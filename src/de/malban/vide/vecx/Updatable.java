/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx;

/**
 *
 * @author chrissalo
 */
public interface Updatable {
    public void updateValues(boolean forceUpdate);
    public void setUpdateEnabled(boolean b);
}
