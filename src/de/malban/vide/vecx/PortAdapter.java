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
public interface PortAdapter 
{
//    public int readDataFromPort();
    public int getWriteDataToPort(int portAOrg);
    public void valueChangedFromPSG();
    public void setInputMode(boolean i);
    
}
