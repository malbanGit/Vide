/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vedi.sound;

import de.malban.Global;
import de.malban.config.Configuration;
import de.malban.gui.panels.LogPanel;
import static de.malban.gui.panels.LogPanel.WARN;
import de.malban.util.XMLSupport;
import de.malban.vide.dissy.DASM6809;
import java.io.File;
import java.io.Serializable;
import java.util.ArrayList;

/**
 *
 * @author malban
 */
public class Explosion  implements Serializable{
    transient LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();

    public byte[] bytes = new byte[4];
    public String name="";
    
    String getBytesString()
    {
        StringBuilder s = new StringBuilder();
        
        s.append("$").append(String.format("%02X", bytes[0])).append(",");
        s.append("$").append(String.format("%02X", bytes[1])).append(",");
        s.append("$").append(String.format("%02X", bytes[2])).append(",");
        s.append("$").append(String.format("%02X", bytes[3])).append("");
        return s.toString();
    }
    
    
    void setBytes(String a)
    {
        String[] numbers = a.split(",");
        int count =0 ;
        for (int i=0; i<numbers.length; i++)
        {
            String ss = numbers[i];
            ss = ss.trim();
            if (ss.length()<=0) continue;
            int value= DASM6809.toNumber(ss)& 0xff;
            
            bytes[count] = (byte)(value);
            count++;
        }        
    }
    
    public boolean toXML(StringBuilder s, String tag)
    {
        s.append("<").append(tag).append(">\n");
        boolean ok = true;
        ok = ok & XMLSupport.addElement(s, "name", name);
        ok = ok & XMLSupport.addElement(s, "bytes", getBytesString());
        s.append("</").append(tag).append(">\n");
        return ok;        
    }

    // a xml "list" of an arbitrary number of GFXVectors
    public boolean fromXML(StringBuilder xml, XMLSupport xmlSupport)
    {
        int errorCode = 0;
        name= xmlSupport.getStringElement("name", xml);errorCode|=xmlSupport.errorCode;
        String b= xmlSupport.getStringElement("bytes", xml);errorCode|=xmlSupport.errorCode;

        setBytes(b);
        if (errorCode!= 0) return false;
        return true;
    }
    
    public boolean saveAsXML(String filename)
    {
        StringBuilder xml = new StringBuilder();

        boolean ok = toXML(xml, "Explosion");
        if (!ok)
        {
            log.addLog("Explosion save 'toXML' return false", WARN);
            return false;
        }
        ok = de.malban.util.UtilityFiles.createTextFile(filename, xml.toString());
        if (!ok)
        {
            log.addLog("Explosion create file '"+filename+"' return false", WARN);
            return false;
        }
        return true; 
    }
    
    public static Explosion loadExplosion(String filename)
    {
        Explosion w = new Explosion();
        if (w.loadFromXML(filename)) return w;
        return null;
    }
    
    public boolean loadFromXML(String filename)
    {
        String xml = de.malban.util.UtilityString.readTextFileToOneString(new File (filename));
        boolean ok = fromXML(new StringBuilder(xml), new XMLSupport());
        if (!ok)
        {
            log.addLog("Explosion load from xml '"+filename+"' return false", WARN);
            return false;
        }
        return true;
    }
    // as in combobox
    public static Explosion getExplosion(String name)
    {
        Explosion expl = Explosion.loadExplosion(Global.mainPathPrefix+"xml"+File.separator+"explosions"+File.separator+name+".xml");
        if (expl == null) expl = new Explosion();
        return expl;
    }
    public static ArrayList<String> getExplosionList()
    {
        ArrayList<String> explosions = new  ArrayList<String>();
        String path = Global.mainPathPrefix+"xml"+File.separator+"explosions";
        ArrayList<String> files = de.malban.util.UtilityFiles.getXMLFileList(path);
        for (String name: files)
        {
            explosions.add(de.malban.util.UtilityString.replace(name.toLowerCase(), ".xml", ""));
        }
        return explosions;
    }
}
