/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.sound.tinysound;

/**
 *
 * @author malban
 */
public interface Stream 
{
    public void start();
    public void stop();
    public void unload();
    public int available();
    public int write(byte[] soundBytes, int offset, int soundLength);

}

