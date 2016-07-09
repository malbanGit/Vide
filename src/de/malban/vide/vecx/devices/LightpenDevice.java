/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx.devices;

import de.malban.vide.vecx.VecX;

/**
 *
 * @author malban
 */
public class LightpenDevice implements JoyportDevice
{
    public static final int LIGHTPEN_OUT_OF_BOUNDS = -100000;

    VectrexJoyport joyport;

    public int lightpenX = LIGHTPEN_OUT_OF_BOUNDS; // must be set from "gui"
    public int lightpenY = LIGHTPEN_OUT_OF_BOUNDS;
    
    public LightpenDevice()
    {
    }
    
    public void setJoyport(VectrexJoyport j)
    {
        joyport = j;
    }
    
    public void step(VecX vectrex)    
    {
        int my = lightpenY;
        int mx = lightpenX;
        if (!((mx == LIGHTPEN_OUT_OF_BOUNDS) || (my == LIGHTPEN_OUT_OF_BOUNDS)))
        {
            if ((Math.abs(vectrex.getBeamPosX()-mx)<0x100) && ((Math.abs(vectrex.getBeamPosY()-my)<0x100)))
            {
//                via_ca1 = 1;
                joyport.setButton4(true, true);
            }
            else
            {
//                via_ca1 = 0;
                joyport.setButton4(false, true);
            }
        }
        else
        {
//          via_ca1 = 0;
            joyport.setButton4(false, true);
        }
        
    }
    
    public void deinit()
    {
        joyport.setButton4(false, true);
        joyport = null;
    }
    public void setCoordinates(int x, int y)
    {
        lightpenX = x;
        lightpenY = y;
        if ((x == LIGHTPEN_OUT_OF_BOUNDS) || (y == LIGHTPEN_OUT_OF_BOUNDS)) 
        {
            joyport.setButton4(false, true);
//            via_ca1 = 0;
        }
        
    }
//    public int getWriteDataToPort(int portAOrg)
//    {
//        return -1;
//    }
//    public void valueChangedFromPSG()
//    {
//        
//    }
    @Override
    public void setInputMode(boolean i)
    {
        
    }
    @Override
    public void updateInputDataFromDevice()
    {
    }
    @Override
    public void updateDeviceWithDataFromVectrex()
    {
    }
}
