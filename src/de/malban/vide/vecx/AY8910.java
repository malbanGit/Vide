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
public class AY8910 implements Serializable
{
    public int index;
    public int ready;
    public int PeriodA,PeriodB,PeriodC,PeriodN,PeriodE;
    public int CountA,CountB,CountC,CountN,CountE;
    public int VolA,VolB,VolC,VolE;
    public int EnvelopeA,EnvelopeB,EnvelopeC;
    public int OutputA,OutputB,OutputC,OutputN;
    public int CountEnv;
    public int Hold,Alternate,Attack,Holding;
    public int RNG;
    public int[] VolTable = new int[32];

}
