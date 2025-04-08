/*
 * This file is part of the programmer editor demo
 * Copyright (C) 2005 Stephen Ostermiller
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

import de.malban.vide.VideConfig;
import java.awt.Color;
import java.util.ArrayList;
import java.util.HashMap;

import javax.swing.text.AttributeSet;
import javax.swing.text.SimpleAttributeSet;
import javax.swing.text.StyleConstants;
import javax.swing.text.StyleContext;
import javax.swing.text.TabSet;
import javax.swing.text.TabStop;

public class TokenStyles 
{
    private TokenStyles() { } // disable constructor

    /**
     * A hash table containing the text styles. Simple attribute sets are hashed
     * by name (String)
     */
    public static HashMap styles;
    public static int FONT_SIZE = 12;
    public static ArrayList<MyStyle> styleList;

    public static class MyStyle extends SimpleAttributeSet
    {
        public String name="";
    }
    
    /**
     * Create the styles and place them in the hash table.
     */
    static 
    {
        declareStyles();
    }
    static void resetStyles()
    {
        declareStyles();
    }
    private static void declareStyles()
    {
        // only in init
        // once config is active
        // the TAB values from config are taken!
        styles = new HashMap();
        styleList = new ArrayList<MyStyle>();
        
        Color maroon = new Color(0xB03060);
        Color darkBlue = new Color(0x000080);
        Color darkGreen = Color.GREEN.darker();
        Color orange = new Color(0xff8000);
        Color darkerGreen = new Color(0x105010);

        addStyle("register", Color.WHITE, Color.BLACK, true, false);
        addStyle("tag", Color.WHITE, Color.BLUE, true, false);
        addStyle("reference", Color.WHITE, Color.BLACK, false, false);
        addStyle("name", Color.WHITE, darkerGreen, true, false);
        addStyle("value", Color.WHITE, maroon, false, true);
        addStyle("text", Color.WHITE, Color.BLACK, true, false);
        addStyle("default", Color.WHITE, Color.BLACK, true, false);
        addStyle("reservedWord", Color.WHITE, Color.BLUE, false, false);
        addStyle("identifier", Color.WHITE, darkerGreen, false, false);
        addStyle("literal", Color.WHITE, maroon, false, false);
        addStyle("literalstring", Color.WHITE, orange, false, false);
        addStyle("separator", Color.WHITE, darkBlue, false, false);
        addStyle("operator", Color.WHITE, Color.BLACK, false, false);
        addStyle("comment", Color.WHITE, darkGreen, false, false);
        addStyle("preprocessor", Color.WHITE, darkBlue, false, false);
        addStyle("whitespace", Color.WHITE, Color.BLACK, false, false);
        addStyle("error", Color.WHITE, Color.RED, false, false);
        addStyle("unknown", Color.WHITE, Color.RED.darker(), true, false);
        addStyle("grayedOut", Color.WHITE, Color.GRAY, false, false);
        addStyle("literalVariable", Color.WHITE, darkerGreen, false, false);
        addStyle("editLogMessage", Color.WHITE, Color.BLACK, false, false);
        addStyle("editLogWarning", Color.WHITE, Color.BLUE, false, false);
        addStyle("editLogComment", Color.WHITE, darkGreen, false, false);
        addStyle("editLogError", Color.WHITE, Color.RED, false, false);


        addStyle("breakpoint", Color.red, darkGreen, false, false);
        addStyle("bookmark", Color.BLUE, darkGreen, false, false);
        
    }
    
    private static void addStyle(String name, Color bg, Color fg, boolean bold, boolean italic) 
    {
        addStyle(name, bg, fg, bold, italic, 12,  "Monospaced"); 
    }
    
    public static void addStyle(String name, Color bg, Color fg, boolean bold, boolean italic, int size, String family) 
    {
        FONT_SIZE = size*2/3;
// is 1/72 of an inch
        
VideConfig config = VideConfig.getConfig();
int TAB_WIDTH = 8;
if (config!=null) TAB_WIDTH = config.tab_width;
int TAB_COUNT = 100;
TabStop[] tabs = new TabStop[TAB_COUNT];
for (int i=0;i<TAB_COUNT;i++)
{
    tabs[i]=new TabStop((i+1)*TAB_WIDTH*TokenStyles.FONT_SIZE, TabStop.ALIGN_LEFT, TabStop.LEAD_NONE);
}
TabSet tabset = new TabSet(tabs);
                
        
        MyStyle style = new MyStyle();
        StyleConstants.setFontFamily(style,family);
        StyleConstants.setFontSize(style, size);
        StyleConstants.setBackground(style, bg);
        StyleConstants.setForeground(style, fg);
        StyleConstants.setBold(style, bold);
        StyleConstants.setItalic(style, italic);
        StyleConstants.setTabSet(style, tabset);
        
        style.name = name;
        styles.put(name, style);
        addToList( style);
    }
 
    public static void addToList(MyStyle style)
    {
        for (int i=0;i<styleList.size();i++)
        {
            if (styleList.get(i).name.equals(style.name))
            {
                styleList.remove(i);
                break;
            }
        }
        
        styleList.add(style);
        
    }
    

    /**
     * Retrieve the style for the given type of token.
     * 
     * @param styleName
     *            the label for the type of text ("tag" for example) or null if
     *            the styleName is not known.
     * @return the style
     */
    public static AttributeSet getStyle(String styleName) 
    {
        return (AttributeSet) styles.get(styleName);
    }
    public static void reset()
    {
        styles = new HashMap();
        styleList = new ArrayList<MyStyle>();
    }
}
