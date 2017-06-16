/*
 * This file is part of the programmer editor demo
 * Copyright (C) 2001-2005 Stephen Ostermiller
 * http://ostermiller.org/contact.pl?regarding=Syntax+Highlighting
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * See COPYING.TXT for details.
 */
package de.malban.util.syntax.Syntax;

import de.malban.config.Configuration;
import de.malban.gui.panels.LogPanel;
import static de.malban.gui.panels.LogPanel.WARN;
import java.io.IOException;
import java.lang.ref.WeakReference;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.NoSuchElementException;
import java.util.SortedSet;
import java.util.TreeSet;

import javax.swing.text.AttributeSet;

import de.malban.util.syntax.Syntax.Lexer.Lexer;
import de.malban.util.syntax.Syntax.Lexer.Token;
import de.malban.vide.vedi.VediPanel;
import java.util.ArrayList;
import javax.swing.SwingUtilities;

/**
 * Run the Syntax Highlighting as a separate thread. Things that need to be
 * colored are messaged to the thread and put in a list.
 */
class Colorer extends Thread 
{
    LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
    /**
     * A simple wrapper representing something that needs to be colored. Placed
     * into an object so that it can be stored in a Vector.
     */
     static int uid_base=0;
     int uid = uid_base++;
     int colorDelay = 0;

    private static class RecolorEvent
    {
        public int position;
        public int adjustment;
        public boolean allowReset=true;
        public boolean all = false;
        String whereFrom = "";

        public RecolorEvent(int position, int adjustment) 
        {
            this.position = position;
            this.adjustment = adjustment;
        }
        public RecolorEvent(int position, int adjustment, boolean ar) 
        {
            this.position = position;
            this.adjustment = adjustment;
            allowReset = ar;
        }
    }
    private boolean mBreak=true;
    /**
     * Stores the document we are coloring. We use a WeakReference
     * so that the document is eligible for garbage collection when
     * it is no longer being used. At that point, this thread will
     * shut down itself.
     */
    private WeakReference document;

    /**
     * Keep a list of places in the file that it is safe to restart the
     * highlighting. This happens whenever the lexer reports that it has
     * returned to its initial state. Since this list needs to be sorted and
     * we need to be able to retrieve ranges from it, it is stored in a
     * balanced tree.
     */
    private TreeSet iniPositions = new TreeSet(DocPositionComparator.instance);

    /**
     * As we go through and remove invalid positions we will also be finding
     * new valid positions. Since the position list cannot be deleted from
     * and written to at the same time, we will keep a list of the new
     * positions and simply add it to the list of positions once all the old
     * positions have been removed.
     */
    private HashSet newPositions = new HashSet();

    /**
     * Vector that stores the communication between the two threads.
     */
    private volatile LinkedList events = new LinkedList();

    /**
     * When accessing the linked list, we need to create a critical section.
     * we will synchronize on this object to ensure that we don't get unsafe
     * thread behavior.
     */
    private final Object eventsLock = new Object();

    /**
     * The amount of change that has occurred before the place in the
     * document that we are currently highlighting (lastPosition).
     */
    private volatile int change = 0;

    /**
     * The last position colored
     */
    private volatile int lastPosition = -1;

    /**
     * Creates the coloring thread for the given document.
     * 
     * @param document The document to be colored.
     */
    public Colorer(HighlightedDocument document) 
    {
        this.setName("Colorer I will never die "+uid+"!");
        this.document = new WeakReference(document);
        this.setPriority(2); // normal is 5, max is 10 , min is 1
    }
    boolean doNotTryToStart = false;
    public void stopIt()
    {
        doNotTryToStart = true;
        if (mBreak) return;
        synchronized (eventsLock)
        {
            mBreak=true;
            this.interrupt();
            eventsLock.notifyAll();
        }
        try
        {
            while (!broken) 
            {
//System.out.println("Thread unbroken: " + this);
                Thread.sleep(10);
            }

        }
        catch (Throwable e)
        {

        }
    }
    // avoid lots and lots of recolors
    // in case of e.g. many undos redos
    public void colorAll() 
    {
        if (!isStarted()) return;
        try
        {
            HighlightedDocument doc = (HighlightedDocument) document.get();
            if(doc == null) return;
            color(0, doc.getLength(), false);
        }
        catch (Throwable ex)
        {


        }
    }
    // coloring within thread of caller!
    public void colorAllDirect() 
    {
        HighlightedDocument doc = (HighlightedDocument) document.get();
        
        if(doc == null) return;
        boolean old = mBreak;
        if (old == false)
            System.out.println("Strange");

        // process label changes "by hand"
        // since in process event we color here without vars!
        try
        {
            ArrayList<String> changedVars = doc.fileInfo.processDocumentChanges(0, doc.getLength(), doc.getText(0, doc.getLength()));
        }
        catch (Throwable e)
        {
           // e.printStackTrace();
        }

        // process event runs usually WITHIN
        // the thread
        // and checks for mBreak
        // here we are "out" of the thread and we must
        // simulate that we are in the thread
        // temporarily set mBreak to false
        // so that the process event actually DOES something!
        mBreak = false;
        processEvent(0, doc.getLength(), false);            
        events.clear();
        mBreak = old;
    }
    public void color(int position, int adjustment) 
    {
        color( position,  adjustment, true) ;
    }
    public void colordbg(int position, int adjustment) 
    {
        color( position,  adjustment, false) ;
    }
    public boolean isStarted()
    {
        return !mBreak && !broken;
    }
    boolean started = false;
    @Override
    public void start()
    {
        SwingUtilities.invokeLater(new Runnable(){
        
            @Override
            public void run()
            {
                synchronized (Colorer.this)
                {
                    if (!started)
                    {
                        // an init error occured in editor setup
                        // and the already initiated start has to be abondened
                        if (!doNotTryToStart)
                        {
                            started = true;
                            mBreak = false;
                            Colorer.super.start();
                        }

                    }
                }
            }
        });
    }
    /**
     * Tell the Syntax Highlighting thread to take another look at this
     * section of the document. It will process this as a FIFO. This method
     * should be done inside a docLock.
     */
    private void color(int position, int adjustment, boolean allowReset) 
    {
        if (!isStarted()) return;

//System.out.println("Color > 1, start:"+position+" adjustment: "+adjustment+" allow Recoler: "+allowReset);
        // figure out if this adjustment effects the current run.
        // if it does, then adjust the place in the document
        // that gets highlighted.
        if (position < lastPosition) 
        {
            if (lastPosition < position - adjustment) 
            {
                change -= lastPosition - position;
            } 
            else 
            {
                change += adjustment;
            }
        }
        synchronized (eventsLock) 
        {
            if(!events.isEmpty()) 
            {
                // check whether to coalesce with current last element
                RecolorEvent curLast = (RecolorEvent) events.getLast();
                if(adjustment < 0 && curLast.adjustment < 0) 
                {
                    // both are removals
                    if(position == curLast.position) 
                    {
                        curLast.adjustment += adjustment;
                        return;
                    }
                } 
                else if(adjustment >= 0 && curLast.adjustment >= 0) 
                {
                    // both are insertions
                    if(position == curLast.position + curLast.adjustment) 
                    {
                        curLast.adjustment += adjustment;
                        return;
                    } 
                    else if(curLast.position == position + adjustment) 
                    {
                        curLast.position = position;
                        curLast.adjustment += adjustment;
                        return;
                    }
                }
            }
            RecolorEvent ev = new RecolorEvent(position, adjustment, allowReset);

            //ev.whereFrom = de.malban.util.Utility.getCurrentStackTrace();
            events.add(ev);
            eventsLock.notifyAll();
        }
    }


    /**
     * The colorer runs forever and may sleep for long periods of time. It
     * should be interrupted every time there is something for it to do.
     */
    boolean broken = true;
    @Override
    public void run() 
    {
        broken = false;
        while(!mBreak) 
        {
            try 
            {
                RecolorEvent re=null;
                synchronized (eventsLock) 
                {
                    // get the next event to process - stalling until the
                    // event becomes available
                    while ((events.isEmpty() && document.get() != null) && (!mBreak)) 
                    {
                        // stop waiting after a second in case document
                        // has been cleared.
                        eventsLock.wait(1000);
                    }
                    if (mBreak) continue;
                    if (events.size()>0)
                        re = (RecolorEvent) events.removeFirst();
                    eventsLock.notifyAll();
                }
                if (re != null)
                    processEvent(re.position, re.adjustment, re.allowReset);
            } catch(InterruptedException e) { }

            catch (Throwable ee)
            {
                log.addLog(ee, WARN);
            }
        }
        broken = true;
    }

    private void processEvent(int position, int adjustment, boolean varCheck)
    {
        int tokenCount = 0;
        HighlightedDocument doc = (HighlightedDocument) document.get();
        if(doc == null) return;

        // slurp everything up into local variables in case another
        // thread changes them during coloring process
        AttributeSet globalStyle = doc.getGlobalStyle();
        Lexer syntaxLexer = doc.getSyntaxLexer();
        DocumentReader documentReader = doc.getDocumentReader();
        Object docLock = doc.getDocumentLock(); 

        int start = Math.min(position, position + adjustment);
        int stop = Math.max(position, position + adjustment);
        if(globalStyle != null) 
        {
//System.out.println("Global Style != null");
            synchronized(docLock) 
            {
                doc.setCharacterAttributes(start, stop - start, globalStyle, true);
            }
            return;
        }
        VediPanel.setInScan(true);            

        SortedSet workingSet;
        Iterator workingIt;
        DocPosition startRequest = new DocPosition(position);
        DocPosition endRequest = new DocPosition(position + Math.abs(adjustment));
        DocPosition dp;
        DocPosition dpStart = null;
        DocPosition dpEnd = null;

        // find the starting position. We must start at least one
        // token before the current position
        try 
        {
            // all the good positions before
            workingSet = iniPositions.headSet(startRequest);
            // the last of the stuff before
            dpStart = (DocPosition) workingSet.last();
        } 
        catch (NoSuchElementException x) 
        {
            // if there were no good positions before the requested
            // start,
            // we can always start at the very beginning.
            dpStart = new DocPosition(0);
        }

        // malban
        // scan for macro var changes
        if (varCheck)
        {
            if (doc.fileInfo!=null)
            {
                try
                {
                    ArrayList<String> changedVars = doc.fileInfo.processDocumentChanges(start, adjustment, doc.getText(0, doc.getLength()));
                    if ((changedVars == null)||(changedVars.size()>0))
                    {
                        VediPanel.setInScan(false);            
                        colorAll();
//System.out.println("COLORALL Invoked from event");
                        /*
                        // for now just do the complete damn doc
                        start = 0;
                        adjustment = doc.getLength();
                        System.out.println("do all");
                        processEvent(start, adjustment, false);
                                */
                        return;

                    }
                }
                catch (Throwable e)
                {
            //        e.printStackTrace();
                }

            }                
        }

        // if stuff was removed, take any removed positions off the
        // list.
        if (adjustment < 0) 
        {
            workingSet = iniPositions.subSet(startRequest, endRequest);
            workingIt = workingSet.iterator();
            while (workingIt.hasNext()) 
            {
                workingIt.next();
                workingIt.remove();
            }
        }
        // adjust the positions of everything after the
        // insertion/removal.
        workingSet = iniPositions.tailSet(startRequest);
        workingIt = workingSet.iterator();
        while (workingIt.hasNext()) 
        {
            ((DocPosition) workingIt.next()).adjustPosition(adjustment);
        }

        // now go through and highlight as much as needed
        workingSet = iniPositions.tailSet(dpStart);
        workingIt = workingSet.iterator();
        dp = null;
        if (workingIt.hasNext()) 
        {
            dp = (DocPosition) workingIt.next();
        }
        try 
        {
            Token t;
            boolean done = false;
            dpEnd = dpStart;
            synchronized (docLock) 
            {
                // we are playing some games with the lexer for
                // efficiency.
                // we could just create a new lexer each time here,
                // but instead,
                // we will just reset it so that it thinks it is
                // starting at the
                // beginning of the document but reporting a funny
                // start position.
                // Reseting the lexer causes the close() method on
                // the reader
                // to be called but because the close() method has
                // no effect on the
                // DocumentReader, we can do this.
                syntaxLexer.reset(documentReader, 0, dpStart .getPosition(), 0);
                // After the lexer has been set up, scroll the
                // reader so that it
                // is in the correct spot as well.
                documentReader.seek(dpStart.getPosition());
                // we will highlight tokens until we reach a good
                // stopping place.
                // the first obvious stopping place is the end of
                // the document.
                // the lexer will return null at the end of the
                // document and wee
                // need to stop there.
                t = syntaxLexer.getNextToken();
                tokenCount++;
            }
            newPositions.add(dpStart);
            while ((!done && t != null) && (!mBreak))
            {
                // this is the actual command that colors the stuff.
                // Color stuff with the description of the styles
                // stored in tokenStyles.
                if (t.getCharEnd() <= doc.getLength()) 
                {

                    int sstart = t.getCharBegin()+change;
                    int slen = t.getCharEnd()- t.getCharBegin();
                    AttributeSet saset = TokenStyles.getStyle(t.getDescription());

                    // do undo/redo manager something good,
                    // only add CHANGES (especially in recolor all!)
                    if (didAttributesChange(sstart, slen, saset, doc))
                    {
                        doc.setCharacterAttributes(sstart, slen, saset, true);
                    }

                    // record the position of the last bit of
                    // text that we colored
                    dpEnd = new DocPosition(t.getCharEnd());
                }
                lastPosition = (t.getCharEnd() + change);
                // The other more complicated reason for doing no
                // more highlighting
                // is that all the colors are the same from here on
                // out anyway.
                // We can detect this by seeing if the place that
                // the lexer returned
                // to the initial state last time we highlighted is
                // the same as the
                // place that returned to the initial state this
                // time.
                // As long as that place is after the last changed
                // text, everything
                // from there on is fine already.
                if (t.getState() == Token.INITIAL_STATE) 
                {
                    // look at all the positions from last time that
                    // are less than or
                    // equal to the current position
                    while (dp != null && dp.getPosition() <= t.getCharEnd()) 
                    {
                        if (dp.getPosition() == t.getCharEnd() && dp.getPosition() >= endRequest .getPosition()) 
                        {
                            // we have found a state that is the
                            // same
                            done = true;
                            dp = null;
                        } 
                        else if (workingIt.hasNext()) 
                        {
                            // didn't find it, try again.
                            dp = (DocPosition) workingIt.next();
                        } 
                        else 
                        {
                            // didn't find it, and there is no more
                            // info from last
                            // time. This means that we will just
                            // continue
                            // until the end of the document.
                            dp = null;
                        }
                    }
                    // so that we can do this check next time,
                    // record all the
                    // initial states from this time.
                    newPositions.add(dpEnd);
                }
                synchronized (docLock) 
                {
                    try
                    {
                        t = syntaxLexer.getNextToken();
                        tokenCount++;
                    }
                    catch (Throwable ex)
                    {
                        ex.printStackTrace();
                        VediPanel.setInScan(false);
                        return;
                    }
                }
            }

            // remove all the old initial positions from the place
            // where
            // we started doing the highlighting right up through
            // the last
            // bit of text we touched.
            workingIt = iniPositions.subSet(dpStart, dpEnd) .iterator();
            while (workingIt.hasNext()) 
            {
                workingIt.next();
                workingIt.remove();
            }

            // Remove all the positions that are after the end of
            // the file.:
            workingIt = iniPositions.tailSet( new DocPosition(doc.getLength())).iterator();
            while (workingIt.hasNext()) 
            {
                workingIt.next();
                workingIt.remove();
            }

            // and put the new initial positions that we have found
            // on the list.
            iniPositions.addAll(newPositions);
            newPositions.clear();
        } 
        catch (IOException x) 
        {
        }
        synchronized (docLock) 
        {
            lastPosition = -1;
            change = 0;
        }
        VediPanel.setInScan(false);
//System.out.println("Tokens processed: "+                    tokenCount);

    }
    boolean didAttributesChange(int sstart, int slen, AttributeSet saset, HighlightedDocument doc)
    {
        try
        {
            javax.swing.text.Element element;
            for(int i=sstart; i<sstart+slen;i++) 
            {
                element = doc.getCharacterElement(i);
                AttributeSet attribute = element.getAttributes();   
                if (!attribute.isEqual(saset)) return true;
            }
        }
        catch (Throwable e)
        {
            
        }
        return false;
    }
}
