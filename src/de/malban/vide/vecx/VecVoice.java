/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx;

import de.malban.config.Configuration;
import de.malban.gui.panels.LogPanel;
import static de.malban.gui.panels.LogPanel.INFO;
import de.malban.sound.tinysound.internal.MemSound;

/* Examinig the VecVox driver routines from alex herbert following guesses are made:

- vecVox communicates via two different "lines":
  a) bit 5 of PSG PortA (this bit can be read as "usual" e.g. as a button state)
  b) bit 4 of PSG PortA, this bit is used to OUTPUT data to vecVox
- There is a init routine, which masks bit 4 as zero and all other bits 1 one
  for output of PSG port A
- it seems, that this state of "output portA" is kept internally in the PSG, regardless
  of what is done in "input mode" to portA, once portA is switched to output, that
  mask seems to be "restored" and used
- the routines of alex which do the serial communication (btw 8n1 9600 baud) SEEM
  to only use the enable register for porta (bit 6 of register 7)
- my guess is by ENABLING output of PortA a "zero" is sent to vecvox
- and by DISABLING output of PortA a "one" is sent to vecvox
- (if the "output button mask" which is set on initialization is intact)
- thus all communication is seemingly done by register 7 bit 6
- but all datasheets and schemetics indicate that there is NO direct connection to any joystick port
- to me, at the moment above guesses are the only explanation....


*/


/**
 *
 * @author malban
 */
public class VecVoice implements PortAdapter
{
    transient LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
    transient E8910 e8910;

    private static int UID_C = 0;
    private final int UID = UID_C++;
    
    static final int LINE_OFFLINE=0;
    static final int LINE_WAIT_FOR_START_BIT=1;
    static final int LINE_WAIT_FOR_START_BIT_END = 2;
    static final int LINE_RECEIVING_BITS=3;
    static final int LINE_READ_NEXT_BYTE_BIT = 4;
    static final int LINE_WAIT_FOR_STOP_BIT = 5;
    
    static final int BAUD_IN_CYCLES = 156; // 156 cycles = 9615 baud
    // get the data that is transfered not at the END of the time range, but in the middle!
    static final int MID_BAUD_IN_CYCLES = BAUD_IN_CYCLES/2; 
    
    int lowLevelState = LINE_OFFLINE;
    long cycles = 0;
    long receiveCycleStart = 0;
    boolean dataLineInput = true; // false is 0, true is 1; bit 4 of snd_reg[14]
    boolean old_dataLineInput = true;
    
    int currentByteRead = 0;
    int bitsLoaded = 0;
    boolean inputMode = true;
    MemSound lastSample = null;
    
    boolean midBaudSet = false;
    boolean midBaudValue = false;
    
    int VECVOICE_PORT = 2;
    public static transient int STATUS_LINE_MASK_PORT2 = 0x20;
    public static transient int DATA_LINE_MASK_PORT2 = 0x10;
    
    // only for cloning!
    private VecVoice()
    {
        
    }
    public VecVoice(E8910 e)
    {
        VecVoiceSamples.loadSamples();
        e8910 = e;
        e8910.setPortAdapter(this);
    }
    public VecVoice clone()
    {
        VecVoice vv = new VecVoice();
        vv.currentByteRead = currentByteRead;
        vv.bitsLoaded = bitsLoaded;
        vv.inputMode = inputMode;
        vv.cycles = cycles;
        vv.dataLineInput = dataLineInput;
        vv.old_dataLineInput = old_dataLineInput;
        vv.receiveCycleStart = receiveCycleStart;
        
        vv.lastSample = lastSample; // no deep copy here actually we could also set to null!
        return vv;
    }
    void initClone(E8910 e)
    {
        e8910 = e;
        e8910.setPortAdapter(this);
    }
    
/*    
    // receiving line information from the emulator (Joy)
    public int readDataFromPort()
    {
        return e8910.snd_regs[14];
    }
*/
    
    // sending line information to the emulator (Joy)
    public int getWriteDataToPort(int portAOrg)
    {
        int value = portAOrg;
        if (!inputMode) return value;
        
        if (VECVOICE_PORT == 2)
        {
            // button state is "inverse": 0 = ready
            if (!isReady())
            {
                value = value | STATUS_LINE_MASK_PORT2;
            }
            else
            {
                value = value & (0xff - STATUS_LINE_MASK_PORT2);
            }
            if (!dataLineInput)
            {
                value = value | DATA_LINE_MASK_PORT2;
            }
            else
            {
                value = value & (0xff - DATA_LINE_MASK_PORT2);
            }
        }

        return value;
    }
    public void valueChangedFromPSG()
    {
        if (inputMode) return;
        if (VECVOICE_PORT == 2) 
            dataLineInput = (e8910.snd_regs[14] & DATA_LINE_MASK_PORT2) == DATA_LINE_MASK_PORT2;
    }
    
    // if i== true
    // than input enabled
    // input mode enabled means
    // vecvoice can WRITE to the port
    // and vectrex (over PSG) can read port
    public void setInputMode(boolean i)
    {
        if (inputMode == i) return;
        inputMode = i;
        if (!inputMode) 
        {
            // for alex herberts driver
            // due to only one input mask
            // this should always be false!
            dataLineInput = (e8910.snd_regs[14] & DATA_LINE_MASK_PORT2) == DATA_LINE_MASK_PORT2;
        }
        else
        {
            // it seems, that when PSG is in input mode
            // than the port "output" is allways $ff
            dataLineInput = true;
        }
    }

    
    // low level step
    // this is triggered with every cycle from the emulator
    // c is the current cylce counter of the vecx emulator, needed for timing
    // (since I don't trust that we are called each cycle :-) )
    public void step(long c)
    {
        // I think we only receive data (apart from status line)
        long dif = c - cycles;
        if (lowLevelState<=LINE_WAIT_FOR_START_BIT_END)
        {
            if (dataLineInput != old_dataLineInput)
            {
                // reset cycle count on line changes (which are triggered from the outside)
                cycles = c;
            }
        }

        switch (lowLevelState)
        {
            case LINE_OFFLINE:
            {
                lowLevelState = LINE_WAIT_FOR_START_BIT;
                cycles = c;
                log.addLog("VecVoice: Offline -> wait for startbit ", INFO);
                break;
            }
            case LINE_WAIT_FOR_START_BIT:
            {
                // startbit MUST be 0
                if (!dataLineInput)
                {
                    
                    log.addLog("VecVoice: Offline -> startbit started", INFO);
                    lowLevelState = LINE_WAIT_FOR_START_BIT_END;
                    if (old_dataLineInput)
                    {
                        cycles = c;
                    }
                    midBaudSet = false;
                }
                break;
            }
            
            case LINE_WAIT_FOR_START_BIT_END:
            {
                if (dif >MID_BAUD_IN_CYCLES)
                {
                    if (!midBaudSet)
                    {
                        midBaudSet = true;
                        midBaudValue = dataLineInput;
                    }
                }
                
                if (dif >=BAUD_IN_CYCLES)
                {
                    // got a bit 0 as startbit in a correct timeframe
                    if (!midBaudValue)
                    {
                        log.addLog("VecVoice: startbit received, waiting for byte data ", INFO);
                        midBaudSet = false;
                        bitsLoaded = 0;
                        currentByteRead = 0;
                        lowLevelState = LINE_READ_NEXT_BYTE_BIT;
                        cycles = c;
                    }
                    else
                    {
                        midBaudSet = false;
                        lowLevelState = LINE_WAIT_FOR_START_BIT;
                        log.addLog("VecVoice: startbit broken, waiting again ", INFO);
                    }
                    
                }
                break;
            }
            case LINE_READ_NEXT_BYTE_BIT:
            {
                if (dif >MID_BAUD_IN_CYCLES)
                {
                    if (!midBaudSet)
                    {
                        midBaudSet = true;
                        midBaudValue = dataLineInput;
                    }
                }
                if (dif >=BAUD_IN_CYCLES)
                {
                    // LSB first
                    currentByteRead = currentByteRead>>1;
                    if (midBaudValue)
                    {
                        currentByteRead +=128;
                        log.addLog("VecVoice: Byte receiving (bit: "+bitsLoaded+" = "+1+")", INFO);
                    }
                    else
                    {
                        log.addLog("VecVoice: Byte receiving (bit: "+bitsLoaded+" = "+0+")", INFO);
                    }
                    bitsLoaded++;
                    cycles = c;
                    midBaudSet = false;
                    if (bitsLoaded == 8)
                    {
                        midBaudSet = false;
                        lowLevelState = LINE_WAIT_FOR_STOP_BIT;
                        log.addLog("VecVoice: Byte received, waiting for stop bit", INFO);
                    }
                }
                break;
            }
            case LINE_WAIT_FOR_STOP_BIT:
            {
                midBaudSet = false;
                if (dataLineInput)
                {
                    lowLevelState = LINE_OFFLINE;
                    cycles = c;
                    log.addLog("VecVoice: stop bit received", INFO);
                    log.addLog("VecVoice: completely received: "+currentByteRead+" (going offline)", INFO);
                    finalizeByteRead();
                }
                else if (dif >=BAUD_IN_CYCLES)
                {
                    lowLevelState = LINE_OFFLINE;
                    cycles = c;
                    log.addLog("VecVoice: stop bit not received (going offline)", INFO);
                }
                break;
            }
            default:
            {
                break;
            }
        }
        old_dataLineInput = dataLineInput;
    }
    boolean isReady()
    {
        if (lastSample == null) return true;
        int pos = lastSample.getPosition();
        if (pos>=lastSample.getLeftData().length) return true;
        if (pos <0) return true;
        return false;
    }
    
    void finalizeByteRead()
    {
        log.addLog("VecVoice: byte received: " + currentByteRead, INFO);
        addCommand(currentByteRead);
    }

    // todo
    // a) fill buffer with commands
    // b) build a vecVoice stream
    // c) execute commands on to be played samples (conversion)
    // d) add to stream all samples/pauses
    //
    boolean verzerk = true;
    void addCommand(int c)
    {
        if (verzerk)
        {
            c = mapVerzerkToSpeakJet(c);
        }
        if (lastSample!=null)
            lastSample.stop();
        lastSample = VecVoiceSamples.playSample(c);    
    }
    
    int mapVerzerkToSpeakJet(int in)
    {
        if (in == 0) return 1; // PA1 
        if (in == 1) return 2; // PA2
        if (in == 2) return 3; // PA3
        if (in == 3) return 4; // PA4
        if (in == 4) return 5; // PA5
        if (in == 5) return 156; // OY - OHIY
        if (in == 6) return 157; // AY - OHIH
        if (in == 7) return 131; // EH - EH
        if (in == 8) return 195; // KK3 - KO
        if (in == 9) return 199; // PP - PO
        if (in == 10)return 165; // JH - JH
        if (in == 11)return 141; // NN1 - NE
        if (in == 12)return 129; // IH - IH
        if (in == 13)return 192; // TT2 - TU
        if (in == 14)return 148; // RR1 - RR
        if (in == 15)return 133; // AX - AX
        if (in == 16)return 140; // MM - MM 
        if (in == 17)return 191; // TT1 - TT
        if (in == 18)return 169; // DH1 - DH 
        if (in == 19)return 128; // IY - IY 
        if (in == 20)return 130; // EY - EY
        if (in == 21)return 176; // DD1 - ED 
        if (in == 22)return 138; // UW1 - UH
        if (in == 23)return 133; // AO - AX 
        if (in == 24)return 135; // AA - OH
        if (in == 25)return 158; // YY2 - IYEH 
        if (in == 26)return 132; // AE - AY
        if (in == 27)return 183; // HH1 - HE
        if (in == 28)return 170; // BB1 - BE
        if (in == 29)return 190; // TH - TH
        if (in == 30)return 138; // UH - UH
        if (in == 31)return 139; // UW2 - UW
        if (in == 32)return 136; // AW - AW 
        if (in == 33)return 175; // DD2 - DO
        if (in == 34)return 180; // GG3 - EG
        if (in == 35)return 166; // VV - VV
        if (in == 36)return 179; // GG1 - GO
        if (in == 37)return 189; // SH - SH
        if (in == 38)return 168; // ZH - ZH
        if (in == 39)return 148; // RR2 - RR
        if (in == 40)return 186; // FF - FF 
        if (in == 41)return 195; // KK2 - KO
        if (in == 42)return 194; // KK1 - KE
        if (in == 43)return 167; // ZZ - ZZ
        if (in == 44)return 143; // NG - NGE 
        if (in == 45)return 145; // LL - LE
        if (in == 46)return 147; // WW - WW 
        if (in == 47)return 150; // XR - EYRR
        if (in == 48)return 185; // WH - WH
        if (in == 49)return 158; // YY1 - IYEH
        if (in == 50)return 182; // CH - CH
        if (in == 51)return 151; // ER1 - AXRR
        if (in == 52)return 151; // ER2 - AXRR
        if (in == 53)return 137; // OW - OW
        if (in == 54)return 169; // DH2 - DH
        if (in == 55)return 187; // SS - SE 
        if (in == 56)return 142; // NN2 - NO
        if (in == 57)return 184; // HH2 - HO 
        if (in == 58)return 153; // OR - OWRR
        if (in == 59)return 152; // AR - AWRR 
        if (in == 60)return 149; // YR - IYRR 
        if (in == 61)return 178; // GG2 - GE 
        if (in == 62)return 159; // EL - EHLL
        if (in == 63)return 171; // BB2 - BO 
        return 0; // pause, silince, whatever is default...
     }
}
