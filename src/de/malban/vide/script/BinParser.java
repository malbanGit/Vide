/*

Veci: vector list and building of animations for list (rotate)
: grab "all" vectors and replace
: Background vectors
: copy / Paste of selected Vectors
: run anaimations
: "close" vector List
: save in "own" format
: do default exports

*/



/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.script;

import de.malban.graphics.GFXVector;
import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Vector;

/**
 *
 * @author malban
 */
public class BinParser {
    
    public static final int UNKOWN = -1;
    public static final int Draw_VL = 0;
    public static final int Draw_VLc = 1;
    public static final int Draw_VL_b = 2;
    public static final int Draw_VLcs = 3;
    public static final int Draw_VLp = 4;
    public static final int Draw_VLp_scale = 5;

    int listType = UNKOWN;
    int pos = 0;
    boolean loaded = false;
    byte[] data; // lines are \n terminated!
    
    // \r\n -> \n
    //\t -> "  "
    public boolean readFile(String filename)
    {
        Path path = Paths.get(filename);
        try
        {
            data = Files.readAllBytes(path);
            loaded = true;
        }
        catch (Throwable ex)
        {
            return false;
        }
        return true;
    }
    
    public void setPosition(int p)
    {
        pos = p;
    }
    public void setExpectedListType(int type)
    {
        listType = type;
    }
    // returns null if any error
    public Vector getNextVectorList()
    {
        return getNextVectorList(0);
    }
    public Vector getNextVectorList(int count)
    {
        Vector<GFXVector> ret = new Vector<GFXVector>();
        
        if (listType == Draw_VLc)
        {
            // DB 10
            // DB x1,y1
            // DB ...
            // DB x10,y10
            int length = data[pos++];
            GFXVector oldVector=null;
            for (int i=0;i<length; i++)
            {
                int x = data[pos++];
                int y = data[pos++];
                GFXVector vector= new GFXVector(oldVector, x,y, 0);
                oldVector = vector;
                ret.addElement(vector);
            }
        }
        if (listType == Draw_VL)
        {
            // DB x1,y1
            // DB ...
            // DB x10,y10
            int length = count;
            GFXVector oldVector=null;
            for (int i=0;i<length; i++)
            {
                int x = data[pos++];
                int y = data[pos++];
                GFXVector vector= new GFXVector(oldVector, x,y, 0);
                oldVector = vector;
                ret.addElement(vector);
            }
        }
        return ret;
    }
}
