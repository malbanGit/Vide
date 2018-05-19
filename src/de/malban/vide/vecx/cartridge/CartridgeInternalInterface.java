/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx.cartridge;

/**
 *
 * @author malban
 */
public interface CartridgeInternalInterface {
    public void reset();
    public void deinit();
    public void init();
    public CartridgeInternalInterface clone();

    
    public boolean usesPB6();
    public boolean isActive();
    
    // receiving line information from the emulator (VIA)
    public void linePB6In(boolean l);
    // receiving line information from the emulator (VIA)
    public void lineIRQIn(boolean l);

    // sending line information to the emulator (VIA)
    public void linePB6Out(boolean l);

    // low level step
    // this is triggered with every cycle from the emulator
    // c is the current cylce counter of the vecx emulator, needed for timing
    // (since I don't trust that we are called each cycle :-) )
    public void step(long c);
}
