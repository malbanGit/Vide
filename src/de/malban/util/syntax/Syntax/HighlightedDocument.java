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

import javax.swing.text.*;

import java.io.*;
import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;

import de.malban.util.syntax.Syntax.Lexer.*;
import de.malban.util.syntax.entities.ASM6809FileInfo;
import javax.swing.SwingUtilities;

/**
 * A <a href="http://ostermiller.org/syntax/editor.html">demonstration text
 * editor</a> that uses syntax highlighting.
 */
public class HighlightedDocument extends DefaultStyledDocument 
{
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

        ASM6809FileInfo fileInfo = null;
	/**
	 * A reader wrapped around the document so that the document can be fed into
	 * the lexer.
	 */
	private DocumentReader documentReader;
	
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
	private Object docLock = new Object();

	/**
	 * Create a new Demo
	 */
	public HighlightedDocument() {

		// Start the thread that does the coloring
	//	colorer.start();
                // malban, moved thread start to be
                // started seperately,
                // otherwise texts will on start ALLWAYs
                // be colored twice!
                // one on setting the highlighter
                // thread snaps event and starts running
                // two, since event queue is empty upon setting the actual text
                
                colorer = new Colorer(this);

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
        String knownFilename = null;
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
                    fileInfo = ASM6809FileInfo.handleFile(filename, text);
                }
                catch (Throwable e)
                {
                    e.printStackTrace();
                }
            }
            // do first coloring NOT in thread, saves us SOME trouble of swing and synchronicity
            if (!colorer.isStarted())
            {
                colorAllDirect();
                colorer.start();
    //            colorAll();
            }
        }
        public void deinit()
        {
            colorer.stopIt();
        }
        public void stopColoring()
        {
            colorer.stopIt();
        }
        public void startColoring()
        {
//            editorPaneDocument.startColoring();
            colorer = new Colorer(this);
            colorAllDirect();
            colorer.start();
        }

	/**
	 * Color or recolor the entire document
	 */
	public void colorAll() 
        {
            if (colorer.isStarted())
            {
                colorer.colorAll();
            }
        }
	public void colorAllDirect() 
        {
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
            if (colorer.isStarted())
                colorer.colordbg(position, adjustment);
	}
	public void color(int position, int adjustment) {
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
	public void insertString(int offs, String str, AttributeSet a)
			throws BadLocationException {
		synchronized (docLock) {
                    try
                    {
			super.insertString(offs, str, a);
			color(offs, str.length());
			documentReader.update(offs, str.length());
                    }
                    catch (Throwable e)
                    {
                        
                    }
		}
	}
        
        // only to prevent neverending exceptions on undo!
        public void getText(int offset, int length, Segment txt) throws BadLocationException
        {
            if (length <0) length = 0;
            super.getText( offset,  length,  txt);
        }

        public void remove(int offs, int len) throws BadLocationException {

  
            if (Math.abs(len) >100) // just some "bigger" size
            {
                // if a large chunck is changed at once, (e.g. deleting half a file)
                // colorer in a THREAD does really hickup
                // we leave the thread and do it out of the thread
                // it is bad - I know!

                
                
                stopColoring();
                super.remove(offs, len); // wtach that belwo!
                /*
                synchronized (docLock) 
                {
                    do
                    {
                        Element elem=getParagraphElement(offs);
                        int start=elem.getStartOffset();
                        int len2=Math.min(elem.getEndOffset()-offs,len);
                        if(len2>0)
                        {
                           super.remove(offs, len2);
                           documentReader.update(offs, -len2);
                        }
                        if (len2 <= 0) len2=1;
                        len-=len2;
                    } while (len > 0);
                }
                */
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
                       super.remove(offs, len2);
                       color(offs, -len2);
                       documentReader.update(offs, -len2);
                    }
                    if (len2 <= 0) len2=1;
                    len-=len2;
                } while (len > 0);

           //     color(offs, -lenOrg);
//                    documentReader.update(offs, -lenOrg);
            }
                
	}
	public void remove_(int offs, int len) throws BadLocationException {
// * OLD Excpeiton upon UNDO
  
            synchronized (docLock) {
                try
                {
                    super.remove(offs, len);
                    color(offs, -len);
                    documentReader.update(offs, -len);
		}
                catch (Throwable e)
                {
                    e.printStackTrace();
System.out.println("Super Buh!");
                }
            }
            
/*            
            
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
                           super.remove(offs, len2);
                        }
                        if (len2 <= 0) len2=1;
                        len-=len2;
                    } while (len > 0);
                     
               //     color(offs, -lenOrg);
                    documentReader.update(offs, -lenOrg);
                    
                     
                }
                */
                
	}

	// methods for Colorer to retrieve information
	DocumentReader getDocumentReader() { return documentReader; }
	public Object getDocumentLock() { return docLock; }
	Lexer getSyntaxLexer() { return syntaxLexer; }
	AttributeSet getGlobalStyle() { return globalStyle; }
        
}
