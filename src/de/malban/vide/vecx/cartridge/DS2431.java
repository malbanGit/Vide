
package de.malban.vide.vecx.cartridge;

import de.malban.config.Configuration;
import de.malban.gui.CSAMainFrame;
import de.malban.gui.panels.LogPanel;
import java.io.File;
import java.io.Serializable;

// no overdrive emulation!
// no emulation of the ID code
// no protection of banks emulated

// main difference to DS2430
// a) 4 * 32 byte "banks"
// b) 16 byte as register/protection 
// c) addressing uses two bytes (TA1 / TA2)
// d) Authentification byte (E/S)
// e) READ SP actually gives first 3 address bytes, instead of reading adresses from master


/**
 *
 * @author malban
 * 
 * 
 * Emulation is only done in so far, that SP can be read and written,
 * this is no FULL emulation of a DS2431!
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

public class DS2431 implements Serializable
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
    public static final int HL_WAIT_FOR_2431_COMMAND = 1;
    public static final int HL_WAIT_FOR_READ_ADDRESSTA1 = 2;
    public static final int HL_WAIT_FOR_READ_ADDRESSTA2 = 3;
    public static final int HL_WAIT_FOR_WRITESP_ADDRESSTAES1 = 4;
    public static final int HL_WAIT_FOR_WRITESP_ADDRESSTAES2 = 5;
    public static final int HL_WAIT_FOR_WRITESP_ADDRESSTAES3 = 6;
    public static final int HL_WAIT_FOR_WRITESP_ADDRESSTAES4 = 7;
    public static final int HL_READ_BYTE_FROM_SP = 8;
    public static final int HL_WAIT_FOR_WRITE_ADDRESSTA1 = 9;
    public static final int HL_WAIT_FOR_WRITE_ADDRESSTA2 = 10;
    public static final int HL_WAIT_FOR_WRITE_ADDRESSTAES1 = 11;
    public static final int HL_WAIT_FOR_WRITE_ADDRESSTAES2 = 12;
    public static final int HL_WAIT_FOR_WRITE_ADDRESSTAES3 = 13;
    public static final int HL_WRITE_BYTE_TO_SP = 14;
    public static final int HL_SERIAL_1 = 15;
    public static final int HL_SERIAL_2 = 16;
    public static final int HL_SERIAL_3 = 17;
    public static final int HL_SERIAL_4 = 18;
    public static final int HL_SERIAL_5 = 19;
    public static final int HL_SERIAL_6 = 20;
    public static final int HL_SERIAL_7 = 21;
    public static final int HL_SERIAL_8 = 22;
    public static final int HL_SERIAL_END = 23;
    String[] hl_names = {
        "WAIT_FOR_1W_COMMAND",
        "WAIT_FOR_2431_COMMAND",
        "WAIT_FOR_READ_ADDRESSTA1",
        "WAIT_FOR_READ_ADDRESSTA2",
        "WAIT_FOR_WRITESP_ADDRESSTAES1",
        "WAIT_FOR_WRITESP_ADDRESSTAES2",
        "WAIT_FOR_WRITESP_ADDRESSTAES3",
        "WAIT_FOR_WRITESP_ADDRESSTAES4",
        "READ_BYTE_FROM_SP",
        "WAIT_FOR_WRITE_ADDRESSTA1",
        "WAIT_FOR_WRITE_ADDRESSTA2",
        "WAIT_FOR_WRITE_ADDRESSTAES1",
        "WAIT_FOR_WRITE_ADDRESSTAES2",
        "WAIT_FOR_WRITE_ADDRESSTAES3",
        "WRITE_BYTE_TO_SP",
        "HL_SERIAL_1",
        "HL_SERIAL_2",
        "HL_SERIAL_3",
        "HL_SERIAL_4",
        "HL_SERIAL_5",
        "HL_SERIAL_6",
        "HL_SERIAL_7",
        "HL_SERIAL_8",
        "HL_SERIAL_END"
    };
    
    // 1 Wire protocoll commands
    public static final int DS1W_NONE = 0x00;
    public static final int DS1W_SKIPROM = 0xcc;
    public static final int DS1W_MATCHROM = 0x55;
    public static final int DS1W_SEARCHROM = 0xf0;
    public static final int DS1W_READROM = 0x33;
    public static final int DS1W_NOT_SUPPORTED = -1;
    //public static final int DS1W_RESUME = 0xA5;
    //public static final int DS1W_OVERDRIVE_SKIP_ROM = 0x3C;
    //public static final int DS1W_OVERDRIVE_MATCH_ROM = 0x69;
    
    
    // DS2431 commands
    public static final int DS2431_NONE = 0x00;
    public static final int DS2431_READMEM = 0xf0;
    public static final int DS2431_WRITESP = 0x0f;
    public static final int DS2431_READSP = 0xaa;
    public static final int DS2431_COPYSP = 0x55;
    public static final int DS2431_VALKEY = 0xa5;
    public static final int DS2431_NOT_SUPPORTED = -1;
    
    
    
/*


; DS2431 Commands

DS2431_WRITESP  equ     $0f     ; Write bytes to Scratch Pad
DS2431_COPYSP   equ     $55     ; Copy entire Scratch Pad to EEPROM
DS2431_READSP   equ     $aa     ; Read bytes from Scratch Pad
DS2431_READMEM  equ     $f0     ; As READSP, but copies EEPROM to SP first

DS2431_LOCKAR   equ     $5a     ; Lock Application Register
DS2431_READSR   equ     $66     ; Read Status Register
DS2431_WRITEAR  equ     $99     ; Write bytes to Application Register
DS2431_READAR   equ     $c3     ; Read bytes from Application Register

DS2431_VALKEY   equ     $a5     ; Validation byte for COPYSP and LOCKAR

    
    */       
    int FAMILY_CODE = 0x2d; 
    public byte[] SERIAL_NUMBER = new byte[6]; // 48 bit
    int getCrc8()
    {
        int crc = 0;
        crc = oneCRC8Step(crc, FAMILY_CODE);
        crc = oneCRC8Step(crc, SERIAL_NUMBER[0]);
        crc = oneCRC8Step(crc, SERIAL_NUMBER[1]);
        crc = oneCRC8Step(crc, SERIAL_NUMBER[2]);
        crc = oneCRC8Step(crc, SERIAL_NUMBER[3]);
        crc = oneCRC8Step(crc, SERIAL_NUMBER[4]);
        crc = oneCRC8Step(crc, SERIAL_NUMBER[5]);
        return crc;
    }

    public long getSerial()
    {
        return SERIAL_NUMBER[0]+SERIAL_NUMBER[1]*256+SERIAL_NUMBER[2]*256*256+SERIAL_NUMBER[3]*256*256*256+SERIAL_NUMBER[4]*256*256*256*256+SERIAL_NUMBER[5]*256*256*256*256*256;
    }
    // CRC-8 (Dallas/Maxim 1-Wire Bus)    
    // X8 + X^5+ X^4+ 1 
    int CRC8_DALLAS_MSB = 0x31;//(1)00110001;
    int CRC8_DALLAS_LSB = 0x8c;//10001100(1);
   int oneCRC8Step(int crc, int data)
   {
        int i;

        crc = crc ^ data;
        for (i = 0; i < 8; i++)
        {
            if ((crc & 0x01) == 0x01)
                crc = (crc >> 1) ^ CRC8_DALLAS_LSB;
            else
                crc >>= 1;
        }

        return crc;
    }    
    public int getTA1()
    {
        return TA1;
    }
    public int getTA2()
    {
        return TA2;
    }
    public int getES()
    {
        return ES;
    }
    public int getCurrentOutValue()
    {
        return currentWriteByteComplete;
    }
    public void setIDByte1(int id)
    {
        epromData.data[0x86] = (byte) (id & 0xff);
    }
    public void setIDByte2(int id)
    {
        epromData.data[0x87] = (byte) (id & 0xff);
    }
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
    public void init()
    {
        if (log == null)
            log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
    }

    public String get2431CommandName()
    {
        if (current2431Command == DS2431_NONE) return "NONE";
        if (current2431Command == DS2431_READMEM) return "READMEM";
        if (current2431Command == DS2431_WRITESP) return "WRITESP";
        if (current2431Command == DS2431_READSP) return "READSP";
        if (current2431Command == DS2431_COPYSP) return "COPYSP";
        if (current2431Command == DS2431_VALKEY) return "VALKEY";
        return "NOT SUPPORTED ($"+String.format("$%02X", (current2431Command&0xff) )+")";
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

    
        
    
    public static final int MAX_DATA_LEN = 128+16;
    
    public transient Cartridge cart;
    
    static class EpromData implements Serializable
    {
        byte[] data = new byte[MAX_DATA_LEN];
        
        EpromData()
        {
            // Asteroids eEprom Data
            int[] ast= 
            {
                0x40, 0x60, 0x48, 0x00, 0x00, 0x8f, 0x18, 0x34, 0xd1, 0xed, 0x04, 0x00, 0x00, 0x0e, 0x53, 0x03,
                0x00, 0x00, 0x1c, 0xaf, 0x02, 0x00, 0x00, 0x24, 0x2e, 0x01, 0x00, 0x00, 0xd1, 0xed, 0x04, 0x00,
                0x00, 0x0e, 0x53, 0x03, 0x00, 0x00, 0x1c, 0xaf, 0x02, 0x00, 0x00, 0x24, 0x2e, 0x01, 0x00, 0x00,
                0xd1, 0xed, 0x04, 0x00, 0x00, 0x0e, 0x53, 0x03, 0x00, 0x00, 0x1c, 0xaf, 0x02, 0x00, 0x00, 0x24,
                0x2e, 0x01, 0x00, 0x00, 0xd1, 0xed, 0x04, 0x00, 0x00, 0x0e, 0x53, 0x03, 0x00, 0x00, 0x1c, 0xaf,
                0x02, 0x00, 0x00, 0x24, 0x2e, 0x01, 0x00, 0x00, 0x58, 0xa3, 0x00, 0x50, 0x00, 0x52, 0x58, 0x00,
                0x20, 0x00, 0xd1, 0xed, 0x04, 0x00, 0x00, 0x0e, 0x53, 0x03, 0x00, 0x00, 0x1c, 0xaf, 0x02, 0x00,
                0x00, 0x24, 0x2e, 0x01, 0x00, 0x00, 0x58, 0xa3, 0x00, 0x50, 0x00, 0x52, 0x58, 0x00, 0x20, 0x00
            };
            for (int i=0; i<0x80;i++)
            {
                data[i] = (byte) (ast[i] & 0x0ff);
            }
            
        }
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
    int current2431Command = DS2431_NONE;
    long dif = 0;
    int currentWriteByteComplete = 0;
    int currentWriteByteCompleteAddress = 0xff;
    
    boolean isReadFromDS = false;

    
    int TA1 = 0;
    int TA2 = 0;
    int ES = 0; // AA 00 PF 00 00 E2 E1 E0
    
    
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
        current2431Command = DS2431_NONE;
        dif = 0;
        currentWriteByteComplete = 0;
        isReadFromDS = false;

    }
    public DS2431(Cartridge c)
    {
        cart = c;
        
        SERIAL_NUMBER[0] = 0x3b;
        SERIAL_NUMBER[1] = 0x50;
        SERIAL_NUMBER[2] = 0x43;
        SERIAL_NUMBER[3] = 0x14;
        SERIAL_NUMBER[4] = 0x00;
        SERIAL_NUMBER[5] = 0x00;
        
        
        // Serial Asteroids from Thomas #2
        SERIAL_NUMBER[0] = 0x60;
        SERIAL_NUMBER[1] =(byte) 0x9e;
        SERIAL_NUMBER[2] = 0x7f;
        SERIAL_NUMBER[3] = 0x15;
        SERIAL_NUMBER[4] = 0x00;
        SERIAL_NUMBER[5] = 0x00;
        
        
        
    }
    public DS2431 clone()
    {
        DS2431 c = new DS2431(cart);
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
        c.current2431Command = current2431Command;
        
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
                log.addLog("DS2431 Reset sequence 1) - start!", LogPanel.INFO);
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
                    log.addLog("DS2431 write byte pulse started!", LogPanel.INFO);
                }
                break;
            }
            case LL_WAIT_FOR_BITWRITE_PULSE_END:
            {
                if (line)
                {
                    lowLevelState = LL_WAIT_FOR_BITWRITE_FINISH;
                    log.addLog("DS2431 write bit pulse ended, starting bit out...!", LogPanel.INFO);

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
                        log.addLog("DS2431 Write bit timeslot done (1)!", LogPanel.INFO);
                    }
                    else
                    {
                        log.addLog("DS2431 Write bit timeslot done (0)!", LogPanel.INFO);
                    }
                    if (bitsOutputDone == 8)
                    {
                        log.addLog("DS2431 Write completed: "+String.format("$%02X", currentWriteByteCompleteAddress )+"->"+String.format("$%02X", currentWriteByteComplete ), LogPanel.INFO);
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
                    log.addLog("DS2431 Read command 1) - bit start!", LogPanel.INFO);
                }
                break;
            }
            case LL_READY_FOR_BITREAD_CONTINUE:
            {
                if (!line)
                {
                    lowLevelState = LL_BITREAD_STARTED;
                    log.addLog("DS2431 Read command 1b) - bit start!", LogPanel.INFO);
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
                        log.addLog("DS2431 Read command 2) - load 1!", LogPanel.INFO);
                    }
                    else
                    {
                        currentByteRead+=0;
                        log.addLog("DS2431 Read command 2) - load 0!", LogPanel.INFO);
                    }
                    lowLevelState = LL_READY_FOR_BITREAD_CONTINUE;
                    bitsLoaded++;
                    if (bitsLoaded == 8)
                    {
                        log.addLog("DS2431 Read command 3) - loaded: "+String.format("$%02X", currentByteRead ), LogPanel.INFO);
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
                    log.addLog("DS2431 Reset sequence 2) - reset!", LogPanel.INFO);
                }
                break;
            }
            case LL_RESETED:
            {
                if (dif > WAIT_TO_GO_LOW_AFTER_RESET_CYCLES)
                {
                    lowLevelState = LL_PULSE_GENERATION;
                    lineOut(false);
                    log.addLog("DS2431 Reset sequence 3) - pulse start!", LogPanel.INFO);
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
                    log.addLog("DS2431 Reset sequence 4) - pulse end!", LogPanel.INFO);
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
                    highLevelState = HL_WAIT_FOR_2431_COMMAND;
                    current2431Command = DS2431_NONE;
                    currentByteRead = 0;
                    bitsLoaded = 0;
                    log.addLog("DS2431 Command DS1W_SKIPROM - ignored (ROM read not supported anyway)! ("+cart.getPC()+")", LogPanel.INFO);
                    break;
                }
                case DS1W_MATCHROM:
                {
                    current1WCommand = DS1W_MATCHROM;
                    current2431Command = DS2431_NONE;
                    lowLevelState = LL_READY_FOR_BITREAD;
                    highLevelState = HL_WAIT_FOR_1W_COMMAND;
                    currentByteRead = 0;
                    bitsLoaded = 0;
                    log.addLog("DS2431 Command DS1W_MATCHROM - not supported! ("+cart.getPC()+")", LogPanel.INFO);
                    break;
                }
                case DS1W_SEARCHROM:
                {
                    current1WCommand = DS1W_SEARCHROM;
                    current2431Command = DS2431_NONE;
                    lowLevelState = LL_READY_FOR_BITREAD;
                    highLevelState = HL_WAIT_FOR_1W_COMMAND;
                    currentByteRead = 0;
                    bitsLoaded = 0;
                    log.addLog("DS2431 Command DS1W_SEARCHROM - not supported! ("+cart.getPC()+")", LogPanel.INFO);
                    break;
                }
                case DS1W_READROM:
                {
                    current1WCommand = DS1W_READROM;
                    current2431Command = DS2431_NONE;

                    highLevelState = HL_SERIAL_2;
                    currentByteOutput = FAMILY_CODE;
                    currentWriteByteComplete = FAMILY_CODE;
                    currentWriteByteCompleteAddress = 0xff;
                    bitsOutputDone = 0;
                    lowLevelState = LL_WAIT_FOR_BITWRITE_PULSE_START;
                    isReadFromDS = false;
                    
                    
                    log.addLog("DS2431 Command DS1W_READROM! ("+cart.getPC()+")", LogPanel.INFO);
                    break;
                }
                default:
                {
                    current1WCommand = DS1W_NOT_SUPPORTED;
                    break;
                }
            }
            
        }
        else if (highLevelState == HL_SERIAL_1)
        {
            log.addLog("1W Command READROM 1. byte!", LogPanel.INFO);
            
            
            highLevelState = HL_SERIAL_2;
            currentByteOutput = FAMILY_CODE;
            currentWriteByteComplete = FAMILY_CODE;
            bitsOutputDone = 0;
            lowLevelState = LL_WAIT_FOR_BITWRITE_PULSE_START;
            isReadFromDS = false;
        }
        else if (highLevelState == HL_SERIAL_2)
        {
            log.addLog("1W Command READROM 2. byte!", LogPanel.INFO);
            highLevelState = HL_SERIAL_3;
            currentByteOutput = SERIAL_NUMBER[0];
            currentWriteByteComplete = SERIAL_NUMBER[0];
            bitsOutputDone = 0;
            lowLevelState = LL_WAIT_FOR_BITWRITE_PULSE_START;
            isReadFromDS = false;
        }
        else if (highLevelState == HL_SERIAL_3)
        {
            log.addLog("1W Command READROM 3. byte!", LogPanel.INFO);
            highLevelState = HL_SERIAL_4;
            currentByteOutput = SERIAL_NUMBER[1];
            currentWriteByteComplete = SERIAL_NUMBER[1];
            bitsOutputDone = 0;
            lowLevelState = LL_WAIT_FOR_BITWRITE_PULSE_START;
            isReadFromDS = false;
        }
        else if (highLevelState == HL_SERIAL_4)
        {
            log.addLog("1W Command READROM 4. byte!", LogPanel.INFO);
            highLevelState = HL_SERIAL_5;
            currentByteOutput = SERIAL_NUMBER[2];
            currentWriteByteComplete = SERIAL_NUMBER[2];
            bitsOutputDone = 0;
            lowLevelState = LL_WAIT_FOR_BITWRITE_PULSE_START;
            isReadFromDS = false;
        }
        else if (highLevelState == HL_SERIAL_5)
        {
            log.addLog("1W Command READROM 4. byte!", LogPanel.INFO);
            highLevelState = HL_SERIAL_6;
            currentByteOutput = SERIAL_NUMBER[3];
            currentWriteByteComplete = SERIAL_NUMBER[3];
            bitsOutputDone = 0;
            lowLevelState = LL_WAIT_FOR_BITWRITE_PULSE_START;
            isReadFromDS = false;
        }
        else if (highLevelState == HL_SERIAL_6)
        {
            log.addLog("1W Command READROM 6. byte!", LogPanel.INFO);
            highLevelState = HL_SERIAL_7;
            currentByteOutput = SERIAL_NUMBER[4];
            currentWriteByteComplete = SERIAL_NUMBER[4];
            bitsOutputDone = 0;
            lowLevelState = LL_WAIT_FOR_BITWRITE_PULSE_START;
            isReadFromDS = false;
        }
        else if (highLevelState == HL_SERIAL_7)
        {
            log.addLog("1W Command READROM 7. byte!", LogPanel.INFO);
            highLevelState = HL_SERIAL_8;
            currentByteOutput = SERIAL_NUMBER[5];
            currentWriteByteComplete = SERIAL_NUMBER[5];
            bitsOutputDone = 0;
            lowLevelState = LL_WAIT_FOR_BITWRITE_PULSE_START;
            isReadFromDS = false;
        }
        else if (highLevelState == HL_SERIAL_8)
        {
            log.addLog("1W Command READROM 8. byte!", LogPanel.INFO);
            highLevelState = HL_SERIAL_END;
            currentByteOutput = getCrc8();
            currentWriteByteComplete = currentByteOutput;
            bitsOutputDone = 0;
            lowLevelState = LL_WAIT_FOR_BITWRITE_PULSE_START;
            isReadFromDS = false;
        }
        else if (highLevelState == HL_SERIAL_END)
        {
            current1WCommand = DS1W_READROM;
            current2431Command = DS2431_NONE;
            lowLevelState = LL_READY_FOR_BITREAD;
            highLevelState = HL_WAIT_FOR_2431_COMMAND;
            currentByteRead = 0;
            bitsLoaded = 0;
            
            log.addLog("DS2431 Command READROM - finished!", LogPanel.INFO);
        }
        
        else if (highLevelState == HL_WAIT_FOR_2431_COMMAND)
        {
            switch (currentByteRead)
            {
                case DS2431_READMEM:
                {
                    current2431Command = DS2431_READMEM;
                    loadBytesFromDisk();
                    lowLevelState = LL_READY_FOR_BITREAD;
                    highLevelState = HL_WAIT_FOR_READ_ADDRESSTA1;
                    
                    currentByteRead = 0;
                    bitsLoaded = 0;
                    log.addLog("DS2431 Command DS2431_READMEM - accepted! ("+cart.getPC()+")", LogPanel.INFO);
                    break;
                }
                // read bytes from ds
                case DS2431_READSP:
                {
                    current2431Command = DS2431_READSP;
                    log.addLog("DS2431 Command DS2431_READSP - accepted! ("+cart.getPC()+")", LogPanel.INFO);
                    highLevelState = HL_WAIT_FOR_WRITESP_ADDRESSTAES2;
                    lowLevelState = LL_WAIT_FOR_BITWRITE_PULSE_START;

                    currentByteOutput = TA1;
                    currentWriteByteComplete = TA1;
                    currentWriteByteCompleteAddress = 0xff;

                    bitsOutputDone = 0;
                    isReadFromDS = false;        
                    break;
                }
                // write bytes to ds
                case DS2431_WRITESP:
                {
                    isReadFromDS = true;
                    current2431Command = DS2431_WRITESP;
                    lowLevelState = LL_READY_FOR_BITREAD;
                    highLevelState = HL_WAIT_FOR_WRITE_ADDRESSTA1;
                    currentByteRead = 0;
                    bitsLoaded = 0;
                    log.addLog("DS2431 Command DS2431_WRITESP - accepted! ("+cart.getPC()+")", LogPanel.INFO);
                    break;
                }

                case DS2431_COPYSP:
                {
                    current2431Command = DS2431_COPYSP;
                    lowLevelState = LL_READY_FOR_BITREAD;
                    highLevelState = HL_WAIT_FOR_WRITE_ADDRESSTAES1;
                    currentByteRead = 0;
                    bitsLoaded = 0;
                    
                    log.addLog("DS2431 Command DS2431_COPYSP - accepted! ("+cart.getPC()+")", LogPanel.INFO);
                    break;
                }
                case DS2431_VALKEY:
                {
                    current2431Command = DS2431_VALKEY;
                    // do nothing, what is there to verify?
                    lowLevelState = LL_READY_FOR_BITREAD;
                    highLevelState = HL_WAIT_FOR_2431_COMMAND;
                    currentByteRead = 0;
                    bitsLoaded = 0;
                    log.addLog("DS2431 Command DS2431_VALKEY - accepted! ("+cart.getPC()+")", LogPanel.INFO);
                    break;
                }
                default:
                {
                    current2431Command = DS2431_NOT_SUPPORTED;
                    break;
                }
            }
        }
        else if (highLevelState == HL_WAIT_FOR_READ_ADDRESSTA1)
        {
            TA1 = currentByteRead;
            log.addLog("DS2431 Command READ TA1 Address received!", LogPanel.INFO);
            
                    current2431Command = DS2431_READSP;
                    lowLevelState = LL_READY_FOR_BITREAD;
                    highLevelState = HL_WAIT_FOR_READ_ADDRESSTA2;
                    currentByteRead = 0;
                    bitsLoaded = 0;
            
        }
        else if (highLevelState == HL_WAIT_FOR_READ_ADDRESSTA2)
        {
            TA2 = currentByteRead;
            currentOutputAddress = TA1+256*TA2;
            log.addLog("DS2431 Command READ TA2 Address received!", LogPanel.INFO);
            
            if (current2431Command == DS2431_READMEM)
            {
                initOutputNextByte();
            }
            else
            {
                initOutputNextByte();
            }
        }
        else if (highLevelState == HL_WAIT_FOR_WRITESP_ADDRESSTAES1)
        {
            // not used
            highLevelState = HL_WAIT_FOR_WRITESP_ADDRESSTAES2;
            currentByteOutput = TA1;
            currentWriteByteComplete = TA1;
            currentWriteByteCompleteAddress = 0xff;

            bitsOutputDone = 0;
            lowLevelState = LL_WAIT_FOR_BITWRITE_PULSE_START;
            isReadFromDS = false;
                    
                    
            log.addLog("DS2431 Command WRITE TA1 Address started!", LogPanel.INFO);
                    
        }
        else if (highLevelState == HL_WAIT_FOR_WRITESP_ADDRESSTAES2)
        {
            log.addLog("TA1 Address written:" +String.format("$%02X", currentWriteByteComplete ), LogPanel.INFO);
            highLevelState = HL_WAIT_FOR_WRITESP_ADDRESSTAES3;
            currentByteOutput = TA2;
            currentWriteByteComplete = TA2;
            currentWriteByteCompleteAddress = 0xff;

            bitsOutputDone = 0;
            lowLevelState = LL_WAIT_FOR_BITWRITE_PULSE_START;
            isReadFromDS = false;
            
            log.addLog("DS2431 Command WRITE TA2 Address started!", LogPanel.INFO);
            
        }
        else if (highLevelState == HL_WAIT_FOR_WRITESP_ADDRESSTAES3)
        {
            log.addLog("TA2 Address written:" +String.format("$%02X", currentWriteByteComplete ), LogPanel.INFO);
            highLevelState = HL_WAIT_FOR_WRITESP_ADDRESSTAES4;
            currentByteOutput = ES;
            currentWriteByteComplete = ES;
            currentWriteByteCompleteAddress = 0xff;

            bitsOutputDone = 0;
            lowLevelState = LL_WAIT_FOR_BITWRITE_PULSE_START;
            isReadFromDS = false;
            log.addLog("DS2431 Command WRITE ES Address started!", LogPanel.INFO);

        }
        else if (highLevelState == HL_WAIT_FOR_WRITESP_ADDRESSTAES4)
        {
            log.addLog("ES Address written:" +String.format("$%02X", currentWriteByteComplete ), LogPanel.INFO);
            currentOutputAddress = TA1+256*TA2;
            log.addLog("DS2431 Continuing read from DS2431...", LogPanel.INFO);
            initOutputNextByte();
        }
        else if (highLevelState == HL_READ_BYTE_FROM_SP)
        {
            log.addLog("DS2431 Continuing read from DS2431...", LogPanel.INFO);
            initOutputNextByte();
        }        

        else if (highLevelState == HL_WAIT_FOR_WRITE_ADDRESSTA1)
        {
            TA1 = currentByteRead;
            isReadFromDS = true;
            current2431Command = DS2431_WRITESP;
            lowLevelState = LL_READY_FOR_BITREAD;
            highLevelState = HL_WAIT_FOR_WRITE_ADDRESSTA2;
            currentByteRead = 0;
            bitsLoaded = 0;
            log.addLog("DS2431 Command WRITE Address TA1 received!", LogPanel.INFO);
        }
        else if (highLevelState == HL_WAIT_FOR_WRITE_ADDRESSTA2)
        {
            TA2 = currentByteRead;
            currentInputAddress = TA1+256*TA2;
            log.addLog("DS2431 Command WRITE Address TA2 received!", LogPanel.INFO);
            initInputNextByte();
        }
        else if (highLevelState == HL_WAIT_FOR_WRITE_ADDRESSTAES1)
        {
            TA1 = currentByteRead;
            isReadFromDS = true;
            lowLevelState = LL_READY_FOR_BITREAD;
            highLevelState = HL_WAIT_FOR_WRITE_ADDRESSTAES2;
            currentByteRead = 0;
            bitsLoaded = 0;
            log.addLog("DS2431 Command WRITE Address TA1 received!", LogPanel.INFO);
        }
        else if (highLevelState == HL_WAIT_FOR_WRITE_ADDRESSTAES2)
        {
            
            TA2 = currentByteRead;
            currentInputAddress = TA1+256*TA2;
            isReadFromDS = true;
            lowLevelState = LL_READY_FOR_BITREAD;
            highLevelState = HL_WAIT_FOR_WRITE_ADDRESSTAES3;
            currentByteRead = 0;
            bitsLoaded = 0;
            log.addLog("DS2431 Command WRITE Address TA2 received!", LogPanel.INFO);
        }
        else if (highLevelState == HL_WAIT_FOR_WRITE_ADDRESSTAES3)
        {
            // ignoring the actual SP addresses that are saved (TAx) but always saving everything
            ES = currentByteRead;
            log.addLog("DS2431 Command WRITE Address ES received!", LogPanel.INFO);
            if (current2431Command == DS2431_COPYSP) 
            {
                highLevelState = HL_WAIT_FOR_2431_COMMAND;
                saveBytestoDisk();
                log.addLog("Scratchpad DS2431 saved to disk!", LogPanel.INFO);
            }
            else
                initInputNextByte();
        }
        else if (highLevelState == HL_WRITE_BYTE_TO_SP)
        {
            log.addLog("DS2431 Continuing write to DS2431..., byte written "+String.format("$%02X", currentByteRead )+"->"+String.format("$%02X", currentInputAddress ), LogPanel.INFO);
            
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
    
    // output from DS2431 to VIA
    void initOutputNextByte()
    {
        highLevelState = HL_READ_BYTE_FROM_SP;
        currentByteOutput = epromData.data[currentOutputAddress%MAX_DATA_LEN];
        currentWriteByteComplete = currentByteOutput;
        currentWriteByteCompleteAddress = currentOutputAddress%MAX_DATA_LEN;

        bitsOutputDone = 0;
        currentOutputAddress++;
        lowLevelState = LL_WAIT_FOR_BITWRITE_PULSE_START;
        isReadFromDS = false;
    }
        

    // input from VIA to DS2431
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
        return cart.cartName+".ds2431.ser";
    }

    public boolean isActive()
    {
        return highLevelState != HL_WAIT_FOR_1W_COMMAND;
    }

}

