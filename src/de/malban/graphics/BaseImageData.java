/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package de.malban.graphics;

import de.malban.gui.ImageCache;
import de.malban.gui.Scaler;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.util.Collections;
import java.util.Comparator;
import java.util.Vector;
import javax.swing.JPanel;

/**
 *
 * @author malban
 * This class holds information regarding ONE image. [One image as one image of an animation]
 * 
 * This class also supplies methods to load an image into it, scales image and handle offsets (of different kinds)
 * It provides methods to load images from ImageSequenceData (into a Vector of BaseImageData) and to gather data from BaseImageData to ImageSequence Data.
 * 
 * It supplies also methods to crop and "optimize" images in regard to its parent "spritesheet"
 */
public class BaseImageData {

    //String key="";
    String fileName=""; // name of the image file it was loaded from
    public int xOrg=0; // position in image from filename
    public int yOrg=0;
    public int x=0;    // position in current image (see below)
    public int y=0;
    public int w=0;    // width 
    public int h=0;    // height
    public int cx=0;   // position of image in parent if crop was done -> X
    public int cy=0;   // position of image in parent if crop was done -> Y
    public int cw=0;   // width of image in parent if crop was done 
    public int ch=0;   // height of image in parent if crop was done 
    public int pos = 0; // position of this image in a sequence

    public int ox = 0;  // offset to "original" position if image was cropped - X
    public int oy = 0;  // offset to "original" position if image was cropped - Y

    public boolean randomAnim = false; // is the sequence randomly initialized?
    public BufferedImage image = null; // data of the image itself
    
    public String notice = ""; // copyright notice
    JPanel cpanel = null; // if the image is displayed -> this is the panel it is displayed in. needed to provide update information if image changed

    // copy uses SAME image
    BaseImageData copy()
    {
        BaseImageData newBase = new BaseImageData();
        newBase.fileName = this.fileName;
        newBase.xOrg = this.xOrg;
        newBase.yOrg = this.yOrg;
        newBase.x = this.x;
        newBase.y = this.y;
        newBase.w = this.w;
        newBase.h = this.h;
        newBase.cx = this.cx;
        newBase.cy = this.cy;
        newBase.cw = this.cw;
        newBase.ch = this.ch;
        newBase.pos = this.pos;
        
        newBase.randomAnim = this.randomAnim;
        newBase.image = this.image;
        newBase.notice = this.notice;
        newBase.cpanel = null;
        return newBase;
    }
    
    // clone also clones the image data
    @Override
    public BaseImageData clone()
    {
        BaseImageData newBase = copy();
        newBase.image = de.malban.util.UtilityImage.copyImage(this.image);

        return newBase;
    }

    public static Vector<BaseImageData> toBase(ImageSequenceData iData)
    {
        return toBase(iData, 1);
    }

    public static Dimension getUnscaledMaxDimensions(ImageSequenceData iData)
    {
        int maxW=0;
        int maxH=0;

        for (int i = 0; i < iData.mHeight.size(); i++)
        {
            int h = iData.mHeight.elementAt(i);
            int w = iData.mWidth.elementAt(i);
            if (iData.moptimzeCropOffsetX.size()>i)
            {
                w += iData.moptimzeCropOffsetX.elementAt(i);
                h += iData.moptimzeCropOffsetY.elementAt(i);
            }
            if (w>maxW) maxW=w;
            if (h>maxH) maxH=h;
        }
        return new Dimension(maxW,maxH);
    }
    
    // scalePercent 1-100
    public static Vector<BaseImageData> toBasePercent(ImageSequenceData iData, int scalePercent, int fixed100Width, int fixed100Height, boolean shadow)
    {
        return toBase( iData,  (float) ((float)scalePercent/(float)100.0),  fixed100Width,  fixed100Height, shadow);
    }
    public static Vector<BaseImageData> toBasePercent(ImageSequenceData iData, int scalePercent, int fixed100Width, int fixed100Height)
    {
        return toBase( iData,  (float) ((float)scalePercent/(float)100.0),  fixed100Width,  fixed100Height, false);
    }
    // scalePercent 1-100
    public static Vector<BaseImageData> toBasePercent(ImageSequenceData iData, int scalePercent)
    {
        return toBasePercent(iData, scalePercent, false);
    }
    public static Vector<BaseImageData> toBasePercent(ImageSequenceData iData, int scalePercent, boolean shadow)
    {
        Dimension unscaledSize = getUnscaledMaxDimensions(iData);
        return toBasePercent(iData, scalePercent, unscaledSize.width, unscaledSize.height, shadow);
    }
    // scale 0.0 - 1.0
    public static Vector<BaseImageData> toBase(ImageSequenceData iData, double scale)
    {
        return toBase(iData, scale, false);
    }
    // scale 0.0 - 1.0
    public static Vector<BaseImageData> toBase(ImageSequenceData iData, double scale, boolean shadow)
    {
        Dimension unscaledSize = getUnscaledMaxDimensions(iData);
        return toBase(iData, scale, unscaledSize.width, unscaledSize.height, shadow);
    }
    // scale 0.0 - 1.0
    public static Vector<BaseImageData> toBase(ImageSequenceData iData, double scale, int fixed100Width, int fixed100Height)
    {
        return toBase(iData, scale, fixed100Width, fixed100Height, false);
    }
    public static Vector<BaseImageData> toBase(ImageSequenceData iData, double scale, int fixed100Width, int fixed100Height, boolean shadow)
    {
        return toBase( iData, (float)scale,  fixed100Width,  fixed100Height, shadow);
    }
    // scale 0.0 - 1.0
    public static Vector<BaseImageData> toBase(ImageSequenceData iData, float scale, int fixed100Width, int fixed100Height)
    {
        return toBase(iData, scale, fixed100Width, fixed100Height, false);
    }
    public static synchronized Vector<BaseImageData> toBase(ImageSequenceData iData, float scale, int fixed100Width, int fixed100Height, boolean shadow)
    {
        BufferedImage lastBim;
        Vector<BaseImageData> bases = new Vector<BaseImageData>();

        // each image of an animation can have a different size
        // in order to do a correct scaling for the complete animation
        // we must do the scaling in respect to the
        // max size!
        //for fixed scalings the correct scaling is the max width == force!
        Dimension unscaledSize = getUnscaledMaxDimensions(iData);

        for (int i = 0; i < iData.mHeight.size(); i++)
        {
            BaseImageData d = new BaseImageData();
            d.h = iData.mHeight.elementAt(i);
            d.w = iData.mWidth.elementAt(i);
            d.x = iData.mXPos.elementAt(i);
            d.y = iData.mYPos.elementAt(i);
            d.xOrg = d.x;
            d.yOrg = d.y;
            
            if (iData.mCropHeight.size()>i)
            {
                d.ch = iData.mCropHeight.elementAt(i);
                d.cw = iData.mCropWidth.elementAt(i);
                d.cx = iData.mCropXPos.elementAt(i);
                d.cy = iData.mCropYPos.elementAt(i);
            }
            else
            {
                d.ch = d.h;
                d.cw = d.w;
                d.cx = 0;
                d.cy = 0;
            }
            if (iData.moptimzeCropOffsetX.size()>i)
            {
                d.ox = iData.moptimzeCropOffsetX.elementAt(i);
                d.oy = iData.moptimzeCropOffsetY.elementAt(i);
            }
            else
            {
                d.ox = 0;
                d.oy = 0;
            }
            d.pos = iData.mPosition.elementAt(i);
            d.fileName = iData.mImageSourceFile.elementAt(i);
            d.notice = iData.mOriginNotice;
            d.randomAnim = iData.mRandomAnimationStart;

            lastBim = ImageCache.getImageCache().getImage(d.fileName);
            ImageCache.getImageCache().canBeInvalidated(lastBim);
            d.image = ImageCache.getImageCache().getDerivatSubImage(lastBim, d.x, d.y, d.w, d.h);
            
            // scaling to 100%
            float scaleX = Scaler.unscaleFloatToFloat(fixed100Width,((float)(unscaledSize.width)) );
            float scaleY = Scaler.unscaleFloatToFloat(fixed100Height,((float)(unscaledSize.height)) );
            
            // downscale with given scaling!
            scaleX = Scaler.scaleFloatToFloat(scaleX, scale);
            scaleY = Scaler.scaleFloatToFloat(scaleY, scale);

            // round scaling up
            int newWidth = Scaler.scaleFloatToInt(d.w, scaleX);
            int newHeight = Scaler.scaleFloatToInt(d.h, scaleY);
            
            // these additional pixel eliminate to a large degree
            // scaling artifacts!
            if (scaleX != 1.0)
            {
                if (Scaler.overlappedScaling)
                {
                    newWidth+=1;
                    newHeight+=1;
                    if (scaleX<0.6)newWidth+=1;
                    if (scaleY<0.6)newHeight+=1;
                    if (scaleX<0.3)newWidth+=1;
                    if (scaleY<0.3)newHeight+=1;
                }

                d.image = ImageCache.getImageCache().getDerivatScale(d.image, newWidth, newHeight);
            }
            d.x = 0;
            d.y = 0;
            d.w = newWidth;
            d.h = newHeight;
            d.ch = (int)(d.ch*scaleY);
            d.cw = (int)(d.cw*scaleX);
            d.cx = (int)(d.cx*scaleX);
            d.cy = (int)(d.cy*scaleY);
            d.ox = (int)(d.ox*scaleX);
            d.oy = (int)(d.oy*scaleY);
            
            if (shadow)
            {
                
                d.thickness = _thickness;
                d.antialiaseCount = _antialiaseCount;
                d.shadow_r = _shadow_r;
                d.shadow_g = _shadow_g;
                d.shadow_b = _shadow_b;
                
                d.applyShadow();
                d.wasShadowed = true;
            }
            else
            {
                d.wasShadowed = false;
            }
            bases.addElement(d);
        }

        return reorder(bases);
    }
    public void calculateCrop()
    {
        cx=0;
        cy=0;
        cw=w;
        ch=h;

        // if image is opaque, no croping can be done with alpha channels
        // y upper
        
        // hm - should have documented it by the time I programmed it... what the heck - it seems to work
        for(int y_ = 0; y_ < h; y_++)
        {
            boolean opaque = false;
            for(int x_ = 0; x_ < w; x_++)
            {
                int rgba = image.getRGB(x_, y_);
                int a = (rgba >> 24) & 0xFF;

                if (a != 0)
                {
                    opaque = true;
                    break;
                }
            }
            if (!opaque)
            {
                cy++;
                ch--;
            }
            else break;
        }

        // y lower
        for(int y_ = h-1; y_ >= 0; y_--)
        {
            boolean opaque = false;
            for(int x_ = 0; x_ < w; x_++)
            {
                int rgba = image.getRGB(x_, y_);
                int a = (rgba >> 24) & 0xFF;
                if (a != 0)
                {
                    opaque = true;
                    break;
                }
            }
            if (!opaque) ch--;
            else break;
        }


        // x upper
        for(int x_ = 0; x_ < w; x_++)
        {
            boolean opaque = false;
            for(int y_ = 0; y_ < h; y_++)
            {
                int rgba = image.getRGB(x_, y_);
                int a = (rgba >> 24) & 0xFF;
                if (a != 0)
                {
                    opaque = true;
                    break;
                }
            }
            if (!opaque)
            {
                cx++;
                cw--;
            }
            else break;
        }

        // x lower
        for(int x_ = w-1; x_ >= 0; x_--)
        {
            boolean opaque = false;
            for(int y_ = 0; y_ < h; y_++)
            {
                int rgba = image.getRGB(x_, y_);
                int a = (rgba >> 24) & 0xFF;
                if (a != 0)
                {
                    opaque = true;
                    break;
                }
            }
            if (!opaque) cw--;
            else break;
        }

    }
    public void applySimpleCrop()
    {
        x += cx;
        y += cy;
        xOrg +=  cx;
        yOrg +=  cy;

        w = cw;
        h = ch;
        cx=0;
        cy=0;
        cw=w;
        ch=h;
        ox = 0;
        oy = 0;
        
        reInitImage();
    }

    public void applyOffsetCrop()
    {
        x += cx;
        y += cy;

        xOrg +=  cx;
        yOrg +=  cy;
        
        w = cw;
        h = ch;
        ox = cx;
        oy = cy;
        cx=0;
        cy=0;
        cw=w;
        ch=h;
        reInitImage();
    }


    public static Vector<BaseImageData> reorder(Vector<BaseImageData> bases)
    {
        Collections.sort(bases, new Comparator<BaseImageData>()
        {
            @Override
           public final int compare(BaseImageData s1, BaseImageData s2)
           {
              return s1.pos-s2.pos;
           }
        });
        return bases;

    }

    public static void fromBase(ImageSequenceData iData, Vector<BaseImageData> base)
    {
        Vector<Integer> poss = new Vector<Integer>();
        Vector<Integer> heights = new Vector<Integer>();
        Vector<Integer> widths = new Vector<Integer>();
        Vector<Integer> xs = new Vector<Integer>();
        Vector<Integer> ys = new Vector<Integer>();
        Vector<Integer> cheights = new Vector<Integer>();
        Vector<Integer> cwidths = new Vector<Integer>();
        Vector<Integer> cxs = new Vector<Integer>();
        Vector<Integer> cys = new Vector<Integer>();
        Vector<Integer> oxs = new Vector<Integer>();
        Vector<Integer> oys = new Vector<Integer>();
        Vector<String> names = new Vector<String>();

        String notice="";
        boolean random=false;
        for (int i = 0; i < base.size(); i++)
        {
            BaseImageData d = base.elementAt(i);
            poss.addElement(i);
            heights.addElement(d.h);
            widths.addElement(d.w);
            xs.addElement(d.xOrg);
            ys.addElement(d.yOrg);
            cheights.addElement(d.ch);
            cwidths.addElement(d.cw);
            cxs.addElement(d.cx);
            cys.addElement(d.cy);
            oxs.addElement(d.ox);
            oys.addElement(d.oy);            
            
            names.addElement(d.fileName);
            notice = d.notice;
            random = d.randomAnim;
        }
        iData.mHeight = heights;
        iData.mWidth = widths;
        iData.mXPos = xs;
        iData.mYPos = ys;
        iData.mCropHeight = cheights;
        iData.mCropWidth = cwidths;
        iData.mCropXPos = cxs;
        iData.mCropYPos = cys;
        iData.moptimzeCropOffsetX = oxs;
        iData.moptimzeCropOffsetY = oys;

        iData.mPosition = poss;
        iData.mImageSourceFile = names;
        iData.mOriginNotice = notice;
        iData.mRandomAnimationStart = random;
    }

    synchronized void reInitImage()
    {
        if (fileName==null) return;
        if (fileName.trim().length()==0)
        {
            if ((w+x) > image.getWidth())
            {
                w = image.getWidth()-x;
            }
            if ((h+y) > image.getHeight())
            {
                h = image.getHeight()-y;
            }
            ImageCache.getImageCache().remove(fileName);
            image = ImageCache.getImageCache().getDerivatSubImage(image, x, y, w, h);
            if (wasShadowed) applyShadow();
            x=0;
            y=0;
            return;
        }

        
        ImageCache.getImageCache().remove(fileName);
        BufferedImage lastBim;

        lastBim = ImageCache.getImageCache().getImage(fileName);
        
        if ((w+xOrg) > lastBim.getWidth())
        {
            w = lastBim.getWidth()-xOrg;
        }
        if ((h+yOrg) > lastBim.getHeight())
        {
            h = lastBim.getHeight()-yOrg;
        }
        
        
        ImageCache.getImageCache().canBeInvalidated(lastBim);
        image = ImageCache.getImageCache().getDerivatSubImage(lastBim, xOrg, yOrg, w, h);
        if (wasShadowed) applyShadow();
        x=0;
        y=0;
    }
    
    
    public static int _thickness = 2;
    public static int _antialiaseCount = 3;
    public static int _shadow_r= 0;
    public static int _shadow_g= 0;
    public static int _shadow_b= 0;

    public int thickness = 2;
    public int antialiaseCount = 3;
    public int shadow_r= 0;
    public int shadow_g= 0;
    public int shadow_b= 0;
    
    boolean wasShadowed = false;
    int step = 50;//100 / thickness; 
    int[] colors;
    int shadow_a = 254;
    int shadowColor = 0;
  
    // builds a shadow around a sprite 
    // all pixels are replaced in a copy with a thick "black" pixel (radius is thickness, opaqness is
    // reduced by radius)
    // the "difference" between org and "big pixeled" is than build, this is the shadowes
    // variant. At last some antialiase is apülied to get rid of
    // ugly steps
    private void applyShadow()
    {
        //if (d!= null) return;
        // copy image
        final BufferedImage copy = new BufferedImage(image.getWidth(null), image.getHeight(null), java.awt.image.BufferedImage.TYPE_INT_ARGB);
        final Graphics2D g2 = copy.createGraphics();
        g2.drawImage(image, null, null);
        g2.dispose();

        final BufferedImage copy2 = new BufferedImage(image.getWidth(null), image.getHeight(null), java.awt.image.BufferedImage.TYPE_INT_ARGB);
        final Graphics2D g3 = copy2.createGraphics();
        g3.drawImage(image, null, null);
        g3.dispose();
        
        int _w = copy.getWidth();
        int _h = copy.getHeight();
        
        shadowColor = (shadow_r<<16)+(shadow_g<<8)+(shadow_b);
        int rgba; 
        int a;
        step = shadow_a/(thickness+1);
        colors=new int[thickness];
        int bb = shadow_a;

        for (int i=0; i< thickness; i++)
        {
            colors[i] = (bb<<24)+shadowColor;
            bb -= step;
            if (bb <0) bb = 0;
        }
        
        for (int _x=0; _x<_w; _x++)
        {
            for (int _y=0; _y<_h; _y++)
            {
                rgba =image.getRGB(_x, _y);
                a = (rgba >> 24) & 0xFF;
                if (a!=0)
                {
                    setThickPixel(copy,_w,_h, _x,_y,thickness);
                }
            }
        }
        

        for (int _x=0; _x<_w; _x++)
        {
            for (int _y=0; _y<_h; _y++)
            {
                rgba =image.getRGB(_x, _y);
                a = (rgba >> 24) & 0xFF;
                if (a==0)
                {
                    rgba =copy.getRGB(_x, _y);
                    a = (rgba >> 24) & 0xFF;
                    if (a!=0)
                    {
                        copy2.setRGB(_x, _y, rgba);
                    }
                }
            }
        }
        
        for (int i=0; i< antialiaseCount;i++)
            antialiase(copy2);
        image = copy2;
    }
    
    // sets in image a shadow pixel
    // thickness of one means in radius 1 around the pixel
    void setThickPixel(BufferedImage image, int _w,int _h, int _x, int _y, int _thickness_)
    {
        image.setRGB(_x, _y, (shadow_a<<24) + shadowColor);
        for (int yy=1;yy<_thickness_+1; yy++)
        {
            setOnePixel(image,  _w, _h,  _x,  _y-yy, colors[yy-1]);
            setOnePixel(image,  _w, _h,  _x,  _y+yy, colors[yy-1]);
            for (int xx=1;xx<_thickness_+1; xx++)
            {
                int radius = (xx+yy)/2;
                setOnePixel(image,  _w, _h,  _x-xx,  _y-yy, colors[radius-1]);
                setOnePixel(image,  _w, _h,  _x+xx,  _y-yy, colors[radius-1]);
            
                setOnePixel(image,  _w, _h,  _x-xx,  _y+yy, colors[radius-1]);
                setOnePixel(image,  _w, _h,  _x+xx,  _y+yy, colors[radius-1]);
            
                setOnePixel(image,  _w, _h,  _x-xx,  _y, colors[xx-1]);
                setOnePixel(image,  _w, _h,  _x+xx,  _y, colors[xx-1]);
            }
        }
        
        
    }
    
    // helper method that surrounds a setPixel with needed if-clauses
    void setOnePixel(BufferedImage image, int _w,int _h, int _x, int _y, int color)
    {
        if (_x<0) return ;
        if (_y<0) return ;
        if (_x>_w-1) return ;
        if (_y>_h-1) return ;

        
        int olda = (((image.getRGB(_x, _y)) >>24)&0xff);
        int newa = (color >> 24) & 0xFF;
        
        if (olda>newa) return;
        
        image.setRGB(_x, _y, color);
    }
            
    // looks for transparent "pixels" 
    // alpha of 254 is ignored, since this is the shadow which should
    // not be touched
    // pixels will be set to black with averaged alpha of surrounding pixels
    void antialiase(BufferedImage image)
    {
        int _w = image.getWidth();
        int _h = image.getHeight();
        
        int rgba; 
        int a;
        int rgb;
        
       
        for (int _x=0; _x<_w; _x++)
        {
            for (int _y=0; _y<_h; _y++)
            {
                rgba = image.getRGB(_x, _y);
                rgb = rgba & (0xffffff);
                a = (rgba >> 24) & 0xFF;
                
                
                int count =1;
                
                if (((rgb==shadowColor)|| (rgb == 0) ) && (a<254))
                {
                    int a2;
                    a2 = getAlpha(image, _w,_h,_x-1,_y-1);if (a2!=-1){count++;a+=a2;}
                    
                    a2 = getAlpha(image, _w,_h,_x,_y-1);if (a2!=-1){count++;a+=a2;}
                    a2 = getAlpha(image, _w,_h,_x+1,_y-1);if (a2!=-1){count++;a+=a2;}
                    
                    a2 = getAlpha(image, _w,_h,_x-1,_y+1);if (a2!=-1){count++;a+=a2;}
                    a2 = getAlpha(image, _w,_h,_x,_y+1);if (a2!=-1){count++;a+=a2;}
                    a2 = getAlpha(image, _w,_h,_x+1,_y+1);if (a2!=-1){count++;a+=a2;}

                    a2 = getAlpha(image, _w,_h,_x-1,_y);if (a2!=-1){count++;a+=a2;}
                    a2 = getAlpha(image, _w,_h,_x+1,_y);if (a2!=-1){count++;a+=a2;}

                    a=a/count;
                    a = a<<24;
                    image.setRGB(_x, _y, a+shadowColor);
                }
            }
        }
    }
    // -1 is none
    // helper method to wrap many if-clauses
    int getAlpha(BufferedImage image, int _w,int _h, int _x, int _y)
    {
        if (_x<0) return -1;
        if (_y<0) return -1;
        if (_x>_w-1) return -1;
        if (_y>_h-1) return -1;
        int rgba = image.getRGB(_x, _y);
        int rgb = rgba & (0xffffff);
        int a = (rgba >> 24) & 0xFF;
        if ((rgb != shadowColor) && (rgb != 0)) return -1;
        //if (a==0) return -1;
        if (a==255) return -1;
        return a;
    }
    
}


