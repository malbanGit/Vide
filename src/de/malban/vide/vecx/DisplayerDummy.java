/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx;

import de.malban.vide.vecx.VecXState.vector_t;
import de.malban.vide.vecx.devices.JoyportDevice;

/**
 *
 * @author malban
 */
public class DisplayerDummy implements DisplayerInterface
{
    public void breakpointRemove(Breakpoint bp){}
    public void switchDisplay(){}
    public void updateDisplay(){} 
    public void directDraw(vector_t v){}
    public void rayMove(int x0,int y0, int x1, int y1, int color, int dwell, boolean curved, int alg_vector_speed, int alg_leftEye, int alg_rightEye){}
    public void setJoyportDevice(int port, JoyportDevice d){}
    public void setLED(int state){}// 0 = invisible, 1 = on, 2 = off
}
