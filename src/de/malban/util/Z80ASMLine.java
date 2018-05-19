/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.util;

import de.malban.vide.assy.Comment;
import static de.malban.vide.vedi.VediPanel.removeEmpty;
import java.util.ArrayList;

/**
 *
 * @author malban
 */
public class Z80ASMLine 
{
    private static int UID = 0;
    public final int uid=UID++;
    public String org;
    public String clean= "";

    public String mnenomic="";
    public String operandAllOrg="";
    public String operandAll="";
    public String operand1="";
    public String operand2="";
    public String lineNo="";
    public String addressNo="";
    public String hexRep="";
    ArrayList<String> hexRepArray = new ArrayList<String>();
    


    public String label="";
    public String rest ="";
    public String comment = ""; // with ";"


    public Z80ASMLine(String s)
    {
        org = s;
        clean = Comment.removeEndOfLineComment(org);
        comment = de.malban.util.UtilityString.replace(org, clean, "");

        String tmp = de.malban.util.UtilityString.replaceWhiteSpaces(clean, " ");
        tmp = de.malban.util.UtilityString.replace(tmp, "  ", " ");
        String[] split = tmp.split(" ");
        split = removeEmpty(split);
        if (split.length == 0) return;

        // check format
        // 0110   006F 3E 01       PLY_Channel1_WaitBeforeNextRegisterBlock:  ld a,1	;Frames to wait before reading the next RegisterBlock. 0 = finished.
        // 006F 3E 01       PLY_Channel1_WaitBeforeNextRegisterBlock:  ld a,1	;Frames to wait before reading the next RegisterBlock. 0 = finished.
        // 006F: 3E 01       PLY_Channel1_WaitBeforeNextRegisterBlock:  ld a,1	;Frames to wait before reading the next RegisterBlock. 0 = finished.
        // PLY_Channel1_WaitBeforeNextRegisterBlock:  ld a,1	;Frames to wait before reading the next RegisterBlock. 0 = finished.
        //   ld a,1	;Frames to wait before reading the next RegisterBlock. 0 = finished.
        tmp = doLineNumber(tmp);
        tmp = doLineAddress(tmp);
        tmp = doLineHex(tmp);
        tmp = doLineLabel(tmp);
        tmp = doLineMnemonic(tmp);
        tmp = doLineOperands(tmp);
    }


    // check format
    // 0110   006F 3E 01       PLY_Channel1_WaitBeforeNextRegisterBlock:  ld a,1	;Frames to wait before reading the next RegisterBlock. 0 = finished.
    // 006F 3E 01       PLY_Channel1_WaitBeforeNextRegisterBlock:  ld a,1	;Frames to wait before reading the next RegisterBlock. 0 = finished.
    // 006F: 3E 01       PLY_Channel1_WaitBeforeNextRegisterBlock:  ld a,1	;Frames to wait before reading the next RegisterBlock. 0 = finished.
    // PLY_Channel1_WaitBeforeNextRegisterBlock:  ld a,1	;Frames to wait before reading the next RegisterBlock. 0 = finished.
    //   ld a,1	;Frames to wait before reading the next RegisterBlock. 0 = finished.
    public String doLineNumber(String line)
    {
        lineNo = "";
        String[] split = line.split(" ");
        split = removeEmpty(split);
        if (split.length == 0) return line;
        String l1 = split[0];
        if (isDec4(l1))
        {
            if (split.length == 1) return line;
            String l2 = split[1].trim();
            l2 = de.malban.util.UtilityString.replace(l2, ":", "");
            if (isHex4(l2))
            {
                lineNo = l1;
                line = de.malban.util.UtilityString.replace(line, l1, "");
                return line.trim();
            }
            return line;
        }
        return line;
    }
    // check format
    // 006F 3E 01       PLY_Channel1_WaitBeforeNextRegisterBlock:  ld a,1	;Frames to wait before reading the next RegisterBlock. 0 = finished.
    // 006F: 3E 01       PLY_Channel1_WaitBeforeNextRegisterBlock:  ld a,1	;Frames to wait before reading the next RegisterBlock. 0 = finished.
    // PLY_Channel1_WaitBeforeNextRegisterBlock:  ld a,1	;Frames to wait before reading the next RegisterBlock. 0 = finished.
    //   ld a,1	;Frames to wait before reading the next RegisterBlock. 0 = finished.
    public String doLineAddress(String line)
    {
        addressNo = "";
        String[] split = line.split(" ");
        split = removeEmpty(split);
        if (split.length == 0) return line;
        String l1 = split[0];
        
        String l2 = l1;
        l2 = de.malban.util.UtilityString.replace(l2, ":", "");
        
        if (isHex4(l2))
        {
            addressNo = l2;
            line = de.malban.util.UtilityString.replace(line, l1, "");
            return line.trim();
        }
        return line;
    }
    // 3E 01       PLY_Channel1_WaitBeforeNextRegisterBlock:  ld a,1	;Frames to wait before reading the next RegisterBlock. 0 = finished.
    // PLY_Channel1_WaitBeforeNextRegisterBlock:  ld a,1	;Frames to wait before reading the next RegisterBlock. 0 = finished.
    //   ld a,1	;Frames to wait before reading the next RegisterBlock. 0 = finished.
    public String doLineHex(String line)
    {
        hexRep="";
        hexRepArray = new ArrayList<String>();

        String workLine = line;

        while (true)
        {
            String[] split = workLine.split(" ");
            split = removeEmpty(split);
            if (split.length == 0) return workLine;
            String l1 = split[0];

            if (isHex2(l1))
            {
                if (hexRep.length() > 0) hexRep+=" ";
                hexRep+=l1;
                hexRepArray.add(l1);
                workLine = de.malban.util.UtilityString.replace(workLine, l1, "").trim();
                continue;
            }
            break;
        }
        return workLine;
    }


    // PLY_Channel1_WaitBeforeNextRegisterBlock:  ld a,1	;Frames to wait before reading the next RegisterBlock. 0 = finished.
    //   ld a,1	;Frames to wait before reading the next RegisterBlock. 0 = finished.
    public String doLineLabel(String line)
    {
        label="";

        String[] split = line.split(" ");
        split = removeEmpty(split);
        if (split.length == 0) return line;
        String l1 = split[0];
        l1 = de.malban.util.UtilityString.replace(l1, ":", "").trim();

        if (!isZ80Mnemonic(l1))
        {
            label = l1;
            line = de.malban.util.UtilityString.replace(line, split[0], "").trim();
        }

        return line;
    }

    //   ld a,1	;Frames to wait before reading the next RegisterBlock. 0 = finished.
    public String doLineMnemonic(String line)
    {
        mnenomic="";

        String[] split = line.split(" ");
        split = removeEmpty(split);
        if (split.length == 0) return line;
        String l1 = split[0];

        if (isZ80Mnemonic(l1))
        {
            mnenomic = l1.toLowerCase();
            line = de.malban.util.UtilityString.replace(line, l1, "").trim();
        }

        return line;
    }

    //   a,1
    public String doLineOperands(String line)
    {
        operandAllOrg="";
        operandAll="";
        operand1="";
        operand2="";

        String[] split = line.split(" ");
        split = removeEmpty(split);
        if (split.length == 0) return line;
        String l1 = split[0];
        operandAllOrg = line.trim();
        operandAll = line.trim();
        
        String work = de.malban.util.UtilityString.replace(operandAll, " ", "").trim();
        split = work.split(",");
        split = removeEmpty(split);
        if (split.length == 0) return line;
        operand1 = split[0];
        if (split.length == 1) return line;
        operand2 = split[1];
        if (split.length>1)
        {
            for (int i=2; i<split.length; i++)
                operand2 = ","+split[i];
        }
        return "";
    }
    
    // is String a number consisting of 4 digits in decimal 
    public static boolean isDec4(String n)
    {
        if (n == null) return false;
        n = n.trim();
        if (n.length() != 4) return false;
        return isDecNumber(n);        
    }

    // is String a number consisting of 4 digits in hex 
    public static boolean isHex4(String n)
    {
        if (n == null) return false;
        n = n.trim();
        if (n.length() != 4) 
            return false;
        return isHexNumber(n);        
    }
    // is String a number consisting of 2 digits in hex 
    public static boolean isHex2(String n)
    {
        if (n == null) return false;
        n = n.trim();
        if (n.length() != 2)
            return false;
        return isHexNumber(n);        
    }

    // without any "pre"
    static public boolean isDecNumber(String a)
    {
        for (int i=0; i<a.length(); i++)
        {
            char c = a.charAt(i);
            if ((c>='0') && (c<='9')) continue;
            return false;
        }
        return true;
    }
    // without any "pre"
    static public boolean isHexNumber(String a)
    {
        a = a.toLowerCase();
        for (int i=0; i<a.length(); i++)
        {
            char c = a.charAt(i);
            
            if ((c>='0') && (c<='9')) continue;
            if ((c>='a') && (c<='f')) continue;
            return false;
        }
        return true;
    }    
    static public boolean isZ80Mnemonic(String m)
    {
        // should use a map...
        m = m.toUpperCase().trim();
        for (int i=0; i<MNEMOMICS.length; i++)
        {
            if (MNEMOMICS[i].equals(m)) return true;
        }
        return false;
    }
    
    static String[] MNEMOMICS = 
    {
        "ADC",	
        "ADD",
        "AND",
        "BIT",
        "CALL",
        "CCF",
        "CP",
        "CPD",
        "CPDR",
        "CPI",
        "CPIR",
        "CPL",
        "DAA",
        "DEC",
        "DI",
        "DJNZ",
        "EI",
        "EX",
        "EXX",
        "HALT",
        "IM",
        "IN",
        "INC",
        "IND",
        "INDR",
        "INI",
        "INIR",
        "JP",
        "JR",
        "LD",
        "LDD",
        "LDDR",
        "LDI",
        "LDIR",
        "NEG",
        "NOP",
        "OR",
        "OTDR",
        "OTIR",
        "OUT",
        "OUTD",
        "OUTI",
        "POP",
        "PUSH",
        "RES",
        "RET",
        "RETI",
        "RETN",
        "RL",
        "RLA",
        "RLC",
        "RLCA",
        "RLD",
        "RR",
        "RRA",
        "RRC",
        "RRCA",
        "RRD",
        "RST",
        "SBC",
        "SCF",
        "SET",
        "SLA",
        "SRA",
        "SRL",
        "SUB",
        "XOR",
        
        // Pseudo
        "BYTE",
        "ABYTE",
        "DB",
        "DEFINE",
        "DC",
        "INCLUDE",
        "ORG",
        "END",
        "DD",
        "WORD",
        "DW",
        "DZ",
        "DWORD",
        "DUP",
        "NOP",
        "DS",
        "EQU",
        "=",
        "BLOCK",
        "ASSERT",
    };
    
}    

