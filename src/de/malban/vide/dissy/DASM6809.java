
/* 6809dasm.c - a 6809 opcode disassembler */
/* Version 1.6 27-DEC-95 */
/* Copyright © 1995 Sean Riddle */

/* thanks to Franklin Bowen for bug fixes, ideas */

/* Freely distributable on any medium given all copyrights are retained */
/* by the author and no charge greater than $7.00 is made for obtaining */
/* this software */

/* Please send all bug reports, update ideas and data files to: */
/* sriddle@ionet.net */

/* latest version at: */
/* <a href="http://www.ionet.net/~sriddle">Please don't hurl on my URL!</a> */

/* the data files must be kept compatible across systems! */

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.dissy;

import de.malban.Global;
import de.malban.config.Configuration;
import de.malban.gui.panels.LogPanel;
import static de.malban.gui.panels.LogPanel.INFO;
import static de.malban.gui.panels.LogPanel.WARN;
import de.malban.vide.VideConfig;
import de.malban.vide.assy.Asmj;
import static de.malban.vide.dissy.MemoryInformation.MEM_TYPE_BAD;
import static de.malban.vide.dissy.MemoryInformation.MEM_TYPE_IO;
import static de.malban.vide.dissy.MemoryInformation.MEM_TYPE_RAM;
import de.malban.vide.dissy.MemoryInformation.MemCInfoBlock;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author malban
 */
public class DASM6809 extends DASMStatics {
    
    LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
    public static class OutPutDefinition
    {
        public String hexPrefix ="$";
        public String immediatePrefix ="#";
        
        public String indexedPrefix="[";
        public String indexedPostfix="]";
        
        public String _8bitPrefix="<";
        public String _5bitPrefix="<<";
        public String _16bitPrefix=">";
        
    }
    public static OutPutDefinition DEF = new OutPutDefinition();
    Memory myMemory = new Memory();

    public static boolean ALLOW_DIF_TRANSFER = true;
    
    int currentMemPointer = 0;              // after the current operand (one after getByte())
    int currentInstructionStartAddress =0;  /* current program (of last getByte()) */
    int currentPC =0; // begin of the currently disassembled instruction
    boolean endOfFile = false;
    boolean createLabels = false;
    boolean sizeWarning = false;

    boolean PC=false;  /* to see if a PUL instr is pulling PC */
    String out2=""; // aktuell bearbeitete Zeile
    VideConfig config = VideConfig.getConfig();
    
    
    public DASM6809()
    {
        reset();
    }
    class CodeMemoryScan
    {
        int startadress;
        boolean done = false;
    }
    class ToScan
    {
        private ArrayList<CodeMemoryScan> toScan = new ArrayList<CodeMemoryScan>();
        private HashMap<CodeMemoryScan, Boolean> checker = new HashMap<CodeMemoryScan, Boolean>();
        
        public void add(CodeMemoryScan scan)
        {
            if (checker.get(scan) != null) return;
            checker.put(scan, true);
            toScan.add(scan);
        }
        public CodeMemoryScan next()
        {
            for (CodeMemoryScan scan: toScan)
            {
                if (!scan.done) return scan;
            }
            return null;
        }
    }
    
    // unsigned int = byte in java (more or less)
    int getbyte()
    {
        MemoryInformation m = myMemory.memMap.get(currentMemPointer);
        if (m == null)
        {
            endOfFile = true;
            return 0;
        }
        byte c = m.content;
        currentInstructionStartAddress=currentMemPointer;
        currentMemPointer++;
        return (c & 0xff);
    }
    /* pregetbyte() - get the next byte from a file, and store it back 'lookahead' */
    int pregetbyte()
    {
        MemoryInformation m = myMemory.memMap.get(currentMemPointer);
        if (m == null)
        {
            return 0;
        }
        byte c = m.content;
        return (c & 0xff);
    }

    /* bittest() - test on a single bit, 1-8 */
    static boolean bittest(int c, int bitnumber)
    {
        while (--bitnumber>0)
        {
            c = (c >> 1);
        }
        return ((c&1)==1);
    }
    /* fitbinarypattern() - test on a bit pattern, 0 1 ? */
    /* 11, "00001011" -> true */
    boolean fitbinarypattern(int c, String pattern)
    {
        if (pattern.length()==0)
            return true;
        if (pattern.charAt(0) == '?')
            return fitbinarypattern(c, pattern+1);
        if (pattern.charAt(0)=='0')
            if  ( !bittest(c,pattern.length()))
                return fitbinarypattern(c,pattern+1);
            else
                return false;
        if (pattern.charAt(0)=='1')
            if  ( bittest(c,pattern.length()))
                return fitbinarypattern(c,pattern+1);
            else
                return false;
        return false; /* not supposed to ever get here */
    }
    
    /* printbinary() - 8 bit ... */
    public static String printbinary(int c)
    {
        String ret = "";
        int i=8;
        while (i>0)
        {
            if (bittest(c,i))
                ret += "1";
            else
                ret += "0";
            i--;
        }
        return ret;
    }
    /* printbinary() - 16 bit ... */
    public static String printbinary16(int c)
    {
        String ret = "";
        int i=16;
        while (i>0)
        {
            if (bittest(c,i))
                ret += "1";
            else
                ret += "0";
            i--;
        }
        return ret;
    }
    /* checkindpostbyte() - see if postbyte of IND is OK */
    boolean checkindpostbyte(int c,int numoperands,int[] operandarray)
    {
        /* I'm aware, that this checking could have been done more efficiently.
           but this way it reflects exactly the technical manual I got */

         if (fitbinarypattern(c,"0???????")) /* EA = ,R + 5 bit offset */
         {
            if (fitbinarypattern(c,"0??00000"))
            {
                // no action needed, since assembler assumes 0 offset only with syntax like "lda ,x"
                // the output we generate is "lda 0x00,x", which is correctly translated to 5 bit
                //   force_len[0]='_';
                //   force_len[1]='5';
                //   force_len[2]=(char)0;
//                force_len="_5";
                return true;
                //   printf("; 5bit nil-offset will be translated to 0-offset, changing to data\n");
                //   return SHOW_IT;
            }
            return true;
         }
         if (fitbinarypattern(c,"1??00000")) /* ,R+ */
          return true;
         if (fitbinarypattern(c,"1???0001")) /* ,R++ */
          return true;
         if (fitbinarypattern(c,"1??00010")) /* ,R- */
          return true;
         if (fitbinarypattern(c,"1???0011")) /* ,R-- */
          return true;
         if (fitbinarypattern(c,"1???0100")) /* EA = ,R + 0 offset */
          return true;
         if (fitbinarypattern(c,"1???0101")) /* EA = ,R + ACCB offset */
          return true;
         if (fitbinarypattern(c,"1???0110")) /* EA = ,R + ACCA offset */
          return true;
         if (fitbinarypattern(c,"1???1001")) /* EA = ,R + 16bit offset */
         {
            if (pregetbyte()==0)
            {
                if (fitbinarypattern(c,"???1????"))
                {
//                    force_len="_16";
                    return true;
                    //  printf("; small 16bit ind offset will be falsely assembled, changing to data\n");
                    //  return FALSE;
                }
            }
            return true;
         }
         
         
         if (fitbinarypattern(c,"1???1000")) /* EA = ,R + 8bit offset */
         {
            if ((pregetbyte()<15)||(pregetbyte()>240))
            {
                if (fitbinarypattern(c,"???0????"))
                {
//                    force_len="_8";
                    return true;
                    // printf("; small 8bit ind offset will be falsely assembled, changing to data\n");
                    // return SHOW_IT;
                    // return FALSE;
                }
            }
            return true;
         }
         if (fitbinarypattern(c,"1???1011")) /* EA = ,R + D offset */
              return true;
         if (fitbinarypattern(c,"1???1100")) /* EA = ,PC + 8bit offset */
         {
/* ASMJ doesnt!             
            if (!fitbinarypattern(c,"?00?????"))
            {
//                print("; assembler expects don't care bits to be zeroed, changing to data\n");
                return false;
            }
*/
            return true;
         }
         if (fitbinarypattern(c,"1???1101")) /* EA = ,PC + 16bit offset */
         {
/* ASMJ doesnt!             
             
            if (!fitbinarypattern(c,"?00?????"))
            {
//                print("; assembler expects don't care bits to be zeroed, changing to data\n");
                return false;
            }
*/            
            return true;
         }
         if (fitbinarypattern(c,"1???1111")) /* EA = ,[,adress] */
         {
            if (!fitbinarypattern(c,"10011111"))
            {
//                print("; invalid extended indirect adressing, changing to data\n");
                return false;
            }
            return true;
         }
//         print("; illegal postbyte encountered, changing to data\n");
         return false;
    }

    
    static HashMap<Integer, String> BIOSLABELS;
    static HashMap<Integer, String> BIOSLABELS2;
    static HashMap<Integer, String> BIOSFUNCTIONS;
    
    static HashMap<Integer, String> BIOS_WT1_FUNCTIONS;
    static HashMap<Integer, String> BIOS_WT1_LABELS;
    static HashMap<Integer, String> BIOS_WT1_LABELS2;
    
    static HashMap<Integer, String> BIOS_TOMLIN_LABELS;
    static HashMap<Integer, String> BIOS_TOMLIN_LABELS2;
    static HashMap<Integer, String> BIOS_TOMLIN_FUNCTIONS;

    static 
    {
        BIOS_WT1_FUNCTIONS = new HashMap<Integer, String>();
        BIOS_WT1_LABELS = new HashMap<Integer, String>();
        BIOS_WT1_LABELS2 = new HashMap<Integer, String>();

        
        
        BIOS_WT1_LABELS.put(0xc800, "REG0");
        BIOS_WT1_LABELS.put(0xc801, "REG1");
        BIOS_WT1_LABELS.put(0xc802, "REG2");
        BIOS_WT1_LABELS.put(0xc803, "REG3");
        BIOS_WT1_LABELS.put(0xc804, "REG4");
        BIOS_WT1_LABELS.put(0xc805, "REG5");
        BIOS_WT1_LABELS.put(0xc806, "REG6");
        BIOS_WT1_LABELS.put(0xc807, "REG7");
        BIOS_WT1_LABELS.put(0xc808, "REG8");
        BIOS_WT1_LABELS.put(0xc809, "REG9");
        BIOS_WT1_LABELS.put(0xc80a, "REGA");
        BIOS_WT1_LABELS.put(0xc80b, "REGB");
        BIOS_WT1_LABELS.put(0xc80c, "REGC");
        BIOS_WT1_LABELS.put(0xc80d, "REGD");
        BIOS_WT1_LABELS.put(0xc80e, "REGE");
        BIOS_WT1_LABELS.put(0xc80f, "TRIGGR"); // 2 bytes
        BIOS_WT1_LABELS.put(0xc811, "EDGE");
        BIOS_WT1_LABELS.put(0xc812, "KEY0");
        BIOS_WT1_LABELS.put(0xc813, "KEY1");
        BIOS_WT1_LABELS.put(0xc814, "KEY2");
        BIOS_WT1_LABELS.put(0xc815, "KEY3");
        BIOS_WT1_LABELS.put(0xc816, "KEY4");
        BIOS_WT1_LABELS.put(0xc817, "KEY5");
        BIOS_WT1_LABELS.put(0xc818, "KEY6");
        BIOS_WT1_LABELS.put(0xc819, "KEY7");
        BIOS_WT1_LABELS.put(0xc81a, "POTRES");
        BIOS_WT1_LABELS.put(0xc81b, "POT0");
        BIOS_WT1_LABELS.put(0xc81c, "POT1");
        BIOS_WT1_LABELS.put(0xc81d, "POT1");
        BIOS_WT1_LABELS.put(0xc81e, "POT3");
        BIOS_WT1_LABELS.put(0xc81f, "EPOT0");
        BIOS_WT1_LABELS.put(0xc820, "EPOT1");
        BIOS_WT1_LABELS.put(0xc821, "EPOT2");
        BIOS_WT1_LABELS.put(0xc822, "EPOT3");
        BIOS_WT1_LABELS.put(0xc823, "LIST");
        BIOS_WT1_LABELS.put(0xc824, "ZSKIP");
        BIOS_WT1_LABELS.put(0xc825, "FRAME"); // 2bytes
        BIOS_WT1_LABELS.put(0xc827, "TENSTY");
        BIOS_WT1_LABELS.put(0xc828, "DWELL");
        BIOS_WT1_LABELS.put(0xc829, "DASH");
        BIOS_WT1_LABELS.put(0xc82a, "SIZRAS"); // 2 bytes
        BIOS_WT1_LABELS.put(0xc82c, "MESAGE"); // 2 bytes
        BIOS_WT1_LABELS.put(0xc82e, "XTMR0");
        BIOS_WT1_LABELS.put(0xc82f, "XTMR1");
        BIOS_WT1_LABELS.put(0xc830, "XTMR2");
        BIOS_WT1_LABELS.put(0xc831, "XTMR3");
        BIOS_WT1_LABELS.put(0xc832, "XTMR4");
        BIOS_WT1_LABELS.put(0xc833, "XTMR5");
        BIOS_WT1_LABELS.put(0xc834, "ABSY");
        BIOS_WT1_LABELS.put(0xc835, "ABSX");
        BIOS_WT1_LABELS.put(0xc836, "ANGLE");
        BIOS_WT1_LABELS.put(0xc837, "WSINE"); // 2 bytes
        BIOS_WT1_LABELS.put(0xc839, "WCSINE"); // 2 bytes
        BIOS_WT1_LABELS.put(0xc83b, "LEG");
        BIOS_WT1_LABELS.put(0xc83c, "LAG");
		
        BIOS_WT1_LABELS.put(0xc83d, "FRMTIM"); // 2 bytes
        BIOS_WT1_LABELS.put(0xc83f, "REQ0");
        BIOS_WT1_LABELS.put(0xc840, "REQ1");
        BIOS_WT1_LABELS.put(0xc841, "REQ2");
        BIOS_WT1_LABELS.put(0xc842, "REQ3");
        BIOS_WT1_LABELS.put(0xc843, "REQ4");
        BIOS_WT1_LABELS.put(0xc844, "REQ5");
        BIOS_WT1_LABELS.put(0xc845, "REQ6");
        BIOS_WT1_LABELS.put(0xc846, "REQ7");
        BIOS_WT1_LABELS.put(0xc847, "REQ8");
        BIOS_WT1_LABELS.put(0xc848, "REQ9");
        BIOS_WT1_LABELS.put(0xc849, "REQA");
        BIOS_WT1_LABELS.put(0xc84a, "REQB");
        BIOS_WT1_LABELS.put(0xC84B, "REQC");
        BIOS_WT1_LABELS.put(0xc84c, "REQD");
        BIOS_WT1_LABELS.put(0xc84d, "DOREMI"); // 2 bytes
        BIOS_WT1_LABELS.put(0xc84f, "FADE"); // 2 bytes
        BIOS_WT1_LABELS.put(0xc851, "VIBE");
        BIOS_WT1_LABELS.put(0xc853, "TUNE"); // 2 bytes
        BIOS_WT1_LABELS.put(0xc855, "NEWGEN");
        BIOS_WT1_LABELS.put(0xc856, "TSTAT");
        BIOS_WT1_LABELS.put(0xc857, "RESTC");
        BIOS_WT1_LABELS.put(0xc858, "RATEA");
        BIOS_WT1_LABELS.put(0xc859, "VIBA");
        BIOS_WT1_LABELS.put(0xc85A, "RATEB");
        BIOS_WT1_LABELS.put(0xc85b, "VIBB");
        BIOS_WT1_LABELS.put(0xc85c, "RATEC");
        BIOS_WT1_LABELS.put(0xc85d, "VIBC");
        BIOS_WT1_LABELS.put(0xc85e, "FADEA");
        BIOS_WT1_LABELS.put(0xc85f, "FADEB");
        BIOS_WT1_LABELS.put(0xc860, "FADEC");
		
        BIOS_WT1_LABELS.put(0xc861, "TONEA"); // 2bytes
        BIOS_WT1_LABELS.put(0xc863, "TONEB");// 2 bytes
        BIOS_WT1_LABELS.put(0xc865, "TONEC");// 2 bytes
		
        BIOS_WT1_LABELS.put(0xc867, "SATUS");
        BIOS_WT1_LABELS.put(0xc868, "LATUS");// minestorm
        BIOS_WT1_LABELS.put(0xc869, "XATUS");// minestorm
        
        BIOS_WT1_LABELS.put(0xc86a, "GAP"); // minestorm
        BIOS_WT1_LABELS.put(0xc86b, "B1FREQ"); // 2 bytes
        BIOS_WT1_LABELS.put(0xc86d, "B2FREQ"); // 2 bytes
        BIOS_WT1_LABELS.put(0xc86f, "F1FREQ"); // 2 bytes minestorm

        BIOS_WT1_LABELS.put(0xc871, "FEAST"); // minestorm

        BIOS_WT1_LABELS.put(0xc872, "PEDGE"); // minestorm 2 bytes
        BIOS_WT1_LABELS.put(0xc873, "NEDGE"); // minestorm 2 bytes
        BIOS_WT1_LABELS.put(0xc874, "K1FREQ"); // minestorm 2 bytes

        BIOS_WT1_LABELS.put(0xc876, "BACON"); // minestorm
		
        BIOS_WT1_LABELS.put(0xc877, "XACON");
        BIOS_WT1_LABELS.put(0xc878, "SPEKT"); // minestorm

        BIOS_WT1_LABELS.put(0xc879, "PLAYRS");
        BIOS_WT1_LABELS.put(0xc87a, "OPTION");
        BIOS_WT1_LABELS.put(0xc87b, "SEED"); // 2 bytes
        BIOS_WT1_LABELS.put(0xc87d, "RANCID"); // 3 bytes



        BIOS_WT1_LABELS.put(0xc880, "LASRAM");	// 
        BIOS_WT1_LABELS2.put(0xc880, "SBTN");	// 
        BIOS_WT1_LABELS.put(0xc881, "SJOY");	// 
		
        BIOS_WT1_LABELS.put(0xc883, "ETMP1");	// Minestorm
        BIOS_WT1_LABELS.put(0xc884, "ETMP2");	// Minestorm
        BIOS_WT1_LABELS.put(0xc885, "ETMP3");	// Minestorm
        BIOS_WT1_LABELS.put(0xc886, "ETMP4");	// Minestorm
        BIOS_WT1_LABELS.put(0xc887, "ETMP5");	// Minestorm
        BIOS_WT1_LABELS.put(0xc888, "ETMP6");	// Minestorm
        BIOS_WT1_LABELS.put(0xc889, "ETMP7");	// Minestorm
        BIOS_WT1_LABELS.put(0xc88a, "ETMP8");	// Minestorm
        BIOS_WT1_LABELS.put(0xc88b, "ETMP9");	// Minestorm
        BIOS_WT1_LABELS.put(0xc88c, "ETMP10");	// Minestorm 3 bytes
		
		
        BIOS_WT1_LABELS.put(0xc88f, "TEMP1");	// Minestorm
        BIOS_WT1_LABELS.put(0xc890, "TEMP2");	// Minestorm
        BIOS_WT1_LABELS.put(0xc891, "TEMP3");	// Minestorm
        BIOS_WT1_LABELS.put(0xc892, "TEMP4");	// Minestorm
        BIOS_WT1_LABELS.put(0xc893, "TEMP5");	// Minestorm
        BIOS_WT1_LABELS.put(0xc894, "TEMP6");	// Minestorm
        BIOS_WT1_LABELS.put(0xc895, "TEMP7");	// Minestorm
        BIOS_WT1_LABELS.put(0xc896, "TEMP8");	// Minestorm
        BIOS_WT1_LABELS.put(0xc897, "TEMP9");	// Minestorm
        BIOS_WT1_LABELS.put(0xc898, "TEMP10");	// Minestorm 3 bytes
		
        BIOS_WT1_LABELS.put(0xc89b, "ACTPLY");	// Minestorm
        BIOS_WT1_LABELS.put(0xc89c, "TMR1");	// Minestorm 3 bytes
        BIOS_WT1_LABELS.put(0xc89f, "TMR2");	// Minestorm 3 bytes
        BIOS_WT1_LABELS.put(0xc8a2, "TMR3");	// Minestorm 3 bytes
        BIOS_WT1_LABELS.put(0xc8a5, "TMR4");	// Minestorm 3 bytes
        
		
		
		
	BIOS_WT1_LABELS.put(0xc8a8, "SCOR1");	// Minestorm
        BIOS_WT1_LABELS.put(0xc8af, "SCOR2");	// Minestorm

        BIOS_WT1_LABELS.put(0xc8eb, "HISCOR");	// Minestorm
        BIOS_WT1_LABELS.put(0xca00, "RAMMES");	// Minestorm





        BIOS_WT1_LABELS.put(0xd000, "CNTRL");
        BIOS_WT1_LABELS.put(0xd001, "DAC");
        BIOS_WT1_LABELS.put(0xd002, "DCNTRL");
        BIOS_WT1_LABELS.put(0xd003, "DDAC");
        BIOS_WT1_LABELS.put(0xd004, "T1LOLC");
        BIOS_WT1_LABELS.put(0xd005, "T1HOC");
        BIOS_WT1_LABELS.put(0xd006, "T1LOL");
        BIOS_WT1_LABELS.put(0xd007, "T1HOL");
        BIOS_WT1_LABELS.put(0xd008, "T2LOLC");
        BIOS_WT1_LABELS.put(0xd009, "T2HOC");
        BIOS_WT1_LABELS.put(0xd00a, "SHIFT");
        BIOS_WT1_LABELS.put(0xd00b, "ACNTRL");
        BIOS_WT1_LABELS.put(0xd00c, "PCNTRL");
        BIOS_WT1_LABELS.put(0xd00d, "IFLAG");
        BIOS_WT1_LABELS.put(0xd00e, "IENABL");
        BIOS_WT1_LABELS.put(0xd00f, "ORA");

        BIOS_WT1_LABELS.put(0xCBEA, "Vec_Default_Stk");
        BIOS_WT1_LABELS.put(0xCBEB, "Vec_High_Score");
        BIOS_WT1_LABELS.put(0xCBF2, "Vec_SWI3_Vector");
        BIOS_WT1_LABELS2.put(0xCBF2, "Vec_SWI2_Vector");
        BIOS_WT1_LABELS.put(0xCBF5, "Vec_FIRQ_Vector");
        BIOS_WT1_LABELS.put(0xCBF8, "Vec_IRQ_Vector");
        BIOS_WT1_LABELS.put(0xCBFB, "Vec_SWI_Vector");
        BIOS_WT1_LABELS2.put(0xCBFB, "Vec_NMI_Vector");
        BIOS_WT1_LABELS.put(0xCBFE, "Vec_Cold_Flag");
        

    
        BIOS_WT1_FUNCTIONS.put(0xe7b5, "MLTY8");
        BIOS_WT1_FUNCTIONS.put(0xe7d2, "MLTY16");
		
        BIOS_WT1_FUNCTIONS.put(0xe98a, "RANPOS");
        BIOS_WT1_FUNCTIONS.put(0xea3e, "CONE");
        BIOS_WT1_FUNCTIONS.put(0xea5d, "ADOT");
        BIOS_WT1_FUNCTIONS.put(0xea6d, "DDOT");

        BIOS_WT1_FUNCTIONS.put(0xea7f, "APACK");
        BIOS_WT1_FUNCTIONS.put(0xea8d, "DPACK");
		
        BIOS_WT1_FUNCTIONS.put(0xeaa8, "ASMESS");
        BIOS_WT1_FUNCTIONS.put(0xeab4, "SCRMES");
        BIOS_WT1_FUNCTIONS.put(0xeacf, "SCRBTH");
        BIOS_WT1_FUNCTIONS.put(0xeaf0, "WAIT");
		
		
		
        
        // add them all
        BIOS_WT1_FUNCTIONS.put(0xF000, "Cold_Start");
        BIOS_WT1_FUNCTIONS.put(0xF06C, "Warm_Start");
        BIOS_WT1_FUNCTIONS.put(0xF14C, "INTPIA");
        BIOS_WT1_FUNCTIONS.put(0xF164, "INTMSC");
        BIOS_WT1_FUNCTIONS.put(0xF18B, "INTALL");
        BIOS_WT1_FUNCTIONS.put(0xF192, "FRWAIT");
        BIOS_WT1_FUNCTIONS.put(0xF1A2, "Set_Refresh");// not in BIOS_WT1_
        BIOS_WT1_FUNCTIONS.put(0xF1AA, "DPIO");
        BIOS_WT1_FUNCTIONS.put(0xF1AF, "DPRAM");
        BIOS_WT1_FUNCTIONS.put(0xF1BA, "INPUT");
        BIOS_WT1_FUNCTIONS.put(0xF1B4, "DBNCE");
        BIOS_WT1_FUNCTIONS.put(0xF1F5, "JOYSTK");
        BIOS_WT1_FUNCTIONS.put(0xF1F8, "JOYBIT");
        BIOS_WT1_FUNCTIONS.put(0xF256, "WRREG");
        BIOS_WT1_FUNCTIONS.put(0xF259, "WRPSC");
        BIOS_WT1_FUNCTIONS.put(0xF25B, "Sound_Byte_raw");// not in BIOS_WT1_
        BIOS_WT1_FUNCTIONS.put(0xF272, "INTPSG");
        BIOS_WT1_FUNCTIONS.put(0xF27D, "PSGLST");
        BIOS_WT1_FUNCTIONS.put(0xF284, "PSGMIR");
        BIOS_WT1_FUNCTIONS.put(0xF289, "REQOUT");
        BIOS_WT1_FUNCTIONS.put(0xF28C, "Do_Sound_x");// not in BIOS_WT1_
        BIOS_WT1_FUNCTIONS.put(0xF29D, "INT1Q");
        BIOS_WT1_FUNCTIONS.put(0xF2A1, "INT2Q");
        BIOS_WT1_FUNCTIONS.put(0xF2A5, "INT3Q");
        BIOS_WT1_FUNCTIONS.put(0xF2A9, "INTMAX");
        BIOS_WT1_FUNCTIONS.put(0xF2AB, "INTENS");
        BIOS_WT1_FUNCTIONS.put(0xF2BE, "DOTTIM");
        BIOS_WT1_FUNCTIONS.put(0xF2C1, "DOTX");
        BIOS_WT1_FUNCTIONS.put(0xF2C3, "DOTAB");
        BIOS_WT1_FUNCTIONS.put(0xF2C5, "DOT");
        BIOS_WT1_FUNCTIONS.put(0xF2D5, "DIFDOT");
        BIOS_WT1_FUNCTIONS.put(0xF2DE, "DOTPCK");
        BIOS_WT1_FUNCTIONS.put(0xF2E6, "DEFLOK");
        BIOS_WT1_FUNCTIONS.put(0xF2F2, "POSWID");
        BIOS_WT1_FUNCTIONS.put(0xF2FC, "POSITD");
        BIOS_WT1_FUNCTIONS.put(0xF308, "POSIT2");
        BIOS_WT1_FUNCTIONS.put(0xF30C, "POSIT1");
        BIOS_WT1_FUNCTIONS.put(0xF30E, "POSITB");
        BIOS_WT1_FUNCTIONS.put(0xF310, "POSITX");
        BIOS_WT1_FUNCTIONS.put(0xF312, "POSITN");
        BIOS_WT1_FUNCTIONS.put(0xF34A, "DZERO");
        BIOS_WT1_FUNCTIONS.put(0xF34F, "CZERO");
        BIOS_WT1_FUNCTIONS.put(0xF354, "ZERGND");
        BIOS_WT1_FUNCTIONS.put(0xF35B, "ACTGND");
        BIOS_WT1_FUNCTIONS.put(0xF36B, "ZERO");
        BIOS_WT1_FUNCTIONS.put(0xF373, "RSTSIZ");
        BIOS_WT1_FUNCTIONS.put(0xF378, "RSTPOS");
        BIOS_WT1_FUNCTIONS.put(0xF37A, "MSSPOS");
        BIOS_WT1_FUNCTIONS.put(0xF385, "TXTSIZ");
        BIOS_WT1_FUNCTIONS.put(0xF38A, "Print_List"); // not in BIOS_WT1_
        BIOS_WT1_FUNCTIONS.put(0xF38C, "TXTPOS");
        BIOS_WT1_FUNCTIONS.put(0xF391, "SHIPX");
        BIOS_WT1_FUNCTIONS.put(0xF393, "DSHIP");
        BIOS_WT1_FUNCTIONS.put(0xF3AD, "DUFFAX");
        BIOS_WT1_FUNCTIONS.put(0xF3B1, "DUFTIM");
        BIOS_WT1_FUNCTIONS.put(0xF3B5, "DUFLST");
        BIOS_WT1_FUNCTIONS.put(0xF3B7, "TDUFFY");
        BIOS_WT1_FUNCTIONS.put(0xF3B9, "LDUFFY");
        BIOS_WT1_FUNCTIONS.put(0xF3BC, "DUFFY");
        BIOS_WT1_FUNCTIONS.put(0xF3BE, "DUFFAB");
        BIOS_WT1_FUNCTIONS.put(0xF3CE, "DIFFAX");
        BIOS_WT1_FUNCTIONS.put(0xF3D2, "DIFTIM");
        BIOS_WT1_FUNCTIONS.put(0xF3D6, "DIFLST");
        BIOS_WT1_FUNCTIONS.put(0xF3D8, "TDIFFY");
        BIOS_WT1_FUNCTIONS.put(0xF3DA, "LDIFFY");
        BIOS_WT1_FUNCTIONS.put(0xF3DD, "DIFFY");
        BIOS_WT1_FUNCTIONS.put(0xf3df, "DIFFAB");
        BIOS_WT1_FUNCTIONS.put(0xF404, "PACK2X");
        BIOS_WT1_FUNCTIONS.put(0xF408, "PACK1X");
        BIOS_WT1_FUNCTIONS.put(0xF40C, "LPACK");
        BIOS_WT1_FUNCTIONS.put(0xF40E, "TPACK");
        BIOS_WT1_FUNCTIONS.put(0xF410, "PACKET");

        BIOS_WT1_FUNCTIONS.put(0xF433, "DSHDF1"); // 
        BIOS_WT1_FUNCTIONS.put(0xF434, "DSHDF");
        BIOS_WT1_FUNCTIONS.put(0xF437, "DASHDF");
        BIOS_WT1_FUNCTIONS.put(0xF439, "Draw_Pat_VL_d");// not in BIOS_WT1_
        BIOS_WT1_FUNCTIONS.put(0xF46E, "DASHPK");
        BIOS_WT1_FUNCTIONS.put(0xF495, "RASTER");
        BIOS_WT1_FUNCTIONS.put(0xF498, "MRASTR");
		
        BIOS_WT1_FUNCTIONS.put(0xF511, "RAND3");
        BIOS_WT1_FUNCTIONS.put(0xF517, "RANDOM");
        BIOS_WT1_FUNCTIONS.put(0xF533, "INTREQ");
        BIOS_WT1_FUNCTIONS.put(0xF53F, "BCLR");
        BIOS_WT1_FUNCTIONS.put(0xF542, "CLREX");
        BIOS_WT1_FUNCTIONS.put(0xF545, "CLR256");
        BIOS_WT1_FUNCTIONS.put(0xF548, "CLRBLK");
        BIOS_WT1_FUNCTIONS.put(0xF550, "CLR80");
        BIOS_WT1_FUNCTIONS.put(0xF552, "BLKFIL");
        BIOS_WT1_FUNCTIONS.put(0xF55A, "D2TMR");
        BIOS_WT1_FUNCTIONS.put(0xF55E, "DECTMR");
        BIOS_WT1_FUNCTIONS.put(0xF563, "Dec_Counters");// not in BIOS_WT1_
        BIOS_WT1_FUNCTIONS.put(0xF56D, "DEL38");
        BIOS_WT1_FUNCTIONS.put(0xF571, "DEL33");
        BIOS_WT1_FUNCTIONS.put(0xF575, "DEL28");
        BIOS_WT1_FUNCTIONS.put(0xF579, "DEL20");
        BIOS_WT1_FUNCTIONS.put(0xF57A, "DEL");
        BIOS_WT1_FUNCTIONS.put(0xF57D, "DEL13");
        BIOS_WT1_FUNCTIONS.put(0xF57E, "DECBIT");
        BIOS_WT1_FUNCTIONS.put(0xF584, "ABSAB");
        BIOS_WT1_FUNCTIONS.put(0xF58B, "ABSB");
        BIOS_WT1_FUNCTIONS.put(0xF593, "CMPASS");
        BIOS_WT1_FUNCTIONS.put(0xF5D9, "COSINE");
		
		
        BIOS_WT1_FUNCTIONS.put(0xF5D8, "SINE");
        BIOS_WT1_FUNCTIONS.put(0xF5DB, "Get_Run_Idx");// not in BIOS_WT1_
        BIOS_WT1_FUNCTIONS.put(0xF5EF, "SINCOS");
        BIOS_WT1_FUNCTIONS.put(0xF5FF, "LROT90");
        BIOS_WT1_FUNCTIONS.put(0xF601, "LNROT");
        BIOS_WT1_FUNCTIONS.put(0xF603, "ALNROT");
        BIOS_WT1_FUNCTIONS.put(0xF610, "DROT");
        BIOS_WT1_FUNCTIONS.put(0xF613, "BDROT");
		
        BIOS_WT1_FUNCTIONS.put(0xF616, "ADROT");
        BIOS_WT1_FUNCTIONS.put(0xF61F, "PROT");
        BIOS_WT1_FUNCTIONS.put(0xF622, "APROT");
		
        BIOS_WT1_FUNCTIONS.put(0xF637, "Rot_VL_dft");// not in BIOS_WT1_
        BIOS_WT1_FUNCTIONS.put(0xF65B, "MSINE");
        BIOS_WT1_FUNCTIONS.put(0xF65D, "LSINE");
        BIOS_WT1_FUNCTIONS.put(0xF661, "MCSINE");
        BIOS_WT1_FUNCTIONS.put(0xF663, "LCSINE");
        BIOS_WT1_FUNCTIONS.put(0xF67F, "BLKMV1");
        BIOS_WT1_FUNCTIONS.put(0xF683, "BLKMOV");
        BIOS_WT1_FUNCTIONS.put(0xF687, "REPLAY");
        BIOS_WT1_FUNCTIONS.put(0xF68D, "SPLAY");
		
        BIOS_WT1_FUNCTIONS.put(0xF690, "ASPLAY");
        BIOS_WT1_FUNCTIONS.put(0xF692, "TPLAY");
		
		
        BIOS_WT1_FUNCTIONS.put(0xF742, "XPLAY");
		
        BIOS_WT1_FUNCTIONS.put(0xF7A9, "SELOPT");
        BIOS_WT1_FUNCTIONS.put(0xF84F, "SCLR");
        BIOS_WT1_FUNCTIONS.put(0xF85E, "BYTADD");
        BIOS_WT1_FUNCTIONS.put(0xF87C, "SCRADD");
        BIOS_WT1_FUNCTIONS.put(0xF880, "STKADD");
		
		
        BIOS_WT1_FUNCTIONS.put(0xF8B7, "Strip_Zeros");// not in BIOS_WT1_
        BIOS_WT1_FUNCTIONS.put(0xF8C7, "WINNER");
        BIOS_WT1_FUNCTIONS.put(0xF8D8, "HISCR");
        BIOS_WT1_FUNCTIONS.put(0xF8E5, "OFF1BX");
        BIOS_WT1_FUNCTIONS.put(0xF8F3, "OFF2BX");
        BIOS_WT1_FUNCTIONS.put(0xF8FF, "BXTEST");
        BIOS_WT1_FUNCTIONS.put(0xF92E, "EXPLOD");
        BIOS_WT1_FUNCTIONS.put(0xF9ca, "SETAMP");
		
        BIOS_WT1_FUNCTIONS.put(0xFF9F, "Draw_Grid_VL");// not in BIOS_WT1_

// ///////////////////////////////////////////        
        
        
        BIOS_TOMLIN_FUNCTIONS = new HashMap<Integer, String>();
        BIOS_TOMLIN_LABELS = new HashMap<Integer, String>();
        BIOS_TOMLIN_LABELS2 = new HashMap<Integer, String>();
        
        BIOS_TOMLIN_LABELS.put(0xc800, "Vec_Snd_Shadow");
        BIOS_TOMLIN_LABELS.put(0xc80f, "Vec_Btn_State");
        BIOS_TOMLIN_LABELS.put(0xc810, "Vec_Prev_Btns");
        BIOS_TOMLIN_LABELS.put(0xc811, "Vec_Buttons");
        BIOS_TOMLIN_LABELS.put(0xc812, "Vec_Button_1_1");
        BIOS_TOMLIN_LABELS.put(0xc813, "Vec_Button_1_2");
        BIOS_TOMLIN_LABELS.put(0xc814, "Vec_Button_1_3");
        BIOS_TOMLIN_LABELS.put(0xc815, "Vec_Button_1_4");
        BIOS_TOMLIN_LABELS.put(0xc816, "Vec_Button_2_1");
        BIOS_TOMLIN_LABELS.put(0xc817, "Vec_Button_2_2");
        BIOS_TOMLIN_LABELS.put(0xc818, "Vec_Button_2_3");
        BIOS_TOMLIN_LABELS.put(0xc819, "Vec_Button_2_4");
        BIOS_TOMLIN_LABELS.put(0xc81a, "Vec_Joy_Resltn");
        BIOS_TOMLIN_LABELS.put(0xc81b, "Vec_Joy_1_X");
        BIOS_TOMLIN_LABELS.put(0xc81c, "Vec_Joy_1_Y");
        BIOS_TOMLIN_LABELS.put(0xc81d, "Vec_Joy_2_X");
        BIOS_TOMLIN_LABELS.put(0xc81e, "Vec_Joy_2_Y");
        BIOS_TOMLIN_LABELS2.put(0xc81e, "Vec_Joy_Mux");
        BIOS_TOMLIN_LABELS2.put(0xc81f, "Vec_Joy_Mux");
        BIOS_TOMLIN_LABELS.put(0xc81f, "Vec_Joy_Mux_1_X");
        BIOS_TOMLIN_LABELS.put(0xc820, "Vec_Joy_Mux_1_Y");
        BIOS_TOMLIN_LABELS.put(0xc821, "Vec_Joy_Mux_2_X");
        BIOS_TOMLIN_LABELS.put(0xc822, "Vec_Joy_Mux_2_Y");
        BIOS_TOMLIN_LABELS.put(0xc823, "Vec_Misc_Count");
        BIOS_TOMLIN_LABELS.put(0xc824, "Vec_0Ref_Enable");
        BIOS_TOMLIN_LABELS.put(0xc825, "Vec_Loop_Count");
        BIOS_TOMLIN_LABELS.put(0xc827, "Vec_Brightness");
        BIOS_TOMLIN_LABELS.put(0xc828, "Vec_Dot_Dwell");
        BIOS_TOMLIN_LABELS.put(0xc829, "Vec_Pattern");
        BIOS_TOMLIN_LABELS.put(0xc82a, "Vec_Text_HW");
        BIOS_TOMLIN_LABELS2.put(0xc82a, "Vec_Text_Height");
        BIOS_TOMLIN_LABELS.put(0xc82b, "Vec_Text_Width");
        BIOS_TOMLIN_LABELS.put(0xc82c, "Vec_Str_Ptr");
        BIOS_TOMLIN_LABELS.put(0xc82e, "Vec_Counters");
        BIOS_TOMLIN_LABELS2.put(0xc82e, "Vec_Counter_1");
        BIOS_TOMLIN_LABELS.put(0xc82f, "Vec_Counter_2");
        BIOS_TOMLIN_LABELS.put(0xc830, "Vec_Counter_3");
        BIOS_TOMLIN_LABELS.put(0xc831, "Vec_Counter_4");
        BIOS_TOMLIN_LABELS.put(0xc832, "Vec_Counter_5");
        BIOS_TOMLIN_LABELS.put(0xc833, "Vec_Counter_6");
        BIOS_TOMLIN_LABELS.put(0xc834, "Vec_RiseRun_Tmp");
        BIOS_TOMLIN_LABELS.put(0xc836, "Vec_Angle");
        BIOS_TOMLIN_LABELS.put(0xc837, "Vec_Run_Index");
        BIOS_TOMLIN_LABELS.put(0xc839, "Vec_Rise_Index");
        BIOS_TOMLIN_LABELS.put(0xc83b, "Vec_RiseRun_Len");
        BIOS_TOMLIN_LABELS.put(0xc83d, "Vec_Rfrsh");
        BIOS_TOMLIN_LABELS2.put(0xc83d, "Vec_Rfrsh_lo");
        BIOS_TOMLIN_LABELS.put(0xc83e, "Vec_Rfrsh_hi");
        BIOS_TOMLIN_LABELS2.put(0xc83f, "Vec_Music_Work");
        BIOS_TOMLIN_LABELS.put(0xc83f, "Vec_Music_Wk_D");
        BIOS_TOMLIN_LABELS.put(0xc840, "Vec_Music_Wk_C");
        BIOS_TOMLIN_LABELS.put(0xc841, "Vec_Music_Wk_B");
        BIOS_TOMLIN_LABELS.put(0xc842, "Vec_Music_Wk_A");
        BIOS_TOMLIN_LABELS.put(0xc843, "Vec_Music_Wk_9");
        BIOS_TOMLIN_LABELS.put(0xc844, "Vec_Music_Wk_8");
        BIOS_TOMLIN_LABELS.put(0xc845, "Vec_Music_Wk_7");
        BIOS_TOMLIN_LABELS.put(0xc846, "Vec_Music_Wk_6");
        BIOS_TOMLIN_LABELS.put(0xc847, "Vec_Music_Wk_5");
        BIOS_TOMLIN_LABELS.put(0xc848, "Vec_Music_Wk_4");
        BIOS_TOMLIN_LABELS.put(0xc849, "Vec_Music_Wk_3");
        BIOS_TOMLIN_LABELS.put(0xc84a, "Vec_Music_Wk_2");
        BIOS_TOMLIN_LABELS.put(0xC84B, "Vec_Music_Wk_1");
        BIOS_TOMLIN_LABELS.put(0xc84c, "Vec_Music_Wk_0");
        BIOS_TOMLIN_LABELS.put(0xc84d, "Vec_Freq_Table");
        BIOS_TOMLIN_LABELS.put(0xc84f, "Vec_Max_Players");
        BIOS_TOMLIN_LABELS.put(0xc850, "Vec_Max_Games");
        BIOS_TOMLIN_LABELS2.put(0xc84f, "Vec_ADSR_Table");
        BIOS_TOMLIN_LABELS.put(0xc851, "Vec_Twang_Table");
        BIOS_TOMLIN_LABELS.put(0xc853, "Vec_Music_Ptr");
        BIOS_TOMLIN_LABELS2.put(0xc853, "Vec_Expl_ChanA");
        BIOS_TOMLIN_LABELS.put(0xc854, "Vec_Expl_Chans");
        BIOS_TOMLIN_LABELS.put(0xc855, "Vec_Music_Chan");
        BIOS_TOMLIN_LABELS.put(0xc856, "Vec_Music_Flag");
        BIOS_TOMLIN_LABELS.put(0xc857, "Vec_Duration");
        BIOS_TOMLIN_LABELS2.put(0xc858, "Vec_Music_Twang");
        BIOS_TOMLIN_LABELS.put(0xc858, "Vec_Expl_1");
        BIOS_TOMLIN_LABELS.put(0xc859, "Vec_Expl_2");
        BIOS_TOMLIN_LABELS.put(0xc85A, "Vec_Expl_3");
        BIOS_TOMLIN_LABELS.put(0xc85b, "Vec_Expl_4");
        BIOS_TOMLIN_LABELS.put(0xc85c, "Vec_Expl_Chan");
        BIOS_TOMLIN_LABELS.put(0xc85d, "Vec_Expl_ChanB");
        BIOS_TOMLIN_LABELS.put(0xc85e, "Vec_ADSR_Timers");
        BIOS_TOMLIN_LABELS.put(0xc861, "Vec_Music_Freq");
        BIOS_TOMLIN_LABELS.put(0xc867, "Vec_Expl_Flag");
        BIOS_TOMLIN_LABELS.put(0xc877, "Vec_Expl_Timer");
        BIOS_TOMLIN_LABELS.put(0xc879, "Vec_Num_Players");
        BIOS_TOMLIN_LABELS.put(0xc87a, "Vec_Num_Game");
        BIOS_TOMLIN_LABELS.put(0xc87b, "Vec_Seed_Ptr");
        BIOS_TOMLIN_LABELS.put(0xc87d, "Vec_Random_Seed");

        BIOS_TOMLIN_LABELS.put(0xd000, "VIA_port_b");
        BIOS_TOMLIN_LABELS.put(0xd001, "VIA_port_a");
        BIOS_TOMLIN_LABELS.put(0xd002, "VIA_DDR_b");
        BIOS_TOMLIN_LABELS.put(0xd003, "VIA_DDR_a");
        BIOS_TOMLIN_LABELS.put(0xd004, "VIA_t1_cnt_lo");
        BIOS_TOMLIN_LABELS.put(0xd005, "VIA_t1_cnt_hi");
        BIOS_TOMLIN_LABELS.put(0xd006, "VIA_t1_lch_lo");
        BIOS_TOMLIN_LABELS.put(0xd007, "VIA_t1_lch_hi");
        BIOS_TOMLIN_LABELS.put(0xd008, "VIA_t2_lo");
        BIOS_TOMLIN_LABELS.put(0xd009, "VIA_t2_hi");
        BIOS_TOMLIN_LABELS.put(0xd00a, "VIA_shift_reg");
        BIOS_TOMLIN_LABELS.put(0xd00b, "VIA_aux_cntl");
        BIOS_TOMLIN_LABELS.put(0xd00c, "VIA_cntl");
        BIOS_TOMLIN_LABELS.put(0xd00d, "VIA_int_flags");
        BIOS_TOMLIN_LABELS.put(0xd00e, "VIA_int_enable");
        BIOS_TOMLIN_LABELS.put(0xd00f, "VIA_port_a_nohs");

        BIOS_TOMLIN_LABELS.put(0xCBEA, "Vec_Default_Stk");
        BIOS_TOMLIN_LABELS.put(0xCBEB, "Vec_High_Score");
        BIOS_TOMLIN_LABELS.put(0xCBF2, "Vec_SWI3_Vector");
        BIOS_TOMLIN_LABELS2.put(0xCBF2, "Vec_SWI2_Vector");
        BIOS_TOMLIN_LABELS.put(0xCBF5, "Vec_FIRQ_Vector");
        BIOS_TOMLIN_LABELS.put(0xCBF8, "Vec_IRQ_Vector");
        BIOS_TOMLIN_LABELS.put(0xCBFB, "Vec_SWI_Vector");
        BIOS_TOMLIN_LABELS2.put(0xCBFB, "Vec_NMI_Vector");
        BIOS_TOMLIN_LABELS.put(0xCBFE, "Vec_Cold_Flag");
        
    
        
        // add them all
        BIOS_TOMLIN_FUNCTIONS.put(0xF192, "Wait_Recal");
        BIOS_TOMLIN_FUNCTIONS.put(0xF2AB, "Intensity_a");
        BIOS_TOMLIN_FUNCTIONS.put(0xF56D, "Delay_3");
        BIOS_TOMLIN_FUNCTIONS.put(0xF000, "Cold_Start");
        BIOS_TOMLIN_FUNCTIONS.put(0xF06C, "Warm_Start");
        BIOS_TOMLIN_FUNCTIONS.put(0xF14C, "Init_VIA");
        BIOS_TOMLIN_FUNCTIONS.put(0xF164, "Init_OS_RAM");
        BIOS_TOMLIN_FUNCTIONS.put(0xF18B, "Init_OS");
        BIOS_TOMLIN_FUNCTIONS.put(0xF1A2, "Set_Refresh");
        BIOS_TOMLIN_FUNCTIONS.put(0xF1AA, "DP_to_D0");
        BIOS_TOMLIN_FUNCTIONS.put(0xF1AF, "DP_to_C8");
        BIOS_TOMLIN_FUNCTIONS.put(0xF1BA, "Read_Btns");
        BIOS_TOMLIN_FUNCTIONS.put(0xF1B4, "Read_Btns_Mask");
        BIOS_TOMLIN_FUNCTIONS.put(0xF1F5, "Joy_Analog");
        BIOS_TOMLIN_FUNCTIONS.put(0xF1F8, "Joy_Digital");
        BIOS_TOMLIN_FUNCTIONS.put(0xF256, "Sound_Byte");
        BIOS_TOMLIN_FUNCTIONS.put(0xF259, "Sound_Byte_x");
        BIOS_TOMLIN_FUNCTIONS.put(0xF25B, "Sound_Byte_raw");
        BIOS_TOMLIN_FUNCTIONS.put(0xF272, "Clear_Sound");
        BIOS_TOMLIN_FUNCTIONS.put(0xF27D, "Sound_Bytes");
        BIOS_TOMLIN_FUNCTIONS.put(0xF284, "DelaSound_Bytes_xy_3");
        BIOS_TOMLIN_FUNCTIONS.put(0xF289, "Do_Sound");
        BIOS_TOMLIN_FUNCTIONS.put(0xF28C, "Do_Sound_x");
        BIOS_TOMLIN_FUNCTIONS.put(0xF29D, "Intensity_1F");
        BIOS_TOMLIN_FUNCTIONS.put(0xF2A1, "Intensity_3F");
        BIOS_TOMLIN_FUNCTIONS.put(0xF2A5, "Intensity_5F");
        BIOS_TOMLIN_FUNCTIONS.put(0xF2A9, "Intensity_7F");
        BIOS_TOMLIN_FUNCTIONS.put(0xF2AB, "Intensity_a");
        BIOS_TOMLIN_FUNCTIONS.put(0xF2BE, "Dot_ix_b");
        BIOS_TOMLIN_FUNCTIONS.put(0xF2C1, "Dot_ix");
        BIOS_TOMLIN_FUNCTIONS.put(0xF2C3, "Dot_d");
        BIOS_TOMLIN_FUNCTIONS.put(0xF2C5, "Dot_here");
        BIOS_TOMLIN_FUNCTIONS.put(0xF2D5, "Dot_List");
        BIOS_TOMLIN_FUNCTIONS.put(0xF2DE, "Dot_List_Reset");
        BIOS_TOMLIN_FUNCTIONS.put(0xF2E6, "Recalibrate");
        BIOS_TOMLIN_FUNCTIONS.put(0xF2F2, "Moveto_x_7F");
        BIOS_TOMLIN_FUNCTIONS.put(0xF2FC, "Moveto_d_7F");
        BIOS_TOMLIN_FUNCTIONS.put(0xF308, "Moveto_ix_FF");
        BIOS_TOMLIN_FUNCTIONS.put(0xF30C, "Moveto_ix_7F");
        BIOS_TOMLIN_FUNCTIONS.put(0xF30E, "Moveto_ix_b");
        BIOS_TOMLIN_FUNCTIONS.put(0xF310, "Moveto_ix");
        BIOS_TOMLIN_FUNCTIONS.put(0xF312, "Moveto_d");
        BIOS_TOMLIN_FUNCTIONS.put(0xF34A, "Reset0Ref_D0");
        BIOS_TOMLIN_FUNCTIONS.put(0xF34F, "Check0Ref");
        BIOS_TOMLIN_FUNCTIONS.put(0xF354, "Reset0Ref");
        BIOS_TOMLIN_FUNCTIONS.put(0xF35B, "Reset_Pen");
        BIOS_TOMLIN_FUNCTIONS.put(0xF36B, "Reset0Int");
        BIOS_TOMLIN_FUNCTIONS.put(0xF373, "Print_Str_hwyx");
        BIOS_TOMLIN_FUNCTIONS.put(0xF378, "Print_Str_yx");
        BIOS_TOMLIN_FUNCTIONS.put(0xF37A, "Print_Str_d");
        BIOS_TOMLIN_FUNCTIONS.put(0xF385, "Print_List_hw");
        BIOS_TOMLIN_FUNCTIONS.put(0xF38A, "Print_List");
        BIOS_TOMLIN_FUNCTIONS.put(0xF38C, "Print_List_chk");
        BIOS_TOMLIN_FUNCTIONS.put(0xF391, "Print_Ships_x");
        BIOS_TOMLIN_FUNCTIONS.put(0xF393, "Print_Ships");
        BIOS_TOMLIN_FUNCTIONS.put(0xF3AD, "Mov_Draw_VLc_a");
        BIOS_TOMLIN_FUNCTIONS.put(0xF3B1, "Mov_Draw_VL_b");
        BIOS_TOMLIN_FUNCTIONS.put(0xF3B5, "Mov_Draw_VLcs");
        BIOS_TOMLIN_FUNCTIONS.put(0xF3B7, "Mov_Draw_VL_ab");
        BIOS_TOMLIN_FUNCTIONS.put(0xF3B9, "Mov_Draw_VL_a");
        BIOS_TOMLIN_FUNCTIONS.put(0xF3BC, "Mov_Draw_VL");
        BIOS_TOMLIN_FUNCTIONS.put(0xF3BE, "Mov_Draw_VL_d");
        BIOS_TOMLIN_FUNCTIONS.put(0xF3CE, "Draw_VLc");
        BIOS_TOMLIN_FUNCTIONS.put(0xF3D2, "Draw_VL_b");
        BIOS_TOMLIN_FUNCTIONS.put(0xF3D6, "Draw_VLcs");
        BIOS_TOMLIN_FUNCTIONS.put(0xF3D8, "Draw_VL_ab");
        BIOS_TOMLIN_FUNCTIONS.put(0xF3DA, "Draw_VL_a");
        BIOS_TOMLIN_FUNCTIONS.put(0xF3DD, "Draw_VL");
        BIOS_TOMLIN_FUNCTIONS.put(0xf3df, "Draw_Line_d");
        BIOS_TOMLIN_FUNCTIONS.put(0xF404, "Draw_VLp_FF");
        BIOS_TOMLIN_FUNCTIONS.put(0xF408, "Draw_VLp_7F");
        BIOS_TOMLIN_FUNCTIONS.put(0xF40C, "Draw_VLp_scale");
        BIOS_TOMLIN_FUNCTIONS.put(0xF40E, "Draw_VLp_b");
        BIOS_TOMLIN_FUNCTIONS.put(0xF410, "Draw_VLp");
        BIOS_TOMLIN_FUNCTIONS.put(0xF434, "Draw_Pat_VL_a");
        BIOS_TOMLIN_FUNCTIONS.put(0xF437, "Draw_Pat_VL");
        BIOS_TOMLIN_FUNCTIONS.put(0xF439, "Draw_Pat_VL_d");
        BIOS_TOMLIN_FUNCTIONS.put(0xF46E, "Draw_VL_mode");
        BIOS_TOMLIN_FUNCTIONS.put(0xF495, "Print_Str");
        BIOS_TOMLIN_FUNCTIONS.put(0xF511, "Random_3");
        BIOS_TOMLIN_FUNCTIONS.put(0xF517, "Random");
        BIOS_TOMLIN_FUNCTIONS.put(0xF533, "Init_Music_Buf");
        BIOS_TOMLIN_FUNCTIONS.put(0xF53F, "Clear_x_b");
        BIOS_TOMLIN_FUNCTIONS.put(0xF542, "Clear_C8_RAM");
        BIOS_TOMLIN_FUNCTIONS.put(0xF545, "Clear_x_256");
        BIOS_TOMLIN_FUNCTIONS.put(0xF548, "Clear_x_d");
        BIOS_TOMLIN_FUNCTIONS.put(0xF550, "Clear_x_b_80");
        BIOS_TOMLIN_FUNCTIONS.put(0xF552, "Clear_x_b_a");
        BIOS_TOMLIN_FUNCTIONS.put(0xF55A, "Dec_3_Counters");
        BIOS_TOMLIN_FUNCTIONS.put(0xF55E, "Dec_6_Counters");
        BIOS_TOMLIN_FUNCTIONS.put(0xF563, "Dec_Counters");
        BIOS_TOMLIN_FUNCTIONS.put(0xF571, "Delay_2");
        BIOS_TOMLIN_FUNCTIONS.put(0xF575, "Delay_1");
        BIOS_TOMLIN_FUNCTIONS.put(0xF579, "Delay_0");
        BIOS_TOMLIN_FUNCTIONS.put(0xF57A, "Delay_b");
        BIOS_TOMLIN_FUNCTIONS.put(0xF57D, "Delay_RTS");
        BIOS_TOMLIN_FUNCTIONS.put(0xF57E, "Bitmask_a");
        BIOS_TOMLIN_FUNCTIONS.put(0xF584, "Abs_a_b");
        BIOS_TOMLIN_FUNCTIONS.put(0xF58B, "Abs_b");
        BIOS_TOMLIN_FUNCTIONS.put(0xF593, "Rise_Run_Angle");
        BIOS_TOMLIN_FUNCTIONS.put(0xF5D9, "Get_Rise_Idx");
        BIOS_TOMLIN_FUNCTIONS.put(0xF5DB, "Get_Run_Idx");
        BIOS_TOMLIN_FUNCTIONS.put(0xF5EF, "Get_Rise_Run");
        BIOS_TOMLIN_FUNCTIONS.put(0xF5FF, "Rise_Run_X");
        BIOS_TOMLIN_FUNCTIONS.put(0xF601, "Rise_Run_Y");
        BIOS_TOMLIN_FUNCTIONS.put(0xF603, "Rise_Run_Len");
        BIOS_TOMLIN_FUNCTIONS.put(0xF610, "Rot_VL_ab");
        BIOS_TOMLIN_FUNCTIONS.put(0xF616, "Rot_VL");
        BIOS_TOMLIN_FUNCTIONS.put(0xF61F, "Rot_VL_Mode");
        BIOS_TOMLIN_FUNCTIONS.put(0xF637, "Rot_VL_dft");
        BIOS_TOMLIN_FUNCTIONS.put(0xF65B, "Xform_Run_a");
        BIOS_TOMLIN_FUNCTIONS.put(0xF65D, "Xform_Run");
        BIOS_TOMLIN_FUNCTIONS.put(0xF661, "Xform_Rise_a");
        BIOS_TOMLIN_FUNCTIONS.put(0xF663, "Xform_Rise");
        BIOS_TOMLIN_FUNCTIONS.put(0xF67F, "Move_Mem_a_1");
        BIOS_TOMLIN_FUNCTIONS.put(0xF683, "Move_Mem_a");
        BIOS_TOMLIN_FUNCTIONS.put(0xF687, "Init_Music_chk");
        BIOS_TOMLIN_FUNCTIONS.put(0xF68D, "Init_Music");
        BIOS_TOMLIN_FUNCTIONS.put(0xF692, "Init_Music_x");
        BIOS_TOMLIN_FUNCTIONS.put(0xF7A9, "Select_Game");
        BIOS_TOMLIN_FUNCTIONS.put(0xF84F, "Clear_Score");
        BIOS_TOMLIN_FUNCTIONS.put(0xF85E, "Add_Score_a");
        BIOS_TOMLIN_FUNCTIONS.put(0xF87C, "Add_Score_d");
        BIOS_TOMLIN_FUNCTIONS.put(0xF8B7, "Strip_Zeros");
        BIOS_TOMLIN_FUNCTIONS.put(0xF8C7, "Compare_Score");
        BIOS_TOMLIN_FUNCTIONS.put(0xF8D8, "New_High_Score");
        BIOS_TOMLIN_FUNCTIONS.put(0xF8E5, "Obj_Will_Hit_u");
        BIOS_TOMLIN_FUNCTIONS.put(0xF8F3, "Obj_Will_Hit");
        BIOS_TOMLIN_FUNCTIONS.put(0xF8FF, "Obj_Hit");
        BIOS_TOMLIN_FUNCTIONS.put(0xF92E, "Explosion_Snd");
        BIOS_TOMLIN_FUNCTIONS.put(0xFF9F, "Draw_Grid_VL");
        
        BIOSLABELS = BIOS_WT1_LABELS;
        BIOSLABELS2 = BIOS_WT1_LABELS2;
        BIOSFUNCTIONS = BIOS_WT1_FUNCTIONS;
    }
    public static void setStyle()
    {
        VideConfig config = VideConfig.getConfig();
        if (config.useTomlinConstants)
        {
            BIOSLABELS = BIOS_TOMLIN_LABELS;
            BIOSLABELS2 = BIOS_TOMLIN_LABELS2;
            BIOSFUNCTIONS = BIOS_TOMLIN_FUNCTIONS;
        }
        else
        {
            BIOSLABELS = BIOS_WT1_LABELS;
            BIOSLABELS2 = BIOS_WT1_LABELS2;
            BIOSFUNCTIONS = BIOS_WT1_FUNCTIONS;
        }
    }
    
    
    public static boolean isBIOSLabelPublic(String label, int address)
    {
        String l = BIOSLABELS.get(address);
        String l2 = BIOSLABELS2.get(address);
        boolean isLabel = false;

        if (l!=null) 
            isLabel = isLabel || (label.toLowerCase().equals(l.toLowerCase()));
        if (l2!=null) 
            isLabel = isLabel || (label.toLowerCase().equals(l2.toLowerCase()));

        return isLabel;
    }
    public static String getBIOSLabel(int address)
    {
        String l = BIOSLABELS.get(address);
        String l2 = BIOSLABELS2.get(address);
        if (l!=null) return l;
        return l2;
    }
    public static String getBIOSFunction(int address)
    {
        return BIOSFUNCTIONS.get(address);
    }
    
    boolean isBIOSLabel(String label, int address)
    {
        return false;
        // is obsolete with FORCE settings in CNT
        /*
        String l = BIOSLABELS.get(address);
        String l2 = BIOSLABELS2.get(address);
        boolean isLabel = false;

        if (l!=null) 
            isLabel = isLabel || (label.toLowerCase().equals(l.toLowerCase()));
        if (l2!=null) 
            isLabel = isLabel || (label.toLowerCase().equals(l2.toLowerCase()));

        return isLabel;
        */
    }
    
    String getNonBIOSLableFirst(ArrayList<String> labels, int address)
    {
        for (int i=0; i < labels.size(); i++)
        {
            String label = labels.get(i);
            if (!isBIOSLabel(label, address)) return label;
        }
        return labels.get(0);

    }
    
    public void setCreateLabels(boolean c)
    {
        createLabels = c;
    }
    /* substitute label for address if found */
    String checklabs(int address, MemoryInformation memInfo)
    {
        return checklabs(address, -1, memInfo);
    }
    String checklabs(int address, int mode, MemoryInformation memInfo)
    {
         return checklabs(address, mode, -1, memInfo);
    }
    String checklabs(int address, int mode, int dp, MemoryInformation memInfo)
    {
         return checklabs(address, mode, -1, -1, memInfo);
    }
    String checklabs(int address, int mode, int dp, int numOperands, MemoryInformation memInfo)
    {
        String labtemp="";
        boolean shortaddr=true;
        boolean hasLabel = false;
        
        MemoryInformation info =  myMemory.memMap.get(address);
        
        if (info != null)
        {
            ArrayList<String> labels = new ArrayList<String> ();
            if (mode == IMM)
            {
                labels = info.immediateLabels;
                if (labels.size() == 0)
                {
                    if (address>256)
                        labels = info.labels;
                }
            }
            else if (mode == DIR) 
            {
                if (dp != -1)// || (dp!=0)) ! // assuming 0 is also an incorrect dp register!
                {
                    boolean doVarTest = false;
                    HashMap<Integer, String> map = myMemory.directLabels.get(dp);
                    if (map != null)
                    {
                        String lab = map.get(address&0xff);
                        if (lab != null)
                            labtemp+=lab;
                        else
                            doVarTest = true;
                    } 
                    else
                    {
                        doVarTest = true;
                    }
                    if (doVarTest)
                    {
                        int testAddress = address+ (dp*256);
                        MemoryInformation info2 =  myMemory.memMap.get(testAddress);
                        if (info2.labels.size()>0)
                        {
                            if (memInfo.forcedSymbol!= null)
                            {
                                if (memInfo.forcedSymbol.length() != 0)
                                {
                                    for (int iii=0; iii<info2.labels.size(); iii++)
                                    {
                                        if (memInfo.forcedSymbol.equals(info2.labels.get(iii)))
                                        {
                                            labtemp+=info2.labels.get(iii);
                                        }
                                    }
                                }
                                else
                                {
                                    labtemp+=info2.labels.get(0);
                                }
                            }
                            else
                            {
                                labtemp+=info2.labels.get(0);
                            }
                            
                            // also add to direct labels for future use
                            HashMap<Integer, String> dmap = myMemory.directLabels.get(dp);
                            if (dmap == null)
                            {
                                dmap = new HashMap<Integer, String>();
                                myMemory.directLabels.put(dp, dmap);

                            } 
                            dmap.put(address, info2.labels.get(0));
                        }
                    }
                }
            }
            else
            {
                labels = info.labels;
            }
            if (labels.size()>0)
            {
                if (memInfo.forcedSymbol!= null)
                {
                    if (memInfo.forcedSymbol.length() != 0)
                    {
                        for (int iii=0; iii<labels.size(); iii++)
                        {
                            if (memInfo.forcedSymbol.equals(labels.get(iii)))
                            {
                                labtemp+=labels.get(iii);
                            }
                        }
                    }
                    else
                    {
                        labtemp+= getNonBIOSLableFirst(labels, address);
                    }
                }
                else
                {
                    labtemp+= getNonBIOSLableFirst(labels, address);
                }
               // labtemp+=labels.get(0);
                hasLabel = true;
            }
        }
        if (memInfo.forcedSymbol!= null)
        {
            if (memInfo.forcedSymbol.length() == 0)
            {
                labtemp ="";
                hasLabel = true;
            }
        }
        
        if (numOperands!=-1)
        {
            // 0 = inherent
            // 1 = 8 bit
            // 2 = 16 bit
            if ((numOperands == 0) || (numOperands == 1))
            {
                 shortaddr = true;
            }
            else
            {
                 shortaddr = false;
            }
        }
        else
        {
            if (((address<128)&&(address>-129)) || (mode == DIR))
            {
                 shortaddr = true;
            }
            else
            {
                 shortaddr = false;
            }
        }
        
        if (labtemp.length() == 0)
        {
            labtemp ="";
            // dont create labels for DIR mode
            if (((info != null) && (createLabels)) && ((mode == REL)||(mode == LREL)/*||(mode == DIR)*/||(mode == EXT)) )
            {
                labtemp = "_"+String.format("%04X", (address & 0xFFFF));
                info.labels.add(labtemp);
                hasLabel = true;
            }
            else
            {
                if ((address>=0)||(mode == DIR))
                {
                    if (shortaddr)
                        labtemp += DEF.hexPrefix+String.format("%02X", address & 0xFF);
                    else
                        labtemp += DEF.hexPrefix+String.format("%04X", address & 0xFFFF);
                }
                else
                {
                    if ((address<128)&&(address>-129))
                    {
                        if (shortaddr)
                            labtemp += "-"+DEF.hexPrefix+String.format("%02X", -address & 0xFF);
                        else // CSA ADDED 2023
                            labtemp += "-"+DEF.hexPrefix+String.format("%04X", -address & 0xFFFF);
                    }
                    else
                    {
                       labtemp += "-"+DEF.hexPrefix+String.format("%04X", -address & 0xFFFF);
                    }
                }
            }
        }
        if (mode == REL) 
        {
            address -= currentMemPointer;
            address = address & 0xff;
            if (address>=128) address-=256;
            if (!hasLabel)
            {
                int a = address & 0xff;
                if (a<128)
                    labtemp=  DEF.hexPrefix+String.format("%02X", a);
                else
                    labtemp = "-"+DEF.hexPrefix+String.format("%02X", 256-a);
                
            }
        }
        if (mode == LREL) 
        {
            address -= currentMemPointer;
            address = address & 0xffff;
            if (address>=32768) address-=65536;
            if (!hasLabel)
            {
                int a = address & 0xffff;
                if (a<32768) 
                    labtemp=  DEF.hexPrefix+  String.format("%04X", a);
                else
                    labtemp=  "-"+DEF.hexPrefix+String.format("%04X", 65536-a);
            }
        }
        
        if (mode != IMM)
        {
            myMemory.memMap.get(currentPC).referingToAddress = address;
        }
        myMemory.memMap.get(currentPC).referingToShort = shortaddr;
        return labtemp;
    }
    
    /* printoperands() - print operands for the given opcode */
    String printoperands(int opcode, int numoperands,int[] operandarray, int mode, String opname, int page, MemoryInformation memInfo)
    {
        int pb;
        int sp;
        int i,rel,offset=0,reg,pb2;
        boolean comma;
        String str="";
        String out2 = "";

        int dp = memInfo.directPageAddress;
        PC=false;

//        if (memInfo.address == 0x73c7)
//            System.out.println();
        
        myMemory.memMap.get(currentPC).referingAddressMode = mode;
        if( (opcode!=0x1f)&&(opcode!=0x1e) )
        {
            switch(mode)
            {     
                /* print before operands */
                case IMM:
                {
                    str+=DEF.immediatePrefix;
                    break;
                }
                case DIR:
                    break;
                case EXT:
                    break;
                default:
                     break;
            }
        }
        switch(mode)
        {
            case REL:          /* 8-bit relative */
                rel=operandarray[0];
                str+=checklabs((currentMemPointer+((rel<128) ? rel : rel-256)), mode,-1,1, memInfo);;
                break;
            case LREL:           /* 16-bit long relative */
                rel=(operandarray[0]<<8)+operandarray[1];
                str+=checklabs(currentMemPointer+((rel<32768) ? rel : rel-65536),mode,2, memInfo);
                break;
            case IND:         /* indirect- many flavors */
                pb=operandarray[0];
                reg=(pb>>5)&0x3;
                // filter out not allowed combinations
                // 1xxx 0111
                // 1xxx 1010
                // 1xxx 1110
                if ( ((pb & 0x8f) == 0x87) ||
                     ((pb & 0x8f) == 0x8a) ||
                     ((pb & 0x8f) == 0x8e)  )
                {
                    return incorrectDisassembleFoundAt(currentPC, "Illegal postbyte value for indexed addressing, bit combination of 4 lower bits.");                        
                }                
                // filter out not allowed combinations
                // 1xx1 0010
                // 1xx1 0000
                if ( ((pb & 0x9f) == 0x92) ||
                     ((pb & 0x9f) == 0x90) )
                {
                    return incorrectDisassembleFoundAt(currentPC, "Illegal postbyte value ,-R or ,R+  not allowed for indirect indexed addressing.");                        
                }          
                
                // filter out not allowed combinations
                // 1xx0 1111
                if ( ((pb & 0x9f) == 0x8f) )
                {
                    return incorrectDisassembleFoundAt(currentPC, "Illegal postbyte value 16 bit extended not allowed in indexed (non indirect) addressing.");                        
                }          
                // filter out not allowed combinations
                // 1011 1111
                // 1101 1111
                // 1111 1111
                if ( ((pb & 0xff) == 0xbf) ||
                     ((pb & 0xff) == 0xdf) ||
                     ((pb & 0xff) == 0xff)  )
                {
                    return incorrectDisassembleFoundAt(currentPC, "Illegal postbyte value 16 bit indirect indexed addressing expects bits 5 and 6 to be 0");                        
                }          
                
                // 1xxx 1100
                // 1xxx 1101
                if (( (pb&0x8f) == 0x8d) || ( (pb&0x8f) == 0x8c))
                {
                    // reg == PC!
                    reg = 4;
                    
                    if ( ((pb>>4) & 0x6) != 0)
                    {
    /*                    
                        1XX? ????
                        X bits can be anything,
                        asmj converts "sta <$30,pc"
                        to "ec 8c 30"
                        which is correct
                        but "ec ec 30"
                        but "ec dc 30"
                        but "ec bc 30" are also correct, but only the first 100% ressembles old binary
                        therefor the below three variants must be converted to DB, with comment not to convert to code!
                        this is true for both 16 bit or 8 bit variant!
    */                    
                        return incorrectDisassembleFoundAt(currentPC, "Ambiguous pc index addressing, postbytes bit 5 and 6 are non zero (assi generates 0).");                        
                    }
                }
                
                pb2=pb&0x8f;
                if ((pb2==0x88)||(pb2==0x8c))
                {   
                    /* 8-bit offset */
                    offset=getbyte();
                    memInfo.cycles+=1;
                    if (endOfFile)
                    {
                        return incorrectDisassembleFoundAt(currentPC, "End of file while reading operands (8bit).");                        
                    }
                    myMemory.memMap.get(currentPC).length++; // the offset is not "counted" as numoperands - strange!
                    myMemory.memMap.get(currentPC).familyBytes.add(myMemory.memMap.get(currentMemPointer-1));
                    myMemory.memMap.get(currentPC).disType++;
                    myMemory.memMap.get(currentPC).familyBytes.get(myMemory.memMap.get(currentPC).familyBytes.size()-1).belongsToInstruction = myMemory.memMap.get(currentPC);
                    myMemory.memMap.get(currentPC).familyBytes.get(myMemory.memMap.get(currentPC).familyBytes.size()-1).isInstructionByte = (myMemory.memMap.get(currentPC).familyBytes.size()-1)+1;
                    myMemory.memMap.get(currentPC).familyBytes.get(myMemory.memMap.get(currentPC).familyBytes.size()-1).hexDump = String.format("%02X", opcode);
                    myMemory.memMap.get(currentPC).familyBytes.get(myMemory.memMap.get(currentPC).familyBytes.size()-1).disType = MemoryInformation.DIS_TYPE_DATA_BELONGSTO_INSTRUCTION_POS_1+myMemory.memMap.get(currentPC).familyBytes.size()-1;
                    if (offset>127)         /* convert to signed */
                         offset=offset-256;
                    memInfo.disassembledMnemonic = opname; 

                    if((pb&0x90)==0x90)
                    {
                        memInfo.cycles+=3;
                         str += DEF.indexedPrefix;
                    }
                    if(pb==0x8c)
                         out2 = checklabs(offset, memInfo) +","+ regs[reg];
                    else if(offset>=0)
                    {
                        out2 = DEF.hexPrefix+String.format("%02X", offset)+","+regs[reg];
                        if (memInfo.forcedSymbol!=null)
                        {
                            if (memInfo.forcedSymbol.length()!=0)
                            {
                                MemoryInformation info =  myMemory.memMap.get(offset);
                                if (info!=null)
                                {
                                    for (int iii=0; iii<info.labels.size(); iii++)
                                    {
                                        if (memInfo.forcedSymbol.equals(info.labels.get(iii)))
                                        {
                                            out2=info.labels.get(iii)+","+regs[reg];
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else
                    {
                        out2 = "-"+DEF.hexPrefix+String.format("%02X", -offset)+","+regs[reg];
                        if (memInfo.forcedSymbol!=null)
                        {
                            if (memInfo.forcedSymbol.length()!=0)
                            {
                                MemoryInformation info =  myMemory.memMap.get(offset);
                                if (info!=null)
                                {
                                    for (int iii=0; iii<info.labels.size(); iii++)
                                    {
                                        if (memInfo.forcedSymbol.equals(info.labels.get(iii)))
                                        {
                                            out2=info.labels.get(iii)+","+regs[reg];
                                        }
                                    }
                                }
                            }
                        }
                    }
                    str += DEF._8bitPrefix+out2;
                }
                else if((pb2==0x89)||(pb2==0x8d)||(pb2==0x8f))
                { /* IND 16-bit */
                    int helper;
                    helper=getbyte();
                    memInfo.cycles+=4;
                    if (endOfFile)
                    {
                        return incorrectDisassembleFoundAt(currentPC, "End of file while reading operands (16 byte-1).");                        
                    }
                    myMemory.memMap.get(currentPC).length++; // the offset is not "counted" as numoperands - strange!
                    myMemory.memMap.get(currentPC).familyBytes.add(myMemory.memMap.get(currentMemPointer-1));
                    myMemory.memMap.get(currentPC).disType++;
                    myMemory.memMap.get(currentPC).familyBytes.get(myMemory.memMap.get(currentPC).familyBytes.size()-1).belongsToInstruction = myMemory.memMap.get(currentPC);
                    myMemory.memMap.get(currentPC).familyBytes.get(myMemory.memMap.get(currentPC).familyBytes.size()-1).isInstructionByte = (myMemory.memMap.get(currentPC).familyBytes.size()-1)+1;
                    myMemory.memMap.get(currentPC).familyBytes.get(myMemory.memMap.get(currentPC).familyBytes.size()-1).hexDump = String.format("%02X", opcode);
                    myMemory.memMap.get(currentPC).familyBytes.get(myMemory.memMap.get(currentPC).familyBytes.size()-1).disType = MemoryInformation.DIS_TYPE_DATA_BELONGSTO_INSTRUCTION_POS_1+myMemory.memMap.get(currentPC).familyBytes.size()-1;
        
                    offset=(helper<<8);
                    helper=getbyte();
                    if (endOfFile)
                    {
                        return incorrectDisassembleFoundAt(currentPC, "End of file while reading operands (16 byte-2).");                        
                    }
                    myMemory.memMap.get(currentPC).length++; // the offset is not "counted" as numoperands - strange!
                    myMemory.memMap.get(currentPC).familyBytes.add(myMemory.memMap.get(currentMemPointer-1));
                    myMemory.memMap.get(currentPC).disType++;
                    myMemory.memMap.get(currentPC).familyBytes.get(myMemory.memMap.get(currentPC).familyBytes.size()-1).belongsToInstruction = myMemory.memMap.get(currentPC);
                    myMemory.memMap.get(currentPC).familyBytes.get(myMemory.memMap.get(currentPC).familyBytes.size()-1).isInstructionByte = (myMemory.memMap.get(currentPC).familyBytes.size()-1)+1;
                    myMemory.memMap.get(currentPC).familyBytes.get(myMemory.memMap.get(currentPC).familyBytes.size()-1).hexDump = String.format("%02X", opcode);
                    myMemory.memMap.get(currentPC).familyBytes.get(myMemory.memMap.get(currentPC).familyBytes.size()-1).disType = MemoryInformation.DIS_TYPE_DATA_BELONGSTO_INSTRUCTION_POS_1+myMemory.memMap.get(currentPC).familyBytes.size()-1;
                    offset+=helper;
                    if ((pb!=0x8f)&&(offset>32767))
                        offset=offset-65536;
                    offset&=0xffff;
                    
                    memInfo.disassembledMnemonic = opname; 

                    if ((pb&0x90)==0x90)
                    {
                        str+=DEF.indexedPrefix;
                        memInfo.cycles+=3;
                        
                    }
                    if (reg == 4)
                    {
                        memInfo.cycles+=1;
                        
                    }
                    if(pb==0x9f)
                    {
                        out2 = checklabs(offset, memInfo);
                        memInfo.cycles-=2;
                    }
                    else if(pb==0x8d)
                        out2 = checklabs(offset, memInfo)+","+regs[reg];
                    else if (offset>=0)
                    {
                        out2 = DEF.hexPrefix+String.format("%04X", offset)+","+regs[reg];
                        if (memInfo.forcedSymbol!=null)
                        {
                            if (memInfo.forcedSymbol.length()!=0)
                            {
                                MemoryInformation info =  myMemory.memMap.get(offset);
                                if (info!=null)
                                {
                                    for (int iii=0; iii<info.labels.size(); iii++)
                                    {
                                        if (memInfo.forcedSymbol.equals(info.labels.get(iii)))
                                        {
                                            out2=info.labels.get(iii)+","+regs[reg];
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else
                    {
                        
                        out2 = "-"+DEF.hexPrefix+String.format("%04X", offset)+","+regs[reg];
                        if (memInfo.forcedSymbol!=null)
                        {
                            if (memInfo.forcedSymbol.length()!=0)
                            {
                                MemoryInformation info =  myMemory.memMap.get(offset);
                                if (info!=null)
                                {
                                    for (int iii=0; iii<info.labels.size(); iii++)
                                    {
                                        if (memInfo.forcedSymbol.equals(info.labels.get(iii)))
                                        {
                                            out2=info.labels.get(iii)+","+regs[reg];
                                        }
                                    }
                                }
                            }
                        }
                    }
                    str += DEF._16bitPrefix+out2;
                }

                else if ((pb&0x80) != 0)
                {
                   memInfo.disassembledMnemonic = opname; 
                   if((pb&0x90)==0x90)
                   {
                        str+=DEF.indexedPrefix;
                        memInfo.cycles+=3;
                       
                   }
                   if((pb&0x8f)==0x80)
                   {
                        out2=","+regs[reg]+"+";
                        str += out2;
                        memInfo.cycles+=2;
                   }
                   else if((pb&0x8f)==0x81)
                   {
                        out2=","+regs[reg]+"++";
                        str += out2;
                        memInfo.cycles+=3;
                   }
                   else if((pb&0x8f)==0x82)
                   {
                        out2=",-"+regs[reg]+"";
                        str += out2;
                        memInfo.cycles+=2;
                   }
                   else if((pb&0x8f)==0x83)
                   {
                        out2=",--"+regs[reg]+"";
                        str += out2;
                        memInfo.cycles+=3;
                   }
                   else if((pb&0x8f)==0x84)
                   {
                        out2=","+regs[reg]+"";
                        str += out2;
                   }
                   else if((pb&0x8f)==0x85)
                   {
                        out2="b,"+regs[reg]+"";
                        str += out2;
                        memInfo.cycles+=1;
                   }
                   else if((pb&0x8f)==0x86)
                   {
                        out2="a,"+regs[reg]+"";
                        str += out2;
                        memInfo.cycles+=1;
                   }
                   else if((pb&0x8f)==0x8b)
                   {
                        out2="d,"+regs[reg]+"";
                        str += out2;
                        memInfo.cycles+=4;
                   }
                }
                else
                {       /* IND 5-bit offset */
                    offset=pb&0x1f;
                    if (offset>15)
                        offset=offset-32;
                    memInfo.disassembledMnemonic = opname; 
                    if (offset<0)
                        out2 = "-"+DEF.hexPrefix+String.format("%02X", -offset)+","+regs[reg];
                    else
                        out2 = DEF.hexPrefix+String.format("%02X", offset)+","+regs[reg];
                    if (memInfo.forcedSymbol!=null)
                    {
                        if (memInfo.forcedSymbol.length()!=0)
                        {
                            MemoryInformation info =  myMemory.memMap.get(offset);
                            if (info!=null)
                            {
                                for (int iii=0; iii<info.labels.size(); iii++)
                                {
                                    if (memInfo.forcedSymbol.equals(info.labels.get(iii)))
                                    {
                                        out2=info.labels.get(iii)+","+regs[reg];
                                    }
                                }
                            }
                        }
                    }
                    
                    
                    str += DEF._5bitPrefix + out2;
                    memInfo.cycles+=1;
                }
                if((pb&0x90)==0x90)
                    str+=DEF.indexedPostfix;
                break;
            default:
                if((opcode==0x1f)||(opcode==0x1e))
                {         /* TFR/EXG */
                    out2 = ""+teregs[(operandarray[0]>>4)&0xf]+","+teregs[operandarray[0]&0xf];
                    str += out2;
                }
                else if((opcode==0x34)||(opcode==0x36))
                {     /* PUSH */
                    comma=false;
                    if ((operandarray[0]&0x80)>0)
                    {
                        str += "pc";
                        comma=true;
                        PC=true;
                        memInfo.cycles+=2;
                    }
                    if ((operandarray[0]&0x40)>0)
                    {
                        if(comma)
                            str+=",";
                        if((opcode==0x34)||(opcode==0x35))
                            str+="u";
                        else
                            str+="s";
                        memInfo.cycles+=2;
                        comma=true;
                    }
                    if((operandarray[0]&0x20)>0)
                    {
                        if(comma)
                            str+=",";
                         str+="y";
                         comma=true;
                        memInfo.cycles+=2;
                    }
                    if((operandarray[0]&0x10)>0)
                    {
                        if(comma)
                            str+=",";
                         str+="x";
                         comma=true;
                        memInfo.cycles+=2;
                    }
                    if((operandarray[0]&0x8)>0)
                    {
                        if(comma)
                            str+=",";
                        str+="dp";
                        comma=true;
                        memInfo.cycles+=1;
                    }
                    if((operandarray[0]&0x4)>0)
                    {
                        if(comma)
                            str+=",";
                        str+="b";
                        comma=true;
                        memInfo.cycles+=1;
                    }
                    if((operandarray[0]&0x2)>0)
                    {
                        if(comma)
                            str+=",";
                        str+="a";
                        comma=true;
                        memInfo.cycles+=1;
                    }
                    if((operandarray[0]&0x1)>0)
                    {
                        if(comma)
                            str+=",";
                        str+="cc";
                        memInfo.cycles+=1;
                    }
                }
                else if((opcode==0x35)||(opcode==0x37))
                {    /* PULL */
                    comma=false;
                    if((operandarray[0]&0x1)>0)
                    {
                        str+="cc";
                        comma=true;
                        memInfo.cycles+=1;
                    }
                    if((operandarray[0]&0x2)>0)
                    {
                        if(comma)
                            str+=",";
                        str+="a";
                        comma=true;
                        memInfo.cycles+=1;
                    }
                    if((operandarray[0]&0x4)>0)
                    {
                        if(comma)
                            str+=",";
                        str+="b";
                        comma=true;
                        memInfo.cycles+=1;
                    }
                    if((operandarray[0]&0x8)>0)
                    {
                        if(comma)
                            str+=",";
                        str+="dp";
                        comma=true;
                        memInfo.cycles+=1;
                    }
                    if((operandarray[0]&0x10)>0)
                    {
                        if(comma)
                            str+=",";
                        str+="x";
                         comma=true;
                        memInfo.cycles+=2;
                    }
                    if((operandarray[0]&0x20)>0)
                    {
                        if(comma)
                            str+=",";
                        str+="y";
                        comma=true;
                        memInfo.cycles+=2;
                    }
                    if((operandarray[0]&0x40)>0)
                    {
                        if(comma)
                            str+=",";
                        if((opcode==0x34)||(opcode==0x35))
                            str+="u";
                        else
                            str+="s";
                        comma=true;
                        memInfo.cycles+=2;
                    }
                    if((operandarray[0]&0x80)>0)
                    {
                        if(comma)
                            str+=",";
                        str+="pc";
                        PC=true;
                        memInfo.cycles+=2;
                    }
                }
                else
                {
                    if(numoperands==0);
                    else if(numoperands==2)
                    {
                        if (mode != IMM)str += DEF._16bitPrefix;
//                        str += checklabs((operandarray[0]<<8)+operandarray[1], mode, numoperands, memInfo);
                        str += checklabs((operandarray[0]<<8)+operandarray[1], mode, -1, numoperands, memInfo);
                        
                    }
                    else if (numoperands==1) //((numoperands==1)&&(mode!=IMM))
                    {
                        //give indicate 1 operand = 8 bit
                        if (mode != IMM)str += DEF._8bitPrefix;
                        str += checklabs(operandarray[0], mode, dp, numoperands , memInfo);
                    }
                    else
                    {
                        if (mode != IMM)str += DEF._5bitPrefix;
                        str += DEF.hexPrefix;
                        for(i=0;i<numoperands;i++)
                        {
                            str += String.format("%02X", operandarray[i])+"";
                        }
                    }
                }
            break;
        }
        return str;
    }
    
    
    // disassembles one memory location (but ALSO more, if an opcode with opradns is found)   
    public String disassemble(int startAddress)
    {
        currentPC = startAddress;
        currentInstructionStartAddress = startAddress;
        currentMemPointer = startAddress;
        int[] operand = new int[4];
        int opcode;
        Opcodeinfo op;
        int i,j,k;
        int sp;
        int page;
        int numoperands;
        int familyCounter =-1;

        opcode=getbyte();
                    
        if (endOfFile) 
            return incorrectDisassembleFoundAt(startAddress, "End of file while reading byte.");
        MemoryInformation memInfo = myMemory.memMap.get(startAddress);
        
        // in case of ReDis
        // reset values, since below, we "add"
        memInfo.reset();
        

        if (
                   (memInfo.disType != MemoryInformation.DIS_TYPE_UNKOWN) 
                && (memInfo.disType != MemoryInformation.DIS_TYPE_DATA_INSTRUCTION_GENERAL) 
                && (memInfo.disType != MemoryInformation.DIS_TYPE_CODE) 
                && (memInfo.disType != MemoryInformation.DIS_TYPE_LOADED)) 
            return "Memory location known, not disassembled again.";

        memInfo.hexDump = DEF.hexPrefix+String.format("%02X", opcode);
        op=null;

        // in i the number of the opcode in the pg1.opcode table!
        for(i=0;(i<numops[0])&&(pg1opcodes[i].opcode!=opcode);i++)
            ;
        
        int iLen = DASMStatics.getNumOpcodes(memInfo.content, myMemory.memMap.get((startAddress+1)%65536 ).content);
        boolean ok = true;
        for (int il=0;il<iLen;il++)
        {
            MemoryInformation memInfo2 = myMemory.memMap.get((startAddress+1+il)%65536);
            if (
                   (memInfo2.disType == MemoryInformation.DIS_TYPE_DATA_BYTE) 
                || (memInfo2.disType == MemoryInformation.DIS_TYPE_DATA_DECIMAL) 
                || (memInfo2.disType == MemoryInformation.DIS_TYPE_DATA_WORD) 
                || (memInfo2.disType == MemoryInformation.DIS_TYPE_DATA_WORD_POINTER) 
                || (memInfo2.disType == MemoryInformation.DIS_TYPE_DATA_CHAR) 
                || (memInfo2.disType == MemoryInformation.DIS_TYPE_DATA_BINARY)) 
            {
        memInfo.reset();
//                uncast(memInfo2);
                //ok = false;
            }
        }


        if (!ok)
        {
                memInfo.length = 0;
                memInfo.disassembledMnemonic = "DB";

                memInfo.disassembledOperand += DEF.hexPrefix+String.format("%02X", (memInfo.content&0xff));
                memInfo.length++;
/*                
                boolean inLoop = false;
                String c;
                MemoryInformation orgInfo = info;
                orgInfo.disassembledOperand = "";
                while (info.disType == MemoryInformation.DIS_TYPE_DATA_BYTE)
                {
                    if (orgInfo.length>=orgInfo.disTypeCollectionMax)
                    {
                        break;
                    }
                    if (i+orgInfo.length>=65536)
                    {
                        break; 
                    }
                    info.done = true;
                    c = "";
                    if (inLoop)
                        c += ", ";
                    c += DEF.hexPrefix+String.format("%02X", (info.content&0xff));
                    inLoop = true;
                    
                    orgInfo.disassembledOperand += c;
                    orgInfo.length++;
                    info = myMemory.memMap.get(i+orgInfo.length);
                    if (info == null) break;
                }
*/

            return "";
        }
        
        
        memInfo.indexInOpcodeTablePage0 = i;
        memInfo.disType = MemoryInformation.DIS_TYPE_DATA_INSTRUCTION_1_LENGTH; // might be changed later

        if(i<numops[0]) // opcode found in page 0
        {    /* opcode found */
            if (pg1opcodes[i].mode>=PG2) // switch to other page?
            {   
                /* page switch */
                page=pg1opcodes[i].mode-PG2+1;       /* get page # */
                memInfo.page = page;
                memInfo.cycles = pg1opcodes[i].numcycles;
                int helper=getbyte();
                if (endOfFile)
                {
                    return incorrectDisassembleFoundAt(startAddress, "End of file while at page seek.");
                }
                opcode=helper;
                memInfo.familyBytes.add(myMemory.memMap.get(currentMemPointer-1));
                memInfo.disType++;
                familyCounter++;

                memInfo.familyBytes.get(familyCounter).belongsToInstruction = memInfo;
                memInfo.familyBytes.get(familyCounter).isInstructionByte = familyCounter+1;
                memInfo.familyBytes.get(familyCounter).hexDump = String.format("%02X", opcode);
                memInfo.familyBytes.get(familyCounter).disType = MemoryInformation.DIS_TYPE_DATA_BELONGSTO_INSTRUCTION_POS_1+familyCounter;

                // find opcode in page
                for(k=0;(k<numops[page])&&(opcode!=pgpointers[page][k].opcode);k++)
                    ;
                if (page == 1)
                    memInfo.familyBytes.get(familyCounter).indexInOpcodeTablePage1 = k;
                if (page == 2)
                    memInfo.familyBytes.get(familyCounter).indexInOpcodeTablePage2 = k;

                if (k!=numops[page])
                {   /* opcode found */
                    op=pgpointers[page][k];

                    numoperands=pgpointers[page][k].numoperands;
                    memInfo.cycles+=pgpointers[page][k].numcycles;
                    for(j=0;j<numoperands-1;j++)
                    {
                        int helper2 = getbyte();

                        memInfo.familyBytes.add(myMemory.memMap.get(currentMemPointer-1));
                        memInfo.disType++;
                        familyCounter++;

                        memInfo.familyBytes.get(familyCounter).belongsToInstruction = memInfo;
                        memInfo.familyBytes.get(familyCounter).isInstructionByte = familyCounter+1;
                        memInfo.familyBytes.get(familyCounter).hexDump = String.format("%02X", helper2);
                        memInfo.familyBytes.get(familyCounter).disType = MemoryInformation.DIS_TYPE_DATA_BELONGSTO_INSTRUCTION_POS_1+familyCounter;
                        operand[j]=helper2;
                        if (endOfFile)
                        {
                            return incorrectDisassembleFoundAt(startAddress, "End of file while at page "+(page+1)+" opcode search.");
                        }
                    }
                    if (j!=numoperands-1)
                        return incorrectDisassembleFoundAt(startAddress, "End of file while at page "+(page+1)+": incorrect number of operands.");
                    if(pgpointers[page][k].mode!=IND)
                    {
                        memInfo.disassembledMnemonic += pgpointers[page][k].name;
                    }
                    
                    String opAdd = printoperands(opcode,(numoperands-1),operand,pgpointers[page][k].mode,pgpointers[page][k].name,page,memInfo);
                    
                    if ((memInfo.disType == MemoryInformation.DIS_TYPE_DATA_BYTE) || (memInfo.disType == MemoryInformation.DIS_TYPE_DATA_DECIMAL))
                    {
                        ;// an error occured while evaluating the printperands
                    }
                    else
                    {
                        memInfo.disassembledOperand += opAdd;
                        memInfo.length = 1 + memInfo.familyBytes.size();
                    }
                }
                else
                {   /* not found in alternate page */
                    return incorrectDisassembleFoundAt(startAddress, "Opcode not found in any page.");
                }
            }
            else
            {          
                /* page 1 opcode */
                memInfo.page=0; 
                memInfo.cycles = pg1opcodes[i].numcycles;
                op = pg1opcodes[i];
                numoperands=pg1opcodes[i].numoperands;
                for(j=0;j<numoperands;j++)
                {
                    int helper2 = getbyte();
                    memInfo.familyBytes.add(myMemory.memMap.get(currentMemPointer-1));
                    memInfo.disType++;
                    familyCounter++;

                    memInfo.familyBytes.get(familyCounter).belongsToInstruction = memInfo;
                    memInfo.familyBytes.get(familyCounter).isInstructionByte = familyCounter+1;
                    memInfo.familyBytes.get(familyCounter).hexDump = String.format("%02X", helper2);
                    memInfo.familyBytes.get(familyCounter).disType = MemoryInformation.DIS_TYPE_DATA_BELONGSTO_INSTRUCTION_POS_1+familyCounter;
                    operand[j]=helper2;
                    if (endOfFile)
                    {
                        return incorrectDisassembleFoundAt(startAddress, "End of file while in opcode search Page 1.");
                    }
                }
                if (j!=numoperands)
                    return incorrectDisassembleFoundAt(startAddress, "Opcode search Page 1: incorrect number of operands.");

                boolean c1 = teregs[(operand[0]>>4)&0xf].toUpperCase().equals("INV");
                boolean c2 = teregs[operand[0]&0xf].toUpperCase().equals("INV");
                sizeWarning = false;
                
                if (  ((opcode==0x1f) || (opcode==0x1e)) 
                    &&   (((teregssize[(operand[0]>>4)&0xf]-teregssize[operand[0]&0xf])!=0) )
                   )
                {
                    if (DASM6809.ALLOW_DIF_TRANSFER)
                    {
                        sizeWarning = true;
                    }
                    else
                    {
                        return incorrectDisassembleFoundAt(startAddress, "Illegal Register code (EXG/TFR).");
                    }
                    
                }
                
                
                if (  ((opcode==0x1f) || (opcode==0x1e)) 
                    && ( (c1) || (c2) /*|| ((teregssize[(operand[0]>>4)&0xf]-teregssize[operand[0]&0xf])!=0) */ )
                   )
                {
                    sizeWarning = false;
                    return incorrectDisassembleFoundAt(startAddress, "Illegal Register code (EXG/TFR).");
                }
                else if (((opcode==0x34)||(opcode==0x35)||(opcode==0x36)||(opcode==0x37))&&(operand[0]==0))
                {
                    /* test if push/pull register codes are right */
                    /* illegal register */
                    return incorrectDisassembleFoundAt(startAddress, "Illegal Register code (PUSH/PULL).");
                }
                else
                {
                    if (sizeWarning)
                    {
                        memInfo.comments.add("WARNING mismatching operand size found");
                        sizeWarning = false;
                    }

                    if (pg1opcodes[i].mode!=IND)
                    {
                        memInfo.disassembledMnemonic += pg1opcodes[i].name;
                    }
                    String opAdd = printoperands(opcode,numoperands,operand, pg1opcodes[i].mode,pg1opcodes[i].name,0,memInfo);
                    if ((memInfo.disType == MemoryInformation.DIS_TYPE_DATA_BYTE) || (memInfo.disType == MemoryInformation.DIS_TYPE_DATA_DECIMAL))
                    {
                        ;// an error occured while evaluating the printperands
                    }
                    else
                    {
                        memInfo.disassembledOperand += opAdd;
                        memInfo.length = 1 + memInfo.familyBytes.size();
                    }
                }
            }
        }
        else if(i==numops[0])
        {   
            return incorrectDisassembleFoundAt(startAddress, "Opcode not found (page 1).");
        }
        PC=false;
        return "";
    }
    public MemoryInformationTableModel getTableModel()
    {
        return MemoryInformationTableModel.createModel(myMemory);
    }
    public MemoryInformationTableModelSmall getTableModelSmall()
    {
        return MemoryInformationTableModelSmall.createModel(myMemory);
    }
    String incorrectDisassembleFoundAt(int startAddress, String errorMsg)
    {
        MemoryInformation memInfo = myMemory.memMap.get(startAddress);

        if (memInfo == null)
            return "";
        memInfo.reset();
        memInfo.disType = MemoryInformation.DIS_TYPE_DATA_BYTE;
        memInfo.disassembledMnemonic = "DB";
        memInfo.disassembledOperand = String.format("$%02X", memInfo.content&0xff);
        
        /*
        memInfo.length = 1;
        memInfo.indexInOpcodeTablePage0 = -1;
        memInfo.indexInOpcodeTablePage1 = -1;
        memInfo.indexInOpcodeTablePage2 = -1;
        memInfo.page = -1;
        memInfo.belongsToInstruction = null;
        
        // reset following family bytes, that we might have "damaged"
        for (MemoryInformation mi: memInfo.familyBytes)
        {
            mi.isInstructionByte = 0;
            mi.hexDump = "";
            mi.belongsToInstruction = null;
            mi.disType = MemoryInformation.DIS_TYPE_UNKOWN;
            
        }
        memInfo.familyBytes.clear();
        */
        memInfo.comments.add("DISSI "+errorMsg);
        memInfo.disassemblerInfoText = errorMsg;
        return errorMsg;
    }
    
    public boolean readCNTFile(String name)
    {
        try 
        {
            BufferedReader br = new BufferedReader(new FileReader(name));
            try 
            {
                StringBuilder sb = new StringBuilder();
                String line = br.readLine();
                while (line != null) 
                {
                    doOneCNTLine(line);
                    line = br.readLine();
                }
                return true;
            } 
            catch (Throwable ex)
            {
                // ignore
                log.addLog(ex, WARN);
            }
            finally 
            {
                br.close();
            }        
        } 
        catch (Throwable ex)
        {
            // ignore
        }
        return false;
    }
    public static int toNumber(String s)
    {
        return toNumber( s, false);
    }
    public static int toNumber(String s, boolean largeAllowed)
    {
        s = de.malban.util.UtilityString.replace(s, "$$","$");
        s = s.toUpperCase();
        boolean minus = false;
        int radix = 10;
        int result = 0;
        if (s.startsWith("-"))
        {
            minus=true;
            s = s.substring(1);
        }
        if (s.startsWith("+"))
        {
            s = s.substring(1);
        }
        if (s.startsWith("$"))
        {
            radix = 16;
            s = s.substring(1);
        }
        if (s.startsWith("%"))
        {
            radix = 2;
            s = s.substring(1);
        }
        if (s.startsWith("b"))
        {
            radix = 2;
            s = s.substring(1);
        }
        
        if (s.startsWith("0X"))
        {
            s= s.substring(2);
            radix = 16;
        }
        try
        {
            result = Integer.parseInt(s, radix);
            if (minus) result *=-1;
            if (!largeAllowed)
                result = result &(0xffff);
        }
        catch (Throwable ex)
        {
            
        }
        return result;
    }
    
    // returns adress of vectrex program start
    public int processVectrexHeader()
    {
        // look for startaddress
        // and vectrex header in rom
        int a = 0;
        int stringOrg = a;
        MemoryInformation info;
        myMemory.memMap.get(a).length = 0;
        myMemory.memMap.get(a).comments.add("GCS Copyright");
        myMemory.memMap.get(a).disTypeCollectionMax = 30;

        do
        {
            info = myMemory.memMap.get(a++);
            if (info == null) return -1;
            if (a > 0x8000) return -1;
            info.disType = MemoryInformation.DIS_TYPE_DATA_CHAR; // Copyright
            info.typeWasSet = true;
            myMemory.memMap.get(stringOrg).length++;
        } while ((info.content & 0xff) != 0x80);
        info.disType = MemoryInformation.DIS_TYPE_DATA_BYTE; // last of string is a $80 byte
        info.typeWasSet = true;
        info = myMemory.memMap.get(a++);

        info.comments.add("Start music pointer");
        info.length = 2;
        info.disType = MemoryInformation.DIS_TYPE_DATA_WORD_POINTER; // music word pointer
        info.typeWasSet = true;
        info = myMemory.memMap.get(a++);
        info.disType = MemoryInformation.DIS_TYPE_DATA_WORD_POINTER; // music word pointer
        info.typeWasSet = true;
        while (myMemory.memMap.get(a).content != 0)
        {
            info = myMemory.memMap.get(a++);
            info.comments.add("hight, width, rel y, rel x (from 0,0)");
            info.disTypeCollectionMax = 4;
            info.disType = MemoryInformation.DIS_TYPE_DATA_BYTE; // Text Pos and size
            info.typeWasSet = true;
            info = myMemory.memMap.get(a++);
            info.disType = MemoryInformation.DIS_TYPE_DATA_BYTE; // Text Pos and size
            info.typeWasSet = true;
            info = myMemory.memMap.get(a++);
            info.disType = MemoryInformation.DIS_TYPE_DATA_BYTE; // Text Pos and size
            info.typeWasSet = true;
            info = myMemory.memMap.get(a++);
            info.disType = MemoryInformation.DIS_TYPE_DATA_BYTE; // Text Pos and size
            info.typeWasSet = true;

            myMemory.memMap.get(a).comments.add("individual title String(s)");
            stringOrg = a;
            myMemory.memMap.get(stringOrg).length = 0;
            do
            {
                info = myMemory.memMap.get(a++);
                info.disTypeCollectionMax = 30;
                info.disType = MemoryInformation.DIS_TYPE_DATA_CHAR;
                info.typeWasSet = true;
                myMemory.memMap.get(stringOrg).length++;
            } while ((info.content & 0xff) != 0x80);
            info.disType = MemoryInformation.DIS_TYPE_DATA_BYTE; // last of string is a $80 byte
            info.typeWasSet = true;
        }
        
        myMemory.memMap.get(a).disType = MemoryInformation.DIS_TYPE_DATA_BYTE; // end of header
        myMemory.memMap.get(a).typeWasSet = true;
        myMemory.memMap.get(a).comments.add("end of header");
        a++;
        myMemory.memMap.get(a).comments.add("start of cartridge code!");
        myMemory.memMap.get(a).labels.add("start");
        return a;        
    }
    

    public void resetInfo()
    {
        myMemory.reset();
        myMemory.init();
        currentCNTScanBank = 0;
    }
    public void reset()
    {
        myMemory.reset();
        myMemory.init();
        currentCNTScanBank = 0;
    }
    // data = memory dump data
    // startAddress - start Adress of memory dump
    // startDisAddress, address at which to start disassembler
    // assumeVectrex - if yes and startAdress == 0
    //               - a header in vectrex format is looked for and startDisAddress is set to the byte following    
    //               - also, if available a "SYSTEM.CNT" and a "SYSTEM.BIN" is loaded
    public String disassemble(byte[] data, int romStartAddress, int disassemblyStartAddress, boolean assumeVectrexModule)
    {
        return disassemble(data, romStartAddress, disassemblyStartAddress, assumeVectrexModule, 0);
    }
    public String disassemble(byte[] data, int romStartAddress, int disassemblyStartAddress, boolean assumeVectrexModule, int bank)
    {
        return disassemble(data, romStartAddress, disassemblyStartAddress, assumeVectrexModule, bank, false);
    }
    public String disassemble(byte[] data, int romStartAddress, int disassemblyStartAddress, boolean assumeVectrexModule, int bank, boolean fullMode)
    {
        myMemory.setBank(bank, true);
        currentCNTScanBank = bank;
        if (!fullMode)
        {
            String biosName = null;
            String tmpFile = de.malban.util.UtilityFiles.convertSeperator(Global.mainPathPrefix+config.usedSystemRom);
            if (new File (tmpFile).exists())
            {
                biosName = new File (tmpFile).getName();
            }
            if (biosName == null)
            {
                biosName = "system.img";
            }

            String biosNameOnly = biosName.substring(0, biosName.indexOf("."));
            
            
            if (assumeVectrexModule)
            {
                boolean tmp = createLabels;
                createLabels = false; // stupid labels may be generated, since some data is perhaps dissed
                try
                {
                    // init names from statics
                    // option:
                    // use lst/cnt for BIOS
                    // if not
                    // use tomlin / WT

                    if (!config.usefilebasedBIOSConstants)
                    {
                        supplyBIOSLabels();
                    }
                    else
                    {
                        if (config.lstFirst)
                        {
                            boolean done = readLSTFile(Global.mainPathPrefix+"system"+File.separator+biosNameOnly+".lst", true);
                            if (!done)
                                readCNTFile(Global.mainPathPrefix+"system"+File.separator+biosNameOnly+".cnt");
                        }
                        else 
                        {
                            boolean done = readCNTFile(Global.mainPathPrefix+"system"+File.separator+biosNameOnly+".cnt");
                            if (!done)
                                readLSTFile(Global.mainPathPrefix+"system"+File.separator+biosNameOnly+".lst", true);
                        }
                    }
                    Path path = Paths.get(tmpFile);
                    
                    byte[] biosData = Files.readAllBytes(path);
                    disassemble(biosData,0xe000, 0xe000, false, bank);
                }
                catch (Throwable e)
                {
                    log.addLog("An error occured while loading vectrex bios files. ["+tmpFile+"]", WARN);
                    log.addLog("Disassembly will continue without additional BIOS information!", WARN);
                    log.addLog(de.malban.util.Utility.getStackTrace(e), WARN);
                }
                createLabels = tmp;
                for (int m= 0xc800; m<= 0xcbff; m++)
                {
                    // todo: fixme 
                    // special cards like spekturm...
                    myMemory.memMap.get(m).memType = MEM_TYPE_RAM;
                }
                for (int m= 0xD000; m<= 0xD7FF; m++)
                {
                    myMemory.memMap.get(m).memType = MEM_TYPE_IO;
                }
                for (int m= 0xD800; m<= 0xDFFF; m++)
                {
                    myMemory.memMap.get(m).memType = MEM_TYPE_BAD;
                }
            }
            if (data == null) return "";
        }
        

        
        // Changed fpr 48k
        int len = data.length;
        if (len > 49152) len = 49152;
        
        
        // check for:
        // BDF1AF - JSR DP_to_C8
        // BDF1AA - JSR DP_to_D0
        // 86D01F8B - lda #$D0 TFR a,dp
        // 86C81F8B - lda #$C8 TFR a,dp
        
        
        endOfFile = false;
        // set contents of rom to internal memory
        for (int i=romStartAddress; i<romStartAddress+len; i++)
            myMemory.buildMemInfo(i, data[i-romStartAddress]);
     
        if ((romStartAddress == 0) && (assumeVectrexModule))
        {
            disassemblyStartAddress = processVectrexHeader();
            if (disassemblyStartAddress==-1) return "";
        }
        if (!fullMode)
            doAllKnownMemoryLocations(romStartAddress, romStartAddress+len);
        // known memeory locations done
        
        for (int i=disassemblyStartAddress; i< romStartAddress+len; )
        {
            // CHECK Whether current adress should be disassembled
            // or  be printed as data!
            MemoryInformation info = myMemory.memMap.get(i);
            if (info.done)
            {
                i+= info.length;
                continue;
            }
            // do disassemble
            disassemble(i);
            // String s = myMemory.memMap.get(i).instructionDisassembled+"\n";
            i+= myMemory.memMap.get(i).length;
        }
        return "";//getOutPutString(romStartAddress, data.length );
    }   
    
    void reDisassemble(boolean all)
    {
        int end = 0xc000;
        if (all) end = 0xffff+1;
        
        doAllKnownMemoryLocations(0, end);
    }
    
    public int getInstructionLengthAt(int address)
    {
        return myMemory.memMap.get(address).length;
    }
    
    // "disassembler" all memory locations, which are already known
    // this is called after loading CNT files
    // probably only "data" sections are processed!
    public void doAllKnownMemoryLocations(int startDisAddress, int endDisAddress)
    {        
        // doAllKnownmemoryLocations
        for (int i=startDisAddress; i< endDisAddress; )
        {
//            if (i == 3641)
//                System.out.println("BUG!");
            
            int wasDissed = 0;
            // CHECK Whether current adress should be disassembled
            // or  be printed as data!
            MemoryInformation info = myMemory.memMap.get(i);
            
            if (info.disType == MemoryInformation.DIS_TYPE_UNKOWN)
            {
                i += 1;
                continue;
            }
            if (info.disType == MemoryInformation.DIS_TYPE_LOADED)
            {
                i += 1;
                continue;
            }
            if (info.done)
            {
                // if == 0, than this instruction belonged originally to another instruction - but not anymore
                if (info.disassembledOperand.length()!=0)
                {
                    i+= info.length;
                    continue;
                }
            }
            if (info.disType == MemoryInformation.DIS_TYPE_DATA_DECIMAL)
            {
                info.length = 0;
                info.disassembledMnemonic = "DB";
                
                boolean inLoop = false;
                String c;
                MemoryInformation orgInfo = info;
                orgInfo.disassembledOperand = "";
                while (info.disType == MemoryInformation.DIS_TYPE_DATA_DECIMAL)
                {
                    if (orgInfo.length>=orgInfo.disTypeCollectionMax)
                    {
                        break;
                    }
                    if (i+orgInfo.length>=65536)
                    {
                        break; 
                    }
                    info.done = true;
                    c = "";
                    if (inLoop)
                        c += ", ";
                    if ( ( (info.content&0xff) >=0) && ( (info.content&0xff) <128) )
                        c += (info.content&0xff);
                    else
                        c += (-(256 - (info.content&0xff)));
                        
                    inLoop = true;
                    
                    orgInfo.disassembledOperand += c;
                    orgInfo.length++;
                    info = myMemory.memMap.get(i+orgInfo.length);
                    if (info == null) break;
                }
            }
            else
            if (info.disType == MemoryInformation.DIS_TYPE_DATA_BYTE)
            {
                info.length = 0;
                info.disassembledMnemonic = "DB";
                
                boolean inLoop = false;
                String c;
                MemoryInformation orgInfo = info;
                orgInfo.disassembledOperand = "";
                while (info.disType == MemoryInformation.DIS_TYPE_DATA_BYTE)
                {
                    if (orgInfo.length>=orgInfo.disTypeCollectionMax)
                    {
                        break;
                    }
                    if (i+orgInfo.length>=65536)
                    {
                        break; 
                    }
                    info.done = true;
                    c = "";
                    if (inLoop)
                        c += ", ";
                    c += DEF.hexPrefix+String.format("%02X", (info.content&0xff));
                    inLoop = true;
                    
                    orgInfo.disassembledOperand += c;
                    orgInfo.length++;
                    info = myMemory.memMap.get(i+orgInfo.length);
                    if (info == null) break;
                }
            }
            else
            if (info.disType == MemoryInformation.DIS_TYPE_DATA_BINARY)
            {
                info.length = 0;
                info.disassembledMnemonic = "DB";

                boolean inLoop = false;
                String c;
                MemoryInformation orgInfo = info;
                orgInfo.disassembledOperand = "";
                while (info.disType == MemoryInformation.DIS_TYPE_DATA_BINARY)
                {
                    if (orgInfo.length>=orgInfo.disTypeCollectionMax)
                    {
                        break;
                    }
                    if (i+orgInfo.length>=65536)
                    {
                        break; 
                    }
                    info.done = true;
                    c = "";
                    if (inLoop)
                        c += ", ";
                    c += "%"+ printbinary((info.content&0xff));
                    inLoop = true;
                    
                    orgInfo.disassembledOperand += c;
                    orgInfo.length++;
                    info = myMemory.memMap.get(i+orgInfo.length);
                    if (info == null) break;
                }
            }
            else if (info.disType == MemoryInformation.DIS_TYPE_DATA_WORD)
            {
/*                
                info.length = 2;
                info.done = true;
                int word = (info.content&0xff)*256;
                word += (myMemory.memMap.get(i+1).content & 0xff);
                info.disassembledMnemonic = "DW";
                info.disassembledOperand = DEF.hexPrefix+String.format("%04X", word);
                // disMax not done for word yet
                // todo fixme!
*/                
                
                info.length = 0;
                info.disassembledMnemonic = "DW";

                
                boolean inLoop = false;
                String c;
                MemoryInformation orgInfo = info;
                orgInfo.disassembledOperand = "";
                while (info.disType == MemoryInformation.DIS_TYPE_DATA_WORD)
                {
                    if (orgInfo.length>=orgInfo.disTypeCollectionMax)
                    {
                        break;
                    }
                    if (i+orgInfo.length>=65536)
                    {
                        break;
                    }
                    info.done = true;

//                    info.length = 2;
//                    info.done = true;
                    int word = (info.content&0xff)*256;
                    word += (myMemory.memMap.get(info.address+1).content & 0xff);


                    c = "";
                    if (inLoop)
                        c += ", ";
                    c += DEF.hexPrefix+String.format("%04X", word);
                    inLoop = true;
                    
                    orgInfo.disassembledOperand += c;
                    orgInfo.length+=2;
                    info = myMemory.memMap.get(i+orgInfo.length);
                    if (info == null) break;
                }
            }
            else if (info.disType == MemoryInformation.DIS_TYPE_DATA_WORD_POINTER)
            {
                /*
                info.length = 2;
                info.done = true;
                int word = (info.content&0xff)*256;
                word += (myMemory.memMap.get(i+1).content & 0xff);
                info.disassembledMnemonic = "DW";
                if (myMemory.memMap.get(word).labels.size()>0)
                {
                    info.disassembledOperand = myMemory.memMap.get(word).labels.get(0);
                }
                else
                {
                    // generate label
                    myMemory.memMap.get(word).labels.add("_"+String.format("%04X", word));
                    info.disassembledOperand = myMemory.memMap.get(word).labels.get(0);
                }
                // disMax not done for word yet
                // todo fixme!
                
                */
                
                
                info.length = 0;
                info.disassembledMnemonic = "DW";

                
                boolean inLoop = false;
                String c;
                MemoryInformation orgInfo = info;
                orgInfo.disassembledOperand = "";
                while (info.disType == MemoryInformation.DIS_TYPE_DATA_WORD_POINTER)
                {
                    if (orgInfo.length>=orgInfo.disTypeCollectionMax)
                    {
                        break;
                    }
                    if (i+orgInfo.length>=65536)
                    {
                        break;
                    }
                    info.done = true;

                    int word = (info.content&0xff)*256;
                    word += (myMemory.memMap.get(info.address+1).content & 0xff);

                    c = "";
                    if (inLoop)
                        c += ", ";
                    inLoop = true;

                    if (myMemory.memMap.get(word).labels.size()>0)
                    {
                        c += myMemory.memMap.get(word).labels.get(0);
                    }
                    else
                    {
                        // generate label
                        myMemory.memMap.get(word).labels.add("_"+String.format("%04X", word));
                        c += myMemory.memMap.get(word).labels.get(0);
                    }
                    
                    orgInfo.disassembledOperand += c;
                    orgInfo.length+=2;
                    info = myMemory.memMap.get(i+orgInfo.length);
                    if (info == null) break;
                }
            }
            
            // char type "switches" to DB on 0x80 and 0x00!
            else if (info.disType == MemoryInformation.DIS_TYPE_DATA_CHAR)
            {
                if (  ( (info.content&0xff) < 0x20) /* SPACE */
//                    ||( (info.content&0xff) > 0x6F))
                    ||( (info.content&0xff) > 0x7e))
                {
                    info.disType = MemoryInformation.DIS_TYPE_DATA_BYTE;
                    info.length = 1;
                    continue; // do it again with changed info
                }

                info.length = 0;
                info.disassembledMnemonic = "DB";
                info.disassembledOperand = "\"";
                boolean mustClose = true;
                boolean inLoop = false;
                
                
                MemoryInformation orgInfo = info;
                while (info.disType == MemoryInformation.DIS_TYPE_DATA_CHAR)
                {
                   if (orgInfo.length>=orgInfo.disTypeCollectionMax)
                        break;
                    if (i+orgInfo.length>=65536) 
                    {
                        break; 
                    }
                    info.done = true;
                    char c = (char) (info.content&0xff);
                    inLoop = true;
                    
                    orgInfo.length++;
                    if ((info.content&0xff) == 0x00)
                    {
                        orgInfo.disassembledOperand += "\"";
                        mustClose = false;
                        if (inLoop)
                        {
                            orgInfo.disassembledOperand += ", ";
                        }
                        orgInfo.disassembledOperand += DEF.hexPrefix+"00";
                        break;
                    }
                    else if ((info.content&0xff) == 0x80)
                    {
                        orgInfo.disassembledOperand += "\"";
                        mustClose = false;
                        if (inLoop)
                        {
                            orgInfo.disassembledOperand += ", ";
                        }
                        orgInfo.disassembledOperand += DEF.hexPrefix+String.format("%02X", (info.content&0xff));
                        break;
                    }
                    else
                    {
                        orgInfo.disassembledOperand += c;
                    }

                    info = myMemory.memMap.get(i+orgInfo.length);
                }
                if (mustClose)
                    orgInfo.disassembledOperand += "\"";
                // check if next is a $80
                // then we use it as a string delimiter and add it to string!
                
                if (orgInfo.length<orgInfo.disTypeCollectionMax)
                {
                    if ((myMemory.memMap.get(i+orgInfo.length).content & 0xff) == 0x80)
                    {
                        myMemory.memMap.get(i+orgInfo.length).done = true;
                        orgInfo.disassembledOperand += ", "+DEF.hexPrefix+String.format("%02X", (myMemory.memMap.get(i+orgInfo.length).content&0xff));
                        orgInfo.length++;
                    }
                }
            }
            else
            {
                // do disassemble
                disassemble(i);
                wasDissed = 1;
                /*
                It can happen:
                a) byte 1 is unkown - and oversteppted with "knownHandling"
                b) byte 2 is a known code part and gets disassembled, and sets its operand bytes as "done"
                c) these operand byte(s) is at least byte 3
                ->
                while the "real" disassembling is done, byte 1 is disassembled and has 1 operand byte
                this leaves byte 3 (in the real disassembly) as "done" - and as such is NOT
                disassembled!
                
                Therefor we only set "following" bytes only as done, if not disassembled!
                */
            }
            if (wasDissed != 1)
            for (int off=0; off<myMemory.memMap.get(i).length; off++)
            {
                myMemory.memMap.get(i+off).done = true;
            }
            i+= myMemory.memMap.get(i).length;
        }
        // known memeory locations done
    }
    private void addNewBranches(MemoryInformation info)
    {
        // bra, jump, swi, jsr, (PC-Registerchanegs!)
        Opcodeinfo op=null;
        
        int page = info.page;
        if (page == 0) op = pg1opcodes[info.indexInOpcodeTablePage0];
        if (page == 1) op = pg2opcodes[myMemory.memMap.get(info.address+1).indexInOpcodeTablePage1];
        if (page == 2) op = pg3opcodes[myMemory.memMap.get(info.address+1).indexInOpcodeTablePage2];

        // 0
        if (op.opcode == 14) // jmp DIR
        if (op.opcode == 101) // jmp IND
        if (op.opcode == 126) // jmp EXT
        if (op.opcode == 147) // jsr DIR
        if (op.opcode == 173) // jsr IND
        if (op.opcode == 189) // jsr EXT
        if (op.opcode == 22) // lbra REL
        if (op.opcode == 23) // ljsr REL
        if (op.opcode == 141) // bsr REL
        if (op.opcode == 63) // SWI P1 + P2 * p3
        if ((op.opcode>=32) && (op.opcode<=47)) // P1 & p1
        {
            // BRA LBRA...
        }

    }
    String spaceTo(String l, int to)
    {
        while (l.length()<to) l=l+" ";
        return l;
    }
    String getOutPutString(int startAdress, int length)
    {
        String ret = "";
        
        for (int i=startAdress; i< startAdress+length; )
        {
            
            MemoryInformation info = myMemory.memMap.get(i);

            // labels
            for (String l:info.labels)
                ret+=""+l+":\n";
            
            String line ="";
            line = spaceTo(line, TABOPNAME);
            line += info.disassembledMnemonic;
            line = spaceTo(line, TABOPERAND);
            line += info.disassembledOperand;
            
            // comments
            for (String l:info.comments)
            {
                line = spaceTo(line, TABCOMM);
                line+=";"+l;
                ret += line+"\n";
                line ="";
            }
            if (line.length()!=0)
                ret += line+"\n";
            i+= myMemory.memMap.get(i).length;
        }
        return ret;
    }
    

    public boolean tryLoadList(String name)
    {
        if (name == null) return false;
        int li = name.lastIndexOf(".");
        if (li<0) return false;
        name = name.substring(0,li)+".lst";
        File f = new File(name);
        if (!f.exists()) return false;
        readLSTFile(name, false);
        return true;
    }
    public boolean tryLoadCNT(String name)
    {
        if (name == null) return false;
        int li = name.lastIndexOf(".");
        if (li<0) return false;
        
        // first look in current dir
        name = name.substring(0,li)+".cnt";
        File f = new File(name);
        if (f.exists()) 
        {
            readCNTFile( name);
            return true;
        }
        // than try cnt dir
        String nameOnly = name;
        if (nameOnly.contains(File.separator))
        {
            nameOnly = nameOnly.substring(nameOnly.lastIndexOf(File.separator)+1);
        }
        name = "cnt"+File.separator+nameOnly;
        f = new File(name);
        if (f.exists()) 
        {
            readCNTFile( name);
            return true;
        }
        
        
        return false;
    }
    public boolean readLSTFile(String name, boolean allowBios)
    {
        try 
        {
            BufferedReader br = new BufferedReader(new FileReader(name));
            try 
            {
                StringBuilder sb = new StringBuilder();
                String line = br.readLine();
                int lastAddress = 0;
                int count = 0;
                boolean islwasm = checkLWAsm(line);

                while (true) 
                {
                    if (!islwasm)
                        lastAddress = doOneLSTLine(line, lastAddress, allowBios);
                    else
                        lastAddress = doOneLWASMLSTLine(line, lastAddress, allowBios);
                    line = br.readLine();
                    if (line == null) break;
                    count++;
                }
                return true;
            } 
            catch (Throwable ex)
            {
                log.addLog(ex, WARN);
            }
            finally 
            {
                br.close();
            }        
        } 
        catch (Throwable ex)
        {
            // ignore
        }
        return false;
    }
    
    static String[] removeEmpty(String[] s)
    {
        ArrayList<String> as = new ArrayList<String>();
        for (String ss: s)
            if (ss.length()>0) as.add(ss);
        return as.toArray(new String[0]);
    }
    
    private int doOneLSTLine(String line, int lastAddress, boolean allowBios)
    {
        
        
        // test label
        // that is: text : $address decimal adress
        String[] s = removeEmpty(line.split(" "));
        int adr = lastAddress;
        String[] lr = removeEmpty(line.split("\\|"));
        String[] r = null;
        String[] l = null;
        if (lr.length>0) l  = removeEmpty(lr[0].split(" "));
        if (lr.length>1) r  = removeEmpty(lr[1].split(" "));

        if (((r!=null) && (r.length>0)) && (!((r[0].startsWith(";")) || (r[0].startsWith("*")))))
        {

            
            // the right starts with a label (of kind)
            if (lr[1].startsWith(r[0]))
            {
                String label;
                if (r[0].endsWith(":")) label = r[0].substring(0,r[0].length()-1); else label = r[0];

                String address = "$"+s[0]; 
                int adress = toNumber(address);

                if (!allowBios)
                    if (adress >= 0xd000) return adress; // no stuff from BIOS or IO
                MemoryInformation info = myMemory.memMap.get(adress);
                if (info == null)
                {
                    info = myMemory.buildMemInfo(adress);
                }
                if (!info.hasLabel(label))
                    info.labels.add(label);
                return adress;
            }
            
            // label in the same line as instruction
            if (r[0].endsWith(":"))
            {
                String address = "$"+s[0]; 
                String label = r[0].substring(0, r[0].length()-1);
                int adress = toNumber(address);

                if (!allowBios)
                    if (adress >= 0xd000) return adress; // no stuff from BIOS or IO
                MemoryInformation info = myMemory.memMap.get(adress);
                if (info == null)
                {
                    info = myMemory.buildMemInfo(adress);
                }
                if (!info.hasLabel(label))
                    info.labels.add(label);
                return adress;
            }
        }
        

        
        
        if (s.length==0) return adr;
        if (s.length == 4)
        {
            if (s[1].equals(":"))
            {
                // fair enough - I take it, it is a label :)
                // label
                String address = s[2]; 
                String label = s[0];
                int adress = toNumber("$"+address);
                if (adress < 0) return lastAddress;
                if (!allowBios)
                    if (adress >= 0xd000) return adress; // no stuff from BIOS or IO
                MemoryInformation info = myMemory.memMap.get(adress);
                if (info == null)
                {
                    info = myMemory.buildMemInfo(adress);
                }
                if (!info.hasLabel(label))
                    info.labels.add(label);
                return adress;
            }
        }
        if (s[s.length-1].endsWith(":"))
        {
            {
                // fair enough - I take it, it is a label :)
                // label
                String address = s[0]; 
                String label = s[s.length-1].substring(0,s[s.length-1].length()-1);
                int adress = toNumber("$"+address);
                if (adress < 0) return lastAddress;
                if (!allowBios)
                    if (adress >= 0xd000) return adress; // no stuff from BIOS or IO
                MemoryInformation info = myMemory.memMap.get(adress);
                if (info == null)
                {
                    info = myMemory.buildMemInfo(adress);
                }
                if (!info.hasLabel(label))
                    info.labels.add(label);
                return adress;
            }
        }
        
        // test Immediate values
        if (s.length == 4)
        {
            // not done
            
        }
        // try code
        //if (s.length == 4)
        {
            // not done
            if (line.length()<8)
            {
                return lastAddress;
            }
            if (line.trim().startsWith("*")) // comment line, completely!
            {
                if (lastAddress == -1) return lastAddress;
                MemoryInformation info = myMemory.memMap.get(lastAddress);
                info.comments.add(line.trim());
                return lastAddress;
            }
        
        
            if (line.substring(4,7).equals(" : "))
            {
                int address = toNumber("$"+line.substring(0,4));
                MemoryInformation info = myMemory.memMap.get(address);
                adr = address;
                if (info == null)
                {
                    info = myMemory.buildMemInfo(address);
                }
                if (address >=0)
                {
                    // fair enough, we assume a valid line
                    // search for comment
                    int c = line.indexOf(";");
                    if (c>0)
                    {
                        String comment = line.substring(c);
                        info.comments.add(comment);
                    }
                    else
                    {
                        c = line.length();
                    }
                    // line without comments now!
                    line = line.substring(0, c);
                    
                    // look for data
                    int reduce = 5;
                    c = line.toUpperCase().indexOf(" FCC ");
                    if (c<0)
                    {
                        c = line.toUpperCase().indexOf(" DB ");
                        if (c>=0)
                            if (line.substring(c).split("\"").length != 2) c = -1;
                        reduce = 4;
                    }
                    
                    if (c>=0)
                    {
                        line = line.substring(c+reduce);
                        String[] spl = removeEmpty(line.trim().split("\""));
                        if (spl.length==0) return address;
                        int cc = 0;
                        for (int i=address;i<address+spl[0].length();i++)
                        {
                            info = myMemory.memMap.get(i);
                            if (info == null)
                            {
                                info = myMemory.buildMemInfo(address);
                            }
                            info.disType = MemoryInformation.DIS_TYPE_DATA_CHAR;
                            info.typeWasSet = true;
                            info.length=spl[0].length()-(cc);
                            info.disTypeCollectionMax=spl[0].length()-(cc++);
//                            info.disassembledMnemonic = "DB";
//                            info.done = true;
                        }
                        return address;
                    }
                    
                    reduce = 5;
                    c = line.toUpperCase().indexOf(" FCB ");
                    if (c<0)
                    {
                        reduce = 4;
                        c = line.toUpperCase().indexOf(" DB ");
                    }
                    if (c>=0)
                    {
                        // note! LST does not
                        // print out ALL data of one line
                        // it stops after a certain character width of the source line!
                        // the calculation with "," ist thus not allways correct!
                        line = line.substring(c+reduce);
                        String[] spl = removeEmpty(line.split(","));
                        int cc = 0;
                        for (int i=address;i<address+spl.length;i++)
                        {
                            info = myMemory.memMap.get(i);
                            if (info == null)
                            {
                                info = myMemory.buildMemInfo(address);
                            }
                            info.disType = MemoryInformation.DIS_TYPE_DATA_BYTE;
                            info.typeWasSet = true;
                            info.length=spl.length-(cc++);
                            info.disassembledMnemonic = "DB";
//                            info.done = true;
                        }
                        return address;
                    }
                    reduce = 5;
                    c = line.toUpperCase().indexOf(" FDB ");
                    if (c<0)
                    {
                        reduce = 4;
                        c = line.toUpperCase().indexOf(" DW ");
                    }
                    if (c>=0)
                    {
                        line = line.substring(c+reduce);
                        String[] spl =removeEmpty(line.split(","));
                        for (int i=address;i<address+spl.length*2;i++)
                        {
                            info = myMemory.memMap.get(i);
                            if (info == null)
                            {
                                info = myMemory.buildMemInfo(address);
                            }
                            info.disType = MemoryInformation.DIS_TYPE_DATA_WORD;
                            info.typeWasSet = true;
                            info.length = 2;
                            info.disassembledMnemonic = "DW";
//                            info.done = true;
                        }
                        return address;
                    }
                    // is code?
                    String[] spl = removeEmpty(line.split(" "));

                    if (spl.length >5)
                    {
                        if (spl[3].equals("["))
                        {
                            if (spl[3].indexOf("]")>=0)
                            {
                                // assuming code, since we found cycle information
                                info = myMemory.memMap.get(address);
                                if (info == null)
                                {
                                    info = myMemory.buildMemInfo(address);
                                }
                                info.disType = MemoryInformation.DIS_TYPE_DATA_INSTRUCTION_1_LENGTH;
                                info.typeWasSet = true;
                            }
                        }
                        return address;
                    }
                }
            }
        }
        return adr;
        
    }
   
    // tell which range what DP value
    // RANGE 1000-2000 DEC_DATA [3]
    // RANGE 1000-2000 DB_DATA [3]
    // RANGE 1000-2000 DW_DATA [1]
    // RANGE 1000-2000 DWP_DATA [1]
    // RANGE 1000-2000 CHAR_DATA [20]
    // RANGE 1000-2000 CODE
    // RANGE 1000-2000 DP D0
    private void doRangeLine(int rangeStart, int rangeEnd, String type, int maxSame)
    {
        for (int i=rangeStart; i<rangeEnd; i++)
        {
            if (type.trim().toUpperCase().equals("DEC_DATA"))
            {
                if (maxSame==0) maxSame = 8;
                MemoryInformation info = myMemory.buildMemInfo(i);
                info.disType = MemoryInformation.DIS_TYPE_DATA_DECIMAL;
                info.typeWasSet = true;
                info.disTypeCollectionMax = maxSame;
            }
            if (type.trim().toUpperCase().equals("DB_DATA"))
            {
                if (maxSame==0) maxSame = 8;
                MemoryInformation info = myMemory.buildMemInfo(i);
                info.disType = MemoryInformation.DIS_TYPE_DATA_BYTE;
                info.typeWasSet = true;
                info.disTypeCollectionMax = maxSame;
            }
            if (type.trim().toUpperCase().equals("BIN_DATA"))
            {
                if (maxSame==0) maxSame = 8;
                MemoryInformation info = myMemory.buildMemInfo(i);
                info.disType = MemoryInformation.DIS_TYPE_DATA_BINARY;
                info.typeWasSet = true;
                info.disTypeCollectionMax = maxSame;
            }
            if (type.trim().toUpperCase().equals("DW_DATA"))
            {
                if (maxSame==0) maxSame = 4;
                MemoryInformation info = myMemory.buildMemInfo(i);
                info.disType = MemoryInformation.DIS_TYPE_DATA_WORD;
                info.typeWasSet = true;
                info.disTypeCollectionMax = maxSame;
            }
            if (type.trim().toUpperCase().equals("DWP_DATA"))
            {
                if (maxSame==0) maxSame = 1;
                MemoryInformation info = myMemory.buildMemInfo(i);
                info.disType = MemoryInformation.DIS_TYPE_DATA_WORD_POINTER;
                info.typeWasSet = true;
                info.disTypeCollectionMax = maxSame;
            }
            if (type.trim().toUpperCase().equals("DW_POINTER")) // backwards compatability
            {
                if (maxSame==0) maxSame = 1;
                MemoryInformation info = myMemory.buildMemInfo(i);
                info.disType = MemoryInformation.DIS_TYPE_DATA_WORD_POINTER;
                info.typeWasSet = true;
                info.disTypeCollectionMax = maxSame;
            }
            if (type.trim().toUpperCase().equals("CHAR_DATA"))
            {
                if (maxSame==0) maxSame = 20;
                MemoryInformation info = myMemory.buildMemInfo(i);
                info.disType = MemoryInformation.DIS_TYPE_DATA_CHAR;
                info.typeWasSet = true;
                info.disTypeCollectionMax = maxSame;
            }
            if (type.trim().toUpperCase().equals("CODE"))
            {
                MemoryInformation info = myMemory.buildMemInfo(i);
                info.disType = MemoryInformation.DIS_TYPE_UNKOWN; // will be disassaembled!
                info.disType = MemoryInformation.DIS_TYPE_CODE; // will be disassaembled!
                info.typeWasSet = true;
            }
            if (type.trim().toUpperCase().equals("DP"))
            {
                MemoryInformation info = myMemory.buildMemInfo(i);
                info.directPageAddress = maxSame; // oh well, just using the parameter
            }
        }
    }

    
    // EQU 20 value - konstant
    // DIRECT_LABEL D0 $00 timer_low ...
    // LABEL $c100 lab - label to pc
    // COMMENT_LABEL $c100 comment
    // COMMENT $c100 "bla" - end of line comment
    // COMMENT_LINE $c100 "bla" - line comment BEFOR adr
    // VTEXT #adresse1# #adresse2# - from adr1 to adr2 is vectrex type text (same as range RANGE 1000-2000 CHAR_DATA)
    // DATA_BYTE #adresse1# #adresse2#
    // DATA_DECIMAL #adresse1# #adresse2#
    // DATA_WORD #adresse1# #adresse2#
    int currentCNTScanBank = 0;
    private void doOneCNTLine(String line)
    {
        line = line.trim();
        
        // if found than a stack breakpoint is added!
        if (line.toUpperCase().startsWith("HIGHEST_USED_RAM"))
        {
            String s[] = line.split(" ");
            s = removeEmpty(s);
            if (s.length>1)
            {
                String address = s[1]; 
                myMemory.highestUserRAM = toNumber(address);
            }
        }
                
        
        if (line.toUpperCase().startsWith("C_INFO_BLOCK"))
        {
            // C_INFO_BLOCK $053C "/Users/chrissalo/NetBeansProjects/Vide/projects/LodeRunner/source/LRUNNER.c "FN_END 154 " VIA_port_a = y; "

            MemCInfoBlock infBlock = new MemCInfoBlock();
            
            line = line.substring("C_INFO_BLOCK".length()).trim();
            String s[] = line.split(" ");
            String address = s[0]; 
            int adress = toNumber(address);
            if (adress < 0) return;
            if (adress > 65536) return;
            infBlock.address = adress;
            String filename = line.substring(line.indexOf("\"")+1, line.indexOf("\"FN_END"));
            String subLine = line.substring(line.indexOf("\"FN_END")+"\"FN_END".length() ).trim();
            s = subLine.split(" ");
            s = removeEmpty(s);
            String linenoS = s[0]; 
            int lineNo = toNumber(linenoS);
            subLine = subLine.substring(linenoS.length()+1).trim();
            String cline = subLine.substring(subLine.indexOf("\"")+1, subLine.lastIndexOf("\""));
            
            boolean hasBreakPoint = line.contains("BKPOINT=1");
            
            infBlock.address = adress;
            infBlock.lineNo = lineNo;
            infBlock.file = filename;
            infBlock.lineString = cline;
            
            MemoryInformation info = myMemory.memMap.get(adress);
            if (info == null)
            {
                info = myMemory.buildMemInfo(adress);
            }
            info.cInfo = infBlock;
            if (hasBreakPoint)
            {
                info.comments.add("; hey dissi \"break\"");
            }
            return;
        }        
        
        if (line.toUpperCase().startsWith("BANK"))
        {
            currentCNTScanBank = 0;
            line = line.substring(5).trim();
            int newbank = toNumber(line);
            currentCNTScanBank = newbank;
            myMemory.setBank(currentCNTScanBank, true);
            return;
        }        
        if (line.toUpperCase().startsWith("START_BANK"))
        {
            currentCNTScanBank = 0;
            line = line.substring(10).trim();
            int newbank = toNumber(line);
            currentCNTScanBank = newbank;
            myMemory.setBank(currentCNTScanBank, true);
            return;
        }        
        if (line.toUpperCase().startsWith("END_BANK"))
        {
            currentCNTScanBank = 0;
            myMemory.setBank(currentCNTScanBank, true);
            return;
        }        

        
        if (line.toUpperCase().startsWith("RANGE"))
        {
            line = line.substring(5).trim().replaceAll("-", " ");
            line = de.malban.util.UtilityString.replace(line, "  ", " ");
            String s[] = line.split(" ");
            if (s.length<3) return;
            int rangeStart = toNumber(s[0]);
            int rangeEnd = toNumber(s[1]);
            if (rangeEnd==0) return;
            if (rangeEnd<rangeStart) return;
            String type = s[2];
            int maxSame = 0;
            if (s.length>3)
                maxSame = toNumber(s[3]);
            doRangeLine(rangeStart, rangeEnd, type, maxSame);
        }        
        
        // EQU #adresse# "text"
        else if (line.toUpperCase().startsWith("EQU"))
        {
            // label
            line = line.substring(3).trim();
            line = de.malban.util.UtilityString.replace(line, "  ", " ");
            String s[] = line.split(" ");
            String address = s[0]; 
            String label = line.substring(address.length()).trim();
            int adress = toNumber(address);
            if (adress < 0) return;
            if (adress > 65536) return;
            MemoryInformation info = myMemory.memMap.get(adress);
            if (info == null)
            {
                info = myMemory.buildMemInfo(adress);
            }
            
            if (!info.hasImmediateLabel(label))
                info.immediateLabels.add(label);
            // for now - also a label!
            if (!info.hasLabel(label))
                info.labels.add(label);
        }        
        
        // DIRECT_LABEL C8 $00 timer_low ...
        else if (line.toUpperCase().startsWith("DIRECT_LABEL"))
        {
            // label
            line = line.substring(12).trim();
            line = de.malban.util.UtilityString.replace(line, "  ", " ");
            String s[] = line.split(" ");
            if (s.length<3) return;
            String label = s[2];
            
            int dp = toNumber(s[0]);
            int adress = toNumber(s[1]);
            if (adress < 0) return;
            if (adress > 65536) return;
            if (dp < 0) return;
            if (dp > 65536) return;
            HashMap<Integer, String> map = myMemory.directLabels.get(dp);
            if (map == null)
            {
                map = new HashMap<Integer, String>();
                myMemory.directLabels.put(dp, map);
                
            } 
            map.put(adress, label);
        }        
        // LABEL #adresse# "text"
        else if (line.toUpperCase().startsWith("LABEL"))
        {
            // label
            line = line.substring(5).trim();
            line = de.malban.util.UtilityString.replace(line, "  ", " ");
            String s[] = line.split(" ");
            String address = s[0]; 
            String label = line.substring(address.length()).trim();
            int adress = toNumber(address);
            if (adress < 0) return;
            if (adress > 65536) return;
            MemoryInformation info = myMemory.memMap.get(adress);
            if (info == null)
            {
                info = myMemory.buildMemInfo(adress);
            }
            
            if (!info.hasLabel(label))
                info.labels.add(label);
        }
        
        // FORCE_SYMBOL #adresse# "text"
        else if (line.toUpperCase().startsWith("FORCE_SYMBOL"))
        {
            // FORCE_SYMBOL
            line = line.substring("FORCE_SYMBOL".length()).trim();
            line = de.malban.util.UtilityString.replace(line, "  ", " ");
            String s[] = line.split(" ");
            String address = s[0]; 
            String symbol = line.substring(address.length()).trim();
            int adress = toNumber(address);
            if (adress < 0) return;
            if (adress > 65536) return;
            MemoryInformation info = myMemory.memMap.get(adress);
            if (info == null)
            {
                info = myMemory.buildMemInfo(adress);
            }
            info.forcedSymbol = symbol;

        }
        // FORCE_NO_SYMBOL #adresse# 
        else if (line.toUpperCase().startsWith("FORCE_NO_SYMBOL"))
        {
            // FORCE_NO_SYMBOL
            line = line.substring("FORCE_NO_SYMBOL".length()).trim();
            line = de.malban.util.UtilityString.replace(line, "  ", " ");
            String s[] = line.split(" ");
            String address = s[0]; 
            int adress = toNumber(address);
            if (adress < 0) return;
            if (adress > 65536) return;
            MemoryInformation info = myMemory.memMap.get(adress);
            if (info == null)
            {
                info = myMemory.buildMemInfo(adress);
            }
            info.forcedSymbol = "";
        }

        // COMMENT_LABEL #adresse# "text"
        else if (line.toUpperCase().startsWith("COMMENT_LABEL"))
        {
            // COMMENT
            line = line.substring(13).trim();
            String s[] = line.split(" ");
            String address = s[0]; 
            String comment = line.substring(address.length()).trim();
            int adress = toNumber(address);
            if (adress < 0) return;
            if (adress >= 65536) return;
            
            MemoryInformation info = myMemory.memMap.get(adress);
            if (info == null)
            {
                info = myMemory.buildMemInfo(adress);
            }
            if (!info.hasComment(comment))
                info.comments.add(comment);
        }       
        // COMMENT #adresse# "text"
        else if (line.toUpperCase().startsWith("COMMENT_LINE"))
        {
            // COMMENT
            line = line.substring(12).trim();
            String s[] = line.split(" ");
            String address = s[0]; 
            String comment = line.substring(address.length()).trim();
            int adress = toNumber(address);
            if (adress < 0) return;
            if (adress >= 65536) return;
            
            MemoryInformation info = myMemory.memMap.get(adress);
            if (info == null)
            {
                info = myMemory.buildMemInfo(adress);
            }
            if (!info.hasComment(comment))
                info.comments.add(comment);
        }        // COMMENT #adresse# "text"
        else if (line.toUpperCase().startsWith("COMMENT"))
        {
            // COMMENT
            line = line.substring(7).trim();
            String s[] = line.split(" ");
            String address = s[0]; 
            String comment = line.substring(address.length()).trim();
            int adress = toNumber(address);
            if (adress < 0) return;
            if (adress >= 65536) return;
            
            MemoryInformation info = myMemory.memMap.get(adress);
            if (info == null)
            {
                info = myMemory.buildMemInfo(adress);
            }
            if (!info.hasComment(comment))
                info.comments.add(comment);
        }
        
        // VTEXT #adresse1# #adresse2#
        else if (line.toUpperCase().startsWith("VTEXT"))
        {
            int max = 30;
            line = line.substring(5).trim();
            String s[] = line.split(" ");
            String address1 = s[0];
            String address2; 
            if (s.length==1) 
                address2 = address1;
            else  
                address2 = s[1]; 
            
            if (s.length == 3)
            {
                max = toNumber(s[2]); 
            }
            
            int adress1 = toNumber(address1);
            int adress2 = toNumber(address2);
            if (adress1 < 0) return;
            if (adress1 < 65536) return;
            if (adress2 < 0) return;
            if (adress2 < 65536) return;
            
            for (int a = adress1; a<= adress2; a++)
            {
                MemoryInformation info = myMemory.memMap.get(a);
                if (info == null)
                {
                    info = myMemory.buildMemInfo(a);
                }
                info.disType = MemoryInformation.DIS_TYPE_DATA_CHAR;
                info.typeWasSet = true;
                info.length = 1;
                info.disTypeCollectionMax = max;
            }
        }

        // DATA_DECIMAL #adresse1# #adresse2#
        else if (line.toUpperCase().startsWith("DATA_DECIMAL"))
        {
            int max = 4;
            line = line.substring(5).trim();
            line = de.malban.util.UtilityString.replace(line, "  ", " ");
            String s[] = line.split(" ");
            String address1 = s[0];
            String address2; 
            if (s.length==1) 
                address2 = address1;
            else  
                address2 = s[1]; 
            if (s.length == 3)
            {
                max = toNumber(s[2]); 
            }
            
            int adress1 = toNumber(address1);
            int adress2 = toNumber(address2);
            if (adress1 < 0) return;
            if (adress1 < 65536) return;
            if (adress2 < 0) return;
            if (adress2 < 65536) return;
            
            for (int a = adress1; a<= adress2; a++)
            {
                MemoryInformation info = myMemory.memMap.get(a);
                if (info == null)
                {
                    info = myMemory.buildMemInfo(a);
                }
                info.disType = MemoryInformation.DIS_TYPE_DATA_DECIMAL;
                info.typeWasSet = true;
                info.disTypeCollectionMax = max;
                info.length = 1;
            }
        }



        // DATA_BYTE #adresse1# #adresse2#
        else if (line.toUpperCase().startsWith("DATA_BYTE"))
        {
            int max = 4;
            line = line.substring(5).trim();
            line = de.malban.util.UtilityString.replace(line, "  ", " ");
            String s[] = line.split(" ");
            String address1 = s[0];
            String address2; 
            if (s.length==1) 
                address2 = address1;
            else  
                address2 = s[1]; 
            if (s.length == 3)
            {
                max = toNumber(s[2]); 
            }
            
            int adress1 = toNumber(address1);
            int adress2 = toNumber(address2);
            if (adress1 < 0) return;
            if (adress1 < 65536) return;
            if (adress2 < 0) return;
            if (adress2 < 65536) return;
            
            for (int a = adress1; a<= adress2; a++)
            {
                MemoryInformation info = myMemory.memMap.get(a);
                if (info == null)
                {
                    info = myMemory.buildMemInfo(a);
                }
                info.disType = MemoryInformation.DIS_TYPE_DATA_BYTE;
                info.typeWasSet = true;
                info.disTypeCollectionMax = max;
                info.length = 1;
            }
        }
        else if (line.toUpperCase().startsWith("DATA_BINARY"))
        {
            
            int max = 4;
            line = line.substring(5).trim();
            line = de.malban.util.UtilityString.replace(line, "  ", " ");
            String s[] = line.split(" ");
            String address1 = s[0];
            String address2; 
            if (s.length==1) 
                address2 = address1;
            else  
                address2 = s[1]; 
            if (s.length == 3)
            {
                max = toNumber(s[2]); 
            }
            
            int adress1 = toNumber(address1);
            int adress2 = toNumber(address2);
            if (adress1 < 0) return;
            if (adress1 < 65536) return;
            if (adress2 < 0) return;
            if (adress2 < 65536) return;
            
            for (int a = adress1; a<= adress2; a++)
            {
                MemoryInformation info = myMemory.memMap.get(a);
                if (info == null)
                {
                    info = myMemory.buildMemInfo(a);
                }
                info.disType = MemoryInformation.DIS_TYPE_DATA_BINARY;
                info.typeWasSet = true;
                info.disTypeCollectionMax = max;
                info.length = 1;
            }
        }
        // DATA_WORD #adresse1# #adresse2#
        else if (line.toUpperCase().startsWith("DATA_WORD"))
        {
            int max = 1;
            line = line.substring(5).trim();
            line = de.malban.util.UtilityString.replace(line, "  ", " ");
            String s[] = line.split(" ");
            String address1 = s[0];
            String address2; 
            if (s.length==1) 
                address2 = address1;
            else  
                address2 = s[1]; 
            if (s.length == 3)
            {
                max = toNumber(s[2]); 
            }
            
            int adress1 = toNumber(address1);
            int adress2 = toNumber(address2);
            if (adress1 < 0) return;
            if (adress1 < 65536) return;
            if (adress2 < 0) return;
            if (adress2 < 65536) return;
            
            for (int a = adress1; a<= adress2; a++)
            {
                MemoryInformation info = myMemory.memMap.get(a);
                if (info == null)
                {
                    info = myMemory.buildMemInfo(a);
                }
                info.disType = MemoryInformation.DIS_TYPE_DATA_WORD;
                info.typeWasSet = true;
                info.disTypeCollectionMax = max;
                info.length = 1; // hm todo fixme
            }
        }
    }

    public void supplyBIOSLabels()
    {
//    static HashMap<Integer, String> BIOSLABELS;
//    static HashMap<Integer, String> BIOSLABELS2;
//    static HashMap<Integer, String> BIOSFUNCTIONS;
        
        for (Map.Entry<Integer, String> entry : BIOSLABELS.entrySet()) 
        {
            Integer adress = entry.getKey();
            String label = entry.getValue();

            MemoryInformation info = myMemory.memMap.get(adress);
            if (info == null)
            {
                info = myMemory.buildMemInfo(adress);
            }
            if (!info.hasLabel(label))
                info.labels.add(label);

        }        
        for (Map.Entry<Integer, String> entry : BIOSLABELS2.entrySet()) 
        {
            Integer adress = entry.getKey();
            String label = entry.getValue();

            MemoryInformation info = myMemory.memMap.get(adress);
            if (info == null)
            {
                info = myMemory.buildMemInfo(adress);
            }
            if (!info.hasLabel(label))
                info.labels.add(label);

        }        
        for (Map.Entry<Integer, String> entry : BIOSFUNCTIONS.entrySet()) 
        {
            Integer adress = entry.getKey();
            String label = entry.getValue();

            MemoryInformation info = myMemory.memMap.get(adress);
            if (info == null)
            {
                info = myMemory.buildMemInfo(adress);
            }
            if (!info.hasLabel(label))
                info.labels.add(label);

        }        
    }
    boolean checkLWAsm(String firstLine)
    {
        if (firstLine.length()<23) return false;
        return (firstLine.substring(22,23).equals("("));
    }

    private int doOneLWASMLSTLine(String _line, int lastAddress, boolean allowBios)
    {
        int adress =lastAddress;
        if (_line.length()>5)
        {
            String adr = _line.substring(0,4);
            adress = toNumber("$"+adr);
            if (adress == 0) return lastAddress;
        }
        if (!allowBios) if (adress >= 0xd000) return adress; // no stuff from BIOS or IO
        MemoryInformation info = myMemory.memMap.get(adress);
        if (info == null)
        {
            info = myMemory.buildMemInfo(adress);
        }
        

        String line = "";
        if (_line.length()>65)
            line=_line.substring(64);
        
        // test label
        // that is: text : $address decimal adress
        String[] s = removeEmpty(line.split(" "));
        int adr = lastAddress;
        String[] r = removeEmpty(line.split(" "));

        if (((r!=null) && (r.length>0)) && (!((r[0].startsWith(";")) || (r[0].startsWith("*")))))
        {
            // the right starts with a label (of kind)
            if (line.startsWith(r[0]))
            {
                String label;
                if (r[0].endsWith(":")) label = r[0].substring(0,r[0].length()-1); else label = r[0];

                if (!info.hasLabel(label))
                    info.labels.add(label);
                return adress;
            }
            
            // label in the same line as instruction
            if (r[0].endsWith(":"))
            {
                String address = "$"+s[0]; 
                String label = r[0].substring(0, r[0].length()-1);

                if (!info.hasLabel(label))
                    info.labels.add(label);
                return adress;
            }
        }
        

        
        
        if (s.length==0) return adr;
        if (s.length == 4)
        {
            if (s[1].equals(":"))
            {
                // fair enough - I take it, it is a label :)
                // label
                String label = s[0];
                if (!info.hasLabel(label))
                    info.labels.add(label);
                return adress;
            }
        }
        if (s[s.length-1].endsWith(":"))
        {
            {
                // fair enough - I take it, it is a label :)
                // label
                String label = s[s.length-1].substring(0,s[s.length-1].length()-1);
                if (!info.hasLabel(label))
                    info.labels.add(label);
                return adress;
            }
        }
        
        // test Immediate values
        if (s.length == 4)
        {
            // not done
            
        }
        // try code
        //if (s.length == 4)
        {
            // not done
            if (line.length()<8)
            {
                return lastAddress;
            }
            if (line.trim().startsWith("*")) // comment line, completely!
            {
                if (lastAddress == -1) return lastAddress;
                info.comments.add(line.trim());
                return lastAddress;
            }
        
        
            if (line.substring(4,7).equals(" : "))
            {
                adr = adress;
                if (adress >=0)
                {
                    // fair enough, we assume a valid line
                    // search for comment
                    int c = line.indexOf(";");
                    if (c>0)
                    {
                        String comment = line.substring(c);
                        info.comments.add(comment);
                    }
                    else
                    {
                        c = line.length();
                    }
                    // line without comments now!
                    line = line.substring(0, c);
                    
                    // look for data
                    int reduce = 5;
                    c = line.toUpperCase().indexOf(" FCC ");
                    if (c<0)
                    {
                        c = line.toUpperCase().indexOf(" DB ");
                        if (c>=0)
                            if (line.substring(c).split("\"").length != 2) c = -1;
                        reduce = 4;
                    }
                    
                    if (c>=0)
                    {
                        line = line.substring(c+reduce);
                        String[] spl = removeEmpty(line.trim().split("\""));
                        if (spl.length==0) return adress;
                        int cc = 0;
                        for (int i=adress;i<adress+spl[0].length();i++)
                        {
                            info = myMemory.memMap.get(i);
                            if (info == null)
                            {
                                info = myMemory.buildMemInfo(adress);
                            }
                            info.disType = MemoryInformation.DIS_TYPE_DATA_CHAR;
                            info.typeWasSet = true;
                            info.length=spl[0].length()-(cc);
                            info.disTypeCollectionMax=spl[0].length()-(cc++);
//                            info.disassembledMnemonic = "DB";
//                            info.done = true;
                        }
                        return adress;
                    }
                    
                    reduce = 5;
                    c = line.toUpperCase().indexOf(" FCB ");
                    if (c<0)
                    {
                        reduce = 4;
                        c = line.toUpperCase().indexOf(" DB ");
                    }
                    if (c>=0)
                    {
                        // note! LST does not
                        // print out ALL data of one line
                        // it stops after a certain character width of the source line!
                        // the calculation with "," ist thus not allways correct!
                        line = line.substring(c+reduce);
                        String[] spl = removeEmpty(line.split(","));
                        int cc = 0;
                        for (int i=adress;i<adress+spl.length;i++)
                        {
                            info = myMemory.memMap.get(i);
                            if (info == null)
                            {
                                info = myMemory.buildMemInfo(adress);
                            }
                            info.disType = MemoryInformation.DIS_TYPE_DATA_BYTE;
                            info.typeWasSet = true;
                            info.length=spl.length-(cc++);
                            info.disassembledMnemonic = "DB";
//                            info.done = true;
                        }
                        return adress;
                    }
                    reduce = 5;
                    c = line.toUpperCase().indexOf(" FDB ");
                    if (c<0)
                    {
                        reduce = 4;
                        c = line.toUpperCase().indexOf(" DW ");
                    }
                    if (c>=0)
                    {
                        line = line.substring(c+reduce);
                        String[] spl =removeEmpty(line.split(","));
                        for (int i=adress;i<adress+spl.length*2;i++)
                        {
                            info = myMemory.memMap.get(i);
                            if (info == null)
                            {
                                info = myMemory.buildMemInfo(adress);
                            }
                            info.disType = MemoryInformation.DIS_TYPE_DATA_WORD;
                            info.typeWasSet = true;
                            info.length = 2;
                            info.disassembledMnemonic = "DW";
//                            info.done = true;
                        }
                        return adress;
                    }
                    // is code?
                    String[] spl = removeEmpty(line.split(" "));

                    if (spl.length >5)
                    {
                        if (spl[3].equals("["))
                        {
                            if (spl[3].indexOf("]")>=0)
                            {
                                // assuming code, since we found cycle information
                                info = myMemory.memMap.get(adress);
                                if (info == null)
                                {
                                    info = myMemory.buildMemInfo(adress);
                                }
                                info.disType = MemoryInformation.DIS_TYPE_DATA_INSTRUCTION_1_LENGTH;
                                info.typeWasSet = true;
                            }
                        }
                        return adress;
                    }
                }
            }
        }
        return adr;
        
    }
}
