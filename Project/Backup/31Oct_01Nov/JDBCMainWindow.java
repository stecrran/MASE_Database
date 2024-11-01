package com.tus.JDBCProject;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.JFrame;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;

public class JDBCMainWindow extends JFrame {
	

	public JDBCMainWindow() {
		// sets window title
		super("Diabetes Characteristic");

		// Create an instance of our class JDBCMainWindowContent
		JDBCMainWindowContent medicalContent = new JDBCMainWindowContent("Medical Data");
		// Add the instance to the main section of the window
		getContentPane().add(medicalContent);

		setSize(1200, 600);
		setVisible(true);
	}


}
