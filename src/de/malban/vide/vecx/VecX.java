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


import de.malban.vide.vecx.devices.VectrexJoyport;
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
import static de.malban.gui.panels.LogPanel.VERBOSE;
import static de.malban.gui.panels.LogPanel.WARN;
import de.malban.vide.veccy.VectorListScanner;
import de.malban.vide.vecx.cartridge.Cartridge;
import static de.malban.vide.vecx.cartridge.Cartridge.FLAG_DS2430A;
import static de.malban.vide.vecx.cartridge.Cartridge.FLAG_DS2431;
import de.malban.vide.vecx.devices.Imager3dDevice;
import de.malban.vide.vecx.devices.JoyportDevice;
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
    public static final int START_TYPE_DEBUG = 1;
    public static final int START_TYPE_RUN = 2;
    public static final int START_TYPE_INJECT = 3;

    // for easier access from cart
    // config is here public
    // other wise we could also duplicate config in cart...
    // this way it is
    // easier to keep consistency while load and save/state
    public VideConfig config = VideConfig.getConfig();
    LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
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
    
    public transient VectrexJoyport[] joyport= new VectrexJoyport[2];
     
    // dummy displayer, which does nothing!
    public transient DisplayerInterface displayer = new DisplayerDummy();
        
    
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
        joyport[0]= new VectrexJoyport(0, this);
        joyport[1]= new VectrexJoyport(1, this);
        
        e6809 = new E6809();
        e6809.vecx=this;        
        e8910 = new E8910();
        e8910.setVectrexJoyport(joyport);
        e8910.e8910_init_sound();
        for (int i=0; i<Breakpoint.BP_TARGET_COUNT; i++)
            breakpoints[i] = new ArrayList<Breakpoint>();
/*
        if (TinySound.isInitialized())
        {
            soundBytes = new byte[E8910.getSoundBufferSize()];
            line = E8910.getVectrexLine();
            //line = E8910.getVectrexLine(); //TinySound.getOutStreamVectrex();
            line.start();
        }
*/        
    }
    void deinit()
    {
        if (e8910 != null)
        {
            e8910.e8910_done_sound();
        }
//        deinitAudio();
        joyport[0].deinit();
        joyport[1].deinit();
        displayer = null;
    }
/*
    void deinitAudio()
    {
        if (line != null)
            line.unload();
        line = null;
    }
    */
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
        else if (address < 0x8000) 
        {
            /* cartridge */
            data = cart.get_cart(address);
        } 
        else if ((address >= 0x8000) && (address < 0x8800) && (extraRam8000_8800Enabled))  
        {
            /* cartridge */
            data = cart.get_cart(address);
        } 
        else if ((address == 0xa000) && (extraRam8000_8800Enabled))  
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
        if (config.codeScanActive) dissiMem.mem[address].addAccess(e6809.reg_pc, e6809.reg_dp, MEMORY_READ);
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
                        if ((via_ddrb & 0x40) == 0) // pb6 is input
                        {
                            data = data & (0xff-0x40); // ensure pb6 =0
                            data = data | (pb6_in); // ensure pb6 in value
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
                        addTimerItem(new TimerItem(data, null, TIMER_SHIFT_READ));
                        
/*                        
s                        if (shouldStall((int)(cyclesRunning - lastShiftTriggered)))
                        {
                            via_stalling = true;
                            via_ifr &= 0xfb; /* remove shift register interrupt flag * /
                            via_srclk = 1;
                            int_update ();
//                            // dunno if "stalling" cycle counter should reset...
                            lastShiftTriggered = cyclesRunning;
                        }
                        else
                        {
                            via_stalling = false;

                            lastShiftTriggered = cyclesRunning;
                            via_ifr &= 0xfb; /* remove shift register interrupt flag * /
                            via_srb = 0;
                            via_srclk = 1;
                            int_update ();
                        }
                        */
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
            data = cart.get_cart(address);
        } 
        else if ((address >= 0x8000) && (address < 0x8800) && (extraRam8000_8800Enabled))  
        {
            /* cartridge */
            data = cart.get_cart(address);
        } 
        else if ((address == 0xa000) && (extraRam8000_8800Enabled))  
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
        if (config.codeScanActive) dissiMem.mem[address].addAccess(e6809.reg_pc, e6809.reg_dp, MEMORY_WRITE);
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
            }
            if ((address & 0x1000) != 0)
            {
                switch (address & 0xf) 
                {
                    case 0x0:
                        /*
                        // if pb6 in input mode, don't change pb6
                        if ((via_ddrb & 0x40) == 0)
                        {
                            if ((data & 0x040) == 0x40)
                            {
                                data = data | 0x40;
                            }
                            else
                            {
                                data = data & (0xff - 0x40);
                            }
                        }
                        */
                        checkVIABreakpoint(0, via_orb, data);                  

                        boolean pb6 = setPB6FromVectrex(data, via_ddrb, true);
                        if ((data & 0x7) != (via_orb & 0x07)) // check if state of mux sel changed
                        {
                            addTimerItem(new TimerItem(data, alg_sel, TIMER_MUX_SEL_CHANGE));
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
                            addTimerItem(new TimerItem(via_cb2h, sig_blank, TIMER_BLANK_CHANGE));
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
                            addTimerItem(new TimerItem(via_ca2,sig_zero, TIMER_ZERO));
                        }
                        via_ifr = via_ifr & (0xff-0x02); // clear ca1 interrupt
                    /* fall through */
                    case 0xf:
                        /* output of port a feeds directly into the dac which then
                         * feeds the x axis sample and hold.
                         */
                        addTimerItem(new TimerItem(getDACDelay((byte)(via_ora&0xff),(byte)( data&0xff)), data, alg_DAC, TIMER_DAC_CHANGE));
                        via_ora = data;
                        
                        snd_update(false);
                        break;
                    case 0x2:
                        boolean pb6_2 = setPB6FromVectrex(via_orb, data, false);
                        via_ddrb = data;
                        if (cart != null)
                        {
                            cart.setPB6InputEnabledFromExternal(!((data&0x40)==0x40));
                        }
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
                        
            addTimerItem(new TimerItem(data,null, TIMER_T1));
/*
                        via_t1on = 1; / * timer 1 starts running * /

                        if ((via_acr & 0x80)!=0)  
                        {
                            if (via_t1pb7!=0)
                                checkVIABreakpoint(0, via_orb, via_orb-via_t1pb7);                  
                        }
                        via_t1pb7 = 0;
                        
                        
                        doCheckRamp(false);
                        int_update ();
*/                        
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
                 
                        addTimerItem(new TimerItem(data, via_shift, TIMER_SHIFT_WRITE));
                        
                        
                        
                        
/*                        
                        if (via_stalling)
                        {
                            via_ifr &= 0xfb; // * remove shift register interrupt flag * /
                           // via_srb = 0;
                            via_srclk = 1;
                            int_update ();
                            
                        }
                        else
                        {
                            // do normal - exactly as above
                            lastShiftTriggered = cyclesRunning;
                            via_sr = data;
                            via_ifr &= 0xfb; /* remove shift register interrupt flag * /
                            via_srb = 0;
                            via_srclk = 1;
                            int_update ();
                        }
*/
                        break;
                    case 0xb:
                        if ((via_acr & 0x1c) != (data & 0x1c))
                        {
                            // new CSA
                            if ((data & 0x1c) == 0) // shift reg is switched off - so take the manual value
                            {
                                addTimerItem(new TimerItem(via_cb2h, sig_blank, TIMER_BLANK_CHANGE));
                            }
                            else // use the last shift
                            {
    //                            addTimerItem(new TimerItem(via_cb2s, sig_blank, TIMER_BLANK_CHANGE));
                                addTimerItem(new TimerItem(0, sig_blank, TIMER_BLANK_CHANGE));
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
                        // new CSA - it seems manually setting blank
                        // only works if shift is disabled
                        
                        
// Thrust stall Gen 3 needs this commented out!                        
                        
// some line draw needed this enabled ????                        
                        
//                        if ((via_acr & 0x1c) == 0)
                        {
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
        else if ((address < 0x8000) &&(cart.isExtremeMulti()))
        {
            cart.write(address,(byte) data);
        }
        else if ((address >= 0x2000) && (address < 0x2800) && (extraRam2000_2800Enabled))
        {
            cart.write(address,(byte) data);
        }
        else if ((address >= 0x8000) && (address < 0x8800) && (extraRam8000_8800Enabled))  
        {
            cart.write(address,(byte) data);
        }
        else if ((address == 0xa000) && (extraRam8000_8800Enabled))  
        {
            cart.write(address,(byte) data);
        }
        else if ((address >= 0x6000) && (address < 0x6000+8192) && (extraRam6000_7fff_8k_Enabled))  
        {
            cart.write(address,(byte) data);
        } 
        else
        {
            log.addLog("RAM access at: $" + String.format("%04X", address)+", $"+String.format("%02X", (data&0xff))+" from $"+String.format("%04X", e6809.reg_pc), VERBOSE);
            checkROMBreakPoint(address, data);
        }
    }

    void vecx_reset()
    {
       vecx_reset(true);
    }
    void vecx_reset(boolean clearBreakpoints)
    {
        int r;
        if (displayer != null)
            displayer.setLED(0);

        /* ram */
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

        /* input buttons */
        // this "write" does not work anymore, since it now
        // reespects the input enable register

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

        if (clearBreakpoints)
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
    }

    // called befor VIA is changed
    // so we have access to old via data

    // returns state of PB6
    // calls cart on line change
    private boolean setPB6FromVectrex(int tobe_via_orb, int tobe_via_ddrb, boolean orbInitiated)
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
            checkExternalLineBreakpoint(pb6);
            old_pb6 = pb6;
        }
        if (pb6)
        {
            pb6_out = 0x40;
          
            if (!isDualVec)
            {
                if (!extraRam8000_8800Enabled)
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
    int pb6_pulseCounter = 0;
        /* perform a single cycle worth of via emulation.
     * via_sstep0 is the first postion of the emulation.
     */
    void via_sstep0 ()
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
                    if ((via_acr & 0x80)!=0)  
                    {
                        if (via_t1pb7==0x80)
                            checkVIABreakpoint(0, via_orb, via_orb-0x80); 
                        else
                            checkVIABreakpoint(0, via_orb, via_orb+0x80); 
                    }
                    via_t1pb7 = 0x80 - via_t1pb7;
                    doCheckRamp(false);
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
                        doCheckRamp(false);
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
            /*
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
            */
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

        /*
        * NOTE!
        TODO:
        SHIFTING every two steps should also be implemented for non system clock shifting - didn't do yet!
        */
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
                        addTimerItem(new TimerItem(via_cb2s, sig_blank, TIMER_BLANK_CHANGE));
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

        // documentation of VIA
        if (via_ca1 !=old_via_ca1)
        {
            checkVIABreakpoint(16, old_via_ca1, via_ca1);
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
        if (config.useRayGun) return;
        int index;
        
        if (imagerMode)
        {
            if (((left == -1)||(left == 0)) && ((right==-1)||(right == 0))) return;
        }

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
        v.imagerColorLeft = left;
        v.imagerColorRight = right;
        
        if (color < 0x7f) color = color/3;
        

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
            directDrawVector.imagerColorLeft = left;
            directDrawVector.imagerColorRight = right;
            displayer.directDraw(directDrawVector);
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
    
    public void vectrexNonCPUStep(int cycles)
    {
        if (!config.cycleExactEmulation) return;
        for (int c = 0; c < cycles; c++) 
        {
            if (cart != null) cart.cartStep(cyclesRunning);
            via_sstep0();
            doTimerStep();
            // timer after via, to make sure befor analog step, that 0 timers are respected!
            analogStep();
            if (joyport[0] != null) joyport[0].step();
            if (joyport[1] != null) joyport[1].step();
            via_sstep1();
            nonCPUStepsDone++;
            cyclesRunning++;
        }
    }
    int nonCPUStepsDone = 0;
    ArrayList<Breakpoint> tmp = new ArrayList<Breakpoint>();
    
    
    boolean syncImpulse = false;
    long lastSyncCycles = 0;
    long soundCycles = 0;
    public long getCycles()
    {
        return cyclesRunning;
    }
    static int UID_ = 1;
    static int uid = UID_++;    
    volatile boolean debugging = false;
    boolean stop = false;
    public boolean isDebugging()
    {
        return debugging;
    }
    void stopEmulation()
    {
        debugging = true;
        stop = true;
    }
    // for speed measurement    
    long cyclesDone=0;
    boolean thisWaitRecal = false;
    long lastWaitRecal=0;
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
        if (ringWalkStep != -1)
        {
            ringBufferNext = (ringWalkStep+1)%RING_BUFFER_SIZE;
            ringWalkStep = -1;
        }
        
        while ((cycles > 0) && (!stop))
        {
//System.out.println(uid+": "+cyclesRunning);            
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

            
            
            icycles = e6809.e6809_sstep (via_ifr & 0x80, firq);
            firq = 0;
            if (config.codeScanActive) 
            {
                for (int i=0; i<icycles; i++)
                {
                    dissiMem.mem[(pc+i)%65536].addAccess(e6809.reg_pc%65536, e6809.reg_dp, MEMORY_CODE);
                }
            }
            
            for (c = 0; c < (icycles-nonCPUStepsDone); c++) 
            {
                if (cart != null) cart.cartStep(cyclesRunning);
                via_sstep0();
                doTimerStep();
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
                    if (((via_ifr &0x02) == 0x02) && ((via_ier &0x02) == 0x02) && (e6809.get_cc(E6809.FLAG_I) == 0))
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
            
            for (Breakpoint bp: tmp) 
                displayer.breakpointRemove(bp); // circumvent concurrent modification


            
            if (activeBreakpoint.size() != 0)
            {
                debugging = true;
                cyclesDone=cyclesRunning-cyclesStart;
                return breakpointExit;
            }
            //Fill buffer and call core to update sound
            // no sound while debugging (cycledOrg == 1)
            if (soundCycles<=0)
            {
                soundCycles = 30000; // Hz 50
                if (cyclesOrg>1)
                {
                    e8910.updateSound();
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
    long lastRecordCycle = 0;
    
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
    private boolean loadOrgBios()
    {
        try
        {
            Path path = Paths.get("system"+File.separator+"system.img");
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
        ds2430Enabled = false;
        ds2431Enabled = false;
        microchipEnabled = false;
        extraRam2000_2800Enabled = false;
        extraRam8000_8800Enabled = false;
        extraRam6000_7fff_8k_Enabled = false;
        isDualVec = false;
        isDualVec = false;
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
            ds2430Enabled = (cartProp.getTypeFlags()&FLAG_DS2430A)!=0;
            ds2431Enabled = (cartProp.getTypeFlags()&FLAG_DS2431)!=0;
            microchipEnabled = (cartProp.getTypeFlags()&Cartridge.FLAG_MICROCHIP)!=0;
            extraRam2000_2800Enabled = (cartProp.getTypeFlags()&Cartridge.FLAG_RAM_ANIMACTION)!=0;
            extraRam8000_8800Enabled = (cartProp.getTypeFlags()&Cartridge.FLAG_RAM_RA_SPECTRUM)!=0;
            extraRam6000_7fff_8k_Enabled = (cartProp.getTypeFlags()&Cartridge.FLAG_LOGO)!=0;
            
            isDualVec = (cartProp.getTypeFlags()&Cartridge.FLAG_DUALVEC1)!=0;
            isDualVec = isDualVec || ((cartProp.getTypeFlags()&Cartridge.FLAG_DUALVEC2)!=0);

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
        cart = new Cartridge();
        ds2430Enabled = false;
        ds2431Enabled = false;
        microchipEnabled = false;
        extraRam2000_2800Enabled = false;
        extraRam8000_8800Enabled = false;
        extraRam6000_7fff_8k_Enabled = false;
        isDualVec = false;
        isDualVec = false;
        joyport[0].deinit();
        joyport[1].deinit();
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
    public boolean saveStateToFile(String name)
    {
        CompleteState state = new CompleteState();
        state.rom = rom;
        state.cart = cart;
        
        state.putState(this);
        state.putState(this.e6809);
        state.putState(this.e8910);
        
        if (imagerMode)
            state.putState((Imager3dDevice)joyport[1].getDevice());
        
        CSAMainFrame.serialize(state, "serialize"+File.separator+"StateSaveTest.ser");
        return true;
    }
    // caller must ensure, that no
    // concurrent modification is done on the data
    // otherwise an exception will occur!
    public CompleteState getState()
    {
        CompleteState state = new CompleteState();
        state.rom = rom;
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
    public boolean loadStateFromFile(String name)
    {
        try 
        {
            joyport[0].deinit();
            joyport[1].deinit();
            // this is sort of bad
            // but a shortcut to reinitializing listerners
            ArrayList<CartridgeListener> mListener = cart.getListener();
            
            CompleteState state = (CompleteState) CSAMainFrame.deserialize("serialize"+File.separator+"StateSaveTest.ser");
            rom = state.rom;
            cart = state.cart;
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
        initFromState(state);
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
        if (ringBufferNext==ringWalkStep+1)
        {
            ringWalkStep=-1; // wie hit the front!
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
    
    void doTimerStep()
    {
        ticksRunning++;
        ArrayList<VecX.TimerItem> timerItemListClone = (ArrayList<VecX.TimerItem>)timerItemList.clone();
        ArrayList<TimerItem> removeList = new ArrayList<TimerItem>();
        for (TimerItem t: timerItemListClone)
        {
            t.countDown--;
            if (t.countDown <=0)
            {
                if (t.type == TIMER_SHIFT_READ)
                {
                    
                    alternate = true;
                    if (shouldStall((int)(cyclesRunning - lastShiftTriggered)))
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
                    via_ifr &= 0xbf; /* remove timer 1 interrupt flag */
                    via_t1int = 1;

                    if ((via_acr & 0x80)!=0)  
                    {
                        if (via_t1pb7!=0)
                            checkVIABreakpoint(0, via_orb, via_orb-via_t1pb7);                  
                    }
                    via_t1pb7 = 0;
                    doCheckRamp(false);
                    int_update ();
                }
                else if (t.whereToSet != null)   
                {
                    if (t.type == TIMER_SHIFT_WRITE)
                    {
                        alternate = true;

                        if (via_stalling)
                        {
                            via_ifr &= 0xfb; // * remove shift register interrupt flag * /
                           // via_srb = 0;
                            via_srclk = 1;
                            int_update ();
                            
                        }
                        else
                        {
                            // do normal - exactly as above
//                            via_stalling = false;
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
//        int com = (via_ora^0x80);
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
                    addTimerItem(new TimerItem(via_t1pb7, sig_ramp, TIMER_RAMP_CHANGE));
                else
                    addTimerItem(new TimerItem(via_t1pb7, sig_ramp, TIMER_RAMP_OFF_CHANGE));
            } 
        }
        else
        {
            if ((via_acr & 0x80)==0) 
            {
                if ((via_orb & 0x80) == 0)
                    addTimerItem(new TimerItem(via_orb & 0x80 , sig_ramp, TIMER_RAMP_CHANGE));
                else
                    addTimerItem(new TimerItem(via_orb & 0x80, sig_ramp, TIMER_RAMP_OFF_CHANGE));
            }
        }
    }

    /* perform a single cycle worth of analog emulation */
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

            

            if (alg_curr_x<config.ALG_MAX_X/2)
            {
                // smaller 0
                sig_dx+= ((config.ALG_MAX_X/2)-alg_curr_x)/2;
            }
            else if (alg_curr_x>config.ALG_MAX_X/2)
            {
                // greater 0
                sig_dx-= (alg_curr_x-(config.ALG_MAX_X/2))/2;
            }
            if (alg_curr_y<config.ALG_MAX_Y/2)
            {
                // smaller 0
                sig_dy+= ((config.ALG_MAX_Y/2)-alg_curr_y)/2;
            }
            else if (alg_curr_x>config.ALG_MAX_Y/2)
            {
                // greater 0
                sig_dy-= (alg_curr_y-(config.ALG_MAX_Y/2))/2;
            }
            
            sig_dx = (config.ALG_MAX_X / 2 - (int)alg_curr_x)/4;
            sig_dy = (config.ALG_MAX_Y / 2 - (int)alg_curr_y)/4;
            
            
        } 
        //else 
        // no else anymore, integrating can be done WHILE zeroing (see my discussion in forum Vectrex32)
        {
            if (sig_ramp.intValue== 0) 
            {
                sig_dx += alg_xsh.intValue;
                sig_dy += -alg_ysh.intValue;
                
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
            if (sig_blank.intValue == 1 &&
                    alg_curr_x >= 0 && alg_curr_x < config.ALG_MAX_X &&
                    alg_curr_y >= 0 && alg_curr_y < config.ALG_MAX_Y &&
                    ((alg_zsh.intValue &0x80) ==0) &&  ((alg_zsh.intValue &0x7f) !=0)) 
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
                alg_vector_x0 = (int)alg_curr_x;
                alg_vector_y0 = (int)alg_curr_y;
                alg_vector_x1 = (int)alg_curr_x;
                alg_vector_y1 = (int)alg_curr_y;
                alg_vector_dx = alg_xsh.intValue;
                alg_vector_dy = -alg_ysh.intValue;
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
        } 
        else 
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
                
                if ((sig_ramp.intValue== 0)     && (sig_blank.intValue == 0))     
                {
                    // ramping and blank just went enabled
                    // do a blank off delay
                    // make the vector a tiny bit longer!(sig_blank.intValue == 0)
                    alg_addline (alg_vector_x0, alg_vector_y0, alg_vector_x1+(int)(config.blankOnDelay*alg_vector_dx), alg_vector_y1+(int)(config.blankOnDelay*alg_vector_dy), alg_zsh.intValue, alg_curved, alg_vector_speed, alg_leftEye, alg_rightEye);
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
            double xTest = alg_curr_x - (config.ALG_MAX_X / 2);
            double yTest = alg_curr_y - (config.ALG_MAX_Y / 2);

            double xPercent = Math.abs( xTest / (config.ALG_MAX_X / 2) );
            double yPercent = Math.abs( yTest / (config.ALG_MAX_Y / 2) );

            double xEfficience = 1.0-(xPercent)/config.efficiency;
            double yEfficience = 1.0-(yPercent)/config.efficiency;

            alg_curr_x += ((double)sig_dx)*xEfficience;
            alg_curr_y += ((double)sig_dy)*yEfficience;

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
        
        
        
        if (alg_vectoring == 1 && alg_curr_x >= 0 && alg_curr_x < config.ALG_MAX_X && alg_curr_y >= 0 && alg_curr_y < config.ALG_MAX_Y) 
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
                displayer.rayMove((int)alg_old_x, (int)alg_old_y, (int)alg_curr_x, (int)alg_curr_y, alg_oldzsh, dwell, alg_curved, alg_vector_speed, alg_leftEye, alg_rightEye);
            }

            alg_oldRamp = sig_ramp.intValue;
            alg_oldZero = sig_zero.intValue;
            alg_oldBlank = sig_blank.intValue;
            alg_oldzsh= alg_zsh.intValue;

            alg_old_x = alg_curr_x;
            alg_old_y = alg_curr_y;
        }
        
        
        if ((sig_ramp.intValue== 1) || (sig_blank.intValue == 0))
        {
            alg_curved = false;
        }
        if (Double.isNaN(alg_curr_x)) alg_curr_x = config.ALG_MAX_X/2;
        if (Double.isNaN(alg_curr_y)) alg_curr_y = config.ALG_MAX_Y/2;
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
    void checkROMBreakPoint(int address, int data)
    {
        if (!config.breakpointsActive) return;
        synchronized (breakpoints[Breakpoint.BP_TARGET_MEMORY])
        {
            for (Breakpoint bp: breakpoints[Breakpoint.BP_TARGET_MEMORY])
            {
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
                if ((bp.type & Breakpoint.BP_WRITE) == Breakpoint.BP_WRITE)
                {
                    if (((address&0xffff) == bp.targetAddress) && (cart.getCurrentBank() == bp.targetBank) )
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
                     if (((address&0xffff) == bp.targetAddress) && (cart.getCurrentBank() == bp.targetBank) )
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
                if ((bp.targetSubType  == Breakpoint.BP_SUBTARGET_VIA_CA1) && (register == 16))
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
        dissiMem.setCurrentBank(currentBank);

        if (!config.breakpointsActive) return;
        synchronized (breakpoints[Breakpoint.BP_TARGET_CARTRIDGE])
        {
            for (Breakpoint bp: breakpoints[Breakpoint.BP_TARGET_CARTRIDGE])
            {
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
    
    public boolean shouldStall(int shiftCycleDif)
    {
//        shiftCycleDif-=2; // correction factor due to cycle exact timings
        
        // if shift is CLR
        // then a write occurs 2 cycles after a read
        // it seems, that the stall from the first read should be taken...
//        a
        
        int generation = config.generation;
        if (generation == 0) return false; // if generation emulation is off, never stall
        if (shiftCycleDif<4) 
            return via_stalling;
        if (generation<3)
        {
            if (shiftCycleDif==15) return true;
        }
        if (generation==3)
        {
            if (shiftCycleDif==15) return true;
            if (shiftCycleDif==14) return true;
        }
        return false;
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
                    if (value == lastReg13) value = (byte)0xff;
                }
                psgData[i] = value;
            }
        }
    }
    
    
    // is a "fast" interupt initiated (from device port 0 Button 4)
    // only == 0 or !=0 is relevant
    int firq;
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
            e6809.reg_a = value&0xff;
            e6809.reg_b = (value>>8)&0xff;
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
}

