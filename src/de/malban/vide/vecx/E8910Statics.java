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
    public static final int  MAX_OUTPUT = 0x0fff;
    //#define MAX_OUTPUT 0x7f

    public static final int  STEP3 = 1;
//    public static final int  STEP2 = length;
    public static final int  STEP  = 2;
    

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
    public static final int  AY_PORTB	= (15)  ;  
    
}
