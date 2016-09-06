/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx.devices;

import de.malban.vide.vecx.VecX;
import static de.malban.vide.vecx.VecXPanel.DEVICE_NULL;

/**
 *
 * @author malban
 */
public class NullDevice extends AbstractDevice
{
    public int getDeviceID()
    {
        return DEVICE_NULL;
    }
    @Override
    public boolean isActive()
    {
        return false;
    }
    @Override
    public String toString()
    {
        return " ";
    }    
    public String getDeviceName()
    {
        return "null device";
    }
}
