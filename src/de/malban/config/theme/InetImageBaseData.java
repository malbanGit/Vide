/*
 * To change this template, choose Tools | Templates and open the template in
 * the editor.
 */
package de.malban.config.theme;

import java.util.Collections;
import java.util.Comparator;
import java.util.Vector;

/**
 *
 * @author Malban
 */
public class InetImageBaseData {
    

    String url="";
    String saveName="";
    public int x=0;
    public int y=0;
    public int w=0;
    public int h=0;
    public int id = 0;

    public int scaleH = 0;
    public int scaleW = 0;
    public boolean doScale = false;
    public boolean fromMana = false;
    public boolean fromBig = false;

    InetImageBaseData copy()
    {
        InetImageBaseData newBase = new InetImageBaseData();
        newBase.h = this.h;
        newBase.w = this.w;
        newBase.x = this.x;
        newBase.y = this.y;
        newBase.id = this.id;
        newBase.url = this.url;
        newBase.saveName = this.saveName;

        newBase.scaleH = this.scaleH;
        newBase.scaleW = this.scaleW;
        newBase.doScale = this.doScale;
        
        newBase.fromMana = this.fromMana;
        newBase.fromBig = this.fromBig;

        return newBase;
    }
    public static Vector<InetImageBaseData> toBase(InetThemeData iData)
    {
        Vector<InetImageBaseData> bases = new Vector<InetImageBaseData>();
        for (int i = 0; i < iData.mHeight.size(); i++)
        {
            InetImageBaseData d = new InetImageBaseData();
            d.h = iData.mHeight.elementAt(i);
            d.w = iData.mWidth.elementAt(i);
            d.x = iData.mStartX.elementAt(i);
            d.y = iData.mStartY.elementAt(i);

            d.url = iData.mImageUrl.elementAt(i);
            d.saveName = iData.mSaveImageName.elementAt(i);

            d.scaleH = iData.mScaleHeight.elementAt(i);
            d.scaleW = iData.mScaleWidth.elementAt(i);
            d.doScale = iData.mDoScale.elementAt(i);
            d.id = de.malban.util.UtilityString.Int0(iData.mThemeID.elementAt(i));

            // new - to be compatible with old
            if (iData.mBuildFromMana.size()>i)
                d.fromMana = iData.mBuildFromMana.elementAt(i);
            // new - to be compatible with old
            if (iData.mBuildFromBig.size()>i)
                d.fromBig = iData.mBuildFromBig.elementAt(i);
            
            bases.addElement(d);
        }
        
        return reorder(bases);
    }

    public static Vector<InetImageBaseData> reorder(Vector<InetImageBaseData> bases)
    {
        Collections.sort(bases, new Comparator<InetImageBaseData>()
        {
           public final int compare(InetImageBaseData s1, InetImageBaseData s2)
           {
              return s1.id-s2.id;
           }
        });
        return bases;

    }
    public static void fromBase(InetThemeData iData, Vector<InetImageBaseData> base)
    {
        Vector<Integer> heights = new Vector<Integer>();
        Vector<Integer> widths = new Vector<Integer>();
        Vector<Integer> xs = new Vector<Integer>();
        Vector<Integer> ys = new Vector<Integer>();

        Vector<String> imageNames = new Vector<String>();
        Vector<String> urls = new Vector<String>();
        
        Vector<Integer> scaleWs = new Vector<Integer>();
        Vector<Integer> scaleHs = new Vector<Integer>();
        Vector<Boolean> doScales = new Vector<Boolean>();

        Vector<String> ids = new Vector<String>();
        Vector<Boolean> fromManas = new Vector<Boolean>();
        Vector<Boolean> fromBigs = new Vector<Boolean>();
        
       
        
        
        for (int i = 0; i < base.size(); i++)
        {
            InetImageBaseData d = base.elementAt(i);

            heights.addElement(d.h);
            widths.addElement(d.w);
            xs.addElement(d.x);
            ys.addElement(d.y);
            
            imageNames.addElement(d.saveName);
            urls.addElement(d.url);

            scaleHs.addElement(d.scaleH);
            scaleWs.addElement(d.scaleW);
            doScales.addElement(d.doScale);

            ids.addElement(""+d.id);
            fromManas.addElement(d.fromMana);
            fromBigs.addElement(d.fromBig);
            
        
        }
        iData.mHeight = heights;
        iData.mWidth = widths;
        iData.mStartX = xs;
        iData.mStartY = ys;
        
        iData.mSaveImageName = imageNames;
        iData.mImageUrl = urls;

        iData.mScaleHeight = scaleHs;
        iData.mScaleWidth = scaleWs;
        iData.mDoScale = doScales;

        iData.mThemeID = ids;
        iData.mBuildFromMana = fromManas;
        iData.mBuildFromBig = fromBigs;
    
    }
}