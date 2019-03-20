/* s6186mch.c */

/*
 *  Copyright (C) 2003-2009  Alan R. Baldwin
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
 * Ported for SC61860 by Edgar Puehringer
 */

#include "asxxxx.h"
#include "s61860.h"

char	*cpu	= "Sharp SC61860";
char	*dsft	= "asm";

/*
 * Opcode Cycle Definitions
 */
#define	OPCY_SDP	((char) (0xFF))
#define	OPCY_ERR	((char) (0xFE))

/*	OPCY_NONE	((char) (0x80))	*/
/*	OPCY_MASK	((char) (0x7F))	*/

#define	OPCY_SBASIC	((char) (0xFD))

#define	UN	((char) (OPCY_NONE | 0x00))

static char  s61860[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/   4, 4, 4, 4, 6, 6, 6, 6, 6, 6, 6, 6, 7, 7, 7, 7,
/*10*/   8, 5, 4, 4, 5, 5,UN,UN, 5, 7, 5, 7, 5, 5, 5, 4,
/*20*/   2, 2, 2, 2, 7, 7, 6, 6, 7, 7, 7, 7, 7, 7,UN,10,
/*30*/   2, 2, 2,UN, 3,11,UN, 4, 7, 7, 7, 7,UN,UN,UN,UN,
/*40*/   4, 4, 4, 4, 3, 3, 3, 3, 4, 4, 4, 4, 2, 2, 6, 0,
/*50*/   2, 2, 2, 3, 0, 3, 0, 3, 2, 2, 2, 2,UN, 3,UN, 3,
/*60*/   4, 4, 4, 4, 4, 4, 4, 4,UN, 3,UN, 4,UN,UN,UN, 0,
/*70*/   4, 4,UN,UN, 4, 4,UN,UN, 8, 6, 9,UN, 6, 6, 6, 6,
/*80*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*90*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*A0*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*B0*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*C0*/   4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 2,UN, 3,UN,
/*D0*/   2, 2, 2, 0, 6, 6, 6,UN, 2,UN, 2, 3,UN, 2,UN, 2,
/*E0*/   7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
/*F0*/   7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7
};

/*
 * Process machine ops.
 */
VOID
machine(mp)
struct mne *mp;
{
	unsigned int op;
	struct expr e1, e2;
       	int c, d, t1;

	clrexpr(&e1);
	clrexpr(&e2);
	op = (unsigned int) mp->m_valu;
	switch (mp->m_type) {

	case S_INH:
		outab(op);
		break;

	case S_CAL:
		t1 = addr(&e1);
		if (t1 != S_EXT) {
			aerr();
		}
		/*
		 *	CAL	label
		 */
		if (is_abs(&e1)) {
			if (e1.e_addr & ~0x1FFF) {
				aerr();
			}
			outaw((op << 8) | (e1.e_addr & 0x1FFF));
		} else {
			outrwm(&e1, R_PAG0 | R_13BIT, op << 8);
		}
		break;

	case S_ADI:
		t1 = addr(&e1);
		if ((t1 != S_IMM) && (t1 != S_EXT)) {
			aerr();
		}
		/*
		 *	ADI	#0x03
		 *	ADI	 0x03
		 */
		outab(op);
		outrb(&e1, 0);
		break;

	case S_LP:
		/*
		 *	LP	register
		 */
		t1 = addr(&e1);
		if (t1 != S_EXT) {
			aerr();
		}
		if (is_abs(&e1)) {
			if (e1.e_addr & ~0x3F) {
				aerr();
			}
			outab(op | (e1.e_addr & 0x3F));
		} else {
			outrbm(&e1, R_PAG0 | R_6BIT, op);
		}
		break;

	case S_JMP:
		t1 = addr(&e1);
		if (t1 != S_EXT) {
			aerr();
		}
		/*
		 *	JMP	label
		 */
		outab(op);
		outrw(&e1, 0);
		break;

	case S_JRP:
		t1 = addr(&e1);
		if (t1 != S_EXT) {
			aerr();
		}
		if (is_abs(&e1)) {
			/*
			 *	JRP	pbra-(.+1)
			 *	IX
			 *	IY
			 * pbra:
			 *
			 **** OR ***
			 *
			 *	JRP	3
			 *	IX
			 *	IY
			 * pbra:
			 */
			;
		} else
		if (mchpcr(&e1)) {
			/*
			 *	JRP	pbra
			 *		...
			 * pbra:
			 */
			e1.e_addr = e1.e_addr - (dot.s_addr + 1);
		} else {
			/*
			 *	LOOP	external
			 */
			abscheck(&e1);
		}
		outab(op);
		if (e1.e_addr & ~0xFF) {
			aerr();
		}
		outab(e1.e_addr & 0xFF);
		break;

	case S_JRM:
		t1 = addr(&e1);
		if (t1 != S_EXT) {
			aerr();
		}
		if (is_abs(&e1)) {
			/*
			 * mbra:
			 *	IX
			 *	IY
			 *	JRM	(.+1)-mbra
			 *
			 **** OR ***
			 *
			 * mbra:
			 *	IX
			 *	IY
			 *	JRM	3
			 */
			;
		} else
		if (mchpcr(&e1)) {
			/*
			 * mbra:
			 *		...
			 *	JRM	mbram
			 */
			e1.e_addr = (dot.s_addr + 1) - e1.e_addr;
		} else {
			/*
			 *	LOOP	external
			 */
			abscheck(&e1);
		}
		outab(op);
		if (e1.e_addr & ~0xFF) {
			aerr();
		}
		outab(e1.e_addr & 0xFF);
		break;

	case S_PTC:
		expr(&e1, 0);
		comma(1);
		expr(&e2, 0);
		outab(op);
		outrb(&e1, 0);
		outrw(&e2, 0);
		break;

	case S_CASE:
		expr(&e1, 0);
		comma(1);
		expr(&e2, 0);
		outrb(&e1, 0);
		outrw(&e2, 0);
		break;

        case S_DEFA:
		expr(&e1, 0);
		outrw(&e1, 0);
		break;

	case S_BASIC:
		opcycles = OPCY_SBASIC;
		do {
			if ((d = getnb()) == '\0') {
				qerr();
			}
			while ((c = getmap(d)) >= 0) {
				outab(ascii2sbasic(c));
			}
		} while ((c = getnb()) == ',');
		unget(c);
	        break;

	default:
		opcycles = OPCY_ERR;
		err('o');
		break;
	}

	if (opcycles == OPCY_NONE) {
		opcycles = s61860[cb[0] & 0xFF];
	}
}

/*
 * Covert ascii characters to SBASIC characters
 */
int
ascii2sbasic(c)
int c;
{
	if (((c >= '0') && (c <= '9')) ||
	    ((c >= 'A') && (c <= 'Z'))) {
		return (c + 16);
	}
	switch (c) {
	case ' ':	return(0x11);
	case '"':	return(0x12);
	case '?':	return(0x13);
	case '!':	return(0x14);
	case '#':	return(0x15);
	case '%':	return(0x16);
	case '$':	return(0x18);
	case ',':	return(0x1b);
	case ';':	return(0x1c);
	case ':':	return(0x1d);
	case '@':	return(0x1e);
	case '&':	return(0x1f);
	case '(':	return(0x30);
	case ')':	return(0x31);
	case '>':	return(0x32);
	case '<':	return(0x33);
	case '=':	return(0x34);
	case '+':	return(0x35);
	case '-':	return(0x36);
	case '*':	return(0x37);
	case '/':	return(0x38);
	case '^':	return(0x39);
	case '.':	return(0x4a);
	case '~':	return(0x4d);
	case '_':	return(0x4e);
	/*
	 * Extra mappings for characters not
	 * available in the ascii charset.
	 */
	case 'i':	return(0x10);  /* insertion mark */
	case 'y':	return(0x17);  /* yen */
	case 'p':	return(0x19);  /* pi */
	case 's':	return(0x1a);  /* square root */
	case 'e':	return(0x4b);  /* exponent */
	case 'b':
	case 'c':	return(0x4c);  /* block cursor */

	default:	return(c);
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
 * Machine specific init.
 */
VOID
minit()
{
	/*
	 * Byte Order
	 */
	hilo = 1;
}
