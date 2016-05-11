package de.malban.util;


import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.RenderingHints;
import java.awt.Transparency;
import java.awt.image.BufferedImage;
import java.awt.image.ImageObserver;
import java.awt.image.VolatileImage;
import java.io.File;
import java.net.URL;
import javax.imageio.ImageIO;

/**
 */
public class UtilityImage
{
    public static BufferedImage toBufferedImage(final Image image)
    {
        if (image == null) return null;
        if (image instanceof BufferedImage)
            return (BufferedImage) image;
        if (image instanceof VolatileImage)
            return ((VolatileImage) image).getSnapshot();
        loadImage(image);
        final BufferedImage buffImg = new BufferedImage(image.getWidth(null), image.getHeight(null), java.awt.image.BufferedImage.TYPE_4BYTE_ABGR);
        final Graphics2D g2 = buffImg.createGraphics();
        g2.drawImage(image, null, null);
        g2.dispose();
        return buffImg;
    }
    public static BufferedImage copyImage(final Image image)
    {
        if (image == null) return null;
        loadImage(image);
        final BufferedImage buffImg = new BufferedImage(image.getWidth(null), image.getHeight(null), java.awt.image.BufferedImage.TYPE_4BYTE_ABGR);
        final Graphics2D g2 = buffImg.createGraphics();
        g2.drawImage(image, null, null);
        g2.dispose();
        return buffImg;
    }

    /** Converts an image to an image which has alpha channels.
     *
     * @param image
     * @return
     */
    public static BufferedImage toAlpha(final Image image)
    {
        if (image == null) return null;
        loadImage(image);
        final BufferedImage buffImg = new BufferedImage(image.getWidth(null), image.getHeight(null), java.awt.image.BufferedImage.TYPE_4BYTE_ABGR);
        final Graphics2D g2 = buffImg.createGraphics();
        g2.drawImage(image, null, null);
        g2.dispose();
        return buffImg;
    }
    public static BufferedImage toNonAlpha(final Image image)
    {
        if (image == null) return null;
        loadImage(image);
        final BufferedImage buffImg = new BufferedImage(image.getWidth(null), image.getHeight(null), java.awt.image.BufferedImage.TYPE_3BYTE_BGR);
        final Graphics2D g2 = buffImg.createGraphics();
        g2.drawImage(image, null, null);
        g2.dispose();
        return buffImg;
    }

    
    
    
    private static void loadImage(final Image image)
    {
        if (image == null) return;
        class StatusObserver implements ImageObserver
        {
            boolean imageLoaded = false;
            @Override public boolean imageUpdate(final Image img, final int infoflags, final int x, final int y, final int width, final int height)
            {
                if (infoflags == ALLBITS)
                {
                    synchronized (StatusObserver.this)
                    {
                        imageLoaded = true;
                        notify();
                    }
                    return true;
                }
                return false;
            }
        }
        final StatusObserver imageStatus = new StatusObserver();
        if (image == null) return;
        synchronized (imageStatus)
        {
            if (image.getWidth(imageStatus) == -1 || image.getHeight(imageStatus) == -1)
            {
                while (!imageStatus.imageLoaded)
                {
                    try
                    {
                        imageStatus.wait();
                    } catch (InterruptedException ex) {}
                }
            }
        }
    }


    @SuppressWarnings("CallToThreadDumpStack")
    // returns BufferedImage
    public static BufferedImage loadImage(URL name)
    {
        java.awt.Image dImage;

        dImage =java.awt.Toolkit.getDefaultToolkit().createImage(name);
        java.awt.MediaTracker tracker = new java.awt.MediaTracker(de.malban.Global.mMainWindow);
        tracker.addImage(dImage, 1);

        boolean interrupt;
        do
        {
            try
            {
                interrupt = false;
                tracker.waitForAll();
            } catch (InterruptedException e)
            {
                interrupt=true;
            //    System.out.println("Error loading images!");
            //    e.printStackTrace();
                return null;
        }} while (interrupt);
        return toBufferedImage(dImage);
    }


    @SuppressWarnings("CallToThreadDumpStack")
    public static BufferedImage loadImage(String name)
    {
        java.awt.Image dImage;
        name = UtilityString.cleanFileString(name);

        File file =new java.io.File(name);
        if (!file.exists()) return null;
        try
        {
            dImage = ImageIO.read(file);
        } catch (Throwable e)
        {
            //System.out.println("Error loading images!");
            //e.printStackTrace();
            return null;
        }
        return toBufferedImage(dImage);
    }

    @SuppressWarnings("CallToThreadDumpStack")
    public static BufferedImage loadImage_old(String name)
    {
        java.awt.Image dImage = null;

        name = UtilityString.cleanFileString(name);

        File file =new java.io.File(name);
        if (file.exists())
        {
            dImage =java.awt.Toolkit.getDefaultToolkit().createImage(name);


            java.awt.MediaTracker tracker = new java.awt.MediaTracker(de.malban.Global.mMainWindow);
            tracker.addImage(dImage, 1);

            boolean interrupt;
            do
            {
                try
                {
                    interrupt = false;
                    tracker.waitForAll();
                } catch (InterruptedException e)
                {
                    interrupt=true;
               //     System.out.println("Error loading images!");
               //     e.printStackTrace();
                    return null;
            }} while (interrupt);
        }
        return toBufferedImage(dImage);
    }

    // http://today.java.net/pub/a/today/2007/04/03/perils-of-image-getscaledinstance.html
    public static BufferedImage imageScale(Image image, int width, int height)
    {
        if (image == null) return null;
        if (width == 0) return toBufferedImage(image);
        if (height == 0) return toBufferedImage(image);
        return getScaledInstance(toBufferedImage(image),width, height, RenderingHints.VALUE_INTERPOLATION_BILINEAR, true);
    }

    public static BufferedImage imageScale(Image image, int percent)
    {
        if (image == null) return null;
        int width = (image.getWidth(null) * percent ) / 100;
        int height = (image.getHeight(null) * percent) / 100;
        return imageScale(image, width, height);
    }


    public static BufferedImage getNewImage(int w, int h)
    {
        return getNewImage(w, h, true);
    }
    public static BufferedImage getNewImage(int w, int h, boolean hasAlpha)
    {
        int type;
        if (hasAlpha)
            type = BufferedImage.TYPE_INT_ARGB;
        else
            type = BufferedImage.TYPE_INT_RGB;
        if (w<=0) return null;
        if (h<=0) return null;
        BufferedImage tmp = new BufferedImage(w, h, type);
        Graphics2D g2 = tmp.createGraphics();
        g2.clearRect(0, 0, w, h);
        g2.dispose();
        return tmp;
    }

    /**
     * Convenience method that returns a scaled instance of the
     * provided {@code BufferedImage}.
     *
     * @param img the original image to be scaled
     * @param targetWidth the desired width of the scaled instance,
     *    in pixels
     * @param targetHeight the desired height of the scaled instance,
     *    in pixels
     * @param hint one of the rendering hints that corresponds to
     *    {@code RenderingHints.KEY_INTERPOLATION} (e.g.
     *    {@code RenderingHints.VALUE_INTERPOLATION_NEAREST_NEIGHBOR},
     *    {@code RenderingHints.VALUE_INTERPOLATION_BILINEAR},
     *    {@code RenderingHints.VALUE_INTERPOLATION_BICUBIC})
     * @param higherQuality if true, this method will use a multi-step
     *    scaling technique that provides higher quality than the usual
     *    one-step technique (only useful in downscaling cases, where
     *    {@code targetWidth} or {@code targetHeight} is
     *    smaller than the original dimensions, and generally only when
     *    the {@code BILINEAR} hint is specified)
     * @return a scaled version of the original {@code BufferedImage}
     */
    public static BufferedImage getScaledInstance(BufferedImage img,
                                           int targetWidth,
                                           int targetHeight,
                                           Object hint,
                                           boolean higherQuality)
    {
        int type = (img.getTransparency() == Transparency.OPAQUE) ?
            BufferedImage.TYPE_INT_RGB : BufferedImage.TYPE_INT_ARGB;
        BufferedImage ret = (BufferedImage)img;
        int w, h;
        boolean hqw = higherQuality;
        boolean hqh = higherQuality;

        if (targetWidth >= img.getWidth()) hqw = false;
        if (targetHeight >= img.getHeight()) hqh = false;

        if (hqw) {
            // Use multi-step technique: start with original size, then
            // scale down in multiple passes with drawImage()
            // until the target size is reached
            w = img.getWidth();
        } else {
            // Use one-step technique: scale directly from original
            // size to target size with a single drawImage() call
            w = targetWidth;
        }
        if (hqh) {
            // Use multi-step technique: start with original size, then
            // scale down in multiple passes with drawImage()
            // until the target size is reached
            h = img.getHeight();
        } else {
            // Use one-step technique: scale directly from original
            // size to target size with a single drawImage() call
            h = targetHeight;
        }

        do {
            if (hqw && w > targetWidth) {
                w /= 2;
                if (w < targetWidth) {
                    w = targetWidth;
                }
            }

            if (hqh && h > targetHeight) {
                h /= 2;
                if (h < targetHeight) {
                    h = targetHeight;
                }
            }

            BufferedImage tmp = new BufferedImage(w, h, type);
            Graphics2D g2 = tmp.createGraphics();
            g2.setRenderingHint(RenderingHints.KEY_INTERPOLATION, hint);
            g2.drawImage(ret, 0, 0, w, h, null);
            g2.dispose();

            ret = tmp;
        } while (w != targetWidth || h != targetHeight);

        return ret;
    }

    public static int colorToInt(Color col)
    {
        return col.getRGB();
    }
    public static Color intToColor(int c)
    {
        return new Color(c);
    }
    public static Color intToColor(int r, int g, int b)
    {
        return new Color(r,g,b,255);
    }
    public static Color intToColor(int r, int g, int b, int a)
    {
        return new Color(r,g,b,a);
    }
}
