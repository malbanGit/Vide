/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.graphics;

import de.malban.util.XMLSupport;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;

/**
 *
 * @author malban
 * */
public class Face
{
    public static final int NONE = 0;
    public static final int FACE = 1;
    public static final int POINT = 2;
    public static final int LINE = 3;
    
    public ArrayList<Vertex> vertice = new ArrayList<Vertex>();
    public int faceID = -1;
    public int type = NONE; // for wavefront loading
    
    
    // order vertice to pos
    public void order()
    {
        vertice.sort(new Comparator<Vertex>()
        {
            public int compare(Vertex v1, Vertex v2) 
            {   
                int pos1 =-1;
                for (String faceIdString: v1.face)
                {
                    if (faceIdString.startsWith(""+faceID+"|"))
                    {
                        String pos1S = faceIdString.substring((""+faceID+"|").length());
                        pos1 = de.malban.util.UtilityString.Int0(pos1S);
                        break;
                    }
                }
                int pos2 =-1;
                for (String faceIdString: v2.face)
                {
                    if (faceIdString.startsWith(""+faceID+"|"))
                    {
                        String pos2S = faceIdString.substring((""+faceID+"|").length());
                        pos2 = de.malban.util.UtilityString.Int0(pos2S);
                        break;
                    }
                }
                    
                
                return pos1-pos2;
            }
        });
    }

    
    public String getUidsString()
    {
        String ret = "";
        for (Vertex v: vertice)
        {
            ret += v.uid+" ";
        }
        return ret;
    }
    public String getPointsString()
    {
        String ret = "";
        
        for (Vertex v: vertice)
        {
            ret += "("+v.toString()+") ";
        }
        return ret;
    }
    
}