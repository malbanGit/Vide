/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx;

/**
 *
 * @author malban
 */
public abstract interface VecXStatics 
{
    public static final int EMU_EXIT_CYCLES_DONE = 1;
    public static final int EMU_EXIT_BREAKPOINT_CONTINUE = 2;
    public static final int EMU_EXIT_BREAKPOINT_BREAK = 3;

    
    public static final int TIMER_ACTION_NONE = 0;
    public static final int TIMER_ZERO = 1;
    public static final int TIMER_BLANK_ON_CHANGE = 2;
    public static final int TIMER_BLANK_OFF_CHANGE = 3;
    public static final int TIMER_RAMP_CHANGE = 4;
    public static final int TIMER_MUX_Y_CHANGE = 5;
    public static final int TIMER_MUX_S_CHANGE = 6;
    public static final int TIMER_MUX_Z_CHANGE = 7;
    public static final int TIMER_MUX_R_CHANGE = 8;
    public static final int TIMER_XSH_CHANGE = 9;
    public static final int TIMER_LIGHTPEN = 10;
    public static final int TIMER_RAMP_OFF_CHANGE = 11;
    public static final int TIMER_MUX_SEL_CHANGE = 12;
    public static final int TIMER_SHIFT = 13;
    public static final int TIMER_T1 = 14;
    
       
    public static final int TIMER_SHIFT_WRITE = TIMER_SHIFT+1024;
    public static final int TIMER_SHIFT_READ = TIMER_SHIFT+2048;
    
    
    public static int JOYSTICK_CENTER = 0x7f; // for whatever reason Debris does not like $80, $7f is ok though - is that a emulator test?
    
    
    public static boolean PARA = false;
    public static final int EMU_TIMER = 20; // milliseconds per frame, used by speed limit!


    public static final int VECTREX_MHZ		= 1500000; /* speed of the vectrex being emulated */
    public static final int VIA_MHZ             = 2000000;
    public static final int VECTREX_COLORS      = 128;     /* number of possible colors ... grayscale */
    public static final int VECTREX_PDECAY	= 30;      /* phosphor decay rate */
    public static final int FCYCLES_INIT        =  VECTREX_MHZ/ VECTREX_PDECAY;/* number of 6809 cycles before a frame redraw */
            /* max number of possible vectors that maybe on the screen at one time.
             * one only needs VECTREX_MHZ / VECTREX_PDECAY but we need to also store
             * deleted vectors in a single table
             */
    public static final int VECTOR_CNT		= VECTREX_MHZ / VECTREX_PDECAY;
    public static final int VECTOR_HASH         = 65521;

}
