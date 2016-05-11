/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package de.malban.gui;

import de.malban.gui.components.CSAView;

/**
 *
 * @author Malban
 */
public interface Windowable
{
    public void setParentWindow(CSAView jpv);
    public void setMenuItem(javax.swing.JMenuItem item);
    public javax.swing.JMenuItem getMenuItem();
    public javax.swing.JPanel getPanel();
    public void closing(); // probably called multiple times, since closing events happen a lot :-)
}
