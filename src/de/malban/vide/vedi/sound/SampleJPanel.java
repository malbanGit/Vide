/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vedi.sound;

import de.malban.config.Configuration;
import de.malban.event.EditMouseEvent;
import de.malban.graphics.MouseMovedListener;
import de.malban.graphics.MousePressedListener;
import de.malban.gui.components.ModalInternalFrame;
import de.malban.gui.dialogs.InternalFrameFileChoser;
import de.malban.gui.dialogs.QuickHelpModal;
import de.malban.gui.dialogs.ShowErrorDialog;
import de.malban.gui.panels.LogPanel;
import static de.malban.gui.panels.LogPanel.INFO;
import static de.malban.gui.panels.LogPanel.WARN;
import de.malban.sound.tinysound.Sound;
import de.malban.sound.tinysound.TinySound;
import de.malban.sound.tinysound.internal.ByteList;
import de.malban.sound.tinysound.internal.MemSound;
import de.malban.sound.tinysound.internal.PositionListener;
import de.malban.vide.dissy.DASM6809;
import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import javax.sound.sampled.AudioFileFormat;
import javax.sound.sampled.AudioFormat;
import javax.sound.sampled.AudioFormat.Encoding;
import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.DataLine;
import javax.sound.sampled.Line;
import javax.sound.sampled.LineUnavailableException;
import javax.sound.sampled.Mixer;
import javax.sound.sampled.SourceDataLine;
import javax.sound.sampled.TargetDataLine;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JInternalFrame;
import javax.swing.SwingUtilities;
import javax.swing.ToolTipManager;
import javax.swing.filechooser.FileNameExtensionFilter;

/**
 * // see: http://www.jsresources.org/examples/AudioRecorder.html
 * @author malban
 */
public class SampleJPanel extends javax.swing.JPanel implements PositionListener, MousePressedListener, MouseMovedListener {

    public static final String TMP_FILENAME = "tmp"+File.separator+"sampleRecording.wav";
    
    LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
    String currentSampleFile = "";
    MemSound sound=null;
    TargetDataLine  targetDataLine = null;
    boolean targetLineOk = false;
    Recorder recorder = null;
    ArrayList<MyMixer> targetMixers = new ArrayList<MyMixer>();
    class MyMixer
    {
        Mixer.Info info;
        Mixer mixer;
        public MyMixer(Mixer.Info i, Mixer m)
        {
            info = i;
            mixer = m;
        }
        @Override
        public String toString()
        {
            return info.getName();
        }
    }

    int rangeStartPos = -1;
    int rangeEndPos = -1;
    boolean rangeWasSet = false;
    
    BufferedImage org = null; // allays the complete smaple image, corresponding to size of singleimagepanel
    BufferedImage image = null; // allays the complete smaple image, corresponding to size of singleimagepanel, includes ranges
    BufferedImage pos = null; // 'copy' of image, but has a line for the position
    int positionDeltaMin = 0;
    int lastPostion = 0;
    int lastDrawnPosition = 0;
    
    
    String pathOnly = "";
    /**
     * Creates new form SampleJPanel
     */
    public SampleJPanel(String filename) {
        initComponents();
        fillDeviceList();
        checkTargetLine();

        
        // check if is a file or a dir
        File file = new File(filename);
        if (file.isDirectory())
        {
            pathOnly = file.toString();
        }
        else
        {
            pathOnly = file.getParent();
            currentSampleFile = filename;
        }
        
        // for debugging only
        if (currentSampleFile.length()==0)
            currentSampleFile = TMP_FILENAME;
    
        
        if (currentSampleFile.length()!=0)
            setSample(currentSampleFile);
        paintSamples();
        singleImagePanel1.addClickListener(this);
        singleImagePanel1.addMouseMovedListener(this);

        
        singleImagePanel1.setCrossDrawn(false);
        singleImagePanel1.setSelectionDrawn(false);
        
        
    }
    public void pressed(EditMouseEvent evt)
    {
        if (sound == null) return;
        rangeStartPos = evt.evt.getX();
        rangeEndPos = -1;
        setRanges();
    }
    
   // fuck dragging we take left and right mouse button
    public void moved(EditMouseEvent evt)
    {
        if (sound == null) return;
        if (evt.dragging)
        {
            rangeEndPos = evt.evt.getX();
            setRanges();
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

        singleImagePanel1 = new de.malban.graphics.SingleImagePanel();
        jButton1 = new javax.swing.JButton();
        jButtonCreate = new javax.swing.JButton();
        jButtonSaveOrgSample = new javax.swing.JButton();
        jSlider1 = new javax.swing.JSlider();
        jButtonCancel = new javax.swing.JButton();
        jPanel3 = new javax.swing.JPanel();
        jButtonRecord = new javax.swing.JButton();
        jButtonPlaySample = new javax.swing.JButton();
        jButtonStop2 = new javax.swing.JButton();
        jButtonCut = new javax.swing.JButton();
        jPanel2 = new javax.swing.JPanel();
        jLabel8 = new javax.swing.JLabel();
        jLabel9 = new javax.swing.JLabel();
        jLabel10 = new javax.swing.JLabel();
        jLabel11 = new javax.swing.JLabel();
        jTextFieldFrameSize = new javax.swing.JTextField();
        jLabel12 = new javax.swing.JLabel();
        jLabel13 = new javax.swing.JLabel();
        jTextFieldFrameRate = new javax.swing.JTextField();
        jLabel14 = new javax.swing.JLabel();
        jComboBoxEncoding = new javax.swing.JComboBox();
        jComboBoxBit = new javax.swing.JComboBox();
        jComboBoxChannels = new javax.swing.JComboBox();
        jComboBoxEndian = new javax.swing.JComboBox();
        jComboBoxSampleRate = new javax.swing.JComboBox();
        jLabel16 = new javax.swing.JLabel();
        jComboBoxAudioDevices = new javax.swing.JComboBox();
        jLabel17 = new javax.swing.JLabel();
        jButtonStop3 = new javax.swing.JButton();
        jTextFieldSizeInternal = new javax.swing.JTextField();
        jLabel20 = new javax.swing.JLabel();
        jComboBoxNormalize = new javax.swing.JComboBox();
        jPanel4 = new javax.swing.JPanel();
        jButtonPlayVectrex = new javax.swing.JButton();
        jPanel1 = new javax.swing.JPanel();
        jLabel1 = new javax.swing.JLabel();
        jTextFieldSampleRate = new javax.swing.JTextField();
        jLabel2 = new javax.swing.JLabel();
        jLabel3 = new javax.swing.JLabel();
        jLabel4 = new javax.swing.JLabel();
        jTextField5 = new javax.swing.JTextField();
        jLabel5 = new javax.swing.JLabel();
        jLabel6 = new javax.swing.JLabel();
        jTextField6 = new javax.swing.JTextField();
        jLabel7 = new javax.swing.JLabel();
        jComboBox1 = new javax.swing.JComboBox();
        jComboBox2 = new javax.swing.JComboBox();
        jComboBox3 = new javax.swing.JComboBox();
        jComboBox4 = new javax.swing.JComboBox();
        jLabel18 = new javax.swing.JLabel();
        jComboBoxAudioDevices1 = new javax.swing.JComboBox();
        jButton5 = new javax.swing.JButton();
        jButton7 = new javax.swing.JButton();
        jLabel19 = new javax.swing.JLabel();
        jTextFieldVectrexSize = new javax.swing.JTextField();
        jCheckBoxReverse = new javax.swing.JCheckBox();
        jButton6 = new javax.swing.JButton();

        singleImagePanel1.addComponentListener(new java.awt.event.ComponentAdapter() {
            public void componentResized(java.awt.event.ComponentEvent evt) {
                singleImagePanel1ComponentResized(evt);
            }
        });

        javax.swing.GroupLayout singleImagePanel1Layout = new javax.swing.GroupLayout(singleImagePanel1);
        singleImagePanel1.setLayout(singleImagePanel1Layout);
        singleImagePanel1Layout.setHorizontalGroup(
            singleImagePanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 0, Short.MAX_VALUE)
        );
        singleImagePanel1Layout.setVerticalGroup(
            singleImagePanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 207, Short.MAX_VALUE)
        );

        jButton1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/page_go.png"))); // NOI18N
        jButton1.setText("load a sample");
        jButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton1ActionPerformed(evt);
            }
        });

        jButtonCreate.setText("create source");
        jButtonCreate.setName("create"); // NOI18N
        jButtonCreate.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonCreateActionPerformed(evt);
            }
        });

        jButtonSaveOrgSample.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/page_save.png"))); // NOI18N
        jButtonSaveOrgSample.setText("save sample as");
        jButtonSaveOrgSample.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSaveOrgSampleActionPerformed(evt);
            }
        });

        jButtonCancel.setText("cancel");
        jButtonCancel.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonCancelActionPerformed(evt);
            }
        });

        jPanel3.setBorder(javax.swing.BorderFactory.createTitledBorder("Source"));

        jButtonRecord.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/control_record_blue.png"))); // NOI18N
        jButtonRecord.setToolTipText("Record a sample (microphone)");
        jButtonRecord.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonRecord.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonRecordActionPerformed(evt);
            }
        });

        jButtonPlaySample.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/control_play_blue.png"))); // NOI18N
        jButtonPlaySample.setToolTipText("Play current sample!");
        jButtonPlaySample.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonPlaySample.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonPlaySampleActionPerformed(evt);
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

        jButtonCut.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/cut.png"))); // NOI18N
        jButtonCut.setToolTipText("Cut current seelction!");
        jButtonCut.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonCut.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonCutActionPerformed(evt);
            }
        });

        jPanel2.setBorder(javax.swing.BorderFactory.createTitledBorder("Input Format"));

        jLabel8.setText("encoding");

        jLabel9.setText("sample rate");

        jLabel10.setText("bit ");

        jLabel11.setText("channels");

        jTextFieldFrameSize.setEditable(false);
        jTextFieldFrameSize.setText("1");

        jLabel12.setText("frame size");

        jLabel13.setText("frame rate");

        jTextFieldFrameRate.setEditable(false);
        jTextFieldFrameRate.setText("22050");

        jLabel14.setText("endian");

        jComboBoxEncoding.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "PCM_SIGNED", "PCM_UNSIGNED" }));
        jComboBoxEncoding.setSelectedIndex(1);
        jComboBoxEncoding.setEnabled(false);
        jComboBoxEncoding.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBoxEncodingActionPerformed(evt);
            }
        });

        jComboBoxBit.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "8 bit", "16 bit", "24 bit", "32 bit" }));
        jComboBoxBit.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBoxBitActionPerformed(evt);
            }
        });

        jComboBoxChannels.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "1", "2" }));
        jComboBoxChannels.setEnabled(false);
        jComboBoxChannels.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBoxChannelsActionPerformed(evt);
            }
        });

        jComboBoxEndian.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "little endian", "big endian" }));
        jComboBoxEndian.setEnabled(false);
        jComboBoxEndian.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBoxEndianActionPerformed(evt);
            }
        });

        jComboBoxSampleRate.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "8 kHz", "22.05 kHz", "44.10 kHz", "48 kHz" }));
        jComboBoxSampleRate.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBoxSampleRateActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel2Layout = new javax.swing.GroupLayout(jPanel2);
        jPanel2.setLayout(jPanel2Layout);
        jPanel2Layout.setHorizontalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel10, javax.swing.GroupLayout.PREFERRED_SIZE, 65, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                        .addGroup(jPanel2Layout.createSequentialGroup()
                            .addComponent(jLabel13, javax.swing.GroupLayout.PREFERRED_SIZE, 65, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGap(21, 21, 21)
                            .addComponent(jTextFieldFrameRate))
                        .addGroup(jPanel2Layout.createSequentialGroup()
                            .addComponent(jLabel14, javax.swing.GroupLayout.PREFERRED_SIZE, 65, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGap(21, 21, 21)
                            .addComponent(jComboBoxEndian, javax.swing.GroupLayout.PREFERRED_SIZE, 93, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                            .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel2Layout.createSequentialGroup()
                                .addComponent(jLabel11, javax.swing.GroupLayout.PREFERRED_SIZE, 65, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                .addComponent(jComboBoxChannels, javax.swing.GroupLayout.PREFERRED_SIZE, 46, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel2Layout.createSequentialGroup()
                                .addComponent(jLabel12, javax.swing.GroupLayout.PREFERRED_SIZE, 65, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(21, 21, 21)
                                .addComponent(jTextFieldFrameSize, javax.swing.GroupLayout.PREFERRED_SIZE, 46, javax.swing.GroupLayout.PREFERRED_SIZE))))
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addGap(86, 86, 86)
                        .addComponent(jComboBoxBit, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel9, javax.swing.GroupLayout.PREFERRED_SIZE, 74, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel8, javax.swing.GroupLayout.PREFERRED_SIZE, 65, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addComponent(jComboBoxEncoding, 0, 117, Short.MAX_VALUE)
                            .addComponent(jComboBoxSampleRate, 0, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))))
                .addGap(0, 0, Short.MAX_VALUE))
        );
        jPanel2Layout.setVerticalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel8)
                    .addComponent(jComboBoxEncoding, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel9)
                    .addComponent(jComboBoxSampleRate, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel10)
                    .addComponent(jComboBoxBit, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel11)
                    .addComponent(jComboBoxChannels, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel12)
                    .addComponent(jTextFieldFrameSize, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel13)
                    .addComponent(jTextFieldFrameRate, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel14)
                    .addComponent(jComboBoxEndian, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
        );

        jLabel16.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/help.png"))); // NOI18N

        jComboBoxAudioDevices.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Item 1", "Item 2", "Item 3", "Item 4" }));
        jComboBoxAudioDevices.setToolTipText("Select input device");
        jComboBoxAudioDevices.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBoxAudioDevicesActionPerformed(evt);
            }
        });

        jLabel17.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/microphone.png"))); // NOI18N

        jButtonStop3.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/control_equalizer_blue.png"))); // NOI18N
        jButtonStop3.setToolTipText("normalize samples");
        jButtonStop3.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonStop3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonStop3ActionPerformed(evt);
            }
        });

        jTextFieldSizeInternal.setEditable(false);
        jTextFieldSizeInternal.setToolTipText("size in byte of internal data representation (16bit, 2channel, 44100Hz)");

        jLabel20.setText("size");

        jComboBoxNormalize.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "peak", "1bit", "2bit", "3bit", "4bit" }));
        jComboBoxNormalize.setToolTipText("<html>\nNormalize<BR>\nThis is a \"simple\" normalize without eleborated range compression.<BR>\nThe options are:<BR>\n<UL>\n<LI>peak: <BR>use highest found value, give it max bits, and scale all others</LI>\n<LI>xbit: <BR>set highest x bits to 0 and than give highest found value max bits and scale all others</LI>\n</UL>\n</html>"); // NOI18N
        jComboBoxNormalize.setPreferredSize(new java.awt.Dimension(31, 19));

        javax.swing.GroupLayout jPanel3Layout = new javax.swing.GroupLayout(jPanel3);
        jPanel3.setLayout(jPanel3Layout);
        jPanel3Layout.setHorizontalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jPanel2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addGroup(jPanel3Layout.createSequentialGroup()
                        .addComponent(jLabel17)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jComboBoxAudioDevices, 0, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                    .addGroup(jPanel3Layout.createSequentialGroup()
                        .addComponent(jLabel16)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jLabel20, javax.swing.GroupLayout.PREFERRED_SIZE, 35, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(41, 41, 41)
                        .addComponent(jTextFieldSizeInternal, javax.swing.GroupLayout.PREFERRED_SIZE, 90, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(0, 0, Short.MAX_VALUE))
                    .addGroup(jPanel3Layout.createSequentialGroup()
                        .addComponent(jButtonRecord)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButtonPlaySample)
                        .addGap(28, 28, 28)
                        .addComponent(jButtonStop2)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButtonCut)
                        .addGap(46, 46, 46)
                        .addComponent(jButtonStop3)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jComboBoxNormalize, 0, 58, Short.MAX_VALUE)))
                .addContainerGap())
        );
        jPanel3Layout.setVerticalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jButtonRecord)
                    .addComponent(jButtonPlaySample)
                    .addComponent(jButtonStop2)
                    .addComponent(jButtonCut)
                    .addComponent(jButtonStop3)
                    .addComponent(jComboBoxNormalize, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jLabel16)
                    .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jLabel20)
                        .addComponent(jTextFieldSizeInternal, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 7, Short.MAX_VALUE)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel17, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jComboBoxAudioDevices, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
        );

        jPanel4.setBorder(javax.swing.BorderFactory.createTitledBorder("Target"));

        jButtonPlayVectrex.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/control_play_blue.png"))); // NOI18N
        jButtonPlayVectrex.setToolTipText("Play current sample!");
        jButtonPlayVectrex.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonPlayVectrex.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonPlayVectrexActionPerformed(evt);
            }
        });

        jPanel1.setBorder(javax.swing.BorderFactory.createTitledBorder("Output Format"));

        jLabel1.setText("encoding");

        jTextFieldSampleRate.setText("8000");
        jTextFieldSampleRate.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextFieldSampleRateFocusLost(evt);
            }
        });
        jTextFieldSampleRate.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldSampleRateActionPerformed(evt);
            }
        });
        jTextFieldSampleRate.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyTyped(java.awt.event.KeyEvent evt) {
                jTextFieldSampleRateKeyTyped(evt);
            }
        });

        jLabel2.setText("sample rate");

        jLabel3.setText("bit ");

        jLabel4.setText("channels");

        jTextField5.setEditable(false);
        jTextField5.setText("1");
        jTextField5.setToolTipText("");

        jLabel5.setText("frame size");

        jLabel6.setText("frame rate");

        jTextField6.setEditable(false);
        jTextField6.setText("8000");

        jLabel7.setText("endian");

        jComboBox1.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "PCM_UNSIGNED" }));
        jComboBox1.setEnabled(false);

        jComboBox2.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "8 bit" }));
        jComboBox2.setEnabled(false);

        jComboBox3.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "1", "2" }));
        jComboBox3.setEnabled(false);

        jComboBox4.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "1 byte" }));
        jComboBox4.setEnabled(false);

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                        .addGroup(jPanel1Layout.createSequentialGroup()
                            .addComponent(jLabel6, javax.swing.GroupLayout.PREFERRED_SIZE, 65, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGap(21, 21, 21)
                            .addComponent(jTextField6))
                        .addGroup(jPanel1Layout.createSequentialGroup()
                            .addComponent(jLabel7, javax.swing.GroupLayout.PREFERRED_SIZE, 65, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGap(21, 21, 21)
                            .addComponent(jComboBox4, javax.swing.GroupLayout.PREFERRED_SIZE, 93, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                            .addGroup(jPanel1Layout.createSequentialGroup()
                                .addComponent(jLabel4, javax.swing.GroupLayout.PREFERRED_SIZE, 65, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                .addComponent(jComboBox3, javax.swing.GroupLayout.PREFERRED_SIZE, 46, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel1Layout.createSequentialGroup()
                                .addComponent(jLabel5, javax.swing.GroupLayout.PREFERRED_SIZE, 65, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(21, 21, 21)
                                .addComponent(jTextField5, javax.swing.GroupLayout.PREFERRED_SIZE, 46, javax.swing.GroupLayout.PREFERRED_SIZE))))
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                            .addComponent(jLabel3, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jLabel2, javax.swing.GroupLayout.DEFAULT_SIZE, 74, Short.MAX_VALUE)
                            .addComponent(jLabel1, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.PREFERRED_SIZE, 65, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addComponent(jComboBox2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jComboBox1, 0, 115, Short.MAX_VALUE)
                            .addComponent(jTextFieldSampleRate))))
                .addGap(0, 0, Short.MAX_VALUE))
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel1)
                    .addComponent(jComboBox1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel2)
                    .addComponent(jTextFieldSampleRate, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel3)
                    .addComponent(jComboBox2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel4)
                    .addComponent(jComboBox3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel5)
                    .addComponent(jTextField5, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel6)
                    .addComponent(jTextField6, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel7)
                    .addComponent(jComboBox4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );

        jLabel18.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/sound_none.png"))); // NOI18N

        jComboBoxAudioDevices1.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Vectrex" }));
        jComboBoxAudioDevices1.setToolTipText("Select input device");
        jComboBoxAudioDevices1.setEnabled(false);

        jButton5.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/page_save.png"))); // NOI18N
        jButton5.setText("save (wav)");
        jButton5.setMargin(new java.awt.Insets(2, 2, 2, 2));
        jButton5.setPreferredSize(new java.awt.Dimension(72, 20));
        jButton5.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton5ActionPerformed(evt);
            }
        });

        jButton7.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/page_save.png"))); // NOI18N
        jButton7.setLabel("save (raw)");
        jButton7.setMargin(new java.awt.Insets(2, 2, 2, 2));
        jButton7.setPreferredSize(new java.awt.Dimension(72, 20));
        jButton7.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton7ActionPerformed(evt);
            }
        });

        jLabel19.setText("size");

        jTextFieldVectrexSize.setEditable(false);

        jCheckBoxReverse.setSelected(true);
        jCheckBoxReverse.setText("reverse");
        jCheckBoxReverse.setToolTipText("Save generated asm data in reverse order");

        javax.swing.GroupLayout jPanel4Layout = new javax.swing.GroupLayout(jPanel4);
        jPanel4.setLayout(jPanel4Layout);
        jPanel4Layout.setHorizontalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel4Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addGroup(jPanel4Layout.createSequentialGroup()
                        .addComponent(jButtonPlayVectrex)
                        .addGap(18, 18, 18)
                        .addComponent(jButton5, javax.swing.GroupLayout.PREFERRED_SIZE, 97, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jButton7, javax.swing.GroupLayout.PREFERRED_SIZE, 97, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(8, 8, 8))
                    .addGroup(jPanel4Layout.createSequentialGroup()
                        .addComponent(jLabel18)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jComboBoxAudioDevices1, 0, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addGroup(jPanel4Layout.createSequentialGroup()
                                .addComponent(jLabel19, javax.swing.GroupLayout.PREFERRED_SIZE, 35, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(41, 41, 41)
                                .addComponent(jTextFieldVectrexSize, javax.swing.GroupLayout.PREFERRED_SIZE, 90, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jCheckBoxReverse, javax.swing.GroupLayout.DEFAULT_SIZE, 72, Short.MAX_VALUE)))))
                .addContainerGap())
        );
        jPanel4Layout.setVerticalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel4Layout.createSequentialGroup()
                .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jButtonPlayVectrex)
                    .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jButton5, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jButton7, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, 199, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel19)
                    .addComponent(jTextFieldVectrexSize, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jCheckBoxReverse))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel18, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jComboBoxAudioDevices1, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
        );

        jButton6.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/information.png"))); // NOI18N
        jButton6.setText("info");
        jButton6.setPreferredSize(new java.awt.Dimension(72, 20));
        jButton6.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton6ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(singleImagePanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                .addGroup(layout.createSequentialGroup()
                                    .addComponent(jPanel3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                    .addComponent(jPanel4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addGap(0, 0, Short.MAX_VALUE))
                                .addGroup(layout.createSequentialGroup()
                                    .addComponent(jButton6, javax.swing.GroupLayout.PREFERRED_SIZE, 68, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                    .addComponent(jSlider1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))))
                        .addContainerGap())
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(jButton1, javax.swing.GroupLayout.PREFERRED_SIZE, 130, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButtonSaveOrgSample)
                        .addGap(102, 102, 102)
                        .addComponent(jButtonCancel)
                        .addGap(66, 66, 66)
                        .addComponent(jButtonCreate, javax.swing.GroupLayout.PREFERRED_SIZE, 110, javax.swing.GroupLayout.PREFERRED_SIZE))))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(singleImagePanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jSlider1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButton6, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(jPanel3, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jPanel4, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButtonCreate)
                    .addComponent(jButtonCancel)
                    .addComponent(jButtonSaveOrgSample)
                    .addComponent(jButton1))
                .addGap(18, 18, 18))
        );
    }// </editor-fold>//GEN-END:initComponents

    private void jButtonCancelActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonCancelActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jButtonCancelActionPerformed

    private void jButtonRecordActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonRecordActionPerformed
        if (targetDataLine != null) return;
        if (!targetLineOk) return;
        
        if (sound != null)
        {
            sound.unload();
            sound = null;
        }
        image = null;
        targetDataLine = getTargetDataLine(((MyMixer)jComboBoxAudioDevices.getSelectedItem()), getSelectedAudioFormat(), AudioSystem.NOT_SPECIFIED);
        AudioFileFormat.Type targetType = findTargetType("wav");
        
        File file = new File(TMP_FILENAME);
        recorder = new BufferingRecorder( targetDataLine, targetType, file);
        recorder.start();
        jButtonRecord.setEnabled(false);
    }//GEN-LAST:event_jButtonRecordActionPerformed


    private void jButtonPlaySampleActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonPlaySampleActionPerformed
        if (sound != null)
        {
            if (image != null)
                pos = de.malban.util.UtilityImage.copyImage(image);
            lastPostion = 0;
            lastDrawnPosition = 0;
        
            if ((rangeEndPos!=-1) && (rangeStartPos!=-1))
            {
                int rStart = rangeStartPos;
                int rEnd = rangeEndPos;
                if (rangeEndPos<rangeStartPos) 
                {
                    rEnd = rangeStartPos;
                    rStart = rangeEndPos;
                }
                if (rStart <0) rStart = 0;

                sound.playRange(getSamplePos(rStart), getSamplePos(rEnd));
            }
            else
            {
                sound.play();                        
            }
        }
    }//GEN-LAST:event_jButtonPlaySampleActionPerformed

    // in frames for 1 channel!, not in bytes!
    // 
    int getSamplePos(int winPos)
    {
        if (sound == null) 
        {
            return -1;
        }
        byte[] data = sound.getLeftData(); // only left, we only sample one channel anyway
        // frame size for one channel is 2, since tiny sound allways uses 16bit
        int oneChannelFrameSize = 2;
        int windowWidth = singleImagePanel1.getWidth();
        double pos = ((double)winPos)/((double)windowWidth);
        double sampleWidth = ((double)data.length)/((double)oneChannelFrameSize);

        
        int samplePos = (int)(sampleWidth*pos);
        if (samplePos<0) samplePos = 0;
        if (samplePos>=data.length/oneChannelFrameSize) samplePos = (data.length/oneChannelFrameSize) -1;
        
        return samplePos;
    }
    
    private void jButtonStop2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonStop2ActionPerformed
        if (recorder != null)
        {
            recorder.stopRecording();
            checkTargetLine();
            recorder = null;
            // todo load wav
            setSample(TMP_FILENAME);        
        }
        if (sound != null)
        {
            sound.stop();
        }
    }//GEN-LAST:event_jButtonStop2ActionPerformed

    private void jButtonCutActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonCutActionPerformed
        if (sound != null)
        {
            if ((rangeEndPos!=-1) && (rangeStartPos!=-1))
            {
                int rStart = rangeStartPos;
                int rEnd = rangeEndPos;
                if (rangeEndPos<rangeStartPos) 
                {
                    rEnd = rangeStartPos;
                    rStart = rangeEndPos;
                }
                if (rStart <0) rStart = 0;

                sound.cutRange(getSamplePos(rStart), getSamplePos(rEnd));
                rangeStartPos = -1;
                rangeEndPos = -1;
                paintSamples();
            }
        }
    }//GEN-LAST:event_jButtonCutActionPerformed

    private void jButtonPlayVectrexActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonPlayVectrexActionPerformed
        playVectrex();
    }//GEN-LAST:event_jButtonPlayVectrexActionPerformed

    private void jComboBoxSampleRateActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBoxSampleRateActionPerformed
        if (jComboBoxSampleRate.getSelectedIndex() == 0) jTextFieldFrameRate.setText(""+8000);
        if (jComboBoxSampleRate.getSelectedIndex() == 1) jTextFieldFrameRate.setText(""+22050);
        if (jComboBoxSampleRate.getSelectedIndex() == 2) jTextFieldFrameRate.setText(""+44100);
        if (jComboBoxSampleRate.getSelectedIndex() == 3) jTextFieldFrameRate.setText(""+48000);
        checkTargetLine();
    }//GEN-LAST:event_jComboBoxSampleRateActionPerformed

    private void jComboBoxBitActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBoxBitActionPerformed

        if (jComboBoxBit.getSelectedIndex() == 0)
        {
            jComboBoxEncoding.setSelectedIndex(1);
        }
        else
            jComboBoxEncoding.setSelectedIndex(0);
            
        calcFrameSize();
        checkTargetLine();
    }//GEN-LAST:event_jComboBoxBitActionPerformed

    private void jComboBoxChannelsActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBoxChannelsActionPerformed
        calcFrameSize();
        checkTargetLine();
    }//GEN-LAST:event_jComboBoxChannelsActionPerformed

    private void jComboBoxEncodingActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBoxEncodingActionPerformed
        checkTargetLine();
    }//GEN-LAST:event_jComboBoxEncodingActionPerformed

    private void jComboBoxEndianActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBoxEndianActionPerformed
        checkTargetLine();
    }//GEN-LAST:event_jComboBoxEndianActionPerformed

    private void jComboBoxAudioDevicesActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBoxAudioDevicesActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jComboBoxAudioDevicesActionPerformed

    private void singleImagePanel1ComponentResized(java.awt.event.ComponentEvent evt) {//GEN-FIRST:event_singleImagePanel1ComponentResized
        image = null;
        pos = null;
        org = null;
        rangeStartPos = -1;
        rangeEndPos = -1;
        paintSamples();
        
    }//GEN-LAST:event_singleImagePanel1ComponentResized

    private void jButtonCreateActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonCreateActionPerformed
        createSource();
    }//GEN-LAST:event_jButtonCreateActionPerformed

    private void jButton5ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton5ActionPerformed
        saveVectrex();
    }//GEN-LAST:event_jButton5ActionPerformed

    private void jButton6ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton6ActionPerformed

        QuickHelpModal.showHelpHtmlFile("documents"+File.separator+"help"+File.separator+"sample.html");
    }//GEN-LAST:event_jButton6ActionPerformed

    private void jButtonStop3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonStop3ActionPerformed
        if (sound != null) normalize();
    }//GEN-LAST:event_jButtonStop3ActionPerformed

    private void jButton7ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton7ActionPerformed
        saveVectrexRaw();
    }//GEN-LAST:event_jButton7ActionPerformed

    private void jTextFieldSampleRateActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldSampleRateActionPerformed
        jTextField6.setText(jTextFieldSampleRate.getText());
        jTextFieldVectrexSize.setText(""+(convertToVectrex().length));

    }//GEN-LAST:event_jTextFieldSampleRateActionPerformed

    private void jTextFieldSampleRateFocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextFieldSampleRateFocusLost
        jTextField6.setText(jTextFieldSampleRate.getText());
        jTextFieldVectrexSize.setText(""+(convertToVectrex().length));
    }//GEN-LAST:event_jTextFieldSampleRateFocusLost

    private void jTextFieldSampleRateKeyTyped(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTextFieldSampleRateKeyTyped
        jTextField6.setText(jTextFieldSampleRate.getText());
        if (convertToVectrex() != null) 
            jTextFieldVectrexSize.setText(""+(convertToVectrex().length));
    }//GEN-LAST:event_jTextFieldSampleRateKeyTyped

    private void jButtonSaveOrgSampleActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSaveOrgSampleActionPerformed
        
        String name = GetWavFilenamePanel.showEnterValueDialog();
        name = name+".wav";
        name = pathOnly+File.separator+name;
        try
        {
            byte[] orgData16Bit2Channel  = sound.getData();
            AudioFormat tinyformat = TinySound.FORMAT;
            AudioInputStream audioStream = new AudioInputStream( new ByteArrayInputStream(orgData16Bit2Channel) ,tinyformat, orgData16Bit2Channel.length/4 );
            AudioFileFormat.Type targetType = findTargetType("wav");
            AudioSystem.write(audioStream,  targetType, new File(name));
        }
        catch (Throwable e)
        {
            log.addLog(e, WARN);
        }
    }//GEN-LAST:event_jButtonSaveOrgSampleActionPerformed

    String lastPath ="";
    private void jButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton1ActionPerformed
        
        InternalFrameFileChoser fc = new de.malban.gui.dialogs.InternalFrameFileChoser();
        
        if (lastPath.length()==0)
        {
            fc.setCurrentDirectory(new java.io.File(pathOnly));
        }
        else
        {
            fc.setCurrentDirectory(new java.io.File(lastPath));
        }
        FileNameExtensionFilter filter = new FileNameExtensionFilter("wav", "wav");
        fc.setFileFilter(filter);
        
        int r = fc.showOpenDialog(Configuration.getConfiguration().getMainFrame());
        if (r != InternalFrameFileChoser.APPROVE_OPTION) return;
        lastPath = fc.getSelectedFile().getAbsolutePath();
        
        String relPath = de.malban.util.Utility.makeRelative(lastPath);
//        String fileNameOnly = Paths.get(relPath).getFileName().toString();
//        currentSampleFile = pathOnly+File.separator+fileNameOnly; 
        setSample(relPath);
        
    }//GEN-LAST:event_jButton1ActionPerformed

    void calcFrameSize()
    {
        int size = jComboBoxBit.getSelectedIndex()+1;
        size = size * (jComboBoxChannels.getSelectedIndex()+1);
        jTextFieldFrameSize.setText(""+size);
        checkTargetLine();
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton jButton1;
    private javax.swing.JButton jButton5;
    private javax.swing.JButton jButton6;
    private javax.swing.JButton jButton7;
    private javax.swing.JButton jButtonCancel;
    private javax.swing.JButton jButtonCreate;
    private javax.swing.JButton jButtonCut;
    private javax.swing.JButton jButtonPlaySample;
    private javax.swing.JButton jButtonPlayVectrex;
    private javax.swing.JButton jButtonRecord;
    private javax.swing.JButton jButtonSaveOrgSample;
    private javax.swing.JButton jButtonStop2;
    private javax.swing.JButton jButtonStop3;
    private javax.swing.JCheckBox jCheckBoxReverse;
    private javax.swing.JComboBox jComboBox1;
    private javax.swing.JComboBox jComboBox2;
    private javax.swing.JComboBox jComboBox3;
    private javax.swing.JComboBox jComboBox4;
    private javax.swing.JComboBox jComboBoxAudioDevices;
    private javax.swing.JComboBox jComboBoxAudioDevices1;
    private javax.swing.JComboBox jComboBoxBit;
    private javax.swing.JComboBox jComboBoxChannels;
    private javax.swing.JComboBox jComboBoxEncoding;
    private javax.swing.JComboBox jComboBoxEndian;
    private javax.swing.JComboBox jComboBoxNormalize;
    private javax.swing.JComboBox jComboBoxSampleRate;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel10;
    private javax.swing.JLabel jLabel11;
    private javax.swing.JLabel jLabel12;
    private javax.swing.JLabel jLabel13;
    private javax.swing.JLabel jLabel14;
    private javax.swing.JLabel jLabel16;
    private javax.swing.JLabel jLabel17;
    private javax.swing.JLabel jLabel18;
    private javax.swing.JLabel jLabel19;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel20;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JLabel jLabel6;
    private javax.swing.JLabel jLabel7;
    private javax.swing.JLabel jLabel8;
    private javax.swing.JLabel jLabel9;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JPanel jPanel3;
    private javax.swing.JPanel jPanel4;
    private javax.swing.JSlider jSlider1;
    private javax.swing.JTextField jTextField5;
    private javax.swing.JTextField jTextField6;
    private javax.swing.JTextField jTextFieldFrameRate;
    private javax.swing.JTextField jTextFieldFrameSize;
    private javax.swing.JTextField jTextFieldSampleRate;
    private javax.swing.JTextField jTextFieldSizeInternal;
    private javax.swing.JTextField jTextFieldVectrexSize;
    private de.malban.graphics.SingleImagePanel singleImagePanel1;
    // End of variables declaration//GEN-END:variables

    JInternalFrame modelDialog;
    public static boolean showSamplePanel(String fileName, boolean fileExists)
    {
        JFrame frame = Configuration.getConfiguration().getMainFrame();
        SampleJPanel panel = new SampleJPanel(fileName);
/*        
        if (fileExists)
            panel.setSample(fileName);
*/        
        
        ArrayList<JButton> eb= new ArrayList<JButton>();
        eb.add(panel.jButtonCreate);
        eb.add(panel.jButtonCancel);
        ModalInternalFrame modal = new ModalInternalFrame("Sample", frame.getRootPane(), frame, panel,null, null , eb);
        
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
    private void checkTargetLine()
    {
        if (targetMixers.isEmpty())
        {
            jLabel16.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/help.png"))); // NOI18N
            return;
        }

        targetDataLine = null;
        targetDataLine = getTargetDataLine(((MyMixer)jComboBoxAudioDevices.getSelectedItem()), getSelectedAudioFormat(), AudioSystem.NOT_SPECIFIED);
        if (targetDataLine == null)
        {
            targetLineOk =false;
            jLabel16.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/cancel.png"))); // NOI18N
        }
        else
        {
            targetLineOk = true;
            jLabel16.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/accept.png"))); 
        }
        targetDataLine = null;
        if (recorder != null)
            jButtonRecord.setEnabled(targetLineOk);
    }
    private AudioFormat getSelectedAudioFormat()
    {
        AudioFormat.Encoding encoding = jComboBoxEncoding.getSelectedIndex()==0?AudioFormat.Encoding.PCM_SIGNED:AudioFormat.Encoding.PCM_UNSIGNED;
        int	nBitsPerSample = DASM6809.toNumber(jComboBoxBit.getSelectedItem().toString().split(" ")[0]);
        boolean	bBigEndian = jComboBoxEndian.getSelectedIndex()==1;
        int     nChannels = jComboBoxChannels.getSelectedIndex()+1;
        int	nFrameSize = (nBitsPerSample / 8) * nChannels;
        int     fRate = DASM6809.toNumber(jTextFieldFrameRate.getText());
        int     fsize = DASM6809.toNumber(jTextFieldFrameSize.getText());
        
        AudioFormat	audioFormat = new AudioFormat(encoding, fRate, nBitsPerSample, nChannels, nFrameSize, fRate, bBigEndian);
        int nInternalBufferSize = AudioSystem.NOT_SPECIFIED;        
        return audioFormat;
    }
    
    public boolean setSample(String fullPathFilename)
    {
        currentSampleFile = fullPathFilename;
        File file = new File (currentSampleFile);
        if (!file.exists()) return false;
        
        sound = (MemSound) TinySound.loadSound(new File(currentSampleFile), false);
        if (sound != null)
        {
            setAudioFormat(fullPathFilename);
        }
        else
        {
            log.addLog("Sample could not be loaded: " + fullPathFilename, WARN);
        }
        
        paintSamples();
        return false;
    }
    
    void paintSamples()
    {
        int windowWidth = singleImagePanel1.getWidth();
        int windowHeight = singleImagePanel1.getHeight();
        if ((windowWidth==0) || (windowHeight==0)) return;
        if (image == null)
        {
            pos = null;
            org = null;
            image = de.malban.util.UtilityImage.getNewImage(windowWidth, windowHeight);
        }
        Graphics2D g = image.createGraphics();
        g.clearRect(0, 0, windowWidth, windowHeight);
        
        if (sound == null) 
        {
            g.dispose();
            singleImagePanel1.setImage(image);
            return;
        }
        byte[] data = sound.getLeftData(); // only left, we only sample one channel anyway
        // frame size for one channel is 2, since tiny sound allways uses 16bit
        int oneChannelFrameSize = 2;

        jTextFieldSizeInternal.setText(""+(sound.getLeftData().length*2));
        jTextFieldVectrexSize.setText(""+(convertToVectrex().length));
        // no need to change anything
        // data from SOUND
        // allways are: 44100, 16bit, unsigned
        double maxSampleWidth = 32768.0; // 16 bit
        int height0 = windowHeight/2; // signed
        
        double heightScale = ((double)height0)/maxSampleWidth;
        int gfxSampleWidth = (data.length/oneChannelFrameSize)/windowWidth;
        if (gfxSampleWidth<1) gfxSampleWidth = 1;
        positionDeltaMin = gfxSampleWidth;
        int gfxSample = 0;
        int gfxSampleCount = 0;
        int x=0;
        
        int max = -1000000000;
        int min = 1000000000;
        
        // ignoring samples of opposite sign
        // is useful for graph building
        // since there is less "averaging" out
        int lastSample =0;
        int ignoreDiv = 0;
        for (int i=0; i< data.length; i+=oneChannelFrameSize)
        {
            int soundSample = sound.get16BitDataAt(i, 0);
            boolean ignore = false;
            if (lastSample != 0)
            {
                if (lastSample*soundSample<0)
                {
                    ignoreDiv++;
                    ignore = true;
                }
                else
                {
                    lastSample = soundSample;
                }
            }
            else
            {
                lastSample = soundSample;
            }
            
            if (!ignore)
                gfxSample += soundSample;
            gfxSampleCount = (gfxSampleCount+1) % gfxSampleWidth;
            if (gfxSampleCount==0)
            {
                gfxSample = gfxSample / (gfxSampleWidth-ignoreDiv);

                
                double gfxSampleScaled = ((double)gfxSample) * heightScale;
                gfxSample = 0;
                int y = height0-(int)gfxSampleScaled;
                g.drawLine(x, height0, x, y);
                x++;
                lastSample =0;
                ignoreDiv = 0;
            }
        }
        if (pos == null)
        {
            pos = de.malban.util.UtilityImage.copyImage(image);
        }
        else
        {
            Graphics2D g2 = pos.createGraphics();
            g2.drawImage(image, null, null);
            g2.dispose();
        }
        if (org == null)
        {
            org = de.malban.util.UtilityImage.copyImage(image);
        }
        else
        {
            Graphics2D g2 = org.createGraphics();
            g2.drawImage(image, null, null);
            g2.dispose();
        }
        g.dispose();
        setRanges();
        singleImagePanel1.setImage(image);
        sound.addPositionListener(this);
    }
    
    // ranges are set from mouse events
    // this paints the current range to image
    // and sets the image to singleImagePanel
    void setRanges()
    {
        int rStart = rangeStartPos;
        int rEnd = rangeEndPos;
        if ((rangeEndPos==-1) || (rangeStartPos==-1))
        {
            if (rangeWasSet)
            {
                rangeWasSet = false;
                Graphics2D g = image.createGraphics();
                g.drawImage(org, null, null);
                singleImagePanel1.setImage(image);
                g.dispose();
            }
            return;
        }
        if (rangeEndPos<rangeStartPos) 
        {
            rEnd = rangeStartPos;
            rStart = rangeEndPos;
        }
        Graphics2D g = image.createGraphics();
        g.drawImage(org, null, null);
        g.setColor(new Color(255,255,0,100));
        g.fillRect(rStart, 0, rEnd-rStart, image.getHeight());
        rangeWasSet = true;
        singleImagePanel1.setImage(image);
        g.dispose();
    }
    
    

    public void positionChanged(final int position)    
    {
        if (image==null) return;
        if (sound == null) return;
        
        if (Math.abs(position - lastPostion) >positionDeltaMin)
        {
            SwingUtilities.invokeLater(new Runnable()
            {
                public void run()
                {
                    Graphics2D g = pos.createGraphics();
                    int oneChannelFrameSize = 2;
                    int gfxSampleWidth = (sound.getLeftData().length/oneChannelFrameSize)/image.getWidth();
                    if (lastDrawnPosition != 0)
                    {
                        // restore old 
                        g.drawImage(image, lastDrawnPosition, 0, lastDrawnPosition+1, image.getHeight(), lastDrawnPosition, 0, lastDrawnPosition+1, image.getHeight(), null);
                    }
                    double pos1 = ((double)position)/((double)sound.getLeftData().length);
                    double pos2 = ((double)image.getWidth()) * pos1;
                    g.setColor(Color.red);
                    g.drawLine((int)pos2, 0,(int)pos2, image.getHeight());
                    singleImagePanel1.setImage(pos);
                    lastDrawnPosition = (int)pos2;
                }
            });                    
            lastPostion = position;
        }
    }
    
    void fillDeviceList()
    {
        jComboBoxAudioDevices.removeAllItems();
        Mixer.Info[] aInfos = AudioSystem.getMixerInfo();
        for (int i = 0; i < aInfos.length; i++)
        {
            Mixer mixer = AudioSystem.getMixer(aInfos[i]);
            Line.Info lineInfo = new Line.Info(TargetDataLine.class);
            if (mixer.isLineSupported(lineInfo))
            {
                MyMixer mm = new MyMixer(aInfos[i], mixer);
                targetMixers.add(mm);
                jComboBoxAudioDevices.addItem(mm);
            }
        }
    }
    public TargetDataLine getTargetDataLine(MyMixer mixer, AudioFormat audioFormat, int nBufferSize)
    {
        /*
                Asking for a line is a rather tricky thing.
                We have to construct an Info object that specifies
                the desired properties for the line.
                First, we have to say which kind of line we want. The
                possibilities are: SourceDataLine (for playback), Clip
                (for repeated playback)	and TargetDataLine (for
                 recording).
                Here, we want to do normal capture, so we ask for
                a TargetDataLine.
                Then, we have to pass an AudioFormat object, so that
                the Line knows which format the data passed to it
                will have.
                Furthermore, we can give Java Sound a hint about how
                big the internal buffer for the line should be. This
                isn't used here, signaling that we
                don't care about the exact size. Java Sound will use
                some default value for the buffer size.
        */
        TargetDataLine targetDataLine = null;
        DataLine.Info info = new DataLine.Info(TargetDataLine.class, audioFormat, nBufferSize);
        try
        {
            targetDataLine = (TargetDataLine) mixer.mixer.getLine(info);
            /*
             *	The line is there, but it is not yet ready to
             *	receive audio data. We have to open the line.
             */
            targetDataLine.open(audioFormat, nBufferSize);
        }
        catch (LineUnavailableException e)
        {
            log.addLog(e, INFO);
            targetDataLine = null;
        }
        catch (Exception e)
        {
            log.addLog(e, INFO);
            targetDataLine = null;
        }
        if (targetDataLine != null) targetDataLine.close();
        return targetDataLine;
    }    
    /**	Trying to get an audio file type for the passed extension.
        This works by examining all available file types. For each
        type, if the extension this type promisses to handle matches
        the extension we are trying to find a type for, this type is
        returned.
        If no appropriate type is found, null is returned.
    */
    public static AudioFileFormat.Type findTargetType(String strExtension)
    {
        AudioFileFormat.Type[] aTypes = AudioSystem.getAudioFileTypes();
        for (int i = 0; i < aTypes.length; i++)
        {
            if (aTypes[i].getExtension().equals(strExtension))
            {
                    return aTypes[i];
            }
        }
        return null;
    }
    public static void listSupportedTargetTypes()
    {
        String	strMessage = "Supported target types:";
        AudioFileFormat.Type[]	aTypes = AudioSystem.getAudioFileTypes();
        for (int i = 0; i < aTypes.length; i++)
        {
                strMessage += " " + aTypes[i].getExtension();
        }
        System.out.println(strMessage);
    }
    public static interface Recorder
    {
        public void start();
        public void stopRecording();
        public long getFrames();
    }
    public static class AbstractRecorder extends Thread implements Recorder
    {
        LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
        protected TargetDataLine	m_line;
        protected AudioFileFormat.Type	m_targetType;
        protected File			m_file;
        protected boolean		m_bRecording;
        long frames=0;

        public AbstractRecorder(TargetDataLine line, AudioFileFormat.Type targetType, File file)
        {
            m_line = line;
            m_targetType = targetType;
            m_file = file;
        }
        /**	Starts the recording.
         *	To accomplish this, (i) the line is started and (ii) the
         *	thread is started.
         */
        public void start()
        {
            if (!m_line.isOpen())
            {
                try
                {
                    m_line.open();
                }
                catch (Throwable e)
                {
                    // should not happen, we tested befor!
                    log.addLog(e, WARN);
                    return;
                }
            }
            m_line.start();
            super.start();
        }
        public void stopRecording()
        {
            // for recording, the line needs to be stopped
            // before draining (especially if you're still
            // reading from it)
            m_line.stop();
            m_line.drain();
            m_line.close();
            m_bRecording = false;
        }
        public long getFrames()
        {
            return frames;
        }
    }
    public static class DirectRecorder extends AbstractRecorder
    {
        private AudioInputStream	m_audioInputStream;
        public DirectRecorder(TargetDataLine line, AudioFileFormat.Type targetType, File file)
        {
            super(line, targetType, file);
            m_audioInputStream = new AudioInputStream(line);
        }
        public void run()
        {
            try
            {
                AudioSystem.write( m_audioInputStream, m_targetType, m_file);
            }
            catch (IOException e)
            {
                e.printStackTrace();
            }
        }
    }
    public static class BufferingRecorder extends AbstractRecorder
    {
        public BufferingRecorder(TargetDataLine line, AudioFileFormat.Type targetType, File file)
        {
            super(line, targetType, file);
        }
        public void run()
        {
            ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            OutputStream outputStream = byteArrayOutputStream;

            // TODO: intelligent size
            AudioFormat	format = m_line.getFormat();
            int size = 1024; 
            size = ((int)format.getFrameRate()) * format.getFrameSize();
            
            byte[] abBuffer = new byte[size];
            int	nFrameSize = format.getFrameSize();
            int	nBufferFrames = abBuffer.length / nFrameSize;
            m_bRecording = true;
            frames = 0;
            while (m_bRecording)
            {
                int available = m_line.available();
                if (available <= 0) continue;
                if (available>abBuffer.length) // buffer.length is allways a multiple of frameSize
                    available = abBuffer.length;
                int nBytesRead = m_line.read(abBuffer, 0, available);
                int nBytesToWrite = nBytesRead;
                frames+=nBytesRead/nFrameSize;
                try
                {
                    outputStream.write(abBuffer, 0, nBytesToWrite);
                    
                }
                catch (IOException e)
                {
                    log.addLog(e, WARN);
                }
            }
            log.addLog(""+frames+" frames were sampled.", INFO);

            /* We close the ByteArrayOutputStream.
             */
            try
            {
                byteArrayOutputStream.close();
            }
            catch (IOException e)
            {
                log.addLog(e, WARN);
            }


            byte[] abData = byteArrayOutputStream.toByteArray();
            ByteArrayInputStream byteArrayInputStream = new ByteArrayInputStream(abData);

            AudioInputStream audioInputStream = new AudioInputStream(byteArrayInputStream, format, abData.length / format.getFrameSize());
            try
            {
                AudioSystem.write(audioInputStream,  m_targetType, m_file);
            }
            catch (IOException e)
            {
                log.addLog(e, WARN);
            }
        }
    }
    void createSource()
    {
        byte[] vectrexSampleData = convertToVectrex();
        int size = vectrexSampleData.length;
        
        if (size > 32768)
        {
            ShowErrorDialog.showErrorDialog("Size of samples exceeds memory limit of vectrex, creating source of that is stupid!<BR>I, <B>'VIDE'</B> refuses to do so!");
            return;
        }
        
        
        String name = GetFilenamePanel.showEnterValueDialog();
        String nameOnly = name;
        name = name+".asm";
        
        if (pathOnly.length()>0)
            name = pathOnly+File.separator+name;
            
        // convert to signed!
        for (int index8=0; index8<size; index8++)
        {
            int data8=0;
            data8=vectrexSampleData[index8]; 
            data8-=128;
            vectrexSampleData[index8] = (byte)data8;
        }
        
        StringBuilder b = new StringBuilder();
        b.append("; following is sample data saved by Vide\n");
        b.append("; the data is in raw format: 8 bit, signed, 1 channel, samplerate: "+jTextFieldSampleRate.getText()+"\n");
        b.append("; since a frame is only one byte, endianess is meaningless\n");
        b.append("; one byte with 'length', followed by length sample bytes\n");
        b.append("\n");
        if (jCheckBoxReverse.isSelected())
            b.append("; The sample data below is stored in REVERSE order!");
        b.append("\n");
        b.append(nameOnly.toUpperCase()+"_SAMPLERATE equ "+jTextFieldSampleRate.getText()+"\n");
        b.append("\n");
        b.append(nameOnly+"_length:\n dw "+size+"\n\n");
        b.append(nameOnly+"_data: \n");
        b.append(nameOnly+"_data_start: ");

        int LINEMAX = 10;
        int lineCount = 0;
        
        int count=0;
        for (int index8=0; index8<size; index8++)
        {
            if (lineCount == 0)
            {
                b.append("\n db ");
            }
            else
            {
                b.append(", ");
            }
            int data = vectrexSampleData[index8];
            if (jCheckBoxReverse.isSelected())
                data = vectrexSampleData[(size-1)-index8];
            b.append(" $"+String.format("%02X", (data & 0xff)));
            
            lineCount = (lineCount+1)%LINEMAX;
            count++;
        }
        b.append("\n"+nameOnly+"_data_end: ");
        de.malban.util.UtilityFiles.createTextFile(name, b.toString());
        
        String pathNow = pathOnly;
        if (pathNow.length()>0)
            pathNow = pathNow+File.separator;
        
        
        Path include = Paths.get(".", "template", "VECTREX.I");
        de.malban.util.UtilityFiles.copyOneFile(include.toString(), pathNow+ "VECTREX.I");
        Path digital = Paths.get(".", "template", "digitalPlayer.i");
        de.malban.util.UtilityFiles.copyOneFile(digital.toString(), pathNow+ "digitalPlayer.i");

        Path template = Paths.get(".", "template", "digitalPlayMain.template");
        String exampleMain = de.malban.util.UtilityString.readTextFileToOneString(new File(template.toString()));

        int sampleRate = de.malban.util.UtilityString.IntX(jTextFieldSampleRate.getText(), 8000);
        exampleMain = de.malban.util.UtilityString.replace(exampleMain,"#SAMPLE_RATE#", ""+nameOnly.toUpperCase()+"_SAMPLERATE");
        exampleMain = de.malban.util.UtilityString.replace(exampleMain,"#SAMPLE_START#", ""+nameOnly+"_data_start");
        exampleMain = de.malban.util.UtilityString.replace(exampleMain,"#SAMPLE_LENGTH#", ""+nameOnly+"_length");
        exampleMain = de.malban.util.UtilityString.replace(exampleMain,"#SAMPLE_FILE#", ""+nameOnly+".asm");
        de.malban.util.UtilityFiles.createTextFile(pathNow+nameOnly+"Main.asm", exampleMain);
    }
    void playVectrex()
    {
        byte[] vectrexSampleData = convertToVectrex();
        if (vectrexSampleData == null) return;

        AudioInputStream audioStream= new AudioInputStream( new ByteArrayInputStream(vectrexSampleData) ,getVectrexAudioFormat(), vectrexSampleData.length );
        
        Sound s = TinySound.loadSound(audioStream, false);         
        s.play();
        
    }
    AudioFormat getVectrexAudioFormat()
    {
        int sampleRate = de.malban.util.UtilityString.IntX(jTextFieldSampleRate.getText(), 8000);
        // there seems to be no such thing as PCM signed
        // therefor we "save" and use
        // unsigned
        // but later for vectrex building we will save as signed!
        return new AudioFormat(AudioFormat.Encoding.PCM_UNSIGNED, (float) sampleRate, (int) 8, (int) 1, 1, (float) sampleRate, false);
    }
    
    void saveVectrexRaw()
    {
        String name = GetRawFilenamePanel.showEnterValueDialog();
        name = name+".raw";
        name = pathOnly+File.separator+name;
        byte[] vectrexSampleData = convertToVectrex();
        
        // convert to signed!
        int size = vectrexSampleData.length;

        for (int index8=0; index8<size; index8++)
        {
            int data8=0;

            data8=vectrexSampleData[index8];
            data8-=128;
            vectrexSampleData[index8] = (byte)data8;
        }

        FileOutputStream stream = null;
        try 
        {
            stream = new FileOutputStream(name);
            stream.write(vectrexSampleData);
        } 
        catch (Throwable e)
        {
            log.addLog(e, WARN);
        }
        finally 
        {
            try
            {
                if (stream != null)
                    stream.close();
            }
            catch (Throwable e)
            {
            }
        }            
        
    }
    void saveVectrex()
    {
        String name = GetWavFilenamePanel.showEnterValueDialog();
        name = name+".wav";
        name = pathOnly+File.separator+name;
        
        
        
        
        byte[] vectrexSampleData = convertToVectrex();
        if (vectrexSampleData == null) return;
        int sampleRate = de.malban.util.UtilityString.IntX(jTextFieldSampleRate.getText(), 8000);

        // format as given by gui (well sample rate only, the other parameters are quite fixed)
        AudioInputStream audioStream= new AudioInputStream( new ByteArrayInputStream(vectrexSampleData) ,getVectrexAudioFormat(), vectrexSampleData.length );
        AudioFileFormat.Type targetType = findTargetType("wav");

        try
        {
            AudioSystem.write(audioStream,  targetType, new File(name));
        }
        catch (Throwable e)
        {
            log.addLog(e, WARN);
        }
    }

    byte[] convertToVectrex()
    {
        if (sound == null) return null;

        int sampleRate = de.malban.util.UtilityString.IntX(jTextFieldSampleRate.getText(), 8000);
        // convert the current sound to 
        // 8 bit
        // 1 channel
        // signed
        // samplerate as given
        // we only use left channel, since we only CAN use one channel
        byte[] orgData16 = sound.getLeftData();

        AudioFormat outDataFormat = getVectrexAudioFormat();

        // tinyAudio Format for one channel only
        AudioFormat tinyformat = new AudioFormat(
                        AudioFormat.Encoding.PCM_SIGNED, //linear signed PCM
                        44100, //44.1kHz sampling rate
                        16, //16-bit
                        1, //2 channels fool
                        2, //frame size 4 bytes (16-bit, 2 channel)
                        44100,//44100, //same as sampling rate
                        false //little-endian
                        );        
        AudioInputStream tinyAIS;
        AudioInputStream lowResAIS;
        try
        {
            // sample rate
            lowResAIS = convertSampleRate(sampleRate, new AudioInputStream( new ByteArrayInputStream(orgData16) ,tinyformat, orgData16.length/2 ));

            //????
            // for whatever reason tritonus is not able to convert 16 bit to 8 bit, at least not
            // with my samples
            // i will do it myself!
            //   byte[] orgData8 = convert16bitTo8bitUnsigned(orgData16, false);
            // 8 bit
            orgData16 = getData(lowResAIS);
            byte[] orgData8 = convert16BitSignedTo8BitUnsigned(orgData16, false);
         
            lowResAIS = new AudioInputStream( new ByteArrayInputStream(orgData8) ,getVectrexAudioFormat(), orgData8.length );

            
            
            
            
            // get data again...
            byte[] targetData;  
            
            // shamelessly copied from TinySound :-)
            //buffer 1-sec at a time
            int bufSize = (int)outDataFormat.getSampleRate() * outDataFormat.getChannels() * outDataFormat.getFrameSize();

            byte[] buf = new byte[bufSize];
            ByteList list = new ByteList(bufSize);
            int numRead = 0;
            while ((numRead = lowResAIS.read(buf)) > -1)  
            {
                for (int i = 0; i < numRead; i++) 
                {
                    list.add(buf[i]);
                }
            }
            return list.asArray();
        }
        catch (Throwable e)
        {
            log.addLog(e, WARN);
        }
        return null;
    }
    
    byte[] getData(AudioInputStream audioStream) 
    {
        try
        {
            // get data again...
            byte[] targetData;  

            // shamelessly copied from TinySound :-)
            //buffer 1-sec at a time
            int bufSize = (int)audioStream.getFormat().getSampleRate() * audioStream.getFormat().getChannels() * audioStream.getFormat().getFrameSize();

            byte[] buf = new byte[bufSize];
            ByteList list = new ByteList(bufSize);
            int numRead = 0;
            while ((numRead = audioStream.read(buf)) > -1)  
            {
                for (int i = 0; i < numRead; i++) 
                {
                    list.add(buf[i]);
                }
            }
            return list.asArray();
        }
        catch (Throwable e)
        {
            log.addLog(e, WARN);
        }
        return null;
        
    }
    


private static AudioInputStream convertSampleRate(
		float fSampleRate,
		AudioInputStream sourceStream)
	{
		AudioFormat sourceFormat = sourceStream.getFormat();
		AudioFormat targetFormat = new AudioFormat(
			sourceFormat.getEncoding(),
			fSampleRate,
			sourceFormat.getSampleSizeInBits(),
			sourceFormat.getChannels(),
			sourceFormat.getFrameSize(),
			fSampleRate,
			sourceFormat.isBigEndian());
		return AudioSystem.getAudioInputStream(targetFormat, sourceStream);
	}


	private static AudioInputStream convertSampleSizeAndEndianess(
		int nSampleSizeInBits,
		boolean bBigEndian,
		AudioInputStream sourceStream)
	{
		AudioFormat sourceFormat = sourceStream.getFormat();
		AudioFormat targetFormat = new AudioFormat(
			sourceFormat.getEncoding(),
			sourceFormat.getSampleRate(),
			nSampleSizeInBits,
			sourceFormat.getChannels(),
			calculateFrameSize(sourceFormat.getChannels(),
							   nSampleSizeInBits),
			sourceFormat.getFrameRate(),
			bBigEndian);
		return AudioSystem.getAudioInputStream(targetFormat,
											   sourceStream);
	}
        private static int calculateFrameSize(int nChannels, int nSampleSizeInBits)
	{
		return ((nSampleSizeInBits + 7) / 8) * nChannels;
	}
        private static AudioInputStream convertEncoding(
		AudioFormat.Encoding targetEncoding,
		AudioInputStream sourceStream)
	{
		return AudioSystem.getAudioInputStream(targetEncoding,
											   sourceStream);
	}       
        
        byte[] convert16BitSignedTo8BitUnsigned(byte[] orgData16, boolean bigEndian)
        {
            int size = orgData16.length/2;
            if (size *2 != orgData16.length)size--;
            byte[] data8All = new byte[size];

            for (int index8=0; index8<size; index8++)
            {
                int index16 = index8*2;
                int data16;
                int data8=0;
                if (bigEndian) 
                    data16 = ((orgData16[index16] << 8) | (orgData16[index16 + 1] & 0xFF));
                else 
                    data16 = ((orgData16[index16 + 1] << 8) | (orgData16[index16] & 0xFF));

                data8=data16/256;
                data8+=128;
                if (data8>255)
                    System.out.println("Data Conversion error: "+data16+" -> "+data8);
                data8All[index8] = (byte)data8;
            }
            
            return data8All;
        }
        void setAudioFormat(String filename)
        {
            AudioFormat format = getAudioFormat(filename); 
            if (format.getChannels() == 1) jComboBoxChannels.setSelectedIndex(0);
            else if (format.getChannels() == 2) jComboBoxChannels.setSelectedIndex(1);
            else 
            {
                jComboBoxChannels.addItem(""+format.getChannels());
                jComboBoxChannels.setSelectedItem(""+format.getChannels());
            }
        
            if (format.getEncoding() == Encoding.PCM_SIGNED) jComboBoxEncoding.setSelectedIndex(0);
            else if (format.getEncoding() == Encoding.PCM_UNSIGNED) jComboBoxEncoding.setSelectedIndex(1);
            else 
            {
                jComboBoxEncoding.addItem(""+format.getEncoding().toString());
                jComboBoxEncoding.setSelectedItem(""+format.getEncoding().toString());
            }
            
            if (format.getSampleRate() == 8000.0) jComboBoxSampleRate.setSelectedIndex(0);
            else if (format.getSampleRate() == 22050.0) jComboBoxSampleRate.setSelectedIndex(1);
            else if (format.getSampleRate() == 44100.0) jComboBoxSampleRate.setSelectedIndex(2);
            else if (format.getSampleRate() == 48000.0) jComboBoxSampleRate.setSelectedIndex(3);
            else 
            {
                jComboBoxSampleRate.addItem(""+format.getSampleRate()+" Hz");
                jComboBoxSampleRate.setSelectedItem(""+format.getSampleRate()+" Hz");
            }
            
            if (format.getSampleRate() == 8000.0) jTextFieldFrameRate.setText(""+8000);
            else if (format.getSampleRate() == 22050.0) jTextFieldFrameRate.setText(""+22050);
            else if (format.getSampleRate() == 44100.0) jTextFieldFrameRate.setText(""+44100);
            else if (format.getSampleRate() == 48000.0) jTextFieldFrameRate.setText(""+48000);
            else jTextFieldFrameRate.setText(""+format.getSampleRate());
            
            if (format.getSampleSizeInBits() == 8) jComboBoxBit.setSelectedIndex(0);
            else if (format.getSampleSizeInBits() == 16) jComboBoxBit.setSelectedIndex(1);
            else if (format.getSampleSizeInBits() == 24) jComboBoxBit.setSelectedIndex(2);
            else if (format.getSampleSizeInBits() == 32) jComboBoxBit.setSelectedIndex(3);
            else 
            {
                jComboBoxBit.addItem(""+format.getSampleSizeInBits()+" bit");
                jComboBoxBit.setSelectedItem(""+format.getSampleSizeInBits()+" bit");
            }
        
            if (format.isBigEndian()) jComboBoxEndian.setSelectedIndex(1);
            else jComboBoxEndian.setSelectedIndex(0);
            
            int framesize = (format.getSampleSizeInBits()/8)*format.getChannels();
            jTextFieldFrameSize.setText(""+framesize);
        }
        
        AudioFormat getAudioFormat(String filename)
        {
            try
            {
                AudioFileFormat aff;
                AudioInputStream ais;
                File file = new File(filename);
                aff = AudioSystem.getAudioFileFormat(file);
                return aff.getFormat();
            }
            catch (Throwable e)
            {
                log.addLog(e, WARN);
            }
            return null;
        }
        
        // assumes little endian in sound!
        void normalize()
        {
            byte[] orgData16 = sound.getLeftData();
            double max = 0;
            int size = orgData16.length/2;

            int andBits = 0xffff;
            if (jComboBoxNormalize.getSelectedIndex()==0) // peak
                ;
            else if (jComboBoxNormalize.getSelectedIndex()==1) // 1bit // we start with 3 instead of 7, since the last bit is the sign bit, and we use ABS anyway
                andBits = 0x3fff;
            else if (jComboBoxNormalize.getSelectedIndex()==2) // 2bit
                andBits = 0x1fff;
            else if (jComboBoxNormalize.getSelectedIndex()==3) // 3bit
                andBits = 0x0fff;
            else if (jComboBoxNormalize.getSelectedIndex()==4) // 3bit
                andBits = 0x07ff;
            

            for (int index=0; index<size; index++)
            {
                int index16 = index*2;
                int data16;
                data16 = ((orgData16[index16 + 1] << 8) | (orgData16[index16] & 0xFF));

                if (max < (Math.abs(data16 )& andBits) ) max = (Math.abs(data16) & andBits);
            }
            
            double scale = 32767.0/ max; 
            for (int index=0; index<size; index++)
            {
                int index16 = index*2;
                int data16;
                int newData;
                data16 = ((orgData16[index16 + 1] << 8) | (orgData16[index16] & 0xFF));

                boolean neg = data16<0;
                newData =Math.abs(data16);

                if (newData > andBits) newData = andBits; // high data should STAY hi!
                newData =(int) (((double)(newData & andBits))* scale);

                newData = newData * (neg?-1:1);
                orgData16[index16] = (byte) (newData & 0xFF);
                orgData16[index16+1] = (byte) ((newData>>8) & 0xFF);
            }
            
            
            
            
            
            sound.setLeftData(orgData16);
            sound.setRightData(orgData16);
            paintSamples();
        }

}
