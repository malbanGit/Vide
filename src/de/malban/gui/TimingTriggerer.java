/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package de.malban.gui;

import java.util.Vector;

/**
 *
 * @author Malban
 */
public class TimingTriggerer
{
    public static final int DEFAULT_RESOLUTION = 200;// 1/5 second
    private static TimingTriggerer timer = new TimingTriggerer();
    public static TimingTriggerer getTimer()
    {
        return timer;
    }
    
    class Trigger
    {
        TriggerCallback trigger;
        int timing;
        int state;
        Object o;
    }
    private long resolution = DEFAULT_RESOLUTION; // 1/5 second
    private boolean stop = true;
    private boolean running = false;
    private final Vector <Trigger> mTriggers = new Vector<Trigger>();

    private final boolean autoResolutionEnabled = true;
    public void deinit()
    {
        stop = true;

    }
    int minRes = 100000;
    public void start()
    {
        new Thread()
        {
            @Override public void run()
            {
                running = true;
                while (!stop)
                {
                    try
                    {
                        sleep(resolution);
                        if (!stop)
                        {
                            synchronized (mTriggers)
                            {
                                minRes = 100000;
                                for (int i = mTriggers.size()-1; i>=0 ; i--)
                                {
                                    Trigger trigger = mTriggers.elementAt(i);
                                    trigger.timing-=resolution;
                                    if (trigger.timing <=0)
                                    {
                                        mTriggers.removeElement(trigger);
                                        trigger.trigger.doIt(trigger.state, trigger.o);
                                    }
                                    else
                                    {
                                        if (minRes >trigger.timing)
                                        {
                                            minRes = trigger.timing;
                                        }
                                    }
                                }
                                if (mTriggers.isEmpty())
                                {
                                    stop=true;
                                    if (autoResolutionEnabled)
                                        setResolution(DEFAULT_RESOLUTION);
                                }
                                else
                                {
                                    if (autoResolutionEnabled)
                                    {
                                        setResolution(minRes);
                                    }
                                }
                            }
                        }
                    }
                    catch (Exception e)
                    {
                        e.printStackTrace();
                    }
                }
                running = false;
                mTriggers.clear();
            }
        }.start();
    }

    public void setResolution(int res)
    {
        if (res == 0)
        {
            System.out.println("Timer Res: 0");
            res=5;
        }
        
        if (resolution<res) return;
        resolution = res;
    }

    public void stop()
    {
        stop = true;
    }

    public void removeTrigger(TriggerCallback trigger)
    {
        synchronized (mTriggers)
        {
            for (int i = mTriggers.size()-1; i >=0 ; i--) 
            {
                Trigger trigger1 = mTriggers.elementAt(i);
                if (trigger1.trigger == trigger)
                    mTriggers.removeElement(trigger1);
            }
            if (mTriggers.isEmpty())
                stop=true;
        }
    }

    public void addTrigger(TriggerCallback trigger, int timing, int state, Object o)
    {
        if (timing<resolution) setResolution(timing);
        
        Trigger t = new Trigger();
        t.trigger = trigger;
        t.timing = timing;
        if (minRes>timing )minRes = timing;
        t.state = state;
        t.o = o;
        mTriggers.addElement(t);
        if (stop)
        {
            stop = false;
            if (!running)
                start();
        }
    }
}
