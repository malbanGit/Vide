/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package de.malban.gui;

import java.util.Vector;
import javax.swing.Icon;
import javax.swing.JLabel;

/**
 *
 * @author Malban
 */
public class AnimatedLabel extends JLabel implements Runnable
{
    static int counter=0;
    int thiscCounter = (counter++);
    Vector<Icon> icons = new Vector<Icon>();
    Thread animator = null;
    boolean doRun = false;
    int index=0;
    int animDelay = 25;

    // all images of icons MUST be loaded!
    public AnimatedLabel(Vector<Icon> i)
    {
        super();
        icons = i;
    }

    public void setDelay(int d)
    {
        animDelay=d;
    }

    @Override public void setVisible(boolean b)
    {
        super.setVisible(b);
        if (icons.isEmpty())
        {
            setText("NO IMAGE");
            return;
        }
        if (icons.size() == 1) 
        {
            this.setIcon(icons.elementAt(0));
            return;
        }
        if ( b )
        {
            if (animator == null)
            {
                animator = new Thread(this);
                doRun = true;
                animator.start();
            }
        }
        else
        {
            if (animator != null)
            {
                synchronized (this)
                {
                    doRun = false;
                    animator.interrupt();
                    animator = null;
                }
            }
        }
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
            synchronized (this)
            {
                index++;
                if (index >= icons.size())
                {
                    index = 0;
                }
/*
System.out.println(""+index+"("+thiscCounter+")");
System.out.println(this);
System.out.println(getParent().getComponentZOrder(this)+", " +getParent() );
System.out.println(getParent().getParent().getComponentZOrder(getParent())+", " +getParent().getParent() );
System.out.println(getParent().getParent().getParent().getComponentZOrder(getParent().getParent())+", " +getParent().getParent().getParent() );
System.out.flush();
*/
                this.setIcon(icons.elementAt(index));
                // this.setb;
            }
            repaint();
        }
    }
}


