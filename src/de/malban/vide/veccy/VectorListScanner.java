/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.veccy;

import de.malban.graphics.GFXVector;
import de.malban.graphics.GFXVectorList;
import de.malban.vide.vecx.E6809;
import de.malban.vide.vecx.VecX;
import de.malban.vide.vecx.cartridge.Cartridge;
import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;

/**
 *
 * @author malban
 */
public class VectorListScanner {
    public static final int THRESHOLD = 3; // at last this many vectors must be in a list to be saved!
    static class ScanEntry
    {
        public int listStartAddress;
        public int listEndAddress;
        public int listType;
        String name="";
        int bank;
        public String key;
        public GFXVectorList list = new GFXVectorList();
    }
    
    static ArrayList <ScanEntry> listsFound = new ArrayList<>();
    
    // key = cartname_bank_address
    static HashMap<String, Boolean> scanDone = new HashMap<String, Boolean>();
    
    public static final int NONE =  0;
    public static final int Draw_Pat_VL =  1;
    public static final int Draw_VL =  2;
    public static final int Draw_VL_a =  3;
    public static final int Draw_VL_ab =  4;
    public static final int Draw_VL_b =  5;
    public static final int Draw_VL_mode =  6;
    public static final int Draw_VLc =  7;
    public static final int Draw_VLcs =  8;
    public static final int Draw_VLp =  9;
    public static final int Draw_VLp_7F =  10;
    public static final int Draw_VLp_b =  11;
    public static final int Draw_VLp_FF =  12;
    public static final int Draw_VLp_scale =  13;
    public static final int Mov_Draw_VL_a = 14;
    
    private static boolean isDone(E6809 e6809, Cartridge cart, String key)
    {
        int x = e6809.reg_x;
        for (ScanEntry se: listsFound)
        {
            if (!cart.cartName.equals(se.name)) continue;
            if (cart.getCurrentBank() != se.bank) continue;
            if ((x>=se.listStartAddress) && (x<=se.listEndAddress))
            {
                scanDone.put(key, Boolean.TRUE);
                return true;
            }
        }
        return false;
    }
    static boolean saveList(ScanEntry list)
    {
        if (list.list.list.size()<THRESHOLD) return false;
        
        String name = new File(list.name).getName();
        name += "_"+list.bank;
        name += "_0x"+String.format("%04X", list.listStartAddress);
        name += "_"+typeString[list.listType];
        
        
        
        String filename ="xml"+File.separator+"vectorlist"+File.separator+name+".xml";
        
        return list.list.saveAsXML(filename);
    }    
    
    static String[] typeString = {"NONE",
                            "Draw_Pat_VL",
                            "Draw_VL",
                            "Draw_VL_a",
                            "Draw_VL_ab",
                            "Draw_VL_b",
                            "Draw_VL_mode",
                            "Draw_VLc",
                            "Draw_VLcs",
                            "Draw_VLp",
                            "Draw_VLp_7F",
                            "Draw_VLp_b",
                            "Draw_VLp_FF",
                            "Draw_VLp_scale",
                            "Mov_Draw_VL_a"
    };
    public static void check(E6809 e6809, Cartridge cart, VecX vecx)
    {
        if ((e6809.reg_pc<0xF3AD) || (e6809.reg_pc>0xF46E)) return;
        int checkType = NONE;
        // check if  a vectorList is drawn
        if (e6809.reg_pc == 0xF437) checkType = Draw_Pat_VL;    // Draw_Pat_VL ($F437)
        if (e6809.reg_pc == 0xF3DD) checkType = Draw_VL;        // Draw_VL ($F3DD))
        if (e6809.reg_pc == 0xF3DA) checkType = Draw_VL_a;      // Draw_VL_a ($F3DA))
        if (e6809.reg_pc == 0xF3D8) checkType = Draw_VL_ab;     // Draw_VL_ab ($F3D8))
        if (e6809.reg_pc == 0xF3D2) checkType = Draw_VL_b;      // Draw_VL_b ($F3D2)
        if (e6809.reg_pc == 0xF46E) checkType = Draw_VL_mode;   // Draw_VL_mode ($F46E)
        if (e6809.reg_pc == 0xF3CE) checkType = Draw_VLc;       // Draw_VLc ($F3CE)
        if (e6809.reg_pc == 0xF3D6) checkType = Draw_VLcs;      // Draw_VLcs ($F3D6)
        if (e6809.reg_pc == 0xF410) checkType = Draw_VLp;       // Draw_VLp ($F410)
        if (e6809.reg_pc == 0xF408) checkType = Draw_VLp_7F;    // Draw_VLp_7F ($F408)
        if (e6809.reg_pc == 0xF40E) checkType = Draw_VLp_b;     // Draw_VLp_b ($F40E)
        if (e6809.reg_pc == 0xF404) checkType = Draw_VLp_FF;    // Draw_VLp_FF ($F404)
        if (e6809.reg_pc == 0xF40C) checkType = Draw_VLp_scale; // Draw_VLp_scale ($F40C) 
        if (e6809.reg_pc == 0xF3B9) checkType = Mov_Draw_VL_a;  // Mov_Draw_VL_a ($F3B9) 
        
        if (checkType == NONE) return;
        
        String key = cart.cartName+"_"+cart.getCurrentBank()+"_" + e6809.reg_x+"_"+typeString[checkType];
        if (isDone(e6809, cart, key)) return;
        Boolean isDone =scanDone.get(key);
        if ((isDone != null) && (isDone)) return;

        switch (checkType)
        {
            case Draw_Pat_VL:
            {
                doDraw_Pat_VL(e6809, cart, vecx, key, checkType);
                break;
            }
            case Draw_VL:
            {
                doDraw_VL(e6809, cart, vecx, key, checkType);
                break;
            }
            case Draw_VLp:
            {
                doDraw_VLp(e6809, cart, vecx, key, checkType);
                break;
            }
            case Draw_VL_mode:
            {
                doDraw_VL_mode(e6809, cart, vecx, key, checkType);
                break;
            }
            case Mov_Draw_VL_a:
            {
                doMov_Draw_VL_a(e6809, cart, vecx, key, checkType);
                break;
            }
                        
            default:
                break;
        }
        
        scanDone.put(key, Boolean.TRUE); // whatever happens - only scan once!
    }

    // PC = 0xF3DD
    // in X is an address of VL
    static void doDraw_VL(E6809 e6809, Cartridge cart, VecX vecx, String key, int type)
    {
        ScanEntry list = new ScanEntry();
        list.name = cart.cartName;
        list.bank = cart.getCurrentBank();
        list.key = key;
        list.listType = type;
        list.listStartAddress = e6809.reg_x;
        int bytesUsed = 0;
        int count = vecx.e6809_readOnly8(0xc823)+1; // count of vectors
        int oldx=0;
        int oldy=0;
        int pattern = 0xff;
        int intensity = vecx.alg_zsh.intValue;
        for (int i=0; i<count; i++)
        {
            int y = vecx.e6809_readOnly8(e6809.reg_x+bytesUsed) &0xff;
            int x = vecx.e6809_readOnly8(e6809.reg_x+bytesUsed+1) &0xff;
            if (y>127) y-=256; 
            if (x>127) x-=256; 
            
            y+=oldy;
            x+=oldx;
            
            GFXVector v = new GFXVector();
            v.start.x(oldx);
            v.start.y(oldy);
            v.end.x(x);
            v.end.y(y);
            oldx = x;
            oldy = y;
            v.intensity = intensity;
            v.pattern = pattern;
            if (i!=0)
            {
                list.list.get(i-1).end_connect = v;
                list.list.get(i-1).uid_end_connect = v.uid;
                v.start_connect = list.list.get(i-1);
                v.uid_start_connect = list.list.get(i-1).uid;
                v.start = list.list.get(i-1).end;
            }
            list.list.add(v);
            bytesUsed += 2;
        }
        for (GFXVector v: list.list.list)
        {
            if ((v.end_connect != null) && (v.start_connect != null))
                v.setRelativ(true);
        }
        list.listEndAddress = list.listStartAddress+bytesUsed;
        saveList(list);
        listsFound.add(list);
    }
    
    // Draw_VLp
    // PC = 0xF410
    // in X is an address of VL
    static void doDraw_VLp(E6809 e6809, Cartridge cart, VecX vecx, String key, int type)
    {
        ScanEntry list = new ScanEntry();
        list.name = cart.cartName;
        list.bank = cart.getCurrentBank();
        list.key = key;
        list.listType = type;
        list.listStartAddress = e6809.reg_x;
        int bytesUsed = 0;
        int oldx=0;
        int oldy=0;
        int intensity = vecx.alg_zsh.intValue;
        int count = 0;
        boolean first = true;
        while (true)
        {
            GFXVector v = new GFXVector();
            v.pattern = vecx.e6809_readOnly8(e6809.reg_x+bytesUsed) &0xff;
            if (!first)
                if (v.pattern<128) break;
            first = false;
            int y = vecx.e6809_readOnly8(e6809.reg_x+bytesUsed+1) &0xff;
            int x = vecx.e6809_readOnly8(e6809.reg_x+bytesUsed+2) &0xff;
            if (y>127) y-=256; 
            if (x>127) x-=256; 
            
            y+=oldy;
            x+=oldx;
            
            v.start.x(oldx);
            v.start.y(oldy);
            v.end.x(x);
            v.end.y(y);
            oldx = x;
            oldy = y;
            v.intensity = intensity;
            if (count!=0)
            {
                list.list.get(count-1).end_connect = v;
                list.list.get(count-1).uid_end_connect = v.uid;
                v.start_connect = list.list.get(count-1);
                v.uid_start_connect = list.list.get(count-1).uid;
                v.start = list.list.get(count-1).end;
            }
            list.list.add(v);
            bytesUsed += 3;
            count++;
        }
        for (GFXVector v: list.list.list)
        {
            if ((v.end_connect != null) && (v.start_connect != null))
                v.setRelativ(true);
        }
        list.listEndAddress = list.listStartAddress+bytesUsed;
        saveList(list);
        listsFound.add(list);
    }

   static void doDraw_Pat_VL(E6809 e6809, Cartridge cart, VecX vecx, String key, int type)
    {
        ScanEntry list = new ScanEntry();
        list.name = cart.cartName;
        list.bank = cart.getCurrentBank();
        list.key = key;
        list.listType = type;
        list.listStartAddress = e6809.reg_x;
        int bytesUsed = 0;
        int oldx=0;
        int oldy=0;
        int intensity = vecx.alg_zsh.intValue;
        int pattern = vecx.e6809_readOnly8(0xC829) &0xff;
        int max = vecx.e6809_readOnly8(0xC823) &0xff;
        max++;
        for (int i=0; i<max;i++)
        {
            GFXVector v = new GFXVector();
            v.pattern = pattern;
            
            int y = vecx.e6809_readOnly8(e6809.reg_x+bytesUsed+0) &0xff;
            int x = vecx.e6809_readOnly8(e6809.reg_x+bytesUsed+1) &0xff;
            if (y>127) y-=256; 
            if (x>127) x-=256; 
            
            y+=oldy;
            x+=oldx;
            
            v.start.x(oldx);
            v.start.y(oldy);
            v.end.x(x);
            v.end.y(y);
            oldx = x;
            oldy = y;
            v.intensity = intensity;
            if (i!=0)
            {
                list.list.get(i-1).end_connect = v;
                list.list.get(i-1).uid_end_connect = v.uid;
                v.start_connect = list.list.get(i-1);
                v.uid_start_connect = list.list.get(i-1).uid;
                v.start = list.list.get(i-1).end;
            }
            list.list.add(v);
            bytesUsed += 2;
        }
        for (GFXVector v: list.list.list)
        {
            if ((v.end_connect != null) && (v.start_connect != null))
                v.setRelativ(true);
        }
        list.listEndAddress = list.listStartAddress+bytesUsed;
        saveList(list);
        listsFound.add(list);
    }

    // Draw_VL_mode
    // PC = 0xF46E
    // in X is an address of VL
    static void doDraw_VL_mode(E6809 e6809, Cartridge cart, VecX vecx, String key, int type)
    {
        ScanEntry list = new ScanEntry();
        list.name = cart.cartName;
        list.bank = cart.getCurrentBank();
        list.key = key;
        list.listType = type;
        list.listStartAddress = e6809.reg_x;
        int bytesUsed = 0;
        int oldx=0;
        int oldy=0;
        int intensity = vecx.alg_zsh.intValue;
        int count = 0;
        int pattern = 0;
        while (true)
        {
            GFXVector v = new GFXVector();
            int mode = vecx.e6809_readOnly8(e6809.reg_x+bytesUsed) &0xff;
            if (mode == 1) break;
            
            
            
            else if (mode == 0) pattern = 0;
            else if (mode >= 128) pattern = vecx.e6809_readOnly8(0xC829);
            else pattern = 255;
            
            int y = vecx.e6809_readOnly8(e6809.reg_x+bytesUsed+1) &0xff;
            int x = vecx.e6809_readOnly8(e6809.reg_x+bytesUsed+2) &0xff;
            if (y>127) y-=256; 
            if (x>127) x-=256; 
            
            y+=oldy;
            x+=oldx;
            
            
            v.start.x(oldx);
            v.start.y(oldy);
            v.end.x(x);
            v.end.y(y);
            oldx = x;
            oldy = y;
            v.intensity = intensity;
            if (count!=0)
            {
                list.list.get(count-1).end_connect = v;
                list.list.get(count-1).uid_end_connect = v.uid;
                v.start_connect = list.list.get(count-1);
                v.uid_start_connect = list.list.get(count-1).uid;
                v.start = list.list.get(count-1).end;
            }
            list.list.add(v);
            bytesUsed += 3;
            count++;
        }
        for (GFXVector v: list.list.list)
        {
            if ((v.end_connect != null) && (v.start_connect != null))
                v.setRelativ(true);
        }
        
        list.listEndAddress = list.listStartAddress+bytesUsed;
        saveList(list);
        listsFound.add(list);
    }
    static void doMov_Draw_VL_a(E6809 e6809, Cartridge cart, VecX vecx, String key, int type)
    {
        ScanEntry list = new ScanEntry();
        list.name = cart.cartName;
        list.bank = cart.getCurrentBank();
        list.key = key;
        list.listType = type;
        list.listStartAddress = e6809.reg_x;
        int bytesUsed = 2;
        int count = (e6809.reg_a & 0xff); // count of vectors
        int oldx=0;
        int oldy=0;
        int pattern = 0xff;
        int intensity = vecx.alg_zsh.intValue;
        for (int i=0; i<count; i++)
        {
            int y = vecx.e6809_readOnly8(e6809.reg_x+bytesUsed) &0xff;
            int x = vecx.e6809_readOnly8(e6809.reg_x+bytesUsed+1) &0xff;
            if (y>127) y-=256; 
            if (x>127) x-=256; 
            
            y+=oldy;
            x+=oldx;
            
            GFXVector v = new GFXVector();
            v.start.x(oldx);
            v.start.y(oldy);
            v.end.x(x);
            v.end.y(y);
            oldx = x;
            oldy = y;
            v.intensity = intensity;
            v.pattern = pattern;
            if (i!=0)
            {
                list.list.get(i-1).end_connect = v;
                list.list.get(i-1).uid_end_connect = v.uid;
                v.start_connect = list.list.get(i-1);
                v.uid_start_connect = list.list.get(i-1).uid;
                v.start = list.list.get(i-1).end;
            }
            list.list.add(v);
            bytesUsed += 2;
        }
        for (GFXVector v: list.list.list)
        {
            if ((v.end_connect != null) && (v.start_connect != null))
                v.setRelativ(true);
        }
        list.listEndAddress = list.listStartAddress+bytesUsed;
        saveList(list);
        listsFound.add(list);
    }
    
}
