/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vedi.peeper;

import java.util.ArrayList;

/**
 *
 * @author Malban
 */
public class CombinedPeepRule {
    
    public static final int COMBINE_AND = 0;
    public static final int COMBINE_OR = 1;
    // 
    ArrayList<OnePeepRule> rules = new ArrayList<OnePeepRule>();
    
    
    // comment only
    public boolean isNotRelevant(ASMLine line)
    {
        return (line.mnenomic.length() == 0) && (line.label.length() == 0);
    }
    boolean isTrue(ASMLine line, PeepRule parent, int combiner)
    {
        if (combiner == COMBINE_AND)
        {
            for (OnePeepRule r: rules)
                if (!r.isTrue(line, parent)) return false;
            return true;
        }
        if (combiner == COMBINE_OR)
        {
            for (OnePeepRule r: rules)
                if (r.isTrue(line, parent)) return true;
            return false;
        }
        return false;
    }
}
