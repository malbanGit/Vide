/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.dissy;

import de.malban.vide.vecx.panels.RegisterJPanel;

/**
 *
 * @author malban
 */
public class Watch {
    public static int WATCHTYPE_BINARY = 0; // 1 byte as binary
    public static int WATCHTYPE_BYTE_8 = 1; // 1 byte as dec/hex/2 complement dec
    public static int WATCHTYPE_BYTE_16 = 2;// 1 word as dec/hex/2 complement dec
    public static int WATCHTYPE_STRING = 3; // till 0 or complement negative is found
    public static int WATCHTYPE_BYTE_PAIR = 4;// 2 byte as dec/hex/2 complement dec
    public static int WATCHTYPE_BYTE_SEQUENCE = 5; // x number of bytes as hex

    DissiPanel dissi = null;
    int startaddress = 0;
    int type = 0;
    int length = 1;
    
    private Watch()
    {
    }
    public String toString()
    {
        if (dissi == null) return "";
        int val = peek(startaddress)&0xff;
        if (type == WATCHTYPE_BINARY)
        {
            return "%" + RegisterJPanel.printbinary(val);
        }
        if (type == WATCHTYPE_BYTE_8)
        {
            String ret = "$"+String.format("%02X", val);
            ret += " #"+val+"(#"+((val>127)?(val-256):(val))+"), binary: %"+RegisterJPanel.printbinary(val);
            return ret;
        }
        if (type == WATCHTYPE_BYTE_16)
        {
            int val16 =  ((val&0xff)*256)+(peek((startaddress+1)%65536));
            String ret = "$"+String.format("%04X",val16);
            ret += " #"+val16+"(#"+((val16>32767)?(val16-32768):(val16))+")";
            return ret;
        }
        if (type == WATCHTYPE_BYTE_PAIR)
        {
            String ret = "$"+String.format("%02X",peek(startaddress));
            ret += " $"+String.format("%02X",peek((startaddress+1)%65536));
            return ret;
        }
        if (type == WATCHTYPE_BYTE_SEQUENCE)
        {
            String ret = "";
            for (int i=0;i<length; i++)
            {
                if (ret.length()>0) ret += " ";
                ret += "$"+String.format("%02X",peek((startaddress+i)%65536));
            }
            return ret;
        }
        if (type == WATCHTYPE_STRING)
        {
            String ret = "";
            int v=0;
            int count =0;
            while (true)
            {
                v = peek((startaddress+count)%65536);
                if (v == 0) break;
                if (v > 127) break;
                if (v < 0) break;
                ret += ((char) v);
                count++;
            }
            return ret;
        }
        return "";
    }
    private int peek(int address)
    {
        if (dissi==null) return 0;
        if (dissi.currentDissi==null) return 0;
        if (dissi.currentDissi.vecxPanel==null) return 0;
        return (dissi.currentDissi.vecxPanel.getVecXMem8(address))&0xff;
    }
    public static void addWatch(int address, int t, int l, DissiPanel d)
    {
        removeWatch(address, d);
        Watch w = new Watch();
        w.startaddress = address;
        w.type = t;
        w.length = l;
        w.dissi =d;
        d.currentDissi.watchlist.add(w);
    }
    public static void removeWatch(int address, DissiPanel d)
    {
        Watch w = new Watch();
        w.startaddress = address;
        d.currentDissi.removeWatchByAddress(address);
    }
    

}
