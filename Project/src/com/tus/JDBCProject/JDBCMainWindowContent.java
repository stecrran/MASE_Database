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
	private ResultSet rs = null;

	private Container content;
	private JPanel detailsPanel;
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
	private JButton exportButton = new JButton("Export");
	private JButton deleteButton = new JButton("Delete");
	private JButton clearButton = new JButton("Clear");
	private JButton exitButton = new JButton("Exit");

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

		// Initialize decimal formatter for body temperature field
		DecimalFormat decimalFormat = new DecimalFormat("#0.0#");
		NumberFormatter decimalFormatter = new NumberFormatter(decimalFormat);
		decimalFormatter.setValueClass(Double.class);
		decimalFormatter.setAllowsInvalid(false);
		decimalFormatter.setMinimum(0.0);
		decimalFormatter.setMaximum(200.0);
		bodyTempIDTF = new JFormattedTextField(decimalFormatter);
		bodyTempIDTF.setColumns(4);

		// Set up details panel with GridBagLayout
		detailsPanel = new JPanel(new GridBagLayout());
		detailsPanel.setBackground(Color.lightGray);
		detailsPanel.setBorder(BorderFactory.createTitledBorder(lineBorder, "Data Fields"));
		GridBagConstraints gbc = new GridBagConstraints();
		gbc.insets = new Insets(5, 5, 5, 5); // Spacing around components
		gbc.anchor = GridBagConstraints.NORTHWEST; // Top-left alignment
		gbc.fill = GridBagConstraints.HORIZONTAL; // Stretch horizontally

		// Adding all components to details panel
		addLabelAndField(detailsPanel, patientIDLabel, patientIDTF, gbc, 0);
		addLabelAndField(detailsPanel, recordIDLabel, recordIDTF, gbc, 1);
		addLabelAndField(detailsPanel, glucoseLabel, glucoseIDTF, gbc, 2);
		addLabelAndField(detailsPanel, diasBPLabel, diasBPIDTF, gbc, 3);
		addLabelAndField(detailsPanel, sysBPLabel, sysBPIDTF, gbc, 4);
		addLabelAndField(detailsPanel, heartLabel, heartIDTF, gbc, 5);
		addLabelAndField(detailsPanel, bodyTempLabel, bodyTempIDTF, gbc, 6);
		addLabelAndField(detailsPanel, spO2Label, spO2IDTF, gbc, 7);
		addLabelAndField(detailsPanel, sweatingLabel, sweatingIDTF, gbc, 8);
		addLabelAndField(detailsPanel, shiverLabel, shiverIDTF, gbc, 9);
		addLabelAndField(detailsPanel, diabeticLabel, diabeticIDTF, gbc, 10);

		content.add(detailsPanel, BorderLayout.WEST);

		// Set up buttons panel
		JPanel buttonsPanel = new JPanel(new GridLayout(6, 1, 6, 6));
		buttonsPanel.add(insertButton);
		buttonsPanel.add(updateButton);
		buttonsPanel.add(deleteButton);
		buttonsPanel.add(exportButton);
		buttonsPanel.add(clearButton);
		buttonsPanel.add(exitButton);

		// Add action listeners
		insertButton.addActionListener(this);
		updateButton.addActionListener(this);
		exportButton.addActionListener(this);
		deleteButton.addActionListener(this);
		clearButton.addActionListener(this);
		exitButton.addActionListener(this);

		content.add(buttonsPanel, BorderLayout.EAST);

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

	private void addLabelAndField(JPanel panel, JLabel label, JComponent field, GridBagConstraints gbc, int row) {
		gbc.gridx = 0;
		gbc.gridy = row;
		panel.add(label, gbc);

		gbc.gridx = 1;
		panel.add(field, gbc);
	}

	public void initiate_db_conn() {
		try {
			Class.forName("com.mysql.jdbc.Driver");
			String url = "jdbc:mysql://localhost:3306/diabetes";
			con = DriverManager.getConnection(url, "root", "goop");
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
	        if (target == exportButton) {
	            CSVExport.generateCSV(TableofDBContents, "diabetes_data.csv");
	        }
	    }
	    if (target == exitButton) {
	        int confirm = JOptionPane.showConfirmDialog(this, "Are you sure you want to exit?", "Confirm Exit", JOptionPane.YES_NO_OPTION);
	        if (confirm == JOptionPane.YES_OPTION) {
	            System.exit(0); // Terminates the program
	        }
	    }
	}
}
