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
import de.malban.vide.dissy.DASM6809;
import de.malban.vide.dissy.DissiPanel;
import de.malban.vide.dissy.Memory;
import de.malban.vide.dissy.MemoryInformation;
import de.malban.vide.vecx.Updatable;
import static de.malban.vide.dissy.MemoryInformation.MEM_TYPE_RAM;
import de.malban.vide.vecx.Breakpoint;
import java.awt.Color;
import java.awt.Component;
import java.awt.Point;
import java.awt.event.MouseEvent;
import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import javax.swing.JTable;
import javax.swing.SwingUtilities;
import de.muntjak.tinylookandfeel.Theme;
import static java.awt.event.ActionEvent.SHIFT_MASK;
import java.util.List;
import javax.swing.RowSorter;
import javax.swing.SortOrder;
import javax.swing.UIManager;
import javax.swing.table.AbstractTableModel;
import javax.swing.table.DefaultTableCellRenderer;
import javax.swing.table.TableModel;
import javax.swing.table.TableRowSorter;

/**
 *
 * @author malban
 */
public class VarJPanel extends javax.swing.JPanel implements
        Windowable, Stateable, Updatable{
    public boolean isLoadSettings() { return true; }
    private CSAView mParent = null;
    private javax.swing.JMenuItem mParentMenuItem = null;
    private int mClassSetting=0;
    private DissiPanel dissi = null;
    private VecXPanel vecxPanel = null; // needed for vectrex memory access
    public static String SID = "vari";
    ArrayList<MemoryInformation> variables = new ArrayList<MemoryInformation>();
    Memory memory = null;
    boolean onlyUserRam = false;
    public String getID()
    {
        return SID;
    }
    public Serializable getAdditionalStateinfo(){return null;}
    public void setAdditionalStateinfo(Serializable ser){}
    
    public void setVecxy(VecXPanel v)
    {
        vecxPanel = v;
        initVariables();
    }
    public void setDissi(DissiPanel v)
    {
        dissi = v;
        if (dissi == null) return;
        memory = dissi.getMemory();
        initVariables();
    }
    
    void initVariables()
    {
        if (vecxPanel == null) return;
        if (memory == null) return;
        variables = new ArrayList<MemoryInformation>();
        
        int start = 0;
        int end = 65536;
        if (onlyUserRam)
        {
            start = 0xc880;
            end = 0xcbff;
        }
        for (int m = start; m<end; m++)
        {
            MemoryInformation memInfo = memory.memMap.get(m);
            if (memInfo.memType == MEM_TYPE_RAM)
            {
                if (memInfo.labels.size()>0)
                    variables.add(memInfo);
            }
        }
        correctTable();
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
    
    @Override
    public void closing()
    {
        if (vecxPanel != null) vecxPanel.resetVari();
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
        mParentMenuItem.setText("Variables");
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
     * Creates new form VaJPanel
     */
    public VarJPanel() {
        initComponents();
        VariablesTableModel model = new VariablesTableModel();
        jTable1.setModel(model);
        

TableRowSorter<TableModel> sorter = new TableRowSorter<TableModel>(jTable1.getModel());
jTable1.setRowSorter(sorter);

List<RowSorter.SortKey> sortKeys = new ArrayList<>(2);
sortKeys.add(new RowSorter.SortKey(1, SortOrder.ASCENDING));
sortKeys.add(new RowSorter.SortKey(0, SortOrder.ASCENDING));
sorter.setSortKeys(sortKeys);        

        
        jTable1.setDefaultRenderer(Object.class, new DefaultTableCellRenderer()
        {
            @Override
            public Component getTableCellRendererComponent(JTable table, Object value, boolean isSelected, boolean hasFocus, int row, int col) 
            {
                super.getTableCellRendererComponent(table, value, isSelected, hasFocus, row, col);

                if (table.getModel() instanceof VariablesTableModel)
                {
                    VariablesTableModel model = (VariablesTableModel)table.getModel();

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
    private void update()
    {
        jTable1.repaint();
    }
    public void correctTable()
    {
        jTable1.tableChanged(null);
        
        VariablesTableModel model = (VariablesTableModel)jTable1.getModel();
        
        for (int i=0; i< model.getColumnCount(); i++)
        {
            jTable1.getColumnModel().getColumn(i).setPreferredWidth(model.getColWidth(i));                
        }
    }

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jPopupMenu1 = new javax.swing.JPopupMenu();
        jMenuItemBreakpointRead = new javax.swing.JMenuItem();
        jMenuItemBreakpointWrite = new javax.swing.JMenuItem();
        jMenuItemBreakpointValue = new javax.swing.JMenuItem();
        jSeparator1 = new javax.swing.JPopupMenu.Separator();
        jMenuItem1 = new javax.swing.JMenuItem();
        jToggleButton4 = new javax.swing.JToggleButton();
        jScrollPane1 = new javax.swing.JScrollPane();
        jTable1 = buildTable();
        jCheckBox1 = new javax.swing.JCheckBox();
        jButtonAddVariable = new javax.swing.JButton();

        jMenuItemBreakpointRead.setText("add Breakpoint read");
        jMenuItemBreakpointRead.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemBreakpointReadActionPerformed(evt);
            }
        });
        jPopupMenu1.add(jMenuItemBreakpointRead);

        jMenuItemBreakpointWrite.setText("add breakpoint write");
        jMenuItemBreakpointWrite.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemBreakpointWriteActionPerformed(evt);
            }
        });
        jPopupMenu1.add(jMenuItemBreakpointWrite);

        jMenuItemBreakpointValue.setText("add breakpoint value");
        jMenuItemBreakpointValue.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemBreakpointValueActionPerformed(evt);
            }
        });
        jPopupMenu1.add(jMenuItemBreakpointValue);
        jPopupMenu1.add(jSeparator1);

        jMenuItem1.setText("use label as data");
        jMenuItem1.setToolTipText("marking the label as data enables dissi to load that address to a X,Y,U,S,D register as immediate value, also removed previous labels");
        jMenuItem1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem1ActionPerformed(evt);
            }
        });
        jPopupMenu1.add(jMenuItem1);

        jToggleButton4.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/webcam.png"))); // NOI18N
        jToggleButton4.setToolTipText("Toggle Update (always or only while debug)");
        jToggleButton4.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jToggleButton4.setSelectedIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/webcamSelect.png"))); // NOI18N
        jToggleButton4.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jToggleButton4ActionPerformed(evt);
            }
        });

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

        jCheckBox1.setText("only user RAM (from $c880)");
        jCheckBox1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox1ActionPerformed(evt);
            }
        });

        jButtonAddVariable.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/add.png"))); // NOI18N
        jButtonAddVariable.setToolTipText("add new \"named\" variable (location)");
        jButtonAddVariable.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonAddVariable.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonAddVariableActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addComponent(jToggleButton4, javax.swing.GroupLayout.PREFERRED_SIZE, 20, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(18, 18, 18)
                .addComponent(jCheckBox1)
                .addGap(27, 27, 27)
                .addComponent(jButtonAddVariable)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
            .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 435, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jToggleButton4, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jCheckBox1, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButtonAddVariable, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(5, 5, 5)
                .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 309, Short.MAX_VALUE))
        );
    }// </editor-fold>//GEN-END:initComponents

    private void jCheckBox1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox1ActionPerformed
        onlyUserRam = jCheckBox1.isSelected();
        initVariables();
    }//GEN-LAST:event_jCheckBox1ActionPerformed

    private void jToggleButton4ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jToggleButton4ActionPerformed
        updateEnabled = jToggleButton4.isSelected();
    }//GEN-LAST:event_jToggleButton4ActionPerformed

    int popUpAddress = -1;
    String popUpName = "";
    private void jTable1MousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jTable1MousePressed
        if (evt.getButton() == MouseEvent.BUTTON3)
        {
            JTable table =(JTable) evt.getSource();
            Point p = evt.getPoint();
            int row = table.rowAtPoint(p);
            Object o =  table.getModel().getValueAt( row,  0);
            if (o==null) return;
            popUpAddress = DASM6809.toNumber(o.toString());
            popUpName = (String ) table.getModel().getValueAt(row, 1);
            jPopupMenu1.show(jTable1, evt.getX()-20,evt.getY()-20);
        }        
        if (evt.getClickCount() == 2) 
        {
            if ((evt.getModifiers() & SHIFT_MASK) == SHIFT_MASK)
            {
                JTable table =(JTable) evt.getSource();
                Point p = evt.getPoint();
                int row = table.rowAtPoint(p);
                int col = table.columnAtPoint(p);
                if (col == 3) // zeiger auf adresse
                {
                    Object o =  table.getModel().getValueAt( row,  col);
                    if (o==null) return;
                    int address = DASM6809.toNumber(o.toString());
                    vecxPanel.setDumpToAddress(address);
                }
            }
        }
    }//GEN-LAST:event_jTable1MousePressed

    private void jMenuItemBreakpointReadActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemBreakpointReadActionPerformed
        Breakpoint bp = new Breakpoint();
        bp.targetAddress = popUpAddress;
        bp.targetBank = vecxPanel.getCurrentBank();
        bp.targetType = Breakpoint.BP_TARGET_MEMORY;
        bp.name = popUpName;
        bp.targetSubType = 0;
        bp.type = Breakpoint.BP_READ | Breakpoint.BP_MULTI ;
        vecxPanel.breakpointVarSet(bp);
        popUpAddress = -1;
        popUpName = "";
    }//GEN-LAST:event_jMenuItemBreakpointReadActionPerformed

    private void jMenuItemBreakpointWriteActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemBreakpointWriteActionPerformed
        Breakpoint bp = new Breakpoint();
        bp.targetAddress = popUpAddress;
        bp.targetBank = vecxPanel.getCurrentBank();
        bp.targetType = Breakpoint.BP_TARGET_MEMORY;
        bp.targetSubType = 0;
        bp.name = popUpName;
        bp.type = Breakpoint.BP_WRITE | Breakpoint.BP_MULTI ;
        vecxPanel.breakpointVarSet(bp);
        popUpAddress = -1;
        popUpName = "";
    }//GEN-LAST:event_jMenuItemBreakpointWriteActionPerformed

    private void jMenuItemBreakpointValueActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemBreakpointValueActionPerformed
        int value =GetValuePanel.showEnterValueDialog() & 0xff;
        Breakpoint bp = new Breakpoint();
        bp.targetAddress = popUpAddress;
        bp.targetBank = vecxPanel.getCurrentBank();
        bp.targetType = Breakpoint.BP_TARGET_MEMORY;
        bp.targetSubType = 0;
        bp.compareValue = value;
        bp.name = popUpName;
        bp.type = Breakpoint.BP_WRITE | Breakpoint.BP_MULTI | Breakpoint.BP_COMPARE;
        vecxPanel.breakpointVarSet(bp);
        popUpAddress = -1;
        popUpName = "";
    }//GEN-LAST:event_jMenuItemBreakpointValueActionPerformed

    private void jButtonAddVariableActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonAddVariableActionPerformed
        int adress =AddVariablePanel.showEnterValueDialog() & 0xffff;
        
        Memory myMemory = dissi.getMemory();
        
        MemoryInformation info = myMemory.get(adress, dissi.getCurrentBank());
        if (info == null)
        {
            info = myMemory.buildMemInfo(adress);
        }
        info.labels.add(("_"+String.format("%04X",adress)).toUpperCase());
        initVariables();        
        dissi.completeUpdate();
        
    }//GEN-LAST:event_jButtonAddVariableActionPerformed

    private void jMenuItem1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem1ActionPerformed
        Memory myMemory = dissi.getMemory();
        
        MemoryInformation info = myMemory.get(popUpAddress, dissi.getCurrentBank());

        info.immediateLabels.clear();
        for (String l: info.labels)
        {
            info.immediateLabels.add(l);
        }
        initVariables();        
        dissi.completeUpdate();
    }//GEN-LAST:event_jMenuItem1ActionPerformed

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
 
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton jButtonAddVariable;
    private javax.swing.JCheckBox jCheckBox1;
    private javax.swing.JMenuItem jMenuItem1;
    private javax.swing.JMenuItem jMenuItemBreakpointRead;
    private javax.swing.JMenuItem jMenuItemBreakpointValue;
    private javax.swing.JMenuItem jMenuItemBreakpointWrite;
    private javax.swing.JPopupMenu jPopupMenu1;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JPopupMenu.Separator jSeparator1;
    private javax.swing.JTable jTable1;
    private javax.swing.JToggleButton jToggleButton4;
    // End of variables declaration//GEN-END:variables
    JTable buildTable()
    {
        JTable table = new JTable(){

            //Implement table cell tool tips.           
            public String getToolTipText(MouseEvent e) 
            {
                if (vecxPanel==null) return null;
                String tip = "<html>";
                if (jTable1.getModel() instanceof VariablesTableModel)
                {
                    VariablesTableModel model = (VariablesTableModel) jTable1.getModel();
                    java.awt.Point p = e.getPoint();
                    int rowIndex = rowAtPoint(p);
                    int colIndex = columnAtPoint(p);

                    
                    rowIndex = jTable1.convertRowIndexToModel( rowAtPoint(p) ) ;                   
                    
                    try 
                    {
                        MemoryInformation memInfo = variables.get(rowIndex);
                        int val1 = (vecxPanel.getVecXMem8(memInfo.address)&0xff);
                        int val2 = (vecxPanel.getVecXMem8(memInfo.address)&0xff)*256+(vecxPanel.getVecXMem8(memInfo.address+1)&0xff);
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
                        if (colIndex == 4) // comments
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
                }
                tip += "</html>";
                return tip;
            }
        };       
       return  table;
    }

    
    public class VariablesTableModel extends AbstractTableModel
    {
        public int getRowCount()
        {
            return variables.size();
        }
        public int getColumnCount()
        {
            return 5;
        }
        public Object getValueAt(int row, int col)
        {
            if (vecxPanel == null) return "";
            if (row >variables.size()) return "";
            MemoryInformation memInfo = variables.get(row);
            
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
            if (col == 2) return "$"+String.format("%02X", (vecxPanel.getVecXMem8(memInfo.address)&0xff));
            if (col == 3) return "$"+String.format("%04X", (vecxPanel.getVecXMem8(memInfo.address)&0xff)*256+(vecxPanel.getVecXMem8(memInfo.address+1)&0xff));
            if (col == 4)
            {
                String l = "";
                for (int i = 0; i< memInfo.comments.size(); i++)
                {
                    if (i>0) l+=", ";
                    l += memInfo.comments.get(i);
                }
                return l;
            }
            return "";
        }
        public String getColumnName(int column) {
            if (column == 0) return "address";
            if (column == 1) return "variables";
            if (column == 2) return "8 bit";
            if (column == 3) return "16 bit";
            if (column == 4) return "comment";
            return "-";
        }
        public Class<?> getColumnClass(int columnIndex) {
            return String.class;
        }
        public boolean isCellEditable(int rowIndex, int columnIndex) {
            return columnIndex==1 ||columnIndex==4||columnIndex==2||columnIndex==3;
        }
        public int getColWidth(int col)
        {
            if (col == 0) return 20;
            if (col == 1) return 200;
            if (col == 2) return 10;
            if (col == 3) return 20;
            if (col == 4) return 80;
            return 20;
        }
        public Color getBackground(int col)
        {
            if (col == 0) return new Color(200,255,200,255);
            return null; // default
        }
        public void setValueAt(Object aValue, int row, int col) {
            if (col == 2) // 8 bit edit
            {
                MemoryInformation memInfo = variables.get(row);
                if (aValue == null) return;
                String v = aValue.toString();
                int iv = DASM6809.toNumber(v) & 0xff;
                if (dissi != null)
                    dissi.doThePoke(memInfo.address, (byte)iv);
            }
            if (col == 3) // 16 bit edit
            {
                MemoryInformation memInfo = variables.get(row);
                if (aValue == null) return;
                String v = aValue.toString();
                int iv = DASM6809.toNumber(v) & 0xffff;
                if (dissi != null)
                {
                    int msb = (iv/256)&0xff;
                    int lsb = (iv)&0xff;
                    dissi.doThePoke(memInfo.address, (byte)msb);
                    dissi.doThePoke(memInfo.address+1, (byte)lsb);
                }

            }
            if (col == 1)
            {
                MemoryInformation memInfo = variables.get(row);
                ArrayList<String> oldLabels = (ArrayList<String>)memInfo.labels.clone();   
                memInfo.labels.clear();
                String label = aValue.toString();
                String[] labels = label.split(":");
                for (String l: labels)
                {
                    if (l.trim().length()>0)
                        memInfo.labels.add(l);
                }
                if (dissi == null) return;
                Memory orgData = dissi.getMemory();
                boolean changeRelevant = true;
                if (orgData != null)
                {
                    changeRelevant = orgData.labelsChanged(memInfo, oldLabels);
                }
                // check if var was a dp also!
                int adr = memInfo.address;
                int dp = adr/256;
                HashMap<Integer, String> dmap = orgData.directLabels.get(dp);
                if (dmap != null)
                {
                    if (dmap.get(adr&0xff) != null)
                    {
                        if (labels.length>0)
                            dmap.put((adr&0xff), labels[0]);
                    }

                } 
                        

                
                
                
                
                if (changeRelevant)
                    dissi.varUpdate();
                fireTableCellUpdated(row, col);
            }
            if (col == 4)
            {
                // todo 
                MemoryInformation memInfo = variables.get(row);

                memInfo.comments.clear();
                String comment = aValue.toString();
                String[] comments = comment.split(":");
                for (String c: comments)
                memInfo.comments.add(c);
                fireTableCellUpdated(row, col);

            }
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
        SwingUtilities.updateComponentTreeUI(jPopupMenu1);
        int fontSize = Theme.textFieldFont.getFont().getSize();
        int rowHeight = fontSize+3;
        jTable1.setRowHeight(rowHeight);
    }
}
