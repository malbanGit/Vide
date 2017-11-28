/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;

/**
 *
 * @author malban
 */
public class Profiler implements Serializable 
{
    private static void deInitLock()
    {
        lockMap.clear();
    }
    private static void addLock(int address)
    {
        lockMap.put(address, address);
    }
    private static boolean isLocked(int address)
    {
        return lockMap.get(address) != null;
    }
    public static HashMap<Integer, Integer> lockMap = new HashMap<Integer, Integer>();


    public class ProfilerMemoryLocation
    {   
        public String name="";
        public int address = 0;
//        public boolean counted = false; // prohibit recursion
        public long accessCount=0;
        public long accessCountSum = 0;

        public long accessCycles=0;
        public long accessCyclesSum = 0;
        
        public long caller_accessCyclesSum = 0;
        
        public long lastTrack_accessCount=0;
        public long lastTrack_accessCountSum = 0;
        public long lastTrack_accessCycles=0;
        public long lastTrack_accessCyclesSum = 0;
        public long caller_lastTrack_accessCyclesSum = 0;


        public long lastTrack_accessCount_final=0;
        public long lastTrack_accessCountSum_final = 0;
        public long lastTrack_accessCycles_final=0;
        public long lastTrack_accessCyclesSum_final = 0;

        public long caller_lastTrack_accessCyclesSum_final = 0;

        public void access(long cycles)
        {
            accessCount++;
            accessCountSum++;
            accessCycles+=cycles;
            accessCyclesSum+=cycles;

            lastTrack_accessCount++;
            lastTrack_accessCountSum++;
            lastTrack_accessCycles+=cycles;
            lastTrack_accessCyclesSum+=cycles;
        }
        public void contextAccess(long cycles)
        {
            if (isLocked(address)) return;
            accessCountSum++;
            accessCyclesSum+=cycles;
            lastTrack_accessCountSum++;
            lastTrack_accessCyclesSum+=cycles;
        }
        public void sumAccess(long cycles)
        {
            if (isLocked(address)) return;
            caller_accessCyclesSum+=cycles;
            caller_lastTrack_accessCyclesSum+=cycles;
        }
        
        ProfilerMemoryLocation(String n)
        {
            name = n;
        }
        ProfilerMemoryLocation(int a)
        {
            address = a;
        }
    }

    class Context
    {
        int stackedAddress; // return of subroutine which is on stack
        int stackAddress; // address of stack where the stacked address resides
        int startAddress; // address of first instruction of the subroutine
        int callingAddress; // adress of the instruction that called this context
        ProfilerMemoryLocation mem; // 
    }

    public boolean finalOnly = false;
    public boolean trackingOnly = true;
    public long overallCycles = 0;
    public long overallInstructions = 0;
    public long track_overallCycles = 0;
    public long track_overallInstructions = 0;
    public long track_overallCycles_final = 0;
    public long track_overallInstructions_final = 0;

    public ProfilerMemoryLocation[] memory = new ProfilerMemoryLocation[65536];
    public ArrayList<ProfilerMemoryLocation> routines = new ArrayList<ProfilerMemoryLocation>();
    HashMap<ProfilerMemoryLocation, ProfilerMemoryLocation> routinesMap = new HashMap<ProfilerMemoryLocation, ProfilerMemoryLocation>();

    ArrayList<Context> currentContext = new ArrayList<Context>();

    
    public void trackPointReached()
    {
        for (int i=0; i<65536; i++)
        {
            memory[i].lastTrack_accessCount_final = memory[i].lastTrack_accessCount;
            memory[i].lastTrack_accessCountSum_final = memory[i].lastTrack_accessCountSum;
            memory[i].lastTrack_accessCycles_final = memory[i].lastTrack_accessCycles;
            memory[i].lastTrack_accessCyclesSum_final = memory[i].lastTrack_accessCyclesSum;
            memory[i].caller_lastTrack_accessCyclesSum_final = memory[i].caller_lastTrack_accessCyclesSum;
            
            memory[i].lastTrack_accessCount = 0;
            memory[i].lastTrack_accessCountSum = 0;
            memory[i].lastTrack_accessCycles = 0;
            memory[i].lastTrack_accessCyclesSum = 0;
            memory[i].caller_lastTrack_accessCyclesSum = 0;
        }
        track_overallCycles_final = track_overallCycles;
        track_overallInstructions_final = track_overallInstructions;
        track_overallCycles = 0;
        track_overallInstructions = 0;
    }

    
    public static final int P_MEMORY = 0;
    public static final int P_INIT_SUBROUTINE = 1;
    public static final int P_EXIT_SUBROUTINE = 2;

    public void addName(int address, String name)
    {
        ProfilerMemoryLocation loc = memory[address];
        if (name == null)
            loc.name = "_"+address;
        else
            loc.name = name;
    }
    public void addRoutine(int address, String name)
    {
        ProfilerMemoryLocation loc = memory[address];
        if (routinesMap.get(loc) == null)
        {
            if (name == null)  
            {
                if (loc.name.length()==0)
                    loc.name = "_"+address;
            }
            else
            {
                loc.name = name;
                
            }
            routinesMap.put(loc, loc);
            routines.add(loc);
            
            Collections.sort(routines, new Comparator<ProfilerMemoryLocation>() {
                @Override
                public int compare(ProfilerMemoryLocation p1, ProfilerMemoryLocation p2)
                {
                    return  p1.address - p2.address;
                }
            });

        }
    }
    
    // locking ensures each instruction is counted for each access in each context only once!
    public void accessed(int address, int cycles)
    {
        accessed_internal(address, cycles);
        deInitLock();
    }
    private void accessed_internal(int address, int cycles)
    {
        if (address == -1) return;
        overallCycles+=cycles;
        overallInstructions++;
        track_overallCycles+=cycles;
        track_overallInstructions++;
        
        memory[address].access(cycles);
        addLock(address);
        for (Context c: currentContext)
        {
            c.mem.contextAccess(cycles);

            int callerAddress = c.callingAddress;
            if (callerAddress != -1)
            {
                memory[callerAddress].sumAccess(cycles);
                addLock(callerAddress);
            }
        }
    }
    
    // address - of subroutines first instruction
    // stackAddress - address of the stackpointer where the return address resided
    // returnAdress - adress that was pushed onto stack as return address
    public void addContext(int address, int stackAddress, int returnAddress, int callerAddress)
    {
        ProfilerMemoryLocation loc = memory[address];
        Context c = new Context();

        addRoutine(address, null);
        c.mem = loc;
        c.stackAddress = stackAddress;
        c.stackedAddress = returnAddress;
        c.startAddress = address;
        c.callingAddress = callerAddress;
        
        currentContext.add(c);
    }

    public void removeContext()
    {
        if (currentContext.size() <= 1) return;
        currentContext.remove(currentContext.size()-1);
    }

    // needs stack access
    public void checkContext(VecX vecx)
    {
        // look if stack frame still contains the context
        int index = currentContext.size()-1;
        while (index >= 1)
        {
            boolean contextOK = true;
            Context c = currentContext.get(index);
            if (vecx.e6809.reg_s.intValue>c.stackAddress) 
            {
                // stack is not correct anymore
                // the stack address is higher than our return address
                // that means it is not reachable via a pull/rts
                // if anyone "saved" an old stack and later sets it again -> this delivers false info
                // but how do you want to automatically check that?
                contextOK = false;
            }

            int sAddress = vecx.e6809_readOnly8(c.stackAddress)*256+vecx.e6809_readOnly8(c.stackAddress+1);
            if (sAddress != c.stackedAddress)
            {
                // address on stack is not the same return adress anymore ->
                // I assume here that somehow the routine was "cancled"
                contextOK = false;
            }
            if (contextOK) break;
            removeContext();
            index--;
        }
    }

    private Profiler(int startAddress, String n)
    {
        for (int i=0; i<65536; i++)
        {
            memory[i] = new ProfilerMemoryLocation(i);
        }
        
        ProfilerMemoryLocation loc = memory[startAddress];
        loc.name = n;
        
        Context c = new Context();
        c.mem = loc;
        c.stackAddress = -1;
        c.stackedAddress = -1;
        c.startAddress = -1;
        c.callingAddress = -1;
        currentContext.add(c);
    }
    public static Profiler buildProfiler(int startAddress)
    {
        return new Profiler(startAddress, "main");
    }
    public static Profiler buildProfiler(int startAddress, String n)
    {
        return new Profiler(startAddress, n);
    }
}

