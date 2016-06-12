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

    long cycles = 0;
    boolean lineIO = false; // false is 0, true is 1; bit 4 of snd_reg[14]
    boolean old_lineIO = false;

    static final int LINE_OFFLINE=0;
    static final int LINE_WAIT_FOR_START_BIT=1;
    static final int LINE_WAIT_FOR_START_BIT_END = 2;
    static final int LINE_RECEIVING_BITS=3;
    static final int LINE_READ_NEXT_BYTE_BIT = 4;
    static final int LINE_WAIT_FOR_STOP_BIT = 5;
    
    static final int BAUD_IN_CYCLES = 156; // 156 cycles = 9615 baud
    
    int lowLevelState = LINE_OFFLINE;
    
    int currentByteRead = 0;
    int bitsLoaded = 0;
    boolean inputMode = true;
    
    int VECVOICE_PORT = 2;
    public static transient int STATUS_LINE_MASK_PORT2 = 0x20;
    public static transient int DATA_LINE_MASK_PORT2 = 0x10;
    
    public VecVoice(E8910 e)
    {
        e8910 = e;
        e8910.setPortAdapter(this);
    }
    public VecVoice clone()
    {
        VecVoice vv = new VecVoice(e8910);
        
        return vv;
    }
    
    // receiving line information from the emulator (Joy)
    public int readDataFromPort()
    {
        return e8910.snd_regs[14];
    }

    
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
            if (!lineIO)
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
            lineIO = (e8910.snd_regs[14] & DATA_LINE_MASK_PORT2) == DATA_LINE_MASK_PORT2;
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
            lowLevelState = LINE_OFFLINE;
            lineIO = (e8910.snd_regs[14] & DATA_LINE_MASK_PORT2) == DATA_LINE_MASK_PORT2;
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
        if (lineIO != old_lineIO)
        {
            // reset cycle count on line changes (which are triggered from the outside)
            cycles = c;
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
                if (!lineIO)
                {
                    lowLevelState = LINE_WAIT_FOR_START_BIT_END;
                    if (old_lineIO)
                    {
                        cycles = c;
                    }
                }
                break;
            }
            case LINE_WAIT_FOR_START_BIT_END:
            {
                if (dif >=BAUD_IN_CYCLES)
                {
                    // got a bit 0 as startbit in a correct timeframe
                    if (!lineIO)
                    {
                        log.addLog("VecVoice: startbit received, waiting for byte data ", INFO);
                        initReceiveByte();
                        cycles = c;
                    }
                    else
                    {
                        lowLevelState = LINE_WAIT_FOR_START_BIT;
                        log.addLog("VecVoice: startbit broken, waiting again ", INFO);
                    }
                    
                }
                break;
            }
            case LINE_READ_NEXT_BYTE_BIT:
            {
                if (dif >=BAUD_IN_CYCLES)
                {
                    // LSB first
                    if (lineIO)
                        currentByteRead +=128;
                    currentByteRead = currentByteRead>>1;
                    bitsLoaded++;
                    cycles = c;
                    if (bitsLoaded == 8)
                    {
                        lowLevelState = LINE_WAIT_FOR_STOP_BIT;
                        log.addLog("VecVoice: Byte received, waiting for end bit", INFO);
                    }
                    else
                    {
                        log.addLog("VecVoice: Byte receiving (bit: "+bitsLoaded+")", INFO);
                    }
                }
                break;
            }
            case LINE_WAIT_FOR_STOP_BIT:
            {
                if (lineIO)
                {
                    lowLevelState = LINE_OFFLINE;
                    cycles = c;
                    finalizeByteRead();
                    log.addLog("VecVoice: completely received: "+currentByteRead+" (going offline)", INFO);
                }
                if (dif >=BAUD_IN_CYCLES)
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
        old_lineIO = lineIO;
    }
    void initReceiveByte()
    {
        bitsLoaded = 0;
        currentByteRead = 0;
        lowLevelState = LINE_READ_NEXT_BYTE_BIT;
    }
    MemSound lastSample = null;
    boolean isReady()
    {
        if (lastSample == null) return true;
        int pos = lastSample.getPosition();
        if (pos <0) return true;
        return false;
    }
    
    void finalizeByteRead()
    {
        log.addLog("VecVoice: byte received: " + currentByteRead, INFO);
        lastSample = VecVoiceSamples.playSample(currentByteRead);    
    }
}
