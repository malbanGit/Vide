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
import de.malban.gui.components.CSATableModel;
import de.malban.gui.components.CSAView;
import de.malban.gui.components.DoubleClickAction;
import de.malban.gui.components.ModalInternalFrame;
import de.malban.gui.dialogs.QuickHelpModal;
import de.malban.gui.dialogs.ShowErrorDialog;
import de.malban.gui.panels.LogPanel;
import de.malban.sound.tinysound.Sound;
import de.malban.sound.tinysound.TinySound;
import de.malban.vide.dissy.DASM6809;
import de.malban.vide.vedi.VediPanel;
import static de.malban.vide.vedi.sound.ModJPanel.VectrexInstrument.*;
import de.malban.vide.vedi.sound.ibxm.Sample;
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
import javax.swing.JFrame;
import javax.swing.JInternalFrame;
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

    ArrayList<InstrumentHandle> instrumentHandles = new ArrayList<>();
    static ArrayList<VectrexInstrument> vectrexInstruments= new ArrayList<>();
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
    /**
     * Creates new form SampleJPanel
     */
    public ModJPanel(String filename, TinyLogInterface tl) 
    {
        initComponents();
        tinyLog = tl;
        // check if is a file or a dir
        File file = new File(filename);
        if (file.isDirectory())
        {
            pathOnly = file.toString();
        }
        else
        {
            pathOnly = file.getParent();
            currentModFile = filename;
        }
        iBXMPlayerJPanel1.setModfile(currentModFile);
        cSATablePanel1.setTableStyleSwitchingEnabled(false);

        
        JComboBox comboBox = new JComboBox(vectrexInstruments.toArray());
        TableCellEditor editor = new DefaultCellEditor(comboBox);
        
        Vector<String> in = iBXMPlayerJPanel1.getInstruments();
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
        updateVoicePlay();
        
        cSATablePanel1.getTable().setFont(new java.awt.Font("Courier New", 1, 10));
        cSATablePanel1.setColumnWidth(0, 5);
        cSATablePanel1.setColumnWidth(1, 100);
        cSATablePanel1.setColumnWidth(2, 10);
        cSATablePanel1.setColumnWidth(3, 160);
        cSATablePanel1.setColumnWidth(4, 60);
        cSATablePanel1.setColumnWidth(5, 5);
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
        jTextField1 = new javax.swing.JTextField();
        jLabel7 = new javax.swing.JLabel();
        jTextField3 = new javax.swing.JTextField();
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
        jPanel2 = new javax.swing.JPanel();
        cSATablePanel1 = new de.malban.gui.components.CSATablePanel();

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

        jLabel5.setText("ADSR (32 nibble):");

        jTextField1.setFont(new java.awt.Font("Courier New", 1, 12)); // NOI18N
        jTextField1.setText("$ff,$ed,$cb,$a9,$87,$65,$43,$21,$00,$00,$00,$00,$00,$00,$00,$00");
        jTextField1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField1ActionPerformed(evt);
            }
        });

        jLabel7.setText("TWANG (8 byte):");

        jTextField3.setFont(new java.awt.Font("Courier New", 1, 12)); // NOI18N
        jTextField3.setText("$ff,$ff,$00,$00,$00,$00,$00,$00");

        jLabel8.setText("voice usages:");

        jLabelv1.setText("0");

        jLabelv2.setText("0");

        jLabelv3.setText("0");

        jLabelv4.setText("0");

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

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel1)
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addComponent(jLabel2)
                        .addGap(18, 18, 18)
                        .addComponent(jRadioButton1)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jRadioButton2)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jRadioButton3)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jRadioButton4))
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addComponent(jLabel3)
                        .addGap(18, 18, 18)
                        .addComponent(jRadioButton5)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jRadioButton6)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jRadioButton7)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jRadioButton8))
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel4)
                            .addComponent(jLabel8)
                            .addComponent(jLabel9))
                        .addGap(18, 18, 18)
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel1Layout.createSequentialGroup()
                                .addComponent(jRadioButton9)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(jRadioButton10)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jRadioButton11)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jRadioButton12))
                            .addGroup(jPanel1Layout.createSequentialGroup()
                                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jLabelv1, javax.swing.GroupLayout.PREFERRED_SIZE, 44, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jCheckBoxV1))
                                .addGap(18, 18, 18)
                                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jLabelv2, javax.swing.GroupLayout.PREFERRED_SIZE, 44, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jCheckBoxV2))
                                .addGap(18, 18, 18)
                                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jLabelv3, javax.swing.GroupLayout.PREFERRED_SIZE, 44, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jCheckBoxV3))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jCheckBoxV4)
                                    .addComponent(jLabelv4, javax.swing.GroupLayout.PREFERRED_SIZE, 44, javax.swing.GroupLayout.PREFERRED_SIZE)))))
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel7)
                            .addComponent(jLabel5, javax.swing.GroupLayout.PREFERRED_SIZE, 117, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jTextField1, javax.swing.GroupLayout.PREFERRED_SIZE, 484, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGroup(jPanel1Layout.createSequentialGroup()
                                .addComponent(jTextField3, javax.swing.GroupLayout.PREFERRED_SIZE, 248, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 216, Short.MAX_VALUE)
                                .addComponent(jCheckBoxIndirectOutput)))))
                .addGap(24, 24, 24))
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addComponent(jLabel1)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel2)
                    .addComponent(jRadioButton1)
                    .addComponent(jRadioButton2)
                    .addComponent(jRadioButton3)
                    .addComponent(jRadioButton4))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel3)
                    .addComponent(jRadioButton5)
                    .addComponent(jRadioButton6)
                    .addComponent(jRadioButton7)
                    .addComponent(jRadioButton8))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel4)
                    .addComponent(jRadioButton9)
                    .addComponent(jRadioButton10)
                    .addComponent(jRadioButton11)
                    .addComponent(jRadioButton12))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel8)
                    .addComponent(jLabelv1)
                    .addComponent(jLabelv2)
                    .addComponent(jLabelv3)
                    .addComponent(jLabelv4))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jCheckBoxV1)
                    .addComponent(jCheckBoxV2)
                    .addComponent(jCheckBoxV3)
                    .addComponent(jCheckBoxV4)
                    .addComponent(jLabel9))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel5)
                    .addComponent(jTextField1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(4, 4, 4)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel7)
                    .addComponent(jTextField3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jCheckBoxIndirectOutput))
                .addGap(0, 0, 0))
        );

        javax.swing.GroupLayout jPanel2Layout = new javax.swing.GroupLayout(jPanel2);
        jPanel2.setLayout(jPanel2Layout);
        jPanel2Layout.setHorizontalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(cSATablePanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        jPanel2Layout.setVerticalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(cSATablePanel1, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, 300, Short.MAX_VALUE)
        );

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(iBXMPlayerJPanel1, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                .addComponent(jButton6, javax.swing.GroupLayout.PREFERRED_SIZE, 68, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(jButtonCancel)
                .addGap(66, 66, 66)
                .addComponent(jButtonCreate, javax.swing.GroupLayout.PREFERRED_SIZE, 110, javax.swing.GroupLayout.PREFERRED_SIZE))
            .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addComponent(jPanel2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addComponent(iBXMPlayerJPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, 107, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButtonCreate)
                    .addComponent(jButtonCancel)
                    .addComponent(jButton6, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(18, 18, 18))
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
        
        
        createSource();
    }//GEN-LAST:event_jButtonCreateActionPerformed

    private void jButton6ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton6ActionPerformed

        QuickHelpModal.showHelpHtmlFile("documents"+File.separator+"help"+File.separator+"mod.html");
    }//GEN-LAST:event_jButton6ActionPerformed

    private void jTextField1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextField1ActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jTextField1ActionPerformed

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
    private javax.swing.JButton jButton6;
    private javax.swing.JButton jButtonCancel;
    private javax.swing.JButton jButtonCreate;
    private javax.swing.JCheckBox jCheckBoxIndirectOutput;
    private javax.swing.JCheckBox jCheckBoxV1;
    private javax.swing.JCheckBox jCheckBoxV2;
    private javax.swing.JCheckBox jCheckBoxV3;
    private javax.swing.JCheckBox jCheckBoxV4;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JLabel jLabel7;
    private javax.swing.JLabel jLabel8;
    private javax.swing.JLabel jLabel9;
    private javax.swing.JLabel jLabelv1;
    private javax.swing.JLabel jLabelv2;
    private javax.swing.JLabel jLabelv3;
    private javax.swing.JLabel jLabelv4;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel2;
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
    private javax.swing.JTextField jTextField3;
    // End of variables declaration//GEN-END:variables

    JInternalFrame modelDialog;
    public static boolean showModPanel(String fileName, TinyLogInterface tl)
    {
        JFrame frame = Configuration.getConfiguration().getMainFrame();
        ModJPanel panel = new ModJPanel(fileName, tl);
        
        ArrayList<JButton> eb= new ArrayList<>();
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
        JFrame frame = Configuration.getConfiguration().getMainFrame();
        ModJPanel panel = new ModJPanel(fileName, tl);
        
        ArrayList<JButton> eb= new ArrayList<>();
        eb.add(panel.jButtonCreate);
        eb.add(panel.jButtonCancel);
        
       ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).addPanel(panel);
       ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).windowMe(panel, 800, 800, panel.getMenuItem().getText());
    }        
    void createSource()
    {
        
        String pathOnly = Paths.get(currentModFile).getParent().toString();
        if (pathOnly.length()!=0)pathOnly+=File.separator;
        
        String nameOnly = Paths.get(currentModFile).getFileName().toString();;
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
        
        String result = m2v.doIt(currentModFile, instrumentHandles, jTextField1.getText(), jTextField3.getText(), jCheckBoxIndirectOutput.isSelected());
        tinyLog.printMessage(result);

        Path include = Paths.get(".", "template", "VECTREX.I");
        de.malban.util.UtilityFiles.copyOneFile(include.toString(), pathOnly+ "VECTREX.I");
        Path digital = Paths.get(".", "template", "modPlayer.i");
        de.malban.util.UtilityFiles.copyOneFile(digital.toString(), pathOnly+ "modPlayer.i");

        Path template = Paths.get(".", "template", "modPlayMain.template");
        String exampleMain = de.malban.util.UtilityString.readTextFileToOneString(new File(template.toString()));

        exampleMain = de.malban.util.UtilityString.replace(exampleMain,"#MOD_NAME#", ""+nameOnly.toUpperCase());
        exampleMain = de.malban.util.UtilityString.replace(exampleMain,"#MOD_NAME_ASM#", ""+nameOnly+".asm");
        de.malban.util.UtilityFiles.createTextFile(pathOnly+nameOnly+"Main.asm", exampleMain);    
        
      // ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).removePanel(this);
        if (tinyLog instanceof VediPanel)
        {
            ((VediPanel)tinyLog).returnFromModPanel(true);
        }
    }

    

}
