/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx.cartridge;

import de.malban.config.Configuration;
import de.malban.gui.CSAMainFrame;
import de.malban.gui.panels.LogPanel;
import java.io.File;
import java.io.Serializable;

/**
 *
 * @author malban
 * 
 * Based on the description and vectrex source code from Alex Herbert 
 * 
 * Emulation is only done in so far, that SP can be read and written,
 * this is no FULL emulation of a DS2430!
 * 
 * 
 * In General the below emulation are two state machines, one lowlevel "machine"
 * which regulats bit manipulations and waits for timings slots and so on
 * 
 * and one highlevel machine which emulates the
 * commands, the highlevel uses the lowlevel machine and is "called" back from
 * it when it is finished.
 * 
 * Input/output is basically done via the lineIn and lineOut functions
 * both functions in itself do not trigger any further actions.
 *
 * All steps of emulation are "triggered" from the "step" function.
 * The step function should be called EVERY emulated cycle.
 * 
 * The step function is basically the lowLevel statemachine, which on occassion
 * triggers the highlevel.
 * 
 */
/*
; 1-Wire Timing constants
; Reset Pulse duration
; $032a = 810 cycles = 540us

; Presence Pulse duration
; $02d0 = 720 cycles = 480us

; Time Slot duration
; $78 = 120cycles = 80us

; Note:
;
; For reliability DS1W_RESETDUR and DS1W_TSLOTDUR are set above the
; minimums specified by the datasheet. To improve performance, values
; closer to the specified minimums may be used.
;
; DS1W_RESETDUR minimum = 480us
; DS1W_TSLOTDUR minimum = 60us


; 1-Wire ROM commands
DS1W_READROM    equ     $33
DS1W_SKIPROM    equ     $cc

DS1W_MATCHROM   equ     $55
DS1W_SEARCHROM  equ     $f0

*/

public class DS2430A implements Serializable
{
    transient LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
    public static final int LL_UNKOWN = 0;
    public static final int LL_RESET_START = 1;
    public static final int LL_RESETED = 2;
    public static final int LL_PULSE_GENERATION = 3;
    public static final int LL_PULSE_GENERATION_DONE = 4;
    public static final int LL_READY_FOR_BITREAD = 5;
    public static final int LL_BITREAD_STARTED = 6;
    public static final int LL_READY_FOR_BITREAD_CONTINUE = 7;
    public static final int LL_WAIT_FOR_BITWRITE_PULSE_START = 8;
    public static final int LL_WAIT_FOR_BITWRITE_PULSE_END = 9;
    public static final int LL_WAIT_FOR_BITWRITE_FINISH = 10;
    
    String[] ll_names = {
        "UNKOWN",
        "RESET_START",
        "RESETED",
        "PULSE_GENERATION",
        "PULSE_GENERATION_DONE",
        "READY_FOR_BITREAD",
        "BITREAD_STARTED",
        "READY_FOR_BITREAD_CONTINUE",
        "WAIT_FOR_BITWRITE_PULSE_START",
        "WAIT_FOR_BITWRITE_PULSE_END",
        "WAIT_FOR_BITWRITE_FINISH"
    };
    
    
    
    // Timings for low level communication (in 6809 cycles)
    public static int RESET_CYCLE_DURATION = 720;
    public static int WAIT_TO_GO_LOW_AFTER_RESET_CYCLES = 50;
    public static int PULSE_PRESENT_DURATION_CYCLES = 700;
    public static int BIT_TIMESLOT = 120; // 80u
    public static int HIGH_BIT_CYLCE = 40; // something significntly smaller than 120
    
    

    public static final int HL_WAIT_FOR_1W_COMMAND = 0;
    public static final int HL_WAIT_FOR_2430_COMMAND = 1;
    public static final int HL_WAIT_FOR_READ_ADDRESS = 2;
    public static final int HL_READ_BYTE_FROM_SP = 3;
    public static final int HL_WAIT_FOR_WRITE_ADDRESS = 4;
    public static final int HL_WRITE_BYTE_TO_SP = 5;
    String[] hl_names = {
        "WAIT_FOR_1W_COMMAND",
        "WAIT_FOR_2430_COMMAND",
        "WAIT_FOR_READ_ADDRESS",
        "READ_BYTE_FROM_SP",
        "WAIT_FOR_WRITE_ADDRESS",
        "WRITE_BYTE_TO_SP"
    };
    
    // 1 Wire protocoll commands
    public static final int DS1W_NONE = 0x00;
    public static final int DS1W_SKIPROM = 0xcc;
    public static final int DS1W_MATCHROM = 0x55;
    public static final int DS1W_SEARCHROM = 0xf0;
    public static final int DS1W_READROM = 0x33;
    public static final int DS1W_NOT_SUPPORTED = -1;
    
    // DS2430 commands
    public static final int DS2430_NONE = 0x00;
    public static final int DS2430_READMEM = 0xf0;
    public static final int DS2430_WRITESP = 0x0f;
    public static final int DS2430_READSP = 0xaa;
    public static final int DS2430_COPYSP = 0x55;
    public static final int DS2430_VALKEY = 0xa5;
    public static final int DS2430_NOT_SUPPORTED = -1;
    
    int FAMILY_CODE = 0x14; 
    int SERIAL_NUMBER = 0; // 48 bit
    
/*


; DS2430 Commands

DS2430_WRITESP  equ     $0f     ; Write bytes to Scratch Pad
DS2430_COPYSP   equ     $55     ; Copy entire Scratch Pad to EEPROM
DS2430_READSP   equ     $aa     ; Read bytes from Scratch Pad
DS2430_READMEM  equ     $f0     ; As READSP, but copies EEPROM to SP first

DS2430_LOCKAR   equ     $5a     ; Lock Application Register
DS2430_READSR   equ     $66     ; Read Status Register
DS2430_WRITEAR  equ     $99     ; Write bytes to Application Register
DS2430_READAR   equ     $c3     ; Read bytes from Application Register

DS2430_VALKEY   equ     $a5     ; Validation byte for COPYSP and LOCKAR

    
    */       
    public String getLowLevelName()
    {
        return ll_names[lowLevelState];
    }
    public String getHighLevelName()
    {
        return hl_names[highLevelState];
    }
    public String get1WCommandName()
    {
        if (current1WCommand == DS1W_NONE) return "NONE";
        if (current1WCommand == DS1W_SKIPROM) return "SKIPROM";
        if (current1WCommand == DS1W_MATCHROM) return "MATCHROM";
        if (current1WCommand == DS1W_SEARCHROM) return "SEARCHROM";
        if (current1WCommand == DS1W_READROM) return "READROM";
        return "NOT SUPPORTED ($"+String.format("$%02X", (current1WCommand&0xff) )+")";
    }

    public String get2430CommandName()
    {
        if (current2430Command == DS2430_NONE) return "NONE";
        if (current2430Command == DS2430_READMEM) return "READMEM";
        if (current2430Command == DS2430_WRITESP) return "WRITESP";
        if (current2430Command == DS2430_READSP) return "READSP";
        if (current2430Command == DS2430_COPYSP) return "COPYSP";
        if (current2430Command == DS2430_VALKEY) return "VALKEY";
        return "NOT SUPPORTED ($"+String.format("$%02X", (current2430Command&0xff) )+")";
    }
    public void init()
    {
        if (log == null)
            log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
    }

    public boolean isInputToDS()
    {
        return isReadFromDS;
    }
    public String getSyncCycles()
    {
        return ""+dif;
    }
    public String getLineIn()
    {
        if (lineIn) return "1";
        return "0";
    }
    public String getLineOut()
    {
        if (lineOut) return "1";
        return "0";
    }
    public String getBitCounterFromVectrex()
    {
        return ""+bitsLoaded;
    }
    public String getBitCounterFromDS()
    {
        return ""+bitsOutputDone;
    }
    public String getBitFromDS()
    {
        return ""+(currentByteOutput & 0x01);
    }
    public String getBitFromVectrex()
    {
        return ""+(currentByteRead & 0x01);
    }

    
        
    
    public static final int MAX_DATA_LEN = 32;
    
    public transient Cartridge cart;
    
    static class EpromData implements Serializable
    {
        byte[] data = new byte[MAX_DATA_LEN];
    }
    EpromData epromData = new EpromData();
    public byte[] getData()
    {
        return epromData.data;
    }
    
    long cycles = 0;
    boolean line = false; // false is 0, true is 1
    boolean old_line = false;
    boolean lineIn = false; // false is 0, true is 1
    boolean lineOut = false; // false is 0, true is 1

    int lowLevelState = LL_UNKOWN;
    int highLevelState = HL_WAIT_FOR_1W_COMMAND;

    int currentByteRead = 0;
    int bitsLoaded = 0;

    int currentOutputAddress = 0;
    int currentInputAddress = 0;
    int currentByteOutput = 0;
    int bitsOutputDone = 0;
    
    int current1WCommand = DS1W_NONE;
    int current2430Command = DS2430_NONE;
    long dif = 0;
    int currentWriteByteComplete = 0;
    
    boolean isReadFromDS = false;

    public void reset()
    {
        cycles = 0;
        line = false; // false is 0, true is 1
        old_line = false;
        lineIn = false; // false is 0, true is 1
        lineOut = false; // false is 0, true is 1

        lowLevelState = LL_UNKOWN;
        highLevelState = HL_WAIT_FOR_1W_COMMAND;

        currentByteRead = 0;
        bitsLoaded = 0;

        currentOutputAddress = 0;
        currentInputAddress = 0;
        currentByteOutput = 0;
        bitsOutputDone = 0;

        current1WCommand = DS1W_NONE;
        current2430Command = DS2430_NONE;
        dif = 0;
        currentWriteByteComplete = 0;
        isReadFromDS = false;

    }
    public DS2430A(Cartridge c)
    {
        cart = c;
    }
    public DS2430A clone()
    {
        DS2430A c = new DS2430A(cart);
        for (int i=0; i<MAX_DATA_LEN;i++)
        {
            c.epromData.data[i] = epromData.data[i];
        }
        c.cycles = cycles;
        c.lineOut = lineOut; 
        c.line = line; 
        c.old_line = old_line;
        c.lowLevelState = lowLevelState;
        c.highLevelState = highLevelState;
        c.isReadFromDS = isReadFromDS;
        c.dif = dif;

        c.currentByteRead = currentByteRead;
        c.bitsLoaded = bitsLoaded;

        c.currentOutputAddress = currentOutputAddress;
        c.currentInputAddress = currentInputAddress;
        c.currentByteOutput = currentByteOutput;
        c.bitsOutputDone = bitsOutputDone;
        c.currentWriteByteComplete = currentWriteByteComplete;
        c.current1WCommand = current1WCommand;
        c.current2430Command = current2430Command;
        
        return c;
    }
    
    // receiving line information from the emulator (VIA)
    public void lineIn(boolean l)
    {
        line = l;
        lineIn = l;
    }

    // sending line information to the emulator (VIA)
    public void lineOut(boolean l)
    {
        line = l;
        lineOut = l;
        cart.setPB6FromCarrtridge(line);
    }

    // low level step
    // this is triggered with every cycle from the emulator
    // c is the current cylce counter of the vecx emulator, needed for timing
    // (since I don't trust that we are called each cycle :-) )
    public void step(long c)
    {
        dif = c - cycles;
        if (line != old_line)
        {
            // reset cycle count on line changes (which are triggered from the outside)
            cycles = c;
        }
        if ((!line) && (!old_line))
        {
            if (lowLevelState == LL_RESET_START) return;
            // if line low longer than 480u
            // initiate reset sequence
            if (dif > RESET_CYCLE_DURATION) // 720 cycles = 480us reset duration as in datasheet
            {
                log.addLog("DS2430 Reset sequence 1) - start!", LogPanel.INFO);
                lowLevelState = LL_RESET_START;
                highLevelState = HL_WAIT_FOR_1W_COMMAND;
            }
        }
        switch (lowLevelState)
        {
            case LL_WAIT_FOR_BITWRITE_PULSE_START:
            {
                if (!line)
                {
                    lowLevelState = LL_WAIT_FOR_BITWRITE_PULSE_END;
                    log.addLog("DS2430 write byte pulse started!", LogPanel.INFO);
                }
                break;
            }
            case LL_WAIT_FOR_BITWRITE_PULSE_END:
            {
                if (line)
                {
                    lowLevelState = LL_WAIT_FOR_BITWRITE_FINISH;
                    log.addLog("DS2430 write bit pulse ended, starting bit out...!", LogPanel.INFO);

                    // LSB first
                    boolean bit = (currentByteOutput & 0x01) == 0x01;
                    currentByteOutput = currentByteOutput>>1;
                    lineOut(bit);
                    bitsOutputDone++;
                }
                break;
            }
            case LL_WAIT_FOR_BITWRITE_FINISH:
            {
                if (dif >= BIT_TIMESLOT)
                {
                    lineOut(true);
                    if (old_line)
                    {
                        log.addLog("DS2430 Write bit timeslot done (1)!", LogPanel.INFO);
                    }
                    else
                    {
                        log.addLog("DS2430 Write bit timeslot done (0)!", LogPanel.INFO);
                    }
                    if (bitsOutputDone == 8)
                    {
                        log.addLog("DS2430 Write completed: "+String.format("$%02X", currentWriteByteComplete ), LogPanel.INFO);
                        highLevelStep();
                    }
                    else
                    {
                        lowLevelState = LL_WAIT_FOR_BITWRITE_PULSE_START;
                    }
                }
                
                break;
            }
            
            case LL_READY_FOR_BITREAD:
            {
                if (!line)
                {
                    lowLevelState = LL_BITREAD_STARTED;
                    log.addLog("DS2430 Read command 1) - bit start!", LogPanel.INFO);
                }
                break;
            }
            case LL_READY_FOR_BITREAD_CONTINUE:
            {
                if (!line)
                {
                    lowLevelState = LL_BITREAD_STARTED;
                    log.addLog("DS2430 Read command 1b) - bit start!", LogPanel.INFO);
                }
                break;
            }
            case LL_BITREAD_STARTED:
            {
                if (line)
                {
                    // LSB first
                    currentByteRead = currentByteRead>>1;
                    if (dif <= HIGH_BIT_CYLCE)
                    {
                        currentByteRead+=128;
                        log.addLog("DS2430 Read command 2) - load 1!", LogPanel.INFO);
                    }
                    else
                    {
                        currentByteRead+=0;
                        log.addLog("DS2430 Read command 2) - load 0!", LogPanel.INFO);
                    }
                    lowLevelState = LL_READY_FOR_BITREAD_CONTINUE;
                    bitsLoaded++;
                    if (bitsLoaded == 8)
                    {
                        log.addLog("DS2430 Read command 3) - loaded: "+String.format("$%02X", currentByteRead ), LogPanel.INFO);
                        highLevelStep();
                    }
                }
                break;
            }
            case LL_RESET_START:
            {
                if (line)
                {
                    lowLevelState = LL_RESETED;
                    log.addLog("DS2430 Reset sequence 2) - reset!", LogPanel.INFO);
                }
                break;
            }
            case LL_RESETED:
            {
                if (dif > WAIT_TO_GO_LOW_AFTER_RESET_CYCLES)
                {
                    lowLevelState = LL_PULSE_GENERATION;
                    lineOut(false);
                    log.addLog("DS2430 Reset sequence 3) - pulse start!", LogPanel.INFO);
                }
                break;
            }
            case LL_PULSE_GENERATION:
            {
                if (dif > PULSE_PRESENT_DURATION_CYCLES)
                {
                    lowLevelState = LL_READY_FOR_BITREAD;
                    currentByteRead = 0;
                    bitsLoaded = 0;
                    lineOut(true);
                    log.addLog("DS2430 Reset sequence 4) - pulse end!", LogPanel.INFO);
                }
                break;
            }
            
            default:
            {
                break;
            }
        }
        old_line = line;
    }
    
    
    // High Level commands
    void highLevelStep()
    {
        isReadFromDS = true;
        if (highLevelState == HL_WAIT_FOR_1W_COMMAND)
        {
            switch (currentByteRead)
            {
                case DS1W_SKIPROM:
                {
                    current1WCommand = DS1W_SKIPROM;
                    lowLevelState = LL_READY_FOR_BITREAD;
                    highLevelState = HL_WAIT_FOR_2430_COMMAND;
                    current2430Command = DS2430_NONE;
                    currentByteRead = 0;
                    bitsLoaded = 0;
                    log.addLog("DS2430 Command DS1W_SKIPROM - ignored (ROM read not supported anyway)!", LogPanel.INFO);
                    break;
                }
                case DS1W_MATCHROM:
                {
                    current1WCommand = DS1W_MATCHROM;
                    current2430Command = DS2430_NONE;
                    lowLevelState = LL_READY_FOR_BITREAD;
                    highLevelState = HL_WAIT_FOR_1W_COMMAND;
                    currentByteRead = 0;
                    bitsLoaded = 0;
                    log.addLog("DS2430 Command DS1W_MATCHROM - not supported!", LogPanel.INFO);
                    break;
                }
                case DS1W_SEARCHROM:
                {
                    current1WCommand = DS1W_SEARCHROM;
                    current2430Command = DS2430_NONE;
                    lowLevelState = LL_READY_FOR_BITREAD;
                    highLevelState = HL_WAIT_FOR_1W_COMMAND;
                    currentByteRead = 0;
                    bitsLoaded = 0;
                    log.addLog("DS2430 Command DS1W_SEARCHROM - not supported!", LogPanel.INFO);
                    break;
                }
                case DS1W_READROM:
                {
                    current1WCommand = DS1W_READROM;
                    current2430Command = DS2430_NONE;
                    lowLevelState = LL_READY_FOR_BITREAD;
                    highLevelState = HL_WAIT_FOR_1W_COMMAND;
                    currentByteRead = 0;
                    bitsLoaded = 0;
                    log.addLog("DS2430 Command DS1W_READROM - not supported!", LogPanel.INFO);
                    break;
                }
                default:
                {
                    current1WCommand = DS1W_NOT_SUPPORTED;
                    break;
                }
            }
            
        }
        else if (highLevelState == HL_WAIT_FOR_2430_COMMAND)
        {
            switch (currentByteRead)
            {
                case DS2430_READMEM:
                {
                    current2430Command = DS2430_READMEM;
                    loadBytesFromDisk();
                    lowLevelState = LL_READY_FOR_BITREAD;
                    highLevelState = HL_WAIT_FOR_READ_ADDRESS;
                    currentByteRead = 0;
                    bitsLoaded = 0;
                    log.addLog("DS2430 Command DS2430_READMEM - accepted!", LogPanel.INFO);
                    break;
                }
                // read bytes from ds
                case DS2430_READSP:
                {
                    current2430Command = DS2430_READSP;
                    lowLevelState = LL_READY_FOR_BITREAD;
                    highLevelState = HL_WAIT_FOR_READ_ADDRESS;
                    currentByteRead = 0;
                    bitsLoaded = 0;
                    log.addLog("DS2430 Command DS2430_READSP - accepted!", LogPanel.INFO);
                    break;
                }
                // write bytes to ds
                case DS2430_WRITESP:
                {
                    isReadFromDS = true;
                    current2430Command = DS2430_WRITESP;
                    lowLevelState = LL_READY_FOR_BITREAD;
                    highLevelState = HL_WAIT_FOR_WRITE_ADDRESS;
                    currentByteRead = 0;
                    bitsLoaded = 0;
                    log.addLog("DS2430 Command DS2430_WRITESP - accepted!", LogPanel.INFO);
                    break;
                }

                case DS2430_COPYSP:
                {
                    current2430Command = DS2430_COPYSP;
                    saveBytestoDisk();
                    lowLevelState = LL_READY_FOR_BITREAD;
                    highLevelState = HL_WAIT_FOR_2430_COMMAND;
                    currentByteRead = 0;
                    bitsLoaded = 0;
                    log.addLog("DS2430 Command DS2430_COPYSP - accepted!", LogPanel.INFO);
                    break;
                }
                case DS2430_VALKEY:
                {
                    current2430Command = DS2430_VALKEY;
                    // do nothing, what is there to verify?
                    lowLevelState = LL_READY_FOR_BITREAD;
                    highLevelState = HL_WAIT_FOR_2430_COMMAND;
                    currentByteRead = 0;
                    bitsLoaded = 0;
                    log.addLog("DS2430 Command DS2430_VALKEY - accepted!", LogPanel.INFO);
                    break;
                }
                default:
                {
                    current2430Command = DS2430_NOT_SUPPORTED;
                    break;
                }
            }
        }
        else if (highLevelState == HL_WAIT_FOR_READ_ADDRESS)
        {
            currentOutputAddress = currentByteRead;
            log.addLog("DS2430 Command READ Address received!", LogPanel.INFO);
            initOutputNextByte();
        }
        else if (highLevelState == HL_READ_BYTE_FROM_SP)
        {
            log.addLog("DS2430 Continuing read from DS2430...", LogPanel.INFO);
            initOutputNextByte();
        }        

        else if (highLevelState == HL_WAIT_FOR_WRITE_ADDRESS)
        {
            currentInputAddress = currentByteRead;
            log.addLog("DS2430 Command WRITE Address received!", LogPanel.INFO);
            initInputNextByte();
        }
        else if (highLevelState == HL_WRITE_BYTE_TO_SP)
        {
            log.addLog("DS2430 Continuing write to DS2430...", LogPanel.INFO);
            epromData.data[currentInputAddress%MAX_DATA_LEN] = (byte) currentByteRead;
            currentInputAddress++;
                    
            initInputNextByte();
        }        
    }
    public static EpromData loadData(String serialname)
    {
        return (EpromData)CSAMainFrame.deserialize(serialname);
    }
    public static boolean saveData(String serialname, EpromData d)
    {
        return CSAMainFrame.serialize(d, serialname);
    }
    void loadBytesFromDisk()
    {
        epromData = loadData(getSaveName());
        if (epromData == null)
        {
            epromData = new EpromData();
        }
    }
    void saveBytestoDisk()
    {
        saveData(getSaveName(), epromData);
    }
    
    // output from DS2430 to VIA
    void initOutputNextByte()
    {
        highLevelState = HL_READ_BYTE_FROM_SP;
        currentByteOutput = epromData.data[currentOutputAddress%MAX_DATA_LEN];
        currentWriteByteComplete = currentByteOutput;
        bitsOutputDone = 0;
        currentOutputAddress++;
        lowLevelState = LL_WAIT_FOR_BITWRITE_PULSE_START;
        isReadFromDS = false;
    }
        

    // input from VIA to DS2430
    void initInputNextByte()
    {
        highLevelState = HL_WRITE_BYTE_TO_SP;
        bitsLoaded = 0;
        currentByteRead = 0;
        lowLevelState = LL_READY_FOR_BITREAD;
        isReadFromDS = true;
    }

    public String getSaveName()
    {
        return cart.cartName+".ds2430.ser";
    }

    public boolean isActive()
    {
        return highLevelState != HL_WAIT_FOR_1W_COMMAND;
    }

}

