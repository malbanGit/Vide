/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.PiTrex;

import com.fazecast.jSerialComm.SerialPortEvent;

/**
 *
 * @author salom
 */
public class PiTrexEvent {
    public static final int PITREX_SERIAL_EVEN=0;
    public static final int PITREX_CONNECTION_STATE_CHANGED=1;
    public int type=0;
    public byte[] received; 
    public SerialPortEvent se;
    
    public PiTrexEvent(SerialPortEvent _se)
    {
        se = _se;
        type = PITREX_SERIAL_EVEN; // type 1 connection state changed
    }
    public PiTrexEvent(int t)
    {
        type = t; // type 1 connection state changed
    }
}
