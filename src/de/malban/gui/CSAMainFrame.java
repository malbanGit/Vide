/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.gui;

import de.malban.vide.veccy.VeccyPanel;
import de.malban.Global;
import de.malban.config.ConfigChangedListener;
import de.malban.config.Configuration;
import de.malban.config.ConfigurationPanel;
import de.malban.config.theme.Theme;
import de.malban.vide.dissy.DissiPanel;
import de.malban.event.EventSupport;
import de.malban.gui.components.CSAInternalFrame;
import de.malban.gui.components.CSAMacMenuInternalFrame;
import de.malban.gui.components.CSAView;
import de.malban.gui.components.ModalInternalFrame;
import de.malban.gui.dialogs.FileUtil;
import de.malban.gui.panels.LogPanel;
import static de.malban.gui.panels.LogPanel.INFO;
import static de.malban.gui.panels.LogPanel.WARN;
import de.malban.gui.panels.TipOfDayGUI;
import de.malban.gui.panels.WindowablePanel;
import de.malban.jdbc.DBConnectionEdit;
import de.malban.jdbc.StatementWindow;
import de.malban.vide.assy.AssyPanel;
import de.malban.vide.dissy.CompareDissiPanel;
import de.malban.vide.vecx.panels.AnalogJPanel;
import de.malban.vide.vecx.panels.BreakpointJPanel;
import de.malban.vide.ConfigJPanel;
import de.malban.vide.VideConfig;
import de.malban.vide.codi.CodeLibraryPanel;
import de.malban.vide.vecx.VecX;
import de.malban.vide.vecx.panels.LabelJPanel;
import de.malban.vide.vecx.panels.MemoryDumpPanel;
import de.malban.vide.vecx.panels.PSGJPanel;
import de.malban.vide.vecx.panels.RegisterJPanel;
import de.malban.vide.vecx.panels.VIAJPanel;
import de.malban.vide.vecx.panels.VarJPanel;
import de.malban.vide.vecx.VecXPanel;
import de.malban.vide.vecx.cartridge.CartridgePropertiesPanel;
import de.malban.vide.vecx.cartridge.DualVec;
import de.malban.vide.vecx.devices.AbstractDevice;
import de.malban.vide.vecx.panels.CartridgePanel;
import de.malban.vide.vecx.panels.JoyportPanel;
import de.malban.vide.vecx.panels.OverlSwitcherJPanel;
import de.malban.vide.vecx.panels.ProfileJPanel;
import de.malban.vide.vecx.panels.StarterJPanel;
import de.malban.vide.vecx.panels.VectorInfoJPanel;
import de.malban.vide.vecx.panels.WRTrackerJPanel;
import de.malban.vide.vecx.panels.WheelEdit;
import de.malban.vide.vedi.VediPanel;
import de.malban.vide.vedi.VediPanel32;
import de.malban.vide.vedi.raster.RasterPanel;
import de.malban.vide.vedi.raster.VectorJPanel;
import de.malban.vide.vedi.sound.ExplosionEditor;
import de.malban.vide.vedi.sound.InstrumentEditor;
import de.malban.vide.vedi.sound.ModJPanel;
import de.malban.vide.vedi.sound.SampleJPanel;
import de.malban.vide.vedi.sound.VecSpeechPanel;
import de.malban.vide.vedi.sound.YMJPanel;
import java.awt.*;
import static java.awt.event.ActionEvent.SHIFT_MASK;
import java.awt.event.KeyEvent;
import java.awt.event.MouseAdapter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;
import java.util.*;
import javax.help.DefaultHelpBroker;
import javax.help.HelpBroker;
import javax.help.HelpSet;
import javax.help.JHelpContentViewer;
import javax.help.JHelpTOCNavigator;
import javax.help.WindowPresentation;
import javax.swing.*;
import javax.swing.event.InternalFrameEvent;
import javax.swing.plaf.basic.BasicInternalFrameUI;

/**
 *
 * @author malban
 */
public class CSAMainFrame extends javax.swing.JFrame
            implements
                        CSAView,
                        java.awt.event.AWTEventListener,
                        ConfigChangedListener
{
    boolean fullDesktopDefault = false; // desktop window or move to front on menu item click
    static boolean isMac = Global.getOSName().toUpperCase().indexOf("MAC")!=-1;
    transient LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
    class JM extends JMenu
    {
        @Override public boolean isTopLevelMenu()
        {
            isRolloverEnabled();
            return true;
        }
        @Override public boolean isRolloverEnabled()
        {
            return false;
        }
    }
    private static int MENU_HIDE_DELAY = 20;
    private static int POP_DISPLAY_START_Y = 10;
/*    
    static HashMap <String, UIResource> windowedDefaults;
    static HashMap <String, UIResource> fullscreenDefaults;

    static Color fFontColor;
    static Color fBackColor;
*/    
    static
    {
/*        
        fFontColor = new Color(100,200,100);
        fBackColor = new Color(00,00,00);
        windowedDefaults = new HashMap <String, UIResource>();
        fullscreenDefaults = new HashMap <String, UIResource>();

        UIDefaults uiDefaults = UIManager.getDefaults();
        Enumeration eenum = uiDefaults.keys();
        while (eenum.hasMoreElements())
        {
            try
            {
                Object key = eenum.nextElement();
                Object val = uiDefaults.get(key);
                String keyString = key.toString();
                if (val == null) continue;
                String valueString = val.toString();
                if (valueString.toUpperCase().indexOf("COLOR") != -1)
                {
                    if (val instanceof UIResource)
                        windowedDefaults.put(keyString, (UIResource)val);
                }

                if (valueString.toUpperCase().indexOf("R=0,G=0,B=0") != -1)
                    fullscreenDefaults.put(keyString, new javax.swing.plaf.ColorUIResource(fFontColor));
                if (keyString.toUpperCase().indexOf("BACKGROUND") != -1)
                    fullscreenDefaults.put(keyString, new javax.swing.plaf.ColorUIResource(fBackColor));
            }
            catch (Throwable e)
            {
                e.printStackTrace();
                Configuration.getConfiguration().getDebugEntity().addLog(e);
            }
        }
*/        

//        fullscreenDefaults.put("Panel.background", new javax.swing.plaf.ColorUIResource(0,0,0));
        UIManager.put("TabbedPane.tabsOpaque", Boolean.FALSE);
        UIManager.put("TabbedPane.contentOpaque", Boolean.FALSE);


        UIDefaults uiDefaults = UIManager.getDefaults();
        uiDefaults.put("TabbedPane.contentOpaque", Boolean.FALSE);
        uiDefaults.put("TabbedPane.tabsOpaque", Boolean.FALSE);
//        uiDefaults.put("TabbedPane.highlight", new javax.swing.plaf.ColorUIResource(new Color(0,255,0,100)));

        Global.updateComponentTree();
    }

    Vector<JPanel> mPanels = new Vector<JPanel>();
    Vector<JInternalFrame> mFrames = new Vector<JInternalFrame>();
    JPanel mCurrentPanel=null;
    int sizeX=1024;
    int sizeY=768;
    HashMap<Object, Boolean> dum = new HashMap<Object, Boolean>();
    HashMap<Object, MouseAdapter> mAdapter = new HashMap<Object, MouseAdapter>();
    HashMap<Object, javax.swing.event.InternalFrameAdapter> fl = new HashMap<Object, javax.swing.event.InternalFrameAdapter>();

    private static Dimension internalFrameDifference=null;
    
    //the original resolution before our program is run.
    private DisplayMode dispModeOld = null;

    //a reference to the GraphicsDevice for changing resolution and making
    //this window fullscreen.
    //get a reference to the device.
    private GraphicsDevice device = GraphicsEnvironment.getLocalGraphicsEnvironment().getDefaultScreenDevice();

    //the resolution in which we want to change the monitor to.
    private DisplayMode dispMode = new DisplayMode(1024, 768, 32, 60);

    private boolean fullscreen=false;
    private int overMenu=0;
    int enterCounter=0;
    private JPopupMenu pop=new JPopupMenu();
    private CSAMacMenuInternalFrame macFrame = null;
    private JMenuBar tmenuBar = new JMenuBar();
    private boolean mDebugDisplayed = false;
    private boolean mLogDisplayed = false;
    private int inEvent=0;

    private JDesktopPane mDesktop = new JDesktopPane()
    {
        protected void processEvent(AWTEvent e)
        {
            try
            {
                // BASICInternalFrameUI
                // throws a null pointer exception if 
                // desktop panel is activeted and at the same time
                // an invisible icon is on the desktop
                super.processEvent(e);
            }
            catch (Throwable x)
            {
                //System.out.println("Stupid resize error");
            }
        }
    };
    public JDesktopPane getDesktop(){return mDesktop;}

    /**
     * Creates new form CSAMainFrame
     */
    public CSAMainFrame() {
        //initComponents();
        initLibraryMapping();
        Global.mMainWindow = this;
        
         
        
        ToolTipManager.sharedInstance().setDismissDelay(15000);
        Theme t = Configuration.getConfiguration().getCurrentTheme();
//        getFrame().setIconImage(t.getImage(("RedIconSmall.png")));
        
        

ArrayList<Image> images = new ArrayList<>();
    images.add(t.getImage("VectrexConsole96.png"));
    images.add(t.getImage("VectrexConsole32.png"));
    images.add(t.getImage("VectrexConsole16.png"));

    
// Define a small and large app icon
this.setIconImages(images);        
        
        
        
        
        Configuration.getConfiguration().setMainFrame(getFrame());
        initComponents();
        jMenuItemCloseWin.setVisible(fullDesktopDefault);
        jMenuItem16.setVisible(false);
        jMenuItem15.setVisible(false);
//jMenuItem5.setVisible(false);
jCheckBoxMenuItem1.setVisible(false);
        jMenuItemDissy.setVisible(false);
        jMenuItemAssi.setVisible(false);
        mainPanel.removeAll();
        mainPanel.setLayout(new java.awt.BorderLayout());
        mainPanel.add(mDesktop, java.awt.BorderLayout.CENTER);
        resetMainPanel();

        Configuration.getConfiguration().init();
        Configuration.getConfiguration().addConfigListerner(this);
        windowMenu.removeAll();
        windowMenu.add(jMenuItemCloseWin);
        windowMenu.add(jMenuItemDebug);

        VideConfig config = VideConfig.getConfig();
        setUpGlobalKeys();
        
        getFrame().setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);
        loadMe();
        
        initLibrary();
        String startFile = null;
        if (config.startFile != null)
        {
            if (config.startFile.trim().length() != 0)
            {
                File file = new File(Global.mainPathPrefix+config.startFile);
                if (file.exists())
                {
                    startFile = Global.mainPathPrefix+config.startFile;
                }
            }
        }
        boolean startInFullScreenMode;
        if (!device.isFullScreenSupported())
        {
            startInFullScreenMode = false;
        }
        else
        {
            startInFullScreenMode = config.startInFullScreenMode;
        }
        
        if ((startFile!= null) && (config.cartridgeToStart == null))
            getVecxy().startBin(startFile);
        
        if (config.cartridgeToStart != null)
        {
            getVecxy().startCartridge(config.cartridgeToStart, VecX.START_TYPE_RUN);
        }

        
        SwingUtilities.invokeLater(new Runnable() {
            public void run()
            {
                if ((startInFullScreenMode) && (checkVecxy() != null))
                {
                    getVecxy().toggleFullscreen();
                    Configuration.getConfiguration().fireSizeChanged(false);
                    Configuration.getConfiguration().fireConfigChanged();
                }
                else
                {
                    Configuration.getConfiguration().fireSizeChanged(false);
                    Configuration.getConfiguration().fireConfigChanged();
                    motd();
                    
                }
                if ((config.startInFullPanelMode) && (checkVecxy() != null))
                {
                    getVecxy().toggleMainPanel();
                }
                
            }
        });
    }
    void windowManagerStart()
    {
        
    }
    public final CSAMainFrame getFrame()
    {
        return this;
    }

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        mainPanel = new javax.swing.JPanel();
        menuBar = new javax.swing.JMenuBar();
        fileMenu = new javax.swing.JMenu();
        fileMenu = new JM();
        jMenu2 = new javax.swing.JMenu();
        jMenuItem16 = new javax.swing.JMenuItem();
        jMenuItem15 = new javax.swing.JMenuItem();
        jMenuItem5 = new javax.swing.JMenuItem();
        jMenuItem1 = new javax.swing.JMenuItem();
        jSeparator2 = new javax.swing.JPopupMenu.Separator();
        exitMenuItem = new javax.swing.JMenuItem();
        jCheckBoxMenuItem1 = new javax.swing.JCheckBoxMenuItem();
        toolsMenu = new javax.swing.JMenu();
        jMenuItemStarter = new javax.swing.JMenuItem();
        jMenuItemVecxi = new javax.swing.JMenuItem();
        jMenuItemVedi = new javax.swing.JMenuItem();
        jMenuItemCodi = new javax.swing.JMenuItem();
        jMenuItemVeccy = new javax.swing.JMenuItem();
        jMenuItemDissy = new javax.swing.JMenuItem();
        jMenuItemAssi = new javax.swing.JMenuItem();
        jSeparator1 = new javax.swing.JPopupMenu.Separator();
        jMenu8 = new javax.swing.JMenu();
        jMenuItem38 = new javax.swing.JMenuItem();
        jMenuItem39 = new javax.swing.JMenuItem();
        jMenuItem40 = new javax.swing.JMenuItem();
        jMenuItem41 = new javax.swing.JMenuItem();
        jMenuItem43 = new javax.swing.JMenuItem();
        jMenuItem6 = new javax.swing.JMenuItem();
        jMenuItem45 = new javax.swing.JMenuItem();
        jMenuItem42 = new javax.swing.JMenuItem();
        jMenuItem44 = new javax.swing.JMenuItem();
        jMenuItemCartridgeEdit = new javax.swing.JMenuItem();
        jMenuItem4 = new javax.swing.JMenuItem();
        jMenuItem3 = new javax.swing.JMenuItem();
        jMenuItem2 = new javax.swing.JMenuItem();
        jMenuItemVec32 = new javax.swing.JMenuItem();
        jSeparator3 = new javax.swing.JPopupMenu.Separator();
        jMenuItemConfig = new javax.swing.JMenuItem();
        jMenuLibrary = new javax.swing.JMenu();
        windowMenu = new javax.swing.JMenu();
        windowMenu = new JM();
        jMenuItemCloseWin = new javax.swing.JMenuItem();
        jMenuItem12 = new javax.swing.JMenuItem();
        jMenuItemDebug = new javax.swing.JMenuItem();
        helpMenu = new javax.swing.JMenu();
        helpMenu = new JM();
        aboutMenuItem = new javax.swing.JMenuItem();
        jMenuItemHelp = new javax.swing.JMenuItem();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);
        setTitle("VIDE");
        setMinimumSize(new java.awt.Dimension(200, 200));
        setPreferredSize(new java.awt.Dimension(1024, 768));
        addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                formMousePressed(evt);
            }
        });
        addWindowListener(new java.awt.event.WindowAdapter() {
            public void windowClosing(java.awt.event.WindowEvent evt) {
                formWindowClosing(evt);
            }
            public void windowIconified(java.awt.event.WindowEvent evt) {
                formWindowIconified(evt);
            }
        });

        mainPanel.setLayout(new java.awt.BorderLayout());
        getContentPane().add(mainPanel, java.awt.BorderLayout.CENTER);

        fileMenu.setText("System");

        jMenu2.setText("Extra");

        jMenuItem16.setText("DB Settings");
        jMenuItem16.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem16ActionPerformed(evt);
            }
        });
        jMenu2.add(jMenuItem16);

        jMenuItem15.setText("DB Browser");
        jMenuItem15.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem15ActionPerformed(evt);
            }
        });
        jMenu2.add(jMenuItem15);

        jMenuItem5.setText("Generate XML-Class");
        jMenuItem5.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem5ActionPerformed(evt);
            }
        });
        jMenu2.add(jMenuItem5);

        jMenuItem1.setText("Application Configuration");
        jMenuItem1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem1ActionPerformed(evt);
            }
        });
        jMenu2.add(jMenuItem1);
        jMenu2.add(jSeparator2);

        fileMenu.add(jMenu2);

        exitMenuItem.setText("Exit");
        exitMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                exitMenuItemActionPerformed(evt);
            }
        });
        fileMenu.add(exitMenuItem);

        jCheckBoxMenuItem1.setText("Fullscreen");
        jCheckBoxMenuItem1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxMenuItem1ActionPerformed(evt);
            }
        });
        fileMenu.add(jCheckBoxMenuItem1);

        menuBar.add(fileMenu);

        toolsMenu.setText("Tools");

        jMenuItemStarter.setText("Starter");
        jMenuItemStarter.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemStarterActionPerformed(evt);
            }
        });
        toolsMenu.add(jMenuItemStarter);

        jMenuItemVecxi.setText("Vecxi");
        jMenuItemVecxi.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemVecxiActionPerformed(evt);
            }
        });
        toolsMenu.add(jMenuItemVecxi);

        jMenuItemVedi.setText("Vedi");
        jMenuItemVedi.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemVediActionPerformed(evt);
            }
        });
        toolsMenu.add(jMenuItemVedi);

        jMenuItemCodi.setText("Codi");
        jMenuItemCodi.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemCodiActionPerformed(evt);
            }
        });
        toolsMenu.add(jMenuItemCodi);

        jMenuItemVeccy.setText("Vecci");
        jMenuItemVeccy.setToolTipText("");
        jMenuItemVeccy.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemVeccyActionPerformed(evt);
            }
        });
        toolsMenu.add(jMenuItemVeccy);

        jMenuItemDissy.setText("Dissi");
        jMenuItemDissy.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemDissyActionPerformed(evt);
            }
        });
        toolsMenu.add(jMenuItemDissy);

        jMenuItemAssi.setText("Assi");
        jMenuItemAssi.setEnabled(false);
        jMenuItemAssi.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemAssiActionPerformed(evt);
            }
        });
        toolsMenu.add(jMenuItemAssi);
        toolsMenu.add(jSeparator1);

        jMenu8.setText("Utilities");

        jMenuItem38.setText("Raster images");
        jMenuItem38.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem38ActionPerformed(evt);
            }
        });
        jMenu8.add(jMenuItem38);

        jMenuItem39.setText("Vector images");
        jMenuItem39.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem39ActionPerformed(evt);
            }
        });
        jMenu8.add(jMenuItem39);

        jMenuItem40.setText("YM-files");
        jMenuItem40.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem40ActionPerformed(evt);
            }
        });
        jMenu8.add(jMenuItem40);

        jMenuItem41.setText("Mod-files");
        jMenuItem41.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem41ActionPerformed(evt);
            }
        });
        jMenu8.add(jMenuItem41);

        jMenuItem43.setText("Vectrex instruments/music");
        jMenuItem43.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem43ActionPerformed(evt);
            }
        });
        jMenu8.add(jMenuItem43);

        jMenuItem6.setText("Explosion design");
        jMenuItem6.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem6ActionPerformed(evt);
            }
        });
        jMenu8.add(jMenuItem6);

        jMenuItem45.setText("Sample generation");
        jMenuItem45.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem45ActionPerformed(evt);
            }
        });
        jMenu8.add(jMenuItem45);

        jMenuItem42.setText("VecVoice/VecVox");
        jMenuItem42.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem42ActionPerformed(evt);
            }
        });
        jMenu8.add(jMenuItem42);

        jMenuItem44.setText("Imager wheel editor");
        jMenuItem44.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem44ActionPerformed(evt);
            }
        });
        jMenu8.add(jMenuItem44);

        jMenuItemCartridgeEdit.setText("Cartridge information");
        jMenuItemCartridgeEdit.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemCartridgeEditActionPerformed(evt);
            }
        });
        jMenu8.add(jMenuItemCartridgeEdit);

        jMenuItem4.setText("File utility");
        jMenuItem4.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem4ActionPerformed(evt);
            }
        });
        jMenu8.add(jMenuItem4);

        jMenuItem3.setText("Dissi compare");
        jMenuItem3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem3ActionPerformed(evt);
            }
        });
        jMenu8.add(jMenuItem3);

        jMenuItem2.setText("Overlay switcher");
        jMenuItem2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem2ActionPerformed(evt);
            }
        });
        jMenu8.add(jMenuItem2);

        toolsMenu.add(jMenu8);

        jMenuItemVec32.setText("Vec32 Terminal");
        jMenuItemVec32.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemVec32ActionPerformed(evt);
            }
        });
        toolsMenu.add(jMenuItemVec32);
        toolsMenu.add(jSeparator3);

        jMenuItemConfig.setText("Configuration");
        jMenuItemConfig.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemConfigActionPerformed(evt);
            }
        });
        toolsMenu.add(jMenuItemConfig);

        menuBar.add(toolsMenu);

        jMenuLibrary.setText("Library");
        menuBar.add(jMenuLibrary);

        windowMenu.setText("Window");

        jMenuItemCloseWin.setText("Close current Window");
        jMenuItemCloseWin.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemCloseWinActionPerformed(evt);
            }
        });
        windowMenu.add(jMenuItemCloseWin);

        jMenuItem12.setText("Dummy Window");
        windowMenu.add(jMenuItem12);

        jMenuItemDebug.setText("Debug Window");
        jMenuItemDebug.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemDebugActionPerformed(evt);
            }
        });
        windowMenu.add(jMenuItemDebug);

        menuBar.add(windowMenu);

        helpMenu.setText("Help");

        aboutMenuItem.setText("About");
        aboutMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                aboutMenuItemActionPerformed(evt);
            }
        });
        helpMenu.add(aboutMenuItem);

        jMenuItemHelp.setText("Help");
        jMenuItemHelp.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemHelpActionPerformed(evt);
            }
        });
        helpMenu.add(jMenuItemHelp);

        menuBar.add(helpMenu);

        setJMenuBar(menuBar);

        getAccessibleContext().setAccessibleName("TT - Tile Tool");

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void exitMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_exitMenuItemActionPerformed
        AbstractDevice.exitSync = true;
        DualVec.exitSync = true;
        saveStateAll();
        dispose();
        System.exit(0);
    }//GEN-LAST:event_exitMenuItemActionPerformed

    public void doExit()
    {
        exitMenuItemActionPerformed(null);
    }
    
    private void jMenuItemCloseWinActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemCloseWinActionPerformed
        if (mCurrentPanel instanceof Windowable)
        {
             removePanel((Windowable)mCurrentPanel);
        }
    }//GEN-LAST:event_jMenuItemCloseWinActionPerformed

    private void aboutMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_aboutMenuItemActionPerformed
        Configuration C = Configuration.getConfiguration();
        if (C.getMainFrame() == null) {
            return;
        }
        AboutPanel ac = new AboutPanel();
        ModalInternalFrame modal = new ModalInternalFrame("About", C.getMainFrame().getRootPane(), C.getMainFrame(), ac);
        modal.setVisible(true);
    }//GEN-LAST:event_aboutMenuItemActionPerformed

    private void jMenuItemVeccyActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemVeccyActionPerformed
        Windowable p;
        if ((evt != null ) && ((evt.getModifiers() & SHIFT_MASK) == SHIFT_MASK))
        {
            p = createVeccy();
        }
        else
        {
            p = getVeccy();
        }
        CSAInternalFrame frame = getInternalFrame(p);
        try
        {
            if (frame.isIcon()) frame.setIcon(false);
        }
        catch (Throwable ex) { }
    }//GEN-LAST:event_jMenuItemVeccyActionPerformed

    private void jMenuItem16ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem16ActionPerformed

        // TODO make CSA Conform!
        DBConnectionEdit.showDBConnectionEditDialog();
        //        DBConnectionEdit edit = new DBConnectionEdit(Global.mMainWindow, true);
        //        edit.setVisible(true);
    }//GEN-LAST:event_jMenuItem16ActionPerformed

    private void jMenuItem15ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem15ActionPerformed
        // TODO make CSA Conform!
        StatementWindow p = new StatementWindow();
        addAsWindow(p, 800, 600, "SQL Window");
    }//GEN-LAST:event_jMenuItem15ActionPerformed

    private void jMenuItemDissyActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemDissyActionPerformed
        Windowable p = getDissi();
        CSAInternalFrame frame = getInternalFrame(p);
        try
        {
            if (frame.isIcon()) frame.setIcon(false);
        }
        catch (Throwable ex) { }
    }//GEN-LAST:event_jMenuItemDissyActionPerformed

    private void jMenuItemAssiActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemAssiActionPerformed
        AssyPanel p = new AssyPanel();
        addAsWindow(p, 800, 600, "Assi Window");
    }//GEN-LAST:event_jMenuItemAssiActionPerformed

    private void jMenuItemVecxiActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemVecxiActionPerformed
        
        boolean forced = ((evt != null ) && ((evt.getModifiers() & SHIFT_MASK) == SHIFT_MASK));
        if (forced)
        {
            VecXPanel p = createVecxy();
        }
        else
        {
            Windowable p = getVecxy();

            CSAInternalFrame frame = getInternalFrame(p);
            try
            {
                if (frame.isIcon()) frame.setIcon(false);
            }
            catch (Throwable ex) { }
        }
    }//GEN-LAST:event_jMenuItemVecxiActionPerformed

    private void formWindowClosing(java.awt.event.WindowEvent evt) {//GEN-FIRST:event_formWindowClosing
        AbstractDevice.exitSync = true;
        DualVec.exitSync = true;
        saveStateAll();
    }//GEN-LAST:event_formWindowClosing

    private void jMenuItemVediActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemVediActionPerformed
        Windowable p;
        if ((evt != null ) && ((evt.getModifiers() & SHIFT_MASK) == SHIFT_MASK))
        {
            p = createVedi();
        }
        else
        {
            p = createVedi();
//            p = getVedi();
        }
        
        CSAInternalFrame frame = getInternalFrame(p);
        try
        {
            if (frame.isIcon()) frame.setIcon(false);
        }
        catch (Throwable ex) { }
    }//GEN-LAST:event_jMenuItemVediActionPerformed

    private void jMenuItemConfigActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemConfigActionPerformed
        ConfigJPanel configi = new ConfigJPanel();
        addAsWindow(configi, 655, 875, ConfigJPanel.SID);
    }//GEN-LAST:event_jMenuItemConfigActionPerformed

    private void jMenuItem3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem3ActionPerformed
        CompareDissiPanel cd = new CompareDissiPanel();
        addAsWindow(cd, 331, 514, CompareDissiPanel.SID);
    }//GEN-LAST:event_jMenuItem3ActionPerformed

    private void jMenuItem4ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem4ActionPerformed

        Configuration C = Configuration.getConfiguration();
        FileUtil ac = new FileUtil();
        
        JDialog dialog = new JDialog();
        
        ModalInternalFrame modal = new ModalInternalFrame("FileUtil", C.getMainFrame().getRootPane(), C.getMainFrame(), ac, ac.getExitButton());
        ac.setDialog(modal);
        modal.setVisible(true);
    }//GEN-LAST:event_jMenuItem4ActionPerformed

    private void jMenuItem5ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem5ActionPerformed
        de.malban.util.XMLClassBuilder builder= new de.malban.util.XMLClassBuilder();
        builder.setVisible(true);
    }//GEN-LAST:event_jMenuItem5ActionPerformed

    private void jMenuItemCodiActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemCodiActionPerformed
        Windowable p;
        if ((evt != null ) && ((evt.getModifiers() & SHIFT_MASK) == SHIFT_MASK))
        {
            p = createCodi();
        }
        else
        {
            p = getCodi();
        }

        CSAInternalFrame frame = getInternalFrame(p);
        try
        {
            if (frame.isIcon()) frame.setIcon(false);
        }
        catch (Throwable ex) { }
    }//GEN-LAST:event_jMenuItemCodiActionPerformed

    private void jMenuItemHelpActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemHelpActionPerformed
        String helpHS = "main.hs";
        HelpSet hs;
        ClassLoader cl = CSAView.class.getClassLoader();
        try {
            java.net.URL hsURL = HelpSet.findHelpSet(cl, helpHS);
            hs = new HelpSet(null, hsURL);
        }
        catch (Exception ee)
        {
            // Say what the exception really is
            log.addLog("CSAMainFrame: Help "+ee.getMessage());
            return;
        }
        // Create a HelpBroker object:
        JHelpContentViewer hsv = new JHelpContentViewer(hs);
        HelpBroker hb = hs.createHelpBroker();

        
        if (hb instanceof DefaultHelpBroker)
        {
            WindowPresentation wp = ((DefaultHelpBroker)hb).getWindowPresentation();
            
            wp.createHelpWindow();
            java.awt.Window w  = wp.getHelpWindow();

            // prevents a nullpointer exception if run later
            SwingUtilities.invokeLater(new Runnable()
            {
                public void run()
                {
                    SwingUtilities.updateComponentTreeUI(w);  
                    
                }
            });
            
            if (w instanceof JFrame)
            {
                JFrame helpFrame = (JFrame)w;
                // remove printer buttons!
                printComponents(helpFrame,0);

                WindowablePanel wap = new WindowablePanel();
                JRootPane rpane = helpFrame.getRootPane();
                Container cpane = rpane.getContentPane();

                if (cpane instanceof JComponent)
                {
                    wap.setContent((JComponent)cpane, "Help");
                    addAsWindow(wap, 950, 650, "Help");
                    
//                    addPanel(wap);
//                    setMainPanel(wap);
//                    windowMe(wap, 950, 650, "Help");
                }

            }
        }    }//GEN-LAST:event_jMenuItemHelpActionPerformed

    private void jMenuItemStarterActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemStarterActionPerformed
        Windowable p = getStarter();
        CSAInternalFrame frame = getInternalFrame(p);
        try
        {
            if (frame.isIcon()) frame.setIcon(false);
        }
        catch (Throwable ex) { }
    }//GEN-LAST:event_jMenuItemStarterActionPerformed

    private void jMenuItemCartridgeEditActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemCartridgeEditActionPerformed
        
        CartridgePropertiesPanel cd = new CartridgePropertiesPanel();
        addAsWindow(cd, 331, 514, CartridgePropertiesPanel.SID);
    }//GEN-LAST:event_jMenuItemCartridgeEditActionPerformed

    private void jMenuItemDebugActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemDebugActionPerformed
        if (Configuration.getConfiguration().isDebugOff()) return;
        if (!(Configuration.getConfiguration().getDebugEntity() instanceof de.malban.gui.panels.LogPanel)) return;
        LogPanel c = (LogPanel) Configuration.getConfiguration().getDebugEntity();
        
        
        CSAInternalFrame frame = addAsWindow(c, 331, 514, "Debug Window");
            frame.addInternalFrameListener(new javax.swing.event.InternalFrameAdapter() {
                @Override
                public void internalFrameClosed(javax.swing.event.InternalFrameEvent evt) {
                    mDebugDisplayed = false;
                    doZOrder();
                }


                public void internalFrameOpened(InternalFrameEvent ife) {
                    doZOrder();
                }

                public void internalFrameClosing(InternalFrameEvent ife) {
                    doZOrder();
                }

                public void internalFrameIconified(InternalFrameEvent ife) {
                    doZOrder();
                }

                public void internalFrameDeiconified(InternalFrameEvent ife) {
                    doZOrder();
                }

                public void internalFrameActivated(InternalFrameEvent ife) {
                    doZOrder();
                }

                public void internalFrameDeactivated(InternalFrameEvent ife) {
                    doZOrder();
                }                
                
            });
        mDebugDisplayed = true;
        /*
        if (Configuration.getConfiguration().isDebugWindowFrameable())
        {
            if (mDebugDisplayed)
            {
                return;
            }
            CSAInternalFrame frame = new CSAInternalFrame();
            frame.addInternalFrameListener(new javax.swing.event.InternalFrameAdapter() {
                @Override
                public void internalFrameClosed(javax.swing.event.InternalFrameEvent evt) {
                    mDebugDisplayed = false;
                }
            });
            frame.addPanel(c);
            addInternalFrame(frame);
            frame.setTitle("Debug Window");
            frame.setVisible(true);
            mDebugDisplayed = true;
            return;
        }
        else if (mDebugDisplayed)
        {
            setMainPanel(c);
            mCurrentPanel = c.getPanel();
            return;
        }
        addPanel(c);
        setMainPanel(c);
        */
    }//GEN-LAST:event_jMenuItemDebugActionPerformed

    private void jMenuItem1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem1ActionPerformed
        ConfigurationPanel c = new ConfigurationPanel();
        addAsWindow(c, 1018, 680, "Application onfiguration");
    }//GEN-LAST:event_jMenuItem1ActionPerformed

    private void jMenuItem38ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem38ActionPerformed
        RasterPanel.showModPanelNoModal();
    }//GEN-LAST:event_jMenuItem38ActionPerformed

    private void jMenuItem39ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem39ActionPerformed
        VectorJPanel.showModPanelNoModal(null);
    }//GEN-LAST:event_jMenuItem39ActionPerformed

    private void jMenuItem40ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem40ActionPerformed
        YMJPanel.showYMPanelNoModal(null,log, true);
    }//GEN-LAST:event_jMenuItem40ActionPerformed

    private void jMenuItem41ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem41ActionPerformed
        ModJPanel.showModPanelNoModal(null, log, true);
    }//GEN-LAST:event_jMenuItem41ActionPerformed

    private void jMenuItem43ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem43ActionPerformed
        InstrumentEditor.showInstrumentPanelNoModal(log);
    }//GEN-LAST:event_jMenuItem43ActionPerformed

    private void jMenuItem45ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem45ActionPerformed
        SampleJPanel.showSamplePanelNoModal();
    }//GEN-LAST:event_jMenuItem45ActionPerformed

    private void jMenuItem42ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem42ActionPerformed
        VecSpeechPanel.showVecSpeechPanelNoModal(log, null);
    }//GEN-LAST:event_jMenuItem42ActionPerformed

    private void jMenuItem44ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem44ActionPerformed
        WheelEdit.showWheelEdit();
    }//GEN-LAST:event_jMenuItem44ActionPerformed

    private void jMenuItemVec32ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemVec32ActionPerformed
        Windowable p = getVec32();
        CSAInternalFrame frame = getInternalFrame(p);
        try
        {
            if (frame.isIcon()) frame.setIcon(false);
        }
        catch (Throwable ex) { }
    }//GEN-LAST:event_jMenuItemVec32ActionPerformed

    private void jCheckBoxMenuItem1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxMenuItem1ActionPerformed

        if (inEvent>0) return;
        fullscreen = !jCheckBoxMenuItem1.isSelected();
        // not yet in fullscreen - lets switch
        if (!fullscreen)
        {
            toFullscreen();
        }
        else
        {
            toWindowed();
        }
    }//GEN-LAST:event_jCheckBoxMenuItem1ActionPerformed

    private void jMenuItem2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem2ActionPerformed
        OverlSwitcherJPanel p = new OverlSwitcherJPanel();        
        addAsWindow(p, 400, 320, p.SID);
        
    }//GEN-LAST:event_jMenuItem2ActionPerformed

    private void jMenuItem6ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem6ActionPerformed
        ExplosionEditor.showExplosionPanelNoModal(log);
    }//GEN-LAST:event_jMenuItem6ActionPerformed

    private void formWindowIconified(java.awt.event.WindowEvent evt) {//GEN-FIRST:event_formWindowIconified
        // TODO add your handling code here:
 int i;
  i= 0;
  i++;
    }//GEN-LAST:event_formWindowIconified

    private void formMousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_formMousePressed
 int i;
  i= 0;
  i++;
        // TODO add your handling code here:
    }//GEN-LAST:event_formMousePressed

    boolean gameMode = false;
    de.malban.event.MasterEventListener keyListener = null;    
    
    // as of now! -> one way ticket!
    // only in fullscreen
    // to be invoked AFTER toFullscreen()
    // or BEFOR toWindowed()
    private void setMenu(boolean b)
    {
        if ((fullscreen) && (b))
        {
            java.awt.Toolkit.getDefaultToolkit().addAWTEventListener(this, java.awt.AWTEvent.MOUSE_MOTION_EVENT_MASK | java.awt.AWTEvent.MOUSE_EVENT_MASK);
            if (!isMac)
            {
                createPopup();

            }
            else
            {
                createMacPopup();

            }
        }
        else if ((fullscreen) && (!b))
        {
            java.awt.Toolkit.getDefaultToolkit().removeAWTEventListener(this);
            if (!isMac)
            {
                addEnter(pop, false);

                int i=0;
                while (pop.getComponentCount()>0)
                {
                    java.awt.Component m = pop.getComponent(i);
                    pop.remove(m);
                    if (m instanceof JMenu)
                    {
                        menuBar.add((JMenu)m);
                    ((JMenu)m).setMenuLocation(0, m.getPreferredSize().height);
                    }
                }

            }
            else
            {
                addEnter(macFrame, false);
                removeInternalFrame(macFrame);
                macFrame = null;
                int i=0;
                while (tmenuBar.getComponentCount()>0)
                {
                    java.awt.Component m = tmenuBar.getComponent(i);
                    tmenuBar.remove(m);
                    if (m instanceof JMenu)
                    {
                        menuBar.add((JMenu)m);
                    ((JMenu)m).setMenuLocation(0, m.getPreferredSize().height);
                    }
                }

            }
        }
        // no other combination is supported!
    }
    
    void printComponents(Container c, int depth)
    {
        depth++;
        for (int i=0; i<c.getComponentCount();i++)
        {
            Component com = c.getComponent(i);
            Container parent = com.getParent();
            if (com instanceof Container)
            {
                printComponents((Container) com, depth);
                if (parent instanceof javax.swing.JToolBar)
                {
                    if (i>2)
                    {
                        parent.remove(com);
                        i--;
                    }
                }
            }
            else
            {
                System.out.println(""+depth+". "+com.getName()+" "+com);
            }
        }
    }
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JMenuItem aboutMenuItem;
    private javax.swing.JMenuItem exitMenuItem;
    private javax.swing.JMenu fileMenu;
    private javax.swing.JMenu helpMenu;
    private javax.swing.JCheckBoxMenuItem jCheckBoxMenuItem1;
    private javax.swing.JMenu jMenu2;
    private javax.swing.JMenu jMenu8;
    private javax.swing.JMenuItem jMenuItem1;
    private javax.swing.JMenuItem jMenuItem12;
    private javax.swing.JMenuItem jMenuItem15;
    private javax.swing.JMenuItem jMenuItem16;
    private javax.swing.JMenuItem jMenuItem2;
    private javax.swing.JMenuItem jMenuItem3;
    private javax.swing.JMenuItem jMenuItem38;
    private javax.swing.JMenuItem jMenuItem39;
    private javax.swing.JMenuItem jMenuItem4;
    private javax.swing.JMenuItem jMenuItem40;
    private javax.swing.JMenuItem jMenuItem41;
    private javax.swing.JMenuItem jMenuItem42;
    private javax.swing.JMenuItem jMenuItem43;
    private javax.swing.JMenuItem jMenuItem44;
    private javax.swing.JMenuItem jMenuItem45;
    private javax.swing.JMenuItem jMenuItem5;
    private javax.swing.JMenuItem jMenuItem6;
    private javax.swing.JMenuItem jMenuItemAssi;
    private javax.swing.JMenuItem jMenuItemCartridgeEdit;
    private javax.swing.JMenuItem jMenuItemCloseWin;
    private javax.swing.JMenuItem jMenuItemCodi;
    private javax.swing.JMenuItem jMenuItemConfig;
    private javax.swing.JMenuItem jMenuItemDebug;
    private javax.swing.JMenuItem jMenuItemDissy;
    private javax.swing.JMenuItem jMenuItemHelp;
    private javax.swing.JMenuItem jMenuItemStarter;
    private javax.swing.JMenuItem jMenuItemVec32;
    private javax.swing.JMenuItem jMenuItemVeccy;
    private javax.swing.JMenuItem jMenuItemVecxi;
    private javax.swing.JMenuItem jMenuItemVedi;
    private javax.swing.JMenu jMenuLibrary;
    private javax.swing.JPopupMenu.Separator jSeparator1;
    private javax.swing.JPopupMenu.Separator jSeparator2;
    private javax.swing.JPopupMenu.Separator jSeparator3;
    private javax.swing.JPanel mainPanel;
    private javax.swing.JMenuBar menuBar;
    private javax.swing.JMenu toolsMenu;
    private javax.swing.JMenu windowMenu;
    // End of variables declaration//GEN-END:variables


    @Override
    public int getUsableFrameHeight()
    {
        int height;
        height = mainPanel.getHeight();
        return height;
    }
    @Override
    public int getUsableFrameWidth()
    {
        int width;
        width = mainPanel.getWidth();
        return width;
    }

    public void addInternalFrame(final CSAInternalFrame frame)
    {
        frame.setParent(this);
        Theme t = Configuration.getConfiguration().getCurrentTheme();
        frame.setFrameIcon( new ImageIcon(t.getImage("VectrexConsole16.png")));

        mFrames.add(frame);
        getMainPanel().add(frame);
        getMainPanel().setComponentZOrder(frame, 0);
        
        final javax.swing.event.InternalFrameAdapter l = new javax.swing.event.InternalFrameAdapter()
        {
            javax.swing.event.InternalFrameAdapter ll=this;
            @Override public void internalFrameClosed(javax.swing.event.InternalFrameEvent e)
            {
                removeInternalFrame(frame);
                frame.removeInternalFrameListener(fl.get(frame));
                    doZOrder();
            }
                public void internalFrameOpened(InternalFrameEvent ife) {
                    doZOrder();
                }

                public void internalFrameClosing(InternalFrameEvent ife) {
                    doZOrder();
                }

                public void internalFrameIconified(InternalFrameEvent ife) {
                    doZOrder();
                    frame.iconified();
                    if (frame.getDesktopIcon()!=null)
                        frame.getDesktopIcon().setVisible(true);
                    
                    
                    
                }

                public void internalFrameDeiconified(InternalFrameEvent ife) {
                    doZOrder();
                    frame.deIconified();
                }

                public void internalFrameActivated(InternalFrameEvent ife) {
                    doZOrder();
                }

                public void internalFrameDeactivated(InternalFrameEvent ife) {
                    doZOrder();
                }                
        };
        frame.addInternalFrameListener(l);
        fl.put(frame, l);
    }

    public void aboutToCloseInternalFrame(CSAInternalFrame iFrame)
    {
        JPanel p = iFrame.getPanel();
        if (p instanceof Stateable)
        {
            saveState((Stateable)p, iFrame);
        }
        
    }
    @Override
    public void removeInternalFrame(CSAInternalFrame frame)
    {
        mFrames.removeElement(frame);
        getMainPanel().remove(frame);

        // also called from removePanel, but this is later
        // when removed via removePanel
        if (frame.getPanel() instanceof Windowable)
        {
            if (((Windowable)frame.getPanel()) != null)
                ((Windowable)frame.getPanel()).closing();
        
            JMenuItem item = ((Windowable)frame.getPanel()).getMenuItem();
            if (item!=null)
                windowMenu.remove(item);
        }
        frame.removeInternalFrameListener(fl.get(frame));
    }

    private void createPopup()
    {
        pop.setLayout(new BoxLayout(pop, BoxLayout.LINE_AXIS));
        dum = new HashMap<Object, Boolean>();
        int i=0;
        int w=0;
        while (menuBar.getMenuCount()>0)
        {
            final JMenu m = menuBar.getMenu(i);
            w+=m.getWidth();
            w++; // GAP of 1
            m.setMenuLocation(0, m.getPreferredSize().height);
            menuBar.remove(m);
            pop.add(m);
        }
        w-=3; // first or last no gap, whatever
        JLabel filler = new JLabel("");

        // TODO take resolution from Configuration
        filler.setPreferredSize(new java.awt.Dimension((dispMode.getWidth())-(w+1),1));
        pop.add(filler);
        addEnter(pop, true);
        java.awt.Toolkit.getDefaultToolkit().addAWTEventListener(this, java.awt.AWTEvent.MOUSE_MOTION_EVENT_MASK | java.awt.AWTEvent.MOUSE_EVENT_MASK);
    }

    private void createMacPopup()
    {
        macFrame = new CSAMacMenuInternalFrame();
        //hide everything
        macFrame.setVisible(false);

        //remove the frame from being displayable.
        macFrame.dispose();

        //remove borders around the frame
        macFrame.setUndecorated(true);

        //show the frame


        // if not 2 buffers switching back to windowed mode
        // results (at least with me) in Exceptions
        //macFrame.createBufferStrategy(2); // 2 buffers


        macFrame.setSize(menuBar.getSize());
        int i=0;
        while (menuBar.getMenuCount()>0)
        {
            final JMenu m = menuBar.getMenu(i);

            menuBar.remove(m);
            tmenuBar.add(m);
        }
        macFrame.getContentPane().add(tmenuBar);
        //macFrame.pack();

        //macFrame.setVisible(false);
        macFrame.setLocation(0, 0);

        macFrame.setParent(this);
        addInternalFrame(macFrame);

        addEnter(macFrame, true);
        java.awt.Toolkit.getDefaultToolkit().addAWTEventListener(this, java.awt.AWTEvent.MOUSE_MOTION_EVENT_MASK | java.awt.AWTEvent.MOUSE_EVENT_MASK);
    }
    private void createMenuBar()
    {
        java.awt.Toolkit.getDefaultToolkit().removeAWTEventListener(this);
        if (!isMac)
        {
            addEnter(pop, false);

            int i=0;
            while (pop.getComponentCount()>0)
            {
                java.awt.Component m = pop.getComponent(i);
                pop.remove(m);
                if (m instanceof JMenu)
                {
                    menuBar.add((JMenu)m);
                ((JMenu)m).setMenuLocation(0, m.getPreferredSize().height);
                }
            }

        }
        else
        {
            addEnter(macFrame, false);
            removeInternalFrame(macFrame);
            macFrame = null;
            int i=0;
            while (tmenuBar.getComponentCount()>0)
            {
                java.awt.Component m = tmenuBar.getComponent(i);
                tmenuBar.remove(m);
                if (m instanceof JMenu)
                {
                    menuBar.add((JMenu)m);
                ((JMenu)m).setMenuLocation(0, m.getPreferredSize().height);
                }
            }

        }


    }

    void addEnter(java.awt.Component c, boolean set)
    {
        if (c instanceof java.awt.Container)
        for (int j=0;j<((java.awt.Container)c).getComponentCount();j++)
        {
            final java.awt.Component mc = ((java.awt.Container)c).getComponent(j);
            if(set)
            {
                dum.put(mc, false);
                MouseAdapter adapter= new java.awt.event.MouseAdapter() {
                    @Override public void mouseEntered(java.awt.event.MouseEvent evt) {
                        enterCounter=MENU_HIDE_DELAY;
                        dum.put(mc, true);}
                    @Override public void mouseExited(java.awt.event.MouseEvent evt) {
                        dum.put(mc, false);}
                };
                mAdapter.put(mc, adapter);

                mc.addMouseListener(adapter);
            }
            else
            {
                mc.removeMouseListener(mAdapter.get(mc));
                dum.remove(mc);
                mAdapter.remove(mc);
            }

            addEnter((java.awt.Container)mc, set);
        }
        if (c instanceof JMenu)
        {
            for (int j=0;j<((JMenu)c).getMenuComponentCount();j++)
            {
                final java.awt.Component mc = ((JMenu)c).getMenuComponent(j);
                if(set)
                {
                    dum.put(mc, false);
                    MouseAdapter adapter= new java.awt.event.MouseAdapter() {
                        @Override public void mouseEntered(java.awt.event.MouseEvent evt) {
                            enterCounter=MENU_HIDE_DELAY;
                            dum.put(mc, true);}
                        @Override public void mouseExited(java.awt.event.MouseEvent evt) {
                            dum.put(mc, false);}
                    };
                    mAdapter.put(mc, adapter);
                    mc.addMouseListener(adapter);
                }
                else
                {
                    mc.removeMouseListener(mAdapter.get(mc));
                    dum.remove(mc);
                    mAdapter.remove(mc);
                }
                addEnter((java.awt.Container)mc, set);
            }
        }
    }

    private void resetOverMenu()
    {
        if (!fullscreen) return;
        Set entries = dum.entrySet();
        Iterator it = entries.iterator();
        while (it.hasNext())
        {
            java.util.Map.Entry entry = (java.util.Map.Entry) it.next();
            dum.put(entry.getKey(), false);
        }
    }

    boolean overMenu()
    {
        Set entries = dum.entrySet();
        Iterator it = entries.iterator();
        while (it.hasNext())
        {
            java.util.Map.Entry entry = (java.util.Map.Entry) it.next();
            Boolean value = (Boolean) entry.getValue();

            if (value)
            {
                return true;
            }
        }
        if (enterCounter>0) enterCounter--;
        if (enterCounter>0) return true;
        return false;
    }

    @Override
    public void eventDispatched(java.awt.AWTEvent event)
    {
        if (!fullscreen) return;

        if (ModalInternalFrame.isModalCount>0) return;

        boolean noPosEvent = false;
        String pos = event.paramString();
        
        int startInString = pos.indexOf("e(");
        int endInString = pos.indexOf("),button");
        
        if (endInString<0)
        {
            endInString = pos.indexOf("),clickCount");
        }
        
        if ((endInString<0) || (startInString<0))
            return;
        
        // System.out.println("Pos " +pos);
        
        pos = pos.substring(startInString+2, endInString);

        String x = pos.substring(0, pos.indexOf(","));
        String y = pos.substring(pos.indexOf(",")+1);
        int Y = Integer.parseInt(y);
        
//        System.out.println("Pos: " +Y);
        
        if (Y>POP_DISPLAY_START_Y)
        {
            if (!overMenu())
            {
                if (!isMac)
                    pop.setVisible(false);
                else
                {



                    Set entries = dum.entrySet();
                    Iterator it = entries.iterator();
                    while (it.hasNext())
                    {
                        java.util.Map.Entry entry = (java.util.Map.Entry) it.next();


                        if (entry.getKey() instanceof JMenu)
                        {
                            JMenu mi= (JMenu)entry.getKey();
                            mi.getPopupMenu().setVisible(false);
                        }

                    }
                    macFrame.setVisible(false);
                }
            }
        }
        else
        {
                if (!isMac)
                {

                    if (pop.isVisible()) return;
                    pop.show(getFrame(), 0, 0);
                }
                else
                {

                macFrame.setVisible(true);

                }
        }
        if (event.paramString().indexOf("button=1") != -1)
        {
            SwingUtilities.invokeLater(new Runnable() {
                @Override
                public void run()
                {
                    resetOverMenu();
                }
            });
        }
    }
    void setMySize()
    {
        getFrame().setMinimumSize(new java.awt.Dimension(sizeX,sizeY));
        getFrame().setMaximumSize(new java.awt.Dimension(sizeX,sizeY));
        getFrame().setPreferredSize(new java.awt.Dimension(sizeX,sizeY));
        getFrame().setSize(sizeX,sizeY);
        getFrame().doLayout();
        getFrame().validate();
    }

    public void preStartMatch()
    {
//        titlePanel1.stopMusic();
//        titlePanel1.stopGlitter();
    }
    public void postMatch()
    {
//        titlePanel1.playMusic();
//        titlePanel1.startGlitter();
    }
    
    public void toFullscreen()
    {
        if (fullscreen) return;
        if (!device.isFullScreenSupported()) return;
        fullscreen = true;
        Configuration.getConfiguration().mIsFullscreen = true;
        
        //save off the old display mode.
        dispModeOld = device.getDisplayMode();
        String dispString = Configuration.getConfiguration().getFullScrrenResString();
        if (dispString.trim().length() != 0)
        {
            DisplayMode d = ConfigurationPanel.getDisplayModeForString(dispString);
            if (d!=null) dispMode = d;
        }

        //hide everything
        getFrame().setVisible(false);

        //remove the frame from being displayable.
        getFrame().dispose();

        //remove borders around the frame
        getFrame().setUndecorated(true);

        // MAC needs this!        
        getRootPane().setWindowDecorationStyle(JRootPane.NONE);
        Global.updateComponentTree();
        
        device.setFullScreenWindow(getFrame());

        //attempt to change the screen resolution.
        device.setDisplayMode(dispMode);

        //show the frame
        getFrame().setVisible(true);

        // if not 2 buffers switching back to windowed mode
        // results (at least with me) in Exceptions
        getFrame().createBufferStrategy(2); // 2 buffers

        //statusPanel.setVisible(false);
        java.awt.Toolkit.getDefaultToolkit().addAWTEventListener(this, java.awt.AWTEvent.MOUSE_MOTION_EVENT_MASK | java.awt.AWTEvent.MOUSE_EVENT_MASK);
        if (!isMac)
            createPopup();
        else
            createMacPopup();
        SwingUtilities.invokeLater(new Runnable() {
            @Override
            public void run()
            {
                Configuration.getConfiguration().setMainSize(mainPanel.getWidth(), mainPanel.getHeight());
//                if (titlePanel1 != null)
//                    titlePanel1.sizeChanged();
                Configuration.getConfiguration().fireSizeChanged(false);
                Configuration.getConfiguration().fireConfigChanged();
                
            }
        });
        menuBar.setVisible(false);
    }
  // found somewhere in forums of the www
  void showComponents( java.awt.Container  c, int depth, java.awt.Container  p)
  {
    System.out.println(""+depth+". "+ c+"\n   ->"+p);
    if (c instanceof java.awt.Container)
    for (int j=0;j<((java.awt.Container)c).getComponentCount();j++)
    {
        final java.awt.Component mc = ((java.awt.Container)c).getComponent(j);
        showComponents((java.awt.Container)mc, depth+1, c);
    }
  }  
    public void toWindowed()
    {
        if (!fullscreen) return;
        fullscreen = false;
        Configuration.getConfiguration().mIsFullscreen = false;

        
        menuBar.setVisible(true);
        java.awt.Toolkit.getDefaultToolkit().removeAWTEventListener(this);

        //hide the frame so we can change it.
        getFrame().setVisible(false);
        
        //remove the frame from being displayable.
        getFrame().dispose();

        
getFrame().setUndecorated(false);
        
        
        //statusPanel.setVisible(true);
        //set the display mode back to the what it was when
        //the program was launched.
        try
        {
            device.setDisplayMode(dispModeOld);
        }
        // under windows an exceptiuon is thrown
        // under mac not
        catch (Throwable e)
        {
        }
            
        
        
        //needed to unset this window as the fullscreen window.
        device.setFullScreenWindow(null);

        //put the borders back on the frame.
        getFrame().setUndecorated(false);
// MAC needs this!        
//getRootPane().setWindowDecorationStyle(JRootPane.FRAME);
        SwingUtilities.updateComponentTreeUI(getFrame());
        
        Global.updateComponentTree();

        

        //recenter window
        getFrame().setLocationRelativeTo(null);

        //reset the display mode to what it was before
        //we changed it.
        getFrame().setVisible(true);
        // if not 2 buffers switching back to windowed mode
        // results (at least with me) in Exceptions
        getFrame().createBufferStrategy(2); // 2 buffers

        getFrame().getJMenuBar().setVisible(true);
        
        createMenuBar();

        
        
        
        SwingUtilities.invokeLater(new Runnable() {
            @Override
            public void run()
            {
                Configuration.getConfiguration().setMainSize(mainPanel.getWidth(), mainPanel.getHeight());
//                if (titlePanel1 != null)
//                    titlePanel1.sizeChanged();
                Configuration.getConfiguration().fireSizeChanged(false);
                Configuration.getConfiguration().fireConfigChanged();
            }
        });
    }

    public void desktopMe(Windowable p)
    {
        for (int i = 0; i < mFrames.size(); i++)
        {
            CSAInternalFrame frame = (CSAInternalFrame) mFrames.elementAt(i);
            if (frame.getPanel() == p)
            {
                desktopMe(frame);
                return;
            }
        }
        addPanel(p);
        setMainPanel((JPanel)p);
    }



    public boolean closeMyWindow(JPanel p)
    {
        for (int i = 0; i < mFrames.size(); i++)
        {
            CSAInternalFrame frame = (CSAInternalFrame) mFrames.elementAt(i);
            if (frame.getPanel() == p)
            {
                try
                {
                    frame.setClosed(true);
                    return true;
                }
                catch(Throwable e) { }
            }
        }
        return false;
    }

    public boolean hideMyPanel(JPanel p)
    {
        removePanel((Windowable) p);
        return true;
    }
    public boolean showMyPanel(Windowable p)
    {
        return showMyPanel( p, false);
    }
    public boolean showMyPanel(Windowable p, boolean now)
    {
        if (now)
        {
            addAsWindow(p, 800, 800, p.getMenuItem().getName());
            return true;
        }
        addPanel(p);
        return true;
    }

    public boolean hideMyWindow(JPanel p)
    {
        for (int i = 0; i < mFrames.size(); i++)
        {
            CSAInternalFrame frame = (CSAInternalFrame) mFrames.elementAt(i);
            if (frame.getPanel() == p)
            {
                try
                {
                    frame.setVisible(false);
                    return true;
                }
                catch(Throwable e) { }
            }
        }
        return false;
    }

    public boolean showMyWindow(JPanel p)
    {
        for (int i = 0; i < mFrames.size(); i++)
        {
            CSAInternalFrame frame = (CSAInternalFrame) mFrames.elementAt(i);
            if (frame.getPanel() == p)
            {
                try
                {
                    frame.setVisible(true);
                    return true;
                }
                catch(Throwable e) { }
            }
        }
        return false;
    }

    @Override
    public void configurationChanged()
    {
        ignoreIconMessage = true;
        if (mCurrentPanel != null)
            setMainPanel(mCurrentPanel);
        ignoreIconMessage = false;
    }



    
    void motd()
    {
        Configuration C = Configuration.getConfiguration();
        VideConfig config = VideConfig.getConfig();
//        if (C.isShowTOD())
        if (config.motdActive)
        {
            TipOfDayGUI c = new TipOfDayGUI();
            c.setParentWindow(this);
//            titlePanel1.add(c);
  //          titlePanel1.setComponentZOrder(c, 0);

            getMainPanel().add(c);
            getMainPanel().setComponentZOrder(c, 0);
            
            c.setBounds(100, 100, 500, 400);
        }
    }

    @Override
    public void removeTOD(TipOfDayGUI starter)
    {
//        titlePanel1.remove(starter);
        starter.deinit();
  //      titlePanel1.invalidate();
  //      titlePanel1.validate();
getMainPanel().remove(starter);
  getMainPanel().invalidate();
  getMainPanel().validate();
  getMainPanel().repaint();
  //      titlePanel1.repaintAll();
    }
    public void showPanelModal(JPanel c, String name)
    {
        showPanelModal(c, name, 550, 400);
    }

    @Override
    public void showPanelModal(JPanel c, String name, int w, int h)
    {
        JPanel all = new JPanel();
        all.setLayout(new BorderLayout());
        all.add(c, BorderLayout.CENTER);
        JButton close = new JButton("Ok");
        all.add(close, BorderLayout.SOUTH);

        final ModalInternalFrame modal = new ModalInternalFrame(name, getFrame().getRootPane(), getFrame(), all, close);

        modal.setResizable(true);
        
        close.addActionListener(new java.awt.event.ActionListener() {
            @Override
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                try
                {
                    modal.setVisible(false);
                }
                catch (Throwable ex){}
            }
        });
        modal.setSize(w, h);

        int x = (getFrame().getRootPane().getWidth() - w) / 2;
        int y = (getFrame().getRootPane().getHeight() - h) / 2;
        modal.setLocation(x, y);
        modal.setVisible(true);
    }
    
    public void correctGarbledDisplay()
    {
        invalidate();
        validate();
        repaint();
        /*
        for (int i = 0; i < mFrames.size(); i++) {
            JInternalFrame frame = mFrames.elementAt(i);
            frame.invalidate();
            frame.validate();
            frame.repaint();
        }
        */
    }
    public static Dimension getInternalFrameDifference()
    {
        if (internalFrameDifference != null) return internalFrameDifference;
        else
        {
            CSAInternalFrame frame = new CSAInternalFrame();
            frame.setSize(100, 100);
            ((CSAMainFrame)Global.mMainWindow).getMainPanel().add(frame);


            frame.setTitle("Test");
            frame.setVisible(true);
            frame.invalidate();
            frame.validate();
            frame.repaint();

            Container c = frame.getContentPane();
            Dimension cc = c.getSize();
            Dimension f = frame.getSize();
            
            internalFrameDifference = new Dimension(f.width-cc.width, f.height-cc.height);
            
            frame.setVisible(false);

            ((CSAMainFrame)Global.mMainWindow).getMainPanel().remove(frame);
            
        }
        return internalFrameDifference;
    }

    
    
    
    
    private void initGame()
    {
        inEvent++;
        gameMode = !gameMode;
        if (gameMode != fullscreen)
        {
            if (!fullscreen)
            {
// FULLSCREEN               toFullscreen();
                setMenu(false);
                keyListener = new  de.malban.event.MasterEventListener()
                {
                    public void eventOccured(de.malban.event.MasterEvent e)
                    {
                        if (e.eventHandled) return;
                        if (e.keyboardState == e.KBD_STATE_RELEASED)
                        {

                            if (e.keyCode == KeyEvent.VK_ESCAPE)
                            {
                                e.eventHandled=true;
                                return;
                            }
                        }
                        // send key events to game!
                    }
                };
                EventSupport.getEventSupport().addKeyEventListener(keyListener);
                
                preStartMatch();
            }
            else
            {
                postMatch();
                EventSupport.getEventSupport().removeKeyEventListener(keyListener);
                keyListener = null;
                setMenu(true);
                toWindowed();
            }
        }
        else if ((!fullscreen) && (!gameMode))
        {
            postMatch();
            EventSupport.getEventSupport().removeKeyEventListener(keyListener);
            keyListener = null;
            setMenu(true);
        }
        inEvent--;
    }    
    public void doGameAction(String action)
    {
    }
    public void doStartMatch()
    {
    }
    
    public boolean hasPanel(Windowable win)
    {
        if (mPanels.contains(win.getPanel())) 
            return true;
        
        for(JInternalFrame frame: mFrames)
        {
            CSAInternalFrame f = (CSAInternalFrame)frame;
            if (f.getPanel().equals((JPanel)win)) 
                return true;
        }
        
        return false;
    }
    
    // deserialize to Object from given file
    public static Object deserialize(String fileName) 
    {
        try
        {
            FileInputStream fis = new FileInputStream(fileName);
            ObjectInputStream ois = new ObjectInputStream(fis);
            Object obj = ois.readObject();
            ois.close();
            return obj;
        }
        catch (java.io.FileNotFoundException e)
        {
            // often the case if nothing was serialzed yet - dont bother
        }
        catch (Throwable e)
        {
            Configuration.getConfiguration().getDebugEntity().addLog("Deserialize not possible for: "+fileName, INFO);
//            Configuration.getConfiguration().getDebugEntity().addLog(e, ERROR);
        }
        return null;
    }    
    
    // serialize the given object and save it to file
    public static boolean serialize(Object obj, String fileName)
    {
        
        try
        {
            FileOutputStream fos = new FileOutputStream(fileName);
            ObjectOutputStream oos = new ObjectOutputStream(fos);
            oos.writeObject(obj);

            fos.close();
        }
        catch (Throwable e)
        {
            Configuration.getConfiguration().getDebugEntity().addLog(e, ERROR);
            return false;
        }
        return true;
    }
    
    // returns the "first" found dissi panel or creates a new one!
    public DissiPanel getDissi()
    {
        DissiPanel dis =checkDissi();
        if (dis == null) dis = createDissi();
        return dis;
    }
    // returns dissi IF already there, null otherwise!
    public DissiPanel checkDissi()
    {
        // get any panel that is called by name dissi
        for (JPanel p: mPanels )
        {
            if (p instanceof Stateable)
            {
                if (((Stateable)p).getID().equals(DissiPanel.SID))
                    return (DissiPanel)p;
            }
        }
        for(JInternalFrame frame: mFrames)
        {
            CSAInternalFrame f = (CSAInternalFrame)frame;
            if (!(f.getPanel() instanceof Stateable)) continue;
            if (((Stateable)f.getPanel()).getID().equals(DissiPanel.SID))
                return (DissiPanel)f.getPanel();
        }
        return null;
    }    
    
    
    public DissiPanel createDissi()
    {
        DissiPanel p = new DissiPanel();        
        addAsWindow(p, 800, 600, p.SID);
        return p;
    }
    // returns the "first" found vecxy panel or creates a new one!
    public VecXPanel getVecxy()
    {
        VecXPanel v =checkVecxy();
        if (v == null) v = createVecxy();
        return v;
    }
    public VecXPanel checkVecxy()
    {
        // get any panel that is called by name dissi
        for (JPanel p: mPanels )
        {
            if (p instanceof Stateable)
            {
                if (((Stateable)p).getID().equals(VecXPanel.SID))
                    return (VecXPanel)p;
            }
        }
        for(JInternalFrame frame: mFrames)
        {
            CSAInternalFrame f = (CSAInternalFrame)frame;
            if (!(f.getPanel() instanceof Stateable)) continue;
            if (((Stateable)f.getPanel()).getID().equals(VecXPanel.SID))
                return (VecXPanel)f.getPanel();
        }
        return null;
    }
    public VecXPanel createVecxy()
    {
        VecXPanel p = new VecXPanel();        
        addAsWindow(p, 600, 300, p.SID);
        return p;
    }
    // returns the "first" found dissi panel or creates a new one!
    public RegisterJPanel getRegi()
    {
        RegisterJPanel r =checkRegi();
        if (r == null) r = createRegi();
        return r;
    }
    public RegisterJPanel checkRegi()
    {
        // get any panel that is called by name dissi
        for (JPanel p: mPanels )
        {
            if (p instanceof Stateable)
            {
                if (((Stateable)p).getID().equals(RegisterJPanel.SID))
                    return (RegisterJPanel)p;
            }
        }
        for(JInternalFrame frame: mFrames)
        {
            CSAInternalFrame f = (CSAInternalFrame)frame;
            if (!(f.getPanel() instanceof Stateable)) continue;
            if (((Stateable)f.getPanel()).getID().equals(RegisterJPanel.SID))
                return (RegisterJPanel)f.getPanel();
        }
        return null;
    }
    public RegisterJPanel createRegi()
    {
        RegisterJPanel p = new RegisterJPanel();        
        addAsWindow(p, 94, 320, p.SID);
        return p;
    }
    public VectorInfoJPanel getVinfi()
    {
        VectorInfoJPanel r =checkVinfi();
        if (r == null) r = createVinfi();
        return r;
    }
    public VectorInfoJPanel checkVinfi()
    {
        // get any panel that is called by name dissi
        for (JPanel p: mPanels )
        {
            if (p instanceof Stateable)
            {
                if (((Stateable)p).getID().equals(VectorInfoJPanel.SID))
                    return (VectorInfoJPanel)p;
            }
        }
        for(JInternalFrame frame: mFrames)
        {
            CSAInternalFrame f = (CSAInternalFrame)frame;
            if (!(f.getPanel() instanceof Stateable)) continue;
            if (((Stateable)f.getPanel()).getID().equals(VectorInfoJPanel.SID))
                return (VectorInfoJPanel)f.getPanel();
        }
        return null;
    }
    public VectorInfoJPanel createVinfi()
    {
        VectorInfoJPanel p = new VectorInfoJPanel();        
        addAsWindow(p, 94, 320, p.SID);
        return p;
    }
    public MemoryDumpPanel getDumpy()
    {
        MemoryDumpPanel r =checkDumpy();
        if (r == null) r = createDumpy();
        return r;
    }
    public MemoryDumpPanel checkDumpy()
    {
        // get any panel that is called by name dissi
        for (JPanel p: mPanels )
        {
            if (p instanceof Stateable)
            {
                if (((Stateable)p).getID().equals(MemoryDumpPanel.SID))
                    return (MemoryDumpPanel)p;
            }
        }
        for(JInternalFrame frame: mFrames)
        {
            CSAInternalFrame f = (CSAInternalFrame)frame;
            if (!(f.getPanel() instanceof Stateable)) continue;
            if (((Stateable)f.getPanel()).getID().equals(MemoryDumpPanel.SID))
                return (MemoryDumpPanel)f.getPanel();
        }
        return null;
    }
    public MemoryDumpPanel createDumpy()
    {
        MemoryDumpPanel p = new MemoryDumpPanel();        
        addAsWindow(p, 94, 320, p.SID);
        return p;
    }
    // returns the "first" found vecxy panel or creates a new one!
    public VIAJPanel getViay()
    {
        VIAJPanel v =checkViay();
        if (v == null) v = createViay();
        return v;
    }
    public VIAJPanel checkViay()
    {
        // get any panel that is called by name dissi
        for (JPanel p: mPanels )
        {
            if (p instanceof Stateable)
            {
                if (((Stateable)p).getID().equals(VIAJPanel.SID))
                    return (VIAJPanel)p;
            }
        }
        for(JInternalFrame frame: mFrames)
        {
            CSAInternalFrame f = (CSAInternalFrame)frame;
            if (!(f.getPanel() instanceof Stateable)) continue;
            if (((Stateable)f.getPanel()).getID().equals(VIAJPanel.SID))
                return (VIAJPanel)f.getPanel();
        }
        return null;
    }
    public VIAJPanel createViay()
    {
        VIAJPanel p = new VIAJPanel();        
        addAsWindow(p, 600, 300, p.SID);
        return p;
    }
    
    // returns the "first" found vecxy panel or creates a new one!
    public VediPanel getVedi(boolean forceNew)
    {
        VediPanel v=null;
        if (!forceNew)
            v =checkVedi();
        if (v == null) v = createVedi();
        return v;
    }
    public VediPanel getVedi()
    {
        VediPanel v =checkVedi();
        if (v == null) v = createVedi();
        return v;
    }
    public VediPanel checkVedi()
    {
        // get any panel that is called by name dissi
        for (JPanel p: mPanels )
        {
            if (p instanceof Stateable)
            {
                if (((Stateable)p).getID().equals(VediPanel.SID))
                    return (VediPanel)p;
            }
        }
        for(JInternalFrame frame: mFrames)
        {
            CSAInternalFrame f = (CSAInternalFrame)frame;
            if (!(f.getPanel() instanceof Stateable)) continue;
            if (((Stateable)f.getPanel()).getID().equals(VediPanel.SID))
                return (VediPanel)f.getPanel();
        }
        return null;
    }
    public VediPanel createVedi()
    {
        VediPanel p = new VediPanel();        
        addAsWindow(p, 600, 600, p.SID);
        return p;
    }
    
    public VediPanel32 getVec32()
    {
        VediPanel32 v =checkVec32();
        if (v == null) v = createVec32();
        return v;
    }
    public VediPanel32 checkVec32()
    {
        // get any panel that is called by name dissi
        for (JPanel p: mPanels )
        {
            if (p instanceof Stateable)
            {
                if (((Stateable)p).getID().equals(VediPanel32.SID))
                    return (VediPanel32)p;
            }
        }
        for(JInternalFrame frame: mFrames)
        {
            CSAInternalFrame f = (CSAInternalFrame)frame;
            if (!(f.getPanel() instanceof Stateable)) continue;
            if (((Stateable)f.getPanel()).getID().equals(VediPanel32.SID))
                return (VediPanel32)f.getPanel();
        }
        return null;
    }
    public VediPanel32 createVec32()
    {
        VediPanel32 p = new VediPanel32();        
        addAsWindow(p, 600, 600, p.SID);
        return p;
    }

    // returns the "first" found vecxy panel or creates a new one!
    public AnalogJPanel getAni()
    {
        AnalogJPanel v =checkAni();
        if (v == null) v = createAni();
        return v;
    }
    public AnalogJPanel checkAni()
    {
        // get any panel that is called by name dissi
        for (JPanel p: mPanels )
        {
            if (p instanceof Stateable)
            {
                if (((Stateable)p).getID().equals(AnalogJPanel.SID))
                    return (AnalogJPanel)p;
            }
        }
        for(JInternalFrame frame: mFrames)
        {
            CSAInternalFrame f = (CSAInternalFrame)frame;
            if (!(f.getPanel() instanceof Stateable)) continue;
            if (((Stateable)f.getPanel()).getID().equals(AnalogJPanel.SID))
                return (AnalogJPanel)f.getPanel();
        }
        return null;
    }
    public AnalogJPanel createAni()
    {
        AnalogJPanel p = new AnalogJPanel();        
        addAsWindow(p, 300, 200, p.SID);
        return p;
    }
    
    
    
    // returns the "first" found vecxy panel or creates a new one!
    public VarJPanel getVari()
    {
        VarJPanel v =checkVari();
        if (v == null) v = createVari();
        return v;
    }
    public VarJPanel checkVari()
    {
        // get any panel that is called by name dissi
        for (JPanel p: mPanels )
        {
            if (p instanceof Stateable)
            {
                if (((Stateable)p).getID().equals(VarJPanel.SID))
                    return (VarJPanel)p;
            }
        }
        for(JInternalFrame frame: mFrames)
        {
            CSAInternalFrame f = (CSAInternalFrame)frame;
            if (!(f.getPanel() instanceof Stateable)) continue;
            if (((Stateable)f.getPanel()).getID().equals(VarJPanel.SID))
                return (VarJPanel)f.getPanel();
        }
        return null;
    }    
    public VarJPanel createVari()
    {
        VarJPanel p = new VarJPanel();        
        addAsWindow(p, 300, 200, p.SID);
        return p;
    }
    
    // returns the "first" found vecxy panel or creates a new one!
    public BreakpointJPanel getBreaki()
    {
        BreakpointJPanel v =checkBreaki();
        if (v == null) v = createBreaki();
        return v;
    }
    public BreakpointJPanel checkBreaki()
    {
        // get any panel that is called by name dissi
        for (JPanel p: mPanels )
        {
            if (p instanceof Stateable)
            {
                if (((Stateable)p).getID().equals(BreakpointJPanel.SID))
                    return (BreakpointJPanel)p;
            }
        }
        for(JInternalFrame frame: mFrames)
        {
            CSAInternalFrame f = (CSAInternalFrame)frame;
            if (!(f.getPanel() instanceof Stateable)) continue;
            if (((Stateable)f.getPanel()).getID().equals(BreakpointJPanel.SID))
                return (BreakpointJPanel)f.getPanel();
        }
        return null;
    }    
    public BreakpointJPanel createBreaki()
    {
        BreakpointJPanel p = new BreakpointJPanel();        
        addAsWindow(p, 460, 200, p.SID);
        return p;
    }
    
        // returns the "first" found vecxy panel or creates a new one!
    public LabelJPanel getLabi()
    {
        LabelJPanel v =checkLabi();
        if (v == null) v = createLabi();
        return v;
    }
    public LabelJPanel checkLabi()
    {
        // get any panel that is called by name dissi
        for (JPanel p: mPanels )
        {
            if (p instanceof Stateable)
            {
                if (((Stateable)p).getID().equals(LabelJPanel.SID))
                    return (LabelJPanel)p;
            }
        }
        for(JInternalFrame frame: mFrames)
        {
            CSAInternalFrame f = (CSAInternalFrame)frame;
            if (!(f.getPanel() instanceof Stateable)) continue;
            if (((Stateable)f.getPanel()).getID().equals(LabelJPanel.SID))
                return (LabelJPanel)f.getPanel();
        }
        return null;
    }    
    public LabelJPanel createLabi()
    {
        LabelJPanel p = new LabelJPanel();        
        addAsWindow(p, 320, 200, p.SID);
        return p;
    }
        // returns the "first" found vecxy panel or creates a new one!

    public PSGJPanel getAyi()
    {
        PSGJPanel v =checkAyi();
        if (v == null) v = createAyi();
        return v;
    }
    public PSGJPanel checkAyi()
    {
        // get any panel that is called by name dissi
        for (JPanel p: mPanels )
        {
            if (p instanceof Stateable)
            {
                if (((Stateable)p).getID().equals(PSGJPanel.SID))
                    return (PSGJPanel)p;
            }
        }
        for(JInternalFrame frame: mFrames)
        {
            CSAInternalFrame f = (CSAInternalFrame)frame;
            if (!(f.getPanel() instanceof Stateable)) continue;
            if (((Stateable)f.getPanel()).getID().equals(PSGJPanel.SID))
                return (PSGJPanel)f.getPanel();
        }
        return null;
    }    
    public PSGJPanel createAyi()
    {
        PSGJPanel p = new PSGJPanel();        
        addAsWindow(p, 320, 200, p.SID);
        return p;
    }
    
    
    public CodeLibraryPanel getCodi()
    {
        CodeLibraryPanel v =checkCodi();
        if (v == null) v = createCodi();
        return v;
    }
    public CodeLibraryPanel checkCodi()
    {
        // get any panel that is called by name dissi
        for (JPanel p: mPanels )
        {
            if (p instanceof Stateable)
            {
                if (((Stateable)p).getID().equals(CodeLibraryPanel.SID))
                    return (CodeLibraryPanel)p;
            }
        }
        for(JInternalFrame frame: mFrames)
        {
            CSAInternalFrame f = (CSAInternalFrame)frame;
            if (!(f.getPanel() instanceof Stateable)) continue;
            if (((Stateable)f.getPanel()).getID().equals(CodeLibraryPanel.SID))
                return (CodeLibraryPanel)f.getPanel();
        }
        return null;
    }    
    public CodeLibraryPanel createCodi()
    {
        CodeLibraryPanel p = new CodeLibraryPanel();        
        addAsWindow(p, 320, 200, p.SID);
        return p;
    }
    
    // returns the "first" found vecxy panel or creates a new one!
    public WRTrackerJPanel getWRTracker()
    {
        WRTrackerJPanel v =checkWRTracker();
        if (v == null) v = createWRTracker();
        return v;
    }
    public WRTrackerJPanel checkWRTracker()
    {
        // get any panel that is called by name dissi
        for (JPanel p: mPanels )
        {
            if (p instanceof Stateable)
            {
                if (((Stateable)p).getID().equals(WRTrackerJPanel.SID))
                    return (WRTrackerJPanel)p;
            }
        }
        for(JInternalFrame frame: mFrames)
        {
            CSAInternalFrame f = (CSAInternalFrame)frame;
            if (!(f.getPanel() instanceof Stateable)) continue;
            if (((Stateable)f.getPanel()).getID().equals(WRTrackerJPanel.SID))
                return (WRTrackerJPanel)f.getPanel();
        }
        return null;
    }    
    public WRTrackerJPanel createWRTracker()
    {
        WRTrackerJPanel p = new WRTrackerJPanel();        
        addAsWindow(p, 320, 200, p.SID);
        return p;
    }

    public StarterJPanel getStarter()
    {
        StarterJPanel v =checkStarter();
        if (v == null) v = createStarter();
        return v;
    }
    public StarterJPanel checkStarter()
    {
        for (JPanel p: mPanels )
        {
            if (p instanceof Stateable)
            {
                if (((Stateable)p).getID().equals(StarterJPanel.SID))
                    return (StarterJPanel)p;
            }
        }
        for(JInternalFrame frame: mFrames)
        {
            CSAInternalFrame f = (CSAInternalFrame)frame;
            if (!(f.getPanel() instanceof Stateable)) continue;
            if (((Stateable)f.getPanel()).getID().equals(StarterJPanel.SID))
                return (StarterJPanel)f.getPanel();
        }
        return null;
    }    
    public StarterJPanel createStarter()
    {
        StarterJPanel p = new StarterJPanel();        
        addAsWindow(p, 320, 200, p.SID);
        return p;
    }
    
    public VeccyPanel getVeccy()
    {
        VeccyPanel v =checkVeccy();
        if (v == null) v = createVeccy();
        return v;
    }
    public VeccyPanel checkVeccy()
    {
        for (JPanel p: mPanels )
        {
            if (p instanceof Stateable)
            {
                if (((Stateable)p).getID().equals(VeccyPanel.SID))
                    return (VeccyPanel)p;
            }
        }
        for(JInternalFrame frame: mFrames)
        {
            CSAInternalFrame f = (CSAInternalFrame)frame;
            if (!(f.getPanel() instanceof Stateable)) continue;
            if (((Stateable)f.getPanel()).getID().equals(VeccyPanel.SID))
                return (VeccyPanel)f.getPanel();
        }
        return null;
    }    
    public VeccyPanel createVeccy()
    {
        VeccyPanel p = new VeccyPanel();        
        addAsWindow(p, 1024, 768, p.SID);
        return p;
    }
    
        
    
    public CSAInternalFrame getInternalFrame(Windowable p)   
    {
        CSAInternalFrame ret = null;
        
        for(JInternalFrame frame: mFrames)
        {
            CSAInternalFrame f = (CSAInternalFrame)frame;
            if (!(f instanceof CSAMacMenuInternalFrame))
            {
                if (f.getPanel().equals((JPanel)p)) 
                {
                    return f;
                }
            }
        }   
        return null;
    }

    public boolean saveState(Stateable p, CSAInternalFrame frame)
    {
        SaveItem s = new SaveItem();
        if (frame == null) return false;
        s.x=frame.getX();
        s.y=frame.getY();
        s.w=frame.getWidth();
        s.h=frame.getHeight();
        s.name = p.getID();
        s.iconified = frame.isIcon();

        try
        {
            CSAMainFrame.serialize(s, Global.mainPathPrefix+"serialize"+File.separator+p.getID()+"Window.ser");
            Serializable ser =  p.getAdditionalStateinfo();
            if (ser != null)
                CSAMainFrame.serialize(ser, Global.mainPathPrefix+"serialize"+File.separator+p.getID()+"Add"+"Window.ser");
        }
        catch (Throwable e)
        {
            log.addLog(e, ERROR);
            return false;
        }
        return true;
    }   
    public boolean loadState(Stateable p, CSAInternalFrame frame)
    {
        SaveItem s;
        try
        {
            if (p.isLoadSettings())
            {
                s = (SaveItem) deserialize(Global.mainPathPrefix+"serialize"+File.separator+p.getID()+"Window.ser");

                if (s == null) return false;
                if (frame == null) return false;
                frame.setBounds(s.x, s.y, s.w, s.h);
                try
                {
                    frame.setIcon(s.iconified);
                }
                catch (Throwable e)
                {
                    
                }

                Serializable ser =  (Serializable) CSAMainFrame.deserialize(Global.mainPathPrefix+"serialize"+File.separator+p.getID()+"Add"+"Window.ser");
                if (ser != null)
                {
                    p.setAdditionalStateinfo(ser);
                }
            }
        }
        catch (Throwable e)
        {
            log.addLog(e, ERROR);
            return false;
        }
        return true;
    }
    boolean saveStateAll()
    {
        saveMe();
        Vector<JInternalFrame> saveFrames = (Vector<JInternalFrame>) mFrames.clone();
        for(JInternalFrame frame: saveFrames)
        {
            CSAInternalFrame f = (CSAInternalFrame)frame;
            JPanel p = f.getPanel();
            try
            {
                if (p instanceof Stateable)
                {
                    if (((Stateable)p).isLoadSettings())
                        saveState((Stateable)p, f);
                }
                if (p instanceof Windowable)
                {
                    ((Windowable)p).closing();
                }
            }
            catch (Throwable e)
            {
                // exceptions are done in savestates
            }
        }
        return true;
    }
    private boolean saveMe()
    {
        SaveItem s = new SaveItem();
        s.x=getX();
        s.y=getY();
        s.w=getWidth();
        s.h=getHeight();
        
        // todo make generic
        s.names = new ArrayList<String>();
        for(JInternalFrame frame: mFrames)
        {
            CSAInternalFrame f = (CSAInternalFrame)frame;
            JPanel p = f.getPanel();
            if (p instanceof Stateable)
            {
                if (((Stateable)p).isLoadSettings())
                    s.names.add(((Stateable)p).getID());
            }
        }
        try
        {
            CSAMainFrame.serialize(s, Global.mainPathPrefix+"serialize"+File.separator+"MainWindow.ser");
        }
        catch (Throwable e)
        {
            log.addLog(e, ERROR);
            return false;
        }
        return true;
    }
    private boolean loadMe()
    {
        SaveItem s;
        try
        {
            s = (SaveItem) deserialize(Global.mainPathPrefix+"serialize"+File.separator+"MainWindow.ser");
            if (s==null) return false;
            
            Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
            double width = screenSize.getWidth();
            double height = screenSize.getHeight();            
            
            boolean doScreenCoords = true;
            if (s.x+s.w>width) doScreenCoords = false;
            if (s.y+s.h>height) doScreenCoords = false;
            
            if (doScreenCoords)
                setBounds(s.x, s.y, s.w, s.h);
            else
                setBounds(0, 0, s.w, s.h);
            
            if (s.names != null)
            {
                for (String id: s.names)
                {
                    if (id.equals(DissiPanel.SID)) getDissi();
                    if (id.equals(RegisterJPanel.SID)) getRegi();
                    if (id.equals(VecXPanel.SID)) getVecxy();
                    if (id.equals(VectorInfoJPanel.SID)) getVinfi();
                    if (id.equals(MemoryDumpPanel.SID)) getDumpy();
                    if (id.equals(VIAJPanel.SID)) getViay();
                    if (id.equals(VediPanel.SID)) getVedi();
                    if (id.equals(AnalogJPanel.SID)) getAni();
                    if (id.equals(VarJPanel.SID)) getVari();
                    if (id.equals(BreakpointJPanel.SID)) getBreaki();
                    if (id.equals(LabelJPanel.SID)) getLabi();
                    if (id.equals(WRTrackerJPanel.SID)) getWRTracker();
                    if (id.equals(CodeLibraryPanel.SID)) getCodi();
                    if (id.equals(PSGJPanel.SID)) getAyi();
                    if (id.equals(StarterJPanel.SID)) getStarter();
                    if (id.equals(VeccyPanel.SID)) getVeccy();
                    if (id.equals(VediPanel32.SID)) getVec32();
                    
                }
            }
        }
        catch (Throwable e)
        {
            log.addLog(e, ERROR);
            
            return false;
        }
        return true;
    }
    
    public static boolean invokeSystemFile(File file)
    {
        Desktop desktop = null;
        // Before more Desktop API is used, first check
        // whether the API is supported by this particular
        // virtual machine (VM) on this particular host.
        try
        {
            if (Desktop.isDesktopSupported())
            {
                desktop = Desktop.getDesktop();
                desktop.open(file);
            }
        }
        catch (Throwable e)
        {
            Configuration.getConfiguration().getDebugEntity().addLog(e, ERROR);
            return false;
        }        
        return true;
    }

    public void addPanel(final Windowable p)
    {
        if (mPanels.contains(p.getPanel())) return;
        ((JPanel)p).setVisible(false);
        mPanels.addElement(p.getPanel());
        mCurrentPanel = p.getPanel();
        javax.swing.JMenuItem jMenuItem = new javax.swing.JMenuItem();
        p.setMenuItem(jMenuItem);
        p.setParentWindow(this);
        jMenuItem.addActionListener(new java.awt.event.ActionListener()
        {
            @Override
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                
                if (mCurrentPanel == p.getPanel())
                {
                    Windowable wp = (Windowable)p;
                    
                    if ((fullDesktopDefault) || (getInternalFrame(wp)==null))
                    {
                        
                        windowMe(wp, 100, 100, p.getMenuItem().getName());
                        if (getInternalFrame(wp)!=null)
                            getInternalFrame(wp).deIconified();
                    }
                    else
                    {
                        if (getInternalFrame(wp).isIcon())
                        {
                            try
                            {
                                getInternalFrame(wp).setIcon(false);
                            }
                            catch (Throwable e)
                            {
                                
                            }
                        }
                        getInternalFrame(wp).toFront();
                        getInternalFrame(wp).grabFocus();
                        try
                        {
                            getInternalFrame(wp).setSelected(true);
                        }
                        catch (Throwable e)
                        {

                        }
                    }
                        
                }
                else
                {
                    if (fullDesktopDefault)
                    {
                        setMainPanel(p.getPanel());
                        mCurrentPanel = p.getPanel();
                    }
                    else
                    {
                        Windowable wp = (Windowable)p;
                        if (getInternalFrame(wp).isIcon())
                        {
                            try
                            {
                                getInternalFrame(wp).setIcon(false);
                            }
                            catch (Throwable e)
                            {
                                
                            }
                        }
                        getInternalFrame(wp).toFront();
                        getInternalFrame(wp).grabFocus();
                        try
                        {
                            getInternalFrame(wp).setSelected(true);
                        }
                        catch (Throwable e)
                        {

                        }
                    }
                }
            }
        });
        
        boolean alreadyAdded = false;
        Component[] c = windowMenu.getPopupMenu().getComponents();
        for (int i=0; i<c.length; i++)
        {
            if (c[i] instanceof javax.swing.JMenuItem)
            {
                javax.swing.JMenuItem mi = (javax.swing.JMenuItem) c[i];
                if (mi == jMenuItem)
                {
                    alreadyAdded = true;
                    break;
                }
            }
        }
        if (!alreadyAdded)
            windowMenu.add(jMenuItem);
        // reset in fullscreen the addEnter Structure
        if (fullscreen)
        {
            addEnter(pop, false);
            addEnter(pop, true);
        }

        ((JPanel)p).setVisible(true);
    }
    public void removePanel(final Windowable p)
    {
        removePanel(p, true);
    }
    public void removePanel(final Windowable p, boolean closing)
    {
        ((JPanel)p).setVisible(false);
        mPanels.removeElement(p.getPanel());
        
        int fcount = 0;
        for(JInternalFrame frame: mFrames)
        {
            CSAInternalFrame f = (CSAInternalFrame)frame;

//if (f.getPanel()==null) System.out.println(""+f.uid+"f.getPanel() null : "+ fcount +" "+f.getTitle()+" "+f.getName());
//fcount++;
            if (!(f instanceof CSAMacMenuInternalFrame))
            {
                if (f.getPanel().equals((JPanel)p)) 
                {
                    try
                    {
                        p.closing();
                        mFrames.remove(f);
                        f.setClosed(true);
                        f.dispose();
                    }
                    catch (Throwable e)
                    {
                        log.addLog("CSAMainFrame: removePanel: "+e.getMessage(), WARN);
                    }
                    break;
                }
            }
        }
       
        
        
        if (closing)
        {
            JMenuItem item = p.getMenuItem();
            if (item!=null)
                windowMenu.remove(item);
        }
        // reset in fullscreen the addEnter Structure
        if (fullscreen)
        {
            addEnter(pop, false);
            addEnter(pop, true);
        }
        if (mPanels.size()>0)
        {
            
            setMainPanel(mPanels.elementAt(0));
            mCurrentPanel = mPanels.elementAt(0);
        }
        else
        {
            mCurrentPanel = null;
            resetMainPanel();
        }
        if (p ==(Windowable) Configuration.getConfiguration().getLogEntity())
        {
            mLogDisplayed = false;
        }
        if (Configuration.getConfiguration().getDebugEntity() instanceof Windowable)
        if (p ==(Windowable) Configuration.getConfiguration().getDebugEntity())
        {
            mDebugDisplayed = false;
        }
        if (closing)
            p.closing();
    }
    public void setMainPanel(javax.swing.JPanel panel)
    {
        if (panel == null) return;
        boolean backdrop = false;
        if (Configuration.getConfiguration().isBackImageShown())
        {
            backdrop = true;
        }
        backdrop = backdrop && (!panel.isOpaque());
        if (!backdrop )
        {
            setMainPanelOld(panel);
        }
        else
        {
        }
        invalidate();
        validate();
        repaint();
    }
    private boolean ignoreIconMessage = false;
    public void setMainPanelOld(javax.swing.JPanel panel)
    {
        panel.setVisible(false);
        mDesktop.setVisible(false);
        
        for (int i = 0;i<mDesktop.getComponentCount();i++)
        {
            mDesktop.getComponent(i).setVisible(false);
        }
        
        
// CSA VIDE DESKTOPABLE
        mDesktop.removeAll();
        if (!ignoreIconMessage)
        {
            for (int i=0; i <  mFrames.size(); i++)
            {
                JInternalFrame f = mFrames.elementAt(i);

                if (f instanceof CSAInternalFrame)
                {
                    ((CSAInternalFrame) f).setIconState(f.isIcon());
                    if (f.isIcon())
                    {
                        ((CSAInternalFrame) f).setIconBounds(f.getDesktopIcon().getBounds());
                        try
                        {
                            f.setIcon(false); // after adding a previously iconified will be "large", but iconify is still set, so unset it
                        }
                        catch (Throwable e){}
                    }
                }
            }
        }

        javax.swing.GroupLayout mainPanelLayout = new javax.swing.GroupLayout(mDesktop);
        mDesktop.setLayout(mainPanelLayout);

        synchronized (panel)
        {
            mainPanelLayout.setHorizontalGroup(
                mainPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                .addComponent(panel, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            );
            mainPanelLayout.setVerticalGroup(
                mainPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                .addComponent(panel, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            );
            panel.setVisible(true);
        }
        mDesktop.setVisible(true);

    }
    private void resetMainPanel()
    {
    }

    public java.awt.Container getMainPanel()
    {
        return mDesktop;
    }    
    public void desktopMe(CSAInternalFrame f)
    {
        JPanel p = f.getPanel();

        ((JPanel)p).setVisible(false);
        f.setVisible(false);
        if (p instanceof CloseWatcher) ((CloseWatcher)p).preClose();
        try
        {
            f.setClosed(true);
        }
        catch (Throwable e){}
        removeInternalFrame(f);
        if (p instanceof CloseWatcher) ((CloseWatcher)p).postClose();
        addPanel((Windowable) p);
        ((JPanel)p).setVisible(true);
        setMainPanel(p);

    }
    
    public CSAInternalFrame windowMe(Windowable p, int w, int h, String title)
    {
        ((JPanel)p).setVisible(false);
        if (p instanceof CloseWatcher) ((CloseWatcher)p).preClose();
        removePanel(p, false);
        CSAInternalFrame frame = new CSAInternalFrame();
        frame.addPanel((JPanel)p);
        frame.setSize(w, h);
        if (!fullDesktopDefault)
            frame.setIconifiable(true);
        
            
        
// CSA VIDE DESKTOPABLE
        mDesktop.removeAll();
        for (int i=0; i <  mFrames.size(); i++)
        {
            JInternalFrame f = mFrames.elementAt(i);

            if (f instanceof CSAInternalFrame)
            {
            //    addInternalFrame(((CSAInternalFrame) f));
//             f.setFrameIcon( new ImageIcon(Configuration.getConfiguration().getCurrentTheme().getImage(("RedIconSmall.png"))));
//            f.setDesktopIcon(new JInternalFrame.JDesktopIcon(f));
            JInternalFrame.JDesktopIcon icon = f.getDesktopIcon();
            icon.setVisible(true);
         
         
            getMainPanel().add(f);
       f.setVisible(true);
            getMainPanel().setComponentZOrder(f, 0);
                
                try
                {
                    if (((CSAInternalFrame) f).getIconState())
                    {
                        
                        f.setIcon(((CSAInternalFrame) f).getIconState());
                        if (((CSAInternalFrame) f).getIconBounds() != null)
                            f.getDesktopIcon().setBounds(((CSAInternalFrame) f).getIconBounds());
                    }
                }
                catch (Throwable x) {}
            }
        }
//            
          
                    
        
        
        
        
        addInternalFrame(frame);
        if (p instanceof CloseWatcher) ((CloseWatcher)p).postClose();
        
        frame.setTitle(title);
        frame.setVisible(true);
        
        if (internalFrameDifference == null)
        {
            Container c = frame.getContentPane();
            Dimension cc = c.getSize();
            Dimension f = frame.getSize();
            
            internalFrameDifference = new Dimension(f.width-cc.width, f.height-cc.height);
        }
        
        ((JPanel)p).setVisible(true);
        if (p instanceof Stateable)
        {
            loadState((Stateable)p, frame);
        }


        // desperate!
        for (int i = 0;i<mDesktop.getComponentCount();i++)
        {
            Component component = mDesktop.getComponent(i);

            if (component instanceof CSAInternalFrame)
            {
                CSAInternalFrame csaFrame = ((CSAInternalFrame) component);
                if (csaFrame.getIconState())
                {
                    try
                    {
                        csaFrame.setIcon(csaFrame.getIconState());
                        csaFrame.setIconBounds(csaFrame.getIconBounds());
                    }
                    catch (Throwable e)
                    {
                    }                            
                }
            }
        }
        return frame;
    }


    public CSAInternalFrame addAsWindow(final Windowable p, int w, int h, String title)
    {
        ((JPanel)p).setVisible(false);
        if (mPanels.contains(p.getPanel()))
        {
            removePanel(p, false);
        }
        javax.swing.JMenuItem jMenuItem = new javax.swing.JMenuItem();
        p.setMenuItem(jMenuItem);
        p.setParentWindow(this);
        jMenuItem.addActionListener(new java.awt.event.ActionListener()
        {
            @Override
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                
                if (mCurrentPanel == p.getPanel())
                {
                    if (fullDesktopDefault)
                        windowMe((Windowable)p, 100, 100, p.getMenuItem().getName());
                    else
                    {
                        Windowable wp = (Windowable)p;
                        if (getInternalFrame(wp).isIcon())
                        {
                            try
                            {
                                getInternalFrame(wp).setIcon(false);
                            }
                            catch (Throwable e)
                            {
                                
                            }
                        }
                        getInternalFrame(wp).toFront();
                        getInternalFrame(wp).grabFocus();
                        try
                        {
                            getInternalFrame(wp).setSelected(true);
                        }
                        catch (Throwable e)
                        {

                        }
                    }
                        
                }
                else
                {
                    if (fullDesktopDefault)
                    {
                        setMainPanel(p.getPanel());
                        mCurrentPanel = p.getPanel();
                    }
                    else
                    {
                        Windowable wp = (Windowable)p;
                        if (getInternalFrame(wp).isIcon())
                        {
                            try
                            {
                                getInternalFrame(wp).setIcon(false);
                            }
                            catch (Throwable e)
                            {
                                
                            }
                        }
                        getInternalFrame(wp).toFront();
                        getInternalFrame(wp).grabFocus();
                        try
                        {
                            getInternalFrame(wp).setSelected(true);
                        }
                        catch (Throwable e)
                        {

                        }
                    }
                }
            }
        });        
        boolean alreadyAdded = false;
        Component[] co = windowMenu.getPopupMenu().getComponents();
        for (int i=0; i<co.length; i++)
        {
            if (co[i] instanceof javax.swing.JMenuItem)
            {
                javax.swing.JMenuItem mi = (javax.swing.JMenuItem) co[i];
                if (mi == jMenuItem)
                {
                    alreadyAdded = true;
                    break;
                }
            }
        }
        if (!alreadyAdded)
            windowMenu.add(jMenuItem);

        CSAInternalFrame frame = new CSAInternalFrame();
        frame.addPanel((JPanel)p);
        frame.setSize(w, h);
        if (!fullDesktopDefault)
            frame.setIconifiable(true);
        
        addInternalFrame(frame);
        
        frame.setTitle(title);
        frame.setVisible(true);
        
        if (internalFrameDifference == null)
        {
            Container c = frame.getContentPane();
            Dimension cc = c.getSize();
            Dimension f = frame.getSize();
            internalFrameDifference = new Dimension(f.width-cc.width, f.height-cc.height);
        }
        
        ((JPanel)p).setVisible(true);
        if (p instanceof Stateable)
        {
            loadState((Stateable)p, frame);
        }
        return frame;
    }

    void setUpGlobalKeys()
    {
        KeyboardFocusManager keyManager;

        keyManager=KeyboardFocusManager.getCurrentKeyboardFocusManager();
        keyManager.addKeyEventDispatcher(new KeyEventDispatcher() 
        {
            @Override
            public boolean dispatchKeyEvent(KeyEvent e) 
            {
                if (e.getKeyCode()==KeyEvent.VK_CONTROL)
                {
                    if (e.getID()==KeyEvent.KEY_PRESSED)
                    {
                    }
                    if (e.getID()==KeyEvent.KEY_RELEASED)
                    {
                        stopWindowManager();
                        return true;
                    }
                }
                
                // TAB
                if (e.getKeyCode()==KeyEvent.VK_TAB)
                {
                    if (e.getID()==KeyEvent.KEY_PRESSED)
                    {
                        if (e.isControlDown())
                        {
                            startWindowManager();
                            return true;
                        }
                    }
                    else
                    {
                    }
                }
                
                if(e.getID()==KeyEvent.KEY_PRESSED && e.getKeyCode()==KeyEvent.VK_ESCAPE)
                {
//                    System.out.println("Esc");
                    return true;
                }
                return false;
            }

        });        
        
    }
    boolean wmStarted = false;
    CSAInternalFrame wmFrame = null;
    WindowManagerJPanel wm = null;
    void startWindowManager()
    {
        if (wmStarted)
        {
            windowManagerNextTab();
            return;
        }
        
        
        wm = new WindowManagerJPanel(this);
        
        
        wmFrame = new CSAInternalFrame();

        BasicInternalFrameUI bi = (BasicInternalFrameUI)wmFrame.getUI();
        bi.setNorthPane(null);        
        wmFrame.setBorder(null);
        /*
        wmFrame.addComponentListener(new java.awt.event.ComponentAdapter() {
            public void componentResized(java.awt.event.ComponentEvent evt) {
                wm.setBounds(0,0,wmFrame.getWidth(), wmFrame.getHeight());
            
            }
        });
        */
        wmFrame.setBackground(new java.awt.Color(200, 200, 255,255));

        wmFrame.addPanel(wm);
        wmFrame.setSize(155, 400);
        wmFrame.setResizable(false);
        wmFrame.setParent(this);
        getMainPanel().add(wmFrame);
        getMainPanel().setComponentZOrder(wmFrame, 0);
        
        wmFrame.setBounds(this.getWidth()/2-wmFrame.getBounds().width/2, this.getHeight()/2-wmFrame.getBounds().height/2, wmFrame.getBounds().width, wm.getSizeY());
        
        wmFrame.setTitle("WinMan");
        wmFrame.setVisible(true);
        wmStarted = true;
    }
    void stopWindowManager()
    {
        if (!wmStarted) return;
        int i = wm.getSel();
        try
        {
            mFrames.elementAt(i).setIcon(false);
            mFrames.elementAt(i).toFront();
            mFrames.elementAt(i).setSelected(true);
        }
        catch (Throwable e)
        {
            
        }
        
        getMainPanel().remove(wmFrame);
        wmStarted = false;
        wmFrame.setVisible(false);
        wmFrame = null;
        wm = null;
        this.repaint();
    }
    void windowManagerNextTab()
    {
        wm.doTab();
    }
    
    

    public CartridgePanel getCartridge()
    {
        CartridgePanel v =checkCartridge();
        if (v == null) v = createCartridge();
        return v;
    }
    public CartridgePanel checkCartridge()
    {
        for (JPanel p: mPanels )
        {
            if (p instanceof Stateable)
            {
                if (((Stateable)p).getID().equals(CartridgePanel.SID))
                    return (CartridgePanel)p;
            }
        }
        for(JInternalFrame frame: mFrames)
        {
            CSAInternalFrame f = (CSAInternalFrame)frame;
            if (!(f.getPanel() instanceof Stateable)) continue;
            if (((Stateable)f.getPanel()).getID().equals(CartridgePanel.SID))
                return (CartridgePanel)f.getPanel();
        }
        return null;
    }    
    public CartridgePanel createCartridge()
    {
        CartridgePanel p = new CartridgePanel();        
        addAsWindow(p, 320, 200, p.SID);
        return p;
    }
    

    public JoyportPanel getJoyportDevice()
    {
        JoyportPanel v =checkJoyportDevice();
        if (v == null) v = createJoyportDevice();
        return v;
    }
    public JoyportPanel checkJoyportDevice()
    {
        for (JPanel p: mPanels )
        {
            if (p instanceof Stateable)
            {
                if (((Stateable)p).getID().equals(JoyportPanel.SID))
                    return (JoyportPanel)p;
            }
        }
        for(JInternalFrame frame: mFrames)
        {
            CSAInternalFrame f = (CSAInternalFrame)frame;
            if (!(f.getPanel() instanceof Stateable)) continue;
            if (((Stateable)f.getPanel()).getID().equals(JoyportPanel.SID))
                return (JoyportPanel)f.getPanel();
        }
        return null;
    }    
    public JoyportPanel createJoyportDevice()
    {
        JoyportPanel p = new JoyportPanel();        
        addAsWindow(p, 320, 200, p.SID);
        return p;
    }   
    
    CSAInternalFrame topElement = null;
    public void setTopElement(CSAInternalFrame f)
    {
        topElement = f;
    }
    void doZOrder()
    {
        if (topElement != null)
        {
            setComponentZOrder(topElement, 0);
            topElement.repaint();
        }
    }
    
    public ArrayList<Object> getPanels(Class type)
    {
        ArrayList<Object> list = new ArrayList<Object>();
        
        for (JPanel p: mPanels )
        {
            if (type.isInstance(p))
            {
                list.add(p);
            }
        }
        for(JInternalFrame frame: mFrames)
        {
            CSAInternalFrame f = (CSAInternalFrame)frame;
            if (type.isInstance(f.getPanel()))
            {
                list.add(f.getPanel());
            }
        }        
        
        return list;
    }
    
    void initLibrary()
    {
        jMenuLibrary.removeAll();
        String baseDir = Global.mainPathPrefix+"documents";
        addFilesToMenu(jMenuLibrary, baseDir);
    }
    void addFilesToMenu(javax.swing.JMenu menu, String path)
    {
        File pfile = new File(path);
        if (pfile.isDirectory())
        {
            // get all the files from a directory
            File[] fList = pfile.listFiles();
            Arrays.sort(fList);
            // two times, to output all directories first
            for (File file : fList) 
            {
                if (file.isDirectory())
                {
                    if (file.toString().toLowerCase().endsWith("firstvectrex")) continue;
                    JMenu newMenu = new javax.swing.JMenu();
                    newMenu.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/folder.png"))); // NOI18N
                    newMenu.setText(file.getName());
                    addFilesToMenu(newMenu, file.getPath());
                    if (newMenu.getItemCount()>0)
                        menu.add(newMenu);
                }
            }
            for (File file : fList) 
            {
                if (!file.isDirectory())
                {
                    if (file.toString().toLowerCase().contains("_critics.txt")) continue;
                    if (file.toString().toLowerCase().contains("_instructions.txt")) continue;
                    addFilesToMenu(menu, file.getPath());
                    
                }
            }
        }
        else
        {
            for (LibraryMap lm: libMap)
            {
                String name = pfile.getName();
                if (pfile.toString().toLowerCase().endsWith(lm.ending))
                {
                    name = name.substring(0, name.length()-lm.ending.length());
                    javax.swing.JMenuItem mItem = new javax.swing.JMenuItem();
                    mItem.setText(name);
                    mItem.setIcon(new javax.swing.ImageIcon(getClass().getResource(lm.image))); // NOI18N
                    mItem.addActionListener(new java.awt.event.ActionListener() 
                    {
                        public void actionPerformed(java.awt.event.ActionEvent evt) 
                        {
                            invokeSystemFile(pfile);
                        }
                    });
                    menu.add(mItem);
                }
            }
        }
    }
    static class LibraryMap
    {
        String ending="";
        String image="";
        LibraryMap(String e, String i)
        {
            ending = e;
            image = i;
        }
    }
    static ArrayList<LibraryMap> libMap = null;
    static void initLibraryMapping()
    {
        if (libMap != null) return;
        libMap = new ArrayList<LibraryMap>();
        libMap.add(new LibraryMap(".pdf", "/de/malban/vide/images/page_white_acrobat.png"));
        libMap.add(new LibraryMap(".html", "/de/malban/vide/images/html.png"));
        libMap.add(new LibraryMap(".txt", "/de/malban/vide/images/text_align_justify.png"));
        libMap.add(new LibraryMap(".rtf", "/de/malban/vide/images/text_dropcaps.png"));
        libMap.add(new LibraryMap(".doc", "/de/malban/vide/images/page_white_word.png"));
    }
    
    public void toFront(Windowable panel)
    {
        try
        {
            getInternalFrame(panel).setIcon(false);
            getInternalFrame(panel).toFront();
            getInternalFrame(panel).setSelected(true);
        }
        catch (Throwable e)
        {
            
        }
        
    }
    

    public ProfileJPanel getProfi()
    {
        ProfileJPanel v =checkProfi();
        if (v == null) v = createProfi();
        return v;
    }
    public ProfileJPanel checkProfi()
    {
        // get any panel that is called by name dissi
        for (JPanel p: mPanels )
        {
            if (p instanceof Stateable)
            {
                if (((Stateable)p).getID().equals(ProfileJPanel.SID))
                    return (ProfileJPanel)p;
            }
        }
        for(JInternalFrame frame: mFrames)
        {
            CSAInternalFrame f = (CSAInternalFrame)frame;
            if (!(f.getPanel() instanceof Stateable)) continue;
            if (((Stateable)f.getPanel()).getID().equals(ProfileJPanel.SID))
                return (ProfileJPanel)f.getPanel();
        }
        return null;
    }    
    public ProfileJPanel createProfi()
    {
        ProfileJPanel p = new ProfileJPanel();        
        addAsWindow(p, 320, 200, p.SID);
        return p;
    }
}

