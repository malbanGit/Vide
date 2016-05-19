/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vedi;

import de.malban.config.Configuration;
import de.malban.config.TinyLogInterface;
import de.malban.gui.HotKey;
import de.malban.gui.dialogs.InternalFrameFileChoser;
import de.malban.util.KeyboardListener;
import de.malban.util.UtilityString;
import de.malban.util.syntax.Syntax.HighlightedDocument;
import de.malban.vide.veccy.VectorListFileChoserJPanel;
import java.awt.Color;
import java.awt.Component;
import java.awt.Dimension;
import java.awt.Event;
import java.awt.Point;
import java.awt.event.ActionEvent;
import java.awt.event.KeyEvent;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import javax.swing.AbstractAction;
import javax.swing.JTable;
import javax.swing.JTextPane;
import javax.swing.JViewport;
import javax.swing.SwingUtilities;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;
import javax.swing.plaf.ComponentUI;
import javax.swing.table.AbstractTableModel;
import javax.swing.table.DefaultTableCellRenderer;

/**
 *
 * @author malban
 */
public class EditorPanel extends EditorPanelFoundation
{

    // indicator whether rows must be counted anew
    int rowCount = -1;
    
    boolean hasChanged = false;
    boolean assume6809Asm = false;
    
    private HighlightedDocument editorPaneDocument;
    //private Document editorPaneDocument;

    VediPanel parent;
    public void setParent(VediPanel p)
    {
        parent = p;
    }
    
    TinyLogInterface tinyLog = null;
    private String filename = "";
    boolean initError = false;
    
    public void resetDocument()
    {
        editorPaneDocument = new HighlightedDocument();
    }
    protected boolean isInitError()
    {
        return initError;
    }
    
    /**
     * Creates new form EditorPanel
     */
    public EditorPanel() {
        initComponents();
        try
        {
            setup(jTextPane1.getText());
        }
        catch (Throwable e)
        {
            initError = true;
        }
    }
    public EditorPanel(String fn, TinyLogInterface tl) {
        tinyLog = tl;
        filename = fn;
        initComponents();
        try 
        {
            FileReader fr = new FileReader(getFilename());
            jTextPane1.read(fr, null);
            fr.close();
        }
        catch (IOException e) 
        {
            tl.printError("Error loading file: "+getFilename());
            initError = true;
        }
        try
        {
            setup(null);
        }
        catch (Throwable e)
        {
            initError = true;
        }
        if (initError)
        {
            deinit();
        }
    }
    public boolean reload(boolean recolor)
    {
        if (recolor)
        {
            stopColoring();
        }
        String t = de.malban.util.UtilityString.readTextFileToOneString(new File(getFilename()));
        t = UtilityString.replace(t, "\r\n", "\n");
        jTextPane1.setText(t);
        if (recolor)
        {
            startColoring();
        }
        return true;
        
    }
    JTextPane buildTextPane()
    {
        JTextPane tp = new JTextPane()
        {
            // Override getScrollableTracksViewportWidth
            // to preserve the full width of the text
            public boolean getScrollableTracksViewportWidth() {
              Component parent = getParent();
              ComponentUI ui = getUI();

              return parent != null ? (ui.getPreferredSize(this).width <= parent
                  .getSize().width) : true;
            }
            
        };
        tp.addCaretListener(new VisibleCaretListener());
        return tp;
    }
    public void stopColoring()
    {
        if (editorPaneDocument == null) return;
        savePos();
        
        editorPaneDocument.stopColoring();
    }
    public void startColoring()
    {
        if (editorPaneDocument == null) return;
        editorPaneDocument.startColoring();
        restorePos();
    }
    
    int savedCaretPosition = 0;
    void savePos()
    {
        savedCaretPosition = jTextPane1.getCaretPosition();
    }
    void restorePos()
    {
        if (savedCaretPosition>jTextPane1.getDocument().getLength()) return;
        jTextPane1.setCaretPosition(savedCaretPosition);
        jTextPane1.requestFocusInWindow();
    }

    public void setup(String t)
    {
        rowCount = -1;
        jTextPane1.setCaret(new HighlightCaret());
        if (t == null) t=jTextPane1.getText();
       
        // Text Highlight setup
        resetDocument();
        jTextPane1.setDocument(editorPaneDocument);
        
        if ((getFilename().toLowerCase().endsWith(".template") ) ||(getFilename().toLowerCase().endsWith(".s") ) || (getFilename().toLowerCase().endsWith(".asm")) || (getFilename().toLowerCase().endsWith(".as9"))|| (getFilename().toLowerCase().endsWith(".a69")) || (getFilename().toLowerCase().endsWith(".i"))|| (getFilename().toLowerCase().endsWith(".inc")))
        {
            assume6809Asm = true;
            editorPaneDocument.setHighlightStyle(HighlightedDocument.M6809_STYLE, false);
        }
        else if (getFilename().toLowerCase().endsWith(".java"))
                editorPaneDocument.setHighlightStyle(HighlightedDocument.JAVA_STYLE);
        else if (getFilename().toLowerCase().endsWith(".js"))
                editorPaneDocument.setHighlightStyle(HighlightedDocument.JAVASCRIPT_STYLE);
        else if ((getFilename().toLowerCase().endsWith(".c"))|| (getFilename().toLowerCase().endsWith(".h")))
                editorPaneDocument.setHighlightStyle(HighlightedDocument.C_STYLE);
        else if ((getFilename().toLowerCase().endsWith(".htm"))|| (getFilename().toLowerCase().endsWith(".html")))
                editorPaneDocument.setHighlightStyle(HighlightedDocument.HTML_STYLE);
        else if (getFilename().toLowerCase().endsWith(".sql"))
                editorPaneDocument.setHighlightStyle(HighlightedDocument.SQL_STYLE);
        else if (getFilename().toLowerCase().endsWith(".properties"))
                editorPaneDocument.setHighlightStyle(HighlightedDocument.PROPERTIES_STYLE);
        else
                editorPaneDocument.setHighlightStyle(HighlightedDocument.GRAYED_OUT_STYLE);
            
            
        if (t != null) jTextPane1.setText(t);
        editorPaneDocument.start(getFilename());
        editorPaneDocument.addUndoableEditListener(undoManager);
        
        
        
        
        new HotKey(javax.swing.text.DefaultEditorKit.copyAction,null, jTextPane1);
        new HotKey(javax.swing.text.DefaultEditorKit.pasteAction, null, jTextPane1);
        new HotKey(javax.swing.text.DefaultEditorKit.cutAction, null, jTextPane1);
        new HotKey("unindent", shiftTabAction, jTextPane1);
        new HotKey("indent", tabAction, jTextPane1);
        new HotKey("UndoMac", undoAction, jTextPane1);
        new HotKey("RedoMac", redoAction, jTextPane1);
        new HotKey("UndoWin", undoAction, jTextPane1);
        new HotKey("RedoWin", redoAction, jTextPane1);
        new HotKey("UndoWin", undoAction, jTextPane1);
        new HotKey("RedoWin", redoAction, jTextPane1);
        new HotKey("SearchMac", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (parent != null) parent.requestSearchFocus(); }}, this);
        new HotKey("SearchWin", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (parent != null) parent.requestSearchFocus(); }}, this);
        new HotKey("Run", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (parent != null) parent.run(); }}, this);
        new HotKey("Debug", new AbstractAction() { public void actionPerformed(ActionEvent e) {  if (parent != null) parent.debug(); }}, this);
        new HotKey("RecolorMac", new AbstractAction() { public void actionPerformed(ActionEvent e) {  
            stopColoring(); 
            startColoring();}}, jTextPane1);
        new HotKey("RecolorWin", new AbstractAction() { public void actionPerformed(ActionEvent e) {  stopColoring(); startColoring();}}, jTextPane1);
        new HotKey("JumpMac", new AbstractAction() { public void actionPerformed(ActionEvent e) {  jump();}}, jTextPane1);
        new HotKey("JumpWin", new AbstractAction() { public void actionPerformed(ActionEvent e) {  jump();}}, jTextPane1);
        
        
        

        // table setup
        // 8736("&"%%!%%$$$!°°!!!°
        // I don't want to think about it... WHY am I using an own LAF if this is an issue???
        if (Configuration.MAC_OS_X)
            jTable1.setRowHeight(15);
        if (Configuration.WINDOWS)
            jTable1.setRowHeight(17);
        
        jTable1.setTableHeader(null);
        LineTableModel model = new LineTableModel();
        jTable1.setModel(model);
        jTable1.setDefaultRenderer(Integer.class, new DefaultTableCellRenderer()
        {
            @Override
            public Component getTableCellRendererComponent(JTable table, Object value, boolean isSelected, boolean hasFocus, int row, int col) 
            {
                super.getTableCellRendererComponent(table, value, isSelected, hasFocus, row, col);

                if (table.getModel() instanceof LineTableModel)
                {
                    LineTableModel model = (LineTableModel)table.getModel();

                    if (isSelected)
                    {
                        setBackground(table.getSelectionBackground());
                        setForeground(table.getSelectionForeground());
                    }
                    else
                    {
                        Color back = model.getBackground(col);
                        if (back != null)
                            setBackground(back);
                        else
                            setBackground(table.getBackground());
                        setForeground(table.getForeground());
                    }
                }
                return this;
            }   
        });       
        
        JViewport viewport = jScrollPane2.getViewport();
        viewport.addChangeListener(
                new ChangeListener()
                {
                    public void stateChanged(ChangeEvent e)
                    {
                        JViewport viewport = jScrollPane2.getViewport();
                        Point p = viewport.getViewPosition();
                        JViewport viewport2 = jScrollPane1.getViewport();
                        p.x=0;
                        viewport2.setViewPosition(p);                
                    }
                });    

        correctTable();
        jTextPane1.setCaretPosition(0);
    }
    public void correctTable()
    {
        jTable1.tableChanged(null);
        
        LineTableModel model = (LineTableModel)jTable1.getModel();
        
        for (int i=0; i< model.getColumnCount(); i++)
        {
            jTable1.getColumnModel().getColumn(i).setPreferredWidth(model.getColWidth(i));                
        }
    }
    public void deinit()
    {
        if (editorPaneDocument!= null)
        editorPaneDocument.deinit();
        editorPaneDocument = null;
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
        jMenuItemAddVectorlist = new javax.swing.JMenuItem();
        jMenuItemAddAnim = new javax.swing.JMenuItem();
        jScrollPane1 = new javax.swing.JScrollPane();
        jTable1 = new javax.swing.JTable();
        jScrollPane2 = new javax.swing.JScrollPane();
        jTextPane1 = buildTextPane();

        jMenuItemAddVectorlist.setText("insert vectorlist");
        jMenuItemAddVectorlist.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemAddVectorlistActionPerformed(evt);
            }
        });
        jPopupMenu1.add(jMenuItemAddVectorlist);

        jMenuItemAddAnim.setText("insert animation/scenario");
        jMenuItemAddAnim.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemAddAnimActionPerformed(evt);
            }
        });
        jPopupMenu1.add(jMenuItemAddAnim);

        jScrollPane1.setHorizontalScrollBarPolicy(javax.swing.ScrollPaneConstants.HORIZONTAL_SCROLLBAR_NEVER);
        jScrollPane1.setVerticalScrollBarPolicy(javax.swing.ScrollPaneConstants.VERTICAL_SCROLLBAR_NEVER);

        jTable1.setFont(new java.awt.Font("Courier New", 0, 12)); // NOI18N
        jTable1.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null},
                {null},
                {null},
                {null}
            },
            new String [] {
                "Title 1"
            }
        ));
        jTable1.setRowHeight(15);
        jTable1.setShowHorizontalLines(false);
        jTable1.setShowVerticalLines(false);
        jScrollPane1.setViewportView(jTable1);

        jTextPane1.setBorder(javax.swing.BorderFactory.createEmptyBorder(1, 3, 1, 3));
        jTextPane1.setFont(new java.awt.Font("Courier New", 0, 12)); // NOI18N
        jTextPane1.setText("\n\n\n        ORG     $0000                      ; start address of all vectrex progs -> 0\n\n        DB -$0e,  $ff, -$01, -$02, -$03, -$08, -$0a, -$0c,  $00\n\nPrint_Str_hwyx  EQU     $F373   ;\nIntensity_5F    EQU     $F2A5   ;\nWait_Recal      EQU     $F192   ;\nmusic1  EQU $FD0D               ;\n\n\n; Magic Init Block\n\n\n_m:     ; M\n        fcb     20*5,0\n        fcb     5*5,-5*5\n        fcb     0,-17*5\n        fcb     0,-18*5\n        fcb     -25*5,0\n        fcb     0,10*5\n        fcb     20*5,0\n        fcb     -5*5,5*5\n        fcb     -15*5,0\n        fcb     0,10*5\n        fcb     20*5,0\n        fcb     -5*5,5*5\n        fcb     -15*5,0\n        fcb     0,10*5\n;        fcb     1\n        fcb     -2,2,3,-1,1,1,-2,2\n\n        FCB     $67,$20                    ; copyright sign and space\n        FCC     \"GCE XXXX\"                 ; copyright text, must start with copyright sign space GCE\n        FCB     $80                        ; end of text marker\n        FDB     music1                      ; music address to be played on title screen\n        FDB     $f850                      ; text size for following text height, width (A,B)\n        FDB     $30b8                      ; position of following text y,x (A,B)\n        FCC     \"MOON LANDER\"              ; text\n        FCB     $80,$0                     ; text end ($80) and header end (0)\n\n        direct $d0                         ; vectrex starts with dp set to $d0\ninit:                                      ; start of program\n        lda <$01\n\n        JSR \t\tWait_Recal\n        jsr     Intensity_5F            ; brightness to $5f\n                                           ; no need to go to zero here,\n                                           ; since this is the first printing\n\n        ldu     #TestString1               ; load score string\n        jsr     Print_Str_hwyx          ; print it\n        ldu     #TestString2               ; load score string\n        jsr     Print_Str_hwyx          ; print it\n        ldu     #TestString3               ; load score string\n        jsr     Print_Str_hwyx          ; print it\n        ldu     #TestString4               ; load score string\n        jsr     Print_Str_hwyx          ; print it\n        ldu     #TestString5               ; load score string\n        jsr     Print_Str_hwyx          ; print it\n        ldu     #TestString6               ; load score string\n        jsr     Print_Str_hwyx          ; print it\n        ldu     #TestString7               ; load score string\n        jsr     Print_Str_hwyx          ; print it\n        ldu     #TestString8               ; load score string\n        jsr     Print_Str_hwyx          ; print it\n        ldu     #TestString9               ; load score string\n        jsr     Print_Str_hwyx          ; print it\n\n        jmp init\n\n\n\nTestString1:\n        fdb      $f53a\n        fdb      $7090\n\tFCC     \"THIS IS A LONG MESSAGE TO BE\"\n\t  FCB $81\nTestString2:\n        fdb      $f53a\n        fdb      $5090\n\tFCC     \"PRINTED ON A POOR VECTREX\"\n\t  FCB $81\nTestString3:\n        fdb      $f53a\n        fdb      $3090\n\tFCC     \"DISPLAY, BUT IT MIGHT BE USED\"\n\t  FCB $81\nTestString4:\n        fdb      $f53a\n        fdb      $1090\n\tFCC     \"AS A SPEEDTEST FOR THE PRINT\"\n\t  FCB $81\nTestString5:\n        fdb      $f53a\n        fdb      $e090\n\tFCC     \"ROUTINES!\"\n\t  FCB $81\nTestString6:\n        fdb      $f53a\n        fdb      $d090\n\tFCC     \"THIS IS A LONG MESSAGE TO BE\"\n\t  FCB $81\nTestString7:\n        fdb      $f53a\n        fdb      $b090\n\tFCC     \"PRINTED ON A POOR VECTREX\"\n\t  FCB $81\nTestString8:\n        fdb      $f53a\n        fdb      $9090\n\tFCC     \"DISPLAY, BUT IT MIGHT BE USED\"\n\t  FCB $81\nTestString9:\n        fdb      $f53a\n        fdb      $8090\n\tFCC     \"AS A SPEEDTEST FOR THE PRINT\"\n\t  FCB $81\n");
        jTextPane1.addCaretListener(new javax.swing.event.CaretListener() {
            public void caretUpdate(javax.swing.event.CaretEvent evt) {
                jTextPane1CaretUpdate(evt);
            }
        });
        jTextPane1.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jTextPane1MousePressed(evt);
            }
        });
        jTextPane1.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyTyped(java.awt.event.KeyEvent evt) {
                jTextPane1KeyTyped(evt);
            }
            public void keyPressed(java.awt.event.KeyEvent evt) {
                jTextPane1KeyPressed(evt);
            }
        });
        jScrollPane2.setViewportView(jTextPane1);

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 40, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jScrollPane2, javax.swing.GroupLayout.DEFAULT_SIZE, 552, Short.MAX_VALUE))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jScrollPane1, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, 440, Short.MAX_VALUE)
            .addComponent(jScrollPane2, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE)
        );
    }// </editor-fold>//GEN-END:initComponents

    private void jTextPane1KeyTyped(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTextPane1KeyTyped
        rowCount = -1;
        fireEditorChanged(EditorEvent.EV_TEXT_CHANGED);
    }//GEN-LAST:event_jTextPane1KeyTyped

    private void jTextPane1CaretUpdate(javax.swing.event.CaretEvent evt) {//GEN-FIRST:event_jTextPane1CaretUpdate
          fireEditorChanged(EditorEvent.EV_CARET_CHANGED);
    }//GEN-LAST:event_jTextPane1CaretUpdate

    private void jTextPane1KeyPressed(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTextPane1KeyPressed
        
    }//GEN-LAST:event_jTextPane1KeyPressed

    private void jTextPane1MousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jTextPane1MousePressed

        Point pt = new Point(evt.getX(), evt.getY());
        int pos = jTextPane1.viewToModel(pt);

        if (evt.getClickCount() == 2) 
        {
            jTextPane1.setSelectionStart(pos);
            jTextPane1.setSelectionEnd(pos); // -1 look shiity, but enables another previous search
            if (SwingUtilities.isMiddleMouseButton(evt))
            {
                String word = getWordOfPos(jTextPane1, pos);
                if (parent != null)
                    parent.processWord(word);
            }
            /*
            else
            if (SwingUtilities.isMiddleMouseButton(evt))
            {
                int spos = getStartOfWord(jTextPane1, pos);
                if (spos == -1) return;
                String word = getWordOfPos(jTextPane1, pos);
                if (word.length()==0) return;
                editorPaneDocument.colordbg(spos, word.length());
            }*/
            else
            {
                int line = getLineOfPos(jTextPane1, pos);
                if (line != -1)
                {
                    if (parent != null)
                        parent.processIncludeLine(getLine(jTextPane1, line));
                }
            }
        }        
        else
        {
            // click one
            if (SwingUtilities.isLeftMouseButton(evt))
            {
                if (KeyboardListener.isShiftDown())
                {
                    // select between current caret and THIS position!
                    int oldpos = jTextPane1.getCaretPosition();
                    jTextPane1.setSelectionStart(pos);
                    jTextPane1.setSelectionEnd(oldpos); // -1 look shiity, but enables another previous search
                    jTextPane1.setCaretPosition(oldpos);
                    return;
                }
            }
            else if (SwingUtilities.isRightMouseButton(evt))
            {
                popUpTextPos = pos;
                
                
                
                jPopupMenu1.show(this, evt.getX()-20- jScrollPane2.getViewport().getViewPosition().x,evt.getY()-20- jScrollPane2.getViewport().getViewPosition().y);
            }
        }
        jTextPane1.setSelectionStart(pos);
        jTextPane1.setSelectionEnd(pos); // -1 look shiity, but enables another previous search
        
    }//GEN-LAST:event_jTextPane1MousePressed
    int popUpTextPos = 0;

    private void jMenuItemAddVectorlistActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemAddVectorlistActionPerformed
       
        String filename ="xml"+File.separator+"vectorlist";
        String text = VectorListFileChoserJPanel.showLoadPanel(filename,"Load Vectorlist", false, true);
        stopColoring();
        
        try
        {
            jTextPane1.getDocument().insertString(popUpTextPos, text, null);
        }
        catch (Throwable e)
        {
            
        }
        
        startColoring();
        
    }//GEN-LAST:event_jMenuItemAddVectorlistActionPerformed

    private void jMenuItemAddAnimActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemAddAnimActionPerformed

        String filename ="xml"+File.separator+"vectoranimation";
        String text = VectorListFileChoserJPanel.showLoadPanel(filename,"Load Vector-Animation", true, true);
        stopColoring();
        
        try
        {
            jTextPane1.getDocument().insertString(popUpTextPos, text, null);
        }
        catch (Throwable e)
        {
            
        }
        
        startColoring();
    }//GEN-LAST:event_jMenuItemAddAnimActionPerformed
    int getLineOfPos(JTextPane comp, int pos)
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
    int getStartOfWord(JTextPane comp, int pos)
    {
        int word =-1;
        try
        {
            String text = comp.getDocument().getText(0, comp.getDocument().getLength());
            char c = text.charAt(pos);
            while (!de.malban.util.UtilityString.isWordBoundry(c)) 
            {
                pos--;
                if (pos <0)
                {
                    break;
                }
                c = text.charAt(pos);
            }
            pos++;
            return pos;
        }
        catch (Throwable e)
        {
        }
        return word;
    }    
    
    String getWordOfPos(JTextPane comp, int pos)
    {
        String word ="";
        try
        {
            String text = comp.getDocument().getText(0, comp.getDocument().getLength());
            char c = text.charAt(pos);
            while (!de.malban.util.UtilityString.isWordBoundry(c)) 
            {
                pos--;
                if (pos <0)
                {
                    break;
                }
                c = text.charAt(pos);
            }
            pos++;
            c = text.charAt(pos);
            while (!de.malban.util.UtilityString.isWordBoundry(c))
            {
                word += c;
                pos++;
                c = text.charAt(pos);
            }
        }
        catch (Throwable e)
        {
        }
        return word;
    }    
    public int getPosOfLineStart(int line)
    {
        int pos = 0;
        try
        {
            String[] lines = jTextPane1.getDocument().getText(0, jTextPane1.getDocument().getLength()).split("\n");
            int lineCounter = 0;
            while (lineCounter < line)
            {
                pos += lines[lineCounter].length()+1; // because of "/n"
                lineCounter++;
                if (lineCounter>=lines.length) return -1;
            }
            
        }
        catch (Throwable e)
        {
        }
        return pos;
    }
    public String getLine(JTextPane comp, int pos)
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

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JMenuItem jMenuItemAddAnim;
    private javax.swing.JMenuItem jMenuItemAddVectorlist;
    private javax.swing.JPopupMenu jPopupMenu1;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JScrollPane jScrollPane2;
    private javax.swing.JTable jTable1;
    private javax.swing.JTextPane jTextPane1;
    // End of variables declaration//GEN-END:variables

    public void setTinyLog(TinyLogInterface tl)
    {
        tinyLog = tl;
    }
    String saveText(String path)
    {
        try
        {
            String text = editorPaneDocument.getText(0, editorPaneDocument.getLength());
            
            BufferedWriter writer = null;
            File logFile = new File(path);
            writer = new BufferedWriter(new FileWriter(logFile));
            writer.write(text);
            writer.close();
        }
        catch (Throwable e)
        {
            e.printStackTrace();
            tinyLog.printError(de.malban.util.Utility.getStackTrace(e));
            return null;
        }
        return path;
    }
    public Point getCursorPos()
    {
        Point p = new Point(1,1);
        String[] splitter;
        try
        {
         splitter = jTextPane1.getDocument().getText(0, jTextPane1.getDocument().getLength()).split("\n");
            
        }
        catch (Throwable e)
        {
            return p;
        }
        int pos = jTextPane1.getCaretPosition();
        
        int count =0;
        for (String split: splitter)
        {
            if (count + split.length() >=pos)
            {
                p.x = pos - count+1;
                break;
            }
            count+=split.length();
            count++; // plus one because of "/n"
            p.y++;
        }
        
        return p;
    }
    public int getCharCount()
    {
        return editorPaneDocument.getLength();
    }
    // https://tips4java.wordpress.com/2009/05/23/text-component-line-number/
    public int getTextpaneRowCount()
    {
        if (rowCount != -1) return rowCount;
        rowCount = jTextPane1.getText().split("\n").length;
        return rowCount;
    }

    /**
     * @return the filename
     */
    public String getFilename() {
        return filename;
    }
    public void replaceFilename(String fn)
    {
        filename = fn;
    }
    public String getPath()
    {
        Path path = Paths.get(filename);
        return path.getParent().toString();
    }
    // "document" text, sperated by "\n", empty if error
    public String getText() 
    {
        String text = "";
        try
        {
            text = jTextPane1.getDocument().getText(0, jTextPane1.getDocument().getLength());
        }
        catch (Throwable e)
        {
        }
        return text;
    }
    // "document" text, sperated by "\n", empty if error
    public void  setText(String text) 
    {
        jTextPane1.setText(text);
    }
    
    
    /**
     * @param filename the filename to set
     */
    public void setFilename(String filename) {
        this.filename = filename;
    }
    public class LineTableModel extends AbstractTableModel
    {
        public int getRowCount()
        {
            return getTextpaneRowCount();
        }
        public int getColumnCount()
        {
            return 1;
        }
        public Object getValueAt(int row, int col)
        {
            return row+1;
        }
        public String getColumnName(int column) {
            return "";
        }
        public Class<?> getColumnClass(int columnIndex) {
            return Integer.class;
        }
        public boolean isCellEditable(int rowIndex, int columnIndex) {
            return false;
        }
        public int getColWidth(int col)
        {
            if (col == 0) return 40;
            if (col == 17) return 120;
            return 20;
        }
        public Color getBackground(int col)
        {
            if (col == 0) return new Color(200,255,200,255);
            return null; // default
        }
    }
    public boolean goNext(String toSearch, boolean ignoreCase)
    {
        try
        {
            int startSearchPos = jTextPane1.getCaretPosition();
            if (ignoreCase) toSearch = toSearch.toLowerCase();
            String text = jTextPane1.getDocument().getText(0, jTextPane1.getDocument().getLength()).substring(startSearchPos);
            if (ignoreCase) text = text.toLowerCase();
            int startPos = text.indexOf(toSearch);
            if (startPos<0) return false;

            jTextPane1.setSelectionStart(startPos+startSearchPos);
            jTextPane1.setSelectionEnd(startPos+startSearchPos+toSearch.length());
            jTextPane1.requestFocusInWindow();
            return true;
            
        }
        catch (Throwable e)
        {
            
        }
        return false;
    }
    public boolean goPrevious(String toSearch, boolean ignoreCase)
    {
        try
        {
            
            if (ignoreCase) toSearch = toSearch.toLowerCase();
            String text = jTextPane1.getDocument().getText(0, jTextPane1.getDocument().getLength()).substring(0,jTextPane1.getCaretPosition());
            if (ignoreCase) text = text.toLowerCase();
            int startPos = text.lastIndexOf(toSearch);
            if (startPos<0) return false;

            jTextPane1.setSelectionStart(startPos);
            jTextPane1.setSelectionEnd(startPos+toSearch.length()-1); // -1 look shiity, but enables another previous search
            jTextPane1.requestFocusInWindow();
            return true;
        }
        catch (Throwable e)
        {
            
        }
        return false;

    }
    public boolean goLine(int lineNumber)
    {
        try
        {
            String[] lines = jTextPane1.getDocument().getText(0, jTextPane1.getDocument().getLength()).split("\n");
            int lineNow = 1;
            int lenNow = 0;
            while (lineNow != lineNumber)
            {
                lenNow += lines[lineNow-1].length()+1; // plus one because auf "\n"
                lineNow++;
            }
            final int lineNowf = lineNow;
            final int lenNowf = lenNow;
            jTextPane1.requestFocusInWindow();
            jTextPane1.setSelectionStart(0);
            jTextPane1.setSelectionEnd(lenNowf+lines[lineNowf-1].length()); // -1 look shiity, but enables another previous search
            jTextPane1.setSelectionStart(lenNowf);
            
        }
        catch (Throwable e)
        {
            e.printStackTrace();
        }
        
        return true;
    }
    public boolean replaceNext(String toSearch, String replacement, boolean ignoreCase, boolean singleReplace)
    {
        try
        {
            int startSearchPos = jTextPane1.getCaretPosition();
            if (ignoreCase) toSearch = toSearch.toLowerCase();
            String text = jTextPane1.getDocument().getText(0, jTextPane1.getDocument().getLength()).substring(startSearchPos);
            if (ignoreCase) text = text.toLowerCase();
            int startPos = text.indexOf(toSearch);
            if (startPos<0) return false;

            synchronized (editorPaneDocument.getDocumentLock())
            {
                jTextPane1.setSelectionStart(startPos+startSearchPos);
                jTextPane1.setSelectionEnd(startPos+startSearchPos+toSearch.length());
                jTextPane1.replaceSelection(replacement);
            }
            if (singleReplace)
                jTextPane1.requestFocusInWindow();
            return true;
            
        }
        catch (Throwable e)
        {
            
        }
        return false;
        
        
    }
    public int replaceAll(String toSearch, String replacement, boolean ignoreCase)
    {
        if (toSearch.length()==0) return -1;
        int count = -1;
        jTextPane1.setCaretPosition(0);
        synchronized (editorPaneDocument.getDocumentLock())
        {
            boolean found = false;
            do
            {
                count++;
                found = replaceNext(toSearch, replacement, ignoreCase, false);
            } while (found);
            
        }
        
        return count;
    }    
    public int replaceSel(String toSearch, String replacement, boolean ignoreCase, int start, int end)
    {
        try
        {
            int startSearchPos = jTextPane1.getCaretPosition();
            if (start != -1) startSearchPos=start;

            if (ignoreCase) toSearch = toSearch.toLowerCase();
            String text = jTextPane1.getDocument().getText(0,jTextPane1.getDocument().getLength()).substring(startSearchPos);
            if (ignoreCase) text = text.toLowerCase();
            int startPos = text.indexOf(toSearch);

            if (end!=-1)
            {
                if (startPos+startSearchPos+toSearch.length() >end) return -1;
            }


            if (startPos<0) return -1;

            synchronized (editorPaneDocument.getDocumentLock())
            {
                jTextPane1.setSelectionStart(startPos+startSearchPos);
                jTextPane1.setSelectionEnd(startPos+startSearchPos+toSearch.length());
                jTextPane1.replaceSelection(replacement);
                jTextPane1.requestFocusInWindow();
                
            }
            return jTextPane1.getCaretPosition();
            
        }
        catch (Throwable e)
        {
            e.printStackTrace();
        }
        return -1;
    }    
    public int replaceInSelection(String toSearch, String replacement, boolean ignoreCase)
    {
        int start = jTextPane1.getSelectionStart();
        int startOrg = start;
        int end = jTextPane1.getSelectionEnd();
        int count = -1;
        jTextPane1.setCaretPosition(start);
        synchronized (editorPaneDocument.getDocumentLock())
        {
            do
            {
                count++;
                start = replaceSel(toSearch, replacement, ignoreCase, start, end);
            } while (start>0);
        }
        jTextPane1.setSelectionStart(startOrg);
        jTextPane1.setSelectionEnd(end);
        jTextPane1.requestFocusInWindow();
        return count;
    }    
    public void reColor()
    {
        editorPaneDocument.colorAll();
    }

    // watching, if swing does something evil!
    Dimension oldDim=null;
    public Dimension getPreferredSize()
    {
        try
        {
            oldDim = super.getPreferredSize();
            
        }
        catch (Throwable e)
        {
            System.out.println("Bad things happen!");
        }
        return oldDim;
    }
    
    // todo save as
    // save as not done
    public boolean save(boolean saveAs)
    {
        boolean ret = true;
            String newFilename = filename;            
            String oldFilename = filename;
        
        if (saveAs)
        {
            InternalFrameFileChoser fc = new de.malban.gui.dialogs.InternalFrameFileChoser();
            
            Path p = Paths.get(filename);
            fc.setCurrentDirectory(new java.io.File(p.getParent().toString()));
            int r = fc.showOpenDialog(Configuration.getConfiguration().getMainFrame());
            if (r != InternalFrameFileChoser.APPROVE_OPTION) return false;
            newFilename = fc.getSelectedFile().getAbsolutePath();            

            
            filename = newFilename;
        }
        
        FileWriter writer =null;
        try 
        {
            writer = new FileWriter(getFilename());
            jTextPane1.write(writer);
            if (saveAs)
                parent.changeFileName(oldFilename, newFilename);
        }
        catch (IOException e) 
        {
            tinyLog.printError("Error saving file: "+ filename);
            tinyLog.printError(de.malban.util.Utility.getCurrentStackTrace());
        }
        finally
        {
            if (writer != null)
            {
                try
                {
                    writer.close();
                }
                catch (Throwable e)
                {
                    
                }
                
            }
            
        }
        
        
        return ret;
    }

    String TAB_STRING = "    ";
    AbstractAction tabAction = new AbstractAction()
    {
        public void actionPerformed(ActionEvent e)
        {
            try
            {
                int start = jTextPane1.getSelectionStart();
                int startOrg = start;
                int end = jTextPane1.getSelectionEnd();
                if (end-start == 0)
                {
                    jTextPane1.getDocument().insertString(jTextPane1.getCaretPosition(),TAB_STRING, null);
                    return;
                }
                stopColoring();
                // now, add for every line in selection one TAB to start!
                int first = getLineOfPos(jTextPane1, start);
                int last = getLineOfPos(jTextPane1, end);
                for (int i=last; i>=first;i--)
                {
                    int pos = getPosOfLineStart(i);
                    jTextPane1.getDocument().insertString(pos,TAB_STRING, null);
                    end +=TAB_STRING.length();
                }
                startColoring();
                jTextPane1.setSelectionStart(start);
                jTextPane1.setSelectionEnd(end);
            }
            catch (Throwable ex)
            {
                ex.printStackTrace();
                startColoring();
            }
        }
        
    };
    AbstractAction shiftTabAction = new AbstractAction()
    {
        public void actionPerformed(ActionEvent e)
        {
            try
            {
                int start = jTextPane1.getSelectionStart();
                int startOrg = start;
                int end = jTextPane1.getSelectionEnd();
                if (end-start == 0)
                {
                    return;
                }
                stopColoring();

                // now, sub for every line in selection one TAB from start!
                int first = getLineOfPos(jTextPane1, start);
                int last = getLineOfPos(jTextPane1, end);
                for (int i=last; i>=first;i--)
                {
                    int pos = getPosOfLineStart(i);
                    int c = 0;
                    while ((jTextPane1.getDocument().getText(pos, 1).equals(" ")) && (c<TAB_STRING.length()))
                    {
                        jTextPane1.getDocument().remove(pos, 1);
                        end--;
                        c++;
                    }
                }
                startColoring();
                jTextPane1.setSelectionStart(start);
                jTextPane1.setSelectionEnd(end);
            }
            catch (Throwable ex)
            {
                ex.printStackTrace();
                startColoring();
            }
        }
        
    };
    protected void editActionChanged()
    {
        if (parent == null) return;
        parent.tabChanged(false);
    }

    public void jump()
    {
        int line = GetJumpValuePanel.showEnterValueDialog();
        jump(line);
        if (line <=0 ) 
        {
            goLine(0);
        }
        else if (line >getTextpaneRowCount())
        {
            goLine(getTextpaneRowCount()-1);
        }
        else
        {
            goLine(line);
        }
        jTextPane1.grabFocus();
    }
    public void jump(int line)
    {
        if (line <=0 ) 
        {
            goLine(0);
        }
        else if (line >getTextpaneRowCount())
        {
            goLine(getTextpaneRowCount()-1);
        }
        else
        {
            goLine(line);
        }
        jTextPane1.grabFocus();
    } }
