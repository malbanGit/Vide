/*
 * http://magnevation.com/
 */
package de.malban.vide.vecx;

import de.malban.config.Configuration;
import de.malban.gui.panels.LogPanel;
import static de.malban.gui.panels.LogPanel.INFO;
import de.malban.sound.tinysound.TinySound;
import de.malban.sound.tinysound.internal.MemSound;
import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

/**
 *
 * @author malban
 */
public class VecVoxSamples {
    
    LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
    static final SpeakJetMSA[] allSamples;
    static final SpeakJetMSA[] pauseSamples;
    static final ArrayList<SpeakSpecials> allSpecials;
    static final HashMap<Integer, MemSound> playList;

    static final HashMap<String, String> codeMap;
    static final HashMap <String, Integer> notes;
    static final ArrayList <SpeakSpecials> notesList;
    static boolean init;

    static public class SpeakSpecials
    {
        public String mnemonic;
        public String codes;
        SpeakSpecials(String m, String c)
        {
            mnemonic = m;
            codes = c;
            codeMap.put(mnemonic.substring(1), codes);
            
        }
        
    }
    
    static
    {
        init = false;
        notes = new HashMap <String, Integer>();
        notesList = new ArrayList <SpeakSpecials>();
        codeMap = new HashMap<String, String>();
        allSamples = new SpeakJetMSA[127];
        allSpecials = new ArrayList<SpeakSpecials>();
        pauseSamples = new SpeakJetMSA[7];
        playList = new HashMap<Integer, MemSound>();

        notes.put("C0"	, 16); // 16.35 Hz 
        notes.put("C#0"	, 17); // 17.32 Hz
        notes.put("D0"  , 18); // 18.35 Hz
        notes.put("D#0"	, 19); // 19.45 Hz
        notes.put("E0"	, 21); // 20.60 Hz
        notes.put("F0"	, 22); // 21.83 Hz 
        notes.put("F#0"	, 23); // 23.12 Hz 
        notes.put("G0"	, 24); // 24.50 Hz 
        notes.put("G#0" , 26); // 25.96 Hz 
        notes.put("A0"	, 28); // 27.50 Hz 
        notes.put("A#0" , 29); // 29.14 Hz 
        notes.put("B0"	, 31); // 30.87 Hz 
        notes.put("C1"	, 33); // 32.70 Hz 
        notes.put("C#1"	, 35); // 34.65 Hz 
        notes.put("D1"	, 37); // 36.71 Hz 
        notes.put("D#1" , 39); // 38.89 Hz 
        notes.put("E1"	, 41); // 41.20 Hz 
        notes.put("F1"	, 44); // 43.65 Hz 
        notes.put("F#1"	, 46); // 46.25 Hz 
        notes.put("G1"	, 49); // 49.00 Hz 
        notes.put("G#1"	, 52); // 51.91 Hz 
        notes.put("A1"  , 55); // 55.00 Hz 
        notes.put("A#1" , 58); // 58.27 Hz 
        notes.put("B1"	, 62); // 61.74 Hz 
        notes.put("C2"	, 65); // 65.41 Hz 
        notes.put("C#2" , 69); // 69.30 Hz 
        notes.put("D2"	, 73); // 73.42 Hz 
        notes.put("D#2" , 78); // 77.78 Hz 
        notes.put("E2"	, 82); // 82.41 Hz 
        notes.put("F2"	, 87); // 87.31 Hz 
        notes.put("F#2" , 93); // 92.50 Hz 
        notes.put("G2"	, 98); // 98.00 Hz 
        notes.put("G#2" , 104); // 103.83 Hz
        notes.put("A2"	, 110); // 110.00 Hz
        notes.put("A#2" , 117); // 116.54 Hz
        notes.put("B2"	, 123); // 123.47 Hz
        notes.put("C3"	, 131); // 130.81 Hz
        notes.put("C#3" , 139); // 138.59 Hz
        notes.put("D3"	, 147); // 146.83 Hz
        notes.put("D#3" , 156); // 155.56 Hz
        notes.put("E3"	, 165); // 164.81 Hz
        notes.put("F3"	, 175); // 174.61 Hz
        notes.put("F#3" , 185); // 185.00 Hz
        notes.put("G3"	, 196); // 196.00 Hz
        notes.put("G#3" , 208); // 207.65 Hz
        notes.put("A3"	, 220); // 220.00 Hz
        notes.put("A#3" , 233); // 233.08 Hz
        notes.put("B3"	, 247); // 246.94 Hz    
        
        notesList.add(new SpeakSpecials("\\NTC0"	, "22, 16")); // 16.35 Hz 
        notesList.add(new SpeakSpecials("\\NTC#0"	, "22, 17")); // 17.32 Hz
        notesList.add(new SpeakSpecials("\\NTD0"        , "22, 18")); // 18.35 Hz
        notesList.add(new SpeakSpecials("\\NTD#0"	, "22, 19")); // 19.45 Hz
        notesList.add(new SpeakSpecials("\\NTE0"	, "22, 21")); // 20.60 Hz
        notesList.add(new SpeakSpecials("\\NTF0"	, "22, 22")); // 21.83 Hz 
        notesList.add(new SpeakSpecials("\\NTF#0"	, "22, 23")); // 23.12 Hz 
        notesList.add(new SpeakSpecials("\\NTG0"	, "22, 24")); // 24.50 Hz 
        notesList.add(new SpeakSpecials("\\NTG#0"       , "22, 26")); // 25.96 Hz 
        notesList.add(new SpeakSpecials("\\NTA0"	, "22, 28")); // 27.50 Hz 
        notesList.add(new SpeakSpecials("\\NTA#0"       , "22, 29")); // 29.14 Hz 
        notesList.add(new SpeakSpecials("\\NTB0"	, "22, 31")); // 30.87 Hz 
        notesList.add(new SpeakSpecials("\\NTC1"	, "22, 33")); // 32.70 Hz 
        notesList.add(new SpeakSpecials("\\NTC#1"	, "22, 35")); // 34.65 Hz 
        notesList.add(new SpeakSpecials("\\NTD1"	, "22, 37")); // 36.71 Hz 
        notesList.add(new SpeakSpecials("\\NTD#1"       , "22, 39")); // 38.89 Hz 
        notesList.add(new SpeakSpecials("\\NTE1"	, "22, 41")); // 41.20 Hz 
        notesList.add(new SpeakSpecials("\\NTF1"	, "22, 44")); // 43.65 Hz 
        notesList.add(new SpeakSpecials("\\NTF#1"	, "22, 46")); // 46.25 Hz 
        notesList.add(new SpeakSpecials("\\NTG1"	, "22, 49")); // 49.00 Hz 
        notesList.add(new SpeakSpecials("\\NTG#1"	, "22, 52")); // 51.91 Hz 
        notesList.add(new SpeakSpecials("\\NTA1"        , "22, 55")); // 55.00 Hz 
        notesList.add(new SpeakSpecials("\\NTA#1"       , "22, 58")); // 58.27 Hz 
        notesList.add(new SpeakSpecials("\\NTB1"	, "22, 62")); // 61.74 Hz 
        notesList.add(new SpeakSpecials("\\NTC2"	, "22, 65")); // 65.41 Hz 
        notesList.add(new SpeakSpecials("\\NTC#2"       , "22, 69")); // 69.30 Hz 
        notesList.add(new SpeakSpecials("\\NTD2"	, "22, 73")); // 73.42 Hz 
        notesList.add(new SpeakSpecials("\\NTD#2"       , "22, 78")); // 77.78 Hz 
        notesList.add(new SpeakSpecials("\\NTE2"	, "22, 82")); // 82.41 Hz 
        notesList.add(new SpeakSpecials("\\NTF2"	, "22, 87")); // 87.31 Hz 
        notesList.add(new SpeakSpecials("\\NTF#2"       , "22, 93")); // 92.50 Hz 
        notesList.add(new SpeakSpecials("\\NTG2"	, "22, 98")); // 98.00 Hz 
        notesList.add(new SpeakSpecials("\\NTG#2"       , "22, 104")); // 103.83 Hz
        notesList.add(new SpeakSpecials("\\NTA2"	, "22, 110")); // 110.00 Hz
        notesList.add(new SpeakSpecials("\\NTA#2"       , "22, 117")); // 116.54 Hz
        notesList.add(new SpeakSpecials("\\NTB2"	, "22, 123")); // 123.47 Hz
        notesList.add(new SpeakSpecials("\\NTC3"	, "22, 131")); // 130.81 Hz
        notesList.add(new SpeakSpecials("\\NTC#3"       , "22, 139")); // 138.59 Hz
        notesList.add(new SpeakSpecials("\\NTD3"	, "22, 147")); // 146.83 Hz
        notesList.add(new SpeakSpecials("\\NTD#3"       , "22, 156")); // 155.56 Hz
        notesList.add(new SpeakSpecials("\\NTE3"	, "22, 165")); // 164.81 Hz
        notesList.add(new SpeakSpecials("\\NTF3"	, "22, 175")); // 174.61 Hz
        notesList.add(new SpeakSpecials("\\NTF#3"       , "22, 185")); // 185.00 Hz
        notesList.add(new SpeakSpecials("\\NTG3"	, "22, 196")); // 196.00 Hz
        notesList.add(new SpeakSpecials("\\NTG#3"       , "22, 208")); // 207.65 Hz
        notesList.add(new SpeakSpecials("\\NTA3"	, "22, 220")); // 220.00 Hz
        notesList.add(new SpeakSpecials("\\NTA#3"       , "22, 233")); // 233.08 Hz
        notesList.add(new SpeakSpecials("\\NTB3"	, "22, 247")); // 246.94 Hz   
         loadSamples();
    }
    public static class SpeakJetMSA
    {
        public int code = -1;
        public String phoneme="";
        public String sampleWords="";
        int timing=-1;
        String type = "";
        MemSound sample=null;
        String filename="";

        SpeakJetMSA(int c, String p, String sw, int t, String ty)
        {
            code = c;
            phoneme = p;
            codeMap.put(phoneme, ""+c);
            sampleWords = sw;
            timing = t;
            type = ty;
            String loadname;
            filename = phoneme;
            loadname = "samples"+File.separator+"SpeakJet"+File.separator+filename+".wav";
            sample = (MemSound) TinySound.loadSound(new File(loadname), false);
            if (sample != null)
            {
                playList.put(code, sample);
            }
        }
    }
    
    public static ArrayList<SpeakSpecials> getAllSpecials()
    {
        loadSamples();
        return allSpecials;
    }
    public static SpeakJetMSA[] getAllSamples()
    {
        loadSamples();
        return allSamples;
    }
    public static HashMap<String, String> getCodeMap()
    {
        loadSamples();
        return codeMap;
    }
    
    private static boolean loadSamples()
    {
        if (init) return true;
        for (int i=0; i< 256; i++)
        {
            codeMap.put(""+i, ""+i);
        }
        
        allSpecials.add(new SpeakSpecials("\\P0", "0"));
        allSpecials.add(new SpeakSpecials("\\P1", "1"));
        allSpecials.add(new SpeakSpecials("\\P2", "2"));
        allSpecials.add(new SpeakSpecials("\\P3", "3"));
        allSpecials.add(new SpeakSpecials("\\P4", "4"));
        allSpecials.add(new SpeakSpecials("\\P5", "5"));
        allSpecials.add(new SpeakSpecials("\\P6", "6"));
        allSpecials.add(new SpeakSpecials("\\FAST", "7"));
        allSpecials.add(new SpeakSpecials("\\SLOW", "8"));
        allSpecials.add(new SpeakSpecials("\\SOFT", "8"));
        allSpecials.add(new SpeakSpecials("\\STRESS", "14"));
        allSpecials.add(new SpeakSpecials("\\RELAX", "15"));
        allSpecials.add(new SpeakSpecials("\\VOLUME", "20, x (96)"));
        allSpecials.add(new SpeakSpecials("\\SPEED", "21, x (114)"));
        allSpecials.add(new SpeakSpecials("\\PITCH", "22, x (88)"));
        allSpecials.add(new SpeakSpecials("\\BEND", "23, x (5)"));
        allSpecials.add(new SpeakSpecials("\\REPEAT", "26, x (1)"));
        allSpecials.add(new SpeakSpecials("\\DELAY", "30, x (0)"));
        allSpecials.add(new SpeakSpecials("\\RESET", "31"));
        allSpecials.add(new SpeakSpecials("\\VOX_TERM", "255"));
        
        
        for (SpeakSpecials sps: notesList)
        {
            allSpecials.add(sps); // pitch command
        }
        
        
        int s=0;
        allSamples[s++] = new SpeakJetMSA(128 , "IY",   "See, Even, Feed", 70, "Voiced Long Vowel");
        allSamples[s++] = new SpeakJetMSA(129 , "IH",   "Sit, Fix, Pin", 70, "Voiced Short Vowel");
        allSamples[s++] = new SpeakJetMSA(130 , "EY",   "Hair, Gate, Beige", 70, "Voiced Long Vowel");
        allSamples[s++] = new SpeakJetMSA(131 , "EH",   "Met, Check, Red", 70, "Voiced Short Vowel");
        allSamples[s++] = new SpeakJetMSA(132 , "AY",   "Hat, Fast, Fan", 70, "Voiced Short Vowel");
        allSamples[s++] = new SpeakJetMSA(133 , "AX",   "Cotten", 70, "Voiced Short Vowel");
        allSamples[s++] = new SpeakJetMSA(134 , "UX",   "Luck, Up, Uncle", 70, "Voiced Short Vowel");
        allSamples[s++] = new SpeakJetMSA(135 , "OH",   "Hot, Clock, Fox", 70, "Voiced Short Vowel");
        allSamples[s++] = new SpeakJetMSA(136 , "AW",   "Father, Fall", 70, "Voiced Short Vowel");
        allSamples[s++] = new SpeakJetMSA(137 , "OW",   "Comb, Over, Hold", 70, "Voiced Long Vowel");
        allSamples[s++] = new SpeakJetMSA(138 , "UH",   "Book, Could, Should", 70, "Voiced Short Vowel");
        allSamples[s++] = new SpeakJetMSA(139 , "UW",   "Food, June", 70, "Voiced Long Vowel");
        allSamples[s++] = new SpeakJetMSA(140 , "MM",   "Milk, Famous,", 70, "Voiced Nasal");
        allSamples[s++] = new SpeakJetMSA(141 , "NE",   "Nip, Danger, Thin", 70, "Voiced Nasal");
        allSamples[s++] = new SpeakJetMSA(142 , "NO",   "No, Snow, On", 70, "Voiced Nasal");
        allSamples[s++] = new SpeakJetMSA(143 , "NGE",  "Think, Ping", 70, "Voiced Nasal");
        allSamples[s++] = new SpeakJetMSA(144 , "NGO",  "Hung, Song", 70, "Voiced Nasal");
        allSamples[s++] = new SpeakJetMSA(145 , "LE",   "Lake, Alarm, Lapel", 70, "Voiced Resonate");
        allSamples[s++] = new SpeakJetMSA(146 , "LO",   "Clock, Plus, Hello", 70, "Voiced Resonate");
        allSamples[s++] = new SpeakJetMSA(147 , "WW",   "Wool, Sweat", 70, "Voiced Resonate");
        allSamples[s++] = new SpeakJetMSA(148 , "RR",   "Ray, Brain, Over", 70, "Voiced Resonate");
        allSamples[s++] = new SpeakJetMSA(149 , "IYRR", "Clear, Hear, Year", 200, "Voiced R Color Vowel");
        allSamples[s++] = new SpeakJetMSA(150 , "EYRR", "Hair, Stair, Repair", 200, "Voiced R Color Vowel");
        allSamples[s++] = new SpeakJetMSA(151 , "AXRR", "Fir, Bird, Burn", 190, "Voiced R Color Vowel");
        allSamples[s++] = new SpeakJetMSA(152 , "AWRR", "Part, Farm, Yarn", 200, "Voiced R Color Vowel");
        allSamples[s++] = new SpeakJetMSA(153 , "OWRR", "Corn, Four, Your", 185, "Voiced R Color Vowel");
        allSamples[s++] = new SpeakJetMSA(154 , "EYIY", "Gate, Ate, Ray", 165, "Voiced Diphthong");
        allSamples[s++] = new SpeakJetMSA(155 , "OHIY", "Mice, Fight, White", 200, "Voiced Diphthong");
        allSamples[s++] = new SpeakJetMSA(156 , "OWIY", "Boy, Toy, Voice", 225, "Voiced Diphthong");
        allSamples[s++] = new SpeakJetMSA(157 , "OHIH", "Sky, Five, I", 185, "Voiced Diphthong");
        allSamples[s++] = new SpeakJetMSA(158 , "IYEH", "Yes, Yarn, Million", 170, "Voiced Diphthong");
        allSamples[s++] = new SpeakJetMSA(159 , "EHLL", "Saddle, Angle, Spell", 140, "Voiced Diphthong");
        allSamples[s++] = new SpeakJetMSA(160 , "IYUW", "Cute, Few,", 180, "Voiced Diphthong");
        allSamples[s++] = new SpeakJetMSA(161 , "AXUW", "Brown, Clown, Thousand", 170, "Voiced Diphthong");
        allSamples[s++] = new SpeakJetMSA(162 , "IHWW", "Two, New, Zoo", 170, "Voiced Diphthong");
        allSamples[s++] = new SpeakJetMSA(163 , "AYWW", "Our, Ouch, Owl", 200, "Voiced Diphthong");
        allSamples[s++] = new SpeakJetMSA(164 , "OWWW", "Go, Hello, Snow", 131, "Voiced Diphthong");
        allSamples[s++] = new SpeakJetMSA(165 , "JH",   "Dodge, Jet, Savage", 70, "Voiced Affricate");
        allSamples[s++] = new SpeakJetMSA(166 , "VV",   "Vest, Even,", 70, "Voiced Fictive");
        allSamples[s++] = new SpeakJetMSA(167 , "ZZ",   "Zoo, Zap", 70, "Voiced Fictive");
        allSamples[s++] = new SpeakJetMSA(168 , "ZH",   "Azure, Treasure", 70, "Voiced Fictive");
        allSamples[s++] = new SpeakJetMSA(169 , "DH",   "There, That, This", 70, "Voiced Fictive");
        allSamples[s++] = new SpeakJetMSA(170 , "BE",   "Bear, Bird, Beed", 45, "Voiced Stop");
        allSamples[s++] = new SpeakJetMSA(171 , "BO",   "Bone, Book Brown", 45, "Voiced Stop");
        allSamples[s++] = new SpeakJetMSA(172 , "EB",   "Cab, Crib, Web", 10, "Voiced Stop");
        allSamples[s++] = new SpeakJetMSA(173 , "OB",   "Bob, Sub, Tub", 10, "Voiced Stop");
        allSamples[s++] = new SpeakJetMSA(174 , "DE",   "Deep, Date, Divide", 45, "Voiced Stop");
        allSamples[s++] = new SpeakJetMSA(175 , "DO",   "Do, Dust, Dog", 45, "Voiced Stop");
        allSamples[s++] = new SpeakJetMSA(176 , "ED",   "Could, Bird", 10, "Voiced Stop");
        allSamples[s++] = new SpeakJetMSA(177 , "OD",   "Bud, Food", 10, "Voiced Stop");
        allSamples[s++] = new SpeakJetMSA(178 , "GE",   "Get, Gate, Guest,", 55, "Voiced Stop");
        allSamples[s++] = new SpeakJetMSA(179 , "GO",   "Got, Glue, Goo", 55, "Voiced Stop");
        allSamples[s++] = new SpeakJetMSA(180 , "EG",   "Peg, Wig", 55, "Voiced Stop");
        allSamples[s++] = new SpeakJetMSA(181 , "OG",   "Dog, Peg", 55, "Voiced Stop");
        allSamples[s++] = new SpeakJetMSA(182 , "CH",   "Church, Feature, March", 70, "Voiceless Affricate");
        allSamples[s++] = new SpeakJetMSA(183 , "HE",   "Help, Hand, Hair", 70, "Voiceless Fricative");
        allSamples[s++] = new SpeakJetMSA(184 , "HO",   "Hoe, Hot, Hug", 70, "Voiceless Fricative");
        allSamples[s++] = new SpeakJetMSA(185 , "WH",   "Who, Whale, White", 70, "Voiceless Fricative");
        allSamples[s++] = new SpeakJetMSA(186 , "FF",   "Food, Effort, Off", 70, "Voiceless Fricative");
        allSamples[s++] = new SpeakJetMSA(187 , "SE",   "See, Vest, Plus", 40, "Voiceless Fricative");
        allSamples[s++] = new SpeakJetMSA(188 , "SO",   "So, Sweat", 40, "Voiceless Fricative");
        allSamples[s++] = new SpeakJetMSA(189 , "SH",   "Ship, Fiction, Leash", 50, "Voiceless Fricative");
        allSamples[s++] = new SpeakJetMSA(190 , "TH",   "Thin, month", 40, "Voiceless Fricative");
        allSamples[s++] = new SpeakJetMSA(191 , "TT",   "Part, Little, Sit", 50, "Voiceless Stop");
        allSamples[s++] = new SpeakJetMSA(192 , "TU",   "To, Talk, Ten", 70, "Voiceless Stop");
        allSamples[s++] = new SpeakJetMSA(193 , "TS",   "Parts, Costs, Robots", 170, "Voiceless Stop");
        allSamples[s++] = new SpeakJetMSA(194 , "KE",   "Can't, Clown, Key", 55, "Voiceless Stop");
        allSamples[s++] = new SpeakJetMSA(195 , "KO",   "Comb, Quick, Fox", 55, "Voiceless Stop");
        allSamples[s++] = new SpeakJetMSA(196 , "EK",   "Speak, Task", 55, "Voiceless Stop");
        allSamples[s++] = new SpeakJetMSA(197 , "OK",   "Book, Took, October", 45, "Voiceless Stop");
        allSamples[s++] = new SpeakJetMSA(198 , "PE",   "People, Computer", 99, "Voiceless Stop");
        allSamples[s++] = new SpeakJetMSA(199 , "PO",   "Paw, Copy", 99, "Voiceless Stop");
        allSamples[s++] = new SpeakJetMSA(200 , "R0",   "", 80, "Robot");
        allSamples[s++] = new SpeakJetMSA(201 , "R1",   "", 80, "Robot");
        allSamples[s++] = new SpeakJetMSA(202 , "R2",   "", 80, "Robot");
        allSamples[s++] = new SpeakJetMSA(203 , "R3",   "", 80, "Robot");
        allSamples[s++] = new SpeakJetMSA(204 , "R4",   "", 80, "Robot");
        allSamples[s++] = new SpeakJetMSA(205 , "R5",   "", 80, "Robot");
        allSamples[s++] = new SpeakJetMSA(206 , "R6",   "", 80, "Robot");
        allSamples[s++] = new SpeakJetMSA(207 , "R7",   "", 80, "Robot");
        allSamples[s++] = new SpeakJetMSA(208 , "R8",   "", 80, "Robot");
        allSamples[s++] = new SpeakJetMSA(209 , "R9",   "", 80, "Robot");
        allSamples[s++] = new SpeakJetMSA(210 , "A0",   "", 300, "Alarm");
        allSamples[s++] = new SpeakJetMSA(211 , "A1",   "", 101, "Alarm");
        allSamples[s++] = new SpeakJetMSA(212 , "A2",   "", 102, "Alarm");
        allSamples[s++] = new SpeakJetMSA(213 , "A3",   "", 540, "Alarm");
        allSamples[s++] = new SpeakJetMSA(214 , "A4",   "", 530, "Alarm");
        allSamples[s++] = new SpeakJetMSA(215 , "A5",   "", 500, "Alarm");
        allSamples[s++] = new SpeakJetMSA(216 , "A6",   "", 135, "Alarm");
        allSamples[s++] = new SpeakJetMSA(217 , "A7",   "", 600, "Alarm");
        allSamples[s++] = new SpeakJetMSA(218 , "A8",   "", 300, "Alarm");
        allSamples[s++] = new SpeakJetMSA(219 , "A9",   "", 250, "Alarm");
        allSamples[s++] = new SpeakJetMSA(220 , "B0",   "", 200, "Beeps");
        allSamples[s++] = new SpeakJetMSA(221 , "B1",   "", 270, "Beeps");
        allSamples[s++] = new SpeakJetMSA(222 , "B2",   "", 280, "Beeps");
        allSamples[s++] = new SpeakJetMSA(223 , "B3",   "", 260, "Beeps");
        allSamples[s++] = new SpeakJetMSA(224 , "B4",   "", 300, "Beeps");
        allSamples[s++] = new SpeakJetMSA(225 , "B5",   "", 100, "Beeps");
        allSamples[s++] = new SpeakJetMSA(226 , "B6",   "", 104, "Beeps");
        allSamples[s++] = new SpeakJetMSA(227 , "B7",   "", 100, "Beeps");
        allSamples[s++] = new SpeakJetMSA(228 , "B8",   "", 270, "Beeps");
        allSamples[s++] = new SpeakJetMSA(229 , "B9",   "", 262, "Beeps");
        allSamples[s++] = new SpeakJetMSA(230 , "C0",   "", 160, "Biological");
        allSamples[s++] = new SpeakJetMSA(231 , "C1",   "", 300, "Biological");
        allSamples[s++] = new SpeakJetMSA(232 , "C2",   "", 182, "Biological");
        allSamples[s++] = new SpeakJetMSA(233 , "C3",   "", 120, "Biological");
        allSamples[s++] = new SpeakJetMSA(234 , "C4",   "", 175, "Biological");
        allSamples[s++] = new SpeakJetMSA(235 , "C5",   "", 350, "Biological");
        allSamples[s++] = new SpeakJetMSA(236 , "C6",   "", 160, "Biological");
        allSamples[s++] = new SpeakJetMSA(237 , "C7",   "", 260, "Biological");
        allSamples[s++] = new SpeakJetMSA(238 , "C8",   "", 95 , "Biological");
        allSamples[s++] = new SpeakJetMSA(239 , "C9",   "", 75 , "Biological");
        allSamples[s++] = new SpeakJetMSA(240 , "D0",   "0", 95, "DTMF");
        allSamples[s++] = new SpeakJetMSA(241 , "D1",   "1", 95, "DTMF");
        allSamples[s++] = new SpeakJetMSA(242 , "D2",   "2", 95, "DTMF");
        allSamples[s++] = new SpeakJetMSA(243 , "D3",   "3", 95, "DTMF");
        allSamples[s++] = new SpeakJetMSA(244 , "D4",   "4", 95, "DTMF");
        allSamples[s++] = new SpeakJetMSA(245 , "D5",   "5", 95, "DTMF");
        allSamples[s++] = new SpeakJetMSA(246 , "D6",   "6", 95, "DTMF");
        allSamples[s++] = new SpeakJetMSA(247 , "D7",   "7", 95, "DTMF");
        allSamples[s++] = new SpeakJetMSA(248 , "D8",   "8", 95, "DTMF");
        allSamples[s++] = new SpeakJetMSA(249 , "D9",   "9", 95, "DTMF");
        allSamples[s++] = new SpeakJetMSA(250 , "D10",  "*", 95, "DTMF");
        allSamples[s++] = new SpeakJetMSA(251 , "D11",  "#", 95, "DTMF");
        allSamples[s++] = new SpeakJetMSA(252 , "M0",   "Sonar Ping", 125, "Miscellaneous");
        allSamples[s++] = new SpeakJetMSA(253 , "M1",   "Pistol Shot", 250, "Miscellaneous");
        allSamples[s++] = new SpeakJetMSA(254 , "M2",   "WOW", 530, "Miscellaneous");
        
        
        pauseSamples[1] = new SpeakJetMSA(1 , "PA1",   "Pause1", 100, "Pause");
        pauseSamples[2] = new SpeakJetMSA(2 , "PA2",   "Pause2", 200, "Pause");
        pauseSamples[3] = new SpeakJetMSA(3 , "PA3",   "Pause3", 700, "Pause");
        pauseSamples[4] = new SpeakJetMSA(4 , "PA4",   "Pause4", 30, "Pause");
        pauseSamples[5] = new SpeakJetMSA(5 , "PA5",   "Pause5", 60, "Pause");
        pauseSamples[6] = new SpeakJetMSA(6 , "PA6",   "Pause6", 90, "Pause");
        
        ((LogPanel) Configuration.getConfiguration().getDebugEntity()).addLog("VecVox: samples loaded.", INFO);
        init = true;
        return true;
    }

    public static MemSound getPauseSample(int pause)
    {
        return getSample(pause);
    }
    public static MemSound getSample(int code)
    {
        if (playList == null) 
        {
            ((LogPanel) Configuration.getConfiguration().getDebugEntity()).addLog("VecVox: samples not initialized", INFO);
            return null;
        }
        MemSound sample = playList.get(code);
        if (sample == null)
        {
            ((LogPanel) Configuration.getConfiguration().getDebugEntity()).addLog("VecVox: sample for code: "+code+" not found", INFO);
            return null;
        }
        return sample;
    }
    public static MemSound playSample(int code)
    {
        MemSound sample = getSample(code);
        if (sample == null) return null;
        sample.play();
        ((LogPanel) Configuration.getConfiguration().getDebugEntity()).addLog("VecVox: playing sample for code: "+code, INFO);
        return sample;
    }

}

