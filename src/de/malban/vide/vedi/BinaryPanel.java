/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vedi;

import de.malban.config.Configuration;
import de.malban.config.TinyLogInterface;
import de.malban.gui.panels.LogPanel;
import static de.malban.gui.panels.LogPanel.WARN;
import java.awt.Color;
import java.awt.Component;
import java.awt.Rectangle;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import javax.swing.JTable;
import javax.swing.JViewport;
import javax.swing.table.AbstractTableModel;
import javax.swing.table.DefaultTableCellRenderer;

/**
 *
 * @author malban
 */
public class BinaryPanel extends javax.swing.JPanel {
    LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
    private javax.swing.JMenuItem mParentMenuItem = null;
    private int mClassSetting=0;
    TinyLogInterface tinyLog = null;
    private String filename = "";
    boolean initError = false;
    byte[] data;        
    
    VediPanel parent;
    public void setParent(VediPanel p)
    {
        parent = p;
    }
    
    private void update()
    {
        jTable1.repaint();
    }
    public void correctTable()
    {
        jTable1.tableChanged(null);
        
        MemoryDumpTableModel model = (MemoryDumpTableModel)jTable1.getModel();
        
        for (int i=0; i< model.getColumnCount(); i++)
        {
            jTable1.getColumnModel().getColumn(i).setPreferredWidth(model.getColWidth(i));                
        }
    }

    public class MemoryDumpTableModel extends AbstractTableModel
    {
        public int getRowCount()
        {
            return data.length/16;
        }
        public int getColumnCount()
        {
            return 18;
        }
        public Object getValueAt(int row, int col)
        {
            if (col == 0)
                return"$"+String.format("%04X",getAddress( row,  col)+1) ;
            if (col == 17)
                return asciiDump(row);
            return "$"+String.format("%02X", data[getAddress( row,  col)]);
        }
        public int getAddress(int row, int col)
        {
            return row *16 + (col-1);
        }
        public String getColumnName(int column) {
            if (column == 0) return "Address";
            if (column == 17) return "Chars";
            return "$"+String.format("%02X",(column&0xff)-1);
        }
        public Class<?> getColumnClass(int columnIndex) {
            return String.class;
        }
        public boolean isCellEditable(int rowIndex, int columnIndex) {
            return false;
        }
        public int getColWidth(int col)
        {
            if (col == 0) return 40;
            if (col == 17) return 120;
            return 20;
        }
        public Color getBackground(int col)
        {
            if (col == 0) return new Color(200,255,200,255);
            return null; // default
        }
        
    }
    public void deinit()
    {
    }
    /**
     * Creates new form MemoryDumpPanel
     */
    public BinaryPanel() {
        initComponents();
        setup();

    }

    protected boolean isInitError()
    {
        return initError;
    }
    public BinaryPanel(String fn, TinyLogInterface tl)
    {
        initComponents();
        filename = fn;
        try
        {
            setup();
        }
        catch (Throwable e)
        {
            initError = true;
        }
        if (initError)
        {
            deinit();
        }        
    }
    
    public void setup()
    {
        Path path = Paths.get(filename);
        try
        {
            data = Files.readAllBytes(path);        
        }
        catch (Throwable e)
        {
            log.addLog(e, WARN);
        }
        if (data == null)
        {
            data = new byte[0];
            return;
        }
        MemoryDumpTableModel model = new MemoryDumpTableModel();
        jTable1.setModel(model);
        jTable1.setDefaultRenderer(Object.class, new DefaultTableCellRenderer()
        {
            @Override
            public Component getTableCellRendererComponent(JTable table, Object value, boolean isSelected, boolean hasFocus, int row, int col) 
            {
                super.getTableCellRendererComponent(table, value, isSelected, hasFocus, row, col);

                if (table.getModel() instanceof MemoryDumpTableModel)
                {
                    MemoryDumpTableModel model = (MemoryDumpTableModel)table.getModel();

                    if (isSelected)
                    {
                        setBackground(table.getSelectionBackground());
                        setForeground(table.getSelectionForeground());
                    }
                    else
                    {
                        Color back = model.getBackground(col);
                        if (back != null)
                            setBackground(back);
                        else
                            setBackground(table.getBackground());
                        setForeground(table.getForeground());
                    }
                }
                return this;
            }   
        });       
        correctTable();
    }
    JTable buildTable()
    {
        JTable table = new JTable();       
       return  table;
    }
    
    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jScrollPane1 = new javax.swing.JScrollPane();
        jTable1 = buildTable();

        jTable1.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTable1.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null}
            },
            new String [] {
                "Title 1", "Title 2", "Title 3", "Title 4"
            }
        ));
        jTable1.setShowHorizontalLines(false);
        jTable1.setShowVerticalLines(false);
        jScrollPane1.setViewportView(jTable1);

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 742, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jScrollPane1, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, 522, Short.MAX_VALUE)
        );
    }// </editor-fold>//GEN-END:initComponents


    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JTable jTable1;
    // End of variables declaration//GEN-END:variables
   
    public void goAddress(int address)
    {
        // select line in table and jump to display that!
        int row = address/16;
        if (row == -1 ) return;
        // select
        jTable1.setRowSelectionInterval(row, row);
        scrollToVisible(jTable1, row,0) ;
        // and jump there!
       // jTableSource.scrollRectToVisible(jTableSource.getCellRect(row, 0, true));
    }
    public static void scrollToVisible(JTable table, int rowIndex, int vColIndex) 
    {
        // down
        JViewport vp = (JViewport)table.getParent();
        int bottomIndex = table.getModel().getRowCount()-1;
        table.setRowSelectionInterval(bottomIndex, bottomIndex);
        table.changeSelection(bottomIndex,0,false,false);
        Rectangle r = table.getCellRect(bottomIndex-1, 0, true);
        int vph = vp.getExtentSize().height;
        r.y += vph;
        table.scrollRectToVisible(r);

        
        // and UP!
        int currentSelectedRow = table.getSelectedRow();
        
        try{
          table.changeSelection(rowIndex,0,false,false);
          if(rowIndex > currentSelectedRow)
          {
            r = table.getCellRect(rowIndex-1, 0, true);
            vph = vp.getExtentSize().height;
            r.y += vph;
            table.scrollRectToVisible(r);
          }
        }catch(Exception e){/*error message*/}

    
    }
    String asciiDump(int row)
    {
        String dump = "";
        for (int i=0;i<16; i++)
        {
            int v = data[( row*16+i)] &0xff;
            if (v<0x20) dump+=".";
            else if (v<127) dump+=(char)v;
            else dump += "~";
        }
        return dump;
    }

    private boolean updateEnabled = false;
    public void updateValues(boolean forceUpdate)
    {
        if (!forceUpdate) if (!updateEnabled) return;
        update();
    }
    public void setUpdateEnabled(boolean b)
    {
        updateEnabled = b;
    }
    
}

