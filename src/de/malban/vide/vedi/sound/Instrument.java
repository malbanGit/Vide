/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vedi.sound;

import de.malban.config.Configuration;
import de.malban.gui.panels.LogPanel;
import static de.malban.gui.panels.LogPanel.WARN;
import de.malban.util.XMLSupport;
import de.malban.vide.dissy.DASM6809;
import de.malban.vide.vecx.devices.WheelData;
import java.awt.Color;
import java.io.File;
import java.io.Serializable;
import java.util.ArrayList;

/**
 *
 * @author malban
 */
public class Instrument  implements Serializable{
    transient LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();

    public byte[] adsr = new byte[32];
    public byte[] twang = new byte[8];
    public String name="";
    
    String getADSRAsString()
    {
        StringBuilder s = new StringBuilder();
        
        s.append("$").append(String.format("%01X", adsr[0])).append(String.format("%01X", adsr[1])).append(", ");
        s.append("$").append(String.format("%01X", adsr[2])).append(String.format("%01X", adsr[3])).append(", ");
        s.append("$").append(String.format("%01X", adsr[4])).append(String.format("%01X", adsr[5])).append(", ");
        s.append("$").append(String.format("%01X", adsr[6])).append(String.format("%01X", adsr[7])).append(", ");
        s.append("$").append(String.format("%01X", adsr[8])).append(String.format("%01X", adsr[9])).append(", ");
        s.append("$").append(String.format("%01X", adsr[10])).append(String.format("%01X", adsr[11])).append(", ");
        s.append("$").append(String.format("%01X", adsr[12])).append(String.format("%01X", adsr[13])).append(", ");
        s.append("$").append(String.format("%01X", adsr[14])).append(String.format("%01X", adsr[15])).append(", ");
        s.append("$").append(String.format("%01X", adsr[16])).append(String.format("%01X", adsr[17])).append(", ");
        s.append("$").append(String.format("%01X", adsr[18])).append(String.format("%01X", adsr[19])).append(", ");
        s.append("$").append(String.format("%01X", adsr[20])).append(String.format("%01X", adsr[21])).append(", ");
        s.append("$").append(String.format("%01X", adsr[22])).append(String.format("%01X", adsr[23])).append(", ");
        s.append("$").append(String.format("%01X", adsr[24])).append(String.format("%01X", adsr[25])).append(", ");
        s.append("$").append(String.format("%01X", adsr[26])).append(String.format("%01X", adsr[27])).append(", ");
        s.append("$").append(String.format("%01X", adsr[28])).append(String.format("%01X", adsr[29])).append(", ");
        s.append("$").append(String.format("%01X", adsr[30])).append(String.format("%01X", adsr[31])).append("");
        return s.toString();
    }
    String getTWANGAsString()
    {
        StringBuilder s = new StringBuilder();
        s.append("$").append(String.format("%02X", twang[0])).append(", ");
        s.append("$").append(String.format("%02X", twang[1])).append(", ");
        s.append("$").append(String.format("%02X", twang[2])).append(", ");
        s.append("$").append(String.format("%02X", twang[3])).append(", ");
        s.append("$").append(String.format("%02X", twang[4])).append(", ");
        s.append("$").append(String.format("%02X", twang[5])).append(", ");
        s.append("$").append(String.format("%02X", twang[6])).append(", ");
        s.append("$").append(String.format("%02X", twang[7])).append("");
        return s.toString();
    }
    
    void setADSR(String a)
    {
        String[] numbers = a.split(",");
        int count =0 ;
        for (int i=0; i<numbers.length; i++)
        {
            String ss = numbers[i];
            ss = ss.trim();
            if (ss.length()<=0) continue;
            int value= DASM6809.toNumber(ss)& 0xff;
            
            adsr[count*2+0] = (byte)(value>>4);
            adsr[count*2+1] = (byte)(value&0xf);
            count++;
        }        
    }
    void setTWANG(String t)
    {
        String[] numbers = t.split(",");
        int count =0 ;
        for (int i=0; i<numbers.length; i++)
        {
            String ss = numbers[i];
            ss = ss.trim();
            if (ss.length()<=0) continue;
            int value= DASM6809.toNumber(ss)& 0xff;
            twang[count++] = (byte)(value);
            if (count>=8) break;
        }        
    }    
    public boolean toXML(StringBuilder s, String tag)
    {
        s.append("<").append(tag).append(">\n");
        boolean ok = true;
        ok = ok & XMLSupport.addElement(s, "name", name);
        ok = ok & XMLSupport.addElement(s, "adsr", getADSRAsString());
        ok = ok & XMLSupport.addElement(s, "twang", getTWANGAsString());
        s.append("</").append(tag).append(">\n");
        return ok;        
    }

    // a xml "list" of an arbitrary number of GFXVectors
    public boolean fromXML(StringBuilder xml, XMLSupport xmlSupport)
    {
        int errorCode = 0;
        name= xmlSupport.getStringElement("name", xml);errorCode|=xmlSupport.errorCode;
        String adsr= xmlSupport.getStringElement("adsr", xml);errorCode|=xmlSupport.errorCode;
        String twang= xmlSupport.getStringElement("twang", xml);errorCode|=xmlSupport.errorCode;

        setADSR(adsr);
        setTWANG(twang);
        if (errorCode!= 0) return false;
        return true;
    }
    
    public boolean saveAsXML(String filename)
    {
        StringBuilder xml = new StringBuilder();

        boolean ok = toXML(xml, "Instrument");
        if (!ok)
        {
            log.addLog("Instrument save 'toXML' return false", WARN);
            return false;
        }
        ok = de.malban.util.UtilityFiles.createTextFile(filename, xml.toString());
        if (!ok)
        {
            log.addLog("Instrument create file '"+filename+"' return false", WARN);
            return false;
        }
        return true; 
    }
    
    public static Instrument loadInstrument(String filename)
    {
        Instrument w = new Instrument();
        if (w.loadFromXML(filename)) return w;
        return null;
    }
    
    public boolean loadFromXML(String filename)
    {
        String xml = de.malban.util.UtilityString.readTextFileToOneString(new File (filename));
        boolean ok = fromXML(new StringBuilder(xml), new XMLSupport());
        if (!ok)
        {
            log.addLog("Instrument load from xml '"+filename+"' return false", WARN);
            return false;
        }
        return true;
    }
    // as in combobox
    public static Instrument getInstrument(String name)
    {
        Instrument instr = Instrument.loadInstrument("xml"+File.separator+"instruments"+File.separator+name+".xml");
        if (instr == null) instr = new Instrument();
        return instr;
    }
    public static ArrayList<String> getInstrumentList()
    {
        ArrayList<String> instruments = new  ArrayList<String>();
        String path = "xml"+File.separator+"instruments";
        ArrayList<String> files = de.malban.util.UtilityFiles.getXMLFileList(path);
        for (String name: files)
        {
            instruments.add(de.malban.util.UtilityString.replace(name.toLowerCase(), ".xml", ""));
        }
        return instruments;
    }
}
