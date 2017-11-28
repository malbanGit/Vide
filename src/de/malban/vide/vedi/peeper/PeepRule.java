/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vedi.peeper;

import java.util.ArrayList;

/**
 *
 * @author malban
 */
public class PeepRule {
    
    String name;
    String comment;
    ArrayList<CombinedPeepRule> rules = new ArrayList<CombinedPeepRule>();
    ArrayList<OneResult> result = new ArrayList<OneResult>();
    ArrayList<String> lines = new ArrayList<String>();
    // "%" donates variable
    public String getCheckValue(String t)
    {
        if (!t.startsWith("%")) return t; // direct
        // if t contains a line number than it MUST be the one after the %
        if (t.length()<3) return "ß908uiorw2"; // return nonsense - nothing good can come out of this!
        t=t.substring(1); // delete the %
        String lineNoS = t.substring(0,1);
        t=t.substring(1); // delete the %
        int lineNo = de.malban.util.UtilityString.IntX(t, -1);
        if (lineNo == -1) return "ß908uiorw2"; // return nonsense - nothing good can come out of this!
        if (lineNo>lines.size() ) return "ß908uiorw2"; // return nonsense - nothing good can come out of this!
        ASMLine l = new ASMLine(lines.get(lineNo));

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
        
        return "ß908uiorw2"; // nothing suitable found
    }
}
