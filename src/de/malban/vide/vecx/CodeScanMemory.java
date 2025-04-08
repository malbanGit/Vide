/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx;

import java.util.ArrayList;

/**
 *
 * @author malban
 */
public class CodeScanMemory {
    
    public MemInfo[] mem = new MemInfo[65536];
    ArrayList<MemInfo[]> allBankMem = new ArrayList<MemInfo[]>();
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
        public static final int MEMORY_READ = 2;  // memory was read, this will also be set, if mem is code, since code is always read!
        public static final int MEMORY_WRITE = 4; // memory (tried) write
        public static final int MEMORY_CODE_PART = 8;  // pc was here
        public ArrayList<Integer> readAccess; 
        public ArrayList<Integer> writeAccess; 
        public int codeScanType = MEMORY_UNKOWN;
        public int dp = 0xff;
        public void addAccess(int address, int dp, int type)
        {
            codeScanType = codeScanType | type;
            this.dp = dp;
            if ((type & MEMORY_CODE) == MEMORY_CODE)
            {
                codeScanType = codeScanType & (~MEMORY_READ);

                if (readAccess==null) readAccess = new ArrayList<Integer>();
                if (!readAccess.contains(address)) readAccess.add(address);
            }
            if ((type & MEMORY_CODE) == MEMORY_CODE_PART)
            {
                codeScanType = codeScanType & (~MEMORY_READ);
                codeScanType = codeScanType & (~MEMORY_CODE);

                if (readAccess==null) readAccess = new ArrayList<Integer>();
                if (!readAccess.contains(address)) readAccess.add(address);
            }
            if ((type & MEMORY_READ) == MEMORY_READ)
            {
                if (readAccess==null) readAccess = new ArrayList<Integer>();
                if (!readAccess.contains(address)) readAccess.add(address);
            }
            if ((type & MEMORY_WRITE) == MEMORY_WRITE)
            {
                if (writeAccess==null) writeAccess = new ArrayList<Integer>();
                if (!writeAccess.contains(address)) writeAccess.add(address);
            }
        }
    }
}
