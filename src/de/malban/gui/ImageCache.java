/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.gui;

// see:
//http://www.javamex.com/classmexer/
import com.javamex.classmexer.MemoryUtil;
import java.awt.image.BufferedImage;
import java.util.HashMap;

/**
 *
 * @author malban
 */
public class ImageCache {

    private static boolean USE_SIZEOF;

    private final HashMap<Integer, ImageCacheItem> cacheByUID = new HashMap<Integer, ImageCacheItem>();
    private final HashMap<String, ImageCacheItem> cacheByKey = new HashMap<String, ImageCacheItem>();
    private final HashMap<BufferedImage, ImageCacheItem> cacheByImage = new HashMap<BufferedImage, ImageCacheItem>();
    private final static ImageCache ICACHE;

    private boolean cacheActive = true;

    // diable/enable caching
    // usefull e.g. for the "dragging" in image editing, which auto
    // updates the current selected image (possible scaled)
    public void setCacheActive(boolean a)
    {
        cacheActive = a;
    }

    static
    {
        ICACHE = new ImageCache();
        try
        {
            // to work put: -javaagent:libs/classmexer.jar in startup code of java
            MemoryUtil.memoryUsageOf(ICACHE);
            USE_SIZEOF = true;
        }
        catch (Throwable e)
        {
            USE_SIZEOF = false;
            // e.printStackTrace();
        }
    }

    public static void clearCache()
    {
        getImageCache().cacheByUID.clear();
        getImageCache().cacheByKey.clear();
        getImageCache().cacheByImage.clear();
    }

    public static ImageCache getImageCache()
    {
        return ICACHE;
    }
    private static String buildKey(String path)
    {
        return path;
    }

    public int getSize()
    {
        return cacheByUID.size();
    }

    public long getImageCacheSize()
    {
        if (USE_SIZEOF)
        {
            synchronized(cacheByUID)
            {
                return MemoryUtil.deepMemoryUsageOfAll(cacheByUID.values());
            }
        }
        return 0;
    }

    public ImageCacheItem getImageCacheItem(String path)
    {
        String key = buildKey(path);
        ImageCacheItem item = cacheByKey.get(key);
        if (item == null)
        {
            item = ImageCacheItem.buildItem(path);
            if (item == null) return null;
            item.setKey(key);
            addItem(item);
        }
        return item;
    }

    public ImageCacheItem getImageCacheByKey(String key)
    {
        ImageCacheItem item = cacheByKey.get(key);
        return item;
    }
    public ImageCacheItem getImageCacheByImage(BufferedImage bimage)
    {
        ImageCacheItem item = cacheByImage.get(bimage);
        return item;
    }

    public ImageCacheItem getImageCacheByUID(int uid)
    {
        ImageCacheItem item = cacheByUID.get(uid);
        return item;
    }
    public void removeItem(ImageCacheItem item)
    {
        if (item == null) return;
        synchronized(cacheByUID)
        {
            cacheByKey.remove(item.getKey());
            cacheByImage.remove(item.getBufferedImage());
            cacheByUID.remove(item.getUID());
        }
        invalidateDerivates(item);
    }

    public void remove(String path)
    {
        String key = buildKey(path);
        ImageCacheItem item = cacheByKey.get(key);
        if (item == null) return;
        synchronized(cacheByUID)
        {
            cacheByKey.remove(item.getKey());
            cacheByImage.remove(item.getBufferedImage());
            cacheByUID.remove(item.getUID());
        }
        invalidateDerivates(item);
    }

    public BufferedImage getImage(String path)
    {
        ImageCacheItem item = getImageCacheItem(path);
        if (item == null)
        {
            return null;
        }
        return item.getBufferedImage();
    }

    public void addItem(ImageCacheItem item)
    {
        if (!cacheActive) return;
        synchronized(cacheByUID)
        {
            cacheByKey.remove(item.getKey());
            cacheByKey.put(item.getKey(), item);

            cacheByImage.remove(item.getBufferedImage());
            cacheByImage.put(item.getBufferedImage(), item);

            cacheByUID.remove(item.getUID());
            cacheByUID.put(item.getUID(), item);
        }
    }

    public BufferedImage getDerivatScale(BufferedImage sourceImage, int scaleWidth, int scaleHeight)
    {
        ImageCacheItem item = cacheByImage.get(sourceImage);
        if (item == null)
        {
            // item to derivate from is not cached yet -> cache it!
            item = ImageCacheItem.buildItem(sourceImage);
            if (item == null) return null;
            addItem(item);
        }
        ImageCacheItem derivatItem = item.getDerivatScale(scaleWidth, scaleHeight);
        return derivatItem.getBufferedImage();
    }

        public BufferedImage getDerivatScale(BufferedImage sourceImage, int percent)
    {
        ImageCacheItem item = cacheByImage.get(sourceImage);
        if (item == null)
        {
            // item to derivate from is not cached yet -> cache it!
            item = ImageCacheItem.buildItem(sourceImage);
            if (item == null) return null;
            addItem(item);
        }
        int width = (item.getBufferedImage().getWidth(null) * percent ) / 100;
        int height = (item.getBufferedImage().getHeight(null) * percent) / 100;
        ImageCacheItem derivatItem = item.getDerivatScale(width, height);
        return derivatItem.getBufferedImage();
    }

    public BufferedImage getDerivatOpaque(BufferedImage sourceImage, int opacity)
    {
        ImageCacheItem item = cacheByImage.get(sourceImage);
        if (item == null)
        {
            // item to derivate from is not cached yet -> cache it!
            item = ImageCacheItem.buildItem(sourceImage);
            if (item == null) return null;
            addItem(item);
        }
        // ensure alpha channel!
        toAlpha(item.getBufferedImage());

        ImageCacheItem derivatItem = item.getDerivatOpaque(opacity);
        return derivatItem.getBufferedImage();
    }

    public BufferedImage getDerivatCanvasResize(BufferedImage sourceImage, int w, int h)
    {
        ImageCacheItem item = cacheByImage.get(sourceImage);
        if (item == null)
        {
            // item to derivate from is not cached yet -> cache it!
            item = ImageCacheItem.buildItem(sourceImage);
            if (item == null) return null;
            addItem(item);
        }

        ImageCacheItem derivatItem = item.getDerivatCanvasResize(w,h);
        return derivatItem.getBufferedImage();
    }

    /** Angle in degrees from 0 to 360
     *
     * @param sourceImage
     * @param angle
     * @return
     */
    public BufferedImage getDerivatRotate(BufferedImage sourceImage, double angle)
    {
        ImageCacheItem item = cacheByImage.get(sourceImage);
        if (item == null)
        {
            // item to derivate from is not cached yet -> cache it!
            item = ImageCacheItem.buildItem(sourceImage);
            if (item == null) return null;
            addItem(item);
        }
        ImageCacheItem derivatItem = item.getDerivatRotate(angle);
        return derivatItem.getBufferedImage();
    }

    public BufferedImage getDerivatRotate(BufferedImage sourceImage, double angle, boolean keepSize)
    {
        ImageCacheItem item = cacheByImage.get(sourceImage);
        if (item == null)
        {
            // item to derivate from is not cached yet -> cache it!
            item = ImageCacheItem.buildItem(sourceImage);
            if (item == null) return null;
            addItem(item);
        }
        ImageCacheItem derivatItem = item.getDerivatRotate(angle, keepSize);
        return derivatItem.getBufferedImage();
    }

    public BufferedImage getDerivatMirror(BufferedImage sourceImage, boolean isVerticalMirror)
    {
        ImageCacheItem item = cacheByImage.get(sourceImage);
        if (item == null)
        {
            // item to derivate from is not cached yet -> cache it!
            item = ImageCacheItem.buildItem(sourceImage);
            if (item == null) return null;
            addItem(item);
        }
        ImageCacheItem derivatItem = item.getDerivatMirror(isVerticalMirror);
        return derivatItem.getBufferedImage();
    }

    public BufferedImage getDerivatSubImage(BufferedImage sourceImage, int x, int y, int w, int h)
    {
        if (sourceImage == null) return null;
        ImageCacheItem item = cacheByImage.get(sourceImage);
        if (item == null)
        {
            // item to derivate from is not cached yet -> cache it!
            item = ImageCacheItem.buildItem(sourceImage);
            if (item == null) return null;
            addItem(item);
        }
        ImageCacheItem derivatItem = item.getDerivatSubImage(x, y, w, h);
        return derivatItem.getBufferedImage();
    }

    public BufferedImage getDerivatRGB(BufferedImage sourceImage, float r, float g, float b)
    {
        if (sourceImage == null) return null;
        ImageCacheItem item = cacheByImage.get(sourceImage);
        if (item == null)
        {
            // item to derivate from is not cached yet -> cache it!
            item = ImageCacheItem.buildItem(sourceImage);
            if (item == null) return null;
            addItem(item);
        }
        ImageCacheItem derivatItem = item.getDerivatRGB(r,g,b);
        return derivatItem.getBufferedImage();
    }

    public BufferedImage getDerivatHSB(BufferedImage sourceImage, float h, float s, float b)
    {
        if (sourceImage == null) return null;
        ImageCacheItem item = cacheByImage.get(sourceImage);
        if (item == null)
        {
            // item to derivate from is not cached yet -> cache it!
            item = ImageCacheItem.buildItem(sourceImage);
            if (item == null) return null;
            addItem(item);
        }
        ImageCacheItem derivatItem = item.getDerivatHSB(h,s,b);
        return derivatItem.getBufferedImage();
    }
    
    // remove all derivates, so they can be built anew when needed
    public void invalidateDerivates(BufferedImage sourceImage)
    {
        ImageCacheItem item = cacheByImage.get(sourceImage);
        invalidateDerivates(item);
    }

    public void invalidateDerivates(ImageCacheItem item)
    {
        if (item == null) return;
        item.invalidateDerivates();
    }

    public BufferedImage toAlpha(BufferedImage sourceImage)
    {
        ImageCacheItem item = cacheByImage.get(sourceImage);
        if (item != null)
        {
            if (item.isAlpha())
                return item.getBufferedImage();
        }

        BufferedImage alphaImage = de.malban.util.UtilityImage.toAlpha(sourceImage);
        if (item != null) // no cache found -> return simply the transformed image
        {
            removeItem(item); // also removes derivates
            item.setBufferedImage(alphaImage);
            addItem(item);
        }
        return alphaImage;
    }

    public void canBeInvalidated(BufferedImage image)
    {
        // sets a flag, that this one can be removed from cache
        // all derivates will become non-derivates
        // todo:
        // also - to implement invalidateCache()
    }
}
