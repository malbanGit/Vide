/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx;

import de.malban.vide.VideConfig;
import de.malban.config.Configuration;
import de.malban.graphics.GFXVector;
import de.malban.graphics.GFXVectorList;
import de.malban.graphics.SingleVectorPanel;
import de.malban.gui.CSAMainFrame;
import de.malban.gui.ImageCache;
import de.malban.gui.Scaler;
import de.malban.gui.Stateable;
import de.malban.gui.Windowable;
import de.malban.gui.components.CSAView;
import de.malban.gui.dialogs.InternalFrameFileChoser;
import de.malban.gui.dialogs.ShowErrorDialog;
import de.malban.sound.VideAudio;
import de.malban.util.KeyboardListener;
import de.malban.vide.dissy.DissiPanel;
import de.malban.vide.dissy.MemoryInformation;
import de.malban.vide.vecx.cartridge.Cartridge;
import de.malban.vide.vecx.VecX.VectrexDisplayVectors;
import de.malban.vide.vecx.VecXState.vector_t;
import static de.malban.vide.vecx.VecXStatics.EMU_TIMER;
import static de.malban.vide.vecx.VecXStatics.VECTREX_MHZ;
import de.malban.vide.vecx.cartridge.CartridgeProperties;
import de.malban.vide.vecx.spline.CardinalSpline;
import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Point;
import java.awt.RenderingHints;
import java.awt.event.ActionEvent;
import java.awt.event.KeyEvent;
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
import javax.swing.AbstractAction;
import javax.swing.KeyStroke;
import javax.swing.SwingUtilities;
import de.malban.vide.vecx.spline.Pt;
import de.malban.vide.vecx.panels.AnalogJPanel;
import de.malban.vide.vecx.panels.BreakpointJPanel;
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

/**
 *
 * @author malban
 */
public class VecXPanel extends javax.swing.JPanel  implements Windowable, DisplayerInterface, VecXStatics, Stateable
{
    public boolean isLoadSettings() { return true; }
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
    
    
    boolean updateAllways = false;
    
    boolean keyEventsAreSet = false;
    public boolean stop = false;
    public boolean running = false;
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
    
    BufferedImage image;
    

    @Override
    public void closing()
    {
        deinit();
        if (vecx!=null)
            vecx.deinitAudio();
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
    }
    /**
     * Creates new form DissiPanel
     */
    public VecXPanel() {
        initComponents();
        vecx = new VecX();
        vecx.setDisplayer(this);
        setupKeyEvents();
        resetGfx();
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
        jLabel5 = new javax.swing.JLabel();
        jTextFieldstart = new javax.swing.JTextField();
        jButtonFileSelect1 = new javax.swing.JButton();
        jButtonStop = new javax.swing.JButton();
        jButtonPause = new javax.swing.JButton();
        jButtonStart = new javax.swing.JButton();
        jButton1 = new javax.swing.JButton();
        jButton2 = new javax.swing.JButton();
        jButtonLightpen = new javax.swing.JButton();
        jButtonGoggle = new javax.swing.JButton();

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

        jLabel5.setText("Bin File");

        jTextFieldstart.setText("FROGGER.BIN");
        jTextFieldstart.setFocusable(false);
        jTextFieldstart.setName("vecxy"); // NOI18N

        jButtonFileSelect1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/folder_go.png"))); // NOI18N
        jButtonFileSelect1.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonFileSelect1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonFileSelect1ActionPerformed(evt);
            }
        });

        jButtonStop.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/control_stop.png"))); // NOI18N
        jButtonStop.setToolTipText("Stops and unloads ROM!");
        jButtonStop.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonStop.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonStopActionPerformed(evt);
            }
        });

        jButtonPause.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/control_pause.png"))); // NOI18N
        jButtonPause.setToolTipText("Pauses current running emulation...");
        jButtonPause.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonPause.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonPauseActionPerformed(evt);
            }
        });

        jButtonStart.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/control_play.png"))); // NOI18N
        jButtonStart.setToolTipText("<html>Starts selected ROM, no effect if running!<BR>\nSHIFT click resets and starts new!\n</html>\n"); // NOI18N
        jButtonStart.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonStart.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonStartActionPerformed(evt);
            }
        });

        jButton1.setText("save");
        jButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton1ActionPerformed(evt);
            }
        });

        jButton2.setText("load");
        jButton2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton2ActionPerformed(evt);
            }
        });

        jButtonLightpen.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/pencil.png"))); // NOI18N
        jButtonLightpen.setToolTipText("Lightpen");
        jButtonLightpen.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonLightpen.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonLightpenActionPerformed(evt);
            }
        });

        jButtonGoggle.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/color_wheel.png"))); // NOI18N
        jButtonGoggle.setToolTipText("Goggle");
        jButtonGoggle.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonGoggle.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonGoggleActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGap(2, 2, 2)
                .addComponent(jLabel5)
                .addGap(17, 17, 17)
                .addComponent(jTextFieldstart, javax.swing.GroupLayout.PREFERRED_SIZE, 103, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonFileSelect1)
                .addGap(18, 18, 18)
                .addComponent(jButtonStart)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonPause)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonStop)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButton1)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(jButton2)
                .addGap(18, 18, 18)
                .addComponent(jButtonGoggle)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonLightpen)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGap(0, 0, 0)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jButton2)
                        .addComponent(jButton1))
                    .addComponent(jButtonFileSelect1)
                    .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jTextFieldstart, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLabel5))
                    .addComponent(jButtonPause)
                    .addComponent(jButtonStart)
                    .addComponent(jButtonStop)
                    .addComponent(jButtonLightpen)
                    .addComponent(jButtonGoggle))
                .addGap(4, 4, 4))
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
                .addGap(0, 0, Short.MAX_VALUE))
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
        
        if (dissi == null)
        {
            createDissi();
            if (dissi == null) return; 
        }
        setDissi(dissi);
        vecx.init(jTextFieldstart.getText(), cartProp);
        dissi.dis(vecx.cart);
        dissiInit = true;
        if (config.overlayEnabled)
            loadOverlay(jTextFieldstart.getText()); // ensure overlay in scaled form is available
        checkWindows();
        stop = true;
        dissi.processHeyDissis();
        resetGfx();
        start();
    }//GEN-LAST:event_jButtonStartActionPerformed
    boolean cartProp = true;
    public void startUp(String path)
    {
        startUp(path, true);
    }
    public void startUp(String path, boolean checkCartridge)
    {
        if (image == null)
            resetGfx();
        jButtonStopActionPerformed(null);
        jTextFieldstart.setText(path);
        cartProp = false;
        jButtonStartActionPerformed(null);
        cartProp = true;
        jTextFieldstart.setText("");
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

    public void setDissi(DissiPanel d)
    {
        dissi = d;
    }

    
    private void createDissi()
    {
        CSAMainFrame f = (CSAMainFrame) mParent;
        dissi = f.getDissi();
        dissi.setVecxy(this);
        checkWindows();
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
            return;
        }
        if (!isRunning())
        {
            vecx.init(jTextFieldstart.getText());
            if (config.overlayEnabled)
                loadOverlay(vecx.romName);
            stop = true;
            startDebug();
            if (dissi == null)
            {
                createDissi();
                if (dissi == null) return; 
            }
            dissi.dis(vecx.cart);
            setDissi(dissi);
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
                if (regi!= null) regi.setDissi(dissi);
                dissi.dis(vecx.cart);
                dissiInit = true;
            }
            setDissi(dissi);
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
        resetGfx();
        paint(vecx.getDisplayList());
        repaint();
    }//GEN-LAST:event_formComponentResized
    private void jButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton1ActionPerformed
        if (stop) return;
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
            vecx.saveStateToFile("");
            cont();
            return;
        }
        vecx.saveStateToFile("");

    }//GEN-LAST:event_jButton1ActionPerformed
    private void jButton2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton2ActionPerformed
        stop();
        dissiInit = false;
        if (!vecx.loadStateFromFile("")) return;
        
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
    }//GEN-LAST:event_jButton2ActionPerformed
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
                if (regi!= null) regi.setDissi(dissi);
                dissi.dis(vecx.cart);
                dissiInit = true;
            }
            setDissi(dissi);
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
        if ((!mouseMode) && (!vecx.lightpen)) return;
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
        if ((!mouseMode) && (!vecx.lightpen)) return;
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
        if ((!mouseMode) && (!vecx.lightpen)) return;
        if (evt.getButton() == MouseEvent.BUTTON1)
        {
            mousePressed = false;
            shiftPressed = KeyboardListener.isShiftDown();
        }
        if (vecx.lightpen) unsetLightPen();
        if (!mouseMode) return;
        crossColor = Color.ORANGE;
        repaint();
    }//GEN-LAST:event_formMouseReleased

    private void formMouseDragged(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_formMouseDragged
        if ((!mouseMode) && (!vecx.lightpen)) return;
        mX=evt.getX();
        mY=evt.getY();
        if (!mouseMode) return;
        crossColor = Color.GREEN;
        noCross = false;
        repaint();
    }//GEN-LAST:event_formMouseDragged

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
        dumpi.setVecxy(this);
        dumpi.updateValues(true);
    }
    public void showTracki()
    {
        if (tracki == null)
        {
            tracki = ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).getWRTracker();
        }
        if (tracki == null) return;
        tracki.setVecxy(this);
        tracki.updateValues(true);
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
        if (ani == null)
        {
            ani = ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).getAni();
        }
        if (ani == null) return;
        ani.setVecxy(this);
        ani.updateValues(true);
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
        
        vari.setDissi(dissi);
        vari.updateValues(true);
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
        
        labi.setDissi(dissi);
        labi.updateValues(true);
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
        
        ayi.setDissi(dissi);
        ayi.updateValues(true);
    }
    public void showBreakpoints()
    {
        if (dissi == null) return;
        if (breaki == null)
        {
            breaki = ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).getBreaki();
        }
        if (breaki == null) return;
        breaki.setVecxy(this);
        
        breaki.setDissi(dissi);
        breaki.updateValues(true);
    }
    
    
    private void jButtonLightpenActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonLightpenActionPerformed
        vecx.toggleLightPen();
    }//GEN-LAST:event_jButtonLightpenActionPerformed

    private void jButtonGoggleActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonGoggleActionPerformed
        vecx.toggleGoggle();
    }//GEN-LAST:event_jButtonGoggleActionPerformed


    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton jButton1;
    private javax.swing.JButton jButton2;
    private javax.swing.JButton jButtonFileSelect1;
    private javax.swing.JButton jButtonGoggle;
    private javax.swing.JButton jButtonLightpen;
    private javax.swing.JButton jButtonPause;
    private javax.swing.JButton jButtonStart;
    private javax.swing.JButton jButtonStop;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JTextField jTextFieldstart;
    // End of variables declaration//GEN-END:variables

    private void setupKeyEvents()
    {
        if (keyEventsAreSet) return;
        keyEventsAreSet = true;
        this.getInputMap(WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_A,0, false), "Button1_1_pressed");
        this.getActionMap().put("Button1_1_pressed", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (!running) return; vecx.e8910.snd_regs[14] &= ~0x01; }});
        this.getInputMap(WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_S,0, false), "Button1_2_pressed");
        this.getActionMap().put("Button1_2_pressed", new AbstractAction() { public void actionPerformed(ActionEvent e) { if (!running) return; vecx.e8910.snd_regs[14] &= ~0x02; }});
        this.getInputMap(WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_D,0, false), "Button1_3_pressed");
        this.getActionMap().put("Button1_3_pressed", new AbstractAction() { public void actionPerformed(ActionEvent e) { if (!running) return; vecx.e8910.snd_regs[14] &= ~0x04; }});
        this.getInputMap(WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_F,0, false), "Button1_4_pressed");
        this.getActionMap().put("Button1_4_pressed", new AbstractAction() { public void actionPerformed(ActionEvent e) { if (!running) return; vecx.e8910.snd_regs[14] &= ~0x08; }});

        this.getInputMap(WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_LEFT,0, false),  "Joy1_Left_pressed");
        this.getActionMap().put("Joy1_Left_pressed", new AbstractAction() { public void actionPerformed(ActionEvent e) { if (!running) return;  
        vecx.alg_jch0 = 0x00; }});
        this.getInputMap(WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_RIGHT,0, false), "Joy1_Right_pressed");
        this.getActionMap().put("Joy1_Right_pressed", new AbstractAction() { public void actionPerformed(ActionEvent e) { if (!running) return; 
        vecx.alg_jch0 = 0xff; }});
        this.getInputMap(WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_UP,0, false),    "Joy1_Up_pressed");
        this.getActionMap().put("Joy1_Up_pressed", new AbstractAction() { public void actionPerformed(ActionEvent e) { if (!running) return; 
        vecx.alg_jch1 = 0xff; }});
        this.getInputMap(WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_DOWN,0, false),  "Joy1_Down_pressed");
        this.getActionMap().put("Joy1_Down_pressed", new AbstractAction() { public void actionPerformed(ActionEvent e) { if (!running) return; 
        vecx.alg_jch1 = 0x00; }});

        this.getInputMap(WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_A,0, true), "Button1_1_released");
        this.getActionMap().put("Button1_1_released", new AbstractAction() { public void actionPerformed(ActionEvent e) { if (!running) return; vecx.e8910.snd_regs[14] |= 0x01; }});
        this.getInputMap(WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_S,0, true), "Button1_2_released");
        this.getActionMap().put("Button1_2_released", new AbstractAction() { public void actionPerformed(ActionEvent e) { if (!running) return; vecx.e8910.snd_regs[14] |= 0x02; }});
        this.getInputMap(WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_D,0, true), "Button1_3_released");
        this.getActionMap().put("Button1_3_released", new AbstractAction() { public void actionPerformed(ActionEvent e) { if (!running) return; vecx.e8910.snd_regs[14] |= 0x04; }});
        this.getInputMap(WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_F,0, true), "Button1_4_released");
        this.getActionMap().put("Button1_4_released", new AbstractAction() { public void actionPerformed(ActionEvent e) { if (!running) return; vecx.e8910.snd_regs[14] |= 0x08; }});

        this.getInputMap(WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_LEFT,0, true),  "Joy1_Left_released");
        this.getActionMap().put("Joy1_Left_released", new AbstractAction() { public void actionPerformed(ActionEvent e) { if (!running) return; 
        vecx.alg_jch0 = 0x80; }});
        this.getInputMap(WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_RIGHT,0, true), "Joy1_Right_released");
        this.getActionMap().put("Joy1_Right_released", new AbstractAction() { public void actionPerformed(ActionEvent e) { if (!running) return; 
        vecx.alg_jch0 = 0x80; }});
        this.getInputMap(WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_UP,0, true),    "Joy1_Up_released");
        this.getActionMap().put("Joy1_Up_released", new AbstractAction() { public void actionPerformed(ActionEvent e) { if (!running) return; 
        vecx.alg_jch1 = 0x80; }});
        this.getInputMap(WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_DOWN,0, true),  "Joy1_Down_released");
        this.getActionMap().put("Joy1_Down_released", new AbstractAction() { public void actionPerformed(ActionEvent e) { if (!running) return; 
        vecx.alg_jch1 = 0x80; }});
        
    }   
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
                        vecx.directDrawActive = false;
                        if (exitReason == EMU_EXIT_BREAKPOINT_BREAK)
                        {
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
                        long duration = System.currentTimeMillis() - startTime;
                        if (duration < EMU_TIMER)
                        {
                            try 
                            {
                                Thread.sleep(EMU_TIMER-duration);
                            } 
                            catch(InterruptedException v) 
                            {
                            }
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


    
    void drawCatmullRom(ArrayList<Point> spline, Graphics2D g2, int color, int speed)
    {
        synchronized (spline)
        {
            if (config.useQuads)
            {
                drawAsQuads(spline, g2,  color, speed);
                return;
            }

            Color c = new Color(210,210,255,color/*>>3*/ );
            g2.setColor(c);
            
            if (spline.size() == 2)
            {
                drawAsQuads(spline, g2,  color, speed);
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
            ArrayList<Point> nP = new ArrayList<>();
            for (int i=0;i<pts.size(); i++)
            {
                nP.add(new Point(pts.get(i).ix(), pts.get(i).iy()));
            }
            if (nP.size()>0)
                drawAsQuads(nP, g2,  color, speed);

            
            
            
/*org
            Pt old = null;
            boolean isFirst = true;
            for (Pt point: pts)
            {
                if (Double.isNaN(point.x)) 
                    continue;
                if (Double.isNaN(point.y)) 
                    continue;
                if (old != null)
                {
                    int SHORTEN = config.lineWidth;
                    int startx = (int)(old.x);
                    int starty = (int)(old.y);
                    if (!isFirst)
                    {
                        double dx = old.x - point.x;
                        double dy = old.y - point.y;
                        double length = Math.sqrt(dx * dx + dy * dy);
                        if (length > 0)
                        {
                            dx /= length;
                            dy /= length;
                        }
                        dx *= length - SHORTEN;
                        dy *= length - SHORTEN;

                        // shortened by tw2
                        startx = (int)(point.x + dx);
                        starty = (int)(point.y + dy);
                        
                    }
                    isFirst = false;
                    g2.drawLine(((int) startx), ((int) starty), ((int) point.x),((int) point.y));
                }
                old = point;
            }
*/            
        }
      }

    void drawAsQuads(ArrayList<Point> spline, Graphics2D g2, int color, int speed)
    {
        synchronized (spline)
        {
            int counter = 0;
            GeneralPath path = new GeneralPath(GeneralPath.WIND_NON_ZERO);
        //    Color c = new Color(100,255,100,color );
            Color c = new Color(210,210,255,color );
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
    public void rayMove(int x0,int y0, int x1, int y1, int color, int dwell, boolean curved)
    {
        if (phosphor[phosphorDraw]==null) return;
        Graphics2D g2 = phosphor[phosphorDraw].createGraphics();

        x0 =Scaler.scaleDoubleToInt(x0, scaleWidth);
        y0 =Scaler.scaleDoubleToInt(y0, scaleHeight);
        x1 =Scaler.scaleDoubleToInt(x1, scaleWidth);
        y1 =Scaler.scaleDoubleToInt(y1, scaleHeight);


        Color c = new Color(255,255,255,color );
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
    HashMap<String, String> doubleCheck= new HashMap<>();
    StringBuilder sh = new StringBuilder();
    synchronized private void paint(VectrexDisplayVectors vList)
    {
        if (image == null) return;
        doubleCheck.clear();

        Graphics2D g2 = image.createGraphics();
        
        Color cc = new Color(0,0,0,config.persistenceAlpha );
        g2.setColor(cc);
//        g2.clearRect(0, 0, vectrexDisplayWidth, vectrexDisplayheight);
        g2.fillRect(0, 0, vectrexDisplayWidth, vectrexDisplayheight);
        
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
        if(vecx.lightpen)
        {
            Color c = new Color(255,0,0,255 );
            if (mousePressed)
                g2.setColor(Color.ORANGE);
            else
                g2.setColor(Color.YELLOW);
            g2.setFont(this.getFont());
            g2.drawString("Lightpen", (image.getWidth()/2)-20, image.getHeight()/3);
        }
        if(vecx.imager)
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
                                drawCatmullRom(spline, g2, splineColor, vList.vectrexVectors[v].speed);
                                inSpline = false;
                                continue;
                            }

                        }
                        else
                        {
                           // 0 -> 1 von -1 und aktuell als line
                            spline.add(new Point(vList.vectrexVectors[v-1].x1,vList.vectrexVectors[v-1].y1 ));
                            drawCatmullRom(spline, g2, splineColor, vList.vectrexVectors[v-1].speed);
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
                    int color = v.color <<2; // 7f is max color
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
                    int halo = color/BASE_GLOW_OFFSET;
                    halo*=2;

                    for (int i=0; i< halo; i++)
                    {
                        int alpha = BASE_GLOW_OFFSET/(3*(halo-i));
                        if (alpha == 0) continue;
                        int width = (halo-i)*config.lineWidth;
                        g2.setStroke(new BasicStroke(width,  CAP_ROUND, JOIN_ROUND));
                        Color c = new Color(255,255,255,alpha );
                    c = new Color(210,210,255,alpha );
                        g2.setColor(c);
                        g2.drawLine(((int) x0), ((int) y0), ((int) x1),((int) y1));
                    }
                    g2.setStroke(new BasicStroke(config.lineWidth,  CAP_ROUND, JOIN_ROUND));
                    if (color>BASE_GLOW_OFFSET)
                        color=BASE_GLOW_OFFSET;
                    Color c = new Color(255,255,255,color );
                    c = new Color(210,210,255,color);
                    g2.setColor(c);
                    g2.drawLine(((int) x0), ((int) y0), ((int) x1),((int) y1));
                    //&if ((config.lineWidth%2!=0) && (config.lineWidth!=1))
                    if ( (config.lineWidth!=1))
                    {
                        g2.setStroke(new BasicStroke(config.lineWidth/2));
                        int col = color*2;
                        if (col > 255) col = 255;
                        c = new Color(255,255,255,col );
                        c = new Color(210,210,255,col );
                        g2.setColor(c);
                        g2.drawLine(((int) x0), ((int) y0), ((int) x1),((int) y1));
                    }
                }
                else
                {
                    Color c = new Color(255,255,255,v.color );
                    c = new Color(210,210,255,v.color );
                    g2.setColor(c);
                    g2.drawLine(((int) x0), ((int) y0), ((int) x1),((int) y1));
                }
            }
            else
            {
                Color c = new Color(255,255,255,v.color );
                    c = new Color(210,210,255,v.color );
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
        scaleWidth = ((double)vectrexDisplayWidth)/((double)ALG_MAX_X);
        scaleHeight = ((double)vectrexDisplayheight)/((double)ALG_MAX_Y);

        
        if ((overlayImageOrg != null)&& (config.overlayEnabled))
        {
            overlayImageScaled = ImageCache.getImageCache().getDerivatScale(overlayImageOrg, getWidth(), getHeight()-jPanel1.getHeight());
        }
    }
    @Override public void paintComponent(Graphics g)
    {
        super.paintComponent(g);
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
                    double scaleWidth = ((double)width)/((double)ALG_MAX_X);
                    double scaleHeight = ((double)height)/((double)ALG_MAX_Y);
                    
                    
                    double distance = Double.MAX_VALUE;
                    if (vinfi != null)
                    {
                        int x = mX;
                        int y = mY-offsetY;
                        
                        x =Scaler.unscaleDoubleToInt(x, scaleWidth);
                        y =Scaler.unscaleDoubleToInt(y, scaleHeight);
                        x -=ALG_MAX_X/2;
                        y -=ALG_MAX_Y/2;
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
            
    }
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
        vecx.setLightPen(LIGHTPEN_OUT_OF_BOUNDS, LIGHTPEN_OUT_OF_BOUNDS);
    }
    public void setLightPen()
    {
        if (image == null) return;
        if (!vecx.lightpen) return;
        if (!mousePressed) {unsetLightPen();return;}

        // coordinates on image of vectrex
        // the image represents the fill ALG_MAX_X*ALG_MAX_Y
        int x = mX;
        int y = mY -jPanel1.getHeight();
        
        if (y<0) {unsetLightPen();return;} // mouse not pressed on vectrex panel
        
        // in vectrex coordinates,
        // though 0,0 is as of yet not "center", but upper left corner
        int ux =Scaler.unscaleDoubleToInt(x, scaleWidth);
        int uy =Scaler.unscaleDoubleToInt(y, scaleHeight);
        
        vecx.setLightPen(ux, uy);
    }
    
    private void updateAvailableWindows(boolean jumpInDissi, boolean moveDissiToFirst, boolean forceUpdate)
    {
        if (dissi != null)
            if (jumpInDissi)
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

        if (dissi != null)
        {
            if (dumpi!= null) dumpi.setDissi(dissi);
            if (regi!= null) regi.setDissi(dissi);
            if (vinfi!= null) vinfi.setDissi(dissi);
            if (vari != null) vari.setDissi(dissi);
            if (labi != null) labi.setDissi(dissi);
            if (ayi != null) ayi.setDissi(dissi);
            if (breaki != null) breaki.setDissi(dissi);
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
    }
    public void resetMe()
    {
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
    
    // single systemwide entry point fpr Breakpoints!
    // not checked if "same" breakpoint already exists!
    public void breakpointMemorySet(Breakpoint bp)
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
        dissi.getMemory();
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
    // true on add
    public boolean breakpointBankToggle(Breakpoint bp)
    {
        boolean b = vecx.toggleBankBreakpoint(bp);
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
        return (int)vecx.alg_curr_x-VecXStatics.ALG_MAX_X/2;
    }
    public int getYIntegratorValue()
    {
        if (vecx==null) return 0;
        return (int)vecx.alg_curr_y-VecXStatics.ALG_MAX_Y/2;
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
    public void startCartridge(CartridgeProperties cartProp)
    {
        // stop everything
        jButtonStopActionPerformed(null);                                            
        
        
        Thread cartLoaderThread = new Thread()
        {
            public void run()
            {
                if (!vecx.init(cartProp))
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
        }
        setDissi(dissi);
        dissi.dis(vecx.cart); // to dissi
        dissiInit = true;
        if (config.overlayEnabled)
            loadOverlay(vecx.cart.currentCardProp.getOverlay()); // ensure overlay in scaled form is available
        checkWindows();
        stop = true;
        dissi.processHeyDissis();
        resetGfx();
        start();
        
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
        double exportScaleWidth = ((double)255)/((double)ALG_MAX_X);
        double exportScaleHeight = ((double)255)/((double)ALG_MAX_Y);

        VectrexDisplayVectors currentVectors = vecx.getDisplayList();
        GFXVectorList list = new GFXVectorList();
        for (int ve = 0; ve < currentVectors.count; ve++) 
        {
            vector_t v = currentVectors.vectrexVectors[ve];
            GFXVector vector = new GFXVector();
            vector.pattern = 255;
            vector.intensity = v.color;
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
}
