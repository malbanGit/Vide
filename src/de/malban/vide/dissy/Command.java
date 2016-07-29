/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.dissy;

/**
 *
 * @author malban
 */
public class Command
{
    public static final int D_CMD_RESET = 0;
    public static final int D_CMD_GO = 1;
    public static final int D_CMD_CYCLES = 2;
    public static final int D_CMD_PRINT = 3;
    public static final int D_CMD_WATCH = 4;
    public static final int D_CMD_BREAKPOINT = 5;
    public static final int D_CMD_BREAKPOINT_RESET = 6;
    public static final int D_CMD_HELP = 7;
    public static final int D_CMD_LABEL_RESET = 8;
    public static final int D_CMD_INFO = 9;
    public static final int D_CMD_BANKSWITCH = 10;
    public static final int D_CMD_REMOVE_DISSI_COMMENTS = 11;
    public static final int D_CMD_BANKSWITCH_INFO = 12;
    public static final int D_CMD_CLEAR_SCREEN = 13;
    public static final int D_CMD_RUN_CYCLES = 14;
    public static final int D_CMD_CYCLES_MEASURE = 15;
    public static final int D_CMD_POKE = 16;
    public static final int D_CMD_SOFTRESET = 17;
    public static final int D_CMD_SYNC_BANK_COMMENTS = 18;
    public static final int D_CMD_CARTRIDGE = 19;
    public static final int D_CMD_JOYPORT_DEVICE = 20;
    public static final int D_CMD_BANKSWITCH_DEBUG = 21;
    
    

    public static final Command[] commands = 
    {
        new Command(D_CMD_RESET, "HardReset", "hr", 0,0,"\"HardReset\"\t\tvectrex, start with currently loaded cartridge (reloaded, HARD reset)",""),
        new Command(D_CMD_SOFTRESET, "SoftReset", "sr", 0,0,"\"SoftReset\"\t\tvectrex, start with currently loaded cartridge (not reloaded, SOFT reset)",""),
        new Command(D_CMD_GO, "Go [xxxx]", "g", 0,0,"\"Go\"\t\t\tleave debugging, and run the emulator [go from, meaning pc = xxxx than go]","G"),
        new Command(D_CMD_CYCLES, "Cycles", "c", 0,1,"\"Cycles [#number]\"\t\tprint current cycle count of running vectrex, \n\t\t\t#number sets the current cycle count",""),
        new Command(D_CMD_RUN_CYCLES, "RunCycles", "rc", 0,0,"\"RunCycles ####\"\t\tRun program untill at least #### cycles have been processed\n\t\t\t(all instructions are fully processed) ",""),
        new Command(D_CMD_CYCLES_MEASURE, "CountCycles", "cc", 0,0,"\"CountCycles $xxxx $yyyy\"\tnext time pc executed $xxxx it starts counting cycles \n\t\t\tand prints out the count after $yyyy is executed(only in currently emulated bank!) ",""),
        new Command(D_CMD_PRINT, "Print", "p", 1,1,"\"Print $xxxx|$label [8|16]\"\tprint content of an address or label, \n\t\t\t8 as 8bit (default), 16 as 16bit",""),
        new Command(D_CMD_WATCH, "Watch", "w", 1,1,"\"Watch $xxxx|$label [8|16]\"\twatch content of an address or label, \n\t\t\t8 as 8bit (default), 16 as 16bit",""),
        new Command(D_CMD_BREAKPOINT, "Breakpoint", "b", 1,0,"\"Breakpoint $xxxx\"\t\ttoggle breakpoint to address\n\t\t\t|bankswitch\n\t\t\tVIA_ORB $0-7 (bit )","SPACE"),
        new Command(D_CMD_BREAKPOINT_RESET, "ClearBreakpoint", "cb", 0,0,"\"ClearBreakpoint\"\t\tclears all breakpoints",""),
        new Command(D_CMD_LABEL_RESET, "LabelReset", "lr", 0,0,"\"LabelReset\"\t\tResets all automatically build labels",""),
        new Command(D_CMD_INFO, "Info", "i", 0,0,"\"Info\"\t\t\tPrint information about current cartridge",""),
        new Command(D_CMD_BANKSWITCH, "Bankswitch", "bs", 0,0,"\"Bankswitch $00\"\t\tSwitch debugger to bank x (%maxBanks for cartridge)",""),
        new Command(D_CMD_HELP, "Help", "h", 0,0,"\"Help\"\t\t\toutput list of commands",""),
        new Command(D_CMD_REMOVE_DISSI_COMMENTS, "RMD", "", 0,0,"\"RMD\"\t\t\tremove automatically generated dissi comments",""),
        new Command(D_CMD_BANKSWITCH_INFO, "BankswitchInfo", "bi", 0,0,"\"BankswitchInfo\"\t\tDisplay a textmessage upon bankswitch (toggle)",""),
        new Command(D_CMD_CLEAR_SCREEN, "CLS", "", 0,0,"\"CLS\"\t\t\tClear messages",""),
        new Command(D_CMD_POKE, "POKE", "", 0,0,"\"POKE\"\t\t\t$xxxx $yy write value to address",""),
        new Command(D_CMD_SYNC_BANK_COMMENTS, "SyncBankComments", "sbc", 0,0,"\"SyncBankComments\"\t\tSynchronizes comments in different banks, if code/data is equal.",""),
        new Command(D_CMD_CARTRIDGE, "carti", "", 0,0,"\"carti\"\t\t\tOpens a cartridge device debug window.",""),
        new Command(D_CMD_JOYPORT_DEVICE, "joyi", "", 0,0,"\"joyi\"\t\t\tOpens a joyport device debug window.",""),
        new Command(D_CMD_BANKSWITCH_DEBUG, "BankswitchDebug", "bsd", 0,0,"\"BankswitchDebug\"\t\tAll memory brakpoints are set/deleted in all banks.",""),
    };
    
    public String fullname ="";
    public String abreviation ="";
    public String shortkey ="";
    public String help = ""; 
    public int numNeededArguments =0;
    public int numOptionalArguments =0;
    public int ID =0;
    
    private Command(int i, String fn, String ab, int na, int oa, String sy, String sk)
    {
        ID = i;
        fullname = fn;
        abreviation = ab;
        numNeededArguments = na;
        numOptionalArguments = oa;
        shortkey = sk;
        help = sy;
    }
    public static Command getCommand(String s)
    {
        for (Command c: commands)
        {
            if (s.toLowerCase().equals(c.fullname.toLowerCase())) return c;
            if (s.toLowerCase().equals(c.abreviation.toLowerCase())) return c;
        }
        return null;
    }
    public static String getHelp()
    {
        StringBuilder s = new StringBuilder();
        s.append("List of all dissi commands:\n");
        for (Command c: commands)
        {
            s.append(c.help).append(" [").append(c.abreviation).append("]"+"\n");
        }
        return s.toString();
    }
    
    
}
