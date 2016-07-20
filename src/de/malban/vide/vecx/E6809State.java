/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 *
 * @author malban
 */
public class E6809State implements Serializable{
        /* index registers */
    public int reg_x;
    public int reg_y;
    /* user stack pointer */
    public IntegerPointer reg_u = new IntegerPointer();
    /* hardware stack pointer */
    public IntegerPointer reg_s = new IntegerPointer();
    /* program counter */
    public int reg_pc;
    /* accumulators */
    public int reg_a;
    public int reg_b;
    /* direct page register */
    public int reg_dp;
    /* condition codes */
    public int reg_cc;
    /* flag to see if interrupts should be handled (sync/cwai). */
    public int irq_status;
    public long cyclesRunning;
    
    public ArrayList<Integer> callStack = new  ArrayList<Integer>();
    
    public static void deepCopy(E6809State from, E6809State to)
    {
        to.reg_x = from.reg_x;
        to.reg_y = from.reg_y;
        to.reg_u.intValue = from.reg_u.intValue;
        to.reg_s.intValue = from.reg_s.intValue;
        to.reg_pc = from.reg_pc;
        to.reg_a = from.reg_a;
        to.reg_b = from.reg_b;
        to.reg_dp = from.reg_dp;
        to.reg_cc = from.reg_cc;
        to.irq_status = from.irq_status;
        to.cyclesRunning = from.cyclesRunning;
        synchronized (to.callStack)
        {
            to.callStack.clear();
            for (int i: from.callStack) to.callStack.add(i);
        }
    }
    
}
