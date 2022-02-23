/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx;


import de.malban.Global;
import de.malban.vide.vecx.devices.LightpenDevice;
import de.malban.vide.VideConfig;
import de.malban.config.Configuration;
import de.malban.graphics.GFXVector;
import de.malban.graphics.GFXVectorList;
import de.malban.gui.CSAMainFrame;
import de.malban.gui.CloseWatcher;
import de.malban.gui.HotKey;
import de.malban.gui.ImageCache;
import de.malban.gui.Scaler;
import de.malban.gui.Stateable;
import de.malban.gui.Windowable;
import de.malban.gui.components.CSAView;
import de.malban.gui.dialogs.InternalFrameFileChoser;
import de.malban.gui.dialogs.ShowErrorDialog;
import de.malban.gui.panels.LogPanel;
import de.malban.input.ControllerEvent;
import de.malban.jogl.JOGLSupport;


import de.malban.vide.ControllerConfig;
import de.malban.vide.dissy.DissiPanel;
import de.malban.vide.dissy.MemoryInformation;
import static de.malban.vide.vecx.VecX.SS_RING_BUFFER_SIZE;
import static de.malban.vide.vecx.VecX.START_TYPE_INJECT;
import static de.malban.vide.vecx.VecX.START_TYPE_RUN;
import de.malban.vide.vecx.cartridge.Cartridge;
import de.malban.vide.vecx.VecX.VectrexDisplayVectors;
import de.malban.vide.vecx.VecXState.vector_t;
import static de.malban.vide.vecx.VecXStatics.EMU_EXIT_BREAKPOINT_BREAK;
import static de.malban.vide.vecx.VecXStatics.EMU_TIMER;
import static de.malban.vide.vecx.VecXStatics.VECTREX_MHZ;
import de.malban.vide.vecx.cartridge.AT24C02;
import static de.malban.vide.vecx.cartridge.Cartridge.convertSeperator;
import de.malban.vide.vecx.cartridge.CartridgeProperties;
import de.malban.vide.vecx.cartridge.DS2430A;
import de.malban.vide.vecx.cartridge.DS2431;
import de.malban.vide.vecx.cartridge.DualVec;
import de.malban.vide.vecx.cartridge.Microchip11AA010;
import de.malban.vide.vecx.devices.AbstractDevice;
import de.malban.vide.vecx.devices.Imager3dDevice;
import de.malban.vide.vecx.devices.JoyportDevice;
import de.malban.vide.vecx.devices.JInputJoystickDevice;
import de.malban.vide.vecx.devices.JInputSpinnerDevice;
import de.malban.vide.vecx.devices.KeyboardJoystickDevice;
import de.malban.vide.vecx.devices.KeyboardSpinnerDevice;
import de.malban.vide.vecx.devices.NullDevice;
import de.malban.vide.vecx.devices.VecLinkV1Device;
import de.malban.vide.vecx.devices.VecLinkV2Device;
import de.malban.vide.vecx.devices.VecSpeechDevice;
import de.malban.vide.vecx.devices.VectrexJoyport;
import java.awt.Color;
import java.awt.Graphics;
import java.awt.event.MouseEvent;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.Serializable;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.SwingUtilities;
import de.malban.vide.vecx.panels.AnalogJPanel;
import de.malban.vide.vecx.panels.BreakpointJPanel;
import de.malban.vide.vecx.panels.CartridgePanel;
import de.malban.vide.vecx.panels.JoyportPanel;
import de.malban.vide.vecx.panels.LabelJPanel;
import de.malban.vide.vecx.panels.MemoryDumpPanel;
import de.malban.vide.vecx.panels.PSGJPanel;
import de.malban.vide.vecx.panels.ProfileJPanel;
import de.malban.vide.vecx.panels.RegisterJPanel;
import de.malban.vide.vecx.panels.VIAJPanel;
import de.malban.vide.vecx.panels.VarJPanel;
import de.malban.vide.vecx.panels.VectorInfoJPanel;
import de.malban.vide.vecx.panels.WRTrackerJPanel;
import de.malban.vide.vedi.DebugInfoC;
import java.awt.Point;
import java.awt.Rectangle;
import java.awt.event.ActionEvent;
import static java.awt.event.ActionEvent.SHIFT_MASK;
import java.time.LocalDateTime;
import javax.swing.AbstractAction;
import javax.swing.DefaultComboBoxModel;
import javax.swing.JPanel;

/**
 *
 * @author malban
 */
public class VecXPanel extends javax.swing.JPanel  
    implements  Windowable, 
                DisplayerInterface, 
                VecXStatics, 
                Stateable, CloseWatcher
{
    public boolean isLoadSettings() { return true; }
    LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
    VideConfig config = VideConfig.getConfig();
    protected CSAView mParent = null;
    protected javax.swing.JMenuItem mParentMenuItem = null;
    protected int mClassSetting=0;
    VecX vecx;
    
    boolean cartProp = true;
    
    BufferedImage overlayImageOrg=null;
    
    boolean updateAllways = false;
    
    public boolean stop = false;
    public volatile boolean running = false;
    public boolean pausing = false;
    protected boolean pauseMode = false;
    public boolean debuging = false;
    public boolean stepping = false;
    public boolean mouseMode = false;
    
    public vector_t getFound()
    {
        return found;
    }
    public void setFound(vector_t v)
    {
        found = v;
    }
    vector_t found = null;
    vector_t lastfound = null;
    
    int exitReason = 0;
    
    Color crossColor = Color.ORANGE;
    boolean noCross = true;
    int mX=0;
    int mY=0;
    int mXPressStart = 0;
    int mYPressStart = 0;
    boolean shiftPressed = false;
    boolean mousePressed = false;
    boolean noDissiFirstLine = false;
    
    Thread one = null;
    boolean dissiInit = false;
    DissiPanel dissi=null;
    RegisterJPanel regi = null;
    VectorInfoJPanel vinfi = null;
    MemoryDumpPanel dumpi = null;
    VIAJPanel viai = null;
    AnalogJPanel ani = null;
    VarJPanel vari = null;
    BreakpointJPanel breaki = null;
    ProfileJPanel profi = null;
    LabelJPanel labi = null;
    WRTrackerJPanel tracki = null;
    PSGJPanel ayi = null;
    JoyportPanel joyi = null;
    CartridgePanel carti = null;
    
    public VectorInfoJPanel getVinfi()
    {
        return vinfi;
    }

    int startTypeRun = START_TYPE_RUN;

    boolean ignoreClose = false;

    public void preClose()
    {
        ignoreClose = true;
    }
    public void postClose()
    {
        ignoreClose = false;
    }
    
    @Override
    public void closing()
    {
        if (ignoreClose) return;
        deinit();
        if (vecx!=null)
        {
            vecx.deinit();
        }
    }
    @Override
    public void setParentWindow(CSAView jpv)
    {
        mParent = jpv;
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
        if (displayPanel != null)
            displayPanel.deinit();
        jButtonStopActionPerformed(null);                                            
        resetMe();
        AbstractDevice.exitSync = true;
        DualVec.exitSync = true;
    }
    /**
     * Creates new form DissiPanel
     */
    public VecXPanel() {
        AbstractDevice.exitSync = false;
        DualVec.exitSync = false;
        initComponents();
        //jCheckBox1.setVisible(false);
        vecx = new VecX();
        ensureDevices();
        initJoyportsFromFlag();
        vecx.setDisplayer(this);
        updatePorts();
        changeDisplay();
        
        new HotKey("Pause/Toggle", new AbstractAction() { public void actionPerformed(ActionEvent e) {  jButtonPauseActionPerformed(null); }}, this);
        new HotKey("Overlay/Toggle", new AbstractAction() { public void actionPerformed(ActionEvent e) { config.overlayEnabled = !config.overlayEnabled; checkOverlay();}}, this);
        new HotKey("VecX QuickSave", new AbstractAction() { public void actionPerformed(ActionEvent e) {  jButtonSaveStateActionPerformed(null); }}, this);
        new HotKey("VecX QuickLoad", new AbstractAction() { public void actionPerformed(ActionEvent e) {  jButtonLoadStateActionPerformed(null); }}, this);
        new HotKey("RingbufferToggle", new AbstractAction() { public void actionPerformed(ActionEvent e) {  ringbufferToggle(); }}, this);

        new HotKey("Panel/Toggle", new AbstractAction() { public void actionPerformed(ActionEvent e) { toggleMainPanel();}}, this);
        new HotKey("FullScreen/Toggle", new AbstractAction() { public void actionPerformed(ActionEvent e) { toggleFullscreen();}}, this);

        new HotKey("Quit vecxi", new AbstractAction() { public void actionPerformed(ActionEvent e) { quitVecxi();}}, this);
    }
    void ringbufferToggle()
    {
        config.ringbufferActive = !config.ringbufferActive;
    }
            /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jPanel1 = new javax.swing.JPanel();
        jLabel1 = new javax.swing.JLabel();
        jComboBoxJoyport1 = new javax.swing.JComboBox();
        jLabel2 = new javax.swing.JLabel();
        jComboBoxJoyport0 = new javax.swing.JComboBox();
        jButtonPause = new javax.swing.JButton();
        jButtonStop = new javax.swing.JButton();
        jButtonFileSelect1 = new javax.swing.JButton();
        jLabelFPS = new javax.swing.JLabel();
        jTextFieldstart = new javax.swing.JTextField();
        jButtonDebug = new javax.swing.JButton();
        jLabel5 = new javax.swing.JLabel();
        jButtonLoadState = new javax.swing.JButton();
        jButtonSaveState = new javax.swing.JButton();
        jButtonStart = new javax.swing.JButton();
        jCheckBox1 = new javax.swing.JCheckBox();

        setBackground(new java.awt.Color(0, 0, 0));
        setName("vecxy"); // NOI18N
        addMouseMotionListener(new java.awt.event.MouseMotionAdapter() {
            public void mouseDragged(java.awt.event.MouseEvent evt) {
                formMouseDragged(evt);
            }
            public void mouseMoved(java.awt.event.MouseEvent evt) {
                formMouseMoved(evt);
            }
        });
        addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseEntered(java.awt.event.MouseEvent evt) {
                formMouseEntered(evt);
            }
            public void mouseExited(java.awt.event.MouseEvent evt) {
                formMouseExited(evt);
            }
            public void mousePressed(java.awt.event.MouseEvent evt) {
                formMousePressed(evt);
            }
            public void mouseReleased(java.awt.event.MouseEvent evt) {
                formMouseReleased(evt);
            }
        });
        addComponentListener(new java.awt.event.ComponentAdapter() {
            public void componentResized(java.awt.event.ComponentEvent evt) {
                formComponentResized(evt);
            }
        });
        setLayout(null);

        jLabel1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/Port.png"))); // NOI18N
        jLabel1.setText("1");
        jLabel1.setPreferredSize(new java.awt.Dimension(43, 21));

        jComboBoxJoyport1.setModel(new javax.swing.DefaultComboBoxModel(new String[] { " ", "Keyboard Controler", "Lightpen", "VecVox", "VecVoice", "VecLinkV1", "VecLinkV2", "3d-Imager" }));
        jComboBoxJoyport1.setFocusable(false);
        jComboBoxJoyport1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBoxJoyport1ActionPerformed(evt);
            }
        });

        jLabel2.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/Port.png"))); // NOI18N
        jLabel2.setText("0");
        jLabel2.setPreferredSize(new java.awt.Dimension(43, 21));

        jComboBoxJoyport0.setModel(new javax.swing.DefaultComboBoxModel(new String[] { " ", "Keyboard Controler", "Lightpen" }));
        jComboBoxJoyport0.setFocusable(false);
        jComboBoxJoyport0.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBoxJoyport0ActionPerformed(evt);
            }
        });

        jButtonPause.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/control_pause.png"))); // NOI18N
        jButtonPause.setToolTipText("Pauses current running emulation...");
        jButtonPause.setFocusable(false);
        jButtonPause.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonPause.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonPauseActionPerformed(evt);
            }
        });

        jButtonStop.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/control_stop.png"))); // NOI18N
        jButtonStop.setToolTipText("Stops and unloads ROM!");
        jButtonStop.setFocusable(false);
        jButtonStop.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonStop.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonStopActionPerformed(evt);
            }
        });

        jButtonFileSelect1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/folder_go.png"))); // NOI18N
        jButtonFileSelect1.setFocusable(false);
        jButtonFileSelect1.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonFileSelect1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonFileSelect1ActionPerformed(evt);
            }
        });

        jLabelFPS.setFont(new java.awt.Font("Geneva", 0, 8)); // NOI18N
        jLabelFPS.setText("0");
        jLabelFPS.setPreferredSize(new java.awt.Dimension(5, 21));

        jTextFieldstart.setText("FROGGER.BIN");
        jTextFieldstart.setFocusable(false);
        jTextFieldstart.setName("vecxy"); // NOI18N
        jTextFieldstart.setPreferredSize(new java.awt.Dimension(75, 21));

        jButtonDebug.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/bug_go.png"))); // NOI18N
        jButtonDebug.setToolTipText("Associate dissi with this vecx instance.");
        jButtonDebug.setFocusable(false);
        jButtonDebug.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonDebug.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonDebugActionPerformed(evt);
            }
        });

        jLabel5.setHorizontalAlignment(javax.swing.SwingConstants.TRAILING);
        jLabel5.setText("Bin File");
        jLabel5.setPreferredSize(new java.awt.Dimension(38, 21));

        jButtonLoadState.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/page_go.png"))); // NOI18N
        jButtonLoadState.setToolTipText("load state");
        jButtonLoadState.setFocusable(false);
        jButtonLoadState.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonLoadState.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonLoadStateActionPerformed(evt);
            }
        });

        jButtonSaveState.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/page_save.png"))); // NOI18N
        jButtonSaveState.setToolTipText("save state");
        jButtonSaveState.setFocusable(false);
        jButtonSaveState.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonSaveState.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSaveStateActionPerformed(evt);
            }
        });

        jButtonStart.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/control_play.png"))); // NOI18N
        jButtonStart.setToolTipText("<html>Starts selected ROM, no effect if running!<BR>\nSHIFT click resets and starts new!\n</html>\n"); // NOI18N
        jButtonStart.setFocusable(false);
        jButtonStart.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonStart.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonStartActionPerformed(evt);
            }
        });

        jCheckBox1.setText("Peer Output");
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
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel5, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel1, javax.swing.GroupLayout.PREFERRED_SIZE, 53, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addComponent(jTextFieldstart, javax.swing.GroupLayout.PREFERRED_SIZE, 100, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jButtonFileSelect1)
                        .addGap(2, 2, 2)
                        .addComponent(jLabelFPS, javax.swing.GroupLayout.PREFERRED_SIZE, 18, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(0, 0, 0)
                        .addComponent(jButtonStart)
                        .addGap(5, 5, 5)
                        .addComponent(jButtonPause))
                    .addComponent(jComboBoxJoyport1, 0, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jComboBoxJoyport0, 0, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addGap(5, 5, 5)
                        .addComponent(jButtonStop)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButtonSaveState)
                        .addGap(6, 6, 6)
                        .addComponent(jButtonLoadState)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButtonDebug))
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jCheckBox1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)))
                .addContainerGap(29, Short.MAX_VALUE))
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                .addComponent(jButtonFileSelect1, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jTextFieldstart, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jLabel5, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jButtonDebug, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jButtonLoadState, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jLabelFPS, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel1Layout.createSequentialGroup()
                                    .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                        .addComponent(jButtonPause, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addComponent(jButtonStart, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                                    .addGap(1, 1, 1)))
                            .addComponent(jButtonStop, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jButtonSaveState, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(0, 0, 0)
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addComponent(jLabel2, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jComboBoxJoyport0, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)))
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addGap(0, 0, Short.MAX_VALUE)
                        .addComponent(jCheckBox1)))
                .addGap(1, 1, 1)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jComboBoxJoyport1, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)))
        );

        add(jPanel1);
        jPanel1.setBounds(0, 0, 380, 65);
        jPanel1.getAccessibleContext().setAccessibleDescription("");
    }// </editor-fold>//GEN-END:initComponents

    static String lastOpenedDir = Global.mainPathPrefix;
    private void jButtonFileSelect1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonFileSelect1ActionPerformed
        InternalFrameFileChoser fc = new de.malban.gui.dialogs.InternalFrameFileChoser();
        fc.setCurrentDirectory(new java.io.File(lastOpenedDir));
        int r = fc.showOpenDialog(Configuration.getConfiguration().getMainFrame());
        if (r != InternalFrameFileChoser.APPROVE_OPTION) return;
        String name = fc.getSelectedFile().getAbsolutePath();
        lastOpenedDir = new File(name).getAbsolutePath();
        jTextFieldstart.setText(name);
    }//GEN-LAST:event_jButtonFileSelect1ActionPerformed

    public void resetCurrent()
    {
        jButtonStopActionPerformed(null); // stop
        jButtonStartActionPerformed(null);
    }
    public void resetCurrent(boolean softreset)
    {
        if (isPausing())
            vecx.vecx_reset(!softreset);
        else
        {
            jButtonPauseActionPerformed(null);
            vecx.vecx_reset(!softreset);
            jButtonPauseActionPerformed(null);
        }
    }
    
    private void jButtonStartActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonStartActionPerformed
        updatefinished = true;
        usedCDebug = null;

        if (evt != null)
        {
            if (((evt.getModifiers() & SHIFT_MASK) == SHIFT_MASK))
            {
                jButtonStopActionPerformed(evt); // stop
                // ... and run :-)... meaning go on...
            }
        }

        if (startTypeRun != START_TYPE_INJECT)
        {
            if (stepping) 
            {
                debugMultistepAction();
            }
            if (isDebuging())
            {
                oneStep();
                return;
            }
            if (isPausing())
            {
                cont();
                return;
            }
            if (isRunning()) return;
        }
        else
        {
            stop = true;
            while (running);
        }
        if (config.debugingCore)
        {
            if (dissi == null)
            {
                createDissi();
                if (dissi == null) return; 
            }
            setDissi(dissi);
        }
        

        
        if (startTypeRun != START_TYPE_INJECT)
        {
            boolean ok = vecx.init(jTextFieldstart.getText(), cartProp, true);
            if (!ok)
                return;
            if (dissi != null)
            {
                dissi.dis(vecx.cart);
                if (startTypeRun == VecX.START_TYPE_DEBUG)
                    dissi.setStartbreakpoint();
            }
            if (config.overlayEnabled)
                loadOverlay(jTextFieldstart.getText()); // ensure overlay in scaled form is available
            checkWindows();
            initJoyportsFromFlag();
        }
        else
        {
            vecx.inject(jTextFieldstart.getText(), cartProp);
            if (dissi != null)
                dissi.dis(vecx.cart);
        }
        
        if (config.debugingCore)
        {
            dissiInit = true;
            dissi.processHeyDissis();
        }        
        
        stop = true;
        setLED(0);
        changeDisplay();
        updatePorts();
        if (startTypeRun != START_TYPE_INJECT)
        {
            start();            
        }
        else
        {
            if (!isDebuging())
            {
                if (!stepping)
                    start();            
            }
        }

    }//GEN-LAST:event_jButtonStartActionPerformed
    public void startUp(String path)
    {
        startUp(path, true);
    }
    public void startUp(String path, boolean checkCartridge)
    {
        startUp( path,  checkCartridge, START_TYPE_RUN);
    }
    
    public String getStartName()
    {
        return jTextFieldstart.getText();
    }
    public void startUp(String path, boolean checkCartridge, int runType)
    {
        startTypeRun = runType;
        changeDisplay();
        if (runType != START_TYPE_INJECT) 
            jButtonStopActionPerformed(null);
        jTextFieldstart.setText(path);
        cartProp = false;
        jButtonStartActionPerformed(null);
        cartProp = true;
        
        jTextFieldstart.setText("");
    }
    public void startBin(String path)
    {
        startTypeRun = START_TYPE_RUN;
        changeDisplay();
        jTextFieldstart.setText(path);
        cartProp = true;
        jButtonStartActionPerformed(null);
    }

    public boolean loadOverlay(String name)
    {
        try
        {
            overlayImageOrg = null;
            if ((forcedOverlay!=null) && (forcedOverlay.length() != 0))
            {
                overlayImageOrg = ImageCache.getImageCache().getImage(forcedOverlay);
            }
            if (overlayImageOrg == null)
            {
                Path base = Paths.get(Global.mainPathPrefix);
                Path fromPath = base.resolve(Paths.get(name));
                String pathOnly = fromPath.getParent().toString();
                if (pathOnly==null) pathOnly = Global.mainPathPrefix+File.separator;
                if (!pathOnly.endsWith(File.separator))pathOnly+=File.separator;
                
                
                
                String fName = fromPath.getFileName().toString();

                String fullname = fromPath.toString();
                fullname  = de.malban.util.UtilityString.replaceCI(fullname, ".rom", ".png");
                fullname = de.malban.util.UtilityString.replaceCI(fullname, ".bin", ".png");
                fullname = de.malban.util.UtilityString.replaceCI(fullname, ".vec", ".png");

                name = de.malban.util.UtilityString.replaceCI(fName, ".rom", ".png");
                name = de.malban.util.UtilityString.replaceCI(name, ".bin", ".png");
                name = de.malban.util.UtilityString.replaceCI(name, ".vec", ".png");
                
                overlayImageOrg = ImageCache.getImageCache().getImage(Global.mainPathPrefix+"overlays"+File.separator+name);
                if (overlayImageOrg==null) overlayImageOrg = ImageCache.getImageCache().getImage(name);
                if (overlayImageOrg==null) overlayImageOrg = ImageCache.getImageCache().getImage(Global.mainPathPrefix+File.separator+name);
                if (overlayImageOrg==null) overlayImageOrg = ImageCache.getImageCache().getImage(Global.mainPathPrefix+File.separator+"overlays"+File.separator+name);
                if (overlayImageOrg==null) overlayImageOrg = ImageCache.getImageCache().getImage(Global.mainPathPrefix+File.separator+"overlays"+File.separator+"homemade"+File.separator+name);
                if (overlayImageOrg==null) overlayImageOrg = ImageCache.getImageCache().getImage(fullname);
                
                if (overlayImageOrg==null) overlayImageOrg = ImageCache.getImageCache().getImage(pathOnly+"overlays"+File.separator+name);
                if (overlayImageOrg==null) overlayImageOrg = ImageCache.getImageCache().getImage(pathOnly+name);
                if (overlayImageOrg==null) overlayImageOrg = ImageCache.getImageCache().getImage(pathOnly+".."+File.separator+"overlays"+File.separator+name);
                if (overlayImageOrg==null) overlayImageOrg = ImageCache.getImageCache().getImage(pathOnly+".."+File.separator+name);
                
                if (overlayImageOrg==null) overlayImageOrg = ImageCache.getImageCache().getImage(pathOnly+"overlay"+File.separator+name);
                if (overlayImageOrg==null) overlayImageOrg = ImageCache.getImageCache().getImage(pathOnly+name);
                if (overlayImageOrg==null) overlayImageOrg = ImageCache.getImageCache().getImage(pathOnly+".."+File.separator+"overlay"+File.separator+name);
                if (overlayImageOrg==null) overlayImageOrg = ImageCache.getImageCache().getImage(pathOnly+".."+File.separator+name);
                
            }
        }
        catch (Throwable e)
        {
            
        }
        if (overlayImageOrg==null) 
        {
            if (name.toUpperCase().contains("SYSTEM"))
                overlayImageOrg = ImageCache.getImageCache().getImage(Global.mainPathPrefix+"overlays"+File.separator+"mine.png");
        }
        if (overlayImageOrg==null) return false;
        overlayChanged();            
        
        return true;
    }
    
    private void jButtonPauseActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonPauseActionPerformed
        updatefinished = true;
        if (isPausing())
        {
            cont();
            return;
        }
        pause();
    }//GEN-LAST:event_jButtonPauseActionPerformed

    
    private void createDissi()
    {
        CSAMainFrame f = (CSAMainFrame) mParent;
        dissi = f.getDissi();
    }
    // stops debugging,
    // if not debugging does nothing
    public void run()
    {
        if (isDebuging()) 
            debugAction();
    }
    public void debugAction()
    {
        vecx.directDrawActive = true; // once -> so an update occurs defineitly!
        updatefinished = true;
        // start running in debug mode
        // or go to pause and debug
        if (isDebuging())
        {
            //            Switch Debug Off
            stepping = false;
            stopDebug(false);
            vecx.config.syncCables = false;
            return;
        }
        if (!isRunning())
        {
            vecx.init(jTextFieldstart.getText());
            initJoyportsFromFlag();
            if (config.overlayEnabled)
                loadOverlay(vecx.romName);
            stop = true;
            startDebug();
            if (dissi == null)
            {
                createDissi();
                if (dissi == null) return; 
            }
            setDissi(dissi);
            dissi.dis(vecx.cart);
            dissiInit = true;
            checkWindows();
            oneStep();
        }
        else
        {
            // start debugging while running
            vecx.config.debugingCore = true;
            vecx.directDrawActive = true;
            startDebug();
        
            if (!dissiInit)
            {
                if (dissi == null)
                {
                    createDissi();
                    if (dissi == null) return; 
                }
                setDissi(dissi);
                if (regi!= null) regi.setDissi(dissi);
                dissi.dis(vecx.cart);
                dissiInit = true;
            }
            checkWindows();
            oneStep();
        }        
    }
    void quitVecxi()
    {
        // only if in cli started
        if (config.doExitAfterVecxi) 
        {
            jButtonStopActionPerformed(null);
            ((CSAMainFrame)mParent).doExit();
        }
    }
    private void jButtonStopActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonStopActionPerformed
        updatefinished = true;
        stop();
        if (dissi != null)
            dissi.deinit();
        dissiInit = false;
        overlayImageOrg = null;
        overlayChanged();

    }//GEN-LAST:event_jButtonStopActionPerformed
    private void formComponentResized(java.awt.event.ComponentEvent evt) {//GEN-FIRST:event_formComponentResized
        forceResize();
        SwingUtilities.invokeLater(new Runnable()
        {
            public void run()
            {
                forceResize();
            }
        });                    
    }//GEN-LAST:event_formComponentResized

    static class VeryCompleteState implements Serializable
    {
        ArrayList<Breakpoint> breakpoints[] = new ArrayList[Breakpoint.BP_TARGET_COUNT];
        
        int SS_RING_BUFFER_SIZE = 30000;
        int ringSSWalkStep = 0; // if I step back, what is the position of the step back?
        int ringSSBufferNext = 0;
        CompleteState[] goSSBackRingBuffer;


        int FRAME_RING_BUFFER_SIZE = 1000;
        int ringFrameWalkStep = 0; // if I step back, what is the position of the step back?
        int ringFrameBufferNext = 0;
        CompleteState[] goFrameBackRingBuffer;
    }
 
    private void jButtonSaveStateActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSaveStateActionPerformed
        LocalDateTime ldt = LocalDateTime.now(); 
        VeryCompleteState vcs = null;

        if (evt != null)
        {
            shiftPressed = ((evt.getModifiers() & SHIFT_MASK) == SHIFT_MASK);

            if (shiftPressed)
            {
                vcs = new VeryCompleteState();
                vcs.breakpoints = vecx.breakpoints;
                vcs.SS_RING_BUFFER_SIZE = vecx.SS_RING_BUFFER_SIZE;
                vcs.ringSSWalkStep = vecx.ringSSWalkStep;
                vcs.ringSSBufferNext = vecx.ringSSBufferNext;
                vcs.goSSBackRingBuffer = vecx.goSSBackRingBuffer;

                vcs.FRAME_RING_BUFFER_SIZE = vecx.FRAME_RING_BUFFER_SIZE;
                vcs.ringFrameWalkStep = vecx.ringFrameWalkStep;
                vcs.ringFrameBufferNext = vecx.ringFrameBufferNext;
                vcs.goFrameBackRingBuffer = vecx.goFrameBackRingBuffer;
            }
        }
        
        
        if ((!running)&& (!debuging)) return;
        if (stop) 
        {
            if (debuging)
            {
                CompleteState state = vecx.getState();
                state.additional = vcs;

                
                if (vecx.joyport[0]!=null)
                {
                    if (vecx.joyport[0].getDevice()!=null)
                    {
                        state.deviceID0 = vecx.joyport[0].getDevice().getDeviceID();
                        state.deviceName0 = vecx.joyport[0].getDevice().getDeviceName();

                    }
                }
                if (vecx.joyport[1]!=null)
                {
                    if (vecx.joyport[1].getDevice()!=null)
                    {
                        state.deviceID1 = vecx.joyport[1].getDevice().getDeviceID();
                        state.deviceName1 = vecx.joyport[1].getDevice().getDeviceName();

                    }
                }
                CSAMainFrame.serialize(state, Global.mainPathPrefix+"serialize"+File.separator+"StateSaveTest.ser");
                CSAMainFrame.serialize(state, Global.mainPathPrefix+"serialize"+File.separator+"StateSaveTest_"+ldt.toString().replace(':','_')+".ser");
                state.additional = null;
            }
            return;
        } 
        if (!isPausing())
        {
            pause();
            while (!pauseMode)
            {
                try {
                    Thread.sleep(10);
                } catch (InterruptedException ex) {
                    Logger.getLogger(VecXPanel.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
            CompleteState state = vecx.getState();
            state.additional = vcs;
            
            if (vecx.joyport[0]!=null)
            {
                if (vecx.joyport[0].getDevice()!=null)
                {
                    state.deviceID0 = vecx.joyport[0].getDevice().getDeviceID();
                    state.deviceName0 = vecx.joyport[0].getDevice().getDeviceName();
                    
                }
            }
            if (vecx.joyport[1]!=null)
            {
                if (vecx.joyport[1].getDevice()!=null)
                {
                    state.deviceID1 = vecx.joyport[1].getDevice().getDeviceID();
                    state.deviceName1 = vecx.joyport[1].getDevice().getDeviceName();
                    
                }
            }
            CSAMainFrame.serialize(state, Global.mainPathPrefix+"serialize"+File.separator+"StateSaveTest.ser");
            CSAMainFrame.serialize(state, Global.mainPathPrefix+"serialize"+File.separator+"StateSaveTest_"+ldt.toString()+".ser");
            state.additional = null;
            cont();
            return;
        }
        CompleteState state = vecx.getState();
        state.additional = vcs;
        if (vecx.joyport[0]!=null)
        {
            if (vecx.joyport[0].getDevice()!=null)
            {
                state.deviceID0 = vecx.joyport[0].getDevice().getDeviceID();
                state.deviceName0 = vecx.joyport[0].getDevice().getDeviceName();

            }
        }
        if (vecx.joyport[1]!=null)
        {
            if (vecx.joyport[1].getDevice()!=null)
            {
                state.deviceID1 = vecx.joyport[1].getDevice().getDeviceID();
                state.deviceName1 = vecx.joyport[1].getDevice().getDeviceName();

            }
        }
        CSAMainFrame.serialize(state, Global.mainPathPrefix+"serialize"+File.separator+"StateSaveTest.ser");
        CSAMainFrame.serialize(state, Global.mainPathPrefix+"serialize"+File.separator+"StateSaveTest_"+ldt.toString()+".ser");
        state.additional = null;

    }//GEN-LAST:event_jButtonSaveStateActionPerformed
    private void jButtonLoadStateActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonLoadStateActionPerformed
        boolean oldPause = isPausing();
        boolean oldDebug = debuging;
        updatefinished = true;
        stop();
        dissiInit = false;

        CompleteState state = (CompleteState) CSAMainFrame.deserialize(Global.mainPathPrefix+"serialize"+File.separator+"StateSaveTest.ser");
        if (state == null) return;
        
        if (!vecx.putState(state)) return;
//        if (!vecx.loadStateFromFile("")) return;

        mClassSetting++;
        if (state.deviceID0 != -1)
        {
            JoyportDevice device = getDevice(state.deviceID0, state.deviceName0);
            vecx.joyport[0].plugIn(device);
            if (device == null)
            {
                jComboBoxJoyport0.setSelectedIndex(-1);
            }
            else
            {
                jComboBoxJoyport0.setSelectedItem(device);
            }
        }
        if (state.deviceID1 != -1)
        {
            JoyportDevice device1;
            if (state.deviceID1 == DEVICE_IMAGER)
            {
                device1 = vecx.joyport[1].getDevice();
                if (device1 != null)
                {
                    if (device1 instanceof Imager3dDevice)
                    {
                        replaceDeviceInList(device1);
                        jComboBoxJoyport1.setSelectedItem(vecx.joyport[1].getDevice());
                    }
                }
            }
            else
            {
                device1 = getDevice(state.deviceID1, state.deviceName1);
                vecx.joyport[1].plugIn(device1);
            }
            if (device1 == null)
            {
                jComboBoxJoyport1.setSelectedIndex(-1);
            }
            else
            {
                jComboBoxJoyport1.setSelectedItem(device1);
            }
        }
        mClassSetting--;

        
        if (state.additional != null)
        {
            if (state.additional instanceof VeryCompleteState)
            {
                VeryCompleteState vcs = (VeryCompleteState) state.additional;
                vecx.breakpoints = vcs.breakpoints;
        setAllBreakpoints(vcs.breakpoints);

                vecx.SS_RING_BUFFER_SIZE = vcs.SS_RING_BUFFER_SIZE;
                vecx.ringSSWalkStep = vcs.ringSSWalkStep;
                vecx.ringSSBufferNext = vcs.ringSSBufferNext;
                vecx.goSSBackRingBuffer = vcs.goSSBackRingBuffer;
                
                vecx.FRAME_RING_BUFFER_SIZE = vcs.FRAME_RING_BUFFER_SIZE;
                vecx.ringFrameWalkStep = vcs.ringFrameWalkStep;
                vecx.ringFrameBufferNext = vcs.ringFrameBufferNext;
                vecx.goFrameBackRingBuffer = vcs.goFrameBackRingBuffer;
            }
        }
        
        
        
        
        jTextFieldstart.setText(vecx.romName);
        overlayImageOrg = null;
        if (config.overlayEnabled)
            loadOverlay(vecx.romName);
        
        if (dissi == null)
        {
            createDissi();
            if (dissi == null) return; 
        }
        setDissi(dissi);
        dissi.dis(vecx.cart);
        
        dissi.setDissiBank(vecx.cart.getCurrentBank());
        dissiInit = true;
        if (config.overlayEnabled)
            loadOverlay(jTextFieldstart.getText()); // ensure overlay in scaled form is available
        dissi.processHeyDissis();
        
        checkWindows();
        changeDisplay();
        
waitAMoment = true;        
 start();
 
        if (oldPause) 
        {
 while (!running); // this is bad!
            pause();
        }
       
        if (oldDebug) 
        {
 while (!running); // this is bad!
            
            debugAction();
        }
waitAMoment = false;        

    }//GEN-LAST:event_jButtonLoadStateActionPerformed
    public void debugFrameUndoAction(int s)
    {
        updatefinished = true;
        if (!isDebuging())
            return;
        if (stepping) return;
        vecx.stepBackInFrameRingbuffer(s);
        updateDisplay();
        repaint();
        updateAvailableWindows(true, false, true);
    }    
    public void debugFrameRedoAction(int s)
    {
        updatefinished = true;
        if (!isDebuging())
            return;
        if (stepping) return;
        vecx.stepForwardInFrameRingbuffer(s);
        updateDisplay();
        repaint();
        updateAvailableWindows(true, false, true);
    }    

    public void debugUndoAction(int s)
    {
        if (!isDebuging())
            return;
        if (stepping) return;
        vecx.stepBackInSSRingbuffer(s);
        updateDisplay();
        repaint();
        updateAvailableWindows(true, false, true);
    }    
    public void debugRedoAction(int s)
    {
        if (!isDebuging())
            return;
        if (stepping) return;
        vecx.stepForwardInSSRingbuffer(s);
        updateDisplay();
        repaint();
        updateAvailableWindows(true, false, true);
    }    
    
    public void debugStepoutAction()
    {
        updatefinished = true;
        if (!isDebuging())
            return;
        if (stepping) return;
        // set breakpoint
        int adr = vecx.getStepoutAddress();
        if (adr == -1) return;
        Breakpoint bp = new Breakpoint();
        bp.targetAddress = adr;
        bp.targetBank = vecx.cart.getCurrentBank();
        bp.targetType = Breakpoint.BP_TARGET_CPU;
        bp.targetSubType = Breakpoint.BP_SUBTARGET_CPU_PC;
        bp.type = Breakpoint.BP_COMPARE | Breakpoint.BP_ONCE| Breakpoint.BP_QUIET;
        breakpointMemorySet(bp);
        // and run
        vecx.directDrawActive = true;
        stopDebug(false);
        
    }
    
    public void debugOverstepAction()
    {
        updatefinished = true;
        if (!isDebuging())
            return;
        if (stepping) return;
        noDissiFirstLine = true;
        if (dissi == null) return; // I need dissi here :-)
        int adr = vecx.e6809.reg_pc;
        adr+=dissi.getInstructionLengthAt(adr);
        if (!dissi.hasBreakpoint(adr, vecx.cart.getCurrentBank()))
        {
            Breakpoint bp = new Breakpoint();
            bp.targetAddress = adr;
            bp.targetBank = vecx.cart.getCurrentBank();
            bp.targetType = Breakpoint.BP_TARGET_CPU;
            bp.targetSubType = Breakpoint.BP_SUBTARGET_CPU_PC;
            bp.type = Breakpoint.BP_COMPARE | Breakpoint.BP_ONCE| Breakpoint.BP_QUIET;
            breakpointMemorySet(bp);
        }
        // and run
        // stopping will be done by emualtion
        vecx.directDrawActive = true;
        stopDebug(false);
    }
    
    
    public void debugBreakpointAction()
    {
        updatefinished = true;
        if (stepping) return;
        if (dissi == null) return; // I need dissi here :-)
        int adr = dissi.getCurrentAddress();
        if (adr == -1) return; // no adress selected!
        Breakpoint bp = new Breakpoint();
        bp.targetAddress = adr;
        bp.targetBank = dissi.getCurrentBank();
        bp.targetType = Breakpoint.BP_TARGET_CPU;
        bp.targetSubType = Breakpoint.BP_SUBTARGET_CPU_PC;
        bp.type = Breakpoint.BP_COMPARE | Breakpoint.BP_MULTI;
            
        breakpointAddressToggle(bp);
    }   

    public void debugMultistepAction()
    {
        updatefinished = true;
        if (!isDebuging()) return;
        if (pausing)
        {
            pausing = false;
        }
        if (stepping)
        {
            stepping = false;
            startDebug();
            if (!dissiInit)
            {
                if (dissi == null)
                {
                    createDissi();
                    if (dissi == null) return; 
                }
                setDissi(dissi);
                if (regi!= null) regi.setDissi(dissi);
                dissi.dis(vecx.cart);
                dissiInit = true;
            }
            oneStep();
        }
        else
        {
            stepping = true;
            start();            
        }        
    }    
    public void debugStepAction()
    {
        updatefinished = true;
        if (stepping)
        {
            debugMultistepAction();
            return;
        }
        
        
        if (isDebuging())
        {
            oneStep();
            return;
        }
         
    }
    public boolean isMouseMode()
    {
        return mouseMode;
    }
    public void setMouseMode(boolean b)
    {
        mouseMode = b;
    }
    private void formMouseMoved(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_formMouseMoved

        if ((!mouseMode) && (!deviceList.get(DEVICE_LIGHTPEN).isActive())) return;
        mX=evt.getX();
        mY=evt.getY();
        if (!mouseMode) return;
        crossColor = Color.ORANGE;
        noCross = false;
        repaint();
        
    }//GEN-LAST:event_formMouseMoved

    public Color getCrossColor()
    {
        return crossColor;
    }
    
    public boolean isCrossDisabled()
    {
        return noCross;
    }
    private void formMouseExited(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_formMouseExited
        noCross = true;
    }//GEN-LAST:event_formMouseExited

    private void formMouseEntered(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_formMouseEntered
        noCross = false;
    }//GEN-LAST:event_formMouseEntered

    private void formMousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_formMousePressed

        if (config.tryJOGL)
        {
            if (displayPanel instanceof VecxiPanel_JOGL)
            {
                ((VecxiPanel_JOGL)displayPanel).getCorrectFocus();
            }
        }
        
        if ((!mouseMode) && (!deviceList.get(DEVICE_LIGHTPEN).isActive())) return;
        shiftPressed = false;
        if (evt.getButton() == MouseEvent.BUTTON1)
        {
            mousePressed = true;
            mXPressStart = evt.getX();
            mYPressStart = evt.getY();
            if ((evt != null ) )
                shiftPressed = ((evt.getModifiers() & SHIFT_MASK) == SHIFT_MASK);
        }
        if (!mouseMode) return;
        crossColor = Color.GREEN;
        updateVectorInfo();
        repaint();
    }//GEN-LAST:event_formMousePressed

    private void formMouseReleased(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_formMouseReleased
        if ((!mouseMode) && (!deviceList.get(DEVICE_LIGHTPEN).isActive())) return;
        if (evt.getButton() == MouseEvent.BUTTON1)
        {
            mousePressed = false;
            if ((evt != null ) )
            shiftPressed = ((evt.getModifiers() & SHIFT_MASK) == SHIFT_MASK);
        }
        if (deviceList.get(DEVICE_LIGHTPEN).isActive()) unsetLightPen();
        if (!mouseMode) return;
        crossColor = Color.ORANGE;
        repaint();
    }//GEN-LAST:event_formMouseReleased

    public boolean isMousePressed()
    {
        return mousePressed;
    }
    public int getMouseX()
    {
        return mX;
    }
    public int getMouseY()
    {
        // TODO update with panel offset?
        if (jPanel1.isVisible())
            return mY-jPanel1.getHeight();
        return mY;
    }
    
    private void formMouseDragged(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_formMouseDragged
        if ((!mouseMode) && (!deviceList.get(DEVICE_LIGHTPEN).isActive())) return;
        mX=evt.getX();
        mY=evt.getY();
        if (!mouseMode) return;
        crossColor = Color.GREEN;
        noCross = false;
        repaint();
    }//GEN-LAST:event_formMouseDragged

    private void jComboBoxJoyport1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBoxJoyport1ActionPerformed
        if (mClassSetting>0) return;
        vecx.joyport[1].plugIn((JoyportDevice)jComboBoxJoyport1.getSelectedItem());
        AbstractDevice.exitSync = false;
        updatePorts();
    }//GEN-LAST:event_jComboBoxJoyport1ActionPerformed

    private void jComboBoxJoyport0ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBoxJoyport0ActionPerformed
        if (mClassSetting>0) return;
        AbstractDevice.exitSync = false;
        vecx.joyport[0].plugIn((JoyportDevice)jComboBoxJoyport0.getSelectedItem());
        updatePorts();
    }//GEN-LAST:event_jComboBoxJoyport0ActionPerformed

    private void jButtonDebugActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonDebugActionPerformed
        ensureMyDissi();
    }//GEN-LAST:event_jButtonDebugActionPerformed

    private void jCheckBox1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox1ActionPerformed
        vecx.setPeerOutputEnabled(jCheckBox1.isSelected());
    }//GEN-LAST:event_jCheckBox1ActionPerformed

    
    public void setUpdateAllways(boolean b)
    {
        updateAllways = b;
    }
    public void showDumpi()
    {
        if (dumpi == null)
        {
            dumpi = ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).getDumpy();
            if (dumpi == null) return;
            dumpi.setDissi(dissi);
        }
        dumpi.setIcon(false);
        dumpi.setVecxy(this);
        dumpi.updateValues(true);
        ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).toFront(dumpi);
    }
    public void showTracki()
    {
        CSAMainFrame frame = ((CSAMainFrame)Configuration.getConfiguration().getMainFrame());
        if (tracki == null)
        {
            tracki = frame.getWRTracker();
        }
        if (tracki == null) return;
        tracki.setIcon(false);
        tracki.setVecxy(this);
        tracki.updateValues(true);
        ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).toFront(tracki);
    }

    
    public void showViai()
    {
        if (viai == null)
        {
            viai = ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).getViay();
        }
        if (viai == null) return;
        viai.setVecxy(this);
        viai.updateValues(true);
        viai.setIcon(false);
        if (ani == null)
        {
            ani = ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).getAni();
        }
        if (ani == null) return;
        ani.setIcon(false);
        ani.setVecxy(this);
        ani.updateValues(true);
        ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).toFront(viai);
        ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).toFront(ani);
    }
    public void showVari()
    {
        if (dissi == null) return;
        if (vari == null)
        {
            vari = ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).getVari();
        }
        if (vari == null) return;
        vari.setVecxy(this);
        vari.setIcon(false);
        
        vari.setDissi(dissi);
        vari.updateValues(true);
        ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).toFront(vari);
    }
    public void showVari(int address)
    {
        showVari();
        if (dissi == null) return;
        if (vari == null) return;
        vari.setSelectedAddress(address);
    }
    public void showLabi()
    {
        if (dissi == null) return;
        if (labi == null)
        {
            labi = ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).getLabi();
        }
        if (labi == null) return;
        labi.setVecxy(this);
        labi.setIcon(false);
        
        labi.setDissi(dissi);
        labi.updateValues(true);
        ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).toFront(labi);
    }
    public void showPSG()
    {
        if (dissi == null) return;
        if (ayi == null)
        {
            ayi = ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).getAyi();
        }
        if (ayi == null) return;
        ayi.setVecxy(this);
        ayi.setIcon(false);
        
        ayi.setDissi(dissi);
        ayi.updateValues(true);
        ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).toFront(ayi);
    }
    public void showProfiling()
    {
        if (dissi == null) return;
        if (profi == null)
        {
            profi = ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).getProfi();
        }
        if (profi == null) return;
        profi.setIcon(false);
        profi.setVecxy(this);
        
        profi.setDissi(dissi);
        profi.updateValues(true);
        ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).toFront(profi);
    }
    
    
    public void showBreakpoints()
    {
        if (dissi == null) return;
        if (breaki == null)
        {
            breaki = ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).getBreaki();
        }
        if (breaki == null) return;
        breaki.setIcon(false);
        breaki.setVecxy(this);
        
        breaki.setDissi(dissi);
        breaki.updateValues(true);
        ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).toFront(breaki);
    }
    public void showJoyportDevices()
    {
        if (dissi == null) return;
        if (joyi == null)
        {
            joyi = ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).getJoyportDevice();
        }
        if (joyi == null) return;
        joyi.setIcon(false);
        joyi.setVecxy(this);
        
        joyi.setDissi(dissi);
        joyi.updateValues(true);
        ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).toFront(joyi);
    }
    public void showCartridges()
    {
        if (dissi == null) return;
        if (carti == null)
        {
            carti = ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).getCartridge();
        }
        if (carti == null) return;
        carti.setIcon(false);
        carti.setVecxy(this);
        
        carti.setDissi(dissi);
        carti.updateValues(true);
        ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).toFront(carti);
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton jButtonDebug;
    private javax.swing.JButton jButtonFileSelect1;
    private javax.swing.JButton jButtonLoadState;
    private javax.swing.JButton jButtonPause;
    private javax.swing.JButton jButtonSaveState;
    private javax.swing.JButton jButtonStart;
    private javax.swing.JButton jButtonStop;
    private javax.swing.JCheckBox jCheckBox1;
    private javax.swing.JComboBox jComboBoxJoyport0;
    private javax.swing.JComboBox jComboBoxJoyport1;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JLabel jLabelFPS;
    protected javax.swing.JPanel jPanel1;
    private javax.swing.JTextField jTextFieldstart;
    // End of variables declaration//GEN-END:variables

    boolean waitAMoment = false;
    // start a thread with emulation
    public void start()
    {
        // paranoia!
        if (one != null) return;
        if (!stop) return;
        one = new Thread() 
        {
            public void run() 
            {
                stop = false;
                running = true;

                long measureTime = System.currentTimeMillis();
                long measureCycles = 0;
                while (!stop)
                {
                    long startTime = System.currentTimeMillis();
                    
                    if (!pausing)
                    {
                        int cyclesToRun = (VECTREX_MHZ / 1000) * EMU_TIMER;
                        if (stepping)
                        {
                            cyclesToRun = 1;
                            vecx.directDrawActive = true;
                        }
                        setLightPen();

                        if (waitAMoment) cyclesToRun =1;

                        boolean bs = config.breakpointsActive;
                        config.breakpointsActive = config.debugingCore;
                        if (config.debugingCore)
                            exitReason = vecx.vecx_emu(cyclesToRun); 
                        else
                            exitReason = vecx.vecx_emu_plain(cyclesToRun);    
                        config.breakpointsActive = bs;
                        
                        measureCycles += vecx.cyclesDone;
                        vecx.directDrawActive = false;
                        if (exitReason == EMU_EXIT_BREAKPOINT_BREAK)
                        {
                            vecx.config.syncCables = true;
                            stepping = false;
                            break;
                        }
                        if (exitReason == EMU_EXIT_BREAKPOINT_CONTINUE)
                        {
                            breakpointHandleContinue(vecx.activeBreakpoint);
                        }
                    }
                    else
                    {
                        pauseMode = true;
                        SwingUtilities.invokeLater(new Runnable()
                        {
                            public void run()
                            {
                                updateDisplay();
                                repaint();
                            }
                        });                    
                        try
                        {
                            Thread.sleep(100);
                        } 
                        catch(InterruptedException v) 
                        {
                        }
                    }
                    if (stepping)
                    {
                        try 
                        {
                            updatefinished = false;
                            SwingUtilities.invokeLater(new Runnable()
                            {
                                public void run()
                                {
                                    updateDisplay();
                                    updateAvailableWindows(true, false, true, false);
                                    updatefinished = true;
                                    
                                }
                            });                    
                            if (config.multiStepDelay>0)
                                Thread.sleep(config.multiStepDelay);
                            while (!updatefinished) Thread.sleep(0,1);
                        } 
                        catch(InterruptedException v) 
                        {
                        }
                        
                    }
                    else
                    {
                        SwingUtilities.invokeLater(new Runnable()
                        {
                            public void run()
                            {
                                updateAvailableWindows(true, false, false, true);
                            }
                        });                    
                        if (config.speedLimit) 
                        {
                            long duration = System.currentTimeMillis() - startTime;

                            if (duration < EMU_TIMER-1)
                            {
                                try 
                                {
                                    Thread.sleep(EMU_TIMER-1-duration);
                                } 
                                catch(InterruptedException v) 
                                {
                                }
                            }                        
                        }
                        long startTime2 = System.currentTimeMillis();
                        if (startTime2-measureTime >= 1000)
                        {
                            measureTime = startTime2;
                            double percent= ((double)measureCycles)/((double)VECTREX_MHZ)*100.0;
                            measureCycles = 0;
                            jLabelFPS.setText(""+((int)percent));
                        }
                    }
                }
                one = null;
                running = false;
                if (exitReason == EMU_EXIT_BREAKPOINT_BREAK)
                {
                    // meaning a breakpoint occured
                    SwingUtilities.invokeLater(new Runnable()
                    {
                        public void run()
                        {
                            updateAvailableWindows(true, noDissiFirstLine, true);
                            startDebug();
                            noDissiFirstLine = false;
                            breakpointHandleBreak();
                        }
                    });                    
                }
            }  
        };
        vecx.initDissi();

        one.start();           
    }
    boolean updatefinished=false;
    public void startDebug()
    {
        vecx.config.syncCables = true;
        stopThreading();
        debuging = true;
        if (regi == null)
        {
            regi = ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()). getRegi();
            regi.setE6809(vecx.e6809);
            regi.setVecxy(this);

            if (dissi != null)
                regi.setDissi(dissi);
        }
        if (!dissiInit)
        {
            if (dissi == null)
            {
                createDissi();
                if (dissi == null) return;
            }
            if (regi!= null) regi.setDissi(dissi);
            dissi.dis(vecx.cart);
            dissiInit = true;
        }
        if (dissi != null)
        {
            vecx.initDissi();
            dissi.goAddress(vecx.e6809.reg_pc, true, false, true);
        }
        updateDisplay();
    }

    public void stopDebug(boolean noRestart)
    {
        if (!noRestart)
            start();
        resetDirectdraw();
        debuging = false;
        vecx.config.syncCables = false;
    }
    
    public void oneStep()
    {
        if (!debuging) return;
        setLightPen();
        vecx.directDrawActive = true;
        vecx.vecx_emu(1); // only one instruction!
        updateDisplay();
        repaint();
        updateAvailableWindows(true, false, true);
    }
    
    private void stopThreading()
    {
        if (stop) return;
        stop = true;
        while (one != null) 
        {
            try 
            {
                Thread.sleep(10);
                vecx.stopEmulation();
            } 
            catch(InterruptedException v) 
            {
            }
        }
    }

    // blocking till thread is stopped!
    // this completly stops current emulation
    // and resets!
    // no continue possible!
    public void stop()
    {
        if (isPausing())
        {
            cont();
        }
        
        stopThreading();
        if (isDebuging())
        {
            stopDebug(true);
        }
        stepping = false;
        debuging = false;
        pausing = false;
        vecx.vecx_reset();
        forcedOverlay = "";

        stopGraphics();
        initJoyportsFromFlag();
        repaint();
    }
    public boolean isRunning()
    {
        return running;
    }
    // does "nothing" if not pausing
    public void cont()
    {
        pausing = false;
    }
    public void pause()
    {
        if (stop) return;
        pausing = true;
        // emulation thread is still runnning but not
        // emulating!
    }
    public boolean isPausing()
    {
        return pausing;
    }
    public boolean isDebuging()
    {
        return debuging;
    }
    
    public int getVectorCount()
    {
        return vecx.getDisplayList().count;
    }
    
    public boolean isImagerMode()
    {
        return vecx.imagerMode;
    }
    
    // this is a quick hack to get imager colors
    // intensity drift is an even worse hack - I know!!!
    Color getColor(int alpha, int left, int right, Color color)
    {
        if (!vecx.imagerMode)
            return color;
        if ((left == -2) ||(right == -2)) // draw bw
        {
            if (vecx.intensityDrift>100000)
            {
                return new Color( (int)(color.getRed()*vecx.intensityDriftNow),  (int)(color.getGreen()*vecx.intensityDriftNow),  (int)(color.getBlue()*vecx.intensityDriftNow), color.getAlpha()  );
            }
            return color;
        }
        Imager3dDevice i3d = (Imager3dDevice) vecx.joyport[1].getDevice();
 
        if (i3d.isAnaglyphicEnabled())
        {
            if (left > 0)
                color =  Color.RED;
            else if (right > 0)
                color =  Color.BLUE;
        }
        else
        {
            if (left > 0)
                color =  i3d.getWheel().colors[left];
            else if (right > 0)
                color =  i3d.getWheel().colors[right];
        }
        if (vecx.intensityDrift>100000)
        {
            return new Color( (int)(color.getRed()*vecx.intensityDriftNow),  (int)(color.getGreen()*vecx.intensityDriftNow),  (int)(color.getBlue()*vecx.intensityDriftNow), color.getAlpha()  );
        }
        
        return new Color(color.getRed(), color.getGreen(), color.getBlue(), alpha);
    }
    
    
    // if enabled -> cycle exact electron beam update
    // not "handled" correctly yet - but nice show!
    // supposed to respect:
    // - color
    // - dwell time
    //
    // curves would need a timewarp, (history of points)
    // dwell time and color should be handled so that color
    // greater than 255 is "spilled" to neighbouring pixels!
    synchronized public void rayMove(int x0,int y0, int x1, int y1, int color, int dwell, boolean curved, int alg_vector_speed, int alg_leftEye, int alg_rightEye)
    {
        displayPanel.rayMove( x0, y0,  x1,  y1,  color,  dwell,  curved,  alg_vector_speed,  alg_leftEye,  alg_rightEye);
    }
    
    
    double getBrightness()
    {
        double brightness = config.brightness;
        brightness = brightness /10;
        if (brightness>=0) brightness++;
        if (brightness<0) brightness--;
        
        if (brightness<0)
        {
            brightness = 1/(-brightness);
        }
        return brightness;
    }
 
    public void resetBuffer()
    {
        if (vecx != null)
        {
            vecx.resetBuffer();
        }
    }

    
    @Override public void paintComponent(Graphics g)
    {
        super.paintComponent(g);
    } 
    
  
    public void setLEDDir(boolean d)
    {
        ledDir = d;
    }
    public boolean isLEDDir()
    {
        return ledDir;
    }
    public void setLEDStep(int s)
    {
        ledStep = s;
    }
    public int getLEDStep()
    {
        return ledStep;
    }
    
    boolean ledDir = true;
    int ledStep = 0;
    
    public void breakpointUpdateDissi()
    {
        if (dissi != null)
            dissi.updateValues(false);
    }
    public void updateVectorInfo()
    {
        lastfound = found;
        if (vinfi == null)
        {
            vinfi = ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()). getVinfi();
            vinfi.setVecxy(this);
            if (dissi != null)
                vinfi.setDissi(dissi);
        }
        vinfi.update(lastfound);

    }
    
    public static String SID = "Emulator";
    public String getID()
    {
        return SID;
    }
    @Override public String getFileID()
    {
        return de.malban.util.UtilityString.replace(de.malban.util.UtilityString.replace(de.malban.util.UtilityString.replace(de.malban.util.UtilityString.replaceWhiteSpaces(SID, ""),":",""),"(",""),")","") ;
    }

    public int getVecXMem8(int adr)
    {
        return vecx.e6809_readOnly8(adr);
    }
    public void setDumpToAddress(int a)
    {
        if (dumpi == null)
        {
            dumpi = ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).getDumpy();
            if (dumpi != null)
                dumpi.setDissi(dissi);
        }
        dumpi.setVecxy(this);
        dumpi.updateValues(false);
        dumpi.goAddress(a);
    }
    public void unsetLightPen()
    {
        setLightPen(LightpenDevice.LIGHTPEN_OUT_OF_BOUNDS, LightpenDevice.LIGHTPEN_OUT_OF_BOUNDS);
    }
    public void setLightPen()
    {
        if (!deviceList.get(DEVICE_LIGHTPEN).isActive()) return;
        if (!mousePressed) {unsetLightPen();return;}
        displayPanel.setLightPen();
    }
    
    public void updateAvailableWindows(boolean jumpInDissi, boolean moveDissiToFirst, boolean forceUpdate)
    {
        updateAvailableWindows(jumpInDissi, moveDissiToFirst, forceUpdate, false);
    }
    public void updateAvailableWindows(boolean jumpInDissi, boolean moveDissiToFirst, boolean forceUpdate, boolean jumpMayBeDiscarded)
    {
        if (!dissiActive) return;
        if (dissi != null)
        {
            if ((jumpInDissi) && (!pausing))
                dissi.goAddress(vecx.e6809.reg_pc, moveDissiToFirst, false, forceUpdate, jumpMayBeDiscarded);
            dissi.updateValues(forceUpdate);
            
        }
        if (regi != null)
            regi.updateValues(forceUpdate);
        if (dumpi != null)
            dumpi.updateValues(forceUpdate);
        if (viai != null)
            viai.updateValues(forceUpdate);
        if (ani != null)
            ani.updateValues(forceUpdate);
        if (vari != null)
            vari.updateValues(forceUpdate);
        if (breaki != null)
            breaki.updateValues(forceUpdate);
        if (labi != null)
            labi.updateValues(forceUpdate);
        if (tracki != null)
            tracki.updateValues(forceUpdate);
        if (ayi != null)
            ayi.updateValues(forceUpdate);
        if (carti != null)
            carti.updateValues(forceUpdate);
        if (joyi != null)
            joyi.updateValues(forceUpdate);
        if (vinfi != null)
            vinfi.updateValues(forceUpdate);
        if (profi != null)
            profi.updateValues(forceUpdate);
    }
    void checkWindows()
    {
        CSAMainFrame f = (CSAMainFrame) mParent;
        if (dissi == null) dissi = f.checkDissi(); // stays null or is set!
        if (dumpi == null) dumpi = f.checkDumpy(); // stays null or is set!
        if (regi == null) regi = f.checkRegi(); // stays null or is set!
        if (vinfi == null) vinfi = f.checkVinfi(); // stays null or is set!
        if (viai == null) viai = f.checkViay(); // stays null or is set!
        if (ani == null) ani = f.checkAni(); // stays null or is set!
        if (vari == null) vari = f.checkVari(); // stays null or is set!
        if (breaki == null) breaki = f.checkBreaki(); // stays null or is set!
        if (labi == null) labi = f.checkLabi(); // stays null or is set!
        if (tracki == null) tracki = f.checkWRTracker(); // stays null or is set!
        if (ayi == null) ayi = f.checkAyi(); // stays null or is set!
        if (joyi == null) joyi = f.checkJoyportDevice(); // stays null or is set!
        if (carti == null) carti = f.checkCartridge(); // stays null or is set!
        if (profi == null) profi = f.checkProfi(); // stays null or is set!

        if (dissi != null)
        {
            if (dumpi!= null) dumpi.setDissi(dissi);
            if (regi!= null) regi.setDissi(dissi);
            if (vinfi!= null) vinfi.setDissi(dissi);
            if (vari != null) vari.setDissi(dissi);
            if (labi != null) labi.setDissi(dissi);
            if (ayi != null) ayi.setDissi(dissi);
            if (breaki != null) breaki.setDissi(dissi);
            if (joyi != null) joyi.setDissi(dissi);
            if (carti != null) carti.setDissi(dissi);
            if (profi != null) profi.setDissi(dissi);
            dissi.setVecxy(this);
        }
        if (dumpi != null) dumpi.setVecxy(this);
        if (regi != null) regi.setVecxy(this);
        if (regi != null) regi.setE6809(this.vecx.e6809);
        if (vinfi != null) vinfi.setVecxy(this);
        if (viai != null) viai.setVecxy(this);
        if (ani != null) ani.setVecxy(this);
        if (vari != null) vari.setVecxy(this);
        if (breaki != null) breaki.setVecxy(this);
        if (labi != null) labi.setVecxy(this);
        if (tracki != null) tracki.setVecxy(this);
        if (ayi != null) ayi.setVecxy(this);
        if (joyi != null) joyi.setVecxy(this);
        if (carti != null) carti.setVecxy(this);
        if (profi != null) profi.setVecxy(this);
    }
    public void resetCartridge()
    {
        carti = null;
    }
    public void resetDevice()
    {
        joyi = null;
    }
    public void resetAyi()
    {
        ayi = null;
    }
    public void resetProfi()
    {
        profi = null;
    }
    public void resetLabi()
    {
        labi = null;
    }
    public void resetViai()
    {
        viai = null;
    }
    public void resetVinfi()
    {
        vinfi = null;
    }
    public void resetDumpi()
    {
        dumpi = null;
    }
    public void resetRegi()
    {
        regi = null;
    }
    public void resetAni()
    {
        ani = null;
    }
    public void resetVari()
    {
        vari = null;
    }
    public void resetTracki()
    {
        tracki = null;
    }
    public void resetBreaki()
    {
        breaki = null;
    }
    public void resetDissi()
    {
        dissi = null;
        dissiInit = false;
        if (dumpi != null)
            dumpi.setDissi(null);
        if (regi != null)
            regi.setDissi(null);
        if (vinfi != null)
            vinfi.setDissi(null);
        if (vari != null)
            vari.setDissi(null);
        if (labi != null)
            labi.setDissi(null);
        if (ayi != null)
            ayi.setDissi(null);
        if (breaki != null)
            breaki.setDissi(null);
        if (carti != null)
            carti.setDissi(null);
        if (joyi != null)
            joyi.setDissi(null);
        if (profi != null)
            profi.setDissi(null);
    }
    public void resetMe()
    {
        // look if dissi is using "me"
        if (dissi != null)
            if (dissi.getVecXPanel() != this) return; // dissi is not using "me" as a source, it is associated with another instance of vecx
        
        if (dissi != null) dissi.setVecxy(null);
        if (dumpi != null) dumpi.setVecxy(null);
        if (regi != null) regi.setE6809(null);
        if (regi != null) regi.setVecxy(null);
        if (vinfi != null) vinfi.setVecxy(null);
        if (viai != null) viai.setVecxy(null);
        if (ani != null) ani.setVecxy(null);
        if (vari != null) vari.setVecxy(null);
        if (breaki != null) breaki.setVecxy(null);
        if (labi != null) labi.setVecxy(null);
        if (tracki != null) tracki.setVecxy(null);
        if (ayi != null) ayi.setVecxy(null);
        if (joyi != null) joyi.setVecxy(null);
        if (carti != null) carti.setVecxy(null);
        if (profi != null) profi.setVecxy(null);
    }
    // re setting dissi updates all!
    
    public void initLabels()
    {
        if (labi != null)
            labi.initLabels();
    }
    
    public void updateDumpi()
    {
        if (dumpi != null)
            dumpi.setDissi(dissi);
    }
    public void updateLabi()
    {
        if (labi != null)
            labi.setDissi(dissi);
    }
    // re setting dissi updates all!
    public void updateVari()
    {
        if (vari != null)
            vari.setDissi(dissi);
    }
    
    // this function is actually DIRECTLY executed from the
    // emulation thread!
    // since this is continuing breakpoint (emulation continues)
    // we must access the breakpoints NOW
    // or they will be lost
    // one time breakpoints have already been removed from all memInfo and from vecx
    private void breakpointHandleContinue(ArrayList<Breakpoint> activeBreakpoint)
    {
        if (dissi== null) return;
        // for now let dissi handle
        // all, since probably they are hey dissi breakpoints :-)!
        for (Breakpoint bp: activeBreakpoint)
        {
            bp.wasTriggered = true;
            if (bp.targetSubType  == Breakpoint.BP_SUBTARGET_CPU_SPECIAL)
            {
                dissi.printMessage("Measure finished, target ("+String.format("$%04X",bp.targetAddress )+")reached: "+bp.compareValue+" cycles", DissiPanel.MESSAGE_INFO );
                continue;
            }
            if ((bp.type&Breakpoint.BP_QUIET) ==0)
                dissi.printMessage("Triggered: "+bp, DissiPanel.MESSAGE_INFO);
            if ((bp.type&Breakpoint.BP_HEY) == Breakpoint.BP_HEY)
                dissi.doHeyDissiBreakpoint(bp);
                
        }            
        if (breaki != null) breaki.updateValues(true);
    }

    // this function "runs" in the gui thread as "usual"
    private void breakpointHandleBreak()
    {
        // do something if "wanted"
        // debugging is already switch on, since this is a 
        // breaking breakpoint
        // vecxy still has the active breakpoints, if we need them
        // in ... vecx.activeBreakpoint
        if (dissi== null) return;
        for (Breakpoint bp: vecx.activeBreakpoint)
        {
            bp.wasTriggered = true;
            if (bp.targetSubType  == Breakpoint.BP_SUBTARGET_CPU_SPECIAL)
            {
                dissi.printMessage("Measure finished, target ("+String.format("$%04X",bp.targetAddress )+")reached: "+bp.compareValue+" cycles", DissiPanel.MESSAGE_INFO );
                continue;
            }
            if ((bp.type&Breakpoint.BP_QUIET) ==0)
            {
                if (!dissi.isQuiet())
                    dissi.printMessage("Triggered: "+bp, DissiPanel.MESSAGE_INFO);
            }
            dissi.ensureCorrectOutput();
        }
        if (breaki != null) breaki.updateValues(true);
    }
    
    // RAM access// read//write// value
    public void breakpointVarSet(Breakpoint bp)
    {
        if (dissi == null) return;
        bp.memInfo = null;
        vecx.addBreakpoint(bp);
        dissi.updateTableOnly();
        vari.updateValues(true);
        if (breaki != null) breaki.updateValues(true);
    }
    public void breakpointSet(Breakpoint bp)
    {
        vecx.addBreakpoint(bp);
        if (breaki != null) breaki.updateValues(true);
    }
    
    // "incoming" bp is used to transport information
    // it is not an already set breakpoint!
    // it can be used to look up memory or Vecx
    // to compare if an existing breakpoint
    // can be switched off
    // this toggle onle works for "address" breakpoints!
    // since information from memInfo is used
    // returns true on add
    public boolean breakpointAddressToggle(Breakpoint bp)
    {
        if (dissi == null) return false;
        
        if (dissi.isBankDebug())
        {
            for (int b=0;b<vecx.cart.getBankCount(); b++)
            {
                Breakpoint nbp = bp.duplicate();
                nbp.targetBank = b;
                breakpointAddressToggleImpl(nbp);
            }
            
            return true;
        }
        return breakpointAddressToggleImpl(bp);
    }
    

    public boolean breakpointAddressToggleImpl(Breakpoint bp)
    {
        MemoryInformation memInfo = dissi.getMemory().get(bp.targetAddress, bp.targetBank);
        if (memInfo == null) return false;
        bp.memInfo = memInfo;

        Breakpoint oldBreakpoint = memInfo.hasBreakpoint(bp);
        if (oldBreakpoint == null)
        {
            vecx.addBreakpoint(bp);
            dissi.updateTableOnly();
            if (breaki != null) breaki.updateValues(true);
            return true;
        }
        vecx.removeBreakpoint(oldBreakpoint);        
        dissi.updateTableOnly();
        if (breaki != null) breaki.updateValues(true);
        return false;
    }
    
    // single systemwide entry point fpr Breakpoints!
    // not checked if "same" breakpoint already exists!
    public void breakpointMemorySet(Breakpoint bp)
    {
        if (dissi == null) return;
        if (dissi.isBankDebug())
        {
            for (int b=0;b<vecx.cart.getBankCount(); b++)
            {
                Breakpoint nbp = bp.duplicate();
                nbp.targetBank = b;
                breakpointAddressToggleImpl(nbp);
            }
            
            return;
        }
        breakpointAddressToggleImpl(bp);
        return ;
    }
    public void breakpointMemorySetImpl(Breakpoint bp)
    {
        if (dissi == null) return;
        dissi.getMemory();
        MemoryInformation memInfo = dissi.getMemory().get(bp.targetAddress, bp.targetBank);
        if (memInfo == null) return;
        bp.memInfo = memInfo;
        vecx.addBreakpoint(bp);
        dissi.updateTableOnly();
        if (breaki != null) breaki.updateValues(true);
    }


    // true on add
    public boolean breakpointBankToggle(Breakpoint bp)
    {
        boolean b = vecx.toggleBankBreakpoint(bp);
        if (breaki != null) breaki.updateValues(true);
        return b;
    }
    public boolean breakpointROMToggle(Breakpoint bp)
    {
        boolean b = vecx.toggleROMBreakpoint(bp);
        if (breaki != null) breaki.updateValues(true);
        return b;
    }
    public boolean breakpointVIAToggle(Breakpoint bp)
    {
        boolean b = vecx.toggleViaBreakpoint(bp);
        if (breaki != null) breaki.updateValues(true);
        return b;
    }
    public boolean breakpointCyclesSet(Breakpoint bp)
    {
        boolean b = vecx.setCyclesBreakpoint(bp);
        if (breaki != null) breaki.updateValues(true);
        return b;
    }
    public boolean breakpointCPUToggle(Breakpoint bp)
    {
        boolean b = vecx.breakpointCPUToggle(bp);
        if (breaki != null) breaki.updateValues(true);
        return b;
    }
    
    
    
    

    public void breakpointRemove(Breakpoint bp)
    {
        if (dissi == null) return;
        if (dissi.isBankDebug())
        {
            for (int b=0;b<vecx.cart.getBankCount(); b++)
            {
                Breakpoint nbp = bp.duplicate();
                nbp.targetBank = b;
                breakpointRemoveImpl(nbp);
            }
            
            return;
        }
        breakpointRemoveImpl(bp);
        return ;
    }
    void breakpointRemoveImpl(Breakpoint bp)
    {
        vecx.removeBreakpoint(bp);        
        dissi.updateTableOnly();
        if (breaki != null) breaki.updateValues(true);
    }
    
    public long getCyclesRunning()
    {
        return vecx.cyclesRunning;
    }
    public void setCyclesRunning(long n)
    {
        vecx.setCyclesRunning(n);
        if (regi != null) regi.updateValues(true);
    }
    public void breakpointClearAll()
    {
        vecx.clearAllBreakpoints();        
        dissi.updateTableOnly();
        if (breaki != null) breaki.updateValues(true);
    }
    
    public CodeScanMemory getCodeScanMemory()
    {
        return vecx.dissiMem;
    }
    
    public Cartridge getCartridge()
    {
        if (vecx==null) return null;
        return vecx.cart;
    }
    public Serializable getAdditionalStateinfo()
    {
        VecxSettings vs = new VecxSettings();
        vs.lastOpenFile = jTextFieldstart.getText();
        return vs;
    }
    public void setAdditionalStateinfo(Serializable ser)
    {
        VecxSettings vs = (VecxSettings) ser;
        jTextFieldstart.setText(vs.lastOpenFile);
    }
    
    public int getCurrentBank()
    {
        if (vecx==null) return -1;
        return vecx.currentBank;
    }
    public int getCurrentAddress()
    {
        if (vecx==null) return -1;
        return vecx.e6809.reg_pc;
    }
    public void poke(int addres, byte value)
    {
        if (vecx==null) return ;
        vecx.poke( addres,  value);
    }
    public int getXIntegratorValue()
    {
        if (vecx==null) return 0;
        return (int)vecx.alg_curr_x-config.ALG_MAX_X/2;
    }
    public int getYIntegratorValue()
    {
        if (vecx==null) return 0;
        return (int)vecx.alg_curr_y-config.ALG_MAX_Y/2;
    }
    
    public E6809 get6809()
    {
        return vecx.e6809;
    }
    public VecXState getVecXState()
    {
        return vecx;
    }
    public E8910State getE8910State()
    {
        return vecx.e8910;
        
    }
    public int getCurrentWaitRecalBufferPos()
    {
        return vecx.getCurrentWaitRecalBufferPos();
    }
    public int[] getCurrentWaitRecalBuffer()
    {
        return vecx.getCurrentWaitRecalBuffer();
    }
    public long getLastWaitRecalTest()
    {
        return vecx.getLastWaitRecalTest();
    }
    public void setTrackingAddress(int start,int end, int bank)
    {
        vecx.setTrackingAddress( start, end, bank);
    }
    public void resetAllTimeLowStack()
    {
        vecx.resetAllTimeLowStack();
    }
    public int getAllTimeLowStack()
    {
        return vecx.getAllTimeLowStack();
    }
    
    public CartridgeProperties getCurrentCartProp()
    {
        if (vecx == null) return null;
        if (vecx.cart == null) return null;
        return vecx.cart.currentCardProp;
    }
    DebugInfoC toSetCDebug = null;
    DebugInfoC usedCDebug = null;
    public DebugInfoC getUsedCDebugInfo()
    {
        return usedCDebug;
    }
    public void setNextStartCDebugInfo(DebugInfoC cDebug)
    {
        toSetCDebug = cDebug;
    }
    public void startCartridge(final CartridgeProperties cartProp, int runType)
    {
        startTypeRun = runType;        
        // stop everything
        if (startTypeRun != START_TYPE_INJECT)
            jButtonStopActionPerformed(null);                                            
        
        if (cartProp.getFullFilename().size()>0)
        {
            String name = de.malban.util.Utility.makeVideAbsolute(de.malban.util.UtilityFiles.convertSeperator(cartProp.getFullFilename().elementAt(0)));
            jTextFieldstart.setText(name);
            lastOpenedDir = name;
        }
    
        
        Thread cartLoaderThread = new Thread()
        {
            public void run()
            {
                // cDebug info only used once and ONCE only!
                usedCDebug = toSetCDebug;
                toSetCDebug = null;
                boolean loaded = false;
                if (startTypeRun != START_TYPE_INJECT)
                    loaded = vecx.init(cartProp);
                else
                    loaded = vecx.inject(cartProp);
                if (!loaded)
                {
                    SwingUtilities.invokeLater(new Runnable()
                    {
                        public void run()
                        {
                            ShowErrorDialog.showErrorDialog("Error loading binaries for: "+cartProp.getCartName()+"!");
                        }
                    });                    
                }
                else
                {
                    SwingUtilities.invokeLater(new Runnable()
                    {
                        public void run()
                        {
                            startVecxCallback();
                        }
                    });                    
                }
            }
        };
        cartLoaderThread.start();
        
        // vecx loads cart correctly and gives it
        
    }
    
    void startVecxCallback()
    {
        if (dissi == null)
        {
            createDissi();
            if (dissi == null) return; 
            if (startTypeRun == START_TYPE_INJECT)
            {
                setDissi(dissi);
                dissi.dis(vecx.cart); // to dissi
            }
        }
        if (startTypeRun != START_TYPE_INJECT)
        {
            setDissi(dissi);
            dissi.dis(vecx.cart); // to dissi
        }
        else
        {
            dissi.dis(vecx.cart); // to dissi
        }
        if (startTypeRun == VecX.START_TYPE_DEBUG)
            dissi.setStartbreakpoint();
        if (config.pleaseforceDissiIconizeOnRun)
            dissi.setIcon(startTypeRun == VecX.START_TYPE_RUN);
        else
        {
            if (!dissi.isIcon())
            {
                CSAMainFrame gui = (CSAMainFrame)mParent;
                try
                {
                    gui.getInternalFrame(dissi).toFront();
                    gui.getInternalFrame(dissi).setSelected(true);
                }
                catch (Throwable e)
                {
                }
            }
        }

        dissiInit = true;
        if (config.overlayEnabled)
        {
            if (vecx != null)
            {
                if (vecx.cart != null)
                {
                    if (vecx.cart.currentCardProp != null)
                    {
                        loadOverlay(vecx.cart.currentCardProp.getOverlay()); // ensure overlay in scaled form is available
                        if (overlayImageOrg==null) 
                        {
                            loadOverlay(vecx.cart.cartName); // ensure overlay in scaled form is available
                        }
                    }
                }
            }
        }
        checkWindows();
        stop = true;
        
        while (running);
        dissi.processHeyDissis();
        changeDisplay();
        initJoyportsFromFlag();
        
        
        
        
        updatePorts();
        if (startTypeRun != VecX.START_TYPE_INJECT)
        {
            start();
        }
        else
        {
            if (!debuging)
            {
                if (!stepping)
                    start();
            }
        }
        
    }
    
    public void setPC(int addr)
    {
        vecx.e6809.reg_pc = addr;
    }
    public void doNMI()
    {
        vecx.e6809.doNMI();
    }
    
    public void setAllBreakpoints(ArrayList<Breakpoint>[] ab)
    {
        // remove all
        vecx.clearAllBreakpoints();
        // set all
        for (ArrayList<Breakpoint> blist: ab)
        {
            for (Breakpoint bp: blist)
            {
                MemoryInformation memInfo = dissi.getMemory().get(bp.targetAddress, bp.targetBank);
                bp.memInfo = memInfo;
            }
        }
        vecx.setAllBreakpoints(ab);
        
    }
    public ArrayList<Breakpoint>[] getAllBreakpoints()
    {
        return vecx.getAllBreakpoints();
    }
    public void startRecord(String filename, int type, boolean isAddress, int address)
    {
        vecx.startRecord(filename,type, isAddress , address);
    }
    public void stopRecord()
    {
        vecx.stopRecord();
    }
    public void vectorScreenshot()
    {
        double exportScaleWidth = ((double)255)/((double)config.ALG_MAX_X);
        double exportScaleHeight = ((double)255)/((double)config.ALG_MAX_Y);

        VectrexDisplayVectors currentVectors = vecx.getDisplayList();
        GFXVectorList list = new GFXVectorList();
        for (int ve = 0; ve < currentVectors.count; ve++) 
        {
            vector_t v = currentVectors.vectrexVectors[ve];
            GFXVector vector = new GFXVector();
            vector.pattern = 255;
            vector.intensity = v.color &0xff; // can be higher 255, due to dwell timing!
            double x0 =Scaler.scaleDoubleToInt(v.x0, exportScaleWidth);
            double y0 =Scaler.scaleDoubleToInt(v.y0, exportScaleHeight)*-1;
            double x1 =Scaler.scaleDoubleToInt(v.x1, exportScaleWidth);
            double y1 =Scaler.scaleDoubleToInt(v.y1, exportScaleHeight)*-1;
            vector.start.x(x0-128);
            vector.start.y(y0+127);
            vector.end.x(x1-128);
            vector.end.y(y1+127);
            list.add(vector);
        }
        String filename =Global.mainPathPrefix+"xml"+File.separator+"vectorlist"+File.separator;
        int count = 0;
        
        String cartName = vecx.cart.cartName;
        if (cartName.trim().length()!=0)
        {
            cartName = new File(cartName).getName();
            if (cartName == null) cartName = "";
            cartName = de.malban.util.UtilityString.replace(cartName.toLowerCase(), ".bin", "");
            cartName = de.malban.util.UtilityString.replace(cartName.toLowerCase(), ".vec", "");
            cartName = de.malban.util.UtilityString.replace(cartName.toLowerCase(), ".gam", "");
        }
        
        String saveName = "";

        do
        {
            saveName = filename+cartName+"_"+count+".xml";
            count++;
        }while  (new File(saveName).exists());
        list.saveAsXML(saveName);
    }
    
    // expects vectrex coordionates like vector list
    // transformed to upper left corner. (is 0,0)
    // values from 0 to ALG_MAX_X and 0 to ALG_MAX_Y
    public void setLightPen(int x, int y)
    {
        if (deviceList.get(DEVICE_LIGHTPEN).isActive())
        {
            ((LightpenDevice)deviceList.get(DEVICE_LIGHTPEN)).setCoordinates(x,y);
        }
    }
    
    void updatePorts()
    {
        mClassSetting++;
        
        if (vecx.joyport[0].getDevice() == null) vecx.joyport[0].plugIn(deviceList.get(DEVICE_NULL));
        if (vecx.joyport[1].getDevice() == null) vecx.joyport[1].plugIn(deviceList.get(DEVICE_NULL));
        
        jComboBoxJoyport0.setSelectedItem(vecx.joyport[0].getDevice());
        jComboBoxJoyport1.setSelectedItem(vecx.joyport[1].getDevice());
        mClassSetting--;
    }
    
    
    ArrayList<JoyportDevice> deviceList = null;
    
    public ArrayList<JoyportDevice> getDeviceList()
    {
        return deviceList;
    }
    private void ensureDevices()
    {
        if (deviceList != null) return;
        deviceList = new ArrayList<JoyportDevice>();

        deviceList.add(new NullDevice()); // 0

        
        deviceList.add(new LightpenDevice()); // 1
        
        VecSpeechDevice speech = new VecSpeechDevice(); 
        speech.setVecVoice(true);
        deviceList.add(speech); // 2
        
        speech = new VecSpeechDevice();
        speech.setVecVoice(false);
        deviceList.add(speech);// 3

        deviceList.add(new Imager3dDevice()); // 4

        deviceList.add(VecLinkV1Device.getVecLinkV1(0));// 5
        deviceList.add(VecLinkV1Device.getVecLinkV1(1));// 6
        deviceList.add(VecLinkV2Device.getVecLinkV2(0));// 7
        deviceList.add(VecLinkV2Device.getVecLinkV2(1));// 8

        deviceList.add(new KeyboardJoystickDevice(this, 0)); // 9
        deviceList.add(new KeyboardJoystickDevice(this, 1)); // 10
        deviceList.add(new KeyboardSpinnerDevice(this)); // 11
        for (ControllerConfig cConfig: config.getAvailableControllerConfigs())
        {
            if (cConfig.vectrexType==ControllerConfig.CONTROLLER_JOYSTICK)
                deviceList.add(JInputJoystickDevice.getDevice(cConfig)); // 12++
            if (cConfig.vectrexType==ControllerConfig.CONTROLLER_SPINNER)
                deviceList.add(JInputSpinnerDevice.getDevice(cConfig)); // 13++
        }
        
        ArrayList<JoyportDevice> deviceList0 = (ArrayList<JoyportDevice>)deviceList.clone();
        deviceList0.remove(DEVICE_IMAGER);
        deviceList0.add(DEVICE_IMAGER, new NullDevice());
        
        jComboBoxJoyport0.setModel((new DefaultComboBoxModel(deviceList0.toArray())) );
        jComboBoxJoyport1.setModel((new DefaultComboBoxModel(deviceList.toArray())) );
    }
    
    public static int DEVICE_NULL = 0;

    public static int DEVICE_LIGHTPEN = 1;
    public static int DEVICE_VECVOICE = 2;
    public static int DEVICE_VECVOX = 3;

    public static int DEVICE_IMAGER = 4;

    public static int DEVICE_LINKV1_L = 5;
    public static int DEVICE_LINKV1_R = 6;
    public static int DEVICE_LINKV2_L = 7;
    public static int DEVICE_LINKV2_R = 8;
    public static int DEVICE_KEYBOARD_JOYSTICK0 = 9;
    public static int DEVICE_KEYBOARD_JOYSTICK1 = 10;
    public static int DEVICE_KEYBOARD_SPINNER = 11;
    public static int DEVICE_JINPUT_JOYSTICK = 12; // ...
    public static int DEVICE_JINPUT_SPINNER = 13; // ...
    
    
    private void initJoyportsFromFlag()
    {
        if (vecx == null) return;
        vecx.joyport[0].plugIn(deviceList.get(DEVICE_KEYBOARD_JOYSTICK0));
        vecx.joyport[1].plugIn(deviceList.get(DEVICE_KEYBOARD_JOYSTICK1));

        if (vecx.cart == null) return;
        if (vecx.cart.currentCardProp == null) return;
        
        int flags = vecx.cart.currentCardProp.getTypeFlags();
        if ((flags & Cartridge.FLAG_LIGHTPEN1) == Cartridge.FLAG_LIGHTPEN1)
        {
            vecx.joyport[0].plugIn(deviceList.get(DEVICE_LIGHTPEN));
        }
        if ((flags & Cartridge.FLAG_LIGHTPEN2) == Cartridge.FLAG_LIGHTPEN2)
        {
            vecx.joyport[1].plugIn(deviceList.get(DEVICE_LIGHTPEN));
        }
        if ((flags & Cartridge.FLAG_VEC_VOICE) == Cartridge.FLAG_VEC_VOICE)
        {
            vecx.joyport[1].plugIn(deviceList.get(DEVICE_VECVOICE));
        }
        if ((flags & Cartridge.FLAG_VEC_VOX) == Cartridge.FLAG_VEC_VOX)
        {
            vecx.joyport[1].plugIn(deviceList.get(DEVICE_VECVOX));
        }
        if ((flags & Cartridge.FLAG_IMAGER) == Cartridge.FLAG_IMAGER)
        {
            vecx.joyport[1].plugIn(deviceList.get(DEVICE_IMAGER));
            String wheelName = vecx.cart.currentCardProp.getWheelName();
            ((Imager3dDevice)deviceList.get(DEVICE_IMAGER)).setWheel(wheelName);
        }
        
        
        for (JoyportDevice d :deviceList )
        {
            if (config.devicePort0!= null)
            {
                if (d.toString().equalsIgnoreCase(config.devicePort0))
                {
                    vecx.joyport[0].plugIn(d);
                    
                }
            }
            if (config.devicePort1!= null)
            {
                if (d.toString().equalsIgnoreCase(config.devicePort1))
                {
                    vecx.joyport[1].plugIn(d);
//                    jComboBoxJoyport1.setSelectedItem(vecx.joyport[1].getDevice());
                }
            }
        }
    }
    
    private void replaceDeviceInList(JoyportDevice d)
    {
        int sel0 = jComboBoxJoyport0.getSelectedIndex();
        int sel1 = jComboBoxJoyport1.getSelectedIndex();
        int index = 0;
        for (JoyportDevice dOrg: deviceList)
        {
            if (dOrg.getDeviceID() == d.getDeviceID())
            {
                deviceList.remove(index);
                deviceList.add(index,d);
                break;
            }
            index++;
        }
        mClassSetting++;
        jComboBoxJoyport0.setModel((new DefaultComboBoxModel(deviceList.toArray())) );
        jComboBoxJoyport1.setModel((new DefaultComboBoxModel(deviceList.toArray())) );
        jComboBoxJoyport0.setSelectedIndex(sel0);
        jComboBoxJoyport1.setSelectedIndex(sel1);
        mClassSetting--;
    }
    JoyportDevice getDevice(int id, String name)
    {
        if (id < DEVICE_JINPUT_JOYSTICK)
        {
            return deviceList.get(id);
        }
        for (JoyportDevice device : deviceList)
        {
            if ((device.getDeviceID() == id) && (device.getDeviceName().equals(name)))
                return device;
        }
        return null;
    }
    private void initJoyportsFromEmulation()
    {
        if (vecx == null) return;
        if (vecx.joyport == null) return;
        JoyportDevice device1 = vecx.joyport[1].getDevice();
        
        mClassSetting++;

        vecx.joyport[0].plugIn(deviceList.get(DEVICE_KEYBOARD_JOYSTICK0));
        if (!(device1 instanceof Imager3dDevice))
            vecx.joyport[1].plugIn(deviceList.get(DEVICE_KEYBOARD_JOYSTICK1));

        if (vecx.cart == null) 
        {
            mClassSetting--;
            return;
        }
        if (vecx.cart.currentCardProp == null) 
        {
            mClassSetting--;
            return;
        }
        
        int flags = vecx.cart.currentCardProp.getTypeFlags();
        if ((flags & Cartridge.FLAG_LIGHTPEN1) == Cartridge.FLAG_LIGHTPEN1)
        {
            vecx.joyport[0].plugIn(deviceList.get(DEVICE_LIGHTPEN));
        }
        if ((flags & Cartridge.FLAG_LIGHTPEN2) == Cartridge.FLAG_LIGHTPEN2)
        {
            vecx.joyport[1].plugIn(deviceList.get(DEVICE_LIGHTPEN));
        }
        if ((flags & Cartridge.FLAG_VEC_VOICE) == Cartridge.FLAG_VEC_VOICE)
        {
            vecx.joyport[1].plugIn(deviceList.get(DEVICE_VECVOICE));
        }
        if ((flags & Cartridge.FLAG_VEC_VOX) == Cartridge.FLAG_VEC_VOX)
        {
            vecx.joyport[1].plugIn(deviceList.get(DEVICE_VECVOX));
        }
        if (vecx.joyport[0] != null)
        {
            jComboBoxJoyport0.setSelectedItem(vecx.joyport[0].getDevice());
        }
        else
        {
            jComboBoxJoyport0.setSelectedIndex(-1);
        }
        if (device1 != null)
        {
            if (device1 instanceof Imager3dDevice)
            {
                replaceDeviceInList(device1);
                jComboBoxJoyport1.setSelectedItem(vecx.joyport[1].getDevice());
            }
        }
        mClassSetting--;
    }

    public void setDissi(DissiPanel d)
    {
        dissi = d;
        dissi.newEnvironment(this);
        

        myDissi = dissi.getData();
        AbstractDevice.exitSync = false;
        DualVec.exitSync = false;
    }
    
    DissiPanel.DissiSwitchData myDissi;
    
    boolean dissiActive = true;
    public void setDissiAcitve(boolean a)
    {
        dissiActive = a;
    }
    
    // unsets a dissi connection
    void removeDissi()
    {
        if (dissi == null) return;
        vecx.clearAllBreakpoints();
        if (breaki != null) 
            breaki.updateValues(true);
        resetMe();
        
        dissi=null;
        regi = null;
        vinfi = null;
        dumpi = null;
        viai = null;
        ani = null;
        vari = null;
        breaki = null;
        labi = null;
        tracki = null;
        ayi = null;
        carti = null;
        joyi = null;
        profi = null;
        dissiInit = false;

        
    }
    void ensureMyDissi()
    {
        // check and cleanup (if needed ) other vecx/dissi
        CSAMainFrame f = (CSAMainFrame) mParent;
        f.checkDissi();
        if (dissi != null)
        {
            if (dissi.getVecXPanel() == this) return;

            // if the other vecx still exists, clear its breakpoints
            if (dissi.getVecXPanel() != null)
            {
                dissi.getVecXPanel().removeDissi();
            }
        }
        else
        {
            if (config.debugingCore)
            {
                createDissi();
                if (dissi == null) return; 
                if (running)
                {
                    setDissi(dissi);
                    dissi.dis(vecx.cart);
                    dissi.processHeyDissis();
                    dissiInit = true;
                    vecx.initDissi();
                }
            }
            else
            {
                return;
            }
        }
        
        dissi.changeBaseData(myDissi);
       
        findWindows();
        
        if (dissi != null) dissi.setVecxy(this);
        if (dumpi != null) dumpi.setVecxy(this);
        if (regi != null) regi.setE6809(vecx.e6809);
        if (regi != null) regi.setVecxy(this);
        if (vinfi != null) vinfi.setVecxy(this);
        if (viai != null) viai.setVecxy(this);
        if (ani != null) ani.setVecxy(this);
        if (vari != null) vari.setVecxy(this);
        if (breaki != null) breaki.setVecxy(this);
        if (labi != null) labi.setVecxy(this);
        if (tracki != null) tracki.setVecxy(this);
        if (ayi != null) ayi.setVecxy(this);        
        if (carti != null) carti.setVecxy(this);        
        if (joyi != null) joyi.setVecxy(this);        
        if (profi != null) profi.setVecxy(this);        
        
        if (dumpi != null) dumpi.setDissi(dissi);
        if (regi != null) regi.setDissi(dissi);
        if (vinfi != null) vinfi.setDissi(dissi);
        if (vari != null) vari.setDissi(dissi);
        if (labi != null) labi.setDissi(dissi);
        if (ayi != null) ayi.setDissi(dissi);
        if (breaki != null) breaki.setDissi(dissi);
        if (carti != null) carti.setDissi(dissi);
        if (joyi != null) joyi.setDissi(dissi);
        if (profi != null) profi.setDissi(dissi);

        
        updateAvailableWindows(false, false, true);
    }
    // if my own "panels" are null and they were opened meanwhile for antother panel - find them
    // if my own panels are now closed -> null them
    void findWindows()
    {
        CSAMainFrame f = (CSAMainFrame) mParent;
        dissi = f.checkDissi();
        dumpi = f.checkDumpy();
        regi = f.checkRegi();
        vinfi = f.checkVinfi();
        viai = f.checkViay();
        ani = f.checkAni();
        vari = f.checkVari();
        breaki = f.checkBreaki();
        labi = f.checkLabi();
        tracki = f.checkWRTracker();
        ayi = f.checkAyi();
        carti = f.checkCartridge();
        joyi = f.checkJoyportDevice();
        profi = f.checkProfi();
    }

    public int getXReg()
    {
        return vecx.e6809.reg_x;
    }
    public int getYReg()
    {
        return vecx.e6809.reg_y;
    }
    public int getSReg()
    {
        return vecx.e6809.reg_s.intValue;
    }
    public int getUReg()
    {
        return vecx.e6809.reg_u.intValue;
    }
    public int getDReg()
    {
        return vecx.e6809.reg_a<<8+vecx.e6809.reg_b;
    }
    public int getAReg()
    {
        return vecx.e6809.reg_a;
    }
    public int getBReg()
    {
        return vecx.e6809.reg_b;
    }
    public int getPCReg()
    {
        return vecx.e6809.reg_pc;
    }
    public int getDPReg()
    {
        return vecx.e6809.reg_dp;
    }
    public int getCCReg()
    {
        return vecx.e6809.reg_cc;
    }
    public void setJoyportDevice(int port, JoyportDevice d)
    {
        mClassSetting++;
        if (port == 0)
        {
            if (d == null)
                jComboBoxJoyport0.setSelectedIndex(-1);
        }
        if (port == 1)
        {
            if (d == null)
                jComboBoxJoyport1.setSelectedIndex(-1);
        }
        mClassSetting--;
    }
    
    // start a thread with emulation
    public boolean oneSlaveEmulation(int cycles)
    {
        boolean stopEmulation = false;
        if (cycles == 1)
        {
            vecx.directDrawActive = true;
        }
        setLightPen();

        exitReason = vecx.vecx_emu(cycles);    

        vecx.directDrawActive = false;
        if (exitReason == EMU_EXIT_BREAKPOINT_BREAK)
        {
            stepping = false;
            stopEmulation = true;
            return stopEmulation;
        }
        if (exitReason == EMU_EXIT_BREAKPOINT_CONTINUE)
        {
            breakpointHandleContinue(vecx.activeBreakpoint);
        }
        if (stepping)
        {
            try 
            {
                SwingUtilities.invokeLater(new Runnable()
                {
                    public void run()
                    {
                        updateDisplay();
                        updateAvailableWindows(true, false, true);

                    }
                });                    
                if (config.multiStepDelay>0)
                    Thread.sleep(config.multiStepDelay);
            } 
            catch(InterruptedException v) 
            {
            }
        }
        else
        {
            SwingUtilities.invokeLater(new Runnable()
            {
                public void run()
                {
                    updateAvailableWindows(true, false, false);
                }
            });
        }
        
        return stopEmulation;
    }
    public AT24C02 getAtmel()
    {
        if (vecx == null) return null;
        if (vecx.cart == null) return null;
        if (vecx.cart.isAtmel == false) return null;
        return vecx.cart.atmel;
    }
    public Microchip11AA010 getMicrochip()
    {
        if (vecx == null) return null;
        if (vecx.cart == null) return null;
        if (vecx.cart.isMicrochip == false) return null;
        return vecx.cart.microchip;
    }
    public DS2430A getDS2430A()
    {
        if (vecx == null) return null;
        if (vecx.cart == null) return null;
        if (vecx.cart.is2430a == false) return null;
        return vecx.cart.ds2430;
    }
    public DS2431 getDS2431()
    {
        if (vecx == null) return null;
        if (vecx.cart == null) return null;
        if (vecx.cart.isDS2431 == false) return null;
        return vecx.cart.ds2431;
    }
    public VectrexJoyport[] getJoyportDevices()
    {
        return vecx.joyport;
    }
    public boolean setRegister(String register, int value)
    {
        boolean ok = vecx.setRegister(register, value);
        updateAvailableWindows(true, false, true);
        return ok;
    }
    
    boolean ledState = false;
    public boolean isLEDState()
    {
        return ledState;
    }// 0 = invisible, 1 = on, 2 = off
    public void setLED(int state)
    {
        ledState = (state == 1);
    }// 0 = invisible, 1 = on, 2 = off
 
    public BufferedImage getOverlayImageOrg()
    {
        return overlayImageOrg;
    }
    void checkOverlay()
    {
        if (config.overlayEnabled)
        {
            try
            {
                if (overlayImageOrg==null) 
                {
                    if (vecx.cart.currentCardProp != null)
                        loadOverlay(vecx.cart.currentCardProp.getOverlay()); // ensure overlay in scaled form is available
                }
                if (overlayImageOrg==null) 
                {
                    loadOverlay(vecx.cart.cartName); // ensure overlay in scaled form is available
                }
            }
            catch (Throwable e)
            {
                
            }
            try
            {
                if (overlayImageOrg==null) 
                {
                    if (vecx.cart==null)
                        loadOverlay(vecx.romName);
                }
            }
            catch (Throwable e)
            {
                
            }
        }
    }
    public String dumpCurrentROM()
    {
        if (vecx == null) return null;
        return vecx.dumpCurrentROM();
    }
    
    public Profiler getProfiler()
    {
        if (vecx == null) return null;
        if (!config.doProfile) return null;
        return vecx.profiler;
    }
    


    /* was called from ray move
    int lsCounter = 0;
    float[] dataRay = new float[200000];
    void addGLLineSegment(int x0, int y0, int x1, int y1)
    {
        if (lsCounter>200000-4) return;
        dataRay[lsCounter++] =Scaler.scaleFloatToFloat(x0-config.ALG_MAX_X/2, scaleWidthGL);
        dataRay[lsCounter++] =Scaler.scaleFloatToFloat(-(y0-config.ALG_MAX_Y/2), scaleHeightGL);
        dataRay[lsCounter++] =Scaler.scaleFloatToFloat(x1-config.ALG_MAX_X/2, scaleWidthGL);
        dataRay[lsCounter++] =Scaler.scaleFloatToFloat(-(y1-config.ALG_MAX_Y/2), scaleHeightGL);
    }
    */
    
    public boolean isJOGL()
    {
        return config.tryJOGL;
    }

    DisplayPanelInterface displayPanel=null;
/*
    new DisplayPanelInterface()
    {
        @Override public void setRotation(int angle) {}
        @Override public void stopGraphics() {}
        @Override public void setLightPen() {}
        @Override public void setVecxiPanel(VecxiPanel vp) {}
        @Override public void internalReinit() {}
        @Override public void forceResize() {}
        @Override public void paintVectrex() {}
        @Override public void deinit() {}
        @Override public void init() {}
        @Override public void reset() {}
        @Override public void resetDirectdraw() {}
        @Override public void overlayChanged() {}
        @Override public void switchDisplay() {}
        @Override public void updateDisplay() {}
        @Override public void directDraw(vector_t v) {}
        @Override public void rayMove(int x0, int y0, int x1, int y1, int color, int dwell, boolean curved, int alg_vector_speed, int alg_leftEye, int alg_rightEye) {}
    };
*/
    boolean inResize = false;
    public void forceResize()
    {
        if (inResize) return;
        inResize = true;
        Rectangle bounds = jPanel1.getBounds();
        bounds.width = this.getWidth();
        jPanel1.setBounds(bounds);

        if (displayPanel instanceof VecxiPanel_JOGL)
            changeDisplay();
        else
            displayPanel.forceResize();

        invalidate();
        validate();
        repaint();
        inResize = false;
    }

    public void doRedraw()
    {
        updateDisplay();
        repaint();
    }
    public void stopGraphics()
    {
        displayPanel.stopGraphics();
    }
    
    public void directDraw(vector_t v)// from display interface, used by vecxi
    {
        displayPanel.directDraw(v);
    }
    public void resetDirectdraw()
    {
        displayPanel.resetDirectdraw();
    }
    synchronized public void switchDisplay()// from display interface, used by vecxi, Ray
    {
        displayPanel.switchDisplay();
    }
    // when something not in the control of vecxi "happens" (dissi...)
    synchronized public void updateDisplay()// from display interface, used by vecxi
    {
        displayPanel.updateDisplay();
    }
    
    
    public void overlayChanged()
    {
        if (displayPanel != null)
        {
            displayPanel.overlayChanged();
        }
    }
    synchronized public void changeDisplay()
    {
        overlayImageOrg = null;
        if (displayPanel != null)
        {
            displayPanel.deinit();
            this.remove((javax.swing.JPanel)displayPanel);
            displayPanel = null;
        }
        
        if ((config.tryJOGL) && (JOGLSupport.isJOGLSupported()))
        {
            try
            {
                VecxiPanel_JOGL vecpanel = VecxiPanel_JOGL.getJOGLPanel( this ); 
                displayPanel = vecpanel;
                this.add(vecpanel);
            }
            catch (Throwable e)
            {
                JOGLSupport.setJOGLSupported(false);
                log.addLog("JOGL init failed for Vecxi - disabling JOGL");

                VecxiPanel_JAVA vecpanel = new VecxiPanel_JAVA( this ); 
                displayPanel = vecpanel;
                this.add(vecpanel);
            }
        }
        else
        {
            VecxiPanel_JAVA vecpanel = new VecxiPanel_JAVA( this ); 
            displayPanel = vecpanel;
            this.add(vecpanel);
        }
        forceResize();
        checkOverlay(); 
    }
    
    VectrexDisplayVectors getDisplayList()
    {
        if (vecx==null) return new VecX.VectrexDisplayVectors();
        return vecx.getDisplayList();
    }

    public double getIntegratorX()
    {
        if (vecx==null) return 0;
        return vecx.alg_curr_x;
    }
    public double getIntegratorY()
    {
        if (vecx==null) return 0;
        return vecx.alg_curr_y;
    }
    public int getYOffset()
    {
        if (jPanel1.isVisible())
            return jPanel1.getHeight()+1;
        return 0;
    }
    public void deIconified() // deiconify leaves JOGL in unhealthy state
    {
        if (displayPanel instanceof VecxiPanel_JOGL)
            SwingUtilities.invokeLater(new Runnable() {
                @Override
                public void run()
                {
                    changeDisplay();
                }
            });
    }
    boolean ptoggle = false;
    public void toggleMainPanel()
    {
        if (!config.tryJOGL) return;
        CSAMainFrame mf = (CSAMainFrame)Configuration.getConfiguration().getMainFrame();
        
        if (ftoggle) return; // don't switch in fullscreen
        
        if (ptoggle)//(Configuration.getConfiguration().mIsFullscreen)
        {
            jPanel1.setVisible(true);
            mf.windowMe(this,10,10,"vecxi");
        }
        else
        {
            mf.saveState(this, mf.getInternalFrame(this));
            jPanel1.setVisible(false);
            mf.desktopMe(this);
        }
        ptoggle = !ptoggle;
        changeDisplay();
    }
    boolean ftoggle = false;
    public void toggleFullscreen()
    {
        if (!config.tryJOGL) return;
        CSAMainFrame mf = (CSAMainFrame)Configuration.getConfiguration().getMainFrame();
        
        if (ftoggle)
        {
            ftoggle = !ftoggle;
            mf.toWindowed();
            toggleMainPanel();
        }
        else
        {
            if (!ptoggle)
            {
                toggleMainPanel();
            }
            mf.toFullscreen();
            ftoggle = !ftoggle;
        }
        SwingUtilities.invokeLater(new Runnable() {
            @Override
            public void run()
            {
                changeDisplay();
            }
        });
    }
    String forcedOverlay = "";
    public void setOverlay(String overlayFile)
    {
        forcedOverlay = overlayFile;
        SwingUtilities.invokeLater(new Runnable() {
            @Override
            public void run()
            {
                changeDisplay();
            }
        });
    }
    public long getTrackiCount()
    {
        return vecx.trackyCount;
    }
    public long getTrackiAbove()
    {
        return vecx.trackyAbove;
    }

    int old_x=0;
    int old_y=0;
    public void setMouseCoordinates(ControllerEvent event)
    {
        // test is mouse over vecx panel
        // if so - set new coordinates
        
        if (displayPanel != null) 
        {
            JPanel panel = (JPanel)displayPanel;
            Point p = panel.getMousePosition();
            if (p != null)
            {
                float mx = p.x;
                float my = p.y;
                
                float percentX = mx /((float)(panel.getWidth()));
                float percentY = my /((float)(panel.getHeight()));
                float maxVectrexPos = 256;
                old_x = (int) (maxVectrexPos*percentX);
                old_y = -(int) (maxVectrexPos*percentY);
// $80 == 0
// $ff ==right
// $00 == left
                old_x =(old_x&0xff);
                old_y =(old_y&0xff);
            }
        }
        event.x=old_x;
        event.y=old_y;
    }
    
}
