/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx.devices;

import de.malban.vide.vecx.VecX;
import static de.malban.vide.vecx.VecXPanel.DEVICE_LIGHTPEN;

/**
 *
 * @author malban
 */
public class LightpenDevice extends AbstractDevice
{
    public static final int LIGHTPEN_OUT_OF_BOUNDS = -100000;
    public int lightpenX = LIGHTPEN_OUT_OF_BOUNDS; 
    public int lightpenY = LIGHTPEN_OUT_OF_BOUNDS;
    
    public int getDeviceID()
    {
        return DEVICE_LIGHTPEN;
    }
    public String getDeviceName()
    {
        return "lightpen";
    }
    public LightpenDevice()
    {
    }
    
    @Override
    public void step()    
    {
        if (joyport == null) return;
        VecX vectrex = joyport.vecx;
        
        // it seems that just having the position is not enough
        // since checking for only the position
        // keeps ca1 "on" for to long
        // (remember each read or write of port A of via resets the interrupt flag)
        // and setting the interrupt flag (again) requires a going high -> low
        // so keeping ca1 "on" for to long does not allow enabling the interrupt flag again
        //
        // in order for ca1 to be "switched on and off" in accordance to interrupts generated
        // we also must check if BLANK is 0 or 1
        
//        double dx = vectrex.getBeamPosX()-lightpenX;
//        double dy = vectrex.getBeamPosY()-lightpenY;
        if ((Math.abs(vectrex.getBeamPosX()-lightpenX)<0x100) && ((Math.abs(vectrex.getBeamPosY()-lightpenY)<0x100)))
        {
//            System.out.println(""+dx+", "+dy);
            // we have the right position,
            // is the beam also switched on?
            // lightpen only reacts on light switched ON
            if (vectrex.sig_blank.intValue == 1)
            {
                // false "active"
                joyport.setButton4(false, true);
            }
            else
            {
                // true inactive"
                joyport.setButton4(true, true);
            }
        }
        else
        {
            // true inactive"
            joyport.setButton4(true, true);
        }
    }
    
    
    public void setCoordinates(int x, int y)
    {
        lightpenX = x;
        lightpenY = y;
    }
    public String toString()
    {
        return "Lightpen";
    }
}
