/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vedi;

/**
 *
 * @author chrissalo
 */
public interface CloseListener {
    public boolean closeRequested(CloseEvent e);
    public void renameTo(String newFilename);
    
}
