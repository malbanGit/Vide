/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
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


import de.malban.Global;
import de.malban.vide.VideConfig;
import de.malban.config.Configuration;
import de.malban.vide.vecx.cartridge.CartridgeListener;
import de.malban.gui.CSAMainFrame;
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
import de.malban.sound.tinysound.Stream;
import de.malban.sound.tinysound.TinySound;
import de.malban.vide.veccy.VectorListScanner;
import static de.malban.vide.vecx.panels.PSGJPanel.REC_BIN;
import static de.malban.vide.vecx.panels.PSGJPanel.REC_DATA;
import static de.malban.vide.vecx.panels.PSGJPanel.REC_YM;
import java.io.BufferedOutputStream;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.nio.charset.StandardCharsets;

/**
 *
 * @author malban
 */
public class VecX extends VecXState implements VecXStatics, E6809Access
{
    VideConfig config = VideConfig.getConfig();
    LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
    // timer is count down in 1/1500000 steps
    // meaning each processor cycle is one step...
    
    ArrayList<Breakpoint> breakpoints[] = new ArrayList[Breakpoint.BP_TARGET_COUNT];
    ArrayList<Breakpoint> activeBreakpoint = new ArrayList<Breakpoint>();
    
    boolean rampOffFraction = true;
    boolean rampOnFraction = true;

    
    boolean alternate = false;


    transient CodeScanMemory dissiMem=CodeScanMemory.getCodeScanMemory();

    ArrayList<Breakpoint>[] getAllBreakpoints() 
    {
        return breakpoints;
    }


    class VectrexDisplayVectors
    {
        vector_t[] vectrexVectors = new vector_t[VECTOR_CNT];
        int count = 0;
        VectrexDisplayVectors()
        {
            for(int i=0; i<VECTOR_CNT; i++ )
                vectrexVectors[i] = new vector_t();
        }
    }

    transient E8910 e8910 = null;
    transient E6809 e6809 = null;
    transient Stream line=null;
    public static int SOUNDBUFFER_SIZE = 882*4;
    transient byte[] soundBytes = new byte[SOUNDBUFFER_SIZE];
    transient int[] rom = new int[8192];

    transient static int RING_BUFFER_SIZE = 2000;
    transient int ringWalkStep = 0; // if I step back, what is the position of the step back?
    transient int ringBufferNext = 0;
    transient CompleteState[] goBackRingBuffer = new CompleteState[RING_BUFFER_SIZE];
    
    transient static int WAIT_RECAL_BUFFER_SIZE = 500;
    transient int waitRecalBufferNext = 0;
    transient boolean waitRecalActive = true;
    transient int testAddressFirst = 0xF1A2;
    transient int testAddressSecond = 0xF192;
    transient long lastTestTicks = 0;
    transient int[] waitRecalBuffer = new int[WAIT_RECAL_BUFFER_SIZE];
    
    transient boolean directDrawActive = false;
    
     
    // dummy displayer, which does nothing!
    transient DisplayerInterface displayer = new DisplayerInterface(){public void switchDisplay(){}public void updateDisplay(){} public void directDraw(vector_t v){}public void rayMove(int x0,int y0, int x1, int y1, int color, int dwell, boolean curved){}};

    
    transient VectrexDisplayVectors[] vectorDisplay = new VectrexDisplayVectors[2];
    transient int displayedNext = 0;
    transient int displayedNow = 1;
    transient int[] vector_hash = new int[VECTOR_HASH];
    transient long fcycles;

    void addTimerItem(TimerItem item)
    {
        synchronized (timerItemList)
        {
            timerItemList.add(item);
        }
    }
    // remove all timer items of a type
    void removerTimerItem(int t)
    {
        synchronized (timerItemList)
        {
            for (int i= timerItemList.size()-1; i>=0;i--)
            {
                TimerItem item = timerItemList.get(i);
                if (item.type == t)
                {
                    timerItemList.remove(item);
                }
            }
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
        e6809 = new E6809();
        e6809.vecx=this;        
        e8910 = new E8910();
        e8910.e8910_init_sound();
        for (int i=0; i<Breakpoint.BP_TARGET_COUNT; i++)
            breakpoints[i] = new ArrayList<>();
        line = TinySound.getOutStream();
line.start();
        }
    void deinitAudio()
    {
        if (line != null)
            line.unload();
        line = null;
    }
    
    public void setDisplayer(DisplayerInterface d)
    {
        displayer = d;
    }
    // called befor VIA is changed
    // so we have access to old via data
    void doCheckBankswitch(int tobe_via_orb, int tobe_via_ddrb)
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
        // the actual bankswitching test is than only called
        // if the state of the EXTERNAL LINE has changed

        
        
        // get output value of via b NOW
        int viaOutNow = via_orb| (via_ddrb ^ 0xFFFFFFFF) & 0xFF;
        if ((tobe_via_orb != viaOutNow) || (tobe_via_ddrb != via_ddrb))
        {
            // get output of changed port b
            int viaOutTobe = tobe_via_orb |((tobe_via_ddrb ^ 0xFFFFFFFF) & 0xFF);
            // send changed via port b out put to cartridge
            boolean changed = cart.checkBankswitch(viaOutTobe, cyclesRunning);
            if (changed)
            {
                currentBank = cart.getCurrentBank();
                dissiMem.setCurrentBank(currentBank);
                
                if (!config.breakpointsActive) return;
                synchronized (breakpoints[Breakpoint.BP_TARGET_CARTRIDGE])
                {

                    for (Breakpoint bp: breakpoints[Breakpoint.BP_TARGET_CARTRIDGE])
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
    }
    

    /* update the snd chips internal registers when via_ora/via_orb changes */
    // here ORA is taken, not DAC
    // for PSG this should not make realy a difference!
    void snd_update ()
    {
        switch (via_orb & 0x18) 
        {
            case 0x00:
                /* the sound chip is disabled */
                break;
            case 0x08:
                /* the sound chip is sending data */
                break;
            case 0x10:
                /* the sound chip is recieving data */
                if (snd_select != 14) 
                {
                    e8910.e8910_write(snd_select, via_ora);
                }
                else
                {
                    // DVE implementation
                    if (imager)
                    {
                        if (!PARA)
                        {
                            if ((lastImagerData & 0x7f) != 0)
                            {
                                if (via_ora != 0xff)
                                {
                                    imagerPulse=(int)(e6809.cyclesRunning-lastImagerCycleCount);
                                }
                            }
                            lastImagerCycleCount=e6809.cyclesRunning;
                            lastImagerData=via_ora;
                        }
                    }
                    else
                    {
                        // Para implementaion
                        if (imager)
                        {
                            imagerIn = ((via_ora & 0x40) != 0);
                            if (!imagerIn)
                            {
                              imagerOut = false;
                              imagerCountDown = 22400;
                            }
                            lastImagerData = via_ora;
                             lastImagerCycleCount=e6809.cyclesRunning;
                        }
                    }
                }
                break;
            case 0x18:
                /* the sound chip is latching an address */
                if ((via_ora & 0xf0) == 0x00) {
                        snd_select = via_ora & 0x0f;
                }
                break;
        }
        
        // Malban
        if ((via_orb & 0x07) == 0x06) // SEL == 11 -> Sound, Mux ==0 meaning ON
        {
            // dac is sending data to PSG
            // data is via_ora
            // dummy register, write directy to audio line buffer in psg emulation!
            e8910.e8910_write(255, alg_ssh.intValue);
//            System.out.println("Cycl:"+(cyclesRunning-sampleCycle) );
            if ((cyclesRunning-sampleCycle)==224)
//                System.out.println("PC="+e6809.reg_pc);
sampleCycle= cyclesRunning;
        }
        checkPSGBreakpoint();
    }
    long sampleCycle = 0;

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
                        break;
                    case 0x1:
                        /* fall through */
                    case 0xf:
                        if ((via_orb & 0x18) == 0x08) 
                        {
                                /* the snd chip is driving port a */
                            data = e8910.snd_regs[snd_select];
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
        else if (address < 0x8000) 
        {
            /* cartridge */
            data = cart.get_cart(address);
        } 
        else 
        {
            data = 0xff;
        }

        return data & 0xff; // and return unsigned byte!        
    }
    // returns unsigned 8bit in int 
    @Override
    public int e6809_read8(int address)
    {
        int data = 0;
        if (config.codeScanActive) dissiMem.mem[address].addAccess(e6809.reg_pc, MEMORY_READ);
        checkMemReadBreakpoint(address);

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
                        break;
                    case 0x1:
                        /* register 1 also performs handshakes if necessary */
                        if ((via_pcr & 0x0e) == 0x08) 
                        {
                            /* if ca2 is in pulse mode or handshake mode, then it
                             * goes low whenever ira is read.
                             */
                            via_ca2 = 0;
                            addTimerItem(new TimerItem(via_ca2,sig_zero, TIMER_ZERO));
                        }
                        via_ifr = via_ifr & (0xff-0x02); // clear ca1 interrupt
                        /* fall through */
                    case 0xf:
                        if ((via_orb & 0x18) == 0x08) 
                        {
                                /* the snd chip is driving port a */
                            data = e8910.snd_regs[snd_select];
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
                        via_ifr &= 0xbf; /* remove timer 1 interrupt flag */
                        via_t1int = 0;
                        int_update ();
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
                        data = via_t2c;
                        via_ifr &= 0xdf; /* remove timer 2 interrupt flag */
                        via_t2int = 0;
                        int_update ();
                        break;
                    case 0x9:
                        /* T2 high order counter */
                        data = (via_t2c >> 8);
                        break;
                    case 0xa:
                        data = via_sr;
                        via_ifr &= 0xfb; /* remove shift register interrupt flag */
                        via_srb = 0;
                        via_srclk = 1;
                        int_update ();
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
        else if (address < 0x8000) 
        {
            /* cartridge */
            data = cart.get_cart(address);
        } 
        else 
        {
            data = 0xff;
        }

        return data & 0xff; // and return unsigned byte!
    }
    @Override
    public void e6809_write8(int address, int data)
    {
        if (config.codeScanActive) dissiMem.mem[address].addAccess(e6809.reg_pc, MEMORY_WRITE);
        checkMemWriteBreakpoint(address, data);
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
//                checkMemWriteBreakpoint(address & 0x3ff, data);
            }
            if ((address & 0x1000) != 0)
            {
                switch (address & 0xf) 
                {
                    case 0x0:
                        checkVIABreakpoint(0, via_orb, data);                  
                        doCheckBankswitch(data, via_ddrb);
                        if ((data & 0x7) != (via_orb & 0x07)) // check if state of mux sel changed
                        {
                            addTimerItem(new TimerItem(data, alg_sel, TIMER_MUX_SEL_CHANGE));
                        }
                        via_orb = data;
                        snd_update();
                        if ((via_pcr & 0xe0) == 0x80) 
                        {
                            /* if cb2 is in pulse mode or handshake mode, then it
                             * goes low whenever orb is written.
                             */
                            via_cb2h = 0;
                            addTimerItem(new TimerItem(via_cb2h, sig_blank, TIMER_BLANK_CHANGE));
                        }
                           doCheckRamp();
//s                        doCheckOrb();
                        break;
                    case 0x1:
                        /* register 1 also performs handshakes if necessary */
                        if ((via_pcr & 0x0e) == 0x08) 
                        {
                            /* if ca2 is in pulse mode or handshake mode, then it
                             * goes low whenever ora is written.
                             */
                            via_ca2 = 0;
                            addTimerItem(new TimerItem(via_ca2,sig_zero, TIMER_ZERO));
                        }
                        via_ifr = via_ifr & (0xff-0x02); // clear ca1 interrupt
                    /* fall through */
                    case 0xf:
                        addTimerItem(new TimerItem(getDACDelay((byte)(via_ora&0xff),(byte)( data&0xff)), data, alg_DAC, TIMER_DAC_CHANGE));
                        via_ora = data;
                        
                        /* output of port a feeds directly into the dac which then
                         * feeds the x axis sample and hold.
                         */
                        /*
                         addTimerItem(new TimerItem(data, alg_xsh, TIMER_XSH_CHANGE));
                         doCheckMultiplexer();
                        */
                        snd_update();
                        break;
                    case 0x2:
                        doCheckBankswitch(via_orb, data);
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
                        via_t1lh = data;
                        via_t1c = (via_t1lh << 8) | via_t1ll;
                        via_ifr &= 0xbf; /* remove timer 1 interrupt flag */
                        via_t1on = 1; /* timer 1 starts running */
                        via_t1int = 1;

                        if ((via_acr & 0x80)!=0)  
                        {
                            if (via_t1pb7!=0)
                                checkVIABreakpoint(0, via_orb, via_orb-via_t1pb7);                  
                        }
                        via_t1pb7 = 0;
                        
                        
                        
                        doCheckRamp();
                        int_update ();
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
                        via_t2c = (data << 8) | via_t2ll;
                        via_ifr &= 0xdf;
                        via_t2on = 1; /* timer 2 starts running */
                        via_t2int = 1;
                        int_update ();
                        break;
                    case 0xa:
                        
                        // duno if ignoring is realy alright
                        if (cyclesRunning - lastShiftRegWrite >= 18)
                        {
                            lastShiftRegWrite = cyclesRunning;
                            via_sr = data;
                            via_ifr &= 0xfb; /* remove shift register interrupt flag */
                            via_srb = 0;
                            via_srclk = 1;
                            int_update ();
                        }                            
                        else
                        {
//System.out.println("ToEarly: "+(cyclesRunning - lastShiftRegWrite));
                            via_stalling = true;
                           // via_sr = 0; // DUnno!
                            via_ifr &= 0xfb; /* remove shift register interrupt flag */
                           // via_srb = 0;
                            via_srclk = 1;
                            int_update ();
                        }
                        break;
                    case 0xb:
                        via_acr = data;
                        doCheckRamp();
                        break;
                    case 0xc:
                        via_pcr = data;
                        if ((via_pcr & 0x0e) == 0x0c) 
                        {
                            /* ca2 is outputting low */
                            via_ca2 = 0;
                            addTimerItem(new TimerItem(via_ca2,sig_zero, TIMER_ZERO));
                        } 
                        else 
                        {
                            /* ca2 is disabled or in pulse mode or is
                             * outputting high.
                             */
                            via_ca2 = 1;
                            addTimerItem(new TimerItem(via_ca2,sig_zero, TIMER_ZERO));
                        }
                        if ((via_pcr & 0xe0) == 0xc0) 
                        {
                            /* cb2 is outputting low */
                            via_cb2h = 0;
                            addTimerItem(new TimerItem(via_cb2h, sig_blank, TIMER_BLANK_CHANGE));
                        } 
                        else 
                        {
                            /* cb2 is disabled or is in pulse mode or is
                             * outputting high.
                             */
                            via_cb2h = 1;
                            addTimerItem(new TimerItem(via_cb2h, sig_blank, TIMER_BLANK_CHANGE));
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
        } 
        else if (address < 0x8000) 
        {
            // spektrum has to go here!
            /* cartridge */
            // for now only bad apple!
            cart.write(address,(byte) data);
        }
    }

    void vecx_reset()
    {
       vecx_reset(true);
    }
    void vecx_reset(boolean clearBreakpoints)
    {
        int r;

        /* ram */
        for (r = 0; r < 1024; r++) 
        {
            ram[r] = r & 0xff;
        }
        
        
        for (r = 0; r < 16; r++) 
        {
            e8910.e8910_write(r, 0);
        }

        /* input buttons */
        e8910.e8910_write(14, 0xff);

        snd_select = 0;
        lastShiftRegWrite = 0;
        via_stalling = false;
        via_ora = 0;
        via_orb = 0;
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
        via_ca1 = 0;
        via_ca2 = 1;
        via_cb2h = 1;
        via_cb2s = 0;

        alg_jch0 = 128;
        alg_jch1 = 128;
        alg_jch2 = 128;
        alg_jch3 = 128;
        alg_rsh.intValue = 128;
        alg_xsh.intValue = 128;
        alg_ysh.intValue = 128;
        alg_zsh.intValue = 0;
        alg_ssh.intValue = 0;
        alg_jsh = 128;
        alg_compare = 0; 
        sig_zero.intValue = 1;
        sig_ramp.intValue = 0;
        sig_blank.intValue = 0;
        alg_curr_x = ALG_MAX_X / 2;
        alg_curr_y = ALG_MAX_Y / 2;
        
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
        lightpen = false;
        lightpenX = LIGHTPEN_OUT_OF_BOUNDS; // must be set from "gui"
        lightpenY = LIGHTPEN_OUT_OF_BOUNDS;

        imager = false;
        lastImagerData =0;
        lastImagerCycleCount =0;
        imagerPulse =0;
        
        imagerIn = true;
        imagerOut = true;
        imagerCountDown = 0;

        if (clearBreakpoints)
        {
            if (config.resetBreakpointsOnLoad)
                clearAllBreakpoints();        
        }

        timerItemList.clear();
        e6809.e6809_reset();
        dissiMem.reset();
    }

    /* perform a single cycle worth of via emulation.
     * via_sstep0 is the first postion of the emulation.
     */
    void via_sstep0 ()
    {
        int t2shift;
        if (via_t1on!=0) 
        {
            via_t1c--;
            if ((via_t1c & 0xffff) == 0xffff) 
            {
                /* counter just rolled over */
                if ((via_acr & 0x40) != 0)
                {
                    /* continuous interrupt mode */
                    via_ifr |= 0x40;
                    int_update ();
                    if ((via_acr & 0x80)!=0)  
                    {
                        if (via_t1pb7==0x80)
                            checkVIABreakpoint(0, via_orb, via_orb-0x80); 
                        else
                            checkVIABreakpoint(0, via_orb, via_orb+0x80); 
                    }
                    via_t1pb7 = 0x80 - via_t1pb7;
                    doCheckRamp();
                    /* reload counter */
                    via_t1c = (via_t1lh << 8) | via_t1ll;
                } 
                else 
                {
                    /* one shot mode */
                    if (via_t1int != 0) 
                    {
                        via_ifr |= 0x40;
                        int_update ();
                        if ((via_acr & 0x80)!=0)  
                        {
                            if (via_t1pb7!=0x80)
                                checkVIABreakpoint(0, via_orb, via_orb+0x80); 
                        }
                        via_t1pb7 = 0x80;
                        doCheckRamp();
                        via_t1int = 0;
                    }
                }
            }
        }

        if ((via_t2on!=0) && (via_acr & 0x20) == 0x00) 
        {
            via_t2c--;
            if ((via_t2c & 0xffff) == 0xffff) 
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
            if (via_srclk != 0) 
            {
                t2shift = 1;
                via_srclk = 0;
            } 
            else 
            {
                t2shift = 0;
                via_srclk = 1;
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
                        addTimerItem(new TimerItem(via_cb2s, sig_blank, TIMER_BLANK_CHANGE));
                    }
                    break;
                case 0x14:
                    /// shift out under t2 control 
                    if (t2shift!=0) 
                    {
                        via_cb2s = (via_sr >> 7) & 1;
                        via_sr <<= 1;
                        via_sr |= via_cb2s;
                        addTimerItem(new TimerItem(via_cb2s, sig_blank, TIMER_BLANK_CHANGE));
                        via_srb++;
                    }
                    break;
                case 0x18:
/*                    
                    // shift out under system clock control 
                    via_cb2s = (via_sr >> 7) & 1;
                    via_sr <<= 1;
                    via_sr |= via_cb2s;
                    addTimerItem(new TimerItem(via_cb2s, sig_blank, TIMER_BLANK_CHANGE));
                    via_srb++;
*/                    
                    // System Time -> look at hardware manual
                    // only every SECOND cycle!
                    alternate = !alternate;
                    if (alternate)
                    {
                        via_cb2s = (via_sr >> 7) & 1;
                        via_sr <<= 1;
                        via_sr |= via_cb2s;
                        addTimerItem(new TimerItem(via_cb2s, sig_blank, TIMER_BLANK_CHANGE));
                        via_srb++;
                    }
                    
                    
                    
                    break;
                case 0x1c:
                    // shift out under cb1 control 
                    break;
            }

            if ((via_srb == 8) && (alternate))
            {
                via_ifr |= 0x04;
                int_update ();
                lastShift = via_cb2s;
            }
// last shift is repeated, 18 cycles 
            if (via_srb == 9) 
            {
                alternate = !alternate;
                if (alternate)
                {
                    via_cb2s = lastShift;
                    addTimerItem(new TimerItem(via_cb2s, sig_blank, TIMER_BLANK_CHANGE));
                    if (!via_stalling)
                        via_srb++;
                }

            }
        }
    }
    int lastShift = 0;
    /* perform the second part of the via emulation */
    void via_sstep1()
    {
        if ((via_pcr & 0x0e) == 0x0a) 
        {
            /* if ca2 is in pulse mode, then make sure
             * it gets restored to '1' after the pulse.
             */
            via_ca2 = 1;
            addTimerItem(new TimerItem(via_ca2,sig_zero, TIMER_ZERO));
        }

        if ((via_pcr & 0xe0) == 0xa0) 
        {
            /* if cb2 is in pulse mode, then make sure
             * it gets restored to '1' after the pulse.
             */
            via_cb2h = 1;
            addTimerItem(new TimerItem(via_cb2h, sig_blank, TIMER_BLANK_CHANGE));
        }
        
        // lightpen
        if (via_ca1!=0) // interrupt flag can be set without its enable flag && ((via_ier&0x02)==0x02))
        {
            via_ifr = via_ifr | 0x02;
            int_update ();
            
        }
        if (imager)
        {
            if (PARA)
            {
                if (imagerOut) 
                {
                    via_ca1=1;
                    via_ifr = via_ifr | 0x02;
                }
                else
                    via_ca1=0;
                int_update ();
            }         
        } 
    }
    
    // input in vectrex coordinates!
    // transformed to upper left corner. (is 0,0)
    // values from 0 to ALG_MAX_X and 0 to ALG_MAX_Y
    void alg_addline (int x0, int y0, int x1, int y1, int color, int speed)
    {
        alg_addline ( x0,  y0,  x1,  y1,  color, false, speed);
    }
    void alg_addline (int x0, int y0, int x1, int y1, int color, boolean midChange, int speed)
    {
        if (config.useRayGun) return;
        int index;

        // possibly add some brightness!
        if (vectorDisplay[displayedNext].count >=vectorDisplay[displayedNext].vectrexVectors.length)
        {
            log.addLog("To many vectors - can't draw!", ERROR);
            return ;
        }
        
        vector_t v = vectorDisplay[displayedNext].vectrexVectors[vectorDisplay[displayedNext].count];
        v.speed = speed;
        v.x0 = x0;
        v.y0 = y0;
        v.x1 = x1;
        v.y1 = y1;
        v.midChange = midChange;
        v.color = color;

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
            directDrawVector = vectorDisplay[displayedNow].vectrexVectors[vectorDisplay[displayedNow].count];
            vectorDisplay[displayedNow].count++;
            directDrawVector.x0 = x0;
            directDrawVector.y0 = y0;
            directDrawVector.x1 = x1;
            directDrawVector.y1 = y1;
            directDrawVector.speed = speed;
            directDrawVector.midChange = midChange;

            directDrawVector.color = 255;
            displayer.directDraw(directDrawVector);
        }
        vectorDisplay[displayedNext].count++;
    }

    public boolean toggleLightPen()
    {
        lightpen = !lightpen;
        if (!lightpen) via_ca1=0; // ensure it is off!
        return lightpen;
    }
    public boolean toggleGoggle()
    {
        imager = !imager;
        if (!imager) via_ca1=0; // ensure it is off!
        return imager;
    }

    // expects vectrex coordonates like vector list
    // transformed to upper left corner. (is 0,0)
    // values from 0 to ALG_MAX_X and 0 to ALG_MAX_Y
    public void setLightPen(int x, int y)
    {
        lightpenX = x;
        lightpenY = y;
        if ((x == LIGHTPEN_OUT_OF_BOUNDS) || (y == LIGHTPEN_OUT_OF_BOUNDS)) 
        {
            via_ca1 = 0;
        }
    }
    void lightpenStep()
    {
        int my = lightpenY;
        int mx = lightpenX;
        if (!((mx == LIGHTPEN_OUT_OF_BOUNDS) || (my == LIGHTPEN_OUT_OF_BOUNDS)))
        {
            if ((Math.abs(alg_curr_x-mx)<0x100) && ((Math.abs(alg_curr_y-my)<0x100)))
            {
                via_ca1 = 1;

            }
            else
            {
                via_ca1 = 0;
            }
        }
        else
        {
            via_ca1 = 0;
        }
    }
    
    public void vectrexNonCPUStep(int cycles)
    {
        if (!config.cycleExactEmulation) return;
        for (int c = 0; c < cycles; c++) 
        {
            via_sstep0();
            timerStep();
            // timer after via, to make sure befor analog step, that 0 timers are respected!
            analogStep();
            if (imager) imagerStep();
            if (lightpen) lightpenStep();
            via_sstep1();
            nonCPUStepsDone++;
        }
    }
    int nonCPUStepsDone = 0;
    ArrayList<Breakpoint> tmp = new ArrayList<Breakpoint>();
    
    int breakpointExit=EMU_EXIT_CYCLES_DONE;
    // returns an "exit reason"
    // break point e.g.
    
    boolean syncImpulse = false;
    long lastSyncCycles = 0;
    long soundCycles = 0;
    int vecx_emu(long cyclesOrg)
    {
        int c, icycles;
        long cycles = cyclesOrg;
        int reason = EMU_EXIT_CYCLES_DONE;
        breakpointExit=EMU_EXIT_CYCLES_DONE;
        activeBreakpoint.clear();
        tmp.clear(); // breakpoint (one time) that must be deleted

        // if emulation is run from a "behind" step
        // discard all forward steps
        if (ringWalkStep != -1)
        {
            ringBufferNext = (ringWalkStep+1)%RING_BUFFER_SIZE;
            ringWalkStep = -1;
        }
        
        while (cycles > 0) 
        {
            nonCPUStepsDone = 0;
            // see: http://oldies.malban.de/firstvectrex/vectrex/UNSORTED/text/6809/HTML/UP05.HTM
            int pc = e6809.reg_pc%65536;
            icycles = e6809.e6809_sstep (via_ifr & 0x80, 0);
            if (config.codeScanActive) 
            {
                for (int i=0; i<icycles; i++)
                {
                    dissiMem.mem[(pc+i)%65536].addAccess(e6809.reg_pc%65536, MEMORY_CODE);
                }
            }
            
            cyclesRunning += icycles;
            for (c = 0; c < (icycles-nonCPUStepsDone); c++) 
            {
                
                via_sstep0();
                timerStep();
                // timer after via, to make sure befor analog step, that 0 timers are respected!
                analogStep();
                if (imager) imagerStep();
                if (lightpen) lightpenStep();
                via_sstep1();
            }

            if (waitRecalActive) checkWaitRecal();

            cycles -= (long) icycles;
            fcycles -= (long) icycles;
            soundCycles -= (long) icycles;
            boolean doSync = false;
            if (config.autoSync)
            {
                if (syncImpulse)
                {
                    // some carts use T2 for other timing (like digital output), these timers are "relly" small compared to 50 Hz
                    if (cyclesRunning - lastSyncCycles < 20000) // do not trust T2 timers which are to lo!
                    {
                        lastSyncCycles = cyclesRunning;
                        syncImpulse = false;
                    }
                }
                
                if (syncImpulse)
                {
                    lastSyncCycles = cyclesRunning;
                    doSync = true;
                }
                else if (fcycles < 0) 
                {
                    doSync = true;
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
                syncImpulse = false;
                fcycles = FCYCLES_INIT;
                if (!config.useRayGun)
                {
                    displayedNext = (displayedNext+1) %2;
                    displayedNow =  (displayedNow+1)  %2;
                    displayer.updateDisplay();
                    vectorDisplay[displayedNext].count = 0;
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
            
            for (Breakpoint bp: tmp) removeBreakpoint(bp); // circumvent concurrent modification


            
            if (activeBreakpoint.size() != 0)
            {
                return breakpointExit;
            }
            //Fill buffer and call core to update sound
            // no sound while debugging (cycledOrg == 1)
            if (soundCycles<=0)
            {
                soundCycles = 50000;
                if ((line != null) && (cyclesOrg>1))
                {
                    synchronized (line)
                    {
                        if (line != null)
                        {
                            int soundLength = line.available();
                            e8910.e8910_callback(soundBytes, soundLength);
                            soundLength = soundLength >soundBytes.length ? soundBytes.length : soundLength;
                            if (soundLength>=0)
                            {
                               //orgLine.write(soundBytes, 0, soundLength);
                                line.write(soundBytes, 0, soundLength);
                            }
                        }
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
        return reason;
    }
    long lastRecordCycle = 0;

    
    
    
    
    public void imagerStep()
    {
        // Para implementaion
        if (PARA)
        {
            imagerCountDown--; // one step
            if (imagerCountDown <= 0)
            {
                imagerOut = (!imagerOut);
                if (imagerOut) 
                {
                    imagerCountDown += 37600;
                } 
                else 
                {
                    imagerCountDown += 22400;
                }
            }
        }
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
        else if (address < 0x8000) 
        {
            cart.poke(address, value);
        }
    }

    // 8k BIOS
    private boolean loadBios()
    {
        try
        {
            Path path = Paths.get(config.usedSystemRom);
            byte[] biosData = Files.readAllBytes(path);
            for (int i=0; i< biosData.length;i++)
            {
                rom[i] = biosData[i];
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
        if (!loadBios()) 
        {
            log.addLog("Vecx: init() BIOS of vectrex not loaded!", WARN);
            return false;
        }
        
        try
        {
            // load Cartridge
            if (!cart.init(cartProp)) 
            {
                log.addLog("Vecx: init() cartridge not loaded!", WARN);
                return false;
            }
            e6809.e6809_reset();  
            vecx_reset();
            //initAudioLine();
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
        romName = filenameRom;
        if (checkForCartridge)
        {
            CartridgeProperties cartProp = CartridgePropertiesPanel.getCartridgeProp(filenameRom);
            if (cartProp != null)
            {
                return init(cartProp);
            }
        }
        if (!loadBios()) 
        {
            log.addLog("Vecx: init() BIOS of vectrex not loaded!", WARN);
            return false;
        }
        
        try
        {
            // load Cartridge
            cart.load(filenameRom);
            e6809.e6809_reset();  
            vecx_reset();
            // initAudioLine();
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
    public boolean saveStateToFile(String name)
    {
        CompleteState state = new CompleteState();
        state.rom = rom;
        state.cart = cart;
        
        state.putState(this);
        state.putState(this.e6809);
        state.putState(this.e8910);
        
        CSAMainFrame.serialize(state, "serialize"+File.separator+"StateSaveTest.ser");
        return true;
    }
    public boolean loadStateFromFile(String name)
    {
        try 
        {
            // this is sort of bad
            // but a shortcut to reinitializing listerners
            ArrayList<CartridgeListener> mListener = cart.getListener();
            
            CompleteState state = (CompleteState) CSAMainFrame.deserialize("serialize"+File.separator+"StateSaveTest.ser");
            rom = state.rom;
            cart = state.cart;
            cart.setListener(mListener);
            
            E6809State.deepCopy(state.e6809State, this.e6809);
            E8910State.deepCopy(state.e8910State, this.e8910);
            VecXState.deepCopy(state.eVecXState, this);
            cart.setBank(currentBank); // just bankswitch occurred
            cart.init();
            // initAudioLine();
            
            return true;
        } 
        catch (Throwable ex) 
        {
            log.addLog(ex, ERROR);
        }
        return false;
    }
    
    // all ringbuffers should 
    // be called when paused
    // or from "our" thread!
    private void addStateToRingbuffer()
    {
        if (goBackRingBuffer[ringBufferNext] == null) goBackRingBuffer[ringBufferNext] = new CompleteState();
        CompleteState state = goBackRingBuffer[ringBufferNext];
        state.putState(this);
        state.putState(e6809);
        state.putState(e8910);
             
        ringBufferNext = (ringBufferNext+1)%RING_BUFFER_SIZE;
        ringWalkStep=-1; 
    }  
    public boolean oneStepBackInRingbuffer()
    {
        if (!config.ringbufferActive) return false;
        if (ringWalkStep==-1) // if first step, than ringBufferNext-2 (-1 would be the last instruction - again, endless loop :-))
            ringWalkStep = (ringBufferNext+(RING_BUFFER_SIZE-2))%RING_BUFFER_SIZE;
        else
            ringWalkStep = (ringWalkStep+(RING_BUFFER_SIZE-1))%RING_BUFFER_SIZE;
        
        // if ringbuffer overflow
        if (ringBufferNext==ringWalkStep)
        {
            // 
            if (ringWalkStep == ((ringBufferNext+(RING_BUFFER_SIZE-1))%RING_BUFFER_SIZE))
                ringWalkStep=-1;
            else
                ringWalkStep=(ringWalkStep+1)%RING_BUFFER_SIZE; // preserve current position
            // we are at the end of the ringbuffer!
            return false;
        }
        
        // if ringbuffer last step is "empty"
        if (goBackRingBuffer[ringWalkStep] == null) 
        {
            if (ringWalkStep == ((ringBufferNext+(RING_BUFFER_SIZE-1))%RING_BUFFER_SIZE))
                ringWalkStep=-1;
            else
                ringWalkStep=(ringWalkStep+1)%RING_BUFFER_SIZE; // preserve current position
            // not last step was saved (yet)
            return false;
        }
            
        CompleteState state = goBackRingBuffer[ringWalkStep];

        E6809State.deepCopy(state.e6809State, this.e6809);
        E8910State.deepCopy(state.e8910State, this.e8910);
        VecXState.deepCopy(state.eVecXState, this);
        cart.setBank(currentBank); // just in case a bankswitch occurred
        displayer.directDraw(directDrawVector);
        return true;
    }
    public boolean oneStepForwardInRingbuffer()
    {
        if (!config.ringbufferActive) return false;
        if (ringWalkStep == -1)
        {
            // last position was "executed" we can not go further in ringbuffer
            // just do a single step - idiot!
            return false;
        }
        ringWalkStep = (ringWalkStep+1)%RING_BUFFER_SIZE;
        
        if (goBackRingBuffer[ringWalkStep] == null) 
        {
            // error!
            // should not happen :-)
            ringWalkStep=-1; // preserve current position
            // not last step was saved (yet)
            return false;
        }
            
        CompleteState state = goBackRingBuffer[ringWalkStep];
        
        E6809State.deepCopy(state.e6809State, this.e6809);
        E8910State.deepCopy(state.e8910State, this.e8910);
        VecXState.deepCopy(state.eVecXState, this);
        if (ringBufferNext==ringWalkStep+1)
        {
            ringWalkStep=-1; // wie hit the front!
        }
        cart.setBank(currentBank); // just in case a bankswitch occurred
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
    
    void timerStep()
    {
        ticksRunning++;
        ArrayList<VecX.TimerItem> timerItemListClone = (ArrayList<VecX.TimerItem>)timerItemList.clone();
        ArrayList<TimerItem> removeList = new ArrayList<TimerItem>();
        for (TimerItem t: timerItemListClone)
        {
            t.countDown--;
            if (t.countDown <=0)
            {
                if (t.whereToSet != null)   
                {
                    if (t.type == TIMER_RAMP_OFF_CHANGE) 
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
                    if (t.type == TIMER_RAMP_CHANGE) 
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
                    
                    if (t.type == TIMER_DAC_CHANGE)
                    {
                        /* output of port a feeds directly into the dac which then
                         * feeds the x axis sample and hold.
                         */
                        addTimerItem(new TimerItem(t.whereToSet.intValue, alg_xsh, TIMER_XSH_CHANGE));
                        doCheckMultiplexer();
                    }
                    if (t.type == TIMER_MUX_R_CHANGE)
                    {
                        noiseCycles = cyclesRunning;
                    }
                }
                removeList.add(t);
            }
        }
        synchronized (timerItemList)
        {
            for (TimerItem t: removeList)
            {
                timerItemList.remove(t);
            }
        }
    }
    /*
    void doCheckOrb()
    {
        doCheckMultiplexer();
        doCheckRamp();
    }
    */
    /* update the various analog values when orb is written. */
    void doCheckMultiplexer()
    {
        doCheckJoystick();
        if ((via_orb & 0x01) != 0) return;
        
        /* MUX has been enabled, state changed! */
        switch (alg_sel.intValue & 0x06) 
//        switch (via_orb & 0x06) 
        {
            case 0x00:
                /* demultiplexor is on */
                addTimerItem(new TimerItem(alg_DAC.intValue, alg_ysh, TIMER_MUX_Y_CHANGE));
                break;
            case 0x02:
                /* demultiplexor is on */
                addTimerItem(new TimerItem(alg_DAC.intValue, alg_rsh, TIMER_MUX_R_CHANGE));
                break;
            case 0x04:
                /* demultiplexor is on */
                addTimerItem(new TimerItem(alg_DAC.intValue , alg_zsh, TIMER_MUX_Z_CHANGE));
                break;
            case 0x06:
                /* sound output line */
                addTimerItem(new TimerItem(alg_DAC.intValue , alg_ssh, TIMER_MUX_S_CHANGE));
                break;
                
        }
    }

    // uses ORA instead of DAC, again this should not be emulation relevant
    void doCheckJoystick()
    {
        switch (via_orb & 0x06) 
        {
            case 0x00:
                alg_jsh = alg_jch0;
                break;
            case 0x02:
                alg_jsh = alg_jch1;
                break;
            case 0x04:
                alg_jsh = alg_jch2;
                break;
            case 0x06:
                alg_jsh = alg_jch3;
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
    void doCheckRamp()
    {
        if ((via_acr & 0x80)!=0) 
        {
            if (via_t1pb7==0)
                addTimerItem(new TimerItem(via_t1pb7, sig_ramp, TIMER_RAMP_CHANGE));
            else
                addTimerItem(new TimerItem(via_t1pb7, sig_ramp, TIMER_RAMP_OFF_CHANGE));
        } 
        else
        {
            if ((via_orb & 0x80) == 0)
                addTimerItem(new TimerItem(via_orb & 0x80 , sig_ramp, TIMER_RAMP_CHANGE));
            else
                addTimerItem(new TimerItem(via_orb & 0x80, sig_ramp, TIMER_RAMP_OFF_CHANGE));
        }
    }

    /* perform a single cycle worth of analog emulation */
    
    int THRES = 100;
    long noiseCycles = 0;
    void analogStep()
    {
        int sig_dx=0, sig_dy=0; // allways the delta from the last vector end position, to the new position
                                // even when zero is active!

        if (sig_zero.intValue == 0) 
        {
            noiseCycles = cyclesRunning;
            /* need to force the current point to the 'orgin' so just
             * calculate distance to origin and use that as dx,dy.
             */

            sig_dx = (ALG_MAX_X / 2 - (int)alg_curr_x);
            sig_dy = (ALG_MAX_Y / 2 - (int)alg_curr_y);
//            if ((sig_dx>1)||(sig_dy>1)) System.out.println(sig_dx+","+sig_dy);

            // this is just fun - not real!
            THRES -= 2;
            if (THRES<10) THRES =10;
            if ((ALG_MAX_X / 2 - (int)alg_curr_x)>THRES*THRES ) sig_dx = THRES*THRES;
            else if ((ALG_MAX_X / 2 - (int)alg_curr_x)<-THRES*THRES ) sig_dx = -THRES*THRES;
            else sig_dx = (ALG_MAX_X / 2 - (int)alg_curr_x);
            
            if ((ALG_MAX_Y / 2 - (int)alg_curr_y)>THRES*THRES ) sig_dy = THRES*THRES;
            else if ((ALG_MAX_Y / 2 - (int)alg_curr_y)<-THRES*THRES ) sig_dy = -THRES*THRES;
            else sig_dy = (ALG_MAX_Y / 2 - (int)alg_curr_y);
            
        } 
        else 
        {
            THRES = 60;
            if (sig_ramp.intValue== 0) 
            {
                sig_dx = alg_xsh.intValue;
                sig_dy = -alg_ysh.intValue;
                
                //fraction = false;
                if (rampOnFraction)
                {
                    rampOnFraction = false;
                    alg_curr_x -= (int)(((double)alg_xsh.intValue)*(config.rampOnFractionValue));
                    alg_curr_y -= -(int)(((double)alg_ysh.intValue)*(config.rampOnFractionValue));

                    // warmUp
                    alg_curr_x -= (int)(((double)alg_xsh.intValue)*(config.warmup));
                    alg_curr_y -= -(int)(((double)alg_ysh.intValue)*(config.warmup));
                }
            } 
            else 
            {
                //fraction = false;
                if (rampOffFraction)
                {
                    rampOffFraction = false;
                    alg_curr_x += (int)(((double)alg_xsh.intValue)*config.rampOffFractionValue);
                    alg_curr_y += -(int)(((double)alg_ysh.intValue)*config.rampOffFractionValue);

                    //cooldown
                    alg_curr_x += (int)(((double)alg_xsh.intValue)*(config.cooldown));
                    alg_curr_y += -(int)(((double)alg_ysh.intValue)*(config.cooldown));
                    
                    if (alg_vectoring == 1 && alg_curr_x >= 0 && alg_curr_x < ALG_MAX_X && alg_curr_y >= 0 && alg_curr_y < ALG_MAX_Y) 
                    {
                        /* we're vectoring ... current point is still within limits so
                         * extend the current vector.
                         */
                        alg_vector_x1 = (int)alg_curr_x;
                        alg_vector_y1 = (int)alg_curr_y;
                    }        
                }
                sig_dx = 0;
                sig_dy = 0;
            }
        }

        if (alg_vectoring == 0) 
        {
            if (sig_blank.intValue == 1 &&
                    alg_curr_x >= 0 && alg_curr_x < ALG_MAX_X &&
                    alg_curr_y >= 0 && alg_curr_y < ALG_MAX_Y &&
                    ((alg_zsh.intValue &0x80) ==0) &&  ((alg_zsh.intValue &0x7f) !=0)) 
            {
                /* start a new vector */
                alg_vectoring = 1;
                alg_vector_x0 = (int)alg_curr_x;
                alg_vector_y0 = (int)alg_curr_y;
                alg_vector_x1 = (int)alg_curr_x;
                alg_vector_y1 = (int)alg_curr_y;
                alg_vector_dx = alg_xsh.intValue;
                alg_vector_dy = -alg_ysh.intValue;
                alg_vector_speed = Math.max(Math.abs(alg_xsh.intValue), Math.abs(alg_ysh.intValue));
                
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
        } 
        else 
        {
            boolean yChanged = (-alg_ysh.intValue != alg_vector_dy) && (sig_ramp.intValue== 0);
            boolean xChanged = (alg_xsh.intValue != alg_vector_dx) && (sig_ramp.intValue== 0);
            
            /* already drawing a vector ... check if we need to turn it off */
            if ((sig_blank.intValue == 0) || ((alg_zsh.intValue &0x80) !=0) || ((alg_zsh.intValue &0x7f) ==0))
            {
                /* blank just went on, vectoring turns off, and we've got a
                 * new line.
                 */
                
                if ((sig_ramp.intValue== 0)     && (sig_blank.intValue == 0))     
                {
                    // ramping and blank just went enabled
                    // do a blank off delay
                    // make the vector a tiny bit longer!(sig_blank.intValue == 0)
                    alg_addline (alg_vector_x0, alg_vector_y0, alg_vector_x1+(int)(config.blankOnDelay*alg_vector_dx), alg_vector_y1+(int)(config.blankOnDelay*alg_vector_dy), alg_zsh.intValue, alg_curved, alg_vector_speed);
                }
                else
                {
                    boolean doLine = true;
                 
                    // if the last vector just because of timer (ramp = 1)
                    // and then a cycle later blank is set
                    // this should not be a "point"
                    // actually it should, since it is a brighter spot
                    // in this special emualation case
                    // the brighter spot is realized by the drawing routines anyway!
                    // since line end and start are the same point
                    // and a double draw happens!
                    /*
                    if (sig_blank.intValue==0)
                    {
                        if (vectorDisplay[displayedNext].count>0)
                        {
                            vector_t lastv = vectorDisplay[displayedNext].vectrexVectors[vectorDisplay[displayedNext].count-1];
                            if ( (lastv.x1 == alg_vector_x0) && (lastv.y1 == alg_vector_y0) )
                                doLine = false;
                        }
                        
                    }
                    if (doLine)
                        */
                    alg_addline (alg_vector_x0, alg_vector_y0, alg_vector_x1, alg_vector_y1, alg_zsh.intValue, alg_curved, alg_vector_speed);
                    
                }
                alg_vectoring = 0;
            } 
            
            
            else if (xChanged || yChanged || alg_zsh.intValue != alg_vector_color ||  (sig_zero.intValue == 0) || ((sig_ramp.intValue== 0) != alg_ramping) ) 
            {
                /* the parameters of the vectoring processing has changed.
                 * so end the current line.
                 */
                boolean inLimits = (alg_curr_x >= 0 && alg_curr_x < ALG_MAX_X && alg_curr_y >= 0 && alg_curr_y < ALG_MAX_Y);
                
                
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
                    alg_addline (alg_vector_x0, alg_vector_y0, alg_vector_x1, alg_vector_y1, alg_vector_color, alg_curved, alg_vector_speed);

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
        
        if (config.efficiencyEnabled)
        {
            double xTest = alg_curr_x - (ALG_MAX_X / 2);
            double yTest = alg_curr_y - (ALG_MAX_Y / 2);

            double xPercent = Math.abs( xTest / (ALG_MAX_X / 2) );
            double yPercent = Math.abs( xTest / (ALG_MAX_X / 2) );

            double xEfficience = 1.0-(xPercent)/config.efficiency;
            double yEfficience = 1.0-(yPercent)/config.efficiency;

            alg_curr_x += ((double)sig_dx)*xEfficience;
            alg_curr_y += ((double)sig_dy)*yEfficience;
        }
        else
        {
        
            alg_curr_x += sig_dx;
            alg_curr_y += sig_dy;
        }        
/*        
        if (alg_curr_x<(ALG_MAX_X / 2)) alg_curr_x += Math.abs(config.drift_x);
        else alg_curr_x -= Math.abs(config.drift_x);
        
        if (alg_curr_y<(ALG_MAX_Y / 2)) alg_curr_y += Math.abs(config.drift_y);
        else alg_curr_y -= Math.abs(config.drift_y);
*/
        
        alg_curr_x-= config.drift_x;
        alg_curr_y-= config.drift_y;

        if (config.emulateIntegrationOverflow)
        {
            double xOverflow = ((double)sig_dx) / config.overflowFactor;
            double yOverflow = ((double)sig_dy) / config.overflowFactor;

            alg_curr_x+= yOverflow;
            alg_curr_y+= xOverflow;
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
        
        
        
        if (alg_vectoring == 1 && alg_curr_x >= 0 && alg_curr_x < ALG_MAX_X && alg_curr_y >= 0 && alg_curr_y < ALG_MAX_Y) 
        {
            /* we're vectoring ... current point is still within limits so
             * extend the current vector.
             */
            alg_vector_x1 = (int)alg_curr_x;
            alg_vector_y1 = (int)alg_curr_y;
        }

        
        if (config.useRayGun)
        {
            if (alg_oldBlank != 0)
            {
                int dwell = Math.max(Math.abs(sig_dx), Math.abs(sig_dy));
                displayer.rayMove((int)alg_old_x, (int)alg_old_y, (int)alg_curr_x, (int)alg_curr_y, alg_oldzsh, dwell, alg_curved);
            }

            alg_oldRamp = sig_ramp.intValue;
            alg_oldZero = sig_zero.intValue;
            alg_oldBlank = sig_blank.intValue;
            alg_oldzsh= alg_zsh.intValue;

            alg_old_x = alg_curr_x;
            alg_old_y = alg_curr_y;
        }
        
        
        if ((sig_ramp.intValue== 1) || (sig_blank.intValue == 0)/*|| (sig_zero.intValue == 0)*/)
        {
            alg_curved = false;
        }
    }
    static final int WR_UNKOWN = 0;
    static final int WR_FIRST_FOUND = 1;
    int wrStatus = WR_UNKOWN;
    
    void checkWaitRecal()
    {
        if (e6809.reg_pc == testAddressFirst) 
        {
            lastTestTicks = ticksRunning;
            wrStatus = WR_FIRST_FOUND;
            return;
        }
        if (e6809.reg_pc == testAddressSecond) 
        {
            if (wrStatus == WR_FIRST_FOUND)
            {
                waitRecalBuffer[waitRecalBufferNext] =  (int)(ticksRunning - lastTestTicks);
                waitRecalBufferNext = (waitRecalBufferNext+1) %WAIT_RECAL_BUFFER_SIZE;
                wrStatus = WR_UNKOWN;
            }
        }
    }
    void setTrackingAddress(int start,int end)
    {
        testAddressFirst = start;
        testAddressSecond = end;
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
    void checkMemWriteBreakpoint(int address, int data)
    {
        if (!config.breakpointsActive) return;
        synchronized (breakpoints[Breakpoint.BP_TARGET_MEMORY])
        {
            for (Breakpoint bp: breakpoints[Breakpoint.BP_TARGET_MEMORY])
            {
                if ((bp.type & Breakpoint.BP_WRITE) == Breakpoint.BP_WRITE)
                {
                    if (((address&0xffff) == bp.targetAddress) && (cart.getCurrentBank() == bp.targetBank))
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
                if ((bp.type & Breakpoint.BP_READ) == Breakpoint.BP_READ)
                {
                    if (((address&0xffff) == bp.targetAddress) && (cart.getCurrentBank() == bp.targetBank))
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
    void checkVIABreakpoint(int register, int oldValue, int newValue)
    {
        if (!config.breakpointsActive) return;
        synchronized (breakpoints[Breakpoint.BP_TARGET_VIA])
        {
            for (Breakpoint bp: breakpoints[Breakpoint.BP_TARGET_VIA])
            {
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
        synchronized (breakpoints[bp.targetType])
        {
            boolean removed = breakpoints[bp.targetType].remove(bp);
            if (!removed)
            {
                // try finding the SAME
            }
        }        
        if (bp.memInfo != null)
        {
            bp.memInfo.removeBreakpoint(bp);
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
            removeBreakpoint(bp);
        }
        
    }
    

    // dac is funny
    // it seems that the delay depends on:
    // a) the old value
    // b) the new value
    // the generation of the vectrex
    
    // I would not have a CLUE what a good value would be
    // I have an old and a new vectrex (Serials: 30xxxx and 31xxx [no Buz])
    // for -$40 to 0 the old one has exactly a delay of 4 cycles
    // for -$40 to 0 the new one has exactly a delay of 2 cycles
    
    // for -$70 to 0 the old one has exactly a delay of 2 cycles
    // ... to be continued
    
    // the DAC delay is alltogether only interesting
    // if DAC is changed while ramping
    // general advice -> do not do that!
    public int getDACDelay(byte oldValue, byte newValue)
    {
        int generation = config.generation;
        if (generation ==0) return 0;
        if (oldValue == newValue) return 0;
        
        int delay = 0;
        if (newValue<oldValue) return 0;
        if (oldValue > -0x10) delay = 0;
        if (oldValue < -0x10) delay++;
        if (oldValue < -0x20) delay++;
        if (oldValue < -0x20) delay++;
        if (oldValue < -0x30) delay++;
//        if (oldValue < -0x50) delay--;
        if (oldValue < -0x60) delay--;
        if (generation>2)
        {
            delay = delay / 2;
        }
        return delay;
    }
    public boolean recording = false;
    int recordingType = REC_YM;
    boolean recordingIsAddress = true;
    int recordingAddress = 0;
    String recordingFilename = "";
    ArrayList<byte[]> recordData;
    public void startRecord(String filename, int type, boolean isAddress , int address)
    {
        if (recording) return;
        recordingAddress = address;
        recordingFilename = filename;
        recordingType = type;
        recordingIsAddress = isAddress;
        recording = true;
        recordData = new ArrayList<>();
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
                    output = new BufferedOutputStream(new FileOutputStream(recordingFilename));
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
                                if (r == 13) toWrite = (byte) (toWrite & 0x0f);
                                if (r == 14) toWrite = (byte) (toWrite & 0x1f);
                                if (r == 15) toWrite = 0;
                                if (r == 16) toWrite = 0;
                                if (r == 13) 
                                {
                                    if (i>0)
                                    {
                                        if (toWrite == (byte) ((recordData.get(i-1)[r]) & 0x0f))
                                            toWrite = (byte)0xff;
                                    }
                                    else
                                        toWrite = (byte)0xff;
                                }
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
                                if (r == 13) toWrite = (byte) (toWrite & 0x0f);
                                if (r == 14) toWrite = (byte) (toWrite & 0x1f);
                                if (r == 15) toWrite = 0;
                                if (r == 16) toWrite = 0;
                                if (r == 13) 
                                {
                                    if (i>0)
                                    {
                                        if (toWrite == (byte) ((recordData.get(i-1)[r]) & 0x0f))
                                            toWrite = (byte)0xff;
                                    }
                                    else
                                        toWrite = (byte)0xff;
                                }
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
                                if (r == 13) toWrite = (byte) (toWrite & 0x0f);
                                if (r == 14) toWrite = (byte) (toWrite & 0x1f);
                                if (r == 15) toWrite = 0;
                                if (r == 16) toWrite = 0;
                                if (r == 13) 
                                {
                                    if (i>0)
                                    {
                                        if (toWrite == (byte) ((recordData.get(i-1)[r]) & 0x0f))
                                            toWrite = (byte)0xff;
                                    }
                                    else
                                        toWrite = (byte)0xff;
                                }
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
        synchronized(recordData)
        {
            if (recordData == null) return;
            byte[] psgData = new byte[16];
            recordData.add(psgData);
            for (int i=0; i<16; i++)
            {
                psgData[i] = (byte) (e8910.snd_regs[i]&0xff);
            }
        }
    }
}

