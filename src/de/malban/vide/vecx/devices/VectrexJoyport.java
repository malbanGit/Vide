/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx.devices;

import de.malban.vide.vecx.VecX;
import de.malban.vide.vecx.devices.JoyportDevice;
import java.util.Vector;

/**
 *
 * @author malban
 */
public class VectrexJoyport 
{
    int port = 0;
    private boolean button1 = true;
    private boolean button2 = true;
    private boolean button3 = true;
    private boolean button4 = true;
    private int horizontal = 0x80; // left = 0, right = 0xff
    private int vertical = 0x80; // down = 0, up = 0xff

    // if input == true,
    // than values of states are set FROM device
    // if input == false
    // than values are set FROM vectrex
    boolean inputMode = false;
    
    
    VecX vecx = null;
    JoyportDevice device = null;
    public VectrexJoyport(int p, VecX v)
    {
        port = p;
        vecx = v;
    }
    public void deinit()
    {
        if (device != null) device.deinit();
        device = null;
    }
    public void reset()
    {
        // default values for starters
        button1 = true;
        button2 = true;
        button3 = true;
        button4 = true;
        horizontal = 0x80; // left = 0, right = 0xff
        vertical = 0x80; // down = 0, up = 0xff
    }
    
    public void plugIn(JoyportDevice d)
    {
        reset();
        if (device != null) device.deinit();
        device = null;
        if (d == null) return; // unplug
        device = d;
        device.setJoyport(this);
        setInputMode(inputMode);
    }
    
    public void step()
    {
        if (device == null) return;
        device.step(vecx);
        if (inputMode)
        {
            if (port == 1)
            {
                // via reacts on == 0 or != 0
                if (button4)
                    vecx.via_ca1 = 1;
                else
                    vecx.via_ca1 = 0;
            }
            if (port == 0)
            {
                // via reacts on == 0 or != 0
                vecx.setFIRQ(button4);
            }
        }
    }
    
    public void setInputMode(boolean b)
    {
        inputMode = b;
        if (device == null) return;
        device.setInputMode(b);
    }
    
    /**
     * @return the button1
     */
    public boolean isButton1(boolean fromDevice) {
        if (device != null) device.updateInputDataFromDevice();
        if (fromDevice) if (inputMode) return true;
        if (!fromDevice) if (!inputMode) return true;
        return button1;
    }

    /**
     * @param button1 the button1 to set
     */
    public void setButton1(boolean button1, boolean fromDevice) {
        if (inputMode)  if (fromDevice) this.button1 = button1;
        if (!inputMode)  if (!fromDevice) this.button1 = button1;
        if (!inputMode) if (device != null) device.updateDeviceWithDataFromVectrex();
    }

    /**
     * @return the button2
     */
    public boolean isButton2(boolean fromDevice) {
        if (device != null) device.updateInputDataFromDevice();
        if (fromDevice) if (inputMode) return true;
        if (!fromDevice) if (!inputMode) return true;
        return button2;
    }

    /**
     * @param button2 the button2 to set
     */
    public void setButton2(boolean button2, boolean fromDevice) {
        if (inputMode)  if (fromDevice) this.button2 = button2;
        if (!inputMode)  if (!fromDevice) this.button2 = button2;
        if (!inputMode) if (device != null) device.updateDeviceWithDataFromVectrex();
    }

    /**
     * @return the button3
     */
    public boolean isButton3(boolean fromDevice) {
        if (device != null) device.updateInputDataFromDevice();
        if (fromDevice) if (inputMode) return true;
        if (!fromDevice) if (!inputMode) return true;
        return button3;
    }

    /**
     * @param button3 the button3 to set
     */
    public void setButton3(boolean button3, boolean fromDevice) {
        if (inputMode)  if (fromDevice) this.button3 = button3;
        if (!inputMode)  if (!fromDevice) this.button3 = button3;
        if (!inputMode) if (device != null) device.updateDeviceWithDataFromVectrex();
    }

    /**
     * @return the button4
     */
    public boolean isButton4(boolean fromDevice) {
        if (device != null) device.updateInputDataFromDevice();
        if (fromDevice) if (inputMode) return true;
        if (!fromDevice) if (!inputMode) return true;
        return button4;
    }

    /**
     * @param button4 the button4 to set
     */
    public void setButton4(boolean button4, boolean fromDevice) {
        if (inputMode)  if (fromDevice) this.button4 = button4;
        if (!inputMode)  if (!fromDevice) this.button4 = button4;
        if (!inputMode) if (device != null) device.updateDeviceWithDataFromVectrex();
    }

    /**
     * @return the horizontal
     */
    public int getHorizontal() {
        if (device != null) device.updateInputDataFromDevice();
        return horizontal;
    }

    /**
     * @param horizontal the horizontal to set
     */
    public void setHorizontal(int horizontal, boolean fromDevice) {
        this.horizontal = horizontal;
    }

    /**
     * @return the vertical
     */
    public int getVertical() {
        if (device != null) device.updateInputDataFromDevice();
        return vertical;
    }

    /**
     * @param vertical the vertical to set
     */
    public void setVertical(int vertical, boolean fromDevice) {
        this.vertical = vertical;
    }
    
}
