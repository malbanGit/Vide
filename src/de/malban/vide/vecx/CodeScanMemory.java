/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx;

import java.util.ArrayList;

/**
 *
 * @author chrissalo
 */
public class CodeScanMemory {
    
    public MemInfo[] mem = new MemInfo[65536];
    ArrayList<MemInfo[]> allBankMem = new ArrayList<>();
    int currentBank =0;
    public static CodeScanMemory getCodeScanMemory()
    {
        return new CodeScanMemory();
    }
    public int getBankCount()
    {
        return allBankMem.size();
    }
    public void setCurrentBank(int b)
    {
        while (b >=allBankMem.size())
        {
            mem = new MemInfo[65536];
            for(int i=0;i<65536; i++)
                mem[i] = new MemInfo();
            allBankMem.add(mem);
        }
        currentBank = b;
        mem = allBankMem.get(currentBank);
    }
    private CodeScanMemory()
    {
        reset();
    }
    public void reset()
    {
        allBankMem.clear();
        for(int i=0;i<65536; i++)
            mem[i] = new MemInfo();
        allBankMem.add(mem);
    }
    
    
    public static class MemInfo
    {
        // codeScan 
        public static final int MEMORY_UNKOWN = 0;
        public static final int MEMORY_CODE = 1;  // pc was here
        public static final int MEMORY_READ = 2;  // memory was read, this will also be set, if mem is code, since code is allways read!
        public static final int MEMORY_WRITE = 4; // memory (tried) write
        public ArrayList<Integer> readAccess; 
        public ArrayList<Integer> writeAccess; 
        public int codeScanType = MEMORY_UNKOWN;
        public void addAccess(int address, int type)
        {
            codeScanType = codeScanType | type;
            if ((type & 3) != 0)
            {
                if (readAccess==null) readAccess = new ArrayList<Integer>();
                if (!readAccess.contains(address))
                    readAccess.add(address);
            }
            if ((type & 1) != 0)
            {
                if (writeAccess==null) writeAccess = new ArrayList<Integer>();
                if (!writeAccess.contains(address))
                    writeAccess.add(address);
            }
        }
    }
}
