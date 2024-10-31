package com.tus.JDBCProject;

import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;

import javax.swing.*;
import javax.swing.table.TableModel;
import javax.swing.filechooser.FileNameExtensionFilter;
import java.util.ArrayList;
import java.util.List;

public class CSVExport {

	public static void writeToFile(ResultSet rs) {
		JFrame f = new JFrame();
		try {
			String filename = JOptionPane.showInputDialog(null, "Enter File Name");
			if (filename.equals("")) {
				JOptionPane.showMessageDialog(f, "No file created.");
			} else {
				FileWriter outputFile = new FileWriter(filename + ".csv");
				PrintWriter printWriter = new PrintWriter(outputFile);
				ResultSetMetaData rsmd = rs.getMetaData();
				int numColumns = rsmd.getColumnCount();

				for (int i = 0; i < numColumns; i++) {
					printWriter.print(rsmd.getColumnLabel(i + 1) + ",");
				}
				printWriter.print("\n");
				while (rs.next()) {
					for (int i = 0; i < numColumns; i++) {
						printWriter.print(rs.getString(i + 1) + ",");
					}
					printWriter.print("\n");
					printWriter.flush();
				}
				JOptionPane.showMessageDialog(f, "File created: " + filename + ".csv");
				printWriter.close();
			}
		} catch (Exception e) {
			JOptionPane.showMessageDialog(f, "No file created.");
		}
	}
	
}
