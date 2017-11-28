/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vedi.sound;

import de.malban.Global;
import de.malban.config.Configuration;
import de.malban.config.TinyLogInterface;
import de.malban.gui.CSAMainFrame;
import de.malban.gui.Windowable;
import de.malban.gui.components.CSATableModel;
import de.malban.gui.components.CSAView;
import de.malban.gui.components.DoubleClickAction;
import de.malban.gui.components.ModalInternalFrame;
import de.malban.gui.dialogs.InternalFrameFileChoser;
import de.malban.gui.dialogs.QuickHelpModal;
import de.malban.gui.dialogs.ShowErrorDialog;
import de.malban.gui.panels.LogPanel;
import de.malban.sound.tinysound.Sound;
import de.malban.sound.tinysound.TinySound;
import de.malban.vide.dissy.DASM6809;
import de.malban.vide.vedi.VediPanel;
import static de.malban.vide.vedi.sound.ModJPanel.VectrexInstrument.*;
import de.malban.vide.vedi.sound.ibxm.Sample;
import de.muntjak.tinylookandfeel.Theme;
import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Vector;
import javax.sound.sampled.AudioFormat;
import javax.sound.sampled.AudioInputStream;
import javax.swing.DefaultCellEditor;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JInternalFrame;
import javax.swing.UIManager;
import javax.swing.filechooser.FileNameExtensionFilter;
import javax.swing.table.AbstractTableModel;
import javax.swing.table.TableCellEditor;

/**
 * // see: http://www.jsresources.org/examples/AudioRecorder.html
 * @author malban
 */
public class ModJPanel extends javax.swing.JPanel implements Windowable
{
    LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
    String currentModFile = "";
    String pathOnly = "";
    TinyLogInterface tinyLog = null;
    private int mClassSetting=0;
    private CSAView mParent = null;
    private javax.swing.JMenuItem mParentMenuItem = null;
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
        mParentMenuItem.setText("Mod2Vectrex");
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
    
    static class VectrexInstrument
    {
        public static final VectrexInstrument SILENCE = new VectrexInstrument("Silence", (byte)0x3f, true, false, false);
        public static final VectrexInstrument NOTE = new VectrexInstrument("Note", (byte)0, false, true, false);
        public static final VectrexInstrument BASS = new VectrexInstrument("Bass drum", (byte)63, false, false, true);
        public static final VectrexInstrument HIHAT = new VectrexInstrument("HiHat drum", (byte)1, false, false, true);
        public static final VectrexInstrument SNARE = new VectrexInstrument("Snare drum", (byte)47, false, false, true);
        String name;
        byte vectrexByte;
        boolean isSilent;
        boolean isNote;
        boolean isNoise;
        public VectrexInstrument(String na, byte b, boolean s, boolean n, boolean x)
        {
            name = na;
            vectrexByte = b;
            isSilent = s;
            isNote = n;
            isNoise = x;
        }
        public String toString()
        {
            return name;
        }
    }
    class InstrumentHandle
    {
        int no;
        String name;
        int length;
        int[] usage = new int[4];
        VectrexInstrument vectrex;
        public InstrumentHandle()
        {
            usage[0] = 0;
            usage[1] = 0;
            usage[2] = 0;
            usage[3] = 0;
        }
    }

    ArrayList<InstrumentHandle> instrumentHandles = new ArrayList<InstrumentHandle>();
    static ArrayList<VectrexInstrument> vectrexInstruments= new ArrayList<VectrexInstrument>();
    static
    {
        vectrexInstruments.add(SILENCE);
        vectrexInstruments.add(NOTE);
        vectrexInstruments.add(BASS);
        vectrexInstruments.add(HIHAT);
        vectrexInstruments.add(SNARE);
    }
    public class ModTableModel extends AbstractTableModel
    {    
        String[] columns = {"No", "Name", "SampleLength","Used #", "VectrexName", "VectrexByte"};

        @Override
        public String getColumnName(int col) {
            return columns[col];
        }
        @Override
        public int getRowCount() {
            return instrumentHandles.size();
        }

        @Override
        public int getColumnCount() {
            return columns.length;
        }
        String pad(int v, int p)
        {
            String ret=""+v;
                 if (v<10)   ret = "   "+ret;
            else if (v<100)  ret = "  "+ret;
            else if (v<1000) ret = " "+ret;
            return ret;
        }
        @Override
        public Object getValueAt(int row, int col) {
            if (col==0) return instrumentHandles.get(row).no;
            if (col==1) return instrumentHandles.get(row).name;
            if (col==2) return instrumentHandles.get(row).length;
            if (col==3) 
            {
                int sum = instrumentHandles.get(row).usage[0]+instrumentHandles.get(row).usage[1]+instrumentHandles.get(row).usage[2]+instrumentHandles.get(row).usage[3];
                String r = ""+sum+"";
                if (sum < 10)            r+="   ";
                else if (sum < 100)      r+="  ";
                else if (sum < 1000)     r+=" ";
                
                r += "(";
                r+="0:"+ pad(instrumentHandles.get(row).usage[0],4);
                r+=" 1:"+pad(instrumentHandles.get(row).usage[1],4);
                r+=" 2:"+pad(instrumentHandles.get(row).usage[2],4);
                r+=" 3:"+pad(instrumentHandles.get(row).usage[3],4);
                r += ")";
                return r;
            }
                    
                    
                    
            if (col==4) return instrumentHandles.get(row).vectrex.name;
            if (col==5) 
            {
                if (instrumentHandles.get(row).vectrex.vectrexByte == 256) return "$xx";
                if (instrumentHandles.get(row).vectrex.isNoise)
                {
                    return  "$"+String.format("%02X", instrumentHandles.get(row).vectrex.vectrexByte & 0xff)+"+64";
                }
                return  "$"+String.format("%02X", instrumentHandles.get(row).vectrex.vectrexByte & 0xff);
            }
            return "";
        }
        public Class<?> getColumnClass(int col) 
        {
            if (col == 4) return VectrexInstrument.class;
            return Object.class;
        }
        public boolean isCellEditable(int row, int col) 
        {
            return (col == 4);
        }
        public void setValueAt(Object aValue, int row, int col) 
        {
            if (aValue instanceof VectrexInstrument)
                if (col == 4) instrumentHandles.get(row).vectrex = (VectrexInstrument)aValue;
        }
    }
    void deinit()
    {
        iBXMPlayerJPanel1.stop();
        removeUIListerner();
    }

    void initModFile(String filename)
    {
        File file = new File(filename);
        if (file.isDirectory())
        {
            pathOnly = file.toString();
        }
        else
        {
            pathOnly = file.getParent();
            if (pathOnly==null) pathOnly ="";
            currentModFile = filename;
        }
        if (pathOnly.length()!=0) pathOnly+=File.separator;
        iBXMPlayerJPanel1.setModfile(currentModFile);
        cSATablePanel1.setTableStyleSwitchingEnabled(false);

        
        JComboBox comboBox = new JComboBox(vectrexInstruments.toArray());
        TableCellEditor editor = new DefaultCellEditor(comboBox);
        
        Vector<String> in = iBXMPlayerJPanel1.getInstruments();
        if (currentModFile.length()!=0)
        {
            for(int i=0; i< in.size(); i++)
            {
                InstrumentHandle ins = new InstrumentHandle();
                ins.name = in.elementAt(i).substring(4);
                ins.no = DASM6809.toNumber(in.elementAt(i).substring(0,3));
                ins.vectrex = SILENCE;
                Sample sample = iBXMPlayerJPanel1.getInstrumentSample(ins.no);
                ins.length = sample.getSampleData().length*2; // in byte
                instrumentHandles.add(ins);
            }
            Mod2Vectrex infoCollector = new Mod2Vectrex();
            infoCollector.collectInfo(filename, instrumentHandles);

            jLabelv1.setText(""+getVoiceUsage(instrumentHandles,0));
            jLabelv2.setText(""+getVoiceUsage(instrumentHandles,1));
            jLabelv3.setText(""+getVoiceUsage(instrumentHandles,2));
            jLabelv4.setText(""+getVoiceUsage(instrumentHandles,3));        
        }
        else
        {
            jLabelv1.setText("");
            jLabelv2.setText("");
            jLabelv3.setText("");
            jLabelv4.setText("");        
        }

        
        csaModel = CSATableModel.buildTableModel(new ModTableModel());
        cSATablePanel1.setModel(csaModel);
        cSATablePanel1.getTable().setDefaultEditor(VectrexInstrument.class, editor);
        cSATablePanel1.setHeaderEnabled(false);
        cSATablePanel1.setDoubleClickAction(new DoubleClickAction()
        {
            public void doIt()
            {
                int[] rows = cSATablePanel1.getSelectedRows();
                if (rows.length>0) playInstrument(rows[0]);
            }
        });
        if (currentModFile.length()!=0)
            updateVoicePlay();
        
    }
    /**
     * Creates new form SampleJPanel
     */
    public ModJPanel(String filename, TinyLogInterface tl) 
    {
        initComponents();
        initInstrumentCombo();
        tinyLog = tl;
        // check if is a file or a dir
        if (filename != null)
        {
            jPanel3.setVisible(false);
            initModFile(filename);
        }
        else
        {
            filename = "";
            initModFile(filename);
        }
        UIManager.addPropertyChangeListener(pListener);
        updateMyUI(); 

    }
    int getVoiceUsage(ArrayList<InstrumentHandle> instrumentHandles, int voice)
    {
        int sum = 0;
        for (InstrumentHandle h: instrumentHandles)
        {
            sum +=h.usage[voice];
        }
        return sum;
    }
    
    CSATableModel csaModel;
    void playInstrument(int instrument)
    {
        System.out.println("Playing: "+instrumentHandles.get(instrument).name);
        Sample sample = iBXMPlayerJPanel1.getInstrumentSample(instrumentHandles.get(instrument).no);
        short[] dataOrg = sample.getSampleData();
	 
        
        
	AudioFormat FORMAT = new AudioFormat(
			AudioFormat.Encoding.PCM_SIGNED, //linear signed PCM
			sample.c2Rate,//44100, //44.1kHz sampling rate
			16, //16-bit
			1, //2 channels fool
			2, //frame size 4 bytes (16-bit, 2 channel)
			44100,//44100, //same as sampling rate
			false //little-endian
			);
        
        byte[] sampleData = new byte[dataOrg.length*2];

        for (int i=0; i<dataOrg.length;i++ )
        {
            sampleData[i*2+0] = (byte)(dataOrg[i]&0xff);
            sampleData[i*2+1] = (byte)((dataOrg[i]>>8)&0xff);
        }
        
        AudioInputStream audioStream= new AudioInputStream( new ByteArrayInputStream(sampleData) ,FORMAT, sampleData.length );
        
        Sound s = TinySound.loadSound(audioStream, false);         
        s.play();
        
        
        
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
        jButtonCreate = new javax.swing.JButton();
        jButtonCancel = new javax.swing.JButton();
        jButton6 = new javax.swing.JButton();
        iBXMPlayerJPanel1 = new de.malban.vide.vedi.sound.ibxm.IBXMPlayerJPanel();
        jPanel1 = new javax.swing.JPanel();
        jLabel1 = new javax.swing.JLabel();
        jLabel2 = new javax.swing.JLabel();
        jRadioButton1 = new javax.swing.JRadioButton();
        jRadioButton2 = new javax.swing.JRadioButton();
        jRadioButton3 = new javax.swing.JRadioButton();
        jRadioButton4 = new javax.swing.JRadioButton();
        jLabel3 = new javax.swing.JLabel();
        jRadioButton5 = new javax.swing.JRadioButton();
        jRadioButton6 = new javax.swing.JRadioButton();
        jRadioButton7 = new javax.swing.JRadioButton();
        jRadioButton8 = new javax.swing.JRadioButton();
        jLabel4 = new javax.swing.JLabel();
        jRadioButton9 = new javax.swing.JRadioButton();
        jRadioButton10 = new javax.swing.JRadioButton();
        jRadioButton11 = new javax.swing.JRadioButton();
        jRadioButton12 = new javax.swing.JRadioButton();
        jLabel5 = new javax.swing.JLabel();
        jTextFieldADSR1 = new javax.swing.JTextField();
        jLabel7 = new javax.swing.JLabel();
        jTextFieldTWANG1 = new javax.swing.JTextField();
        jLabel8 = new javax.swing.JLabel();
        jLabelv1 = new javax.swing.JLabel();
        jLabelv2 = new javax.swing.JLabel();
        jLabelv3 = new javax.swing.JLabel();
        jLabelv4 = new javax.swing.JLabel();
        jCheckBoxV1 = new javax.swing.JCheckBox();
        jCheckBoxV2 = new javax.swing.JCheckBox();
        jCheckBoxV3 = new javax.swing.JCheckBox();
        jCheckBoxV4 = new javax.swing.JCheckBox();
        jLabel9 = new javax.swing.JLabel();
        jCheckBoxIndirectOutput = new javax.swing.JCheckBox();
        jLabel6 = new javax.swing.JLabel();
        jTextFieldADSR2 = new javax.swing.JTextField();
        jTextFieldADSR3 = new javax.swing.JTextField();
        jLabel10 = new javax.swing.JLabel();
        jComboBox1 = new javax.swing.JComboBox();
        jComboBox2 = new javax.swing.JComboBox();
        jComboBox3 = new javax.swing.JComboBox();
        jLabel11 = new javax.swing.JLabel();
        jTextFieldTWANG2 = new javax.swing.JTextField();
        jTextFieldTWANG3 = new javax.swing.JTextField();
        jLabel12 = new javax.swing.JLabel();
        jButton7 = new javax.swing.JButton();
        jButton2 = new javax.swing.JButton();
        jLabel13 = new javax.swing.JLabel();
        jTextField1 = new javax.swing.JTextField();
        jPanel2 = new javax.swing.JPanel();
        cSATablePanel1 = new de.malban.gui.components.CSATablePanel();
        jPanel3 = new javax.swing.JPanel();
        jLabel14 = new javax.swing.JLabel();
        jButtonLoad = new javax.swing.JButton();

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

        jButton6.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/information.png"))); // NOI18N
        jButton6.setText("info");
        jButton6.setPreferredSize(new java.awt.Dimension(72, 20));
        jButton6.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton6ActionPerformed(evt);
            }
        });

        jPanel1.setBorder(javax.swing.BorderFactory.createTitledBorder("Conversion settings\n"));

        jLabel1.setText("Mods have 4 voices, the PSG has only three voices, therefor you can decide which voice(s) to convert:");

        jLabel2.setText("as PSG voice 1:");

        buttonGroup1.add(jRadioButton1);
        jRadioButton1.setSelected(true);
        jRadioButton1.setText("mod 1");

        buttonGroup1.add(jRadioButton2);
        jRadioButton2.setText("mod 2");
        jRadioButton2.setToolTipText("");

        buttonGroup1.add(jRadioButton3);
        jRadioButton3.setText("mod 3");

        buttonGroup1.add(jRadioButton4);
        jRadioButton4.setText("mod 4");

        jLabel3.setText("as PSG voice 2:");

        buttonGroup2.add(jRadioButton5);
        jRadioButton5.setText("mod 1");

        buttonGroup2.add(jRadioButton6);
        jRadioButton6.setSelected(true);
        jRadioButton6.setText("mod 2");
        jRadioButton6.setToolTipText("");

        buttonGroup2.add(jRadioButton7);
        jRadioButton7.setText("mod 3");

        buttonGroup2.add(jRadioButton8);
        jRadioButton8.setText("mod 4");

        jLabel4.setText("as PSG voice 3:");

        buttonGroup3.add(jRadioButton9);
        jRadioButton9.setText("mod 1");

        buttonGroup3.add(jRadioButton10);
        jRadioButton10.setText("mod 2");
        jRadioButton10.setToolTipText("");

        buttonGroup3.add(jRadioButton11);
        jRadioButton11.setSelected(true);
        jRadioButton11.setText("mod 3");

        buttonGroup3.add(jRadioButton12);
        jRadioButton12.setText("mod 4");

        jLabel5.setText("ADSR (32 nibble) 1:");

        jTextFieldADSR1.setFont(new java.awt.Font("Courier New", 1, 10)); // NOI18N
        jTextFieldADSR1.setText("$ff,$ed,$cb,$a9,$87,$65,$43,$21,$00,$00,$00,$00,$00,$00,$00,$00");
        jTextFieldADSR1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldADSR1ActionPerformed(evt);
            }
        });

        jLabel7.setText("TWANG (8 byte) 1:");

        jTextFieldTWANG1.setFont(new java.awt.Font("Courier New", 1, 10)); // NOI18N
        jTextFieldTWANG1.setText("$ff,$ff,$00,$00,$00,$00,$00,$00");

        jLabel8.setText("voice usages:");

        jLabelv1.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLabelv1.setText("0");
        jLabelv1.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);

        jLabelv2.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLabelv2.setText("0");
        jLabelv2.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);

        jLabelv3.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLabelv3.setText("0");
        jLabelv3.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);

        jLabelv4.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLabelv4.setText("0");
        jLabelv4.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);

        jCheckBoxV1.setSelected(true);
        jCheckBoxV1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxV1ActionPerformed(evt);
            }
        });

        jCheckBoxV2.setSelected(true);
        jCheckBoxV2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxV2ActionPerformed(evt);
            }
        });

        jCheckBoxV3.setSelected(true);
        jCheckBoxV3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxV3ActionPerformed(evt);
            }
        });

        jCheckBoxV4.setSelected(true);
        jCheckBoxV4.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxV4ActionPerformed(evt);
            }
        });

        jLabel9.setText("play voices");

        jCheckBoxIndirectOutput.setSelected(true);
        jCheckBoxIndirectOutput.setText("indirect output");
        jCheckBoxIndirectOutput.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxIndirectOutputActionPerformed(evt);
            }
        });

        jLabel6.setText("ADSR (32 nibble) 2:");

        jTextFieldADSR2.setFont(new java.awt.Font("Courier New", 1, 10)); // NOI18N
        jTextFieldADSR2.setText("$ff,$ed,$cb,$a9,$87,$65,$43,$21,$00,$00,$00,$00,$00,$00,$00,$00");
        jTextFieldADSR2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldADSR2ActionPerformed(evt);
            }
        });

        jTextFieldADSR3.setFont(new java.awt.Font("Courier New", 1, 10)); // NOI18N
        jTextFieldADSR3.setText("$ff,$ed,$cb,$a9,$87,$65,$43,$21,$00,$00,$00,$00,$00,$00,$00,$00");
        jTextFieldADSR3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldADSR3ActionPerformed(evt);
            }
        });

        jLabel10.setText("ADSR (32 nibble) 3:");

        jComboBox1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBox1ActionPerformed(evt);
            }
        });

        jComboBox2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBox2ActionPerformed(evt);
            }
        });

        jComboBox3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBox3ActionPerformed(evt);
            }
        });

        jLabel11.setText("TWANG (8 byte) 2:");

        jTextFieldTWANG2.setFont(new java.awt.Font("Courier New", 1, 10)); // NOI18N
        jTextFieldTWANG2.setText("$ff,$ff,$00,$00,$00,$00,$00,$00");

        jTextFieldTWANG3.setFont(new java.awt.Font("Courier New", 1, 10)); // NOI18N
        jTextFieldTWANG3.setText("$ff,$ff,$00,$00,$00,$00,$00,$00");

        jLabel12.setText("TWANG (8 byte) 3:");

        jButton7.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/ipod.png"))); // NOI18N
        jButton7.setText("instrument edit");
        jButton7.setPreferredSize(new java.awt.Dimension(150, 20));
        jButton7.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton7ActionPerformed(evt);
            }
        });

        jButton2.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/wand.png"))); // NOI18N
        jButton2.setToolTipText("refresh (after configuration)");
        jButton2.setMargin(new java.awt.Insets(2, 2, 2, 2));
        jButton2.setPreferredSize(new java.awt.Dimension(37, 20));
        jButton2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton2ActionPerformed(evt);
            }
        });

        jLabel13.setHorizontalAlignment(javax.swing.SwingConstants.TRAILING);
        jLabel13.setText("default speed:");

        jTextField1.setText("10");
        jTextField1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField1ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel4)
                    .addComponent(jLabel8)
                    .addComponent(jLabel9)
                    .addComponent(jLabel2)
                    .addComponent(jLabel3))
                .addGap(18, 18, 18)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jRadioButton1)
                    .addComponent(jRadioButton5)
                    .addComponent(jRadioButton9)
                    .addComponent(jLabelv1, javax.swing.GroupLayout.PREFERRED_SIZE, 44, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jCheckBoxV1))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jRadioButton2)
                    .addComponent(jRadioButton6)
                    .addComponent(jRadioButton10)
                    .addComponent(jLabelv2, javax.swing.GroupLayout.PREFERRED_SIZE, 44, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jCheckBoxV2))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jRadioButton3)
                    .addComponent(jRadioButton7)
                    .addComponent(jRadioButton11)
                    .addComponent(jLabelv3, javax.swing.GroupLayout.PREFERRED_SIZE, 44, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jCheckBoxV3))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jRadioButton4)
                    .addComponent(jRadioButton8)
                    .addComponent(jRadioButton12)
                    .addComponent(jLabelv4, javax.swing.GroupLayout.PREFERRED_SIZE, 44, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jCheckBoxV4))
                .addContainerGap(467, Short.MAX_VALUE))
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel1Layout.createSequentialGroup()
                                .addComponent(jLabel1)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 232, Short.MAX_VALUE))
                            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel1Layout.createSequentialGroup()
                                .addGap(0, 0, Short.MAX_VALUE)
                                .addComponent(jLabel13, javax.swing.GroupLayout.PREFERRED_SIZE, 139, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(4, 4, 4)))
                        .addComponent(jTextField1, javax.swing.GroupLayout.PREFERRED_SIZE, 34, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel12)
                            .addComponent(jLabel11)
                            .addComponent(jLabel7)
                            .addComponent(jLabel10)
                            .addComponent(jLabel6)
                            .addComponent(jLabel5))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jTextFieldADSR1, javax.swing.GroupLayout.PREFERRED_SIZE, 438, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextFieldADSR2, javax.swing.GroupLayout.PREFERRED_SIZE, 438, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextFieldADSR3, javax.swing.GroupLayout.PREFERRED_SIZE, 438, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextFieldTWANG1, javax.swing.GroupLayout.PREFERRED_SIZE, 300, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextFieldTWANG2, javax.swing.GroupLayout.PREFERRED_SIZE, 300, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextFieldTWANG3, javax.swing.GroupLayout.PREFERRED_SIZE, 300, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jComboBox1, javax.swing.GroupLayout.Alignment.TRAILING, 0, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jComboBox2, javax.swing.GroupLayout.Alignment.TRAILING, 0, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jComboBox3, javax.swing.GroupLayout.Alignment.TRAILING, 0, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel1Layout.createSequentialGroup()
                                .addGap(0, 0, Short.MAX_VALUE)
                                .addComponent(jCheckBoxIndirectOutput))
                            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel1Layout.createSequentialGroup()
                                .addComponent(jButton2, javax.swing.GroupLayout.PREFERRED_SIZE, 20, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                .addComponent(jButton7, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addComponent(jLabel1)
                        .addGap(0, 0, 0)
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel2)
                            .addComponent(jRadioButton1)
                            .addComponent(jRadioButton2)
                            .addComponent(jRadioButton3)
                            .addComponent(jRadioButton4)))
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addContainerGap()
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jTextField1, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel13))))
                .addGap(0, 0, 0)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel3)
                    .addComponent(jRadioButton5)
                    .addComponent(jRadioButton6)
                    .addComponent(jRadioButton7)
                    .addComponent(jRadioButton8))
                .addGap(0, 0, 0)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel4)
                    .addComponent(jRadioButton9)
                    .addComponent(jRadioButton10)
                    .addComponent(jRadioButton11)
                    .addComponent(jRadioButton12))
                .addGap(0, 0, 0)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel8)
                            .addComponent(jLabelv1)
                            .addComponent(jLabelv2)
                            .addComponent(jLabelv3)
                            .addComponent(jLabelv4))
                        .addGap(0, 0, 0)
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jCheckBoxV1)
                            .addComponent(jCheckBoxV2)
                            .addComponent(jCheckBoxV3)
                            .addComponent(jCheckBoxV4)
                            .addComponent(jLabel9)))
                    .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                        .addComponent(jButton2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jButton7, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 7, Short.MAX_VALUE)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jComboBox1, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextFieldADSR1, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel5))
                .addGap(4, 4, 4)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jComboBox2, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextFieldADSR2, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel6))
                .addGap(4, 4, 4)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jComboBox3, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextFieldADSR3, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel10))
                .addGap(6, 6, 6)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel7)
                    .addComponent(jTextFieldTWANG1, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(4, 4, 4)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel11)
                    .addComponent(jTextFieldTWANG2, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(4, 4, 4)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel12)
                    .addComponent(jTextFieldTWANG3, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jCheckBoxIndirectOutput))
                .addGap(4, 4, 4))
        );

        javax.swing.GroupLayout jPanel2Layout = new javax.swing.GroupLayout(jPanel2);
        jPanel2.setLayout(jPanel2Layout);
        jPanel2Layout.setHorizontalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(cSATablePanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        jPanel2Layout.setVerticalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(cSATablePanel1, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, 273, Short.MAX_VALUE)
        );

        jLabel14.setText("load mod file");

        jButtonLoad.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/page_go.png"))); // NOI18N
        jButtonLoad.setToolTipText("load YM");
        jButtonLoad.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonLoad.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonLoadActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel3Layout = new javax.swing.GroupLayout(jPanel3);
        jPanel3.setLayout(jPanel3Layout);
        jPanel3Layout.setHorizontalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addComponent(jLabel14)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonLoad)
                .addGap(0, 0, Short.MAX_VALUE))
        );
        jPanel3Layout.setVerticalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jButtonLoad)
                    .addComponent(jLabel14))
                .addGap(0, 3, Short.MAX_VALUE))
        );

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                .addComponent(jButton6, javax.swing.GroupLayout.PREFERRED_SIZE, 84, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(jButtonCancel)
                .addGap(34, 34, 34)
                .addComponent(jButtonCreate))
            .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addComponent(jPanel2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addComponent(jPanel3, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addComponent(iBXMPlayerJPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addComponent(jPanel3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(iBXMPlayerJPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButtonCreate, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButtonCancel, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButton6, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(2, 2, 2))
        );
    }// </editor-fold>//GEN-END:initComponents

    private void jButtonCancelActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonCancelActionPerformed
        iBXMPlayerJPanel1.stop();     
       ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).removePanel(this);
        if (tinyLog instanceof VediPanel)
        {
            ((VediPanel)tinyLog).returnFromModPanel(false);
        }
    }//GEN-LAST:event_jButtonCancelActionPerformed

    
    private void jButtonCreateActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonCreateActionPerformed
        iBXMPlayerJPanel1.stop();
        Mod2Vectrex.DEFAULT_SPEED = (byte) DASM6809.toNumber(jTextField1.getText());
        
        createSource();
    }//GEN-LAST:event_jButtonCreateActionPerformed

    private void jButton6ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton6ActionPerformed

        QuickHelpModal.showHelpHtmlFile(Global.mainPathPrefix+"help"+File.separator+"mod.html");
    }//GEN-LAST:event_jButton6ActionPerformed

    private void jTextFieldADSR1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldADSR1ActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jTextFieldADSR1ActionPerformed

    private void jCheckBoxV1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxV1ActionPerformed
        updateVoicePlay();
    }//GEN-LAST:event_jCheckBoxV1ActionPerformed

    private void jCheckBoxV2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxV2ActionPerformed
        updateVoicePlay();
    }//GEN-LAST:event_jCheckBoxV2ActionPerformed

    private void jCheckBoxV3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxV3ActionPerformed
        updateVoicePlay();
    }//GEN-LAST:event_jCheckBoxV3ActionPerformed

    private void jCheckBoxV4ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxV4ActionPerformed
        updateVoicePlay();
    }//GEN-LAST:event_jCheckBoxV4ActionPerformed

    private void jCheckBoxIndirectOutputActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxIndirectOutputActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jCheckBoxIndirectOutputActionPerformed

    private void jTextFieldADSR2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldADSR2ActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jTextFieldADSR2ActionPerformed

    private void jTextFieldADSR3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldADSR3ActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jTextFieldADSR3ActionPerformed

    private void jButton7ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton7ActionPerformed
        InstrumentEditor.showInstrumentPanelNoModal(tinyLog);
        // TODO add your handling code here:
    }//GEN-LAST:event_jButton7ActionPerformed

    private void jButton2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton2ActionPerformed
        initInstrumentCombo();
    }//GEN-LAST:event_jButton2ActionPerformed

    private void jComboBox1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBox1ActionPerformed
        if (mClassSetting>0) return;
        if (jComboBox1.getSelectedIndex()==-1) return;
        String selname = jComboBox1.getSelectedItem().toString();
        ArrayList<String> list = Instrument.getInstrumentList();
        for (String name: list)
        {
            String comboName = de.malban.util.UtilityString.replace(name.toLowerCase(), ".xml", "");
            if (selname.equals(comboName))
            {
                Instrument ins = Instrument.getInstrument(comboName);
                jTextFieldADSR1.setText(ins.getADSRAsString());
                jTextFieldTWANG1.setText(ins.getTWANGAsString());
                return;
            }
        }
    }//GEN-LAST:event_jComboBox1ActionPerformed

    private void jComboBox2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBox2ActionPerformed
        if (mClassSetting>0) return;
        if (jComboBox2.getSelectedIndex()==-1) return;
        String selname = jComboBox2.getSelectedItem().toString();
        ArrayList<String> list = Instrument.getInstrumentList();
        for (String name: list)
        {
            String comboName = de.malban.util.UtilityString.replace(name.toLowerCase(), ".xml", "");
            if (selname.equals(comboName))
            {
                Instrument ins = Instrument.getInstrument(comboName);
                jTextFieldADSR2.setText(ins.getADSRAsString());
                jTextFieldTWANG2.setText(ins.getTWANGAsString());
                return;
            }
        }
    }//GEN-LAST:event_jComboBox2ActionPerformed

    private void jComboBox3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBox3ActionPerformed
        if (mClassSetting>0) return;
        if (jComboBox3.getSelectedIndex()==-1) return;
        String selname = jComboBox3.getSelectedItem().toString();
        ArrayList<String> list = Instrument.getInstrumentList();
        for (String name: list)
        {
            String comboName = de.malban.util.UtilityString.replace(name.toLowerCase(), ".xml", "");
            if (selname.equals(comboName))
            {
                Instrument ins = Instrument.getInstrument(comboName);
                jTextFieldADSR3.setText(ins.getADSRAsString());
                jTextFieldTWANG3.setText(ins.getTWANGAsString());
                return;
            }
        }
    }//GEN-LAST:event_jComboBox3ActionPerformed

    private void jTextField1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextField1ActionPerformed
            // TODO add your handling code here:
    }//GEN-LAST:event_jTextField1ActionPerformed

    String lastImagePath = Global.mainPathPrefix;
    private void jButtonLoadActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonLoadActionPerformed

        InternalFrameFileChoser fc = new de.malban.gui.dialogs.InternalFrameFileChoser();
        fc.setMultiSelectionEnabled(true);
        if (lastImagePath.length()==0)
        {
        }
        else
        {
            fc.setCurrentDirectory(new java.io.File(lastImagePath));
        }
        FileNameExtensionFilter  filter = new  FileNameExtensionFilter("Mod-Files", "mod");
        fc.setFileFilter(filter);
        int r = fc.showOpenDialog(Configuration.getConfiguration().getMainFrame());
        if (r != InternalFrameFileChoser.APPROVE_OPTION) return;
        File[] files = fc.getSelectedFiles();
        String fullPath;
        if ((files == null) || (files.length == 1))
        {
            fullPath = fc.getSelectedFile().getAbsolutePath();
        }
        else // add multiple images
        {
            fullPath = files[0].getAbsolutePath();
        }
        lastImagePath =fullPath;
        initModFile(fullPath);
    }//GEN-LAST:event_jButtonLoadActionPerformed

    boolean[] voicePlay = new boolean[4];
    void updateVoicePlay()
    {
        voicePlay[0] = jCheckBoxV1.isSelected();
        voicePlay[1] = jCheckBoxV2.isSelected();
        voicePlay[2] = jCheckBoxV3.isSelected();
        voicePlay[3] = jCheckBoxV4.isSelected();
        iBXMPlayerJPanel1.setVoicePlay(voicePlay);
    }
    

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.ButtonGroup buttonGroup1;
    private javax.swing.ButtonGroup buttonGroup2;
    private javax.swing.ButtonGroup buttonGroup3;
    private de.malban.gui.components.CSATablePanel cSATablePanel1;
    private de.malban.vide.vedi.sound.ibxm.IBXMPlayerJPanel iBXMPlayerJPanel1;
    private javax.swing.JButton jButton2;
    private javax.swing.JButton jButton6;
    private javax.swing.JButton jButton7;
    private javax.swing.JButton jButtonCancel;
    private javax.swing.JButton jButtonCreate;
    private javax.swing.JButton jButtonLoad;
    private javax.swing.JCheckBox jCheckBoxIndirectOutput;
    private javax.swing.JCheckBox jCheckBoxV1;
    private javax.swing.JCheckBox jCheckBoxV2;
    private javax.swing.JCheckBox jCheckBoxV3;
    private javax.swing.JCheckBox jCheckBoxV4;
    private javax.swing.JComboBox jComboBox1;
    private javax.swing.JComboBox jComboBox2;
    private javax.swing.JComboBox jComboBox3;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel10;
    private javax.swing.JLabel jLabel11;
    private javax.swing.JLabel jLabel12;
    private javax.swing.JLabel jLabel13;
    private javax.swing.JLabel jLabel14;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JLabel jLabel6;
    private javax.swing.JLabel jLabel7;
    private javax.swing.JLabel jLabel8;
    private javax.swing.JLabel jLabel9;
    private javax.swing.JLabel jLabelv1;
    private javax.swing.JLabel jLabelv2;
    private javax.swing.JLabel jLabelv3;
    private javax.swing.JLabel jLabelv4;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JPanel jPanel3;
    private javax.swing.JRadioButton jRadioButton1;
    private javax.swing.JRadioButton jRadioButton10;
    private javax.swing.JRadioButton jRadioButton11;
    private javax.swing.JRadioButton jRadioButton12;
    private javax.swing.JRadioButton jRadioButton2;
    private javax.swing.JRadioButton jRadioButton3;
    private javax.swing.JRadioButton jRadioButton4;
    private javax.swing.JRadioButton jRadioButton5;
    private javax.swing.JRadioButton jRadioButton6;
    private javax.swing.JRadioButton jRadioButton7;
    private javax.swing.JRadioButton jRadioButton8;
    private javax.swing.JRadioButton jRadioButton9;
    private javax.swing.JTextField jTextField1;
    private javax.swing.JTextField jTextFieldADSR1;
    private javax.swing.JTextField jTextFieldADSR2;
    private javax.swing.JTextField jTextFieldADSR3;
    private javax.swing.JTextField jTextFieldTWANG1;
    private javax.swing.JTextField jTextFieldTWANG2;
    private javax.swing.JTextField jTextFieldTWANG3;
    // End of variables declaration//GEN-END:variables

    JInternalFrame modelDialog;
    public static boolean showModPanel(String fileName, TinyLogInterface tl)
    {
        JFrame frame = Configuration.getConfiguration().getMainFrame();
        ModJPanel panel = new ModJPanel(fileName, tl);
        
        ArrayList<JButton> eb= new ArrayList<JButton>();
        eb.add(panel.jButtonCreate);
        eb.add(panel.jButtonCancel);
        ModalInternalFrame modal = new ModalInternalFrame("Mod 2 Vectrex", frame.getRootPane(), frame, panel,null, null , eb);
        
        modal.setResizable(true);
        panel.modelDialog = modal;
        modal.setVisible(true);

        String result = modal.getNamedExit();
        if (result.equals("create"))
        {
            return true;
        }
        
        return false;
    }        
    public static void showModPanelNoModal(String fileName, TinyLogInterface tl)
    {
        showModPanelNoModal( fileName,  tl, false);
    }        
    boolean standalone = false;
    public static void showModPanelNoModal(String fileName, TinyLogInterface tl, boolean sa)
    {
        JFrame frame = Configuration.getConfiguration().getMainFrame();
        ModJPanel panel = new ModJPanel(fileName, tl);
        panel.standalone = sa;
        ArrayList<JButton> eb= new ArrayList<JButton>();
        eb.add(panel.jButtonCreate);
        eb.add(panel.jButtonCancel);
        ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).addAsWindow(panel,  800, 800, "Mod2Vectrex");
    }        
    void createSource()
    {
        
        if (standalone)
        {
            // ask where to save!
            InternalFrameFileChoser fc = new de.malban.gui.dialogs.InternalFrameFileChoser();
            fc.setDialogTitle("Select save directory");
            fc.setCurrentDirectory(new java.io.File(Global.mainPathPrefix));
            fc.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);

            int r = fc.showOpenDialog(Configuration.getConfiguration().getMainFrame());
            if (r != InternalFrameFileChoser.APPROVE_OPTION) return;
            String lastPath = fc.getSelectedFile().getAbsolutePath();

            Path p = Paths.get(lastPath);
            String newName = p.toString();
            if (!newName.endsWith(File.separator)) newName+=File.separator;
            pathOnly = newName;
        }
        
        String nameOnly = Paths.get(currentModFile).getFileName().toString();
        int li = nameOnly.lastIndexOf(".");
        if (li>=0) 
            nameOnly = nameOnly.substring(0,li);
       
        Mod2Vectrex m2v = new Mod2Vectrex( );
        
        
        int v0=0;
        int v1=1;
        int v2=2;
        if (jRadioButton1.isSelected()) v0=0; else if (jRadioButton2.isSelected()) v0=1;else if (jRadioButton3.isSelected()) v0=2;else v0=3;
        if (jRadioButton5.isSelected()) v1=0; else if (jRadioButton6.isSelected()) v1=1;else if (jRadioButton7.isSelected()) v1=2;else v1=3;
        if (jRadioButton9.isSelected()) v2=0; else if (jRadioButton10.isSelected()) v2=1;else if (jRadioButton11.isSelected()) v2=2;else v2=3;
        
        m2v.vectrexModMapping[0] = v0;
        m2v.vectrexModMapping[1] = v1;
        m2v.vectrexModMapping[2] = v2;
        
        
        String currentOut = pathOnly+Paths.get(currentModFile).getFileName().toString();
        
        String result = m2v.doIt(currentModFile, currentOut, instrumentHandles, jTextFieldADSR1.getText(),jTextFieldADSR2.getText(),jTextFieldADSR3.getText(), jTextFieldTWANG1.getText(),jTextFieldTWANG2.getText(),jTextFieldTWANG3.getText(), jCheckBoxIndirectOutput.isSelected());
        tinyLog.printMessage(result);

        Path include = Paths.get(Global.mainPathPrefix, "template", "VECTREX.I");
        de.malban.util.UtilityFiles.copyOneFile(include.toString(), pathOnly+ "VECTREX.I");
        Path digital = Paths.get(Global.mainPathPrefix, "template", "modPlayer.i");
        de.malban.util.UtilityFiles.copyOneFile(digital.toString(), pathOnly+ "modPlayer.i");

        Path template = Paths.get(Global.mainPathPrefix, "template", "modPlayMain.template");
        String exampleMain = de.malban.util.UtilityString.readTextFileToOneString(new File(template.toString()));

        exampleMain = de.malban.util.UtilityString.replace(exampleMain,"#MOD_NAME#", ""+nameOnly.toUpperCase());
        exampleMain = de.malban.util.UtilityString.replace(exampleMain,"#MOD_NAME_ASM#", ""+nameOnly+".asm");
        de.malban.util.UtilityFiles.createTextFile(pathOnly+nameOnly+"Main.asm", exampleMain);    
        
      // ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).removePanel(this);
        if (tinyLog instanceof VediPanel)
        {
            ((VediPanel)tinyLog).returnFromModPanel(true);
        }
        if (standalone)
        {
            VediPanel.openInVedi(pathOnly+nameOnly+"Main.asm");
        }
    }

    
    void initInstrumentCombo()
    {
        ArrayList<String> list = Instrument.getInstrumentList();
        mClassSetting++;
        jComboBox1.removeAllItems();
        jComboBox2.removeAllItems();
        jComboBox3.removeAllItems();
        int selIndex1 = -1;
        int selIndex2 = -1;
        int selIndex3 = -1;
        int index = 0;
        String nameSel1="";
        if (jComboBox1.getSelectedIndex()!=-1)
            nameSel1 = jComboBox1.getSelectedItem().toString();
        String nameSel2="";
        if (jComboBox2.getSelectedIndex()!=-1)
            nameSel2 = jComboBox2.getSelectedItem().toString();
        String nameSel3="";
        if (jComboBox3.getSelectedIndex()!=-1)
            nameSel3 = jComboBox3.getSelectedItem().toString();
        for (String name: list)
        {
            String comboName = de.malban.util.UtilityString.replace(name.toLowerCase(), ".xml", "");
            jComboBox1.addItem(comboName);
            if (comboName.equals(nameSel1.toLowerCase()))
                selIndex1 = index; 
            jComboBox2.addItem(comboName);
            if (comboName.equals(nameSel2.toLowerCase()))
                selIndex2 = index; 
            jComboBox3.addItem(comboName);
            if (comboName.equals(nameSel3.toLowerCase()))
                selIndex3 = index; 
            index++;
        }
        jComboBox1.setSelectedIndex(selIndex1);
        jComboBox2.setSelectedIndex(selIndex2);
        jComboBox3.setSelectedIndex(selIndex3);
        mClassSetting--;
        
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
//        jTable1.setRowHeight(rowHeight);
        cSATablePanel1.setRowHeight(fontSize+1);
        cSATablePanel1.getTable().setFont(new java.awt.Font("Courier New", 1, fontSize-1));
        cSATablePanel1.setColumnWidth(0, 5);
        cSATablePanel1.setColumnWidth(1, 100);
        cSATablePanel1.setColumnWidth(2, 10);
        cSATablePanel1.setColumnWidth(3, 160);
        cSATablePanel1.setColumnWidth(4, 60);
        cSATablePanel1.setColumnWidth(5, 5);
    }
    public void deIconified()  {}
}
