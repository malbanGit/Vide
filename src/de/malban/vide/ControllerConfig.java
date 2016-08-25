/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

/**
 *
 * @author malban
 */
public class ControllerConfig  implements Serializable
{
    public static final int CONTROLLER_NONE = 0;
    public static final int CONTROLLER_JOYSTICK = 1;
    public static final int CONTROLLER_SPINNER = 2;
    public static final int CONTROLLER_PADDLE = 3;

    public static final String[] controllerNames =
    {
        "none",
        "Joystick",
        "Spinner",
//        "Paddle",
    };

    // vectrex device id <->controller eventID 
    public HashMap<String, String> inputMapping = new HashMap<String, String>();
    public HashMap<String, String> eventMapping = new HashMap<String, String>();
    public int vectrexType = CONTROLLER_NONE;
    public String JInputId = "";
    public boolean isWorking = false; // is set by init
    public String name = "";
    public int compareValue = 0;
    
    public ControllerConfig clone()
    {
        ControllerConfig clone = new ControllerConfig();
        clone .vectrexType = vectrexType;
        clone.JInputId = JInputId;
        clone.name = name;
        clone.isWorking = isWorking;
        clone.compareValue = compareValue;

        clone.inputMapping = new HashMap<String, String>();
        Set entries = inputMapping.entrySet();
        Iterator it = entries.iterator();
        while (it.hasNext())
        {
            Map.Entry entry = (Map.Entry) it.next();
            clone.inputMapping.put(entry.getKey().toString(), entry.getValue().toString());
        }
        
        clone.eventMapping = new HashMap<String, String>();
        entries = eventMapping.entrySet();
        it = entries.iterator();
        while (it.hasNext())
        {
            Map.Entry entry = (Map.Entry) it.next();
            clone.eventMapping.put(entry.getKey().toString(), entry.getValue().toString());
        }

        return clone;
    }
    public void initEventMapping()
    {
        eventMapping = new HashMap<String, String>();
        Set entries = inputMapping.entrySet();
        Iterator it = entries.iterator();
        while (it.hasNext())
        {
            Map.Entry entry = (Map.Entry) it.next();
            eventMapping.put(entry.getValue().toString(), entry.getKey().toString());
        }
    }
    public String toString()
    {
        return controllerNames[vectrexType] +"-" +name;
    }
}