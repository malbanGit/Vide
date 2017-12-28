/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vedi.peeper;

import de.malban.util.XMLSupport;
import de.malban.vide.dissy.DASM6809;

/**
 *
 * @author malban
 */
public class OnePeepRule {
    
    public static final int RULE_NONE = 0;
    public static final int RULE_MNEMONIC_CONTAINS = 1;
    public static final int RULE_FIRST_OPERAND_EQUALS = 2;
    public static final int RULE_SECOND_OPERAND_EQUALS = 3;
    public static final int RULE_FIRST_REG_CONTAINS = 4;
    public static final int RULE_SECOND_REG_CONTAINS = 5;
    public static final int RULE_IS_LOAD = 6;
    public static final int RULE_OPERAND_ALL_EQUALS = 7;
    public static final int RULE_OPERAND_ALL_CONTAINS = 8;
    public static final int RULE_STORE_LOAD_REG_EQUALS = 9;
    public static final int RULE_ORG_LINE_CONTAINS = 10;
    public static final int RULE_IS_STORE = 11;
    public static final int RULE_IS_LEA = 12;
    public static final int RULE_FIRST_REG_NOTCONTAINS = 13;
    public static final int RULE_SECOND_REG_NOTCONTAINS = 14;
    public static final int RULE_NO_INDEX_CHANGE = 15;
    public static final int RULE_STORE_LOAD_REG_NOTEQUALS = 16;
    public static final int RULE_FIRST_OPERAND_NOTEQUALS = 17;
    public static final int RULE_SECOND_OPERAND_NOTEQUALS = 18;
    public static final int RULE_NO_BRANCH = 19;
    public static final int RULE_NO_REGISTER_CHANGE = 20;
    public static final int RULE_IS_IMMEDIATE = 21;
    public static final int RULE_IS_EXTENED = 22;
    public static final int RULE_PAGE_EQUALS = 23;
    public static final int RULE_FIRST_OPERAND_STARTSWITH = 24;
    
    
    public static final String[] TYPES = {
        "RULE_NONE",
        "RULE_MNEMONIC_CONTAINS",
        "RULE_FIRST_OPERAND_EQUALS",
        "RULE_SECOND_OPERAND_EQUALS",
        "RULE_FIRST_REG_CONTAINS",
        "RULE_SECOND_REG_CONTAINS",
        "RULE_IS_LOAD",
        "RULE_OPERAND_ALL_EQUALS",
        "RULE_OPERAND_ALL_CONTAINS",
        "RULE_STORE_LOAD_REG_EQUALS",
        "RULE_ORG_LINE_CONTAINS",
        "RULE_IS_STORE",
        "RULE_IS_LEA",
        "RULE_FIRST_REG_NOTCONTAINS",
        "RULE_SECOND_REG_NOTCONTAINS",
        "RULE_NO_INDEX_CHANGE",
        "RULE_STORE_LOAD_REG_NOTEQUALS",
        "RULE_FIRST_OPERAND_NOTEQUALS",
        "RULE_SECOND_OPERAND_NOTEQUALS",
        "RULE_NO_BRANCH",
        "RULE_NO_REGISTER_CHANGE",
        "RULE_IS_IMMEDIATE",
        "RULE_IS_EXTENED",
        "RULE_PAGE_EQUALS",
        "RULE_FIRST_OPERAND_STARTSWITH"
        };
    int type=0;
    String compareValue ="";
    int order = 0;


    // ASM Lines and input are NOT cloned
    OnePeepRule doClone()
    {
        OnePeepRule ret = new OnePeepRule();
        
        ret.type = type;
        ret.compareValue = compareValue;
        ret.order = order;
        return ret;
    }
            
    private OnePeepRule() { }
    public OnePeepRule(int t, int o)
    {
        type = t;
        compareValue = "";
        order = o;
    }
    public OnePeepRule(int t, String c, int o)
    {
        type = t;
        compareValue = c;
        order = o;
    }
    
    boolean isTrue(ASMLine line, PeepRule r)
    {
        String realValue = r.getValue(compareValue).toLowerCase();
        // rule none is true
        if (type == RULE_NONE)
            return true;
        if (realValue == null)
            return false;
        switch (type)
        {
            case RULE_MNEMONIC_CONTAINS:
            {
                return line.mnenomic.contains(realValue);
            }
            case RULE_FIRST_OPERAND_EQUALS:
            {
                return line.first.equals(realValue);
            }
            case RULE_FIRST_OPERAND_STARTSWITH:
            {
                return line.first.startsWith(realValue);
            }
            case RULE_SECOND_OPERAND_EQUALS:
            {
                return line.second.equals(realValue);
            }
            case RULE_FIRST_OPERAND_NOTEQUALS:
            {
                return !line.first.equals(realValue);
            }
            case RULE_SECOND_OPERAND_NOTEQUALS:
            {
                return !line.second.equals(realValue);
            }
            
            case RULE_FIRST_REG_CONTAINS:
            {
                return line.firstReg.contains(realValue);
            }
            case RULE_SECOND_REG_CONTAINS:
            {
                return line.secondReg.contains(realValue);
            }
            case RULE_FIRST_REG_NOTCONTAINS:
            {
                return !line.firstReg.contains(realValue);
            }
            case RULE_SECOND_REG_NOTCONTAINS:
            {
                return !line.secondReg.contains(realValue);
            }
            case RULE_IS_LOAD:
            {
                return line.isLoad;
            }
            case RULE_OPERAND_ALL_EQUALS:
            {
                return line.operandAll.equals(realValue);
            }
            case RULE_OPERAND_ALL_CONTAINS:
            {
                return line.operandAll.contains(realValue);
            }
            case RULE_STORE_LOAD_REG_EQUALS:
            {
                return line.storeLoadReg.equals(realValue);
            }
            case RULE_STORE_LOAD_REG_NOTEQUALS:
            {
                return !line.storeLoadReg.equals(realValue);
            }
            case RULE_ORG_LINE_CONTAINS:
            {
                return line.org.contains(realValue);
            }
            case RULE_IS_STORE:
            {
                return line.isStore;
            }
            case RULE_IS_LEA:
            {
                return line.isLea;
            }
            case RULE_NO_INDEX_CHANGE:
            {
                return !line.isIndexChange;
            }
            case RULE_NO_BRANCH:
            {
                return !line.isBranch;
            }
            case RULE_NO_REGISTER_CHANGE:
            {
                return line.isRegSave;
            }
            case RULE_IS_IMMEDIATE:
            {
                return line.isImmediate;
            }
            case RULE_IS_EXTENED:
            {
                return line.isExtended;
            }
            case RULE_PAGE_EQUALS:
            {
                return line.page == (DASM6809.toNumber(realValue));
            }
            
        }
        return false;
    }
    public static OnePeepRule readRuleFromXML(StringBuilder xml, XMLSupport xmlSupport)
    {
        if (xml == null) return null;
        if (xml.length() == 0) return null;
        OnePeepRule rule = new OnePeepRule();
        if (rule.fromXML(xml, xmlSupport)) return rule;
        return null;
    }

    public boolean toXML(StringBuilder s, String tag)
    {
        s.append("<").append(tag).append(">\n");
        boolean ok = true;
        ok = ok & XMLSupport.addElement(s, "type", type);
        ok = ok & XMLSupport.addElement(s, "order", order);
        ok = ok & XMLSupport.addElement(s, "compareValue", compareValue);
        s.append("</").append(tag).append(">\n");
        return ok;        
    }
    public boolean fromXML(StringBuilder xml, XMLSupport xmlSupport)
    {
        int errorCode = 0;
        type = xmlSupport.getIntElement("type", xml);errorCode|=xmlSupport.errorCode;
        order = xmlSupport.getIntElement("order", xml);errorCode|=xmlSupport.errorCode;
        compareValue = xmlSupport.getStringElement("compareValue", xml);errorCode|=xmlSupport.errorCode;
        if (errorCode!= 0) return false;
        return true;
    }
}
