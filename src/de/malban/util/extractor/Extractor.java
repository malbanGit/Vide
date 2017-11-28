package de.malban.util.extractor;

import de.malban.Global;
import de.malban.VideMain;
import de.malban.config.Configuration;
import de.malban.gui.panels.LogPanel;
import static de.malban.gui.panels.LogPanel.WARN;
import de.malban.util.DownloaderPanel;
import de.malban.vide.VideConfig;
import java.awt.Image;
import java.io.File;
import java.io.InputStream;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.net.URL;
import java.net.URLClassLoader;
import javax.imageio.ImageIO;


/**
 *
 * @author malban
 */
public class Extractor{

   public static boolean testChassisFromPara()
   {
       VideConfig config = VideConfig.getConfig();
       if (!chassisMustLoad()) return config.CHASSIS_AVAILABLE==1;
       LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
       try
       {
            startDataDir();
            if (!ensureParaAvailable()) 
            {
                endDataDir();
                config.CHASSIS_AVAILABLE=-1;
                return config.CHASSIS_AVAILABLE==1;
            }
            if (!extractPara())
            {
                endDataDir();
                config.CHASSIS_AVAILABLE=-1;
                return config.CHASSIS_AVAILABLE==1;
            }
            
            for (int i=0; i<loadImages.length/2; i++)
            {
                String from = loadImages[i*2];
                String to = de.malban.util.UtilityFiles.convertSeperator(loadImages[i*2+1]);
                InputStream is = getParaImageInputStream(from);
                if (is == null)
                {
                    log.addLog(from+" could not be imported", WARN);
                    config.CHASSIS_AVAILABLE=-1;
                    continue;
                }
                Image image = ImageIO.read(is);
                // the "cast" to buffered ensures the right ARGB format
                ImageIO.write(de.malban.util.UtilityImage.toBufferedImage(image), "png", new File(to));           
            }
            
            
       }
       catch (Throwable ex)
       {
            log.addLog(ex, WARN);
            config.CHASSIS_AVAILABLE=-1;
            endDataDir();
            return config.CHASSIS_AVAILABLE==1;
       }
       endDataDir();
       config.CHASSIS_AVAILABLE=1;
        return config.CHASSIS_AVAILABLE==1;
   }
  
    // see: https://stackoverflow.com/questions/1010919/adding-files-to-java-classpath-at-runtime
    private static void addSoftwareLibrary(File file) throws Exception 
    {
        Method method = URLClassLoader.class.getDeclaredMethod("addURL", new Class[]{URL.class});
        method.setAccessible(true);
        method.invoke(ClassLoader.getSystemClassLoader(), new Object[]{file.toURI().toURL()});
    }  

    // needs "ParaJVE_0.7.0_windows.zip" in tmp directory
    // unzips 
    public static boolean extractPara()
    {
        LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
        try
        {
          String name = Global.mainPathPrefix+"tmp"+File.separator+"ParaJVE_0.7.0_windows.zip";
          de.malban.util.UtilityFiles.unzip(name, Global.mainPathPrefix+"tmp"+File.separator+"tmp1");
          String packPath = Global.mainPathPrefix+"tmp"+File.separator+"tmp1"+File.separator+"ParaJVE"+File.separator+"data"+File.separator+"packs"+File.separator+"chassis.jvepak";
          String unpackPath = "data"+File.separator+"packs"+File.separator+"chassis.jvepak";
          de.malban.util.UtilityFiles.copyOneFile(packPath, unpackPath);

          packPath = Global.mainPathPrefix+"tmp"+File.separator+"tmp1"+File.separator+"ParaJVE"+File.separator+"libs"+File.separator+"ParaJVE.jar";
          unpackPath = Global.mainPathPrefix+"lib"+File.separator+"ParaJVE.jar";
          de.malban.util.UtilityFiles.copyOneFile(packPath, unpackPath);
          addSoftwareLibrary(new File(unpackPath));
          de.malban.util.UtilityFiles.deleteDirectoryRecursive(Global.mainPathPrefix+"tmp"+File.separator+"tmp1");
        }
        catch (Throwable ex)
        {
            log.addLog(ex, WARN);
            return false;
        }
        return true;
    }
  
   static boolean dataDirExisted;
   static boolean packDirExisted;
   static boolean chassisExisted;
   static boolean paraExisted;
   static boolean zipExisted;
   
   
   private static void startDataDir()
   {
       File f = new File (Global.mainPathPrefix+"data");
       dataDirExisted = f.exists();
       if (!dataDirExisted)
           f.mkdir();

       f = new File (Global.mainPathPrefix+"data"+File.separator+"packs");
       packDirExisted = f.exists();
       if (!packDirExisted)
           f.mkdir();

       f = new File (Global.mainPathPrefix+"data"+File.separator+"packs"+File.separator+"chassis.jvepak");
       chassisExisted = f.exists();
       
       f = new File (Global.mainPathPrefix+"lib"+File.separator+"ParaJVE.jar");
       paraExisted = f.exists();
       
       f = new File (Global.mainPathPrefix+"tmp"+File.separator+"ParaJVE_0.7.0_windows.zip");
       zipExisted = f.exists();
   }

   private static void endDataDir()
   {
               
       if (!zipExisted)
       {
            File f = new File (Global.mainPathPrefix+"tmp"+File.separator+"ParaJVE_0.7.0_windows.zip");
            f.delete();
       }
       if (!paraExisted)
       {
            File f = new File (Global.mainPathPrefix+"lib"+File.separator+"ParaJVE.jar");
            f.delete();
       }
       if (!chassisExisted)
       {
            File f = new File (Global.mainPathPrefix+"data"+File.separator+"packs"+File.separator+"chassis.jvepak");
            f.delete();
       }
       if (!packDirExisted)
       {
            File f = new File (Global.mainPathPrefix+"data"+File.separator+"packs");
            f.delete();
       }
       if (!dataDirExisted)
       {
            File f = new File (Global.mainPathPrefix+"data");
            f.delete();
       }
   }
   
   // return null if some error
   private static InputStream getParaImageInputStream(String imageName)
   {
        LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
        InputStream is = null;
        // doing this via class loader circumvents having ParaJVE jar 
        // within netbeans all the time
        ClassLoader classLoader = VideMain.class.getClassLoader();
        try 
        {
            Class JoglContextClass = classLoader.loadClass("frc.emul.vectrex.ui.opengl.JoglContext");
            Object joglcontext = JoglContextClass.newInstance();
            Field kindField = JoglContextClass.getField("KIND_CHS");
            Object kind = kindField.get(joglcontext);

            Class texLoaderClass = classLoader.loadClass("frc.emul.tools.data.TexLoader");
            Method method = texLoaderClass.getMethod("getResourceStream", new Class[]{String.class, Object.class});
            Object isObject = method.invoke(null, imageName, kind);

            is = (InputStream)isObject;

        } 
        catch (Throwable ex) 
        {
            log.addLog(ex, WARN);
            return null;
        }       
        return is;
   }
   
   // input - output
   static String[] loadImages =
   {
        Global.mainPathPrefix+"data/packs/chassis_holders_top.png", Global.mainPathPrefix+"theme/images/chassis_holders_top.png",
        Global.mainPathPrefix+"data/packs/chassis_holders_bottom.png", Global.mainPathPrefix+"theme/images/chassis_holders_bottom.png",
        Global.mainPathPrefix+"data/packs/chassis_cartridge.png", Global.mainPathPrefix+"theme/images/chassis_cartridge.png",
        Global.mainPathPrefix+"data/packs/chassis_screen.png", Global.mainPathPrefix+"theme/images/chassis_screen.png",
        Global.mainPathPrefix+"data/packs/chassis_frame.png", Global.mainPathPrefix+"theme/images/chassis_frame.png",
        Global.mainPathPrefix+"data/packs/chassis_cable_port1.png", Global.mainPathPrefix+"theme/images/chassis_cable_port1.png",
        Global.mainPathPrefix+"data/packs/chassis_cable_port2.png", Global.mainPathPrefix+"theme/images/chassis_cable_port2.png",
        Global.mainPathPrefix+"data/packs/chassis_joystick_panel.png", Global.mainPathPrefix+"theme/images/chassis_joystick_panel.png"
   };
          
   private static boolean ensureParaAvailable()
   {
        return DownloaderPanel.saveUrlInternal("http://vectrex.malban.de/ParaJVE_0.7.0_windows.zip", Global.mainPathPrefix+"tmp"+File.separator+"ParaJVE_0.7.0_windows.zip")!=null;
   }

    private static boolean chassisMustLoad()
    {
        //public static int CHASSIS_AVAILABLE = 0; // 0 not tried, 1 = yes, -1 no and have tried
        VideConfig config = VideConfig.getConfig();
        if (config.CHASSIS_AVAILABLE==1) return false;
        if (config.CHASSIS_AVAILABLE==-1) return false;
        // testing only one example file
        File chassis = new File(de.malban.util.UtilityFiles.convertSeperator(Global.mainPathPrefix+"theme/images/chassis_screen.png"));
        if (chassis.exists())
        {
            config.CHASSIS_AVAILABLE=1;
            return false;
        }
        return true;
    }

}
   