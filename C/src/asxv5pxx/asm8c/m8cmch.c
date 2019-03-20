/* m8cmch.c */

/*
 *  Copyright (C) 2009  Alan R. Baldwin
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
 */

#include <stdio.h>
#include <setjmp.h>
#include "asxxxx.h"
#include "m8c.h"

char	*cpu	= "Cypress M8C";
char	*dsft	= "asm";

/*
 * Opcode Cycle Definitions
 */
#define	OPCY_ERR	((char) (0xFE))

/*	OPCY_NONE	((char) (0x80))	*/
/*	OPCY_MASK	((char) (0x7F))	*/

/*
 * M8C Cycle Count
 *
 *	opcycles = m8ccyc[opcode]
 */
static char m8ccyc[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/  15, 4, 6, 7, 7, 8, 9,10, 4, 4, 6, 7, 7, 8, 9,10,
/*10*/   4, 4, 6, 7, 7, 8, 9,10, 5, 4, 6, 7, 7, 8, 9,10,
/*20*/   5, 4, 6, 7, 7, 8, 9,10,11, 4, 6, 7, 7, 8, 9,10,
/*30*/   9, 4, 6, 7, 7, 8, 9,10, 5, 5, 7, 8, 8, 9,10,10,
/*40*/   4, 9,10, 9,10, 9,10, 8, 9, 9,10, 5, 7, 7, 5, 4,
/*50*/   4, 5, 6, 5, 6, 8, 9, 4, 6, 7, 5, 4, 4, 6, 7,10,
/*60*/   5, 6, 8, 9, 4, 7, 8, 4, 7, 8, 4, 7, 8, 4, 7, 8,
/*70*/   4, 4, 4, 4, 4, 4, 7, 8, 4, 4, 7, 8,13, 7,10, 8,
/*80*/   5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
/*90*/   4, 4, 4, 6, 4, 4, 4, 4, 4, 4, 4, 4, 6, 7, 5, 5,
/*A0*/  11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,
/*B0*/   5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
/*C0*/   5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
/*D0*/   5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
/*E0*/   7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
/*F0*/  13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13
};

/*
 * Process a machine op.
 */
VOID
machine(mp)
struct mne *mp;
{
	int op;
	int t1, v1;
	int t2, v2;
	struct expr e1, e2;

	clrexpr(&e1);
	clrexpr(&e2);
	op = mp->m_valu;
	switch (mp->m_type) {

	case S_MATH:
		t1 = addr(&e1);
		v1 = 1;
		comma(1);
		t2 = addr(&e2);
		v2 = 1;
		if (t1 == S_A) {
			switch (t2) {
			case S_IMM:	v2 = 1;	break;
			case S_EXT:	v2 = 2;	break;
			case S_INDX:	v2 = 3;	break;
			default:	aerr();
					opcycles = OPCY_ERR;
					return;
			}
			outab(op + v2);
			outrb(&e2, R_USGN);
		} else
		if ((t1 == S_SP) && (op == 0x00)) {
			switch (t2) {
			case S_IMM:		break;
			default:	aerr();
					opcycles = OPCY_ERR;
					return;
			}
			outab(op + 0x38);
			outrb(&e2, R_USGN);
		} else
		if (t2 == S_A) {
			switch (t1) {
			case S_EXT:	v1 = 4;	break;
			case S_INDX:	v1 = 5;	break;
			default:	aerr();
					opcycles = OPCY_ERR;
					return;
			}
			outab(op + v1);
			outrb(&e1, R_USGN);
		} else
		if (t2 == S_IMM) {
			switch (t1) {
			case S_EXT:	v1 = 6;	break;
			case S_INDX:	v1 = 7;	break;
			default:	aerr();
					opcycles = OPCY_ERR;
					return;
			}
			outab(op + v1);
			outrb(&e1, R_USGN);
			outrb(&e2, R_USGN);
		} else {
			aerr();
			opcycles = OPCY_ERR;
			return;
		}
		break;

	case S_CMP:
		t1 = addr(&e1);
		v1 = 1;
		comma(1);
		t2 = addr(&e2);
		v2 = 1;
		if (t1 == S_A) {
			switch (t2) {
			case S_IMM:	v2 = 1;	break;
			case S_EXT:	v2 = 2;	break;
			case S_INDX:	v2 = 3;	break;
			default:	aerr();
					opcycles = OPCY_ERR;
					return;
			}
			outab(op + v2);
			outrb(&e2, R_USGN);
		} else
		if (t2 == S_IMM) {
			switch (t1) {
			case S_EXT:	v1 = 4;	break;
			case S_INDX:	v1 = 5;	break;
			default:	aerr();
					opcycles = OPCY_ERR;
					return;
			}
			outab(op + v1);
			outrb(&e1, R_USGN);
			outrb(&e2, R_USGN);
		} else {
			aerr();
			opcycles = OPCY_ERR;
			return;
		}
		break;

	case S_LGC:
		t1 = addr(&e1);
		v1 = 1;
		comma(1);
		t2 = addr(&e2);
		v2 = 1;
		if (t1 == S_A) {
			switch (t2) {
			case S_IMM:	v2 = 1;	break;
			case S_EXT:	v2 = 2;	break;
			case S_INDX:	v2 = 3;	break;
			default:	aerr();
					opcycles = OPCY_ERR;
					return;
			}
			outab(op + v2);
			outrb(&e2, R_USGN);
		} else
		if (t2 == S_A) {
			switch (t1) {
			case S_EXT:	v1 = 4;	break;
			case S_INDX:	v1 = 5;	break;
			default:	aerr();
					opcycles = OPCY_ERR;
					return;
			}
			outab(op + v1);
			outrb(&e1, R_USGN);
		} else
		if (t2 == S_IMM) {
			switch (t1) {
			case S_EXT:	v1 = 6;	break;
			case S_INDX:	v1 = 7;	break;
			case S_F:	v1 = 0;	break;
			case S_REXT:	v1 = 1;	break;
			case S_RINDX:	v1 = 2; break;
			default:	aerr();
					opcycles = OPCY_ERR;
					return;
			}
			if (v1 == 0) {
				switch (op) {
				case 0x20:	op = 0x70;	break;
				case 0x28:	op = 0x71;	break;
				case 0x30:	op = 0x72;	break;
				default:	aerr();
						opcycles = OPCY_ERR;
						return;
				}
			} else
			if ((v1 == 1) || (v1 == 2)) {
				switch (op) {
				case 0x20:	op = 0x40;	break;
				case 0x28:	op = 0x42;	break;
				case 0x30:	op = 0x44;	break;
				default:	aerr();
						opcycles = OPCY_ERR;
						return;
				}
			}
			outab(op + v1);
			if (v1 != 0) {
				outrb(&e1, R_USGN);
			}
			outrb(&e2, R_USGN);
		} else {
			aerr();
			opcycles = OPCY_ERR;
			return;
		}
		break;

	case S_SHFT:
		t1 = addr(&e1);
		v1 = 1;
		switch (t1) {
		case S_A:	v1 = 0;	break;
		case S_EXT:	v1 = 1;	break;
		case S_INDX:	v1 = 2;	break;
		default:	aerr();
				opcycles = OPCY_ERR;
				return;
		}
		outab(op + v1);
		if (v1 != 0) {
			outrb(&e1, R_USGN);
		}
		break;

	case S_CPL:
		t1 = addr(&e1);
		v1 = 1;
		if (t1 != S_A) {
			aerr();
			opcycles = OPCY_ERR;
			return;
		}
		outab(op);
		break;

	case S_CNT:
		t1 = addr(&e1);
		v1 = 1;
		switch (t1) {
		case S_A:	v1 = 0;	break;
		case S_X:	v1 = 1;	break;
		case S_EXT:	v1 = 2;	break;
		case S_INDX:	v1 = 3;	break;
		default:	aerr();
				opcycles = OPCY_ERR;
				return;
		}
		outab(op + v1);
		if ((v1 == 2) || (v1 == 3)) {
			outrb(&e1, R_USGN);
		}
		break;

	case S_TST:
		t1 = addr(&e1);
		v1 = 1;
		comma(1);
		t2 = addr(&e2);
		v2 = 1;
		if (t2 == S_IMM) {
			switch (t1) {
			case S_EXT:	v1 = 0;	break;
			case S_INDX:	v1 = 1;	break;
			case S_REXT:	v1 = 2;	break;
			case S_RINDX:	v1 = 3;	break;
			default:	aerr();
					opcycles = OPCY_ERR;
					return;
			}
		} else {
			aerr();
			opcycles = OPCY_ERR;
			return;
		}
		outab(op + v1);
		outrb(&e1, R_USGN);
		outrb(&e2, R_USGN);
		break;

	case S_SWAP:
		t1 = addr(&e1);
		v1 = 1;
		comma(1);
		t2 = addr(&e2);
		v2 = 1;
		if (t2 == S_EXT) {
			switch (t1) {
			case S_A:	v1 = 1;	break;
			case S_X:	v1 = 2;	break;
			default:	aerr();
					opcycles = OPCY_ERR;
					return;
			}
		} else
		if (t1 == S_A) {
			switch (t2) {
			case S_X:	v1 = 0;	break;
			case S_SP:	v1 = 3;	break;
			default:	aerr();
					opcycles = OPCY_ERR;
					return;
			}
		} else {
			aerr();
			opcycles = OPCY_ERR;
			return;
		}
		outab(op + v1);
		if (t2 == S_EXT) {
			outrb(&e2, R_USGN);
		}
		break;

	case S_MVI:
		t1 = addr(&e1);
		v1 = 0;
		comma(1);
		t2 = addr(&e2);
		v2 = 1;
		if ((t1 == S_A) && ((t2 == S_EXT) || (t2 == S_EXTIAU))) {
			outab(op + v1);
			outrb(&e2, R_USGN);
		} else
	 	if ((t2 == S_A) && ((t1 == S_EXT) || (t1 == S_EXTIAU))) {
			outab(op + v2);
			outrb(&e1, R_USGN);
		} else {
			aerr();
			opcycles = OPCY_ERR;
			return;
		}
		break;

	case S_MOV:
		t1 = addr(&e1);
		v1 = 0;
		comma(1);
		t2 = addr(&e2);
		v2 = 0;
		if (t1 == S_A) {
			switch (t2) {
			case S_IMM:	v2 = 0;		break;
			case S_EXT:	v2 = 1;		break;
			case S_INDX:	v2 = 2;		break;
			case S_X:	v2 = 11;	break;
			case S_REXT:	v2 = 13;	break;
			case S_RINDX:	v2 = 14;	break;
			default:	aerr();
					opcycles = OPCY_ERR;
					return;
			}
			outab(op + v2);
			if (t2 != S_X) {
				outrb(&e2, R_USGN);
			}
		} else
		if (t1 == S_X) {
			switch (t2) {
			case S_IMM:	v2 = 7;		break;
			case S_EXT:	v2 = 8;		break;
			case S_INDX:	v2 = 9;		break;
			case S_A:	v2 = 12;	break;
			case S_SP:	v2 = -1;	break;
			default:	aerr();
					opcycles = OPCY_ERR;
					return;
			}
			outab(op + v2);
			if ((t2 != S_A) && (t2 != S_SP)) {
				outrb(&e2, R_USGN);
			}
		} else
		if (t1 == S_EXT) {
			switch (t2) {
			case S_A:	v2 = 3;		break;
			case S_IMM:	v2 = 5;		break;
			case S_X:	v2 = 10;	break;
			case S_EXT:	v2 = 15;	break;
			default:	aerr();
					opcycles = OPCY_ERR;
					return;
			}
			outab(op + v2);
			outrb(&e1, R_USGN);
			if ((t2 != S_A) && (t2 != S_X)) {
				outrb(&e2, R_USGN);
			}
		} else
		if (t1 == S_INDX) {
			switch (t2) {
			case S_A:	v2 = 4;		break;
			case S_IMM:	v2 = 6;		break;
			default:	aerr();
					opcycles = OPCY_ERR;
					return;
			}
			outab(op + v2);
			outrb(&e1, R_USGN);
			if (t2 == S_IMM) {
				outrb(&e2, R_USGN);
			}
		} else
		if (t1 == S_REXT) {
			switch (t2) {
			case S_A:	v2 = 16;	break;
			case S_IMM:	v2 = 18;	break;
			default:	aerr();
					opcycles = OPCY_ERR;
					return;
			}
			outab(op + v2);
			outrb(&e1, R_USGN);
			if (t2 == S_IMM) {
				outrb(&e2, R_USGN);
			}
		} else
		if (t1 == S_RINDX) {
			switch (t2) {
			case S_A:	v2 = 17;	break;
			case S_IMM:	v2 = 19;	break;
			default:	aerr();
					opcycles = OPCY_ERR;
					return;
			}
			outab(op + v2);
			outrb(&e1, R_USGN);
			if (t2 == S_IMM) {
				outrb(&e2, R_USGN);
			}
		} else {
			aerr();
			opcycles = OPCY_ERR;
			return;
		}
		break;


	case S_PUSH:
		t1 = addr(&e1);
		if (t1 == S_A) {
			outab(op);
			break;
		}
		if (t1 == S_X) {
			outab(op+0x08);
			break;
		}
		aerr();
		opcycles = OPCY_ERR;
		return;

	case S_INH:
		outab(op);
		break;

	case S_JMP:
		expr(&e1, 0);
		outab(op);
		outrw(&e1, R_NORM);
		break;

	case S_BRA:
		expr(&e1, 0);
		if (mchpcr(&e1)) {
			v1 = (int) (e1.e_addr - dot.s_addr - 1);
			if ((v1 < -2048) || (v1 > 2047)) {
				aerr();
			}
			outaw((op << 8) | (v1 & 0x0FFF));
		} else {
			outrwm(&e1, R_PCR1 | M_BRA, op << 8);
		}
		if (e1.e_mode != S_USER)
			rerr();
		break;


	default:
		opcycles = OPCY_ERR;
		err('o');
		return;
	}
	if (opcycles == OPCY_NONE) {
		opcycles = m8ccyc[cb[0] & 0xFF];
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
 * Machine Dependent Initialization
 */
VOID
minit()
{
	/*
	 * Byte Order
	 */
	hilo = 1;
}
