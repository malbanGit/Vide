/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.veccy;

import java.util.ArrayList;
import de.malban.graphics.GFXVectorAnimation;

/**
 *
 * @author malban
 */
public interface StoryboardPanelInterface {
    void setElement(StoryboardElement element, StoryboardLanePanel lane);
    public ArrayList<StoryboardLanePanel> getLanes() ;
    public void setLanes(ArrayList<StoryboardLanePanel> lanes) ;
    public StoryboardLanePanel getCurrentLane() ;
    public void setCurrentLane(StoryboardLanePanel currentLane);
    public StoryboardElement getCurrentElement() ;
    public void setCurrentElement(StoryboardElement currentElement) ;
    public GFXVectorAnimation getCurrentAnimation();
    public void setCurrentAnimation(GFXVectorAnimation currentAnimation);
    public boolean isNoAdditionalSyncOptimization();
    public void updateBounds();
    public void setVeccy(VeccyPanel vp);
    public int getVersion();
}
