/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx;

import de.malban.vide.dissy.MemoryInformation;
import static de.malban.vide.vecx.VecXStatics.EMU_EXIT_BREAKPOINT_BREAK;
import java.io.Serializable;
import java.util.ArrayList;

/**
 *
 * @author malban   
 */
public class Breakpoint implements Serializable
{
    public static int BP_NONE = 0;
    public static int BP_ONCE = 1;
    public static int BP_MULTI = 2;
    public static int BP_READ = 4;
    public static int BP_WRITE = 8;
    public static int BP_INFO = 16;
    public static int BP_COMPARE = 32;
    public static int BP_HEY = 64;
    public static int BP_BANK = 128;
    public static int BP_BITCOMPARE = 256;
    public static int BP_CYCLES = 512;
    public static int BP_QUIET = 1024;
    public static int BP_ALLBANK = 2048;
    public static int BP_WEIRD = 4096;
    public static int BP_INTEGRATOR = 4096*2;
    public static String[] types={"once", "multi", "read", "write", "info", "compare", "hey","bank", "bitcompare", "cycles", "quiet", "allbanks", "weird", "integrators"};
    

    public static int BP_TARGET_MEMORY = 0;
    public static int BP_TARGET_CPU = 1;
    public static int BP_TARGET_ANALOG = 2;
    public static int BP_TARGET_VIA = 3;
    public static int BP_TARGET_PSG = 4;
    public static int BP_TARGET_CARTRIDGE = 5;
    public static int BP_TARGET_PORT = 6;
    
    public static int BP_TARGET_COUNT = 7;

    public static String[] bp_target={"Memory", "CPU", "Analog", "VIA", "PSG", "CARTRIDGE", "PORT"};

    public static String[][] bp_subtarget={
        /* Memory*/     {"none","RAM","ROM"}, 
        /* CPU*/        {"none","PC","A", "B", "D","X", "Y","U","S", "CC", "DP", "CYCLES", "SPECIAL" }, 
        /* Analog*/     {"none","RAMP"}, 
        /* VIA*/        {"none","ORB","CA1", "AUX"}, 
        /* PSG*/        {"none","PSG 0"}, 
        /* CARTRIDGE*/  {"none","BANKSWITCH", "PB6"}, 
        /* PORT*/       {"none","IN", "OUT"}
    };
    
    public static int BP_SUBTARGET_MEMORY_NONE = 0; // 
    public static int BP_SUBTARGET_MEMORY_RAM = 1; // 
    public static int BP_SUBTARGET_MEMORY_ROM = 2; // 
    
    public static int BP_SUBTARGET_CPU_NONE = 0; // only one implemented
    public static int BP_SUBTARGET_CPU_PC = 1; // only one implemented
    public static int BP_SUBTARGET_CPU_A = 2;
    public static int BP_SUBTARGET_CPU_B = 3;
    public static int BP_SUBTARGET_CPU_D = 4;
    public static int BP_SUBTARGET_CPU_X = 5;
    public static int BP_SUBTARGET_CPU_Y = 6;
    public static int BP_SUBTARGET_CPU_U = 7;
    public static int BP_SUBTARGET_CPU_S = 8;
    public static int BP_SUBTARGET_CPU_CC = 9;
    public static int BP_SUBTARGET_CPU_DP = 10;
    public static int BP_SUBTARGET_CPU_CYCLES = 11;
    public static int BP_SUBTARGET_CPU_SPECIAL = 12;
    
    public static int BP_SUBTARGET_ANALOG_NONE = 0; // .. not implemented
    public static int BP_SUBTARGET_ANALOG_RAMP = 1; // .. not implemented

    public static int BP_SUBTARGET_VIA_NONE = 0; // 
    public static int BP_SUBTARGET_VIA_ORB = 1; // 
    public static int BP_SUBTARGET_VIA_CA1 = 2; // 
    public static int BP_SUBTARGET_VIA_AUX = 3; // 
    
    public static int BP_SUBTARGET_PSG_NONE = 0; // .. not implemented
    public static int BP_SUBTARGET_PSG_0 = 1; // .. not implemented

    public static int BP_SUBTARGET_CARTRIDGE_NONE = 0;
    public static int BP_SUBTARGET_CARTRIDGE_BANKSWITCH = 1;
    public static int BP_SUBTARGET_CARTRIDGE_PB6 = 2;
    
    public static int BP_SUBTARGET_PORT_NONE = 0;
    public static int BP_SUBTARGET_PORT_IN = 1;
    public static int BP_SUBTARGET_PORT_OUT = 2;
    
    
    
    private static int UID_C = 1;

    public int targetType = BP_TARGET_CPU;
    public int targetSubType = BP_SUBTARGET_CPU_PC;
    public int type = BP_ONCE;
    public int targetAddress=0;
    public int targetBank=0;
    public int compareValue=0;
    public long counter=0;
    public String name = "";
    public int exitType = EMU_EXIT_BREAKPOINT_BREAK; // default break of emulation
    public boolean enabled = true;
    public ArrayList<String> printInfo = null;
    
    public transient MemoryInformation memInfo = null;
    public transient final int uid = UID_C++;
    public transient boolean wasTriggered = false;
    
    
    // meminfo is not cloned, but taken directly!
    public Breakpoint duplicate()
    {
        Breakpoint nbp = new Breakpoint();
        nbp.targetType = targetType;
        nbp.targetSubType = targetSubType;
        nbp.type = type;
        nbp.targetAddress = targetAddress;
        nbp.targetBank = targetBank;
        nbp.compareValue = compareValue;
        nbp.counter = counter;
        nbp.name = name;
        nbp.enabled = enabled;
        nbp.exitType = exitType;
        nbp.wasTriggered = wasTriggered;
        if (printInfo != null)
            nbp.printInfo = (ArrayList<String>) printInfo.clone();
        else
            nbp.printInfo = null;
        nbp.memInfo = memInfo;
        return nbp;
    }
    
    // are the two breakpoints "adress similar"
    public boolean addressEquals(Breakpoint bp)
    {
        if (targetType != bp.targetType) return false;
        if (targetSubType != bp.targetSubType) return false;
        if (targetAddress != bp.targetAddress) return false;
        if (targetBank != bp.targetBank) return false;
        if (type != bp.type) return false;
        return true;
    }
    
    public boolean equals(Breakpoint bp)
    {
        if (targetType != bp.targetType) return false;
        if (targetSubType != bp.targetSubType) return false;
        if (targetAddress != bp.targetAddress) return false;
        if (targetBank != bp.targetBank) return false;
        if (compareValue != bp.compareValue) return false;
        if (type != bp.type) return false;
        return true;
    }
    
    public String toString()
    {
        String ret = "Breakpoint, type="+bp_target[targetType];
        ret+=", subtype="+bp_subtarget[targetType][targetSubType];
        if (targetAddress!=0) 
        {
            ret+=", address="+String.format("$%04X",targetAddress);
            ret+=", bank="+targetBank;
        }
        ret+=", typeflags: ";
        int t=type;
        for (int i=0;i<types.length;i++) 
        {
            if ((t&1)==1) 
                ret+=types[i]+" ";
            t = t>>1;
        }
        
        return ret;
    }
    public String getTargetString()
    {
        return bp_target[targetType];
    }
    public String getTargetSubtypeString()
    {
        return bp_subtarget[targetType][targetSubType];
    }
    public int getTargetAddress()
    {
        return targetAddress;
    }
    public int getTargetBank()
    {
        return targetBank;
    }
    public String getTypeString()
    {
        String ret ="";
        int t=type;
        for (int i=0;i<types.length;i++) 
        {
            if ((t&1)==1) 
                ret+=types[i]+" ";
            t = t>>1;
        }
        return ret;
    }
    public int getCompareValue()
    {
        return compareValue;
    }
    
    public String getExitTypeString()
    {
        if (exitType == EMU_EXIT_BREAKPOINT_BREAK) return "break";
        return "info";
    }
    public long getCounter()
    {
        return counter;
    }
    public String getName()
    {
        return name;
    }
    public boolean wasTriggered()
    {
        return wasTriggered;
    }
    public void setTriggered(boolean b)
    {
        wasTriggered = b;
    }
}
