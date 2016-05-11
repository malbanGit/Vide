/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx;

import de.malban.vide.vecx.cartridge.Cartridge;
import java.io.Serializable;

/**
 *
 * @author malban
 */
public class CompleteState implements Serializable
{
    int[] rom=null;
    Cartridge cart=null;
    String romPath = "";
    E6809State e6809State = new E6809State();
    E8910State e8910State = new E8910State();
    VecXState eVecXState = new VecXState();

    public void putState(E6809State s)
    {
        E6809State.deepCopy(s, e6809State);
    }
    public void putState(E8910State s)
    {
        E8910State.deepCopy(s, e8910State);
    }
    public void putState(VecXState s)
    {
        VecXState.deepCopy(s, eVecXState);
    }
}
