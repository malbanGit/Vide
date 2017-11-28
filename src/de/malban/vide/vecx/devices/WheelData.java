/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx.devices;

import de.malban.Global;
import de.malban.config.Configuration;
import de.malban.gui.panels.LogPanel;
import static de.malban.gui.panels.LogPanel.WARN;
import de.malban.util.XMLSupport;
import java.awt.Color;
import java.io.File;
import java.io.Serializable;
import java.util.ArrayList;

/**
 *
 * @author malban
 */
public class WheelData implements Serializable{
    transient LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
    // angle of 0 start of black
    // angles are "counted" clockwise
    public String name;
    public int id;
    public double indexAngle;
    public double[] startAngle;
    public Color[] colors;
    public double defaultFrequency;

    private WheelData()
    {
        // Narrow escape is default new wheel!
        id = 1;
        name="Narrow Escape";
        startAngle = new double[4];
        colors = new Color[4];

        // black
        startAngle[0] = 0;
        colors[0] = new Color(0,0,0,255);

        // red
        startAngle[1] = 180;
        colors[1] = new Color(0,0,255,100);

        // green
        startAngle[2] = 240;
        colors[2] = new Color(0,255,0,100);

        // blue
        startAngle[3] = 304;
        colors[3] = new Color(255,0,0,100);
        
        defaultFrequency = 26.1579;
        indexAngle = 254; // guessing        
    }
    
    public void addSection(Color newColor)
    {
        double[] nstartAngle = new double[startAngle.length+1];
        Color[] ncolors = new Color[colors.length+1];
     
        for (int i=0; i<colors.length;i++)
        {
            nstartAngle[i] = startAngle[i];
            ncolors[i] = colors[i];
        }
     
        nstartAngle[startAngle.length] = 360;
        ncolors[startAngle.length] = newColor;

        startAngle = nstartAngle;
        colors = ncolors;
    }
    public void removeSection(int s)
    {
        if (s<1) return; // can't remove black
        if (s>=startAngle.length) return; // only remove sections that actually exist
        
        double[] nstartAngle = new double[startAngle.length-1];
        Color[] ncolors = new Color[colors.length-1];
     
        int target=0;
        for (int i=0; i<colors.length;i++)
        {
            if (i!=s)
            {
                nstartAngle[target] = startAngle[i];
                ncolors[target] = colors[i];
                target++;
            }
        }
     
        startAngle = nstartAngle;
        colors = ncolors;
    }
    
    
    public static WheelData createNewWheel()
    {
        WheelData wd = new WheelData();

        return wd;
    }
    
    public boolean toXML(StringBuilder s, String tag)
    {
        s.append("<").append(tag).append(">\n");
        boolean ok = true;
        ok = ok & XMLSupport.addElement(s, "name", name);
        ok = ok & XMLSupport.addElement(s, "id", id);
        ok = ok & XMLSupport.addElement(s, "indexAngle", indexAngle);
        ok = ok & XMLSupport.addElement(s, "defaultFrequency", defaultFrequency);
        for (int i=0; i<colors.length; i++)
        {
            s.append("<").append("colorsection").append(">\n");
            ok = ok & XMLSupport.addElement(s, "wheelplacing", i);
            ok = ok & XMLSupport.addElement(s, "startAngle", startAngle[i]);
            ok = ok & XMLSupport.addElement(s, "red", colors[i].getRed());
            ok = ok & XMLSupport.addElement(s, "green", colors[i].getGreen());
            ok = ok & XMLSupport.addElement(s, "blue", colors[i].getBlue());
            s.append("</").append("colorsection").append(">\n");
        }
        s.append("</").append(tag).append(">\n");
        return ok;        
    }

    // a xml "list" of an arbitrary number of GFXVectors
    public boolean fromXML(StringBuilder xml, XMLSupport xmlSupport)
    {
        int errorCode = 0;
        name= xmlSupport.getStringElement("name", xml);errorCode|=xmlSupport.errorCode;
        id= xmlSupport.getIntElement("id", xml);errorCode|=xmlSupport.errorCode;
        defaultFrequency= xmlSupport.getDoubleElement("defaultFrequency", xml);errorCode|=xmlSupport.errorCode;
        indexAngle= xmlSupport.getDoubleElement("indexAngle", xml);errorCode|=xmlSupport.errorCode;
        
        ArrayList<Color> col = new ArrayList<Color>();
        ArrayList<Double> ang = new ArrayList<Double>();
        ArrayList<Integer> ord = new ArrayList<Integer>();
        StringBuilder oneElement = null;
        do
        {
            oneElement = xmlSupport.removeTag("colorsection", xml);
            if (oneElement == null) break;
            errorCode|=xmlSupport.errorCode;
            
            double a = xmlSupport.getDoubleElement("startAngle", oneElement);errorCode|=xmlSupport.errorCode;
            int o = xmlSupport.getIntElement("wheelplacing", oneElement);errorCode|=xmlSupport.errorCode;
            int r = xmlSupport.getIntElement("red", oneElement);errorCode|=xmlSupport.errorCode;
            int g = xmlSupport.getIntElement("green", oneElement);errorCode|=xmlSupport.errorCode;
            int b = xmlSupport.getIntElement("blue", oneElement);errorCode|=xmlSupport.errorCode;
            col.add(new Color(r,g,b));
            ang.add(a);
            ord.add(o);
        } while (true);
        if (errorCode!= 0) return false;
        
        startAngle = new double[ang.size()];
        colors = new Color[ang.size()];
        int count = 0;
        while (ang.size()>0)
        {
            for (int i=0; i<ang.size(); i++)
            {
                if (ord.get(i) == count)
                {
                    startAngle[count] = ang.get(i);
                    colors[count] = col.get(i);
                    count++;
                    ang.remove(i);
                    col.remove(i);
                    ord.remove(i);
                    break;
                }
            }
        }
        return true;
    }
    
    public boolean saveAsXML(String filename)
    {
        StringBuilder xml = new StringBuilder();

        boolean ok = toXML(xml, "WheelData");
        if (!ok)
        {
            log.addLog("WheelData save 'toXML' return false", WARN);
            return false;
        }
        ok = de.malban.util.UtilityFiles.createTextFile(filename, xml.toString());
        if (!ok)
        {
            log.addLog("WheelData create file '"+filename+"' return false", WARN);
            return false;
        }
        return true; 
    }
    
    public static WheelData loadWheel(String filename)
    {
        WheelData w = new WheelData();
        if (w.loadFromXML(filename)) return w;
        return null;
    }
    
    public boolean loadFromXML(String filename)
    {
        String xml = de.malban.util.UtilityString.readTextFileToOneString(new File (filename));
        boolean ok = fromXML(new StringBuilder(xml), new XMLSupport());
        if (!ok)
        {
            log.addLog("WheelData load from xml '"+filename+"' return false", WARN);
            return false;
        }
        return true;
    }
    // as in combobox
    public static WheelData getWheel(String name)
    {
        WheelData wheel = WheelData.loadWheel(Global.mainPathPrefix+"xml"+File.separator+"wheels"+File.separator+name+".xml");
        if (wheel == null) wheel = new WheelData();
        return wheel;
    }
}
