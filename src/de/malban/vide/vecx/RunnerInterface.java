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
public interface RunnerInterface {
    public static final int NO_SYNC = 0;
    public static final int SYNC_MASTER = 1;
    public static final int SYNC_SLAVE = 2;

    public boolean setHardSyncMode(int mode);
}
