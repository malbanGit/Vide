/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.modi;

import java.io.File;
import java.io.FileInputStream;
import java.io.PrintWriter;


/**
 * Mod2Vectrex v1.08 - 02.01.2011 by Wolf (the@BigBadWolF.de), additions by Nitro/NCE
 * 
 * @author malban
 * 
 *                         // http://www.fileformat.info/format/mod/corion.htm

 */
public class mod2Vectrex 
{
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

    int[] PERIOD = {// 12 * 7
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
    
    String[] NAME = {
                    "C-1", "C#1", "D-1", "D#1", "E-1", "F-1", "F#1", "G-1", "G#1", "A-1", "A#1", "H-1",
                    "C-2", "C#2", "D-2", "D#2", "E-2", "F-2", "F#2", "G-2", "G#2", "A-2", "A#2", "H-2",
                    "C-3", "C#3", "D-3", "D#3", "E-3", "F-3", "F#3", "G-3", "G#3", "A-3", "A#3", "H-3",
                    "C-4", "C#4", "D-4", "D#4", "E-4", "F-4", "F#4", "G-4", "G#4", "A-4", "A#4", "H-4",
                    "C-5", "C#5", "D-5", "D#5", "E-5", "F-5", "F#5", "G-5", "G#5", "A-5", "A#5", "H-5",
                    "C-6", "C#6", "D-6", "D#6", "E-6", "F-6", "F#6", "G-6", "G#6", "A-6", "A#6", "H-6",
                    "C-7", "C#7", "D-7", "D#7", "E-7", "F-7", "F#7", "G-7", "G#7", "A-7", "A#7", "H-7" 
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
    void readMod(String fileName)
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
            ex.printStackTrace();
            return; // error
        }
        finally
        {
            try 
            {
                fin.close();
            }
            catch (Throwable ex)
            {
                ex.printStackTrace();
                return; // error
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
    void writeModInfo(String fileName)
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
            x.printStackTrace();
        }
    }
    void writePattern(PrintWriter writer)
    {
        int c,d,e;
        byte data;

        stdOut.append("Writing section \"Patterns\""+"\n");

        writer.println(";--- music data [created with "+PROGNAME+" v"+VERSION+" - "+_DATE+" by "+AUTHOR+"] ---");
        writer.println();

        if (VERBOSITY>0) stdOut.append(" Writing Pattern Position Table..."+"\n");
        writer.println("SIL	equ	$3f");
        writer.println();
        writer.println("songLength	equ	$"+hex(songlength));
        writer.println("loopPosition	equ	$"+hex(loop_position));
        writer.println();

        writer.println(";;;;;;;;;;   Pattern  ; Part");
        writer.println("script:");
        for (c = 0;c<= songlength-1;c++)
        {
            writer.println("  fdb pattern"+hex(pattern_position[c])+", part1, init_part1");
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
                   if ( (pattern[e].voice[0].tone[c].note == OFFNOTE_VALUE) &&
                        (pattern[e].voice[1].tone[c].note == OFFNOTE_VALUE) &&
                        (pattern[e].voice[2].tone[c].note == OFFNOTE_VALUE) ) 	
                       writer.print("SIL,");	// SIL

                   for (d = 0;d<=2;d++) 	// first three voices 0-2
                   {
                       // set speed (from Martin)
                       data = pattern[e].voice[d].tone[c].effect1;
                       if ((data==15) && (pattern[e].voice[d].tone[c].effect2<2)) 
                       {
                           if (VERBOSITY>0) stdOut.append("Setting speed to "+hex((byte)(pattern[e].voice[d].tone[c].effect2*16+pattern[e].voice[d].tone[c].effect3))+"\n");
                           SPEED = (byte)(pattern[e].voice[d].tone[c].effect2*16+pattern[e].voice[d].tone[c].effect3);
                       }


                       data = pattern[e].voice[d].tone[c].note;

                       if (data<(2*12)) 
                           stdOut.append("*** Attention: Pattern $"+hex((byte)e)+" Voice $"+hex((byte)d)+" Position $"+hex((byte)c)+" is too low! ***"+"\n");
                       else 
                           data = (byte)(data - (2*12)); // lower tone by 3 octaves

                       // drums: bass drum (instrument 0)
                       if (pattern[e].voice[d].tone[c].instrument == 1) data = (byte)(BASS_DRUM_VALUE | 64);	// set bit 6 (effect)
                       // drums: hihat drum (instrument 1)
                       if (pattern[e].voice[d].tone[c].instrument == 2) data = (byte)(HIHAT_DRUM_VALUE | 64);	// set bit 6 (effect)
                       // drums: snare drum (instrument 2)
                       if (pattern[e].voice[d].tone[c].instrument == 3) data = (byte)(SNARE_DRUM_VALUE | 64);	// set bit 6 (effect)

                       // silence (instrument 3)
                       //    if (pattern[e].voice[d].tone[c].instrument = 4) then 
                            //data := SILENCE_VALUE or 64;	// set bit 6 (effect)
                       //     data := SILENCE_VALUE;	// set bit 6 (effect)

                       // mark tone with bit 7 if another voice follows
                       if ( (d<2) && (pattern[e].voice[d+1].tone[c].note != OFFNOTE_VALUE) ) 
                           data = (byte)(data | 128);	// set bit 7

                       if ( (d==0) && (pattern[e].voice[d+2].tone[c].note != OFFNOTE_VALUE) ) 
                           data = (byte)(data | 128);	// set bit 7

                       if (pattern[e].voice[d].tone[c].note != OFFNOTE_VALUE ) 
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
    void write (String fileName)
    {

        String header_string = "$1100";
        try
        {
            PrintWriter writer = new PrintWriter(fileName, "UTF-8");

            stdOut.append("Writing file \""+fileName+"\" beginning from "+header_string+"\n");
            stdOut.append("\n");
            writePattern(writer);

            writer.close();
        }
        catch (Exception x)
        {
            x.printStackTrace();
        }
        stdOut.append("The first three channels of the mod file have been converted (0-2)."+"\n");
        stdOut.append("Every voice in a pattern has the length of $40 bytes."+"\n");
        stdOut.append("Every pattern is 3x$40 bytes = $c0 bytes long."+"\n");
       // stdOut.append("Offnotes have the value of ",OFFNOTE_VALUE,".");
        stdOut.append("\n");
        stdOut.append("Speed is set to $"+hex(SPEED)+"."+"\n");
        stdOut.append("\n");
        stdOut.append("Instrument 1 is a bass drum and gets value $"+hex(BASS_DRUM_VALUE)+"."+"\n");
        stdOut.append("Instrument 2 is a hihat drum and gets value $"+hex(HIHAT_DRUM_VALUE)+"."+"\n");
        stdOut.append("Instrument 3 is a snare drum and gets value $"+hex(SNARE_DRUM_VALUE)+"."+"\n");
        stdOut.append("\n");
       // stdOut.append("Instrument 4 makes Vectrex Soundchip silent (value $"+hex(SILENCE_VALUE)+").");
        stdOut.append("\n");
        stdOut.append("Lowest note should be G-2."+"\n");
        stdOut.append("\n");    
    }
    StringBuffer stdOut;
    public String doIt(String filename)
    {
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
        

        readMod(inModName);
        findUsedPatterns();
        writeModInfo(outTxtName);
        write(outVecFile);
        return stdOut.toString();
    }
}

