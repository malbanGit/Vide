/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.codi;

import de.malban.Global;
import de.malban.config.Configuration;
import de.malban.config.TinyLogInterface;
import de.malban.gui.CSAMainFrame;
import static de.malban.util.Utility.makeGlobalAbsolute;
import de.malban.util.syntax.Syntax.TokenStyles;
import de.malban.util.UtilityString;
import de.malban.vide.VideConfig;
import de.malban.vide.assy.Asmj;
import de.malban.vide.script.ExecutionDescriptor;
import static de.malban.vide.script.ExecutionDescriptor.ED_TYPE_PROJECT_POST;
import static de.malban.vide.script.ExecutionDescriptor.ED_TYPE_PROJECT_PRE;
import de.malban.vide.script.ScriptDataPanel;
import static de.malban.vide.vecx.VecX.START_TYPE_RUN;
import de.malban.vide.vecx.VecXPanel;
import de.malban.vide.vecx.cartridge.Cartridge;
import de.malban.vide.vecx.cartridge.CartridgeProperties;
import de.malban.vide.vedi.EditorEvent;
import de.malban.vide.vedi.EditorListener;
import de.malban.vide.vedi.VEdiFoundationPanel;
import static de.malban.vide.vedi.VEdiFoundationPanel.ASM_LIST;
import static de.malban.vide.vedi.VEdiFoundationPanel.ASM_MESSAGE_ERROR;
import static de.malban.vide.vedi.VediPanel.convertSeperator;
import de.malban.vide.vedi.project.ProjectProperties;
import de.malban.vide.vedi.project.ProjectPropertiesPool;
import java.io.File;
import java.io.Serializable;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Vector;
import javax.swing.JEditorPane;
import javax.swing.JFrame;
import javax.swing.SwingUtilities;
import javax.swing.tree.DefaultMutableTreeNode;
import javax.swing.tree.DefaultTreeModel;



/**
 *
 * @author malban
 * 
 * Category1  DIR
 *   Name1    DIR
 *    - Describtion (short)         readme.txt     
 *    - CodeFile                    name_main.asm
 *    - VariablesFile (RAM)         name_ram.i
 *    - declarationFile (Include)   name_inc.i
 *    - Working COMPLETE example    name_example.asm
 * 
 * Category2
 *   Name1
 *   Name2...
 */
public class CodeLibraryPanel extends VEdiFoundationPanel implements TinyLogInterface, EditorListener
{
    public JFrame getFrame()
    {
        return (CSAMainFrame)mParent;
    }
    VideConfig config = VideConfig.getConfig();
    public void printASMList(String s, int type){}
    public void printASMMessage(String s, int type)
    {
        try
        {
            if (type == ASM_MESSAGE_INFO)
            {
                jEditorLog.getDocument().insertString(jEditorLog.getDocument().getLength(), s, TokenStyles.getStyle("editLogMessage"));
            }
            else if (type == ASM_MESSAGE_ERROR)
            {
                jEditorLog.getDocument().insertString(jEditorLog.getDocument().getLength(), s, TokenStyles.getStyle("editLogError"));
            }
            else if (type == ASM_MESSAGE_WARNING)
            {
                jEditorLog.getDocument().insertString(jEditorLog.getDocument().getLength(), s, TokenStyles.getStyle("editLogWarning"));
            }
            else if (type == ASM_MESSAGE_OPTIMIZATION)
            {
                jEditorLog.getDocument().insertString(jEditorLog.getDocument().getLength(), s, TokenStyles.getStyle("editLogComment"));
            }
        } catch (Throwable e) { }
        jEditorLog.setCaretPosition(jEditorLog.getDocument().getLength());
    }
    String treeName = null;
    String fileName = null;
    boolean init = false;

    // adds a green"asterix" to the bottom, which lights up when Syntax scan is active!
    
    private String lastPath="";    
    public static String SID = "codi";
    public String getID()
    {
        return SID;
    }
    /**
     * Creates new form RegisterJPanel
     */
    public CodeLibraryPanel() {
        initComponents();
        
        jEditorLog.setEditable(false);
        jEditorLog.setContentType("text/html");
        
        init();
    }
    @Override
    public void setMenuItem(javax.swing.JMenuItem item)
    {
        mParentMenuItem = item;
        mParentMenuItem.setText("Codi");

    }
    protected boolean closeRequested(String tabName)
    {
        return true;
    }
    public void deinit()
    {
        saveSettings();
        init = false;
    }    
    public void init()
    {
        initSyntax();
        loadSettings();
        fillTree();
        init = true;
        
        
    }
    void repaintLater()
    {
        SwingUtilities.invokeLater(new Runnable()
        {
            public void run()
            {
                codeEditorPanel.correctLineNumbers(true);
                invalidate();
                validate();
                repaint();
            }
        });                    
        
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

    
    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jPanel1 = new javax.swing.JPanel();
        jButtonAssemble = new javax.swing.JButton();
        jButtonCopy = new javax.swing.JButton();
        jSplitPane1 = new javax.swing.JSplitPane();
        jSplitPane2 = new javax.swing.JSplitPane();
        jScrollPane1 = new javax.swing.JScrollPane();
        jTree1 = new javax.swing.JTree();
        jLayeredPane1 = new javax.swing.JLayeredPane();
        codeEditorPanel = new de.malban.vide.vedi.EditorPanel();
        singleImagePanel = new de.malban.graphics.SingleImagePanel();
        htmlScrollPane3 = new javax.swing.JScrollPane();
        htmlEditorPane = new javax.swing.JEditorPane();
        jPanel4 = new javax.swing.JPanel();
        jPanel2 = new javax.swing.JPanel();
        jPanel3 = new javax.swing.JPanel();
        jLabel1 = new javax.swing.JLabel();
        jTextFieldSearch = new javax.swing.JTextField();
        jButtonSearchNext = new javax.swing.JButton();
        jButtonSearchPrevious = new javax.swing.JButton();
        jButtonIgnoreCase = new javax.swing.JButton();
        jCheckBoxIgnoreCase = new javax.swing.JCheckBox();
        jLabel5 = new javax.swing.JLabel();
        jTabbedPane = new javax.swing.JTabbedPane();
        jScrollPane2 = new javax.swing.JScrollPane();
        jEditorLog = new javax.swing.JEditorPane();

        setName("regi"); // NOI18N

        jPanel1.setBorder(javax.swing.BorderFactory.createEtchedBorder());

        jButtonAssemble.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/control_play_blue.png"))); // NOI18N
        jButtonAssemble.setToolTipText("Redo");
        jButtonAssemble.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonAssemble.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonAssembleActionPerformed(evt);
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

        jSplitPane1.setDividerLocation(300);
        jSplitPane1.setOrientation(javax.swing.JSplitPane.VERTICAL_SPLIT);
        jSplitPane1.setResizeWeight(1.0);
        jSplitPane1.setMinimumSize(new java.awt.Dimension(224, 164));
        jSplitPane1.setPreferredSize(new java.awt.Dimension(576, 700));

        jSplitPane2.setDividerLocation(200);
        jSplitPane2.setPreferredSize(new java.awt.Dimension(964, 100));

        jScrollPane1.setPreferredSize(new java.awt.Dimension(145, 50));

        javax.swing.tree.DefaultMutableTreeNode treeNode1 = new javax.swing.tree.DefaultMutableTreeNode("CodeLibrary");
        javax.swing.tree.DefaultMutableTreeNode treeNode2 = new javax.swing.tree.DefaultMutableTreeNode("BIOS replacements");
        javax.swing.tree.DefaultMutableTreeNode treeNode3 = new javax.swing.tree.DefaultMutableTreeNode("blue");
        treeNode2.add(treeNode3);
        treeNode3 = new javax.swing.tree.DefaultMutableTreeNode("violet");
        treeNode2.add(treeNode3);
        treeNode3 = new javax.swing.tree.DefaultMutableTreeNode("red");
        treeNode2.add(treeNode3);
        treeNode3 = new javax.swing.tree.DefaultMutableTreeNode("yellow");
        treeNode2.add(treeNode3);
        treeNode1.add(treeNode2);
        treeNode2 = new javax.swing.tree.DefaultMutableTreeNode("sports");
        treeNode3 = new javax.swing.tree.DefaultMutableTreeNode("basketball");
        treeNode2.add(treeNode3);
        treeNode3 = new javax.swing.tree.DefaultMutableTreeNode("soccer");
        treeNode2.add(treeNode3);
        treeNode3 = new javax.swing.tree.DefaultMutableTreeNode("football");
        treeNode2.add(treeNode3);
        treeNode3 = new javax.swing.tree.DefaultMutableTreeNode("hockey");
        treeNode2.add(treeNode3);
        treeNode1.add(treeNode2);
        treeNode2 = new javax.swing.tree.DefaultMutableTreeNode("food");
        treeNode3 = new javax.swing.tree.DefaultMutableTreeNode("hot dogs");
        treeNode2.add(treeNode3);
        treeNode3 = new javax.swing.tree.DefaultMutableTreeNode("pizza");
        treeNode2.add(treeNode3);
        treeNode3 = new javax.swing.tree.DefaultMutableTreeNode("ravioli");
        treeNode2.add(treeNode3);
        treeNode3 = new javax.swing.tree.DefaultMutableTreeNode("bananas");
        treeNode2.add(treeNode3);
        treeNode1.add(treeNode2);
        jTree1.setModel(new javax.swing.tree.DefaultTreeModel(treeNode1));
        jTree1.addTreeSelectionListener(new javax.swing.event.TreeSelectionListener() {
            public void valueChanged(javax.swing.event.TreeSelectionEvent evt) {
                jTree1ValueChanged(evt);
            }
        });
        jScrollPane1.setViewportView(jTree1);

        jSplitPane2.setLeftComponent(jScrollPane1);

        jLayeredPane1.setPreferredSize(new java.awt.Dimension(810, 50));
        jLayeredPane1.setLayout(new javax.swing.OverlayLayout(jLayeredPane1));

        codeEditorPanel.setPreferredSize(new java.awt.Dimension(584, 50));
        jLayeredPane1.add(codeEditorPanel);
        jLayeredPane1.setLayer(codeEditorPanel, 1);

        singleImagePanel.setPreferredSize(new java.awt.Dimension(810, 50));

        javax.swing.GroupLayout singleImagePanelLayout = new javax.swing.GroupLayout(singleImagePanel);
        singleImagePanel.setLayout(singleImagePanelLayout);
        singleImagePanelLayout.setHorizontalGroup(
            singleImagePanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 810, Short.MAX_VALUE)
        );
        singleImagePanelLayout.setVerticalGroup(
            singleImagePanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 297, Short.MAX_VALUE)
        );

        jLayeredPane1.add(singleImagePanel);
        jLayeredPane1.setLayer(singleImagePanel, 2);

        htmlScrollPane3.setViewportView(htmlEditorPane);

        jLayeredPane1.add(htmlScrollPane3);
        jLayeredPane1.setLayer(htmlScrollPane3, 3);

        jPanel4.setPreferredSize(new java.awt.Dimension(810, 50));

        javax.swing.GroupLayout jPanel4Layout = new javax.swing.GroupLayout(jPanel4);
        jPanel4.setLayout(jPanel4Layout);
        jPanel4Layout.setHorizontalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 810, Short.MAX_VALUE)
        );
        jPanel4Layout.setVerticalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 297, Short.MAX_VALUE)
        );

        jLayeredPane1.add(jPanel4);

        jSplitPane2.setRightComponent(jLayeredPane1);

        jSplitPane1.setTopComponent(jSplitPane2);

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

        jLabel5.setForeground(new java.awt.Color(255, 0, 0));
        jLabel5.setToolTipText("");

        javax.swing.GroupLayout jPanel3Layout = new javax.swing.GroupLayout(jPanel3);
        jPanel3.setLayout(jPanel3Layout);
        jPanel3Layout.setHorizontalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addComponent(jCheckBoxIgnoreCase)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonIgnoreCase)
                .addGap(23, 23, 23)
                .addComponent(jLabel1)
                .addGap(2, 2, 2)
                .addComponent(jTextFieldSearch, javax.swing.GroupLayout.PREFERRED_SIZE, 105, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonSearchPrevious)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonSearchNext)
                .addGap(301, 301, 301)
                .addComponent(jLabel5, javax.swing.GroupLayout.PREFERRED_SIZE, 97, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(303, Short.MAX_VALUE))
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
                                .addComponent(jLabel5, javax.swing.GroupLayout.PREFERRED_SIZE, 19, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addComponent(jCheckBoxIgnoreCase)
                            .addComponent(jButtonIgnoreCase))))
                .addGap(2, 2, 2))
        );

        jScrollPane2.setViewportView(jEditorLog);

        jTabbedPane.addTab("Messages", jScrollPane2);

        javax.swing.GroupLayout jPanel2Layout = new javax.swing.GroupLayout(jPanel2);
        jPanel2.setLayout(jPanel2Layout);
        jPanel2Layout.setHorizontalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel3, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addComponent(jTabbedPane)
        );
        jPanel2Layout.setVerticalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addComponent(jTabbedPane)
                .addGap(1, 1, 1)
                .addComponent(jPanel3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
        );

        jSplitPane1.setBottomComponent(jPanel2);

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addComponent(jSplitPane1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addGap(1, 1, 1))
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addComponent(jButtonCopy)
                .addGap(190, 190, 190)
                .addComponent(jButtonAssemble)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jButtonCopy)
                    .addComponent(jButtonAssemble))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jSplitPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 730, Short.MAX_VALUE))
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

    private void jButtonCopyActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonCopyActionPerformed
       
    }//GEN-LAST:event_jButtonCopyActionPerformed

    
    
    
    private void jButtonSearchNextActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSearchNextActionPerformed
        jLabel5.setText("");
        boolean found = codeEditorPanel.goNext(jTextFieldSearch.getText(), jCheckBoxIgnoreCase.isSelected());
        if (!found) jLabel5.setText("not found!");
    }//GEN-LAST:event_jButtonSearchNextActionPerformed

    private void jButtonSearchPreviousActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSearchPreviousActionPerformed
        jLabel5.setText("");
        boolean found = codeEditorPanel.goPrevious(jTextFieldSearch.getText(), jCheckBoxIgnoreCase.isSelected());
        if (!found) jLabel5.setText("not found!");
    }//GEN-LAST:event_jButtonSearchPreviousActionPerformed

    private void jButtonIgnoreCaseActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonIgnoreCaseActionPerformed
        jCheckBoxIgnoreCase.setSelected(!jCheckBoxIgnoreCase.isSelected());
    }//GEN-LAST:event_jButtonIgnoreCaseActionPerformed

    private void jTextFieldSearchKeyPressed(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTextFieldSearchKeyPressed
        jLabel5.setText("");
    }//GEN-LAST:event_jTextFieldSearchKeyPressed

    private void jTextFieldSearchActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldSearchActionPerformed
        jButtonSearchNextActionPerformed(null);
    }//GEN-LAST:event_jTextFieldSearchActionPerformed

    int HTML_LAYER = 0;
    int CODE_LAYER = 1;
    int IMAGE_LAYER = 2;
    int EMPTY_LAYER = 3;
    int DISPLAY_LAYER = 4;
    void resetLayers()
    {
       jLayeredPane1.setLayer(codeEditorPanel, CODE_LAYER);
       jLayeredPane1.setLayer(htmlScrollPane3, HTML_LAYER);
       jLayeredPane1.setLayer(singleImagePanel, IMAGE_LAYER);
       jLayeredPane1.setLayer(jPanel4, EMPTY_LAYER);
    }
    
    private void jTree1ValueChanged(javax.swing.event.TreeSelectionEvent evt) {//GEN-FIRST:event_jTree1ValueChanged
        if (!(((DefaultMutableTreeNode)evt.getPath().getLastPathComponent()).getUserObject() instanceof TreeEntry)) return;
        
        TreeEntry entry = (TreeEntry) ((DefaultMutableTreeNode)evt.getPath().getLastPathComponent()).getUserObject();
        if (entry.type == DIR) return;
        jLayeredPane1.getComponentsInLayer(3);
        fileName = null;
        treeName = entry.path.toString();
        resetLayers();
        if ( (entry.name.toLowerCase().endsWith(".asm")) ||
             (entry.name.toLowerCase().endsWith(".s")) ||
             (entry.name.toLowerCase().endsWith(".as9")) ||
             (entry.name.toLowerCase().endsWith(".i")) ||
             (entry.name.toLowerCase().endsWith(".inc")) 
           )
        {
           jLayeredPane1.setLayer(codeEditorPanel, DISPLAY_LAYER);
            codeEditorPanel.deinit();
            codeEditorPanel.setFilename(entry.path.toString());
            codeEditorPanel.reload(false);
            codeEditorPanel.setup(null);
            fileName = entry.path.toString();
            repaintLater();
        }
        if ( (entry.name.toLowerCase().endsWith(".jpg")) ||
             (entry.name.toLowerCase().endsWith(".png")) ||
             (entry.name.toLowerCase().endsWith(".gif")) ||
             (entry.name.toLowerCase().endsWith(".bmp")) 
           )
        {
            jLayeredPane1.setLayer(singleImagePanel, DISPLAY_LAYER);
            singleImagePanel.setImage(entry.path.toString());
        }
        if ( (entry.name.toLowerCase().endsWith(".htm")) ||
             (entry.name.toLowerCase().endsWith(".html")) 
           )
        {
            jLayeredPane1.setLayer(htmlScrollPane3, DISPLAY_LAYER);
            htmlEditorPane.setContentType("text/html");
            String text = de.malban.util.UtilityString.readTextFileToOneString(new File(entry.path.toString()));
            htmlEditorPane.setText(text);
        }
        if (
             (entry.name.toLowerCase().endsWith(".txt")) 
           )
        {
            jLayeredPane1.setLayer(htmlScrollPane3, DISPLAY_LAYER);
            htmlEditorPane.setContentType("text/plain");
            String text = de.malban.util.UtilityString.readTextFileToOneString(new File(entry.path.toString()));
            htmlEditorPane.setText(text);
        }

        
    }//GEN-LAST:event_jTree1ValueChanged

    private void jButtonAssembleActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonAssembleActionPerformed
        // save File(s) to tmp
        if (isProject()) return;
        
        if (fileName == null) return;
        if (fileName.trim().length() == 0) return;

        Path p = Paths.get(fileName);
        de.malban.util.UtilityFiles.cleanDirectory(Global.mainPathPrefix+"tmp"+File.separator);
        
        
        de.malban.util.UtilityFiles.copyDirectoryAllFiles(p.getParent().toString(),Global.mainPathPrefix+"tmp"+File.separator);
        p = Paths.get(Global.mainPathPrefix+"tmp"+File.separator+p.getFileName());
        jEditorLog.setText("");
        startASM(p.toString());
    }//GEN-LAST:event_jButtonAssembleActionPerformed
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
                        Asmj asm = new Asmj(filenameASM, asmErrorOut, asmListOut, asmSymbolOut, asmMessagesOut,"", null);
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
                asmStarted = false;
            }  
        };

        one.setName("Run ASMJ with: "+filenameASM);
        one.start();           
    }    
    protected void asmResult(boolean asmOk, String filenameASM)
    {
        if (asmOk)
        {
            if (config.invokeEmulatorAfterAssembly)
            {
                VecXPanel vec = ((CSAMainFrame)mParent).getVecxy();
                ((CSAMainFrame)mParent).getInternalFrame(vec).toFront();

                String fname="";
                if ( filenameASM.toLowerCase().endsWith(".asm") ) {
                    // drop the ".asm" extension
                    fname = filenameASM .substring( 0, filenameASM.length()-4 );
                }
                else
                {
                    int li = filenameASM.lastIndexOf(".");
                    if (li>=0) 
                        fname = filenameASM.substring(0,li);
                }
                fname = fname + ".bin";
                vec.startUp(fname, false);
                printMessage("Assembly successfull, starting emulation...");
                de.malban.util.UtilityFiles.cleanDirectory(Global.mainPathPrefix+"tmp"+File.separator);
            }
            else
            {
                printMessage("Assembly successfull...");
            }
            
        }
        else
        {
            printError("Assembly not successfull, see ASM output...");
        }
    }

    
    // output "Tabs" for source generation
    int TAB_EQU = 30;
    int TAB_EQU_VALUE = 40;
    int TAB_MNEMONIC = 20;
    int TAB_OP = 30;
    int TAB_COMMENT = 50;
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
        /* Does not work as exepcted!

        Document doc = comp.getDocument();
        Element map = doc.getDefaultRootElement();
        int lineNo = -1;
        if (pos < 0)  return "";
        if (pos > doc.getLength())  return "";
        lineNo =  map.getElementIndex(pos);
        if (lineNo == -1) return "";
        if (lineNo >= map.getElementCount()) return "";
        
        Element lineElem = map.getElement(lineNo);
        int lineStartPos =  lineElem.getStartOffset();
        int lineEndPos = lineElem.getEndOffset();
        
        String ret = "";
        try
        {
            ret = doc.getText(lineStartPos, lineEndPos-lineStartPos);
        }
        catch (Throwable e)
        {
            
        }
        System.out.println("double clicked line: "+ret);
        return ret;
                */
    }
    /*
    EditorPanel getSelectedEditor()
    {
        return (EditorPanel) jTabbedPane1.getSelectedComponent();
    }
*/
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private de.malban.vide.vedi.EditorPanel codeEditorPanel;
    private javax.swing.JEditorPane htmlEditorPane;
    private javax.swing.JScrollPane htmlScrollPane3;
    private javax.swing.JButton jButtonAssemble;
    private javax.swing.JButton jButtonCopy;
    private javax.swing.JButton jButtonIgnoreCase;
    private javax.swing.JButton jButtonSearchNext;
    private javax.swing.JButton jButtonSearchPrevious;
    private javax.swing.JCheckBox jCheckBoxIgnoreCase;
    private javax.swing.JEditorPane jEditorLog;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JLayeredPane jLayeredPane1;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JPanel jPanel3;
    private javax.swing.JPanel jPanel4;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JScrollPane jScrollPane2;
    private javax.swing.JSplitPane jSplitPane1;
    private javax.swing.JSplitPane jSplitPane2;
    private javax.swing.JTabbedPane jTabbedPane;
    private javax.swing.JTextField jTextFieldSearch;
    private javax.swing.JTree jTree1;
    private de.malban.graphics.SingleImagePanel singleImagePanel;
    // End of variables declaration//GEN-END:variables

    public void editorChanged(EditorEvent ev)
    {
        
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
            jEditorLog.getDocument().insertString(jEditorLog.getDocument().getLength(), s+"\n", TokenStyles.getStyle("editLogError"));
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
    
    
    public void requestSearchFocus()
    {
        jTextFieldSearch.requestFocusInWindow();
    }
    
    class TreeEntry
    {
        int type;
        String name;
        Path path;
        public TreeEntry(Path p)
        {
            path = p;
            type = p.toFile().isDirectory()?DIR:FILE;
            name = path.getFileName().toString();
        }
        public String toString()
        {
            return name;
        }
    }
    public static final int DIR = 0;
    public static final int FILE = 1;
    void fillTree()
    {
        Path startpath = Paths.get(Global.mainPathPrefix,"codelib");
        DefaultMutableTreeNode root = new DefaultMutableTreeNode(new TreeEntry(startpath));
        addChildren(root);
        jTree1.setModel(new DefaultTreeModel(root));
        
    
    }
    boolean addChildren(DefaultMutableTreeNode node)
    {
        TreeEntry entry = (TreeEntry) node.getUserObject();
        if (entry.type == FILE) return false;
        Path basePath = entry.path;
        
        File directory = basePath.toFile();

        // get all the files from a directory
        File[] fList = directory.listFiles();
        for (File file : fList) 
        {
            TreeEntry newEntry = new TreeEntry(Paths.get(basePath.toString(), file.getName()));
            DefaultMutableTreeNode child = new DefaultMutableTreeNode(newEntry);
            node.add(child);
            addChildren(child);
        }
        return true;
    }
    
    static class SplitterLocation implements Serializable
    {
        int pos=0;
    }
    public Serializable getAdditionalStateinfo()
    {
        SplitterLocation sl = new SplitterLocation();
        sl.pos = jSplitPane1.getDividerLocation();
        return sl;
    }
    public void setAdditionalStateinfo(Serializable ser)
    {
        SplitterLocation sl = (SplitterLocation) ser;
        jSplitPane1.setDividerLocation(sl.pos);
    }
    ProjectProperties getProjectFile(String dir)
    {
        File directory = new File(dir);

        // get all the files from a directory
        File[] fList = directory.listFiles();
        for (File file : fList) 
        {
            if (file.getName().contains("ProjectProperty.xml"))
            {
                String ppath = de.malban.util.Utility.ensureRelative(file.getParent());
                if (ppath.length()!=0)ppath+=File.separator;
                ProjectPropertiesPool pool = new ProjectPropertiesPool(ppath, file.getName());
                ProjectProperties project =  pool.get(file.getName().substring(0,file.getName().length()- ("ProjectProperty.xml").length()));
                return project;
            }
        }
        return null;
    }
    private boolean isProject()
    {
        if (treeName == null) return false;
        Path p = Paths.get(treeName);
        String dir = p.getParent().toString();
        ProjectProperties project = getProjectFile(dir);
        if (project == null) return false;
        // Build the complete project
        String preClass = project.getProjectPreScriptClass();
        String preName = project.getProjectPreScriptName();
        ExecutionDescriptor ed = new ExecutionDescriptor(ED_TYPE_PROJECT_PRE, project.getProjectName(), "", "CodeLibraryPanel", dir);
        boolean ok =  ScriptDataPanel.executeScript(preClass, preName, this, ed);
        if (!ok) return true; // was project - but could not be build!
        startBuild(project);
        
        return true;
    }
    // start a thread for assembler
    public void startBuild(final ProjectProperties project)
    {
        if (asmStarted) return;
        asmStarted = true;
        jButtonAssemble.setEnabled(false);
        // paranoia!
        if (one != null) return;
        one = new Thread() 
        {
            public void run() 
            {
                boolean asmOk = true;
                
                // todo pre file builds!
                
                try
                {
                    for (int b = 0; b<project.getNumberOfBanks(); b++)
                    {
                        String filenameASM = project.getBankMainFiles().elementAt(b);
                        if (filenameASM.length() == 0) continue;
                        
                        
                        if (project.projectPrefix.length()==0)
                        {
                            Path p = Paths.get(treeName);
                            String dir = p.getParent().toString();
                            project.projectPrefix = dir;
                        }
                        filenameASM = project.projectPrefix+File.separator+filenameASM;
                        
                        
                        File test = new File(filenameASM);
                        if (!test.exists())
                        {
                            continue; // allow empty names!
                        }
                        String define = project.getBankDefines().elementAt(b);
                        printMessage("Assembling: "+filenameASM);
                        Asmj asm = new Asmj(filenameASM, asmErrorOut, null, null, asmMessagesOut, define, null);
                        printASMList(asm.getListing(), ASM_LIST);

                        String info = asm.getInfo();
                        asmOk = info.indexOf("0 errors detected.") >=0;
                        if (!asmOk) break;
                        
                        
                        String filename = project.getBankMainFiles().elementAt(b);
                        filename = project.projectPrefix+File.separator+filename;
                        int li = filename.lastIndexOf(".");
                        if (li>=0) 
                            filename = filename.substring(0,li);
                        String org = filename + ".bin";
                        String banked = filename+"_"+(b) + ".bin";
                        de.malban.util.UtilityFiles.move(org, banked);
                        
                        org = filename + ".cnt";
                        banked = filename+"_"+(b) + ".cnt";
//                        de.malban.util.UtilityFiles.move(org, banked);
                        
                        Vector<String> what = new Vector<String>();
                        Vector<String> with = new Vector<String>();
                        what.add("BANK 0");
                        with.add("BANK "+(b));
                        de.malban.util.UtilityString.replaceToNewFile(new File(org), new File(banked), what,with);
                        de.malban.util.UtilityFiles.deleteFile(org);
                        
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
                            buildResult(false, project);
                        }
                    });   
                    one = null;
                    jButtonAssemble.setEnabled(true);
                    asmStarted = false;
                    return;
                }
                if (!asmOk)
                {
                    SwingUtilities.invokeLater(new Runnable()
                    {
                        public void run()
                        {
                            buildResult(false, project);
                        }
                    });                    
                    one = null;
                    jButtonAssemble.setEnabled(true);
                    asmStarted = false;
                    return;
                }
                String postClass = project.getProjectPostScriptClass();
                String postName = project.getProjectPostScriptName();
                
                String pp = project.projectPrefix;
                
                ExecutionDescriptor ed = new ExecutionDescriptor(ED_TYPE_PROJECT_POST, project.getProjectName(), "", "CodeLibraryPanel", pp);
                boolean ok =  ScriptDataPanel.executeScript(postClass, postName, CodeLibraryPanel.this, ed);
                final boolean asmOk2 = asmOk; // effectivly final!
                SwingUtilities.invokeLater(new Runnable()
                {
                    public void run()
                    {
                        buildResult(asmOk2, project);
                    }
                });                    
                
                one = null;
                jButtonAssemble.setEnabled(true);
                asmStarted = false;
            }  
        };

        one.setName("Build: "+project.getProjectName());
        one.start();           
    }            
    protected void buildResult(boolean buildOk, ProjectProperties project)
    {
        if (buildOk)
        {
            if (config.invokeEmulatorAfterAssembly)
            {
                VecXPanel vec = ((CSAMainFrame)mParent).getVecxy();
                ((CSAMainFrame)mParent).getInternalFrame(vec).toFront();

                CartridgeProperties cartProp = buildCart(project);
                vec.startCartridge(cartProp, START_TYPE_RUN);
                printMessage("Assembly successfull, starting emulation...");
            }
            else
            {
                printMessage("Assembly successfull...");
            }
            
        }
        else
        {
            printError("Assembly not successfull, see ASM output...");
        }
    }
    CartridgeProperties buildCart(ProjectProperties project)
    {
        CartridgeProperties cart = new CartridgeProperties();

        for (int b = 0; b<project.getNumberOfBanks(); b++)
        {
            String filename = project.getBankMainFiles().elementAt(b);
            
            if (project.projectPrefix.length()==0)
            {
                filename = project.getOldPath()+File.separator+project.mName+File.separator+filename;
            }
            else
            {
                filename = project.projectPrefix+File.separator+filename;
            }
            
            
            int li = filename.lastIndexOf(".");
            if (li>=0) 
                filename = filename.substring(0,li);
            filename = filename+"_"+(b) + ".bin";

            File test = new File(makeGlobalAbsolute(filename));
            if (!test.exists())
            {
                cart.getFullFilename().add("");
                continue;
            }
            cart.getFullFilename().add(filename);
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
    public void run(){}
    public void debug(){}
    public void doQuickHelp(String s, String f2){}
    public void tabChanged(boolean b){}
    public void changeFileName(String s, String f2){}
    public void processIncludeLine(String s){}
    public void processWord(String s){}
    protected void deselectInTree(String tabName)
    {
        DefaultMutableTreeNode node =  (DefaultMutableTreeNode) jTree1.getSelectionPath().getLastPathComponent() ;
        if (node == null) return;
        TreeEntry entry = (TreeEntry) node.getUserObject();
        if (entry == null) return;
        if (tabName.equals(tabName))
        {
            mClassSetting++;
            jTree1.clearSelection();
            mClassSetting--;
        }
            
    }
    public void deIconified() { }
}
