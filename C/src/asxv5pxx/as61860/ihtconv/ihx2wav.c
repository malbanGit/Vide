/***************************************************************************
                          ihxconv.c 

Intel Hex to WAV conversion for Sharp pocket computers

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

#include <string.h>

void usage() {
  fprintf(stderr, "usage: ihx2wav [-old] [-o wavfile] [ihxfile]\n");
  exit(-1);
}


void duplicate(char * param) {
  fprintf(stderr, "duplicate parameter '%s'\n", param);
  usage();
}


void unknown(char * param) {
  fprintf(stderr, "unknown parameter '%s'\n", param);
  usage();
}


void missing() {
  fprintf(stderr, "missing file name for wavefile");
  usage();
}


void dupfile(char * param) {
  fprintf(stderr, "duplicate input file '%s'\n", param);
  usage();
}


int main(int argc, char * argv[]) {
  int mode       = MODE_WAV_NEW;
  char * wavname = NULL;
  char * srcname = NULL;
  FILE * wavfile;
  FILE * srcfile; 
  int i = 1;

  while (i < argc) {
    if (strcmp(argv[i], "-old") == 0) {
      if (mode == MODE_WAV_OLD) duplicate(argv[i]);
      mode = MODE_WAV_OLD;
    } else if (strcmp(argv[i], "-o") == 0) {
      if (wavname) duplicate(argv[i]);
      if (i == (argc - 1)) missing();
      wavname = argv[++i];
    } else if (strncmp(argv[i], "-", 1) == 0) {
      unknown(argv[i]);
    } else {
      if (srcname) dupfile(argv[i]);
      srcname = argv[i];
    }
    i++;
  }
  if (!wavname) wavname = "a.wav";
  wavfile = fopen(wavname, "wb");
  if (!wavfile) {
    perror("ihx2wav");
    exit(-2);
  }
  if (srcname) {
    srcfile = fopen(srcname, "r");
    if (!srcfile) {
      perror("ihx2wav");
      exit(-3);
    }
  }
  else {
    srcfile = stdin;
  }

  i = ihxconv(srcfile, wavfile, mode); 

  if (srcname) fclose(srcfile);  
  fclose(wavfile);
  exit(i);
}

