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
public interface E6809Access {
    public int e6809_read8(int address);
    public int e6809_readOnly8(int address);
    public void e6809_write8(int address, int data);
//    public void vectrexNonCPUStep();
    public void vectrexNonCPUStep(int cycles);

}
