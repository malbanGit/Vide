
/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package de.malban.gui.components;
import de.malban.gui.ImageCache;
import de.malban.gui.image.SaveOpacityFilter;
import java.awt.Graphics2D;
import java.awt.Toolkit;
import java.awt.image.BufferedImage;
import java.util.Vector;
import javax.swing.Icon;
import javax.swing.ImageIcon;
import javax.swing.JPanel;

/**
 *
 * @author Malban
 */
public class ImageSequencer extends JPanel
{
    private static int id =0;
    Vector<BufferedImage> bimages = new Vector<BufferedImage>();

    Toolkit toolkit = Toolkit.getDefaultToolkit();

    // "D:\Dev\JavaProjects\JPortal\images\jewels\jewel darkblue0000.bmp"
    // only up to 99

    /** Loads a single image and sets an opacity
     *
     * @param name pathname
     */
    private ImageSequencer()
    {
    }


    /** Loads a count images of kind "image00.p ng" count replaces "00"
     *
     * @param name pathname
     * @param count Steps to fade of images
     */
    public static ImageSequencer createFromImageFading(String name, int count)
    {
        name = de.malban.util.UtilityString.cleanFileString(name);
        ImageSequencer i = new ImageSequencer();
        i.initImageFading(name, count);
        return i;
    }

    /** Loads a count images of kind "image00.p ng" count replaces "00"
     *
     * @param name pathname
     * @param count number of images
     */
    public static ImageSequencer createFromImageSequence(String name, int count)
    {
        name = de.malban.util.UtilityString.cleanFileString(name);
        ImageSequencer i = new ImageSequencer();
        i.initImageSequence(name, count);
        return i;
    }
    public static ImageSequencer createByRotation(String name, int steps)
    {
        name = de.malban.util.UtilityString.cleanFileString(name);
        ImageSequencer i = new ImageSequencer();
        i.initRotationSequence(name, steps);
        return i;
    }

    public Vector<BufferedImage> getBufferedImages()
    {
        return bimages;
    }

    public Vector<Icon> getAsIcons()
    {
        Vector<Icon> icons = new Vector<Icon>();
        for (int i=0; i<bimages.size(); i++)
        {
            BufferedImage image = bimages.elementAt(i);
            ImageIcon icon = new ImageIcon(image);
            icons.addElement(icon);
        }
        return icons;
    }

    private boolean initRotationSequence(String name, int steps)
    {
        if  (!initImageSequence(name, 1))
        {
            return false;
        }
        // remove the element itself, because it will be rotated by 0 degrees
        // easier this way because the size will be changed
        BufferedImage bimage = bimages.elementAt(0);
        bimages.clear();
        
        int angleInc = 360 / steps;
        int angleNow = 0;
        int size;
        int h = bimage.getHeight();
        int w = bimage.getWidth();
        if (h>w) size = h; else size=w;
        //int difSize = h-w;
        //int difHalf = difSize/2;
        int bigSize = (int) (Math.sqrt(((double)2*(size*size))) +0.999);
        size=bigSize;

        for (int i=0; i<steps; i++)
        {
            BufferedImage dimg = new BufferedImage(size, size, bimage.getType());
            Graphics2D g = dimg.createGraphics();
            g.rotate(Math.toRadians(angleNow), size/2, size/2);
            angleNow+=angleInc;
            //g.drawImage(bimage, null, difHalf, 0);
            g.drawImage( bimage, (size-w)/2, (size-h)/2,bimage.getWidth(), bimage.getHeight(), null);
            // now Crop to original size
            //BufferedImage bimageCropped = dimg.getSubimage(0, difHalf, h, w);
            bimages.addElement(dimg);
          //  bimages.addElement(bimage);

        }
        return true;
    }

     private boolean initImageFading(String name, int steps)
    {
        if  (!initImageSequence(name, 1))
        {
            return false;
        }
        int stepIncread = 255/(steps-2);
        int opaqueness = stepIncread;
        BufferedImage bimage = bimages.elementAt(0);
        //bimages.clear();
        for (int s = 0; s<(steps-2);s++)
        {
            SaveOpacityFilter filter = new SaveOpacityFilter(255-opaqueness);
            bimages.addElement(filter.filter(bimage, null));
            opaqueness+=stepIncread;
        }
        SaveOpacityFilter filter = new SaveOpacityFilter(0);
        bimages.addElement(filter.filter(bimage, null));
        return true;
    }

    @SuppressWarnings("CallToThreadDumpStack")
    private boolean initImageSequence(String name, int count)
    {
        if (count <=0) return false;
        String extension = name.substring(name.lastIndexOf("."));
        String base = name.substring(0, name.lastIndexOf("."));
        boolean greaterTen = count>9;
        if (greaterTen)
            base = base.substring(0, base.length()-2);
        else
            base = base.substring(0, base.length()-1);
        for (int i=0; i<count; i++)
        {
            String path = base;
            if ((i<10) && (greaterTen)) path+="0";
            path+=i;
            path+=extension;
            if (count == 1) path = name;
            BufferedImage image = ImageCache.getImageCache().getImage(path);
            bimages.addElement(image);
        }
        return true;
    }

    public void transformScale(int h, int w)
    {
        Vector<BufferedImage> newBimages = new Vector<BufferedImage>();
        for (int i=0; i<bimages.size(); i++)
        {
            BufferedImage image = bimages.elementAt(i);
            BufferedImage bimage = ImageCache.getImageCache().getDerivatScale(image, w, h);
            newBimages.addElement(bimage);
        }
        bimages = newBimages;
    }

    public void transformOpaque(int opaqueness)
    {
        Vector<BufferedImage> newBimages = new Vector<BufferedImage>();
        for (int i=0; i<bimages.size(); i++)
        {
            BufferedImage image = bimages.elementAt(i);
            BufferedImage bimage = ImageCache.getImageCache().getDerivatOpaque(image, opaqueness);
            newBimages.addElement(bimage);
        }
        bimages = newBimages;
    }

    public void transformScale(int percent)
    {
    }

    public void transformRotate()
    {
    }
}
