/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban;

import de.malban.config.Configuration;
import de.malban.config.Logable;
import de.malban.gui.CSAMainFrame;
import de.malban.gui.dialogs.ShowWarningDialog;
import de.malban.gui.panels.LogPanel;
import de.muntjak.tinylookandfeel.Theme;
import java.awt.Color;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.ObjectOutputStream;
import java.io.OutputStream;
import java.io.PrintStream;
import static java.lang.System.exit;
import java.lang.management.ManagementFactory;
import java.net.URISyntaxException;
import java.security.AccessController;
import java.security.PrivilegedAction;
import java.util.Map;
import javax.swing.JOptionPane;
import javax.swing.SwingUtilities;
import javax.swing.UIDefaults;
import javax.swing.UIManager;
import javax.swing.text.html.HTMLEditorKit;
import javax.swing.text.html.StyleSheet;




/**
 *
 * @author Malban
 */
public class Global {
    
    // enabled so must be "-XstartOnFirstThread" upon run!
    public static final boolean JOGL_ENABLE = true;
    
    public static final String OSNAME;
    public static final String NATIVES_PATH;
    
    public static final boolean SOLARIS;
    public static final boolean LINUX;
    public static final boolean MAC_OS_X;
    public static final boolean WINDOWS;

    public static boolean doTestJava = true;
    
    public static final String mainPathPrefix;
    
    //public static StringBuilder devNullString=new StringBuilder();
    public static PrintStream devNull;
    public static PrintStream devErr;
    public static PrintStream devOut;
    static 
    {
        devErr = System.err;
        devOut = System.out;
        devNull = new PrintStream(
            new OutputStream()
            {
              @Override
              public void write( int b )
              {
//                  char[] c = {(char)b};
//                  String s = new String(c);
//                  errorString.append(s);
              }
            }
          );
        Map<String, String> env = System.getenv();
        String VideHome = env.get("VIDE_HOME");
        String home = "";
        if (VideHome != null)
        {
            home = "";
            
            home = new File(de.malban.util.UtilityFiles.convertSeperator(VideHome)).getAbsolutePath();
            if (!home.endsWith(File.separator))
                home = home + File.separator;
            mainPathPrefix = home;
//            System.out.println("VIDE_HOME found end read to: "+mainPathPrefix);
        }
        else
        {
            // search current dir for "vide" sub dirs
            // if not found step one "up"
            boolean found = false;
            String currentDir = "."+File.separator;
            try
            {
            currentDir = new File(currentDir).getCanonicalPath();
            }
            catch (Throwable e) { }
            if (!currentDir.endsWith(File.separator)) currentDir = currentDir + File.separator;
            while (!found)
            {
//            System.out.println("Searching vide home in: "+currentDir);
                File t = new File(currentDir+"serialize");
                if (t.exists())
                {
                    t = new File(currentDir+"cartridges");
                    if (t.exists())
                    {
                        found = true;
                    }
                }
                if (!found)
                {
                    String oldDir=currentDir;
                    try
                    {
                    currentDir = new File(currentDir+"..").getCanonicalPath();
                    }
                    catch (Throwable e) { }
                    
                    if (!currentDir.endsWith(File.separator)) currentDir = currentDir + File.separator;
                    if (currentDir.equals(oldDir)) break;
                }
            }
            if (!found)
            {
                // scream!
                JOptionPane.showMessageDialog(null, "Vide could not find its home directory and will not run correctly!\nPlease set the environment variable VIDE_HOME!" ,"Vide problem",  JOptionPane.INFORMATION_MESSAGE);
                exit (1);
            }
            home = new File(de.malban.util.UtilityFiles.convertSeperator(currentDir)).getAbsolutePath();
            if (!home.endsWith(File.separator))
                home = home + File.separator;
            mainPathPrefix = home;
//            System.out.println("Vide determined home at: "+mainPathPrefix);
        }
        
//        mainPathPrefix = getProgramDirectory()+File.separator;
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
        if (WINDOWS) NATIVES_PATH = mainPathPrefix+"lib"+File.separator;
        else if(MAC_OS_X)NATIVES_PATH = mainPathPrefix+"lib";
        else if(LINUX)NATIVES_PATH = mainPathPrefix+"lib";
        else if(SOLARIS)NATIVES_PATH = mainPathPrefix+"lib";
        else NATIVES_PATH = mainPathPrefix+"lib";

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
        
    }
    
    public static String mBaseDir=mainPathPrefix+"xml"+java.io.File.separator;
    private static final java.util.Random _Rand = new java.util.Random();
    private static final long usedFirstSeed;
    public static CSAMainFrame /*javax.swing.JFrame*/ mMainWindow=null;
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
    
    // https://stackoverflow.com/questions/4032957/how-to-get-the-real-path-of-java-application-at-runtime
    private static String getJarName()
    {
        return new File(Global.class.getProtectionDomain()
                .getCodeSource()
                .getLocation()
                .getPath())
                .getName();
    }

    private static boolean runningFromJAR()
    {
        String jarName = getJarName();
        return jarName.contains(".jar");
    }

    public static String getProgramDirectory()
    {
        if (runningFromJAR())
        {
            return getCurrentJARDirectory();
        } else
        {
            return getCurrentProjectDirectory();
        }
    }

    private static String getCurrentProjectDirectory()
    {
        return new File("").getAbsolutePath();
    }

    private static String getCurrentJARDirectory()
    {
        try
        {
            return new File(Global.class.getProtectionDomain().getCodeSource().getLocation().toURI().getPath()).getParent();
        } catch (URISyntaxException exception)
        {
            exception.printStackTrace();
        }

        return null;
    }    

    private static boolean firstTime = true;
    private static Color splitLight;
    private static Color splitDark;
    
    public static Color linkColor = Color.blue;
    public static Color textColor = Color.black;
    
    
    

    public static String getHTMLColor(Color c)
    {
        return (String.format("%02X", c.getRed())+String.format("%02X", c.getGreen())+String.format("%02X", c.getBlue())).toLowerCase();
    }
    
    public static void initLAF()
    {
//        if (firstTime)
//            return;
        
        if (firstTime)
        {
            firstTime = false;
            UIDefaults table = UIManager.getLookAndFeelDefaults();
            splitLight = (Color) table.get( "SplitPane.highlight");
            splitDark =  (Color) table.get( "SplitPane.darkShadow");
        }
        try {
            // get rid of the stupd ever the same message that initializing was done successfully!
            System.setOut(devNull);
            
            UIManager.setLookAndFeel("de.muntjak.tinylookandfeel.TinyLookAndFeel");
            UIDefaults table = UIManager.getLookAndFeelDefaults();
            //UIDefaults table = UIManager.getLookAndFeelDefaults();

            HTMLEditorKit kit = new HTMLEditorKit();
            StyleSheet styleSheet = kit.getStyleSheet();
            styleSheet.addRule("a {color:#"+getHTMLColor(linkColor)+";}");
            styleSheet.addRule("body {color:#"+getHTMLColor(textColor)+";}");
            
            // reset to defaults
            if (splitLight != null)
                table.put( "SplitPane.highlight" , splitLight );
            if (splitDark != null)
                table.put( "SplitPane.darkShadow" , splitDark );
            
            // load new value from theme
            if (Theme.splitPaneHightlight.getColor() != null)
                table.put( "SplitPane.highlight" , Theme.splitPaneHightlight.getColor() );
            if (Theme.splitPaneDarkShadow.getColor() != null)
                table.put( "SplitPane.darkShadow" , Theme.splitPaneDarkShadow.getColor() );
            
            
            
            // things not initialized by tiny LAF
            table.put( "Panel.foreground" , table.get( "TextField.foreground") );

            table.put( "TextPane.foreground" , table.get( "TextField.foreground") );
            table.put( "TextPane.background" , table.get( "TextField.background") );
            table.put( "TextPane.selectionForeground" , table.get( "TextField.selectionForeground") );
            table.put( "TextPane.selectionBackground" , table.get( "TextField.selectionBackground") );

            table.put( "TextPane.caretForeground" , table.get( "TextField.caretForeground") );
            table.put( "TextArea.caretForeground" , table.get( "TextField.caretForeground") );
            table.put( "EditorPane.caretForeground" , table.get( "TextField.caretForeground") );
            
            updateComponentTree();
            
        } catch(Exception ex) {
            ex.printStackTrace();
        }  
        finally
        {
            System.setOut(devOut);
        }
    }
    
    public static void updateComponentTree()
    {
        if (mMainWindow != null)    
        {
            SwingUtilities.updateComponentTreeUI(mMainWindow);  
        }
    
        Logable l = Configuration.getConfiguration().getLogEntity();
        if ((l!=null) && (l instanceof LogPanel))
            SwingUtilities.updateComponentTreeUI((LogPanel)l);
        Logable d = Configuration.getConfiguration().getDebugEntity();
        if ((d!=null) && (d instanceof LogPanel))
            SwingUtilities.updateComponentTreeUI((LogPanel)d);
        
    }
    
    
    
}
