/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.dissy;

import de.malban.vide.vecx.Breakpoint;
import java.util.ArrayList;

/**
 *
 * @author malban
 */
public class MemoryInformation
{
    public static final int MEM_TYPE_RAM = 0;
    public static final int MEM_TYPE_ROM = 1;
    public static final int MEM_TYPE_IO = 2;
    public static final int MEM_TYPE_BAD = 3;
    
    public static final int DIS_TYPE_UNKOWN = 0; 
    public static final int DIS_TYPE_DATA_BYTE = 1; 
    public static final int DIS_TYPE_DATA_WORD = 2; 
    public static final int DIS_TYPE_DATA_WORD_POINTER = 3; 
    public static final int DIS_TYPE_DATA_CHAR = 4;
    public static final int DIS_TYPE_DATA_BINARY = 5;
    
    public static final int DIS_TYPE_DATA_INSTRUCTION_1_LENGTH = 6; 
    public static final int DIS_TYPE_DATA_INSTRUCTION_2_LENGTH = 7; 
    public static final int DIS_TYPE_DATA_INSTRUCTION_3_LENGTH = 8; 
    public static final int DIS_TYPE_DATA_INSTRUCTION_4_LENGTH = 9; 
    public static final int DIS_TYPE_DATA_INSTRUCTION_5_LENGTH = 10; 
    
    public static final int DIS_TYPE_DATA_BELONGSTO_INSTRUCTION_POS_1 = 11; 
    public static final int DIS_TYPE_DATA_BELONGSTO_INSTRUCTION_POS_2 = 12; 
    public static final int DIS_TYPE_DATA_BELONGSTO_INSTRUCTION_POS_3 = 13; 
    public static final int DIS_TYPE_DATA_BELONGSTO_INSTRUCTION_POS_4 = 14; 
    
    public static final int DIS_TYPE_DATA_INSTRUCTION_GENERAL = 15; 
    
    public static String[] disTypeString = {"UNKOWN", "DB Byte", "DB Word", "DB Ptr", "DB Char",
                                            "INS 1","INS 2","INS 3","INS 4","INS 5",
                                            "INSPart 2","INSPart 3","INSPart 4","INSPart 5", "INS UNKOWN"
    };

    // this class describes ONE BYTE of memory!
    public final int address; // adress of THIS instruction
    public byte content;      // one byte, content of this memory location
    public int length = 1;    // the instruction length (or the consecutive data length)
    public int memType = MEM_TYPE_ROM;    // RAM/ROM
    public int disType = DIS_TYPE_UNKOWN; // was knowledge gathered, and is known as, see above DIS_TYPE_DATA...

    public boolean visible = true; // only for cdissi, convenience lazyness
    
    public int directPageAddress = -1;
    
    public String disassemblerInfoText = ""; // if an error occured disassembling this address - an error text will be provided here
    
    public int disTypeCollectionMax = 4;  // how many bytes (when byte7word/char) can be collected on a single assembler instruction line
    public int referingAddressMode=-1;    // what kind of adressing mode is used by this instruction
    public int referingToAddress=-1;      // and what is the adress of that
    public boolean referingToShort=false; // is it refering to 8 bit?
    public boolean contentUnkown = true;  // true if this memory address was not "loaded" from a file and is as such unkown

    public String forcedSymbol = null; // null = default, string = label, empty string = number
    
    public ArrayList<String> labels = new ArrayList<String>();   // all labels this adress has
    public ArrayList<String> immediateLabels = new ArrayList<String>();   // all labels this adress represents as an immediate value!
    public ArrayList<String> comments = new ArrayList<String>(); // comment lines this adress has
    public int page = -1;                 // is this a page 1 opcode, or is it a "switch" to page 2 or 3
    public int indexInOpcodeTablePage0 = -1; // allways (first byte (16/17) of page 2 opcode has a page 0 offset, even if it denotes page =2) 
    public int indexInOpcodeTablePage1 = -1; // sometimes (only the second byte of page = 2 opcode can have a page 2 opcode)
    public int indexInOpcodeTablePage2 = -1; // sometimes (only the second byte of page = 3 opcode can have a page 3 opcode)
    
    public String hexDump="";            
    public String disassembledMnemonic="";
    public String disassembledOperand="";
    public boolean done = false;          // set when this memory location is fully disassembled, to prevent a "second" pass
    
    public int isInstructionByte = 0;     // set to instructions with a length >1 to the following bytes, a counter within each opcodes and its operands
    public MemoryInformation belongsToInstruction = null; // if a multi-byte opcode, than here is the memory information of the root byte (the first)
    public ArrayList<MemoryInformation> familyBytes = new ArrayList<MemoryInformation>(); // the "root" byte has here a collection of its "children"
    private ArrayList<Breakpoint> breakpoints = null;

    
    int cycles =-1;
    public MemoryInformation(int adr, byte mem)
    {
        address = adr;
        content = mem;
        contentUnkown = false;
    }
    // 
    public boolean hasImmediateLabel(String la)
    {
        for (String l : immediateLabels)
        {
            if (l.trim().equals(la.trim())) return true;
        }
        return false;
    }
    public boolean hasLabel(String la)
    {
        for (String l : labels)
        {
            if (l.trim().equals(la.trim())) return true;
        }
        return false;
    }
    public boolean hasComment(String co)
    {
        for (String c : comments)
        {
            if (c.trim().equals(co.trim())) return true;
        }
        return false;
    }
    
    public void addBreakpoint(Breakpoint bp)
    {
        if (breakpoints==null) breakpoints = new ArrayList<Breakpoint>();
        
        breakpoints.add(bp);
    }
    public void removeBreakpoint(Breakpoint bp)
    {
        if (breakpoints==null) return;
        while (breakpoints.remove(bp)); // remove all instances
    }
    public boolean hasBreakpoint()
    {
        if (breakpoints==null) return false;
        return breakpoints.size()!=0;
    }
    public ArrayList<Breakpoint> getBreakpoints()
    {
        return breakpoints;
    }
    public void resetBreakPoints()
    {
        if (breakpoints == null) return;
        breakpoints.clear();
    }

    // if return != null
    // that is the breakpoint that was found!
    public Breakpoint hasBreakpoint(Breakpoint bp)
    {
        if (breakpoints==null) return null;
        for (Breakpoint breakpoint: breakpoints)
        {
            if (breakpoint.addressEquals(bp)) return breakpoint;
        }
        return null;
    }
    
    // does NOT reset labels
    // does NOT reset comments!
    public void reset()
    {
        if (disType>=DIS_TYPE_DATA_INSTRUCTION_1_LENGTH)
            disType = DIS_TYPE_DATA_INSTRUCTION_GENERAL;
        disassembledMnemonic = "";
        disassembledOperand = "";
        done = false;
        length = 1;
        indexInOpcodeTablePage0 = -1;
        indexInOpcodeTablePage1 = -1;
        indexInOpcodeTablePage2 = -1;
        page = -1;
        belongsToInstruction = null;
        // reset following family bytes, that are might have "damaged"
        for (MemoryInformation mi: familyBytes)
        {
            mi.isInstructionByte = 0;
            mi.hexDump = "";
            mi.belongsToInstruction = null;
            mi.disType = MemoryInformation.DIS_TYPE_UNKOWN;
            
        }
        familyBytes.clear();
        disassemblerInfoText="";
    }
}
