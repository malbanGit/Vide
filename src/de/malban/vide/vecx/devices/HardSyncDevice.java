/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx.devices;

import de.malban.vide.vecx.VecX;

/**
 *
 * @author malban
 */
public interface HardSyncDevice 
{
    public boolean isMaster();
    public VecX getMasterVecX();
    public VecX getSlaveVecX();
}
