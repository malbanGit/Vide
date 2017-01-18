/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vedi;

import java.io.Serializable;

/**
 *
 * @author malban
 */
public class DebugComment implements Serializable, Comparable<DebugComment>
{
    public static final int COMMENT_TYPE_NONE = 0;
    public static final int COMMENT_TYPE_BREAK = 1;
    public static final int COMMENT_TYPE_WATCH = 2;

    public static final int SUB_BREAK_NORMAL = 0;
    public static final int SUB_BREAK_ONCE = 1;

    public static final int SUB_WATCH_8BIT = 0;
    public static final int SUB_WATCH_16BIT = 1;
    public static final int SUB_WATCH_STRING = 2;
    public static final int SUB_WATCH_2_8BIT = 3;
    public static final int SUB_WATCH_SEQUENCE = 4;
    
    private static int UID =0;
    int uid = (UID++);
    int beforLineNo = -1;
    int type = COMMENT_TYPE_NONE;
    int subType = 0;
    int additionalParameter = 0; // only for wtch sequence now
    
    boolean enabled = true;
    String generatedComment ="";
    String file="";

    @Override
    public int compareTo(DebugComment c)
    {
        if (c == null) return 1;
        return beforLineNo - c.beforLineNo; 
    }
    
    public String getGeneratedComment()
    {
        return generatedComment;
    }
    
}
