/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx.cartridge;

import de.malban.config.Configuration;
import de.malban.gui.panels.LogPanel;
import static de.malban.gui.panels.LogPanel.INFO;

/**
 *
 * @author Thomas
 */
public class VFCompress {
    LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
    final int MAX_16K_BANKS = (32+2);
    public final static int CRC_SEED       =     0x56344542;     // V4EB
    final int BACKREFERENCESIZE =   0x1000;


    byte data[] = new byte[16*1024*MAX_16K_BANKS];
    public byte dzipdata[] = new byte[16*1024*MAX_16K_BANKS];
    public int dzipdata_size;
    public long  dzipdata_crc;
    byte header[] = new byte[4+2+MAX_16K_BANKS*6];

        /* Current run */
    int run_start;
    int run_length;
    int count_run;
    int match_offset, match_length, map_pos;
    byte map[];
    int in_bytes, out_bytes;
    int bytes_remaining;
    int count_short_match;
    int count_long_match;
    byte mapout[];
    int mapOutCounter = 0;
    
    
    void resetValues()
    {
     run_start = 0;
     run_length = 0;
     count_run = 0;
     match_offset = 0;
     match_length = 0;
     map_pos = 0;
     in_bytes = 0; 
     out_bytes = 0;
     bytes_remaining = 0;
     count_short_match = 0;
     count_long_match = 0;
    byte mapout[];
    byte map[];
    }
    
    int currentBankMax = 0;
    public void compressData(byte[] d, int bankSize)
    {
         currentBankMax = bankSize;
         resetValues();
         data = new byte[bankSize];
         dzipdata = new byte[bankSize*2]; // out can be larger than in
         
         int maxSize = d.length;
         
         if (maxSize>bankSize) maxSize = bankSize;
         for (int i=0;i<maxSize; i++)
         {
             data[i] = d[i];
         }
         
         int decode_crc = CRC_SEED;
         dzipdata_size = mydzip(dzipdata, data, maxSize);
         dzipdata_crc  = mycrc32(decode_crc, dzipdata, dzipdata_size);
         
//         log.addLog("// bank 0, crc "+dzipdata_crc+", size "+dzipdata_size, INFO);
    }

/*
    
    int main(int argc, char *argv[]) {
        FILE *rom;
        int romsize = 0, loop, r, k;
        assert(sizeof(unsigned int)==4);


         
         



            while (size > 0) {
                int banksize = (size>0x4000) ? 0x4000 : size;
                size -= banksize;
                dzipdata_size[no_banks] = mydzip(dzipdata+compressedsize, data+no_banks*0x8000, banksize);
                dzipdata_crc[no_banks] = mycrc32(decode_crc, dzipdata+compressedsize, dzipdata_size[no_banks]);
                printf("// bank %i, crc 0x%x, size 0x%x\n",no_banks, dzipdata_crc[no_banks], dzipdata_size[no_banks]);

                compressedsize += dzipdata_size[no_banks];
                no_banks++;
            }
            printf("// no_banks %i, v4e_size %i (0x%x)\n", no_banks, 8+no_banks*6+compressedsize, 8+no_banks*6+compressedsize);

            int index=0;
            header[index++] = 'V';          // 0 header
            header[index++] = '4';
            header[index++] = 'E';
            header[index++] = 'B';

            int cart_type = 7;
            header[index++] = (cart_type>> 8)&0xff;      // 4
            header[index++] = (cart_type    )&0xff;

            header[index++] = (no_banks>> 8)&0xff;      // 4
            header[index++] = (no_banks    )&0xff;

            header[index++] = (dzipdata_32k_crc>>24)&0xff;   // 6
            header[index++] = (dzipdata_32k_crc>>16)&0xff;
            header[index++] = (dzipdata_32k_crc>> 8)&0xff;
            header[index++] = (dzipdata_32k_crc    )&0xff;

            header[index++] = (dzipdata_32k_size>> 8)&0xff;  // 10
            header[index++] = (dzipdata_32k_size    )&0xff;

            for (loop=1;loop<no_banks;loop++) {
                header[index++] = (dzipdata_crc[loop]>>24)&0xff;   // 6
                header[index++] = (dzipdata_crc[loop]>>16)&0xff;
                header[index++] = (dzipdata_crc[loop]>> 8)&0xff;
                header[index++] = (dzipdata_crc[loop]    )&0xff;

                header[index++] = (dzipdata_size[loop]>> 8)&0xff;  // 10
                header[index++] = (dzipdata_size[loop]    )&0xff;
            }

            FILE *psgfile = fopen("CART.V4E","w+");
            if (psgfile != 0) {
                fwrite(header, 8+no_banks*6,1, psgfile);                
                fwrite(dzipdata, compressedsize, 1, psgfile);
                fclose (psgfile);
            }
        } else {
            printf("// ERROR: unable to open file..\n");
        } 
    }


*/

    
    int mydzip(byte[] dest, byte[] source, int size)
    {
        mapOutCounter = 0;
        
        
        
        bytes_remaining = size;
        map = new byte[source.length];
        for (int i=0;i<source.length;i++)
        {
            map[i] = source[i];
        }
        mapout = dest;

        run_start = run_length = 0;
        match_offset = match_length = 0;
        map_pos = 0;
        
        /* reset stats */
        in_bytes = out_bytes = 0;
        count_run = count_short_match = count_long_match = 0;
        while (bytes_remaining > 0) 
        {

            find_match(map_pos);
            
            
            
            /* short offset run > 2 bytes always worth doing */
            if (match_offset >= -128) 
            {
                if (match_length > 2
                    /* or 2 bytes, and not already in a run */
                    || (match_length == 2 && run_length == 0)) 
                {
                    dump_match();
                    continue;
                }
            }
            /* long offset run > 3 bytes always worth doing */
            if (match_length > 3
                /* or 3 bytes, and not already in a run */
                || (match_length == 3 && run_length == 0)) 
            {
                dump_match();
                continue;
            }
            /* if already in a run, continue it */
            if (run_length > 0) {
                run_length++;
                map_pos++;
                in_bytes++;
                bytes_remaining--;
                /* maximum run length is 128 */
                if (run_length == 128) 
                {
                    dump_run();
                }
                continue;
            }
            /* otherwise, start a run */
            run_start = map_pos;
            run_length = 1;
            map_pos++;
            in_bytes++;
            bytes_remaining--;
        }
        dump_run();
        return out_bytes;
    }
    void dzipOut(byte data) 
    {
        try
        {
            
        mapout[mapOutCounter++] = data;
        }
        catch (Throwable e)
        {
            e.printStackTrace();
        }
    }


    void dump_run() 
    {
            if (run_length == 0)
                    return;
            int i;
            count_run++;
            dzipOut((byte) (128 - run_length));
            for (i = 0; i < run_length; i++) {
                    dzipOut(map[run_start + i]);
            }
            out_bytes += run_length + 1;
            run_length = run_start = 0;
    }

    void dump_match() 
    {
            dump_run();
            if (match_offset >= -128 && match_length <= 128) {
                    count_short_match++;
                    dzipOut((byte)(match_offset & 0xff));
                    dzipOut((byte)(128 - match_length));
                    out_bytes += 2;
            } else {
                    count_long_match++;
                    dzipOut((byte) (((match_offset >> 7) & 0x7f) | 0x80));
                    dzipOut((byte) ((match_offset & 0x7f) | 0x80));
                    dzipOut((byte) ((384 - match_length) & 0xff));
                    out_bytes += 3;
            }
            map_pos += match_length;
            in_bytes += match_length;
            bytes_remaining -= match_length;
    }

    /* check possible length of match at 'from' */
    int count_match_length(int from, int to) {
            int length = 0;
            while (length < 256) {
                    if (length >= bytes_remaining)
                            return length;
                    if (map[from] != map[to])
                            return length;
                    from++;
                    to++;
                    length++;
            }
            return length;
    }

    /* find best match */
    void find_match(int to) {
            match_length = 0;
            /* work backwards: even if an extra byte is used for offset (further
             * back), a longer run exceeding the best so far will be at least as
             * efficient */
            int f;
            for (f = 1; f <= BACKREFERENCESIZE; f++) 
            {
                    if (f > to)
                            return;
                    int l = count_match_length(to - f, to);
                    if (l > match_length) 
                    {
                            match_length = l;
                            match_offset = -f;
                    }
            }
    }


    /*-
     *  COPYRIGHT (C) 1986 Gary S. Brown.  You may use this program, or
     *  code or tables extracted from it, as desired without restriction.
     *
     *  First, the polynomial itself and its table of feedback terms.  The
     *  polynomial is
     *  X^32+X^26+X^23+X^22+X^16+X^12+X^11+X^10+X^8+X^7+X^5+X^4+X^2+X^1+X^0
     *
     *  Note that we take it "backwards" and put the highest-order term in
     *  the lowest-order bit.  The X^32 term is "implied"; the LSB is the
     *  X^31 term, etc.  The X^0 term (usually shown as "+1") results in
     *  the MSB being 1
     *
     *  Note that the usual hardware shift register implementation, which
     *  is what we're using (we're merely optimizing it by doing eight-bit
     *  chunks at a time) shifts bits into the lowest-order term.  In our
     *  implementation, that means shifting towards the right.  Why do we
     *  do it this way?  Because the calculated CRC must be transmitted in
     *  order from highest-order term to lowest-order term.  UARTs transmit
     *  characters in order from LSB to MSB.  By storing the CRC this way
     *  we hand it to the UART in the order low-byte to high-byte; the UART
     *  sends each low-bit to hight-bit; and the result is transmission bit
     *  by bit from highest- to lowest-order term without requiring any bit
     *  shuffling on our part.  Reception works similarly
     *
     *  The feedback terms table consists of 256, 32-bit entries.  Notes
     *
     *      The table can be generated at runtime if desired; code to do so
     *      is shown later.  It might not be obvious, but the feedback
     *      terms simply represent the results of eight shift/xor opera
     *      tions for all combinations of data and CRC register values
     *
     *      The values must be right-shifted by eight bits by the "updcrc
     *      logic; the shift must be unsigned (bring in zeroes).  On some
     *      hardware you could probably optimize the shift in assembler by
     *      using byte-swap instructions
     *      polynomial $edb88320
     *
     *
     * CRC32 code derived from work by Gary S. Brown.
     */

    static final int crc32_tab[] = {
            0x00000000, 0x77073096, 0xee0e612c, 0x990951ba, 0x076dc419, 0x706af48f,
            0xe963a535, 0x9e6495a3,	0x0edb8832, 0x79dcb8a4, 0xe0d5e91e, 0x97d2d988,
            0x09b64c2b, 0x7eb17cbd, 0xe7b82d07, 0x90bf1d91, 0x1db71064, 0x6ab020f2,
            0xf3b97148, 0x84be41de,	0x1adad47d, 0x6ddde4eb, 0xf4d4b551, 0x83d385c7,
            0x136c9856, 0x646ba8c0, 0xfd62f97a, 0x8a65c9ec,	0x14015c4f, 0x63066cd9,
            0xfa0f3d63, 0x8d080df5,	0x3b6e20c8, 0x4c69105e, 0xd56041e4, 0xa2677172,
            0x3c03e4d1, 0x4b04d447, 0xd20d85fd, 0xa50ab56b,	0x35b5a8fa, 0x42b2986c,
            0xdbbbc9d6, 0xacbcf940,	0x32d86ce3, 0x45df5c75, 0xdcd60dcf, 0xabd13d59,
            0x26d930ac, 0x51de003a, 0xc8d75180, 0xbfd06116, 0x21b4f4b5, 0x56b3c423,
            0xcfba9599, 0xb8bda50f, 0x2802b89e, 0x5f058808, 0xc60cd9b2, 0xb10be924,
            0x2f6f7c87, 0x58684c11, 0xc1611dab, 0xb6662d3d,	0x76dc4190, 0x01db7106,
            0x98d220bc, 0xefd5102a, 0x71b18589, 0x06b6b51f, 0x9fbfe4a5, 0xe8b8d433,
            0x7807c9a2, 0x0f00f934, 0x9609a88e, 0xe10e9818, 0x7f6a0dbb, 0x086d3d2d,
            0x91646c97, 0xe6635c01, 0x6b6b51f4, 0x1c6c6162, 0x856530d8, 0xf262004e,
            0x6c0695ed, 0x1b01a57b, 0x8208f4c1, 0xf50fc457, 0x65b0d9c6, 0x12b7e950,
            0x8bbeb8ea, 0xfcb9887c, 0x62dd1ddf, 0x15da2d49, 0x8cd37cf3, 0xfbd44c65,
            0x4db26158, 0x3ab551ce, 0xa3bc0074, 0xd4bb30e2, 0x4adfa541, 0x3dd895d7,
            0xa4d1c46d, 0xd3d6f4fb, 0x4369e96a, 0x346ed9fc, 0xad678846, 0xda60b8d0,
            0x44042d73, 0x33031de5, 0xaa0a4c5f, 0xdd0d7cc9, 0x5005713c, 0x270241aa,
            0xbe0b1010, 0xc90c2086, 0x5768b525, 0x206f85b3, 0xb966d409, 0xce61e49f,
            0x5edef90e, 0x29d9c998, 0xb0d09822, 0xc7d7a8b4, 0x59b33d17, 0x2eb40d81,
            0xb7bd5c3b, 0xc0ba6cad, 0xedb88320, 0x9abfb3b6, 0x03b6e20c, 0x74b1d29a,
            0xead54739, 0x9dd277af, 0x04db2615, 0x73dc1683, 0xe3630b12, 0x94643b84,
            0x0d6d6a3e, 0x7a6a5aa8, 0xe40ecf0b, 0x9309ff9d, 0x0a00ae27, 0x7d079eb1,
            0xf00f9344, 0x8708a3d2, 0x1e01f268, 0x6906c2fe, 0xf762575d, 0x806567cb,
            0x196c3671, 0x6e6b06e7, 0xfed41b76, 0x89d32be0, 0x10da7a5a, 0x67dd4acc,
            0xf9b9df6f, 0x8ebeeff9, 0x17b7be43, 0x60b08ed5, 0xd6d6a3e8, 0xa1d1937e,
            0x38d8c2c4, 0x4fdff252, 0xd1bb67f1, 0xa6bc5767, 0x3fb506dd, 0x48b2364b,
            0xd80d2bda, 0xaf0a1b4c, 0x36034af6, 0x41047a60, 0xdf60efc3, 0xa867df55,
            0x316e8eef, 0x4669be79, 0xcb61b38c, 0xbc66831a, 0x256fd2a0, 0x5268e236,
            0xcc0c7795, 0xbb0b4703, 0x220216b9, 0x5505262f, 0xc5ba3bbe, 0xb2bd0b28,
            0x2bb45a92, 0x5cb36a04, 0xc2d7ffa7, 0xb5d0cf31, 0x2cd99e8b, 0x5bdeae1d,
            0x9b64c2b0, 0xec63f226, 0x756aa39c, 0x026d930a, 0x9c0906a9, 0xeb0e363f,
            0x72076785, 0x05005713, 0x95bf4a82, 0xe2b87a14, 0x7bb12bae, 0x0cb61b38,
            0x92d28e9b, 0xe5d5be0d, 0x7cdcefb7, 0x0bdbdf21, 0x86d3d2d4, 0xf1d4e242,
            0x68ddb3f8, 0x1fda836e, 0x81be16cd, 0xf6b9265b, 0x6fb077e1, 0x18b74777,
            0x88085ae6, 0xff0f6a70, 0x66063bca, 0x11010b5c, 0x8f659eff, 0xf862ae69,
            0x616bffd3, 0x166ccf45, 0xa00ae278, 0xd70dd2ee, 0x4e048354, 0x3903b3c2,
            0xa7672661, 0xd06016f7, 0x4969474d, 0x3e6e77db, 0xaed16a4a, 0xd9d65adc,
            0x40df0b66, 0x37d83bf0, 0xa9bcae53, 0xdebb9ec5, 0x47b2cf7f, 0x30b5ffe9,
            0xbdbdf21c, 0xcabac28a, 0x53b39330, 0x24b4a3a6, 0xbad03605, 0xcdd70693,
            0x54de5729, 0x23d967bf, 0xb3667a2e, 0xc4614ab8, 0x5d681b02, 0x2a6f2b94,
            0xb40bbe37, 0xc30c8ea1, 0x5a05df1b, 0x2d02ef8d
    };

    static public int mycrc32(int crc, byte buf[], int size)
    {
            int p = 0;

            crc = crc ^ ~0;

            while (size-- > 0)
            {
                byte t1 = (byte)(buf[p++] & 0xFF);
                int t2 = (crc ^ (t1) );
                
                byte p1 = (byte)(t2 & 0xFF);
                int p2 = (crc >>> 8); // thats the culprit - LOGICAL shift, not ARITHMETICAL!
                int p3 =      crc32_tab[p1& 0xFF];
                crc = p2 ^ p3;
            }

            return crc ^ ~0;
    }    
    
    
    
    
    
}
