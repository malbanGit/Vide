/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.config.theme;

import java.awt.Image;
import java.io.File;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

/**
 *
 * @author malban
 */
public class Theme 
{
    public static final String THEME_BASE_PATH = "theme"+File.separator;
    String themeDir = THEME_BASE_PATH+"default";
    boolean isDefault = true;
    String mName = "default";
    ThemeData data = null;

    public static HashMap<String, Theme> allThemes = null;
    static
    {
        allThemes = new HashMap<String, Theme>();
        allThemes.put("default", new Theme());
    }

    public static void resetAllData()
    {
        Set entries = allThemes.entrySet();
        Iterator it = entries.iterator();
        while (it.hasNext())
        {
            Map.Entry entry = (Map.Entry) it.next();
            Theme value = (Theme) entry.getValue();
            value.data = null;
        }

    }

    private Theme(String name)
    {
        if (!name.equals("default")) isDefault = false;
        themeDir = THEME_BASE_PATH+name;
        mName = name;
    }
    private Theme()
    {
    }
    public ThemeData getData()
    {
        if (data==null)
        {
            ThemeDataPool mThemeDataPool = new ThemeDataPool(".."+File.separator+"theme"+File.separator+mName+File.separator+"Theme.xml");
            Collection<ThemeData> colC = mThemeDataPool.getMapForKlasse("Themes").values();
            Iterator<ThemeData> iterC = colC.iterator();

            while (iterC.hasNext())
            {
                ThemeData item = iterC.next();
                if (item.mName.equals(mName))
                {
                    data = mThemeDataPool.get(item.mName);
                }
            }
            if (data == null) data = new ThemeData();
        }
        return data;
    }

    public static Theme getThemeInstance(String name)
    {
        Theme t = allThemes.get(name);
        if (t == null)
        {
            t = new Theme(name);
            allThemes.put(name, t);
        }
        return t;
    }
    private static Image loadOneImage(String name)
    {
        java.awt.Image dImage = null;

        File file =new java.io.File(name);
        if (file.exists())
        {
            dImage =java.awt.Toolkit.getDefaultToolkit().createImage(name);
            java.awt.MediaTracker tracker = new java.awt.MediaTracker(de.malban.Global.mMainWindow);
            tracker.addImage(dImage, 1);

            boolean interrupt = false;
            do
            {
                try
                {
                    interrupt = false;
                    tracker.waitForAll();
                } catch (InterruptedException e)
                {
                    interrupt=true;
                    System.out.println("Error loading images!");
                    e.printStackTrace();
                    dImage=null;
                //    return false;
            }} while (interrupt);
        }
        return dImage;
    }
    
    /** Included seperator 
     * 
     * @return 
     */
    public String getCurrentThemePath()
    {
        String name =  themeDir+java.io.File.separator;
        return name;
    }

    public String getBackImagePath()
    {
        String name =  themeDir+java.io.File.separator+"Back.png";
        File f = new File (name);
        if (!isDefault)
            if (!f.exists()) return getThemeInstance("default").getBackImagePath();
        return name;
    }
    
    public String getTitleImagePath()
    {
        String name =  themeDir+java.io.File.separator+"Title.png";
        File f = new File (name);
        if (!isDefault)
            if (!f.exists()) return getThemeInstance("default").getTitleImagePath();
        return name;
    }
    
    public Image getTitleImage()
    {
        String name = getTitleImagePath();
        Image i = loadOneImage(name);
        if ((i == null) &&  (!isDefault)) return getThemeInstance("default").getTitleImage();
        return i;
    }
    public Image getBackImage()
    {
        String name =  getBackImagePath();
        Image i = loadOneImage(name);
        if ((i == null) &&  (!isDefault)) return getThemeInstance("default").getBackImage();
        return i;
    }
    
    public String getImagePath(String in)
    {
        String name =  themeDir+java.io.File.separator+in;
        File f = new File (name);
        if (!isDefault)
            if (!f.exists()) return getThemeInstance("default").getImagePath(in);
        
        return name;
    }

    public Image getImage(String in)
    {
        String name =  getImagePath(in);
        Image i = loadOneImage(name);
        if ((i == null) &&  (!isDefault)) return getThemeInstance("default").getImage(in);
        return i;
    }
    
    public String getGameImagePath()
    {
        String name =  getData().mGameImage;
        File f = new File (name);
        if (!isDefault)
            if (!f.exists())
                return getThemeInstance("default").getGameImagePath();
        return name;
    }
    
    public Image getGameImage()
    {
        String name = getTitleImagePath();
        Image i = loadOneImage(name);
        if ((i == null) &&  (!isDefault)) return getThemeInstance("default").getGameImage();
        return i;
    }
}
