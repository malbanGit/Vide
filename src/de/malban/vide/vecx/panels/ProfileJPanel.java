package de.malban.vide.vecx.panels;

import de.malban.config.Configuration;
import de.malban.gui.CSAMainFrame;
import de.malban.gui.Stateable;
import de.malban.gui.Windowable;
import de.malban.gui.components.CSAView;
import de.malban.vide.dissy.DissiPanel;
import de.malban.vide.vecx.Profiler;
import de.malban.vide.vecx.Updatable;
import de.malban.vide.vecx.VecXPanel;
import de.muntjak.tinylookandfeel.Theme;
import java.awt.Color;
import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import javax.swing.RowSorter;
import javax.swing.SortOrder;
import javax.swing.SwingUtilities;
import javax.swing.UIManager;
import javax.swing.event.RowSorterEvent;
import static javax.swing.event.RowSorterEvent.Type.SORTED;
import javax.swing.table.AbstractTableModel;
import javax.swing.table.TableModel;
import javax.swing.table.TableRowSorter;

/**
 *
 * @author malban
 */
public class ProfileJPanel extends javax.swing.JPanel  implements
        Windowable, Stateable, Updatable{

    public boolean isLoadSettings() { return true; }
    Profiler profiler = null;

    private CSAView mParent = null;
    private javax.swing.JMenuItem mParentMenuItem = null;
    private int mClassSetting=0;
    private VecXPanel vecxPanel = null; // needed for vectrex memory access
    private DissiPanel dissi = null;
    public static String SID = "Debug: Profiler";
    boolean nameChanged = false;
    public String getID()
    {
        return SID;
    }
    @Override public String getFileID()
    {
        return de.malban.util.UtilityString.replace(de.malban.util.UtilityString.replace(de.malban.util.UtilityString.replace(de.malban.util.UtilityString.replaceWhiteSpaces(SID, ""),":",""),"(",""),")","") ;
    }
    public Serializable getAdditionalStateinfo(){return null;}
    public void setAdditionalStateinfo(Serializable ser){}
    
    public void setDissi(DissiPanel v)
    {
        dissi = v;
        if (dissi == null) return;
    }
    public void setVecxy(VecXPanel v)
    {
        vecxPanel = v;
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
        if (vecxPanel != null) vecxPanel.resetProfi();
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

    
    ProfileFunctionTableModel model = new ProfileFunctionTableModel();
    /**
     * Creates new form ProfileJPanel
     */
    TableRowSorter<TableModel> sorter;
    public ProfileJPanel() {
        initComponents();
        jTable1.setModel(model);
        UIManager.addPropertyChangeListener(pListener);
        updateMyUI(); 
        jTable1.tableChanged(null);

        sorter = new TableRowSorter<TableModel>(jTable1.getModel());
        jTable1.setRowSorter(sorter);
        List<RowSorter.SortKey> sortKeys = new ArrayList<>(1);
        sortKeys.add(new RowSorter.SortKey(4, SortOrder.DESCENDING));
        sorter.setSortKeys(sortKeys);        

        jTable1.tableChanged(null);
        jTable1.sorterChanged(new RowSorterEvent(sorter, SORTED, null));
        sorter.sort();
    }
    public void removeUIListerner()
    {
        UIManager.removePropertyChangeListener(pListener);
    }
    private PropertyChangeListener pListener = new PropertyChangeListener()
    {
        @Override
        public void propertyChange(PropertyChangeEvent evt)
        {
            updateMyUI();
        }
    };
    void updateMyUI()
    {
//        SwingUtilities.updateComponentTreeUI(jPopupMenu1);
        int fontSize = Theme.textFieldFont.getFont().getSize();
        int rowHeight = fontSize+3;
        jTable1.setRowHeight(rowHeight);
    }

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jTabbedPane1 = new javax.swing.JTabbedPane();
        jPanel2 = new javax.swing.JPanel();
        jScrollPane1 = new javax.swing.JScrollPane();
        jTable1 = new javax.swing.JTable();
        jPanel1 = new javax.swing.JPanel();
        jToggleButton1 = new javax.swing.JToggleButton();
        jCheckBox1 = new javax.swing.JCheckBox();
        jButtonApplyCodeScan = new javax.swing.JButton();

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

        javax.swing.GroupLayout jPanel2Layout = new javax.swing.GroupLayout(jPanel2);
        jPanel2.setLayout(jPanel2Layout);
        jPanel2Layout.setHorizontalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 395, Short.MAX_VALUE)
            .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                .addGroup(jPanel2Layout.createSequentialGroup()
                    .addContainerGap()
                    .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 375, Short.MAX_VALUE)
                    .addContainerGap()))
        );
        jPanel2Layout.setVerticalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 243, Short.MAX_VALUE)
            .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                .addGroup(jPanel2Layout.createSequentialGroup()
                    .addContainerGap()
                    .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 221, Short.MAX_VALUE)
                    .addContainerGap()))
        );

        jTabbedPane1.addTab("functional view", jPanel2);

        jToggleButton1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/webcam.png"))); // NOI18N
        jToggleButton1.setToolTipText("Toggle Update (always or only while debug)");
        jToggleButton1.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jToggleButton1.setSelectedIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/webcamSelect.png"))); // NOI18N
        jToggleButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jToggleButton1ActionPerformed(evt);
            }
        });

        jCheckBox1.setText("selected tracker cycle only");
        jCheckBox1.setToolTipText("Only usable while tracker is actually tracking!");
        jCheckBox1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox1ActionPerformed(evt);
            }
        });

        jButtonApplyCodeScan.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/exclamation.png"))); // NOI18N
        jButtonApplyCodeScan.setToolTipText("Reset Profiler");
        jButtonApplyCodeScan.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonApplyCodeScan.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonApplyCodeScanActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addComponent(jToggleButton1, javax.swing.GroupLayout.PREFERRED_SIZE, 20, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(18, 18, 18)
                .addComponent(jCheckBox1)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(jButtonApplyCodeScan))
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jToggleButton1, javax.swing.GroupLayout.PREFERRED_SIZE, 20, javax.swing.GroupLayout.PREFERRED_SIZE)
            .addComponent(jCheckBox1)
            .addComponent(jButtonApplyCodeScan)
        );

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addComponent(jTabbedPane1)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                .addComponent(jPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jTabbedPane1))
        );
    }// </editor-fold>//GEN-END:initComponents

    private void jToggleButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jToggleButton1ActionPerformed
        updateEnabled = jToggleButton1.isSelected();
    }//GEN-LAST:event_jToggleButton1ActionPerformed

    private void jTable1MousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jTable1MousePressed
    }//GEN-LAST:event_jTable1MousePressed

    private void jCheckBox1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox1ActionPerformed
        if (profiler != null) profiler.trackingOnly = jCheckBox1.isSelected();
    }//GEN-LAST:event_jCheckBox1ActionPerformed

    private void jButtonApplyCodeScanActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonApplyCodeScanActionPerformed
        vecxPanel.initProfiler();
    }//GEN-LAST:event_jButtonApplyCodeScanActionPerformed

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton jButtonApplyCodeScan;
    private javax.swing.JCheckBox jCheckBox1;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JTabbedPane jTabbedPane1;
    private javax.swing.JTable jTable1;
    private javax.swing.JToggleButton jToggleButton1;
    // End of variables declaration//GEN-END:variables

    int lastLength = -1;
    boolean first = true;
    private void update()
    {
        if (vecxPanel == null) return;
        profiler = vecxPanel.getProfiler();
        if (profiler == null) return;
        if (first)
        {
            jCheckBox1.setSelected(profiler.trackingOnly);
            first = false;
        }
        if (lastLength != profiler.routines.size()) model.fireTableDataChanged();
        lastLength = profiler.routines.size();
        try
        {
        sorter.sort();
        }
        catch (Throwable e){}
        jTable1.repaint();
    }
    private boolean updateEnabled = false;
    public void updateValues(boolean forceUpdate)
    {
        if (profiler != null) profiler.trackingOnly = jCheckBox1.isSelected();

        if (!forceUpdate)
            if (!updateEnabled) return;
        update();
    }
    public void setUpdateEnabled(boolean b)
    {
        updateEnabled = b;
    }
    
    
    public class ProfileFunctionTableModel extends AbstractTableModel
    {
        public int getRowCount()
        {
            if (profiler == null) return 0;
            return profiler.routines.size();
        }
        public int getColumnCount()
        {
            return 5;
        }
        public Object getValueAt(int row, int col)
        {
            boolean ok = true;
            if (profiler == null) ok = false;
            if (ok) if (vecxPanel == null) ok = false;
            if (ok) if (profiler.routines == null) ok = false;
            if (ok) if (row >=profiler.routines.size()) ok = false;
            
            if (!ok)
            {
                if (col == 0) 
                {
                    return "";
                }
                if (col == 1) 
                {
                    return "";
                }
                if (col == 2) 
                {
                    return 0;
                }
                if (col == 3) 
                {
                    return 0;
                }
                if (col == 4) 
                {
                    return 0.0;
                }
                return "";
            }
            
            Profiler.ProfilerMemoryLocation pml = profiler.routines.get(row);
            
            if (profiler.trackingOnly)
            {
                if (col == 0) 
                {
                    return "$"+String.format("%04X",pml.address);
                }
                if (col == 1) 
                {
                    return pml.name;
                }
                if (col == 2) 
                {
                    return pml.lastTrack_accessCount_final;
                }
                if (col == 3) 
                {
                    return pml.lastTrack_accessCyclesSum_final;
                }
                if (col == 4) 
                {
                    double cycles= profiler.track_overallCycles_final;
                    cycles = (((double)pml.lastTrack_accessCyclesSum_final)/cycles)*100.0;
                    return cycles;
                }
                return "";
                
            }
            
            if (col == 0) 
            {
                return "$"+String.format("%04X",pml.address);
            }
            if (col == 1) 
            {
                return pml.name;
            }
            if (col == 2) 
            {
                return pml.accessCount;
            }
            if (col == 3) 
            {
                return pml.accessCyclesSum;
            }
            if (col == 4) 
            {
                double cycles= profiler.overallCycles;
                cycles = (((double)pml.accessCyclesSum)/cycles)*100.0;
                return cycles;
            }
            return "";
        }
        public String getColumnName(int column) {
            if (column == 0) return "address";
            if (column == 1) return "name";
            if (column == 2) return "access";
            if (column == 3) return "cycles";
            if (column == 4) return "cycles %";
            return "-";
        }
        @Override
        public Class<?> getColumnClass(int columnIndex) {
            if (columnIndex == 0) return String.class;
            if (columnIndex == 1) return String.class;
            if (columnIndex == 2) return Long.class;
            if (columnIndex == 3) return Long.class;
            if (columnIndex == 4) return Double.class;
            return String.class;
        }
        public int getColWidth(int col)
        {
            if (col == 0) return 20;
            if (col == 1) return 200;
            if (col == 2) return 20;
            if (col == 3) return 20;
            return 20;
        }
        public Color getBackground(int col)
        {
            if (col == 0) return new Color(200,255,200,255);
            return null; // default
        }
    }
    public void deIconified() { }
    
    
}
