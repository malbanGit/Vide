/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.event;

import java.awt.AWTEvent;
import java.awt.event.KeyEvent;

/**
 *
 * @author malban
 */
public class MasterEvent {
    
    public static final int EVT_ERROR = -1;
    public static final int EVT_KEYBOARD = 0;
    
    public static final int KBD_STATE_ERROR = -1;
    public static final int KBD_STATE_PRESSED = 0;
    public static final int KBD_STATE_TYPED = 1;
    public static final int KBD_STATE_RELEASED = 2;
    
    
    public AWTEvent orgAWTEvent = null;
    public KeyEvent orgKeyEvent = null;

    public boolean eventHandled = false;
    
    public int type = EVT_ERROR;
    public int keyboardState=KBD_STATE_ERROR;
    public int keyCode =-1;
    
}
