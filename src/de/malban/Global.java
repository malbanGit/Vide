/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.ObjectOutputStream;
import java.lang.management.ManagementFactory;
import java.security.AccessController;
import java.security.PrivilegedAction;

/**
 *
 * @author Malban
 */
public class Global {
    
    // enabled so must be "-XstartOnFirstThread" upon run!
    public static final boolean LWJGL_ENABLE = false;
    
    public static final String OSNAME;
    public static final String NATIVES_PATH;
    
    public static final boolean SOLARIS;
    public static final boolean LINUX;
    public static final boolean MAC_OS_X;
    public static final boolean WINDOWS;

    
    static 
    {
        OSNAME = System.getProperty("os.name").toLowerCase();
        if (OSNAME.startsWith("mac"))
        {
          LINUX = false;
          MAC_OS_X = true;
          WINDOWS = false;
          SOLARIS = false;
        }
        else if (OSNAME.contains("windows"))
        {
          LINUX = false;
          MAC_OS_X = false;
          WINDOWS = true;
          SOLARIS = false;
        }
        else if (OSNAME.contains("sol"))
        {
          LINUX = false;
          MAC_OS_X = false;
          WINDOWS = false;
          SOLARIS = true;
        }
        else
        {
          LINUX = true;
          MAC_OS_X = false;
          WINDOWS = false;
          SOLARIS = false;
        }

        // http://www.java-gaming.org/topics/setup-natives-from-code/32484/view.html
        if (WINDOWS) NATIVES_PATH = "lib/";
        else if(MAC_OS_X)NATIVES_PATH = "lib";
        else if(LINUX)NATIVES_PATH = "lib";
        else if(SOLARIS)NATIVES_PATH = "lib";
        else NATIVES_PATH = "lib";

        // see: http://stackoverflow.com/questions/17413690/java-jinput-rescan-reload-controllers
        /**
         * Fix windows 8 warnings by defining a working plugin
         */
        AccessController.doPrivileged(new PrivilegedAction<Object>() 
        {
            public Object run() {
                String os = System.getProperty("os.name", "").trim();
                if ((os.startsWith("Windows 8")) || (os.startsWith("Windows 1"))) {  // 8, 8.1 etc.

                    // disable default plugin lookup
                    System.setProperty("jinput.useDefaultPlugin", "false");

                    // set to same as windows 7 (tested for windows 8 and 8.1)
                    System.setProperty("net.java.games.input.plugins", "net.java.games.input.DirectAndRawInputEnvironmentPlugin");

                }
                return null;
            }
        });
        
        // set native library path
        AccessController.doPrivileged(new PrivilegedAction() 
        {
            public Object run() 
            {
                System.setProperty("net.java.games.input.librarypath", new File(NATIVES_PATH).getAbsolutePath());
                return null;
            }
        });         
        
        // set native library path lwjgl
        AccessController.doPrivileged(new PrivilegedAction() 
        {
            public Object run() 
            {
                System.setProperty("org.lwjgl.librarypath", new File(NATIVES_PATH).getAbsolutePath());
                return null;
            }
        });         
    }
    
    public static String mBaseDir="xml"+java.io.File.separator;
    private static final java.util.Random _Rand = new java.util.Random();
    private static final long usedFirstSeed;
    public static javax.swing.JFrame mMainWindow=null;
    public static long nextSeed = -1;
    static 
    {
        usedFirstSeed = _Rand.nextLong();
        _Rand.setSeed(usedFirstSeed);
    }
    
    public static void setCurrentSeed(long seed)
    {
        _Rand.setSeed(seed);
    }
    
    public static long getCurrentSeed()
    {
        byte[] ba0, ba1, bar;
        try 
        {
            ByteArrayOutputStream baos = new ByteArrayOutputStream(128);
            ObjectOutputStream oos = new ObjectOutputStream(baos);
            oos.writeObject(new java.util.Random(0));
            ba0 = baos.toByteArray();
            baos = new ByteArrayOutputStream(128);
            oos = new ObjectOutputStream(baos);
            oos.writeObject(new java.util.Random(-1));
            ba1 = baos.toByteArray();
            baos = new ByteArrayOutputStream(128);
            oos = new ObjectOutputStream(baos);
            oos.writeObject(_Rand);
            bar = baos.toByteArray();
        } 
        catch (IOException e) 
        {
            throw new RuntimeException("IOException: " + e);
        }
        if (ba0.length != ba1.length || ba0.length != bar.length)
            throw new RuntimeException("bad serialized length");
        int i = 0;
        while (i < ba0.length && ba0[i] == ba1[i]) 
        {
            i++;
        }
        int j = ba0.length;
        while (j > 0 && ba0[j - 1] == ba1[j - 1]) 
        {
            j--;
        }
        if (j - i != 6)
            throw new RuntimeException("6 differing bytes not found");
        // The constant 0x5DEECE66DL is from
        // http://download.oracle.com/javase/6/docs/api/java/util/Random.html .
        return ((bar[i] & 255L) << 40 | (bar[i + 1] & 255L) << 32 |
                (bar[i + 2] & 255L) << 24 | (bar[i + 3] & 255L) << 16 |
                (bar[i + 4] & 255L) << 8 | (bar[i + 5] & 255L)) ^ 0x5DEECE66DL;
    }
    
    public static java.util.Random getRand() 
    {
        return _Rand;
    }
    
    public static String getOSName()
    {
        return ManagementFactory.getOperatingSystemMXBean().getName();
    }
    // http://stackoverflow.com/questions/1856565/how-do-you-determine-32-or-64-bit-architecture-of-windows-using-java
    // NOT foolproof
    public static int getOSBit()
    {
        boolean is64bit = false;
        if (System.getProperty("os.name").contains("Windows")) {
            is64bit = (System.getenv("ProgramFiles(x86)") != null);
        } else {
            is64bit = (System.getProperty("os.arch").indexOf("64") != -1);
        }    
        
        if (is64bit) return 64;
        return 32;
    }
}
