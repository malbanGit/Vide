/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx.devices;

import de.malban.input.ControllerEvent;
import static de.malban.input.ControllerEvent.CONTROLLER_AXIS_CHANGED;
import static de.malban.input.ControllerEvent.CONTROLLER_RELATIVE_CHANGED;
import de.malban.input.ControllerListern;
import de.malban.input.EventController;
import de.malban.input.SystemController;
import de.malban.vide.ControllerConfig;
import de.malban.vide.VideConfig;
import de.malban.vide.vecx.VecX;
import static de.malban.vide.vecx.VecXPanel.DEVICE_JINPUT_SPINNER;
import net.java.games.input.Controller;

/**
 *
 * @author malban
 */
public class JInputSpinnerDevice  extends AbstractDevice implements ControllerListern{
    
    public String usedInputID = "JInputSpinnerDevice";

    ControllerConfig cConfig=null;
    EventController eController = null;
    
    
    public static final int NONE = 0;
    public static final int RIGHT = 1;
    public static final int LEFT = 2;
    int moveDirection = NONE;
    double speedFactor = 0;
    int currentCount =0;
    
    int[] pinMoveLeft = {1, 3, 0, 2};
    int[] pinMoveRight = {2, 0, 3, 1};
    int out = 0;
    long lastCycles = 0;
    
    public int getDeviceID()
    {
        return DEVICE_JINPUT_SPINNER;
    }
    public String getDeviceName()
    {
        if (cConfig == null) return "n/a";
        return cConfig.name;
    }
    
    public JInputSpinnerDevice()
    {
    }
    

    @Override
    public String toString()
    {
        if (cConfig==null)
            return "JInputSpinnerDevice";
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
        currentCount = VideConfig.getConfig().minimumSpinnerChangeCycles;
        out = 0;
        
        eController.setActive(true);
    }
    
    @Override
    public void step()
    {
        if (joyport == null) return;
        VecX vectrex = joyport.vecx;
        long c = vectrex.getCycles();
        int dif = (int)(c-lastCycles);
        lastCycles = c;
        currentCount -= dif;
        if (currentCount<=0)
        {

            currentCount = (int)(VideConfig.getConfig().minimumSpinnerChangeCycles*speedFactor);
            if (moveDirection==NONE) ;//out = 0;
            if (moveDirection==RIGHT) out = pinMoveRight[out];
            if (moveDirection==LEFT) out = pinMoveLeft[out];
            if (joyportIsInInputMode)
            {
                joyport.setButton1(!((out&0x01)==0x01), true);
                joyport.setButton2(!((out&0x02)==0x02), true);
            }
        }
    }
    
    
    public static JInputSpinnerDevice getDevice(ControllerConfig c)
    {
        JInputSpinnerDevice device = new JInputSpinnerDevice();
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
        
        if (vectrexTarget.equals("3")) joyport.setButton3(!e.currentButtonState, true); 
        if (vectrexTarget.equals("4")) joyport.setButton4(!e.currentButtonState, true); 
        
        if (vectrexTarget.equals("horizontal"))  
        {
            if (e.type == CONTROLLER_AXIS_CHANGED)
            {
                int v = e.currentAxisPercent-50;
                int v2 = (int) Math.abs(v);
                if (v2 > 50>>1)
                {
                    speedFactor = 1;
                }
                else if (v2 > 50>>2)
                {
                    speedFactor = 2;
                }
                else if (v2 > 50>>3)
                {
                    speedFactor = 4;
                }
                else if (v2 > 50>>4)
                {
                    speedFactor = 8;
                }
                else if (v2 > 50>>5)
                {
                    speedFactor = 10;
                }
                
                if (v<0) 
                {
                    moveDirection=LEFT;
                }
                else if (v>0) 
                {
                    moveDirection=RIGHT;
                }
                else 
                {
                    moveDirection=NONE;
                    speedFactor = 1;
                }
            }
            
            else if (e.type == CONTROLLER_RELATIVE_CHANGED)
            {
                float v = e.currentRelative;
                int v2 = (int) Math.abs(v);
                if (v2 > cConfig.compareValue>>1)
                {
                    speedFactor = 1;
                }
                else if (v2 > cConfig.compareValue>>2)
                {
                    speedFactor = 2;
                }
                else if (v2 > cConfig.compareValue>>3)
                {
                    speedFactor = 4;
                }
                else if (v2 > cConfig.compareValue>>4)
                {
                    speedFactor = 8;
                }
                else if (v2 > cConfig.compareValue>>5)
                {
                    speedFactor = 10;
                }
                
                if (v<0) 
                {
                    moveDirection=LEFT;
                }
                else if (v>0) 
                {
                    moveDirection=RIGHT;
                }
                else 
                {
                    moveDirection=NONE;
                    speedFactor = 1;
                }
            }
            else if (e.type == ControllerEvent.CONTROLLER_BUTTON_CHANGED)
            {
                if (e.currentButtonState)
                {
                    speedFactor = 1;
                    moveDirection=RIGHT;
                }
                else 
                {
                    moveDirection=NONE;
                    speedFactor = 1;
                }
            }
            
//            joyport.setHorizontal((int)(e.currentAxisPercent*FACTOR)&0xff, true);
        }
        if (vectrexTarget.equals("vertical"))  
        {
            if (e.type == ControllerEvent.CONTROLLER_BUTTON_CHANGED)
            {
                if (e.currentButtonState)
                {
                    speedFactor = 1;
                    moveDirection=LEFT;
                }
                else 
                {
                    moveDirection=NONE;
                    speedFactor = 1;
                }
            }
        }       
    }
    static double FACTOR = 127.0/50.0;
    
}
