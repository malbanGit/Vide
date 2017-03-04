/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban;

import static de.malban.Global.LWJGL_ENABLE;
import de.malban.config.Configuration;
import de.malban.event.EventSupport;
import de.malban.gui.CSAMainFrame;
import de.malban.gui.panels.LogPanel;
import de.malban.input.SystemController;
import de.malban.lwgl.LWJGLSupport;
import de.malban.sound.tinysound.TinySound;
import de.malban.vide.dissy.DASM6809;
import java.awt.Toolkit;
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.lang.management.ManagementFactory;
import java.util.ArrayList;
import java.util.List;

import javax.swing.JDialog;
import javax.swing.JFrame;
import javax.swing.SwingUtilities;
import javax.swing.UIManager;



//http://forum.staticvoidgames.com/t/lwjgl-3-0-tutorial-modern-opengl-part-1/32
// http://forum.staticvoidgames.com/t/lwjgl-tutorial-modern-opengl-part-2/35
/**
 *
 * @author malban
 */
public class VideMain {

    /**
     * @param args the command line arguments
     */
/*    
    public static int count(String toCount, String whatCount)
    {
        int count = 0;
        
        for (int i=0;i<toCount.length(); i++)
        {
            if (toCount.substring(i).startsWith(whatCount))
                count ++;
        }
        
        return count;
    }
    */
    public static void main(String[] args) {
/*        
        int count = 0;
        for (int i=0; i<= 0xffff; i++)
        {
            String b = DASM6809.printbinary16(i);
            String[] s = b.split("1");
            if (count(b,"1") == 8)
            {
                System.out.println(b);
                count++;
            }
        }
                System.out.println(""+count);
*/        
        
        
        if (LWJGL_ENABLE)
        {
            if (restartJVM()) 
                  return;
            
        }

        Configuration.getConfiguration().getDebugEntity();
        Global g = new Global();
        SystemController.isJInputSupported();
        LWJGLSupport.isLWJGLSupported();
                
        Toolkit.getDefaultToolkit().setDynamicLayout(true);
        System.setProperty("sun.awt.noerasebackground", "true");
        JFrame.setDefaultLookAndFeelDecorated(true);
        JDialog.setDefaultLookAndFeelDecorated(true);

        
        // Mac tinyLAF does somehow not
        // undecorate windows in fullscreen mode
        // on the fly, either create the application NEW (and lose everything we do right now)
        // ... we jjust do not decorate the main Frame...
        Toolkit.getDefaultToolkit().setDynamicLayout(false);
        System.setProperty("sun.awt.noerasebackground", "false");
        JFrame.setDefaultLookAndFeelDecorated(false);
        
        
        try {
            UIManager.setLookAndFeel("de.muntjak.tinylookandfeel.TinyLookAndFeel");
        } catch(Exception ex) {
            ex.printStackTrace();
        }  
        EventSupport.getEventSupport();
  
        TinySound.init();
        SwingUtilities.invokeLater(new Runnable()
        {
            public void run()
            {
                CSAMainFrame mainFrame = new CSAMainFrame();
                mainFrame.setVisible(true);
            }
        });

        if (LWJGLSupport.isLWJGLSupported())
            LWJGLSupport.getLWJGLSupport().deliverMainThread();
    }
    
    // see: http://www.java-gaming.org/topics/starting-jvm-on-mac-with-xstartonfirstthread-programmatically/37697/view.html
public static boolean restartJVM() {
      
      String osName = System.getProperty("os.name");
      
      // if not a mac return false
      if (!osName.startsWith("Mac") && !osName.startsWith("Darwin")) {
         return false;
      }
      
      // get current jvm process pid
      String pid = ManagementFactory.getRuntimeMXBean().getName().split("@")[0];
      // get environment variable on whether XstartOnFirstThread is enabled
      String env = System.getenv("JAVA_STARTED_ON_FIRST_THREAD_" + pid);
      
      // if environment variable is "1" then XstartOnFirstThread is enabled
      if (env != null && env.equals("1")) {
         return false;
      }
      
      // restart jvm with -XstartOnFirstThread
      String separator = System.getProperty("file.separator");
      String classpath = System.getProperty("java.class.path");
      String mainClass = System.getenv("JAVA_MAIN_CLASS_" + pid);
      String jvmPath = System.getProperty("java.home") + separator + "bin" + separator + "java";
      
      List<String> inputArguments = ManagementFactory.getRuntimeMXBean().getInputArguments();
      
      ArrayList<String> jvmArgs = new ArrayList<String>();
      
      jvmArgs.add(jvmPath);
      jvmArgs.add("-XstartOnFirstThread");
      jvmArgs.addAll(inputArguments);
      jvmArgs.add("-cp");
      jvmArgs.add(classpath);
      jvmArgs.add(mainClass);
      
      // if you don't need console output, just enable these two lines 
      // and delete bits after it. This JVM will then terminate.
      //ProcessBuilder processBuilder = new ProcessBuilder(jvmArgs);
      //processBuilder.start();
      
      try {
         ProcessBuilder processBuilder = new ProcessBuilder(jvmArgs);
         processBuilder.redirectErrorStream(true);
         Process process = processBuilder.start();
         
         InputStream is = process.getInputStream();
         InputStreamReader isr = new InputStreamReader(is);
         BufferedReader br = new BufferedReader(isr);
         String line;
         
         while ((line = br.readLine()) != null) {
            System.out.println(line);
         }
         
         process.waitFor();
      } catch (Exception e) {
         e.printStackTrace();
      }
      
      return true;
   }
}