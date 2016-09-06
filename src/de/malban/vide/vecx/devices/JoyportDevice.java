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
public interface JoyportDevice 
{
    public void setJoyport(VectrexJoyport joyport);
    public void step();
    public void deinit();
    public void updateInputDataFromDevice();        // ask the device kindly to update button states, since vectrex will read the states soon
    public void setInputMode(boolean i);            // if true, the device can output data to vectrex, the PSG port A is in input mode
    public boolean isActive();
    public int getDeviceID();
    public String getDeviceName();
}
