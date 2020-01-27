/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx.devices;

import de.malban.vide.vecx.VecX;
import static de.malban.vide.vecx.VecXPanel.DEVICE_LINKV2_L;
import java.io.Serializable;

/**
 *
 * @author malban
 */
public class VecLinkV2Device extends AbstractDevice  implements Serializable
{
    public int getDeviceID()
    {
        return DEVICE_LINKV2_L;
    }
    private static VecLinkV2Device[] vecLink = null;
    int side = 0;
    int otherSide = 1;
    
    // ensure only ONE cable is available
    public static VecLinkV2Device getVecLinkV2(int side)
    {
        if (vecLink == null)
        {
            vecLink = new VecLinkV2Device[2];
            vecLink[0] = new VecLinkV2Device();
            vecLink[0].side = 0;
            vecLink[0].otherSide = 1;

            vecLink[1] = new VecLinkV2Device();
            vecLink[1].side = 1;
            vecLink[1].otherSide = 0;
        }
        if (side <0) return null;
        if (side >1) return null;
        return vecLink[side];
    }


    
    private VecLinkV2Device()
    {
    }
    public String toString()
    {
        if (side == 0)
            return "VecLinkV2 left";
        return "VecLinkV2 right";
    }
    public String getDeviceName()
    {
        if (side == 0)
            return "VecLinkV2 left";
        return "VecLinkV2 right";
    }
    
    static volatile boolean sync[] = new boolean [2];
    static volatile boolean syncDone[] = new boolean [2];
    
    boolean firstTime = true;
    @Override
    public void step()
    {
//        if (vecLink[side].joyport.vecx.config.syncCables) // when debugging, if non synced debug, than link is broken immediately
            syncStep();
//        else
//            noSyncStep();
    }
    public void syncStep()
    {
        try
        {
            if (joyport == null) 
                return;
            if (vecLink[otherSide] == null)
                return;
            if (vecLink[otherSide].joyport == null)
                return;
            if (firstTime)
            {
                firstTime = false;
                vecLink[otherSide].joyport.vecx.cyclesRunning = 0;
                vecLink[side].joyport.vecx.cyclesRunning = 0;
            }

            //System.out.println(""+side+": "+vecLink[side].joyport.vecx.cyclesRunning);

            sync[side] = true;
            syncDone[side] = false;
            while (!sync[otherSide])
            {
                if (vecLink[side].joyport == null) return;
                if (vecLink[otherSide].joyport == null) return;
                if (!(vecLink[side].joyport.device instanceof VecLinkV2Device)) return;
                if (!(vecLink[otherSide].joyport.device instanceof VecLinkV2Device))
                    return;
                if (exitSync) 
                    return;
                if ((vecLink[otherSide].joyport.vecx.isDebugging()) && (vecLink[side].joyport.vecx.isDebugging())) 
                    break;
                if (!vecLink[side].joyport.vecx.config.syncCables) break;
            }

            synchronized (vecLink)
            {
                joyport.setButton1(vecLink[otherSide].joyport.isButton1(true), true);
                joyport.setButton2(vecLink[otherSide].joyport.isButton2(true), true); 
                joyport.setButton3(vecLink[otherSide].joyport.isButton3(true), true); 
            }
            syncDone[side] = true;
            while (!syncDone[otherSide])
            {
                if (vecLink[side].joyport == null) return;
                if (vecLink[otherSide].joyport == null) return;
                if (!(vecLink[side].joyport.device instanceof VecLinkV2Device)) return;
                if (!(vecLink[otherSide].joyport.device instanceof VecLinkV2Device)) return;
                if (exitSync) 
                    return;
                if ((vecLink[otherSide].joyport.vecx.isDebugging()) && (vecLink[side].joyport.vecx.isDebugging()))  
                    break;
                if (!vecLink[side].joyport.vecx.config.syncCables) break;
            }
        }
        catch (Throwable e)
        {
            // there still can be null pointers, if a links removed while in the above loop
            // this can happen since synchronizing is sort of bad at the moment
            // and does not really consider removing devices on the fly
            // both vectrex emulators also run in different threads
            // I think the overhead of doing a REAL sync is just "to much" for the
            // seldom case that the link cable will be emulated...
            syncDone[side] = true;
        }
        sync[side] = false;
    }    
    public void noSyncStep()
    {
        try
        {
            if (joyport == null) 
                return;
            if (vecLink[otherSide] == null)
                return;
            if (vecLink[otherSide].joyport == null)
                return;
            if (firstTime)
            {
                firstTime = false;
                vecLink[otherSide].joyport.vecx.cyclesRunning = 0;
                vecLink[side].joyport.vecx.cyclesRunning = 0;
            }
            joyport.setButton1(vecLink[otherSide].joyport.isButton1(true), true);
            joyport.setButton2(vecLink[otherSide].joyport.isButton2(true), true); 
            joyport.setButton3(vecLink[otherSide].joyport.isButton3(true), true); 
        }
        catch (Throwable e)
        {
            // there still can be null pointers, if a links removed while in the above loop
            // this can happen since synchronizing is sort of bad at the moment
            // and does not really consider removing devices on the fly
            // both vectrex emulators also run in different threads
            // I think the overhead of doing a REAL sync is just "to much" for the
            // seldom case that the link cable will be emulated...
        }
            
    }    
  }