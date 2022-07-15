/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vedi.sound;

import de.malban.Global;
import de.malban.config.Configuration;
import de.malban.config.TinyLogInterface;
import de.malban.gui.panels.LogPanel;
import static de.malban.gui.panels.LogPanel.ERROR;
import static de.malban.gui.panels.LogPanel.WARN;
import static de.malban.vide.vedi.sound.DoubleLinkedList.*;
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.Comparator;
import java.util.Iterator;
import net.sourceforge.lhadecompressor.LhaEntry;
import net.sourceforge.lhadecompressor.LhaFile;

// http://homepage1.nifty.com/dangan/en/Content/Program/Java/jLHA/LhaLibrary.html
// https://sourceforge.net/projects/lhadecompressor/
// http://www.atari-forum.com/viewtopic.php?t=11188
// http://pacidemo.planet-d.net/html.html

/**
 *
 * @author malban
 */
public class YmSound {
    
    TinyLogInterface tl;
    int current_working_register = 0;
    String file_name = "";
    String song_name = "";
    int DATA_TAB = 40;

    int MIN_PHRASE_LEN     = 2 ; /* inclusive */
    int MAX_PHRASE_LEN     = 16; /* exclusive */
    int PHRASES_MAX_DEPTH  = 10;
    int VECTREX_DECODER    = 1;
    int PHRASE_OPTIMIZER   = 2;
    int OLD_STYLE          = 0;

    //START inclusive
    int ENCODE_START = 0;
    //END exclusive
    int ENCODE_END = 14;
    
    boolean packed = true;
    boolean init = false;
    LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
    String pathFull ="";
    String pathOnly ="";
    String filenameOnly ="";
    String filenameBaseOnly ="";

    boolean SHANNON = true;
    boolean RLE_USED = true;
    boolean USE_PHRASE = true;
    boolean OPTIMAL_PHRASE = true;

    public int attribut =0;
    public int samples = 0;
    public int loopStart = 0;
    public String author ="";
    public String comment ="";
    public boolean interleave=true;
    public int vbl_len=0;
    public int externalFrequency = 0;
    public int playerFrequency = 0;
    public int futureDataLength = 0;
    
    public String unpackedName = "";
    public byte[][] out_buf = new byte[16][];
    String version ="";
    public YmSound(String filename, TinyLogInterface tinl)
    {
        tl = tinl;
        
        byte[] buf;
        
        // empty means NEW YM file
        if (filename.length() == 0)
        {
            attribut = 1;
            author = "VIDE";
            externalFrequency = 2000000;
            playerFrequency = 50;
            packed = false;
            init = true;
            version = "YM6!";
            vbl_len = 1;
            for (int i=0; i < 16; i++)
            {
                out_buf[i] = new byte[1];
            }
            return;
        }
        
        Path path = Paths.get(filename);
        long orglen=0;
        orglen = (int) new File(filename).length();
     
        try
        {
            buf = Files.readAllBytes(path);
            if (buf.length>8)
            {
                // test for lharc
                if ( ((buf[2]) == (byte)0x2d) && // '-'
                     ((buf[3]) == (byte)0x6c) && // 'l'
                     ((buf[6]) == (byte)0x2d)    // '-'
                   )
                {
                    packed = true;
                    unpackedName = unpackYMLharc(filename);
                    if (unpackedName == null)
                    {
                        log.addLog("YM - unpack error...", WARN);
                        return;
                    }
                    tl.printMessageSU(filename+" unpacked to: "+unpackedName);
                    
                }
                else
                {
                    unpackedName = filename;
                    packed = false;
                }
            }
        }
        catch (Throwable e)
        {
            log.addLog("YM - error reading file ('"+filename+"').", WARN);
            return;
        }        

        path = Paths.get(unpackedName);
     
        try
        {
            buf = Files.readAllBytes(path);
        }
        catch (Throwable e)
        {
            log.addLog("YM - error reading unpacked file ('"+unpackedName+"').", WARN);
            return;
        }
        int len=buf.length;        
        
        
        
        Path p = Paths.get(filename);
        pathFull = p.toString();
        pathOnly = p.getParent().toString();
        filenameOnly = p.getFileName().toString();
        filenameBaseOnly = filenameOnly.substring(0, filenameOnly.length()-3); // we know it ends with ".ym"

        String format ="";
        format += (char)buf[0];
        format += (char)buf[1];
        format += (char)buf[2];
        format += (char)buf[3];
        tl.printMessageSU("Length of file: "+len+"("+orglen+")");
        version = format.toUpperCase();
        if (format.toUpperCase().equals("YM2!"))
        {
            tl.printMessageSU("YM2! format");
            vbl_len=convert_ym2(out_buf, buf,len);
        }
        else if (format.toUpperCase().equals("YM3!"))
        {
            tl.printMessageSU("YM3! format");
            vbl_len=convert_ym3(out_buf,buf,len);
        }
        else if (format.toUpperCase().equals("YM3b"))
        {
            tl.printMessageSU("YM3b format");
            vbl_len=convert_ym3b(out_buf,buf,len);
        }
        else if (format.toUpperCase().equals("YM4!"))
        {
            tl.printMessageSU("YM4! format");
            vbl_len=convert_ym4(out_buf,buf);
        }
        else if (format.toUpperCase().equals("YM5!"))
        {
            tl.printMessageSU("YM5! format");
            vbl_len=convert_ym5(out_buf,buf);
        }
        else if (format.toUpperCase().equals("YM6!"))
        {
            tl.printMessageSU("YM6! format");
            tl.printMessageSU("I have found no documentation for this format, for now");
            tl.printMessageSU("YM5! is assumed for this. - works most of the time...");
            vbl_len=convert_ym5(out_buf,buf);
        }
        else
        {
            tl.printMessageSU("Unkown or unsupported format!");
            return;
        }

        if (vbl_len == 0)
        {
            tl.printMessageSU("Unsupported format!\n");
            log.addLog("YM - Unsupported format! ('"+unpackedName+"').", WARN);
            return;
        }
        init = true;
    }
    // returns the destiny fullPathAndFilename
    public static String unpackYMLharc(String filename)
    {
        try
        {
            int BUFFSER_SIZE = 4096;
            byte[] buff = new byte[BUFFSER_SIZE];
            LhaFile file = new LhaFile(filename);
            Iterator iter = file.entryIterator();
            File dst = null;
            while (iter.hasNext()) 
            {
                LhaEntry entry = (LhaEntry) iter.next();
                String dstName = Global.mainPathPrefix+"tmp"+File.separator+entry.getFile().getName();
                dst = new File(dstName);
                
                if (entry.getMethod().equals(LhaEntry.METHOD_SIG_LHD)) 
                {
                    //dst.mkdirs();
                    continue;
                }
                // File parent = dst.getParentFile();
                // if (parent != null) parent.mkdirs();
                
                InputStream in = new BufferedInputStream(file.getInputStream(entry), BUFFSER_SIZE);
                OutputStream out = new BufferedOutputStream(new FileOutputStream(dst), BUFFSER_SIZE);
                while (true) 
                {
                    int len = in.read(buff, 0, BUFFSER_SIZE);
                    if (len < 0) break;
                    out.write(buff, 0, len);
                }
                out.flush();
                out.close();
            }
            file.close();
            if (dst != null)
                return dst.toString();
        }
        catch (Throwable e)
        {
            e.printStackTrace();
        }
        return null;
    }
    int bitsSaved = 0;
    public String buildASM(boolean[] regsUsed)
    {
        if (!init) return null;
        int li = unpackedName.lastIndexOf(".");
        if (li<0)
        {
            log.addLog("YM - filename error ('"+unpackedName+"').", WARN);
            return null;
        }
        String name_out_raw = unpackedName.substring(0,li);
        name_out_raw+=".asm";

        //////////////////////////////////////////////////
        //////////////////////////////////////////////////
        //////////////////////////////////////////////////

        File file = new File(name_out_raw);
        FileWriter fw;
        BufferedWriter bw;
        try
        {
            fw = new FileWriter(file.getAbsoluteFile());
            bw = new BufferedWriter(fw);        
        }
        catch (Throwable e)
        {
            log.addLog("YM - Error openening output file! ('"+name_out_raw+"').", WARN);
            return null;
        }
        init_bit_out(bw);

        //////////////////////////////////////////////////
        //////////////////////////////////////////////////
        //////////////////////////////////////////////////

        abstract_buffer abuffer;
        int overall_used_bits = 0;
        BufferedWriter outFile = get_dbOutFile();

        try
        {
            if (outFile != null)
            {
                outFile.write(""+file_name+"_start: \n");
                outFile.write(" DW "+vbl_len+" ; vbl_len \n");
            }

            tl.printMessageSU("");
            // pack register
            tl.printMessageSU("Start packing data...");
            int ym_register;
            bitsSaved=0;
            for (ym_register=ENCODE_START; ym_register< ENCODE_END; ym_register++)
            {
                if (!regsUsed[ym_register]) continue;
                current_working_register = ym_register;
                abuffer = build_abstract(out_buf[ym_register], vbl_len);
                if (USE_PHRASE)
                {
                    abstract_search_insert_phrases_optimal(abuffer);
                }
                if (SHANNON)
                {
                    abstract_Shannon(abuffer);
                }
                if (RLE_USED)
                {
                    abstract_RLE(abuffer);
                }
                int used_bits = get_bits_used_from_abstract_complete(abuffer);
                abstract_out(abuffer);
                tl.printMessageSU("Register "+current_working_register+" -> Bytes used: "+((used_bits+7)/8)+" ");
                overall_used_bits += used_bits;
                delete_abstract(abuffer);
                tl.printMessageSU("");
            }
            overall_used_bits += 16 + 68*8; // vbl_len
            tl.printMessageSU("Bytes used alltogether (best guess :-)): "+((overall_used_bits+7)/8)+" " );

            if (outFile != null)
            {
                outFile.write(""+file_name+"_data: \n");
                outFile.write(" DW "+file_name+"_start \n");
                for (ym_register=ENCODE_START; ym_register< ENCODE_END; ym_register++)
                {
                    if (!regsUsed[ym_register]) continue;
                    outFile.write(" DB $"+String.format("%02X",ym_register)+"\n");
                    if (dontShanonSingleByteUsages) 
                        outFile.write(" DW "+file_name+"_reg_"+ym_register+"");
                    else
                       outFile.write(" DW "+file_name+"_reg_"+ym_register+"-3");
                    outFile.write(", "+file_name+"_pd_"+ym_register+"");
                    outFile.write(", "+file_name+"_reg_"+ym_register+"_data\n" );
                }
                outFile.write(" DB $"+String.format("%02X",((-1)&0xff) )+"\n");
                outFile.write("SONG_DATA EQU "+file_name+"_data \n");
                outFile.write(""+file_name+"_name: \n DB ");
                for (int i = 0; i < song_name.length(); i++)
                {
                    byte c = (byte) song_name.toUpperCase().charAt(i);
                    if (c <= 'Z')
                    {
                        outFile.write("$"+String.format("%02X",c&0xff)+", ");
                    }
                }
                outFile.write("$80 \n");
            }
            deinit_bit_out();
        }

        catch (Throwable e)
        {
            tl.printMessageSU("... error, see log!");
            log.addLog(e, WARN);
            return null;
        }
        tl.printMessageSU("YM convert to vectrex - done!" );

        if (pathOnly.length()>0)
            pathOnly+=File.separator;
        String outFileFinal = pathOnly+Paths.get(name_out_raw).getFileName().toString();
        de.malban.util.UtilityFiles.copyOneFile(name_out_raw, outFileFinal);
        return outFileFinal;
    }    
    public static String getByteBinaryString(byte b) 
    {
        StringBuilder sb = new StringBuilder();
        for (int i = 7; i >= 0; --i) 
        {
            sb.append(b >>> i & 1);
        }
        return sb.toString();
    }
    public static String getLongBinaryString(long b) 
    {
        StringBuilder sb = new StringBuilder();
        for (int i = 31; i >= 0; --i) 
        {
            sb.append(b >>> i & 1);
        }
        return sb.toString();
    }

    String tab(String s, int tab)
    {
        String ret = s;
        while (ret.length()<tab)
        {
            ret+=".";
        }
        ret+=": ";
        return ret;
    }
    //////////////////////////////////////
    ///////// YM_CONV.C - START //////////
    //////////////////////////////////////

    int convert_ym2(byte out_buf[][], byte[] in_buf, int len)
    {
        return convert_ym3(out_buf, in_buf, len);
    }
    int convert_ym3(byte out_buf[][], byte[] in_buf, int len)
    {
        int pos=4;
        int todo=((len-4)/14);
        vbl_len=todo;
        for (int i=0; i < 16; i++)
        {
             out_buf[i] = new byte[vbl_len];
        }
        int out_counter = 0;
        tl.printMessageSU(tab("VBL found", DATA_TAB)+todo+"");
        song_name = file_name;

        while( todo != 0)
        {
            int i;
            for (i=0;i<14;i++)
            {
                byte[] outer = out_buf[i];
                byte poker = in_buf[pos+(i*((len-4)/14))];

                if ((i==1)||(i==3)||(i==5))
                    poker &= 1+2+4+8;

                if ((i==6) )
                    poker &= 1+2+4+8+16;

                if (i==7)
                    poker &= 1+2+4+8+16+32;
/*
                  // for vectrex
                if ((i==8)||(i==9)||(i==10))
                {
                    if (enableAmlitude5thBit)
                        poker &= 1+2+4+8+16;
                    else
                        poker &= 1+2+4+8;
                }
                */
                if (out_counter<outer.length)
                    outer[out_counter] = poker;
            }
            out_counter++;
            pos++;
            todo--;
        }
        return vbl_len;
    }

    int convert_ym3b(byte out_buf[][], byte[] in_buf, int len)
    {
         return convert_ym3(out_buf, in_buf, len);
    }

    int convert_ym4(byte out_buf[][], byte[] in_buf)
    {
        int c1;
        int c2;
        int c3;
        int c4;
        int pos=12;

        c1 = in_buf[pos++]&0xff;
        c2 = in_buf[pos++]&0xff;
        c3 = in_buf[pos++]&0xff;
        c4 = in_buf[pos++]&0xff;
        int todo=c1*256*256*256+c2*256*256+c3*256+c4;
        vbl_len=todo;
        for (int i=0; i < 16; i++)
        {
             out_buf[i] = new byte[vbl_len];
        }
        int out_counter = 0;
        tl.printMessageSU(tab("VBL found", DATA_TAB)+todo+"");
        int interleave_length=todo;

        c1 = in_buf[pos++]&0xff;
        c2 = in_buf[pos++]&0xff;
        c3 = in_buf[pos++]&0xff;
        c4 = in_buf[pos++]&0xff;
        attribut=c1*256*256*256+c2*256*256+c3*256+c4;
        tl.printMessageSU(tab("Attributs found", DATA_TAB)+getLongBinaryString(attribut)+"");

        c1 = in_buf[pos++]&0xff;
        c2 = in_buf[pos++]&0xff;
        c3 = in_buf[pos++]&0xff;
        c4 = in_buf[pos++]&0xff;
        samples=c1*256*256*256+c2*256*256+c3*256+c4;
        if (samples!=0)
            tl.printMessageSU(tab("Samples found", DATA_TAB)+samples+" (not converted!)");

        c1 = in_buf[pos++]&0xff;
        c2 = in_buf[pos++]&0xff;
        c3 = in_buf[pos++]&0xff;
        c4 = in_buf[pos++]&0xff;
        loopStart = (c1*256*256*256+c2*256*256+c3*256+c4);
        tl.printMessageSU(tab("Frame loop start", DATA_TAB)+loopStart+"");

        // skip samples!
        while (samples!=0)
        {
            long sample_length;
            c1 = in_buf[pos++]&0xff;
            c2 = in_buf[pos++]&0xff;
            c3 = in_buf[pos++]&0xff;
            c4 = in_buf[pos++]&0xff;
            sample_length=c1*256*256*256+c2*256*256+c3*256+c4;
            pos+=sample_length;
            samples--;
        }
        song_name ="";
        char cc=0;
        do
        {
            cc = (char)in_buf[pos++];
            if (cc != 0) song_name += cc;
        } while (cc!=0);
        tl.printMessageSU(tab("Name of song", DATA_TAB)+song_name+"");

        author ="";
        do
        {
            cc = (char)in_buf[pos++];
            if (cc != 0) author += cc;
        } while (cc!=0);
        tl.printMessageSU(tab("Name of author", DATA_TAB)+author+"");

        comment ="";
        do
        {
            cc = (char)in_buf[pos++];
            if (cc != 0) comment += cc;
        } while (cc!=0);
        tl.printMessageSU(tab("Comment", DATA_TAB)+comment+"");

        interleave=((attribut&1) == 1);
        if (interleave)
        {
            tl.printMessageSU("Using interleave format!");
            while( todo !=0)
            {
               int i;
               for (i=0;i<16;i++)
               {
                   byte poker = in_buf[pos+i*interleave_length];
                   byte[] outer = out_buf[i];
                   if ((i==1)||(i==3)||(i==5))
                       poker &= 1+2+4+8;

                   if ((i==6) )
                       poker &= 1+2+4+8+16;

                   if (i==7)
                       poker &= 1+2+4+8+16+32;
/*                   
               // for vectrex
                   if ((i==8)||(i==9)||(i==10))
                    {
                        if (enableAmlitude5thBit)
                            poker &= 1+2+4+8+16;
                        else
                            poker &= 1+2+4+8;
                    }
*/        
                    if (out_counter<outer.length)
                       outer[out_counter] = poker;
               }
               out_counter++;
               pos++;
               todo--;
           }
        }
        else
        {
            tl.printMessageSU("Using non interleave format!");
            while( todo !=0)
            {
               int i;
               for (i=0;i<16;i++)
               {
                   byte poker = in_buf[pos++];
                   byte[] outer = out_buf[i];
                   if ((i==1)||(i==3)||(i==5))
                       poker &= 1+2+4+8;

                   if ((i==6) )
                       poker &= 1+2+4+8+16;

                   if (i==7)
                       poker &= 1+2+4+8+16+32;
/*                   
               // for vectrex
                   if ((i==8)||(i==9)||(i==10))
                    {
                        if (enableAmlitude5thBit)
                            poker &= 1+2+4+8+16;
                        else
                            poker &= 1+2+4+8;
                    }
*/        
                if (out_counter<outer.length)
                   outer[out_counter] = poker;
               }
               out_counter++;
               todo--;
           }
        }
        return vbl_len;
    }

    int convert_ym5(byte out_buf[][], byte[] in_buf)
    {
        int c1;
        int c2;
        int c3;
        int c4;
        int pos=12;
        int out_counter = 0;

        c1 = in_buf[pos++]&0xff;
        c2 = in_buf[pos++]&0xff;
        c3 = in_buf[pos++]&0xff;
        c4 = in_buf[pos++]&0xff;
        int todo=c1*256*256*256+c2*256*256+c3*256+c4;
        vbl_len=todo;
        for (int i=0; i < 16; i++)
        {
             out_buf[i] = new byte[vbl_len];
        }
        tl.printMessageSU(tab("VBL found", DATA_TAB)+todo+"");
        int interleave_length=todo;

        c1 = in_buf[pos++]&0xff;
        c2 = in_buf[pos++]&0xff;
        c3 = in_buf[pos++]&0xff;
        c4 = in_buf[pos++]&0xff;
        attribut=c1*256*256*256+c2*256*256+c3*256+c4;
        tl.printMessageSU(tab("Attributes found", DATA_TAB)+getLongBinaryString(attribut)+"");

        c3 = in_buf[pos++]&0xff;
        c4 = in_buf[pos++]&0xff;
        samples=c3*256+c4;
        if (samples != 0)
            tl.printMessageSU(tab("Samples found", DATA_TAB)+samples+" (not converted!)");

        c1 = in_buf[pos++]&0xff;
        c2 = in_buf[pos++]&0xff;
        c3 = in_buf[pos++]&0xff;
        c4 = in_buf[pos++]&0xff;
        externalFrequency = (c1*256*256*256+c2*256*256+c3*256+c4);
        tl.printMessageSU(tab("YM2149 External frequency in Hz", DATA_TAB)+externalFrequency+"");

        c3 = in_buf[pos++]&0xff;
        c4 = in_buf[pos++]&0xff;
        
        playerFrequency = (c3*256+c4);
        tl.printMessageSU(tab("Player frequency in Hz", DATA_TAB)+playerFrequency+"");

        c1 = in_buf[pos++]&0xff;
        c2 = in_buf[pos++]&0xff;
        c3 = in_buf[pos++]&0xff;
        c4 = in_buf[pos++]&0xff;
        loopStart = (c1*256*256*256+c2*256*256+c3*256+c4);
        tl.printMessageSU(tab("Vbl number to loop the song", DATA_TAB)+loopStart+" (unused)");

        c3 = in_buf[pos++]&0xff;
        c4 = in_buf[pos++]&0xff;
        futureDataLength = (c3*256+c4);
        tl.printMessageSU(tab("Size (in bytes) of future data", DATA_TAB)+futureDataLength+"");

        // skip samples!
        while (samples != 0)
        {
            long sample_length;
            c1 = in_buf[pos++]&0xff;
            c2 = in_buf[pos++]&0xff;
            c3 = in_buf[pos++]&0xff;
            c4 = in_buf[pos++]&0xff;
            sample_length=c1*256*256*256+c2*256*256+c3*256+c4;
            pos+=sample_length;
            samples--;
        }
        song_name ="";
        char cc=0;
        do
        {
            cc = (char)in_buf[pos++];
            if (cc != 0) song_name += cc;
        } while (cc!=0);
        tl.printMessageSU(tab("Name of song", DATA_TAB)+song_name+"");

        author ="";
        do
        {
            cc = (char)in_buf[pos++];
            if (cc != 0) author += cc;
        } while (cc!=0);
        tl.printMessageSU(tab("Name of author", DATA_TAB)+author+"");

        comment ="";
        do
        {
            cc = (char)in_buf[pos++];
            if (cc != 0) comment += cc;
        } while (cc!=0);
        tl.printMessageSU(tab("Comment", DATA_TAB)+comment+"");

        interleave=((attribut&1) == 1);
        if (interleave)
        {
            tl.printMessageSU("Using interleave format!");
            while( todo !=0)
            {
                int i;
                for (i=0;i<16;i++)
                {
                    byte poker = in_buf[pos+i*interleave_length];
                    byte[] outer = out_buf[i];
                    if ((i==1)||(i==3)||(i==5))
                        poker &= 1+2+4+8;
                    if ((i==6) )
                        poker &= 1+2+4+8+16;

                    if (i==7)
                        poker &= 1+2+4+8+16+32;
/*                    
                    // for vectrex
                    if ((i==8)||(i==9)||(i==10))
                    {
                        if (enableAmlitude5thBit)
                            poker &= 1+2+4+8+16;
                        else
                            poker &= 1+2+4+8;
                    }
*/        
                if (out_counter<outer.length)
                    outer[out_counter] = poker;
                }
                out_counter++;
                pos++;
                todo--;
            }
        }
        else
        {
            tl.printMessageSU("Using non interleave format!");
            while( todo !=0)
            {
               int i;
               for (i=0;i<16;i++)
               {
                   byte poker = in_buf[pos++];
                   byte[] outer = out_buf[i];
                    if ((i==1)||(i==3)||(i==5))
                       poker &= 1+2+4+8;

                    if ((i==6) )
                       poker &= 1+2+4+8+16;

                    if (i==7)
                       poker &= 1+2+4+8+16+32;
/*                    
               // for vectrex
                    if ((i==8)||(i==9)||(i==10))
                    {
                        if (enableAmlitude5thBit)
                            poker &= 1+2+4+8+16;
                        else
                            poker &= 1+2+4+8;
                    }
*/        
                    if (out_counter<outer.length)
                       outer[out_counter] = poker;
               }
               out_counter++;
               todo--;
           }
        }
        return vbl_len;
    }
    
    public boolean deleteVBL(int row)
    {
        if (row > out_buf[0].length) return false;
        for (int i=0;i<out_buf.length; i++)
        {
            System.arraycopy(out_buf[i], row+1, out_buf[i], row, out_buf[i].length-(row+1));
        }
        vbl_len--;
        return true;
    }
    
    public boolean addRow(int row)
    { 
        if (out_buf == null)
            out_buf = new byte[16][];

        byte[][] new_out_buf = new byte[16][];
        for (int i=0;i<16; i++)
        {
            int len = 1;
            if (out_buf[i] != null) len = out_buf[i].length+1;
            
            new_out_buf[i] = new byte[len];
            
            
            if (out_buf[i] != null)
            {
                if (row >0) 
                    System.arraycopy(out_buf[i], 0, new_out_buf[i], 0, row);
            }


            if (i != 7)
                new_out_buf[i][row] = 0;
            else
                new_out_buf[i][row] = 255-128-64;

            if (out_buf[i] != null)
            {
                System.arraycopy(out_buf[i], row, new_out_buf[i], row+1, out_buf[i].length-row);
            }

            out_buf[i] = new_out_buf[i];
        }
        vbl_len++;
        return true;
    }
    
    //////////////////////////////////////
    ///////// YM_CONV.C - END ////////////
    //////////////////////////////////////}
    
    
    //////////////////////////////////////
    ///////// BIT_CODE.C - START /////////
    //////////////////////////////////////
    public static final int BIT =  0;
    public static final int CODE =  1;

    
    // from here shannon helper

    // recursivly divides an array in halfs according to strengths
    // sets code and bit width
    // first half gets bit set
    // second half gets bit cleared
    void shannon(int from_index, int to_index, int bit_count, int coder, int set_count, int[] bytes_used_array, int[] map, Code[] code)
    {
        
        if (from_index == to_index)
        {
          code[map[from_index]].bit_count = bit_count + 1;
          code[map[from_index]].code = (coder<<1) + 1;
          return;
        }

        if (from_index+1 == to_index)
        {
          code[map[from_index]].bit_count = bit_count + 1;
          code[map[from_index]].code = (coder<<1)+1;
          code[map[to_index]].bit_count = bit_count + 1;
          code[map[to_index]].code = (coder<<1);
          return;
        }
        int start1 = from_index;
        int end1   = start1;
        int start2 = end1+1;
        int end2   = to_index;
        int set_count1 = bytes_used_array[map[end1]];
        int set_count2;
        while (set_count1 < set_count/2)
        {
            end1++;
            start2++;
            set_count1 += bytes_used_array[map[end1]];
        }
        set_count2 = 0;
        for (int i=start2; i<=end2; i++)
        {
            set_count2+=bytes_used_array[map[i]];
        }

        if (start1 == end1)
        {
            code[map[start1]].bit_count = bit_count + 1;
            code[map[start1]].code = (coder<<1)+1;
        }
        else
        {
            shannon(start1, end1, bit_count+1, (coder<<1)+1, set_count1, bytes_used_array, map, code);
        }

        if (start2 == end2)
        {
            code[map[start2]].bit_count = bit_count + 1;
            code[map[start2]].code = (coder<<1);
        }
        else
        {
            shannon(start2, end2, bit_count+1, (coder<<1), set_count2, bytes_used_array, map, code);
        }
    }

    // from here huffman helper
    static class Tree
    {
        int count;
        int index;
        Tree parent;
        Tree left;
        Tree right;
        int bit_count;
        int coder;
    };
    DoubleLinkedList list = new DoubleLinkedList();
            
//    DoubleLinkedList.DoubleLinkedListElement list_head = null;
//    DoubleLinkedList.DoubleLinkedListElement list_tail = NULL;

    // search smalles tree element in list and
    // remove it give it back
    Tree get_and_remove_from_list_smallest()
    {
        DoubleLinkedList.DoubleLinkedListElement listElement = list.first;
        Tree found=null;
        while (listElement != null)
        {
            Tree current = (Tree) listElement.object;
            if (found == null)
            {
                found = current;
            }
            else
            {
                if (found.count > current.count)
                {
                    found = current;
                }
            }
            listElement = listElement.next;
        }
        d_entferne_aus_liste(found, list, true );
        return found;
    }
    // set codes to coder from huffman tree information
    // recursive
    // free()'s tree node processed
    void code_tree(Tree htree, int[] map, Code[] code)
    {
        if (htree.index != -1)
        {
            code[map[htree.index]].bit_count = htree.bit_count;
            code[map[htree.index]].code = htree.coder;
        }
        else
        {
            Tree left = (Tree ) htree.left;
            left.bit_count = htree.bit_count+1;
            left.coder= ((htree.coder)<<1);

            Tree right = (Tree ) htree.right;
            right.bit_count = htree.bit_count+1;
            right.coder=((htree.coder)<<1)+1;

            code_tree(left, map, code);
            code_tree(right, map, code);
        }
    }    
    // codes into a huffman tree from map[from] to map[to]
    public void hstart(int from_index, int to_index, int[] bytes_used_array, int[] map, Code[] code)
    {
        // generate list with lose tree nodes
        // one node for each 'set'
        int i;
        for (i=from_index; i<to_index; i++)
        {
            Tree htree;
            htree = new Tree();
            htree.index = i;
            htree.count = bytes_used_array[map[i]];
            htree.parent = null;
            htree.left = null;
            htree.right = null;
            htree.bit_count = 0;
            htree.coder = 0;
            d_fuege_in_liste_ein(htree,list,DLL_ADD_LAST);
        }
        while (d_anzahl_liste(list) != 1)
        {
           // look for the two smallest elements of the set
           Tree small1 = get_and_remove_from_list_smallest();
           Tree small2 = get_and_remove_from_list_smallest();

           Tree htree;
           htree = new Tree();
           htree.index = -1;
           htree.count = small1.count+small2.count;
           htree.parent = null;
           htree.left = small1;
           htree.right = small2;
           htree.bit_count = 0;
           htree.coder = 0;
           small1.parent = htree;
           small2.parent = htree;
           d_fuege_in_liste_ein(htree,list,DLL_ADD_LAST);
        }
        // now we have a tree, whose root is the single
        // element of the list!

        // now we code it -> recursively
        code_tree(get_and_remove_from_list_smallest(), map, code);
    }
    //////////////////////////////////////
    ///////// BIT_CODE.C - END ///////////
    //////////////////////////////////////
    //////////////////////////////////////
    ///////// BIT_OUT.C - START //////////
    //////////////////////////////////////

    int get_bits_for_counter(int counter)
    {
        if (counter < 8)
            return 3;
        if (counter < 16)
            return 4;
        if (counter < 32)
            return 5;
        if (counter < 64)
            return 6;
        if (counter < 128)
            return 7;
        if (counter < 256)
            return 8;
        if (counter < 512)
            return 9;
        if (counter < 1024)
            return 10;
        if (counter < 2048)
            return 11;
        if (counter < 4096)
            return 12;
        if (counter < 8192)
            return 13;
        if (counter < 16384)
            return 14;
        if (counter < 32768)
            return 15;
        if (counter < 65536)
            return 16;
        return -1;
    }

    // lsb of count is first bit that is output (meaning lsb bit is in MSB position!)
    long get_RLE_code(int counter)
    {
        long ret = 0;
        int bits_for_counter = get_bits_for_counter(counter);
        int i;
        int ander = 1;
        for (i=0; i<bits_for_counter-2; i++)
        {
            ret<<=1;
            ret++;
        }
        ret<<=1;

        for (i=0; i<bits_for_counter; i++)
        {
            ret<<=1;
            if ((counter & (ander) ) != 0)
                ret++;
            ander<<=1;
        }
        return ret;
    }    
    long get_RLE_code_msb(int counter)
    {
        long ret = 0;
        int bits_for_counter = get_bits_for_counter(counter);
        int i;
        int ander = 1;
        ander = ander << (bits_for_counter-1);
        for (i=0; i<bits_for_counter-2; i++)
        {
            ret<<=1;
            ret++;
        }
        ret<<=1;

        for (i=0; i<bits_for_counter; i++)
        {
            ret<<=1;
            if ((counter & (ander) ) != 0)
                ret++;
            ander>>=1;
        }
        return ret;
    }    
    byte current_out;
    byte current_out_bit;
    byte current_out_bit_counter;
    BufferedWriter dbOutFile = null;
    BufferedWriter get_dbOutFile()
    {
        return dbOutFile;
    }

    void deinit_bit_out()
    {
        try
        {
            if (dbOutFile != null)
                dbOutFile.close();
        }
        catch (Throwable e)
        {
            e.printStackTrace();
        }
        dbOutFile = null;
    }
    
    void init_bit_out(BufferedWriter outFile)
    {
        dbOutFile = outFile;
        current_out = 0;
        current_out_bit = 0;
        current_out_bit_counter = 0;
    }
    int byte_out_counter = 0;
    void byte_out(byte b)
    {
        try
        {
            byte_out_counter = 0;
            if (dbOutFile!=null)
            {
                String s;
                s = " DB $"+String.format("%02X",b&0xff)+"\n";
                dbOutFile.write(s, 0, s.length());
            }
            current_out_bit_counter+=8;
            current_out_bit=0;
            current_out=0;
        }
        catch (Throwable e)
        {
            e.printStackTrace();
        }
    }
    
    void bit_out(int abit)
    {
        try
        {
    
            // printf(" \n current_bit_counter $%02X \n", current_out_bit);
             current_out<<=1;
             current_out += ( (abit != 0) ?1:0);
             current_out_bit++;
             current_out_bit_counter++;
            // printf(" current_out $%02X \n", current_out);
             if (current_out_bit == 8)
             {
                if (dbOutFile!=null)
                {
                    String s;
                    if (byte_out_counter == 0)
                    {
                        s = " DB $"+String.format("%02X",current_out&0xff);
                    }
                    else
                    {
                        s = ", $"+String.format("%02X",current_out&0xff);
                    }
                    dbOutFile.write(s, 0, s.length());
                    byte_out_counter++;
                    if (byte_out_counter == 10)
                    {
                        byte_out_counter=0;
                        s = "\n";
                        dbOutFile.write(s, 0, s.length());
                    }
                }
                current_out_bit=0;
                current_out=0;
             }
            
            
        }
        catch (Throwable e)
        {
            e.printStackTrace();
        }
        
    }

    void bit_flush()
    {
        while (current_out_bit!=0)
        {
            bit_out(0);
        }
        try
        {
            String s = " ; flushed\n";
            dbOutFile.write(s, 0, s.length());
            byte_out_counter = 0;
        }
        catch (Throwable e)
        {
            e.printStackTrace();
        }
    }

    void bits_out_bit_code(int bit_len, int code)
    {
        int cb = bit_len;
        while (cb != 0)
        {
            cb--;
            bit_out(code&(1<<cb));
        }
    }
    //////////////////////////////////////
    ///////// BIT_OUT.C - END ////////////
    //////////////////////////////////////
    
    
    
    
    
    

    //////////////////////////////////////
    //////// ABSTRACT.C - START //////////
    //////////////////////////////////////
    public static final int  _MAX_PHRASE_LEN_ = 100;
    public static final int  PHRASES_MAX = 100;
    class phrase
    {
        int[]  phrase = new int[_MAX_PHRASE_LEN_];
        int  len;
        int  count;
        int  start;
    };

    public static final int   VALID_BYTE =1;
    public static final int   VALID_PHRASE =2;
    public static final int   VALID_RLE_BYTE =3;
    public static final int   VALID_RLE_PHRASE =4;
    public static final int   VALID_ENCODED_BYTE =5;
    public static final int   VALID_ENCODED_PHRASE =6;
    public static final int   VALID_ENCODED_RLE_BYTE =7;
    public static final int   VALID_ENCODED_RLE_PHRASE =8;

    public static final int   INVALID =0;
    public static final int   VALID =1;
    public static final int   ENCODED =2;
    public static final int   RLE =4;
    public static final int   RLE_ENCODED =6;

    class abstract_data
    {
        int type; // types, see above
        int bit_length_ENCODED; // bit length of current code
        int ENCODED_code; // current bit code for this 'data'
        int bit_length_RLE; // bit length of current code
        long RLE_code; // current bit code for this 'data'
        int count; // repeated how many times?
        int length_in_abstract_data_elements_of_single_element;
        int original_data;
        int phrase_used; // if phrase is used, here is a pointer to it
    };

    class abstract_buffer
    {
        abstract_data[] data;
        int len;
        phrase[] phrases;              // phrases used in this abstract
        int phrase_count;             // number of phrases used...
        int[] codes_used_array;
        int[] map;
        Code[] code;
        int different_codes_used;
        int kind;
    };

    phrase[][] alternating_phrases = new phrase[2][];
    int phrase_toggler;
    String[] type_string=
    {
        "INVALID",
        "VALID_BYTE"          ,
        "VALID_PHRASE"        ,
        "VALID_RLE_BYTE"      ,
        "VALID_RLE_PHRASE"    ,
        "VALID_ENCODED_BYTE"  ,
        "VALID_ENCODED_PHRASE",
        "VALID_ENCODED_RLE_BYTE",
        "VALID_ENCODED_RLE_PHRASE"
    };
    class Code 
    {
          int bit_count;
          int code;
    }
    class sorted_codes
    {
        int bits;
        int code;
        int value;
        int map;
    };

    abstract_buffer abstract_clone(abstract_buffer abuffer)
    {
        abstract_buffer buffer = new abstract_buffer();
        buffer.len = abuffer.len;
        buffer.data = new abstract_data[abuffer.len];
        buffer.phrase_count = abuffer.phrase_count;
        buffer.kind = abuffer.kind;

        abstract_data[] data = buffer.data;
        int i;
        for (i=0;i<abuffer.len;i++)
        {
            data[i] = new abstract_data();
            data[i].type = abuffer.data[i].type;
            data[i].ENCODED_code = abuffer.data[i].ENCODED_code;
            data[i].bit_length_ENCODED = abuffer.data[i].bit_length_ENCODED;
            data[i].RLE_code = abuffer.data[i].RLE_code;
            data[i].bit_length_RLE = abuffer.data[i].bit_length_RLE;
            data[i].count = abuffer.data[i].count;
            data[i].original_data = abuffer.data[i].original_data;
            data[i].phrase_used = abuffer.data[i].phrase_used;
            data[i].length_in_abstract_data_elements_of_single_element = abuffer.data[i].length_in_abstract_data_elements_of_single_element;
        }

        int[] bytes_used_array;
        int[] map;
        Code[] code;
        phrase[] phrases;
        code = new Code[256+PHRASES_MAX];
        bytes_used_array = new int[256+PHRASES_MAX];
        map = new int[256+PHRASES_MAX];
        phrases = new phrase[256+PHRASES_MAX];
        

        for (i=0;i<PHRASES_MAX;i++)
        {
            phrases[i] = new phrase();
            if (abuffer.phrases[i].len != 0)
            {
               int j;
               for (j=0;j<abuffer.phrases[i].len; j++)
               {
                    phrases[i].phrase[j] = abuffer.phrases[i].phrase[j];
               }
            }
            phrases[i].len=abuffer.phrases[i].len;
            phrases[i].count=abuffer.phrases[i].count;
        }

        for (i=0;i<256+PHRASES_MAX;i++)
        {
            code[i] = new Code();
            bytes_used_array[i] = abuffer.codes_used_array[i];
            map[i]=abuffer.map[i];
            code[i].bit_count = abuffer.code[i].bit_count;
            code[i].code = abuffer.code[i].code;
        }

        buffer.phrases = phrases;
        buffer.codes_used_array = bytes_used_array;
        buffer.map = map;
        buffer.code = code;
        buffer.different_codes_used = abuffer.different_codes_used;

        return buffer;
    }    
    abstract_buffer build_abstract(byte[] data_buf, int len)
    {
        abstract_data[] data;
        int i = 0;

        abstract_buffer buffer = new abstract_buffer();
        buffer.kind = VALID;
        buffer.len = len;
        buffer.data = new abstract_data[len];
        buffer.phrase_count = 0;
        data = buffer.data;

        for (i=0;i<len;i++)
        {
            data[i] = new abstract_data();
            data[i].type = VALID_BYTE;
            data[i].ENCODED_code = 0;
            data[i].bit_length_ENCODED = 0;
            data[i].RLE_code = 0;
            data[i].bit_length_RLE = 0;
            data[i].count = 1;
            data[i].original_data = data_buf[i];
            data[i].phrase_used = 0;
            data[i].length_in_abstract_data_elements_of_single_element = 1;
        }

        int[] bytes_used_array;
        int[] map;
        Code[] code;
        phrase[] phrases;
        
        code = new Code[256+PHRASES_MAX];
        bytes_used_array = new int[256+PHRASES_MAX];
        map = new int[256+PHRASES_MAX];
        phrases = new phrase[256+PHRASES_MAX];
        buffer.phrases = phrases;

        for (i=0;i<PHRASES_MAX;i++)
        {
            phrases[i] = new phrase();
            phrases[i].len=0;
            phrases[i].count=0;
        }
        for (i=0;i<256+PHRASES_MAX;i++)
            bytes_used_array[i]=0;

        i=0;
        while( i != len )
        {
            bytes_used_array[data[i].original_data&0xff]++; // make byte unsigned
            i++;
        }

        int bytes_used_array_count=0; // count of different 'bytes' (+phrases) used in this abstract
        for (i=0;i<256+PHRASES_MAX;i++)
        {
            code[i] = new Code();
            if (bytes_used_array[i] != 0)
            {
                bytes_used_array_count++;
            }
        }
       // count bytes end

       // fill map start
         int remember = -1;
         int map_count = 0;
         for (i=0;i<256+PHRASES_MAX;i++)
            map[i]=-1;

         while (map_count < 256 + PHRASES_MAX)
         {
            int most = -1;
            for (i=0;i<256+PHRASES_MAX ;i++)
            {
                if (bytes_used_array[i] >= most)
                {
                    most = bytes_used_array[i];
                    remember = i;
                }
            }
            map[map_count] = remember;
            bytes_used_array[remember] = -2;
            map_count++;
         }
       // fill map end

       // correct count start
        for (i=0;i<256+PHRASES_MAX;i++)
            bytes_used_array[i]=0;
        i=0;
        while( i != len )
        {
            bytes_used_array[data[i].original_data&0xff]++;
            i++;
        }
        buffer.codes_used_array = bytes_used_array;
        buffer.map = map;
        buffer.code = code;
        buffer.different_codes_used = bytes_used_array_count;

        return buffer;
    }
    void delete_abstract(abstract_buffer buffer)
    {
        buffer.phrases=null;
        buffer.data=null;
        buffer.code=null;
        buffer.codes_used_array=null;
        buffer.map=null;
    }
    void abstract_Huffman(abstract_buffer buffer)
    {
        // count bytes start
         abstract_data[] data = buffer.data;
         int len = buffer.len;
         int i = 0;
         buffer.kind = ENCODED;

         // result in code[][]
         hstart(0, buffer.different_codes_used, buffer.codes_used_array, buffer.map, buffer.code);

         i=0;
         while( i < len )
         {
            if (data[i].type == VALID_BYTE)
            {
                  data[i].type = VALID_ENCODED_BYTE;

                  if (buffer.code[data[i].original_data&0xff].code>255)
                  {
                      System.out.println("encode error, code = "+buffer.code[data[i].original_data&0xff].code+" (from "+(data[i].original_data&0xff)+")\n");
                  }
                  data[i].ENCODED_code = buffer.code[data[i].original_data&0xff].code;
                  data[i].bit_length_ENCODED = buffer.code[data[i].original_data&0xff].bit_count;
            }
            else if (data[i].type == VALID_PHRASE)
            {
                  data[i].type = VALID_ENCODED_PHRASE;
                  if (buffer.code[data[i].phrase_used+256].code>255)
                  {
                      log.addLog("Encode error, Huffman code > 255, bigger than 1 byte - exiting!", ERROR);
                      return;
                  }
                  data[i].ENCODED_code = buffer.code[data[i].phrase_used+256].code;
                  data[i].bit_length_ENCODED = buffer.code[data[i].phrase_used+256].bit_count;
            }
            i+=data[i].length_in_abstract_data_elements_of_single_element;
         }
    }
    void abstract_Shannon(abstract_buffer buffer)
    {
        // count bytes start
         abstract_data[] data = buffer.data;
         int len = buffer.len;
         int i;
         buffer.kind = ENCODED;

         // result in code[][]
         shannon(0, buffer.different_codes_used, 0, 0, len, buffer.codes_used_array, buffer.map, buffer.code);

         i=0;
         while( i < len )
         {
            if (data[i].type == VALID_BYTE)
            {
                  data[i].type = VALID_ENCODED_BYTE;
                  if (buffer.code[data[i].original_data&0xff].code>255)
                  {
                      if (!dontShanonSingleByteUsages)
                      {
                        log.addLog("Encode error, Shannon byte code > 255, bigger than 1 byte - exiting!", ERROR);
                        return;
                      }
                  }
                  data[i].ENCODED_code = buffer.code[data[i].original_data&0xff].code;
                  data[i].bit_length_ENCODED = buffer.code[data[i].original_data&0xff].bit_count;
            }
            else if (data[i].type == VALID_PHRASE)
            {
                  data[i].type = VALID_ENCODED_PHRASE;
                  if (buffer.code[data[i].phrase_used+256].code>255)
                  {
                      log.addLog("Encode error, Shannon phrase code > 255, bigger than 1 byte - exiting!", ERROR);
                      return;
                  }
                  data[i].ENCODED_code = buffer.code[data[i].phrase_used+256].code;
                  data[i].bit_length_ENCODED = buffer.code[data[i].phrase_used+256].bit_count;
            }
            i+=data[i].length_in_abstract_data_elements_of_single_element;
         }
    }    
    void abstract_RLE(abstract_buffer buffer)
    {
        if (buffer.kind == ENCODED)
            buffer.kind = RLE_ENCODED;
        else
            buffer.kind = RLE;

        abstract_data[] data = buffer.data;
        int len = buffer.len;
        int pos = 0;
        int current_out = 0;
        int current_out_bit = 0;
        int current_code = 0;
        int current_bits = 0;
        while( pos < len )
        {
            int counter = 1;
         // fixme test for valid data
         // fixme for non ENCODED
            if (  (data[pos].type == VALID_ENCODED_BYTE)
               || (data[pos].type == VALID_ENCODED_PHRASE)
               )
            {
                current_code = data[pos].ENCODED_code;
                current_bits = data[pos].bit_length_ENCODED;
            }
            else if (data[pos].type == VALID_BYTE)
            {
                 current_code = data[pos].original_data&0xff;
                 current_bits = 8;
            }
            else if (data[pos].type == VALID_PHRASE)
            {
                 current_code = data[pos].phrase_used;
                 current_bits = 9;
            }

            while (pos+data[pos].length_in_abstract_data_elements_of_single_element < len)
            {
             // fixme for non ENCODED
                if (
                     (((data[pos].type == VALID_ENCODED_BYTE) && (data[pos+data[pos].length_in_abstract_data_elements_of_single_element].type == VALID_ENCODED_BYTE)) &&
                      (data[pos+data[pos].length_in_abstract_data_elements_of_single_element].ENCODED_code == data[pos].ENCODED_code) &&
                      (data[pos+data[pos].length_in_abstract_data_elements_of_single_element].bit_length_ENCODED == data[pos].bit_length_ENCODED))
                    ||
                     (((data[pos].type == VALID_ENCODED_PHRASE) && (data[pos+data[pos].length_in_abstract_data_elements_of_single_element].type == VALID_ENCODED_PHRASE)) &&
                      (data[pos+data[pos].length_in_abstract_data_elements_of_single_element].ENCODED_code == data[pos].ENCODED_code) &&
                      (data[pos+data[pos].length_in_abstract_data_elements_of_single_element].bit_length_ENCODED == data[pos].bit_length_ENCODED))
                    ||
                     (((data[pos].type == VALID_BYTE) && (data[pos+data[pos].length_in_abstract_data_elements_of_single_element].type == VALID_BYTE)) &&
                      (data[pos+data[pos].length_in_abstract_data_elements_of_single_element].original_data == data[pos].original_data))
                    ||
                     (((data[pos].type == VALID_PHRASE) && (data[pos+data[pos].length_in_abstract_data_elements_of_single_element].type == VALID_PHRASE)) &&
                      (data[pos+data[pos].length_in_abstract_data_elements_of_single_element].phrase_used == data[pos].phrase_used))
                   )
                {
                    data[pos].type = INVALID;
                    // the last occurance is valid
                    pos += data[pos].length_in_abstract_data_elements_of_single_element;
                    counter++;
                    continue;
                }
                  break;
            }
            if (counter == 1)
            {
                // fixme for non ENCODED
                if ((data[pos].type == VALID_ENCODED_BYTE) || (data[pos].type == VALID_ENCODED_PHRASE))
                {
                   data[pos].RLE_code = 0;
                   data[pos].bit_length_RLE = 1;
                   data[pos].count = 1;
                   if (data[pos].type == VALID_ENCODED_BYTE)
                       data[pos].type = VALID_ENCODED_RLE_BYTE;
                   else if (data[pos].type == VALID_ENCODED_PHRASE)
                       data[pos].type = VALID_ENCODED_RLE_PHRASE;
                }
                else
                {
                   if ((data[pos].type == VALID_BYTE) || (data[pos].type == VALID_PHRASE))
                   {
                       data[pos].RLE_code = 0;
                       data[pos].bit_length_RLE = 1;
                       data[pos].count = 1;
                       if (data[pos].type == VALID_BYTE)
                           data[pos].type = VALID_RLE_BYTE;
                       else if (data[pos].type == VALID_PHRASE)
                           data[pos].type = VALID_RLE_PHRASE;
                   }
                }
            }
            else
            {
                int bits_for_counter = get_bits_for_counter(counter);

                if ((data[pos].type == VALID_ENCODED_BYTE) || (data[pos].type == VALID_ENCODED_PHRASE))
                {
                    if (dontShanonSingleByteUsages)
                       data[pos].RLE_code = get_RLE_code_msb(counter);
                    else
                        data[pos].RLE_code = get_RLE_code(counter);
                   data[pos].bit_length_RLE = bits_for_counter - 1 + bits_for_counter;
                   data[pos].count = counter;
                   if (data[pos].type == VALID_ENCODED_BYTE)
                       data[pos].type = VALID_ENCODED_RLE_BYTE;
                   else if (data[pos].type == VALID_ENCODED_PHRASE)
                       data[pos].type = VALID_ENCODED_RLE_PHRASE;
                }
                else
                {
                    if ((data[pos].type == VALID_BYTE) || (data[pos].type == VALID_PHRASE))
                    {
                        if (dontShanonSingleByteUsages)
                           data[pos].RLE_code = get_RLE_code_msb(counter);
                        else
                            data[pos].RLE_code = get_RLE_code(counter);
                        data[pos].bit_length_RLE = bits_for_counter - 1 + bits_for_counter;
                        data[pos].count = counter;
                        if (data[pos].type == VALID_BYTE)
                            data[pos].type = VALID_RLE_BYTE;
                        else if (data[pos].type == VALID_PHRASE)
                            data[pos].type = VALID_RLE_PHRASE;
                    }
                }
            }
            pos+=data[pos].length_in_abstract_data_elements_of_single_element;
        }
    }
    int get_bits_used_from_abstract(abstract_buffer buffer)
    {
        abstract_data []data = buffer.data;
        int len = buffer.len;
        int count = 0;
        int i=0;
        while( i < len )
        {
            if (data[i].type == VALID_BYTE)
            {
                count += 8;
            }

            if (data[i].type == VALID_PHRASE)
            {
                count += 9; // non encoded phrase 'more' than one byte
            }

            if (data[i].type == VALID_RLE_BYTE)
            {
                count += 8;
                count += data[i].bit_length_RLE;
            }

            if (data[i].type == VALID_RLE_PHRASE)
            {
                count += 9;
                count += data[i].bit_length_RLE;
            }

            if (   (data[i].type == VALID_ENCODED_BYTE)
                || (data[i].type == VALID_ENCODED_PHRASE)
               )
            {
                count += data[i].bit_length_ENCODED;
            }

            if (   (data[i].type == VALID_ENCODED_RLE_BYTE)
                || (data[i].type == VALID_ENCODED_RLE_PHRASE)
               )
            {
                count += data[i].bit_length_RLE;
                count += data[i].bit_length_ENCODED;
            }
            i+=data[i].length_in_abstract_data_elements_of_single_element;
        }
        return count;
    }
    int get_bits_used_from_abstract_complete(abstract_buffer buffer)
    {
        int used_bits = get_bits_used_from_abstract(buffer);
       // used_bits += 8; // buffer->different_codes_used
        for(int i=0;i<buffer.different_codes_used;i++)
        {
            // not exact for non optimal phase
            // since count 0 phrases phrases can occur!
            used_bits += 8+8+8; // buffer->code[buffer->map[i]].bit_count, buffer->code[buffer->map[i]].code,buffer->map[i]
        }

        int i=0;
        while (buffer.phrases[i].len != 0)
        {
            // not exact for non optimal phase
            // since count 0 phrases phrases can occur!
            used_bits += 8; // len of phrase
            int j;
            for (j=0; j<buffer.phrases[i].len; j++)
            {
                // for now only unpacked data == bytes
                byte outer = (byte) (buffer.phrases[i].phrase[j]);
                used_bits += 8; // a phrase code
            }
            i++;
        }
        return used_bits;
    }
    sorted_codes[] abstract_sort_code_with_bits(abstract_buffer buffer)
    {
        int i;
        sorted_codes[] sorted = new sorted_codes[buffer.different_codes_used];
        for(i=0;i<buffer.different_codes_used;i++)
        {
            sorted[i] = new sorted_codes();
            sorted[i].bits =  (buffer.code[buffer.map[i]].bit_count)&0xff;
            sorted[i].code =  (buffer.code[buffer.map[i]].code)&0xff;
            sorted[i].value = ((buffer.map[i])&255)&0xff;
            sorted[i].map = buffer.map[i];
        }
        
        Arrays.sort(sorted, new Comparator<sorted_codes>() {
                @Override
                public int compare(sorted_codes p1, sorted_codes p2) 
                {
                    if ((p1.bits &0xff)<(p2.bits &0xff)) return -1;
                    if ((p1.bits &0xff)>(p2.bits &0xff)) return 1;
                    if ((p1.code &0xff)<(p2.code &0xff)) return -1;
                    if ((p1.code &0xff)>(p2.code &0xff)) return 1;
                    return 0;
                }
            });        
        return sorted;
    }  
    void fprintf(BufferedWriter w, String s)
    {
        try
        {
            w.write(s);
        }
        catch (Throwable e)
        {
            e.printStackTrace();
        }
    }
    void abstract_out(abstract_buffer buffer)
    {
        abstract_data[] data = buffer.data;
        int len = buffer.len;
        int i = 0;
        int j = 0;
        BufferedWriter outFile = get_dbOutFile();
        sorted_codes[] sorted = abstract_sort_code_with_bits(buffer);
        if ((buffer.kind == ENCODED) || (buffer.kind == RLE_ENCODED))
        {
           if (outFile != null)
           {
                fprintf(outFile,"; translation data \n");
                fprintf(outFile,"; DB $"+String.format("%02X",buffer.different_codes_used&0xff)+"; bytes follow \n");
                fprintf(outFile,"; bits used, code, real 'byte' \n");
                fprintf(outFile,""+file_name+"_reg_"+current_working_register+": \n");
            }
            int iCount = 0;
            for(i=0;i<buffer.different_codes_used;i++)
            {
                int bit_count =  (sorted[i].bits);
                int code = (sorted[i].value);
                int count;
                if (sorted[i].map >=256)
                {
                    // bit one of bit count is pointer to whether it is a phrase or a
                    // byte
                    bit_count+=128;
                }
                if (bit_count>128)
                    count = buffer.codes_used_array[256+code];
                else
                    count = buffer.codes_used_array[code];
                
                if (dontShanonSingleByteUsages)// && ((data[i].bit_length_ENCODED >= 8) && ((int)data[i].RLE_code == 0)))
                {
                    if (bit_count<=128)
                    {
                        count=0;
                    }
                    
                }
                if (count > 0)
                {
                    if (dontShanonSingleByteUsages)
                    {
                        if (outFile != null)
                             fprintf(outFile," DB $"+String.format("%02X",bit_count&0x7f)
                                     +", $"+String.format("%02X",sorted[i].code&0xff)   
               //                      +", $"+String.format("%02X",iCount&0xff)
                                     +", $"+String.format("%02X",buffer.phrases[code].len & 0xff)
                                     +" ;"+count+" \n");
                        iCount++;
                    }
                    else
                    {
                        if (outFile != null)
                             fprintf(outFile," DB $"+String.format("%02X",bit_count&0xff)
                                     +", $"+String.format("%02X",sorted[i].code&0xff)   
                                     +", $"+String.format("%02X",code&0xff)
                                     +" ;"+count+" \n");
                    }
                }
            }
            if (USE_PHRASE)
            {
                if (dontShanonSingleByteUsages)
                {
                    if (outFile != null)
                     {
                         fprintf(outFile,"; phrases follow \n");
                         fprintf(outFile,file_name+"_pd_"+current_working_register+": \n");
                     }
                     for(i=0;i<buffer.different_codes_used;i++)
                     {
                         int bit_count =  (sorted[i].bits);
                         int code = (sorted[i].value);



                         if (sorted[i].map >=256)
                         {
                             if (buffer.codes_used_array[code+256]>0)
                             {
                                 if (outFile != null)
                                 {
                                     fprintf(outFile," DB ");
                                 }
                                 boolean first = true;
                                 for (j=0; j<buffer.phrases[code].len; j++)
                                 {
                                     // for now only unpacked data == bytes
                                     int outer = (buffer.phrases[code].phrase[j]);
                                     if (outFile != null)
                                     {
                                         if (first)
                                             fprintf(outFile,"$"+String.format("%02X",outer & 0xff));
                                        else
                                             fprintf(outFile,", $"+String.format("%02X",outer & 0xff));
                                         first = false;
                                     }
                                 }
                                 if (j!=0)
                                 {
                                     if (outFile != null)
                                     {
                                         fprintf(outFile,"; "+buffer.codes_used_array[code+256]+" \n");
                                     }
                                 }
                             }
                         }
                     }
                }
                else
                {
                    if (outFile != null)
                    {
                        fprintf(outFile,"; phrases follow \n");
                        fprintf(outFile,file_name+"_pd_"+current_working_register+": \n");
                    }
                    i=0;
                    while (buffer.phrases[i].len != 0)
                    {
                        if (buffer.codes_used_array[i+256]>0)
                        {
                            if (outFile != null)
                            {
                                fprintf(outFile," DB $"+String.format("%02X",buffer.phrases[i].len & 0xff) );
                            }
                            for (j=0; j<buffer.phrases[i].len; j++)
                            {
                                // for now only unpacked data == bytes
                                int outer = (buffer.phrases[i].phrase[j]);
                                if (outFile != null)
                                {
                                    fprintf(outFile,", $"+String.format("%02X",outer & 0xff));
                                }
                            }
                            if (j!=0)
                            {
                                if (outFile != null)
                                {
                                    fprintf(outFile,"; "+buffer.codes_used_array[i+256]+" \n");
                                }
                            }
                        }
                        i++;
                    }                    
                }
 
            }
        }
        if (outFile != null)
        {
            fprintf(outFile,"; data follows \n");
            fprintf(outFile,file_name+"_reg_"+current_working_register+"_data: \n");
        }

        i = 0;
        while( i < len )
        {
            // invalid are not used!
            if (data[i].type == VALID_BYTE)
            {
                byte_out((byte)data[i].original_data);
            }
            if (data[i].type == VALID_PHRASE)
            {
                for (j=0;j<buffer.phrases[data[i].phrase_used].len; j++)
                {
                    byte_out((byte)buffer.phrases[data[i].phrase_used].phrase[j]);
                }
            }

            if (data[i].type == VALID_RLE_BYTE)
            {
                bits_out_bit_code(data[i].bit_length_RLE, (int)data[i].RLE_code);
                byte_out((byte)data[i].original_data);
            }

            if (data[i].type == VALID_RLE_PHRASE)
            {
                bits_out_bit_code(data[i].bit_length_RLE, (int)data[i].RLE_code);
                for (j=0;j<buffer.phrases[data[i].phrase_used].len; j++)
                {
                    byte_out((byte)buffer.phrases[data[i].phrase_used].phrase[j]);
                }
            }
            if (data[i].type == VALID_ENCODED_BYTE)
            {
                bits_out_bit_code(data[i].bit_length_ENCODED, data[i].ENCODED_code);
            }

            if (data[i].type == VALID_ENCODED_PHRASE)
            {
                bits_out_bit_code(data[i].bit_length_ENCODED, data[i].ENCODED_code);
            }

            if (data[i].type == VALID_ENCODED_RLE_BYTE)
            {
//System.out.println("RLE byte -> count: "+data[i].count+ ", data: "+String.format("%02X",((byte) (data[i].original_data)&0xff))+" phrasew used"+data[i].phrase_used);
               
                if (dontShanonSingleByteUsages) 
                {
                    int max_reg_data_len = 8;
                    if ((current_working_register==8) || (current_working_register==9) || (current_working_register==10))
                    {
                        if (enableAmlitude5thBit)
                        {
                            bitsSaved += 3;
                            max_reg_data_len = 5;
                        }
                        else
                        {
                            bitsSaved += 4;
                            max_reg_data_len = 4;
                        }
                    }
                    else if ((current_working_register==1) || (current_working_register==3) || (current_working_register==5))
                    {
                        bitsSaved += 4;
                        max_reg_data_len = 4;
                    }
                    else if (current_working_register==6)
                    {
                        bitsSaved += 3;
                        max_reg_data_len = 5;
                    }
                    else if (current_working_register==7)
                    {
                        bitsSaved += 2;
                        max_reg_data_len = 6;
                    }
                    else if (current_working_register==13)
                    {
                        // not doing a ff for a skip but a 1f
                        bitsSaved += 3;
                        max_reg_data_len = 5;
                    }
                    bits_out_bit_code(data[i].bit_length_RLE, (int)data[i].RLE_code);
                    bits_out_bit_code(1, 0); // no shannon
                    bits_out_bit_code(max_reg_data_len, (byte)data[i].original_data);
                }
                else
                {
                    bits_out_bit_code(data[i].bit_length_RLE, (int)data[i].RLE_code);
                    bits_out_bit_code(data[i].bit_length_ENCODED, data[i].ENCODED_code);
                }
            }

            if (data[i].type == VALID_ENCODED_RLE_PHRASE)
            {
                bits_out_bit_code(data[i].bit_length_RLE, (int)data[i].RLE_code);
                if (dontShanonSingleByteUsages) 
                    bits_out_bit_code(1, 1); // shannon
                bits_out_bit_code(data[i].bit_length_ENCODED, data[i].ENCODED_code);
            }
            i+=data[i].length_in_abstract_data_elements_of_single_element;
        }
        bit_flush();
    }
    boolean abstract_phrase_already_seen(phrase[] phrases, int[] phrase_codes)
    {
        int current_phrase = 0;
        while (phrases[current_phrase].len != 0)
        {
            int i;
            for (i=0;i<phrases[current_phrase].len;i++)
            {
                if (phrases[current_phrase].phrase[i] != phrase_codes[i])
                {
                    break;
                }
            }
            if (i == phrases[current_phrase].len)
            {
                if (PHRASE_OPTIMIZER != 2)
                {
                    phrases[current_phrase].count++;
                }
                return true;
            }
            current_phrase++;
        }
        return false;
    }
    boolean abstract_phrase_valid(phrase[] phrases, int[] phrase_codes, int phrase_len)
    {
        int i;
        int first = phrase_codes[0];
        for (i=0;i<phrase_len;i++)
        {
            if (phrase_codes[i] != first)
            {
                break;
            }
        }
        if (i == phrase_len)
        {
            return false;
        }
        return !abstract_phrase_already_seen(phrases, phrase_codes);
    }
    int abstract_get_phrase_count(abstract_buffer abuffer, int[] phrase_codes, int phrase_len, int start)
    {
        int counter = 0;
        abstract_data[] data = abuffer.data;
        int array_counter = start;
        while (array_counter + phrase_len < abuffer.len)
        {
            int j;
            for (j=0; j<phrase_len;j++)
            {
                if (data[array_counter].type != VALID_BYTE)
                    break;
                if ((phrase_codes[j]&0xff) == (data[array_counter].original_data&0xff))
                {
                    if (array_counter < abuffer.len)
                    {
                      if (j+1<phrase_len)
                          array_counter++;
                    }
                    else
                    {
                      return counter;
                    }
                }
                else
                {
                    break;
                }
            }
            if (j==phrase_len)
            {
                counter++;
            }
            array_counter++;
        }
        return counter;
    }
    // time killer!!!
    phrase abstract_get_best_phrase_used_more_than_once(abstract_buffer abuffer, int phrase_len)
    {
        int[] phrase_codes = new int[_MAX_PHRASE_LEN_];
        int phrase_count=abuffer.len-(phrase_len-1);
        if (alternating_phrases[phrase_toggler] == null)
        {
            alternating_phrases[phrase_toggler] = new phrase [phrase_count+1];
            for (int i=0; i<phrase_count+1; i++ )
            {
                alternating_phrases[phrase_toggler][i] = new phrase();
            }
        }
        
        abstract_data[] data = abuffer.data;
        alternating_phrases[phrase_toggler][0].len = 0;
        alternating_phrases[phrase_toggler][0].count = 0;

        int current_phrase = 0;
        int array_counter = 0;

        int max_count = 1;
        int best_index = -1;
        phrase best = new phrase();
        best.len = 0;
        int other_toggle = (phrase_toggler+1)%2;
        while (array_counter+phrase_len<abuffer.len)
        {
            int i;
            int valid =1 ;

            if (alternating_phrases[other_toggle] != null)
            {
                valid = 0;
                i=0;
                while (alternating_phrases[other_toggle][i].len != 0)
                {
                   if (alternating_phrases[other_toggle][i].start == array_counter)
                   {
                       valid = 1;
                       break;
                   }
                   i++;
                }
            }

            if (valid!=0)
            {
                for (i=0; i<phrase_len;i++)
                {
                    if (data[array_counter+i].type != VALID_BYTE)
                    {
                        valid = 0;
                        break;
                    }
                    phrase_codes[i] = data[array_counter+i].original_data&0xff;
                }
                if (valid == 0)
                {
                    array_counter++;
                    continue;
                }
                // in abstract_phrase_already_seen(), which is called in
                // abstract_phrase_valid the count for doubles is set!
                // above is true for search optimization = 0!
                if (abstract_phrase_valid(alternating_phrases[phrase_toggler], phrase_codes, phrase_len))
                {
                    if (PHRASE_OPTIMIZER == 0)
                    {
                        alternating_phrases[phrase_toggler][current_phrase].len = phrase_len;
                        alternating_phrases[phrase_toggler][current_phrase].count = 1;
                        alternating_phrases[phrase_toggler][current_phrase].start = array_counter;
                        for (i=0; i<phrase_len;i++)
                        {
                           alternating_phrases[phrase_toggler][current_phrase].phrase[i] = phrase_codes[i];
                        }
                        current_phrase++;

                        alternating_phrases[phrase_toggler][current_phrase].len = 0;
                        alternating_phrases[phrase_toggler][current_phrase].count = 0;
                    }
                    else
                    {
                       // takes much time, but is difficult to correctly count in another manor
                       // since overlapping (same) phrases can occur, which garbles count
                       int count = abstract_get_phrase_count(abuffer, phrase_codes, phrase_len, array_counter+1);
                       if (count > 1)
                       {
                        alternating_phrases[phrase_toggler][current_phrase].len = phrase_len;
                        alternating_phrases[phrase_toggler][current_phrase].count = count;
                        alternating_phrases[phrase_toggler][current_phrase].start = array_counter;
                        for (i=0; i<phrase_len;i++)
                        {
                            alternating_phrases[phrase_toggler][current_phrase].phrase[i] = phrase_codes[i];
                        }
                        if (count > max_count)
                        {
                            max_count = count;
                            best_index = current_phrase;
                        }
                        current_phrase++;

                        alternating_phrases[phrase_toggler][current_phrase].len = 0;
                        alternating_phrases[phrase_toggler][current_phrase].count = 0;
                       }
                    }
                }
            }
            array_counter++;
        }

        if (PHRASE_OPTIMIZER == 0)
        {
            for (int i=0; i < current_phrase; i++)
            {
                if (alternating_phrases[phrase_toggler][i].count > max_count)
                {
                    max_count = alternating_phrases[phrase_toggler][i].count;
                    best_index = i;
                }
            }
        }

        if (best_index != -1)
        {
            best.len = alternating_phrases[phrase_toggler][best_index].len;
            best.count = alternating_phrases[phrase_toggler][best_index].count;
            for (int i=0; i<phrase_len;i++)
            {
                best.phrase[i] = alternating_phrases[phrase_toggler][best_index].phrase[i];
            }
        }
        if (PHRASE_OPTIMIZER != 2)
        {
            phrase_toggler=(phrase_toggler+1)%2;
        }
        return best;
    }
    void abstract_reset_buffer(abstract_buffer ubuffer, abstract_buffer obuffer)
    {
        ubuffer.len = obuffer.len;
        ubuffer.phrase_count = obuffer.phrase_count;
        abstract_data[] data = ubuffer.data;
        int i;
        for (i=0;i<obuffer.len;i++)
        {
            data[i].type = obuffer.data[i].type;
            data[i].ENCODED_code = obuffer.data[i].ENCODED_code;
            data[i].bit_length_ENCODED = obuffer.data[i].bit_length_ENCODED;
            data[i].RLE_code = obuffer.data[i].RLE_code;
            data[i].bit_length_RLE = obuffer.data[i].bit_length_RLE;
            data[i].count = obuffer.data[i].count;
            data[i].original_data = obuffer.data[i].original_data;
            data[i].phrase_used = obuffer.data[i].phrase_used;
            data[i].length_in_abstract_data_elements_of_single_element = obuffer.data[i].length_in_abstract_data_elements_of_single_element;
        }
        for (i=0;i<PHRASES_MAX;i++)
        {
            if (obuffer.phrases[i].len != 0)
            {
                int j;
                for (j=0;j<obuffer.phrases[i].len; j++)
                {
                    ubuffer.phrases[i].phrase[j] = obuffer.phrases[i].phrase[j];
                }
            }
            ubuffer.phrases[i].len=obuffer.phrases[i].len;
            ubuffer.phrases[i].count=obuffer.phrases[i].count;
        }

        for (i=0;i<256+PHRASES_MAX;i++)
        {
            ubuffer.codes_used_array[i] = obuffer.codes_used_array[i];
            ubuffer.map[i]=obuffer.map[i];
            ubuffer.code[i].bit_count = obuffer.code[i].bit_count;
            ubuffer.code[i].code = obuffer.code[i].code;
        }
        ubuffer.different_codes_used = obuffer.different_codes_used;
    }
    void abstract_apply_phrase(abstract_buffer abuffer, phrase aphrase)
    {
        int phrase_count = abuffer.phrase_count;
        if (phrase_count >= PHRASES_MAX)
        {
            return;
        }
        abuffer.phrase_count++;

        for (int i=0; i<aphrase.len; i++)
        {
            abuffer.phrases[phrase_count].phrase[i] = aphrase.phrase[i];
        }
        abuffer.phrases[phrase_count].count = 0;
        abuffer.phrases[phrase_count].len = aphrase.len;
        abstract_data[] data = abuffer.data;

        // now scan data for phrase
        // only for original data for now
        int data_pointer=0;
        while (data_pointer < abuffer.len)
        {
            int j = 0;
            int search_start = data_pointer;
            while ((data_pointer < abuffer.len) && (j < aphrase.len))
            {
                if (data[data_pointer].type != VALID_BYTE)
                {
                    break;
                }
                if ((data[data_pointer].original_data&0xff) == (aphrase.phrase[j]&0xff ))
                {
                   j++;
                   data_pointer++;
                   continue;
                }
                break;
            }
            if (j == aphrase.len)
            {
                //printf(" \n Phrase found at: %i \n", search_start);
                // phrase found
                j = 0;
                data_pointer = search_start;
                while (j < aphrase.len)
                {
                    if (j == 0)
                    {
                        data[data_pointer].type = VALID_PHRASE;
                        data[data_pointer].phrase_used = phrase_count;
                        data[data_pointer].length_in_abstract_data_elements_of_single_element = aphrase.len;
                        abuffer.phrases[phrase_count].count++;
                        //printf("# Phrase used: %i, length: %i \n", data[data_pointer].phrase_used, data[data_pointer].length_in_abstract_data_elements_of_single_element);
                    }
                    else
                    {
                        data[data_pointer].type = INVALID;
                    }
                    j++;
                    data_pointer++;
                }
                data_pointer--;
            }
            data_pointer++;
        }

        // correct map, code, codes_used_array
        for (int i=0;i < aphrase.len; i++)
        {
            int current_code = aphrase.phrase[i];
            abuffer.codes_used_array[current_code] -= (abuffer.phrases[phrase_count].count-1);
        }
        abuffer.codes_used_array[256+phrase_count] = aphrase.len * abuffer.phrases[phrase_count].count;
        abuffer.different_codes_used++;

        int[] bytes_used_array;
        bytes_used_array = new int [256+PHRASES_MAX];

       // fill map start
        int map_count = 0;
        for (int i=0;i<256+PHRASES_MAX;i++)
        {
            abuffer.map[i]=-1;
            bytes_used_array[i] = abuffer.codes_used_array[i];
        }
        int remember = -1;
        while (map_count < 256 + PHRASES_MAX)
        {
            int most = -1;
            for (int i=0;i<256+PHRASES_MAX ;i++)
            {
               if (bytes_used_array[i] >= most)
               {
                   most = bytes_used_array[i];
                   remember = i;
               }
            }
            abuffer.map[map_count] = remember;
            bytes_used_array[remember] = -2;
            map_count++;
        }
    }
    phrase abstract_get_best_single_phrase(abstract_buffer abuffer)
    {
        phrase phrase_to_remember = new phrase();
        phrase_to_remember.len = 0;
        abstract_buffer local_buffer;
        local_buffer = abstract_clone(abuffer);
        int used_bits_without_phrase = get_bits_used_from_abstract_complete(local_buffer);
        int minimum_bits_so_far = used_bits_without_phrase;

        int phrase_len;
        String message = "Testing phrase with len: ";
        alternating_phrases[0] = null;
        alternating_phrases[1] = null;
        phrase_toggler=0;
        for (phrase_len=MIN_PHRASE_LEN; phrase_len<MAX_PHRASE_LEN;phrase_len++)
        {
            message += " "+ phrase_len+" ";
            phrase best_phrase = abstract_get_best_phrase_used_more_than_once(local_buffer, phrase_len);
            if (best_phrase.len == 0)
                continue;
            abstract_apply_phrase(local_buffer, best_phrase);
            if (SHANNON)
                abstract_Shannon(local_buffer);
            if (RLE_USED)
                abstract_RLE(local_buffer);
            int used_bits = get_bits_used_from_abstract_complete(local_buffer);
            if (minimum_bits_so_far>used_bits)
            {
                minimum_bits_so_far=used_bits;
                phrase_to_remember.len = best_phrase.len;
                phrase_to_remember.count = best_phrase.count;
                int i;
                for (i=0; i< best_phrase.len; i++)
                {
                     phrase_to_remember.phrase[i] = best_phrase.phrase[i];
                }
            }
            abstract_reset_buffer(local_buffer, abuffer);
        }
        delete_abstract(local_buffer);
        message += " "+ phrase_len+" ";
        tl.printMessageSU(message);
        return phrase_to_remember;
    }
    void abstract_search_insert_phrases(abstract_buffer abuffer)
    {
        abstract_buffer local_buffer = abstract_clone(abuffer);
        if (SHANNON)
            abstract_Shannon(local_buffer);
        if (RLE_USED)
            abstract_RLE(local_buffer);
        int used_bits = get_bits_used_from_abstract_complete(local_buffer);
        tl.printMessageSU("Non Phrase: Reg: "+current_working_register+", bytes used: "+(7+used_bits)/8);
        delete_abstract(local_buffer);

        phrase[] phrases= new phrase[PHRASES_MAX];
        int phrases_depth;
        for (phrases_depth=0;phrases_depth<PHRASES_MAX_DEPTH;phrases_depth++)
        {
            phrase aphrase = abstract_get_best_single_phrase(abuffer);
            if (aphrase.len == 0)
            {
                tl.printWarningSU("No phrase found!");
                continue;
            }
            phrases[phrases_depth].len = aphrase.len;
            phrases[phrases_depth].count = aphrase.count;
            int i;
            for (i=0;i<aphrase.len;i++)
            {
                phrases[phrases_depth].phrase[i] = aphrase.phrase[i];
            }
            abstract_apply_phrase(abuffer, aphrase);

            local_buffer = abstract_clone(abuffer);
            if (SHANNON)
                abstract_Shannon(local_buffer);
            if (RLE_USED)
                abstract_RLE(local_buffer);
            used_bits = get_bits_used_from_abstract_complete(local_buffer);
            delete_abstract(local_buffer);
            tl.printMessageSU("Last result of test: Reg: "+current_working_register +", Depth: "+phrases_depth+", phrase_len: "+aphrase.len+", bytes used: "+(7+used_bits)/8);
        }
    }
    void abstract_search_insert_phrases_optimal(abstract_buffer abuffer)
    {
        abstract_buffer local_buffer = abstract_clone(abuffer);
        if (SHANNON)
            abstract_Shannon(local_buffer);
        if (RLE_USED)
            abstract_RLE(local_buffer);
        phrase aphrase;
        int used_bits_last;
        int used_bits = get_bits_used_from_abstract_complete(local_buffer);
        int best_used = used_bits;
        tl.printMessageSU("Non Phrase: Reg: "+current_working_register+", bytes used: "+(7+used_bits)/8);
        int phrases_depth = 0;
        int phrase_used = 0;

        delete_abstract(local_buffer);
        do
        {
            used_bits_last = used_bits;
            aphrase = abstract_get_best_single_phrase(abuffer);
            if (aphrase.len == 0)
            {
                tl.printWarningSU("No phrase found!");
                continue;
            }

            local_buffer = abstract_clone(abuffer);
            abstract_apply_phrase(local_buffer, aphrase);
            if (SHANNON)
                abstract_Shannon(local_buffer);
            if (RLE_USED)
                abstract_RLE(local_buffer);
            used_bits = get_bits_used_from_abstract_complete(local_buffer);
            delete_abstract(local_buffer);
            if (used_bits<used_bits_last)
            {
                abstract_apply_phrase(abuffer, aphrase);
                tl.printMessageSU("Last result of test: Reg: "+current_working_register +", Depth: "+phrases_depth+", phrase_len: "+aphrase.len+", bytes used: "+(7+used_bits)/8);
                best_used = used_bits;
                phrase_used = 1;
            }
            phrases_depth++;
        }
        while ((used_bits<used_bits_last) &&(phrases_depth<PHRASES_MAX));
        if (phrase_used == 1)
            tl.printMessageSU("Optimum reached: Reg: "+current_working_register+", Depth: "+phrases_depth+", phrase_len: "+aphrase.len+", bytes used: "+ (7+best_used)/8);
        else
            tl.printMessageSU("Optimum reached: Reg: "+current_working_register+", bytes used: "+(7+best_used)/8+" (no phrase used) ");
    }
    void print_abstract(abstract_buffer abuffer)
    {
        int i;
        for (i=0;i<abuffer.len;i++)
        {
            System.out.println(""+i+".--- ");
            System.out.println("type      :%s "+ type_string[abuffer.data[i].type]);
            System.out.println("count     :%i "+ abuffer.data[i].count);
            System.out.println("odata     :%i "+ (abuffer.data[i].original_data&0xff) );
            System.out.println("phrase    :%i "+ abuffer.data[i].phrase_used);
            System.out.println("data_len  :%i "+ abuffer.data[i].length_in_abstract_data_elements_of_single_element);
        }
        System.out.println("");
        System.out.println("Other abstract data: ");
        System.out.println("len        :%i "+ abuffer.len);
        System.out.println("#phrases   :%i "+ abuffer.phrase_count);
        System.out.println("codes used :%i "+ abuffer.different_codes_used);
        System.out.println("kind       :%i "+ abuffer.kind);
        System.out.println("\n");
        System.out.println("Phrases: ");
        for (i=0;i<abuffer.phrase_count;i++)
        {
            int j;
            System.out.println("Phrase "+i+": ");
            for (j=0;j<abuffer.phrases[i].len; j++)
            {
                System.out.println(""+abuffer.phrases[i].phrase[j]+" ");
            }
            System.out.println(" ");
        }

    }

    //////////////////////////////////////
    //////// ABSTRACT.C - END ////////////
    //////////////////////////////////////

    public static boolean dontShanonSingleByteUsages = true;
    public static boolean enableAmlitude5thBit = false;
}
