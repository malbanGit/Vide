/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package de.malban.gui;

import javax.swing.*;
import java.util.*;
import java.awt.*;

/**
 *
 * @author Malban
 */
public class FadingTextLabel extends JLabel implements Runnable
{
    public static final int DEFAULT_STEP = 30;
    static int counter=0;
    int thiscCounter = (counter++);
    Thread animator = null;
    boolean doRun = false;
    int index=0;
    int animDelay = 25;
    String oldText ="";
    int fheight=0;

    Color orgTextColor=null;
    Color orgBackColor=null;

    Vector<Color> fColors = new Vector<Color>();
    Vector<Color> bColors = new Vector<Color>();

    Vector<String> words;
    Vector<String> lines;

    int steps = 30;
    public FadingTextLabel(String name)
    {
        this(name, DEFAULT_STEP);
        setOpaque(false);
        setDoubleBuffered(false);
        setVisible(false);
    }
    public void deinit()
    {
        synchronized (lines)
        {
            doRun=false;
            animator = null;
            words = null;
            lines = null;
        }
    }
    public FadingTextLabel(String name, int count)
    {
        super();
        setText(name);
    }

    public void setText(String t)
    {
        setText(t,0);
    }

    public void setText(String t, int maxWidth)
    {
        super.setText(t);

        oldText = getText();
        words = new Vector<String>();
        String text = getText();
        text = de.malban.util.UtilityString.replace(text, "<BR>", "<br>");
        text = de.malban.util.UtilityString.replace(text, "<html>", "");
        text = de.malban.util.UtilityString.replace(text, "</html>", "");
        text = de.malban.util.UtilityString.replace(text, "\n", "<br>");
        text = de.malban.util.UtilityString.replace(text, "\\n", "<br>");
        text = de.malban.util.UtilityString.replace(text, "<br>", " <br> ");
        String[] word = text.split(" ");
        for (int i = 0; i < word.length; i++) {
            String string = word[i].trim();
            if (string.length()!=0)
                words.addElement(string);
        }
        int size = maxWidth;
        Font f = getFont();
        int lineCount = 0;
        String line = "";
        int lineWidth = 0;

        int currentMaxWidth=0;
        if (f == null) return;
        if (getFontMetrics(f) == null) return;
        int spaceWidth = getFontMetrics(f).stringWidth(" ");
        fheight = getFontMetrics(f).getHeight();
        lines = new Vector<String>();
        synchronized (lines)
        {
            for (int i = 0; i < words.size(); i++)
            {
                String w = words.elementAt(i).trim();
                int width = getFontMetrics(f).stringWidth(w);

                if (w.indexOf("<br>")!=-1)
                {
                    lines.addElement(line);
                    if (lineWidth>currentMaxWidth)  currentMaxWidth = lineWidth;
                    lineWidth = 0;
                    line="";
                    continue;
                }

                if (lineWidth == 0)
                {
                    lineWidth = width;
                    line+=w;
                }
                else
                {
                    if ((size!=0) && (lineWidth+width+spaceWidth >size))
                    {
                        lines.addElement(line);
                        if (lineWidth>currentMaxWidth)  currentMaxWidth = lineWidth;
                        lineWidth = 0;
                        line="";
                        i--;
                        continue;
                    }
                    lineWidth += width+spaceWidth;
                    line+=" "+w;
                }
            }
            if (lineWidth>currentMaxWidth)  currentMaxWidth = lineWidth;
            lines.addElement(line);
        }
        int height = lines.size()*fheight+20;
        int width = currentMaxWidth+20;
        setPreferredSize(new Dimension(width, height));
    }

    boolean fadeIn = true;
    int startStep = 0;
    int stopStep = steps;
    private void buildColors()
    {
        if (orgTextColor==null)
        {
            orgTextColor = getForeground();
            orgBackColor = getBackground();

            fColors.clear();
            int inc = 255/(steps-2);
            Color c = new Color(orgTextColor.getRed(), orgTextColor.getGreen(), orgTextColor.getBlue(), 255);
            fColors.addElement(c);
            c = new Color(orgBackColor.getRed(), orgBackColor.getGreen(), orgBackColor.getBlue(), 255);
            bColors.addElement(c);
            for (int i=0; i< steps-2; i++)
            {
                c = new Color(orgTextColor.getRed(), orgTextColor.getGreen(), orgTextColor.getBlue(), 255-((i+1)*inc));
                fColors.addElement(c);
                c = new Color(orgBackColor.getRed(), orgBackColor.getGreen(), orgBackColor.getBlue(), 255-((i+1)*inc));
                bColors.addElement(c);
            }
            c = new Color(orgTextColor.getRed(), orgTextColor.getGreen(), orgTextColor.getBlue(), 0);
            fColors.addElement(c);
            c = new Color(orgBackColor.getRed(), orgBackColor.getGreen(), orgBackColor.getBlue(), 0);
            bColors.addElement(c);
        }
    }
    public void fadeOut()
    {
        buildColors();
        fadeOut(0, fColors.size());
    }
    private void fadeOut(int fromStep, int toStep)
    {
        while (animator != null)
        {
            try
            {
                Thread.sleep(100);
            }
            catch (InterruptedException e)
            {
                break;
            }
        }
        if (fColors.size() == 0) return;
        if (fColors.size() == 1)
        {
            this.setForeground(fColors.elementAt(0));
            this.setBackground(bColors.elementAt(0));
            return;
        }
        startStep = stopStep;
        if (toStep>fColors.size()-1) toStep=fColors.size()-1;
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
        buildColors();
        fadeIn(fColors.size(), 0);
        this.setForeground(fColors.elementAt(fColors.size()-1));
        this.setBackground(bColors.elementAt(bColors.size()-1));
        setVisible(true);
    }

    private void fadeIn(int fromStep, int toStep)
    {
        if (animator != null) return;
        if (fColors.size() == 0) return;
        if (fColors.size() == 1)
        {
            this.setForeground(fColors.elementAt(0));
            this.setBackground(bColors.elementAt(0));
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
                        setVisible(false);
                    }
                }
                else
                {
                    index--;
                    if (index <= stopStep)
                    {
//System.out.println("Fading fone");
                        doRun=false;
                        animator = null;
                    }
                }
                if (doRun)
                {

//System.out.println("Using color: "+bColors.elementAt(index)+" "+bColors.elementAt(index).getAlpha() );
                    this.setForeground(fColors.elementAt(index));
                    this.setBackground(bColors.elementAt(index));
                    setText(getText());
                }
            }
            repaint();
        }
    }
    
    @Override
    public void paintComponent(java.awt.Graphics g)
    {
        if ((index <0) || (index >= steps)) return;
        g.setColor(bColors.elementAt(index));
        g.fillRect(0, 0, getWidth()-1, getHeight()-1);
        g.setColor(new Color(0,0,0,bColors.elementAt(index).getAlpha()));
        g.drawRect(0, 0, getWidth()-1, getHeight()-1);
        g.setColor(getForeground());


        if (lines != null)
        synchronized (lines)
        {
            for (int i = 0; i < lines.size(); i++)
            {
                String  line = lines.elementAt(i);
                g.drawString(line, 10,10+ fheight*(i+1));
            }
        }
//        super.paintComponent(g);
    }
}
