/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx.devices;

/**
 *
 * @author malban
 */
public abstract class AbstractDevice implements JoyportDevice
{
    public static boolean exitSync = false;
    protected volatile VectrexJoyport joyport;
    protected boolean inDeinit = false;
    
    @Override
    public void setJoyport(VectrexJoyport j)
    {
        if (joyport != null)
        {
            deinit();
        }
        if (j != null)
        {
            j.plugIn(null);
        }
        joyport = j;
    }
    @Override
    public void deinit()
    {
        if (inDeinit) return;
        inDeinit = true;
        if (joyport != null)
        {
            joyport.setButton1(true, true);
            joyport.setButton2(true, true);
            joyport.setButton3(true, true);
            joyport.setButton4(true, true);
            VectrexJoyport tmp = joyport;
            tmp.plugIn(null);
            joyport = null;
        }
        inDeinit = false;
    }
    @Override
    public boolean isActive()
    {
        return joyport != null;
    }
    
    @Override
    public void step()
    {
    }

    
    // if i== true
    // than input enabled
    // input mode enabled means
    // vecvoice can WRITE to the port
    // and vectrex (over PSG) can read port
    @Override
    public void setInputMode(boolean i)
    {
    }
    // ask the device kindly to update button states, since vectrex will read the states soon
    // sending line information to the emulator (Joy)
    // this is called befor a "read" is done (isButton()) from the emulator 
    // to get fresh information from the device
    @Override
    public void updateInputDataFromDevice()
    {
    }
    abstract public String toString();
}
