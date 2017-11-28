/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.input;

import static de.malban.input.EventController.OFF;
import net.java.games.input.Component;

/**
 *
 * @author malban
 */
public class ControllerEvent 
{
    public static final int CONTROLLER_DISCONNECT = 0;
    public static final int CONTROLLER_POLL_OCCURED = 1;
    public static final int CONTROLLER_CHANGED = 2;
    
    public static final int CONTROLLER_BUTTON_CHANGED = 3;
    public static final int CONTROLLER_AXIS_CHANGED = 4;
    public static final int CONTROLLER_RELATIVE_CHANGED = 5;
    public static final int CONTROLLER_POV_CHANGED = 6;

    String[] names = {
        "CONTROLLER_DISCONNECT",
        "CONTROLLER_POLL_OCCURED",
        "CONTROLLER_CHANGED",
        "CONTROLLER_BUTTON_CHANGED",
        "CONTROLLER_AXIS_CHANGED",
        "CONTROLLER_RELATIVE_CHANGED",
        "CONTROLLER_POV_CHANGED"
    };
    
    public int type = CONTROLLER_POLL_OCCURED;
    public String componentId  = "";
    
    public Component component;
    public float lastValue = -11.2838822F;
    public boolean lastButtonState = false;
    public int lastAxisPercent = 50;
    public int lastPOV = OFF;
    public float lastRelative = 0F;

    public float currentValue = -21.2838822F;
    public boolean currentButtonState = false;
    public int currentAxisPercent = 50;
    public int currentPOV = OFF;
    public float currentRelative = 0F;
    public boolean isRelative = false;
    
    public int index = -1;
    
    public String toString()
    {
        return "ControllerEvent! "+names[type]+" "+componentId+" old: "+lastValue+", new: "+currentValue;
    }
}
