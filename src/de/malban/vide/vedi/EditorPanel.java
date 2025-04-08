/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vedi;

import de.malban.Global;
import de.malban.vide.vedi.panels.GetJumpValuePanel;
import de.malban.config.Configuration;
import de.malban.config.TinyLogInterface;
import de.malban.gui.HotKey;
import de.malban.gui.ListPopupJPanel;
import de.malban.gui.dialogs.InternalFrameFileChoser;
import de.malban.gui.panels.LogPanel;
import static de.malban.gui.panels.LogPanel.INFO;
import de.malban.util.UtilityString;
import de.malban.util.syntax.Syntax.HighlightedDocument;
import de.malban.util.syntax.Syntax.TokenStyles;
import de.malban.util.syntax.entities.EntityDefinition;
import de.malban.vide.VideConfig;
import de.malban.vide.veccy.VectorListFileChoserJPanel;
import static de.malban.vide.vedi.DebugComment.SUB_WATCH_16BIT;
import static de.malban.vide.vedi.DebugComment.SUB_WATCH_2_8BIT;
import static de.malban.vide.vedi.DebugComment.SUB_WATCH_8BIT;
import static de.malban.vide.vedi.DebugComment.SUB_WATCH_BINARY;
import static de.malban.vide.vedi.DebugComment.SUB_WATCH_SEQUENCE;
import static de.malban.vide.vedi.DebugComment.SUB_WATCH_STRING;
import de.malban.vide.vedi.panels.GetRadiusValuePanel;
import de.malban.vide.vedi.panels.GetSinValuePanel;
import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Component;
import java.awt.Dimension;
import java.awt.Insets;
import java.awt.Point;
import java.awt.Rectangle;
import java.awt.event.ActionEvent;
import static java.awt.event.InputEvent.CTRL_DOWN_MASK;
import static java.awt.event.InputEvent.SHIFT_DOWN_MASK;
import java.awt.event.KeyEvent;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.zip.CRC32;
import javax.swing.AbstractAction;
import javax.swing.Action;
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
import javax.swing.text.DefaultStyledDocument;
import javax.swing.text.StyleConstants;

/**
 *
 * @author malban
 */
public class EditorPanel extends EditorPanelFoundation
{
    VideConfig config = VideConfig.getConfig();
    LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();

    // indicator whether rows must be counted anew
    int rowCount = -1;
    boolean isBasic = false;
    boolean hasChanged1 = false;
    boolean hasChanged2 = false;
    boolean assume6809Asm = false;
    boolean assume6809C = false;
    boolean addToSettings = true;  
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
        editorPaneDocument = new HighlightedDocument(vediId, getFilename());
        resetCRC();
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

    int vediId = -1;
    public int getVediId()
    {
        if (vediId != -1) return vediId;
        VEdiFoundationPanel vedi = VEdiFoundationPanel.getVedi(this);
        if (vedi != null)
        {
            vediId = vedi.UID;
        }
        
        return -1;
    }
    
    JPanel noWrapPanel = new JPanel( new BorderLayout() );
    public EditorPanel(String fn, TinyLogInterface tl, int id) {
        vediId = id;
        tinyLog = tl;
        filename = fn;
        initComponents();
        if (tl instanceof VEdiFoundationPanel)
            parent = (VEdiFoundationPanel) tl;
        
        jScrollPane2.remove(jTextPane1);
        noWrapPanel.add( jTextPane1 );

        jScrollPane2.setViewportView(noWrapPanel);
        jScrollPane2.getVerticalScrollBar().setUnitIncrement(12);
        
        try 
        {
            openEditorMap.put(filename.toLowerCase(), this);
            FileReader fr = new FileReader(getFilename());
            jTextPane1.read(fr, null);
            fr.close();
            resetCRC();
        }
        catch (IOException e) 
        {
            if (tl != null)
                tl.printError("Error loading file: "+getFilename());
            initError = true;
        }
        if (!initError)
        {
            try
            {
                setup(null);
            }
            catch (Throwable e)
            {
                initError = true;
            }
            
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
        resetCRC();
        if (recolor)
        {
            startColoring();
        }
        return true;
        
    }
    
    private static HashMap<String, EditorPanel> openEditorMap = new HashMap<String, EditorPanel>();
    public static String getTextForFile(String filename)
    {
        EditorPanel p = openEditorMap.get(filename.toLowerCase());
        if (p == null) return null;
        try
        {
            String text = p.jTextPane1.getDocument().getText(0, p.jTextPane1.getDocument().getLength());
            return text;
            
        }
        catch (Throwable e)
        {
            LogPanel slog = (LogPanel) Configuration.getConfiguration().getDebugEntity();
            slog.addLog(e);
        }
        return null;
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
//        FONTWIDTH = fontSize;
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
    boolean inSetup = false;
    class CSAViewport extends JViewport
    {
        public void setViewPosition(Point p)
        {
        }
        public void setViewPositionCSA(Point p)
        {
            super.setViewPosition(p);
        }
    }
    class CSAViewport2 extends JViewport
    {
        public boolean enableViewport = true;
        @Override
        public void setViewPosition(Point p)
        {
            if (enableViewport) super.setViewPosition(p);
        }
    }
    public void setViewportEnabled(boolean b)
    {
        if (jScrollPane2.getViewport() instanceof CSAViewport2)
        {
            if (b)
            {
                SwingUtilities.invokeLater(new Runnable() {
                @Override public void run() 
                    {
                ((CSAViewport2)jScrollPane2.getViewport()).enableViewport = b;
                    }
                });                
            }
            else
                ((CSAViewport2)jScrollPane2.getViewport()).enableViewport = b;
        }
    }
    
    public void setup(String t)
    {
        inSetup = true;
        jTextPane2.setMargin(new Insets(1,3,1,3));
        rowCount = -1;
        jTextPane1.setCaret(new HighlightCaret());
        if (t == null) t=jTextPane1.getText();
       
        // Text Highlight setup
        if (vediId == -1)
        {
            VEdiFoundationPanel vedi = VEdiFoundationPanel.getVedi(this);
            if (vedi != null) vediId = vedi.UID;
        }
        resetDocument();
        jTextPane1.setDocument(editorPaneDocument);
        resetCRC();
        
        if ((getFilename().toLowerCase().endsWith(".template") )
                ||(getFilename().toLowerCase().endsWith(".s") ) 
                || (getFilename().toLowerCase().endsWith(".asm")) 
                || (getFilename().toLowerCase().endsWith(".as9"))
                || (getFilename().toLowerCase().endsWith(".a69")) 
                || (getFilename().toLowerCase().endsWith(".inc")))
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
        else if ((getFilename().toLowerCase().endsWith(".c"))
                || (getFilename().toLowerCase().endsWith(".h"))
                || (getFilename().toLowerCase().endsWith(".ec")))
        {
            editorPaneDocument.setHighlightStyle(HighlightedDocument.C_STYLE);
            assume6809C = true;
        }
        else if ((getFilename().toLowerCase().endsWith(".htm"))|| (getFilename().toLowerCase().endsWith(".html")))
                editorPaneDocument.setHighlightStyle(HighlightedDocument.HTML_STYLE);
        else if (getFilename().toLowerCase().endsWith(".sql"))
                editorPaneDocument.setHighlightStyle(HighlightedDocument.SQL_STYLE);
        else if (getFilename().toLowerCase().endsWith(".properties"))
                editorPaneDocument.setHighlightStyle(HighlightedDocument.PROPERTIES_STYLE);
        else
                editorPaneDocument.setHighlightStyle(HighlightedDocument.GRAYED_OUT_STYLE);
            
        if (parent instanceof VediPanel)   
        {
            if ((getFilename().toLowerCase().endsWith(".i") ))
            {
                if (((VediPanel)parent).currentProject!=null)
                {
                    if (((VediPanel)parent).currentProject.getIsPeerCProject())
                    {
                        editorPaneDocument.setHighlightStyle(HighlightedDocument.C_STYLE);
                        assume6809C = true;
                    }
                }
                if (!assume6809C)
                {
                    assume6809Asm = true;
                    editorPaneDocument.setHighlightStyle(HighlightedDocument.M6809_STYLE, false);
                }
            }
        }
        
        
        
        if (t != null) jTextPane1.setText(t);
        editorPaneDocument.start(getFilename());
        resetCRC();
        if (VideConfig.editorUndoEnabled)
        {
            editorPaneDocument.addUndoableEditListener(undoManager);
            new HotKey("UndoMac", undoAction, jTextPane1);
            new HotKey("RedoMac", redoAction, jTextPane1);
            new HotKey("UndoWin", undoAction, jTextPane1);
            new HotKey("RedoWin", redoAction, jTextPane1);
            new HotKey("UndoWin", undoAction, jTextPane1);
            new HotKey("RedoWin", redoAction, jTextPane1);
        }
        
        new HotKey(javax.swing.text.DefaultEditorKit.copyAction,(Action)null, jTextPane1);
        new HotKey(javax.swing.text.DefaultEditorKit.pasteAction, (Action)null, jTextPane1);
        new HotKey(javax.swing.text.DefaultEditorKit.cutAction, (Action)null, jTextPane1);
        new HotKey(javax.swing.text.DefaultEditorKit.selectAllAction, (Action)null, jTextPane1);

        new HotKey("EditorSearchCopy", javax.swing.text.DefaultEditorKit.copyAction, jTextPane1);
        new HotKey("EditorSearchPaste", javax.swing.text.DefaultEditorKit.pasteAction,  jTextPane1);
        new HotKey("EditorSearchCut", javax.swing.text.DefaultEditorKit.cutAction,  jTextPane1);
        new HotKey("EditorSearchSelect", javax.swing.text.DefaultEditorKit.selectAllAction,  jTextPane1);
        

        if (Global.getOSName().toUpperCase().contains("MAC"))
        {
            new HotKey("FirstCharInLine", javax.swing.text.DefaultEditorKit.beginLineAction, jTextPane1);
            new HotKey("LastCharInLine", javax.swing.text.DefaultEditorKit.endLineAction, jTextPane1);
            new HotKey("FileStart", javax.swing.text.DefaultEditorKit.beginAction, jTextPane1);
            new HotKey("FileEnd", javax.swing.text.DefaultEditorKit.endAction, jTextPane1);
        }
        
        new HotKey("unindent", shiftTabAction, jTextPane1);
        new HotKey("indent", tabAction, jTextPane1);
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
                        syncViewports();
                    }
                });            
        jScrollPane1.getViewport().addChangeListener(
                new ChangeListener()
                {
                    @Override
                    public void stateChanged(ChangeEvent e)
                    {
                        
                        JViewport viewport = jScrollPane2.getViewport();
                        if (viewport == null) return;
                        Point p = viewport.getViewPosition();
                        JViewport viewport2 = jScrollPane1.getViewport();
                        if (p.y != viewport2.getViewPosition().y)
                        {
                            p.x=0;
                            viewport2.setViewPosition(p);                
                        }
                    }
                });            
        jTextPane1.setCaretPosition(0);
        
        
        
        
        
                
        
        final DefaultStyledDocument doc = new DefaultStyledDocument();
        jTextPane2.setDocument(doc);
        correctLineNumbers(true);
        initDebugDisplay();
        inSetup = false;
    }
    
    public void deinit()
    {
        if (editorPaneDocument!= null)
            editorPaneDocument.deinit();
        editorPaneDocument = null;
        if (parent instanceof VediPanel)
            parent.settings.setOpenPosition(getFilename(), getPosition());
        if (parent instanceof PiTrexTerminal)
            parent.settings.setOpenPosition(getFilename(), getPosition());
        if (filename != null)
            openEditorMap.remove(filename.toLowerCase());
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
        jMenu1 = new javax.swing.JMenu();
        jMenuItem1 = new javax.swing.JMenuItem();
        jMenuItem2 = new javax.swing.JMenuItem();
        jMenuItem3 = new javax.swing.JMenuItem();
        jMenuItem4 = new javax.swing.JMenuItem();
        jMenuItem5 = new javax.swing.JMenuItem();
        jMenu3 = new javax.swing.JMenu();
        jMenuItemWatchBinary = new javax.swing.JMenuItem();
        jMenuItemWatchByte = new javax.swing.JMenuItem();
        jMenuItemWatchWord = new javax.swing.JMenuItem();
        jMenuItemWatchString = new javax.swing.JMenuItem();
        jMenuItemWatchBytePair = new javax.swing.JMenuItem();
        jMenuItemWatchSequence = new javax.swing.JMenuItem();
        jScrollPane2 = new JScrollPane()
        {
            protected JViewport createViewport() {
                return new CSAViewport2();
            }

        }
        ;
        jTextPane1 = buildTextPane();
        jScrollPane1 = new JScrollPane()
        {
            protected JViewport createViewport() {
                return new CSAViewport();
            }

        }
        ;
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

        jMenu1.setText("data generation");

        jMenuItem1.setText("sin");
        jMenuItem1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem1ActionPerformed(evt);
            }
        });
        jMenu1.add(jMenuItem1);

        jMenuItem2.setText("cos");
        jMenuItem2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem2ActionPerformed(evt);
            }
        });
        jMenu1.add(jMenuItem2);

        jMenuItem3.setText("circle (y=cos, x = -sin)");
        jMenuItem3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem3ActionPerformed(evt);
            }
        });
        jMenu1.add(jMenuItem3);

        jMenuItem4.setText("sin dif");
        jMenuItem4.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem4ActionPerformed(evt);
            }
        });
        jMenu1.add(jMenuItem4);

        jMenuItem5.setText("Faller 256");
        jMenuItem5.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem5ActionPerformed(evt);
            }
        });
        jMenu1.add(jMenuItem5);

        jPopupMenu1.add(jMenu1);

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

        addComponentListener(new java.awt.event.ComponentAdapter() {
            public void componentResized(java.awt.event.ComponentEvent evt) {
                formComponentResized(evt);
            }
        });
        setLayout(new java.awt.BorderLayout());

        jScrollPane2.addComponentListener(new java.awt.event.ComponentAdapter() {
            public void componentResized(java.awt.event.ComponentEvent evt) {
                jScrollPane2ComponentResized(evt);
            }
        });

        jTextPane1.setBorder(javax.swing.BorderFactory.createEmptyBorder(1, 3, 1, 3));
        jTextPane1.setFont(new java.awt.Font("Courier New", 0, 12)); // NOI18N
        jTextPane1.setText("\n\n\n        ORG     $0000                      ; start address of all vectrex progs -> 0\n\n        DB -$0e,  $ff, -$01, -$02, -$03, -$08, -$0a, -$0c,  $00\n\nPrint_Str_hwyx  EQU     $F373   ;\nIntensity_5F    EQU     $F2A5   ;\nWait_Recal      EQU     $F192   ;\nmusic1  EQU $FD0D               ;\n\n\n; Magic Init Block\n\n\n_m:     ; M\n        fcb     20*5,0\n        fcb     5*5,-5*5\n        fcb     0,-17*5\n        fcb     0,-18*5\n        fcb     -25*5,0\n        fcb     0,10*5\n        fcb     20*5,0\n        fcb     -5*5,5*5\n        fcb     -15*5,0\n        fcb     0,10*5\n        fcb     20*5,0\n        fcb     -5*5,5*5\n        fcb     -15*5,0\n        fcb     0,10*5\n;        fcb     1\n        fcb     -2,2,3,-1,1,1,-2,2\n\n        FCB     $67,$20                    ; copyright sign and space\n        FCC     \"GCE XXXX\"                 ; copyright text, must start with copyright sign space GCE\n        FCB     $80                        ; end of text marker\n        FDB     music1                      ; music address to be played on title screen\n        FDB     $f850                      ; text size for following text height, width (A,B)\n        FDB     $30b8                      ; position of following text y,x (A,B)\n        FCC     \"MOON LANDER\"              ; text\n        FCB     $80,$0                     ; text end ($80) and header end (0)\n\n        direct $d0                         ; vectrex starts with dp set to $d0\ninit:                                      ; start of program\n        lda <$01\n\n        JSR \t\tWait_Recal\n        jsr     Intensity_5F            ; brightness to $5f\n                                           ; no need to go to zero here,\n                                           ; since this is the first printing\n\n        ldu     #TestString1               ; load score string\n        jsr     Print_Str_hwyx          ; print it\n        ldu     #TestString2               ; load score string\n        jsr     Print_Str_hwyx          ; print it\n        ldu     #TestString3               ; load score string\n        jsr     Print_Str_hwyx          ; print it\n        ldu     #TestString4               ; load score string\n        jsr     Print_Str_hwyx          ; print it\n        ldu     #TestString5               ; load score string\n        jsr     Print_Str_hwyx          ; print it\n        ldu     #TestString6               ; load score string\n        jsr     Print_Str_hwyx          ; print it\n        ldu     #TestString7               ; load score string\n        jsr     Print_Str_hwyx          ; print it\n        ldu     #TestString8               ; load score string\n        jsr     Print_Str_hwyx          ; print it\n        ldu     #TestString9               ; load score string\n        jsr     Print_Str_hwyx          ; print it\n\n        jmp init\n\n\n\nTestString1:\n        fdb      $f53a\n        fdb      $7090\n\tFCC     \"THIS IS A LONG MESSAGE TO BE\"\n\t  FCB $81\nTestString2:\n        fdb      $f53a\n        fdb      $5090\n\tFCC     \"PRINTED ON A POOR VECTREX\"\n\t  FCB $81\nTestString3:\n        fdb      $f53a\n        fdb      $3090\n\tFCC     \"DISPLAY, BUT IT MIGHT BE USED\"\n\t  FCB $81\nTestString4:\n        fdb      $f53a\n        fdb      $1090\n\tFCC     \"AS A SPEEDTEST FOR THE PRINT\"\n\t  FCB $81\nTestString5:\n        fdb      $f53a\n        fdb      $e090\n\tFCC     \"ROUTINES!\"\n\t  FCB $81\nTestString6:\n        fdb      $f53a\n        fdb      $d090\n\tFCC     \"THIS IS A LONG MESSAGE TO BE\"\n\t  FCB $81\nTestString7:\n        fdb      $f53a\n        fdb      $b090\n\tFCC     \"PRINTED ON A POOR VECTREX\"\n\t  FCB $81\nTestString8:\n        fdb      $f53a\n        fdb      $9090\n\tFCC     \"DISPLAY, BUT IT MIGHT BE USED\"\n\t  FCB $81\nTestString9:\n        fdb      $f53a\n        fdb      $8090\n\tFCC     \"AS A SPEEDTEST FOR THE PRINT\"\n\t  FCB $81\n");
        jTextPane1.setMinimumSize(new java.awt.Dimension(100, 100));
        jTextPane1.setPreferredSize(null);
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
        jTextPane1.addComponentListener(new java.awt.event.ComponentAdapter() {
            public void componentResized(java.awt.event.ComponentEvent evt) {
                jTextPane1ComponentResized(evt);
            }
        });
        jTextPane1.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyPressed(java.awt.event.KeyEvent evt) {
                jTextPane1KeyPressed(evt);
            }
            public void keyTyped(java.awt.event.KeyEvent evt) {
                jTextPane1KeyTyped(evt);
            }
        });
        jScrollPane2.setViewportView(jTextPane1);

        add(jScrollPane2, java.awt.BorderLayout.CENTER);

        jScrollPane1.setHorizontalScrollBarPolicy(javax.swing.ScrollPaneConstants.HORIZONTAL_SCROLLBAR_NEVER);
        jScrollPane1.setVerticalScrollBarPolicy(javax.swing.ScrollPaneConstants.VERTICAL_SCROLLBAR_NEVER);
        jScrollPane1.setFocusable(false);

        jTextPane2.setEditable(false);
        jTextPane2.setFont(new java.awt.Font("Courier New", 0, 12)); // NOI18N
        jTextPane2.setCursor(new java.awt.Cursor(java.awt.Cursor.DEFAULT_CURSOR));
        jTextPane2.setPreferredSize(null);
        jTextPane2.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jTextPane2MousePressed(evt);
            }
        });
        jScrollPane1.setViewportView(jTextPane2);

        add(jScrollPane1, java.awt.BorderLayout.WEST);
    }// </editor-fold>//GEN-END:initComponents
    
    int countChars(String s, String c)
    {
        int count = 0;
        int pos=-1;
        do
        {   
            pos = s.indexOf(c, pos+1);
            if (pos >=0) count++;
        }
        while (pos >=0);
        
        return count;
    }
    
    int[] brackCount;
    void recountBraces()
    {
        int lineCount = getLineCount(jTextPane1);
        if (lineCount<=0) lineCount=0;
        int openCount = 0;
        brackCount = new int[lineCount];
        try
        {
            int length = jTextPane1.getDocument().getLength();
            String text = jTextPane1.getDocument().getText(0, length);
            String[] split = text.split("\n");

            for (int i=0; i<split.length; i++)
            {
                openCount += countChars(split[i], "{");
                openCount -= countChars(split[i], "}");
                if (i+1<brackCount.length) 
                    brackCount[i+1]= openCount;
            }
        }
        catch (Throwable e)
        {

        }
    }
    String getTabForLineBracket(int line)
    {
        recountBraces();
        if (line>=brackCount.length) return "";
        if (line<0) return "";

        String ret = "";

        for (int i=0;i<brackCount[line];i++) 
            ret+=getTABString(); 
        return ret;
    }
    
    private void jTextPane1KeyTyped(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTextPane1KeyTyped
        rowCount = -1;
        fireEditorChanged(EditorEvent.EV_KEY_TYPED, getPosition());
        hasChanged1 = true;
        hasChanged2 = true;
        
        if (evt.getExtendedKeyCode()==KeyEvent.VK_ENTER)
        {
            try
            {
                int startPos = jTextPane1.getCaretPosition();
                int lineNo = getLineOfPos(startPos);
                synchronized (editorPaneDocument.getDocumentLock())
                {
                    jTextPane1.setSelectionStart(startPos);
                    jTextPane1.setSelectionEnd(startPos);
                    jTextPane1.replaceSelection(getTabForLineBracket(lineNo));
                }
            }
            catch (Throwable e)
            {
                e.printStackTrace();
log.addLog("Attrib:\n"+de.malban.util.Utility.getStackTrace(e), INFO);
            }
        
        
        }
        if (evt.getExtendedKeyCode()==KeyEvent.VK_BRACERIGHT)
        {
            try
            {
                // check if char befor is TAB if so delete it
                int startPos = jTextPane1.getCaretPosition()-getTABString().length();
                int endPos = jTextPane1.getCaretPosition()-0;
                jTextPane1.setSelectionStart(startPos);
                jTextPane1.setSelectionEnd(endPos);
                String before = jTextPane1.getSelectedText();
                if (before.endsWith(getTABString()))
                {
                    synchronized (editorPaneDocument.getDocumentLock())
                    {
                        jTextPane1.replaceSelection("}");
                        evt.consume();
                    }
                }
                jTextPane1.setSelectionStart(startPos+1);
                jTextPane1.setSelectionEnd(startPos+1);
                
            }
            catch (Throwable e)
            {
                e.printStackTrace();
log.addLog("Attrib:\n"+de.malban.util.Utility.getStackTrace(e), INFO);
            }
        
        
        }
        
        correctLineNumbers(false);
    }//GEN-LAST:event_jTextPane1KeyTyped

    private void jTextPane1CaretUpdate(javax.swing.event.CaretEvent evt) {//GEN-FIRST:event_jTextPane1CaretUpdate
          fireEditorChanged(EditorEvent.EV_CARET_CHANGED, getPosition());
    }//GEN-LAST:event_jTextPane1CaretUpdate

    // gets the "word" that the current cursor has in front
    // or "" - word breaks at current caret position
    private String getStarterText()
    {
        int pos = jTextPane1.getCaretPosition()-1;
        if (pos <=0) return "";
        
        
        String word ="";
        try
        {
            String text = jTextPane1.getDocument().getText(0, jTextPane1.getDocument().getLength());
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
            while ((!de.malban.util.UtilityString.isWordBoundry(c)) && (pos<=jTextPane1.getCaretPosition()-1))
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
   
    private void jTextPane1KeyPressed(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTextPane1KeyPressed
        boolean ctrl = ((evt.getModifiersEx() & CTRL_DOWN_MASK) == CTRL_DOWN_MASK);
        if (!ctrl) return;
        if (evt.getKeyCode() == KeyEvent.VK_SPACE)
        {
            // open ComboBox with possible extenion
            int endPos = jTextPane1.getCaretPosition();
            int startPos = endPos -1;
            if (startPos <=0) return;
            try
            {
                String text = jTextPane1.getDocument().getText(0, jTextPane1.getDocument().getLength());
                char c = text.charAt(startPos);
                while (!de.malban.util.UtilityString.isWordBoundry(c)) 
                {
                    startPos--;
                    if (startPos <0)
                    {
                        break;
                    }
                    c = text.charAt(startPos);
                }
                startPos++;
                String starter = getStarterText();
                ArrayList<String> possibleWord = getPossibleWords(starter);
                //Rectangle pos = jTextPane1.modelToView(startPos);

                
// JAVA10                Rectangle2D pos = jTextPane1.modelToView2D(startPos);
                Rectangle pos = jTextPane1.modelToView(startPos);

                
                int x1 = (int) pos.getX();
                int x2 = parent.getEditorPos().x;
                int x3 = Configuration.getConfiguration().getMainFrame().getInternalFrame(parent).getX();
                int x4 = jScrollPane1.getWidth()+4;
                int x5 = -jScrollPane2.getViewport().getViewPosition().x;
                
                int y1 = (int)pos.getY();
                int y2 = parent.getEditorPos().y;
                int y3 = Configuration.getConfiguration().getMainFrame().getInternalFrame(parent).getY();
                int y4 = 95;
                int y5 = -jScrollPane2.getViewport().getViewPosition().y;
                
                int posx = x1+x2+x3+x4+x5;
                int posy = y1+y2+y3+y4+y5;

                
                
                

                String select = ListPopupJPanel.showListDialog(possibleWord, posx, posy);
                if (select.length() != 0)
                {
                    // replace
                    synchronized (editorPaneDocument.getDocumentLock())
                    {
                        jTextPane1.setSelectionStart(startPos);
                        jTextPane1.setSelectionEnd(endPos);
                        jTextPane1.replaceSelection(select);
                    }
                }
                jTextPane1.requestFocusInWindow();
            }
            catch (Throwable e)
            {
e.printStackTrace();
            }
            
            
        }
        
    }//GEN-LAST:event_jTextPane1KeyPressed

    ArrayList<String> getPossibleWords(String starter)
    {
        ArrayList<String> ret = new ArrayList<String>();
        if (assume6809Asm)
        {
            Set entries = VediPanel.getVedi(this).asmInfo.knownGlobalVariables.entrySet();
            Iterator it = entries.iterator();
            while (it.hasNext())
            {
                try
                {
                    Map.Entry entry = (Map.Entry) it.next();
                    EntityDefinition value = (EntityDefinition) entry.getValue();
                    if (value.getName().toLowerCase().startsWith(starter.toLowerCase()))
                    {
                        ret.add(value.getName());
                    }
                }
                catch (Throwable x){}
            }
        }
        else if (assume6809C)
        {
            Set entries = VediPanel.getVedi(this).cInfo.knownGlobalFunctions.entrySet();
            Iterator it = entries.iterator();
            while (it.hasNext())
            {
                Map.Entry entry = (Map.Entry) it.next();
                EntityDefinition value = (EntityDefinition) entry.getValue();
                if (value.getName().toLowerCase().startsWith(starter.toLowerCase()))
                {
                    ret.add(value.getName());
                }
            }
            
        }
        Collections.sort(ret);
        
        return ret;
    }
    
    
    
    private void jTextPane1MousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jTextPane1MousePressed

        if (isBasic) return;
        Point pt = new Point(evt.getX(), evt.getY());
    // JAVA10    Point2D.Float pt = new Point2D.Float(evt.getX(), evt.getY());
        int pos = jTextPane1.viewToModel(pt);
    // JAVA10    int pos = jTextPane1.viewToModel2D(pt);
        
      
        
        boolean shift = ((evt.getModifiersEx()& SHIFT_DOWN_MASK) == SHIFT_DOWN_MASK);

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
                if (((evt.getModifiersEx() & SHIFT_DOWN_MASK) == SHIFT_DOWN_MASK))
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
                jMenu3.setVisible(assume6809Asm);
                               
                jPopupMenu1.show(this, evt.getX()-20- jScrollPane2.getViewport().getViewPosition().x,evt.getY()-20- jScrollPane2.getViewport().getViewPosition().y);
            }
        }
        jTextPane1.setSelectionStart(pos);
        jTextPane1.setSelectionEnd(pos); // -1 look shiity, but enables another previous search
        
    }//GEN-LAST:event_jTextPane1MousePressed
    int popUpTextPos = 0;

    private void jMenuItemAddVectorlistActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemAddVectorlistActionPerformed
       
        String filenameI =Global.mainPathPrefix+"xml"+File.separator+"vectorlist";
        String text = VectorListFileChoserJPanel.showLoadPanel(filenameI,"Load Vectorlist", false, true);
        stopColoring();
        
        try
        {
            jTextPane1.getDocument().insertString(popUpTextPos, text, null);
            correctLineNumbers(false);
        }
        catch (Throwable e)
        {
            
        }
        
        startColoring();
        
    }//GEN-LAST:event_jMenuItemAddVectorlistActionPerformed

    private void jMenuItemAddAnimActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemAddAnimActionPerformed

        String filenameI =Global.mainPathPrefix+"xml"+File.separator+"vectoranimation";
        String text = VectorListFileChoserJPanel.showLoadPanel(filenameI,"Load Vector-Animation", true, true);
        stopColoring();
        
        try
        {
            jTextPane1.getDocument().insertString(popUpTextPos, text, null);
            correctLineNumbers(false);
        }
        catch (Throwable e)
        {
            
        }
        
        startColoring();
    }//GEN-LAST:event_jMenuItemAddAnimActionPerformed

    private void jTextPane1ComponentResized(java.awt.event.ComponentEvent evt) {//GEN-FIRST:event_jTextPane1ComponentResized
         //JPanel w = noWrapPanel;
    }//GEN-LAST:event_jTextPane1ComponentResized

    private void jScrollPane2ComponentResized(java.awt.event.ComponentEvent evt) {//GEN-FIRST:event_jScrollPane2ComponentResized
         //JPanel w = noWrapPanel;
    }//GEN-LAST:event_jScrollPane2ComponentResized

    private void formComponentResized(java.awt.event.ComponentEvent evt) {//GEN-FIRST:event_formComponentResized
         //JPanel w = noWrapPanel;
         jScrollPane2.doLayout();
         Rectangle size = jScrollPane2.getBounds();
         size.height = getHeight();
         jScrollPane2.setBounds(size);

         size = jScrollPane1.getBounds();
         size.height = getHeight();
         jScrollPane1.setBounds(size);

         
         invalidate();
        validate();
         this.doLayout();
         repaint();
    }//GEN-LAST:event_formComponentResized

    private void jTextPane2MousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jTextPane2MousePressed
        if (isBasic) return;
        
// JAVA10        Point2D.Float pt = new Point2D.Float(evt.getX(), evt.getY());
// JAVA10        int pos = jTextPane2.viewToModel2D(pt);
        
        Point pt = new Point(evt.getX(), evt.getY());
        int pos = jTextPane2.viewToModel(pt);

        int line = getLineOfPos(jTextPane2, pos); // starts at 0
        if (line == -1)
        {
            return;
        }

        // click one
        if (SwingUtilities.isLeftMouseButton(evt))
        {
            if (assume6809Asm)
            {
                toggleBreakpoint(line);
            }
            else if (assume6809C)
            {
                toggleBreakpoint(line);
            }
            // toggle bp at line
        }
        else if (SwingUtilities.isRightMouseButton(evt))
        {
        }

    }//GEN-LAST:event_jTextPane2MousePressed

    private void jMenuItem1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem1ActionPerformed
        // add a sin data
        int count = GetSinValuePanel.showEnterValueDialog();
        double radius = GetRadiusValuePanel.showEnterValueDialog();
        if (count == 0) return;
        
        StringBuilder builder = new StringBuilder();
        double adds = 360.0/((double)count);
        double angle = 0.0;
        builder.append("; sin generated 0°-360° in ").append(count).append(" steps, radius: "+((int)radius)+"\n");
        for (int i=0; i< count; i++)
        {
            // value ranging in SIN from -127 to + 127
            int v = ((int)(Math.sin( Math.toRadians(angle)) *radius))&0xff;
            builder.append(" ").append("db ").append("$").append(String.format("%02X",v)).append(" ; degrees: ").append((int)angle).append("°\n");
            angle += adds;
        }
        
        stopColoring();
        try
        {
            jTextPane1.getDocument().insertString(popUpTextPos, builder.toString(), null);
            correctLineNumbers(false);
        }
        catch (Throwable e)
        {
            
        }
        startColoring();
    }//GEN-LAST:event_jMenuItem1ActionPerformed

    private void jMenuItem2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem2ActionPerformed
        // add a cos data
        int count = GetSinValuePanel.showEnterValueDialog();
        double radius = GetRadiusValuePanel.showEnterValueDialog();
        if (count == 0) return;
        
        StringBuilder builder = new StringBuilder();
        double adds = 360.0/((double)count);
        double angle = 0.0;
        builder.append("; cos generated 0°-360° in ").append(count).append(" steps, radius: "+((int)radius)+"\n");
        for (int i=0; i< count; i++)
        {
            // value ranging in SIN from -127 to + 127
            int v = ((int)(Math.cos( Math.toRadians(angle)) *radius))&0xff;
            builder.append(" ").append("db ").append("$").append(String.format("%02X",v)).append(" ; degrees: ").append((int)angle).append("°\n");
            angle += adds;
        }
        
        stopColoring();
        try
        {
            jTextPane1.getDocument().insertString(popUpTextPos, builder.toString(), null);
            correctLineNumbers(false);
        }
        catch (Throwable e)
        {
            
        }
        
        startColoring();
    }//GEN-LAST:event_jMenuItem2ActionPerformed

    private void jMenuItem3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem3ActionPerformed
        // add a cos data
        int count = GetSinValuePanel.showEnterValueDialog();
        double radius = GetRadiusValuePanel.showEnterValueDialog();
        if (count == 0) return;
        
            StringBuilder builder = new StringBuilder();
            double adds = 360.0/((double)count);
            double angle = 0.0;
            builder.append("; circle generated 0°-360° in ").append(count).append(" steps (cos, -sin), radius: "+((int)radius)+"\n");
            for (int i=0; i< count; i++)
            {
                // value ranging in SIN from -127 to + 127
                int cos = ((int)(Math.cos( Math.toRadians(angle)) *radius))&0xff;
                int sin = (((int)(-Math.sin( Math.toRadians(angle)) *radius))&0xff);
                builder.append(" ").append("db ").append("$").append(String.format("%02X",cos)).append(", $").append(String.format("%02X",sin)).append(" ; degrees: ").append((int)angle).append("°\n");
                angle += adds;
            }
        
        stopColoring();
        try
        {
            jTextPane1.getDocument().insertString(popUpTextPos, builder.toString(), null);
            correctLineNumbers(false);
        }
        catch (Throwable e)
        {
            
        }
        
        startColoring();
    }//GEN-LAST:event_jMenuItem3ActionPerformed
    

    private void jMenuItemWatchBinaryActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemWatchBinaryActionPerformed
        addWatch(popUpTextPos, SUB_WATCH_BINARY,0);
    }//GEN-LAST:event_jMenuItemWatchBinaryActionPerformed

    private void jMenuItemWatchByteActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemWatchByteActionPerformed
        addWatch(popUpTextPos, SUB_WATCH_8BIT,0);
    }//GEN-LAST:event_jMenuItemWatchByteActionPerformed

    private void jMenuItemWatchWordActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemWatchWordActionPerformed
        addWatch(popUpTextPos, SUB_WATCH_16BIT,0);
    }//GEN-LAST:event_jMenuItemWatchWordActionPerformed

    private void jMenuItemWatchStringActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemWatchStringActionPerformed
        addWatch(popUpTextPos, SUB_WATCH_STRING,0);
    }//GEN-LAST:event_jMenuItemWatchStringActionPerformed

    private void jMenuItemWatchBytePairActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemWatchBytePairActionPerformed
        addWatch(popUpTextPos, SUB_WATCH_2_8BIT,0);
    }//GEN-LAST:event_jMenuItemWatchBytePairActionPerformed

    private void jMenuItemWatchSequenceActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemWatchSequenceActionPerformed
        addWatch(popUpTextPos, SUB_WATCH_SEQUENCE,5);
    }//GEN-LAST:event_jMenuItemWatchSequenceActionPerformed

    private void jMenuItem4ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem4ActionPerformed
        // add a sin dif data
        int count = GetSinValuePanel.showEnterValueDialog();
        double radius = GetRadiusValuePanel.showEnterValueDialog();
        if (count == 0) return;
        
        StringBuilder builder = new StringBuilder();
        double adds = 360.0/((double)count);
        double angle = 0.0;
        builder.append("; sin generated 0°-360° in ").append(count).append(" steps, radius: "+((int)radius)+"\n");

        int oldValue = 0;
        for (int i=0; i< count; i++)
        {
            // value ranging in SIN from -127 to + 127
            int v = ((int)(Math.sin( Math.toRadians(angle)) *radius))&0xff;
            int difValue = v-oldValue;
            
            oldValue = v;
            builder.append(" ").append("db ").append("$").append(String.format("%02X",(difValue&0xff))).append(" ; degrees: ").append((int)angle).append("°\n");
            angle += adds;
        }
        
        stopColoring();
        try
        {
            jTextPane1.getDocument().insertString(popUpTextPos, builder.toString(), null);
            correctLineNumbers(false);
        }
        catch (Throwable e)
        {
            
        }
        
        startColoring();


    }//GEN-LAST:event_jMenuItem4ActionPerformed

    private void jMenuItem5ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem5ActionPerformed

        // add a cos data
        int count = GetSinValuePanel.showEnterValueDialog();
        double radius = GetRadiusValuePanel.showEnterValueDialog();
        if (count == 0) return;
        
            StringBuilder builder = new StringBuilder();
            double adds = 360.0/((double)count);
            double angle = 270.0;
            builder.append("; circle generated 0°-360° in ").append(count).append(" steps (cos, -sin), radius: "+((int)radius)+"\n");
            double anglePrint = 0;
            for (int i=0; i< count; i++)
            {
                // value ranging in SIN from -127 to + 127
                int cos = ((int)(Math.cos( Math.toRadians(angle)) *radius))&0xff;
                int sin = (((int)(-Math.sin( Math.toRadians(angle)) *radius))&0xff);
                builder.append(" ").append("db ").append("$").append(String.format("%02X",cos)).append(", $").append(String.format("%02X",sin)).append(" ; degrees: ").append((int)anglePrint).append("° ("+i+")\n");
                angle -= adds;
                anglePrint += adds;
                if (angle <0) angle+=360;
            }
        
        stopColoring();
        try
        {
            jTextPane1.getDocument().insertString(popUpTextPos, builder.toString(), null);
            correctLineNumbers(false);
        }
        catch (Throwable e)
        {
            
        }
        
        startColoring();

    }//GEN-LAST:event_jMenuItem5ActionPerformed
    int getCurrentLineNumber()
    {
        return getLineOfPos(jTextPane1.getCaretPosition());
    }
    // returns the line number of the given position
    int getLineOfPos(int pos)
    {
        return getLineOfPos(jTextPane1, pos);
    }
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
    public int getPosOfLineStart(int line, JTextPane jTextPane)
    {
        int pos = 0;
        try
        {
            String[] lines = jTextPane.getDocument().getText(0, jTextPane.getDocument().getLength()).split("\n");
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
    private javax.swing.JMenu jMenu1;
    private javax.swing.JMenu jMenu3;
    private javax.swing.JMenuItem jMenuItem1;
    private javax.swing.JMenuItem jMenuItem2;
    private javax.swing.JMenuItem jMenuItem3;
    private javax.swing.JMenuItem jMenuItem4;
    private javax.swing.JMenuItem jMenuItem5;
    private javax.swing.JMenuItem jMenuItemAddAnim;
    private javax.swing.JMenuItem jMenuItemAddVectorlist;
    private javax.swing.JMenuItem jMenuItemWatchBinary;
    private javax.swing.JMenuItem jMenuItemWatchByte;
    private javax.swing.JMenuItem jMenuItemWatchBytePair;
    private javax.swing.JMenuItem jMenuItemWatchSequence;
    private javax.swing.JMenuItem jMenuItemWatchString;
    private javax.swing.JMenuItem jMenuItemWatchWord;
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
        openEditorMap.remove(filename.toLowerCase());
        filename = fn;
        openEditorMap.put(filename.toLowerCase(), this);
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
        // pretty print and to assi
    }

     public void setFilename(String ff) 
     {
        openEditorMap.remove(this.filename.toLowerCase());
        this.filename = ff;
        openEditorMap.put(filename.toLowerCase(), this);
        
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
            if (startPos<0) 
            {
                // start from top again
                if (startSearchPos>1)
                {
                    startSearchPos = 0;
                    text = jTextPane1.getDocument().getText(0, jTextPane1.getDocument().getLength()).substring(startSearchPos);
                    if (ignoreCase) text = text.toLowerCase();
                    startPos = text.indexOf(toSearch);
                    if (startPos<0) 
                    {
                        return false;
                    }
                    parent.wrapped = true;
                }
            }

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
            if (startPos<0) 
            {
                text = jTextPane1.getDocument().getText(0, jTextPane1.getDocument().getLength());
                if (ignoreCase) text = text.toLowerCase();
                startPos = text.lastIndexOf(toSearch);
                if (startPos<0) return false;
                parent.wrapped = true;
            }

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
    public boolean replaceNext(String toSearch, String replacement, boolean ignoreCase, boolean singleReplace, boolean isLocked)
    {
        try
        {
            int startSearchPos = jTextPane1.getCaretPosition();
            if (ignoreCase) toSearch = toSearch.toLowerCase();
            String text = jTextPane1.getDocument().getText(0, jTextPane1.getDocument().getLength()).substring(startSearchPos);
            if (ignoreCase) text = text.toLowerCase();
            int startPos = text.indexOf(toSearch);
            if (startPos<0) return false;

            if (!isLocked)
            {
                synchronized (editorPaneDocument.getDocumentLock())
                {
                    jTextPane1.setSelectionStart(startPos+startSearchPos);
                    jTextPane1.setSelectionEnd(startPos+startSearchPos+toSearch.length());
                    jTextPane1.replaceSelection(replacement);
                }
            }
            else
            {
                jTextPane1.setSelectionStart(startPos+startSearchPos);
                jTextPane1.setSelectionEnd(startPos+startSearchPos+toSearch.length());
                jTextPane1.replaceSelection(replacement);
            }
          //  System.gc();
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
        int startSearchPos = jTextPane1.getCaretPosition();
        jTextPane1.setCaretPosition(0);
        stopColoring();
        synchronized (editorPaneDocument.getDocumentLock())
        {
            boolean found = false;
            do
            {
                count++;
                found = replaceNext(toSearch, replacement, ignoreCase, false, true);
            } while (found);
        }
        startColoring();
        jTextPane1.setCaretPosition(startSearchPos);
                
        return count;
    }    
    public int replaceSel(String toSearch, String replacement, boolean ignoreCase, int start, int end, boolean isLocked)
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

            if (!isLocked)
            {
                synchronized (editorPaneDocument.getDocumentLock())
                {
                    jTextPane1.setSelectionStart(startPos+startSearchPos);
                    jTextPane1.setSelectionEnd(startPos+startSearchPos+toSearch.length());
                    jTextPane1.replaceSelection(replacement);
                    jTextPane1.requestFocusInWindow();
                }
            }
            else
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
    int selStart = 0;
    int selEnd = 0;
    public boolean hasSelection()
    {
        int start = jTextPane1.getSelectionStart();
        int end = jTextPane1.getSelectionEnd();
        return ( end-start )!= 0;
    }
    public void saveSelection()
    {
        selStart = jTextPane1.getSelectionStart();
        selEnd = jTextPane1.getSelectionEnd();
    }
    public void restoreSelection()
    {
        jTextPane1.setSelectionStart(selStart);
        jTextPane1.setSelectionEnd(selEnd);
        
    }
    
    public int replaceInSelection(String toSearch, String replacement, boolean ignoreCase)
    {
        int start = jTextPane1.getSelectionStart();
        int startOrg = start;
        int end = jTextPane1.getSelectionEnd();
        int count = -1;
        
        stopColoring();
        
        jTextPane1.setCaretPosition(start);
        synchronized (editorPaneDocument.getDocumentLock())
        {
            do
            {
                count++;
                start = replaceSel(toSearch, replacement, ignoreCase, start, end, true);
            } while (start>0);
        }
        startColoring();
        jTextPane1.setCaretPosition(startOrg);
        jTextPane1.setSelectionStart(startOrg);
        jTextPane1.setSelectionEnd(end);
        jTextPane1.requestFocusInWindow();
        return count;
    }    
    public void reColor()
    {
        editorPaneDocument.colorAll();
    }
    public void reColorDirect()
    {
        editorPaneDocument.stopColoring();
        editorPaneDocument.startColoring();
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
            tinyLog.printMessage("Saving file: "+ filename);
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
            tinyLog.printMessage("Saving file: "+ getFilename());
            if (saveAs)
                parent.changeFileName(oldFilename, newFilename);
            resetCRC();
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
    String getTABString()
    {
        String tab="";
        for (int i=0;i<config.tab_width; i++) tab +=" ";
        return tab;
    }

    AbstractAction tabAction = new AbstractAction()
    {
        @Override
        public void actionPerformed(ActionEvent e)
        {
            try
            {
                String TAB_STRING = getTABString();
                int start = jTextPane1.getSelectionStart();
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
                String TAB_STRING = getTABString();
                int start = jTextPane1.getSelectionStart();
                int end = jTextPane1.getSelectionEnd();
                boolean startEQEnd = start==end;
                if (start != end) end--;
                stopColoring();

                // now, sub for every line in selection one TAB from start!
                int first = getLineOfPos(jTextPane1, start);
                int last = getLineOfPos(jTextPane1, end);
                
                int myLine = getLineOfPos(jTextPane1, jTextPane1.getCaretPosition());
                int myPos = jTextPane1.getCaretPosition();
                boolean myPosIsStart = myPos==start;
                
                
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
                
                
                if (startEQEnd)
                    jTextPane1.setSelectionStart(end);
                else
                    jTextPane1.setSelectionStart(start);
                jTextPane1.setSelectionEnd(end);
                
//                jTextPane1.setCaretPosition(getPosOfLineStart(myLine));
                
                
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
    public void fireEditorChanged(int type, int line)
    {
        super.fireEditorChanged(type, line);
    }
    void updateMyUI()
    {
        SwingUtilities.updateComponentTreeUI(jPopupMenu1);
        correctLineNumbers(true);
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
    public void correctLineNumbers(boolean force)
    {
        try
        {
            AttributeSet normal = TokenStyles.getStyle("comment");
            AttributeSet bookmark = TokenStyles.getStyle("bookmark");
            AttributeSet breakpoint = TokenStyles.getStyle("breakpoint");
            int lineCountOrg = getLineCount(jTextPane1);
            int lineCountNow = getLineCount(jTextPane2);

            
            if (lineCountOrg>lineCountNow)
            {
                breakPointLineAdded();
            }
            else if (lineCountOrg<lineCountNow)
            {
                breakPointLineDeleted();
            }
            
            if  ((lineCountNow >lineCountOrg) || (force))
            {
                lineCountNow = 0;
            }
            int w = 3;
            if (lineCountOrg>999) w= 4;
            if (lineCountOrg>9999) w= 5;
            if (lineCountOrg>99999) w= 6;
            
            int lineNumberWidth = ((StyleConstants.getFontSize(normal)-1)*w);

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
            DebugCommentList list = null;
            if (parent instanceof VediPanel)
            {
                VediPanel vedi = (VediPanel) parent;
                list = vedi.getDebugComments(this);
            }
            if ((lineCountNow == 0) && (!force))
            {
                // build textString first
                StringBuilder sb = new StringBuilder();
                while (lineCountNow <lineCountOrg)
                {
                    lineCountNow++;
                    if (lineCountNow==1)
                        sb.append(""+(lineCountNow));
                    else
                        sb.append("\n"+(lineCountNow));

                }            
                jTextPane2.setText(sb.toString());

                doc.setCharacterAttributes(0, doc.getLength(), normal, true);

                // now do breakpoints
                lineCountNow = 0;
                int pos = 0;
                while (lineCountNow <lineCountOrg)
                {
                    if (list!=null)
                    {
                        if (list.getBreakpoint(lineCountNow) != null)
                        {
                            correctLine(lineCountNow);
                        }
                    }
                    lineCountNow++;
                }
                
                
            }
            else
            {
                if ((lineCountNow == 0) || (force))
                {
                    jTextPane2.setText("");
                }
                if (lineCountNow == -1) 
                    lineCountNow = 0;
                while (lineCountNow <lineCountOrg)
                {
                    AttributeSet currentStyle =  normal;
                    if (hasBookmark(lineCountNow, getFilename()))
                    {
                        currentStyle = bookmark;
                    }
                    if (list!=null)
                    {
                        if (list.getBreakpoint(lineCountNow) != null)
                            currentStyle = breakpoint;
                    }
                    
                    lineCountNow++;



                    if (lineCountNow==1)
                        doc.insertString(jTextPane2.getDocument().getLength(), ""+(lineCountNow), currentStyle);
                    else
                        doc.insertString(jTextPane2.getDocument().getLength(), "\n"+(lineCountNow), currentStyle);
                }                

            }

        }
        catch (Throwable e)
        {
            log.addLog("LineNumbers (bp1):\n"+de.malban.util.Utility.getStackTrace(e), INFO);
        }



        

        
        
        
        
        
        

        

        syncViewports();
    }
    
    void syncViewports()
    {
        JViewport viewport = jScrollPane2.getViewport();
        Point p = viewport.getViewPosition();
        
        JViewport viewport2 = (JViewport)jScrollPane1.getViewport();
        p.x=0;
        if (viewport2 == null) return;
        if (viewport2 instanceof CSAViewport)
            ((CSAViewport)viewport2).setViewPositionCSA(p);                
        else
            viewport2.setViewPosition(p);                
    }
    Point vpSave = new Point(0,0);
    void saveViewportPos()
    {
        JViewport viewport = jScrollPane2.getViewport();
        vpSave = viewport.getViewPosition();
    }
    void restoreViewportPos()
    {
        JViewport viewport = jScrollPane2.getViewport();
        viewport.setViewPosition(vpSave);
        syncViewports();
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
    void addWatch(int pos, int type, int param)
    {
        String word = getWordOfPos(jTextPane1, popUpTextPos);
        if (parent instanceof VediPanel)
        {
            VediPanel vedi = (VediPanel) parent;
            DebugCommentList list = vedi.getDebugComments(this);
            list.addWatchComment(word, type, param);
        }
        updateParentTables();        
    }
    
    // line is zero based
    private void toggleBreakpoint(int line)
    {
        if (parent instanceof VediPanel)
        {
            VediPanel vedi = (VediPanel) parent;
            DebugCommentList list = vedi.getDebugComments(this);
            DebugComment dbc = list.getBreakpoint(line);
            if (dbc != null)
            {
                list.removeComment(dbc);
            }
            else
            {
                list.addBreakComment(line);
            }
            
            correctLine(line);
        }
        updateParentTables();
    }

    void breakPointLineAdded()
    {
        if (parent instanceof VediPanel)
        {
            VediPanel vedi = (VediPanel) parent;
            DebugCommentList dbclist = vedi.getDebugComments(this);
            int currentLine = getLineOfPos(jTextPane1, jTextPane1.getCaretPosition());
            ArrayList<DebugComment> list = dbclist.getList();
            for (DebugComment dbc: list)
            {
                if (dbc.beforLineNo>=currentLine)
                {
                    if (!inSetup)
                        dbc.beforLineNo++;
                    correctLine(dbc.beforLineNo-1);
                    correctLine(dbc.beforLineNo);
                }
            }
        }
        updateParentTables();
    }
    void breakPointLineDeleted()
    {
        if (parent instanceof VediPanel)
        {
            VediPanel vedi = (VediPanel) parent;
            DebugCommentList dbclist = vedi.getDebugComments(this);
            int currentLine = getLineOfPos(jTextPane1, jTextPane1.getCaretPosition());
            ArrayList<DebugComment> list = dbclist.getList();
            for (DebugComment dbc: list)
            {
                if (dbc.beforLineNo>currentLine)
                {
                    dbc.beforLineNo--;
                    correctLine(dbc.beforLineNo+1);
                    correctLine(dbc.beforLineNo);
                }
            }
        }
        updateParentTables();
    }
    public void updateParentTables()
    {
        if (parent instanceof VediPanel)
        {
            VediPanel vedi = (VediPanel) parent;
            vedi.updateTables();
        }        
    }

    private void initDebugDisplay()
    {
        SwingUtilities.invokeLater(new Runnable() {

            @Override
            public void run() 
            {
                if (!(parent instanceof VediPanel)) return;
                if (!assume6809Asm) return;

                DebugCommentList list = null;
                if (parent instanceof VediPanel)
                {
                    VediPanel vedi = (VediPanel) parent;
                    list = vedi.getDebugComments(EditorPanel.this);
                }
                if (list != null)
                {
                    for (DebugComment c : list.getList())
                    {
                        correctLine(c.beforLineNo);
                    }
                }

                Set entries = parent.settings.bookmarks.entrySet();
                Iterator it = entries.iterator();
                while (it.hasNext())
                {
                    Map.Entry entry = (Map.Entry) it.next();
                    Bookmark bm = (Bookmark) entry.getValue();
                    int lineNumber = bm.lineNumber;
                    String filename = bm.fullFilename;
                    if (filename.equals(getFilename()))
                    {
                        correctLine(lineNumber);
                    }

                }        
            }
        });
    }
    
    // ypixel in editor - NOT line number related!!!
    public int getPosition()
    {
        JViewport viewport = jScrollPane2.getViewport();
        Point p = viewport.getViewPosition();
        return p.y;
    }
    
    public void setPosition(int _y)
    {
        SwingUtilities.invokeLater(new Runnable()
        {
            public void run()
            {
                JViewport viewport = jScrollPane2.getViewport();
                Point p = viewport.getViewPosition();
                p.y = _y;
                p.x = 0;
                viewport.setViewPosition(p);                
                viewport = jScrollPane1.getViewport();
                viewport.setViewPosition(p);        

                jScrollPane2.invalidate();
                jScrollPane2.validate();
                jScrollPane2.repaint();
                jScrollPane1.invalidate();
                jScrollPane1.validate();
                jScrollPane1.repaint();
            }
        });                    
        
    }

    // line is zero based
    void correctLine(int line)
    {
        try
        {
            AttributeSet normal = TokenStyles.getStyle("comment");
            AttributeSet breakpoint = TokenStyles.getStyle("breakpoint");
            int lineCountOrg = getLineCount(jTextPane1);
            int lineCountNow = 0;
//            jTextPane2.setText("");

            DebugCommentList list = null;
            if (parent instanceof VediPanel)
            {
                VediPanel vedi = (VediPanel) parent;
                list = vedi.getDebugComments(this);
            }
            DefaultStyledDocument doc = (DefaultStyledDocument)jTextPane2.getDocument();
            int pos = 0;
            while (lineCountNow <lineCountOrg)
            {
                AttributeSet currentStyle =  normal;
                if (list!=null)
                {
                    if (list.getBreakpoint(lineCountNow) != null)
                        currentStyle = breakpoint;
                }

                
                lineCountNow++;
                String num; 
                if (lineCountNow==1)
                    num = ""+(lineCountNow);
                else
                    num = "\n"+(lineCountNow);
                
                if (line+1 != lineCountNow)
                {
                    pos += num.length();
                    continue;
                }
                doc.setCharacterAttributes(pos, num.length(), currentStyle, true);
                break;
            }
        }
        catch (Throwable e)
        {
log.addLog("Correct Line (bp):\n"+de.malban.util.Utility.getStackTrace(e), INFO);
        }
        
        String name = getFilename();
        try
        {
            AttributeSet normal = TokenStyles.getStyle("comment");
            AttributeSet bookmark = TokenStyles.getStyle("bookmark");
            int lineCountOrg = getLineCount(jTextPane1);
            int lineCountNow = 0;
//            jTextPane2.setText("");

            DefaultStyledDocument doc = (DefaultStyledDocument)jTextPane2.getDocument();
            int pos = 0;
            while (lineCountNow <lineCountOrg)
            {
                AttributeSet currentStyle =  normal;

                lineCountNow++;
                String num; 
                if (lineCountNow==1)
                    num = ""+(lineCountNow);
                else
                    num = "\n"+(lineCountNow);
                
                if (line+1 != lineCountNow)
                {
                    pos += num.length();
                    continue;
                }

                if (hasBookmark(lineCountNow-1, name))
                {
                    currentStyle = bookmark;
                    doc.setCharacterAttributes(pos, num.length(), currentStyle, true);
                }
                return;
            }
        }
        catch (Throwable e)
        {
log.addLog("Correct Line (bm):\n"+de.malban.util.Utility.getStackTrace(e), INFO);
        }
    }
    
    boolean hasBookmark(int line, String name)
    {
        Set entries = parent.settings.bookmarks.entrySet();
        Iterator it = entries.iterator();
        line++;
        while (it.hasNext())
        {
            Map.Entry entry = (Map.Entry) it.next();
            Bookmark bm = (Bookmark) entry.getValue();
            int lineNumber = bm.lineNumber;
            String filename = bm.fullFilename;
            if (name.endsWith(filename))
            {
                if (line == lineNumber)
                    return true;
            }
        }        
        return false;
    }
    
    
    CRC32 loadCRC32 = new CRC32();
    public void resetCRC()
    {
        String s = getText();
        loadCRC32 = new CRC32();
        for (int i=0; i<s.length(); i++)
            loadCRC32.update(s.charAt(i));
    }
    public boolean hasChanged()
    {
        String s = getText();
        CRC32 localCRC32 = new CRC32();
        for (int i=0; i<s.length(); i++)
            localCRC32.update(s.charAt(i));
        
        long org = loadCRC32.getValue();
        long now = localCRC32.getValue();
        
        return !(org == now);
    }
    
}

