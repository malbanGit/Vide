/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.input;

import de.malban.config.Configuration;
import de.malban.gui.TimingTriggerer;
import de.malban.gui.TriggerCallback;
import de.malban.gui.panels.LogPanel;
import static de.malban.input.ControllerEvent.CONTROLLER_DISCONNECT;
import java.util.ArrayList;
import net.java.games.input.Component;
import net.java.games.input.Controller;

/**
 *
 * @author malban
 */
public class EventController 
{
    LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
    public static int POLL_RESOLUTION = 50; // each 50 milliseconds -> 20 timres per second
    private static int pollResultion = POLL_RESOLUTION;
    
    static class ComponentWithHistory 
    {
        public Component component;
        public float lastValue = -11.2838822F;
        public boolean lastButtonState = false;
        public int lastAxisPercent = 50;
        public int lastPOV = OFF;
        public float lastRelative = 0F;
        ComponentWithHistory(Component c)
        {
            component = c;
        }
    }
    boolean isRemoved = false;
    public void setRemoved(boolean b)
    {
        isRemoved = b;
    }
    private Controller controller;
    boolean isActive = false;
    private boolean isAvailable = true;
    
    private ArrayList<ControllerListern> mListener= new ArrayList<ControllerListern>();

    static TimingTriggerer timer;
    public EventController(Controller c)
    {
        timer = TimingTriggerer.getTimer();
        setController(c);
    }
    /**
     * @return the controller
     */
    public Controller getController() {
        return controller;
    }

    /**
     * @param controller the controller to set
     */
    public void setController(Controller controller) {
        this.controller = controller;
        init();
    }

    /**
     * @return the isAvailable
     */
    public boolean isIsAvailable() {
        return isAvailable;
    }

    /**
     * @param isAvailable the isAvailable to set
     */
    public void setIsAvailable(boolean isAvailable) {
        this.isAvailable = isAvailable;
    }
    /**
     * @return the pollResultion
     */
    public static int getPollResultion() {
        return pollResultion;
    }

    /**
     * @param pollResultion the pollResultion to set
     */
    public static void setPollResultion(int pr) {
        pollResultion = pr;
    }
    
    public void addEventListerner(ControllerListern listener)
    {
        mListener.remove(listener);
        mListener.add(listener);
    }

    public void removeEventListerner(ControllerListern listener)
    {
        mListener.remove(listener);
    }
    public void clearEventListerner()
    {
        mListener.clear();
    }
    public void fireControllerChanged(ControllerEvent event)
    {
        for (int i=0; i<mListener.size(); i++)
        {
            mListener.get(i).controllerEvent(event);
        }
        // log.addLog(event+" fired", VERBOSE);
    }
    
    TriggerCallback triggerCallback = new TriggerCallback()
    {
        public void doIt(int state, Object o)
        {
            checkStateChange();
            if (!isRemoved)
                timer.addTrigger(triggerCallback, pollResultion, 0, null);
        }
    };
    
    public void setActive(boolean b)
    {
        if (isActive == b) return;
        if (b)
        {
            // switch to active
            timer.setResolution(pollResultion); // 30 milliseconds resultion - > about 30 times per second
            timer.addTrigger(triggerCallback, pollResultion, 0, null);
        }
        else
        {
            // switch to inactive
            timer.removeTrigger(triggerCallback);
        }
            
        isActive = b;
    }
    
    // determine if controller changed state
    // if so trigger an event
    private void checkStateChange()
    {
        if (controller==null) 
        {
            ControllerEvent event = new ControllerEvent();
            isAvailable = false;
            setActive(false);
            event.type = CONTROLLER_DISCONNECT;
            fireControllerChanged(event);
            return;
        }
//            return;
        if( !controller.poll() )
        {
            ControllerEvent event = new ControllerEvent();
            isAvailable = false;
            setActive(false);
            event.type = CONTROLLER_DISCONNECT;
            fireControllerChanged(event);
            return;
        }

        // trigger changed buttons
        for (int i=0; i< getButtonCount(); i++)
        {
            boolean last = mButtons.get(i).lastButtonState;
            float lastValue = mButtons.get(i).lastValue;
            if (last != getButtonState(i))
            {
                ControllerEvent event = new ControllerEvent();
                event.component = mButtons.get(i).component;
                event.type = ControllerEvent.CONTROLLER_BUTTON_CHANGED;
                event.componentId = getButtonId(i);
                event.lastValue = lastValue;
                event.lastButtonState = last;
                event.currentButtonState = mButtons.get(i).lastButtonState;
                event.currentValue = mButtons.get(i).lastValue;
                event.index = i;
                fireControllerChanged(event);
            }
        }

        // trigger changed Axis
        for (int i=0; i< getAxisCount(); i++)
        {
            int last = mAxis.get(i).lastAxisPercent;
            float lastValue = mAxis.get(i).lastValue;
            if (last != getAxisPercent(i))
            {
                ControllerEvent event = new ControllerEvent();
                event.component = mAxis.get(i).component;
                event.type = ControllerEvent.CONTROLLER_AXIS_CHANGED;
                event.componentId = getAxisId(i);
                event.lastValue = lastValue;
                event.lastAxisPercent = last;
                event.currentAxisPercent = mAxis.get(i).lastAxisPercent;
                event.currentValue = mAxis.get(i).lastValue;
                event.index = i;
                fireControllerChanged(event);
            }
        }
        // trigger changed POV
        for (int i=0; i< getPOVCount(); i++)
        {
            int last = mPovs.get(i).lastPOV;
            float lastValue = mPovs.get(i).lastValue;
            if (last != getPOVPosition(i))
            {
                ControllerEvent event = new ControllerEvent();
                event.component = mPovs.get(i).component;
                event.type = ControllerEvent.CONTROLLER_POV_CHANGED;
                event.componentId = getPOVId(i);
                event.lastValue = lastValue;
                event.lastPOV = last;
                event.currentPOV = mPovs.get(i).lastPOV;
                event.currentValue = mPovs.get(i).lastValue;
                event.index = i;
                fireControllerChanged(event);
            }
        }

        // trigger changed Relative
        for (int i=0; i< getRelativeCount(); i++)
        {
            float last = mRelative.get(i).lastRelative;
            float lastValue = mRelative.get(i).lastValue;
            if (last != getRelativeValue(i))
            {
                ControllerEvent event = new ControllerEvent();
                event.component = mRelative.get(i).component;
                event.type = ControllerEvent.CONTROLLER_RELATIVE_CHANGED;
                event.componentId = getRelativeId(i);
                event.lastValue = lastValue;
                event.lastRelative = last;
                event.currentRelative = mRelative.get(i).lastRelative;
                event.currentValue = mRelative.get(i).lastValue;
                event.index = i;
                event.isRelative = true;

                fireControllerChanged(event);
            }
        }
    }
    // see: Component.java of JInput
    //  Returns a non-localized string description of this axis type.
    public static boolean isButton(Component.Identifier c)
    {
        // If the component identifier name contains only numbers, then this is a button.
        if(c.getName().matches("^[0-9]*$")) return true;
        if(c.getName().equals(Component.Identifier.Button.LEFT.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.MIDDLE.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.RIGHT.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.TRIGGER.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.THUMB.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.THUMB2.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.TOP.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.TOP2.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.PINKIE.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.BASE.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.BASE2.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.BASE3.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.BASE4.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.BASE5.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.BASE6.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.DEAD.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.A.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.B.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.C.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.X.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.Y.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.Z.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.LEFT_THUMB.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.RIGHT_THUMB.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.LEFT_THUMB2.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.RIGHT_THUMB2.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.SELECT.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.START.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.MODE.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.LEFT_THUMB3.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.RIGHT_THUMB3.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.TOOL_PEN.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.TOOL_RUBBER.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.TOOL_BRUSH.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.TOOL_PENCIL.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.TOOL_AIRBRUSH.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.TOOL_FINGER.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.TOOL_MOUSE.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.TOOL_LENS.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.TOUCH.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.STYLUS.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.STYLUS2.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.UNKNOWN.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.BACK.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.EXTRA.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.FORWARD.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.SIDE.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.EXTRA_1.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.EXTRA_2.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.EXTRA_3.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.EXTRA_4.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.EXTRA_5.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.EXTRA_6.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.EXTRA_7.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.EXTRA_8.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.EXTRA_9.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.EXTRA_10.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.EXTRA_11.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.EXTRA_12.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.EXTRA_13.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.EXTRA_14.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.EXTRA_15.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.EXTRA_16.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.EXTRA_17.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.EXTRA_18.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.EXTRA_19.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.EXTRA_20.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.EXTRA_21.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.EXTRA_22.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.EXTRA_23.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.EXTRA_24.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.EXTRA_25.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.EXTRA_26.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.EXTRA_27.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.EXTRA_28.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.EXTRA_29.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.EXTRA_30.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.EXTRA_31.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.EXTRA_32.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.EXTRA_33.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.EXTRA_34.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.EXTRA_35.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.EXTRA_36.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.EXTRA_37.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.EXTRA_38.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.EXTRA_39.getName())) return true;
        if(c.getName().equals(Component.Identifier.Button.EXTRA_40.getName())) return true;
        return false;
    }

    private ArrayList<ComponentWithHistory> mButtons= new ArrayList<ComponentWithHistory>();
    private ArrayList<ComponentWithHistory> mPovs= new ArrayList<ComponentWithHistory>();
    private ArrayList<ComponentWithHistory> mAxis= new ArrayList<ComponentWithHistory>();
    private ArrayList<ComponentWithHistory> mRelative= new ArrayList<ComponentWithHistory>();
    
    void init()
    {
        // Go trough all components of the controller.
        if (getController()==null) return;
        Component[] components = getController().getComponents();
        for(int i=0; i < components.length; i++)
        {
            Component component = components[i];
            Component.Identifier componentIdentifier = component.getIdentifier();

            // Buttons
            if (isButton(componentIdentifier))
            { 
                mButtons.add(new ComponentWithHistory(component));
                continue;
            }

            // Hat switch
            if(componentIdentifier == Component.Identifier.Axis.POV)
            {
                mPovs.add(new ComponentWithHistory(component));
                continue;
            }

            // Mouse
            if(component.isRelative())
            {
                mRelative.add(new ComponentWithHistory(component));
                continue;
            }

            // Axes
            if(component.isAnalog())
            {
                mAxis.add(new ComponentWithHistory(component));
                continue;
            }
        }
    }
    
    public int getButtonCount()
    {
        return mButtons.size();
    }
    
    // true = pressed
    // false = released
    public boolean getButtonState(int index)
    {
        return mButtons.get(index).lastButtonState = (mButtons.get(index).lastValue = mButtons.get(index).component.getPollData()) != 0.0f;
    }

    public String getButtonId(int index )
    {
        return mButtons.get(index).component.getIdentifier().getName();
    }
    public int getAxisCount()
    {
        return mAxis.size();
    }
    public String getAxisId(int index )
    {
        return mAxis.get(index).component.getIdentifier().getName();
    }
    // 50% is "middle"
    public int getAxisPercent(int index)
    {
        return mAxis.get(index).lastAxisPercent = (int)(((2 - (1 -(mAxis.get(index).lastValue= mAxis.get(index).component.getPollData())  )) * 100) / 2);
    }

    // pov
    public static final int OFF = 0;
    public static final int CENTER = 0;
    public static final int UP_LEFT = 1;
    public static final int UP = 2;
    public static final int UP_RIGHT = 3;
    public static final int RIGHT = 4;
    public static final int DOWN_RIGHT = 5;
    public static final int DOWN = 6;
    public static final int DOWN_LEFT = 7;
    public static final int LEFT = 8;
    public int getPOVPosition(int index)
    {
        
        float hatSwitchPosition = mPovs.get(index).lastValue = mPovs.get(index).component.getPollData();
        if(Float.compare(hatSwitchPosition, Component.POV.UP) == 0) return mPovs.get(index).lastPOV =UP;
        if(Float.compare(hatSwitchPosition, Component.POV.DOWN) == 0)return mPovs.get(index).lastPOV =DOWN;
        if(Float.compare(hatSwitchPosition, Component.POV.LEFT) == 0)return mPovs.get(index).lastPOV =LEFT;
        if(Float.compare(hatSwitchPosition, Component.POV.RIGHT) == 0)return mPovs.get(index).lastPOV =RIGHT;
        if(Float.compare(hatSwitchPosition, Component.POV.UP_LEFT) == 0)return mPovs.get(index).lastPOV =UP_LEFT;
        if(Float.compare(hatSwitchPosition, Component.POV.UP_RIGHT) == 0)return mPovs.get(index).lastPOV =UP_RIGHT;
        if(Float.compare(hatSwitchPosition, Component.POV.DOWN_LEFT) == 0)return mPovs.get(index).lastPOV =DOWN_LEFT;
        if(Float.compare(hatSwitchPosition, Component.POV.DOWN_RIGHT) == 0) return mPovs.get(index).lastPOV =DOWN_RIGHT;
            
        return mPovs.get(index).lastPOV =CENTER;
    }
    public int getPOVCount()
    {
        return mPovs.size();
    }
    public String getPOVId(int index )
    {
        return mPovs.get(index).component.getIdentifier().getName();
    }
    public int getRelativeCount()
    {
        return mRelative.size();
    }
    public String getRelativeId(int index )
    {
        return mRelative.get(index).component.getIdentifier().getName();
    }

    public float getRelativeValue(int index)
    {
        return mRelative.get(index).lastRelative = mRelative.get(index).lastValue = mRelative.get(index).component.getPollData();
    }
}
       