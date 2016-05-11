/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.gui;

import java.util.HashMap;

/**
 *
 * @author Malban
 */
public class Scaler 
{
    // this is not efficient, and might be removed later on
    // for now I want a central point where I do all the scaling
    // so the scaling is the same wherever I need it!
    
    public static boolean overlappedScaling = true;
    static boolean USE_CACHE = false;
    
    // cashing results insures proper mapping of scale and unscale
    // sadly output makes no difference :-(
    
    static HashMap<String, Float> scaleFloat;    
    static HashMap<String, Float> unscaleFloat;    
    static
    {
        if (USE_CACHE)
        {
            scaleFloat = new HashMap<String, Float>();    
            unscaleFloat = new HashMap<String, Float>();    
        }
    }
    
    // returns X as in: 
    // orgSize * X = scaledSize
    public static double getScaleFactor(int orgSize, int scaledSize)
    {
        double _DOrgSize = orgSize;
        double _DScaledSize = scaledSize;
        
        return _DScaledSize/_DOrgSize;
    }
    
    
    // scale in percent 1-100
    public static int scalePercentToInt(int value, int scale)
    {
        return scaleFloatToInt(value, (float)( ((float) scale)/((float)100)) );
    }
    // scale in percent 1-100
    public static double scalePercentToDouble(double value, double scaleInPercent)
    {
        
        return scaleDoubleToDouble(value, ( ( scaleInPercent)/((double)100)) );
    }
    
    // scale in double 0.1 - 1.0
    public static int scaleDoubleToInt(int value, double scale)
    {
        return (int) scaleFloatToInt(value, (float) scale);
    }
    public static int scaleDoubleToInt(double value, double scale)
    {
        return (int) scaleDoubleToDouble(value, scale);
    }
    
    // scale in float 0.1 - 1.0
    public static int scaleFloatToInt(int value, float scale)
    {
        
        //System.out.println("Float: "+scaleFloatToFloat(((float)value),scale)+" Int:"+(int) Math.round( scaleFloatToFloat(((float)value),scale)) );
        //return roundUp(scaleFloatToFloat(((float)value),scale)) ;
        return (int) Math.round( scaleFloatToFloat(((float)value),scale));
    }
    static int roundUp(float n)
    {
        if (n != ((float)((int)n)))
        {
            if (n<0)
            {
                return Math.round(n);
            }
            return ((int)n)+1;
        }
        return (int) n;
    }
    
    public static float scalePercentToFloat(int value, int scale)
    {
        return scaleFloatToFloat((float)(value), (float)( ((float) scale)/((float)100)) );
    }
    
    // scale in float 0.1 - 1.0
    public static float scaleFloatToFloat(float value, float scale)
    {
        if (USE_CACHE)
        {
            String key = ""+value+"_"+scale;
            Float result = scaleFloat.get(key);
            if (result == null)
            {
                result = value*scale;
                scaleFloat.put(key, result);
                String key2 = ""+result+"_"+scale;
                unscaleFloat.put(key2, value);
            }
            return result;        
            
        }
        return value*scale;
    }    
    // scale in float 0.1 - 1.0
    public static double scaleDoubleToDouble(double value, double scale)
    {
        return value*scale;
    }      
    
    // scale in percent 1-100
    public static int unscalePercentToInt(int value, int scale)
    {
        return unscaleFloatToInt(value, (float)( ((float) scale)/((float)100)));
    }
    
    // scale in double 0.1 - 1.0
    public static int unscaleDoubleToInt(int value, double scale)
    {
        return (int) unscaleFloatToInt(value, (float) scale);
    }
    // scale in float 0.1 - 1.0
    public static int unscaleFloatToInt(int value, float scale)
    {
        return Math.round(unscaleFloatToFloat( value,scale));
        //return roundUp(unscaleFloatToFloat( value,scale));
    }

    // scale in double 0.1 - 1.0
    public static double unscaleDoubleToDouble(int value, double scale)
    {
        return (double) unscaleFloatToFloat(value, (float) scale);
    }
    // scale in double 0.1 - 1.0
    public static double unscaleDoubleToDouble(double value, double scale)
    {
        return (value/scale);
    }
    
    // scale in float 0.1 - 1.0
    public static float unscaleFloatToFloat(int value, float scale)
    {
        if (USE_CACHE)
        {
            String key = ""+value+"_"+scale;
            Float result = unscaleFloat.get(key);
            if (result == null)
            {
                result = (((float)value)/scale);
                unscaleFloat.put(key, result);

                String key2 = ""+result+"_"+scale;
                scaleFloat.put(key2, (float)value);
            }
            return result;        
        }
        return (((float)value)/scale);
    }
}
