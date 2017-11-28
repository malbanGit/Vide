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
            }
        });

    }
}
