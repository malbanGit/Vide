/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package de.malban.gui.components;

import java.util.Vector;
import javax.swing.Icon;
import javax.swing.JLabel;

/**
 *
 * @author Malban
 */
public class FadingImageLabel extends JLabel implements Runnable
{
    public static final int DEFAULT_STEP = 30;
    static int counter=0;
    int thiscCounter = (counter++);
    Vector<Icon> icons = new Vector<Icon>();
    Thread animator = null;
    boolean doRun = false;
    int index=0;
    int animDelay = 25;

    public FadingImageLabel(String name)
    {
        this(name, DEFAULT_STEP);
    }
    public void deinit()
    {
        doRun=false;
        animator = null;
        icons = null;
    }
    public FadingImageLabel(String name, int count)
    {
        super();
        icons = ImageSequencer.createFromImageFading(name, count).getAsIcons();
        setSize(icons.elementAt(0).getIconWidth(), icons.elementAt(0).getIconHeight());
        setIcon(icons.elementAt(icons.size()-1));
    }

    boolean fadeIn = true;
    int startStep = 0;
    int stopStep = icons.size();
    public void fadeOut()
    {
        fadeOut(0, icons.size());
    }
    public void fadeOut(int fromStep, int toStep)
    {
        if (animator != null) return;
        if (icons.isEmpty()) return;
        if (icons.size() == 1)
        {
            this.setIcon(icons.elementAt(0));
            return;
        }
        startStep = stopStep;
        if (toStep>icons.size()-1) toStep=icons.size()-1;
        startStep = 0;
        stopStep = toStep;
        animator = new Thread(this);
        doRun = true;
        fadeIn = false;
        index = fromStep;
        animator.start();
    }

    public void fadeIn()
    {
        fadeIn(icons.size(), 0);
    }

    public void fadeIn(int fromStep, int toStep)
    {
        if (animator != null) return;
        if (icons.isEmpty()) return;
        if (icons.size() == 1)
        {
            this.setIcon(icons.elementAt(0));
            return;
        }
        if (toStep<0) toStep=0;
        startStep = fromStep;
        stopStep = toStep;
        animator = new Thread(this);
        doRun = true;
        fadeIn = true;
        index = fromStep;
        animator.start();
    }
    public void setDelay(int d)
    {
        animDelay=d;
    }

    // Run the animation thread.
    // First wait for the background image to fully load
    // and paint.  Then wait for all of the animation
    // frames to finish loading. Finally, loop and
    // increment the animation frame index.
    @Override
    public void run()
    {
        while (doRun)
        {
            try
            {
                Thread.sleep(animDelay);
            }
            catch (InterruptedException e)
            {
                break;
            }
            if (doRun)
            synchronized (this)
            {
                if (!fadeIn)
                {
                    index++;
                    if (index >= stopStep)
                    {
                        doRun=false;
                        animator = null;
                        this.setVisible(false);
                    }
                }
                else
                {
                    index--;
                    if (index <= stopStep)
                    {
                        doRun=false;
                        animator = null;
                    }
                }
                if (doRun)
                {
                    // despite sync, there actually happened at least once a out of bound index !")(""&(/!&"$$§
                    try
                    {
                        this.setIcon(icons.elementAt(index));
                    }
                    catch (Throwable e){}
                }

            }
            repaint();
        }
    }
}
