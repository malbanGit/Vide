/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.graphics;

import de.malban.util.XMLSupport;
import java.util.ArrayList;

/**
 *
 * @author malban
 */
public class Vertex implements Comparable{
    
    private static int UID = 0;
    public int uid = ++UID;
    public int load_uid=0;
    
    public static int ARRAY_X = 0;
    public static int ARRAY_Y = 1;
    public static int ARRAY_Z = 2;
    public static int ARRAY_W = 3;
    
    public double[] coords = new double[4];
    boolean[] usage = new boolean[4];

    // helper for editing!
    public boolean selected = false;
    public boolean highlight = false;
        
    public ArrayList<String> face=new ArrayList<String>(); // the string is FaceNo|FacePos (faceNo >=1, FacePos >= 0)
    
    public void resetSelection()
    {
        selected = false;
        highlight = false;
    }
    public void resetDisplay()
    {
        selected = false;
        highlight = false;
    }
    
    public boolean equals(Vertex p)
    {
        if (coords[ARRAY_X] != p.coords[ARRAY_X]) return false;
        if (coords[ARRAY_Y] != p.coords[ARRAY_Y]) return false;
        if (coords[ARRAY_Z] != p.coords[ARRAY_Z]) return false;
        if (coords[ARRAY_W] != p.coords[ARRAY_W]) return false;
        if (usage[ARRAY_X] != p.usage[ARRAY_X]) return false;
        if (usage[ARRAY_Y] != p.usage[ARRAY_Y]) return false;
        if (usage[ARRAY_Z] != p.usage[ARRAY_Z]) return false;
        if (usage[ARRAY_W] != p.usage[ARRAY_W]) return false;
        return true;
    }
    
    
    public Vertex()
    {
        coords[ARRAY_X]=0;
        coords[ARRAY_Y]=0;
        coords[ARRAY_Z]=0;
        coords[ARRAY_W]=1;
        usage[ARRAY_X]=true;
        usage[ARRAY_Y]=true;
        usage[ARRAY_Z]=true;
        usage[ARRAY_W]=true;
    }
    // "clone"
    public Vertex(Vertex p)
    {
        set(p);
    }
    public Vertex(double _x, double _y, double _z)
    {
        coords[ARRAY_X]=_x;
        coords[ARRAY_Y]=_y;
        coords[ARRAY_Z]=_z;
        coords[ARRAY_W]=1;
        usage[ARRAY_X]=true;
        usage[ARRAY_Y]=true;
        usage[ARRAY_Z]=true;
        usage[ARRAY_W]=true;
    }
    
    // "clone"
    // clone even, if set to "self"
    public final void set(Vertex p)
    {
        double[] c = new double[4];
        boolean[] u = new boolean[4];
                
        if (p==null) return;
        c[ARRAY_X] = p.coords[ARRAY_X];
        c[ARRAY_Y] = p.coords[ARRAY_Y];
        c[ARRAY_Z] = p.coords[ARRAY_Z];
        c[ARRAY_W] = p.coords[ARRAY_W];
        u[ARRAY_X] = p.usage[ARRAY_X];
        u[ARRAY_Y] = p.usage[ARRAY_Y];
        u[ARRAY_Z] = p.usage[ARRAY_Z];
        u[ARRAY_W] = p.usage[ARRAY_W];
        selected = p.selected;
        highlight = p.highlight;
        coords = c; 
        usage = u; 
        
        ArrayList<String> faceNew =new ArrayList<String>();
        for (String f: p.face)
        {
            faceNew.add(f);
        }
        face = faceNew; // does that make sense?
    }
    
    public String toString()
    {
        return "x: "+coords[ARRAY_X]+", y:"+coords[ARRAY_Y]+", z:"+coords[ARRAY_Z];
    }
    
    // "pointer"
    public double[] coord()
    {
        return coords;
    }
    
    public boolean x_use()
    {
        return usage[ARRAY_X];
    }
    public boolean y_use()
    {
        return usage[ARRAY_Y];
    }
    public boolean z_use()
    {
        return usage[ARRAY_Z];
    }
    public boolean w_use()
    {
        return usage[ARRAY_W];
    }
    public double x() 
    {
        return coords[ARRAY_X];
    }
    public double y() 
    {
        return coords[ARRAY_Y];
    }
    public double z() 
    {
        return coords[ARRAY_Z];
    }
    public double w() 
    {
        return coords[ARRAY_W];
    }
    public void x(double x) 
    {
        coords[ARRAY_X] = x;
    }
    public void y(double y) 
    {
        coords[ARRAY_Y] = y;
    }
    public void z(double z) 
    {
        coords[ARRAY_Z] = z;
    }
    public void w(double w) 
    {
        coords[ARRAY_W] = w;
    }
    
    public boolean toXML(StringBuilder s, String tag)
    {
        
        s.append("<").append(tag).append(">\n");
        boolean ok = true;
        ok = ok & XMLSupport.addElement(s, "x", coords[ARRAY_X]);
        ok = ok & XMLSupport.addElement(s, "y", coords[ARRAY_Y]);
        ok = ok & XMLSupport.addElement(s, "z", coords[ARRAY_Z]);
        ok = ok & XMLSupport.addElement(s, "w", coords[ARRAY_W]);

        ok = ok & XMLSupport.addElement(s, "use_x", usage[ARRAY_X]);
        ok = ok & XMLSupport.addElement(s, "use_y", usage[ARRAY_Y]);
        ok = ok & XMLSupport.addElement(s, "use_z", usage[ARRAY_Z]);
        ok = ok & XMLSupport.addElement(s, "use_w", usage[ARRAY_W]);

        ok = ok & XMLSupport.addElement(s, "id", uid);
        for(String f: face)
        {
            ok = ok & XMLSupport.addElement(s, "face", f);
        }

        s.append("</").append(tag).append(">\n");
        return ok;        
    }
    public boolean fromXML(StringBuilder xml, XMLSupport xmlSupport)
    {
        int errorCode = 0;
        x(xmlSupport.getDoubleElement("x", xml));errorCode|=xmlSupport.errorCode;
        y(xmlSupport.getDoubleElement("y", xml));errorCode|=xmlSupport.errorCode;
        z(xmlSupport.getDoubleElement("z", xml));errorCode|=xmlSupport.errorCode;
        w(xmlSupport.getDoubleElement("w", xml));errorCode|=xmlSupport.errorCode;
        usage[ARRAY_X] = xmlSupport.getBooleanElement("use_x", xml);errorCode|=xmlSupport.errorCode;
        usage[ARRAY_Y] = xmlSupport.getBooleanElement("use_y", xml);errorCode|=xmlSupport.errorCode;
        usage[ARRAY_Z] = xmlSupport.getBooleanElement("use_z", xml);errorCode|=xmlSupport.errorCode;
        usage[ARRAY_W] = xmlSupport.getBooleanElement("use_w", xml);errorCode|=xmlSupport.errorCode;

        // no error to support
        // backwards compatability
        load_uid = xmlSupport.getIntElement("id", xml);/*errorCode|=xmlSupport.errorCode;*/

        face = new ArrayList<String>(); 
        do
        {
            String faceInt = xmlSupport.getStringElement("face", xml, false);
            if (xmlSupport.errorCode != 0) 
            {
                break;
            }
            face.add(faceInt);
        } while (true);
        
        if (errorCode!= 0) return false;
        return true;
    }
    
    public int compareTo(Object o)
    {
        return this.toString().compareTo((o).toString());
    }
    
    public String buildCompareId()
    {
        String id = toString();
        for (String s: face)
        {
            id+=s;
        }
        return id+load_uid;
    }
}
