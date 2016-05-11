/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.gui;

import de.malban.gui.image.HSBAdjustFilter;
import de.malban.gui.image.OpacityFilter;
import de.malban.gui.image.RGBAdjustFilter;
import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.image.BufferedImage;
import java.io.File;
import java.util.ArrayList;

/**
 *
 * @author salchr
 */
public class ImageCacheItem
{
    public static int DERIVAT_NO = 0;
    public static int DERIVAT_SCALE = 1;
    public static int DERIVAT_SUB = 2;
    public static int DERIVAT_OPAQUE =3;
    public static int DERIVAT_ROTATE =4;
    public static int DERIVAT_RESIZE =5;
    public static int DERIVAT_VMIRROR =6;
    public static int DERIVAT_HMIRROR =7;
    public static int DERIVAT_RGB=8;
    public static int DERIVAT_HSB=9;

    ArrayList<Integer> derivateUIDs = new ArrayList<Integer>();
    private static int counter=0;
    private int UID = (counter++);
    private String key="";

    private BufferedImage bimage;
    private int usageCount=0;
    private int derivatFrom = -1; // UID
    private boolean cacheable = true;

    private int derivatType = DERIVAT_NO;
    private int scaleWidth=0;
    private int scaleHeight=0;

    private boolean vMirror=false;
    private boolean hMirror=false;
    private boolean keepSize=false;
    private int opacity=0;
    private int subX=0;
    private int subY=0;
    private int subWidth=0;
    private int subHeight=0;
    private int resizeWidth=0;
    private int resizeHeight=0;

    private float rFactor=0;
    private float gFactor=0;
    private float bFactor=0;
    
    private float h_Factor=0;
    private float s_Factor=0;
    private float b_Factor=0;
    
    public boolean isAlpha() {
        if (bimage== null) return false;
        return bimage.getColorModel().hasAlpha();
    }

    private double angle = 0.0;

    private String sourcePath="";

    private ImageCacheItem() {}

    public String getKey() {
        if (key.length()==0) return ""+UID;
        return key;
    }

    public void setKey(String key) {
        this.key = key;
    }

    public int getUID() {
        return UID;
    }

    public BufferedImage getBufferedImage() {
        return bimage;
    }

    public void setBufferedImage(BufferedImage bi) {
        bimage = bi;

    }

    public boolean isCacheable() {
        return cacheable;
    }

    public int getDerivatFrom() {
        return derivatFrom;
    }

    public int getDerivatType() {
        return derivatType;
    }

    public int getScaleHeight() {
        return scaleHeight;
    }

    public int getScaleWidth() {
        return scaleWidth;
    }

    public String getSourcePath() {
        return sourcePath;
    }

    public int decUsageCount() {
        usageCount--;
        return usageCount;
    }

    public int incUsageCount() {
        this.usageCount++;
        return usageCount;
    }

    public int getUsageCount() {
        return usageCount;
    }

    public static ImageCacheItem buildItem(String path)
    {
        ImageCacheItem item = new ImageCacheItem();
        item.sourcePath = de.malban.util.UtilityString.cleanFileString(path);
        File inFile = new File(item.sourcePath);
        if (!inFile.exists()) return null;
        Image image = de.malban.util.UtilityImage.loadImage(path);
        if (image==null) return null;

        item.bimage = de.malban.util.UtilityImage.toBufferedImage(image);
        item.scaleHeight=item.bimage.getHeight(null);
        item.scaleWidth=item.bimage.getWidth(null);
        return item;
    }

    public static ImageCacheItem buildItem(BufferedImage bimage)
    {
        if (bimage==null) return null;
        ImageCacheItem item = new ImageCacheItem();
        item.bimage = bimage;
        item.scaleHeight=item.bimage.getHeight(null);
        item.scaleWidth=item.bimage.getWidth(null);
        return item;
    }

    protected ImageCacheItem getDerivatScale(int scaleWidth, int scaleHeight)
    {
        if ((bimage.getHeight(null)==scaleHeight) && (bimage.getWidth(null)==scaleWidth))
            return this;
        String nkey = getKey() +"_"+ DERIVAT_SCALE+"_"+scaleWidth+"x"+scaleHeight;


        ImageCacheItem item;
        item = ImageCache.getImageCache().getImageCacheByKey(nkey);
        if (item != null) return item;

        item = new ImageCacheItem();
        item.key = nkey;
        item.sourcePath = de.malban.util.UtilityString.cleanFileString(sourcePath);
        item.scaleHeight=scaleWidth;
        item.scaleWidth=scaleHeight;
        item.derivatFrom = UID;
        item.bimage = de.malban.util.UtilityImage.toBufferedImage(de.malban.util.UtilityImage.imageScale(bimage, scaleWidth, scaleHeight));
        derivateUIDs.add(item.UID);
        ImageCache.getImageCache().addItem(item);
        return item;
    }

    protected ImageCacheItem getDerivatOpaque(int o)
    {
        String nkey = getKey() +"_"+ DERIVAT_OPAQUE+"_"+o;
        ImageCacheItem item;
        item = ImageCache.getImageCache().getImageCacheByKey(nkey);
        if (item != null) return item;

        item = new ImageCacheItem();
        item.key = nkey;
        item.opacity = o;
        item.sourcePath = de.malban.util.UtilityString.cleanFileString(sourcePath);
        item.derivatFrom = UID;
        OpacityFilter filter = new OpacityFilter(o);
        item.bimage = filter.filter(bimage, null);

        derivateUIDs.add(item.UID);
        ImageCache.getImageCache().addItem(item);
        return item;
    }

    protected ImageCacheItem getDerivatSubImage(int x, int y, int w, int h)
    {
        String nkey = getKey() +"_"+ DERIVAT_SUB+"_"+x+","+y+","+w+","+h;
        ImageCacheItem item;
        item = ImageCache.getImageCache().getImageCacheByKey(nkey);
        if (item != null) return item;

        item = new ImageCacheItem();
        item.key = nkey;
        item.sourcePath = de.malban.util.UtilityString.cleanFileString(sourcePath);

        item.subX=x;
        item.subY=y;
        item.subWidth=w;
        item.subHeight=h;

        item.derivatFrom = UID;
        item.bimage = bimage.getSubimage(x, y, w, h);
        derivateUIDs.add(item.UID);

        ImageCache.getImageCache().addItem(item);
        return item;
    }

    /** Angle in degrees from 0 to 360
     *
     * @param sourceImage
     * @param angle
     * @return
     */
    protected ImageCacheItem getDerivatRotate(double a)
    {
        return getDerivatRotate(a, false);
    }

    protected ImageCacheItem getDerivatRotate(double a, boolean ks)
    {
        String nkey = getKey() +"_"+ DERIVAT_ROTATE+"_"+a+"_"+ks;
        ImageCacheItem item;
        item = ImageCache.getImageCache().getImageCacheByKey(nkey);
        if (item != null) return item;

        item = new ImageCacheItem();
        item.keepSize = ks;
        item.key = nkey;
        item.sourcePath = de.malban.util.UtilityString.cleanFileString(sourcePath);
        item.angle=a;
        item.derivatFrom = UID;

        int size;
        int h = bimage.getHeight();
        int w = bimage.getWidth();
        if (h>w) size = h; else size=w;
        int bigSize = (int) (Math.sqrt(((double)2*(size*size))) +0.999);
        size=bigSize;

        int sizeW = size;
        int sizeH = size;
        if (ks)
        {
            sizeW = w;
            sizeH = h;
            /*
            if ((item.angle == 90) || (item.angle == 270))
            {
                sizeW = h;
                sizeH = w;
            }
            */
        }

        int type =  BufferedImage.TYPE_INT_ARGB;

        BufferedImage orgImg;
        Graphics2D go;
        if (!ks)
        {
            orgImg = new BufferedImage(sizeW, sizeH, type);
            go = orgImg.createGraphics();
            go.drawImage( bimage, (sizeW-w)/2, (sizeH-h)/2,bimage.getWidth(), bimage.getHeight(), null);
        }
        else
        {
            orgImg = new BufferedImage(w, h, type);
            go = orgImg.createGraphics();
            go.drawImage( bimage, 0, 0,bimage.getWidth(), bimage.getHeight(), null);
        }

        BufferedImage dimg = new BufferedImage(sizeW, sizeH, type);
        Graphics2D g = dimg.createGraphics();
        double sw = sizeW;
        double sh = sizeH;

        g.rotate(Math.toRadians(item.angle), sw/2, sh/2);

        g.drawImage(orgImg, null, 0, 0);
        item.bimage = dimg;

        derivateUIDs.add(item.UID);
        ImageCache.getImageCache().addItem(item);
        return item;
    }
    protected ImageCacheItem getDerivatMirror(boolean isVerticalMirror)
    {
        String nkey = getKey() +"_"+ DERIVAT_HMIRROR;
        if (isVerticalMirror)
            nkey = getKey() +"_"+ DERIVAT_VMIRROR;

        ImageCacheItem item;
        item = ImageCache.getImageCache().getImageCacheByKey(nkey);
        if (item != null) return item;

        item = new ImageCacheItem();
        item.key = nkey;
        item.sourcePath = de.malban.util.UtilityString.cleanFileString(sourcePath);
        item.vMirror=isVerticalMirror;
        item.hMirror=!isVerticalMirror;
        item.derivatFrom = UID;



        int w = bimage.getWidth();
        int h = bimage.getHeight();

        if (!isVerticalMirror)
        {
            BufferedImage dimg = new BufferedImage(w, h, bimage.getType());
            Graphics2D g = dimg.createGraphics();
            g.drawImage(bimage, 0, 0, w, h, w, 0, 0, h, null);
            g.dispose();
            item.bimage = dimg;
        }
        else
        {
            BufferedImage dimg = new BufferedImage(w, h, bimage.getType());
            Graphics2D g = dimg.createGraphics();
            g.drawImage(bimage, 0, 0, w, h, 0, h, w, 0, null);
            g.dispose();
            item.bimage = dimg;
        }


        derivateUIDs.add(item.UID);
        ImageCache.getImageCache().addItem(item);
        return item;
    }

    public ImageCacheItem getDerivatCanvasResize(int w, int h)
    {
        String nkey = getKey() +"_"+ DERIVAT_RESIZE+"_"+w+","+h;
        ImageCacheItem item;
        item = ImageCache.getImageCache().getImageCacheByKey(nkey);
        if (item != null) return item;

        item = new ImageCacheItem();
        item.key = nkey;
        item.sourcePath = de.malban.util.UtilityString.cleanFileString(sourcePath);

        item.resizeHeight=h;
        item.resizeWidth=w;
        item.derivatFrom = UID;

        int oldW = bimage.getWidth();
        int oldH = bimage.getHeight();

        int offX = (w-oldW)/2;
        int offY = (h-oldH)/2;

        int type = BufferedImage.TYPE_INT_ARGB;
        BufferedImage dimg = new BufferedImage(w, h, type);
        Graphics2D g = dimg.createGraphics();
        g.drawImage(bimage, null, offX, offY);
        item.bimage = dimg;

        derivateUIDs.add(item.UID);
        ImageCache.getImageCache().addItem(item);
        return item;
    }
    
    public ImageCacheItem getDerivatRGB(float r, float g, float b)
    {
        String nkey = getKey() +"_"+ DERIVAT_RGB+"_"+r+","+g+","+b;
        ImageCacheItem item;
        item = ImageCache.getImageCache().getImageCacheByKey(nkey);
        if (item != null) return item;

        item = new ImageCacheItem();
        item.key = nkey;
        item.sourcePath = de.malban.util.UtilityString.cleanFileString(sourcePath);
        
        item.rFactor=r;
        item.gFactor=g;
        item.bFactor=b;
        
        item.derivatFrom = UID;

        RGBAdjustFilter filter = new RGBAdjustFilter(r,g,b);
        item.bimage = filter.filter(bimage, null);

        derivateUIDs.add(item.UID);
        ImageCache.getImageCache().addItem(item);
        return item;        
    }
    public ImageCacheItem getDerivatHSB(float h, float s, float b)
    {
        String nkey = getKey() +"_"+ DERIVAT_HSB+"_"+h+","+s+","+b;
        ImageCacheItem item;
        item = ImageCache.getImageCache().getImageCacheByKey(nkey);
        if (item != null) return item;

        item = new ImageCacheItem();
        item.key = nkey;
        item.sourcePath = de.malban.util.UtilityString.cleanFileString(sourcePath);
        
        item.h_Factor=h;
        item.s_Factor=s;
        item.b_Factor=b;
        
        item.derivatFrom = UID;

        HSBAdjustFilter filter = new HSBAdjustFilter(h,s,b);
        item.bimage = filter.filter(bimage, null);

        derivateUIDs.add(item.UID);
        ImageCache.getImageCache().addItem(item);
        return item;        
    }    
    public void invalidateDerivates()
    {
        for (int i=0; i<derivateUIDs.size(); i++)
        {
            ImageCacheItem item = ImageCache.getImageCache().getImageCacheByUID(derivateUIDs.get(i));
            ImageCache.getImageCache().removeItem(item);
        }
        derivateUIDs.clear();
    }

}
