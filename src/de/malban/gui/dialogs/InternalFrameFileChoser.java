/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package de.malban.gui.dialogs;

import de.malban.gui.components.ModalInternalFrame;
import java.awt.Component;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.accessibility.AccessibleContext;
import javax.swing.JFileChooser;
import javax.swing.JFrame;

/**
 *
 * @author Malban
 */
public class InternalFrameFileChoser extends JFileChooser{
    private int returnValue = ERROR_OPTION;
    @Override public int showOpenDialog(Component c)
    {
        if (!(c instanceof JFrame)) return JFileChooser.ERROR_OPTION;
        JFrame frame = (JFrame) c;
        setDialogType(OPEN_DIALOG);
        
        
        setApproveButtonText("Ok");
        
        String title = getUI().getDialogTitle(this);
        putClientProperty(AccessibleContext.ACCESSIBLE_DESCRIPTION_PROPERTY, title);

        returnValue = JFileChooser.ERROR_OPTION;

        // Manually construct an input popup
        final ModalInternalFrame modal = new ModalInternalFrame(title, frame.getRootPane(),frame, this, "Ok");

        modal.setSystemDialog(true);
        final javax.swing.event.InternalFrameAdapter l = new javax.swing.event.InternalFrameAdapter()
        {
            javax.swing.event.InternalFrameAdapter ll=this;
            @Override public void internalFrameClosed(javax.swing.event.InternalFrameEvent e)
            {
                if (modal.isExitButtonUsed())
                {
                    returnValue =  JFileChooser.APPROVE_OPTION;
                }
                returnValue = JFileChooser.CANCEL_OPTION;
            }
        };

        modal.addInternalFrameListener(l);
	returnValue = ERROR_OPTION;
        rescanCurrentDirectory();
        addActionListener(new ActionListener()
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
        modal.setVisible(true);
        return returnValue;
    }
}
