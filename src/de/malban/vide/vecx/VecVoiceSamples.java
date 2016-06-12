/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx;

import de.malban.config.Configuration;
import de.malban.gui.panels.LogPanel;
import static de.malban.gui.panels.LogPanel.INFO;
import de.malban.sound.tinysound.TinySound;
import de.malban.sound.tinysound.internal.MemSound;
import java.io.File;
import java.util.HashMap;

/**
 *
 * @author malban
 */
public class VecVoiceSamples {
    LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
    static SpeakJetMSA[] allSamples;
    static HashMap<String, String> mapping;
    static HashMap<Integer, MemSound> playList;

    static
    {
        mapping = new HashMap<String, String>();
        allSamples = null;
        mapping.put("IY",   "IY"); 
        mapping.put("IH",   "IH"); 
        mapping.put("EY",   "EY"); 
        mapping.put("EH",   "EH"); 
        mapping.put("AY",   "AE"); 
        mapping.put("AX",   "AO"); 
        mapping.put("UX",   "AW"); 
        mapping.put("OH",   "AA"); 
        mapping.put("AW",   "AA"); 
        mapping.put("OW",   "OW");
        mapping.put("UH",   "UH"); 
        mapping.put("UW",   "UW2"); 
        mapping.put("MM",   "MM"); 
        mapping.put("NE",   "NN1"); 
        mapping.put("NO",   "NN2"); 
        mapping.put("NGE",  "NN1");
        mapping.put("NGO",  "NN1");
        mapping.put("LE",   "LL"); 
        mapping.put("LO",   "LL"); 
        mapping.put("WW",   "WW"); 
        mapping.put("RR",   "RR2"); 
        mapping.put("IYRR", "YR");
        mapping.put("EYRR", "ER1");
        mapping.put("AXRR", "ER2");
        mapping.put("AWRR", "AR");
        mapping.put("OWRR", "OR");
        mapping.put("EYIY", "EY");
        mapping.put("OHIY", "AY");
        mapping.put("OWIY", "OY");
        mapping.put("OHIH", "AY");
        mapping.put("IYEH", "YY2");
        mapping.put("EHLL", "LL");
        mapping.put("IYUW", "UW2");
        mapping.put("AXUW", "AW");
        mapping.put("IHWW", "UW1");
        mapping.put("AYWW", "AW");
        mapping.put("OWWW", "AO");
        mapping.put("JH",   "JH"); 
        mapping.put("VV",   "VV"); 
        mapping.put("ZZ",   "ZZ"); 
        mapping.put("ZH",   "ZH"); 
        mapping.put("DH",   "DH1"); 
        mapping.put("BE",   "BB2"); 
        mapping.put("BO",   "BB2"); 
        mapping.put("EB",   "BB1"); 
        mapping.put("OB",   "BB1"); 
        mapping.put("DE",   "DD2"); 
        mapping.put("DO",   "DD2"); 
        mapping.put("ED",   "DD1"); 
        mapping.put("OD",   "DD1"); 
        mapping.put("GE",   "GG1"); 
        mapping.put("GO",   "GG1"); 
        mapping.put("EG",   "GG3"); 
        mapping.put("OG",   "GG3"); 
        mapping.put("CH",   "CH"); 
        mapping.put("HE",   "HH1"); 
        mapping.put("HO",   "HH1"); 
        mapping.put("WH",   "WH"); 
        mapping.put("FF",   "FF"); 
        mapping.put("SE",   "SS"); 
        mapping.put("SO",   "SS"); 
        mapping.put("SH",   "SH"); 
        mapping.put("TH",   "TH"); 
        mapping.put("TT",   "TT1"); 
        mapping.put("TU",   "TT2"); 
        mapping.put("TS",   "TT1"); 
        mapping.put("KE",   "KK1"); 
        mapping.put("KO",   "KK3"); 
        mapping.put("EK",   "KK1"); 
        mapping.put("OK",   "KK1"); 
        mapping.put("PE",   "PP"); 
        mapping.put("PO",   "PP"); 
        mapping.put("R0",   "R0"); 
        mapping.put("R1",   "R1"); 
        mapping.put("R2",   "R2"); 
        mapping.put("R3",   "R3"); 
        mapping.put("R4",   "R4"); 
        mapping.put("R5",   "R5"); 
        mapping.put("R6",   "R6"); 
        mapping.put("R7",   "R7"); 
        mapping.put("R8",   "R8"); 
        mapping.put("R9",   "R9"); 
        mapping.put("A0",   "A0"); 
        mapping.put("A1",   "A1"); 
        mapping.put("A2",   "A2"); 
        mapping.put("A3",   "A3"); 
        mapping.put("A4",   "A4"); 
        mapping.put("A5",   "A5"); 
        mapping.put("A6",   "A6"); 
        mapping.put("A7",   "A7"); 
        mapping.put("A8",   "A8"); 
        mapping.put("A9",   "A9"); 
        mapping.put("B0",   "B0"); 
        mapping.put("B1",   "B1"); 
        mapping.put("B2",   "B2"); 
        mapping.put("B3",   "B3"); 
        mapping.put("B4",   "B4"); 
        mapping.put("B5",   "B5"); 
        mapping.put("B6",   "B6"); 
        mapping.put("B7",   "B7"); 
        mapping.put("B8",   "B8"); 
        mapping.put("B9",   "B9"); 
        mapping.put("C0",   "C0"); 
        mapping.put("C1",   "C1"); 
        mapping.put("C2",   "C2"); 
        mapping.put("C3",   "C3"); 
        mapping.put("C4",   "C4"); 
        mapping.put("C5",   "C5"); 
        mapping.put("C6",   "C6"); 
        mapping.put("C7",   "C7"); 
        mapping.put("C8",   "C8"); 
        mapping.put("C9",   "C9"); 
        mapping.put("D0",   "D0"); 
        mapping.put("D1",   "D1"); 
        mapping.put("D2",   "D2"); 
        mapping.put("D3",   "D3"); 
        mapping.put("D4",   "D4"); 
        mapping.put("D5",   "D5"); 
        mapping.put("D6",   "D6"); 
        mapping.put("D7",   "D7"); 
        mapping.put("D8",   "D8"); 
        mapping.put("D9",   "D9"); 
        mapping.put("D10",  "D10");
        mapping.put("D11",  "D11");
        mapping.put("M0",   "M0"); 
        mapping.put("M1",   "M1"); 
        mapping.put("M2",   "M2"); 

    }
    static class SpeakJetMSA
    {
        int code = -1;
        String phoneme="";
        String sampleWords="";
        int timing=-1;
        String type = "";
        MemSound sample=null;
        String filename="";

        SpeakJetMSA(int c, String p, String sw, int t, String ty)
        {
            code = c;
            phoneme = p;
            sampleWords = sw;
            timing = t;
            type = ty;
            filename = getSP0256Mapping(phoneme);
            
            
            String loadname = "samples"+File.separator+filename+".wav";
            sample = (MemSound) TinySound.loadSound(new File(loadname), false);
            if (sample != null)
            {
                playList.put(code, sample);
            }
        }
    }
    
                
    private static String getSP0256Mapping(String msaPhoneme)
    {
        return mapping.get(msaPhoneme);
    }
    
    
    public static boolean loadSamples()
    {
        if (allSamples != null) return true;
        allSamples = new SpeakJetMSA[128];
        playList = new HashMap<Integer, MemSound>();
        
        

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
        ((LogPanel) Configuration.getConfiguration().getDebugEntity()).addLog("VecVoice: samples loaded.", INFO);
        return true;
    }


    public static MemSound playSample(int code)
    {
        if (playList == null) 
        {
            ((LogPanel) Configuration.getConfiguration().getDebugEntity()).addLog("VecVoice: samples not initialized", INFO);
            return null;
        }
        MemSound sample = playList.get(code);
        if (sample == null)
        {
            ((LogPanel) Configuration.getConfiguration().getDebugEntity()).addLog("VecVoice: sample for code: "+code+" not found", INFO);
            return null;
        }
        
        
        sample.play();
        ((LogPanel) Configuration.getConfiguration().getDebugEntity()).addLog("VecVoice: playing sample for code: "+code, INFO);
        return sample;
    }

}
