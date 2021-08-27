/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
  
package de.malban.vide.vedi; 
   
import com.fazecast.jSerialComm.SerialPort;
import de.malban.Global;
import de.malban.vide.vedi.panels.BinaryPanel;
import de.malban.vide.vedi.panels.ImagePanel;
import de.malban.gui.HotKey;
import de.malban.config.Configuration;
import de.malban.config.TinyLogInterface;
import de.malban.gui.CSAMainFrame;
import de.malban.gui.TimingTriggerer;
import de.malban.gui.TriggerCallback;
import de.malban.gui.dialogs.InternalFrameFileChoser;
import de.malban.gui.dialogs.QuickHelpTopFrame;
import de.malban.gui.panels.LogPanel;
import static de.malban.gui.panels.LogPanel.INFO;
import static de.malban.gui.panels.LogPanel.WARN;
import de.malban.util.UtilityFiles;
import static de.malban.util.UtilityFiles.executeOSCommand;
import de.malban.util.syntax.Syntax.TokenStyles;
import de.malban.util.UtilityString;
import de.malban.util.syntax.entities.ASM6809FileMaster;
import de.malban.util.syntax.entities.C6809FileMaster;
import de.malban.util.syntax.entities.EntityDefinition;
import de.malban.util.syntax.entities.SyntaxDebugJPanel;
import de.malban.vide.VideConfig;
import de.malban.vide.assy.Asmj;
import de.malban.vide.assy.Comment;
import de.malban.vide.dissy.DASM6809;
import de.malban.vide.script.*;
import static de.malban.vide.dissy.DissiPanel.eval;
import static de.malban.vide.script.ExecutionDescriptor.*;
import static de.malban.vide.vecx.VecX.START_TYPE_DEBUG;
import static de.malban.vide.vecx.VecX.START_TYPE_INJECT;
import static de.malban.vide.vecx.VecX.START_TYPE_RUN;
import static de.malban.vide.vecx.VecX.START_TYPE_STOP;
import de.malban.vide.vecx.VecXPanel;
import de.malban.vide.vecx.cartridge.Cartridge;
import de.malban.vide.vecx.cartridge.CartridgeProperties;
import static de.malban.vide.vedi.DebugComment.COMMENT_TYPE_BREAK;
import static de.malban.vide.vedi.DebugComment.COMMENT_TYPE_WATCH;
import static de.malban.vide.vedi.VEdiFoundationPanel.ASM_LIST;
import static de.malban.vide.vedi.VEdiFoundationPanel.ASM_MESSAGE_ERROR;
import de.malban.vide.vedi.panels.GetIDValuePanel;
import de.malban.vide.vedi.panels.LabelVisibilityConfigPanel;
import de.malban.vide.vedi.peeper.FilePeeper;
import de.malban.vide.vedi.project.FileProperties;
import de.malban.vide.vedi.project.FilePropertiesPanel;
import de.malban.vide.vedi.project.FilePropertiesPool;
import de.malban.vide.vedi.project.ProjectProperties;
import de.malban.vide.vedi.project.ProjectPropertiesPanel;
import de.malban.vide.vedi.project.ProjectPropertiesPool;
import de.malban.vide.vedi.raster.RasterPanel;
import de.malban.vide.vedi.raster.VectorJPanel;
import de.malban.vide.vedi.sound.AKSBin;
import de.malban.vide.vedi.sound.ModJPanel;
import de.malban.vide.vedi.sound.SampleJPanel;
import de.malban.vide.vedi.sound.VecSpeechPanel;
import de.malban.vide.vedi.sound.YMJPanel;
import java.awt.Color;
import java.awt.Component;
import java.awt.Dimension;
import java.awt.Point;
import java.awt.Rectangle;
import java.awt.event.ActionEvent;
import static java.awt.event.ActionEvent.SHIFT_MASK;
import java.awt.event.KeyEvent;
import java.awt.event.MouseEvent;
import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;
import java.io.File;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.EventObject;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import javax.swing.AbstractAction;
import javax.swing.DefaultListModel;
import javax.swing.JComponent;
import javax.swing.JEditorPane;
import javax.swing.JFileChooser;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JTable;
import static javax.swing.JTable.AUTO_RESIZE_LAST_COLUMN;
import static javax.swing.JTable.AUTO_RESIZE_SUBSEQUENT_COLUMNS;
import javax.swing.JTree;
import javax.swing.KeyStroke;
import javax.swing.RowSorter;
import javax.swing.SortOrder;
import javax.swing.SwingUtilities;
import javax.swing.UIManager;
import javax.swing.event.RowSorterEvent;
import javax.swing.event.RowSorterListener;
import javax.swing.event.TreeSelectionEvent;
import javax.swing.event.TreeSelectionListener;
import javax.swing.table.AbstractTableModel;
import javax.swing.table.TableModel;
import javax.swing.table.TableRowSorter;
import javax.swing.text.StyleConstants;
import javax.swing.tree.DefaultMutableTreeNode;
import javax.swing.tree.DefaultTreeCellEditor;
import javax.swing.tree.DefaultTreeCellRenderer;
import javax.swing.tree.DefaultTreeModel;
import javax.swing.tree.TreeNode;
import javax.swing.tree.TreePath;

import static java.awt.event.InputEvent.SHIFT_DOWN_MASK;
import java.awt.geom.Point2D;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.RandomAccessFile;
import java.util.Arrays;
import java.util.Comparator;
import java.util.Vector;
import javax.swing.Action;
import javax.swing.text.DefaultEditorKit;


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
public class VediPanel extends VEdiFoundationPanel implements TinyLogInterface, EditorListener
{
    public static String SID = "Vedi";
    VideConfig config = VideConfig.getConfig();
    LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
    String oneTimeTab = null; 
    
    public static int scanCount = 0;
    boolean init = false;
    Color defaultForegroundColor=null;
    boolean inProject = false;
    ProjectProperties currentProject = null;
    DefaultListModel projectsListModel;
    DefaultListModel filesListModel;
    boolean loadSettings=true;
    BookmarkTableModel bookmarkModel = new BookmarkTableModel();
    
    class InventoryEntry
    {
        public String name="";
        public int line = 0;
        public int type = 0;
        public InventoryEntry (String n, int l, int t)
        {
            name = n;
            line = l;
            type = t;
        }
    }
    ArrayList<InventoryEntry> inventory = new ArrayList<InventoryEntry>();
    public class InventoryTableModel extends AbstractTableModel
    {
        public int getRowCount()
        {
            return inventory.size();
        }
        public int getColumnCount()
        {
            return 3;
        }
        public Object getValueAt(int row, int col)
        {
            if (row >=inventory.size()) return "";
            if (col == 0) return inventory.get(row).line;
            if (col == 1) return inventory.get(row).name;
            if (col == 2) return EntityDefinition.SUBTYPE_NAMES[inventory.get(row).type];
            return "";
        }
        public String getColumnName(int column) {
            if (column == 0) return "line";
            if (column == 1) return "name";
            if (column == 2) return "type";
          
            return "";
        }
        public Class<?> getColumnClass(int col) {
            if (col == 0) return Integer.class;
            return String.class;
        }
        public boolean isCellEditable(int rowIndex, int columnIndex) {
            return false;
        }
        public int getColWidth(int col)
        {
            if (col == 0) return 50;
            if (col == 1) return 180;
            if (col == 2) return 80;
            return 10;
        }
        public Color getBackground(int col)
        {
            if (col == 0) return new Color(200,255,200,255);
            return null; // default
        }

    }
    InventoryTableModel inventoryModel = new InventoryTableModel();
    TableRowSorter<TableModel> sorter;
    public class BookmarkTableModel extends AbstractTableModel
    {
        public int getRowCount()
        {
            return 10;
        }
        public int getColumnCount()
        {
            return 3;
        }
        public Object getValueAt(int row, int col)
        {
            if (col == 0) return row;
            Bookmark b = settings.bookmarks.get(row);
            if (b == null)
            {
                return "";
            }
            if (col == 1) return b.name;
            if (col == 2) return b.lineNumber;
            return "";
        }
        public String getColumnName(int column) {
            if (column == 0) return "no";
            if (column == 1) return "file";
            return "line";
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
            if (col == 1) return 200;
            return 10;
        }
        public Color getBackground(int col)
        {
            if (col == 0) return new Color(200,255,200,255);
            return null; // default
        }

    }
    WatchesTableModel watchesModel = new WatchesTableModel();
    public class WatchesTableModel extends AbstractTableModel
    {
        public int getRowCount()
        {
            Set entries = settings.allDebugComments.entrySet();
            Iterator it = entries.iterator();
            int count = 0;
            while (it.hasNext())
            {
                Map.Entry entry = (Map.Entry) it.next();
                DebugCommentList dbclist = (DebugCommentList) entry.getValue();
                String filename = (String)entry.getKey();
                ArrayList<DebugComment> list = dbclist.getList();
                for(DebugComment dbc: list)
                {
                    if (dbc.type == COMMENT_TYPE_WATCH)
                        count++;
                }
            }
            return count;
        }
        public int getColumnCount()
        {
            return 2;
        }
        public DebugComment getDebugComment(int row)
        {
            Set entries = settings.allDebugComments.entrySet();
            Iterator it = entries.iterator();
            int count = 0;
            while (it.hasNext())
            {
                Map.Entry entry = (Map.Entry) it.next();
                DebugCommentList dbclist = (DebugCommentList) entry.getValue();
                String filename = (String)entry.getKey();
                ArrayList<DebugComment> list = dbclist.getList();
                for(DebugComment dbc: list)
                {
                    if (dbc.type == COMMENT_TYPE_WATCH)
                    {
                        if (count == row)
                        {
                            return dbc;
                        }
                        count++;
                    }
                }
            }
            return null;
        }
        
        public Object getValueAt(int row, int col)
        {
            DebugComment dbc = getDebugComment(row);
            if (dbc == null) return "";
            if (col == 0) return dbc.varname;
            if (col == 1) return dbc.getSubtypeString();
            return "";
        }
        public String getColumnName(int column) {
            if (column == 0) return "name";
            if (column == 1) return "type";
            return "";
        }
        public Class<?> getColumnClass(int columnIndex) {
            return String.class;
        }
        public boolean isCellEditable(int rowIndex, int columnIndex) {
            return false;
        }
        public int getColWidth(int col)
        {
            if (col == 0) return 100;
            return 100;
        }
        public Color getBackground(int col)
        {
            if (col == 0) return new Color(200,255,200,255);
            return null; // default
        }

    }
    BreakpointTableModel breakpointModel = new BreakpointTableModel();
    public class BreakpointTableModel extends AbstractTableModel
    {
        public int getRowCount()
        {
            Set entries = settings.allDebugComments.entrySet();
            Iterator it = entries.iterator();
            int count = 0;
            while (it.hasNext())
            {
                Map.Entry entry = (Map.Entry) it.next();
                DebugCommentList dbclist = (DebugCommentList) entry.getValue();
                String filename = (String)entry.getKey();
                ArrayList<DebugComment> list = dbclist.getList();
                for(DebugComment dbc: list)
                {
                    if (dbc.type == COMMENT_TYPE_BREAK)
                        count++;
                }
            }
            return count;
        }
        public int getColumnCount()
        {
            return 2;
        }
        public DebugComment getDebugComment(int row)
        {
            Set entries = settings.allDebugComments.entrySet();
            Iterator it = entries.iterator();
            int count = 0;
            while (it.hasNext())
            {
                Map.Entry entry = (Map.Entry) it.next();
                DebugCommentList dbclist = (DebugCommentList) entry.getValue();
                String filename = (String)entry.getKey();
                ArrayList<DebugComment> list = dbclist.getList();
                for(DebugComment dbc: list)
                {
                    if (dbc.type == COMMENT_TYPE_BREAK)
                    {
                        if (count == row)
                        {
                            return dbc;
                        }
                        count++;
                    }
                }
            }
            return null;
        }
        
        public Object getValueAt(int row, int col)
        {
            DebugComment dbc = getDebugComment(row);
            if (dbc == null) return "";
            if (col == 0) return dbc.file;
            if (col == 1) return dbc.beforLineNo+1;
            return "";
        }
        public String getColumnName(int column) {
            if (column == 0) return "file";
            if (column == 1) return "line";
            return "";
        }
        public Class<?> getColumnClass(int columnIndex) {
            return String.class;
        }
        public boolean isCellEditable(int rowIndex, int columnIndex) {
            return false;
        }
        public int getColWidth(int col)
        {
            if (col == 0) return 200;
            return 10;
        }
        public Color getBackground(int col)
        {
            if (col == 0) return new Color(200,255,200,255);
            return null; // default
        }

    }
    public void updateTables()
    {
        jTableBreakpoints.tableChanged(null);
        jTableBookmarks.tableChanged(null);
        jTableWatches.tableChanged(null);
        jTableBreakpoints.repaint();
        jTableBookmarks.repaint();
        jTableWatches.repaint();
        
        
        jTableBookmarks.setAutoResizeMode(AUTO_RESIZE_LAST_COLUMN);
        for (int i=0; i< bookmarkModel.getColumnCount(); i++)
        {
            jTableBookmarks.getColumnModel().getColumn(i).setPreferredWidth(bookmarkModel.getColWidth(i));                
            jTableBookmarks.getColumnModel().getColumn(i).setWidth(bookmarkModel.getColWidth(i));  
        }
        jTableBookmarks.setAutoResizeMode(AUTO_RESIZE_SUBSEQUENT_COLUMNS);

        
        jTableBreakpoints.setAutoResizeMode(AUTO_RESIZE_LAST_COLUMN);
        for (int i=0; i< breakpointModel.getColumnCount(); i++)
        {
            jTableBreakpoints.getColumnModel().getColumn(i).setPreferredWidth(breakpointModel.getColWidth(i));                
            jTableBreakpoints.getColumnModel().getColumn(i).setWidth(breakpointModel.getColWidth(i));  
        }
        jTableBreakpoints.setAutoResizeMode(AUTO_RESIZE_SUBSEQUENT_COLUMNS);
        jTableWatches.setAutoResizeMode(AUTO_RESIZE_LAST_COLUMN);
        for (int i=0; i< watchesModel.getColumnCount(); i++)
        {
            jTableWatches.getColumnModel().getColumn(i).setPreferredWidth(watchesModel.getColWidth(i));                
            jTableWatches.getColumnModel().getColumn(i).setWidth(watchesModel.getColWidth(i));  
        }
        jTableWatches.setAutoResizeMode(AUTO_RESIZE_SUBSEQUENT_COLUMNS);
    }
    public boolean isLoadSettings()
    {
        return loadSettings;
    }
    String possibleProject = null;

    DebugCommentList getDebugComments(EditorPanel edi)
    {
        if (edi == null) return null;
        String key = de.malban.util.UtilityFiles.convertSeperator(de.malban.util.Utility.makeVideAbsolute(edi.getFilename())).toLowerCase(); 
        
        DebugCommentList list = settings.allDebugComments.get(key);
        if (list == null)
        {
            list = new DebugCommentList();
            settings.allDebugComments.put(key, list);
        }
        list.filename = de.malban.util.UtilityFiles.convertSeperator(de.malban.util.Utility.makeVideAbsolute(edi.getFilename()));
        return list;
    }
    private DebugCommentList getDebugComments(String fname)
    {
        String key = de.malban.util.UtilityFiles.convertSeperator(de.malban.util.Utility.makeVideAbsolute(fname)).toLowerCase(); 
        DebugCommentList list = settings.allDebugComments.get(key);
        return list;
    }
    
    TreeEntry selectedTreeEntry = null;
    TreePath selectedTreePath = null;
    DefaultMutableTreeNode root = null;
    static ArrayList<VediPanel> listVedi = new ArrayList<VediPanel>();
    Path currentStartPath = Paths.get(".");

    public String getID()
    {
        return SID;
    }
    
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
    public static void addVedi(VediPanel vedi)
    {
        synchronized(listVedi)
        {
            listVedi.add(vedi);
        }
    }
    public static void removeVedi(VediPanel vedi)
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
                    for (VediPanel vp: listVedi)
                    {
                        if (working)vp.jLabel6.setText(" *");
                        else vp.jLabel6.setText("  ");
                        
                    }
                }
            }
        });                    
    }
    
    
    private String lastPath="";    
    /**
     * Creates new form RegisterJPanel
     */
    public VediPanel() {
        this(true);
    }
    public VediPanel(boolean ls) {
        initComponents();
        jMenuItem1.setVisible(false);
        jSeparator4.setVisible(false);
        defaultForegroundColor = jLabel10.getForeground();
        jMenuItemVector.setVisible(false); // dsabled, do image conversion from vecci
        loadSettings = ls;
        jEditorLog.setEditable(false);
        jEditorLog.setContentType("text/html");
        jEditorASMMessages.setEditable(false);
        jEditorASMMessages.setContentType("text/html");
        jEditorPaneASMListing.setEditable(false);
        jEditorPaneASMListing.setContentType("text/html");
        
        
        // split panel per default uses F6
        // delete that default java mapping, since we would like to use F6 for "debug"
        jSplitPane1.getInputMap(JComponent.WHEN_ANCESTOR_OF_FOCUSED_COMPONENT) .put(KeyStroke.getKeyStroke(KeyEvent.VK_F6, 0), "none");        
        jSplitPane2.getInputMap(JComponent.WHEN_ANCESTOR_OF_FOCUSED_COMPONENT) .put(KeyStroke.getKeyStroke(KeyEvent.VK_F6, 0), "none");        
        jSplitPane3.getInputMap(JComponent.WHEN_ANCESTOR_OF_FOCUSED_COMPONENT) .put(KeyStroke.getKeyStroke(KeyEvent.VK_F6, 0), "none");        
        jSplitPane4.getInputMap(JComponent.WHEN_ANCESTOR_OF_FOCUSED_COMPONENT) .put(KeyStroke.getKeyStroke(KeyEvent.VK_F6, 0), "none");        

        
        jTableInventory.setModel(inventoryModel);
        
        sorter = new TableRowSorter<TableModel>(jTableInventory.getModel());
        jTableInventory.setRowSorter(sorter);
        sorter.addRowSorterListener(new RowSorterListener()
        {
            public void sorterChanged(RowSorterEvent e)
            {

            }
        }); 
        sorter.setSortsOnUpdates(true);
    
        
        
        List<RowSorter.SortKey> sortKeys = new ArrayList<>(2);
        sortKeys.add(new RowSorter.SortKey(0, SortOrder.ASCENDING));
        sortKeys.add(new RowSorter.SortKey(1, SortOrder.ASCENDING));
        sorter.setSortKeys(sortKeys);        
        
        init();
        UIManager.addPropertyChangeListener(pListener);
        updateMyUI(); 
        initScheduler();  
        jButtonAssembleOne1.setVisible(false);
        
    }
/*    
    // If we only support move operations...
    ds = new TreeDragSource(jTree1, DnDConstants.ACTION_MOVE);
    //ds = new TreeDragSource(tree, DnDConstants.ACTION_COPY_OR_MOVE);
    dt = new TreeDropTarget(jTree1);        
    }
    
    http://www.java2s.com/Code/Java/Swing-JFC/DnDdraganddropJTreecode.htm
    
  TreeDragSource ds;

  TreeDropTarget dt;
    
    class TreeDragSource implements DragSourceListener, DragGestureListener {

      DragSource source;

      DragGestureRecognizer recognizer;

      TransferableTreeNode transferable;

      DefaultMutableTreeNode oldNode;

      JTree sourceTree;

      public TreeDragSource(JTree tree, int actions) 
      {
        sourceTree = tree;
        source = new DragSource();
        recognizer = source.createDefaultDragGestureRecognizer(sourceTree,
            actions, this);
      }    
    
  //
   // Drag Gesture Handler
   //
  public void dragGestureRecognized(DragGestureEvent dge) {
    TreePath path = sourceTree.getSelectionPath();
    if ((path == null) || (path.getPathCount() <= 1)) {
      // We can't move the root node or an empty selection
      return;
    }
    oldNode = (DefaultMutableTreeNode) path.getLastPathComponent();
    transferable = new TransferableTreeNode(path);
    source.startDrag(dge, DragSource.DefaultMoveNoDrop, transferable, this);

    // If you support dropping the node anywhere, you should probably
    // start with a valid move cursor:
    //source.startDrag(dge, DragSource.DefaultMoveDrop, transferable,
    // this);
  }

  //
  // Drag Event Handlers
   //
  public void dragEnter(DragSourceDragEvent dsde) {
  }

  public void dragExit(DragSourceEvent dse) {
  }

  public void dragOver(DragSourceDragEvent dsde) {
  }

  public void dropActionChanged(DragSourceDragEvent dsde) {
    System.out.println("Action: " + dsde.getDropAction());
    System.out.println("Target Action: " + dsde.getTargetActions());
    System.out.println("User Action: " + dsde.getUserAction());
  }

  public void dragDropEnd(DragSourceDropEvent dsde) {
    //
    // to support move or copy, we have to check which occurred:
     //
    System.out.println("Drop Action: " + dsde.getDropAction());
    if (dsde.getDropSuccess()
        && (dsde.getDropAction() == DnDConstants.ACTION_MOVE)) {
      ((DefaultTreeModel) sourceTree.getModel())
          .removeNodeFromParent(oldNode);
    }

    //
    // * to support move only... if (dsde.getDropSuccess()) {
    // ((DefaultTreeModel)sourceTree.getModel()).removeNodeFromParent(oldNode); }
    //
  }
}

//TreeDropTarget.java
//A quick DropTarget that's looking for drops from draggable JTrees.
//

class TreeDropTarget implements DropTargetListener {

  DropTarget target;

  JTree targetTree;

  public TreeDropTarget(JTree tree) {
    targetTree = tree;
    target = new DropTarget(targetTree, this);
  }

  /// *
  // Drop Event Handlers
  //
  private TreeNode getNodeForEvent(DropTargetDragEvent dtde) {
    Point p = dtde.getLocation();
    DropTargetContext dtc = dtde.getDropTargetContext();
    JTree tree = (JTree) dtc.getComponent();
    TreePath path = tree.getClosestPathForLocation(p.x, p.y);
    return (TreeNode) path.getLastPathComponent();
  }

  public void dragEnter(DropTargetDragEvent dtde) {
    TreeNode node = getNodeForEvent(dtde);
    if (node.isLeaf()) {
      dtde.rejectDrag();
    } else {
      // start by supporting move operations
      //dtde.acceptDrag(DnDConstants.ACTION_MOVE);
      dtde.acceptDrag(dtde.getDropAction());
    }
  }

  public void dragOver(DropTargetDragEvent dtde) {
    TreeNode node = getNodeForEvent(dtde);
    if (node.isLeaf()) {
      dtde.rejectDrag();
    } else {
      // start by supporting move operations
      //dtde.acceptDrag(DnDConstants.ACTION_MOVE);
      dtde.acceptDrag(dtde.getDropAction());
    }
  }

  public void dragExit(DropTargetEvent dte) {
  }

  public void dropActionChanged(DropTargetDragEvent dtde) {
  }

  public void drop(DropTargetDropEvent dtde) {
    Point pt = dtde.getLocation();
    DropTargetContext dtc = dtde.getDropTargetContext();
    JTree tree = (JTree) dtc.getComponent();
    TreePath parentpath = tree.getClosestPathForLocation(pt.x, pt.y);
    DefaultMutableTreeNode parent = (DefaultMutableTreeNode) parentpath
        .getLastPathComponent();
    if (parent.isLeaf()) {
      dtde.rejectDrop();
      return;
    }

    try {
      Transferable tr = dtde.getTransferable();
      DataFlavor[] flavors = tr.getTransferDataFlavors();
      for (int i = 0; i < flavors.length; i++) {
        if (tr.isDataFlavorSupported(flavors[i])) {
          dtde.acceptDrop(dtde.getDropAction());
          TreePath p = (TreePath) tr.getTransferData(flavors[i]);
          DefaultMutableTreeNode node = (DefaultMutableTreeNode) p
              .getLastPathComponent();
          DefaultTreeModel model = (DefaultTreeModel) tree.getModel();
          model.insertNodeInto(node, parent, 0);
          dtde.dropComplete(true);
          return;
        }
      }
      dtde.rejectDrop();
    } catch (Exception e) {
      e.printStackTrace();
      dtde.rejectDrop();
    }
  }
}

//TransferableTreeNode.java
//A Transferable TreePath to be used with Drag & Drop applications.
//

class TransferableTreeNode implements Transferable {

  public DataFlavor TREE_PATH_FLAVOR = new DataFlavor(TreePath.class, "Tree Path");

  DataFlavor flavors[] = { TREE_PATH_FLAVOR };

  TreePath path;

  public TransferableTreeNode(TreePath tp) {
    path = tp;
  }

  public synchronized DataFlavor[] getTransferDataFlavors() {
    return flavors;
  }

  public boolean isDataFlavorSupported(DataFlavor flavor) {
    return (flavor.getRepresentationClass() == TreePath.class);
  }

  public synchronized Object getTransferData(DataFlavor flavor)
      throws UnsupportedFlavorException, IOException {
    if (isDataFlavorSupported(flavor)) {
      return (Object) path;
    } else {
      throw new UnsupportedFlavorException(flavor);
    }
  }
}
*/
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
        deinitScheduler();        

        settings.pos3 = jSplitPane3.getDividerLocation();
        settings.pos2 = jSplitPane2.getDividerLocation();
        settings.pos1 = jSplitPane1.getDividerLocation();
        settings.inventoryPos = jSplitPane4.getDividerLocation();

        for (Component c: jTabbedPane1.getComponents())
        {
            if (c instanceof de.malban.vide.vedi.EditorPanel)
            {
                EditorPanel ep = (EditorPanel) c;
                ep.deinit();
            }
        }
        saveSettings();
        init = false;
        VediPanel.removeVedi(this);
        removeUIListerner();
        deinitSyntax();
    }    

    public void init()
    {
        initSyntax();
        String lastLoadedFile =null;
        if (loadSettings())
        {
            setFontSize(settings.fontSize);
            if (isLoadSettings())
            {
                jSplitPane3.setDividerLocation(settings.pos3);
                jSplitPane2.setDividerLocation(settings.pos2);
                jSplitPane1.setDividerLocation(settings.pos1);
                jSplitPane4.setDividerLocation(settings.inventoryPos);
                
                if ((settings.currentProject != null) && (settings.currentProject.mName.trim().length()!=0))
                {
                    loadProject(settings.currentProject.mClass, settings.currentProject.mName, settings.currentProject.mFullPath);
                }
                ArrayList<EditorFileSettings> toRemove = new ArrayList<EditorFileSettings>();
                for (EditorFileSettings fn: settings.currentOpenFiles)
                {
                    EditorPanel edi = addEditor(de.malban.util.Utility.makeVideAbsolute(fn.filename), false);
                    if (edi == null)
                    {
                        // error while loading, remove file from current
                        toRemove. add(fn); 
                        continue;
                    }
                    else
                    {
                        lastLoadedFile = fn.filename;
                    }
                    edi.setPosition(fn.position);
                    oneTimeTab = null;
                }
                for (EditorFileSettings fn: toRemove) settings.currentOpenFiles.remove(fn);
                jCheckBoxIgnoreCase1.setSelected(settings.v4eEnabled);
                if (settings.v4eVolumeName != null)
                    jTextFieldPath.setText(settings.v4eVolumeName);
                checkVec4Ever(true);
            }
        }
        else
        {
            settings  = new VediSettings();
        }
        updateList();
        
        
        init = true;
        VediPanel.addVedi(this);
        if (!inProject)
        {
            if (lastLoadedFile != null)
                fillTree(Paths.get(lastLoadedFile).getParent());
            else
                fillTree();
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

        new HotKey("Search next", new AbstractAction() { public void actionPerformed(ActionEvent e) {  jButtonSearchNextActionPerformed(null); }}, this);
        new HotKey("Search previous", new AbstractAction() { public void actionPerformed(ActionEvent e) {  jButtonSearchPreviousActionPerformed(null); }}, this);
/*                
        new HotKey(javax.swing.text.DefaultEditorKit.copyAction,(Action)null, jTextFieldSearch);
        new HotKey(javax.swing.text.DefaultEditorKit.pasteAction,(Action) null, jTextFieldSearch);
        new HotKey(javax.swing.text.DefaultEditorKit.cutAction, (Action)null, jTextFieldSearch);
        new HotKey(javax.swing.text.DefaultEditorKit.selectAllAction, (Action)null, jTextFieldSearch);
        
        new HotKey(javax.swing.text.DefaultEditorKit.copyAction, DefaultEditorKit.copyAction, jTextFieldSearch);
        HotKey.addMap(KeyEvent.VK_C, java.awt.event.KeyEvent.META_DOWN_MASK, javax.swing.text.DefaultEditorKit.copyAction, "EditorSearch");
        HotKey.addMap(KeyEvent.VK_V, java.awt.event.KeyEvent.META_DOWN_MASK, javax.swing.text.DefaultEditorKit.pasteAction, "EditorSearch");
        HotKey.addMap(KeyEvent.VK_X, java.awt.event.KeyEvent.META_DOWN_MASK, javax.swing.text.DefaultEditorKit.cutAction, "EditorSearch");
        HotKey.addMap(KeyEvent.VK_A, java.awt.event.KeyEvent.META_DOWN_MASK, javax.swing.text.DefaultEditorKit.selectAllAction, "EditorSearch");
*/        
        if (isMac)
        {
            HotKey.addMacDefaults(jTextFieldSearch);
            HotKey.addMacDefaults(jTextFieldReplace);
            HotKey.addMacDefaults(jTextFieldCommand);
            HotKey.addMacDefaults(jEditorLog);
            HotKey.addMacDefaults(jEditorASMMessages);
            HotKey.addMacDefaults(jEditorPaneASMListing);
            
        }
        


        
        new HotKey("Run", new AbstractAction() { public void actionPerformed(ActionEvent e) {  run(); }}, this);
        new HotKey("Debug", new AbstractAction() { public void actionPerformed(ActionEvent e) { debug(); }}, this);

        new HotKey("SaveWin", new AbstractAction() { public void actionPerformed(ActionEvent e) { jButtonSaveActionPerformed(null); }}, this);
        new HotKey("SaveMac", new AbstractAction() { public void actionPerformed(ActionEvent e) { jButtonSaveActionPerformed(null); }}, this);
        
        
        
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
        
        jTableBookmarks.setModel(bookmarkModel);
        jTableBookmarks.setAutoResizeMode(AUTO_RESIZE_LAST_COLUMN);
        for (int i=0; i< bookmarkModel.getColumnCount(); i++)
        {
            jTableBookmarks.getColumnModel().getColumn(i).setPreferredWidth(bookmarkModel.getColWidth(i));                
            jTableBookmarks.getColumnModel().getColumn(i).setWidth(bookmarkModel.getColWidth(i));  
        }
        jTableBookmarks.setAutoResizeMode(AUTO_RESIZE_SUBSEQUENT_COLUMNS);

        
        jTableBreakpoints.setModel(breakpointModel);
        jTableBreakpoints.setAutoResizeMode(AUTO_RESIZE_LAST_COLUMN);
        for (int i=0; i< breakpointModel.getColumnCount(); i++)
        {
            jTableBreakpoints.getColumnModel().getColumn(i).setPreferredWidth(breakpointModel.getColWidth(i));                
            jTableBreakpoints.getColumnModel().getColumn(i).setWidth(breakpointModel.getColWidth(i));  
        }
        jTableBreakpoints.setAutoResizeMode(AUTO_RESIZE_SUBSEQUENT_COLUMNS);
        
        jTableWatches.setModel(watchesModel);
        jTableWatches.setAutoResizeMode(AUTO_RESIZE_LAST_COLUMN);
        for (int i=0; i< watchesModel.getColumnCount(); i++)
        {
            jTableWatches.getColumnModel().getColumn(i).setPreferredWidth(watchesModel.getColWidth(i));                
            jTableWatches.getColumnModel().getColumn(i).setWidth(watchesModel.getColWidth(i));  
        }
        jTableWatches.setAutoResizeMode(AUTO_RESIZE_SUBSEQUENT_COLUMNS);
        initInventory();
    }

    void setBookmark(int b)
    {
        Bookmark bm = new Bookmark();
        bm.number = b;
        bm.lineNumber = getSelectedEditor().getCursorPos().y;
        bm.name = getSelectedEditor().getFilename();
        bm.fullFilename = getSelectedEditor().getFilename();
        if (currentProject != null)
        bm.project = currentProject.getDirectoryName();
        settings.bookmarks.put(b, bm);
        printMessage("Bookmark set: " + bm.toString());
        updateTables();
    }
    
    void goBookmark(int b)
    {
        Bookmark bm = settings.bookmarks.get(b);
        if (bm == null) return;
        addHistory();
        printMessage("Bookmark go: " + bm.toString());
        
        addEditor(bm.fullFilename, true);
        
        tabExistsSwitch(bm.fullFilename);
        if (getSelectedEditor() == null) return;
        getSelectedEditor().jump(bm.lineNumber);
        updateTables();
        
    }
    void goBreakpoint(DebugComment dbc)
    {
        if (dbc == null) return;
        addHistory();
        
        addEditor(dbc.file, true);
        
        tabExistsSwitch(dbc.file);
        getSelectedEditor().jump(dbc.beforLineNo+1);
        updateTables();
    }
    
    public void updateList()
    {
        projectsListModel = new DefaultListModel();
        filesListModel = new DefaultListModel();
        for (VediSettings.P p: settings.recentProject)
        {
            projectsListModel.addElement(p);
        }
        jListProjects.setModel(projectsListModel);


        for (EditorFileSettings s: settings.recentOpenFiles)
        {
            Path p = Paths.get(s.filename);
            filesListModel.addElement(p.getFileName().toString());
        }
        jListFiles.setModel(filesListModel);
    }
    
    EditorPanel addEditor(String fullPathname, boolean addToSettings)
    {
        String name = "edi";
        Path path = Paths.get(fullPathname);
        name = path.getFileName().toString();
        EditorFileSettings oldSettings = null;
        int pos = 0;
        String settingsRel = de.malban.util.Utility.makeVideRelative(fullPathname);
        String settingsAbs = settingsAbs = de.malban.util.Utility.makeVideAbsolute(fullPathname);
        
        if (addToSettings)
        {
            if (settings.openContains(settingsAbs))
            {
                return null;
            }
            if (settings.openContains(settingsRel))
            {
                return null;
            }
           /*
            if (settings.recentContains(settingsAbs))
            {
                oldSettings = settings.getRecent(settingsAbs);
                settings.removeRecent(settingsAbs);
                pos = oldSettings.position;
                updateList();
            }
            if (settings.recentContains(settingsRel))
            {
                oldSettings = settings.getRecent(settingsRel);
                settings.removeRecent(settingsRel);
                pos = oldSettings.position;
                updateList();
            }
            */
        }
        else // even if not to be added to settings
            // look if a tab with that nameis open, do not open a second one!
        {
            EditorPanel edi = getEditor(settingsAbs, false); 
            if (edi != null)
            {
                // todo
                // ask reload or not
                
                // also gets it to front
                // for now - do not ask, but reload!
                edi.reload(true);
                return edi;
            }

/*
            int tabNumber = checkTabExists(settingsAbs);
            if (tabNumber != -1)
            {
                // todo
                // ask reload or not
                
                // also gets it to front
                EditorPanel edi = getEditor(settingsAbs, false); 

                
                
                // for now - do not ask, but reload!
                edi.reload(true);
                return edi;
            }
            */
        }
        

        EditorPanel edi = new EditorPanel(de.malban.util.Utility.makeVideAbsolute(fullPathname), this, UID);
        edi.setMinimumSize(new Dimension(5,5));
        edi.setAddToSettings(addToSettings);
        if (edi.isInitError()) return null;
        
        int count=0;
        String nname = name;
        while (jTabbedPane1.indexOfTab(nname) != -1) 
        {
            count++;
            if (count!= 0) nname = name+"-"+count;
        }
        name = nname;
        
        
        jTabbedPane1.addTab(name, null, edi, settingsRel);
        oneTimeTab = name;
        
        addCloseButton(jTabbedPane1, name);
        
        jTabbedPane1.setSelectedComponent(edi);
        edi.setTinyLog(this);
        edi.addEditorListener(this);
        jLabel5.setText("");
        if (addToSettings)
            settings.addOpen(de.malban.util.Utility.makeVideAbsolute(fullPathname),pos);
        edi.setParent(this);
        if (pos != 0)
        {
            edi.setPosition(pos);
        }
        
        return edi;
    }
    
    // expects full path name(s)
    // exchanges in a node the path to another name
    // called from a save as
    // return index of tab, or -1
    public int checkTabExists(String fileName)
    {
        String pathName = Paths.get(fileName).getFileName().toString();
        int count = jTabbedPane1.getTabCount();
        int found = -1;
        for (int i=0; i< count; i++)
        {
            if (pathName.equals(jTabbedPane1.getTitleAt(i)))
            {
                return i;
            }
        }
        return -1;
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
        jTabbedPane1.addTab(name, null, edi, fullPathname);
        addCloseButton(jTabbedPane1, name);
        jTabbedPane1.setSelectedComponent(edi);
        jLabel5.setText("");
        if (addToSettings)
            settings.addOpen(fullPathname,0);
        edi.setParent(this);
        return edi;
    }   
    public BinaryPanel addBinaryDisplay(String fullPathname, boolean addToSettings)
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
        BinaryPanel edi = new BinaryPanel(fullPathname, this);
        if (edi.isInitError()) return null;
        jTabbedPane1.addTab(name, null, edi, fullPathname);
        oneTimeTab = name;
        addCloseButton(jTabbedPane1, name);
        jTabbedPane1.setSelectedComponent(edi);
        jLabel5.setText("");
        if (addToSettings)
            settings.addOpen(fullPathname,0);
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
        jMenuItemCFile = new javax.swing.JMenuItem();
        jMenuItemNewProject = new javax.swing.JMenuItem();
        jPopupMenuTree = new javax.swing.JPopupMenu();
        jMenuItemFileProperties = new javax.swing.JMenuItem();
        jMenuItemSetMain = new javax.swing.JMenuItem();
        jMenuItemAction = new javax.swing.JMenuItem();
        jSeparator1 = new javax.swing.JPopupMenu.Separator();
        jMenuItemModi = new javax.swing.JMenuItem();
        jMenuItemYM = new javax.swing.JMenuItem();
        jMenuItemAKS = new javax.swing.JMenuItem();
        jMenuItemASFX = new javax.swing.JMenuItem();
        jMenuItemSample = new javax.swing.JMenuItem();
        jMenuItemVecSpeech = new javax.swing.JMenuItem();
        jSeparator3 = new javax.swing.JPopupMenu.Separator();
        jMenuItemRaster = new javax.swing.JMenuItem();
        jMenuItemVector = new javax.swing.JMenuItem();
        jSeparator2 = new javax.swing.JPopupMenu.Separator();
        jMenuItemDelete = new javax.swing.JMenuItem();
        jMenuItemRename = new javax.swing.JMenuItem();
        jMenuItemDuplicate = new javax.swing.JMenuItem();
        jMenuItem1AddNewFile = new javax.swing.JMenuItem();
        jSeparator4 = new javax.swing.JPopupMenu.Separator();
        jMenuItem1 = new javax.swing.JMenuItem();
        jPopupMenuProjectProperties = new javax.swing.JPopupMenu();
        jMenuItemProjectProperties = new javax.swing.JMenuItem();
        jMenuItemRefresh = new javax.swing.JMenuItem();
        jMenuItemClose = new javax.swing.JMenuItem();
        jMenuItemAddToProject = new javax.swing.JMenuItem();
        jPopupMenuBP = new javax.swing.JPopupMenu();
        jMenuItemRemoveBP = new javax.swing.JMenuItem();
        jPopupMenuWatch = new javax.swing.JPopupMenu();
        jMenuItemRemoveWatch = new javax.swing.JMenuItem();
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
        jSplitPane4 = new javax.swing.JSplitPane();
        jTabbedPane2 = new javax.swing.JTabbedPane();
        jScrollPane1 = new javax.swing.JScrollPane();
        jTree1 = new javax.swing.JTree();
        jPanel4 = new javax.swing.JPanel();
        jScrollPane5 = new javax.swing.JScrollPane();
        jListFiles = new javax.swing.JList();
        jButtonNew1 = new javax.swing.JButton();
        jPanel5 = new javax.swing.JPanel();
        jScrollPane6 = new javax.swing.JScrollPane();
        jListProjects = new javax.swing.JList();
        jButtonNew7 = new javax.swing.JButton();
        jPanel7 = new javax.swing.JPanel();
        jScrollPane9 = new javax.swing.JScrollPane();
        jTableInventory = new javax.swing.JTable();
        jButtonAdressBack = new javax.swing.JButton();
        jButtonAdressForward = new javax.swing.JButton();
        jButtonLabelConfig = new javax.swing.JButton();
        jSplitPane3 = new javax.swing.JSplitPane();
        jTabbedPane = new javax.swing.JTabbedPane();
        jScrollPane2 = new javax.swing.JScrollPane();
        jEditorLog = new javax.swing.JEditorPane();
        jScrollPane3 = new javax.swing.JScrollPane();
        jEditorASMMessages = new javax.swing.JEditorPane();
        jScrollPane4 = new javax.swing.JScrollPane();
        jEditorPaneASMListing = new javax.swing.JEditorPane();
        jTabbedPane3 = new javax.swing.JTabbedPane();
        jPanel2 = new javax.swing.JPanel();
        jScrollPane7 = new javax.swing.JScrollPane();
        jTableBookmarks = new javax.swing.JTable();
        jPanel6 = new javax.swing.JPanel();
        jScrollPane8 = new javax.swing.JScrollPane();
        jTableBreakpoints = new javax.swing.JTable();
        jPanel8 = new javax.swing.JPanel();
        jScrollPane10 = new javax.swing.JScrollPane();
        jTableWatches = new javax.swing.JTable();
        jPanel9 = new javax.swing.JPanel();
        jPanel10 = new javax.swing.JPanel();
        jButtonAssembleOne1 = new javax.swing.JButton();
        jButtonAssembleOne2 = new javax.swing.JButton();
        jButtonAssembleOne3 = new javax.swing.JButton();
        jButtonAssembleOne4 = new javax.swing.JButton();
        jCheckBox1 = new javax.swing.JCheckBox();
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
        jButtonFontPlus = new javax.swing.JButton();
        jButtonFontMinus = new javax.swing.JButton();
        jButtonRefresh = new javax.swing.JButton();
        jButtonDebug = new javax.swing.JButton();
        jButtonInjectBin = new javax.swing.JButton();
        jTextFieldCommand = new javax.swing.JTextField();
        jLabel7 = new javax.swing.JLabel();
        jLabel9 = new javax.swing.JLabel();
        jTextFieldPath = new javax.swing.JTextField();
        jButtonFileSelect1 = new javax.swing.JButton();
        jButtonCheckVec4Ever = new javax.swing.JButton();
        jButtonEjectVecForever = new javax.swing.JButton();
        jLabel10 = new javax.swing.JLabel();
        jCheckBoxIgnoreCase1 = new javax.swing.JCheckBox();
        jButtonDebugSyntax = new javax.swing.JButton();
        jButtonAssembleOne = new javax.swing.JButton();

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

        jMenuItemCFile.setText("new C file");
        jMenuItemCFile.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemCFileActionPerformed(evt);
            }
        });
        jMenuNewFileMenu.add(jMenuItemCFile);

        jPopupMenu1.add(jMenuNewFileMenu);

        jMenuItemNewProject.setText("new Project");
        jMenuItemNewProject.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemNewProjectActionPerformed(evt);
            }
        });
        jPopupMenu1.add(jMenuItemNewProject);

        jMenuItemFileProperties.setText("Properties");
        jMenuItemFileProperties.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemFilePropertiesActionPerformed(evt);
            }
        });
        jPopupMenuTree.add(jMenuItemFileProperties);

        jMenuItemSetMain.setText("set as main");
        jMenuItemSetMain.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemSetMainActionPerformed(evt);
            }
        });
        jPopupMenuTree.add(jMenuItemSetMain);

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

        jMenuItemAKS.setText("Arkos Tracker \"bin\"");
        jMenuItemAKS.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemAKSActionPerformed(evt);
            }
        });
        jPopupMenuTree.add(jMenuItemAKS);

        jMenuItemASFX.setText("build vectrex ayfx");
        jMenuItemASFX.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemASFXActionPerformed(evt);
            }
        });
        jPopupMenuTree.add(jMenuItemASFX);

        jMenuItemSample.setText("build vectrex sample");
        jMenuItemSample.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemSampleActionPerformed(evt);
            }
        });
        jPopupMenuTree.add(jMenuItemSample);

        jMenuItemVecSpeech.setText("VecVoice/VecVox+");
        jMenuItemVecSpeech.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemVecSpeechActionPerformed(evt);
            }
        });
        jPopupMenuTree.add(jMenuItemVecSpeech);
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

        jMenuItem1AddNewFile.setText("new empty file");
        jMenuItem1AddNewFile.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem1AddNewFileActionPerformed(evt);
            }
        });
        jPopupMenuTree.add(jMenuItem1AddNewFile);
        jPopupMenuTree.add(jSeparator4);

        jMenuItem1.setText("Invoke C-Compiler");
        jMenuItem1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem1ActionPerformed(evt);
            }
        });
        jPopupMenuTree.add(jMenuItem1);

        jMenuItemProjectProperties.setText("Project properties");
        jMenuItemProjectProperties.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemProjectPropertiesActionPerformed(evt);
            }
        });
        jPopupMenuProjectProperties.add(jMenuItemProjectProperties);

        jMenuItemRefresh.setLabel("Refresh");
        jMenuItemRefresh.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemRefreshActionPerformed(evt);
            }
        });
        jPopupMenuProjectProperties.add(jMenuItemRefresh);

        jMenuItemClose.setText("close project");
        jMenuItemClose.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemCloseActionPerformed(evt);
            }
        });
        jPopupMenuProjectProperties.add(jMenuItemClose);

        jMenuItemAddToProject.setText("add file");
        jMenuItemAddToProject.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemAddToProjectActionPerformed(evt);
            }
        });
        jPopupMenuProjectProperties.add(jMenuItemAddToProject);

        jMenuItemRemoveBP.setText("remove breakpoint");
        jMenuItemRemoveBP.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemRemoveBPActionPerformed(evt);
            }
        });
        jPopupMenuBP.add(jMenuItemRemoveBP);

        jMenuItemRemoveWatch.setText("remove watch");
        jMenuItemRemoveWatch.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemRemoveWatchActionPerformed(evt);
            }
        });
        jPopupMenuWatch.add(jMenuItemRemoveWatch);

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
        jButtonSaveAll.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonSaveAll.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonSaveAllActionPerformed(evt);
            }
        });

        jButtonLoad.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/page_go.png"))); // NOI18N
        jButtonLoad.setToolTipText("Open file (+Shift -> reload current file)");
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

        jSplitPane1.setBorder(null);
        jSplitPane1.setDividerLocation(500);
        jSplitPane1.setOrientation(javax.swing.JSplitPane.VERTICAL_SPLIT);
        jSplitPane1.setResizeWeight(1.0);

        jSplitPane2.setBorder(null);
        jSplitPane2.setDividerLocation(200);

        jTabbedPane1.setTabLayoutPolicy(javax.swing.JTabbedPane.SCROLL_TAB_LAYOUT);
        jTabbedPane1.setPreferredSize(null);
        jTabbedPane1.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jTabbedPane1StateChanged(evt);
            }
        });
        jSplitPane2.setRightComponent(jTabbedPane1);

        jSplitPane4.setBorder(null);
        jSplitPane4.setDividerLocation(300);
        jSplitPane4.setOrientation(javax.swing.JSplitPane.VERTICAL_SPLIT);

        jTabbedPane2.setTabLayoutPolicy(javax.swing.JTabbedPane.SCROLL_TAB_LAYOUT);

        jScrollPane1.setPreferredSize(new java.awt.Dimension(80, 200));

        jTree1.setDragEnabled(true);
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

        jPanel4.setPreferredSize(new java.awt.Dimension(100, 100));

        jListFiles.setModel(new javax.swing.AbstractListModel() {
            String[] strings = { "Item 1", "Item 2", "Item 3", "Item 4", "Item 5" };
            public int getSize() { return strings.length; }
            public Object getElementAt(int i) { return strings[i]; }
        });
        jListFiles.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jListFilesMousePressed(evt);
            }
        });
        jScrollPane5.setViewportView(jListFiles);

        jButtonNew1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/delete.png"))); // NOI18N
        jButtonNew1.setToolTipText("delete entries");
        jButtonNew1.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonNew1.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jButtonNew1MousePressed(evt);
            }
        });
        jButtonNew1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonNew1ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel4Layout = new javax.swing.GroupLayout(jPanel4);
        jPanel4.setLayout(jPanel4Layout);
        jPanel4Layout.setHorizontalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jScrollPane5, javax.swing.GroupLayout.DEFAULT_SIZE, 195, Short.MAX_VALUE)
            .addGroup(jPanel4Layout.createSequentialGroup()
                .addComponent(jButtonNew1)
                .addGap(0, 0, Short.MAX_VALUE))
        );
        jPanel4Layout.setVerticalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel4Layout.createSequentialGroup()
                .addComponent(jButtonNew1)
                .addGap(2, 2, 2)
                .addComponent(jScrollPane5, javax.swing.GroupLayout.DEFAULT_SIZE, 131, Short.MAX_VALUE))
        );

        jTabbedPane2.addTab("last files", jPanel4);

        jPanel5.setPreferredSize(new java.awt.Dimension(100, 100));

        jListProjects.setModel(new javax.swing.AbstractListModel() {
            String[] strings = { "Item 1", "Item 2", "Item 3", "Item 4", "Item 5" };
            public int getSize() { return strings.length; }
            public Object getElementAt(int i) { return strings[i]; }
        });
        jListProjects.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jListProjectsMousePressed(evt);
            }
        });
        jScrollPane6.setViewportView(jListProjects);

        jButtonNew7.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/delete.png"))); // NOI18N
        jButtonNew7.setToolTipText("delete entries");
        jButtonNew7.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonNew7.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jButtonNew7MousePressed(evt);
            }
        });
        jButtonNew7.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonNew7ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel5Layout = new javax.swing.GroupLayout(jPanel5);
        jPanel5.setLayout(jPanel5Layout);
        jPanel5Layout.setHorizontalGroup(
            jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jScrollPane6, javax.swing.GroupLayout.DEFAULT_SIZE, 195, Short.MAX_VALUE)
            .addGroup(jPanel5Layout.createSequentialGroup()
                .addComponent(jButtonNew7)
                .addGap(0, 0, Short.MAX_VALUE))
        );
        jPanel5Layout.setVerticalGroup(
            jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel5Layout.createSequentialGroup()
                .addComponent(jButtonNew7)
                .addGap(2, 2, 2)
                .addComponent(jScrollPane6, javax.swing.GroupLayout.DEFAULT_SIZE, 131, Short.MAX_VALUE))
        );

        jTabbedPane2.addTab("last projects", jPanel5);

        jSplitPane4.setLeftComponent(jTabbedPane2);

        jPanel7.setBorder(javax.swing.BorderFactory.createTitledBorder("Navigation"));

        jTableInventory.setModel(new javax.swing.table.DefaultTableModel(
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
        jTableInventory.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jTableInventoryMousePressed(evt);
            }
        });
        jScrollPane9.setViewportView(jTableInventory);

        jButtonAdressBack.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/resultset_previous.png"))); // NOI18N
        jButtonAdressBack.setToolTipText("<html>\ngo to last visited adress\n<BR>\nAll visited adresses are on a stack.<BR>\nThe current displayed address is NOT on the stack.<BR>\nIf the current address is change by the user, and than goes<BR>\nback and forth, the \"new\" last address is visted, not the \"old\"<BR>\nlast address!<BR>\n\n</html>\n");
        jButtonAdressBack.setEnabled(false);
        jButtonAdressBack.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonAdressBack.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonAdressBackActionPerformed(evt);
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

        jButtonLabelConfig.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/cog_edit.png"))); // NOI18N
        jButtonLabelConfig.setToolTipText("configure kind of listed labels");
        jButtonLabelConfig.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonLabelConfig.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonLabelConfigActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel7Layout = new javax.swing.GroupLayout(jPanel7);
        jPanel7.setLayout(jPanel7Layout);
        jPanel7Layout.setHorizontalGroup(
            jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jScrollPane9, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE)
            .addGroup(jPanel7Layout.createSequentialGroup()
                .addComponent(jButtonAdressBack)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonAdressForward)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 124, Short.MAX_VALUE)
                .addComponent(jButtonLabelConfig))
        );
        jPanel7Layout.setVerticalGroup(
            jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel7Layout.createSequentialGroup()
                .addGroup(jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jButtonAdressForward, javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jButtonAdressBack, javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jButtonLabelConfig, javax.swing.GroupLayout.Alignment.TRAILING))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jScrollPane9, javax.swing.GroupLayout.DEFAULT_SIZE, 96, Short.MAX_VALUE))
        );

        jSplitPane4.setRightComponent(jPanel7);

        jSplitPane2.setLeftComponent(jSplitPane4);

        jSplitPane1.setTopComponent(jSplitPane2);

        jSplitPane3.setBorder(null);
        jSplitPane3.setDividerLocation(600);

        jTabbedPane.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jTabbedPaneStateChanged(evt);
            }
        });
        jTabbedPane.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jTabbedPaneMousePressed(evt);
            }
        });

        jEditorLog.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jEditorLogMousePressed(evt);
            }
        });
        jScrollPane2.setViewportView(jEditorLog);

        jTabbedPane.addTab("Editor messages", jScrollPane2);

        jEditorASMMessages.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jEditorASMMessagesMousePressed(evt);
            }
        });
        jScrollPane3.setViewportView(jEditorASMMessages);

        jTabbedPane.addTab("ASM messages", jScrollPane3);

        jScrollPane4.setViewportView(jEditorPaneASMListing);

        jTabbedPane.addTab("ASM listing/symbols", jScrollPane4);

        jSplitPane3.setLeftComponent(jTabbedPane);

        jTableBookmarks.setModel(new javax.swing.table.DefaultTableModel(
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
        jTableBookmarks.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jTableBookmarksMousePressed(evt);
            }
        });
        jScrollPane7.setViewportView(jTableBookmarks);

        javax.swing.GroupLayout jPanel2Layout = new javax.swing.GroupLayout(jPanel2);
        jPanel2.setLayout(jPanel2Layout);
        jPanel2Layout.setHorizontalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jScrollPane7, javax.swing.GroupLayout.DEFAULT_SIZE, 434, Short.MAX_VALUE)
        );
        jPanel2Layout.setVerticalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jScrollPane7, javax.swing.GroupLayout.DEFAULT_SIZE, 217, Short.MAX_VALUE)
        );

        jTabbedPane3.addTab("Bookmarks", jPanel2);

        jTableBreakpoints.setModel(new javax.swing.table.DefaultTableModel(
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
        jTableBreakpoints.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jTableBreakpointsMousePressed(evt);
            }
        });
        jScrollPane8.setViewportView(jTableBreakpoints);

        javax.swing.GroupLayout jPanel6Layout = new javax.swing.GroupLayout(jPanel6);
        jPanel6.setLayout(jPanel6Layout);
        jPanel6Layout.setHorizontalGroup(
            jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jScrollPane8, javax.swing.GroupLayout.DEFAULT_SIZE, 434, Short.MAX_VALUE)
        );
        jPanel6Layout.setVerticalGroup(
            jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jScrollPane8, javax.swing.GroupLayout.DEFAULT_SIZE, 217, Short.MAX_VALUE)
        );

        jTabbedPane3.addTab("Breakpoints", jPanel6);

        jTableWatches.setModel(new javax.swing.table.DefaultTableModel(
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
        jTableWatches.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jTableWatchesMousePressed(evt);
            }
        });
        jScrollPane10.setViewportView(jTableWatches);

        javax.swing.GroupLayout jPanel8Layout = new javax.swing.GroupLayout(jPanel8);
        jPanel8.setLayout(jPanel8Layout);
        jPanel8Layout.setHorizontalGroup(
            jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jScrollPane10, javax.swing.GroupLayout.DEFAULT_SIZE, 434, Short.MAX_VALUE)
        );
        jPanel8Layout.setVerticalGroup(
            jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jScrollPane10, javax.swing.GroupLayout.DEFAULT_SIZE, 217, Short.MAX_VALUE)
        );

        jTabbedPane3.addTab("Watches", jPanel8);

        jPanel10.setBorder(javax.swing.BorderFactory.createTitledBorder("assi only"));

        jButtonAssembleOne1.setText("to assi");
        jButtonAssembleOne1.setToolTipText("");
        jButtonAssembleOne1.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonAssembleOne1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonAssembleOne1ActionPerformed(evt);
            }
        });

        jButtonAssembleOne2.setText("to as6809");
        jButtonAssembleOne2.setToolTipText("");
        jButtonAssembleOne2.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonAssembleOne2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonAssembleOne2ActionPerformed(evt);
            }
        });

        jButtonAssembleOne3.setText("preProcess only");
        jButtonAssembleOne3.setToolTipText("");
        jButtonAssembleOne3.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonAssembleOne3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonAssembleOne3ActionPerformed(evt);
            }
        });

        jButtonAssembleOne4.setText("start as6809");
        jButtonAssembleOne4.setToolTipText("");
        jButtonAssembleOne4.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonAssembleOne4.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonAssembleOne4ActionPerformed(evt);
            }
        });

        jCheckBox1.setSelected(true);
        jCheckBox1.setText("scheduler");
        jCheckBox1.setToolTipText("update timer to check files for var changes");
        jCheckBox1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox1ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel10Layout = new javax.swing.GroupLayout(jPanel10);
        jPanel10.setLayout(jPanel10Layout);
        jPanel10Layout.setHorizontalGroup(
            jPanel10Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel10Layout.createSequentialGroup()
                .addGroup(jPanel10Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                    .addComponent(jButtonAssembleOne2, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jButtonAssembleOne1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jButtonAssembleOne3, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE)
                    .addComponent(jButtonAssembleOne4, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addGap(30, 30, 30)
                .addComponent(jCheckBox1)
                .addContainerGap(193, Short.MAX_VALUE))
        );
        jPanel10Layout.setVerticalGroup(
            jPanel10Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel10Layout.createSequentialGroup()
                .addGroup(jPanel10Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButtonAssembleOne1, javax.swing.GroupLayout.PREFERRED_SIZE, 20, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jCheckBox1))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jButtonAssembleOne3, javax.swing.GroupLayout.PREFERRED_SIZE, 20, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jButtonAssembleOne2, javax.swing.GroupLayout.PREFERRED_SIZE, 20, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jButtonAssembleOne4, javax.swing.GroupLayout.PREFERRED_SIZE, 20, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(41, Short.MAX_VALUE))
        );

        javax.swing.GroupLayout jPanel9Layout = new javax.swing.GroupLayout(jPanel9);
        jPanel9.setLayout(jPanel9Layout);
        jPanel9Layout.setHorizontalGroup(
            jPanel9Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel9Layout.createSequentialGroup()
                .addComponent(jPanel10, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addContainerGap())
        );
        jPanel9Layout.setVerticalGroup(
            jPanel9Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel9Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jPanel10, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(27, Short.MAX_VALUE))
        );

        jTabbedPane3.addTab("Assi->C", jPanel9);

        jSplitPane3.setRightComponent(jTabbedPane3);

        jSplitPane1.setBottomComponent(jSplitPane3);

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
        jLabel1.setPreferredSize(new java.awt.Dimension(36, 21));

        jTextFieldSearch.setPreferredSize(new java.awt.Dimension(6, 21));
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
        jLabel2.setPreferredSize(new java.awt.Dimension(39, 21));

        jLabel3.setHorizontalAlignment(javax.swing.SwingConstants.TRAILING);
        jLabel3.setText("xyz chars");
        jLabel3.setPreferredSize(new java.awt.Dimension(46, 21));

        jLabel4.setText("row/col: xxxx/yyyy");
        jLabel4.setPreferredSize(new java.awt.Dimension(94, 21));

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

        jTextFieldReplace.setPreferredSize(new java.awt.Dimension(6, 21));
        jTextFieldReplace.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldReplaceActionPerformed(evt);
            }
        });

        jLabel5.setForeground(new java.awt.Color(255, 0, 0));
        jLabel5.setToolTipText("");
        jLabel5.setPreferredSize(new java.awt.Dimension(100, 21));

        jLabel6.setFont(new java.awt.Font("Courier New", 0, 12)); // NOI18N
        jLabel6.setForeground(new java.awt.Color(0, 153, 51));
        jLabel6.setHorizontalAlignment(javax.swing.SwingConstants.TRAILING);
        jLabel6.setText("*");
        jLabel6.setMaximumSize(new java.awt.Dimension(16, 21));
        jLabel6.setMinimumSize(new java.awt.Dimension(16, 21));
        jLabel6.setPreferredSize(new java.awt.Dimension(16, 21));

        jButtonClearMessages.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/weather_sun.png"))); // NOI18N
        jButtonClearMessages.setToolTipText("clear messages");
        jButtonClearMessages.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonClearMessages.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonClearMessagesActionPerformed(evt);
            }
        });

        jButtonFontPlus.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/font_add.png"))); // NOI18N
        jButtonFontPlus.setToolTipText("update size of all fonts");
        jButtonFontPlus.setMargin(new java.awt.Insets(0, 0, 0, 0));
        jButtonFontPlus.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonFontPlusActionPerformed(evt);
            }
        });

        jButtonFontMinus.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/font_delete.png"))); // NOI18N
        jButtonFontMinus.setToolTipText("update size of all fonts");
        jButtonFontMinus.setMargin(new java.awt.Insets(0, 0, 0, 0));
        jButtonFontMinus.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonFontMinusActionPerformed(evt);
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
                .addComponent(jLabel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addGap(2, 2, 2)
                .addComponent(jTextFieldSearch, javax.swing.GroupLayout.PREFERRED_SIZE, 105, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonSearchPrevious)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonSearchNext)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(jLabel2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addGap(0, 0, 0)
                .addComponent(jTextFieldReplace, javax.swing.GroupLayout.PREFERRED_SIZE, 105, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonReplaceNext)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonReplaceAll)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonReplaceInSelection)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(jButtonFontPlus)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonFontMinus)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabel5, javax.swing.GroupLayout.PREFERRED_SIZE, 114, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(jLabel4, javax.swing.GroupLayout.PREFERRED_SIZE, 184, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabel3, javax.swing.GroupLayout.PREFERRED_SIZE, 144, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jLabel6, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE))
        );
        jPanel3Layout.setVerticalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addGap(0, 0, 0)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jCheckBoxIgnoreCase)
                    .addComponent(jButtonIgnoreCase)
                    .addComponent(jButtonReplaceNext)
                    .addComponent(jButtonReplaceAll)
                    .addComponent(jButtonReplaceInSelection)
                    .addComponent(jLabel4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jLabel3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLabel6, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jLabel2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButtonFontMinus)
                    .addComponent(jButtonFontPlus)
                    .addComponent(jButtonClearMessages)
                    .addComponent(jButtonSearchPrevious)
                    .addComponent(jButtonSearchNext)
                    .addComponent(jLabel5, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextFieldSearch, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextFieldReplace, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(0, 0, 0))
        );

        jButtonRefresh.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/arrow_refresh.png"))); // NOI18N
        jButtonRefresh.setToolTipText("refresh tree");
        jButtonRefresh.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonRefresh.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonRefreshActionPerformed(evt);
            }
        });

        jButtonDebug.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/bug_go.png"))); // NOI18N
        jButtonDebug.setToolTipText("<html>\nAssemble current file, if project is loaded, build project and start debugging it (if so defined in config).\n<BR>\nUsing C, this oes as of now nothing different than \"build\".\n</html>\n");
        jButtonDebug.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonDebug.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonDebugActionPerformed(evt);
            }
        });

        jButtonInjectBin.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/server_go.png"))); // NOI18N
        jButtonInjectBin.setToolTipText("Assemble and \"inject\" built binary to currently running vecx");
        jButtonInjectBin.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonInjectBin.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonInjectBinActionPerformed(evt);
            }
        });

        jTextFieldCommand.setPreferredSize(new java.awt.Dimension(6, 21));
        jTextFieldCommand.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldCommandActionPerformed(evt);
            }
        });

        jLabel7.setText("ask:");

        jLabel9.setText("V4E");

        jTextFieldPath.setEnabled(false);
        jTextFieldPath.setFocusable(false);
        jTextFieldPath.setPreferredSize(new java.awt.Dimension(6, 21));

        jButtonFileSelect1.setText("...");
        jButtonFileSelect1.setToolTipText("Chose the \"mountpoint\" of the VecFever RAM disk\n");
        jButtonFileSelect1.setEnabled(false);
        jButtonFileSelect1.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonFileSelect1.setPreferredSize(new java.awt.Dimension(17, 21));
        jButtonFileSelect1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonFileSelect1ActionPerformed(evt);
            }
        });

        jButtonCheckVec4Ever.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/drive_add.png"))); // NOI18N
        jButtonCheckVec4Ever.setToolTipText("seek connection");
        jButtonCheckVec4Ever.setEnabled(false);
        jButtonCheckVec4Ever.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonCheckVec4Ever.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonCheckVec4EverActionPerformed(evt);
            }
        });

        jButtonEjectVecForever.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/drive_delete.png"))); // NOI18N
        jButtonEjectVecForever.setToolTipText("eject ");
        jButtonEjectVecForever.setEnabled(false);
        jButtonEjectVecForever.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonEjectVecForever.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonEjectVecForeverActionPerformed(evt);
            }
        });

        jLabel10.setFont(new java.awt.Font("Geneva", 1, 11)); // NOI18N
        jLabel10.setText("!");
        jLabel10.setEnabled(false);

        jCheckBoxIgnoreCase1.setToolTipText("ignore case (if selected)");
        jCheckBoxIgnoreCase1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxIgnoreCase1ActionPerformed(evt);
            }
        });

        jButtonDebugSyntax.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/zoom_out.png"))); // NOI18N
        jButtonDebugSyntax.setToolTipText("debug");
        jButtonDebugSyntax.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonDebugSyntax.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonDebugSyntaxActionPerformed(evt);
            }
        });

        jButtonAssembleOne.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/control_end_blue.png"))); // NOI18N
        jButtonAssembleOne.setToolTipText("Assemble/compile current file - nothing is started!");
        jButtonAssembleOne.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonAssembleOne.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonAssembleOneActionPerformed(evt);
            }
        });

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
                .addGap(18, 18, 18)
                .addComponent(jButtonUndo)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonRedo)
                .addGap(18, 18, 18)
                .addComponent(jButtonPrettyPrint)
                .addGap(18, 18, 18)
                .addComponent(jButtonAssembleOne)
                .addGap(4, 4, 4)
                .addComponent(jButtonAssemble)
                .addGap(4, 4, 4)
                .addComponent(jButtonDebug)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jButtonInjectBin)
                .addGap(2, 2, 2)
                .addComponent(jLabel7)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jTextFieldCommand, javax.swing.GroupLayout.PREFERRED_SIZE, 139, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(32, 32, 32)
                .addComponent(jLabel9)
                .addGap(1, 1, 1)
                .addComponent(jCheckBoxIgnoreCase1)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextFieldPath, javax.swing.GroupLayout.PREFERRED_SIZE, 145, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonFileSelect1, javax.swing.GroupLayout.PREFERRED_SIZE, 13, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonCheckVec4Ever)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonEjectVecForever)
                .addGap(5, 5, 5)
                .addComponent(jLabel10)
                .addGap(36, 36, 36)
                .addComponent(jButtonDebugSyntax)
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
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(jLabel10, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jCheckBoxIgnoreCase1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
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
                            .addComponent(jButtonDebug)
                            .addComponent(jButtonInjectBin)
                            .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                .addComponent(jTextFieldCommand, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jLabel7)
                                .addComponent(jLabel9)
                                .addComponent(jTextFieldPath, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jButtonFileSelect1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addComponent(jButtonCheckVec4Ever)
                            .addComponent(jButtonEjectVecForever)
                            .addComponent(jButtonDebugSyntax)
                            .addComponent(jButtonAssembleOne))
                        .addGap(1, 1, 1)))
                .addComponent(jSplitPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 642, Short.MAX_VALUE)
                .addGap(1, 1, 1)
                .addComponent(jPanel3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
        );

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
    }// </editor-fold>//GEN-END:initComponents
   private void jButtonCutActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonCutActionPerformed

    }//GEN-LAST:event_jButtonCutActionPerformed

    private void jButtonPasteActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonPasteActionPerformed
       
    }//GEN-LAST:event_jButtonPasteActionPerformed

    private void jButtonSaveActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSaveActionPerformed
        EditorPanel edi = getSelectedEditor();
        if (edi == null) return;
        boolean shift = false;
        if ((evt != null ) )
        
        shift = ((evt.getModifiers() & SHIFT_MASK) == SHIFT_MASK);

        edi.save(shift);
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

    private void jButtonSaveAllActionPerformed(java.awt.event.ActionEvent evt) {                                               
        saveAll();
    }                                                                        

    private void jButtonLoadActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonLoadActionPerformed

        if ((evt != null ) && ((evt.getModifiers() & SHIFT_MASK) == SHIFT_MASK))
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
            fc.setCurrentDirectory(new java.io.File(Global.mainPathPrefix));
        }
        else
        {
            fc.setCurrentDirectory(new java.io.File(lastPath));
        }
        
        int r = fc.showOpenDialog(Configuration.getConfiguration().getMainFrame());
        if (r != InternalFrameFileChoser.APPROVE_OPTION) return;
        if (fc == null) return;
        if (fc.getSelectedFile() == null) return;
        lastPath = fc.getSelectedFile().getAbsolutePath();
        try
        {
        lastPath = fc.getSelectedFile().getCanonicalPath();
        }
        catch (Throwable e){}
        if (inProject)
        {
            jMenuItemCloseActionPerformed(null);
        }
        // test and open, if project
//        if (isProject(de.malban.util.Utility.makeRelative(lastPath)))
        if (isProject(de.malban.util.Utility.makeVideRelative(lastPath)))
        {
            return;
        }
        addEditor(lastPath, true);
        oneTimeTab = null;
        Path p = Paths.get(lastPath);
        fillTree(p.getParent());
    }//GEN-LAST:event_jButtonLoadActionPerformed

    
    Thread one = null;
    public boolean  asmStarted = false;
    public boolean stop = false;
    public boolean running = false;
    public boolean pausing = false;

    // start a thread for assembler
    public void startASM(final String filenameASM)
    {
        if (asmStarted) return;
        asmStarted = true;
        jButtonDebug.setEnabled(false);
        jButtonAssemble.setEnabled(false);
        // paranoia!
        if (one != null) return;
        one = new Thread() 
        {
            public void run() 
            {
                try 
                {
                    Thread.sleep(10);
                    try
                    {
                        boolean is48K = false;
                        if (currentProject != null)
                            is48K= (currentProject.getExtras() & Cartridge.FLAG_48K) != 0;
                        Asmj asm = new Asmj(filenameASM, asmErrorOut, null, null, asmMessagesOut, "", settings.allDebugComments,is48K);



                        //Asmj asm = new Asmj(filenameASM, asmErrorOut, asmListOut, asmSymbolOut, asmMessagesOut);
                        printASMList(asm.getListing(), ASM_LIST);
                        String info = asm.getInfo();
                        final boolean asmOk = info.indexOf("0 errors detected.") >=0;
                        
                        SwingUtilities.invokeLater(new Runnable()
                        {
                            public void run()
                            {
                                asmResult(asmOk, filenameASM);
                            }
                        });                    
                    }
                    catch (final Throwable e)
                    {
                        SwingUtilities.invokeLater(new Runnable()
                        {
                            public void run()
                            {
                                printASMMessage("Exception while assembling: " + e.getMessage(), ASM_MESSAGE_ERROR);
                                printASMMessage(de.malban.util.Utility.getStackTrace(e), ASM_MESSAGE_ERROR);
                                asmResult(false, filenameASM);
                            }
                        });                    
                    }
                } 
                catch(InterruptedException v) 
                {
                }

                one = null;
                jButtonAssemble.setEnabled(true);
                jButtonDebug.setEnabled(true);
                asmStarted = false;
            }  
        };

        one.setName("Run ASMJ with: "+filenameASM);
        one.start();           
    }    
    protected void asmResult(boolean asmOk, String filename)
    {
        if (asmOk)
        {
            String fname = getSelectedEditor().getFilename();

            if (fname.toLowerCase().endsWith(".c"))
            {
                Path p = Paths.get(fname);
                String pathOnly = p.getParent().toString();
                if (pathOnly.length()>0)
                    pathOnly+= File.separator;


                fname= baseOnly(filename);

            }

            if ( fname.toLowerCase().endsWith(".asm") ) {
                // drop the ".asm" extension
                fname = fname .substring( 0, fname.length()-4 );
            }
            else
            {
                int li = fname.lastIndexOf(".");
                if (li>=0) 
                    fname = fname.substring(0,li);
            }
            fname = fname + ".bin";
            boolean started = false;
            if ((config.invokeEmulatorAfterAssembly)&&(startTypeRun != START_TYPE_STOP))
            {
                VecXPanel vec = ((CSAMainFrame)mParent).getVecxy();
                ((CSAMainFrame)mParent).getInternalFrame(vec).toFront();

                    

                
                boolean ask = false;
                if (startTypeRun == START_TYPE_INJECT)
                {
                    String myName = fname;
                    String oldName = vec.getStartName();
                    if (!oldName.equals(myName)) ask = true;
                }
        
                checkVec4EverFile(fname);
                started = true;
                boolean doit = true;
                if (ask)
                {
//                    JOptionPane pane = new JOptionPane("The bin files appear to be not compatible, inject anyway?", JOptionPane.WARNING_MESSAGE, JOptionPane.OK_CANCEL_OPTION);
//                    int answer = JOptionPaneDialog.show(pane);
                    
                    int answer = JOptionPane.showOptionDialog(Configuration.getConfiguration().getMainFrame(), 
                    "The bin files appear to be not compatible, inject anyway?",
                    "Different bin file",
                     JOptionPane.WARNING_MESSAGE, JOptionPane.OK_CANCEL_OPTION, null, null, null);
                    
                    
                    if (answer == JOptionPane.YES_OPTION)
                        doit = true;
                    else
                    {
                        doit = false;
                    }
                }
                if (doit)
                {
                    vec.startUp(fname, true, startTypeRun);
                    printMessage("Assembly successfull, starting emulation...");
                }
            }
            if (!started)
            {
                checkVec4EverFile(fname);
                printMessage("Assembly successfull...");
            }
            
        }
        else
        {
            printError("Assembly not successfull, see ASM output...");
            jTabbedPane.setSelectedIndex(1);
        }
        refreshTree();
    }

    private void jButtonAssembleActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonAssembleActionPerformed
// following initialized the FilePeeper even in ASM...
        jEditorPaneASMListing.setText("");
        jEditorASMMessages.setText("");
        jEditorLog.setText("");
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
        // save File(s) to tmp
        if (inProject)
        {
            doBuildProject();
            return;
        }
        // just compile current
        clearASMOutput();
        EditorPanel edit = getSelectedEditor();
        if (edit == null) return;
        edit.save(false);
        printMessage("\""+getSelectedEditor().getFilename()+"\" saved.");
        String fname = getSelectedEditor().getFilename();
        if (fname == null) return;

        if (fname.toLowerCase().endsWith(".c"))
        {
            FilePeeper.peepsFound = 0;
            doCCompilerSingleFile(fname);
        }
        else
        {
            startASM(fname);
        }
    }
    
private void jTabbedPane1StateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jTabbedPane1StateChanged
        tabChanged(true);
        initInventory();
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
        boolean found = getSelectedEditor().replaceNext(jTextFieldSearch.getText(), jTextFieldReplace.getText(), jCheckBoxIgnoreCase.isSelected(), true, false);
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
        if ((evt != null ) && ((evt.getModifiers() & SHIFT_MASK) == SHIFT_MASK))
        {
            if (possibleProject == null) return;
            if (possibleProject.endsWith(File.separator)) return;
            inProject = false;
            closeAllEditors();
            settings.currentProject = null;
            currentProject = null;

            // build empty project with data from current file
            // inf possibleProject name and path of a valid asm file
            // build a project from that
            ProjectProperties project = new ProjectProperties();
            String nameFull="";
            String nameOnly="";
            String path="";
            String projectName="";
            
            String work = de.malban.util.Utility.makeVideRelative(possibleProject);
            int tmp = work.lastIndexOf(File.separator);
            if (tmp <0)
            {
                nameFull = work;
            }
            else
            {
                nameFull=work.substring(tmp+1);
            }
            tmp = nameFull.lastIndexOf(".");
            nameOnly=nameFull.substring(0, tmp);

            work = work.substring(0, work.length()-nameFull.length());
            if (work.endsWith(File.separator))
                work = work.substring(0, work.length()-1);
            if (work.contains(File.separator))
            {
                // then path and project
                tmp = work.lastIndexOf(File.separator);
                projectName=work.substring(tmp+1);
                work = work.substring(0, work.length()-projectName.length());
            }
            else
            {
                // path = ""
                // project = work
                projectName=work;
            }
            if (work.endsWith(File.separator))
                work = work.substring(0, work.length()-1);
            path = work;
            
            project.setCClass("Project");
            project.setName(nameOnly);

//            project.mAuthor = "";
//            project.mDescription = "";
//            project.mDirectoryName = "";
            project.setOldPath(path);
            project.projectPrefix = path+File.separator+projectName;
            project.setProjectName(projectName);
            project.setMainFile(nameFull);
            
            Vector<String> bankMainFiles = new Vector<String>();
            bankMainFiles.add(nameFull);
            project.setBankMainFiles(bankMainFiles);
            Vector<String> bankDefines = new Vector<String>();
            bankDefines.add("");
            project.setBankDefines(bankDefines);
            
            project.setVersion("1.0");
            project.setBankswitching("none");
            project.setNumberOfBanks(1);
//            project.mcreateBankswitchCode = jCheckBoxCreateSupportCode.isSelected();
//            project.mcreateGameLoopCode = jCheckBoxCreateGameLoop.isSelected();
//            project.mProjectPreScriptClass = "";
//            project.mProjectPreScriptName = "";
//            project.mProjectPostScriptClass = "";
//            project.mProjectPostScriptName = "";
//            project.mWheelName ="";
            project.setExtras(0);
            doNewProject(project, false);
            fileView = false;
            fillTree(Paths.get(de.malban.util.Utility.makeVideAbsolute(currentProject.projectPrefix)));
        }
    }//GEN-LAST:event_jButtonNewActionPerformed

    private void jEditorASMMessagesMousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jEditorASMMessagesMousePressed
        if (evt.getClickCount() == 2) 
        {
// JAVA10            Point2D.Float pt = new Point2D.Float(evt.getX(), evt.getY());
// JAVA10            int pos = jEditorASMMessages.viewToModel2D(pt);

        Point pt = new Point(evt.getX(), evt.getY());
        int pos = jEditorASMMessages.viewToModel(pt);

            int line = getLineOfPos(jEditorASMMessages, pos);
            if (line != -1)
            {
                String lineString = getLine(jEditorASMMessages, line);
                if (lineString.indexOf("jEditorASMMessages")>0) return;
                if (lineString.contains("******")) 
                    lineString = getLine(jEditorASMMessages, line+1);
                if (lineString.contains("++++++")) 
                    lineString = getLine(jEditorASMMessages, line+1);
                if (lineString.contains("######")) 
                    lineString = getLine(jEditorASMMessages, line+1);
                if (lineString.length()==0) return;
                processErrorLine(lineString);
            }
        }
    }//GEN-LAST:event_jEditorASMMessagesMousePressed

    private void jTextFieldSearchActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldSearchActionPerformed
        jButtonSearchNextActionPerformed(null);
    }//GEN-LAST:event_jTextFieldSearchActionPerformed
    
    // output "Tabs" for source generation
    
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
        c = spaceTo(b, c, config.TAB_MNEMONIC);
        if (w>=words.length)
        {
            b.append(quote);
            c+=quote.length();
            c = spaceTo(b, c, config.TAB_OP);
            b.append(postQuote);
            return b.toString();
        }
        while (words[w].length()==0) w++;
        b.append(words[w]).append(" ");
        c+=words[w].length()+1;
        w++;
        c = spaceTo(b, c, config.TAB_OP);

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
    
    String getTABString()
    {
        String tab="";
        for (int i=0;i<config.tab_width; i++) tab +=" ";
        return tab;
    }
    String getTabForLineBracket(int count)
    {
        String ret="";
        for (int i=0;i<count;i++) 
            ret+="\t";
        return ret;
    }
    String prettyPrintC(String orgText)
    {
        StringBuilder b = new StringBuilder();
        orgText = UtilityString.replace(orgText, "\r\n", "\n");
        orgText = UtilityString.replace(orgText, "\t", getTABString());
        int openBrackets = 0;
        String[] lines = orgText.split("\n");
        for (String line: lines)
        {
            int bracketHelp = 0;
            
            if (line.trim().startsWith("}")) bracketHelp = -1;
            
            b.append(getTabForLineBracket(openBrackets+bracketHelp));
            b.append(line.trim());
            openBrackets += UtilityString.countChars(line, "{");
            openBrackets -= UtilityString.countChars(line, "}");
           b.append("\n");
        }
        return  b.toString();
    }
    
    String prettyPrint(String orgText)
    {
        StringBuilder b = new StringBuilder();
        orgText = UtilityString.replace(orgText, "\r\n", "\n");
        
        
        orgText = UtilityString.replace(orgText, "\t", getTABString());
        
        String[] lines = orgText.split("\n");
        for (String line: lines)
        {
            boolean doSeperator = false;
            boolean inComment = false;
            int c = 0; // space counter (position)
            int w = 0;
            // any literals?
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
            // "zero" line? -> remove
            if (line.trim().length()==0) continue;
            
            // comment only (a)?
            if (line.charAt(0)==';')
            {
                b.append(line).append("\n"); // leave them for now
                continue;
            }

            // comment only (b)?
            if (line.charAt(0)=='*')
            {
                b.append(line).append("\n"); // leave them for now
                continue;
            }
            
            // remove all tabs (in non comment line)
            line = UtilityString.replace(line, "\t", getTABString());
            String[] words = line.split(" ");

            // is it a label? [word starting a line]
            if (!UtilityString.isWordBoundry(line.charAt(0)))
            {
                // if so append - and a space
                b.append(words[w]).append(" ");
                c+=words[w].length()+1;
                w++;
            }
            // if line finished -> end line
            if (w>=words.length)
            {
                b.append("\n"); 
                continue;
            }

            while (words[w].length()==0) w++;
            boolean shortTab = false;
            if (words[w].toLowerCase().equals("if")) shortTab = true;
            if (words[w].toLowerCase().equals("else")) shortTab = true;
            if (words[w].toLowerCase().equals("elseif")) shortTab = true;
            if (words[w].toLowerCase().equals("endif")) shortTab = true;
            if (words[w].toLowerCase().equals("ifdef")) shortTab = true;

            if (shortTab)
                c = spaceTo(b, c, config.SHORT_TAB_OP);
            else
                c = spaceTo(b, c, config.TAB_MNEMONIC);
    
            b.append(words[w]).append(" ");
            boolean structPossible = false;
            if (words[w].toLowerCase().equals("rts")) doSeperator = true;
            if (words[w].toLowerCase().equals("jmp")) doSeperator = true;
            if (words[w].toLowerCase().equals("bra")) doSeperator = true;
            if (words[w].toLowerCase().equals("lbra")) doSeperator = true;
            if (words[w].toLowerCase().equals("end")) structPossible = true;

            
            
            c+=words[w].length()+1;
            w++;
            if (structPossible)
            {
                structPossible = line.toLowerCase().contains("struct");
            }
            if (!structPossible)
            {
                if (!(line.toString().trim().startsWith(";")))
                {
                    if (shortTab)
                        c = spaceTo(b, c, config.SHORT_TAB_OP );
                    else
                        c = spaceTo(b, c, config.TAB_OP);
                }
            }
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
            c = spaceTo(b, c, config.TAB_COMMENT);
            b.append(comment).append("\n");
        }
        return  b.toString();
    }

    private void jButtonPrettyPrintActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonPrettyPrintActionPerformed

        if ((evt != null ) && ((evt.getModifiers() & SHIFT_MASK) == SHIFT_MASK))
        {
            if (inProject)
            {
                if (currentProject.getIsPeerCProject())
                {
                    peerClean(currentProject.projectPrefix,0);
                    peerClean(currentProject.projectPrefix,1);
                    refreshTree();
                }
            }
            cInfo.resetDefinitions();
            asmInfo.resetDefinitions();
            initInventory();
            reDisplayAll();
            return;
        }
        

        
        if (getSelectedEditor()==null) return;

        String text = getSelectedEditor().getText();
        if (getSelectedEditor().assume6809Asm)
        {
            text = prettyPrint(text);
        }
        else if (getSelectedEditor().assume6809C)
        {
            text = prettyPrintC(text);
        }
        
        getSelectedEditor().stopColoring();
        getSelectedEditor().setText(text);
        getSelectedEditor().startColoring(settings.fontSize);
        initInventory();
    }//GEN-LAST:event_jButtonPrettyPrintActionPerformed

    private void jMenuItemNewFileActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemNewFileActionPerformed

        InternalFrameFileChoser fc = new de.malban.gui.dialogs.InternalFrameFileChoser();
        
        if (lastPath.length()==0)
        {
            fc.setCurrentDirectory(new java.io.File(Global.mainPathPrefix));
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
//            JOptionPane pane = new JOptionPane("The file already exists, do you really want\nto create a new file?\n\nAll previous data will be lost!", JOptionPane.WARNING_MESSAGE, JOptionPane.OK_CANCEL_OPTION);
//            int answer = JOptionPaneDialog.show(pane);

                int answer = JOptionPane.showOptionDialog(Configuration.getConfiguration().getMainFrame(), 
                "The file already exists, do you really want\nto create a new file?\n\nAll previous data will be lost!",
                "File exists",
                 JOptionPane.WARNING_MESSAGE, JOptionPane.OK_CANCEL_OPTION, null, null, null);


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
    
    private void jMenuItemNewProjectActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemNewProjectActionPerformed
        doNewProject();
        
    }//GEN-LAST:event_jMenuItemNewProjectActionPerformed

    private void jPopupMenu1MouseExited(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jPopupMenu1MouseExited
        jPopupMenu1.setVisible(false);
    }//GEN-LAST:event_jPopupMenu1MouseExited

    private void jButtonNewMousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jButtonNewMousePressed
        if (evt == null) return;
        if ((evt != null ) && ((evt.getModifiersEx() & SHIFT_DOWN_MASK) == SHIFT_DOWN_MASK))
            return;
        jMenuItemCFile.setVisible(false);
        if (currentProject!=null)
        {
            if (currentProject.getIsPeerCProject())
            {
                jMenuItemCFile.setVisible(true);
            }
        }
        jPopupMenu1.show(jButtonNew, evt.getX()-20,evt.getY()-20);
    }//GEN-LAST:event_jButtonNewMousePressed

    private void jMenuItemVectrexFileActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemVectrexFileActionPerformed
        InternalFrameFileChoser fc = new de.malban.gui.dialogs.InternalFrameFileChoser();
        
        if (lastPath.length()==0)
        {
            fc.setCurrentDirectory(new java.io.File(Global.mainPathPrefix));
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
//            JOptionPane pane = new JOptionPane("The file already exists, do you really want\nto create a new file?\n\nAll previous data will be lost!", JOptionPane.WARNING_MESSAGE, JOptionPane.OK_CANCEL_OPTION);
//            int answer = JOptionPaneDialog.show(pane);
            int answer = JOptionPane.showOptionDialog(Configuration.getConfiguration().getMainFrame(), 
            "The file already exists, do you really want\nto create a new file?\n\nAll previous data will be lost!",
            "File exists",
             JOptionPane.WARNING_MESSAGE, JOptionPane.OK_CANCEL_OPTION, null, null, null);
            if (answer == JOptionPane.YES_OPTION)
                System.out.println("YES");
            else
            {
                System.out.println("NO");
                return;
            }
        }
        
        Path template = Paths.get(Global.mainPathPrefix, "template", "vectrexMain.template");
        de.malban.util.UtilityFiles.copyOneFile(template.toString(), lastPath);
        Path include = Paths.get(Global.mainPathPrefix, "template", "VECTREX.I");
        
        
        Path p = Paths.get(lastPath);
        File includeFile = new File(p.getParent().toString()+File.separator+ "VECTREX.I");
        de.malban.util.UtilityFiles.copyOneFile(include.toString(), includeFile.toString());
        
        addEditor(lastPath, true);        
        oneTimeTab = null;
    }//GEN-LAST:event_jMenuItemVectrexFileActionPerformed

    
    protected void deselectInTree(String tabName)
    {
        if (jTree1 == null) return;
        if (jTree1.getSelectionPath() == null) return;
        DefaultMutableTreeNode node =  (DefaultMutableTreeNode) jTree1.getSelectionPath().getLastPathComponent() ;
        if (node == null) return;
        TreeEntry entry = (TreeEntry) node.getUserObject();
        if (entry == null) return;
        if (tabName.equals(entry.name))
        {
            mClassSetting++;
            jTree1.clearSelection();
            mClassSetting--;
        }
            
    }
    
    private void jTree1ValueChanged(javax.swing.event.TreeSelectionEvent evt) {//GEN-FIRST:event_jTree1ValueChanged
        if (mClassSetting>0) return;
        if (!(((DefaultMutableTreeNode)evt.getPath().getLastPathComponent()).getUserObject() instanceof TreeEntry)) return;
        closeOneTimeTab();
        possibleProject = null;
        TreeEntry entry = (TreeEntry) ((DefaultMutableTreeNode)evt.getPath().getLastPathComponent()).getUserObject();
        if (entry.type == DIR) return;
        
        if (tabExistsSwitch(entry))
        {
            if ( (entry.name.toLowerCase().endsWith(".asm")) ||
                 (entry.name.toLowerCase().endsWith(".s")) ||
                 (entry.name.toLowerCase().endsWith(".as9")) ||
                 (entry.name.toLowerCase().endsWith(".a69")) 
               
               )
            {
                possibleProject = entry.pathAndName.toString();
            }
            return;
        }

        if ( (entry.name.toLowerCase().endsWith(".asm")) ||
             (entry.name.toLowerCase().endsWith(".s")) ||
             (entry.name.toLowerCase().endsWith(".as9")) ||
             (entry.name.toLowerCase().endsWith(".a69")) ||
             (entry.name.toLowerCase().endsWith(".template")) ||
             (entry.name.toLowerCase().endsWith(".i")) ||
             (entry.name.toLowerCase().endsWith(".h")) ||
             (entry.name.toLowerCase().endsWith(".c")) ||
             (entry.name.toLowerCase().endsWith(".ec")) ||
             (entry.name.toLowerCase().endsWith(".inc")) 
           )
        {
           addEditor(entry.pathAndName.toString(), true);
            oneTimeTab = null;
            possibleProject = entry.pathAndName.toString();
        }
        else if ( 
             (entry.name.toLowerCase().endsWith(".md")) ||
             (entry.name.toLowerCase().endsWith(".diz")) ||
             (entry.name.toLowerCase().endsWith(".doc")) ||
             (entry.name.toLowerCase().endsWith(".cc")) ||
             (entry.name.toLowerCase().endsWith(".js")) ||
             (entry.name.toLowerCase().endsWith(".cpp")) ||
             (entry.name.toLowerCase().endsWith(".java")) || 
             (entry.name.toLowerCase().endsWith(".xml")) || 
             (entry.name.toLowerCase().endsWith(".html")) || 
             (entry.name.toLowerCase().endsWith(".bat")) || 
             (entry.name.toLowerCase().endsWith(".man")) || 
             (entry.name.toLowerCase().endsWith(".lst")) || 
             (entry.name.toLowerCase().endsWith(".map")) || 
             (entry.name.toLowerCase().endsWith(".s19")) || 
             (entry.name.toLowerCase().endsWith(".rel")) || 
             (entry.name.toLowerCase().endsWith(".hlr")) || 
             (entry.name.toLowerCase().endsWith(".rst")) || 
             (entry.name.toLowerCase().endsWith(".cnt")) 
           )
        {
            addEditor(entry.pathAndName.toString(), true);
        }
        else if ( (entry.name.toLowerCase().endsWith(".txt")) 
           )
        {
            addEditor(entry.pathAndName.toString(), true);
            oneTimeTab = null;
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
        initInventory();
        
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
//                    jMenuItemModi.setEnabled(false);
//                    jMenuItemYM.setEnabled(false);
//                    jMenuItemASFX.setEnabled(false);
//                    jMenuItemRaster.setEnabled(false);
//                    jMenuItemVector.setEnabled(false);
                    jPopupMenuTree.show(evt.getComponent(), evt.getX(),evt.getY());
                    selectedTreeEntry = null;

                    return;
                }
                
                jPopupMenuProjectProperties.show(evt.getComponent(), evt.getX(),evt.getY());
                return;
            }
            if (jTree1.getSelectionPath().getLastPathComponent() == null) return;
            if (((DefaultMutableTreeNode)jTree1.getSelectionPath().getLastPathComponent()).getUserObject() == null) return;
            TreeEntry te = (TreeEntry)((DefaultMutableTreeNode) jTree1.getSelectionPath().getLastPathComponent()).getUserObject();

            if (te.type==DIR) 
            {
                if (currentProject != null)
                {
                    if (currentProject.getIsPeerCProject())
                    {
                        if (te.name.equals("lib"))
                        {
                            showAddLibPopup(evt);
                        }
                    }
                }
                return;
            }
            selectedTreeEntry = te;
            
            jMenuItemModi.setEnabled(te.name.toLowerCase().endsWith(".mod"));
          //  jMenuItemModi.setEnabled(true);
            jMenuItemYM.setEnabled(te.name.toLowerCase().endsWith(".ym"));
//            jMenuItemYM.setEnabled(te.name.toLowerCase().endsWith(".afx"));
//            jMenuItemYM.setEnabled(true);
            jMenuItemASFX.setEnabled(te.name.toLowerCase().endsWith(".afx"));
            jMenuItemAKS.setEnabled(te.name.toLowerCase().endsWith(".bin"));
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
        if (evt.getClickCount() == 2) 
        {
            if ((jTree1.getSelectionPath()!=null) && (jTree1.getSelectionPath().getLastPathComponent() != null))
            {
                TreeEntry te = (TreeEntry)((DefaultMutableTreeNode) jTree1.getSelectionPath().getLastPathComponent()).getUserObject();
                if (te.type==DIR) return;
                if (te.name.toLowerCase().endsWith(".bin"))
                {
                    // start a bin file in vecxi



                    VecXPanel vec = ((CSAMainFrame)mParent).getVecxy();
                    ((CSAMainFrame)mParent).getInternalFrame(vec).toFront();

                    String fname = te.pathAndName.toString();

                    vec.startUp(fname, true, START_TYPE_RUN);
                    printMessage("Starting emulation...");
                }
                else
                {
                    String fname = te.pathAndName.toString();
                    CSAMainFrame.invokeSystemFile(new File(fname));
                }
            }
            
            

        }
        
    }//GEN-LAST:event_jTree1MousePressed

    void addLibItem(java.awt.event.ActionEvent evt)
    {
        String sourceInc =  Global.mainPathPrefix+"C"+File.separator+"PeerC"+File.separator+"vide"+File.separator+"include";
        String source =  Global.mainPathPrefix+"C"+File.separator+"PeerC"+File.separator+"vide"+File.separator+"lib";
        String dest =  currentProject.projectPrefix;
        String destInc =  currentProject.projectPrefix;
        
        dest = dest+File.separator+"lib"+File.separator;
        destInc = destInc+File.separator+"include";

        javax.swing.JMenuItem item = (javax.swing.JMenuItem) evt.getSource();
        String baseName = item.getText();
        
        de.malban.util.UtilityFiles.copyOneFile(source+File.separator+baseName+".rel", dest+File.separator+baseName+".rel");
        de.malban.util.UtilityFiles.copyOneFile(source+File.separator+baseName+".lst", dest+File.separator+baseName+".lst");

        de.malban.util.UtilityFiles.copyOneFile(sourceInc+File.separator+baseName+".h", destInc+File.separator+baseName+".h");
        refreshTree();
    }
    void showAddLibPopup(java.awt.event.MouseEvent evt)
    {
        javax.swing.JPopupMenu jPopupMenu = new javax.swing.JPopupMenu();
        
        String source =  Global.mainPathPrefix+"C"+File.separator+"PeerC"+File.separator+"vide"+File.separator+"lib";
        File directory = new File(source);
        File[] fList = directory.listFiles();
        for (File file : fList) 
        {
            String fileNameOnly = file.getName();
            if (!fileNameOnly.endsWith(".rel")) continue;
            String nameonly = baseOnly(fileNameOnly);
            javax.swing.JMenuItem item = new javax.swing.JMenuItem(nameonly);
            item.setText(nameonly);
            item.addActionListener(new java.awt.event.ActionListener() {
                public void actionPerformed(java.awt.event.ActionEvent evt) {
                    addLibItem(evt);
                }
            });
            jPopupMenu.add(item);
        }    
    
        jPopupMenu.show(evt.getComponent(), evt.getX(),evt.getY());
    }
            

    private void jMenuItemFilePropertiesActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemFilePropertiesActionPerformed
        doFileProperties(selectedTreeEntry);
    }//GEN-LAST:event_jMenuItemFilePropertiesActionPerformed

    private void jMenuItemProjectPropertiesActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemProjectPropertiesActionPerformed
        doProjectProperties();
        
        if (currentProject.getIsPeerCProject())
        {
            String flags = currentProject.getCFLAGS();
            boolean hasFramePointer = true;
            if (flags.contains("-fomit-frame-pointer"))
                hasFramePointer = false;
            resetCScan(hasFramePointer);    
        }
    }//GEN-LAST:event_jMenuItemProjectPropertiesActionPerformed

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
        
        File ttest = new File(selectedTreeEntry.pathAndName.toString());
        if (ttest.isDirectory()) return;
        
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
            
            pathOnly = de.malban.util.Utility.makeVideRelative(pathOnly);
            FilePropertiesPool pool = new FilePropertiesPool(pathOnly+File.separator, test.getName());
            FileProperties fileProperties =  pool.get(filenameOnly);
            if (fileProperties!=null)
            {
                if (fileProperties.getFilename().endsWith(filenameOnly))
                {
                    de.malban.util.UtilityFiles.deleteFile(Global.mainPathPrefix+pathOnly+File.separator+ filenameBaseOnly+"FileProperty.xml");
                }
            }
        }
        
        refreshTree();
    }//GEN-LAST:event_jMenuItemDeleteActionPerformed

    private void jMenuItemRefreshActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemRefreshActionPerformed
        refreshTree();
    }//GEN-LAST:event_jMenuItemRefreshActionPerformed

    
    private void jMenuItemDuplicateActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemDuplicateActionPerformed
        if (selectedTreeEntry == null) return;
        de.malban.util.UtilityFiles.copyOneFile(selectedTreeEntry.pathAndName.toString(),  selectedTreeEntry.pathAndName.toString()+".copy");
        refreshTree();
    }//GEN-LAST:event_jMenuItemDuplicateActionPerformed

     
    private void jMenuItemAddToProjectActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemAddToProjectActionPerformed
        if (!inProject) return;
        InternalFrameFileChoser fc = new de.malban.gui.dialogs.InternalFrameFileChoser();
        fc.setMultiSelectionEnabled(true);
        if (lastPath.length()==0)
        {
            fc.setCurrentDirectory(new java.io.File(Global.mainPathPrefix));
        }
        else
        {
            fc.setCurrentDirectory(new java.io.File(lastPath));
        }
        int r = fc.showOpenDialog(Configuration.getConfiguration().getMainFrame());
        if (r != InternalFrameFileChoser.APPROVE_OPTION) return;
        File[] files = fc.getSelectedFiles();
        if (files == null)
        {
            File f = fc.getSelectedFile();
            if (f != null)
            {
                String fullPath = f.getAbsolutePath();
                lastPath = fullPath;
                addFileToProject(f);
            }
            
        }
        else // add multiple images
        {
            if (files.length>0)
            {
                String fullPath = files[0].getAbsolutePath();
                lastPath = fullPath;
                for (File f : files)
                    addFileToProject(f);
            }
        }        
        fillTree(Paths.get(de.malban.util.Utility.makeVideAbsolute(currentProject.projectPrefix)));
    }//GEN-LAST:event_jMenuItemAddToProjectActionPerformed

    private void jMenuItemCloseActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemCloseActionPerformed
        inProject = false;
        fillTree();
        closeAllEditors();
        
        asmInfo.clearDefinitions();
        cInfo.clearDefinitions();
        
        settings.currentProject = null;
        currentProject = null;
    }//GEN-LAST:event_jMenuItemCloseActionPerformed

    public void closeProject()
    {
        inProject = false;
        fillTree();
        closeAllEditors();
        asmInfo.clearDefinitions();
        cInfo.clearDefinitions();
        settings.currentProject = null;
        currentProject = null;
    }
    private void jListProjectsMousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jListProjectsMousePressed
        
        if (evt.getClickCount() == 2) 
        {
            int index = jListProjects.locationToIndex(evt.getPoint());
            if (index == -1) return;
            VediSettings.P p = (VediSettings.P) projectsListModel.elementAt(index);
            settings.currentProject = p;
            if ((settings.currentProject != null) && (settings.currentProject.mName.trim().length()!=0))
            {
                closeAllEditors();
                asmInfo.clearDefinitions();
                cInfo.clearDefinitions();
                String path = settings.currentProject.mFullPath;
                
//                if (!settings.currentProject.mFullPath.endsWith(settings.currentProject.mName))
//                {
//                    path = path + File.separator +settings.currentProject.mName;
//                }
                
                
                loadProject(settings.currentProject.mClass, settings.currentProject.mName, path);
            }
            // switch tab
            jTabbedPane2.setSelectedIndex(0);
            
        }
        
    }//GEN-LAST:event_jListProjectsMousePressed

    private void jListFilesMousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jListFilesMousePressed
        if (evt.getClickCount() == 2) 
        {
            int index = jListFiles.locationToIndex(evt.getPoint());
            if (index == -1) return;
     
            EditorFileSettings fn = settings.recentOpenFiles.get(index);
            EditorPanel edi = addEditor(de.malban.util.Utility.makeVideAbsolute(fn.filename), true);
            if (edi != null)
            {
                edi.setPosition(fn.position);
            }
            oneTimeTab = null;
            if (edi == null)
            {
                // error while loading, remove file from current
                settings.currentOpenFiles.remove(fn);
            }
            if (!inProject)
            {
                if (edi != null)
                    fillTree(Paths.get(de.malban.util.Utility.makeVideAbsolute(fn.filename)).getParent());
                else
                    fillTree();
            }
            
            // switch tab
            jTabbedPane2.setSelectedIndex(0);
        }
    }//GEN-LAST:event_jListFilesMousePressed

    private void jMenuItemSetMainActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemSetMainActionPerformed

        if (!inProject) return;
        String filename = selectedTreeEntry.name.toString();
        currentProject.setMainFile(filename);
        currentProject.getBankMainFiles().remove(0);
        currentProject.getBankMainFiles().add(0,filename);
        
        saveProject();
        
    }//GEN-LAST:event_jMenuItemSetMainActionPerformed

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
            pathOnly = de.malban.util.Utility.makeVideRelative(pathOnly);  
            if (pathOnly.length()!=0) pathOnly+=File.separator;
            FilePropertiesPool pool = new FilePropertiesPool(pathOnly, test.getName());

            FileProperties fileProperties =  pool.get(fileNameOnly);
            if (fileProperties == null) return;

            String scriptClass = fileProperties.getActionScriptClass();
            String scriptName = fileProperties.getActionScriptName();
            ExecutionDescriptor ed = new ExecutionDescriptor(ED_TYPE_FILE_ACTION, currentProject.getProjectName(), fileNameOnly, "VediPanel", de.malban.util.Utility.makeVideAbsolute(pathOnly) );
            if (!ScriptDataPanel.executeScript(scriptClass, scriptName, VediPanel.this, ed))
            {
                printWarning("Script for "+fileNameOnly+" returned with error!");
            }
        }

        scanTreeDirectory(selectedTreeEntry);

    }//GEN-LAST:event_jMenuItemActionActionPerformed

    private void jButtonClearMessagesActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonClearMessagesActionPerformed
        if ((evt != null ) && ((evt.getModifiers() & SHIFT_MASK) == SHIFT_MASK))
        {
            String to = Global.mainPathPrefix+"tmp"+File.separator+"BIOS.ASM";
            File biosFile = new File(to);
            if (!biosFile.exists())
            {
                String from = Global.mainPathPrefix+"codelib"+File.separator+"Originals"+File.separator+"BIOS - Bruce Tomlin"+File.separator+"BIOS.ASM";
                de.malban.util.UtilityFiles.copyOneFile(from, to);
            }
            try
            {
                SwingUtilities.invokeLater(new Runnable()
                {
                    public void run()
                    {
                        jumpToEdit(to, 0);
                    }
                });                    
            }
            catch (Throwable e)
            {

            }        
        }
        jEditorPaneASMListing.setText("");
        jEditorASMMessages.setText("");
        jEditorLog.setText("");
        
    }//GEN-LAST:event_jButtonClearMessagesActionPerformed

    private void jMenuItemRasterActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemRasterActionPerformed
        doRasterImage();
    }//GEN-LAST:event_jMenuItemRasterActionPerformed

    private void jMenuItemSampleActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemSampleActionPerformed
        doSample();
        refreshTree();
    }//GEN-LAST:event_jMenuItemSampleActionPerformed

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

    private void jMenuItemASFXActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemASFXActionPerformed
        doAYFX();
    }//GEN-LAST:event_jMenuItemASFXActionPerformed
    boolean fileView = false;
    private void jButtonRefreshActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonRefreshActionPerformed
        if ((evt != null ) && ((evt.getModifiers() & SHIFT_MASK) == SHIFT_MASK))
        {
            fileView = true;
        }
        else
        {
            fileView = false;
        }
        refreshTree();
    }//GEN-LAST:event_jButtonRefreshActionPerformed

    private void jMenuItemVectorActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemVectorActionPerformed
        doVector();
    }//GEN-LAST:event_jMenuItemVectorActionPerformed

    private void jButtonNew1MousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jButtonNew1MousePressed
        // TODO add your handling code here:
    }//GEN-LAST:event_jButtonNew1MousePressed

    private void jButtonNew1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonNew1ActionPerformed
        settings.recentOpenFiles = new ArrayList<EditorFileSettings>();
        updateList();
    }//GEN-LAST:event_jButtonNew1ActionPerformed

    private void jButtonNew7MousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jButtonNew7MousePressed
        // TODO add your handling code here:
    }//GEN-LAST:event_jButtonNew7MousePressed

    private void jButtonNew7ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonNew7ActionPerformed
        settings.recentProject = new ArrayList<VediSettings.P>();
        updateList();
    }//GEN-LAST:event_jButtonNew7ActionPerformed

    private void jButtonDebugActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonDebugActionPerformed
        debug();
    }//GEN-LAST:event_jButtonDebugActionPerformed

    private void jMenuItemVecSpeechActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemVecSpeechActionPerformed
        String path = "";
        if (inProject)
        {
            if (currentProject != null)
            {
                path = de.malban.util.Utility.makeVideAbsolute(currentProject.projectPrefix)+File.separator;
            }
        }
        VecSpeechPanel.showVecSpeechPanelNoModal(this, path);
    }//GEN-LAST:event_jMenuItemVecSpeechActionPerformed

    private void jButtonInjectBinActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonInjectBinActionPerformed
        VecXPanel vec = ((CSAMainFrame)mParent).getVecxy();

        if (vec == null) return;
        if ((!vec.isRunning()) && (!vec.isDebuging())) 
        {
            printError("Vecxi not running!");
            return;
        }
        
        startTypeRun = START_TYPE_INJECT;
        runInternal();
    }//GEN-LAST:event_jButtonInjectBinActionPerformed

    private void jTextFieldCommandActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldCommandActionPerformed
        String command = jTextFieldCommand.getText();
        jTextFieldCommand.setText("");
        doQuickHelp(command, command);
    }//GEN-LAST:event_jTextFieldCommandActionPerformed

    private void jButtonFileSelect1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonFileSelect1ActionPerformed
        InternalFrameFileChoser fc = new de.malban.gui.dialogs.InternalFrameFileChoser();
        fc.setDialogTitle("Select VecFever RAMDISK-drive");
        fc.setCurrentDirectory(new java.io.File(File.separator));
        fc.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);

        int r = fc.showOpenDialog(Configuration.getConfiguration().getMainFrame());
        if (r != InternalFrameFileChoser.APPROVE_OPTION) return;
        String lastPath = fc.getSelectedFile().getAbsolutePath();

        Path p = Paths.get(lastPath);
        settings.v4eVolumeName = p.toString();
        jTextFieldPath.setText(p.toString());
        checkVec4Ever(true);        
    }//GEN-LAST:event_jButtonFileSelect1ActionPerformed

    private void jButtonCheckVec4EverActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonCheckVec4EverActionPerformed
        checkVec4Ever(true);        
    }//GEN-LAST:event_jButtonCheckVec4EverActionPerformed

    private void jButtonEjectVecForeverActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonEjectVecForeverActionPerformed
        ejectVec4Ever();
        checkVec4Ever(false);        
    }//GEN-LAST:event_jButtonEjectVecForeverActionPerformed

    private void jCheckBoxIgnoreCase1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxIgnoreCase1ActionPerformed
        settings.v4eEnabled = jCheckBoxIgnoreCase1.isSelected();
        checkVec4Ever(false);
    }//GEN-LAST:event_jCheckBoxIgnoreCase1ActionPerformed

    private void jButtonFontPlusActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonFontPlusActionPerformed
         increaseFontSize();
    }//GEN-LAST:event_jButtonFontPlusActionPerformed

    private void jButtonFontMinusActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonFontMinusActionPerformed
        decreaseFontSize();
    }//GEN-LAST:event_jButtonFontMinusActionPerformed

    private void jTableBookmarksMousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jTableBookmarksMousePressed
       
        JTable table =(JTable) evt.getSource();
        Point p = evt.getPoint();
        int row = table.rowAtPoint(p);
        int col = table.columnAtPoint(p);
        
        if (evt.getClickCount() == 2) 
            goBookmark(row);
        
    }//GEN-LAST:event_jTableBookmarksMousePressed

    int popupRow = -1;
    private void jTableBreakpointsMousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jTableBreakpointsMousePressed
        JTable table =(JTable) evt.getSource();
        Point p = evt.getPoint();
        int row = table.rowAtPoint(p);
        int col = table.columnAtPoint(p);
        if (evt.getButton() == MouseEvent.BUTTON3)
        {
            popupRow = row;
            jPopupMenuBP.show(jTableBreakpoints, evt.getX()-20,evt.getY()-20);
        }        
        
        if (evt.getClickCount() == 2) 
            goBreakpoint(breakpointModel.getDebugComment(row));
    }//GEN-LAST:event_jTableBreakpointsMousePressed

    private void jMenuItemRemoveBPActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemRemoveBPActionPerformed
        if (popupRow<0) return;
        DebugComment dbc = breakpointModel.getDebugComment(popupRow);
        DebugCommentList list = getDebugComments(dbc.file);
        if (list == null) return;
        
        int line = dbc.beforLineNo;
        list.removeComment(dbc);
        updateTables();
        EditorPanel edi = getEditor(dbc.file, false);
        if (edi == null) return;
        edi.correctLine(line);
    }//GEN-LAST:event_jMenuItemRemoveBPActionPerformed

    private void jButtonDebugSyntaxActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonDebugSyntaxActionPerformed
        SyntaxDebugJPanel.showSyntaxDebugPanelNoModal(UID);

    }//GEN-LAST:event_jButtonDebugSyntaxActionPerformed

    private void jTableInventoryMousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jTableInventoryMousePressed
        JTable table =(JTable) evt.getSource();
        Point p = evt.getPoint();
        int row = table.rowAtPoint(p);
        int col = table.columnAtPoint(p);
        row = sorter.convertRowIndexToModel(row);
        
        if (evt.getClickCount() == 2) 
            goFunction(row);
    }//GEN-LAST:event_jTableInventoryMousePressed

    private void jButtonAdressBackActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonAdressBackActionPerformed
        historyBack();
    }//GEN-LAST:event_jButtonAdressBackActionPerformed

    private void jButtonAdressForwardActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonAdressForwardActionPerformed
        historyForward();
    }//GEN-LAST:event_jButtonAdressForwardActionPerformed

    private void jButtonLabelConfigActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonLabelConfigActionPerformed
        LabelVisibilityConfigPanel.showEnterValueDialog(settings);
        initInventory();
    }//GEN-LAST:event_jButtonLabelConfigActionPerformed

    private void jTableWatchesMousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jTableWatchesMousePressed
        JTable table =(JTable) evt.getSource();
        Point p = evt.getPoint();
        int row = table.rowAtPoint(p);
        int col = table.columnAtPoint(p);
        if (evt.getButton() == MouseEvent.BUTTON3)
        {
            popupRow = row;
            jPopupMenuWatch.show(jTableWatches, evt.getX()-20,evt.getY()-20);
        }        
        
    }//GEN-LAST:event_jTableWatchesMousePressed

    private void jMenuItemRemoveWatchActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemRemoveWatchActionPerformed
        if (popupRow<0) return;
        DebugComment dbc = watchesModel.getDebugComment(popupRow);
        DebugCommentList list = getDebugComments(dbc.file);
        if (list == null) return;
        list.removeComment(dbc);
        updateTables();
    }//GEN-LAST:event_jMenuItemRemoveWatchActionPerformed

    private void jMenuItem1AddNewFileActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem1AddNewFileActionPerformed
        if (selectedTreeEntry == null) return;
        
        
        String dir = Global.mainPathPrefix;
        if (selectedTreeEntry.pathAndName.getParent() != null)
        {
            dir = selectedTreeEntry.pathAndName.getParent()+File.separator;
        }
                
        
        
        de.malban.util.UtilityFiles.createTextFile(dir+"newFile.asm", "");
        refreshTree();
    }//GEN-LAST:event_jMenuItem1AddNewFileActionPerformed

    private void jMenuItemAKSActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemAKSActionPerformed

        doAKS();

    }//GEN-LAST:event_jMenuItemAKSActionPerformed

    private void jMenuItem1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem1ActionPerformed
        if (selectedTreeEntry == null) return;
        doCCompilerSingleFile(selectedTreeEntry.pathAndName.toString());
        refreshTree();
    }//GEN-LAST:event_jMenuItem1ActionPerformed

    private void jTabbedPaneMousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jTabbedPaneMousePressed
      

    }//GEN-LAST:event_jTabbedPaneMousePressed

    private void jEditorLogMousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jEditorLogMousePressed
        if (evt.getClickCount() == 2) 
        {
            Point pt = new Point(evt.getX(), evt.getY());
            int pos = jEditorLog.viewToModel(pt);
            int line = getLineOfPos(jEditorLog, pos);
            if (line != -1)
            {
                String lineString = getLine(jEditorLog, line);
                if (!lineString.contains(": error")) return;
                if (lineString.indexOf(": error")<2) return;
                // format
                // ABS_FILENAME:ROW: error:
                String filename = "";
                String linenumber = "";
                filename = lineString.substring(0, lineString.indexOf(": error"));
                filename = filename.substring(0, filename.lastIndexOf(":"));

                File f = new File(filename); 
                if (!f.exists())
                {
                    if (filename.lastIndexOf(":")>0)
                        filename = filename.substring(0, filename.lastIndexOf(":"));
                }
                linenumber = de.malban.util.UtilityString.replace(lineString, filename+":", "");
                linenumber = linenumber.substring(0,linenumber.indexOf(":"));
                
                /*
        // check if "C"
        String fn = getSelectedEditor().getFilename().toLowerCase();
        if ((fn.endsWith(".c")) || (fn.endsWith(".h")));
                
                
                if (!lineString.startsWith(File.separator)) return;
                String[] split = lineString.split(":");
                split = removeEmpty(split);
                if (split.length<2) return;
                String file = split[0];
                String lineno = split[1];
                */
                int lineNoI = DASM6809.toNumber(linenumber);


                processErrorLine(filename, lineNoI);
            }
        }
    }//GEN-LAST:event_jEditorLogMousePressed

    private void jButtonAssembleOneActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonAssembleOneActionPerformed
        startTypeRun = START_TYPE_STOP;
        runInternal();
    }//GEN-LAST:event_jButtonAssembleOneActionPerformed

    private void jButtonAssembleOne1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonAssembleOne1ActionPerformed
        toAssi();
        refreshTree();
    }//GEN-LAST:event_jButtonAssembleOne1ActionPerformed

    private void jButtonAssembleOne2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonAssembleOne2ActionPerformed
        jButtonClearMessagesActionPerformed(null);
        toAs6809();
        refreshTree();
    }//GEN-LAST:event_jButtonAssembleOne2ActionPerformed

    private void jButtonAssembleOne3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonAssembleOne3ActionPerformed
        jButtonClearMessagesActionPerformed(null);
        preprocessOnly();
        refreshTree();
    }//GEN-LAST:event_jButtonAssembleOne3ActionPerformed

    private void jButtonAssembleOne4ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonAssembleOne4ActionPerformed
        jButtonClearMessagesActionPerformed(null);
        doAS6809();
        refreshTree();
    }//GEN-LAST:event_jButtonAssembleOne4ActionPerformed

    private void jMenuItemCFileActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemCFileActionPerformed

        if (currentProject==null) return;
        if (!currentProject.getIsPeerCProject()) return;
        
        String baseProjectPath = currentProject.projectPrefix+File.separator+"source"+File.separator;

        InternalFrameFileChoser fc = new de.malban.gui.dialogs.InternalFrameFileChoser();
        fc.setCurrentDirectory(new java.io.File(de.malban.util.Utility.makeVideAbsolute(baseProjectPath)));

            
        int r = fc.showOpenDialog(Configuration.getConfiguration().getMainFrame());
        if (r != InternalFrameFileChoser.APPROVE_OPTION) return;
        lastPath = fc.getSelectedFile().getAbsolutePath();
        
        File newFile = new File(lastPath);
        if (newFile.exists())
        {
//            JOptionPane pane = new JOptionPane("The file already exists, do you really want\nto create a new file?\n\nAll previous data will be lost!", JOptionPane.WARNING_MESSAGE, JOptionPane.OK_CANCEL_OPTION);
//            int answer = JOptionPaneDialog.show(pane);

                int answer = JOptionPane.showOptionDialog(Configuration.getConfiguration().getMainFrame(), 
                "The file already exists, do you really want\nto create a new file?\n\nAll previous data will be lost!",
                "File exists",
                 JOptionPane.WARNING_MESSAGE, JOptionPane.OK_CANCEL_OPTION, null, null, null);

            if (answer == JOptionPane.YES_OPTION)
                System.out.println("YES");
            else
            {
                System.out.println("NO");
                return;
            }
        }
        Path template = Paths.get(Global.mainPathPrefix, "template", "template.c");
        de.malban.util.UtilityFiles.copyOneFile(template.toString(), lastPath);
        
        addEditor(lastPath, true);        
        oneTimeTab = null;     
        refreshTree();
        
    }//GEN-LAST:event_jMenuItemCFileActionPerformed

    private void jCheckBox1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox1ActionPerformed
        // TODO add your handling code here:
        // debug only
        if (jCheckBox1.isSelected())
        {
            initScheduler();
            log.addLog("scheduling was switched on manually", INFO);
        }
        else
        {
            deinitScheduler();
            log.addLog("scheduling was switched off manually", INFO);
        }
    }//GEN-LAST:event_jCheckBox1ActionPerformed
    
    @Override
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
                printMessage("Result: "+i + "("+((i>127)?(i-256):(i))+")" +", $"+String.format("%02X", i & 0xFF)+", "+DASM6809.printbinary(i));
            else
                printMessage("Result: "+i+ "("+((i>127)?(i-65536):(i))+")"+", $"+String.format("%X", i)+", "+DASM6809.printbinary16(i));
        
        
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
    private javax.swing.JButton jButtonAdressBack;
    private javax.swing.JButton jButtonAdressForward;
    javax.swing.JButton jButtonAssemble;
    private javax.swing.JButton jButtonAssembleOne;
    private javax.swing.JButton jButtonAssembleOne1;
    private javax.swing.JButton jButtonAssembleOne2;
    private javax.swing.JButton jButtonAssembleOne3;
    private javax.swing.JButton jButtonAssembleOne4;
    private javax.swing.JButton jButtonCheckVec4Ever;
    private javax.swing.JButton jButtonClearMessages;
    private javax.swing.JButton jButtonCopy;
    private javax.swing.JButton jButtonCut;
    javax.swing.JButton jButtonDebug;
    private javax.swing.JButton jButtonDebugSyntax;
    private javax.swing.JButton jButtonEjectVecForever;
    private javax.swing.JButton jButtonFileSelect1;
    private javax.swing.JButton jButtonFontMinus;
    private javax.swing.JButton jButtonFontPlus;
    private javax.swing.JButton jButtonIgnoreCase;
    private javax.swing.JButton jButtonInjectBin;
    private javax.swing.JButton jButtonLabelConfig;
    private javax.swing.JButton jButtonLoad;
    private javax.swing.JButton jButtonNew;
    private javax.swing.JButton jButtonNew1;
    private javax.swing.JButton jButtonNew7;
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
    private javax.swing.JCheckBox jCheckBox1;
    private javax.swing.JCheckBox jCheckBoxIgnoreCase;
    private javax.swing.JCheckBox jCheckBoxIgnoreCase1;
    private javax.swing.JEditorPane jEditorASMMessages;
    private javax.swing.JEditorPane jEditorLog;
    private javax.swing.JEditorPane jEditorPaneASMListing;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel10;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JLabel jLabel6;
    private javax.swing.JLabel jLabel7;
    private javax.swing.JLabel jLabel9;
    private javax.swing.JList jListFiles;
    private javax.swing.JList jListProjects;
    private javax.swing.JMenuItem jMenuItem1;
    private javax.swing.JMenuItem jMenuItem1AddNewFile;
    private javax.swing.JMenuItem jMenuItemAKS;
    private javax.swing.JMenuItem jMenuItemASFX;
    private javax.swing.JMenuItem jMenuItemAction;
    private javax.swing.JMenuItem jMenuItemAddToProject;
    private javax.swing.JMenuItem jMenuItemCFile;
    private javax.swing.JMenuItem jMenuItemClose;
    private javax.swing.JMenuItem jMenuItemDelete;
    private javax.swing.JMenuItem jMenuItemDuplicate;
    private javax.swing.JMenuItem jMenuItemFileProperties;
    private javax.swing.JMenuItem jMenuItemModi;
    private javax.swing.JMenuItem jMenuItemNewFile;
    private javax.swing.JMenuItem jMenuItemNewProject;
    private javax.swing.JMenuItem jMenuItemProjectProperties;
    private javax.swing.JMenuItem jMenuItemRaster;
    private javax.swing.JMenuItem jMenuItemRefresh;
    private javax.swing.JMenuItem jMenuItemRemoveBP;
    private javax.swing.JMenuItem jMenuItemRemoveWatch;
    private javax.swing.JMenuItem jMenuItemRename;
    private javax.swing.JMenuItem jMenuItemSample;
    private javax.swing.JMenuItem jMenuItemSetMain;
    private javax.swing.JMenuItem jMenuItemVecSpeech;
    private javax.swing.JMenuItem jMenuItemVector;
    private javax.swing.JMenuItem jMenuItemVectrexFile;
    private javax.swing.JMenuItem jMenuItemYM;
    private javax.swing.JMenu jMenuNewFileMenu;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel10;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JPanel jPanel3;
    private javax.swing.JPanel jPanel4;
    private javax.swing.JPanel jPanel5;
    private javax.swing.JPanel jPanel6;
    private javax.swing.JPanel jPanel7;
    private javax.swing.JPanel jPanel8;
    private javax.swing.JPanel jPanel9;
    private javax.swing.JPopupMenu jPopupMenu1;
    private javax.swing.JPopupMenu jPopupMenuBP;
    private javax.swing.JPopupMenu jPopupMenuProjectProperties;
    private javax.swing.JPopupMenu jPopupMenuTree;
    private javax.swing.JPopupMenu jPopupMenuWatch;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JScrollPane jScrollPane10;
    private javax.swing.JScrollPane jScrollPane2;
    private javax.swing.JScrollPane jScrollPane3;
    private javax.swing.JScrollPane jScrollPane4;
    private javax.swing.JScrollPane jScrollPane5;
    private javax.swing.JScrollPane jScrollPane6;
    private javax.swing.JScrollPane jScrollPane7;
    private javax.swing.JScrollPane jScrollPane8;
    private javax.swing.JScrollPane jScrollPane9;
    private javax.swing.JPopupMenu.Separator jSeparator1;
    private javax.swing.JPopupMenu.Separator jSeparator2;
    private javax.swing.JPopupMenu.Separator jSeparator3;
    private javax.swing.JPopupMenu.Separator jSeparator4;
    private javax.swing.JSplitPane jSplitPane1;
    private javax.swing.JSplitPane jSplitPane2;
    private javax.swing.JSplitPane jSplitPane3;
    private javax.swing.JSplitPane jSplitPane4;
    private javax.swing.JTabbedPane jTabbedPane;
    private javax.swing.JTabbedPane jTabbedPane1;
    private javax.swing.JTabbedPane jTabbedPane2;
    private javax.swing.JTabbedPane jTabbedPane3;
    private javax.swing.JTable jTableBookmarks;
    private javax.swing.JTable jTableBreakpoints;
    private javax.swing.JTable jTableInventory;
    private javax.swing.JTable jTableWatches;
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
        if (s.trim().length()==0) return;
        try
        {
            if (s.endsWith("\n"))
                jEditorLog.getDocument().insertString(jEditorLog.getDocument().getLength(), s, TokenStyles.getStyle("editLogMessage"));
            else
                jEditorLog.getDocument().insertString(jEditorLog.getDocument().getLength(), s+"\n", TokenStyles.getStyle("editLogMessage"));
        } catch (Throwable e) { }
        jEditorLog.setCaretPosition(jEditorLog.getDocument().getLength());
    }
    
    public void printNoLNMessage(String s)
    {
        if (s.trim().length()==0) return;
        try
        {
            jEditorLog.getDocument().insertString(jEditorLog.getDocument().getLength(), s, TokenStyles.getStyle("editLogMessage"));
        } catch (Throwable e) { }
        jEditorLog.setCaretPosition(jEditorLog.getDocument().getLength());
    }
    public void printWarning(String s)
    {
        if (s.trim().length()==0) return;
        try
        {
            if (s.endsWith("\n"))
                jEditorLog.getDocument().insertString(jEditorLog.getDocument().getLength(), s, TokenStyles.getStyle("editLogWarning"));
            else
                jEditorLog.getDocument().insertString(jEditorLog.getDocument().getLength(), s+"\n", TokenStyles.getStyle("editLogWarning"));
        } catch (Throwable e) { }
        jEditorLog.setCaretPosition(jEditorLog.getDocument().getLength());
    }    
    public void printNoLNWarning(String s)
    {
        if (s.trim().length()==0) return;
        try
        {
            jEditorLog.getDocument().insertString(jEditorLog.getDocument().getLength(), s, TokenStyles.getStyle("editLogWarning"));
        } catch (Throwable e) { }
        jEditorLog.setCaretPosition(jEditorLog.getDocument().getLength());
    }    
    public void printError(String s)
    {
        if (s.trim().length()==0) return;
        try
        {
            if (s.endsWith("\n"))
                jEditorLog.getDocument().insertString(jEditorLog.getDocument().getLength(), s, TokenStyles.getStyle("editLogError"));
            else
                jEditorLog.getDocument().insertString(jEditorLog.getDocument().getLength(), s+"\n", TokenStyles.getStyle("editLogError"));
        
        } catch (Throwable e) { 
        System.out.println(e);
        e.printStackTrace();
        
        }
        jEditorLog.setCaretPosition(jEditorLog.getDocument().getLength());
    }
    public void printNoLNError(String s)
    {
        if (s.trim().length()==0) return;
        try
        {
            jEditorLog.getDocument().insertString(jEditorLog.getDocument().getLength(), s, TokenStyles.getStyle("editLogError"));
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
    
    
    public void printASMList(String s, int type)
    {
        try
        {
            if (type == ASM_LIST)
            {
                if (s.startsWith("******"))
                {
                    jEditorPaneASMListing.getDocument().insertString(jEditorPaneASMListing.getDocument().getLength(), s, TokenStyles.getStyle("editLogError"));
                }
                else if (s.startsWith("++++++"))
                {
                    jEditorPaneASMListing.getDocument().insertString(jEditorPaneASMListing.getDocument().getLength(), s, TokenStyles.getStyle("editLogWarning"));
                }
                else if (s.startsWith("######"))
                {
                    jEditorPaneASMListing.getDocument().insertString(jEditorPaneASMListing.getDocument().getLength(), s, TokenStyles.getStyle("editLogComment"));
                }
                else
                    jEditorPaneASMListing.getDocument().insertString(jEditorPaneASMListing.getDocument().getLength(), s, TokenStyles.getStyle("editLogMessage"));
            }
            else if (type == ASM_SYMBOL)
            {
                jEditorPaneASMListing.getDocument().insertString(jEditorPaneASMListing.getDocument().getLength(), s, TokenStyles.getStyle("editLogWarning"));
            }
        } catch (Throwable e) { }
        jEditorPaneASMListing.setCaretPosition(jEditorPaneASMListing.getDocument().getLength());
    }
    public void printASMMessage(String s, int type)
    {
        try
        {
            if (type == ASM_MESSAGE_INFO)
            {
                jEditorASMMessages.getDocument().insertString(jEditorASMMessages.getDocument().getLength(), s, TokenStyles.getStyle("editLogMessage"));
            }
            else if (type == ASM_MESSAGE_ERROR)
            {
                jEditorASMMessages.getDocument().insertString(jEditorASMMessages.getDocument().getLength(), s, TokenStyles.getStyle("editLogError"));
            }
            else if (type == ASM_MESSAGE_WARNING)
            {
                jEditorASMMessages.getDocument().insertString(jEditorASMMessages.getDocument().getLength(), s, TokenStyles.getStyle("editLogWarning"));
            }
            else if (type == ASM_MESSAGE_OPTIMIZATION)
            {
                jEditorASMMessages.getDocument().insertString(jEditorASMMessages.getDocument().getLength(), s, TokenStyles.getStyle("editLogComment"));
            }
        } catch (Throwable e) { }
        jEditorASMMessages.setCaretPosition(jEditorASMMessages.getDocument().getLength());
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
//        getSelectedEditor().correctLineNumbers(false);
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
            settings.removeOpen(edit.getFilename());
            if (edit.isAddToSettings())
            {
                settings.removeRecent(edit.getFilename());
                settings.addRecent(edit.getFilename(), edit.getPosition());
                updateList();
            }
            edit.deinit();
        }
        if (jTabbedPane1.getComponentAt(found) instanceof BinaryPanel)
        {
            BinaryPanel edit = (BinaryPanel)jTabbedPane1.getComponentAt(found);
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
    private void processErrorLine(String file, int lineno)
    {
        try
        {
            jumpToEdit(file, lineno);
        }
        catch (Throwable e)
        {
            
        }
        
    }
    
    // figure out filename and line, - if possible
    public void processIncludeLine(String lineString)
    {
        // check if "C"
        String fn = getSelectedEditor().getFilename().toLowerCase();
        if ((fn.endsWith(".c")) || (fn.endsWith(".h"))|| (fn.endsWith(".i")))
        {
            // C assumed
            if (lineString.contains("//"))
                lineString = lineString.substring(0,lineString.indexOf("//"));
            lineString = de.malban.util.UtilityString.replace(lineString.trim(), "#", "");
            lineString = de.malban.util.UtilityString.replace(lineString.trim(), "\t", "");
            lineString = de.malban.util.UtilityString.replace(lineString.trim(), "include", "");
            lineString = de.malban.util.UtilityString.replace(lineString.trim(), "INCLUDE", "");
            lineString = de.malban.util.UtilityString.replace(lineString.trim(), "<", "");
            lineString = de.malban.util.UtilityString.replace(lineString.trim(), ">", "");
            lineString = de.malban.util.UtilityString.replace(lineString.trim(), "\"", "").trim();
            // assuming lineString = filename
            // try load in current Dir first
            String nameToLoad=convertSeperator(lineString);
            String line = nameToLoad;

            
            String[] parts = line.split("\"");
            String name = "";
            if (parts.length<=1) 
                parts = line.split("'");
            if (parts.length<=1) 
                parts = line.split(" ");
            if (parts.length<=0) 
                return;
            String filename;
            filename = parts[0].trim();
            if ((filename.length()==0) && (parts.length>1))filename = parts[1].trim();
            if (filename.length()==0)return;
            String path = getSelectedEditor().getPath();
            if (path != null)
            {
                nameToLoad=path+File.separator;
            }
            nameToLoad=convertSeperator(nameToLoad);
            
            // check sub dirs
            if (File.separator.equals("\\"))
            {
                // Windows!!!!
                parts = filename.split("\\\\");
            }
            else
                parts = filename.split(File.separator);
            if (parts.length > 1)
            {
                String firstPart="";
                for (int i=0; i<parts.length-1; i++)
                    firstPart += parts[i]+File.separator;
                if (nameToLoad.endsWith(firstPart))
                    filename = parts[parts.length-1];
                
            }            
            nameToLoad+=filename;
            
            boolean hasFramePointer = true;
            if (currentProject != null)
            {
                if (currentProject.getIsPeerCProject())
                {
                    String flags = currentProject.getCFLAGS();
                    if (flags.contains("-fomit-frame-pointer"))
                        hasFramePointer = false;
                }
            }
            

            File f = new File(nameToLoad);
            if (!f.exists())
            {
                nameToLoad = Global.mainPathPrefix+"C"+File.separator+"include"+File.separator+filename;
                if (inProject)
                {
                    if (currentProject.getIsPeerCProject())
                    {
//                        if (hasFramePointer)
                            nameToLoad = Global.mainPathPrefix+"C"+File.separator+"PeerC"+File.separator+"vectrex"+File.separator+"include"+File.separator+filename;
//                        else
//                            nameToLoad = Global.mainPathPrefix+"C"+File.separator+"PeerC"+File.separator+"vectrex"+File.separator+"include.nf"+File.separator+filename;
                    }
                }
                f = new File(nameToLoad);
                if (!f.exists())
                {
                    if (inProject)
                    {
                        if (currentProject.getIsPeerCProject())
                        {
                            path = Global.mainPathPrefix+currentProject.projectPrefix;
                            nameToLoad = path+ File.separator+"include"+File.separator+filename;;
                        }
                    }
                    f = new File(nameToLoad);
                    if (!f.exists()) return;
                }
            }
            
            jumpToEdit(nameToLoad, 0);

            
            return;
        }
        
        
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
            nameToLoad=convertSeperator(nameToLoad);
            
            // check sub dirs
            if (File.separator.equals("\\"))
            {
                // Windows!!!!
                parts = filename.split("\\\\");
            }
            else
                parts = filename.split(File.separator);
            if (parts.length > 1)
            {
                String firstPart="";
                for (int i=0; i<parts.length-1; i++)
                    firstPart += parts[i]+File.separator;
                if (nameToLoad.endsWith(firstPart))
                    filename = parts[parts.length-1];
            }
            
            
            nameToLoad+=filename;
            jumpToEdit(nameToLoad, 0);
        }
        catch (Throwable e)
        {
        }
    }
    EditorPanel getEditor(String filename, boolean create)
    {
        String name = "edi";
        Path path = Paths.get(filename);
        name = path.getFileName().toString();
        
        int found = -1;
        for (int i=0; i < jTabbedPane1.getTabCount(); i++)
        {
            String tabName = jTabbedPane1.getTitleAt(i);
            if (tabName.equalsIgnoreCase(name))
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
        if (!create) return null;
        EditorPanel edi = addEditor(filename, true);
        oneTimeTab = null;
        return edi;
    }
    
    private void jumpToEdit(String filename, int lineNumber)
    {
        jumpToEdit(filename,  lineNumber, true);
    }
    private void jumpToEdit(String filename, int lineNumber, boolean addToHistory)
    {
        if (addToHistory)
            addHistory();
        EditorPanel edi = getEditor(filename, true);
        if (edi == null)
        {
            printError("Could not access editor for: \""+filename+"\"");
            return;
        }
        
        edi.goLine(lineNumber);
    }
    void clearASMOutput()
    {
        jEditorASMMessages.setText("");
        jEditorPaneASMListing.setText("");
    }   
    public void requestSearchFocus()
    {
        jTextFieldSearch.requestFocusInWindow();
        jTextFieldSearch.setSelectionStart(0);
        jTextFieldSearch.setSelectionEnd(jTextFieldSearch.getText().length());
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

    public void refreshTree()
    {
        fillTree(currentStartPath, true);        
    }
    void fillTree()
    {
        if (!projectLoaded)
        {
            jTree1.setModel(new DefaultTreeModel(null));
            root = null;
            return;
        }
        Path startpath = Paths.get(Global.mainPathPrefix,"codelib");
        fillTree(startpath);
    }
    void fillTree(Path startpath)
    {
        fillTree(startpath, false);
    }
    void fillTree(Path startpath, boolean refresh)
    {
        if (fileView)
        {
            fillTreeFiles();
            return;
        }
        if (!inProject) 
        {
            jTree1.setModel(new DefaultTreeModel(null));
            return;
        }
        currentStartPath = startpath;
        TreeEntry rootEntry = new TreeEntry(startpath);
        root = new DefaultMutableTreeNode(rootEntry);
        rootEntry.myNode = root;
        rootEntry.parentNode = null;
        addChildren(root);
        if (!refresh)
            jTree1.setModel(new DefaultTreeModel(root));
        else
        {
            
            StringBuilder sb = new StringBuilder();

            for(int i =0 ; i < jTree1.getRowCount(); i++){
                TreePath tp = jTree1.getPathForRow(i);
                if(jTree1.isExpanded(i)){
                    sb.append(tp.toString());
                    sb.append(",");
                }
            }
            jTree1.setModel(new DefaultTreeModel(root));
            
            String state = sb.toString();
            for(int i = 0 ; i<jTree1.getRowCount(); i++){
                TreePath tp = jTree1.getPathForRow(i);
                if(state.contains(tp.toString() )){
                    jTree1.expandRow(i);
                }             
            }
    
/*            
            List<TreePath> loEpanded = new ArrayList<>();        
            for(int i = 0; i <jTree1.getRowCount()-1; i++){            
                if(jTree1.getPathForRow(i).isDescendant(jTree1.getPathForRow(i+1))){
                    loEpanded.add(jTree1.getPathForRow(i));
                }
            }        
            jTree1.setModel(new DefaultTreeModel(root));
//            ((DefaultTreeModel) jTree1.getModel()).reload();        
            for(TreePath ot : loEpanded){
                jTree1.expandPath(ot);
            }
*/
        }
        if (!refresh)
        {
            if (currentProject != null)
            {
                if (currentProject.getIsPeerCProject())
                {


                    DefaultMutableTreeNode node = null; 

                    Enumeration enumeration= root.breadthFirstEnumeration(); 
                    while(enumeration.hasMoreElements()) 
                    {

                        node = (DefaultMutableTreeNode)enumeration.nextElement(); 
                        if("source".equals(node.getUserObject().toString())) 
                        {
                            TreeNode[] nodes = ((DefaultTreeModel) jTree1.getModel()).getPathToRoot(node);
                                TreePath tpath = new TreePath(nodes);
                                jTree1.scrollPathToVisible(tpath);

                                jTree1.getSelectionModel().setSelectionPath(tpath);
                                jTree1.expandPath(tpath);
                //                jTree1.setSelectionPath(tpath);

                                break;
                        } 
                    } 
                }
            }
        }

        
        
    }
    void fillTreeFiles()
    {
        Path startpath = Paths.get(Global.mainPathPrefix,"");
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
        Arrays.sort(fList, new Comparator<File>()
                {
                    @Override
                    public int compare(File f1, File f2)
                    {
                        if (f1 == null) return 1;
                        if (f2 == null) return -1;
                        if ((f1.isDirectory()) && (!f2.isDirectory())) return -1;
                        if ((f2.isDirectory()) && (!f1.isDirectory())) return 1;
                        return f1.getName().toLowerCase().compareTo(f2.getName().toLowerCase());
                    }
                });
                
        
        
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
        Arrays.sort(fList, new Comparator<File>()
                {
                    @Override
                    public int compare(File f1, File f2)
                    {
                        if (f1 == null) return 1;
                        if (f2 == null) return -1;
                        if ((f1.isDirectory()) && (!f2.isDirectory())) return -1;
                        if ((f2.isDirectory()) && (!f1.isDirectory())) return 1;
                        return f1.getName().toLowerCase().compareTo(f2.getName().toLowerCase());
                    }
                });
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
                settings.removeOpen(oldFileName);
                settings.addOpen(newFileName, edit.getPosition());
                updateList();
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
        
        
        Path base = Paths.get(Global.mainPathPrefix);
        Path fromPath = base.resolve(Paths.get(leaf.pathAndName.toString()));
        File ff = fromPath.toFile();
        if (ff.isDirectory())
        {
            log.addLog("Renaming of directories not allowed!", INFO);
            return;
        }
        
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
            asmInfo.replaceFileName(oldFileName, newFileName);
            cInfo.replaceFileName(oldFileName, newFileName);
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
                    settings.removeOpen(oldFileName);
                    settings.addOpen(newFileName, edit.getPosition());
                    
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
                String rel = de.malban.util.Utility.makeVideRelative(start);
                if (rel.length()>0) rel = rel + File.separator;
                FilePropertiesPool pool = new FilePropertiesPool(rel, filenameBaseOnly+"FileProperty.xml");
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
                    fileProperties.setFilename(de.malban.util.Utility.makeVideRelative(npathFull));
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
    private void loadProject(String mClass, String mName, String mPath)
    {
        // path is "home" relative
        String xmlFilename = de.malban.util.UtilityFiles.convertSeperator(mName);
        String ppath = de.malban.util.UtilityFiles.convertSeperator(mPath);
        if (ppath.endsWith(File.separator)) ppath = ppath.substring(0, ppath.length()-1);
        
        ProjectPropertiesPool pool = new ProjectPropertiesPool(ppath/*+mName+File.separator*/, mName+"ProjectProperty.xml");
        ProjectProperties project =  pool.get(mName);

        if (project == null) 
        {
            log.addLog("Project file not found: "+mName, WARN);
            return;
        }
        project.projectPrefix = ppath/*+mName*/;
        // set Tree to location
        inProject = true;
        currentProject = project;
        fillTree(Paths.get(de.malban.util.Utility.makeVideAbsolute(project.projectPrefix)));
//        fillTree(Paths.get(project.projectPrefix));
        
        settings.addProject(currentProject.getName(), currentProject.getCClass(), project.projectPrefix);
        settings.setCurrentProject(currentProject.getName(), currentProject.getCClass(), project.projectPrefix);
                
        // scan projects for vars
        String path = project.projectPrefix+File.separator;
                    
        for (int b = 0; b<currentProject.getNumberOfBanks(); b++)
        {
            String filenameASM = currentProject.getBankMainFiles().elementAt(b);
            if (filenameASM.length() == 0) continue;
            filenameASM = Global.mainPathPrefix+path+filenameASM;
            File test = new File(filenameASM);
            if (!test.exists())
            {
                continue; // allow empty names!
            }                

            asmInfo.handleFile(filenameASM, null);
        }
        if (currentProject.getIsPeerCProject())
        {
            String flags = currentProject.getCFLAGS();
            boolean hasFramePointer = true;
            if (flags.contains("-fomit-frame-pointer"))
                hasFramePointer = false;
            resetCScan(hasFramePointer);    
        }
                
                
        updateList();
    }
    private void doNewProject()
    {
        doNewProject(ProjectPropertiesPanel.showNewProjectProperties(), true);
    }
    private void doNewProject(ProjectProperties project, boolean askForDirDouble)
    {
        if (project == null) return; // cancel or error
        
        // try to create dir and save project properties
        String p1 = project.getOldPath();
        String p2 = project.getProjectName();
        Path p = Paths.get(Global.mainPathPrefix+p1,p2);
        project.projectPrefix = p1+File.separator+p2;
        if (project.projectPrefix.startsWith(File.separator)) project.projectPrefix = project.projectPrefix.substring(1);
        
        
        if (((p.toFile().exists()) ) && (askForDirDouble))
        {
//            JOptionPane pane = new JOptionPane("A directory \""+project.getProjectName()+"\"already exists, do you really want\nto use an existing diretcory for a new project?", JOptionPane.WARNING_MESSAGE, JOptionPane.OK_CANCEL_OPTION);
//            int answer = pane.setv JOptionPaneDialog.show(pane);


            
            int answer = JOptionPane.showOptionDialog(Configuration.getConfiguration().getMainFrame(), 
                    "A directory \""+project.getProjectName()+"\"already exists, do you really want\nto use an existing diretcory for a new project?",
                    "Directory exists",
                     JOptionPane.WARNING_MESSAGE, JOptionPane.OK_CANCEL_OPTION, null, null, null);
                    

            if (answer == JOptionPane.YES_OPTION)
                System.out.println("YES");
            else
            {
                System.out.println("NO");
                return;
            }
            
        }
        else
        {
            if (askForDirDouble)
            {
                // create dir
                File file = p.toAbsolutePath().toFile();

                
                boolean b = file.mkdir();
                if (!b)
                {
                JOptionPane.showMessageDialog(Configuration.getConfiguration().getMainFrame(), 
                "Failed to create directory!\n"+p.toAbsolutePath(),
                "Directory creation failed",
                 JOptionPane.ERROR_MESSAGE);

                //JOptionPane pane = new JOptionPane("Failed to create directory!\n"+p.toAbsolutePath(), JOptionPane.ERROR_MESSAGE, JOptionPane.CLOSED_OPTION);
                //    JOptionPaneDialog.show(pane);
                    return;
                }
            }
        }
        // dir created!
        // now save ProjectProperties!
        File xmlFile = new File(Global.mainPathPrefix+project.projectPrefix+File.separator+ project.getProjectName()+"ProjectProperty.xml");
        if (xmlFile.exists())
        {
//            JOptionPane pane = new JOptionPane("Projectfile already exists! \nNew project cancled!", JOptionPane.ERROR_MESSAGE, JOptionPane.CLOSED_OPTION);
//            JOptionPaneDialog.show(pane);
            
                JOptionPane.showMessageDialog(Configuration.getConfiguration().getMainFrame(), 
                "Projectfile already exists! \nNew project cancled!",
                "Projectfile already exists",
                 JOptionPane.ERROR_MESSAGE);
            
            
            return;
        }
        String poolName =  project.getProjectName()+"ProjectProperty.xml";
        
        ProjectPropertiesPool pool = new ProjectPropertiesPool(de.malban.util.Utility.makeVideRelative(p.toString())+File.separator,poolName);
        pool.put(project);
        pool.save();
        boolean shouldSave = false;

        // project file saved
        // now create new project [asm] file(s)
        if (project.getIsPeerCProject())
        {
            doCreatePeerCProject( project);
            return;
        }
        if (project.getcreateGameLoopCode())
        {
            if ((project.getBankswitching().equals("none")) || (!project.getcreateBankswitchCode()))
            {
                File asmFile = new File(de.malban.util.Utility.makeVideAbsolute(p.toString()+File.separator+ project.getMainFile()));
                if (asmFile.exists())
                {
//                    JOptionPane pane = new JOptionPane("The file:\""+project.getMainFile()+"\" already exists, do you really want\nto create a new file?\n\nAll previous data will be lost!", JOptionPane.WARNING_MESSAGE, JOptionPane.OK_CANCEL_OPTION);
//                    int answer = JOptionPaneDialog.show(pane);

                int answer = JOptionPane.showOptionDialog(Configuration.getConfiguration().getMainFrame(), 
                "The file:\""+project.getMainFile()+"\" already exists, do you really want\nto create a new file?\n\nAll previous data will be lost!",
                "File exists",
                JOptionPane.WARNING_MESSAGE, JOptionPane.OK_CANCEL_OPTION, null, null, null);


                    if (answer == JOptionPane.YES_OPTION)
                        System.out.println("YES");
                    else
                    {
                        System.out.println("NO");
                        return;
                    }
                }

                Path template = Paths.get(Global.mainPathPrefix, "template", "vectrexMain.template");
                de.malban.util.UtilityFiles.copyOneFile(template.toString(), asmFile.toString());
                Path include = Paths.get(Global.mainPathPrefix, "template", "VECTREX.I");
                File includeFile = new File(p.toString()+File.separator+ "VECTREX.I");
                de.malban.util.UtilityFiles.copyOneFile(include.toString(), includeFile.toString());

                addEditor(asmFile.toString(), true);      
                oneTimeTab = null;
            }
            else if (project.getBankswitching().contains("2 bank standard")) 
            {
                String name0 = project.getBankMainFiles().elementAt(0);
                String name1 = project.getBankMainFiles().elementAt(1);
                if ((name0 == null) || (name0.length()==0))
                {
                    name0 = "mainBank0.asm";
                    //File file = new File(p.toString()+File.separator+ name0);
                    //name0 = file.toString();
                    project.getBankMainFiles().setElementAt(name0, 0);
                    
                }
                if ((name1 == null) || (name1.length()==0))
                {
                    name1 = "mainBank1.asm";
                    //File file = new File(p.toString()+File.separator+ name1);
                    //name1 = file.toString();
                    project.getBankMainFiles().setElementAt(name1, 1);
                }

                Path template = Paths.get(Global.mainPathPrefix, "template", "bank0Main.template");
                de.malban.util.UtilityFiles.copyOneFile(template.toString(), p.toString()+File.separator+name0.toString());
                template = Paths.get(Global.mainPathPrefix, "template", "bank1Main.template");
                de.malban.util.UtilityFiles.copyOneFile(template.toString(), p.toString()+File.separator+name1.toString());
                
                
                Path include = Paths.get(Global.mainPathPrefix, "template", "VECTREX.I");
                de.malban.util.UtilityFiles.copyOneFile(include.toString(), p.toString()+File.separator+ "VECTREX.I");
                
                
            }
            else if (project.getBankswitching().contains("VecFlash")) 
            {
                for (int i=0; i< project.getNumberOfBanks(); i++)
                {
                    String name = project.getBankMainFiles().elementAt(i);
                    if ((name == null) || (name.length()==0))
                    {
                        name = "mainBank"+i+".asm";
                        //File file = new File(p.toString()+File.separator+ name0);
                        //name0 = file.toString();
                        project.getBankMainFiles().setElementAt(name, i);
                    }
                    Path template = Paths.get(Global.mainPathPrefix, "template", "vecflashBankXMain.template");
                    
                    
                    String bankMain = de.malban.util.UtilityString.readTextFileToOneString(new File(template.toString()));
                    bankMain = de.malban.util.UtilityString.replace(bankMain,"3+1", ""+project.getNumberOfBanks()+"+1");
                    bankMain = de.malban.util.UtilityString.replace(bankMain,"BANK 0", "BANK "+i);
                    bankMain = de.malban.util.UtilityString.replace(bankMain,"Bank 0", "Bank "+i);
                    de.malban.util.UtilityFiles.createTextFile(p.toString()+File.separator+name.toString(), bankMain);

                    
                    
                }
                Path include = Paths.get(Global.mainPathPrefix, "template", "VECTREX.I");
                de.malban.util.UtilityFiles.copyOneFile(include.toString(), p.toString()+File.separator+ "VECTREX.I");
                Path flashi = Paths.get(Global.mainPathPrefix, "template", "vecflash_bs.i");
                de.malban.util.UtilityFiles.copyOneFile(flashi.toString(),p.toString()+File.separator+ "vecflash_bs.i");
            }
            else if (project.getBankswitching().contains("4 bank PB6/IRQ")) 
            {
                project.getBankMainFiles().setElementAt("mainBank0.asm", 0);
                project.getBankMainFiles().setElementAt("mainBank1.asm", 1);
                project.getBankMainFiles().setElementAt("mainBank2.asm", 2);
                project.getBankMainFiles().setElementAt("mainBank3.asm", 3);

                de.malban.util.UtilityFiles.copyOneFile(Paths.get(Global.mainPathPrefix, "template", "mainBank0.asm").toString(), p.toString()+File.separator+ "mainBank0.asm");
                de.malban.util.UtilityFiles.copyOneFile(Paths.get(Global.mainPathPrefix, "template", "mainBank1.asm").toString(), p.toString()+File.separator+ "mainBank1.asm");
                de.malban.util.UtilityFiles.copyOneFile(Paths.get(Global.mainPathPrefix, "template", "mainBank2.asm").toString(), p.toString()+File.separator+ "mainBank2.asm");
                de.malban.util.UtilityFiles.copyOneFile(Paths.get(Global.mainPathPrefix, "template", "mainBank3.asm").toString(), p.toString()+File.separator+ "mainBank3.asm");
                
                de.malban.util.UtilityFiles.copyOneFile(Paths.get(Global.mainPathPrefix, "template", "waitMacros.i").toString(), p.toString()+File.separator+ "waitMacros.i");
                de.malban.util.UtilityFiles.copyOneFile(Paths.get(Global.mainPathPrefix, "template", "macro.i").toString(), p.toString()+File.separator+ "macro.i");
                de.malban.util.UtilityFiles.copyOneFile(Paths.get(Global.mainPathPrefix, "template", "inAllBanks.i").toString(), p.toString()+File.separator+ "inAllBanks.i");
                de.malban.util.UtilityFiles.copyOneFile(Paths.get(Global.mainPathPrefix, "template", "commonGround.i").toString(), p.toString()+File.separator+ "commonGround.i");
                de.malban.util.UtilityFiles.copyOneFile(Paths.get(Global.mainPathPrefix, "template", "VECTREX.I").toString(), p.toString()+File.separator+ "VECTREX.I");
            }
                    
            shouldSave = true;
        }
        
        if ((project.getExtras() & Cartridge.FLAG_DS2430A) == Cartridge.FLAG_DS2430A)
        {
            Path include = Paths.get(Global.mainPathPrefix, "template", "VECTREX.I");
            de.malban.util.UtilityFiles.copyOneFile(include.toString(), p.toString()+File.separator+ "VECTREX.I");

            include = Paths.get(Global.mainPathPrefix, "template", "ds2430LowLevel.i");
            de.malban.util.UtilityFiles.copyOneFile(include.toString(), p.toString()+File.separator+ "ds2430LowLevel.i");
            include = Paths.get(Global.mainPathPrefix, "template", "ds2430HighLevel.i");
            de.malban.util.UtilityFiles.copyOneFile(include.toString(), p.toString()+File.separator+ "ds2430HighLevel.i");
            include = Paths.get(Global.mainPathPrefix, "template", "ds2430ExampleMain.template");
            de.malban.util.UtilityFiles.copyOneFile(include.toString(), p.toString()+File.separator+ "ds2430ExampleMain.asm");
            project.getBankMainFiles().setElementAt("ds2430ExampleMain.asm", 0);
        }
        if ((project.getExtras() & Cartridge.FLAG_DS2431) == Cartridge.FLAG_DS2431)
        {
            Path include = Paths.get(Global.mainPathPrefix, "template", "VECTREX.I");
            de.malban.util.UtilityFiles.copyOneFile(include.toString(), p.toString()+File.separator+ "VECTREX.I");

            include = Paths.get(Global.mainPathPrefix, "template", "ds2431LowLevel.i");
            de.malban.util.UtilityFiles.copyOneFile(include.toString(), p.toString()+File.separator+ "ds2431LowLevel.i");
            include = Paths.get(Global.mainPathPrefix, "template", "ds2431HighLevel.i");
            de.malban.util.UtilityFiles.copyOneFile(include.toString(), p.toString()+File.separator+ "ds2431HighLevel.i");
            include = Paths.get(Global.mainPathPrefix, "template", "ds2431ExampleMain.template");
            de.malban.util.UtilityFiles.copyOneFile(include.toString(), p.toString()+File.separator+ "ds2431ExampleMain.asm");
            project.getBankMainFiles().setElementAt("ds2431ExampleMain.asm", 0);
        }


        // set Tree to location
        inProject = true;
        fillTree(Paths.get(Global.mainPathPrefix+project.projectPrefix));
        
        // TODO all additional project stuff
        currentProject = project;
        if (shouldSave)
            saveProject(); // since files 
        settings.addProject(currentProject.getName(), currentProject.getCClass(), project.projectPrefix);
        settings.setCurrentProject(currentProject.getName(), currentProject.getCClass(), project.projectPrefix);

        updateList();

        File asmFile = new File(Global.mainPathPrefix+currentProject.projectPrefix+File.separator+ project.getMainFile());
        asmInfo.resetToProject(asmFile);
    }
    @Override
    public void processWord(String word)
    {
        EntityDefinition entity = null;
        if (currentProject != null)
        {
            if (!currentProject.getIsPeerCProject())
            {
                if (checkBIOSFile(word))
                {
                    return;
                }
            }
            if (currentProject.getIsPeerCProject())
            {
                if (entity == null)
                {
                    entity = cInfo.knownGlobalFunctions.get(word);
                }
            }
        }
        if (entity == null)
        {
            entity = asmInfo.knownGlobalVariables.get(word);
        }
        if (entity == null)
        {
            entity = asmInfo.knownGlobalMacros.get(word);        
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
        
        
        if (entity.getCFile()!=null)
            message.append("defined at: ").append(entity.getCFile().toString()).append("(").append(entity.getLineNumber()).append(")");
        else
            message.append("defined at: ").append(entity.getFile().toString()).append("(").append(entity.getLineNumber()).append(")");
        printMessage(message.toString());

        try
        {
            final String filename;
            
            if (entity.getCFile()!=null)
                filename = de.malban.util.UtilityFiles.convertSeperator(entity.getCFile().toString());
            else
                filename = de.malban.util.UtilityFiles.convertSeperator(entity.getFile().toString());

            if (filename.length()==0)return;
            final int line = entity.getLineNumber();
            SwingUtilities.invokeLater(new Runnable()
            {
                @Override
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
    private void addFileToProject(File f)
    {
        Path p = Paths.get(f.getAbsolutePath());
        String filename = p.getFileName().toString();
        de.malban.util.UtilityFiles.copyOneFile(f.getAbsolutePath(), Global.mainPathPrefix+currentProject.projectPrefix+File.separator+filename);
    }
    
    public void reDisplayAll()
    {
        for (int i=0; i<jTabbedPane1.getTabCount();i++)
        {
            if (jTabbedPane1.getComponentAt(i) instanceof EditorPanel)
            {
                EditorPanel ep = (EditorPanel) jTabbedPane1.getComponentAt(i);
                ep.reColorDirect();

            }
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
    private boolean saveProject()
    {
        if (!inProject) return false;
        if (currentProject == null) return false;
        // try to create dir and save project properties
        ProjectPropertiesPool pool = new ProjectPropertiesPool(currentProject.projectPrefix+File.separator, currentProject.getProjectName()+"ProjectProperty.xml");
        pool.put(currentProject);
        pool.save();
        return true;
    }
    private void doProjectProperties()
    {
        ProjectProperties project = ProjectPropertiesPanel.showEditProjectProperties(currentProject);
        if (project == null) return; // cancel or error
        currentProject = project;
        saveProject();
    }
    private void doFileProperties(TreeEntry te)
    {
        if (selectedTreeEntry==null) return; // how?
        if (selectedTreeEntry.pathAndName==null) return; // file not project?
         FilePropertiesPanel.showEditFileProperties(selectedTreeEntry.pathAndName.toString(), this);
    }
    void doBuildProject()
    {
        saveAll();
        if (currentProject.getIsCProject())
        {
            FilePeeper.peepsFound = 0;
            if (startTypeRun == START_TYPE_STOP)
            {
                String fname = getSelectedEditor().getFilename();
                if (fname == null) return;

                if (fname.toLowerCase().endsWith(".c"))
                {
                    doCCompilerSingleFile(fname);
                }
                return;
            }
            doBuildCProject();
            return;
        }
        if (currentProject.getIsPeerCProject())
        {
            FilePeeper.peepsFound = 0;
            doBuildPeerCProject();
            return;
        }
        
        if (startTypeRun == START_TYPE_STOP)
        {
            String fname = getSelectedEditor().getFilename();
            if (fname == null) return;
            startASM(fname);
            return;
        }
            
            
        
        
        // Build the complete project
        String preClass = currentProject.getProjectPreScriptClass();
        String preName = currentProject.getProjectPreScriptName();
        
        String p = currentProject.projectPrefix+ File.separator;
        String pathAbs = de.malban.util.Utility.makeVideAbsolute(p);
        
        
        
        ExecutionDescriptor ed = new ExecutionDescriptor(ED_TYPE_PROJECT_PRE, currentProject.getProjectName(), "", "VediPanel", pathAbs);
        boolean ok =  ScriptDataPanel.executeScript(preClass, preName, this, ed);
        if (!ok) return;
        clearASMOutput();
        startBuildProject();
    }
    public static String convertSeperator(String filename)
    {
        String ret = de.malban.util.UtilityString.replace(filename, "/", File.separator);
        ret = de.malban.util.UtilityString.replace(ret, "\\", File.separator);
        return ret;
    }
    boolean skipInternalProcessing(String videRelFilename)
    {
        File file = new File(videRelFilename);
        String fileNameOnly = file.getName();
        String fileNameBare = fileNameOnly;
        int li = videRelFilename.lastIndexOf(".");
        if (li>=0) 
            videRelFilename = videRelFilename.substring(0,li);
        
        String absFilename = de.malban.util.Utility.makeVideAbsolute(videRelFilename);
        File test = new File(absFilename+"FileProperty.xml");
        if (test.exists())
        {
            String pathOnly = test.getParent().toString();
            if (pathOnly.length()!=0) pathOnly+=File.separator;
            
            String relOnly = de.malban.util.Utility.makeVideRelative(pathOnly);
            if (relOnly.length()!=0) relOnly+=File.separator;
            
            FilePropertiesPool pool = new FilePropertiesPool(relOnly, test.getName());

            FileProperties fileProperties =  pool.get(fileNameOnly);
            if (fileProperties == null) return false;
            return fileProperties.getNoInternalProcessing();
        }
        
        return false;
    }    
    // get all the files from a directory
    String executeFileScripts(String type, String videRelPath)
    {
        String absPath = de.malban.util.Utility.makeVideAbsolute(videRelPath);
        File directory = new File(absPath);
        File[] fList = directory.listFiles();
        for (File file : fList) 
        {
            String fileNameOnly = file.getName();
            String fileNameBare = fileNameOnly;
            int li = fileNameOnly.lastIndexOf(".");
            if (li>=0) 
                fileNameBare = fileNameOnly.substring(0,li);
            if (absPath.length() != 0) absPath += File.separator;
            File test = new File(absPath+fileNameBare+"FileProperty.xml");
            if (test.exists())
            {
                String pathOnly = test.getParent().toString();
                if (pathOnly.length()!=0) pathOnly+=File.separator;
                
                String relPathOnly = de.malban.util.Utility.makeVideRelative(pathOnly);
                if (relPathOnly.length()!=0) relPathOnly+=File.separator;
                FilePropertiesPool pool = new FilePropertiesPool(relPathOnly, test.getName());

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
                if ((scriptClass.length()!=0)&& (scriptName.length()!=0))
                    if (!ScriptDataPanel.executeScript(scriptClass, scriptName, VediPanel.this, ed))
                        return file.getName();
            }
        }
        return null;
    }                           
    // start a thread for assembler
    public void startBuildProject()
    {
        if (asmStarted) return;
        asmStarted = true;
        jButtonAssemble.setEnabled(false);
        jButtonDebug.setEnabled(false);
        // paranoia!
        if (one != null) return;
        one = new Thread() 
        {
            public void run() 
            {
                boolean asmOk = true;
                boolean is48K = (currentProject.getExtras() & Cartridge.FLAG_48K) != 0;

                try
                {
                    String videRelPath = currentProject.projectPrefix;
                    
                    String pathAbs = de.malban.util.Utility.makeVideAbsolute(videRelPath);
//                    path = de.malban.util.Utility.makeVideRelative(pathAbs);
                            
                            
                    Asmj.resetReplacements(pathAbs);



                    // get all the files from a directory
                    final String failure = executeFileScripts("Pre", videRelPath);
                    if (failure!=null) 
                    {
                        if (!asmOk)
                        {
                            SwingUtilities.invokeLater(new Runnable()
                            {
                                public void run()
                                {
                                    printError("Error execute pre build script for: " + failure);
                                    buildProjectResult(false);
                                }
                            });                    
                            one = null;
                            jButtonAssemble.setEnabled(true);
                            jButtonDebug.setEnabled(true);
                            asmStarted = false;
                            return;
                        }
                    }
                    
                    boolean compiled = false;
                    // compile all
                    for (int b = 0; b<currentProject.getNumberOfBanks(); b++)
                    {
                        String filenameASM = currentProject.getBankMainFiles().elementAt(b);
                        // ensure name only
                        File f = new File(filenameASM);
                        filenameASM = f.getName();

                        if (filenameASM.length() == 0) continue;
                        filenameASM = videRelPath+File.separator+filenameASM;
                        String absFileName = de.malban.util.Utility.makeVideAbsolute(filenameASM);
                        
                        File test = new File(absFileName);
                        if (!test.exists())
                        {
                            continue; // allow empty names!
                        }
                        if (skipInternalProcessing(filenameASM))
                        {
                            String filename = currentProject.getBankMainFiles().elementAt(b);
                            filename = videRelPath+File.separator+filename;
                            int li = filename.lastIndexOf(".");
                            if (li>=0) 
                                filename = filename.substring(0,li);
                            String orgVideRel = filename + ".bin";
                            String bankedVideRel = filename+"_"+(b) + ".bin";
                            
                            String orgAbs = de.malban.util.Utility.makeVideAbsolute(orgVideRel);
                            String bankedAbs = de.malban.util.Utility.makeVideAbsolute(bankedVideRel);
                            
                            
                            File orgName = new File(orgAbs);
                            if (orgName.exists())
                            {
                                de.malban.util.UtilityFiles.move(orgAbs, bankedAbs);
                            }
                            continue;
                        }
                        
                        String define = currentProject.getBankDefines().elementAt(b);
                        printMessage("Assembling: "+absFileName);
                        Asmj asm = new Asmj(absFileName, asmErrorOut, null, null, asmMessagesOut, define, settings.allDebugComments,is48K);
                        
                        
                        
                        printASMList(asm.getListing(), ASM_LIST);

                        String info = asm.getInfo();
                        asmOk = info.indexOf("0 errors detected.") >=0;
                        if (!asmOk) break;
                        compiled = true;

                        
                        String filename = currentProject.getBankMainFiles().elementAt(b);
                        File ff = new File(filename);
                        filename = ff.getName(); // ensure name only
                        filename = videRelPath+File.separator+filename;
                        int li = filename.lastIndexOf(".");
                        if (li>=0) 
                            filename = filename.substring(0,li);
                        String org = filename + ".bin";
                        String banked = filename+"_"+(b) + ".bin";

                        String orgAbs = de.malban.util.Utility.makeVideAbsolute(org);
                        String bankedAbs = de.malban.util.Utility.makeVideAbsolute(banked);


                        de.malban.util.UtilityFiles.move(orgAbs, bankedAbs);
                        Asmj.binFileRename(orgAbs, bankedAbs);
                        
                        org = filename + ".cnt";
                        banked = filename+"_"+(b) + ".cnt";
                        
                        orgAbs = de.malban.util.Utility.makeVideAbsolute(org);
                        bankedAbs = de.malban.util.Utility.makeVideAbsolute(banked);
                        
                        
                        Vector<String> what = new Vector<String>();
                        Vector<String> with = new Vector<String>();
                        what.add("BANK 0");
                        with.add("BANK "+(b));
                        de.malban.util.UtilityString.replaceToNewFile(new File(orgAbs), new File(bankedAbs), what,with);
                        de.malban.util.UtilityFiles.deleteFile(orgAbs);
                        
                    }
                    if (!compiled)
                    {
                        SwingUtilities.invokeLater(new Runnable()
                        {
                            public void run()
                            {
                                printError("Nothing compiled, main not set? ");
                                buildProjectResult(false);
                            }
                        });                    
                        one = null;
                        jButtonAssemble.setEnabled(true);
                        jButtonDebug.setEnabled(true);
                        asmStarted = false;
                        return;
                        
                    }
                    
                    // get all the files from a directory
                    final String failure2 = executeFileScripts("Post", videRelPath);
                    if (failure2!=null) 
                    {
                        if (!asmOk)
                        {
                            SwingUtilities.invokeLater(new Runnable()
                            {
                                public void run()
                                {
                                    printError("Error execute post build script for: " + failure2);
                                    buildProjectResult(false);
                                }
                            });                    
                            one = null;
                            jButtonAssemble.setEnabled(true);
                            jButtonDebug.setEnabled(true);
                            asmStarted = false;
                            return;
                        }

                    }
                }
                catch (final Throwable e)
                {
                    SwingUtilities.invokeLater(new Runnable()
                    {
                        public void run()
                        {
                            printASMMessage("Exception while building: " + e.getMessage(), ASM_MESSAGE_ERROR);
                            printASMMessage(de.malban.util.Utility.getStackTrace(e), ASM_MESSAGE_ERROR);
                            buildProjectResult(false);
                        }
                    });   
                    one = null;
                    jButtonAssemble.setEnabled(true);
                    jButtonDebug.setEnabled(true);
                    asmStarted = false;
                    return;
                }
                if (!asmOk)
                {
                    SwingUtilities.invokeLater(new Runnable()
                    {
                        public void run()
                        {
                            buildProjectResult(false);
                        }
                    });                    
                    one = null;
                    jButtonAssemble.setEnabled(true);
                    jButtonDebug.setEnabled(true);
                    asmStarted = false;
                    return;
                }
                final boolean asmOk2 = asmOk; // effectivly final!
                Asmj.doReplacements();
                
                SwingUtilities.invokeLater(new Runnable()
                {
                    public void run()
                    {
                        buildProjectResult(asmOk2);
                    }
                });                    
                
                one = null;
                jButtonAssemble.setEnabled(true);
                jButtonDebug.setEnabled(true);
                asmStarted = false;
            }  
        };

        one.setName("Build: "+currentProject.getProjectName());
        one.start();           
    }            
        
    protected void buildProjectResult(boolean buildOk)
    {
        refreshTree();
        if (buildOk)
        {
            CartridgeProperties cartProp = buildCart(currentProject, true);
            checkVec4EverProject(cartProp);
            
            String postClass = currentProject.getProjectPostScriptClass();
            String postName = currentProject.getProjectPostScriptName();
            String pp = currentProject.projectPrefix;
            ExecutionDescriptor ed = new ExecutionDescriptor(ED_TYPE_PROJECT_POST, currentProject.getProjectName(), "", "VediPanel", pp);
            boolean ok =  ScriptDataPanel.executeScript(postClass, postName, VediPanel.this, ed);
            
            if (config.invokeEmulatorAfterAssembly)
            {
                VecXPanel vec = ((CSAMainFrame)mParent).getVecxy();
                // can be null if vec is fullscreen
                if (((CSAMainFrame)mParent).getInternalFrame(vec) != null)
                    ((CSAMainFrame)mParent).getInternalFrame(vec).toFront();

                boolean ask = false;
                if (startTypeRun == START_TYPE_INJECT)
                {
                    CartridgeProperties oldProp = vec.getCurrentCartProp();
                    if (oldProp == null) ask = true;
                    else
                    {
                        String myName = currentProject.getProjectName();
                        String oldName = oldProp.getCartName();
                        if (!oldName.equals(myName)) ask = true;
                    }
                }
        
                boolean doit = true;
                if (ask)
                {
//                    JOptionPane pane = new JOptionPane("The bin files appear to be not compatible, inject anyway?", JOptionPane.WARNING_MESSAGE, JOptionPane.OK_CANCEL_OPTION);
//                    int answer = JOptionPaneDialog.show(pane);
                    
                int answer = JOptionPane.showOptionDialog(Configuration.getConfiguration().getMainFrame(), 
                "The bin files appear to be not compatible, inject anyway?",
                "File not compatible",
                JOptionPane.WARNING_MESSAGE, JOptionPane.OK_CANCEL_OPTION, null, null, null);
                    
                    
                    if (answer == JOptionPane.YES_OPTION)
                        doit = true;
                    else
                    {
                        doit = false;
                    }
                }
                if (doit)
                {
                    vec.startCartridge(cartProp, startTypeRun);
                    printMessage("Assembly successfull, starting emulation...");
                }
            }
            else
            {
                printMessage("Assembly successfull...");
            }
            
            if (config.invokeVecMultiAfterAssembly) {
                loadVecMulti(cartProp);
            }
        }
        else
        {
            printError("Assembly not successfull, see ASM output...");
            jTabbedPane.setSelectedIndex(1);
        }
        refreshTree();
    }  
    
    private void loadVecMulti(CartridgeProperties cartProp)
    {
        SerialPort[] ports = SerialPort.getCommPorts();
        if (ports.length == 0) {
            printError("Failed to find any connected serial ports");
            return;
        }
        
        SerialPort port = ports[0];
        printMessage("Writing to serial port " + port.getDescriptivePortName() + "...");
        port.setComPortParameters(115200, 8, SerialPort.ONE_STOP_BIT, SerialPort.NO_PARITY);
        port.openPort();
        try {
            InputStream input = port.getInputStream();
            try (OutputStream output = port.getOutputStream()) {
                output.write('s');
                RandomAccessFile file = new RandomAccessFile(cartProp.getFullFilename().get(0), "r");
                byte[] bytes = new byte[(int)file.length()];
                file.readFully(bytes);
                file.close();
                
                for (int i = 0; i < bytes.length; i++) {
                    output.write('@');
                    output.write(bytes[i]);
                }
                output.write('y');
            }
            port.closePort();
            printMessage("VecMulti loading successful. Reset your Vectrex!");
        } catch (IOException e) {}
    }
        
    // expects relative file name
    // but under windows can be absolute nonetheless (other drive)
    boolean isProject(String filename)
    {
        if (!filename.toLowerCase().endsWith("projectproperty.xml")) 
        {
            log.addLog(filename + " is not a project file", INFO);
            return false;
        }
        String file = de.malban.util.UtilityString.readTextFileToOneString(new File (de.malban.util.Utility.makeVideAbsolute(filename) ));
        
        
        
        
        if (!file.contains("<AllProjectProperties>")) 
        {
            log.addLog(de.malban.util.Utility.makeVideAbsolute(filename) + " contains no project definition", INFO);
            return false;
        }
        
        // remove all file from editor
        closeAllEditors();
        
        String name = Paths.get(filename).getFileName().toString();
        name = name.substring(0, name.length()-("ProjectProperty.xml").length());
        
        // is project - load it!
        ProjectPropertiesPool pool = new ProjectPropertiesPool(Paths.get(de.malban.util.Utility.makeVideAbsolute(filename)).getParent().toString()+File.separator, Paths.get(de.malban.util.Utility.makeVideAbsolute(filename)).getFileName().toString());
        ProjectProperties project =  pool.get(name);
        currentProject = project;
 
        // set Tree to location
        inProject = true;
        File projectFile = new File (de.malban.util.Utility.makeVideAbsolute(filename ));
        currentProject.projectPrefix = de.malban.util.Utility.makeVideRelative(projectFile.getAbsolutePath());
        currentProject.projectPrefix = de.malban.util.UtilityString.replace(currentProject.projectPrefix, projectFile.getName(), "");
        if (currentProject.projectPrefix.endsWith(File.separator)) 
            currentProject.projectPrefix = currentProject.projectPrefix.substring(0, currentProject.projectPrefix.length()-1);
        
//        fillTree(Paths.get(Global.mainPathPrefix+convertSeperator(project.getPath()), project.getProjectName()));
        fillTree(Paths.get(de.malban.util.Utility.makeVideAbsolute(currentProject.projectPrefix)));
        
//        settings.addProject(currentProject.getName(), currentProject.getCClass(), project.getPath());
//        settings.setCurrentProject(currentProject.getName(), currentProject.getCClass(), project.getPath());
        settings.addProject(currentProject.getName(), currentProject.getCClass(), currentProject.projectPrefix);
        settings.setCurrentProject(currentProject.getName(), currentProject.getCClass(), currentProject.projectPrefix);
        updateList();

        Path p = Paths.get(de.malban.util.Utility.makeVideAbsolute(currentProject.projectPrefix));
        File asmFile = new File(p.toString()+File.separator+ project.getMainFile());

        asmInfo.resetToProject(asmFile);
        cInfo.resetToProject(asmFile);
        
        return true;
    }
    CartridgeProperties buildCart(ProjectProperties project, boolean banked)
    {
        CartridgeProperties cart = new CartridgeProperties();
        
//        String path = convertSeperator(project.getPath());
        String videRelpath = currentProject.projectPrefix;

        // vecxi expects relative
        
        
        if (banked)
        {
            for (int b = 0; b<project.getNumberOfBanks(); b++)
            {
                String filenameVideRel = project.getBankMainFiles().elementAt(b);
                if (project.getIsPeerCProject())
                {
                    filenameVideRel = "bin"+File.separator+filenameVideRel;
                    filenameVideRel = videRelpath+File.separator+filenameVideRel;
                }
                else
                {
                    if (!filenameVideRel.contains(File.separator))
                        filenameVideRel = videRelpath+File.separator+filenameVideRel;
                }

                int li = filenameVideRel.lastIndexOf(".");
                if (li>=0) 
                    filenameVideRel = filenameVideRel.substring(0,li);
                filenameVideRel = filenameVideRel+"_"+(b) + ".bin";
                
                String filenameAbs = de.malban.util.Utility.makeVideAbsolute(filenameVideRel);
                
                File test = new File(filenameAbs);
                if (!test.exists())
                {
                    cart.getFullFilename().add("");
                    continue;
                }
                cart.getFullFilename().add(filenameVideRel);
            }        
        }
        else
        {
            int b= 0;
            String filenameVideRel = project.getBankMainFiles().elementAt(b);
            
            if (project.getIsPeerCProject())
            {
                filenameVideRel = videRelpath+File.separator+"bin"+File.separator+project.getProjectName();
            }
            else
            {
                filenameVideRel = videRelpath+File.separator+project.getProjectName();
            }
            
//            int li = filename.lastIndexOf(".");
//            if (li>=0) 
//                filename = filename.substring(0,li);
            filenameVideRel = filenameVideRel+".bin";

            cart.getFullFilename().add(filenameVideRel);
        }
        cart.setCartName(project.getProjectName()); 
        cart.setAuthor(project.getAuthor()); 
        String bs = project.getBankswitching();
        int typeFlags = project.getExtras();;
        if (bs.equals("none"))
            ;
        else if (bs.contains("standard"))
        {
            typeFlags += Cartridge.FLAG_BANKSWITCH_DONDZILA;
        }
        else if (bs.contains("VecFlash"))
        {
            typeFlags += Cartridge.FLAG_BANKSWITCH_VECFLASH;
        }
        if ((typeFlags &Cartridge.FLAG_IMAGER )==  Cartridge.FLAG_IMAGER)
            cart.setWheelName(project.getWheelName());
        
        cart.setTypeFlags(typeFlags);

        
        return cart;
    }
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
        String fname = entry.pathAndName./*getFileName().*/toString();
        return tabExistsSwitch(fname);
    }
    // fname is the PATH to a file, relative or absolut
    boolean tabExistsSwitch(String fname)
    {
        int count = jTabbedPane1.getTabCount();
        
        String fn1 = de.malban.util.UtilityFiles.convertSeperator(de.malban.util.Utility.makeVideAbsolute(fname)).toLowerCase();
                
        for (int i=0; i< count; i++)
        {
            Component com = jTabbedPane1.getComponentAt(i);
            if (com instanceof EditorPanel)
            {
                EditorPanel edi = (EditorPanel) com;
                String fn2 = de.malban.util.UtilityFiles.convertSeperator(de.malban.util.Utility.makeVideAbsolute(edi.getFilename())).toLowerCase();
                
                
                if (fn1.equals(fn2))
                {
                    jTabbedPane1.setSelectedIndex(i);
                    return true;
                }
            }
        }

        return false;
    }
    
    boolean _old_tabExistsSwitch(String tabname)
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
        if (filenameOnly.toLowerCase().endsWith(".gif"))pic = true;
        if (filenameOnly.toLowerCase().endsWith(".jpg"))pic = true;
        if (filenameOnly.toLowerCase().endsWith(".png"))pic = true;
        if (filenameOnly.toLowerCase().endsWith(".bmp"))pic = true;
        if (!pic) 
        {
            printError("Selected entry does not have a known image extension!");
            return;
        }
        
        boolean done  = RasterPanel.showRasterPanel(pathFull);
        if (!done) return; // cancel or error
        refreshTree();
    }
    void doSample()
    {
        // check for a property file!
        String type ="";
        String pathFull ="";
        String pathOnly ="";
        String filenameOnly ="";
        String filenameBaseOnly ="";
        Path p = null;
        if (selectedTreeEntry != null)
        {
            p = Paths.get(selectedTreeEntry.pathAndName.toString());
        }
        else
        {
            if (inProject)
            {
                if (currentProject != null)
                {
                    p = Paths.get(de.malban.util.Utility.makeVideAbsolute(currentProject.projectPrefix));
                }
            }
        }
        if (p == null) return;
        
        pathFull = p.toString();
        if (p.toFile().isDirectory())
        {
            pathOnly = pathFull;
        }
        else
        {
            pathOnly = p.getParent().toString();
        }
        filenameOnly = p.getFileName().toString();
        boolean wav = false;
        if (filenameOnly.toLowerCase().endsWith(".wav")) wav = true;
        if (filenameOnly.toLowerCase().endsWith(".pcm")) wav = true;
        boolean done = false;
        if (!wav) 
            done  = SampleJPanel.showSamplePanel(pathOnly, false);
        else
            done  = SampleJPanel.showSamplePanel(pathFull, true);
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
    
    
    // 0 error, cancle
    // 1 = vecVox
    // 2 = vecVoice
    public void returnFromVecVoxPanel(int type)
    {
        if (type == 0) return; // cancel or error
        if ((currentProject == null) || (!projectLoaded))
        {
            printWarning("Voice files were built, but no project is active.");
            printWarning("Voice emulation in vecxi will not be active if run without a project!");
        }
        else
        {
            int extras = currentProject.getExtras();
            if (type == 1)
                extras = extras | Cartridge.FLAG_VEC_VOX;
            if (type == 2)
                extras = extras | Cartridge.FLAG_VEC_VOICE;
            currentProject.setExtras(extras);
            
        }

        refreshTree();
        
        scanTreeDirectory(selectedTreeEntry);
        // reload entries;
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
    void doAKS()
    {
        String type ="";
        String pathFull ="";
        String pathOnly ="";
        String filenameOnly ="";
        String filenameBaseOnly ="";
        Path p = Paths.get(selectedTreeEntry.pathAndName.toString());
        pathFull = p.toString();
        pathOnly = p.getParent().toString();
        if (pathOnly.length()>0)
            pathOnly+= File.separator;
        filenameOnly = p.getFileName().toString();
        boolean pic = false;
        if (filenameOnly.toLowerCase().endsWith(".bin")) pic = true;
        if (!pic) 
        {
            printError("Selected entry does not have a \"bin\" extension!");
            return;
        }
        filenameBaseOnly = filenameOnly.substring(0, filenameOnly.length()-4);
        AKSBin aksbin = new AKSBin();
        
        String id = GetIDValuePanel.showEnterValueDialog();
        
        String text = aksbin.buildData(pathFull, this, id);
        if (text.length() == 0) return;
        String targetFile = pathOnly+File.separator+filenameBaseOnly+"AKS.asm";
        de.malban.util.UtilityFiles.createTextFile(targetFile, text);
        
        boolean isPC = false;
        if (currentProject!= null)
        {
            isPC = currentProject.getIsPeerCProject();
        }
        
        
        if (!isPC)
        {
            String nameOnly = Paths.get(targetFile).getFileName().toString();
            String barenameOnly = nameOnly.substring(0, nameOnly.length()-4); 

            Path include = Paths.get(Global.mainPathPrefix, "template", "VECTREX.I");
            de.malban.util.UtilityFiles.copyOneFile(include.toString(), pathOnly+ "VECTREX.I");

            Path digital = Paths.get(Global.mainPathPrefix, "template", "arkosPlayer.i");
            de.malban.util.UtilityFiles.copyOneFile(digital.toString(), pathOnly+ "arkosPlayer.i");

            Path template = Paths.get(Global.mainPathPrefix, "template", "arkosPlayerMain.template");
            String exampleMain = de.malban.util.UtilityString.readTextFileToOneString(new File(template.toString()));

            exampleMain = de.malban.util.UtilityString.replace(exampleMain,"#AKS_DATA#", filenameBaseOnly+"AKS.asm");


            de.malban.util.UtilityFiles.createTextFile(pathOnly+filenameBaseOnly+"Main.asm", exampleMain);        
        }
        else
        {
            String pathSource = getProjectBase()+ File.separator+"source";
            convertToCASM(targetFile, true);
            de.malban.util.UtilityFiles.move(changeTypeTo(targetFile,"s"), pathSource+ File.separator+filenameBaseOnly+".s");

            
 
            String outName = pathSource+File.separator+filenameBaseOnly+".h";
            String body = "extern const void* "+"SongAddress"+id+";\n";
            de.malban.util.UtilityFiles.createTextFile(outName, body);
        }
        refreshTree();            
    }
    
    void doAYFX()
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
        if (pathOnly.length()>0)
            pathOnly+= File.separator;
        
        
        boolean isPC = false;
        if (currentProject != null)
        {
            isPC = currentProject.getIsPeerCProject();
        }
        
        
        filenameOnly = p.getFileName().toString();
        boolean pic = false;
        if (filenameOnly.toLowerCase().endsWith(".afx")) pic = true;
        if (!pic) 
        {
            printError("Selected entry does not have a known afx extension!");
            return;
        }
        filenameBaseOnly = filenameOnly.substring(0, filenameOnly.length()-4);
                
        if (isPC)
        {
            String targetFile = pathOnly+filenameBaseOnly+".c";
            if (!saveAYFXC(pathFull, targetFile))
            {
                printError("Could not generate c file from: "+pathFull);
                return;

            }
            String nameOnly = Paths.get(targetFile).getFileName().toString();
            String barenameOnly = nameOnly.substring(0, nameOnly.length()-2); // is a ".c", tehrefor a -2 must work!

            String pathSource = getProjectBase()+ File.separator+"source";
//            convertToCASM(targetFile, true);
            de.malban.util.UtilityFiles.move(targetFile, pathSource+ File.separator+barenameOnly+".c");
 
            
            
            
            String outName = pathSource+File.separator+barenameOnly+".h";
            String body = "extern const unsigned int "+barenameOnly+"_data[];\n";
            de.malban.util.UtilityFiles.createTextFile(outName, body);
        }
        else
        {
            String targetFile = pathOnly+filenameBaseOnly+".asm";
            if (!saveAYFX(pathFull, targetFile))
            {
                printError("Could not generate asm file from: "+pathFull);
                return;

            }
            String nameOnly = Paths.get(targetFile).getFileName().toString();
            String barenameOnly = nameOnly.substring(0, nameOnly.length()-4); // is a ".afx", tehrefor a -4 must work!

            
            Path include = Paths.get(Global.mainPathPrefix, "template", "VECTREX.I");
            de.malban.util.UtilityFiles.copyOneFile(include.toString(), pathOnly+ "VECTREX.I");
            Path digital = Paths.get(Global.mainPathPrefix, "template", "ayfxPlayer.i");
            de.malban.util.UtilityFiles.copyOneFile(digital.toString(), pathOnly+ "ayfxPlayer.i");

            Path template = Paths.get(Global.mainPathPrefix, "template", "ayfxPlayMain.template");
            String exampleMain = de.malban.util.UtilityString.readTextFileToOneString(new File(template.toString()));

            exampleMain = de.malban.util.UtilityString.replace(exampleMain,"#AYFX_DATA_ADDRESS#", barenameOnly+"_data");
            exampleMain = de.malban.util.UtilityString.replace(exampleMain,"#AYFX_DATA#", filenameBaseOnly+".asm");
            exampleMain = de.malban.util.UtilityString.replace(exampleMain,"#AYFX_NAME#", de.malban.util.UtilityString.onlyUpperASCII(filenameBaseOnly.toUpperCase()));


            de.malban.util.UtilityFiles.createTextFile(pathOnly+filenameBaseOnly+"Main.asm", exampleMain);        
        }

        
        refreshTree();            
    }
    public String getProjectBase()
    {
        if (currentProject==null) return "";
        return currentProject.projectPrefix;
    }
    boolean saveAYFX(String inFilename, String outFilename)
    {
        byte[] data;
        Path path = Paths.get(inFilename);
     
        String nameOnly = path.getFileName().toString();
        String barenameOnly = nameOnly.substring(0, nameOnly.length()-4); // is a ".afx", tehrefor a -4 must work!
        
        try
        {
            data = Files.readAllBytes(path);

            StringBuilder buf = new StringBuilder();
            int count = 0;
            
            buf.append("; AYFX - Data of file: \""+inFilename+"\"\n");
            buf.append(""+barenameOnly+"_data:\n");
            for (int i=0; i< data.length;i++)
            {
                if (count == 0)
                {
                    buf.append(" DB ");
                }
                else
                {
                    buf.append(", ");

                }
                buf.append(String.format("$%02X",data[i] ));
                count++;
                if (count == 10)
                {
                    count =0;
                    buf.append("\n" );
                }
            }
            de.malban.util.UtilityFiles.createTextFile(outFilename, buf.toString());
        
        }
        catch (Throwable e)
        {
            log.addLog(e, WARN);
            return false;
        }
        return true;
    }
    boolean saveAYFXC(String inFilename, String outFilename)
    {
        byte[] data;
        Path path = Paths.get(inFilename);
     
        String nameOnly = path.getFileName().toString();
        String barenameOnly = nameOnly.substring(0, nameOnly.length()-4); // is a ".afx", tehrefor a -4 must work!
        
        try
        {
            data = Files.readAllBytes(path);

            StringBuilder buf = new StringBuilder();
            int count = 0;

            buf.append("// AYFX - Data of file: \""+inFilename+"\"\n");
            buf.append("const unsigned int "+barenameOnly+"_data").append("[]=\n{\n");
            for (int i=0; i< data.length;i++)
            {
                if (count == 0)
                {
                    buf.append("\t");
                }
                else
                {
                    buf.append("");
                }
                buf.append(String.format("0x%02X, ",data[i] ));
                count++;
                if (count == 10)
                {
                    count =0;
                    buf.append("\n" );
                }
            }
            buf.append("\n};\n");
            de.malban.util.UtilityFiles.createTextFile(outFilename, buf.toString());
        
        }
        catch (Throwable e)
        {
            log.addLog(e, WARN);
            return false;
        }
        return true;
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
        if (filenameOnly.toLowerCase().endsWith(".gif"))pic = true;
        if (filenameOnly.toLowerCase().endsWith(".jpg"))pic = true;
        if (filenameOnly.toLowerCase().endsWith(".png"))pic = true;
        if (filenameOnly.toLowerCase().endsWith(".bmp"))pic = true;
        if (!pic) 
        {
            printError("Selected entry does not have a known image extension!");
            return;
        }
        
        VectorJPanel.showModPanelNoModal(pathFull, this);
    }
    private static HashMap<String, String> biosMap = null;
    public static boolean checkBIOS(String word)
    {
        if (biosMap == null)
        {
            biosMap = new HashMap<String,String>();
            biosMap.put("Abs_a_b", "F584");
            biosMap.put("Abs_b", "F58B");
            biosMap.put("Add_Score_a", "F85E");
            biosMap.put("Add_Score_d", "F87C");
            biosMap.put("Bitmask_a", "F57E");
            biosMap.put("Check0Ref", "F34F");
            biosMap.put("Clear_C8_RAM", "F542");
            biosMap.put("Clear_Score", "F84F");
            biosMap.put("Clear_Sound", "F272");
            biosMap.put("Clear_x_256", "F545");
            biosMap.put("Clear_x_b", "F53F");
            biosMap.put("Clear_x_b_80", "F550");
            biosMap.put("Clear_x_b_a", "F552");
            biosMap.put("Clear_x_d", "F548");
            biosMap.put("Cold_Start", "F000");
            biosMap.put("Compare_Score", "F8C7");
            biosMap.put("Dec_3_Counters", "F55A");
            biosMap.put("Dec_6_Counters", "F55E");
            biosMap.put("Dec_Counters", "F563");
            biosMap.put("Delay_0", "F579");
            biosMap.put("Delay_1", "F575");
            biosMap.put("Delay_2", "F571");
            biosMap.put("Delay_3", "F56D");
            biosMap.put("Delay_b", "F57A");
            biosMap.put("Delay_RTS", "F57D");
            biosMap.put("Display_Option", "F835");
            biosMap.put("Do_Sound", "F289");
            biosMap.put("Do_Sound_x", "F28C");
            biosMap.put("Dot_d", "F2C3");
            biosMap.put("Dot_here", "F2C5");
            biosMap.put("Dot_ix_b", "F2BE");
            biosMap.put("Dot_ix", "F2C1");
            biosMap.put("Dot_List", "F2D5");
            biosMap.put("Dot_List_Reset", "F2DE");
            biosMap.put("DP_to_C8", "F1AF");
            biosMap.put("DP_to_D0", "F1AA");
            biosMap.put("Draw_Grid_VL", "FF9F");
            biosMap.put("Draw_Line_d", "F3DF");
            biosMap.put("Draw_Pat_VL", "F437");
            biosMap.put("Draw_Pat_VL_a", "F434");
            biosMap.put("Draw_Pat_VL_d", "F439");
            biosMap.put("Draw_VL", "F3DD");
            biosMap.put("Draw_VL_a", "F3DA");
            biosMap.put("Draw_VL_ab", "F3D8");
            biosMap.put("Draw_VL_b", "F3D2");
            biosMap.put("Draw_VL_mode", "F46E");
            biosMap.put("Draw_VLc", "F3CE");
            biosMap.put("Draw_VLcs", "F3D6");
            biosMap.put("Draw_VLp", "F410");
            biosMap.put("Draw_VLp_7F", "F408");
            biosMap.put("Draw_VLp_b", "F40E");
            biosMap.put("Draw_VLp_FF", "F404");
            biosMap.put("Draw_VLp_scale", "F40C");
            biosMap.put("Explosion_Snd", "F92E");
            biosMap.put("Get_Rise_Idx", "F5D9");
            biosMap.put("Get_Run_Idx", "F5DB");
            biosMap.put("Init_Music", "F68D");
            biosMap.put("Init_Music_Buf", "F533");
            biosMap.put("Init_Music_chk", "F687");
            biosMap.put("Init_Music_dft", "F692");
            biosMap.put("Init_OS", "F18B");
            biosMap.put("Init_OS_RAM", "F164");
            biosMap.put("Init_VIA", "F14C");
            biosMap.put("Intensity_1F", "F29D");
            biosMap.put("Intensity_3F", "F2A1");
            biosMap.put("Intensity_5F", "F2A5");
            biosMap.put("Intensity_7F", "F2A9");
            biosMap.put("Intensity_a", "F2AB");
            biosMap.put("Joy_Analog", "F1F5");
            biosMap.put("Joy_Digital", "F1F8");
            biosMap.put("Mov_Draw_VL", "F3BC");
            biosMap.put("Mov_Draw_VL_ab", "F3B7");
            biosMap.put("Mov_Draw_VL_a", "F3B9");
            biosMap.put("Mov_Draw_VL_d", "F3BE");
            biosMap.put("Mov_Draw_VLc_a", "F3AD");
            biosMap.put("Mov_Draw_VLc_b", "F3B1");
            biosMap.put("Mov_Draw_VLcs", "F3B5");
            biosMap.put("Move_Mem_a", "F683");
            biosMap.put("Move_Mem_a_1", "F67F");
            biosMap.put("Moveto_d", "F312");
            biosMap.put("Moveto_d_7F", "F2FC");
            biosMap.put("Moveto_ix", "F310");
            biosMap.put("Moveto_ix_7F", "F30C");
            biosMap.put("Moveto_ix_b", "F30E");
            biosMap.put("Moveto_ix_FF", "F308");
            biosMap.put("Moveto_x_7F", "F2F2");
            biosMap.put("New_High_Score", "F8D8");
            biosMap.put("Obj_Hit", "F8FF");
            biosMap.put("Obj_Will_Hit", "F8F3");
            biosMap.put("Obj_Will_Hit_u", "F8E5");
            biosMap.put("Print_Str_d", "F37A");
            biosMap.put("Print_List", "F38A");
            biosMap.put("Print_List_chk", "F38C");
            biosMap.put("Print_List_hw", "F385");
            biosMap.put("Print_Ships_x", "F391");
            biosMap.put("Print_Ships", "F393");
            biosMap.put("Print_Str", "F495");
            biosMap.put("Print_Str_hwyx", "F373");
            biosMap.put("Print_Str_yx", "F378");
            biosMap.put("Random", "F517");
            biosMap.put("Random_3", "F511");
            biosMap.put("Read_Btns_Mask", "F1B4");
            biosMap.put("Read_Btns", "F1BA");
            biosMap.put("Recalibrate", "F2E6");
            biosMap.put("Reset_Pen", "F35B");
            biosMap.put("Reset0Int", "F36B");
            biosMap.put("Reset0Ref", "F354");
            biosMap.put("Reset0Ref_D0", "F34A");
            biosMap.put("Rise_Run_Angle", "F593");
            biosMap.put("Rise_Run_Idx", "F5EF");
            biosMap.put("Rise_Run_Len", "F603");
            biosMap.put("Rise_Run_X", "F5FF");
            biosMap.put("Rise_Run_Y", "F601");
            biosMap.put("Rot_VL", "F616");
            biosMap.put("Rot_VL_ab", "F610");
            biosMap.put("Rot_VL_M_dft", "F62B");
            biosMap.put("Rot_VL_Mode", "F61F");
            biosMap.put("Select_Game", "F7A9");
            biosMap.put("Set_Refresh", "F1A2");
            biosMap.put("Sound_Byte", "F256");
            biosMap.put("Sound_Byte_x", "F259");
            biosMap.put("Sound_Byte_raw", "F25B");
            biosMap.put("Sound_Bytes", "F27D");
            biosMap.put("Sound_Bytes_x", "F284");
            biosMap.put("Strip_Zeros", "F8B7");
            biosMap.put("Wait_Recal", "F192");
            biosMap.put("Warm_Start", "F06C");
            biosMap.put("Xform_Rise", "F663");
            biosMap.put("Xform_Rise_a", "F661");
            biosMap.put("Xform_Run", "F65D");
            biosMap.put("Xform_Run_a", "F65B");
        }
        String target = biosMap.get(word);
        if (target != null)
        {
//            String path = "help"+File.separator+"bios.htm#"+target;
//            QuickHelpTopFrame.showHelpHtmlFile(path);
//            invokeSystemFile(pfile);
            return false;
        }
        return false;
    }
    private static HashMap<String, Integer> biosFileMap = null;
    public boolean checkBIOSFile(String word)
    {
        if (biosFileMap == null)
        {
            biosFileMap = new HashMap<String,Integer>();
            biosFileMap.put("Abs_a_b", 2038);
            biosFileMap.put("Abs_b", 2038);
            biosFileMap.put("Add_Score_a", 2765);
            biosFileMap.put("Add_Score_d", 2765);
            biosFileMap.put("Bitmask_a", 2021);
            biosFileMap.put("Check0Ref", 985);
            biosFileMap.put("Clear_C8_RAM", 1889);
            biosFileMap.put("Clear_Score", 2744);
            biosFileMap.put("Clear_Sound", 594);
            biosFileMap.put("Clear_x_256", 1901);
            biosFileMap.put("Clear_x_b", 1873);
            biosFileMap.put("Clear_x_b_80", 1920);
            biosFileMap.put("Clear_x_b_a", 1920);
            biosFileMap.put("Clear_x_d", 1901);
            biosFileMap.put("Cold_Start", 29);
            biosFileMap.put("Compare_Score", 2851);
            biosFileMap.put("Dec_3_Counters", 1945);
            biosFileMap.put("Dec_6_Counters", 1945);
            biosFileMap.put("Dec_Counters", 1965);
            biosFileMap.put("Delay_0", 1986);
            biosFileMap.put("Delay_1", 1986);
            biosFileMap.put("Delay_2", 1986);
            biosFileMap.put("Delay_3", 1986);
            biosFileMap.put("Delay_b", 1986);
            biosFileMap.put("Delay_RTS", 1986);
            biosFileMap.put("Display_Option", 2711);
            biosFileMap.put("Do_Sound", 644);
            biosFileMap.put("Do_Sound_x", 644);
            biosFileMap.put("Dot_d", 732);
            biosFileMap.put("Dot_here", 748);
            biosFileMap.put("Dot_ix_b", 711);
            biosFileMap.put("Dot_ix", 711);
            biosFileMap.put("Dot_List", 767);
            biosFileMap.put("Dot_List_Reset", 794);
            biosFileMap.put("DP_to_C8", 365);
            biosFileMap.put("DP_to_D0", 351);
            biosFileMap.put("Draw_Grid_VL", 3307);
            biosFileMap.put("Draw_Line_d", 1461);
            biosFileMap.put("Draw_Pat_VL", 1623);
            biosFileMap.put("Draw_Pat_VL_a", 1623);
            biosFileMap.put("Draw_Pat_VL_d", 1623);
            biosFileMap.put("Draw_VL", 1441);
            biosFileMap.put("Draw_VL_a", 1421);
            biosFileMap.put("Draw_VL_ab", 1404);
            biosFileMap.put("Draw_VL_b", 1360);
            biosFileMap.put("Draw_VL_mode", 1688);
            biosFileMap.put("Draw_VLc", 1339);
            biosFileMap.put("Draw_VLcs", 1380);
            biosFileMap.put("Draw_VLp", 1581);
            biosFileMap.put("Draw_VLp_7F", 1497);
            biosFileMap.put("Draw_VLp_b", 1555);
            biosFileMap.put("Draw_VLp_FF", 1497);
            biosFileMap.put("Draw_VLp_scale", 1528);
            biosFileMap.put("Explosion_Snd", 2995);
            biosFileMap.put("Get_Rise_Idx", 2127);
            biosFileMap.put("Get_Run_Idx", 2127);
            biosFileMap.put("Init_Music", 2411);
            biosFileMap.put("Init_Music_Buf", 1857);
            biosFileMap.put("Init_Music_chk", 2411);
            biosFileMap.put("Init_Music_dft", 2411);
            biosFileMap.put("Init_OS", 292);
            biosFileMap.put("Init_OS_RAM", 262);
            biosFileMap.put("Init_VIA", 239);
            biosFileMap.put("Intensity_1F", 671);
            biosFileMap.put("Intensity_3F", 671);
            biosFileMap.put("Intensity_5F", 671);
            biosFileMap.put("Intensity_7F", 671);
            biosFileMap.put("Intensity_a", 671);
            biosFileMap.put("Joy_Analog", 466);
            biosFileMap.put("Joy_Digital", 466);
            biosFileMap.put("Mov_Draw_VL", 1304);
            biosFileMap.put("Mov_Draw_VL_b", 1236);
            biosFileMap.put("Mov_Draw_VL_ab", 1281);
            biosFileMap.put("Mov_Draw_VL_a", 1281);
            biosFileMap.put("Mov_Draw_VL_d", 1304);
            biosFileMap.put("Mov_Draw_VLc_a", 1214);
            biosFileMap.put("Mov_Draw_VLcs", 1260);
            biosFileMap.put("Move_Mem_a", 2385);
            biosFileMap.put("Move_Mem_a_1", 2385);
            biosFileMap.put("Moveto_d", 926);
            biosFileMap.put("Moveto_d_7F", 865);
            biosFileMap.put("Moveto_ix", 909);
            biosFileMap.put("Moveto_ix_7F", 885);
            biosFileMap.put("Moveto_ix_b", 885);
            biosFileMap.put("Moveto_ix_FF", 885);
            biosFileMap.put("Moveto_x_7F", 840);
            biosFileMap.put("New_High_Score", 2882);
            biosFileMap.put("Obj_Hit", 2945);
            biosFileMap.put("Obj_Will_Hit", 2905);
            biosFileMap.put("Obj_Will_Hit_u", 2905);
            biosFileMap.put("Print_Str_d", 1094);
            biosFileMap.put("Print_List", 1145);
            biosFileMap.put("Print_List_chk", 1145);
            biosFileMap.put("Print_List_hw", 1121);
            biosFileMap.put("Print_Ships_x", 1177);
            biosFileMap.put("Print_Ships", 1177);
            biosFileMap.put("Print_Str", 1739);
            biosFileMap.put("Print_Str_hwyx", 1054);
            biosFileMap.put("Print_Str_yx", 1075);
            biosFileMap.put("Random", 1822);
            biosFileMap.put("Random_3", 1822);
            biosFileMap.put("Read_Btns_Mask", 380);
            biosFileMap.put("Read_Btns", 380);
            biosFileMap.put("Recalibrate", 824);
            biosFileMap.put("Reset_Pen", 1018);
            biosFileMap.put("Reset0Int", 1037);
            biosFileMap.put("Reset0Ref", 1001);
            biosFileMap.put("Reset0Ref_D0", 971);
            biosFileMap.put("Rise_Run_Angle", 2067);
            biosFileMap.put("Rise_Run_Idx", 2173);
            biosFileMap.put("Rise_Run_Len", 2197);
            biosFileMap.put("Rise_Run_X", 2197);
            biosFileMap.put("Rise_Run_Y", 2197);
            biosFileMap.put("Rot_VL", 2235);
            biosFileMap.put("Rot_VL_ab", 2235);
            biosFileMap.put("Rot_VL_M_dft", 2269);
            biosFileMap.put("Rot_VL_Mode", 2269);
            biosFileMap.put("Select_Game", 2600);
            biosFileMap.put("Set_Refresh", 331);
            biosFileMap.put("Sound_Byte", 558);
            biosFileMap.put("Sound_Byte_x", 558);
            biosFileMap.put("Sound_Byte_raw", 558);
            biosFileMap.put("Sound_Bytes", 612);
            biosFileMap.put("Sound_Bytes_x", 612);
            biosFileMap.put("Strip_Zeros", 2830);
            biosFileMap.put("Wait_Recal", 309);
            biosFileMap.put("Warm_Start", 99);
            biosFileMap.put("Xform_Rise", 2349);
            biosFileMap.put("Xform_Rise_a", 2349);
            biosFileMap.put("Xform_Run", 2328);
            biosFileMap.put("Xform_Run_a", 2328);
        }
        Integer target = biosFileMap.get(word);
        if (target != null)
        {
            String to = Global.mainPathPrefix+"tmp"+File.separator+"BIOS.ASM";
            File biosFile = new File(to);
            if (!biosFile.exists())
            {
                String from = Global.mainPathPrefix+"codelib"+File.separator+"Originals"+File.separator+"BIOS - Bruce Tomlin"+File.separator+"BIOS.ASM";
                de.malban.util.UtilityFiles.copyOneFile(from, to);
            }
            try
            {
                SwingUtilities.invokeLater(new Runnable()
                {
                    public void run()
                    {
                        jumpToEdit(to, target);
                    }
                });                    
            }
            catch (Throwable e)
            {

            }        
        return true;
        }
        return false;
    }

    
    public static boolean displayHelp(String h)
    {
        h = h.toLowerCase();
        String path = Global.mainPathPrefix+"help"+File.separator;
        
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
    
    public static boolean openInVedi(String path)
    {
        VediPanel vp = ((CSAMainFrame)Configuration.getConfiguration().getMainFrame()).getVedi(true);
        vp.closeProject();
        vp.addEditor(path, false);
        return true;
    }
    

    void checkVec4Ever(boolean verbose)
    {
        boolean available = settings.v4eEnabled;
        if (settings.v4eEnabled)
        {
            available = checkVec4EverVolume(verbose);
        }
        else
        {
            jLabel10.setForeground(defaultForegroundColor);
        }
        jTextFieldPath.setEnabled(settings.v4eEnabled);
        jButtonFileSelect1.setEnabled(settings.v4eEnabled);
        jButtonCheckVec4Ever.setEnabled(settings.v4eEnabled);
        jButtonEjectVecForever.setEnabled(available);
        jLabel10.setEnabled(settings.v4eEnabled);
    }    
    public boolean checkVec4EverVolume(boolean verbose)
    {
        if (!settings.v4eEnabled)
        {
            return false;
        }
        try
        {
            Path path = Paths.get(settings.v4eVolumeName);
            File directory = path.toFile();

            // get all the files from a directory
            File[] fList = directory.listFiles();
            // sanitiy check for "README.TXT" on top level
            if (fList != null)
            {
                for (File file : fList) 
                {
                    if (file.getName().contains("README.TXT"))
                    {
                        String readmetxt = de.malban.util.UtilityString.readTextFileToOneString(file);
                        if (readmetxt.contains("Sontowski"))
                        {
                            jLabel10.setForeground(Color.green);
                            if (verbose)
                                printMessage("V4E: RAM DISK volume found.");
                            return true; 
                        }
                    }

                }
            }
            
        }
        catch (Throwable e)
        {
            if (verbose)
                printError("V4E: RAM DISK volume not found.");
        }
        jLabel10.setForeground(Color.black);
        return false;
    }
    void ejectVec4Ever()
    {
        boolean available = checkVec4EverVolume(false);
        if (!available)
        {
            jLabel10.setForeground(Color.red);
            return;
        }
        boolean ok = de.malban.util.UtilityFiles.ejectVolume(settings.v4eVolumeName);
        if (!ok)
        {
            printError("V4E: RAM DISK not ejected");
            jLabel10.setForeground(Color.red);
        }
        else
        {
            printMessage("V4E: RAM DISK ejected");
            jLabel10.setForeground(Color.black);
        }
    }

    void checkVec4EverProject(CartridgeProperties cart)
    {
        try
        {
            // if there are TWO main files (2 banks)
            // concatinate the two
            if (cart.getFullFilename().size() == 2)
            {
                boolean is48K = (currentProject.getExtras() & Cartridge.FLAG_48K) != 0;
                int memSize = 32768;
                if (is48K) memSize+=32768;
                
                String newFilename = de.malban.util.Utility.makeVideAbsolute(cart.getFullFilename().elementAt(0).substring(0,cart.getFullFilename().elementAt(0).length()-1-4));
                String n1 = de.malban.util.Utility.makeVideAbsolute(cart.getFullFilename().elementAt(0));
                String n2 = de.malban.util.Utility.makeVideAbsolute(cart.getFullFilename().elementAt(1));
                de.malban.util.UtilityFiles.padFile(n1, (byte)0xff, memSize);
                de.malban.util.UtilityFiles.padFile(n2, (byte)0xff, memSize);
                n1 += ".fil";
                n2 += ".fil";
                de.malban.util.UtilityFiles.concatFiles(n1, n2);
                checkVec4EverFile(n1+".con");
            }
            if (cart.getFullFilename().size() == 4)
            {
                boolean is48K = (currentProject.getExtras() & Cartridge.FLAG_48K) != 0;
                int memSize = 32768;
                if (is48K) memSize+=32768;
                
                String newFilename = de.malban.util.Utility.makeVideAbsolute(cart.getFullFilename().elementAt(0).substring(0,cart.getFullFilename().elementAt(0).length()-1-4));
                String n1 = de.malban.util.Utility.makeVideAbsolute(cart.getFullFilename().elementAt(0));
                String n2 = de.malban.util.Utility.makeVideAbsolute(cart.getFullFilename().elementAt(1));
                String n3 = de.malban.util.Utility.makeVideAbsolute(cart.getFullFilename().elementAt(2));
                String n4 = de.malban.util.Utility.makeVideAbsolute(cart.getFullFilename().elementAt(3));
                de.malban.util.UtilityFiles.padFile(n1, (byte)0xff, memSize);
                de.malban.util.UtilityFiles.padFile(n2, (byte)0xff, memSize);
                de.malban.util.UtilityFiles.padFile(n3, (byte)0xff, memSize);
                de.malban.util.UtilityFiles.padFile(n4, (byte)0xff, memSize);
                n1 += ".fil";
                n2 += ".fil";
                n3 += ".fil";
                n4 += ".fil";
                de.malban.util.UtilityFiles.concatFiles(n1, n2);
                de.malban.util.UtilityFiles.concatFiles(n3, n4);
                de.malban.util.UtilityFiles.concatFiles(n1+".con", n3+".con");
                de.malban.util.UtilityFiles.rename(n1+".con"+".con", newFilename+"256k.bin");
                de.malban.util.UtilityFiles.deleteFile(n1);
                de.malban.util.UtilityFiles.deleteFile(n2);
                de.malban.util.UtilityFiles.deleteFile(n3);
                de.malban.util.UtilityFiles.deleteFile(n4);
                de.malban.util.UtilityFiles.deleteFile(n1+".con");
                de.malban.util.UtilityFiles.deleteFile(n3+".con");

            }
            else
            {
                String filename = de.malban.util.Utility.makeVideAbsolute(cart.getFullFilename().elementAt(0));
                checkVec4EverFile(filename);
            }
            
        }
        catch (Throwable e)
        {
            printError("V4E: could not access project file.");
            jLabel10.setForeground(Color.red);
        }
    }

    public void checkVec4EverFile(String filenameAbs)
    {
        if (!checkVec4EverVolume(false)) return;
        boolean ok = de.malban.util.UtilityFiles.copyOneFile(filenameAbs, settings.v4eVolumeName+File.separator+"cart.bin");
        if (!ok)
        {
            printError("V4E: error copying file to RAMDISK: "+de.malban.util.UtilityFiles.error);
        }
        else
        {
            printMessage("V4E: bin file copied to RAM DISK");
            if (config.autoEjectV4EonCompile)
            {
                ejectVec4Ever();
            }
        }
    }

    public int getFontSize()
    {
        return settings.fontSize;
    }
    void setFontSize(int fs)
    {
//        ArrayList<TokenStyles.MyStyle> cloneStyleList = TokenStyles.styleList;
        ArrayList<TokenStyles.MyStyle> cloneStyleList = (ArrayList<TokenStyles.MyStyle>) TokenStyles.styleList.clone();
//        TokenStyles.reset();
        settings.fontSize = fs;
        
        for (TokenStyles.MyStyle style: cloneStyleList)
        {
            if (style.name.contains("editLog")) continue;
            TokenStyles.addStyle(
                style.name,
                StyleConstants.getBackground(style),
                StyleConstants.getForeground(style), 
                StyleConstants.isBold(style),
                StyleConstants.isItalic(style),
                settings.fontSize,
                StyleConstants.getFontFamily(style)
                );
        }
        resetAllEditors();
    }
    void increaseFontSize()
    {
        ArrayList<TokenStyles.MyStyle> cloneStyleList = (ArrayList<TokenStyles.MyStyle>) TokenStyles.styleList.clone();
//        ArrayList<TokenStyles.MyStyle> cloneStyleList = TokenStyles.styleList;
    //    TokenStyles.reset();
        settings.fontSize++;
        
        for (TokenStyles.MyStyle style: cloneStyleList)
        {
            if (style.name.contains("editLog")) continue;
            TokenStyles.addStyle(
                style.name,
                StyleConstants.getBackground(style),
                StyleConstants.getForeground(style), 
                StyleConstants.isBold(style),
                StyleConstants.isItalic(style),
                settings.fontSize,
                StyleConstants.getFontFamily(style)
                );
        }
        resetAllEditors();
    }
    void decreaseFontSize()
    {
        ArrayList<TokenStyles.MyStyle> cloneStyleList = (ArrayList<TokenStyles.MyStyle>) TokenStyles.styleList.clone();
    //    TokenStyles.reset();
        settings.fontSize--;
        for (TokenStyles.MyStyle style: cloneStyleList)
        {
            if (style.name.contains("editLog")) continue;
            TokenStyles.addStyle(
                style.name,
                StyleConstants.getBackground(style),
                StyleConstants.getForeground(style), 
                StyleConstants.isBold(style),
                StyleConstants.isItalic(style),
                settings.fontSize,
                StyleConstants.getFontFamily(style)
                );
        }
        resetAllEditors();
    }    
    void resetAllEditors()
    {
        for (Component c: jTabbedPane1.getComponents())
        {
            if (c instanceof de.malban.vide.vedi.EditorPanel)
            {
                EditorPanel ep = (EditorPanel) c;
                ep.stopColoring();
                ep.startColoring(settings.fontSize);
            }
        }
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
        jEditorPaneASMListing.setText("");
        jEditorASMMessages.setText("");
        jEditorLog.setText("");

        SwingUtilities.updateComponentTreeUI(jPopupMenu1);
        SwingUtilities.updateComponentTreeUI(jPopupMenuTree);
        SwingUtilities.updateComponentTreeUI(jPopupMenuProjectProperties);
        // int fontSize = Theme.textFieldFont.getFont().getSize();
        // int rowHeight = fontSize+2;
        // jTable1.setRowHeight(rowHeight);
        for (Component c: jTabbedPane1.getComponents())
        {
            if (c instanceof de.malban.vide.vedi.EditorPanel)
            {
                EditorPanel ep = (EditorPanel) c;
                ep.updateMyUI();
            }
        }
    }

    boolean invUpdating = false;
    void initInventory()
    {
        if (invUpdating) return;
        invUpdating = true;
        
        inventory.clear();
        EditorPanel edi = getSelectedEditor();
        if (edi != null)
        {
            String filename = edi.getFilename();
            
            
            if (filename.contains(Global.mainPathPrefix))
                filename = de .malban.util.UtilityString.replace(filename, Global.mainPathPrefix, "");

            
            if (edi.assume6809C)
            {
                Set entries;
                synchronized (cInfo.knownGlobalFunctions)
                {
                    HashMap<String, EntityDefinition> clonnie = (HashMap<String, EntityDefinition>) cInfo.knownGlobalFunctions.clone();
                    entries = clonnie.entrySet();
                }
                Iterator it = entries.iterator();
                while (it.hasNext())
                {
                    Map.Entry entry = (Map.Entry) it.next();
                    EntityDefinition entity = (EntityDefinition) entry.getValue();
                    if (entity.getCFile()!=null)
                    {
                        if (!entity.getCFile().toString().toLowerCase().equals(filename.toLowerCase())) 
                            continue;
                    }
                    boolean add = false;

                    add = add || ((settings.showEQULabel) && (entity.getSubType() == EntityDefinition.SUBTYPE_EQU_LABEL));
                    add = add || ((settings.showEqualLabel) && (entity.getSubType() == EntityDefinition.SUBTYPE_DEFINED_LABEL));
                    add = add || ((settings.showSetLabel) && (entity.getSubType() == EntityDefinition.SUBTYPE_SET_LABEL));
                    add = add || ((settings.showStructLabel) && (entity.getSubType() == EntityDefinition.SUBTYPE_STRUCT_LABEL));
                    add = add || ((settings.showInStructLabel) && (entity.getSubType() == EntityDefinition.SUBTYPE_INSTRUCT_LABEL));
                    add = add || ((settings.showLineLabel) && (entity.getSubType() == EntityDefinition.SUBTYPE_LINE_LABEL));
                    add = add || ((settings.showDataLabel) && (entity.getSubType() == EntityDefinition.SUBTYPE_DATA_LABEL));
                    add = add || ((settings.showMacroLabel) && (entity.getSubType() == EntityDefinition.SUBTYPE_INNER_MACRO_LABEL));
                    add = add || ((settings.showFunctionLabel) && (entity.getSubType() == EntityDefinition.SUBTYPE_FUNCTION_LABEL));
                    add = add || ((settings.showUserLabel) && (entity.getSubType() == EntityDefinition.SUBTYPE_VERIFIED_FUNCTION_LABEL));
                    add = add || ((settings.showMacroDefinition) && (entity.getSubType() == EntityDefinition.SUBTYPE_MACRO_DEFINITION_LABEL));
                    

                    if (add)
                        inventory.add(new InventoryEntry(entity.getName(), entity.getLineNumber(), entity.getSubType()));
                }
            }
            else if (edi.assume6809Asm)
            {
                Set entries;
                synchronized (asmInfo.knownGlobalVariables)
                {
                    HashMap<String, EntityDefinition> clonnie = (HashMap<String, EntityDefinition>) asmInfo.knownGlobalVariables.clone();
                    entries = clonnie.entrySet();
                }
                Iterator it = entries.iterator();
                while (it.hasNext())
                {
                    Map.Entry entry = (Map.Entry) it.next();
                    EntityDefinition entity = (EntityDefinition) entry.getValue();
                    if (entity.getCFile()!=null)
                    {
                        if (!entity.getCFile().toString().toLowerCase().equals(filename.toLowerCase())) 
                            continue;
                    }
                    else
                    {
                        if (!entity.getFile().toString().toLowerCase().equals(filename.toLowerCase())) 
                            continue;
                    }
                    boolean add = false;

                    add = add || ((settings.showEQULabel) && (entity.getSubType() == EntityDefinition.SUBTYPE_EQU_LABEL));
                    add = add || ((settings.showEqualLabel) && (entity.getSubType() == EntityDefinition.SUBTYPE_DEFINED_LABEL));
                    add = add || ((settings.showSetLabel) && (entity.getSubType() == EntityDefinition.SUBTYPE_SET_LABEL));
                    add = add || ((settings.showStructLabel) && (entity.getSubType() == EntityDefinition.SUBTYPE_STRUCT_LABEL));
                    add = add || ((settings.showInStructLabel) && (entity.getSubType() == EntityDefinition.SUBTYPE_INSTRUCT_LABEL));
                    add = add || ((settings.showLineLabel) && (entity.getSubType() == EntityDefinition.SUBTYPE_LINE_LABEL));
                    add = add || ((settings.showDataLabel) && (entity.getSubType() == EntityDefinition.SUBTYPE_DATA_LABEL));
                    add = add || ((settings.showMacroLabel) && (entity.getSubType() == EntityDefinition.SUBTYPE_INNER_MACRO_LABEL));
                    add = add || ((settings.showFunctionLabel) && (entity.getSubType() == EntityDefinition.SUBTYPE_FUNCTION_LABEL));
                    add = add || ((settings.showUserLabel) && (entity.getSubType() == EntityDefinition.SUBTYPE_VERIFIED_FUNCTION_LABEL));

                    if (add)
                        inventory.add(new InventoryEntry(entity.getName(), entity.getLineNumber(), entity.getSubType()));
                }
                HashMap<String, String> savety = new HashMap<String, String>();
                if (settings.showMacroDefinition)
                {
                    synchronized (asmInfo.knownGlobalMacros)
                    {
                        HashMap<String, EntityDefinition> clonnie = (HashMap<String, EntityDefinition>) asmInfo.knownGlobalMacros.clone();
                        entries = clonnie.entrySet();
                    }
                    it = entries.iterator();
                    while (it.hasNext())
                    {
                        Map.Entry entry = (Map.Entry) it.next();
                        EntityDefinition entity = (EntityDefinition) entry.getValue();

                        if (entity.getCFile()!=null)
                        {
                            if (!entity.getCFile().toString().toLowerCase().equals(filename.toLowerCase())) 
                                continue;
                        }
                        else
                        {
                            if (!entity.getFile().toString().toLowerCase().equals(filename.toLowerCase())) 
                                continue;
                        }
                        

                        boolean add = false;

                        if ((entity.getSubType() == EntityDefinition.SUBTYPE_MACRO_DEFINITION_LABEL))
                        {
                            if (savety.get(entity.getName()) == null)
                            {
                                savety.put(entity.getName(), entity.getName());
                                inventory.add(new InventoryEntry(entity.getName(), entity.getLineNumber(), entity.getSubType()));
                            }
                        }
                    }            
                }
            }
                

            
        }
        invUpdating = false;
        
        List list = sorter.getSortKeys();
        
        jTableInventory.tableChanged(null);
        sorter.setSortKeys(list);
        sorter.sort();        
        jTableInventory.setAutoResizeMode(AUTO_RESIZE_LAST_COLUMN);
        for (int i=0; i< inventoryModel.getColumnCount(); i++)
        {
            jTableInventory.getColumnModel().getColumn(i).setPreferredWidth(inventoryModel.getColWidth(i));                
            jTableInventory.getColumnModel().getColumn(i).setWidth(inventoryModel.getColWidth(i));  
        }
        jTableInventory.setAutoResizeMode(AUTO_RESIZE_SUBSEQUENT_COLUMNS);
    }
    void goFunction(int row)
    {
        if (row <0) return;
        if (row >= inventory.size()) return;
        InventoryEntry inv = inventory.get(row);
        EditorPanel edi = getSelectedEditor();
        if (edi == null) return;
        addHistory();
        edi.goLine(inv.line);
        updateTables();
    }
    
    class HistoryEntry
    {
        public int line;
        public String file;
        public HistoryEntry(String f, int l)
        {
            line = l;
            file = f;
        }
    }
    ArrayList <HistoryEntry> history = new ArrayList<HistoryEntry>();
    int historyPosition = 0;
    // remembers the current active edited file
    // and position and adds it to a history buffer
    private void addHistory()
    {
        EditorPanel edi = getSelectedEditor();
        if (edi == null) return;
        while (historyPosition<history.size())
        {
            history.remove(history.size()-1);
        }
        
        history.add(new HistoryEntry(edi.getFilename(), edi.getCurrentLineNumber()+1));
        historyPosition = history.size();
        jButtonAdressBack.setEnabled(historyPosition>0);
        jButtonAdressForward.setEnabled(historyPosition<history.size());
    }
    private void historyBack()
    {
        if (historyPosition > 0)
        {
            // if we go the first time back - add the current position
            // so we can go forward again
            if (historyPosition == history.size())
            {
                addHistory();
                historyPosition--;
            }
            historyPosition--;
            HistoryEntry h = history.get(historyPosition);
            jumpToEdit(h.file, h.line, false);
        }
        jButtonAdressBack.setEnabled(historyPosition>0);
        jButtonAdressForward.setEnabled(historyPosition<history.size());
    }                                                 
    private void historyForward()
    {
        if (historyPosition < history.size()-1)
        {
            historyPosition++;
            HistoryEntry h = history.get(historyPosition);
            jumpToEdit(h.file, h.line, false);
        }

        // if we are in the front and came from the back - delete the current front
        if (historyPosition == history.size()-1)
        {
//            historyPosition--;
            history.remove(history.size()-1);
        }
        
        
        jButtonAdressBack.setEnabled(historyPosition>0);
        jButtonAdressForward.setEnabled(historyPosition<history.size());
    }                                                 
    private Object syncObject = new Object();
    private TimingTriggerer timer = null; 
    private TriggerCallback timerWorker = null;
    private void deinitScheduler()
    {
        synchronized (syncObject)
        {
            if (timer != null)
            {
                timer.removeTrigger(timerWorker);
                timerWorker = null;
                timer = null;
            }
        }
    }

    private void initScheduler()
    {
        if (timer == null)
        {
            timer = TimingTriggerer.getPrivatTimer();
            timer.setResolution(config.deepSyntaxCheckTiming); // 10 seconds
            
            timerWorker = new TriggerCallback()
            {
                @Override
                public void doIt(int state, Object o)
                {
                    updateDefinitions();
                    synchronized (syncObject)
                    {
                        if (timer != null)
                        {
                            if (timerWorker != null)
                                timer.addTrigger(timerWorker, config.deepSyntaxCheckTiming, 0, null); // every 10 seconds
                        }
                    }
                }
            };
            timer.addTrigger(timerWorker, config.deepSyntaxCheckTiming, 0, null);            
        }
    }
    
    boolean doIHaveSomeFocus()
    {
        if (getFrame()==null) return false;
        Component c = getFrame().getFocusOwner();
        if (c == null) return false;
        
        while (c != null)
        {
            if (c == this) return true;
            c = c.getParent();
        }
        return false;
    }
    
    boolean doesItHaveSomeFocus(Component editor)
    {
        Component c = getFrame().getFocusOwner();
        if (c == null) return false;
        
        while (c != null)
        {
            if (c == editor) return true;
            c = c.getParent();
        }
        return false;
    }
    private void updateDefinitions()
    {
        if (!doIHaveSomeFocus())
        {
            return;
        }
        SwingUtilities.invokeLater(new Runnable()
        {
            public void run()
            {
                if (config.deepSyntaxCheck)
                {
                    EditorPanel lastEdi = null;
                    for (int i=0; i <jTabbedPane1. getTabCount(); i++)
                    {
                        try
                        {
                            if (jTabbedPane1.getComponentAt(i) instanceof EditorPanel)
                            {
                                EditorPanel edi = (EditorPanel) jTabbedPane1.getComponentAt(i);
                                lastEdi = edi;
                                if (edi.assume6809Asm)
                                {
                                    if (edi.hasChanged1)
                                    {
                                        if ((config.deepSyntaxCheckThresholdActive) && (edi.getText().length()>config.deepSyntaxCheckThreshold))
                                            continue;
                                        asmInfo.resetDefinitions(de.malban.util.Utility.makeVideAbsolute(edi.getFilename()), edi.getText());
                                        edi.hasChanged1 = false;
                                    }
                                }
                                if (edi.assume6809C)
                                {
                                    if (edi.hasChanged1)
                                    {
                                        if ((config.deepSyntaxCheckThresholdActive) && (edi.getText().length()>config.deepSyntaxCheckThreshold))
                                            continue;
                                        cInfo.resetDefinitions(de.malban.util.Utility.makeVideAbsolute(edi.getFilename()), edi.getText());
                                        edi.hasChanged1 = false;
                                    }
                                }
                            }
                        }
                        catch (Throwable e)
                        {
                            log.addLog("UpdateDefinitions:\n"+de.malban.util.Utility.getStackTrace(e), INFO);
                            if (lastEdi != null)
                                log.addLog("Editorname:\n"+lastEdi.getFilename(), INFO);
                            e.printStackTrace();
                            
                        }
                    }
                    if (getSelectedEditor() != null)
                    {
                        if (getSelectedEditor().hasChanged2)
                        {

                            if (!((config.deepSyntaxCheckThresholdActive) && (getSelectedEditor().getText().length()>config.deepSyntaxCheckThreshold)))
                            {
                                if (doesItHaveSomeFocus(getSelectedEditor()))
                                {
                                    if (!getSelectedEditor().hasSelection())
                                    {
                                        try
                                        {
                    getSelectedEditor().setViewportEnabled(false);
                                            getSelectedEditor().saveSelection();
                                            getSelectedEditor().stopColoring();
                                            getSelectedEditor().startColoring(settings.fontSize);
                                            getSelectedEditor().restoreSelection();
                    getSelectedEditor().setViewportEnabled(true);
                                        }
                                        catch (Throwable e)
                                        {
                                            log.addLog("UpdateDefinitions 2:\n"+de.malban.util.Utility.getStackTrace(e), INFO);
                                            if (lastEdi != null)
                                                log.addLog("Editorname:\n"+getSelectedEditor().getFilename(), INFO);
                                            e.printStackTrace();

                                        }
                                    }
                                }
                            }
                            getSelectedEditor().hasChanged2 = false;
                        }

                    }
                }

                
                
                initInventory();
            }
        });                    
    }   
    public void deIconified()  {}
    
    // invokes compiler for one file
    // and translforms output to assi compatible form
    static boolean isMac = Global.getOSName().toUpperCase().contains("MAC");
    static boolean isWin = Global.getOSName().toUpperCase().contains("WIN");
    static boolean isLinux = Global.getOSName().toUpperCase().contains("LIN");

    public void doCCompilerSingleFile(String file)
    {
        // build CFLAGS
        String compiler = Global.mainPathPrefix+"C"+File.separator+"Mac"+File.separator+"gcc6809"+File.separator+"bin"+File.separator+"cc1";
        String CFLAGS1a = "-dumpbase";
        String CFLAGS1b = baseOnly(file);
        String CFLAGS2a = "-O3";//-O3";
        String CFLAGS2b = "-O3";//"-g";
        String CFLAGS3 = "-mint8";
        String CFLAGS4 = "-msoft-reg-count=0";
        String CFLAGS5a = "-auxbase";
        String CFLAGS5b = baseOnly(file);
        String CFLAGS6 = "-I"+Global.mainPathPrefix+"C"+File.separator+"include";
        String CFLAGS7 = "-quiet";
        
        String program = file;
        String output1 = "-o";
        String output2 = changeTypeTo(file,"s");
    
        String [] cmd = new String[14];
        int cl = 0;
        cmd[cl++] = compiler;
        cmd[cl++] = CFLAGS1a;   
        cmd[cl++] = CFLAGS1b;   
        cmd[cl++] = CFLAGS2a;
        cmd[cl++] = CFLAGS2b;
        cmd[cl++] = CFLAGS3;   
        cmd[cl++] = CFLAGS4;
        cmd[cl++] = CFLAGS5a;   
        cmd[cl++] = CFLAGS5b;   
        cmd[cl++] = CFLAGS6;   
        cmd[cl++] = CFLAGS7;   
        cmd[cl++] = program;
        cmd[cl++] = output1;
        cmd[cl++] = output2;  
        
        CompileResult compiled = doCCompiler( cmd);
        if (peepAtASM)
        {
            if (currentProject!=null)
            {
                if (currentProject.getIsCPeephole())
                    FilePeeper.peepCorrectASM(output2);
            }
            else
                    FilePeeper.peepCorrectASM(output2);
        }
        
        
//        if (compiled != null)
//        {
//            ArrayList<CompileResult> crs = new ArrayList<CompileResult>();
//            crs.add(compiled);
//            buildFinalAssiResult(crs, false);
//        }
    }
    /*

    */
    public CompileResult doCCompiler(String[] flags)
    {
        if (isMac)
        {
            return doCCompilerMac(flags);
        }
        if (isWin)
        {
            return doCCompilerWin(flags);
        }
        return null;
    }
    public CompileResult doCCompilerWin(String[] flags)
    {
        flags[0]=Global.mainPathPrefix+"C"+File.separator+"Win32"+File.separator+"bin"+File.separator+"gcc6809.exe";
        String file = flags[flags.length-3];
        String outputFile = flags[flags.length-1];
        try
        {
            log.addLog("Trying to compile: "+file, INFO);
            boolean ok=  executeOSCommand(flags);
            
            String tt= UtilityFiles.lastError;
            ok = ok && (!(UtilityFiles.lastError.contains("error:")));
            
            if (ok)
            {
                printWarning(UtilityFiles.lastError);
                printMessage(UtilityFiles.lastMessage);
                printMessage("\nCompile success");
                CompileResult cr = doAssiConform(file, outputFile);
                return cr;
            }
            
        }
        catch (Throwable e)
        {
            log.addLog(de.malban.util.Utility.getStackTrace(e), INFO);
        }
        log.addLog("Compile failed: "+file, WARN);
        printError(UtilityFiles.lastError);
        printError(UtilityFiles.lastMessage);
        printError("\nCompile failed");
        return null;
    }    
    public CompileResult doCCompilerMac(String[] flags)
    {
        flags[0]=Global.mainPathPrefix+"C"+File.separator+"Mac"+File.separator+"bin"+File.separator+"cc1";
        String file = flags[flags.length-3];
        String outputFile = flags[flags.length-1];

        printMessage("\nCompiling: "+file);
        
        try
        {
            log.addLog("Trying to compile: "+file, INFO);
            boolean ok=  executeOSCommand(flags);
            
            String tt= UtilityFiles.lastError;
            ok = ok && (!(UtilityFiles.lastError.contains("error:")));
            
            if (ok)
            {
                printWarning(UtilityFiles.lastError.trim());
                printMessage(UtilityFiles.lastMessage.trim());
                printMessage("\nCompile success");
                CompileResult cr = doAssiConform(file, outputFile);
                return cr;
            }
            
        }
        catch (Throwable e)
        {
            log.addLog(de.malban.util.Utility.getStackTrace(e), INFO);
        }
        log.addLog("Compile failed: "+file, WARN);
        printError(UtilityFiles.lastError);
        printError(UtilityFiles.lastMessage);
        printError("\nCompile failed");
        return null;
    }
    public static String baseOnly(String file)
    {
        String fileWithoutEnding = file.substring(0, file.lastIndexOf("."));
        return fileWithoutEnding;
    }
    public static String changeTypeTo(String file, String type)
    {
        return baseOnly(file)+"."+type;
    }
    static String nameOnly(String file)
    {
        file = convertSeperator(file);
        if (!file.contains(File.separator)) return file;
        if (file.endsWith(File.separator)) return "";
        return file.substring(file.lastIndexOf(File.separator)+1);
    }
    
    static class CompileResult
    {
        String inputFile;
        String intermediateFile;
        String codeData;
        String dataData;
        String bssData;
        String bssInitData;
        
        
        boolean initializedDataFound = false;
        
        String pathOnly;
        String nameOnly;
        
        ArrayList <String> usedIncludeFiles = new ArrayList<String>();
        HashMap<String,String> varMapping = new HashMap<String,String>();
        HashMap<String,String> libCCalls = new HashMap<String,String>();
    }
    
    boolean buildFinalAssiResult(ArrayList <CompileResult> compiles, boolean isProject)
    {
        String n = buildFinalAssiResultString(compiles, isProject);
        if (n==null) return false;
        String assiFile = changeTypeTo(compiles.get(0).inputFile, "asm");//.�pathOnly+"assiFile.asm";
        if (currentProject != null)
        {
            assiFile = de.malban.util.Utility.makeVideAbsolute(currentProject.projectPrefix+File.separator+currentProject.getProjectName()+".asm");
        }

        de.malban.util.UtilityFiles.createTextFile(assiFile, n);
        
        if (!isProject)
        {
            startTypeRun = START_TYPE_RUN;
            asmStarted = false;
            startASM(assiFile);
        }
        
        return true;
    }
    String buildFinalAssiResultString(ArrayList <CompileResult> compiles, boolean isProject)
    {
        if (compiles.size() == 0) return null;
        HashMap<String,String> libCCalls = new HashMap<String,String>();
        
        Path include = Paths.get(Global.mainPathPrefix, "template", "VECTREX.I");
        de.malban.util.UtilityFiles.copyOneFile(include.toString(), compiles.get(0).pathOnly+ "VECTREX.I");
        
        StringBuilder assiSource = new StringBuilder();
        assiSource.append(" include \"VECTREX.I\"").append("\n");

        boolean initializedDataFound = false;
        for (CompileResult compile: compiles)
        {
            if (compile.initializedDataFound)
            {
                initializedDataFound = true;
            }
            Set entries = compile.libCCalls.entrySet();
            Iterator it = entries.iterator();
            while (it.hasNext())
            {
                Map.Entry entry = (Map.Entry) it.next();
                String key = (String) entry.getKey();
                String lib = (String) entry.getValue();
                libCCalls.put(key, lib);
            }
        }
        assiSource.append("; Vectrex RAM section").append("\n");
        assiSource.append(" bss").append("\n");
        assiSource.append(" org 0xc880").append("\n");
        if (initializedDataFound)
        {
            assiSource.append("RAM_to_initialize_start:").append("\n");
        }                
        
        for (CompileResult compile: compiles)
        {
            assiSource.append(compile.bssInitData);
        }
        
        if (initializedDataFound)
        {
            assiSource.append("RAM_to_initialize_end:").append("\n");
        }                
        assiSource.append("RAM_uninitialized:").append("\n");
        for (CompileResult compile: compiles)
        {
            assiSource.append(compile.bssData);
        }

        
        StringBuilder crt0 = new StringBuilder();
        crt0.append(getLibSource("crt0.s"));
        // todo: replace some names etc

        String crt0S = crt0.toString();
        if (currentProject != null)
        {
            crt0S = de.malban.util.UtilityString.replace(crt0S, "VIDE-C", currentProject.getProjectName().toUpperCase());
        }
        
        
        assiSource.append(crt0S);

        if (initializedDataFound)
        {
            assiSource.append(" jsr initializeData_bss").append("\n");
        }                
        assiSource.append(" jmp _main").append("\n");
        
        for (CompileResult compile: compiles)
        {
            assiSource.append(compile.codeData);
        }
        // add all libc sources that are needed
        Set entries = libCCalls.entrySet();
        Iterator it = entries.iterator();
        while (it.hasNext())
        {
            Map.Entry entry = (Map.Entry) it.next();
            String lib = (String) entry.getValue();
            assiSource.append(getLibSource(lib));
        }
        
        if (initializedDataFound)
        {
            assiSource.append(getLibSource("initbss.s"));
            assiSource.append("data_to_initialize_bss:").append("\n");
            for (CompileResult compile: compiles)
            {
                assiSource.append(compile.dataData);
            }
        }
        
        String n = prettyPrint(assiSource.toString());
        
        return n;
    }
    String getLibSource(String lib)
    {
        String fullPath = Global.mainPathPrefix+"C"+File.separator+"lib"+File.separator+lib;
        return de.malban.util.UtilityString.readTextFileToOneString(new File(fullPath));
    }
    // returns length for use in "ds x" of a "db" statement
    // it is tricky since DB can contain Strings and comma seperated values
    static int getDBLen(String input)
    {
        if (!input.contains("db")) return 0;
        if (!input.contains("\"")) return 1;
        String split[] = input.split("\"");
        split = removeEmpty(split);
//        System.out.println(""+split);
        return 1;
    }
    
    public static  String[] removeEmpty(String split[])
    {
        ArrayList<String> l = new ArrayList<String>();
        for (int i=0; i< split.length;i++)
        {
            if (split[i] == null) continue;
            if (split[i].length() == 0) continue;
            l.add(split[i]);
        }
        return l.toArray(new String[0]);
    }
    // check if line contains a variable
    // if so change the line to use a with concatinated version of the name
    static String doVarMapping(HashMap<String,String> map, String line, String append)
    {
        return line;
        /*
        String var="";
        String workLine;
        workLine = EntityDefinition.removeComment(line, ";");
        workLine = EntityDefinition.removeComment(line, "*");
        if (workLine.trim().length() == 0) return line;
        if (workLine.startsWith("_main")) return line;

        if (Character.isWhitespace(line.charAt(0))) 
        {
            // test operand
            String split[] = line.split(" ");
            split = removeEmpty(split);
            if (split.length<2) return line;
            
            split[1] = de.malban.util.UtilityString.replace(split[1], "#", "");
            split[1] = de.malban.util.UtilityString.replace(split[1], "<", "");
            split[1] = de.malban.util.UtilityString.replace(split[1], ">", "");
            split[1] = de.malban.util.UtilityString.replace(split[1], "<<", "");
            
            if (!split[1].startsWith("_")) return line;
            String orgVar = split[1];

            String newVar = orgVar+"_"+append;
            map.put(orgVar, newVar);
            return de.malban.util.UtilityString.replace(line, orgVar, newVar);
        }
            
        String split[] = line.split(" ");
        split = removeEmpty(split);
        if (split.length == 0) return line;
        if (!split[0].startsWith("_")) return line;
        if (!split[0].endsWith(":")) return line;
        String orgVar = split[0].substring(0,split[0].length()-1);
        String newVar = orgVar+"_"+append;
        map.put(orgVar, newVar);
        return de.malban.util.UtilityString.replace(line, orgVar, newVar);
            */
        
    }
    static String checkRAMLocations(String sLine)
    {
        if (sLine.startsWith(";")) return sLine;
        String wl = de.malban.util.UtilityString.replace(sLine, "#", "");
        wl = de.malban.util.UtilityString.replace(wl, "<", "");
        wl = de.malban.util.UtilityString.replace(wl, "<<", "");
        wl = de.malban.util.UtilityString.replace(wl, ">", "");
        String[] parts = wl.trim().split(" ");
        parts = removeEmpty(parts);
        for (int i=0;i<parts.length; i++)
        {
            int v=0;
            try
            {
                v = DASM6809.toNumber(parts[i]);
                if (((v>= 0xc800) && (v<0xc800+1024)) || ((v>= 0xd000) && (v<=0xd00f)))
                {
                    String label = DASM6809.getBIOSLabel(v);
                    if (label != null)
                    {
                        return de.malban.util.UtilityString.replace(sLine, parts[i], label);
                    }
                }
                else
                {
                    if ((v>256) && (v< ((-128)&0xffff)  ))
                    {
                        return de.malban.util.UtilityString.replace(sLine, parts[i], "0x"+String.format("%04X", (v & 0xFFFF)));
                    }
                }
            }
            catch (Exception e)
            {
                
            }
        }
        
        return sLine;
    }
    
    void doBuildCProject()
    {

        // Build the complete project
        String preClass = currentProject.getProjectPreScriptClass();
        String preName = currentProject.getProjectPreScriptName();
        
        String p = currentProject.projectPrefix+File.separator;
        
        ExecutionDescriptor ed = new ExecutionDescriptor(ED_TYPE_PROJECT_PRE, currentProject.getProjectName(), "", "VediPanel", p);
        boolean ok =  ScriptDataPanel.executeScript(preClass, preName, this, ed);
        if (!ok) return;
        clearASMOutput();
        startBuildCProject();
    }    
    
    String[] buildCFLAGS()
    {
        if (currentProject == null) return new String[0];
        String[] splits = currentProject.getCFLAGS().split(" ");
        splits = removeEmpty(splits);

        for (int i=0; i<splits.length; i++)
        {
            if (splits[i].startsWith("-I"))
            {
                // "-O3 -mint8 -msoft-reg-count=0 -quiet -IC/include";
                String dir = splits[i].substring(2);
                dir = "-I"+Global.mainPathPrefix+dir;
                splits[i] = de.malban.util.UtilityFiles.convertSeperator(dir);
            }
        }
        
        String[] cflags = new String[splits.length+4];
        for (int i=0; i< splits.length; i++) cflags[i+1]=splits[i];

        cflags[cflags.length-2] = "-o";
        return cflags;
    }
    
    
    public void startBuildCProject()
    {
        if (asmStarted) return;
        asmStarted = true;
        jButtonAssemble.setEnabled(false);
        jButtonDebug.setEnabled(false);
        // paranoia!
        if (one != null) return;
        
        String[] CFLAGS = buildCFLAGS();
        log.addLog("GCC: "+CFLAGS);
        one = new Thread() 
        {
            public void run() 
            {
                ArrayList<CompileResult> crs = new ArrayList<CompileResult>();
                boolean asmOk = true;
                
                {
                    try
                    {
                        String path = currentProject.projectPrefix;



                        // get all the files from a directory
                        final String failure = executeFileScripts("Pre", path);
                        if (failure!=null) 
                        {
                            if (!asmOk)
                            {
                                SwingUtilities.invokeLater(new Runnable()
                                {
                                    public void run()
                                    {
                                        printError("Error execute pre build script for: " + failure);
                                        buildCProjectResult(false, true);
                                    }
                                });                    
                                one = null;
                                jButtonAssemble.setEnabled(true);
                                jButtonDebug.setEnabled(true);
                                asmStarted = false;
                                return;
                            }
                        }

                        // get 
                        // get all the files from a directory
                        {
                            File directory = new File(path);
                            File[] fList = directory.listFiles();
                            for (File file : fList) 
                            {
                                String fileNameOnly = file.getName();

                                // process only c files
                                if (!fileNameOnly.toLowerCase().endsWith(".c")) continue;
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

                                    String relPathOnly = de.malban.util.Utility.makeVideRelative(pathOnly);
                                    if (relPathOnly.length()!=0) relPathOnly+=File.separator;
                                    FilePropertiesPool pool = new FilePropertiesPool(relPathOnly, test.getName());

                                    FileProperties fileProperties =  pool.get(fileNameOnly);
                                    if (fileProperties != null) 
                                    {
                                        if (fileProperties.getNoInternalProcessing()) continue;
                                    }
                                }
                                // compile file

                                CFLAGS[CFLAGS.length-3] = file.getAbsolutePath();
                                CFLAGS[CFLAGS.length-1] = changeTypeTo(file.getAbsolutePath(),"s");

                                CompileResult compiled = doCCompiler(CFLAGS);
                                if (compiled != null)
                                    crs.add(compiled);
                                else
                                {
                                    SwingUtilities.invokeLater(new Runnable()
                                    {
                                        public void run()
                                        {
                                            printError("Error compiling: " + CFLAGS[CFLAGS.length-3]);
                                            buildCProjectResult(false, true);
                                        }
                                    });                    
                                    one = null;
                                    jButtonAssemble.setEnabled(true);
                                    jButtonDebug.setEnabled(true);
                                    asmStarted = false;
                                    return;
                                }
                            }
                        }                                        

                        // get all the files from a directory
                        final String failure2 = executeFileScripts("Post", path);
                        if (failure2!=null) 
                        {
                            if (!asmOk)
                            {
                                SwingUtilities.invokeLater(new Runnable()
                                {
                                    public void run()
                                    {
                                        printError("Error execute post build script for: " + failure2);
                                        buildCProjectResult(false, true);
                                    }
                                });                    
                                one = null;
                                jButtonAssemble.setEnabled(true);
                                jButtonDebug.setEnabled(true);
                                asmStarted = false;
                                return;
                            }

                        }
                    }
                    catch (final Throwable e)
                    {
                        SwingUtilities.invokeLater(new Runnable()
                        {
                            public void run()
                            {
                                printASMMessage("Exception while building: " + e.getMessage(), ASM_MESSAGE_ERROR);
                                printASMMessage(de.malban.util.Utility.getStackTrace(e), ASM_MESSAGE_ERROR);
                                buildCProjectResult(false, true);
                            }
                        });   
                        one = null;
                        jButtonAssemble.setEnabled(true);
                        jButtonDebug.setEnabled(true);
                        asmStarted = false;
                        return;
                    }
                } // and banks loop
                

                String postClass = currentProject.getProjectPostScriptClass();
                String postName = currentProject.getProjectPostScriptName();
                
                String pp = currentProject.projectPrefix;
                
                ExecutionDescriptor ed = new ExecutionDescriptor(ED_TYPE_PROJECT_POST, currentProject.getProjectName(), "", "VediPanel", pp);
                boolean ok =  ScriptDataPanel.executeScript(postClass, postName, VediPanel.this, ed);
                final boolean asmOk2 = asmOk; // effectivly final!
                
                
                if (!ok)
                {
                    SwingUtilities.invokeLater(new Runnable()
                    {
                        public void run()
                        {
                            buildCProjectResult(false, true);
                        }
                    });                    
                    one = null;
                    jButtonAssemble.setEnabled(true);
                    jButtonDebug.setEnabled(true);
                    asmStarted = false;
                }
                else
                {
                    asmOk = buildFinalAssiResult(crs, true);
                    if (asmOk)
                    {
//                        String assiFile = changetypeTo(crs.get(0).inputFile, "asm");//pathOnly+"assiFile.asm";

                        String assiFile = de.malban.util.Utility.makeVideAbsolute(currentProject.projectPrefix+File.separator+currentProject.getProjectName()+".asm");
                        
                        
                        printMessage("Assembling: "+assiFile);
                        Asmj asm = new Asmj(assiFile, asmErrorOut, null, null, asmMessagesOut, "", settings.allDebugComments);
                        printASMList(asm.getListing(), ASM_LIST);

                        String info = asm.getInfo();
                        asmOk = info.indexOf("0 errors detected.") >=0;
                    }
                    if (asmOk)
                    {
//                        String filename = changetypeTo(crs.get(0).inputFile, "bin");
//                        int li = filename.lastIndexOf(".");
//                        if (li>=0) 
//                            filename = filename.substring(0,li);
//                        String org = filename + ".bin";
//                        String banked = filename+"_"+(0) + ".bin";
//                        de.malban.util.UtilityFiles.move(org, banked);
//                        
//                        org = filename + ".cnt";
//                        banked = filename+"_"+(0) + ".cnt";
//                        
//                        Vector<String> what = new Vector<String>();
//                        Vector<String> with = new Vector<String>();
//                        what.add("BANK 0");
//                        with.add("BANK "+(0));
//                        de.malban.util.UtilityString.replaceToNewFile(new File(org), new File(banked), what,with);
//                        de.malban.util.UtilityFiles.deleteFile(org);                        
                    }
                    boolean asmOk3 = asmOk;
                    SwingUtilities.invokeLater(new Runnable()
                    {
                        public void run()
                        {
                            buildCProjectResult(asmOk3, false);
                        }
                    });                    
                    one = null;
                    asmStarted = false;
                    jButtonAssemble.setEnabled(true);
                    jButtonDebug.setEnabled(true);
                }
            }  
        };

        one.setName("C-Build: "+currentProject.getProjectName());
        one.start();           
    }
        
    protected void buildCProjectResult(boolean buildOk, boolean errorPreAssembler)
    {
        refreshTree();
        if (buildOk)
        {
            VecXPanel vec = ((CSAMainFrame)mParent).getVecxy();
            ((CSAMainFrame)mParent).getInternalFrame(vec).toFront();

            CartridgeProperties cartProp = buildCart(currentProject, false);
                
            if (config.invokeEmulatorAfterAssembly)
            {
                checkVec4EverProject(cartProp);
                
                
                boolean ask = false;
                if (startTypeRun == START_TYPE_INJECT)
                {
                    CartridgeProperties oldProp = vec.getCurrentCartProp();
                    if (oldProp == null) ask = true;
                    else
                    {
                        String myName = currentProject.getProjectName();
                        String oldName = oldProp.getCartName();
                        if (!oldName.equals(myName)) ask = true;
                    }
                }
        
                boolean doit = true;
                if (ask)
                {
//                    JOptionPane pane = new JOptionPane("The bin files appear to be not compatible, inject anyway?", JOptionPane.WARNING_MESSAGE, JOptionPane.OK_CANCEL_OPTION);
//                    int answer = JOptionPaneDialog.show(pane);

                int answer = JOptionPane.showOptionDialog(Configuration.getConfiguration().getMainFrame(), 
                "The bin files appear to be not compatible, inject anyway?",
                "File not compatible",
                JOptionPane.WARNING_MESSAGE, JOptionPane.OK_CANCEL_OPTION, null, null, null);


                    if (answer == JOptionPane.YES_OPTION)
                        doit = true;
                    else
                    {
                        doit = false;
                    }
                }
                if (doit)
                {
                    vec.startCartridge(cartProp, startTypeRun);
                    printMessage("Assembly successfull, starting emulation...");
                }
            }
            else
            {
                printMessage("Assembly successfull...");
            }
            
            if (config.invokeVecMultiAfterAssembly) {
                loadVecMulti(cartProp);
            }
        }
        else
        {
            printError("Assembly not successfull, see ASM output...");
            if (errorPreAssembler)
                jTabbedPane.setSelectedIndex(0);
            else
                jTabbedPane.setSelectedIndex(1);
        }
        refreshTree();
    }                    

    CompileResult doAssiConform(String cFile, String gccSFile)
    {
        CompileResult result = new CompileResult();
        result.inputFile = cFile;
        result.intermediateFile = gccSFile;
        
        Path p = Paths.get(cFile);
        result.pathOnly = p.getParent().toString();
        if (result.pathOnly.length()>0)
            result.pathOnly+= File.separator;
        result.nameOnly = baseOnly(de.malban.util.UtilityString.replace(cFile, result.pathOnly, ""));

        Vector<String> orgLines =  de.malban.util.UtilityString.readTextFileToString(new File(cFile));
        Vector<String> sLines =  de.malban.util.UtilityString.readTextFileToString(new File(gccSFile));
        
        return doAssiConform(orgLines, sLines, result);
        
    }
    static CompileResult doAssiConform(Vector<String> orgLines, Vector<String> sLines, CompileResult r)
    {
        CompileResult result = r;
        if (result == null) result = new CompileResult();
        
        String cFile = "something, that does not occur in C Source";
        if (r != null) cFile = r.inputFile;
        
        StringBuilder codeSource = new StringBuilder();
        StringBuilder dataSource = new StringBuilder();
        StringBuilder bssSource = new StringBuilder();
        StringBuilder bssInitSource = new StringBuilder();

        

        
        // Scan for include files.
        // for each include file we look "automatically" if there is an
        // accompanying "*.asm" file, if so, we load it as a library refference to include
        // also we must fix somehow the callings of 
        // added assembler routines, the "_" callings must somehow be handled
        //
        // also in diverse generated files in vide
        // add option to generate an accompanying ".h" file
        // with C conform global calling names
        
        
        
        
        boolean in_Code = false;
        boolean in_Data = false;
        boolean in_BSS = false;
        
        
        for (int i=0; i< sLines.size(); i++)
        {
            String sLine = sLines.elementAt(i);
            if (sLine.contains(".area .data"))
            {
                result.initializedDataFound = true;
                break;
            }
        }
        for (int i=0; i< sLines.size(); i++)
        {
            String sLine = sLines.elementAt(i);
            String[] splits = sLine.split(" ");
            boolean doLine = true;
            
            if (sLine.contains(".area .text"))
            {
                in_Code = true;
                in_Data = false;
                in_BSS = false;
                doLine = false;
            }
            if (sLine.contains(".area .data"))
            {
                in_Code = false;
                in_Data = true;
                in_BSS = false;
                doLine = false;
            }
            if (sLine.contains(".area .bss"))
            {
                in_Code = false;
                in_Data = false;
                in_BSS = true;
                doLine = false;
            }
            
            // I don't like tabs, replace all tabs with spaces
            sLine = de.malban.util.UtilityString.replace(sLine,"\t", "        ");

            // reference to C-Line
            if (sLine.contains(cFile))
            {
                int line = de.malban.util.UtilityString.Int0(splits[2]);
                if (in_Code)
                    codeSource.append("; ").append(orgLines.elementAt(line-1)).append("\n");
                if (in_Data)
                    dataSource.append("; ").append(orgLines.elementAt(line-1)).append("\n");
                if (in_BSS)
                    bssSource.append("; ").append(orgLines.elementAt(line-1)).append("\n");
            }
            // probably a call to BIOS
            int pos = sLine.indexOf("jsr 0xF");
            if (pos > 0)
            {
                String orgJSR = sLine.substring(pos, pos+10);
                int biosAddress=DASM6809.toNumber(orgJSR.substring(4));
                String name=DASM6809.getBIOSFunction(biosAddress);
                if (name != null)
                {
                    sLine = de.malban.util.UtilityString.replace(sLine,orgJSR, "jsr "+name);
                }
            }
            sLine = de.malban.util.UtilityString.replace(sLine,".byte", "db");
            sLine = de.malban.util.UtilityString.replace(sLine,".word", "dw");
            sLine = de.malban.util.UtilityString.replace(sLine,".blkb", "ds");
                // 
            
            if (sLine.contains(".ascii"))
            {
                sLine = de.malban.util.UtilityString.replace(sLine,"\\0\"", "\", $80");
            }
            sLine = de.malban.util.UtilityString.replace(sLine,".ascii", "db");
            
            if (sLine.contains(".globl")) doLine = false;
            if (sLine.contains(";----- asm")) doLine = false;
            if (sLine.contains(";--- end asm")) doLine = false;
            if (sLine.contains(".module")) doLine = false;
            if (sLine.contains(";;; ")) doLine = false;
            
            if (doLine)
            {
                if (in_Data)
                {
                    if (sLine.contains("db"))
                        bssInitSource.append(" ds "+getDBLen(sLine)+"\n");
                    else if (sLine.contains("dw"))
                        bssInitSource.append(" ds 2\n");
                    if ((sLine.contains("_")) && (sLine.contains(":")))
                    {
                        bssInitSource.append(doVarMapping(result.varMapping, sLine, result.nameOnly)).append("\n");
                        doLine = false;
                    }
                    if (doLine)
                        dataSource.append(doVarMapping(result.varMapping, sLine, result.nameOnly)).append("\n");
                }
                if (in_BSS)
                {
                    bssSource.append(doVarMapping(result.varMapping, sLine, result.nameOnly)).append("\n");
                    
                }
                if (in_Code)
                {
                    if (sLine.contains("_ashlhi3")) result.libCCalls.put("_ashlhi3", "ashlhi3.s");
                    if (sLine.contains("_ashrhi3")) result.libCCalls.put("_ashrhi3", "ashrhi3.s");
                    if (sLine.contains("_lshrhi3")) result.libCCalls.put("_lshrhi3", "lshrhi3.s");
                    if (sLine.contains("_ashlsi3_one")) result.libCCalls.put("_ashlsi3_one", "ashlsi3_one.s");
                    if (sLine.contains("_ashrsi3_one")) result.libCCalls.put("_ashrsi3_one", "ashrsi3_one.s");
                    if (sLine.contains("_lshrsi3_one")) result.libCCalls.put("_lshrsi3_one", "lshrsi3_one.s");
                    if (sLine.contains("_mulhi3")) result.libCCalls.put("_mulhi3", "mulhi3.s");
                    if (sLine.contains("_divhi3")) result.libCCalls.put("divAndMod", "divAndMod.s");
                    if (sLine.contains("_udivhi3")) result.libCCalls.put("divAndMod", "divAndMod.s");
                    if (sLine.contains("_modhi3")) result.libCCalls.put("divAndMod", "divAndMod.s");
                    if (sLine.contains("_umodhi3")) result.libCCalls.put("divAndMod", "divAndMod.s");
                    
                    sLine = checkRAMLocations(sLine);
                    
                    codeSource.append(doVarMapping(result.varMapping, sLine, result.nameOnly)).append("\n");
                }
            }
        }
        
        result.bssInitData = bssInitSource.toString();
        result.bssData = bssSource.toString();
        result.codeData = codeSource.toString();
        result.dataData = dataSource.toString();
        
       
        
        return result;
    }
    void doCreatePeerCProject(ProjectProperties project)
    {
        String projectDirPath = de.malban.util.Utility.makeVideAbsolute(project.projectPrefix+ File.separator);
        if (!project.getBankswitching().contains("2 bank standard")) 
        {
            de.malban.util.UtilityFiles.copyDirectoryAllFiles(Global.mainPathPrefix+"template"+File.separator+"PeerC", projectDirPath);

            de.malban.util.UtilityFiles.rename(projectDirPath+"overlay"+File.separator+"c_project.png",  project.getProjectName()+".png");
            de.malban.util.UtilityFiles.rename(projectDirPath+"overlay"+File.separator+"c_project.pptx",  project.getProjectName()+".pptx");

            de.malban.util.UtilityFiles.rename(projectDirPath+"manual"+File.separator+"c_project.pdf",  project.getProjectName()+".pdf");
            de.malban.util.UtilityFiles.rename(projectDirPath+"manual"+File.separator+"c_project.pptx",  project.getProjectName()+".pptx");
        }
        else
        {
            de.malban.util.UtilityFiles.copyDirectoryAllFiles(Global.mainPathPrefix+"template"+File.separator+"PeerC.2banks", projectDirPath);

            de.malban.util.UtilityFiles.rename(projectDirPath+"overlay"+File.separator+"c_project.png",  project.getProjectName()+".png");
            de.malban.util.UtilityFiles.rename(projectDirPath+"overlay"+File.separator+"c_project.pptx",  project.getProjectName()+".pptx");

            de.malban.util.UtilityFiles.rename(projectDirPath+"manual"+File.separator+"c_project.pdf",  project.getProjectName()+".pdf");
            de.malban.util.UtilityFiles.rename(projectDirPath+"manual"+File.separator+"c_project.pptx",  project.getProjectName()+".pptx");

            project.getBankMainFiles().clear();
            project.getBankMainFiles().addElement(project.getProjectName());
            project.getBankMainFiles().addElement(project.getProjectName());
        }
        
        
 
        // set Tree to location
        inProject = true;
        currentProject = project;
        fillTree(Paths.get(de.malban.util.Utility.makeVideAbsolute(currentProject.projectPrefix)));
        
        saveProject(); // since files 
        settings.addProject(currentProject.getName(), currentProject.getCClass(), currentProject.projectPrefix);
        settings.setCurrentProject(currentProject.getName(), currentProject.getCClass(), currentProject.projectPrefix);
        updateList();
    }
    void doBuildPeerCProject()
    {
        if (startTypeRun == START_TYPE_STOP)
        {
            String fname = getSelectedEditor().getFilename();
            if (fname == null) return;

            if (fname.toLowerCase().endsWith(".c"))
            {
                doSinglePeerCFile(fname);
            }
            return;
        }
        
        
        // Build the complete project
        String preClass = currentProject.getProjectPreScriptClass();
        String preName = currentProject.getProjectPreScriptName();
        
        boolean twice = currentProject.getBankswitching().contains("2 bank standard");
        if (!twice)
        {
            String p = currentProject.projectPrefix+File.separator+"source"+File.separator;
            ExecutionDescriptor ed = new ExecutionDescriptor(ED_TYPE_PROJECT_PRE, currentProject.getProjectName(), "", "VediPanel", p);
            boolean ok =  ScriptDataPanel.executeScript(preClass, preName, this, ed);
            if (!ok) return;
        }
        else
        {
            String p = currentProject.projectPrefix+File.separator+"source"+File.separator+"bank0"+File.separator;
            ExecutionDescriptor ed = new ExecutionDescriptor(ED_TYPE_PROJECT_PRE, currentProject.getProjectName(), "", "VediPanel", p);
            boolean ok =  ScriptDataPanel.executeScript(preClass, preName, this, ed);
            if (!ok) return;
            p = currentProject.projectPrefix+File.separator+"source"+File.separator+"bank1"+File.separator;
            ed = new ExecutionDescriptor(ED_TYPE_PROJECT_PRE, currentProject.getProjectName(), "", "VediPanel", p);
            ok =  ScriptDataPanel.executeScript(preClass, preName, this, ed);
            if (!ok) return;
        }
        clearASMOutput();
        startBuildPeerCProject();
    }    

    public void startBuildPeerCProject()
    {
        if (asmStarted) return;
        asmStarted = true;
        jButtonAssemble.setEnabled(false);
        jButtonDebug.setEnabled(false);
        // paranoia!
        if (one != null) return;
        
        one = new Thread() 
        {
            public void run() 
            {
                ArrayList<VediPanel.CompileResult> crs = new ArrayList<VediPanel.CompileResult>();
                boolean asmOk = true;
                boolean twice = currentProject.getBankswitching().contains("2 bank standard");

                for (int banks=0;banks<2;banks++)
                {
                    try
                    {
                        String baseProjectPath = de.malban.util.Utility.makeVideAbsolute(currentProject.projectPrefix);

                        peerClean(baseProjectPath, banks);

                        String path;
                        String libPath;
                        if (!twice)
                        {
                            path = baseProjectPath+ File.separator+"source";
                            libPath = baseProjectPath+ File.separator+"build"+ File.separator+"lib"+ File.separator;
                        }
                        else
                        {
                            path = baseProjectPath+File.separator+"source"+File.separator+"bank"+banks;
                            libPath = baseProjectPath+ File.separator+"build"+ File.separator+"lib."+banks+ File.separator;
                        }



                        // copy all "s" files to build lib, so they get automatically included
                        File directory = new File(path);
                        File[] fList = directory.listFiles();
                        for (File file : fList) 
                        {
                            String fileNameOnly = file.getName();
                            // process only c files
                            if (!fileNameOnly.toLowerCase().endsWith(".s")) continue;
                            de.malban.util.UtilityFiles.copyOneFile(file.getAbsolutePath(), libPath+fileNameOnly);
                        }                        

                        // get all the files from a directory
                        final String failure = executeFileScripts("Pre", path);
                        if (failure!=null) 
                        {
                            if (!asmOk)
                            {
                                SwingUtilities.invokeLater(new Runnable()
                                {
                                    public void run()
                                    {
                                        printError("Error execute pre build script for: " + failure);
                                        buildPeerCProjectResult(false, true);
                                    }
                                });                    
                                one = null;
                                jButtonAssemble.setEnabled(true);
                                jButtonDebug.setEnabled(true);
                                asmStarted = false;
                                return;
                            }
                        }

                        directory = new File(path);
                        fList = directory.listFiles();

                        ArrayList<String> outNames = peerPreprocess(fList, baseProjectPath, banks);

                        if (outNames == null)
                        {
                            SwingUtilities.invokeLater(new Runnable()
                            {
                                public void run()
                                {
    //                                printError("Error preprocessing...");
                                    buildPeerCProjectResult(false, true);
                                }
                            });                    
                            one = null;
                            jButtonAssemble.setEnabled(true);
                            jButtonDebug.setEnabled(true);
                            asmStarted = false;
                            return;
                        }

                        // compile for errors
                        if (!peerCompile(fList, baseProjectPath, false, banks))
                        {
                            SwingUtilities.invokeLater(new Runnable()
                            {
                                public void run()
                                {
    //                                printError("Error compiling...");
                                    buildPeerCProjectResult(false, true);
                                }
                            });                    
                            one = null;
                            jButtonAssemble.setEnabled(true);
                            jButtonDebug.setEnabled(true);
                            asmStarted = false;
                            return;
                        }                    
                        if (currentProject.getIsCDebugging())
                        {
        // adding debug only START                    
                            // compile for enriching
                            // this enriches in current dir only "C" files
                            deleteAllCompileTargets(fList, baseProjectPath);

                            File[] fList2 = enrichCFiles(fList);
                            if (!peerCompile(fList2, baseProjectPath, true, banks))
                            {
                                deleteEnrichedCFiles(fList2);          
                                SwingUtilities.invokeLater(new Runnable()
                                {
                                    public void run()
                                    {
                                        buildPeerCProjectResult(false, true);
                                    }
                                });                    
                                one = null;
                                jButtonAssemble.setEnabled(true);
                                jButtonDebug.setEnabled(true);
                                asmStarted = false;
                                return;
                            }
                            deleteEnrichedCFiles(fList2);          
        // adding debug only END                    
                        }
                        if (!twice)
                            path = baseProjectPath+ File.separator+"build"+ File.separator+"lib";
                        else
                            path = baseProjectPath+ File.separator+"build"+ File.separator+"lib."+banks;
                        directory = new File(path);
                        fList = directory.listFiles();

                        if (!peerAssemble(fList, baseProjectPath, banks))
                        {
                            SwingUtilities.invokeLater(new Runnable()
                            {
                                public void run()
                                {
    //                                printError("Error assembling...");
                                    buildPeerCProjectResult(false, true);
                                }
                            });                    
                            one = null;
                            jButtonAssemble.setEnabled(true);
                            jButtonDebug.setEnabled(true);
                            asmStarted = false;
                            return;
                        }

                        if (!peerLink(baseProjectPath, banks))
                        {
                            SwingUtilities.invokeLater(new Runnable()
                            {
                                public void run()
                                {
    //                                printError("Error linking...");
                                    buildPeerCProjectResult(false, true);
                                }
                            });                    
                            one = null;
                            jButtonAssemble.setEnabled(true);
                            jButtonDebug.setEnabled(true);
                            asmStarted = false;
                            return;
                        }

                        if (!peerBuild(baseProjectPath, banks))
                        {
                            SwingUtilities.invokeLater(new Runnable()
                            {
                                public void run()
                                {
    //                                printError("Error building...");
                                    buildPeerCProjectResult(false, true);
                                }
                            });                    
                            one = null;
                            jButtonAssemble.setEnabled(true);
                            jButtonDebug.setEnabled(true);
                            asmStarted = false;
                            return;
                        }


                    }
                    catch (final Throwable e)
                    {
                        SwingUtilities.invokeLater(new Runnable()
                        {
                            public void run()
                            {
                                printError("Exception while building: " + e.getMessage());
                                printError(de.malban.util.Utility.getStackTrace(e));
                                buildPeerCProjectResult(false, true);
                            }
                        });   
                        one = null;
                        jButtonAssemble.setEnabled(true);
                        jButtonDebug.setEnabled(true);
                        asmStarted = false;
                        return;
                    }
                    if (!twice) break;
                } // and banks loop

                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                String postClass = currentProject.getProjectPostScriptClass();
                String postName = currentProject.getProjectPostScriptName();
                
                String pp = currentProject.projectPrefix;

                
                ExecutionDescriptor ed = new ExecutionDescriptor(ED_TYPE_PROJECT_POST, currentProject.getProjectName(), "", "VediPanel", pp);
                boolean ok =  ScriptDataPanel.executeScript(postClass, postName, VediPanel.this, ed);
                final boolean asmOk2 = asmOk; // effectivly final!
                
                
                if (!ok)
                {
                    SwingUtilities.invokeLater(new Runnable()
                    {
                        public void run()
                        {
                            buildPeerCProjectResult(false, true);
                        }
                    });                    
                    one = null;
                    jButtonAssemble.setEnabled(true);
                    jButtonDebug.setEnabled(true);
                    asmStarted = false;
                }
                else
                {
                    SwingUtilities.invokeLater(new Runnable()
                    {
                        public void run()
                        {
                            buildPeerCProjectResult(true, false);
                        }
                    });                    
                    one = null;
                    asmStarted = false;
                    jButtonAssemble.setEnabled(true);
                    jButtonDebug.setEnabled(true);
                }
            }  
        };

        one.setName("C-Build: "+currentProject.getProjectName());
        one.start();           
    }          
    protected void buildPeerCProjectResult(boolean buildOk, boolean errorPreAssembler)
    {
        refreshTree();
        if (buildOk)
        {
            if (!buildPeerCCNT())
            {
                return;
            }
            boolean twice = currentProject.getBankswitching().contains("2 bank standard");

            CartridgeProperties cartProp = buildCart(currentProject, twice);
            checkVec4EverProject(cartProp);
            if (config.invokeEmulatorAfterAssembly)
            {
                
                VecXPanel vec = ((CSAMainFrame)mParent).getVecxy();
                ((CSAMainFrame)mParent).getInternalFrame(vec).toFront();
                boolean ask = false;
                if (startTypeRun == START_TYPE_INJECT)
                {
                    CartridgeProperties oldProp = vec.getCurrentCartProp();
                    if (oldProp == null) ask = true;
                    else
                    {
                        String myName = currentProject.getProjectName();
                        String oldName = oldProp.getCartName();
                        if (!oldName.equals(myName)) ask = true;
                    }
                }
        
                boolean doit = true;
                if (ask)
                {
//                    JOptionPane pane = new JOptionPane("The bin files appear to be not compatible, inject anyway?", JOptionPane.WARNING_MESSAGE, JOptionPane.OK_CANCEL_OPTION);
//                    int answer = JOptionPaneDialog.show(pane);
                int answer = JOptionPane.showOptionDialog(Configuration.getConfiguration().getMainFrame(), 
                "The bin files appear to be not compatible, inject anyway?",
                "File not compatible",
                JOptionPane.WARNING_MESSAGE, JOptionPane.OK_CANCEL_OPTION, null, null, null);

                
                
                if (answer == JOptionPane.YES_OPTION)
                        doit = true;
                    else
                    {
                        doit = false;
                    }
                }
                if (doit)
                {
                    DebugInfoC cDebug = null;
                    vec.setNextStartCDebugInfo(cDebug);
                    vec.startCartridge(cartProp, startTypeRun);
                    printMessage("Compile successfull, starting emulation...");
                }
            }
            else
            {
                printMessage("Compile successfull...");
            }
            
            if (config.invokeVecMultiAfterAssembly) {
                loadVecMulti(cartProp);
            }
        }
        else
        {
//            printError("Compile not successfull, see ASM output...");
/*
            if (errorPreAssembler)
                jTabbedPane.setSelectedIndex(0);
            else
                jTabbedPane.setSelectedIndex(1);
*/        
        }
        refreshTree();
    }          
    
    String[] buildPeerCFLAGS(String additional, String additionalFileFlags)
    {
        if (currentProject == null) return new String[0];

        String flags = currentProject.getCFLAGS();
        boolean hasFramePointer = true;
        if (flags.contains("-fomit-frame-pointer"))
            hasFramePointer = false;
        if (flags.contains("-fno-omit-frame-pointer"))
            hasFramePointer = true;
        
        String[] splitsFile = additionalFileFlags.split(" ");
        splitsFile = removeEmpty(splitsFile);

        String[] splits = flags.split(" ");
        splits = removeEmpty(splits);

        String[] splits2 = additional.split(" ");
        splits2 = removeEmpty(splits2);
        
        for (int i=0; i<splits.length; i++)
        {
            if (splits[i].startsWith("-I"))
            {
                // "-O3 -mint8 -msoft-reg-count=0 -quiet -IC/include";
                String dir = splits[i].substring(2);
                dir = "-I"+Global.mainPathPrefix+dir;
                splits[i] = de.malban.util.UtilityFiles.convertSeperator(dir);
            }
        }

        // if locally a include directory exists - add it to the include Path
        //String path =  currentProject.projectPrefix+ File.separator;

        File directory = new File(de.malban.util.Utility.makeVideAbsolute(currentProject.projectPrefix+ File.separator+"include"));
        String additionalInclude ="";
        int additionalFlags= 5;
        additionalFlags++;
                
        if (directory.exists())
        {
            additionalInclude = "-I"+directory.getAbsolutePath();
            additionalFlags++;
        }
        
        String[] cflags = new String[splits.length+splits2.length+additionalFlags+splitsFile.length];
        
        int flagBase = 1;
        for (int i=0; i< splits.length; i++) cflags[flagBase++]=splits[i];
        for (int i=0; i< splits2.length; i++) cflags[flagBase++]=splits2[i];
        for (int i=0; i< splitsFile.length; i++) cflags[flagBase++]=splitsFile[i];

        if (additionalInclude.length()!=0)
        {
            cflags[cflags.length-4] = additionalInclude;
            if (!hasFramePointer)
                cflags[cflags.length-5] = "-DOMMIT_FRAMEPOINTER=1";
            else
                cflags[cflags.length-5] = "-DFRAME_POINTER=1";

            if (currentProject.getIsCRumInlined())
            {
                cflags[cflags.length-6] = "-D__INLINE_RUM=1";
                
            }
            else
                cflags[cflags.length-6] = "-D__RUM_FUNCTION=1";
        }
        else
        {
            if (!hasFramePointer)
                cflags[cflags.length-4] = "-DOMMIT_FRAMEPOINTER=1";
            else
                cflags[cflags.length-4] = "-DFRAME_POINTER=1";
            
            if (currentProject.getIsCRumInlined())
                cflags[cflags.length-5] = "-D__INLINE_RUM=1";
            else
                cflags[cflags.length-5] = "-D__RUM_FUNCTION=1";
        }

        
        cflags[cflags.length-2] = "-o";
        return cflags;
    }    

    ArrayList<String> peerPreprocess(File[] fList, String baseProjectPath, int banks)  
    {
        ArrayList<String> outNames = new  ArrayList<String>();
        boolean twice = currentProject.getBankswitching().contains("2 bank standard");

        {
            String path = de.malban.util.Utility.makeVideAbsolute(baseProjectPath+File.separator+"source");
            if (twice) path = path+File.separator+"bank"+banks;

            String[] CFLAGS = buildPeerCFLAGS("-E","");

            for (File file : fList) 
            {
                String fileNameOnly = file.getName();

                if (file.isDirectory())
                {
                    File directory = new File(file.getAbsoluteFile().toString());
                    File[] fList2 = directory.listFiles();
                    ArrayList<String> outNames2 = peerPreprocess(fList2, baseProjectPath, banks);
                    if (null == outNames2)
                    {
                        return null;
                    }
                    for (String on: outNames2)
                        outNames.add(on);
                    continue;
                }

                // process only c files
                if (!fileNameOnly.toLowerCase().endsWith(".c")) continue;
                fileNameOnly = de.malban.util.UtilityString.replace(fileNameOnly, ".enr.", ".");

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

                    String relPathOnly = de.malban.util.Utility.makeVideRelative(pathOnly);
                    if (relPathOnly.length()!=0) relPathOnly+=File.separator;
                    FilePropertiesPool pool = new FilePropertiesPool(relPathOnly, test.getName());

                    FileProperties fileProperties =  pool.get(fileNameOnly);
                    if (fileProperties != null) 
                    {
                        if (fileProperties.getNoInternalProcessing()) continue;
                    }
                }
                // compile file

                CFLAGS[CFLAGS.length-3] = file.getAbsolutePath();

                if (!twice) 
                {
                 CFLAGS[CFLAGS.length-1] = baseProjectPath+ File.separator+"build"+File.separator+"lib"+File.separator+fileNameBare+".i";
                }
                else
                {
                 CFLAGS[CFLAGS.length-1] = baseProjectPath+ File.separator+"build"+File.separator+"lib."+banks+File.separator+fileNameBare+".i";
                }


                outNames.add(CFLAGS[CFLAGS.length-1]);
                if (!doPeerCCompiler(CFLAGS, "Preprocessing", false))
                {
                    SwingUtilities.invokeLater(new Runnable()
                    {
                        public void run()
                        {
                            printError("Error preprocessing: " + CFLAGS[CFLAGS.length-3]);
                            buildPeerCProjectResult(false, true);
                        }
                    });                    
                    one = null;
                    jButtonAssemble.setEnabled(true);
                    jButtonDebug.setEnabled(true);
                    asmStarted = false;
                    return null;
                }
            }    
        }

        return outNames;
    }
    boolean peerCompile(File[] fList, String baseProjectPath, boolean quiet, int banks)  
    {
        boolean twice = currentProject.getBankswitching().contains("2 bank standard");
        {
            String path = baseProjectPath+File.separator+"source";
            if (twice)
            {
                path = path +File.separator+"bank"+banks;
            }
            
            for (File file : fList) 
            {
                String fileNameOnly = file.getName();
                if (file.isDirectory())
                {
                    File directory = new File(file.getAbsoluteFile().toString());
                    File[] fList2 = directory.listFiles();

                    if (!peerCompile(fList2, baseProjectPath, quiet, banks))
                    {
                        return false;
                    }
                    continue;
                }

                // process only c files
                if (!fileNameOnly.toLowerCase().endsWith(".c")) continue;
                // ensure enrciched files use the orignal file properties
                fileNameOnly = de.malban.util.UtilityString.replace(fileNameOnly, ".enr.", ".");

                String fileNameBare = fileNameOnly;


                int li = fileNameOnly.lastIndexOf(".");
                if (li>=0) 
                    fileNameBare = fileNameOnly.substring(0,li);
                if (path.length() != 0) path += File.separator;
                File test = new File(path+fileNameBare+"FileProperty.xml");
                String fileCFLAGS = "";
                if (test.exists())
                {
                    String pathOnly = test.getParent().toString();
                    if (pathOnly.length()!=0) pathOnly+=File.separator;

                    String relPathOnly = de.malban.util.Utility.makeVideRelative(pathOnly);
                    if (relPathOnly.length()!=0) relPathOnly+=File.separator;
                    FilePropertiesPool pool = new FilePropertiesPool(relPathOnly, test.getName());

                    FileProperties fileProperties =  pool.get(fileNameOnly);
                    if (fileProperties != null) 
                    {
                        if (fileProperties.getNoInternalProcessing()) continue;
                        fileCFLAGS = fileProperties.getFlags().trim();
                    }
                }
                // compile file
                String[] CFLAGS = buildPeerCFLAGS("",fileCFLAGS);

                CFLAGS[CFLAGS.length-3] = file.getAbsolutePath();
                if (!twice)
                    CFLAGS[CFLAGS.length-1] = baseProjectPath+ File.separator+"build"+File.separator+"lib"+File.separator+fileNameBare+".s";
                else
                    CFLAGS[CFLAGS.length-1] = baseProjectPath+ File.separator+"build"+File.separator+"lib."+banks+File.separator+fileNameBare+".s";
                    
                if (!doPeerCCompiler(CFLAGS, "Compiling", quiet))
                {
                    SwingUtilities.invokeLater(new Runnable()
                    {
                        public void run()
                        {
                            printError("Error compiling: " + CFLAGS[CFLAGS.length-3]);
                            buildPeerCProjectResult(false, true);
                        }
                    });                    
                    one = null;
                    jButtonAssemble.setEnabled(true);
                    jButtonDebug.setEnabled(true);
                    asmStarted = false;
                    return false;
                }
                if (peepAtASM)
                {
                    if (currentProject.getIsCPeephole())
                        FilePeeper.peepCorrectASM(CFLAGS[CFLAGS.length-1]);
                }
            }    
        } //banks loop
        
        return true;
    }
    
    void deleteAllCompileTargets(File[] fList, String baseProjectPath)
    {
        for (File file : fList) 
        {
            String fileNameOnly = file.getName();
            if (file.isDirectory())
            {
                File directory = new File(file.getAbsoluteFile().toString());
                File[] fList2 = directory.listFiles();
                deleteAllCompileTargets(fList2, baseProjectPath);
            }

            // process only c files
            if (!fileNameOnly.toLowerCase().endsWith(".c")) continue;
            String fileNameBare = fileNameOnly;
            int li = fileNameOnly.lastIndexOf(".");
            if (li>=0) 
                fileNameBare = fileNameOnly.substring(0,li);
            
            String targetName = baseProjectPath+ File.separator+"build"+File.separator+"lib"+File.separator+fileNameBare+".s";

            de.malban.util.UtilityFiles.deleteFile(targetName);
        }    
    }
    
    public boolean doPeerCCompiler(String[] flags, String stageMessage, boolean quiet)
    {
        String[] envs = null;
        if (isMac)
        {
            flags[0]=Global.mainPathPrefix+"C"+File.separator+"Mac"+File.separator+"bin"+File.separator+"cc1";
            /*
            Map<String, String> env = System.getenv();
            String envkey = "DYLD_LIBRARY_PATH";
            String envVal = env.get("DYLD_LIBRARY_PATH");
            envVal+=":"+Global.mainPathPrefix+"C"+File.separator+"Mac"+File.separator+"lib"+File.separator+"mpfr"+File.separator+"lib"+":"+Global.mainPathPrefix+"C"+File.separator+"Mac"+File.separator+"lib"+File.separator+"gmp"+File.separator+"lib";
            String envChange = envkey+"="+envVal;
            envs = new String[1];
            envs[0] = envChange;
            */
        }
        if (isWin)
        {
            if (Global.getOSBit()==64)
                flags[0]=Global.mainPathPrefix+"C"+File.separator+"Win32"+File.separator+"bin"+File.separator+"gcc6809.exe";
            else
                flags[0]=Global.mainPathPrefix+"C"+File.separator+"Win32"+File.separator+"bin"+File.separator+"gcc6809.exe";
        }
        if (isLinux)
        {
            if (Global.getOSBit()==64)
            {
                flags[0]=Global.mainPathPrefix+"C"+File.separator+"Linux64"+File.separator+"bin"+File.separator+"cc1";
                /*
                Map<String, String> env = System.getenv();
                String envkey = "LD_LIBRARY_PATH";
                String envVal = env.get("LD_LIBRARY_PATH");
                envVal+=":"+Global.mainPathPrefix+"C"+File.separator+"Linux64"+File.separator+"lib"+File.separator+"mpfr"+File.separator+"lib"+":"+Global.mainPathPrefix+"C"+File.separator+"Mac"+File.separator+"lib"+File.separator+"gmp"+File.separator+"lib";
                String envChange = envkey+"="+envVal;
                envs = new String[1];
                envs[0] = envChange;
                */
            }
            else
                flags[0]=Global.mainPathPrefix+"C"+File.separator+"Linux32"+File.separator+"bin"+File.separator+"cc1";
        }
        String flagsOut = ""; for (int i=0;i<flags.length; i++) flagsOut+= flags[i]+" " ;
        log.addLog("GCC: "+flagsOut);
        
        
        String file = flags[flags.length-3];
        String outputFile = flags[flags.length-1];

        if (!quiet)
            printNoLNMessage(stageMessage+": "+truncateFilename(file));
        

        
        try
        {
            log.addLog(stageMessage+": "+file, INFO);
            boolean ok=  executeOSCommand(flags, envs);
            

            ok = ok && (!(UtilityFiles.lastError.contains("error:")));
            
            if (ok)
            {
                if (!quiet)
                {
                    printMessage(" ... success");
                    printWarning(truncateFilename(UtilityFiles.lastError.trim()));
                    printMessage(truncateFilename(UtilityFiles.lastMessage.trim()));
                }
                return true;
            }
            
        }
        catch (Throwable e)
        {
            e.printStackTrace();
        }
        log.addLog(stageMessage+" failed: "+file, WARN);
        printError(stageMessage+" failed");
        printError((UtilityFiles.lastError.trim()));
        printError((UtilityFiles.lastMessage.trim()));
        return false;
    }    

    String[] buildPeerASMFLAGS(String additional)
    {
        String[] splits = "-x -p -l -o -y -g".split(" ");
        splits = removeEmpty(splits);

        String[] splits2 = additional.split(" ");
        splits2 = removeEmpty(splits2);
        
        String[] asmflags = new String[splits.length+splits2.length+3];
        int flagBase = 1;
        for (int i=0; i< splits.length; i++) asmflags[flagBase++]=splits[i];
        for (int i=0; i< splits2.length; i++) asmflags[flagBase++]=splits2[i];
        return asmflags;
    } 
    boolean peerAssemble(File[] fList, String baseProjectPath, int banks)  
    {
        boolean twice = currentProject.getBankswitching().contains("2 bank standard");
        {
            String path = baseProjectPath+File.separator+"source";
            if (twice) 
                path = path +File.separator+"bank"+banks;
            String[] ASMFLAGS = buildPeerASMFLAGS("");

            for (File file : fList) 
            {
                String fileNameOnly = file.getName();

                // process only c files
                if (!fileNameOnly.toLowerCase().endsWith(".s")) continue;

                ASMFLAGS[ASMFLAGS.length-2] = changeTypeTo(file.getAbsolutePath(),"rel");
                ASMFLAGS[ASMFLAGS.length-1] = file.getAbsolutePath();

                if (!doPeerAssemble(ASMFLAGS, "Assemble"))
                {
                    SwingUtilities.invokeLater(new Runnable()
                    {
                        public void run()
                        {
                            printError("Error assembling: " + ASMFLAGS[ASMFLAGS.length-3]);
                            buildPeerCProjectResult(false, true);
                        }
                    });                    
                    one = null;
                    jButtonAssemble.setEnabled(true);
                    jButtonDebug.setEnabled(true);
                    asmStarted = false;
                    return false;
                }
            }    
        } // banks loop
        
        return true;
    }
    boolean peepAtASM = true;
    public boolean doPeerAssemble(String[] flags, String stageMessage)
    {
        if (isMac)
        {
            flags[0]=Global.mainPathPrefix+"C"+File.separator+"Mac"+File.separator+"bin"+File.separator+"as6809";
        }
        if (isWin)
        {
            flags[0]=Global.mainPathPrefix+"C"+File.separator+"Win32"+File.separator+"bin"+File.separator+"as6809.exe";
        }
        if (isLinux)
        {
            if (Global.getOSBit()==64)
                flags[0]=Global.mainPathPrefix+"C"+File.separator+"Linux64"+File.separator+"bin"+File.separator+"as6809";
            else
                flags[0]=Global.mainPathPrefix+"C"+File.separator+"Linux32"+File.separator+"bin"+File.separator+"as6809";
        }
        String file = flags[flags.length-1];
        String outputFile = flags[flags.length-2];

        String flagsOut = ""; for (int i=0;i<flags.length; i++) flagsOut+= flags[i]+" " ;
        log.addLog("ASM: "+flagsOut);
        
        printNoLNMessage(stageMessage+": "+truncateFilename(file));
        
        try
        {
/*
            if (peepAtASM)
            {
                peepCorrectASM(file);
            }
*/            
            
            
            log.addLog(stageMessage+": "+file, INFO);
            boolean ok=  executeOSCommand(flags);
            
            String tt= UtilityFiles.lastError;
            ok = ok && (!(UtilityFiles.lastError.toLowerCase().contains("error")));
            
            if (ok)
            {
                printMessage(" ... success");
                printWarning(truncateFilename(UtilityFiles.lastError.trim()));
                printMessage(truncateFilename(UtilityFiles.lastMessage.trim()));
                return true;
            }
            
        }
        catch (Throwable e)
        {
            e.printStackTrace();
        }
        log.addLog(stageMessage+" failed: "+file, WARN);
        printError(" ... failed");
        printError((UtilityFiles.lastError.trim()));
        printError((UtilityFiles.lastMessage.trim()));
        return false;

    }    

    String[] buildPeerLINKFLAGS(String additional1, String[] additional3)
    {
        if (currentProject == null) return new String[0];
        int extras = currentProject.getExtras();
        boolean is48K = (extras & Cartridge.FLAG_48K) != 0;
        
        
  //      String options="-n -m -u -w -s -k GCCLIB -l libgcov.a -l as-libgcc.a -l libgcc.a PROJECTS19 GCCLIBREL";
        
        String path = Global.mainPathPrefix+"C"+File.separator+"PeerC"+File.separator+"vectrex"+File.separator+"lib";
        File directory = new File(path);
        File[] fList = directory.listFiles();
        
        ArrayList<String> additional2 = new ArrayList<String>();
        // needs crt0 to be first?
        for (File file : fList) 
        {
            String fileNameOnly = file.getName();
//            if (is48K)
//            {
//                if (!fileNameOnly.toLowerCase().contains("crt0_48.rel")) continue;
//            }
//            else
//            {
                if (!fileNameOnly.toLowerCase().contains("crt0.rel")) continue;
//            }
            additional2.add(file.getAbsolutePath());
            break;
        }

        for (File file : fList) 
        {
            String fileNameOnly = file.getName();
            if (fileNameOnly.contains("crt0")) continue;
            if (!fileNameOnly.toLowerCase().endsWith(".rel")) continue;
            
            // function library not needed, when inlining is active!
            if (currentProject.getIsCRumInlined())
            {
                if (fileNameOnly.contains("vec_rum_fct_pjc.rel")) continue;
            }
            
            additional2.add(file.getAbsolutePath());
        }        
        String libPath = Global.mainPathPrefix+"C"+File.separator+"PeerC"+File.separator+"vectrex"+File.separator+"lib"+File.separator;

        
        ArrayList<String> allOptions= new ArrayList<String>();
        allOptions.add("-n");
        allOptions.add("-m");
        allOptions.add("-u");
        allOptions.add("-w");
        allOptions.add("-s");
        allOptions.add("-k");
        allOptions.add(libPath);
        allOptions.add("-l");
        allOptions.add("rum.lib");
        allOptions.add("-l");
        allOptions.add("libgcc.lib");
        allOptions.add("-l");
        allOptions.add("gcc.lib");
        allOptions.add("-l");
        allOptions.add("assert.lib");
        
        
//        -k %GCC%/vectrex/lib/lib/ -l assert.lib
        
        
        allOptions.add(additional1);
        for (String additional21 : additional2) allOptions.add(additional21);
        for (String additional31 : additional3) allOptions.add(additional31);
        
        String[] asmflags = new String[allOptions.size()+1];
        int flagBase = 1;
        for (int i=0; i< allOptions.size(); i++) 
            asmflags[flagBase++]=allOptions.get(i);
        return asmflags;
    } 
    
  
    
    boolean peerLink(String baseProjectPath, int banks)  
    {
        boolean twice = currentProject.getBankswitching().contains("2 bank standard");
        {
            String path = baseProjectPath+File.separator+"build";
            path = baseProjectPath+ File.separator+"build"+ File.separator+"lib";
            if (twice)
                path = path+ "."+banks;
            
            File directory = new File(path);
            File[] fList = directory.listFiles();
            ArrayList<String> files = new ArrayList<String>();
            for (File file : fList) 
            {
                String fileNameOnly = file.getName();
                if (!fileNameOnly.toLowerCase().endsWith(".rel")) continue;
                files.add(file.getAbsolutePath());
            }

            // if locally a lib directory exists - grab all rel files in there too
            if (!twice)
                directory = new File(baseProjectPath+ File.separator+"lib");
            else
                directory = new File(baseProjectPath+ File.separator+"lib."+banks);
            if (directory.exists())
            {
                fList = directory.listFiles();
                for (File file : fList) 
                {
                    String fileNameOnly = file.getName();
                    if (!fileNameOnly.toLowerCase().endsWith(".rel")) continue;
                    files.add(file.getAbsolutePath());
                }
            }

            // and all RAM/ROM definitions
            directory = new File(Global.mainPathPrefix+"C"+File.separator+"PeerC"+File.separator+"vectrex"+File.separator+"lib"+File.separator+"static"+File.separator);
            if (directory.exists())
            {
                fList = directory.listFiles();
                for (File file : fList) 
                {
                    String fileNameOnly = file.getName();
                    if (!fileNameOnly.toLowerCase().endsWith(".rel")) continue;
                    files.add(file.getAbsolutePath());
                }
            }


            String[] LINKFLAGS;
            if (!twice)
                LINKFLAGS = buildPeerLINKFLAGS(baseProjectPath+File.separator+"build"+File.separator+currentProject.getProjectName()+".s19", files.toArray(new String[0]));
            else
                LINKFLAGS = buildPeerLINKFLAGS(baseProjectPath+File.separator+"build"+File.separator+currentProject.getProjectName()+"_"+banks+".s19", files.toArray(new String[0]));

            if (!doPeerLink(LINKFLAGS, "Link"))
            {
                SwingUtilities.invokeLater(new Runnable()
                {
                    public void run()
                    {
                        printError("Error linking... " );
                        buildPeerCProjectResult(false, true);
                    }
                });                    
                one = null;
                jButtonAssemble.setEnabled(true);
                jButtonDebug.setEnabled(true);
                asmStarted = false;
                return false;
            }
        } // bank loop
        return true;
    }
    public boolean doPeerLink(String[] flags, String stageMessage)
    {
        if (isMac)
        {
            flags[0]=Global.mainPathPrefix+"C"+File.separator+"Mac"+File.separator+"bin"+File.separator+"aslink";
        }
        if (isWin)
        {
            flags[0]=Global.mainPathPrefix+"C"+File.separator+"Win32"+File.separator+"bin"+File.separator+"aslink.exe";
        }
        if (isLinux)
        {
            if (Global.getOSBit()==64)
                flags[0]=Global.mainPathPrefix+"C"+File.separator+"Linux64"+File.separator+"bin"+File.separator+"aslink";
            else
                flags[0]=Global.mainPathPrefix+"C"+File.separator+"Linux32"+File.separator+"bin"+File.separator+"aslink";
        }
        String outputFile = flags[flags.length-2];

        String flagsOut = ""; for (int i=0;i<flags.length; i++) flagsOut+= flags[i]+" " ;
        log.addLog("LINK: "+flagsOut);
        
        String to="";
        String libs="";
        String rels="";
        for (int i=0;i<flags.length; i++)
        {
            if (flags[i].trim().endsWith(".a")) 
            {
                if (libs.length()>0) libs+=" ";
                libs+=flags[i];
            }
            if (flags[i].trim().endsWith(".s19")) 
            {
                if (to.length()>0) to+=" ";
                to+=flags[i];
            }
            if (flags[i].trim().endsWith(".rel")) 
            {
                if (rels.length()>0) rels+=" ";
                rels+=flags[i];
            }
        }
        String msg = libs+" "+rels+" to "+to;
        msg = truncateFilename(msg);
        printNoLNMessage(stageMessage+": "+msg);
        
        
        try
        {
            log.addLog(stageMessage+" ...", INFO);
            boolean ok=  executeOSCommand(flags);
            int explain = 0;
            String errorMessage = UtilityFiles.lastError;
            if (errorMessage.contains("?ASlink-Warning-Undefined Global"))
                ok = false;

            if (errorMessage.contains("?ASlink-Warning-PageN relocation error"))
                explain = 1;
          
            errorMessage = de.malban.util.UtilityString.replace(errorMessage, "?ASlink-Warning-PageN relocation error", "?ASlink-Warning-PageN relocation WARNING!");
            
            
            
            ok = ok && (!(errorMessage.toLowerCase().contains("error")));
            ok = ok && (!(UtilityFiles.lastMessage.toLowerCase().contains("error")));
            
            if (ok)
            {
                printMessage(" ... success");
                printWarning(truncateFilename(UtilityFiles.lastError.trim()));
                printMessage(truncateFilename(UtilityFiles.lastMessage.trim()));
                if (explain==1)
                {
                    printMessage("The above warning happens if direct access is used to another page than the current.\nThis is frequently the case, when accessing VIA.");
                }
                return true;
            }
            
        }
        catch (Throwable e)
        {
            e.printStackTrace();
        }
        log.addLog(stageMessage+" failed ", WARN);
        printError(" ... failed");
        printError(UtilityFiles.lastError);
        printError(UtilityFiles.lastMessage);
        return false;
    } 

    
    String[] buildPeerSREC(String options)
    {
        if (currentProject == null) return new String[0];
        String[] splits = options.split(" ");
        splits = removeEmpty(splits);

        String[] asmflags = new String[splits.length+3];
        int flagBase = 1;
        for (int i=0; i< splits.length; i++) asmflags[flagBase++]=splits[i];
        return asmflags;
    } 
    boolean peerBuild(String baseProjectPath, int banks)  
    {
        boolean twice = currentProject.getBankswitching().contains("2 bank standard");
        {
            String msg ="";
            String path = baseProjectPath+File.separator+"build";

            String romBase="_rom";
            String ramBase="_ram";
            String binBase=".bin";

            if (twice)
            {
                romBase="_"+banks+"_rom";
                ramBase="_"+banks+"_ram";
                binBase="_"+banks+".bin";
            }
            
            String fromS19 = baseProjectPath+File.separator+"build"+File.separator+currentProject.getProjectName()+romBase+".s19";
            String toBin = baseProjectPath+File.separator+"build"+File.separator+currentProject.getProjectName()+romBase+".bin";
            msg+="build"+File.separator+currentProject.getProjectName()+romBase+".s19";
            msg+="->";
            msg+="build"+File.separator+currentProject.getProjectName()+romBase+".bin";
            String[] SRECFLAGS = buildPeerSREC("-q");
            SRECFLAGS[SRECFLAGS.length-2] = fromS19;
            SRECFLAGS[SRECFLAGS.length-1] = toBin;
            boolean ok = true;
            ok = ok && doPeerBuild(SRECFLAGS, "SREC2BIN: "+msg);

            String fromS19ram = baseProjectPath+File.separator+"build"+File.separator+currentProject.getProjectName()+ramBase+".s19";
            String toBinram = baseProjectPath+File.separator+"build"+File.separator+currentProject.getProjectName()+ramBase+".bin";
            boolean ramExists = new File(fromS19ram).exists();
            if (ramExists)
            {
                msg ="build"+File.separator+currentProject.getProjectName()+ramBase+".s19";
                msg+="->";
                msg+="build"+File.separator+currentProject.getProjectName()+ramBase+".bin";
                SRECFLAGS = buildPeerSREC("-q -o -0xc880");
                SRECFLAGS[SRECFLAGS.length-2] = fromS19ram;
                SRECFLAGS[SRECFLAGS.length-1] = toBinram;
                ok = ok && doPeerBuild(SRECFLAGS, "SREC2BIN: "+msg);

                printMessage("Concatinate: "+"build"+File.separator+currentProject.getProjectName()+romBase+".bin"+" + "+"build"+File.separator+currentProject.getProjectName()+ramBase+".bin"+" to "+"bin"+File.separator+currentProject.getProjectName()+binBase);
                ok = ok && de.malban.util.UtilityFiles.concatFiles(toBin, toBinram, baseProjectPath+File.separator+"bin"+File.separator+currentProject.getProjectName()+binBase);
            }
            else
            {
                printMessage("copy: "+"build"+File.separator+currentProject.getProjectName()+"_rom.bin"+" to "+"bin"+File.separator+currentProject.getProjectName()+binBase);
                ok = ok && de.malban.util.UtilityFiles.copyOneFile(toBin, baseProjectPath+File.separator+"bin"+File.separator+currentProject.getProjectName()+binBase);
            }


            if (!ok)
            {
                SwingUtilities.invokeLater(new Runnable()
                {
                    public void run()
                    {
                        printError("Error linking... " );
                        buildPeerCProjectResult(false, true);
                    }
                });                    
                one = null;
                jButtonAssemble.setEnabled(true);
                jButtonDebug.setEnabled(true);
                asmStarted = false;
                return false;
            }
        }
        return true;
    }
    public boolean doPeerBuild(String[] flags, String stageMessage)
    {
        if (isMac)
        {
            flags[0]=Global.mainPathPrefix+"C"+File.separator+"Mac"+File.separator+"bin"+File.separator+"srec2bin";
        }
        if (isWin)
        {
            flags[0]=Global.mainPathPrefix+"C"+File.separator+"Win32"+File.separator+"bin"+File.separator+"srec2bin.exe";
        }
        if (isLinux)
        {
        if (Global.getOSBit()==64)
            flags[0]=Global.mainPathPrefix+"C"+File.separator+"Linux64"+File.separator+"bin"+File.separator+"srec2bin";
        else
            flags[0]=Global.mainPathPrefix+"C"+File.separator+"Linux32"+File.separator+"bin"+File.separator+"srec2bin";
        }
        String flagsOut = ""; for (int i=0;i<flags.length; i++) flagsOut+= flags[i]+" " ;
        log.addLog("SREC: "+flagsOut);

        

                
        
        printNoLNMessage(stageMessage);
        
        try
        {
            log.addLog(stageMessage+" ", INFO);
            boolean ok=  executeOSCommand(flags);
            
            ok = ok && (!(UtilityFiles.lastError.toLowerCase().contains("error")));
            ok = ok && (!(UtilityFiles.lastMessage.toLowerCase().contains("error")));
            
            if (ok)
            {
                printMessage(" ... success");
                printWarning(truncateFilename(UtilityFiles.lastError.trim()));
                printMessage(truncateFilename(UtilityFiles.lastMessage.trim()));
                return true;
            }
            
        }
        catch (Throwable e)
        {
            e.printStackTrace();
        }
        log.addLog(stageMessage+" failed ", WARN);
        printError(" ... failed");
        printError(UtilityFiles.lastError);
        printError(UtilityFiles.lastMessage);
        return false;
    }    
    void peerClean(String baseProjectPath, int banks)
    {
        boolean twice = currentProject.getBankswitching().contains("2 bank standard");
        if (!twice)
        {
        }
        else
        {
            if (banks == 0)
            {
                de.malban.util.UtilityFiles.cleanDirectory(baseProjectPath+File.separator+"bin");
                de.malban.util.UtilityFiles.cleanDirectory(baseProjectPath+File.separator+"build");
            }
        }
        if (!twice)
        {
            File f = new File(baseProjectPath+File.separator+"build"+File.separator+"lib");
            f.mkdir();
        }
        else
        {
            File f = new File(baseProjectPath+File.separator+"build"+File.separator+"lib."+banks);
            f.mkdir();
        }
        printMessage("Cleaned...");
        log.addLog("Clean was run...");
    }
    void doSinglePeerCFile(final String fname)
    {
        if (asmStarted) return;
        asmStarted = true;
        jButtonAssemble.setEnabled(false);
        jButtonDebug.setEnabled(false);
        // paranoia!
        if (one != null) return;
        
        one = new Thread() 
        {
            public void run() 
            {
                boolean asmOk = true;
                try
                {
                    String baseProjectPath = currentProject.projectPrefix;

                    peerClean(baseProjectPath,-1);
                 
                    String path = de.malban.util.Utility.makeVideAbsolute(baseProjectPath+ File.separator+"source");
                    File[] fList = new File[1];
                    fList[0] = new File(fname);
                    ArrayList<String> res = peerPreprocess(fList, baseProjectPath,-1);
                    if (res == null)
                    {
                        SwingUtilities.invokeLater(new Runnable()
                        {
                            public void run()
                            {
                                buildPeerCProjectResult(false, true);
                            }
                        });                    
                        one = null;
                        jButtonAssemble.setEnabled(true);
                        jButtonDebug.setEnabled(true);
                        asmStarted = false;
                        refreshTree();

                        return;
                    }
                    
                    if (!peerCompile(fList, baseProjectPath, false, -1))
                    {
                        SwingUtilities.invokeLater(new Runnable()
                        {
                            public void run()
                            {
                                buildPeerCProjectResult(false, true);
                            }
                        });                    
                        one = null;
                        jButtonAssemble.setEnabled(true);
                        jButtonDebug.setEnabled(true);
                        asmStarted = false;
                        refreshTree();
                        return;
                    }
                    path = baseProjectPath+ File.separator+"build"+ File.separator+"lib";
                    File directory = new File(path);
                    
                    
                    
                    String sName = path +File.separator+changeTypeTo(nameOnly(fname),"s");
                    fList[0] = new File(sName);

                    
                    if (!peerAssemble(fList, baseProjectPath, -1))
                    {
                        SwingUtilities.invokeLater(new Runnable()
                        {
                            public void run()
                            {
//                                printError("Error assembling...");
                                buildPeerCProjectResult(false, true);
                            }
                        });                    
                        one = null;
                        jButtonAssemble.setEnabled(true);
                        jButtonDebug.setEnabled(true);
                        asmStarted = false;
                        refreshTree();
                        return;
                    }
                }
                catch (final Throwable e)
                {
                    SwingUtilities.invokeLater(new Runnable()
                    {
                        public void run()
                        {
                            printError("Exception while building: " + e.getMessage());
                            printError(de.malban.util.Utility.getStackTrace(e));
                            buildPeerCProjectResult(false, true);
                        }
                    });   
                    one = null;
                    jButtonAssemble.setEnabled(true);
                    jButtonDebug.setEnabled(true);
                    asmStarted = false;
                    refreshTree();
                    return;
                }
                printMessage("Compile successfull...");
                
                one = null;
                asmStarted = false;
                jButtonAssemble.setEnabled(true);
                jButtonDebug.setEnabled(true);
                refreshTree();
            }  
        };

        one.setName("C-Build: "+currentProject.getProjectName());
        one.start();                   
    }
    boolean buildPeerCCNT()
    {
        boolean twice = currentProject.getBankswitching().contains("2 bank standard");
        
        for (int banks = 0; banks<2;banks++)
        {

            // do map file        
            CartridgeProperties cart = new CartridgeProperties();
            String  cntFilename;
            StringBuilder buf = new StringBuilder();
            String baseProjectPath = de.malban.util.Utility.makeVideAbsolute(currentProject.projectPrefix);
            String pathBuildLib = baseProjectPath+ File.separator+"build"+ File.separator+"lib";
            ASMap asmap;
            String pathSource = baseProjectPath+ File.separator+"source";
            String pathBuild = baseProjectPath+ File.separator+"build";
            String pathUsrLib = baseProjectPath+ File.separator+"lib";
    
            if (!twice)
            {
                cntFilename = de.malban.util.Utility.makeVideAbsolute(currentProject.projectPrefix+File.separator+"bin"+File.separator+currentProject.getProjectName() +".cnt");
                asmap = parseMap(pathBuild+File.separator+currentProject.getProjectName()+".map");
            }
            else
            {
                cntFilename = de.malban.util.Utility.makeVideAbsolute(currentProject.projectPrefix+File.separator+"bin"+File.separator+currentProject.getProjectName()+"_"+banks +".cnt");
                buf.append("BANK "+banks+"\n");
                pathBuildLib = baseProjectPath+ File.separator+"build"+ File.separator+"lib."+banks;
                asmap = parseMap(pathBuild+File.separator+currentProject.getProjectName()+"_"+banks+".map");
            }

    

            File directory = new File(de.malban.util.Utility.makeVideAbsolute(currentProject.projectPrefix));
            File[] fList = directory.listFiles();



            if (currentProject.getIsCDebugging())
                buf.append("HIGHEST_USED_RAM "+String.format("$%04X", (asmap.highestUsedRAM&0xffff))+"\n");
            buf.append("COMMENT "+String.format("$%04X", (asmap.highestUsedRAM&0xffff))+" not used RAM onword...\n");


            if (currentProject.getIsCDebugging())
                FilePeeper.peepsFound /=2; // each compile is done 2 times.

            printMessage("Header size: "+asmap.headerLength+", Rom size: "+asmap.romLength+", iRam size: "+asmap.initializedRAMUsage+", uRam size: "+asmap.unInitializedRAMUsage+", PF: "+FilePeeper.peepsFound );

            int extras = currentProject.getExtras();
            boolean is48K = (extras & Cartridge.FLAG_48K) != 0;


            int maxSize = 32768;
            if (is48K) maxSize += 16384;
            if (asmap.romLength > maxSize)
            {
                printError("Resulting ROM exceeds maximum size!");
                return false;
            }


            String pathCLib = Global.mainPathPrefix+"C"+File.separator+"PeerC"+File.separator+"vectrex"+File.separator+"lib";
            directory = new File(pathCLib);
            fList = directory.listFiles();

            // all std C files
            ArrayList<String> files = new ArrayList<String>();
            for (File file : fList) 
            {
                String fileNameOnly = file.getName();
                if (!fileNameOnly.toLowerCase().endsWith(".rst")) continue;
                files.add(file.getAbsolutePath());
            }

            // all files of usr lib
            directory = new File(pathUsrLib);
            if (directory.exists())
            {
                fList = directory.listFiles();
                for (File file : fList) 
                {
                    String fileNameOnly = file.getName();
                    if (!fileNameOnly.toLowerCase().endsWith(".rst")) continue;
                    files.add(file.getAbsolutePath());
                }
            }

            // all files of project

            directory = new File(pathBuildLib);
            fList = directory.listFiles();
            for (File file : fList) 
            {
                String fileNameOnly = file.getName();
                if (!fileNameOnly.toLowerCase().endsWith(".rst")) continue;
                files.add(file.getAbsolutePath());
            }












            RSTInfo rst = parseRSTs(files);

            for (MemInfo info :rst.m)
            {
                if (info.label.length() != 0)
                {
                    String label = info.label;
                    if (((info.address&0xffff)<=0xff) && (label.contains("_dp_")))
                    {
                        // blend out all peer "dp things that lie in the zero page"
                        label = removeDP_LABELs(label);

                    }
                    buf.append("LABEL ").append(String.format("$%04X", (info.address&0xffff))).append(" ").append(label).append("\n");
                }
            }

            for (MemInfo info :rst.m)
            {

                if (info.comment.length() != 0)
                {
                    String c = info.comment;
                    c = de.malban.util.UtilityString.replace(c, "rum:", "");
                    c = de.malban.util.UtilityString.replace(c, "rum", "");
                    c = de.malban.util.UtilityString.replace(c, "cold reset:", "");
                    c = de.malban.util.UtilityString.replace(c, "cold reset", "");
                    c = de.malban.util.UtilityString.replace(c, "cmpqi:(R):", "");
                    c = de.malban.util.UtilityString.replace(c, "cmpqi:(R)", "");
                    c = de.malban.util.UtilityString.replace(c, "cmpqi", "");


                    if (c.trim().length()==0) continue;
                    /*
                    c = c.trim();
                    c = de.malban.util.UtilityString.replace(c, "::",":").trim();
                    if (c.startsWith(":")) c = c.substring(1);
                    if (c.endsWith(":")) c = c.substring(0, c.length()-1);
                    */
                    if (((info.address&0xffff)<=0xff) && (info.label.contains("_dp_")))
                    {
                        // blend out all peer "dp things that lie in the zero page"
                    }
                    else
                        buf.append("COMMENT "+String.format("$%04X", (info.address&0xffff))+" "+c+"\n");

               }
            }
            for (MemInfo info :rst.m)
            {
                if (info.lineComment.length() != 0)
                {
                    String c = info.lineComment;
                    buf.append("COMMENT_LINE "+String.format("$%04X", (info.address&0xffff))+" "+c+"\n");
               }
            }

            // CINfo
            for (MemInfo info :rst.m)
            {
                if (info.cInfo != null)
                {
                    CInfoBlock c = info.cInfo;
                    if (c.hasBreakpoint)
                        buf.append("C_INFO_BLOCK "+String.format("$%04X", (info.address&0xffff))+" \""+c.file+" \"FN_END "+c.lineNo+" \""+c.lineString+" \" BKPOINT=1\n");
                    else
                        buf.append("C_INFO_BLOCK "+String.format("$%04X", (info.address&0xffff))+" \""+c.file+" \"FN_END "+c.lineNo+" \""+c.lineString+" \" BKPOINT=0\n");
               }
            }

            int a = 0;

            while (a<0x8000)
                a = addConsecutiveType(a, rst, buf);


            try
            {
                PrintWriter out = new PrintWriter(cntFilename);
                out.println(buf.toString());
                out.close();
            }
            catch (Throwable e)
            {
                System.out.println("Error saving CNT file...");
                return false;
            }


            if (!twice) break;
        } // end banks loop
        
                
                
        return true;
    }
    
    String removeDP_LABELs(String in)
    {
        String out="";
        String[] parts = in.split(":");
        parts = removeEmpty(parts);
        for (String l:parts)
        {
            if (l.contains("_dp_")) continue;
            if (out.length()>0) out+=":";
            out+=l.trim();
        }
        return out;
    }

    
    int addConsecutiveType(int start, RSTInfo rst, StringBuilder buf)
    {
        if (start > 0x7fff) return Integer.MAX_VALUE;
        
        int length = rst.m[start].typeLength;
        int type = rst.m[start].type;
        int end = start+rst.m[start].typeLength;
        
        while (end < 0x8000)
        {
            if (rst.m[end].type != type) break;


            length += rst.m[end].typeLength;
            end += rst.m[end].typeLength;
        }
        if (end>0x8000) end = 0x8000;
        switch (type)
        {
            case CNT_DATA_BYTE:
            {
                buf.append("RANGE "+String.format("$%04X", (start&0xffff))+"-"+String.format("$%04X", ((start+length)&0xffff))+" DB_DATA"+" 8\n");
                break;
            }
            case CNT_DATA_CHAR:
            {
                buf.append("RANGE "+String.format("$%04X", (start&0xffff))+"-"+String.format("$%04X", ((start+length)&0xffff))+" CHAR_DATA"+" 20\n");
                break;
            }
            case CNT_DATA_WORD:
            {
                buf.append("RANGE "+String.format("$%04X", (start&0xffff))+"-"+String.format("$%04X", ((start+length)&0xffff))+" DW_DATA"+" 4\n");
                break;
            }
            case CNT_CODE:
            {
                buf.append("RANGE "+String.format("$%04X", (start&0xffff))+"-"+String.format("$%04X", ((start+length)&0xffff))+" CODE"+"\n");
                break;
            }
        }

        
        return end;
    }
    
    
    class Area
    {
        public int baseAddress=0;
        public int length = 0;
        public String fullname="";
        ArrayList<GlobalSymbols> symbols = new ArrayList<GlobalSymbols>();
        public boolean isROM = true;
        public Area(String line)
        {
            // line as in: 
            // .cartridge                 0000        0020 =          32. bytes (REL,CON,CSEG)
            line = de.malban.util.UtilityString.replaceWhiteSpaces(line, " ");
            line = de.malban.util.UtilityString.replace(line, "  ", " ").trim();
            String[] split = line.split(" ");
            split = removeEmpty(split);
            fullname = split[0];
            baseAddress = DASM6809.toNumber("$"+split[1]);
            length = DASM6809.toNumber("$"+split[2]);
            isROM = baseAddress<0xc800;
        }
    }
    class GlobalSymbols
    {
        public int relativeAddress=0; // in rel file
        public int absolutAddress=0;  // in final bin file
        public String fullname="";
        public GlobalSymbols(String line, Area a)
        {
            // line as in: 
            // C880  __mc6809                           mc6809.c
            line = de.malban.util.UtilityString.replaceWhiteSpaces(line, " ");
            line = de.malban.util.UtilityString.replace(line, "  ", " ").trim();
            String[] split = line.split(" ");
            split = removeEmpty(split);
            absolutAddress = DASM6809.toNumber("$"+split[0]);
            relativeAddress = absolutAddress- a.baseAddress;
            fullname = split[1];
        }
        
    }
    class ASMap
    {
        public ArrayList<Area> area = new ArrayList<Area>();
        int initializedRAMUsage = 0;
        int unInitializedRAMUsage = 0;
        int headerLength = 0;
        int romLength = 0;
        int highestUsedRAM = 0;
    }
    ASMap parseMap(String mapFile)
    {
        File f = new File(mapFile);
        if (f==null) return null;
        ASMap m = new ASMap();
        Vector<String>lines = de.malban.util.UtilityString.readTextFileToStringNoTab(f);
        int areaCount = 0;
        for (int i=0; i< lines.size(); i++)
        {
            String line = lines.elementAt(i);
            
            if (line.startsWith(".data"))
            {
                //.data                      C880        004C =          76. bytes (REL,CON,CSEG)
                String[] split = line.split(" ");
                split = removeEmpty(split);
                m.initializedRAMUsage = DASM6809.toNumber("$"+split[2]);

                int localHi = DASM6809.toNumber("$"+split[1]) + DASM6809.toNumber("$"+split[2]);
                if (m.highestUsedRAM<localHi) m.highestUsedRAM = localHi;
            }
            if (line.startsWith(".bss"))
            {
                //.bss                       C8CC        016F =         367. bytes (REL,CON,CSEG)
                String[] split = line.split(" ");
                split = removeEmpty(split);
                m.unInitializedRAMUsage = DASM6809.toNumber("$"+split[2]);
                
                int localHi = DASM6809.toNumber("$"+split[1]) + DASM6809.toNumber("$"+split[2]);
                if (m.highestUsedRAM<localHi) m.highestUsedRAM = localHi;
            }
            if (line.startsWith(".cartridge"))
            {
                //.cartridge                 0000        001D =          29. bytes (REL,CON,CSEG)
                String[] split = line.split(" ");
                split = removeEmpty(split);
                m.headerLength = DASM6809.toNumber("$"+split[2]);
            }
            if (line.startsWith(".text"))
            {
                //.text                      001D        2110 =        8464. bytes (REL,CON,CSEG)
                String[] split = line.split(" ");
                split = removeEmpty(split);
                m.romLength = DASM6809.toNumber("$"+split[2]);
            }
            
            
            
        }
        
        for (int i=0; i< lines.size(); i++)
        {
            String line = lines.elementAt(i);
            if (line.contains("Files Linked")) break; // we are done here
            if (!line.contains("Area")) continue;
            areaCount++;
            if (areaCount==1) continue;
            // now we start at an interesing point in the file
            // skip this line, and the next
            i+=2;
            line = lines.elementAt(i);
            Area a = new Area(line);
            m.area.add(a);
            
            while (!line.contains("Global")) line = lines.elementAt(i++);
            // skip this line, and the next
            i+=2;
            while (line.trim().length() != 0)
            {
                // here each line is a global symbol
                GlobalSymbols gs = new GlobalSymbols(line, a);
                a.symbols.add(gs);
                line = lines.elementAt(i++);
            }
            
        }
        
        return m;
    }
    
    final int CNT_UNKOWN = 0;
    final int CNT_CODE = 1;
    final int CNT_DATA_WORD = 2;
    final int CNT_DATA_BYTE = 3;
    final int CNT_DATA_CHAR = 4;
    class CInfoBlock
    {
        boolean hasBreakpoint = false;
        int lineNo=0;
        String file="";
        String lineString = "";
        int address =0;
    }
    class MemInfo
    {
        String label="";
        int address = 0;
        int type = CNT_UNKOWN;
        int typeLength = 1;
        String comment="";
        String lineComment="";
        CInfoBlock cInfo = null;
        boolean hasBreakpoint = false;
        MemInfo(int i)
        {
            address = i;
        }
    }
    class ValueName
    {
        int size=0; // bytes
        int value=0;
        String name ="";
    }
    class StackFrame
    {
        int start=0;
        int end=0;
        int size=0; // bytes
        String frameReg = "u"; // or s
        ArrayList<ValueName> defs = new ArrayList<ValueName>();
    }
    class RSTInfo
    {
        MemInfo[] m = new MemInfo[65536];
        ArrayList<StackFrame> stackFrames = new ArrayList<StackFrame>();
        
        void setLabel(int a, String l)
        {
            if (l.startsWith("LBE")) return;
            if (l.startsWith("LBB")) return;
            if (l.startsWith("Lscope")) return;
            if (l.startsWith("LFBB")) return;
            if (l.startsWith("Ltext")) return;
            if (m[a].label.length() != 0)
            {
                if (m[a].label.startsWith("_"))
                    m[a].label = m[a].label +":"+ l;
                else
                    m[a].label = l + ":"+m[a].label;
            }
            else
                m[a].label = l;
        }
        void setType(int a, int t, int l)
        {
            m[a].type = t;
            m[a].typeLength = l;
            while (a+l>65536) l--;
            String comment = m[a].comment;

            for (int i=1;i<l;i++)
            {
                m[a+i].type = t;
                m[a+i].typeLength = l-i;
                if (m[a+1].comment.length()!=0)
                {
                    if (comment.length()!=0)
                    {
                        comment +=":";
                    }
                    comment += m[a+i].comment;
                }
            }
            setComment(a, comment);
        }
        void setLineComment(int a, String c)
        {
            m[a].lineComment = c;
        }
        void setComment(int a, String c)
        {
            String test = c.trim();
            test = de.malban.util.UtilityString.replace(test, ",","").trim();
            test = de.malban.util.UtilityString.replace(test, ":","").trim();
            test = de.malban.util.UtilityString.replace(test, ";","").trim();
            test = de.malban.util.UtilityString.replace(test, "*","").trim();
            test = de.malban.util.UtilityString.replace(test, "i","").trim();
            test = de.malban.util.UtilityString.replace(test, "0","").trim();
            test = de.malban.util.UtilityString.replace(test, "1","").trim();
            test = de.malban.util.UtilityString.replace(test, "2","").trim();
            test = de.malban.util.UtilityString.replace(test, "3","").trim();
            test = de.malban.util.UtilityString.replace(test, "4","").trim();
            test = de.malban.util.UtilityString.replace(test, "5","").trim();
            test = de.malban.util.UtilityString.replace(test, "6","").trim();
            test = de.malban.util.UtilityString.replace(test, "7","").trim();
            test = de.malban.util.UtilityString.replace(test, "8","").trim();
            test = de.malban.util.UtilityString.replace(test, "9","").trim();
            test = de.malban.util.UtilityString.replace(test, "D","").trim();
            test = de.malban.util.UtilityString.replace(test, "i","").trim();
            test = de.malban.util.UtilityString.replace(test, "t","").trim();
            test = de.malban.util.UtilityString.replace(test, ".","").trim();
            test = de.malban.util.UtilityString.replaceCI(test, "tmp","").trim();

            test = de.malban.util.UtilityString.replace(test, "::",":").trim();
            if (test.startsWith(":")) test = test.substring(1);
            if (test.endsWith(":")) test = test.substring(0, test.length()-1);
            if (test.startsWith(",")) test = test.substring(1);
            if (test.startsWith(";")) test = test.substring(1);
            if (test.endsWith(",")) test = test.substring(0, test.length()-1);
            test = test.trim();
            
            if (test.trim().length()==0) return;
            m[a].comment = c.trim();
            m[a].comment = de.malban.util.UtilityString.replace(m[a].comment, "::",":").trim();
            if (m[a].comment.endsWith(";")) m[a].comment = m[a].comment.substring(0, m[a].comment.length()-1).trim();
            if (m[a].comment.endsWith(":")) m[a].comment = m[a].comment.substring(0, m[a].comment.length()-1).trim();;
            if (m[a].comment.endsWith(",")) m[a].comment = m[a].comment.substring(0, m[a].comment.length()-1).trim();;
            if (m[a].comment.startsWith(";")) m[a].comment = m[a].comment.substring(1).trim();;
            if (m[a].comment.startsWith(":")) m[a].comment = m[a].comment.substring(1).trim();;
            if (m[a].comment.startsWith(",")) m[a].comment = m[a].comment.substring(1).trim();;
            m[a].comment = m[a].comment.trim();
        }
        void setCInfo(int a, CInfoBlock c)
        {
            if (m[a].cInfo!=null)
            {
                m[a].cInfo.lineString+=c.lineString;
                m[a].cInfo.hasBreakpoint = m[a].cInfo.hasBreakpoint || c.hasBreakpoint;
            }
            else
            {
                m[a].cInfo = c;
            }
        }

        RSTInfo()
        {
            for (int i=0;i<65536;i++)
            {
                m[i] = new MemInfo(i);
            }
        }

    }
    Vector<String> ensureFileLoaded(HashMap<String, Vector> cFiles, String filename)
    {
        File f = new File(filename);
        if (!f.exists()) return null;
        if (cFiles.get(filename) != null) return cFiles.get(filename);
        Vector v = de.malban.util.UtilityString.readTextFileToStringNoTab(f);
        cFiles.put(filename, v);
        return v;
    }
    /*
    
    Stopping with stack frames...
    Inlined functions go on the same stack frame as the calling function
    same var names in inline function go on the same frame, this makes it
    impossible to just call stack "offsets" by its varnames, since
    there can be different definitions to one var name on one stack...
    
    Comments that are generated by gcc default must suffice...
    
    
    ArrayList<StackFrame> getStackFrame(Vector<String>lines)
    {
        ArrayList<StackFrame> frames = new ArrayList<StackFrame>();
        boolean hasFramepointer = false;
        // do (end of line) comments first
        
        int OUT_OF_FRAME = 0;
        int IN_FRAME = 1;
        
        int state = OUT_OF_FRAME;
        for (int i=0; i< lines.size(); i++)
        {
            String line = lines.elementAt(i);
            // this will always be set beforehand
            if (line.contains("-fno-omit-frame-pointer")) hasFramepointer = true;

            // stack frame are "encapsulated in 
            // leas -##,s
            // if frame pinter -> then followed by
            //      leau ,s {or other fp index reg}
            
            // ...
            // leas +##,s
            // 0         1          2         3         4
            // 012345678901233456789012345678901234567890
            //  07CF 32 E8 EF      [ 5]  110   	leas	-17,s	; ,,
            //                           104 	; #ENR#[373]int main(void)
            //                           105 ;--- end asm ---
            //                           106 	.area .text
            //                           107 	.globl _main
            //  07CD                     108 _main:
            //  07CD 34 40         [ 6]  109 	pshs	u	; 
            //  07CF 32 E8 EF      [ 5]  110 	leas	-17,s	; ,,
            //  07D2 33 E4         [ 4]  111 	leau	,s	; ,

            String mnemonic = getMnemonic(line);
            if ("leas".equals(mnemonic))
            {
                if (state == OUT_OF_FRAME)
                {
                    
                }
            }
            
        
        }
        return frames;
    }
    int getOPCount(String line)
    {
        int ret = Integer.MAX_VALUE;
        String op = getOperand(line);
        if (op.length() ==0) return ret;
        try
        {
            op = op.substring(0,op.indexOf(",")).trim();
            ret = DASM6809.toNumber(op);
            if (ret == 0) ret = Integer.MAX_VALUE;
        }
        catch (Throwable e) { }
        return ret;
    }
    String getOperand(String line)
    {
        String ret = "";
        try
        {
            if (!line.contains("[")) return ret;
            if (!line.contains("]")) return ret;
            line = line.substring(line.indexOf("]")+1).trim();
            line = de.malban.util.UtilityString.replaceWhiteSpaces(line, " ");
            line = de.malban.util.UtilityString.replace(line, "  "," ");
            String[] split = line.split(" ");
            split = removeEmpty(split);
            ret = split[2];
        }
        catch (Throwable e) { }
        return ret;
    }
    String getMnemonic(String line)
    {
        String ret = "";
        try
        {
            if (!line.contains("[")) return ret;
            if (!line.contains("]")) return ret;
            line = line.substring(line.indexOf("]")+1).trim();
            line = de.malban.util.UtilityString.replaceWhiteSpaces(line, " ");
            line = de.malban.util.UtilityString.replace(line, "  "," ");
            String[] split = line.split(" ");
            split = removeEmpty(split);
            ret = split[1];
        }
        catch (Throwable e) { }
        return ret;
    }
    int getAddress(String line)
    {
        int ret = -1;
        try
        {
            String a = line.substring(2,2+4);
            ret = DASM6809.toNumber("$"+a);
            if (ret == 0) ret = -1;
        }
        catch (Throwable e) { }
        return ret;
    }
    
    */
    
    
    RSTInfo parseRSTs(ArrayList<String> files)
    {
        HashMap<String, Vector> cFiles = new HashMap<String, Vector>();
        RSTInfo rst = new RSTInfo();
        for (String f: files)
        {
            if (f.contains("vec_rom")) continue;
            if (f.contains("vec_ram")) continue;
            ArrayList<DebugComment> commentList = new ArrayList<DebugComment>();
            String debugCommentFilename = "";
            
            if (f.contains("enr.rst"))
                debugCommentFilename = de.malban.util.UtilityString.replace(f, "enr.rst", "c");
            else
                debugCommentFilename = de.malban.util.UtilityString.replace(f, ".rst", ".c");
            
            
            
            debugCommentFilename = de.malban.util.UtilityString.replace(debugCommentFilename, "build"+File.separator+"lib","source");
// QUICK hack, 
// TODO
// does not work with subdirectoy files!
            
//        /Users/chrissalo/NetBeansProjects/Vide/projects/LodeRunner/source/jumpman.c
//        /users/chrissalo/netbeansprojects/vide/projects/loderunner/build/lib/jumpman.c
            
            
            DebugCommentList currentComments = getDebugComments(debugCommentFilename);
            if (currentComments!=null)
            {
                commentList = currentComments.getList();
                for (DebugComment dbc: commentList)
                {
                    dbc.breakpointCommitted = false;
                }
                
            }

            int areaCount = 0;
            Vector<String>lines = de.malban.util.UtilityString.readTextFileToStringNoTab(new File (f));
//            StackFrame frame = getStackFrame(lines);
           
            // do (end of line) comments first
            for (int i=0; i< lines.size(); i++)
            {
                String line = lines.elementAt(i);
                
                
                
                line = de.malban.util.UtilityString.replaceWhiteSpaces(line, " ");
                if (line.contains(".area")) areaCount++;
                if (areaCount<1) continue;
                // now we start at an interesing point in the file
                // skip this line, and the next
                if (line.contains("(Motorola 6809)")) break;
                if (line.length()<30) continue;
                String address = line.substring(3, 3+4);
                
                if (!de.malban.util.UtilityString.isHexNumber(address)) continue;
                int iaddress = DASM6809.toNumber("$"+address);

                // cycle info -> real assembler line
                if ((line.contains("[")) && (line.contains("]"))) 
                {
                    if (!line.contains(";")) continue; // if there is no comment - skip
                    String comment = line.substring(line.indexOf(";"));
                    rst.setComment(iaddress, comment);
                }
            }
            
            
            areaCount = 0;
            // seek refferenced "C" lines
            int lastAddress = 0;
            String nextComment = "";
            CInfoBlock cInfo = null;
            for (int i=0; i< lines.size(); i++)
            {
                String line = lines.elementAt(i);
   
                
                line = de.malban.util.UtilityString.replaceWhiteSpaces(line, " ");
                if (line.contains(".area")) areaCount++;
                if (areaCount<1) continue;
                // now we start at an interesing point in the file
                // skip this line, and the next
                if (line.contains("(Motorola 6809)")) break;
                
                // look if there is an "C info block"
                /*

                    0A23                    1425 L89:
                               1426 ;----- asm -----
                               1427 ;  334 "/Users/chrissalo/NetBeansProjects/Vide/projects/LodeRunner/source/LRUNNER.enr.c" 1
                               1428 	; #ENR#[X] player_heading = _DOWN;
                               1429 ;--- end asm ---
                    0A23 C6 01         [ 2] 1430 	ldb	#1	; ,            
                */
                
                if (line.contains("; #ENR#["))
                {
                    // ensure we can inspect the next lines
                    if (i+4<lines.size())
                    {
          //              String line0=line;                 // asm start
                        String line1=lines.elementAt(i-1); // file info
                        String line2=line; // enrich
                        String line4="";// code, next address os gotten from
                        
                        int t=1;
                        boolean adressFound = false;
                        while (!adressFound)
                        {
                            if (lines.size()<i+t+1) break;
                            line4=lines.elementAt(i+(t++));
                            String address = line4.substring(3, 3+4);
                            if (de.malban.util.UtilityString.isHexNumber(address)) adressFound = true;
                        }

                        if (line2.contains("#ENR#"))
                        {
                            if (cInfo == null)
                                cInfo = new CInfoBlock();

                            if (!cInfo.hasBreakpoint)
                            {

                                if (line1.indexOf("\"")==-1)
                                {
                                    cInfo.file ="";
                                }
                                else
                                {
                                    cInfo.file =line1.substring(line1.indexOf("\"")+1, line1.lastIndexOf("\""));
                                }


                                cInfo.file = de.malban.util.UtilityString.replace(cInfo.file, ".enr.c", ".c").trim();

                                String lineNo = line2.substring(line2.indexOf("[")+1, line2.indexOf("]"));
                                cInfo.lineNo = de.malban.util.UtilityString.Int0(lineNo);

                                if (cInfo.lineString.length() == 0)
                                    cInfo.lineString = line2.substring(line2.indexOf("]")+1);
                                else
                                    cInfo.lineString += ", "+line2.substring(line2.indexOf("]")+1);

                                String address = line4.substring(3, 3+4);
                                if (de.malban.util.UtilityString.isHexNumber(address)) 
                                {
                                    cInfo.address = DASM6809.toNumber("$"+address);
                                }   
                                


                                for (DebugComment dbc: commentList)
                                {
                                    if (dbc.beforLineNo == cInfo.lineNo)
                                    {
                                        cInfo.hasBreakpoint = true;
                                        dbc.breakpointCommitted = true;
                                    }
                                }
                                
                            }
                            
                            
                            i+=1;
                            continue;
                        }
                        
                    }
                }

                
                
                if (line.length()<30) continue;
                
                String address = line.substring(3, 3+4);
                
                if (de.malban.util.UtilityString.isHexNumber(address)) 
                {
                    lastAddress = DASM6809.toNumber("$"+address);
                    if (cInfo!= null)
                    {
                        rst.setCInfo(lastAddress, cInfo);
                    }
                    if (nextComment.length() != 0)
                    {
                        rst.setLineComment(lastAddress, nextComment);
                    }
                    cInfo = null;
                    nextComment = "";
                    continue;
                }
                
//                examine if removal is bad!
//                cInfo = null;
                if (line.contains(".stabs")) continue;

                if (line.contains(Global.mainPathPrefix))
                {
                    String ln = line.substring(33, 33+5).trim();
                    if (de.malban.util.UtilityString.isDecNumber(ln))
                    {
                        /*
                        like:
                                                         572 ;  360 "/Users/chrissalo/NetBeansProjects/Vide/projects/Graham/source/main.c" 1
                                02C6 35 76         [10]  573 	puls   d,x,y,u
                        */
                        int lineNumber = de.malban.util.UtilityString.Int0(ln);
                        String filename = line.substring(line.indexOf("\"")+1, line.lastIndexOf("\""));
                        Vector<String> v = ensureFileLoaded(cFiles, filename);

                        
                        if (v != null)
                            nextComment = v.elementAt(lineNumber-1);
                    }
                }
            }
            
            
            
            areaCount = 0;
            int lastCertainAddress = 0;
            for (int i=0; i< lines.size(); i++)
            {
                String line = lines.elementAt(i);
                line = de.malban.util.UtilityString.replaceWhiteSpaces(line, " ");
                if (line.contains(".area")) areaCount++;
                if (areaCount<1) continue;
                // now we start at an interesing point in the file
                // skip this line, and the next
                if (line.contains("(Motorola 6809)")) break;
                if (line.length()<30) continue;
                String address = line.substring(3, 3+4);
                
                if (!de.malban.util.UtilityString.isHexNumber(address)) continue;
                int iaddress = DASM6809.toNumber("$"+address);
                boolean isCertainAddress = false;
//                if () // line contains data
                if ((line.contains("[")) && (line.contains("]"))) 
                {
                    isCertainAddress = true;
                    lastCertainAddress = iaddress;
                }
                
                // test DATA
                if (line.contains(".byte")) 
                {
                    rst.setType(iaddress, CNT_DATA_BYTE, 1);
                    continue;
                }
                if (line.contains(".word")) 
                {
                    rst.setType(iaddress, CNT_DATA_WORD, 2);
                    continue;
                }
                if (line.contains(".ascii")) 
                {
                    // peeping for next lines to get the len of ascii data
                    
                    int asciiLen = getAsciiLen(i, lines);
                    
                    rst.setType(iaddress, CNT_DATA_CHAR, asciiLen);
                    continue;
                }
                if ((line.contains("[")) && (line.contains("]"))) 
                {
                    int x = getCodeBytes(line, 12);
                    rst.setType(iaddress, CNT_CODE, x);
                    continue;
                }
                
                String label = line.substring(32);
                if (!label.contains(":")) continue;
                label = label.substring(0,label.indexOf(":")).trim();
                if (label.trim().split(" ").length>1) label ="";
                if (label.length() != 0)
                {
                    if (!isCertainAddress)
                    {
                        if (iaddress<lastCertainAddress)
                            iaddress +=lastCertainAddress;
                        
                    }
                    
                    rst.setLabel(iaddress, label);
                }
            }
            
            
            for (DebugComment dbc: commentList)
            {
                if (!dbc.breakpointCommitted)
                {
                    printWarning("Breakpoint "+debugCommentFilename+": "+dbc.beforLineNo+" could not be committed!");
                }
            }

            
        }
        return rst;
    }
    
    int getCodeBytes(String line, int max)
    {
        /* lines like:
            037B 49            [ 2]  122 	rola
            037C 10 8E 03 66   [ 4]  123 	ldy	#_objects        
        */
        int x = 0;
        int end = 8+max;
        while (line.length()<end) end--;
        
        line = line.substring(8, end).trim();
        String[] split = line.split(" ");
        split = removeEmpty(split);
        for(int i=0; i< split.length;i++)
        {
            if (de.malban.util.UtilityString.isHexNumber(split[i]))
                x++;
            else
                break;
        }
        return x;
        
    }
    int getAsciiLen(int i, Vector<String> lines)
    {
        /*
            021C                      59 LC0:
            021C 47 45 54 20 52 45    60 	.ascii "GET READY\0"
                 41 44 59 00
                                      61 	.globl _game_init
        */
        String line = lines.elementAt(i++);
        int count = getCodeBytes(line, 18);
        line = lines.elementAt(i++);
        while (line.startsWith("       "))
        {
            count+=getCodeBytes(line, 18);
            line = lines.elementAt(i++);
        }
        return count;
    }
    
    // Peer truncate only!
    String truncateFilename(String file)
    {
        String path= Global.mainPathPrefix;
        String baseProjectPath = path;
        if (currentProject != null)
            baseProjectPath = de.malban.util.Utility.makeVideAbsolute(currentProject.projectPrefix+File.separator);

        String path2 = Global.mainPathPrefix+"C"+File.separator+"PeerC"+File.separator+"vectrex"+File.separator+"lib"+File.separator;
        
        String ret = de.malban.util.UtilityString.replace(file, baseProjectPath, "");
        ret = de.malban.util.UtilityString.replace(ret, path2, "");
        return ret;
    }
    void toAssi()
    {
        if (getSelectedEditor() == null) return;
        String fn = getSelectedEditor().getFilename();
        if (!fn.toLowerCase().endsWith("s")) return;
        
        getSelectedEditor().save(false);
        Vector<String> sLines =  de.malban.util.UtilityString.readTextFileToString(new File(fn));
        CompileResult result = doAssiConform(null, sLines, null);
        
        ArrayList <CompileResult> compiles = new ArrayList <CompileResult>();
        compiles.add(result);
        String t = buildFinalAssiResultString(compiles, false);
        if (t == null) return;
        getSelectedEditor().stopColoring();
        getSelectedEditor().setText(t);
        getSelectedEditor().startColoring(settings.fontSize);
        initInventory();
    
    }

    // somthing that does not start a line
    // but comes "second"
    static String getMnemonic(String line)
    {
        if (!line.startsWith(" "))
        {
            if (!line.contains(" ")) return "";
            line = line.substring(line.indexOf(" "));
        }
        
        // next "word" is mnemonic
        String[] split = line.split(" ");
        int i=0;
        while (i<split.length)
        {
            if (split[i].length()!=0) 
                return split[i];
            i++;
        }
        return "";
    }
    
    // not realy the operand
    // the rest of the line withour spaces!
    static String getOperand(String line, String knownMnemonic)
    {
        String rest = line.substring(line.indexOf(knownMnemonic)+knownMnemonic.length()).trim();
        if (rest.length()==0) return "";
        rest = de.malban.util.UtilityString.replaceWhiteSpaces(rest, " ");
        rest = de.malban.util.UtilityString.replace(rest, " ", "");

        return rest;
    }
    void preprocessOnly()
    {
        if (getSelectedEditor() == null) return;
        String fn = getSelectedEditor().getFilename();
        if (!((fn.toLowerCase().endsWith("s")) || (fn.toLowerCase().endsWith("i"))|| (fn.toLowerCase().endsWith("asm"))   )    ) return;
        
        getSelectedEditor().save(false);
        
        CustomOutputStream preprocessOut = new CustomOutputStream();
        PrintStream asmPreprocess = new PrintStream(preprocessOut);
        CustomOutputStream _errOut = new CustomOutputStream();
        PrintStream _asmErrOut = new PrintStream(_errOut);
        
        String o = new Asmj(fn, _asmErrOut, asmPreprocess).getAllOut();
        fn = changeTypeTo(fn, "pre.s");
        // todo translate struct

        de.malban.util.UtilityString.writeToTextFile(o, new File(fn));
        EditorPanel edi = addEditor(fn, true);
        
    }
    
    void toAs6809()
    {
        if (getSelectedEditor() == null) return;
        String fn = getSelectedEditor().getFilename();
        if (!((fn.toLowerCase().endsWith("s")) || (fn.toLowerCase().endsWith("i"))|| (fn.toLowerCase().endsWith("asm"))   )    ) return;
        getSelectedEditor().save(false);
        File f = new File (fn);
        String nameOnly = f.getName();
        
        
        Vector<String> sLines =  de.malban.util.UtilityString.readTextFileToString(new File(fn));
        CompileResult result = toAs6809(sLines, nameOnly);
        
        fn = changeTypeTo(fn, "asx.s");
        // todo translate struct

        de.malban.util.UtilityString.writeToTextFile(result.codeData, new File(fn));
        EditorPanel edi = addEditor(fn, true);
    }
    
    static boolean containsWord(String line, String word)
    {
        if (!line.contains(word)) return false;
        boolean contains = true;
        int start = line.indexOf(word);
        int end = line.indexOf(word) + word.length();
        if (start>0)
        {
            char startChar = line.charAt(start-1);
            if (!de.malban.util.UtilityString.isWordBoundry(startChar)) contains = false;
        }
        if (end<line.length())
        {
            char endChar = line.charAt(end);
            if (!de.malban.util.UtilityString.isWordBoundry(endChar)) contains = false;
        }
        return contains;
    }
    // replaces 'A' with 'A
    static String removeAS6809QuotePairs(String sLine)
    {
        if (!sLine.contains("'")) return sLine;
        String[] split = sLine.split("'");
        split = removeEmpty(split);
        if (split.length < 2) return sLine;
        String result = "";
        int pos1 = 0;
        int pos2 = 0;
        String work = sLine;
        
        pos1 = work.indexOf("'");
        result = work.substring(0, pos1+1);
        work = work.substring(pos1+1);

        pos2 = work.indexOf("'");
        if (pos2 != 1)
        {
            // next ' is to far away
            result += work.substring(0, pos2+1);
            work = work.substring(pos2+1);
        }
        else
        {
            result += work.substring(0, 1);
            work = work.substring(2);
        }
        result = result + removeAS6809QuotePairs(work);
        return result;
    }
    
    
    
    static CompileResult toAs6809(Vector<String> sLines, String module)
    {
        CompileResult result = new CompileResult();// doAssiConform(null, sLines, null);

        module = de.malban.util.UtilityString.replaceWhiteSpaces(module.toLowerCase(), " ");
        module = de.malban.util.UtilityString.replaceWhiteSpaces(module , "");
        if (module.length()==0) module = "tmp";
        if (Character.isDigit(module.charAt(0))) module = "_"+module;
        
        StringBuilder codeSource = new StringBuilder();
        StringBuilder dataSource = new StringBuilder();
        StringBuilder bssSource = new StringBuilder();
        StringBuilder bssInitSource = new StringBuilder();

        boolean in_Code = false;
        boolean in_Data = false;
        boolean in_BSS = false;
        
        ArrayList<String> globalNames = new ArrayList<String>();
        ArrayList<String> globalVars = new ArrayList<String>();

        
        
        codeSource.append(" .module "+module+"\n");
//        codeSource.append(" .bank rom(BASE=0x0000,SIZE=0x8000,FSFX=_rom)\n");
//        codeSource.append(" .area .cartridge (BANK=rom) \n");
//        codeSource.append(" .area .text (BANK=rom)\n");
//        codeSource.append(" .area .text.hot (BANK=rom)\n");
//        codeSource.append(" .area .text.unlikely (BANK=rom)\n\n");
//        codeSource.append(" .bank ram(BASE=0xc880,SIZE=0x036b,FSFX=_ram)\n");
        
//        codeSource.append(" .area .data  (BANK=ram)\n");
//        codeSource.append(" .area .bss   (BANK=ram)\n\n");
        codeSource.append(" .area .text\n");
        
        /* structs can be transfered like:
                    struct   ObjectStruct 
                    ds       Y_POS,1                      ; D (1) current position 
                    ds       SCALE,1                      ; D (2) scale to position the object 
                    ds       CURRENT_LIST,2               ; X current list vectorlist 
                    ds       TYPE, 0 
                    ds       BEHAVIOUR,2                  ; PC 
                    ds       X_POS,1                      ; D (2) 
                    ds       ANGLE,2                      ; if angle base, angle in degree *2 
                    ds       NEXT_OBJECT,2                ; positive = end of list 
                    ds       filler, 5                    ; #noDoubleWarn 
                    end struct 
        
        Y_POS = 0           ; D (1) current position
        SCALE = 1           ; D (2) scale to position the object 
        CURRENT_LIST = 2    ; X current list vectorlist
        TYPE = 4
        BEHAVIOUR = 4       ; PC 
        X_POS = 6           ; D (2) 
        ANGLE = 7           ; if angle base, angle in degree *2 
        NEXT_OBJECT = 9     ; positive = end of list 
        filler = 11         ; #noDoubleWarn
        ObjectStruct = filler +5
        
        */
        
        boolean inStruct = false;
        String structName = "";
        String structComment = "";
        int structCount = 0;
        for (int i=0; i< sLines.size(); i++)
        {
            boolean doLine = true;
            String sLine = sLines.elementAt(i);
            String orgLine = sLines.elementAt(i);

            // handle YM file special
            if (orgLine.trim().startsWith("SONG_DATA ")) continue; // quick hack for YM
            
            // handle // hex
            orgLine = de.malban.util.UtilityString.replace(orgLine, "$", "0x");

            // handle whitespaces
            sLine = de.malban.util.UtilityString.replaceWhiteSpaces(sLine.toLowerCase(), " ");
            if (sLine.trim().startsWith(";")) 
            {
                codeSource.append(orgLine+"\n");
                continue;
            }
            // handle comment
            if (sLine.trim().startsWith("*")) 
            {
                codeSource.append(";"+orgLine.substring(1)+"\n");
                continue;
            }
            sLine = Comment.removeEndOfLineComment(sLine);

            // handle strings
            sLine = removeAS6809QuotePairs(sLine);
            orgLine = removeAS6809QuotePairs(orgLine);

            String wLine = de.malban.util.UtilityString.replaceWhiteSpaces(sLine, " ");
            
            if ((wLine.toLowerCase().contains(" db ")) || ((wLine.toLowerCase().contains(" fcb ")))
                    || ((wLine.toLowerCase().contains(" fcc ")))
                    ) 
            {
                if ((wLine.contains("\"")) && (wLine.contains(",")))
                {
                    // split asciii and data
                    // for now assuming style: 
                    // db "TEXT", $80
                    int cPos = orgLine.lastIndexOf("\"");
                    String newLine1 = orgLine.substring(0,cPos+1);
                    newLine1 = de.malban.util.UtilityString.replace(newLine1, " DB ", " .ascii ");
                    newLine1 = de.malban.util.UtilityString.replace(newLine1, " FCB ", " .ascii ");
                    newLine1 = de.malban.util.UtilityString.replace(newLine1, " FCC ", " .ascii ");
                    newLine1 = de.malban.util.UtilityString.replace(newLine1, " db ", ". ascii ");
                    newLine1 = de.malban.util.UtilityString.replace(newLine1, " fcb ", " .ascii ");
                    newLine1 = de.malban.util.UtilityString.replace(newLine1, " fcc ", " .ascii ");
                    
                    
                    String newLine2 = orgLine.substring(cPos+1).trim();
                    newLine2 = newLine2.substring(1).trim(); // remove comma
                    newLine2 = " .byte "+newLine2;
                    codeSource.append(newLine1+"\n");
                    codeSource.append(newLine2+"\n");
                    continue;
                }
            }
            
            
            // handle // bin
            if (sLine.contains("%"))
            {
                // check if following 8 are binary digits, is so - this is most probablya binary :-)
                int pos = sLine.indexOf("%");
                if(sLine.length()-pos>=8)
                {
                    boolean isBinary = true;
                    // enough "space for digits
                    for (int ib=pos+1; ib<pos+1+8; ib++)
                    {
                        char c = sLine.charAt(ib);
                        if ((c != '0') && (c != '1'))
                        {
                            isBinary = false;
                            break;
                        }
                    }
                    if (isBinary)
                    {
                        orgLine = de.malban.util.UtilityString.replace(orgLine, "%", "0b");
                        sLine = de.malban.util.UtilityString.replace(sLine, "%", "0b");
                    }
                }
            }
            
            // handle end struct
            if (sLine.contains(" end struct") )
            {
                // do somethine
                codeSource.append(structName+" = "+structCount +" "+structComment+"\n");
                inStruct= false;
                structName = "";
                structComment = "";
                structCount = 0;
                continue;
            }
            
            // handle in struct
            if (inStruct)
            {
                String line =  Comment.removeEndOfLineComment(orgLine);
                String someComment = de.malban.util.UtilityString.replace(orgLine, line,"");
                String someName = "";
                line = de.malban.util.UtilityString.replaceWhiteSpaces(line, " ");

                if (!line.toLowerCase().contains(" ds")) continue;
                if (!line.toLowerCase().contains(",")) continue;
                
                int dsIndex = line.toLowerCase().indexOf(" ds");
                int commaIndex = line.toLowerCase().indexOf(",");
                someName = line.substring(dsIndex+" ds".length(), commaIndex).trim();
                
                codeSource.append(someName+" = "+structCount +" "+someComment+"\n");
                
                line =  line.substring(commaIndex+1).trim();
                String[] split = line.split(" ");
                split = removeEmpty(split);
                for (String s: split)
                {
                    structCount += DASM6809.toNumber(s);
                }
                continue;
            }
            
            // handle in struct start
            if (sLine.contains(" struct") )
            {
                // do somethine
                String line =  Comment.removeEndOfLineComment(orgLine);
                structComment = de.malban.util.UtilityString.replace(orgLine, line,"");

                int pos = sLine.indexOf(" struct");
                if (sLine.length()> pos+" struct".length())
                {
                     pos = sLine.indexOf(" struct ");
                }
                // struct is only start of some stupid name
                if (pos >=0)
                {
                    inStruct= true;
                    structCount = 0;
                    String lineCopy = line.toLowerCase();
                    pos = lineCopy.indexOf(" struct");
                    structName = line.substring(pos+" struct".length()).trim();
                
                    continue;
                }
            }
            
            // check if start of a "function"
            boolean isFunction = true;
            isFunction = isFunction & (!(sLine.trim().length()==0));
            isFunction = isFunction & (!sLine.startsWith(" "));
            isFunction = isFunction & (!sLine.contains("="));
            isFunction = isFunction & (!containsWord(sLine,"equ"));
            isFunction = isFunction & (!containsWord(sLine,"set"));
            isFunction = isFunction & (!containsWord(sLine,"macro"));
            isFunction = isFunction & (!containsWord(sLine,"struct"));
            isFunction = isFunction & (!containsWord(sLine,"db"));
            isFunction = isFunction & (!containsWord(sLine,"dw"));
            isFunction = isFunction & (!containsWord(sLine,"ds"));
            isFunction = isFunction & (!sLine.contains("\""));
            
            // check if standalone label, if so scan next line for data
            String t1 = de.malban.util.UtilityString.replaceWhiteSpaces(orgLine, " ");
            t1 = Comment.removeEndOfLineComment(t1);
            t1 = de.malban.util.UtilityString.replaceWhiteSpaces(t1, " ");
            t1 = de.malban.util.UtilityString.replace(t1,":", " ");
            t1 = de.malban.util.UtilityString.replace(t1.trim(),"  ", " ");
            String[] split = t1.split(" ");
            split = removeEmpty(split);
            if (split.length == 1) // is standalone label
            {
                // scan next lline
                if (i+1< sLines.size())
                {
                    String nextLine = sLines.elementAt(i+1).toLowerCase();
                    t1 = de.malban.util.UtilityString.replaceWhiteSpaces(nextLine, " ");
                    t1 = Comment.removeEndOfLineComment(t1);
                    t1 = de.malban.util.UtilityString.replaceWhiteSpaces(t1, " ");
                    t1 = de.malban.util.UtilityString.replace(t1,":", " ");
                    t1 = de.malban.util.UtilityString.replace(t1.trim(),"  ", " ");
                    isFunction = isFunction & (!containsWord(t1,"equ"));
                    isFunction = isFunction & (!containsWord(t1,"set"));
                    isFunction = isFunction & (!containsWord(t1,"macro"));
                    isFunction = isFunction & (!containsWord(t1,"struct"));
                    isFunction = isFunction & (!containsWord(t1,"db"));
                    isFunction = isFunction & (!containsWord(t1,"dw"));
                    isFunction = isFunction & (!containsWord(t1,"ds"));
                    isFunction = isFunction & (!t1.contains("\""));
                    
                }
                else
                {
                    isFunction = false;
                }
            }
            
            if (isFunction)
            {
                // ensure label is same case, not "tolower"
                String sLine2 = de.malban.util.UtilityString.replaceWhiteSpaces(orgLine, " ");
                sLine2 = Comment.removeEndOfLineComment(sLine2);

                
                String name = sLine2.split(" ")[0];
                if (name.endsWith(":")) name = name.substring(0, name.length()-1);
                if (name.trim().length()!=0)
                {
                    codeSource.append(" .globl "+name+"\n");
                    globalNames.add(name);
                }
                // ensure ":"
                orgLine = de.malban.util.UtilityString.replace(orgLine, name+":", name);
                orgLine = de.malban.util.UtilityString.replace(orgLine, name, name+":");
            }
            
            // handle variable lables
            boolean isVar = true & (!isFunction);
            isVar = isVar & (!(sLine.trim().length()==0));
            isVar = isVar & (!sLine.startsWith(" "));
            isVar = isVar & (!sLine.contains("="));
            isVar = isVar & (!containsWord(sLine,"equ"));
            isVar = isVar & (!containsWord(sLine,"set"));
            isVar = isVar & (!containsWord(sLine,"macro"));
            isVar = isVar & (!containsWord(sLine,"struct"));
            isVar = isVar & (!sLine.contains("\""));
            
            if (isVar)
            {
                // ensure label is same case, not "tolower"
                String sLine2 = de.malban.util.UtilityString.replaceWhiteSpaces(orgLine, " ");
                sLine2 = Comment.removeEndOfLineComment(sLine2);
                
                String name = sLine2.split(" ")[0];
                if (name.endsWith(":")) name = name.substring(0, name.length()-1);
                if (name.trim().length()!=0)
                {
                    codeSource.append(" .globl "+name+"\n");
                    globalVars.add(name);
                }
                // ensure ":"
                orgLine = de.malban.util.UtilityString.replace(orgLine, name+":", name);
                orgLine = de.malban.util.UtilityString.replace(orgLine, name, name+":");
                
            }
            
            // handle special lo() / hi() command
            
            // code changes are neccesarry
            // can not be done wit macro
            // lo(x) = (x&0xff)
            // hi(x) = ((x>>8)&0xff)
            // "x" has to be "extracted" and inserted in above... than the above inserted instead of ...
            String loHiTest = de.malban.util.UtilityString.replaceWhiteSpaces(orgLine, " ");
            loHiTest = Comment.removeEndOfLineComment(loHiTest);
            loHiTest = de.malban.util.UtilityString.replace(loHiTest, " ","");

            if (loHiTest.toLowerCase().contains("lo("))
            {
                String line =  Comment.removeEndOfLineComment(orgLine);
                String comment = de.malban.util.UtilityString.replace(orgLine, line,"");
                 
                line =  de.malban.util.UtilityString.replaceCI(line, "lo (","lo_(");
                line =  de.malban.util.UtilityString.replaceCI(line, "lo(","lo_(");
                // line is now no commented, and all occurences of "lo(" should be unified  
                String r ="";
                while (true)
                {
                    int pos = line.indexOf("lo_");
                    if (pos == -1) break;
                    r += line.substring(0,pos);
                    line = line.substring(pos+4); // without low
                    int in=1;
                    int ii=0;
                    for (ii=0;ii<line.length(); ii++)
                    {
                        char t = line.charAt(ii);
                        if (t == '(') in++;
                        if (t == ')') in--;
                        if (in == 0) break;
                    }
                    String innerBracketString = line.substring(0, ii);
                    line = line.substring(ii+1); // without low
                    r += "("+"("+innerBracketString+")"+"&0xff"+")";
                }
                orgLine = r+line+comment;
            }
            if (loHiTest.toLowerCase().contains("hi("))
            {
                String line =  Comment.removeEndOfLineComment(orgLine);
                String comment = de.malban.util.UtilityString.replace(orgLine, line,"");
                 
                line =  de.malban.util.UtilityString.replaceCI(line, "hi (","hi_(");
                line =  de.malban.util.UtilityString.replaceCI(line, "hi(","hi_(");
                // line is now no commented, and all occurences of "hi(" should be unified  
                String r ="";
                while (true)
                {
                    int pos = line.indexOf("hi_");
                    if (pos == -1) break;
                    r += line.substring(0,pos);
                    line = line.substring(pos+4); // without high
                    int in=1;
                    int ii=0;
                    for (ii=0;ii<line.length(); ii++)
                    {
                        char t = line.charAt(ii);
                        if (t == '(') in++;
                        if (t == ')') in--;
                        if (in == 0) break;
                    }
                    String innerBracketString = line.substring(0, ii);
                    line = line.substring(ii+1); // without high
                    r += "("+"(("+innerBracketString+")>>8)"+"&0xff"+")";
                }
                orgLine = r+line+comment;
             }                    

            // start of special assembler mnemonic handling
            String mnemonic = getMnemonic(sLine);
            
            
            
            if (mnemonic.trim().length() ==0)
            {
                codeSource.append(orgLine+"\n");
                continue;
            }
            
            if (mnemonic.equals("code"))
            {
                codeSource.append(de.malban.util.UtilityString.replaceCI(orgLine, "code", ".area .text", true)+"\n");
                continue;
            }
            if (mnemonic.equals("bss"))
            {
                codeSource.append(de.malban.util.UtilityString.replaceCI(orgLine, "bss", ".area .bss", true)+"\n");
                continue;
            }
            // direct is completely different in asxxxx
            // since relocatibility should be a thing
            // here we give only a warning
            // page handling can in this case not be automated
            if (mnemonic.equals("direct"))
            {
                codeSource.append("; Warning - direct line found!"+"\n");
                codeSource.append(";" + orgLine+"\n");
                continue;
            }
            if (mnemonic.equals("org"))
            {
                codeSource.append("; Warning - org line found, my be countering relocatable code!"+"\n");
                codeSource.append(";" + orgLine+"\n");
                continue;
            }
            
            if (mnemonic.equals("equ"))
            {
                codeSource.append(de.malban.util.UtilityString.replaceCI(orgLine, "equ", "=", true)+"\n");
                continue;
            }
            if (mnemonic.equals("set"))
            {
                codeSource.append(de.malban.util.UtilityString.replaceCI(orgLine, "set", "=", true)+"\n");
                continue;
            }
             
            // data statements
            if ((mnemonic.equals("ds"))|| (mnemonic.equals("rmb")))
            {
                orgLine = de.malban.util.UtilityString.replaceCI(orgLine, "ds",".blkb", true);
                orgLine = de.malban.util.UtilityString.replaceCI(orgLine, "rmb",".blkb", true);
                codeSource.append(orgLine+"\n");
                continue;
            }
            if ((mnemonic.equals("dw")) || (mnemonic.equals("fdb")))
            {
                orgLine = de.malban.util.UtilityString.replaceCI(orgLine, "dw",".word", true);
                orgLine = de.malban.util.UtilityString.replaceCI(orgLine, "fdb",".word", true);
                codeSource.append(orgLine+"\n");
                continue;
            }
            if ((mnemonic.equals("db")) || (mnemonic.equals("fcb"))|| (mnemonic.equals("fcc")))
            {
                orgLine = de.malban.util.UtilityString.replaceCI(orgLine, "db",".byte", true);
                orgLine = de.malban.util.UtilityString.replaceCI(orgLine, "fcb",".byte", true);
                orgLine = de.malban.util.UtilityString.replaceCI(orgLine, "fcc",".byte", true);
                
                if (orgLine.contains("\""))
                {
                    orgLine = de.malban.util.UtilityString.replaceCI(orgLine, ".byte",".ascii", true);

                    if (sLine.endsWith(", 0x80"))
                    {
                        orgLine = de.malban.util.UtilityString.replaceCI(orgLine, ", 0x80","");
                        codeSource.append(orgLine+"\n");
                        codeSource.append(" .byte 0x80\n");
                        continue;
                    }
                    if (sLine.endsWith(",0x80"))
                    {
                        orgLine = de.malban.util.UtilityString.replaceCI(orgLine, ",0x80","");
                        codeSource.append(orgLine+"\n");
                        codeSource.append(" .byte 0x80\n");
                        continue;
                    }
                }
                codeSource.append(orgLine+"\n");
                continue;
            }
            
            
            // not realy the operand
            // the rest of the line without spaces!
            // handle extended, direct with modifiers!
            String op = getOperand(sLine, mnemonic);
            
            // handle NOP (+ count)
            if (mnemonic.equals("nop"))
            {
                String line =  Comment.removeEndOfLineComment(orgLine);
                String someComment = de.malban.util.UtilityString.replace(orgLine, line,"");

                op = de.malban.util.UtilityString.replace(op, "(","").toLowerCase();
                op = de.malban.util.UtilityString.replace(op, "nop","");
                op = de.malban.util.UtilityString.replace(op, ")","").trim();
                int nopCount = de.malban.util.UtilityString.IntX(op, 1);
                for (int ni=0;ni<nopCount;ni++)
                {
                    if (ni==0)
                        codeSource.append(" nop "+someComment+"\n");
                    else
                        codeSource.append(" nop \n");
                    
                }
                continue;
            }
            
            
            
            if (op.startsWith("<<"))
                orgLine = de.malban.util.UtilityString.replace(orgLine, "<<","");
            if (op.startsWith("[<<"))
                orgLine = de.malban.util.UtilityString.replace(orgLine, "[<<","[");

            if (op.startsWith("<"))
                orgLine = de.malban.util.UtilityString.replace(orgLine, "<","*");
            if (op.startsWith("[<"))
                orgLine = de.malban.util.UtilityString.replace(orgLine, "[<","[*");
            if (op.startsWith(">"))
                orgLine = de.malban.util.UtilityString.replace(orgLine, ">","");
            if (op.startsWith("[>"))
                orgLine = de.malban.util.UtilityString.replace(orgLine, "[>","[");
            
            
            // handle stack
            if (op.contains(",sp"))
                orgLine = de.malban.util.UtilityString.replace(orgLine, ",sp",",s");
            if (op.contains(",SP"))
                orgLine = de.malban.util.UtilityString.replace(orgLine, ",SP",",s");
            if (op.contains(", sp"))
                orgLine = de.malban.util.UtilityString.replace(orgLine, ", sp",",s");
            if (op.contains(", SP"))
                orgLine = de.malban.util.UtilityString.replace(orgLine, ", SP",",s");
            
            
            codeSource.append(orgLine+"\n");
        }
        
        // replace all global vars with _name
        
        String org = codeSource.toString();
        for (String varName: globalVars)
        {
            String in = org;
            String out ="";
            int sPos = in.indexOf(varName);
            while (sPos >=0)
            {
                char preChar=' '; // 0 lines are seperators
                char postChar=' ';
                String pre = in.substring(0,sPos);
                String post = in.substring(sPos+varName.length(), in.length());
                if (pre.length() > 0)
                    preChar = pre.charAt(pre.length()-1);
                if (post.length() > 0)
                    postChar = post.charAt(0);
                if ((isVarSeperator(preChar)) && (isVarSeperator(postChar)))
                {
                    out += pre+"_"+varName;
                }
                else
                {
                    out += pre+varName;
                }
                in = post;
                sPos = in.indexOf(varName);
            }
            org = out+in;
        }
        
        
        result.bssInitData = bssInitSource.toString();
        result.bssData = bssSource.toString();
        result.codeData = org;//codeSource.toString();
        result.dataData = dataSource.toString();
        
        return result;
    }
    static boolean isVarSeperator(char a)
    {
        boolean noSeperator = false;
        if (Character.isAlphabetic(a)) noSeperator=true;
        if (Character.isDigit(a)) noSeperator=true;
        if (a=='_') noSeperator=true;
        
        return !noSeperator;
    }
    
    
    
    void doAS6809()
    {
        if (getSelectedEditor() == null) return;
        String fn = getSelectedEditor().getFilename();
        if (!((fn.toLowerCase().endsWith("s")) || (fn.toLowerCase().endsWith("i"))|| (fn.toLowerCase().endsWith("asm"))   )    ) return;
        getSelectedEditor().save(false);
        
        String[] ASMFLAGS = buildPeerASMFLAGS("");
        
        File file = new File(fn);

        ASMFLAGS[ASMFLAGS.length-2] = changeTypeTo(file.getAbsolutePath(),"rel");
        ASMFLAGS[ASMFLAGS.length-1] = file.getAbsolutePath();

        if (doPeerAssemble(ASMFLAGS, "Assemble"))
        {
            EditorPanel edi = addEditor(ASMFLAGS[ASMFLAGS.length-2], false);
        }    
        
    }
    
    // takes an input asm file and replaces it with a asxxxx.s
    // old file is deleted!
    public static void convertToCASM(String orgName, boolean deleteOrg)
    {
        // preprocess only:
        CustomOutputStream preprocessOut = new CustomOutputStream();
        PrintStream asmPreprocess = new PrintStream(preprocessOut);
        CustomOutputStream _errOut = new CustomOutputStream();
        PrintStream _asmErrOut = new PrintStream(_errOut);
        
        String o = new Asmj(orgName, _asmErrOut, asmPreprocess).getAllOut();
        String newNamePre = changeTypeTo(orgName, "pre.s");
        // todo translate struct

        de.malban.util.UtilityString.writeToTextFile(o, new File(newNamePre));
        
        
        
        
        
        Vector<String> sLines =  de.malban.util.UtilityString.readTextFileToString(new File(newNamePre));
        String module = baseOnly(new File(orgName).getName());
        CompileResult result = toAs6809(sLines, module);
        
        
        de.malban.util.UtilityFiles.deleteFile(newNamePre);
        String newName_s = changeTypeTo(orgName, "s");
        de.malban.util.UtilityString.writeToTextFile(result.codeData, new File(newName_s));
        if (deleteOrg)
            de.malban.util.UtilityFiles.deleteFile(orgName);
    }
                    
    File[] enrichCFiles(ArrayList<String> fList)  
    {
        ArrayList<File> outputFiles = new ArrayList<File>();
        
        for (String file : fList) 
        {
            String outName = changeTypeTo(file, "enr.c");
            enrichtOneFile(file, outName);
            outputFiles.add(new File (outName));
        }    
        return outputFiles.toArray(new File[0]);
    }                    
    
    File[] enrichCFiles(File[] fList)  
    {
        File[] flist2=  getAllCFiles(fList);
        ArrayList<File> outputFiles = new ArrayList<File>();
        
        for (File file : flist2) 
        {
            String fileName = file.getAbsolutePath();
            if (!fileName.toLowerCase().endsWith(".c")) continue;
            String outName = changeTypeTo(fileName, "enr.c");
            enrichtOneFile(fileName, outName);
            outputFiles.add(new File (outName));
        }    
        return outputFiles.toArray(new File[0]);
    }                    
    
    File[] getAllCFiles(File[] fList)
    {
        ArrayList<File> outputFiles = new ArrayList<File>();
        
        for (File file : fList) 
        {
            if (file.isDirectory())
            {
                File[] fList2 = file.listFiles();
                File[] outputFiles3 = getAllCFiles(fList2);
                for (File f3: outputFiles3) outputFiles.add(f3);
                continue;
            }
            outputFiles.add(file);
        }    
        return outputFiles.toArray(new File[0]);
        
    }
    String removeQuots(String line)
    {
        if (line.contains("\""))
        {
            String l1 = line.substring(0, line.indexOf("\""));
            String l2 = "";
            line = de.malban.util.UtilityString.replace(line, l1+"\"", "");
            if (line.contains("\""))
            {
                l2 = line.substring(line.indexOf("\"")+1);
            }
            line = l1+l2;
            if (line.contains("\"")) return removeQuots(line);
        }
        return line;
    }
    String removeComments(String line)
    {
        line = removeQuots(line);
        
        if (line.contains("//"))
        {
       
            line = line.substring(0, line.indexOf("//"));
        }
        if (line.contains("/*"))
        {
            if (line.contains("*/"))
            {
                String l1 = line.substring(0, line.indexOf("/*"));
                String l2 = "";
                if (!line.trim().endsWith("*/"))
                {

                    if (line.lastIndexOf("*/")+2 <line.length())
                    {
                        l2 = line.substring(line.lastIndexOf("*/")+2);
                    }
     
                }
                line = l1+l2;
            }
            else
            {
                line = line.substring(0, line.indexOf("/*"));
            }
        }
        
        return line.trim();
    }
    
    void enrichtOneFile(String in, String out)
    {
//        if (in.contains("main.c"))
//            System.out.println("Buh");
        Vector<String> sLines =  de.malban.util.UtilityString.readTextFileToString(new File(in));
        ArrayList<String> outLines = new ArrayList<String>();
        int countCurly =0;
        int countRound =0;
        int countSquare =0;
        boolean inLargeLine=false;
        boolean inComment = false;
        boolean inStart = false;
        boolean inStruct = false;
        boolean inStartRoundSeen = false;
        boolean inVar = false;
        boolean inFunc = false;
        boolean openOneLiner = false;
        boolean openDo = false;
        int doCurlyCount = 0;
        boolean doEnrich = true;        
        
        
        for (int i=0; i< sLines.size(); i++)
        {
            boolean addCloseCurly = false;
            String preLine = "";
            boolean preLineAllowed=true;
            boolean overwriteAllowed = false;
            int curlyStart = countCurly;
            boolean openIfStart = openOneLiner;

            String orgLine = sLines.elementAt(i);
            
            if (orgLine.contains("EnrichmentOff"))
                doEnrich = false;
            if (orgLine.contains("EnrichmentOn"))
                doEnrich = true;
            
            
///// COMMENTS

            // only in function (at least one { open)
            // not in function "call" (in () of a function of IF
            int commentStartPos = orgLine.indexOf("/*");
            if (commentStartPos>=0)
            {
                if (orgLine.indexOf("//*")!=-1)commentStartPos=-1;
            }
            
            
            int commentEndPos = orgLine.lastIndexOf("*/");
            if (commentStartPos>=0) inComment=true;
            if (inComment)
            {
                if (commentEndPos>commentStartPos) inComment = false;
            }
            if (inComment) preLineAllowed = false;
            
            if ((commentStartPos>=0) && (commentEndPos>=0))
            {
                String l=orgLine.substring(0, commentStartPos);
                l+=orgLine.substring(commentEndPos);
                if (l.trim().length() == 0) preLineAllowed = false;
            }
            
            String countReadyLine = orgLine.trim().toLowerCase();
            if (inComment)
            {
                if (countReadyLine.contains("*/"))
                    countReadyLine = countReadyLine.substring(countReadyLine.indexOf("*/")+2);
                else
                    countReadyLine="";
            }
            countReadyLine = removeComments(countReadyLine).trim();
///// COMMENTS
            
            
            
            
            if (!inComment)
            {
                if (orgLine.trim().toLowerCase().startsWith("#define"))
                {
                    outLines.add(orgLine);

                    
                    while ((i+1< sLines.size()) && (orgLine.endsWith("\\")) )
                    {
                        i+=1;
                        orgLine = sLines.elementAt(i);
                        outLines.add(orgLine);
                    }
                    
                    continue;
                }
            }
            
            
            
            if ((countReadyLine.contains("=")) && (!(countReadyLine.contains("!="))) && (!(countReadyLine.contains("=="))) && (!(countReadyLine.contains("<="))) 
                    && (!(countReadyLine.contains(">="))) && (!(countReadyLine.contains("=<"))) && (!(countReadyLine.contains("=>"))) 
                     && (!(countReadyLine.contains("*")))  && (!(countReadyLine.contains("+="))) && (!(countReadyLine.contains("/=")))  && (!(countReadyLine.contains("-=")))
                     && (!(countReadyLine.contains("^=")))  && (!(countReadyLine.contains("|=")))  && (!(countReadyLine.contains("&=")))  && (!(countReadyLine.contains("~="))))
            {
                openOneLiner = true;
                
            }

            if (countReadyLine.toLowerCase().trim().startsWith("while")) openOneLiner = true;
            if (countReadyLine.toLowerCase().trim().startsWith("for")) openOneLiner = true;
            if (countReadyLine.toLowerCase().trim().startsWith("if")) openOneLiner = true;
            if (countReadyLine.toLowerCase().trim().startsWith("else")) 
            {
                openOneLiner = true;
                preLineAllowed = false;
            }
            
            
            
            if (orgLine.trim().contains("{")) openOneLiner = false;
            if (orgLine.trim().contains(";")) 
            {
                String strange = de.malban.util.UtilityString.replaceWhiteSpaces(orgLine, "");
                
                if (strange.toLowerCase().trim().startsWith("}while"))
                {
                    openOneLiner = false;
                }
                else if (orgLine.toLowerCase().trim().startsWith("while"))
                {
                    openOneLiner = false;
                }
                else if (orgLine.toLowerCase().trim().startsWith("for"))
                {
                    if (orgLine.toLowerCase().trim().endsWith(";"))
                    {
                        openOneLiner = false;
                    }
                }
                else
                {
                    if (openOneLiner)
                    {
//                        outLines.add("{");
//                        addCloseCurly=true;
//                        overwriteAllowed = true;
                    }
                    openOneLiner = false;
                }
                
            }
            if ( (orgLine.toLowerCase().contains("else")) && (orgLine.toLowerCase().contains("if")) )
            {
                preLineAllowed=false;
                overwriteAllowed = false;
            }
            
            
            
            boolean isAloneDo = false;
            if (orgLine.trim().startsWith("do")) 
            {
                int doPos = orgLine.indexOf("do")+2;
                isAloneDo = true;
                if (doPos <orgLine.length())
                {
                    char next = orgLine.charAt(doPos);
                    isAloneDo = de.malban.util.UtilityString.isWordBoundry(next);
                }
                if (isAloneDo)
                {
                    openDo = true;
                    doCurlyCount = countCurly;
                }
            }
            
            // to enclosed do while(); loops can happen otherwise, 
            if ((countReadyLine.trim().contains("while")) && (countReadyLine.trim().contains(";")))
                    preLineAllowed = false;
            
            
            
            
            
            if (orgLine.trim().startsWith("#define")) preLineAllowed = false;
            if (orgLine.trim().startsWith("{")) preLineAllowed = false;
            if (orgLine.trim().startsWith("}")) preLineAllowed = false;
            if (orgLine.trim().startsWith("//")) preLineAllowed = false;
            if (orgLine.trim().length() == 0) preLineAllowed = false;
            if (countCurly == 0) preLineAllowed = false;
            if (countRound != 0) preLineAllowed = false;
            if (countSquare != 0) preLineAllowed = false;
            if ((openDo) && (doCurlyCount == countCurly))
            {
                if (!isAloneDo)
                    preLineAllowed = false;
            }
            if (inLargeLine) preLineAllowed = false;
            if (openIfStart) preLineAllowed = false;
            
            
            
            if (orgLine.trim().contains("while")) 
            {
                if (openDo)
                {
                    if (doCurlyCount == countCurly) openDo= false;
                    if (orgLine.trim().startsWith("}")) 
                    {
                        if (doCurlyCount == countCurly-1) openDo= false;
                        preLineAllowed = true;
                    }
                    else
                    {
                        String lastLine = outLines.get(outLines.size()-1);
                        if (lastLine.trim().startsWith("}")) 
                        {
                            
                       //     String prepreLine = "asm(\"; #ENR#["+i+"]"+escape(orgLine)+"\");";
                            String prepreLine = "asm(\"; #ENR#["+i+"]"+escape(countReadyLine)+"\");";
                            outLines.add(outLines.size()-1, prepreLine);
                            preLineAllowed = false;
                        }
                    }
//                    go back to last curly close and add
                    
                }
            }

            
            if ((!countReadyLine.endsWith(";")) && (!countReadyLine.endsWith(";")))
            {
                if (sLines.size()>i+1)
                {
                    String nextLine = sLines.elementAt(i+1);
                    if (nextLine.trim().startsWith("}"))
                    {
                        preLineAllowed = false;
                    }
                }
            }

            
            countCurly += UtilityString.countChars(countReadyLine, "{");
            countCurly -= UtilityString.countChars(countReadyLine, "}");
            
            
            if (countCurly == 0)
            {
                if (countReadyLine.contains("struct ")) 
                {
                    if (!countReadyLine.contains(",")) 
                        if (!countReadyLine.contains("*")) 
                          inStruct = true;
                    
                }
            }
            if ((countCurly == 0) && (curlyStart!=0) && (inStruct)) inStruct= false;

            
            
            
            int countRoundStart = UtilityString.countChars(countReadyLine, "(");
            countRound += UtilityString.countChars(countReadyLine, "(");
            countRound -= UtilityString.countChars(countReadyLine, ")");
            countSquare += UtilityString.countChars(countReadyLine, "[");
            countSquare -= UtilityString.countChars(countReadyLine, "]");
            if ((countCurly == 0) && (curlyStart!=0))
            {
                inStart = false;
                inStartRoundSeen = false;
                inFunc = false;
            }
            if ((!inFunc) && (curlyStart == 0))
            {
                if (orgLine.trim().toLowerCase().contains("void ")) inStart = true;
                if (orgLine.trim().toLowerCase().contains("signed ")) inStart = true;
                if (orgLine.trim().toLowerCase().contains("unsigned ")) inStart = true;
                if (orgLine.trim().toLowerCase().contains("char ")) inStart = true;
                if (orgLine.trim().toLowerCase().contains("int ")) inStart = true;
                if (orgLine.trim().toLowerCase().contains("short ")) inStart = true;
                if (orgLine.trim().toLowerCase().contains("long ")) inStart = true;
                if (orgLine.trim().toLowerCase().contains("volatile ")) inStart = true;
                if (orgLine.trim().toLowerCase().contains("const ")) inStart = true;
                if (orgLine.trim().toLowerCase().contains("static ")) inStart = true;
                if (orgLine.trim().toLowerCase().contains("inline ")) inStart = true;
                if (orgLine.trim().toLowerCase().contains("struct ")) inStart = true;
                
                
                if ((orgLine.trim().toLowerCase().contains("(")) 
                     && (orgLine.trim().toLowerCase().contains(")")) 
                     && (!(orgLine.trim().toLowerCase().contains(";")) )
                     && (!(orgLine.trim().toLowerCase().contains("=")) )
                    )
                    inStart = true;
            }
            if ((countRoundStart>0) && (inStart)) inStartRoundSeen = true;

            if (inStart)
            {
                if ((curlyStart == 0) && (countCurly != 0))
                {
                    int curlyPos = orgLine.indexOf("{");
                    int roundPos = orgLine.indexOf(")");
                    int equalPos = orgLine.indexOf("=");
                    if ((curlyPos>roundPos) && (inStartRoundSeen))
                    {
                        inFunc = true;
                    }
                    if (roundPos==-1) roundPos = Integer.MAX_VALUE;
                        
                    if (equalPos>roundPos)
                    {
                        inFunc = false;
                        inStart = false;
                        inStartRoundSeen = false;
                    }
                    if (orgLine.contains("#define"))
                    {
                        inFunc = false;
                        inStart = false;
                        inStartRoundSeen = false;
                    }
                    if (orgLine.contains("\\"))
                    {
                        inFunc = false;
                    }
                    if ((orgLine.trim().startsWith("//")) ||(orgLine.trim().startsWith("/*")))
                    {
                        inFunc = false;
                    }
                    inStart = false;
                }
                else if ((curlyStart == 0) && (countCurly == 0))
                {
                    int roundPos = orgLine.indexOf(")");
                    if ((roundPos>=0) &&  (inStartRoundSeen))
                    {
                        inFunc = true;
                    }
                    int equalPos = orgLine.indexOf("=");
                    if (equalPos>roundPos)
                    {
                        inFunc = false;
                        inStartRoundSeen = false;
                        inStart = false;
                    }
                    if (orgLine.contains("#define"))
                    {
                        inFunc = false;
                        inStartRoundSeen = false;
                        inStart = false;
                    }
                    if (orgLine.contains("\\"))
                    {
                        inFunc = false;
                    }
                    if ((orgLine.trim().startsWith("//")) ||(orgLine.trim().startsWith("/*")))
                    {
                        inFunc = false;
                    }
                }
            }
            if ((inStart) && (inFunc))
            {
                inStartRoundSeen = false;
                inStart = false;
            }
            if (orgLine.trim().startsWith("asm")) 
            {
                preLineAllowed = false;
            }
            if (orgLine.contains("#define")) 
            {
                preLineAllowed = false;
            }
            if (orgLine.trim().startsWith("*/")) 
            {
                preLineAllowed = false;
            }
            if (orgLine.trim().endsWith("\\"))
            {
                preLineAllowed = false;
            }
            String line = removeComments(orgLine).trim();
            if (line.endsWith(","))
            {
                preLineAllowed = false;
            }
            
            
            if (!inFunc) preLineAllowed = false;
            if (inStruct) preLineAllowed = false;
            
  //            preLine = "{asm(\"; #ENR#["+i+"]"+escape(orgLine)+"\");}";
            preLine = "{asm(\"; #ENR#["+i+"]"+escape(countReadyLine)+"\");}";
            preLine = de.malban.util.UtilityString.replace(preLine, "*/", "* /");
/*            
            if ((newFunction) && (!preLineAllowed))
            {
                // new func does not work anyway
//                System.out.println("No Func: "+orgLine);
                    preLineAllowed = true;
                
            }
*/            
            inLargeLine = orgLine.endsWith("\\");
            if ((((preLine.length()>0) && (preLineAllowed)) || (overwriteAllowed)) && (doEnrich))
                outLines.add(preLine);
            if (addCloseCurly)
            {
                outLines.add(orgLine);
                outLines.add("}");
                
            }
            else
                outLines.add(orgLine);
            
            
            
            if (countReadyLine.contains(";")) 
                inStruct = false;
            
            
            
            
        }
        
        
        StringBuilder outString = new StringBuilder();
        for (String s: outLines) outString.append(s).append("\n");
        de.malban.util.UtilityString.writeToTextFile(outString.toString(), new File(out));
    }
    
    // deletes all files ending with "enr.c"
    void deleteEnrichedCFiles( File[] fList)
    {
        for (File f: fList)
        {
            if (f.exists())
            {
                if (f.getAbsolutePath().endsWith("enr.c"))
                {
                    if (currentProject.getIsCKeepEnriched())
                    {
                        String copyForTest = changeTypeTo(f.getAbsolutePath(), "ec");
                        de.malban.util.UtilityFiles.move(f.getAbsolutePath(), copyForTest);
                    }
                    else
                    {
                        de.malban.util.UtilityFiles.deleteFile(f.getAbsolutePath());
                    }
                }
            }
        }
    }
    
    String escape(String e)
    {
        return de.malban.util.UtilityString.replace(e, "\"", "\\\"");
    }
    
    public Point getEditorPos()
    {
        Point p = new Point();
        p.x = settings.pos2+10;
        p.y = jSplitPane1.getY()+4+20; // splitz pos + border + TAB
        return p;
    }
    
    
    public void resetCScan(boolean hasFramePointer)
    {
        if (cInfo.hasFramePointer == hasFramePointer) return;
        cInfo.hasFramePointer = hasFramePointer;
        cInfo.resetDefinitions();
        updateDefinitions();
    }
    
    public static C6809FileMaster getCInfo(Component o)
    {
        VEdiFoundationPanel vedi = getVedi(o);
        if (vedi == null) return null;
        return vedi.cInfo;
    }
    public static ASM6809FileMaster getAsmInfo(Component o)
    {
        VEdiFoundationPanel vedi = getVedi(o);
        if (vedi == null) return null;
        return vedi.asmInfo;
    }

}

