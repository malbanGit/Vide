/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban;

import de.malban.event.EventSupport;
import de.malban.gui.CSAMainFrame;
import de.malban.sound.tinysound.TinySound;
import java.awt.KeyboardFocusManager;
import java.awt.Toolkit;
import javax.swing.JDialog;
import javax.swing.JFrame;
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
  /*     
long eventMask = AWTEvent.MOUSE_MOTION_EVENT_MASK
    + AWTEvent.MOUSE_EVENT_MASK
    + AWTEvent.KEY_EVENT_MASK;
 eventMask = AWTEvent.KEY_EVENT_MASK;

Toolkit.getDefaultToolkit().addAWTEventListener( new AWTEventListener()
{
    public void eventDispatched(AWTEvent e)
    {
        System.out.println(e.getID());
    }
}, eventMask);
*/

        TinySound.init();
        CSAMainFrame mainFrame = new CSAMainFrame();
        mainFrame.setVisible(true);

    }
    
}
