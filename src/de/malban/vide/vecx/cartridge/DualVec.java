/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx.cartridge;

import java.io.Serializable;

/**
 * Dual vec protocoll
 * vec(1)
 * default pb6 (read from vectrex) after power up is: true
 * 
 * dualvec 1 waits till it is switched to false, for that time it displays "waiting"
 * 
 * after that it enters the main loop (never to return to waiting again)
 * 
 * (pb6 is per default in input mode)
 * the main loop:
 *  - send sequence:
 *  - delay, till pb6 reads: false
 *  - after a false is received, it switches pb6 to output mode
 *  - and sends a sequence of false true (each for about 65 cycles)
 *  - and returns than to pb6 false again
 *  - than the 4 buttons of joyport 0 are checked
 *  - and after 34 cycles a true (button pressed) or false (button not pressed)
 *  - the next button states are send after 30 cycles
 *  - the last "button" output is held untill the receive sequence is initiated
 *  -
 *  - "ACTIVE" string is printed
 *  - receive sequence:
 *  - pb6 is set to input
 *  - if received pb6 = true, put pb6 in output mode, set pb6 to false and start receive sequence again
 *  - if received pb6 = false, wait till pb6 is true (this checks the above false/true sequence 65 cycles part 1)
 *  - wait till pb6 = false (this checks the above false/true sequence 65 cycles part 2)
 *  - delay 36 cycles, and read pb6 and store the result in extern joystick 1 button variable
 *  - after 30 cycles read pb6 again and store the result in next extern joystick button variable
 *  - untill all buttons are done
 *  - 
 *  - than print "own" buttons
 *  - than print "external" buttons
 * 
 * 
 * Due to not exact "synchronization of the two vectrex emulations, there might be some
 * "glitches" (button presses that are not realy happening).
 * 
 * Some day I must add a true "hardsync" of two emulations
 * 
 * 
 * @author malban
 */
public class DualVec implements Serializable, CartridgeInternalInterface
{
    private static DualVec[] dualVec = null;
    int side = 0;
    int otherSide = 1;
    Cartridge cart = null;
    boolean lineOut = true; // only output value from our OWN vectrex
    
    // ensure only ONE of each kind is available
    public static DualVec getDualVec(int side, Cartridge c)
    {
        if (dualVec == null)
        {
            dualVec = new DualVec[2];
            dualVec[0] = new DualVec();
            dualVec[0].side = 0;
            dualVec[0].otherSide = 1;

            dualVec[1] = new DualVec();
            dualVec[1].side = 1;
            dualVec[1].otherSide = 0;
        }
        if (side <0) return null;
        if (side >1) return null;
        if (c != null) // clone must not set null!
            dualVec[side].setCartridge(c);
        return dualVec[side];
    }
    // there is no clone!
    public DualVec clone()
    {
        DualVec c = getDualVec(side, null);
        return c;
    }
    public void setCartridge(Cartridge c)
    {
        cart = c;
    }
    
    private DualVec()
    {
    }
    public void init()
    {
    }
    public void deinit()
    {
    }
    public void reset()
    {
    }
    public void linePB6Out(boolean b)
    {
    }
    public String toString()
    {
        if (side == 0)
            return "DualVec 1";
        return "DualVec 2";
    }
    
    public void step(long cycles)
    {
        syncStep();
    }
    static volatile boolean sync[] = new boolean [2];
    static volatile boolean syncDone[] = new boolean [2];
    public static boolean exitSync = false;
    public void syncStep()
    {
        if (dualVec == null) return;
        if (dualVec[otherSide] == null) return;
        if (dualVec[otherSide].cart == null) return;
        if (dualVec[otherSide].cart.vecx == null) return;
        if (dualVec[side] == null) return;
        if (dualVec[side].cart == null) return;
        if (dualVec[side].cart.vecx == null) return;

        sync[side] = true;
        syncDone[side] = false;

        
        try
        {
            while (!sync[otherSide])
            {
                if (dualVec == null) return;
                if (dualVec[otherSide] == null) return;
                if (dualVec[otherSide].cart == null) return;
                if (exitSync) return;
                if ((dualVec[otherSide].cart.vecx.isDebugging()) && (dualVec[side].cart.vecx.isDebugging()))  break;
            }

            synchronized (dualVec)
            {
                if (oldLine != lineOut)
                    dualVec[otherSide].cart.setPB6FromCartridge(lineOut);
                oldLine = lineOut;
            }
        
            syncDone[side] = true;
            while (!syncDone[otherSide])
            {
                if (dualVec == null) return;
                if (dualVec[otherSide] == null) return;
                if (dualVec[otherSide].cart == null) return;
                if (exitSync) return;
                if ((dualVec[otherSide].cart.vecx.isDebugging()) && (dualVec[side].cart.vecx.isDebugging()))  break;
            }
        }
        catch (Throwable e)
        {
            // there still can be null pointers, if a links removed while in the above loop
            // this can happen since synchronizing is sort of bad at the moment
            // and does not really consider removing devices on the fly
            // both vectrex emulators also run in different threads
            // I think the overhead of doing a REAL sync is just "to much" for the
            // seldom case that the link will be emulated...
            syncDone[side] = true;
            // e.printStackTrace();
        }
        sync[side] = false;        
        
    }
    boolean oldLine = true;
    // only set from our OWN vectrex
    public void linePB6In(boolean b)
    {
        lineOut = b;
    }
    public boolean usesPB6() {return true;}
    public boolean isActive() {return true;}
    public void lineIRQIn(boolean i)
    {
    }
}

