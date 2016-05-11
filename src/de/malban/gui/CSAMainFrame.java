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
import static de.malban.gui.panels.LogPanel.WARN;
import de.malban.gui.panels.TipOfDayGUI;
import de.malban.gui.panels.WindowablePanel;
import de.malban.jdbc.DBConnectionEdit;
import de.malban.jdbc.StatementWindow;
import de.malban.vide.assy.AssyPanel;
import de.malban.vide.dissy.CompareDissiPanel;
import de.malban.vide.dissy.DissiFullPanel;
import de.malban.vide.vecx.panels.AnalogJPanel;
import de.malban.vide.vecx.panels.BreakpointJPanel;
import de.malban.vide.ConfigJPanel;
import de.malban.vide.codi.CodeLibraryPanel;
import de.malban.vide.vecx.panels.LabelJPanel;
import de.malban.vide.vecx.panels.MemoryDumpPanel;
import de.malban.vide.vecx.panels.PSGJPanel;
import de.malban.vide.vecx.panels.RegisterJPanel;
import de.malban.vide.vecx.panels.VIAJPanel;
import de.malban.vide.vecx.panels.VarJPanel;
import de.malban.vide.vecx.VecXPanel;
import de.malban.vide.vecx.cartridge.CartridgePropertiesPanel;
import de.malban.vide.vecx.panels.StarterJPanel;
import de.malban.vide.vecx.panels.VectorInfoJPanel;
import de.malban.vide.vecx.panels.WRTrackerJPanel;
import de.malban.vide.vedi.VediPanel;
import java.awt.*;
import java.awt.event.KeyEvent;
import java.awt.event.MouseAdapter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;
import java.util.*;
import javax.help.DefaultHelpBroker;
import javax.help.HelpBroker;
import javax.help.HelpSet;
import javax.help.JHelpContentViewer;
import javax.help.WindowPresentation;
import javax.swing.*;
import javax.swing.plaf.UIResource;

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
    static HashMap <String, UIResource> windowedDefaults;
    static HashMap <String, UIResource> fullscreenDefaults;

    static Color fFontColor;
    static Color fBackColor;
    static
    {
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

//        fullscreenDefaults.put("Panel.background", new javax.swing.plaf.ColorUIResource(0,0,0));
        UIManager.put("TabbedPane.tabsOpaque", Boolean.FALSE);
        UIManager.put("TabbedPane.contentOpaque", Boolean.FALSE);


        uiDefaults = UIManager.getDefaults();
        uiDefaults.put("TabbedPane.contentOpaque", Boolean.FALSE);
        uiDefaults.put("TabbedPane.tabsOpaque", Boolean.FALSE);
//        uiDefaults.put("TabbedPane.highlight", new javax.swing.plaf.ColorUIResource(new Color(0,255,0,100)));

        if (Global.mMainWindow != null)
        SwingUtilities.updateComponentTreeUI(  Global.mMainWindow );
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

    private JDesktopPane mDesktop = new JDesktopPane();
    public JDesktopPane getDesktop(){return mDesktop;}

    /**
     * Creates new form CSAMainFrame
     */
    public CSAMainFrame() {
        //initComponents();
        Global.mMainWindow = this;

        ToolTipManager.sharedInstance().setDismissDelay(15000);
        Theme t = Configuration.getConfiguration().getCurrentTheme();
        getFrame().setIconImage(t.getImage(("RedIconSmall.png")));
        Configuration.getConfiguration().setMainFrame(getFrame());
        initComponents();

        if (!device.isFullScreenSupported())
        {
        }

        mainPanel.removeAll();
        mainPanel.setLayout(new java.awt.BorderLayout());
        mainPanel.add(mDesktop, java.awt.BorderLayout.CENTER);
        resetMainPanel();

//        titlePanel1.setPortalView(this);

        Configuration.getConfiguration().init();
        Configuration.getConfiguration().addConfigListerner(this);
        windowMenu.removeAll();
        windowMenu.add(jMenuItemCloseWin);
        if (Configuration.getConfiguration().isStartInFullScrren())
        {
            SwingUtilities.invokeLater(new Runnable() {
                @Override
                public void run()
                {
                    toFullscreen();
                }
            });
        }
        windowMenu.add(jMenuItemDebug);
        if (Configuration.getConfiguration().isStartInFullScrren())
        {
            SwingUtilities.invokeLater(new Runnable() {
                @Override
                public void run()
                {
                    toFullscreen();
                }
            });
        }
        SwingUtilities.invokeLater(new Runnable() {
            @Override
            public void run()
            {
                Configuration.getConfiguration().fireSizeChanged(false);
                Configuration.getConfiguration().fireConfigChanged();
            }
        });

        getFrame().setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);
        loadMe();
    }

    public final JFrame getFrame()
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
        jMenuItem3 = new javax.swing.JMenuItem();
        jMenuItem4 = new javax.swing.JMenuItem();
        jMenuItemCartridgeEdit = new javax.swing.JMenuItem();
        exitMenuItem = new javax.swing.JMenuItem();
        toolsMenu = new javax.swing.JMenu();
        jMenuItemStarter = new javax.swing.JMenuItem();
        jMenuItemVecxi = new javax.swing.JMenuItem();
        jMenuItemVedi = new javax.swing.JMenuItem();
        jMenuItemCodi = new javax.swing.JMenuItem();
        jMenuItemVeccy = new javax.swing.JMenuItem();
        jMenuItemDissy = new javax.swing.JMenuItem();
        jMenuItemAssi = new javax.swing.JMenuItem();
        jSeparator1 = new javax.swing.JPopupMenu.Separator();
        jMenuItemConfig = new javax.swing.JMenuItem();
        jMenuLibrary = new javax.swing.JMenu();
        jMenu1 = new javax.swing.JMenu();
        jMenu7 = new javax.swing.JMenu();
        jMenuItem6 = new javax.swing.JMenuItem();
        jMenuItem8 = new javax.swing.JMenuItem();
        jMenuItem7 = new javax.swing.JMenuItem();
        jMenuItem9 = new javax.swing.JMenuItem();
        jMenuItem10 = new javax.swing.JMenuItem();
        jMenuItem11 = new javax.swing.JMenuItem();
        jMenuItem13 = new javax.swing.JMenuItem();
        jMenuItem14 = new javax.swing.JMenuItem();
        jMenuItem17 = new javax.swing.JMenuItem();
        jMenuItem18 = new javax.swing.JMenuItem();
        jMenuItem19 = new javax.swing.JMenuItem();
        jMenuItem20 = new javax.swing.JMenuItem();
        jMenuItem21 = new javax.swing.JMenuItem();
        jMenuItem22 = new javax.swing.JMenuItem();
        jMenuItem23 = new javax.swing.JMenuItem();
        jMenuItem37 = new javax.swing.JMenuItem();
        jMenu3 = new javax.swing.JMenu();
        jMenu4 = new javax.swing.JMenu();
        jMenuItem24 = new javax.swing.JMenuItem();
        jMenuItem25 = new javax.swing.JMenuItem();
        jMenuItem26 = new javax.swing.JMenuItem();
        jMenuItem27 = new javax.swing.JMenuItem();
        jMenuItem34 = new javax.swing.JMenuItem();
        jMenuItem35 = new javax.swing.JMenuItem();
        jMenu5 = new javax.swing.JMenu();
        jMenuItem28 = new javax.swing.JMenuItem();
        jMenuItem29 = new javax.swing.JMenuItem();
        jMenuItem36 = new javax.swing.JMenuItem();
        jMenu6 = new javax.swing.JMenu();
        jMenuItem30 = new javax.swing.JMenuItem();
        jMenuItem31 = new javax.swing.JMenuItem();
        jMenuItem32 = new javax.swing.JMenuItem();
        jMenuItem33 = new javax.swing.JMenuItem();
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
        setMinimumSize(new java.awt.Dimension(1024, 768));
        setPreferredSize(new java.awt.Dimension(1024, 768));
        addWindowListener(new java.awt.event.WindowAdapter() {
            public void windowClosing(java.awt.event.WindowEvent evt) {
                formWindowClosing(evt);
            }
        });

        mainPanel.setLayout(new java.awt.BorderLayout());
        getContentPane().add(mainPanel, java.awt.BorderLayout.CENTER);

        fileMenu.setForeground(Color.black);
        fileMenu.setText("File");

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

        jMenuItem3.setText("compare Dissi");
        jMenuItem3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem3ActionPerformed(evt);
            }
        });
        jMenu2.add(jMenuItem3);

        jMenuItem4.setText("File utility");
        jMenuItem4.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem4ActionPerformed(evt);
            }
        });
        jMenu2.add(jMenuItem4);

        jMenuItemCartridgeEdit.setText("EditCartridgeInfo");
        jMenuItemCartridgeEdit.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemCartridgeEditActionPerformed(evt);
            }
        });
        jMenu2.add(jMenuItemCartridgeEdit);

        fileMenu.add(jMenu2);

        exitMenuItem.setText("Exit");
        exitMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                exitMenuItemActionPerformed(evt);
            }
        });
        fileMenu.add(exitMenuItem);

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

        jMenuItemConfig.setText("Configuration");
        jMenuItemConfig.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemConfigActionPerformed(evt);
            }
        });
        toolsMenu.add(jMenuItemConfig);

        menuBar.add(toolsMenu);

        jMenuLibrary.setText("Library");

        jMenu1.setText("Hardware");

        jMenu7.setText("Original");

        jMenuItem6.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/gui/Adobe_PDF_file_icon_24x24.png"))); // NOI18N
        jMenuItem6.setText("MC6809 Motorola");
        jMenuItem6.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem6ActionPerformed(evt);
            }
        });
        jMenu7.add(jMenuItem6);

        jMenuItem8.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/gui/Adobe_PDF_file_icon_24x24.png"))); // NOI18N
        jMenuItem8.setText("MC6809 Motorola");
        jMenuItem8.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem8ActionPerformed(evt);
            }
        });
        jMenu7.add(jMenuItem8);

        jMenuItem7.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/gui/Adobe_PDF_file_icon_24x24.png"))); // NOI18N
        jMenuItem7.setText("VIA 6552A");
        jMenuItem7.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem7ActionPerformed(evt);
            }
        });
        jMenu7.add(jMenuItem7);

        jMenuItem9.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/gui/Adobe_PDF_file_icon_24x24.png"))); // NOI18N
        jMenuItem9.setText("PSG AY-3-891X");
        jMenuItem9.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem9ActionPerformed(evt);
            }
        });
        jMenu7.add(jMenuItem9);

        jMenuItem10.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/gui/Adobe_PDF_file_icon_24x24.png"))); // NOI18N
        jMenuItem10.setText("LF 147");
        jMenuItem10.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem10ActionPerformed(evt);
            }
        });
        jMenu7.add(jMenuItem10);

        jMenuItem11.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/gui/Adobe_PDF_file_icon_24x24.png"))); // NOI18N
        jMenuItem11.setText("LF 153");
        jMenuItem11.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem11ActionPerformed(evt);
            }
        });
        jMenu7.add(jMenuItem11);

        jMenuItem13.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/gui/Adobe_PDF_file_icon_24x24.png"))); // NOI18N
        jMenuItem13.setText("SN74LS32");
        jMenuItem13.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem13ActionPerformed(evt);
            }
        });
        jMenu7.add(jMenuItem13);

        jMenuItem14.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/gui/Adobe_PDF_file_icon_24x24.png"))); // NOI18N
        jMenuItem14.setText("SN54/74LS00");
        jMenuItem14.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem14ActionPerformed(evt);
            }
        });
        jMenu7.add(jMenuItem14);

        jMenuItem17.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/gui/Adobe_PDF_file_icon_24x24.png"))); // NOI18N
        jMenuItem17.setText("MC34004P");
        jMenuItem17.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem17ActionPerformed(evt);
            }
        });
        jMenu7.add(jMenuItem17);

        jMenuItem18.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/gui/Adobe_PDF_file_icon_24x24.png"))); // NOI18N
        jMenuItem18.setText("DAC0808");
        jMenuItem18.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem18ActionPerformed(evt);
            }
        });
        jMenu7.add(jMenuItem18);

        jMenuItem19.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/gui/Adobe_PDF_file_icon_24x24.png"))); // NOI18N
        jMenuItem19.setText("LF353");
        jMenuItem19.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem19ActionPerformed(evt);
            }
        });
        jMenu7.add(jMenuItem19);

        jMenuItem20.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/gui/Adobe_PDF_file_icon_24x24.png"))); // NOI18N
        jMenuItem20.setText("74HC4066 (MUX)");
        jMenuItem20.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem20ActionPerformed(evt);
            }
        });
        jMenu7.add(jMenuItem20);

        jMenuItem21.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/gui/Adobe_PDF_file_icon_24x24.png"))); // NOI18N
        jMenuItem21.setText("4052B");
        jMenuItem21.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem21ActionPerformed(evt);
            }
        });
        jMenu7.add(jMenuItem21);

        jMenuItem22.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/gui/Adobe_PDF_file_icon_24x24.png"))); // NOI18N
        jMenuItem22.setText("2114 RAM");
        jMenuItem22.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem22ActionPerformed(evt);
            }
        });
        jMenu7.add(jMenuItem22);

        jMenu1.add(jMenu7);

        jMenuItem23.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/html.png"))); // NOI18N
        jMenuItem23.setText("Lecture CPU");
        jMenuItem23.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem23ActionPerformed(evt);
            }
        });
        jMenu1.add(jMenuItem23);

        jMenuItem37.setIcon(new javax.swing.ImageIcon("/Users/malban/NetBeansProjects/Veccy/src/de/malban/vide/images/text_dropcaps.png")); // NOI18N
        jMenuItem37.setText("Lightpen FAQ");
        jMenu1.add(jMenuItem37);

        jMenuLibrary.add(jMenu1);

        jMenu3.setText("Games");
        jMenuLibrary.add(jMenu3);

        jMenu4.setText("Programming");

        jMenuItem24.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/gui/Adobe_PDF_file_icon_24x24.png"))); // NOI18N
        jMenuItem24.setText("Vectrex Programmers Manual Vol 1");
        jMenuItem24.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem24ActionPerformed(evt);
            }
        });
        jMenu4.add(jMenuItem24);

        jMenuItem25.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/gui/Adobe_PDF_file_icon_24x24.png"))); // NOI18N
        jMenuItem25.setText("Vectrex Programmers Manual Vol 2");
        jMenuItem25.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem25ActionPerformed(evt);
            }
        });
        jMenu4.add(jMenuItem25);

        jMenuItem26.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/gui/Adobe_PDF_file_icon_24x24.png"))); // NOI18N
        jMenuItem26.setText("Vectrex BIOS Original");
        jMenuItem26.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem26ActionPerformed(evt);
            }
        });
        jMenu4.add(jMenuItem26);

        jMenuItem27.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/text_dropcaps.png"))); // NOI18N
        jMenuItem27.setText("Tutorial - Christopher Tumber");
        jMenuItem27.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem27ActionPerformed(evt);
            }
        });
        jMenu4.add(jMenuItem27);

        jMenuItem34.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/gui/Adobe_PDF_file_icon_24x24.png"))); // NOI18N
        jMenuItem34.setText("Bios (Tomlin)");
        jMenuItem34.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem34ActionPerformed(evt);
            }
        });
        jMenu4.add(jMenuItem34);

        jMenuItem35.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/html.png"))); // NOI18N
        jMenuItem35.setText("Tutorial Malban");
        jMenuItem35.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem35ActionPerformed(evt);
            }
        });
        jMenu4.add(jMenuItem35);

        jMenuLibrary.add(jMenu4);

        jMenu5.setText("Repair");

        jMenuItem28.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/html.png"))); // NOI18N
        jMenuItem28.setText("Service Manual");
        jMenuItem28.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem28ActionPerformed(evt);
            }
        });
        jMenu5.add(jMenuItem28);

        jMenuItem29.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/gui/Adobe_PDF_file_icon_24x24.png"))); // NOI18N
        jMenuItem29.setText("Vectrex Troubleshooting guide");
        jMenuItem29.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem29ActionPerformed(evt);
            }
        });
        jMenu5.add(jMenuItem29);

        jMenuItem36.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/gui/Adobe_PDF_file_icon_24x24.png"))); // NOI18N
        jMenuItem36.setText("Service Manual");
        jMenuItem36.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem36ActionPerformed(evt);
            }
        });
        jMenu5.add(jMenuItem36);

        jMenuLibrary.add(jMenu5);

        jMenu6.setText("Miscellaneous");

        jMenuItem30.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/gui/Adobe_PDF_file_icon_24x24.png"))); // NOI18N
        jMenuItem30.setText("Patent Vectrex Housing");
        jMenuItem30.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem30ActionPerformed(evt);
            }
        });
        jMenu6.add(jMenuItem30);

        jMenuItem31.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/gui/Adobe_PDF_file_icon_24x24.png"))); // NOI18N
        jMenuItem31.setText("Patent Cartridge");
        jMenuItem31.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem31ActionPerformed(evt);
            }
        });
        jMenu6.add(jMenuItem31);

        jMenuItem32.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/gui/Adobe_PDF_file_icon_24x24.png"))); // NOI18N
        jMenuItem32.setText("Patent Self contained arcade");
        jMenuItem32.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem32ActionPerformed(evt);
            }
        });
        jMenu6.add(jMenuItem32);

        jMenuItem33.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/gui/Adobe_PDF_file_icon_24x24.png"))); // NOI18N
        jMenuItem33.setText("Patent Circuitry CRT beam");
        jMenuItem33.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem33ActionPerformed(evt);
            }
        });
        jMenu6.add(jMenuItem33);

        jMenuLibrary.add(jMenu6);

        menuBar.add(jMenuLibrary);

        windowMenu.setForeground(Color.black);
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

        helpMenu.setForeground(Color.black);
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
        // NOTHING SAVED!
        System.exit(0);
        
    }//GEN-LAST:event_exitMenuItemActionPerformed

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
      
        VeccyPanel p = new VeccyPanel();
        addPanel(p);
        setMainPanel(p);
        CSAInternalFrame frame = windowMe(p, 800, 600, VeccyPanel.SID);
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
        addPanel(p);
        setMainPanel(p);
    }//GEN-LAST:event_jMenuItem15ActionPerformed

    private void jMenuItemDissyActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemDissyActionPerformed
        DissiFullPanel p = new DissiFullPanel();        
        addPanel(p);
        setMainPanel(p);
        CSAInternalFrame frame = windowMe(p, 800, 600, DissiFullPanel.SID);
    }//GEN-LAST:event_jMenuItemDissyActionPerformed

    private void jMenuItemAssiActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemAssiActionPerformed
        AssyPanel p = new AssyPanel();
        addPanel(p);
        setMainPanel(p);
    }//GEN-LAST:event_jMenuItemAssiActionPerformed

    private void jMenuItemVecxiActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemVecxiActionPerformed
      
        VecXPanel p = new VecXPanel();
        addPanel(p);
        setMainPanel(p);
        CSAInternalFrame frame = windowMe(p, 800, 600, VecXPanel.SID);
    }//GEN-LAST:event_jMenuItemVecxiActionPerformed

    private void formWindowClosing(java.awt.event.WindowEvent evt) {//GEN-FIRST:event_formWindowClosing
        saveStateAll();
    }//GEN-LAST:event_formWindowClosing

    private void jMenuItemVediActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemVediActionPerformed
        getVedi();
    }//GEN-LAST:event_jMenuItemVediActionPerformed

    private void jMenuItemConfigActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemConfigActionPerformed
        ConfigJPanel configi = new ConfigJPanel();
        CSAMainFrame frame = ((CSAMainFrame)Configuration.getConfiguration().getMainFrame());
        frame.addPanel(configi);
        frame.setMainPanel(configi);
        frame.windowMe(configi, 331, 514, ConfigJPanel.SID);
    }//GEN-LAST:event_jMenuItemConfigActionPerformed

    private void jMenuItem3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem3ActionPerformed
        CompareDissiPanel cd = new CompareDissiPanel();
        CSAMainFrame frame = ((CSAMainFrame)Configuration.getConfiguration().getMainFrame());
        frame.addPanel(cd);
        frame.setMainPanel(cd);
        frame.windowMe(cd, 331, 514, CompareDissiPanel.SID);
    }//GEN-LAST:event_jMenuItem3ActionPerformed

    private void jMenuItem4ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem4ActionPerformed

     Configuration C = Configuration.getConfiguration();
        FileUtil ac = new FileUtil();
        ModalInternalFrame modal = new ModalInternalFrame("FileUtil", C.getMainFrame().getRootPane(), C.getMainFrame(), ac, ac.getExitButton());
        ac.setDialog(modal);
        modal.setVisible(true);
    }//GEN-LAST:event_jMenuItem4ActionPerformed

    private void jMenuItem5ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem5ActionPerformed
        de.malban.util.XMLClassBuilder builder= new de.malban.util.XMLClassBuilder();
        builder.setVisible(true);
    }//GEN-LAST:event_jMenuItem5ActionPerformed

    private void jMenuItemCodiActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemCodiActionPerformed
        getCodi();
    }//GEN-LAST:event_jMenuItemCodiActionPerformed

    private void jMenuItem6ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem6ActionPerformed
        invokeSystemFile(new File("documents"+File.separator+"hardware"+File.separator+"original"+File.separator+"m6809pm.rev0.pdf"));
    }//GEN-LAST:event_jMenuItem6ActionPerformed

    private void jMenuItem7ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem7ActionPerformed
        invokeSystemFile(new File("documents"+File.separator+"hardware"+File.separator+"original"+File.separator+"6522AP.pdf"));
    }//GEN-LAST:event_jMenuItem7ActionPerformed

    private void jMenuItem8ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem8ActionPerformed
        invokeSystemFile(new File("documents"+File.separator+"hardware"+File.separator+"original"+File.separator+"6809.pdf"));
    }//GEN-LAST:event_jMenuItem8ActionPerformed

    private void jMenuItem9ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem9ActionPerformed
        invokeSystemFile(new File("documents"+File.separator+"hardware"+File.separator+"original"+File.separator+"AY_3_8913.pdf"));
    }//GEN-LAST:event_jMenuItem9ActionPerformed

    private void jMenuItem10ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem10ActionPerformed
        invokeSystemFile(new File("documents"+File.separator+"hardware"+File.separator+"original"+File.separator+"2151.PDF"));
    }//GEN-LAST:event_jMenuItem10ActionPerformed

    private void jMenuItem11ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem11ActionPerformed
        invokeSystemFile(new File("documents"+File.separator+"hardware"+File.separator+"original"+File.separator+"2153.PDF"));
    }//GEN-LAST:event_jMenuItem11ActionPerformed

    private void jMenuItem13ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem13ActionPerformed
        invokeSystemFile(new File("documents"+File.separator+"hardware"+File.separator+"original"+File.separator+"SN74LS32N.pdf"));
    }//GEN-LAST:event_jMenuItem13ActionPerformed

    private void jMenuItem14ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem14ActionPerformed
        invokeSystemFile(new File("documents"+File.separator+"hardware"+File.separator+"original"+File.separator+"SN54LS00.pdf"));
    }//GEN-LAST:event_jMenuItem14ActionPerformed

    private void jMenuItem17ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem17ActionPerformed
        invokeSystemFile(new File("documents"+File.separator+"hardware"+File.separator+"original"+File.separator+"MC34004P.pdf"));
    }//GEN-LAST:event_jMenuItem17ActionPerformed

    private void jMenuItem18ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem18ActionPerformed
        invokeSystemFile(new File("documents"+File.separator+"hardware"+File.separator+"original"+File.separator+"MC1408P8.pdf"));
    }//GEN-LAST:event_jMenuItem18ActionPerformed

    private void jMenuItem19ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem19ActionPerformed
        invokeSystemFile(new File("documents"+File.separator+"hardware"+File.separator+"original"+File.separator+"LF353.pdf"));
    }//GEN-LAST:event_jMenuItem19ActionPerformed

    private void jMenuItem20ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem20ActionPerformed
        invokeSystemFile(new File("documents"+File.separator+"hardware"+File.separator+"original"+File.separator+"4066.pdf"));
    }//GEN-LAST:event_jMenuItem20ActionPerformed

    private void jMenuItem21ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem21ActionPerformed
        invokeSystemFile(new File("documents"+File.separator+"hardware"+File.separator+"original"+File.separator+"4052B.pdf"));
    }//GEN-LAST:event_jMenuItem21ActionPerformed

    private void jMenuItem22ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem22ActionPerformed
        invokeSystemFile(new File("documents"+File.separator+"hardware"+File.separator+"original"+File.separator+"2114 RAM.pdf"));
    }//GEN-LAST:event_jMenuItem22ActionPerformed

    private void jMenuItem23ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem23ActionPerformed
        invokeSystemFile(new File("documents"+File.separator+"hardware"+File.separator+"LectureCPU"+File.separator+"MICROS.HTM"));
    }//GEN-LAST:event_jMenuItem23ActionPerformed

    private void jMenuItem24ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem24ActionPerformed
        invokeSystemFile(new File("documents"+File.separator+"programming"+File.separator+"VectrexVol1.pdf"));
    }//GEN-LAST:event_jMenuItem24ActionPerformed

    private void jMenuItem25ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem25ActionPerformed
        invokeSystemFile(new File("documents"+File.separator+"programming"+File.separator+"VectrexVol2.pdf"));
    }//GEN-LAST:event_jMenuItem25ActionPerformed

    private void jMenuItem26ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem26ActionPerformed
        invokeSystemFile(new File("documents"+File.separator+"programming"+File.separator+"exec.pdf"));
    }//GEN-LAST:event_jMenuItem26ActionPerformed

    private void jMenuItem27ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem27ActionPerformed
        invokeSystemFile(new File("documents"+File.separator+"programming"+File.separator+"TUTORIAL.TXT"));
    }//GEN-LAST:event_jMenuItem27ActionPerformed

    private void jMenuItem28ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem28ActionPerformed
        invokeSystemFile(new File("documents"+File.separator+"repair"+File.separator+"ServiceManual"+File.separator+"SERVICE.HTM"));
    }//GEN-LAST:event_jMenuItem28ActionPerformed

    private void jMenuItem29ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem29ActionPerformed
        invokeSystemFile(new File("documents"+File.separator+"repair"+File.separator+"vecguid.pdf"));
    }//GEN-LAST:event_jMenuItem29ActionPerformed

    private void jMenuItem30ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem30ActionPerformed
        invokeSystemFile(new File("documents"+File.separator+"miscellaneous"+File.separator+"Patent - Video arcade game and display housing.pdf"));
    }//GEN-LAST:event_jMenuItem30ActionPerformed

    private void jMenuItem31ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem31ActionPerformed
        invokeSystemFile(new File("documents"+File.separator+"miscellaneous"+File.separator+"Patent - Video Game Cartridge recognition and security system.pdf"));
    }//GEN-LAST:event_jMenuItem31ActionPerformed

    private void jMenuItem32ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem32ActionPerformed
        invokeSystemFile(new File("documents"+File.separator+"miscellaneous"+File.separator+"Patent - Self contained arcade game apparatus for object generation.pdf"));
    }//GEN-LAST:event_jMenuItem32ActionPerformed

    private void jMenuItem33ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem33ActionPerformed
        invokeSystemFile(new File("documents"+File.separator+"miscellaneous"+File.separator+"Patent - Circuitry for controlling a CRT beam.pdf"));
    }//GEN-LAST:event_jMenuItem33ActionPerformed

    private void jMenuItem34ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem34ActionPerformed
        invokeSystemFile(new File("documents"+File.separator+"programming"+File.separator+"BIOS.ASM.pdf"));
    }//GEN-LAST:event_jMenuItem34ActionPerformed

    private void jMenuItem35ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem35ActionPerformed
        invokeSystemFile(new File("documents"+File.separator+"programming"+File.separator+"secondvectrex"+File.separator+"toc.htm"));
    }//GEN-LAST:event_jMenuItem35ActionPerformed

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
                    addPanel(wap);
                    setMainPanel(wap);
                    windowMe(wap, 950, 650, "Help");
                }

            }

        }    }//GEN-LAST:event_jMenuItemHelpActionPerformed

    private void jMenuItem36ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem36ActionPerformed
        invokeSystemFile(new File("documents"+File.separator+"repair"+File.separator+"vecman.pdf"));
    }//GEN-LAST:event_jMenuItem36ActionPerformed

    private void jMenuItemStarterActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemStarterActionPerformed
        getStarter();
    }//GEN-LAST:event_jMenuItemStarterActionPerformed

    private void jMenuItemCartridgeEditActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemCartridgeEditActionPerformed
        
        CartridgePropertiesPanel cd = new CartridgePropertiesPanel();
        CSAMainFrame frame = ((CSAMainFrame)Configuration.getConfiguration().getMainFrame());
        frame.addPanel(cd);
        frame.setMainPanel(cd);
        frame.windowMe(cd, 331, 514, CartridgePropertiesPanel.SID);
        
        
    }//GEN-LAST:event_jMenuItemCartridgeEditActionPerformed

    private void jMenuItemDebugActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemDebugActionPerformed
        if (Configuration.getConfiguration().isDebugOff()) return;
        if (!(Configuration.getConfiguration().getDebugEntity() instanceof de.malban.gui.panels.LogPanel)) return;
        LogPanel c = (LogPanel) Configuration.getConfiguration().getDebugEntity();
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
        mDebugDisplayed = true;
    }//GEN-LAST:event_jMenuItemDebugActionPerformed

    private void jMenuItem1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem1ActionPerformed
        ConfigurationPanel c = new ConfigurationPanel();
        addPanel(c);
        setMainPanel(c);
        windowMe(c,1018,680, "Configuration");
    }//GEN-LAST:event_jMenuItem1ActionPerformed

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
    private javax.swing.JMenu jMenu1;
    private javax.swing.JMenu jMenu2;
    private javax.swing.JMenu jMenu3;
    private javax.swing.JMenu jMenu4;
    private javax.swing.JMenu jMenu5;
    private javax.swing.JMenu jMenu6;
    private javax.swing.JMenu jMenu7;
    private javax.swing.JMenuItem jMenuItem1;
    private javax.swing.JMenuItem jMenuItem10;
    private javax.swing.JMenuItem jMenuItem11;
    private javax.swing.JMenuItem jMenuItem12;
    private javax.swing.JMenuItem jMenuItem13;
    private javax.swing.JMenuItem jMenuItem14;
    private javax.swing.JMenuItem jMenuItem15;
    private javax.swing.JMenuItem jMenuItem16;
    private javax.swing.JMenuItem jMenuItem17;
    private javax.swing.JMenuItem jMenuItem18;
    private javax.swing.JMenuItem jMenuItem19;
    private javax.swing.JMenuItem jMenuItem20;
    private javax.swing.JMenuItem jMenuItem21;
    private javax.swing.JMenuItem jMenuItem22;
    private javax.swing.JMenuItem jMenuItem23;
    private javax.swing.JMenuItem jMenuItem24;
    private javax.swing.JMenuItem jMenuItem25;
    private javax.swing.JMenuItem jMenuItem26;
    private javax.swing.JMenuItem jMenuItem27;
    private javax.swing.JMenuItem jMenuItem28;
    private javax.swing.JMenuItem jMenuItem29;
    private javax.swing.JMenuItem jMenuItem3;
    private javax.swing.JMenuItem jMenuItem30;
    private javax.swing.JMenuItem jMenuItem31;
    private javax.swing.JMenuItem jMenuItem32;
    private javax.swing.JMenuItem jMenuItem33;
    private javax.swing.JMenuItem jMenuItem34;
    private javax.swing.JMenuItem jMenuItem35;
    private javax.swing.JMenuItem jMenuItem36;
    private javax.swing.JMenuItem jMenuItem37;
    private javax.swing.JMenuItem jMenuItem4;
    private javax.swing.JMenuItem jMenuItem5;
    private javax.swing.JMenuItem jMenuItem6;
    private javax.swing.JMenuItem jMenuItem7;
    private javax.swing.JMenuItem jMenuItem8;
    private javax.swing.JMenuItem jMenuItem9;
    private javax.swing.JMenuItem jMenuItemAssi;
    private javax.swing.JMenuItem jMenuItemCartridgeEdit;
    private javax.swing.JMenuItem jMenuItemCloseWin;
    private javax.swing.JMenuItem jMenuItemCodi;
    private javax.swing.JMenuItem jMenuItemConfig;
    private javax.swing.JMenuItem jMenuItemDebug;
    private javax.swing.JMenuItem jMenuItemDissy;
    private javax.swing.JMenuItem jMenuItemHelp;
    private javax.swing.JMenuItem jMenuItemStarter;
    private javax.swing.JMenuItem jMenuItemVeccy;
    private javax.swing.JMenuItem jMenuItemVecxi;
    private javax.swing.JMenuItem jMenuItemVedi;
    private javax.swing.JMenu jMenuLibrary;
    private javax.swing.JPopupMenu.Separator jSeparator1;
    private javax.swing.JPopupMenu.Separator jSeparator2;
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
        frame.setFrameIcon( new ImageIcon(t.getImage(("RedIconSmall.png"))));

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

    public void addPanel(final Windowable p)
    {
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
                    windowMe((Windowable)p, 100, 100, p.getMenuItem().getName());
                }
                else
                {
                    setMainPanel(p.getPanel());
                    mCurrentPanel = p.getPanel();
                }
            }
        });
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
        
        
        for(JInternalFrame frame: mFrames)
        {
            CSAInternalFrame f = (CSAInternalFrame)frame;
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
       
        
        
        
        JMenuItem item = p.getMenuItem();
        if (item!=null)
            windowMenu.remove(item);
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


    private void toFullscreen()
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
        
        //needed for tinyLAF - see also MAIN start for Mac
        //JFrame.setDefaultLookAndFeelDecorated(false);	// to decorate frames
        //JDialog.setDefaultLookAndFeelDecorated(false);	// to decorate dialogs 
        //Toolkit.getDefaultToolkit().setDynamicLayout(false);
        //System.setProperty("sun.awt.noerasebackground", "false");
        //JFrame.setDefaultLookAndFeelDecorated(false);
        
        SwingUtilities.updateComponentTreeUI(getFrame());

        //make the window fullscreen.
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
        {
            createPopup();

        }
        else
        {
            createMacPopup();

        }

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

  
    private void toWindowed()
    {
        if (!fullscreen) return;
        fullscreen = false;
        Configuration.getConfiguration().mIsFullscreen = false;
/*
        UIDefaults uiDefaults = UIManager.getDefaults();
        Set entries = windowedDefaults.entrySet();
        Iterator it = entries.iterator();
        while (it.hasNext())
        {
            java.util.Map.Entry entry = (java.util.Map.Entry) it.next();
            UIResource value = (UIResource) entry.getValue();
            String key = (String)entry.getKey();
            uiDefaults.put(key, value);
        }
        SwingUtilities.updateComponentTreeUI(  org.jdesktop.application.Application.getInstance(de.malban.jportal.JPortalApp.class).getMainFrame() );
*/
        menuBar.setVisible(true);
        java.awt.Toolkit.getDefaultToolkit().removeAWTEventListener(this);
        getFrame().getJMenuBar().setVisible(true);
        //statusPanel.setVisible(true);
        //set the display mode back to the what it was when
        //the program was launched.
        device.setDisplayMode(dispModeOld);

        //hide the frame so we can change it.
        getFrame().setVisible(false);

        //remove the frame from being displayable.
        getFrame().dispose();

        //put the borders back on the frame.
        getFrame().setUndecorated(false);
        
        //needed for tinyLAF - see also MAIN start for Mac
        //JFrame.setDefaultLookAndFeelDecorated(true);	// to decorate frames
        //JDialog.setDefaultLookAndFeelDecorated(true);	// to decorate dialogs        
        //SwingUtilities.updateComponentTreeUI(getFrame());
        //Toolkit.getDefaultToolkit().setDynamicLayout(true);
        //System.setProperty("sun.awt.noerasebackground", "true");
        //JFrame.setDefaultLookAndFeelDecorated(true);
		        

        //needed to unset this window as the fullscreen window.
        device.setFullScreenWindow(null);

        //make sure the size of the window is correct.
        // getFrame().setSize(800,600);
        setMySize();

        //recenter window
        getFrame().setLocationRelativeTo(null);

        //reset the display mode to what it was before
        //we changed it.
        getFrame().setVisible(true);
        // if not 2 buffers switching back to windowed mode
        // results (at least with me) in Exceptions
        getFrame().createBufferStrategy(2); // 2 buffers
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

    public void desktopMe(CSAInternalFrame f)
    {
        JPanel p = f.getPanel();
        ((JPanel)p).setVisible(false);
        f.setVisible(false);
        try
        {
            f.setClosed(true);
        }
        catch (Throwable e){}
        removeInternalFrame(f);
        addPanel((Windowable) p);
        ((JPanel)p).setVisible(true);
        setMainPanel(p);
    }

    public CSAInternalFrame windowMe(Windowable p, int w, int h, String title)
    {
        ((JPanel)p).setVisible(false);
        removePanel(p, false);
        CSAInternalFrame frame = new CSAInternalFrame();
        frame.addPanel((JPanel)p);
        frame.setSize(w, h);

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
        addPanel(p);
        if (now)
            windowMe(p, 800, 800, p.getMenuItem().getName());
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
        if (mCurrentPanel != null)
            setMainPanel(mCurrentPanel);
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

    public void setMainPanelOld(javax.swing.JPanel panel)
    {
        panel.setVisible(false);
        mDesktop.setVisible(false);
        
        for (int i = 0;i<mDesktop.getComponentCount();i++)
        {
            mDesktop.getComponent(i).setVisible(false);
        }
        
        
        mDesktop.removeAll();
        for (int i=0; i <  mFrames.size(); i++)
        {
            JInternalFrame f = mFrames.elementAt(i);
            getMainPanel().add(f);
            f.setVisible(true);
            getMainPanel().setComponentZOrder(f, 0);
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

    
    void testFirstTime()
    {
        Configuration C = Configuration.getConfiguration();
        /*
        if (C.isFirstTime())
        {
            StarterKit c = new StarterKit();
            c.setParentWindow(this);
            titlePanel1.add(c);
            titlePanel1.setComponentZOrder(c, 0);
            c.setBounds(100, 100, 500, 400);
        }
        else
        */
        if (C.isShowTOD())
        {
            TipOfDayGUI c = new TipOfDayGUI();
            c.setParentWindow(this);
//            titlePanel1.add(c);
  //          titlePanel1.setComponentZOrder(c, 0);
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

        final JInternalFrame modal = new ModalInternalFrame(name, getFrame().getRootPane(), getFrame(), all, close);

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
            Configuration.getConfiguration().getDebugEntity().addLog(e, ERROR);
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
        addPanel(p);
        setMainPanel((javax.swing.JPanel)p);
        CSAInternalFrame frame = windowMe(p, 600, 300, DissiPanel.SID);
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
        addPanel(p);
        setMainPanel((javax.swing.JPanel)p);
        CSAInternalFrame frame = windowMe(p, 600, 300, VecXPanel.SID);
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
        addPanel(p);
        setMainPanel((javax.swing.JPanel)p);
        CSAInternalFrame frame = windowMe(p, 94, 320, RegisterJPanel.SID);
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
        addPanel(p);
        setMainPanel((javax.swing.JPanel)p);
        CSAInternalFrame frame = windowMe(p, 94, 320, VectorInfoJPanel.SID);
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
        addPanel(p);
        setMainPanel((javax.swing.JPanel)p);
        CSAInternalFrame frame = windowMe(p, 94, 320, MemoryDumpPanel.SID);
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
        addPanel(p);
        setMainPanel((javax.swing.JPanel)p);
        CSAInternalFrame frame = windowMe(p, 600, 300, VIAJPanel.SID);
        return p;
    }
    
    // returns the "first" found vecxy panel or creates a new one!
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
        addPanel(p);
        setMainPanel((javax.swing.JPanel)p);
        CSAInternalFrame frame = windowMe(p, 600, 600, VediPanel.SID);
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
        addPanel(p);
        setMainPanel((javax.swing.JPanel)p);
        CSAInternalFrame frame = windowMe(p, 300, 200, AnalogJPanel.SID);
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
        addPanel(p);
        setMainPanel((javax.swing.JPanel)p);
        CSAInternalFrame frame = windowMe(p, 300, 200, VarJPanel.SID);
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
        addPanel(p);
        setMainPanel((javax.swing.JPanel)p);
        CSAInternalFrame frame = windowMe(p, 460, 200, BreakpointJPanel.SID);
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
        addPanel(p);
        setMainPanel((javax.swing.JPanel)p);
        CSAInternalFrame frame = windowMe(p, 300, 200, LabelJPanel.SID);
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
        addPanel(p);
        setMainPanel((javax.swing.JPanel)p);
        CSAInternalFrame frame = windowMe(p, 300, 200, PSGJPanel.SID);
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
        addPanel(p);
        setMainPanel((javax.swing.JPanel)p);
        CSAInternalFrame frame = windowMe(p, 300, 200, CodeLibraryPanel.SID);
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
        addPanel(p);
        setMainPanel((javax.swing.JPanel)p);
        CSAInternalFrame frame = windowMe(p, 300, 200, WRTrackerJPanel.SID);
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
        addPanel(p);
        setMainPanel((javax.swing.JPanel)p);
        CSAInternalFrame frame = windowMe(p, 300, 200, StarterJPanel.SID);
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
        addPanel(p);
        setMainPanel((javax.swing.JPanel)p);
        CSAInternalFrame frame = windowMe(p, 1024, 768, VeccyPanel.SID);
        return p;
    }
    
        
    
    public CSAInternalFrame getInternalFrame(Windowable p)   
    {
        CSAInternalFrame ret = null;
        
        for(JInternalFrame frame: mFrames)
        {
            CSAInternalFrame f = (CSAInternalFrame)frame;
            if (f.getPanel().equals((JPanel)p)) 
            {
                return f;
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
        

        try
        {
            CSAMainFrame.serialize(s, "serialize"+File.separator+p.getID()+"Window.ser");
            Serializable ser =  p.getAdditionalStateinfo();
            if (ser != null)
                CSAMainFrame.serialize(ser, "serialize"+File.separator+p.getID()+"Add"+"Window.ser");
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
                s = (SaveItem) deserialize("serialize"+File.separator+p.getID()+"Window.ser");

                if (s == null) return false;
                if (frame == null) return false;
                frame.setBounds(s.x, s.y, s.w, s.h);
                
                Serializable ser =  (Serializable) CSAMainFrame.deserialize("serialize"+File.separator+p.getID()+"Add"+"Window.ser");
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
        for(JInternalFrame frame: mFrames)
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
            CSAMainFrame.serialize(s, "serialize"+File.separator+"MainWindow.ser");
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
            s = (SaveItem) deserialize("serialize"+File.separator+"MainWindow.ser");
            if (s==null) return false;
            setBounds(s.x, s.y, s.w, s.h);
            
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

    
}
