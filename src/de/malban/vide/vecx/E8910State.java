/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx;

import java.io.Serializable;

/**
 *
 * @author malban
 */
public class E8910State implements Serializable, E8910Statics{
    
    public AY8910 PSG = new AY8910();
    public int portAOut = 0;
    public int portAIn = 0;
    public int[] snd_regs = new int[16];

    public static void deepCopy(E8910State from, E8910State to)
    {
        System.arraycopy(from.snd_regs, 0, to.snd_regs, 0, from.snd_regs.length);
        to.portAOut = from.portAOut;
        to.portAIn = from.portAIn;
        to.PSG.index =from.PSG.index;
        to.PSG.ready =from.PSG.ready;
        to.PSG.PeriodA =from.PSG.PeriodA;
        to.PSG.PeriodB =from.PSG.PeriodB;
        to.PSG.PeriodC =from.PSG.PeriodC;
        to.PSG.PeriodN =from.PSG.PeriodN;
        to.PSG.PeriodE =from.PSG.PeriodE;
        to.PSG.CountA =from.PSG.CountA;
        to.PSG.CountB =from.PSG.CountB;
        to.PSG.CountC =from.PSG.CountC;
        to.PSG.CountN =from.PSG.CountN;
        to.PSG.CountE =from.PSG.CountE;
        to.PSG.VolA =from.PSG.VolA;
        to.PSG.VolB =from.PSG.VolB;
        to.PSG.VolC =from.PSG.VolC;
        to.PSG.VolE =from.PSG.VolE;
        to.PSG.EnvelopeA =from.PSG.EnvelopeA;
        to.PSG.EnvelopeB =from.PSG.EnvelopeB;
        to.PSG.EnvelopeC =from.PSG.EnvelopeC;
        to.PSG.OutputA =from.PSG.OutputA;
        to.PSG.OutputB =from.PSG.OutputB;
        to.PSG.OutputC =from.PSG.OutputC;
        to.PSG.OutputN =from.PSG.OutputN;
        
        to.PSG.CountEnv =from.PSG.CountEnv;
        to.PSG.Hold =from.PSG.Hold;
        to.PSG.Alternate =from.PSG.Alternate;
        to.PSG.Attack =from.PSG.Attack;
        to.PSG.Continue =from.PSG.Continue;
        to.PSG.RNG =from.PSG.RNG;    
    }
    public boolean NOISE_ENABLEQ (int _chan)
    {
        return ((snd_regs[AY_ENABLE] >> (3 + _chan)) & 1)!=0;
    }
    public boolean TONE_ENABLEQ (int _chan)
    {
        return ((snd_regs[AY_ENABLE] >> (_chan)) & 1)!=0;
    }
    public int TONE_PERIOD (int _chan)
    {
        return snd_regs[(_chan) << 1] | ((snd_regs[((_chan) << 1) | 1] & 0x0f) << 8);
    }
    public int NOISE_PERIOD()
    {
        return snd_regs[AY_NOISEPER] & 0x1f;
    }
    public int TONE_VOLUME (int _chan)
    {
        return snd_regs[AY_AVOL + (_chan)] & 0x0f;
    }
    public int TONE_ENVELOPE (int _chan)
    {
        return (snd_regs[AY_AVOL + (_chan)] >> 4) & 0x01;
    }
    public int ENVELOPE_PERIOD()
    {
        return snd_regs[AY_EFINE] | (snd_regs[AY_ECOARSE]<<8);
    }
    public boolean NOISE_OUTPUT()
    {
        return (PSG.RNG & 1)!=0;
    }        
    
}
