/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.graphics;

import de.malban.config.Configuration;
import de.malban.gui.panels.LogPanel;
import de.malban.util.XMLSupport;
import java.util.HashMap;

/**
 *
 * @author malban
 */
public class GFXVector 
{
    LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
    public static XMLSupport xmlSupport = new XMLSupport();
    // IMPORTANT
    // the linking between vectors is not directional sensible all the time
    // it might be that a vector start points "other" side is also a start
    // thus, you can NOT assume, 
    // Vector A
    // A.start_connect.end_connect = A
    // the NAMES "start" and "end" have no semantical meaning!
    
    
    // will be set from init to max UID in DB!
    public static void setMaxUID(int u)
    {
        UID = u;
    }
    private transient int oldCloneUID = -1; // uid that this vector was clones from
    private static int UID = 0;
    public int uid = ++UID;
    public int load_uid=0;
    boolean relativ = false;
    public boolean is3d = false;
    
    public int order;
    
    // on 2d only x,y are used
    // if relative, than only the "1" coordinates are used!
    // if relativ the "1" are relativ too
    // if not relative BOTH coordinates are absolut!
    
    // if relative both vectors SHARE a point (end->start)
    // for relative vectors to be persistable, each vector has an ID
    // and two "brothers"
    public GFXVector start_connect = null;
    public GFXVector end_connect = null;
    
    public Vertex start=new Vertex();
    public Vertex end=new Vertex();
    
    public int uid_start_connect=-1;
    public int uid_end_connect=-1;
    
    
    public int factor;
    
    // color
    public int r=255;
    public int g=255;
    public int b=255;
    public int a=128; 
    
    public int pattern =255; // vectrex byte pattern
    public int intensity =127; // vectrex intensity 0-127; (127 = max)
    
    // helper for editing!
    public boolean selected = false;
    public boolean highlight = false;
    public GFXVector()
    {
        order = uid;
    }
    public String toString()
    {
        return start.toString()+" -> "+end.toString();
    }
    public void resetSelection()
    {
        selected = false;
        highlight = false;
        start.resetSelection();
        end.resetSelection();
    }
    
    public void resetDisplay()
    {
        selected = false;
        highlight = false;
        r = 255;
        g = 255;
        b = 255;
        a = 128;
        start.resetDisplay();
        end.resetDisplay();
    }
    // relativ Vector
    // convention:
    // this start is old Vector end!
    // if old Vector == null
    // new vector will be completly empty!
    public GFXVector(GFXVector oldVector, int difX, int difY, int difZ)
    {
        order = uid;
        if (oldVector != null)
        {
            start = oldVector.end;
            oldVector.end_connect = this;
            oldVector.uid_end_connect = uid;
            if (oldVector.uid_start_connect!=-1)
            {
                oldVector.setRelativ(true);
            }
            start_connect = oldVector;
            uid_start_connect = oldVector.uid;

            end.x(start.x()+difX);
            end.y(start.y()+difY);
            end.z(start.z()+difZ);
        }
    }
    
    
    // connections are NOT cloned!
    // they are null and -1
    public GFXVector clone()
    {
        GFXVector v = new GFXVector();
        v.selected = selected;
        v.highlight = highlight;
        v.setIntensity(getIntensity());
        v.pattern = pattern;
        v.r = r;
        v.g = b;
        v.b = b;
        v.a = a;
        v.factor = factor;
        v.start.set(start);
        v.end.set(end);
        v.oldCloneUID = uid;
        return v;
    }
    // -1 if not cloned
    // otherwise old uid
    // can be needed to restore vector "connections" after a vectorlist clone
    public int getOldCloneUID()
    {
        return oldCloneUID;
    }
    
    /**
     * @return the relativ
     */
    public boolean isRelativ() 
    {
        
        return relativ;
    }

    /**
     * @param relativ the relativ to set
     */
    public void setRelativ(boolean relativ) {
        this.relativ = relativ;
        if (!relativ)
        {
            r=255;
            g=255;
            b=255;
            a=getIntensity()*2;
        }
        else
        {
            r=255;
            g=0;
            b=255;
            a=getIntensity()*2;
        }
    }

    /**
     * @return the intensity
     */
    public int getIntensity() {
        return intensity;
    }

    /**
     * @param intensity the intensity to set
     */
    public void setIntensity(int intensity) {
        this.intensity = intensity;
        a = intensity*2;
        if (a>255) a = 255;
        if (a<0) a = 0;
    }
    
    public boolean toXML(StringBuilder s, String tag)
    {
        s.append("<").append(tag).append(">\n");
        boolean ok = true;
        ok = ok & start.toXML(s, "startVertex");
        ok = ok & end.toXML(s, "endVertex");
        ok = ok & XMLSupport.addElement(s, "pattern", pattern);
        ok = ok & XMLSupport.addElement(s, "r", r);
        ok = ok & XMLSupport.addElement(s, "g", g);
        ok = ok & XMLSupport.addElement(s, "b", b);
        ok = ok & XMLSupport.addElement(s, "a", a);
        ok = ok & XMLSupport.addElement(s, "id", uid);
        ok = ok & XMLSupport.addElement(s, "order", order);
        ok = ok & XMLSupport.addElement(s, "start_neighbour_id", uid_start_connect);
        ok = ok & XMLSupport.addElement(s, "end_neighbour_id", uid_end_connect);
        ok = ok & XMLSupport.addElement(s, "start_is_relative", relativ);
        ok = ok & XMLSupport.addElement(s, "end_is_relative", relativ);
        ok = ok & XMLSupport.addElement(s, "is_3d", is3d);
        ok = ok & XMLSupport.addElement(s, "intensity", intensity);
        s.append("</").append(tag).append(">\n");
        return ok;        
    }
    
    // parameter a string representing 
    // one vector in xml form like "toXML"
    // I know there are a lot of parsers out there, 
    // but this is short and straight forward and
    // I don't have to setup a whole bunch of 
    public boolean fromXML(StringBuilder xml, XMLSupport xmlSupport)
    {
        int errorCode = 0;
        start.fromXML((xmlSupport.getXMLElement("startVertex", xml)), xmlSupport);errorCode|=xmlSupport.errorCode;
        end.fromXML((xmlSupport.getXMLElement("endVertex", xml)), xmlSupport);errorCode|=xmlSupport.errorCode;

        pattern = xmlSupport.getIntElement("pattern", xml);errorCode|=xmlSupport.errorCode;
        r = xmlSupport.getIntElement("r", xml);errorCode|=xmlSupport.errorCode;
        g = xmlSupport.getIntElement("g", xml);errorCode|=xmlSupport.errorCode;
        b = xmlSupport.getIntElement("b", xml);errorCode|=xmlSupport.errorCode;
        a = xmlSupport.getIntElement("a", xml);errorCode|=xmlSupport.errorCode;
        load_uid= xmlSupport.getIntElement("id", xml);errorCode|=xmlSupport.errorCode;
        
        order= xmlSupport.getIntElement("order", xml);errorCode|=xmlSupport.errorCode;
        uid_start_connect= xmlSupport.getIntElement("start_neighbour_id", xml);errorCode|=xmlSupport.errorCode;
        uid_end_connect= xmlSupport.getIntElement("end_neighbour_id", xml);errorCode|=xmlSupport.errorCode;
        boolean startRelative;
        boolean endRelative;
        startRelative= xmlSupport.getBooleanElement("start_is_relative", xml);errorCode|=xmlSupport.errorCode;
        endRelative= xmlSupport.getBooleanElement("end_is_relative", xml);errorCode|=xmlSupport.errorCode;
        relativ = startRelative & endRelative;
        
        is3d= xmlSupport.getBooleanElement("is_3d", xml);errorCode|=xmlSupport.errorCode;
        intensity= xmlSupport.getIntElement("intensity", xml);errorCode|=xmlSupport.errorCode;
        if (errorCode!= 0) return false;
        return true;
    }
    
    // always positive
    public double getMaxAbsValue()
    {
        double minX = Integer.MAX_VALUE;
        double maxX = -Integer.MAX_VALUE;
        double minY = Integer.MAX_VALUE;
        double maxY = -Integer.MAX_VALUE;
        double minZ = Integer.MAX_VALUE;
        double maxZ = -Integer.MAX_VALUE;
        GFXVector v = this;
        if (minX>v.start.x()) minX = v.start.x();
        if (minX>v.end.x()) minX = v.end.x();
        if (maxX<v.start.x()) maxX = v.start.x();
        if (maxX<v.end.x()) maxX = v.end.x();

        if (minY>v.start.y()) minY = v.start.y();
        if (minY>v.end.y()) minY = v.end.y();
        if (maxY<v.start.y()) maxY = v.start.y();
        if (maxY<v.end.y()) maxY = v.end.y();

        if (minZ>v.start.z()) minZ = v.start.z();
        if (minZ>v.end.z()) minZ = v.end.z();
        if (maxZ<v.start.z()) maxZ = v.start.z();
        if (maxZ<v.end.z()) maxZ = v.end.z();
    
        double max = Math.max(Math.abs(maxX), Math.abs(maxY));
        max = Math.max(max, Math.abs(maxZ));
        max = Math.max(max, Math.abs(minX));
        max = Math.max(max, Math.abs(minY));
        max = Math.max(max, Math.abs(minZ));    
        return max;
    }
    // always positive
    public double getMaxAbsLenValue()
    {
        GFXVector v = this;
        double xLen = v.end.x() - v.start.x();
        double yLen = v.end.y() - v.start.y();
        double zLen = v.end.z() - v.start.z();
        double max = Math.max(Math.abs(xLen), Math.abs(yLen));
        max = Math.max(max, Math.abs(zLen));
        return max;
    }

    public void scaleAll(double scale, HashMap<Vertex, Boolean> safetyMap)
    {
        GFXVector v = this;
        if (safetyMap.get(v.start) == null)
        {
            v.start.x((int)(v.start.x()*scale));
            v.start.y((int)(v.start.y()*scale));
            v.start.z((int)(v.start.z()*scale));
            safetyMap.put(v.start, true);
        }
        if (safetyMap.get(v.end) == null)
        {
            v.end.x((int)(v.end.x()*scale));
            v.end.y((int)(v.end.y()*scale));
            v.end.z((int)(v.end.z()*scale));
            safetyMap.put(v.end, true);
        }
    }
    
    
}
