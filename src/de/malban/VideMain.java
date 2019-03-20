/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban;

import static de.malban.Global.initLAF;
import de.malban.jogl.JOGLSupport;
import de.malban.config.Configuration;
import de.malban.event.EventSupport;
import de.malban.gui.CSAMainFrame;
import static de.malban.gui.panels.LogPanel.INFO;
import de.malban.input.SystemController;
import de.malban.sound.tinysound.TinySound;
import de.malban.vide.CLI;
import java.awt.Toolkit;

import javax.swing.JDialog;
import javax.swing.JFrame;
import javax.swing.SwingUtilities;


/**
 *
 * @author malban
 */
public class VideMain {

    public static void main(String[] args) {

        Configuration.getConfiguration().getDebugEntity();
        String javaVersion2 = System.getProperty("java.vm.name") + " (build " +
                     System.getProperty("java.vm.version") + ", " +
                     System.getProperty("java.vm.info") + ")";
        String javaVersion1 = System.getProperty("java.version") + " " +
                     System.getProperty("java.vendor");
        String javaDir = "Java Home: "+System.getProperty("java.home");
         
        
        
        Configuration.getConfiguration().getDebugEntity().addLog("Running on: "+javaVersion1, INFO);
        Configuration.getConfiguration().getDebugEntity().addLog(""+javaVersion2, INFO);
        Configuration.getConfiguration().getDebugEntity().addLog(""+javaDir, INFO);
        Configuration.getConfiguration().getDebugEntity().addLog("VIDE_HOME = "+Global.mainPathPrefix, INFO);

        
        Global g = new Global();
                
        Toolkit.getDefaultToolkit().setDynamicLayout(true);
        System.setProperty("sun.awt.noerasebackground", "true");
        JFrame.setDefaultLookAndFeelDecorated(true);
        JDialog.setDefaultLookAndFeelDecorated(true);

        initLAF();
        EventSupport.getEventSupport();

        CLI cli = CLI.getCLI();
        boolean doExit = cli.parseArguments(args);
        // if help was invoked - exit
        if (doExit) return;
        cli.injectCLIConfig();
        
        
        
        
        
        SystemController.isJInputSupported();
        JOGLSupport.isJOGLSupported();
  
        TinySound.init();
        SwingUtilities.invokeLater(new Runnable()
        {
            public void run()
            {
                CSAMainFrame mainFrame = new CSAMainFrame();
                mainFrame.setVisible(true);
                
                /*
                String javaVersion = System.getProperty("java.version");
                String[] splitter = javaVersion.split("\\.");
                if (splitter.length == 0)
                {
                    ShowWarningDialog.showWarningDialog("Java version", "Java version cannot be determined,\nyou need at least Java version 10, procede at own risk!");
                }
                else
                {
                    int v = DASM6809.toNumber(splitter[0]);
                    Logable l = Configuration.getConfiguration().getDebugEntity();
                    l.addLog("Version string found: "+javaVersion+"("+v+")", INFO);
                    if (v<10)
                    {
                        if (Global.doTestJava)
                        {
                            ShowErrorDialog.showErrorDialog("Java version", "You need at least Java version 10 to run Vide!\nPlease update Java.");
                            System.exit(1);
                        }
                    }
                }
                */
                
            }
        });

    }
}
