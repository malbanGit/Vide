/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vedi.sound;

import de.malban.config.Configuration;
import de.malban.gui.panels.LogPanel;
import static de.malban.gui.panels.LogPanel.WARN;
import de.malban.vide.vedi.sound.ModJPanel.InstrumentHandle;
import de.malban.vide.vedi.sound.ModJPanel.VectrexInstrument;
import java.io.File;
import java.io.FileInputStream;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;


/**
 * Mod2Vectrex v1.08 - 02.01.2011 by Wolf (the@BigBadWolF.de), additions by Nitro/NCE
 * 
 * @author malban
 * 
 *                         // http://www.fileformat.info/format/mod/corion.htm

 */
public class Mod2Vectrex 
{
    LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
    public Mod2Vectrex()
    {
        vectrexModMapping[0] = 0;
        vectrexModMapping[1] = 1;
        vectrexModMapping[2] = 2;
    }
    class tone_type
    {
        byte instrument;
        int period;
        byte note;
        byte effect1;
        byte effect2;
        byte effect3;
    }
    class voice_type
    {
        tone_type[] tone = new tone_type[64];
        public voice_type()
        {
            for (int i=0; i< 64; i++)
            {
                tone[i] = new tone_type();
            }
        }
        
    }
    class pattern_type
    {
        voice_type[] voice = new voice_type[4];
        public pattern_type()
        {
            for (int i=0; i< 4; i++)
            {
                voice[i] = new voice_type();
            }
        }
        boolean used;
    }
    class sample_type
    {
        String name;
        int length;         // * 2 gives real length in bytes, big-endian (swap lo,high)
        byte finetune;      // mask upper 4 bits
        byte volume;        // 0-64
        int repeat_pos;     // * 2 gives offset in bytes
        int repeat_length;  // * 2 gives replen in bytes
    }
    
    public static byte SPEED = 2;
    public static byte BASS_DRUM_VALUE = 63;
    public static byte HIHAT_DRUM_VALUE = 1;
    public static byte SNARE_DRUM_VALUE = 47;
    
    public static String PROGNAME = "VIDE: Mod2Vectrex";
    public static String VERSION = "1.08";
    public static String _DATE = "02.01.2011";
    public static String AUTHOR = "Wolf, additions by Nitro/NCE, PAS to Java by Malban";
    
    
    public static byte VERBOSITY = 1;
    public static String HEXPRE = "0123456789ABCDEF";

    public static int[] PERIOD = {// 12 * 7
                    //{C-1}
                    3424,3232,3048,2880,2712,2560,2416,2280,2152,2032,1920,1812,
                    //{C-2}
                    1712,1616,1524,1440,1356,1280,1208,1140,1076,1016,960,906,
                    //{C-3}
                    856,808,762,720,678,640,604,570,538,508,480,453,
                    //{C-4}
                    428,404,381,360,339,320,302,285,269,254,240,226,
                    //{C-5}
                    214,202,190,180,170,160,151,143,135,127,120,113,
                    //{C-6}
                    107,101,95,90,85,80,75,71,67,63,60,56,
                    //{C-7}
                    53,50,47,45,42,40,37,35,33,31,30,28
            };
    public static int[] PSG_PERIOD = {// 12 * 7
                    //{C-1}
                    64*065+035,64*062+034,64*057+047,64*054+074,64*052+033,64*050+02,64*045+063,64*043+053,64*041+053,64*047+062,64*036+00,64*034+024,
                    //{C-2}
                    64*032+056,64*031+016,64*027+064,64*026+036,64*025+015,64*024+01,64*022+071,64*021+065,64*020+065,64*017+071,64*017+00,64*016+012,
                    //{C-3}
                    64*015+027,64*014+047,64*013+072,64*013+017,64*012+047,64*012+01,64*011+035,64*010+073,64*010+033,64*007+074,64*007+040,64*007+005,
                    //{C-4}
                    64*006+054,64*006+024,64*005+075,64*005+050,64*005+023,64*005+00,64*004+056,64*004+035,64*004+015,64*003+076,64*003+060,64*003+042,
                    //{C-5}
                    64*003+026,64*003+012,64*002+076,64*002+064,64*002+052,64*002+040,64*002+027,64*002+017,64*002+07,64*001+077,64*001+070,64*001+061,
                    //{C-6}
                    64*001+053,64*001+045,64*001+037,64*001+032,64*001+025,64*001+020,64*001+014,64*001+07,64*001+03,64*001+0,64*000+074,64*000+071,
                    //{C-7}
                    64*000+065,64*000+062,64*000+060,64*000+055,64*000+052,64*000+050,64*000+046,64*000+044,64*000+042,64*000+040,64*000+036,64*000+034,
                    //{C-8}
                    64*000+033,64*000+031,64*000+030,64*000+026,64*000+025,64*000+024,64*000+023,64*000+022,64*000+021,64*000+030,64*000+017,64*000+016
            };
    
    public static HashMap<Integer, Integer> freq2Index = new HashMap<>();
    static
    {
        for (int i=0; i< 12*7; i++)
        {
            freq2Index.put(PSG_PERIOD[i], i);
        }
    }
    
    public static String[] NAME = {
                    "C-1", "C#1", "D-1", "D#1", "E-1", "F-1", "F#1", "G-1", "G#1", "A-1", "A#1", "H-1",
                    "C-2", "C#2", "D-2", "D#2", "E-2", "F-2", "F#2", "G-2", "G#2", "A-2", "A#2", "H-2",
                    "C-3", "C#3", "D-3", "D#3", "E-3", "F-3", "F#3", "G-3", "G#3", "A-3", "A#3", "H-3",
                    "C-4", "C#4", "D-4", "D#4", "E-4", "F-4", "F#4", "G-4", "G#4", "A-4", "A#4", "H-4",
                    "C-5", "C#5", "D-5", "D#5", "E-5", "F-5", "F#5", "G-5", "G#5", "A-5", "A#5", "H-5",
                    "C-6", "C#6", "D-6", "D#6", "E-6", "F-6", "F#6", "G-6", "G#6", "A-6", "A#6", "H-6",
                    "C-7", "C#7", "D-7", "D#7", "E-7", "F-7", "F#7", "G-7", "G#7", "A-7", "A#7", "H-7" 
            };
    
    public static String[] VEC_NOTES=
    {
        "G2_",
        "GS2",
        "A2_",
        "AS2",
        "B2_",
        "C3_",
        "CS3",
        "D3_",
        "DS3",
        "E3_",
        "F3_",
        "FS3",
        "G3_",
        "GS3",
        "A3_",
        "AS3",
        "B3_",
        "C4_",
        "CS4",
        "D4_",
        "DS4",
        "E4_",
        "F4_",
        "FS4",
        "G4_",
        "GS4",
        "A4_",
        "AS4",
        "B4_",
        "C5_",
        "CS5",
        "D5_",
        "DS5",
        "E5_",
        "F5_",
        "FS5",
        "G5_",
        "GS5",
        "A5_",
        "AS5",
        "B5_",
        "C6_",
        "CS6",
        "D6_",
        "DS6",
        "E6_",
        "F6_",
        "FS6",
        "G6_",
        "GS6",
        "A6_",
        "AS6",
        "B6_",
        "C7_",
        "CS7",
        "D7_",
        "DS7",
        "E7_",
        "F7_",
        "FS7",
        "G7_",
        "GS7",
        "A7_",
        "AS7" 

    };
    
    
    public static byte OFFNOTE_VALUE = 84;
    public static String OFFNOTE = "---";
    
    public static String[] EFFECT_INFO = {
                    "Protracker V2.3A/3.01 Effect Commands",
                    "----------------------------------------------------------------------------",
                    "0 - Normal play or Arpeggio             0xy : x-first halfnote add, y-second",
                    "1 - Slide Up                            1xx : upspeed",
                    "2 - Slide Down                          2xx : downspeed",
                    "3 - Tone Portamento                     3xx : up/down speed",
                    "4 - Vibrato                             4xy : x-speed,   y-depth",
                    "5 - Tone Portamento + Volume Slide      5xy : x-upspeed, y-downspeed",
                    "6 - Vibrato + Volume Slide              6xy : x-upspeed, y-downspeed",
                    "7 - Tremolo                             7xy : x-speed,   y-depth",
                    "8 - NOT USED",
                    "9 - Set SampleOffset                    9xx : offset (23 -> 2300)",
                    "A - VolumeSlide                         Axy : x-upspeed, y-downspeed",
                    "B - Position Jump                       Bxx : songposition",
                    "C - Set Volume                          Cxx : volume, 00-40",
                    "D - Pattern Break                       Dxx : break position in next pattern",
                    "E - E-Commands                          Exy : see below...",
                    "F - Set Speed                           Fxx : speed (00-1F) / tempo (20-FF)",
                    "----------------------------------------------------------------------------",
                    "E0- Set Filter                          E0x : 0-filter on, 1-filter off",
                    "E1- FineSlide Up                        E1x : value",
                    "E2- FineSlide Down                      E2x : value",
                    "E3- Glissando Control                   E3x : 0-off, 1-on (use with tonep.)",
                    "E4- Set Vibrato Waveform                E4x : 0-sine, 1-ramp down, 2-square",
                    "E5- Set Loop                            E5x : set loop point",
                    "E6- Jump to Loop                        E6x : jump to loop, play x times",
                    "E7- Set Tremolo Waveform                E7x : 0-sine, 1-ramp down. 2-square",
                    "E8- NOT USED",
                    "E9- Retrig Note                         E9x : retrig from note + x vblanks",
                    "EA- Fine VolumeSlide Up                 EAx : add x to volume",
                    "EB- Fine VolumeSlide Down               EBx : subtract x from volume",
                    "EC- NoteCut                             ECx : cut from note + x vblanks",
                    "ED- NoteDelay                           EDx : delay note x vblanks",
                    "EE- PatternDelay                        EEx : delay pattern x notes",
                    "EF- Invert Loop                         EFx : speed",
                    "----------------------------------------------------------------------------"
            };
    pattern_type[] pattern = new pattern_type[128];
    sample_type[] sample = new sample_type[32];
    byte songlength;
    String songName;
    String trackerID; // 4 chars
    String inModName;
    String outTxtName;
    String outVecFile;
    byte[] pattern_position = new byte[128];
    byte pattern_number;
    byte loop_position;

    String hex(byte input)
    {
        return String.format("%02X", input);
    }
    String hexShort(byte input)
    {
        return String.format("%01X", input&0xf);
    }  
    void show_message()
    {
        stdOut.append(PROGNAME+" v"+VERSION+" - "+_DATE+" by "+AUTHOR+"\n");
        stdOut.append("\n");
    }
    byte findNote(int period_in)
    {
        byte ret = OFFNOTE_VALUE;
        for (int a = 0; a<=(12*7-1); a++)
        {
            if (period_in == PERIOD[a]) 
            {
                ret = (byte)(a-7);
            }
        }
        return ret;
    }
    void findPatternNumber()
    {
        pattern_number = 0;
        for (int a = 0; a<=songlength; a++)
        {
            if (pattern_position[a]>pattern_number) 
                pattern_number = pattern_position[a]; 
        }
    }
    boolean readMod(String fileName)
    {
        File file;
        FileInputStream fin=null;
        byte[] data = new byte[4];
        int c,d,e,f;
        char swapChar;
        songName = "";
        stdOut.append("Reading file \""+fileName+"\""+"\n");
        file=new File(fileName);
        byte a[] = new byte[(int)file.length()];
        int pos = 0;
        if (VERBOSITY>0) stdOut.append("Reading songName..."+"\n");
        try 
        {
            fin = new FileInputStream(file);
            fin.read(a);
        }
        catch (Throwable ex)
        {
            log.addLog(ex, WARN);               
            return false; // error
        }
        finally
        {
            try 
            {
                fin.close();
            }
            catch (Throwable ex)
            {
                log.addLog(ex, WARN);               
                return false; // error
            }        
        }
        // reading out songName
        for (c=1;c<=20;c++)
        {
            swapChar = 0;
            if (pos<a.length) swapChar = (char)a[(pos++)];
            if (swapChar != 0) songName = songName + swapChar;
        }
        if (VERBOSITY>0) stdOut.append("Reading Samples..."+"\n");
        
        // reading samples}
        for (c = 1;c<=31;c++)
        {
            sample[c].name = "";
            for (d = 1; d<=22;d++)
            {
                swapChar = 0;
                if (pos<a.length) swapChar = (char)a[(pos++)];
                if (swapChar != 0) sample[c].name += swapChar;
            }
            data[0] = a[(pos++)];
            data[1] = a[(pos++)];
            sample[c].length = ((data[0]&0xff)*256+(data[1]&0xff)) * 2;
            sample[c].finetune = a[(pos++)];
            sample[c].finetune = (byte)(sample[c].finetune | 15);
            sample[c].volume = a[(pos++)];
            data[0] = a[(pos++)];
            data[1] = a[(pos++)];
            sample[c].repeat_pos = ((data[0]&0xff)*256+(data[1]&0xff)) * 2;
            data[0] = a[(pos++)];
            data[1] = a[(pos++)];
            sample[c].repeat_length = ((data[0]&0xff)*256+(data[1]&0xff)) * 2;
        }
        //songlength
        if (VERBOSITY>0) stdOut.append("Reading songLength..."+"\n");
        if (pos<a.length) songlength = a[(pos++)];
        if (pos<a.length) data[0] = a[(pos++)];

        // pattern position table
        if (VERBOSITY>0) stdOut.append("Reading Pattern Position Table..."+"\n");
        for (c=0; c<=127;c++)
            if (pos<a.length) pattern_position[c]= a[(pos++)];
        findPatternNumber();

        // "4chn"
        if (VERBOSITY>0) stdOut.append("Reading Tracker-ID string..."+"\n");
        trackerID = "";
        for (d = 1;d<=4; d++)
        {
            swapChar = 0;
            if (pos<a.length) swapChar= (char)a[(pos++)];
            if (swapChar !=0) trackerID += swapChar;
        }
        loop_position = 0;
        if (VERBOSITY>0) stdOut.append("Reading Patterns..."+"\n");
        for (f= 0; f<=pattern_number;f++)
        {
            if (VERBOSITY>1) stdOut.append(" Pattern "+String.format("%02d", f)+": ");
            for (c = 0;c<=63;c++)
            {
                if (VERBOSITY>1) stdOut.append(".");
                for (d= 0;d<=3;d++) 
                {
                    for (e= 0;e<=3;e++) 
                    {
                        if (pos<a.length) data[e] = a[(pos++)];
                    }
                    pattern[f].voice[d].tone[c].instrument =(byte) ( ((data[0]&0xff) & 240) | ((data[2]&0xff) >>> 4));  
                    pattern[f].voice[d].tone[c].period = (((data[0]&0xff) & 15) << 8) | (data[1]&0xff); // make data[1] unsigned 
                    pattern[f].voice[d].tone[c].note = findNote(pattern[f].voice[d].tone[c].period);  
                    pattern[f].voice[d].tone[c].effect1 = (byte) ((data[2]&0xff) & 15);  
                    pattern[f].voice[d].tone[c].effect2 = (byte) ((data[3]&0xff) >>> 4);  
                    pattern[f].voice[d].tone[c].effect3 = (byte) ((data[3]&0xff) & 15);

                    // check loop position
                    if (pattern[f].voice[d].tone[c].effect1 == 11) 
                    {
                        if (loop_position != 0) stdOut.append("! >> Caution: More than one loop found in modfile, so I am taking the last one."+"\n");
                        loop_position = data[3];
                    }
                }
            }
            if (VERBOSITY>1) stdOut.append(""+"\n");
        }
        if (VERBOSITY>1) stdOut.append("done."+"\n");
        if (VERBOSITY>1) stdOut.append(""+"\n");
        return true;
    }
    void findUsedPatterns()
    {
        for (int e=0; e<=pattern_number; e++)
        {
            pattern[e].used=false;
            for (int c=0; c<=songlength-1; c++)
            {
               if (e==pattern_position[c]) 
                   pattern[e].used=true;
            }
        }
    }
    
    boolean writeModInfo(String fileName)
    {
        String a;
        int c,d,e;
        String swap_note;

        try
        {
            PrintWriter writer = new PrintWriter(fileName, "UTF-8");

            stdOut.append("Writing file \""+fileName+"\""+"\n");

            if (VERBOSITY>0) stdOut.append(" Writing header..."+"\n");
            writer.println(PROGNAME+" v"+VERSION+" - "+_DATE+" by "+AUTHOR);
            writer.println("");
            if (VERBOSITY>0) stdOut.append(" Writing SongName..."+"\n");
            writer.println("SongName: \""+songName+"\"");
            writer.println("");
            if (VERBOSITY>0) stdOut.append(" Writing TrackerID..."+"\n");
            writer.println("TrackerID: \""+trackerID+"\"");
            writer.println("");
            writer.println("");

            if (VERBOSITY>0) stdOut.append(" Writing Sample Information..."+"\n");
            writer.println("Samples:");
            writer.println("");
            for (c=1; c<31;c++)
            {
                if ((sample[c].length > 0) || (sample[c].name.length() != 0))
                {
                    writer.write("Sample "+hex((byte)c)+": ");
                    writer.println("\""+sample[c].name+"\"");
                    writer.write("Length: "+sample[c].length+" bytes - ");
                    writer.write("Finetune: $"+hex(sample[c].finetune)+" - ");
                    writer.println("Volume: $"+hex(sample[c].volume));
                    writer.write("Repeat position: "+sample[c].repeat_pos+" bytes - ");
                    writer.println("Repeat length: "+sample[c].repeat_length+" bytes");
                    writer.println("");
                }
            }
            writer.println("");
            writer.println("");

            if (VERBOSITY>0) stdOut.append(" Writing SongLength..."+"\n");
            writer.println("Songlength: $"+hex(songlength)+" pattern positions");
            writer.println("Finally, song jumps to pattern position: $"+hex(loop_position));
            writer.println("");

            if (VERBOSITY>0) stdOut.append(" Writing Pattern Position Table..."+"\n");
            writer.println("Pattern Position Table:");

            
            for (c=0;c<=songlength-1;c++)
            {
                writer.println(hex((byte)c)+" "+hex(pattern_position[c]));
            }
            writer.println("");
            writer.println("");

            if (VERBOSITY>0) stdOut.append(" Writing Patterns..."+"\n");
            for (e=0; e<=pattern_number; e++)
            {
                if (pattern[e].used) 
                {
                    writer.println("Pattern "+hex((byte)e));
                    writer.println("");
                    if (VERBOSITY>1) stdOut.append("  Pattern "+hex((byte)e)+": ");
                    for (c=0;c<=63; c++)
                    {
                        writer.write(hex((byte)c)+": ");
                        for (d=0; d<=3; d++)
                        {
                            if (pattern[e].voice[d].tone[c].note != OFFNOTE_VALUE) 
                                swap_note = NAME[pattern[e].voice[d].tone[c].note];
                            else
                                swap_note = OFFNOTE;
                            writer.write(swap_note+" ");

                            if (pattern[e].voice[d].tone[c].instrument>0) 
                               writer.write(hex(pattern[e].voice[d].tone[c].instrument)+" ");
                            else
                               writer.write("   ");

                            writer.write(hexShort(pattern[e].voice[d].tone[c].effect1));
                            writer.write(hexShort(pattern[e].voice[d].tone[c].effect2));
                            writer.write(hexShort(pattern[e].voice[d].tone[c].effect3));
                            writer.write("   ");
                        }
                        writer.println("");
                        if (VERBOSITY>1) stdOut.append(".");                        
                    }
                    if (VERBOSITY>1) stdOut.append("\n");
                    writer.println("");
                    writer.println("");
                }
            }


            if (VERBOSITY>0) stdOut.append(" Writing Protracker Effect Information..."+"\n");
            for (e=0; e<=35;e++)
                writer.println(EFFECT_INFO[e]);
            writer.println("");
            writer.println("");

            if (VERBOSITY>0) stdOut.append("done."+"\n");
            if (VERBOSITY>0) stdOut.append("\n");
            writer.close();
        }
        catch (Exception x)
        {
            log.addLog(x, WARN);   
            return false;
        }
        return true;
    }
    void writePatternDirect(PrintWriter writer)
    {
        int c,d,e;
        byte data;

        stdOut.append("Writing section \"Patterns\""+"\n");

        writer.println(";--- music data [created with "+PROGNAME+" v"+VERSION+" - "+_DATE+" by "+AUTHOR+"] ---");
        writer.println();

        writer.println("adsr: ");
        writer.println("  fcb "+adsr1);
        writer.println();
        writer.println("twang: ");
        writer.println("  fcb "+twang);
        writer.println();
        
        if (VERBOSITY>0) stdOut.append(" Writing Pattern Position Table..."+"\n");
        writer.println("SIL	equ	$3f");
        writer.println();
        writer.println("songLength	equ	$"+hex(songlength));
        writer.println("loopPosition	equ	$"+hex(loop_position));
        writer.println();

        writer.println(";   Pattern ");
        writer.println("script:");
        for (c = 0;c<= songlength-1;c++)
        {
            writer.println("  fdb pattern"+hex(pattern_position[c]));
        }
        writer.println();

        if (VERBOSITY>0) stdOut.append(" Writing Patterns..."+"\n");
        
        for (e = 0;e<=pattern_number;e++) 
        {
            if (pattern[e].used)
            {
               writer.println("pattern"+hex((byte)e)+":");
               writer.println("  fdb adsr");
               writer.println("  fdb twang");
               writer.println();
               for (c = 0; c<=63;c++)
               {
                   writer.print("  fcb ");


                   // if no note at this position, set SIL
                   if ( (pattern[e].voice[vectrexModMapping[0]].tone[c].note == OFFNOTE_VALUE) &&
                        (pattern[e].voice[vectrexModMapping[1]].tone[c].note == OFFNOTE_VALUE) &&
                        (pattern[e].voice[vectrexModMapping[2]].tone[c].note == OFFNOTE_VALUE) ) 	
                       writer.print("SIL,");	// SIL

                   // d == three voices of vectrex
                   // vectrexModMapping[d] = the voice in the mod file
                   for (d = 0;d<=2;d++) 	// first three voices 0-2
                   {
                       // set speed (from Martin)
                       data = pattern[e].voice[vectrexModMapping[d]].tone[c].effect1;
                       if ((data==15) && (pattern[e].voice[vectrexModMapping[d]].tone[c].effect2<2)) 
                       {
                           if (VERBOSITY>0) stdOut.append("Setting speed to "+hex((byte)(pattern[e].voice[vectrexModMapping[d]].tone[c].effect2*16+pattern[e].voice[vectrexModMapping[d]].tone[c].effect3))+"\n");
                           SPEED = (byte)(pattern[e].voice[vectrexModMapping[d]].tone[c].effect2*16+pattern[e].voice[vectrexModMapping[d]].tone[c].effect3);
                       }


                       data = pattern[e].voice[vectrexModMapping[d]].tone[c].note;

                       if (data<(2*12)) 
                           stdOut.append("*** Attention: Pattern $"+hex((byte)e)+" Voice $"+hex((byte)vectrexModMapping[d])+" Position $"+hex((byte)c)+" is too low! ***"+"\n");
                       else 
                           data = (byte)(data - (2*12)); // lower tone by 3 octaves

                       // drums: bass drum (instrument 0)
                       int instNo = pattern[e].voice[vectrexModMapping[d]].tone[c].instrument;
                       VectrexInstrument instr = getInstrument(instNo);
                       /*
                       if ((instr == null) || (instr.isSilent))
                           data = VectrexInstrument.SILENCE.vectrexByte;
                       */
                       if (instr == null) 
;//                           data = VectrexInstrument.SILENCE.vectrexByte;
                       else if (instr.isSilent)
                           data = VectrexInstrument.SILENCE.vectrexByte;
                       else if (instr.isNoise)
                       {
                           data = (byte)(instr.vectrexByte | 64); // 64 is indicator for vectrex NOISE
                       }
                       /*
                       if (pattern[e].voice[vectrexModMapping[d]].tone[c].instrument == 1) data = (byte)(BASS_DRUM_VALUE | 64);         // set bit 6 (effect)
                       // drums: hihat drum (instrument 1)
                       if (pattern[e].voice[vectrexModMapping[d]].tone[c].instrument == 2) data = (byte)(HIHAT_DRUM_VALUE | 64);	// set bit 6 (effect)
                       // drums: snare drum (instrument 2)
                       if (pattern[e].voice[vectrexModMapping[d]].tone[c].instrument == 3) data = (byte)(SNARE_DRUM_VALUE | 64);	// set bit 6 (effect)
                        */
                       // silence (instrument 3)
                       //    if (pattern[e].voice[d].tone[c].instrument = 4) then 
                            //data := SILENCE_VALUE or 64;	// set bit 6 (effect)
                       //     data := SILENCE_VALUE;	// set bit 6 (effect)

                       // mark tone with bit 7 if another voice follows
                       if ( (d<2) && (pattern[e].voice[vectrexModMapping[d+1]].tone[c].note != OFFNOTE_VALUE) ) 
                           data = (byte)(data | 128);	// set bit 7

                       if ( (d==0) && (pattern[e].voice[vectrexModMapping[d+2]].tone[c].note != OFFNOTE_VALUE) ) 
                           data = (byte)(data | 128);	// set bit 7

                       if (pattern[e].voice[vectrexModMapping[d]].tone[c].note != OFFNOTE_VALUE ) 
                           writer.print("$"+hex(data)+", ");
                       else 
                           writer.print("     ");
                   }

                   writer.println("$"+hex(SPEED)+" ; $"+hex((byte)c));
                }
                writer.println(" fcb $00, $80 ; end-marker");
                writer.println();
                if (VERBOSITY>1) stdOut.append("\n");
            }
        }
        if (VERBOSITY>0) stdOut.append("done."+"\n");
        if (VERBOSITY>0) stdOut.append("\n");
    }
    public int[] vectrexModMapping = new int[3];
    
    
    VectrexInstrument getInstrument(int no)
    {
        for (InstrumentHandle vh : instrumentHandles)
        {
            if (vh.no == no) return vh.vectrex;
        }
        return null;
    }
    

    
    void writePatternIndirect(PrintWriter writer)
    {
        int c,d,e;
        byte data;

        stdOut.append("Writing section \"Patterns\""+"\n");

        writer.println(";--- music data [created with "+PROGNAME+" v"+VERSION+" - "+_DATE+" by "+AUTHOR+"] ---");
        writer.println();

        writer.println("adsr: ");
        writer.println("  fcb "+adsr1);
        writer.println();
        writer.println("twang: ");
        writer.println("  fcb "+twang);
        writer.println();
        
        if (VERBOSITY>0) stdOut.append(" Writing Pattern Position Table..."+"\n");
        writer.println("; Player identifier values");
        writer.println("SIL            EQU     $3f   ;  Silence");
        writer.println("NOISE          EQU     $40   ;  Sound is a 'noise'");
        writer.println("CONT           EQU     $80   ;  continue to next note (max 2 continues per line)");
        writer.println("; ");
        writer.println("; Instrument mapping");
        for (InstrumentHandle vh : instrumentHandles)
        {
            if (vh.vectrex.isNote) 
            {
                writer.println("; "+getInstrumentLabelForced(vh.no, 0).trim()+ "                        ;  Note     : "+ vh.name+" -> "+vh.vectrex.name);
                continue;
            }
            String l = getInstrumentLabel(vh.no, 0).trim();
            writer.print(l+   "            EQU     $"+hex(vh.vectrex.vectrexByte));
            if (vh.vectrex.isNoise)        writer.println("   ;  Noise    : " + vh.name+" -> "+vh.vectrex.name);
            else if (vh.vectrex.isSilent)  writer.println("   ;  Silence  : " + vh.name+" -> "+vh.vectrex.name);
            else if (vh.vectrex.isNote)    writer.println("   ;  Note     : " + vh.name+" -> "+vh.vectrex.name);
            else                           writer.println("   ;  Unkown");
        }
        int counter = 0;
        writer.println("; ");
        writer.println("; Note mapping");
        for (String note : VEC_NOTES)
        {
            writer.println(note+"            EQU     $"+hex (  (byte)(counter++)  ));
        }
        
        writer.println("; ");
        writer.println("; Song values");
        writer.println("songLength     EQU     $"+hex(songlength));
        writer.println("loopPosition   EQU     $"+hex(loop_position));
        writer.println();

        writer.println(";   Pattern ");
        writer.println("script:");
        for (c = 0;c<= songlength-1;c++)
        {
            writer.println("  fdb pattern"+hex(pattern_position[c]));
        }
        writer.println();

        if (VERBOSITY>0) stdOut.append(" Writing Patterns..."+"\n");
        
        for (e = 0;e<=pattern_number;e++) 
        {
            if (pattern[e].used)
            {
               writer.println("pattern"+hex((byte)e)+":");
               writer.println("  fdb adsr");
               writer.println("  fdb twang");
               writer.println();
               int pos = 0;
               for (c = 0; c<=63;c++)
               {
                   pos = 0;
                   writer.print("  fcb ");
                   pos +=6;


                   // if no note at this position, set SIL
                   if ( (pattern[e].voice[vectrexModMapping[0]].tone[c].note == OFFNOTE_VALUE) &&
                        (pattern[e].voice[vectrexModMapping[1]].tone[c].note == OFFNOTE_VALUE) &&
                        (pattern[e].voice[vectrexModMapping[2]].tone[c].note == OFFNOTE_VALUE) ) 
                   {
                       writer.print("SIL,");	// SIL
                       pos +=4;
                   }

                   // d == three voices of vectrex
                   // vectrexModMapping[d] = the voice in the mod file
                   for (d = 0;d<=2;d++) 	// first three voices 0-2
                   {
                       // set speed (from Martin)
                       data = pattern[e].voice[vectrexModMapping[d]].tone[c].effect1;
                       if ((data==15) && (pattern[e].voice[vectrexModMapping[d]].tone[c].effect2<2)) 
                       {
                           if (VERBOSITY>0) stdOut.append("Setting speed to "+hex((byte)(pattern[e].voice[vectrexModMapping[d]].tone[c].effect2*16+pattern[e].voice[vectrexModMapping[d]].tone[c].effect3))+"\n");
                           SPEED = (byte)(pattern[e].voice[vectrexModMapping[d]].tone[c].effect2*16+pattern[e].voice[vectrexModMapping[d]].tone[c].effect3);
                       }


                       data = pattern[e].voice[vectrexModMapping[d]].tone[c].note;

                       if (data<(2*12)) 
                           stdOut.append("*** Attention: Pattern $"+hex((byte)e)+" Voice $"+hex((byte)vectrexModMapping[d])+" Position $"+hex((byte)c)+" is too low! ***"+"\n");
                       else 
                           data = (byte)(data - (2*12)); // lower tone by 3 octaves

                       int instNo = pattern[e].voice[vectrexModMapping[d]].tone[c].instrument;
                       VectrexInstrument instr = getInstrument(instNo);
                       if (instr == null) 
                            ;//             
                       else if (instr.isSilent)
                           data = VectrexInstrument.SILENCE.vectrexByte;
                       else if (instr.isNoise)
                       {
                           data = (byte)(instr.vectrexByte | 64); // 64 is indicator for vectrex NOISE
                       }

                       // mark tone with bit 7 if another voice follows
                       if ( (d<2) && (pattern[e].voice[vectrexModMapping[d+1]].tone[c].note != OFFNOTE_VALUE) ) 
                           data = (byte)(data | 128);	// set bit 7

                       if ( (d==0) && (pattern[e].voice[vectrexModMapping[d+2]].tone[c].note != OFFNOTE_VALUE) ) 
                           data = (byte)(data | 128);	// set bit 7

                       if (pattern[e].voice[vectrexModMapping[d]].tone[c].note != OFFNOTE_VALUE ) 
                       {
                           writer.print(getInstrumentLabel(instNo, data)+", ");
                           pos +=14;
                       }
                       else 
                       {
                           writer.print("                ");
                           pos +=14;
                       }
                   }
                   int SPEED_POS = 60;
                   for (int p=pos;p<SPEED_POS; p++)writer.print(" ");
                   writer.println("$"+hex(SPEED)+" ; $"+hex((byte)c));
                }
                writer.println(" fcb $00, $80 ; end-marker");
                writer.println();
                if (VERBOSITY>1) stdOut.append("\n");
            }
        }
        if (VERBOSITY>0) stdOut.append("done."+"\n");
        if (VERBOSITY>0) stdOut.append("\n");
    }
    
    String getInstrumentLabel(int no, int data)
    {
        String o = "";
        int newData = data;
        
        VectrexInstrument inst = getInstrument(no);
        
        if (inst == null)
        {
            log.addLog("Mod contains unkown instrument data! (instr: "+no+") -> DEFAULT to TONE!", WARN);
            newData = data & (0xff-0x40);
            newData = data & (0xff-0x80);
            o+=VEC_NOTES[newData&0x3f];
        }
        else
        if (inst.isNote)
        {
            newData = data & (0xff-0x40);
            newData = data & (0xff-0x80);
            o+=VEC_NOTES[newData&0x3f];
        }
        else
        {
            o += "_";
            if (no<10) o+=0;
            o+=""+no;
        }
        if ((newData & 64) == 64) o+="+NOISE";
        else                      o+="      ";
        if ((data & 128) == 128) o+="+CONT";
        else                     o+="     ";
        return o;
    }
    String getInstrumentLabelForced(int no, int data)
    {
        String o = "";
        int newData = data;
        
        
        o += "_";
        if (no<10) o+=0;
        o+=""+no;
        if ((newData & 64) == 64) o+="+NOISE";
        else                      o+="      ";
        if ((data & 128) == 128) o+="+CONT";
        else                     o+="     ";
        return o;
    }    
    
    
    boolean writeIndirectOutput (String fileName)
    {
        String header_string = "$1100";
        try
        {
            PrintWriter writer = new PrintWriter(fileName, "UTF-8");

            stdOut.append("Writing file \""+fileName+"\" beginning from "+header_string+"\n");
            stdOut.append("\n");
            writePatternIndirect(writer);

            writer.close();
        }
        catch (Exception x)
        {
            log.addLog(x, WARN);   
            return false;
        }
        stdOut.append("The three channels of the mod file have been converted to 3 channels of vectres"+"\n");
        stdOut.append("following mapping was used:"+"\n");
        stdOut.append("  mod channel "+vectrexModMapping[0]+" was mapped to channel 0 vectrex\n");
        stdOut.append("  mod channel "+vectrexModMapping[1]+" was mapped to channel 1 vectrex\n");
        stdOut.append("  mod channel "+vectrexModMapping[2]+" was mapped to channel 2 vectrex\n");
        
        //stdOut.append("The first three channels of the mod file have been converted (0-2)."+"\n");
        stdOut.append("Every voice in a pattern has the length of $40 bytes."+"\n");
        stdOut.append("Every pattern is 3x$40 bytes = $c0 bytes long."+"\n");
       // stdOut.append("Offnotes have the value of ",OFFNOTE_VALUE,".");
        stdOut.append("\n");
        stdOut.append("Speed is set to $"+hex(SPEED)+"."+"\n");
        stdOut.append("\n");

        stdOut.append("Following instrument mapping was used:\n");
        for (InstrumentHandle vh : instrumentHandles)
        {
            stdOut.append("(Mod)Instrument "+vh.no+" ("+vh.name+") is mapped to vectrex: "+vh.vectrex.name+" ("+hex(vh.vectrex.vectrexByte)+")\n");
        }
        stdOut.append("\n");
        stdOut.append("\n");
        stdOut.append("Lowest note should be G-2."+"\n");
        stdOut.append("\n");    
        return true;
    }    
    boolean writeDirectOutput (String fileName)
    {

        String header_string = "$1100";
        try
        {
            PrintWriter writer = new PrintWriter(fileName, "UTF-8");

            stdOut.append("Writing file \""+fileName+"\" beginning from "+header_string+"\n");
            stdOut.append("\n");
            writePatternDirect(writer);

            writer.close();
        }
        catch (Exception x)
        {
            log.addLog(x, WARN); 
            return false;
        }
        stdOut.append("The three channels of the mod file have been converted to 3 channels of vectres"+"\n");
        stdOut.append("following mapping was used:"+"\n");
        stdOut.append("  mod channel "+vectrexModMapping[0]+" was mapped to channel 0 vectrex\n");
        stdOut.append("  mod channel "+vectrexModMapping[1]+" was mapped to channel 1 vectrex\n");
        stdOut.append("  mod channel "+vectrexModMapping[2]+" was mapped to channel 2 vectrex\n");
        
        //stdOut.append("The first three channels of the mod file have been converted (0-2)."+"\n");
        stdOut.append("Every voice in a pattern has the length of $40 bytes."+"\n");
        stdOut.append("Every pattern is 3x$40 bytes = $c0 bytes long."+"\n");
       // stdOut.append("Offnotes have the value of ",OFFNOTE_VALUE,".");
        stdOut.append("\n");
        stdOut.append("Speed is set to $"+hex(SPEED)+"."+"\n");
        stdOut.append("\n");

        stdOut.append("Following instrument mapping was used:\n");
        for (InstrumentHandle vh : instrumentHandles)
        {
            stdOut.append("(Mod)Instrument "+vh.no+" ("+vh.name+") is mapped to vectrex: "+vh.vectrex.name+" ("+hex(vh.vectrex.vectrexByte)+")\n");
        }
        stdOut.append("\n");
        stdOut.append("\n");
        stdOut.append("Lowest note should be G-2."+"\n");
        stdOut.append("\n");    
        return true;
    }
    StringBuffer stdOut;
    
    String adsr1 = "";
    String twang = "";
    ArrayList<ModJPanel.InstrumentHandle> instrumentHandles;
    
    
    public String doIt(String filename, ArrayList<ModJPanel.InstrumentHandle> vh, String a1, String t, boolean indirectOutput)
    {
        adsr1 = a1;
        twang = t;
        instrumentHandles = vh;
        
        stdOut = new StringBuffer();
        for (int i=0; i< 128; i++)
        {
            pattern[i] = new pattern_type();
        }
        for (int i=0; i< 32; i++)
        {
            sample[i] = new sample_type();
        }
    
        show_message();
        inModName = filename;

        
        int li = filename.lastIndexOf(".");
        if (li<0) return "File not recognized.";
        outTxtName = filename.substring(0,li)+".txt";
        outVecFile = filename.substring(0,li)+".asm";
        

        boolean ok = readMod(inModName);
        if (!ok) return stdOut.toString();
        findUsedPatterns();
        ok = writeModInfo(outTxtName);
        if (!ok) return stdOut.toString();
        if (indirectOutput)
        {
            ok = writeIndirectOutput(outVecFile);
            
        }
        else
            ok = writeDirectOutput(outVecFile);
        return stdOut.toString();
    }
    
    private boolean readQuiet(String filename)
    {
        for (int i=0; i< 128; i++)
        {
            pattern[i] = new pattern_type();
        }
        for (int i=0; i< 32; i++)
        {
            sample[i] = new sample_type();
        }

        File file;
        FileInputStream fin=null;
        byte[] data = new byte[4];
        int c,d,e,f;
        char swapChar;
        songName = "";
        file=new File(filename);
        byte a[] = new byte[(int)file.length()];
        int pos = 0;
        try 
        {
            fin = new FileInputStream(file);
            fin.read(a);
        }
        catch (Throwable ex)
        {
            return false; // error
        }
        finally
        {
            try 
            {
                fin.close();
            }
            catch (Throwable ex)
            {
                
                return false; // error
            }        
        }
        // reading out songName
        for (c=1;c<=20;c++)
        {
            swapChar = 0;
            if (pos<a.length) swapChar = (char)a[(pos++)];
            if (swapChar != 0) songName = songName + swapChar;
        }
        
        // reading samples}
        for (c = 1;c<=31;c++)
        {
            sample[c].name = "";
            for (d = 1; d<=22;d++)
            {
                swapChar = 0;
                if (pos<a.length) swapChar = (char)a[(pos++)];
                if (swapChar != 0) sample[c].name += swapChar;
            }
            data[0] = a[(pos++)];
            data[1] = a[(pos++)];
            sample[c].length = ((data[0]&0xff)*256+(data[1]&0xff)) * 2;
            sample[c].finetune = a[(pos++)];
            sample[c].finetune = (byte)(sample[c].finetune | 15);
            sample[c].volume = a[(pos++)];
            data[0] = a[(pos++)];
            data[1] = a[(pos++)];
            sample[c].repeat_pos = ((data[0]&0xff)*256+(data[1]&0xff)) * 2;
            data[0] = a[(pos++)];
            data[1] = a[(pos++)];
            sample[c].repeat_length = ((data[0]&0xff)*256+(data[1]&0xff)) * 2;
        }
        //songlength
        if (pos<a.length) songlength = a[(pos++)];
        if (pos<a.length) data[0] = a[(pos++)];

        // pattern position table
        for (c=0; c<=127;c++)
            if (pos<a.length) pattern_position[c]= a[(pos++)];
        findPatternNumber();

        // "4chn"
        trackerID = "";
        for (d = 1;d<=4; d++)
        {
            swapChar = 0;
            if (pos<a.length) swapChar= (char)a[(pos++)];
            if (swapChar !=0) trackerID += swapChar;
        }
        loop_position = 0;
        for (f= 0; f<=pattern_number;f++)
        {
            for (c = 0;c<=63;c++)
            {
                for (d= 0;d<=3;d++) 
                {
                    for (e= 0;e<=3;e++) 
                    {
                        if (pos<a.length) data[e] = a[(pos++)];
                    }
                    pattern[f].voice[d].tone[c].instrument =(byte) ( ((data[0]&0xff) & 240) | ((data[2]&0xff) >>> 4));  
                    pattern[f].voice[d].tone[c].period = (((data[0]&0xff) & 15) << 8) | (data[1]&0xff); // make data[1] unsigned 
                    pattern[f].voice[d].tone[c].note = findNote(pattern[f].voice[d].tone[c].period);  
                    pattern[f].voice[d].tone[c].effect1 = (byte) ((data[2]&0xff) & 15);  
                    pattern[f].voice[d].tone[c].effect2 = (byte) ((data[3]&0xff) >>> 4);  
                    pattern[f].voice[d].tone[c].effect3 = (byte) ((data[3]&0xff) & 15);

                    // check loop position
                    if (pattern[f].voice[d].tone[c].effect1 == 11) 
                    {
                        loop_position = data[3];
                    }
                }
            }
        }
        return true;
    }
                
    public boolean collectInfo(String filename, ArrayList<ModJPanel.InstrumentHandle> vh)
    {
        boolean read = readQuiet(filename);
        if (!read) return false;
        findUsedPatterns();
        int c,d,e;

        for (e=0; e<=pattern_number; e++)
        {
            // x patterns
            if (pattern[e].used) 
            {
                // $3f notes  in a pattern
                for (c=0;c<=63; c++)
                {

                    // 4 voices
                    for (d=0; d<=3; d++)
                    {
                        if (pattern[e].voice[d].tone[c].note != OFFNOTE_VALUE) 
                            if (pattern[e].voice[d].tone[c].instrument>0) 
                                incInstrumentUsed(vh, pattern[e].voice[d].tone[c].instrument, d);
                    }
                }
            }
        }
        
        
        return true;
    }
    void incInstrumentUsed(ArrayList<ModJPanel.InstrumentHandle> vh, int instrumentNo, int voice)
    {
        for (ModJPanel.InstrumentHandle h : vh)
        {
            if (h.no==instrumentNo)
            {
                h.usage[voice]++;
                return;
            }
        }
    }
    
}

