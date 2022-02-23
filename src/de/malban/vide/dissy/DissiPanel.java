/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templatesƒ
 * and open the template in the editor.
 */
package de.malban.vide.dissy;

import de.malban.Global;
import de.malban.config.Configuration;
import de.malban.gui.CSAMainFrame;
import de.malban.gui.HotKey;
import de.malban.gui.Stateable;
import de.malban.gui.Windowable;
import de.malban.gui.components.CSAView;
import de.malban.gui.panels.LogPanel;
import static de.malban.gui.panels.LogPanel.INFO;
import static de.malban.gui.panels.LogPanel.WARN;
import de.malban.jogl.JOGLSupport;
import de.malban.util.syntax.Syntax.TokenStyles;
import de.malban.vide.VideConfig;
import static de.malban.vide.dissy.DASM6809.printbinary;
import de.malban.vide.dissy.DissiPanel.DissiSwitchData.WatchTableModel;
import static de.malban.vide.dissy.MemoryInformation.DIS_TYPE_DATA_BYTE;
import de.malban.vide.vedi.VediPanel;
import static de.malban.vide.dissy.MemoryInformation.DIS_TYPE_DATA_INSTRUCTION_1_LENGTH;
import static de.malban.vide.dissy.MemoryInformation.DIS_TYPE_DATA_INSTRUCTION_2_LENGTH;
import static de.malban.vide.dissy.MemoryInformation.DIS_TYPE_DATA_INSTRUCTION_3_LENGTH;
import static de.malban.vide.dissy.MemoryInformation.DIS_TYPE_DATA_INSTRUCTION_4_LENGTH;
import static de.malban.vide.dissy.MemoryInformation.DIS_TYPE_DATA_INSTRUCTION_5_LENGTH;
import static de.malban.vide.dissy.MemoryInformation.DIS_TYPE_DATA_INSTRUCTION_GENERAL;
import static de.malban.vide.dissy.MemoryInformation.DIS_TYPE_DATA_WORD;
import static de.malban.vide.dissy.MemoryInformation.DIS_TYPE_DATA_WORD_POINTER;
import static de.malban.vide.dissy.MemoryInformation.DIS_TYPE_UNKOWN;
import static de.malban.vide.dissy.MemoryInformation.MEM_TYPE_RAM;
import static de.malban.vide.dissy.MemoryInformation.MEM_TYPE_ROM;
import de.malban.vide.vecx.Breakpoint;
import de.malban.vide.vecx.cartridge.Cartridge;
import de.malban.vide.vecx.cartridge.CartridgeListener;
import de.malban.vide.vecx.CodeScanMemory;
import de.malban.vide.vecx.E6809;
import de.malban.vide.vecx.Profiler;
import de.malban.vide.vecx.Updatable;
import static de.malban.vide.vecx.VecXStatics.EMU_EXIT_BREAKPOINT_BREAK;
import static de.malban.vide.vecx.VecXStatics.EMU_EXIT_BREAKPOINT_CONTINUE;
import de.malban.vide.vecx.VecXPanel;
import de.malban.vide.vecx.cartridge.CartridgeEvent;
import de.malban.vide.vecx.panels.MemoryDumpPanel;
import de.muntjak.tinylookandfeel.Theme;
import java.awt.Color;
import java.awt.Component;
import java.awt.Point;
import java.awt.Rectangle;
import java.awt.event.ActionEvent;
import static java.awt.event.ActionEvent.ALT_MASK;
import static java.awt.event.ActionEvent.CTRL_MASK;
import static java.awt.event.ActionEvent.SHIFT_MASK;
import java.awt.event.KeyEvent;
import java.awt.event.MouseEvent;
import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;
import java.io.File;
import java.io.PrintWriter;
import java.io.Serializable;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import javax.swing.AbstractAction;
import javax.swing.JTable;
import static javax.swing.JTable.AUTO_RESIZE_LAST_COLUMN;
import static javax.swing.JTable.AUTO_RESIZE_SUBSEQUENT_COLUMNS;
import javax.swing.JTextField;
import javax.swing.JViewport;
import javax.swing.KeyStroke;
import javax.swing.SwingUtilities;
import javax.swing.UIManager;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ListSelectionEvent;
import javax.swing.event.TableColumnModelEvent;
import javax.swing.event.TableColumnModelListener;
import javax.swing.event.TableModelEvent;
import javax.swing.event.TableModelListener;
import javax.swing.table.AbstractTableModel;
import javax.swing.table.DefaultTableCellRenderer;
import javax.swing.table.TableCellEditor;
import javax.swing.table.TableColumn;

/**
 *
 * @author malban
 */
public class DissiPanel extends javax.swing.JPanel  implements
        Windowable, Stateable, Updatable, CartridgeListener{
    private static int UID_BASE = 0;
    private int current_uid;
    public int getUID()
    {
        return current_uid;
    }
////
    public static boolean doNotFollow = false;
    public class DissiSwitchData
    {
        String loadedName = "";
        boolean doDisRAM = false;
        boolean init = false;
        VecXPanel vecxPanel = null; // needed for vectrex memory access
        boolean keyEventsAreSet = false;
        private boolean updateEnabled = false;
        boolean bankswitchInfo = false;
        boolean quiet = false;
        MemoryInformationTableModel model=null;
        DASM6809 dasm = new DASM6809();
        ArrayList<Integer> rowStack = new ArrayList<Integer>();
        int rowStackPosition = -1;
        ArrayList <Watch> watchlist = new ArrayList <Watch>();

        // remember last jumped to addresses
        ArrayList<String> commandHistory = new ArrayList<String>();
        int commandHistoryPosition = -1;
        public final int uid = UID_BASE++;
        public void removeWatchByAddress(int address)
        {
            int size;
            do 
            {
                size = watchlist.size();
                for (Watch w: watchlist)
                {
                    if (w.startaddress == address)
                    {
                        watchlist.remove(w);
                        break;
                    }
                }
            } while (size != watchlist.size());
        }
        public void removeWatchbyIndex(int index)
        {
            if (index < watchlist.size())
                watchlist.remove(index);
        }
        WatchTableModel watchModel = new WatchTableModel();
        public class WatchTableModel extends AbstractTableModel
        {
            public int getRowCount()
            {
                return watchlist.size();
            }
            public int getColumnCount()
            {
                return 3;
            }
            public Object getValueAt(int row, int col)
            {
                Watch w = watchlist.get(row);
                if (col == 0) return "$"+String.format("%04X",w.startaddress);
                if (col == 1)
                {
                    if (vecxPanel == null) return "";
                    MemoryInformation memInfo = getMemoryInformation(w.startaddress, vecxPanel.getCurrentBank());
                    String ret = "";
                    for (int i = 0; i< memInfo.labels.size(); i++)
                    {
                        if (i>0) ret+=", ";
                        ret += memInfo.labels.get(i);
                    }      
                    return ret;
                }
                if (col == 2) return w.toString();

                return "";
            }
            public String getColumnName(int column) {
                if (column == 0) return "address";
                if (column == 1) return "labels";
                return "value";
            }
            public Class<?> getColumnClass(int columnIndex) {
                return String.class;
            }
            public boolean isCellEditable(int rowIndex, int columnIndex) {
                return false;
            }
            public int getColWidth(int col)
            {
                if (col == 0) return 10;
                if (col == 1) return 50;
                return 200;
            }
            
            
//            public Color getBackground(int col)
//            {
//                if (col == 0) return new Color(200,255,200,255);
//                return null; // default
//            }

        }
    }
    
    
    DissiSwitchData currentDissi = new DissiSwitchData();
    public DissiSwitchData getData() {return currentDissi;}
    
    LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
    public boolean isLoadSettings() { return true; }

    public static final String MESSAGE_INFO = "editLogMessage";
    public static final String MESSAGE_WARN = "editLogWarning";
    public static final String MESSAGE_ERR = "error";
    VideConfig config = VideConfig.getConfig();
    
    
    // output "Tabs" for source generation
    int TAB_EQU = 30;
    int TAB_EQU_VALUE = 40;
    int TAB_MNEMONIC = 20;
    int TAB_OP = 30;
    int TAB_COMMENT = 50;
    
    
    private CSAView mParent = null;
    private javax.swing.JMenuItem mParentMenuItem = null;
    private int mClassSetting=0;
    
    ArrayList<TableColumn> allColumns = null;
    // for config changed listeners
    public static ArrayList<DissiPanel> panels = new ArrayList<DissiPanel>();
    public static String SID = "Debugger";
    public String getID()
    {
        return SID;
    }
    public void setVecxy(VecXPanel v)
    {
        if (currentDissi == null) return;
        currentDissi.vecxPanel = v;
        if (currentDissi.vecxPanel!=null)
        {
            jPanelDebug.setVisible(true);
        }
        else
        {
            jPanelDebug.setVisible(false);
        }
    }

    @Override
    public void closing()
    {
        if (currentDissi.vecxPanel != null) currentDissi.vecxPanel.resetDissi();
        deinit();
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
        currentDissi.init = false;
        panels.remove(this);
        removeUIListerner();
    }
    /**
     * Creates new form DissiPanel
     */
    public  DissiPanel() {
        current_uid = currentDissi.uid;
        initComponents();
        jEditorPane1.setEditable(false);
        jEditorPane1.setContentType("text/html");
        initTable();
        jPanelDebug.setVisible(false);
        jLabel3.setVisible(false);
        setupKeyEvents();
        panels.add(this);
        jTable1.setModel(currentDissi.watchModel);
        correctTableWatch();
        
        if (Global.getOSName().toUpperCase().contains("MAC"))
        {
            HotKey.addMacDefaults(jTextFieldCommand);
            HotKey.addMacDefaults(jTextFieldSearch);
            HotKey.addMacDefaults(jTextFieldSearch1);
        }
        
        
        UIManager.addPropertyChangeListener(pListener);
        updateMyUI(); 
        
        jTable2.setTableHeader(null);
        jTable2.setModel(new CallStackTableModel());
        
        jTableStack.setTableHeader(null);
        jTableStack.setModel(new RealStackTableModel());
    }
    void reset()
    {
        deinit();
        if (currentDissi.vecxPanel != null)
        {
            dis(currentDissi.vecxPanel.getCartridge());
        }
        else
        {
            printMessage("Can't reset, haven't got vecxy for cartridge information.", MESSAGE_ERR);
        }
        jTable1.setModel(currentDissi.watchModel);
        panels.add(this);
        correctTableWatch();
    }
    public boolean isQuiet()
    {
        return currentDissi.quiet;
    }
    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jPopupMenu1 = new javax.swing.JPopupMenu();
        jMenuItemCode = new javax.swing.JMenuItem();
        jMenuItemByte = new javax.swing.JMenuItem();
        jMenuItemWord = new javax.swing.JMenuItem();
        jMenuItemWord1 = new javax.swing.JMenuItem();
        jMenuItemChar = new javax.swing.JMenuItem();
        jMenuItemBinary = new javax.swing.JMenuItem();
        jMenuItemUngroup = new javax.swing.JMenuItem();
        jMenuItemJoin = new javax.swing.JMenuItem();
        jMenu1 = new javax.swing.JMenu();
        jMenuItem1 = new javax.swing.JMenuItem();
        jMenuItem2 = new javax.swing.JMenuItem();
        jMenuItem3 = new javax.swing.JMenuItem();
        jMenuItem4 = new javax.swing.JMenuItem();
        jMenuItem5 = new javax.swing.JMenuItem();
        jMenuItem10 = new javax.swing.JMenuItem();
        jMenuItem11 = new javax.swing.JMenuItem();
        jMenuItem12 = new javax.swing.JMenuItem();
        jMenuItem13 = new javax.swing.JMenuItem();
        jMenuItem14 = new javax.swing.JMenuItem();
        jMenuItem15 = new javax.swing.JMenuItem();
        jMenu2 = new javax.swing.JMenu();
        jMenuItem6 = new javax.swing.JMenuItem();
        jMenuItemC9 = new javax.swing.JMenuItem();
        jMenuItem8 = new javax.swing.JMenuItem();
        jMenuItem9 = new javax.swing.JMenuItem();
        jMenuItem7 = new javax.swing.JMenuItem();
        jMenu3 = new javax.swing.JMenu();
        jMenuItemWatchBinary = new javax.swing.JMenuItem();
        jMenuItemWatchByte = new javax.swing.JMenuItem();
        jMenuItemWatchWord = new javax.swing.JMenuItem();
        jMenuItemWatchString = new javax.swing.JMenuItem();
        jMenuItemWatchBytePair = new javax.swing.JMenuItem();
        jMenuItemWatchSequence = new javax.swing.JMenuItem();
        jMenuItemLabelAsData = new javax.swing.JMenuItem();
        jPopupMenu2 = new javax.swing.JPopupMenu();
        jMenuItem16 = new javax.swing.JMenuItem();
        jCheckBox2 = new javax.swing.JCheckBox();
        jCheckBox1 = new javax.swing.JCheckBox();
        jPanelDebug = new javax.swing.JPanel();
        jButtonRinbufferUndo = new javax.swing.JButton();
        jButtonRingbufferRedo = new javax.swing.JButton();
        jButtonMultiStep = new javax.swing.JButton();
        jButtonsetBreakpoint = new javax.swing.JButton();
        jButtonStepOut = new javax.swing.JButton();
        jButtonOverstep = new javax.swing.JButton();
        jButtonDebugStep = new javax.swing.JButton();
        jButtonDebug = new javax.swing.JButton();
        jButtonDump1 = new javax.swing.JButton();
        jButtonViai = new javax.swing.JButton();
        jButtonShowVars = new javax.swing.JButton();
        jButtonWRTracker = new javax.swing.JButton();
        jButtonShowLabels = new javax.swing.JButton();
        jButtonShowPSG = new javax.swing.JButton();
        jButtonShowBreakpoints = new javax.swing.JButton();
        jButtonAdressForward = new javax.swing.JButton();
        jButtonAdressBack = new javax.swing.JButton();
        jToggleButton1 = new javax.swing.JToggleButton();
        jLabel1 = new javax.swing.JLabel();
        jCheckBoxVectorSelect = new javax.swing.JCheckBox();
        jButtonVectrorScreenshot = new javax.swing.JButton();
        jButtonCNTOutput = new javax.swing.JButton();
        jButtonDASMOutput = new javax.swing.JButton();
        jButtonApplyCodeScan = new javax.swing.JButton();
        jButtonRinbufferUndo1 = new javax.swing.JButton();
        jButtonRingbufferRedo1 = new javax.swing.JButton();
        jButtonWRTracker1 = new javax.swing.JButton();
        jPanel1 = new javax.swing.JPanel();
        jButtonSearchNext = new javax.swing.JButton();
        jTextFieldSearch = new javax.swing.JTextField();
        jLabel2 = new javax.swing.JLabel();
        jButtonSearchPrevious = new javax.swing.JButton();
        jLabel3 = new javax.swing.JLabel();
        jTextFieldSearch1 = new javax.swing.JTextField();
        jButtonSearchNext2 = new javax.swing.JButton();
        jLabel4 = new javax.swing.JLabel();
        jSplitPane1 = new javax.swing.JSplitPane();
        jScrollPane2 = new javax.swing.JScrollPane();
        jTableSource = buildTable();
        jPanel3 = new javax.swing.JPanel();
        jScrollPane3 = new javax.swing.JScrollPane();
        jEditorPane1 = new javax.swing.JEditorPane();
        jTextFieldCommand = new javax.swing.JTextField();
        jTabbedPane1 = new javax.swing.JTabbedPane();
        jScrollPane1 = new javax.swing.JScrollPane();
        jTable1 = new javax.swing.JTable();
        jPanel2 = new javax.swing.JPanel();
        jToggleButton3 = new javax.swing.JToggleButton();
        jLabel5 = new javax.swing.JLabel();
        jLabel11 = new javax.swing.JLabel();
        jLabel12 = new javax.swing.JLabel();
        jLabel6 = new javax.swing.JLabel();
        jLabel9 = new javax.swing.JLabel();
        jLabel18 = new javax.swing.JLabel();
        jLabel10 = new javax.swing.JLabel();
        jLabel19 = new javax.swing.JLabel();
        jLabel21 = new javax.swing.JLabel();
        jLabel15 = new javax.swing.JLabel();
        jLabel7 = new javax.swing.JLabel();
        jLabel8 = new javax.swing.JLabel();
        jLabel14 = new javax.swing.JLabel();
        jLabel13 = new javax.swing.JLabel();
        jLabel16 = new javax.swing.JLabel();
        jLabel17 = new javax.swing.JLabel();
        jLabel20 = new javax.swing.JLabel();
        jLabel22 = new javax.swing.JLabel();
        jLabel23 = new javax.swing.JLabel();
        jLabel24 = new javax.swing.JLabel();
        jLabel25 = new javax.swing.JLabel();
        jLabel26 = new javax.swing.JLabel();
        jScrollPane4 = new javax.swing.JScrollPane();
        jTable2 = new javax.swing.JTable();
        jScrollPane5 = new javax.swing.JScrollPane();
        jTableStack = new javax.swing.JTable();
        jCheckBox3 = new javax.swing.JCheckBox();

        jPopupMenu1.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseExited(java.awt.event.MouseEvent evt) {
                jPopupMenu1MouseExited(evt);
            }
        });

        jMenuItemCode.setText("cast to code");
        jMenuItemCode.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemCodeActionPerformed(evt);
            }
        });
        jPopupMenu1.add(jMenuItemCode);

        jMenuItemByte.setText("cast to byte");
        jMenuItemByte.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemByteActionPerformed(evt);
            }
        });
        jPopupMenu1.add(jMenuItemByte);

        jMenuItemWord.setText("cast to word");
        jMenuItemWord.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemWordActionPerformed(evt);
            }
        });
        jPopupMenu1.add(jMenuItemWord);

        jMenuItemWord1.setText("cast to word-pointer");
        jMenuItemWord1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemWord1ActionPerformed(evt);
            }
        });
        jPopupMenu1.add(jMenuItemWord1);

        jMenuItemChar.setText("cast to char");
        jMenuItemChar.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemCharActionPerformed(evt);
            }
        });
        jPopupMenu1.add(jMenuItemChar);

        jMenuItemBinary.setText("cast to binary");
        jMenuItemBinary.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemBinaryActionPerformed(evt);
            }
        });
        jPopupMenu1.add(jMenuItemBinary);

        jMenuItemUngroup.setText("ungroup");
        jMenuItemUngroup.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemUngroupActionPerformed(evt);
            }
        });
        jPopupMenu1.add(jMenuItemUngroup);

        jMenuItemJoin.setText("join (same data types)");
        jMenuItemJoin.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemJoinActionPerformed(evt);
            }
        });
        jPopupMenu1.add(jMenuItemJoin);

        jMenu1.setText("join #");

        jMenuItem1.setText("2");
        jMenuItem1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem1ActionPerformed(evt);
            }
        });
        jMenu1.add(jMenuItem1);

        jMenuItem2.setText("3");
        jMenuItem2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem2ActionPerformed(evt);
            }
        });
        jMenu1.add(jMenuItem2);

        jMenuItem3.setText("4");
        jMenuItem3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem3ActionPerformed(evt);
            }
        });
        jMenu1.add(jMenuItem3);

        jMenuItem4.setText("5");
        jMenuItem4.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem4ActionPerformed(evt);
            }
        });
        jMenu1.add(jMenuItem4);

        jMenuItem5.setText("6");
        jMenuItem5.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem5ActionPerformed(evt);
            }
        });
        jMenu1.add(jMenuItem5);

        jMenuItem10.setText("7");
        jMenuItem10.setToolTipText("");
        jMenuItem10.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem10ActionPerformed(evt);
            }
        });
        jMenu1.add(jMenuItem10);

        jMenuItem11.setText("8");
        jMenuItem11.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem11ActionPerformed(evt);
            }
        });
        jMenu1.add(jMenuItem11);

        jMenuItem12.setText("9");
        jMenuItem12.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem12ActionPerformed(evt);
            }
        });
        jMenu1.add(jMenuItem12);

        jMenuItem13.setText("10");
        jMenuItem13.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem13ActionPerformed(evt);
            }
        });
        jMenu1.add(jMenuItem13);

        jMenuItem14.setText("11");
        jMenuItem14.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem14ActionPerformed(evt);
            }
        });
        jMenu1.add(jMenuItem14);

        jMenuItem15.setText("12");
        jMenuItem15.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem15ActionPerformed(evt);
            }
        });
        jMenu1.add(jMenuItem15);

        jPopupMenu1.add(jMenu1);

        jMenu2.setText("DP");

        jMenuItem6.setText("$C8");
        jMenuItem6.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem6ActionPerformed(evt);
            }
        });
        jMenu2.add(jMenuItem6);

        jMenuItemC9.setText("$C9");
        jMenuItemC9.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemC9ActionPerformed(evt);
            }
        });
        jMenu2.add(jMenuItemC9);

        jMenuItem8.setText("$CA");
        jMenuItem8.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem8ActionPerformed(evt);
            }
        });
        jMenu2.add(jMenuItem8);

        jMenuItem9.setText("$CB");
        jMenuItem9.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem9ActionPerformed(evt);
            }
        });
        jMenu2.add(jMenuItem9);

        jMenuItem7.setText("$D0");
        jMenuItem7.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem7ActionPerformed(evt);
            }
        });
        jMenu2.add(jMenuItem7);

        jPopupMenu1.add(jMenu2);

        jMenu3.setText("Watches");

        jMenuItemWatchBinary.setText("add watch binary");
        jMenuItemWatchBinary.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemWatchBinaryActionPerformed(evt);
            }
        });
        jMenu3.add(jMenuItemWatchBinary);

        jMenuItemWatchByte.setText("add watch byte");
        jMenuItemWatchByte.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemWatchByteActionPerformed(evt);
            }
        });
        jMenu3.add(jMenuItemWatchByte);

        jMenuItemWatchWord.setText("add watch word");
        jMenuItemWatchWord.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemWatchWordActionPerformed(evt);
            }
        });
        jMenu3.add(jMenuItemWatchWord);

        jMenuItemWatchString.setText("add watch string");
        jMenuItemWatchString.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemWatchStringActionPerformed(evt);
            }
        });
        jMenu3.add(jMenuItemWatchString);

        jMenuItemWatchBytePair.setText("add watch byte pair");
        jMenuItemWatchBytePair.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemWatchBytePairActionPerformed(evt);
            }
        });
        jMenu3.add(jMenuItemWatchBytePair);

        jMenuItemWatchSequence.setText("add watch sequence 5");
        jMenuItemWatchSequence.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemWatchSequenceActionPerformed(evt);
            }
        });
        jMenu3.add(jMenuItemWatchSequence);

        jPopupMenu1.add(jMenu3);

        jMenuItemLabelAsData.setText("use label as data");
        jMenuItemLabelAsData.setToolTipText("marking the label as data enables dissi to load that address to a X,Y,U,S,D register as immediate value, also removed previous labels");
        jMenuItemLabelAsData.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemLabelAsDataActionPerformed(evt);
            }
        });
        jPopupMenu1.add(jMenuItemLabelAsData);

        jMenuItem16.setText("remove");
        jMenuItem16.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem16ActionPerformed(evt);
            }
        });
        jPopupMenu2.add(jMenuItem16);

        setName("dissy"); // NOI18N

        jCheckBox2.setSelected(true);
        jCheckBox2.setText("ofi");
        jCheckBox2.setToolTipText("Only Full Instructions! - Memory locations that \"belong\" to other mnemonics are not shown.");
        jCheckBox2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox2ActionPerformed(evt);
            }
        });

        jCheckBox1.setSelected(true);
        jCheckBox1.setText("nu");
        jCheckBox1.setToolTipText("<html>no unkown!<BR>\nDon't show locations that are \"unkown\" (not read from file), this <b>always</b> includes RAM!<BR>(Since disassembled data is static)</html>\n"); // NOI18N
        jCheckBox1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox1ActionPerformed(evt);
            }
        });

        jPanelDebug.setToolTipText("");

        jButtonRinbufferUndo.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/arrow_turn_left.png"))); // NOI18N
        jButtonRinbufferUndo.setToolTipText("Take the last instruction back - step back, undo... (+SHIFT 10, +CONTROL 100)");
        jButtonRinbufferUndo.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonRinbufferUndo.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonRinbufferUndoActionPerformed(evt);
            }
        });

        jButtonRingbufferRedo.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/arrow_turn_right.png"))); // NOI18N
        jButtonRingbufferRedo.setToolTipText("redo last instruction (not executed, but \"reload\" state\") (+SHIFT 10, +CONTROL 100)");
        jButtonRingbufferRedo.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonRingbufferRedo.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonRingbufferRedoActionPerformed(evt);
            }
        });

        jButtonMultiStep.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/arrow_rotate_clockwise.png"))); // NOI18N
        jButtonMultiStep.setToolTipText("Multi Step");
        jButtonMultiStep.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonMultiStep.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonMultiStepActionPerformed(evt);
            }
        });

        jButtonsetBreakpoint.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/stop.png"))); // NOI18N
        jButtonsetBreakpoint.setToolTipText("Breakpoint set to current selected address (in dissy)");
        jButtonsetBreakpoint.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonsetBreakpoint.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonsetBreakpointActionPerformed(evt);
            }
        });

        jButtonStepOut.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/arrow_out.png"))); // NOI18N
        jButtonStepOut.setToolTipText("Step Out. Breakpoint, wenn PC = [S]");
        jButtonStepOut.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonStepOut.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonStepOutActionPerformed(evt);
            }
        });

        jButtonOverstep.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/arrow_refresh.png"))); // NOI18N
        jButtonOverstep.setToolTipText("Overstep next instruction (breakpoint PC+1 instruction) (uses correct dissi!)");
        jButtonOverstep.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonOverstep.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonOverstepActionPerformed(evt);
            }
        });

        jButtonDebugStep.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/bullet_go.png"))); // NOI18N
        jButtonDebugStep.setToolTipText("single Step");
        jButtonDebugStep.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonDebugStep.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonDebugStepActionPerformed(evt);
            }
        });

        jButtonDebug.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/bug_go.png"))); // NOI18N
        jButtonDebug.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonDebug.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonDebugActionPerformed(evt);
            }
        });

        jButtonDump1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/monitor_add.png"))); // NOI18N
        jButtonDump1.setToolTipText("show VIA monitor");
        jButtonDump1.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonDump1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonDump1ActionPerformed(evt);
            }
        });

        jButtonViai.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/table.png"))); // NOI18N
        jButtonViai.setToolTipText("show memory dump");
        jButtonViai.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonViai.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonViaiActionPerformed(evt);
            }
        });

        jButtonShowVars.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/table_refresh.png"))); // NOI18N
        jButtonShowVars.setToolTipText("show variables");
        jButtonShowVars.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonShowVars.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonShowVarsActionPerformed(evt);
            }
        });

        jButtonWRTracker.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/chart_curve_edit.png"))); // NOI18N
        jButtonWRTracker.setToolTipText("show tracker");
        jButtonWRTracker.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonWRTracker.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonWRTrackerActionPerformed(evt);
            }
        });

        jButtonShowLabels.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/table_relationship.png"))); // NOI18N
        jButtonShowLabels.setToolTipText("show labels");
        jButtonShowLabels.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonShowLabels.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonShowLabelsActionPerformed(evt);
            }
        });

        jButtonShowPSG.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/sound_add.png"))); // NOI18N
        jButtonShowPSG.setToolTipText("show psg registers");
        jButtonShowPSG.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonShowPSG.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonShowPSGActionPerformed(evt);
            }
        });

        jButtonShowBreakpoints.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/application_lightning.png"))); // NOI18N
        jButtonShowBreakpoints.setToolTipText("show breakpoints");
        jButtonShowBreakpoints.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonShowBreakpoints.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonShowBreakpointsActionPerformed(evt);
            }
        });

        jButtonAdressForward.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/resultset_next.png"))); // NOI18N
        jButtonAdressForward.setToolTipText("<html>\ngo to next visited adress\n<BR>\nAll visited adresses are on a stack.<BR>\nThe current displayed address is NOT on the stack.<BR>\nIf the current address is change by the user, and than goes<BR>\nback and forth, the \"new\" last address is visted, not the \"old\"<BR>\nlast address!<BR>\n\n</html>\n");
        jButtonAdressForward.setEnabled(false);
        jButtonAdressForward.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonAdressForward.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonAdressForwardActionPerformed(evt);
            }
        });

        jButtonAdressBack.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/resultset_previous.png"))); // NOI18N
        jButtonAdressBack.setToolTipText("<html>\ngo to last visited adress\n<BR>\nAll visited adresses are on a stack.<BR>\nThe current displayed address is NOT on the stack.<BR>\nIf the current address is change by the user, and than goes<BR>\nback and forth, the \"new\" last address is visted, not the \"old\"<BR>\nlast address!<BR>\n\n</html>\n");
        jButtonAdressBack.setEnabled(false);
        jButtonAdressBack.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonAdressBack.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonAdressBackActionPerformed(evt);
            }
        });

        jToggleButton1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/webcam.png"))); // NOI18N
        jToggleButton1.setToolTipText("Toggle Update (always or only while debug)");
        jToggleButton1.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jToggleButton1.setSelectedIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/webcamSelect.png"))); // NOI18N
        jToggleButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jToggleButton1ActionPerformed(evt);
            }
        });

        jLabel1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/mouse_error.png"))); // NOI18N
        jLabel1.setToolTipText("Select Vectors and show information");
        jLabel1.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jLabel1MouseClicked(evt);
            }
        });

        jCheckBoxVectorSelect.setToolTipText("Select Vectors and show information");
        jCheckBoxVectorSelect.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxVectorSelectActionPerformed(evt);
            }
        });

        jButtonVectrorScreenshot.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/vectorCam.png"))); // NOI18N
        jButtonVectrorScreenshot.setToolTipText("vector-screenshot");
        jButtonVectrorScreenshot.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonVectrorScreenshot.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonVectrorScreenshotActionPerformed(evt);
            }
        });

        jButtonCNTOutput.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/page_code.png"))); // NOI18N
        jButtonCNTOutput.setToolTipText("save gathered information to CNT-file");
        jButtonCNTOutput.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonCNTOutput.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonCNTOutputActionPerformed(evt);
            }
        });

        jButtonDASMOutput.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/page_save.png"))); // NOI18N
        jButtonDASMOutput.setToolTipText("save dissi as asm file");
        jButtonDASMOutput.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonDASMOutput.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonDASMOutputActionPerformed(evt);
            }
        });

        jButtonApplyCodeScan.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/exclamation.png"))); // NOI18N
        jButtonApplyCodeScan.setToolTipText("Reset dissi, do everything from start. This mainly makes sense in combination with\n \"codescan\".");
        jButtonApplyCodeScan.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonApplyCodeScan.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonApplyCodeScanActionPerformed(evt);
            }
        });

        jButtonRinbufferUndo1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/arrow_undo.png"))); // NOI18N
        jButtonRinbufferUndo1.setToolTipText("Take the last 30000 instructions back.");
        jButtonRinbufferUndo1.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonRinbufferUndo1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonRinbufferUndo1ActionPerformed(evt);
            }
        });

        jButtonRingbufferRedo1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/arrow_redo.png"))); // NOI18N
        jButtonRingbufferRedo1.setToolTipText("redo last 30000 instructions");
        jButtonRingbufferRedo1.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonRingbufferRedo1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonRingbufferRedo1ActionPerformed(evt);
            }
        });

        jButtonWRTracker1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/layout_content.png"))); // NOI18N
        jButtonWRTracker1.setToolTipText("profile window (enable in config & restart emulation)");
        jButtonWRTracker1.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonWRTracker1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonWRTracker1ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanelDebugLayout = new javax.swing.GroupLayout(jPanelDebug);
        jPanelDebug.setLayout(jPanelDebugLayout);
        jPanelDebugLayout.setHorizontalGroup(
            jPanelDebugLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanelDebugLayout.createSequentialGroup()
                .addComponent(jToggleButton1)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonAdressBack)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonAdressForward)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonDebug)
                .addGap(18, 18, 18)
                .addComponent(jButtonDebugStep)
                .addGap(5, 5, 5)
                .addComponent(jButtonOverstep)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonStepOut)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jButtonsetBreakpoint)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonMultiStep)
                .addGap(18, 18, 18)
                .addComponent(jButtonRinbufferUndo1)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonRinbufferUndo)
                .addGap(7, 7, 7)
                .addComponent(jButtonRingbufferRedo)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonRingbufferRedo1)
                .addGap(12, 12, 12)
                .addComponent(jButtonWRTracker)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonDump1)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonViai)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonShowVars)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonShowLabels)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonShowPSG)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonShowBreakpoints)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonWRTracker1)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 11, Short.MAX_VALUE)
                .addComponent(jCheckBoxVectorSelect)
                .addGap(2, 2, 2)
                .addComponent(jLabel1)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jButtonDASMOutput)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonCNTOutput)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonVectrorScreenshot)
                .addGap(18, 18, 18)
                .addComponent(jButtonApplyCodeScan)
                .addContainerGap())
        );
        jPanelDebugLayout.setVerticalGroup(
            jPanelDebugLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
            .addGroup(jPanelDebugLayout.createSequentialGroup()
                .addGap(1, 1, 1)
                .addGroup(jPanelDebugLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jButtonRingbufferRedo1)
                    .addComponent(jButtonRinbufferUndo1)
                    .addComponent(jButtonRinbufferUndo)
                    .addComponent(jButtonWRTracker1)
                    .addComponent(jToggleButton1)
                    .addComponent(jButtonAdressBack)
                    .addComponent(jButtonAdressForward)
                    .addComponent(jButtonsetBreakpoint)
                    .addComponent(jButtonMultiStep)
                    .addComponent(jButtonRingbufferRedo)
                    .addComponent(jButtonShowBreakpoints)
                    .addComponent(jButtonWRTracker)
                    .addComponent(jButtonShowVars)
                    .addComponent(jButtonViai)
                    .addComponent(jButtonDump1)
                    .addComponent(jButtonDebug)
                    .addComponent(jButtonDebugStep)
                    .addComponent(jButtonOverstep)
                    .addComponent(jButtonStepOut)
                    .addComponent(jButtonShowPSG)
                    .addComponent(jButtonShowLabels)
                    .addComponent(jButtonDASMOutput)
                    .addComponent(jButtonCNTOutput)
                    .addComponent(jButtonVectrorScreenshot)
                    .addComponent(jButtonApplyCodeScan))
                .addGap(1, 1, 1))
            .addComponent(jLabel1, javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jCheckBoxVectorSelect, javax.swing.GroupLayout.Alignment.LEADING)
        );

        jPanel1.setBorder(javax.swing.BorderFactory.createEtchedBorder());

        jButtonSearchNext.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/resultset_next.png"))); // NOI18N
        jButtonSearchNext.setToolTipText("search forward");
        jButtonSearchNext.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonSearchNext.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSearchNextActionPerformed(evt);
            }
        });

        jTextFieldSearch.setToolTipText("searches in labels and in comments (case independent)");
        jTextFieldSearch.setPreferredSize(new java.awt.Dimension(120, 20));
        jTextFieldSearch.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldSearchActionPerformed(evt);
            }
        });

        jLabel2.setHorizontalAlignment(javax.swing.SwingConstants.TRAILING);
        jLabel2.setText("search:");
        jLabel2.setPreferredSize(new java.awt.Dimension(37, 21));

        jButtonSearchPrevious.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/resultset_previous.png"))); // NOI18N
        jButtonSearchPrevious.setToolTipText("search backwards");
        jButtonSearchPrevious.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonSearchPrevious.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSearchPreviousActionPerformed(evt);
            }
        });

        jLabel3.setForeground(new java.awt.Color(255, 51, 51));
        jLabel3.setText("not found");

        jTextFieldSearch1.setToolTipText("text to be highlighted in \"operator\" field");
        jTextFieldSearch1.setPreferredSize(new java.awt.Dimension(120, 20));
        jTextFieldSearch1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldSearch1ActionPerformed(evt);
            }
        });

        jButtonSearchNext2.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/lightbulb.png"))); // NOI18N
        jButtonSearchNext2.setToolTipText("Highlite text given in \"operator\" field");
        jButtonSearchNext2.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonSearchNext2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSearchNext2ActionPerformed(evt);
            }
        });

        jLabel4.setHorizontalAlignment(javax.swing.SwingConstants.TRAILING);
        jLabel4.setText("highlight op:");
        jLabel4.setPreferredSize(new java.awt.Dimension(67, 21));

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addComponent(jLabel2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addGap(2, 2, 2)
                .addComponent(jTextFieldSearch, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonSearchPrevious)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonSearchNext)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jLabel3, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addGap(18, 18, 18)
                .addComponent(jLabel4, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addGap(4, 4, 4)
                .addComponent(jTextFieldSearch1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonSearchNext2)
                .addGap(0, 603, Short.MAX_VALUE))
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGap(1, 1, 1)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextFieldSearch, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButtonSearchPrevious)
                    .addComponent(jButtonSearchNext)
                    .addComponent(jLabel3, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jLabel4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextFieldSearch1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButtonSearchNext2)))
        );

        jSplitPane1.setDividerLocation(470);
        jSplitPane1.setOrientation(javax.swing.JSplitPane.VERTICAL_SPLIT);
        jSplitPane1.setResizeWeight(1.0);

        jTableSource.setModel(new javax.swing.table.DefaultTableModel(
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
        jTableSource.setSelectionMode(javax.swing.ListSelectionModel.MULTIPLE_INTERVAL_SELECTION);
        jTableSource.setShowHorizontalLines(false);
        jTableSource.setShowVerticalLines(false);
        jTableSource.addMouseMotionListener(new java.awt.event.MouseMotionAdapter() {
            public void mouseDragged(java.awt.event.MouseEvent evt) {
                jTableSourceMouseDragged(evt);
            }
        });
        jTableSource.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jTableSourceMousePressed(evt);
            }
            public void mouseReleased(java.awt.event.MouseEvent evt) {
                jTableSourceMouseReleased(evt);
            }
        });
        jScrollPane2.setViewportView(jTableSource);

        jSplitPane1.setTopComponent(jScrollPane2);

        jPanel3.setPreferredSize(new java.awt.Dimension(50, 50));

        jScrollPane3.setHorizontalScrollBarPolicy(javax.swing.ScrollPaneConstants.HORIZONTAL_SCROLLBAR_NEVER);

        jEditorPane1.setEditable(false);
        jScrollPane3.setViewportView(jEditorPane1);

        jTextFieldCommand.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldCommandActionPerformed(evt);
            }
        });

        jTable1.setModel(new javax.swing.table.DefaultTableModel(
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
        jTable1.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jTable1MousePressed(evt);
            }
        });
        jScrollPane1.setViewportView(jTable1);

        jTabbedPane1.addTab("Watches", jScrollPane1);

        jToggleButton3.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/webcam.png"))); // NOI18N
        jToggleButton3.setToolTipText("Toggle Update (always or only while debug)");
        jToggleButton3.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jToggleButton3.setSelectedIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/webcamSelect.png"))); // NOI18N
        jToggleButton3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jToggleButton3ActionPerformed(evt);
            }
        });

        jLabel5.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel5.setText("A");

        jLabel11.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel11.setText("$ff");

        jLabel12.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel12.setText("$ff");

        jLabel6.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel6.setText("B");

        jLabel9.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel9.setText("DP");

        jLabel18.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel18.setText("$ff");

        jLabel10.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel10.setText("CC");

        jLabel19.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel19.setText("%0000 0000");
        jLabel19.setToolTipText("<html>\n<PRE>\nEntire flag (Bit 7, if set RTI~s=F)\nFIRQ/IRQ interrupt mask (Bit 6/4)  \nHalf carry (Bit 5)                 \nNegative (Bit 3)                   \nZero (Bit 2)                       \nOverflow (Bit 1)                   \nCarry/borrow (Bit 0)\n</PRE>\n</html>");

        jLabel21.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel21.setText(" EFHI NZVC");
        jLabel21.setToolTipText("<html>\n<PRE>\nEntire flag (Bit 7, if set RTI~s=F)\nFIRQ/IRQ interrupt mask (Bit 6/4)  \nHalf carry (Bit 5)                 \nNegative (Bit 3)                   \nZero (Bit 2)                       \nOverflow (Bit 1)                   \nCarry/borrow (Bit 0)\n</PRE>\n</html>");

        jLabel15.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel15.setText("$ffff");

        jLabel7.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel7.setText("D");

        jLabel8.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel8.setText("X");

        jLabel14.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel14.setText("$ffff");
        jLabel14.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jLabel14MousePressed(evt);
            }
        });

        jLabel13.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel13.setText("Y");

        jLabel16.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel16.setText("$ffff");
        jLabel16.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jLabel16MousePressed(evt);
            }
        });

        jLabel17.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel17.setText("U");

        jLabel20.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel20.setText("$ffff");
        jLabel20.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jLabel20MousePressed(evt);
            }
        });

        jLabel22.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel22.setText("PC");

        jLabel23.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel23.setText("$ffff");
        jLabel23.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jLabel23MousePressed(evt);
            }
        });

        jLabel24.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel24.setText("[00]");
        jLabel24.setToolTipText("bank number");

        jLabel25.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel25.setText("S");

        jLabel26.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel26.setText("$ffff");
        jLabel26.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jLabel26MousePressed(evt);
            }
        });

        jScrollPane4.setBorder(javax.swing.BorderFactory.createEtchedBorder());

        jTable2.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTable2.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null},
                {null},
                {null},
                {null}
            },
            new String [] {
                "Adr"
            }
        ) {
            Class[] types = new Class [] {
                java.lang.Integer.class
            };
            boolean[] canEdit = new boolean [] {
                false
            };

            public Class getColumnClass(int columnIndex) {
                return types [columnIndex];
            }

            public boolean isCellEditable(int rowIndex, int columnIndex) {
                return canEdit [columnIndex];
            }
        });
        jTable2.setToolTipText("return addresses on stack");
        jTable2.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jTable2MousePressed(evt);
            }
        });
        jScrollPane4.setViewportView(jTable2);

        jScrollPane5.setBorder(javax.swing.BorderFactory.createEtchedBorder());

        jTableStack.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTableStack.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null},
                {null},
                {null},
                {null}
            },
            new String [] {
                "Adr"
            }
        ) {
            Class[] types = new Class [] {
                java.lang.Integer.class
            };
            boolean[] canEdit = new boolean [] {
                false
            };

            public Class getColumnClass(int columnIndex) {
                return types [columnIndex];
            }

            public boolean isCellEditable(int rowIndex, int columnIndex) {
                return canEdit [columnIndex];
            }
        });
        jTableStack.setToolTipText("real stack values (in bytes)");
        jTableStack.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jTableStackMousePressed(evt);
            }
        });
        jScrollPane5.setViewportView(jTableStack);

        javax.swing.GroupLayout jPanel2Layout = new javax.swing.GroupLayout(jPanel2);
        jPanel2.setLayout(jPanel2Layout);
        jPanel2Layout.setHorizontalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel2Layout.createSequentialGroup()
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jToggleButton3, javax.swing.GroupLayout.PREFERRED_SIZE, 20, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addContainerGap()
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel2Layout.createSequentialGroup()
                                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jLabel6)
                                    .addComponent(jLabel5))
                                .addGap(5, 5, 5)
                                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jLabel11)
                                    .addComponent(jLabel12)))
                            .addGroup(jPanel2Layout.createSequentialGroup()
                                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jLabel9)
                                    .addComponent(jLabel10))
                                .addGap(5, 5, 5)
                                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jLabel18)
                                    .addComponent(jLabel19)
                                    .addComponent(jLabel21))))
                        .addGap(18, 18, 18)
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel2Layout.createSequentialGroup()
                                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jLabel8)
                                    .addComponent(jLabel17)
                                    .addComponent(jLabel13)
                                    .addComponent(jLabel22))
                                .addGap(5, 5, 5)
                                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jLabel15)
                                    .addComponent(jLabel14)
                                    .addComponent(jLabel16)
                                    .addComponent(jLabel20)
                                    .addGroup(jPanel2Layout.createSequentialGroup()
                                        .addComponent(jLabel23)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addComponent(jLabel24, javax.swing.GroupLayout.PREFERRED_SIZE, 37, javax.swing.GroupLayout.PREFERRED_SIZE))))
                            .addComponent(jLabel7))))
                .addGap(10, 10, 10)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addComponent(jLabel25)
                        .addGap(5, 5, 5)
                        .addComponent(jLabel26))
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addComponent(jScrollPane4, javax.swing.GroupLayout.PREFERRED_SIZE, 64, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jScrollPane5, javax.swing.GroupLayout.PREFERRED_SIZE, 114, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addContainerGap())
        );
        jPanel2Layout.setVerticalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel2Layout.createSequentialGroup()
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jToggleButton3, javax.swing.GroupLayout.PREFERRED_SIZE, 20, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jLabel25)
                        .addComponent(jLabel26)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addComponent(jScrollPane4, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE)
                        .addGap(11, 11, 11))
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addGroup(jPanel2Layout.createSequentialGroup()
                                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jLabel5)
                                    .addComponent(jLabel11))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jLabel6)
                                    .addComponent(jLabel12))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jLabel9)
                                    .addComponent(jLabel18))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jLabel10)
                                    .addComponent(jLabel19))
                                .addGap(2, 2, 2)
                                .addComponent(jLabel21))
                            .addGroup(jPanel2Layout.createSequentialGroup()
                                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addGroup(jPanel2Layout.createSequentialGroup()
                                        .addComponent(jLabel7)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                            .addComponent(jLabel8)
                                            .addComponent(jLabel14)))
                                    .addComponent(jLabel15))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jLabel13)
                                    .addComponent(jLabel16))
                                .addGap(4, 4, 4)
                                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jLabel17)
                                    .addComponent(jLabel20))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jLabel22)
                                    .addComponent(jLabel23)
                                    .addComponent(jLabel24))))
                        .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addComponent(jScrollPane5, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE)
                        .addContainerGap())))
        );

        jTabbedPane1.addTab("Regs", jPanel2);

        javax.swing.GroupLayout jPanel3Layout = new javax.swing.GroupLayout(jPanel3);
        jPanel3.setLayout(jPanel3Layout);
        jPanel3Layout.setHorizontalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jTextFieldCommand, javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jScrollPane3, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, 759, Short.MAX_VALUE))
                .addGap(430, 430, 430))
            .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel3Layout.createSequentialGroup()
                    .addGap(0, 766, Short.MAX_VALUE)
                    .addComponent(jTabbedPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 423, javax.swing.GroupLayout.PREFERRED_SIZE)))
        );
        jPanel3Layout.setVerticalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel3Layout.createSequentialGroup()
                .addComponent(jScrollPane3, javax.swing.GroupLayout.DEFAULT_SIZE, 149, Short.MAX_VALUE)
                .addGap(2, 2, 2)
                .addComponent(jTextFieldCommand, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(1, 1, 1))
            .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                .addComponent(jTabbedPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 176, Short.MAX_VALUE))
        );

        jSplitPane1.setBottomComponent(jPanel3);

        jCheckBox3.setSelected(true);
        jCheckBox3.setText("BIOS");
        jCheckBox3.setToolTipText("show/not show BIOS in disassembly"); // NOI18N
        jCheckBox3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox3ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addGroup(layout.createSequentialGroup()
                .addComponent(jPanelDebug, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jCheckBox3)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox1)
                .addGap(6, 6, 6)
                .addComponent(jCheckBox2)
                .addContainerGap(277, Short.MAX_VALUE))
            .addComponent(jSplitPane1)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jCheckBox2)
                    .addComponent(jCheckBox1)
                    .addComponent(jCheckBox3)
                    .addComponent(jPanelDebug, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(2, 2, 2)
                .addComponent(jSplitPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 571, Short.MAX_VALUE)
                .addGap(2, 2, 2)
                .addComponent(jPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
        );
    }// </editor-fold>//GEN-END:initComponents

    private void jCheckBox1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox1ActionPerformed
        correctModel();
    }//GEN-LAST:event_jCheckBox1ActionPerformed

    private void jCheckBox2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox2ActionPerformed
        if (currentDissi.model!=null)
        {
            currentDissi.model.setFullDisplay(!jCheckBox2.isSelected());
        }
        correctModel();
    }//GEN-LAST:event_jCheckBox2ActionPerformed

    public void correctTableWatch()
    {
        jTable1.tableChanged(null);
        
        WatchTableModel model = (WatchTableModel)jTable1.getModel();
        
        jTable1.setAutoResizeMode(AUTO_RESIZE_LAST_COLUMN);
        for (int i=0; i< model.getColumnCount(); i++)
        {
            jTable1.getColumnModel().getColumn(i).setPreferredWidth(model.getColWidth(i));                
            jTable1.getColumnModel().getColumn(i).setWidth(model.getColWidth(i));  
        }
        jTable1.setAutoResizeMode(AUTO_RESIZE_SUBSEQUENT_COLUMNS);
    }

    int popupRow=-1;
    private void jTableSourceMousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jTableSourceMousePressed
        JTable table =(JTable) evt.getSource();
        Point p = evt.getPoint();
        int row = table.rowAtPoint(p);
        int col = table.columnAtPoint(p);
        if (evt.getButton() == MouseEvent.BUTTON3)
        {
            popupRow = row;
            jPopupMenu1.show(jTableSource, evt.getX()-20,evt.getY()-20);
        }        
        if (currentDissi.vecxPanel==null) return;

        if (evt.getClickCount() == 2) 
        {
            mClassSetting++;
            if (currentDissi.model.convertViewToModel(col) == 8) // zeiger auf adresse
            {
                MemoryInformation memInfo = currentDissi.model.getValueAt(row);
                boolean bit8 = false;
                String adr = (String) currentDissi.model.getValueAt( row,  currentDissi.model.convertViewToModel(col));
                if (adr.trim().length() <1) return;
                if (adr.trim().length() <=4) bit8 = true;
                int a = DASM6809.toNumber(adr);
                int current = memInfo.address;
                
                if (bit8) 
                    a += current+memInfo.length; // offsets are calculated AFTER the instruction!
                
                if (memInfo.disassembledMnemonic.toLowerCase().contains("lb")) // long RELATIV branch
                {
                    a += current+memInfo.length; // offsets are calculated AFTER the instruction!
                }
                if ((evt != null ) && ((evt.getModifiers() & SHIFT_MASK) == SHIFT_MASK))
                    currentDissi.vecxPanel.setDumpToAddress(a&0xffff);
                else 
                    goAddress(a&0xffff,true, true, true);
            }
            if (currentDissi.model.convertViewToModel(col) == 0) // zeiger auf adresse
            {
                MemoryInformation memInfo = currentDissi.model.getValueAt(row);
                if ((evt != null ) && ((evt.getModifiers() & SHIFT_MASK) == SHIFT_MASK))
                    currentDissi.vecxPanel.setDumpToAddress(memInfo.address);
            }
            mClassSetting--;
            if (currentDissi.model.convertViewToModel(col) == 3) // zeiger auf mnemonic
            {
                
                MemoryInformation memInfo = currentDissi.model.getValueAt(row);
                VediPanel.displayHelp(memInfo.disassembledMnemonic);
            }
            if (currentDissi.model.convertViewToModel(col) == 4) // zeiger auf operand
            {
                MemoryInformation memInfo = currentDissi.model.getValueAt(row);
                
                String op = memInfo.disassembledOperand;
                if (op == null) 
                    return;
                op = op.toLowerCase();
                op = de.malban.util.UtilityString.replace(op, "<", "");
                op = de.malban.util.UtilityString.replace(op, ">", "");
                if (op.length()==0) return;


                boolean bit8 = false;
                String adr = (String) currentDissi.model.getValueAt( row,  8);
                if (adr.trim().length() <1) return;
                if (adr.trim().length() <=4) bit8 = true;
                int a = DASM6809.toNumber(adr);
                int current = memInfo.address;
                
                if (bit8) 
                    a += current+memInfo.length; // offsets are calculated AFTER the instruction!
                
                if (memInfo.disassembledMnemonic.toLowerCase().contains("lb")) // long RELATIV branch
                {
                    a += current+memInfo.length; // offsets are calculated AFTER the instruction!
                }


                displayRAM(op, a&0xffff);
                VediPanel.displayHelp(op);
            }
        }
        else if (evt.getClickCount() == 1) 
        {
            String clicky="";
            if (currentDissi.model.convertViewToModel(col) == 1)
            {
                MemoryInformation memInfo = currentDissi.model.getValueAt(row);
                if (memInfo.labels.size()>0) clicky=memInfo.labels.get(0);
            }
            currentDissi.model.setHighliteClick(clicky);
            updateTableOnly();
            selectionChanged();
        }

        
    }//GEN-LAST:event_jTableSourceMousePressed

    private void jButtonDebugActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonDebugActionPerformed
        // start running in debug mode
        // or go to pause and debug
        if (currentDissi.vecxPanel==null) return;
        currentDissi.vecxPanel.debugAction();
        updateTableOnly();
    }//GEN-LAST:event_jButtonDebugActionPerformed

    private void jButtonDebugStepActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonDebugStepActionPerformed
        if (currentDissi.vecxPanel==null) return;
        currentDissi.vecxPanel.debugStepAction();
        updateTableOnly();
    }//GEN-LAST:event_jButtonDebugStepActionPerformed

    private void jButtonOverstepActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonOverstepActionPerformed
        if (currentDissi.vecxPanel==null) return;
        currentDissi.vecxPanel.debugOverstepAction();
        updateTableOnly();
    }//GEN-LAST:event_jButtonOverstepActionPerformed

    private void jButtonStepOutActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonStepOutActionPerformed
        if (currentDissi.vecxPanel==null) return;
        currentDissi.vecxPanel.debugStepoutAction();
        updateTableOnly();
    }//GEN-LAST:event_jButtonStepOutActionPerformed

    private void jButtonsetBreakpointActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonsetBreakpointActionPerformed
        if (currentDissi.vecxPanel==null) return; 
        currentDissi.vecxPanel.debugBreakpointAction();
    }//GEN-LAST:event_jButtonsetBreakpointActionPerformed

    private void jButtonMultiStepActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonMultiStepActionPerformed
        if (currentDissi.vecxPanel==null) return;
        currentDissi.vecxPanel.debugMultistepAction();
        updateTableOnly();
    }//GEN-LAST:event_jButtonMultiStepActionPerformed

    private void jButtonRingbufferRedoActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonRingbufferRedoActionPerformed
        if (currentDissi.vecxPanel==null) return;
        int modi = evt.getModifiers();
        
        if ((modi & ALT_MASK) == ALT_MASK)
        {
            currentDissi.vecxPanel.debugRedoAction(10000);
        }
        else if (((modi & SHIFT_MASK) == SHIFT_MASK) && ((modi & CTRL_MASK) == CTRL_MASK))
        {
            currentDissi.vecxPanel.debugRedoAction(1000);
        }
        else if ((modi & SHIFT_MASK) == SHIFT_MASK)
//        if (KeyboardListener.isShiftDown())
        {
            currentDissi.vecxPanel.debugRedoAction(10);
        }
        else
        if ((modi & CTRL_MASK) == CTRL_MASK)
//        if (KeyboardListener. isControlDown())
        {
            currentDissi.vecxPanel.debugRedoAction(100);
        }
        else
            currentDissi.vecxPanel.debugRedoAction(1);
        updateTableOnly();
    }//GEN-LAST:event_jButtonRingbufferRedoActionPerformed

    private void jButtonRinbufferUndoActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonRinbufferUndoActionPerformed
        if (currentDissi.vecxPanel==null) return;
        
        int modi = evt.getModifiers();
        
        if ((modi & ALT_MASK) == ALT_MASK)
        {
            currentDissi.vecxPanel.debugUndoAction(10000);
        }
        else if (((modi & SHIFT_MASK) == SHIFT_MASK) && ((modi & CTRL_MASK) == CTRL_MASK))
        {
            currentDissi.vecxPanel.debugUndoAction(1000);
        }
        else if ((modi & SHIFT_MASK) == SHIFT_MASK)
//        if (KeyboardListener.isShiftDown())
        {
            currentDissi.vecxPanel.debugUndoAction(10);
        }
        else
        if ((modi & CTRL_MASK) == CTRL_MASK)
//        if (KeyboardListener. isControlDown())
        {
            currentDissi.vecxPanel.debugUndoAction(100);
        }
        else
            currentDissi.vecxPanel.debugUndoAction(1);
            
            
        updateTableOnly();
    }//GEN-LAST:event_jButtonRinbufferUndoActionPerformed

    private void jButtonViaiActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonViaiActionPerformed
        if (currentDissi.vecxPanel==null) return;
        currentDissi.vecxPanel.showDumpi();
    }//GEN-LAST:event_jButtonViaiActionPerformed

    private void jButtonDump1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonDump1ActionPerformed
        if (currentDissi.vecxPanel==null) return;
        currentDissi.vecxPanel.showViai();
    }//GEN-LAST:event_jButtonDump1ActionPerformed

    private void jLabel1MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel1MouseClicked
        jCheckBox1.setSelected(jCheckBoxVectorSelect.isSelected());
        jCheckBox1ActionPerformed(null);
    }//GEN-LAST:event_jLabel1MouseClicked

    private void jCheckBoxVectorSelectActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxVectorSelectActionPerformed
        if (currentDissi.vecxPanel==null) return;
        currentDissi.vecxPanel.setMouseMode(jCheckBoxVectorSelect.isSelected());
    }//GEN-LAST:event_jCheckBoxVectorSelectActionPerformed

    int getTopRow()
    {
        JViewport viewport = jScrollPane2.getViewport();

        Point p = viewport.getViewPosition();
        return jTableSource.rowAtPoint(p);   
    }
    
    void saveLastAdress()
    {
        int saveRow =-1;
        int[] selected = jTableSource.getSelectedRows();
        if (selected.length>0) saveRow=selected[0];
        else saveRow = getTopRow();
        if (saveRow==-1) return;
        
        currentDissi.rowStack.add(saveRow);
        currentDissi.rowStackPosition = -1;
        jButtonAdressBack.setEnabled(true);
        jButtonAdressForward.setEnabled(false);
    }
    private void jButtonAdressBackActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonAdressBackActionPerformed
        if (currentDissi.rowStackPosition==0) return;
        if (currentDissi.rowStack.size() == 0) return;
        if (currentDissi.rowStackPosition == -1) currentDissi.rowStackPosition = currentDissi.rowStack.size();
        currentDissi.rowStackPosition--;
        if (currentDissi.rowStackPosition == 0)jButtonAdressBack.setEnabled(false);
        jButtonAdressForward.setEnabled(true);
        Integer row = currentDissi.rowStack.remove(currentDissi.rowStackPosition);
        currentDissi.rowStack.add(currentDissi.rowStackPosition, getTopRow());
        ensureVisible(jTableSource, row,0) ;
    }//GEN-LAST:event_jButtonAdressBackActionPerformed

    private void jButtonAdressForwardActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonAdressForwardActionPerformed
        if (currentDissi.rowStackPosition==-1) return;
        if (currentDissi.rowStack.size() == 0) return;
        if (currentDissi.rowStackPosition >= currentDissi.rowStack.size()) return;
        Integer row = currentDissi.rowStack.remove(currentDissi.rowStackPosition);
        currentDissi.rowStack.add(currentDissi.rowStackPosition, getTopRow());
        currentDissi.rowStackPosition++;
        if (currentDissi.rowStackPosition == currentDissi.rowStack.size())
        {
            jButtonAdressForward.setEnabled(false);
            currentDissi.rowStackPosition = -1;
        }
        jButtonAdressBack.setEnabled(true);
        ensureVisible(jTableSource, row,0);        
    }//GEN-LAST:event_jButtonAdressForwardActionPerformed

    private void jButtonShowVarsActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonShowVarsActionPerformed
        if (currentDissi.vecxPanel==null) return;
        currentDissi.vecxPanel.showVari();
    }//GEN-LAST:event_jButtonShowVarsActionPerformed

    private void jButtonWRTrackerActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonWRTrackerActionPerformed
        if (currentDissi.vecxPanel==null) return;
        currentDissi.vecxPanel.showTracki();
    }//GEN-LAST:event_jButtonWRTrackerActionPerformed

    private void jToggleButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jToggleButton1ActionPerformed
        currentDissi.updateEnabled = jToggleButton1.isSelected();
    }//GEN-LAST:event_jToggleButton1ActionPerformed

    private void jButtonShowLabelsActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonShowLabelsActionPerformed
        if (currentDissi.vecxPanel==null) return;
        currentDissi.vecxPanel.showLabi();
    }//GEN-LAST:event_jButtonShowLabelsActionPerformed

    private void jPopupMenu1MouseExited(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jPopupMenu1MouseExited
        jPopupMenu1.setVisible(false);
    }//GEN-LAST:event_jPopupMenu1MouseExited
    
    private void jMenuItemByteActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemByteActionPerformed
        updateToNewType(MemoryInformation.DIS_TYPE_DATA_BYTE, 1);
    }//GEN-LAST:event_jMenuItemByteActionPerformed

    private void jMenuItemCodeActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemCodeActionPerformed

        updateToNewType(MemoryInformation.DIS_TYPE_DATA_INSTRUCTION_GENERAL, 1);
    }//GEN-LAST:event_jMenuItemCodeActionPerformed

    private void jMenuItemCharActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemCharActionPerformed
        updateToNewType(MemoryInformation.DIS_TYPE_DATA_CHAR, 1);
    }//GEN-LAST:event_jMenuItemCharActionPerformed

    private void jMenuItemWordActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemWordActionPerformed
        updateToNewType(MemoryInformation.DIS_TYPE_DATA_WORD, 2);
    }//GEN-LAST:event_jMenuItemWordActionPerformed

    private void jMenuItemUngroupActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemUngroupActionPerformed
        joinData(1);
    }//GEN-LAST:event_jMenuItemUngroupActionPerformed
    
    private void jMenuItemJoinActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemJoinActionPerformed
        int[] selected = jTableSource.getSelectedRows();
        MemoryInformationTableModel model = (MemoryInformationTableModel) jTableSource.getModel();
        
        int max = 0;
        for (int row: selected)
        {
            MemoryInformation memInfo = model.getValueAt(row);
            int len = memInfo.length;
            for (int a=memInfo.address; a<memInfo.address+len; a++)
            {
                max++;
            }
        }        
        joinData(max);
    
    }//GEN-LAST:event_jMenuItemJoinActionPerformed

    private void jMenuItem1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem1ActionPerformed
        joinData(2);
    }//GEN-LAST:event_jMenuItem1ActionPerformed

    private void jMenuItem2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem2ActionPerformed
        joinData(3);
    }//GEN-LAST:event_jMenuItem2ActionPerformed

    private void jMenuItem3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem3ActionPerformed
        joinData(4);
    }//GEN-LAST:event_jMenuItem3ActionPerformed

    private void jMenuItem4ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem4ActionPerformed
        joinData(5);
    }//GEN-LAST:event_jMenuItem4ActionPerformed

    private void jMenuItem5ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem5ActionPerformed
        joinData(6);
    }//GEN-LAST:event_jMenuItem5ActionPerformed

    private void jMenuItem6ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem6ActionPerformed
        updateToNewDP(0xc8);
    }//GEN-LAST:event_jMenuItem6ActionPerformed

    private void jMenuItem7ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem7ActionPerformed
        updateToNewDP(0xd0);
    }//GEN-LAST:event_jMenuItem7ActionPerformed

    private void jMenuItemC9ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemC9ActionPerformed
        updateToNewDP(0xc9);
    }//GEN-LAST:event_jMenuItemC9ActionPerformed

    private void jTextFieldSearchActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldSearchActionPerformed
        jButtonSearchNextActionPerformed(null);
    }//GEN-LAST:event_jTextFieldSearchActionPerformed

    private void jButtonSearchPreviousActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSearchPreviousActionPerformed
        jLabel3.setVisible(false);
        int searchStart = 0;
        String text = jTextFieldSearch.getText();
        if (text.trim().length() == 0) return;
        int[] selected = jTableSource.getSelectedRows();
        MemoryInformationTableModel model = (MemoryInformationTableModel) jTableSource.getModel();
        if (selected.length!= 0) 
            searchStart = model.getValueAt(selected[0]).address-1;
        if (searchStart<=0) searchStart = 65535;
        int adr = searchForString(searchStart, text, false);
        int row = model.getNearestVisibleRow(adr);
        if (row == -1) return;
        
        goRow(row, true);

    }//GEN-LAST:event_jButtonSearchPreviousActionPerformed

    private void jButtonSearchNextActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSearchNextActionPerformed
        jLabel3.setVisible(false);
        int searchStart = 0;
        String text = jTextFieldSearch.getText();
        if (text.trim().length() == 0) return;
        int[] selected = jTableSource.getSelectedRows();
        MemoryInformationTableModel model = (MemoryInformationTableModel) jTableSource.getModel();
        if (selected.length!= 0) 
            searchStart = model.getValueAt(selected[0]).address+1;
        if (searchStart>=65536) searchStart = 0;
        int adr = searchForString(searchStart, text, true);
        int row = model.getNearestVisibleRow(adr);
        if (row == -1) return;
        
        goRow(row, true);
    }//GEN-LAST:event_jButtonSearchNextActionPerformed

    public void commandHistoryNext()
    {
        if (currentDissi.commandHistoryPosition==-1) return; // we have no history
        if (currentDissi.commandHistoryPosition == currentDissi.commandHistory.size()-1)
        {
            // new is allways empty
            jTextFieldCommand.setText("");
            currentDissi.commandHistoryPosition = -1;
            return;
        }
        currentDissi.commandHistoryPosition++;
        jTextFieldCommand.setText(currentDissi.commandHistory.get(currentDissi.commandHistoryPosition));
    }
    public void commandHistoryPrevious()
    {
        if (currentDissi.commandHistoryPosition==0) return; // we have no further history
        if (currentDissi.commandHistory.isEmpty()) return;
        if (currentDissi.commandHistoryPosition==-1)  // we are not yet in  history
        {
            currentDissi.commandHistoryPosition = currentDissi.commandHistory.size()-1;
            jTextFieldCommand.setText(currentDissi.commandHistory.get(currentDissi.commandHistoryPosition));
            return;
        }
        currentDissi.commandHistoryPosition--;
        jTextFieldCommand.setText(currentDissi.commandHistory.get(currentDissi.commandHistoryPosition));
    }
    
    private void jTextFieldCommandActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldCommandActionPerformed
        if (currentDissi != null)
        {
            currentDissi.commandHistoryPosition = -1;
            currentDissi.commandHistory.add(jTextFieldCommand.getText());
        }
        String command = jTextFieldCommand.getText();
        jTextFieldCommand.setText("");
        executeCommand(command.trim());
    }//GEN-LAST:event_jTextFieldCommandActionPerformed

    int spaceTo(StringBuilder s, int posNow, int upTo)
    {
        s.append(" ");posNow++; //at least 1;
        while (posNow++<upTo) s.append(" ");
        return posNow;
    }
    void outputBIOS()
    {
        if (currentDissi.loadedName==null) return;
        if (currentDissi.loadedName.trim().length()==0) return;
        
        {
            StringBuilder s = new StringBuilder();
            int start = 0xf000;
            int end = 0xffff;
            ArrayList<String> comments;
            ArrayList<String> labels;
            HashMap<String, String> doneLabels = new HashMap<String, String>();
            int dp = 0;
            int brokenLength = 0;
            boolean breakable = false;
            int c = 0;
            spaceTo(s, c, TAB_MNEMONIC);
            s.append(" noopt ").append("\n");

            for (int m = start; m<end; )
            {
                /*
                if (m==0x0765)
                    System.out.println("");
                */
                breakable = false;
                c = 0;
                MemoryInformation memInfo = getMemory().memMap.get(m);
                int length = memInfo.length;
                if (memInfo.disType == MemoryInformation.DIS_TYPE_DATA_BINARY) breakable = true;
                if (memInfo.disType == MemoryInformation.DIS_TYPE_DATA_BYTE) breakable = true;
                if (memInfo.disType == MemoryInformation.DIS_TYPE_DATA_CHAR) breakable = true;
                if (memInfo.disType == MemoryInformation.DIS_TYPE_DATA_WORD) breakable = true;
                if (memInfo.disType == MemoryInformation.DIS_TYPE_DATA_WORD_POINTER) breakable = true;

                if (memInfo.directPageAddress != dp)
                {
                    dp = memInfo.directPageAddress;
                    spaceTo(s, c, TAB_MNEMONIC);
                    s.append("direct $").append(String.format("%02X",((byte)memInfo.directPageAddress)) ).append("\n");
                    c=0;
                }
                if (memInfo.memType == MEM_TYPE_ROM)
                {
                    if (memInfo.disType == DIS_TYPE_UNKOWN) 
                    {
                        m++;
                        continue;
                    }
                    comments = memInfo.comments;
                    labels = memInfo.labels;
                    if (comments.size()>1)
                    {
                        for (int i=1; i<comments.size(); i++)
                        {
                            s.append("; ").append(comments.get(i)).append("\n");
                        }
                    }
                    if (labels.size()>0)
                    {
                        for (int i=0; i<labels.size(); i++)
                        {
                            s.append(labels.get(i)).append(":\n");
                            doneLabels.put(labels.get(i), labels.get(i));
                        }
                    }

                    c=spaceTo(s, c, TAB_MNEMONIC);
                    s.append(memInfo.disassembledMnemonic);
                    c+=memInfo.disassembledMnemonic.length();

                    c=spaceTo(s, c, TAB_OP);
                    s.append(memInfo.disassembledOperand);
                    c+=memInfo.disassembledOperand.length();

                    if (comments.size()>0)
                    {
                        spaceTo(s, c, TAB_COMMENT);
                        String cc = comments.get(0);
                        s.append("; ").append(cc);
                        if (!cc.endsWith("\n"))
                            s.append("\n");
                    }
                    else
                    {
                        s.append("\n");
                    }
                    m+=length;
                    if (length==0) m++;
                }
                else
                {
                    m++;
                }
            }
            StringBuilder s2 = new StringBuilder();
            for (int m = 0; m<65536; m++)
            {
                MemoryInformation memInfo = getMemory().memMap.get(m);
                labels = memInfo.labels;
                if (labels.size()>0)
                {
                    for (int i=0; i<labels.size(); i++)
                    {
                        if (doneLabels.get(labels.get(i)) == null)
                        {
                            c=0;
                            doneLabels.put(labels.get(i), labels.get(i));
                            s2.append(labels.get(i));
                            c+=labels.get(i).length();
                            c=spaceTo(s2, c, TAB_EQU);
                            s2.append("EQU");
                            c+=3;
                            spaceTo(s2, c, TAB_EQU_VALUE);
                            s2.append(String.format("$%04X",memInfo.address )).append("\n");
                        }
                    }
                }
                labels = memInfo.immediateLabels;
                if (labels.size()>0)
                {
                    for (int i=0; i<labels.size(); i++)
                    {
                        if (doneLabels.get(labels.get(i)) == null)
                        {
                            c=0;
                            doneLabels.put(labels.get(i), labels.get(i));
                            s2.append(labels.get(i));
                            c+=labels.get(i).length();
                            c=spaceTo(s2, c, TAB_EQU);
                            s2.append("EQU");
                            c+=3;
                            spaceTo(s2, c, TAB_EQU_VALUE);
                            s2.append(String.format("$%04X",memInfo.address )).append("\n");
                        }

                    }
                }
                // and all direct labels!
                Iterator it = getMemory().directLabels.entrySet().iterator();
                while (it.hasNext()) 
                {
                    Map.Entry pair = (Map.Entry)it.next();
                    int directPageHi = (Integer) pair.getKey();
                    HashMap<Integer, MemoryInformation> entries = (HashMap<Integer, MemoryInformation>) pair.getValue();

                    Iterator it2 = entries.entrySet().iterator();
                    while (it2.hasNext()) 
                    {
                        Map.Entry pair2 = (Map.Entry)it2.next();
                        int directPageLo = (Integer) pair2.getKey();
                        String directLabel = (String)pair2.getValue();
                        if (doneLabels.get(directLabel) == null)
                        {
                            int value = directPageHi*256+directPageLo;
                            c=0;
                            doneLabels.put(directLabel, directLabel);
                            s2.append(directLabel);
                            c+=directLabel.length();
                            c=spaceTo(s2, c, TAB_EQU);
                            s2.append("EQU");
                            c+=3;
                            spaceTo(s2, c, TAB_EQU_VALUE);
                            s2.append(String.format("$%04X",value )).append("  ; DP accessed\n");
                        }
                    }
                }
            }
            s2.append(s);
            try
            {
                String name = currentDissi.loadedName;
                int li = name.lastIndexOf(".");
                if (li<0) return;
                name = name.substring(0,li)+".dasm.asm";
                PrintWriter out = new PrintWriter(name);
                out.println(s2.toString());
                out.close();
                printMessage("DASM output saved to \""+name+"\"", MESSAGE_INFO);
            }
            catch (Throwable e)
            {
                printMessage("Error saving DASM file...", MESSAGE_ERR);
            }        
        }
    }
    void outputDASM()
    {
        if (currentDissi.loadedName==null) return;
        if (currentDissi.loadedName.trim().length()==0) return;
        
        int currentBank = getMemory().currentBank;
// todo disasm olny to loadlen        int loadLen = ;
        for (int b = 0; b<getMemory().maxBank; b++)
        {
            StringBuilder s = new StringBuilder();
            int start = 0;
            int end = 0xc000;
            ArrayList<String> comments;
            ArrayList<String> labels;
            HashMap<String, String> doneLabels = new HashMap<String, String>();
            int dp = 0;
            int brokenLength = 0;
            boolean breakable = false;
            int c = 0;
            getMemory().setBank(b);
            spaceTo(s, c, TAB_MNEMONIC);
            s.append("bank ").append(b).append("\n");
            s.append(" noopt ").append("\n");

            for (int m = start; m<end; )
            {
                /*
                if (m==0x0765)
                    System.out.println("");
                */
                breakable = false;
                c = 0;
                MemoryInformation memInfo = getMemory().memMap.get(m);
                int length = memInfo.length;
                if (memInfo.disType == MemoryInformation.DIS_TYPE_DATA_BINARY) breakable = true;
                if (memInfo.disType == MemoryInformation.DIS_TYPE_DATA_BYTE) breakable = true;
                if (memInfo.disType == MemoryInformation.DIS_TYPE_DATA_CHAR) breakable = true;
                if (memInfo.disType == MemoryInformation.DIS_TYPE_DATA_WORD) breakable = true;
                if (memInfo.disType == MemoryInformation.DIS_TYPE_DATA_WORD_POINTER) breakable = true;

                if (memInfo.directPageAddress != dp)
                {
                    dp = memInfo.directPageAddress;
                    spaceTo(s, c, TAB_MNEMONIC);
                    s.append("direct $").append(String.format("%02X",((byte)memInfo.directPageAddress)) ).append("\n");
                    c=0;
                }
                if (memInfo.memType == MEM_TYPE_ROM)
                {
                    if (memInfo.disType == DIS_TYPE_UNKOWN) 
                    {
                        m++;
                        continue;
                    }
                    comments = memInfo.comments;
                    labels = memInfo.labels;
                    if (comments.size()>1)
                    {
                        for (int i=1; i<comments.size(); i++)
                        {
                            s.append("; ").append(comments.get(i)).append("\n");
                        }
                    }
                    if (labels.size()>0)
                    {
                        for (int i=0; i<labels.size(); i++)
                        {
                            s.append(labels.get(i)).append(":\n");
                            doneLabels.put(labels.get(i), labels.get(i));
                        }
                    }

                    c=spaceTo(s, c, TAB_MNEMONIC);
                    s.append(memInfo.disassembledMnemonic);
                    c+=memInfo.disassembledMnemonic.length();

                    c=spaceTo(s, c, TAB_OP);
                    s.append(memInfo.disassembledOperand);
                    c+=memInfo.disassembledOperand.length();

                    if (comments.size()>0)
                    {
                        spaceTo(s, c, TAB_COMMENT);
                        String cc = comments.get(0);
                        s.append("; ").append(cc);
                        if (!cc.endsWith("\n"))
                            s.append("\n");
                    }
                    else
                    {
                        s.append("\n");
                    }
                    m+=length;
                    if (length==0) m++;
                }
                else
                {
                    m++;
                }
            }
            StringBuilder s2 = new StringBuilder();
            for (int m = 0; m<65536; m++)
            {
                MemoryInformation memInfo = getMemory().memMap.get(m);
                labels = memInfo.labels;
                if (labels.size()>0)
                {
                    for (int i=0; i<labels.size(); i++)
                    {
                        if (doneLabels.get(labels.get(i)) == null)
                        {
                            c=0;
                            doneLabels.put(labels.get(i), labels.get(i));
                            s2.append(labels.get(i));
                            c+=labels.get(i).length();
                            c=spaceTo(s2, c, TAB_EQU);
                            s2.append("EQU");
                            c+=3;
                            spaceTo(s2, c, TAB_EQU_VALUE);
                            s2.append(String.format("$%04X",memInfo.address )).append("\n");
                        }
                    }
                }
                labels = memInfo.immediateLabels;
                if (labels.size()>0)
                {
                    for (int i=0; i<labels.size(); i++)
                    {
                        if (doneLabels.get(labels.get(i)) == null)
                        {
                            c=0;
                            doneLabels.put(labels.get(i), labels.get(i));
                            s2.append(labels.get(i));
                            c+=labels.get(i).length();
                            c=spaceTo(s2, c, TAB_EQU);
                            s2.append("EQU");
                            c+=3;
                            spaceTo(s2, c, TAB_EQU_VALUE);
                            s2.append(String.format("$%04X",memInfo.address )).append("\n");
                        }

                    }
                }
                // and all direct labels!
                Iterator it = getMemory().directLabels.entrySet().iterator();
                while (it.hasNext()) 
                {
                    Map.Entry pair = (Map.Entry)it.next();
                    int directPageHi = (Integer) pair.getKey();
                    HashMap<Integer, MemoryInformation> entries = (HashMap<Integer, MemoryInformation>) pair.getValue();

                    Iterator it2 = entries.entrySet().iterator();
                    while (it2.hasNext()) 
                    {
                        Map.Entry pair2 = (Map.Entry)it2.next();
                        int directPageLo = (Integer) pair2.getKey();
                        String directLabel = (String)pair2.getValue();
                        if (doneLabels.get(directLabel) == null)
                        {
                            int value = directPageHi*256+directPageLo;
                            c=0;
                            doneLabels.put(directLabel, directLabel);
                            s2.append(directLabel);
                            c+=directLabel.length();
                            c=spaceTo(s2, c, TAB_EQU);
                            s2.append("EQU");
                            c+=3;
                            spaceTo(s2, c, TAB_EQU_VALUE);
                            s2.append(String.format("$%04X",value )).append("  ; DP accessed\n");
                        }
                    }
                }
            }
            s2.append(s);
            try
            {
                String name = currentDissi.loadedName;
                int li = name.lastIndexOf(".");
                if (li<0) return;
                name = name.substring(0,li)+"."+b+".dasm.asm";
                PrintWriter out = new PrintWriter(name);
                out.println(s2.toString());
                out.close();
                printMessage("DASM output saved to \""+name+"\"", MESSAGE_INFO);
            }
            catch (Throwable e)
            {
                printMessage("Error saving DASM file...", MESSAGE_ERR);
            }        
        }
        getMemory().setBank(currentBank);

    }
    void outputDASMShort()
    {
        if (currentDissi.loadedName==null) return;
        if (currentDissi.loadedName.trim().length()==0) return;
        StringBuilder s = new StringBuilder();
        int start = 0;
        int end = 0xc000;
        ArrayList<String> comments;
        ArrayList<String> labels;
        HashMap<String, Integer> doneLabels = new HashMap<String, Integer>();

        
        for (int m = 0; m<65536; m++)
        {
            MemoryInformation memInfo = getMemory().memMap.get(m);
            labels = memInfo.labels;
            if (labels.size()>0)
            {
                for (int i=0; i<labels.size(); i++)
                {
                    if (doneLabels.get(labels.get(i).trim()) == null)
                        doneLabels.put(labels.get(i).trim(), memInfo.address);
                    
                }
            }
            labels = memInfo.immediateLabels;
            if (labels.size()>0)
            {
                for (int i=0; i<labels.size(); i++)
                {
                    if (doneLabels.get(labels.get(i).trim()) == null)
                        doneLabels.put(labels.get(i).trim(), memInfo.address);
                }
                
            }
        }        
        
        
        int dp = 0;
        for (int m = start; m<end; )
        {
            int c = 0;
            MemoryInformation memInfo = getMemory().memMap.get(m);
            if (memInfo.directPageAddress != dp)
            {
                dp = memInfo.directPageAddress;
                c=spaceTo(s, c, TAB_MNEMONIC);
                s.append("direct $").append(String.format("%02X",(byte)memInfo.directPageAddress )).append("\n");
            }
            if (memInfo.memType == MEM_TYPE_ROM)
            {
                if (memInfo.disType == DIS_TYPE_UNKOWN) 
                {
                    m++;
                    continue;
                }
                c=spaceTo(s, c, TAB_MNEMONIC);
                s.append(memInfo.disassembledMnemonic);
                c+=memInfo.disassembledMnemonic.length();
                c=spaceTo(s, c, TAB_OP);
                if (memInfo.disassembledMnemonic.equals("DB"))
                {
                    boolean first = true;
                    for (int i=0; i<memInfo.length; i++)
                    {
                        if (!first)s.append(", ");
                        s.append("$").append(String.format("%02X",getMemory().memMap.get(m+i).content ));
                        first = false;
                    }
                }
                else if (memInfo.disassembledMnemonic.equals("DW"))
                {
                    boolean first = true;
                    for (int i=0; i<memInfo.length; i+=2)
                    {
                        if (!first)s.append(", ");
                        s.append("$").append(String.format("%04X",((getMemory().memMap.get(m+i).content*256)+(getMemory().memMap.get(m+i+1).content*256) )& 0xffff));
                        first = false;
                    }
                }
                else
                {
                    s.append(operandToNumber(memInfo.disassembledOperand, doneLabels));
                    c+=memInfo.disassembledOperand.length();
                }
                
                
                s.append("\n");
                m+=memInfo.length;
                if (memInfo.length==0) m++;
            }
            else
            {
                m++;
            }
        }
        
        try
        {
            String name = currentDissi.loadedName;
            int li = name.lastIndexOf(".");
            if (li<0) return;
            name = name.substring(0,li)+".dasm";

            
            
            PrintWriter out = new PrintWriter(name);
            out.println(s.toString());
            out.close();
            printMessage("DASM output saved to \""+name+"\"", MESSAGE_INFO);
        }
        catch (Throwable e)
        {
            printMessage("Error saving DASM file...", MESSAGE_ERR);
        }
    }
    String operandToNumber(String op, HashMap<String, Integer> doneLabels)
    {
        if (op.length()==0) return"";
        String pre = "";
        String post = "";
        op = de.malban.util.UtilityString.replace(op, "$", "");
        if (op.startsWith("#")) 
        {
            pre += "#";
            op = op.substring(1);
        }
        if (op.startsWith("<")) 
        {
            pre += "<";
            op = op.substring(1);
        }
        if (op.startsWith("[")) 
        {
            pre += "[";
            op = op.substring(1);
        }
        if (op.startsWith("<")) 
        {
            pre += "<";
            op = op.substring(1);
        }
        if (op.startsWith(">")) 
        {
            pre += ">";
            op = op.substring(1);
        }
        if (op.indexOf(",")!=-1)
        {
            post += op.substring(op.indexOf(","));
            op = op.substring(0, op.indexOf(","));
        }
        if (op.indexOf("]")!=-1)
        {
            post = op.substring(op.indexOf("]"))+post;
            op = op.substring(0, op.indexOf("]"));
        }
        
        Integer adr = doneLabels.get(op);
        if (adr != null)
        {
            return pre+String.format("$%04X",adr)+post;
        }
        boolean dollar = true;
        if (op.trim().length()==0)
            dollar = false;
            else
        if (post.contains(","))
        {
            {
                if (op.toLowerCase().equals("a")) dollar = false;
                if (op.toLowerCase().equals("b")) dollar = false;
                if (op.toLowerCase().equals("d")) dollar = false;
                if (op.toLowerCase().equals("x")) dollar = false;
                if (op.toLowerCase().equals("y")) dollar = false;
                if (op.toLowerCase().equals("s")) dollar = false;
                if (op.toLowerCase().equals("u")) dollar = false;
                if (op.toLowerCase().equals("pc")) dollar = false;
                if (op.toLowerCase().equals("dp")) dollar = false;
            }
        }
            
        if (dollar)
            return de.malban.util.UtilityString.replace(pre+"$"+op+post, "$-", "-$") ;
        return pre+op+post;
    }
    
    
    private void jButtonDASMOutputActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonDASMOutputActionPerformed
        if ((evt != null ) && ((evt.getModifiers() & SHIFT_MASK) == SHIFT_MASK))
            outputDASMShort();
        if ((evt != null ) && ((evt.getModifiers() & CTRL_MASK) == CTRL_MASK))
            outputBIOS();
        else
            outputDASM();
        
        
        

    }//GEN-LAST:event_jButtonDASMOutputActionPerformed

    private void jCheckBox3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox3ActionPerformed
        
        correctModel();
    }//GEN-LAST:event_jCheckBox3ActionPerformed

    private void jTextFieldSearch1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldSearch1ActionPerformed
        currentDissi.model.setHighliteLabel(jTextFieldSearch1.getText());
        updateTableOnly();
    }//GEN-LAST:event_jTextFieldSearch1ActionPerformed

    private void jButtonSearchNext2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSearchNext2ActionPerformed
   
        currentDissi.model.setHighliteLabel(jTextFieldSearch1.getText());
        updateTableOnly();
    }//GEN-LAST:event_jButtonSearchNext2ActionPerformed

    private void jButtonApplyCodeScanActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonApplyCodeScanActionPerformed
        reset();
    }//GEN-LAST:event_jButtonApplyCodeScanActionPerformed

    private void jButtonCNTOutputActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonCNTOutputActionPerformed
        outputCNT();
    }//GEN-LAST:event_jButtonCNTOutputActionPerformed

    private void jButtonShowPSGActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonShowPSGActionPerformed
        if (currentDissi.vecxPanel==null) return;
        currentDissi.vecxPanel.showPSG();
    }//GEN-LAST:event_jButtonShowPSGActionPerformed

    private void jButtonShowBreakpointsActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonShowBreakpointsActionPerformed
        if (currentDissi.vecxPanel==null) return;
        currentDissi.vecxPanel.showBreakpoints();
    }//GEN-LAST:event_jButtonShowBreakpointsActionPerformed

    private void jMenuItem8ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem8ActionPerformed
        updateToNewDP(0xca);
    }//GEN-LAST:event_jMenuItem8ActionPerformed

    private void jMenuItem9ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem9ActionPerformed
        updateToNewDP(0xcb);
    }//GEN-LAST:event_jMenuItem9ActionPerformed

    private void jButtonVectrorScreenshotActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonVectrorScreenshotActionPerformed
        currentDissi.vecxPanel.vectorScreenshot();
    }//GEN-LAST:event_jButtonVectrorScreenshotActionPerformed

    private void jMenuItem10ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem10ActionPerformed
        joinData(7);
    }//GEN-LAST:event_jMenuItem10ActionPerformed

    private void jMenuItem11ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem11ActionPerformed
        joinData(8);
    }//GEN-LAST:event_jMenuItem11ActionPerformed

    private void jMenuItem12ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem12ActionPerformed
        joinData(9);
    }//GEN-LAST:event_jMenuItem12ActionPerformed

    private void jMenuItem13ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem13ActionPerformed
        joinData(10);
    }//GEN-LAST:event_jMenuItem13ActionPerformed

    private void jMenuItem14ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem14ActionPerformed
        joinData(11);
    }//GEN-LAST:event_jMenuItem14ActionPerformed

    private void jMenuItem15ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem15ActionPerformed
        joinData(12);
    }//GEN-LAST:event_jMenuItem15ActionPerformed

    private void jMenuItemBinaryActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemBinaryActionPerformed
        updateToNewType(MemoryInformation.DIS_TYPE_DATA_BINARY, 1);
    }//GEN-LAST:event_jMenuItemBinaryActionPerformed

    private void jMenuItemLabelAsDataActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemLabelAsDataActionPerformed
        int[] selected = jTableSource.getSelectedRows();
        MemoryInformationTableModel model = (MemoryInformationTableModel) jTableSource.getModel();
        for (int row: selected)
        {
            MemoryInformation memInfo = model.getValueAt(row);
            
            memInfo.immediateLabels.clear();
            if (memInfo.labels.size() == 0)
            {
                memInfo.immediateLabels.add("_"+String.format("%04X",memInfo.address ));
            }
            else
            {
                for (String l: memInfo.labels)
                {
                    memInfo.immediateLabels.add(l);
                }
            }
        }                
        completeUpdate();
    }//GEN-LAST:event_jMenuItemLabelAsDataActionPerformed

    private void jTableSourceMouseReleased(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jTableSourceMouseReleased
  //      selectionChanged();
    }//GEN-LAST:event_jTableSourceMouseReleased

    private void jTableSourceMouseDragged(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jTableSourceMouseDragged
        selectionChanged();
    }//GEN-LAST:event_jTableSourceMouseDragged

    int getPopupWatchAddress()
    {
        MemoryInformation memInfo = currentDissi.model.getValueAt(popupRow);
        String adr = (String) currentDissi.model.getValueAt( popupRow,  8); // address

        if (memInfo.disassembledMnemonic.toLowerCase().contains("lb")) return -1; // long RELATIV branch
        if (memInfo.disassembledMnemonic.toLowerCase().startsWith("b")) return -1; //  branch
        if (memInfo.disassembledMnemonic.toLowerCase().startsWith("j")) return -1; //  branch
        if (memInfo.disassembledMnemonic.toLowerCase().startsWith("p")) return -1; //  push pu
        if (memInfo.disassembledMnemonic.toLowerCase().contains("tfr")) return -1; // 
        if (memInfo.disassembledMnemonic.toLowerCase().contains("exg")) return -1; // 
        if (memInfo.disassembledMnemonic.toLowerCase().contains("lea")) return -1; // 

                
        String op = memInfo.disassembledOperand;
        if (memInfo.disassembledMnemonic.toLowerCase().contains(",")) return -1;
        if (op == null)  return -1;
        op = op.toLowerCase();
        op = de.malban.util.UtilityString.replace(op, "<", "");
        op = de.malban.util.UtilityString.replace(op, ">", "");
        op = de.malban.util.UtilityString.replace(op, "#", "");
        op = de.malban.util.UtilityString.replace(op, "$", "");
        if (op.length()==0) return -1;

        boolean bit8 = false;
        
        if (adr.trim().length() <1)
        {
            // check immediate
            int iadr = getLabelAddr(op.trim());
            if (iadr == 0)
            {
                iadr = getImmediateLabelAddr(op.trim());
            }
            if (iadr != 0) return iadr;
            return -1;
        }
        if (adr.trim().length() <=4) bit8 = true;

        int a = DASM6809.toNumber(adr);
        if (bit8) 
            a += memInfo.directPageAddress*256;
        return a;
    }
    private void jMenuItemWatchBinaryActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemWatchBinaryActionPerformed
        int adr = getPopupWatchAddress();
        if (adr == -1)
        {
            printMessage("Watch address not found!", MESSAGE_WARN);
            return;
        }
        int type = 0;
        int len = 0;
        Watch.addWatch(adr, type, len, this);
        correctTableWatch();
    }//GEN-LAST:event_jMenuItemWatchBinaryActionPerformed

    private void jMenuItemWatchByteActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemWatchByteActionPerformed
        int adr = getPopupWatchAddress();
        if (adr == -1)
        {
            printMessage("Watch address not found!", MESSAGE_WARN);
            return;
        }
        int type = 1;
        int len = 0;
        Watch.addWatch(adr, type, len, this);
        correctTableWatch();
    }//GEN-LAST:event_jMenuItemWatchByteActionPerformed

    private void jMenuItemWatchWordActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemWatchWordActionPerformed
        int adr = getPopupWatchAddress();
        if (adr == -1)
        {
            printMessage("Watch address not found!", MESSAGE_WARN);
            return;
        }
        int type = 2;
        int len = 0;
        Watch.addWatch(adr, type, len, this);
        correctTableWatch();
    }//GEN-LAST:event_jMenuItemWatchWordActionPerformed

    private void jMenuItemWatchStringActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemWatchStringActionPerformed
        int adr = getPopupWatchAddress();
        if (adr == -1)
        {
            printMessage("Watch address not found!", MESSAGE_WARN);
            return;
        }
        int type = 3;
        int len = 0;
        Watch.addWatch(adr, type, len, this);
        correctTableWatch();
    }//GEN-LAST:event_jMenuItemWatchStringActionPerformed

    private void jMenuItemWatchBytePairActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemWatchBytePairActionPerformed
        int adr = getPopupWatchAddress();
        if (adr == -1)
        {
            printMessage("Watch address not found!", MESSAGE_WARN);
            return;
        }
        int type = 4;
        int len = 0;
        Watch.addWatch(adr, type, len, this);
        correctTableWatch();
    }//GEN-LAST:event_jMenuItemWatchBytePairActionPerformed

    private void jMenuItemWatchSequenceActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemWatchSequenceActionPerformed
        int adr = getPopupWatchAddress();
        if (adr == -1)
        {
            printMessage("Watch address not found!", MESSAGE_WARN);
            return;
        }
        int type = 5;
        int len = 5;
        Watch.addWatch(adr, type, len, this);
        correctTableWatch();
    }//GEN-LAST:event_jMenuItemWatchSequenceActionPerformed

    private void jMenuItem16ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem16ActionPerformed
        currentDissi.removeWatchbyIndex(popupRow);
        correctTableWatch();
    }//GEN-LAST:event_jMenuItem16ActionPerformed

    private void jTable1MousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jTable1MousePressed
        JTable table =(JTable) evt.getSource();
        Point p = evt.getPoint();
        int row = table.rowAtPoint(p);
        int col = table.columnAtPoint(p);
        if (evt.getButton() == MouseEvent.BUTTON3)
        {
            popupRow = row;
            jPopupMenu2.show(jTable1, evt.getX()-20,evt.getY()-20);
        }        
        if (currentDissi.vecxPanel==null) return;
    }//GEN-LAST:event_jTable1MousePressed

    private void jToggleButton3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jToggleButton3ActionPerformed
        updateRegEnabled = jToggleButton3.isSelected();
    }//GEN-LAST:event_jToggleButton3ActionPerformed

    private void jLabel14MousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel14MousePressed
        DissiPanel dissi = this;
        if (dissi.currentDissi == null) return;
        VecXPanel vecxPanel = dissi.currentDissi.vecxPanel; // needed for vectrex memory access
        if (vecxPanel == null) return;
        E6809 e6809 = vecxPanel.get6809();
        if (e6809 == null) return;

        if (vecxPanel==null) return;
        if (evt.getClickCount() == 2)
        if ((evt != null ) && ((evt.getModifiers() & SHIFT_MASK) == SHIFT_MASK))
            vecxPanel.setDumpToAddress(reg_x);
        else
          if (dissi != null) dissi.goAddress(reg_x, true, true, true);
    }//GEN-LAST:event_jLabel14MousePressed

    private void jLabel16MousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel16MousePressed
        DissiPanel dissi = this;
        if (dissi.currentDissi == null) return;
        VecXPanel vecxPanel = dissi.currentDissi.vecxPanel; // needed for vectrex memory access
        if (vecxPanel == null) return;
        E6809 e6809 = vecxPanel.get6809();
        if (e6809 == null) return;

        if (vecxPanel==null) return;
        if (evt.getClickCount() == 2)
        if ((evt != null ) && ((evt.getModifiers() & SHIFT_MASK) == SHIFT_MASK))
            vecxPanel.setDumpToAddress(reg_y);
        else
            if (dissi != null) dissi.goAddress(reg_y, true, true, true);
    }//GEN-LAST:event_jLabel16MousePressed

    private void jLabel20MousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel20MousePressed
        DissiPanel dissi = this;
        if (dissi.currentDissi == null) return;
        VecXPanel vecxPanel = dissi.currentDissi.vecxPanel; // needed for vectrex memory access
        if (vecxPanel == null) return;
        E6809 e6809 = vecxPanel.get6809();
        if (e6809 == null) return;

        if (vecxPanel==null) return;
        if (evt.getClickCount() == 2)
        if ((evt != null ) && ((evt.getModifiers() & SHIFT_MASK) == SHIFT_MASK))
            vecxPanel.setDumpToAddress(reg_u);
        else
            if (dissi != null) dissi.goAddress(reg_u, true, true, true);
    }//GEN-LAST:event_jLabel20MousePressed

    private void jLabel23MousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel23MousePressed
        DissiPanel dissi = this;
        if (dissi.currentDissi == null) return;
        VecXPanel vecxPanel = dissi.currentDissi.vecxPanel; // needed for vectrex memory access
        if (vecxPanel == null) return;
        E6809 e6809 = vecxPanel.get6809();
        if (e6809 == null) return;

        if (vecxPanel==null) return;
        
        if (evt.getClickCount() == 2)
        {
            if ((evt != null ) && ((evt.getModifiers() & SHIFT_MASK) == SHIFT_MASK))
                vecxPanel.setDumpToAddress(reg_pc);
            else
                if (dissi != null) dissi.goAddress(reg_pc, true, true,true );            
        }

    }//GEN-LAST:event_jLabel23MousePressed

    private void jLabel26MousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel26MousePressed
        DissiPanel dissi = this;
        if (dissi.currentDissi == null) return;
        VecXPanel vecxPanel = dissi.currentDissi.vecxPanel; // needed for vectrex memory access
        if (vecxPanel == null) return;
        E6809 e6809 = vecxPanel.get6809();
        if (e6809 == null) return;

        if (vecxPanel==null) return;
        if (evt.getClickCount() == 2)
        if ((evt != null ) && ((evt.getModifiers() & SHIFT_MASK) == SHIFT_MASK))
            vecxPanel.setDumpToAddress(reg_s);
        else
            if (dissi != null) dissi.goAddress(reg_s, true, true, true);
    }//GEN-LAST:event_jLabel26MousePressed

    private void jTable2MousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jTable2MousePressed
        DissiPanel dissi = this;
        if (dissi.currentDissi == null) return;
        VecXPanel vecxPanel = dissi.currentDissi.vecxPanel; // needed for vectrex memory access
        if (vecxPanel == null) return;
        E6809 e6809 = vecxPanel.get6809();
        if (e6809 == null) return;

        if (evt.getClickCount() == 2)
        {
            JTable table =(JTable) evt.getSource();
            Point p = evt.getPoint();
            int row = table.rowAtPoint(p);
            // your valueChanged overridden method
            if (dissi != null)
            dissi.goAddress(((CallStackTableModel)table.getModel()).getAddress(row), true, true, true);
        }
    }//GEN-LAST:event_jTable2MousePressed

    private void jButtonRinbufferUndo1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonRinbufferUndo1ActionPerformed
        if (currentDissi.vecxPanel==null) return;
            currentDissi.vecxPanel.debugFrameUndoAction(1);
        updateTableOnly();
    }//GEN-LAST:event_jButtonRinbufferUndo1ActionPerformed

    private void jButtonRingbufferRedo1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonRingbufferRedo1ActionPerformed
        if (currentDissi.vecxPanel==null) return;
            currentDissi.vecxPanel.debugFrameRedoAction(1);
        updateTableOnly();
    }//GEN-LAST:event_jButtonRingbufferRedo1ActionPerformed

    private void jButtonWRTracker1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonWRTracker1ActionPerformed
        if (currentDissi.vecxPanel==null) return;
        currentDissi.vecxPanel.showProfiling();
    }//GEN-LAST:event_jButtonWRTracker1ActionPerformed

    private void jMenuItemWord1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemWord1ActionPerformed
        updateToNewType(MemoryInformation.DIS_TYPE_DATA_WORD_POINTER, 2);
    }//GEN-LAST:event_jMenuItemWord1ActionPerformed

    private void jTableStackMousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jTableStackMousePressed
        // TODO add your handling code here:
    }//GEN-LAST:event_jTableStackMousePressed

    private int searchForString(int start, String text, boolean forward)
    {
        int foundAt = -1;
        int addi = forward?1:-1;
            
        for (int i=start; (((i&0xffff) !=0) || (i==start)); i+=addi)
        {
            MemoryInformation memInfo =  currentDissi.dasm.myMemory.memMap.get(i);
            
            for (String l: memInfo.labels)
            {
                if (l.toLowerCase().contains(text.toLowerCase()))
                {
                    foundAt = i;
                    jLabel3.setVisible(true);
                    jLabel3.setForeground(config.valueNotChanged);
                    jLabel3.setText("Found in label at: " + String.format("$%04X",i&0xffff ));
                    break;
                }
            }
            if (foundAt!=-1) break;
            for (String c: memInfo.comments)
            {
                if (c.toLowerCase().contains(text.toLowerCase()))
                {
                    foundAt = i;
                    jLabel3.setVisible(true);
                    jLabel3.setForeground(config.valueNotChanged);
                    jLabel3.setText("Found in comment at: " + String.format("$%04X",i&0xffff ));
                    break;
                }
            }
            if (foundAt!=-1) break;
            if(memInfo.isCInfo())
            {
                if (memInfo.cInfo != null)
                    if (memInfo.cInfo.lineString.toLowerCase().contains(text.toLowerCase()))
                    {
                        foundAt = i;
                        jLabel3.setVisible(true);
                        jLabel3.setForeground(config.valueNotChanged);
                        jLabel3.setText("Found in label at: " + String.format("$%04X",i&0xffff ));
                        break;
                    }
            }
            if (foundAt!=-1) break;
        }
        if (foundAt == -1)
        {
            jLabel3.setVisible(true);
            jLabel3.setForeground(config.valueChanged);
            jLabel3.setText("not found");
        }

        return foundAt;
    }
    void updateToNewDP(int dp)
    {
        int[] selected = jTableSource.getSelectedRows();
        MemoryInformationTableModel model = (MemoryInformationTableModel) jTableSource.getModel();
        
        int max = 0;
        int end = 0;
        for (int row: selected)
        {
            MemoryInformation memInfo = model.getValueAt(row);
            int len = memInfo.length;
            for (int a=memInfo.address; a<memInfo.address+len; a++)
            {
                // join / ungroup makes no sense for NON code
                if (currentDissi.dasm.myMemory.memMap.get(a).disType <MemoryInformation.DIS_TYPE_DATA_INSTRUCTION_1_LENGTH) continue;

                currentDissi.dasm.myMemory.memMap.get(a).directPageAddress = dp;

                currentDissi.dasm.myMemory.memMap.get(a).disType = MemoryInformation.DIS_TYPE_DATA_INSTRUCTION_GENERAL;
                currentDissi.dasm.myMemory.memMap.get(a).belongsToInstruction = null;
                currentDissi.dasm.myMemory.memMap.get(a).disassembledMnemonic = "";
                currentDissi.dasm.myMemory.memMap.get(a).disassembledOperand = "";
                currentDissi.dasm.myMemory.memMap.get(a).page = -1;
                currentDissi.dasm.myMemory.memMap.get(a).hexDump = "";
                currentDissi.dasm.myMemory.memMap.get(a).isInstructionByte = 0;
                currentDissi.dasm.myMemory.memMap.get(a).referingToAddress = -1;
                currentDissi.dasm.myMemory.memMap.get(a).referingAddressMode = -1;
                currentDissi.dasm.myMemory.memMap.get(a).length = 1;
                currentDissi.dasm.myMemory.memMap.get(a).done = false;
                currentDissi.dasm.myMemory.memMap.get(a).familyBytes.clear();
                
            }
            end = memInfo.address+len;
        }        
        
        currentDissi.dasm.reDisassemble(end>0xe000);
        updateTable();                    
    }
    void updateToNewType(int type, int l)
    {
        int[] selected = jTableSource.getSelectedRows();
        updateToNewType(type, l, selected);
    }
    void updateToNewType(int type, int l, int[] selected)
    {
        MemoryInformationTableModel model = (MemoryInformationTableModel) jTableSource.getModel();
        int end = 0;
        int start = -1;
        int lastCollection = -1;
        int previousLength=-1;
        int previousStart=-1;
        for (int row: selected)
        {
            MemoryInformation memInfo = model.getValueAt(row);
            int len = memInfo.length;
            if (memInfo.disType <DIS_TYPE_DATA_INSTRUCTION_1_LENGTH)
            {
                if (memInfo.disTypeCollectionMax>len)
                    len = memInfo.disTypeCollectionMax;
            }
            boolean didRam = false;
            
            for (int a=memInfo.address; a<memInfo.address+len; a++)
            {
                if (start == -1) start = memInfo.address;
                
                if ((!didRam) && ( (memInfo.address>0xc7ff) &&  (memInfo.address<0xcc00) ))
                {
                    didRam = true;
                    initRAM();
                }
                
                lastCollection = currentDissi.dasm.myMemory.memMap.get(a).disTypeCollectionMax;
                if (type==DIS_TYPE_DATA_INSTRUCTION_GENERAL)
                    resetFollowers(currentDissi.dasm.myMemory.memMap.get(a));
                
                currentDissi.dasm.myMemory.memMap.get(a).disType = type;
                currentDissi.dasm.myMemory.memMap.get(a).belongsToInstruction = null;
                currentDissi.dasm.myMemory.memMap.get(a).disassembledMnemonic = "";
                currentDissi.dasm.myMemory.memMap.get(a).disassembledOperand = "";
                currentDissi.dasm.myMemory.memMap.get(a).page = -1;
                currentDissi.dasm.myMemory.memMap.get(a).hexDump = "";
                currentDissi.dasm.myMemory.memMap.get(a).isInstructionByte = 0;
                currentDissi.dasm.myMemory.memMap.get(a).referingToAddress = -1;
                currentDissi.dasm.myMemory.memMap.get(a).referingAddressMode = -1;
                currentDissi.dasm.myMemory.memMap.get(a).length = l;
                currentDissi.dasm.myMemory.memMap.get(a).done = false;
                currentDissi.dasm.myMemory.memMap.get(a).familyBytes.clear();
            }
            end = memInfo.address+len;
        }
        if (type==DIS_TYPE_DATA_INSTRUCTION_GENERAL)
        {
            int len = 4; // max code len possible
            for (int a=end; a<end+len; a++)
            {
                resetFollowers(currentDissi.dasm.myMemory.memMap.get(a));
            }        
        }
        else if ((type==DIS_TYPE_DATA_WORD) || (type==DIS_TYPE_DATA_WORD_POINTER))
        {
            int ll = 2;
            
            if (lastCollection!=-1)
            {
                // test next memory addresses if they are now "lose" ends (befor they were part of a group +1, and now the old group is gone.
                // if that is so, a new group must be build
                boolean done = false;
                int a = end;
                int dif = end - start;
                int rest = dif % ll;

                int newStart = start+((end - start)/ll)*ll;
                if (rest != 0) newStart+=ll;


                if (rest >0)
                {

                    rest = ll - rest;
                    int todo = lastCollection -rest;
                    if (todo>0)
                    {
                        MemoryInformation memInfo = currentDissi.dasm.myMemory.memMap.get(newStart);
                        memInfo.disTypeCollectionMax = todo;
                        memInfo.disassembledMnemonic = "";
                        memInfo.disassembledOperand = "";
                        memInfo.page = -1;
                        memInfo.hexDump = "";
                        memInfo.isInstructionByte = 0;
                        memInfo.referingToAddress = -1;
                        memInfo.referingAddressMode = -1;
                        memInfo.length = 1;
                        memInfo.done = false;
                        memInfo.familyBytes.clear();
                    }
                }
            }
        }
        
        currentDissi.dasm.reDisassemble(end>0xc000);
        updateTable();        
    }
    void resetToCode(int addressNotCode, int addressToCode)
    {
        // step a reset old data
        Memory mem = currentDissi.dasm.myMemory;
        MemoryInformation memInfo = mem.memMap.get(addressNotCode);
        int end = 0;
        int start = -1;
        int lastCollection = -1;

        int len = memInfo.length;
        if (memInfo.disType <DIS_TYPE_DATA_INSTRUCTION_1_LENGTH)
        {
            if (memInfo.disTypeCollectionMax>len)
                len = memInfo.disTypeCollectionMax;
        }

        for (int a=memInfo.address; a<memInfo.address+len; a++)
        {
            if (start == -1) start = memInfo.address;
            lastCollection = currentDissi.dasm.myMemory.memMap.get(a).disTypeCollectionMax;

            currentDissi.dasm.myMemory.memMap.get(a).disType = DIS_TYPE_DATA_BYTE;
            currentDissi.dasm.myMemory.memMap.get(a).belongsToInstruction = null;
            currentDissi.dasm.myMemory.memMap.get(a).disassembledMnemonic = "";
            currentDissi.dasm.myMemory.memMap.get(a).disassembledOperand = "";
            currentDissi.dasm.myMemory.memMap.get(a).page = -1;
            currentDissi.dasm.myMemory.memMap.get(a).hexDump = "";
            currentDissi.dasm.myMemory.memMap.get(a).isInstructionByte = 0;
            currentDissi.dasm.myMemory.memMap.get(a).referingToAddress = -1;
            currentDissi.dasm.myMemory.memMap.get(a).referingAddressMode = -1;
            currentDissi.dasm.myMemory.memMap.get(a).length = 1;
            currentDissi.dasm.myMemory.memMap.get(a).done = false;
            currentDissi.dasm.myMemory.memMap.get(a).familyBytes.clear();
        }
        end = memInfo.address+len;
        
        // step b set new code
        memInfo = mem.memMap.get(addressToCode);
        len = memInfo.length;
        if (memInfo.disType <DIS_TYPE_DATA_INSTRUCTION_1_LENGTH)
        {
            if (memInfo.disTypeCollectionMax>len)
                len = memInfo.disTypeCollectionMax;
        }

        for (int a=memInfo.address; a<memInfo.address+len; a++)
        {
            if (start == -1) start = memInfo.address;
            lastCollection = currentDissi.dasm.myMemory.memMap.get(a).disTypeCollectionMax;
            resetFollowers(currentDissi.dasm.myMemory.memMap.get(a));

            currentDissi.dasm.myMemory.memMap.get(a).disType = DIS_TYPE_DATA_INSTRUCTION_GENERAL;
            currentDissi.dasm.myMemory.memMap.get(a).belongsToInstruction = null;
            currentDissi.dasm.myMemory.memMap.get(a).disassembledMnemonic = "";
            currentDissi.dasm.myMemory.memMap.get(a).disassembledOperand = "";
            currentDissi.dasm.myMemory.memMap.get(a).page = -1;
            currentDissi.dasm.myMemory.memMap.get(a).hexDump = "";
            currentDissi.dasm.myMemory.memMap.get(a).isInstructionByte = 0;
            currentDissi.dasm.myMemory.memMap.get(a).referingToAddress = -1;
            currentDissi.dasm.myMemory.memMap.get(a).referingAddressMode = -1;
            currentDissi.dasm.myMemory.memMap.get(a).length = 1;
            currentDissi.dasm.myMemory.memMap.get(a).done = false;
            currentDissi.dasm.myMemory.memMap.get(a).familyBytes.clear();
        }
        end = memInfo.address+len;
        len = 4; // max code len possible
        for (int a=end; a<end+len; a++)
        {
            resetFollowers(currentDissi.dasm.myMemory.memMap.get(a));
        }        
        currentDissi.dasm.reDisassemble(end>0xe000);
        updateTable();        
    }

    void resetFollowers(MemoryInformation memInfo)
    {
        
        if (memInfo.disassembledOperand.length() == 0) return;
        // of 0, than changing this one does not change followers
        
        int len =  memInfo.length;
        if (memInfo.disType <DIS_TYPE_DATA_INSTRUCTION_1_LENGTH)
        {
            if (memInfo.disTypeCollectionMax>len)
                len = memInfo.disTypeCollectionMax;
        }
        for (int a=0; a<len;a++)
        {
            currentDissi.dasm.myMemory.memMap.get(memInfo.address+a).disTypeCollectionMax = 1;
            currentDissi.dasm.myMemory.memMap.get(memInfo.address+a).belongsToInstruction = null;
            currentDissi.dasm.myMemory.memMap.get(memInfo.address+a).disassembledMnemonic = "";
            currentDissi.dasm.myMemory.memMap.get(memInfo.address+a).disassembledOperand = "";
            currentDissi.dasm.myMemory.memMap.get(memInfo.address+a).page = -1;
            currentDissi.dasm.myMemory.memMap.get(memInfo.address+a).hexDump = "";
            currentDissi.dasm.myMemory.memMap.get(memInfo.address+a).isInstructionByte = 0;
            currentDissi.dasm.myMemory.memMap.get(memInfo.address+a).referingToAddress = -1;
            currentDissi.dasm.myMemory.memMap.get(memInfo.address+a).referingAddressMode = -1;
            currentDissi.dasm.myMemory.memMap.get(memInfo.address+a).length = 1;
            currentDissi.dasm.myMemory.memMap.get(memInfo.address+a).done = false;
            currentDissi.dasm.myMemory.memMap.get(memInfo.address+a).familyBytes.clear();
        }
        
    }
    
    
    private void joinData(int ll)
    {
        int[] selected = jTableSource.getSelectedRows();
        if (selected.length == 0) return;
        MemoryInformationTableModel model = (MemoryInformationTableModel) jTableSource.getModel();
        int end = 0;
        int start = -1;
        int lastCollection = -1;
        
        // first reset "all" data
        for (int row: selected)
        {
            MemoryInformation memInfo = model.getValueAt(row);
            int len = memInfo.length;
            for (int a=memInfo.address; a<memInfo.address+len; a++)
            {
                if (start == -1) start = memInfo.address;
                // join / ungroup makes no sense for code
                if (currentDissi.dasm.myMemory.memMap.get(a).disType >=MemoryInformation.DIS_TYPE_DATA_INSTRUCTION_1_LENGTH) continue;
                
                lastCollection = currentDissi.dasm.myMemory.memMap.get(a).disTypeCollectionMax;
                currentDissi.dasm.myMemory.memMap.get(a).disTypeCollectionMax = ll;
                
                currentDissi.dasm.myMemory.memMap.get(a).disassembledMnemonic = "";
                currentDissi.dasm.myMemory.memMap.get(a).disassembledOperand = "";
                currentDissi.dasm.myMemory.memMap.get(a).page = -1;
                currentDissi.dasm.myMemory.memMap.get(a).hexDump = "";
                currentDissi.dasm.myMemory.memMap.get(a).isInstructionByte = 0;
                currentDissi.dasm.myMemory.memMap.get(a).referingToAddress = -1;
                currentDissi.dasm.myMemory.memMap.get(a).referingAddressMode = -1;
                currentDissi.dasm.myMemory.memMap.get(a).length = 1;
                currentDissi.dasm.myMemory.memMap.get(a).done = false;
                currentDissi.dasm.myMemory.memMap.get(a).familyBytes.clear();
            }
            end = memInfo.address+len;
        }

        if (lastCollection!=-1)
        {
            // test next memory addresses if they are now "lose" ends (befor they were part of a group +1, and now the old group is gone.
            // if that is so, a new group must be build
            boolean done = false;
            int a = end;

            int dif = end - start;

                    
            
            
            int rest = dif % ll;

            int newStart = start+((end - start)/ll)*ll;
            if (rest != 0) newStart+=ll;
            
            
            if (rest >0)
            {
                
                rest = ll - rest;
                int todo = lastCollection -rest;
                if (todo>0)
                {

                    MemoryInformation memInfo = currentDissi.dasm.myMemory.memMap.get(newStart);



                    memInfo.disTypeCollectionMax = todo;

                    memInfo.disassembledMnemonic = "";
                    memInfo.disassembledOperand = "";
                    memInfo.page = -1;
                    memInfo.hexDump = "";
                    memInfo.isInstructionByte = 0;
                    memInfo.referingToAddress = -1;
                    memInfo.referingAddressMode = -1;
                    memInfo.length = 1;
                    memInfo.done = false;
                    memInfo.familyBytes.clear();
                }
            }
            
            
            
            

            
        }

        
        
        currentDissi.dasm.reDisassemble(end>0xe000);

        updateTable();            
    }
    
    private void updateTable()
    {
        JViewport vp = (JViewport)jTableSource.getParent();
        Point pos = vp.getViewPosition();
        correctModel();
        vp.setViewPosition(pos);
        jTable1.repaint();
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton jButtonAdressBack;
    private javax.swing.JButton jButtonAdressForward;
    private javax.swing.JButton jButtonApplyCodeScan;
    private javax.swing.JButton jButtonCNTOutput;
    private javax.swing.JButton jButtonDASMOutput;
    private javax.swing.JButton jButtonDebug;
    private javax.swing.JButton jButtonDebugStep;
    private javax.swing.JButton jButtonDump1;
    private javax.swing.JButton jButtonMultiStep;
    private javax.swing.JButton jButtonOverstep;
    private javax.swing.JButton jButtonRinbufferUndo;
    private javax.swing.JButton jButtonRinbufferUndo1;
    private javax.swing.JButton jButtonRingbufferRedo;
    private javax.swing.JButton jButtonRingbufferRedo1;
    private javax.swing.JButton jButtonSearchNext;
    private javax.swing.JButton jButtonSearchNext2;
    private javax.swing.JButton jButtonSearchPrevious;
    private javax.swing.JButton jButtonShowBreakpoints;
    private javax.swing.JButton jButtonShowLabels;
    private javax.swing.JButton jButtonShowPSG;
    private javax.swing.JButton jButtonShowVars;
    private javax.swing.JButton jButtonStepOut;
    private javax.swing.JButton jButtonVectrorScreenshot;
    private javax.swing.JButton jButtonViai;
    private javax.swing.JButton jButtonWRTracker;
    private javax.swing.JButton jButtonWRTracker1;
    private javax.swing.JButton jButtonsetBreakpoint;
    private javax.swing.JCheckBox jCheckBox1;
    private javax.swing.JCheckBox jCheckBox2;
    private javax.swing.JCheckBox jCheckBox3;
    private javax.swing.JCheckBox jCheckBoxVectorSelect;
    private javax.swing.JEditorPane jEditorPane1;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel10;
    private javax.swing.JLabel jLabel11;
    private javax.swing.JLabel jLabel12;
    private javax.swing.JLabel jLabel13;
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
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JLabel jLabel6;
    private javax.swing.JLabel jLabel7;
    private javax.swing.JLabel jLabel8;
    private javax.swing.JLabel jLabel9;
    private javax.swing.JMenu jMenu1;
    private javax.swing.JMenu jMenu2;
    private javax.swing.JMenu jMenu3;
    private javax.swing.JMenuItem jMenuItem1;
    private javax.swing.JMenuItem jMenuItem10;
    private javax.swing.JMenuItem jMenuItem11;
    private javax.swing.JMenuItem jMenuItem12;
    private javax.swing.JMenuItem jMenuItem13;
    private javax.swing.JMenuItem jMenuItem14;
    private javax.swing.JMenuItem jMenuItem15;
    private javax.swing.JMenuItem jMenuItem16;
    private javax.swing.JMenuItem jMenuItem2;
    private javax.swing.JMenuItem jMenuItem3;
    private javax.swing.JMenuItem jMenuItem4;
    private javax.swing.JMenuItem jMenuItem5;
    private javax.swing.JMenuItem jMenuItem6;
    private javax.swing.JMenuItem jMenuItem7;
    private javax.swing.JMenuItem jMenuItem8;
    private javax.swing.JMenuItem jMenuItem9;
    private javax.swing.JMenuItem jMenuItemBinary;
    private javax.swing.JMenuItem jMenuItemByte;
    private javax.swing.JMenuItem jMenuItemC9;
    private javax.swing.JMenuItem jMenuItemChar;
    private javax.swing.JMenuItem jMenuItemCode;
    private javax.swing.JMenuItem jMenuItemJoin;
    private javax.swing.JMenuItem jMenuItemLabelAsData;
    private javax.swing.JMenuItem jMenuItemUngroup;
    private javax.swing.JMenuItem jMenuItemWatchBinary;
    private javax.swing.JMenuItem jMenuItemWatchByte;
    private javax.swing.JMenuItem jMenuItemWatchBytePair;
    private javax.swing.JMenuItem jMenuItemWatchSequence;
    private javax.swing.JMenuItem jMenuItemWatchString;
    private javax.swing.JMenuItem jMenuItemWatchWord;
    private javax.swing.JMenuItem jMenuItemWord;
    private javax.swing.JMenuItem jMenuItemWord1;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JPanel jPanel3;
    private javax.swing.JPanel jPanelDebug;
    private javax.swing.JPopupMenu jPopupMenu1;
    private javax.swing.JPopupMenu jPopupMenu2;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JScrollPane jScrollPane2;
    private javax.swing.JScrollPane jScrollPane3;
    private javax.swing.JScrollPane jScrollPane4;
    private javax.swing.JScrollPane jScrollPane5;
    private javax.swing.JSplitPane jSplitPane1;
    private javax.swing.JTabbedPane jTabbedPane1;
    private javax.swing.JTable jTable1;
    private javax.swing.JTable jTable2;
    private javax.swing.JTable jTableSource;
    private javax.swing.JTable jTableStack;
    private javax.swing.JTextField jTextFieldCommand;
    private javax.swing.JTextField jTextFieldSearch;
    private javax.swing.JTextField jTextFieldSearch1;
    private javax.swing.JToggleButton jToggleButton1;
    private javax.swing.JToggleButton jToggleButton3;
    // End of variables declaration//GEN-END:variables

    private void handleCodeScan()
    {
        if (currentDissi.vecxPanel==null) return;
        if (!config.debugingCore) return;
        CodeScanMemory csmem = currentDissi.vecxPanel.getCodeScanMemory();
        
        if (csmem == null) return;
        
        for (int b=0; b< csmem.getBankCount(); b++)
        {
            csmem.setCurrentBank(b);
            int code = 0;
            int data = 0;
            int unkown = 0;
            for (int i=0; i<0xbfff; i++)
            {
                CodeScanMemory.MemInfo codeScanMemInfo = csmem.mem[i];
                if ((codeScanMemInfo.codeScanType & CodeScanMemory.MemInfo.MEMORY_CODE ) == CodeScanMemory.MemInfo.MEMORY_CODE)
                {
                    getMemoryInformation(i, b).disType = MemoryInformation.DIS_TYPE_DATA_INSTRUCTION_GENERAL;
                    getMemoryInformation(i, b).directPageAddress = codeScanMemInfo.dp;
                    code++;
                    continue;
                }
                if ((codeScanMemInfo.codeScanType & CodeScanMemory.MemInfo.MEMORY_READ ) == CodeScanMemory.MemInfo.MEMORY_READ)
                {
                    getMemoryInformation(i, b).disType = MemoryInformation.DIS_TYPE_DATA_BYTE;
                    data++;
                    continue;
                }
                unkown++;
            }
            /*
            System.out.println("Codescan data for Bank: "+b);
            System.out.println("code: "+code);
            System.out.println("data: "+data);
            System.out.println("unkown: "+unkown);
            */
        }
        
    }
    boolean fullMode = false;
    // depricated - dont use!
    String disFull(String name, int startAddress, boolean assumeVectrex, boolean createUnkownLabels)
    {
        fullMode = false;
        currentDissi.dasm.setCreateLabels(config.createUnkownLabels);
        String ret = "";
        currentDissi.init = false;
        currentDissi.dasm.reset();
        currentDissi.loadedName = name;
        Path path = Paths.get(name);
     
        handleCodeScan();
        try
        {
            byte[] data = Files.readAllBytes(path);
            
            ret = currentDissi.dasm.disassemble(data,startAddress, startAddress, assumeVectrex, 0, true);
        }
        catch (Throwable e)
        {
            System.out.println(de.malban.util.Utility.getStackTrace(e));
        }
        
        correctModel();
        correctTableWatch();
        currentDissi.init = true;
        fullMode = false;
        fullMode = true;
        return  ret;
    }
    String dis(String name, int startAddress)
    {
        fullMode = false;

        currentDissi.init = false;
        currentDissi.dasm.reset();
        currentDissi.loadedName = name;
        Path path = Paths.get(name);
     
        handleCodeScan();
        if (config.lstFirst)
        {
            if (!currentDissi.dasm.tryLoadList(name))
                currentDissi.dasm.tryLoadCNT(name);
        }
        else
        {
            if (!currentDissi.dasm.tryLoadCNT(name))
            currentDissi.dasm.tryLoadList(name);
        }
        
        currentDissi.dasm.setCreateLabels(config.createUnkownLabels);
        String ret = "";
        try
        {
            byte[] data = Files.readAllBytes(path);
            
            ret = currentDissi.dasm.disassemble(data,startAddress, startAddress, config.assumeVectrex);
        }
        catch (Throwable e)
        {
            System.out.println(de.malban.util.Utility.getStackTrace(e));
            ret = currentDissi.dasm.disassemble(null,startAddress, startAddress, config.assumeVectrex);
        }
        
        correctModel();
        correctTableWatch();
        currentDissi.init = true;
        return ret;
    }
    public String dis(Cartridge cart)
    {
        currentDissi.init = false;
        currentDissi.dasm.reset();
        handleCodeScan();
        
        panels.remove(this);
        panels.add(this);
        
        currentDissi.loadedName = cart.cartName;
     
        cart.addCartridgeListener(this);
        
        String lastName = cart.getBankeRomName(0);

        String ret = "";
        if ((lastName == null) || (cart.getBankCount()==0))
        {
            // no rom file loadable
            // at least load system rom info!
            try
            {
                if (config.lstFirst)
                {
                    if (!currentDissi.dasm.tryLoadList(lastName))
                        currentDissi.dasm.tryLoadCNT(lastName);
                }
                else
                {
                    if (!currentDissi.dasm.tryLoadCNT(lastName))
                    currentDissi.dasm.tryLoadList(lastName);
                }
                ret = currentDissi.dasm.disassemble(cart.getByteData(0),0, 0, config.assumeVectrex, 0);
            }
            catch (Throwable e)
            {
                log.addLog(e, WARN);
            }
        }
        else
        {
            lastName = "Plumperquatsch#"; // any string with non 0 length
        }

        currentDissi.dasm.setCreateLabels(config.createUnkownLabels);
        try
        {
            int bankCount = cart.getBankCount();
            if (bankCount>32) bankCount = 4;
            for (int b=0;b<bankCount; b++)
            {
                if (cart.getBankeRomName(b) != null)
                {
                    if ((lastName != null)/*&&(lastName.length()!=0)*/)
                    {
                        if (!lastName.equals(cart.getBankeRomName(b)))
                        {
                            lastName = cart.getBankeRomName(b);
//                            currentDissi.dasm.resetInfo();
                            if (config.lstFirst)
                            {
                                if (!currentDissi.dasm.tryLoadList(lastName))
                                    currentDissi.dasm.tryLoadCNT(lastName);
                            }
                            else
                            {
                                if (!currentDissi.dasm.tryLoadCNT(lastName))
                                currentDissi.dasm.tryLoadList(lastName);
                            }
                        }
                    }
                }
                ret = currentDissi.dasm.disassemble(cart.getByteData(b),0, 0, config.assumeVectrex, b);
            }
        }
        catch (Throwable e)
        {
            log.addLog(e, WARN);
        }
        // in case banks were set by CNT file
        getMemory().setBank(0);
        correctModel();
        correctTableWatch();
        currentDissi.init = true;
        
        initOldBreakPoints();
        
        if (getMemory().highestUserRAM != -1)
        {
            // add stack breakpoint
            Breakpoint bp = new Breakpoint();
            bp.targetAddress = getMemory().highestUserRAM;
            bp.name = "stack lower equal ";
            bp.targetType = Breakpoint.BP_TARGET_CPU;
            bp.targetSubType = Breakpoint.BP_SUBTARGET_CPU_S;
            bp.type = Breakpoint.BP_MULTI | Breakpoint.BP_COMPARE;
            boolean added = currentDissi.vecxPanel.breakpointCPUToggle(bp);
            if (added) printMessage("Breakpoint for stack added.", MESSAGE_INFO);
            else printMessage("Breakpoint for stack removed.", MESSAGE_INFO);
        }
        
        return ret;
    }    
    public boolean isInit()
    {
        return currentDissi.init;
    }
    public void correctModel()
    {
        if (currentDissi == null) return ;
        if (currentDissi.model == null) return ;
        
        currentDissi.model.showAll();
        if (jCheckBox1.isSelected())
            currentDissi.model.reduceUnkown();
        if (jCheckBox2.isSelected())
            currentDissi.model.reduceCompleteInstructions();
        if (!jCheckBox3.isSelected())
            currentDissi.model.reduceBIOS();
        jTableSource.tableChanged(null);
        setUpTableColumns();
        mClassSetting++;
        jTableSource.setAutoResizeMode(AUTO_RESIZE_LAST_COLUMN);
//        for (int i=0; i< currentDissi.model.getColumnCount(); i++)
        for (int i=0; i< jTableSource.getColumnModel().getColumnCount(); i++)
        {
            // since "invisible" the columns in the model of jTableSource are not 
            // present in the table model, the actual number is also the VIEW
            int colData = i;//currentDissi.model.convertViewToModel(i);
            
            String n = jTableSource.getColumnModel().getColumn(i).getHeaderValue().toString();
            int ci = getColumnNameIndex(n);

            jTableSource.getColumnModel().getColumn(i).setPreferredWidth(currentDissi.model.getColWidth(ci));    
            
            
            jTableSource.getColumnModel().getColumn(i).setWidth(currentDissi.model.getColWidth(ci));  
        }
        jTableSource.setAutoResizeMode(AUTO_RESIZE_SUBSEQUENT_COLUMNS);
        mClassSetting--;
    }
    
    int getColumnNameIndex(String n)
    {
        int i= 0;
        for (;i<currentDissi.model.columnNames.length; i++ )
        {
            if (n.equals(currentDissi.model.columnNames[i])) return i;
        }
        return -1;
    }
    public void updateTableOnly()
    {
        
        jTableSource.repaint();
        jTable1.repaint();
    }
    
    public void goRow(int row, boolean forceTopRow)
    {
        if (!currentDissi.init) return;
        
        saveLastAdress();
        
        
        jTableSource.setRowSelectionInterval(row, row);
        if (forceTopRow)
            ensureVisible(jTableSource, row,0) ;
        // and jump there!
        jTableSource.scrollRectToVisible(jTableSource.getCellRect(row, 0, true));
    }    
    public void goAddress(int address, boolean forceTopRow, boolean userGo, boolean forceUpdate)
    {
        goAddress(address, forceTopRow, userGo, forceUpdate, false);
    }
    public void goAddress(int address, boolean forceTopRow, boolean userGo, boolean forceUpdate, boolean jumpMayBeDiscarded)
    {
        goAddress(address, forceTopRow, userGo, forceUpdate, false, false);
    }
    public void goAddress(int address, boolean forceTopRow, boolean userGo, boolean forceUpdate, boolean jumpMayBeDiscarded, boolean recall)
    {
        if (!currentDissi.init) return;
        
        if (userGo)
        {
            saveLastAdress();
        }
        if (currentDissi.watchlist.size()>0)
            jTable1.repaint();

        if (!forceUpdate) // single step e.g. always must update!
        {
            if (!userGo)
            {
                if (!currentDissi.updateEnabled) return;
            }
        }
        if ((jumpMayBeDiscarded) && (doNotFollow)) 
            return;
        
        int row = currentDissi.model.getNearestVisibleRow( address);
        int exactRow =  currentDissi.model.getRowForAddress(address);
        Memory mem = currentDissi.dasm.myMemory;
        MemoryInformation memInfo = mem.memMap.get(address);

        int rowAddress = currentDissi.model.getValueAt(row).address;
        MemoryInformation rowMemInfo = mem.memMap.get(rowAddress);
        
        if (address<0xc000)
        {
            if ((exactRow == -1) && (row != exactRow))
            {

                if ((!memInfo.typeWasSet) && (!rowMemInfo.typeWasSet))
                {
                    // true false true false
                    resetToCode(rowAddress, address);
                    goAddress(address, forceTopRow, userGo, forceUpdate, jumpMayBeDiscarded);
                    return;
                }
            }
        }
        if ((!userGo) && (forceUpdate) && (!jumpMayBeDiscarded))
        {
            // than the "jump" should go to code...
            int infoRow = rowMemInfo.disType;
            
            
            boolean isInstruction = false;
            isInstruction = isInstruction || (infoRow == DIS_TYPE_DATA_INSTRUCTION_1_LENGTH);
            isInstruction = isInstruction || (infoRow == DIS_TYPE_DATA_INSTRUCTION_2_LENGTH);
            isInstruction = isInstruction || (infoRow == DIS_TYPE_DATA_INSTRUCTION_3_LENGTH);
            isInstruction = isInstruction || (infoRow == DIS_TYPE_DATA_INSTRUCTION_4_LENGTH);
            isInstruction = isInstruction || (infoRow == DIS_TYPE_DATA_INSTRUCTION_5_LENGTH);
            isInstruction = isInstruction || (infoRow == DIS_TYPE_DATA_INSTRUCTION_GENERAL);
            
            
            if ((!isInstruction) && (!recall))
            {
                // but it is NO code
                resetToCode(rowAddress, rowAddress);
                goAddress(address, forceTopRow, userGo, forceUpdate, jumpMayBeDiscarded, true);
                return;
            }
        }
        if (exactRow!=-1)
        {
            if (row != exactRow)
            {
                row = exactRow;
            }
        }
            
            
        // select line in table and jump to display that!
        if (row == -1 ) return;
        // select
        
        ensureVisible(jTableSource,  row,  0);
    }
    public static void ensureVisible(JTable table, int row, int col)
    {
        table.setRowSelectionInterval(row, row);
        if (!isCellVisible(table,  row,  col))
            scrollToVisibleMid(table, row,col);
    }
    
    public static boolean isCellVisible(JTable table, int row, int col) {
        if (!(table.getParent() instanceof JViewport)) 
        {
            return false;
        }
        JViewport viewport = (JViewport) table.getParent();
        Rectangle rect = table.getCellRect(row, col, true);
        Point pt = viewport.getViewPosition();
        rect.setLocation(rect.x - pt.x, rect.y - pt.y);
        return new Rectangle(viewport.getExtentSize()).contains(rect);
      }
    public static void scrollToVisibleMid(JTable table, int row, int col )
    {
        if (!(table.getParent() instanceof JViewport)) 
        {
            return;
        }
        JViewport viewport = (JViewport) table.getParent();
        Rectangle rect = table.getCellRect(row, col, true);
        Rectangle viewRect = viewport.getViewRect();
        rect.setLocation(rect.x - viewRect.x, rect.y - viewRect.y);

        int centerX = (viewRect.width - rect.width) / 2;
        int centerY = (viewRect.height - rect.height) / 2;
        if (rect.x < centerX) {
          centerX = -centerX;
        }
        if (rect.y < centerY) {
          centerY = -centerY;
        }
        rect.translate(centerX, centerY);
        viewport.scrollRectToVisible(rect);

            
    }
    
    /*
    public static void scrollToVisible(JTable table, int rowIndex, int vColIndex) 
    {
        // down
        JViewport vp = (JViewport)table.getParent();
        int bottomIndex = table.getModel().getRowCount()-1;
        table.setRowSelectionInterval(bottomIndex, bottomIndex);
        table.changeSelection(bottomIndex,0,false,false);
        Rectangle r = table.getCellRect(bottomIndex-1, 0, true);
        int vph = vp.getExtentSize().height;
        r.y += vph;
        table.scrollRectToVisible(r);

        
        // and UP!
        int currentSelectedRow = table.getSelectedRow();
        
        try
        {
          table.changeSelection(rowIndex,0,false,false);
          if(rowIndex > currentSelectedRow)
          {
            r = table.getCellRect(rowIndex-1, 0, true);
            vph = vp.getExtentSize().height;
            r.y += vph;
            table.scrollRectToVisible(r);
          }
        }
        catch(Exception e){/*error message*b/}

    
    }
*/
    public int getInstructionLengthAt(int address)
    {
        if (!currentDissi.init) return 1;
        return currentDissi.dasm.getInstructionLengthAt(address);
    }

    private void deinitTable()
    {
        if (currentDissi == null) return;
        currentDissi.model.removeTableModelListener(tml);
        jTableSource.getColumnModel().removeColumnModelListener(tcml);
    }
    TableModelListener tml = null;
    TableColumnModelListener tcml = null;
    private void initTable()
    {
        currentDissi.model = currentDissi.dasm.getTableModel();
     
        jTableSource.setModel(currentDissi.model);
        jTableSource.tableChanged(null);
        jTableSource.setAutoResizeMode(AUTO_RESIZE_SUBSEQUENT_COLUMNS);
        jTableSource.setRowSelectionAllowed(true);
        jTableSource.setDefaultRenderer(Object.class, new DefaultTableCellRenderer()
        {
            @Override
            public Component getTableCellRendererComponent(JTable table, Object value, boolean isSelected, boolean hasFocus, int row, int col) 
            {
                super.getTableCellRendererComponent(table, value, isSelected, hasFocus, row, col);

                if (table.getModel() instanceof MemoryInformationTableModel)
                {
                    MemoryInformationTableModel model = (MemoryInformationTableModel)table.getModel();

                    MemoryInformation memInfo = model.getValueAt(row);
                    
                    int currentBank = 0;
                    int currentAddress = 0;
                    if (currentDissi.vecxPanel != null)
                    {
                        currentBank = currentDissi.vecxPanel.getCurrentBank();
                        currentAddress = currentDissi.vecxPanel.getCurrentAddress();
                        
                    }
                    
                    boolean rowSet = false;
                    if (currentDissi.vecxPanel != null)
                    {
                        if (currentDissi.vecxPanel.debuging)
                        {
                            if ((memInfo.address == currentAddress) && ( getCurrentBank() == currentBank))
                            {
                                if (col == 0)
                                {
                                    setBackground(config.cLinesFore);//table.getSelectionBackground());//new Color(200,200,255));
                                    rowSet = true;
                                }
                            }
                        }
                    }
                    if (rowSet)
                        ;
                    else if (memInfo.hasBreakpoint())
                    {
                        boolean enabled = false;
                        ArrayList<Breakpoint> bp = memInfo.getBreakpoints();
                        for (Breakpoint b: bp)
                        {
                            if (b.enabled) enabled = true;
                        }
                        
                        if (enabled)
                            setBackground(config.valueChanged);//Color.RED);
                        else
                            setBackground(config.psgChannelA);//some other color);
                        // setForeground(Color.WHITE);
                    } 
                    else 
                    {
                        if (isSelected)
                        {
                            setBackground(table.getSelectionBackground());
                            setForeground(table.getSelectionForeground());
                        }
                        else
                        {
                            Color back = model.getBackground(row, col);
                            Color fore = model.getForeground(row, col);
                            if (back != null)
                                setBackground(back);
                            else
                                setBackground(table.getBackground());
                            if (fore != null)
                                setForeground(fore);
                            else
                                setForeground(table.getForeground());
                        }
                    }       
                }
                return this;
            }   
        });        
        
        tml = new TableModelListener() 
        {

            public void tableChanged(TableModelEvent tme) 
            {
                if (tme.getType() == TableModelEvent.UPDATE) 
                {
                    int row = tme.getFirstRow();
                    int col = tme.getColumn();
                    if (currentDissi.model.convertViewToModel(col) == 1)
                    {
                        // labels
                        // do complete disasm
                        varUpdate();
                    }
                    if (currentDissi.model.convertViewToModel(col) == 11) // comment
                    {
                        MemoryInformation memInfo = currentDissi.model.getValueAt(row);
                        if (memInfo == null) return;

                        removeHeyDissi(memInfo);

                        for (String comment: memInfo.comments)
                        {
                            int hey = comment.toLowerCase().indexOf("hey dissi");
                            if (hey <0) continue;
                            addHeyDissi(memInfo.address, currentDissi.model.getOrgData().currentBank, comment);
                        }
                    }
                }
            }
        };
        currentDissi.model.addTableModelListener(tml);

        // only set up initially, otherwise it gets less and less :-)
        if (allColumns == null)
        {
            allColumns = new ArrayList<TableColumn>();
            for (int i=0; i< currentDissi.model.getColumnOrgCount(); i++)
            {
                allColumns.add(jTableSource.getColumnModel().getColumn(i));
            }
        }
        setUpTableColumns();
                
        tcml = new TableColumnModelListener()
        {
              public void columnMarginChanged(ChangeEvent e)
              {
                  if (mClassSetting==0)
                      rememberColumnsWidth();
              }
              public void columnSelectionChanged(ListSelectionEvent e)
              {
              }
              public void columnAdded(TableColumnModelEvent e)
              {
              }
              public void columnRemoved(TableColumnModelEvent e)
              {
              }
              public void columnMoved(TableColumnModelEvent e)
              {
              }
        };
        jTableSource.getColumnModel().addColumnModelListener(tcml);
    }
    
    
    
    public int getCurrentAddress()
    {
        if (!currentDissi.init) return -1;
        int row = jTableSource.getSelectedRow();
        if (row == -1) return -1;
        MemoryInformationTableModel model = (MemoryInformationTableModel)jTableSource.getModel();
        MemoryInformation memInfo = model.getValueAt(row);
        return memInfo.address;
    }

    public MemoryInformation getMemoryInformation(int address, int bank)
    {
        return currentDissi.dasm.myMemory.get(address, bank);
    }
    public Memory getMemory()
    {
        return currentDissi.dasm.myMemory;
    }
        
    JTable buildTable()
    {
        JTable table = new JTable(){

	


            @Override
            public Component prepareEditor(TableCellEditor editor, int row, int column) 
            {
                Component c = super.prepareEditor(editor, row, column);
                if (column == 1)
                {
                    if (c instanceof JTextField)
                    {
                        JTextField tf = (JTextField) c;
                        if (jTableSource.getModel() instanceof MemoryInformationTableModel)
                        {
                            MemoryInformationTableModel model = (MemoryInformationTableModel) jTableSource.getModel();
                            MemoryInformation memInfo = getMemoryInformation(model.getValueAt(row).address, getCurrentBank());
                            String ediString ="";
                            for (String l: memInfo.labels)
                            {
                                if (l.trim().length()>0)
                                    ediString+=l+":";
                            }
                            if (ediString.length()>0)  
                                ediString = ediString.substring(0, ediString.length()-1);
                            tf.setText(ediString);
                        }                        
                    }
                }
                return c;
            }


            //Implement table cell tool tips.           
            public String getToolTipText(MouseEvent e) 
            {
                if (currentDissi.vecxPanel==null) return null;
                String tip = "<html>";
                if (jTableSource.getModel() instanceof MemoryInformationTableModel)
                {
                    MemoryInformationTableModel model = (MemoryInformationTableModel) jTableSource.getModel();
                    java.awt.Point p = e.getPoint();
                    int rowIndex = rowAtPoint(p);
                    int colIndex = columnAtPoint(p);

                    try 
                    {
                        MemoryInformation memInfo = getMemoryInformation(model.getValueAt(rowIndex).address, currentDissi.vecxPanel.getCurrentBank());
                        // labels
                        if (model.convertViewToModel(colIndex) == 1)
                        {
                            // show complete labels as tt
                            tip+="<pre>";
                            for (int i = 0;i< memInfo.length; i++)
                            {
                                MemoryInformation next = model.getOrgData().memMap.get(memInfo.address+i);
                                for (int ii = 0;ii< next.labels.size(); ii++)
                                {
                                    tip += String.format("$%04X",memInfo.address+i )+"| "+next.labels.get(ii)+":\n";
                                }
                            }
                            tip+="</pre>";
                        }
                        if (model.convertViewToModel(colIndex) == 8)
                        {
                            boolean bit8 = false;
                            String adr = (String) model.getValueAt( rowIndex,  model.convertViewToModel(colIndex));
                            if (adr.trim().length() <1) return "";
                            if (adr.trim().length() <4) bit8 = true;
                            int a = DASM6809.toNumber(adr);
                            int current = memInfo.address;
                            if (bit8) return null;

                            // MemoryInformation memInfo2 = getMemoryInformation(a);
                            int val1 = currentDissi.vecxPanel.getVecXMem8(a);
                            int val2 = currentDissi.vecxPanel.getVecXMem8(a+1);
                            
                            tip +=adr+": contains...<BR>";
                            tip +="8bit:  " + "$"+String.format("%02X",val1&0xff)+", dec: "+(val1&0xff)+"<BR>";
                            tip +="16bit: " + "$"+String.format("%04X",((val1&0xff)*256+(val2&0xff)) )+", dec: "+((val1&0xff)*256+(val2&0xff)) +"<BR>";
                        }
                        if (model.convertViewToModel(colIndex) == 11)
                        {
                            // show complete comment as tt
                            tip+="<pre>";
                            for (int i = 0;i< memInfo.length; i++)
                            {
                                MemoryInformation next = model.getOrgData().memMap.get(memInfo.address+i);
                                for (int ii = 0;ii< next.comments.size(); ii++)
                                {
                                    tip += String.format("$%04X",memInfo.address+i )+"| "+next.comments.get(ii)+"\n";
                                }
                            }
                            tip+="</pre>";
                        }
                        
                        
                                
                    } 
                    catch (RuntimeException e1) 
                    {
                        //catch null pointer exception if mouse is over an empty line
                    }
                }
                tip += "</html>";
                return tip;
            }
        };       
        table.putClientProperty("terminateEditOnFocusLost", Boolean.TRUE);  
       return  table;
        
    }
    private void setupKeyEvents()
    {
        if (currentDissi.keyEventsAreSet) return;
        currentDissi.keyEventsAreSet = true;
        jTableSource.getInputMap(WHEN_FOCUSED).put(KeyStroke.getKeyStroke(KeyEvent.VK_SPACE,0, false), "set Breakpoint");
        jTableSource.getActionMap().put("set Breakpoint", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (currentDissi.vecxPanel==null) return; currentDissi.vecxPanel.debugBreakpointAction(); }});
        jTableSource.getInputMap(WHEN_FOCUSED).put(KeyStroke.getKeyStroke(KeyEvent.VK_R,0, false), "RUN");
        jTableSource.getActionMap().put("RUN", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (currentDissi.vecxPanel==null) return; currentDissi.vecxPanel.debugAction(); }});

        jTextFieldCommand.getInputMap(WHEN_FOCUSED).put(KeyStroke.getKeyStroke(KeyEvent.VK_DOWN,0, false), "command next");
        jTextFieldCommand.getActionMap().put("command next", new AbstractAction() { public void actionPerformed(ActionEvent e) {   commandHistoryNext(); }});
        jTextFieldCommand.getInputMap(WHEN_FOCUSED).put(KeyStroke.getKeyStroke(KeyEvent.VK_UP,0, false), "command previous");
        jTextFieldCommand.getActionMap().put("command previous", new AbstractAction() { public void actionPerformed(ActionEvent e) {  commandHistoryPrevious(); }});
    }   

    // CALLED FROM UNICONIFY
    public void updateForced()
    {
        jTableSource.tableChanged(null);
        jTableSource.repaint();
        jTable1.tableChanged(null);
        jTable1.repaint();
        correctModel();
    }

    public void updateValues(boolean forceUpdate)
    {
        updateReg(forceUpdate);
        if (!forceUpdate)
            if (!currentDissi.updateEnabled) return;
        disRAM();
        updateTableOnly();
    }
    public void setUpdateEnabled(boolean b)
    {
        currentDissi.updateEnabled = b;
    }
    
    public boolean hasBreakpoint(int adr)
    {
        MemoryInformation memInfo = currentDissi.dasm.myMemory.memMap.get(adr);
        if (memInfo == null) return false;
        return memInfo.hasBreakpoint();
    }

    public int getCurrentBank()
    {
        return currentDissi.dasm.myMemory.getCurrentBank();
    }
    public boolean hasBreakpoint(int adr, int bank)
    {
        MemoryInformation memInfo = currentDissi.dasm.myMemory.get(adr, bank);
        
        if (memInfo == null) return false;
        return memInfo.hasBreakpoint();
    }
    public void processHeyDissis()
    {
        Memory mem = currentDissi.dasm.myMemory;

        int cb = mem.currentBank;
        for (int b=0; b<mem.maxBank; b++)
        {
            mem.setBank(b);
            for (int i=0; i<65536; i++)
            {
                MemoryInformation memInfo = mem.memMap.get(i);
                if (memInfo == null) continue;
                for (String comment: memInfo.comments)
                {
                    int hey = comment.toLowerCase().indexOf("hey dissi");
                    if (hey <0) continue;
                    addHeyDissi(i, mem.currentBank, comment);
                }
            }
        }
        currentDissi.dasm.myMemory.setBank(cb);
    }
    private void addHeyDissi(int address, int bank, String hey)
    {
        // remove hey dissi
        int i = hey.toLowerCase().indexOf("hey dissi");
        hey = hey.substring(i+9).trim();

        // get what is in between quotes
        i=hey.indexOf("\""); // first quote
        if (i<0) return;
        hey = hey.substring(i+1).trim();
        i=hey.indexOf("\""); // second quote
        if (i>0) // if there is no second ", don'T bother its not THAT important!
            hey = hey.substring(0,i).trim();
        
        // in hey now our commands
        // they should be splitable and than "doable"
        String[] commands = hey.split(" ");
        int commandCounter = 0;
        for (;commandCounter<commands.length;)
        {
            if (commands[commandCounter].length()==0) continue;
            if (commands[commandCounter].toLowerCase().equals("print"))
            {
                addHeyDissiPrint(address, bank, commands, commandCounter+1);
                return; // nothing else can follow
            }
            if (commands[commandCounter].toLowerCase().equals("watch"))
            {
                addHeyDissiWatch(address, bank, commands, commandCounter+1);
                return; // nothing else can follow
            }
            if (commands[commandCounter].toLowerCase().equals("break"))
            {
                addHeyDissiBreak(address, bank, commands, commandCounter+1);
                return; // nothing else can follow
            }
            commandCounter++;
        }
        
    }
    
    void addHeyDissiPrint(int address, int bank, String[] commands, int parameterStart)
    {
        if (currentDissi.vecxPanel==null)printMessage("\"Hey dissi\" not processed, vecx not found!", MESSAGE_WARN);
            
        Breakpoint bp = new Breakpoint();
        bp.targetAddress = address;
        bp.targetType = Breakpoint.BP_TARGET_CPU;
        bp.targetBank = bank;
        bp.targetSubType = Breakpoint.BP_SUBTARGET_CPU_PC;
        bp.type = Breakpoint.BP_COMPARE | Breakpoint.BP_MULTI|Breakpoint.BP_INFO|Breakpoint.BP_HEY;
        bp.exitType = EMU_EXIT_BREAKPOINT_CONTINUE;
        
        // take $xxxx as memory location
        // take $label_name as label, seek memory location and take that
        // everything else is printed verbatim
        for (int i=parameterStart; i< commands.length; i++)
        {
            if (bp.printInfo==null) bp.printInfo = new ArrayList<String>();
            if (commands[i].trim().length()==0) continue;
            if (!commands[i].startsWith("$")) 
            {
                if (commands[i].startsWith("#"))
                {
                    bp.printInfo.add(commands[i]);
                    continue;
                }
                bp.printInfo.add(commands[i]); // print verbatim all strings which do not start with $
                continue;
            }

            int adr = DASM6809.toNumber(commands[i]); // is it a number?
            if ((adr & 0xffff) != 0) 
            {
                bp.printInfo.add(String.format("$%04X",adr&0xffff));
                continue;
            }
            
            if (commands[i].substring(1).trim().toLowerCase().equals("$intx"))
            {
                bp.printInfo.add("$intx"); 
                continue;
            }
            if (commands[i].substring(1).trim().toLowerCase().equals("$inty"))
            {
                bp.printInfo.add("$inty"); 
                continue;
            }
            
            
            
            // seek label!
            adr = getLabelAddr(commands[i].substring(1).trim());
            if (adr == 0) 
            {
                bp.printInfo.add(commands[i]); // take string verbatim, even with a $
                continue;
            }
            bp.printInfo.add(commands[i].substring(1).trim()+"="); 
            bp.printInfo.add(String.format("$%04X",adr&0xffff )); // translate label to hex address
        }
        currentDissi.vecxPanel.breakpointMemorySet(bp);
    }
    void addHeyDissiWatch(int address, int bank, String[] commands, int parameterStart)
    {
        if (currentDissi.vecxPanel==null)printMessage("\"Hey dissi\" not processed, vecx not found!", MESSAGE_WARN);
            
        // take $xxxx as memory location
        // take $label_name as label, seek memory location and take that
        // everything else is printed verbatim
        ArrayList<String>words = new ArrayList<String>();
        boolean varGot = false;
        boolean typeGot = false;
        boolean ok = true;
        int watchAddress =-1;
        int watchType  =1;
        int watchLen = 0;
        for (int i=parameterStart; i< commands.length; i++)
        {
            if (commands[i].trim().length()==0) continue;
            if (varGot) 
            {
                if (typeGot)
                {
                    words.add(commands[i]); 
                    watchLen = DASM6809.toNumber(commands[i]);
                    continue;
                }
                words.add(commands[i]); 
                watchType = DASM6809.toNumber(commands[i]);
                typeGot = true;
                continue;
            }

            int adr = DASM6809.toNumber(commands[i]); // is it a number?
            if ((adr & 0xffff) != 0) 
            {
                words.add(String.format("$%04X",adr&0xffff));
                watchAddress = adr&0xffff;
                varGot = true;
                continue;
            }
            // seek label!
            if (commands[i].startsWith("$"))
                adr = getLabelAddr(commands[i].substring(1).trim());
            else
                adr = getLabelAddr(commands[i].trim());
            if ((adr & 0xffff) != 0) 
            {
                words.add(String.format("$%04X",adr&0xffff));
                watchAddress = adr&0xffff;
                varGot = true;
            }
            else 
            {
                words.add(commands[i]); 
                ok = false;
            }
        }
        if (ok)
        {
            Watch.addWatch(watchAddress, watchType, watchLen, this);
        }
    }
    // if we do that more often, we should build a lookup table for labels as a hashmap!
    int getLabelAddr(String label)
    {
        Memory mem = currentDissi.dasm.myMemory;
        
        for (int i=0; i<65536; i++)
        {
            MemoryInformation memInfo = mem.memMap.get(i);
            for (String l: memInfo.labels)
            {
                if (l.toLowerCase().equals(label.toLowerCase())) 
                    return i;
            }
        }
        return 0; // not successull
        
    }
    int getImmediateLabelAddr(String label)
    {
        Memory mem = currentDissi.dasm.myMemory;
        
        for (int i=0; i<65536; i++)
        {
            MemoryInformation memInfo = mem.memMap.get(i);
            for (String l: memInfo.immediateLabels)
            {
                if (l.toLowerCase().equals(label.toLowerCase())) 
                    return i;
            }
        }
        return 0; // not successull
        
    }
    void addHeyDissiBreak(int address, int bank, String[] commands, int parameterStart)
    {
        boolean once = false;
        boolean integratorZero = false;
        int defaultCompare = 10;
        if (parameterStart<commands.length)
        {
            // there is another "command"
            if (commands[parameterStart].toLowerCase().equals("once"))
            {
                once = true;
            }
            if (commands[parameterStart].toLowerCase().equals("integratorzero"))
            {
                integratorZero = true;
            }
        }
        if (parameterStart+1<commands.length)
        {
            defaultCompare = DASM6809.toNumber(commands[parameterStart+1]);
        }
        
        // no conditionals yet, just break
        Breakpoint bp = new Breakpoint();
        bp.targetAddress = address;
        bp.targetBank = bank;
        bp.targetType = Breakpoint.BP_TARGET_CPU;
        bp.targetSubType = Breakpoint.BP_SUBTARGET_CPU_PC;

        if (!once)
            bp.type = Breakpoint.BP_MULTI|Breakpoint.BP_HEY;
        else
            bp.type = Breakpoint.BP_ONCE|Breakpoint.BP_HEY;
        if (integratorZero)
        {
            bp.type = bp.type | Breakpoint.BP_INTEGRATOR;
            bp.compareValue = defaultCompare;
        }
        else
        {
            bp.type = bp.type | Breakpoint.BP_COMPARE;
            
        }
        
        bp.exitType = EMU_EXIT_BREAKPOINT_BREAK;
        currentDissi.vecxPanel.breakpointMemorySet(bp);
    }
    
    void removeHeyDissi(MemoryInformation memInfo)
    {
        if (!memInfo.hasBreakpoint()) return;
        ArrayList<Breakpoint> tmp = (ArrayList<Breakpoint>) memInfo.getBreakpoints().clone(); // concurrency...
        for (Breakpoint bp: tmp)
        {
            if ((bp.type & Breakpoint.BP_HEY) == Breakpoint.BP_HEY)
            {
                currentDissi.vecxPanel.breakpointRemove(bp);
            }
        }
    }
    
    public void doHeyDissiBreakpoint(Breakpoint bp)
    {
        // for now only PRINT
        StringBuilder message = new StringBuilder();
        if (bp == null) return;
        if (bp.printInfo == null) return;
        if (bp.printInfo.size() == 0) return;
        boolean inJoytickMode = false;
        
//  ; hey dissi "print JOYSTICK_READ timeHi= $RecalCounterHi timeLow= $RecalCounterLow , X= $Vec_Joy_1_X"
        
        String josytickInfo = "";
        int jcount = 0;
        int jAdr = 0;
        boolean isX = false;
        boolean isY = false;
        int index = 0;
        for (;index<bp.printInfo.size(); index++)
        {
            String c = bp.printInfo.get(index);
            String nextC = "";
            if (index+1<bp.printInfo.size())
                nextC = bp.printInfo.get(index+1);
            boolean bit16 = false;
            if (nextC.trim().equals("16"))
            {
                bit16 = true;
                index++;
            }
            if (c.contains("JOYSTICK_READ")) 
                inJoytickMode = true;
            if (c.contains("X=")) isX = true;
            if (c.contains("Y=")) isY = true;
            String out = "";
            if (!c.startsWith("$")) 
            {
                if (c.startsWith("#")) 
                {
                    String reg = c.substring(1).toLowerCase();
                    if (reg.equals("a"))
                        out+= String.format("$%02X",currentDissi.vecxPanel.getAReg()&0xff);
                    if (reg.equals("b"))
                        out+= String.format("$%02X",currentDissi.vecxPanel.getBReg()&0xff);
                    if (reg.equals("dp"))
                        out+= String.format("$%02X",currentDissi.vecxPanel.getDPReg()&0xff);
                    if (reg.equals("cc"))
                        out+= String.format("$%02X",currentDissi.vecxPanel.getCCReg()&0xff);
                    if (reg.equals("pc"))
                        out+= String.format("$%04X",currentDissi.vecxPanel.getPCReg()&0xffff);
                    if (reg.equals("x"))
                        out+= String.format("$%04X",currentDissi.vecxPanel.getXReg()&0xffff);
                    if (reg.equals("y"))
                        out+= String.format("$%04X",currentDissi.vecxPanel.getYReg()&0xffff);
                    if (reg.equals("s"))
                        out+= String.format("$%04X",currentDissi.vecxPanel.getSReg()&0xffff);
                    if (reg.equals("u"))
                        out+= String.format("$%04X",currentDissi.vecxPanel.getUReg()&0xffff);
                    if (reg.equals("d"))
                        out+= String.format("$%04X",currentDissi.vecxPanel.getDReg()&0xffff);
                    if (out.length()>0)
                    {
                        out+=" ";
                        message.append(out);
                        continue;
                    }

                }
                
                out+=" ";
                message.append(c).append(out);
                continue;
            }
            if (c.equals("$intx"))
            {
                message.append("Integrator X = "+currentDissi.vecxPanel.getXIntegratorValue());
                continue;
            }
            if (c.equals("$inty"))
            {
                message.append("Integrator Y = "+currentDissi.vecxPanel.getYIntegratorValue());
                continue;
            }
            int adr = DASM6809.toNumber(c); // is it a number?
            if (adr==0)     // can't interprete number
            {
                if (c.startsWith("$")) jcount++;
                message.append(c).append(" ");
                continue;
            }
            
            int msb = currentDissi.vecxPanel.getVecXMem8(adr)&0xff;
            if (bit16)
            {
                int lsb = currentDissi.vecxPanel.getVecXMem8(adr+1)&0xff;
                int value = msb*256+lsb;
                message.append(String.format("$%04X",adr )).append("=").append(String.format("$%04X",value )).append(" ");
            }
            else
            {
                message.append(String.format("$%04X",adr )).append("=").append(String.format("$%02X",msb )).append(" ");
            }
            
            if (inJoytickMode)
            {
                if (jcount==0)
                {
                    jAdr = msb*256;
                }
                if (jcount==1)
                {
                    jAdr += msb;
                }
                if (jcount==2)
                {
                    if (isX) jAdr += 128 *256; // set highest 16 bit
                    if (msb==1) jAdr += 64 *256; // set highest 16 bit
//                    if ((b&0xff)==0xff) jAdr += 64 *256; // set highest 16 bit

                    System.out.println(" dw "+String.format("$%04X",jAdr )+"; DVaa aaaa aaaa aaaa , a=RecalCounter, D=1->X (Y else), V=1->1 (-1 else) ");
                
                }
                jcount++;
            }
        }
        printMessage(message.toString(), MESSAGE_INFO);
    }
    public void printMessage(String s, String type)
    {
        try
        {
            jEditorPane1.getDocument().insertString(jEditorPane1.getDocument().getLength(), s+"\n", TokenStyles.getStyle(type));
        } 
        catch (Throwable e) 
        { 
            System.out.println("Error messaging from dissi");
        }
        jEditorPane1.setCaretPosition(jEditorPane1.getDocument().getLength());
    }
    
    static class DissiStateInfo implements Serializable
    {
        int pos=0;
        Boolean[] columnVisible=new Boolean[15];
        int[]  columnWidth=new int[15];
        int[] columnWidthSmall;
    }
    void rememberColumnsWidth()
    {
        MemoryInformationTableModel model = (MemoryInformationTableModel)jTableSource.getModel();
        for (int i = 0;i<jTableSource.getColumnCount(); i++)
        {
            TableColumn tcol = jTableSource.getColumnModel().getColumn(i);
            String n = jTableSource.getColumnModel().getColumn(i).getHeaderValue().toString();
            int ci = getColumnNameIndex(n);
           
            
            
            model.columnWidth[ci] = tcol.getWidth();
        }
    }
    public Serializable getAdditionalStateinfo()
    {
        DissiStateInfo sl = new DissiStateInfo();
        sl.pos = jSplitPane1.getDividerLocation();
        sl.columnVisible = new Boolean[MemoryInformationTableModel.columnVisibleALL.length];
        sl.columnWidth = new int[MemoryInformationTableModel.columnWidth.length];
        sl.columnWidthSmall = new int[MemoryInformationTableModel.columnWidthSmall.length];

        for (int i=0;i<MemoryInformationTableModel.columnVisibleALL.length; i++)
            sl.columnVisible[i]= MemoryInformationTableModel.columnVisibleALL[i];
        for (int i=0;i<MemoryInformationTableModel.columnWidth.length; i++)
        {
            sl.columnWidth[i]= MemoryInformationTableModel.columnWidth[i];
        }
        for (int i=0;i<MemoryInformationTableModel.columnWidthSmall.length; i++)
            sl.columnWidthSmall[i]= MemoryInformationTableModel.columnWidthSmall[i];
        return sl;
    }
    public void setAdditionalStateinfo(Serializable ser)
    {
        DissiStateInfo sl = (DissiStateInfo) ser;
        jSplitPane1.setDividerLocation(sl.pos);
        MemoryInformationTableModel.columnVisibleALL = new Boolean[MemoryInformationTableModel.columnVisibleALL.length];// = new Boolean[sl.columnVisible.length];
        MemoryInformationTableModel.columnWidth = new int[MemoryInformationTableModel.columnWidth.length];//new int[sl.columnWidth.length];
        MemoryInformationTableModel.columnWidthSmall = new int[MemoryInformationTableModel.columnWidthSmall.length];//= new int[sl.columnWidthSmall.length];

        // defaults
        for (int i=0;i<MemoryInformationTableModel.columnWidth.length; i++)
        {
            MemoryInformationTableModel.columnWidth[i]= 100;
        }
        


        for (int i=0;i<sl.columnVisible.length; i++)
            MemoryInformationTableModel.columnVisibleALL[i]= sl.columnVisible[i];
        for (int i=0;i<sl.columnWidth.length; i++)
        {
            MemoryInformationTableModel.columnWidth[i]= sl.columnWidth[i];
        }
        for (int i=0;i<sl.columnWidthSmall.length; i++)
            MemoryInformationTableModel.columnWidthSmall[i]= sl.columnWidthSmall[i];
        correctModel();
    }
    public static boolean specialDebugMode = false;
    // receives the contents of the textfield after a return
    public void executeCommand(String command)
    {
        executeCommand(command, false);
    }
    public void executeCommand(String command, boolean quiet)
    {
        command = de.malban.util.UtilityString.replaceWhiteSpaces(command, " ");
        command = de.malban.util.UtilityString.replace(command, "  ", " ");
        if (!quiet)
            printMessage(command, MESSAGE_INFO);
        String[] parts = command.split(" ");
        if (parts.length==0) return;
        if (parts[0].length()==0) return;
        Command com = Command.getCommand(parts[0]);
        if (com == null)
        {
            if (parts[0].equals("debug"))
            {
                specialDebugMode = !specialDebugMode;
                if (specialDebugMode)
                    printMessage("Vide: special debug mode enabled!", MESSAGE_INFO);
                else
                    printMessage("Vide: special debug mode disabled!", MESSAGE_INFO);
                return;
            }
            if (!doCalculator(command))
            {
                if (!VediPanel.displayHelp(command))
                    printMessage("Syntax Error!", MESSAGE_ERR);
            }
            return;
        }
        try
        {
            executeCommand(com, parts, quiet);
        }
        catch (Throwable e)
        {
            
        }
    }
    boolean bsDebug = false;
    // insert breakpoints in ALL banks
    public boolean isBankDebug()
    {
        return bsDebug;
    }
    
// executes given command with given parameters, param[0] is string of command invocation!
    public void executeCommand(Command command, String[] param, boolean quiet)
    {
        // commanfs that can be used outside of emulation
        switch (command.ID)
        {
            case Command.D_CMD_DUMP_JOGL:
            {
                String t = JOGLSupport.getJOGLInfo();
                
                printMessage(t, MESSAGE_INFO);
                log.addLog(t);
                return;
            }
            case Command.D_CMD_HELP:
            {
                printMessage(Command.getHelp(), MESSAGE_INFO);
                return;
            }
            case Command.D_CMD_CLEAR_SCREEN:
            {
                jEditorPane1.setText("");
                return;
            }
        }        
        if (currentDissi.vecxPanel==null) 
        {
            printMessage("Sorry, can't do that now! (emulation not started)", MESSAGE_WARN);
            return; 
        }
        switch (command.ID)
        {
            
            case Command.D_CMD_DO_NMI:
            {
                currentDissi.vecxPanel.doNMI();
                break;
            }
            case Command.D_CMD_BANKSWITCH_DEBUG:
            {
                bsDebug = !bsDebug;
                if (bsDebug)
                {
                    printMessage("Debug for bankswitching enabled.", MESSAGE_INFO);
                }
                else
                {
                    printMessage("Debug for bankswitching disabled.", MESSAGE_INFO);
                }
                
                break;
            }
            case Command.D_CMD_CARTRIDGE:
            {
                if (currentDissi.vecxPanel!=null) 
                    currentDissi.vecxPanel.showCartridges();
                break;
            }
            case Command.D_CMD_JOYPORT_DEVICE:
            {
                if (currentDissi.vecxPanel!=null) 
                    currentDissi.vecxPanel.showJoyportDevices();
                break;
            }
            case Command.D_CMD_GO:
            {
                if (param.length==2) 
                {
                    String param1 = param[1];
                    int num = DASM6809.toNumber(param1);
                    currentDissi.vecxPanel.setPC(num);
                }
                currentDissi.vecxPanel.run();
                break;
            }
            
            case Command.D_CMD_SOFTRESET:
            {
                currentDissi.vecxPanel.resetCurrent(true);
                currentDissi.vecxPanel.run();
                break;
            }
            case Command.D_CMD_RESET:
            {
                currentDissi.vecxPanel.resetCurrent();
                break;
            }
            case Command.D_CMD_SYNC_BANK_COMMENTS:
            {
                synchronizeComments();
                break;
            }
            case Command.D_CMD_CYCLES:
            {
                if (param.length==1) 
                {
                    currentDissi.vecxPanel.getCyclesRunning();
                    printMessage("Vecx works hard for "+currentDissi.vecxPanel.getCyclesRunning()+" cycles!", MESSAGE_INFO);
                    return;
                }
                String param1 = param[1];
                int num = DASM6809.toNumber(param1);
                currentDissi.vecxPanel.setCyclesRunning(num);
                printMessage("Vecx cycle count set to: "+currentDissi.vecxPanel.getCyclesRunning(), MESSAGE_INFO);

                
                break;
            }
            case Command.D_CMD_RUN_CYCLES:
            {
                if (param.length==1) 
                {
                    printMessage("More input needed...", MESSAGE_WARN);
                    return;
                }
                String param1 = param[1];
                int num = DASM6809.toNumber(param1, true);
                if (num==0) 
                {
                    printMessage("Running for 0 cycles uff - done!", MESSAGE_WARN);
                    return;
                }

                Breakpoint bp = new Breakpoint();
                bp.compareValue = num;
                
                bp.targetType = Breakpoint.BP_TARGET_CPU;
                bp.targetSubType = Breakpoint.BP_SUBTARGET_CPU_CYCLES;
                bp.name = "cycle run";
                bp.type = Breakpoint.BP_COMPARE | Breakpoint.BP_ONCE;
                currentDissi.vecxPanel.breakpointCyclesSet(bp);
                printMessage("Vecx one time breakpoint set after "+num+" cycles.", MESSAGE_INFO);
                if (param.length ==2)
                    currentDissi.vecxPanel.run();
                break;
            }
            
            case Command.D_CMD_CYCLES_MEASURE:
            {
                int startadr =0xF1A2;
                int endadr = 0xF192;
                if (param.length==1)
                {
                    ;
                }
                else if (param.length==2) 
                {
                    printMessage("Out of Data error!...", MESSAGE_WARN);
                    return;
                }
                else
                {
                    startadr = DASM6809.toNumber(param[1]);
                    endadr = DASM6809.toNumber(param[2]);
                }
                
                if ((startadr==0) ||(endadr==0))
                {
                    printMessage("You plan to execute adr $0000? - MURDER!", MESSAGE_WARN);
                    return;
                }

                Breakpoint bp = new Breakpoint();
                bp.targetAddress = startadr;
                bp.compareValue = endadr;
                bp.name = "cycle measure";
                bp.targetType = Breakpoint.BP_TARGET_CPU;
                bp.targetSubType = Breakpoint.BP_SUBTARGET_CPU_SPECIAL;
                bp.type = Breakpoint.BP_COMPARE | Breakpoint.BP_ONCE;
                currentDissi.vecxPanel.breakpointSet(bp);
                printMessage("Waiting for emulation to reach address "+String.format("$%04X", startadr ), MESSAGE_INFO);
                break;
            }
            case Command.D_CMD_DONOT_FOLLOW:
            {
                doNotFollow = !doNotFollow;
                printMessage("Do not follow: "+(doNotFollow?"on":"off"), MESSAGE_INFO);
                if (config.doProfile)
                {
                    if (((MemoryInformationTableModel)jTableSource.getModel()).profiler!=null)
                    {
                        Profiler profiler = ((MemoryInformationTableModel)jTableSource.getModel()).profiler;
                        profiler.finalOnly = doNotFollow;
                    }
                }
                break;
            }
                    
            case Command.D_CMD_BREAKPOINT:
            {
                if (param.length<1)
                {
                    printMessage("Not enough parameters.", MESSAGE_WARN);
                    return;
                }
                String param1 = param[1];
                int num = DASM6809.toNumber(param1);
                if (num != 0)
                {
                    Breakpoint bp = new Breakpoint();
                    bp.targetAddress = num;
                    bp.targetBank = getCurrentBank();
                    bp.targetType = Breakpoint.BP_TARGET_CPU;
                    bp.name = "Address: "+String.format("$%04X", num )+"["+bp.targetBank+"]";
                    bp.targetSubType = Breakpoint.BP_SUBTARGET_CPU_PC;
                    bp.type = Breakpoint.BP_COMPARE | Breakpoint.BP_MULTI;
                    currentDissi.vecxPanel.breakpointAddressToggle(bp);
                    printMessage("Breakpoint at address $"+String.format("$%04X", num )+", bank "+bp.targetBank+" toggled.", MESSAGE_INFO);
                    break;
                }
                else if (param1.toLowerCase().contains("bankswitch"))
                {
                    Breakpoint bp = new Breakpoint();
                    bp.targetBank = getCurrentBank();
                    bp.targetType = Breakpoint.BP_TARGET_CARTRIDGE;
                    bp.targetSubType = Breakpoint.BP_SUBTARGET_CARTRIDGE_BANKSWITCH;
                    bp.name = "Bankswitch";
                    bp.type = /*Breakpoint.BP_COMPARE |*/ Breakpoint.BP_MULTI|Breakpoint.BP_BANK;
                    boolean added = currentDissi.vecxPanel.breakpointBankToggle(bp);
                    if (added) printMessage("Breakpoint for bankswitching added.", MESSAGE_INFO);
                    else printMessage("Breakpoint for bankswitching removed.", MESSAGE_INFO);
                    break;
                }
                else if (param1.toLowerCase().contains("VIA_ORB".toLowerCase()))
                {
                    String param2 = param[2];
                    Breakpoint bp = new Breakpoint();
                    bp.compareValue = Math.abs(DASM6809.toNumber(param2)%8); // ensure bit0-7
                    bp.targetBank = getCurrentBank();
                    bp.name = "VIA_ORB bit "+bp.compareValue;
                    bp.targetType = Breakpoint.BP_TARGET_VIA;
                    bp.targetSubType = Breakpoint.BP_SUBTARGET_VIA_ORB;
                    bp.type = Breakpoint.BP_BITCOMPARE | Breakpoint.BP_MULTI;
                    boolean added = currentDissi.vecxPanel.breakpointVIAToggle(bp);
                    if (added) printMessage("Breakpoint for via orb bit "+bp.compareValue+" added.", MESSAGE_INFO);
                    else printMessage("Breakpoint for via orb bit "+bp.compareValue+" removed.", MESSAGE_INFO);
                    break;
                }
                else if (param1.toLowerCase().contains("WEIRD_AUX".toLowerCase()))
                {
                    Breakpoint bp = new Breakpoint();
                    bp.compareValue = 0; // inherect: $80 / $98
                    // ensure bit0-7
                    bp.targetBank = getCurrentBank();
                    bp.name = "WEIRD_AUX";
                    bp.targetType = Breakpoint.BP_TARGET_VIA;
                    bp.targetSubType = Breakpoint.BP_SUBTARGET_VIA_AUX;
                    bp.type = Breakpoint.BP_MULTI;
                    boolean added = currentDissi.vecxPanel.breakpointVIAToggle(bp);
                    if (added) printMessage("Breakpoint for weird AUX != $80/$89 added.", MESSAGE_INFO);
                    else printMessage("Breakpoint for weird AUX != $80/$89 removed.", MESSAGE_INFO);
                    break;
                }
                else if (param1.toLowerCase().contains("ROM".toLowerCase()))
                {
                    Breakpoint bp = new Breakpoint();
                    bp.name = "ROM write bit ";
                    bp.targetType = Breakpoint.BP_TARGET_MEMORY;
                    bp.targetSubType = Breakpoint.BP_SUBTARGET_MEMORY_ROM;
                    bp.type = Breakpoint.BP_MULTI | Breakpoint.BP_WRITE;
                    boolean added = currentDissi.vecxPanel.breakpointROMToggle(bp);
                    if (added) printMessage("Breakpoint for ROM write added.", MESSAGE_INFO);
                    else printMessage("Breakpoint for ROM write added removed.", MESSAGE_INFO);
                    break;
                }
                else if (param1.toLowerCase().contains("PC".toLowerCase()))
                {
                    Breakpoint bp = new Breakpoint();
                    bp.name = "PC weird address ";
                    bp.targetType = Breakpoint.BP_TARGET_CPU;
                    bp.targetSubType = Breakpoint.BP_SUBTARGET_CPU_PC;
                    bp.type = Breakpoint.BP_MULTI | Breakpoint.BP_WEIRD;
                    boolean added = currentDissi.vecxPanel.breakpointROMToggle(bp);
                    if (added) printMessage("Breakpoint for PC weird added.", MESSAGE_INFO);
                    else printMessage("Breakpoint for PC weird removed.", MESSAGE_INFO);
                    break;
                }
                else if (param1.toLowerCase().contains("NZ".toLowerCase()))
                {
                    Breakpoint bp = new Breakpoint();
                    
                    String param2 = param[2];
                    num = DASM6809.toNumber(param2);

                    if (num != 0)
                    {
                        bp.compareValue = 10;
                        if (param.length>3)
                            bp.compareValue = DASM6809.toNumber(param[3]);
                        bp.targetAddress = num;
                        bp.name = "integrators non zero ";
                        bp.targetType = Breakpoint.BP_TARGET_CPU;
                        bp.targetSubType = Breakpoint.BP_SUBTARGET_CPU_PC;
                        bp.type = Breakpoint.BP_MULTI | Breakpoint.BP_INTEGRATOR;
                        boolean added = currentDissi.vecxPanel.breakpointAddressToggle(bp);
                        if (added) printMessage("Breakpoint for non zero integrators added.", MESSAGE_INFO);
                        else printMessage("Breakpoint for non zero  integrators removed.", MESSAGE_INFO);
                        break;
                    }
                }                
                else if (param1.toLowerCase().contains("STACK".toLowerCase()))
                {
                    Breakpoint bp = new Breakpoint();
                    
                    String param2 = param[2];
                    num = DASM6809.toNumber(param2);

                    if (num != 0)
                    {
                        bp.targetAddress = num;
                        bp.name = "stack lower equal ";
                        bp.targetType = Breakpoint.BP_TARGET_CPU;
                        bp.targetSubType = Breakpoint.BP_SUBTARGET_CPU_S;
                        bp.type = Breakpoint.BP_MULTI | Breakpoint.BP_COMPARE;
                        boolean added = currentDissi.vecxPanel.breakpointCPUToggle(bp);
                        if (added) printMessage("Breakpoint for stack added.", MESSAGE_INFO);
                        else printMessage("Breakpoint for stack removed.", MESSAGE_INFO);
                        break;
                    }
                }                
                printMessage("I don't know what you mean by that!", MESSAGE_WARN);
                break;
            }
            case Command.D_CMD_BREAKPOINT_RESET:
            {
                currentDissi.vecxPanel.breakpointClearAll();

                printMessage("Breakpoints cleared!", MESSAGE_INFO);
                printMessage("(even hey dissi breakpoints, although comments were not altered!)", MESSAGE_INFO);
                break;
            }
            case Command.D_CMD_REMOVE_WATCH:
            {
                if (param.length<2)
                {
                    printMessage("Not enough parameters.", MESSAGE_WARN);
                    return;
                }
                int address = DASM6809.toNumber(param[1]);
                
                String out = "";
                // if 0 than not a number
                // seek label!
                if (address == 0)
                {
                    if (param[1].startsWith("$")) param[1] = param[1].substring(1);
                    address = getLabelAddr(param[1].trim());
                }
                if (address == 0)
                {
                    printMessage("Watch not recognized.", MESSAGE_WARN);
                    return;
                }
                Watch.removeWatch(address, this);
                jTable1.tableChanged(null);
                jTable1.repaint();
                correctTableWatch();
                printMessage("Watch removed.", MESSAGE_INFO);
                break;                
            }
            case Command.D_CMD_REDRAW:
            {
                currentDissi.vecxPanel.doRedraw();
                break;                
            }
            case Command.D_CMD_QUIET:
            {
                currentDissi.quiet = !currentDissi.quiet;
                if (currentDissi.quiet)
                    printMessage("Dissi is more quiet.", MESSAGE_INFO);
                else
                    printMessage("Dissi will be babbling.", MESSAGE_INFO);
                break;                
            }
            case Command.D_CMD_WATCH:
            {
                if (param.length<3)
                {
                    printMessage("Not enough parameters.", MESSAGE_WARN);
                    return;
                }
                int address = DASM6809.toNumber(param[1]);
                int type = DASM6809.toNumber(param[2]);
                int len = 0;
                if (param.length>3)
                    len = DASM6809.toNumber(param[3]);
                
                String out = "";
                // if 0 than not a number
                // seek label!
                if (address == 0)
                {
                    if (param[1].startsWith("$")) param[1] = param[1].substring(1);
                    address = getLabelAddr(param[1].trim());
                }
                if (address == 0)
                {
                    printMessage("Watch not recognized.", MESSAGE_WARN);
                    return;
                }
                Watch.addWatch(address, type, len, this);
                jTable1.tableChanged(null);
                jTable1.repaint();
                correctTableWatch();
                printMessage("Watch added.", MESSAGE_INFO);
                break;                
            }
            case Command.D_CMD_PRINT:
            {
                if (param.length<2) return;
                int address = DASM6809.toNumber(param[1]);
                String out = "";
                // if 0 than not a number
                // seek label!
                if (address == 0)
                {
                    if (param[1].startsWith("$")) param[1] = param[1].substring(1);
                    address = getLabelAddr(param[1].trim());
                    if (address == 0)
                    {
                        printMessage("Print not recognized.", MESSAGE_WARN);
                    }
                    else
                    {
                        out+="Contents of $"+param[1].trim()+" ("+String.format("$%04X", address)+")";
                    }
                }
                else
                {
                    out+="Contents of address "+String.format("$%04X", address );
                }
                if (address == 0)
                {
                    printMessage("Print not recognized.", MESSAGE_WARN);
                    return;
                }
                out +=": ";
                boolean bit8 = true;
                int value = 0;
                if (param.length>2)
                {
                    if (param[2].contains("16"))
                        bit8=false;
                }
                value += currentDissi.vecxPanel.getVecXMem8(address) & 0xff;
                if (!bit8)
                {
                    value = value*256;
                    value += (currentDissi.vecxPanel.getVecXMem8(address+1) & 0xff);
                    out += String.format("$%04X", value );
                }
                else
                {
                    out += String.format("$%02X", value );
                }
                printMessage(out, MESSAGE_INFO);
                break;
            }
            case Command.D_CMD_LABEL_RESET:
            {
                for (int m = 0; m<=0xffff; m++)
                {
                    MemoryInformation memInfo = getMemoryInformation(m, getCurrentBank());
                    for (String label: memInfo.labels)
                    {
                        String labtemp = "_"+String.format("%04X", (m & 0xFFFF));
                        if (label.equals(labtemp))
                        {
                            memInfo.labels.remove(label);
                            memInfo.reset();
                            break;
                        }
                    }
                }
                currentDissi.dasm.reDisassemble(true);
                updateTable();        
                printMessage("All autobuild labels were resetted, rebuild was executed (if configured).", MESSAGE_INFO);
                break;
            }
            case Command.D_CMD_REMOVE_DISSI_COMMENTS:
            {
                for (int b=0; b<getMemory().maxBank; b++)
                {
                    for (int a=0; a<65536; a++)
                    {
                        MemoryInformation memInfo = getMemory().get(a, b);
                        if (memInfo ==null) continue;
                        for (String comment: memInfo.comments)
                        {
                            if (comment.contains("DISSI")) 
                            {
                                memInfo.comments.remove(comment);
                                break;
                            }
                        }
                    }
                }
                printMessage("All comments containing \"DISSI\" have been removed!", MESSAGE_INFO);
                updateTable();
                break;
            }
            case Command.D_CMD_INFO:
            {
                Cartridge cart = currentDissi.vecxPanel.getCartridge();
                if (cart == null)
                {
                    printMessage("Sorry, can't do that now! (no cartridge loaded)", MESSAGE_WARN);
                    return;
                }

                printMessage("Cartridge name: "+cart.cartName, MESSAGE_INFO);
                printMessage("Cartridge banks# : "+cart.getBankCount(), MESSAGE_INFO);
                for (int i=0; i<cart.getBankCount(); i++)
                {
                    printMessage("bank size #"+i+": "+cart.getBankSize(i), MESSAGE_INFO);
                }
                printMessage("Cartridge CRC32: "+cart.getCRC()+" (over all banks)", MESSAGE_INFO);
                printMessage("Current bank (emulation): "+currentDissi.vecxPanel.getCurrentBank()+" (dissi: "+getMemory().currentBank+")", MESSAGE_INFO);
                printMessage("Typ info: "+cart.getTypInfoString(), MESSAGE_INFO);

                
                break;
            }            
            case Command.D_CMD_BANKSWITCH:
            {
                if (param.length<2) 
                {
                    return;
                }
                int bank = DASM6809.toNumber(param[1]);

                setDissiBank(bank);
                if (!quiet)
                    printMessage("Bank in dissi switched to: "+getCurrentBank()+" (bank may be changed automatically by emulation...)", MESSAGE_INFO);
                break;
            }
            case Command.D_CMD_BANKSWITCH_INFO:
            {
                currentDissi.bankswitchInfo = !currentDissi.bankswitchInfo;
                
                if (!quiet)
                    printMessage("Information display for bankswitches: "+(currentDissi.bankswitchInfo?"on":"off"), MESSAGE_INFO);
                break;
            }
            case Command.D_CMD_TOGGLE_DISASM_RAM:
            {
                currentDissi.doDisRAM = !currentDissi.doDisRAM;
                
                printMessage("Disassamble RAM: "+(currentDissi.doDisRAM?"on":"off"), MESSAGE_INFO);
                break;
            }
            
            case Command.D_CMD_POKE:
            {
                if (param.length!= 3)
                {
                    printMessage("OUT OF DATA ERROR!", MESSAGE_ERR);
                    break;
                }
                String param1 = param[1];
                String param2 = param[2];
                int address = DASM6809.toNumber(param1)& 0xFFFF;
                int value = DASM6809.toNumber(param2) & 0xff;
                if (address == 53280)
                {
                    jEditorPane1.setBackground(new Color(00, 0x88,0xff ));
                    printMessage("Ooops, that was a C64 poke!", MESSAGE_INFO);
                    return;
                }
                doThePoke(address, (byte)value);
                        
                        
                printMessage("I poked "+String.format("%02X", (value))+" to location: "+String.format("%04X", (address ))+" (current bank)", MESSAGE_INFO);
                break;
            }            
            case Command.D_CMD_SET:
            {
                if (param.length!=3)
                {
                    printMessage("Not enough parameters.", MESSAGE_WARN);
                    return;
                }
                int value  = DASM6809.toNumber(param[2]);
                boolean ok = currentDissi.vecxPanel.setRegister(param[1], value);
                
                if (!ok)
                {
                    printMessage("Register can not be set.", MESSAGE_WARN);
                }
                else
                {
                    printMessage("done", MESSAGE_INFO);
                }
                break;
            }
            case Command.D_CMD_TO_FEVER:
            {
                String dump = currentDissi.vecxPanel.dumpCurrentROM();
                if (dump == null)
                {
                    printMessage("ROM not dumped.", MESSAGE_WARN);
                    return;
                }
                boolean ok = checkVec4EverFile(dump);
                if (ok)
                    printMessage("ROM dumped to VecFever", MESSAGE_INFO);
                else
                    printMessage("Some error occured - more information -> log.", MESSAGE_WARN);

                break;
            }
            default:
            {
                printMessage("Command not implemented yet.", MESSAGE_WARN);
            }
        }
    }
    
    public boolean checkVec4EverFile(String fname)
    {
        
        if (!checkVec4EverVolume(false)) return false;
        boolean ok = de.malban.util.UtilityFiles.copyOneFile(fname, config.v4eVolumeName+File.separator+"cart.bin");
        if (!ok)
        {
            log.addLog("V4E: error copying file to RAMDISK: "+de.malban.util.UtilityFiles.error, WARN);
            return false;
        }
        else
        {
            log.addLog("V4E: bin file copied to RAM DISK", INFO);
            return ejectVec4Ever();
        }
    }
    boolean ejectVec4Ever()
    {
        boolean available = checkVec4EverVolume(false);
        if (!available)
        {
            jLabel10.setForeground(config.valueChanged);
            return false;
        }
        boolean ok = de.malban.util.UtilityFiles.ejectVolume(config.v4eVolumeName);
        if (!ok)
        {
            log.addLog("V4E: RAM DISK not ejected", WARN);
            return false;
        }
        else
        {
            log.addLog("V4E: RAM DISK ejected", INFO);
        }
        return true;
    }    
    public boolean checkVec4EverVolume(boolean verbose)
    {
        try
        {
            Path path = Paths.get(config.v4eVolumeName);
            File directory = path.toFile();

            // get all the files from a directory
            File[] fList = directory.listFiles();
            // sanitiy check for "README.TXT" on top level
            for (File file : fList) 
            {
                if (file.getName().contains("README.TXT"))
                {
                    String readmetxt = de.malban.util.UtilityString.readTextFileToOneString(file);
                    if (readmetxt.contains("Sontowski"))
                    {
                        log.addLog("V4E: RAM DISK volume found.", INFO);
                        return true; 
                    }
                }
            }
            
        }
        catch (Throwable e)
        {
            if (verbose)
                log.addLog("V4E: RAM DISK volume not found.", INFO);
        }
        return false;
    }
    
    public void doThePoke(int address, byte value)
    {
        doThePoke(address, value, false);
    }
    public void doThePoke(int address, byte value, boolean doAllBanks)
    {
        if (!doAllBanks)
        {
            for (int bank = 0; bank<currentDissi.dasm.myMemory.getMaxBank(); bank++)
            {
                MemoryInformation memInfo = getMemoryInformation(address, bank);
                memInfo.content = (byte)value;
                
                int len = memInfo.length;
                for (int a=memInfo.address-5; a<memInfo.address+5; a++)
                {
                    if (a<0) continue;
                    if (a<=65536) continue;
                    MemoryInformation memInfo2 = getMemoryInformation(a, bank);
                    memInfo2.reset();
                }
                currentDissi.dasm.reDisassemble(memInfo.address>0xdff5);
            }
        }
        else
        {
            int bank = currentDissi.vecxPanel.getCurrentBank();
            MemoryInformation memInfo = getMemoryInformation(address, bank);
            memInfo.content = (byte)value;

            int len = memInfo.length;
            for (int a=memInfo.address-5; a<memInfo.address+5; a++)
            {
                if (a<0) continue;
                if (a<=65536) continue;
                currentDissi.dasm.myMemory.memMap.get(a).reset();
            }
            currentDissi.dasm.reDisassemble(memInfo.address>0xdff5);
        }

        updateTable();        
        currentDissi.vecxPanel.poke(address, (byte)value);
        currentDissi.vecxPanel.updateAvailableWindows(false, false, true);
    }
    
    // called byRAM update,
    // only for current banks fpr now!
    public void varUpdate()
    {
        // labels
        // do complete disasm
        currentDissi.dasm.reDisassemble(true);
        updateTable();            
        currentDissi.vecxPanel.initLabels();
    }
    public void completeUpdate()
    {
        int end = 0;
        do
        {
            
            MemoryInformation memInfo = getMemoryInformation(end, getCurrentBank());
            
            int len = memInfo.length;
            for (int a=memInfo.address; a<memInfo.address+len; a++)
            {
                // join / ungroup makes no sense for NON code
                if (currentDissi.dasm.myMemory.memMap.get(a).disType <MemoryInformation.DIS_TYPE_DATA_INSTRUCTION_1_LENGTH) continue;

                currentDissi.dasm.myMemory.memMap.get(a).disType = MemoryInformation.DIS_TYPE_DATA_INSTRUCTION_GENERAL;
                currentDissi.dasm.myMemory.memMap.get(a).belongsToInstruction = null;
                currentDissi.dasm.myMemory.memMap.get(a).disassembledMnemonic = "";
                currentDissi.dasm.myMemory.memMap.get(a).disassembledOperand = "";
                currentDissi.dasm.myMemory.memMap.get(a).page = -1;
                currentDissi.dasm.myMemory.memMap.get(a).hexDump = "";
                currentDissi.dasm.myMemory.memMap.get(a).isInstructionByte = 0;
                currentDissi.dasm.myMemory.memMap.get(a).referingToAddress = -1;
                currentDissi.dasm.myMemory.memMap.get(a).referingAddressMode = -1;
                currentDissi.dasm.myMemory.memMap.get(a).length = 1;
                currentDissi.dasm.myMemory.memMap.get(a).done = false;
                currentDissi.dasm.myMemory.memMap.get(a).familyBytes.clear();
            }
            end = memInfo.address+len;
        } while (end < 65536);           
        currentDissi.dasm.reDisassemble(true);
        updateTable();            
        currentDissi.vecxPanel.initLabels();
    }    
    public boolean outputCNT()
    {
        
        if (currentDissi.loadedName==null) return false;
        if (currentDissi.loadedName.trim().length()==0) return false;
        StringBuilder s = new StringBuilder();
        
        for (int bank = 0; bank < getMemory().maxBank; bank++)
        {
            s.append("START_BANK");
            spaceTo(s, 0, TAB_MNEMONIC);
            s.append(String.format("$%02X",bank)).append("\n");
            
            int start = 0;
            int end = 0xdfff;
            for (int m = start; m<end; m++)
            {
                int c=0;
                // Labels
                MemoryInformation memInfo = getMemoryInformation(m, bank);
                for (String label: memInfo.immediateLabels)
                {
                    s.append("EQU");
                    spaceTo(s, c, TAB_MNEMONIC);
                    s.append(String.format("$%04X",m));
                    spaceTo(s, c, TAB_OP);
                    s.append(label).append("\n");
                }
                // labels 2
                for (String label: memInfo.labels)
                {
                    s.append("LABEL");
                    spaceTo(s, c, TAB_MNEMONIC);
                    s.append(String.format("$%04X",m));
                    spaceTo(s, c, TAB_OP);
                    s.append(label).append("\n");
                }
                // comments
                for (String comment: memInfo.comments)
                {
                    if (memInfo.disType<MemoryInformation.DIS_TYPE_DATA_INSTRUCTION_1_LENGTH)
                    {
                        if (comment.contains("DISSI")) continue;
                        // don't keep all dissi error comments for data...
                    }
                    s.append("COMMENT");
                    spaceTo(s, c, TAB_MNEMONIC);
                    s.append(String.format("$%04X",m));
                    spaceTo(s, c, TAB_OP);
                    s.append(comment).append("\n");
                }
            }

            // DP
            int lastAddress = 0;
            int oldDP = -1;
            int currentDP=0;
            int dpStart = 0;
            for (int m = start; m<end; m++)
            {
                int c=0;
                MemoryInformation memInfo = getMemoryInformation(m, bank);
                currentDP = memInfo.directPageAddress;
                if (currentDP != oldDP)
                {
                    if (oldDP != -1)
                    {
                        // new dp range
                        // RANGE 1000-2000 DP D0
                        s.append("RANGE ").append(String.format("$%04X", (dpStart&0xffff))).append("-").append(String.format("$%04X", (lastAddress&0xffff))).append(" DP ").append(String.format("$%02X", (oldDP&0xff))).append("\n");
                    }
                    dpStart = m;
                }
                oldDP = currentDP;
                lastAddress = m;
            }        
            if (currentDP != -1)
            {
                // one more dp line
                s.append("RANGE ").append(String.format("$%04X", (dpStart&0xffff))).append("-").append(String.format("$%04X", (lastAddress&0xffff))).append(" DP ").append(String.format("$%02X", (oldDP&0xff))).append("\n");
            }

            // data / code
            // code / data
            for (int m = start; m<end; )
            {
                MemoryInformation memInfo = getMemoryInformation(m, bank);
                int type = memInfo.disType;
                if (type>=DIS_TYPE_DATA_INSTRUCTION_1_LENGTH) type = MemoryInformation.DIS_TYPE_DATA_INSTRUCTION_GENERAL;

                int len = getConsecutiveType(m, bank, type);

                int count = memInfo.disTypeCollectionMax;
                
                // out
                if ((type == MemoryInformation.DIS_TYPE_DATA_BYTE))
                {
                    s.append("RANGE ").append(String.format("$%04X", (m&0xffff))).append("-").append(String.format("$%04X", ((m+len)&0xffff))).append(" DB_DATA"+" ").append(count +"\n");
                }
                else if ((type == MemoryInformation.DIS_TYPE_DATA_BINARY))
                {
                    s.append("RANGE ").append(String.format("$%04X", (m&0xffff))).append("-").append(String.format("$%04X", ((m+len)&0xffff))).append(" BIN_DATA"+" ").append(count +"\n");
                }
                else if ((type == MemoryInformation.DIS_TYPE_DATA_CHAR))
                {
                    s.append("RANGE ").append(String.format("$%04X", (m&0xffff))).append("-").append(String.format("$%04X", ((m+len)&0xffff))).append(" CHAR_DATA"+" ").append(count +"\n");
                }
                else if ((type == MemoryInformation.DIS_TYPE_DATA_WORD))
                {
                    s.append("RANGE ").append(String.format("$%04X", (m&0xffff))).append("-").append(String.format("$%04X", ((m+len)&0xffff))).append(" DW_DATA"+" ").append(count +"\n");
                }
                else if ((type == MemoryInformation.DIS_TYPE_DATA_WORD_POINTER))
                {
                    s.append("RANGE ").append(String.format("$%04X", (m&0xffff))).append("-").append(String.format("$%04X", ((m+len)&0xffff))).append(" DWP_DATA"+" ").append(count +"\n");
                }
                else if ((type == MemoryInformation.DIS_TYPE_DATA_INSTRUCTION_GENERAL))
                {
                    s.append("RANGE ").append(String.format("$%04X", (m&0xffff))).append("-").append(String.format("$%04X", ((m+len)&0xffff))).append(" CODE"+"\n");
                }
                m+= len;
            }        

            // direct labels
            // and all direct labels!
            Iterator it = getMemory().directLabels.entrySet().iterator();
            while (it.hasNext()) 
            {
                Map.Entry pair = (Map.Entry)it.next();
                int directPageHi = (Integer) pair.getKey();
                HashMap<Integer, MemoryInformation> entries = (HashMap<Integer, MemoryInformation>) pair.getValue();

                Iterator it2 = entries.entrySet().iterator();
                while (it2.hasNext()) 
                {
                    Map.Entry pair2 = (Map.Entry)it2.next();
                    int directPageLo = (Integer) pair2.getKey();
                    String directLabel = (String)pair2.getValue();

                    int value = directPageHi*256+directPageLo;
                    s.append("DIRECT_LABEL "+String.format("$%02X", ((directPageHi)&0xff))+String.format(" $%02X", (directPageLo&0xff))+" "+directLabel+"\n");
                }
            }
            s.append("END_BANK");
            spaceTo(s, 0, TAB_MNEMONIC);
            s.append(String.format("$%02X",bank)+"\n");
        }
        try
        {
            String name = currentDissi.loadedName;
            int li = name.lastIndexOf(".");
            if (li<0) return false;
            name = name.substring(0,li)+".cnt";

            PrintWriter out = new PrintWriter(name);
            out.println(s.toString());
            out.close();
            printMessage("DASM CNT output saved to \""+name+"\"", MESSAGE_INFO);
        }
        catch (Throwable e)
        {
            printMessage("Error saving DASM CNT file...", MESSAGE_ERR);
            return false;
        }        
        return true;
    }
    // returns the number of addresses which have the same type, staring at address
    int getConsecutiveType(int address, int bank, int type)
    {
        int len = 0;
        int newType = DIS_TYPE_UNKOWN;
        do
        {
            len++;
            address++;
            if (getMemoryInformation(address, bank) != null)
                newType = getMemoryInformation(address, bank).disType;
            if (newType>=DIS_TYPE_DATA_INSTRUCTION_1_LENGTH) newType = MemoryInformation.DIS_TYPE_DATA_INSTRUCTION_GENERAL;
        }
        while  (type == newType);
        
        return len;
    }
    public void cartridgeChanged(final CartridgeEvent e)
    {
        // called from emulation thread!
        SwingUtilities.invokeLater(new Runnable()
        {
            public void run()
            {
                currentDissi.dasm.myMemory.setBank(e.newBank);
                if (currentDissi.bankswitchInfo)
                    printMessage("Bank was switched from: "+e.oldBank+" to "+e.newBank, MESSAGE_INFO);
                if (currentDissi.vecxPanel == null) return;
//                updateTableOnly(); // if only this is used, multi banks accross multi files are not updated correctly in table (disassambled operand!

                // otherwise emulation slows to a hold on multiple switchings
                if ((currentDissi.vecxPanel.debuging) || (currentDissi.vecxPanel.stepping))
                {
                    correctModel();
                    currentDissi.vecxPanel.updateLabi();
                    currentDissi.vecxPanel.updateVari();
                }
                // ensure jump is done in gui also
                if (!doNotFollow)
                    goAddress(reg_pc, true, true,true );            
            }
        });                    

    }
    public void setDissiBank(int bank)
    {
        currentDissi.dasm.myMemory.setBank(bank);
        
        correctModel();    
        if (currentDissi.vecxPanel==null) return;
        currentDissi.vecxPanel.updateLabi();
        currentDissi.vecxPanel.updateDumpi();
        currentDissi.vecxPanel.updateVari(); // memory layout has changed!
    }
    public void setUpTableColumns()
    {
        ((MemoryInformationTableModel)jTableSource.getModel()).initVisibity();
        while (jTableSource.getColumnCount()>0)
        {
            jTableSource.getColumnModel().removeColumn(jTableSource.getColumnModel().getColumn(0));
        }
        for (int i=0; i< allColumns.size(); i++)
        {
            if (i>=MemoryInformationTableModel.columnVisibleALL.length)
            {
                jTableSource.getColumnModel().addColumn(allColumns.get(i));
            }
            else
            {
                if (MemoryInformationTableModel.columnVisibleALL[i] == null)
                    jTableSource.getColumnModel().addColumn(allColumns.get(i));
                else
                    if (MemoryInformationTableModel.columnVisibleALL[i])
                    {
                        if (i >= 13)
                        {
                            if (config.doProfile)
                            {
                                if (((MemoryInformationTableModel)jTableSource.getModel()).profiler!=null)
                                    jTableSource.getColumnModel().addColumn(allColumns.get(i));
                            }
                        }
                        else
                            jTableSource.getColumnModel().addColumn(allColumns.get(i));
                    }
            }
        }
    }
    
    public static void configChanged()
    {
        for (DissiPanel p: panels )
            p.setUpTableColumns();
                
    }
    void initOldBreakPoints()
    {
        if (currentDissi.vecxPanel == null) return;
        currentDissi.dasm.myMemory.resetAllBreakPoints();
        ArrayList<Breakpoint>[] allBreakpoints = currentDissi.vecxPanel.getAllBreakpoints();
        int y = 0;
        ArrayList<Breakpoint> tmp = new ArrayList<Breakpoint>();
        for (ArrayList<Breakpoint> list: allBreakpoints)
        {
            for (Breakpoint bp: list)
            {
                if (bp.targetType == Breakpoint.BP_TARGET_CPU)
                {
                    if (bp.targetSubType == Breakpoint.BP_SUBTARGET_CPU_PC)
                    {
                        int address = bp.targetAddress;
                        int bank = bp.targetBank;
                        bp.memInfo = null;
                        MemoryInformation memInfo = getMemoryInformation(address, bank);
                        memInfo.removeBreakpoint(bp); // ensure no doubles
                        memInfo.addBreakpoint(bp);
                        bp.memInfo = memInfo;
                    }
                }
            }
        }        

        if (config.romAndPcBreakpoints)
        {
            Breakpoint bp = new Breakpoint();
            bp.name = "ROM write bit ";
            bp.targetType = Breakpoint.BP_TARGET_MEMORY;
            bp.targetSubType = Breakpoint.BP_SUBTARGET_MEMORY_ROM;
            bp.type = Breakpoint.BP_MULTI | Breakpoint.BP_WRITE;
            boolean added = currentDissi.vecxPanel.breakpointROMToggle(bp);
            if (added) 
            {
            }
            else
            {
                added = currentDissi.vecxPanel.breakpointROMToggle(bp);
            }
            
            bp = new Breakpoint();
            bp.name = "PC weird address ";
            bp.targetType = Breakpoint.BP_TARGET_CPU;
            bp.targetSubType = Breakpoint.BP_SUBTARGET_CPU_PC;
            bp.type = Breakpoint.BP_MULTI | Breakpoint.BP_WEIRD;
            added = currentDissi.vecxPanel.breakpointROMToggle(bp);
            if (added) 
            {
            }
            else
            {
                added = currentDissi.vecxPanel.breakpointROMToggle(bp);
            }
        }
        
        
        
        updateTableOnly();
    }
    public void setStartbreakpoint()
    {
        if (currentDissi.dasm.myMemory.allBanks.size()>1)
        {
            setDissiBank(1);
        }
        
        
        int adr = currentDissi.dasm.processVectrexHeader();
        if (adr == -1) return; // no adress selected!

        
        Breakpoint bp = new Breakpoint();
        bp.targetAddress = adr;
        bp.targetBank = getCurrentBank();
        bp.targetType = Breakpoint.BP_TARGET_CPU;
        bp.targetSubType = Breakpoint.BP_SUBTARGET_CPU_PC;
        bp.type = Breakpoint.BP_COMPARE | Breakpoint.BP_MULTI;
        if (currentDissi.vecxPanel != null)
            currentDissi.vecxPanel.breakpointAddressToggle(bp);
    }
    
    public void newEnvironment(VecXPanel p)
    {
        DissiSwitchData newData = new DissiSwitchData();
        newData.vecxPanel = p;
        changeBaseData(newData);
    }
    public void changeBaseData(DissiSwitchData newDissi)
    {
        deinitTable();
        if (currentDissi != null) 
        {
            if (currentDissi.vecxPanel != null)
            {
                currentDissi.vecxPanel.setDissiAcitve(false);
            }
        }
        currentDissi = newDissi;
        
        if (currentDissi != null) 
        {
            currentDissi.updateEnabled = jToggleButton1.isSelected();
            if (currentDissi.vecxPanel != null)
            {
                currentDissi.vecxPanel.setDissiAcitve(true);
            }
            current_uid = currentDissi.uid;
            initTable();

            jCheckBox2.setSelected(currentDissi.model.fullDisplay);

            if (currentDissi.vecxPanel != null)
            {
                int currentBank = 0;
                if (currentDissi.vecxPanel.getCartridge() != null)
                {
                    currentBank = currentDissi.vecxPanel.getCartridge().getCurrentBank();
                }
                setDissiBank(currentBank);
            }
        
        }
        else
            current_uid = -1;

        correctModel();
        if (currentDissi != null) 
            jTable1.setModel(currentDissi.watchModel);
        else
        {

            jTable1.setModel(new javax.swing.table.DefaultTableModel(
                new Object [][] {
                    {null, null, null, null},
                    {null, null, null, null},
                    {null, null, null, null},
                    {null, null, null, null}
                },
                new String [] {
                    "", "", "", ""
                }
            ));
            
        }
        jTable1.tableChanged(null);
        jTable1.repaint();
        
    }
    
    public VecXPanel getVecXPanel()
    {
        if (currentDissi == null) return null;
        return currentDissi.vecxPanel;
    }
    public void selectionChanged()
    {
        if (mClassSetting>0) return;
        MemoryDumpPanel dumpi = ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).checkDumpy();
        if (dumpi == null) return;
        int[] selected = jTableSource.getSelectedRows();
        MemoryInformationTableModel model = (MemoryInformationTableModel) jTableSource.getModel();
        int start = -1;
        int end = -1;
        for (int row: selected)
        {
            MemoryInformation memInfo = model.getValueAt(row);
            int len = memInfo.length;
            if (memInfo.disType <DIS_TYPE_DATA_INSTRUCTION_1_LENGTH)
            {
                if (memInfo.disTypeCollectionMax>len)
                    len = memInfo.disTypeCollectionMax;
            }
            for (int a=memInfo.address; a<memInfo.address+len; a++)
            {
                if (start == -1) start = memInfo.address;
            }
            end = memInfo.address+len;
        }
        if (lastDumpi == start + end) return;
        lastDumpi = start + end;
        dumpi.setStartEndAddress(start, end);
    }
    int lastDumpi = -1;
    
    void synchronizeComment(int adr)
    {
        boolean e = isBankEqual(adr);
        if (!e) return;
        
        // find a "single" comment
        ArrayList<String> comments = null;
        boolean doComments = true;
        
        
        for (int b = 0; b<getMemory().maxBank; b++)
        {
            MemoryInformation memInfo = getMemory().get(adr, b);
            if (memInfo.comments.size() > 0)
            {
                ArrayList<String> newComments = null;
                String c="";
                for (int i=0; i< memInfo.comments.size();i++)
                {
                    c+=memInfo.comments.get(i).trim();
                }
                c = de.malban.util.UtilityString.replace(c, ":", "");
                if (c.length()>0)
                {
                    newComments = (ArrayList<String>) memInfo.comments.clone();
                }
                if (newComments == null) 
                    continue;
                if (comments != null) 
                {
                    doComments = false; // different comments -> no synchronize
                    continue;
                }
                comments = newComments;
            }
        }
        
        if (doComments)
        {
            // set that to all others
            if (comments != null)
            {
                for (int b = 0; b<getMemory().maxBank; b++)
                {
                    MemoryInformation memInfo = getMemory().get(adr, b);
                    memInfo.comments = (ArrayList<String>) comments.clone();
                }
            }
        }
    }
    
    
    void synchronizeLabels(int adr)
    {
        boolean e = isBankEqual(adr);
        if (!e) return;
        
        ArrayList<String> labels = null;
        boolean doLabels = true;
        
        
        for (int b = 0; b<getMemory().maxBank; b++)
        {
            MemoryInformation memInfo = getMemory().get(adr, b);
            if (memInfo.labels.size() > 0)
            {
                ArrayList<String> newLabels = null;
                boolean validLabels = false;
                for (int i=0; i<memInfo.labels.size(); i++)
                {
                    String l = memInfo.labels.get(i);
                    if ((l.startsWith("_")) && (l.length() == 5)) continue;
                    validLabels = true;
                }
                if (validLabels)
                {
                     newLabels = (ArrayList<String>) memInfo.labels.clone();
                    if (labels == null) labels = newLabels;
                    else  doLabels = false;
                }
            }
        }
        if (doLabels)
        {
            // set that to all others
            if (labels != null)
            {
                for (int b = 0; b<getMemory().maxBank; b++)
                {
                    MemoryInformation memInfo = getMemory().get(adr, b);
                    memInfo.labels = (ArrayList<String>) labels.clone();
                }
            }
        }
    }    
    
    boolean isBankEqual(int adr)
    {
        boolean ret = true;
        MemoryInformation lastMemInfo = null;
        String lastContents = "";
        for (int b = 0; b<getMemory().maxBank; b++)
        {
            MemoryInformation memInfo = getMemory().get(adr, b);

            String content1 ="";
            for (int i = 0;i< memInfo.length; i++)
            {
                MemoryInformation next = getMemory().memMap.get(memInfo.address+i);
                if (next != null)
                {
                    content1 += String.format("%02X ", next.content&0xff);
                }
            }
            if (lastMemInfo != null)
            {
                if (!memInfo.disassembledMnemonic.equals(lastMemInfo.disassembledMnemonic)) return false;
                if (!content1.equals(lastContents)) return false;
                if (memInfo.length != lastMemInfo.length) return false;
            }
            lastContents = content1;
            lastMemInfo = memInfo;
        }
        return ret;
    }
    
    void synchronizeComments()
    {
        if (getMemory().maxBank<=1)
        {
            printMessage("Hm, how exactly do you want to synchronize "+getMemory().maxBank+" banks?", MESSAGE_INFO);
            return;
        }
        
        int start = 0;
        int end = 0x7fff;
        for (int m = start; m<end; )
        {
            synchronizeComment(m);
            synchronizeLabels(m);
            MemoryInformation memInfo = getMemory().get(m, 0);

            int length = memInfo.length;
            m+=length;
            if (length==0) m++;
        }
        start = 0xc800;
        end = 0xcc00;
        for (int m = start; m<end; )
        {
            synchronizeComment(m);
            synchronizeLabels(m);
            MemoryInformation memInfo = getMemory().get(m, 0);

            int length = memInfo.length;
            m+=length;
            if (length==0) m++;
        }
        
        int currentBank = getMemory().currentBank;

        for (int b = 0; b<getMemory().maxBank; b++)
        {
            getMemory().setBank(b);
            currentDissi.dasm.reDisassemble(false);
            updateTable();
        }        
        getMemory().setBank(currentBank);
        updateTable();
        jTableSource.repaint();
        printMessage("Synchronize of comments/labels in banks... done.", MESSAGE_INFO);
    }
    

    // receives the contents of the textfield after a return
    public boolean doCalculator(String command)
    {
        try
        {
            Double d = eval(command) ;
            int i = (int) d.intValue();
            
            if ((i<256) && (i>-128))
                printMessage("Result: "+i + "("+((i>127)?(i-256):(i))+")" +", $"+String.format("%02X", i & 0xFF)+", "+DASM6809.printbinary(i), MESSAGE_INFO);
            else
                printMessage("Result: "+i+ "("+((i>127)?(i-65536):(i))+")"+", $"+String.format("%X", i)+", "+DASM6809.printbinary16(i), MESSAGE_INFO);
        }
        catch (Throwable x)
        {
            return false;
        }
        return true;
    }

    // see: http://stackoverflow.com/questions/3422673/evaluating-a-math-expression-given-in-string-form
    // changed to integer only!
    // and support of 0x/$/ %
    public static double eval( String s) 
    {
        s = s.toLowerCase();
        s=de.malban.util.UtilityString.replace(s, "0x", "$");
        
        final String str = s.toLowerCase();
        Object o = new Object() 
        {
            int pos = -1, ch;

            void nextChar() 
            {
                ch = (++pos < str.length()) ? str.charAt(pos) : -1;
            }

            boolean eat(int charToEat) 
            {
                while (ch == ' ') nextChar();
                if (ch == charToEat) 
                {
                    nextChar();
                    return true;
                }
                return false;
            }

            double parse() 
            {
                nextChar();
                double x = parseExpression();
                if (pos < str.length()) throw new RuntimeException("Unexpected: " + (char)ch);
                return x;
            }

            // Grammar:
            // expression = term | expression `+` term | expression `-` term
            // term = factor | term `*` factor | term `/` factor
            // factor = `+` factor | `-` factor | `(` expression `)`
            //        | number | functionName factor | factor `^` factor

            double parseExpression() 
            {
                double x = parseTerm();
                for (;;) 
                {
                    if      (eat('+')) x += parseTerm(); // addition
                    else if (eat('-')) x -= parseTerm(); // subtraction
                    else return x;
                }
            }

            double parseTerm() 
            {
                double x = parseFactor();
                for (;;) 
                {
                    if      (eat('*')) x *= parseFactor(); // multiplication
                    else if (eat('/')) x /= parseFactor(); // division
                    else return x;
                }
            }

            double parseFactor() 
            {
                if (eat('+')) return parseFactor(); // unary plus
                if (eat('-')) return -parseFactor(); // unary minus

                double x;
                int startPos = this.pos;
                if (eat('(')) 
                { // parentheses
                    x = parseExpression();
                    eat(')');
                } 
                else if ((ch >= '0' && ch <= '9') ) 
                { // numbers
                    while ((ch >= '0' && ch <= '9') ) nextChar();
                    x = Double.parseDouble(str.substring(startPos, this.pos));
                } 
                else if (((ch >= '0' && ch <= '9') || ((ch >= 'a' && ch <= 'f')) ) || (ch == '$'))
                { // numbers
                    while ((ch >= '0' && ch <= '9') || ((ch >= 'a' && ch <= 'f')) || (ch == '$')) nextChar();
                    x =DASM6809.toNumber(str.substring(startPos, this.pos), true);
//                    x = Double.parseDouble(str.substring(startPos, this.pos));
                } 
                else if (((ch >= '0' && ch <= '1') ) || (ch == '%'))
                { // numbers
                    while ((ch >= '0' && ch <= '1') || (ch == '%')) nextChar();
                    x =DASM6809.toNumber(str.substring(startPos, this.pos), true);
//                    x = Double.parseDouble(str.substring(startPos, this.pos));
                } 
/*                
                else if (ch >= 'a' && ch <= 'z') 
                { // functions
                    while (ch >= 'a' && ch <= 'z') nextChar();
                    String func = str.substring(startPos, this.pos);
                    x = parseFactor();
                    if (func.equals("sqrt")) x = Math.sqrt(x);
                    else if (func.equals("sin")) x = Math.sin(Math.toRadians(x));
                    else if (func.equals("cos")) x = Math.cos(Math.toRadians(x));
                    else if (func.equals("tan")) x = Math.tan(Math.toRadians(x));
                    else throw new RuntimeException("Unknown function: " + func);
                } 
*/        
                else 
                {
                    throw new RuntimeException("Unexpected: " + (char)ch);
                }

                if (eat('^')) x = Math.pow(x, parseFactor()); // exponentiation

                return x;
            }
        }.parse();
        return (Double)o;
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
        SwingUtilities.updateComponentTreeUI(jPopupMenu1);
        SwingUtilities.updateComponentTreeUI(jPopupMenu2);
        int fontSize = Theme.textFieldFont.getFont().getSize();
        int rowHeight = fontSize+3;
        jTableSource.setRowHeight(rowHeight);
        jTable1.setRowHeight(rowHeight);
        
//        jTableStack
    }
    
    
    
    boolean updateRegEnabled = false;
    int reg_x;
    int reg_y;
    /* user stack pointer */
    int reg_u = 0;
    /* hardware stack pointer */
    int reg_s= 0;
    /* program counter */
    int reg_pc;
    /* accumulators */
    int reg_a;
    int reg_b;
    /* direct page register */
    int reg_dp;
    /* condition codes */
    int reg_cc;
    int reg_d;
    int bank;
    ArrayList<Integer> callstack = new ArrayList<Integer>();
    private void updateReg(boolean forceUpdate)
    {
        if (!forceUpdate)
            if (!updateRegEnabled) return;
        DissiPanel dissi = this;
        if (dissi.currentDissi == null) return;
        VecXPanel vecxPanel = dissi.currentDissi.vecxPanel; // needed for vectrex memory access
        if (vecxPanel == null) return;
        E6809 e6809 = vecxPanel.get6809();
        
        callstack.clear();
        if (e6809 == null) return;
        synchronized (e6809.callStack)
        {
            try
            {
                for(Integer i: e6809.callStack) callstack.add(i);
            }
            catch (Throwable ex)
            {
                
            }
        }
        jTable2.tableChanged(null);
        jTableStack.tableChanged(null);
        
//        if (vecxPanel!=null)
//            jLabelCycles.setText(""+vecxPanel.getCyclesRunning());
        
        jLabel11.setText("$"+String.format("%02X", e6809.reg_a));
        if (e6809.reg_a != reg_a) jLabel11.setForeground(config.valueChanged);
        else jLabel11.setForeground(config.valueNotChanged);
        reg_a = e6809.reg_a&0xff;
        jLabel11.setToolTipText("decimal: "+reg_a+"("+((reg_a>127)?(reg_a-256):(reg_a))+"), binary: %"+printbinary(reg_a));
        
        jLabel12.setText("$"+String.format("%02X", e6809.reg_b));
        if (e6809.reg_b != reg_b) jLabel12.setForeground(config.valueChanged);
        else jLabel12.setForeground(config.valueNotChanged);
        reg_b = e6809.reg_b&0xff;
        jLabel12.setToolTipText("decimal: "+reg_b+"("+((reg_b>127)?(reg_b-256):(reg_b))+"), binary: %"+printbinary(reg_b));
        
        int d = ((reg_a << 8)&0xff00) | (reg_b & 0xff);
        jLabel15.setText("$"+String.format("%04X", d));
        if (reg_d != d) jLabel15.setForeground(config.valueChanged);
        else jLabel15.setForeground(config.valueNotChanged);
        reg_d = d&0xffff;
        jLabel15.setToolTipText("decimal: "+d+"("+((reg_d>32767)?(reg_d-65536):(reg_d))+"), binary: %"+printbinary(reg_a)+ " " + printbinary(reg_b));
        
        jLabel14.setText("$"+String.format("%04X", e6809.reg_x&0xffff));
        if (e6809.reg_x != reg_x) jLabel14.setForeground(config.valueChanged);
        else jLabel14.setForeground(config.valueNotChanged);
        reg_x = e6809.reg_x&0xffff;
        jLabel14.setToolTipText("decimal: "+reg_x+"("+((reg_x>32767)?(reg_x-65536):(reg_x))+"), binary: %"+printbinary((reg_x>>8)&0xff)+ " " + printbinary(reg_x&0xff));

        jLabel16.setText("$"+String.format("%04X", e6809.reg_y&0xffff));
        if (e6809.reg_y != reg_y) jLabel16.setForeground(config.valueChanged);
        else jLabel16.setForeground(config.valueNotChanged);
        reg_y = e6809.reg_y&0xffff;
        jLabel16.setToolTipText("decimal: "+reg_y+"("+((reg_y>32767)?(reg_y-65536):(reg_y))+"), binary: %"+printbinary((reg_y>>8)&0xff)+ " " + printbinary(reg_y&0xff));

        jLabel20.setText("$"+String.format("%04X", e6809.reg_u.intValue&0xffff));
        if (e6809.reg_u.intValue != reg_u) jLabel20.setForeground(config.valueChanged);
        else jLabel20.setForeground(config.valueNotChanged);
        reg_u = e6809.reg_u.intValue&0xffff;
        jLabel20.setToolTipText("decimal: "+reg_u+"("+((reg_u>32767)?(reg_u-65536):(reg_u))+"), binary: %"+printbinary((reg_u>>8)&0xff)+ " " + printbinary(reg_u&0xff));

        jLabel23.setText("$"+String.format("%04X", e6809.reg_pc&0xffff));
        if ((e6809.reg_pc&0xffff) != reg_pc) jLabel23.setForeground(config.valueChanged);
        else jLabel23.setForeground(config.valueNotChanged);
        reg_pc = e6809.reg_pc&0xffff;
        jLabel23.setToolTipText("decimal: "+reg_pc+", binary: %"+printbinary((reg_pc>>8)&0xff)+ " " + printbinary(reg_pc&0xff));

        if (vecxPanel!=null)
        {
            jLabel24.setVisible(true);
            jLabel24.setText("["+vecxPanel.getCurrentBank()+"]");
            if (bank !=vecxPanel.getCurrentBank()) jLabel24.setForeground(config.valueChanged);
            else jLabel24.setForeground(config.valueNotChanged);
            bank =vecxPanel.getCurrentBank();
        }
        else
        {
            jLabel24.setVisible(false);
        }
        
        jLabel18.setText("$"+String.format("%02X", e6809.reg_dp&0xff));
        if (e6809.reg_dp != reg_dp) jLabel18.setForeground(config.valueChanged);
        else jLabel18.setForeground(config.valueNotChanged);
        reg_dp = e6809.reg_dp;
        jLabel18.setToolTipText("decimal: "+reg_dp+", binary: %"+printbinary(reg_dp));

        jLabel19.setText("%"+printbinary(e6809.reg_cc).substring(0, 4)+" "+printbinary(e6809.reg_cc).substring(4));
        if (e6809.reg_cc != reg_cc) jLabel19.setForeground(config.valueChanged);
        else jLabel19.setForeground(config.valueNotChanged);
        reg_cc = e6809.reg_cc;
        String html = "<html>";
        html += "decimal: "+reg_cc+", hex: $"+String.format("%02X", reg_cc)+"<BR>";
        html +="<ol>";
        html +="<li>Carry "+(((reg_cc&0x01) == 0x01)?"is set":"is clear")+"</li>";
        html +="<li>Overflow "+(((reg_cc&0x02) == 0x02)?"is set":"is clear")+"</li>";
        html +="<li>Zero "+(((reg_cc&0x04) == 0x04)?"is set":"is clear")+"</li>";
        html +="<li>Negative "+(((reg_cc&0x08) == 0x08)?"is set":"is clear")+"</li>";
        html +="<li>IRQ Mask "+(((reg_cc&0x10) == 0x10)?"is set":"is clear")+"</li>";
        html +="<li>Half Carry "+(((reg_cc&0x20) == 0x20)?"is set":"is clear")+"</li>";
        html +="<li>FIRQ Mask "+(((reg_cc&0x40) == 0x40)?"is set":"is clear")+"</li>";
        html +="<li>Entire Flag "+(((reg_cc&0x80) == 0x80)?"is set":"is clear")+"</li>";
        html +="</ol>";
        html += "</html>";
        
        jLabel19.setToolTipText(html);
        
        jLabel26.setText("$"+String.format("%04X", e6809.reg_s.intValue));
        if (e6809.reg_s.intValue != reg_u) jLabel26.setForeground(config.valueChanged);
        else jLabel26.setForeground(config.valueNotChanged);
        reg_s = e6809.reg_s.intValue;
        jLabel26.setToolTipText("decimal: "+reg_s+"("+((reg_s>32767)?(reg_s-65536):(reg_s))+"), binary: %"+printbinary((reg_s>>8)&0xff)+ " " + printbinary(reg_s&0xff));
        
        
    }    
    public class CallStackTableModel extends AbstractTableModel
    {
        public int getRowCount()
        {
            return callstack.size();
        }
        public int getColumnCount()
        {
            return 1;
        }
        public Object getValueAt(int row, int col)
        {
            try
            {

                if (row<callstack.size())
                    return "$"+String.format("%04X", callstack.get(row));
            }
            catch (Throwable e)
            {
                // sometimes synch problems
                // when updated "on the fly"
                // rather than synchronize everything
                // everything - I jest catch and ignore
            }
            return "";
        }
        public int getAddress(int row)
        {
            if (row == -1) return 0;
            return callstack.get(row);
        }
        public String getColumnName(int column) {
            return "";
        }
        public Class<?> getColumnClass(int columnIndex) {
            return String.class;
        }
        public boolean isCellEditable(int rowIndex, int columnIndex) {
            return false;
        }
    }
    
    static final int NEGATIVE_OFFSET_MAX = 20;
    public class RealStackTableModel extends AbstractTableModel
    {
        public int getRowCount()
        {
            if (currentDissi==null) return 0;
            if (currentDissi.vecxPanel==null) return 0;

            
            return 40;//0xcbea-currentDissi.vecxPanel.getSReg()+NEGATIVE_OFFSET_MAX;
        }
        public int getColumnCount()
        {
            return 2;
        }
        public Object getValueAt(int row, int col)
        {
            if (currentDissi==null) return "";
            if (currentDissi.vecxPanel==null) return "";
          //  int count =  0xcbea-currentDissi.vecxPanel.getSReg();
            
            
            int stackRow = row-NEGATIVE_OFFSET_MAX;
            int address = currentDissi.vecxPanel.getSReg()+stackRow;
            
            try
            {
                if (col == 0) 
                {
                    if (stackRow<0)
                        return ""+stackRow;
                    if (stackRow==0)
                        return ""+stackRow;
                    return "+"+stackRow;
                }
                if (col == 1) return "$"+String.format("%02X", (currentDissi.vecxPanel.getVecXMem8(address)&0xff));
            }
            catch (Throwable e)
            {
                // sometimes synch problems
                // when updated "on the fly"
                // rather than synchronize everything
                // everything - I jest catch and ignore
            }
            return "";
        }
        public String getColumnName(int column) {
            if (column == 0) return "+";
            if (column == 1) return "value";
            return "";
        }
        public Class<?> getColumnClass(int columnIndex) {
            return String.class;
        }
        public boolean isCellEditable(int rowIndex, int columnIndex) {
            return false;
        }
    }
    boolean displayRAM(String operand, int address)
    {
        // determine if operand is a variable in ram
        // if so, open Vari
        int start = 0xc800;
        int end = 0xcc00;
        
        for (int m = start; m<end; m++)
        {
            MemoryInformation memInfo = currentDissi.dasm.myMemory.memMap.get(m);
            if (memInfo.address!=address) continue;
            
            if (memInfo.memType == MEM_TYPE_RAM)
            {
                for (int i = 0; i< memInfo.labels.size(); i++)
                {
                    if (operand.toLowerCase().equals(memInfo.labels.get(i).toLowerCase()))
                    {
                        // found
                        if (currentDissi.vecxPanel==null) return false;
                        currentDissi.vecxPanel.showVari();
                        currentDissi.vecxPanel.showVari(memInfo.address);
                        return true;
                    }
                }
            }
        }
        return false;
    }
    boolean systemLabels = true;
    public void setProfilingNames(Profiler profiler)
    {
        if (currentDissi.vecxPanel != null)
        {
            if (config.doProfile)
            {
                if (currentDissi.model != null)
                {
                    currentDissi.model.profiler = currentDissi.vecxPanel.getProfiler();
                    
                    correctModel();
                }
            }
        }


        int start = 0;
        int end = 0xc000;
        for (int m = start; m<end; m++)
        {
            MemoryInformation memInfo = getMemory().memMap.get(m);
            if (memInfo.memType == MEM_TYPE_ROM)
            {
                if (memInfo.labels.size()>0)
                {
                    for (int i=0; i<memInfo.labels.size(); i++)
                    {
                        if (memInfo.labels.get(i)==null) continue;
                        if (memInfo.labels.get(i).length()==0) continue;
                        profiler.addName(m, memInfo.labels.get(i));
                        break;
                    }
                }
            }
        }
        if (systemLabels)
        {
            start = 0xE000;
            end = 0xFFFF;
            for (int m = start; m<end; m++)
            {
                MemoryInformation memInfo = getMemory().memMap.get(m);
                if (memInfo.memType == MEM_TYPE_ROM)
                {
                    if (memInfo.labels.size()>0)
                    {
                        for (int i=0; i<memInfo.labels.size(); i++)
                        {
                            if (memInfo.labels.get(i)==null) continue;
                            if (memInfo.labels.get(i).length()==0) continue;
                            profiler.addName(m, memInfo.labels.get(i));
                            break;
                        }
                    }
                }
            }
        }
    }

    public void deIconified()
    {
        updateForced();
    }

    public void initRAM()
    {
        if (currentDissi == null) return;
        if (currentDissi.vecxPanel == null) return;
        for (int i=0xc800; i< 0xcc00; i++)
        {
            getMemory().setToAllBanks((byte)currentDissi.vecxPanel.getVecXMem8(i), i);
            MemoryInformation memInfo = getMemory().memMap.get(i);
            memInfo.done = false;
        }
    }
    
    public void disRAM()
    {
        if (currentDissi == null) return;
        if (!currentDissi.doDisRAM) return;
        initRAM();
        currentDissi.dasm.doAllKnownMemoryLocations(0xc800, 0xcc00);
        updateTable();        
    }
    
    public void ensureCorrectOutput()
    {
        if(getMemory()==null) return;
        int banks = getMemory().getMaxBank();
        if (banks == 0) 
            return ;
        if(currentDissi==null) return;
        if(currentDissi.vecxPanel==null) return;
        executeCommand("bs "+currentDissi.vecxPanel.getCurrentBank(), true);
//        updateTable();
//        jTableSource.invalidate();
//        jTableSource.validate();
//        jTableSource.repaint();
        goAddress(reg_pc, false, false, true);
    }
    
    
}
