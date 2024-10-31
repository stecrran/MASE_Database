package com.tus.JDBCProject;

import java.io.FileWriter;
import java.io.IOException;
import javax.swing.*;
import javax.swing.table.TableModel;
import javax.swing.filechooser.FileNameExtensionFilter;
import java.util.ArrayList;
import java.util.List;

public class CSVExport {
    
    public static void generateCSV(JTable table, String defaultFileName) {
        JFileChooser fileChooser = new JFileChooser();
        fileChooser.setDialogTitle("Save CSV");
        fileChooser.setFileFilter(new FileNameExtensionFilter("CSV Files", "csv"));
        fileChooser.setSelectedFile(new java.io.File(defaultFileName));
        
        int userSelection = fileChooser.showSaveDialog(null);

        if (userSelection == JFileChooser.APPROVE_OPTION) {
            String filePath = fileChooser.getSelectedFile().getAbsolutePath();
            if (!filePath.endsWith(".csv")) filePath += ".csv";

            try (FileWriter writer = new FileWriter(filePath)) {
                TableModel model = table.getModel();
                
                // Write header
                for (int col = 0; col < model.getColumnCount(); col++) {
                    writer.append(model.getColumnName(col));
                    if (col < model.getColumnCount() - 1) writer.append(",");
                }
                writer.append("\n");

                // Write rows
                for (int row = 0; row < model.getRowCount(); row++) {
                    for (int col = 0; col < model.getColumnCount(); col++) {
                        writer.append(model.getValueAt(row, col).toString());
                        if (col < model.getColumnCount() - 1) writer.append(",");
                    }
                    writer.append("\n");
                }

                JOptionPane.showMessageDialog(null, "Data exported to " + filePath, "Export Successful", JOptionPane.INFORMATION_MESSAGE);

            } catch (IOException e) {
                JOptionPane.showMessageDialog(null, "Error exporting data: " + e.getMessage(), "Export Error", JOptionPane.ERROR_MESSAGE);
            }
        }
    }
}
