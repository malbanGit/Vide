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
public interface E8910Statics 
{

/* register id's */
    public static final int  AY_AFINE	= (0);
    public static final int  AY_ACOARSE	= (1);
    public static final int  AY_BFINE	= (2);
    public static final int  AY_BCOARSE	= (3);
    public static final int  AY_CFINE	= (4);
    public static final int  AY_CCOARSE	= (5);
    public static final int  AY_NOISEPER= (6);
    public static final int  AY_ENABLE	= (7);
    public static final int  AY_AVOL	= (8);
    public static final int  AY_BVOL	= (9);
    public static final int  AY_CVOL	= (10);
    public static final int  AY_EFINE	= (11);
    public static final int  AY_ECOARSE	= (12);
    public static final int  AY_ESHAPE	= (13);

    public static final int  AY_PORTA	= (14);
    public static final int  AY_PORTB	= (15);  
    


    public static final int  PSG_TYPE_AY = 1;
    public static final int  PSG_TYPE_YM = 2;
    
    public static final int  ALL_8910_CHANNELS = -1;

    /* Internal resistance at Volume level 7. */

    public static final int  AY8910_INTERNAL_RESISTANCE = (356);
    public static final int  YM2149_INTERNAL_RESISTANCE = (353);

    /*
     * The following is used by all drivers not reviewed yet.
     * This will like the old behaviour, output between
     * 0 and 7FFF
     */
    public static final int   AY8910_LEGACY_OUTPUT       = (0x01);

    /*
     * Specifing the next define will simulate the special
     * cross channel mixing if outputs are tied together.
     * The driver will only provide one stream in this case.
     */
    public static final int   AY8910_SINGLE_OUTPUT      = (0x02);

    /*
     * The following define is the default behaviour.
     * Output level 0 is 0V and 7ffff corresponds to 5V.
     * Use this to specify that a discrete mixing stage
     * follows.
     */
    public static final int   AY8910_DISCRETE_OUTPUT     = (0x04);

    /*
     * The following define causes the driver to output
     * resistor values. Intended to be used for
     * netlist interfacing.
     */

    public static final int   AY8910_RESISTOR_OUTPUT    =  (0x08);

    /*
     * This define specifies the initial state of YM2149
     * pin 26 (SEL pin). By default it is set to high,
     * compatible with AY8910.
     */
    /* TODO: make it controllable while it's running (used by any hw???) */
    public static final int   YM2149_PIN26_HIGH       =    (0x00); /* or N/C */
    public static final int   YM2149_PIN26_LOW        =    (0x10);
    public static final int   AY8910_NUM_CHANNELS = 3;

    

}

