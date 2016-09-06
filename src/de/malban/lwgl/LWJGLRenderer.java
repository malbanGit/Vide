/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.lwgl;

/**
 *
 * @author malban
 */
public interface LWJGLRenderer {
    public int render(LWJGLSupport.GLWindow w);
    public void lwjglExit();
            
}
