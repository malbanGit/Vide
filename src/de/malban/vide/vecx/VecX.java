/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.



Vecx
1) Emulating shifting of SHIFT REG (every two cycles)
2) instruction clr (0x0f  + 0x6f + 0x7f) also READS memory (importand in e.g. clr shift_reg
3) FAST RTI
4) interrupt flag of CA1 should be set in accordance to the CTR register of via (transition low/hi or hi/low) 
5) T2 timer2 shift clock, also doubled (== 4 cycles)
                    case 0x8:
                        / T2 low order counter /
                        data = via_t2c;
                        via_ifr &= 0xdf; / remove timer 2 interrupt flag /
                        via_t2int = 0; // THIS WAS original - and is wrong!
                        via_t2int = 1;
                        int_update ();
                        break;
6) original bug in emulation code discovered - upon read of T2 low counter the iFlag must be resetted - that was falsly implemented
         and could lead to vectrex games crashing (e.g. omega chase).

7)  exgtfr_read (op >> 4)); if fed with "a" register than "ff" is returned instead of value of a!
8) 
        return (datahi << 8) | (datalo&0xff); was done without &0xff negative lows could vanish the his
9) original bug in emulation code discovered - upon read of T1 low counter the iFlag must be resetted - that was falsly implemented
         and could lead to vectrex games crashing (e.g. vector Patrol).
10) to test if originally wrong 
  regardless of int allowed state, ramp flag changes upon timer expires T1


 */
package de.malban.vide.vecx;
/*
MUX enable isbit 0 ob ORB, MUX activ when bit 0 is 0!
BLANK is via_cb2 line. Blank is active when CB2 0 is (meaning, LIGHT of beam is switched OFF)
ZERO is via via_ca2 line. Zero is active when ca2 is 0, meaning, integrators are resetted to 0
RAMP is ORB Bit 7 (0x80). Ramp is active when bit 7 is 0, meaning, the integrators are 
     WORKING, when bit 7 is NOT set!
(Bit 7 of ORB can be timer controlled (ACR & 0x80 = 0x80) )


the MUX, connects the DAC with 4 possible destinations
BIT (Bits 2 and 3 of ORB)
00 Y integrator
01 R Offset
10 Z Brightness
11 S Soundchip

X Integrator is ALLWAYS DAC feeded, regardless of MUX.

The DAC is "loaded" with the values in ORA.

The DAC values which can be "feeded" to the integators do nothing if RAMP is not set.
IF ramp is set to 0 (that means active) +
both X and Y integrators use the last fed DAC value and 
start "adding" them to there internal counters.

These "counters" represent the X and Y position of the vector beam.
(DAC values can be positive and negative)

The 6522 chips offers VARIOUS possiblities to change values and signals.
SHIFT, Interrupt, Timers etc

Moonlander, my Text drawing routines,
require CYCLE exact emulation of VIA
meaning, processor excat cacle emulation, in between fetch read execute processor emulation!

    // TODO:
    // emulate timer for mux sel
    // do a mux -> dac to analog
    // every turn with current
    // values
    // evt with on timein!

*/


import de.malban.vide.vecx.cartridge.VSID;
import de.malban.vide.vecx.devices.VectrexJoyport;
import de.malban.Global;
import de.malban.vide.VideConfig;
import de.malban.config.Configuration;
import de.malban.gui.CSAMainFrame;
import de.malban.gui.dialogs.ShowWarningDialog;
import de.malban.vide.vecx.cartridge.CartridgeListener;
import de.malban.gui.panels.LogPanel;
import static de.malban.vide.vecx.CodeScanMemory.MemInfo.*;
import de.malban.vide.vecx.cartridge.CartridgeProperties;
import de.malban.vide.vecx.cartridge.CartridgePropertiesPanel;
import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import static de.malban.gui.panels.LogPanel.ERROR;
import static de.malban.gui.panels.LogPanel.INFO;
import static de.malban.gui.panels.LogPanel.WARN;
import de.malban.vide.dissy.DissiPanel;
import de.malban.vide.veccy.VectorListScanner;
import de.malban.vide.vecx.cartridge.Cartridge;
import de.malban.vide.vecx.devices.Imager3dDevice;
import static de.malban.vide.vecx.panels.PSGJPanel.REC_BIN;
import static de.malban.vide.vecx.panels.PSGJPanel.REC_DATA;
import static de.malban.vide.vecx.panels.PSGJPanel.REC_YM;
import java.io.BufferedOutputStream;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import java.util.Vector;

/**
 *
 * @author malban
 */
public class VecX extends VecXState implements VecXStatics, E6809Access
{
    public static final int START_TYPE_DEBUG = 1;
    public static final int START_TYPE_RUN = 2;
    public static final int START_TYPE_INJECT = 3;
    public static final int START_TYPE_STOP = 4;

    transient Profiler profiler = null;
    
    // for easier access from cart
    // config is here public
    // other wise we could also duplicate config in cart...
    // this way it is
    // easier to keep consistency while load and save/state
    public VideConfig config = VideConfig.getConfig();
    private LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
    // timer is count down in 1/1500000 steps
    // meaning each processor cycle is one step...
    
    
    // public because lazy and VectrexJoyport uses them
    public ArrayList<Breakpoint> breakpoints[] = new ArrayList[Breakpoint.BP_TARGET_COUNT];
    public ArrayList<Breakpoint> activeBreakpoint = new ArrayList<Breakpoint>();
    public int breakpointExit=EMU_EXIT_CYCLES_DONE;
    // returns an "exit reason"
    // break point e.g.
   
    boolean rampOffFraction = true;
    boolean rampOnFraction = true;

    // via shift cycles - only eaxch alternate "cycle2
    boolean alternate = false;


    transient CodeScanMemory dissiMem=CodeScanMemory.getCodeScanMemory();

    public void setAllBreakpoints(ArrayList<Breakpoint>[] ab)
    {
        // set all
        for (ArrayList<Breakpoint> blist: ab)
        {
            for (Breakpoint b: blist)
            {
                addBreakpoint(b);
            }
        }
    }

    ArrayList<Breakpoint>[] getAllBreakpoints() 
    {
        return breakpoints;
    }

    public static int OVERFLOW_BORDER_RAYWIDTH = 6;            
    public static int OVERFLOW_SAMPLE_MAX = 16;
    static class VectrexDisplayVectors
    {
        vector_t[] vectrexVectors = new vector_t[VECTOR_CNT];
        float[] left = new float[OVERFLOW_SAMPLE_MAX];
        float[] right = new float[OVERFLOW_SAMPLE_MAX];
        float[] top = new float[OVERFLOW_SAMPLE_MAX];
        float[] bottom = new float[OVERFLOW_SAMPLE_MAX];
        void resetBorders()
        {
            for (int i=0; i<OVERFLOW_SAMPLE_MAX; i++)
            {
                left[i] = right[i] = top[i] = bottom[i]=0;
            }
        }
        int count = 0;
        VectrexDisplayVectors()
        {
            for(int i=0; i<VECTOR_CNT; i++ )
                vectrexVectors[i] = new vector_t();
        }
    }
// following public
// so I can inspect memory usage
    
    transient E8910 e8910 = null;
    transient E6809 e6809 = null;

    transient int[] rom = new int[8192];

    transient static int SS_RING_BUFFER_SIZE = 30000;
    transient int ringSSWalkStep = 0; // if I step back, what is the position of the step back?
    transient int ringSSBufferNext = 0;
    public transient CompleteState[] goSSBackRingBuffer = new CompleteState[SS_RING_BUFFER_SIZE];
    
    
    transient static int FRAME_RING_BUFFER_SIZE = 1000;
    transient int ringFrameWalkStep = 0; // if I step back, what is the position of the step back?
    transient int ringFrameBufferNext = 0;
    public transient CompleteState[] goFrameBackRingBuffer = new CompleteState[FRAME_RING_BUFFER_SIZE];
    
    transient static int WAIT_RECAL_BUFFER_SIZE = 500;
    transient int waitRecalBufferNext = 0;
    transient boolean waitRecalActive = true;
    transient int testBank = 0;
    transient int testAddressFirst = 0xF1A2;
    transient int testAddressSecond = 0xF192;
    transient long lastTestTicks = 0;
    transient int[] waitRecalBuffer = new int[WAIT_RECAL_BUFFER_SIZE];
    
    transient boolean directDrawActive = false;
    
    public transient VectrexJoyport[] joyport= new VectrexJoyport[2];
     
    // dummy displayer, which does nothing!
    public transient DisplayerInterface displayer = new DisplayerDummy();
    
    transient VectrexDisplayVectors[] vectorDisplay = new VectrexDisplayVectors[2];
    transient int displayedNext = 0;
    transient int displayedNow = 1;
    transient int[] vector_hash = new int[VECTOR_HASH];
    transient long fcycles;
    transient long trackyCount = 0;
    transient long trackyAbove = 0;

    ArrayList<TimerItem> timerHeap = new ArrayList<TimerItem>();

    
    
 
    int pb6_pulseCounter = 0;
    
    long lastAddLine = 0;
    double intensityDriftNow = 1;
    boolean toManyvectors = false;

    int nonCPUStepsDone = 0;
    ArrayList<Breakpoint> tmp = new ArrayList<Breakpoint>();
    boolean syncImpulse = false;
    long lastSyncCycles = 0;
    long soundCycles = 0;
    static int UID_ = 1;
    static int uid = UID_++;    
    volatile boolean debugging = false;
    boolean stop = false;
    // for speed measurement    
    long cyclesDone=0;
    boolean thisWaitRecal = false;
    long lastWaitRecal=0;
    long lastRecordCycle = 0;

    // is a "fast" interupt initiated (from device port 0 Button 4)
    // only == 0 or !=0 is relevant
    int firq;

    public boolean recording = false;
    int recordingType = REC_YM;
    boolean recordingIsAddress = true;
    int recordingAddress = 0;
    String recordingFilename = "";
    ArrayList<byte[]> recordData;

    
    static final int WR_UNKOWN = 0;
    static final int WR_FIRST_FOUND = 1;
    int wrStatus = WR_UNKOWN;
    public transient int allTimeLow = 65536;
    
    ArrayList<TimerItem> timerRemoveList = new ArrayList<TimerItem>();
    ArrayList<VecX.TimerItem> timerItemListClone = new ArrayList<TimerItem>();
    long noiseCycles = 0;
    
    
    void timerAddItem(int when, int value, ValuePointer destination, int t)
    {
        TimerItem titem;
        if (timerHeap.size() == 0)
        {
            titem = new  TimerItem( when,  value,  destination, t);
        }
        else
        {
            titem = timerHeap.remove(0);
            titem.countDown = when;
            titem.valueToSet = value;
            titem.whereToSet = destination;
            titem.type = t; 
        }
        synchronized (timerItemList)
        {
            timerItemList.add(titem);
        }
    }
    void timerAddItem(int value, ValuePointer destination, int t)
    {
        TimerItem titem;
        if (timerHeap.size() == 0)
        {
            titem = new  TimerItem(value,  destination, t);
        }
        else
        {
            titem = timerHeap.remove(0);
            titem.valueToSet = value;
            titem.whereToSet = destination;
            titem.type = t; 
            
            titem.countDown = VideConfig.getConfig().delays[(t&0xff)];
        }
        synchronized (timerItemList)
        {
            timerItemList.add(titem);
        }
    }
    
    /**
     * Creates new form VecXPanel
     */
    @SuppressWarnings("LeakingThisInConstructor")
    public VecX() 
    {
        vectorDisplay[0] = new VectrexDisplayVectors();
        vectorDisplay[1] = new VectrexDisplayVectors();
        joyport[0]= new VectrexJoyport(0, this);
        joyport[1]= new VectrexJoyport(1, this);
        
        e6809 = new E6809();
        e6809.vecx=this;        
        e8910 = new E8910();
        e8910.setVectrexJoyport(joyport);
        e8910.e8910_init_sound();
        for (int i=0; i<Breakpoint.BP_TARGET_COUNT; i++)
            breakpoints[i] = new ArrayList<Breakpoint>();
    }
    void deinit()
    {
        if (e8910 != null)
        {
            e8910.e8910_done_sound();
        }
        joyport[0].deinit();
        joyport[1].deinit();
        displayer = new DisplayerDummy();
    }

    public void setDisplayer(DisplayerInterface d)
    {
        displayer = d;
        displayer.setLED(0);
    }
    
    public void setPB6FromExternal(boolean b)
    {
       // if ((via_ddrb & 0x40) != 0) return; // if via is in output - don't change line from cart!
        /*
        int data = via_orb;
        if (b) data = data | 0x40;
        else data = data & (0xff - 0x40);
        
        checkVIABreakpoint(0, via_orb, data); 

        boolean changed = ((via_orb & 0x40) >0) == b;

        if (changed) 
            checkExternalLineBreakpoint(b);
    //    old_pb6 = b;
        via_orb = data;
        */
        boolean changed = ((pb6_in & 0x40) ==0x40) != b;

        if (config.breakpointsActive)
            if (changed) 
                checkExternalLineBreakpoint(b);
        if (b)
            pb6_in = 0x40;
        else
            pb6_in = 0x00;

    }
    /* update the snd chips internal registers when via_ora/via_orb changes */
    // here ORA is taken, not DAC
    // for PSG this should not make really a difference!
    void snd_update(boolean command)
    {
        switch (via_orb & 0x18) 
        {
            case 0x00:
                /* the sound chip is disabled */
                break;
            case 0x08:
                
                /* the sound chip is sending data */
                // via_ora must be set!
                if (command)
                    via_ora = e8910.read(snd_select);
                break;
            case 0x10:
                /* the sound chip is recieving data */
                if (command)
                    e8910.e8910_write(snd_select, via_ora);
                break;
            case 0x18:
                /* the sound chip is latching an address */
                if ((via_ora & 0xf0) == 0x00) 
                    snd_select = via_ora & 0x0f;
                break;
        }
        
        // Malban
        if ((via_orb & 0x07) == 0x06) // SEL == 11 -> Sound, Mux ==0 meaning ON
        {
            // dac is sending data to audio hardware
            // since we are used to do audio in PSG anyway, we send the sampled data there to a "dummy" register
            // data is via_ora
            // dummy register, write directy to audio line buffer in psg emulation!
            e8910.e8910_write(255, alg_ssh.intValue);
        }
        if (config.breakpointsActive)
            checkPSGBreakpoint();
    }

    /* update IRQ and bit-7 of the ifr register after making an adjustment to
     * ifr.
     */
     void int_update ()
    {
	if ( (((via_ifr & 0x7f) & (via_ier & 0x7f))) != 0   ) 
        {
            via_ifr |= 0x80;
        } 
        else 
        {
            via_ifr &= 0x7f;
        }
        if (cart != null) cart.setIRQFromVectrex(((via_ifr&0x80) !=0 ));
    }
    // for dump windows,
    // so read does not effect IO
    public int e6809_readOnly8(int address)
    {
        int data = 0;
        
        if ((address & 0xe000) == 0xe000) 
        {
            /* rom */
            data = rom[address & 0x1fff];
        } 
        else if ((address & 0xe000) == 0xc000) 
        {
            if ((address & 0x800) != 0)
            {
                /* ram */
                data = ram[address & 0x3ff];
            } 
            else if ((address & 0x1000) != 0)
            {
                /* io */
                switch (address & 0xf) 
                {
                    case 0x0:
                        /* compare signal is an input so the value does not come from
                         * via_orb.
                         */
                        if ((via_acr & 0x80) !=0)
                        {
                            /* timer 1 has control of bit 7 */
                            data = ((via_orb & 0x5f) | alg_compare | via_t1pb7);
                        } 
                        else 
                        {
                            /* bit 7 is being driven by via_orb */
                            data = ((via_orb & 0xdf) | alg_compare);
                        }
                        if ((via_ddrb & 0x40) == 0) // pb6 is input
                        {
                            data = data & (0xff-0x40); // ensure pb6 =0
                            data = data | (pb6_in); // ensure pb6 in value
                        }
                        else
                        {
                            if (config.isFaultyVIA)
                            {
                                data = data | 0x40;
                            }
                        }
                        
                        break;
                    case 0x1:
                        /* fall through */
                    case 0xf:
                        if ((via_orb & 0x18) == 0x08) 
                        {
                            /* the snd chip is driving port a */
                            data = e8910.read(snd_select);
                        } 
                        else 
                        {
                            data = via_ora;
                        }
                        break;
                    case 0x2:
                        data = via_ddrb;
                        break;
                    case 0x3:
                        data = via_ddra;
                        break;
                    case 0x4:
                        /* T1 low order counter */
                        data = via_t1c;
                        break;
                    case 0x5:
                        /* T1 high order counter */
                        data = (via_t1c >> 8);
                        break;
                    case 0x6:
                        /* T1 low order latch */
                        data = via_t1ll;
                        break;
                    case 0x7:
                        /* T1 high order latch */
                        data = via_t1lh;
                        break;
                    case 0x8:
                        /* T2 low order counter */
                        data = via_t2c&0xff;
                        break;
                    case 0x9:
                        /* T2 high order counter */
                        data = (via_t2c >> 8);
                        break;
                    case 0xa:
                        data = via_sr;
                        break;
                    case 0xb:
                        data = via_acr;
                        break;
                    case 0xc:
                        data = via_pcr;
                        break;
                    case 0xd:
                        /* interrupt flag register */
                        data = via_ifr;
                        break;
                    case 0xe:
                        /* interrupt enable register */
                        data = (via_ier | 0x80);
                        break;
                }
            }
        } 
        else if (cart != null) 
        {
            return cart.readByte(address)& 0xff;
        } 

        return data & 0xff; // and return unsigned byte!        
    }
    // returns unsigned 8bit in int 
    @Override
    public int e6809_read8(int address)
    {
        int data=0;

        if (config.debugingCore)
        {
            if (config.codeScanActive) 
                dissiMem.mem[address].addAccess(e6809.reg_pc, e6809.reg_dp, MEMORY_READ);
            checkMemReadBreakpoint(address);
        }

        if ((address & 0xe000) == 0xe000) 
        {
            /* rom */
            return rom[address & 0x1fff];
        } 
        else if ((address & 0xe000) == 0xc000) 
        {
            if ((address & 0x800) != 0)
            {
                if (ramAccess[address & 0x3ff]==0)
                {
                    if (e6809.clear==0)
                    log.addLog("RAM ACCESS to uninitialized location: "+String.format("$%04X", address)+ " from: "+String.format("$%04X", e6809.reg_pc));
                }
                /* ram */
                //data = ram[address & 0x3ff];
                return ram[address & 0x3ff];
            } 
            else if ((address & 0x1000) != 0)
            {
               // int data = 0;
                /* io */
                switch (address & 0xf) 
                {
                    case 0x0:
                        /* compare signal is an input so the value does not come from
                         * via_orb.
                         */
                        if ((via_acr & 0x80) !=0)
                        {
                            /* timer 1 has control of bit 7 */
                            data = ((via_orb & 0x5f) | alg_compare | via_t1pb7);
                        } 
                        else 
                        {
                            /* bit 7 is being driven by via_orb */
                            data = ((via_orb & 0xdf) | alg_compare);
                        }
                        if ((via_ddrb & 0x40) == 0) // pb6 is input
                        {
                            data = data & (0xff-0x40); // ensure pb6 =0
                            data = data | (pb6_in); // ensure pb6 in value
                        }
                        else
                        {
                            if (config.isFaultyVIA)
                            {
                                data = data | 0x40;
                            }
                        }
                        return data;
                    case 0x1:
                        /* register 1 also performs handshakes if necessary */
                        if ((via_pcr & 0x0e) == 0x08) 
                        {
                            /* if ca2 is in pulse mode or handshake mode, then it
                             * goes low whenever ira is read.
                             */
                            via_ca2 = 0;
                            timerAddItem(via_ca2,sig_zero, TIMER_ZERO);
                        }
                        via_ifr = via_ifr & (0xff-0x02); // clear ca1 interrupt
                        if (cart != null) cart.setIRQFromVectrex(((via_ifr&0x80) !=0 ));
                        /* fall through */
                    case 0xf:
                        if ((via_orb & 0x18) == 0x08) 
                        {
                            /* the snd chip is driving port a */
//                            data = e8910.read(snd_select);
                            return e8910.read(snd_select);
                        } 
                        else 
                        {
//                            data = via_ora;
                            return via_ora;
                        }
                    case 0x2:
                        //data = via_ddrb;
                        return via_ddrb;
                    case 0x3:
                        //data = via_ddra;
                        return via_ddra;
                    case 0x4:
                        /* T1 low order counter */
                        data = via_t1c;
                        via_ifr &= 0xbf; /* remove timer 1 interrupt flag */
//                        via_t1int = 0; // THIS WAS original - and is wrong!
                        via_t1int = 1;
                        int_update ();
                        return data;
                    case 0x5:
                        /* T1 high order counter */
                        // data = (via_t1c >> 8);
                        return (via_t1c >> 8)&0xff;
                    case 0x6:
                        /* T1 low order latch */
                        //data = via_t1ll;
                        return via_t1ll;
                    case 0x7:
                        /* T1 high order latch */
                        //data = via_t1lh;
                        return via_t1lh;
                    case 0x8:
                        /* T2 low order counter */
                        data = via_t2c;
                        via_ifr &= 0xdf; /* remove timer 2 interrupt flag */



//                        via_t2int = 0; // THIS WAS original - and is wrong!
                        via_t2int = 1;
                        
                        
                        
                        
                        int_update ();
                        return data;
                    case 0x9:
                        /* T2 high order counter */
//                        data = (via_t2c >> 8);
                        return (via_t2c >> 8)&0xff;
                    case 0xa:
                        //data = via_sr;
                        timerAddItem(via_sr, null, TIMER_SHIFT_READ);
                        return via_sr;
                    case 0xb:
                        //data = via_acr;
                        return via_acr;
                    case 0xc:
                        //data = via_pcr;
                        return via_pcr;
                    case 0xd:
                        /* interrupt flag register */
                        //data = via_ifr;
                        return via_ifr;
                    case 0xe:
                        /* interrupt enable register */
                        //data = (via_ier | 0x80);
                        return (via_ier | 0x80);
                }
            }
            else if (cart != null) 
            {
                return cart.readByte(address);
            } 
        } 
        else if (cart != null) 
        {
            return cart.readByte(address);
        } 
        return 0xff; // and return unsigned byte!
    }

    @Override
    public void e6809_write8(int address, int data)
    {
        
        if (config.debugingCore)
        {
            if (config.codeScanActive) dissiMem.mem[address].addAccess(e6809.reg_pc, e6809.reg_dp, MEMORY_WRITE);
            checkMemWriteBreakpoint(address, data);
        }
        
        data = data & 0xff;
        if ((address & 0xe000) == 0xe000) 
        {
            /* rom */
        } 
        else if ((address & 0xe000) == 0xc000) 
        {
            /* it is possible for both ram and io to be written at the same! */
            if ((address & 0x800) != 0)
            {
                ram[address & 0x3ff] = data;
                
                ramAccess[address & 0x3ff]=1;
            }
                
            if ((address & 0x1000) != 0)
            {
                switch (address & 0xf) 
                {
                    case 0x0:
//            if ((data&0x40) == 0x40) 
//                System.out.println("badOutFromVectrex pc = "  +e6809.reg_pc);
                        if (config.breakpointsActive) checkVIABreakpoint(0, via_orb, data);                  
                        boolean pb6 = setPB6FromVectrex(data, via_ddrb, true);
                        if ((data & 0x7) != (via_orb & 0x07)) // check if state of mux sel changed
                        {
                            timerAddItem(data, alg_sel, TIMER_MUX_SEL_CHANGE);
                        }
                        
                        // for old times sake, variable via_orb allways carries the vectrex "out" state of pb6
                        via_orb = data;
                        snd_update(true);
                        
                        if ((via_pcr & 0xe0) == 0x80) 
                        {
                            /* if cb2 is in pulse mode or handshake mode, then it
                             * goes low whenever orb is written.
                             */
                            via_cb2h = 0;
                            timerAddItem(via_cb2h, sig_blank, TIMER_BLANK_ON_CHANGE);
                        }
                        doCheckRamp(true);

                        break;
                    case 0x1:
                        /* register 1 also performs handshakes if necessary */
                        if ((via_pcr & 0x0e) == 0x08) 
                        {
                            /* if ca2 is in pulse mode or handshake mode, then it
                             * goes low whenever ora is written.
                             */
                            via_ca2 = 0;
                            timerAddItem(via_ca2,sig_zero, TIMER_ZERO);
                        }
                        via_ifr = via_ifr & (0xff-0x02); // clear ca1 interrupt
                        if (cart != null) cart.setIRQFromVectrex(((via_ifr&0x80) !=0 ));
                    /* fall through */
                    case 0xf:
                        /* output of port a feeds directly into the dac which then
                         * feeds the x axis sample and hold.
                         */
                        
                        alg_DAC.intValue = data;
                        via_ora = data;
                    
                        /* output of port a feeds directly into the dac which then
                         * feeds the x axis sample and hold.
                         */
                        timerAddItem(alg_DAC.intValue, alg_xsh, TIMER_XSH_CHANGE);
                        doCheckMultiplexer();
                        
                        
                        
                        snd_update(false);
                        break;
                    case 0x2:
                        setPB6FromVectrex(via_orb, data, false);
                        via_ddrb = data;
                        break;
                    case 0x3:
                        via_ddra = data;
                        break;
                    case 0x4:
                        /* T1 low order counter */
                        via_t1ll = data;
                        break;
                    case 0x5:
                        /* T1 high order counter */
                        timerAddItem(data,null, TIMER_T1);
                        break;
                    case 0x6:
                        /* T1 low order latch */
                        via_t1ll = data;
                        break;
                    case 0x7:
                        /* T1 high order latch */
                        // Malban: check, should that not rather be exactly the same as reg 5?
                        // in fact should reg 5 not load into t1lh and "fall through" to reg 7 which
                        // than loads t1lh to t1c and t1ll also... triggering in effect the counter?
                        via_t1lh = data;
                        break;
                    case 0x8:
                        /* T2 low order latch */
                        via_t2ll = data;
                        break;
                    case 0x9:
                        /* T2 high order latch/counter */
                        timerAddItem(data,null, TIMER_T2);
                        break;
                    case 0xa:
                 
                        timerAddItem(data, via_shift, TIMER_SHIFT_WRITE);
                        break;
                    case 0xb:
                        if ((via_acr & 0x1c) != (data & 0x1c))
                        {
                            // new CSA
                            if ((data & 0x1c) == 0) // shift reg is switched off - so take the manual value
                            {
                                // removed to get the stalling of write shift correct
                                // test with release explosion normal end - 
                                // if this is IN scrolltext (e.g.) draws dots
         //                       addTimerItem(new TimerItem(via_cb2hmanual, sig_blank, TIMER_BLANK_CHANGE));
         // possibly this sets teh shift interrupt flag to disbaled!

//                via_ifr &= (255-0x04); // 


                            }
                            else // use the last shift
                            {
    //                            addTimerItem(new TimerItem(via_cb2s, sig_blank, TIMER_BLANK_CHANGE));
                                timerAddItem(0, sig_blank, TIMER_BLANK_ON_CHANGE);
                            }
                        }
                        if ((via_acr & 0xc0) != (data & 0xc0))
                        {
                            via_acr = data;
                            doCheckRamp(!((via_acr&0x80) == 0x80));
                        }
                        
                        via_acr = data;
                        break;
                    case 0xc:
                        via_pcr = data;
                        if ((via_pcr & 0x0e) == 0x0c) 
                        {
                            /* ca2 is outputting low */
                            via_ca2 = 0;
                            timerAddItem(via_ca2,sig_zero, TIMER_ZERO);
                        } 
                        else 
                        {
                            /* ca2 is disabled or in pulse mode or is
                             * outputting high.
                             */
                            via_ca2 = 1;
                            timerAddItem(via_ca2,sig_zero, TIMER_ZERO);
                        }
                        if ((via_acr & 0x1c) == 0)
                        {
                            if ((via_pcr & 0xe0) == 0xc0) 
                            {
                                /* cb2 is outputting low */
                                via_cb2h = 0;
                                via_cb2hmanual = 0;
                                timerAddItem(via_cb2h, sig_blank, TIMER_BLANK_ON_CHANGE);
                            } 
                            else if ((via_pcr & 0xe0) == 0xe0) 
                            {
                                /* cb2 is outputting high */
                                via_cb2h = 1;
                                via_cb2hmanual = 1;
                                timerAddItem(via_cb2h, sig_blank, TIMER_BLANK_OFF_CHANGE);
                            } 
                            else 
                            {
                                /* cb2 is disabled or is in pulse mode or is
                                 * outputting high.
                                 */
                                via_cb2h = 1;
                                timerAddItem(via_cb2h, sig_blank, TIMER_BLANK_OFF_CHANGE);
                            }
                        }
                        break;
                    case 0xd:
                        /* interrupt flag register */
                        via_ifr &= ~(data & 0x7f);
                        int_update ();
                        break;
                    case 0xe:
                        /* interrupt enable register */
                        if ((data & 0x80) !=0)
                        {
                            via_ier |= data & 0x7f;
                        } 
                        else 
                        {
                            via_ier &= ~(data & 0x7f);
                        }
                        int_update ();
                        break;
                }
            }
            if (((address & 0x1000) == 0) && ((address & 0x800) == 0)) // not d000 nad < c800
            {
                // possibly write to cart
                cart.write(address, (byte)data);
            }
            return;
        } 
        cart.write(address, (byte)data);
    }

    void vecx_reset()
    {
       vecx_reset(true);
    }
    void vecx_reset(boolean hardReset)
    {
        int r;
        if (displayer != null)
            displayer.setLED(0);

        /* ram */
        if (hardReset)
            for (r = 0; r < 1024; r++) 
            {
                ram[r] = r & 0xff;
            }
        
        e8910.reset();
        e8910.setVectrexJoyport(joyport);
        for (r = 0; r < 16; r++) 
        {
            e8910.e8910_write(r, 0);
        }

        snd_select = 0;
        lastShiftTriggered = 0;
        via_stalling = false;
        via_ora = 0;
        via_orb = 0;
        pb6_in = 0x40;
        pb6_out = 0x40;
        via_ddra = 0;
        via_ddrb = 0;
        via_t1on = 0;
        via_t1int = 0;
        via_t1c = 0;
        via_t1ll = 0;
        via_t1lh = 0;
        via_t1pb7 = 0x80;
        via_t2on = 0;
        via_t2int = 0;
        via_t2c = 0;
        via_t2ll = 0;
        via_sr = 0;
        via_srb = 8;
        via_src = 0;
        via_srclk = 0;
        via_acr = 0;
        via_pcr = 0;
        via_ifr = 0;
        via_ier = 0;
        via_ca1 = 1;
        old_via_ca1 = 1;
        via_ca2 = 1;
        via_cb2h = 1;
        via_cb2s = 0;
        old_pb6 = false;
        intensityDrift = 0;

        c_alg_rsh.setDigitalVoltage(128);
        alg_xsh.intValue = 128;
        alg_ysh.intValue = 128;
        alg_zsh.intValue = 0;
        alg_ssh.intValue = 0;
        alg_jsh = 128;
        alg_compare = 0; 
        sig_zero.intValue = 1;
        sig_ramp.intValue = 0;
        sig_blank.intValue = 0;
        alg_curr_x = config.ALG_MAX_X / 2;
        alg_curr_y = config.ALG_MAX_Y / 2;
        
        alg_DAC.intValue = 0;
        alg_vectoring = 0;

        alg_vector_x0 = 0; 
        alg_vector_y0 = 0;
        alg_vector_x1 = 0;
        alg_vector_y1 = 0;
        alg_vector_dx = 0;
        alg_vector_dy = 0;
        alg_vector_color = 0;
        alg_vector_speed = 0;

        alg_ramping = false;
        alg_spline_compare_dx = Integer.MAX_VALUE;
        alg_spline_compare_dy = Integer.MAX_VALUE;
        
        ticksRunning = 0;
        
        vectorDisplay[0].count = 0;
        vectorDisplay[1].count = 0;

        fcycles = FCYCLES_INIT;
        cyclesRunning = 0;

        if (hardReset)
        {
            if (config.resetBreakpointsOnLoad)
                clearAllBreakpoints();        
        }
        synchronized (timerItemList)
        {
            timerItemList.clear();
        }
        e6809.e6809_reset();
        dissiMem.reset();
        if (cart!= null) cart.reset();
        resetBuffer();
        
    }
    public void initDissi()
    {
        
        if ((config.doProfile) && (config.debugingCore))
        {
            String name = "main";
            if (cart != null) name = cart.cartName;
            profiler = Profiler.buildProfiler(e6809.reg_pc, name);
            e6809.profiler = profiler;
            
            if (Configuration.getConfiguration().getMainFrame() instanceof CSAMainFrame)
            {
                CSAMainFrame frame = (CSAMainFrame) Configuration.getConfiguration().getMainFrame();
                DissiPanel dissi = frame.checkDissi();
                if (dissi != null)
                {
                    dissi.setProfilingNames(profiler);
                }
            }
        }
    }
    
    
    // from ParaJVE
    /*
    
  private void outputPB()
  {
    int i = (this.ORB & this.DDRB) | (this.lines.via_read_PB() & (this.DDRB ^ 0xFFFFFFFF));
    this.lines.via_write_PB(i, this.DDRB);
  }
      
    
  public void via_write_PB(int orb, int ddrb)
  {
    if ((orb != this.viaOutB) || (ddrb != this.DDRB))
    {
      this.DDRB = ddrb;
      orb |= (this.DDRB ^ 0xFFFFFFFF) & 0xFF; // wherever ddrb is input -> place a one
      this.viaOutB = orb;
      fireInt(1, orb, ddrb);
    }
    this.viaInB = paramInt1;
  }
*/

private boolean setPB6FromVectrex(int tobe_via_orb, int tobe_via_ddrb, boolean orbInitiated)
    {
        boolean b=false;
        // pb6 = input (ddra = 0) than pb6 always = 1
        // pb6 = output (ddra = 1) than pb6 always = value that was written to pb6 (should always be 0 using BIOS)
        
        
        int npb6 = tobe_via_orb & tobe_via_ddrb & 0x40; // all output (0x40)
        if ((tobe_via_ddrb & 0x40) == 0x00)  npb6 = npb6 | 0x40; // all input (0x40)
        b = npb6 != 0;
pb6_out = npb6;
        cart.setPB6FromVectrex(b);
        if (config.breakpointsActive) checkExternalLineBreakpoint(b);
        return b;
    }    

    // called befor VIA is changed
    // so we have access to old via data

    // returns state of PB6
    // calls cart on line change
    private boolean setPB6FromVectrex_old(int tobe_via_orb, int tobe_via_ddrb, boolean orbInitiated)
    {
        // below we do output to all bits
        // we are only really interested in PB6
        // and rather interested in the LINE EXTERNAL
        
        // LINE EXTERNAL has some odd behavior, it
        // automatically switches to a state when the corresponding DDRB register is set to out/in
        
        // when the bit 6 of DDRB is cleared (INPUT mode) 
        // LINE EXTERNAL GOES HIGH
        
        // when the bit 6 of DDRB is set (OUTPUT mode) 
        // LINE EXTERNAL GOES LOW
        
        // once set to output, PB6 can be "controlled", by setting it 
        // in (through) ORB
        
        // so basically there are two methods to control the state of the xternal line
        // below oring and exoring considers that
        // the cart which might be efrected by the line change 
        // e.g. bankswitching test is than only called
        // if the state of the EXTERNAL LINE has changed
        
        
        // it can happen, that "nothing" changes 
        // if that is the case pb6 should ALSO not change
        // this is not obvious,
        // if ddrb is set as input
        // input changed pb6 to low
        // and than ddrb is AGAIN set as input, pb6 should NOT change to high, since 
        // really nothing changed!
        // if we don't test this, in the example pb6 would go high!
        if ((via_orb == tobe_via_orb) && (via_ddrb == tobe_via_ddrb))
        {
            return pb6_out != 0;
        }

        // get output value of via b NOW
        int viaOutNow = ((via_orb&(0xff-0x40))|pb6_out) | (via_ddrb ^ 0xFFFFFFFF) & 0xFF;

        
        boolean pb6 = pb6_out != 0;
        
        if ((tobe_via_orb != viaOutNow) || (tobe_via_ddrb != via_ddrb))
        {
            // get output of changed port b
            int viaOutTobe = tobe_via_orb |((tobe_via_ddrb ^ 0xFFFFFFFF) & 0xFF);
            
            if (!orbInitiated)
            {
                if ((tobe_via_ddrb &0x40) == 0x40)
                    viaOutTobe = viaOutTobe & (0xff-0x40);
                else
                    viaOutTobe = viaOutTobe | 0x40;
            }
            pb6 = (viaOutTobe&0x40) == 0x40;
            cart.setPB6FromVectrex(pb6);
            if (config.breakpointsActive) checkExternalLineBreakpoint(pb6);
            old_pb6 = pb6;
        }
        if (pb6)
        {
            pb6_out = 0x40;
          
            if (!cart.isDualVec())
            {
                if (!cart.isExtra8000Ram2k())
                {
                    if (orbInitiated)
                        if ((via_ddrb & 0x40) == 0x40)
                            pb6_in = pb6_out; // pull up?
                    if (!orbInitiated)
                        if ((tobe_via_ddrb & 0x40) == 0x40)
                            pb6_in = pb6_out; // pull up?
                    pb6_in = pb6_out; // pull up?
                }
            }
        }
        else
        {
            pb6_out = 00;
        }
        return pb6;
    }    
    
    /* perform a single cycle worth of via emulation.
     * via_sstep0 is the first postion of the emulation.
     */
    void via_sstep0()
    {
        int t2shift;
        if (via_t1on!=0) 
        {
            
            via_t1c--;
            if ((via_t1c & 0xffff) == 0xffff) // two cycle "MORE" since in via manual it says timer runs 1,5 cycles to long
            {
                /* counter just rolled over */
                if ((via_acr & 0x40) != 0)
                {
                    /* continuous interrupt mode */
                    via_ifr |= 0x40;
                    int_update ();
                    if (config.breakpointsActive)
                    {
                        if ((via_acr & 0x80)!=0)  
                        {
                            if (via_t1pb7==0x80)
                                checkVIABreakpoint(0, via_orb, via_orb-0x80); 
                            else
                                checkVIABreakpoint(0, via_orb, via_orb+0x80); 
                        }
                    }
                    via_t1pb7 = 0x80 - via_t1pb7;
                    doCheckRamp(false);
                    /* reload counter */

                    via_t1c = (via_t1lh << 8) | via_t1ll;
                } 
                else 
                {
                    /* one shot mode */
                    // reload timer
                    via_t1c = (via_t1lh << 8) | via_t1ll;
                    
                    via_t1c++; // reloading takes one cycle?
                    // reloaded value is shown "false" in vecxi since it show "value+"
                    // the real VIA shows hi ff, lo 0 and than the "real" value appears next round
                    
// regardless of interrup, the t1pb7 is set when timer expired                
// changed for VectorPatrol 13.01.2018, string print routine                     
                    if (via_t1pb7 != 0x80)
                    {
                        via_t1pb7 = 0x80;
                        if (config.breakpointsActive)
                        {
                            if ((via_acr & 0x80)!=0)  
                            {
                                if (via_t1pb7!=0x80)
                                    checkVIABreakpoint(0, via_orb, via_orb+0x80); 
                            }
                        }
                        doCheckRamp(false);
                    }
                    else
                    {
                        via_t1pb7 = 0x80;
                    }
                    if (via_t1int != 0) 
                    {
                        via_ifr |= 0x40;
                        int_update ();
                        via_t1int = 0;
                    }
                }
            }
        }

        if ((via_t2on!=0) && (via_acr & 0x20) == 0x00) 
        {
            via_t2c--;
            if ((via_t2c & 0xffff) == 0xffff) // two cycle "MORE" since in via manual it says timer runs 1,5 cycles to long
            {
                /* one shot mode */
                if (via_t2int!=0) 
                {
                    via_ifr |= 0x20;
                    int_update ();
                    via_t2int = 0;
                    syncImpulse = true;
                }
            }
        }

        // shift counter 
        via_src--;
        if ((via_src & 0xff) == 0xff) 
        {
            via_src = via_t2ll;
            if (via_srclk == 3) 
            {
                t2shift = 1;
                via_srclk = 0;
            } 
            else 
            {
                t2shift = 0;
                via_srclk = (via_srclk+1)%4;
            }
        } 
        else 
        {
            t2shift = 0;
        }

        if (via_srb < 8) 
        {
            switch (via_acr & 0x1c) 
            {
                case 0x00:
                    // disabled 
                    break;
                case 0x04:
                    // shift in under control of t2 
                    if (t2shift!=0) 
                    {
                        // shifting in 0s since cb2 is always an output 
                        via_sr <<= 1;
                        via_srb++;
                    }
                    break;
                case 0x08:
                    // shift in under system clk control 
                    via_sr <<= 1;
                    via_srb++;
                    break;
                case 0x0c:
                    // shift in under cb1 control 
                    break;
                case 0x10:
                    // shift out under t2 control (free run) 
                    if (t2shift!=0) 
                    {
                        via_cb2s = (via_sr >> 7) & 1;
                        via_sr <<= 1;
                        via_sr |= via_cb2s;

                        timerAddItem(via_cb2s, sig_blank, (via_cb2s==1) ? TIMER_BLANK_OFF_CHANGE : TIMER_BLANK_ON_CHANGE);
                    }
                    break;
                case 0x14:
                    /// shift out under t2 control 
                    if (t2shift!=0) 
                    {
                        via_cb2s = (via_sr >> 7) & 1;
                        via_sr <<= 1;
                        via_sr |= via_cb2s;
                        timerAddItem(via_cb2s, sig_blank, (via_cb2s==1) ? TIMER_BLANK_OFF_CHANGE : TIMER_BLANK_ON_CHANGE);
                        via_srb++;
                    }
                    break;
                case 0x18:
/*                    
                    // shift out under system clock control 
*/                    
                    // System Time -> look at hardware manual
                    // only every SECOND cycle!
                    alternate = !alternate;
                    if (alternate)
                    {
                        via_cb2s = (via_sr >> 7) & 1;
                        via_sr <<= 1;
                        via_sr |= via_cb2s;
                        timerAddItem(via_cb2s, sig_blank, (via_cb2s==1) ? TIMER_BLANK_OFF_CHANGE : TIMER_BLANK_ON_CHANGE);
                        via_srb++;
                    }
                    break;
                case 0x1c:
                    // shift out under cb1 control 
                    break;
            }
            
            if (via_srb == 8)
            {
                via_ifr |= 0x04;
                int_update ();
                lastShift = via_cb2s;
            }
        }
        else
        {
            if (config.viaShift9BugEnabled)
            {
                if ((via_acr & 0x1c) ==0x18)
                {
                    if (via_srb==8)
                    {
                        alternate = !alternate;
                        if (alternate)
                        {
                            via_srb=9;
                        }
                    }
                    // last shift is repeated, -> 18 cycles 
                    if (via_srb == 9) 
                    {
                        via_cb2s = lastShift;
                        timerAddItem(via_cb2s, sig_blank, (via_cb2s==1) ? TIMER_BLANK_OFF_CHANGE : TIMER_BLANK_ON_CHANGE);
                        via_srb++;
                    }                
                }                
            }
        }
    }
    /* perform the second part of the via emulation */
    void via_sstep1()
    {
        if ((via_pcr & 0x0e) == 0x0a) 
        {
            /* if ca2 is in pulse mode, then make sure
             * it gets restored to '1' after the pulse.
             */
            via_ca2 = 1;
            timerAddItem(via_ca2,sig_zero, TIMER_ZERO);
        }

        if ((via_pcr & 0xe0) == 0xa0) 
        {
            /* if cb2 is in pulse mode, then make sure
             * it gets restored to '1' after the pulse.
             */
            via_cb2h = 1;
            timerAddItem(via_cb2h, sig_blank, (via_cb2h==1) ? TIMER_BLANK_OFF_CHANGE : TIMER_BLANK_ON_CHANGE);
        }

        // documentation of VIA
        if (via_ca1 !=old_via_ca1)
        {
            if (config.breakpointsActive) checkVIABreakpoint(16, old_via_ca1, via_ca1);
            if ((via_pcr & 0x01) == 0x01) // interrupt flag is set by transition low to high
            {
                if (via_ca1 != 0)
                {
                    via_ifr = via_ifr | 0x02;
                    int_update();
                }
            }
            else // ((via_pcr & 0x01) == 0x00) // interrupt flag is set by transition high to low
            {
                if (via_ca1 == 0)
                {
                    via_ifr = via_ifr | 0x02;
                    int_update();
                }
            }
        }
        old_via_ca1 =via_ca1;// NEW

    }
    
    // input in vectrex coordinates!
    // transformed to upper left corner. (is 0,0)
    // values from 0 to ALG_MAX_X and 0 to ALG_MAX_Y
    void alg_addline (int x0, int y0, int x1, int y1, int color, int speed, int left, int right)
    {
        alg_addline ( x0,  y0,  x1,  y1,  color, false, speed,  left,  right);
    }
    
    void alg_addline (int x0, int y0, int x1, int y1, int color, boolean midChange, int speed, int left, int right)
    {
        
        alg_curr_x= (int )alg_curr_x;
        alg_curr_y= (int )alg_curr_y;
        
        
        if (config.useRayGun) return;
        
        
        
//        if ((cyclesRunning-lastAddLine<15) && (x0==x1) && (y0==y1))
        if (cyclesRunning-lastAddLine<15)
        {
            float driftXMax = 1+(float)Math.abs( (cyclesRunning-lastAddLine)*config.drift_x);
            float driftYMax = 1+(float)Math.abs( (cyclesRunning-lastAddLine)*config.drift_y);

            int xDif = Math.abs(x0-x1);
            int yDif = Math.abs(y0-y1);
            if ((xDif<=driftXMax) && (yDif<=driftYMax))
            {
                lastAddLine = cyclesRunning;
                return; // this is a more or less "immediate" change of to flags (ramp/blank) and should not be TWO lines (or rather a line and a point)
            }
        }


        lastAddLine = cyclesRunning;
        int index;

        x0+=zeroRetainX;
        x1+=zeroRetainX;
        y0+=zeroRetainY;
        y1+=zeroRetainY;
        
        if (imagerMode)
        {
            if (((left == -1)||(left == 0)) && ((right==-1)||(right == 0))) return;
        }

        // possibly add some brightness!
        if (vectorDisplay[displayedNext].count >=vectorDisplay[displayedNext].vectrexVectors.length)
        {
            if ((!toManyvectors))
            {
                log.addLog("To many vectors - can't draw!", ERROR);
            }
            toManyvectors = true;
            return ;
        }
        toManyvectors = false;
        
        vector_t v = vectorDisplay[displayedNext].vectrexVectors[vectorDisplay[displayedNext].count];
        v.speed = speed;
        v.x0 = x0;
        v.y0 = y0;
        v.x1 = x1;
        v.y1 = y1;
        v.midChange = midChange;
        v.color = color;
        v.imagerColorLeft = left;
        v.imagerColorRight = right;
        v.intensityDrift = intensityDriftNow = 1;
        if (intensityDrift>100000)
        {
           double degradePercent = (180000000.0-((double)intensityDrift))/180000000.0; // two minutes
           if (degradePercent<0) degradePercent = 0;
           v.color = (int)(((double)color)*degradePercent);
           v.intensityDrift = intensityDriftNow = degradePercent;
//            v.imagerColorLeft =  (int)(((double)left)*degradePercent);
//            v.imagerColorRight =  (int)(((double)right)*degradePercent);
        }

        if (config.vectorInformationCollectionActive)
        {
            if (v.callStack == null)
            {
                v.callStack = new ArrayList<Integer>();
            }
            else
            {
                v.callStack.clear();
            }
            // deepcopy current callstack
            for (int i : e6809.callStack) v.callStack.add(i);

            // also add current pc
            v.callStack.add(e6809.reg_pc);
        }
        if (directDrawActive)
        {
            if (vectorDisplay[displayedNow].count<VECTOR_CNT)
            {
                directDrawVector = vectorDisplay[displayedNow].vectrexVectors[vectorDisplay[displayedNow].count];
                vectorDisplay[displayedNow].count++;
                directDrawVector.x0 = x0;
                directDrawVector.y0 = y0;
                directDrawVector.x1 = x1;
                directDrawVector.y1 = y1;
                directDrawVector.speed = speed;
                directDrawVector.midChange = midChange;

                directDrawVector.color = 127;
                directDrawVector.imagerColorLeft = left;
                directDrawVector.imagerColorRight = right;
                displayer.directDraw(directDrawVector);                
            }

        }
        vectorDisplay[displayedNext].count++;
    }
    
    public double getBeamPosX()
    {
        return alg_curr_x;
    }
    public double getBeamPosY()
    {
        return alg_curr_y;
    }
    public void setCyclesRunning(long n)
    {
        cyclesRunning = n;
        if (cart != null)
            cart.setCyclesRunning(n);
    }
    public DisplayerInterface getDisplayer()
    {
        return displayer;
    }
    
    public void vectrexNonCPUStepDontAdd(int cycles)
    {
        if (!config.cycleExactEmulation) return;
        for (int c = 0; c < cycles; c++) 
        {
            if (cart != null) cart.cartStep(cyclesRunning);
            via_sstep0();
            timerDoStep();
            // timer after via, to make sure befor analog step, that 0 timers are respected!
            analogStep();
            if (joyport[0] != null) joyport[0].step();
            if (joyport[1] != null) joyport[1].step();
            via_sstep1();
//            nonCPUStepsDone++;
//            cyclesRunning++;
        }
    }    
    public void vectrexNonCPUStep(int cycles)
    {
        if (!config.cycleExactEmulation) return;
        for (int c = 0; c < cycles; c++) 
        {
            if (cart != null) cart.cartStep(cyclesRunning);
            via_sstep0();
            timerDoStep();
            // timer after via, to make sure befor analog step, that 0 timers are respected!
            analogStep();
            if (joyport[0] != null) joyport[0].step();
            if (joyport[1] != null) joyport[1].step();
            via_sstep1();
            nonCPUStepsDone++;
            cyclesRunning++;
            if (peerOutputEnabled)
                doPeerOutput();
        }
    }
    boolean peerOutputEnabled = false;
    boolean wasSync = false;
    double hzStep = 1.0/1500000.0;
    double hzStepHalf = (1.0/1500000.0)/2.0;
    synchronized public void doPeerOutput()
    {
        double t1 = ((double)cyclesRunning) * hzStep;
        double t2 = ((double)cyclesRunning) * hzStep + hzStepHalf;

        StringBuffer b=new StringBuffer();
        
        int portA = e6809_readOnly8(0xd001);
        b.append(String.format("%02X", (portA & 0xFF)))  ;

        int portB = e6809_readOnly8(0xd000);
        portB = portB & (0x07); // only lowest 3 bits
        // BIT 0x08 NOT used!

        if (sig_ramp.intValue  != 0) portB+= 0x10;
        if (sig_blank.intValue  != 0) portB+= 0x20;
        if (sig_zero.intValue  != 0) portB+= 0x40;
        if (wasSync) portB+= 0x80;
 
        b.append(String.format("%02X", (portB & 0xFF)))  ;

        wasSync = false;
        if (pw != null)
        {
            try
            {
                pw.print(""+b.toString()+"\n");
            }
            catch (Throwable e)
            {
                e.printStackTrace();
            }
        }
    }
    synchronized void doPeerSync()
    {
        wasSync = true;
        /*
        if (pw != null)
        {
            try
            {
                pw.print("SYNC\n");
            }
            catch (Throwable e)
            {
                e.printStackTrace();
            }
        }
        */
    }
    PrintWriter pw = null;
    synchronized public void setPeerOutputEnabled(boolean z)
    {
        peerOutputEnabled = z;
        if (!peerOutputEnabled)
        {
            pw.close();
            pw = null;
        }
        else
        {
            if (pw == null)
            {
                try
                {
                    FileWriter fstream = new FileWriter(Global.mainPathPrefix+"logs"+File.separator+"peerOutput"+".csv",true);
                    pw = new PrintWriter(fstream);
//                    pw.append("Time[s], Bit1, Bit2, Bit3, Bit4, Bit5, Bit6, Bit7, Bit8, S/H, Sel0, Sel1, Compare, !RAMP, !BLANK, !ZERO, E(CLK)\n");
                    pw.append("XXYY: X hex porta, YY hex bits szbr#10h h=S/H, 0=Sel0, 1=Sel1, #=unused , r=!RAMP, b=!BLANK, z=!ZERO, s = sync before these values\n");
                }
                catch (Throwable e)
                {
                    e.printStackTrace();
                    System.out.println("WriteFile could not be created!");
                }
            }
        }
    }



    
    public long getCycles()
    {
        return cyclesRunning;
    }
    public boolean isDebugging()
    {
        return debugging;
    }
    void stopEmulation()
    {
        debugging = true;
        stop = true;
    }

    int vecx_emu(long cyclesOrg)
    {
        stop = false;
        int c, icycles;
        long cycles = cyclesOrg;
        long cyclesStart = cyclesRunning;
        int reason = EMU_EXIT_CYCLES_DONE;
        breakpointExit=EMU_EXIT_CYCLES_DONE;
        activeBreakpoint.clear();
        if (cyclesOrg<=1) debugging = true; else debugging = false;
        tmp.clear(); // breakpoint (one time) that must be deleted

        // if emulation is run from a "behind" step
        // discard all forward steps
        if (ringSSWalkStep != -1)
        {
            ringSSBufferNext = (ringSSWalkStep+1)%SS_RING_BUFFER_SIZE;
            ringSSWalkStep = -1;
        }
        if (ringFrameWalkStep != -1)
        {
            ringSSBufferNext = (ringFrameWalkStep+1)%SS_RING_BUFFER_SIZE;
            ringFrameWalkStep = -1;
        }
        
        while ((cycles > 0) && (!stop))
        {
            nonCPUStepsDone = 0;
            // see: http://oldies.malban.de/firstvectrex/vectrex/UNSORTED/text/6809/HTML/UP05.HTM
            int pc = e6809.reg_pc%65536;
            if (pc == 0xf07b)
            {
                if (e6809_readOnly8(0xf617) == 0x32)
                {
                    // fix Malban Bios
                    loadOrgBios();
                }
            }
            if (pc == 0xf1a2)
            {
                thisWaitRecal = true;
            }
            
            int oldAdr = e6809.reg_pc%65536;
            icycles = e6809.e6809_sstep(via_ifr & 0x80, firq);
    
            firq = 0;
            if (config.codeScanActive) 
            {
                for (int i=0; i<icycles; i++)
                {
                    dissiMem.mem[(pc+i)%65536].addAccess(oldAdr, e6809.reg_dp, MEMORY_CODE);
                }
            }
            if (config.doProfile)
            {
                if (profiler != null)
                {
                    profiler.accessed(oldAdr, icycles);
                    profiler.checkContext(this);
                }
            }
            for (c = 0; c < (icycles-nonCPUStepsDone); c++) 
            {
                if (cart != null) cart.cartStep(cyclesRunning);
                via_sstep0();
                timerDoStep();
                // timer after via, to make sure befor analog step, that 0 timers are respected!
                analogStep();
                if (joyport[0] != null) joyport[0].step();
                if (joyport[1] != null) joyport[1].step();
                via_sstep1();
                cyclesRunning++;
            }

            if (waitRecalActive) checkWaitRecal();

            cycles -= (long) icycles;
            fcycles -= (long) icycles;
            soundCycles -= (long) icycles;
            boolean doSync = false;
            if (config.autoSync)
            {
                // imager games can be synced to their generated interrupt!
                if ((imagerMode)&& ((via_ier &0x02) == 0x02))
                {
                    if (((via_ifr &0x02) == 0x02) && ((via_ier &0x02) == 0x02) && (!e6809.get_cc(E6809.FLAG_I)))
                    {
                        doSync = true;
                        lastSyncCycles = cyclesRunning;
                    }
                        
                }
                else
                {
                    if (syncImpulse)
                    {
                        // some carts use T2 for other timing (like digital output), these timers are "realy" small compared to 50 Hz
                        if (cyclesRunning - lastSyncCycles < 20000) // do not trust T2 timers which are to lo!
                        {
                            lastSyncCycles = cyclesRunning;
                            syncImpulse = false;
                        }
                    }
                    if (syncImpulse)
                    {
                        // this check evens out some peaks above the 3000cycle range
                        if (cyclesRunning - lastWaitRecal < 100000)
                        {
                            if (thisWaitRecal)
                            {
                                lastSyncCycles = cyclesRunning;
                                doSync = true;
                            }
                        }
                        else
                        {
                            lastSyncCycles = cyclesRunning;
                            doSync = true;
                        }
                    }
                    else if (fcycles < 0) 
                    {
                        doSync = true;
                    }
                }
            }
            else
            {
                if (fcycles < 0) 
                {
                    doSync = true;
                }
            }
            
            if (doSync)
            {
                if (peerOutputEnabled)
                    doPeerSync();
                if (thisWaitRecal)
                {
                    thisWaitRecal = false;
                    lastWaitRecal = cyclesRunning;
                }                

                syncImpulse = false;
                fcycles = FCYCLES_INIT;
                if (!config.useRayGun)
                {
                    displayedNext = (displayedNext+1) %2;
                    displayedNow =  (displayedNow+1)  %2;
                    displayer.updateDisplay();
                    vectorDisplay[displayedNext].count = 0;
                    vectorDisplay[displayedNext].resetBorders();
                }
                else
                {
                    displayer.switchDisplay();
                    displayer.updateDisplay();
                }                
            }
            if (config.ringbufferActive)
                addStateToRingbuffer();     
            checkCPUBreakpoints(icycles);
            checkAnalogBreakpoint();
            
            for (Breakpoint bp: tmp) 
                displayer.breakpointRemove(bp); // circumvent concurrent modification
            
            if (activeBreakpoint.size() != 0)
            {
                debugging = true;
                cyclesDone=cyclesRunning-cyclesStart;
                return breakpointExit;
            }
            /*
            if (checkRAMPointers())
            {
                debugging = true;
                cyclesDone=cyclesRunning-cyclesStart;
                return breakpointExit;
            }
*/

            //Fill buffer and call core to update sound
            // no sound while debugging (cycledOrg == 1)
            if (soundCycles<=0)
            {
                soundCycles = 37500; // on 100% speed this is every 25ms Hz 40
                if (cyclesOrg>1)
                {
                    e8910.updateSound();
                    if ((cart != null) && (cart.isSIDEnabled()))
                    {
                        cart.updateSound();
                    }
                }
            }
            if (config.scanForVectorLists)
            {
                VectorListScanner.check(e6809, cart, this);
            }
            if (recording) 
            {
                if (recordingIsAddress)
                {
                    if (e6809.reg_pc == recordingAddress)
                    {
                        addSoundRecord();
                    }
                }
                else
                {
                    if (cyclesRunning - lastRecordCycle >= recordingAddress)
                    {
                        addSoundRecord();
                        lastRecordCycle = cyclesRunning;
                    }
                }
            }
        }
        e6809.callstackSanityCheck();
        
        cyclesDone=cyclesRunning-cyclesStart;
        
        return reason;
    }
    
    
    int vecx_emu_plain(long cyclesOrg)
    {
        stop = false;
        int c, icycles;
        long cycles = cyclesOrg;
        long cyclesStart = cyclesRunning;
        int reason = EMU_EXIT_CYCLES_DONE;
        breakpointExit=EMU_EXIT_CYCLES_DONE;

        while ((cycles > 0) && (!stop))
        {
            nonCPUStepsDone = 0;
            thisWaitRecal = ((e6809.reg_pc%65536) == 0xf1a2);

            
            
            
            
            
            icycles = e6809.e6809_sstep_opt(via_ifr & 0x80, firq);
            
            firq = 0;
            for (c = 0; c < (icycles-nonCPUStepsDone); c++) 
            {
                // these are only "specials" like ds chips...
                if (cart != null) cart.cartStep(cyclesRunning);
                via_sstep0();
                timerDoStep();
                // timer after via, to make sure befor analog step, that 0 timers are respected!
                analogStep();
                if (joyport[0] != null) joyport[0].step();
                if (joyport[1] != null) joyport[1].step();
                via_sstep1();
                
                cyclesRunning++;
            }

            cycles -= (long) icycles;
            fcycles -= (long) icycles;
            soundCycles -= (long) icycles;
            boolean doSync = false;
            if (config.autoSync)
            {
                // imager games can be synced to their generated interrupt!
                if ((imagerMode)&& ((via_ier &0x02) == 0x02))
                {
                    if (((via_ifr &0x02) == 0x02) && ((via_ier &0x02) == 0x02) && (!e6809.get_cc(E6809.FLAG_I)))
                    {
                        doSync = true;
                        lastSyncCycles = cyclesRunning;
                    }
                        
                }
                else
                {
                    if (syncImpulse)
                    {
                        // some carts use T2 for other timing (like digital output), these timers are "realy" small compared to 50 Hz
                        if (cyclesRunning - lastSyncCycles < 20000) // do not trust T2 timers which are to lo!
                        {
                            lastSyncCycles = cyclesRunning;
                            syncImpulse = false;
                        }
                    }
                    if (syncImpulse)
                    {
                        // this check evens out some peaks above the 3000cycle range
                        if (cyclesRunning - lastWaitRecal < 100000)
                        {
                            if (thisWaitRecal)
                            {
                                lastSyncCycles = cyclesRunning;
                                doSync = true;
                            }
                        }
                        else
                        {
                            lastSyncCycles = cyclesRunning;
                            doSync = true;
                        }
                    }
                    else if (fcycles < 0) 
                    {
                        doSync = true;
                    }
                }
            }
            else
            {
                if (fcycles < 0) 
                {
                    doSync = true;
                }
            }
            
            if (doSync)
            {
                if (thisWaitRecal)
                {
                    thisWaitRecal = false;
                    lastWaitRecal = cyclesRunning;
                }                

                syncImpulse = false;
                fcycles = FCYCLES_INIT;

                displayedNext = (displayedNext+1) %2;
                displayedNow =  (displayedNow+1)  %2;
                displayer.updateDisplay();
                vectorDisplay[displayedNext].count = 0;
                vectorDisplay[displayedNext].resetBorders();
            }
            
            //Fill buffer and call core to update sound
            // no sound while debugging (cycledOrg == 1)
            if (soundCycles<=0)
            {
                soundCycles = 37500; // on 100% speed this is every 25ms Hz 40
                e8910.updateSound();
                if ((cart != null) && (cart.isSIDEnabled()))
                {
                    cart.updateSound();
                }
            }
        }
        cyclesDone=cyclesRunning-cyclesStart;
        return reason;
    }
    
    
    
    
    
    
    
    
    
    public VectrexDisplayVectors getDisplayList()
    {
        return vectorDisplay[displayedNow];
    }
    public void poke(int address, byte value)
    {
        if ((address & 0xe000) == 0xe000) 
        {
            /* rom */
            rom[address-0xe000] = value;
        } 
        else if ((address & 0xe000) == 0xc000) 
        {
            /* it is possible for both ram and io to be written at the same! */
            if ((address & 0x800) != 0)
            {
                ram[address & 0x3ff] = value;
                checkMemWriteBreakpoint(address & 0x3ff, value);
            }
            if ((address & 0x1000) != 0)
            {
                e6809_write8(address, value);
            }
        } 
        else // if (address < 0x8000) 
        {
            cart.write(address, value);
        }
    }

    // 8k BIOS
    private boolean loadBios()
    {
        try
        {
            Path path = Paths.get(Global.mainPathPrefix+config.usedSystemRom);
            byte[] biosData = Files.readAllBytes(path);
            for (int i=0; i< biosData.length;i++)
            {
                rom[i] = biosData[i]&0xff;
            }
        }
        catch (Throwable e)
        {
            log.addLog(e, ERROR);
            return false;
        }        
        return true;
    }
    private boolean loadOrgBios()
    {
        try
        {
            Path path = Paths.get(Global.mainPathPrefix+"system"+File.separator+"system.img");
            byte[] biosData = Files.readAllBytes(path);
            for (int i=0; i< biosData.length;i++)
            {
                rom[i] = biosData[i]&0xff;
            }
        }
        catch (Throwable e)
        {
            log.addLog(e, ERROR);
            return false;
        }        
        return true;
    }

    public boolean init(CartridgeProperties cartProp)
    {
        initRam();
        
        config.resetCartChanges();
        /*
        atmelEnabled = false;
        ds2430Enabled = false;
        ds2431Enabled = false;
        microchipEnabled = false;
        sidEnabled = false;
        isDualVec = false;
        */
        log.addLog("vecx: init cart: " + cartProp.mName, INFO);

        if (!loadBios()) 
        {
            log.addLog("Vecx: init() BIOS of vectrex not loaded!", WARN);
            return false;
        }
        
        try
        {
            cart.setVecx(this);
            // load Cartridge
            if (!cart.init(cartProp)) 
            {
                log.addLog("Vecx: init() cartridge not loaded!", WARN);
                return false;
            }
            /*
            atmelEnabled = (cartProp.getTypeFlags()&FLAG_ATMEL_EEPROM)!=0;
            ds2430Enabled = (cartProp.getTypeFlags()&FLAG_DS2430A)!=0;
            ds2431Enabled = (cartProp.getTypeFlags()&FLAG_DS2431)!=0;
            microchipEnabled = (cartProp.getTypeFlags()&Cartridge.FLAG_MICROCHIP)!=0;
            sidEnabled = (cartProp.getTypeFlags()&Cartridge.FLAG_SID)!=0;
            isDualVec = (cartProp.getTypeFlags()&Cartridge.FLAG_DUALVEC1)!=0;
            isDualVec = isDualVec || ((cartProp.getTypeFlags()&Cartridge.FLAG_DUALVEC2)!=0);
            */

            e6809.e6809_reset();  
            vecx_reset();
        }
        catch (Throwable e)
        {
            log.addLog(e, ERROR);
            return false;
        }
        return true;    
    }    
    // init new emulation
    public boolean init(String filenameRom)
    {
        return init(filenameRom, true);
    }
    
    public boolean init(String filenameRom, boolean checkForCartridge)
    {
        return init(filenameRom, checkForCartridge, false);
    }
    public boolean init(String filenameRom, boolean checkForCartridge, boolean fromPanel)
    {
        initRam();
        config.resetCartChanges();
        cart = new Cartridge();
        /*
        atmelEnabled = false;
        ds2430Enabled = false;
        ds2431Enabled = false;
        microchipEnabled = false;
        sidEnabled = false;
        
        isDualVec = false;
        isDualVec = false;
        */
        joyport[0].deinit();
        joyport[1].deinit();
        romName = de.malban.util.UtilityFiles.convertSeperator(filenameRom);
        if (checkForCartridge)
        {
            CartridgeProperties cartProp = CartridgePropertiesPanel.getCartridgeProp(filenameRom);
            if (cartProp != null)
            {
                boolean loadit = true;
                File f = new File (filenameRom);
                if (f.exists())
                {
                    Vector<String> f1 = cartProp.getFullFilename();
                    if (f1 == null) loadit = false;
                    else
                    {
                        if (f1.size()<=0) loadit = false;
                        else
                        {
                            String f2 = de.malban.util.UtilityFiles.convertSeperator(f1.elementAt(0));
                            loadit = (filenameRom.contains(f2));
                        }
                    }
                    
                }
                if (loadit)
                {
                    if (fromPanel)
                    {
                        ShowWarningDialog.showWarningDialog("Cartridge found!", "For the supplied vectrex binary\n(based on the name)\na cartridge definition was found.\n\nThe cartridge was loaded!");
                    }
                    return init(cartProp);
                }
            }
        }
        if (!loadBios()) 
        {
            log.addLog("Vecx: init() BIOS of vectrex not loaded!", WARN);
            return false;
        }
        
        try
        {
            cart.setVecx(this);
            // load Cartridge
            log.addLog("vecx: init rom: " + filenameRom, INFO);
            
            
            
            cart.load(filenameRom);
            e6809.e6809_reset();  
            vecx_reset();
        }
        catch (Throwable e)
        {
            log.addLog(e, ERROR);
            return false;
        }
        return true;
    }
    
    public boolean inject(String filenameRom, boolean checkForCartridge)
    {
        cart = new Cartridge();
        romName = filenameRom;
        
        try
        {
            cart.load(filenameRom);
        }
        catch (Throwable e)
        {
            log.addLog(e, ERROR);
            return false;
        }
        return true;
    }    
    public boolean inject(CartridgeProperties cartProp)
    {
        
        try
        {
            // load Cartridge
            if (!cart.inject(cartProp)) 
            {
                log.addLog("Vecx: init() cartridge not loaded!", WARN);
                return false;
            }
        }
        catch (Throwable e)
        {
            log.addLog(e, ERROR);
            return false;
        }
        return true;    
    }        
    // caller must ensure, that no
    // concurrent modification is done on the data
    // otherwise an exception will occur!
            
    public CompleteState getState()
    {
        CompleteState state = new CompleteState();
        state.rom = rom;
        cart.initStateSave();

        state.sidState = null;
        if ((cart != null) && (cart.isSIDEnabled()))
        {
            if (cart.vsid != null)
            {
                state.sidState = cart.vsid.oldState;
            }
        }

        state.cart = cart;
        
        state.putState(this);
        state.putState(this.e6809);
        state.putState(this.e8910);
        
        if (imagerMode)
            state.putState((Imager3dDevice)joyport[1].getDevice());
        
        return state;
    }
    public boolean putState(CompleteState state)
    {
        try 
        {
            joyport[0].deinit();
            joyport[1].deinit();
            // this is sort of bad
            // but a shortcut to reinitializing listerners
            ArrayList<CartridgeListener> mListener = cart.getListener();
            
            rom = state.rom;
            cart = state.cart;
            if (state.cart.isSIDEnabled())
            {
                cart.vsid = new VSID(cart);
            }
            
            initFromState(state);
            cart.setListener(mListener);
            cart.init();
            
            if (imagerMode)
            {
                state.imager.setIgnoreReset(true);
                joyport[1].plugIn(state.imager);
                state.imager.setIgnoreReset(false);
            }
            return true;
        } 
        catch (Throwable ex) 
        {
            log.addLog(ex, ERROR);
        }
        return false;
    }    
    void initFromState(CompleteState state)
    {
        E6809State.deepCopy(state.e6809State, this.e6809);
        E8910State.deepCopy(state.e8910State, this.e8910);
        VecXState.deepCopy(state.eVecXState, this);
        cart.setBank(currentBank); // just in case a bankswitch occurred
        cart.setVecx(this);
        cart.ds2430.cart = cart;
        cart.microchip.cart = cart;

        if (cart.isSIDEnabled())
        {
            if (cart.vsid == null)
            {
                cart.vsid = new VSID(cart);
                cart.vsid.init();
            }
            cart.vsid.oldState = state.sidState;
        }
        cart.initFromStateSave();
    }
    
    // all ringbuffers should 
    // be called when paused
    // or from "our" thread!
    private void addStateToRingbuffer()
    {
        try
        {
            if (goSSBackRingBuffer[ringSSBufferNext] == null) 
                goSSBackRingBuffer[ringSSBufferNext] = new CompleteState();
            CompleteState state = goSSBackRingBuffer[ringSSBufferNext];
            cart.initStateSave();
            state.sidState = cart.getSidState();
            state.putState(this);
            state.putState(e6809);
            state.putState(e8910);

            ringSSBufferNext = (ringSSBufferNext+1)%SS_RING_BUFFER_SIZE;
            ringSSWalkStep=-1; 


            if ((cyclesRunning%30000) == 0)
            {
                if (goFrameBackRingBuffer[ringFrameBufferNext] == null) 
                    goFrameBackRingBuffer[ringFrameBufferNext] = new CompleteState();
                state = goFrameBackRingBuffer[ringFrameBufferNext];
                state.putState(this);
                state.putState(e6809);
                state.putState(e8910);


                ringFrameBufferNext = (ringFrameBufferNext+1)%FRAME_RING_BUFFER_SIZE;
                ringFrameWalkStep=-1; 
            }
        }
        catch (Throwable e)
        { }

    }  
    // get # of step backs from "0" (current)
    public int getRingbufferPos()
    {
        if (!config.ringbufferActive) return 0;
        int pos = 0;
        if (ringSSWalkStep == -1) return pos;

        int testStep = ringSSWalkStep;
        
        while (true)
        {
            if (testStep==-1) // if first step, than ringBufferNext-2 (-1 would be the last instruction - again, endless loop :-))
                testStep = (ringSSBufferNext+(SS_RING_BUFFER_SIZE-2))%SS_RING_BUFFER_SIZE;
            else
                testStep = (testStep+(SS_RING_BUFFER_SIZE-1))%SS_RING_BUFFER_SIZE;
            // if ringbuffer overflow
            if (ringSSBufferNext==testStep)
            {
                break;
            }
            // if ringbuffer last step is "empty"
            if (goSSBackRingBuffer[testStep] == null) 
            {
                break;
            }
            pos++;
        }
        return pos;
    }
    public boolean stepBackInSSRingbuffer(int steps)
    {
        boolean b = true;
        for (int i=0;i<steps; i++)
            b = b & oneStepBackInSSRingbuffer();
        return b;
    }
    private boolean oneStepBackInSSRingbuffer()
    {
        if (!config.ringbufferActive) return false;
        if (ringSSWalkStep==-1) // if first step, than ringBufferNext-2 (-1 would be the last instruction - again, endless loop :-))
            ringSSWalkStep = (ringSSBufferNext+(SS_RING_BUFFER_SIZE-2))%SS_RING_BUFFER_SIZE;
        else
            ringSSWalkStep = (ringSSWalkStep+(SS_RING_BUFFER_SIZE-1))%SS_RING_BUFFER_SIZE;
        
        // if ringbuffer overflow
        if (ringSSBufferNext==ringSSWalkStep)
        {
            // 
            if (ringSSWalkStep == ((ringSSBufferNext+(SS_RING_BUFFER_SIZE-1))%SS_RING_BUFFER_SIZE))
                ringSSWalkStep=-1;
            else
                ringSSWalkStep=(ringSSWalkStep+1)%SS_RING_BUFFER_SIZE; // preserve current position
            // we are at the end of the ringbuffer!
            return false;
        }
        
        // if ringbuffer last step is "empty"
        if (goSSBackRingBuffer[ringSSWalkStep] == null) 
        {
            if (ringSSWalkStep == ((ringSSBufferNext+(SS_RING_BUFFER_SIZE-1))%SS_RING_BUFFER_SIZE))
                ringSSWalkStep=-1;
            else
                ringSSWalkStep=(ringSSWalkStep+1)%SS_RING_BUFFER_SIZE; // preserve current position
            // not last step was saved (yet)
            return false;
        }
            
        CompleteState state = goSSBackRingBuffer[ringSSWalkStep];
        initFromState(state);
        displayer.directDraw(directDrawVector);
        return true;
    }
    public boolean stepForwardInSSRingbuffer(int steps)
    {
        boolean b = true;
        for (int i=0;i<steps; i++)
            b = b & oneStepForwardInSSRingbuffer();
        return b;
    }
    private boolean oneStepForwardInSSRingbuffer()
    {
        if (!config.ringbufferActive) return false;
        if (ringSSWalkStep == -1)
        {
            // last position was "executed" we can not go further in ringbuffer
            // just do a single step - idiot!
            return false;
        }
        ringSSWalkStep = (ringSSWalkStep+1)%SS_RING_BUFFER_SIZE;
        
        if (goSSBackRingBuffer[ringSSWalkStep] == null) 
        {
            // error!
            // should not happen :-)
            ringSSWalkStep=-1; // preserve current position
            // not last step was saved (yet)
            return false;
        }
            
        CompleteState state = goSSBackRingBuffer[ringSSWalkStep];
        if (ringSSBufferNext==ringSSWalkStep+1)
        {
            ringSSWalkStep=-1; // wie hit the front!
        }
        initFromState(state);

        displayer.directDraw(directDrawVector);
        return true;
    }     
    public boolean stepBackInFrameRingbuffer(int steps)
    {
        boolean b = true;
        for (int i=0;i<steps; i++)
            b = b & oneStepBackInFrameRingbuffer();
        return b;
    }
    private boolean oneStepBackInFrameRingbuffer()
    {
        if (!config.ringbufferActive) return false;
        ringSSWalkStep = -1; // if I step back, what is the position of the step back?
        ringSSBufferNext = 0;
        
        if (ringFrameWalkStep==-1) // if first step, than ringBufferNext-2 (-1 would be the last instruction - again, endless loop :-))
            ringFrameWalkStep = (ringFrameBufferNext+(FRAME_RING_BUFFER_SIZE-2))%FRAME_RING_BUFFER_SIZE;
        else
            ringFrameWalkStep = (ringFrameWalkStep+(FRAME_RING_BUFFER_SIZE-1))%FRAME_RING_BUFFER_SIZE;
        
        // if ringbuffer overflow
        if (ringFrameBufferNext==ringFrameWalkStep)
        {
            // 
            if (ringFrameWalkStep == ((ringFrameBufferNext+(FRAME_RING_BUFFER_SIZE-1))%FRAME_RING_BUFFER_SIZE))
                ringFrameWalkStep=-1;
            else
                ringFrameWalkStep=(ringFrameWalkStep+1)%FRAME_RING_BUFFER_SIZE; // preserve current position
            // we are at the end of the ringbuffer!
            return false;
        }
        
        // if ringbuffer last step is "empty"
        if (goFrameBackRingBuffer[ringFrameWalkStep] == null) 
        {
            if (ringFrameWalkStep == ((ringFrameBufferNext+(FRAME_RING_BUFFER_SIZE-1))%FRAME_RING_BUFFER_SIZE))
                ringFrameWalkStep=-1;
            else
                ringFrameWalkStep=(ringFrameWalkStep+1)%FRAME_RING_BUFFER_SIZE; // preserve current position
            // not last step was saved (yet)
            return false;
        }
            
        CompleteState state = goFrameBackRingBuffer[ringFrameWalkStep];
        initFromState(state);
        displayer.directDraw(directDrawVector);
        return true;
    } 
    public boolean stepForwardInFrameRingbuffer(int steps)
    {
        boolean b = true;
        for (int i=0;i<steps; i++)
            b = b & oneStepForwardInFrameRingbuffer();
        return b;
    }
    private boolean oneStepForwardInFrameRingbuffer()
    {
        if (!config.ringbufferActive) return false;
        if (ringFrameWalkStep == -1)
        {
            // last position was "executed" we can not go further in ringbuffer
            // just do a single step - idiot!
            return false;
        }
        
        ringSSWalkStep = -1; // if I step back, what is the position of the step back?
        ringSSBufferNext = 0;
        
        
        ringFrameWalkStep = (ringFrameWalkStep+1)%FRAME_RING_BUFFER_SIZE;
        
        if (goFrameBackRingBuffer[ringFrameWalkStep] == null) 
        {
            // error!
            // should not happen :-)
            ringFrameWalkStep=-1; // preserve current position
            // not last step was saved (yet)
            return false;
        }
            
        CompleteState state = goFrameBackRingBuffer[ringFrameWalkStep];
        if (ringFrameBufferNext==ringFrameWalkStep+1)
        {
            ringFrameWalkStep=-1; // wie hit the front!
        }
        initFromState(state);

        displayer.directDraw(directDrawVector);
        return true;
    }         
    int getStepoutAddress()
    {
        if (e6809.callStack.size()>0)
        {
            return e6809.callStack.get(e6809.callStack.size()-1);
        }
        return -1;
    }  
    
    void timerDoStep()
    {
        ticksRunning++;
        timerRemoveList.clear();
        timerItemListClone.clear();
        synchronized (timerItemList)
        {
            for (TimerItem t: timerItemList) timerItemListClone.add(t);
        }

        for (TimerItem t: timerItemListClone)
        {
            t.countDown--;
            if (t.countDown <=0)
            {
                if (t.type == TIMER_SHIFT_READ)
                {
                    alternate = true;
                    if (shouldStall((int)(cyclesRunning - lastShiftTriggered), true))
                    {
                        via_stalling = true;
                        via_ifr &= 0xfb; /* remove shift register interrupt flag */
                        via_srclk = 1;
                        int_update ();
                        lastShiftTriggered = cyclesRunning;
                    }
                    else
                    {
                        via_stalling = false;

                        lastShiftTriggered = cyclesRunning;
                        via_ifr &= 0xfb; /* remove shift register interrupt flag */
                        via_srb = 0;
                        via_srclk = 1;
                        int_update ();
                    }
                    
                } 
                else if (t.type == TIMER_T1)
                {
                    via_t1on = 1; /* timer 1 starts running */
                    via_t1lh = (t.valueToSet & 0xff);
                    via_t1c = (via_t1lh << 8) | via_t1ll;
//                    via_t1c += 1; // hack, it seems vectrex (via) takes one cycles to "process" the setting...
                    via_ifr &= 0xbf; /* remove timer 1 interrupt flag */
                    via_t1int = 1;

                    if (config.breakpointsActive)
                    {
                        if ((via_acr & 0x80)!=0)  
                        {
                            if (via_t1pb7!=0)
                                checkVIABreakpoint(0, via_orb, via_orb-via_t1pb7);                  
                        }
                    }
                    via_t1pb7 = 0;
                    doCheckRamp(false);
                    int_update ();
                }
                else if (t.type == TIMER_T2)
                {
                        via_t2c = ((t.valueToSet& 0xff) << 8) | via_t2ll;
                        via_t2c += 0; // hack, it seems vectrex (via) takes two cycles to "process" the setting...
                        via_ifr &= 0xdf;
                        via_t2on = 1; /* timer 2 starts running */
                        via_t2int = 1;
                        int_update ();
                }

                
                
                
                
                
                
                
                
                else if (t.type == TIMER_MUX_R_CHANGE)
                {
                    noiseCycles = cyclesRunning;
                    c_alg_rsh.setDigitalVoltage(t.valueToSet&0xff);
//                    dacOffset = (dacOffset/10.0)+t.valueToSet; 
                    // 10.0 is the easy variant - in reality 
                    // the charging/discharging of the offset would be an RC curve from the old to the new value
                    // and the final value would be determined 
                    // by how long the charging/discharging of the new value took place
                }
                else if (t.whereToSet != null)   
                {
                    if (t.type == TIMER_SHIFT_WRITE)
                    {
                        alternate = true;
                        if (shouldStall((int)(cyclesRunning - lastShiftTriggered), false))
                        {
                            via_stalling = true;
                            via_ifr &= 0xfb; // * remove shift register interrupt flag * /
                            via_srclk = 1;
                            int_update ();
                            timerRemoveList.add(t);
                            continue;
                        }
                        else
                        {
                            via_stalling = false;
                            lastShiftTriggered = cyclesRunning;
                            via_sr = t.valueToSet & 0xff;
                            via_ifr &= 0xfb; /* remove shift register interrupt flag */
                            via_srb = 0;
                            via_srclk = 1;
                            int_update ();
                        }
                    }
                    else if (t.type == TIMER_RAMP_OFF_CHANGE) 
                    {
                        // difference of 3 is to much, but we have no "smaller" unit than
                        // cycles ticks
                        // therefor we calculate a fraction on ticks to be as exact as possible
                        // the fraction here is not KNOWN, it is
                        // experimented
                        // analog curcuits don't really care about cycles...
                        if ((t.whereToSet.intValue& 0xff) != (t.valueToSet & 0xff))
                        {
                            rampOffFraction = true;
                        }
                    }
                    else if (t.type == TIMER_RAMP_CHANGE) 
                    {
                        // difference of 3 is to much, but we have no "smaller" unit than
                        // cycles ticks
                        // therefor we calculate a fraction on ticks to be as exact as possible
                        // the fraction here is not KNOWN, it is
                        // experimented
                        // analog curcuits don't really care about cycles...
                        if ((t.whereToSet.intValue& 0xff) != (t.valueToSet & 0xff))
                        {
                            rampOnFraction = true;
                        }
                    }
/*                    
                    // ATTENTION!
                    // it looks like MUX SEL has a time - offset
                    // but the value that is used to "transport" to the receiving SH
                    // is the one, when "timing" expires, not when the timer is
                    // set
                    // luckily that is ALLWAYS via_ora
                    // so we can take it here directly and ignore the value that
                    // is passed to timing!
                    if (t.type == TIMER_MUX_Y_CHANGE)
                    {
                        // test above "theory" with Y
                        t.whereToSet.intValue = via_ora & 0xff;
                    }
*/
                    t.whereToSet.intValue = t.valueToSet & 0xff;

                    if (t.type == TIMER_MUX_SEL_CHANGE)
                        doCheckMultiplexer();
                
                    if (t.type != TIMER_MUX_Z_CHANGE) // Z must not be negative
                        if (t.whereToSet.intValue >= 128) t.whereToSet.intValue -= 256;
                    
                }
                timerRemoveList.add(t);
            }
        }
        synchronized (timerItemList)
        {
            for (TimerItem t: timerRemoveList)
            {
                timerItemList.remove(t);
                timerHeap.add(t);
            }
        }
    }
    /* update the various analog values when orb is written. */
    void doCheckMultiplexer()
    {
        doCheckJoystick();
        if ((via_orb & 0x01) != 0) return;
        
        /* MUX has been enabled, state changed! */
        switch (alg_sel.intValue & 0x06) 
        {
            case 0x00:
                /* demultiplexor is on */
                timerAddItem(alg_DAC.intValue, alg_ysh, TIMER_MUX_Y_CHANGE);
                break;
            case 0x02:
                /* demultiplexor is on */
                timerAddItem(alg_DAC.intValue, null, TIMER_MUX_R_CHANGE);
                break;
            case 0x04:
                /* demultiplexor is on */
                timerAddItem(alg_DAC.intValue , alg_zsh, TIMER_MUX_Z_CHANGE);
                intensityDrift = 0;
                break;
            case 0x06:
                /* sound output line */
                timerAddItem(alg_DAC.intValue , alg_ssh, TIMER_MUX_S_CHANGE);
                break;
                
        }
    }

    // uses ORA instead of DAC, again this should not be emulation relevant
    void doCheckJoystick()
    {
        switch (via_orb & 0x06) 
        {
            case 0x00:
                if (joyport[0] != null) alg_jsh = joyport[0].getHorizontal(); else alg_jsh = JOYSTICK_CENTER;
                break;
            case 0x02:
                if (joyport[0] != null) alg_jsh = joyport[0].getVertical(); else alg_jsh = JOYSTICK_CENTER;
                break;
            case 0x04:
                if (joyport[1] != null) alg_jsh = joyport[1].getHorizontal(); else alg_jsh = JOYSTICK_CENTER;
                break;
            case 0x06:
                if (joyport[1] != null) alg_jsh = joyport[1].getVertical(); else alg_jsh = JOYSTICK_CENTER;
                break;
        }                
        
        /* compare the current joystick direction with a reference */        
        if ((alg_jsh) > (via_ora^0x80)) // current DAC , here ORA, the XSH can't be used, since it will be set by timer
        {
            alg_compare = 0x20;// bit 5 of ORB
        } 
        else 
        {
            alg_compare = 0x00;
        }        
        
    }    
    void doCheckRamp(boolean fromOrbWrite)
    {
        if (!fromOrbWrite)
        {
            if ((via_acr & 0x80)!=0) 
            {
                if (via_t1pb7==0)
                    timerAddItem(via_t1pb7, sig_ramp, TIMER_RAMP_CHANGE);
                else
                    timerAddItem(via_t1pb7, sig_ramp, TIMER_RAMP_OFF_CHANGE);
            } 
        }
        else
        {
            if ((via_acr & 0x80)==0) 
            {
                if ((via_orb & 0x80) == 0)
                    timerAddItem(via_orb & 0x80 , sig_ramp, TIMER_RAMP_CHANGE);
                else
                    timerAddItem(via_orb & 0x80, sig_ramp, TIMER_RAMP_OFF_CHANGE);
            }
        }
    }

    /* perform a single cycle worth of analog emulation */
    void analogStepColor()
    {
        if (((via_orb & 0x01) == 0) && ((alg_sel.intValue & 0x06) == 0x02))
            c_alg_rsh.doStep();
        
        
        
        intensityDrift++;
        int sig_dx=0, sig_dy=0; // always the delta from the last vector end position, to the new position
                                // even when zero is active!
        if (lastZero != sig_zero.intValue)
        {
            if (sig_zero.intValue == 0)
            {
                // we start zeroing now
                zeroRetainX = (((double)(alg_curr_x-(config.ALG_MAX_X/2))) *config.zeroRetainX);
                zeroRetainY = (((double)(alg_curr_y-(config.ALG_MAX_Y/2))) *config.zeroRetainY);
            }
            lastZero = sig_zero.intValue;
        }
        else
        {
            if (sig_zero.intValue == 0)
            {
                zeroRetainX = (((double)(zeroRetainX)) *0.99);
                zeroRetainY = (((double)(zeroRetainY)) *0.99);
            }
        }
        if (sig_zero.intValue == 0) 
        {
            noiseCycles = cyclesRunning;
            /* need to force the current point to the 'orgin' so just
             * calculate distance to origin and use that as dx,dy.
             */
            // on zero - do not zero immediatly but "degrade" "slowly"
            int absx = (int)Math.abs(alg_curr_x - (config.ALG_MAX_X / 2));
            int absy = (int)Math.abs(alg_curr_y - (config.ALG_MAX_Y / 2));

            
            sig_dx = (int)(((double)(config.ALG_MAX_X / 2 - (int)alg_curr_x))/config.zero_divider);
            sig_dy = (int)(((double)(config.ALG_MAX_Y / 2 - (int)alg_curr_y))/config.zero_divider);
            
        } 
        //else 
        // no else anymore, integrating can be done WHILE zeroing (see my discussion in forum Vectrex32)
        {
            if (sig_ramp.intValue== 0) 
            {
                sig_dx += alg_xsh.intValue;
                sig_dy += -alg_ysh.intValue;
                fractionSaveX = alg_xsh.intValue;
                fractionSaveY = alg_ysh.intValue;

                //fraction = false;
                if (rampOnFraction)
                {
                    rampOnFraction = false;
                    alg_curr_x -= (int)(((double)alg_xsh.intValue)*(config.rampOnFractionValue));
                    alg_curr_y -= -(int)(((double)alg_ysh.intValue)*(config.rampOnFractionValue));

                }
            } 
            else 
            {
                //fraction = false;
                if (rampOffFraction)
                {
                    // with cycle exact programming we are not allowed to use "alg_xsh.intValue" as fraction
                    // value, because that might have been altered in the last "cycle"
                    // we must remember the last integration value and 
                    // use that instead of the current one!
//                    alg_curr_x += (int)(((double)alg_xsh.intValue)*config.rampOffFractionValue);
//                    alg_curr_y += -(int)(((double)alg_ysh.intValue)*config.rampOffFractionValue);
                    rampOffFraction = false;
                    alg_curr_x += (int)(((double)fractionSaveX)*config.rampOffFractionValue);
                    alg_curr_y += -(int)(((double)fractionSaveY)*config.rampOffFractionValue);

                    
                    
                    if (alg_vectoring == 1 && alg_curr_x >= 0 && alg_curr_x < config.ALG_MAX_X && alg_curr_y >= 0 && alg_curr_y < config.ALG_MAX_Y) 
                    {
                        /* we're vectoring ... current point is still within limits so
                         * extend the current vector.
                         */
                        alg_vector_x1 = (int)alg_curr_x;
                        alg_vector_y1 = (int)alg_curr_y;
                    }        
                }
            }
        }

        if (alg_vectoring == 0) 
        {
            if (sig_blank.intValue == 1 ) 
            {
                // new vector should start
                // is oob?
                if (alg_curr_x >= 0 && alg_curr_x < config.ALG_MAX_X && alg_curr_y >= 0 && alg_curr_y < config.ALG_MAX_Y)
                {
                    if (imagerMode)
                    {
                        if (joyport[1].getDevice() instanceof Imager3dDevice)
                        {
                            Imager3dDevice i3d = (Imager3dDevice)joyport[1].getDevice();
                            leftEyeColor = i3d.getLeftColor();
                            rightEyeColor = i3d.getRightColor();
                        }
                    }

                    /* start a new vector */
                    alg_vectoring = 1;

                    alg_vector_dx = alg_xsh.intValue;
                    alg_vector_dy = -alg_ysh.intValue;

                    alg_vector_x0 = (int)alg_curr_x+(int)(config.blankOffDelay*alg_vector_dx);
                    alg_vector_y0 = (int)alg_curr_y+(int)(config.blankOffDelay*alg_vector_dy);
                    alg_vector_x1 = (int)alg_curr_x;
                    alg_vector_y1 = (int)alg_curr_y;

                    alg_vector_speed = Math.max(Math.abs(alg_xsh.intValue), Math.abs(alg_ysh.intValue));

                    alg_leftEye = leftEyeColor;
                    alg_rightEye = rightEyeColor;

                    alg_vector_color = alg_zsh.intValue;
                    alg_ramping = (sig_ramp.intValue== 0);
                    if ((alg_ramping) || (sig_zero.intValue == 0))
                    {
                        alg_spline_compare_dx = sig_dx;
                        alg_spline_compare_dy = sig_dy;
                    }
                    else
                    {
                        alg_spline_compare_dx = Integer.MAX_VALUE;
                        alg_spline_compare_dy = Integer.MAX_VALUE;
                    }                    
                }
                else
                {
// OUT OF BOUNDS                    
                    // OUT OF BOUNDS VECTOR START
                }
            }
        } 
        else // vectoring == 1
        {
            if (imagerMode)
            {
                if (joyport[1].getDevice() instanceof Imager3dDevice)
                {
                    Imager3dDevice i3d = (Imager3dDevice)joyport[1].getDevice();
                    leftEyeColor = i3d.getLeftColor();
                    rightEyeColor = i3d.getRightColor();
                }
            }
            boolean yChanged = (-alg_ysh.intValue != alg_vector_dy) && (sig_ramp.intValue== 0);
            boolean xChanged = (alg_xsh.intValue != alg_vector_dx) && (sig_ramp.intValue== 0);
            boolean imagerColorChanged = (imagerMode) && ((leftEyeColor!=alg_leftEye)||(rightEyeColor!=alg_rightEye));
            
            /* already drawing a vector ... check if we need to turn it off */
            if ((sig_blank.intValue == 0))
            {
                /* blank just went on, vectoring turns off, and we've got a
                 * new line.
                 */
                
                if (/*(sig_ramp.intValue== 0)     && */(sig_blank.intValue == 0))     
                {
                    // ramping and blank just went enabled
                    // do a blank off delay
                    // make the vector a tiny bit longer!(sig_blank.intValue == 0)
                    alg_addline (alg_vector_x0, alg_vector_y0, alg_vector_x1+(int)(config.blankOnDelay*alg_vector_dx), alg_vector_y1+(int)(config.blankOnDelay*alg_vector_dy), alg_zsh.intValue, alg_curved, alg_vector_speed, alg_leftEye, alg_rightEye);
                }
                else
                {
                    alg_addline (alg_vector_x0, alg_vector_y0, alg_vector_x1, alg_vector_y1, alg_zsh.intValue, alg_curved, alg_vector_speed, alg_leftEye, alg_rightEye);
                }
                alg_vectoring = 0;
            } 
            else if (imagerColorChanged || xChanged || yChanged || alg_zsh.intValue != alg_vector_color /*||  (sig_zero.intValue == 0)*/ || ((sig_ramp.intValue== 0) != alg_ramping) ) 
            {
                /* the parameters of the vectoring processing has changed.
                 * so end the current line.
                 */
                boolean inLimits = (alg_curr_x >= 0 && alg_curr_x < config.ALG_MAX_X && alg_curr_y >= 0 && alg_curr_y < config.ALG_MAX_Y);
                
                
                if ((alg_ramping) ||  (sig_zero.intValue == 0))
                {
                    if ((sig_dx != alg_spline_compare_dx || sig_dy != alg_spline_compare_dy) && (inLimits) && (sig_dy != 0))
                    {
                        alg_curved = true;
                    }
                }
                // check if this is just the start of a movement,
                // discard the first 0 vector if so
                boolean rampStartCheck =  ((!alg_ramping) && (sig_ramp.intValue== 0));
                if (!rampStartCheck)
                    alg_addline (alg_vector_x0, alg_vector_y0, alg_vector_x1, alg_vector_y1, alg_vector_color, alg_curved, alg_vector_speed, alg_leftEye, alg_rightEye);

                /* we continue vectoring with a new set of parameters if the
                 * current point is not out of limits.
                 */

                if  (inLimits)
                {
                    alg_vector_x0 = (int)alg_curr_x;
                    alg_vector_y0 = (int)alg_curr_y;
                    alg_vector_x1 = (int)alg_curr_x;
                    alg_vector_y1 = (int)alg_curr_y;
                    if (sig_ramp.intValue==0)
                    {
                        alg_vector_dx = alg_xsh.intValue;
                        alg_vector_dy = -alg_ysh.intValue;
                    }
                    else
                    {
                        alg_vector_dx = 0;
                        alg_vector_dy = 0;
                        alg_curved = false;
                    }
                    alg_vector_color = alg_zsh.intValue;
                    alg_leftEye = leftEyeColor;
                    alg_rightEye = rightEyeColor;
                    alg_vector_speed = Math.max(Math.abs(alg_xsh.intValue), Math.abs(alg_ysh.intValue));

                    alg_ramping = (sig_ramp.intValue== 0);
                    if ((alg_ramping)||  (sig_zero.intValue == 0))
                    {
                        alg_spline_compare_dx = sig_dx;
                        alg_spline_compare_dy = sig_dy;
                    }
                    else
                    {
                        alg_spline_compare_dx = Integer.MAX_VALUE;
                        alg_spline_compare_dy = Integer.MAX_VALUE;
                    }
                } 
                else 
                {
// OUT OF BOUNDS        
                    // an active vector was FINISHED OUT OF BOUNDS!
                    // and a new vector should start                    
                    alg_vectoring = 0;
                }
            }
            else // alg vectoring == 1, but nothing changed
            {
                if ((sig_dx == 0) && (sig_dy == 0))
                {
                    // dot dwell realized with a zero movement and a high speed
                    if (alg_vector_speed<128) alg_vector_speed = 128;
                    alg_vector_speed += 0x4;
                }
            }
        }
        
        // efficiency only active when non zeroing!
        if ((config.efficiencyEnabled) && (sig_zero.intValue!=0))
        {
            double EFFICIENCY_THRESHOLD_X = config.efficiencyThresholdX;
            double EFFICIENCY_THRESHOLD_Y = config.efficiencyThresholdY;
            
            double xTest = alg_curr_x - (config.ALG_MAX_X / 2);
            double yTest = alg_curr_y - (config.ALG_MAX_Y / 2);

            double xPercent = Math.abs( xTest / (config.ALG_MAX_X / 2) );
            double yPercent = Math.abs( yTest / (config.ALG_MAX_Y / 2) );

            double xEfficience = 1.0;
            double yEfficience = 1.0;
            if (xPercent>EFFICIENCY_THRESHOLD_X)
            {
                xEfficience = 1.0-((xPercent)/config.efficiency)*(xPercent-EFFICIENCY_THRESHOLD_X/EFFICIENCY_THRESHOLD_X);
                
                if (xEfficience<0.01) xEfficience = 0.01;
                if (xTest*sig_dx<0)xEfficience = 1/xEfficience;
            }
            if (yPercent>EFFICIENCY_THRESHOLD_Y)
            {
                yEfficience = 1.0-((yPercent)/config.efficiency)*(yPercent-EFFICIENCY_THRESHOLD_Y/EFFICIENCY_THRESHOLD_Y);
                if (yEfficience<0.01) yEfficience = 0.01;
                if (yTest*sig_dy<0)yEfficience = 1/yEfficience;
            }
            alg_curr_x += ((double)sig_dx)*xEfficience;
            alg_curr_y += ((double)sig_dy)*yEfficience;

            // actually do not go negative should be sufficient here!
            if (sig_dx != 0)
            alg_curr_x += (config.scaleEfficiency / ((double)sig_dx))*xPercent;
            if (sig_dy != 0)
            alg_curr_y += (config.scaleEfficiency /((double)sig_dy))*yPercent;
        }
        else
        {
            alg_curr_x += sig_dx;
            alg_curr_y += sig_dy;
        }        
            if (sig_ramp.intValue== 0) 
            {
        
            alg_curr_x -= c_alg_rsh.getDigitalValue();
            alg_curr_y += c_alg_rsh.getDigitalValue();
//                sig_dx += - alg_rsh.intValue;
//                sig_dy += + alg_rsh.intValue;
            }        
        if (alg_curr_x>100000) alg_curr_x=100000;
        else if (alg_curr_x<-100000) alg_curr_x=-100000;
        if (alg_curr_y>100000) alg_curr_y=100000;
        else if (alg_curr_y<-100000) alg_curr_y=-100000;
        
        
        // drift only when not zeroing
        if (sig_zero.intValue != 0) 
        {
            // drift only, when not integrating - or?
            if (sig_ramp.intValue != 0)
            {
                alg_curr_x-= config.drift_x;
                alg_curr_y-= config.drift_y;
            }
            else
            {
                alg_curr_x-= config.drift_x/5.0;
                alg_curr_y-= config.drift_y/5.0;
            }
        }
        
        if (config.emulateIntegrationOverflow)
        {
            if (Math.abs(sig_dx)>100)
            {
                double yOverflow = (  ((double)sig_dx)+((double)sig_dy) ) / config.overflowFactor;

//            alg_curr_x+= xOverflow;
                alg_curr_y+= yOverflow;
            }
        }
        
        if (config.noise)
        {
            long running = cyclesRunning-noiseCycles;
            double xnoise;
            double ynoise;


            if (running>2000)
            {
                xnoise = (0.5 - Global.getRand().nextDouble())*config.noisefactor;
                ynoise = (0.5 - Global.getRand().nextDouble())*config.noisefactor;
                alg_curr_x -=xnoise/10;
                alg_curr_y -=ynoise/10;
            }
            if (running>5000)
            {
                xnoise = (0.5 - Global.getRand().nextDouble())*config.noisefactor;
                ynoise = (0.5 - Global.getRand().nextDouble())*config.noisefactor;
                alg_curr_x -=xnoise/8;
                alg_curr_y -=ynoise/8;
            }
            if (running>10000)
            {
                xnoise = (0.5 - Global.getRand().nextDouble())*config.noisefactor;
                ynoise = (0.5 - Global.getRand().nextDouble())*config.noisefactor;
                alg_curr_x -=xnoise/5;
                alg_curr_y -=ynoise/5;
            }
            if (running>15000)
            {
                xnoise = (0.5 - Global.getRand().nextDouble())*config.noisefactor;
                ynoise = (0.5 - Global.getRand().nextDouble())*config.noisefactor;
                alg_curr_x -=xnoise/2;
                alg_curr_y -=ynoise/2;
            }
            if (running>25000)
            {
                xnoise = (0.5 - Global.getRand().nextDouble())*config.noisefactor;
                ynoise = (0.5 - Global.getRand().nextDouble())*config.noisefactor;
                alg_curr_x -=xnoise;
                alg_curr_y -=ynoise;
            }
        }
        
        
        
        if (alg_vectoring == 1)
        {
            if( alg_curr_x >= 0 && alg_curr_x < config.ALG_MAX_X && alg_curr_y >= 0 && alg_curr_y < config.ALG_MAX_Y) 
            {
                /* we're vectoring ... current point is still within limits so
                 * extend the current vector.
                 */
                alg_vector_x1 = (int)alg_curr_x;
                alg_vector_y1 = (int)alg_curr_y;
            }
            else
            {
// OUT OF BOUNDS        
                // add values that are out of bounds if light is shining!
            }
        }
        if (config.emulateBorders)
        {
            boolean inLimits = (alg_curr_x >= 0 && alg_curr_x < config.ALG_MAX_X && alg_curr_y >= 0 && alg_curr_y < config.ALG_MAX_Y);
            if (!inLimits)
            {
                if ((sig_blank.intValue==1) )
                {
                    int intensity = (alg_zsh.intValue &0xff);
                    if (intensityDrift>100000)
                    {
                       double degradePercent = (180000000.0-((double)intensityDrift))/180000000.0; // two minutes
                       if (degradePercent<0) degradePercent = 0;
                       intensity = (int)(((double)intensity)*degradePercent);
                    }                    
                    
                    int OFFSET_START_DIVISOR = 40;
                    double leftStart =  -config.ALG_MAX_X/OFFSET_START_DIVISOR;
                    double rightStart =  config.ALG_MAX_X+config.ALG_MAX_X/OFFSET_START_DIVISOR;
                    double topStart =   -config.ALG_MAX_Y/OFFSET_START_DIVISOR;
                    double bottomStart = config.ALG_MAX_Y+config.ALG_MAX_Y/OFFSET_START_DIVISOR;
                    // left
                    if (alg_curr_x < leftStart) 
                    {
                        int leftCoordinate = (int)(alg_curr_y/((double)config.ALG_MAX_Y) * OVERFLOW_SAMPLE_MAX);
                        if (leftCoordinate<0) leftCoordinate = 0;
                        if (leftCoordinate>OVERFLOW_SAMPLE_MAX-1) leftCoordinate = OVERFLOW_SAMPLE_MAX-1;
                        vectorDisplay[displayedNext].left[leftCoordinate] += intensity;
                    }
                    // right
                    if (alg_curr_x > rightStart) 
                    {
                        int rightCoordinate = (int)(alg_curr_y/((double)config.ALG_MAX_Y) * OVERFLOW_SAMPLE_MAX);
                        if (rightCoordinate<0) rightCoordinate = 0;
                        if (rightCoordinate>OVERFLOW_SAMPLE_MAX-1) rightCoordinate = OVERFLOW_SAMPLE_MAX-1;
                        vectorDisplay[displayedNext].right[rightCoordinate] += intensity;
                    }
                    // top
                    if (alg_curr_y < topStart) 
                    {
                        int topCoordinate = (int)(alg_curr_x/((double)config.ALG_MAX_X) * OVERFLOW_SAMPLE_MAX);
                        if (topCoordinate<0) topCoordinate = 0;
                        if (topCoordinate>OVERFLOW_SAMPLE_MAX-1) topCoordinate = OVERFLOW_SAMPLE_MAX-1;
                        vectorDisplay[displayedNext].top[topCoordinate] += intensity;
                    }
                    // bottom
                    if (alg_curr_y > bottomStart) 
                    {
                        int bottomCoordinate = (int)(alg_curr_x/((double)config.ALG_MAX_X) * OVERFLOW_SAMPLE_MAX);
                        if (bottomCoordinate<0) bottomCoordinate = 0;
                        if (bottomCoordinate>OVERFLOW_SAMPLE_MAX-1) bottomCoordinate = OVERFLOW_SAMPLE_MAX-1;
                        vectorDisplay[displayedNext].bottom[bottomCoordinate] += intensity;
                    }
                    
                }
                
            }
        }

        
        if (config.useRayGun)
        {
            if (alg_oldBlank != 0)
            {
                int dwell = Math.max(Math.abs(sig_dx), Math.abs(sig_dy));
                displayer.rayMove((int)alg_old_x, (int)alg_old_y, (int)alg_curr_x, (int)alg_curr_y, alg_oldzsh, dwell, alg_curved, alg_vector_speed, alg_leftEye, alg_rightEye);
            }

            alg_oldRamp = sig_ramp.intValue;
            alg_oldZero = sig_zero.intValue;
            alg_oldBlank = sig_blank.intValue;
            alg_oldzsh= alg_zsh.intValue;

            alg_old_x = alg_curr_x;
            alg_old_y = alg_curr_y;
        }
        
        
        
        if ((sig_ramp.intValue!= 0) || (sig_blank.intValue == 0))
        {
            alg_curved = false;
        }
        if (Double.isNaN(alg_curr_x)) 
            alg_curr_x = config.ALG_MAX_X/2;
        if (Double.isNaN(alg_curr_y)) 
            alg_curr_y = config.ALG_MAX_Y/2;        
    }
    void analogStep()
    {
        if (config.vectrexColorMode)
        {
            analogStepColor();
            return;
        }
        if (((via_orb & 0x01) == 0) && ((alg_sel.intValue & 0x06) == 0x02))
            c_alg_rsh.doStep();
        
        
        
        intensityDrift++;
        int sig_dx=0, sig_dy=0; // always the delta from the last vector end position, to the new position
                                // even when zero is active!
        if (lastZero != sig_zero.intValue)
        {
            if (sig_zero.intValue == 0)
            {
                // we start zeroing now
                zeroRetainX = (((double)(alg_curr_x-(config.ALG_MAX_X/2))) *config.zeroRetainX);
                zeroRetainY = (((double)(alg_curr_y-(config.ALG_MAX_Y/2))) *config.zeroRetainY);
            }
            lastZero = sig_zero.intValue;
        }
        else
        {
            if (sig_zero.intValue == 0)
            {
                zeroRetainX = (((double)(zeroRetainX)) *0.99);
                zeroRetainY = (((double)(zeroRetainY)) *0.99);
            }
        }
        if (sig_zero.intValue == 0) 
        {
            noiseCycles = cyclesRunning;
            /* need to force the current point to the 'orgin' so just
             * calculate distance to origin and use that as dx,dy.
             */
            // on zero - do not zero immediatly but "degrade" "slowly"
            int absx = (int)Math.abs(alg_curr_x - (config.ALG_MAX_X / 2));
            int absy = (int)Math.abs(alg_curr_y - (config.ALG_MAX_Y / 2));

            
            sig_dx = (int)(((double)(config.ALG_MAX_X / 2 - (int)alg_curr_x))/config.zero_divider);
            sig_dy = (int)(((double)(config.ALG_MAX_Y / 2 - (int)alg_curr_y))/config.zero_divider);
            
        } 
        //else 
        // no else anymore, integrating can be done WHILE zeroing (see my discussion in forum Vectrex32)
        {
            if (sig_ramp.intValue== 0) 
            {
                sig_dx += alg_xsh.intValue;
                sig_dy += -alg_ysh.intValue;
                fractionSaveX = alg_xsh.intValue;
                fractionSaveY = alg_ysh.intValue;

                //fraction = false;
                if (rampOnFraction)
                {
                    rampOnFraction = false;
                    alg_curr_x -= (int)(((double)alg_xsh.intValue)*(config.rampOnFractionValue));
                    alg_curr_y -= -(int)(((double)alg_ysh.intValue)*(config.rampOnFractionValue));

                }
            } 
            else 
            {
                //fraction = false;
                if (rampOffFraction)
                {
                    // with cycle exact programming we are not allowed to use "alg_xsh.intValue" as fraction
                    // value, because that might have been altered in the last "cycle"
                    // we must remember the last integration value and 
                    // use that instead of the current one!
//                    alg_curr_x += (int)(((double)alg_xsh.intValue)*config.rampOffFractionValue);
//                    alg_curr_y += -(int)(((double)alg_ysh.intValue)*config.rampOffFractionValue);
                    rampOffFraction = false;
                    alg_curr_x += (int)(((double)fractionSaveX)*config.rampOffFractionValue);
                    alg_curr_y += -(int)(((double)fractionSaveY)*config.rampOffFractionValue);

                    
                    
                    if (alg_vectoring == 1 && alg_curr_x >= 0 && alg_curr_x < config.ALG_MAX_X && alg_curr_y >= 0 && alg_curr_y < config.ALG_MAX_Y) 
                    {
                        /* we're vectoring ... current point is still within limits so
                         * extend the current vector.
                         */
                        alg_vector_x1 = (int)alg_curr_x;
                        alg_vector_y1 = (int)alg_curr_y;
                    }        
                }
            }
        }

        if (alg_vectoring == 0) 
        {
            if (sig_blank.intValue == 1 && ((alg_zsh.intValue &0x80) ==0) &&  ((alg_zsh.intValue &0x7f) !=0) ) 
            {
                // new vector should start
                // is oob?
                if (alg_curr_x >= 0 && alg_curr_x < config.ALG_MAX_X && alg_curr_y >= 0 && alg_curr_y < config.ALG_MAX_Y)
                {
                    if (imagerMode)
                    {
                        if (joyport[1].getDevice() instanceof Imager3dDevice)
                        {
                            Imager3dDevice i3d = (Imager3dDevice)joyport[1].getDevice();
                            leftEyeColor = i3d.getLeftColor();
                            rightEyeColor = i3d.getRightColor();
                        }
                    }

                    /* start a new vector */
                    alg_vectoring = 1;

                    alg_vector_dx = alg_xsh.intValue;
                    alg_vector_dy = -alg_ysh.intValue;

                    alg_vector_x0 = (int)alg_curr_x+(int)(config.blankOffDelay*alg_vector_dx);
                    alg_vector_y0 = (int)alg_curr_y+(int)(config.blankOffDelay*alg_vector_dy);
                    alg_vector_x1 = (int)alg_curr_x;
                    alg_vector_y1 = (int)alg_curr_y;

                    alg_vector_speed = Math.max(Math.abs(alg_xsh.intValue), Math.abs(alg_ysh.intValue));

                    alg_leftEye = leftEyeColor;
                    alg_rightEye = rightEyeColor;

                    alg_vector_color = alg_zsh.intValue;
                    alg_ramping = (sig_ramp.intValue== 0);
                    if ((alg_ramping) || (sig_zero.intValue == 0))
                    {
                        alg_spline_compare_dx = sig_dx;
                        alg_spline_compare_dy = sig_dy;
                    }
                    else
                    {
                        alg_spline_compare_dx = Integer.MAX_VALUE;
                        alg_spline_compare_dy = Integer.MAX_VALUE;
                    }                    
                }
                else
                {
// OUT OF BOUNDS                    
                    // OUT OF BOUNDS VECTOR START
                }
            }
        } 
        else // vectoring == 1
        {
            if (imagerMode)
            {
                if (joyport[1].getDevice() instanceof Imager3dDevice)
                {
                    Imager3dDevice i3d = (Imager3dDevice)joyport[1].getDevice();
                    leftEyeColor = i3d.getLeftColor();
                    rightEyeColor = i3d.getRightColor();
                }
            }
            boolean yChanged = (-alg_ysh.intValue != alg_vector_dy) && (sig_ramp.intValue== 0);
            boolean xChanged = (alg_xsh.intValue != alg_vector_dx) && (sig_ramp.intValue== 0);
            boolean imagerColorChanged = (imagerMode) && ((leftEyeColor!=alg_leftEye)||(rightEyeColor!=alg_rightEye));
            
            /* already drawing a vector ... check if we need to turn it off */
            if ((sig_blank.intValue == 0) || ((alg_zsh.intValue &0x80) !=0) || ((alg_zsh.intValue &0x7f) ==0))
            {
                /* blank just went on, vectoring turns off, and we've got a
                 * new line.
                 */
                
                if (/*(sig_ramp.intValue== 0)     && */(sig_blank.intValue == 0))     
                {
                    // ramping and blank just went enabled
                    // do a blank off delay
                    // make the vector a tiny bit longer!(sig_blank.intValue == 0)
                    alg_addline (alg_vector_x0, alg_vector_y0, alg_vector_x1+(int)(config.blankOnDelay*alg_vector_dx), alg_vector_y1+(int)(config.blankOnDelay*alg_vector_dy), alg_zsh.intValue, alg_curved, alg_vector_speed, alg_leftEye, alg_rightEye);
                }
                else
                {
                    alg_addline (alg_vector_x0, alg_vector_y0, alg_vector_x1, alg_vector_y1, alg_zsh.intValue, alg_curved, alg_vector_speed, alg_leftEye, alg_rightEye);
                }
                alg_vectoring = 0;
            } 
            else if (imagerColorChanged || xChanged || yChanged || alg_zsh.intValue != alg_vector_color /*||  (sig_zero.intValue == 0)*/ || ((sig_ramp.intValue== 0) != alg_ramping) ) 
            {
                /* the parameters of the vectoring processing has changed.
                 * so end the current line.
                 */
                boolean inLimits = (alg_curr_x >= 0 && alg_curr_x < config.ALG_MAX_X && alg_curr_y >= 0 && alg_curr_y < config.ALG_MAX_Y);
                
                
                if ((alg_ramping) ||  (sig_zero.intValue == 0))
                {
                    if ((sig_dx != alg_spline_compare_dx || sig_dy != alg_spline_compare_dy) && (inLimits) && (sig_dy != 0))
                    {
                        alg_curved = true;
                    }
                }
                // check if this is just the start of a movement,
                // discard the first 0 vector if so
                boolean rampStartCheck =  ((!alg_ramping) && (sig_ramp.intValue== 0));
                if (!rampStartCheck)
                    alg_addline (alg_vector_x0, alg_vector_y0, alg_vector_x1, alg_vector_y1, alg_vector_color, alg_curved, alg_vector_speed, alg_leftEye, alg_rightEye);

                /* we continue vectoring with a new set of parameters if the
                 * current point is not out of limits.
                 */

                if  (inLimits)
                {
                    alg_vector_x0 = (int)alg_curr_x;
                    alg_vector_y0 = (int)alg_curr_y;
                    alg_vector_x1 = (int)alg_curr_x;
                    alg_vector_y1 = (int)alg_curr_y;
                    if (sig_ramp.intValue==0)
                    {
                        alg_vector_dx = alg_xsh.intValue;
                        alg_vector_dy = -alg_ysh.intValue;
                    }
                    else
                    {
                        alg_vector_dx = 0;
                        alg_vector_dy = 0;
                        alg_curved = false;
                    }
                    alg_vector_color = alg_zsh.intValue;
                    alg_leftEye = leftEyeColor;
                    alg_rightEye = rightEyeColor;
                    alg_vector_speed = Math.max(Math.abs(alg_xsh.intValue), Math.abs(alg_ysh.intValue));

                    alg_ramping = (sig_ramp.intValue== 0);
                    if ((alg_ramping)||  (sig_zero.intValue == 0))
                    {
                        alg_spline_compare_dx = sig_dx;
                        alg_spline_compare_dy = sig_dy;
                    }
                    else
                    {
                        alg_spline_compare_dx = Integer.MAX_VALUE;
                        alg_spline_compare_dy = Integer.MAX_VALUE;
                    }
                } 
                else 
                {
// OUT OF BOUNDS        
                    // an active vector was FINISHED OUT OF BOUNDS!
                    // and a new vector should start                    
                    alg_vectoring = 0;
                }
            }
            else // alg vectoring == 1, but nothing changed
            {
                if ((sig_dx == 0) && (sig_dy == 0))
                {
                    // dot dwell realized with a zero movement and a high speed
                    if (alg_vector_speed<128) alg_vector_speed = 128;
                    alg_vector_speed += 0x4;
                }
            }
        }
        
        // efficiency only active when non zeroing!
        if ((config.efficiencyEnabled) && (sig_zero.intValue!=0))
        {
            double EFFICIENCY_THRESHOLD_X = config.efficiencyThresholdX;
            double EFFICIENCY_THRESHOLD_Y = config.efficiencyThresholdY;
            
            double xTest = alg_curr_x - (config.ALG_MAX_X / 2);
            double yTest = alg_curr_y - (config.ALG_MAX_Y / 2);

            double xPercent = Math.abs( xTest / (config.ALG_MAX_X / 2) );
            double yPercent = Math.abs( yTest / (config.ALG_MAX_Y / 2) );

            double xEfficience = 1.0;
            double yEfficience = 1.0;
            if (xPercent>EFFICIENCY_THRESHOLD_X)
            {
                xEfficience = 1.0-((xPercent)/config.efficiency)*(xPercent-EFFICIENCY_THRESHOLD_X/EFFICIENCY_THRESHOLD_X);
                
                if (xEfficience<0.01) xEfficience = 0.01;
                if (xTest*sig_dx<0)xEfficience = 1/xEfficience;
            }
            if (yPercent>EFFICIENCY_THRESHOLD_Y)
            {
                yEfficience = 1.0-((yPercent)/config.efficiency)*(yPercent-EFFICIENCY_THRESHOLD_Y/EFFICIENCY_THRESHOLD_Y);
                if (yEfficience<0.01) yEfficience = 0.01;
                if (yTest*sig_dy<0)yEfficience = 1/yEfficience;
            }
            alg_curr_x += ((double)sig_dx)*xEfficience;
            alg_curr_y += ((double)sig_dy)*yEfficience;

            // actually do not go negative should be sufficient here!
            if (sig_dx != 0)
            alg_curr_x += (config.scaleEfficiency / ((double)sig_dx))*xPercent;
            if (sig_dy != 0)
            alg_curr_y += (config.scaleEfficiency /((double)sig_dy))*yPercent;
        }
        else
        {
            alg_curr_x += sig_dx;
            alg_curr_y += sig_dy;
        }        
            if (sig_ramp.intValue== 0) 
            {
        
            alg_curr_x -= c_alg_rsh.getDigitalValue();
            alg_curr_y += c_alg_rsh.getDigitalValue();
//                sig_dx += - alg_rsh.intValue;
//                sig_dy += + alg_rsh.intValue;
            }        
        if (alg_curr_x>100000) alg_curr_x=100000;
        else if (alg_curr_x<-100000) alg_curr_x=-100000;
        if (alg_curr_y>100000) alg_curr_y=100000;
        else if (alg_curr_y<-100000) alg_curr_y=-100000;
        
        
        // drift only when not zeroing
        if (sig_zero.intValue != 0) 
        {
            // drift only, when not integrating - or?
            if (sig_ramp.intValue != 0)
            {
                alg_curr_x-= config.drift_x;
                alg_curr_y-= config.drift_y;
            }
            else
            {
                alg_curr_x-= config.drift_x/5.0;
                alg_curr_y-= config.drift_y/5.0;
            }
        }
        
        if (config.emulateIntegrationOverflow)
        {
            if (Math.abs(sig_dx)>100)
            {
                double yOverflow = (  ((double)sig_dx)+((double)sig_dy) ) / config.overflowFactor;

//            alg_curr_x+= xOverflow;
                alg_curr_y+= yOverflow;
            }
        }
        
        if (config.noise)
        {
            long running = cyclesRunning-noiseCycles;
            double xnoise;
            double ynoise;


            if (running>2000)
            {
                xnoise = (0.5 - Global.getRand().nextDouble())*config.noisefactor;
                ynoise = (0.5 - Global.getRand().nextDouble())*config.noisefactor;
                alg_curr_x -=xnoise/10;
                alg_curr_y -=ynoise/10;
            }
            if (running>5000)
            {
                xnoise = (0.5 - Global.getRand().nextDouble())*config.noisefactor;
                ynoise = (0.5 - Global.getRand().nextDouble())*config.noisefactor;
                alg_curr_x -=xnoise/8;
                alg_curr_y -=ynoise/8;
            }
            if (running>10000)
            {
                xnoise = (0.5 - Global.getRand().nextDouble())*config.noisefactor;
                ynoise = (0.5 - Global.getRand().nextDouble())*config.noisefactor;
                alg_curr_x -=xnoise/5;
                alg_curr_y -=ynoise/5;
            }
            if (running>15000)
            {
                xnoise = (0.5 - Global.getRand().nextDouble())*config.noisefactor;
                ynoise = (0.5 - Global.getRand().nextDouble())*config.noisefactor;
                alg_curr_x -=xnoise/2;
                alg_curr_y -=ynoise/2;
            }
            if (running>25000)
            {
                xnoise = (0.5 - Global.getRand().nextDouble())*config.noisefactor;
                ynoise = (0.5 - Global.getRand().nextDouble())*config.noisefactor;
                alg_curr_x -=xnoise;
                alg_curr_y -=ynoise;
            }
        }
        
        
        
        if (alg_vectoring == 1)
        {
            if( alg_curr_x >= 0 && alg_curr_x < config.ALG_MAX_X && alg_curr_y >= 0 && alg_curr_y < config.ALG_MAX_Y) 
            {
                /* we're vectoring ... current point is still within limits so
                 * extend the current vector.
                 */
                alg_vector_x1 = (int)alg_curr_x;
                alg_vector_y1 = (int)alg_curr_y;
            }
            else
            {
// OUT OF BOUNDS        
                // add values that are out of bounds if light is shining!
            }
        }
        if (config.emulateBorders)
        {
            boolean inLimits = (alg_curr_x >= 0 && alg_curr_x < config.ALG_MAX_X && alg_curr_y >= 0 && alg_curr_y < config.ALG_MAX_Y);
            if (!inLimits)
            {
                if ((sig_blank.intValue==1) && ((alg_zsh.intValue &0x80) ==0) && ((alg_zsh.intValue &0x7f) !=0) )
                {
                    int intensity = (alg_zsh.intValue &0x7f);
                    if (intensityDrift>100000)
                    {
                       double degradePercent = (180000000.0-((double)intensityDrift))/180000000.0; // two minutes
                       if (degradePercent<0) degradePercent = 0;
                       intensity = (int)(((double)intensity)*degradePercent);
                    }                    
                    
                    int OFFSET_START_DIVISOR = 40;
                    double leftStart =  -config.ALG_MAX_X/OFFSET_START_DIVISOR;
                    double rightStart =  config.ALG_MAX_X+config.ALG_MAX_X/OFFSET_START_DIVISOR;
                    double topStart =   -config.ALG_MAX_Y/OFFSET_START_DIVISOR;
                    double bottomStart = config.ALG_MAX_Y+config.ALG_MAX_Y/OFFSET_START_DIVISOR;
                    // left
                    if (alg_curr_x < leftStart) 
                    {
                        int leftCoordinate = (int)(alg_curr_y/((double)config.ALG_MAX_Y) * OVERFLOW_SAMPLE_MAX);
                        if (leftCoordinate<0) leftCoordinate = 0;
                        if (leftCoordinate>OVERFLOW_SAMPLE_MAX-1) leftCoordinate = OVERFLOW_SAMPLE_MAX-1;
                        vectorDisplay[displayedNext].left[leftCoordinate] += intensity;
                    }
                    // right
                    if (alg_curr_x > rightStart) 
                    {
                        int rightCoordinate = (int)(alg_curr_y/((double)config.ALG_MAX_Y) * OVERFLOW_SAMPLE_MAX);
                        if (rightCoordinate<0) rightCoordinate = 0;
                        if (rightCoordinate>OVERFLOW_SAMPLE_MAX-1) rightCoordinate = OVERFLOW_SAMPLE_MAX-1;
                        vectorDisplay[displayedNext].right[rightCoordinate] += intensity;
                    }
                    // top
                    if (alg_curr_y < topStart) 
                    {
                        int topCoordinate = (int)(alg_curr_x/((double)config.ALG_MAX_X) * OVERFLOW_SAMPLE_MAX);
                        if (topCoordinate<0) topCoordinate = 0;
                        if (topCoordinate>OVERFLOW_SAMPLE_MAX-1) topCoordinate = OVERFLOW_SAMPLE_MAX-1;
                        vectorDisplay[displayedNext].top[topCoordinate] += intensity;
                    }
                    // bottom
                    if (alg_curr_y > bottomStart) 
                    {
                        int bottomCoordinate = (int)(alg_curr_x/((double)config.ALG_MAX_X) * OVERFLOW_SAMPLE_MAX);
                        if (bottomCoordinate<0) bottomCoordinate = 0;
                        if (bottomCoordinate>OVERFLOW_SAMPLE_MAX-1) bottomCoordinate = OVERFLOW_SAMPLE_MAX-1;
                        vectorDisplay[displayedNext].bottom[bottomCoordinate] += intensity;
                    }
                    
                }
                
            }
        }

        
        if (config.useRayGun)
        {
            if (alg_oldBlank != 0)
            {
                int dwell = Math.max(Math.abs(sig_dx), Math.abs(sig_dy));
                displayer.rayMove((int)alg_old_x, (int)alg_old_y, (int)alg_curr_x, (int)alg_curr_y, alg_oldzsh, dwell, alg_curved, alg_vector_speed, alg_leftEye, alg_rightEye);
            }

            alg_oldRamp = sig_ramp.intValue;
            alg_oldZero = sig_zero.intValue;
            alg_oldBlank = sig_blank.intValue;
            alg_oldzsh= alg_zsh.intValue;

            alg_old_x = alg_curr_x;
            alg_old_y = alg_curr_y;
        }
        
        
        
        if ((sig_ramp.intValue!= 0) || (sig_blank.intValue == 0))
        {
            alg_curved = false;
        }
        if (Double.isNaN(alg_curr_x)) 
            alg_curr_x = config.ALG_MAX_X/2;
        if (Double.isNaN(alg_curr_y)) 
            alg_curr_y = config.ALG_MAX_Y/2;
    }
    
    public void resetAllTimeLowStack()
    {
        e6809.lowestStackValue = e6809.reg_s.intValue;
        allTimeLow = e6809.reg_s.intValue;
    }
    public int getAllTimeLowStack()
    {
        return allTimeLow;
    }
    void checkWaitRecal()
    {
        if ((e6809.reg_pc == testAddressFirst) && ((cart.getCurrentBank() == testBank)|| (testAddressFirst>0xc000))  )
        {
            lastTestTicks = ticksRunning;
            wrStatus = WR_FIRST_FOUND;
            return;
        }
        if ((e6809.reg_pc == testAddressSecond) && ((cart.getCurrentBank() == testBank)|| (testAddressFirst>0xc000)) )
        {
            if (wrStatus == WR_FIRST_FOUND)
            {
                int cycles = (int)(ticksRunning - lastTestTicks);
                waitRecalBuffer[waitRecalBufferNext] =  cycles;
                waitRecalBufferNext = (waitRecalBufferNext+1) %WAIT_RECAL_BUFFER_SIZE;
                wrStatus = WR_UNKOWN;
                trackyCount++;
                if (cycles>30000) trackyAbove++;
                if (allTimeLow>e6809.lowestStackValue) allTimeLow = e6809.lowestStackValue;
                e6809.lowestStackValue = e6809.reg_s.intValue;
                
                if (config.doProfile)
                {
                    if (profiler != null)
                    {
                        if (profiler.trackingOnly)
                        {
                            profiler.trackPointReached();
                        }
                    }
                }
            }
        }
    }
    void setTrackingAddress(int start,int end, int bank)
    {
        testAddressFirst = start;
        testAddressSecond = end;
        testBank = bank;
    }
    
    
    int getCurrentWaitRecalBufferPos()
    {
        return waitRecalBufferNext;
    }
    int[] getCurrentWaitRecalBuffer()
    {
        return waitRecalBuffer;
    }
    long getLastWaitRecalTest()
    {
        return lastTestTicks;
    }
    
    void checkCPUBreakpoints(int cycles)
    {
        if (!config.breakpointsActive) return;
        synchronized (breakpoints[Breakpoint.BP_TARGET_CPU])
        {
            // check PC = ADR breakpoint
            for (Breakpoint bp: breakpoints[Breakpoint.BP_TARGET_CPU])
            {
                if (bp == null) continue;
                if (!bp.enabled) continue;
                if (bp.targetSubType  == Breakpoint.BP_SUBTARGET_CPU_PC)
                {
                    if ((bp.type & Breakpoint.BP_COMPARE) == Breakpoint.BP_COMPARE)
                    {

                        if ((e6809.reg_pc == bp.targetAddress) && (cart.getCurrentBank() == bp.targetBank))
                        {
                            if ((bp.type & Breakpoint.BP_ONCE) == Breakpoint.BP_ONCE)
                            {
                                tmp.add(bp);
                            }
                            activeBreakpoint.add(bp);
                            if (breakpointExit<bp.exitType)breakpointExit=bp.exitType;
                        }
                    }
                    else if ((bp.type & Breakpoint.BP_WEIRD) == Breakpoint.BP_WEIRD)
                    {
                        // pc > cart and smaller ROM is weird
                        // thus also RAM execution is defined as weird
                        if (cart!=null)
                        {
                            boolean isWeird = ((e6809.reg_pc > cart.getCurrentBankLength()) && (e6809.reg_pc < 0xe000));

                            if (isWeird)
                            {
                                if ((bp.type & Breakpoint.BP_ONCE) == Breakpoint.BP_ONCE)
                                {
                                    tmp.add(bp);
                                }
                                activeBreakpoint.add(bp);
                                if (breakpointExit<bp.exitType)breakpointExit=bp.exitType;
                            }
                        }
                    }
                    else if ((bp.type & Breakpoint.BP_INTEGRATOR) == Breakpoint.BP_INTEGRATOR)
                    {
                        if (cart!=null)
                        {
                            if ((e6809.reg_pc == bp.targetAddress) && (cart.getCurrentBank() == bp.targetBank))
                            {
                                int difx = Math.abs(((int)alg_curr_x)-(config.ALG_MAX_X / 2));
                                int dify = Math.abs(((int)alg_curr_y)-(config.ALG_MAX_Y / 2));
                                if ((difx >bp.compareValue) || (dify>bp.compareValue))
                                {
                                    if ((bp.type & Breakpoint.BP_ONCE) == Breakpoint.BP_ONCE)
                                    {
                                        tmp.add(bp);
                                    }
                                    activeBreakpoint.add(bp);
                                    if (breakpointExit<bp.exitType)breakpointExit=bp.exitType;
                                }
                            }
                        }
                    }
                }
                if (bp.targetSubType  == Breakpoint.BP_SUBTARGET_CPU_CYCLES)
                {
                    if ((bp.type & Breakpoint.BP_COMPARE) == Breakpoint.BP_COMPARE)
                    {
                        bp.compareValue-=cycles;
                        if (bp.compareValue<=0)
                        {
                            if ((bp.type & Breakpoint.BP_ONCE) == Breakpoint.BP_ONCE)
                            {
                                tmp.add(bp);
                            }
                            activeBreakpoint.add(bp);
                            if (breakpointExit<bp.exitType)breakpointExit=bp.exitType;
                        }
                    }
                }
                if (bp.targetSubType  == Breakpoint.BP_SUBTARGET_CPU_S)
                {
                    
                    if ((bp.type & Breakpoint.BP_COMPARE) == Breakpoint.BP_COMPARE)
                    {
                        if (e6809.reg_s.intValue<=bp.targetAddress)
                        {
                            if ((bp.type & Breakpoint.BP_ONCE) == Breakpoint.BP_ONCE)
                            {
                                tmp.add(bp);
                            }
                            activeBreakpoint.add(bp);
                            if (breakpointExit<bp.exitType)breakpointExit=bp.exitType;
                        }
                    }
                }
                if (bp.targetSubType  == Breakpoint.BP_SUBTARGET_CPU_SPECIAL)
                {
                    if ((bp.type & Breakpoint.BP_COMPARE) == Breakpoint.BP_COMPARE)
                    {
                        if (e6809.reg_pc == bp.targetAddress)// && (cart.currentBank == bp.targetBank))
                        {
                            if (bp.compareValue != -1)
                            {
                                bp.targetAddress = bp.compareValue;
                                bp.counter = ticksRunning;
                                bp.compareValue = -1;
                            }
                            else
                            {
                                bp.compareValue=(int)(ticksRunning-bp.counter);
                                tmp.add(bp);
                                activeBreakpoint.add(bp);
                                if (breakpointExit<bp.exitType)breakpointExit=bp.exitType;
                            }
                        }
                    }
                }
            }                 
        }
    }
    public void checkROMBreakPoint(int address, int data)
    {
        if (!config.breakpointsActive) return;
        synchronized (breakpoints[Breakpoint.BP_TARGET_MEMORY])
        {
            for (Breakpoint bp: breakpoints[Breakpoint.BP_TARGET_MEMORY])
            {
                if (!bp.enabled) continue;
                if ((bp.type & Breakpoint.BP_WRITE) == Breakpoint.BP_WRITE)
                {
                    if ((bp.targetSubType & Breakpoint.BP_SUBTARGET_MEMORY_ROM) == Breakpoint.BP_SUBTARGET_MEMORY_ROM)
                    {
                        if ((bp.type & Breakpoint.BP_ONCE) == Breakpoint.BP_ONCE)
                        {
                            tmp.add(bp);
                        }
                        activeBreakpoint.add(bp);
                        if (breakpointExit<bp.exitType)breakpointExit=bp.exitType;
                    }
                }
            }                
        }    
    }

    void checkMemWriteBreakpoint(int address, int data)
    {
        if (!config.breakpointsActive) return;
        synchronized (breakpoints[Breakpoint.BP_TARGET_MEMORY])
        {
            for (Breakpoint bp: breakpoints[Breakpoint.BP_TARGET_MEMORY])
            {
                if (!bp.enabled) continue;
                if ((bp.type & Breakpoint.BP_WRITE) == Breakpoint.BP_WRITE)
                {
                    if (((address&0xffff) == bp.targetAddress) && ((cart.getCurrentBank() == bp.targetBank) || (bp.targetBank == -1)))
                    {
                        if ((bp.type & Breakpoint.BP_COMPARE) == Breakpoint.BP_COMPARE)
                        {
                            if ((bp.compareValue != (data&0xff)))
                            {
                                continue;
                            }
                        }
                        if ((bp.type & Breakpoint.BP_ONCE) == Breakpoint.BP_ONCE)
                        {
                            tmp.add(bp);
                        }
                        activeBreakpoint.add(bp);
                        if (breakpointExit<bp.exitType)breakpointExit=bp.exitType;
                    }
                }
            }                
        }
    }
    void checkMemReadBreakpoint(int address)
    {
        if (!config.breakpointsActive) return;
        synchronized (breakpoints[Breakpoint.BP_TARGET_MEMORY])
        {

            for (Breakpoint bp: breakpoints[Breakpoint.BP_TARGET_MEMORY])
            {
                if (!bp.enabled) continue;
                if ((bp.type & Breakpoint.BP_READ) == Breakpoint.BP_READ)
                {
                     if (((address&0xffff) == bp.targetAddress) && 
                             ((cart.getCurrentBank() == bp.targetBank) || (bp.targetBank == -1))
                             )
                    {
                        if ((bp.type & Breakpoint.BP_COMPARE) == Breakpoint.BP_COMPARE)
                        {
                            if ((bp.compareValue != (e6809_readOnly8(address))))
                            {
                                continue;
                            }
                        }
                        if ((bp.type & Breakpoint.BP_ONCE) == Breakpoint.BP_ONCE)
                        {
                            tmp.add(bp);
                        }
                        activeBreakpoint.add(bp);
                        if (breakpointExit<bp.exitType)breakpointExit=bp.exitType;
                    }
                }
            }
        }             
    }
    boolean bitcompare(int o, int n, int bit) 
    {
        int b=1;
        for (;bit>0;bit--) b=b<<1;
        return (o&b) == (n&b);
    }
    
    // register 16 = CA1
    void checkVIABreakpoint(int register, int oldValue, int newValue)
    {
        if (!config.breakpointsActive) return;
        synchronized (breakpoints[Breakpoint.BP_TARGET_VIA])
        {
            for (Breakpoint bp: breakpoints[Breakpoint.BP_TARGET_VIA])
            {
                if (!bp.enabled) continue;
                if ((bp.targetSubType  == Breakpoint.BP_SUBTARGET_VIA_ORB) && (register == 0))
                {
                    if ((bp.type & Breakpoint.BP_BITCOMPARE) == Breakpoint.BP_BITCOMPARE)
                    {
                        if (!bitcompare(oldValue, newValue, bp.compareValue)) 
                        {
                            if ((bp.type & Breakpoint.BP_ONCE) == Breakpoint.BP_ONCE)
                            {
                                tmp.add(bp);
                            }
                            activeBreakpoint.add(bp);
                            if (breakpointExit<bp.exitType)breakpointExit=bp.exitType;
                        }
                    }
                }
                
                else if ((bp.targetSubType  == Breakpoint.BP_SUBTARGET_VIA_AUX) && (register == 11))
                {
                    if ((via_acr != 0x80) && (via_acr != 0x98))
                    {
                        if ((bp.type & Breakpoint.BP_ONCE) == Breakpoint.BP_ONCE)
                        {
                            tmp.add(bp);
                        }
                        activeBreakpoint.add(bp);
                        if (breakpointExit<bp.exitType)breakpointExit=bp.exitType;
                        
                    }
                }
                else if ((bp.targetSubType  == Breakpoint.BP_SUBTARGET_VIA_CA1) && (register == 16))
                {
                    if ((bp.type & Breakpoint.BP_BITCOMPARE) == Breakpoint.BP_BITCOMPARE)
                    {
                        if ((newValue >0) && (bp.compareValue==1))
                        {
                            if ((bp.type & Breakpoint.BP_ONCE) == Breakpoint.BP_ONCE)
                            {
                                tmp.add(bp);
                            }
                            activeBreakpoint.add(bp);
                            if (breakpointExit<bp.exitType)breakpointExit=bp.exitType;
                        }
                    }
                    if ((bp.type & Breakpoint.BP_BITCOMPARE) == Breakpoint.BP_BITCOMPARE)
                    {
                        if ((newValue ==0) && (bp.compareValue==0))
                        {
                            if ((bp.type & Breakpoint.BP_ONCE) == Breakpoint.BP_ONCE)
                            {
                                tmp.add(bp);
                            }
                            activeBreakpoint.add(bp);
                            if (breakpointExit<bp.exitType)breakpointExit=bp.exitType;
                        }
                    }
                    if ((bp.type & Breakpoint.BP_WRITE) == Breakpoint.BP_WRITE)
                    {
                        if ((bp.type & Breakpoint.BP_ONCE) == Breakpoint.BP_ONCE)
                        {
                            tmp.add(bp);
                        }
                        activeBreakpoint.add(bp);
                        if (breakpointExit<bp.exitType)breakpointExit=bp.exitType;
                    }
                }
            }                 
        }
    }
    public void checkBankswitchBreakpoint()
    {
        currentBank = cart.getCurrentBank();
        if (config.debugingCore)
            dissiMem.setCurrentBank(currentBank);

        if (!config.breakpointsActive) return;
        synchronized (breakpoints[Breakpoint.BP_TARGET_CARTRIDGE])
        {
            for (Breakpoint bp: breakpoints[Breakpoint.BP_TARGET_CARTRIDGE])
            {
                if (!bp.enabled) continue;
                if ((bp.targetSubType & Breakpoint.BP_SUBTARGET_CARTRIDGE_BANKSWITCH) == Breakpoint.BP_SUBTARGET_CARTRIDGE_BANKSWITCH)
                {
                    if ((bp.type & Breakpoint.BP_BANK) == Breakpoint.BP_BANK)
                    {
                        if ((bp.type & Breakpoint.BP_ONCE) == Breakpoint.BP_ONCE)
                        {
                            tmp.add(bp);
                        }
                        activeBreakpoint.add(bp);
                        if (breakpointExit<bp.exitType)breakpointExit=bp.exitType;
                    }
                }
            }
        }             
    }    
    void checkExternalLineBreakpoint(boolean externalLine)
    {
        if (!config.breakpointsActive) return;
        synchronized (breakpoints[Breakpoint.BP_TARGET_CARTRIDGE])
        {
            for (Breakpoint bp: breakpoints[Breakpoint.BP_TARGET_CARTRIDGE])
            {
                if (!bp.enabled) continue;
                if ((bp.targetSubType & Breakpoint.BP_SUBTARGET_CARTRIDGE_PB6) == Breakpoint.BP_SUBTARGET_CARTRIDGE_PB6)
                {
                    if ((bp.type & Breakpoint.BP_BITCOMPARE) == Breakpoint.BP_BITCOMPARE)
                    {
                        if (((bp.compareValue == 1) && (externalLine)) || ((bp.compareValue == 0) && (!externalLine)))
                        {
                            if ((bp.type & Breakpoint.BP_ONCE) == Breakpoint.BP_ONCE)
                            {
                                tmp.add(bp);
                            }
                            activeBreakpoint.add(bp);
                            if (breakpointExit<bp.exitType)breakpointExit=bp.exitType;
                        }
                    }
                    else if ((bp.type & Breakpoint.BP_WRITE) == Breakpoint.BP_WRITE)
                    {
                        // only on a change
                        if (old_pb6 != externalLine)
                        {
                            if ((bp.type & Breakpoint.BP_ONCE) == Breakpoint.BP_ONCE)
                            {
                                tmp.add(bp);
                            }
                            activeBreakpoint.add(bp);
                            if (breakpointExit<bp.exitType)breakpointExit=bp.exitType;
                        }
                    }
                    
                }
            }
        }             
    }
    void checkAnalogBreakpoint()
    {
    }
    
    void checkPSGBreakpoint()
    {
        
    }
    // to on add
    protected boolean toggleBankBreakpoint(Breakpoint bp)
    {
        ArrayList<Breakpoint> bankBreakpoints = breakpoints[bp.targetType];

        for (Breakpoint bpAvailable: bankBreakpoints)
        {
            if (bpAvailable.equals(bp))
            {
                bankBreakpoints.remove(bpAvailable);
                return false;
            }
        }
        bankBreakpoints.add(bp);
        return true;
    }
    // true on add
    protected boolean setCyclesBreakpoint(Breakpoint bp)
    {
        ArrayList<Breakpoint> cpuBreakpoints = breakpoints[bp.targetType];
        cpuBreakpoints.add(bp);
        return true;
    }
    public boolean breakpointCPUToggle(Breakpoint bp)
    {
        ArrayList<Breakpoint> cpuBreakpoints = breakpoints[bp.targetType];

        for (Breakpoint bpAvailable: cpuBreakpoints)
        {
            if (bpAvailable.equals(bp))
            {
                cpuBreakpoints.remove(bpAvailable);
                return false;
            }
        }
        cpuBreakpoints.add(bp);
        return true;
    }
    
    // true on add
    protected boolean toggleViaBreakpoint(Breakpoint bp)
    {
        ArrayList<Breakpoint> viaBreakpoints = breakpoints[bp.targetType];

        for (Breakpoint bpAvailable: viaBreakpoints)
        {
            if (bpAvailable.equals(bp))
            {
                viaBreakpoints.remove(bpAvailable);
                return false;
            }
        }
        viaBreakpoints.add(bp);
        return true;
    }
    // true on add
    protected boolean toggleROMBreakpoint(Breakpoint bp)
    {
        ArrayList<Breakpoint> romBreakpoints = breakpoints[bp.targetType];

        for (Breakpoint bpAvailable: romBreakpoints)
        {
            if (bpAvailable.equals(bp))
            {
                romBreakpoints.remove(bpAvailable);
                return false;
            }
        }
        romBreakpoints.add(bp);
        return true;
    }
    protected void addBreakpoint(Breakpoint bp)
    {
        if (bp.memInfo != null)
        {
            bp.memInfo.addBreakpoint(bp);
        }
        synchronized (breakpoints[bp.targetType])
        {
            breakpoints[bp.targetType].add(bp);
        }    
    }
    void removeBreakpoint(Breakpoint bp)
    {
        // no doubles!
        Breakpoint done = bp;
        synchronized (breakpoints[bp.targetType])
        {
            boolean removed = breakpoints[bp.targetType].remove(bp);
            if (!removed)
            {
                for (int i=0; i<breakpoints[bp.targetType].size(); i++ )
                {
                    Breakpoint realBP = breakpoints[bp.targetType].get(i);
                    if (realBP.equals(bp))
                    {
                        removed = breakpoints[bp.targetType].remove(realBP);
                        done = realBP;
                        break;
                    }
                }
                // try finding the SAME
            }
        }        
        if (done.memInfo != null)
        {
            done.memInfo.removeBreakpoint(done);
        }
    }
    public void clearAllBreakpoints()
    {
        ArrayList<Breakpoint> tmp = new ArrayList<Breakpoint>();
        for (ArrayList<Breakpoint> list: breakpoints)
        {
            for (Breakpoint bp: list)
            {
                tmp.add(bp);
            }
        }
        for (Breakpoint bp: tmp)
        {
            if (displayer != null)  
                displayer.breakpointRemove(bp);
        }
        
    }
    

    
    public boolean shouldStall(int shiftCycleDif, boolean isRead)
    {
        if (isRead)
        {
            int generation = config.generation;
            if (generation == 0) return false; // if generation emulation is off, never stall
            if (shiftCycleDif<4) 
                return via_stalling;
            if (generation<3)
            {
                if (shiftCycleDif==15) 
                    return true;
            }
            if (generation==3)
            {
                if (shiftCycleDif==15) return true;
                if (shiftCycleDif==14) return true;
            }
            return false;
        }
        // write
        int generation = config.generation;
        if (generation == 0) return false; // if generation emulation is off, never stall
        if (shiftCycleDif<4) 
            return via_stalling;
        if (generation<3)
        {
            if (shiftCycleDif==17) 
                return true;
        }
        if (generation==3)
        {
            if (shiftCycleDif==17) return true;
            if (shiftCycleDif==16) return true;
        }
        return false;
    }
        

    public void startRecord(String filename, int type, boolean isAddress , int address)
    {
        if (recording) return;
        recordingAddress = address;
        recordingFilename = filename;
        recordingType = type;
        recordingIsAddress = isAddress;
        recording = true;
        recordData = new ArrayList<byte[]>();
    }
    
    // 32 bit int as byte array in big endian
    byte[] getLongBytes(int l)
    {
        byte[] ret = new byte[4];
        
        ret[0] =(byte) ((((l>>8)>>8)>>8) & 0xff);
        ret[1] =(byte) (((l>>8)>>8) & 0xff);
        ret[2] =(byte) ((l>>8) & 0xff);
        ret[3] =(byte) (l & 0xff);
        
        return ret;
    }
    // 16 bit int as byte array in big endian
    byte[] getWordBytes(int l)
    {
        byte[] ret = new byte[2];
        
        ret[0] =(byte) ((l>>8) & 0xff);
        ret[1] =(byte) (l & 0xff);
        
        return ret;
    }
    public void stopRecord()
    {
        if (!recording) return;
        long dataSaved = 0;
        synchronized(recordData)
        {
            // open file
            try 
            {
                OutputStream output = null;
                try 
                {
                    String outAbs = de.malban.util.Utility.makeVideAbsolute(recordingFilename);
                    output = new BufferedOutputStream(new FileOutputStream(outAbs));
                    if (recordingType == REC_DATA)
                    {
                        for (int i=0; i<recordData.size(); i++)
                        {
                            output.write(" db ".getBytes(StandardCharsets.UTF_8));
                            for (int r=0; r<16; r++)
                            {
                                byte toWrite = recordData.get(i)[r];
                                if (r == 0) toWrite = (byte) (toWrite & 0xff);
                                if (r == 1) toWrite = (byte) (toWrite & 0x0f);
                                if (r == 2) toWrite = (byte) (toWrite & 0xff);
                                if (r == 3) toWrite = (byte) (toWrite & 0x0f);
                                if (r == 4) toWrite = (byte) (toWrite & 0xff);
                                if (r == 5) toWrite = (byte) (toWrite & 0x0f);
                                if (r == 6) toWrite = (byte) (toWrite & 0x1f);
                                if (r == 7) toWrite = (byte) (toWrite & 0x3f);
                                if (r == 8) toWrite = (byte) (toWrite & 0x1f);
                                if (r == 9) toWrite = (byte) (toWrite & 0x1f);
                                if (r == 10) toWrite = (byte) (toWrite & 0x1f);
                                if (r == 11) toWrite = (byte) (toWrite & 0xff);
                                if (r == 12) toWrite = (byte) (toWrite & 0xff);
 //                               if (r == 13) toWrite = (byte) (toWrite & 0x0f);
                                if (r == 14) toWrite = (byte) (toWrite & 0x1f);
                                if (r == 15) toWrite = 0;
                                if (r == 16) toWrite = 0;
//                                if (r == 13) 
 //                               {
//                                    if (i>0)
//                                    {
//                                        if (toWrite == (byte) ((recordData.get(i-1)[r]) & 0x0f))
//                                            toWrite = (byte)0xff;
//                                    }
//                                    //else
                                    //    toWrite = (byte)0xff;
//                                }
                                if (r!= 0)
                                    output.write(", ".getBytes(StandardCharsets.UTF_8));
                                output.write(("$"+String.format("%02X", toWrite & 0xFF)).getBytes(StandardCharsets.UTF_8) );
                                dataSaved++;
                            }
                            output.write("\n".getBytes(StandardCharsets.UTF_8));
                        }                            
                    }
                    else if (recordingType == REC_BIN)
                    {
                        for (int i=0; i<recordData.size(); i++)
                        {
                            for (int r=0; r<16; r++)
                            {
                                byte toWrite = recordData.get(i)[r];
                                if (r == 0) toWrite = (byte) (toWrite & 0xff);
                                if (r == 1) toWrite = (byte) (toWrite & 0x0f);
                                if (r == 2) toWrite = (byte) (toWrite & 0xff);
                                if (r == 3) toWrite = (byte) (toWrite & 0x0f);
                                if (r == 4) toWrite = (byte) (toWrite & 0xff);
                                if (r == 5) toWrite = (byte) (toWrite & 0x0f);
                                if (r == 6) toWrite = (byte) (toWrite & 0x1f);
                                if (r == 7) toWrite = (byte) (toWrite & 0x3f);
                                if (r == 8) toWrite = (byte) (toWrite & 0x1f);
                                if (r == 9) toWrite = (byte) (toWrite & 0x1f);
                                if (r == 10) toWrite = (byte) (toWrite & 0x1f);
                                if (r == 11) toWrite = (byte) (toWrite & 0xff);
                                if (r == 12) toWrite = (byte) (toWrite & 0xff);
//                                if (r == 13) toWrite = (byte) (toWrite & 0x0f);
                                if (r == 14) toWrite = (byte) (toWrite & 0x1f);
                                if (r == 15) toWrite = 0;
                                if (r == 16) toWrite = 0;
//                                if (r == 13) 
//                                {
//                                    if (i>0)
//                                    {
//                                        if (toWrite == (byte) ((recordData.get(i-1)[r]) & 0x0f))
//                                            toWrite = (byte)0xff;
//                                    }
                                    //else
                                    //    toWrite = (byte)0xff;
//                                }
                                output.write(toWrite);
                                dataSaved++;
                            }
                        }                            
                    }
                    else if (recordingType == REC_YM)
                    {
                        // generate ym header
                        output.write("YM6!".getBytes(StandardCharsets.UTF_8));
                        output.write("LeOnArD!".getBytes(StandardCharsets.UTF_8));
                        output.write(getLongBytes(recordData.size()));
                        output.write(getLongBytes(1));
                        output.write(getWordBytes(0));
                        output.write(getLongBytes(2000000));
                        output.write(getWordBytes(50));
                        output.write(getLongBytes(0));
                        output.write(getWordBytes(0));

                        dataSaved +=34;
                        output.write("VECTREX".getBytes(StandardCharsets.UTF_8));
                        output.write(0);
                        output.write("VIDE".getBytes(StandardCharsets.UTF_8));
                        output.write(0);
                        output.write("VIDE IS GREAT!".getBytes(StandardCharsets.UTF_8));
                        output.write(0);
                        dataSaved +=28;
                        // save header
                        // save data
                        for (int r=0; r<16; r++)
                        {
                            for (int i=0; i<recordData.size(); i++)
                            {
                                byte toWrite = recordData.get(i)[r];
                                if (r == 0) toWrite = (byte) (toWrite & 0xff);
                                if (r == 1) toWrite = (byte) (toWrite & 0x0f);
                                if (r == 2) toWrite = (byte) (toWrite & 0xff);
                                if (r == 3) toWrite = (byte) (toWrite & 0x0f);
                                if (r == 4) toWrite = (byte) (toWrite & 0xff);
                                if (r == 5) toWrite = (byte) (toWrite & 0x0f);
                                if (r == 6) toWrite = (byte) (toWrite & 0x1f);
                                if (r == 7) toWrite = (byte) (toWrite & 0x3f);
                                if (r == 8) toWrite = (byte) (toWrite & 0x1f);
                                if (r == 9) toWrite = (byte) (toWrite & 0x1f);
                                if (r == 10) toWrite = (byte) (toWrite & 0x1f);
                                if (r == 11) toWrite = (byte) (toWrite & 0xff);
                                if (r == 12) toWrite = (byte) (toWrite & 0xff);
//                                if (r == 13) toWrite = (byte) (toWrite & 0x0f);
                                if (r == 14) toWrite = (byte) (toWrite & 0x1f);
                                if (r == 15) toWrite = 0;
                                if (r == 16) toWrite = 0;
//                              if (r == 13) 
//                                {
//                                    if (i>0)
//                                    {
//                                        if (toWrite == (byte) ((recordData.get(i-1)[r]) & 0x0f))
//                                            toWrite = (byte)0xff;
//                                    }
                                    //else
                                    //    toWrite = (byte)0xff;
//                                }
                                output.write(toWrite);
                                dataSaved++;
                            }
                        }                    
                        // save ending
                        output.write("End!".getBytes(StandardCharsets.UTF_8));
                        dataSaved+=4;
                    }
                    // close file -> finished!
                }
                finally 
                {
                    output.flush();
                    output.close();
                }
            }
            catch(Throwable ex)
            {
                log.addLog(ex, WARN);
            }

        }            
        recording = false;
        recordData = null;
        log.addLog("YM file saved successfully!", INFO);
        
    }
    public void addSoundRecord()
    {
        if (recordData == null) return;
        synchronized(recordData)
        {
            byte[] psgData = new byte[16];
            
            int lastReg13 = 256;
            if (recordData.size()>0)
            {
                lastReg13 = recordData.get(recordData.size()-1)[13];
            }
            
            for (int i=0; i<16; i++)
            {
                byte value = (byte) (e8910.read(i)&0xff);
                if (i == 13)
                {
                    if (!e8910.envWritten)
                        value = (byte)0xff;
                    else
                        value = (byte)(value & 0xf);
                        
                }
                psgData[i] = value;
            }
            recordData.add(psgData);
        }
        e8910.envWritten = false;

    }
    
    

    // accessed from devices in port 0
    public void setFIRQ(boolean lineState)
    {
        // firq line is zero active
        if (lineState) 
            firq = 1;
        else 
            firq = 0;
    }
    public boolean setRegister(String register, int value)
    {
        register = register.trim().toLowerCase();
        if (register.equals("dp"))
        {
            e6809.reg_dp = value&0xff;
            return true;
        }
        if (register.equals("cc"))
        {
            e6809.reg_cc = value&0xff;
            return true;
        }
        if (register.equals("a"))
        {
            e6809.reg_a = value&0xff;
            return true;
        }
        if (register.equals("b"))
        {
            e6809.reg_b = value&0xff;
            return true;
        }
        if (register.equals("d"))
        {
            e6809.reg_b = value&0xff;
            e6809.reg_a = (value>>8)&0xff;
            return true;
        }
        if (register.equals("x"))
        {
            e6809.reg_x = value&0xffff;
            return true;
        }
        if (register.equals("y"))
        {
            e6809.reg_y = value&0xffff;
            return true;
        }
        if (register.equals("pc"))
        {
            e6809.reg_pc = value&0xffff;
            return true;
        }
        if (register.equals("u"))
        {
            e6809.reg_u.intValue = value&0xffff;
            return true;
        }
        if (register.equals("s"))
        {
            e6809.reg_s.intValue = value&0xffff;
            return true;
        }
        return false;
    }
    public boolean isImager()
    {
        return imagerMode;
    }
    public void setImager(boolean im)
    {
        imagerMode = im;
    }
    public DisplayerInterface getDisplay()
    {
        return displayer;
    }
    public int getPC()
    {
        return e6809.reg_pc;
    }
    
    public ArrayList<Integer> getCallstack()
    {
        return e6809.callStack;
    }
    public void resetBuffer()
    {
        SS_RING_BUFFER_SIZE = config.singestepBuffer;
        ringSSWalkStep = 0; // if I step back, what is the position of the step back?
        ringSSBufferNext = 0;
        goSSBackRingBuffer = new CompleteState[SS_RING_BUFFER_SIZE];
                
        FRAME_RING_BUFFER_SIZE = config.frameBuffer;
        ringFrameWalkStep = 0; // if I step back, what is the position of the step back?
        ringFrameBufferNext = 0;
        goFrameBackRingBuffer = new CompleteState[FRAME_RING_BUFFER_SIZE];
                
    }
    public String dumpCurrentROM()
    {
        return cart.dumpCurrentROM();
    }
    public int getAddressBUS()
    {
        return e6809.getAddressBUS();
    }
    public byte getDataBUS()
    {
        return e6809.getDataBUS();
    }
    transient int[] ramAccess = new int[1024];
    private void initRam()
    {
        for (int i=0; i< 1024; i++)ramAccess[i]=0;
        
    }

    boolean checkRAMPointers()
    {
        return false;
        /*
        int[] toCheck=
        {
            // enemy shots
            0xc903+0*12,
            0xc903+1*12,
            0xc903+2*12,
            0xc903+3*12,
            0xc903+4*12,
            0xc903+5*12,
            0xc903+6*12,
            0xc903+7*12,
            // BONUS
            0xc963+8*0,
            0xc963+8*1,
            0xc963+8*2,
            0xc963+8*3,
            0xc963+8*4,
            0xc963+8*5,
            // stars
            0xc993+0*13,
            0xc993+1*13,
            0xc993+2*13,
            0xc993+3*13,
            0xc993+4*13,
            // enemies
            0xc9d4+0*21,
            0xc9d4+1*21,
            0xc9d4+2*21,
            0xc9d4+3*21,
            0xc9d4+4*21,
            0xc9d4+5*21,
            0xc9d4+6*21,
            0xc9d4+7*21,
            0xc9d4+8*21,
            0xc9d4+9*21,
            0xc9d4+10*21,
            0xc9d4+11*21,
            0xc9d4+12*21,
            0xc9d4+13*21,
            0xc9d4+14*21,
            0xc9d4+15*21,
            0xc9d4+16*21,
            0xc9d4+17*21,
            0xc9d4+18*21,
            0xc9d4+19*21,
            // player shots
            0xcb78+0*10,
            0xcb78+1*10,
            0xcb78+2*10,
            0xcb78+3*10,
            0xcb78+4*10,
            0xcb78+5*10,
            0xcb78+6*10,
            0xcb78+7*10,
            0xcb78+8*10,
            0xcb78+9*10,
        };
        
        if (getPC() == 0x53a) // main loop start
        {
            if (cart.getCurrentBank() == 3)
            {
                for (int i=0; i<toCheck.length; i++)
                {
                    int offsetDueToChanges = -0;
                    int ram = e6809_readOnly8(toCheck[i]+offsetDueToChanges)*256+e6809_readOnly8(toCheck[i]+offsetDueToChanges+1);
                    if (ram < 0xc800)
                    {
                        breakpointExit=EMU_EXIT_BREAKPOINT_BREAK;
                        CSAMainFrame frame = (CSAMainFrame) Configuration.getConfiguration().getMainFrame();
                        DissiPanel dissi = frame.checkDissi();
                        if (dissi != null)
                        {
                            dissi.printMessage("Vectorblade RAM corruption: "+String.format("$%04X", toCheck[i]+offsetDueToChanges)+"->"+String.format("$%04X", ram), DissiPanel.MESSAGE_INFO );
                        }

                        return true;
                    }
                }
            }
        }
        return false;
*/
    }
}

