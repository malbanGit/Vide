/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.dissy;

import static de.malban.vide.dissy.MemoryInformation.DIS_TYPE_DATA_INSTRUCTION_1_LENGTH;
import static de.malban.vide.dissy.MemoryInformation.DIS_TYPE_DATA_INSTRUCTION_GENERAL;
import static de.malban.vide.dissy.MemoryInformation.DIS_TYPE_UNKOWN;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.zip.CRC32;

/**
 *
 * @author malban
 */
public class Memory {
    // the complete known (and perhaps unkown) memory map

    public HashMap<Integer, MemoryInformation> memMap;
    public HashMap<Integer, HashMap<Integer, String>> directLabels;   // all labels this adress has

    int maxBank = 1;
    int currentBank = 0;
    int highestUserRAM = -1;
    
    class OneBank
    {
        public HashMap<Integer, MemoryInformation> memMap = new HashMap<Integer, MemoryInformation>();
        public HashMap<Integer, HashMap<Integer, String>> directLabels = new HashMap<Integer, HashMap<Integer, String>>();   // all labels this adress has
    }
    ArrayList<OneBank> allBanks=new ArrayList<OneBank>();
    
    public Memory()
    {
        allBanks.add(new OneBank());
        setBank(0);
    }
    
    public void resetAllBreakPoints()
    {
        for (OneBank bank : allBanks)
        {
            for (int a=0; a< 65536; a++)
            {
                MemoryInformation memInfo = memMap.get(a);
                if (memInfo != null)
                {
                    memInfo.resetBreakPoints();
                }
            }
        }
    }
    
    public int getCurrentBank()
    {
        return currentBank;
    }
    public void setBank(int b)
    {
        setBank(b, false);
    }
    public int getMaxBank()
    {
        return maxBank;
    }
    public HashMap<Integer, MemoryInformation> getBankMemory(int bank)
    {
        if (bank > maxBank-1) 
            return null;

        
        HashMap<Integer, MemoryInformation> memMap2 = allBanks.get(bank).memMap;
        return memMap2;
    }
    
    // used for RAM hack
    public void setToAllBanks(byte b, int address)
    {
        for (OneBank bank : allBanks)
        {
            MemoryInformation memInfo = memMap.get(address);
            if (memInfo == null) 
            {
                memMap.put(address, new MemoryInformation(address, b));            
                memInfo = memMap.get(address);
            }
            memInfo.content = b;
        }
    }
    
    public void setBank(int b, boolean addBank)
    {
        if ((b > maxBank-1) && (addBank))
        {
            if (b > maxBank) return; // only one bank at a time
            allBanks.add(new OneBank());
            maxBank++;
            currentBank = b%maxBank;
            memMap  = allBanks.get(currentBank).memMap;
            directLabels  = allBanks.get(currentBank).directLabels;
            init();
            return;
        }
        currentBank = b%maxBank;
        memMap  = allBanks.get(currentBank).memMap;
        directLabels  = allBanks.get(currentBank).directLabels;
    }
    
    // creates bank if neccessary!
    public MemoryInformation get(int adr, int bank)
    {
        while (bank > maxBank-1)
        {
            int saveCurrent = currentBank;
            allBanks.add(new OneBank());
            maxBank++;
            currentBank = bank%maxBank;
            memMap  = allBanks.get(currentBank).memMap;
            directLabels  = allBanks.get(currentBank).directLabels;
            init();
            // restore current settings
            currentBank = saveCurrent;
            memMap  = allBanks.get(currentBank).memMap;
            directLabels  = allBanks.get(currentBank).directLabels;
        }
            
        return allBanks.get(bank).memMap.get(adr);
    }
    public void reset()
    {
        maxBank=1;
        allBanks.clear();
        allBanks.add(new OneBank());
        setBank(0);
    }
    
    // loaded memory
    public MemoryInformation buildMemInfo(int adr, byte mem)
    {
        if (memMap.get(adr) == null) 
        {
            memMap.put(adr, new MemoryInformation(adr, mem));            
        }
        else 
            memMap.get(adr).content = mem;
        
        // something that is LOADED into mem, is at least a byte? But defenitly not unkown
        if (adr < 0xe000)
            if (memMap.get(adr).disType == MemoryInformation.DIS_TYPE_UNKOWN)
                memMap.get(adr).disType = MemoryInformation.DIS_TYPE_LOADED;
        
        return memMap.get(adr);
    }
    public void init()
    {
        // build a complete memory map
        for (int i=0; i< 65536; i++)
        {
             buildMemInfo(i);
        }
    }
    
    // unkown memory
    public MemoryInformation buildMemInfo(int adr)
    {
        if (memMap.get(adr) == null) 
        {
            memMap.put(adr, new MemoryInformation(adr, (byte)0));            
        }
        return memMap.get(adr);
    }
    

    // unkown memory
    public MemoryInformation buildMemInfo(int adr, int bank)
    {
        while (bank > maxBank-1)
        {
            int saveCurrent = currentBank;
            allBanks.add(new OneBank());
            maxBank++;
            currentBank = bank%maxBank;
            memMap  = allBanks.get(currentBank).memMap;
            directLabels  = allBanks.get(currentBank).directLabels;
            init();
            // restore current settings
            currentBank = saveCurrent;
            memMap  = allBanks.get(currentBank).memMap;
            directLabels  = allBanks.get(currentBank).directLabels;
        }
        
        if (allBanks.get(bank).memMap.get(adr) == null) 
        {
            allBanks.get(bank).memMap.put(adr, new MemoryInformation(adr, (byte)0));            
        }
        return allBanks.get(bank).memMap.get(adr);
    }
    
    
    public long getCRC(int start, int end)
    {
        if (end<=start) return -1;
        if (start <0) return -1;
        CRC32 localCRC32 = new CRC32();
        for (int i=start; i<end; i++)
            localCRC32.update(memMap.get(i).content);
        return localCRC32.getValue();
    }
    public boolean labelsChanged(MemoryInformation memInfo, ArrayList<String> oldLabels)
    {
        boolean changeRelevant = false;
        ArrayList<String> newLabels = memInfo.labels;
        
        // are all old Labels still available?
        for (String oldLabel: oldLabels)
        {
            if (newLabels.contains(oldLabel)) continue;
            changeRelevant = true;

            // mark memory with "not done" on
            // not any longer available labels
            // reDisassembly should take care of the rest later...
            invalidateLabel(oldLabel);
        }
        for (String oldLabel: newLabels)
        {
            if (oldLabels.contains(oldLabel)) continue;
            changeRelevant = true;
        }
        if (!changeRelevant) return false;
        
        return changeRelevant;
    }
    private void invalidateLabel(String oldLabel)
    {
        for (int i=0; i< 65536; i++)
        {
            MemoryInformation memInfo = memMap.get(i);
            if (memInfo == null) continue;
            if (memInfo.disType == DIS_TYPE_UNKOWN) continue;
            
            // this may be to much,
            // but rather mark a few to many locations
            // than miss some, or have a hellufanalgorhythm to get correct comparisson
            if (memInfo.disassembledOperand.contains(oldLabel))
            {
                memInfo.done = false;
                memInfo.disassembledMnemonic = "";
                memInfo.disassembledOperand = "";
                if (memInfo.disType >= DIS_TYPE_DATA_INSTRUCTION_1_LENGTH)
                {
                    memInfo.disType = DIS_TYPE_DATA_INSTRUCTION_GENERAL;
                }
            }
        }
    }
    
}
