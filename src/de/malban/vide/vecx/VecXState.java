/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx;

import de.malban.vide.vecx.cartridge.DS2430;
import de.malban.vide.VideConfig;
import de.malban.vide.vecx.cartridge.Cartridge;
import static de.malban.vide.vecx.VecXStatics.TIMER_ACTION_NONE;
import java.io.Serializable;
import java.util.ArrayList;

/**
 *
 * @author malban
 */
public class VecXState implements Serializable
{
    public static class vector_t implements Serializable
    {
        public int x0, y0; /* start coordinate */
        public int x1, y1; /* end coordinate */
        public int speed;
        public int color;    // Brightness only!
        public boolean midChange = false;
        public ArrayList<Integer> callStack;
    };
    static class TimerItem implements Serializable
    {
        int countDown=0;
        int valueToSet = 0;
        IntegerPointer whereToSet;
        int type=TIMER_ACTION_NONE;
        TimerItem(TimerItem t)
        {
            countDown = t.countDown;
            valueToSet = t.valueToSet;
            whereToSet = t.whereToSet;
            type = t.type; 
        }
        TimerItem(int when, int value, IntegerPointer destination, int t)
        {
            countDown = when;
            valueToSet = value;
            whereToSet = destination;
            type = t; 
        }
        TimerItem(int value, IntegerPointer destination, int t)
        {
            
            countDown = VideConfig.getConfig().delays[t];
            valueToSet = value;
            whereToSet = destination;
            type = t; 
        }
        TimerItem(int when, int t)
        {
            countDown = when;
            valueToSet = -1;
            whereToSet = null;
            type = t; 
        }
    }
    String romName = "";
    int[] ram = new int[1024];
    ArrayList<VecX.TimerItem> timerItemList = new ArrayList<VecX.TimerItem>();

    Cartridge cart = new Cartridge();
    VecVoice vecVoice = null;
    
    /* the sound chip registers */
     public int  snd_select;

    /* the via 6522 registers */
     public int via_ora;
     public int via_orb;
     public int via_ddra;
     public int via_ddrb;
     public int via_t1on;  /* is timer 1 on? */
     public int via_t1int; /* are timer 1 interrupts allowed? */
     public int via_t1c;
     public int via_t1ll;
     public int via_t1lh;
     public int via_t1pb7; /* timer 1 controlled version of pb7 */
     public int via_t2on;  /* is timer 2 on? */
     public int via_t2int; /* are timer 2 interrupts allowed? */
     public int via_t2c;
     public int via_t2ll;
     public int via_sr;
     public int via_srb;   /* number of bits shifted so far */
     public int via_src;   /* shift counter */
     public int via_srclk;
     public int via_acr;
     public int via_pcr;
     public int via_ifr;
     public int via_ier;
     public int via_ca1;
     public int via_ca2;
     public int via_cb2h;  /* basic handshake version of cb2 */
     public int via_cb2s;  /* version of cb2 controlled by the shift register */
     
     public long lastShiftRegWrite = 0;
     public boolean via_stalling = false;

     public IntegerPointer alg_sel = new IntegerPointer(); // current mux selection, is exact copy of ORB
     public IntegerPointer sig_zero = new IntegerPointer();
     public IntegerPointer sig_ramp = new IntegerPointer();
     public IntegerPointer sig_blank = new IntegerPointer();
     public IntegerPointer alg_rsh = new IntegerPointer();  /* zero ref sample and hold */
     public IntegerPointer alg_xsh = new IntegerPointer();  /* x sample and hold */
     public IntegerPointer alg_ysh = new IntegerPointer();  /* y sample and hold */
     public IntegerPointer alg_zsh = new IntegerPointer();  /* z sample and hold */
     public IntegerPointer alg_ssh = new IntegerPointer();  /* s sample and hold */
     
     public int alg_oldzsh = 0;   
     public int alg_oldRamp = 0;
     public int alg_oldZero = 0;
     public int alg_oldBlank = 0;
     public int alg_oldDAC = 0;
     public IntegerPointer alg_DAC  = new IntegerPointer();   

     public int alg_jsh = 0;  /* joystick sample and hold */
     public int alg_compare = 0;
     public int alg_jch0 = 0;		  /* joystick direction channel 0 */
     public int alg_jch1 = 0;		  /* joystick direction channel 1 */
     public int alg_jch2 = 0;		  /* joystick direction channel 2 */
     public int alg_jch3 = 0;		  /* joystick direction channel 3 */
     public double alg_old_x; /* old x position */
     public double alg_old_y; /* old y position */
     public double alg_curr_x; /* current x position */
     public double alg_curr_y; /* current y position */
     
     public boolean alg_curved = false;
     public boolean alg_ramping = false;
     public int alg_spline_compare_dx = Integer.MAX_VALUE;
     public int alg_spline_compare_dy = Integer.MAX_VALUE;
     
     public int ticksRunning = 0; // cycles of run instructions since last reset!
     public vector_t directDrawVector=null;

     public int alg_vectoring = 0;
     
    // vectors not saved
    public int alg_vector_x0 = 0; 
    public int alg_vector_y0 = 0;
    public int alg_vector_x1 = 0;
    public int alg_vector_y1 = 0;
    public int alg_vector_dx = 0;
    public int alg_vector_dy = 0;
    public int alg_vector_color = 0;
    public int alg_vector_speed = 0;
     
    
    public boolean lightpen=false;
    public int lightpenX = 0; // must be set from "gui"
    public int lightpenY = 0;
   
    public boolean imager = false;
    public int lastImagerData =0;
    public long lastImagerCycleCount =0;
    public int imagerPulse =0;
    public boolean imagerIn = true;
    public boolean imagerOut = true;
    public int imagerCountDown = 0;
    public int currentBank = 0;

    public long cyclesRunning=0;
    
    public boolean ds2430Enabled = false;
    public boolean vecVoiceEnabled = false;
    
    // no rom or cart
    public static void deepCopy(VecXState from, VecXState to)
    {
        deepCopy( from,  to, true, true);        
    }
    public static void deepCopy(VecXState from, VecXState to, boolean doRam, boolean doTimer)
    {
        to.romName = from.romName;
        if (doRam)
            System.arraycopy(from.ram, 0, to.ram, 0, from.ram.length);
        
        Cartridge.deepCopy(from.cart, to.cart, doRam, doTimer);
        to.ds2430Enabled = from.ds2430Enabled;
        to.vecVoiceEnabled = from.vecVoiceEnabled;

        if (from.vecVoiceEnabled)
        {
            to.vecVoice = from.vecVoice.clone();
        }
        
        
        
        
       to.lastShiftRegWrite = from.lastShiftRegWrite;
       to.via_stalling = from.via_stalling;
       to.snd_select= from.snd_select;
      /* the via 6522 registers */
       to.via_ora= from.via_ora;
       to.via_orb= from.via_orb;
       to.via_ddra= from.via_ddra;
       to.via_ddrb= from.via_ddrb;
       to.via_t1on= from.via_t1on;  /* is timer 1 on? */
       to.via_t1int= from.via_t1int; /* are timer 1 interrupts allowed? */
       to.via_t1c= from.via_t1c;
       to.via_t1ll= from.via_t1ll;
       to.via_t1lh= from.via_t1lh;
       to.via_t1pb7= from.via_t1pb7; /* timer 1 controlled version of pb7 */
       to.via_t2on= from.via_t2on;  /* is timer 2 on? */
       to.via_t2int= from.via_t2int; /* are timer 2 interrupts allowed? */
       to.via_t2c= from.via_t2c;
       to.via_t2ll= from.via_t2ll;
       to.via_sr= from.via_sr;
       to.via_srb= from.via_srb;   /* number of bits shifted so far */
       to.via_src= from.via_src;   /* shift counter */
       to.via_srclk= from.via_srclk;
       to.via_acr= from.via_acr;
       to.via_pcr= from.via_pcr;
       to.via_ifr= from.via_ifr;
       to.via_ier= from.via_ier;
       to.via_ca1= from.via_ca1;
       to.via_ca2= from.via_ca2;
       to.via_cb2h= from.via_cb2h; 
       to.via_cb2s= from.via_cb2s;  

       to.alg_DAC.intValue= from.alg_DAC.intValue;  
       to.alg_oldDAC= from.alg_oldDAC;  
       
       to.alg_sel.intValue= from.alg_sel.intValue;  
       to.sig_zero.intValue= from.sig_zero.intValue;  
       to.sig_ramp.intValue= from.sig_ramp.intValue;  
       to.sig_blank.intValue= from.sig_blank.intValue;  
       to.alg_rsh.intValue= from.alg_rsh.intValue;  
       to.alg_xsh.intValue= from.alg_xsh.intValue;  
       to.alg_ysh.intValue= from.alg_ysh.intValue;  
       to.alg_zsh.intValue= from.alg_zsh.intValue;  
       to.alg_ssh.intValue= from.alg_ssh.intValue;  
       to.alg_jsh= from.alg_jsh;   
       to.alg_compare= from.alg_compare;   
       to.alg_jch0= from.alg_jch0;   
       to.alg_jch1= from.alg_jch1;   
       to.alg_jch2= from.alg_jch2;   
       to.alg_jch3= from.alg_jch3;   
       to.alg_curr_x= from.alg_curr_x;   
       to.alg_curr_y= from.alg_curr_y;   
       to.alg_old_x= from.alg_old_x;   
       to.alg_old_y= from.alg_old_y;   

       to.alg_oldRamp= from.alg_oldRamp;   
       to.alg_oldZero= from.alg_oldZero;   
       to.alg_oldBlank= from.alg_oldBlank;   
       to.alg_oldzsh= from.alg_oldzsh;   
       to.alg_curved = from.alg_curved;
       
        to.alg_ramping = from.alg_ramping;
        to.alg_spline_compare_dx = from.alg_spline_compare_dx;
        to.alg_spline_compare_dy = from.alg_spline_compare_dy;
       
       
       if (from.directDrawVector != null)
       {
           to.directDrawVector = new vector_t();
           to.directDrawVector.x0 = from.directDrawVector.x0;
           to.directDrawVector.x1 = from.directDrawVector.x1;
           to.directDrawVector.y0 = from.directDrawVector.y0;
           to.directDrawVector.midChange = from.directDrawVector.midChange;
           to.directDrawVector.y1 = from.directDrawVector.y1;
           to.directDrawVector.color = from.directDrawVector.color;
           to.directDrawVector.speed = from.directDrawVector.speed;
           to.directDrawVector.callStack = new ArrayList<Integer>();
           if (from.directDrawVector.callStack != null)
               for (int cs: from.directDrawVector.callStack)
                   to.directDrawVector.callStack.add(cs);
           
                           
       }
       
       to.alg_vectoring= from.alg_vectoring;   

       to.alg_vector_x0= from.alg_vector_x0;   
       to.alg_vector_y0= from.alg_vector_y0;   
       to.alg_vector_x1= from.alg_vector_x1;   
       to.alg_vector_y1= from.alg_vector_y1;   
       to.alg_vector_dx= from.alg_vector_dx;   
       to.alg_vector_dy= from.alg_vector_dy;   
       to.alg_vector_color= from.alg_vector_color;   
       to.alg_vector_speed= from.alg_vector_speed;   

       to.ticksRunning= from.ticksRunning;   
       to.cyclesRunning = from.cyclesRunning;// this one is for dissi alone!

       to.lightpen = from.lightpen;
       to.lightpenX = from.lightpenX;
       to.lightpenY = from.lightpenY;

       to.currentBank = from.currentBank;
       
       if (doTimer)
       {
           synchronized (from)
           {
                to.timerItemList = new ArrayList<VecX.TimerItem>();
                for (VecX.TimerItem it: from.timerItemList)
                {
                    to.timerItemList.add(new VecX.TimerItem(it));
                }
           }
       }
       
       
    }
}

