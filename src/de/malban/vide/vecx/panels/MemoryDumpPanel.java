/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx.panels;

import de.malban.config.Configuration;
import de.malban.graphics.GFXVector;
import de.malban.graphics.GFXVectorAnimation;
import de.malban.graphics.GFXVectorList;
import de.malban.gui.CSAMainFrame;
import de.malban.vide.vecx.VecXPanel;
import de.malban.gui.Stateable;
import de.malban.gui.Windowable;
import de.malban.gui.components.CSAView;
import de.malban.util.KeyboardListener;
import de.malban.vide.dissy.DASM6809;
import de.malban.vide.dissy.DissiPanel;
import de.malban.vide.dissy.MemoryInformation;
import de.malban.vide.vecx.Updatable;
import static de.malban.vide.dissy.MemoryInformation.MEM_TYPE_IO;
import static de.malban.vide.dissy.MemoryInformation.MEM_TYPE_RAM;
import static de.malban.vide.dissy.MemoryInformation.MEM_TYPE_ROM;
import de.malban.vide.veccy.VeccyInterpreter;
import de.malban.vide.veccy.VeccyPanel;
import de.malban.vide.veccy.VeccyPanel.PatternInfo;
import java.awt.Color;
import java.awt.Component;
import java.awt.Point;
import java.awt.Rectangle;
import java.awt.event.MouseEvent;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Vector;
import javax.swing.DefaultComboBoxModel;
import javax.swing.JButton;
import javax.swing.JTable;
import javax.swing.JViewport;
import javax.swing.table.AbstractTableModel;
import javax.swing.table.DefaultTableCellRenderer;

/**
 *
 * @author malban
 */
public class MemoryDumpPanel extends javax.swing.JPanel implements
        Windowable, Stateable, Updatable{
    public boolean isLoadSettings() { return true; }
    private CSAView mParent = null;
    private javax.swing.JMenuItem mParentMenuItem = null;
    private int mClassSetting=0;
    private DissiPanel dissi = null;    // nice to have for additional memory information
    private VecXPanel vecxPanel = null; // needed for vectrex memory access
    
    private static final int DEFAULT_SPLIT_SIZE = 250;
    
    // selection
    int endAddress = -1;
    int startAddress = -1;
    
    public void setVecxy(VecXPanel v)
    {
        vecxPanel = v;
        correctTable();
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
    public void setDissi(DissiPanel d)
    {
        dissi = d;
    }

    public class MemoryDumpTableModel extends AbstractTableModel
    {
        public int getRowCount()
        {
            return 65536/16;
        }
        public int getColumnCount()
        {
            return 18;
        }
        public Object getValueAt(int row, int col)
        {
            if (vecxPanel == null) return "";
            if (col == 0)
                return"$"+String.format("%04X",getAddress( row,  col)+1) ;
            if (col == 17)
                return asciiDump(row);
            
            return "$"+String.format("%02X", vecxPanel.getVecXMem8(getAddress( row,  col)));
        }
        public int getIntegerValueAt(int row, int col)
        {
            if (vecxPanel == null) return -1;
            if (col == 0) return -1;
            if (col == 17) return -1;
            
            return vecxPanel.getVecXMem8(getAddress( row,  col));
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
        if (vecxPanel != null) vecxPanel.resetDumpi();
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
        mParentMenuItem.setText("Memory dump");
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
    }
    /**
     * Creates new form MemoryDumpPanel
     */
    public MemoryDumpPanel() {
        initComponents();
        MemoryDumpTableModel model = new MemoryDumpTableModel();

        mClassSetting++;
        loadPatterns();
        if (knownPatterns.size() == 0)
        {
            VeccyPanel.fillPatternBox(knownPatterns);
            jComboBoxPatterns.setModel(new DefaultComboBoxModel(knownPatterns));
        }
        
        
        mClassSetting--;
        jComboBoxPatterns.setSelectedIndex(0);
        
        single3dDisplayPanel1.setByteFrame(false);
        single3dDisplayPanel1.setAxisAngleX(0);
        single3dDisplayPanel1.setAxisAngleY(0);
        single3dDisplayPanel1.setAxisAngleZ(0);
        single3dDisplayPanel1.setDrawVectorEnds(false);
        single3dDisplayPanel1.repaint();
        jSliderSourceScale1StateChanged(null); 
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
                    int address = model.getAddress(row, col);

                    
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
                    if ((address>=startAddress) && (address<= endAddress) && (jCheckBox1.isSelected()))
                    {
                        setBackground(new Color(200,200,255)); // light blue for data selection
                    }
                }
                return this;
            }   
        });       
        correctTable();
        jSplitPane1.setDividerLocation(jSplitPane1.getSize().height-DEFAULT_SPLIT_SIZE);
        jSplitPane1.setDividerSize(5);
    }
    Vector<VeccyPanel.PatternInfo> knownPatterns = new Vector<VeccyPanel.PatternInfo>();
    
    protected boolean loadPatterns()
    {
        mClassSetting++;
        jComboBoxPatterns.setModel(new DefaultComboBoxModel(knownPatterns));
        mClassSetting--;
        try
        {
            knownPatterns = (Vector<VeccyPanel.PatternInfo>) CSAMainFrame.deserialize("serialize"+File.separator+"PatternInfo.ser");
            if (knownPatterns == null) 
            {
                knownPatterns = new Vector<VeccyPanel.PatternInfo>();
                return false;
            }
        }
        catch (Throwable e)
        {
            return false;
        }
        mClassSetting++;
        jComboBoxPatterns.setModel(new DefaultComboBoxModel(knownPatterns));
        mClassSetting--;

        return true;
    }
    JTable buildTable()
    {
        JTable table = new JTable(){

            //Implement table cell tool tips.           
            public String getToolTipText(MouseEvent e) 
            {
                String tip = "<html>";
                if (dissi == null) return null;
                if (vecxPanel==null) return null;
                if (jTable1.getModel() instanceof MemoryDumpTableModel)
                {
                    MemoryDumpTableModel model = (MemoryDumpTableModel) jTable1.getModel();
                    java.awt.Point p = e.getPoint();
                    int rowIndex = rowAtPoint(p);
                    int colIndex = columnAtPoint(p);

                    try 
                    {
                        MemoryInformation memInfo = dissi.getMemoryInformation(model.getAddress(rowIndex, colIndex), vecxPanel.getCurrentBank());
                        if (memInfo.memType == MEM_TYPE_RAM)
                        {
                            tip += "RAM:<BR> \"";
                            tip += "decimal: "+model.getIntegerValueAt(rowIndex, colIndex)+"<BR>";
                            tip += "labels: \"";
                            for (int i = 0; i< memInfo.labels.size(); i++)
                            {
                                if (i>0) tip+=", ";
                                tip += memInfo.labels.get(i);
                            }
                            tip += "\"<BR>";
                            tip += "comments: \"";
                            for (int i = 0; i< memInfo.comments.size(); i++)
                            {
                                if (i>0) tip+=":";
                                tip += memInfo.comments.get(i);
                            }
                            tip += "\"<BR>";
                            
                        }
                        if (memInfo.memType == MEM_TYPE_ROM)
                        {
                            tip += "ROM:<BR>labels: \"";
                            for (int i = 0; i< memInfo.labels.size(); i++)
                            {
                                if (i>0) tip+=", ";
                                tip += memInfo.labels.get(i);
                            }
                            tip += "\"<BR>";
                            tip += "comments: \"";
                            for (int i = 0; i< memInfo.comments.size(); i++)
                            {
                                if (i>0) tip+=":";
                                tip += memInfo.comments.get(i);
                            }
                            tip += "\"<BR>";
                            tip += "Type: "+MemoryInformation.disTypeString[memInfo.disType]+"<BR>";
                        }
                        if (memInfo.memType == MEM_TYPE_IO)
                        {
                            tip += "IO:<BR>labels: \"";
                            for (int i = 0; i< memInfo.labels.size(); i++)
                            {
                                if (i>0) tip+=", ";
                                tip += memInfo.labels.get(i);
                            }
                            tip += "\"<BR>";
                            tip += "comments: \"";
                            for (int i = 0; i< memInfo.comments.size(); i++)
                            {
                                if (i>0) tip+=":";
                                tip += memInfo.comments.get(i);
                            }
                            tip += "\"<BR>";
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
    
    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        buttonGroup1 = new javax.swing.ButtonGroup();
        jSplitPane1 = new javax.swing.JSplitPane();
        jPanel4 = new javax.swing.JPanel();
        jPanel1 = new javax.swing.JPanel();
        jToggleButton4 = new javax.swing.JToggleButton();
        jButton1 = new javax.swing.JButton();
        jButton2 = new javax.swing.JButton();
        jButton3 = new javax.swing.JButton();
        jButton4 = new javax.swing.JButton();
        jButton5 = new javax.swing.JButton();
        jButton6 = new javax.swing.JButton();
        jButton7 = new javax.swing.JButton();
        jButton8 = new javax.swing.JButton();
        jButton9 = new javax.swing.JButton();
        jCheckBox1 = new javax.swing.JCheckBox();
        jScrollPane1 = new javax.swing.JScrollPane();
        jTable1 = buildTable();
        jPanel2 = new javax.swing.JPanel();
        single3dDisplayPanel1 = new de.malban.graphics.Single3dDisplayPanel();
        jTextFieldRasterWidth = new javax.swing.JTextField();
        jLabel2 = new javax.swing.JLabel();
        jRadioButton2 = new javax.swing.JRadioButton();
        jComboBoxPatterns = new javax.swing.JComboBox();
        jLabel1 = new javax.swing.JLabel();
        jRadioButton1 = new javax.swing.JRadioButton();
        jTextField2 = new javax.swing.JTextField();
        jLabel3 = new javax.swing.JLabel();
        jTextField3 = new javax.swing.JTextField();
        jLabel4 = new javax.swing.JLabel();
        jSliderSourceScale1 = new javax.swing.JSlider();
        jCheckBoxActive = new javax.swing.JCheckBox();
        jButtonInterprete = new javax.swing.JButton();
        jButtonSave3 = new javax.swing.JButton();
        jTextFieldPatternName = new javax.swing.JTextField();
        jLabel25 = new javax.swing.JLabel();
        jLabel26 = new javax.swing.JLabel();
        jLabel27 = new javax.swing.JLabel();
        jTextField9 = new javax.swing.JTextField();
        jTextField10 = new javax.swing.JTextField();
        jTextField8 = new javax.swing.JTextField();

        jSplitPane1.setDividerLocation(250);
        jSplitPane1.setOrientation(javax.swing.JSplitPane.VERTICAL_SPLIT);
        jSplitPane1.addComponentListener(new java.awt.event.ComponentAdapter() {
            public void componentResized(java.awt.event.ComponentEvent evt) {
                jSplitPane1ComponentResized(evt);
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

        jButton1.setText("$c800");
        jButton1.setMargin(new java.awt.Insets(2, 2, 2, 2));
        jButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton2ActionPerformed(evt);
            }
        });

        jButton2.setText("$c880");
        jButton2.setMargin(new java.awt.Insets(2, 2, 2, 2));
        jButton2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton2ActionPerformed(evt);
            }
        });

        jButton3.setText("$c900");
        jButton3.setMargin(new java.awt.Insets(2, 2, 2, 2));
        jButton3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton2ActionPerformed(evt);
            }
        });

        jButton4.setText("$ca00");
        jButton4.setMargin(new java.awt.Insets(2, 2, 2, 2));
        jButton4.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton2ActionPerformed(evt);
            }
        });

        jButton5.setText("$cb00");
        jButton5.setMargin(new java.awt.Insets(2, 2, 2, 2));
        jButton5.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton2ActionPerformed(evt);
            }
        });

        jButton6.setText("X");
        jButton6.setMargin(new java.awt.Insets(2, 2, 2, 0));
        jButton6.setPreferredSize(new java.awt.Dimension(18, 23));
        jButton6.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton6jButton2ActionPerformed(evt);
            }
        });

        jButton7.setText("Y");
        jButton7.setMargin(new java.awt.Insets(2, 2, 2, 0));
        jButton7.setPreferredSize(new java.awt.Dimension(18, 23));
        jButton7.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton7jButton2ActionPerformed(evt);
            }
        });

        jButton8.setText("S");
        jButton8.setMargin(new java.awt.Insets(2, 2, 2, 0));
        jButton8.setPreferredSize(new java.awt.Dimension(18, 23));
        jButton8.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton8jButton2ActionPerformed(evt);
            }
        });

        jButton9.setText("U");
        jButton9.setMargin(new java.awt.Insets(2, 2, 2, 0));
        jButton9.setPreferredSize(new java.awt.Dimension(18, 23));
        jButton9.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton9jButton2ActionPerformed(evt);
            }
        });

        jCheckBox1.setSelected(true);
        jCheckBox1.setText("data display");
        jCheckBox1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox1ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addComponent(jToggleButton4, javax.swing.GroupLayout.PREFERRED_SIZE, 20, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jButton1, javax.swing.GroupLayout.PREFERRED_SIZE, 53, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButton2, javax.swing.GroupLayout.PREFERRED_SIZE, 53, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButton3, javax.swing.GroupLayout.PREFERRED_SIZE, 53, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButton4, javax.swing.GroupLayout.PREFERRED_SIZE, 53, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButton5, javax.swing.GroupLayout.PREFERRED_SIZE, 53, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButton6, javax.swing.GroupLayout.PREFERRED_SIZE, 18, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButton7, javax.swing.GroupLayout.PREFERRED_SIZE, 18, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButton8, javax.swing.GroupLayout.PREFERRED_SIZE, 18, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButton9, javax.swing.GroupLayout.PREFERRED_SIZE, 18, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(27, 27, 27)
                .addComponent(jCheckBox1)
                .addGap(0, 376, Short.MAX_VALUE))
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jToggleButton4, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                .addComponent(jButton1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(jButton2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(jButton3, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(jButton4, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(jButton5, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(jButton6, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(jButton7, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(jButton8, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(jButton9, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(jCheckBox1))
        );

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
        jTable1.setSelectionMode(javax.swing.ListSelectionModel.MULTIPLE_INTERVAL_SELECTION);
        jTable1.setShowHorizontalLines(false);
        jTable1.setShowVerticalLines(false);
        jTable1.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jTable1MousePressed(evt);
            }
        });
        jScrollPane1.setViewportView(jTable1);

        javax.swing.GroupLayout jPanel4Layout = new javax.swing.GroupLayout(jPanel4);
        jPanel4.setLayout(jPanel4Layout);
        jPanel4Layout.setHorizontalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel1, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                .addComponent(jScrollPane1, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, 898, Short.MAX_VALUE))
        );
        jPanel4Layout.setVerticalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel4Layout.createSequentialGroup()
                .addComponent(jPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0))
            .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel4Layout.createSequentialGroup()
                    .addGap(28, 28, 28)
                    .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 221, Short.MAX_VALUE)))
        );

        jSplitPane1.setLeftComponent(jPanel4);

        single3dDisplayPanel1.setMaximumSize(new java.awt.Dimension(150, 150));
        single3dDisplayPanel1.setMinimumSize(new java.awt.Dimension(150, 150));
        single3dDisplayPanel1.setPreferredSize(new java.awt.Dimension(100, 100));

        javax.swing.GroupLayout single3dDisplayPanel1Layout = new javax.swing.GroupLayout(single3dDisplayPanel1);
        single3dDisplayPanel1.setLayout(single3dDisplayPanel1Layout);
        single3dDisplayPanel1Layout.setHorizontalGroup(
            single3dDisplayPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 0, Short.MAX_VALUE)
        );
        single3dDisplayPanel1Layout.setVerticalGroup(
            single3dDisplayPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 186, Short.MAX_VALUE)
        );

        jTextFieldRasterWidth.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextFieldRasterWidthFocusLost(evt);
            }
        });
        jTextFieldRasterWidth.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldRasterWidthActionPerformed(evt);
            }
        });
        jTextFieldRasterWidth.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyReleased(java.awt.event.KeyEvent evt) {
                jTextFieldRasterWidthKeyReleased(evt);
            }
            public void keyTyped(java.awt.event.KeyEvent evt) {
                jTextFieldRasterWidthKeyTyped(evt);
            }
        });

        jLabel2.setText("width");

        buttonGroup1.add(jRadioButton2);
        jRadioButton2.setText("raster");
        jRadioButton2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jRadioButton2ActionPerformed(evt);
            }
        });

        jComboBoxPatterns.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Item 1", "Item 2", "Item 3", "Item 4" }));
        jComboBoxPatterns.setPreferredSize(new java.awt.Dimension(59, 19));
        jComboBoxPatterns.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBoxPatternsActionPerformed(evt);
            }
        });

        jLabel1.setText("type");

        buttonGroup1.add(jRadioButton1);
        jRadioButton1.setSelected(true);
        jRadioButton1.setText("vectorlist");
        jRadioButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jRadioButton1ActionPerformed(evt);
            }
        });

        jTextField2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField2ActionPerformed(evt);
            }
        });
        jTextField2.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyTyped(java.awt.event.KeyEvent evt) {
                jTextField2KeyTyped(evt);
            }
        });

        jLabel3.setText("start");

        jTextField3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField3ActionPerformed(evt);
            }
        });
        jTextField3.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyTyped(java.awt.event.KeyEvent evt) {
                jTextField3KeyTyped(evt);
            }
        });

        jLabel4.setText("end");

        jSliderSourceScale1.setMajorTickSpacing(1);
        jSliderSourceScale1.setMaximum(21);
        jSliderSourceScale1.setMinimum(1);
        jSliderSourceScale1.setMinorTickSpacing(1);
        jSliderSourceScale1.setValue(10);
        jSliderSourceScale1.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderSourceScale1StateChanged(evt);
            }
        });

        jCheckBoxActive.setText("active");
        jCheckBoxActive.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxActiveActionPerformed(evt);
            }
        });

        jButtonInterprete.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/accept.png"))); // NOI18N
        jButtonInterprete.setToolTipText("Select previous, +SHIFT moves selected vectorlist one to the left.");
        jButtonInterprete.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButtonInterprete.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonInterprete.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonInterpreteActionPerformed(evt);
            }
        });

        jButtonSave3.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/page_save.png"))); // NOI18N
        jButtonSave3.setToolTipText("save current setting");
        jButtonSave3.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonSave3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSave3ActionPerformed(evt);
            }
        });

        jTextFieldPatternName.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldPatternNameActionPerformed(evt);
            }
        });

        jLabel25.setText("line 1");

        jLabel26.setText("line x");

        jLabel27.setText("last line");

        jTextField10.setText("%Y %X");

        jTextField8.setText("%C");

        javax.swing.GroupLayout jPanel2Layout = new javax.swing.GroupLayout(jPanel2);
        jPanel2.setLayout(jPanel2Layout);
        jPanel2Layout.setHorizontalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel2Layout.createSequentialGroup()
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addComponent(jLabel25, javax.swing.GroupLayout.PREFERRED_SIZE, 42, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel26, javax.swing.GroupLayout.PREFERRED_SIZE, 42, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel27, javax.swing.GroupLayout.PREFERRED_SIZE, 55, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel2Layout.createSequentialGroup()
                                .addComponent(jButtonInterprete, javax.swing.GroupLayout.PREFERRED_SIZE, 20, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                .addComponent(jButtonSave3)))
                        .addGap(8, 8, 8))
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addComponent(jLabel1, javax.swing.GroupLayout.PREFERRED_SIZE, 38, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(25, 25, 25)))
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                        .addComponent(jTextFieldPatternName, javax.swing.GroupLayout.PREFERRED_SIZE, 92, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jComboBoxPatterns, javax.swing.GroupLayout.PREFERRED_SIZE, 92, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jTextField8, javax.swing.GroupLayout.PREFERRED_SIZE, 92, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addGap(18, 18, 18)
                        .addComponent(jRadioButton1, javax.swing.GroupLayout.PREFERRED_SIZE, 82, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jRadioButton2, javax.swing.GroupLayout.PREFERRED_SIZE, 70, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jLabel2, javax.swing.GroupLayout.PREFERRED_SIZE, 38, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextFieldRasterWidth, javax.swing.GroupLayout.PREFERRED_SIZE, 40, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(56, 56, 56)
                        .addComponent(jLabel3, javax.swing.GroupLayout.PREFERRED_SIZE, 38, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField2, javax.swing.GroupLayout.PREFERRED_SIZE, 52, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jLabel4, javax.swing.GroupLayout.PREFERRED_SIZE, 38, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jTextField3, javax.swing.GroupLayout.PREFERRED_SIZE, 52, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(34, 34, 34)
                        .addComponent(jCheckBoxActive)
                        .addGap(100, 100, 100))
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addGap(5, 5, 5)
                        .addComponent(single3dDisplayPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, 738, Short.MAX_VALUE)
                        .addGap(0, 0, 0))))
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jTextField10, javax.swing.GroupLayout.PREFERRED_SIZE, 92, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField9, javax.swing.GroupLayout.PREFERRED_SIZE, 92, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jSliderSourceScale1, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.PREFERRED_SIZE, 155, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel2Layout.setVerticalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jRadioButton2)
                    .addComponent(jLabel2)
                    .addComponent(jTextFieldRasterWidth, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel3)
                    .addComponent(jTextField3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel4)
                    .addComponent(jRadioButton1)
                    .addComponent(jCheckBoxActive))
                .addGap(5, 5, 5)
                .addComponent(single3dDisplayPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, 186, Short.MAX_VALUE))
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addComponent(jLabel1)
                        .addGap(10, 10, 10))
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel2Layout.createSequentialGroup()
                        .addComponent(jComboBoxPatterns, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)))
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jButtonInterprete)
                    .addComponent(jTextFieldPatternName, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButtonSave3))
                .addGap(6, 6, 6)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jTextField9, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLabel27))
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jTextField8, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel25))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jTextField10, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel26))
                        .addGap(25, 25, 25)))
                .addComponent(jSliderSourceScale1, javax.swing.GroupLayout.PREFERRED_SIZE, 22, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, Short.MAX_VALUE))
        );

        jSplitPane1.setRightComponent(jPanel2);

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSplitPane1)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSplitPane1)
        );
    }// </editor-fold>//GEN-END:initComponents

    private void jToggleButton4ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jToggleButton4ActionPerformed
        updateEnabled = jToggleButton4.isSelected();
    }//GEN-LAST:event_jToggleButton4ActionPerformed

    private void jButton2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton2ActionPerformed
        int targetAdress = DASM6809.toNumber(((JButton)evt.getSource()).getText());
        goAddress(targetAdress);
    }//GEN-LAST:event_jButton2ActionPerformed

    private void jButton6jButton2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton6jButton2ActionPerformed
        if (vecxPanel==null) return;
        int targetAdress = vecxPanel.getXReg();
        goAddress(targetAdress);
    }//GEN-LAST:event_jButton6jButton2ActionPerformed

    private void jButton7jButton2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton7jButton2ActionPerformed
        if (vecxPanel==null) return;
        int targetAdress = vecxPanel.getYReg();
        goAddress(targetAdress);
    }//GEN-LAST:event_jButton7jButton2ActionPerformed

    private void jButton8jButton2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton8jButton2ActionPerformed
        if (vecxPanel==null) return;
        int targetAdress = vecxPanel.getSReg();
        goAddress(targetAdress);
    }//GEN-LAST:event_jButton8jButton2ActionPerformed

    private void jButton9jButton2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton9jButton2ActionPerformed
        if (vecxPanel==null) return;
        int targetAdress = vecxPanel.getUReg();
        goAddress(targetAdress);
    }//GEN-LAST:event_jButton9jButton2ActionPerformed

    private void jComboBoxPatternsActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBoxPatternsActionPerformed
        if (mClassSetting>0) return;
 
        if (mClassSetting>0) return;
        if (jComboBoxPatterns.getSelectedIndex() == -1) return;
        PatternInfo info = (PatternInfo)jComboBoxPatterns.getSelectedItem();
        jTextFieldPatternName.setText(info.name);
        jTextField8.setText(info.line1Pattern);
        jTextField10.setText(info.lineXPattern);
        jTextField9.setText(info.lastLinePattern);
        selectionChanged();
    }//GEN-LAST:event_jComboBoxPatternsActionPerformed
    void doInterpret()
    {
        PatternInfo info = (PatternInfo)jComboBoxPatterns.getSelectedItem();
        if (info == null) return;
        if (startAddress==-1) return;
        if (endAddress==-1) return;
        if (endAddress<startAddress) return;
        
        
        StringBuffer b = new StringBuffer();
        for(int i=startAddress; i<=endAddress; i++)
        {
            MemoryInformation memInfo = dissi.getMemoryInformation(i, vecxPanel.getCurrentBank());
            b.append(" $").append(String.format("%02X",memInfo.content) );
        }
       
        VeccyInterpreter interpreter = new VeccyInterpreter();
        interpreter.setPatterns(jTextField8.getText(), jTextField10.getText(), jTextField9.getText());
//        interpreter.setPatterns(info.line1Pattern, info.lineXPattern, info.lastLinePattern);
        ArrayList<Byte> data = interpreter.setData(b.toString());

        GFXVectorList newList = interpreter.getVectorList();

        single3dDisplayPanel1.setAnimation(new GFXVectorAnimation());
        single3dDisplayPanel1.setForegroundVectorList(newList);
        single3dDisplayPanel1.setDelay(-1);

    }
    void selectionChanged()
    {
        updateTable();
        if (!jCheckBoxActive.isSelected()) return;
        if (!jCheckBox1.isSelected()) return;
        if (jRadioButton1.isSelected())
        {
            // do vectorlist
            doInterpret();
        }
        else
        {
            doBitmap();
        }
    }
    
    public void setStartEndAddress(int start, int end)
    {
        startAddress = start;
        endAddress = end;
        jTextField2.setText("$"+String.format("%04X",startAddress));
        jTextField3.setText("$"+String.format("%04X",endAddress));
        selectionChanged();
        jTable1.repaint();
    }
    
    private void jTextField2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextField2ActionPerformed
        startAddress = de.malban.util.UtilityString.IntX(jTextField2.getText(), startAddress);
        selectionChanged();
        jTable1.repaint();
    }//GEN-LAST:event_jTextField2ActionPerformed

    private void jTextField3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextField3ActionPerformed
        endAddress = de.malban.util.UtilityString.IntX(jTextField3.getText(), endAddress);
        selectionChanged();
        jTable1.repaint();
    }//GEN-LAST:event_jTextField3ActionPerformed

    private void jTable1MousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jTable1MousePressed
        JTable table =(JTable) evt.getSource();
        Point p = evt.getPoint();
        int  row = table.rowAtPoint(p);
        int  col= table.columnAtPoint(p);
        boolean shift = KeyboardListener.isShiftDown();
        MemoryDumpTableModel model = (MemoryDumpTableModel) jTable1.getModel();
        int address = model.getAddress(row, col);
        
        if (shift)
        {
            endAddress = address;
        }
        else
        {
            startAddress = address;
        }
        
        jTextField2.setText("$"+String.format("%04X",startAddress&0xffff));
        jTextField3.setText("$"+String.format("%04X",endAddress&0xffff));
        selectionChanged();
    }//GEN-LAST:event_jTable1MousePressed

    private void jSliderSourceScale1StateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderSourceScale1StateChanged
        int value = jSliderSourceScale1.getValue();
        int max = jSliderSourceScale1.getMaximum();
        double scale = value - ((max-1)/2);
        if (value <((max/2)+1))
        {
            int invScale = ((max/2)+2)-value;
            scale = 1.0/invScale;
        }
        single3dDisplayPanel1.setScale(scale);
        single3dDisplayPanel1.repaint();
        

    }//GEN-LAST:event_jSliderSourceScale1StateChanged

    private void jRadioButton2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jRadioButton2ActionPerformed
        selectionChanged();
    }//GEN-LAST:event_jRadioButton2ActionPerformed

    private void jRadioButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jRadioButton1ActionPerformed
        selectionChanged();
    }//GEN-LAST:event_jRadioButton1ActionPerformed

    private void jTextFieldRasterWidthActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldRasterWidthActionPerformed
        selectionChanged();
    }//GEN-LAST:event_jTextFieldRasterWidthActionPerformed

    private void jTextFieldRasterWidthKeyTyped(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTextFieldRasterWidthKeyTyped
        selectionChanged();
    }//GEN-LAST:event_jTextFieldRasterWidthKeyTyped

    private void jTextField2KeyTyped(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTextField2KeyTyped
        startAddress = de.malban.util.UtilityString.IntX(jTextField2.getText(), startAddress);
        selectionChanged();
        jTable1.repaint();
    }//GEN-LAST:event_jTextField2KeyTyped

    private void jTextField3KeyTyped(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTextField3KeyTyped
        endAddress = de.malban.util.UtilityString.IntX(jTextField3.getText(), endAddress);
        selectionChanged();
        jTable1.repaint();
    }//GEN-LAST:event_jTextField3KeyTyped

    private void jTextFieldRasterWidthFocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextFieldRasterWidthFocusLost
        selectionChanged();
    }//GEN-LAST:event_jTextFieldRasterWidthFocusLost

    private void jTextFieldRasterWidthKeyReleased(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTextFieldRasterWidthKeyReleased
        selectionChanged();
    }//GEN-LAST:event_jTextFieldRasterWidthKeyReleased

    private void jCheckBox1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox1ActionPerformed
        single3dDisplayPanel1.setRepaint(jCheckBoxActive.isSelected() && jCheckBox1.isSelected());
        if (jCheckBox1.isSelected())
        {
           jSplitPane1.setDividerLocation(jSplitPane1.getSize().height-DEFAULT_SPLIT_SIZE);
           jSplitPane1.setDividerSize(5);
        }
        else
        {
           jSplitPane1.setDividerLocation(jSplitPane1.getSize().height);
           jSplitPane1.setDividerSize(0);
        }
        
    }//GEN-LAST:event_jCheckBox1ActionPerformed

    private void jSplitPane1ComponentResized(java.awt.event.ComponentEvent evt) {//GEN-FIRST:event_jSplitPane1ComponentResized
        jCheckBox1ActionPerformed(null);
    }//GEN-LAST:event_jSplitPane1ComponentResized

    private void jButtonInterpreteActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonInterpreteActionPerformed

         selectionChanged();
    }//GEN-LAST:event_jButtonInterpreteActionPerformed

    private void jButtonSave3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSave3ActionPerformed
        savePatterns();
    }//GEN-LAST:event_jButtonSave3ActionPerformed

    private void jTextFieldPatternNameActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldPatternNameActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jTextFieldPatternNameActionPerformed

    private void jCheckBoxActiveActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxActiveActionPerformed
        single3dDisplayPanel1.setRepaint(jCheckBoxActive.isSelected() && jCheckBox1.isSelected());
    }//GEN-LAST:event_jCheckBoxActiveActionPerformed
    public void updateTable()
    {
        jTable1.repaint();
    }


    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.ButtonGroup buttonGroup1;
    private javax.swing.JButton jButton1;
    private javax.swing.JButton jButton2;
    private javax.swing.JButton jButton3;
    private javax.swing.JButton jButton4;
    private javax.swing.JButton jButton5;
    private javax.swing.JButton jButton6;
    private javax.swing.JButton jButton7;
    private javax.swing.JButton jButton8;
    private javax.swing.JButton jButton9;
    private javax.swing.JButton jButtonInterprete;
    private javax.swing.JButton jButtonSave3;
    private javax.swing.JCheckBox jCheckBox1;
    private javax.swing.JCheckBox jCheckBoxActive;
    private javax.swing.JComboBox jComboBoxPatterns;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel25;
    private javax.swing.JLabel jLabel26;
    private javax.swing.JLabel jLabel27;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JPanel jPanel4;
    private javax.swing.JRadioButton jRadioButton1;
    private javax.swing.JRadioButton jRadioButton2;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JSlider jSliderSourceScale1;
    private javax.swing.JSplitPane jSplitPane1;
    private javax.swing.JTable jTable1;
    private javax.swing.JTextField jTextField10;
    private javax.swing.JTextField jTextField2;
    private javax.swing.JTextField jTextField3;
    private javax.swing.JTextField jTextField8;
    private javax.swing.JTextField jTextField9;
    private javax.swing.JTextField jTextFieldPatternName;
    private javax.swing.JTextField jTextFieldRasterWidth;
    private javax.swing.JToggleButton jToggleButton4;
    private de.malban.graphics.Single3dDisplayPanel single3dDisplayPanel1;
    // End of variables declaration//GEN-END:variables
   
    public static String SID = "dumpi";
    public String getID()
    {
        return SID;
    }
    public Serializable getAdditionalStateinfo(){return null;}
    public void setAdditionalStateinfo(Serializable ser){}
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
        if (vecxPanel==null) return "";
        String dump = "";
        for (int i=0;i<16; i++)
        {
            int v = vecxPanel.getVecXMem8( row*16+i) &0xff;
            if (v<0x20) dump+=".";
            else if (v>0x6F) dump+=".";
            else if (v<0x5F) dump+=(char)v;
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
    void doBitmap()
    {
        single3dDisplayPanel1.clearVectors();
        if (startAddress==-1) return;
        if (endAddress==-1) return;
        if (endAddress<startAddress) return;


        int targetWidth = de.malban.util.UtilityString.IntX(jTextFieldRasterWidth.getText(), 1);
        int targetHeight = (endAddress-startAddress)/targetWidth;

        
        

        int vy = 0 +(targetHeight/2);  
        for (int y=0; y<targetHeight; y++)
        {
            int vx = 0 -(targetWidth/2)*8;             


/////                
            for (int x=0; x<targetWidth; x++)
            {
                int address = startAddress+(y*targetWidth)+x;
                MemoryInformation memInfo = dissi.getMemoryInformation(address, vecxPanel.getCurrentBank());
                
                
                int brightness = 255;
                int shiftreg = memInfo.content;
                for (int b=0; b<8; b++)
                {
                    boolean bit = ((shiftreg&0x80)!=0);
                    shiftreg = shiftreg<<1;
                    int pattern = bit?255:0;

                    int sx = vx;
                    int ex = ex = (vx)+1;
                    
                    GFXVector v = new GFXVector();
                    v.start.x(sx);
                    v.start.y(vy);
                    v.end.x(ex);
                    v.end.y(vy);
                    v.pattern = pattern;
                    v.setIntensity(brightness);
                    single3dDisplayPanel1.addForegroundVector(v);
                    vx+=1;

//                        if (jCheckBoxAssume9Bit.isSelected())
                    {
                        if (b == 7)
                        {
                            sx = vx;
                            ex = (vx)+1;
                            v = new GFXVector();
                            v.start.x(sx);
                            v.start.y(vy);
                            v.end.x(ex);
                            v.end.y(vy);
                            v.pattern = pattern;
                            v.setIntensity(brightness);
                            single3dDisplayPanel1.addForegroundVector(v);
                            vx+=1;
                        }
                    }
                }
            }
            vy--;
        }                
    }        
    protected boolean savePatterns()
    {
        PatternInfo ti = new PatternInfo();
        ti.name = jTextFieldPatternName.getText();
        if (ti.name.trim().length() == 0) return false;
        ti.line1Pattern = jTextField8.getText();
        ti.lineXPattern = jTextField10.getText();
        ti.lastLinePattern = jTextField9.getText();
        
        
        for (int i=0; i< knownPatterns.size(); i++)
        {
            if (knownPatterns.elementAt(i).equals(ti)) return true;
        }
        knownPatterns.addElement(ti);
        try
        {
            CSAMainFrame.serialize(knownPatterns, "serialize"+File.separator+"PatternInfo.ser");
        }
        catch (Throwable e)
        {
            return false;
        }
        mClassSetting++;
        jComboBoxPatterns.setModel(new DefaultComboBoxModel(knownPatterns));
        jComboBoxPatterns.setSelectedIndex(knownPatterns.size()-1);
        mClassSetting--;
        return true;
    }        
}

