package com.tus.JDBCProject;

import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import javax.swing.border.*;
import javax.swing.text.NumberFormatter;
import java.sql.*;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@SuppressWarnings("serial")
public class JDBCMainWindowContent extends JInternalFrame implements ActionListener {
	// DB Connectivity Attributes
	private Connection con = null;
	private Statement stmt = null;
	private CallableStatement call_stmt = null;
	private ResultSet rs = null;
	private PreparedStatement ps = null;

	private Container content;
	private JPanel detailsPanel;
	private JPanel exportPanel;
	private JScrollPane dbContentsPanel;
	private Border lineBorder;

	// Labels
	private JLabel patientIDLabel = new JLabel("Patient ID:");
	private JLabel recordIDLabel = new JLabel("Record ID:");
	private JLabel glucoseLabel = new JLabel("Blood Glucose:");
	private JLabel diasBPLabel = new JLabel("Diastolic BP:");
	private JLabel sysBPLabel = new JLabel("Systolic BP:");
	private JLabel heartLabel = new JLabel("Heart Rate:");
	private JLabel bodyTempLabel = new JLabel("Body Temp:");
	private JLabel spO2Label = new JLabel("SpO2:");
	private JLabel sweatingLabel = new JLabel("Sweating:");
	private JLabel shiverLabel = new JLabel("Shivering:");
	private JLabel diabeticLabel = new JLabel("Diabetic / Non-Diabetic:");

	// Text Fields
	private JTextField patientIDTF = new JTextField(10);
	private JTextField recordIDTF = new JTextField(10);
	private JTextField glucoseIDTF = new JTextField(3);
	private JTextField diasBPIDTF = new JTextField(3);
	private JTextField sysBPIDTF = new JTextField(3);
	private JTextField heartIDTF = new JTextField(3);
	private JTextField spO2IDTF = new JTextField(3);
	private JTextField sweatingIDTF = new JTextField(3);
	private JTextField shiverIDTF = new JTextField(3);
	private JTextField diabeticIDTF = new JTextField(1);

	// Decimal input for body temperature
	private JFormattedTextField bodyTempIDTF;

	// Table model and content display
	private static QueryTableModel TableModel = new QueryTableModel();
	private JTable TableofDBContents = new JTable(TableModel);

	// Buttons
	private JButton updateButton = new JButton("Update");
	private JButton insertButton = new JButton("Insert");
	private JButton deleteButton = new JButton("Delete");
	private JButton clearButton = new JButton("Clear");
	// Exit
	private JButton exitButton = new JButton("Exit");
	// Export buttons
	private JButton exportButton = new JButton("All Data");
	private JButton diabeticButton = new JButton("Diabetic Patients");
	private JButton nonDiabeticButton = new JButton("Non-Diabetic Patients");
	private JButton recommendBPButton = new JButton("BP >140/90");
	private JButton glucoseNormalButton = new JButton("Glucose <100");
	private JButton glucoseHighButton = new JButton("Glucose >200");
	private JButton lowSpO2Button = new JButton("SpO₂ <96%");
	private JButton showIfLowSugar = new JButton("Check: Low Sugar");


	public JDBCMainWindowContent(String aTitle) {
		super(aTitle, false, false, false, false);
		setEnabled(true);

		// Database connection
		initiate_db_conn();

		// Content pane
		content = getContentPane();
		content.setLayout(new BorderLayout());
		content.setBackground(Color.lightGray);
		lineBorder = BorderFactory.createEtchedBorder(15, Color.green, Color.black);

		// decimal formatter for body temperature field
		DecimalFormat decimalFormat = new DecimalFormat("#0.0#");
		NumberFormatter decimalFormatter = new NumberFormatter(decimalFormat);
		decimalFormatter.setValueClass(Double.class);
		decimalFormatter.setAllowsInvalid(false);
		decimalFormatter.setMinimum(0.0);
		decimalFormatter.setMaximum(200.0);
		bodyTempIDTF = new JFormattedTextField(decimalFormatter);
		bodyTempIDTF.setColumns(4);

		// Set up details (JPanel) with GridBagLayout
		// Reference: https://docs.oracle.com/javase/8/docs/api/index.html?java/awt/GridBagLayout.html,
		// https://www.javatpoint.com/java-gridbaglayout,
		// https://docs.oracle.com/javase/tutorial/uiswing/layout/gridbag.html
		detailsPanel = new JPanel(new GridBagLayout());
		detailsPanel.setBackground(Color.lightGray);
		detailsPanel.setBorder(BorderFactory.createTitledBorder(lineBorder, "Data Fields"));
		GridBagConstraints gbc = new GridBagConstraints();
		gbc.insets = new Insets(5, 5, 5, 5); // padding
		gbc.anchor = GridBagConstraints.NORTHWEST; // top-left align
		gbc.fill = GridBagConstraints.HORIZONTAL; // fill horizontally

		// adding fields to medical details panel
		// labelPosition(GridBagConstraints gbc, JPanel panel, int gridx, int gridy, JLabel label)
		// textFieldPosition(GridBagConstraints gbc, JPanel panel, int gridx, int gridy, JTextField tf)
		labelPosition(gbc, detailsPanel, 0, 0, patientIDLabel);
		textFieldPosition(gbc, detailsPanel, 1, 0, patientIDTF);
		labelPosition(gbc, detailsPanel, 0, 1, recordIDLabel);
		textFieldPosition(gbc, detailsPanel, 1, 1, recordIDTF);
		labelPosition(gbc, detailsPanel, 0, 2, glucoseLabel);
		textFieldPosition(gbc, detailsPanel, 1, 2, glucoseIDTF);
		labelPosition(gbc, detailsPanel, 0, 3, diasBPLabel);
		textFieldPosition(gbc, detailsPanel, 1, 3, diasBPIDTF);
		labelPosition(gbc, detailsPanel, 0, 4, sysBPLabel);
		textFieldPosition(gbc, detailsPanel, 1, 4, sysBPIDTF);
		labelPosition(gbc, detailsPanel, 0, 5, heartLabel);
		textFieldPosition(gbc, detailsPanel, 1, 5, heartIDTF);
		labelPosition(gbc, detailsPanel, 0, 6, bodyTempLabel);
		textFieldPosition(gbc, detailsPanel, 1, 6, bodyTempIDTF);
		labelPosition(gbc, detailsPanel, 0, 7, spO2Label);
		textFieldPosition(gbc, detailsPanel, 1, 7, spO2IDTF);
		labelPosition(gbc, detailsPanel, 0, 8, sweatingLabel);
		textFieldPosition(gbc, detailsPanel, 1, 8, sweatingIDTF);
		labelPosition(gbc, detailsPanel, 0, 9, shiverLabel);
		textFieldPosition(gbc, detailsPanel, 1, 9, shiverIDTF);
		labelPosition(gbc, detailsPanel, 0, 10, diabeticLabel);
		textFieldPosition(gbc, detailsPanel, 1, 10, diabeticIDTF);
		
		//buttonPosition(GridBagConstraints gbc, JPanel panel, int gridx, int gridy, JButton button)
		buttonPosition(gbc, detailsPanel, 0, 11, insertButton);
		buttonPosition(gbc, detailsPanel, 1, 11, deleteButton);
		buttonPosition(gbc, detailsPanel, 0, 12, updateButton);
		buttonPosition(gbc, detailsPanel, 1, 12, clearButton);
	
		content.add(detailsPanel, BorderLayout.WEST);
		
		exportPanel = new JPanel(new GridBagLayout());
		exportPanel.setBackground(Color.lightGray);
		exportPanel.setBorder(BorderFactory.createTitledBorder(lineBorder, "Export Data"));
		
		GridBagConstraints gbcExp = new GridBagConstraints();
		gbcExp.insets = new Insets(5, 5, 5, 5); // padding

		buttonPosition(gbcExp, exportPanel, 0, 0, exportButton);
		buttonPosition(gbcExp, exportPanel, 1, 0, diabeticButton);
		buttonPosition(gbcExp, exportPanel, 2, 0, nonDiabeticButton);
		buttonPosition(gbcExp, exportPanel, 3, 0, recommendBPButton);
		buttonPosition(gbcExp, exportPanel, 4, 0, glucoseNormalButton);
		buttonPosition(gbcExp, exportPanel, 5, 0, glucoseHighButton);
		buttonPosition(gbcExp, exportPanel, 6, 0, lowSpO2Button);
		buttonPosition(gbcExp, exportPanel, 7, 0, showIfLowSugar);

		// Create a panel for the exit button
		JPanel buttonsPanelExit = new JPanel(new FlowLayout(FlowLayout.CENTER));
		buttonsPanelExit.add(exitButton);

		// Create a container panel to hold both exportPanel and buttonsPanelExit
		JPanel bottomPanel = new JPanel(new BorderLayout());
		bottomPanel.add(exportPanel, BorderLayout.NORTH);
		bottomPanel.add(buttonsPanelExit, BorderLayout.SOUTH);

		// Add the combined bottom panel to the main content area
		content.add(bottomPanel, BorderLayout.SOUTH);

		// Add action listeners
		insertButton.addActionListener(this);
		updateButton.addActionListener(this);
		exportButton.addActionListener(this);
		deleteButton.addActionListener(this);
		clearButton.addActionListener(this);
		exitButton.addActionListener(this);
		diabeticButton.addActionListener(this);
		nonDiabeticButton.addActionListener(this);
		recommendBPButton.addActionListener(this);
		glucoseNormalButton.addActionListener(this);
		glucoseHighButton.addActionListener(this);
		lowSpO2Button.addActionListener(this);
		showIfLowSugar.addActionListener(this);

		// Table panel for displaying database contents
		TableofDBContents.setPreferredScrollableViewportSize(new Dimension(700, 300));
		dbContentsPanel = new JScrollPane(TableofDBContents);
		dbContentsPanel.setBackground(Color.lightGray);
		dbContentsPanel.setBorder(BorderFactory.createTitledBorder(lineBorder, "Database Content"));
		content.add(dbContentsPanel, BorderLayout.CENTER);

		setSize(982, 645);
		setVisible(true);

		TableModel.refreshFromDB(stmt);
	}
	
	public void buttonPosition(GridBagConstraints gbc, JPanel panel, int gridx, int gridy, JButton button) {
		gbc.gridx = gridx;
		gbc.gridy = gridy;
		panel.add(button, gbc);
	}
	
	public void labelPosition(GridBagConstraints gbc, JPanel panel, int gridx, int gridy, JLabel label) {
		gbc.gridx = gridx;
		gbc.gridy = gridy;
		panel.add(label, gbc);
	}
	
	public void textFieldPosition(GridBagConstraints gbc, JPanel panel, int gridx, int gridy, JTextField tf) {
		gbc.gridx = gridx;
		gbc.gridy = gridy;
		panel.add(tf, gbc);
	}

	public void initiate_db_conn() {
		try {
			Class.forName("com.mysql.jdbc.Driver");
			String url = "jdbc:mysql://localhost:3306/diabetes";
			con = DriverManager.getConnection(url, "root", "root");
			stmt = con.createStatement();
		} catch (Exception e) {
			System.out.println("Error: Failed to connect to database\n" + e.getMessage());
		}
	}
	

	public void actionPerformed(ActionEvent e) {
		Object target = e.getSource();
		if (target == clearButton) {
			patientIDTF.setText("");
			recordIDTF.setText("");
			glucoseIDTF.setText("");
			diasBPIDTF.setText("");
			sysBPIDTF.setText("");
			heartIDTF.setText("");
			bodyTempIDTF.setValue(null);
			spO2IDTF.setText("");
			sweatingIDTF.setText("");
			shiverIDTF.setText("");
			diabeticIDTF.setText("");
		}

		if (target == insertButton) {
			try {
				String updateTemp = "INSERT INTO medicalrecords (PatientID, RecordID, BloodGlucose, Diastolic_BloodPressure, "
						+ "Systolic_BloodPressure, HeartRate, BodyTemp, SpO2, Sweating, Shivering, Diabetic_NonDiabetic) VALUES ('"
						+ patientIDTF.getText() + "', '" + recordIDTF.getText() + "', '" + glucoseIDTF.getText()
						+ "', '" + diasBPIDTF.getText() + "', '" + sysBPIDTF.getText() + "', '" + heartIDTF.getText()
						+ "', '" + bodyTempIDTF.getText() + "', '" + spO2IDTF.getText() + "', '"
						+ sweatingIDTF.getText() + "', '" + shiverIDTF.getText() + "', '" + diabeticIDTF.getText()
						+ "');";
				stmt.executeUpdate(updateTemp);
			} catch (SQLException sqle) {
				System.err.println("Error with insert:\n" + sqle.toString());
			} finally {
				TableModel.refreshFromDB(stmt);
			}
		}
		
		if (target == deleteButton) {
			try {
				String updateTemp = "DELETE FROM medicalrecords where RecordID = " + recordIDTF.getText() + ";";
				stmt.executeUpdate(updateTemp);
			} catch (SQLException sqle) {
				System.err.println("Error with delete:\n" + sqle.toString());
			} finally {
				TableModel.refreshFromDB(stmt);
			}
		}

		if (target == exportButton) {
				String cmd = "SELECT * FROM diabetes.medicalrecords;";
				writeResult(rs, cmd);
		}
		
		if (target == nonDiabeticButton) {
				String cmd = "SELECT medicalrecords.PatientID, patient.age, medicalrecords.BloodGlucose, concat(medicalrecords.Systolic_BloodPressure, '/', "
						+ "medicalrecords.Diastolic_BloodPressure) as BP_Reading FROM diabetes.medicalrecords inner join diabetes.patient \r\n"
						+ "on medicalrecords.PatientID = patient.PatientID where Diabetic_NonDiabetic = 'N' order by age DESC;";
				writeResult(rs, cmd);
		}
		
		if (target == diabeticButton) {
				String cmd = "SELECT medicalrecords.PatientID, patient.age, medicalrecords.BloodGlucose, concat(medicalrecords.Systolic_BloodPressure, '/', "
						+ "medicalrecords.Diastolic_BloodPressure) as BP_Reading FROM diabetes.medicalrecords inner join diabetes.patient \r\n"
						+ "on medicalrecords.PatientID = patient.PatientID where Diabetic_NonDiabetic = 'D' order by age DESC;";
				writeResult(rs, cmd);
		}
		
		if (target == recommendBPButton) {
				String cmd = "SELECT medicalrecords.PatientID, patient.age, medicalrecords.HeartRate, medicalrecords.SpO2, concat(medicalrecords.Systolic_BloodPressure, '/', "
						+ "medicalrecords.Diastolic_BloodPressure) as BP_Reading, medicalrecords.Diabetic_NonDiabetic FROM diabetes.medicalrecords inner join diabetes.patient \r\n"
						+ "on medicalrecords.PatientID = patient.PatientID where Diastolic_BloodPressure > 90 and Systolic_BloodPressure > 140 ORDER BY age ASC;";
				writeResult(rs, cmd);
		}
		
		if (target == glucoseNormalButton) {
			String cmd = "SELECT * FROM diabetes.medicalrecords where BloodGlucose < 100;";
			writeResult(rs, cmd);
		}
		
		if (target == glucoseHighButton) {
			String cmd = "SELECT * FROM diabetes.medicalrecords where BloodGlucose > 200;";
			writeResult(rs, cmd);
		}
		
		if (target == lowSpO2Button) {
			String cmd = "select medicalrecords.PatientID, patient.age, medicalrecords.SpO2 as Sp02_pc, medicalrecords.HeartRate, "
					+ "medicalrecords.BodyTemp from medicalrecords inner join diabetes.patient \r\n"
					+ "on medicalrecords.PatientID = patient.PatientID where SpO2 < 96 order by SpO2 ASC;";
			writeResult(rs, cmd);
		}
		
		if (target == showIfLowSugar) {
			JFrame f = new JFrame();
			// based on numRecForCellButton in JDBC example but using CallableStatement 
			try {
				String sql = "{CALL diabetes.lowSugarCheck(?)}";
				call_stmt = con.prepareCall(sql);

				String patientID = patientIDTF.getText();
				Integer testPatient = null;
				if (!patientID.isEmpty()) {
					testPatient = Integer.parseInt(patientID);
				}

				if (testPatient != null) {
					call_stmt.setInt(1, testPatient);
				} else {
					call_stmt.setNull(1, Types.INTEGER);
				}
				call_stmt.execute();
				// I only want a single value, so display only. No export required for one value.
				rs = call_stmt.getResultSet();
				if (rs != null && rs.next()) {
					if (isInteger(rs.getString(1))) {
					JOptionPane.showMessageDialog(f, "Blood sugar for Patient #" + patientID + " is " + rs.getString(1));
					}
					else {
						JOptionPane.showMessageDialog(f, rs.getString(1));
					}
				}
		
			} catch (Exception e1) {
				e1.printStackTrace();
			}
		}
		
		if (target == exitButton) {
			// https://www.youtube.com/watch?v=TFBRiICqLeg
			int confirm = JOptionPane.showConfirmDialog(this, "Are you sure you want to exit?", "Confirm Exit",
					JOptionPane.YES_NO_OPTION);
			if (confirm == JOptionPane.YES_OPTION) {
				System.exit(0); // terminate JVM
			}
		}
	}
	
	public void writeResult(ResultSet rs, String cmd) {
		try {
			rs = stmt.executeQuery(cmd);
			CSVExport.writeToFile(rs);
		} catch (Exception exception) {
			exception.printStackTrace();
		}
	}
	
	public boolean isInteger(String output) {
	    if (output == null || output.isEmpty()) {
	        return false;
	    }
	    try {
	        Integer.parseInt(output);
	        return true;
	    } catch (NumberFormatException e) {
	        return false;
	    }
	}

	
}
