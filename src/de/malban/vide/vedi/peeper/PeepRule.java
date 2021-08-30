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

/** One complete peephole rule!
 *
 * @author malban
 */
public class PeepRule {
    
    int order;
    boolean active=true;
    String name;
    String longName;
    String comment="";
    int finalAdd=0;
    int invalidLineBetween = 0;
    int linesTillRuleActive=0;
    ArrayList<CombinedPeepRule> rules = new ArrayList<CombinedPeepRule>();
    ArrayList<OneResult> results = new ArrayList<OneResult>();

    ArrayList<ASMLine> inputLines = null; // lines that are considered consecutive input lines for rules
    ArrayList<ASMLine> outPutOnly = null; // lines that are outputlines only (comments)
    ArrayList<ASMLine> labelLinesOnly = null; // lines that are only labels
    ArrayList<ASMLine> orgInput = null; // all lines as they were input from parent

    
    // ASM Lines and input are NOT cloned
    PeepRule doClone()
    {
        PeepRule ret = new PeepRule();
        
        ret.order = order;
        ret.active = active;
        ret.name = name;
        ret.longName = longName;
        ret.comment = comment;
        ret.finalAdd = finalAdd;
        ret.invalidLineBetween = invalidLineBetween;
        ret.linesTillRuleActive = linesTillRuleActive;
        
        for (CombinedPeepRule rule: rules)
        {
            ret.rules.add(rule.doClone());
        }
        for (OneResult result: results)
        {
            ret.results.add(result.doClone());
        }

        ret.reorderRuleList();
        ret.reorderResultList();        
        return ret;
    }
    // copy all values of this object to the other,
    // but keep internal structure
    void unClone(PeepRule ret)
    {
        ret.order = order;
        ret.active = active;
        ret.name = name;
        ret.longName = longName;
        ret.comment = comment;
        ret.finalAdd = finalAdd;
        ret.invalidLineBetween = invalidLineBetween;
        ret.linesTillRuleActive = linesTillRuleActive;
        
        
        ret.rules.clear();
        for (CombinedPeepRule rule: rules)
        {
            ret.rules.add(rule.doClone());
        }
        ret.results.clear();
        for (OneResult result: results)
        {
            ret.results.add(result.doClone());
        }

        ret.reorderRuleList();
        ret.reorderResultList();        
    }
    
    
    // "%" donates variable
    // final add allways -1, since the tested line is "automatically" added by for loop
    // this must not be calculated!
    private PeepRule()
    {
    }
    public PeepRule(int o, String n, String c, int fa, ArrayList<CombinedPeepRule> ru, ArrayList<OneResult> res)
    {
        order = o;
        name = n;
        longName = c;
        rules = ru;
        results = res;
        finalAdd = fa;
        reorderRuleList();
        reorderResultList();
    }
    
    // to be checked lines only
    public int getLoadedLines()
    {
        if (inputLines == null) return 0;
        return inputLines.size();
    }
    
    // // lower and upper case are NOT respected, some may be LOWER
    // resolves a peeper parameter placeholder with the real value
    public String getValue(String t)
    {
        
        if (!t.startsWith("%")) return t; // direct
        // if t contains a line number than it MUST be the one after the %
        if (t.length()<3) return null; // return nonsense - nothing good can come out of this!
        t=t.substring(1); // delete the %
        String lineNoS = t.substring(0,1);
        t=t.substring(1); // delete one digit lineNo (two digits not allowed)
        int lineNo = de.malban.util.UtilityString.IntX(lineNoS, -1);
        if (lineNo == -1) return null; // return nonsense - nothing good can come out of this!
        if (lineNo>inputLines.size() ) return null; // return nonsense - nothing good can come out of this!
        ASMLine l = inputLines.get(lineNo);

        if (t.startsWith("m")) // Mnemonic
            return l.mnenomic;
        if (t.startsWith("o1")) // RULE_FIRST_OPERAND_EQUALS
            return l.first;
        if (t.startsWith("o2")) // RULE_SECOND_OPERAND_EQUALS
            return l.second;
        if (t.startsWith("r1")) // RULE_FIRST_REG_CONTAINS
            return l.first;
        if (t.startsWith("r2")) // RULE_SECOND_REG_CONTAINS
            return l.second;
        if (t.startsWith("oAll")) // RULE_OPERAND_ALL_EQUALS
            return l.operandAll;
        if (t.startsWith("rsl")) // RULE_STORE_LOAD_REG_EQUALS
            return l.storeLoadReg;
        if (t.startsWith("org")) // RULE_ORG_LINE_CONTAINS
            return l.org;
        if (t.startsWith("comment")) // 
            return l.comment;
        
        return null; // nothing suitable found
    }
    
    
    // // lower and upper case are respected
    // resolves a peeper parameter placeholder with the real value
    public String getValueOrg(String t)
    {
        
        if (!t.startsWith("%")) return t; // direct
        // if t contains a line number than it MUST be the one after the %
        if (t.length()<3) return null; // return nonsense - nothing good can come out of this!
        t=t.substring(1); // delete the %
        String lineNoS = t.substring(0,1);
        t=t.substring(1); // delete one digit lineNo (two digits not allowed)
        int lineNo = de.malban.util.UtilityString.IntX(lineNoS, -1);
        if (lineNo == -1) return null; // return nonsense - nothing good can come out of this!
        if (lineNo>inputLines.size() ) return null; // return nonsense - nothing good can come out of this!
        ASMLine l = inputLines.get(lineNo);

        if (t.startsWith("m")) // Mnemonic
            return l.mnenomic;
        if (t.startsWith("o1")) // RULE_FIRST_OPERAND_EQUALS
            return l.firstOrg;
        if (t.startsWith("o2")) // RULE_SECOND_OPERAND_EQUALS
            return l.secondOrg;
        if (t.startsWith("r1")) // RULE_FIRST_REG_CONTAINS
            return l.first;
        if (t.startsWith("r2")) // RULE_SECOND_REG_CONTAINS
            return l.second;
        if (t.startsWith("oAll")) // RULE_OPERAND_ALL_EQUALS
            return l.operandAllOrg;
        if (t.startsWith("rsl")) // RULE_STORE_LOAD_REG_EQUALS
            return l.storeLoadReg;
        if (t.startsWith("org")) // RULE_ORG_LINE_CONTAINS
            return l.org;
        if (t.startsWith("comment")) // 
            return l.comment;
        
        return null; // nothing suitable found
    }
    public static PeepRule readRuleFromXML(StringBuilder xml, XMLSupport xmlSupport)
    {
        if (xml == null) return null;
        if (xml.length() == 0) return null;
        PeepRule rule = new PeepRule();
        if (rule.fromXML(xml, xmlSupport)) return rule;
        return null;
    }
    
    // saves the rule to a XML buffer
    public boolean toXML(StringBuilder s, String tag)
    {
        s.append("<").append(tag).append(">\n");
        boolean ok = true;
        
        ok = ok & XMLSupport.addElement(s, "name", name);
        ok = ok & XMLSupport.addElement(s, "longName", longName);
        ok = ok & XMLSupport.addElement(s, "order", order);
        ok = ok & XMLSupport.addElement(s, "finalAdd", finalAdd);
        ok = ok & XMLSupport.addElement(s, "active", active);
        ok = ok & XMLSupport.addElement(s, "comment", comment);
        
        for (CombinedPeepRule rule: rules)
        {
            ok = ok & rule.toXML(s, "CombinedPeepRule");
        }
        for (OneResult result: results)
        {
            ok = ok & result.toXML(s, "OneResult");
        }
        s.append("</").append(tag).append(">\n");
        return ok;        
    }
    
    // loads the rule from an xml buffer
    public boolean fromXML(StringBuilder xml, XMLSupport xmlSupport)
    {
        int errorCode = 0;
        rules = new ArrayList<CombinedPeepRule>();        

        name = xmlSupport.getStringElement("name", xml);errorCode|=xmlSupport.errorCode;
        longName = xmlSupport.getStringElement("longName", xml);errorCode|=xmlSupport.errorCode;
        comment = xmlSupport.getStringElement("comment", xml);errorCode|=xmlSupport.errorCode;
        order = xmlSupport.getIntElement("order", xml);errorCode|=xmlSupport.errorCode;
        finalAdd = xmlSupport.getIntElement("finalAdd", xml);errorCode|=xmlSupport.errorCode;
        active = xmlSupport.getBooleanElement("active", xml);errorCode|=xmlSupport.errorCode;

        CombinedPeepRule rule = null;
        do
        {
            xmlSupport.errorCode = 0;
    xmlSupport.beQuiet(true);
            rule = CombinedPeepRule.readRuleFromXML(xmlSupport.getXMLElement("CombinedPeepRule", xml), xmlSupport);
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
        
        
        OneResult result = null;
        do
        {
            xmlSupport.errorCode = 0;
    xmlSupport.beQuiet(true);
            result = OneResult.readResultFromXML(xmlSupport.getXMLElement("OneResult", xml), xmlSupport);
    xmlSupport.beQuiet(false);
            if (result != null)
            {
                errorCode|=xmlSupport.errorCode;
                results.add(result);
            }
            else
            {
                // eof is no error
                xmlSupport.errorCode = 0;
            }
        } while (result != null);
        
        
        if (errorCode!= 0) 
        {
            rules = new ArrayList<CombinedPeepRule>();  
            results = new ArrayList<OneResult>();  
            return false;
        }
        reorderRuleList();
        return true;
    }
    
    // sorts the rules by line numbers
    void reorderRuleList()
    {
        
        for (CombinedPeepRule rule: rules)
        {
            rule.reorderList();
        }
        Collections.sort(rules, new Comparator<CombinedPeepRule>() {
                @Override
                public int compare(CombinedPeepRule rule1, CombinedPeepRule rule2)
                {
                    return  rule1.line - rule2.line;
                }
            });        
    } 
    
    // orders the result by line numbers
    void reorderResultList()
    {
        Collections.sort(results, new Comparator<OneResult>() {
                @Override
                public int compare(OneResult result1, OneResult result2)
                {
                    return  result1.line - result2.line;
                }
            });        
    }   
    
    // sets 10 lines (max) from parent to this rule
    // lines are sorted to there respective internal arraylists
    public void setLines(ArrayList<ASMLine> il)
    {
        invalidLineBetween = 0;
        inputLines = new ArrayList<ASMLine>();
        labelLinesOnly = new ArrayList<ASMLine>();
        outPutOnly = new ArrayList<ASMLine>();
        orgInput = new ArrayList<ASMLine>();
        for (ASMLine l: il)
        {
            orgInput.add(l);
            if (l.label.length() != 0)
            {
                labelLinesOnly.add(l);
            }
            else
            {
                labelLinesOnly.add(null);
            }
            if (l.mnenomic.length() == 0)
            {
                outPutOnly.add(l);
            }
            else
            {
                outPutOnly.add(null);
                inputLines.add(l);
            }
        }
    }
    
    // can only be called after setLines()
    // tests if current rule is valid
    boolean isRuleValid()
    {
        boolean valid = true;
        // also test labels
        for (CombinedPeepRule rule :rules)
        {
            int line = rule.line;
            if (inputLines.size()<= line) return false;
            valid = rule.isTrue(inputLines.get(line), this);
            if (!valid) return false;
        }
        
        if (valid)
        {
            int counter = 0;
            int uid = -1;
            int lastMatchedLine = 0;
            // test if there are inner labels
            for (ASMLine org: inputLines)
            {
                counter++;
                if (counter == finalAdd+1) 
                {
                    uid = org.uid;
                    break;
                }
            }
            
            for (ASMLine org: orgInput)
            {
                lastMatchedLine++;
                if (org.mnenomic.length() == 0)
                {
                    invalidLineBetween++;
                }
                if (org.uid == uid) break;
            }            

            // check for labels
            // if there are ANY labels in the range up to finalAdd
            // than we do not apply the rule
            for (int i=0; i<lastMatchedLine; i++)
            {
                if (labelLinesOnly.get(i) != null)
                {
                    return false;
                }

            }            
        
        }
        
        return valid;
    }
    
    // adds lines to the output array list given
    // as defined by the rule
    // it is not tested whether rule is valid!
    void addResult(ArrayList<String> outLines)
    {
        // all comments in advants
        int lastMatchedLine = 0;
        int counter = 0;
        int uid = -1;
        outLines.add("; Applied peep: "+name+" ("+longName+")");
        for (ASMLine org: inputLines)
        {
            counter++;
            if (counter == finalAdd+1) 
            {
                uid = org.uid;
                break;
            }
        }
        for (ASMLine org: orgInput)
        {
            lastMatchedLine++;
            if (org.uid == uid) break;
        }
        // nur commentare ausgeben, VOR dem final add
        // as of now these can be in the wrong order
        for (int i=0; i<lastMatchedLine; i++)
        {
            if (outPutOnly.get(i) != null)      
                outLines.add(outPutOnly.get(i).org);
        }
        for (OneResult re: results)
        {
            outLines.add(re.getResultString(this));
        }
        
        // add as comment the changed originals
        for (int i=0; i<lastMatchedLine; i++)
        {
            String org = de.malban.util.UtilityString.replace(orgInput.get(i).org, "#ENR#", "$ENR$");
                    
            outLines.add("; ORG>"+org);
        }
        
    }
    
    public int getFinalAdd()
    {
        return finalAdd+invalidLineBetween;
    }
}

