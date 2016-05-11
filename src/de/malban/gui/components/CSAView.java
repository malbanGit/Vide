/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.gui.components;

import de.malban.gui.panels.TipOfDayGUI;
import javax.swing.JPanel;

/**
 *
 * @author malban
 */
public interface CSAView {
    
    public void removeInternalFrame(CSAInternalFrame iFrame);
    public void aboutToCloseInternalFrame(CSAInternalFrame iFrame);
    public void showPanelModal(JPanel c, String name, int w, int h);
    public void removeTOD(TipOfDayGUI starter);
    public int getUsableFrameWidth();
    public int getUsableFrameHeight();
    public void doGameAction(String action);
        
    
}
