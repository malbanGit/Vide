/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx.panels;

import de.malban.config.Configuration;
import de.malban.gui.CSAMainFrame;
import de.malban.vide.vecx.VecXPanel;
import de.malban.gui.Stateable;
import de.malban.gui.Windowable;
import de.malban.gui.components.CSAView;
import de.malban.vide.VideConfig;
import de.malban.vide.dissy.DissiPanel;
import de.malban.vide.dissy.Memory;
import de.malban.vide.dissy.MemoryInformation;
import de.malban.vide.vecx.Updatable;
import static de.malban.vide.dissy.MemoryInformation.MEM_TYPE_ROM;
import java.awt.Color;
import java.awt.Component;
import java.awt.Point;
import java.awt.event.MouseEvent;
import java.io.Serializable;
import java.util.ArrayList;
import javax.swing.JTable;
import javax.swing.table.AbstractTableModel;
import javax.swing.table.DefaultTableCellRenderer;
import de.muntjak.tinylookandfeel.Theme;
import static java.awt.event.ActionEvent.SHIFT_MASK;
import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;
import javax.swing.UIManager;

/**
 *
 * @author malban
 */
public class LabelJPanel extends javax.swing.JPanel implements
        Windowable, Stateable, Updatable{
    private CSAView mParent = null;
    VideConfig config = VideConfig.getConfig();
    public boolean isLoadSettings() { return true; }
    private javax.swing.JMenuItem mParentMenuItem = null;
    private int mClassSetting=0;
    private DissiPanel dissi = null;
    private VecXPanel vecxPanel = null; // needed for vectrex memory access
    public static String SID = "Debug: Labels";
    boolean systemLabels = false;
    
    ArrayList<MemoryInformation> labels = new ArrayList<MemoryInformation>();
    Memory memory = null;
    
    
    public String getID()
    {
        return SID;
    }
    public Serializable getAdditionalStateinfo(){return null;}
    public void setAdditionalStateinfo(Serializable ser){}
    
    public void setVecxy(VecXPanel v)
    {
        vecxPanel = v;
        initLabels();
    }
    public void setDissi(DissiPanel v)
    {
        dissi = v;
        if (dissi == null) return;
        memory = dissi.getMemory();
        initLabels();
    }
    @Override public boolean isIcon()
    {
        CSAMainFrame frame = ((CSAMainFrame)Configuration.getConfiguration().getMainFrame());
        if (frame.getInternalFrame(this) == null) return false;
        return frame.getInternalFrame(this).isIcon();
    }
    @Override public void setIcon(boolean b)
    {
        CSAMainFrame frame = ((CSAMainFrame)Configuration.getConfiguration().getMainFrame());
        if (frame.getInternalFrame(this) == null) return;
        try
        {
            frame.getInternalFrame(this).setIcon(b);
        }
        catch (Throwable e){}
    }

    public void initLabels()
    {
        if (vecxPanel == null) return;
        if (memory == null) return;
        labels = new ArrayList<MemoryInformation>();
        
        int start = 0;
        int end = 0xbfff;
        for (int m = start; m<end; m++)
        {
            MemoryInformation memInfo = memory.memMap.get(m);
            if (memInfo.memType == MEM_TYPE_ROM)
            {
                if (memInfo.labels.size()>0)
                    labels.add(memInfo);
            }
        }
        if (systemLabels)
        {
            start = 0xE000;
            end = 0xFFFF;
            for (int m = start; m<end; m++)
            {
                MemoryInformation memInfo = memory.memMap.get(m);
                if (memInfo.memType == MEM_TYPE_ROM)
                {
                    if (memInfo.labels.size()>0)
                        labels.add(memInfo);
                }
            }
        }
        correctTable();
    }    
    @Override
    public void closing()
    {
        if (vecxPanel != null) vecxPanel.resetLabi();
        deinit();
    }
    @Override
    public void setParentWindow(CSAView jpv)
    {
        mParent = jpv;
    }
    @Override
    public void setMenuItem(javax.swing.JMenuItem item)
    {
        mParentMenuItem = item;
        mParentMenuItem.setText(SID);
    }
    @Override
    public javax.swing.JMenuItem getMenuItem()
    {
        return mParentMenuItem;
    }
    @Override
    public javax.swing.JPanel getPanel()
    {
        return this;
    }
    public void deinit()
    {
        removeUIListerner();
    }
    /**
     * Creates new form LabelJPanel
     */
    public LabelJPanel() {
        initComponents();
        LabelsTableModel model = new LabelsTableModel();
        jTable1.setModel(model);
        
        
        jTable1.setDefaultRenderer(Object.class, new DefaultTableCellRenderer()
        {
            @Override
            public Component getTableCellRendererComponent(JTable table, Object value, boolean isSelected, boolean hasFocus, int row, int col) 
            {
                super.getTableCellRendererComponent(table, value, isSelected, hasFocus, row, col);

                if (table.getModel() instanceof LabelsTableModel)
                {
                    LabelsTableModel model = (LabelsTableModel)table.getModel();

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
        UIManager.addPropertyChangeListener(pListener);
        updateMyUI(); 
        correctTable();    
    }
    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jCheckBox1 = new javax.swing.JCheckBox();
        jToggleButton4 = new javax.swing.JToggleButton();
        jScrollPane1 = new javax.swing.JScrollPane();
        jTable1 = buildTable();

        jCheckBox1.setText("system labels");
        jCheckBox1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox1ActionPerformed(evt);
            }
        });

        jToggleButton4.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/webcam.png"))); // NOI18N
        jToggleButton4.setToolTipText("Toggle Update (always or only while debug)");
        jToggleButton4.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jToggleButton4.setSelectedIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/webcamSelect.png"))); // NOI18N
        jToggleButton4.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jToggleButton4ActionPerformed(evt);
            }
        });

        jTable1.setAutoCreateRowSorter(true);
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
        jTable1.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jTable1MousePressed(evt);
            }
        });
        jScrollPane1.setViewportView(jTable1);

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addComponent(jToggleButton4, javax.swing.GroupLayout.PREFERRED_SIZE, 20, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jCheckBox1)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
            .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 409, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jToggleButton4, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jCheckBox1, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(5, 5, 5)
                .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 262, Short.MAX_VALUE))
        );
    }// </editor-fold>//GEN-END:initComponents

    private void jCheckBox1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox1ActionPerformed
        systemLabels = jCheckBox1.isSelected();
        initLabels();
    }//GEN-LAST:event_jCheckBox1ActionPerformed

    private void jToggleButton4ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jToggleButton4ActionPerformed
        updateEnabled = jToggleButton4.isSelected();
    }//GEN-LAST:event_jToggleButton4ActionPerformed

    private void jTable1MousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jTable1MousePressed
        if (evt.getClickCount() == 2) 
        {
            JTable table =(JTable) evt.getSource();
            Point p = evt.getPoint();
            int row = table.rowAtPoint(p);
            int col = table.columnAtPoint(p);
            LabelsTableModel model = (LabelsTableModel) jTable1.getModel();
            
            
            MemoryInformation memInfo = labels.get(jTable1.convertRowIndexToModel( row ));
            int current = memInfo.address;

            if (((evt.getModifiers() & SHIFT_MASK) == SHIFT_MASK))
            {
                if (vecxPanel != null)
                vecxPanel.setDumpToAddress(current);

            }
            else
            {
                if (dissi != null)
                dissi.goAddress(current,true, true, true);
            }
        }
    }//GEN-LAST:event_jTable1MousePressed


    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JCheckBox jCheckBox1;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JTable jTable1;
    private javax.swing.JToggleButton jToggleButton4;
    // End of variables declaration//GEN-END:variables


    private void update()
    {
        jTable1.repaint();
    }
    public void correctTable()
    {
        jTable1.tableChanged(null);
        
        LabelsTableModel model = (LabelsTableModel)jTable1.getModel();
        
        for (int i=0; i< model.getColumnCount(); i++)
        {
            jTable1.getColumnModel().getColumn(i).setPreferredWidth(model.getColWidth(i));                
        }
    }    
    private boolean updateEnabled = false;
    public void updateValues(boolean forceUpdate)
    {
        if (!forceUpdate)
            if (!updateEnabled) return;
        update();
    }
    public void setUpdateEnabled(boolean b)
    {
        updateEnabled = b;
    }
    JTable buildTable()
    {
        JTable table = new JTable(){

            //Implement table cell tool tips.           
            public String getToolTipText(MouseEvent e) 
            {
                if (vecxPanel==null) return null;
                String tip = "<html>";
                if (jTable1.getModel() instanceof LabelsTableModel)
                {
                    LabelsTableModel model = (LabelsTableModel) jTable1.getModel();
                    java.awt.Point p = e.getPoint();
                    int rowIndex = rowAtPoint(p);
                    int colIndex = columnAtPoint(p);
/*
                    try 
                    {
                        MemoryInformation memInfo = variables.get(rowIndex);
                        int val1 = (vecxPanel.vecx.e6809_readOnly8(memInfo.address)&0xff);
                        int val2 = (vecxPanel.vecx.e6809_readOnly8(memInfo.address)&0xff)*256+(vecxPanel.vecx.e6809_readOnly8(memInfo.address+1)&0xff);
                        if (colIndex == 1) // labels
                        {
                            // show complete labels as tt
                            tip+="<pre>";
                            for (String st: memInfo.labels)
                                tip += st+"\n";
                            tip+="</pre>";
                        }
                        if (colIndex == 2) // 8 bit
                        {
                            tip += "decimal: "+val1+"(unsigned)<BR>";
                            tip += "decimal: "+(val1>128?val1-256:val1)+"(signed)<BR>";
                        }
                        if (colIndex == 3) // 16 bit
                        {
                            tip += "decimal: "+val2+"(unsigned)<BR>";
                            tip += "decimal: "+(val2>32768?val2-65536:val2)+"(signed)<BR>";
                        }
                        if (colIndex == 5) // comments
                        {
                            // show complete comment as tt
                            tip+="<pre>";
                            for (String st: memInfo.comments)
                                tip += st+"\n";
                            tip+="</pre>";
                        }
                    } 
                    catch (RuntimeException e1) 
                    {
                        //catch null pointer exception if mouse is over an empty line
                    }
                    */
                }
                tip += "</html>";
                return tip;
            }
        };       
       return  table;
    }

    
    public class LabelsTableModel extends AbstractTableModel
    {
        public int getRowCount()
        {
            return labels.size();
        }
        public int getColumnCount()
        {
            return 2;
        }
        public Object getValueAt(int row, int col)
        {
            if (vecxPanel == null) return "";

            MemoryInformation memInfo = labels.get(row);
            
            if (col == 0) return"$"+String.format("%04X",memInfo.address);
            if (col == 1)
            {
                String l = "";
                for (int i = 0; i< memInfo.labels.size(); i++)
                {
                    if (i>0) l+=", ";
                    l += memInfo.labels.get(i);
                }
                return l;
            }
            return "";
        }
        public String getColumnName(int column) {
            if (column == 1) return "labels";
            if (column == 0) return "address";
            return "-";
        }
        public Class<?> getColumnClass(int columnIndex) {
            return String.class;
        }
        public boolean isCellEditable(int rowIndex, int columnIndex) {
            return false;
        }
        public int getColWidth(int col)
        {
            if (col == 1) return 200;
            if (col == 0) return 30;
            return 20;
        }
        public Color getBackground(int col)
        {
            if (col == 0) return config.tableAddress;
            return null; // default
        }
        
    }
    public void removeUIListerner()
    {
        UIManager.removePropertyChangeListener(pListener);
    }
    private PropertyChangeListener pListener = new PropertyChangeListener()
    {
        public void propertyChange(PropertyChangeEvent evt)
        {
            updateMyUI();
        }
    };
    void updateMyUI()
    {
        int fontSize = Theme.textFieldFont.getFont().getSize();
        int rowHeight = fontSize+3;
        jTable1.setRowHeight(rowHeight);
    }
    public void deIconified() { }

}
