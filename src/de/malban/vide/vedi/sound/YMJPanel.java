/*
Ideas for further optmization of space usage

- preprocess ym files, and use sematic knowlegde to leave out registers as a whole
- e.g if amplitude = 0, no noise/frequency must be set at all!
- if noise and tone = disabled, none of the other registers of that voice need be processed

*/


/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vedi.sound;

import de.muntjak.tinylookandfeel.Theme;
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
import de.malban.vide.vedi.VediPanel;
import de.malban.vide.vedi.VediPanel32;
import java.awt.Color;
import java.awt.Component;
import java.awt.Point;
import java.awt.event.ActionEvent;
import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;
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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import javax.swing.DefaultComboBoxModel;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JInternalFrame;
import javax.swing.JScrollBar;
import javax.swing.JTable;
import javax.swing.JTextField;
import javax.swing.SwingUtilities;
import javax.swing.UIManager;
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
    String startPath = "";
    Thread two = null;
    Thread three = null;
    YmSound ymSound;
    TinyLogInterface tinyLog = null;
    private int mClassSetting=0;
    private CSAView mParent = null;
    private javax.swing.JMenuItem mParentMenuItem = null;

    @Override
    public void closing()
    {
        playingYM = false;
        removeUIListerner();
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
        jCheckBox26.setVisible(false);
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
        startPath = pathOnly;
        lastPath = startPath;

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
        initLister();
        UIManager.addPropertyChangeListener(pListener);
        updateMyUI(); 
        
    }

    boolean initYM(String filename)
    {
        // check if is a file or a dir
        if (filename == null) filename = "";
        File file = new File(filename);
        
        if (file.isDirectory())
        {
            pathOnly = filename;
        }
        else if (filename.length()!=0)
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
        jButtonCut = new javax.swing.JButton();
        jScrollPane2 = new javax.swing.JScrollPane();
        jTable2 = new javax.swing.JTable();
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
        jButtonSwap12 = new javax.swing.JButton();
        jButton11 = new javax.swing.JButton();
        jButton13 = new javax.swing.JButton();
        jButtonAddRow = new javax.swing.JButton();
        jButtonCopy = new javax.swing.JButton();
        jButtonPaste = new javax.swing.JButton();
        jButtonInsertYM = new javax.swing.JButton();
        jButtonSaveSelection = new javax.swing.JButton();
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
        jButtonSaveSelection1 = new javax.swing.JButton();
        jPanel12 = new javax.swing.JPanel();
        jComboBox1 = new javax.swing.JComboBox();
        jLabel20 = new javax.swing.JLabel();
        jButtonNewYM = new javax.swing.JButton();
        jButtonSave = new javax.swing.JButton();
        jButtonLoad = new javax.swing.JButton();
        jButtonStop3 = new javax.swing.JButton();
        jButtonStop2 = new javax.swing.JButton();
        jButtonPlaySample = new javax.swing.JButton();
        jLabel6 = new javax.swing.JLabel();
        jLabel10 = new javax.swing.JLabel();
        jTabbedPane1 = new javax.swing.JTabbedPane();
        jPanel10 = new javax.swing.JPanel();
        jLabel142 = new javax.swing.JLabel();
        jLabel140 = new javax.swing.JLabel();
        jLabel139 = new javax.swing.JLabel();
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
        jLabel112 = new javax.swing.JLabel();
        jLabel141 = new javax.swing.JLabel();
        jLabel138 = new javax.swing.JLabel();
        jLabel137 = new javax.swing.JLabel();
        jLabel136 = new javax.swing.JLabel();
        jLabel135 = new javax.swing.JLabel();
        jPanel8 = new javax.swing.JPanel();
        jButtonLoad3 = new javax.swing.JButton();
        jButtonSave3 = new javax.swing.JButton();
        jCheckBox18 = new javax.swing.JCheckBox();
        jCheckBox21 = new javax.swing.JCheckBox();
        jLabel148 = new javax.swing.JLabel();
        jLabel147 = new javax.swing.JLabel();
        jLabel146 = new javax.swing.JLabel();
        jPanel7 = new javax.swing.JPanel();
        jButtonLoad2 = new javax.swing.JButton();
        jButtonSave2 = new javax.swing.JButton();
        jCheckBox17 = new javax.swing.JCheckBox();
        jCheckBox20 = new javax.swing.JCheckBox();
        jLabel144 = new javax.swing.JLabel();
        jCheckBoxCreatePlayer = new javax.swing.JCheckBox();
        jComboBox2 = new javax.swing.JComboBox();
        jPanel6 = new javax.swing.JPanel();
        jButtonLoad1 = new javax.swing.JButton();
        jButtonSave1 = new javax.swing.JButton();
        jCheckBox19 = new javax.swing.JCheckBox();
        jCheckBox22 = new javax.swing.JCheckBox();
        jLabel143 = new javax.swing.JLabel();
        jPanel9 = new javax.swing.JPanel();
        jScrollPane3 = new javax.swing.JScrollPane();
        jTable3 = new javax.swing.JTable();
        jPanel11 = new javax.swing.JPanel();
        jLabel145 = new javax.swing.JLabel();
        jCheckBox23 = new javax.swing.JCheckBox();
        jCheckBox24 = new javax.swing.JCheckBox();
        jCheckBox25 = new javax.swing.JCheckBox();
        jButton1 = new javax.swing.JButton();
        jLabel149 = new javax.swing.JLabel();
        jLabel150 = new javax.swing.JLabel();
        jLabel151 = new javax.swing.JLabel();
        jLabel152 = new javax.swing.JLabel();
        jButton2 = new javax.swing.JButton();
        jButton3 = new javax.swing.JButton();
        jButton4 = new javax.swing.JButton();
        jButton5 = new javax.swing.JButton();
        jButton6 = new javax.swing.JButton();
        jTextField1 = new javax.swing.JTextField();
        jTextField2 = new javax.swing.JTextField();
        jTextField3 = new javax.swing.JTextField();
        jButton7 = new javax.swing.JButton();
        jButton8 = new javax.swing.JButton();
        jButton9 = new javax.swing.JButton();
        jLabel153 = new javax.swing.JLabel();
        jCheckBoxForce1 = new javax.swing.JCheckBox();
        jCheckBoxForce2 = new javax.swing.JCheckBox();
        jCheckBoxForce3 = new javax.swing.JCheckBox();
        jButtonCancel = new javax.swing.JButton();
        jButtonCreate = new javax.swing.JButton();
        jCheckBox26 = new javax.swing.JCheckBox();

        setPreferredSize(new java.awt.Dimension(960, 537));

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

        jPanel3.setLayout(null);

        jCheckBox1.setSelected(true);
        jCheckBox1.setMargin(new java.awt.Insets(0, 2, 0, 2));
        jCheckBox1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox1ActionPerformed(evt);
            }
        });
        jPanel3.add(jCheckBox1);
        jCheckBox1.setBounds(10, 0, 18, 16);

        jCheckBox2.setSelected(true);
        jCheckBox2.setMargin(new java.awt.Insets(0, 2, 0, 2));
        jCheckBox2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox1ActionPerformed(evt);
            }
        });
        jPanel3.add(jCheckBox2);
        jCheckBox2.setBounds(45, 0, 17, 16);

        jCheckBox3.setSelected(true);
        jCheckBox3.setMargin(new java.awt.Insets(0, 2, 0, 2));
        jCheckBox3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox1ActionPerformed(evt);
            }
        });
        jPanel3.add(jCheckBox3);
        jCheckBox3.setBounds(80, 0, 17, 16);

        jCheckBox4.setSelected(true);
        jCheckBox4.setMargin(new java.awt.Insets(0, 2, 0, 2));
        jCheckBox4.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox1ActionPerformed(evt);
            }
        });
        jPanel3.add(jCheckBox4);
        jCheckBox4.setBounds(115, 0, 17, 16);

        jCheckBox5.setSelected(true);
        jCheckBox5.setMargin(new java.awt.Insets(0, 2, 0, 2));
        jCheckBox5.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox1ActionPerformed(evt);
            }
        });
        jPanel3.add(jCheckBox5);
        jCheckBox5.setBounds(150, 0, 17, 16);

        jCheckBox6.setSelected(true);
        jCheckBox6.setMargin(new java.awt.Insets(0, 2, 0, 2));
        jCheckBox6.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox1ActionPerformed(evt);
            }
        });
        jPanel3.add(jCheckBox6);
        jCheckBox6.setBounds(185, 0, 17, 16);

        jCheckBox7.setSelected(true);
        jCheckBox7.setMargin(new java.awt.Insets(0, 2, 0, 2));
        jCheckBox7.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox1ActionPerformed(evt);
            }
        });
        jPanel3.add(jCheckBox7);
        jCheckBox7.setBounds(220, 0, 17, 16);

        jCheckBox8.setSelected(true);
        jCheckBox8.setMargin(new java.awt.Insets(0, 2, 0, 2));
        jCheckBox8.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox1ActionPerformed(evt);
            }
        });
        jPanel3.add(jCheckBox8);
        jCheckBox8.setBounds(255, 0, 17, 16);

        jCheckBox9.setSelected(true);
        jCheckBox9.setMargin(new java.awt.Insets(0, 2, 0, 2));
        jCheckBox9.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox1ActionPerformed(evt);
            }
        });
        jPanel3.add(jCheckBox9);
        jCheckBox9.setBounds(290, 0, 17, 16);

        jCheckBox10.setSelected(true);
        jCheckBox10.setMargin(new java.awt.Insets(0, 2, 0, 2));
        jCheckBox10.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox1ActionPerformed(evt);
            }
        });
        jPanel3.add(jCheckBox10);
        jCheckBox10.setBounds(325, 0, 17, 16);

        jCheckBox11.setSelected(true);
        jCheckBox11.setMargin(new java.awt.Insets(0, 2, 0, 2));
        jCheckBox11.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox1ActionPerformed(evt);
            }
        });
        jPanel3.add(jCheckBox11);
        jCheckBox11.setBounds(360, 0, 17, 16);

        jCheckBox12.setMargin(new java.awt.Insets(0, 2, 0, 2));
        jCheckBox12.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox1ActionPerformed(evt);
            }
        });
        jPanel3.add(jCheckBox12);
        jCheckBox12.setBounds(395, 0, 17, 16);

        jCheckBox13.setMargin(new java.awt.Insets(0, 2, 0, 2));
        jCheckBox13.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox1ActionPerformed(evt);
            }
        });
        jPanel3.add(jCheckBox13);
        jCheckBox13.setBounds(430, 0, 17, 16);

        jCheckBox14.setMargin(new java.awt.Insets(0, 2, 0, 2));
        jCheckBox14.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox1ActionPerformed(evt);
            }
        });
        jPanel3.add(jCheckBox14);
        jCheckBox14.setBounds(465, 0, 17, 16);

        jCheckBox15.setMargin(new java.awt.Insets(0, 2, 0, 2));
        jCheckBox15.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox1ActionPerformed(evt);
            }
        });
        jPanel3.add(jCheckBox15);
        jCheckBox15.setBounds(500, 0, 17, 16);

        jCheckBox16.setMargin(new java.awt.Insets(0, 2, 0, 2));
        jCheckBox16.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox1ActionPerformed(evt);
            }
        });
        jPanel3.add(jCheckBox16);
        jCheckBox16.setBounds(535, 0, 17, 16);

        jButtonCut.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/cut.png"))); // NOI18N
        jButtonCut.setToolTipText("Cut current selection!");
        jButtonCut.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonCut.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonCutActionPerformed(evt);
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

        jPanel4.setLayout(null);

        jTextField16a.setFont(new java.awt.Font("Courier New", 0, 12)); // NOI18N
        jTextField16a.setText("$00");
        jTextField16a.setToolTipText("double click writes value to PSG emulation, shift double click to complete column");
        jTextField16a.setName("15"); // NOI18N
        jTextField16a.setPreferredSize(new java.awt.Dimension(30, 18));
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
        jTextField1a.setToolTipText("double click writes value to PSG emulation, shift double click to complete column");
        jTextField1a.setName("0"); // NOI18N
        jTextField1a.setPreferredSize(new java.awt.Dimension(30, 18));
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
        jTextField2a.setToolTipText("double click writes value to PSG emulation, shift double click to complete column");
        jTextField2a.setName("1"); // NOI18N
        jTextField2a.setPreferredSize(new java.awt.Dimension(30, 18));
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
        jTextField3a.setToolTipText("double click writes value to PSG emulation, shift double click to complete column");
        jTextField3a.setName("2"); // NOI18N
        jTextField3a.setPreferredSize(new java.awt.Dimension(30, 18));
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
        jTextField4a.setToolTipText("double click writes value to PSG emulation, shift double click to complete column");
        jTextField4a.setName("3"); // NOI18N
        jTextField4a.setPreferredSize(new java.awt.Dimension(30, 18));
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
        jTextField5a.setToolTipText("double click writes value to PSG emulation, shift double click to complete column");
        jTextField5a.setName("4"); // NOI18N
        jTextField5a.setPreferredSize(new java.awt.Dimension(30, 18));
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
        jTextField6a.setToolTipText("double click writes value to PSG emulation, shift double click to complete column");
        jTextField6a.setName("5"); // NOI18N
        jTextField6a.setPreferredSize(new java.awt.Dimension(30, 18));
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
        jTextField7a.setToolTipText("double click writes value to PSG emulation, shift double click to complete column");
        jTextField7a.setName("6"); // NOI18N
        jTextField7a.setPreferredSize(new java.awt.Dimension(30, 18));
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
        jTextField8a.setToolTipText("double click writes value to PSG emulation, shift double click to complete column");
        jTextField8a.setName("7"); // NOI18N
        jTextField8a.setPreferredSize(new java.awt.Dimension(30, 18));
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
        jTextField9a.setToolTipText("double click writes value to PSG emulation, shift double click to complete column");
        jTextField9a.setName("8"); // NOI18N
        jTextField9a.setPreferredSize(new java.awt.Dimension(30, 18));
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
        jTextField10a.setToolTipText("double click writes value to PSG emulation, shift double click to complete column");
        jTextField10a.setName("9"); // NOI18N
        jTextField10a.setPreferredSize(new java.awt.Dimension(30, 18));
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
        jTextField11a.setToolTipText("double click writes value to PSG emulation, shift double click to complete column");
        jTextField11a.setName("10"); // NOI18N
        jTextField11a.setPreferredSize(new java.awt.Dimension(30, 18));
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
        jTextField12a.setToolTipText("double click writes value to PSG emulation, shift double click to complete column");
        jTextField12a.setName("11"); // NOI18N
        jTextField12a.setPreferredSize(new java.awt.Dimension(30, 18));
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
        jTextField13a.setToolTipText("double click writes value to PSG emulation, shift double click to complete column");
        jTextField13a.setName("12"); // NOI18N
        jTextField13a.setPreferredSize(new java.awt.Dimension(30, 18));
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
        jTextField14a.setToolTipText("double click writes value to PSG emulation, shift double click to complete column");
        jTextField14a.setName("13"); // NOI18N
        jTextField14a.setPreferredSize(new java.awt.Dimension(30, 18));
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
        jTextField15a.setToolTipText("double click writes value to PSG emulation, shift double click to complete column");
        jTextField15a.setName("14"); // NOI18N
        jTextField15a.setPreferredSize(new java.awt.Dimension(30, 18));
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
        jLabel78.setMaximumSize(new java.awt.Dimension(5, 10));
        jLabel78.setMinimumSize(new java.awt.Dimension(5, 10));
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
        jComboBoxNotesA.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBoxNotesAActionPerformed(evt);
            }
        });

        jComboBoxNotesB.setBackground(new java.awt.Color(255, 204, 255));
        jComboBoxNotesB.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "C#1" }));
        jComboBoxNotesB.setName("B"); // NOI18N
        jComboBoxNotesB.setPreferredSize(new java.awt.Dimension(59, 19));
        jComboBoxNotesB.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBoxNotesBActionPerformed(evt);
            }
        });

        jComboBoxNotesC.setBackground(new java.awt.Color(255, 204, 204));
        jComboBoxNotesC.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "C#1" }));
        jComboBoxNotesC.setName("C"); // NOI18N
        jComboBoxNotesC.setPreferredSize(new java.awt.Dimension(59, 19));
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

        jButtonSwap12.setFont(new java.awt.Font("Tahoma", 0, 10)); // NOI18N
        jButtonSwap12.setText("1<->2");
        jButtonSwap12.setToolTipText("Swap voices");
        jButtonSwap12.setMargin(new java.awt.Insets(2, 2, 2, 2));
        jButtonSwap12.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSwap12ActionPerformed(evt);
            }
        });

        jButton11.setFont(new java.awt.Font("Tahoma", 0, 10)); // NOI18N
        jButton11.setText("2<->3");
        jButton11.setToolTipText("Swap voices");
        jButton11.setMargin(new java.awt.Insets(2, 2, 2, 2));
        jButton11.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton11ActionPerformed(evt);
            }
        });

        jButton13.setFont(new java.awt.Font("Tahoma", 0, 10)); // NOI18N
        jButton13.setText("3<->1");
        jButton13.setToolTipText("Swap voices");
        jButton13.setMargin(new java.awt.Insets(2, 2, 2, 2));
        jButton13.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton13ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel5Layout = new javax.swing.GroupLayout(jPanel5);
        jPanel5.setLayout(jPanel5Layout);
        jPanel5Layout.setHorizontalGroup(
            jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel5Layout.createSequentialGroup()
                .addGap(8, 8, 8)
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                        .addComponent(jLabel7, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLabel9, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLabel24, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel23, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel8, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)))
                    .addGroup(jPanel5Layout.createSequentialGroup()
                        .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                                .addComponent(jLabel27, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jLabel28, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jLabel25, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jLabel26, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)))
                            .addComponent(jLabel30, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jComboBoxNotesA, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jButtonSwap12, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE))))
                .addGap(4, 4, 4)
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
                        .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jComboBoxNotesB, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jButton11, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(10, 10, 10)
                        .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                                .addComponent(jLabel47, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jLabel48, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jLabel45, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jLabel46, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)))
                            .addComponent(jLabel49, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE))))
                .addGap(0, 0, 0)
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jComboBoxNotesC, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButton13, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE))
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
                .addGap(2, 2, 2)
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
                .addGap(2, 2, 2)
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
                .addGap(2, 2, 2)
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
                        .addGap(2, 2, 2)
                        .addComponent(jLabel78, javax.swing.GroupLayout.PREFERRED_SIZE, 8, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
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
                .addGap(15, 15, 15)
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
                .addContainerGap(23, Short.MAX_VALUE))
        );
        jPanel5Layout.setVerticalGroup(
            jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel5Layout.createSequentialGroup()
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jCheckBoxNoiseA)
                    .addComponent(jCheckBoxToneA))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jCheckBoxToneB)
                    .addComponent(jCheckBoxNoiseB))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jCheckBoxToneC)
                    .addComponent(jCheckBoxNoiseC))
                .addGap(1, 1, 1))
            .addGroup(jPanel5Layout.createSequentialGroup()
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel5Layout.createSequentialGroup()
                        .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel5Layout.createSequentialGroup()
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
                                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addGroup(jPanel5Layout.createSequentialGroup()
                                        .addComponent(jLabel28, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addGap(0, 0, 0)
                                        .addComponent(jLabel27, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                                    .addComponent(jComboBoxNotesA, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                                .addGap(0, 0, 0)
                                .addComponent(jLabel26, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
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
                                .addComponent(jLabel46, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                        .addGap(0, 0, 0)
                        .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jButton11, javax.swing.GroupLayout.PREFERRED_SIZE, 13, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jButton13, javax.swing.GroupLayout.PREFERRED_SIZE, 13, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jButtonSwap12, javax.swing.GroupLayout.PREFERRED_SIZE, 13, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(3, 3, 3)
                        .addComponent(jLabel49, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel5Layout.createSequentialGroup()
                        .addGap(82, 82, 82)
                        .addComponent(jLabel45, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel5Layout.createSequentialGroup()
                        .addGap(50, 50, 50)
                        .addComponent(jComboBoxNotesC, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel5Layout.createSequentialGroup()
                        .addGap(83, 83, 83)
                        .addComponent(jLabel25, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel5Layout.createSequentialGroup()
                        .addGap(101, 101, 101)
                        .addComponent(jLabel30, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel5Layout.createSequentialGroup()
                        .addGap(98, 98, 98)
                        .addComponent(jLabel38, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel5Layout.createSequentialGroup()
                        .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
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
                                .addComponent(jLabel74, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(jPanel5Layout.createSequentialGroup()
                                .addComponent(jLabel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(0, 0, 0)
                                .addComponent(jLabel2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(0, 0, 0)
                                .addComponent(jLabel3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(0, 0, 0)
                                .addComponent(jLabel4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(0, 0, 0)
                                .addComponent(jLabel5, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel78, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel68, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel58, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jCheckBoxModeC, javax.swing.GroupLayout.Alignment.TRAILING)
                            .addComponent(jCheckBoxModeB, javax.swing.GroupLayout.Alignment.TRAILING)
                            .addComponent(jCheckBoxModeA, javax.swing.GroupLayout.Alignment.TRAILING)))
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
                    .addComponent(jSliderNoise, javax.swing.GroupLayout.PREFERRED_SIZE, 108, javax.swing.GroupLayout.PREFERRED_SIZE)
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
                    .addGroup(jPanel5Layout.createSequentialGroup()
                        .addGap(98, 98, 98)
                        .addComponent(jLabel106, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
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
                        .addComponent(jLabel102, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
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
                        .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addGroup(jPanel5Layout.createSequentialGroup()
                                .addComponent(jLabel37, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(0, 0, 0)
                                .addComponent(jLabel36, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addComponent(jComboBoxNotesB, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(0, 0, 0)
                        .addComponent(jLabel35, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(0, 0, 0)
                        .addComponent(jLabel34, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addGap(0, 2, Short.MAX_VALUE))
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

        jButtonSaveSelection1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/drive_user.png"))); // NOI18N
        jButtonSaveSelection1.setToolTipText("insert data from a text file (db statements)");
        jButtonSaveSelection1.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonSaveSelection1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSaveSelection1ActionPerformed(evt);
            }
        });

        jComboBox1.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "50 Hz", "60 Hz" }));
        jComboBox1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBox1ActionPerformed(evt);
            }
        });

        jLabel20.setText("speed:");

        jButtonNewYM.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/new.png"))); // NOI18N
        jButtonNewYM.setToolTipText("new YM window");
        jButtonNewYM.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonNewYM.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonNewYMActionPerformed(evt);
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

        jButtonLoad.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/page_go.png"))); // NOI18N
        jButtonLoad.setToolTipText("load YM");
        jButtonLoad.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonLoad.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonLoadActionPerformed(evt);
            }
        });

        jButtonStop3.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/control_rewind_blue.png"))); // NOI18N
        jButtonStop3.setToolTipText("Rewind");
        jButtonStop3.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonStop3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonStop3ActionPerformed(evt);
            }
        });

        jButtonStop2.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/control_stop_blue.png"))); // NOI18N
        jButtonStop2.setToolTipText("Stop playing current YM");
        jButtonStop2.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonStop2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonStop2ActionPerformed(evt);
            }
        });

        jButtonPlaySample.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/control_play_blue.png"))); // NOI18N
        jButtonPlaySample.setToolTipText("Play current YM!");
        jButtonPlaySample.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonPlaySample.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonPlaySampleActionPerformed(evt);
            }
        });

        jLabel6.setText("File:");

        jLabel10.setText("Song:");

        jLabel142.setText("bitstream dictionary");

        jLabel140.setText("0");

        jLabel139.setText("distinct bitstream lines");

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
        jComboBoxInterleaved.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBoxInterleavedActionPerformed(evt);
            }
        });

        jLabel112.setText("individual: ");

        jLabel141.setText("0");

        javax.swing.GroupLayout jPanel2Layout = new javax.swing.GroupLayout(jPanel2);
        jPanel2.setLayout(jPanel2Layout);
        jPanel2Layout.setHorizontalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                        .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel22, javax.swing.GroupLayout.DEFAULT_SIZE, 92, Short.MAX_VALUE)
                            .addGroup(jPanel2Layout.createSequentialGroup()
                                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jLabel13)
                                    .addComponent(jLabel12)
                                    .addComponent(jLabel11))
                                .addGap(0, 0, Short.MAX_VALUE)))
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                            .addComponent(jLabel16, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jLabel17, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jLabel18, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jLabel19, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)))
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addComponent(jLabel112)
                        .addGap(34, 34, 34)))
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jTextFieldAttributes)
                    .addComponent(jTextFieldSongName)
                    .addComponent(jTextFieldAuthor)
                    .addComponent(jTextFieldComment)
                    .addComponent(jComboBoxInterleaved, 0, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel2Layout.createSequentialGroup()
                                .addComponent(jTextFieldFrequencyComputer, javax.swing.GroupLayout.PREFERRED_SIZE, 55, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(18, 18, 18)
                                .addComponent(jTextFieldFrequencyPlayer, javax.swing.GroupLayout.PREFERRED_SIZE, 55, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addComponent(jTextFieldYMVersion, javax.swing.GroupLayout.PREFERRED_SIZE, 61, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextFieldFutureData, javax.swing.GroupLayout.PREFERRED_SIZE, 55, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel141))
                        .addGap(0, 1, Short.MAX_VALUE)))
                .addGap(12, 12, 12)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel14, javax.swing.GroupLayout.DEFAULT_SIZE, 59, Short.MAX_VALUE)
                    .addComponent(jLabel15)
                    .addComponent(jLabel21))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jTextFieldLoop, javax.swing.GroupLayout.PREFERRED_SIZE, 55, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jCheckBoxPacked)
                    .addComponent(jTextFieldSamples, javax.swing.GroupLayout.PREFERRED_SIZE, 55, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel2Layout.setVerticalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jCheckBoxPacked, javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jLabel11)
                        .addComponent(jTextFieldYMVersion, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLabel21)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel12)
                    .addComponent(jTextFieldAttributes, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel13)
                    .addComponent(jTextFieldFrequencyComputer, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextFieldFrequencyPlayer, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel14)
                    .addComponent(jTextFieldLoop, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(5, 5, 5)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel22)
                    .addComponent(jTextFieldFutureData, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextFieldSamples, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel15))
                .addGap(5, 5, 5)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel16)
                    .addComponent(jTextFieldSongName, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel17)
                    .addComponent(jTextFieldAuthor, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel18)
                    .addComponent(jTextFieldComment, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel19)
                    .addComponent(jComboBoxInterleaved, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addGap(5, 5, 5)
                        .addComponent(jLabel112))
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jLabel141))))
        );

        jLabel138.setText("0");

        jLabel137.setText("bitStream length");

        jLabel136.setText("0");

        jLabel135.setText("data length:");

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
                .addGroup(jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel8Layout.createSequentialGroup()
                        .addComponent(jButtonLoad3)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButtonSave3))
                    .addComponent(jCheckBox21)
                    .addComponent(jCheckBox18))
                .addGap(0, 0, Short.MAX_VALUE))
        );
        jPanel8Layout.setVerticalGroup(
            jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel8Layout.createSequentialGroup()
                .addGroup(jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jButtonLoad3)
                    .addComponent(jButtonSave3))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox21)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox18)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );

        jLabel148.setText("     ");

        jLabel147.setText("     ");

        jLabel146.setText("     ");

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
                .addGroup(jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel7Layout.createSequentialGroup()
                        .addComponent(jButtonLoad2)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButtonSave2))
                    .addComponent(jCheckBox20)
                    .addComponent(jCheckBox17))
                .addGap(0, 0, Short.MAX_VALUE))
        );
        jPanel7Layout.setVerticalGroup(
            jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel7Layout.createSequentialGroup()
                .addGroup(jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jButtonLoad2)
                    .addComponent(jButtonSave2))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox20)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox17)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );

        jLabel144.setText("encoding");

        jCheckBoxCreatePlayer.setSelected(true);
        jCheckBoxCreatePlayer.setText("create player");

        jComboBox2.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "uncompressed", "YMSound (historic)", "YMSound optimized speed", "streamed" }));

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
                .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel6Layout.createSequentialGroup()
                        .addComponent(jButtonLoad1)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButtonSave1))
                    .addComponent(jCheckBox22)
                    .addComponent(jCheckBox19))
                .addGap(0, 0, Short.MAX_VALUE))
        );
        jPanel6Layout.setVerticalGroup(
            jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel6Layout.createSequentialGroup()
                .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jButtonLoad1)
                    .addComponent(jButtonSave1))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox22)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox19)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );

        jLabel143.setText("0");

        javax.swing.GroupLayout jPanel10Layout = new javax.swing.GroupLayout(jPanel10);
        jPanel10.setLayout(jPanel10Layout);
        jPanel10Layout.setHorizontalGroup(
            jPanel10Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
            .addGroup(jPanel10Layout.createSequentialGroup()
                .addGroup(jPanel10Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jComboBox2, 0, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jLabel144)
                    .addComponent(jCheckBoxCreatePlayer))
                .addGap(133, 133, 133)
                .addGroup(jPanel10Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel147, javax.swing.GroupLayout.PREFERRED_SIZE, 44, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel148, javax.swing.GroupLayout.PREFERRED_SIZE, 44, javax.swing.GroupLayout.PREFERRED_SIZE)))
            .addGroup(jPanel10Layout.createSequentialGroup()
                .addComponent(jLabel135)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jLabel136))
            .addGroup(jPanel10Layout.createSequentialGroup()
                .addGap(3, 3, 3)
                .addGroup(jPanel10Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(jPanel10Layout.createSequentialGroup()
                        .addComponent(jPanel7, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jPanel8, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jPanel6, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                    .addComponent(jLabel146, javax.swing.GroupLayout.PREFERRED_SIZE, 44, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel10Layout.createSequentialGroup()
                        .addGroup(jPanel10Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel137)
                            .addComponent(jLabel139)
                            .addComponent(jLabel142))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addGroup(jPanel10Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel143)
                            .addComponent(jLabel140)
                            .addComponent(jLabel138))))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel10Layout.setVerticalGroup(
            jPanel10Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel10Layout.createSequentialGroup()
                .addComponent(jPanel2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(5, 5, 5)
                .addGroup(jPanel10Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel135)
                    .addComponent(jLabel136)
                    .addComponent(jLabel137)
                    .addComponent(jLabel138))
                .addGap(7, 7, 7)
                .addGroup(jPanel10Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel139)
                    .addComponent(jLabel140))
                .addGap(8, 8, 8)
                .addGroup(jPanel10Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel142)
                    .addComponent(jLabel143))
                .addGap(5, 5, 5)
                .addGroup(jPanel10Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jPanel7, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jPanel8, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jPanel6, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(7, 7, 7)
                .addComponent(jLabel144)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel10Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jComboBox2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel146))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel10Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jCheckBoxCreatePlayer)
                    .addComponent(jLabel148))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabel147)
                .addGap(0, 0, Short.MAX_VALUE))
        );

        jTabbedPane1.addTab("Programmer", jPanel10);

        jTable3.setModel(new javax.swing.table.DefaultTableModel(
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
        jTable3.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jTable3MousePressed(evt);
            }
        });
        jScrollPane3.setViewportView(jTable3);

        javax.swing.GroupLayout jPanel9Layout = new javax.swing.GroupLayout(jPanel9);
        jPanel9.setLayout(jPanel9Layout);
        jPanel9Layout.setHorizontalGroup(
            jPanel9Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jScrollPane3, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, 417, Short.MAX_VALUE)
        );
        jPanel9Layout.setVerticalGroup(
            jPanel9Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jScrollPane3, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, 523, Short.MAX_VALUE)
        );

        jTabbedPane1.addTab("Lister", jPanel9);

        jLabel145.setText("Preprocess");

        jCheckBox23.setText("amplitude");
        jCheckBox23.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox23ActionPerformed(evt);
            }
        });

        jCheckBox24.setText("tone");
        jCheckBox24.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox24ActionPerformed(evt);
            }
        });

        jCheckBox25.setText("noise");
        jCheckBox25.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox25ActionPerformed(evt);
            }
        });

        jButton1.setText("<<");
        jButton1.setToolTipText("Shift amplitude of channel one bit (envelope bit is invariant)");
        jButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton1ActionPerformed(evt);
            }
        });

        jLabel149.setText("Amplitude");

        jLabel150.setText("channel A");

        jLabel151.setText("channel B");

        jLabel152.setText("channel C");

        jButton2.setText(">>");
        jButton2.setToolTipText("Shift amplitude of channel one bit (envelope bit is invariant)");
        jButton2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton2ActionPerformed(evt);
            }
        });

        jButton3.setText(">>");
        jButton3.setToolTipText("Shift amplitude of channel one bit (envelope bit is invariant)");
        jButton3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton3ActionPerformed(evt);
            }
        });

        jButton4.setText("<<");
        jButton4.setToolTipText("Shift amplitude of channel one bit (envelope bit is invariant)");
        jButton4.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton4ActionPerformed(evt);
            }
        });

        jButton5.setText(">>");
        jButton5.setToolTipText("Shift amplitude of channel one bit (envelope bit is invariant)");
        jButton5.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton5ActionPerformed(evt);
            }
        });

        jButton6.setText("<<");
        jButton6.setToolTipText("Shift amplitude of channel one bit (envelope bit is invariant)");
        jButton6.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton6ActionPerformed(evt);
            }
        });

        jTextField1.setText("1");

        jTextField2.setText("1");

        jTextField3.setText("1");

        jButton7.setText("mul");
        jButton7.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton7ActionPerformed(evt);
            }
        });

        jButton8.setText("mul");
        jButton8.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton8ActionPerformed(evt);
            }
        });

        jButton9.setText("mul");
        jButton9.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton9ActionPerformed(evt);
            }
        });

        jLabel153.setText("For streamed output only:");

        jCheckBoxForce1.setText("force channel 1");

        jCheckBoxForce2.setText("force channel 2");

        jCheckBoxForce3.setText("force channel 3");

        javax.swing.GroupLayout jPanel11Layout = new javax.swing.GroupLayout(jPanel11);
        jPanel11.setLayout(jPanel11Layout);
        jPanel11Layout.setHorizontalGroup(
            jPanel11Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel11Layout.createSequentialGroup()
                .addGroup(jPanel11Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel11Layout.createSequentialGroup()
                        .addContainerGap()
                        .addGroup(jPanel11Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jCheckBox23)
                            .addComponent(jCheckBox24)
                            .addComponent(jCheckBox25)
                            .addComponent(jLabel149)
                            .addGroup(jPanel11Layout.createSequentialGroup()
                                .addGroup(jPanel11Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jLabel150)
                                    .addComponent(jLabel151)
                                    .addComponent(jLabel152))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(jPanel11Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jButton1)
                                    .addComponent(jButton4)
                                    .addComponent(jButton6))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(jPanel11Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jButton3, javax.swing.GroupLayout.Alignment.TRAILING)
                                    .addComponent(jButton5, javax.swing.GroupLayout.Alignment.TRAILING)
                                    .addComponent(jButton2, javax.swing.GroupLayout.Alignment.TRAILING))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addGroup(jPanel11Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addGroup(jPanel11Layout.createSequentialGroup()
                                        .addComponent(jTextField1, javax.swing.GroupLayout.PREFERRED_SIZE, 42, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                        .addComponent(jButton7))
                                    .addGroup(jPanel11Layout.createSequentialGroup()
                                        .addComponent(jTextField2, javax.swing.GroupLayout.PREFERRED_SIZE, 42, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                        .addComponent(jButton8))
                                    .addGroup(jPanel11Layout.createSequentialGroup()
                                        .addComponent(jTextField3, javax.swing.GroupLayout.PREFERRED_SIZE, 42, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                        .addComponent(jButton9))))))
                    .addGroup(jPanel11Layout.createSequentialGroup()
                        .addGap(12, 12, 12)
                        .addComponent(jLabel145))
                    .addGroup(jPanel11Layout.createSequentialGroup()
                        .addContainerGap()
                        .addGroup(jPanel11Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel153)
                            .addComponent(jCheckBoxForce1)
                            .addComponent(jCheckBoxForce2)
                            .addComponent(jCheckBoxForce3))))
                .addContainerGap(141, Short.MAX_VALUE))
        );
        jPanel11Layout.setVerticalGroup(
            jPanel11Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel11Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jLabel145)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox23)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox24)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox25)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabel149)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel11Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel11Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jButton1, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jButton2, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jTextField1, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jButton7, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jLabel150))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel11Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel11Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jButton4, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jButton3, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jTextField2, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jButton8, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jLabel151))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel11Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel11Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jButton6, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jButton5, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jTextField3, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jButton9, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jLabel152))
                .addGap(52, 52, 52)
                .addComponent(jLabel153)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBoxForce1)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBoxForce2)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBoxForce3)
                .addContainerGap(204, Short.MAX_VALUE))
        );

        jTabbedPane1.addTab("more configuration", jPanel11);

        jButtonCancel.setText("cancel");
        jButtonCancel.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonCancelActionPerformed(evt);
            }
        });

        jButtonCreate.setText("create source");
        jButtonCreate.setName("create"); // NOI18N
        jButtonCreate.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonCreateActionPerformed(evt);
            }
        });

        jCheckBox26.setText("8 bit");

        javax.swing.GroupLayout jPanel12Layout = new javax.swing.GroupLayout(jPanel12);
        jPanel12.setLayout(jPanel12Layout);
        jPanel12Layout.setHorizontalGroup(
            jPanel12Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel12Layout.createSequentialGroup()
                .addGroup(jPanel12Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel12Layout.createSequentialGroup()
                        .addGroup(jPanel12Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel6)
                            .addComponent(jButtonPlaySample))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButtonStop2)
                        .addGap(30, 30, 30)
                        .addGroup(jPanel12Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel12Layout.createSequentialGroup()
                                .addComponent(jButtonStop3)
                                .addGap(53, 53, 53)
                                .addComponent(jButtonLoad)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jButtonSave)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jButtonNewYM)
                                .addGap(22, 22, 22)
                                .addComponent(jLabel20)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jComboBox1, javax.swing.GroupLayout.PREFERRED_SIZE, 69, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addComponent(jLabel10)))
                    .addGroup(jPanel12Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                        .addComponent(jTabbedPane1, javax.swing.GroupLayout.Alignment.LEADING)
                        .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel12Layout.createSequentialGroup()
                            .addComponent(jButtonCreate)
                            .addGap(166, 166, 166)
                            .addComponent(jCheckBox26)
                            .addGap(47, 47, 47)
                            .addComponent(jButtonCancel))))
                .addGap(0, 0, 0))
        );
        jPanel12Layout.setVerticalGroup(
            jPanel12Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel12Layout.createSequentialGroup()
                .addGroup(jPanel12Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel6)
                    .addComponent(jLabel10))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel12Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(jButtonPlaySample, javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jButtonStop2, javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jButtonStop3, javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jButtonLoad, javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jButtonSave, javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jButtonNewYM, javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jComboBox1, javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jLabel20, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTabbedPane1)
                .addGap(0, 0, 0)
                .addGroup(jPanel12Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButtonCreate)
                    .addComponent(jCheckBox26)
                    .addComponent(jButtonCancel)))
        );

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addComponent(jPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, Short.MAX_VALUE))
            .addGroup(layout.createSequentialGroup()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jScrollPane2, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(layout.createSequentialGroup()
                        .addContainerGap()
                        .addComponent(jButtonAddRow))
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(jButtonCopy)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButtonSaveSelection1))
                    .addComponent(jButtonPaste)
                    .addComponent(jButtonCut)
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(jButtonInsertYM)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButtonSaveSelection)))
                .addGap(0, 0, 0)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 583, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jPanel3, javax.swing.GroupLayout.PREFERRED_SIZE, 585, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                        .addComponent(jPanel5, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jPanel4, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel12, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
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
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jButtonCopy)
                                    .addComponent(jButtonSaveSelection1))
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
                                .addComponent(jPanel3, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(1, 1, 1)
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jScrollPane1)
                                    .addComponent(jScrollPane2, javax.swing.GroupLayout.DEFAULT_SIZE, 458, Short.MAX_VALUE)))
                            .addComponent(jButtonAddRow)))
                    .addComponent(jPanel12, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addGap(0, 0, 0)
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
        
        if (usedRegs[13]) YmSound.enableAmlitude5thBit = usedRegs[13];
    }
    
    private void jButtonCancelActionPerformed(ActionEvent evt) {//GEN-FIRST:event_jButtonCancelActionPerformed
       ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).removePanel(this);
        if (tinyLog instanceof VediPanel)
        {
            ((VediPanel)tinyLog).returnFromYMPanel(false);
        }
    }//GEN-LAST:event_jButtonCancelActionPerformed

    
    private void jButtonCreateActionPerformed(ActionEvent evt) {//GEN-FIRST:event_jButtonCreateActionPerformed
        if (standalone)
        {
            // ask where to save!
            InternalFrameFileChoser fc = new de.malban.gui.dialogs.InternalFrameFileChoser();
            fc.setDialogTitle("Select save directory");
            fc.setCurrentDirectory(new java.io.File("."+File.separator));
            fc.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);

            int r = fc.showOpenDialog(Configuration.getConfiguration().getMainFrame());
            if (r != InternalFrameFileChoser.APPROVE_OPTION) return;
            String lastPath = fc.getSelectedFile().getAbsolutePath();

            Path p = Paths.get(lastPath);
            String newName = p.toString();
            if (!newName.endsWith(File.separator)) newName+=File.separator;
            File f = new File(currentYMFile);
            String nameOnly = f.getName();
            newName = newName + nameOnly;
            currentYMFile = newName;
            
            startPath = fc.getSelectedFile().toString();
            if (!startPath.endsWith(File.separator)) startPath+=File.separator;
            
        }
        else
        {
            
        }

        preprocess();
        if (jComboBox2.getSelectedIndex() == 3)
        {
            
            doStreamCode();
        }
        else
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
            if (evt.isShiftDown())
            {
                completeColumnToValue(count, value);
            }
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
    String lastPath ="."+File.separator;
    private void jButtonLoadActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonLoadActionPerformed

        if (jTable1.isEditing()) jTable1.getCellEditor().stopCellEditing();        
        InternalFrameFileChoser fc = new de.malban.gui.dialogs.InternalFrameFileChoser();

        if (lastPath.length()==0)
        {
            if (pathOnly.length()==0)
            {
                pathOnly =  "."+File.separator;
            }
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
        jTable1.tableChanged(null);
        jTable2.tableChanged(null);
        jTable1.repaint();
        jTable2.repaint();
        initLister();
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
                            if (r == 14) toWrite = 0;
                            if (r == 15) toWrite = 0;
                            if (r == 13) 
                            {
                                if (i>0)
                                {
                                    if (toWrite != (byte) 0xff)
                                    {
                                        toWrite = (byte) (toWrite & 0x0f);
                                        if (toWrite == (byte) ((ymSound.out_buf[r][i-1]) & 0x0f))
                                            toWrite = (byte)0xff;
                                        
                                    }
                                }
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
        if (tinyLog instanceof VediPanel)
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
        playingYM = false;
        try
        {
             while (three != null) Thread.sleep(1);
        }
        catch (Throwable e)
        {
            
        }
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

    private void jCheckBox23ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox23ActionPerformed
        preprocAmp = jCheckBox23.isSelected();
    }//GEN-LAST:event_jCheckBox23ActionPerformed

    private void jCheckBox24ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox24ActionPerformed
        preprocTone = jCheckBox24.isSelected();
    }//GEN-LAST:event_jCheckBox24ActionPerformed

    private void jCheckBox25ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox25ActionPerformed
        preprocNoise = jCheckBox25.isSelected();
    }//GEN-LAST:event_jCheckBox25ActionPerformed

    private void jTable3MousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jTable3MousePressed
        tableClicked(evt);
    }//GEN-LAST:event_jTable3MousePressed

    private void jButtonSaveSelection1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSaveSelection1ActionPerformed

        
        if (jTable1.isEditing()) jTable1.getCellEditor().stopCellEditing();        
        InternalFrameFileChoser fc = new de.malban.gui.dialogs.InternalFrameFileChoser();

        if (lastPath.length()==0)
        {
            if (pathOnly.length()==0)
            {
                pathOnly =  "."+File.separator;
            }
            fc.setCurrentDirectory(new java.io.File(pathOnly));
        }
        else
        {
            fc.setCurrentDirectory(new java.io.File(lastPath));
        }

        int r = fc.showOpenDialog(Configuration.getConfiguration().getMainFrame());
        if (r != InternalFrameFileChoser.APPROVE_OPTION) return;
        lastPath = fc.getSelectedFile().getAbsolutePath();

        
        byte[][] buf = readStatements(lastPath);
        
        if (buf != null)
            insertYM(buf, buf[0].length);
    }//GEN-LAST:event_jButtonSaveSelection1ActionPerformed

    private void jButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton1ActionPerformed
        for (int row = 0; row <ymSound.vbl_len; row++)
        {
            // keep envelope
            int x = ymSound.out_buf[8][row] & 0x10;
            ymSound.out_buf[8][row] = (byte)((ymSound.out_buf[8][row]<<1) & 0x0f);
            ymSound.out_buf[8][row] +=x;
        }
        jTable1.repaint();
    }//GEN-LAST:event_jButton1ActionPerformed

    private void jButton4ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton4ActionPerformed
        for (int row = 0; row <ymSound.vbl_len; row++)
        {
            // keep envelope
            int x = ymSound.out_buf[9][row] & 0x10;
            ymSound.out_buf[9][row] = (byte)((ymSound.out_buf[9][row]<<1) & 0x0f);
            ymSound.out_buf[9][row] +=x;
        }
        jTable1.repaint();
    }//GEN-LAST:event_jButton4ActionPerformed

    private void jButton6ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton6ActionPerformed
 for (int row = 0; row <ymSound.vbl_len; row++)
        {
            // keep envelope
            int x = ymSound.out_buf[10][row] & 0x10;
            ymSound.out_buf[10][row] = (byte)((ymSound.out_buf[10][row]<<1) & 0x0f);
            ymSound.out_buf[10][row] +=x;
        }
        jTable1.repaint();
    }//GEN-LAST:event_jButton6ActionPerformed

    private void jButton2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton2ActionPerformed
        for (int row = 0; row <ymSound.vbl_len; row++)
        {
            // keep envelope
            int x = ymSound.out_buf[8][row] & 0x10;
            ymSound.out_buf[8][row] = (byte)(((ymSound.out_buf[8][row]&0x0f)>>1) & 0x0f);
            ymSound.out_buf[8][row] +=x;
        }
        jTable1.repaint();
    }//GEN-LAST:event_jButton2ActionPerformed

    private void jButton3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton3ActionPerformed
        for (int row = 0; row <ymSound.vbl_len; row++)
        {
            // keep envelope
            int x = ymSound.out_buf[9][row] & 0x10;
            ymSound.out_buf[9][row] = (byte)(((ymSound.out_buf[9][row]&0x0f)>>1) & 0x0f);
            ymSound.out_buf[9][row] +=x;
        }
        jTable1.repaint();
    }//GEN-LAST:event_jButton3ActionPerformed

    private void jButton5ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton5ActionPerformed
        for (int row = 0; row <ymSound.vbl_len; row++)
        {
            // keep envelope
            int x = ymSound.out_buf[10][row] & 0x10;
            ymSound.out_buf[10][row] = (byte)(((ymSound.out_buf[10][row]&0x0f)>>1) & 0x0f);
            ymSound.out_buf[10][row] +=x;
        }
        jTable1.repaint();
    }//GEN-LAST:event_jButton5ActionPerformed

    private void jButtonSwap12ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSwap12ActionPerformed
        swapVoice(0,1);
    }//GEN-LAST:event_jButtonSwap12ActionPerformed

    private void jButton11ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton11ActionPerformed
        swapVoice(1,2);
    }//GEN-LAST:event_jButton11ActionPerformed

    private void jButton13ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton13ActionPerformed
        swapVoice(2,0);
    }//GEN-LAST:event_jButton13ActionPerformed

    private void jButton7ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton7ActionPerformed
        double mul = de.malban.util.UtilityString.DoubleX(jTextField1.getText(), 1.0);
        multiplayVoiceAmplitude(0,mul);
                
        
    }//GEN-LAST:event_jButton7ActionPerformed

    private void jButton8ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton8ActionPerformed
        double mul = de.malban.util.UtilityString.DoubleX(jTextField2.getText(), 1.0);
        multiplayVoiceAmplitude(1,mul);

        
    }//GEN-LAST:event_jButton8ActionPerformed

    private void jButton9ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton9ActionPerformed
        double mul = de.malban.util.UtilityString.DoubleX(jTextField3.getText(), 1.0);
        multiplayVoiceAmplitude(2,mul);
    }//GEN-LAST:event_jButton9ActionPerformed

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.ButtonGroup buttonGroup1;
    private javax.swing.ButtonGroup buttonGroup2;
    private javax.swing.ButtonGroup buttonGroup3;
    private javax.swing.ButtonGroup buttonGroup4;
    private javax.swing.JButton jButton1;
    private javax.swing.JButton jButton11;
    private javax.swing.JButton jButton13;
    private javax.swing.JButton jButton2;
    private javax.swing.JButton jButton3;
    private javax.swing.JButton jButton4;
    private javax.swing.JButton jButton5;
    private javax.swing.JButton jButton6;
    private javax.swing.JButton jButton7;
    private javax.swing.JButton jButton8;
    private javax.swing.JButton jButton9;
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
    private javax.swing.JButton jButtonSaveSelection1;
    private javax.swing.JButton jButtonStop2;
    private javax.swing.JButton jButtonStop3;
    private javax.swing.JButton jButtonSwap12;
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
    private javax.swing.JCheckBox jCheckBox23;
    private javax.swing.JCheckBox jCheckBox24;
    private javax.swing.JCheckBox jCheckBox25;
    private javax.swing.JCheckBox jCheckBox26;
    private javax.swing.JCheckBox jCheckBox3;
    private javax.swing.JCheckBox jCheckBox4;
    private javax.swing.JCheckBox jCheckBox5;
    private javax.swing.JCheckBox jCheckBox6;
    private javax.swing.JCheckBox jCheckBox7;
    private javax.swing.JCheckBox jCheckBox8;
    private javax.swing.JCheckBox jCheckBox9;
    private javax.swing.JCheckBox jCheckBoxCreatePlayer;
    private javax.swing.JCheckBox jCheckBoxForce1;
    private javax.swing.JCheckBox jCheckBoxForce2;
    private javax.swing.JCheckBox jCheckBoxForce3;
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
    private javax.swing.JComboBox jComboBox2;
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
    private javax.swing.JLabel jLabel112;
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
    private javax.swing.JLabel jLabel135;
    private javax.swing.JLabel jLabel136;
    private javax.swing.JLabel jLabel137;
    private javax.swing.JLabel jLabel138;
    private javax.swing.JLabel jLabel139;
    private javax.swing.JLabel jLabel14;
    private javax.swing.JLabel jLabel140;
    private javax.swing.JLabel jLabel141;
    private javax.swing.JLabel jLabel142;
    private javax.swing.JLabel jLabel143;
    private javax.swing.JLabel jLabel144;
    private javax.swing.JLabel jLabel145;
    private javax.swing.JLabel jLabel146;
    private javax.swing.JLabel jLabel147;
    private javax.swing.JLabel jLabel148;
    private javax.swing.JLabel jLabel149;
    private javax.swing.JLabel jLabel15;
    private javax.swing.JLabel jLabel150;
    private javax.swing.JLabel jLabel151;
    private javax.swing.JLabel jLabel152;
    private javax.swing.JLabel jLabel153;
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
    private javax.swing.JPanel jPanel10;
    private javax.swing.JPanel jPanel11;
    private javax.swing.JPanel jPanel12;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JPanel jPanel3;
    private javax.swing.JPanel jPanel4;
    private javax.swing.JPanel jPanel5;
    private javax.swing.JPanel jPanel6;
    private javax.swing.JPanel jPanel7;
    private javax.swing.JPanel jPanel8;
    private javax.swing.JPanel jPanel9;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JScrollPane jScrollPane2;
    private javax.swing.JScrollPane jScrollPane3;
    private javax.swing.JSlider jSliderAmplidtudeA;
    private javax.swing.JSlider jSliderAmplidtudeB;
    private javax.swing.JSlider jSliderAmplidtudeC;
    private javax.swing.JSlider jSliderNoise;
    private javax.swing.JTabbedPane jTabbedPane1;
    private javax.swing.JTable jTable1;
    private javax.swing.JTable jTable2;
    private javax.swing.JTable jTable3;
    private javax.swing.JTextField jTextField1;
    private javax.swing.JTextField jTextField10a;
    private javax.swing.JTextField jTextField11a;
    private javax.swing.JTextField jTextField12a;
    private javax.swing.JTextField jTextField13a;
    private javax.swing.JTextField jTextField14a;
    private javax.swing.JTextField jTextField15a;
    private javax.swing.JTextField jTextField16a;
    private javax.swing.JTextField jTextField1a;
    private javax.swing.JTextField jTextField2;
    private javax.swing.JTextField jTextField2a;
    private javax.swing.JTextField jTextField3;
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
    boolean standalone = false;
    public static void showYMPanelNoModal(String fileName, TinyLogInterface tl)
    {
        showYMPanelNoModal(fileName, tl,false);
    }
    public static void showYMPanelNoModal(String fileName, TinyLogInterface tl, boolean sa)
    {
        
        JFrame frame = Configuration.getConfiguration().getMainFrame();
        YMJPanel panel = new YMJPanel(fileName, tl);
        panel.standalone = sa;
       ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).addPanel(panel);
       ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).windowMe(panel, 1180, 700, panel.getMenuItem().getText());
       
       if (tl instanceof VediPanel32)
       {
           panel.initBASIC();
       }
    }        
    void createSource()
    {
        doYM_part1();        
    }

    void doYM_part1()
    {
        boolean uncompressed = false;
        int selectedMode = jComboBox2.getSelectedIndex();
        if (selectedMode == 0) // uncompressd
            uncompressed = true;
        
        if (isBASIC)
        {
            Path p = Paths.get(startPath);
            String newName = p.toString();
            if (!newName.endsWith(File.separator)) newName+=File.separator;
            File f = new File(currentYMFile);
            String nameOnly = f.getName();
            newName = newName + nameOnly;
            currentYMFile = newName;
        }
        
        if (two != null) return;
        ymSaveName = "";
        // check for a property file!
        String type ="";
        String pathFull ="";
        String pathOnly ="";
        String filenameOnly ="";
        String filenameBaseOnly ="";
        Path p = Paths.get(currentYMFile);
        if(p== null) return;
        pathFull = p.toString();
        pathOnly = p.getParent().toString();
        if ((pathOnly.length()>0) && (!pathOnly.endsWith(File.separator)))
            pathOnly+= File.separator;
        
        filenameOnly = p.getFileName().toString();
        filenameBaseOnly = filenameOnly.substring(0,filenameOnly.length()-3);
        
        boolean pic = false;
        if (filenameOnly.toLowerCase().endsWith(".ym")) pic = true;
        if (!pic) 
        {
            tinyLog.printWarning("Selected entry does not have a known ym extension - using 'name' to create a file...");
            filenameBaseOnly = jTextFieldSongName.getText();
           // return;
        }
        String saveNameOnly ="";
        if (isBASIC)
        {
            try
            {
                StringBuilder out = new StringBuilder();
                int start = 0;
                int end = ymSound.vbl_len;

                boolean started = false;
                

                out.append("\n");
                out.append("function initYMData()\n" +"return   { _\n");
                for (int i=start; i<end; i++)
                {
                    String o = "";
                    if (started)
                    {
                        out.append("}, _\n");
                    }
                    started = true;
                    boolean firstInLine = false;
                    for (int r=0; r< 14; r++)
                    {
                        byte value = ymSound.out_buf[r][i];

                        if (firstInLine) o+=", ";
                        o+="$"+String.format("%02X",value);
                        firstInLine = true;
                    }                            
                    out.append("        { ").append(o);
                }
                out.append("} _\n}\nendfunction\n");
                
                String exampleMain ="";
                if (jCheckBoxCreatePlayer.isSelected())
                {

                    Path template = Paths.get(".", "template", "playYMRaw.bas");
                    exampleMain = de.malban.util.UtilityString.readTextFileToOneString(new File(template.toString()));
                }
                String complete = exampleMain+out.toString();

                
                complete = de.malban.util.UtilityString.replace(complete, "\n", "\r\n");
                de.malban.util.UtilityFiles.createTextFile(pathOnly+filenameBaseOnly+".bas", complete);
                tinyLog.printMessage("Creating file: "+pathOnly+filenameBaseOnly+".bas");
                
/*                
                File file = new File(pathOnly+filenameBaseOnly+".bas");
                saveNameOnly = filenameBaseOnly+".bas";
                FileWriter fw;
                BufferedWriter bw;
                fw = new FileWriter(file.getAbsoluteFile());
                bw = new BufferedWriter(fw);        
s
                bw.close();
*/        
            }
            catch (Throwable e)
            {
                log.addLog(e, WARN);
                log.addLog("YM - Error openening output file! ('"+pathOnly+filenameBaseOnly+".bas"+"').", WARN);
                tinyLog.printError("Error creating file: "+pathOnly+filenameBaseOnly+".bas");
            }
            if (tinyLog instanceof VediPanel)
                ((VediPanel)tinyLog).refreshTree();
            return;
        }
        if (uncompressed)
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
//                        if ((r == 13) && (value&0xff) == 0xff) 
//                            continue;


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
            if (tinyLog instanceof VediPanel)
                ((VediPanel)tinyLog).refreshTree();
            if (standalone)
            {
                VediPanel.openInVedi(pathOnly+filenameOnly.substring(0,filenameOnly.length()-3)+"Main.asm");
            }
        }
        else
        {
            // do compress
            start(pathFull);
        }
    }
    
    void doYM_part2()
    {
        boolean ymhistoric = false;
        boolean ymoptimized = false;
        int selectedMode = jComboBox2.getSelectedIndex();
        if (selectedMode == 1) // 
        {
            ymhistoric = true;
            YmSound.dontShanonSingleByteUsages = false;        
        }
        if (selectedMode == 2) // 
        {
            ymoptimized = true;
            YmSound.dontShanonSingleByteUsages = true;        
        }

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
            if (ymhistoric)
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
            if (ymoptimized)
            {
                Path include = Paths.get(".", "template", "VECTREX.I");
                de.malban.util.UtilityFiles.copyOneFile(include.toString(), pathOnly+ "VECTREX.I");
                Path digital = Paths.get(".", "template", "ymPlayerNoByteShannon.template");
                de.malban.util.UtilityFiles.copyOneFile(digital.toString(), pathOnly+ "ymPlayer.i");

                Path template = Paths.get(".", "template", "ymPlayMain.template");
                String exampleMain = de.malban.util.UtilityString.readTextFileToOneString(new File(template.toString()));

                exampleMain = de.malban.util.UtilityString.replace(exampleMain,"#YM_DATA#", saveNameOnly);
                
                if (YmSound.enableAmlitude5thBit)
                {
                    String rep = "\nUSE_ENVELOPES = 1\n"+ "                    include  \"ymPlayer.i\"";
                    exampleMain = de.malban.util.UtilityString.replace(exampleMain,"include  \"ymPlayer.i\"", rep);
                }
                de.malban.util.UtilityFiles.createTextFile(pathOnly+filenameOnly.substring(0,filenameOnly.length()-3)+"Main.asm", exampleMain);     
            }
        }
        

//       ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).removePanel(this);
        if (tinyLog instanceof VediPanel)
        {
            ((VediPanel)tinyLog).returnFromYMPanel(true);
        }
        if (standalone)
        {
            if (jCheckBoxCreatePlayer.isSelected())
                VediPanel.openInVedi(pathOnly+filenameOnly.substring(0,filenameOnly.length()-3)+"Main.asm");
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
                int selectedMode = jComboBox2.getSelectedIndex();
                if (selectedMode == 1) // 
                {
                    YmSound.dontShanonSingleByteUsages = false;        
                }
                if (selectedMode == 2) // 
                {
                    YmSound.dontShanonSingleByteUsages = true;        
                }
                String saveName = currentYMFile;
                //if (!standalone)
                {
                }
                ymSaveName = ymSound.buildASM(usedRegs);
                if (ymSaveName != null) 
                {
                    if (startPath.length() != 0)
                    {
                        if ((startPath.length()>0) && (!startPath.endsWith(File.separator)))
                            startPath+= File.separator;
                        String name = new File (ymSaveName).getName();
                        
                        
                        de.malban.util.UtilityFiles.move(ymSaveName, startPath+name);
                        ymSaveName =startPath+name;
                    }
                    

                    
                    
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
        if (ymSound == null) return;
        if (ymSound.vbl_len==0) return;
        if (playingYM) return;
        // paranoia!
        if (three != null) return;
        
        e8910.is16Bit = !jCheckBox26.isSelected();
        
//        final Stream line = E8910.getVectrexLine();

        e8910.e8910_init_sound();
        // setupPSG once with a complete reigster set!
        // if not every register is setup once,
        // the emulation may decide to do an endless loop!

        if (loopStart>-1) ympos = (int)loopStart;

        for (int r=0; r< 15; r++)
        {
            if (!usedRegs[r]) continue;
            byte value = ymSound.out_buf[r][ympos];
            byte poker = value;
            int i=r;
            if ((i==1)||(i==3)||(i==5)) poker   &= 0x0f;
            if ((i==6) ) poker                  &= 0x1f;
            if  (i==7) poker                    &= 0x3f;
            
            if (ymSound.enableAmlitude5thBit)
                if ((i==8)||(i==9)||(i==10)) poker  &= 0x1f;
            else
                if ((i==8)||(i==9)||(i==10)) poker  &= 0x0f;
            if (i == 13) if (poker == 0xff) 
                continue;
            
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
                if (ymSound.vbl_len == 0) return;
                
//                byte[] soundBytes = new byte[E8910.getSoundBufferSize()];
                
//                line.start();
                currentHz = jComboBox1.getSelectedIndex()==0?50:60;
                compareMilli = 1000/currentHz;

                
                long lastTime = 0;
                while (playingYM)
                {
                    if (ymSound.vbl_len == 0) break;
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
                            if (YmSound.enableAmlitude5thBit)
                                if ((i==8)||(i==9)||(i==10)) poker  &= 0x1f;
                            else
                                if ((i==8)||(i==9)||(i==10)) poker  &= 0x0f;
                            
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

                        e8910.updateSound();
                        /*
                        int soundLength = line.available();
                        int bufLength = soundBytes.length;
                        if (E8910.is16Bit) bufLength/=2;
                        soundLength = soundLength >bufLength ? bufLength : soundLength;
                        if (soundLength>=0)
                        {
//                            soundLength = 2048-96-96-96;
                            e8910.e8910_callback(soundBytes, soundLength);
                            line.write(soundBytes, 0, soundLength);
                        }
                    */
                    }
                    

                    try
                    {
                        Thread.sleep(1);
                    }
                    catch (Throwable e)
                    {
                    }
                    
                    
                    
                }
                playingYM = false;
                e8910.e8910_done_sound();
//                line.stop();
                three = null;
//                line.unload();
            }  
        };
        playingYM = true;
        three.start();           
    }    
    int inEvent=0;
    byte[] workBuf = new byte[16];
    void workBufToSelection()
    {
        if (ymSound == null) return;
        if (ymSound.out_buf == null) return;
        for (int r=0; r< 15; r++)
        {
            if (!usedRegs[r]) continue;
            byte value = ymSound.out_buf[r][ympos];
            byte poker = value;
            int i=r;
            if ((i==1)||(i==3)||(i==5)) poker   &= 0x0f;
            if ((i==6) ) poker                  &= 0x1f;
            if  (i==7) poker                    &= 0x3f;
            if (ymSound.enableAmlitude5thBit)
                if ((i==8)||(i==9)||(i==10)) poker  &= 0x1f;
            else
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
        if (tinyLog instanceof VediPanel)
            ((VediPanel)tinyLog).refreshTree();   
        return true;    
    }
    boolean loadAYFX(String channel, boolean overwrite)
    {
        if (jTable1.isEditing()) jTable1.getCellEditor().stopCellEditing();        
        InternalFrameFileChoser fc = new de.malban.gui.dialogs.InternalFrameFileChoser();

        if (lastPath.length()==0)
        {
            if (pathOnly.length() == 0)
            {
                lastPath = "."+File.separator;
                fc.setCurrentDirectory(new java.io.File(lastPath));
            }
            else
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

        
        
        File file = new File(lastPath);
        
        if (file.isDirectory())
        {
            pathOnly = lastPath;
        }
        else if (lastPath.length()!=0)
            pathOnly = file.getParent();
        
        
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
        initLister();

        return initAFX(channel, data, overwrite, path.toString());
    }

    boolean initAFX(String channel, byte[] data, boolean overwrite, String path)
    {  
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
    boolean isBASIC = false;
    void initBASIC()
    {
        isBASIC = true;
    }
    void doStreamCode()
    {
        HashMap<String, String> test = new HashMap<String, String>();
        updateCheckBoxes();
        int size=0;
        int start = 0;
        int end = ymSound.vbl_len;
        for (int i=start; i<end; i++)
        {
            String o = "";
            for (int r=0; r< 14; r++)
            {
                byte value = ymSound.out_buf[r][i];
                if  (usedRegs[r])
                {
                    size++;
                    o+="$"+String.format("%02X",value);
                }
            }                            
            test.put(o, o);
        }
        jLabel141.setText(""+test.size());
        jLabel136.setText(""+size);
        Dictionary dictionary = buildYMBitStream();
        
//        dictionary.decodeBitStream();
        
        String bitOutput = dictionary.bitStream.toString();
        jLabel138.setText(""+(bitOutput.length()+7)/8);
        jLabel140.setText(""+dictionary.datalines.size());
        jLabel143.setText(""+dictionary.getRawByteDataSize());
        
        // do the output now
        
        ymSaveName = "";
        // check for a property file!
        String type ="";
        String pathFull ="";
        String pathOnly ="";
        String filenameOnly ="";
        String filenameBaseOnly ="";
        Path p = Paths.get(currentYMFile);
        if(p== null) return;
        pathFull = p.toString();
        pathOnly = p.getParent().toString();
        if ((pathOnly.length()>0) && (!pathOnly.endsWith(File.separator)))
            pathOnly+= File.separator;
        
        filenameOnly = p.getFileName().toString();
        filenameBaseOnly = filenameOnly.substring(0,filenameOnly.length()-3);
        
        boolean pic = false;
        if (filenameOnly.toLowerCase().endsWith(".ym")) pic = true;
        if (!pic) 
        {
            tinyLog.printWarning("Selected entry does not have a known ym extension - using 'name' to create a file...");
            filenameBaseOnly = jTextFieldSongName.getText();
           // return;
        }
        String saveNameOnly ="";
        File file = new File(pathOnly+filenameBaseOnly+".asm");
        saveNameOnly = filenameBaseOnly+".asm";
        FileWriter fw;
        BufferedWriter bw;
        try
        {
            fw = new FileWriter(file.getAbsoluteFile());
            bw = new BufferedWriter(fw);        
            start = 0;
            end = ymSound.vbl_len;
            boolean started = false;


            
            if (dictionary.sConfig.hasSomeNoise)
                bw.write("HAS_SOME_NOISE = 1\n");
            if (dictionary.sConfig.hasVoice[0])
                bw.write("HAS_VOICE0 = 1\n");
            if (dictionary.sConfig.hasVoice[1])
                bw.write("HAS_VOICE1 = 1\n");
            if (dictionary.sConfig.hasVoice[2])
                bw.write("HAS_VOICE2 = 1\n");
            
            if (dictionary.sConfig.hasNoise[0])
                bw.write("HAS_NOISE0 = 1\n");
            if (dictionary.sConfig.hasNoise[1])
                bw.write("HAS_NOISE1 = 1\n");
            if (dictionary.sConfig.hasNoise[2])
                bw.write("HAS_NOISE2 = 1\n");
            
            if (!dictionary.sConfig.allToneSame[0])
                bw.write("HAS_DIF_TONE0 = 1\n");
            if (!dictionary.sConfig.allToneSame[1])
                bw.write("HAS_DIF_TONE1 = 1\n");
            if (!dictionary.sConfig.allToneSame[2])
                bw.write("HAS_DIF_TONE2 = 1\n");
            
            if (dictionary.sConfig.hasTone[0])
                bw.write("HAS_TONE0 = 1\n");
            if (dictionary.sConfig.hasTone[1])
                bw.write("HAS_TONE1 = 1\n");
            if (dictionary.sConfig.hasTone[2])
                bw.write("HAS_TONE2 = 1\n");
            
             if (dictionary.sConfig.hasEnvelope)
                bw.write("HAS_ENVELOPE = 1\n");
           
            
            
            bw.write("FIRST7 = $"+String.format("%02X",(dictionary.sConfig.first7))+"\n");
            
            bw.write("\n");
            bw.write("SONG_DATA = ymlen\n");
            bw.write("\n");
            bw.write("ymlen:\n dw ");
            bw.write("$"+String.format("%04X",(end-start)));

            bw.write("\nymData:\n");

            
            dictionary.bitStreamStart();
            
            int dataCount = 0;
            while (!dictionary.eof)
            {
                if (dataCount == 0)
                    bw.write(" db ");
                else
                    bw.write(", ");
                int b = dictionary.getNextByte();
                bw.write("$"+String.format("%02X",(b&0xff)));
                dataCount++;
                if (dataCount == 10)
                {
                    bw.write("\n");
                    dataCount = 0;
                }
            }
            
            bw.close();

            if (jCheckBoxCreatePlayer.isSelected())
            {
                Path include = Paths.get(".", "template", "VECTREX.I");
                de.malban.util.UtilityFiles.copyOneFile(include.toString(), pathOnly+ "VECTREX.I");
                Path digital = Paths.get(".", "template", "ymStreamedPlayer.i");
                de.malban.util.UtilityFiles.copyOneFile(digital.toString(), pathOnly+ "ymStreamedPlayer.i");

                Path template = Paths.get(".", "template", "ymPlayStreamedMain.template");
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
        if (tinyLog instanceof VediPanel)
            ((VediPanel)tinyLog).refreshTree();
        if (standalone)
        {
            VediPanel.openInVedi(pathOnly+filenameOnly.substring(0,filenameOnly.length()-3)+"Main.asm");
        }
    }
    class Dictionary
    {
        ArrayList<OneDataLine> datalines = new ArrayList<OneDataLine>();
        StringBuilder bitStream = new StringBuilder();
        StreamConfig sConfig = new StreamConfig();
        
        StringBitStream stream = new StringBitStream();
        int pos;
        boolean eof = false;
        void bitStreamStart()
        {
            pos = 0;
            eof = false;
            stream.s = bitStream.toString();
            stream.reset();
        }
        
        int getNextByte()
        {
            int b=0;
            for (int i=0;i<8; i++)
            {
                b = b <<1;
                if (!stream.eof)
                {
                    if (stream.nextBit())
                        b++;
                }
                else
                {
                    eof = true;
                }
            }
            return b;
        }
        
        int getRawByteDataSize()
        {
            int size = 0;
            for (OneDataLine dline: datalines)
            {
                size+=dline.bytes.size();
            }
            return size;
        }
        boolean outputRegs(int[] regs, int line, String comment)
        {
            System.out.print(" "+String.format("%04d", line)+":");
            boolean error = false;
            for (int i=0; i<11;i++)
            {
                System.out.print(" $"+String.format("%02X", (regs[i]&0xff)));
                if ((ymSound.out_buf[i][line]&0xff) != (regs[i]&0xff))
                {
                    System.out.println("\n ERROR ");
                    error = true;
                }
                    
            }
            System.out.println(" ; "+comment);
            return error;
        }
        
        // not up to date anymore, doesn't handle the "ifs"
        void decodeBitStream()
        {
            int[] regsLast=new int[16];
            int[] regs=new int[16];
            StringBitStream stream = new StringBitStream();
            stream.doComments = true;
            stream.s = bitStream.toString();
            int line = 0;
            boolean error = false;
            while (!stream.eof)
            {
                // if bit == 0, than completely same than last reg
                // do nothing...
                if (stream.nextBit())
                {
                    // do no voice 0, if next bit is 0
                    if (stream.nextBit())
                    {
                        // do voice 0
                        if (stream.nextBit())
                        {
                            // do amplitude
                            regs[8] = stream.read(4); // read 4 bit value
                        }
                        boolean noise = stream.nextBit();
                        if (noise)
                        {
                            regs[7] = setBit(regs[7], 3, false); // noise is zero active bit 3
                        }
                        else
                        {
                            regs[7] = setBit(regs[7], 3, true); // noise is zero active bit 3
                        }
                        boolean tone = stream.nextBit();
                        if (tone)
                        {
                            regs[7] = setBit(regs[7], 0, false); // tone is zero active bit 0
                        }
                        else
                        {
                            regs[7] = setBit(regs[7], 0, true); // tone is zero active bit 0
                        }
                        if (stream.nextBit())
                        {
                            // read low frequency
                            regs[0] = stream.read(8); // read 8 bit value
                        }
                        if (stream.nextBit())
                        {
                            // read hi frequency
                            regs[1] = stream.read(4); // read 4 bit value
                        }
                    }
                    // do no voice 1, if next bit is 0
                    if (stream.nextBit())
                    {
                        // do voice 1
                        if (stream.nextBit())
                        {
                            // do amplitude
                            regs[9] = stream.read(4); // read 4 bit value
                        }
                        boolean noise = stream.nextBit();
                        if (noise)
                        {
                            regs[7] = setBit(regs[7], 4, false); // noise is zero active bit 4
                        }
                        else
                        {
                            regs[7] = setBit(regs[7], 4, true); // noise is zero active bit 4
                        }
                        boolean tone = stream.nextBit();
                        if (tone)
                        {
                            regs[7] = setBit(regs[7], 1, false); // tone is zero active bit 1
                        }
                        else
                        {
                            regs[7] = setBit(regs[7], 1, true); // tone is zero active bit 1
                        }
                        if (stream.nextBit())
                        {
                            // read low frequency
                            regs[2] = stream.read(8); // read 8 bit value
                        }
                        if (stream.nextBit())
                        {
                            // read hi frequency
                            regs[3] = stream.read(4); // read 4 bit value
                        }
                    }
                    // do no voice 2, if next bit is 0
                    if (stream.nextBit())
                    {
                        // do voice 2
                        if (stream.nextBit())
                        {
                            // do amplitude
                            regs[10] = stream.read(4); // read 4 bit value
                        }
                        boolean noise = stream.nextBit();
                        if (noise)
                        {
                            regs[7] = setBit(regs[7], 5, false); // noise is zero active bit 5
                        }
                        else
                        {
                            regs[7] = setBit(regs[7], 5, true); // noise is zero active bit 5
                        }
                        boolean tone = stream.nextBit();
                        if (tone)
                        {
                            regs[7] = setBit(regs[7], 2, false); // tone is zero active bit 2
                        }
                        else
                        {
                            regs[7] = setBit(regs[7], 2, true); // tone is zero active bit 2
                        }
                        if (stream.nextBit())
                        {
                            // read low frequency
                            regs[4] = stream.read(8); // read 8 bit value
                        }
                        if (stream.nextBit())
                        {
                            // read hi frequency
                            regs[5] = stream.read(4); // read 4 bit value
                        }
                    }                    
                    if (stream.nextBit())
                    {
                        // do noise
                        regs[6] = stream.read(5); // read 5 bit value
                    }
                }
                error = error || outputRegs(regs, line++, stream.comment);
                stream.comment = "";
                for (int i=0;i<regs.length; i++)
                    regsLast[i] = regs[i];
            }
            if (error)
                System.out.println("Error verifying!");
            else
                System.out.println("Verifying ok!");
        }
    }

    class StringBitStream
    {
        public String comment ="";
        public String s;
        int pos=0;
        public boolean eof = false;
        boolean doComments = false;
        boolean nextBit()
        {
            pos++;
            if (pos >= s.length())
            {
                eof = true;
                return false;
            }
            if (doComments)
            comment+=s.substring(pos-1, pos);
            return s.substring(pos-1, pos).equals("1");
        }
        int read(int bits) // read x bit as int
        {
            int v = 0;
            for (int i=0; i<bits; i++)
            {
                v=v<<1;
                if (nextBit()) v+=1;
            }
            return v;
        }
        void reset()
        {
            pos = 0;
            eof = false;
            comment = "";
        }
    }
    
    class OneDataLine
    {
        String bitStream;
        int usage;
        ArrayList<Byte> bytes = new ArrayList<Byte>();
        OneDataLine(String b, int u)
        {
            bitStream = b;
            usage = u;
            
            String bit8 = bitStream;
            do 
            {
                String currentByte;
                if (bit8.length()<=8) 
                {
                    currentByte = bit8;
                    bit8 = "";
                }
                else
                {
                    currentByte = bit8.substring(0, 8);
                    bit8 = bit8.substring(8);
                }
                int bi = Integer.parseInt(currentByte, 2);
                bytes.add((byte) (bi &0xff));

            } while (bit8.length()>0);
        }
        public String toString()
        {
            String ret = bitStream+"->";
            for (Byte b: bytes)
            {
                ret += "$"+String.format("%02X", (b&0xff))+" ";
            }
            return ret+"; usage: "+usage;
        }
    }

    StringBuilder appendbitsLSBFirst(StringBuilder out, int value, int bitCount)
    {
        int compare = 1;
        for (int i=0; i<bitCount; i++)
        {
            if ((value & compare) == compare) 
                out.append("1");
            else
                out.append("0");
            compare *= 2;
        }
        return out;
    }
    StringBuilder appendbitsMSBFirst(StringBuilder out, int value, int bitCount)
    {
        int compare = 1;
        compare = compare << (bitCount-1);
        for (int i=0; i<bitCount; i++)
        {
            if ((value & compare) == compare) 
                out.append("1");
            else
                out.append("0");
            compare = compare >> 1;
        }
        return out;
    }
    
    // zero based
    boolean readBit(int reg, int bit)
    {
       int compare = 1;
       compare = compare << bit;
       return (reg & compare) == compare;
    }
    int setBit(int reg, int bit, boolean state)
    {
       int compare = 1;
       compare = compare << bit;
       if (state) // set bit
       {
           reg = reg | compare;
       }
       else
       {
           reg = reg & (255 - compare);
       }
       return reg;
    }   
    boolean isTone(int voice, int row)
    {
        if (row <0) return false;
        boolean tone = false;
        
        // tone is zero active
        if (voice == 0) tone = !readBit(ymSound.out_buf[7][row],0);
        if (voice == 1) tone = !readBit(ymSound.out_buf[7][row],1);
        if (voice == 2) tone = !readBit(ymSound.out_buf[7][row],2);
            
        return tone;
    }
    boolean isNoise(int voice, int row)
    {
        if (row <0) return false;
        boolean noise = false;
        // noise is zero active
        if (voice == 0) noise = !readBit(ymSound.out_buf[7][row],3);
        if (voice == 1) noise = !readBit(ymSound.out_buf[7][row],4);
        if (voice == 2) noise = !readBit(ymSound.out_buf[7][row],5);

        return noise;
    }
    boolean anyNoise(int row)
    {
        if (row <0) return false;
        boolean anyNoise = false;
        if ((getAmplitude(0, row) >0) && isNoise(0,row)) anyNoise = true;
        if ((getAmplitude(1, row) >0) && isNoise(1,row)) anyNoise = true;
        if ((getAmplitude(2, row) >0) && isNoise(2,row)) anyNoise = true;
        
        return anyNoise;
    }
    int getAmplitude(int voice, int row)
    {
        if (row <0) return 0;
        int amplitude = 0;
        if (voice == 0) amplitude = ymSound.out_buf[8][row] &0x1f;
        if (voice == 1) amplitude = ymSound.out_buf[9][row] &0x1f;
        if (voice == 2) amplitude = ymSound.out_buf[10][row] &0x1f;
        return amplitude;
    }
    int getOldAmplitude(int voice)
    {
        int amplitude = 0;
        if (voice == 0) amplitude = oldRegs[8] &0x1f;
        if (voice == 1) amplitude = oldRegs[9] &0x1f;
        if (voice == 2) amplitude = oldRegs[10] &0x1f;
        return amplitude;
    }
    int getFrequency(int voice, int row)
    {
        if (row <0 ) return -1;
        int frequency = 0;
        if (voice == 0) frequency = ymSound.out_buf[0][row] &0xff;
        if (voice == 1) frequency = ymSound.out_buf[2][row] &0xff;
        if (voice == 2) frequency = ymSound.out_buf[4][row] &0xff;
        if (voice == 0) frequency += (ymSound.out_buf[1][row] &0x0f)<<8;
        if (voice == 1) frequency += (ymSound.out_buf[3][row] &0x0f)<<8;
        if (voice == 2) frequency += (ymSound.out_buf[5][row] &0x0f)<<8;
        return frequency;
    }
    int getOldFrequency(int voice)
    {
        int frequency = 0;
        if (voice == 0) frequency = oldRegs[0] &0xff;
        if (voice == 1) frequency = oldRegs[2] &0xff;
        if (voice == 2) frequency = oldRegs[4] &0xff;
        if (voice == 0) frequency += (oldRegs[1] &0x0f)<<8;
        if (voice == 1) frequency += (oldRegs[3] &0x0f)<<8;
        if (voice == 2) frequency += (oldRegs[5] &0x0f)<<8;
        return frequency;
    }
    int getNoisePeriod(int row)
    {
        newRegs[6]=ymSound.out_buf[6][row] &0x1f;
        return ymSound.out_buf[6][row] &0x1f;
    }
    int getOldNoisePeriod(int row)
    {
        return oldRegs[6] &0x1f;
    }
    // build a COMPLETE voice bitstram
    String buildVoice(int voice, int row, StreamConfig sConfig)
    {
        HashMap<String, Integer> dictionary = new HashMap<String, Integer>();
        StringBuilder voiceStream = new StringBuilder();
        int amplitude = getAmplitude(voice, row);
        boolean tone = isTone(voice, row);
        boolean noise = isNoise(voice, row);
        int frequency = getFrequency(voice, row);
        int fLow = frequency&0xff;
        int fhi = (frequency>>8) & 0x0f;
        boolean oldtone = isTone(voice, row-1);
        boolean oldnoise = isNoise(voice, row-1);

        int oldamplitude =getOldAmplitude(voice);
        int oldfrequency = getOldFrequency(voice);
        int oldfLow = oldfrequency&0xff;
        int oldfhi = (oldfrequency>>8) & 0x0f;
        

        // check tone / noise
        // it is (falsly) assumed, that when neiter tone, not noise is enabled, that the voice
        // is supposedly switched off
        // that is (as written) in the PSG manual not correct, only amplitude can switch a channel off
        // nonetheless - we take it for YM files as given
        // first amplitude
        if (amplitude==oldamplitude)
        {
            appendbitsMSBFirst(voiceStream, 0, 1).toString();
        }
        else
        {
            appendbitsMSBFirst(voiceStream, 1, 1).toString();
            if (sConfig.hasEnvelope)
                appendbitsMSBFirst(voiceStream, amplitude, 5);
            else
                appendbitsMSBFirst(voiceStream, amplitude, 4);
        }

        // for ym we take it that noise has precedence over tone - we only use 1 bit to represent the state!
        if (sConfig.hasSomeNoise)
        {
            if (sConfig.hasNoise[voice])
            {
                if (noise) 
                    voiceStream.append("1");
                else
                    voiceStream.append("0");
            }
        }
        if (!sConfig.allToneSame[voice])
        {
            if (sConfig.hasTone[voice])
            {
                if (tone) 
                    voiceStream.append("1");
                else
                    voiceStream.append("0");
            }
        }
        
        // only if voice has a tone, tone is output
//        if (tone)
        {
            if (fLow==oldfLow)
            {
                appendbitsMSBFirst(voiceStream,0,1);
            }
            else
            {
                appendbitsMSBFirst(voiceStream,1,1);
                appendbitsMSBFirst(voiceStream, fLow, 8);
            }
            if (fhi==oldfhi)
            {
                appendbitsMSBFirst(voiceStream,0,1);
            }
            else
            {
                appendbitsMSBFirst(voiceStream,1,1);
                appendbitsMSBFirst(voiceStream, fhi, 4);
            }
            
        }
        return voiceStream.toString();
    }
    // non usage 

    int[] oldRegs = new int[16]; 
    int[] newRegs = new int[16]; 
    
    class StreamConfig
    {
        boolean[] hasVoice = new boolean[3];
        boolean hasEnvelope;
        boolean hasSomeNoise;
        boolean[] hasNoise = new boolean[3];
        boolean[] hasTone = new boolean[3];
        boolean[] usedRegs = new boolean[14];
        boolean[] allToneSame = new boolean[3];
        int first7 = 0;

    
    }
    
    
    Dictionary buildYMBitStream()
    {
        int start = 0;
        int end = ymSound.vbl_len;
        // build config
        StreamConfig sConfig = new StreamConfig();
        for (int i=0; i<14; i++)
            sConfig.usedRegs[i] = usedRegs[i];
        sConfig.hasVoice[0] = true;
        sConfig.hasVoice[1] = true;
        sConfig.hasVoice[2] = true;
        sConfig.hasTone[0] = false;
        sConfig.hasTone[1] = false;
        sConfig.hasTone[2] = false;
        long sumAmp0 = 0;
        long sumAmp1 = 0;
        long sumAmp2 = 0;
        if ((!sConfig.usedRegs[0]) && (!sConfig.usedRegs[1])) sConfig.hasVoice[0] = false;
        if (!sConfig.usedRegs[8]) sConfig.hasVoice[0] = false;
        
        if ((!sConfig.usedRegs[2]) && (!sConfig.usedRegs[3])) sConfig.hasVoice[1] = false;
        if (!sConfig.usedRegs[9]) sConfig.hasVoice[1] = false;

        if ((!sConfig.usedRegs[4]) && (!sConfig.usedRegs[5])) sConfig.hasVoice[2] = false;
        if (!sConfig.usedRegs[10]) sConfig.hasVoice[2] = false;
        
        for (int i=start;i<end; i++)
        {
            sumAmp0 += ymSound.out_buf[8][i];
            sumAmp1 += ymSound.out_buf[9][i];
            sumAmp2 += ymSound.out_buf[10][i];
        }
        if (sumAmp0==0) sConfig.hasVoice[0] = false;
        if (sumAmp1==0) sConfig.hasVoice[1] = false;
        if (sumAmp2==0) sConfig.hasVoice[2] = false;

        if (jCheckBoxForce1.isSelected()) 
        {
            sConfig.usedRegs[0] = true;
            sConfig.usedRegs[1] = true;
            sConfig.usedRegs[8] = true;

            sConfig.hasVoice[0] = true;
        }
        if (jCheckBoxForce2.isSelected()) 
        {
            sConfig.usedRegs[2] = true;
            sConfig.usedRegs[3] = true;
            sConfig.usedRegs[9] = true;

            sConfig.hasVoice[1] = true;
        }
        if (jCheckBoxForce3.isSelected()) 
        {
            sConfig.usedRegs[4] = true;
            sConfig.usedRegs[5] = true;
            sConfig.usedRegs[10] = true;

            sConfig.hasVoice[2] = true;
        }
        
        sConfig.allToneSame[0] = sConfig.hasVoice[0];
        sConfig.allToneSame[1] = sConfig.hasVoice[1];
        sConfig.allToneSame[2] = sConfig.hasVoice[2];
        
        sConfig.first7 = 0;
        if (!sConfig.hasVoice[0]) sConfig.first7+=1;
        if (!sConfig.hasVoice[1]) sConfig.first7+=2;
        if (!sConfig.hasVoice[2]) sConfig.first7+=4;
        if (!sConfig.hasNoise[0]) sConfig.first7+=8;
        if (!sConfig.hasNoise[1]) sConfig.first7+=16;
        if (!sConfig.hasNoise[2]) sConfig.first7+=32;
        
        
        boolean starting = true;
        boolean tone0=true;
        boolean tone1=true;
        boolean tone2=true;
        
        for (int i=start;i<end; i++)
        {
            if (starting)
            {
                tone0 = (ymSound.out_buf[7][start]&0x01)==1;
                tone1 = (ymSound.out_buf[7][start]&0x02)==2;
                tone2 = (ymSound.out_buf[7][start]&0x04)==4;
                sConfig.first7 = ymSound.out_buf[7][start];
            }
            
            if ((sConfig.hasVoice[0]) && (ymSound.out_buf[8][i]>=16)) sConfig.hasEnvelope = true;
            if ((sConfig.hasVoice[1]) && (ymSound.out_buf[9][i]>=16)) sConfig.hasEnvelope = true;
            if ((sConfig.hasVoice[2]) && (ymSound.out_buf[10][i]>=16)) sConfig.hasEnvelope = true;

            if ((sConfig.hasVoice[0]) && ((ymSound.out_buf[7][i]&0x08) == 0)) 
            {
                sConfig.hasSomeNoise = true;
                sConfig.hasNoise[0] = true;
            }
            if ((sConfig.hasVoice[1]) && ((ymSound.out_buf[7][i]&0x10) == 0)) 
            {
                sConfig.hasSomeNoise = true;
                sConfig.hasNoise[1] = true;
            }
            if ((sConfig.hasVoice[2]) && ((ymSound.out_buf[7][i]&0x20) == 0))
            {
                sConfig.hasSomeNoise = true;
                sConfig.hasNoise[2] = true;
            }

            if ((sConfig.hasVoice[0]) && ((ymSound.out_buf[7][i]&0x01) == 0)) 
            {
                sConfig.hasTone[0] = true;
            }
            if ((sConfig.hasVoice[1]) && ((ymSound.out_buf[7][i]&0x2) == 0)) 
            {
                sConfig.hasTone[1] = true;
            }
            if ((sConfig.hasVoice[2]) && ((ymSound.out_buf[7][i]&0x4) == 0))
            {
                sConfig.hasTone[2] = true;
            }
            
            if ((tone0) != ((ymSound.out_buf[7][i]&0x01)==1)) sConfig.allToneSame[0] = false;
            if ((tone1) != ((ymSound.out_buf[7][i]&0x02)==2)) sConfig.allToneSame[1] = false;
            if ((tone2) != ((ymSound.out_buf[7][i]&0x04)==4)) sConfig.allToneSame[2] = false;
            
        }
        if (!sConfig.hasVoice[0]) sConfig.allToneSame[0] = true;
        if (!sConfig.hasVoice[1]) sConfig.allToneSame[1] = true;
        if (!sConfig.hasVoice[2]) sConfig.allToneSame[2] = true;
        
        
        ////
        Dictionary d = new Dictionary();
        d.sConfig = sConfig;
        if (ymSound.vbl_len<=1) return d;
        HashMap<String, Integer> dictionary = new HashMap<String, Integer>();
        d.bitStream = new StringBuilder();
        updateCheckBoxes();
        if (!usedRegs[7]) return d;
        if ((!usedRegs[8]) && (usedRegs[9]) && (usedRegs[10])) return d;
        
        if (!usedRegs[11]) sConfig.hasEnvelope = false;
        if (!usedRegs[12]) sConfig.hasEnvelope = false;
        if (!usedRegs[13]) sConfig.hasEnvelope = false;

        if (!sConfig.hasEnvelope) 
        {
            usedRegs[11] = false;
            usedRegs[12] = false;
            usedRegs[13] = false;
        }
        
        for (int i=0; i< 16; i++)
        {
            oldRegs[i] = -1;
        }
        
        String lastvoice1 = "";
        String lastvoice2 = "";
        String lastvoice3 = "";
        String lastOut ="";
        String lastnoise = "";
        
        int lastEnvelopeFreq1 = 0;
        int lastEnvelopeFreq2 = 0;
        int lastEnvelope = 0;
        
        
        for (int i=start; i<end; i++)
        {
            String voice1 = "";
            if (sConfig.hasVoice[0]) voice1 = buildVoice(0, i, sConfig);
            String voice2 = "";
            if (sConfig.hasVoice[1]) voice2 = buildVoice(1, i, sConfig);
            String voice3 = "";
            if (sConfig.hasVoice[2]) voice3 = buildVoice(2, i, sConfig);

            String newOut = voice1+voice2+voice3;
            String noise ="";
            if (sConfig.hasSomeNoise) 
            {
                noise = appendbitsMSBFirst(new StringBuilder(), getNoisePeriod(i), 5).toString();
                boolean hasNoise = anyNoise(i);

                if (hasNoise) 
                {
                    newOut+="1";
                    newOut+=noise;
                }
                else 
                    newOut+="0";
            }
                
            
            StringBuilder nextLine = new StringBuilder();
            // now a complete line is done
            // check if we can optimize further
            // this means checking if the line (or parts)
            // are the same as last line!
            
            if (newOut.equals(lastOut))
            {
                // complete line is the same, than
                // we output only 1 bit == 0
                nextLine.append("0");
            }
            else
            {
                nextLine.append("1"); // indicate line changed

                if (sConfig.hasVoice[0])
                {
                    // something in the line differs
                    // now we output each part seperately
                    // Voice1, Voice2, Voice3, noise
                    if (voice1.equals(lastvoice1))
                    {
                        // voice1 is the same, than also only a 0
                        nextLine.append("0");
                    }
                    else
                    {
                        nextLine.append("1"); // indicate voice changed
                        nextLine.append(voice1); 
                    }
                }
                if (sConfig.hasVoice[1])
                {
                    if (voice2.equals(lastvoice2))
                    {
                        // voice2 is the same, than also only a 0
                        nextLine.append("0");
                    }
                    else
                    {
                        nextLine.append("1"); // indicate voice changed
                        nextLine.append(voice2); 
                    }
                }                
                if (sConfig.hasVoice[2])
                {
                    if (voice3.equals(lastvoice3))
                    {
                        // voice3 is the same, than also only a 0
                        nextLine.append("0");
                    }
                    else
                    {
                        nextLine.append("1"); // indicate voice changed
                        nextLine.append(voice3); 
                    }
                }
                if (sConfig.hasSomeNoise) 
                {
                    if (noise.equals(lastnoise))
                    {
                        // noise is the same, than also only a 0
                        nextLine.append("0");
                    }
                    else
                    {
                        nextLine.append("1"); // indicate noise changed
                        nextLine.append(noise); 
                    }
                }
                if (sConfig.hasEnvelope)
                {
                    // 0xff indicates no change to envelope
                    if (/*(lastEnvelope != ymSound.out_buf[13][i]) &&*/ ((ymSound.out_buf[13][i]&0xff)!= 0xff) )
                    {
                        String envString = appendbitsMSBFirst(new StringBuilder(), ymSound.out_buf[13][i], 4).toString();
                        nextLine.append("1"); // indicate envelope changed
                        nextLine.append(envString); 
                        lastEnvelope = ymSound.out_buf[13][i];
                    }
                    else
                    {
                        // env is the same, than also only a 0
                        nextLine.append("0");
                    }
                    if (lastEnvelopeFreq1*256+lastEnvelopeFreq2 != ymSound.out_buf[11][i]*256+ymSound.out_buf[12][i])
                    {
                        String envFreqString = appendbitsMSBFirst(new StringBuilder(), ymSound.out_buf[11][i], 8).toString();
                        envFreqString += appendbitsMSBFirst(new StringBuilder(), ymSound.out_buf[12][i], 8).toString();

                        nextLine.append("1"); // indicate envelope freq changed
                        nextLine.append(envFreqString); 
                        lastEnvelopeFreq1 = ymSound.out_buf[11][i];
                        lastEnvelopeFreq2 = ymSound.out_buf[12][i];
                    }
                    else
                    {
                        // env is the same, than also only a 0
                        nextLine.append("0");
                    }

                }
                
            }

            
            
            
            
            for (int ii=0; ii< 16; ii++) oldRegs[ii] = ymSound.out_buf[ii][i];
//System.out.println(nextLine);
            d.bitStream.append(nextLine); 
            
            Integer usage = 1;
            if (dictionary.containsKey(nextLine.toString()))
            {
                usage = dictionary.get(nextLine.toString())+1;
            }
            dictionary.put(nextLine.toString(), usage);     
            
            lastOut = newOut;
            lastvoice1 = voice1;
            lastvoice2 = voice2;
            lastvoice3 = voice3;
            lastnoise = noise;
        }        
        Set entries = dictionary.entrySet();
        Iterator it = entries.iterator();
        while (it.hasNext())
        {
            Map.Entry entry = (Map.Entry) it.next();
            Integer usage = (Integer) entry.getValue();
            String bits = (String) entry.getKey();
            d.datalines.add(new OneDataLine(bits, usage));
        }
        
        return d;
    }
    
    void preprocess()
    {
        if (ymSound.vbl_len<=1) return;
        updateCheckBoxes();
        if (!usedRegs[7]) return;
        if ((!usedRegs[8]) && (usedRegs[9]) && (usedRegs[10])) return;
        
        
        int start = 0;
        int end = ymSound.vbl_len;
        int aCount = 0;
        int nCount = 0;
        int nfCount = 0;
        for (int row=start; row<end; row++)
        {
            boolean hasNoise = false;
            for (int voice=0;voice<3;voice++)
            {
                int amplitude = getAmplitude(voice, row);
                boolean tone = isTone(voice, row);
                boolean noise = isNoise(voice, row);
                if (amplitude == 0) 
                {
                    aCount++;
                    if (preprocAmp)
                    {
                        if (voice == 0) ymSound.out_buf[0][row] =0;
                        if (voice == 0) ymSound.out_buf[1][row] =0;
                        if (voice == 1) ymSound.out_buf[2][row] =0;
                        if (voice == 1) ymSound.out_buf[3][row] =0;
                        if (voice == 2) ymSound.out_buf[4][row] =0;
                        if (voice == 2) ymSound.out_buf[5][row] =0;
                    }
                }
                
                if (noise) hasNoise=noise;
                if (!tone)
                {
                    if (preprocTone)
                    {
                        if (voice == 0) ymSound.out_buf[0][row] =0;
                        if (voice == 0) ymSound.out_buf[1][row] =0;
                        if (voice == 1) ymSound.out_buf[2][row] =0;
                        if (voice == 1) ymSound.out_buf[3][row] =0;
                        if (voice == 2) ymSound.out_buf[4][row] =0;
                        if (voice == 2) ymSound.out_buf[5][row] =0;
                    }
                    nfCount++;
                }
            
            }
            if (!hasNoise) 
            {
                if (preprocNoise)
                    ymSound.out_buf[6][row] =0;
                nCount++;
            }
            
        }        
        jLabel146.setText(""+aCount);
        jLabel148.setText(""+nfCount);
        jLabel147.setText(""+nCount);
    }

    boolean preprocNoise = false;
    boolean preprocTone = false;
    boolean preprocAmp = false;
           
    /*
     ym packing rules
     - first register 7
     - if tone for voice disabled - no frequency for that voice
     - if no noise at all - no noise gen
     - if no amplitude for voice (0) than no frequency for that voice
     - frequency is 12 bits
     - noise is 4 bit
     - amplitude is 5 bit
     - enable is 6 bit (highest bits should be 1)

     - each channel is packed seperately 
    
     - optimization:
       1) amplitude only 4 lower bits, since bit 5 is a mode bit, and I don't know any ym that make use of that
       2) noise and tone are assumed to be not played at the same time (although PSG alows it), they are represented as:
          1= noise, 0 = tone
    
    
    
     - save LINES of so generated registers
     - use RLE to decode line number
     - 0 - 0 changes do not have a line, they are just that - 0 changes!
     !!!
    
    */
    
    class ListerEntry
    {
        String fileName="";
        String completePath="";
        long size = 0;
    }
    String[] listerColumns = {"Name", "Size"};
    ArrayList<ListerEntry> listerArray = new ArrayList<ListerEntry>();
    ListerTableModel listerModel = new ListerTableModel();
    public class ListerTableModel extends AbstractTableModel
    {    
        @Override
        public String getColumnName(int col) {
            return listerColumns[col];
        }
        @Override
        public int getRowCount() {
            return listerArray.size();
        }

        @Override
        public int getColumnCount() {
            return listerColumns.length;
        }
        @Override
        public Object getValueAt(int row, int col) {
            if (col == 0) return listerArray.get(row).fileName;
            if (col == 1) return listerArray.get(row).size;
            return "";
        }
        @Override
        public Class<?> getColumnClass(int col) 
        {
            if (col == 0) return String.class;
            if (col == 1) return long.class;
            return Object.class;
        }
        @Override
        public boolean isCellEditable(int row, int col) 
        {
            return false;
        }
    }
    void initLister()
    {
        listerArray.clear();

        ArrayList<String> filenames = de.malban.util.UtilityFiles.getFilesWith(pathOnly, ".ym");
        if (pathOnly.length()>0) if (!pathOnly.endsWith(File.separator)) pathOnly+= File.separator;
        for (String f: filenames)
        {
            try
            {
                ListerEntry entry = new ListerEntry();
                entry.fileName = f;
                entry.completePath = pathOnly+f;
                File ff = new File(entry.completePath);
                entry.size = ff.length();
                listerArray.add(entry);
            }
            catch (Throwable e)
            {
                
            }
        }

        filenames = de.malban.util.UtilityFiles.getFilesWith(pathOnly, ".afx");
        if (pathOnly.length()>0) if (!pathOnly.endsWith(File.separator)) pathOnly+= File.separator;
        for (String f: filenames)
        {
            try
            {
                ListerEntry entry = new ListerEntry();
                entry.fileName = f;
                entry.completePath = pathOnly+f;
                File ff = new File(entry.completePath);
                entry.size = ff.length();
                listerArray.add(entry);
            }
            catch (Throwable e)
            {
                
            }
        }
        
        
        jTable3.setModel(listerModel);
        jTable3.tableChanged(null);
    }
    private void tableClicked(java.awt.event.MouseEvent evt) 
    {             
        if (evt.getClickCount() == 2) 
        {
            Point p = evt.getPoint();
            int row = jTable3.rowAtPoint(p);
            int col = jTable3.columnAtPoint(p);
            if (row <0) return;
            if (row >listerArray.size()-1) return;

            if (playingYM)
            {
                playingYM = false;
                try
                {
                    while (three != null)
                    {
                        Thread.sleep(5);
                    }
                }
                catch (Throwable e)
                {
                }
            }
            if (listerArray.get(row).completePath.toLowerCase().endsWith("ym"))
            {
                initYM( listerArray.get(row).completePath);
                ympos = 0;
                workBufToSelection();
                jTable1.tableChanged(null);
                jTable2.tableChanged(null);
                jTable1.repaint();
                jTable2.repaint();

                loopStart = -1;
                loopEnd = -1;
                int[] rows = jTable1.getSelectedRows();
                if (rows.length >1)
                {
                    loopStart = rows[0];
                    loopEnd = rows[rows.length-1];
                }
                startYM();
            }            
            else
            {
                jButtonNewYMActionPerformed(null);                
                lastPath = listerArray.get(row).completePath.toLowerCase();

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
                    return;
                }

                initAFX("A", data, false, path.toString());
                jButtonPlaySampleActionPerformed(null);                                        

            }
        }
    }               
    void completeColumnToValue(int reg, int value)
    {
        for (int row = 0; row <ymSound.vbl_len; row++)
            ymSound.out_buf[reg][row] = (byte)(value & 0xff);
        jTable1.repaint();
    }
    byte[][] readStatements(String file)
    {
        int lineLength=0;
        String text = de.malban.util.UtilityString.readTextFileToOneString(new File (file));

        String[] lines = text.split("\n");
        ArrayList<String> lineArray = new ArrayList<String>();
        for (String line: lines)
        {
            line = line.trim();
        line = de.malban.util.UtilityString.replace(line, "\r", " ");
        line = de.malban.util.UtilityString.replace(line, "\t", " ");
        line = de.malban.util.UtilityString.replace(line, ",", " ");
        line = de.malban.util.UtilityString.replace(line, "0x", "$");
        line = de.malban.util.UtilityString.replace(line, "  ", " ");
            if (line.length() != 0)
            {
                lineArray.add(line);
            }
        }
        int lineCount = lineArray.size();
        if (lineCount==0) return null;
        
        String textLine = lineArray.get(0);
        String[] values = textLine.split(" ");
        ArrayList<String> valueArray = new ArrayList<String>();
        for (String value: values)
        {
            value = value.trim();
            if (value.length() != 0)
            {
                valueArray.add(value);
            }
        }
        int regCount = valueArray.size();
        if (regCount==0) return null;
        
        byte[][] buf = new byte[16][lineCount];
        
        int l = 0;
        for (String line: lineArray)
        {
            int r = 0;
            String[] regs = line.split(" ");
            for (String reg: regs)
            {
                reg = reg.trim();
                if (reg.length() != 0)
                {
                    buf[r++][l] = (byte) ((DASM6809.toNumber(reg))&0xff);
                }
            }
            if (r != regCount) return null;
            l++;
//            System.out.println(""+l+"/"+lineCount);
        }
        
        
        return buf;
    }
    void swapVoice(int v1, int v2)
    {
        int start = 0;
        int end = ymSound.vbl_len;
        int f1low=0, f1hi=0, f2low=0, f2hi=0,a1=0,a2=0,bit1v=0, bit2v=0, bit1n=0, bit2n=0;
        
        if (v1==0)
        {
            f1low = 0;
            f1hi = 1;
            a1 = 8;
            bit1v = 0;
            bit1n = 3;
        }
        if (v1==1)
        {
            f1low = 2;
            f1hi = 3;
            a1 = 9;
            bit1v = 1;
            bit1n = 4;
        }
        if (v1==2)
        {
            f1low = 4;
            f1hi = 5;
            a1 = 10;
            bit1v = 2;
            bit1n = 5;
        }
        if (v2==0)
        {
            f2low = 0;
            f2hi = 1;
            a2 = 8;
            bit2v = 0;
            bit2n = 3;
        }
        if (v2==1)
        {
            f2low = 2;
            f2hi = 3;
            a2 = 9;
            bit2v = 1;
            bit2n = 4;
        }
        if (v2==2)
        {
            f2low = 4;
            f2hi = 5;
            a2 = 10;
            bit2v = 2;
            bit2n = 5;
        }
        
        for (int row=start; row<end; row++)
        {
            swapreg(row, f1low,f2low);
            swapreg(row, f1hi,f2hi);
            swapreg(row, a1,a2);
            swapbit(row,7, bit1v, bit2v);
            swapbit(row,7, bit1n, bit2n);
        }        
        jTable1.repaint();
    }
    void swapreg(int row, int r1, int r2)
    {
        byte tmp = ymSound.out_buf[r1][row];
        ymSound.out_buf[r1][row] = ymSound.out_buf[r2][row];
        ymSound.out_buf[r2][row] = tmp;
    }
    /*
    boolean getBit(int b, int pos)
    {
        for (int i=0; i<pos;i++) 
            b = b >> 1;
        return (b & 0x01) ==0x01;
    }
    int setBit(int r, int pos, boolean bit)
    {
        int mask = 1;
        for (int i=0; i<pos;i++)
            mask = mask <<1;

        r = r & (-1 ^ mask); //delete bit
        if (bit)
            r = r | mask; // set bit
        return r;
    }
*/
    void swapbit(int row,int reg, int r1, int r2)
    {
        byte r = ymSound.out_buf[reg][row];

        boolean b1 = readBit(r, r1);
        boolean b2 = readBit(r, r2);
        r = (byte) setBit(r, r2, b1);
        r = (byte) setBit(r, r1, b2);
        
        ymSound.out_buf[reg][row] = r;

    }
    void multiplayVoiceAmplitude(int voice ,double mul)
    {
        int reg = 8;
        if (voice ==1) reg++;
        if (voice ==2) reg+=2;
        for (int row = 0; row <ymSound.vbl_len; row++)
        {
            // keep envelope
            int x = ymSound.out_buf[reg][row] & 0x10;
            ymSound.out_buf[reg][row] = (byte)(((int)(ymSound.out_buf[reg][row]*mul)) & 0x0f);
            ymSound.out_buf[reg][row] +=x;
        }
        jTable1.repaint();
        
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
        //SwingUtilities.updateComponentTreeUI(jPopupMenu1);
        //SwingUtilities.updateComponentTreeUI(jPopupMenuTree);
        //SwingUtilities.updateComponentTreeUI(jPopupMenuProjectProperties);
        int fontSize = Theme.textFieldFont.getFont().getSize();
        int rowHeight = fontSize+2;
        jTable1.setRowHeight(rowHeight);
        jTable2.setRowHeight(rowHeight);
    }
    
    
}
