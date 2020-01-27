/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx.cartridge;

import de.malban.config.Configuration;
import de.malban.gui.CSAMainFrame;
import de.malban.gui.panels.LogPanel;
import static de.malban.gui.panels.LogPanel.ERROR;
import static de.malban.gui.panels.LogPanel.INFO;
import static de.malban.gui.panels.LogPanel.WARN;
import java.io.Serializable;

/**
 *
 * @author malban
 * Serial eEprom used in VPatrol
 * 
 * ATMEL 611 AT24C02N 10SU-2.7
 * 2,7V
 * 
 * “U” designates Green Package + RoHS compliant.
 * 
 * Package 8S1
 * 
 * 8-lead JEDEC SOIC
 * 
 * 
 * AT24C02, 2K SERIAL EEPROM: Internally organized with 32 pages of 8 bytes each,
 * the 2K requires an 8-bit data word address for random word addressing.
 * 
 * Pins:
 *  G
 *  N  A  A  A
 *  D  2  1  0 
 * 
 *  4  3  2  1 
 *          *
 *        
 *  5  6  7  8 
 *   
 *  S  S  W  V
 *  D  C  P  C
 *  A  L     C
 * 
 * 
 * First guess:
 * SDA connected to PB6
 * SCL connected to IRQ
 *     IRQ Line can be set from VIA using e.g. T1
 *     seems like Kristof used a timer of $0e for timing, that would be a little bit over 100kH 
 *     (0xf would be exactly 100kH)
 * 
 * Confirmation from Kristof:
 * 

Today I actually came around to look at your code again - since at some point I wanted to add a "ATMEL 611 AT24C02N 10SU-2.7" emulation.

Is the following correct:
 - PB6 connected to SDA

    Kristof: Yes, correct.

 - IRQ (Cartridge Port) connected to SCL

    Kristof: Yes, correct.


You use the T1 Timer interrupt to put "signals" on the cartridge IRQ port and thus SCL?
I didn't know that was possible - but your source suggestest it...
Kristof: Yes, correct. The PIA-IRQ pin is in fact an open-drain output and if you look on the vectrex-schematics, 
         a pull-up resistor of 3K3 is already installed on the logic board. The PIA-IRQ pin goes low depending on the flags 
         set in the IER and IFR registers. So, for example, by letting T1 go timeout, you can generate an SCL low signal. 
         Actually, you can manage the IFR and IER in such a way, that you can always create an IRQ low or IRQ high signal. 
         AND THIS MEANS ANOTHER BIG THING: we now can control 2 binary signals PB6 and IRQ, which means 
         extra bankswitching! So instead of having just 2x32K-banks,we now can have 4x32K-banks. 
         My pcb's are already equipped with this feature but believe me, I was more than tired enough to get the first 
         64K already filled with Vector Patrol.

This makes the serial code much more compact than in Vector Pilot - or so it seems...
Kristof: Yes. It makes it also more robust since classic I²C is by definition a quite robust protocol. 
         Actually, when the program is doing bankswitching via toggling the PB6/SDA-line, 
         it does in fact also massive amounts of START/STOP conditions towards the connected I2C-chip. 
         But this doesn't seem to be a problem for the I2C-chip.

* 
* 
* 
SERIAL CLOCK (SCL): The SCL input is used to positive edge clock data into each
EEPROM device and negative edge clock data out of each device.

SERIAL DATA (SDA): The SDA pin is bidirectional for serial data transfer. This pin is
open-drain driven and may be wire-ORed with any number of other open-drain or opencollector
devices.
* 
* 
 * 
 */
public class AT24C02 implements Serializable, CartridgeInternalInterface
{
    transient LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
    public void init()
    {
        if (log == null)
            log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
    }
    public void deinit()
    {
    }
    
    public transient static final int MAX_DATA_LEN = 256;
    
    public transient Cartridge cart;
    
    static class EpromData implements Serializable
    {
        byte[] data = new byte[MAX_DATA_LEN];
        public boolean isNew = true;
        EpromData()
        {
            for (int i=0; i<MAX_DATA_LEN;i++)
            {
                //data[i] = (byte)0xaa;
            }
        }
    }
    EpromData epromData = new EpromData();
    public byte[] getData()
    {
        return epromData.data;
    }
    
    boolean line = false; // false is 0, true is 1
    boolean old_line = false;
    boolean lineIn = false; // false is 0, true is 1
    boolean lineOut = false; // false is 0, true is 1
    boolean irqLine = false; // false is 0, true is 1
    boolean irqLineOld = false; // false is 0, true is 1
    
    
    
    public static final transient int LOW_NOTHING = 0;
    public static final transient int LOW_GET_BYTE_FROM_VECTREX = 1;
    public static final transient int LOW_SEND_BYTE_TO_VECTREX = 2;
    public static final transient int LOW_SEND_ACK_TO_VECTREX = 3;
    public static final transient int LOW_GET_ACK_FROM_VECTREX = 4;
    int lowLevelState = LOW_NOTHING;
    public static final transient String[] low_names = {
        "NOTHING",
        "GET_BYTE_FROM_VECTREX",
        "SEND_BYTE_TO_VECTREX",
        "SEND_ACK_TO_VECTREX",
        "GET_ACK_FROM_VECTREX"
    };
    
    public static final transient int HI_STANDBY_MODE = 0;
    public static final transient int HI_GET_DEVICE_ADDRESS = 1;
    public static final transient int HI_GET_WRITE_ADDRESS = 2;
    public static final transient int HI_GET_BYTE_WRITE = 3;
    public static final transient int HI_READ_CURRENT_BYTE = 4;
    public static final transient String[] hi_names = {
        "STANDBY_MODE",
        "GET_DEVICE_ADDRESS",
        "GET_WRITE_ADDRESS",
        "GET_BYTE_WRITE",
        "READ_CURRENT_BYTE"
    };
    
    
    
    int hiLevelState = HI_STANDBY_MODE;
    
    int internalAddressPointer = 0;
    
    int bitCount = 0;
    byte transportByte = 0;
    boolean lastTransportedBit = false;
    
    public static final transient int WRITE_CYCLE_DELAY = 2500; // 5 ms, in vectrex cycle that is 2500
    boolean writeAck = false;
    boolean inWriteCycle = false;
    boolean delayedAck = false;
    int writeCycleCounter = 0;
    
    int resetCount = 0;
    
    // 100kH
    // = 15 Vectrex cycles
    // reset at each IRQ change
    int periodCounter = 0; 
    public static final transient int FREQ_PERIOD = 15; // 100kHz exactly
    
    int consecutiveHigh = 0;

    public static final transient int RW_UNKOWN = 0;
    public static final transient int RW_READ_FROM_DEVICE = 1;
    public static final transient int RW_WRITE_TO_DEVICE = 2;
    int rwMode = RW_UNKOWN;

    boolean lowStarting = false;
    boolean hiStarting = false;
    int sdaLowCounter = 0;
    int sdaHiCounter = 0;
    boolean currentRecievedBit = false;
    boolean outputBit = false;
    int consecutiveBytesReceived = 0;

  
    public void reset()
    {
        line = false; // false is 0, true is 1
        old_line = false;
        lineIn = false; // false is 0, true is 1
        lineOut = false; // false is 0, true is 1
        irqLineOld = false;
        irqLine = false;
        outputBit = false;
        writeAck = false;
        currentRecievedBit = false;
    }
    public AT24C02(Cartridge c)
    {
        cart = c;
        loadBytesFromDisk();
    }
    public AT24C02(Cartridge c, boolean donotload)
    {
        cart = c;
    }
    public AT24C02 clone()
    {
        AT24C02 c = new AT24C02(cart, false);
        for (int i=0; i<MAX_DATA_LEN;i++)
        {
            c.epromData.data[i] = epromData.data[i];
        }

        c.line = line;
        c.old_line = old_line;
        c.lineIn = lineIn;
        c.lineOut = lineOut;
        c.irqLine = irqLine;
        c.irqLineOld = irqLineOld;
        c.lowLevelState = lowLevelState;
        c.hiLevelState = hiLevelState;
        c.internalAddressPointer = internalAddressPointer;
        c.bitCount = bitCount;
        c.transportByte = transportByte;
        c.inWriteCycle = inWriteCycle;
        c.delayedAck = delayedAck;
        c.writeCycleCounter = writeCycleCounter;
        c.resetCount = resetCount;
        c.periodCounter = periodCounter;
        c.consecutiveHigh = consecutiveHigh;
        c.rwMode = rwMode;
        c.sdaLowCounter = sdaLowCounter;
        c.sdaHiCounter = sdaHiCounter;
        c.lastTransportedBit = lastTransportedBit;
        c.lowStarting = lowStarting;
        c.hiStarting = hiStarting;
        c.currentRecievedBit = currentRecievedBit;
        c.outputBit = outputBit;
        c.writeAck = writeAck;
        
        return c;
    }
    
    // receiving line information from the emulator (VIA)
    public void linePB6In(boolean l)
    {
        line = l;
        lineIn = l;
    }

    // sending line information to the emulator (VIA)
    public void linePB6Out(boolean l)
    {
        line = l;
        lineOut = l;
        cart.setPB6FromCartridge(line);
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
        else
            epromData.isNew = false;
    }
    void saveBytestoDisk()
    {
        epromData.isNew = false;
        saveData(getSaveName(), epromData);
    }
    
    public String getSaveName()
    {
        return cart.cartName+".at24c02.ser";
    }

    public boolean isActive()
    {
        // todo
        return true;
    }
    public boolean usesPB6() {return true;}

    
    public String getSyncCycles()
    {
        return "";
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
    public String getSDA()
    {
        if (line) return "1";
        return "0";
    }
    public String getSCL()
    {
        if (irqLine) return "1";
        return "0";
    }
    public String getLowLevelName()
    {
        return low_names[lowLevelState];
    }
    public String getHighLevelName()
    {
        return hi_names[hiLevelState];
    }
    public boolean isInputToAtmel()
    {
        return rwMode==RW_WRITE_TO_DEVICE;
    }
    public int getBitCounter()
    {
        return bitCount;
    }
    public int getLastTransportedBit()
    {
        return lastTransportedBit?1:0;
    }
    public boolean isWriting()
    {
        return inWriteCycle;
    }
    public int getWriteCyclesLeft()
    {
        return writeCycleCounter;
    }
    public int getTransportByte()
    {
        return transportByte;
    }
    public int getInternalAddress()
    {
        return internalAddressPointer;
    }
    
    public void lineIRQIn(boolean i)
    {
        irqLine = i;
    }
      

    // low level step
    // this is triggered with every cycle from the emulator
    // c is the current cylce counter of the vecx emulator, needed for timing
    // (since I don't trust that we are called each cycle :-) )
    public void step(long c)
    {
        if (de.malban.vide.dissy.DissiPanel.specialDebugMode)
        {
            int sdaI = line?1:0;
            int sclI = irqLine?1:0;
            log.addLog("SDA: "+sdaI+", SCL: "+ sclI, INFO);
            System.out.println("SDA: "+sdaI+", SCL: "+ sclI);
        }


        if (inWriteCycle)
        {
            writeCycleCounter++;
            if (writeCycleCounter>WRITE_CYCLE_DELAY)
            {
                inWriteCycle = false;
                saveBytestoDisk();
                if (delayedAck)
                {
                    delayedAck = false;
                    lowLevelState = LOW_SEND_ACK_TO_VECTREX;
                    rwMode = RW_READ_FROM_DEVICE;
                    linePB6Out(outputBit);
                    log.addLog("ATMEL: delayed ack started ",INFO);
                }
            }
        }

        if (delayedAck)
        {
            return;
        }
        if (irqLineOld != irqLine) 
        {
            periodCounter = 0;
        }
        
        // just to be clear :-)
        boolean sda = line;
        boolean scl = irqLine;
        
        
        
        // do reset - not yet done
        if (periodCounter>FREQ_PERIOD*9)
        {
            
        }
        
        if (!scl) // scl low 
        {
            if (lowStarting)
            {
                lowStarting = false;
                sdaHiCounter=0;
                sdaLowCounter=0;
            }
            hiStarting = true;
            // collect info of data that will be transfered
            // completed as soon as scl is hi again
            
            // data transfer
            if (sda) sdaHiCounter++;
            else sdaLowCounter++;
            currentRecievedBit = sda;
            // seems only the last bit counts...
            /*
            if (rwMode == RW_WRITE_TO_DEVICE)
            {
                if (sda) sdaHiCounter++;
                else sdaLowCounter++;
            }
            else if (rwMode == RW_READ_FROM_DEVICE)
            {
                if (sda) sdaHiCounter++;
                else sdaLowCounter++;
            }
            */
            if (rwMode == RW_READ_FROM_DEVICE)                    
            {
                linePB6Out(outputBit);
            }
        }
        else // scl == true = high
        {
            if (hiStarting) 
            {
                lowStarting = true;
                hiStarting = false;
                if (rwMode == RW_WRITE_TO_DEVICE)
                {
                    doLowLevelDataStep(currentRecievedBit);
                }
                else if (rwMode == RW_READ_FROM_DEVICE)
                {
                    doLowLevelDataStep(currentRecievedBit);
                }
            }

            // start stop conditions
            if ((sda) && (!old_line)) // transition low -> hi
            {
                // stop condition
                initStopCondition();
            }
            else if ((!sda) && (old_line)) // transition hi -> lo
            {
                // start condition
                initStartCondition();
            }
        }
        periodCounter++;
        
        irqLineOld = irqLine;
        old_line = line;
    }
    void initStartCondition()
    {
        writeAck = false;
        lowStarting = true;
        bitCount = 0;
        transportByte = 0;
        lowLevelState = LOW_GET_BYTE_FROM_VECTREX;    
        hiLevelState = HI_GET_DEVICE_ADDRESS;    
        rwMode = RW_WRITE_TO_DEVICE;
        
        // "1010AAA#" / # = 1 read from device, 0 = write to device
        log.addLog("ATMEL: start",INFO);
    }
    void initStopCondition()
    {
        
        if (rwMode == RW_WRITE_TO_DEVICE)
        {
            if (writeAck)
            {
                // write cycle tiime is 5ms
                // == 2500 cycles
                log.addLog("ATMEL: Write cycle initiated",INFO);
                inWriteCycle = true;
                writeCycleCounter = 0;
            }
        }
        
        lowLevelState = LOW_NOTHING;
        hiLevelState = HI_STANDBY_MODE;
        rwMode = RW_UNKOWN;
        hiStarting = false;
        lowStarting = false;
        log.addLog("ATMEL: stop",INFO);
    }
    
    // each case is "called" when the task is finished
    void doLowLevelDataStep(boolean recievedBit)
    {
        switch (lowLevelState)
        {
            case LOW_NOTHING:
            {
                break;
            }
            case LOW_GET_BYTE_FROM_VECTREX:
            {
                // first bit can be "set" while doing a stop
                // teh stop of the write ack can be overwritten by this
                if (bitCount>0)
                    writeAck = false;
                lastTransportedBit = recievedBit;
                int bit = recievedBit?1:0;
                log.addLog("ATMEL: low, received bit: "+bit,INFO);
                transportByte = (byte)(transportByte<<1);
                transportByte += bit;
                bitCount++;
                if (bitCount == 8)
                {
                    if (inWriteCycle)
                    {
                        log.addLog("ATMEL: low, ack delayed, waiting for write ",INFO);
                        lowLevelState = LOW_NOTHING;
                        delayedAck = true;
                        break;
                    }
                    log.addLog("ATMEL: low, ack word from device expected inititated ",INFO);
                    lowLevelState = LOW_SEND_ACK_TO_VECTREX;
                    rwMode = RW_READ_FROM_DEVICE;
                    outputBit = false;
                }
                break;
            }

            case LOW_SEND_BYTE_TO_VECTREX:
            {
                int bit=0;
                if (bitCount == 0) bit = transportByte & 0x80;
                else if (bitCount == 1) bit = transportByte & 0x40;
                else if (bitCount == 2) bit = transportByte & 0x20;
                else if (bitCount == 3) bit = transportByte & 0x10;
                else if (bitCount == 4) bit = transportByte & 0x08;
                else if (bitCount == 5) bit = transportByte & 0x04;
                else if (bitCount == 6) bit = transportByte & 0x02;
                else if (bitCount == 7) bit = transportByte & 0x01;
                rwMode = RW_READ_FROM_DEVICE;
                lastTransportedBit = (bit!=0);
                outputBit = (bit!=0);
                linePB6Out(outputBit);
                log.addLog("ATMEL: low, bit send to vectrex: "+(outputBit?1:0),INFO);
                bitCount++;
                if (bitCount==8)
                {
                    log.addLog("ATMEL: low, ack word from vectrex expected inititated ",INFO);
                    lowLevelState = LOW_GET_ACK_FROM_VECTREX;
                    rwMode = RW_WRITE_TO_DEVICE;
                    internalAddressPointer = (internalAddressPointer+1)%MAX_DATA_LEN;
                }
                break;
            }
            case LOW_GET_ACK_FROM_VECTREX:
            {
                int bit = recievedBit?1:0;
                log.addLog("ATMEL: low, ack bit from vectrex received: "+bit,INFO);
                if (bit==1)
                {
                    log.addLog("ATMEL: error Ack bit = 1 - repeating ",INFO);
                    lowLevelState = LOW_GET_ACK_FROM_VECTREX;
                    rwMode = RW_WRITE_TO_DEVICE;
                    break;
                }
              
                log.addLog("ATMEL: low, ack recieved from vectrex finished",INFO);
                doHiLevelStep();
                break;
            }
            
            
            case LOW_SEND_ACK_TO_VECTREX:
            {
                log.addLog("ATMEL: low, ack send to vectrex finished",INFO);
                if (hiLevelState == HI_GET_BYTE_WRITE)
                    writeAck = true;
                doHiLevelStep();
                break;
            }
            default:
            {

            }
        }
    }

    // each case is "called" when the task is finished
    void doHiLevelStep()
    {
        switch (hiLevelState)
        {
            case HI_STANDBY_MODE:
            {
                break;
            }
            case HI_GET_DEVICE_ADDRESS:
            {
                log.addLog("ATMEL: hi, get device address finished: "+transportByte+"("+ String.format("%02X",transportByte)+")",INFO);
                
                if ((transportByte & 0xa0) != 0xa0)
                {
                    log.addLog("ATMEL: hi, get device address finished but ERROR "+transportByte,INFO);
                    lowLevelState = LOW_NOTHING;
                    hiLevelState = HI_STANDBY_MODE;
                    rwMode = RW_UNKOWN;
                    return;
                }
                
                if ((transportByte&1) == 1)
                {
                    log.addLog("ATMEL: hi mode read from device",INFO);

                    bitCount = 0;
                    transportByte = epromData.data[internalAddressPointer];
                    lowLevelState = LOW_SEND_BYTE_TO_VECTREX;    
                    hiLevelState = HI_READ_CURRENT_BYTE;    
                    rwMode = RW_READ_FROM_DEVICE;
                    
                    
                    
                    /*
                    // put the output bit 0 immediately to the port
                    int bit=0;
                    if (bitCount == 0) bit = transportByte & 0x80;
                    else if (bitCount == 1) bit = transportByte & 0x40;
                    else if (bitCount == 2) bit = transportByte & 0x20;
                    else if (bitCount == 3) bit = transportByte & 0x10;
                    else if (bitCount == 4) bit = transportByte & 0x08;
                    else if (bitCount == 5) bit = transportByte & 0x04;
                    else if (bitCount == 6) bit = transportByte & 0x02;
                    else if (bitCount == 7) bit = transportByte & 0x01;
                    lastTransportedBit = (bit!=0);
                    outputBit = (bit!=0);
                    log.addLog("ATMEL: low, bit send to vectrex: "+(outputBit?1:0),INFO);
                    bitCount++;        
                    */
                }
                else
                {
                    bitCount = 0;
                    transportByte = 0;
                    lowLevelState = LOW_GET_BYTE_FROM_VECTREX;    
                    hiLevelState = HI_GET_WRITE_ADDRESS;    
                    rwMode = RW_WRITE_TO_DEVICE;
                    log.addLog("ATMEL: hi mode write to device",INFO);
                }
                break;
            }
            // this actually also sets the random read address
            case HI_GET_WRITE_ADDRESS:
            {
                if (epromData.isNew) 
                    loadBytesFromDisk();
                
                internalAddressPointer = transportByte;
                log.addLog("ATMEL: hi write address got: "+transportByte+"("+ String.format("%02X",transportByte)+")",INFO);
                bitCount = 0;
                transportByte = 0;
                lowLevelState = LOW_GET_BYTE_FROM_VECTREX;    
                hiLevelState = HI_GET_BYTE_WRITE;    
                rwMode = RW_WRITE_TO_DEVICE;
                consecutiveBytesReceived = 0;
                break;
            }
            case HI_GET_BYTE_WRITE:
            {
                // single byte address wil be terminated by
                // scl change - so
                // here is no difference between page and byte write
                log.addLog("ATMEL: hi byte recieved: "+transportByte+"("+ String.format("%02X",transportByte)+") (to: "+String.format("%02X",internalAddressPointer)+")",INFO);

                if (consecutiveBytesReceived>=8)
                {
                    log.addLog("ATMEL: WARNING page write exceeds 8",WARN);
                }
                try
                {
                epromData.data[internalAddressPointer] = (byte)transportByte;   

                // inc lower 3 bits only - and roll over
                int adrHi = internalAddressPointer & 0xf8;
                int adrLo = internalAddressPointer & 0x07;
                adrLo ++;
                adrLo = adrLo & 0x07;
                internalAddressPointer = adrHi | adrLo;

                consecutiveBytesReceived++;
                bitCount = 0;
                transportByte = 0;
                lowLevelState = LOW_GET_BYTE_FROM_VECTREX;    
                hiLevelState = HI_GET_BYTE_WRITE;    
                rwMode = RW_WRITE_TO_DEVICE;
                }
                catch (Throwable e)
                {
                    log.addLog(e,ERROR);
                }
                break;
            }
            
            // from device to vectrex
            case HI_READ_CURRENT_BYTE:
            {
                // single byte address wil be terminated by
                // scl change - so
                // here is no difference between page and byte write
                int la = internalAddressPointer-1;
                if (la < 0) la += 256;
                log.addLog("ATMEL: current byte sent to vectrex: "+transportByte+"("+ String.format("%02X",transportByte)+") (from: "+String.format("%02X",la)+")",INFO);

                // we prepare everything for a sequential read
                // if it does not happen -> no harm done!
                bitCount = 0;
                transportByte = epromData.data[internalAddressPointer];
                lowLevelState = LOW_SEND_BYTE_TO_VECTREX;    
                hiLevelState = HI_READ_CURRENT_BYTE;    
                rwMode = RW_READ_FROM_DEVICE;
                log.addLog("ATMEL: hi mode read from device",INFO);
                break;
            }            
            default:
            {

            }
        }
    }
}
