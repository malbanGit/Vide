/* rabmch.c */

/*
 *  Copyright (C) 1989-2009  Alan R. Baldwin
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 *
 * Alan R. Baldwin
 * 721 Berkeley St.
 * Kent, Ohio  44240
 * 
 * ported to the Rabbit2000 by
 * Ulrich Raich and Razaq Ijoduola
 * PS Division
 * CERN
 * CH-1211 Geneva-23
 * email: Ulrich dot Raich at cern dot ch
 */

#include "asxxxx.h"
#include "rab.h"

char	*cpu	= "Rabbit 2000";
char	*dsft	= "asm";

char	imtab[3] = { 0x46, 0x56, 0x5E };
struct  preByteType preByte;
int	mchtyp;

/*
 * Opcode Cycle Definitions
 */
#define	OPCY_SDP	((char) (0xFF))
#define	OPCY_ERR	((char) (0xFE))

/*	OPCY_NONE	((char) (0x80))	*/
/*	OPCY_MASK	((char) (0x7F))	*/

#define	OPCY_CPU	((char) (0xFD))

#define	UN	((char) (OPCY_NONE | 0x00))
#define	P2	((char) (OPCY_NONE | 0x01))
#define	P3	((char) (OPCY_NONE | 0x02))
#define	P4	((char) (OPCY_NONE | 0x03))
#define	P5	((char) (OPCY_NONE | 0x04))
#define	P6	((char) (OPCY_NONE | 0x05))
#define	P7	((char) (OPCY_NONE | 0x06))

/*
 * Rabbit 2000 / 3000 Opcode Cycle Pages
 */

static char  rabpg1[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/   2, 6, 7, 2, 2, 2, 4, 2, 2, 2, 6, 2, 2, 2, 4, 2,
/*10*/   5, 6, 7, 2, 2, 2, 4, 2, 5, 2, 6, 2, 2, 2, 4, 2,
/*20*/   5, 6,13, 2, 2, 2, 4, 4, 5, 2,11, 2, 2, 2, 4, 2,
/*30*/   5, 6,10, 2, 8, 8, 7, 2, 5, 2, 9, 2, 2, 2, 4, 2,
/*40*/   2, 2, 2, 2, 2, 2, 5, 2, 2, 2, 2, 2, 2, 2, 5, 2,
/*50*/   2, 2, 2, 2, 2, 2, 5, 2, 2, 2, 2, 2, 2, 2, 5, 2,
/*60*/   2, 2, 2, 2, 2, 2, 5, 2, 2, 2, 2, 2, 2, 2, 5, 2,
/*70*/   6, 6, 6, 6, 6, 6, 0, 6, 2, 2, 2, 2, 2, 2, 5, 2,
/*80*/   2, 2, 2, 2, 2, 2, 5, 2, 2, 2, 2, 2, 2, 2, 5, 2,
/*90*/   2, 2, 2, 2, 2, 2, 5, 2, 2, 2, 2, 2, 2, 2, 5, 2,
/*A0*/   2, 2, 2, 2, 2, 2, 5, 2, 2, 2, 2, 2, 2, 2, 5, 2,
/*B0*/   2, 2, 2, 2, 2, 2, 5, 2, 2, 2, 2, 2, 2, 2, 5, 2,
/*C0*/   8, 7, 7, 7, 9,10, 4,10, 8, 8, 7,P2, 2,12, 4,19,
/*D0*/   8, 7, 7, 0,11,10, 4, 8, 8, 2, 7, 0, 2,P3, 4, 8,
/*E0*/   8, 7, 7, 2, 9,10, 6, 8, 8, 4, 7, 2, 2,P4, 4, 8,
/*F0*/   8, 7, 7, 2,11,10, 4,12, 8, 2, 7, 2, 2,P5, 4, 8
};

static char  rabpg2[256] = {  /* P2 == CB */
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/   4, 4, 4, 4, 4, 4,10, 4, 4, 4, 4, 4, 4, 4,10, 4,
/*10*/   4, 4, 4, 4, 4, 4,10, 4, 4, 4, 4, 4, 4, 4,10, 4,
/*20*/   4, 4, 4, 4, 4, 4,10, 4, 4, 4, 4, 4, 4, 4,10, 4,
/*30*/  UN,UN,UN,UN,UN,UN,UN,UN, 4, 4, 4, 4, 4, 4,10, 4,
/*40*/   4, 4, 4, 4, 4, 4, 7, 4, 4, 4, 4, 4, 4, 4, 7, 4,
/*50*/   4, 4, 4, 4, 4, 4, 7, 4, 4, 4, 4, 4, 4, 4, 7, 4,
/*60*/   4, 4, 4, 4, 4, 4, 7, 4, 4, 4, 4, 4, 4, 4, 7, 4,
/*70*/   4, 4, 4, 4, 4, 4, 7, 4, 4, 4, 4, 4, 4, 4, 7, 4,
/*80*/   4, 4, 4, 4, 4, 4,10, 4, 4, 4, 4, 4, 4, 4,10, 4,
/*90*/   4, 4, 4, 4, 4, 4,10, 4, 4, 4, 4, 4, 4, 4,10, 4,
/*A0*/   4, 4, 4, 4, 4, 4,10, 4, 4, 4, 4, 4, 4, 4,10, 4,
/*B0*/   4, 4, 4, 4, 4, 4,10, 4, 4, 4, 4, 4, 4, 4,10, 4,
/*C0*/   4, 4, 4, 4, 4, 4,10, 4, 4, 4, 4, 4, 4, 4,10, 4,
/*D0*/   4, 4, 4, 4, 4, 4,10, 4, 4, 4, 4, 4, 4, 4,10, 4,
/*E0*/   4, 4, 4, 4, 4, 4,10, 4, 4, 4, 4, 4, 4, 4,10, 4,
/*F0*/   4, 4, 4, 4, 4, 4,10, 4, 4, 4, 4, 4, 4, 4,10, 4
};

static char  rabpg3[256] = {  /* P3 == DD */
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/  UN,UN,UN,UN,UN,UN,UN,UN,UN, 4,UN,UN,UN,UN,UN,UN,
/*10*/  UN,UN,UN,UN,UN,UN,UN,UN,UN, 4,UN,UN,UN,UN,UN,UN,
/*20*/  UN, 8,15, 4,UN,UN,UN,UN,UN, 4,13, 4,UN,UN,UN,UN,
/*30*/  UN,UN,UN,UN,12,12,11,UN,UN, 4,UN,UN,UN,UN,UN,UN,
/*40*/  UN,UN,UN,UN,UN,UN, 9,UN,UN,UN,UN,UN,UN,UN, 9,UN,
/*50*/  UN,UN,UN,UN,UN,UN, 9,UN,UN,UN,UN,UN,UN,UN, 9,UN,
/*60*/  UN,UN,UN,UN,12,15, 9,UN,UN,UN,UN,UN,10,13, 9,UN,
/*70*/  10,10,10,10,10,10,UN,10,UN,UN,UN,UN, 4, 4, 9,UN,
/*80*/  UN,UN,UN,UN,UN,UN, 9,UN,UN,UN,UN,UN,UN,UN, 9,UN,
/*90*/  UN,UN,UN,UN,UN,UN, 9,UN,UN,UN,UN,UN,UN,UN, 9,UN,
/*A0*/  UN,UN,UN,UN,UN,UN, 9,UN,UN,UN,UN,UN,UN,UN, 9,UN,
/*B0*/  UN,UN,UN,UN,UN,UN, 9,UN,UN,UN,UN,UN,UN,UN, 9,UN,
/*C0*/  UN,UN,UN,UN,11,UN,UN,UN,UN,UN,UN,P6, 4,UN,UN,UN,
/*D0*/  UN,UN,UN,UN,13,UN,UN,UN,UN,UN,UN,UN, 4,UN,UN,UN,
/*E0*/  UN, 9,UN,15,11,12,UN,UN,UN, 6,UN,UN, 4,UN,UN,UN,
/*F0*/  UN,UN,UN,UN,13,UN,UN,UN,UN, 4,UN,UN, 4,UN,UN,UN
};

static char  rabpg4[256] = {  /* P4 == ED */
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*10*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*20*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*30*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*40*/  UN, 4, 4,15, 4,13, 4, 4,UN, 4, 4,13,UN,12, 4, 4,
/*50*/  UN, 4, 4,15,15,UN, 4, 4,UN, 4, 4,13,UN, 4, 4, 4,
/*60*/  UN, 4, 4,15,12,15,UN, 4,UN, 4, 4,UN,10,13,UN,UN,
/*70*/  UN,UN, 4,15,UN,UN, 9, 9,UN,UN, 4,13,UN,UN, 7,UN,
/*80*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*90*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*A0*/  10,UN,UN,UN,UN,UN,UN,UN,10,UN,UN,UN,UN,UN,UN,UN,
/*B0*/   6,UN,UN,UN,UN,UN,UN,UN, 6,UN,UN,UN,UN,UN,UN,UN,
/*C0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*D0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*E0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*F0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN
};

static char  rabpg5[256] = {  /* P5 == FD */
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/  UN,UN,UN,UN,UN,UN,UN,UN,UN, 4,UN,UN,UN,UN,UN,UN,
/*10*/  UN,UN,UN,UN,UN,UN,UN,UN,UN, 4,UN,UN,UN,UN,UN,UN,
/*20*/  UN, 8,15, 4,UN,UN,UN,UN,UN, 4,13, 4,UN,UN,UN,UN,
/*30*/  UN,UN,UN,UN,12,12,11,UN,UN, 4,UN,UN,UN,UN,UN,UN,
/*40*/  UN,UN,UN,UN,UN,UN, 9,UN,UN,UN,UN,UN,UN,UN, 9,UN,
/*50*/  UN,UN,UN,UN,UN,UN, 9,UN,UN,UN,UN,UN,UN,UN, 9,UN,
/*60*/  UN,UN,UN,UN,12,15, 9,UN,UN,UN,UN,UN,10,13, 9,UN,
/*70*/  10,10,10,10,10,10,UN,10,UN,UN,UN,UN, 4, 4, 9,UN,
/*80*/  UN,UN,UN,UN,UN,UN, 9,UN,UN,UN,UN,UN,UN,UN, 9,UN,
/*90*/  UN,UN,UN,UN,UN,UN, 9,UN,UN,UN,UN,UN,UN,UN, 9,UN,
/*A0*/  UN,UN,UN,UN,UN,UN, 9,UN,UN,UN,UN,UN,UN,UN, 9,UN,
/*B0*/  UN,UN,UN,UN,UN,UN, 9,UN,UN,UN,UN,UN,UN,UN, 9,UN,
/*C0*/  UN,UN,UN,UN,11,UN,UN,UN,UN,UN,UN,P7, 4,UN,UN,UN,
/*D0*/  UN,UN,UN,UN,13,UN,UN,UN,UN,UN,UN,UN, 4,UN,UN,UN,
/*E0*/  UN, 9,UN,15,11,12,UN,UN,UN, 6,UN,UN, 4,UN,UN,UN,
/*F0*/  UN,UN,UN,UN,13,UN,UN,UN,UN, 4,UN,UN, 4,UN,UN,UN
};

static char  rabpg6[256] = {  /* P6 == DD CB */
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/  UN,UN,UN,UN,UN,UN,10,UN,UN,UN,UN,UN,UN,UN,10,UN,
/*10*/  UN,UN,UN,UN,UN,UN,13,UN,UN,UN,UN,UN,UN,UN,10,UN,
/*20*/  UN,UN,UN,UN,UN,UN,13,UN,UN,UN,UN,UN,UN,UN,13,UN,
/*30*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,13,UN,
/*40*/  UN,UN,UN,UN,UN,UN,10,UN,UN,UN,UN,UN,UN,UN,10,UN,
/*50*/  UN,UN,UN,UN,UN,UN,10,UN,UN,UN,UN,UN,UN,UN,10,UN,
/*60*/  UN,UN,UN,UN,UN,UN,10,UN,UN,UN,UN,UN,UN,UN,10,UN,
/*70*/  UN,UN,UN,UN,UN,UN,10,UN,UN,UN,UN,UN,UN,UN,10,UN,
/*80*/  UN,UN,UN,UN,UN,UN,10,UN,UN,UN,UN,UN,UN,UN,10,UN,
/*90*/  UN,UN,UN,UN,UN,UN,10,UN,UN,UN,UN,UN,UN,UN,10,UN,
/*A0*/  UN,UN,UN,UN,UN,UN,10,UN,UN,UN,UN,UN,UN,UN,10,UN,
/*B0*/  UN,UN,UN,UN,UN,UN,10,UN,UN,UN,UN,UN,UN,UN,10,UN,
/*C0*/  UN,UN,UN,UN,UN,UN,13,UN,UN,UN,UN,UN,UN,UN,13,UN,
/*D0*/  UN,UN,UN,UN,UN,UN,13,UN,UN,UN,UN,UN,UN,UN,13,UN,
/*E0*/  UN,UN,UN,UN,UN,UN,13,UN,UN,UN,UN,UN,UN,UN,13,UN,
/*F0*/  UN,UN,UN,UN,UN,UN,13,UN,UN,UN,UN,UN,UN,UN,13,UN
};

static char  rabpg7[256] = {  /* P7 == FD CB */
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/  UN,UN,UN,UN,UN,UN,10,UN,UN,UN,UN,UN,UN,UN,10,UN,
/*10*/  UN,UN,UN,UN,UN,UN,13,UN,UN,UN,UN,UN,UN,UN,10,UN,
/*20*/  UN,UN,UN,UN,UN,UN,13,UN,UN,UN,UN,UN,UN,UN,13,UN,
/*30*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,13,UN,
/*40*/  UN,UN,UN,UN,UN,UN,10,UN,UN,UN,UN,UN,UN,UN,10,UN,
/*50*/  UN,UN,UN,UN,UN,UN,10,UN,UN,UN,UN,UN,UN,UN,10,UN,
/*60*/  UN,UN,UN,UN,UN,UN,10,UN,UN,UN,UN,UN,UN,UN,10,UN,
/*70*/  UN,UN,UN,UN,UN,UN,10,UN,UN,UN,UN,UN,UN,UN,10,UN,
/*80*/  UN,UN,UN,UN,UN,UN,10,UN,UN,UN,UN,UN,UN,UN,10,UN,
/*90*/  UN,UN,UN,UN,UN,UN,10,UN,UN,UN,UN,UN,UN,UN,10,UN,
/*A0*/  UN,UN,UN,UN,UN,UN,10,UN,UN,UN,UN,UN,UN,UN,10,UN,
/*B0*/  UN,UN,UN,UN,UN,UN,10,UN,UN,UN,UN,UN,UN,UN,10,UN,
/*C0*/  UN,UN,UN,UN,UN,UN,13,UN,UN,UN,UN,UN,UN,UN,13,UN,
/*D0*/  UN,UN,UN,UN,UN,UN,13,UN,UN,UN,UN,UN,UN,UN,13,UN,
/*E0*/  UN,UN,UN,UN,UN,UN,13,UN,UN,UN,UN,UN,UN,UN,13,UN,
/*F0*/  UN,UN,UN,UN,UN,UN,13,UN,UN,UN,UN,UN,UN,UN,13,UN
};

static char *rabPage[7] = {
    rabpg1, rabpg2, rabpg3, rabpg4,
    rabpg5, rabpg6, rabpg7
};

/*
 * HD64180 / Z180  Opcode Cycle Pages
 */

static char  hd64pg1[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/   3, 9, 7, 4, 4, 4, 6, 3, 4, 7, 6, 4, 4, 4, 6, 3,
/*10*/   9, 9, 7, 4, 4, 4, 6, 3, 8, 7, 6, 4, 4, 4, 6, 3,
/*20*/   8, 9,16, 4, 4, 4, 6, 4, 8, 7,15, 4, 4, 4, 6, 3,
/*30*/   8, 9,13, 4,10,10, 9, 3, 8, 7,12, 4, 4, 4, 6, 3,
/*40*/   4, 4, 4, 4, 4, 4, 6, 4, 4, 4, 4, 4, 4, 4, 6, 4,
/*50*/   4, 4, 4, 4, 4, 4, 6, 4, 4, 4, 4, 4, 4, 4, 6, 4,
/*60*/   4, 4, 4, 4, 4, 4, 6, 4, 4, 4, 4, 4, 4, 4, 6, 4,
/*70*/   7, 7, 7, 7, 7, 7, 3, 7, 4, 4, 4, 4, 4, 4, 6, 4,
/*80*/   4, 4, 4, 4, 4, 4, 6, 4, 4, 4, 4, 4, 4, 4, 6, 4,
/*90*/   4, 4, 4, 4, 4, 4, 6, 4, 4, 4, 4, 4, 4, 4, 6, 4,
/*A0*/   4, 4, 4, 4, 4, 4, 6, 4, 4, 4, 4, 4, 4, 4, 6, 4,
/*B0*/   4, 4, 4, 4, 4, 4, 6, 4, 4, 4, 4, 4, 4, 4, 6, 4,
/*C0*/  10, 9, 9, 9,16,11, 6,11,10, 9, 9,P2,16,16, 6,11,
/*D0*/  10, 9, 9,10,16,11, 6,11,10, 3, 9, 9,16,P3, 6,11,
/*E0*/  10, 9, 9,16,16,11, 6,11,10, 3, 9, 3,16,P4, 6,11,
/*F0*/  10, 9, 9, 3,16,11, 6,11,10, 4, 9, 3,16,P5, 6,11
};

static char  hd64pg2[256] = {  /* P2 == CB */
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/   7, 7, 7, 7, 7, 7,13, 7, 7, 7, 7, 7, 7, 7,13, 7,
/*10*/   7, 7, 7, 7, 7, 7,13, 7, 7, 7, 7, 7, 7, 7,13, 7,
/*20*/   7, 7, 7, 7, 7, 7,13, 7, 7, 7, 7, 7, 7, 7,13, 7,
/*30*/  UN,UN,UN,UN,UN,UN,UN,UN, 7, 7, 7, 7, 7, 7,13, 7,
/*40*/   7, 7, 7, 7, 7, 7,13, 7, 7, 7, 7, 7, 7, 7,13, 7,
/*50*/   7, 7, 7, 7, 7, 7,13, 7, 7, 7, 7, 7, 7, 7,13, 7,
/*60*/   7, 7, 7, 7, 7, 7,13, 7, 7, 7, 7, 7, 7, 7,13, 7,
/*70*/   7, 7, 7, 7, 7, 7,13, 7, 7, 7, 7, 7, 7, 7,13, 7,
/*80*/   7, 7, 7, 7, 7, 7,13, 7, 7, 7, 7, 7, 7, 7,13, 7,
/*90*/   7, 7, 7, 7, 7, 7,13, 7, 7, 7, 7, 7, 7, 7,13, 7,
/*A0*/   7, 7, 7, 7, 7, 7,13, 7, 7, 7, 7, 7, 7, 7,13, 7,
/*B0*/   7, 7, 7, 7, 7, 7,13, 7, 7, 7, 7, 7, 7, 7,13, 7, 
/*C0*/   7, 7, 7, 7, 7, 7,13, 7, 7, 7, 7, 7, 7, 7,13, 7,
/*D0*/   7, 7, 7, 7, 7, 7,13, 7, 7, 7, 7, 7, 7, 7,13, 7,
/*E0*/   7, 7, 7, 7, 7, 7,13, 7, 7, 7, 7, 7, 7, 7,13, 7,
/*F0*/   7, 7, 7, 7, 7, 7,13, 7, 7, 7, 7, 7, 7, 7,13, 7
};

static char  hd64pg3[256] = {  /* P3 == DD */
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,10,UN,UN,UN,UN,UN,UN,
/*10*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,10,UN,UN,UN,UN,UN,UN,
/*20*/  UN,12,19, 7,UN,UN,UN,UN,UN,10,18, 7,UN,UN,UN,UN,
/*30*/  UN,UN,UN,UN,18,18,15,UN,UN,10,UN,UN,UN,UN,UN,UN,
/*40*/  UN,UN,UN,UN,UN,UN,14,UN,UN,UN,UN,UN,UN,UN,14,UN,
/*50*/  UN,UN,UN,UN,UN,UN,14,UN,UN,UN,UN,UN,UN,UN,14,UN,
/*60*/  UN,UN,UN,UN,UN,UN,14,UN,UN,UN,UN,UN,UN,UN,14,UN,
/*70*/  15,15,15,15,15,15,UN,15,UN,UN,UN,UN,UN,UN,14,UN,
/*80*/  UN,UN,UN,UN,UN,UN,14,UN,UN,UN,UN,UN,UN,UN,14,UN,
/*90*/  UN,UN,UN,UN,UN,UN,14,UN,UN,UN,UN,UN,UN,UN,14,UN,
/*A0*/  UN,UN,UN,UN,UN,UN,14,UN,UN,UN,UN,UN,UN,UN,14,UN,
/*B0*/  UN,UN,UN,UN,UN,UN,14,UN,UN,UN,UN,UN,UN,UN,14,UN,
/*C0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,P6,UN,UN,UN,UN,
/*D0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*E0*/  UN,12,UN,19,UN,14,UN,UN,UN, 6,UN,UN,UN,UN,UN,UN,
/*F0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN, 7,UN,UN,UN,UN,UN,UN
};

static char  hd64pg4[256] = {  /* P4 == ED */
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/  12,13,UN,UN, 7,UN,UN,UN,12,13,UN,UN, 7,UN,UN,UN,
/*10*/  12,13,UN,UN, 7,UN,UN,UN,12,13,UN,UN, 7,UN,UN,UN,
/*20*/  12,13,UN,UN, 7,UN,UN,UN,12,13,UN,UN, 7,UN,UN,UN,
/*30*/  UN,UN,UN,UN,10,UN,UN,UN,12,13,UN,UN, 7,UN,UN,UN,
/*40*/   9,10,10,19, 6,12, 6, 6, 9,10,10,18,17,12,UN, 6,
/*50*/   9,10,10,19,UN,UN, 6, 6, 9,10,10,18,17,UN, 6, 6,
/*60*/   9,10,10,19, 9,UN,UN,16, 9,10,10,18,17,UN,UN,16,
/*70*/  UN,10,10,19,12,UN, 8,UN, 9,10,10,18,17,UN,UN,UN,
/*80*/  UN,UN,UN,14,UN,UN,UN,UN,UN,UN,UN,14,UN,UN,UN,UN,
/*90*/  UN,UN,UN,16,UN,UN,UN,UN,UN,UN,UN,16,UN,UN,UN,UN,
/*A0*/  12,12,12,12,UN,UN,UN,UN,12,12,12,12,UN,UN,UN,UN,
/*B0*/  14,14,14,14,UN,UN,UN,UN,14,14,14,14,UN,UN,UN,UN,
/*C0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*D0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*E0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*F0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN
};

static char  hd64pg5[256] = {  /* P5 == FD */
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,10,UN,UN,UN,UN,UN,UN,
/*10*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,10,UN,UN,UN,UN,UN,UN,
/*20*/  UN,12,19, 7,UN,UN,UN,UN,UN,10,18, 7,UN,UN,UN,UN,
/*30*/  UN,UN,UN,UN,18,18,15,UN,UN,10,UN,UN,UN,UN,UN,UN,
/*40*/  UN,UN,UN,UN,UN,UN,14,UN,UN,UN,UN,UN,UN,UN,14,UN,
/*50*/  UN,UN,UN,UN,UN,UN,14,UN,UN,UN,UN,UN,UN,UN,14,UN,
/*60*/  UN,UN,UN,UN,UN,UN,14,UN,UN,UN,UN,UN,UN,UN,14,UN,
/*70*/  15,15,15,15,15,15,UN,15,UN,UN,UN,UN,UN,UN,14,UN,
/*80*/  UN,UN,UN,UN,UN,UN,14,UN,UN,UN,UN,UN,UN,UN,14,UN,
/*90*/  UN,UN,UN,UN,UN,UN,14,UN,UN,UN,UN,UN,UN,UN,14,UN,
/*A0*/  UN,UN,UN,UN,UN,UN,14,UN,UN,UN,UN,UN,UN,UN,14,UN,
/*B0*/  UN,UN,UN,UN,UN,UN,14,UN,UN,UN,UN,UN,UN,UN,14,UN,
/*C0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,P7,UN,UN,UN,UN,
/*D0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*E0*/  UN,12,UN,19,UN,14,UN,UN,UN, 6,UN,UN,UN,UN,UN,UN,
/*F0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN, 7,UN,UN,UN,UN,UN,UN
};

static char  hd64pg6[256] = {  /* P6 == DD CB */
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/  UN,UN,UN,UN,UN,UN,19,UN,UN,UN,UN,UN,UN,UN,19,UN,
/*10*/  UN,UN,UN,UN,UN,UN,19,UN,UN,UN,UN,UN,UN,UN,19,UN,
/*20*/  UN,UN,UN,UN,UN,UN,19,UN,UN,UN,UN,UN,UN,UN,19,UN,
/*30*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,19,UN,
/*40*/  UN,UN,UN,UN,UN,UN,19,UN,UN,UN,UN,UN,UN,UN,19,UN,
/*50*/  UN,UN,UN,UN,UN,UN,19,UN,UN,UN,UN,UN,UN,UN,19,UN,
/*60*/  UN,UN,UN,UN,UN,UN,19,UN,UN,UN,UN,UN,UN,UN,19,UN,
/*70*/  UN,UN,UN,UN,UN,UN,19,UN,UN,UN,UN,UN,UN,UN,19,UN,
/*80*/  UN,UN,UN,UN,UN,UN,19,UN,UN,UN,UN,UN,UN,UN,19,UN,
/*90*/  UN,UN,UN,UN,UN,UN,19,UN,UN,UN,UN,UN,UN,UN,19,UN,
/*A0*/  UN,UN,UN,UN,UN,UN,19,UN,UN,UN,UN,UN,UN,UN,19,UN,
/*B0*/  UN,UN,UN,UN,UN,UN,19,UN,UN,UN,UN,UN,UN,UN,19,UN,
/*C0*/  UN,UN,UN,UN,UN,UN,19,UN,UN,UN,UN,UN,UN,UN,19,UN,
/*D0*/  UN,UN,UN,UN,UN,UN,19,UN,UN,UN,UN,UN,UN,UN,19,UN,
/*E0*/  UN,UN,UN,UN,UN,UN,19,UN,UN,UN,UN,UN,UN,UN,19,UN,
/*F0*/  UN,UN,UN,UN,UN,UN,19,UN,UN,UN,UN,UN,UN,UN,19,UN
};

static char  hd64pg7[256] = {  /* P7 == FD CB */
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/  UN,UN,UN,UN,UN,UN,19,UN,UN,UN,UN,UN,UN,UN,19,UN,
/*10*/  UN,UN,UN,UN,UN,UN,19,UN,UN,UN,UN,UN,UN,UN,19,UN,
/*20*/  UN,UN,UN,UN,UN,UN,19,UN,UN,UN,UN,UN,UN,UN,19,UN,
/*30*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,19,UN,
/*40*/  UN,UN,UN,UN,UN,UN,19,UN,UN,UN,UN,UN,UN,UN,19,UN,
/*50*/  UN,UN,UN,UN,UN,UN,19,UN,UN,UN,UN,UN,UN,UN,19,UN,
/*60*/  UN,UN,UN,UN,UN,UN,19,UN,UN,UN,UN,UN,UN,UN,19,UN,
/*70*/  UN,UN,UN,UN,UN,UN,19,UN,UN,UN,UN,UN,UN,UN,19,UN,
/*80*/  UN,UN,UN,UN,UN,UN,19,UN,UN,UN,UN,UN,UN,UN,19,UN,
/*90*/  UN,UN,UN,UN,UN,UN,19,UN,UN,UN,UN,UN,UN,UN,19,UN,
/*A0*/  UN,UN,UN,UN,UN,UN,19,UN,UN,UN,UN,UN,UN,UN,19,UN,
/*B0*/  UN,UN,UN,UN,UN,UN,19,UN,UN,UN,UN,UN,UN,UN,19,UN,
/*C0*/  UN,UN,UN,UN,UN,UN,19,UN,UN,UN,UN,UN,UN,UN,19,UN,
/*D0*/  UN,UN,UN,UN,UN,UN,19,UN,UN,UN,UN,UN,UN,UN,19,UN,
/*E0*/  UN,UN,UN,UN,UN,UN,19,UN,UN,UN,UN,UN,UN,UN,19,UN,
/*F0*/  UN,UN,UN,UN,UN,UN,19,UN,UN,UN,UN,UN,UN,UN,19,UN
};

static char *hd64Page[7] = {
    hd64pg1, hd64pg2, hd64pg3, hd64pg4,
    hd64pg5, hd64pg6, hd64pg7
};

/*
 * Z80 Opcode Cycle Pages
 */

static char  z80pg1[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/   4,10, 7, 6, 4, 4, 7, 4, 4,11, 7, 6, 4, 4, 7, 4,
/*10*/  13,10, 7, 6, 4, 4, 7, 4,12,11, 7, 6, 4, 4, 7, 4,
/*20*/  12,10,16, 6, 4, 4, 7, 4,12,11,16, 6, 4, 4, 7, 4,
/*30*/  12,10,13, 6,11,11,10, 4,12,11,13, 6, 4, 4, 7, 4,
/*40*/   4, 4, 4, 4, 4, 4, 7, 4, 4, 4, 4, 4, 4, 4, 7, 4,
/*50*/   4, 4, 4, 4, 4, 4, 7, 4, 4, 4, 4, 4, 4, 4, 7, 4,
/*60*/   4, 4, 4, 4, 4, 4, 7, 4, 4, 4, 4, 4, 4, 4, 7, 4,
/*70*/   7, 7, 7, 7, 7, 7, 4, 7, 4, 4, 4, 4, 4, 4, 7, 4,
/*80*/   4, 4, 4, 4, 4, 4, 7, 4, 4, 4, 4, 4, 4, 4, 7, 4,
/*90*/   4, 4, 4, 4, 4, 4, 7, 4, 4, 4, 4, 4, 4, 4, 7, 4,
/*A0*/   4, 4, 4, 4, 4, 4, 7, 4, 4, 4, 4, 4, 4, 4, 7, 4,
/*B0*/   4, 4, 4, 4, 4, 4, 7, 4, 4, 4, 4, 4, 4, 4, 7, 4,
/*C0*/  11,10,10,10,17,11, 7,11,11,10,10,P2,17,17, 7,11,
/*D0*/  11,10,10,11,17,11, 7,11,11, 4,10,11,17,P3, 7,11,
/*E0*/  11,10,10,19,17,11, 7,11,11, 4,10, 4,17,P4, 7,11,
/*F0*/  11,10,10, 4,17,11, 7,11,11, 6,10, 4,17,P5, 7,11
};

static char  z80pg2[256] = {  /* P2 == CB */
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/   8, 8, 8, 8, 8, 8,15, 8, 8, 8, 8, 8, 8, 8,15, 8,
/*10*/   8, 8, 8, 8, 8, 8,15, 8, 8, 8, 8, 8, 8, 8,15, 8,
/*20*/   8, 8, 8, 8, 8, 8,15, 8, 8, 8, 8, 8, 8, 8,15, 8,
/*30*/  UN,UN,UN,UN,UN,UN,UN,UN, 8, 8, 8, 8, 8, 8,15, 8,
/*40*/   8, 8, 8, 8, 8, 8,12, 8, 8, 8, 8, 8, 8, 8,12, 8,
/*50*/   8, 8, 8, 8, 8, 8,12, 8, 8, 8, 8, 8, 8, 8,12, 8,
/*60*/   8, 8, 8, 8, 8, 8,12, 8, 8, 8, 8, 8, 8, 8,12, 8,
/*70*/   8, 8, 8, 8, 8, 8,12, 8, 8, 8, 8, 8, 8, 8,12, 8,
/*80*/   8, 8, 8, 8, 8, 8,15, 8, 8, 8, 8, 8, 8, 8,15, 8,
/*90*/   8, 8, 8, 8, 8, 8,15, 8, 8, 8, 8, 8, 8, 8,15, 8,
/*A0*/   8, 8, 8, 8, 8, 8,15, 8, 8, 8, 8, 8, 8, 8,15, 8,
/*B0*/   8, 8, 8, 8, 8, 8,15, 8, 8, 8, 8, 8, 8, 8,15, 8,
/*C0*/   8, 8, 8, 8, 8, 8,15, 8, 8, 8, 8, 8, 8, 8,15, 8,
/*D0*/   8, 8, 8, 8, 8, 8,15, 8, 8, 8, 8, 8, 8, 8,15, 8,
/*E0*/   8, 8, 8, 8, 8, 8,15, 8, 8, 8, 8, 8, 8, 8,15, 8,
/*F0*/   8, 8, 8, 8, 8, 8,15, 8, 8, 8, 8, 8, 8, 8,15, 8
};

static char  z80pg3[256] = {  /* P3 == DD */
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,15,UN,UN,UN,UN,UN,UN,
/*10*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,15,UN,UN,UN,UN,UN,UN,
/*20*/  UN,14,20,10,UN,UN,UN,UN,UN,15,20,10,UN,UN,UN,UN,
/*30*/  UN,UN,UN,UN,23,23,19,UN,UN,15,UN,UN,UN,UN,UN,UN,
/*40*/  UN,UN,UN,UN,UN,UN,19,UN,UN,UN,UN,UN,UN,UN,19,UN,
/*50*/  UN,UN,UN,UN,UN,UN,19,UN,UN,UN,UN,UN,UN,UN,19,UN,
/*60*/  UN,UN,UN,UN,UN,UN,19,UN,UN,UN,UN,UN,UN,UN,19,UN,
/*70*/  19,19,19,19,19,19,UN,19,UN,UN,UN,UN,UN,UN,19,UN,
/*80*/  UN,UN,UN,UN,UN,UN,19,UN,UN,UN,UN,UN,UN,UN,19,UN,
/*90*/  UN,UN,UN,UN,UN,UN,19,UN,UN,UN,UN,UN,UN,UN,19,UN,
/*A0*/  UN,UN,UN,UN,UN,UN,19,UN,UN,UN,UN,UN,UN,UN,19,UN,
/*B0*/  UN,UN,UN,UN,UN,UN,19,UN,UN,UN,UN,UN,UN,UN,19,UN,
/*C0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,P6,UN,UN,UN,UN,
/*D0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*E0*/  UN,14,UN,23,UN,15,UN,UN,UN, 8,UN,UN,UN,UN,UN,UN,
/*F0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,10,UN,UN,UN,UN,UN,UN
};

static char  z80pg4[256] = {  /* P4 == ED */
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*10*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*20*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*30*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*40*/  12,12,15,20, 8,14, 8, 9,12,12,15,20,UN,14,UN, 9,
/*50*/  12,12,15,20,UN,UN, 8, 9,12,12,15,20,UN,UN, 8, 9,
/*60*/  12,12,15,20,UN,UN,UN,18,12,12,15,20,UN,UN,UN,18,
/*70*/  UN,UN,15,20,UN,UN,UN,UN,12,12,15,20,UN,UN,UN,UN,
/*80*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*90*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*A0*/  16,16,16,16,UN,UN,UN,UN,16,16,16,16,UN,UN,UN,UN,
/*B0*/  21,21,21,21,UN,UN,UN,UN,21,21,21,21,UN,UN,UN,UN,
/*C0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*D0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*E0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*F0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN
};

static char  z80pg5[256] = {  /* P5 == FD */
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,15,UN,UN,UN,UN,UN,UN,
/*10*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,15,UN,UN,UN,UN,UN,UN,
/*20*/  UN,14,20,10,UN,UN,UN,UN,UN,15,20,10,UN,UN,UN,UN,
/*30*/  UN,UN,UN,UN,23,23,19,UN,UN,15,UN,UN,UN,UN,UN,UN,
/*40*/  UN,UN,UN,UN,UN,UN,19,UN,UN,UN,UN,UN,UN,UN,19,UN,
/*50*/  UN,UN,UN,UN,UN,UN,19,UN,UN,UN,UN,UN,UN,UN,19,UN,
/*60*/  UN,UN,UN,UN,UN,UN,19,UN,UN,UN,UN,UN,UN,UN,19,UN,
/*70*/  19,19,19,19,19,19,UN,19,UN,UN,UN,UN,UN,UN,19,UN,
/*80*/  UN,UN,UN,UN,UN,UN,19,UN,UN,UN,UN,UN,UN,UN,19,UN,
/*90*/  UN,UN,UN,UN,UN,UN,19,UN,UN,UN,UN,UN,UN,UN,19,UN,
/*A0*/  UN,UN,UN,UN,UN,UN,19,UN,UN,UN,UN,UN,UN,UN,19,UN,
/*B0*/  UN,UN,UN,UN,UN,UN,19,UN,UN,UN,UN,UN,UN,UN,19,UN,
/*C0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,P7,UN,UN,UN,UN,
/*D0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*E0*/  UN,14,UN,23,UN,15,UN,UN,UN, 8,UN,UN,UN,UN,UN,UN,
/*F0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,10,UN,UN,UN,UN,UN,UN
};

static char  z80pg6[256] = {  /* P6 == DD CB */
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/  UN,UN,UN,UN,UN,UN,23,UN,UN,UN,UN,UN,UN,UN,23,UN,
/*10*/  UN,UN,UN,UN,UN,UN,23,UN,UN,UN,UN,UN,UN,UN,23,UN,
/*20*/  UN,UN,UN,UN,UN,UN,23,UN,UN,UN,UN,UN,UN,UN,23,UN,
/*30*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,23,UN,
/*40*/  UN,UN,UN,UN,UN,UN,20,UN,UN,UN,UN,UN,UN,UN,20,UN,
/*50*/  UN,UN,UN,UN,UN,UN,20,UN,UN,UN,UN,UN,UN,UN,20,UN,
/*60*/  UN,UN,UN,UN,UN,UN,20,UN,UN,UN,UN,UN,UN,UN,20,UN,
/*70*/  UN,UN,UN,UN,UN,UN,20,UN,UN,UN,UN,UN,UN,UN,20,UN,
/*80*/  UN,UN,UN,UN,UN,UN,23,UN,UN,UN,UN,UN,UN,UN,23,UN,
/*90*/  UN,UN,UN,UN,UN,UN,23,UN,UN,UN,UN,UN,UN,UN,23,UN,
/*A0*/  UN,UN,UN,UN,UN,UN,23,UN,UN,UN,UN,UN,UN,UN,23,UN,
/*B0*/  UN,UN,UN,UN,UN,UN,23,UN,UN,UN,UN,UN,UN,UN,23,UN,
/*C0*/  UN,UN,UN,UN,UN,UN,23,UN,UN,UN,UN,UN,UN,UN,23,UN,
/*D0*/  UN,UN,UN,UN,UN,UN,23,UN,UN,UN,UN,UN,UN,UN,23,UN,
/*E0*/  UN,UN,UN,UN,UN,UN,23,UN,UN,UN,UN,UN,UN,UN,23,UN,
/*F0*/  UN,UN,UN,UN,UN,UN,23,UN,UN,UN,UN,UN,UN,UN,23,UN
};

static char  z80pg7[256] = {  /* P7 == FD CB */
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/  UN,UN,UN,UN,UN,UN,23,UN,UN,UN,UN,UN,UN,UN,23,UN,
/*10*/  UN,UN,UN,UN,UN,UN,23,UN,UN,UN,UN,UN,UN,UN,23,UN,
/*20*/  UN,UN,UN,UN,UN,UN,23,UN,UN,UN,UN,UN,UN,UN,23,UN,
/*30*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,23,UN,
/*40*/  UN,UN,UN,UN,UN,UN,20,UN,UN,UN,UN,UN,UN,UN,20,UN,
/*50*/  UN,UN,UN,UN,UN,UN,20,UN,UN,UN,UN,UN,UN,UN,20,UN,
/*60*/  UN,UN,UN,UN,UN,UN,20,UN,UN,UN,UN,UN,UN,UN,20,UN,
/*70*/  UN,UN,UN,UN,UN,UN,20,UN,UN,UN,UN,UN,UN,UN,20,UN,
/*80*/  UN,UN,UN,UN,UN,UN,23,UN,UN,UN,UN,UN,UN,UN,23,UN,
/*90*/  UN,UN,UN,UN,UN,UN,23,UN,UN,UN,UN,UN,UN,UN,23,UN,
/*A0*/  UN,UN,UN,UN,UN,UN,23,UN,UN,UN,UN,UN,UN,UN,23,UN,
/*B0*/  UN,UN,UN,UN,UN,UN,23,UN,UN,UN,UN,UN,UN,UN,23,UN,
/*C0*/  UN,UN,UN,UN,UN,UN,23,UN,UN,UN,UN,UN,UN,UN,23,UN,
/*D0*/  UN,UN,UN,UN,UN,UN,23,UN,UN,UN,UN,UN,UN,UN,23,UN,
/*E0*/  UN,UN,UN,UN,UN,UN,23,UN,UN,UN,UN,UN,UN,UN,23,UN,
/*F0*/  UN,UN,UN,UN,UN,UN,23,UN,UN,UN,UN,UN,UN,UN,23,UN
};

static char *z80Page[7] = {
    z80pg1, z80pg2, z80pg3, z80pg4,
    z80pg5, z80pg6, z80pg7
};

/*
 * Process a machine op.
 */
VOID
machine(mp)
struct mne *mp;
{
	int op, t1, t2;
	struct expr e1, e2;
	int rf, v1, v2;
	int of;

	clrexpr(&e1);
	clrexpr(&e2);
	op = (int) mp->m_valu;
	rf = mp->m_type;

	chkPreByte(mp);

	switch (rf) {
	case S_CPU:
		mchtyp = op;
		sym[2].s_addr = op;
		opcycles = OPCY_CPU;
		lmode = SLIST;
		break;

	case RB_PRE:
		/*
		 * Rabbit Only
		 */
		if (mchtyp == X_R2K) {
			switch(op) {
			case 0x76:	preByte.altd = op;	break;
			case 0xdb:	preByte.ioe  = op;	break;
			case 0xd3:	preByte.ioi  = op;	break;
			default:
				err('o');
				break;
			}
		} else {
			err('o');
		}
		return;

	case S_INH1:
	case S_INH1R:
	case S_INH1X:
		/*
		 * Rabbit Only
		 */
		if ((rf == S_INH1R) && (mchtyp != X_R2K))
			err('o');
		/*
		 * Rabbit Excluded
		 */
		if ((rf == S_INH1X) && (mchtyp == X_R2K))
			err('o');
	        outab(op);
		break;

	case S_INH2:
	case S_INH2R:
	case S_INH2X:
		/*
		 * Rabbit Only
		 */
		if ((rf == S_INH2R) && (mchtyp != X_R2K))
			err('o');
		/*
		 * Rabbit Excluded
		 */
		if ((rf == S_INH2X) && (mchtyp == X_R2K))
			err('o');
		outab(0xED);
		outab(op);
		break;

	case S_RET:
		if (more()) {
			if ((v1 = admode(CND)) != 0) {
				outab(op | (v1<<3));
			} else {
				qerr();
			}
		} else {
			outab(0xC9);
		}
		break;

	case S_PUSH:
		/*
		 * Rabbit: push/pop ip
		 */
	        if ((admode(R2KIP) & 0xFF) == IP) {
			if (mchtyp != X_R2K)
				aerr();
			outab(0xed);
			if (op == 0xc5) {	/* push ip */
				outab(0x76);
			} else
			if (op == 0xc1) {	/* pop  ip */
				outab(0x7e);
			} else {
				err('o');
			}
			if (preByte.altd)
				err('o');
			break;
		} else
		/*
		 * push/pop af
		 */
		if (admode(R16AF)) {
			outab(op+0x30);
			break;
		} else
		/*
		 * push/pop bc/de/hl/ix/iy	(not sp)
		 */
		if ((v1 = admode(R16)) != 0 && (v1 &= 0xFF) != SP) {
			if (v1 != gixiy(v1)) {
				if (preByte.altd)
					err('o');
				outab(op+0x20);
				break;
			}
			outab(op | (v1<<4));
			break;
		}
		aerr();
		break;

	case S_RST:
		v1 = (int) absexpr();
		if (v1 & ~0x38) {
			aerr();
			v1 = 0;
		}
		/*
		 * Rabbit: Exclude rst 0x00/0x08/0x30
		 */
		if (mchtyp == X_R2K) {
			switch (v1) {
			case 0x10:
			case 0x18:
			case 0x20:
			case 0x28:
			case 0x38:
				break;
			default: 
				aerr();
				break;
			}
		}
		outab(op|v1);
		break;

	case S_IM:
		/*
		 * Rabbit Excluded
		 */
		if (mchtyp == X_R2K)
			err('o');
		expr(&e1, 0);
		abscheck(&e1);
		if (e1.e_addr > 2) {
			aerr();
			e1.e_addr = 0;
		}
		outab(op);
		outab(imtab[(int) e1.e_addr]);
		break;

	case S_BIT:
		expr(&e1, 0);
		t1 = 0;
		v1 = (int) e1.e_addr;
		if (v1 > 7) {
			v1 &= 0x07;
			++t1;
		}
		op |= (v1<<3);
		comma(1);
		abscheck(&e1);
		chkIOPreByte(addr(&e2));
		/*
		 * bit  b,(hl)
		 * bit  b,(ix+d)
		 * bit  b,(iy+d)
		 * bit  b,r
		 */
		if (genop(0xCB, op, &e2, 0) || t1)
			aerr();
		break;

	case S_RL:
		t1 = addr(&e1);
		if ((mchtyp == X_R2K) && (t1 == S_R16)) {
			v1 = (int) e1.e_addr;
			if (preByte.ioi || preByte.ioe) {
				err('o');
			}
			if (op == 0x10) {		/* rl */
				if (v1 == DE) {		/* rl de */
					outab(0xF3);
				} else {
					aerr();
				}
			} else
			if (op == 0x18) {		/* rr */
				if (v1 == DE) {		/* rr de */
					outab(0xFB);
				} else
				if (v1 == HL) {		/* rr hl */
					outab(0xFC);
				} else
				if (v1 == IX) {		/* rr ix */
					outab(0xDD);	outab(0xFC);
				} else
				if (v1 == IY) {		/* rr iy */
					outab(0xFD);	outab(0xFC);
				} else {
					aerr();
				}
			} else {
				aerr();
			}
			break;
		} else { 
			chkIOPreByte(t1);
			if (genop(0xCB, op, &e1, 0))
				aerr();
		}
		break;

	case S_AND:
        case S_OR:
	case S_SUB:
		t1 = addr(&e1);
		if (t1 == S_USER)
			t1 = e1.e_mode = S_IMMED;
		t2 = 0;
		if (more()) {
			comma(1);
			t2 = addr(&e2);
			if (t2 == S_USER)
				t2 = e2.e_mode = S_IMMED;
		}
		if(t2 == 0) {
			chkIOPreByte(t1);
			/*
			 * op  (hl)
			 * op  (ix+d)
			 * op  (iy+d)
			 * op  r
			 * op  n	[#n]
			 */
			if (genop(0, op, &e1, 1))
				aerr();
			break;
		}
		if ((t1 == S_R8) && (e1.e_addr == A)) {
			chkIOPreByte(t2);
			/*
			 * op  a,(hl)
			 * op  a,(ix+d)
			 * op  a,(iy+d)
			 * op  a,r
			 * op  a,n	[a,#n]
			 */
			if (genop(0, op, &e2, 1))
				aerr();
			break;
		}
		if (preByte.ioi || preByte.ioe) {
			err('o');
		}
		if ((mchtyp == X_R2K) && (t1 == S_R16) && (t2 == S_R16)) {
			if (rf == S_AND) {	/* and */
				op = 0xDC;
			} else
			if (rf == S_OR) {	/* or  */
				op = 0xEC;
			} else {
				aerr();		/* sub / xor */
				break;
			}
			v2 = (int) e2.e_addr;
			if (v2 != DE) {
				aerr();
				break;
			}
			v1 = (int) e1.e_addr;
			if (v1 == HL) {		/* op  hl,de */
				outab(op);
			} else
			if (v1 == IX) {		/* op  ix,de */
				outab(0xDD);	outab(op);
			} else
			if (v1 == IY) {		/* op  iy,de */
				outab(0xFD);	outab(op);
			} else {
				aerr();
			}
			break;
		}
		aerr();
		break;

	case S_ADD:
	case S_ADC:
	case S_SBC:
		t1 = addr(&e1);
		if (t1 == S_USER)
			t1 = e1.e_mode = S_IMMED;
		t2 = 0;
		if (more()) {
			comma(1);
			t2 = addr(&e2);
			if (t2 == S_USER)
				t2 = e2.e_mode = S_IMMED;
		} else
		if (t2 == 0) {
			chkIOPreByte(t1);
			/*
			 * op  (hl)
			 * op  (ix+d)
			 * op  (iy+d)
			 * op  r
			 * op  n	[#n]
			 */
			if (genop(0, op, &e1, 1))
				aerr();
			break;
		}
		if ((t1 == S_R8) && (e1.e_addr == A)) {
			chkIOPreByte(t2);
			/*
			 * op  a,(hl)
			 * op  a,(ix+d)
			 * op  a,(iy+d)
			 * op  a,r
			 * op  a,n	[a,#n]
			 */
			if (genop(0, op, &e2, 1))
				aerr();
			break;
		}
		if (preByte.ioi || preByte.ioe) {
			err('o');
		}
		/*
		 * op  xx,yy
		 */
		if ((t1 == S_R16) && (t2 == S_R16)) {
			if (rf == S_ADD) {
				op = 0x09;
			} else
			if (rf == S_ADC) {
				op = 0x4A;
			} else
			if (rf == S_SBC) {
				op = 0x42;
			}
			v1 = (int) e1.e_addr;
			v2 = (int) e2.e_addr;
			/*
			 * op  hl,bc
			 * op  hl,de
			 * op  hl,hl
			 * op  hl,sp
			 */
			if ((v1 == HL) && (v2 <= SP)) {
				if (rf != S_ADD)
					outab(0xED);
				outab(op | (v2<<4));
				break;
			}
			if (rf != S_ADD) {
				aerr();
				break;
			}
			/*
			 * add  ix,bc
			 * add  ix,de
			 * add  ix,ix
			 * add  ix,sp
			 */
			if ((v1 == IX) && (v2 != HL) && (v2 != IY)) {
				if (v2 == IX)
					v2 = HL;
				outab(0xDD);
				outab(op | (v2<<4));
				break;
			}
			/*
			 * add  iy,bc
			 * add  iy,de
			 * add  iy,iy
			 * add  iy,sp
			 */
			if ((v1 == IY) && (v2 != HL) && (v2 != IX)) {
				if (v2 == IY)
					v2 = HL;
				outab(0xFD);
				outab(op | (v2<<4));
				break;
			}
			aerr();
			break;
		}
                /*
                 * add  sp,n	[sp,#n]
                 */
		if ((mchtyp == X_R2K) && (rf == S_ADD) &&
		    (t1 == S_R16) && (e1.e_addr == SP) &&
		    (t2 == S_IMMED)) {
			outab(0x27);
			outrb(&e2, R_USGN);
			break;
                }
		aerr();
		break;

	case S_LD:
	      	t1 = addr(&e1);
		v1 = (int) e1.e_addr;
		comma(1);
		t2 = addr(&e2);
		v2 = (int) e2.e_addr;
		if (t2 == S_USER)
			t2 = e2.e_mode = S_IMMED;
		/*
		 * ld  a,(bc)
		 * ld  a,(de)
		 */
		if ((t1 == S_R8) && (v1 == A)) {
			if ((t2 == S_IDBC) || (t2 == S_IDDE)) {
				outab(0x0A | ((t2-S_INDR)<<4));
				break;
			}
		}
		/*
		 * ld  (bc),a
		 * ld  (de),a
		 */
		if ((t2 == S_R8) && (v2 == A)) {
			if ((t1 == S_IDBC) || (t1 == S_IDDE)) {
				if (preByte.altd)
					err('o');
				outab(0x02 | ((t1-S_INDR)<<4));
				break;
			}
		}
		/*
		 * ld  a,(mn)	[a,(#mn)]
		 */
		if ((t1 == S_R8) && (v1 == A) && (t2 == S_INDM)) {
			outab(0x3A);
			outrw(&e2, 0);
			break;
		}
		/*
		 * ld  (mn),a	[(#mn),a]
		 */
		if ((t1 == S_INDM) && (t2 == S_R8) && (v2 == A)) {
			if (preByte.altd)
				err('o');
			outab(0x32);
			outrw(&e1, 0);
			break;
		}
		/*
		 * ld  R,a
		 * ld  I,a
		 *
		 * ld  EIR,a
		 * ld  IIR,a
		 * ld  XPC,a
		 */
		if ((t1 == S_R8X) && (t2 == S_R8) && (v2 == A)) {
			if ((mchtyp != X_R2K) && (v1 == XPC))
				aerr();
			if (preByte.altd || preByte.ioe || preByte.ioi)
				err('o');
			outab(0xED);
			outab(v1);
			break;
		}
		/*
		 * ld  a,R
		 * ld  a,I
		 *
		 * ld  a,EIR
		 * ld  a,IIR
		 * ld  a,XPC
		 */
		if ((t1 == S_R8) && (v1 == A) && (t2 == S_R8X)) {
			if ((mchtyp != X_R2K) && (v2 == XPC))
				aerr();
			if (preByte.ioe || preByte.ioi)
				err('o');
			outab(0xED);
			outab(v2|0x10);
			break;
		}
		/*
		 * genop
		 */
		if (t1 == S_R8) {
			chkIOPreByte(t2);
			/*
			 * ld  r,(hl)
			 * ld  r,(ix+d)
			 * ld  r,(iy+d)
			 * ld  r,g
			 */
			if (genop(0, op | (v1<<3), &e2, 0) == 0)
				break;
			/*
			 * ld  r,n	(r,#n)
			 */
			if (t2 == S_IMMED) {
				outab((v1<<3) | 0x06);
				outrb(&e2,0);
				break;
			}
		}
		/*
		 * ld  be,mn	[be,#mn]
		 * ld  de,mn	[de,#mn]
		 * ld  hl,mn	[hl,#mn]
		 * ld  sp,mn	[sp,#mn]
		 * ld  ix,mn	[ix,#mn]
		 * ld  iy,mn	[iy,#mn]
		 */
		if ((t1 == S_R16) && (t2 == S_IMMED)) {
			if (preByte.ioi || preByte.ioe)
				err('o');
			if (preByte.altd && ((v1 == SP) || (v1 == IX) || (v1 == IY)))
				err('o');
			v1 = gixiy(v1);
			outab(0x01|(v1<<4));
			outrw(&e2, 0);
			break;
		}
		/*
		 * ld  be,(mn)	[be,(#mn)]
		 * ld  de,(mn)	[de,(#mn)]
		 * ld  hl,(mn)	[hl,(#mn)]
		 * ld  sp,(mn)	[sp,(#mn)]
		 * ld  ix,(mn)	[ix,(#mn)]
		 * ld  iy,(mn)	[iy,(#mn)]
		 */
		if ((t1 == S_R16) && (t2 == S_INDM)) {
			if (preByte.altd && ((v1 == SP) || (v1 == IX) || (v1 == IY)))
				err('o');
			if (gixiy(v1) == HL) {
				outab(0x2A);
			} else {
				outab(0xED);
				outab(0x4B | (v1<<4));
			}
			outrw(&e2, 0);
			break;
		}
		/*
		 * ld  hl,(hl+d)
		 * ld  hl,(ix+d)
		 * ld  hl,(iy+d)
		 */
		if ((t1 == S_R16) && (v1 == HL) &&
		   ((t2 == S_IDIX) || (t2 == S_IDHL) || (t2 == S_IDIY))) {
			if (mchtyp != X_R2K)
				aerr();
			if (t2 == S_IDHL)	outab(0xDD);
			if (t2 == S_IDIY)	outab(0xFD); 
			outab(0xE4);
			outrb(&e2, R_SGND);
			break;
		}
		/*
		 * ld  hl,(sp+n)
		 * ld  ix,(sp+n)
		 * ld  iy,(sp+n)
		 */
		if ((t1 == S_R16) && (t2 == S_IDSP)) {
 	        	if (mchtyp != X_R2K)
				aerr();
			if (preByte.altd && ((v1 == IX) || (v1 == IY)))
				err('o');
			if (preByte.ioi || preByte.ioe)
				err('o');
			if (gixiy(v1) == HL) {
				outab(0xc4);
				outrb(&e2, R_USGN);
				break;
			}
		}
		/*
		 * ld  (hl+d),hl
		 * ld  (ix+d),hl
		 * ld  (iy+d),hl
		 */
	        if ((t2 == S_R16) && (v2 == HL) &&
		   ((t1 == S_IDIX) || (t1 == S_IDHL) || (t1 == S_IDIY))) {
			if (mchtyp != X_R2K)
				aerr();
			if (preByte.altd)
				err('o');
			if (t1 == S_IDHL)	outab(0xDD);                         
			if (t1 == S_IDIY)	outab(0xFD);                           
			outab(0xF4);
			outrb(&e1, R_SGND);
			break;
		}
		/*
		 * ld (sp+n),hl
		 * ld (sp+n),ix
		 * ld (sp+n),iy
		 */
		if ((t2 == S_R16) && (t1 == S_IDSP)) {
			if (mchtyp != X_R2K)
				aerr();
			if (preByte.altd || preByte.ioe || preByte.ioi)
				err('o');
			if (gixiy(v2) == HL) {
				outab(0xd4);
				outrb(&e1, R_USGN);
				break;
			}
 		}
		/*
		 * ld  (mn),bc	[(#mn),bc]
		 * ld  (mn),de	[(#mn),de]
		 * ld  (mn),hl	[(#mn),hl]
		 * ld  (mn),sp	[(#mn),sp]
		 * ld  (mn),ix	[(#mn),ix]
		 * ld  (mn),iy	[(#mn),iy]
		 */
		if ((t1 == S_INDM) && (t2 == S_R16)) {
			if (preByte.altd)
				err('o');
			if (gixiy(v2) == HL) {
				outab(0x22);
			} else {
				outab(0xED);
				outab(0x43 | (v2<<4));
			}
			outrw(&e1, 0);
			break;
		}
		/*
		 * ld  (hl),r
		 * ld  (ix+d),r
		 * ld  (iy+d),r
		 */
		if ((t2 == S_R8) && (gixiy(t1) == S_IDHL)) {
			if ((t1 == S_IDHL) && ((e1.e_base.e_ap != NULL) || (e1.e_addr != 0)))
				aerr();
			if (preByte.altd)
				err('o');
			outab(0x70|v2);
			if (t1 != S_IDHL)
				outrb(&e1, R_SGND);
			break;
		}
		/*
		 * ld  (hl),n  		[(hl),#n]
		 * ld  (ix+d),n		[(ix+d),#n]
		 * ld  (iy+d),n		[(iy+d),#n]
		 */
		if ((t2 == S_IMMED) && (gixiy(t1) == S_IDHL)) {
			if ((t1 == S_IDHL) && ((e1.e_base.e_ap != NULL) || (e1.e_addr != 0)))
				aerr();
			if (preByte.altd)
				err('o');
			outab(0x36);
			if (t1 != S_IDHL)
				outrb(&e1, R_SGND);
			outrb(&e2, 0);
			break;
		}
		/*
		 * ld  sp,hl
		 * ld  sp,ix
		 * ld  sp,iy
		 */
		if ((t1 == S_R16) && (v1 == SP)) {
			if ((t2 == S_R16) && (gixiy(v2) == HL)) {
				if (preByte.altd || preByte.ioe || preByte.ioi)
					err('o');
				outab(0xF9);
				break;
			}
		}
		/*
		 * ld  hl,ix
		 * ld  hl,iy
		 */
                if ((t1 == S_R16) && (v1 == HL) &&
		    (t2 == S_R16) && ((v2 == IX) || (v2 == IY))) {
			if (mchtyp != X_R2K)
				aerr();
			if (preByte.ioe || preByte.ioi)
				err('o');
			if (v2 == IX)
				outab(0xDD);
			if (v2 == IY)
				outab(0xFD);
			outab(0x7C);
			break;
		}
		/*
		 * ld  ix,hl
		 * ld  iy,hl
		 */
                if ((t2 == S_R16) && (v2 == HL) &&
		    (t1 == S_R16) && ((v1 == IX) || (v1 == IY))) {
			if (mchtyp != X_R2K)
				aerr();
			if (preByte.altd || preByte.ioe || preByte.ioi)
				err('o');
			if (v1 == IX)
				outab(0xDD);
			if (v1 == IY)
				outab(0xFD);
			outab(0x7D);
			break;
		}
		/*
		 * ld  bc',bc
		 * ld  de',bc
		 * ld  hl',bc
		 *
		 * ld  bc',de
		 * ld  de',de
		 * ld  hl',de
		 */
  	        if ((t1 == S_R16ALT) && (t2 == S_R16)) {
			if (mchtyp != X_R2K)
				aerr();
			if (preByte.altd || preByte.ioe || preByte.ioi)
				err('o');
			if (v2 == BC) {
				if ((v1 == BC) || (v1 == DE) || (v1 == HL)) {
					outab(0xED);
					outab(0x49 | (v1 << 4));
					break;
				}
			} else
			if (v2 == DE) {
				if ((v1 == BC) || (v1 == DE) || (v1 == HL)) {
					outab(0xED);
					outab(0x41 | (v1 << 4));
					break;
				}
			}
		}
		aerr();
		break;

	case S_EX:
		t1 = addr(&e1);
		v1 = (int) e1.e_addr;
		comma(1);
		t2 = addr(&e2);
		v2 = (int) e2.e_addr;
		if (t2 == S_R16) {
			/*
			 * ex  (sp),hl
			 * ex  (sp),ix
			 * ex  (sp),iy
			 */
			if ((t1 == S_IDSP) && (e1.e_base.e_ap == NULL) && (v1 == 0)) {
				if (mchtyp == X_R2K) {
					if (preByte.altd) {
						if ((v2 == IX) || (v2 == IY))
							err('o');
					}
					if (v2 == HL) {
						outab(0xED);
						outab(0x54);
						break;
					}
 					if (gixiy(v2) == HL) {
						outab(0xe3);
						break;
					}
				} else {
					if (gixiy(v2) == HL) {
						outab(op);
						break;
					}
				}
			}
		}
		if (t1 == S_R16) {
			/*
			 * ex  hl,(sp)		[ex  (sp),hl]
			 * ex  ix,(sp)		[ex  (sp),ix]
			 * ex  iy,(sp)		[ex  (sp),iy]
			 */
			if ((t2 == S_IDSP) && (e2.e_base.e_ap == NULL) && (v2 == 0)) {
				if (mchtyp == X_R2K) {
					if (preByte.altd) {
						if ((v1 == IX) || (v1 == IY))
							err('o');
					}
					if (v1 == HL) {
						outab(0xED);
						outab(0x54);
						break;
					}
 					if (gixiy(v1) == HL) {
						outab(0xE3);
						break;
					}
				} else {
					if (gixiy(v1) == HL) {
						outab(op);
						break;
					}
				}
			}
		}
		/*
		 * ex  af,af'
		 */
		if ((t1 == S_R16AF) && (v1 == AF) && (t2 == S_R16ALT) && (v2 == AF)) {
			if (preByte.altd)
				err('o');
			outab(0x08);
			break;
		}
		/*
		 * ex  af',af		[ex  af,af']
		 */
		if ((t2 == S_R16AF) && (v2 == AF) && (t1 == S_R16ALT) && (v1 == AF)) {
			if (preByte.altd)
				err('o');
			outab(0x08);
			break;
		}
		/*
		 * ex  de,hl
		 * ex  de,hl'
		 */
		if ((t1 == S_R16) && (v1 == DE)) {
			if ((t2 == S_R16) && (v2 == HL)) {
				outab(0xEB);
				break;
			}
			if ((mchtyp == X_R2K) && (t2 == S_R16ALT) && (v2 == HL)) {
				if (preByte.altd)
					err('o');
				outab(preByte.altd = 0x76);
				outab(0xEB);
				break;
			}
		}
		/*
		 * ex  de',hl
		 * ex  de',hl'
		 */
		if ((mchtyp == X_R2K) && (t1 == S_R16ALT) && (v1 == DE)) {
			if ((t2 == S_R16) && (v2 == HL)) {
				outab(0xE3);
				break;
			}
			if ((t2 == S_R16ALT) && (v2 == HL)) {
				if (preByte.altd)
					err('o');
				outab(preByte.altd = 0x76);
				outab(0xE3);
				break;
			}
		}
		aerr();
		break;

	case S_IN:
	case S_OUT:
		if (mchtyp == X_R2K) {
			err('o');
		}
		if (rf == S_IN) {	/* in  */
			t1 = addr(&e1);
			comma(1);
			t2 = addr(&e2);
		} else {		/* out */
			t2 = addr(&e2);
			comma(1);
			t1 = addr(&e1);
		}
		v1 = (int) e1.e_addr;
		v2 = (int) e2.e_addr;
		if (t1 == S_R8) {
			/*
			 * in   a,(n)	[in   a,(#n)]
			 * out  (n),a	[out  (#n),a]
			 */
			if ((v1 == A) && (t2 == S_INDM)) {
				outab(op);
				outrb(&e2, R_USGN);
				break;
			}
			/*
			 * in   r,(c)
			 * out  (c),r
			 */
			if (t2 == S_IDC) {
				outab(0xED);
				outab(((rf == S_IN) ? 0x40 : 0x41) + (v1<<3));
				break;
			}
		}
		aerr();
		break;

	case S_DEC:
	case S_INC:
		t1 = addr(&e1);
		v1 = (int) e1.e_addr;
		if (preByte.ioi || preByte.ioe) {
			if ((t1 != S_IDHL) && (t1 != S_IDIX) && (t1 != S_IDIY))
				err('o');
		}
		/*
		 * op  r
		 */
		if (t1 == S_R8) {
			outab(op|(v1<<3));
			break;
		}
		/*
		 * op  bc
		 * op  de
		 * op  hl
		 * op  sp
		 * op  ix
		 * op  iy
		 */
		if (t1 == S_R16) {
		        if (preByte.altd || preByte.ioi || preByte.ioe) {
				if ((v1 == IX) || (v1 == IY))
					err('o');
			}
			v1 = gixiy(v1);
			if (rf == S_INC) {
				outab(0x03|(v1<<4));
				break;
			}
			if (rf == S_DEC) {
				outab(0x0B|(v1<<4));
				break;
			}
		}
		/*
		 * op  (hl)
		 */
		if (t1 == S_IDHL) {
			if ((e1.e_base.e_ap != NULL) || (e1.e_addr != 0))
				aerr();
			outab(op|0x30);
			break;
		}
		/*
		 * op  (ix+d)
		 * op  (iy+d)
		 */
		if (t1 != gixiy(t1)) {
			outab(op|0x30);
			outrb(&e1, R_SGND);
			break;
		}
		aerr();
		break;

	case S_DJNZ:
	case S_JR:
		/*
		 * jr  cc,e
		 */
		if (rf == S_JR && (v1 = admode(CND)) != 0) {
			if ((v1 &= 0xFF) <= 0x03) {
				op += (v1+1)<<3;
			} else {
				aerr();
			}
			comma(1);
		}
		/*
		 * jr  e
		 */
		expr(&e2, 0);
		outab(op);
		if (mchpcr(&e2)) {
			v2 = (int) (e2.e_addr - dot.s_addr - 1);
			if ((v2 < -128) || (v2 > 127))
				aerr();
			outab(v2);
		} else {
			outrb(&e2, R_PCR);
		}
		if (e2.e_mode != S_USER)
			rerr();
		break;

	case S_CALL:
		if (mchtyp == X_R2K) {
		/*
		 * call  n
		 */
			op = 0xCD;
		} else {
		/*
		 * call  cc,n
		 */
			if ((v1 = admode(CND)) != 0) {
				op |= (v1&0xFF)<<3;
				comma(1);
			} else {
				op = 0xCD;
			}
		}
		expr(&e1, 0);
		outab(op);
		outrw(&e1, 0);
		break;

	case S_JP:
		/*
		 * jp  cc,mn
		 */
		if ((v1 = admode(CND)) != 0) {
			op |= (v1&0xFF)<<3;
			comma(1);
			expr(&e1, 0);
			outab(op);
			outrw(&e1, 0);
			break;
		}
		/*
		 * jp  mn
		 */
		t1 = addr(&e1);
		if (t1 == S_USER) {
			outab(0xC3);
			outrw(&e1, 0);
			break;
		}
		/*
		 * jp  (hl)
		 * jp  (ix)
		 * jp  (iy)
		 */
		if (gixiy(t1) == S_IDHL) {
			if ((e1.e_base.e_ap != NULL) || (e1.e_addr != 0))
				aerr();
			outab(0xE9);
			break;
		}
		aerr();
		break;

	case HD_INH2:
		if (mchtyp != X_HD64)
			err('o');
		outab(0xED);
		outab(op);
		break;

	case HD_IN:
	case HD_OUT:
		if (mchtyp != X_HD64)
			err('o');
		if (rf == HD_IN) {
			t1 = addr(&e1);
			comma(1);
			t2 = addr(&e2);
		} else {
			t2 = addr(&e2);
			comma(1);
			t1 = addr(&e1);
		}
		/*
		 * op  r,(mn)
		 * op  (mn),r
		 */
		if ((t1 == S_R8) && (t2 == S_INDM)) {
			outab(0xED);
			outab(op | (e1.e_addr<<3));
			outrb(&e2, 0);
			break;
		}
		aerr();
		break;

	case HD_MLT:
		if (mchtyp != X_HD64)
			err('o');
		t1 = addr(&e1);
		/*
		 * mlt  bc/de/hl/sp
		 */
		if ((t1 == S_R16) && ((v1 = (int) e1.e_addr) <= SP)) {
			outab(0xED);
			outab(op | (v1<<4));
			break;
		}
		aerr();
		break;

	case HD_TST:
		if (mchtyp != X_HD64)
			err('o');
		t1 = addr(&e1);
		if (t1 == S_USER)
			t1 = e1.e_mode = S_IMMED;
		/*
		 * tst  r
		 */
		if (t1 == S_R8) {
			outab(0xED);
			outab(op | (e1.e_addr<<3));
			break;
		}
		/*
		 * tst  (hl)
		 */
		if (t1 == S_IDHL) {
			outab(0xED);
			outab(0x34);
			break;
		}
		/*
		 * tst  n	[tst  #n]
		 */
		if (t1 == S_IMMED) {
			outab(0xED);
			outab(0x64);
			outrb(&e1, 0);
			break;
		}
		aerr();
		break;

	case HD_TSTIO:
		if (mchtyp != X_HD64)
			err('o');
		t1 = addr(&e1);
		if (t1 == S_USER)
			t1 = e1.e_mode = S_IMMED;
		/*
		 * tstio  (n)		[tstio  (#n)]
		 */
		if (t1 == S_IMMED) {
			outab(0xED);
			outab(op);
			outrb(&e1, 0);
			break;
		}
		aerr();
		break;

	case RB_IPSET:
		if (mchtyp != X_R2K)
			err('o');
	        v1 = (int) absexpr();
		if (v1 > 3) {
			aerr();
			v1 &= 0x03;
		}
		if(v1 > 1) {
			op = 0x4E;
			v1 = v1 - 2;
		}
		/*
		 * ipset  1/2/3/4
		 */
		outab(0xED);
		outab(op | (v1 << 4));
	        break;

	case RB_LCALL:
		if (mchtyp != X_R2K)
			err('o');
		t1 = addr(&e1);
		v1 = (int) e1.e_addr;
		comma(1);
		t2 = addr(&e2);
		v2 = (int) e2.e_addr;
		/*
		 * lcall  xpc,mn
		 * ljp    nbr,mn
		 */
		if ((t1 == S_USER) && (t2 == S_USER)) {
			outab(op);
			outrw(&e2, 0);
			outrb(&e1, 0);
		} else {
			aerr();
		}
		break;

	case RB_LDP:
		if (mchtyp != X_R2K)
			err('o');
		t1 = addr(&e1);
		v1 = (int) e1.e_addr;
		comma(1);
		t2 = addr(&e2);
		v2 = (int) e2.e_addr;
		/*
		 * ldp  (mn),hl
		 * ldp  (mn),ix
		 * ldp  (mn),iy
		 */
		if ((t1 == S_INDM) && (t2 == S_R16)) {  
			if ((v2 != HL) && (v2 != IX) && (v2 != IY)) {
				aerr();
				break;
			}
			if (v2 == HL) {		
				outab(0xed);
			} else {
				gixiy(v2);
			}
			outab(op+1);
			outrw(&e1,0);
			break;
		}
		/*
		 * ldp  hl,(mn)
		 * ldp  ix,(mn)
		 * ldp  iy,(mn)
		 */
		if ((t1 == S_R16) && (t2 == S_INDM)) {
			if ((v1 != HL) && (v1 != IX) && (v1 != IY)) {
				aerr();
				break;
			}
			if (v1 == HL) {
				outab(0xed);
			} else {
				gixiy(v1);
			}
			outab((op+1)|0x08);
			outrw(&e2,0);
			break;
		}
		/*
		 * ldp  (hl),hl
		 * ldp  (ix),hl
		 * ldp  (iy),hl
		 */
		if ((t2 == S_R16) && (v2 == HL)) {
			if ((t1 != S_IDHL) && (t1 != S_IDIX) && (t1 != S_IDIY)) {
				aerr();
				break;
			}
			if ((e1.e_base.e_ap != NULL) || (v1 != 0)) {
				aerr();
				break;
			}
			if (t1 == S_IDHL) {
				outab(0xed);
			} else {
				gixiy(t1);
			}
			outab(op);
			break;
		}
		/*
		 * ldp  hl,(hl)
		 * ldp  hl,(ix)
		 * ldp  hl,(iy)
		 */
		if ((t1 == S_R16) && (v1 == HL)) {
			if ((t2 != S_IDHL) && (t2 != S_IDIX) && (t2 != S_IDIY)) {
				aerr();
				break;
			}
			if ((e2.e_base.e_ap != NULL) || (v2 != 0)) {
				aerr();
				break;
			}
			if (t2 == S_IDHL) {
				outab(0xed);
			} else {
				gixiy(t2);
			}
			outab(op|0x08);
			break;
		}
		aerr();
		break;

	case RB_BOOL:
		if (mchtyp != X_R2K)
			err('o');
		t1 = addr(&e1);
		v1 = (int) e1.e_addr;
		/*
		 * bool  hl
		 * bool  ix
		 * bool  iy
		 */
		if (t1 == S_R16) {
			if ((v1 == HL) || (v1 == IX) || (v1 == IY)) {
				gixiy(v1);
				outab(op);
			} else {
				aerr();
			}
		} else {
			aerr();
		}
		break;

	default:
		opcycles = OPCY_ERR;
		err('o');
		break;
	}

	if (opcycles == OPCY_NONE) {
		switch (mchtyp) {
		case X_R2K:
			of = (preByte.altd || preByte.ioe || preByte.ioi) ? 1 : 0;
			opcycles = rabpg1[cb[of + 0] & 0xFF];
			while ((opcycles & OPCY_NONE) && (opcycles & OPCY_MASK)) {
				switch (opcycles) {
				case P2:	/* CB xx	*/
				case P3:	/* DD xx	*/
				case P4:	/* ED xx	*/
				case P5:	/* FD xx	*/
					opcycles = rabPage[opcycles & OPCY_MASK][cb[of + 1] & 0xFF];
					break;
				case P6:	/* DD CB -- xx	*/
				case P7:	/* FD CB -- xx	*/
					opcycles = rabPage[opcycles & OPCY_MASK][cb[of + 3] & 0xFF];
					break;
				default:
					opcycles = OPCY_NONE;
					break;
				}
			}
			if (of) {
				opcycles += 2;
			}
			break;

		case X_HD64:
			opcycles = hd64pg1[cb[0] & 0xFF];
			while ((opcycles & OPCY_NONE) && (opcycles & OPCY_MASK)) {
				switch (opcycles) {
				case P2:	/* CB xx	*/
				case P3:	/* DD xx	*/
				case P4:	/* ED xx	*/
				case P5:	/* FD xx	*/
					opcycles = hd64Page[opcycles & OPCY_MASK][cb[1] & 0xFF];
					break;
				case P6:	/* DD CB -- xx	*/
				case P7:	/* FD CB -- xx	*/
					opcycles = hd64Page[opcycles & OPCY_MASK][cb[3] & 0xFF];
					break;
				default:
					opcycles = OPCY_NONE;
					break;
				}
			}
			break;

		case X_Z80:
			opcycles = z80pg1[cb[0] & 0xFF];
			while ((opcycles & OPCY_NONE) && (opcycles & OPCY_MASK)) {
				switch (opcycles) {
				case P2:	/* CB xx	*/
				case P3:	/* DD xx	*/
				case P4:	/* ED xx	*/
				case P5:	/* FD xx	*/
					opcycles = z80Page[opcycles & OPCY_MASK][cb[1] & 0xFF];
					break;
				case P6:	/* DD CB -- xx	*/
				case P7:	/* FD CB -- xx	*/
					opcycles = z80Page[opcycles & OPCY_MASK][cb[3] & 0xFF];
					break;
				default:
					opcycles = OPCY_NONE;
					break;
				}
			}
			break;

		default:
			break;
		}
	}
	clrPreByte();
}

/*
 * general addressing evaluation
 * return(0) if general addressing mode output, else
 * return(esp->e_mode)
 */
int
genop(pop, op, esp, f)
int pop, op;
struct expr *esp;
int f;
{
	int t1;
	/*
	 * r
	 */
	if ((t1 = esp->e_mode) == S_R8) {
		if (pop)
			outab(pop);
		outab(op|esp->e_addr);
		return(0);
	}
	/*
	 * (hl)
	 */
	if (t1 == S_IDHL) {
		if ((esp->e_base.e_ap != NULL) || (esp->e_addr != 0))
			aerr();
		if (pop)
			outab(pop);
		outab(op|0x06);
		return(0);
	}
	/*
	 * (ix) / (ix+d)
	 * (iy) / (iy+d)
	 */
	if (gixiy(t1) == S_IDHL) {
		if (pop) {
			outab(pop);
			outrb(esp, R_SGND);
			outab(op|0x06);
		} else {
			outab(op|0x06);
			outrb(esp, R_SGND);
		}
		return(0);
	}
	/*
	 *  n
	 * #n
	 */
	if ((t1 == S_IMMED) && (f)) {
		if (pop)
			outab(pop);
		outab(op|0x46);
		outrb(esp,0);
		return(0);
	}
	return(t1);
}

/*
 * IX and IY prebyte check
 */
int
gixiy(v)
int v;
{
	if (v == IX) {
		v = HL;
		outab(0xDD);
	} else if (v == IY) {
		v = HL;
		outab(0xFD);
	} else if (v == S_IDIX) {
		v = S_IDHL;
		outab(0xDD);
	} else if (v == S_IDIY) {
		v = S_IDHL;
		outab(0xFD);
	}
	return(v);
}

VOID 
clrPreByte()
{
	preByte.altd = 0;
	preByte.ioi  = 0;
	preByte.ioe  = 0;
}

VOID
chkIOPreByte(addrMode)
int addrMode;
{
	if (preByte.ioi || preByte.ioe) {
		if ((addrMode != S_IDHL) && (addrMode != S_IDIX) && (addrMode != S_IDIY))
			err('o');
	}
}

VOID
chkPreByte(mp)
struct mne *mp;
{
	if (preByte.altd) {
		outab(preByte.altd);
		if (!(mp->m_flag & P_ALTD))
			err('o');
	} else
	if (preByte.ioe) {
		outab(preByte.ioe);
		if (!(mp->m_flag & P_IO))
			err('o');
	} else
	if (preByte.ioi) {
		outab(preByte.ioi);
		if (!(mp->m_flag & P_IO))
			err('o');
	}
}

/*
 * Branch/Jump PCR Mode Check
 */
int
mchpcr(esp)
struct expr *esp;
{
	if (esp->e_base.e_ap == dot.s_area) {
		return(1);
	}
	if (esp->e_flag==0 && esp->e_base.e_ap==NULL) {
		/*
		 * Absolute Destination
		 *
		 * Use the global symbol '.__.ABS.'
		 * of value zero and force the assembler
		 * to use this absolute constant as the
		 * base value for the relocation.
		 */
		esp->e_flag = 1;
		esp->e_base.e_sp = &sym[1];
	}
	return(0);
}

/*
 * Machine dependent initialization
 */
VOID
minit()
{
	/*
	 * Byte Order
	 */
	hilo = 0;

	clrPreByte();
	if (pass == 0) {
		mchtyp = X_R2K;
		sym[2].s_addr = X_R2K;
	}
}


