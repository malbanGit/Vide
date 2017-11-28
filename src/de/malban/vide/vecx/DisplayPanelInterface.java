/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx;

/**
 *
 * @author malban
 */
public interface DisplayPanelInterface 
{
    public void setRotation(int angle); // 
    public void stopGraphics(); // when emulation is stopped, ensure empty display
    public void setLightPen();
    public void forceResize();
    public void deinit();
    public void resetDirectdraw();
    public void overlayChanged();

    // from DisplayerInterface
    public void switchDisplay();
    public void updateDisplay();
    public void directDraw(VecXState.vector_t v); // while debugging a "direct" draw of the currrent drawn vector
    public void rayMove(int x0,int y0, int x1, int y1, int color, int dwell, boolean curved, int alg_vector_speed, int alg_leftEye, int alg_rightEye); // if in ray modus - move one "step"
}
