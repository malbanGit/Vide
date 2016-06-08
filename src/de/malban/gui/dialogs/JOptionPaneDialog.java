/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.gui.dialogs;

import de.malban.config.Configuration;
import de.malban.gui.CSAMainFrame;
import de.malban.gui.components.ModalInternalFrame;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.JOptionPane;

/**
 *
 * @author malban
 */
public class JOptionPaneDialog 
{
    static int returnValue;
    public static int show(JOptionPane c)
    {
        CSAMainFrame frame = (CSAMainFrame) Configuration.getConfiguration().getMainFrame();
        
        
        returnValue = JOptionPane.CANCEL_OPTION;
        
        // Manually construct an input popup
        final ModalInternalFrame modal = new ModalInternalFrame("Question", frame.getRootPane(), frame, c);

        modal.setSystemDialog(true);
                /*
        final javax.swing.event.InternalFrameAdapter l = new javax.swing.event.InternalFrameAdapter()
        {
            javax.swing.event.InternalFrameAdapter ll=this;
            @Override public void internalFrameClosed(javax.swing.event.InternalFrameEvent e)
            {
                if (modal.isExitButtonUsed())
                {
                    returnValue =  JOptionPane.YES_OPTION;
                }
                returnValue = JOptionPane.CANCEL_OPTION;
            }
        };
*/
  //      modal.addInternalFrameListener(l);
/*
        returnValue = ERROR_OPTION;
        c.addActionListener(new ActionListener()
        {
            @Override
            public void actionPerformed(ActionEvent e)
            {
                if (e.getActionCommand().equals(APPROVE_SELECTION))
                {
                    if (modal.isVisible())
                        modal.setVisible(false);
                    returnValue = JFileChooser.APPROVE_OPTION;
                }
                if (e.getActionCommand().equals(CANCEL_SELECTION))
                {
                    if (modal.isVisible())
                        modal.setVisible(false);
                    returnValue = JFileChooser.CANCEL_OPTION;
                }
            }
        });
        */
        modal.setVisible(true);
        Object o = c.getValue();
        returnValue = (Integer)o;
        return returnValue;
    }
}
