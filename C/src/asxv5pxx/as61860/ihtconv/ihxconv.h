/***************************************************************************
                          ihxconv.h 

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

#ifndef __IHXCONV_H__
#define __IHXCONV_H__

#include <stdio.h>

#define MODE_WAV_OLD 0
#define MODE_WAV_NEW 1
#define MODE_COMPACT_STD 2
#define MODE_COMPACT_STUB 3
#define MODE_BASIC_STD 4
#define MODE_BASIC_STUB 5

int ihxconv(FILE * srcfile, FILE * outfile, int mode); 

#endif
