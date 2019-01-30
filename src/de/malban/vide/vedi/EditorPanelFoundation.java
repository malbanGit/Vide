/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vedi;

import de.malban.vide.VideConfig;
import java.awt.Color;
import java.awt.Rectangle;
import java.awt.event.ActionEvent;
import java.util.ArrayList;
import javax.swing.AbstractAction;
import javax.swing.Action;
import javax.swing.SwingUtilities;
import javax.swing.UIManager;
import javax.swing.event.CaretEvent;
import javax.swing.event.CaretListener;
import javax.swing.event.DocumentEvent;
import javax.swing.event.UndoableEditEvent;
import javax.swing.event.UndoableEditListener;
import javax.swing.text.AbstractDocument;
import javax.swing.text.DefaultCaret;
import javax.swing.text.DefaultHighlighter;
import javax.swing.text.Highlighter;
import javax.swing.text.JTextComponent;
import javax.swing.undo.CannotRedoException;
import javax.swing.undo.CannotUndoException;
import javax.swing.undo.CompoundEdit;
import javax.swing.undo.UndoManager;
import javax.swing.undo.UndoableEdit;

/**
 *
 * @author malban
 */
public class EditorPanelFoundation extends javax.swing.JPanel {

  // see: https://tips4java.wordpress.com/2009/01/25/no-wrap-text-pane/
        /**
     *  Simple class to ensure that the caret is visible within the viewport
     *  of the scrollpane. This is the normal situation. However, I've noticed
     *  that solutions that attempt to turn a text pane into a non wrapping
     *  text pane will result in the caret not being visible when adding text
     *  to the right edge of the viewport.
     *
     *  In general, this class can be used any time you wish to increase the number
     *  of visible pixels after the caret on the right edge of a scroll pane.
     */
    public static class VisibleCaretListener implements CaretListener
    {
        private int visiblePixels;

        /**
         *  Convenience constructor to create a VisibleCaretListener using
         *  the default value for visible pixels, which is set to 2.
         */
        public VisibleCaretListener()
        {
                this(2);
        }

        /**
         *  Create a VisibleCaretListener.
         *
         *  @param pixels the number of visible pixels after the caret.
         */
        public VisibleCaretListener(int visiblePixels)
        {
            setVisiblePixels( visiblePixels );
        }

        /**
         *  Get the number of visble pixels displayed after the Caret.
         *
         *  @return the number of visible pixels after the caret.
         */
        public int getVisiblePixels()
        {
            return visiblePixels;
        }

        /**
         *  Control the number of pixels that should be visible in the viewport
         *  after the caret position.
         *
         *  @param pixels the number of visible pixels after the caret.
         */
        public void setVisiblePixels(int visiblePixels)
        {
            this.visiblePixels = visiblePixels;
        }
//
//	Implement CaretListener interface
//
        public void caretUpdate(final CaretEvent e)
        {
            //  Attempt to scroll the viewport to make sure Caret is visible

            SwingUtilities.invokeLater(new Runnable()
            {
                public void run()
                {
                    try
                    {
                    JTextComponent component = (JTextComponent)e.getSource();
                    int position = component.getCaretPosition();
                    Rectangle r = component.modelToView(position);
                    r.x += visiblePixels;
                    component.scrollRectToVisible(r);
                    }
                    catch(Exception ble) {}
                }
            });
        }
    }
    
    // see: http://docs.oracle.com/javase/tutorial/uiswing/components/generaltext.html
    //  https://code.google.com/archive/p/jsyntaxpane/
    // http://alvinalexander.com/java/java-undo-redo

    // see: https://tips4java.wordpress.com/2008/10/27/compound-undo-manager/
    // compound -> all attribute changes are collected to last "real" change
    class CompoundUndoManager extends UndoManager implements UndoableEditListener
    {
	private CompoundEdit compoundEdit;
	/*
	**  Whenever an UndoableEdit happens the edit will either be absorbed
	**  by the current compound edit or a new compound edit will be started
	*/
	public void undoableEditHappened(UndoableEditEvent e)
	{
            //  Check for an attribute change
            // java 10 uses a wrapper for AbstractDocument.DefaultDocumentEvent
            // and thus can not access AbstractDocument.DefaultDocumentEvent directly
            // (without breaking Java 1.8 code)
            // thus in java 10 for now
            // all "style" events are also undoable :-/ 
            
//            UIManager.getString("AbstractDocument.additionText");
            

//        System.out.println("Presentation:"+e.getEdit().getPresentationName()+" = "+compareString);
            if (e.getEdit() instanceof AbstractDocument.DefaultDocumentEvent)
            {
                AbstractDocument.DefaultDocumentEvent event = (AbstractDocument.DefaultDocumentEvent)e.getEdit();

                // style
                if  (event.getType().equals(DocumentEvent.EventType.CHANGE))
                {
                    if (compoundEdit == null) return;
                    compoundEdit.addEdit(e.getEdit() );
                    return;
                }
            }
            else
            {
                // Java 10?
                String compareString =UIManager.getString("AbstractDocument.styleChangeText");
                if (e.getEdit().getPresentationName().equals(compareString))
                {
//        System.out.println("Presentation:"+e.getEdit().getPresentationName()+" = "+compareString);
                    if (compoundEdit == null) return;
                    compoundEdit.addEdit(e.getEdit() );
                    return;
                }
            }

            //  Start a new compound edit
            if (compoundEdit == null)
            {
                    compoundEdit = startCompoundEdit( e.getEdit() );
                    return;
            }

            //  Not incremental edit, end previous edit and start a new one
            compoundEdit.end();
            compoundEdit = startCompoundEdit( e.getEdit() );                

	}
	/*
	**  Each CompoundEdit will store a group of related incremental edits
	**  (ie. each character typed or backspaced is an incremental edit)
	*/
	private CompoundEdit startCompoundEdit(UndoableEdit anEdit)
	{
            //  The compound edit is used to store incremental edits
            compoundEdit = new MyCompoundEdit();
            compoundEdit.addEdit( anEdit );

            //  The compound edit is added to the UndoManager. All incremental
            //  edits stored in the compound edit will be undone/redone at once

            addEdit( compoundEdit );

            undoAction.update();
            redoAction.update();

            return compoundEdit;
	}        
        class MyCompoundEdit extends CompoundEdit
        {
            public boolean isInProgress()
            {
                //  in order for the canUndo() and canRedo() methods to work
                //  assume that the compound edit is never in progress

                return false;
            }

            public void undo() throws CannotUndoException
            {
                //  End the edit so future edits don't get absorbed by this edit
                if (compoundEdit != null) compoundEdit.end();
                super.undo();

                //  Always start a new compound edit after an undo
                compoundEdit = null;
            }
        }
    }
    
    protected CompoundUndoManager undoManager = new CompoundUndoManager() ;
    protected UndoAction undoAction;
    protected RedoAction redoAction;  
    private ArrayList<EditorListener> mListener= new ArrayList<EditorListener>();
    public void addEditorListener(EditorListener listener)
    {
        mListener.remove(listener);
        mListener.add(listener);
    }

    public void removeEditorListener(EditorListener listener)
    {
        mListener.remove(listener);
    }
    public void fireEditorChanged(int type, int line)
    {
        EditorEvent e = new EditorEvent();
        e.type = type;
        e.line = line;
        e.source = this;
        for (int i=0; i<mListener.size(); i++)
        {
            mListener.get(i).editorChanged(e);
        }
    }
    // java undo and redo action classes
    class UndoAction extends AbstractAction
    {
        public UndoAction()
        {
          super("Undo");
          setEnabled(false);
        }

        public void actionPerformed(ActionEvent e)
        {
          try
          {
              undoManager.undo();
            
            fireEditorChanged(EditorEvent.EV_TEXT_UNDO, -1);
          }
          catch (CannotUndoException ex)
          {
            // TODO deal with this
            //ex.printStackTrace();
          }
          update();
          redoAction.update();
        }

        protected void update()
        {
          if (undoManager.canUndo())
          {
            setEnabled(true);
            putValue(Action.NAME, undoManager.getUndoPresentationName());
          }
          else
          {
            setEnabled(false);
            putValue(Action.NAME, "Undo");
          }
            editActionChanged();
        }
    }

    class RedoAction extends AbstractAction
    {
        public RedoAction()
        {
          super("Redo");
          setEnabled(false);
        }

        public void actionPerformed(ActionEvent e)
        {
          try
          {
            undoManager.redo();
           fireEditorChanged(EditorEvent.EV_TEXT_REDO, -1);
          }
          catch (CannotRedoException ex)
          {
            // TODO deal with this
            ex.printStackTrace();
          }
          update();
          undoAction.update();
        }

        protected void update()
        {
          if (undoManager.canRedo())
          {
            setEnabled(true);
            putValue(Action.NAME, undoManager.getRedoPresentationName());
          }
          else
          {
            setEnabled(false);
            putValue(Action.NAME, "Redo");
          }
             editActionChanged();
        }
    }    
    public void undo()
    {
        if (VideConfig.editorUndoEnabled)
            undoAction.actionPerformed(null);
    }
    public void redo()
    {
        if (VideConfig.editorUndoEnabled)
            redoAction.actionPerformed(null);
    }
    public boolean canUndo()
    {
        if (!VideConfig.editorUndoEnabled) return false;
        return undoManager.canUndo();
    }
    public boolean canRedo()
    {
        if (!VideConfig.editorUndoEnabled) return false;
        return undoManager.canRedo();
    }

    /**
     * Creates new form EditorPanelFoundation
     */
    public EditorPanelFoundation() {
        initComponents();
        if (VideConfig.editorUndoEnabled)
        {
            undoAction = new UndoAction();
            redoAction = new RedoAction(); 
            undoManager.setLimit(1000);
        }
    }

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        setPreferredSize(null);

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 400, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 300, Short.MAX_VALUE)
        );
    }// </editor-fold>//GEN-END:initComponents


    // Variables declaration - do not modify//GEN-BEGIN:variables
    // End of variables declaration//GEN-END:variables

    // see: http://stackoverflow.com/questions/18237317/how-to-retain-selected-text-in-jtextfield-when-focus-lost
    protected static final Highlighter.HighlightPainter unfocusedPainter = new DefaultHighlighter.DefaultHighlightPainter(new Color(43,107,197,255));
    protected static final Highlighter.HighlightPainter focusedPainter = new DefaultHighlighter.DefaultHighlightPainter(new Color(43,107,197,255));
    protected class HighlightCaret extends DefaultCaret 
    {

        private static final long serialVersionUID = 1L;
        private boolean isFocused;

        @Override
        protected Highlighter.HighlightPainter getSelectionPainter() {
            setBlinkRate(500); // otherwise is disabled, stopped
            return isFocused ? focusedPainter/*super.getSelectionPainter()*/ : unfocusedPainter;
        }

        @Override
        public void setSelectionVisible(boolean hasFocus) {
            if (hasFocus != isFocused) {
                isFocused = hasFocus;
                super.setSelectionVisible(false);
                super.setSelectionVisible(true);
            }
        }
    }
    protected void editActionChanged()
    {
        
    }

    

}
