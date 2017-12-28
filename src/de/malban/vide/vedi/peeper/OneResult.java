/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vedi.peeper;

import de.malban.util.XMLSupport;

/**
 *
 * @author malban
 */
public class OneResult {
    String resultString;
    int line;
    private OneResult(){}
    public OneResult(int l, String r)
    {
        line = l;
        resultString = r;
    }
    
    // ASM Lines and input are NOT cloned
    OneResult doClone()
    {
        OneResult ret = new OneResult();
        
        ret.resultString = resultString;
        ret.line = line;

        return ret;
    }
        
    
    public static OneResult readResultFromXML(StringBuilder xml, XMLSupport xmlSupport)
    {
        if (xml == null) return null;
        if (xml.length() == 0) return null;
        OneResult result = new OneResult();
        if (result.fromXML(xml, xmlSupport)) return result;
        return null;
    }

    public boolean toXML(StringBuilder s, String tag)
    {
        s.append("<").append(tag).append(">\n");
        boolean ok = true;
        ok = ok & XMLSupport.addElement(s, "resultString", resultString);
        ok = ok & XMLSupport.addElement(s, "line", line);
        s.append("</").append(tag).append(">\n");
        return ok;        
    }
    public boolean fromXML(StringBuilder xml, XMLSupport xmlSupport)
    {
        int errorCode = 0;
        line = xmlSupport.getIntElement("line", xml);errorCode|=xmlSupport.errorCode;
        resultString = xmlSupport.getStringElement("resultString", xml);errorCode|=xmlSupport.errorCode;
        if (errorCode!= 0) return false;
        return true;
    }
    
    String getResultString(PeepRule r)
    {
        String res = resultString;
        
        for (int i=0;i<r.getLoadedLines();i++)
        {
            String what="%"+i+"o1";

            // e1 = new OneResult(0,"%0replace:ldb:lda");
            if (res.contains("replace"))
            {
                what="%"+i+"org";
                res = r.getValue(what);
                try
                {
                    String[] split = resultString.split(":");
                    String from=split[1];
                    String to=split[2];
                    res = de.malban.util.UtilityString.replace(res, from, to);
                }
                catch (Throwable e)
                {
                    
                }
                continue;
            }
            
            String with = r.getValueOrg(what);
            if (with != null) res = de.malban.util.UtilityString.replace(res, what, with);

            what="%"+i+"m"; with = r.getValue(what);
            if (with != null) 
                res = de.malban.util.UtilityString.replace(res, what, with);

            what="%"+i+"o2"; with = r.getValue(what);
            if (with != null) res = de.malban.util.UtilityString.replace(res, what, with);

            what="%"+i+"r1"; with = r.getValue(what);
            if (with != null) res = de.malban.util.UtilityString.replace(res, what, with);

            what="%"+i+"r2"; with = r.getValue(what);
            if (with != null) res = de.malban.util.UtilityString.replace(res, what, with);

            what="%"+i+"oAll"; with = r.getValue(what);
            if (with != null) res = de.malban.util.UtilityString.replace(res, what, with);

            what="%"+i+"rsl"; with = r.getValue(what);
            if (with != null) res = de.malban.util.UtilityString.replace(res, what, with);

            what="%"+i+"org"; with = r.getValue(what);
            if (with != null) res = de.malban.util.UtilityString.replace(res, what, with);

            what="%"+i+"comment"; with = r.getValue(what);
            if (with != null) res = de.malban.util.UtilityString.replace(res, what, with);
        }
        
        return res;
    }
}
