/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx.devices;

import de.malban.vide.vecx.Breakpoint;
import de.malban.vide.vecx.VecX;
import de.malban.vide.vecx.VecXPanel;
import de.malban.vide.vecx.devices.JoyportDevice;

/**
 *
 * @author malban
 */
public class VectrexJoyport 
{
    
    int port = 0;
    
    private boolean outputFromVectrexButton[] = new boolean[4];
    private boolean outputFromDeviceButton[] = new boolean[4];
    private int horizontal = 0x80; // left = 0, right = 0xff
    private int vertical = 0x80; // down = 0, up = 0xff

    // if input == true,
    // than values of states are set FROM device
    // if input == false
    // than values are set FROM vectrex
    boolean inputMode = false;
    boolean outputMode = !inputMode;
    
    
    VecX vecx = null;
    volatile JoyportDevice device = null;
    public VectrexJoyport(int p, VecX v)
    {
        port = p;
        vecx = v;
        reset();
    }
    public void deinit()
    {
        if (device != null) device.deinit();
        device = null;
    }
    public JoyportDevice getDevice()
    {
        return device;
    }
    public void reset()
    {
        // default values for starters
        outputFromVectrexButton[0] = true;
        outputFromVectrexButton[1] = true;
        outputFromVectrexButton[2] = true;
        outputFromVectrexButton[3] = true;
        outputFromDeviceButton[0] = true;
        outputFromDeviceButton[1] = true;
        outputFromDeviceButton[2] = true;
        outputFromDeviceButton[3] = true;
        horizontal = 0x80; // left = 0, right = 0xff
        vertical = 0x80; // down = 0, up = 0xff
    }
    
    public void plugIn(JoyportDevice d)
    {
        reset();
        if (device != null) device.deinit();
        device = null;
        if (d == null)
        {
            if (vecx != null)
            {
                if (vecx.displayer != null)
                {
                    vecx.displayer.setJoyportDevice(port, null);
                }
            }
            return; // unplug
        }
        // if d is a static, than it mus unplug itself too
        d.deinit();
        d.setJoyport(this);
        device = d;
        setInputMode(inputMode);
    }
    
    public void step()
    {
        if (device == null) return;
        device.step();
//        if (inputMode) // veclink1 seems to receive CA1 even in output mode
// seems the mode does not matter
// since the hardware is directly connected to VIA not "over" psg
        {
        if (device != null) device.updateInputDataFromDevice();
            if (port == 1)
            {
                // via reacts on == 0 
                if (outputFromDeviceButton[3])
                    vecx.via_ca1 = 1;
                else
                    vecx.via_ca1 = 0;
     //           System.out.printl
            }
            if (port == 0)
            {
                vecx.setFIRQ(!outputFromDeviceButton[3]);
            }
        }
        if (vecx.config.breakpointsActive) checkPortBreakpoint();
    }
    public void checkPortBreakpoint()
    {
        synchronized (vecx.breakpoints[Breakpoint.BP_TARGET_PORT])
        {
            for (Breakpoint bp: vecx.breakpoints[Breakpoint.BP_TARGET_PORT])
            {
                if ((bp.type & Breakpoint.BP_BITCOMPARE) == Breakpoint.BP_BITCOMPARE)
                {
                    if ((bp.type & Breakpoint.BP_MULTI) == Breakpoint.BP_MULTI)
                    {
                        int bit = bp.getTargetAddress();
                        boolean compareTo = bp.getCompareValue()==1;
                        if (port==1) bit -=4;
                        if (bit <0 ) continue;
                        if (bit >3 ) continue;

                            
                            boolean valueBit = false;
                        if ((bp.targetSubType & Breakpoint.BP_SUBTARGET_PORT_IN) == Breakpoint.BP_SUBTARGET_PORT_IN)
                           valueBit = outputFromDeviceButton[bit];
                        else if ((bp.targetSubType & Breakpoint.BP_SUBTARGET_PORT_OUT) == Breakpoint.BP_SUBTARGET_PORT_OUT)
                           valueBit = outputFromVectrexButton[bit];

                        
                        if (valueBit == compareTo)
                        {
                            vecx.activeBreakpoint.add(bp);
                            if (vecx.breakpointExit<bp.exitType) vecx.breakpointExit=bp.exitType;
                        }
                    }
                }
            }
        }             
    }    
    
    // if b== true
    // than input enabled
    // input mode enabled means
    // device can WRITE to the port
    // and vectrex (over PSG) can read port
    public void setInputMode(boolean b)
    {
        inputMode = b;
        outputMode = !inputMode;
        if (device != null) device.setInputMode(b);
        
    }
    public boolean isInpuMode()
    {
        return inputMode;
    }
    
    // read only variant for analog display windows, doesnt change vars
    public boolean isButtonInRO(int no)
    {
        return outputFromDeviceButton[no];  
    }
    // read only variant for analog display windows, doesnt change vars
    public boolean isButtonOutRO(int no)
    {
        return outputFromVectrexButton[no];  
    }

    private boolean isButton(int no, boolean fromDevice)
    {
        boolean fromVectrex = !fromDevice;
        if (device != null) device.updateInputDataFromDevice();

        if ((fromDevice)  && (inputMode)) 
        {
            // att!
//            return outputFromVectrexButton[no];
            return true; // guessed
        }  
        if ((fromVectrex) && (outputMode)) 
        {
            // att!
            // berzerk arena needs input in output???
            return outputFromDeviceButton[no];  
//            return true; // verified
        } 
        
        if ((fromDevice)  && (outputMode)) 
        {
            return outputFromVectrexButton[no];
        }  

        if ((fromVectrex) && (inputMode)) 
        {
            return outputFromDeviceButton[no];  
        }

        System.out.println("isButton is fucked");
        // should never come here
        return true;        
    }
    private void setButton(int no, boolean button, boolean fromDevice)
    {
        boolean fromVectrex = !fromDevice;
        // straight forward
        // sorting out of allowed, not allowed data is
        // done upon read of "isButton"
        // (although - it doesn't make any sense there either)
        if (fromDevice) 
        {
            outputFromDeviceButton[no] = button;
        }
        if (fromVectrex) 
        {
            outputFromVectrexButton[no] = button;
        }
    }
    
    
    
    
    /**
     * @return the button1
     */
    public boolean isButton1(boolean fromDevice) {
        return isButton(0, fromDevice);
    }

    /**
     * @param button1 the button1 to set
     */
    public void setButton1(boolean button1, boolean fromDevice) {
        setButton(0, button1, fromDevice);
    }

    /**
     * @return the button2
     */
    public boolean isButton2(boolean fromDevice) {
        return isButton(1, fromDevice);
    }

    /**
     * @param button2 the button2 to set
     */
    public void setButton2(boolean button2, boolean fromDevice) {
        setButton(1, button2, fromDevice);
    }

    /**
     * @return the button3
     */
    public boolean isButton3(boolean fromDevice) {
        return isButton(2, fromDevice);
    }

    /**
     * @param button3 the button3 to set
     */
    public void setButton3(boolean button3, boolean fromDevice) {
        setButton(2, button3, fromDevice);
    }

    /**
     * @return the button4
     */
    public boolean isButton4(boolean fromDevice) {
        return isButton(3, fromDevice);
    }

    /**
     * @param button4 the button4 to set
     */
    public void setButton4(boolean button4, boolean fromDevice) {
        setButton(3, button4, fromDevice);
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
