/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vedi.sound;

import de.malban.config.Configuration;
import de.malban.config.TinyLogInterface;
import de.malban.gui.panels.LogPanel;
import static de.malban.gui.panels.LogPanel.WARN;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import de.malban.util.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
        
        

/**
 *
 * @author Malban
 */
public class AKSBin {
    int trackNo=0;
    HashMap<Integer, Track> trackMap = new HashMap<Integer, Track>();

    String notes[] ={"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"};
    
    public static final int CM_BYTE = 1;
    public static final int CM_WORD_1 = 2;
    public static final int CM_WORD_2 = 3;
    public static final int CM_POINTER_1 = 4;
    public static final int CM_POINTER_2 = 5;
    class CommentedMemory
    {
        int address = -1;
        boolean isCommentLine = false;
        boolean additionalComment = false;
        int type = CM_BYTE;
        String addressLabel = "";
        String aditionalComment="";
        String preCommentLine="";
        int byteValue; 
        boolean ommit = false;
        int wordValue=-1;
        AKSMemory parent;
        int offset=0;
        public void setOffset(int o)
        {
            offset = o;
        }
        
        void addLabel(String l)
        {
            addressLabel+=l+parent.labelId;
        }
        void setLabel(String l)
        {
            if (addressLabel.length() != 0) return;
            addressLabel=l+parent.labelId;
        }
        void addComment(String c)
        {
            if (aditionalComment.contains(c)) return;
            if (aditionalComment.length() != 0) aditionalComment+=", ";
            aditionalComment+=c;
        }
        void setComment(String c)
        {
            if (aditionalComment.length() != 0) return;
            aditionalComment=c;
        }
        void addPreComment(String c)
        {
            preCommentLine+="; "+c+"\n";
        }
        public String getPreString()
        {
            if (type == CM_WORD_2) return "";
            if (type == CM_POINTER_2) return "";
            if (ommit) return "";
            String ret = preCommentLine+addressLabel;
            if (addressLabel.length()!=0) ret +=":\n";
            return ret;
        }
        public String getValueString()
        {
            if (type == CM_WORD_2) return "";
            if (type == CM_POINTER_2) return "";
            if (ommit) return "";
            String ret = "";
            if (type == CM_BYTE)
                ret += "$"+String.format("%02X", (int)(byteValue&0xff) );
            if (type == CM_POINTER_1)
            {
                String otherLabel = parent.m.get(wordValue-offset).addressLabel;
                if (otherLabel .length()!=0)
                    ret += otherLabel;
                else
                    ret += "$"+String.format("%04X", (int)((wordValue-offset)&0xffff));
            }
            if (type == CM_WORD_1)
            {
                ret += "$"+String.format("%04X", (int)(wordValue&0xffff));
            }
            return ret;
        }
        public String getPostString()
        {
            if (type == CM_WORD_2) return "";
            if (type == CM_POINTER_2) return "";
            if (ommit) return "";
            if (aditionalComment.length()==0) return "";
            
            return " ; $"+String.format("%04X", (int)(address&0xffff))+": "+aditionalComment;
        }
        public String getPostString(int pointer)
        {
            if (type == CM_WORD_2) return "";
            if (type == CM_POINTER_2) return "";
            if (ommit) return "";
            if (aditionalComment.length()==0) return "";
            
            return " ; $"+String.format("%04X", (int)(address&0xffff))+": "+"[$"+String.format("%04X", (int)(wordValue&0xffff))+"] "+aditionalComment;
        }
        public boolean hasAdditions()
        {
            if (addressLabel.length()!=0) return true;
            if (aditionalComment.length()!=0) return true;
            if (preCommentLine.length()!=0) return true;
            return false;
        }
        public String toString()
        {
            return getPreString()+getValueString()+getPostString();
        }
    }
    class AKSMemory
    {
        ArrayList<CommentedMemory> m = new ArrayList<CommentedMemory>();
        HashMap<Integer, Integer> trackPointer = new HashMap<Integer, Integer>();
        HashMap<Integer, Integer> specialtrackPointer = new HashMap<Integer, Integer>();
        HashMap<Integer, Integer> instrumentCounter = new HashMap<Integer, Integer>();
        
        String labelId="";
        public void addInstrument(int a)
        {
            instrumentCounter.put(a, a);
        }
        public void addTrackPointer(int a)
        {
            trackPointer.put(a, a);
        }
        public void addSpecialtrackPointer(int a)
        {
            specialtrackPointer.put(a, a);
        }
        
        
        int offset;
        
        public void setOffset(int o)
        {
            offset = o;
            for (CommentedMemory cm : m)
            {
                cm.setOffset(o);
            }            
        }
        AKSMemory(int[] data, String id)
        {
            labelId = id;
            for (int i=0;i<data.length; i++)
            {
                CommentedMemory cm = new CommentedMemory();
                cm.byteValue = data[i];
                cm.address = i; 
                cm.parent = this;
                m.add(cm);
            }
        }
        void addPreComment(int a, String c)
        {
            m.get(a).addPreComment(c);
        }
        void addComment(int a, String c)
        {
            m.get(a).addComment(c);
        }
        void setComment(int a, String c)
        {
            m.get(a).setComment(c);
        }
        void addLabel(int a, String l)
        {
            m.get(a).addLabel(l); 
        }
        void setLabel(int a, String l)
        {
            m.get(a).setLabel(l); 
        }
        CommentedMemory get(int a)
        {
            return m.get(a);
        }
        void setTypeWord(int a)
        {
            m.get(a).type = CM_WORD_1;
            m.get(a+1).type = CM_WORD_2;
            
            int v = m.get(a).byteValue+m.get(a+1).byteValue*256; // little endian is org
            m.get(a).wordValue = v;
        }
        void setTypePointer(int a)
        {
            m.get(a).type = CM_POINTER_1;
            m.get(a+1).type = CM_POINTER_2;
            
            int v = m.get(a).byteValue+m.get(a+1).byteValue*256; // little endian is org
            m.get(a).wordValue = v;
        }
        public String toString()
        {
            StringBuilder b = new StringBuilder();
            boolean newLine;
            int byteCount = 0;
            int lastType = -1;
            for (CommentedMemory cm : m)
            {
                String v = cm.toString();
                if (v.length() == 0) continue;
                String addi ="";
                int type = cm.type;
                if (cm.addressLabel.length() != 0) lastType = -1;
                
                
                
                boolean hasAdditions= cm.hasAdditions();
                
                if (type == CM_BYTE)
                {
                    if ((lastType == type) && (!hasAdditions))
                    {
                        if (byteCount > 10)
                        {
                            addi+="\n db "+v;
                            byteCount = 0;
                        }
                        else
                            addi+=", "+v;
                        byteCount++;
                    }
                    else
                    {
                        addi+="\n"+cm.getPreString();
                        addi+=" db "+cm.getValueString();
                        addi+=cm.getPostString();
                        byteCount = 0;
                        byteCount++;
                    }
                }
                if (type == CM_WORD_1)
                {
                    if ((lastType == type) && (!hasAdditions))
                    {
                        if (byteCount > 5)
                        {
                            addi+="\n dw "+v;
                            byteCount = 0;
                        }
                        else
                            addi+=", "+v;
                        byteCount++;
                    }
                    else
                    {
                        addi+="\n"+cm.getPreString();
                        addi+=" dw "+cm.getValueString();
                        addi+=cm.getPostString();
                        
                        byteCount = 0;
                        byteCount++;
                    }
                }
                if (type == CM_POINTER_1)
                {
                    if ((lastType == type) && (!hasAdditions))
                    {
                        if (byteCount > 5)
                        {
                            addi+="\n dw "+cm.getValueString(); 
                            byteCount = 0;
                        }
                        else
                            addi+=", "+v;
                        byteCount++;
                    }
                    else
                    {
                        addi+="\n"+cm.getPreString();
                        addi+=" dw "+cm.getValueString();
                        addi+=cm.getPostString(cm.wordValue);
                        
                        byteCount = 0;
                        byteCount++;
                    }
                }                

//                addi ="\n$"+String.format("%04X", (int)(cm.address&0xffff))+": "+addi;
                
                b.append(addi);

                if (cm.getPostString().length()==0)
                    lastType = type;
                else
                    lastType = -1;
            }
            return b.toString();
        }
        
    }
    class Instrument
    {
        int[] data;
        int firstInstrumentAddress;
        int intrumentNumber;
        
        Instrument (int[] d, int fi, int no, AKSMemory aks)
        {
            data = d;
            firstInstrumentAddress = fi;
            intrumentNumber = no;

            int addressOfPointer = firstInstrumentAddress+2*intrumentNumber;
            
            aks.addComment(addressOfPointer, "pointer to instrument "+intrumentNumber); 
            aks.setTypePointer(addressOfPointer); 

            
            
            int address = d[addressOfPointer] + d[addressOfPointer+1]*256 - aks.offset;
            aks.addLabel(address, "instrument"+intrumentNumber);
            
            aks.addComment(address++, "speed");
            aks.addComment(address++, "retrig");
            while (true)
            {
                boolean manualFrequency = false;
                int firstByte = d[address++];
                if ((firstByte & 0x01) == 0x00)
                {
                    int firstAddress = address-1;
                    aks.addComment(firstAddress, "dataColumn_0 (non hard)");
                    //NON hard
                    if ((firstByte & 0x02) == 0x02)
                    {
                        // second byte needed
                        int secondByte = d[address++];
                        int secondAddress = address-1;
                        aks.addComment(secondAddress, "dataColumn_1");
                        if ((secondByte & 0x40) == 0x40)
                        {
                            // manual frequency
                            aks.setTypeWord(address);
                            aks.addComment(address, "manual frequency");
                            address+=2;
                            manualFrequency = true;
                        }
                        int s2Noise = secondByte & 0x1f;
                        if (s2Noise>0)
                        {
                            aks.addComment(secondAddress, "noise=$"+String.format("%02X", (int)(s2Noise&0x1f) ) );
                        }
                    }
                    if ((!manualFrequency) && ((firstByte & 0x80) == 0x80))
                    {
                        // pitch
                        aks.setTypeWord(address);
                        aks.addComment(address, "pitch");
                        address+=2;
                    }
                    if ((!manualFrequency) && ((firstByte & 0x40) == 0x40))
                    {
                        // pitch
                        aks.addComment(address, "arpegio");
                        address+=1;
                    }
                    firstByte = firstByte >>>2;
                    firstByte = firstByte & 0x0f;
                    {
                        // volume
                        aks.addComment(firstAddress, "vol=$"+String.format("%01X", (int)(firstByte&0xf) ) );
                    }
                    
                    
                }
                else
                {
                    // Hard sound
                    aks.addComment(address-1, "dataColumn_0 (hard)");
                    if ((firstByte & (0x04+0x08)) == (0x04+0x08))
                    {
                        int instrumentTableAddress = 12;
                        int instrument0Address = d[instrumentTableAddress]+d[instrumentTableAddress+1]*256-aks.offset;
                        int instrument0Loop = instrument0Address+2;
                        
                        // LOOP SOUND
                        aks.setTypePointer(address);
                        aks.addComment(address, "loop");
                        int loopAddress = d[address]+d[address+1]*256-aks.offset;
                        
                        if ((loopAddress != instrument0Loop) || (intrumentNumber == 0)) // instrument 0 loop is special, since virtually any instrument can/might/will use it
                        {
                            aks.addLabel(loopAddress, "instrument"+intrumentNumber+"loop");
                        }
                        address+=2;
                        break;
                    }
                    if ((firstByte & (0x04+0x08)) == (0x04))
                    {
                        // software dependend
                        aks.addComment(address, "software dependend 2. byte");
                        int secondByte = d[address++];
                        if ((firstByte & 0x10) == 0x10)
                        {
                            // manual frequency
                            aks.setTypeWord(address);
                            aks.addComment(address, "manual frequency");
                            address+=2;
                            manualFrequency = true;
                        }
                        if ((!manualFrequency) && ((firstByte & 0x40) == 0x40))
                        {
                            // pitch
                            aks.setTypeWord(address);
                            aks.addComment(address, "pitch");
                            address+=2;
                        }
                        if ((!manualFrequency) && ((firstByte & 0x20) == 0x20))
                        {
                            // pitch
                            aks.addComment(address, "arpegio");
                            address+=1;
                        }
                        if ((firstByte & 0x80) == 0x80)
                        {
                            // hardware pitch
                            aks.setTypeWord(address);
                            aks.addComment(address, "hardware pitch");
                            address+=2;
                        }
                        if ((secondByte & 0x80) == 0x80)
                        {
                            // noise
                            aks.addComment(address, "noise");
                            address+=1;
                        }
                        
                    }
                    if ((firstByte & (0x04+0x08)) == (0))
                    {
                        // hardware dependend
                        aks.addComment(address, "hardware dependend 2. byte");
                        int secondByte = d[address++];
                        if ((firstByte & 0x10) == 0x10)
                        {
                            // manual frequency
                            aks.setTypeWord(address);
                            aks.addComment(address, "manual frequency");
                            address+=2;
                            manualFrequency = true;
                        }
                        if ((!manualFrequency) && ((firstByte & 0x40) == 0x40))
                        {
                            // pitch
                            aks.setTypeWord(address);
                            aks.addComment(address, "pitch");
                            address+=2;
                        }
                        if ((!manualFrequency) && ((firstByte & 0x20) == 0x20))
                        {
                            // arpgio
                            aks.addComment(address, "arpegio");
                            address+=1;
                        }
                        if ((firstByte & 0x80) == 0x80)
                        {
                            // software pitch
                            aks.setTypeWord(address);
                            aks.addComment(address, "software pitch");
                            address+=2;
                        }
                        if ((secondByte & 0x80) == 0x80)
                        {
                            // noise
                            aks.addComment(address, "noise");
                            address+=1;
                        }
                        
                    }
                    if ((firstByte & (0x04+0x08)) == (0x08))
                    {
                        // Independent 
                        boolean hasSound = ((firstByte & 0x80) == 0x80);
                        boolean hasPitch = ((firstByte & 0x40) == 0x40);
                        boolean hasArpegio = ((firstByte & 0x20) == 0x20);
                        boolean hasManualFrequency= ((firstByte & 0x10) == 0x10);
                        aks.addComment(address, "Independent dependend 2. byte");
                        int secondByte = d[address++];
                        boolean hasNoise = ((secondByte & 0x80) == 0x80);
                        boolean hasHardwarePitch = ((secondByte & 0x40) == 0x40);
                        boolean hasHardwareArpegio = ((secondByte & 0x20) == 0x20);
                        boolean hasHardwareManualFrequency = ((secondByte & 0x10) == 0x10);
                        boolean hardwareManualFrequency = false;
                        if (hasSound)
                        {
                            if (hasManualFrequency)
                            {
                                // manual frequency
                                aks.setTypeWord(address);
                                aks.addComment(address, "manual frequency");
                                address+=2;
                                manualFrequency = true;
                            }
                            else
                            {
                                if (hasPitch)
                                {
                                    // pitch
                                    aks.setTypeWord(address);
                                    aks.addComment(address, "independend pitch");
                                    address+=2;
                                }
                                if (hasArpegio)
                                {
                                    // arpgio
                                    aks.addComment(address, "independend arpegio");
                                    address+=1;
                                }
                            }
                        }
                        if (hasHardwareManualFrequency)
                        {
                            // manual frequency
                            aks.setTypeWord(address);
                            aks.addComment(address, "hardware manual frequency");
                            address+=2;
                            hardwareManualFrequency = true;
                        }
                        else
                        {
                            if (hasHardwarePitch)
                            {
                                // hw pitch
                                aks.setTypeWord(address);
                                aks.addComment(address, "inepenended hardware pitch");
                                address+=2;
                            }
                            if (hasHardwareArpegio)
                            {
                                // hw arpgio
                                aks.addComment(address, "independend hardware arpegio");
                                address+=1;
                            }
                        }
                        if (hasNoise)
                        {
                            // noise
                            aks.addComment(address, "independend noise");
                            address+=1;
                        }
                    }
                }
            }
            
        }
    }
    class Track
    {
        int[] data;
        int trackStart;
        int size;
        int lfd;
        int height=0;
        AKSMemory aks;
        void update (int maxHeight)
        {
            if (height>=maxHeight) return;
            height = maxHeight;
            int address = trackStart;
            aks.setLabel(trackStart, "trackDef"+lfd); 
            boolean patternEnd = false;
            int currentHeight = 0;
            while (!patternEnd)
            {
                if (currentHeight>=maxHeight) break;
                boolean parameters = true;
                int t0 = data[address++];
                if ((t0 & 0x01) == 0x01)
                {
                    parameters = false;
                    // full optimization
                    if ((t0&(255-1))==0)
                    {
                        // escape code
                        aks.setComment(address-1, "full optimization, escape necessary"); 
                        
                        int n = data[address];
                        int o = n/12;
                        n = n%12;
                        
                        
                        aks.setComment(address++, "escaped note definition "+notes[n]+""+o);
                    }
                    else
                    {
                        // full opt w/o escape
                        int note = t0&0xff;
                        note = note >>>1;
                        note--;
                        
                        int o = note/12;
                        note = note%12;
                        
                        aks.setComment(address-1, "full optimization, no escape: "+notes[note]+""+o); 
                    }
                }
                else
                {
                    // no full optimization
                    t0 = (t0 & 0xff);
                    t0 = t0 >>>1;
                    if ((t0&0x7f) == 0)
                    {
                        parameters = false;
                        patternEnd = true;
                        aks.setComment(address-1, "track end signature found"); 
                        break;
                    }
                    aks.setComment(address-1, "normal track data"); 
                    t0 -=32;
                    if (t0<0)
                    {
                        // wait
                        int w = t0+32;
                        w --;
                        currentHeight+=w;
                        parameters = false;
                        aks.addComment(address-1, " wait "+w); 
                    }
                    else if (t0==0)
                    {
                        patternEnd = true;
                        aks.setComment(address-1, "note escape found"); 
                        
                        int n = data[address];
                        int o = n/12;
                        n = n%12;
                        aks.setComment(address++, "escaped note definition "+notes[n]+""+o); 
                    }
                    else if (t0<=94)
                    {
                        int p = data[address];
                        if ((p & 0x04) == 0x04)
                        {
                            t0 -=1;
                            // note decoded in t0 now - n use here though
                            int n = t0;
                            int o = n/12;
                            n = n%12;
                            aks.addComment(address-1, " note: "+notes[n]+""+o); 
                        }
                    }
                    else 
                    {
                        aks.addComment(address-1, " w/o note"); 
                    }
                }
                if (parameters)
                {
                    int v = data[address];
                    String comment = "";
                    if ((v & 0x01)==0x01)
                    {
                        v = v >>>1;
                        v = v & 0x0f;
                        comment = "vol = $" +String.format("%01X", 0x0f-v)+" (inverted)";
                    }
                    else
                        comment = "vol off"; 
                    comment += ((v & 0x80)==0x80) ? ", pitch": ", no pitch";
                    comment += ((v & 0x40)==0x40) ? ", note": ", no note";
                    comment += ((v & 0x20)==0x20) ? ", instrument": ", no instrument";
                    
                    aks.setComment(address, comment); 

                    
                    int t1 = data[address++];
                    
                    if ((t1 & 0x80) == 0x80)
                    {
                        // pitch
                        aks.setComment(address, "pitch"); 
                        aks.setTypeWord(address);
                        address+=2;
                    }
                    if ((t1 & 0x20) == 0x20)
                    {
                        // instrument
                        aks.setComment(address, "instrument"); 
                        aks.addInstrument(data[address]);
                        address+=1;
                    }
                }
                currentHeight++;
            }
        }
        Track(int[] d, int ts, int l, AKSMemory a, int maxHeight)
        {
            aks = a;
            lfd = l;
            data = d;
            trackStart = ts;
            update (maxHeight);
        }
    }
    class SpecialTrack
    {
        int[] data;
        int trackStart;
        int size;
        int lfd;

        SpecialTrack(int[] d, int ts, int l, AKSMemory aks)
        {
            lfd = l;
            data = d;
            trackStart = ts;
            int address = trackStart;
            aks.addLabel(address, "specialtrackDef"+lfd); 
            int count = 0;
            while (count <128) // should be pattern height, but I think 128 is also correct
            {
                int st0 = d[address++];
                if ((st0&0x01) == 0)
                {
                    int w = st0>>>1;
                    if (w == 0) w = 128;
                    // wait
                    aks.addComment(address-1, "wait "+w); 
                    count += w;
                }
                else
                {
                    // data
                    aks.addComment(address-1, "data"); 
                    if ((st0 & (0xff-1-2)) == 0)
                    {
                        // escape code
                        int st1 = d[address++];
                        aks.addComment(address-1, "escaped data"); 
                    }
                    else
                    if ((st0 & (0x02)) == 0x02)
                    {
                        aks.addComment(address-1, "digidrum (ignored by vectrex player)"); 
                    }
                    else
                    if ((st0 & (0x02)) == 0x00)
                    {
                        st0 = st0 >>>2;
                        aks.addComment(address-1, "speed "+st0); 
                    }
                }                
            }

        }
    }
    class Pattern
    {
        int[] data;
        int patternStart;
        int size;
        public boolean songOver = false;
        int lfd;
        int height = 0;
        Pattern(int[] d, int ps, int l, AKSMemory aks, int defaultHeight)
        {
            height = defaultHeight;
            lfd = l;
            data = d;
            patternStart = ps;
            int address = patternStart;
            
            int state = data[address++];
            aks.addComment(address-1, "pattern "+lfd+" state");
            aks.addLabel(address-1, "pattern"+lfd+"Definition");
            int t1 = -1;
            int t2 = -1;
            int t3 = -1;
            if ((state & 0x01) == 0x01)
            {
                songOver = true;
                int songRestart = data[address]+data[address+1]*256;
                aks.addComment(address, "song restart address");
                aks.setTypePointer(address);
                address+=2;
            }
            else
            {
                if ((state & 0x02) == 0x02) aks.addComment(address++, "transposition 1");
                if ((state & 0x04) == 0x04) aks.addComment(address++, "transposition 2");
                if ((state & 0x08) == 0x08) aks.addComment(address++, "transposition 3");
                
                t1 = data[address]+data[address+1]*256 -aks.offset;
                aks.addComment(address, "pattern "+lfd+", track 1");
                aks.setTypePointer(address);
                address+=2;
                
                t2 = data[address]+data[address+1]*256 -aks.offset;
                aks.addComment(address, "pattern "+lfd+", track 2");
                aks.setTypePointer(address);
                address+=2;

                t3 = data[address]+data[address+1]*256 -aks.offset;
                aks.addComment(address, "pattern "+lfd+", track 3");
                aks.setTypePointer(address);
                address+=2;

                if ((state & 0x10) == 0x10) 
                {
                    height = d[address];
                    aks.addComment(address++, "new height"); 
                }
                
                if ((state & 0x20) == 0x20) 
                {
                    int st = data[address]+data[address+1]*256-aks.offset;
                    aks.addComment(address, "New Special Track");
                    aks.setTypePointer(address);
                    address+=2;
                    aks.addSpecialtrackPointer(st);
                }
            }
            if (t1 != -1)
            {
                Track t_1 = trackMap.get(t1);
                if (t_1 != null)
                {
                    t_1.update(height);
                }
                else
                {
                    t_1 = new Track(data, t1, trackNo++, aks, height);
                    trackMap.put(t1, t_1);
                }
            }
            if (t2 != -1)
            {
                Track t_2 = trackMap.get(t2);
                if (t_2 != null)
                {
                    t_2.update(height);
                    trackMap.put(t2, t_2);
                }
                else
                {
                    t_2 = new Track(data, t2, trackNo++, aks, height);
                }
            }
            if (t3 != -1)
            {
                Track t_3 = trackMap.get(t3);
                if (t_3 != null)
                {
                    t_3.update(height);
                }
                else
                {
                    t_3 = new Track(data, t3, trackNo++, aks, height);
                    trackMap.put(t3, t_3);
                }
            }
            
            

            
            size = address-patternStart;
        }
        public int size()
        {
            return size;
        }
    }
    class Linker
    {
        int firstHeight;
        int transposition1;
        int transposition2;
        int transposition3;
        int specialTrack;
        String specialTrackString;
        int[] data;
        int linkerStart;
        int height = 0;
        
        ArrayList<Pattern> patterns = new ArrayList<Pattern>();
        
        Linker(int[] d, int ls, AKSMemory aks)
        {
            data = d;
            linkerStart = ls;
            height = firstHeight = d[linkerStart];
            transposition1 = d[linkerStart+1];
            transposition2 = d[linkerStart+2];
            transposition3 = d[linkerStart+3];
            specialTrack = data[linkerStart+4]+data[linkerStart+5]*256 - aks.offset;
            specialTrackString = "$"+String.format("%04X", specialTrack); 

            aks.addLabel(linkerStart, "linker");
            aks.addSpecialtrackPointer(specialTrack);
            
            aks.addPreComment(linkerStart, "start of linker definition");      
            aks.addComment(linkerStart, "first height");      
            aks.addComment(linkerStart+1, "transposition1");      
            aks.addComment(linkerStart+2, "transposition2");      
            aks.addComment(linkerStart+3, "transposition3");      
            aks.addComment(linkerStart+4, "specialTrack");      
            aks.setTypePointer(linkerStart+4);      
            
            int address = linkerStart+6;
            int patternCount = 0;
            while (true)
            {
                Pattern p =new Pattern(data, address, patternCount++, aks, height);
                height = p.height;
                patterns.add(p);
                address+=p.size();
                if (p.songOver) break;
            }
            
            
        }
        
    }
    
    public String buildData(String pathFull, TinyLogInterface logi, String labelID)
    {
        StringBuilder ret = new StringBuilder();
        LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
        int offset =0;
        try
        {
            Path path = Paths.get(pathFull);
            byte[] dataB = Files.readAllBytes(path);
            int[] data = new int[dataB.length];
            int c = 0;
            for (byte b: dataB)
            {
                data[c] = (dataB[c]&0xff);
                c++;
            }
            
            if ((data[0] != 'A') || (data[1] != 'T')|| (data[2] != '1')|| (data[3] != '0'))
            {
                logi.printError("No Arkos Tracker signature found - aborting.");
                return "";
            }
            AKSMemory aks = new AKSMemory(data, labelID);
            aks.get(0).ommit = true;
            aks.get(1).ommit = true;
            aks.get(2).ommit = true;
            aks.get(3).ommit = true;
            aks.get(4).ommit = true;
            aks.get(5).ommit = true;
            aks.get(6).ommit = true;
            aks.get(7).ommit = true;
            aks.get(8).ommit = true;

            aks.addPreComment(9,"This file was build using VIDE - Vectrex Integrated Development Environment");
            aks.addPreComment(9,"Original bin file was: "+pathFull);
            aks.addPreComment(9,"");
            
            aks.addComment(9, "default speed"); 
            
            int sizeOfInstrumentTable = data[10]+data[11]*256;
            aks.setTypeWord(10); 
            aks.addComment(10, "size of instrument table (without this word pointer)"); 

            int instrumentCount = 0;
            int address = 12;

            int instrumentTableAddress = 12;

            offset = 0;//firstInstrumentAddress-12-sizeOfInstrumentTable;
            offset=data[13]*256;
            aks.setOffset(offset);
            
            aks.addPreComment(9,"offset for AKS file assumed: $"+UtilityString.convertToHexWord(offset)+" guessed by accessing byte data[13] * 256)");
            aks.addPreComment(9,"not used by vectrex player and therefor omitted:");
            aks.addPreComment(9," DB \"AT10\" ; Signature of Arkos Tracker files");
            aks.addPreComment(9," DB $"+UtilityString.convertToHex(data, 4, 5, "")+" ; sample channel");
            aks.addPreComment(9," DB $"+UtilityString.convertToHex(data, 5,8, ", ")+" ; YM custom frequence - little endian");
            aks.addPreComment(9," DB $"+UtilityString.convertToHex(data, 8,9, "")+" ; Replay frequency (0=13hz,1=25hz,2=50hz,3=100hz,4=150hz,5=300hz)");

            aks.addLabel(9, "SongAddress");
            
            
            address += sizeOfInstrumentTable;
            // address now at Linker
            Linker linker = new Linker(data,address, aks);
            
            // aks no holds all tracks and special track
            ArrayList<SpecialTrack> stracks = new ArrayList<SpecialTrack>();
            ArrayList<Instrument> instruments = new ArrayList<Instrument>();

            int lfd = 0;
            Set entries = aks.specialtrackPointer.entrySet();
            Iterator it = entries.iterator();
            while (it.hasNext())
            {
                Map.Entry entry = (Map.Entry) it.next();
                Integer trackAddress = (Integer) entry.getValue();
                stracks.add(new SpecialTrack(data, trackAddress, lfd++, aks));
            }

            // make sure instrument 0 is defined at all
            instruments.add(new Instrument(data, instrumentTableAddress, 00, aks));

            // now also all instruments can be ittered
            entries = aks.instrumentCounter.entrySet();
            it = entries.iterator();
            while (it.hasNext())
            {
                Map.Entry entry = (Map.Entry) it.next();
                Integer instrumentNo = (Integer) entry.getValue();
                if (instrumentNo==0) continue;
                instruments.add(new Instrument(data, instrumentTableAddress, instrumentNo, aks));
            }
            
            // than done!
            ret.append(aks);
        }
        catch (Throwable e)
        {
            logi.printError("Something went wrong with AKS - please look in the log.");
            log.addLog(e, WARN);
        }
        return ret.toString();
    }
}
