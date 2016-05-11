/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.gui;

import java.io.Serializable;

/**
 *
 * @author malban
 */
public interface Stateable {
    public String getID();
    public Serializable getAdditionalStateinfo();
    public void setAdditionalStateinfo(Serializable ser);
    public boolean isLoadSettings();
    
}
