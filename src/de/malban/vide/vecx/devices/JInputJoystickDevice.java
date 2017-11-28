/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx.devices;

import de.malban.input.ControllerEvent;
import de.malban.input.ControllerListern;
import de.malban.input.EventController;
import de.malban.input.SystemController;
import de.malban.vide.ControllerConfig;
import static de.malban.vide.vecx.VecXPanel.DEVICE_JINPUT_JOYSTICK;
import static de.malban.vide.vecx.VecXStatics.JOYSTICK_CENTER;
import net.java.games.input.Controller;

/**
 *
 * @author malban
 */
public class JInputJoystickDevice  extends AbstractDevice implements ControllerListern{
    
    public String usedInputID = "JInputJoystickDevice";

    ControllerConfig cConfig=null;
    EventController eController = null;
    
    public int getDeviceID()
    {
        return DEVICE_JINPUT_JOYSTICK;
    }
    
    public JInputJoystickDevice()
    {
    }
    public String getDeviceName()
    {
        if (cConfig == null) return "n/a";
        return cConfig.name;
    }
    

    @Override
    public String toString()
    {
        if (cConfig==null)
            return "JInputJoystickDevice";
        return cConfig.toString();
    }
    
    
    // deinit
    @Override
    public void deinit()
    {
        super.deinit();
        if (eController!=null)
        {
            eController.setActive(false);
            eController = null;
        }
    }
    // init()
    public void setJoyport(VectrexJoyport j)
    {
        if (eController!=null)
        {
            eController.setActive(false);
            eController = null;
        }
        super.setJoyport(j);
        Controller controller = SystemController.getController(cConfig.JInputId);
        if (controller == null)
        {
            deinit();
        }
        eController = new EventController(controller);
        eController.addEventListerner(this);
        
        eController.setActive(true);
    }
    
    public static JInputJoystickDevice getDevice(ControllerConfig c)
    {
        JInputJoystickDevice device = new JInputJoystickDevice();
        device.cConfig = c;
        c.initEventMapping();
        return device;
    }
    @Override
    public void controllerEvent(ControllerEvent e)
    {
        String evenId = e.componentId;
        String vectrexTarget = cConfig.eventMapping.get(evenId);
        if (vectrexTarget==null) return; // not for me!
        
        if (vectrexTarget.equals("1")) joyport.setButton1(!e.currentButtonState, true); 
        if (vectrexTarget.equals("2")) joyport.setButton2(!e.currentButtonState, true); 
        if (vectrexTarget.equals("3")) joyport.setButton3(!e.currentButtonState, true); 
        if (vectrexTarget.equals("4")) joyport.setButton4(!e.currentButtonState, true); 
        
        if (vectrexTarget.equals("left"))  joyport.setHorizontal((e.currentButtonState)?0x00:JOYSTICK_CENTER, true);
        if (vectrexTarget.equals("right"))  joyport.setHorizontal((e.currentButtonState)?0xff:JOYSTICK_CENTER, true);
        if (vectrexTarget.equals("down"))  joyport.setVertical((e.currentButtonState)?0x00:JOYSTICK_CENTER, true);
        if (vectrexTarget.equals("up"))  joyport.setVertical((e.currentButtonState)?0xff:JOYSTICK_CENTER, true);

        if (vectrexTarget.equals("vertical"))  
        {
            if (e.isRelative)
            {
                int val = -(int)e.currentRelative;
                if (val<0)
                {
                    if (val<-128) val = -127;
                }
                if (val>0)
                {
                    if (val>127) val = 128;
                }
                joyport.setVertical((int)((JOYSTICK_CENTER+val)&0xff), true);
            }
            else
            {
                joyport.setVertical((int)(e.currentAxisPercent*FACTOR)&0xff, true);
            }
        }
        if (vectrexTarget.equals("horizontal"))  
        {
            if (e.isRelative)
            {
                int val = (int)e.currentRelative;
                if (val<0)
                {
                    if (val<-128) val = -127;
                }
                if (val>0)
                {
                    if (val>127) val = 128;
                }
                joyport.setHorizontal((int)((JOYSTICK_CENTER+val)&0xff), true);
            }
            else
            {
                joyport.setHorizontal((int)(e.currentAxisPercent*FACTOR)&0xff, true);
            }
            
        }
        
    }
    static double FACTOR = 127.0/50.0;
    
}
