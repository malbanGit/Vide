/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban;

import de.malban.config.Configuration;
import de.malban.event.EventSupport;
import de.malban.gui.CSAMainFrame;
import de.malban.input.SystemController;
import de.malban.lwgl.LWJGLSupport;
import de.malban.sound.tinysound.TinySound;
import java.awt.Toolkit;
import javax.swing.JDialog;
import javax.swing.JFrame;
import javax.swing.SwingUtilities;
import javax.swing.UIManager;



/**
 *
 * @author malban
 */
public class VideMain {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        Configuration.getConfiguration().getDebugEntity();
        Global g = new Global();

        SystemController.isJInputSupported();
        LWJGLSupport.isLWJGLSupported();
        
        
/*        
        System.out.println("JInput version: " + Version.getVersion());
        ControllerEnvironment ce = ControllerEnvironment.getDefaultEnvironment();
        Controller[] cs = ce.getControllers();
        for (int i = 0; i < cs.length; i++)
            System.out.println(i + ". " + cs[i].getName() + ", " + cs[i].getType() );
*/
                
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
    
}