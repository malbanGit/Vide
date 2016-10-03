/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx;

import static de.malban.vide.vecx.E8910Statics.MAX_OUTPUT;
import java.io.Serializable;

/**
 *
 * @author malban
 */
public class AY8910 implements Serializable
{
    public int index;
    public int ready;
    public int PeriodA=1,PeriodB=1,PeriodC=1,PeriodN=1,PeriodE=1;
    public int CountA=1,CountB=1,CountC=1,CountN=1,CountE; // count for sound/no sound in relation to above periods, counts get reseted to periods...
    public int VolA,VolB,VolC,VolE; // pointer to volume "voltages" lookup table
    public int EnvelopeA,EnvelopeB,EnvelopeC; // is envelope, a boolean realy with its boolean value stored in the correct bit position
    public int OutputA,OutputB,OutputC,OutputN;  // output "at all" also a boolean
    public int CountEnv; // count down for envelope changes, max 0xf since 16 shifts max
    public int Hold,Alternate,Attack,Continue;
    public int RNG;
    public static transient int[] VolTable = new int[16];

    static 
    {
    
        int i;
        double out;

        /* calculate the volume->voltage conversion table */
        /* The AY-3-8910 has 16 levels, in a logarithmic scale (3dB per STEP) */
        /* The YM2149 still has 16 levels for the tone generators, but 32 for */
        /* the envelope generator (1.5dB per STEP). */
        out = MAX_OUTPUT;
        for (i = 15;i > 0;i--)
        {
            VolTable[i] = (int) (out + 0.5);	/* round to nearest */
            out /= 1.188502227;	/* = 10 ^ (1.5/20) = 1.5dB */
            out /= 1.188502227;	/* = 10 ^ (1.5/20) = 1.5dB */
        }
        VolTable[0] = 0;
    }
        
    
}
