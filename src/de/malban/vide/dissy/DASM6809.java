
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

import de.malban.config.Configuration;
import de.malban.gui.panels.LogPanel;
import static de.malban.gui.panels.LogPanel.INFO;
import static de.malban.gui.panels.LogPanel.WARN;
import de.malban.vide.VideConfig;
import static de.malban.vide.dissy.MemoryInformation.MEM_TYPE_BAD;
import static de.malban.vide.dissy.MemoryInformation.MEM_TYPE_IO;
import static de.malban.vide.dissy.MemoryInformation.MEM_TYPE_RAM;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;

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

    int currentMemPointer = 0;              // after the current operand (one after getByte())
    int currentInstructionStartAddress =0;  /* current program (of last getByte()) */
    int currentPC =0; // begin of the currently disassembled instruction
    boolean endOfFile = false;
    boolean createLabels = false;
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

    public void setCreateLabels(boolean c)
    {
        createLabels = c;
    }
    /* substitute label for address if found */
    String checklabs(int address)
    {
        return checklabs(address, -1);
    }
    String checklabs(int address, int mode)
    {
         return checklabs(address, mode, -1);
    }
    String checklabs(int address, int mode, int dp)
    {
         return checklabs(address, mode, -1, -1);
    }
    String checklabs(int address, int mode, int dp, int numOperands)
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
                            labtemp+=info2.labels.get(0);
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
                labtemp+=labels.get(0);
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
                       labtemp += "-"+DEF.hexPrefix+String.format("%02X", -address & 0xFF);
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
                str+=checklabs((currentMemPointer+((rel<128) ? rel : rel-256)), mode,-1,1);;
                break;
            case LREL:           /* 16-bit long relative */
                rel=(operandarray[0]<<8)+operandarray[1];
                str+=checklabs(currentMemPointer+((rel<32768) ? rel : rel-65536),mode,2);
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
                         out2 = checklabs(offset) +","+ regs[reg];
                    else if(offset>=0)
                         out2 = DEF.hexPrefix+String.format("%02X", offset)+","+regs[reg];
                    else
                         out2 = "-"+DEF.hexPrefix+String.format("%02X", -offset)+","+regs[reg];
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
                        out2 = checklabs(offset);
                        memInfo.cycles-=2;
                    }
                    else if(pb==0x8d)
                        out2 = checklabs(offset)+","+regs[reg];
                    else if (offset>=0)
                        out2 = DEF.hexPrefix+String.format("%04X", offset)+","+regs[reg];
                    else
                        out2 = "-"+DEF.hexPrefix+String.format("%04X", offset)+","+regs[reg];
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
                        str += checklabs((operandarray[0]<<8)+operandarray[1], mode, numoperands);
                    }
                    else if (numoperands==1) //((numoperands==1)&&(mode!=IMM))
                    {
                        //give indicate 1 operand = 8 bit
                        if (mode != IMM)str += DEF._8bitPrefix;
                        str += checklabs(operandarray[0], mode, dp, numoperands );
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
        

        if ((memInfo.disType != MemoryInformation.DIS_TYPE_UNKOWN) && (memInfo.disType != MemoryInformation.DIS_TYPE_DATA_INSTRUCTION_GENERAL) )
            return "Memory location known, not disassembled again.";

        memInfo.hexDump = DEF.hexPrefix+String.format("%02X", opcode);
        op=null;

        // in i the number of the opcode in the pg1.opcode table!
        for(i=0;(i<numops[0])&&(pg1opcodes[i].opcode!=opcode);i++)
            ;
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
                    
                    if (memInfo.disType == MemoryInformation.DIS_TYPE_DATA_BYTE)
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

                if (  ((opcode==0x1f) || (opcode==0x1e)) 
                    && ( (c1) || (c2) || ((teregssize[(operand[0]>>4)&0xf]-teregssize[operand[0]&0xf])!=0) )
                   )
                {
                    return incorrectDisassembleFoundAt(startAddress, "Illegal Regsiter code (EXG/TFR).");
                }
                else if (((opcode==0x34)||(opcode==0x35)||(opcode==0x36)||(opcode==0x37))&&(operand[0]==0))
                {
                    /* test if push/pull register codes are right */
                    /* illegal register */
                    return incorrectDisassembleFoundAt(startAddress, "Illegal Regsiter code (PUSH/PULL).");
                }
                else
                {
                    if (pg1opcodes[i].mode!=IND)
                    {
                        memInfo.disassembledMnemonic += pg1opcodes[i].name;
                    }
                    String opAdd = printoperands(opcode,numoperands,operand, pg1opcodes[i].mode,pg1opcodes[i].name,0,memInfo);
                    if (memInfo.disType == MemoryInformation.DIS_TYPE_DATA_BYTE)
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
            myMemory.memMap.get(stringOrg).length++;
        } while ((info.content & 0xff) != 0x80);
        info.disType = MemoryInformation.DIS_TYPE_DATA_BYTE; // last of string is a $80 byte
        info = myMemory.memMap.get(a++);

        info.comments.add("Start music pointer");
        info.length = 2;
        info.disType = MemoryInformation.DIS_TYPE_DATA_WORD_POINTER; // music word pointer
        info = myMemory.memMap.get(a++);
        info.disType = MemoryInformation.DIS_TYPE_DATA_WORD_POINTER; // music word pointer
        while (myMemory.memMap.get(a).content != 0)
        {
            info = myMemory.memMap.get(a++);
            info.comments.add("hight, width, rel y, rel x (from 0,0)");
            info.disTypeCollectionMax = 4;
            info.disType = MemoryInformation.DIS_TYPE_DATA_BYTE; // Text Pos and size
            info = myMemory.memMap.get(a++);
            info.disType = MemoryInformation.DIS_TYPE_DATA_BYTE; // Text Pos and size
            info = myMemory.memMap.get(a++);
            info.disType = MemoryInformation.DIS_TYPE_DATA_BYTE; // Text Pos and size
            info = myMemory.memMap.get(a++);
            info.disType = MemoryInformation.DIS_TYPE_DATA_BYTE; // Text Pos and size

            myMemory.memMap.get(a).comments.add("individual title String(s)");
            stringOrg = a;
            myMemory.memMap.get(stringOrg).length = 0;
            do
            {
                info = myMemory.memMap.get(a++);
                info.disTypeCollectionMax = 30;
                info.disType = MemoryInformation.DIS_TYPE_DATA_CHAR;
                myMemory.memMap.get(stringOrg).length++;
            } while ((info.content & 0xff) != 0x80);
            info.disType = MemoryInformation.DIS_TYPE_DATA_BYTE; // last of string is a $80 byte
        }
        
        myMemory.memMap.get(a).disType = MemoryInformation.DIS_TYPE_DATA_BYTE; // end of header
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
        myMemory.setBank(bank, true);
        currentCNTScanBank = bank;
        if (assumeVectrexModule)
        {
            boolean tmp = createLabels;
            createLabels = false; // stupid labels may be generated, since some data is perhaps dissed
            try
            {
                if (config.lstFirst)
                {
                    boolean done = readLSTFile("system"+File.separator+"SYSTEM.LST", true);
                    if (!done)
                        readCNTFile("system"+File.separator+"SYSTEM.CNT");
                }
                else 
                {
                    boolean done = readCNTFile("system"+File.separator+"SYSTEM.CNT");
                    if (!done)
                        readLSTFile("system"+File.separator+"SYSTEM.LST", true);
                }
                
                Path path = Paths.get("system"+File.separator+"SYSTEM.IMG");
                byte[] biosData = Files.readAllBytes(path);
                disassemble(biosData,0xe000, 0xe000, false, bank);
            }
            catch (Throwable e)
            {
                log.addLog("An error occured while loading vectrex bios files.", WARN);
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
        int len = data.length;
        if (len > 32768) len = 32768;
        
        
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
        int end = 0xbfff;
        if (all) end = 0xffff;
        
        doAllKnownMemoryLocations(0, end);
    }
    
    public int getInstructionLengthAt(int address)
    {
        return myMemory.memMap.get(address).length;
    }
    
    // "disassembler" all memory locations, which are already known
    // this is called after loading CNT files
    // probably only "data" sections are processed!
    private void doAllKnownMemoryLocations(int startDisAddress, int endDisAddress)
    {        
        // doAllKnownmemoryLocations
        for (int i=startDisAddress; i< endDisAddress; )
        {
            // CHECK Whether current adress should be disassembled
            // or  be printed as data!
            MemoryInformation info = myMemory.memMap.get(i);
            
            if (info.disType == MemoryInformation.DIS_TYPE_UNKOWN)
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
                info.length = 2;
                info.done = true;
                int word = (info.content&0xff)*256;
                word += (myMemory.memMap.get(i+1).content & 0xff);
                info.disassembledMnemonic = "DW";
                info.disassembledOperand = DEF.hexPrefix+String.format("%04X", word);
                // disMax not done for word yet 
                // todo fixme!
            }
            else if (info.disType == MemoryInformation.DIS_TYPE_DATA_WORD_POINTER)
            {
                info.length = 2;
                info.done = true;
                int word = (info.content&0xff)*256;
                word += (myMemory.memMap.get(i+1).content & 0xff);
                if (myMemory.memMap.get(word).labels.size()>0)
                {
                    info.disassembledMnemonic = "DW";
                    info.disassembledOperand = myMemory.memMap.get(word).labels.get(0);
                }
                else
                {
                    info.disassembledMnemonic = "DW";
                    info.disassembledOperand = DEF.hexPrefix+String.format("%04X", word);
                }
                // disMax not done for word yet 
                // todo fixme!
            }
            
            // char type "switches" to DB on 0x80 and 0x00!
            else if (info.disType == MemoryInformation.DIS_TYPE_DATA_CHAR)
            {
                if (  ( (info.content&0xff) < 0x20) /* SPACE */
                    ||( (info.content&0xff) > 0x6F))
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
                    else if ((info.content&0x80) == 0x80)
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
                    if ((myMemory.memMap.get(i+orgInfo.length).content & 0x80) == 0x80)
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
            }
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
        name = name.substring(0,li)+".cnt";
        File f = new File(name);
        if (!f.exists()) return false;
        readCNTFile( name);
        return true;
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
                while (true) 
                {
                    lastAddress = doOneLSTLine(line, lastAddress, allowBios);
                    line = br.readLine();
                    if (line == null) break;
                    count++;
                }
                log.addLog("LST lines processed: " + count, INFO);
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
        
        
        if (s.length==0) return adr;
        if (s.length == 4)
        {
            if (s[1].equals(":"))
            {
                // fair enough - I take it, it is a label :)
                // label
                String address = s[2]; 
                String label = s[0];
                int adress = toNumber(address);
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
            if (type.trim().toUpperCase().equals("DB_DATA"))
            {
                if (maxSame==0) maxSame = 8;
                MemoryInformation info = myMemory.buildMemInfo(i);
                info.disType = MemoryInformation.DIS_TYPE_DATA_BYTE;
                info.disTypeCollectionMax = maxSame;
            }
            if (type.trim().toUpperCase().equals("BIN_DATA"))
            {
                if (maxSame==0) maxSame = 8;
                MemoryInformation info = myMemory.buildMemInfo(i);
                info.disType = MemoryInformation.DIS_TYPE_DATA_BINARY;
                info.disTypeCollectionMax = maxSame;
            }
            if (type.trim().toUpperCase().equals("DW_DATA"))
            {
                if (maxSame==0) maxSame = 4;
                MemoryInformation info = myMemory.buildMemInfo(i);
                info.disType = MemoryInformation.DIS_TYPE_DATA_WORD;
                info.disTypeCollectionMax = maxSame;
            }
            if (type.trim().toUpperCase().equals("DWP_DATA"))
            {
                if (maxSame==0) maxSame = 1;
                MemoryInformation info = myMemory.buildMemInfo(i);
                info.disType = MemoryInformation.DIS_TYPE_DATA_WORD_POINTER;
                info.disTypeCollectionMax = maxSame;
            }
            if (type.trim().toUpperCase().equals("CHAR_DATA"))
            {
                if (maxSame==0) maxSame = 20;
                MemoryInformation info = myMemory.buildMemInfo(i);
                info.disType = MemoryInformation.DIS_TYPE_DATA_CHAR;
                info.disTypeCollectionMax = maxSame;
            }
            if (type.trim().toUpperCase().equals("CODE"))
            {
                MemoryInformation info = myMemory.buildMemInfo(i);
                info.disType = MemoryInformation.DIS_TYPE_UNKOWN; // will be disassaembled!
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
    // DATA_WORD #adresse1# #adresse2#
    int currentCNTScanBank = 0;
    private void doOneCNTLine(String line)
    {
        line = line.trim();
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
        }        // COMMENT #adresse# "text"
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
                info.length = 1;
                info.disTypeCollectionMax = max;
            }
        }
        
        // DATA_BYTE #adresse1# #adresse2#
        else if (line.toUpperCase().startsWith("DATA_BYTE"))
        {
            int max = 4;
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
                info.disType = MemoryInformation.DIS_TYPE_DATA_BYTE;
                info.disTypeCollectionMax = max;
                info.length = 1;
            }
        }
        else if (line.toUpperCase().startsWith("DATA_BINARY"))
        {
            
            int max = 4;
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
                info.disType = MemoryInformation.DIS_TYPE_DATA_BINARY;
                info.disTypeCollectionMax = max;
                info.length = 1;
            }
        }
        // DATA_WORD #adresse1# #adresse2#
        else if (line.toUpperCase().startsWith("DATA_WORD"))
        {
            int max = 1;
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
                info.disType = MemoryInformation.DIS_TYPE_DATA_WORD;
                info.disTypeCollectionMax = max;
                info.length = 1; // hm todo fixme
            }
        }
    }
}
