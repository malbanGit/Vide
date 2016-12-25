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
import de.malban.util.syntax.Syntax.TokenStyles;
import de.malban.util.syntax.Syntax.TokenStyles.MyStyle;
import de.malban.vide.veccy.VectorListFileChoserJPanel;
import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Component;
import java.awt.ComponentOrientation;
import java.awt.Dimension;
import java.awt.Point;
import java.awt.Rectangle;
import java.awt.event.ActionEvent;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import javax.swing.AbstractAction;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextPane;
import javax.swing.JViewport;
import javax.swing.SwingUtilities;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;
import javax.swing.plaf.ComponentUI;
import javax.swing.table.AbstractTableModel;
import javax.swing.text.AttributeSet;
import javax.swing.text.BadLocationException;
import javax.swing.text.DefaultStyledDocument;
import javax.swing.text.StyleConstants;
import javax.swing.text.Utilities;

/**
 *
 * @author malban
 */
public class EditorPanel extends EditorPanelFoundation
{

    // indicator whether rows must be counted anew
    int rowCount = -1;
    boolean isBasic = false;
    boolean hasChanged = false;
    boolean assume6809Asm = false;
    boolean addToSettings = true;  
    private int FONTHEIGHT = 12;
    private int FONTWIDTH = 12;
    void setAddToSettings(boolean b)
    {
        addToSettings = b;
    }
    boolean isAddToSettings()
    {
        return addToSettings;
    }
    
    TinyLogInterface tinyLog = null;
    private String filename = "";
    boolean initError = false;
    VEdiFoundationPanel parent;
    
    private HighlightedDocument editorPaneDocument;

    public void setParent(VEdiFoundationPanel p)
    {
        parent = p;
    }
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
////////////////
/*    
// see:     http://www.developer.com/java/other/article.php/3318421

    // other idea: https://www.thecodingforums.com/threads/jtextpane-with-line-numbers-down-the-side.129565/
    
class NumberedEditorKit extends StyledEditorKit {
    public ViewFactory getViewFactory() {
        return new NumberedViewFactory();
    }
}

class NumberedViewFactory implements ViewFactory {
    public View create(Element elem) {
        String kind = elem.getName();
        if (kind != null)
            if (kind.equals(AbstractDocument.ContentElementName)) {
                return new LabelView(elem);
            }
            else if (kind.equals(AbstractDocument.
                             ParagraphElementName)) {
//              return new ParagraphView(elem);
                return new NumberedParagraphView(elem);
            }
            else if (kind.equals(AbstractDocument.
                     SectionElementName)) {
                return new BoxView(elem, View.Y_AXIS);
            }
            else if (kind.equals(StyleConstants.
                     ComponentElementName)) {
                return new ComponentView(elem);
            }
            else if (kind.equals(StyleConstants.IconElementName)) {
                return new IconView(elem);
            }
        // default to text display
        return new LabelView(elem);
    }
}
public static short NUMBERS_WIDTH=25;
class NumberedParagraphView extends ParagraphView {
    

    public NumberedParagraphView(Element e) {
        super(e);
        short top = 0;
        short left = 0;
        short bottom = 0;
        short right = 0;
        this.setInsets(top, left, bottom, right);
    }

    protected void setInsets(short top, short left, short bottom,
                             short right) {super.setInsets
                             (top,(short)(left+NUMBERS_WIDTH),
                             bottom,right);
    }

    public void paintChild(Graphics g, Rectangle r, int n) {
        super.paintChild(g, r, n);
        int previousLineCount = getPreviousLineCount();
        int numberX = r.x - getLeftInset();
        int numberY = r.y + r.height - 5;
        g.drawString(Integer.toString(previousLineCount + n + 1),
                                      numberX, numberY);
    }

    public int getPreviousLineCount() {
        int lineCount = 0;
        View parent = this.getParent();
        int count = parent.getViewCount();
        for (int i = 0; i < count; i++) {
            if (parent.getView(i) == this) {
                break;
            }
            else {
                lineCount += parent.getView(i).getViewCount();
            }
        }
        return lineCount;
    }
    
    protected void setParagraphInsets(AttributeSet attr) 
    { 
        setInsets((short) StyleConstants.getSpaceAbove(attr),(short) StyleConstants.getLeftIndent(attr),(short) StyleConstants.getSpaceBelow(attr),(short) StyleConstants.getRightIndent(attr)); 
    }    
}    
    */
////////////////    
    public EditorPanel(String fn, TinyLogInterface tl) {
        tinyLog = tl;
        filename = fn;
        initComponents();
        
        
JPanel noWrapPanel = new JPanel( new BorderLayout() );
jScrollPane2.remove(jTextPane1);
noWrapPanel.add( jTextPane1 );
//JScrollPane scrollPane = new JScrollPane( noWrapPanel );        
        jScrollPane2.setViewportView(noWrapPanel);
        jScrollPane2.getVerticalScrollBar().setUnitIncrement(12);
        
//        jTextPane1.setEditorKit(new NumberedEditorKit());
        try 
        {
            FileReader fr = new FileReader(getFilename());
            jTextPane1.read(fr, null);
            fr.close();
            correctLineNumbers(false);
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
            @Override
            public boolean getScrollableTracksViewportWidth() {
              Component parent = getParent();
              ComponentUI uii = getUI();

              return parent != null ? (uii.getPreferredSize(this).width <= parent
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
     
    private void startColoring()
    {
        if (editorPaneDocument == null) return;
        editorPaneDocument.startColoring();
        restorePos();

    }
    public void startColoring(int fontSize)
    {
        FONTWIDTH = fontSize;
        startColoring();
        jScrollPane2.getVerticalScrollBar().setUnitIncrement(fontSize);
        correctLineNumbers(true);
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
        else if (getFilename().toLowerCase().endsWith(".bas"))
                editorPaneDocument.setHighlightStyle(HighlightedDocument.BASIC_STYLE);
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
        new HotKey("QuickHelp", new AbstractAction() { public void actionPerformed(ActionEvent e) {  help();}}, this);

        JViewport viewport = jScrollPane2.getViewport();
        viewport.addChangeListener(
                new ChangeListener()
                {
                    @Override
                    public void stateChanged(ChangeEvent e)
                    {
                        JViewport viewport = jScrollPane2.getViewport();
                        Point p = viewport.getViewPosition();
                        JViewport viewport2 = jScrollPane1.getViewport();
                        p.x=0;
                        viewport2.setViewPosition(p);                
                    }
                });            
        jTextPane1.setCaretPosition(0);
        
        final DefaultStyledDocument doc = new DefaultStyledDocument();
        jTextPane2.setDocument(doc);
        correctLineNumbers(true);
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
        jScrollPane2 = new javax.swing.JScrollPane();
        jTextPane1 = buildTextPane();
        jScrollPane1 = new javax.swing.JScrollPane();
        jTextPane2 = new javax.swing.JTextPane();

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

        jScrollPane2.setPreferredSize(new java.awt.Dimension(1, 1));

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

        jScrollPane1.setHorizontalScrollBarPolicy(javax.swing.ScrollPaneConstants.HORIZONTAL_SCROLLBAR_NEVER);
        jScrollPane1.setVerticalScrollBarPolicy(javax.swing.ScrollPaneConstants.VERTICAL_SCROLLBAR_NEVER);
        jScrollPane1.setFocusTraversalKeysEnabled(false);
        jScrollPane1.setFocusable(false);
        jScrollPane1.setPreferredSize(new java.awt.Dimension(47, 8));

        jTextPane2.setEditable(false);
        jScrollPane1.setViewportView(jTextPane2);

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jScrollPane2, javax.swing.GroupLayout.DEFAULT_SIZE, 782, Short.MAX_VALUE))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jScrollPane2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 606, Short.MAX_VALUE)
        );
    }// </editor-fold>//GEN-END:initComponents

    private void jTextPane1KeyTyped(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTextPane1KeyTyped
        rowCount = -1;
        fireEditorChanged(EditorEvent.EV_KEY_TYPED);
        
        correctLineNumbers(false);
    }//GEN-LAST:event_jTextPane1KeyTyped

    private void jTextPane1CaretUpdate(javax.swing.event.CaretEvent evt) {//GEN-FIRST:event_jTextPane1CaretUpdate
          fireEditorChanged(EditorEvent.EV_CARET_CHANGED);
    }//GEN-LAST:event_jTextPane1CaretUpdate

    private void jTextPane1KeyPressed(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTextPane1KeyPressed
        
    }//GEN-LAST:event_jTextPane1KeyPressed

    private void jTextPane1MousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jTextPane1MousePressed

        if (isBasic) return;
        Point pt = new Point(evt.getX(), evt.getY());
        int pos = jTextPane1.viewToModel(pt);

        boolean shift = KeyboardListener.isShiftDown();

        if (evt.getClickCount() == 2) 
        {
            jTextPane1.setSelectionStart(pos);
            jTextPane1.setSelectionEnd(pos); // -1 look shiity, but enables another previous search

            if ((SwingUtilities.isMiddleMouseButton(evt)) || (shift))
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
       
        String filenameI ="xml"+File.separator+"vectorlist";
        String text = VectorListFileChoserJPanel.showLoadPanel(filenameI,"Load Vectorlist", false, true);
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

        String filenameI ="xml"+File.separator+"vectoranimation";
        String text = VectorListFileChoserJPanel.showLoadPanel(filenameI,"Load Vector-Animation", true, true);
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
    // returns the line number of the given position
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
    // returns the position of the start of the word
    // that the given pos points to (can point to any position of that word)
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
    // get the word, that pos is pointing to
    // pos can be at "any" position of that word
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
    // returns a String representation of an integer
    // that the position points to
    // position can be "any" position within that integer
    // if no integer is found at position, an empty string is returned
    String getIntOfPos(JTextPane comp, int pos)
    {
        String word ="";
        try
        {
            String text = comp.getDocument().getText(0, comp.getDocument().getLength());
            char c = text.charAt(pos);
            while (!de.malban.util.UtilityString.isIntBoundry(c)) 
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
            while (!de.malban.util.UtilityString.isIntBoundry(c))
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
    // returns the position within the text
    // which represents the start of the given line number
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
    // returns the # line within the text as string (or empty string)
    public String getLine(JTextPane comp, int line)
    {
        try
        {
            return comp.getDocument().getText(0, comp.getDocument().getLength()).split("\n")[line];
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
    private javax.swing.JTextPane jTextPane1;
    private javax.swing.JTextPane jTextPane2;
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
            tinyLog.printError(de.malban.util.Utility.getStackTrace(e));
            return null;
        }
        return path;
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
        @Override
        public int getRowCount()
        {
            return getTextpaneRowCount();
        }
        @Override
        public int getColumnCount()
        {
            return 1;
        }
        @Override
        public Object getValueAt(int row, int col)
        {
            return row+1;
        }
        @Override
        public String getColumnName(int column) {
            return "";
        }
        @Override
        public Class<?> getColumnClass(int columnIndex) {
            return Integer.class;
        }
        @Override
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
    // search from the current cursor position the next instance of "to search"
    // and scroll to position and set carret (and set selection)
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
         ;//   e.printStackTrace();
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
        correctLineNumbers(false);
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
    boolean _0d0a = false;
    // sets a flag if the current document should be "forceably" saved
    // with line endings "0xd0 0xa0"
    // setting this to false STILL saves
    // the text with the OS defaults (Windows - "0xd0 0xa0")
    public void setODOA(boolean b)
    {
        _0d0a = b;
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
        if (_0d0a)
        {
            if (saveAs)
                parent.changeFileName(oldFilename, newFilename);
            try
            {
                String text = jTextPane1.getDocument().getText(0, jTextPane1.getDocument().getLength());
                text = de.malban.util.UtilityString.replace(text, "\n", "\r\n");
                de.malban.util.UtilityFiles.createTextFile(filename, text);
            }
            catch (Throwable e)
            {
                tinyLog.printError("Error saving file: "+ filename);
                tinyLog.printError(de.malban.util.Utility.getCurrentStackTrace());
 
            }
            return ret;
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
        @Override
        public void actionPerformed(ActionEvent e)
        {
            try
            {
                int start = jTextPane1.getSelectionStart();
                int startOrg = start;
                int end = jTextPane1.getSelectionEnd();
                if (start != end) end--;
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
        @Override
        public void actionPerformed(ActionEvent e)
        {
            try
            {
                int start = jTextPane1.getSelectionStart();
                int startOrg = start;
                int end = jTextPane1.getSelectionEnd();
                if (start != end) end--;
                if (end-start == 0)
                {
                   // return;
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
    @Override
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
    } 
    public void help()
    {
        int pos = jTextPane1.getCaretPosition();
        String word = getWordOfPos(jTextPane1, pos);
        String integer = getIntOfPos(jTextPane1, pos);
        parent.doQuickHelp(word, integer);
    }
    
    public void setBasic(boolean b)
    {
        isBasic = b;
    }
    @Override
    public void fireEditorChanged(int type)
    {
        super.fireEditorChanged(type);
    }
    void updateMyUI()
    {
        SwingUtilities.updateComponentTreeUI(jPopupMenu1);
    }
    int getLineCount(JTextPane textpane)
    {
        try
        {
            int length = textpane.getDocument().getLength();
            String text = textpane.getDocument().getText(0, length);

            int lineCount = text.split("\n").length;
            int backOffset = 1;

            while (text.charAt(length-backOffset) == '\n')
            {
                lineCount++;
                backOffset++;
            }
            return lineCount;
        }
        catch (Throwable e)
        {
            
        }
        return -1;
    }
    int oldlnWidth = -1;
    void correctLineNumbers(boolean force)
    {
        try
        {
            AttributeSet saset = TokenStyles.getStyle("comment");
            String text1 = jTextPane1.getDocument().getText(0, jTextPane1.getDocument().getLength());
            String text2 = jTextPane2.getDocument().getText(0, jTextPane2.getDocument().getLength());
            int lineCountOrg = text1.split("\n").length;
            int lineCountNow = text2.split("\n").length;

            lineCountOrg = getLineCount(jTextPane1);
            lineCountNow = getLineCount(jTextPane2);
            if  ((lineCountNow >lineCountOrg) || (force))
            {
                jTextPane2.setText("");
                lineCountNow = 0;
            }

            int w = 3;
            if (lineCountOrg>999) w= 4;
            if (lineCountOrg>9999) w= 5;
            if (lineCountOrg>99999) w= 6;
            
            int lineNumberWidth = ((StyleConstants.getFontSize(saset)-1)*w);

            if (oldlnWidth != lineNumberWidth)
            {
                SwingUtilities.invokeLater(new Runnable() {

                    @Override
                    public void run() 
                    {
                        Dimension lNumberSize = new Dimension(lineNumberWidth, jScrollPane1.getSize().height);
                        jScrollPane1.setSize(lNumberSize);
                        jScrollPane1.setPreferredSize(lNumberSize);
                        jScrollPane1.setMinimumSize(lNumberSize);
                        jScrollPane1.setMaximumSize(lNumberSize);
                        jScrollPane1.invalidate();
                        jScrollPane1.validate();
                        jScrollPane1.repaint();
                        if (jScrollPane1.getSize().height != 0)
                            oldlnWidth = lineNumberWidth;
                    }
                });
                
            
            }
            
            DefaultStyledDocument doc = (DefaultStyledDocument)jTextPane2.getDocument();
            while (lineCountNow <lineCountOrg)
            {
                if (lineCountNow==0)
                    doc.insertString(jTextPane2.getDocument().getLength(), ""+(++lineCountNow), saset);
                else
                    doc.insertString(jTextPane2.getDocument().getLength(), "\n"+(++lineCountNow), saset);
            }
        }
        catch (Throwable e)
        {
            
        }
        
    }
    
    // returns the curosur postion within the text
    // cursor position y = line number, x = column within that line
    // x is at maximum the corresponding line length, not the "screen" position (column)
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
    
//                        doc.setCharacterAttributes(sstart, slen, saset, true);
}
