/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vedi.peeper;

import de.malban.Global;
import de.malban.config.Configuration;
import de.malban.gui.panels.LogPanel;
import static de.malban.gui.panels.LogPanel.WARN;
import de.malban.util.XMLSupport;
import static de.malban.vide.vedi.peeper.CombinedPeepRule.COMBINE_AND;
import static de.malban.vide.vedi.peeper.CombinedPeepRule.COMBINE_OR;
import static de.malban.vide.vedi.peeper.OnePeepRule.RULE_FIRST_OPERAND_EQUALS;
import static de.malban.vide.vedi.peeper.OnePeepRule.RULE_FIRST_OPERAND_NOTEQUALS;
import static de.malban.vide.vedi.peeper.OnePeepRule.RULE_FIRST_REG_NOTCONTAINS;
import static de.malban.vide.vedi.peeper.OnePeepRule.RULE_IS_EXTENED;
import static de.malban.vide.vedi.peeper.OnePeepRule.RULE_IS_IMMEDIATE;
import static de.malban.vide.vedi.peeper.OnePeepRule.RULE_IS_LOAD;
import static de.malban.vide.vedi.peeper.OnePeepRule.RULE_IS_STORE;
import static de.malban.vide.vedi.peeper.OnePeepRule.RULE_MNEMONIC_CONTAINS;
import static de.malban.vide.vedi.peeper.OnePeepRule.RULE_NO_BRANCH;
import static de.malban.vide.vedi.peeper.OnePeepRule.RULE_NO_INDEX_CHANGE;
import static de.malban.vide.vedi.peeper.OnePeepRule.RULE_NO_REGISTER_CHANGE;
import static de.malban.vide.vedi.peeper.OnePeepRule.RULE_OPERAND_ALL_EQUALS;
import static de.malban.vide.vedi.peeper.OnePeepRule.RULE_ORG_LINE_CONTAINS;
import static de.malban.vide.vedi.peeper.OnePeepRule.RULE_PAGE_EQUALS;
import static de.malban.vide.vedi.peeper.OnePeepRule.RULE_SECOND_OPERAND_EQUALS;
import static de.malban.vide.vedi.peeper.OnePeepRule.RULE_SECOND_OPERAND_NOTEQUALS;
import static de.malban.vide.vedi.peeper.OnePeepRule.RULE_SECOND_REG_NOTCONTAINS;
import static de.malban.vide.vedi.peeper.OnePeepRule.RULE_STORE_LOAD_REG_EQUALS;
import static de.malban.vide.vedi.peeper.OnePeepRule.RULE_STORE_LOAD_REG_NOTEQUALS;
import java.io.File;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Vector;

/**
 * TODO make configurable -> load save works, but no editor yet
 * 
 * What it does:
 * 
 * Always 10 lines of source code are loaded and investigated. 
 * The Source is searched for patterns, if the patterns match for all rules one peephole has, the
 * "replace" mechanism is triggered.
 * 
 * Lines
 * The lines loaded are investigated whether they contain assembler statements (mnemonics) - only lines which
 * countain assembler statesments are further investigated.
 * All "mnemonic" lines of the loaded 10 lines are numbered from 0-10 (if there are non assembler lines
 * in between, the numbering is DIFFERENT from those lines loaded).
 * 
 * All loaded "comment" only lines are placed IN FRONT of the resulting peephole code (if peephole applies).
 * If within the lines of a found peephole there are any labels discovered, the peephole is discarded, since it
 * can not be assured, the the label will be at the semantically same position as before.
 * 
 * If a peephole is triggered, the old lines will be replaced as defined in the result section of the peephole.
 * The original lines will be added at the end of the newly generated lines as commentary lines with "; ORG>" in front of them.
 * 
 * 
 * Rules
 * Rules (OnePeepRule.java) is one compare or "question" with a true false result.
 * These single rules can be combined to "CombinedRules.java". Combined rules can have an arbitrary number of rules.
 * One CombinedRule combines its "inner" "OnePeepRules" either with "OR" or "AND".
 * 
 * One Peephole can have an arbitrary number of "CombinedRules".
 * 
 * An assembler line is investigated for following facts (see ASMLine.java):
 * (every string is converted to lower case)
 * - mnemonic
 * - label
 * - comment
 * - org (original complete line)
 * - clean (original line without comment)
 * - first (first operand as a string)
 * - second (second operand as a string)
 * - operandAll (the complete operand string)
 * - firstReg (Register information about first operand, can be compared with "contains" - it can contain values like "abd", "x", "y" ...)
 * - secondReg (Register information about second operand, can be compared with "contains" - it can contain values like "abd", "x", "y" ...)
 * - storeLoadReg register that is instruction inherent (like LDA -> A, STY -> Y ...)
 * - isStore (mnemonic starts with "st")
 * - isLoad (mnemonic starts with "ld")
 * - isLea (mnemonic starts with "lea")
 * - isImmediate (value is loaded with a "#")
 * - isBranch (instruction is a branch, pul# pc is not recognized yet)
 * - isRegSave (instruction does not change a register)
 * - isIndexChange (instruction contains a -y, --y, y+, y++ for any index register)
 * - isExtended (is the instruction one with extended addressing)
 * - page (if extended, than this is the extended address/256, -1 otherwise)
 * 
 * Most of these facts can be compared to with a rule, following rules-compares exist (see OnePeepRule.java):
        "RULE_NONE",
        "RULE_MNEMONIC_CONTAINS",
        "RULE_FIRST_OPERAND_EQUALS",
        "RULE_SECOND_OPERAND_EQUALS",
        "RULE_FIRST_REG_CONTAINS",
        "RULE_SECOND_REG_CONTAINS",
        "RULE_IS_LOAD",
        "RULE_OPERAND_ALL_EQUALS",
        "RULE_OPERAND_ALL_CONTAINS",
        "RULE_STORE_LOAD_REG_EQUALS",
        "RULE_ORG_LINE_CONTAINS",
        "RULE_IS_STORE",
        "RULE_IS_LEA",
        "RULE_FIRST_REG_NOTCONTAINS",
        "RULE_SECOND_REG_NOTCONTAINS",
        "RULE_NO_INDEX_CHANGE",
        "RULE_STORE_LOAD_REG_NOTEQUALS",
        "RULE_FIRST_OPERAND_NOTEQUALS",
        "RULE_SECOND_OPERAND_NOTEQUALS",
        "RULE_NO_BRANCH",
        "RULE_NO_REGISTER_CHANGE",
        "RULE_IS_IMMEDIATE"
        "RULE_IS_EXTENED",
        "RULE_PAGE_EQUALS"
 * 
 * A rule is always aplied to one specific line. Example:
        OnePeepRule r1a = new OnePeepRule(RULE_MNEMONIC_CONTAINS, "tfr",0);
        OnePeepRule r1b = new OnePeepRule(RULE_FIRST_OPERAND_EQUALS, "d",0);
        CombinedPeepRule c1 = new CombinedPeepRule(r1a, r1b, COMBINE_AND,0);
 *
 * This combined rule consists of two single rules. The single rules (r1a and r1b) are combined with an "AND" and are applied to line "0" (last parameter of the CombinedRule).
 * Both rules are very simple - they "ask" simple question, simplyfied they check if the first assembler line is of the kind "... tfr d ...".
 *
 * 
        OnePeepRule r2a = new OnePeepRule(RULE_MNEMONIC_CONTAINS, "exg",0);
        OnePeepRule r2b = new OnePeepRule(RULE_FIRST_OPERAND_EQUALS, "d",0);
        OnePeepRule r2c = new OnePeepRule(RULE_SECOND_OPERAND_EQUALS, "%0o2",0);
        CombinedPeepRule c2 = new CombinedPeepRule(r2a, r2b, r2c, COMBINE_AND,1);
 * 
 * First part of the rule is nearly the same. The third single rule does a compare with a previous line.
 * To do this placeholders are used.
 * 
 * Placeholder
 * Placeholders can be used to compare parts of one assembler line with parts of other assembler lines.
 * - each placeholder starts with a "%" (percent)
 * - followed by the line that the placehodler denotes (zero based - MNEMONIC containing lines! (see above)).
 * - followed by an identifier to what part of the original line it refers to,
 * 
 * Identifier
 * - m mnemonic
 * - o1 first (as defined above)
 * - o2 second (as defined above)
 * - r1 firstReg (as defined above)
 * - r2 secondReg (as defined above)
 * - oAll operandAll (as defined above)
 * - rsl storeLoadReg (as defined above)
 * - org org (as defined above)
 * - comment comment (as defined above)
 * 
 * Result
 * If a peephole is discovered as being valid (all CombinedRules are true) - the sourcecode is changed, and the "result" of a peephole is applied.
 * A peephole can have an arbitrary number of results (lines).
 * Each "OneResult" represents one output line.
 * The outputline is generated with the same identifiers as given above.
 * 
 * E.g.
 * 
        OneResult e1 = new OneResult(0,"%2org");
        OneResult e2 = new OneResult(0," tfr d,%0o2");
        OneResult e3 = new OneResult(0,"%4org");
 *
 * These result definition outputs 3 lines.
 * 1) the original 3rd line (zero base line count)
 * 2) a new line "tfr d," + the second operand of the first line.
 * 3) the original 4th line (zero base line count) 
 * 
 * Have fun!
 * 
 * @author malban
 */

public class FilePeeper 
{
    public static ArrayList<PeepRule> peepers = new ArrayList<PeepRule>();
    public static int peepsFound=0;

    // order of peeps is important so that better peeps can
    // have priority!
    static
    {
        /*
            isOne = isOne && ((l1.mnenomic.equals("tfr")) && (l1.first.equals("d")));
            isOne = isOne && ((l2.mnenomic.equals("exg")) && (l2.first.equals("d")) && (l2.second.equals(l1.second)));
            isOne = isOne && (l3.mnenomic.equals("addd"));
            isOne = isOne && ((l4.mnenomic.equals("exg")) && (l4.first.equals("d")) && (l4.second.equals(l1.second)));
            isOne = isOne && ( (l5.mnenomic.equals("std")) || (l5.mnenomic.equals("cmpd")));
        
->        

            outLines.add("; Peep 1 (error)");
            if (l1.label.length()>0) outLines.add(l1.label+":");
            if (l2.label.length()>0) outLines.add(l2.label+":");
            outLines.add(l3.org);
            if (l4.label.length()>0) outLines.add(l4.label+":");
            outLines.add(" tfr d,"+l1.second);
            outLines.add(l5.org);
            i+=4;
            peepsFound++;
        

        */
        OnePeepRule r1a = new OnePeepRule(RULE_MNEMONIC_CONTAINS, "tfr",0);
        OnePeepRule r1b = new OnePeepRule(RULE_FIRST_OPERAND_EQUALS, "d",0);
        CombinedPeepRule c1 = new CombinedPeepRule(r1a, r1b, COMBINE_AND,0);

        OnePeepRule r2a = new OnePeepRule(RULE_MNEMONIC_CONTAINS, "exg",0);
        OnePeepRule r2b = new OnePeepRule(RULE_FIRST_OPERAND_EQUALS, "d",0);
        OnePeepRule r2c = new OnePeepRule(RULE_SECOND_OPERAND_EQUALS, "%0o2",0);
        CombinedPeepRule c2 = new CombinedPeepRule(r2a, r2b, r2c, COMBINE_AND,1);
        
        OnePeepRule r3a = new OnePeepRule(RULE_MNEMONIC_CONTAINS, "addd",0);
        CombinedPeepRule c3 = new CombinedPeepRule(r3a, COMBINE_AND,2);

        OnePeepRule r4a = new OnePeepRule(RULE_MNEMONIC_CONTAINS, "exg",0);
        OnePeepRule r4b = new OnePeepRule(RULE_FIRST_OPERAND_EQUALS, "d",0);
        OnePeepRule r4c = new OnePeepRule(RULE_SECOND_OPERAND_EQUALS, "%0o2",0);
        CombinedPeepRule c4 = new CombinedPeepRule(r4a, r4b, r4c, COMBINE_AND,3);

//        OnePeepRule r5a = new OnePeepRule(RULE_MNEMONIC_CONTAINS, "std",0);
//        OnePeepRule r5b = new OnePeepRule(RULE_MNEMONIC_CONTAINS, "cmpd",0);
//        CombinedPeepRule c5 = new CombinedPeepRule(r5a, r5b, COMBINE_OR,4);
        
        ArrayList<CombinedPeepRule> ru = new ArrayList<CombinedPeepRule>();
        ru.add(c1);ru.add(c2);ru.add(c3);ru.add(c4);//ru.add(c5);

        OneResult e1 = new OneResult(0,"%2org");
        OneResult e2 = new OneResult(1," tfr d,%0o2");
//        OneResult e3 = new OneResult(2,"%4org");
        ArrayList<OneResult> re = new ArrayList<OneResult>();
        re.add(e1);re.add(e2);//re.add(e3);

        PeepRule gccPeep = new PeepRule(0, "bug1", "gcc does one exg to many",3, ru , re);
        peepers.add(gccPeep);
        
        
/*
        
                // st#  bla
                // ; comments
                // NOT LABEL
                // ld#  bla        
                isTwo = isTwo && (l1.isStore);
                if (l2.mnenomic.length()!=0)
                {
                    isTwo = isTwo && l2.label.length()==0;
                    isTwo = isTwo && (l2.isLoad);
                    isTwo = isTwo && (l2.operandAll.equals(l1.operandAll));
                    isTwo = isTwo && (l2.storeLoadReg.equals(l1.storeLoadReg));
                    tmp.add(l2);
                }        

        
        ->
                outLines.add("; Peep 2");
                outLines.add(l1.org);
                for (int ii=0; ii<tmp.size()-1;ii++)
                    outLines.add(tmp.get(ii).org);
               

*/
        
        r1a = new OnePeepRule(RULE_IS_STORE, 0);
        c1 = new CombinedPeepRule(r1a, 0);

        r2a = new OnePeepRule(RULE_IS_LOAD, 0);
        r2b = new OnePeepRule(RULE_OPERAND_ALL_EQUALS, "%0oAll",0);
        r2c = new OnePeepRule(RULE_STORE_LOAD_REG_EQUALS, "%0rsl",0);
        OnePeepRule r2d = new OnePeepRule(RULE_NO_INDEX_CHANGE,0);
        c2 = new CombinedPeepRule(r2a, r2b, r2c, r2d, COMBINE_AND,1);
        
        ru = new ArrayList<CombinedPeepRule>();
        ru.add(c1);ru.add(c2);

        e1 = new OneResult(0,"%0org");
        re = new ArrayList<OneResult>();
        re.add(e1);

        gccPeep = new PeepRule(1, "2", "no load after store",1, ru , re);
        peepers.add(gccPeep);        
        
        
        
        
        
        
        
        
        
        
        
        
              
/*
            // ld#  bla
            // ; comments
            // NO LABEL
            // ld#  bla        
            
            // attention
            // ldx #sjsjs
            // ldx ,x
            // !!!
            
            if (!found) 
            {
                isThree = true;
                tmp.clear();
                isThree = isThree && (l1.isLoad);
                if (l2.mnenomic.length()!=0)
                {
                    isThree = isThree && l2.label.length()==0;
                    isThree = isThree && (l2.isLoad);
                    isThree = isThree && (l2.storeLoadReg.equals(l1.storeLoadReg));

                    isThree = isThree && (! ((l2.firstReg.contains(l2.storeLoadReg)) || (l2.secondReg.contains(l2.storeLoadReg)) ));
                    
                    tmp.add(l2);
        
        ->
                outLines.add("; Peep 3");
                if (l1.label.length()>0) outLines.add(l1.label+":");
                for (int ii=0; ii<tmp.size();ii++)
                    outLines.add(tmp.get(ii).org);
                
                i+=tmp.size();
                peepsFound++;

                outLines.add("; "+l1.org);
                for (int ii=0; ii<tmp.size();ii++)
                    outLines.add("; "+tmp.get(ii).org);

               

*/
        
        r1a = new OnePeepRule(RULE_IS_LOAD, 0);
        c1 = new CombinedPeepRule(r1a, 0);

        r2a = new OnePeepRule(RULE_IS_LOAD, 0);
        r2b = new OnePeepRule(RULE_STORE_LOAD_REG_EQUALS, "%0rsl",0);
        r2c = new OnePeepRule(RULE_FIRST_REG_NOTCONTAINS, "%1rsl",0);
        r2d = new OnePeepRule(RULE_SECOND_REG_NOTCONTAINS, "%1rsl",0);
        OnePeepRule r2e = new OnePeepRule(RULE_NO_INDEX_CHANGE,0);
        c2 = new CombinedPeepRule(r2a, r2b, r2c, r2d, r2e, COMBINE_AND,1);
        
        ru = new ArrayList<CombinedPeepRule>();
        ru.add(c1);ru.add(c2);

        e1 = new OneResult(0,"%1org");
        re = new ArrayList<OneResult>();
        re.add(e1);

        gccPeep = new PeepRule(2, "3", "no double load of same register",1, ru , re);
        peepers.add(gccPeep);        
        
        
        
        

/*
 
                    
            //  tfr	d,x	; , ySpeed
            //	exg	d,x	; , ySpeed            
            if (!found) 
            {
                isFour = true;
                tmp.clear();
                isFour = isFour && l2.label.length()==0;
                isFour = isFour && (l1.mnenomic.equals("tfr"));
                isFour = isFour && (   ((l2.mnenomic.equals("exg")) && (l2.first.equals(l1.first)) &&  (l2.second.equals(l1.second)))
                                    || ((l2.mnenomic.equals("exg")) && (l2.first.equals(l1.second)) && (l2.second.equals(l1.first))) );

                if (isFour)
                {
                    isFourA = true;
                    // tfr	d,x	; , ySpeed
                    // exg	d,x	; , ySpeed
                    // leay	d,y	;  tmp49,, tmp49
                    // exg	d,x	; , ySpeed                
                    isFour = isFour && l3.label.length()==0;
                    isFour = isFour && l4.label.length()==0;
                    
                    isFourA = isFourA && (l3.mnenomic.startsWith("lea"));
                    isFourA = isFourA && (   ((l4.mnenomic.equals("exg")) && (l4.first.equals(l1.first)) &&  (l4.second.equals(l1.second)))
                                          || ((l4.mnenomic.equals("exg")) && (l4.first.equals(l1.second)) && (l4.second.equals(l1.first))) );
                    
                    isFourA = isFourA && (!l1.first.toLowerCase().equals(l3.storeLoadReg));
                    isFourA = isFourA && (!l1.second.toLowerCase().equals(l3.storeLoadReg));
                    
                    
                    if (isFourA) isFour = false;
                }
   
                
                
                found = found |isFour|isFourA;
            }
               
        
        ->

            else if (isFour)
            {
                outLines.add("; Peep 4");
                outLines.add(l1.org);
                if (l2.label.length()>0) outLines.add(l2.label+":");
                i+=1;
                peepsFound++;
                outLines.add("; "+l1.org);
                outLines.add("; "+l2.org);
            }
            else if (isFourA)
            {
                outLines.add("; Peep 4a");
                outLines.add(l1.org);
                if (l2.label.length()>0) outLines.add(l2.label+":");
                outLines.add(l3.org);
                if (l4.label.length()>0) outLines.add(l4.label+":");
                i+=3;
                peepsFound++;
                outLines.add("; "+l1.org);
                outLines.add("; "+l2.org);
                outLines.add("; "+l3.org);
                outLines.add("; "+l4.org);
*/
        
        // --- 4-1a
        r1a = new OnePeepRule(RULE_MNEMONIC_CONTAINS, "tfr",0);
        c1 = new CombinedPeepRule(r1a,0);

        r2a = new OnePeepRule(RULE_MNEMONIC_CONTAINS, "exg",0);
        r2b = new OnePeepRule(RULE_SECOND_OPERAND_EQUALS, "%0o1",0);
        r2c = new OnePeepRule(RULE_FIRST_OPERAND_EQUALS, "%0o2",0);
        c2 = new CombinedPeepRule(r2a, r2b, r2c, COMBINE_AND,1);
        
        r3a = new OnePeepRule(RULE_MNEMONIC_CONTAINS, "lea",0);
        c3 = new CombinedPeepRule(r3a,2);

        r4a = new OnePeepRule(RULE_MNEMONIC_CONTAINS, "exg",0);
        r4b = new OnePeepRule(RULE_SECOND_OPERAND_EQUALS, "%0o1",0);
        r4c = new OnePeepRule(RULE_FIRST_OPERAND_EQUALS, "%0o2",0);
        c4 = new CombinedPeepRule(r4a,r4b,r4c,COMBINE_AND,3);
        
        OnePeepRule r5a = new OnePeepRule(RULE_FIRST_OPERAND_NOTEQUALS, "%2rsl",0);
        OnePeepRule r5b = new OnePeepRule(RULE_SECOND_OPERAND_NOTEQUALS, "%2rsl",0);
        CombinedPeepRule c5 = new CombinedPeepRule(r5a,r5b,COMBINE_AND,1);
        
        
        ru = new ArrayList<CombinedPeepRule>();
        ru.add(c1);ru.add(c2);ru.add(c3);ru.add(c4);ru.add(c5);

        e1 = new OneResult(0,"%0org");
        e2 = new OneResult(1,"%2org");
        re = new ArrayList<OneResult>();
        re.add(e1);re.add(e2);

        gccPeep = new PeepRule(3, "4-1a", "tfr exg 1=2, 2=1, 2. exg 1=2, 2=1",3, ru , re);
        peepers.add(gccPeep);                
                
        // ---4-1b
        r1a = new OnePeepRule(RULE_MNEMONIC_CONTAINS, "tfr",0);
        c1 = new CombinedPeepRule(r1a,0);

        r2a = new OnePeepRule(RULE_MNEMONIC_CONTAINS, "exg",0);
        r2b = new OnePeepRule(RULE_SECOND_OPERAND_EQUALS, "%0o1",0);
        r2c = new OnePeepRule(RULE_FIRST_OPERAND_EQUALS, "%0o2",0);
        c2 = new CombinedPeepRule(r2a, r2b, r2c, COMBINE_AND,1);
        
        r3a = new OnePeepRule(RULE_MNEMONIC_CONTAINS, "lea",0);
        c3 = new CombinedPeepRule(r3a,2);

        r4a = new OnePeepRule(RULE_MNEMONIC_CONTAINS, "exg",0);
        r4b = new OnePeepRule(RULE_SECOND_OPERAND_EQUALS, "%0o2",0);
        r4c = new OnePeepRule(RULE_FIRST_OPERAND_EQUALS, "%0o1",0);
        c4 = new CombinedPeepRule(r4a,r4b,r4c,COMBINE_AND,3);
        
        r5a = new OnePeepRule(RULE_FIRST_OPERAND_NOTEQUALS, "%2rsl",0);
        r5b = new OnePeepRule(RULE_SECOND_OPERAND_NOTEQUALS, "%2rsl",0);
        c5 = new CombinedPeepRule(r5a,r5b,COMBINE_AND,1);
        
        
        ru = new ArrayList<CombinedPeepRule>();
        ru.add(c1);ru.add(c2);ru.add(c3);ru.add(c4);ru.add(c5);

        e1 = new OneResult(0,"%0org");
        e2 = new OneResult(1,"%2org");
        re = new ArrayList<OneResult>();
        re.add(e1);re.add(e2);

        gccPeep = new PeepRule(4, "4-1b", "tfr exg 1=2, 2=1, 2. exg 1=1, 2=2",3, ru , re);
        peepers.add(gccPeep);                
        
                
       // --- 4-2a
        r1a = new OnePeepRule(RULE_MNEMONIC_CONTAINS, "tfr",0);
        c1 = new CombinedPeepRule(r1a,0);

        r2a = new OnePeepRule(RULE_MNEMONIC_CONTAINS, "exg",0);
        r2b = new OnePeepRule(RULE_SECOND_OPERAND_EQUALS, "%0o2",0);
        r2c = new OnePeepRule(RULE_FIRST_OPERAND_EQUALS, "%0o1",0);
        c2 = new CombinedPeepRule(r2a, r2b, r2c, COMBINE_AND,1);
        
        r3a = new OnePeepRule(RULE_MNEMONIC_CONTAINS, "lea",0);
        c3 = new CombinedPeepRule(r3a,2);

        r4a = new OnePeepRule(RULE_MNEMONIC_CONTAINS, "exg",0);
        r4b = new OnePeepRule(RULE_SECOND_OPERAND_EQUALS, "%0o1",0);
        r4c = new OnePeepRule(RULE_FIRST_OPERAND_EQUALS, "%0o2",0);
        c4 = new CombinedPeepRule(r4a,r4b,r4c,COMBINE_AND,3);
        
        r5a = new OnePeepRule(RULE_FIRST_OPERAND_NOTEQUALS, "%2rsl",0);
        r5b = new OnePeepRule(RULE_SECOND_OPERAND_NOTEQUALS, "%2rsl",0);
        c5 = new CombinedPeepRule(r5a,r5b,COMBINE_AND,1);
        
        
        ru = new ArrayList<CombinedPeepRule>();
        ru.add(c1);ru.add(c2);ru.add(c3);ru.add(c4);ru.add(c5);

        e1 = new OneResult(0,"%0org");
        e2 = new OneResult(1,"%2org");
        re = new ArrayList<OneResult>();
        re.add(e1);re.add(e2);

        gccPeep = new PeepRule(5, "4-2a1", "tfr exg 1=1, 2=2, 2. exg 1=2, 2=1",3, ru , re);
        peepers.add(gccPeep);                
        
        
        // --- 4-2b
        r1a = new OnePeepRule(RULE_MNEMONIC_CONTAINS, "tfr",0);
        c1 = new CombinedPeepRule(r1a,0);

        r2a = new OnePeepRule(RULE_MNEMONIC_CONTAINS, "exg",0);
        r2b = new OnePeepRule(RULE_SECOND_OPERAND_EQUALS, "%0o2",0);
        r2c = new OnePeepRule(RULE_FIRST_OPERAND_EQUALS, "%0o1",0);
        c2 = new CombinedPeepRule(r2a, r2b, r2c, COMBINE_AND,1);
        
        r3a = new OnePeepRule(RULE_MNEMONIC_CONTAINS, "lea",0);
        c3 = new CombinedPeepRule(r3a,2);

        r4a = new OnePeepRule(RULE_MNEMONIC_CONTAINS, "exg",0);
        r4b = new OnePeepRule(RULE_SECOND_OPERAND_EQUALS, "%0o2",0);
        r4c = new OnePeepRule(RULE_FIRST_OPERAND_EQUALS, "%0o1",0);
        c4 = new CombinedPeepRule(r4a,r4b,r4c,COMBINE_AND,3);
        
        r5a = new OnePeepRule(RULE_FIRST_OPERAND_NOTEQUALS, "%2rsl",0);
        r5b = new OnePeepRule(RULE_SECOND_OPERAND_NOTEQUALS, "%2rsl",0);
        c5 = new CombinedPeepRule(r5a,r5b,COMBINE_AND,1);
        
        
        ru = new ArrayList<CombinedPeepRule>();
        ru.add(c1);ru.add(c2);ru.add(c3);ru.add(c4);ru.add(c5);

        e1 = new OneResult(0,"%0org");
        e2 = new OneResult(1,"%2org");
        re = new ArrayList<OneResult>();
        re.add(e1);re.add(e2);

        gccPeep = new PeepRule(6, "4-2b2", "tfr exg 1=1, 2=2, 2. exg 1=1, 2=2",3, ru , re);
       peepers.add(gccPeep);                
                
        
        // 4-1
        
        r1a = new OnePeepRule(RULE_MNEMONIC_CONTAINS, "tfr",0);
        c1 = new CombinedPeepRule(r1a,0);

        r2a = new OnePeepRule(RULE_MNEMONIC_CONTAINS, "exg",0);
        r2b = new OnePeepRule(RULE_SECOND_OPERAND_EQUALS, "%0o1",0);
        r2c = new OnePeepRule(RULE_FIRST_OPERAND_EQUALS, "%0o2",0);
        c2 = new CombinedPeepRule(r2a, r2b, r2c, COMBINE_AND,1);
        
        ru = new ArrayList<CombinedPeepRule>();
        ru.add(c1);ru.add(c2);

        e1 = new OneResult(0,"%0org");
        re = new ArrayList<OneResult>();
        re.add(e1);

        gccPeep = new PeepRule(7, "4-1", "tfr exg 1=2, 2=1",1, ru , re);
        peepers.add(gccPeep);                
        // --- 4-2
        r1a = new OnePeepRule(RULE_MNEMONIC_CONTAINS, "tfr",0);
        c1 = new CombinedPeepRule(r1a,0);

        r2a = new OnePeepRule(RULE_MNEMONIC_CONTAINS, "exg",0);
        r2b = new OnePeepRule(RULE_SECOND_OPERAND_EQUALS, "%0o2",0);
        r2c = new OnePeepRule(RULE_FIRST_OPERAND_EQUALS, "%0o1",0);
        c2 = new CombinedPeepRule(r2a, r2b, r2c, COMBINE_AND,1);
        
        ru = new ArrayList<CombinedPeepRule>();
        ru.add(c1);ru.add(c2);

        e1 = new OneResult(0,"%0org");
        re = new ArrayList<OneResult>();
        re.add(e1);

        gccPeep = new PeepRule(8, "4-2", "tfr exg 1=1, 2=2",1, ru , re);
        peepers.add(gccPeep);                
        

                
        
        
        
        

/*
            // tfr	d,x	; , tmp335
            // tfr	x,d	;movlsbqihi: R:x -> R:b	;  tmp335, tmp336                
            if (!found) 
            {
                isFive = true;
                tmp.clear();
                isFive = isFive && l2.label.length()==0;
                isFive = isFive && l1.mnenomic.equals("tfr");
                isFive = isFive && (   ((l2.mnenomic.equals("tfr")) && (l2.first.equals(l1.first)) &&  (l2.second.equals(l1.second)))
                                    || ((l2.mnenomic.equals("tfr")) && (l2.first.equals(l1.second)) && (l2.second.equals(l1.first))) );

                found = found |isFive;
            }            

        
        ->
                outLines.add("; Peep 5");
                outLines.add(l1.org);
                if (l2.label.length()>0) outLines.add(l2.label+":");
                i+=1;
                peepsFound++;
                outLines.add("; "+l1.org);
                outLines.add("; "+l2.org);
*/
        
        // --- 5a
        r1a = new OnePeepRule(RULE_MNEMONIC_CONTAINS, "tfr",0);
        c1 = new CombinedPeepRule(r1a,0);

        r2a = new OnePeepRule(RULE_MNEMONIC_CONTAINS, "tfr",0);
        r2b = new OnePeepRule(RULE_FIRST_OPERAND_EQUALS, "%0o1",0);
        r2c = new OnePeepRule(RULE_SECOND_OPERAND_EQUALS, "%0o2",0);
        c2 = new CombinedPeepRule(r2a, r2b, r2c, COMBINE_AND,1);
        
        ru = new ArrayList<CombinedPeepRule>();
        ru.add(c1);ru.add(c2);

        e1 = new OneResult(0,"%0org");
        re = new ArrayList<OneResult>();
        re.add(e1);

        gccPeep = new PeepRule(9, "5-1", "tfr tfr 1=1, 2=2",1, ru , re);
        peepers.add(gccPeep);                
        // --- 5b
        r1a = new OnePeepRule(RULE_MNEMONIC_CONTAINS, "tfr",0);
        c1 = new CombinedPeepRule(r1a,0);

        r2a = new OnePeepRule(RULE_MNEMONIC_CONTAINS, "tfr",0);
        r2b = new OnePeepRule(RULE_FIRST_OPERAND_EQUALS, "%0o2",0);
        r2c = new OnePeepRule(RULE_SECOND_OPERAND_EQUALS, "%0o1",0);
        c2 = new CombinedPeepRule(r2a, r2b, r2c, COMBINE_AND,1);
        
        ru = new ArrayList<CombinedPeepRule>();
        ru.add(c1);ru.add(c2);

        e1 = new OneResult(0,"%0org");
        re = new ArrayList<OneResult>();
        re.add(e1);

        gccPeep = new PeepRule(10, "5-2", "tfr tfr 1=2, 2=1",1, ru , re);
        peepers.add(gccPeep);                
        
        

        

/*
            // tfr	d,x	; , tmp349
            // NOT RELATED dec	9,s	;  D.3036
            // tfr	x,d	;movlsbqihi: R:x -> R:b	;  tmp349, tmp350
            if (!found) 
            {
                isSix = true;
                tmp.clear();
                isSix = isSix && l2.label.length()==0;
                isSix = isSix && l3.label.length()==0;
                isSix = isSix && l1.mnenomic.equals("tfr");
                isSix = isSix && (   ((l3.mnenomic.equals("tfr")) && (l3.first.equals(l1.first)) &&  (l3.second.equals(l1.second)))
                                    || ((l3.mnenomic.equals("tfr")) && (l3.first.equals(l1.second)) && (l3.second.equals(l1.first))) );

                isSix = isSix && !l2.branch;
                isSix = isSix && l2.regSave;
                
                found = found |isSix;
     

        
        ->
                outLines.add("; Peep 6");
                outLines.add(l1.org);
                outLines.add(l2.org);
                if (l3.label.length()>0) outLines.add(l3.label+":");
                i+=2;
                peepsFound++;
                outLines.add("; "+l1.org);
                outLines.add("; "+l2.org);
                outLines.add("; "+l3.org);

*/
        // ---  6-1
        r1a = new OnePeepRule(RULE_MNEMONIC_CONTAINS, "tfr",0);
        c1 = new CombinedPeepRule(r1a,0);

        r2a = new OnePeepRule(RULE_NO_BRANCH,0);
        r2b = new OnePeepRule(RULE_NO_REGISTER_CHANGE,0);
        c2 = new CombinedPeepRule(r2a,r2b, COMBINE_AND,1);
        
        r3a = new OnePeepRule(RULE_MNEMONIC_CONTAINS, "tfr",0);
        OnePeepRule r3b = new OnePeepRule(RULE_FIRST_OPERAND_EQUALS, "%0o1",0);
        OnePeepRule r3c = new OnePeepRule(RULE_SECOND_OPERAND_EQUALS, "%0o2",0);
        c3 = new CombinedPeepRule(r3a, r3b, r3c, COMBINE_AND,2);
        
        ru = new ArrayList<CombinedPeepRule>();
        ru.add(c1);ru.add(c2);ru.add(c3);

        e1 = new OneResult(0,"%0org");
        e2 = new OneResult(1,"%1org");
        re = new ArrayList<OneResult>();
        re.add(e1);re.add(e2);

        gccPeep = new PeepRule(11, "6-1", "tfr !! tfr 1=1, 2=2 (untested)",2, ru , re);
        peepers.add(gccPeep);                
                        
        
        // ---  6-2
        r1a = new OnePeepRule(RULE_MNEMONIC_CONTAINS, "tfr",0);
        c1 = new CombinedPeepRule(r1a,0);

        r2a = new OnePeepRule(RULE_NO_BRANCH,0);
        r2b = new OnePeepRule(RULE_NO_REGISTER_CHANGE,0);
        c2 = new CombinedPeepRule(r2a,r2b, COMBINE_AND,1);
        
        r3a = new OnePeepRule(RULE_MNEMONIC_CONTAINS, "tfr",0);
        r3b = new OnePeepRule(RULE_FIRST_OPERAND_EQUALS, "%0o2",0);
        r3c = new OnePeepRule(RULE_SECOND_OPERAND_EQUALS, "%0o1",0);
        c3 = new CombinedPeepRule(r3a, r3b, r3c, COMBINE_AND,2);
        
        ru = new ArrayList<CombinedPeepRule>();
        ru.add(c1);ru.add(c2);ru.add(c3);

        e1 = new OneResult(0,"%0org");
        e2 = new OneResult(1,"%1org");
        re = new ArrayList<OneResult>();
        re.add(e1);re.add(e2);

        gccPeep = new PeepRule(12, "6-2", "tfr !! tfr 1=2, 2=1 (untested)",2, ru , re);
        peepers.add(gccPeep);                
        
        
        

/*
            // chnage usage of b to a
            if (!found) 
            {
                isSeven = true;
                tmp.clear();
                isSeven = isSeven && l1.mnenomic.equals("ldb") && l1.isImmediate;
                if (l2.mnenomic.length()!=0)
                {
                    isSeven = isSeven && l2.mnenomic.equals("tfr") && l2.org.contains("#VIDE_CHANGE_B_TO_A#");
                    tmp.add(l2);

        
        ->
                outLines.add("; Peep 7");
                
                outLines.add(de.malban.util.UtilityString.replace(l1.org, "ldb", "lda"));
                for (int ii=0; ii<tmp.size()-1;ii++)
                {
                    outLines.add(tmp.get(ii).org);
                }
                if (tmp.get(tmp.size()-1).label.length()>0) 
                    outLines.add(tmp.get(tmp.size()-1).label+":");
                
                i+=tmp.size();
                peepsFound++;

                outLines.add("; "+l1.org);
                for (int ii=0; ii<tmp.size();ii++)
                    outLines.add("; "+tmp.get(ii).org);


*/        
                
        // ---  7
        r1a = new OnePeepRule(RULE_MNEMONIC_CONTAINS, "ldb",0);
        r1b = new OnePeepRule(RULE_IS_IMMEDIATE, 0);
        c1 = new CombinedPeepRule(r1a,r1b, COMBINE_AND,0);

        r2a = new OnePeepRule(RULE_MNEMONIC_CONTAINS, "tfr",0);
        r2b = new OnePeepRule(RULE_ORG_LINE_CONTAINS,"#VIDE_CHANGE_B_TO_A#",0);
        c2 = new CombinedPeepRule(r2a,r2b, COMBINE_AND,1);
        
        ru = new ArrayList<CombinedPeepRule>();
        ru.add(c1);ru.add(c2);

        e1 = new OneResult(0,"%0replace:ldb:lda");
        re = new ArrayList<OneResult>();
        re.add(e1);

        gccPeep = new PeepRule(13, "7", "change b to a",1, ru , re);
        peepers.add(gccPeep);                
        
        
        


/*
            // ldx y
            if (!found) 
            {
                isEight = true;
                tmp.clear();
                
                isEight = isEight && (l1.isLoad);
                isEight = isEight && (l1.operandAll.equals("x") || l1.operandAll.equals("y") || l1.operandAll.equals("u")|| l1.operandAll.equals("s"));
                found = found |isEight;
            }             

        
        ->
                outLines.add("; Peep 8 (error)");
                if (l1.label.length()>0) outLines.add(l1.label+":");
//                outLines.add("\t"+l1.mnenomic+"\t,"+l1.operandAll+";"+l1.rest);
                if (l1.storeLoadReg.equals("d"))
                {
                    outLines.add("\ttfr\t"+l1.operandAll+","+l1.storeLoadReg+l1.comment);
                }
                else
                    outLines.add("\tlea"+l1.storeLoadReg+"\t,"+l1.operandAll+l1.comment);
                peepsFound++;
                outLines.add("; "+l1.org);

*/        
                    
        // ---  8-1
        r1a = new OnePeepRule(RULE_IS_LOAD, 0);
        r1b = new OnePeepRule(RULE_STORE_LOAD_REG_NOTEQUALS, "d", 0);
        c1 = new CombinedPeepRule(r1a,r1b, COMBINE_AND,0);

        r2a = new OnePeepRule(RULE_OPERAND_ALL_EQUALS, "y",0);
        r2b = new OnePeepRule(RULE_OPERAND_ALL_EQUALS, "x",0);
        r2c = new OnePeepRule(RULE_OPERAND_ALL_EQUALS, "u",0);
        r2d = new OnePeepRule(RULE_OPERAND_ALL_EQUALS, "s",0);
        c2 = new CombinedPeepRule(r2a,r2b,r2c,r2d, COMBINE_OR,0);
        
        ru = new ArrayList<CombinedPeepRule>();
        ru.add(c1);ru.add(c2);

        e1 = new OneResult(0,"\tlea%0rsl\t,%0oAll  %0comment");
        re = new ArrayList<OneResult>();
        re.add(e1);

        gccPeep = new PeepRule(14, "8-1", "single -> lea d",0, ru , re);
        peepers.add(gccPeep);                
        
        // ---  8-2
        r1a = new OnePeepRule(RULE_IS_LOAD, 0);
        r1b = new OnePeepRule(RULE_STORE_LOAD_REG_EQUALS, "d", 0);
        c1 = new CombinedPeepRule(r1a,r1b, COMBINE_AND,0);

        r2a = new OnePeepRule(RULE_OPERAND_ALL_EQUALS, "y",0);
        r2b = new OnePeepRule(RULE_OPERAND_ALL_EQUALS, "x",0);
        r2c = new OnePeepRule(RULE_OPERAND_ALL_EQUALS, "u",0);
        r2d = new OnePeepRule(RULE_OPERAND_ALL_EQUALS, "s",0);
        c2 = new CombinedPeepRule(r2a,r2b,r2c,r2d, COMBINE_OR,0);
        
        ru = new ArrayList<CombinedPeepRule>();
        ru.add(c1);ru.add(c2);

        e1 = new OneResult(0," \ttfr\t %0oAll, %0rsl %0comment");
        re = new ArrayList<OneResult>();
        re.add(e1);

        gccPeep = new PeepRule(15, "8-2", "single -> tfr d (untested)",0, ru , re);
        peepers.add(gccPeep);                
        
        
        
        // ---  9
        r1a = new OnePeepRule(RULE_IS_EXTENED, 0);
        r1b = new OnePeepRule(RULE_PAGE_EQUALS, "$d0", 0);
        c1 = new CombinedPeepRule(r1a,r1b, COMBINE_AND,0);

        ru = new ArrayList<CombinedPeepRule>();
        ru.add(c1);

        OneResult e0 = new OneResult(0,"\t.setdp 0xd000,_DATA");
        e1 = new OneResult(1,"\t%0m\t *%0oAll %0comment");
        re = new ArrayList<OneResult>();
        re.add(e0);re.add(e1);
	

        gccPeep = new PeepRule(16, "9", "extended d0 -> direct d0",0, ru , re);
        peepers.add(gccPeep);                
        
                
                        
        
        

        // ORDER rules
        
        String filename =Global.mainPathPrefix+"xml"+File.separator+"VidePeepholes.xml";
        File f = new File(filename);
        if (f.exists())
        {
            loadFromXML(filename);
        }
        else
        {
            saveAsXML(filename);
        }
        Collections.sort(peepers, new Comparator<PeepRule>() {
                @Override
                public int compare(PeepRule rule1, PeepRule rule2)
                {
                    return  rule1.order - rule2.order;
                }
            });        
        
    }

    
    static Vector<String> removeEmpty(Vector<String> sLines)
    {
        Vector<String> n = new Vector<String> ();
        for (int i=0; i<sLines.size(); i++)
        {
            boolean dotest = true;
            String orgLine1 = sLines.elementAt(i);
            String t = de.malban.util.UtilityString.replaceWhiteSpaces(orgLine1, "");

            if (t.length() == 0) continue;
            n.add(orgLine1);
        }
        return n;
    }
    static public void peepCorrectASM(String sfile)
    {
        Vector<String> sLines =  de.malban.util.UtilityString.readTextFileToString(new File(sfile));
        sLines = removeEmpty(sLines);
        
        ArrayList<String> outLines = new ArrayList<String>();
        ArrayList<ASMLine> testLines = new ArrayList<ASMLine>();

        for (int i=0; i<sLines.size(); i++)
        {
            testLines.clear();
            
            boolean dotest = true;
            String orgLine0 = sLines.elementAt(i);
            String orgLine1 = "";
            String orgLine2 = "";
            String orgLine3 = "";
            String orgLine4 = "";
            String orgLine5 = "";
            String orgLine6 = "";
            String orgLine7 = "";
            String orgLine8 = "";
            String orgLine9 = "";
            String orgLinea = "";
            String orgLineb = "";
            String orgLinec = "";
            String orgLined = "";
            String orgLinee = "";
            String orgLinef = "";
            String orgLineg = "";
            String orgLineh = "";
            String orgLinei = "";
            String orgLinej = "";

            if (i+1<sLines.size()) orgLine1 = sLines.elementAt(i+1);
            if (i+2<sLines.size()) orgLine2 = sLines.elementAt(i+2);
            if (i+3<sLines.size()) orgLine3 = sLines.elementAt(i+3);
            if (i+4<sLines.size()) orgLine4 = sLines.elementAt(i+4);
            if (i+5<sLines.size()) orgLine5 = sLines.elementAt(i+5);
            if (i+6<sLines.size()) orgLine6 = sLines.elementAt(i+6);
            if (i+7<sLines.size()) orgLine7 = sLines.elementAt(i+7);
            if (i+8<sLines.size()) orgLine8 = sLines.elementAt(i+8);
            if (i+9<sLines.size()) orgLine9 = sLines.elementAt(i+9);
            if (i+10<sLines.size()) orgLinea = sLines.elementAt(i+10);
            if (i+11<sLines.size()) orgLineb = sLines.elementAt(i+11);
            if (i+12<sLines.size()) orgLinec = sLines.elementAt(i+12);
            if (i+13<sLines.size()) orgLined = sLines.elementAt(i+13);
            if (i+14<sLines.size()) orgLinee = sLines.elementAt(i+14);
            if (i+15<sLines.size()) orgLinef = sLines.elementAt(i+15);
            if (i+16<sLines.size()) orgLineg = sLines.elementAt(i+16);
            if (i+17<sLines.size()) orgLineh = sLines.elementAt(i+17);
            if (i+18<sLines.size()) orgLinei = sLines.elementAt(i+18);
            if (i+19<sLines.size()) orgLinej = sLines.elementAt(i+19);
            
            
            if (orgLine0.length()>0) testLines.add(new ASMLine(orgLine0));
            if (orgLine1.length()>0) testLines.add(new ASMLine(orgLine1));
            if (orgLine2.length()>0) testLines.add(new ASMLine(orgLine2));
            if (orgLine3.length()>0) testLines.add(new ASMLine(orgLine3));
            if (orgLine4.length()>0) testLines.add(new ASMLine(orgLine4));
            if (orgLine5.length()>0) testLines.add(new ASMLine(orgLine5));
            if (orgLine6.length()>0) testLines.add(new ASMLine(orgLine6));
            if (orgLine7.length()>0) testLines.add(new ASMLine(orgLine7));
            if (orgLine8.length()>0) testLines.add(new ASMLine(orgLine8));
            if (orgLine9.length()>0) testLines.add(new ASMLine(orgLine9));
            if (orgLinea.length()>0) testLines.add(new ASMLine(orgLinea));
            if (orgLineb.length()>0) testLines.add(new ASMLine(orgLineb));
            if (orgLinec.length()>0) testLines.add(new ASMLine(orgLinec));
            if (orgLined.length()>0) testLines.add(new ASMLine(orgLined));
            if (orgLinee.length()>0) testLines.add(new ASMLine(orgLinee));
            if (orgLinef.length()>0) testLines.add(new ASMLine(orgLinef));
            if (orgLineg.length()>0) testLines.add(new ASMLine(orgLineg));
            if (orgLineh.length()>0) testLines.add(new ASMLine(orgLineh));
            if (orgLinei.length()>0) testLines.add(new ASMLine(orgLinei));
            if (orgLinej.length()>0) testLines.add(new ASMLine(orgLinej));

if (orgLine0.contains("test.791"))            
    System.out.println("");
if (orgLine1.contains("test.791"))            
    System.out.println("");
if (orgLine2.contains("test.791"))            
    System.out.println("");
if (orgLine3.contains("test.791"))            
    System.out.println("");
if (orgLine4.contains("test.791"))            
    System.out.println("");
if (orgLine5.contains("test.791"))            
    System.out.println("");
            
//if (i==266)
//    System.out.println("");
//if (orgLine0.startsWith("_VIA_"))
//    System.out.println("");
            //////////
            boolean peepDone = false;
            for (PeepRule rule: peepers)
            {
                if (rule.active)
                {
                    rule.setLines(testLines);
                    
                    if (rule.isRuleValid())
                    {
                        rule.addResult(outLines);
                        i+=rule.getFinalAdd();
                        peepsFound++;
                        peepDone = true;
                        break;
                    }
                }
            }

            if (!peepDone)
            {
                outLines.add(orgLine0);
            }
            
        }
        StringBuilder outString = new StringBuilder();
        for (String s: outLines) outString.append(s).append("\n");
        
    //    sfile = de.malban.util.UtilityString.replace(sfile, ".s", "NEW.s");
        
        de.malban.util.UtilityString.writeToTextFile(outString.toString(), new File(sfile));
        
    }
    
    // saves the all rules to a XML buffer
    static public boolean toXML(StringBuilder s, String tag)
    {
        s.append("<").append(tag).append(">\n");
        boolean ok = true;
        
        for (PeepRule rule: peepers)
        {
            ok = ok & rule.toXML(s, "PeepRule");
        }
        s.append("</").append(tag).append(">\n");
        return ok;        
    }
    
    // loads the rule from an xml buffer
    static public boolean fromXML(StringBuilder xml, XMLSupport xmlSupport)
    {
        int errorCode = 0;
        peepers = new ArrayList<PeepRule>();        

        PeepRule rule = null;
        do
        {
            xmlSupport.errorCode = 0;
            rule = PeepRule.readRuleFromXML(xmlSupport.getXMLElement("PeepRule", xml), xmlSupport);
            if (rule != null)
            {
                errorCode|=xmlSupport.errorCode;
                peepers.add(rule);
            }
            else
            {
                // eof is no error
                xmlSupport.errorCode = 0;
            }
        } while (rule != null);
        
        if (errorCode!= 0) 
        {
            peepers = new ArrayList<PeepRule>();  
            return false;
        }


        
        // ORDER rules
         reorder();
        
        
        
        return true;
    }
    
    static public void reorder()
    {
        Collections.sort(peepers, new Comparator<PeepRule>() {
                @Override
                public int compare(PeepRule rule1, PeepRule rule2)
                {
                    return  rule1.order - rule2.order;
                }
            });        
        
    }
    
    static public boolean saveAsXML()
    {
        String filename =Global.mainPathPrefix+"xml"+File.separator+"VidePeepholes.xml";
        return saveAsXML(filename);
    }
    static public boolean saveAsXML(String filename)
    {
        LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
        StringBuilder xml = new StringBuilder();
        boolean ok = toXML(xml, "PeepholeList");
        if (!ok)
        {
            log.addLog("PeepholeList save 'toXML' return false", WARN);
            return false;
        }
        ok = de.malban.util.UtilityFiles.createTextFile(filename, xml.toString());
        if (!ok)
        {
            log.addLog("PeepholeList create file '"+filename+"' return false", WARN);
            return false;
        }
        return true; 
    }
    static public boolean loadFromXML(String filename)
    {
        LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
        String xml = de.malban.util.UtilityString.readTextFileToOneString(new File (de.malban.util.UtilityFiles.convertSeperator(filename)));
        boolean ok = fromXML(new StringBuilder(xml), new XMLSupport());
        
        if (!ok)
        {
            log.addLog("PeepholeList load from xml '"+filename+"' return false", WARN);
            return false;
        }
        
        return true;
    }    
    
        
}
