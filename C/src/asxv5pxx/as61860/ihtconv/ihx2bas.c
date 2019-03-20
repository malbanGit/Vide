/***************************************************************************
                          ihxconv.c 

Intel Hex to Basic conversion for Sharp pocket computers

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
  fprintf(stderr, "usage: ihx2bas [-compact] [-nostub] [-o basfile] [ihxfile]\n");
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
  fprintf(stderr, "missing file name for basic file");
  usage();
}


void dupfile(char * param) {
  fprintf(stderr, "duplicate input file '%s'\n", param);
  usage();
}


int main(int argc, char * argv[]) {
  int mode       = MODE_BASIC_STUB;
  char * basname = NULL;
  char * srcname = NULL;
  FILE * basfile;
  FILE * srcfile; 
  int i = 1;

  while (i < argc) {
    if (strcmp(argv[i], "-compact") == 0) {
      if (mode == MODE_COMPACT_STD || mode == MODE_COMPACT_STUB) duplicate(argv[i]);
      if (mode == MODE_BASIC_STUB) mode = MODE_COMPACT_STUB;
        else mode = MODE_COMPACT_STD;
    } else if (strcmp(argv[i], "-nostub") == 0) {
      if (mode == MODE_BASIC_STD || mode == MODE_COMPACT_STD) duplicate(argv[i]);
      if (mode == MODE_BASIC_STUB) mode = MODE_BASIC_STD;
        else mode = MODE_COMPACT_STD;
    } else if (strcmp(argv[i], "-o") == 0) {
      if (basname) duplicate(argv[i]);
      if (i == (argc - 1)) missing();
      basname = argv[++i];
    } else if (strncmp(argv[i], "-", 1) == 0) {
      unknown(argv[i]);
    } else {
      if (srcname) dupfile(argv[i]);
      srcname = argv[i];
    }
    i++;
  }
  if (basname) basfile = fopen(basname, "w");
    else basfile = stdout;
  if (!basfile) {
    perror("ihx2bas");
    exit(-2);
  }
  if (srcname) {
    srcfile = fopen(srcname, "r");
    if (!srcfile) {
      perror("ihx2bas");
      exit(-3);
    }
  }
  else {
    srcfile = stdin;
  }

  i = ihxconv(srcfile, basfile, mode); 

  if (srcname) fclose(srcfile);  
  if (basfile != stdout) fclose(basfile);
  exit(i);
}
 
