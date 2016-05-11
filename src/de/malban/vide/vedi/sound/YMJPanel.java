/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vedi.sound;

import de.malban.config.Configuration;
import de.malban.config.TinyLogInterface;
import de.malban.gui.CSAMainFrame;
import de.malban.gui.Windowable;
import de.malban.gui.components.CSAView;
import de.malban.gui.dialogs.InternalFrameFileChoser;
import de.malban.gui.panels.LogPanel;
import static de.malban.gui.panels.LogPanel.WARN;
import de.malban.sound.tinysound.Stream;
import de.malban.sound.tinysound.TinySound;
import de.malban.vide.dissy.DASM6809;
import de.malban.vide.dissy.DissiPanel;
import de.malban.vide.vecx.E8910;
import static de.malban.vide.vecx.VecX.SOUNDBUFFER_SIZE;
import static de.malban.vide.vecx.panels.PSGJPanel.REC_BIN;
import static de.malban.vide.vecx.panels.PSGJPanel.REC_DATA;
import static de.malban.vide.vecx.panels.PSGJPanel.REC_YM;
import de.malban.vide.vedi.VediPanel;
import java.awt.Color;
import java.awt.Component;
import java.awt.Point;
import java.awt.event.ActionEvent;
import java.io.BufferedOutputStream;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.OutputStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import javax.swing.DefaultComboBoxModel;
import javax.swing.ImageIcon;
import javax.swing.JComboBox;
import javax.swing.JFrame;
import javax.swing.JInternalFrame;
import javax.swing.JScrollBar;
import javax.swing.JTable;
import javax.swing.JTextField;
import javax.swing.SwingUtilities;
import javax.swing.filechooser.FileNameExtensionFilter;
import javax.swing.table.AbstractTableModel;
import javax.swing.table.DefaultTableCellRenderer;

/**
 * // see: http://www.jsresources.org/examples/AudioRecorder.html
 * @author malban
 */
public class YMJPanel extends javax.swing.JPanel implements Windowable
{
    LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
    String currentYMFile = "";
    String ymSaveName = "";
    String pathOnly = "";
    TinyLogInterface tinyLog = null;
    private int mClassSetting=0;
    private CSAView mParent = null;
    private javax.swing.JMenuItem mParentMenuItem = null;
    Thread two = null;
    Thread three = null;
    YmSound ymSound;

    @Override
    public void closing()
    {
        playingYM = false;
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
        mParentMenuItem.setText("YMPanel");
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
    
    
    public class YMTableModel extends AbstractTableModel
    {    
        @Override
        public String getColumnName(int col) {
            return ""+col;
        }
        @Override
        public int getRowCount() {
            return ymSound.vbl_len;
        }

        @Override
        public int getColumnCount() {
            return 16;
        }
        @Override
        public Object getValueAt(int row, int col) {
            return "$"+String.format("%02X", ymSound.out_buf[col][row]);
        }
        public Class<?> getColumnClass(int col) 
        {
            return Object.class;
        }
        public boolean isCellEditable(int row, int col) 
        {
            return true;
        }
        public void setValueAt(Object aValue, int row, int col) 
        {
            int value = DASM6809.toNumber(aValue.toString());
            ymSound.out_buf[col][row] = (byte)(value & 0xff);
        }
    }
    public class YMCountTableModel extends AbstractTableModel
    {    
        @Override
        public String getColumnName(int col) {
            return "#";
        }
        @Override
        public int getRowCount() {
            return ymSound.vbl_len;
        }

        @Override
        public int getColumnCount() {
            return 1;
        }
        String pad(int v)
        {
            String ret=""+v;
                 if (v<10)   ret = "000"+ret;
            else if (v<100)  ret = "00"+ret;
            else if (v<1000) ret = "0"+ret;
            return ret;
        }
        @Override
        public Object getValueAt(int row, int col) {
            return pad(row);
        }
        public Class<?> getColumnClass(int col) 
        {
            return Object.class;
        }
        public boolean isCellEditable(int row, int col) 
        {
            return false;
        }
        public void setValueAt(Object aValue, int row, int col) 
        {
        }
    }    
    public static Object[] envelopeItems= null;

        /**
     * Creates new form SampleJPanel
     */
    public YMJPanel(String filename, TinyLogInterface tl) 
    {
        if (envelopeItems == null)
        {
            Object[] items =
            {
                new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/vedi/sound/Down.png")),
                new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/vedi/sound/UpMin.png")),
                new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/vedi/sound/Triangle1.png")),
                new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/vedi/sound/Saw1.png")),
                new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/vedi/sound/DownMax.png")),
                new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/vedi/sound/Saw2.png")),
                new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/vedi/sound/Up.png")),
                new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/vedi/sound/Triangle2.png"))
            };        
            envelopeItems = items;
            
        }
        initComponents();
        tinyLog = tl;
        
        
        jComboBoxNotesA.setModel(new DefaultComboBoxModel(Mod2Vectrex.NAME));
        jComboBoxNotesB.setModel(new DefaultComboBoxModel(Mod2Vectrex.NAME));
        jComboBoxNotesC.setModel(new DefaultComboBoxModel(Mod2Vectrex.NAME));
        
        usedRegs[0] = true;
        usedRegs[1] = true;
        usedRegs[2] = true;
        usedRegs[3] = true;
        usedRegs[4] = true;
        usedRegs[5] = true;
        usedRegs[6] = true;
        usedRegs[7] = true;
        usedRegs[8] = true;
        usedRegs[9] = true;
        usedRegs[10] = true;
        usedRegs[11] = false;
        usedRegs[12] = false;
        usedRegs[13] = false;
        usedRegs[14] = false;
        usedRegs[15] = false;
        jCheckBox1.setSelected(usedRegs[0]);
        jCheckBox2.setSelected(usedRegs[1]);
        jCheckBox3.setSelected(usedRegs[2]);
        jCheckBox4.setSelected(usedRegs[3]);
        jCheckBox5.setSelected(usedRegs[4]);
        jCheckBox6.setSelected(usedRegs[5]);
        jCheckBox7.setSelected(usedRegs[6]);
        jCheckBox8.setSelected(usedRegs[7]);
        jCheckBox9.setSelected(usedRegs[8]);
        jCheckBox10.setSelected(usedRegs[9]);
        jCheckBox11.setSelected(usedRegs[10]);
        jCheckBox12.setSelected(usedRegs[11]);
        jCheckBox13.setSelected(usedRegs[12]);
        jCheckBox14.setSelected(usedRegs[13]);
        jCheckBox15.setSelected(usedRegs[14]);
        jCheckBox16.setSelected(usedRegs[15]);
        
        initYM(filename);
        
        jTable1.setModel(new YMTableModel());
        jTable2.setModel(new YMCountTableModel());
        JScrollBar sBar1 = jScrollPane1.getVerticalScrollBar();
        JScrollBar sBar2 = jScrollPane2.getVerticalScrollBar();
        sBar2.setModel(sBar1.getModel()); //<--------------synchronize   
        
        jTable1.setDefaultRenderer(Object.class, new DefaultTableCellRenderer()
        {
            @Override
            public Component getTableCellRendererComponent(JTable table, Object value, boolean isSelected, boolean hasFocus, int row, int col) 
            {
                super.getTableCellRendererComponent(table, value, isSelected, hasFocus, row, col);

                if (table.getModel() instanceof YMTableModel)
                {
                    if (isSelected)
                    {
                        setBackground(table.getSelectionBackground());
                        setForeground(table.getSelectionForeground());
                    }
                    if (row == ympos)
                    {
                        setBackground(new Color(200,200,255));
                    }        
                    else
                    {
                        if (!isSelected)
                            setBackground(Color.WHITE);
                    }
                }
                return this;
            }   
        });                
        jTable2.setDefaultRenderer(Object.class, new DefaultTableCellRenderer()
        {
            @Override
            public Component getTableCellRendererComponent(JTable table, Object value, boolean isSelected, boolean hasFocus, int row, int col) 
            {
                super.getTableCellRendererComponent(table, value, isSelected, hasFocus, row, col);

                if (table.getModel() instanceof YMCountTableModel)
                {
                    if (row == ympos)
                    {
                        setBackground(new Color(200,200,255));
                    }        
                    else
                    {
                        setBackground(Color.WHITE);
                    }
                }
                return this;
            }   
        });                
    }

    boolean initYM(String filename)
    {
        // check if is a file or a dir
        File file = new File(filename);
        if (filename.length()!=0)
            pathOnly = file.getParent();
        currentYMFile = filename;
        
        ymSound = new YmSound(currentYMFile, tinyLog);
        if (!ymSound.init) return false;
        jTextFieldYMVersion.setText(ymSound.version);
        jCheckBoxPacked.setSelected(ymSound.packed);
        jTextFieldAttributes.setText(ymSound.getLongBinaryString(ymSound.attribut));
        jTextFieldFrequencyComputer.setText(""+ymSound.externalFrequency);
        jTextFieldFrequencyPlayer.setText(""+ymSound.playerFrequency);
        jTextFieldLoop.setText(""+ymSound.loopStart);
        jTextFieldFutureData.setText(""+ymSound.futureDataLength);
        jTextFieldSamples.setText(""+ymSound.samples);
        jTextFieldSongName.setText(""+ymSound.song_name);
        jTextFieldAuthor.setText(""+ymSound.author);
        jTextFieldComment.setText(""+ymSound.comment);
        
        jComboBoxInterleaved.setSelectedIndex(ymSound.interleave?0:1);
        jLabel10.setText(currentYMFile);
        return true;
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
        buttonGroup2 = new javax.swing.ButtonGroup();
        buttonGroup3 = new javax.swing.ButtonGroup();
        buttonGroup4 = new javax.swing.ButtonGroup();
        jButtonCreate = new javax.swing.JButton();
        jButtonCancel = new javax.swing.JButton();
        jLabel6 = new javax.swing.JLabel();
        jScrollPane1 = new javax.swing.JScrollPane();
        jTable1 = new javax.swing.JTable();
        jPanel3 = new javax.swing.JPanel();
        jCheckBox1 = new javax.swing.JCheckBox();
        jCheckBox2 = new javax.swing.JCheckBox();
        jCheckBox3 = new javax.swing.JCheckBox();
        jCheckBox4 = new javax.swing.JCheckBox();
        jCheckBox5 = new javax.swing.JCheckBox();
        jCheckBox6 = new javax.swing.JCheckBox();
        jCheckBox7 = new javax.swing.JCheckBox();
        jCheckBox8 = new javax.swing.JCheckBox();
        jCheckBox9 = new javax.swing.JCheckBox();
        jCheckBox10 = new javax.swing.JCheckBox();
        jCheckBox11 = new javax.swing.JCheckBox();
        jCheckBox12 = new javax.swing.JCheckBox();
        jCheckBox13 = new javax.swing.JCheckBox();
        jCheckBox14 = new javax.swing.JCheckBox();
        jCheckBox15 = new javax.swing.JCheckBox();
        jCheckBox16 = new javax.swing.JCheckBox();
        jButtonPlaySample = new javax.swing.JButton();
        jButtonCut = new javax.swing.JButton();
        jButtonStop2 = new javax.swing.JButton();
        jScrollPane2 = new javax.swing.JScrollPane();
        jTable2 = new javax.swing.JTable();
        jLabel10 = new javax.swing.JLabel();
        jPanel2 = new javax.swing.JPanel();
        jLabel11 = new javax.swing.JLabel();
        jTextFieldYMVersion = new javax.swing.JTextField();
        jLabel12 = new javax.swing.JLabel();
        jTextFieldAttributes = new javax.swing.JTextField();
        jLabel13 = new javax.swing.JLabel();
        jTextFieldFrequencyComputer = new javax.swing.JTextField();
        jLabel14 = new javax.swing.JLabel();
        jTextFieldLoop = new javax.swing.JTextField();
        jCheckBoxPacked = new javax.swing.JCheckBox();
        jLabel21 = new javax.swing.JLabel();
        jTextFieldFrequencyPlayer = new javax.swing.JTextField();
        jLabel22 = new javax.swing.JLabel();
        jTextFieldFutureData = new javax.swing.JTextField();
        jTextFieldComment = new javax.swing.JTextField();
        jTextFieldAuthor = new javax.swing.JTextField();
        jLabel18 = new javax.swing.JLabel();
        jTextFieldSongName = new javax.swing.JTextField();
        jLabel17 = new javax.swing.JLabel();
        jTextFieldSamples = new javax.swing.JTextField();
        jLabel15 = new javax.swing.JLabel();
        jLabel19 = new javax.swing.JLabel();
        jLabel16 = new javax.swing.JLabel();
        jComboBoxInterleaved = new javax.swing.JComboBox();
        jComboBox1 = new javax.swing.JComboBox();
        jLabel20 = new javax.swing.JLabel();
        jCheckBoxDontCompress = new javax.swing.JCheckBox();
        jCheckBoxCreatePlayer = new javax.swing.JCheckBox();
        jPanel4 = new javax.swing.JPanel();
        jTextField16a = new javax.swing.JTextField();
        jTextField1a = new javax.swing.JTextField();
        jTextField2a = new javax.swing.JTextField();
        jTextField3a = new javax.swing.JTextField();
        jTextField4a = new javax.swing.JTextField();
        jTextField5a = new javax.swing.JTextField();
        jTextField6a = new javax.swing.JTextField();
        jTextField7a = new javax.swing.JTextField();
        jTextField8a = new javax.swing.JTextField();
        jTextField9a = new javax.swing.JTextField();
        jTextField10a = new javax.swing.JTextField();
        jTextField11a = new javax.swing.JTextField();
        jTextField12a = new javax.swing.JTextField();
        jTextField13a = new javax.swing.JTextField();
        jTextField14a = new javax.swing.JTextField();
        jTextField15a = new javax.swing.JTextField();
        jButtonStop3 = new javax.swing.JButton();
        jPanel5 = new javax.swing.JPanel();
        jCheckBoxNoiseA = new javax.swing.JCheckBox();
        jCheckBoxNoiseB = new javax.swing.JCheckBox();
        jCheckBoxNoiseC = new javax.swing.JCheckBox();
        jCheckBoxToneC = new javax.swing.JCheckBox();
        jCheckBoxToneB = new javax.swing.JCheckBox();
        jCheckBoxToneA = new javax.swing.JCheckBox();
        jLabel1 = new javax.swing.JLabel();
        jLabel2 = new javax.swing.JLabel();
        jLabel3 = new javax.swing.JLabel();
        jLabel4 = new javax.swing.JLabel();
        jLabel5 = new javax.swing.JLabel();
        jLabel7 = new javax.swing.JLabel();
        jLabel8 = new javax.swing.JLabel();
        jLabel9 = new javax.swing.JLabel();
        jLabel23 = new javax.swing.JLabel();
        jLabel24 = new javax.swing.JLabel();
        jLabel25 = new javax.swing.JLabel();
        jLabel26 = new javax.swing.JLabel();
        jLabel27 = new javax.swing.JLabel();
        jLabel28 = new javax.swing.JLabel();
        jLabel30 = new javax.swing.JLabel();
        jLabel29 = new javax.swing.JLabel();
        jLabel31 = new javax.swing.JLabel();
        jLabel32 = new javax.swing.JLabel();
        jLabel33 = new javax.swing.JLabel();
        jLabel34 = new javax.swing.JLabel();
        jLabel35 = new javax.swing.JLabel();
        jLabel36 = new javax.swing.JLabel();
        jLabel37 = new javax.swing.JLabel();
        jLabel38 = new javax.swing.JLabel();
        jLabel39 = new javax.swing.JLabel();
        jLabel40 = new javax.swing.JLabel();
        jLabel41 = new javax.swing.JLabel();
        jLabel42 = new javax.swing.JLabel();
        jLabel43 = new javax.swing.JLabel();
        jLabel44 = new javax.swing.JLabel();
        jLabel45 = new javax.swing.JLabel();
        jLabel46 = new javax.swing.JLabel();
        jLabel47 = new javax.swing.JLabel();
        jLabel48 = new javax.swing.JLabel();
        jLabel49 = new javax.swing.JLabel();
        jLabel50 = new javax.swing.JLabel();
        jLabel51 = new javax.swing.JLabel();
        jLabel52 = new javax.swing.JLabel();
        jLabel53 = new javax.swing.JLabel();
        jLabel54 = new javax.swing.JLabel();
        jLabel55 = new javax.swing.JLabel();
        jLabel56 = new javax.swing.JLabel();
        jLabel57 = new javax.swing.JLabel();
        jLabel58 = new javax.swing.JLabel();
        jLabel59 = new javax.swing.JLabel();
        jSliderAmplidtudeA = new javax.swing.JSlider();
        jLabel60 = new javax.swing.JLabel();
        jLabel61 = new javax.swing.JLabel();
        jLabel62 = new javax.swing.JLabel();
        jLabel63 = new javax.swing.JLabel();
        jLabel64 = new javax.swing.JLabel();
        jLabel65 = new javax.swing.JLabel();
        jLabel66 = new javax.swing.JLabel();
        jLabel67 = new javax.swing.JLabel();
        jLabel68 = new javax.swing.JLabel();
        jLabel69 = new javax.swing.JLabel();
        jSliderAmplidtudeB = new javax.swing.JSlider();
        jSliderAmplidtudeC = new javax.swing.JSlider();
        jLabel76 = new javax.swing.JLabel();
        jLabel70 = new javax.swing.JLabel();
        jLabel74 = new javax.swing.JLabel();
        jLabel71 = new javax.swing.JLabel();
        jLabel75 = new javax.swing.JLabel();
        jLabel79 = new javax.swing.JLabel();
        jLabel73 = new javax.swing.JLabel();
        jLabel77 = new javax.swing.JLabel();
        jLabel78 = new javax.swing.JLabel();
        jLabel72 = new javax.swing.JLabel();
        jLabel80 = new javax.swing.JLabel();
        jLabel81 = new javax.swing.JLabel();
        jLabel82 = new javax.swing.JLabel();
        jLabel83 = new javax.swing.JLabel();
        jLabel84 = new javax.swing.JLabel();
        jLabel85 = new javax.swing.JLabel();
        jLabel86 = new javax.swing.JLabel();
        jLabel87 = new javax.swing.JLabel();
        jLabel88 = new javax.swing.JLabel();
        jLabel89 = new javax.swing.JLabel();
        jLabel91 = new javax.swing.JLabel();
        jLabel92 = new javax.swing.JLabel();
        jLabel93 = new javax.swing.JLabel();
        jLabel94 = new javax.swing.JLabel();
        jLabel95 = new javax.swing.JLabel();
        jLabel96 = new javax.swing.JLabel();
        jLabel97 = new javax.swing.JLabel();
        jLabel98 = new javax.swing.JLabel();
        jLabel99 = new javax.swing.JLabel();
        jLabel100 = new javax.swing.JLabel();
        jLabel101 = new javax.swing.JLabel();
        jLabel102 = new javax.swing.JLabel();
        jLabel103 = new javax.swing.JLabel();
        jLabel104 = new javax.swing.JLabel();
        jLabel105 = new javax.swing.JLabel();
        jLabel107 = new javax.swing.JLabel();
        jSliderNoise = new javax.swing.JSlider();
        jLabel106 = new javax.swing.JLabel();
        jComboBoxNotesA = new javax.swing.JComboBox();
        jComboBoxNotesB = new javax.swing.JComboBox();
        jComboBoxNotesC = new javax.swing.JComboBox();
        jCheckBoxModeA = new javax.swing.JCheckBox();
        jCheckBoxModeB = new javax.swing.JCheckBox();
        jCheckBoxModeC = new javax.swing.JCheckBox();
        jLabel108 = new javax.swing.JLabel();
        jLabel109 = new javax.swing.JLabel();
        jLabel110 = new javax.swing.JLabel();
        jLabel111 = new javax.swing.JLabel();
        jLabel113 = new javax.swing.JLabel();
        jLabel114 = new javax.swing.JLabel();
        jLabel115 = new javax.swing.JLabel();
        jLabel116 = new javax.swing.JLabel();
        jComboBoxEnvelope = new javax.swing.JComboBox();
        jLabel117 = new javax.swing.JLabel();
        jLabel118 = new javax.swing.JLabel();
        jLabel119 = new javax.swing.JLabel();
        jLabel120 = new javax.swing.JLabel();
        jLabel121 = new javax.swing.JLabel();
        jLabel122 = new javax.swing.JLabel();
        jLabel123 = new javax.swing.JLabel();
        jLabel124 = new javax.swing.JLabel();
        jLabel125 = new javax.swing.JLabel();
        jLabel126 = new javax.swing.JLabel();
        jLabel127 = new javax.swing.JLabel();
        jLabel128 = new javax.swing.JLabel();
        jLabel129 = new javax.swing.JLabel();
        jLabel130 = new javax.swing.JLabel();
        jLabel131 = new javax.swing.JLabel();
        jLabel132 = new javax.swing.JLabel();
        jLabel133 = new javax.swing.JLabel();
        jLabel134 = new javax.swing.JLabel();
        jButtonAddRow = new javax.swing.JButton();
        jButtonCopy = new javax.swing.JButton();
        jButtonPaste = new javax.swing.JButton();
        jButtonLoad = new javax.swing.JButton();
        jButtonSave = new javax.swing.JButton();
        jButtonInsertYM = new javax.swing.JButton();
        jButtonSaveSelection = new javax.swing.JButton();
        jButtonNewYM = new javax.swing.JButton();
        jPanel1 = new javax.swing.JPanel();
        jLabel90 = new javax.swing.JLabel();
        jLabelPSG0 = new javax.swing.JLabel();
        jLabelPSG1 = new javax.swing.JLabel();
        jLabelPSG3 = new javax.swing.JLabel();
        jLabelPSG2 = new javax.swing.JLabel();
        jLabelPSG5 = new javax.swing.JLabel();
        jLabelPSG4 = new javax.swing.JLabel();
        jLabelPSG6 = new javax.swing.JLabel();
        jLabelPSG7 = new javax.swing.JLabel();
        jLabelPSG8 = new javax.swing.JLabel();
        jLabelPSG9 = new javax.swing.JLabel();
        jLabelPSG10 = new javax.swing.JLabel();
        jLabelPSG11 = new javax.swing.JLabel();
        jLabelPSG15 = new javax.swing.JLabel();
        jLabelPSG14 = new javax.swing.JLabel();
        jLabelPSG13 = new javax.swing.JLabel();
        jLabelPSG12 = new javax.swing.JLabel();
        jPanel6 = new javax.swing.JPanel();
        jButtonLoad1 = new javax.swing.JButton();
        jButtonSave1 = new javax.swing.JButton();
        jCheckBox19 = new javax.swing.JCheckBox();
        jCheckBox22 = new javax.swing.JCheckBox();
        jPanel7 = new javax.swing.JPanel();
        jButtonLoad2 = new javax.swing.JButton();
        jButtonSave2 = new javax.swing.JButton();
        jCheckBox17 = new javax.swing.JCheckBox();
        jCheckBox20 = new javax.swing.JCheckBox();
        jPanel8 = new javax.swing.JPanel();
        jButtonLoad3 = new javax.swing.JButton();
        jButtonSave3 = new javax.swing.JButton();
        jCheckBox18 = new javax.swing.JCheckBox();
        jCheckBox21 = new javax.swing.JCheckBox();

        setPreferredSize(new java.awt.Dimension(960, 537));

        jButtonCreate.setText("create source");
        jButtonCreate.setName("create"); // NOI18N
        jButtonCreate.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonCreateActionPerformed(evt);
            }
        });

        jButtonCancel.setText("cancel");
        jButtonCancel.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonCancelActionPerformed(evt);
            }
        });

        jLabel6.setText("File:");

        jScrollPane1.setHorizontalScrollBarPolicy(javax.swing.ScrollPaneConstants.HORIZONTAL_SCROLLBAR_NEVER);
        jScrollPane1.setVerticalScrollBarPolicy(javax.swing.ScrollPaneConstants.VERTICAL_SCROLLBAR_ALWAYS);

        jTable1.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null},
                {null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null},
                {null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null},
                {null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null},
                {null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null},
                {null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null},
                {null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null},
                {null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null},
                {null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null},
                {null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null},
                {null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null},
                {null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null},
                {null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null},
                {null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null},
                {null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null},
                {null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null},
                {null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null},
                {null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null},
                {null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null},
                {null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null},
                {null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null},
                {null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null},
                {null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null}
            },
            new String [] {
                "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16"
            }
        ));
        jTable1.setAutoResizeMode(javax.swing.JTable.AUTO_RESIZE_ALL_COLUMNS);
        jTable1.setSelectionMode(javax.swing.ListSelectionModel.MULTIPLE_INTERVAL_SELECTION);
        jTable1.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jTable1MousePressed(evt);
            }
        });
        jScrollPane1.setViewportView(jTable1);

        jCheckBox1.setSelected(true);
        jCheckBox1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox1ActionPerformed(evt);
            }
        });

        jCheckBox2.setSelected(true);
        jCheckBox2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox1ActionPerformed(evt);
            }
        });

        jCheckBox3.setSelected(true);
        jCheckBox3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox1ActionPerformed(evt);
            }
        });

        jCheckBox4.setSelected(true);
        jCheckBox4.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox1ActionPerformed(evt);
            }
        });

        jCheckBox5.setSelected(true);
        jCheckBox5.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox1ActionPerformed(evt);
            }
        });

        jCheckBox6.setSelected(true);
        jCheckBox6.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox1ActionPerformed(evt);
            }
        });

        jCheckBox7.setSelected(true);
        jCheckBox7.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox1ActionPerformed(evt);
            }
        });

        jCheckBox8.setSelected(true);
        jCheckBox8.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox1ActionPerformed(evt);
            }
        });

        jCheckBox9.setSelected(true);
        jCheckBox9.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox1ActionPerformed(evt);
            }
        });

        jCheckBox10.setSelected(true);
        jCheckBox10.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox1ActionPerformed(evt);
            }
        });

        jCheckBox11.setSelected(true);
        jCheckBox11.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox1ActionPerformed(evt);
            }
        });

        jCheckBox12.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox1ActionPerformed(evt);
            }
        });

        jCheckBox13.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox1ActionPerformed(evt);
            }
        });

        jCheckBox14.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox1ActionPerformed(evt);
            }
        });

        jCheckBox15.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox1ActionPerformed(evt);
            }
        });

        jCheckBox16.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox1ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel3Layout = new javax.swing.GroupLayout(jPanel3);
        jPanel3.setLayout(jPanel3Layout);
        jPanel3Layout.setHorizontalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jCheckBox1)
                .addGap(18, 18, 18)
                .addComponent(jCheckBox2)
                .addGap(18, 18, 18)
                .addComponent(jCheckBox3)
                .addGap(18, 18, 18)
                .addComponent(jCheckBox4)
                .addGap(18, 18, 18)
                .addComponent(jCheckBox5)
                .addGap(18, 18, 18)
                .addComponent(jCheckBox6)
                .addGap(18, 18, 18)
                .addComponent(jCheckBox7)
                .addGap(18, 18, 18)
                .addComponent(jCheckBox8)
                .addGap(18, 18, 18)
                .addComponent(jCheckBox9)
                .addGap(18, 18, 18)
                .addComponent(jCheckBox10)
                .addGap(18, 18, 18)
                .addComponent(jCheckBox11)
                .addGap(18, 18, 18)
                .addComponent(jCheckBox12)
                .addGap(18, 18, 18)
                .addComponent(jCheckBox13)
                .addGap(18, 18, 18)
                .addComponent(jCheckBox14)
                .addGap(18, 18, 18)
                .addComponent(jCheckBox15)
                .addGap(18, 18, 18)
                .addComponent(jCheckBox16)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel3Layout.setVerticalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jCheckBox15, javax.swing.GroupLayout.Alignment.TRAILING)
            .addComponent(jCheckBox1, javax.swing.GroupLayout.Alignment.TRAILING)
            .addComponent(jCheckBox2, javax.swing.GroupLayout.Alignment.TRAILING)
            .addComponent(jCheckBox3, javax.swing.GroupLayout.Alignment.TRAILING)
            .addComponent(jCheckBox4, javax.swing.GroupLayout.Alignment.TRAILING)
            .addComponent(jCheckBox5, javax.swing.GroupLayout.Alignment.TRAILING)
            .addComponent(jCheckBox6, javax.swing.GroupLayout.Alignment.TRAILING)
            .addComponent(jCheckBox7, javax.swing.GroupLayout.Alignment.TRAILING)
            .addComponent(jCheckBox8, javax.swing.GroupLayout.Alignment.TRAILING)
            .addComponent(jCheckBox9, javax.swing.GroupLayout.Alignment.TRAILING)
            .addComponent(jCheckBox10, javax.swing.GroupLayout.Alignment.TRAILING)
            .addComponent(jCheckBox11, javax.swing.GroupLayout.Alignment.TRAILING)
            .addComponent(jCheckBox12, javax.swing.GroupLayout.Alignment.TRAILING)
            .addComponent(jCheckBox13, javax.swing.GroupLayout.Alignment.TRAILING)
            .addComponent(jCheckBox14, javax.swing.GroupLayout.Alignment.TRAILING)
            .addComponent(jCheckBox16, javax.swing.GroupLayout.Alignment.TRAILING)
        );

        jButtonPlaySample.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/control_play_blue.png"))); // NOI18N
        jButtonPlaySample.setToolTipText("Play current sample!");
        jButtonPlaySample.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonPlaySample.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonPlaySampleActionPerformed(evt);
            }
        });

        jButtonCut.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/cut.png"))); // NOI18N
        jButtonCut.setToolTipText("Cut current selection!");
        jButtonCut.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonCut.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonCutActionPerformed(evt);
            }
        });

        jButtonStop2.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/control_stop_blue.png"))); // NOI18N
        jButtonStop2.setToolTipText("Stop recording/playing sample!");
        jButtonStop2.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonStop2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonStop2ActionPerformed(evt);
            }
        });

        jScrollPane2.setHorizontalScrollBarPolicy(javax.swing.ScrollPaneConstants.HORIZONTAL_SCROLLBAR_NEVER);
        jScrollPane2.setVerticalScrollBarPolicy(javax.swing.ScrollPaneConstants.VERTICAL_SCROLLBAR_NEVER);

        jTable2.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null},
                {null},
                {null},
                {null}
            },
            new String [] {
                "#"
            }
        ));
        jTable2.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jTable2MouseClicked(evt);
            }
        });
        jScrollPane2.setViewportView(jTable2);

        jLabel10.setText("Song:");

        jPanel2.setBorder(javax.swing.BorderFactory.createTitledBorder("YM file"));

        jLabel11.setText("version:");

        jTextFieldYMVersion.setEnabled(false);

        jLabel12.setText("attributes:");

        jTextFieldAttributes.setEnabled(false);

        jLabel13.setText("frequency:");

        jTextFieldFrequencyComputer.setEnabled(false);

        jLabel14.setText("loop at:");

        jCheckBoxPacked.setEnabled(false);

        jLabel21.setText("packed:");

        jTextFieldFrequencyPlayer.setEnabled(false);

        jLabel22.setText("# future data:");

        jTextFieldFutureData.setEnabled(false);

        jLabel18.setText("comment:");

        jLabel17.setText("author:");

        jTextFieldSamples.setEnabled(false);

        jLabel15.setText("# samples:");

        jLabel19.setText("format:");

        jLabel16.setText("name:");

        jComboBoxInterleaved.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "interleaved", "non interleaved" }));
        jComboBoxInterleaved.setPreferredSize(new java.awt.Dimension(59, 19));
        jComboBoxInterleaved.setSize(new java.awt.Dimension(59, 19));
        jComboBoxInterleaved.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBoxInterleavedActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel2Layout = new javax.swing.GroupLayout(jPanel2);
        jPanel2.setLayout(jPanel2Layout);
        jPanel2Layout.setHorizontalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                        .addComponent(jLabel22, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addGroup(jPanel2Layout.createSequentialGroup()
                            .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                .addComponent(jLabel14)
                                .addComponent(jLabel13)
                                .addComponent(jLabel12)
                                .addComponent(jLabel11)
                                .addComponent(jLabel15, javax.swing.GroupLayout.PREFERRED_SIZE, 86, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGap(0, 17, Short.MAX_VALUE)))
                    .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                        .addComponent(jLabel16, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jLabel17, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jLabel18, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, 86, Short.MAX_VALUE)
                        .addComponent(jLabel19, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)))
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jTextFieldAuthor)
                    .addComponent(jTextFieldComment)
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jTextFieldSamples, javax.swing.GroupLayout.PREFERRED_SIZE, 55, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextFieldFutureData, javax.swing.GroupLayout.PREFERRED_SIZE, 55, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextFieldLoop, javax.swing.GroupLayout.PREFERRED_SIZE, 55, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGroup(jPanel2Layout.createSequentialGroup()
                                .addComponent(jTextFieldFrequencyComputer, javax.swing.GroupLayout.PREFERRED_SIZE, 55, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(18, 18, 18)
                                .addComponent(jTextFieldFrequencyPlayer, javax.swing.GroupLayout.PREFERRED_SIZE, 55, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(jPanel2Layout.createSequentialGroup()
                                .addComponent(jTextFieldYMVersion, javax.swing.GroupLayout.PREFERRED_SIZE, 61, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(75, 75, 75)
                                .addComponent(jLabel21)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jCheckBoxPacked)))
                        .addGap(0, 52, Short.MAX_VALUE))
                    .addComponent(jTextFieldSongName)
                    .addComponent(jTextFieldAttributes)
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addComponent(jComboBoxInterleaved, javax.swing.GroupLayout.PREFERRED_SIZE, 119, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addContainerGap())))
        );
        jPanel2Layout.setVerticalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jCheckBoxPacked, javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jLabel11)
                        .addComponent(jTextFieldYMVersion, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLabel21)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel12)
                    .addComponent(jTextFieldAttributes, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel13)
                    .addComponent(jTextFieldFrequencyComputer, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextFieldFrequencyPlayer, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel14)
                    .addComponent(jTextFieldLoop, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel22)
                    .addComponent(jTextFieldFutureData, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jTextFieldSamples, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel15))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel16)
                    .addComponent(jTextFieldSongName, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel17)
                    .addComponent(jTextFieldAuthor, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel18)
                    .addComponent(jTextFieldComment, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel19)
                    .addComponent(jComboBoxInterleaved, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap())
        );

        jComboBox1.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "50 Hz", "60 Hz" }));
        jComboBox1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBox1ActionPerformed(evt);
            }
        });

        jLabel20.setText("speed:");

        jCheckBoxDontCompress.setText("don't compress");
        jCheckBoxDontCompress.setToolTipText("If you don't compress, than only data files of pure YM data will be generated...");

        jCheckBoxCreatePlayer.setSelected(true);
        jCheckBoxCreatePlayer.setText("create player");

        jPanel4.setLayout(null);

        jTextField16a.setFont(new java.awt.Font("Courier New", 0, 12)); // NOI18N
        jTextField16a.setText("$00");
        jTextField16a.setToolTipText("double click rites value to PSG emulation");
        jTextField16a.setName("15"); // NOI18N
        jTextField16a.setPreferredSize(new java.awt.Dimension(30, 18));
        jTextField16a.setSize(new java.awt.Dimension(30, 18));
        jTextField16a.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextField1aFocusLost(evt);
            }
        });
        jTextField16a.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jTextField5aMouseClicked(evt);
            }
        });
        jTextField16a.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField1aActionPerformed(evt);
            }
        });
        jTextField16a.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyPressed(java.awt.event.KeyEvent evt) {
                jTextField1aKeyPressed(evt);
            }
        });
        jPanel4.add(jTextField16a);
        jTextField16a.setBounds(530, 0, 30, 18);

        jTextField1a.setBackground(new java.awt.Color(204, 204, 255));
        jTextField1a.setFont(new java.awt.Font("Courier New", 0, 12)); // NOI18N
        jTextField1a.setText("$00");
        jTextField1a.setToolTipText("double click rites value to PSG emulation");
        jTextField1a.setName("0"); // NOI18N
        jTextField1a.setPreferredSize(new java.awt.Dimension(30, 18));
        jTextField1a.setSize(new java.awt.Dimension(30, 18));
        jTextField1a.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextField1aFocusLost(evt);
            }
        });
        jTextField1a.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jTextField5aMouseClicked(evt);
            }
        });
        jTextField1a.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField1aActionPerformed(evt);
            }
        });
        jTextField1a.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyPressed(java.awt.event.KeyEvent evt) {
                jTextField1aKeyPressed(evt);
            }
        });
        jPanel4.add(jTextField1a);
        jTextField1a.setBounds(5, 0, 30, 18);

        jTextField2a.setBackground(new java.awt.Color(204, 204, 255));
        jTextField2a.setFont(new java.awt.Font("Courier New", 0, 12)); // NOI18N
        jTextField2a.setText("$00");
        jTextField2a.setToolTipText("double click rites value to PSG emulation");
        jTextField2a.setName("1"); // NOI18N
        jTextField2a.setPreferredSize(new java.awt.Dimension(30, 18));
        jTextField2a.setSize(new java.awt.Dimension(30, 18));
        jTextField2a.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextField1aFocusLost(evt);
            }
        });
        jTextField2a.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jTextField5aMouseClicked(evt);
            }
        });
        jTextField2a.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField1aActionPerformed(evt);
            }
        });
        jTextField2a.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyPressed(java.awt.event.KeyEvent evt) {
                jTextField1aKeyPressed(evt);
            }
        });
        jPanel4.add(jTextField2a);
        jTextField2a.setBounds(40, 0, 30, 18);

        jTextField3a.setBackground(new java.awt.Color(255, 204, 255));
        jTextField3a.setFont(new java.awt.Font("Courier New", 0, 12)); // NOI18N
        jTextField3a.setText("$00");
        jTextField3a.setToolTipText("double click rites value to PSG emulation");
        jTextField3a.setName("2"); // NOI18N
        jTextField3a.setPreferredSize(new java.awt.Dimension(30, 18));
        jTextField3a.setSize(new java.awt.Dimension(30, 18));
        jTextField3a.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextField1aFocusLost(evt);
            }
        });
        jTextField3a.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jTextField5aMouseClicked(evt);
            }
        });
        jTextField3a.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField1aActionPerformed(evt);
            }
        });
        jTextField3a.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyPressed(java.awt.event.KeyEvent evt) {
                jTextField1aKeyPressed(evt);
            }
        });
        jPanel4.add(jTextField3a);
        jTextField3a.setBounds(75, 0, 30, 18);

        jTextField4a.setBackground(new java.awt.Color(255, 204, 255));
        jTextField4a.setFont(new java.awt.Font("Courier New", 0, 12)); // NOI18N
        jTextField4a.setText("$00");
        jTextField4a.setToolTipText("double click rites value to PSG emulation");
        jTextField4a.setName("3"); // NOI18N
        jTextField4a.setPreferredSize(new java.awt.Dimension(30, 18));
        jTextField4a.setSize(new java.awt.Dimension(30, 18));
        jTextField4a.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextField1aFocusLost(evt);
            }
        });
        jTextField4a.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jTextField5aMouseClicked(evt);
            }
        });
        jTextField4a.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField1aActionPerformed(evt);
            }
        });
        jTextField4a.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyPressed(java.awt.event.KeyEvent evt) {
                jTextField1aKeyPressed(evt);
            }
        });
        jPanel4.add(jTextField4a);
        jTextField4a.setBounds(110, 0, 30, 18);

        jTextField5a.setBackground(new java.awt.Color(255, 204, 204));
        jTextField5a.setFont(new java.awt.Font("Courier New", 0, 12)); // NOI18N
        jTextField5a.setText("$00");
        jTextField5a.setToolTipText("double click rites value to PSG emulation");
        jTextField5a.setName("4"); // NOI18N
        jTextField5a.setPreferredSize(new java.awt.Dimension(30, 18));
        jTextField5a.setSize(new java.awt.Dimension(30, 18));
        jTextField5a.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextField1aFocusLost(evt);
            }
        });
        jTextField5a.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jTextField5aMouseClicked(evt);
            }
        });
        jTextField5a.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField1aActionPerformed(evt);
            }
        });
        jTextField5a.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyPressed(java.awt.event.KeyEvent evt) {
                jTextField1aKeyPressed(evt);
            }
        });
        jPanel4.add(jTextField5a);
        jTextField5a.setBounds(145, 0, 30, 18);

        jTextField6a.setBackground(new java.awt.Color(255, 204, 204));
        jTextField6a.setFont(new java.awt.Font("Courier New", 0, 12)); // NOI18N
        jTextField6a.setText("$00");
        jTextField6a.setToolTipText("double click rites value to PSG emulation");
        jTextField6a.setName("5"); // NOI18N
        jTextField6a.setPreferredSize(new java.awt.Dimension(30, 18));
        jTextField6a.setSize(new java.awt.Dimension(30, 18));
        jTextField6a.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextField1aFocusLost(evt);
            }
        });
        jTextField6a.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jTextField5aMouseClicked(evt);
            }
        });
        jTextField6a.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField1aActionPerformed(evt);
            }
        });
        jTextField6a.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyPressed(java.awt.event.KeyEvent evt) {
                jTextField1aKeyPressed(evt);
            }
        });
        jPanel4.add(jTextField6a);
        jTextField6a.setBounds(180, 0, 30, 18);

        jTextField7a.setBackground(new java.awt.Color(204, 204, 204));
        jTextField7a.setFont(new java.awt.Font("Courier New", 0, 12)); // NOI18N
        jTextField7a.setText("$00");
        jTextField7a.setToolTipText("double click rites value to PSG emulation");
        jTextField7a.setName("6"); // NOI18N
        jTextField7a.setPreferredSize(new java.awt.Dimension(30, 18));
        jTextField7a.setSize(new java.awt.Dimension(30, 18));
        jTextField7a.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextField1aFocusLost(evt);
            }
        });
        jTextField7a.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jTextField5aMouseClicked(evt);
            }
        });
        jTextField7a.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField1aActionPerformed(evt);
            }
        });
        jTextField7a.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyPressed(java.awt.event.KeyEvent evt) {
                jTextField1aKeyPressed(evt);
            }
        });
        jPanel4.add(jTextField7a);
        jTextField7a.setBounds(215, 0, 30, 18);

        jTextField8a.setFont(new java.awt.Font("Courier New", 0, 12)); // NOI18N
        jTextField8a.setText("$00");
        jTextField8a.setToolTipText("double click rites value to PSG emulation");
        jTextField8a.setName("7"); // NOI18N
        jTextField8a.setPreferredSize(new java.awt.Dimension(30, 18));
        jTextField8a.setSize(new java.awt.Dimension(30, 18));
        jTextField8a.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextField1aFocusLost(evt);
            }
        });
        jTextField8a.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jTextField5aMouseClicked(evt);
            }
        });
        jTextField8a.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField1aActionPerformed(evt);
            }
        });
        jTextField8a.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyPressed(java.awt.event.KeyEvent evt) {
                jTextField1aKeyPressed(evt);
            }
        });
        jPanel4.add(jTextField8a);
        jTextField8a.setBounds(250, 0, 30, 18);

        jTextField9a.setBackground(new java.awt.Color(204, 204, 255));
        jTextField9a.setFont(new java.awt.Font("Courier New", 0, 12)); // NOI18N
        jTextField9a.setText("$00");
        jTextField9a.setToolTipText("double click rites value to PSG emulation");
        jTextField9a.setName("8"); // NOI18N
        jTextField9a.setPreferredSize(new java.awt.Dimension(30, 18));
        jTextField9a.setSize(new java.awt.Dimension(30, 18));
        jTextField9a.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextField1aFocusLost(evt);
            }
        });
        jTextField9a.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jTextField5aMouseClicked(evt);
            }
        });
        jTextField9a.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField1aActionPerformed(evt);
            }
        });
        jTextField9a.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyPressed(java.awt.event.KeyEvent evt) {
                jTextField1aKeyPressed(evt);
            }
        });
        jPanel4.add(jTextField9a);
        jTextField9a.setBounds(285, 0, 30, 18);

        jTextField10a.setBackground(new java.awt.Color(255, 204, 255));
        jTextField10a.setFont(new java.awt.Font("Courier New", 0, 12)); // NOI18N
        jTextField10a.setText("$00");
        jTextField10a.setToolTipText("double click rites value to PSG emulation");
        jTextField10a.setName("9"); // NOI18N
        jTextField10a.setPreferredSize(new java.awt.Dimension(30, 18));
        jTextField10a.setSize(new java.awt.Dimension(30, 18));
        jTextField10a.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextField1aFocusLost(evt);
            }
        });
        jTextField10a.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jTextField5aMouseClicked(evt);
            }
        });
        jTextField10a.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField1aActionPerformed(evt);
            }
        });
        jTextField10a.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyPressed(java.awt.event.KeyEvent evt) {
                jTextField1aKeyPressed(evt);
            }
        });
        jPanel4.add(jTextField10a);
        jTextField10a.setBounds(320, 0, 30, 18);

        jTextField11a.setBackground(new java.awt.Color(255, 204, 204));
        jTextField11a.setFont(new java.awt.Font("Courier New", 0, 12)); // NOI18N
        jTextField11a.setText("$00");
        jTextField11a.setToolTipText("double click rites value to PSG emulation");
        jTextField11a.setName("10"); // NOI18N
        jTextField11a.setPreferredSize(new java.awt.Dimension(30, 18));
        jTextField11a.setSize(new java.awt.Dimension(30, 18));
        jTextField11a.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextField1aFocusLost(evt);
            }
        });
        jTextField11a.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jTextField5aMouseClicked(evt);
            }
        });
        jTextField11a.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField1aActionPerformed(evt);
            }
        });
        jTextField11a.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyPressed(java.awt.event.KeyEvent evt) {
                jTextField1aKeyPressed(evt);
            }
        });
        jPanel4.add(jTextField11a);
        jTextField11a.setBounds(355, 0, 30, 18);

        jTextField12a.setFont(new java.awt.Font("Courier New", 0, 12)); // NOI18N
        jTextField12a.setText("$00");
        jTextField12a.setToolTipText("double click rites value to PSG emulation");
        jTextField12a.setName("11"); // NOI18N
        jTextField12a.setPreferredSize(new java.awt.Dimension(30, 18));
        jTextField12a.setSize(new java.awt.Dimension(30, 18));
        jTextField12a.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextField1aFocusLost(evt);
            }
        });
        jTextField12a.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jTextField5aMouseClicked(evt);
            }
        });
        jTextField12a.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField1aActionPerformed(evt);
            }
        });
        jTextField12a.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyPressed(java.awt.event.KeyEvent evt) {
                jTextField1aKeyPressed(evt);
            }
        });
        jPanel4.add(jTextField12a);
        jTextField12a.setBounds(390, 0, 30, 18);

        jTextField13a.setFont(new java.awt.Font("Courier New", 0, 12)); // NOI18N
        jTextField13a.setText("$00");
        jTextField13a.setToolTipText("double click rites value to PSG emulation");
        jTextField13a.setName("12"); // NOI18N
        jTextField13a.setPreferredSize(new java.awt.Dimension(30, 18));
        jTextField13a.setSize(new java.awt.Dimension(30, 18));
        jTextField13a.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextField1aFocusLost(evt);
            }
        });
        jTextField13a.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jTextField5aMouseClicked(evt);
            }
        });
        jTextField13a.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField1aActionPerformed(evt);
            }
        });
        jTextField13a.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyPressed(java.awt.event.KeyEvent evt) {
                jTextField1aKeyPressed(evt);
            }
        });
        jPanel4.add(jTextField13a);
        jTextField13a.setBounds(425, 0, 30, 18);

        jTextField14a.setFont(new java.awt.Font("Courier New", 0, 12)); // NOI18N
        jTextField14a.setText("$00");
        jTextField14a.setToolTipText("double click rites value to PSG emulation");
        jTextField14a.setName("13"); // NOI18N
        jTextField14a.setPreferredSize(new java.awt.Dimension(30, 18));
        jTextField14a.setSize(new java.awt.Dimension(30, 18));
        jTextField14a.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextField1aFocusLost(evt);
            }
        });
        jTextField14a.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jTextField5aMouseClicked(evt);
            }
        });
        jTextField14a.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField1aActionPerformed(evt);
            }
        });
        jTextField14a.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyPressed(java.awt.event.KeyEvent evt) {
                jTextField1aKeyPressed(evt);
            }
        });
        jPanel4.add(jTextField14a);
        jTextField14a.setBounds(460, 0, 30, 18);

        jTextField15a.setFont(new java.awt.Font("Courier New", 0, 12)); // NOI18N
        jTextField15a.setText("$00");
        jTextField15a.setToolTipText("double click rites value to PSG emulation");
        jTextField15a.setName("14"); // NOI18N
        jTextField15a.setPreferredSize(new java.awt.Dimension(30, 18));
        jTextField15a.setSize(new java.awt.Dimension(30, 18));
        jTextField15a.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextField1aFocusLost(evt);
            }
        });
        jTextField15a.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jTextField5aMouseClicked(evt);
            }
        });
        jTextField15a.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField1aActionPerformed(evt);
            }
        });
        jTextField15a.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyPressed(java.awt.event.KeyEvent evt) {
                jTextField1aKeyPressed(evt);
            }
        });
        jPanel4.add(jTextField15a);
        jTextField15a.setBounds(495, 0, 30, 18);

        jButtonStop3.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/control_rewind_blue.png"))); // NOI18N
        jButtonStop3.setToolTipText("Rewind");
        jButtonStop3.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonStop3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonStop3ActionPerformed(evt);
            }
        });

        jCheckBoxNoiseA.setBackground(new java.awt.Color(204, 204, 255));
        jCheckBoxNoiseA.setFont(new java.awt.Font("Geneva", 0, 8)); // NOI18N
        jCheckBoxNoiseA.setSelected(true);
        jCheckBoxNoiseA.setText("A");
        jCheckBoxNoiseA.setHorizontalTextPosition(javax.swing.SwingConstants.LEADING);
        jCheckBoxNoiseA.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxNoiseAjCheckBox1ActionPerformed(evt);
            }
        });

        jCheckBoxNoiseB.setBackground(new java.awt.Color(255, 204, 255));
        jCheckBoxNoiseB.setFont(new java.awt.Font("Geneva", 0, 8)); // NOI18N
        jCheckBoxNoiseB.setSelected(true);
        jCheckBoxNoiseB.setText("B");
        jCheckBoxNoiseB.setHorizontalTextPosition(javax.swing.SwingConstants.LEADING);
        jCheckBoxNoiseB.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxNoiseBjCheckBox1ActionPerformed(evt);
            }
        });

        jCheckBoxNoiseC.setBackground(new java.awt.Color(255, 204, 204));
        jCheckBoxNoiseC.setFont(new java.awt.Font("Geneva", 0, 8)); // NOI18N
        jCheckBoxNoiseC.setSelected(true);
        jCheckBoxNoiseC.setText("C");
        jCheckBoxNoiseC.setHorizontalTextPosition(javax.swing.SwingConstants.LEADING);
        jCheckBoxNoiseC.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxNoiseCjCheckBox1ActionPerformed(evt);
            }
        });

        jCheckBoxToneC.setBackground(new java.awt.Color(255, 204, 204));
        jCheckBoxToneC.setSelected(true);
        jCheckBoxToneC.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxToneCjCheckBox1ActionPerformed(evt);
            }
        });

        jCheckBoxToneB.setBackground(new java.awt.Color(255, 204, 255));
        jCheckBoxToneB.setSelected(true);
        jCheckBoxToneB.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxToneBjCheckBox1ActionPerformed(evt);
            }
        });

        jCheckBoxToneA.setBackground(new java.awt.Color(204, 204, 255));
        jCheckBoxToneA.setSelected(true);
        jCheckBoxToneA.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxToneAjCheckBox1ActionPerformed(evt);
            }
        });

        jLabel1.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel1.setText("N  T");
        jLabel1.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel2.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel2.setText("o  o");
        jLabel2.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel3.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel3.setText("i  n");
        jLabel3.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel4.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel4.setText("s  e");
        jLabel4.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel5.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel5.setText("e");
        jLabel5.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel7.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel7.setText("e");
        jLabel7.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel8.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel8.setText("q");
        jLabel8.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel9.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel9.setText("F");
        jLabel9.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel23.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel23.setText("u");
        jLabel23.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel24.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel24.setText("r");
        jLabel24.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel25.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel25.setText("e");
        jLabel25.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel26.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel26.setText("c");
        jLabel26.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel27.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel27.setText("n");
        jLabel27.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel28.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel28.setText("e");
        jLabel28.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel30.setFont(new java.awt.Font("Geneva", 0, 8)); // NOI18N
        jLabel30.setText("A");
        jLabel30.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel29.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel29.setText("q");
        jLabel29.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel31.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel31.setText("F");
        jLabel31.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel32.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel32.setText("u");
        jLabel32.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel33.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel33.setText("r");
        jLabel33.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel34.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel34.setText("e");
        jLabel34.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel35.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel35.setText("c");
        jLabel35.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel36.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel36.setText("n");
        jLabel36.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel37.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel37.setText("e");
        jLabel37.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel38.setFont(new java.awt.Font("Geneva", 0, 8)); // NOI18N
        jLabel38.setText("B");
        jLabel38.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel39.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel39.setText("e");
        jLabel39.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel40.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel40.setText("e");
        jLabel40.setPreferredSize(new java.awt.Dimension(16, 10));

        jLabel41.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel41.setText("q");
        jLabel41.setPreferredSize(new java.awt.Dimension(16, 10));

        jLabel42.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel42.setText("F");
        jLabel42.setPreferredSize(new java.awt.Dimension(16, 10));

        jLabel43.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel43.setText("u");
        jLabel43.setPreferredSize(new java.awt.Dimension(16, 10));

        jLabel44.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel44.setText("r");
        jLabel44.setPreferredSize(new java.awt.Dimension(16, 10));

        jLabel45.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel45.setText("e");
        jLabel45.setPreferredSize(new java.awt.Dimension(16, 10));

        jLabel46.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel46.setText("c");
        jLabel46.setPreferredSize(new java.awt.Dimension(16, 10));

        jLabel47.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel47.setText("n");
        jLabel47.setPreferredSize(new java.awt.Dimension(16, 10));

        jLabel48.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel48.setText("e");
        jLabel48.setPreferredSize(new java.awt.Dimension(16, 10));

        jLabel49.setFont(new java.awt.Font("Geneva", 0, 8)); // NOI18N
        jLabel49.setText("C");
        jLabel49.setPreferredSize(new java.awt.Dimension(16, 10));

        jLabel50.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel50.setText("l");
        jLabel50.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel51.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel51.setText("A");
        jLabel51.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel52.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel52.setText("i");
        jLabel52.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel53.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel53.setText("m");
        jLabel53.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel54.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel54.setText("e");
        jLabel54.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel55.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel55.setText("d");
        jLabel55.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel56.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel56.setText("u");
        jLabel56.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel57.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel57.setText("t");
        jLabel57.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel58.setFont(new java.awt.Font("Geneva", 0, 8)); // NOI18N
        jLabel58.setText("A");
        jLabel58.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel59.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel59.setText("p");
        jLabel59.setPreferredSize(new java.awt.Dimension(24, 10));

        jSliderAmplidtudeA.setBackground(new java.awt.Color(204, 204, 255));
        jSliderAmplidtudeA.setMaximum(15);
        jSliderAmplidtudeA.setOrientation(javax.swing.JSlider.VERTICAL);
        jSliderAmplidtudeA.setPaintTicks(true);
        jSliderAmplidtudeA.setPaintTrack(false);
        jSliderAmplidtudeA.setToolTipText("amplitude values from 0 - 15");
        jSliderAmplidtudeA.setValue(0);
        jSliderAmplidtudeA.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderAmplidtudeAStateChanged(evt);
            }
        });

        jLabel60.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel60.setText("l");
        jLabel60.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel61.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel61.setText("A");
        jLabel61.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel62.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel62.setText("i");
        jLabel62.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel63.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel63.setText("m");
        jLabel63.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel64.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel64.setText("e");
        jLabel64.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel65.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel65.setText("d");
        jLabel65.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel66.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel66.setText("u");
        jLabel66.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel67.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel67.setText("t");
        jLabel67.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel68.setFont(new java.awt.Font("Geneva", 0, 8)); // NOI18N
        jLabel68.setText("B");
        jLabel68.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel69.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel69.setText("p");
        jLabel69.setPreferredSize(new java.awt.Dimension(24, 10));

        jSliderAmplidtudeB.setBackground(new java.awt.Color(255, 204, 255));
        jSliderAmplidtudeB.setMaximum(15);
        jSliderAmplidtudeB.setOrientation(javax.swing.JSlider.VERTICAL);
        jSliderAmplidtudeB.setPaintTicks(true);
        jSliderAmplidtudeB.setPaintTrack(false);
        jSliderAmplidtudeB.setToolTipText("amplitude values from 0 - 15");
        jSliderAmplidtudeB.setValue(0);
        jSliderAmplidtudeB.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderAmplidtudeBStateChanged(evt);
            }
        });

        jSliderAmplidtudeC.setBackground(new java.awt.Color(255, 204, 204));
        jSliderAmplidtudeC.setMaximum(15);
        jSliderAmplidtudeC.setOrientation(javax.swing.JSlider.VERTICAL);
        jSliderAmplidtudeC.setPaintTicks(true);
        jSliderAmplidtudeC.setPaintTrack(false);
        jSliderAmplidtudeC.setToolTipText("amplitude values from 0 - 15");
        jSliderAmplidtudeC.setValue(0);
        jSliderAmplidtudeC.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderAmplidtudeCStateChanged(evt);
            }
        });

        jLabel76.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel76.setText("u");
        jLabel76.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel70.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel70.setText("l");
        jLabel70.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel74.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel74.setText("e");
        jLabel74.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel71.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel71.setText("A");
        jLabel71.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel75.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel75.setText("d");
        jLabel75.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel79.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel79.setText("p");
        jLabel79.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel73.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel73.setText("m");
        jLabel73.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel77.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel77.setText("t");
        jLabel77.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel78.setFont(new java.awt.Font("Geneva", 0, 8)); // NOI18N
        jLabel78.setText("C");
        jLabel78.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel72.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel72.setText("i");
        jLabel72.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel80.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel80.setText("e r");
        jLabel80.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel81.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel81.setText("E C");
        jLabel81.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel82.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel82.setText("l s");
        jLabel82.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel83.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel83.setText("n o");
        jLabel83.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel84.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel84.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel85.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel85.setText("e");
        jLabel85.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel86.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel86.setText("p");
        jLabel86.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel87.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel87.setText("o e");
        jLabel87.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel88.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel88.setText("v a");
        jLabel88.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel89.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel89.setText("n i");
        jLabel89.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel91.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel91.setText("e");
        jLabel91.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel92.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel92.setText("p");
        jLabel92.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel93.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel93.setText("o ");
        jLabel93.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel94.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel94.setText("v n");
        jLabel94.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel95.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel95.setText("e e");
        jLabel95.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel96.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel96.setText("E F");
        jLabel96.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel97.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel97.setText("l ");
        jLabel97.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel98.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel98.setText("s");
        jLabel98.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel99.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel99.setText("N");
        jLabel99.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel100.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel100.setText("e");
        jLabel100.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel101.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel101.setText("o");
        jLabel101.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel102.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel102.setText("n");
        jLabel102.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel103.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel103.setText("e");
        jLabel103.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel104.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel104.setText("G");
        jLabel104.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel105.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel105.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel107.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel107.setText("i");
        jLabel107.setPreferredSize(new java.awt.Dimension(24, 10));

        jSliderNoise.setBackground(new java.awt.Color(204, 204, 204));
        jSliderNoise.setMaximum(31);
        jSliderNoise.setOrientation(javax.swing.JSlider.VERTICAL);
        jSliderNoise.setPaintTicks(true);
        jSliderNoise.setPaintTrack(false);
        jSliderNoise.setToolTipText("Noise period generator 0 - 31");
        jSliderNoise.setValue(0);
        jSliderNoise.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSliderNoiseStateChanged(evt);
            }
        });

        jLabel106.setFont(new java.awt.Font("Geneva", 0, 8)); // NOI18N
        jLabel106.setText("N");
        jLabel106.setPreferredSize(new java.awt.Dimension(16, 10));

        jComboBoxNotesA.setBackground(new java.awt.Color(204, 204, 255));
        jComboBoxNotesA.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "C#1" }));
        jComboBoxNotesA.setName("A"); // NOI18N
        jComboBoxNotesA.setPreferredSize(new java.awt.Dimension(59, 19));
        jComboBoxNotesA.setSize(new java.awt.Dimension(59, 19));
        jComboBoxNotesA.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBoxNotesAActionPerformed(evt);
            }
        });

        jComboBoxNotesB.setBackground(new java.awt.Color(255, 204, 255));
        jComboBoxNotesB.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "C#1" }));
        jComboBoxNotesB.setName("B"); // NOI18N
        jComboBoxNotesB.setPreferredSize(new java.awt.Dimension(59, 19));
        jComboBoxNotesB.setSize(new java.awt.Dimension(59, 19));
        jComboBoxNotesB.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBoxNotesBActionPerformed(evt);
            }
        });

        jComboBoxNotesC.setBackground(new java.awt.Color(255, 204, 204));
        jComboBoxNotesC.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "C#1" }));
        jComboBoxNotesC.setName("C"); // NOI18N
        jComboBoxNotesC.setPreferredSize(new java.awt.Dimension(59, 19));
        jComboBoxNotesC.setSize(new java.awt.Dimension(59, 19));
        jComboBoxNotesC.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBoxNotesCActionPerformed(evt);
            }
        });

        jCheckBoxModeA.setBackground(new java.awt.Color(204, 204, 255));
        jCheckBoxModeA.setToolTipText("Mode select");
        jCheckBoxModeA.setIconTextGap(0);
        jCheckBoxModeA.setMargin(new java.awt.Insets(0, 0, 0, 0));
        jCheckBoxModeA.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxModeAActionPerformed(evt);
            }
        });

        jCheckBoxModeB.setBackground(new java.awt.Color(204, 204, 255));
        jCheckBoxModeB.setToolTipText("Mode select");
        jCheckBoxModeB.setIconTextGap(0);
        jCheckBoxModeB.setMargin(new java.awt.Insets(0, 0, 0, 0));
        jCheckBoxModeB.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxModeBActionPerformed(evt);
            }
        });

        jCheckBoxModeC.setBackground(new java.awt.Color(204, 204, 255));
        jCheckBoxModeC.setToolTipText("Mode select");
        jCheckBoxModeC.setIconTextGap(0);
        jCheckBoxModeC.setMargin(new java.awt.Insets(0, 0, 0, 0));
        jCheckBoxModeC.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxModeCActionPerformed(evt);
            }
        });

        jLabel108.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel108.setText("E G");
        jLabel108.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel109.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel109.setText("o ");
        jLabel109.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel110.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel110.setText("p");
        jLabel110.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel111.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel111.setText("e");
        jLabel111.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel113.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel113.setText("n e");
        jLabel113.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel114.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel114.setText("e ");
        jLabel114.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel115.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel115.setText("v n");
        jLabel115.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel116.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel116.setText("l ");
        jLabel116.setPreferredSize(new java.awt.Dimension(24, 10));

        jComboBoxEnvelope.setModel(new DefaultComboBoxModel(envelopeItems));
        jComboBoxEnvelope.setPreferredSize(new java.awt.Dimension(59, 21));
        jComboBoxEnvelope.setSize(new java.awt.Dimension(59, 21));
        jComboBoxEnvelope.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBoxEnvelopeActionPerformed(evt);
            }
        });

        jLabel117.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel117.setText("O");
        jLabel117.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel118.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel118.setText("o");
        jLabel118.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel119.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel119.setText("I");
        jLabel119.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel120.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel120.setText("P");
        jLabel120.setToolTipText("");
        jLabel120.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel121.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel121.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel122.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel122.setText("r");
        jLabel122.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel123.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel123.setText("t");
        jLabel123.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel124.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel124.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel125.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel125.setText("A");
        jLabel125.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel126.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel126.setText("o");
        jLabel126.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel127.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel127.setText("O");
        jLabel127.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel128.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel128.setText("B");
        jLabel128.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel129.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel129.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel130.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel130.setText("t");
        jLabel130.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel131.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel131.setText("r");
        jLabel131.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel132.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel132.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel133.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel133.setText("P");
        jLabel133.setToolTipText("");
        jLabel133.setPreferredSize(new java.awt.Dimension(24, 10));

        jLabel134.setFont(new java.awt.Font("Courier New", 0, 10)); // NOI18N
        jLabel134.setText("I");
        jLabel134.setPreferredSize(new java.awt.Dimension(24, 10));

        javax.swing.GroupLayout jPanel5Layout = new javax.swing.GroupLayout(jPanel5);
        jPanel5.setLayout(jPanel5Layout);
        jPanel5Layout.setHorizontalGroup(
            jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel5Layout.createSequentialGroup()
                .addGap(10, 10, 10)
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                        .addComponent(jLabel27, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLabel28, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel25, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel26, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)))
                    .addComponent(jLabel30, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                        .addComponent(jLabel7, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLabel9, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLabel24, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel23, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel8, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE))))
                .addGap(0, 0, 0)
                .addComponent(jComboBoxNotesA, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(10, 10, 10)
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jLabel39, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel31, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel33, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                        .addComponent(jLabel32, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLabel29, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                        .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addComponent(jLabel36, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel37, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                .addComponent(jLabel34, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jLabel35, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)))
                        .addComponent(jLabel38, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addGap(0, 0, 0)
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jLabel40, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel42, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel44, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                        .addComponent(jLabel43, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLabel41, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel5Layout.createSequentialGroup()
                        .addComponent(jComboBoxNotesB, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(8, 8, 8)
                        .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                                .addComponent(jLabel47, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jLabel48, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jLabel45, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jLabel46, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)))
                            .addComponent(jLabel49, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE))))
                .addGap(0, 0, 0)
                .addComponent(jComboBoxNotesC, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(5, 5, 5)
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                        .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel104, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel105, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel102, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel103, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addComponent(jLabel107, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLabel99, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLabel101, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLabel100, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLabel98, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jLabel106, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addComponent(jSliderNoise, javax.swing.GroupLayout.PREFERRED_SIZE, 7, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(1, 1, 1)
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jLabel3, javax.swing.GroupLayout.PREFERRED_SIZE, 33, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel1, javax.swing.GroupLayout.PREFERRED_SIZE, 33, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel2, javax.swing.GroupLayout.PREFERRED_SIZE, 33, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                        .addComponent(jLabel5, javax.swing.GroupLayout.PREFERRED_SIZE, 33, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLabel4, javax.swing.GroupLayout.PREFERRED_SIZE, 33, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel5Layout.createSequentialGroup()
                        .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jCheckBoxNoiseC, javax.swing.GroupLayout.Alignment.TRAILING)
                            .addComponent(jCheckBoxNoiseB, javax.swing.GroupLayout.Alignment.TRAILING)
                            .addComponent(jCheckBoxNoiseA, javax.swing.GroupLayout.Alignment.TRAILING))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jCheckBoxToneB)
                            .addComponent(jCheckBoxToneC)
                            .addComponent(jCheckBoxToneA))))
                .addGap(5, 5, 5)
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel5Layout.createSequentialGroup()
                        .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                .addComponent(jLabel56, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jLabel57, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jLabel54, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jLabel55, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addComponent(jLabel59, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel51, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel53, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel52, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel50, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(0, 0, 0)
                        .addComponent(jSliderAmplidtudeA, javax.swing.GroupLayout.PREFERRED_SIZE, 7, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel5Layout.createSequentialGroup()
                        .addComponent(jLabel58, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(0, 0, 0)
                        .addComponent(jCheckBoxModeA)))
                .addGap(6, 6, 6)
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jLabel68, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                        .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel66, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel67, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel64, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel65, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addComponent(jLabel69, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLabel61, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLabel63, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLabel62, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLabel60, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addGap(0, 0, 0)
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jSliderAmplidtudeB, javax.swing.GroupLayout.PREFERRED_SIZE, 7, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jCheckBoxModeB))
                .addGap(6, 6, 6)
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel5Layout.createSequentialGroup()
                        .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                .addComponent(jLabel76, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jLabel77, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jLabel74, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jLabel75, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addComponent(jLabel79, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel71, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel73, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel72, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel70, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(0, 0, 0)
                        .addComponent(jSliderAmplidtudeC, javax.swing.GroupLayout.PREFERRED_SIZE, 7, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(16, 16, 16)
                        .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addComponent(jLabel86, javax.swing.GroupLayout.PREFERRED_SIZE, 33, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel87, javax.swing.GroupLayout.PREFERRED_SIZE, 33, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                .addComponent(jLabel84, javax.swing.GroupLayout.PREFERRED_SIZE, 33, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jLabel85, javax.swing.GroupLayout.PREFERRED_SIZE, 33, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addComponent(jLabel88, javax.swing.GroupLayout.PREFERRED_SIZE, 33, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel81, javax.swing.GroupLayout.PREFERRED_SIZE, 33, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel83, javax.swing.GroupLayout.PREFERRED_SIZE, 33, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                .addComponent(jLabel82, javax.swing.GroupLayout.PREFERRED_SIZE, 33, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jLabel80, javax.swing.GroupLayout.PREFERRED_SIZE, 33, javax.swing.GroupLayout.PREFERRED_SIZE))))
                    .addGroup(jPanel5Layout.createSequentialGroup()
                        .addComponent(jLabel78, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(0, 0, 0)
                        .addComponent(jCheckBoxModeC)))
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel5Layout.createSequentialGroup()
                        .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addComponent(jLabel92, javax.swing.GroupLayout.PREFERRED_SIZE, 33, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel93, javax.swing.GroupLayout.PREFERRED_SIZE, 33, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel91, javax.swing.GroupLayout.PREFERRED_SIZE, 33, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel94, javax.swing.GroupLayout.PREFERRED_SIZE, 33, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel96, javax.swing.GroupLayout.PREFERRED_SIZE, 33, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel89, javax.swing.GroupLayout.PREFERRED_SIZE, 33, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                .addComponent(jLabel97, javax.swing.GroupLayout.PREFERRED_SIZE, 33, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jLabel95, javax.swing.GroupLayout.PREFERRED_SIZE, 33, javax.swing.GroupLayout.PREFERRED_SIZE)))
                        .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addComponent(jLabel110, javax.swing.GroupLayout.PREFERRED_SIZE, 33, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel109, javax.swing.GroupLayout.PREFERRED_SIZE, 33, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel111, javax.swing.GroupLayout.PREFERRED_SIZE, 33, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel115, javax.swing.GroupLayout.PREFERRED_SIZE, 33, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel108, javax.swing.GroupLayout.PREFERRED_SIZE, 33, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel113, javax.swing.GroupLayout.PREFERRED_SIZE, 33, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                .addComponent(jLabel116, javax.swing.GroupLayout.PREFERRED_SIZE, 33, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jLabel114, javax.swing.GroupLayout.PREFERRED_SIZE, 33, javax.swing.GroupLayout.PREFERRED_SIZE))))
                    .addGroup(jPanel5Layout.createSequentialGroup()
                        .addGap(26, 26, 26)
                        .addComponent(jComboBoxEnvelope, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addGap(10, 10, 10)
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jLabel121, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel119, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel117, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                        .addComponent(jLabel118, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLabel120, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jLabel123, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel122, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                        .addComponent(jLabel125, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLabel124, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addGap(18, 18, 18)
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jLabel132, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel134, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel127, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                        .addComponent(jLabel126, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLabel133, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jLabel130, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel131, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                        .addComponent(jLabel128, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLabel129, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel5Layout.setVerticalGroup(
            jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel5Layout.createSequentialGroup()
                    .addComponent(jLabel9, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGap(0, 0, 0)
                    .addComponent(jLabel24, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGap(0, 0, 0)
                    .addComponent(jLabel7, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGap(0, 0, 0)
                    .addComponent(jLabel8, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGap(0, 0, 0)
                    .addComponent(jLabel23, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGap(0, 0, 0)
                    .addComponent(jLabel28, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGap(0, 0, 0)
                    .addComponent(jLabel27, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGap(0, 0, 0)
                    .addComponent(jLabel26, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGap(0, 0, 0)
                    .addComponent(jLabel25, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGap(5, 5, 5)
                    .addComponent(jLabel30, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addComponent(jComboBoxNotesA, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
            .addGroup(jPanel5Layout.createSequentialGroup()
                .addComponent(jLabel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jLabel2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jLabel3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jLabel4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jLabel5, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jCheckBoxNoiseA)
                    .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                        .addComponent(jLabel58, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGroup(jPanel5Layout.createSequentialGroup()
                            .addComponent(jCheckBoxToneA)
                            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                            .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                .addGroup(jPanel5Layout.createSequentialGroup()
                                    .addComponent(jCheckBoxNoiseB)
                                    .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                    .addComponent(jCheckBoxNoiseC))
                                .addGroup(jPanel5Layout.createSequentialGroup()
                                    .addComponent(jCheckBoxToneB)
                                    .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                    .addComponent(jCheckBoxToneC))))
                        .addComponent(jCheckBoxModeA)
                        .addComponent(jLabel68, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jCheckBoxModeB))))
            .addGroup(jPanel5Layout.createSequentialGroup()
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addGroup(jPanel5Layout.createSequentialGroup()
                        .addComponent(jLabel71, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(0, 0, 0)
                        .addComponent(jLabel73, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(0, 0, 0)
                        .addComponent(jLabel79, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(0, 0, 0)
                        .addComponent(jLabel70, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(0, 0, 0)
                        .addComponent(jLabel72, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(0, 0, 0)
                        .addComponent(jLabel77, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(0, 0, 0)
                        .addComponent(jLabel76, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(0, 0, 0)
                        .addComponent(jLabel75, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jSliderAmplidtudeC, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE))
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(jPanel5Layout.createSequentialGroup()
                        .addComponent(jLabel74, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(3, 3, 3)
                        .addComponent(jLabel78, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jCheckBoxModeC)))
            .addGroup(jPanel5Layout.createSequentialGroup()
                .addComponent(jLabel81, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jLabel83, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jLabel88, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jLabel80, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jLabel82, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jLabel87, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jLabel86, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jLabel85, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jLabel84, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
            .addGroup(jPanel5Layout.createSequentialGroup()
                .addComponent(jLabel99, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jLabel101, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jLabel107, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jLabel98, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jLabel100, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jLabel105, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jLabel104, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jLabel103, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jLabel102, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabel106, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
            .addComponent(jSliderNoise, javax.swing.GroupLayout.PREFERRED_SIZE, 108, javax.swing.GroupLayout.PREFERRED_SIZE)
            .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                .addComponent(jComboBoxNotesC, javax.swing.GroupLayout.PREFERRED_SIZE, 19, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGroup(jPanel5Layout.createSequentialGroup()
                    .addComponent(jLabel42, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGap(0, 0, 0)
                    .addComponent(jLabel44, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGap(0, 0, 0)
                    .addComponent(jLabel40, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGap(0, 0, 0)
                    .addComponent(jLabel41, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGap(0, 0, 0)
                    .addComponent(jLabel43, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGap(0, 0, 0)
                    .addComponent(jLabel48, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGap(0, 0, 0)
                    .addComponent(jLabel47, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGap(0, 0, 0)
                    .addComponent(jLabel46, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGap(0, 0, 0)
                    .addComponent(jLabel45, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGap(5, 5, 5)
                    .addComponent(jLabel49, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
            .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                .addComponent(jComboBoxNotesB, javax.swing.GroupLayout.PREFERRED_SIZE, 19, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGroup(jPanel5Layout.createSequentialGroup()
                    .addComponent(jLabel31, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGap(0, 0, 0)
                    .addComponent(jLabel33, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGap(0, 0, 0)
                    .addComponent(jLabel39, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGap(0, 0, 0)
                    .addComponent(jLabel29, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGap(0, 0, 0)
                    .addComponent(jLabel32, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGap(0, 0, 0)
                    .addComponent(jLabel37, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGap(0, 0, 0)
                    .addComponent(jLabel36, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGap(0, 0, 0)
                    .addComponent(jLabel35, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGap(0, 0, 0)
                    .addComponent(jLabel34, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGap(5, 5, 5)
                    .addComponent(jLabel38, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
            .addGroup(jPanel5Layout.createSequentialGroup()
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addGroup(jPanel5Layout.createSequentialGroup()
                        .addComponent(jLabel51, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(0, 0, 0)
                        .addComponent(jLabel53, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(0, 0, 0)
                        .addComponent(jLabel59, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(0, 0, 0)
                        .addComponent(jLabel50, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(0, 0, 0)
                        .addComponent(jLabel52, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(0, 0, 0)
                        .addComponent(jLabel57, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(0, 0, 0)
                        .addComponent(jLabel56, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(0, 0, 0)
                        .addComponent(jLabel55, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jSliderAmplidtudeA, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE))
                .addGap(0, 0, 0)
                .addComponent(jLabel54, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
            .addGroup(jPanel5Layout.createSequentialGroup()
                .addComponent(jLabel61, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jLabel63, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jLabel69, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jLabel60, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jLabel62, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jLabel67, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jLabel66, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jLabel65, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jLabel64, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
            .addComponent(jSliderAmplidtudeB, javax.swing.GroupLayout.PREFERRED_SIZE, 80, javax.swing.GroupLayout.PREFERRED_SIZE)
            .addGroup(jPanel5Layout.createSequentialGroup()
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel5Layout.createSequentialGroup()
                        .addComponent(jLabel96, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(0, 0, 0)
                        .addComponent(jLabel89, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(0, 0, 0)
                        .addComponent(jLabel94, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(0, 0, 0)
                        .addComponent(jLabel95, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(0, 0, 0)
                        .addComponent(jLabel97, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(0, 0, 0)
                        .addComponent(jLabel93, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(0, 0, 0)
                        .addComponent(jLabel92, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(0, 0, 0)
                        .addComponent(jLabel91, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel5Layout.createSequentialGroup()
                        .addComponent(jLabel108, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(0, 0, 0)
                        .addComponent(jLabel113, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(0, 0, 0)
                        .addComponent(jLabel115, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(0, 0, 0)
                        .addComponent(jLabel114, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(0, 0, 0)
                        .addComponent(jLabel116, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(0, 0, 0)
                        .addComponent(jLabel109, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(0, 0, 0)
                        .addComponent(jLabel110, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(0, 0, 0)
                        .addComponent(jLabel111, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jComboBoxEnvelope, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
            .addGroup(jPanel5Layout.createSequentialGroup()
                .addComponent(jLabel119, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jLabel117, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jLabel121, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jLabel120, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jLabel118, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jLabel122, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jLabel123, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jLabel124, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jLabel125, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
            .addGroup(jPanel5Layout.createSequentialGroup()
                .addComponent(jLabel134, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jLabel127, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jLabel132, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jLabel133, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jLabel126, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jLabel131, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jLabel130, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jLabel129, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jLabel128, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
        );

        jButtonAddRow.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/add.png"))); // NOI18N
        jButtonAddRow.setToolTipText("add one register line befor selection");
        jButtonAddRow.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonAddRow.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonAddRowActionPerformed(evt);
            }
        });

        jButtonCopy.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/page_copy.png"))); // NOI18N
        jButtonCopy.setToolTipText("Copy");
        jButtonCopy.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonCopy.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonCopyActionPerformed(evt);
            }
        });

        jButtonPaste.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/paste_plain.png"))); // NOI18N
        jButtonPaste.setToolTipText("Paste");
        jButtonPaste.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonPaste.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonPasteActionPerformed(evt);
            }
        });

        jButtonLoad.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/page_go.png"))); // NOI18N
        jButtonLoad.setToolTipText("load YM");
        jButtonLoad.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonLoad.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonLoadActionPerformed(evt);
            }
        });

        jButtonSave.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/page_save.png"))); // NOI18N
        jButtonSave.setToolTipText("Save as YM");
        jButtonSave.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonSave.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSaveActionPerformed(evt);
            }
        });

        jButtonInsertYM.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/page_add.png"))); // NOI18N
        jButtonInsertYM.setToolTipText("insert YM file");
        jButtonInsertYM.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonInsertYM.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonInsertYMActionPerformed(evt);
            }
        });

        jButtonSaveSelection.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/page_edit.png"))); // NOI18N
        jButtonSaveSelection.setToolTipText("save selection as YM");
        jButtonSaveSelection.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonSaveSelection.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSaveSelectionActionPerformed(evt);
            }
        });

        jButtonNewYM.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/new.png"))); // NOI18N
        jButtonNewYM.setToolTipText("new YM window");
        jButtonNewYM.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonNewYM.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonNewYMActionPerformed(evt);
            }
        });

        jLabel90.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/vedi/sound/psgkleiner.png"))); // NOI18N

        jLabelPSG0.setFont(new java.awt.Font("Courier New", 0, 12)); // NOI18N
        jLabelPSG0.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLabelPSG0.setText("$01");

        jLabelPSG1.setFont(new java.awt.Font("Courier New", 0, 12)); // NOI18N
        jLabelPSG1.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLabelPSG1.setText("$01");

        jLabelPSG3.setFont(new java.awt.Font("Courier New", 0, 12)); // NOI18N
        jLabelPSG3.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLabelPSG3.setText("$01");

        jLabelPSG2.setFont(new java.awt.Font("Courier New", 0, 12)); // NOI18N
        jLabelPSG2.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLabelPSG2.setText("$01");

        jLabelPSG5.setFont(new java.awt.Font("Courier New", 0, 12)); // NOI18N
        jLabelPSG5.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLabelPSG5.setText("$01");

        jLabelPSG4.setFont(new java.awt.Font("Courier New", 0, 12)); // NOI18N
        jLabelPSG4.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLabelPSG4.setText("$01");

        jLabelPSG6.setFont(new java.awt.Font("Courier New", 0, 12)); // NOI18N
        jLabelPSG6.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLabelPSG6.setText("$01");

        jLabelPSG7.setFont(new java.awt.Font("Courier New", 0, 12)); // NOI18N
        jLabelPSG7.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLabelPSG7.setText("$01");

        jLabelPSG8.setFont(new java.awt.Font("Courier New", 0, 12)); // NOI18N
        jLabelPSG8.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLabelPSG8.setText("$01");

        jLabelPSG9.setFont(new java.awt.Font("Courier New", 0, 12)); // NOI18N
        jLabelPSG9.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLabelPSG9.setText("$01");

        jLabelPSG10.setFont(new java.awt.Font("Courier New", 0, 12)); // NOI18N
        jLabelPSG10.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLabelPSG10.setText("$01");

        jLabelPSG11.setFont(new java.awt.Font("Courier New", 0, 12)); // NOI18N
        jLabelPSG11.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLabelPSG11.setText("$01");

        jLabelPSG15.setFont(new java.awt.Font("Courier New", 0, 12)); // NOI18N
        jLabelPSG15.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLabelPSG15.setText("$01");

        jLabelPSG14.setFont(new java.awt.Font("Courier New", 0, 12)); // NOI18N
        jLabelPSG14.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLabelPSG14.setText("$01");

        jLabelPSG13.setFont(new java.awt.Font("Courier New", 0, 12)); // NOI18N
        jLabelPSG13.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLabelPSG13.setText("$01");

        jLabelPSG12.setFont(new java.awt.Font("Courier New", 0, 12)); // NOI18N
        jLabelPSG12.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLabelPSG12.setText("$01");

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addComponent(jLabel90)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jLabelPSG0, javax.swing.GroupLayout.PREFERRED_SIZE, 29, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabelPSG1, javax.swing.GroupLayout.PREFERRED_SIZE, 29, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabelPSG2, javax.swing.GroupLayout.PREFERRED_SIZE, 29, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabelPSG3, javax.swing.GroupLayout.PREFERRED_SIZE, 29, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabelPSG4, javax.swing.GroupLayout.PREFERRED_SIZE, 29, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabelPSG5, javax.swing.GroupLayout.PREFERRED_SIZE, 29, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabelPSG6, javax.swing.GroupLayout.PREFERRED_SIZE, 29, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabelPSG7, javax.swing.GroupLayout.PREFERRED_SIZE, 29, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabelPSG8, javax.swing.GroupLayout.PREFERRED_SIZE, 29, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabelPSG9, javax.swing.GroupLayout.PREFERRED_SIZE, 29, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabelPSG10, javax.swing.GroupLayout.PREFERRED_SIZE, 29, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabelPSG11, javax.swing.GroupLayout.PREFERRED_SIZE, 29, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabelPSG12, javax.swing.GroupLayout.PREFERRED_SIZE, 29, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabelPSG13, javax.swing.GroupLayout.PREFERRED_SIZE, 29, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabelPSG14, javax.swing.GroupLayout.PREFERRED_SIZE, 29, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabelPSG15, javax.swing.GroupLayout.PREFERRED_SIZE, 29, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 24, Short.MAX_VALUE))
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel90)
                    .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jLabelPSG12)
                        .addComponent(jLabelPSG13)
                        .addComponent(jLabelPSG14)
                        .addComponent(jLabelPSG15))
                    .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jLabelPSG6)
                        .addComponent(jLabelPSG7)
                        .addComponent(jLabelPSG8)
                        .addComponent(jLabelPSG9)
                        .addComponent(jLabelPSG10)
                        .addComponent(jLabelPSG11))
                    .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jLabelPSG0)
                        .addComponent(jLabelPSG1)
                        .addComponent(jLabelPSG2)
                        .addComponent(jLabelPSG3)
                        .addComponent(jLabelPSG4)
                        .addComponent(jLabelPSG5)))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );

        jPanel6.setBackground(new java.awt.Color(255, 204, 204));
        jPanel6.setBorder(javax.swing.BorderFactory.createTitledBorder("Channel C - AYFX"));

        jButtonLoad1.setBackground(new java.awt.Color(204, 204, 255));
        jButtonLoad1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/page_go.png"))); // NOI18N
        jButtonLoad1.setToolTipText("load AFX to pos");
        jButtonLoad1.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonLoad1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonLoad1ActionPerformed(evt);
            }
        });

        jButtonSave1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/page_save.png"))); // NOI18N
        jButtonSave1.setToolTipText("save as AYFX");
        jButtonSave1.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonSave1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSave1ActionPerformed(evt);
            }
        });

        jCheckBox19.setBackground(new java.awt.Color(255, 204, 204));
        jCheckBox19.setText("only selection");
        jCheckBox19.setToolTipText("save only selection");

        jCheckBox22.setBackground(new java.awt.Color(255, 204, 204));
        jCheckBox22.setText("overwrite");
        jCheckBox22.setToolTipText("load ... or insert (new rows)");

        javax.swing.GroupLayout jPanel6Layout = new javax.swing.GroupLayout(jPanel6);
        jPanel6.setLayout(jPanel6Layout);
        jPanel6Layout.setHorizontalGroup(
            jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel6Layout.createSequentialGroup()
                .addComponent(jButtonLoad1)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonSave1)
                .addGap(0, 0, Short.MAX_VALUE))
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel6Layout.createSequentialGroup()
                .addGap(0, 0, Short.MAX_VALUE)
                .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jCheckBox22, javax.swing.GroupLayout.PREFERRED_SIZE, 87, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jCheckBox19, javax.swing.GroupLayout.PREFERRED_SIZE, 105, javax.swing.GroupLayout.PREFERRED_SIZE)))
        );
        jPanel6Layout.setVerticalGroup(
            jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel6Layout.createSequentialGroup()
                .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jButtonLoad1)
                    .addComponent(jButtonSave1))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(jCheckBox22)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox19)
                .addContainerGap())
        );

        jPanel7.setBackground(new java.awt.Color(204, 204, 255));
        jPanel7.setBorder(javax.swing.BorderFactory.createTitledBorder("Channel A - AYFX"));

        jButtonLoad2.setBackground(new java.awt.Color(204, 204, 255));
        jButtonLoad2.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/page_go.png"))); // NOI18N
        jButtonLoad2.setToolTipText("load AFX to pos");
        jButtonLoad2.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonLoad2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonLoad2ActionPerformed(evt);
            }
        });

        jButtonSave2.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/page_save.png"))); // NOI18N
        jButtonSave2.setToolTipText("save as AYFX");
        jButtonSave2.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonSave2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSave2ActionPerformed(evt);
            }
        });

        jCheckBox17.setBackground(new java.awt.Color(204, 204, 255));
        jCheckBox17.setText("only selection");
        jCheckBox17.setToolTipText("save only selection");

        jCheckBox20.setBackground(new java.awt.Color(204, 204, 255));
        jCheckBox20.setText("overwrite");
        jCheckBox20.setToolTipText("load ... or insert (new rows)");

        javax.swing.GroupLayout jPanel7Layout = new javax.swing.GroupLayout(jPanel7);
        jPanel7.setLayout(jPanel7Layout);
        jPanel7Layout.setHorizontalGroup(
            jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel7Layout.createSequentialGroup()
                .addComponent(jButtonLoad2)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonSave2)
                .addGap(0, 0, Short.MAX_VALUE))
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel7Layout.createSequentialGroup()
                .addGap(0, 0, Short.MAX_VALUE)
                .addGroup(jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jCheckBox20, javax.swing.GroupLayout.PREFERRED_SIZE, 87, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jCheckBox17, javax.swing.GroupLayout.PREFERRED_SIZE, 105, javax.swing.GroupLayout.PREFERRED_SIZE)))
        );
        jPanel7Layout.setVerticalGroup(
            jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel7Layout.createSequentialGroup()
                .addGroup(jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jButtonLoad2)
                    .addComponent(jButtonSave2))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(jCheckBox20)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox17)
                .addContainerGap())
        );

        jPanel8.setBackground(new java.awt.Color(255, 204, 255));
        jPanel8.setBorder(javax.swing.BorderFactory.createTitledBorder("Channel B - AYFX"));

        jButtonLoad3.setBackground(new java.awt.Color(204, 204, 255));
        jButtonLoad3.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/page_go.png"))); // NOI18N
        jButtonLoad3.setToolTipText("load AFX to pos");
        jButtonLoad3.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonLoad3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonLoad3ActionPerformed(evt);
            }
        });

        jButtonSave3.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/page_save.png"))); // NOI18N
        jButtonSave3.setToolTipText("save as AYFX");
        jButtonSave3.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonSave3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSave3ActionPerformed(evt);
            }
        });

        jCheckBox18.setBackground(new java.awt.Color(255, 204, 255));
        jCheckBox18.setText("only selection");
        jCheckBox18.setToolTipText("save only selection");

        jCheckBox21.setBackground(new java.awt.Color(255, 204, 255));
        jCheckBox21.setText("overwrite");
        jCheckBox21.setToolTipText("load ... or insert (new rows)");

        javax.swing.GroupLayout jPanel8Layout = new javax.swing.GroupLayout(jPanel8);
        jPanel8.setLayout(jPanel8Layout);
        jPanel8Layout.setHorizontalGroup(
            jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel8Layout.createSequentialGroup()
                .addComponent(jButtonLoad3)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonSave3)
                .addGap(0, 0, Short.MAX_VALUE))
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel8Layout.createSequentialGroup()
                .addGap(0, 0, Short.MAX_VALUE)
                .addGroup(jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jCheckBox21, javax.swing.GroupLayout.PREFERRED_SIZE, 87, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jCheckBox18, javax.swing.GroupLayout.PREFERRED_SIZE, 105, javax.swing.GroupLayout.PREFERRED_SIZE)))
        );
        jPanel8Layout.setVerticalGroup(
            jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel8Layout.createSequentialGroup()
                .addGroup(jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jButtonLoad3)
                    .addComponent(jButtonSave3))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(jCheckBox21)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox18)
                .addContainerGap())
        );

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jScrollPane2, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGroup(layout.createSequentialGroup()
                                .addContainerGap()
                                .addComponent(jButtonAddRow))
                            .addComponent(jButtonCopy)
                            .addComponent(jButtonPaste)
                            .addComponent(jButtonCut)
                            .addGroup(layout.createSequentialGroup()
                                .addComponent(jButtonInsertYM)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jButtonSaveSelection)))
                        .addGap(0, 0, 0)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 583, Short.MAX_VALUE)
                            .addComponent(jPanel4, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jPanel3, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jPanel5, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                    .addComponent(jPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jCheckBoxDontCompress)
                    .addComponent(jCheckBoxCreatePlayer)
                    .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                        .addGroup(layout.createSequentialGroup()
                            .addComponent(jButtonCreate, javax.swing.GroupLayout.PREFERRED_SIZE, 110, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGap(198, 198, 198)
                            .addComponent(jButtonCancel))
                        .addComponent(jPanel2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGroup(layout.createSequentialGroup()
                            .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                                .addComponent(jLabel6, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGroup(layout.createSequentialGroup()
                                    .addComponent(jButtonPlaySample)
                                    .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                    .addComponent(jButtonStop2)))
                            .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                .addGroup(layout.createSequentialGroup()
                                    .addGap(30, 30, 30)
                                    .addComponent(jButtonStop3)
                                    .addGap(53, 53, 53)
                                    .addComponent(jButtonLoad)
                                    .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                    .addComponent(jButtonSave)
                                    .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                    .addComponent(jButtonNewYM)
                                    .addGap(22, 22, 22)
                                    .addComponent(jLabel20, javax.swing.GroupLayout.PREFERRED_SIZE, 48, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                    .addComponent(jComboBox1, javax.swing.GroupLayout.PREFERRED_SIZE, 69, javax.swing.GroupLayout.PREFERRED_SIZE))
                                .addGroup(layout.createSequentialGroup()
                                    .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                    .addComponent(jLabel10, javax.swing.GroupLayout.PREFERRED_SIZE, 226, javax.swing.GroupLayout.PREFERRED_SIZE)))))
                    .addGroup(layout.createSequentialGroup()
                        .addGap(6, 6, 6)
                        .addComponent(jPanel7, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jPanel8, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jPanel6, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGap(3, 3, 3)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jPanel5, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGroup(layout.createSequentialGroup()
                                .addComponent(jButtonCopy)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jButtonPaste)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jButtonCut)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jButtonInsertYM)
                                    .addComponent(jButtonSaveSelection))))
                        .addGap(0, 0, 0)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(layout.createSequentialGroup()
                                .addComponent(jPanel4, javax.swing.GroupLayout.PREFERRED_SIZE, 18, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(0, 0, 0)
                                .addComponent(jPanel3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(0, 0, 0)
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE)
                                    .addComponent(jScrollPane2, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE)))
                            .addComponent(jButtonAddRow)))
                    .addGroup(layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel6, javax.swing.GroupLayout.PREFERRED_SIZE, 15, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel10, javax.swing.GroupLayout.PREFERRED_SIZE, 15, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                .addComponent(jButtonStop2)
                                .addComponent(jButtonPlaySample)
                                .addComponent(jLabel20, javax.swing.GroupLayout.PREFERRED_SIZE, 20, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jButtonStop3)
                                .addComponent(jButtonLoad)
                                .addComponent(jButtonSave)
                                .addComponent(jButtonNewYM))
                            .addComponent(jComboBox1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(7, 7, 7)
                        .addComponent(jPanel2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jCheckBoxDontCompress)
                        .addGap(4, 4, 4)
                        .addComponent(jCheckBoxCreatePlayer)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jButtonCreate)
                            .addComponent(jButtonCancel))
                        .addGap(18, 18, 18)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jPanel7, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jPanel8, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jPanel6, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, 20, javax.swing.GroupLayout.PREFERRED_SIZE))
        );
    }// </editor-fold>//GEN-END:initComponents

    void updateCheckBoxes()
    {
        usedRegs[0] = jCheckBox1.isSelected();
        usedRegs[1] = jCheckBox2.isSelected();
        usedRegs[2] = jCheckBox3.isSelected();
        usedRegs[3] = jCheckBox4.isSelected();
        usedRegs[4] = jCheckBox5.isSelected();
        usedRegs[5] = jCheckBox6.isSelected();
        usedRegs[6] = jCheckBox7.isSelected();
        usedRegs[7] = jCheckBox8.isSelected();
        usedRegs[8] = jCheckBox9.isSelected();
        usedRegs[9] = jCheckBox10.isSelected();
        usedRegs[10] = jCheckBox11.isSelected();
        usedRegs[11] = jCheckBox12.isSelected();
        usedRegs[12] = jCheckBox13.isSelected();
        usedRegs[13] = jCheckBox14.isSelected();
        usedRegs[14] = jCheckBox15.isSelected();
        usedRegs[15] = jCheckBox16.isSelected();
    }
    
    private void jButtonCancelActionPerformed(ActionEvent evt) {//GEN-FIRST:event_jButtonCancelActionPerformed
       ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).removePanel(this);
        if (tinyLog instanceof VediPanel)
        {
            ((VediPanel)tinyLog).returnFromYMPanel(false);
        }
    }//GEN-LAST:event_jButtonCancelActionPerformed

    
    private void jButtonCreateActionPerformed(ActionEvent evt) {//GEN-FIRST:event_jButtonCreateActionPerformed
        doYM_part1();
    }//GEN-LAST:event_jButtonCreateActionPerformed

    long loopStart = -1;
    long loopEnd = -1;
    private void jButtonPlaySampleActionPerformed(ActionEvent evt) {//GEN-FIRST:event_jButtonPlaySampleActionPerformed

        loopStart = -1;
        loopEnd = -1;
        int[] rows = jTable1.getSelectedRows();
        if (rows.length >1)
        {
            loopStart = rows[0];
            loopEnd = rows[rows.length-1];
        }
        startYM();
    }//GEN-LAST:event_jButtonPlaySampleActionPerformed

    private void jButtonCutActionPerformed(ActionEvent evt) {//GEN-FIRST:event_jButtonCutActionPerformed
        jButtonCopyActionPerformed(null);
        int[] rows = jTable1.getSelectedRows();
        for (int i=rows.length-1; i>=0; i--)
        {
            ymSound.deleteVBL(rows[i]);
        }
        jTable1.tableChanged(null);
        jTable2.tableChanged(null);
    }//GEN-LAST:event_jButtonCutActionPerformed

    private void jButtonStop2ActionPerformed(ActionEvent evt) {//GEN-FIRST:event_jButtonStop2ActionPerformed
        playingYM = false;
    }//GEN-LAST:event_jButtonStop2ActionPerformed

    private void jComboBox1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBox1ActionPerformed
        currentHz = jComboBox1.getSelectedIndex()==0?50:60;
        compareMilli = 1000/currentHz;
    }//GEN-LAST:event_jComboBox1ActionPerformed

    private void jCheckBox1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox1ActionPerformed
        updateCheckBoxes();
    }//GEN-LAST:event_jCheckBox1ActionPerformed

    private void jTextField1aActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextField1aActionPerformed
        if (inEvent>0) return;
        JTextField f = (JTextField)evt.getSource();
        updateTextfield(f);
        int count = DASM6809.toNumber(f.getName());
        f.setText("$"+String.format("%02X", e8910.snd_regs[count]));
    }//GEN-LAST:event_jTextField1aActionPerformed

    private void jTextField1aFocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextField1aFocusLost
        if (inEvent>0) return;
        JTextField f = (JTextField)evt.getSource();
        updateTextfield(f);
        int count = DASM6809.toNumber(f.getName());
        f.setText("$"+String.format("%02X", e8910.snd_regs[count]));
    }//GEN-LAST:event_jTextField1aFocusLost

    private void jButtonStop3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonStop3ActionPerformed
        ympos = 0;
        DissiPanel.scrollToVisibleMid(jTable2, ympos, 0);
        jTable1.repaint();
        jTable2.repaint();
    }//GEN-LAST:event_jButtonStop3ActionPerformed
    void updateTextfield(JTextField f)
    {
        if (inEvent>0) return;
        int count = DASM6809.toNumber(f.getName());
        int value = DASM6809.toNumber(f.getText());

        workBuf[count] = (byte) value;
        updateEnhanced(workBuf);
    }
    private void jTextField1aKeyPressed(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTextField1aKeyPressed
        JTextField f = (JTextField)evt.getSource();
        updateTextfield(f);
    }//GEN-LAST:event_jTextField1aKeyPressed

    private void jCheckBoxNoiseAjCheckBox1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxNoiseAjCheckBox1ActionPerformed
        setFromEnhanced();
    }//GEN-LAST:event_jCheckBoxNoiseAjCheckBox1ActionPerformed

    private void jCheckBoxNoiseBjCheckBox1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxNoiseBjCheckBox1ActionPerformed
        setFromEnhanced();
    }//GEN-LAST:event_jCheckBoxNoiseBjCheckBox1ActionPerformed

    private void jCheckBoxNoiseCjCheckBox1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxNoiseCjCheckBox1ActionPerformed
        setFromEnhanced();
    }//GEN-LAST:event_jCheckBoxNoiseCjCheckBox1ActionPerformed

    private void jCheckBoxToneCjCheckBox1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxToneCjCheckBox1ActionPerformed
        setFromEnhanced();
    }//GEN-LAST:event_jCheckBoxToneCjCheckBox1ActionPerformed

    private void jCheckBoxToneBjCheckBox1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxToneBjCheckBox1ActionPerformed
        setFromEnhanced();
    }//GEN-LAST:event_jCheckBoxToneBjCheckBox1ActionPerformed

    private void jCheckBoxToneAjCheckBox1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxToneAjCheckBox1ActionPerformed
        setFromEnhanced();
    }//GEN-LAST:event_jCheckBoxToneAjCheckBox1ActionPerformed

    private void jButtonAddRowActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonAddRowActionPerformed
        if (jTable1.isEditing()) jTable1.getCellEditor().stopCellEditing();        

        ymSound.addRow(ympos);
        ympos++;
        workBufToSelection();
        jTable1.tableChanged(null);
        jTable2.tableChanged(null);
    }//GEN-LAST:event_jButtonAddRowActionPerformed

    private void jComboBoxNotesAActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBoxNotesAActionPerformed
        setFromEnhanced();
    }//GEN-LAST:event_jComboBoxNotesAActionPerformed

    private void jComboBoxNotesBActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBoxNotesBActionPerformed
        setFromEnhanced();
    }//GEN-LAST:event_jComboBoxNotesBActionPerformed

    private void jComboBoxNotesCActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBoxNotesCActionPerformed
        setFromEnhanced();
    }//GEN-LAST:event_jComboBoxNotesCActionPerformed

    private void jCheckBoxModeAActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxModeAActionPerformed
        setFromEnhanced();
    }//GEN-LAST:event_jCheckBoxModeAActionPerformed

    private void jCheckBoxModeBActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxModeBActionPerformed
        setFromEnhanced();
    }//GEN-LAST:event_jCheckBoxModeBActionPerformed

    private void jCheckBoxModeCActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxModeCActionPerformed
        setFromEnhanced();
    }//GEN-LAST:event_jCheckBoxModeCActionPerformed

    private void jComboBoxEnvelopeActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBoxEnvelopeActionPerformed
        setFromEnhanced();
    }//GEN-LAST:event_jComboBoxEnvelopeActionPerformed

    private void jSliderNoiseStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderNoiseStateChanged
        setFromEnhanced();
    }//GEN-LAST:event_jSliderNoiseStateChanged

    private void jSliderAmplidtudeAStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderAmplidtudeAStateChanged
        setFromEnhanced();
    }//GEN-LAST:event_jSliderAmplidtudeAStateChanged

    private void jSliderAmplidtudeBStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderAmplidtudeBStateChanged
        setFromEnhanced();
    }//GEN-LAST:event_jSliderAmplidtudeBStateChanged

    private void jSliderAmplidtudeCStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSliderAmplidtudeCStateChanged
        setFromEnhanced();
    }//GEN-LAST:event_jSliderAmplidtudeCStateChanged

    private void jTextField5aMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jTextField5aMouseClicked
        if (evt.getClickCount() == 2) 
        {
            JTextField f = (JTextField)evt.getSource();
            int count = DASM6809.toNumber(f.getName());
            int value = DASM6809.toNumber(f.getText());
            e8910.e8910_write(count, value);
            updatePSG();
        }
    }//GEN-LAST:event_jTextField5aMouseClicked

    private void jTable1MousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jTable1MousePressed
        if (evt.getClickCount() == 2) 
        {
            Point p = evt.getPoint();
            int row = jTable1.rowAtPoint(p);
            int col = jTable1.columnAtPoint(p);
            ympos = row;
            workBufToSelection();
            jTable1.repaint();
            jTable2.repaint();
        }
    }//GEN-LAST:event_jTable1MousePressed

    public static byte[][] copyBuf = null;
    // both inclusive
    private void jButtonCopyActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonCopyActionPerformed
        copyBuf = null;
        int[] rows = jTable1.getSelectedRows();
        if (rows.length==0) return;
        int start = rows[0];
        int end = start +1;
        if (rows.length>1) end = rows[rows.length-1]+1;
        copyBuf = new byte[16][];
        
        for (int reg = 0; reg<16; reg++)
        {
            for (int i=start; i<end; i++)
            {
                if (i==start) copyBuf[reg] = new byte[end-start]; 
                copyBuf[reg][i-start] = ymSound.out_buf[reg][i];
            }            
        }

    }//GEN-LAST:event_jButtonCopyActionPerformed

    private void jButtonPasteActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonPasteActionPerformed
        if (copyBuf==null) return;
        insertYM(copyBuf, copyBuf[0].length);
    }//GEN-LAST:event_jButtonPasteActionPerformed
    String lastPath ="";
    private void jButtonLoadActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonLoadActionPerformed

        if (jTable1.isEditing()) jTable1.getCellEditor().stopCellEditing();        
        InternalFrameFileChoser fc = new de.malban.gui.dialogs.InternalFrameFileChoser();

        if (lastPath.length()==0)
        {
            fc.setCurrentDirectory(new java.io.File(pathOnly));
        }
        else
        {
            fc.setCurrentDirectory(new java.io.File(lastPath));
        }
        FileNameExtensionFilter filter = new FileNameExtensionFilter("ym", "ym");
        fc.setFileFilter(filter);

        int r = fc.showOpenDialog(Configuration.getConfiguration().getMainFrame());
        if (r != InternalFrameFileChoser.APPROVE_OPTION) return;
        lastPath = fc.getSelectedFile().getAbsolutePath();
        initYM( lastPath);
        
        ympos = 0;
        workBufToSelection();
        jTable1.repaint();
        jTable2.repaint();
    }//GEN-LAST:event_jButtonLoadActionPerformed
    // 32 bit int as byte array in big endian
    byte[] getLongBytes(int l)
    {
        byte[] ret = new byte[4];
        
        ret[0] =(byte) ((((l>>8)>>8)>>8) & 0xff);
        ret[1] =(byte) (((l>>8)>>8) & 0xff);
        ret[2] =(byte) ((l>>8) & 0xff);
        ret[3] =(byte) (l & 0xff);
        
        return ret;
    }
    // 16 bit int as byte array in big endian
    byte[] getWordBytes(int l)
    {
        byte[] ret = new byte[2];
        
        ret[0] =(byte) ((l>>8) & 0xff);
        ret[1] =(byte) (l & 0xff);
        
        return ret;
    }
    
    // start inclusive
    // end exclusive
    boolean saveYM(int start, int end)
    {
        InternalFrameFileChoser fc = new de.malban.gui.dialogs.InternalFrameFileChoser();

        if (lastPath.length()==0)
        {
            fc.setCurrentDirectory(new java.io.File(pathOnly));
        }
        else
        {
            fc.setCurrentDirectory(new java.io.File(lastPath));
        }
        FileNameExtensionFilter filter = new FileNameExtensionFilter("ym", "ym");
        fc.setFileFilter(filter);

        int re = fc.showOpenDialog(Configuration.getConfiguration().getMainFrame());
        if (re != InternalFrameFileChoser.APPROVE_OPTION) return false;
        lastPath = fc.getSelectedFile().getAbsolutePath();
        String recordingFilename = lastPath;
        if (!recordingFilename.toLowerCase().endsWith(".ym"))
            recordingFilename+=".ym";
        // open file
        try 
        {
            OutputStream output = null;
            try 
            {
                output = new BufferedOutputStream(new FileOutputStream(recordingFilename));


                // generate ym header
                output.write("YM6!".getBytes(StandardCharsets.UTF_8));
                output.write("LeOnArD!".getBytes(StandardCharsets.UTF_8));
                output.write(getLongBytes(end-start));
                output.write(getLongBytes(ymSound.attribut));
                output.write(getWordBytes(0));
                output.write(getLongBytes(2000000));
                output.write(getWordBytes(50));
                output.write(getLongBytes(0));
                output.write(getWordBytes(0));

                output.write(jTextFieldSongName.getText().getBytes(StandardCharsets.UTF_8));
                output.write(0);
                output.write(jTextFieldAuthor.getText().getBytes(StandardCharsets.UTF_8));
                output.write(0);
                output.write(jTextFieldComment.getText().getBytes(StandardCharsets.UTF_8));
                output.write(0);
                // save header
                // save data
                if (ymSound.interleave)
                {
                    for (int r=0; r<16; r++)
                    {
                        for (int i=start; i<end; i++)
                        {
                            byte toWrite;
                            toWrite = ymSound.out_buf[r][i];
                            if (r == 0) toWrite = (byte) (toWrite & 0xff);
                            if (r == 1) toWrite = (byte) (toWrite & 0x0f);
                            if (r == 2) toWrite = (byte) (toWrite & 0xff);
                            if (r == 3) toWrite = (byte) (toWrite & 0x0f);
                            if (r == 4) toWrite = (byte) (toWrite & 0xff);
                            if (r == 5) toWrite = (byte) (toWrite & 0x0f);
                            if (r == 6) toWrite = (byte) (toWrite & 0x1f);
                            if (r == 7) toWrite = (byte) (toWrite & 0x3f);
                            if (r == 8) toWrite = (byte) (toWrite & 0x1f);
                            if (r == 9) toWrite = (byte) (toWrite & 0x1f);
                            if (r == 10) toWrite = (byte) (toWrite & 0x1f);
                            if (r == 11) toWrite = (byte) (toWrite & 0xff);
                            if (r == 12) toWrite = (byte) (toWrite & 0xff);
                            if (r == 13) toWrite = (byte) (toWrite & 0x0f);
                            if (r == 14) toWrite = (byte) (toWrite & 0x1f);
                            if (r == 15) toWrite = 0;
                            if (r == 16) toWrite = 0;
                            if (r == 13) 
                            {
                                if (i>0)
                                {
                                    if (toWrite == (byte) ((ymSound.out_buf[r][i-1]) & 0x0f))
                                        toWrite = (byte)0xff;
                                }
                                else
                                    toWrite = (byte)0xff;
                            }                  
                            output.write(toWrite);
                        }
                    }             
                }
                else
                {
                    for (int i=start; i<end; i++)
                    {
                        for (int r=0; r<16; r++)
                        {
                            byte toWrite;
                            toWrite = ymSound.out_buf[r][i];
                            if (r == 0) toWrite = (byte) (toWrite & 0xff);
                            if (r == 1) toWrite = (byte) (toWrite & 0x0f);
                            if (r == 2) toWrite = (byte) (toWrite & 0xff);
                            if (r == 3) toWrite = (byte) (toWrite & 0x0f);
                            if (r == 4) toWrite = (byte) (toWrite & 0xff);
                            if (r == 5) toWrite = (byte) (toWrite & 0x0f);
                            if (r == 6) toWrite = (byte) (toWrite & 0x1f);
                            if (r == 7) toWrite = (byte) (toWrite & 0x3f);
                            if (r == 8) toWrite = (byte) (toWrite & 0x1f);
                            if (r == 9) toWrite = (byte) (toWrite & 0x1f);
                            if (r == 10) toWrite = (byte) (toWrite & 0x1f);
                            if (r == 11) toWrite = (byte) (toWrite & 0xff);
                            if (r == 12) toWrite = (byte) (toWrite & 0xff);
                            if (r == 13) toWrite = (byte) (toWrite & 0x0f);
                            if (r == 14) toWrite = (byte) (toWrite & 0x1f);
                            if (r == 15) toWrite = 0;
                            if (r == 16) toWrite = 0;
                            if (r == 13) 
                            {
                                if (i>0)
                                {
                                    if (toWrite == (byte) ((ymSound.out_buf[r][i-1]) & 0x0f))
                                        toWrite = (byte)0xff;
                                }
                                else
                                    toWrite = (byte)0xff;
                            }                  
                            output.write(toWrite);
                        }
                    }             
                    
                }
                // save ending
                output.write("End!".getBytes(StandardCharsets.UTF_8));
            }
            finally 
            {
                output.flush();
                output.close();
            }
        }
        catch(Throwable ex)
        {
            log.addLog(ex, WARN);
            return false;
        }
        ((VediPanel)tinyLog).refreshTree();   
        return true;
    }

    private void jButtonSaveActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSaveActionPerformed

        saveYM(0, ymSound.vbl_len);
        
    }//GEN-LAST:event_jButtonSaveActionPerformed

    private void jButtonInsertYMActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonInsertYMActionPerformed
        InternalFrameFileChoser fc = new de.malban.gui.dialogs.InternalFrameFileChoser();

        if (lastPath.length()==0)
        {
            fc.setCurrentDirectory(new java.io.File(pathOnly));
        }
        else
        {
            fc.setCurrentDirectory(new java.io.File(lastPath));
        }
        FileNameExtensionFilter filter = new FileNameExtensionFilter("ym", "ym");
        fc.setFileFilter(filter);

        int r = fc.showOpenDialog(Configuration.getConfiguration().getMainFrame());
        if (r != InternalFrameFileChoser.APPROVE_OPTION) return;
        lastPath = fc.getSelectedFile().getAbsolutePath();
        
        YmSound newYMSound = new YmSound(lastPath, tinyLog);
        if (!newYMSound.init) 
        {
            return;
        }

        insertYM(newYMSound.out_buf, newYMSound.vbl_len);

    }//GEN-LAST:event_jButtonInsertYMActionPerformed

    private void insertYM(byte[][] buf, int len)
    {
        if (jTable1.isEditing()) jTable1.getCellEditor().stopCellEditing();        
        for (int i=0; i<len; i++)
        {
            ymSound.addRow(ympos);
            for (int reg=0; reg<16; reg++)
            {
                ymSound.out_buf[reg][ympos] = buf[reg][i];
            }
            ympos++;
        }
        workBufToSelection();
        jTable1.tableChanged(null);
        jTable2.tableChanged(null);        
    }
    
    private void jButtonSaveSelectionActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSaveSelectionActionPerformed
        int[] rows = jTable1.getSelectedRows();
        if (rows.length<=0) return;
        
        int start = rows[0];
        int end = start +1;
        if (rows.length>1) end = rows[rows.length-1];
        saveYM(start, end);
    }//GEN-LAST:event_jButtonSaveSelectionActionPerformed

    private void jButtonNewYMActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonNewYMActionPerformed
        initYM( "");
        
        ympos = 0;
        workBufToSelection();
        jTable1.tableChanged(null);
        jTable2.tableChanged(null);
    }//GEN-LAST:event_jButtonNewYMActionPerformed

    private void jTable2MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jTable2MouseClicked
        if (evt.getClickCount() == 2) 
        {
            Point p = evt.getPoint();
            int row = jTable2.rowAtPoint(p);
            int col = jTable2.columnAtPoint(p);
            ympos = row;
            workBufToSelection();
            jTable1.repaint();
            jTable2.repaint();
        }
    }//GEN-LAST:event_jTable2MouseClicked

    private void jComboBoxInterleavedActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBoxInterleavedActionPerformed
        ymSound.interleave = jComboBoxInterleaved.getSelectedIndex()==0;
        ymSound.attribut = ymSound.attribut & 0xfffffffe;
        if (ymSound.interleave) ymSound.attribut++;
        jTextFieldAttributes.setText(ymSound.getLongBinaryString(ymSound.attribut));
    }//GEN-LAST:event_jComboBoxInterleavedActionPerformed

    private void jButtonLoad1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonLoad1ActionPerformed
        loadAYFX("C", jCheckBox22.isSelected());
    }//GEN-LAST:event_jButtonLoad1ActionPerformed

    private void jButtonSave1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSave1ActionPerformed
        saveAYFX(jCheckBox19.isSelected(), "C");
    }//GEN-LAST:event_jButtonSave1ActionPerformed

    private void jButtonLoad2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonLoad2ActionPerformed
        loadAYFX("A", jCheckBox20.isSelected());
    }//GEN-LAST:event_jButtonLoad2ActionPerformed

    private void jButtonSave2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSave2ActionPerformed
        saveAYFX(jCheckBox17.isSelected(), "A");
    }//GEN-LAST:event_jButtonSave2ActionPerformed

    private void jButtonLoad3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonLoad3ActionPerformed
        loadAYFX("B", jCheckBox21.isSelected());
    }//GEN-LAST:event_jButtonLoad3ActionPerformed

    private void jButtonSave3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSave3ActionPerformed
        saveAYFX(jCheckBox18.isSelected(), "B");
    }//GEN-LAST:event_jButtonSave3ActionPerformed

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.ButtonGroup buttonGroup1;
    private javax.swing.ButtonGroup buttonGroup2;
    private javax.swing.ButtonGroup buttonGroup3;
    private javax.swing.ButtonGroup buttonGroup4;
    private javax.swing.JButton jButtonAddRow;
    private javax.swing.JButton jButtonCancel;
    private javax.swing.JButton jButtonCopy;
    private javax.swing.JButton jButtonCreate;
    private javax.swing.JButton jButtonCut;
    private javax.swing.JButton jButtonInsertYM;
    private javax.swing.JButton jButtonLoad;
    private javax.swing.JButton jButtonLoad1;
    private javax.swing.JButton jButtonLoad2;
    private javax.swing.JButton jButtonLoad3;
    private javax.swing.JButton jButtonNewYM;
    private javax.swing.JButton jButtonPaste;
    private javax.swing.JButton jButtonPlaySample;
    private javax.swing.JButton jButtonSave;
    private javax.swing.JButton jButtonSave1;
    private javax.swing.JButton jButtonSave2;
    private javax.swing.JButton jButtonSave3;
    private javax.swing.JButton jButtonSaveSelection;
    private javax.swing.JButton jButtonStop2;
    private javax.swing.JButton jButtonStop3;
    private javax.swing.JCheckBox jCheckBox1;
    private javax.swing.JCheckBox jCheckBox10;
    private javax.swing.JCheckBox jCheckBox11;
    private javax.swing.JCheckBox jCheckBox12;
    private javax.swing.JCheckBox jCheckBox13;
    private javax.swing.JCheckBox jCheckBox14;
    private javax.swing.JCheckBox jCheckBox15;
    private javax.swing.JCheckBox jCheckBox16;
    private javax.swing.JCheckBox jCheckBox17;
    private javax.swing.JCheckBox jCheckBox18;
    private javax.swing.JCheckBox jCheckBox19;
    private javax.swing.JCheckBox jCheckBox2;
    private javax.swing.JCheckBox jCheckBox20;
    private javax.swing.JCheckBox jCheckBox21;
    private javax.swing.JCheckBox jCheckBox22;
    private javax.swing.JCheckBox jCheckBox3;
    private javax.swing.JCheckBox jCheckBox4;
    private javax.swing.JCheckBox jCheckBox5;
    private javax.swing.JCheckBox jCheckBox6;
    private javax.swing.JCheckBox jCheckBox7;
    private javax.swing.JCheckBox jCheckBox8;
    private javax.swing.JCheckBox jCheckBox9;
    private javax.swing.JCheckBox jCheckBoxCreatePlayer;
    private javax.swing.JCheckBox jCheckBoxDontCompress;
    private javax.swing.JCheckBox jCheckBoxModeA;
    private javax.swing.JCheckBox jCheckBoxModeB;
    private javax.swing.JCheckBox jCheckBoxModeC;
    private javax.swing.JCheckBox jCheckBoxNoiseA;
    private javax.swing.JCheckBox jCheckBoxNoiseB;
    private javax.swing.JCheckBox jCheckBoxNoiseC;
    private javax.swing.JCheckBox jCheckBoxPacked;
    private javax.swing.JCheckBox jCheckBoxToneA;
    private javax.swing.JCheckBox jCheckBoxToneB;
    private javax.swing.JCheckBox jCheckBoxToneC;
    private javax.swing.JComboBox jComboBox1;
    private javax.swing.JComboBox jComboBoxEnvelope;
    private javax.swing.JComboBox jComboBoxInterleaved;
    private javax.swing.JComboBox jComboBoxNotesA;
    private javax.swing.JComboBox jComboBoxNotesB;
    private javax.swing.JComboBox jComboBoxNotesC;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel10;
    private javax.swing.JLabel jLabel100;
    private javax.swing.JLabel jLabel101;
    private javax.swing.JLabel jLabel102;
    private javax.swing.JLabel jLabel103;
    private javax.swing.JLabel jLabel104;
    private javax.swing.JLabel jLabel105;
    private javax.swing.JLabel jLabel106;
    private javax.swing.JLabel jLabel107;
    private javax.swing.JLabel jLabel108;
    private javax.swing.JLabel jLabel109;
    private javax.swing.JLabel jLabel11;
    private javax.swing.JLabel jLabel110;
    private javax.swing.JLabel jLabel111;
    private javax.swing.JLabel jLabel113;
    private javax.swing.JLabel jLabel114;
    private javax.swing.JLabel jLabel115;
    private javax.swing.JLabel jLabel116;
    private javax.swing.JLabel jLabel117;
    private javax.swing.JLabel jLabel118;
    private javax.swing.JLabel jLabel119;
    private javax.swing.JLabel jLabel12;
    private javax.swing.JLabel jLabel120;
    private javax.swing.JLabel jLabel121;
    private javax.swing.JLabel jLabel122;
    private javax.swing.JLabel jLabel123;
    private javax.swing.JLabel jLabel124;
    private javax.swing.JLabel jLabel125;
    private javax.swing.JLabel jLabel126;
    private javax.swing.JLabel jLabel127;
    private javax.swing.JLabel jLabel128;
    private javax.swing.JLabel jLabel129;
    private javax.swing.JLabel jLabel13;
    private javax.swing.JLabel jLabel130;
    private javax.swing.JLabel jLabel131;
    private javax.swing.JLabel jLabel132;
    private javax.swing.JLabel jLabel133;
    private javax.swing.JLabel jLabel134;
    private javax.swing.JLabel jLabel14;
    private javax.swing.JLabel jLabel15;
    private javax.swing.JLabel jLabel16;
    private javax.swing.JLabel jLabel17;
    private javax.swing.JLabel jLabel18;
    private javax.swing.JLabel jLabel19;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel20;
    private javax.swing.JLabel jLabel21;
    private javax.swing.JLabel jLabel22;
    private javax.swing.JLabel jLabel23;
    private javax.swing.JLabel jLabel24;
    private javax.swing.JLabel jLabel25;
    private javax.swing.JLabel jLabel26;
    private javax.swing.JLabel jLabel27;
    private javax.swing.JLabel jLabel28;
    private javax.swing.JLabel jLabel29;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel30;
    private javax.swing.JLabel jLabel31;
    private javax.swing.JLabel jLabel32;
    private javax.swing.JLabel jLabel33;
    private javax.swing.JLabel jLabel34;
    private javax.swing.JLabel jLabel35;
    private javax.swing.JLabel jLabel36;
    private javax.swing.JLabel jLabel37;
    private javax.swing.JLabel jLabel38;
    private javax.swing.JLabel jLabel39;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel40;
    private javax.swing.JLabel jLabel41;
    private javax.swing.JLabel jLabel42;
    private javax.swing.JLabel jLabel43;
    private javax.swing.JLabel jLabel44;
    private javax.swing.JLabel jLabel45;
    private javax.swing.JLabel jLabel46;
    private javax.swing.JLabel jLabel47;
    private javax.swing.JLabel jLabel48;
    private javax.swing.JLabel jLabel49;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JLabel jLabel50;
    private javax.swing.JLabel jLabel51;
    private javax.swing.JLabel jLabel52;
    private javax.swing.JLabel jLabel53;
    private javax.swing.JLabel jLabel54;
    private javax.swing.JLabel jLabel55;
    private javax.swing.JLabel jLabel56;
    private javax.swing.JLabel jLabel57;
    private javax.swing.JLabel jLabel58;
    private javax.swing.JLabel jLabel59;
    private javax.swing.JLabel jLabel6;
    private javax.swing.JLabel jLabel60;
    private javax.swing.JLabel jLabel61;
    private javax.swing.JLabel jLabel62;
    private javax.swing.JLabel jLabel63;
    private javax.swing.JLabel jLabel64;
    private javax.swing.JLabel jLabel65;
    private javax.swing.JLabel jLabel66;
    private javax.swing.JLabel jLabel67;
    private javax.swing.JLabel jLabel68;
    private javax.swing.JLabel jLabel69;
    private javax.swing.JLabel jLabel7;
    private javax.swing.JLabel jLabel70;
    private javax.swing.JLabel jLabel71;
    private javax.swing.JLabel jLabel72;
    private javax.swing.JLabel jLabel73;
    private javax.swing.JLabel jLabel74;
    private javax.swing.JLabel jLabel75;
    private javax.swing.JLabel jLabel76;
    private javax.swing.JLabel jLabel77;
    private javax.swing.JLabel jLabel78;
    private javax.swing.JLabel jLabel79;
    private javax.swing.JLabel jLabel8;
    private javax.swing.JLabel jLabel80;
    private javax.swing.JLabel jLabel81;
    private javax.swing.JLabel jLabel82;
    private javax.swing.JLabel jLabel83;
    private javax.swing.JLabel jLabel84;
    private javax.swing.JLabel jLabel85;
    private javax.swing.JLabel jLabel86;
    private javax.swing.JLabel jLabel87;
    private javax.swing.JLabel jLabel88;
    private javax.swing.JLabel jLabel89;
    private javax.swing.JLabel jLabel9;
    private javax.swing.JLabel jLabel90;
    private javax.swing.JLabel jLabel91;
    private javax.swing.JLabel jLabel92;
    private javax.swing.JLabel jLabel93;
    private javax.swing.JLabel jLabel94;
    private javax.swing.JLabel jLabel95;
    private javax.swing.JLabel jLabel96;
    private javax.swing.JLabel jLabel97;
    private javax.swing.JLabel jLabel98;
    private javax.swing.JLabel jLabel99;
    private javax.swing.JLabel jLabelPSG0;
    private javax.swing.JLabel jLabelPSG1;
    private javax.swing.JLabel jLabelPSG10;
    private javax.swing.JLabel jLabelPSG11;
    private javax.swing.JLabel jLabelPSG12;
    private javax.swing.JLabel jLabelPSG13;
    private javax.swing.JLabel jLabelPSG14;
    private javax.swing.JLabel jLabelPSG15;
    private javax.swing.JLabel jLabelPSG2;
    private javax.swing.JLabel jLabelPSG3;
    private javax.swing.JLabel jLabelPSG4;
    private javax.swing.JLabel jLabelPSG5;
    private javax.swing.JLabel jLabelPSG6;
    private javax.swing.JLabel jLabelPSG7;
    private javax.swing.JLabel jLabelPSG8;
    private javax.swing.JLabel jLabelPSG9;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JPanel jPanel3;
    private javax.swing.JPanel jPanel4;
    private javax.swing.JPanel jPanel5;
    private javax.swing.JPanel jPanel6;
    private javax.swing.JPanel jPanel7;
    private javax.swing.JPanel jPanel8;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JScrollPane jScrollPane2;
    private javax.swing.JSlider jSliderAmplidtudeA;
    private javax.swing.JSlider jSliderAmplidtudeB;
    private javax.swing.JSlider jSliderAmplidtudeC;
    private javax.swing.JSlider jSliderNoise;
    private javax.swing.JTable jTable1;
    private javax.swing.JTable jTable2;
    private javax.swing.JTextField jTextField10a;
    private javax.swing.JTextField jTextField11a;
    private javax.swing.JTextField jTextField12a;
    private javax.swing.JTextField jTextField13a;
    private javax.swing.JTextField jTextField14a;
    private javax.swing.JTextField jTextField15a;
    private javax.swing.JTextField jTextField16a;
    private javax.swing.JTextField jTextField1a;
    private javax.swing.JTextField jTextField2a;
    private javax.swing.JTextField jTextField3a;
    private javax.swing.JTextField jTextField4a;
    private javax.swing.JTextField jTextField5a;
    private javax.swing.JTextField jTextField6a;
    private javax.swing.JTextField jTextField7a;
    private javax.swing.JTextField jTextField8a;
    private javax.swing.JTextField jTextField9a;
    private javax.swing.JTextField jTextFieldAttributes;
    private javax.swing.JTextField jTextFieldAuthor;
    private javax.swing.JTextField jTextFieldComment;
    private javax.swing.JTextField jTextFieldFrequencyComputer;
    private javax.swing.JTextField jTextFieldFrequencyPlayer;
    private javax.swing.JTextField jTextFieldFutureData;
    private javax.swing.JTextField jTextFieldLoop;
    private javax.swing.JTextField jTextFieldSamples;
    private javax.swing.JTextField jTextFieldSongName;
    private javax.swing.JTextField jTextFieldYMVersion;
    // End of variables declaration//GEN-END:variables

    JInternalFrame modelDialog;
    public static boolean showYMPanel(String fileName, TinyLogInterface tl)
    {
        
        
        
        return false;
    }        
    String ymGivenName ="";
    public static void showYMPanelNoModal(String fileName, TinyLogInterface tl)
    {
        JFrame frame = Configuration.getConfiguration().getMainFrame();
        YMJPanel panel = new YMJPanel(fileName, tl);
        if (!panel.ymSound.init)
        {
            panel = null;
            return;
        }
        
       ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).addPanel(panel);
       ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).windowMe(panel, 1024, 600, panel.getMenuItem().getText());
    }        
    void createSource()
    {
        doYM_part1();        
    }

    void doYM_part1()
    {
        if (two != null) return;
        ymSaveName = "";
        // check for a property file!
        String type ="";
        String pathFull ="";
        String pathOnly ="";
        String filenameOnly ="";
        String filenameBaseOnly ="";
        Path p = Paths.get(currentYMFile);
        pathFull = p.toString();
        pathOnly = p.getParent().toString();
        if (pathOnly.length()>0)
            pathOnly+= File.separator;
        
        
        filenameOnly = p.getFileName().toString();
        filenameBaseOnly = filenameOnly.substring(0,filenameOnly.length()-3);
        
        
        
        boolean pic = false;
        if (filenameOnly.toLowerCase().endsWith(".ym"))pic = true;
        if (!pic) 
        {
            tinyLog.printError("Selected entry does not have a known ym extension!");
            return;
        }
        String saveNameOnly ="";
        if (jCheckBoxDontCompress.isSelected())
        {
            File file = new File(pathOnly+filenameBaseOnly+".asm");
            saveNameOnly = filenameBaseOnly+".asm";
            FileWriter fw;
            BufferedWriter bw;
            try
            {
                fw = new FileWriter(file.getAbsoluteFile());
                bw = new BufferedWriter(fw);        
                int start = 0;
                int end = ymSound.vbl_len;

                boolean started = false;
                

                bw.write("\n");
                bw.write("SONG_DATA = ymlen\n");
                bw.write("\n");
                bw.write("ymlen:\n dw ");
                bw.write("$"+String.format("%04X",(end-start)));
                
                bw.write("\nymregs:\n db ");
                for (int r=0; r< 15; r++)
                {
                    if (!usedRegs[r]) continue;
                    
                    if (started) bw.write(", ");
                    bw.write("$"+String.format("%02X",r));
                    started = true;
                }
                bw.write(", $ff \n");
                bw.write("ymdata:\n");
                
                for (int i=start; i<end; i++)
                {
                    String o = "";
                    started = false;
                    for (int r=0; r< 15; r++)
                    {
                        if (!usedRegs[r]) continue;
                        byte value = ymSound.out_buf[r][i];
                        if ((r == 13) && (value&0xff) == 0xff) 
                            continue;


                        if (started) o+=", ";
                        o+="$"+String.format("%02X",value);
                        started = true;
                    }                            
                    bw.write(" db "+o+"; "+i+"\n");
                }
                bw.close();
                
                if (jCheckBoxCreatePlayer.isSelected())
                {
                    Path include = Paths.get(".", "template", "VECTREX.I");
                    de.malban.util.UtilityFiles.copyOneFile(include.toString(), pathOnly+ "VECTREX.I");
                    Path digital = Paths.get(".", "template", "ymUnpackedPlayer.i");
                    de.malban.util.UtilityFiles.copyOneFile(digital.toString(), pathOnly+ "ymUnpackedPlayer.i");

                    Path template = Paths.get(".", "template", "ymPlayUnpackedMain.template");
                    String exampleMain = de.malban.util.UtilityString.readTextFileToOneString(new File(template.toString()));

                    exampleMain = de.malban.util.UtilityString.replace(exampleMain,"#YM_DATA#", saveNameOnly);
                    de.malban.util.UtilityFiles.createTextFile(pathOnly+filenameOnly.substring(0,filenameOnly.length()-3)+"Main.asm", exampleMain);     
                }
                
            }
            catch (Throwable e)
            {
                log.addLog("YM - Error openening output file! ('"+pathOnly+filenameBaseOnly+".asm"+"').", WARN);
                tinyLog.printError("Error creating file: "+pathOnly+filenameBaseOnly+".asm");
            }
            ((VediPanel)tinyLog).refreshTree();
            return;
        }
        // do compress
        start(pathFull);
    }
    
    void doYM_part2()
    {
        String type ="";
        String pathFull ="";
        String pathOnly ="";
        String filenameOnly ="";
        String filenameBaseOnly ="";
        Path p = Paths.get(currentYMFile);
        pathFull = p.toString();
        pathOnly = p.getParent().toString();
        if (pathOnly.length()>0)
            pathOnly+= File.separator;
        
        filenameOnly = p.getFileName().toString();
        
        String saveNameOnly = Paths.get(ymSaveName).getFileName().toString();

        if (jCheckBoxCreatePlayer.isSelected())
        {
            Path include = Paths.get(".", "template", "VECTREX.I");
            de.malban.util.UtilityFiles.copyOneFile(include.toString(), pathOnly+ "VECTREX.I");
            Path digital = Paths.get(".", "template", "ymPlayer.i");
            de.malban.util.UtilityFiles.copyOneFile(digital.toString(), pathOnly+ "ymPlayer.i");

            Path template = Paths.get(".", "template", "ymPlayMain.template");
            String exampleMain = de.malban.util.UtilityString.readTextFileToOneString(new File(template.toString()));

            exampleMain = de.malban.util.UtilityString.replace(exampleMain,"#YM_DATA#", saveNameOnly);
            de.malban.util.UtilityFiles.createTextFile(pathOnly+filenameOnly.substring(0,filenameOnly.length()-3)+"Main.asm", exampleMain);     
        }
        

//       ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).removePanel(this);
        if (tinyLog instanceof VediPanel)
        {
            ((VediPanel)tinyLog).returnFromYMPanel(true);
        }
        
    }
        
    public void start(final String pathFull)
    {
        // paranoia!
        if (two != null) return;
        two = new Thread("Build YM") 
        {
            public void run() 
            {
                ymSaveName = ymSound.buildASM(usedRegs);
                if (ymSaveName != null) 
                {
                    SwingUtilities.invokeLater(new Runnable()
                    {
                        public void run()
                        {
                            doYM_part2();
                        }
                    });                    
                }
                two = null;
            }  
        };
        two.start();           
    }    

    boolean playingYM = false;
    int ympos = 0;
    int currentHz = 50;
    int compareMilli = 1000/50;
    
    boolean[] usedRegs = new boolean[16];
    
    final E8910 e8910 = new E8910();
    void startYM()
    {
        if (playingYM) return;
        // paranoia!
        if (three != null) return;
        
        
        Stream line = TinySound.getOutStream();

        e8910.e8910_init_sound();
        // setupPSG once with a complete reigster set!
        // if not every register is setup once,
        // the emulation may decide to do an endless loop!

        if (loopStart>-1) ympos = (int)loopStart;

        for (int r=0; r< 15; r++)
        {
            byte value = ymSound.out_buf[r][ympos];
            byte poker = value;
            int i=r;
            if ((i==1)||(i==3)||(i==5)) poker   &= 0x0f;
            if ((i==6) ) poker                  &= 0x1f;
            if  (i==7) poker                    &= 0x3f;
            if ((i==8)||(i==9)||(i==10)) poker  &= 0x0f;
            e8910.e8910_write(r,  poker&0xff);
            workBuf[r] = (byte)e8910.snd_regs[r];
        }                
        jTextField1a.setText("$"+String.format("%02X", e8910.snd_regs[0]));
        jTextField2a.setText("$"+String.format("%02X", e8910.snd_regs[1]));
        jTextField3a.setText("$"+String.format("%02X", e8910.snd_regs[2]));
        jTextField4a.setText("$"+String.format("%02X", e8910.snd_regs[3]));
        jTextField5a.setText("$"+String.format("%02X", e8910.snd_regs[4]));
        jTextField6a.setText("$"+String.format("%02X", e8910.snd_regs[5]));
        jTextField7a.setText("$"+String.format("%02X", e8910.snd_regs[6]));
        jTextField8a.setText("$"+String.format("%02X", e8910.snd_regs[7]));
        jTextField9a.setText("$"+String.format("%02X", e8910.snd_regs[8]));
        jTextField10a.setText("$"+String.format("%02X", e8910.snd_regs[9]));
        jTextField11a.setText("$"+String.format("%02X", e8910.snd_regs[10]));
        jTextField12a.setText("$"+String.format("%02X", e8910.snd_regs[11]));
        jTextField13a.setText("$"+String.format("%02X", e8910.snd_regs[12]));
        jTextField14a.setText("$"+String.format("%02X", e8910.snd_regs[13]));
        jTextField15a.setText("$"+String.format("%02X", e8910.snd_regs[14]));
        jTextField16a.setText("$"+String.format("%02X", e8910.snd_regs[15]));
        updatePSG();
        
        three = new Thread("Play YM") 
        {
            public void run() 
            {

                byte[] soundBytes = new byte[SOUNDBUFFER_SIZE];
                
                line.start();
                currentHz = jComboBox1.getSelectedIndex()==0?50:60;
                compareMilli = 1000/currentHz;

                
                long lastTime = 0;
                while (playingYM)
                {
                    long endTime = System.nanoTime();
                    long durationMilli = (endTime - lastTime)/1000000;
                    if (durationMilli>=compareMilli)
                    {
                        for (int r=0; r< 15; r++)
                        {
                            if (!usedRegs[r]) continue;
                            byte value = ymSound.out_buf[r][ympos];
                            if ((r == 13) && (value&0xff) == 0xff) 
                                continue;
                
                            byte poker = value;
                            int i=r;
                            if ((i==1)||(i==3)||(i==5))
                                poker &= 1+2+4+8;
                            if ((i==6) )
                                poker &= 1+2+4+8+16;

                            if (i==7)
                                poker &= 1+2+4+8+16+32;
                            // for vectrex
                            if ((i==8)||(i==9)||(i==10))
                                poker &= 1+2+4+8;
                            
                            e8910.e8910_write(r,  poker&0xff);
                            workBuf[r] = (byte)e8910.snd_regs[r];
                        }
                        if (loopStart<0)
                            ympos = (ympos+1)%ymSound.vbl_len;
                        else
                        {
                            ympos+=1;
                            if (ympos > loopEnd) ympos = (int)loopStart;
                        }
                        

                        SwingUtilities.invokeLater(new Runnable()
                        {
                            public void run()
                            {
                                DissiPanel.scrollToVisibleMid(jTable2, ympos, 0);
                                jTable1.repaint();
                                jTable2.repaint();
                                if (usedRegs[0])
                                    jTextField1a.setText("$"+String.format("%02X", e8910.snd_regs[0]));
                                if (usedRegs[1])
                                    jTextField2a.setText("$"+String.format("%02X", e8910.snd_regs[1]));
                                if (usedRegs[2])
                                    jTextField3a.setText("$"+String.format("%02X", e8910.snd_regs[2]));
                                if (usedRegs[3])
                                    jTextField4a.setText("$"+String.format("%02X", e8910.snd_regs[3]));
                                if (usedRegs[4])
                                    jTextField5a.setText("$"+String.format("%02X", e8910.snd_regs[4]));
                                if (usedRegs[5])
                                    jTextField6a.setText("$"+String.format("%02X", e8910.snd_regs[5]));
                                if (usedRegs[6])
                                    jTextField7a.setText("$"+String.format("%02X", e8910.snd_regs[6]));
                                if (usedRegs[7])
                                    jTextField8a.setText("$"+String.format("%02X", e8910.snd_regs[7]));
                                if (usedRegs[8])
                                    jTextField9a.setText("$"+String.format("%02X", e8910.snd_regs[8]));
                                if (usedRegs[9])
                                    jTextField10a.setText("$"+String.format("%02X", e8910.snd_regs[9]));
                                if (usedRegs[10])
                                    jTextField11a.setText("$"+String.format("%02X", e8910.snd_regs[10]));
                                if (usedRegs[11])
                                    jTextField12a.setText("$"+String.format("%02X", e8910.snd_regs[11]));
                                if (usedRegs[12])
                                    jTextField13a.setText("$"+String.format("%02X", e8910.snd_regs[12]));
                                if (usedRegs[13])
                                    jTextField14a.setText("$"+String.format("%02X", e8910.snd_regs[13]));
                                if (usedRegs[14])
                                    jTextField15a.setText("$"+String.format("%02X", e8910.snd_regs[14]));
                                if (usedRegs[15])
                                    jTextField16a.setText("$"+String.format("%02X", e8910.snd_regs[15]));
                                updateEnhanced(workBuf);
                                updatePSG();
                            }
                        });                                     

                        lastTime = endTime;

                        int soundLength = line.available();
                        soundLength = soundLength >soundBytes.length ? soundBytes.length : soundLength;
                        if (soundLength>=0)
                        {
                            e8910.e8910_callback(soundBytes, soundLength);
                            line.write(soundBytes, 0, soundLength);
                        }
                    
                    }
                    

                    try
                    {
                        Thread.sleep(1);
                    }
                    catch (Throwable e)
                    {
                    }
                    
                    
                    
                }
                line.stop();
                three = null;
                line.unload();
            }  
        };
        playingYM = true;
        three.start();           
    }    
    int inEvent=0;
    byte[] workBuf = new byte[16];
    void workBufToSelection()
    {
        for (int r=0; r< 15; r++)
        {
            byte value = ymSound.out_buf[r][ympos];
            byte poker = value;
            int i=r;
            if ((i==1)||(i==3)||(i==5)) poker   &= 0x0f;
            if ((i==6) ) poker                  &= 0x1f;
            if  (i==7) poker                    &= 0x3f;
            if ((i==8)||(i==9)||(i==10)) poker  &= 0x0f;
            workBuf[r] = (byte)poker;
        }                
        
        updateEnhanced(workBuf);
        jTextField1a.setText("$"+String.format("%02X", workBuf[0]));
        jTextField2a.setText("$"+String.format("%02X", workBuf[1]));
        jTextField3a.setText("$"+String.format("%02X", workBuf[2]));
        jTextField4a.setText("$"+String.format("%02X", workBuf[3]));
        jTextField5a.setText("$"+String.format("%02X", workBuf[4]));
        jTextField6a.setText("$"+String.format("%02X", workBuf[5]));
        jTextField7a.setText("$"+String.format("%02X", workBuf[6]));
        jTextField8a.setText("$"+String.format("%02X", workBuf[7]));
        jTextField9a.setText("$"+String.format("%02X", workBuf[8]));
        jTextField10a.setText("$"+String.format("%02X", workBuf[9]));
        jTextField11a.setText("$"+String.format("%02X", workBuf[10]));
        jTextField12a.setText("$"+String.format("%02X", workBuf[11]));
        jTextField13a.setText("$"+String.format("%02X", workBuf[12]));
        jTextField14a.setText("$"+String.format("%02X", workBuf[13]));
        jTextField15a.setText("$"+String.format("%02X", workBuf[14]));
        jTextField16a.setText("$"+String.format("%02X", workBuf[15]));
    }
    void updateEnhanced(byte[] buf)
    {
        inEvent++;
        //buf[r];
        int freqA = (buf[1]&0xf)*256+(buf[0]&0xff);
        int freqB = (buf[3]&0xf)*256+(buf[2]&0xff);
        int freqC = (buf[5]&0xf)*256+(buf[4]&0xff);
        
        Integer i = Mod2Vectrex.freq2Index.get(freqA);
        if (i!=null) jComboBoxNotesA.setSelectedIndex(i); else jComboBoxNotesA.setSelectedIndex(-1);
        i = Mod2Vectrex.freq2Index.get(freqB);
        if (i!=null) jComboBoxNotesB.setSelectedIndex(i); else jComboBoxNotesB.setSelectedIndex(-1);
        i = Mod2Vectrex.freq2Index.get(freqC);
        if (i!=null) jComboBoxNotesC.setSelectedIndex(i); else jComboBoxNotesC.setSelectedIndex(-1);
        
        int noisePeriod = buf[6]&0x1f;
        jSliderNoise.setValue(noisePeriod);
        
        int r7 = buf[7];
        jCheckBoxNoiseC.setSelected(!((r7 & 0x20) != 0));
        jCheckBoxNoiseB.setSelected(!((r7 & 0x10) != 0));
        jCheckBoxNoiseA.setSelected(!((r7 & 0x08) != 0));
        jCheckBoxToneC.setSelected(!((r7 & 0x04) != 0));
        jCheckBoxToneB.setSelected(!((r7 & 0x02) != 0));
        jCheckBoxToneA.setSelected(!((r7 & 0x01) != 0));
        
        int r8 = buf[8];
        jCheckBoxModeA.setSelected(((r8 & 0x10) != 0));
        jSliderAmplidtudeA.setValue((r8&0x0f));

        int r9 = buf[9];
        jCheckBoxModeB.setSelected(((r9 & 0x10) != 0));
        jSliderAmplidtudeB.setValue((r9&0x0f));
        
        int r10 = buf[10];
        jCheckBoxModeC.setSelected(((r10 & 0x10) != 0));
        jSliderAmplidtudeC.setValue((r10&0x0f));

        int envelopeIndex = -1;
        int r13 = buf[13] & 0x0f;
        
        if ((r13 & 0x03) == 0) envelopeIndex = 0;// Down
        if ((r13 & 0x06) == 4) envelopeIndex = 1;// UpMin
        if ((r13 & 0x0f) == 8) envelopeIndex = 2;// Triangle1
        if ((r13 & 0x0f) == 9) envelopeIndex = 0;// Down
        if ((r13 & 0x0f) == 10) envelopeIndex = 3;// Saw1
        if ((r13 & 0x0f) == 11) envelopeIndex = 4;// DownMax
        if ((r13 & 0x0f) == 12) envelopeIndex = 7;// Triangle2
        if ((r13 & 0x0f) == 13) envelopeIndex = 6;// Up
        if ((r13 & 0x0f) == 14) envelopeIndex = 5;// Saw2
        if ((r13 & 0x0f) == 15) envelopeIndex = 1;// UpMin
        
        jComboBoxEnvelope.setSelectedIndex(envelopeIndex);
        inEvent--;
    }
    void setFromEnhanced()
    {
        if (inEvent>0) return;
        if (jTable1.isEditing()) jTable1.getCellEditor().stopCellEditing();        
        int indexA = jComboBoxNotesA.getSelectedIndex();
        if (indexA>=0)
        {
            int freq = Mod2Vectrex.PSG_PERIOD[indexA];
            workBuf[0] = (byte)(freq&0xff);
            workBuf[1] = (byte)((freq>>8)&0x0f);
        }
        int indexB = jComboBoxNotesB.getSelectedIndex();
        if (indexB>=0)
        {
            int freq = Mod2Vectrex.PSG_PERIOD[indexB];
            workBuf[2] = (byte)(freq&0xff);
            workBuf[3] = (byte)((freq>>8)&0x0f);
        }
        int indexC = jComboBoxNotesC.getSelectedIndex();
        if (indexC>=0)
        {
            int freq = Mod2Vectrex.PSG_PERIOD[indexC];
            workBuf[4] = (byte)(freq&0xff);
            workBuf[5] = (byte)((freq>>8)&0x0f);
        }
        workBuf[6] = (byte) (jSliderNoise.getValue() & 0x1f);
        workBuf[7] = 0;
        workBuf[7] += jCheckBoxNoiseC.isSelected()?0:0x20;
        workBuf[7] += jCheckBoxNoiseB.isSelected()?0:0x10;
        workBuf[7] += jCheckBoxNoiseA.isSelected()?0:0x08;
        workBuf[7] += jCheckBoxToneC.isSelected()?0:0x04;
        workBuf[7] += jCheckBoxToneB.isSelected()?0:0x02;
        workBuf[7] += jCheckBoxToneA.isSelected()?0:0x01;
        
        workBuf[8] = (byte) (jSliderAmplidtudeA.getValue() & 0x0f);
        if (jCheckBoxModeA.isSelected()) workBuf[8] += 0x10;
        workBuf[9] = (byte) (jSliderAmplidtudeB.getValue() & 0x0f);
        if (jCheckBoxModeB.isSelected()) workBuf[9] += 0x10;
        workBuf[10] = (byte) (jSliderAmplidtudeC.getValue() & 0x0f);
        if (jCheckBoxModeC.isSelected()) workBuf[10] += 0x10;
        
        if (jComboBoxEnvelope.getSelectedIndex() == 0) workBuf[13] = (byte) 0x00;
        if (jComboBoxEnvelope.getSelectedIndex() == 1) workBuf[13] = (byte) 0x04;
        if (jComboBoxEnvelope.getSelectedIndex() == 2) workBuf[13] = (byte) 0x08;
        if (jComboBoxEnvelope.getSelectedIndex() == 3) workBuf[13] = (byte) 0x0a;
        if (jComboBoxEnvelope.getSelectedIndex() == 4) workBuf[13] = (byte) 0x0b;
        if (jComboBoxEnvelope.getSelectedIndex() == 5) workBuf[13] = (byte) 0x0e;
        if (jComboBoxEnvelope.getSelectedIndex() == 6) workBuf[13] = (byte) 0x0d;
        if (jComboBoxEnvelope.getSelectedIndex() == 7) workBuf[13] = (byte) 0x0c;
        
        for (int i=0; i< 14; i++)
        {
            ymSound.out_buf[i][ympos] = workBuf[i];
        }
        jTextField1a.setText("$"+String.format("%02X", workBuf[0]));
        jTextField2a.setText("$"+String.format("%02X", workBuf[1]));
        jTextField3a.setText("$"+String.format("%02X", workBuf[2]));
        jTextField4a.setText("$"+String.format("%02X", workBuf[3]));
        jTextField5a.setText("$"+String.format("%02X", workBuf[4]));
        jTextField6a.setText("$"+String.format("%02X", workBuf[5]));
        jTextField7a.setText("$"+String.format("%02X", workBuf[6]));
        jTextField8a.setText("$"+String.format("%02X", workBuf[7]));
        jTextField9a.setText("$"+String.format("%02X", workBuf[8]));
        jTextField10a.setText("$"+String.format("%02X", workBuf[9]));
        jTextField11a.setText("$"+String.format("%02X", workBuf[10]));
        jTextField12a.setText("$"+String.format("%02X", workBuf[11]));
        jTextField13a.setText("$"+String.format("%02X", workBuf[12]));
        jTextField14a.setText("$"+String.format("%02X", workBuf[13]));
        jTextField15a.setText("$"+String.format("%02X", workBuf[14]));
        jTextField16a.setText("$"+String.format("%02X", workBuf[15]));

        jTable1.repaint();
    }
    void updatePSG()
    {
        jLabelPSG0.setText("$"+String.format("%02X", e8910.snd_regs[0]));
        jLabelPSG1.setText("$"+String.format("%02X", e8910.snd_regs[1]));
        jLabelPSG2.setText("$"+String.format("%02X", e8910.snd_regs[2]));
        jLabelPSG3.setText("$"+String.format("%02X", e8910.snd_regs[3]));
        jLabelPSG4.setText("$"+String.format("%02X", e8910.snd_regs[4]));
        jLabelPSG5.setText("$"+String.format("%02X", e8910.snd_regs[5]));
        jLabelPSG6.setText("$"+String.format("%02X", e8910.snd_regs[6]));
        jLabelPSG7.setText("$"+String.format("%02X", e8910.snd_regs[7]));
        jLabelPSG8.setText("$"+String.format("%02X", e8910.snd_regs[8]));
        jLabelPSG9.setText("$"+String.format("%02X", e8910.snd_regs[9]));
        jLabelPSG10.setText("$"+String.format("%02X", e8910.snd_regs[10]));
        jLabelPSG11.setText("$"+String.format("%02X", e8910.snd_regs[11]));
        jLabelPSG12.setText("$"+String.format("%02X", e8910.snd_regs[12]));
        jLabelPSG13.setText("$"+String.format("%02X", e8910.snd_regs[13]));
        jLabelPSG14.setText("$"+String.format("%02X", e8910.snd_regs[14]));
        jLabelPSG15.setText("$"+String.format("%02X", e8910.snd_regs[15]));
        
    }
    boolean saveAYFX(boolean selectionOnly, String channel)
    {
        int start = 0;
        int end = ymSound.vbl_len;
        if (selectionOnly)
        {
            int[] rows = jTable1.getSelectedRows();
            if (rows.length<=0) return false;

            start = rows[0];
            end = start +1;
            if (rows.length>1) end = rows[rows.length-1];
        }
        
        InternalFrameFileChoser fc = new de.malban.gui.dialogs.InternalFrameFileChoser();

        if (lastPath.length()==0)
        {
            fc.setCurrentDirectory(new java.io.File(pathOnly));
        }
        else
        {
            fc.setCurrentDirectory(new java.io.File(lastPath));
        }
        FileNameExtensionFilter filter = new FileNameExtensionFilter("afx", "afx");
        fc.setFileFilter(filter);

        int re = fc.showOpenDialog(Configuration.getConfiguration().getMainFrame());
        if (re != InternalFrameFileChoser.APPROVE_OPTION) return false;
        lastPath = fc.getSelectedFile().getAbsolutePath();
        String recordingFilename = lastPath;
        if (!recordingFilename.toLowerCase().endsWith(".afx"))
            recordingFilename+=".afx";
        // open file
        try 
        {
            OutputStream output = null;
            try 
            {
                output = new BufferedOutputStream(new FileOutputStream(recordingFilename));
                boolean starting = true;
                for (int i=start; i<end; i++)
                {
                    byte toWrite =0;
                    byte toWrite2=0;
                    byte toWrite3=0;
                    byte toWrite4=0;
                    boolean doTone = false;
                    boolean doNoise = false;
                    boolean toneEnabled = true;
                    boolean noiseEnabled = true;
                    if (channel.equals("A"))
                    {
                        toWrite = (byte) (ymSound.out_buf[8][i] &0x0f);  // volume
                        if ((ymSound.out_buf[7][i] & 0x01) == 0x01) 
                        {
                            toWrite = (byte) (toWrite | 0x10); // is tone disabled
                            toneEnabled = false;
                        }
                            
                        if (starting) 
                        {
                            doTone = true;
                            doNoise = true;
                            toWrite = (byte) (toWrite | 0x20); // tone is changed (on start allways)
                            toWrite = (byte) (toWrite | 0x40); // noise is changed (on start allways)
                        }
                            
                        if (i>0)
                        {
                            if ((ymSound.out_buf[1][i]*256+ymSound.out_buf[0][i]) != (ymSound.out_buf[1][i-1]*256+ymSound.out_buf[0][i-1]))
                            {
                                doTone = true;
                                toWrite = (byte) (toWrite | 0x20); // tone is changed 
                            }
                            if ((ymSound.out_buf[6][i]) != (ymSound.out_buf[6][i-1]))
                            {
                                doNoise = true;
                                toWrite = (byte) (toWrite | 0x40); // noise is changed 
                            }
                        }
                        if ((ymSound.out_buf[7][i] & 0x08) == 0x08) 
                        {
                            toWrite = (byte) (toWrite | 0x80); // is noise disabled
                            noiseEnabled = false;
                        }
                            
                        if (doTone && toneEnabled)
                        {
                            toWrite2 = ymSound.out_buf[0][i];
                            toWrite3 = ymSound.out_buf[1][i];
                            if (doNoise && noiseEnabled)
                                toWrite4 = ymSound.out_buf[6][i];
                        }
                        else
                        {
                            if (doNoise && noiseEnabled)
                                toWrite2 = ymSound.out_buf[6][i];
                        }
                    }

                    if (channel.equals("B"))
                    {
                        toWrite = (byte) (ymSound.out_buf[9][i] &0x0f);  // volume
                        if ((ymSound.out_buf[7][i] & 0x02) == 0x02) 
                        {
                            toWrite = (byte) (toWrite | 0x10); // is tone disabled
                            toneEnabled = false;
                        }
                        if (starting) 
                        {
                            doTone = true;
                            doNoise = true;
                            toWrite = (byte) (toWrite | 0x20); // tone is changed (on start allways)
                            toWrite = (byte) (toWrite | 0x40); // noise is changed (on start allways)
                        }
                            
                        if (i>0)
                        {
                            if ((ymSound.out_buf[3][i]*256+ymSound.out_buf[2][i]) != (ymSound.out_buf[3][i-1]*256+ymSound.out_buf[2][i-1]))
                            {
                                doTone = true;
                                toWrite = (byte) (toWrite | 0x20); // tone is changed 
                            }
                            if ((ymSound.out_buf[6][i]) != (ymSound.out_buf[6][i-1]))
                            {
                                doNoise = true;
                                toWrite = (byte) (toWrite | 0x40); // noise is changed 
                            }
                        }
                        if ((ymSound.out_buf[7][i] & 0x10) == 0x10) 
                        {
                            toWrite = (byte) (toWrite | 0x80); // is noise disabled
                            noiseEnabled = false;
                        }
                        if (doTone && toneEnabled)
                        {
                            toWrite2 = ymSound.out_buf[2][i];
                            toWrite3 = ymSound.out_buf[3][i];
                            if (doNoise && noiseEnabled)
                                toWrite4 = ymSound.out_buf[6][i];
                        }
                        else
                        {
                            if (doNoise && noiseEnabled)
                                toWrite2 = ymSound.out_buf[6][i];
                        }
                    }

                    if (channel.equals("C"))
                    {
                        toWrite = (byte) (ymSound.out_buf[10][i] &0x0f);  // volume
                        if ((ymSound.out_buf[7][i] & 0x04) == 0x04) 
                        {
                            toWrite = (byte) (toWrite | 0x10); // is tone disabled
                            toneEnabled = false;
                        }
                        if (starting) 
                        {
                            doTone = true;
                            doNoise = true;
                            toWrite = (byte) (toWrite | 0x20); // tone is changed (on start allways)
                            toWrite = (byte) (toWrite | 0x40); // noise is changed (on start allways)
                        }
                            
                        if (i>0)
                        {
                            if ((ymSound.out_buf[5][i]*256+ymSound.out_buf[4][i]) != (ymSound.out_buf[5][i-1]*256+ymSound.out_buf[4][i-1]))
                            {
                                doTone = true;
                                toWrite = (byte) (toWrite | 0x20); // tone is changed 
                            }
                            if ((ymSound.out_buf[6][i]) != (ymSound.out_buf[6][i-1]))
                            {
                                doNoise = true;
                                toWrite = (byte) (toWrite | 0x40); // noise is changed 
                            }
                        }
                        if ((ymSound.out_buf[7][i] & 0x20) == 0x20) 
                        {
                            toWrite = (byte) (toWrite | 0x80); // is noise disabled
                            noiseEnabled = false;
                        }
                        if (doTone && toneEnabled)
                        {
                            toWrite2 = ymSound.out_buf[4][i];
                            toWrite3 = ymSound.out_buf[5][i];
                            if (doNoise && noiseEnabled)
                                toWrite4 = ymSound.out_buf[6][i];
                        }
                        else
                        {
                            if (doNoise && noiseEnabled)
                                toWrite2 = ymSound.out_buf[6][i];
                        }
                    }                    
                    
                    starting = false;
                    output.write(toWrite);
                    if (doTone)
                    {
                        output.write(toWrite2);
                        output.write(toWrite3);
                        if (doNoise)
                            output.write(toWrite4);
                    }
                    else
                    {
                        if (doNoise)
                            output.write(toWrite2);
                    }
                }
                output.write(0xd0);
                output.write(0x20);
            }
            finally 
            {
                output.flush();
                output.close();
            }
        }
        catch(Throwable ex)
        {
            log.addLog(ex, WARN);
            return false;
        }
        ((VediPanel)tinyLog).refreshTree();   
        return true;    
    }
    boolean loadAYFX(String channel, boolean overwrite)
    {
        if (jTable1.isEditing()) jTable1.getCellEditor().stopCellEditing();        
        InternalFrameFileChoser fc = new de.malban.gui.dialogs.InternalFrameFileChoser();

        if (lastPath.length()==0)
        {
            fc.setCurrentDirectory(new java.io.File(pathOnly));
        }
        else
        {
            fc.setCurrentDirectory(new java.io.File(lastPath));
        }
        FileNameExtensionFilter filter = new FileNameExtensionFilter("afx", "afx");
        fc.setFileFilter(filter);

        int re = fc.showOpenDialog(Configuration.getConfiguration().getMainFrame());
        if (re != InternalFrameFileChoser.APPROVE_OPTION) return false;
        lastPath = fc.getSelectedFile().getAbsolutePath();

        if (!lastPath.toLowerCase().endsWith(".afx"))
        {
            return false;
            
        }
        byte[] data = null;
        Path path = Paths.get(lastPath);
     
        String nameOnly = path.getFileName().toString();
        String barenameOnly = nameOnly.substring(0, nameOnly.length()-4); // is a ".afx", tehrefor a -4 must work!
        
        try
        {
            data = Files.readAllBytes(path);
        }
        catch (Throwable e)
        {
            log.addLog(e, WARN);
            return false;
        }

        byte[] workRow = new byte[16];
        int workPos;
        int count = 0;
        
        byte freq0 = 0;
        byte freq1 = 0;
        byte nfreq = 0;
        boolean noiseEver = false;
        while (true)
        {
            if (!overwrite)  // insert
            {
                ymSound.addRow(ympos);
            }
            workPos = ympos;
            ympos++;

            if ((ympos >ymSound.vbl_len) && (overwrite))
            {
                ympos = ymSound.vbl_len-1;
                tinyLog.printWarning("AYFX size > length and overwrite - not finished!");
                log.addLog("AYFX size > length and overwrite - not finished!", WARN);
                return false;
            }
            
            // get working copy from ym buff
            // this might be new (insert) or a overwrite
            for (int i=0; i<16; i++)
            {
                workRow[i] = ymSound.out_buf[i][workPos];
            }

            // now handle AYFX data bytes
            byte dataByte = data[count++];
            byte volume = (byte)(dataByte & 0x0f);
            boolean toneEnabled = (dataByte & 0x10) != 0x10;
            boolean toneChanged = (dataByte & 0x20) == 0x20;
            boolean noiseChanged = (dataByte & 0x40) == 0x40;
            boolean noiseEnabled = (dataByte & 0x80) != 0x80;
            
            noiseEver = noiseChanged | noiseEnabled;
            
            if (toneChanged)
            {
                freq0 = data[count++];
                freq1 = data[count++];
            }
            if (noiseChanged)
            {
                nfreq = data[count++];
            }
            if (noiseEver)
                workRow[6] = nfreq;
            
            if (channel.equals("A"))
            {
                workRow[8] = volume;
                if (!toneEnabled) workRow[7] = (byte) (workRow[7] | 0x01);
                else workRow[7] = (byte) (workRow[7] & 0xfe);
                if (!noiseEnabled) workRow[7] = (byte) (workRow[7] | 0x08);
                else workRow[7] = (byte) (workRow[7] & 0xf7);
                workRow[0] = freq0;
                workRow[1] = freq1;
            }
            if (channel.equals("B"))
            {
                workRow[9] = volume;
                if (!toneEnabled) workRow[7] = (byte) (workRow[7] | 0x02);
                else workRow[7] = (byte) (workRow[7] & 0xfd);
                if (!noiseEnabled) workRow[7] = (byte) (workRow[7] | 0x10);
                else workRow[7] = (byte) (workRow[7] & 0xef);
                workRow[2] = freq0;
                workRow[3] = freq1;
            }
            if (channel.equals("C"))
            {
                workRow[10] = volume;
                if (!toneEnabled) workRow[7] = (byte) (workRow[7] | 0x04);
                else workRow[7] = (byte) (workRow[7] & 0xfb);
                if (!noiseEnabled) workRow[7] = (byte) (workRow[7] | 0x20);
                else workRow[7] = (byte) (workRow[7] & 0xdf);
                workRow[4] = freq0;
                workRow[5] = freq1;
            }
            
            
            
            
            // set working copy to ym buff
            for (int i=0; i<16; i++)
            {
                ymSound.out_buf[i][workPos] = workRow[i];
            }
            
            if ((data[count]==(byte)0xd0) && (data[count+1]==(byte)0x20))
            {
                break;
            }
            if (count > data.length-1-2)
            {
                tinyLog.printWarning("Unexpected end of AYFX file encounterd: '"+path+"'");
                log.addLog("Unexpected end of AYFX file encounterd: '"+path+"'", WARN);
                break; // not a clean break;
            }
        }
        
        
        
        
        
        
        workBufToSelection();
        jTable1.tableChanged(null);
        jTable2.tableChanged(null);
        
        
        return true;
    }

}
/*
TODO
- done: load YM
- done: save YM
- done: add one register line
- done: PSG register view
- done: save selection as ym
- done: insert file
- done: copy
- done: paste
- copy / paste columns
- player for non compressed

*/