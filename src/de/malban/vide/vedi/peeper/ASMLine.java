/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vedi.peeper;

import de.malban.vide.assy.Comment;
import de.malban.vide.dissy.DASM6809;
import static de.malban.vide.vedi.VediPanel.removeEmpty;

/**
 *
 * @author malban
 */
public class ASMLine 
{
    private static int UID = 0;
    public final int uid=UID++;
    public String org;
    public String clean= "";

    public String mnenomic="";
    public String first="";
    public String second="";
    public String firstOrg="";
    public String secondOrg="";
    public String firstReg="";
    public String operandAllOrg="";
    public String operandAll="";
    public String secondReg="";
    public String label="";
    public String rest ="";
    public String comment = ""; // with ";"

    public boolean isStore = false;
    public boolean isLoad = false;
    public boolean isLea = false;
    public boolean isImmediate = false;
    public boolean isBranch = false;
    public boolean isRegSave = false;
    public boolean isIndexChange = false;
    public boolean isExtended = false;
    public int page = -1;
    public String storeLoadReg = ""+uid;

    public ASMLine(String s)
    {
        org = s;
        clean = Comment.removeEndOfLineComment(org);
        comment = de.malban.util.UtilityString.replace(org, clean, "");


        String tmp = de.malban.util.UtilityString.replaceWhiteSpaces(clean, " ");
        tmp = de.malban.util.UtilityString.replace(tmp, "  ", "");
        String[] split = tmp.split(" ");
        String[] splitOrg;
        if (split.length == 0) return;
        if (split[0].trim().length()!=0) label = split[0].trim();
        label = de.malban.util.UtilityString.replace(label, ":", "");

        split[0] = null;
        split = removeEmpty(split);
        if (split.length == 0) return;
        mnenomic = split[0].toLowerCase();

        if (mnenomic.startsWith("lb")) isBranch = true;
        if (mnenomic.startsWith("b")) isBranch = true;
        if (mnenomic.startsWith("j")) isBranch = true;
        if (mnenomic.startsWith("rt")) isBranch = true;
        if (mnenomic.startsWith("sw")) isBranch = true;
        if (mnenomic.startsWith("sy")) isBranch = true;

        if (mnenomic.equals("dec")) isRegSave = true;
        if (mnenomic.equals("inc")) isRegSave = true;
        if (mnenomic.equals("clr")) isRegSave = true;
        if (mnenomic.equals("asl")) isRegSave = true;
        if (mnenomic.equals("lsl")) isRegSave = true;
        if (mnenomic.equals("rol")) isRegSave = true;
        if (mnenomic.equals("ror")) isRegSave = true;
        if (mnenomic.equals("asr")) isRegSave = true;
        if (mnenomic.equals("com")) isRegSave = true;
        if (mnenomic.equals("lsr")) isRegSave = true;
        if (mnenomic.equals("neg")) isRegSave = true;
        if (mnenomic.equals("nop")) isRegSave = true;


        if (mnenomic.startsWith("st"))
        {
            isStore = true;
            storeLoadReg = mnenomic.substring(2);
        }
        if (mnenomic.startsWith("ld"))
        {
            isLoad = true;
            storeLoadReg = mnenomic.substring(2);
        }
        if (mnenomic.startsWith("lea"))
        {
            isLea = true;
            storeLoadReg = mnenomic.substring(3);
        }


        split[0] = null;
        split = removeEmpty(split);
        if (split.length == 0) return;

        String operand = "";
        for (String ss: split)
        {
            operand = operand +ss+"";
        }
        operand.trim();
        operandAllOrg = operand;
        operandAll = operand.toLowerCase();
        boolean isNumber = de.malban.util.UtilityString.isDecNumber(operandAll) || de.malban.util.UtilityString.isHexNumber(operandAll);
        isExtended = isNumber && (!operandAll.contains(","))&& (!operandAll.contains("["));
        if (isExtended)
        {
            int number = DASM6809.toNumber(operandAll)&0xffff;
            page = number/256;
        }
        
        

        if (operandAll.startsWith("#")) isImmediate = true;

        split = operand.split(",");
        split = removeEmpty(split);
        if (split.length == 0) return;
        firstOrg = split[0];
        first = split[0].toLowerCase();

        if (first.contains("a")) firstReg = "abd";
        if (first.contains("b")) firstReg = "abd";
        if (first.contains("d")) firstReg = "abd";
        if (first.contains("x")) firstReg = "x";
        if (first.contains("y")) firstReg = "y";
        if (first.contains("u")) firstReg = "u";
        if (first.contains("s")) firstReg = "s";
        if (first.contains("pc")) firstReg = "pc";

        split[0] = null;
        split = removeEmpty(split);
        if (split.length == 0) 
        {
            return;
        }
        secondOrg = split[0];
        second = split[0].toLowerCase();
        second = de.malban.util.UtilityString.replace(second, " ", "");

        if (second.contains("a")) secondReg = "abd";
        if (second.contains("b")) secondReg = "abd";
        if (second.contains("d")) secondReg = "abd";
        if (second.contains("x")) secondReg = "x";
        if (second.contains("y")) secondReg = "y";
        if (second.contains("u")) secondReg = "u";
        if (second.contains("s")) secondReg = "s";
        if (second.contains("pc")) secondReg = "pc";
        
        
        if ((secondReg.equals("x")) || (secondReg.equals("s")) ||(secondReg.equals("u")) ||(secondReg.equals("y")) )
        {
            if (second.contains("+") || second.contains("-")) isIndexChange = true;
        }
        
        split[0] = null;
        split = removeEmpty(split);
        if (split.length == 0) return;
        for (String ss: split)
        {
            rest = rest +ss+"";
        }
    }
}    

