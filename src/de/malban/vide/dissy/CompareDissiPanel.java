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
import de.malban.gui.dialogs.InternalFrameFileChoser;
import de.malban.util.syntax.Syntax.TokenStyles;
import de.malban.vide.VideConfig;
import static de.malban.vide.dissy.DissiPanel.panels;
import de.malban.vide.vecx.Updatable;
import de.muntjak.tinylookandfeel.Theme;
import java.awt.Color;
import java.awt.Component;
import java.awt.Point;
import java.awt.Rectangle;
import java.awt.event.ActionEvent;
import java.awt.event.KeyEvent;
import java.awt.event.MouseEvent;
import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;
import java.io.File;
import java.io.Serializable;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardWatchEventKinds;
import java.nio.file.WatchEvent;
import java.nio.file.WatchKey;
import java.nio.file.WatchService;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicBoolean;
import javax.swing.AbstractAction;
import javax.swing.BoundedRangeModel;
import javax.swing.JOptionPane;
import javax.swing.JScrollBar;
import javax.swing.JTable;
import static javax.swing.JTable.AUTO_RESIZE_LAST_COLUMN;
import static javax.swing.JTable.AUTO_RESIZE_SUBSEQUENT_COLUMNS;
import javax.swing.JViewport;
import javax.swing.KeyStroke;
import javax.swing.SwingUtilities;
import javax.swing.UIManager;
import javax.swing.filechooser.FileNameExtensionFilter;
import javax.swing.table.DefaultTableCellRenderer;
import javax.swing.table.TableColumn;
import javax.swing.text.AttributeSet;
import javax.swing.text.StyleConstants;

/**
 *
 * @author malban
 */
class DisCompareFileStrings implements Serializable
{
    String s1;
    String s2;
    String lastDir1;
    String lastDir2;

    Boolean synced = true;
    
    Boolean[] columnVisibleALL = {true, true,true, true,true,true, true,true, true, true,true ,true, true, true, true, true};
    int[] columnWidthSmall1 =     {20       , 50    , 150      , 30        , 100       ,10       ,20,20,20,20,20};
    int[] columnWidthSmall2 =     {20       , 50    , 150      , 30        , 100       ,10       ,20,20,20,20,20};
}
public class CompareDissiPanel extends javax.swing.JPanel  implements
        Windowable, Stateable, Updatable{



    // see https://stackoverflow.com/questions/16251273/can-i-watch-for-single-file-change-with-watchservice-not-the-whole-directory
    class FileWatcher extends Thread {

        CompareDissiPanel parent;
        private final File file;
        private AtomicBoolean stop = new AtomicBoolean(false);
        private boolean useSecondtable = false;
        public FileWatcher(File file, boolean us, CompareDissiPanel p) {
            this.file = file;
            useSecondtable = us;
            parent = p;
        }

        public boolean isStopped() { return stop.get(); }
        public void stopThread() { stop.set(true); }

        public synchronized void doOnChange() {
            
            parent.doOnChange(useSecondtable);
        }
        public synchronized void doOnDelete() {
            parent.doOnDelete(useSecondtable);
        }

        @Override
        public void run() {
            try (WatchService watcher = FileSystems.getDefault().newWatchService()) {
                Path path = file.toPath().getParent();
                path.register(watcher, StandardWatchEventKinds.ENTRY_MODIFY, StandardWatchEventKinds.ENTRY_DELETE);
                while (!isStopped()) {
                    WatchKey key;
                    try { key = watcher.poll(25, TimeUnit.MILLISECONDS); }
                    catch (InterruptedException e) { return; }
                    if (key == null) { Thread.yield(); continue; }

                    for (WatchEvent<?> event : key.pollEvents()) {
                        WatchEvent.Kind<?> kind = event.kind();

                        @SuppressWarnings("unchecked")
                        WatchEvent<Path> ev = (WatchEvent<Path>) event;
                        Path filename = ev.context();

                        if (kind == StandardWatchEventKinds.OVERFLOW) {
                            Thread.yield();
                            continue;
                        } 
                        else if (kind == java.nio.file.StandardWatchEventKinds.ENTRY_MODIFY && filename.toString().equals(file.getName())) 
                        {
                            doOnChange();
                        }
                        else if (kind == java.nio.file.StandardWatchEventKinds.ENTRY_DELETE && filename.toString().equals(file.getName())) 
                        {
                            doOnDelete();
                        }
                        boolean valid = key.reset();
                        if (!valid) { break; }
                    }
                    Thread.yield();
                }
            } catch (Throwable e) {
                // Log or rethrow the error
            }
        }
    }






    public boolean isLoadSettings() { return true; }
    VideConfig config = VideConfig.getConfig();

    public static final String MESSAGE_INFO = "editLogMessage";
    public static final String MESSAGE_WARN = "editLogWarning";
    public static final String MESSAGE_ERR = "error";
    
    String lastDir1;
    String lastDir2;

    private CSAView mParent = null;
    private javax.swing.JMenuItem mParentMenuItem = null;
    private int mClassSetting=0;
    MemoryInformationTableModelSmall model=null;
    DASM6809 dasm = new DASM6809();
    MemoryInformationTableModelSmall model1=null;
    DASM6809 dasm1 = new DASM6809();
    boolean init = false;
    boolean init1 = false;
    JTable  popupSource = null;
    
    ArrayList<Integer> byteDifs = new ArrayList<Integer>();   // all labels this adress has
    public static ArrayList<CompareDissiPanel> panels = new ArrayList<CompareDissiPanel>();
   
    int activeDif = -1;
    int allDifCount = 0;
    

    @Override
    public void closing()
    {
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
        if (watchLeft!=null) watchLeft.stopThread();;
        if (watchRight!=null) watchRight.stopThread();;
        watchLeft = null;
        watchRight = null;
        
        
        init = false;
        panels.remove(this);
        removeUIListerner();
    }
    ArrayList<TableColumn> allColumns1 = null;
    ArrayList<TableColumn> allColumns2 = null;
    public static void configChanged()
    {
        for (CompareDissiPanel p: panels )
            p.setUpTableColumns();
    }
    public void setUpTableColumns()
    {
        ((MemoryInformationTableModelSmall)jTableSource.getModel()).initVisibity();
        while (jTableSource.getColumnCount()>0)
        {
            jTableSource.getColumnModel().removeColumn(jTableSource.getColumnModel().getColumn(0));
        }
        for (int i=0; i< allColumns1.size(); i++)
        {
            if (i>=model.columnVisible.length)
            {
                jTableSource.getColumnModel().addColumn(allColumns1.get(i));
            }
            else
            {
                if (model.columnVisible[i] == null)
                    jTableSource.getColumnModel().addColumn(allColumns1.get(i));
                else
                    if (model.columnVisible[i])
                    {
                        if (i >= 13)
                        {
                            if (config.doProfile)
                            {
                                if (((MemoryInformationTableModelSmall)jTableSource.getModel()).profiler!=null)
                                    jTableSource.getColumnModel().addColumn(allColumns1.get(i));
                            }
                        }
                        else
                            jTableSource.getColumnModel().addColumn(allColumns1.get(i));
                    }
            }
        }

        ((MemoryInformationTableModelSmall)jTableSource1.getModel()).initVisibity();
        while (jTableSource1.getColumnCount()>0)
        {
            jTableSource1.getColumnModel().removeColumn(jTableSource1.getColumnModel().getColumn(0));
        }
        for (int i=0; i< allColumns2.size(); i++)
        {
            if (i>=model1.columnVisible.length)
            {
                jTableSource1.getColumnModel().addColumn(allColumns2.get(i));
            }
            else
            {
                if (model1.columnVisible[i] == null)
                    jTableSource1.getColumnModel().addColumn(allColumns2.get(i));
                else
                    if (model1.columnVisible[i])
                    {
                        if (i >= 13)
                        {
                            if (config.doProfile)
                            {
                                if (((MemoryInformationTableModelSmall)jTableSource1.getModel()).profiler!=null)
                                    jTableSource1.getColumnModel().addColumn(allColumns2.get(i));
                            }
                        }
                        else
                            jTableSource1.getColumnModel().addColumn(allColumns2.get(i));
                    }
            }
        }

    }
        
    /**
     * Creates new form DissiPanel
     */
    public  CompareDissiPanel() {
        initComponents();
        panels.add(this);
        initTable();
        jLabel3.setVisible(false);
        setupKeyEvents();
        UIManager.addPropertyChangeListener(pListener);
        updateMyUI(); 
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
        jMenuItemChar = new javax.swing.JMenuItem();
        jMenuItemUngroup = new javax.swing.JMenuItem();
        jMenuItemJoin = new javax.swing.JMenuItem();
        jMenu1 = new javax.swing.JMenu();
        jMenuItem1 = new javax.swing.JMenuItem();
        jMenuItem2 = new javax.swing.JMenuItem();
        jMenuItem3 = new javax.swing.JMenuItem();
        jMenuItem4 = new javax.swing.JMenuItem();
        jMenuItem5 = new javax.swing.JMenuItem();
        jMenu2 = new javax.swing.JMenu();
        jMenuItem6 = new javax.swing.JMenuItem();
        jMenuItemC9 = new javax.swing.JMenuItem();
        jMenuItem7 = new javax.swing.JMenuItem();
        jMenuItemRemove = new javax.swing.JMenuItem();
        jCheckBox2 = new javax.swing.JCheckBox();
        jCheckBox1 = new javax.swing.JCheckBox();
        jPanel1 = new javax.swing.JPanel();
        jButtonSearchNext = new javax.swing.JButton();
        jTextFieldSearch = new javax.swing.JTextField();
        jLabel2 = new javax.swing.JLabel();
        jButtonSearchPrevious = new javax.swing.JButton();
        jLabel3 = new javax.swing.JLabel();
        jTextField1 = new javax.swing.JTextField();
        jLabel4 = new javax.swing.JLabel();
        jLabel6 = new javax.swing.JLabel();
        jTextField2 = new javax.swing.JTextField();
        jTextField3 = new javax.swing.JTextField();
        jLabel7 = new javax.swing.JLabel();
        jLabel8 = new javax.swing.JLabel();
        jTextField4 = new javax.swing.JTextField();
        jCheckBoxSourceMode = new javax.swing.JCheckBox();
        jLabel5 = new javax.swing.JLabel();
        jTextFieldTileFile = new javax.swing.JTextField();
        jButtonFileSelect1 = new javax.swing.JButton();
        jTextFieldTileFile1 = new javax.swing.JTextField();
        jButtonFileSelect2 = new javax.swing.JButton();
        jPanel4 = new javax.swing.JPanel();
        jScrollPane2 = new javax.swing.JScrollPane();
        jTableSource = buildTable();
        jScrollPane4 = new javax.swing.JScrollPane();
        jTableSource1 = buildTable();
        jPanel3 = new javax.swing.JPanel();
        jTextFieldCurrentDifAdr = new javax.swing.JTextField();
        jLabel1 = new javax.swing.JLabel();
        jButtonDifNext = new javax.swing.JButton();
        jButtonDifPrevious = new javax.swing.JButton();
        jLabelDifsFound = new javax.swing.JLabel();
        jCheckBoxSync = new javax.swing.JCheckBox();
        jLabel9 = new javax.swing.JLabel();
        jLabel10 = new javax.swing.JLabel();

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

        jMenuItemChar.setText("cast to char");
        jMenuItemChar.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemCharActionPerformed(evt);
            }
        });
        jPopupMenu1.add(jMenuItemChar);

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

        jMenuItem7.setText("$D0");
        jMenuItem7.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem7ActionPerformed(evt);
            }
        });
        jMenu2.add(jMenuItem7);

        jPopupMenu1.add(jMenu2);

        jMenuItemRemove.setText("remove");
        jMenuItemRemove.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemRemoveActionPerformed(evt);
            }
        });
        jPopupMenu1.add(jMenuItemRemove);

        setName("dissy"); // NOI18N

        jCheckBox2.setSelected(true);
        jCheckBox2.setText("only full instructions");
        jCheckBox2.setToolTipText("Memory locations that \"belong\" to other mnemonics are not shown.");
        jCheckBox2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox2ActionPerformed(evt);
            }
        });

        jCheckBox1.setSelected(true);
        jCheckBox1.setText("no unkown");
        jCheckBox1.setToolTipText("<html>Don't show locations that are \"unkown\" (not read from file), this <b>allways</b> includes RAM!<BR>(Since disassembled data is static)</html>\n"); // NOI18N
        jCheckBox1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox1ActionPerformed(evt);
            }
        });

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
        jTextFieldSearch.setPreferredSize(new java.awt.Dimension(200, 20));
        jTextFieldSearch.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldSearchActionPerformed(evt);
            }
        });

        jLabel2.setText("search:");

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
        jLabel3.setPreferredSize(new java.awt.Dimension(47, 21));

        jTextField1.setFont(new java.awt.Font("Courier New", 1, 11)); // NOI18N
        jTextField1.setText("$0000");
        jTextField1.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextField1FocusLost(evt);
            }
        });
        jTextField1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField1ActionPerformed(evt);
            }
        });

        jLabel4.setHorizontalAlignment(javax.swing.SwingConstants.TRAILING);
        jLabel4.setText("start:");

        jLabel6.setHorizontalAlignment(javax.swing.SwingConstants.TRAILING);
        jLabel6.setText("end:");

        jTextField2.setFont(new java.awt.Font("Courier New", 1, 11)); // NOI18N
        jTextField2.setText("$ffff");
        jTextField2.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextField2FocusLost(evt);
            }
        });
        jTextField2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField2ActionPerformed(evt);
            }
        });

        jTextField3.setEditable(false);
        jTextField3.setHorizontalAlignment(javax.swing.JTextField.TRAILING);

        jLabel7.setHorizontalAlignment(javax.swing.SwingConstants.TRAILING);
        jLabel7.setText("CRC32-A:");

        jLabel8.setHorizontalAlignment(javax.swing.SwingConstants.TRAILING);
        jLabel8.setText("CRC32-B:");

        jTextField4.setEditable(false);
        jTextField4.setHorizontalAlignment(javax.swing.JTextField.TRAILING);

        jCheckBoxSourceMode.setText("source mode");
        jCheckBoxSourceMode.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxSourceModeActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jLabel2, javax.swing.GroupLayout.PREFERRED_SIZE, 77, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextFieldSearch, javax.swing.GroupLayout.PREFERRED_SIZE, 150, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonSearchPrevious)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonSearchNext)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jLabel3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(18, 18, 18)
                .addComponent(jLabel4)
                .addGap(3, 3, 3)
                .addComponent(jTextField1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabel6)
                .addGap(2, 2, 2)
                .addComponent(jTextField2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(29, 29, 29)
                .addComponent(jLabel7)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField3, javax.swing.GroupLayout.PREFERRED_SIZE, 105, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jLabel8)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField4, javax.swing.GroupLayout.PREFERRED_SIZE, 105, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jCheckBoxSourceMode)
                .addContainerGap(65, Short.MAX_VALUE))
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
            .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                .addComponent(jTextField4, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addComponent(jLabel8, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addComponent(jCheckBoxSourceMode))
            .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                .addComponent(jTextField2, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addComponent(jLabel6, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addComponent(jTextField3, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addComponent(jLabel7, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
            .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                .addComponent(jLabel3, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(jTextField1, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addComponent(jLabel4, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGap(0, 0, Short.MAX_VALUE)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                        .addComponent(jButtonSearchNext, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGroup(jPanel1Layout.createSequentialGroup()
                            .addGap(1, 1, 1)
                            .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                .addComponent(jTextFieldSearch, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jLabel2, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))))
                    .addComponent(jButtonSearchPrevious, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)))
        );

        jLabel5.setText("Bin File");

        jTextFieldTileFile.setText("/Users/chrissalo/NetBeansProjects/Veccy/codelib/CompleteReleases/Ville Krumlinde/thrust.org/thrust.bin");
        jTextFieldTileFile.setPreferredSize(new java.awt.Dimension(300, 21));
        jTextFieldTileFile.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextFieldTileFileFocusLost(evt);
            }
        });
        jTextFieldTileFile.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldTileFileActionPerformed(evt);
            }
        });

        jButtonFileSelect1.setText("...");
        jButtonFileSelect1.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonFileSelect1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonFileSelect1ActionPerformed(evt);
            }
        });

        jTextFieldTileFile1.setText("/Users/chrissalo/NetBeansProjects/Veccy/codelib/CompleteReleases/Ville Krumlinde/Thrust.bin");
        jTextFieldTileFile1.setPreferredSize(new java.awt.Dimension(300, 21));
        jTextFieldTileFile1.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextFieldTileFile1FocusLost(evt);
            }
        });
        jTextFieldTileFile1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldTileFile1ActionPerformed(evt);
            }
        });

        jButtonFileSelect2.setText("...");
        jButtonFileSelect2.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonFileSelect2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonFileSelect2ActionPerformed(evt);
            }
        });

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
        jTableSource.setShowHorizontalLines(false);
        jTableSource.setShowVerticalLines(false);
        jTableSource.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jTableSourceMousePressed(evt);
            }
        });
        jScrollPane2.setViewportView(jTableSource);

        jTableSource1.setModel(new javax.swing.table.DefaultTableModel(
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
        jTableSource1.setShowHorizontalLines(false);
        jTableSource1.setShowVerticalLines(false);
        jTableSource1.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jTableSource1MousePressed(evt);
            }
        });
        jScrollPane4.setViewportView(jTableSource1);

        javax.swing.GroupLayout jPanel4Layout = new javax.swing.GroupLayout(jPanel4);
        jPanel4.setLayout(jPanel4Layout);
        jPanel4Layout.setHorizontalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel4Layout.createSequentialGroup()
                .addComponent(jScrollPane2)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jScrollPane4))
        );
        jPanel4Layout.setVerticalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jScrollPane2, javax.swing.GroupLayout.DEFAULT_SIZE, 405, Short.MAX_VALUE)
            .addComponent(jScrollPane4, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE)
        );

        jPanel3.setPreferredSize(new java.awt.Dimension(25, 26));

        jTextFieldCurrentDifAdr.setEditable(false);
        jTextFieldCurrentDifAdr.setText("-");
        jTextFieldCurrentDifAdr.setToolTipText("address of difference");
        jTextFieldCurrentDifAdr.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldCurrentDifAdrActionPerformed(evt);
            }
        });

        jLabel1.setText("current dif:");
        jLabel1.setToolTipText("address of difference");

        jButtonDifNext.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/resultset_next.png"))); // NOI18N
        jButtonDifNext.setToolTipText("next dif");
        jButtonDifNext.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonDifNext.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonDifNextActionPerformed(evt);
            }
        });

        jButtonDifPrevious.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/resultset_previous.png"))); // NOI18N
        jButtonDifPrevious.setToolTipText("previous dif");
        jButtonDifPrevious.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonDifPrevious.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonDifPreviousActionPerformed(evt);
            }
        });

        jLabelDifsFound.setText("difs found:");

        jCheckBoxSync.setSelected(true);
        jCheckBoxSync.setText("sync scroll");
        jCheckBoxSync.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBoxSyncActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel3Layout = new javax.swing.GroupLayout(jPanel3);
        jPanel3.setLayout(jPanel3Layout);
        jPanel3Layout.setHorizontalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jLabel1, javax.swing.GroupLayout.PREFERRED_SIZE, 78, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextFieldCurrentDifAdr, javax.swing.GroupLayout.PREFERRED_SIZE, 150, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonDifPrevious)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonDifNext)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jLabelDifsFound, javax.swing.GroupLayout.PREFERRED_SIZE, 178, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(18, 18, 18)
                .addComponent(jCheckBoxSync, javax.swing.GroupLayout.PREFERRED_SIZE, 114, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(408, Short.MAX_VALUE))
        );
        jPanel3Layout.setVerticalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel3Layout.createSequentialGroup()
                        .addGap(2, 2, 2)
                        .addComponent(jTextFieldCurrentDifAdr, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel3Layout.createSequentialGroup()
                        .addGap(1, 1, 1)
                        .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                            .addComponent(jButtonDifNext, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jButtonDifPrevious, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                .addComponent(jLabelDifsFound, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                .addComponent(jCheckBoxSync)))))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel3Layout.createSequentialGroup()
                .addComponent(jLabel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addContainerGap())
        );

        jLabel9.setHorizontalAlignment(javax.swing.SwingConstants.TRAILING);
        jLabel9.setText(" ");

        jLabel10.setText(" ");

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jLabel5)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextFieldTileFile, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonFileSelect1)
                .addGap(27, 27, 27)
                .addComponent(jTextFieldTileFile1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonFileSelect2)
                .addGap(5, 5, 5)
                .addComponent(jCheckBox1)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jCheckBox2)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
            .addComponent(jPanel3, javax.swing.GroupLayout.DEFAULT_SIZE, 1024, Short.MAX_VALUE)
            .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addComponent(jPanel4, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                .addComponent(jLabel10, javax.swing.GroupLayout.PREFERRED_SIZE, 76, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(jLabel9, javax.swing.GroupLayout.PREFERRED_SIZE, 76, javax.swing.GroupLayout.PREFERRED_SIZE))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGap(3, 3, 3)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jCheckBox1)
                    .addComponent(jCheckBox2)
                    .addComponent(jTextFieldTileFile, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButtonFileSelect1)
                    .addComponent(jLabel5, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextFieldTileFile1, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButtonFileSelect2))
                .addGap(0, 0, 0)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel9)
                    .addComponent(jLabel10))
                .addGap(0, 0, 0)
                .addComponent(jPanel4, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(jPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
        );
    }// </editor-fold>//GEN-END:initComponents

    private void jCheckBox1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox1ActionPerformed
        correctModel();
    }//GEN-LAST:event_jCheckBox1ActionPerformed

    private void jCheckBox2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox2ActionPerformed
        if (model!=null)
        {
            model.setFullDisplay(!jCheckBox2.isSelected());
        }
        if (model1!=null)
        {
            model1.setFullDisplay(!jCheckBox2.isSelected());
        }
        correctModel();
    }//GEN-LAST:event_jCheckBox2ActionPerformed

    private void jTableSourceMousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jTableSourceMousePressed
        popupSource = jTableSource;
        if (evt.getButton() == MouseEvent.BUTTON3)
        {
            jPopupMenu1.show(jTableSource, evt.getX()-20,evt.getY()-20);
        }       
        
        if (evt.getClickCount() == 2) 
        {
            JTable table =(JTable) evt.getSource();
            Point p = evt.getPoint();
            int row = table.rowAtPoint(p);
            int col = table.columnAtPoint(p);
            if (col == 8) // zeiger auf adresse
            {
                MemoryInformation memInfo = model.getValueAt(row);
                boolean bit8 = false;
                String adr = (String) model.getValueAt( row,  col);
                if (adr.trim().length() <1) return;
                if (adr.trim().length() <4) bit8 = true;
                int a = DASM6809.toNumber(adr);
                int current = memInfo.address;
                
                if (bit8) a += current;
                goAddress(a,true, true, true);
            }
        }

        
    }//GEN-LAST:event_jTableSourceMousePressed

    ArrayList<Integer> rowStack = new ArrayList<Integer>();
    int rowStackPosition = -1;
    
    int getTopRow()
    {
        JViewport viewport = jScrollPane2.getViewport();

        Point p = viewport.getViewPosition();
        return jTableSource.rowAtPoint(p);   
    }
    
    private void jPopupMenu1MouseExited(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jPopupMenu1MouseExited
        jPopupMenu1.setVisible(false);
    }//GEN-LAST:event_jPopupMenu1MouseExited
    
    private void jMenuItemByteActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemByteActionPerformed
        updateToNewType(popupSource, MemoryInformation.DIS_TYPE_DATA_BYTE, 1);
    }//GEN-LAST:event_jMenuItemByteActionPerformed

    private void jMenuItemCodeActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemCodeActionPerformed

        updateToNewType(popupSource,MemoryInformation.DIS_TYPE_DATA_INSTRUCTION_GENERAL, 1);
    }//GEN-LAST:event_jMenuItemCodeActionPerformed

    private void jMenuItemCharActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemCharActionPerformed
        updateToNewType(popupSource,MemoryInformation.DIS_TYPE_DATA_CHAR, 1);
    }//GEN-LAST:event_jMenuItemCharActionPerformed

    private void jMenuItemWordActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemWordActionPerformed
        updateToNewType(popupSource,MemoryInformation.DIS_TYPE_DATA_WORD, 2);
    }//GEN-LAST:event_jMenuItemWordActionPerformed

    private void jMenuItemUngroupActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemUngroupActionPerformed
        joinData(popupSource,1);
    }//GEN-LAST:event_jMenuItemUngroupActionPerformed
    
    private void jMenuItemJoinActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemJoinActionPerformed
        JTable table = popupSource;
        int[] selected = table.getSelectedRows();
        MemoryInformationTableModelSmall model = (MemoryInformationTableModelSmall) table.getModel();
        
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
        joinData(table,max);
    
    }//GEN-LAST:event_jMenuItemJoinActionPerformed

    private void jMenuItem1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem1ActionPerformed
        joinData(popupSource,2);
    }//GEN-LAST:event_jMenuItem1ActionPerformed

    private void jMenuItem2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem2ActionPerformed
        joinData(popupSource,3);
    }//GEN-LAST:event_jMenuItem2ActionPerformed

    private void jMenuItem3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem3ActionPerformed
        joinData(popupSource,4);
    }//GEN-LAST:event_jMenuItem3ActionPerformed

    private void jMenuItem4ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem4ActionPerformed
        joinData(popupSource,5);
    }//GEN-LAST:event_jMenuItem4ActionPerformed

    private void jMenuItem5ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem5ActionPerformed
        joinData(popupSource,6);
    }//GEN-LAST:event_jMenuItem5ActionPerformed

    private void jMenuItem6ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem6ActionPerformed
        updateToNewDP(popupSource,0xc8);
    }//GEN-LAST:event_jMenuItem6ActionPerformed

    private void jMenuItem7ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem7ActionPerformed
        updateToNewDP(popupSource,0xd0);
    }//GEN-LAST:event_jMenuItem7ActionPerformed

    private void jMenuItemC9ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemC9ActionPerformed
        updateToNewDP(popupSource,0xc9);
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
        MemoryInformationTableModelSmall model = (MemoryInformationTableModelSmall) jTableSource.getModel();
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
        MemoryInformationTableModelSmall model = (MemoryInformationTableModelSmall) jTableSource.getModel();
        if (selected.length!= 0) 
            searchStart = model.getValueAt(selected[0]).address+1;
        if (searchStart>=65536) searchStart = 0;
        int adr = searchForString(searchStart, text, true);
        int row = model.getNearestVisibleRow(adr);
        if (row == -1) return;
        
        goRow(row, true);
    }//GEN-LAST:event_jButtonSearchNextActionPerformed

    ArrayList<String> commandHistory = new ArrayList<String>();
    int commandHistoryPosition = -1;
    public void commandHistoryNext()
    {
        if (commandHistoryPosition==-1) return; // we have no history
        if (commandHistoryPosition == commandHistory.size()-1)
        {
            // new is allways empty
        //    jTextFieldCurrentDifAdr.setText("-");
            commandHistoryPosition = -1;
            return;
        }
        commandHistoryPosition++;
        //jTextFieldCurrentDifAdr.setText(commandHistory.get(commandHistoryPosition));
    }
    public void commandHistoryPrevious()
    {
        if (commandHistoryPosition==0) return; // we have no further history
        if (commandHistory.size()==0) return;
        if (commandHistoryPosition==-1)  // we are not yet in  history
        {
            commandHistoryPosition = commandHistory.size()-1;
            //jTextFieldCurrentDifAdr.setText(commandHistory.get(commandHistoryPosition));
            return;
        }
        commandHistoryPosition--;
        //jTextFieldCurrentDifAdr.setText(commandHistory.get(commandHistoryPosition));
    }
    
    private void jTextFieldCurrentDifAdrActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldCurrentDifAdrActionPerformed
        
        commandHistoryPosition = -1;
        commandHistory.add(jTextFieldCurrentDifAdr.getText());
        String command = jTextFieldCurrentDifAdr.getText();
        //jTextFieldCurrentDifAdr.setText("");
    }//GEN-LAST:event_jTextFieldCurrentDifAdrActionPerformed

    private void jTextFieldTileFileFocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextFieldTileFileFocusLost
        jTextFieldTileFileActionPerformed(null);
    }//GEN-LAST:event_jTextFieldTileFileFocusLost

    private void jTextFieldTileFileActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldTileFileActionPerformed

        String file = jTextFieldTileFile.getText().trim();
        String _class = "";
//        if (file.length() == 0) return;
        
        String text = dis(jTextFieldTileFile.getText(), de.malban.util.UtilityString.Int0(jTextFieldTileFile.getText()), false);
        correctModel();
        calcCRC();

    }//GEN-LAST:event_jTextFieldTileFileActionPerformed

    private void jButtonFileSelect1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonFileSelect1ActionPerformed
        InternalFrameFileChoser fc = new de.malban.gui.dialogs.InternalFrameFileChoser();
        
        if ((!config.useLastKnownDir) || ((lastDir1 == null) || (lastDir1.length()==0)))
            fc.setCurrentDirectory(new java.io.File(config.fileRequestHome));
        else
            fc.setCurrentDirectory(new java.io.File(lastDir1));

        FileNameExtensionFilter  filter = new  FileNameExtensionFilter("Binaries", "bin", "vec");
        fc.setFileFilter(filter);
        int r = fc.showOpenDialog(Configuration.getConfiguration().getMainFrame());
        if (r != InternalFrameFileChoser.APPROVE_OPTION) return;
        String name = fc.getSelectedFile().getAbsolutePath();
        lastDir1 = fc.getCurrentDirectory().toString();;
        jTextFieldTileFile.setText(name);
        jTextFieldCurrentDifAdr.setText("-");
        jTextFieldTileFileActionPerformed(null);
    }//GEN-LAST:event_jButtonFileSelect1ActionPerformed

    private void jTextFieldTileFile1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldTileFile1ActionPerformed
        String file = jTextFieldTileFile1.getText().trim();
        String _class = "";
//        if (file.length() == 0) return;
        
        String text = dis(jTextFieldTileFile1.getText(), de.malban.util.UtilityString.Int0(jTextFieldTileFile1.getText()), true);
        correctModel();
        calcCRC();
    }//GEN-LAST:event_jTextFieldTileFile1ActionPerformed

    private void jButtonFileSelect2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonFileSelect2ActionPerformed
        InternalFrameFileChoser fc = new de.malban.gui.dialogs.InternalFrameFileChoser();
        if ((!config.useLastKnownDir) || ((lastDir2 == null) || (lastDir2.length()==0)))
            fc.setCurrentDirectory(new java.io.File(config.fileRequestHome));
        else
            fc.setCurrentDirectory(new java.io.File(lastDir2));
        FileNameExtensionFilter  filter = new  FileNameExtensionFilter("Binaries", "bin", "vec");
        fc.setFileFilter(filter);
        int r = fc.showOpenDialog(Configuration.getConfiguration().getMainFrame());
        if (r != InternalFrameFileChoser.APPROVE_OPTION) return;
        String name = fc.getSelectedFile().getAbsolutePath();
        lastDir2 = fc.getCurrentDirectory().toString();;
        jTextFieldTileFile1.setText(name);
        jTextFieldCurrentDifAdr.setText("-");
        jTextFieldTileFile1ActionPerformed(null);
    }//GEN-LAST:event_jButtonFileSelect2ActionPerformed

    private void jTableSource1MousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jTableSource1MousePressed
        popupSource = jTableSource1;
        if (evt.getButton() == MouseEvent.BUTTON3)
        {
            jPopupMenu1.show(jTableSource1, evt.getX()-20,evt.getY()-20);
        }        
        if (evt.getClickCount() == 2) 
        {
            JTable table =(JTable) evt.getSource();
            Point p = evt.getPoint();
            int row = table.rowAtPoint(p);
            int col = table.columnAtPoint(p);
            if (col == 8) // zeiger auf adresse
            {
                MemoryInformation memInfo = model.getValueAt(row);
                boolean bit8 = false;
                String adr = (String) model.getValueAt( row,  col);
                if (adr.trim().length() <1) return;
                if (adr.trim().length() <4) bit8 = true;
                int a = DASM6809.toNumber(adr);
                int current = memInfo.address;
                
                if (bit8) a += current;
                goAddress(a,true, true, true);
            }
        }
    }//GEN-LAST:event_jTableSource1MousePressed

    private void jTextField1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextField1ActionPerformed
        calcCRC();
    }//GEN-LAST:event_jTextField1ActionPerformed

    private void jTextField1FocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextField1FocusLost
        calcCRC();
    }//GEN-LAST:event_jTextField1FocusLost

    private void jTextField2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextField2ActionPerformed
        calcCRC();
    }//GEN-LAST:event_jTextField2ActionPerformed

    private void jTextField2FocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextField2FocusLost
        calcCRC();
    }//GEN-LAST:event_jTextField2FocusLost

    private void jMenuItemRemoveActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemRemoveActionPerformed
        // remove selected addresses from table (visible)
        JTable table = popupSource;
        
        int[] selected = table.getSelectedRows();
        MemoryInformationTableModelSmall model = (MemoryInformationTableModelSmall) table.getModel();
        
        for (int row: selected)
        {
            MemoryInformation memInfo = model.getValueAt(row);
            int len = memInfo.length;
            for (int a=memInfo.address; a<memInfo.address+len; a++)
            {
                dasm.myMemory.memMap.get(a).visible = false;
                dasm1.myMemory.memMap.get(a).visible = false;
            }
        }
        correctModel();
    }//GEN-LAST:event_jMenuItemRemoveActionPerformed

    private void jCheckBoxSourceModeActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxSourceModeActionPerformed
        activeDif = -1;
        correctModel();
    }//GEN-LAST:event_jCheckBoxSourceModeActionPerformed

    private void jButtonDifPreviousActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonDifPreviousActionPerformed
        setPrevDif();
    }//GEN-LAST:event_jButtonDifPreviousActionPerformed

    private void jButtonDifNextActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonDifNextActionPerformed
        setNextDif();
    }//GEN-LAST:event_jButtonDifNextActionPerformed

    private void jCheckBoxSyncActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBoxSyncActionPerformed
        if (jCheckBoxSync.isSelected())
        {
            jScrollPane4.getVerticalScrollBar().setModel(sBar1Model); //<--------------synchronize            
        }
        else
        {
            jScrollPane4.getVerticalScrollBar().setModel(sBar2Model); //<-------------- not synchronize            
        }
    }//GEN-LAST:event_jCheckBoxSyncActionPerformed

    private void jTextFieldTileFile1FocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextFieldTileFile1FocusLost
        jTextFieldTileFile1ActionPerformed(null);
    }//GEN-LAST:event_jTextFieldTileFile1FocusLost

    void spaceTo(StringBuilder s, int posNow, int upTo)
    {
        while (posNow++<upTo) s.append(" ");
    }
  
    private int searchForString(int start, String text, boolean forward)
    {
        int foundAt = -1;
        int addi = forward?1:-1;
            
        for (int i=start; (((i&0xffff) !=0) || (i==start)); i+=addi)
        {
            MemoryInformation memInfo =  dasm.myMemory.memMap.get(i);
            for (String l: memInfo.labels)
            {
                if (l.toLowerCase().indexOf(text.toLowerCase())>=0)
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
                if (c.toLowerCase().indexOf(text.toLowerCase())>=0)
                {
                    foundAt = i;
                    jLabel3.setVisible(true);
                    jLabel3.setForeground(config.valueNotChanged);
                    jLabel3.setText("Found in comment at: " + String.format("$%04X",i&0xffff ));
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
    void updateToNewDP(JTable table, int dp)
    {
        int[] selected = table.getSelectedRows();
        MemoryInformationTableModelSmall model = (MemoryInformationTableModelSmall) table.getModel();
        
        DASM6809 da;
        if (table == jTableSource) da = dasm; else da = dasm1;
        int max = 0;
        for (int row: selected)
        {
            MemoryInformation memInfo = model.getValueAt(row);
            int len = memInfo.length;
            for (int a=memInfo.address; a<memInfo.address+len; a++)
            {
                // join / ungroup makes no sense for NON code
                if (da.myMemory.memMap.get(a).disType <MemoryInformation.DIS_TYPE_DATA_INSTRUCTION_1_LENGTH) continue;

                da.myMemory.memMap.get(a).directPageAddress = dp;

                da.myMemory.memMap.get(a).disType = MemoryInformation.DIS_TYPE_DATA_INSTRUCTION_GENERAL;
                da.myMemory.memMap.get(a).belongsToInstruction = null;
                da.myMemory.memMap.get(a).disassembledMnemonic = "";
                da.myMemory.memMap.get(a).disassembledOperand = "";
                da.myMemory.memMap.get(a).page = -1;
                da.myMemory.memMap.get(a).hexDump = "";
                da.myMemory.memMap.get(a).isInstructionByte = 0;
                da.myMemory.memMap.get(a).referingToAddress = -1;
                da.myMemory.memMap.get(a).referingAddressMode = -1;
                da.myMemory.memMap.get(a).length = 1;
                da.myMemory.memMap.get(a).done = false;
                da.myMemory.memMap.get(a).familyBytes.clear();
                
            }
        }        
        
        dasm.reDisassemble(true);
        updateTable();        
    }
    void updateToNewType(JTable table, int type, int l)
    {
        int[] selected = table.getSelectedRows();
        MemoryInformationTableModelSmall model = (MemoryInformationTableModelSmall) table.getModel();
        
        DASM6809 da;
        if (table == jTableSource) da = dasm; else da = dasm1;
        for (int row: selected)
        {
            MemoryInformation memInfo = model.getValueAt(row);
            int len = memInfo.length;
            for (int a=memInfo.address; a<memInfo.address+len; a++)
            {
                da.myMemory.memMap.get(a).disType = type;
                da.myMemory.memMap.get(a).belongsToInstruction = null;
                da.myMemory.memMap.get(a).disassembledMnemonic = "";
                da.myMemory.memMap.get(a).disassembledOperand = "";
                da.myMemory.memMap.get(a).page = -1;
                da.myMemory.memMap.get(a).hexDump = "";
                da.myMemory.memMap.get(a).isInstructionByte = 0;
                da.myMemory.memMap.get(a).referingToAddress = -1;
                da.myMemory.memMap.get(a).referingAddressMode = -1;
                da.myMemory.memMap.get(a).length = l;
                da.myMemory.memMap.get(a).done = false;
                da.myMemory.memMap.get(a).familyBytes.clear();
            }
        }
        //da.reDisassemble(false);
        da.reDisassemble(true);

        updateTable();        
    }
    private void joinData(JTable table, int ll)
    {
        int[] selected = table.getSelectedRows();
        MemoryInformationTableModelSmall model = (MemoryInformationTableModelSmall) table.getModel();
        
        DASM6809 da;
        if (table == jTableSource) da = dasm; else da = dasm1;
        
        for (int row: selected)
        {
            MemoryInformation memInfo = model.getValueAt(row);
            int len = memInfo.length;
            for (int a=memInfo.address; a<memInfo.address+len; a++)
            {
                // join / ungroup makes no sense for code
                if (da.myMemory.memMap.get(a).disType >=MemoryInformation.DIS_TYPE_DATA_INSTRUCTION_1_LENGTH) continue;
                
                da.myMemory.memMap.get(a).disTypeCollectionMax = ll;
                
                da.myMemory.memMap.get(a).disassembledMnemonic = "";
                da.myMemory.memMap.get(a).disassembledOperand = "";
                da.myMemory.memMap.get(a).page = -1;
                da.myMemory.memMap.get(a).hexDump = "";
                da.myMemory.memMap.get(a).isInstructionByte = 0;
                da.myMemory.memMap.get(a).referingToAddress = -1;
                da.myMemory.memMap.get(a).referingAddressMode = -1;
                da.myMemory.memMap.get(a).length = 1;
                da.myMemory.memMap.get(a).done = false;
                da.myMemory.memMap.get(a).familyBytes.clear();
            }
        }
        da.reDisassemble(true);
        updateTable();            
    }
    
    private void updateTable()
    {
        JViewport vp = (JViewport)jTableSource.getParent();
        Point pos = vp.getViewPosition();
        JViewport vp1 = (JViewport)jTableSource1.getParent();
        Point pos1 = vp1.getViewPosition();
        correctModel();
        vp.setViewPosition(pos);
        vp1.setViewPosition(pos1);

    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton jButtonDifNext;
    private javax.swing.JButton jButtonDifPrevious;
    private javax.swing.JButton jButtonFileSelect1;
    private javax.swing.JButton jButtonFileSelect2;
    private javax.swing.JButton jButtonSearchNext;
    private javax.swing.JButton jButtonSearchPrevious;
    private javax.swing.JCheckBox jCheckBox1;
    private javax.swing.JCheckBox jCheckBox2;
    private javax.swing.JCheckBox jCheckBoxSourceMode;
    private javax.swing.JCheckBox jCheckBoxSync;
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
    private javax.swing.JLabel jLabelDifsFound;
    private javax.swing.JMenu jMenu1;
    private javax.swing.JMenu jMenu2;
    private javax.swing.JMenuItem jMenuItem1;
    private javax.swing.JMenuItem jMenuItem2;
    private javax.swing.JMenuItem jMenuItem3;
    private javax.swing.JMenuItem jMenuItem4;
    private javax.swing.JMenuItem jMenuItem5;
    private javax.swing.JMenuItem jMenuItem6;
    private javax.swing.JMenuItem jMenuItem7;
    private javax.swing.JMenuItem jMenuItemByte;
    private javax.swing.JMenuItem jMenuItemC9;
    private javax.swing.JMenuItem jMenuItemChar;
    private javax.swing.JMenuItem jMenuItemCode;
    private javax.swing.JMenuItem jMenuItemJoin;
    private javax.swing.JMenuItem jMenuItemRemove;
    private javax.swing.JMenuItem jMenuItemUngroup;
    private javax.swing.JMenuItem jMenuItemWord;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel3;
    private javax.swing.JPanel jPanel4;
    private javax.swing.JPopupMenu jPopupMenu1;
    private javax.swing.JScrollPane jScrollPane2;
    private javax.swing.JScrollPane jScrollPane4;
    private javax.swing.JTable jTableSource;
    private javax.swing.JTable jTableSource1;
    private javax.swing.JTextField jTextField1;
    private javax.swing.JTextField jTextField2;
    private javax.swing.JTextField jTextField3;
    private javax.swing.JTextField jTextField4;
    private javax.swing.JTextField jTextFieldCurrentDifAdr;
    private javax.swing.JTextField jTextFieldSearch;
    private javax.swing.JTextField jTextFieldTileFile;
    private javax.swing.JTextField jTextFieldTileFile1;
    // End of variables declaration//GEN-END:variables

    boolean assumeVectrex = true;
    boolean createUnkownLabels = false;
    
    String loadedName = "";
    String loadedName1 = "";
    
    FileWatcher watchLeft = null;
    FileWatcher watchRight = null;

    void doOnChange(boolean useSecondtable)
    {
        if (useSecondtable)
        {
            int answer = JOptionPane.showOptionDialog(Configuration.getConfiguration().getMainFrame(), 
            "The file in table 2 changed - do you want to reload?",
            "COMPARE DISSI: File change...",
             JOptionPane.WARNING_MESSAGE, JOptionPane.OK_CANCEL_OPTION, null, null, null);
            if (answer == JOptionPane.YES_OPTION)
                jTextFieldTileFile1ActionPerformed(null);
        }
        else
        {
            int answer = JOptionPane.showOptionDialog(Configuration.getConfiguration().getMainFrame(), 
            "The file in table 1 changed - do you want to reload?",
            "COMPARE DISSI: File change...",
             JOptionPane.WARNING_MESSAGE, JOptionPane.OK_CANCEL_OPTION, null, null, null);
            if (answer == JOptionPane.YES_OPTION)
                jTextFieldTileFileActionPerformed(null);
        }
    }

    void doOnDelete(boolean useSecondtable)
    {
        if (useSecondtable)
        {
            int answer = JOptionPane.showOptionDialog(Configuration.getConfiguration().getMainFrame(), 
            "The file in table 2 was deleted - do you want to remove it?",
            "COMPARE DISSI: File delete...",
             JOptionPane.WARNING_MESSAGE, JOptionPane.OK_CANCEL_OPTION, null, null, null);
            if (answer == JOptionPane.YES_OPTION)
                jTextFieldTileFile1ActionPerformed(null);
        }
        else
        {
            int answer = JOptionPane.showOptionDialog(Configuration.getConfiguration().getMainFrame(), 
            "The file in table 1 was deleted - do you want to remove it?",
            "COMPARE DISSI: File delete...",
             JOptionPane.WARNING_MESSAGE, JOptionPane.OK_CANCEL_OPTION, null, null, null);
            if (answer == JOptionPane.YES_OPTION)
                jTextFieldTileFileActionPerformed(null);
        }
    }

    public String dis(String name, int startAddress, boolean useSecondtable)
    {
        if (!useSecondtable)
        {
            if (watchLeft!=null)
            {
                watchLeft.stopThread();
                watchLeft = null;
            }


            init = false;
            dasm.reset();
            loadedName = name;
            Path path = Paths.get(name);

            dasm.tryLoadList(name);
            dasm.tryLoadCNT(name);

            dasm.setCreateLabels(createUnkownLabels);

            String ret = "";
            try
            {
                byte[] data = Files.readAllBytes(path);

                ret = dasm.disassemble(data,startAddress, startAddress, assumeVectrex);
                jLabel10.setForeground(jLabel1.getForeground());
                jLabel10.setText("loaded");

                watchLeft = new FileWatcher(new File(name), useSecondtable, this);
                watchLeft.start();
            }
            catch (Throwable e)
            {
                jLabel10.setForeground(Color.RED);
                jLabel10.setText("not loaded!");
     //           ret = dasm.disassemble(null,startAddress, startAddress, assumeVectrex);
            }

            correctModel();
            init = true;
            return ret;
        }

        if (watchRight!=null)
        {
            watchRight.stopThread();
            watchRight = null;
        }


        init1 = false;
        dasm1.reset();
        loadedName1 = name;
        Path path = null;
        
        try
        {
            path = Paths.get(name);
        }
        catch (Throwable e)
        {}
        String ret = "";
        if (path != null)
        {
            dasm1.tryLoadList(name);
            dasm1.tryLoadCNT(name);

            dasm1.setCreateLabels(createUnkownLabels);
            try
            {
                byte[] data = Files.readAllBytes(path);

                ret = dasm1.disassemble(data,startAddress, startAddress, assumeVectrex);
                jLabel9.setForeground(jLabel1.getForeground());
                jLabel9.setText("loaded");
                watchRight = new FileWatcher(new File(name), useSecondtable, this);
                watchRight.start();
            }
            catch (Throwable e)
            {
                // System.out.println(de.malban.util.Utility.getStackTrace(e));
                jLabel9.setForeground(Color.RED);
                jLabel9.setText("not loaded!");
    //            ret = dasm1.disassemble(null,startAddress, startAddress, assumeVectrex);
            }
        
        }

        correctModel();
        init = true;
        return ret;
    }
    public boolean isInit()
    {
        return init;
    }
    private void buildDifs()
    {
        activeDif = -1;
        allDifCount = 0;

        // byte difs
        byteDifs = new ArrayList<Integer>();
        if (model == null) return;
        if (model1 == null) return;
        Memory data1 =  model.getOrgData();
        Memory data2 =  model1.getOrgData();

        
        for (int i=0; i<65536; i++)
        {
            MemoryInformation memInfo1 = data1.memMap.get(i);
            MemoryInformation memInfo2 = data2.memMap.get(i);
            
            if (memInfo1.content != memInfo2.content)
                byteDifs.add(i);
        }        
        if (jCheckBoxSourceMode.isSelected())
        {
            int difCount = 0;
            for (int aa=0;aa<model.getRowCount(); aa++)
            {
                MemoryInformation memInfo = model.getValueAt(aa);

                // compare row by number
                String cmp1 = "";
                String cmp2 = "";
                if (aa<model1.getRowCount())
                    cmp1 = model1.getValueAt(aa,2).toString();
                if (aa<model.getRowCount())
                    cmp2 = model.getValueAt(aa,2).toString();

                // compare row by address
                String cmp3 = "";
                int arow = model1.getRowForAddress(memInfo.address);
                if (arow != -1)
                {
                    cmp3 = model1.getValueAt(arow,2).toString();
                }
                boolean isDif = !cmp2.equals(cmp3);
                if (isDif)
                {
                    difCount++;
                }
            }
            jLabelDifsFound.setText("difs found: "+difCount);
            allDifCount = difCount;
        }
        else
        {
            jLabelDifsFound.setText("difs found: "+byteDifs.size());
            allDifCount = byteDifs.size();
        }
    }
    int getColumnNameIndex1(String n)
    {
        int i= 0;
        for (;i<model.columnNamesSmall.length; i++ )
        {
            if (n.equals(model.columnNamesSmall[i])) return i;
        }
        return -1;
    }
    int getColumnNameIndex2(String n)
    {
        int i= 0;
        for (;i<model1.columnNamesSmall.length; i++ )
        {
            if (n.equals(model1.columnNamesSmall[i])) return i;
        }
        return -1;
    }
    
    public void correctModel()
    {
        jTextFieldCurrentDifAdr.setText("-");
        buildDifs();
        if (model != null)
        {
            model.showAll();
            if (jCheckBox1.isSelected())
                model.reduceUnkown();
            if (jCheckBox2.isSelected())
                model.reduceCompleteInstructions();
            
            model.reduceInvisible();

            jTableSource.tableChanged(null);

        }

        if (model1 != null)
        {
            model1.showAll();
            if (jCheckBox1.isSelected())
                model1.reduceUnkown();
            if (jCheckBox2.isSelected())
                model1.reduceCompleteInstructions();
            
            model1.reduceInvisible();

            jTableSource1.tableChanged(null);
        }
        setUpTableColumns();

        if (model != null)
        {
            jTableSource.setAutoResizeMode(AUTO_RESIZE_LAST_COLUMN);
            for (int i=0; i< jTableSource.getColumnModel().getColumnCount(); i++)
            {
                // since "invisible" the columns in the model of jTableSource are not 
                // present in the table model, the actual number is also the VIEW
                int colData = i;//currentDissi.model.convertViewToModel(i);

                String n = jTableSource.getColumnModel().getColumn(i).getHeaderValue().toString();
                int ci = getColumnNameIndex1(n);

                jTableSource.getColumnModel().getColumn(i).setPreferredWidth(model.getColWidth1(ci));    
                jTableSource.getColumnModel().getColumn(i).setWidth(model.getColWidth1(ci));  
            }
            jTableSource.setAutoResizeMode(AUTO_RESIZE_SUBSEQUENT_COLUMNS);
        }

        if (model1 != null)
        {
            jTableSource1.setAutoResizeMode(AUTO_RESIZE_LAST_COLUMN);
            for (int i=0; i< jTableSource1.getColumnModel().getColumnCount(); i++)
            {
                // since "invisible" the columns in the model of jTableSource are not 
                // present in the table model, the actual number is also the VIEW
                int colData = i;//currentDissi.model.convertViewToModel(i);

                String n = jTableSource1.getColumnModel().getColumn(i).getHeaderValue().toString();
                int ci = getColumnNameIndex2(n);

                jTableSource1.getColumnModel().getColumn(i).setPreferredWidth(model1.getColWidth2(ci));    
                jTableSource1.getColumnModel().getColumn(i).setWidth(model1.getColWidth2(ci));  
            }
            jTableSource1.setAutoResizeMode(AUTO_RESIZE_SUBSEQUENT_COLUMNS);
        }


    }
    
    public void updateTableOnly()
    {
        jTableSource.repaint();
        jTableSource1.repaint();
    }
    
    public void goRow(int row, boolean forceTopRow)
    {
        if (!init) return;
        
        jTableSource.setRowSelectionInterval(row, row);
        if (forceTopRow)
            scrollToVisible(jTableSource, row,0) ;
        jTableSource.scrollRectToVisible(jTableSource.getCellRect(row, 0, true));
    }    
    public void goAddress(int address, boolean forceTopRow, boolean userGo, boolean forceUpdate)
    {
        if (!init) return;
        if (!forceUpdate) // single step e.g. always must update!
        {
            if (!userGo)
            {
                if (!updateEnabled) return;
            }
        }
        
        
        // select line in table and jump to display that!
        int row = model.getNearestVisibleRow( address);
        if (row == -1 ) return;
        // select
        jTableSource.setRowSelectionInterval(row, row);
        if (forceTopRow)
            scrollToVisible(jTableSource, row,0) ;
        // and jump there!
            jTableSource.scrollRectToVisible(jTableSource.getCellRect(row, 0, true));
            
            
        if (!jCheckBoxSync.isSelected())
        {
            row = model1.getNearestVisibleRow( address);
            if (row == -1 ) return;
            // select
            jTableSource1.setRowSelectionInterval(row, row);
            if (forceTopRow)
                scrollToVisible(jTableSource1, row,0) ;
            // and jump there!
                jTableSource1.scrollRectToVisible(jTableSource1.getCellRect(row, 0, true));
        }
            
            
    }
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
        
        try{
          table.changeSelection(rowIndex,0,false,false);
          if(rowIndex > currentSelectedRow)
          {
            r = table.getCellRect(rowIndex-1, 0, true);
            vph = vp.getExtentSize().height;
            r.y += vph;
            table.scrollRectToVisible(r);
          }
        }catch(Exception e){/*error message*/}

    
    }
    public int getInstructionLengthAt(int address)
    {
        if (!init) return 1;
        return dasm.getInstructionLengthAt(address);
    }
    
    private void initTable()
    {
        model = dasm.getTableModelSmall();
        jTableSource.setModel(model);
        jTableSource.tableChanged(null);
        //jTableSource.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
        jTableSource.setRowSelectionAllowed(true);
        jTableSource.setDefaultRenderer(Object.class, new DefaultTableCellRenderer()
        {
            @Override
            public Component getTableCellRendererComponent(JTable table, Object value, boolean isSelected, boolean hasFocus, int row, int col) 
            {
                super.getTableCellRendererComponent(table, value, isSelected, hasFocus, row, col);

                if (table.getModel() instanceof MemoryInformationTableModelSmall)
                {
                    MemoryInformationTableModelSmall localModel = (MemoryInformationTableModelSmall)table.getModel();
                    MemoryInformationTableModelSmall otherModel;
                    if(localModel.equals(model1))   
                        otherModel=model;
                    else 
                        otherModel=model1;

                    MemoryInformation memInfo = localModel.getValueAt(row);

                    
                    
                    
                    
                    boolean isDif = false;
                    if (!jCheckBoxSourceMode.isSelected())
                    {
                        // we are interested in all adresses covered by this row
                        int startAddress = DASM6809.toNumber(localModel.getValueAt(row,0).toString()); // address
                        int endAddress = startAddress + DASM6809.toNumber(localModel.getValueAt(row,10).toString()); // length
                        
                        for (int aa=startAddress; aa<endAddress; aa++)
                        {
                            for (int dd = 0; dd<byteDifs.size(); dd++)
                            {
                                if (byteDifs.get(dd) == aa) isDif = true;
                            }
                        }
                    }
                    else
                    {

                        // compare row by number
                        String cmp1 = "";
                        if (otherModel.getRowCount()>row)
                            cmp1 = otherModel.getValueAt(row,2).toString();
                        String cmp2 = "";
                        if (localModel.getRowCount()>row)
                            cmp2 = localModel.getValueAt(row,2).toString();

                        // compare row by address
                        String cmp3 = "";

                        int arow = otherModel.getRowForAddress(memInfo.address);
                        if (arow != -1)
                        {
                            cmp3 = otherModel.getValueAt(arow,2).toString();
                        }
    //                    if (!cmp1.equals(cmp2))
                        isDif = !cmp2.equals(cmp3);
                    }
                    if (isDif)
                    {
                        setBackground(config.valueChanged);
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
                            Color back = localModel.getBackground(row, col);
                            Color fore = localModel.getForeground(row, col);
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
                    if (col == 1)
                    {
                        AttributeSet s = TokenStyles.getStyle("identifier");
                        this.setForeground(StyleConstants.getForeground(s));
                    }

                    if (col == 3)
                    {
                        AttributeSet s = TokenStyles.getStyle("reservedWord");
                        AttributeSet _preprop = TokenStyles.getStyle("preprocessor");
                        String mnemonic = "";
                        if (value!=null)
                        {
                            mnemonic = value.toString().toLowerCase();
                        }
                        if ((mnemonic.equals("db")) || (mnemonic.equals("dw")))
                        {
                            this.setForeground(StyleConstants.getForeground(_preprop));
                        }
                        else
                            this.setForeground(StyleConstants.getForeground(s));
                    }

                }
                return this;
            }   
        });        
        // only set up initially, otherwise it gets less and less :-)
        if (allColumns1 == null)
        {
            allColumns1 = new ArrayList<TableColumn>();
            for (int i=0; i< model.getColumnOrgCount(); i++)
            {
                allColumns1.add(jTableSource.getColumnModel().getColumn(i));
            }
        }
        model.setSmallMode(true);
                


        
        model1 = dasm1.getTableModelSmall();
        jTableSource1.setModel(model1);
        jTableSource1.tableChanged(null);
        //jTableSource.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
        jTableSource1.setRowSelectionAllowed(true);
        jTableSource1.setDefaultRenderer(Object.class, new DefaultTableCellRenderer()
        {
            @Override
            public Component getTableCellRendererComponent(JTable table, Object value, boolean isSelected, boolean hasFocus, int row, int col) 
            {
                super.getTableCellRendererComponent(table, value, isSelected, hasFocus, row, col);

                if (table.getModel() instanceof MemoryInformationTableModelSmall)
                {
                    MemoryInformationTableModelSmall localModel = (MemoryInformationTableModelSmall)table.getModel();
                    MemoryInformationTableModelSmall otherModel;
                    if(localModel.equals(model1))   
                        otherModel=model;
                    else 
                        otherModel=model1;

                    MemoryInformation memInfo = localModel.getValueAt(row);

                    boolean isDif = false;
                    if (!jCheckBoxSourceMode.isSelected())
                    {
                        // we are interested in all adresses covered by this row
                        int startAddress = DASM6809.toNumber(localModel.getValueAt(row,0).toString()); // address
                        int endAddress = startAddress + DASM6809.toNumber(localModel.getValueAt(row,10).toString()); // length
                        
                        for (int aa=startAddress; aa<endAddress; aa++)
                        {
                            for (int dd = 0; dd<byteDifs.size(); dd++)
                            {
                                if (byteDifs.get(dd) == aa) isDif = true;
                            }
                        }
                    }
                    else
                    {
                        // compare row by number
                        String cmp1 = "";
                        if (otherModel.getRowCount()>row)
                            cmp1 = otherModel.getValueAt(row,2).toString();
                        String cmp2 = "";
                        if (localModel.getRowCount()>row)
                            cmp2 = localModel.getValueAt(row,2).toString();

                        // compare row by address
                        String cmp3 = "";

                        int arow = otherModel.getRowForAddress(memInfo.address);
                        if (arow != -1)
                        {
                            cmp3 = otherModel.getValueAt(arow,2).toString();
                        }
    //                    if (!cmp1.equals(cmp2))
                        isDif = !cmp2.equals(cmp3);
                    }
                    if (isDif)
                    {
                        setBackground(config.valueChanged);
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
                            Color back = localModel.getBackground(row, col);
                            Color fore = localModel.getForeground(row, col);
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
                    if (col == 3)
                    {
                        AttributeSet s = TokenStyles.getStyle("reservedWord");
                        AttributeSet _preprop = TokenStyles.getStyle("preprocessor");
                        String mnemonic = "";
                        if (value!=null)
                        {
                            mnemonic = value.toString().toLowerCase();
                        }
                        if ((mnemonic.equals("db")) || (mnemonic.equals("dw")))
                        {
                            this.setForeground(StyleConstants.getForeground(_preprop));
                        }
                        else
                            this.setForeground(StyleConstants.getForeground(s));


                    }
                    if (col == 1)
                    {
                        AttributeSet s = TokenStyles.getStyle("identifier");
                        this.setForeground(StyleConstants.getForeground(s));
                    }
                    
                    
                }
                return this;
            }   
        });      

        if (allColumns2 == null)
        {
            allColumns2 = new ArrayList<TableColumn>();
            for (int i=0; i< model1.getColumnOrgCount(); i++)
            {
                allColumns2.add(jTableSource1.getColumnModel().getColumn(i));
            }
        }
        model1.setSmallMode(true);

        jTableSource.tableChanged(null);
        jTableSource1.tableChanged(null);
        CompareDissiPanel.configChanged();

        setUpTableColumns();
    
        
        
        
        sBar1Model = jScrollPane2.getVerticalScrollBar().getModel();
        sBar2Model = jScrollPane4.getVerticalScrollBar().getModel();
        jScrollPane4.getVerticalScrollBar().setModel(sBar1Model); //<--------------synchronize            
    }
    BoundedRangeModel sBar1Model;
    BoundedRangeModel sBar2Model;
    
    public int getCurrentAddress()
    {
        if (!init) return -1;
        int row = jTableSource.getSelectedRow();
        if (row == -1) return -1;
        MemoryInformationTableModelSmall model = (MemoryInformationTableModelSmall)jTableSource.getModel();
        MemoryInformation memInfo = model.getValueAt(row);
        return memInfo.address;
    }

    public MemoryInformation getMemoryInformation(int address)
    {
        return dasm.myMemory.memMap.get(address);
    }
    public Memory getMemory()
    {
        return dasm.myMemory;
    }
    
    public static String SID = "Compare Disassembled";
    public String getID()
    {
        return SID;
    }
    @Override public String getFileID()
    {
        return de.malban.util.UtilityString.replace(de.malban.util.UtilityString.replaceWhiteSpaces(SID, ""),":","");
    }
    JTable buildTable()
    {
        JTable table = new JTable();       
        table.putClientProperty("terminateEditOnFocusLost", Boolean.TRUE);  
       return  table;
        
    }
    boolean keyEventsAreSet = false;
    private void setupKeyEvents()
    {
        if (keyEventsAreSet) return;
        keyEventsAreSet = true;

        jTextFieldCurrentDifAdr.getInputMap(WHEN_FOCUSED).put(KeyStroke.getKeyStroke(KeyEvent.VK_DOWN,0, false), "command next");
        jTextFieldCurrentDifAdr.getActionMap().put("command next", new AbstractAction() { public void actionPerformed(ActionEvent e) {   commandHistoryNext(); }});
        jTextFieldCurrentDifAdr.getInputMap(WHEN_FOCUSED).put(KeyStroke.getKeyStroke(KeyEvent.VK_UP,0, false), "command previous");
        jTextFieldCurrentDifAdr.getActionMap().put("command previous", new AbstractAction() { public void actionPerformed(ActionEvent e) {  commandHistoryPrevious(); }});
        
        new HotKey("dif next", new AbstractAction() { public void actionPerformed(ActionEvent e) {  jButtonDifNextActionPerformed(null); }}, this);
        new HotKey("dif previous", new AbstractAction() { public void actionPerformed(ActionEvent e) {  jButtonDifPreviousActionPerformed(null); }}, this);
    }   
    private boolean updateEnabled = false;
    public void updateValues(boolean forceUpdate)
    {
        if (!forceUpdate)
            if (!updateEnabled) return;
        updateTableOnly();
    }
    public void setUpdateEnabled(boolean b)
    {
        updateEnabled = b;
    }
    
    // if we do that more often, we should build a lookup table for labels as a hashmap!
    int getLabelAddr(String label)
    {
        Memory mem = dasm.myMemory;
        
        for (int i=0; i<65536; i++)
        {
            MemoryInformation memInfo = mem.memMap.get(i);
            for (String l: memInfo.labels)
            {
                if (l.equals(label)) 
                    return i;
            }
        }
        return 0; // not successull
        
    }
    
    
    public void printMessage(String s, String type)
    {
//        try
//        {
//            jEditorPane1.getDocument().insertString(jEditorPane1.getDocument().getLength(), s+"\n", TokenStyles.getStyle(type));
//        } catch (Throwable e) { }
//        jEditorPane1.setCaretPosition(jEditorPane1.getDocument().getLength());
    }
    
    static class SplitterLocation implements Serializable
    {
        int pos=0;
    }
    private void calcCRC()
    {
        int start = DASM6809.toNumber(jTextField1.getText());
        int end = DASM6809.toNumber(jTextField2.getText());
        
        jTextField3.setText(""+dasm.myMemory.getCRC(start, end));
        jTextField4.setText(""+dasm1.myMemory.getCRC(start, end));
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
        int fontSize = Theme.textFieldFont.getFont().getSize();
        int rowHeight = fontSize+2;
        jTableSource.setRowHeight(rowHeight);
        jTableSource1.setRowHeight(rowHeight);
    }
    public void deIconified() { }
    
    void setPrevDif()
    {
        if (allDifCount==0)
        {
            int maxRow = 0;
            jTableSource.setRowSelectionInterval(maxRow, maxRow);
            jTableSource.scrollRectToVisible(jTableSource.getCellRect(maxRow, 0, true));
            jTextFieldCurrentDifAdr.setText("-");

            if (!jCheckBoxSync.isSelected())
            {
                jTableSource1.setRowSelectionInterval(maxRow, maxRow);
                jTableSource1.scrollRectToVisible(jTableSource1.getCellRect(maxRow, 0, true));
            }

            return;
        }

        int address = -1;
        if (activeDif<=0) 
        {
            activeDif = -1;
            int maxRow = 0;
            jTableSource.setRowSelectionInterval(maxRow, maxRow);
            jTableSource.scrollRectToVisible(jTableSource.getCellRect(maxRow, 0, true));

            if (!jCheckBoxSync.isSelected())
            {
                jTableSource1.setRowSelectionInterval(maxRow, maxRow);
                jTableSource1.scrollRectToVisible(jTableSource1.getCellRect(maxRow, 0, true));
            }

            jTextFieldCurrentDifAdr.setText("-");
            return;
        }
        activeDif--;
        if (jCheckBoxSourceMode.isSelected())
        {
            int difCount = 0;
            for (int aa=0;aa<model.getRowCount(); aa++)
            {
                MemoryInformation memInfo = model.getValueAt(aa);

                // compare row by number
                String cmp1 = "";
                String cmp2 = "";
                if (aa<model1.getRowCount())
                    cmp1 = model1.getValueAt(aa,2).toString();
                if (aa<model.getRowCount())
                    cmp2 = model.getValueAt(aa,2).toString();

                // compare row by address
                String cmp3 = "";
                int arow = model1.getRowForAddress(memInfo.address);
                if (arow != -1)
                {
                    cmp3 = model1.getValueAt(arow,2).toString();
                }
                boolean isDif = !cmp2.equals(cmp3);
                if (isDif)
                {
                    if (difCount == activeDif)
                    {
                        address = memInfo.address;
                        break;
                    }
                    difCount++;
                }
            }
        }
        else
        {
            if (activeDif>=0)
                address = byteDifs.get(activeDif);
        }
        if (address != -1)
        {
            goAddress(address, false,true,true);
            jTextFieldCurrentDifAdr.setText(""+(activeDif+1)+": "+String.format("$%04X",address&0xffff ));
        }
        else
        {
            jTextFieldCurrentDifAdr.setText("-");
        }
    }
    
    void setNextDif()
    {
        if (allDifCount==0)
        {
            int maxRow = model.getRowCount()-1;
            jTableSource.setRowSelectionInterval(maxRow, maxRow);
            jTableSource.scrollRectToVisible(jTableSource.getCellRect(maxRow, 0, true));
            
            if (!jCheckBoxSync.isSelected())
            {
                maxRow = model1.getRowCount()-1;
                jTableSource1.setRowSelectionInterval(maxRow, maxRow);
                jTableSource1.scrollRectToVisible(jTableSource1.getCellRect(maxRow, 0, true));
            }
            
            return;
        }

        int address = -1;
        activeDif++;
        if (jCheckBoxSourceMode.isSelected())
        {
            int difCount = 0;
            for (int aa=0;aa<model.getRowCount(); aa++)
            {
                MemoryInformation memInfo = model.getValueAt(aa);

                // compare row by number
                String cmp1 = "";
                String cmp2 = "";
                if (aa<model1.getRowCount())
                    cmp1 = model1.getValueAt(aa,2).toString();
                if (aa<model.getRowCount())
                    cmp2 = model.getValueAt(aa,2).toString();

                // compare row by address
                String cmp3 = "";
                int arow = model1.getRowForAddress(memInfo.address);
                if (arow != -1)
                {
                    cmp3 = model1.getValueAt(arow,2).toString();
                }
                boolean isDif = !cmp2.equals(cmp3);
                if (isDif)
                {
                    if (difCount == activeDif)
                    {
                        address = memInfo.address;
                        break;
                    }
                    difCount++;
                }
            }
        }
        else
        {
            if (activeDif>=byteDifs.size())
            {
                while (activeDif>=byteDifs.size()) activeDif--;
                activeDif++;

                int maxRow = model.getRowCount()-1;
                jTableSource.setRowSelectionInterval(maxRow, maxRow);
                jTableSource.scrollRectToVisible(jTableSource.getCellRect(maxRow, 0, true));


                if (!jCheckBoxSync.isSelected())
                {
                    maxRow = model1.getRowCount()-1;
                    jTableSource1.setRowSelectionInterval(maxRow, maxRow);
                    jTableSource1.scrollRectToVisible(jTableSource1.getCellRect(maxRow, 0, true));
                }

                jTextFieldCurrentDifAdr.setText("-");
                return;
            }
            else
            if (activeDif>=0)
            {
                address = byteDifs.get(activeDif);
            }
        }
        if (address != -1)
        {
            goAddress(address, false,true,true);
//            jTextFieldCurrentDifAdr.setText(String.format("$%04X",address&0xffff ));
            jTextFieldCurrentDifAdr.setText(""+(activeDif+1)+": "+String.format("$%04X",address&0xffff ));
        }
        else
        {
            jTextFieldCurrentDifAdr.setText("-");
        }
    }

    DisCompareFileStrings s = new DisCompareFileStrings();
    public Serializable getAdditionalStateinfo()
    {
        s = new DisCompareFileStrings();
        s.s1 = jTextFieldTileFile.getText();
        s.s2 = jTextFieldTileFile1.getText();
        s.lastDir1 = this.lastDir1;
        s.lastDir2 = this.lastDir2;
        s.synced = jCheckBoxSync.isSelected();

        for (int i = 0;i<jTableSource.getColumnCount(); i++)
        {
            TableColumn tcol = jTableSource.getColumnModel().getColumn(i);
            String n = jTableSource.getColumnModel().getColumn(i).getHeaderValue().toString();
            int ci = getColumnNameIndex1(n);
            MemoryInformationTableModelSmall.columnWidthSmall1[ci] = tcol.getWidth();
        }
        for (int i = 0;i<jTableSource1.getColumnCount(); i++)
        {
            TableColumn tcol = jTableSource1.getColumnModel().getColumn(i);
            String n = jTableSource1.getColumnModel().getColumn(i).getHeaderValue().toString();
            int ci = getColumnNameIndex2(n);
            MemoryInformationTableModelSmall.columnWidthSmall2[ci] = tcol.getWidth();
        }


        
        for (int i=0;i<MemoryInformationTableModelSmall.columnVisibleALL.length; i++)
            s.columnVisibleALL[i]= MemoryInformationTableModelSmall.columnVisibleALL[i];
        for (int i=0;i<MemoryInformationTableModelSmall.columnWidthSmall1.length; i++)
            s.columnWidthSmall1[i]= MemoryInformationTableModelSmall.columnWidthSmall1[i];
        for (int i=0;i<MemoryInformationTableModelSmall.columnWidthSmall2.length; i++)
            s.columnWidthSmall2[i]= MemoryInformationTableModelSmall.columnWidthSmall2[i];
        
        
        return s;
    }
    public void setAdditionalStateinfo(Serializable ser)
    {
        if (ser == null) return;
        if (!(ser instanceof DisCompareFileStrings)) return;
        s = (DisCompareFileStrings) ser;
        jTextFieldTileFile.setText(s.s1);
        jTextFieldTileFileActionPerformed(null);

        jTextFieldTileFile1.setText(s.s2);
        jTextFieldTileFile1ActionPerformed(null);

        jCheckBoxSync.setSelected(s.synced);

        this.lastDir1 = s.lastDir1;
        this.lastDir2 = s.lastDir2;

        MemoryInformationTableModelSmall.columnVisibleALL = new Boolean[MemoryInformationTableModelSmall.columnVisibleALL.length];// = new Boolean[sl.columnVisible.length];
        MemoryInformationTableModelSmall.columnWidthSmall1 = new int[MemoryInformationTableModelSmall.columnWidthSmall1.length];//= new int[sl.columnWidthSmall.length];
        MemoryInformationTableModelSmall.columnWidthSmall2 = new int[MemoryInformationTableModelSmall.columnWidthSmall2.length];//= new int[sl.columnWidthSmall.length];

        // defaults
        for (int i=0;i<MemoryInformationTableModelSmall.columnWidthSmall1.length; i++)
            MemoryInformationTableModelSmall.columnWidthSmall1[i]= 100;
        for (int i=0;i<MemoryInformationTableModelSmall.columnWidthSmall2.length; i++)
            MemoryInformationTableModelSmall.columnWidthSmall2[i]= 100;

        for (int i=0;i<s.columnVisibleALL.length; i++)
            MemoryInformationTableModelSmall.columnVisibleALL[i]= s.columnVisibleALL[i];

        for (int i=0;i<s.columnWidthSmall1.length; i++)
            MemoryInformationTableModelSmall.columnWidthSmall1[i]= s.columnWidthSmall1[i];
        for (int i=0;i<s.columnWidthSmall2.length; i++)
            MemoryInformationTableModelSmall.columnWidthSmall2[i]= s.columnWidthSmall2[i];

        MemoryInformationTableModelSmall.wasInit = true;
        configChanged();
        correctModel();
        jCheckBoxSyncActionPerformed(null);
    }
}
