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
import static de.malban.gui.panels.LogPanel.INFO;
import javax.swing.text.*;

import java.io.*;
import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;

import de.malban.util.syntax.Syntax.Lexer.*;
import de.malban.util.syntax.entities.ASM6809File;
import de.malban.util.syntax.entities.ASM6809FileMaster;
import de.malban.util.syntax.entities.C6809File;
import de.malban.util.syntax.entities.C6809FileMaster;
import de.malban.vide.VideConfig;

/**
 * A <a href="http://ostermiller.org/syntax/editor.html">demonstration text
 * editor</a> that uses syntax highlighting.
 */
public class HighlightedDocument extends DefaultStyledDocument 
{
	public static final Object BASIC_STYLE = BASICLexer.class;
	public static final Object C_STYLE = CLexer.class;
	public static final Object HTML_STYLE = HTMLLexer.class;
	public static final Object HTML_KEY_STYLE = HTMLLexer1.class;
	public static final Object JAVA_STYLE = JavaLexer.class;
	public static final Object JAVASCRIPT_STYLE = JavaScriptLexer.class;
	public static final Object LATEX_STYLE = LatexLexer.class;
	public static final Object PLAIN_STYLE = PlainLexer.class;
	public static final Object PROPERTIES_STYLE = PropertiesLexer.class;
	public static final Object SQL_STYLE = SQLLexer.class;
	public static final Object GRAYED_OUT_STYLE = new Object();
	public static final Object M6809_STYLE = M6809Lexer.class;

        ASM6809File asmFileInfo = null;
        C6809File cFileInfo = null;
        String knownFilename = null;
	/**
	 * A reader wrapped around the document so that the document can be fed into
	 * the lexer.
	 */
	private final DocumentReader documentReader;
	
	/** If non-null, all is drawn with this style (no lexing). */
	private AttributeSet globalStyle = null;

	/**
	 * The lexer that tells us what colors different words should be.
	 */
	private Lexer syntaxLexer;

	/**
	 * A thread that handles the actual coloring.
	 */
	private Colorer colorer;

	/**
	 * A lock for modifying the document, or for actions that depend on the
	 * document not being modified.
	 */
	private final Object docLock = new Object();

        int vediId = -1;
	/**
	 * Create a new Demo
	 */
	public HighlightedDocument(int id) {
            vediId = id;
		// Start the thread that does the coloring
	//	colorer.start();
                // malban, moved thread start to be
                // started seperately,
                // otherwise texts will on start ALLWAYs
                // be colored twice!
                // one on setting the highlighter
                // thread snaps event and starts running
                // two, since event queue is empty upon setting the actual text
                
                if (VideConfig.syntaxHighliteEnabled)
                    colorer = new Colorer(this);
                else
                    colorer = null;

		// create the new document.
		documentReader = new DocumentReader(this);
		syntaxLexer = new JavaLexer(documentReader);
	}
	public HighlightedDocument(int id, String filename) {
            vediId = id;
            knownFilename = filename;
		// Start the thread that does the coloring
	//	colorer.start();
                // malban, moved thread start to be
                // started seperately,
                // otherwise texts will on start ALLWAYs
                // be colored twice!
                // one on setting the highlighter
                // thread snaps event and starts running
                // two, since event queue is empty upon setting the actual text
                
                if (VideConfig.syntaxHighliteEnabled)
                    colorer = new Colorer(this);
                else
                    colorer = null;

		// create the new document.
		documentReader = new DocumentReader(this);
		syntaxLexer = new JavaLexer(documentReader);
	}
        
        public void start()
        {
            start(null);
        }
        // if called with a filename 
        // a m6809 doc is assumed!
        // than a scan of the document and its
        // includes is done to know about macros, labels an includes
        public void start(String filename)
        {
            if (filename != null)
            {
                knownFilename = filename;
                // scans file for includes
                // inserts in "known" list
                // looks for labels and macros
                if  ( filename.toLowerCase().endsWith(".asm")
                    ||filename.toLowerCase().endsWith(".s")
                    ||filename.toLowerCase().endsWith(".template")
                    ||filename.toLowerCase().endsWith(".i")
                    ||filename.toLowerCase().endsWith(".a69")
                    ||filename.toLowerCase().endsWith(".as9")
                    ||filename.toLowerCase().endsWith(".h")
                        )   
                try
                {
                    String text = getText(0, getLength());
                    if (ASM6809FileMaster.getInfo(vediId) == null)
                    {
                        
                    }
                    asmFileInfo = ASM6809FileMaster.getInfo(vediId).handleFile(filename, text);
                }
                catch (Throwable e)
                {
                    LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
                    log.addLog(de.malban.util.Utility.getStackTrace(e), INFO);
                }
                if  ( filename.toLowerCase().endsWith(".c")
                        ||filename.toLowerCase().endsWith(".cxx")
                        ||filename.toLowerCase().endsWith(".c++")
                        ||filename.toLowerCase().endsWith(".h")
                        )   
                try
                {
                    String text = getText(0, getLength());
                    cFileInfo = C6809FileMaster.getInfo(vediId).handleFile(filename, text);
                }
                catch (Throwable e)
                {
                    e.printStackTrace();
                    LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
                    log.addLog(de.malban.util.Utility.getStackTrace(e), INFO);
                }
            }
            // do first coloring NOT in thread, saves us SOME trouble of swing and synchronicity
            if (VideConfig.syntaxHighliteEnabled)
                if (!colorer.isStarted())
                {
                    colorAllDirect();
                    colorer.start();
                }
        }
        public void deinit()
        {
            if (!VideConfig.syntaxHighliteEnabled) return;
            colorer.stopIt();
        }
        public void stopColoring()
        {
            if (!VideConfig.syntaxHighliteEnabled) return;
            colorer.stopIt();
        }
        public void startColoring()
        {
            if (!VideConfig.syntaxHighliteEnabled) return;
            if (colorer != null) colorer.stopIt();
            colorer = new Colorer(this);
            colorAllDirect();
            colorer.start();
        }

	/**
	 * Color or recolor the entire document
	 */
	public void colorAll() 
        {
            if (!VideConfig.syntaxHighliteEnabled) return;
            if (colorer.isStarted())
            {
                colorer.colorAll();
            }
        }
	public void colorAllDirect() 
        {
            if (!VideConfig.syntaxHighliteEnabled) return;
            if (!colorer.isStarted())
            {
                colorer.colorAllDirect();
            }
        }

	/**
	 * Color a section of the document. The actual coloring will start somewhere
	 * before the requested position and continue as long as needed.
	 * 
	 * @param position
	 *            the starting point for the coloring.
	 * @param adjustment
	 *            amount of text inserted or removed at the starting point.
	 */
	public void colordbg(int position, int adjustment) {
            if (!VideConfig.syntaxHighliteEnabled) return;
            if (colorer.isStarted())
                colorer.colordbg(position, adjustment);
	}
	public void color(int position, int adjustment) {
            if (!VideConfig.syntaxHighliteEnabled) return;
            if (colorer.isStarted())
                colorer.color(position, adjustment);
	}
	public void setGlobalStyle(AttributeSet value) {
		globalStyle = value;
	}

	public void setHighlightStyle(Object value) {
	setHighlightStyle(value, false); 
        
        }
	public void setHighlightStyle(Object value, boolean colorAll) {
		if (value == HighlightedDocument.GRAYED_OUT_STYLE) {
			setGlobalStyle(TokenStyles.getStyle("grayedOut"));
			return;
		}

		if (!(value instanceof Class))
			value = HighlightedDocument.PLAIN_STYLE;
		Class source = (Class) value;
		Class[] parms = { Reader.class };
		Object[] args = { documentReader };
		try {
			Constructor cons = source.getConstructor(parms);
			syntaxLexer = (Lexer) cons.newInstance(args);
			globalStyle = null;
                        
                        if (syntaxLexer instanceof M6809Lexer)
                        {
                            ((M6809Lexer)syntaxLexer).setVediId(vediId);
                        }
                        
                        if (colorAll)
                            colorAll();
		} catch (SecurityException e) {
			System.err.println("HighlightEditor.SecurityException");
		} catch (NoSuchMethodException e) {
			System.err.println("HighlightEditor.NoSuchMethod");
		} catch (InstantiationException e) {
			System.err.println("HighlightEditor.InstantiationException");
		} catch (InvocationTargetException e) {
			System.err.println("HighlightEditor.InvocationTargetException");
		} catch (IllegalAccessException e) {
			System.err.println("HighlightEditor.IllegalAccessException");
		}
	}
	
	//
	// Intercept inserts and removes to color them.
	//
        @Override
	public void insertString(int offs, String str, AttributeSet a)
			throws BadLocationException {
            if (str == null) return;
//            if (a == null) return;
            /*
                // if a large chunck is changed at once, (e.g. deleting half a file)
                // colorer in a THREAD does really hickup
                // we leave the thread and do it out of the thread
                // it is bad - I know!
            if (str.length()>50)
            {
                stopColoring();
                try
                {
                    synchronized (docLock) {
			super.insertString(offs, str, a);
                    }
                }
                catch (Throwable e)
                {
                    
                }
                startColoring();
                return;
            }
            */
		synchronized (docLock) {
                    try
                    {
			super.insertString(offs, str, a);
			color(offs, str.length());
			documentReader.update(offs, str.length());
                    }
                    catch (Throwable e)
                    {
                      //  e.printStackTrace();
                        LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
                        log.addLog("Insert String - probably not mega bad", INFO);
                        log.addLog(de.malban.util.Utility.getStackTrace(e), INFO);
                        log.addLog("offs: "+offs, INFO);
                        log.addLog("str: "+str, INFO);
                    }
		}
	}
        
        // only to prevent neverending exceptions on undo!
        @Override
        public void getText(int offset, int length, Segment txt) throws BadLocationException
        {
            if (length <0) length = 0;
            super.getText( offset,  length,  txt);
        }

        @Override
        public void remove(int offs, int len) throws BadLocationException {

  
            if (Math.abs(len) >100) // just some "bigger" size
            {
                // if a large chunck is changed at once, (e.g. deleting half a file)
                // colorer in a THREAD does really hickup
                // we leave the thread and do it out of the thread
                // it is bad - I know!

                boolean restartColorer = false;
                if (VideConfig.syntaxHighliteEnabled)
                    restartColorer = colorer.isStarted();

                if (restartColorer)
                    stopColoring();
                
                try
                {
                    super.remove(offs, len); // wtach that belwo!
                }
                catch (Throwable e)
                {
                    LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
                    log.addLog("Remove 1", INFO);
                    
                }
                if (restartColorer)
                    startColoring();
                return;
            }
            int lenOrg = len;
            // Malban see: https://community.oracle.com/thread/1486098
            synchronized (docLock) 
            {
                do
                {
                    Element elem=getParagraphElement(offs);
                    int start=elem.getStartOffset();
                    int len2=Math.min(elem.getEndOffset()-offs,len);
                    if(len2>0)
                    {
                
                        try
                        {
                            super.remove(offs, len2); 
                        }
                        catch (Throwable e)
                        {
                            LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
                            log.addLog("Remove 2", INFO);
                        }


                       color(offs, -len2);
                       documentReader.update(offs, -len2);
                    }
                    if (len2 <= 0) len2=1;
                    len-=len2;
                } while (len > 0);
            }
                
	}
        

	// methods for Colorer to retrieve information
	DocumentReader getDocumentReader() { return documentReader; }
	public Object getDocumentLock() { return docLock; }
	Lexer getSyntaxLexer() { return syntaxLexer; }
	AttributeSet getGlobalStyle() { return globalStyle; }
}
