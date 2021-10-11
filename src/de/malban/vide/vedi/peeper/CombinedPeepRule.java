/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vedi.peeper;

import de.malban.util.XMLSupport;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;

/**
 *
 * @author Malban
 */
public class CombinedPeepRule {
    
    public static final int COMBINE_UNKOWN = -1;
    public static final int COMBINE_AND = 0;
    public static final int COMBINE_OR = 1;
    // 
    ArrayList<OnePeepRule> rules = new ArrayList<OnePeepRule>();
    
    
    int combiner = COMBINE_UNKOWN;
    int line = 0;
    
    // ASM Lines and input are NOT cloned
    CombinedPeepRule doClone()
    {
        CombinedPeepRule ret = new CombinedPeepRule();
        
        ret.combiner = combiner;
        ret.line = line;
        
        for (OnePeepRule rule: rules)
        {
            ret.rules.add(rule.doClone());
        }

        ret.reorderList();
        return ret;
    }
        
    CombinedPeepRule(){}
    public CombinedPeepRule(OnePeepRule r1, int o)
    {
        rules.add(r1);
        line = o;
        combiner = COMBINE_AND;
    }
    public CombinedPeepRule(OnePeepRule r1, int c, int o)
    {
        rules.add(r1);
        line = o;
        combiner = c;
    }
    public CombinedPeepRule(OnePeepRule r1, OnePeepRule r2, int c, int o)
    {
        rules.add(r1);
        rules.add(r2);
        line = o;
        combiner = c;
    }
    public CombinedPeepRule(OnePeepRule r1, OnePeepRule r2, OnePeepRule r3, int c, int o)
    {
        rules.add(r1);
        rules.add(r2);
        rules.add(r3);
        line = o;
        combiner = c;
    }
    public CombinedPeepRule(OnePeepRule r1, OnePeepRule r2, OnePeepRule r3, OnePeepRule r4, int c, int o)
    {
        rules.add(r1);
        rules.add(r2);
        rules.add(r3);
        rules.add(r4);
        line = o;
        combiner = c;
    }
    public CombinedPeepRule(OnePeepRule r1, OnePeepRule r2, OnePeepRule r3, OnePeepRule r4, OnePeepRule r5, int c, int o)
    {
        rules.add(r1);
        rules.add(r2);
        rules.add(r3);
        rules.add(r4);
        rules.add(r5);
        line = o;
        combiner = c;
    }
    public CombinedPeepRule(ArrayList<OnePeepRule> r, int c, int o)
    {
        rules = r;
        line = o;
        combiner = c;
    }
    
    // comment only
    public boolean isNotRelevant(ASMLine line)
    {
        return (line.mnenomic.length() == 0) && (line.label.length() == 0);
    }
    boolean isTrue(ASMLine line, PeepRule parent)
    {
        if (combiner == COMBINE_AND)
        {
            for (OnePeepRule r: rules)
                if (!r.isTrue(line, parent)) return false;
            return true;
        }
        if (combiner == COMBINE_OR)
        {
            for (OnePeepRule r: rules)
                if (r.isTrue(line, parent)) return true;
            return false;
        }
        return false;
    }

    public static CombinedPeepRule readRuleFromXML(StringBuilder xml, XMLSupport xmlSupport)
    {
        if (xml == null) return null;
        if (xml.length() == 0) return null;
        CombinedPeepRule rule = new CombinedPeepRule();
        if (rule.fromXML(xml, xmlSupport)) return rule;
        return null;
    }

    public boolean toXML(StringBuilder s, String tag)
    {
        s.append("<").append(tag).append(">\n");
        boolean ok = true;
        
        ok = ok & XMLSupport.addElement(s, "combiner", combiner);
        ok = ok & XMLSupport.addElement(s, "line", line);
        for (OnePeepRule rule: rules)
        {
            ok = ok & rule.toXML(s, "OneRule");
        }
        s.append("</").append(tag).append(">\n");
        return ok;        
    }
    
    public boolean fromXML(StringBuilder xml, XMLSupport xmlSupport)
    {
        int errorCode = 0;
        rules = new ArrayList<OnePeepRule>();        

        combiner = xmlSupport.getIntElement("combiner", xml);errorCode|=xmlSupport.errorCode;
        line = xmlSupport.getIntElement("line", xml);errorCode|=xmlSupport.errorCode;

        OnePeepRule rule = null;
        do
        {
            xmlSupport.errorCode = 0;
            xmlSupport.beQuiet(true);
            rule = OnePeepRule.readRuleFromXML(xmlSupport.getXMLElement("OneRule", xml), xmlSupport);
            xmlSupport.beQuiet(false);
            if (rule != null)
            {
                errorCode|=xmlSupport.errorCode;
                rules.add(rule);
            }
            else
            {
                // eof is no error
                xmlSupport.errorCode = 0;
            }
        } while (rule != null);
        
        if (errorCode!= 0) 
        {
            rules = new ArrayList<OnePeepRule>();   
            return false;
        }
        reorderList();
        return true;
    }
    
    void reorderList()
    {
        Collections.sort(rules, new Comparator<OnePeepRule>() {
                @Override
                public int compare(OnePeepRule rule1, OnePeepRule rule2)
                {
                    return  rule1.order - rule2.order;
                }
            });        
    }
}
    
