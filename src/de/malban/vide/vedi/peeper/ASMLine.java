/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vedi.peeper;

import de.malban.vide.assy.Comment;
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
    public String firstReg="";
    public String secondReg="";
    public String label="";
    public String rest ="";
    public String operandAll="";
    public String comment = ""; // with ";"

    public boolean isStore = false;
    public boolean isLoad = false;
    public boolean isLea = false;
    public boolean isImmediate = false;
    public boolean branch = false;
    public boolean regSave = false;
    public String storeLoadReg = ""+uid;

    public ASMLine(String s)
    {
        org = s;
        clean = Comment.removeEndOfLineComment(org);
        comment = de.malban.util.UtilityString.replace(org, clean, "");


        String tmp = de.malban.util.UtilityString.replaceWhiteSpaces(clean, " ");
        tmp = de.malban.util.UtilityString.replace(tmp, "  ", "");
        String[] split = tmp.split(" ");
        if (split.length == 0) return;
        if (split[0].trim().length()!=0) label = split[0].trim();
        label = de.malban.util.UtilityString.replace(label, ":", "");

        split[0] = null;
        split = removeEmpty(split);
        if (split.length == 0) return;
        mnenomic = split[0].toLowerCase();

        if (mnenomic.startsWith("lb")) branch = true;
        if (mnenomic.startsWith("b")) branch = true;
        if (mnenomic.startsWith("j")) branch = true;
        if (mnenomic.startsWith("rt")) branch = true;
        if (mnenomic.startsWith("sw")) branch = true;
        if (mnenomic.startsWith("sy")) branch = true;

        if (mnenomic.equals("dec")) regSave = true;
        if (mnenomic.equals("inc")) regSave = true;
        if (mnenomic.equals("clr")) regSave = true;
        if (mnenomic.equals("asl")) regSave = true;
        if (mnenomic.equals("lsl")) regSave = true;
        if (mnenomic.equals("rol")) regSave = true;
        if (mnenomic.equals("ror")) regSave = true;
        if (mnenomic.equals("asr")) regSave = true;
        if (mnenomic.equals("com")) regSave = true;
        if (mnenomic.equals("lsr")) regSave = true;
        if (mnenomic.equals("neg")) regSave = true;
        if (mnenomic.equals("nop")) regSave = true;


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
        operandAll = operand.toLowerCase();

        if (operandAll.startsWith("#")) isImmediate = true;

        split = operand.split(",");
        split = removeEmpty(split);
        if (split.length == 0) return;
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
        if (split.length == 0) return;

        second = split[0].toLowerCase();
        if (second.contains("a")) secondReg = "abd";
        if (second.contains("b")) secondReg = "abd";
        if (second.contains("d")) secondReg = "abd";
        if (second.contains("x")) secondReg = "x";
        if (second.contains("y")) secondReg = "y";
        if (second.contains("u")) secondReg = "u";
        if (second.contains("s")) secondReg = "s";
        if (second.contains("pc")) secondReg = "pc";
        split[0] = null;
        split = removeEmpty(split);
        if (split.length == 0) return;
        for (String ss: split)
        {
            rest = rest +ss+"";
        }
    }
}    

