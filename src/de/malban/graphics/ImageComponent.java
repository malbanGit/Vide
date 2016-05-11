/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package de.malban.graphics;

import de.malban.Global;
import de.malban.gui.ImageCache;
import de.malban.gui.TimingTriggerer;
import de.malban.gui.TriggerCallback;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.image.BufferedImage;
import java.util.Vector;
import javax.swing.JComponent;

/**
 *
 * @author Malban
 */
public class ImageComponent extends JComponent 
{
    private static int counter=0;
    private ImageSequence mImageSequence = null;
    final int UID = (counter++);
    
    Vector<BufferedImage> imagesUse = new Vector<BufferedImage>();
    Vector<BufferedImage> imagesOrg = new Vector<BufferedImage>();
    Vector<Integer> imagesOrgOffsetX = new Vector<Integer>();
    Vector<Integer> imagesOrgOffsetY = new Vector<Integer>();
    Vector<Integer> imagesUseOffsetX = new Vector<Integer>();
    Vector<Integer> imagesUseOffsetY = new Vector<Integer>();

    boolean useOffset=true;
    boolean useScale = false;
    int scaleW=0;
    int scaleH=0;
    
    boolean doRun = false;
    int index=-1;
    int animDelay = 25;
    boolean anim = true;
    boolean isOpaque = false;

    boolean randomAnim = false;
    
    // all imagesUse of icons MUST be loaded!
    public ImageComponent()
    {
        super();
    }

    private ImageComponent(Vector<BufferedImage> i, boolean d)
    {
        super();
        imagesOrg = i;
        imagesOrgOffsetX = new Vector<Integer>();
        imagesOrgOffsetY = new Vector<Integer>();
        imagesUseOffsetX = new Vector<Integer>();
        imagesUseOffsetY = new Vector<Integer>();
        for (int j = 0; j < i.size(); j++)
        {
            imagesUse.addElement(i.elementAt(j));
            imagesOrgOffsetX.addElement(0);
            imagesOrgOffsetY.addElement(0);
            imagesUseOffsetX.addElement(0);
            imagesUseOffsetY.addElement(0);
        }
    }

    public void deinit()
    {
        setVisible(false);
        started = false;
        imagesUse = null;
        imagesOrg = null;
        imagesOrgOffsetX = null;
        imagesOrgOffsetY = null;
        imagesUseOffsetX = null;
        imagesUseOffsetY = null;
        mImageSequence = null;
    }
    
    private void setImages(Vector<BufferedImage> i)
    {
        boolean v = isVisible();
        if (v) setVisible(false);
        mImageSequence = null;
        imagesOrg = i;
        imagesUse = new Vector<BufferedImage>();

        imagesOrgOffsetX = new Vector<Integer>();
        imagesOrgOffsetY = new Vector<Integer>();
        imagesUseOffsetX = new Vector<Integer>();
        imagesUseOffsetY = new Vector<Integer>();
        
        for (int j = 0; j < i.size(); j++)
        {
            imagesUse.addElement(i.elementAt(j));
            
            imagesOrgOffsetX.addElement(0);
            imagesOrgOffsetY.addElement(0);
            imagesUseOffsetX.addElement(0);
            imagesUseOffsetY.addElement(0);
        }
        if (v) setVisible(true);
    }

    public void setImage(BufferedImage im)
    {
        boolean v = isVisible();
        if (v) setVisible(false);
        mImageSequence = null;
        imagesOrg = new Vector<BufferedImage>();
        imagesOrg.addElement(im);
        imagesUse = new Vector<BufferedImage>();

        imagesOrgOffsetX = new Vector<Integer>();
        imagesOrgOffsetY = new Vector<Integer>();
        imagesUseOffsetX = new Vector<Integer>();
        imagesUseOffsetY = new Vector<Integer>();
        
        for (int j = 0; j < imagesOrg.size(); j++)
        {
            imagesUse.addElement(imagesOrg.elementAt(j));
            
            imagesOrgOffsetX.addElement(0);
            imagesOrgOffsetY.addElement(0);
            imagesUseOffsetX.addElement(0);
            imagesUseOffsetY.addElement(0);
        }
        if (v) setVisible(true);
    }
    
    public void setSequence(ImageSequence is)
    {
        if (is == null)
        {
            setImages(new Vector<BufferedImage>());
            return;
        }
        setDelay(is.getDelay());
        setImages(is.getImageVector());
        useOffset = true;
        imagesOrgOffsetX = new Vector<Integer>();
        imagesOrgOffsetY = new Vector<Integer>();
        imagesUseOffsetX = new Vector<Integer>();
        imagesUseOffsetY = new Vector<Integer>();

        for (int i=0; i< is.getBaseImageData().size();i++)
        {
            BaseImageData data = is.getBaseImageData().elementAt(i);
            imagesOrgOffsetX.addElement(data.ox);
            imagesOrgOffsetY.addElement(data.oy);
            imagesUseOffsetX.addElement(data.ox);
            imagesUseOffsetY.addElement(data.oy);
        }
        randomAnim = is.mData.mRandomAnimationStart;
        mImageSequence = is;
    }
    public ImageSequence getSequence()
    {
         return mImageSequence;
    }

    public void setDelay(int d)
    {
        boolean iv = isVisible();
        setVisible(false);        
        animDelay=d;
        if (imagesUse.size() <= 1) animDelay = -1;
        if (iv)
            setVisible(true);        
    }

    // this sets a fixed scale
    public void setScaled(boolean scaled, int h, int w)
    {
        useScale = scaled;
        scaleW=w;
        scaleH=h;

        boolean v = isVisible();
        if (v) setVisible(false);
        imagesUse = new Vector<BufferedImage>();

        int maxW = 0;
        int maxH = 0;
        imagesUseOffsetX.clear();
        imagesUseOffsetY.clear();
        
        for (int i = 0; i < imagesOrg.size(); i++)
        {
            BufferedImage image = imagesOrg.elementAt(i);
            if (image == null) continue;
            if (maxW==0) 
                maxW = image.getWidth(null);
            if (maxH==0) 
                maxH = image.getHeight(null);
            if (imagesOrgOffsetX.size()>i)
            {
                if (maxW<image.getWidth(null)+imagesOrgOffsetX.elementAt(i)) 
                    maxW = image.getWidth(null)+imagesOrgOffsetX.elementAt(i);
                if (maxH<image.getHeight(null)+imagesOrgOffsetY.elementAt(i)) 
                    maxH = image.getHeight(null)+imagesOrgOffsetY.elementAt(i);
            }
        }
        
        for (int i = 0; i < imagesOrg.size(); i++)
        {
            BufferedImage image = imagesOrg.elementAt(i);
            if (image==null) continue;

            int xo = 0;
            int yo = 0;
            if (imagesOrgOffsetX.size()>i)
            {
                xo = imagesOrgOffsetX.elementAt(i);
                yo = imagesOrgOffsetY.elementAt(i);
            }
            
            if (scaled)
            {
                BufferedImage scaledImage;
                if (useOffset)
                {
                    double scaleX = (double) (((double)w)/((double)(maxW)));
                    double scaleY = (((double)h)/((double)(maxH)));
                    scaledImage = ImageCache.getImageCache().getDerivatScale(image, (int)(image.getWidth(null)*scaleX), (int)(image.getHeight(null)*scaleY));
                    if (imagesOrgOffsetX.size()>i)
                    {
                        int scaledOffsetY = (int) ((double) (scaleY * ((double) yo) )  );
                        int scaledOffsetX = (int) ((double) (scaleX * ((double) xo) )  );

                        imagesUseOffsetX.addElement((int)scaledOffsetX);
                        imagesUseOffsetY.addElement((int)scaledOffsetY);
                    }
                }
                else
                {
                    scaledImage = ImageCache.getImageCache().getDerivatScale(image, w , h);
                    imagesUseOffsetX.addElement(0);
                    imagesUseOffsetY.addElement(0);
                }
                imagesUse.addElement(scaledImage);
            }
            else
            {

                imagesUseOffsetX.addElement((int)xo);
                imagesUseOffsetY.addElement((int)yo);
                imagesUse.addElement(image);
            }
        }

        setSize(new Dimension(w, h));
        setPreferredSize(new Dimension(w, h));
        if (v) setVisible(true);
    }

    TriggerCallback tt; 
    boolean started = false;
    @Override public void setVisible(boolean b)
    {
        boolean oldVisibility = isVisible();
        super.setVisible(b);
        if (oldVisibility == b) return;

        if (imagesUse.isEmpty())
        {
            index = -1;
            return;
        }
        if (imagesUse.size() == 1)
        {
            index = 0;
            return;
        }
        if (animDelay == -1)
        {
            index = 0;
            return;
        }

        if (randomAnim)
        {
            index =  Global.getRand().nextInt(imagesUse.size());
        }
        
        final TimingTriggerer timer = TimingTriggerer.getTimer();
        if (b)
        {
            started = true;
            timer.setResolution(10); //100*1ms resoltuion is 0,1seconds
            if (tt != null)
            {
                timer.removeTrigger(tt);
                tt = null;                
            }

            tt = new TriggerCallback()
            {
                @Override
                public void doIt(int state, Object o)
                {
                    if (!isVisible()) return;
                    if (animDelay != -1)
                    {
                        if (!imagesUse.isEmpty())
                        {
                            index = (index + 1) % imagesUse.size();
                        }
                        else
                            index = -1;
                        if (started)
                            timer.addTrigger(tt, animDelay, 0, null);
                    }
                    repaint();
                }
            };
            timer.addTrigger(tt, animDelay, 0, null);
        }
        
        else
        {
            timer.removeTrigger(tt);
            tt = null;
            started = false;
        }
    }

    @Override public void paintComponent(Graphics g)
    {
        int clearWidth = getWidth();
        int clearHeight = getHeight();
        if (!isOpaque)
            g.clearRect(0, 0, clearWidth, clearHeight);
        if (index == -1) return;
        if ((imagesUse == null) || (imagesUse.isEmpty())) return;
        if (index > imagesUse.size()-1) return;
        if (!useOffset)
            g.drawImage(imagesUse.elementAt(index), 0, 0, null);
        else
            g.drawImage(imagesUse.elementAt(index), imagesUseOffsetX.elementAt(index), imagesUseOffsetY.elementAt(index), null);
    }
    
    public void setUseOffsets(boolean b)
    {
        useOffset = b;
        setScaled(useScale, scaleH, scaleW);
    }
 }
