/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.event;

import java.awt.AWTEvent;
import java.awt.Toolkit;
import java.awt.event.AWTEventListener;
import java.awt.event.KeyEvent;
import java.util.Vector;

/**
 *
 * @author malban
 */
public class EventSupport {
    
    private static EventSupport keyboard = null;
    private Vector<de.malban.event.MasterEventListener> mKeyEventListener= new Vector<de.malban.event.MasterEventListener>();
    public void addKeyEventListener(de.malban.event.MasterEventListener listener)
    {
        removeKeyEventListener(listener);
        mKeyEventListener.addElement(listener);
    }

    public void removeKeyEventListener(de.malban.event.MasterEventListener listener)
    {
        mKeyEventListener.removeElement(listener);
    }
    public void fireKeyEvent(MasterEvent event)
    {
        for (int i=0; i<mKeyEventListener.size(); i++)
        {
            mKeyEventListener.elementAt(i).eventOccured(event);
        }
    }
    
    public static EventSupport getEventSupport()
    {
        if (keyboard == null)
            keyboard = new EventSupport();            
        return keyboard;
    }
    
    private EventSupport()
    {
        Toolkit.getDefaultToolkit().addAWTEventListener(new AWTEventListener()
            {
                public void eventDispatched(AWTEvent e)
                {
                    keyEventDispatched(e);
                }
            },  AWTEvent.KEY_EVENT_MASK);
    }

    public void keyEventDispatched(AWTEvent e) 
    {
     //   System.out.println(e.paramString());
       // CSA if (mKeyEventListener.isEmpty()) return;
        
        if (!(e instanceof KeyEvent))
        {
       //     System.out.println("key");
            return;
        }
        KeyEvent ke = (KeyEvent) e;
        
        MasterEvent event = new MasterEvent();
        int id = ke.getID();
        if (id == ke.KEY_PRESSED) event.keyboardState = MasterEvent.KBD_STATE_PRESSED;
        if (id == ke.KEY_RELEASED) event.keyboardState = MasterEvent.KBD_STATE_RELEASED;
        if (id == ke.KEY_TYPED) event.keyboardState = MasterEvent.KBD_STATE_TYPED;
        

        event.orgAWTEvent = e;
        event.orgAWTEvent = ke;
        event.type = MasterEvent.EVT_KEYBOARD;
        event.keyCode = ke.getKeyCode();
        fireKeyEvent(event);
    }
}
