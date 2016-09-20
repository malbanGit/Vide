/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vedi;

import com.fazecast.jSerialComm.SerialPort;
import static com.fazecast.jSerialComm.SerialPort.NO_PARITY;
import static com.fazecast.jSerialComm.SerialPort.ONE_STOP_BIT;
import com.fazecast.jSerialComm.SerialPortDataListener;
import com.fazecast.jSerialComm.SerialPortEvent;
import de.malban.gui.HotKey;
import de.malban.config.Configuration;
import de.malban.config.TinyLogInterface;
import de.malban.gui.dialogs.InternalFrameFileChoser;
import de.malban.gui.dialogs.JOptionPaneDialog;
import de.malban.gui.dialogs.QuickHelpTopFrame;
import de.malban.gui.panels.LogPanel;
import de.malban.util.KeyboardListener;
import de.malban.util.syntax.Syntax.TokenStyles;
import de.malban.util.UtilityString;
import de.malban.util.syntax.entities.ASM6809FileInfo;
import de.malban.util.syntax.entities.EntityDefinition;
import de.malban.util.syntax.entities.LabelSink;
import de.malban.util.syntax.entities.MacroSink;
import de.malban.vide.VideConfig;
import de.malban.vide.dissy.DASM6809;
import static de.malban.vide.dissy.DissiPanel.eval;
import static de.malban.vide.script.ExecutionDescriptor.*;
import de.malban.vide.script.*;
import static de.malban.vide.vecx.VecX.START_TYPE_DEBUG;
import static de.malban.vide.vecx.VecX.START_TYPE_RUN;
import de.malban.vide.vedi.project.FileProperties;
import de.malban.vide.vedi.project.FilePropertiesPanel;
import de.malban.vide.vedi.project.FilePropertiesPool;
import de.malban.vide.vedi.raster.RasterPanel;
import de.malban.vide.vedi.raster.VectorJPanel;
import de.malban.vide.vedi.sound.ModJPanel;
import de.malban.vide.vedi.sound.YMJPanel;
import java.awt.Color;
import java.awt.Component;
import java.awt.Point;
import java.awt.Rectangle;
import java.awt.event.ActionEvent;
import java.awt.event.KeyEvent;
import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.EventObject;
import javax.swing.AbstractAction;
import javax.swing.JComponent;
import javax.swing.JEditorPane;
import javax.swing.JFileChooser;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JTree;
import javax.swing.KeyStroke;
import javax.swing.SwingUtilities;
import javax.swing.event.TreeSelectionEvent;
import javax.swing.event.TreeSelectionListener;
import javax.swing.tree.DefaultMutableTreeNode;
import javax.swing.tree.DefaultTreeCellEditor;
import javax.swing.tree.DefaultTreeCellRenderer;
import javax.swing.tree.DefaultTreeModel;
import javax.swing.tree.TreeNode;
import javax.swing.tree.TreePath;



/**
 *
 * @author malban
 * 
 * Sytanx strategy
 * - load text file
 * - scan textfile for includes/macros/labels
 * - enable syntax checker
 * - update all definitions while editing
 * 
 * 
 * 
 * 
 */
public class VediPanel32 extends VEdiFoundationPanel implements TinyLogInterface, EditorListener
{
    VideConfig config = VideConfig.getConfig();
    LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
    String oneTimeTab = null; 
    
    public static int scanCount = 0;
    boolean init = false;

    boolean loadSettings=true;
    public boolean isLoadSettings()
    {
        return loadSettings;
    }

    
    TreeEntry selectedTreeEntry = null;
    TreePath selectedTreePath = null;
    DefaultMutableTreeNode root = null;
    static ArrayList<VediPanel32> listVedi = new ArrayList<VediPanel32>();
    Path currentStartPath = Paths.get(".");

    
    int startTypeRun = START_TYPE_RUN;

    // see: http://stackoverflow.com/questions/11107984/get-edited-treenode-from-a-celleditorlistener
    private DefaultTreeCellEditor editor;
    private TreeEntry currentSelectedTreeLeaf = null;
    private class MyTreeCellEditor extends DefaultTreeCellEditor 
    {

        public MyTreeCellEditor(JTree tree, DefaultTreeCellRenderer renderer) {
            super(tree, renderer);
        }

        @Override
        public Object getCellEditorValue() {
            String value = (String) super.getCellEditorValue();
            if (currentSelectedTreeLeaf == null) return null;

            changeFileName(currentSelectedTreeLeaf, value);
            
            return currentSelectedTreeLeaf;
        }

        @Override
        public boolean isCellEditable(EventObject e) {
            if (lastPath != null)
            {
                if (lastPath.getLastPathComponent() != null)    
                    return super.isCellEditable(e) && ((TreeNode) lastPath.getLastPathComponent()).isLeaf();
            }
            return false;
        }
    }

    // called from coloror, to notifiy that syntax coloring is ongoing
    public static synchronized void setInScan(boolean b)
    {
        if (b)
        {
            scanCount++;
            if (scanCount == 1) notifyVedi(true);
        }
        else
        {
            scanCount--;
            if (scanCount == 0) notifyVedi(false);
        }
    }
    
    
    // adds a green"asterix" to the bottom, which lights up when Syntax scan is active!
    public static void addVedi(VediPanel32 vedi)
    {
        synchronized(listVedi)
        {
            listVedi.add(vedi);
        }
    }
    public static void removeVedi(VediPanel32 vedi)
    {
        synchronized(listVedi)
        {
            listVedi.remove(vedi);
        }
    }
    
    private static void notifyVedi(final boolean working)
    {
        
        SwingUtilities.invokeLater(new Runnable()
        {
            public void run()
            {
                synchronized(listVedi)
                {
                    for (VediPanel32 vp: listVedi)
                        vp.jLabel6.setVisible(working);
                }
            }
        });                    
    }
    
    private String lastPath="";    
    /**
     * Creates new form RegisterJPanel
     */
    public VediPanel32() {
        this(true);
    }
    public VediPanel32(boolean ls) {
        initComponents();
        jMenuItemVector.setVisible(false); // dsabled, do image conversion from vecci
        loadSettings = ls;
//        jEditorLog.setEditable(false);
        jEditorLog.setContentType("text/html");
        
        jLabel6.setVisible(false);
        
        // split panel per default uses F6
        // delete that default java mapping, since we would like to use F6 for "debug"
        jSplitPane1.getInputMap(JComponent.WHEN_ANCESTOR_OF_FOCUSED_COMPONENT) .put(KeyStroke.getKeyStroke(KeyEvent.VK_F6, 0), "none");        
        jSplitPane2.getInputMap(JComponent.WHEN_ANCESTOR_OF_FOCUSED_COMPONENT) .put(KeyStroke.getKeyStroke(KeyEvent.VK_F6, 0), "none");        
        init();
    }
    public void setTreeVisible(boolean v)
    {
        if (!v)
        {
            jTabbedPane2.setVisible(v);
            jSplitPane2.setDividerLocation(0);
            jSplitPane2.setDividerSize(0);
        }
    }
    public void deinit()
    {
        if (ubxPort != null)
        {
            ubxPort.removeDataListener();
            ubxPort.closePort();
        }
        ubxPort = null;
        jLabel10.setText("not connected");
        jLabel10.setForeground(Color.red);
        settings.pos2 = jSplitPane2.getDividerLocation();
        settings.pos1 = jSplitPane1.getDividerLocation();
        saveSettings();
        for (Component c: jTabbedPane1.getComponents())
        {
            if (c instanceof de.malban.vide.vedi.EditorPanel)
            {
                EditorPanel ep = (EditorPanel) c;
                ep.deinit();
            }
        }
        init = false;
        VediPanel32.removeVedi(this);
    }    
    public String getSettingsName()
    {
        return "Vedi32.ser";
    }
    protected boolean saveSettings()
    {
        if (jComboBoxSerial.getSelectedIndex()>=0)
        {
            settings.vec32PortName = ports[jComboBoxSerial.getSelectedIndex()].getDescriptivePortName();
        }
        else
            settings.vec32PortName = "";
        settings.vec32UsbMount = jTextFieldPath.getText();
        
        return super.saveSettings();
    }
    public static String SID = "Vec32";
    public String getID()
    {
        return SID;
    }

    public void init()
    {
        String lastLoadedFile =null;
        if (loadSettings())
        {
            if (isLoadSettings())
            {
                jSplitPane2.setDividerLocation(settings.pos2);
                jSplitPane1.setDividerLocation(settings.pos1);
                if ((settings.currentProject != null) && (settings.currentProject.mName.trim().length()!=0))
                {
//                    loadProject(settings.currentProject.mClass, settings.currentProject.mName, settings.currentProject.mPath);
                }
                ArrayList<String> toRemove = new ArrayList<String>();
                for (String fn: settings.currentOpenFiles)
                {
                    EditorPanel edi = addEditor(fn, false);
                    oneTimeTab = null;
                    if (edi == null)
                    {
                        // error while loading, remove file from current
                        toRemove. add(fn); 
                    }
                    else
                    {
                        lastLoadedFile = fn;
                    }
                }
                for (String fn: toRemove) settings.currentOpenFiles.remove(fn);
            }
        }
        else
        {
            settings  = new VediSettings();
        }
        
        fillSerial();
        
        
        
        init = true;
        VediPanel32.addVedi(this);
        if (lastLoadedFile != null)
            fillTree(Paths.get(lastLoadedFile).getParent());
        else
        {
            if (settings.vec32UsbMount.length()>0)
                fillTree(Paths.get(settings.vec32UsbMount));
            else
                fillTree(Paths.get(File.separator));
            
        }

        // This allows the edit to be saved if editing is interrupted
        // by a change in selection, focus, etc -> see method detail.
        jTree1.setInvokesStopCellEditing(true);    
        editor = new MyTreeCellEditor(jTree1, (DefaultTreeCellRenderer) jTree1.getCellRenderer());
        jTree1.setCellEditor(editor);    
        jTree1.addTreeSelectionListener(new TreeSelectionListener() {

            @Override
            public void valueChanged(TreeSelectionEvent e) 
            {
                currentSelectedTreeLeaf = null;
                TreePath path = e.getNewLeadSelectionPath();
                if (path != null) {
                    DefaultMutableTreeNode node = (DefaultMutableTreeNode) path.getLastPathComponent();
                    currentSelectedTreeLeaf = (TreeEntry)node.getUserObject();
                }
            }
        });    
        
        new HotKey("Run", new AbstractAction() { public void actionPerformed(ActionEvent e) {  run(); }}, this);
        
        new HotKey("GoBookmark1Mac", new AbstractAction() { public void actionPerformed(ActionEvent e) {  goBookmark(1); }}, this);
        new HotKey("GoBookmark1Win", new AbstractAction() { public void actionPerformed(ActionEvent e) {  goBookmark(1); }}, this);
        new HotKey("SetBookmark1Mac", new AbstractAction() { public void actionPerformed(ActionEvent e) {  setBookmark(1); }}, this);
        new HotKey("SetBookmark1Win", new AbstractAction() { public void actionPerformed(ActionEvent e) {  setBookmark(1); }}, this);
        
        new HotKey("GoBookmark2Mac", new AbstractAction() { public void actionPerformed(ActionEvent e) {  goBookmark(2); }}, this);
        new HotKey("GoBookmark2Win", new AbstractAction() { public void actionPerformed(ActionEvent e) {  goBookmark(2); }}, this);
        new HotKey("SetBookmark2Mac", new AbstractAction() { public void actionPerformed(ActionEvent e) {  setBookmark(2); }}, this);
        new HotKey("SetBookmark2Win", new AbstractAction() { public void actionPerformed(ActionEvent e) {  setBookmark(2); }}, this);
        
        new HotKey("GoBookmark3Mac", new AbstractAction() { public void actionPerformed(ActionEvent e) {  goBookmark(3); }}, this);
        new HotKey("GoBookmark3Win", new AbstractAction() { public void actionPerformed(ActionEvent e) {  goBookmark(3); }}, this);
        new HotKey("SetBookmark3Mac", new AbstractAction() { public void actionPerformed(ActionEvent e) {  setBookmark(3); }}, this);
        new HotKey("SetBookmark3Win", new AbstractAction() { public void actionPerformed(ActionEvent e) {  setBookmark(3); }}, this);
        
        new HotKey("GoBookmark4Mac", new AbstractAction() { public void actionPerformed(ActionEvent e) {  goBookmark(4); }}, this);
        new HotKey("GoBookmark4Win", new AbstractAction() { public void actionPerformed(ActionEvent e) {  goBookmark(4); }}, this);
        new HotKey("SetBookmark4Mac", new AbstractAction() { public void actionPerformed(ActionEvent e) {  setBookmark(4); }}, this);
        new HotKey("SetBookmark4Win", new AbstractAction() { public void actionPerformed(ActionEvent e) {  setBookmark(4); }}, this);
        
        new HotKey("GoBookmark5Mac", new AbstractAction() { public void actionPerformed(ActionEvent e) {  goBookmark(5); }}, this);
        new HotKey("GoBookmark5Win", new AbstractAction() { public void actionPerformed(ActionEvent e) {  goBookmark(5); }}, this);
        new HotKey("SetBookmark5Mac", new AbstractAction() { public void actionPerformed(ActionEvent e) {  setBookmark(5); }}, this);
        new HotKey("SetBookmark5Win", new AbstractAction() { public void actionPerformed(ActionEvent e) {  setBookmark(5); }}, this);
        
        new HotKey("GoBookmark6Mac", new AbstractAction() { public void actionPerformed(ActionEvent e) {  goBookmark(6); }}, this);
        new HotKey("GoBookmark6Win", new AbstractAction() { public void actionPerformed(ActionEvent e) {  goBookmark(6); }}, this);
        new HotKey("SetBookmark6Mac", new AbstractAction() { public void actionPerformed(ActionEvent e) {  setBookmark(6); }}, this);
        new HotKey("SetBookmark6Win", new AbstractAction() { public void actionPerformed(ActionEvent e) {  setBookmark(6); }}, this);
        
        new HotKey("GoBookmark7Mac", new AbstractAction() { public void actionPerformed(ActionEvent e) {  goBookmark(7); }}, this);
        new HotKey("GoBookmark7Win", new AbstractAction() { public void actionPerformed(ActionEvent e) {  goBookmark(7); }}, this);
        new HotKey("SetBookmark7Mac", new AbstractAction() { public void actionPerformed(ActionEvent e) {  setBookmark(7); }}, this);
        new HotKey("SetBookmark7Win", new AbstractAction() { public void actionPerformed(ActionEvent e) {  setBookmark(7); }}, this);
        
        new HotKey("GoBookmark8Mac", new AbstractAction() { public void actionPerformed(ActionEvent e) {  goBookmark(8); }}, this);
        new HotKey("GoBookmark8Win", new AbstractAction() { public void actionPerformed(ActionEvent e) {  goBookmark(8); }}, this);
        new HotKey("SetBookmark8Mac", new AbstractAction() { public void actionPerformed(ActionEvent e) {  setBookmark(8); }}, this);
        new HotKey("SetBookmark8Win", new AbstractAction() { public void actionPerformed(ActionEvent e) {  setBookmark(8); }}, this);
        
        new HotKey("GoBookmark9Mac", new AbstractAction() { public void actionPerformed(ActionEvent e) {  goBookmark(9); }}, this);
        new HotKey("GoBookmark9Win", new AbstractAction() { public void actionPerformed(ActionEvent e) {  goBookmark(9); }}, this);
        new HotKey("SetBookmark9Mac", new AbstractAction() { public void actionPerformed(ActionEvent e) {  setBookmark(9); }}, this);
        new HotKey("SetBookmark9Win", new AbstractAction() { public void actionPerformed(ActionEvent e) {  setBookmark(9); }}, this);
        
        new HotKey("GoBookmark0Mac", new AbstractAction() { public void actionPerformed(ActionEvent e) {  goBookmark(0); }}, this);
        new HotKey("GoBookmark0Win", new AbstractAction() { public void actionPerformed(ActionEvent e) {  goBookmark(0); }}, this);
        new HotKey("SetBookmark0Mac", new AbstractAction() { public void actionPerformed(ActionEvent e) {  setBookmark(0); }}, this);
        new HotKey("SetBookmark0Win", new AbstractAction() { public void actionPerformed(ActionEvent e) {  setBookmark(0); }}, this);
    }

    void setBookmark(int b)
    {
        Bookmark bm = new Bookmark();
        bm.number = b;
        bm.lineNumber = getSelectedEditor().getCursorPos().y;
        bm.name = getSelectedEditor().getFilename();
        bm.fullFilename = getSelectedEditor().getFilename();
        settings.bookmarks.put(b, bm);
        printMessage("Bookmark set: " + bm.toString());
    }
    
    void goBookmark(int b)
    {
        Bookmark bm = settings.bookmarks.get(b);
        if (bm == null) return;
        printMessage("Bookmark go: " + bm.toString());
        
        addEditor(bm.fullFilename, true);
        String nameOnly = new File(bm.fullFilename).getName();
        
        tabExistsSwitch(nameOnly);
        getSelectedEditor().jump(bm.lineNumber);
    }
    
    EditorPanel addEditor(String fullPathname, boolean addToSettings)
    {
        String name = "edi";
        Path path = Paths.get(fullPathname);
        name = path.getFileName().toString();
        if (addToSettings)
        {
            String settingsRel = de.malban.util.Utility.makeRelative(fullPathname);
            String settingsAbs = de.malban.util.Utility.makeAbsolut(fullPathname);
            if (settings.currentOpenFiles.contains(settingsAbs))
            {
                
                return null;
            }
            if (settings.currentOpenFiles.contains(settingsRel))
            {
                return null;
            }
        }
        if (!(new File(fullPathname).exists())) return null;
        EditorPanel edi = new EditorPanel(fullPathname, this);
        if (edi.isInitError()) return null;
        jTabbedPane1.addTab(name, edi);
        oneTimeTab = name;
        addCloseButton(jTabbedPane1, name);
        jTabbedPane1.setSelectedComponent(edi);
        edi.setTinyLog(this);
        edi.addEditorListener(this);
        jLabel5.setText("");
        if (addToSettings)
            settings.currentOpenFiles.add(fullPathname);
        edi.setParent(this);
        return edi;
    }
    ImagePanel addImageDisplay(String fullPathname, boolean addToSettings)
    {
        String name = "imi";
        Path path = Paths.get(fullPathname);
        name = path.getFileName().toString();
        if (addToSettings)
        {
            if (settings.currentOpenFiles.contains(fullPathname))
            {
                return null;
            }
        }
            if (nameExistAsTab(name)) return null;
        ImagePanel edi = new ImagePanel(fullPathname, this);
        if (edi.isInitError()) return null;
        oneTimeTab = name;
        jTabbedPane1.addTab(name, edi);
        addCloseButton(jTabbedPane1, name);
        jTabbedPane1.setSelectedComponent(edi);
        jLabel5.setText("");
        if (addToSettings)
            settings.currentOpenFiles.add(fullPathname);
        edi.setParent(this);
        return edi;
    }   
    BinaryPanel addBinaryDisplay(String fullPathname, boolean addToSettings)
    {
        String name = "imi";
        Path path = Paths.get(fullPathname);
        name = path.getFileName().toString();
        if (addToSettings)
        {
            if (settings.currentOpenFiles.contains(fullPathname))
            {
//                printError("Restriction: at the moment no two files with the same name can be edited!");
                return null;
            }
        }
        if (nameExistAsTab(name)) return null;
        BinaryPanel edi = new BinaryPanel(fullPathname, this);
        if (edi.isInitError()) return null;
        jTabbedPane1.addTab(name, edi);
        oneTimeTab = name;
        addCloseButton(jTabbedPane1, name);
        jTabbedPane1.setSelectedComponent(edi);
        jLabel5.setText("");
        if (addToSettings)
            settings.currentOpenFiles.add(fullPathname);
        edi.setParent(this);
        return edi;
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
        jMenuNewFileMenu = new javax.swing.JMenu();
        jMenuItemVectrexFile = new javax.swing.JMenuItem();
        jMenuItemNewFile = new javax.swing.JMenuItem();
        jPopupMenuTree = new javax.swing.JPopupMenu();
        jMenuItemFileProperties = new javax.swing.JMenuItem();
        jMenuItemAction = new javax.swing.JMenuItem();
        jSeparator1 = new javax.swing.JPopupMenu.Separator();
        jMenuItemModi = new javax.swing.JMenuItem();
        jMenuItemYM = new javax.swing.JMenuItem();
        jSeparator3 = new javax.swing.JPopupMenu.Separator();
        jMenuItemRaster = new javax.swing.JMenuItem();
        jMenuItemVector = new javax.swing.JMenuItem();
        jSeparator2 = new javax.swing.JPopupMenu.Separator();
        jMenuItemDelete = new javax.swing.JMenuItem();
        jMenuItemRename = new javax.swing.JMenuItem();
        jMenuItemDuplicate = new javax.swing.JMenuItem();
        jPanel1 = new javax.swing.JPanel();
        jButtonCut = new javax.swing.JButton();
        jButtonPaste = new javax.swing.JButton();
        jButtonSave = new javax.swing.JButton();
        jButtonRedo = new javax.swing.JButton();
        jButtonUndo = new javax.swing.JButton();
        jButtonCopy = new javax.swing.JButton();
        jButtonSaveAll = new javax.swing.JButton();
        jButtonLoad = new javax.swing.JButton();
        jButtonAssemble = new javax.swing.JButton();
        jSplitPane1 = new javax.swing.JSplitPane();
        jSplitPane2 = new javax.swing.JSplitPane();
        jTabbedPane1 = new javax.swing.JTabbedPane();
        jTabbedPane2 = new javax.swing.JTabbedPane();
        jScrollPane1 = new javax.swing.JScrollPane();
        jTree1 = new javax.swing.JTree();
        jPanel2 = new javax.swing.JPanel();
        jTabbedPane = new javax.swing.JTabbedPane();
        jScrollPane2 = new javax.swing.JScrollPane();
        jEditorLog = new javax.swing.JEditorPane();
        jButtonNew = new javax.swing.JButton();
        jButtonPrettyPrint = new javax.swing.JButton();
        jPanel3 = new javax.swing.JPanel();
        jLabel1 = new javax.swing.JLabel();
        jTextFieldSearch = new javax.swing.JTextField();
        jButtonSearchNext = new javax.swing.JButton();
        jButtonSearchPrevious = new javax.swing.JButton();
        jLabel2 = new javax.swing.JLabel();
        jLabel3 = new javax.swing.JLabel();
        jLabel4 = new javax.swing.JLabel();
        jButtonReplaceInSelection = new javax.swing.JButton();
        jButtonReplaceAll = new javax.swing.JButton();
        jButtonReplaceNext = new javax.swing.JButton();
        jButtonIgnoreCase = new javax.swing.JButton();
        jCheckBoxIgnoreCase = new javax.swing.JCheckBox();
        jTextFieldReplace = new javax.swing.JTextField();
        jLabel5 = new javax.swing.JLabel();
        jLabel6 = new javax.swing.JLabel();
        jButtonClearMessages = new javax.swing.JButton();
        jButtonRefresh = new javax.swing.JButton();
        jTextFieldCommand = new javax.swing.JTextField();
        jLabel7 = new javax.swing.JLabel();
        jPanel6 = new javax.swing.JPanel();
        jLabel8 = new javax.swing.JLabel();
        jComboBoxSerial = new javax.swing.JComboBox();
        jLabel9 = new javax.swing.JLabel();
        jButton1 = new javax.swing.JButton();
        jButton2 = new javax.swing.JButton();
        jLabel10 = new javax.swing.JLabel();
        jTextFieldPath = new javax.swing.JTextField();
        jButtonFileSelect1 = new javax.swing.JButton();

        jPopupMenu1.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseExited(java.awt.event.MouseEvent evt) {
                jPopupMenu1MouseExited(evt);
            }
        });

        jMenuNewFileMenu.setText("new file");

        jMenuItemVectrexFile.setText("new vectrex file");
        jMenuItemVectrexFile.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemVectrexFileActionPerformed(evt);
            }
        });
        jMenuNewFileMenu.add(jMenuItemVectrexFile);

        jMenuItemNewFile.setText("new empty file");
        jMenuItemNewFile.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemNewFileActionPerformed(evt);
            }
        });
        jMenuNewFileMenu.add(jMenuItemNewFile);

        jPopupMenu1.add(jMenuNewFileMenu);

        jPopupMenuTree.setEnabled(false);

        jMenuItemFileProperties.setText("Properties");
        jMenuItemFileProperties.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemFilePropertiesActionPerformed(evt);
            }
        });
        jPopupMenuTree.add(jMenuItemFileProperties);

        jMenuItemAction.setText("execute action");
        jMenuItemAction.setToolTipText("execute the configured action (if any)");
        jMenuItemAction.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemActionActionPerformed(evt);
            }
        });
        jPopupMenuTree.add(jMenuItemAction);
        jPopupMenuTree.add(jSeparator1);

        jMenuItemModi.setText("build vectrex mod");
        jMenuItemModi.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemModiActionPerformed(evt);
            }
        });
        jPopupMenuTree.add(jMenuItemModi);

        jMenuItemYM.setText("build vectrex YM");
        jMenuItemYM.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemYMActionPerformed(evt);
            }
        });
        jPopupMenuTree.add(jMenuItemYM);
        jPopupMenuTree.add(jSeparator3);

        jMenuItemRaster.setText("convert image to vectrex raster");
        jMenuItemRaster.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemRasterActionPerformed(evt);
            }
        });
        jPopupMenuTree.add(jMenuItemRaster);

        jMenuItemVector.setText("convert image to vector");
        jMenuItemVector.setToolTipText("");
        jMenuItemVector.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemVectorActionPerformed(evt);
            }
        });
        jPopupMenuTree.add(jMenuItemVector);
        jPopupMenuTree.add(jSeparator2);

        jMenuItemDelete.setText("Delete");
        jMenuItemDelete.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemDeleteActionPerformed(evt);
            }
        });
        jPopupMenuTree.add(jMenuItemDelete);

        jMenuItemRename.setText("Rename");
        jMenuItemRename.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemRenameActionPerformed(evt);
            }
        });
        jPopupMenuTree.add(jMenuItemRename);

        jMenuItemDuplicate.setText("Duplicate");
        jMenuItemDuplicate.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemDuplicateActionPerformed(evt);
            }
        });
        jPopupMenuTree.add(jMenuItemDuplicate);

        setName("regi"); // NOI18N

        jPanel1.setBorder(javax.swing.BorderFactory.createEtchedBorder());

        jButtonCut.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/cut.png"))); // NOI18N
        jButtonCut.setToolTipText("Cut");
        jButtonCut.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonCut.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonCutActionPerformed(evt);
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

        jButtonSave.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/page_save.png"))); // NOI18N
        jButtonSave.setToolTipText("Save File (with shift - > save as)");
        jButtonSave.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonSave.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSaveActionPerformed(evt);
            }
        });

        jButtonRedo.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/arrow_redo.png"))); // NOI18N
        jButtonRedo.setToolTipText("Redo");
        jButtonRedo.setEnabled(false);
        jButtonRedo.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonRedo.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonRedoActionPerformed(evt);
            }
        });

        jButtonUndo.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/arrow_undo.png"))); // NOI18N
        jButtonUndo.setToolTipText("Undo");
        jButtonUndo.setEnabled(false);
        jButtonUndo.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonUndo.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonUndoActionPerformed(evt);
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

        jButtonSaveAll.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/disk_multiple.png"))); // NOI18N
        jButtonSaveAll.setToolTipText("Save all");
        jButtonSaveAll.setEnabled(false);
        jButtonSaveAll.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonSaveAll.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSaveAllActionPerformed(evt);
            }
        });

        jButtonLoad.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/page_go.png"))); // NOI18N
        jButtonLoad.setToolTipText("Open file");
        jButtonLoad.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonLoad.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonLoadActionPerformed(evt);
            }
        });

        jButtonAssemble.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/control_play_blue.png"))); // NOI18N
        jButtonAssemble.setToolTipText("Assemble current file, if project is loaded, build project and run it (if so defined in config).");
        jButtonAssemble.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonAssemble.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonAssembleActionPerformed(evt);
            }
        });

        jSplitPane1.setDividerLocation(500);
        jSplitPane1.setOrientation(javax.swing.JSplitPane.VERTICAL_SPLIT);
        jSplitPane1.setResizeWeight(1.0);

        jSplitPane2.setDividerLocation(200);

        jTabbedPane1.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jTabbedPane1StateChanged(evt);
            }
        });
        jSplitPane2.setRightComponent(jTabbedPane1);

        jTabbedPane2.setTabLayoutPolicy(javax.swing.JTabbedPane.SCROLL_TAB_LAYOUT);

        jTree1.setEditable(true);
        jTree1.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jTree1MousePressed(evt);
            }
        });
        jTree1.addTreeSelectionListener(new javax.swing.event.TreeSelectionListener() {
            public void valueChanged(javax.swing.event.TreeSelectionEvent evt) {
                jTree1ValueChanged(evt);
            }
        });
        jScrollPane1.setViewportView(jTree1);

        jTabbedPane2.addTab("Project", jScrollPane1);

        jSplitPane2.setLeftComponent(jTabbedPane2);

        jSplitPane1.setTopComponent(jSplitPane2);

        jTabbedPane.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jTabbedPaneStateChanged(evt);
            }
        });

        jEditorLog.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyTyped(java.awt.event.KeyEvent evt) {
                jEditorLogKeyTyped(evt);
            }
        });
        jScrollPane2.setViewportView(jEditorLog);

        jTabbedPane.addTab("Terminal", jScrollPane2);

        javax.swing.GroupLayout jPanel2Layout = new javax.swing.GroupLayout(jPanel2);
        jPanel2.setLayout(jPanel2Layout);
        jPanel2Layout.setHorizontalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jTabbedPane, javax.swing.GroupLayout.DEFAULT_SIZE, 997, Short.MAX_VALUE)
        );
        jPanel2Layout.setVerticalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jTabbedPane)
        );

        jSplitPane1.setBottomComponent(jPanel2);

        jButtonNew.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/new.png"))); // NOI18N
        jButtonNew.setToolTipText("new Project");
        jButtonNew.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonNew.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jButtonNewMousePressed(evt);
            }
        });
        jButtonNew.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonNewActionPerformed(evt);
            }
        });

        jButtonPrettyPrint.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/text_columns.png"))); // NOI18N
        jButtonPrettyPrint.setToolTipText("Pretty print (as9 only)");
        jButtonPrettyPrint.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonPrettyPrint.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonPrettyPrintActionPerformed(evt);
            }
        });

        jPanel3.setBorder(javax.swing.BorderFactory.createEtchedBorder());

        jLabel1.setText("search:");

        jTextFieldSearch.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldSearchActionPerformed(evt);
            }
        });
        jTextFieldSearch.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyPressed(java.awt.event.KeyEvent evt) {
                jTextFieldSearchKeyPressed(evt);
            }
        });

        jButtonSearchNext.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/resultset_next.png"))); // NOI18N
        jButtonSearchNext.setToolTipText("search forward");
        jButtonSearchNext.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonSearchNext.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSearchNextActionPerformed(evt);
            }
        });

        jButtonSearchPrevious.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/resultset_previous.png"))); // NOI18N
        jButtonSearchPrevious.setToolTipText("search backwards");
        jButtonSearchPrevious.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonSearchPrevious.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSearchPreviousActionPerformed(evt);
            }
        });

        jLabel2.setText("replace:");
        jLabel2.setToolTipText("");

        jLabel3.setHorizontalAlignment(javax.swing.SwingConstants.TRAILING);
        jLabel3.setText("xyz chars");

        jLabel4.setText("row/col: xxxx/yyyy");

        jButtonReplaceInSelection.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/control_fastforward_blue.png"))); // NOI18N
        jButtonReplaceInSelection.setToolTipText("replace in selection");
        jButtonReplaceInSelection.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonReplaceInSelection.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonReplaceInSelectionActionPerformed(evt);
            }
        });

        jButtonReplaceAll.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/control_fastforward.png"))); // NOI18N
        jButtonReplaceAll.setToolTipText("replace all (complete document)");
        jButtonReplaceAll.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonReplaceAll.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonReplaceAllActionPerformed(evt);
            }
        });

        jButtonReplaceNext.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/control_play.png"))); // NOI18N
        jButtonReplaceNext.setToolTipText("replace next");
        jButtonReplaceNext.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonReplaceNext.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonReplaceNextActionPerformed(evt);
            }
        });

        jButtonIgnoreCase.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/text_uppercase.png"))); // NOI18N
        jButtonIgnoreCase.setToolTipText("ignore case (if selected)");
        jButtonIgnoreCase.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonIgnoreCase.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonIgnoreCaseActionPerformed(evt);
            }
        });

        jCheckBoxIgnoreCase.setSelected(true);
        jCheckBoxIgnoreCase.setToolTipText("ignore case (if selected)");

        jTextFieldReplace.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldReplaceActionPerformed(evt);
            }
        });

        jLabel5.setForeground(new java.awt.Color(255, 0, 0));
        jLabel5.setToolTipText("");

        jLabel6.setForeground(new java.awt.Color(0, 153, 51));
        jLabel6.setHorizontalAlignment(javax.swing.SwingConstants.TRAILING);
        jLabel6.setText("*");

        jButtonClearMessages.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/weather_sun.png"))); // NOI18N
        jButtonClearMessages.setToolTipText("clear messages");
        jButtonClearMessages.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonClearMessages.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonClearMessagesActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel3Layout = new javax.swing.GroupLayout(jPanel3);
        jPanel3.setLayout(jPanel3Layout);
        jPanel3Layout.setHorizontalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addGap(2, 2, 2)
                .addComponent(jButtonClearMessages)
                .addGap(5, 5, 5)
                .addComponent(jCheckBoxIgnoreCase)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonIgnoreCase)
                .addGap(1, 1, 1)
                .addComponent(jLabel1, javax.swing.GroupLayout.PREFERRED_SIZE, 47, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(2, 2, 2)
                .addComponent(jTextFieldSearch, javax.swing.GroupLayout.PREFERRED_SIZE, 105, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonSearchPrevious)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonSearchNext)
                .addGap(45, 45, 45)
                .addComponent(jLabel2, javax.swing.GroupLayout.PREFERRED_SIZE, 49, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(15, 15, 15)
                .addComponent(jTextFieldReplace, javax.swing.GroupLayout.PREFERRED_SIZE, 105, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonReplaceNext)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonReplaceAll)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonReplaceInSelection)
                .addGap(51, 51, 51)
                .addComponent(jLabel5, javax.swing.GroupLayout.PREFERRED_SIZE, 97, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(jLabel6, javax.swing.GroupLayout.PREFERRED_SIZE, 15, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabel4, javax.swing.GroupLayout.PREFERRED_SIZE, 122, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jLabel3, javax.swing.GroupLayout.PREFERRED_SIZE, 74, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap())
        );
        jPanel3Layout.setVerticalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jButtonSearchNext)
                    .addComponent(jButtonSearchPrevious)
                    .addGroup(jPanel3Layout.createSequentialGroup()
                        .addGap(1, 1, 1)
                        .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                .addComponent(jTextFieldSearch, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jLabel1)
                                .addComponent(jLabel2)
                                .addComponent(jLabel3)
                                .addComponent(jLabel4)
                                .addComponent(jLabel5, javax.swing.GroupLayout.PREFERRED_SIZE, 19, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jLabel6))
                            .addComponent(jCheckBoxIgnoreCase)
                            .addComponent(jButtonIgnoreCase)
                            .addGroup(jPanel3Layout.createSequentialGroup()
                                .addGap(1, 1, 1)
                                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jTextFieldReplace, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                                        .addComponent(jButtonReplaceInSelection)
                                        .addComponent(jButtonReplaceAll)
                                        .addComponent(jButtonReplaceNext))))
                            .addComponent(jButtonClearMessages))))
                .addGap(1, 1, 1))
        );

        jButtonRefresh.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/arrow_refresh.png"))); // NOI18N
        jButtonRefresh.setToolTipText("refresh tree");
        jButtonRefresh.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonRefresh.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonRefreshActionPerformed(evt);
            }
        });

        jTextFieldCommand.setEnabled(false);
        jTextFieldCommand.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldCommandActionPerformed(evt);
            }
        });

        jLabel7.setText("ask:");
        jLabel7.setEnabled(false);

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addComponent(jButtonNew)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonRefresh)
                .addGap(30, 30, 30)
                .addComponent(jButtonLoad)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonSave)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonSaveAll)
                .addGap(18, 18, 18)
                .addComponent(jButtonCopy)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonPaste)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonCut)
                .addGap(33, 33, 33)
                .addComponent(jButtonUndo)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonRedo)
                .addGap(18, 18, 18)
                .addComponent(jButtonPrettyPrint)
                .addGap(46, 46, 46)
                .addComponent(jButtonAssemble)
                .addGap(108, 108, 108)
                .addComponent(jLabel7, javax.swing.GroupLayout.PREFERRED_SIZE, 35, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jTextFieldCommand, javax.swing.GroupLayout.PREFERRED_SIZE, 245, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel1Layout.createSequentialGroup()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jPanel3, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jSplitPane1))
                .addGap(1, 1, 1))
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jButtonPaste)
                    .addComponent(jButtonSave)
                    .addComponent(jButtonCopy)
                    .addComponent(jButtonSaveAll)
                    .addComponent(jButtonLoad)
                    .addComponent(jButtonCut)
                    .addComponent(jButtonRedo)
                    .addComponent(jButtonUndo)
                    .addComponent(jButtonAssemble)
                    .addComponent(jButtonNew)
                    .addComponent(jButtonPrettyPrint)
                    .addComponent(jButtonRefresh)
                    .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jTextFieldCommand, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLabel7)))
                .addGap(2, 2, 2)
                .addComponent(jSplitPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 752, Short.MAX_VALUE)
                .addGap(1, 1, 1)
                .addComponent(jPanel3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
        );

        jLabel8.setText("serial");

        jComboBoxSerial.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Item 1", "Item 2", "Item 3", "Item 4" }));

        jLabel9.setText("filesystem");

        jButton1.setText("connect");
        jButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton1ActionPerformed(evt);
            }
        });

        jButton2.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/arrow_refresh.png"))); // NOI18N
        jButton2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton2ActionPerformed(evt);
            }
        });

        jLabel10.setForeground(new java.awt.Color(255, 0, 0));
        jLabel10.setText("not connected");

        jTextFieldPath.setFocusable(false);

        jButtonFileSelect1.setText("...");
        jButtonFileSelect1.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonFileSelect1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonFileSelect1ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel6Layout = new javax.swing.GroupLayout(jPanel6);
        jPanel6.setLayout(jPanel6Layout);
        jPanel6Layout.setHorizontalGroup(
            jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel6Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jLabel8, javax.swing.GroupLayout.PREFERRED_SIZE, 40, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jComboBoxSerial, javax.swing.GroupLayout.PREFERRED_SIZE, 153, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButton2, javax.swing.GroupLayout.PREFERRED_SIZE, 20, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(58, 58, 58)
                .addComponent(jLabel9)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextFieldPath, javax.swing.GroupLayout.PREFERRED_SIZE, 220, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonFileSelect1, javax.swing.GroupLayout.PREFERRED_SIZE, 13, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(40, 40, 40)
                .addComponent(jButton1)
                .addGap(70, 70, 70)
                .addComponent(jLabel10)
                .addContainerGap(128, Short.MAX_VALUE))
        );
        jPanel6Layout.setVerticalGroup(
            jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel6Layout.createSequentialGroup()
                .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jButton1, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLabel10, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jTextFieldPath, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jButtonFileSelect1))
                    .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                        .addComponent(jComboBoxSerial)
                        .addComponent(jLabel8, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jLabel9, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jButton2, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                .addGroup(layout.createSequentialGroup()
                    .addComponent(jPanel6, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGap(0, 12, Short.MAX_VALUE)))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                .addGap(25, 25, 25)
                .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
            .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                .addGroup(layout.createSequentialGroup()
                    .addComponent(jPanel6, javax.swing.GroupLayout.PREFERRED_SIZE, 22, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGap(0, 809, Short.MAX_VALUE)))
        );
    }// </editor-fold>//GEN-END:initComponents

    private void jButtonCutActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonCutActionPerformed

    }//GEN-LAST:event_jButtonCutActionPerformed

    private void jButtonPasteActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonPasteActionPerformed
       
    }//GEN-LAST:event_jButtonPasteActionPerformed

    private void jButtonSaveActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSaveActionPerformed
        EditorPanel edi = getSelectedEditor();
        if (edi == null) return;
        
        edi.save(KeyboardListener.isShiftDown());
        printMessage("\""+getSelectedEditor().getFilename()+"\" saved.");
    }//GEN-LAST:event_jButtonSaveActionPerformed

    private void jButtonRedoActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonRedoActionPerformed
        EditorPanel edi = getSelectedEditor();
        if (edi == null) return;
        synchronized (getSelectedEditor())
        {
            getSelectedEditor().redo();
        }
    }//GEN-LAST:event_jButtonRedoActionPerformed

    private void jButtonUndoActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonUndoActionPerformed
        EditorPanel edi = getSelectedEditor();
        if (edi == null) return;
        synchronized (getSelectedEditor())
        {
            getSelectedEditor().undo();
        }
    }//GEN-LAST:event_jButtonUndoActionPerformed

    private void jButtonCopyActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonCopyActionPerformed
       
    }//GEN-LAST:event_jButtonCopyActionPerformed

    private void jButtonSaveAllActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSaveAllActionPerformed
        
    }//GEN-LAST:event_jButtonSaveAllActionPerformed

    private void jButtonLoadActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonLoadActionPerformed

        if (KeyboardListener.isShiftDown())
        {
            if (getSelectedEditor() != null) 
            {
                getSelectedEditor().reload(true);
            }
            return;
        }
        
        InternalFrameFileChoser fc = new de.malban.gui.dialogs.InternalFrameFileChoser();
        
        if (lastPath.length()==0)
        {
            fc.setCurrentDirectory(new java.io.File("."+File.separator));
        }
        else
        {
            fc.setCurrentDirectory(new java.io.File(lastPath));
        }
        
        int r = fc.showOpenDialog(Configuration.getConfiguration().getMainFrame());
        if (r != InternalFrameFileChoser.APPROVE_OPTION) return;
        lastPath = fc.getSelectedFile().getAbsolutePath();
        
        addEditor(lastPath, true);
        oneTimeTab = null;
        Path p = Paths.get(lastPath);
        fillTree(p.getParent());
    }//GEN-LAST:event_jButtonLoadActionPerformed

    


    
    private void jButtonAssembleActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonAssembleActionPerformed
        run();
    }//GEN-LAST:event_jButtonAssembleActionPerformed

    public void debug()
    {
        startTypeRun = START_TYPE_DEBUG;
        runInternal();
    }
    public void run()
    {
        startTypeRun = START_TYPE_RUN;
        runInternal();
    }
    public void runInternal()
    {
        // just compile current
        EditorPanel edit = getSelectedEditor();
        if (edit == null) return;
        edit.save(false);
        printMessage("\""+getSelectedEditor().getFilename()+"\" saved.");
        String fname = getSelectedEditor().getFilename();
        if (fname == null) return;
        runBas(new File(fname).getName());
        
    }
    
    private void jTabbedPane1StateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jTabbedPane1StateChanged
        tabChanged(true);
    }//GEN-LAST:event_jTabbedPane1StateChanged

    private void jButtonSearchNextActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSearchNextActionPerformed
        EditorPanel edi = getSelectedEditor();
        if (edi == null) return;
        jLabel5.setText("");
        boolean found = getSelectedEditor().goNext(jTextFieldSearch.getText(), jCheckBoxIgnoreCase.isSelected());
        if (!found) jLabel5.setText("not found!");
    }//GEN-LAST:event_jButtonSearchNextActionPerformed

    private void jButtonSearchPreviousActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSearchPreviousActionPerformed
        jLabel5.setText("");
        EditorPanel edi = getSelectedEditor();
        if (edi == null) return;
        boolean found = getSelectedEditor().goPrevious(jTextFieldSearch.getText(), jCheckBoxIgnoreCase.isSelected());
        if (!found) jLabel5.setText("not found!");
    }//GEN-LAST:event_jButtonSearchPreviousActionPerformed

    private void jButtonIgnoreCaseActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonIgnoreCaseActionPerformed
        jCheckBoxIgnoreCase.setSelected(!jCheckBoxIgnoreCase.isSelected());
    }//GEN-LAST:event_jButtonIgnoreCaseActionPerformed

    private void jButtonReplaceNextActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonReplaceNextActionPerformed
        jLabel5.setText("");
        EditorPanel edi = getSelectedEditor();
        if (edi == null) return;
        boolean found = getSelectedEditor().replaceNext(jTextFieldSearch.getText(), jTextFieldReplace.getText(), jCheckBoxIgnoreCase.isSelected(), true);
        if (!found) jLabel5.setText("not found!");
    }//GEN-LAST:event_jButtonReplaceNextActionPerformed

    private void jButtonReplaceAllActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonReplaceAllActionPerformed
       
        jLabel5.setText("");
        EditorPanel edi = getSelectedEditor();
        if (edi == null) return;
        int found = getSelectedEditor().replaceAll(jTextFieldSearch.getText(), jTextFieldReplace.getText(), jCheckBoxIgnoreCase.isSelected());
        if (found==0) jLabel5.setText("not found!");
        else jLabel5.setText(""+found+" replaced");
    }//GEN-LAST:event_jButtonReplaceAllActionPerformed

    private void jButtonReplaceInSelectionActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonReplaceInSelectionActionPerformed
        jLabel5.setText("");
        EditorPanel edi = getSelectedEditor();
        if (edi == null) return;
        int found = getSelectedEditor().replaceInSelection(jTextFieldSearch.getText(), jTextFieldReplace.getText(), jCheckBoxIgnoreCase.isSelected());
        if (found==0) jLabel5.setText("not found!");
        else jLabel5.setText(""+found+" replaced");
    }//GEN-LAST:event_jButtonReplaceInSelectionActionPerformed

    private void jTextFieldReplaceActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldReplaceActionPerformed
        jButtonReplaceNextActionPerformed(null);
    }//GEN-LAST:event_jTextFieldReplaceActionPerformed

    private void jTextFieldSearchKeyPressed(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTextFieldSearchKeyPressed
        jLabel5.setText("");
    }//GEN-LAST:event_jTextFieldSearchKeyPressed

    private void jButtonNewActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonNewActionPerformed
        
    }//GEN-LAST:event_jButtonNewActionPerformed

    private void jTextFieldSearchActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldSearchActionPerformed
        jButtonSearchNextActionPerformed(null);
    }//GEN-LAST:event_jTextFieldSearchActionPerformed

    
    // output "Tabs" for source generation
    final int TAB_EQU = 30;
    final int TAB_EQU_VALUE = 40;
    final int TAB_MNEMONIC = 20;
    final int TAB_OP = 30;
    final int TAB_COMMENT = 58;
    
    int spaceTo(StringBuilder s, int posNow, int upTo)
    {
        s.append(" ");posNow++; //at least 1;
        while (posNow++<upTo) s.append(" ");
        return posNow;
    }
    
    String prettyQuoteLine(String line)
    {
        String preQuote;
        String quote;
        String postQuote;
        int startQuote;
        String quoteChar = "\"";
        startQuote = line.indexOf("\"");
        if (line.indexOf("'")>startQuote)
        {
            quoteChar = "'";
            startQuote = line.indexOf("'");
        }
        int endQuote = line.lastIndexOf(quoteChar);
        if (endQuote<=startQuote) return line;
        preQuote = line.substring(0,startQuote);
        quote = line.substring(startQuote, endQuote+1);
        postQuote = line.substring(endQuote+1);
        
        StringBuilder b = new StringBuilder();
        String[] words = preQuote.split(" ");
        int w = 0;
        int c = 0;
        if (!UtilityString.isWordBoundry(line.charAt(0)))
        {
            b.append(words[w]).append(" ");
            c+=words[w].length()+1;
            w++;
        }
        c = spaceTo(b, c, TAB_MNEMONIC);
        if (w>=words.length)
        {
            b.append(quote);
            c+=quote.length();
            c = spaceTo(b, c, TAB_OP);
            b.append(postQuote);
            return b.toString();
        }
        while (words[w].length()==0) w++;
        b.append(words[w]).append(" ");
        c+=words[w].length()+1;
        w++;
        c = spaceTo(b, c, TAB_OP);

        for (;w<words.length;w++)
        {
            if (words[w].length()!=0)
            {
                b.append(words[w]).append(" ");
                c+=words[w].length()+1;
            }
        }
        b.append(quote);
        c+=quote.length();
        b.append(postQuote);
        return b.toString();
    }
    
    int getFirstnonQuoteComment(String line)
    {
        String preQuote;
        String quote;
        String postQuote;
        int startQuote;
        String quoteChar = "\"";
        startQuote = line.indexOf("\"");
        if (line.indexOf("'")>startQuote)
        {
            quoteChar = "'";
            startQuote = line.indexOf("'");
        }
        int endQuote = line.lastIndexOf(quoteChar);
        if (endQuote<=startQuote) return -1;
        preQuote = line.substring(0,startQuote);
        quote = line.substring(startQuote, endQuote+1);
        postQuote = line.substring(endQuote+1);
        int ind = postQuote.indexOf(";");
        if (ind == -1) return -1;
        return ind+preQuote.length()+quote.length();
    }

    private void jButtonPrettyPrintActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonPrettyPrintActionPerformed

        if (getSelectedEditor()==null) return;
        StringBuilder b = new StringBuilder();
        String orgText = getSelectedEditor().getText();
        String[] lines = orgText.split("\n");
        for (String line: lines)
        {
            boolean doSeperator = false;
            boolean inComment = false;
            int c = 0;
            int w = 0;
            if ((line.contains("\"")) || (line.contains("\'")))
            {
                int commentPos = line.indexOf(";");
                int q1 = line.indexOf("\"");
                int q2 = line.indexOf("'");
                if (q1 == -1) q1 = Integer.MAX_VALUE;
                if (q2 == -1) q2 = Integer.MAX_VALUE;
                if (commentPos == -1) commentPos = Integer.MAX_VALUE;
                
                if (!((commentPos<q1) && (commentPos<q2)))
                {
                    b.append(prettyQuoteLine(line)).append("\n"); // 
                    continue;
                }
            }
            if (line.trim().length()==0) continue;
            if (line.charAt(0)==';')
            {
                b.append(line).append("\n"); // leave them for now
                continue;
            }
            line = UtilityString.replace(line, "\t", " ");
            String[] words = line.split(" ");

            if (!UtilityString.isWordBoundry(line.charAt(0)))
            {
                b.append(words[w]).append(" ");
                c+=words[w].length()+1;
                w++;
            }
            if (w>=words.length)
            {
                b.append("\n"); 
                continue;
            }
            c = spaceTo(b, c, TAB_MNEMONIC);
            while (words[w].length()==0) w++;
            b.append(words[w]).append(" ");
            
            if (words[w].toLowerCase().equals("rts")) doSeperator = true;
            if (words[w].toLowerCase().equals("jmp")) doSeperator = true;
            if (words[w].toLowerCase().equals("bra")) doSeperator = true;
            if (words[w].toLowerCase().equals("lbra")) doSeperator = true;
            
            c+=words[w].length()+1;
            w++;

            if (!(line.toString().trim().startsWith(";")))
                c = spaceTo(b, c, TAB_OP);
            for (;w<words.length;w++)
            {
                if (words[w].length()!=0)
                {
                    b.append(words[w]).append(" ");
                    c+=words[w].length()+1;
                }
            }
            b.append("\n");
            if (doSeperator)
                b.append("\n");
        }
        String text = b.toString();
        b = new StringBuilder();
        lines = text.split("\n");
        for (String line: lines)
        {
            boolean inComment = false;
            int c = 0;
            int w = 0;
            int commentPos = -1;
            if ((line.contains("\"")) || (line.contains("\'")))
            {
                
                commentPos = line.indexOf(";");
                int q1 = line.indexOf("\"");
                int q2 = line.indexOf("'");
                if (q1 == -1) q1 = Integer.MAX_VALUE;
                if (q2 == -1) q2 = Integer.MAX_VALUE;
                if (commentPos == -1) commentPos = Integer.MAX_VALUE;
                
                if (!((commentPos<q1) && (commentPos<q2)))
                {
                    commentPos = getFirstnonQuoteComment(line);
                }
            }
            else
            {
                
                commentPos = line.indexOf(";");
            }
            if (commentPos <= 0)
            {
                b.append(line).append("\n"); // 
                continue;
            }
            String preComment = UtilityString.trimEnd(line.substring(0, commentPos));
            String comment = line.substring(commentPos);
            b.append(preComment);
            c = preComment.length();
            c = spaceTo(b, c, TAB_COMMENT);
            b.append(comment).append("\n");
        }
        text = b.toString();
        getSelectedEditor().stopColoring();
        getSelectedEditor().setText(text);
        getSelectedEditor().startColoring();
    }//GEN-LAST:event_jButtonPrettyPrintActionPerformed

    private void jMenuItemNewFileActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemNewFileActionPerformed

        InternalFrameFileChoser fc = new de.malban.gui.dialogs.InternalFrameFileChoser();
        
        if (lastPath.length()==0)
        {
            fc.setCurrentDirectory(new java.io.File("."+File.separator));
        }
        else
        {
            fc.setCurrentDirectory(new java.io.File(lastPath));
        }
        
        int r = fc.showOpenDialog(Configuration.getConfiguration().getMainFrame());
        if (r != InternalFrameFileChoser.APPROVE_OPTION) return;
        lastPath = fc.getSelectedFile().getAbsolutePath();
        
        File newFile = new File(lastPath);
        if (newFile.exists())
        {
            // todo, make this CSA Fullscreen conform!
            JOptionPane pane = new JOptionPane("The file already exists, do you really want\nto create a new file?\n\nAll previous data will be lost!", JOptionPane.WARNING_MESSAGE, JOptionPane.OK_CANCEL_OPTION);
            int answer = JOptionPaneDialog.show(pane);
            if (answer == JOptionPane.YES_OPTION)
                System.out.println("YES");
            else
            {
                System.out.println("NO");
                return;
            }
        }
        de.malban.util.UtilityFiles.createTextFile(lastPath, "");
        addEditor(lastPath, true);
        oneTimeTab = null;
        refreshTree();
    }//GEN-LAST:event_jMenuItemNewFileActionPerformed
    
    public void addTempEditFile(String filePath)
    {
        addEditor(filePath, false);
        oneTimeTab = null;
        refreshTree();
    }
    
    private void jPopupMenu1MouseExited(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jPopupMenu1MouseExited
        jPopupMenu1.setVisible(false);
    }//GEN-LAST:event_jPopupMenu1MouseExited

    private void jButtonNewMousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jButtonNewMousePressed
        if (KeyboardListener.isShiftDown()) return;
        jPopupMenu1.show(jButtonNew, evt.getX()-20,evt.getY()-20);
    }//GEN-LAST:event_jButtonNewMousePressed

    private void jMenuItemVectrexFileActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemVectrexFileActionPerformed
        InternalFrameFileChoser fc = new de.malban.gui.dialogs.InternalFrameFileChoser();
        
        if (lastPath.length()==0)
        {
            fc.setCurrentDirectory(new java.io.File("."+File.separator));
        }
        else
        {
            fc.setCurrentDirectory(new java.io.File(lastPath));
        }
        
        int r = fc.showOpenDialog(Configuration.getConfiguration().getMainFrame());
        if (r != InternalFrameFileChoser.APPROVE_OPTION) return;
        lastPath = fc.getSelectedFile().getAbsolutePath();
        
        File newFile = new File(lastPath);
        if (newFile.exists())
        {
            JOptionPane pane = new JOptionPane("The file already exists, do you really want\nto create a new file?\n\nAll previous data will be lost!", JOptionPane.WARNING_MESSAGE, JOptionPane.OK_CANCEL_OPTION);
            int answer = JOptionPaneDialog.show(pane);
            if (answer == JOptionPane.YES_OPTION)
                System.out.println("YES");
            else
            {
                System.out.println("NO");
                return;
            }
        }
        
        Path template = Paths.get(".", "template", "vectrexMain.template");
        de.malban.util.UtilityFiles.copyOneFile(template.toString(), lastPath);
        Path include = Paths.get(".", "template", "VECTREX.I");
        
        
        Path p = Paths.get(lastPath);
        File includeFile = new File(p.getParent().toString()+File.separator+ "VECTREX.I");
        de.malban.util.UtilityFiles.copyOneFile(include.toString(), includeFile.toString());
        
        addEditor(lastPath, true);        
        oneTimeTab = null;
    }//GEN-LAST:event_jMenuItemVectrexFileActionPerformed

    private void jMenuItemFilePropertiesActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemFilePropertiesActionPerformed
        doFileProperties(selectedTreeEntry);
    }//GEN-LAST:event_jMenuItemFilePropertiesActionPerformed

    private void jMenuItemModiActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemModiActionPerformed
        doMod2Vectrex();
    }//GEN-LAST:event_jMenuItemModiActionPerformed

    private void jTabbedPaneStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jTabbedPaneStateChanged
        Rectangle r = jPanel3.getBounds();
        r.height = 27;
        jPanel3.setBounds(r);
    }//GEN-LAST:event_jTabbedPaneStateChanged

    private void jMenuItemRenameActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemRenameActionPerformed
        if (selectedTreePath == null) return;
        jTree1.startEditingAtPath(selectedTreePath);
    }//GEN-LAST:event_jMenuItemRenameActionPerformed

    private void jMenuItemDeleteActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemDeleteActionPerformed
        de.malban.util.UtilityFiles.deleteFile(selectedTreeEntry.pathAndName.toString());

        
        // check for a property file!
        String type ="";
        String pathFull ="";
        String pathOnly ="";
        String filenameOnly ="";
        String filenameBaseOnly ="";
        Path p = Paths.get(selectedTreeEntry.pathAndName.toString());
        pathFull = p.toString();
        pathOnly = p.getParent().toString();
        filenameOnly = p.getFileName().toString();

        if (filenameOnly.contains("."))
        {
            filenameBaseOnly  =filenameOnly.substring(0, filenameOnly.indexOf("."));
            type = filenameOnly.substring(filenameOnly.indexOf(".")+1);
        }
        else
            filenameBaseOnly = filenameOnly;
        File test = new File(pathOnly+File.separator+ filenameBaseOnly+"FileProperty.xml");
        if (test.exists())
        {
            
            FilePropertiesPool pool = new FilePropertiesPool(pathOnly+File.separator, test.getName());
            FileProperties fileProperties =  pool.get(filenameOnly);
            if (fileProperties!=null)
            {
                if (fileProperties.getFilename().endsWith(filenameOnly))
                {
                    de.malban.util.UtilityFiles.deleteFile(pathOnly+File.separator+ filenameBaseOnly+"FileProperty.xml");
                }
            }
        }
        
        refreshTree();
    }//GEN-LAST:event_jMenuItemDeleteActionPerformed

    public void refreshTree()
    {
        fillTree(currentStartPath);        
    }
    
    private void jMenuItemDuplicateActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemDuplicateActionPerformed
        if (selectedTreeEntry == null) return;
        de.malban.util.UtilityFiles.copyOneFile(selectedTreeEntry.pathAndName.toString(),  selectedTreeEntry.pathAndName.toString()+".copy");
        refreshTree();
    }//GEN-LAST:event_jMenuItemDuplicateActionPerformed

     
    
    private void jMenuItemActionActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemActionActionPerformed
        if (selectedTreeEntry == null) return;
        String filename = selectedTreeEntry.pathAndName.toString();
        File file = new File(filename);
        String path = file.getParent();
        String fileNameOnly = file.getName();
        String fileNameBare = fileNameOnly;
        int li = fileNameOnly.lastIndexOf(".");
        if (li>=0) 
            fileNameBare = fileNameOnly.substring(0,li);
        if (path.length() != 0) path += File.separator;
        File test = new File(path+fileNameBare+"FileProperty.xml");

        if (test.exists())
        {
            String pathOnly = test.getParent().toString();
            if (pathOnly.length()!=0) pathOnly+=File.separator;
            FilePropertiesPool pool = new FilePropertiesPool(pathOnly, test.getName());

            FileProperties fileProperties =  pool.get(fileNameOnly);
            if (fileProperties == null) return;

            String scriptClass = fileProperties.getActionScriptClass();
            String scriptName = fileProperties.getActionScriptName();
            ExecutionDescriptor ed = new ExecutionDescriptor(ED_TYPE_FILE_ACTION, "", fileNameOnly, "VediPanel32", pathOnly);
            if (!ScriptDataPanel.executeScript(scriptClass, scriptName, VediPanel32.this, ed))
            {
                printWarning("Script for "+fileNameOnly+" returned with error!");
            }
        }

        scanTreeDirectory(selectedTreeEntry);

    }//GEN-LAST:event_jMenuItemActionActionPerformed

    private void jButtonClearMessagesActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonClearMessagesActionPerformed
        jEditorLog.setText("");
        
    }//GEN-LAST:event_jButtonClearMessagesActionPerformed

    private void jMenuItemRasterActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemRasterActionPerformed
        doRasterImage();
    }//GEN-LAST:event_jMenuItemRasterActionPerformed

    private void jMenuItemYMActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemYMActionPerformed
        // check for a property file!
        String type ="";
        String pathFull ="";
        String pathOnly ="";
        String filenameOnly ="";
        String filenameBaseOnly ="";
        Path p = Paths.get(selectedTreeEntry.pathAndName.toString());
        pathFull = p.toString();
        pathOnly = p.getParent().toString();
        filenameOnly = p.getFileName().toString();
        YMJPanel.showYMPanelNoModal(pathFull, this);


    }//GEN-LAST:event_jMenuItemYMActionPerformed
    boolean fileView = true;
    private void jButtonRefreshActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonRefreshActionPerformed
        refreshTree();
    }//GEN-LAST:event_jButtonRefreshActionPerformed

    private void jMenuItemVectorActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemVectorActionPerformed
        doVector();
    }//GEN-LAST:event_jMenuItemVectorActionPerformed

    private void jTextFieldCommandActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldCommandActionPerformed
        String command = jTextFieldCommand.getText();
        jTextFieldCommand.setText("");
        doQuickHelp(command, command);
    }//GEN-LAST:event_jTextFieldCommandActionPerformed

    private void jTree1ValueChanged(javax.swing.event.TreeSelectionEvent evt) {//GEN-FIRST:event_jTree1ValueChanged
        if (!(((DefaultMutableTreeNode)evt.getPath().getLastPathComponent()).getUserObject() instanceof TreeEntry)) return;
        closeOneTimeTab();
        TreeEntry entry = (TreeEntry) ((DefaultMutableTreeNode)evt.getPath().getLastPathComponent()).getUserObject();
        if (entry.type == DIR) return;


        if ( (entry.name.toLowerCase().endsWith(".asm")) ||
            (entry.name.toLowerCase().endsWith(".s")) ||
            (entry.name.toLowerCase().endsWith(".as9")) ||
            (entry.name.toLowerCase().endsWith(".a69")) ||
            (entry.name.toLowerCase().endsWith(".template")) ||
            (entry.name.toLowerCase().endsWith(".i")) ||
            (entry.name.toLowerCase().endsWith(".inc"))
        )
        {
            addEditor(entry.pathAndName.toString(), true);
            oneTimeTab = null;
        }
        else if ( (entry.name.toLowerCase().endsWith(".bas")) 
        )
        {
            addEditor(entry.pathAndName.toString(), true);
            oneTimeTab = null;
        }
        else if ( (entry.name.toLowerCase().endsWith(".txt")) ||
            (entry.name.toLowerCase().endsWith(".diz")) ||
            (entry.name.toLowerCase().endsWith(".doc")) ||
            (entry.name.toLowerCase().endsWith(".c")) ||
            (entry.name.toLowerCase().endsWith(".cc")) ||
            (entry.name.toLowerCase().endsWith(".js")) ||
            (entry.name.toLowerCase().endsWith(".cpp")) ||
            (entry.name.toLowerCase().endsWith(".java")) ||
            (entry.name.toLowerCase().endsWith(".xml")) ||
            (entry.name.toLowerCase().endsWith(".html")) ||
            (entry.name.toLowerCase().endsWith(".bat")) ||
            (entry.name.toLowerCase().endsWith(".man")) ||
            (entry.name.toLowerCase().endsWith(".lst")) ||
            (entry.name.toLowerCase().endsWith(".cnt")) ||
            (entry.name.toLowerCase().endsWith(".h"))
        )
        {
            addEditor(entry.pathAndName.toString(), true);
        }
        else if ( (entry.name.toLowerCase().endsWith(".png")) ||
            (entry.name.toLowerCase().endsWith(".jpg")) ||
            (entry.name.toLowerCase().endsWith(".gif")) ||
            (entry.name.toLowerCase().endsWith(".bmp"))
        )
        {
            addImageDisplay(entry.pathAndName.toString(), false);
        }
        else
        {
            addBinaryDisplay(entry.pathAndName.toString(), false);
        }

    }//GEN-LAST:event_jTree1ValueChanged

    private void jTree1MousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jTree1MousePressed
        // popup in relation to node under tree
        selectedTreeEntry = null;
        selectedTreePath = null;
        if (SwingUtilities.isRightMouseButton(evt))
        {
            if (root == null) return;

            int rowReal = jTree1.getRowForLocation(evt.getX(), evt.getY());

            int row = jTree1.getClosestRowForLocation(evt.getX(), evt.getY());
            selectedTreePath = jTree1.getPathForLocation(evt.getX(), evt.getY());
            jTree1.setSelectionRow(row);

            if (jTree1.getSelectionPath() == null) return;
            if (((DefaultMutableTreeNode) jTree1.getSelectionPath().getLastPathComponent()) == root)
            {
                if (rowReal != row)
                {
                    jMenuItemModi.setEnabled(false);
                    jMenuItemYM.setEnabled(false);
                    jMenuItemRaster.setEnabled(false);
                    jMenuItemVector.setEnabled(false);
                    jPopupMenuTree.show(evt.getComponent(), evt.getX(),evt.getY());
                    selectedTreeEntry = null;

                    return;
                }
                return;
            }
            if (jTree1.getSelectionPath().getLastPathComponent() == null) return;
            if (((DefaultMutableTreeNode)jTree1.getSelectionPath().getLastPathComponent()).getUserObject() == null) return;
            TreeEntry te = (TreeEntry)((DefaultMutableTreeNode) jTree1.getSelectionPath().getLastPathComponent()).getUserObject();

            if (te.type==DIR) return;
            selectedTreeEntry = te;

            jMenuItemModi.setEnabled(te.name.toLowerCase().endsWith(".mod"));
            //  jMenuItemModi.setEnabled(true);
            jMenuItemYM.setEnabled(te.name.toLowerCase().endsWith(".ym"));
            jMenuItemYM.setEnabled(true);
            jMenuItemRaster.setEnabled(
                te.name.toLowerCase().endsWith(".jpg") ||
                te.name.toLowerCase().endsWith(".gif") ||
                te.name.toLowerCase().endsWith(".png") ||
                te.name.toLowerCase().endsWith(".bmp")
            );

            jMenuItemVector.setEnabled(
                te.name.toLowerCase().endsWith(".jpg") ||
                te.name.toLowerCase().endsWith(".gif") ||
                te.name.toLowerCase().endsWith(".png") ||
                te.name.toLowerCase().endsWith(".bmp")
            );

            jPopupMenuTree.show(evt.getComponent(), evt.getX(),evt.getY());
        }
    }//GEN-LAST:event_jTree1MousePressed

    private void jButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton1ActionPerformed
        connect();
    }//GEN-LAST:event_jButton1ActionPerformed

    private void jButton2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton2ActionPerformed
        fillSerial();
    }//GEN-LAST:event_jButton2ActionPerformed

    private void jEditorLogKeyTyped(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jEditorLogKeyTyped
        handleTerminalKey(evt.getKeyChar());
    }//GEN-LAST:event_jEditorLogKeyTyped

    private void jButtonFileSelect1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonFileSelect1ActionPerformed
        InternalFrameFileChoser fc = new de.malban.gui.dialogs.InternalFrameFileChoser();
        fc.setDialogTitle("Select Vectrex32 drive");
        fc.setCurrentDirectory(new java.io.File(File.separator));
        fc.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);

        int r = fc.showOpenDialog(Configuration.getConfiguration().getMainFrame());
        if (r != InternalFrameFileChoser.APPROVE_OPTION) return;
        String lastPath = fc.getSelectedFile().getAbsolutePath();

        Path p = Paths.get(lastPath);
        currentStartPath = p;
        jTextFieldPath.setText(p.toString());
        refreshTree();

    }//GEN-LAST:event_jButtonFileSelect1ActionPerformed
    
    public void doQuickHelp(String word, String integer)
    {
        if (!displayHelp(word))
            doCalculator(integer);
    }

    // receives the contents of the textfield after a return
    public boolean doCalculator(String command)
    {
        try
        {
            Double d = eval(command) ;
            int i = (int) d.intValue();
            if ((i<256) && (i>-128))
                printMessage("Result: "+i+", $"+String.format("%02X", i & 0xFF)+", "+DASM6809.printbinary(i));
            else
                printMessage("Result: "+i+", $"+String.format("%X", i)+", "+DASM6809.printbinary16(i));
        }
        catch (Throwable x)
        {
            return false;
        }
        return true;
    }

    public String getLine(JEditorPane comp, int pos)
    {
        try
        {
            return comp.getDocument().getText(0, comp.getDocument().getLength()).split("\n")[pos];
        }
        catch (Throwable e)
        {
        }
        return "";
    }
    int getLineOfPos(JEditorPane comp, int pos)
    {
        int ret = -1;
        try
        {
            String[] lines = comp.getDocument().getText(0, comp.getDocument().getLength()).split("\n");
            int count = 0;
            int c = -1;
            while (count <= pos)
            {
                c++;
                count += lines[c].length()+1; // because of "/n"
            }
            if (c < lines.length) ret = c;
        }
        catch (Throwable e)
        {
        }
        return ret;
    }    
    EditorPanel getSelectedEditor()
    {
        if (jTabbedPane1.getSelectedComponent() instanceof EditorPanel)
            return (EditorPanel) jTabbedPane1.getSelectedComponent();
        return null;
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton jButton1;
    private javax.swing.JButton jButton2;
    private javax.swing.JButton jButtonAssemble;
    private javax.swing.JButton jButtonClearMessages;
    private javax.swing.JButton jButtonCopy;
    private javax.swing.JButton jButtonCut;
    private javax.swing.JButton jButtonFileSelect1;
    private javax.swing.JButton jButtonIgnoreCase;
    private javax.swing.JButton jButtonLoad;
    private javax.swing.JButton jButtonNew;
    private javax.swing.JButton jButtonPaste;
    private javax.swing.JButton jButtonPrettyPrint;
    private javax.swing.JButton jButtonRedo;
    private javax.swing.JButton jButtonRefresh;
    private javax.swing.JButton jButtonReplaceAll;
    private javax.swing.JButton jButtonReplaceInSelection;
    private javax.swing.JButton jButtonReplaceNext;
    private javax.swing.JButton jButtonSave;
    private javax.swing.JButton jButtonSaveAll;
    private javax.swing.JButton jButtonSearchNext;
    private javax.swing.JButton jButtonSearchPrevious;
    private javax.swing.JButton jButtonUndo;
    private javax.swing.JCheckBox jCheckBoxIgnoreCase;
    private javax.swing.JComboBox jComboBoxSerial;
    private javax.swing.JEditorPane jEditorLog;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel10;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JLabel jLabel6;
    private javax.swing.JLabel jLabel7;
    private javax.swing.JLabel jLabel8;
    private javax.swing.JLabel jLabel9;
    private javax.swing.JMenuItem jMenuItemAction;
    private javax.swing.JMenuItem jMenuItemDelete;
    private javax.swing.JMenuItem jMenuItemDuplicate;
    private javax.swing.JMenuItem jMenuItemFileProperties;
    private javax.swing.JMenuItem jMenuItemModi;
    private javax.swing.JMenuItem jMenuItemNewFile;
    private javax.swing.JMenuItem jMenuItemRaster;
    private javax.swing.JMenuItem jMenuItemRename;
    private javax.swing.JMenuItem jMenuItemVector;
    private javax.swing.JMenuItem jMenuItemVectrexFile;
    private javax.swing.JMenuItem jMenuItemYM;
    private javax.swing.JMenu jMenuNewFileMenu;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JPanel jPanel3;
    private javax.swing.JPanel jPanel6;
    private javax.swing.JPopupMenu jPopupMenu1;
    private javax.swing.JPopupMenu jPopupMenuTree;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JScrollPane jScrollPane2;
    private javax.swing.JPopupMenu.Separator jSeparator1;
    private javax.swing.JPopupMenu.Separator jSeparator2;
    private javax.swing.JPopupMenu.Separator jSeparator3;
    private javax.swing.JSplitPane jSplitPane1;
    private javax.swing.JSplitPane jSplitPane2;
    private javax.swing.JTabbedPane jTabbedPane;
    private javax.swing.JTabbedPane jTabbedPane1;
    private javax.swing.JTabbedPane jTabbedPane2;
    private javax.swing.JTextField jTextFieldCommand;
    private javax.swing.JTextField jTextFieldPath;
    private javax.swing.JTextField jTextFieldReplace;
    private javax.swing.JTextField jTextFieldSearch;
    private javax.swing.JTree jTree1;
    // End of variables declaration//GEN-END:variables

    public void editorChanged(EditorEvent ev)
    {
        tabChanged(false);
    }
    
    public void printMessage(String s)
    {
        try
        {
            jEditorLog.getDocument().insertString(jEditorLog.getDocument().getLength(), s+"\n", TokenStyles.getStyle("editLogMessage"));
        } catch (Throwable e) { }
        jEditorLog.setCaretPosition(jEditorLog.getDocument().getLength());
    }
    public void printWarning(String s)
    {
        try
        {
            jEditorLog.getDocument().insertString(jEditorLog.getDocument().getLength(), s+"\n", TokenStyles.getStyle("editLogWarning"));
        } catch (Throwable e) { }
        jEditorLog.setCaretPosition(jEditorLog.getDocument().getLength());
    }    
    public void printError(String s)
    {
        try
        {
            jEditorLog.getDocument().insertString(jEditorLog.getDocument().getLength(), s+"\n", TokenStyles.getStyle("error"));
        } catch (Throwable e) { }
        jEditorLog.setCaretPosition(jEditorLog.getDocument().getLength());
    }
    
    public void printMessageSU(final String s)
    {
        SwingUtilities.invokeLater(new Runnable()
        {
            public void run()
            {
                printMessage(s);
            }
        });                    
    }    
    public void printWarningSU(final String s)
    {
        SwingUtilities.invokeLater(new Runnable()
        {
            public void run()
            {
                printWarning(s);
            }
        });                    
    }    
    public void printErrorSU(final String s)
    {
        SwingUtilities.invokeLater(new Runnable()
        {
            public void run()
            {
                printError(s);
            }
        });                    
    }    
    
    
    
    
    // mainly update position info
    // on true, the tab "really" changed, than a recolor
    // is done, since global variable might have changed
    public void tabChanged(boolean really)
    {
        // correct button enables
        if (getSelectedEditor() == null)
        {
            jButtonRedo.setEnabled(false);
            jButtonUndo.setEnabled(false);

            jLabel3.setText("0 chars");
            jLabel4.setText("row/col: 0/0");
            jLabel5.setText("");
            return;
        }
        jButtonRedo.setEnabled(getSelectedEditor().canRedo());
        jButtonUndo.setEnabled(getSelectedEditor().canUndo());
        
        jLabel3.setText(""+getSelectedEditor().getCharCount()+" chars");
        Point p = getSelectedEditor().getCursorPos();
        jLabel4.setText("row/col: "+p.y+"/"+p.x);
        if (really)
        jLabel5.setText("");
        if (really)
            getSelectedEditor().reColor();
    }
    protected boolean closeRequested(String tabName)
    {
        int count = jTabbedPane1.getTabCount();
        int found = -1;
        for (int i=0; i< count; i++)
        {
            if (tabName.equals(jTabbedPane1.getTitleAt(i)))
            {
                found = i;
                break;
            }
        }
        if (found == -1) return false;
        Component com = jTabbedPane1.getComponentAt(found);
        if (jTabbedPane1.getComponentAt(found) instanceof EditorPanel)
        {
            EditorPanel edit = (EditorPanel)jTabbedPane1.getComponentAt(found);
            // todo check and ask for save!

            settings.currentOpenFiles.remove(edit.getFilename());
            settings.recentOpenFiles.remove(edit.getFilename()); // no doubles
            settings.recentOpenFiles.add(edit.getFilename());
            edit.deinit();
        }
        
        return true;
    }

    
    // figure out filename and line, - if possible
    private void processErrorLine(String lineString)
    {
        // if something is not as expected... well just do nothing
        try
        {
            int lineNumberStart = lineString.indexOf("(")+1;
            int lineNumberEnd = lineString.indexOf(")");

            String lineNumberString = lineString.substring(lineNumberStart,lineNumberEnd);
            int lineNumber = Integer.parseInt(lineNumberString);
            lineString = de.malban.util.UtilityString.replace(lineString, "MACRO-EXPAND from ", "").trim();
            String filename = lineString.substring(0, lineString.indexOf("("));
            
//            filename = convertASMFilename(filename);
            
            jumpToEdit(filename, lineNumber);
        }
        catch (Throwable e)
        {
            
        }
    }
    
    // figure out filename and line, - if possible
    public void processIncludeLine(String lineString)
    {
        // if something is not as expected... well just do nothing
        lineString = convertSeperator(lineString);
        try
        {
            int start = lineString.toLowerCase().indexOf("include");
            if (start <0) return;
            String line = lineString.substring(start+7).trim();
            String[] parts = line.split("\"");
            String name = "";
            if (parts.length<=1) 
                parts = line.split("'");
            if (parts.length<=1) 
                parts = line.split(" ");
            if (parts.length<=1) 
                return;
            String filename = parts[0].trim();
            if (filename.length()==0)filename = parts[1].trim();
            if (filename.length()==0)return;
            String path = getSelectedEditor().getPath();
            String nameToLoad = "";
            if (path != null)
            {
                nameToLoad=path+File.separator;
            }
            nameToLoad+=filename;
            jumpToEdit(nameToLoad, 0);
        }
        catch (Throwable e)
        {
            
        }
    }
    EditorPanel getEditor(String filename)
    {
        String name = "edi";
        Path path = Paths.get(filename);
        name = path.getFileName().toString();
        
        int found = -1;
        for (int i=0; i < jTabbedPane1.getTabCount(); i++)
        {
            String tabName = jTabbedPane1.getTitleAt(i);
            if (tabName.equals(name))
            {
                found = i;
                break;
            }
        }
        if (found != -1)
        {
            jTabbedPane1.setSelectedComponent(jTabbedPane1.getComponentAt(found));
            return (EditorPanel)jTabbedPane1.getComponentAt(found);
        }
        
        EditorPanel edi = addEditor(filename, true);
        oneTimeTab = null;
        return edi;
    }
    
    private void jumpToEdit(String filename, int lineNumber)
    {
        EditorPanel edi = getEditor(filename);
        if (edi == null)
        {
            printError("Could not access editor for: \""+filename+"\"");
        }
        
        edi.goLine(lineNumber);
    }
    public void requestSearchFocus()
    {
        jTextFieldSearch.requestFocusInWindow();
    }
    
    class TreeEntry
    {
        int type;
        String name;
        Path pathAndName;
        DefaultMutableTreeNode myNode;
        DefaultMutableTreeNode parentNode;
        public TreeEntry(Path p)
        {
            pathAndName = p;
            type = p.toFile().isDirectory()?DIR:FILE;
            if (pathAndName.getFileName()==null)
            {
                name = "";
            }
            else
                name = pathAndName.getFileName().toString();
        }
        public String toString()
        {
            return name;
        }
    }
    
    void scanTreeDirectory(TreeEntry selectedTreeEntry)
    {
        if (selectedTreeEntry==null) return;
        DefaultMutableTreeNode parent = selectedTreeEntry.parentNode;
        if (parent == null) return;

    
        TreeEntry entry = (TreeEntry) parent.getUserObject();
        if (entry.type == FILE) return;
        Path basePath = entry.pathAndName;
        
        File directory = basePath.toFile();

        // get all the files from a directory
        File[] fList = directory.listFiles();
        ArrayList<Integer> indexe = new ArrayList<Integer>();
        ArrayList<DefaultMutableTreeNode> added = new ArrayList<DefaultMutableTreeNode>();
        int i=0;
        for (File file : fList) 
        {
            if (file.getName().contains("FileProperty.xml")) continue;
            if (file.getName().contains("ProjectProperty.xml")) continue;
            Path name = Paths.get(basePath.toString(), file.getName());
            if (!hasDirectChild(parent, name))
            {
                TreeEntry newEntry = new TreeEntry(name);
                DefaultMutableTreeNode child = new DefaultMutableTreeNode(newEntry);
                newEntry.myNode = child;
                newEntry.parentNode = parent;
                parent.add(child);
                addChildren(child);
                added.add(child);
                indexe.add(i);
            }
            i++;
        }
        jTree1.updateUI();
    }

    boolean hasDirectChild(DefaultMutableTreeNode parent, Path name)
    {
        if (name == null) return false;
        Enumeration en = parent.children();
        while (en.hasMoreElements()) 
        {
            DefaultMutableTreeNode node = (DefaultMutableTreeNode) en.nextElement();
            TreeEntry entry = (TreeEntry)node.getUserObject();
            if (entry == null) continue;
            if (name.equals(entry.pathAndName)) return true;
        }        
        return false;
    }
    
    public static final int DIR = 0;
    public static final int FILE = 1;
    public boolean projectLoaded = true;
    void fillTree()
    {
        Path startpath = Paths.get(".","codelib");
        fillTree(startpath);
    }
    void fillTree(Path startpath)
    {
        if (fileView)
        {
            fillTreeFiles(startpath);
            return;
        }
        jTree1.setModel(new DefaultTreeModel(null));
        return;
    }
    void fillTreeFiles(Path startpath)
    {
//        Path startpath = Paths.get(".","");
        DefaultMutableTreeNode root = new DefaultMutableTreeNode(new TreeEntry(startpath));
        addChildrenFile(root);
        jTree1.setModel(new DefaultTreeModel(root));
    }
    boolean addChildrenFile(DefaultMutableTreeNode node)
    {
        TreeEntry entry = (TreeEntry) node.getUserObject();
        if (entry.type == FILE) return false;
        Path basePath = entry.pathAndName;
        
        File directory = basePath.toFile();

        // get all the files from a directory
        File[] fList = directory.listFiles();
        for (File file : fList) 
        {
            TreeEntry newEntry = new TreeEntry(Paths.get(basePath.toString(), file.getName()));
            DefaultMutableTreeNode child = new DefaultMutableTreeNode(newEntry);
            node.add(child);
            addChildrenFile(child);
        }
        return true;
    }    
    boolean addChildren(DefaultMutableTreeNode node)
    {
        TreeEntry entry = (TreeEntry) node.getUserObject();
        if (entry.type == FILE) return false;
        Path basePath = entry.pathAndName;
        
        File directory = basePath.toFile();

        // get all the files from a directory
        File[] fList = directory.listFiles();
        for (File file : fList) 
        {
            if (file.getName().contains("FileProperty.xml")) continue;
            if (file.getName().contains("ProjectProperty.xml")) continue;
            TreeEntry newEntry = new TreeEntry(Paths.get(basePath.toString(), file.getName()));
            DefaultMutableTreeNode child = new DefaultMutableTreeNode(newEntry);
            newEntry.myNode = child;
            newEntry.parentNode = node;
            node.add(child);
            addChildren(child);
        }
        return true;
    }
    TreeEntry getTreeEntry(DefaultMutableTreeNode node,  String name)
    {
        TreeEntry entry = (TreeEntry) node.getUserObject();
        if (entry.pathAndName.toString().equals(name)) return entry;
        
        Enumeration en = node.children();
        while (en.hasMoreElements())
        {
            DefaultMutableTreeNode nextNode = (DefaultMutableTreeNode) en.nextElement();
            entry = getTreeEntry( nextNode,  name);
            if (entry != null) return entry;
        }
        return null;
    }
    // expects full path name(s)
    // exchanges in a node the path to another name
    // called from a save as
    public void changeFileName(String oldFileName, String newFileName)
    {
        try
        {
            String newName = Paths.get(newFileName).getFileName().toString();
            String oldName = Paths.get(oldFileName).getFileName().toString();
            
            int count = jTabbedPane1.getTabCount();
            int found = -1;
            for (int i=0; i< count; i++)
            {
                if (oldName.equals(jTabbedPane1.getTitleAt(i)))
                {
                    found = i;
                    break;
                }
            }
            refreshTree();
            if (found != -1)
            {
                jTabbedPane1.setTitleAt(found, newName);
                JPanel tabPanel = (JPanel)jTabbedPane1.getTabComponentAt(found);
                for (int t=0; t<tabPanel.getComponentCount(); t++)
                {
                    if (tabPanel.getComponent(t) instanceof JLabel)
                    {
                        JLabel lblTitle = (JLabel)tabPanel.getComponent(t);
                        lblTitle.setText(newName+"  ");
                    }
                    if (tabPanel.getComponent(t) instanceof CloseButton)
                    {
                        CloseButton btnClose = (CloseButton)tabPanel.getComponent(t);
                        btnClose.renameTo(newName);
                    }
                }
                Component com = jTabbedPane1.getComponentAt(found);
                EditorPanel edit = (EditorPanel)jTabbedPane1.getComponentAt(found);
                settings.currentOpenFiles.remove(oldFileName);
                settings.currentOpenFiles.add(newFileName);
                edit.replaceFilename(newFileName);
            }
            
        }
        catch (Throwable e)
        {
            e.printStackTrace();
        }
    }
    void changeFileName(TreeEntry leaf, String newFilename)
    {
        if (leaf == null) return;
        if (newFilename == null) return;
        if (newFilename.trim().length() == 0) return;
        String fullName = leaf.pathAndName.toString();
        
        if (de.malban.util.UtilityFiles.rename(leaf.pathAndName.toString(), newFilename))
        {
            String oldName = leaf.name;
            leaf.name = newFilename;
            
            int count = jTabbedPane1.getTabCount();
            int found = -1;
            for (int i=0; i< count; i++)
            {
                if (oldName.equals(jTabbedPane1.getTitleAt(i)))
                {
                    found = i;
                    break;
                }
            }
            String oldFileName = leaf.pathAndName.toString();
            String newFileName = de.malban.util.UtilityString.replace(leaf.pathAndName.toString(), oldName, newFilename);
            leaf.pathAndName = Paths.get(newFileName);
            ASM6809FileInfo.replaceFileName(oldFileName, newFileName);
            if (found != -1)
            {
                jTabbedPane1.setTitleAt(found, newFilename);
                JPanel tabPanel = (JPanel)jTabbedPane1.getTabComponentAt(found);
                for (int t=0; t<tabPanel.getComponentCount(); t++)
                {
                    if (tabPanel.getComponent(t) instanceof JLabel)
                    {
                        JLabel lblTitle = (JLabel)tabPanel.getComponent(t);
                        lblTitle.setText(newFilename+"  ");
                    }
                    if (tabPanel.getComponent(t) instanceof CloseButton)
                    {
                        CloseButton btnClose = (CloseButton)tabPanel.getComponent(t);
                        btnClose.renameTo(newFilename);
                    }
                }
                Component com = jTabbedPane1.getComponentAt(found);
                if (jTabbedPane1.getComponentAt(found) instanceof EditorPanel)
                {
                    EditorPanel edit = (EditorPanel)jTabbedPane1.getComponentAt(found);
                    settings.currentOpenFiles.remove(oldFileName);
                    settings.currentOpenFiles.add(newFileName);
                    edit.replaceFilename(newFileName);
                }
            }
            
            // check for a property file!
            String type ="";
            String pathFull ="";
            String pathOnly ="";
            String filenameOnly ="";
            String filenameBaseOnly ="";
            Path p = Paths.get(fullName);
            
            if (p == null) return;
            pathFull = p.toString();
            if (p.getParent() == null) 
                pathOnly="";
            else
                pathOnly = p.getParent().toString();
            filenameOnly = p.getFileName().toString();

            if (filenameOnly.contains("."))
            {
                filenameBaseOnly  =filenameOnly.substring(0, filenameOnly.indexOf("."));
                type = filenameOnly.substring(filenameOnly.indexOf(".")+1);
            }
            else
                filenameBaseOnly = filenameOnly;
            
            String start ="";
            if (pathOnly.length()!=0)
                start = pathOnly+File.separator;
            File test = new File(start+ filenameBaseOnly+"FileProperty.xml");
            if (test.exists())
            {
                FilePropertiesPool pool = new FilePropertiesPool(start, filenameBaseOnly+"FileProperty.xml");
                FileProperties fileProperties =  pool.get(filenameOnly);
                if (fileProperties == null)
                {
                    // something is wrong here!
                }
                else
                {
                    pool.remove(fileProperties);

                    String ntype ="";
                    String npathFull ="";
                    String npathOnly ="";
                    String nfilenameOnly ="";
                    String nfilenameBaseOnly ="";
                    
                    Path np = Paths.get(leaf.pathAndName.toString());
                    npathFull = np.toString();
                    if (np.getParent() != null)
                        npathOnly = np.getParent().toString();
                    nfilenameOnly = np.getFileName().toString();

                    if (nfilenameOnly.contains("."))
                    {
                        nfilenameBaseOnly  =nfilenameOnly.substring(0, nfilenameOnly.indexOf("."));
                        ntype = nfilenameOnly.substring(nfilenameOnly.indexOf(".")+1);
                    }
                    else
                        nfilenameBaseOnly = nfilenameOnly;                    
                    
                    fileProperties.mName = nfilenameOnly;
                    fileProperties.setFilename(npathFull);
                    fileProperties.setTyp(ntype);
                    pool.put(fileProperties);
                    pool.save();
                    
                    String start2 = "";
                    if (pathOnly.length()!=0)
                        start2 = pathOnly+File.separator;
                    de.malban.util.UtilityFiles.rename(start2+ filenameBaseOnly+"FileProperty.xml", nfilenameBaseOnly+"FileProperty.xml");
                }
            }
        }
    }

    
    public void processWord(String word)
    {
        EntityDefinition entity = LabelSink.knownGlobalVariables.get(word.toLowerCase());
        if (entity == null)
        {
            entity = MacroSink.knownGlobalMacros.get(word.toLowerCase());        
        }
        if (entity == null) 
        {
            printWarning("no definition found for: \""+word+"\"");
            return;
        }
        StringBuilder message = new StringBuilder();
        message.append("\"").append(word).append("\":");
        if (entity.getType() == EntityDefinition.TYP_LABEL) message.append(" label");
        else message.append(" macro");
        message.append("\n");
        message.append("defined at: ").append(entity.getFile().toString()).append("(").append(entity.getLineNumber()).append(")");
        printMessage(message.toString());

        try
        {
            final String filename = entity.getFile().toString();
            if (filename.length()==0)return;
            final int line = entity.getLineNumber();
            SwingUtilities.invokeLater(new Runnable()
            {
                public void run()
                {
                    jumpToEdit(filename, line);
                }
            });                    
        }
        catch (Throwable e)
        {
            
        }    
    }
    private void closeAllEditors()
    {
        while (jTabbedPane1.getTabCount()>0)
        {
            String tabName = jTabbedPane1.getTitleAt(0);
            boolean ok = closeRequested(tabName);  
            // TODO ask if save is needed etc
            if (ok)
            {
                JPanel tabPanel = (JPanel)jTabbedPane1.getTabComponentAt(0);
                if (tabPanel != null) // ???
                {
                    for (int t=0; t<tabPanel.getComponentCount(); t++)
                    {
                        if (tabPanel.getComponent(t) instanceof CloseButton)
                        {
                            CloseButton btnClose = (CloseButton)tabPanel.getComponent(t);
                            btnClose.clearCloseListerner();
                        }
                    }
                }
                /*
                Component comp = jTabbedPane1.getComponentAt(0);
                if (comp instanceof EditorPanel)
                {
                    EditorPanel edi = (EditorPanel) comp;
                    edi.stopColoring();
                }
                */
                jTabbedPane1.removeTabAt(0);
            }
        }
    }
    private boolean nameExistAsTab(String n)
    {
        for (int i=0; i<jTabbedPane1.getTabCount();i++)
        {
            String tabTitle = jTabbedPane1.getTitleAt(i);
            if (n.equals(tabTitle)) return true;
        }
        return false;
    }  
    private void doFileProperties(TreeEntry te)
    {
         FilePropertiesPanel.showEditFileProperties(selectedTreeEntry.pathAndName.toString());
    }

    
    public static String convertSeperator(String filename)
    {
        String ret = de.malban.util.UtilityString.replace(filename, "/", File.separator);
        ret = de.malban.util.UtilityString.replace(ret, "\\", File.separator);
        return ret;
    }
    boolean skipInternalProcessing(String filename)
    {
        File file = new File(filename);
        String fileNameOnly = file.getName();
        String fileNameBare = fileNameOnly;
        int li = filename.lastIndexOf(".");
        if (li>=0) 
            filename = filename.substring(0,li);
        File test = new File(filename+"FileProperty.xml");
        if (test.exists())
        {
            String pathOnly = test.getParent().toString();
            if (pathOnly.length()!=0) pathOnly+=File.separator;
            FilePropertiesPool pool = new FilePropertiesPool(pathOnly, test.getName());

            FileProperties fileProperties =  pool.get(fileNameOnly);
            if (fileProperties == null) return false;
            return fileProperties.getNoInternalProcessing();
        }
        
        return false;
    }    
/*    
    // get all the files from a directory
    String executeFileScripts(String type, String path)
    {
        File directory = new File(path);
        File[] fList = directory.listFiles();
        for (File file : fList) 
        {
            String fileNameOnly = file.getName();
            String fileNameBare = fileNameOnly;
            int li = fileNameOnly.lastIndexOf(".");
            if (li>=0) 
                fileNameBare = fileNameOnly.substring(0,li);
            if (path.length() != 0) path += File.separator;
            File test = new File(path+fileNameBare+"FileProperty.xml");
            if (test.exists())
            {
                String pathOnly = test.getParent().toString();
                if (pathOnly.length()!=0) pathOnly+=File.separator;
                FilePropertiesPool pool = new FilePropertiesPool(pathOnly, test.getName());

                FileProperties fileProperties =  pool.get(fileNameOnly);
                if (fileProperties == null) continue;

                ExecutionDescriptor ed;
                String scriptClass;
                String scriptName;
                if (type.equals("Pre"))
                {
                    scriptClass = fileProperties.getPreScriptClass();
                    scriptName = fileProperties.getPreScriptName();
                    ed = new ExecutionDescriptor(ED_TYPE_FILE_PRE, currentProject.getProjectName(), fileNameOnly, "VediPanel", pathOnly);
                }
                else
                {
                    scriptClass = fileProperties.getPostScriptClass();
                    scriptName = fileProperties.getPostScriptName();
                    ed = new ExecutionDescriptor(ED_TYPE_FILE_POST, currentProject.getProjectName(), fileNameOnly, "VediPanel", pathOnly);
                }
                if (!ScriptDataPanel.executeScript(scriptClass, scriptName, VediPanel32.this, ed))
                    return file.getName();
            }
        }
        return null;
    }                           
*/
    void saveAll()
    {
        for (int i=0; i<jTabbedPane1.getTabCount();i++)
        {
            if (jTabbedPane1.getComponentAt(i) instanceof EditorPanel)
            {
                EditorPanel ep = (EditorPanel) jTabbedPane1.getComponentAt(i);
                ep.save(false);
            }
        }
    }
    void closeOneTimeTab()
    {
        if (oneTimeTab == null) return;
        int index = -1;
        for (int i=0;i<jTabbedPane1.getTabCount(); i++)
        {
            String tabName = jTabbedPane1.getTitleAt(i);
            if (tabName.equals(oneTimeTab))
            {
                index = i ;
                break;
            }
        }
        if (index == -1) return;

            
        boolean ok = closeRequested(oneTimeTab);  
        // TODO ask if save is needed etc
        if (ok)
        {
            JPanel tabPanel = (JPanel)jTabbedPane1.getTabComponentAt(index);
            if (tabPanel != null) // ???
            {
                for (int t=0; t<tabPanel.getComponentCount(); t++)
                {
                    if (tabPanel.getComponent(t) instanceof CloseButton)
                    {
                        CloseButton btnClose = (CloseButton)tabPanel.getComponent(t);
                        btnClose.clearCloseListerner();
                    }
                }
            }

            jTabbedPane1.removeTabAt(index);
        }
    }
    boolean tabExistsSwitch(TreeEntry entry)
    {
        String tabname = entry.pathAndName.getFileName().toString();

        return tabExistsSwitch(tabname);
    }
    boolean tabExistsSwitch(String tabname)
    {
        int count = jTabbedPane1.getTabCount();
        int found = -1;
        for (int i=0; i< count; i++)
        {
            if (tabname.equals(jTabbedPane1.getTitleAt(i)))
            {
                found = i;
                break;
            }
        }
        if (found == -1) return false;
        jTabbedPane1.setSelectedIndex(found);
        return true;
    }
    
    void doRasterImage()
    {
        // check for a property file!
        String type ="";
        String pathFull ="";
        String pathOnly ="";
        String filenameOnly ="";
        String filenameBaseOnly ="";
        Path p = Paths.get(selectedTreeEntry.pathAndName.toString());
        pathFull = p.toString();
        pathOnly = p.getParent().toString();
        filenameOnly = p.getFileName().toString();
        boolean pic = false;
        if (filenameOnly.endsWith(".gif"))pic = true;
        if (filenameOnly.endsWith(".jpg"))pic = true;
        if (filenameOnly.endsWith(".png"))pic = true;
        if (filenameOnly.endsWith(".bmp"))pic = true;
        if (!pic) 
        {
            printError("Selected entry does not have a known image extension!");
            return;
        }
        
        boolean done  = RasterPanel.showRasterPanel(pathFull);
        if (!done) return; // cancel or error
        refreshTree();
    }

    
    private void doMod2Vectrex()
    {
        // check for a property file!
        String type ="";
        String pathFull ="";
        String pathOnly ="";
        String filenameOnly ="";
        String filenameBaseOnly ="";
        Path p = Paths.get(selectedTreeEntry.pathAndName.toString());
        pathFull = p.toString();
        pathOnly = p.getParent().toString();
        filenameOnly = p.getFileName().toString();
        ModJPanel.showModPanelNoModal(pathFull, this);
    }

    public void returnFromModPanel(boolean d)
    {
        boolean done = d;
        if (!done) return; // cancel or error
        refreshTree();

        scanTreeDirectory(selectedTreeEntry);
        // reload entries;
    }
    public void returnFromYMPanel(boolean d)
    {
        boolean done = d;
        if (!done) return; // cancel or error
        refreshTree();

        scanTreeDirectory(selectedTreeEntry);
        // reload entries;
    }
    
    
    void doVector()
    {
        // check for a property file!
        String type ="";
        String pathFull ="";
        String pathOnly ="";
        String filenameOnly ="";
        String filenameBaseOnly ="";
        Path p = Paths.get(selectedTreeEntry.pathAndName.toString());
        pathFull = p.toString();
        pathOnly = p.getParent().toString();
        filenameOnly = p.getFileName().toString();
        boolean pic = false;
        if (filenameOnly.endsWith(".gif"))pic = true;
        if (filenameOnly.endsWith(".jpg"))pic = true;
        if (filenameOnly.endsWith(".png"))pic = true;
        if (filenameOnly.endsWith(".bmp"))pic = true;
        if (!pic) 
        {
            printError("Selected entry does not have a known image extension!");
            return;
        }
        
        VectorJPanel.showModPanelNoModal(pathFull, this);
    }
    public static boolean displayHelp(String h)
    {
        h = h.toLowerCase();
        String path = "help"+File.separator;
        
        String full = path+h+".html";
        File f = new File(full);
        if (!f.exists())
            full = path+h+".htm";
        f = new File(full);
        if (f.exists())
        {
            QuickHelpTopFrame.showHelpHtmlFile(full);
            return true;
        }
        full = path+h+".png";
        f = new File(full);
        if (f.exists())
        {
            QuickHelpTopFrame.showHelpPNGFile(full);
            return true;
        }
        return false;
    }
    public void printASMList(String s, int type){}
    public void printASMMessage(String s, int type){}
    
    
    
    byte typed = 0;
    
    SerialPort ubxPort = null;
    SerialPort[] ports;
    void handleTerminalKey(char t)
    {
        typed = (byte)t;
        if (ubxPort!=null)
        {
            byte[] buffer = new byte[1];
            if (typed == 10) // lf
                typed = 0x0d; // cr
            buffer[0] = typed;
            ubxPort.writeBytes(buffer, 1);

            if (typed == 03) // CTRL / C
            {
                buffer[0] = 0x0d;
                ubxPort.writeBytes(buffer, 1);
            }
                
        }
        
    }
    
    void fillSerial()
    {
        ports = SerialPort.getCommPorts();
                
        ArrayList<SerialPort> pp = new ArrayList<SerialPort>();
        for (SerialPort p: ports)
        {
            if (!p.getDescriptivePortName().toLowerCase().contains("dial"))
            {
                pp.add(p);
            }
        }
        ports = pp.toArray(new SerialPort[0]);
        
        mClassSetting++;
        jComboBoxSerial.removeAllItems();
        for (SerialPort p: ports)
        {
            jComboBoxSerial.addItem(p.getDescriptivePortName());
        }
        
        if (settings.vec32PortName.length()>0)
        {
            int index = 0;
            for (SerialPort p: ports)
            {
                if (p.getDescriptivePortName().equals(settings.vec32PortName))
                {
                    jComboBoxSerial.setSelectedIndex(index);
                    break;
                }
                index++;
            }
        }
        jTextFieldPath.setText(settings.vec32UsbMount);
        mClassSetting--;
    }
    SerialPortDataListener listener = new SerialPortDataListener() 
    {
        @Override
        public int getListeningEvents() { return SerialPort.LISTENING_EVENT_DATA_AVAILABLE; }
        @Override
        public void serialEvent(SerialPortEvent event)
        {
            StringBuilder builder = new StringBuilder();
            SerialPort comPort = event.getSerialPort();
            int available = comPort.bytesAvailable();
            if (available<0) return;
            byte[] newData = new byte[available];
            int numRead = comPort.readBytes(newData, newData.length);
            if (numRead == 1) 
            {
                if (typed == newData[0]) return;
            }
            for (byte d: newData)
            {
                builder.append((char )d);
            }
            
        try
        {
            jEditorLog.getDocument().insertString(jEditorLog.getDocument().getLength(), builder.toString()+"", TokenStyles.getStyle("editLogMessage"));
        } catch (Throwable e) { }
        jEditorLog.setCaretPosition(jEditorLog.getDocument().getLength());
            
//System.out.println("Read " + numRead + " bytes.");
        }
    };
   
    void connect()
    {
        if (mClassSetting>0) return;
        int index = jComboBoxSerial.getSelectedIndex();
        if (index == -1) return;
        if (ubxPort != null)
        {
            ubxPort.removeDataListener();
            ubxPort.closePort();
            ubxPort = null;
            jLabel10.setText("not connected");
            jLabel10.setForeground(Color.red);
        }
        ubxPort = ports[index];
        boolean openedSuccessfully = ubxPort.openPort();
        if (openedSuccessfully)
        {
            printMessage("Connected");
        }
        else
        {
            printMessage("Not Connected");
            return;
        }
        
        ubxPort.setBaudRate(9600);
        ubxPort.setNumDataBits(8);
        ubxPort.setNumStopBits(ONE_STOP_BIT);
        ubxPort.setParity(NO_PARITY);
        ubxPort.setComPortTimeouts(SerialPort.TIMEOUT_NONBLOCKING, 1000, 0);

        ubxPort.addDataListener(listener);
        jLabel10.setText("connected");
        jLabel10.setForeground(Color.green);
    }
    void runBas(String fname)
    {
        if (ubxPort==null) 
        {
            printError("Not Connected!");
            return;
        }
        
        // first a CTRL c
        byte[] buffer = new byte[2];
        buffer[0] = 03;
        buffer[1] = 0x0d;
        toCard(buffer);
        
        toCard("\n");
        // stop whatever currently is running
        toCard("stop\n");

        toCard("load \""+fname+"\"\n");
        toCard("run\n");
    }
    void toCard(byte[] buffer)
    {
        ubxPort.writeBytes(buffer, buffer.length);
    }
    void toCard(String buffer)
    {
        String ret = "" + ((char)0x0d);
        buffer = de.malban.util.UtilityString.replace(buffer, "\n", ret);
        toCard(buffer.getBytes());
    }
}
