/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx.cartridge;

import java.io.Serializable;



/* 
 * @author malban
 */
public class XMasLED implements Serializable, CartridgeInternalInterface
{
    private static XMasLED[] dualVec = null;
    int side = 0;
    int otherSide = 1;
    boolean inputFromExternalEnabled = false;
    Cartridge cart = null;
    boolean lineOut = true; // only output value from our OWN vectrex

    public XMasLED clone()
    {
        XMasLED c = new XMasLED();
        c.inputFromExternalEnabled = inputFromExternalEnabled;
        c.side = side;
        c.otherSide = otherSide;
        c.lineOut = lineOut;
        
        return c;
        
    }
    public void setCartridge(Cartridge c)
    {
        cart = c;
    }
    public XMasLED()
    {
    }
    public void setPB6InputEnabledFromExternal(boolean b)
    {
        inputFromExternalEnabled = b;
    }
    public void reset()
    {
    }
    public void init()
    {
    }
    public void deinit()
    {
    }
    public String toString()
    {
        return "Xmas LED";
    }
    public void step(long cycles)
    {
    }
    // only set from our OWN vectrex
    public void linePB6In(boolean b)
    {
        lineOut = b;
        if (cart == null) return;
        if (b)
        {
            cart.getDisplay().setLED(0);
        }
        else
        {
            cart.getDisplay().setLED(1);
        }
    }
    public void linePB6Out(boolean b)
    {
    }
    public void lineIRQIn(boolean i)
    {
    }
    public boolean usesPB6() {return true;}
    public boolean isActive() {return true;}
}

