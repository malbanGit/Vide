/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vedi.peeper;

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
    
    String[] types = {
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
        "RULE_ORG_LINE_CONTAINS"
        };
    int type=0;
    String compareValue ="";
    public OnePeepRule(int t, String c)
    {
        type = t;
        compareValue = c;
    }
    
    boolean isTrue(ASMLine line, PeepRule r)
    {
        boolean ret = true;
        String realValue = r.getCheckValue(compareValue);
        switch (type)
        {
            case RULE_NONE:
            {
                // rule none is true
                return true;
            }
            case RULE_MNEMONIC_CONTAINS:
            {
                return line.mnenomic.contains(realValue);
            }
            case RULE_FIRST_OPERAND_EQUALS:
            {
                return line.first.equals(realValue);
            }
            case RULE_SECOND_OPERAND_EQUALS:
            {
                return line.second.equals(realValue);
            }
            case RULE_FIRST_REG_CONTAINS:
            {
                return line.firstReg.contains(realValue);
            }
            case RULE_SECOND_REG_CONTAINS:
            {
                return line.secondReg.contains(realValue);
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
            case RULE_ORG_LINE_CONTAINS:
            {
                return line.org.contains(realValue);
            }
        }
        return false;
    }
}
