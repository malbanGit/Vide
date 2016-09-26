/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.util;

import de.malban.config.Configuration;
import de.malban.gui.panels.LogPanel;
import static de.malban.gui.panels.LogPanel.INFO;

/**
 *
 * @author malban
 */
public class XMLSupport
{
    // xml structures are given as input via a stringbuffer
    // if the tag was found the contents of the tag is returned
    // AND the tags+contents is removed from the given String buffer!
    
    
    LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
    public static final int OK = 0;
    public static final int ELEMENT_START_NOT_FOUND = 1;
    public static final int ELEMENT_END_NOT_FOUND = 2;
    public static final int ELEMENT_NOT_CAST_DOUBLE = 4;
    public static final int ELEMENT_NOT_CAST_INT = 8;
    public static final int ELEMENT_NOT_CAST_BOOLEAN = 16;

    public int errorCode = OK;
    public double getDoubleElement(String tag, StringBuilder xml)
    {
        errorCode = 0;
        double ret = 0;
        String found = getElement(tag, xml);
        try
        {
            ret = Double.parseDouble(found);
        }
        catch (Throwable e)
        {
            errorCode+=ELEMENT_NOT_CAST_DOUBLE;
            log.addLog("getDoubleElement(): cannot cast to double "+tag+" found", INFO);
        }
        return ret;
    }
    public int getIntElement(String tag, StringBuilder xml)
    {
        errorCode = 0;
        int ret = 0;
        String found = getElement(tag, xml);
        try
        {
            ret = Integer.parseInt(found);
        }
        catch (Throwable e)
        {
            errorCode+=ELEMENT_NOT_CAST_INT;
            log.addLog("getIntElement(): cannot cast to int "+tag+" found", INFO);
        }
        return ret;
    }
    public boolean getBooleanElement(String tag, StringBuilder xml)
    {
        errorCode = 0;
        boolean ret = false;
        String found = getElement(tag, xml);
        try
        {
            ret = Boolean.parseBoolean(found);
        }
        catch (Throwable e)
        {
            errorCode+=ELEMENT_NOT_CAST_BOOLEAN;
            log.addLog("getBooleanElement(): cannot cast to boolean "+tag+" found", INFO);
        }
        return ret;
    }
    // to be consistent with naming
    public String getStringElement(String tag, StringBuilder xml)
    {
        return getStringElement(tag, xml, true);
    }
    // to be consistent with naming
    public String getStringElement(String tag, StringBuilder xml, boolean doWarn)
    {
        return getElement(tag, xml, doWarn);
    }
    // element is "decoded"
    public String getElement(String tag, StringBuilder xml)
    {
        return getElement( tag, xml, true );
    }
    // element is "decoded"
    public String getElement(String tag, StringBuilder xml, boolean doWarn)
    {
        StringBuilder element = getXMLElement(tag, xml, doWarn);
        if (element != null)
            return UtilityString.fromXML(element.toString().trim());
        return null;
    }
    // element is NOT decoded
    // xmlBuffer is reduced 
    public StringBuilder getXMLElement(String tag, StringBuilder xml)
    {
        return getXMLElement( tag,  xml, true);
    }
    public StringBuilder getXMLElement(String tag, StringBuilder xml, boolean doWarn)
    {
        int startPos = xml.toString().toUpperCase().indexOf("<"+tag.toUpperCase()+">");
        int startElementLength = ("<"+tag.toUpperCase()+">").length(); 
        if (startPos<0)
        {
            errorCode+=ELEMENT_START_NOT_FOUND;
            if (doWarn)
            {
                log.addLog("getXMLElement(): StartTag not found: "+tag, INFO);
            }
            return null;
        }
        
        int endPos = xml.toString().toUpperCase().indexOf("</"+tag.toUpperCase()+">");
        if (endPos<0)
        {
            errorCode+=ELEMENT_END_NOT_FOUND;
            log.addLog("getXMLElement(): EndTag not found: "+tag, INFO);
            return null;
        }
        StringBuilder elementDataString = new StringBuilder(xml.substring(startPos+startElementLength, endPos));
        xml.delete(startPos, endPos+(startElementLength+1));
        return elementDataString;
    }
    private static boolean ensureTagOk(String tag)
    {
        return true;
    }
    // returns true, when done
    // false when not
    public static boolean addElement(StringBuilder s, String tag, double value)
    {
        boolean ok = ensureTagOk(tag);
        if (!ok) return false;
        s.append("<").append(tag).append(">\n");
        s.append(value);
        s.append("</").append(tag).append(">\n");
        return true;
    }
    public static boolean addElement(StringBuilder s, String tag, int value)
    {
        boolean ok = ensureTagOk(tag);
        if (!ok) return false;
        s.append("<").append(tag).append(">\n");
        s.append(value);
        s.append("</").append(tag).append(">\n");
        return true;
    }
    public static boolean addElement(StringBuilder s, String tag, boolean value)
    {
        boolean ok = ensureTagOk(tag);
        if (!ok) return false;
        s.append("<").append(tag).append(">\n");
        s.append(value);
        s.append("</").append(tag).append(">\n");
        return true;
    }
    public static boolean addElement(StringBuilder s, String tag, String value)
    {
        boolean ok = ensureTagOk(tag);
        if (!ok) return false;
        s.append("<").append(tag).append(">\n");
        s.append(UtilityString.toXML(value));
        s.append("</").append(tag).append(">\n");
        return true;
    }
    public static boolean hasTag(String tag, StringBuilder xml)
    {
        int startPos = xml.toString().toUpperCase().indexOf("<"+tag.toUpperCase()+">");
        return startPos != -1;
    }
    // returns a "sub"-xml element
    // updates the xmlBuffer (removes the element
    public StringBuilder removeTag(String tag, StringBuilder xmlBuffer)
    {
        errorCode = 0;
        StringBuilder xmlElement = new StringBuilder();
        String xml = xmlBuffer.toString().toUpperCase();
        
        int startPos = xml.indexOf("<"+tag.toUpperCase()+">");
        int startElementLength = ("<"+tag.toUpperCase()+">").length(); 
        if (startPos<0)
        {
            // since this replaces the
            // "hasTag" method
            // it should not throw warnings...
//            log.addLog("removeTag(): StartTag not found: "+tag, INFO);
//            errorCode+=ELEMENT_START_NOT_FOUND;
            return null;
        }
        
        int endPos = xml.indexOf("</"+tag.toUpperCase()+">");
        if (endPos<0)
        {
            log.addLog("removeTag(): EndTag not found: "+tag, INFO);
            errorCode+=ELEMENT_END_NOT_FOUND;
            return null;
        }
        xmlElement.append(xmlBuffer.substring(startPos+startElementLength, endPos));
        xmlBuffer.delete(startPos, endPos+(startElementLength+1));
        return xmlElement;
    }
}
