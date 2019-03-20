/***************************************************************************
                          ihxconv.c 

Intel Hex to WAV and Basic conversion for Sharp pocket computers

                             -------------------
    begin                : 2003.04.17
    copyright            : (C) 2003 by Edgar Puehringer
    email                : edgar_pue@yahoo.com
 ***************************************************************************/

/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/

#include "ihxconv.h"

#include <stdlib.h>
#include <string.h>

#define BUF_SIZE 512

typedef struct sline *Srcptr;

typedef struct sline {
  char *line;
  Srcptr next;
} Srcline;


int g_addr;
int g_len;
int g_pos;
int g_start;
int g_inc;

Srcptr g_head;
Srcptr g_cur;

int g_sum;
int g_sc;

void dumpbasic(FILE * srcfile, FILE * outfile);
void dumpcompact(FILE * srcfile, FILE * outfile);
void dumpstub1(FILE * srcfile, FILE * outfile);
void dumpstub2(FILE * srcfile, FILE * outfile);
void wavout(FILE * srcfile, FILE * outfile, int length, int oldwav);

void write1(FILE * outfile, unsigned char b, int oldwav);
void write1byte(FILE * outfile, unsigned char b, int oldwav);
void printW1(FILE * outfile);
void resetsum();
void writesum(FILE * outfile, int oldwav);

int aton(ch)
unsigned char ch;
{
  int n;
    
  if (ch < 0x3A) n = ch-0x30;
    else n = ch-0x37;
  return n;
}


/**
 * Load all lines into a linked list.
 * The first element of the list is a dummy
 * element to avoid special handling of empty lists 
 * @return the number of bytes 
 */
int preload(FILE * srcfile) {
  int len = 0;
  char buf[BUF_SIZE];
  Srcptr p, cur = NULL;

  strcpy(buf, "dummy");
  do {
    p = malloc(sizeof(Srcline));
    if (p) {
      p->next = NULL;
      p->line = strdup(buf);
      if (!p->line) {
        free(p);
        p = NULL;
      }
    }
    if (!p) {
      fprintf(stderr, "Out of memory");
      break;
    }
    if (cur) cur->next = p;
      else g_head = p;
    cur    = p;
    
    if (buf[0] == ':' && strlen(buf) >= 3) {
      len += (16*aton(buf[1])+aton(buf[2]));
    }
  } while (fgets(buf, BUF_SIZE-1, srcfile) != NULL);

  g_cur  = g_head;

  return len;
}


int getByte() {
  int ch, addr;
  char *buf;

  while (g_pos >= g_len) {
    if (g_cur) g_cur = g_cur->next;
    if (!g_cur) return EOF;
    buf = g_cur->line;
    if (buf[0] != ':') continue;
    if (strlen(buf) < 11) {
      fprintf(stderr, "Line to short: %s\n", buf);
      return EOF;
    }
    g_len = 16*aton(buf[1])+aton(buf[2]);
    if (strlen(buf) < 2*g_len+11) {
      g_len = 0;
      fprintf(stderr, "Line size doesn't match: %s\n", buf);
      return EOF;
    }
    if (g_len == 0) continue;
    addr = 16*16*16*aton(buf[3])+16*16*aton(buf[4])+16*aton(buf[5])+aton(buf[6]);
    if (g_addr < 0) g_addr = addr;
    if (addr != g_addr) {
      g_len = 0;
      fprintf(stderr, "Address gap detected (should be %x): %s\n", g_addr, buf);
      return EOF;
    }
    g_pos = 0;
  }

  buf = g_cur->line;

  ch = 16*aton(buf[2*g_pos+9])+aton(buf[2*g_pos+10]);
  g_pos++;
  g_addr++;
  
  return ch;
}


int ihxconv(FILE * srcfile, FILE * outfile, int mode) {
  int len;
  Srcptr p;

  g_addr  = -1;
  g_start = 10;
  g_inc   = 10;
  g_len   = 0;
  g_pos   = 0;

  len = preload(srcfile);
  switch (mode) {
    case MODE_WAV_OLD:
      wavout(srcfile, outfile, len, mode);
    break;
    case MODE_WAV_NEW:
      wavout(srcfile, outfile, len, mode);
    break;
    case MODE_COMPACT_STUB:
      dumpstub2(srcfile, outfile);
    case MODE_COMPACT_STD:
      dumpcompact(srcfile, outfile);
    break;
    case MODE_BASIC_STUB:
      dumpstub1(srcfile, outfile);
    case MODE_BASIC_STD:
      dumpbasic(srcfile, outfile);
    break;
    default:
    break;
  }

  while (g_head) {
    p      = g_head;
    g_head = g_head->next;
    free(p->line);
    free(p);
  }
    
  return 0;
} 


void dumpbasic(FILE * srcfile, FILE * outfile) {
  int cols   = 0;
  int sadr   = 0;
  int eadr   = 0; // the next unused adress
  int chksum = 0;
  int ch;

  fprintf(outfile, "%d REM ** IHXCONV **\n", g_start);
  g_start += g_inc;
  ch       = getByte();
  if (ch != EOF) sadr = g_addr-1;
  while (ch != EOF) {
    if (cols == 0) {
      fprintf(outfile, "%d DATA ", g_start);
      g_start += g_inc;
    }
    else {
      fprintf(outfile, ",");
    }
    chksum += ch;
    fprintf(outfile, "%d", ch);
    cols++;
    if (cols >= 17) {
      fprintf(outfile, "\n");
      cols = 0;
    }
    ch = getByte();
  }
  eadr = g_addr;
  if (cols != 0) fprintf(outfile, "\n");
  fprintf(outfile, "%d A=%d:B=%d:C=%d:RETURN\n", g_start, sadr, eadr-sadr, chksum);
}


void dumpcompact(FILE * srcfile, FILE * outfile) {
  int cols   = 0;
  int sadr   = 0;
  int eadr   = 0; // the next unused adress
  int chksum = 0;
  int ch;

  ch = getByte();
  if (ch != EOF) sadr = g_addr-1;  
  while (ch != EOF) {
    if (cols == 0) {
      fprintf(outfile, "%d DATA \"", g_start);
      g_start += g_inc;
    }
    chksum += ch;
    fprintf(outfile, "%02x", ch);
    cols++;
    if (cols >= 32) {
      fprintf(outfile, "\"\n");
      cols = 0;
    }
    ch = getByte();
  }
  eadr = g_addr;
  if (cols != 0) fprintf(outfile, "\"\n");
  fprintf(outfile, "%d A=%d:B=%d:C=%d:RETURN\n", g_start, sadr, eadr-sadr, chksum);
}


void dumpstub1(FILE * srcfile, FILE * outfile) {
  int tagadr;

  fprintf(outfile, "%d REM ** IHXCONV **\n", g_start); 
  g_start += g_inc;
  tagadr   = g_start;
  fprintf(outfile, "%d GOSUB \"%d\":B=A+B-1:RESTORE \"%d\"\n", g_start, tagadr, tagadr);
  g_start += g_inc;
  fprintf(outfile, "%d FOR I=A TO B:READ J:POKE I,J:NEXT I:END\n", g_start);
  g_start += g_inc;
  fprintf(outfile, "%d \"%d\" REM START OF DATA SECTION\n", g_start, tagadr);
  g_start += g_inc;
}


void dumpstub2(FILE * srcfile, FILE * outfile) {
  int tagadr;

  fprintf(outfile, "%d REM ** IHXCONV **\n", g_start); 
  g_start += g_inc;
  fprintf(outfile, "%d DIM BA$(0)*64:J=0\n", g_start); 
  g_start += g_inc;
  tagadr   = g_start;
  fprintf(outfile, "%d GOSUB \"%d\":B=A+B-1:RESTORE \"%d\"\n", g_start, tagadr, tagadr);
  g_start += g_inc;
  fprintf(outfile, "%d FOR I=A TO B\n", g_start);
  g_start += g_inc;
  fprintf(outfile, "%d IF J<=0 READ BA$(0):J=LEN BA$(0):K=1\n", g_start);
  g_start += g_inc;
  fprintf(outfile, "%d L=ASC MID$(BA$(0),K,1)\n", g_start);
  g_start += g_inc;
  fprintf(outfile, "%d IF L<58 LET L=L-48\n", g_start);
  g_start += g_inc;
  fprintf(outfile, "%d IF L>96 LET L=L-87\n", g_start);
  g_start += g_inc;
  fprintf(outfile, "%d POKE I,16*L:L=ASC MID$(BA$(0),K+1,1)\n", g_start);
  g_start += g_inc;
  fprintf(outfile, "%d IF L<58 LET L=L-48\n", g_start);
  g_start += g_inc;
  fprintf(outfile, "%d IF L>96 LET L=L-87\n", g_start);
  g_start += g_inc;
  fprintf(outfile, "%d POKE I,L+PEEK I:K=K+2:J=J-2:NEXT I:END\n", g_start);
  g_start += g_inc;
  fprintf(outfile, "%d \"%d\" REM START OF DATA SECTION\n", g_start, tagadr);
  g_start += g_inc;
}


void wavout(FILE * srcfile, FILE * outfile, int length, int mode) {	
  unsigned int wl;
  int ch, i, sadr, l;
  int oldwav = (mode == MODE_WAV_OLD);

  if (oldwav) {
    wl = (length+19+(int)(length/8))*19*16+0x400*16;
    // header(ID,filename,addr,etc)+footer($f0)
    // lead
  }
  else {
    wl = (length+22+(int)(length/120))*16*16+0x400*16;
    // header(ID,filename,addr,etc)+footer($ff,$ff,chksum)
    // lead
  }
  //  $w1="\xff\x00\xff\x00\xff\x00\xff\x00\xff\x00\xff\x00\xff\x00\xff\x00";
  //  $w0="\xff\xff\x00\x00\xff\xff\x00\x00\xff\xff\x00\x00\xff\xff\x00\x00";
  g_sum = 0;
  g_sc  = 0;

  fputs("RIFF", outfile);
  wl = wl +44-4;		// all(header:44+$wl) - 4
  fputc((unsigned char)(wl&0xff), outfile);
  fputc((unsigned char)((wl>>8)&0xff), outfile);
  fputc((unsigned char)((wl>>16)&0xff), outfile);
  fputc((unsigned char)((wl>>24)&0xff), outfile);
  wl = wl -44+4;
  fputs("WAVEfmt ", outfile);
  fputc('\x10', outfile);
  fputc('\x00', outfile);
  fputc('\x00', outfile);
  fputc('\x00', outfile);

  fputc('\x01', outfile);
  fputc('\x00', outfile);		// PCM

  fputc('\x01', outfile);
  fputc('\x00', outfile);		// mono

  fputc('\x40', outfile);
  fputc('\x1f', outfile);
  fputc('\x00', outfile);
  fputc('\x00', outfile);	        // sampling freq. = 8000Hz

  fputc('\x40', outfile);
  fputc('\x1f', outfile);
  fputc('\x00', outfile);
  fputc('\x00', outfile);	        // byte / sec.

  fputc('\x01', outfile);
  fputc('\x00', outfile);		// byte / sample x channel

  fputc('\x08', outfile);
  fputc('\x00', outfile);		// bit / sample

  fputs("data", outfile);
  fputc((unsigned char)(wl&0xff), outfile);
  fputc((unsigned char)((wl>>8)&0xff), outfile);
  fputc((unsigned char)((wl>>16)&0xff), outfile);
  fputc((unsigned char)((wl>>24)&0xff), outfile);


  for (i=0; i<0x400; i++) {
    printW1(outfile);
  }

  if (oldwav) { // 1245/125x
    write1byte(outfile, 0x26, oldwav);
  }
  else { // newer PC
    write1byte(outfile, 0x67, oldwav);
  }
 
  g_sum=0;

  if (oldwav) {
    write1(outfile, 0, oldwav);
    write1(outfile, 0, oldwav);
    write1(outfile, 0, oldwav);
    write1(outfile, 0, oldwav);
    write1(outfile, 0, oldwav);
    write1(outfile, 0, oldwav);
    write1(outfile, 0, oldwav);
    write1(outfile, 0x5f, oldwav);
    resetsum();
  }
  else {
    write1(outfile, 'I', oldwav);    // A tribute to YAGSHI
    write1(outfile, 'H', oldwav);    // (this conversion to WAV is
    write1(outfile, 'S', oldwav);    // based on his perl script
    write1(outfile, 'G', oldwav);    // 'yasm.pl'
    write1(outfile, 'A', oldwav);
    write1(outfile, 'Y', oldwav);
    write1(outfile, 0xf5, oldwav);
    write1(outfile, 0xf5, oldwav);
    writesum(outfile, oldwav);
  }

  write1(outfile, 0, oldwav);
  write1(outfile, 0, oldwav);
  write1(outfile, 0, oldwav);
  write1(outfile, 0, oldwav);
  
  ch = getByte();
  if (ch == EOF) {
    sadr = 0;
    l    = 0;
  }
  else {
    sadr = g_addr-1;
    l    = length-1;
  }

  if (oldwav) { // PC-1245/125x
    write1(outfile, sadr>>12 | (sadr>>4 &0xf0), oldwav);
    write1(outfile, (sadr<<4&0xf0) | (sadr>>4&0x0f), oldwav);
    write1(outfile, (l>>12) | (l>>4 &0xf0), oldwav);
    write1(outfile, (l<<4&0xf0) | (l>>4&0x0f), oldwav);
    resetsum();
  }
  else {
    write1(outfile, sadr>>8 & 0xff, oldwav);
    write1(outfile, sadr & 0xff, oldwav);
    write1(outfile, l>>8&0xff, oldwav);
    write1(outfile, l&0xff, oldwav);
    writesum(outfile, oldwav);
  }

  while (ch != EOF) {
    if (oldwav) {
      write1(outfile, ch, oldwav);
    }
    else {
      write1(outfile, (ch>>4&0x0f) | (ch<<4&0xf0), oldwav);
    }
    ch = getByte();
  } // end while
 
  if (oldwav) { // PC-1245/125x
    write1byte(outfile, 0xf0, oldwav);
  }
  else {
    g_sc = 0;
    write1(outfile, 0xff, oldwav);
    wl = g_sum;
    write1(outfile, 0xff, oldwav);
    g_sum = wl;
    writesum(outfile, oldwav);
  }

}


void resetsum() {
  g_sum = 0;
  g_sc  = 0;
}


void writesum(FILE * outfile, int oldwav) {
  int tmp;

  if (!oldwav) {            // newer PC
    tmp = ((g_sum & 0x0f) << 4) + ((g_sum & 0xf0) >> 4);
    write1byte(outfile, tmp, oldwav);
    resetsum();
  }
  else {		    // PC-1245/125x
    write1byte(outfile, g_sum, oldwav);
    if (g_sc >= 80) resetsum();
  }
}


void write1(FILE * outfile, unsigned char b, int oldwav) {
  write1byte(outfile, b, oldwav);
  if (!oldwav) {
    g_sum += (b & 0xf);
    if (g_sum > 0xff) g_sum  = (g_sum + 1) & 0xff;
    g_sum = (g_sum+ (b >> 4 & 0xf)) & 0xff;
  }
  else {
    g_sum += (b & 0xf0) >> 4;
    if (g_sum > 0xff) g_sum  = (g_sum + 1) & 0xff;
    g_sum  = (g_sum + (b & 0xf)) & 0xff;
  }
  g_sc++;
  if ((g_sc % 8 == 0)   &&  oldwav) writesum(outfile, oldwav);
  if ((g_sc     >= 120) && !oldwav) writesum(outfile, oldwav);
}   


void printW0(FILE * outfile) {
  fputc('\xff', outfile);
  fputc('\xff', outfile);
  fputc('\x00', outfile);
  fputc('\x00', outfile);

  fputc('\xff', outfile);
  fputc('\xff', outfile);
  fputc('\x00', outfile);
  fputc('\x00', outfile);

  fputc('\xff', outfile);
  fputc('\xff', outfile);
  fputc('\x00', outfile);
  fputc('\x00', outfile);

  fputc('\xff', outfile);
  fputc('\xff', outfile);
  fputc('\x00', outfile);
  fputc('\x00', outfile);
}


void printW1(FILE * outfile) {
  fputc('\xff', outfile);
  fputc('\x00', outfile);
  fputc('\xff', outfile);
  fputc('\x00', outfile);

  fputc('\xff', outfile);
  fputc('\x00', outfile);
  fputc('\xff', outfile);
  fputc('\x00', outfile);

  fputc('\xff', outfile);
  fputc('\x00', outfile);
  fputc('\xff', outfile);
  fputc('\x00', outfile);

  fputc('\xff', outfile);
  fputc('\x00', outfile);
  fputc('\xff', outfile);
  fputc('\x00', outfile);
}


void write1byte(FILE * outfile, unsigned char b, int oldwav) {
  if (!oldwav) {          // newer PC
    printW0(outfile);
    if (b & 0x1) printW1(outfile); else printW0(outfile);
    if (b & 0x2) printW1(outfile); else printW0(outfile);
    if (b & 0x4) printW1(outfile); else printW0(outfile);
    if (b & 0x8) printW1(outfile); else printW0(outfile);
    printW1(outfile); printW0(outfile);
    if (b & 0x10) printW1(outfile); else printW0(outfile);
    if (b & 0x20) printW1(outfile); else printW0(outfile);
    if (b & 0x40) printW1(outfile); else printW0(outfile);
    if (b & 0x80) printW1(outfile); else printW0(outfile);
    printW1(outfile); printW1(outfile); printW1(outfile); printW1(outfile); printW1(outfile);
  } 
  else {		  // PC-1245/125x
    printW0(outfile);
    if (b & 0x10) printW1(outfile); else printW0(outfile);
    if (b & 0x20) printW1(outfile); else printW0(outfile);
    if (b & 0x40) printW1(outfile); else printW0(outfile);
    if (b & 0x80) printW1(outfile); else printW0(outfile);
    printW1(outfile); printW1(outfile); printW1(outfile); printW1(outfile); printW0(outfile);
    if (b & 0x1) printW1(outfile); else printW0(outfile);
    if (b & 0x2) printW1(outfile); else printW0(outfile);
    if (b & 0x4) printW1(outfile); else printW0(outfile);
    if (b & 0x8) printW1(outfile); else printW0(outfile);
    printW1(outfile); printW1(outfile); printW1(outfile); printW1(outfile); printW1(outfile);
  }
}
