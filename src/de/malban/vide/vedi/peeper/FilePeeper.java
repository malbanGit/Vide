/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vedi.peeper;

import java.io.File;
import java.util.ArrayList;
import java.util.Vector;

/**
 * TODO make configurable -> started but not finished.
 * 
 * @author malban
 */
public class FilePeeper 
{

    public static int peepsFound=0;
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
    public static void peepCorrectASM(String sfile)
    {
        
        Vector<String> sLines =  de.malban.util.UtilityString.readTextFileToString(new File(sfile));
        sLines = removeEmpty(sLines);
        
      //  if (sfile.length()>0) return;
        
        ArrayList<String> outLines = new ArrayList<String>();
        ArrayList<ASMLine> tmp = new ArrayList<ASMLine>();

        for (int i=0; i<sLines.size(); i++)
        {
            tmp.clear();
            boolean dotest = true;
            String orgLine1 = sLines.elementAt(i);
            String orgLine2 = "";
            String orgLine3 = "";
            String orgLine4 = "";
            String orgLine5 = "";
            String orgLine6 = "";
            String orgLine7 = "";

            if (i+1<sLines.size()) orgLine2 = sLines.elementAt(i+1);
            if (i+2<sLines.size()) orgLine3 = sLines.elementAt(i+2);
            if (i+3<sLines.size()) orgLine4 = sLines.elementAt(i+3);
            if (i+4<sLines.size()) orgLine5 = sLines.elementAt(i+4);
            if (i+5<sLines.size()) orgLine6 = sLines.elementAt(i+5);
            if (i+6<sLines.size()) orgLine7 = sLines.elementAt(i+6);

            ASMLine l1 = new ASMLine(orgLine1);
            ASMLine l2 = new ASMLine(orgLine2);
            ASMLine l3 = new ASMLine(orgLine3);
            ASMLine l4 = new ASMLine(orgLine4);
            ASMLine l5 = new ASMLine(orgLine5);
            ASMLine l6 = new ASMLine(orgLine6);
            ASMLine l7 = new ASMLine(orgLine7);
            
            //////////
            boolean isOne = false;
            boolean isTwo = false;
            boolean isThree = false;
            boolean isFour = false;
            boolean isFourA = false;
            boolean isFive = false;
            boolean isSix = false;
            boolean isSeven = false;
            boolean isEight = false;
            boolean found = false;
/************* ***************/
            // test 1
            // this one is actually a generated false
            // code from gcc, probably only when -o3 is given
            
            isOne = true;
            
            isOne = isOne && ((l1.mnenomic.equals("tfr")) && (l1.first.equals("d")));
            isOne = isOne && ((l2.mnenomic.equals("exg")) && (l2.first.equals("d")) && (l2.second.equals(l1.second)));
            isOne = isOne && (l3.mnenomic.equals("addd"));
            isOne = isOne && ((l4.mnenomic.equals("exg")) && (l4.first.equals("d")) && (l4.second.equals(l1.second)));
            isOne = isOne && ( (l5.mnenomic.equals("std")) || (l5.mnenomic.equals("cmpd")));
            found = found |isOne;
            
/************* ***************/
            if (!found) 
            {
                isTwo = true;
                tmp.clear();
                
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
                else if (l3.mnenomic.length()!=0)
                {
                    isTwo = isTwo && l2.label.length()==0;
                    isTwo = isTwo && l3.label.length()==0;
                    isTwo = isTwo && (l3.isLoad);
                    isTwo = isTwo && (l3.operandAll.equals(l1.operandAll));
                    isTwo = isTwo && (l3.storeLoadReg.equals(l1.storeLoadReg));
                    tmp.add(l2);
                    tmp.add(l3);
                }
                else if (l4.mnenomic.length()!=0)
                {
                    isTwo = isTwo && l2.label.length()==0;
                    isTwo = isTwo && l3.label.length()==0;
                    isTwo = isTwo && l4.label.length()==0;
                    isTwo = isTwo && (l4.isLoad);
                    isTwo = isTwo && (l4.operandAll.equals(l1.operandAll));
                    isTwo = isTwo && (l4.storeLoadReg.equals(l1.storeLoadReg));
                    tmp.add(l2);
                    tmp.add(l3);
                    tmp.add(l4);
                }
                else if (l5.mnenomic.length()!=0)
                {
                    isTwo = isTwo && l2.label.length()==0;
                    isTwo = isTwo && l3.label.length()==0;
                    isTwo = isTwo && l4.label.length()==0;
                    isTwo = isTwo && l5.label.length()==0;
                    isTwo = isTwo && (l5.isLoad);
                    isTwo = isTwo && (l5.operandAll.equals(l1.operandAll));
                    isTwo = isTwo && (l5.storeLoadReg.equals(l1.storeLoadReg));
                    tmp.add(l2);
                    tmp.add(l3);
                    tmp.add(l4);
                    tmp.add(l5);
                }
                else if (l6.mnenomic.length()!=0)
                {
                    isTwo = isTwo && l2.label.length()==0;
                    isTwo = isTwo && l3.label.length()==0;
                    isTwo = isTwo && l4.label.length()==0;
                    isTwo = isTwo && l5.label.length()==0;
                    isTwo = isTwo && l6.label.length()==0;
                    isTwo = isTwo && (l6.isLoad);
                    isTwo = isTwo && (l6.operandAll.equals(l1.operandAll));
                    isTwo = isTwo && (l6.storeLoadReg.equals(l1.storeLoadReg));
                    tmp.add(l2);
                    tmp.add(l3);
                    tmp.add(l4);
                    tmp.add(l5);
                    tmp.add(l6);
                }
                else if (l7.mnenomic.length()!=0)
                {
                    isTwo = isTwo && l2.label.length()==0;
                    isTwo = isTwo && l3.label.length()==0;
                    isTwo = isTwo && l4.label.length()==0;
                    isTwo = isTwo && l5.label.length()==0;
                    isTwo = isTwo && l6.label.length()==0;
                    isTwo = isTwo && l7.label.length()==0;
                    isTwo = isTwo && (l7.isLoad);
                    isTwo = isTwo && (l7.operandAll.equals(l1.operandAll));
                    isTwo = isTwo && (l7.storeLoadReg.equals(l1.storeLoadReg));
                    tmp.add(l2);
                    tmp.add(l3);
                    tmp.add(l4);
                    tmp.add(l5);
                    tmp.add(l6);
                    tmp.add(l7);
                }
                else
                {
                    isTwo = false;
                }
                found = found |isTwo;
            }

/************* ***************/
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
                }
                else if (l3.mnenomic.length()!=0)
                {
                    isThree = isThree && l2.label.length()==0;
                    isThree = isThree && l3.label.length()==0;

                    isThree = isThree && (l3.isLoad);
                    isThree = isThree && (l3.storeLoadReg.equals(l1.storeLoadReg));
                    isThree = isThree && (! ((l3.firstReg.contains(l3.storeLoadReg)) || (l3.secondReg.contains(l3.storeLoadReg)) ));
                    tmp.add(l2);
                    tmp.add(l3);
                }
                else if (l4.mnenomic.length()!=0)
                {
                    isThree = isThree && l2.label.length()==0;
                    isThree = isThree && l3.label.length()==0;
                    isThree = isThree && l4.label.length()==0;

                    isThree = isThree && (l4.isLoad);
                    isThree = isThree && (l4.storeLoadReg.equals(l1.storeLoadReg));
                    isThree = isThree && (! ((l4.firstReg.contains(l4.storeLoadReg)) || (l4.secondReg.contains(l4.storeLoadReg)) ));
                    tmp.add(l2);
                    tmp.add(l3);
                    tmp.add(l4);
                }
                else if (l5.mnenomic.length()!=0)
                {
                    isThree = isThree && l2.label.length()==0;
                    isThree = isThree && l3.label.length()==0;
                    isThree = isThree && l4.label.length()==0;
                    isThree = isThree && l5.label.length()==0;

                    isThree = isThree && (l5.isLoad);
                    isThree = isThree && (l5.storeLoadReg.equals(l1.storeLoadReg));
                    isThree = isThree && (! ((l5.firstReg.contains(l5.storeLoadReg)) || (l5.secondReg.contains(l5.storeLoadReg)) ));
                    tmp.add(l2);
                    tmp.add(l3);
                    tmp.add(l4);
                    tmp.add(l5);
                }
                else if (l6.mnenomic.length()!=0)
                {
                    isThree = isThree && l2.label.length()==0;
                    isThree = isThree && l3.label.length()==0;
                    isThree = isThree && l4.label.length()==0;
                    isThree = isThree && l5.label.length()==0;
                    isThree = isThree && l6.label.length()==0;

                    isThree = isThree && (l6.isLoad);
                    isThree = isThree && (l6.storeLoadReg.equals(l1.storeLoadReg));
                    isThree = isThree && (! ((l6.firstReg.contains(l6.storeLoadReg)) || (l6.secondReg.contains(l6.storeLoadReg)) ));
                    tmp.add(l2);
                    tmp.add(l3);
                    tmp.add(l4);
                    tmp.add(l5);
                    tmp.add(l6);
                }
                else if (l7.mnenomic.length()!=0)
                {
                    isThree = isThree && l2.label.length()==0;
                    isThree = isThree && l3.label.length()==0;
                    isThree = isThree && l4.label.length()==0;
                    isThree = isThree && l5.label.length()==0;
                    isThree = isThree && l6.label.length()==0;
                    isThree = isThree && l7.label.length()==0;

                    isThree = isThree && (l7.isLoad);
                    isThree = isThree && (l7.storeLoadReg.equals(l1.storeLoadReg));
                    isThree = isThree && (! ((l7.firstReg.contains(l7.storeLoadReg)) || (l7.secondReg.contains(l7.storeLoadReg)) ));
                    tmp.add(l2);
                    tmp.add(l3);
                    tmp.add(l4);
                    tmp.add(l5);
                    tmp.add(l6);
                    tmp.add(l7);
                }
                else
                {
                    isThree = false;
                }            
                found = found |isThree;
            }
            
/************* ***************/
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
                
/************* ***************/
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
/************* ***************/
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
            }            
/************* ***************/
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
                }
                else if (l3.mnenomic.length()!=0)
                {
                    isSeven = isSeven && l3.mnenomic.equals("tfr") && l3.org.contains("#VIDE_CHANGE_B_TO_A#");
                    tmp.add(l2);
                    tmp.add(l3);
                }
                else if (l4.mnenomic.length()!=0)
                {
                    isSeven = isSeven && l4.mnenomic.equals("tfr") && l4.org.contains("#VIDE_CHANGE_B_TO_A#");
                    tmp.add(l2);
                    tmp.add(l3);
                    tmp.add(l4);
                }
                else if (l5.mnenomic.length()!=0)
                {
                    isSeven = isSeven && l5.mnenomic.equals("tfr") && l5.org.contains("#VIDE_CHANGE_B_TO_A#");
                    tmp.add(l2);
                    tmp.add(l3);
                    tmp.add(l4);
                    tmp.add(l5);
                }
                else if (l6.mnenomic.length()!=0)
                {
                    isSeven = isSeven && l6.mnenomic.equals("tfr") && l6.org.contains("#VIDE_CHANGE_B_TO_A#");
                    tmp.add(l2);
                    tmp.add(l3);
                    tmp.add(l4);
                    tmp.add(l5);
                    tmp.add(l6);
                }
                else if (l7.mnenomic.length()!=0)
                {
                    isSeven = isSeven && l7.mnenomic.equals("tfr") && l7.org.contains("#VIDE_CHANGE_B_TO_A#");
                    tmp.add(l2);
                    tmp.add(l3);
                    tmp.add(l4);
                    tmp.add(l5);
                    tmp.add(l6);
                    tmp.add(l7);
                }
                else
                {
                    isSeven = false;
                }            
                found = found |isSeven;
            }
/************* ***************/
            // ldx y
            if (!found) 
            {
                isEight = true;
                tmp.clear();
                
                isEight = isEight && (l1.isLoad);
                isEight = isEight && (l1.operandAll.equals("x") || l1.operandAll.equals("y") || l1.operandAll.equals("u")|| l1.operandAll.equals("s"));
                found = found |isEight;
            }             
            

            
            ////////
            if (isOne)
            {
                outLines.add("; Peep 1 (error)");
                if (l1.label.length()>0) outLines.add(l1.label+":");
                if (l2.label.length()>0) outLines.add(l2.label+":");
                outLines.add(l3.org);
                if (l4.label.length()>0) outLines.add(l4.label+":");
                outLines.add(" tfr d,"+l1.second);
                outLines.add(l5.org);
                i+=4;
                peepsFound++;
                
                outLines.add("; "+l1.org);
                outLines.add("; "+l2.org);
                outLines.add("; "+l3.org);
                outLines.add("; "+l4.org);
                outLines.add("; "+l5.org);
                
                
                
            }
            else if (isTwo)
            {
                outLines.add("; Peep 2");
                outLines.add(l1.org);
                for (int ii=0; ii<tmp.size()-1;ii++)
                    outLines.add(tmp.get(ii).org);
                
                if (tmp.get(tmp.size()-1).label.length()>0) outLines.add(tmp.get(tmp.size()-1).label+":");
                i+=tmp.size();
                
                peepsFound++;

                outLines.add("; "+l1.org);
                for (int ii=0; ii<tmp.size();ii++)
                    outLines.add("; "+tmp.get(ii).org);
            }
            else if (isThree)
            {
                outLines.add("; Peep 3");
                if (l1.label.length()>0) outLines.add(l1.label+":");
                for (int ii=0; ii<tmp.size();ii++)
                    outLines.add(tmp.get(ii).org);
                
                i+=tmp.size();
                peepsFound++;

                outLines.add("; "+l1.org);
                for (int ii=0; ii<tmp.size();ii++)
                    outLines.add("; "+tmp.get(ii).org);
            }
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
            }
            else if (isFive)
            {
                outLines.add("; Peep 5");
                outLines.add(l1.org);
                if (l2.label.length()>0) outLines.add(l2.label+":");
                i+=1;
                peepsFound++;
                outLines.add("; "+l1.org);
                outLines.add("; "+l2.org);
            }
            else if (isSix)
            {
                outLines.add("; Peep 6");
                outLines.add(l1.org);
                outLines.add(l2.org);
                if (l3.label.length()>0) outLines.add(l3.label+":");
                i+=2;
                peepsFound++;
                outLines.add("; "+l1.org);
                outLines.add("; "+l2.org);
                outLines.add("; "+l3.org);
            }
            else if (isSeven)
            {
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
            }
            else if (isEight)
            {
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
                
                
                
                
            }
            else
            {
                outLines.add(orgLine1);
            }
            
        }
        StringBuilder outString = new StringBuilder();
        for (String s: outLines) outString.append(s).append("\n");
        de.malban.util.UtilityString.writeToTextFile(outString.toString(), new File(sfile));
        
    }
    
    


             
        
}
