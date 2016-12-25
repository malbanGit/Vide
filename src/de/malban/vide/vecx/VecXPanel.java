/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx;

import de.malban.Global;
import static org.lwjgl.glfw.GLFW.*;
import static org.lwjgl.opengl.GL11.*;

import de.malban.vide.vecx.devices.LightpenDevice;
import de.malban.vide.VideConfig;
import de.malban.config.Configuration;
import de.malban.graphics.GFXVector;
import de.malban.graphics.GFXVectorList;
import de.malban.graphics.SingleVectorPanel;
import de.malban.gui.CSAMainFrame;
import de.malban.gui.HotKey;
import de.malban.gui.ImageCache;
import de.malban.gui.Scaler;
import de.malban.gui.Stateable;
import de.malban.gui.Windowable;
import de.malban.gui.components.CSAView;
import de.malban.gui.dialogs.InternalFrameFileChoser;
import de.malban.gui.dialogs.ShowErrorDialog;
import de.malban.gui.panels.LogPanel;
import static de.malban.gui.panels.LogPanel.INFO;

import de.malban.lwgl.LWJGLRenderer;
import de.malban.lwgl.LWJGLSupport;
import de.malban.lwgl.LWJGLSupport.GLWindow;

import de.malban.util.KeyboardListener;
import de.malban.vide.ControllerConfig;
import de.malban.vide.dissy.DissiPanel;
import de.malban.vide.dissy.MemoryInformation;
import static de.malban.vide.vecx.VecX.START_TYPE_INJECT;
import static de.malban.vide.vecx.VecX.START_TYPE_RUN;
import de.malban.vide.vecx.cartridge.Cartridge;
import de.malban.vide.vecx.VecX.VectrexDisplayVectors;
import de.malban.vide.vecx.VecXState.vector_t;
import static de.malban.vide.vecx.VecXStatics.EMU_EXIT_BREAKPOINT_BREAK;
import static de.malban.vide.vecx.VecXStatics.EMU_TIMER;
import static de.malban.vide.vecx.VecXStatics.VECTREX_MHZ;
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
import de.malban.vide.vecx.spline.CardinalSpline;
import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Point;
import java.awt.RenderingHints;
import java.awt.event.MouseEvent;
import java.awt.geom.AffineTransform;
import java.awt.geom.GeneralPath;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.Serializable;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.SwingUtilities;
import de.malban.vide.vecx.spline.Pt;
import de.malban.vide.vecx.panels.AnalogJPanel;
import de.malban.vide.vecx.panels.BreakpointJPanel;
import de.malban.vide.vecx.panels.CartridgePanel;
import de.malban.vide.vecx.panels.JoyportPanel;
import de.malban.vide.vecx.panels.LabelJPanel;
import de.malban.vide.vecx.panels.MemoryDumpPanel;
import de.malban.vide.vecx.panels.PSGJPanel;
import de.malban.vide.vecx.panels.RegisterJPanel;
import de.malban.vide.vecx.panels.VIAJPanel;
import de.malban.vide.vecx.panels.VarJPanel;
import de.malban.vide.vecx.panels.VectorInfoJPanel;
import de.malban.vide.vecx.panels.WRTrackerJPanel;
import static java.awt.BasicStroke.CAP_ROUND;
import static java.awt.BasicStroke.JOIN_ROUND;
import java.awt.event.ActionEvent;
import java.nio.FloatBuffer;
import javax.swing.AbstractAction;
import javax.swing.DefaultComboBoxModel;
import org.lwjgl.BufferUtils;
import org.lwjgl.opengl.GL11;
import org.lwjgl.opengl.GL15;

/**
 *
 * @author malban
 */
public class VecXPanel extends javax.swing.JPanel  
    implements  Windowable, 
                DisplayerInterface, 
                VecXStatics, LWJGLRenderer, 
                Stateable
{
    public boolean isLoadSettings() { return true; }
    LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
    VideConfig config = VideConfig.getConfig();
    private CSAView mParent = null;
    private javax.swing.JMenuItem mParentMenuItem = null;
    private int mClassSetting=0;
    VecX vecx;
    BufferedImage overlayImageOrg=null;
    BufferedImage overlayImageScaled=null;
    
    BufferedImage[] phosphor = new BufferedImage[2];
    int phosphorDraw = 0;
    int phosphorDisplay = 1;
    boolean cartProp = true;
    
    
    boolean updateAllways = false;
    
    public boolean stop = false;
    public volatile boolean running = false;
    public boolean pausing = false;
    private boolean pauseMode = false;
    public boolean debuging = false;
    public boolean stepping = false;
    public boolean mouseMode = false;
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
    int vectrexDisplayWidth = 0;
    int vectrexDisplayheight = 0;
    double scaleWidth = 0;
    double scaleHeight = 0;
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
    LabelJPanel labi = null;
    WRTrackerJPanel tracki = null;
    PSGJPanel ayi = null;
    JoyportPanel joyi = null;
    CartridgePanel carti = null;
    
    BufferedImage image;
    int startTypeRun = START_TYPE_RUN;

    @Override
    public void closing()
    {
        deinit();
        if (vecx!=null)
        {
            vecx.deinit();
        }
        if (isLWJGL)
            LWJGLSupport.getLWJGLSupport().removeWindow(w);
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
        mParentMenuItem.setText("VecX");
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
        vecx = new VecX();
        ensureDevices();
        initJoyportsFromFlag();
        vecx.setDisplayer(this);
        updatePorts();
        resetGfx();
        initLWGL();
        
        
        
        new HotKey("Pause/Toggle", new AbstractAction() { public void actionPerformed(ActionEvent e) {  jButtonPauseActionPerformed(null); }}, this);
        new HotKey("Overlay/Toggle", new AbstractAction() { public void actionPerformed(ActionEvent e) { config.overlayEnabled = !config.overlayEnabled; checkOverlay();}}, this);
        new HotKey("VecX QuickSave", new AbstractAction() { public void actionPerformed(ActionEvent e) {  jButtonSaveStateActionPerformed(null); }}, this);
        new HotKey("VecX QuickLoad", new AbstractAction() { public void actionPerformed(ActionEvent e) {  jButtonLoadStateActionPerformed(null); }}, this);
        new HotKey("RingbufferToggle", new AbstractAction() { public void actionPerformed(ActionEvent e) {  ringbufferToggle(); }}, this);


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

        setName("vecxy"); // NOI18N
        addMouseMotionListener(new java.awt.event.MouseMotionAdapter() {
            public void mouseMoved(java.awt.event.MouseEvent evt) {
                formMouseMoved(evt);
            }
            public void mouseDragged(java.awt.event.MouseEvent evt) {
                formMouseDragged(evt);
            }
        });
        addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                formMousePressed(evt);
            }
            public void mouseReleased(java.awt.event.MouseEvent evt) {
                formMouseReleased(evt);
            }
            public void mouseExited(java.awt.event.MouseEvent evt) {
                formMouseExited(evt);
            }
            public void mouseEntered(java.awt.event.MouseEvent evt) {
                formMouseEntered(evt);
            }
        });
        addComponentListener(new java.awt.event.ComponentAdapter() {
            public void componentResized(java.awt.event.ComponentEvent evt) {
                formComponentResized(evt);
            }
        });

        jLabel1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/Port.png"))); // NOI18N
        jLabel1.setText("1");
        jLabel1.setPreferredSize(new java.awt.Dimension(43, 21));

        jComboBoxJoyport1.setModel(new javax.swing.DefaultComboBoxModel(new String[] { " ", "Keyboard Controler", "Lightpen", "VecVox", "VecVoice", "VecLinkV1", "VecLinkV2", "3d-Imager" }));
        jComboBoxJoyport1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBoxJoyport1ActionPerformed(evt);
            }
        });

        jLabel2.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/Port.png"))); // NOI18N
        jLabel2.setText("0");
        jLabel2.setPreferredSize(new java.awt.Dimension(43, 21));

        jComboBoxJoyport0.setModel(new javax.swing.DefaultComboBoxModel(new String[] { " ", "Keyboard Controler", "Lightpen" }));
        jComboBoxJoyport0.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBoxJoyport0ActionPerformed(evt);
            }
        });

        jButtonPause.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/control_pause.png"))); // NOI18N
        jButtonPause.setToolTipText("Pauses current running emulation...");
        jButtonPause.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonPause.setPreferredSize(new java.awt.Dimension(21, 21));
        jButtonPause.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonPauseActionPerformed(evt);
            }
        });

        jButtonStop.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/control_stop.png"))); // NOI18N
        jButtonStop.setToolTipText("Stops and unloads ROM!");
        jButtonStop.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonStop.setPreferredSize(new java.awt.Dimension(21, 21));
        jButtonStop.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonStopActionPerformed(evt);
            }
        });

        jButtonFileSelect1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/folder_go.png"))); // NOI18N
        jButtonFileSelect1.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonFileSelect1.setPreferredSize(new java.awt.Dimension(21, 21));
        jButtonFileSelect1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonFileSelect1ActionPerformed(evt);
            }
        });

        jLabelFPS.setFont(new java.awt.Font("Geneva", 0, 8)); // NOI18N
        jLabelFPS.setText("0");
        jLabelFPS.setPreferredSize(new java.awt.Dimension(5, 21));
        jLabelFPS.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jLabelFPSMouseClicked(evt);
            }
        });

        jTextFieldstart.setText("FROGGER.BIN");
        jTextFieldstart.setFocusable(false);
        jTextFieldstart.setName("vecxy"); // NOI18N
        jTextFieldstart.setPreferredSize(new java.awt.Dimension(75, 21));

        jButtonDebug.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/bug_go.png"))); // NOI18N
        jButtonDebug.setToolTipText("Associate dissi with this vecx instance.");
        jButtonDebug.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonDebug.setPreferredSize(new java.awt.Dimension(21, 21));
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
        jButtonLoadState.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonLoadState.setPreferredSize(new java.awt.Dimension(21, 21));
        jButtonLoadState.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonLoadStateActionPerformed(evt);
            }
        });

        jButtonSaveState.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/page_save.png"))); // NOI18N
        jButtonSaveState.setToolTipText("save state");
        jButtonSaveState.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonSaveState.setPreferredSize(new java.awt.Dimension(21, 21));
        jButtonSaveState.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSaveStateActionPerformed(evt);
            }
        });

        jButtonStart.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/control_play.png"))); // NOI18N
        jButtonStart.setToolTipText("<html>Starts selected ROM, no effect if running!<BR>\nSHIFT click resets and starts new!\n</html>\n"); // NOI18N
        jButtonStart.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonStart.setPreferredSize(new java.awt.Dimension(21, 21));
        jButtonStart.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonStartActionPerformed(evt);
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
                .addGap(0, 0, 0)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addComponent(jTextFieldstart, javax.swing.GroupLayout.PREFERRED_SIZE, 100, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jButtonFileSelect1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(2, 2, 2)
                        .addComponent(jLabelFPS, javax.swing.GroupLayout.PREFERRED_SIZE, 18, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(3, 3, 3)
                        .addComponent(jButtonStart, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButtonPause, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButtonStop, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButtonSaveState, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButtonLoadState, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButtonDebug, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jComboBoxJoyport0, 0, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jComboBoxJoyport1, 0, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(31, Short.MAX_VALUE))
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jButtonStop, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButtonPause, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButtonStart, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButtonFileSelect1, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextFieldstart, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel5, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButtonDebug, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButtonLoadState, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButtonSaveState, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabelFPS, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(1, 1, 1)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jLabel2, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jComboBoxJoyport0, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(1, 1, 1)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jComboBoxJoyport1, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)))
        );

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addComponent(jPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0))
        );
    }// </editor-fold>//GEN-END:initComponents

    private void jButtonFileSelect1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonFileSelect1ActionPerformed
        InternalFrameFileChoser fc = new de.malban.gui.dialogs.InternalFrameFileChoser();
        fc.setCurrentDirectory(new java.io.File("."+File.separator));
        int r = fc.showOpenDialog(Configuration.getConfiguration().getMainFrame());
        if (r != InternalFrameFileChoser.APPROVE_OPTION) return;
        String name = fc.getSelectedFile().getAbsolutePath();
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

        if (KeyboardListener.isShiftDown())
        {
            jButtonStopActionPerformed(evt); // stop
            // ... and run :-)... meaning go on...
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
        
        if (dissi == null)
        {
            createDissi();
            if (dissi == null) return; 
        }
        setDissi(dissi);
        

        
        if (startTypeRun != START_TYPE_INJECT)
        {
            vecx.init(jTextFieldstart.getText(), cartProp);
            dissi.dis(vecx.cart);
            if (startTypeRun == VecX.START_TYPE_DEBUG)
                dissi.setStartbreakpoint();
            if (config.overlayEnabled)
                loadOverlay(jTextFieldstart.getText()); // ensure overlay in scaled form is available
            checkWindows();
            initJoyportsFromFlag();
        }
        else
        {
            vecx.inject(jTextFieldstart.getText(), cartProp);
            dissi.dis(vecx.cart);
        }
        
        
        
        dissiInit = true;
        stop = true;
        dissi.processHeyDissis();
        setLED(0);
        resetGfx();
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
    public void startUp(String path, boolean checkCartridge, int runType)
    {
        startTypeRun = runType;
        if (image == null)
            resetGfx();
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
        if (image == null)
            resetGfx();
        jTextFieldstart.setText(path);
        cartProp = true;
        jButtonStartActionPerformed(null);
    }

    public boolean loadOverlay(String name)
    {
        try
        {
            Path base = Paths.get("./");
            Path fromPath = base.resolve(Paths.get(name));

            String fName = fromPath.getFileName().toString();

            String fullname = fromPath.toString().toLowerCase();
            fullname  = de.malban.util.UtilityString.replace(fullname, ".rom", ".png");
            fullname = de.malban.util.UtilityString.replace(fullname, ".bin", ".png");
            fullname = de.malban.util.UtilityString.replace(fullname, ".vec", ".png");

            name = de.malban.util.UtilityString.replace(fName.toLowerCase(), ".rom", ".png");
            name = de.malban.util.UtilityString.replace(name, ".bin", ".png");
            name = de.malban.util.UtilityString.replace(name, ".vec", ".png");
            overlayImageOrg = ImageCache.getImageCache().getImage("overlays"+File.separator+name);
            if (overlayImageOrg==null) overlayImageOrg = ImageCache.getImageCache().getImage(name);
            if (overlayImageOrg==null) overlayImageOrg = ImageCache.getImageCache().getImage("."+File.separator+name);
            if (overlayImageOrg==null) overlayImageOrg = ImageCache.getImageCache().getImage("."+File.separator+"overlays"+File.pathSeparator+name);
            if (overlayImageOrg==null) overlayImageOrg = ImageCache.getImageCache().getImage(fullname);
        }
        catch (Throwable e)
        {
            
        }
        if (overlayImageOrg==null) 
        {
            if (name.toUpperCase().contains("SYSTEM"))
                overlayImageOrg = ImageCache.getImageCache().getImage("overlays"+File.separator+"mine.png");
        }
        if (overlayImageOrg==null) return false;
        resetGfx();            
        
        return true;
    }
    
    private void jButtonPauseActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonPauseActionPerformed
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
    
    private void jButtonStopActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonStopActionPerformed
        stop();
        if (dissi != null)
            dissi.deinit();
        dissiInit = false;
        overlayImageScaled = null;
        overlayImageOrg = null;
    }//GEN-LAST:event_jButtonStopActionPerformed
    private void formComponentResized(java.awt.event.ComponentEvent evt) {//GEN-FIRST:event_formComponentResized
        forceResize();
    }//GEN-LAST:event_formComponentResized
    public void forceResize()
    {
        resetGfx();
        paint(vecx.getDisplayList());
        repaint();
    }
    private void jButtonSaveStateActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSaveStateActionPerformed
        if (stop) 
        {
            if (debuging)
            {
                CompleteState state = vecx.getState();
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
                CSAMainFrame.serialize(state, "serialize"+File.separator+"StateSaveTest.ser");
                
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
            CSAMainFrame.serialize(state, "serialize"+File.separator+"StateSaveTest.ser");
            cont();
            return;
        }
        CompleteState state = vecx.getState();
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
        CSAMainFrame.serialize(state, "serialize"+File.separator+"StateSaveTest.ser");

    }//GEN-LAST:event_jButtonSaveStateActionPerformed
    private void jButtonLoadStateActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonLoadStateActionPerformed
        stop();
        dissiInit = false;

        CompleteState state = (CompleteState) CSAMainFrame.deserialize("serialize"+File.separator+"StateSaveTest.ser");
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

        
        jTextFieldstart.setText(vecx.romName);
        overlayImageOrg = null;
        overlayImageScaled = null;
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
        resetGfx();
        start();
    }//GEN-LAST:event_jButtonLoadStateActionPerformed
    public void debugUndoAction()
    {
        if (!isDebuging())
            return;
        if (stepping) return;
        vecx.oneStepBackInRingbuffer();
        paint(vecx.getDisplayList());
        repaint();
        updateAvailableWindows(true, false, true);
        
    }    
    public void debugRedoAction()
    {
        if (!isDebuging())
            return;
        if (stepping) return;
        vecx.oneStepForwardInRingbuffer();
        paint(vecx.getDisplayList());
        repaint();
        updateAvailableWindows(true, false, true);
    }    
    
    public void debugStepoutAction()
    {
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

    private void formMouseExited(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_formMouseExited
        noCross = true;
    }//GEN-LAST:event_formMouseExited

    private void formMouseEntered(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_formMouseEntered
        noCross = false;
    }//GEN-LAST:event_formMouseEntered

    private void formMousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_formMousePressed
        if ((!mouseMode) && (!deviceList.get(DEVICE_LIGHTPEN).isActive())) return;
        shiftPressed = false;
        if (evt.getButton() == MouseEvent.BUTTON1)
        {
            mousePressed = true;
            mXPressStart = evt.getX();
            mYPressStart = evt.getY();
            shiftPressed = KeyboardListener.isShiftDown();
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
            shiftPressed = KeyboardListener.isShiftDown();
        }
        if (deviceList.get(DEVICE_LIGHTPEN).isActive()) unsetLightPen();
        if (!mouseMode) return;
        crossColor = Color.ORANGE;
        repaint();
    }//GEN-LAST:event_formMouseReleased

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

    boolean toggleDisplay = true;
    private void jLabelFPSMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabelFPSMouseClicked
        // TODO add your handling code here:
        if (!Global.LWJGL_ENABLE) return;
        toggleDisplay = !toggleDisplay;
    }//GEN-LAST:event_jLabelFPSMouseClicked

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
    private javax.swing.JComboBox jComboBoxJoyport0;
    private javax.swing.JComboBox jComboBoxJoyport1;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JLabel jLabelFPS;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JTextField jTextFieldstart;
    // End of variables declaration//GEN-END:variables


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

                        exitReason = vecx.vecx_emu(cyclesToRun);    
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
                                paint(vecx.getDisplayList());
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
        one.start();           
    }
    
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
            dissi.goAddress(vecx.e6809.reg_pc, true, false, true);
        updateDisplay();
    }

    public void stopDebug(boolean noRestart)
    {
        if (!noRestart)
            start();
        directDrawVector = null;
        debuging = false;
        vecx.config.syncCables = false;
    }
    
    public void oneStep()
    {
        if (!debuging) return;
        setLightPen();
        vecx.directDrawActive = true;
        vecx.vecx_emu(1); // only one instruction!
        paint(vecx.getDisplayList());
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
        if (image != null)
        {
            Graphics2D g2 = image.createGraphics();
            g2.clearRect(0, 0, image.getWidth(), image.getHeight());
            
        }
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
    
    public void updateDisplay()
    {
        if (!config.useRayGun)
            paint(vecx.getDisplayList());
        repaint();
    }
    public int getVectorCount()
    {
        return vecx.getDisplayList().count;
    }

    
    void drawCatmullRom(ArrayList<Point> spline, Graphics2D g2, int color, int speed, int left, int right)
    {
        synchronized (spline)
        {
            if (config.useQuads)
            {
                drawAsQuads(spline, g2,  color, speed, left, right);
                return;
            }

            Color c = new Color(210,210,255,color/*>>3*/ );
            c = getColor(color, left, right);
            g2.setColor(c);
            
            if (spline.size() == 2)
            {
                drawAsQuads(spline, g2,  color, speed, left, right);
                return;
            }
            CardinalSpline cs = new CardinalSpline();
            for (Point p: spline)
            {
                Pt pt = new Pt(p.x,p.y);
                cs.addPoint(pt);
            }
            cs.caculate();

            ArrayList<Pt> pts = cs.getPoints();
            ArrayList<Point> nP = new ArrayList<Point>();
            for (int i=0;i<pts.size(); i++)
            {
                nP.add(new Point(pts.get(i).ix(), pts.get(i).iy()));
            }
            if (nP.size()>0)
                drawAsQuads(nP, g2,  color, speed, left, right);

             
        }
      }

    void drawAsQuads(ArrayList<Point> spline, Graphics2D g2, int color, int speed, int left, int right)
    {
        synchronized (spline)
        {
            int counter = 0;
            GeneralPath path = new GeneralPath(GeneralPath.WIND_NON_ZERO);
        //    Color c = new Color(100,255,100,color );
            Color c = new Color(210,210,255,color );
            c = getColor(color, left, right);
            g2.setColor(c);
            path.moveTo(Scaler.scaleDoubleToInt(spline.get(counter).x, scaleWidth), Scaler.scaleDoubleToInt(spline.get(counter).y, scaleHeight));
            counter++;
            boolean doIt = true;
            int circleX = 0;
            int circleY = 0;
            if (spline.size() == 2)
            {
                if (    (Scaler.scaleDoubleToInt(spline.get(0).x, scaleWidth) == Scaler.scaleDoubleToInt(spline.get(1).x, scaleWidth)) &&
                        (Scaler.scaleDoubleToInt(spline.get(0).y, scaleHeight) == Scaler.scaleDoubleToInt(spline.get(1).y, scaleHeight)))
                {
                    circleX = Scaler.scaleDoubleToInt(spline.get(0).x, scaleWidth);
                    circleY = Scaler.scaleDoubleToInt(spline.get(0).y, scaleHeight);
                    if (circleX<3)circleX=0;
                    if (circleY<3)circleY=0;
                }
            }
            while (doIt)
            {
                int remaining = spline.size()-counter; // 
                if (remaining == 1) // BAD  draw a simple line
                {
                    
                    path.lineTo(Scaler.scaleDoubleToInt(spline.get(counter).x, scaleWidth), Scaler.scaleDoubleToInt(spline.get(counter).y, scaleHeight));
                    break;
                }
                if (remaining == 2) // ok, draw a   quad
                {
                    path.quadTo(Scaler.scaleDoubleToInt(spline.get(counter+0).x, scaleWidth), Scaler.scaleDoubleToInt(spline.get(counter+0).y, scaleHeight),
                                Scaler.scaleDoubleToInt(spline.get(counter+1).x, scaleWidth), Scaler.scaleDoubleToInt(spline.get(counter+1).y, scaleHeight));
                    break;
                }
                if (remaining == 3) // ok, draw a curve
                {
                    path.curveTo(Scaler.scaleDoubleToInt(spline.get(counter+0).x, scaleWidth), Scaler.scaleDoubleToInt(spline.get(counter+0).y, scaleHeight),
                                 Scaler.scaleDoubleToInt(spline.get(counter+1).x, scaleWidth), Scaler.scaleDoubleToInt(spline.get(counter+1).y, scaleHeight),
                                 Scaler.scaleDoubleToInt(spline.get(counter+2).x, scaleWidth), Scaler.scaleDoubleToInt(spline.get(counter+2).y, scaleHeight));
                    break;
                }
                if (remaining == 4) // ok, draw a curve
                {
                    path.quadTo(Scaler.scaleDoubleToInt(spline.get(counter+0).x, scaleWidth), Scaler.scaleDoubleToInt(spline.get(counter+0).y, scaleHeight),
                                Scaler.scaleDoubleToInt(spline.get(counter+1).x, scaleWidth), Scaler.scaleDoubleToInt(spline.get(counter+1).y, scaleHeight));
                    counter+=2;
                    continue;
                }
                path.curveTo(Scaler.scaleDoubleToInt(spline.get(counter+0).x, scaleWidth), Scaler.scaleDoubleToInt(spline.get(counter+0).y, scaleHeight),
                             Scaler.scaleDoubleToInt(spline.get(counter+1).x, scaleWidth), Scaler.scaleDoubleToInt(spline.get(counter+1).y, scaleHeight),
                             Scaler.scaleDoubleToInt(spline.get(counter+2).x, scaleWidth), Scaler.scaleDoubleToInt(spline.get(counter+2).y, scaleHeight));
                counter+=3;
            }

            if (config.useGlow)
            {
                color = color <<2; // 7f is max color
                double speedFactor; 
                if (speed>128) // dot dwell
                {
                    speedFactor = ((double)speed)/128.0; 
                }
                else
                {
                    speedFactor = 1.0 - (((double)speed)/512.0);
                }
                color= (int) ((double)color *(speedFactor));

                double brightness = getBrightness();
                color= (int) ((double)color *(brightness));
                color = color/3;
                int halo = color/BASE_GLOW_OFFSET;
                halo*=2;


                for (int i=0; i< halo; i++)
                {
                    int alpha = BASE_GLOW_OFFSET/(3*(halo-i));
                    int width = (halo-i)*config.lineWidth;
                    if (alpha == 0) continue;
                    g2.setStroke(new BasicStroke(width,  CAP_ROUND, JOIN_ROUND)) ;
                    Color cc = new Color(210,210,255,alpha );
                    cc = getColor(alpha, left, right);
                    g2.setColor(cc);
                    if ((circleX != 0) || (circleY != 0))
                    {
                        g2.drawLine(((int) circleX), ((int) circleY), ((int) circleX),((int) circleY));
                    }
                    else
                    {
                        g2.draw( path );            
                    }
                }
                g2.setStroke(new BasicStroke(config.lineWidth,  CAP_ROUND, JOIN_ROUND));
                if (color>BASE_GLOW_OFFSET)
                    color=BASE_GLOW_OFFSET;
                Color cc = new Color(210,210,255,color );
                cc = getColor(color, left, right);
                g2.setColor(cc);
                if ((circleX != 0) || (circleY != 0))
                {
                    g2.drawLine(((int) circleX), ((int) circleY), ((int) circleX),((int) circleY));
                }
                else
                    g2.draw( path );            

                if ((config.lineWidth%2!=0) && (config.lineWidth!=1))
                {
                    g2.setStroke(new BasicStroke(config.lineWidth/2));
                    int col = color*2;
                    if (col > 255) col = 255;
                    cc = new Color(210,210,255,col );
                    cc = getColor(col, left, right);
                    g2.setColor(cc);
                    if ((circleX != 0) || (circleY != 0))
                        g2.drawLine(((int) circleX), ((int) circleY), ((int) circleX),((int) circleY));
                    else
                        g2.draw( path );            
                }
            }
            else
            {
                g2.draw( path );            
            }
        }
    }
    
    // this is a quick hack to get imager colors
    Color getColor(int alpha, int left, int right)
    {
        Color color = new Color(210,210,255,alpha);
        if (!vecx.imagerMode)
            return color;
        if ((left == -2) ||(right == -2)) // draw bw
        {
            return color;
        }

        Imager3dDevice i3d = (Imager3dDevice) vecx.joyport[1].getDevice();
        if (left > 0)
            color =  i3d.getWheel().colors[left];
        else if (right > 0)
            color =  i3d.getWheel().colors[right];
        
        return new Color(color.getRed(), color.getGreen(), color.getBlue(), alpha);
    }

   
    
    public void switchDisplay()
    {
        phosphorDraw = (phosphorDraw+1)%2;
        phosphorDisplay = (phosphorDisplay+1)%2;

        if (phosphor[phosphorDraw] == null) return;
        Graphics2D g2 = phosphor[phosphorDraw].createGraphics();

        // "persist" old image
        g2.drawImage(phosphor[phosphorDisplay], 0, 0,null);
        
        // and "fade away with alpha
        Color cc = new Color(0,0,0,config.persistenceAlpha );
        g2.setColor(cc);
        g2.fillRect(0, 0, vectrexDisplayWidth, vectrexDisplayheight);
        image = phosphor[phosphorDisplay];
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
    public void rayMove(int x0,int y0, int x1, int y1, int color, int dwell, boolean curved, int alg_vector_speed, int alg_leftEye, int alg_rightEye)
    {
        if (!toggleDisplay)
        {
            addGLLineSegment(x0,y0, x1, y1);
            return;
        }
        if (phosphor[phosphorDraw]==null) return;
        Graphics2D g2 = phosphor[phosphorDraw].createGraphics();

        x0 =Scaler.scaleDoubleToInt(x0, scaleWidth);
        y0 =Scaler.scaleDoubleToInt(y0, scaleHeight);
        x1 =Scaler.scaleDoubleToInt(x1, scaleWidth);
        y1 =Scaler.scaleDoubleToInt(y1, scaleHeight);

        Color c = getColor(color, alg_leftEye, alg_rightEye);
//        if (vecx.imagerMode)
//        Color c = new Color(255,255,255,color );
        g2.setColor(c);
        g2.drawLine(((int) x0), ((int) y0), ((int) x1),((int) y1));

        g2.dispose();
    }

// paints all vectors to an image
    // the image will be painted to the component 
    // in paintComponent
    // expects coordinates that can be painted directly
    // meaning 0,0 is in the uper left corner
    // (scaling to panel size will be done though)
    ArrayList<Point> spline = new ArrayList();
    HashMap<String, String> doubleCheck= new HashMap<String, String>();
    StringBuilder sh = new StringBuilder();
    synchronized private void paint(VectrexDisplayVectors vList)
    {
        if (!toggleDisplay) return;
        if (image == null) return;
        doubleCheck.clear();

        Graphics2D g2 = image.createGraphics();
        
        if (config.persistenceAlpha != 255)
        {
                Color cc = new Color(0,0,0,config.persistenceAlpha );
                g2.setColor(cc);
                g2.fillRect(0, 0, vectrexDisplayWidth, vectrexDisplayheight);
        }
        else
        {
                Color cc = new Color(0,0,0,255);
                g2.setBackground(cc);
                g2.clearRect(0, 0, vectrexDisplayWidth, vectrexDisplayheight);

        }

        if (pausing)
        {
            Color c = new Color(255,0,0,255 );
            g2.setColor(Color.RED);
            g2.setFont(this.getFont());
            g2.drawString("PAUSED", (image.getWidth()/2)-30, image.getHeight()/3);
        }
        if (debuging)
        {
            Color c = new Color(255,0,0,255 );
            g2.setColor(Color.GREEN);
            g2.setFont(this.getFont());
            g2.drawString("Debug", (image.getWidth()/2)-20, image.getHeight()/3);
        }
        if(deviceList.get(DEVICE_LIGHTPEN).isActive())
        {
            Color c = new Color(255,0,0,255 );
            if (mousePressed)
                g2.setColor(Color.ORANGE);
            else
                g2.setColor(Color.YELLOW);
            g2.setFont(this.getFont());
            g2.drawString("Lightpen", (image.getWidth()/2)-20, image.getHeight()/3);
        }
        if(deviceList.get(DEVICE_IMAGER).isActive())
        {
            Color c = new Color(255,0,0,255 );
            g2.setColor(Color.YELLOW);
            g2.setFont(this.getFont());
            g2.drawString("Goggle", (image.getWidth()/2)-20, image.getHeight()/3);
        }
        
        RenderingHints rh;
        if (config.antialiazing)
        {
            HashMap<RenderingHints.Key,Object> m = new HashMap<RenderingHints.Key,Object>();
            m.put(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
            m.put(RenderingHints.KEY_ALPHA_INTERPOLATION, RenderingHints.VALUE_ALPHA_INTERPOLATION_SPEED);
            m.put(RenderingHints.KEY_DITHERING, RenderingHints.VALUE_DITHER_DISABLE);
            rh = new RenderingHints(m );                
        }
        else
        {
            HashMap<RenderingHints.Key,Object> m = new HashMap<RenderingHints.Key,Object>();
            m.put(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_OFF);
            m.put(RenderingHints.KEY_ALPHA_INTERPOLATION, RenderingHints.VALUE_ALPHA_INTERPOLATION_SPEED);
            m.put(RenderingHints.KEY_DITHERING, RenderingHints.VALUE_DITHER_DISABLE);
            rh = new RenderingHints(m );                
        }
        g2.setRenderingHints(rh);
        g2.setStroke(new BasicStroke(config.lineWidth,  CAP_ROUND, JOIN_ROUND));

        boolean inSpline = false;
        int splineColor=0;
        
        old_x1 = Integer.MAX_VALUE;
        old_y1 = Integer.MAX_VALUE;
        
        
        for (int v = 0; v < vList.count; v++) 
        {
            if (config.useSplines)
            {
                synchronized(spline)
                {
                    if (!inSpline)
                    {
                        if (v != vList.count-1)
                        {
                            if ((vList.vectrexVectors[v+1].midChange) 
                                && (vList.vectrexVectors[v].x1 == vList.vectrexVectors[v+1].x0)
                                && (vList.vectrexVectors[v].y1 == vList.vectrexVectors[v+1].y0)
                                        )
                            {
                                // start Spline
                                spline.clear();
                                spline.add(new Point(vList.vectrexVectors[v].x0,vList.vectrexVectors[v].y0 ));
                                splineColor =vList.vectrexVectors[v].color; 
                                inSpline = true;
                                continue;
                                
                            }
                        }
                    }
                    else
                    {
                        if ((vList.vectrexVectors[v].midChange)
                                && (vList.vectrexVectors[v-1].x1 == vList.vectrexVectors[v].x0)
                                && (vList.vectrexVectors[v-1].y1 == vList.vectrexVectors[v].y0)
                                        )
                        {
                            // add point Spline
                            spline.add(new Point(vList.vectrexVectors[v].x0,vList.vectrexVectors[v].y0 ));
                            if (v == vList.count-1) // is end of current vector list? Than we MUST draw even if spline is not finished
                            {
                                // start Spline
                                spline.add(new Point(vList.vectrexVectors[v].x1,vList.vectrexVectors[v].y1 ));
                                drawCatmullRom(spline, g2, splineColor, vList.vectrexVectors[v].speed, vList.vectrexVectors[v].imagerColorLeft, vList.vectrexVectors[v].imagerColorRight);
                                inSpline = false;
                                continue;
                            }

                        }
                        else
                        {
                           // 0 -> 1 von -1 und aktuell als line
                            spline.add(new Point(vList.vectrexVectors[v-1].x1,vList.vectrexVectors[v-1].y1 ));
                            
                            drawCatmullRom(spline, g2, splineColor, vList.vectrexVectors[v-1].speed, vList.vectrexVectors[v-1].imagerColorLeft, vList.vectrexVectors[v-1].imagerColorRight);
                            inSpline = false;
                            // check if next vector is again the beginning of a spline
                            if (v != vList.count-1)
                            {
                                if (vList.vectrexVectors[v+1].midChange)
                                {
                                    // start Spline
                                    spline.clear();
                                    spline.add(new Point(vList.vectrexVectors[v].x0,vList.vectrexVectors[v].y0 ));
                                    splineColor =vList.vectrexVectors[v].color; 
                                    inSpline = true;
                                    continue;

                                }
                            }
                        }
                    }
                }
            }

            if (inSpline) continue;

            drawOneLine(g2, vList.vectrexVectors[v]);
	} 
        g2.dispose();
    }
    private void drawOneLine(Graphics2D g2, vector_t v)
    {
        
        double x0 =Scaler.scaleDoubleToInt(v.x0, scaleWidth);
        double y0 =Scaler.scaleDoubleToInt(v.y0, scaleHeight);
        double x1 =Scaler.scaleDoubleToInt(v.x1, scaleWidth);
        double y1 =Scaler.scaleDoubleToInt(v.y1, scaleHeight);
        if (config.supressDoubleDraw)
        {
            if ((old_x1 == (int)x0) && ( old_y1 == (int)y0))
            {
                int SHORTEN = config.lineWidth;
                double dx = x1 - x0;
                double dy = y1 - y0;
                double length = Math.sqrt(dx * dx + dy * dy);
                if (length <= config.lineWidth) return;
                if (length > 0)
                {
                    dx /= length;
                    dy /= length;
                }
                dx *= length - SHORTEN;
                dy *= length - SHORTEN;

                // shortened by tw2
                x0 = x1 - dx;
                y0 = y1 - dy;
            }
        }
        old_x1 = (int)x1;
        old_y1 = (int)y1;
        sh.delete(0, sh.length());
        sh.append((int)x0);
        sh.append((int)x1);
        sh.append((int)y0);
        sh.append((int)y1);
        String key = sh.toString();

        if (doubleCheck.get(key) == null) 
        {
            doubleCheck.put(key, key);
            if (!config.vectorsAsArrows)
            {
                if (config.useGlow)
                {
                    int color = v.color;// <<2; // 7f is max color
                    double speedFactor; 
                    if (v.speed>128) // dot dwell
                    {
                        speedFactor = ((double)v.speed)/128.0; 
                    }
                    else
                    {
                        speedFactor = 1.0 - (((double)v.speed)/512.0);
                    }
                    color= (int) ((double)color *(speedFactor));

                    double brightness = getBrightness();
                    color= (int) ((double)color *(brightness));
                    color = color/3;
                    int halo = color*2/BASE_GLOW_OFFSET;
                    halo*=2;

                    for (int i=0; i< halo; i++)
                    {
                        int alpha = BASE_GLOW_OFFSET/(3*(halo-i));
                        if (alpha == 0) continue;
                        int width = (halo-i)*config.lineWidth;
                        g2.setStroke(new BasicStroke(width,  CAP_ROUND, JOIN_ROUND));
                        Color c = new Color(255,255,255,alpha );
                        c = new Color(210,210,255,alpha );
                        c = getColor(alpha, v.imagerColorLeft, v.imagerColorRight);
                        
                        g2.setColor(c);
                        g2.drawLine(((int) x0), ((int) y0), ((int) x1),((int) y1));
                    }
                    g2.setStroke(new BasicStroke(config.lineWidth,  CAP_ROUND, JOIN_ROUND));
                    if (color>BASE_GLOW_OFFSET)
                        color=BASE_GLOW_OFFSET;
                    Color c = new Color(255,255,255,color );
                    c = new Color(210,210,255,color);
                    c = getColor(color, v.imagerColorLeft, v.imagerColorRight);
                    g2.setColor(c);
                    g2.drawLine(((int) x0), ((int) y0), ((int) x1),((int) y1));
                    //&if ((config.lineWidth%2!=0) && (config.lineWidth!=1))
                    if ( (config.lineWidth!=1))
                    {
                        g2.setStroke(new BasicStroke(config.lineWidth/2));
                        int col = color/2;//*2;
                        if (col > 255) col = 255;
                        c = new Color(255,255,255,col );
                        c = new Color(210,210,255,col );
                        c = getColor(col, v.imagerColorLeft, v.imagerColorRight);
                        g2.setColor(c);
                        g2.drawLine(((int) x0), ((int) y0), ((int) x1),((int) y1));
                    }
                }
                else
                {
                    Color c = new Color(255,255,255,v.color );
                    c = new Color(210,210,255,v.color );
                    c = getColor(v.color, v.imagerColorLeft, v.imagerColorRight);
                    g2.setColor(c);
                    g2.drawLine(((int) x0), ((int) y0), ((int) x1),((int) y1));
                }
            }
            else
            {
                Color c = new Color(255,255,255,v.color );
                    c = new Color(210,210,255,v.color );
                c = getColor(v.color, v.imagerColorLeft, v.imagerColorRight);
                g2.setColor(c);
                drawArrow(g2, ((int) x0), ((int) y0), ((int) x1),((int) y1));
            }            
        }
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
    int BASE_GLOW_OFFSET = 64;
    int SPEED_STRENGTH = 4;
    
    public static int ARR_SIZE = 10;
    int old_x1 = Integer.MAX_VALUE;
    int old_y1 = Integer.MAX_VALUE;
    void drawArrow(Graphics g1, int x1, int y1, int x2, int y2) 
    {
        Graphics2D g = (Graphics2D) g1.create();

        double dx = x2 - x1, dy = y2 - y1;
        double angle = Math.atan2(dy, dx);
        int len = (int) Math.sqrt(dx*dx + dy*dy);
        AffineTransform at = AffineTransform.getTranslateInstance(x1, y1);
        at.concatenate(AffineTransform.getRotateInstance(angle));
        g.transform(at);

        // Draw horizontal arrow starting in (0, 0)
        g.drawLine(0, 0, len, 0);
        g.fillPolygon(new int[] {len, len-ARR_SIZE, len-ARR_SIZE, len},
                      new int[] {0, -ARR_SIZE/3, ARR_SIZE/3, 0}, 4);
    }    
    
    
    vector_t directDrawVector = null;
    public void directDraw(vector_t v)
    {
        directDrawVector = v;
        repaint();
    }
    
    
    private void resetGfx()
    {
        if (getWidth() == 0) return;
        if (getHeight() == 0) return;
        image = de.malban.util.UtilityImage.getNewImage(getWidth(), getHeight()-jPanel1.getHeight());
        phosphor[0] = de.malban.util.UtilityImage.getNewImage(getWidth(), getHeight()-jPanel1.getHeight());
        phosphor[1] = de.malban.util.UtilityImage.getNewImage(getWidth(), getHeight()-jPanel1.getHeight());

        if (image == null) return;
        if (phosphor[0] == null) return;
        if (phosphor[1] == null) return;
        
        
        
        vectrexDisplayWidth = image.getWidth();
        vectrexDisplayheight = image.getHeight();

        
        
        // build an image in the size of this component
        // with vectors on it
        // representing the vectrex vectors
        scaleWidth = ((double)vectrexDisplayWidth)/((double)config.ALG_MAX_X);
        scaleHeight = ((double)vectrexDisplayheight)/((double)config.ALG_MAX_Y);

        
        if ((overlayImageOrg != null)&& (config.overlayEnabled))
        {
            overlayImageScaled = ImageCache.getImageCache().getDerivatScale(overlayImageOrg, getWidth(), getHeight()-jPanel1.getHeight());
        }
    }
    @Override public void paintComponent(Graphics g)
    {
        super.paintComponent(g);
        if (!toggleDisplay) return;

        if (image != null)
        {
            g.drawImage(image, 0, jPanel1.getHeight(), null);
            if ((overlayImageScaled != null) && (config.overlayEnabled))
            {
                g.drawImage(overlayImageScaled, 0, jPanel1.getHeight(),null);
            }
            if (config.paintIntegrators)
            {
                int offsetY = jPanel1.getHeight();
                double x0=vecx.alg_curr_x;
                double y0=vecx.alg_curr_y;
                x0 =Scaler.scaleDoubleToInt(x0, scaleWidth);
                y0 =Scaler.scaleDoubleToInt(y0, scaleHeight)+offsetY;

                int RADIUS = 3;
                g.setColor(Color.red);
                g.drawOval((int)x0-RADIUS, (int)y0-RADIUS, RADIUS*2, RADIUS*2);
                
            }
            
            if (mouseMode)
            {
                if (!noCross) // out of bounds
                {
                    int offsetY = jPanel1.getHeight();
                    int width = image.getWidth();
                    int height = image.getHeight();
                    double scaleWidth = ((double)width)/((double)config.ALG_MAX_X);
                    double scaleHeight = ((double)height)/((double)config.ALG_MAX_Y);
                    
                    
                    double distance = Double.MAX_VALUE;
                    if (vinfi != null)
                    {
                        int x = mX;
                        int y = mY-offsetY;
                        
                        x =Scaler.unscaleDoubleToInt(x, scaleWidth);
                        y =Scaler.unscaleDoubleToInt(y, scaleHeight);
                        x -=config.ALG_MAX_X/2;
                        y -=config.ALG_MAX_Y/2;
                        y =-y;

                        vinfi.setMouseCoordinates( x,  y);
                    }
                    
                    
                    Color c = g.getColor();
                    {
                        int x = mX;
                        int y = mY;
                        g.setColor(crossColor);
                        g.drawLine(0, y, width, y);
                        g.drawLine(x, 0+offsetY, x, height+offsetY);
                    }

                    // search a vector that is in range!
                    VectrexDisplayVectors vList = vecx.getDisplayList();
                
  
                    for (int i = 0; i < vList.count; i++) 
                    {
                        vector_t v = vList.vectrexVectors[i];
                        
                        double x0=v.x0;
                        double y0=v.y0;
                        double x1=v.x1;
                        double y1=v.y1;
                        double d;

                        // vector coordinates in xy pos in relation to image!
                        x0 =Scaler.scaleDoubleToInt(x0, scaleWidth);
                        y0 =Scaler.scaleDoubleToInt(y0, scaleHeight);
                        x1 =Scaler.scaleDoubleToInt(x1, scaleWidth);
                        y1 =Scaler.scaleDoubleToInt(y1, scaleHeight);
                
                        y0 += offsetY; // + image offset in panel
                        y1 += offsetY;
                
                        // nice, but now that I think of it I need a line SEGMENT, not a line!
                        d = SingleVectorPanel.getDistancePointToVector((double)mX, (double)mY, x0,y0,x1,y1);
                        if (d<distance) 
                        {
                            distance = d;
                            found = v;
                        }
                        if (distance==0) break;
                    }
                    if (directDrawVector != null)
                    {
                        double x0=directDrawVector.x0;
                        double y0=directDrawVector.y0;
                        double x1=directDrawVector.x1;
                        double y1=directDrawVector.y1;
                        double d;

                        // vector coordinates in xy pos in relation to image!
                        x0 =Scaler.scaleDoubleToInt(x0, scaleWidth);
                        y0 =Scaler.scaleDoubleToInt(y0, scaleHeight);
                        x1 =Scaler.scaleDoubleToInt(x1, scaleWidth);
                        y1 =Scaler.scaleDoubleToInt(y1, scaleHeight);
                
                        y0 += offsetY; // + image offset in panel
                        y1 += offsetY;
                
                        // nice, but now that I think of it I need a line SEGMENT, not a line!
                        d = SingleVectorPanel.getDistancePointToVector((double)mX, (double)mY, x0,y0,x1,y1);
                        if (d<distance) 
                        {
                            distance = d;
                            found = directDrawVector;
                        }
                        
                    }
                    
                    
                    
                    // distance must be NEAR (in range)
                    if (found != null)
                    {
                        if (distance<=5) // arround 5 Pixel
                        {
                        }
                        else
                        {
                            found = null;
                        }
                    }        
                    if (found != null)
                    {
                        // select vector!
                        double x0=found.x0;
                        double y0=found.y0;
                        double x1=found.x1;
                        double y1=found.y1;

                        x0 =Scaler.scaleDoubleToInt(x0, scaleWidth);
                        y0 =Scaler.scaleDoubleToInt(y0, scaleHeight);
                        x1 =Scaler.scaleDoubleToInt(x1, scaleWidth);
                        y1 =Scaler.scaleDoubleToInt(y1, scaleHeight);
                
                        y0 += offsetY; // + image offset in panel
                        y1 += offsetY;
                        
                        
                        g.setColor(Color.BLUE);

                        // construct a perpendicular vector for a 
                        // paralle transition
                        double py = x0-x1;
                        double px = -(y0-y1);
                        double l = Math.sqrt((Math.pow(py,2) + Math.pow(px,2)));

                        double transition = 3;

                        double px0 = x0 + (transition / l) * px;
                        double py0 = y0 + (transition / l) * py;
                        double px1 = x1 + (transition / l) * px;
                        double py1 = y1 + (transition / l) * py;

                        double transition2 = -3;

                        double px02 = x0 + (transition2 / l) * px;
                        double py02 = y0 + (transition2 / l) * py;
                        double px12 = x1 + (transition2 / l) * px;
                        double py12 = y1 + (transition2 / l) * py;

                        g.drawLine(((int) px0), ((int) py0), ((int) px1),((int) py1));
                        g.drawLine(((int) px02), ((int) py02), ((int) px12),((int) py12));

                        g.drawLine(((int) px0), ((int) py0), ((int) px02),((int) py02));
                        g.drawLine(((int) px1), ((int) py1), ((int) px12),((int) py12));
                    }
                }
            }
        }
        
        if (directDrawVector != null)
        {
            Color c = new Color(255,255,0,255 );
            g.setColor(c);
            double x0=directDrawVector.x0;
            double y0=directDrawVector.y0;
            double x1=directDrawVector.x1;
            double y1=directDrawVector.y1;

            x0 =Scaler.scaleDoubleToInt(x0, scaleWidth);
            y0 =Scaler.scaleDoubleToInt(y0, scaleHeight);
            x1 =Scaler.scaleDoubleToInt(x1, scaleWidth);
            y1 =Scaler.scaleDoubleToInt(y1, scaleHeight);

            g.drawLine(((int) x0), ((int) y0)+jPanel1.getHeight(), ((int) x1),((int) y1)+jPanel1.getHeight());
            directDrawVector = null;
        }
        if (ledState)
        {
            if (ledDir)
            {
                for (int i=22; i>12;i-=2)
                {
                    int alpha = 250-((i-12)*20)-ledStep*2;
                    Color c = new Color(210,210,255,alpha);
                    g.setColor(c);
                    g.fillOval(this.getWidth()-30-i, this.getHeight()-30-i, (i-10)*2, (i-10)*2);
//                    if (i >= 16) i-=2;
                }
                Color c = new Color(255,255,255,255);
                g.setColor(c);
                g.fillOval(this.getWidth()-30-12, this.getHeight()-30-12, 4, 4);
                 c = new Color(255,255,200,255-ledStep);
                g.setColor(c);
                g.fillOval(this.getWidth()-30-11, this.getHeight()-30-11, 2, 2);
                ledStep++;
                if (ledStep >= 15)ledDir = false;
            }
            else if (!ledDir)
            {
                for (int i=22; i>12;i-=2)
                {
                    int alpha = 250-((i-12)*20)-ledStep*2;
                    Color c = new Color(210,210,255,alpha);
                    g.setColor(c);
                    g.fillOval(this.getWidth()-30-i, this.getHeight()-30-i, (i-10)*2, (i-10)*2);
//                    if (i >= 16) i-=2;
                }
                Color c = new Color(255,255,255,255-ledStep);
                g.setColor(c);
                g.fillOval(this.getWidth()-30-12, this.getHeight()-30-12, 4, 4);
                 c = new Color(255,255,200,255);
                g.setColor(c);
                g.fillOval(this.getWidth()-30-11, this.getHeight()-30-11, 2, 2);
                ledStep--;
                if (ledStep <= 0)ledDir = true;
            }
        }
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
    
    public static String SID = "vecxi";
    public String getID()
    {
        return SID;
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
        if (image == null) return;
        if (!deviceList.get(DEVICE_LIGHTPEN).isActive()) return;
        if (!mousePressed) {unsetLightPen();return;}

        // coordinates on image of vectrex
        // the image represents the fill ALG_MAX_X*ALG_MAX_Y
        int x = mX;
        int y = mY -jPanel1.getHeight();
        
        // try correct some rounding mistakes
        y-=4;
        x-=4;

        if (y<0) {unsetLightPen();return;} // mouse not pressed on vectrex panel

        
        
        // in vectrex coordinates,
        // though 0,0 is as of yet not "center", but upper left corner
        int ux =Scaler.unscaleDoubleToInt(x, scaleWidth);
        int uy =Scaler.unscaleDoubleToInt(y, scaleHeight);
        
        setLightPen(ux, uy);
    }
    
    public void updateAvailableWindows(boolean jumpInDissi, boolean moveDissiToFirst, boolean forceUpdate)
    {
        if (!dissiActive) return;
        if (dissi != null)
            if ((jumpInDissi) && (!pausing))
                dissi.goAddress(vecx.e6809.reg_pc, moveDissiToFirst, false, forceUpdate);
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
    }
    // re setting dissi updates all!
    
    public void initLabels()
    {
        if (labi != null)
            labi.initLabels();
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
                dissi.printMessage("Triggered: "+bp, DissiPanel.MESSAGE_INFO);
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
        vecx.cyclesRunning = n;
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
    public void setTrackingAddress(int start,int end)
    {
        vecx.setTrackingAddress( start, end);
    }
    public void startCartridge(final CartridgeProperties cartProp, int runType)
    {
        startTypeRun = runType;        
        // stop everything
        if (startTypeRun != START_TYPE_INJECT)
            jButtonStopActionPerformed(null);                                            
        
        
        Thread cartLoaderThread = new Thread()
        {
            public void run()
            {
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
            loadOverlay(vecx.cart.currentCardProp.getOverlay()); // ensure overlay in scaled form is available
        checkWindows();
        stop = true;
        
        while (running);
        dissi.processHeyDissis();
        resetGfx();
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
        String filename ="xml"+File.separator+"vectorlist"+File.separator;
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
            createDissi();
            if (dissi == null) return; 
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
        
        if (dumpi != null) dumpi.setDissi(dissi);
        if (regi != null) regi.setDissi(dissi);
        if (vinfi != null) vinfi.setDissi(dissi);
        if (vari != null) vari.setDissi(dissi);
        if (labi != null) labi.setDissi(dissi);
        if (ayi != null) ayi.setDissi(dissi);
        if (breaki != null) breaki.setDissi(dissi);
        if (carti != null) carti.setDissi(dissi);
        if (joyi != null) joyi.setDissi(dissi);

        
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
    public Microchip11AA010 getMicrochip()
    {
        if (vecx.microchipEnabled == false) return null;
        return vecx.cart.microchip;
    }
    public DS2430A getDS2430A()
    {
        if (vecx.ds2430Enabled == false) return null;
        return vecx.cart.ds2430;
    }
    public DS2431 getDS2431()
    {
        if (vecx.ds2431Enabled == false) return null;
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

    
    boolean isLWJGL = false;
    GLWindow w = null;
    float scaleWidthGL = ((float)1)/((float)config.ALG_MAX_X)*2;
    float scaleHeightGL = ((float)1)/((float)config.ALG_MAX_Y)*2;
    void initLWGL()
    {
        isLWJGL = LWJGLSupport.isLWJGLSupported();
        if (!isLWJGL) return;
        w = LWJGLSupport.getLWJGLSupport().addWindow(0,0, 300, 300, "Hello Vectrex!", this);
        if ( w == null )
        {
            log.addLog("GL Window not created!", INFO);
            isLWJGL = false;
        }
    }

    float[] data = new float[VECTOR_CNT];
    public int render(GLWindow w)
    {
        if (toggleDisplay) return 0;
        if (config.useRayGun)
        {
            int ret = lsCounter;
            
            
            w.DataBuffer.put(dataRay, 0, lsCounter);//put all the data in the buffer, position at the end of the data
            
            lsCounter = 0;
            return ret;
        }
        
        VectrexDisplayVectors list = vecx.getDisplayList();

        ////////////////Prepare the Data////////////////
        int dCount = 0;
        
//        float[] data = new float[list.count*4];
        for (int v = 0; v < list.count; v++) 
        {
            vector_t vector = list.vectrexVectors[v];
            data[dCount++] =Scaler.scaleFloatToFloat(vector.x0-config.ALG_MAX_X/2, scaleWidthGL);
            data[dCount++] =Scaler.scaleFloatToFloat(-(vector.y0-config.ALG_MAX_Y/2), scaleHeightGL);
            data[dCount++] =Scaler.scaleFloatToFloat(vector.x1-config.ALG_MAX_X/2, scaleWidthGL);
            data[dCount++] =Scaler.scaleFloatToFloat(-(vector.y1-config.ALG_MAX_Y/2), scaleHeightGL);
        }        
        //DataBuffer.put(data, 0,dCount );//put all the data in the buffer, position at the end of the data

        w.DataBuffer.put(data, 0, dCount);//put all the data in the buffer, position at the end of the data
        return dCount;

    }
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
    public void lwjglExit()
    {
        jButtonStopActionPerformed(null);
        ((CSAMainFrame)mParent).removePanel(this, true);
    }
    
    boolean ledState = false;
    public void setLED(int state)
    {
        ledState = (state == 1);
    }// 0 = invisible, 1 = on, 2 = off
 
    void checkOverlay()
    {
        if (config.overlayEnabled)
        {
            try
            {
                if (overlayImageOrg==null) 
                {
                    loadOverlay(vecx.cart.currentCardProp.getOverlay()); // ensure overlay in scaled form is available
                }
            }
            catch (Throwable e)
            {
                
            }
            try
            {
                if (overlayImageOrg==null) 
                {
                    loadOverlay(vecx.romName);
                }
            }
            catch (Throwable e)
            {
                
            }
        }
    }
}

