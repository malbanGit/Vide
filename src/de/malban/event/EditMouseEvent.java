/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.event;

import de.malban.graphics.GFXVector;
import de.malban.graphics.Vertex;
import java.awt.event.MouseEvent;
import javax.swing.JPanel;

/**
 *
 * @author malban
 */
public class EditMouseEvent {
    
    // vecci uses only vectrex coordinates to handle vectors!
    
    // mouse coordinates are only used to display the popupmenu
    public MouseEvent evt;
    public JPanel panel;
    public boolean dragging = false;
    public boolean shiftPressed = false;
    public boolean ctrlPressed = false;
    public boolean mouseExited = false;
    public int dragOriginX = 0;
    public int dragOriginY = 0;
    public int dragOriginZ = 0;
    public int dragNowX = 0;
    public int dragNowY = 0;
    public int dragNowZ = 0;
    // all above in gui mouse coordinates
    // all following in vectrex coordinates
    public GFXVector highlightedVector = null;
    public GFXVector selectedVector = null;
    public Vertex highlightedPoint = null;
    public Vertex selectedPoint = null;
    public Vertex translocationInVectrexPoint = new Vertex();
    public Vertex lastClickedVectrexPoint = new Vertex();
    public Vertex currentVectrexPoint = new Vertex();
}
