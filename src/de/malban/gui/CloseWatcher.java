/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.gui;

/**
 *
 * @author malban
 */
public interface CloseWatcher {
    
    public void preClose();
    public void postClose();
}
