/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vedi;

import static de.malban.vide.vedi.DebugComment.*;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collections;

/**
 *
 * @author malban
 */
public class DebugCommentList implements Serializable
{
    ArrayList<DebugComment> comments = new ArrayList<DebugComment>();
    public String filename = "";
    public ArrayList<DebugComment> getList()
    {
        return comments;
    }
    public boolean removeComment(DebugComment c)
    {
        return comments.remove(c);
    }
    private DebugComment addComment(int l, int t, int st, String s, int p)
    {
        DebugComment c = new DebugComment();
        c.type = t;
        c.subType = st;
        c.beforLineNo = l;
        c.generatedComment = s;
        c.additionalParameter = p;
        c.file = filename;
        comments.add(c);
        Collections.sort(comments);
        return c;
    }
    public DebugComment addBreakComment(int line)
    {
        return addComment(line, COMMENT_TYPE_BREAK, SUB_BREAK_NORMAL, "; hey dissi \"break\"", 0);
    }
    public DebugComment addBreakOnceComment(int line)
    {
        return addComment(line, COMMENT_TYPE_BREAK, SUB_BREAK_ONCE, "; hey dissi \"break once\"", 0);
    }
    public DebugComment addWatchComment(int line, String varName, int subType, int param)
    {
        return addComment(line, COMMENT_TYPE_WATCH, subType, "; hey dissi \"watch $"+varName+" "+subType+" "+ param+ "\"", param);
    }
    public DebugComment getBreakpoint(int line)
    {
        for(DebugComment dbc: comments)
        {
            if (dbc.beforLineNo == line)
            {
                if (dbc.type == COMMENT_TYPE_BREAK) return dbc;
            }
        }
        return null;
    }
            
}
