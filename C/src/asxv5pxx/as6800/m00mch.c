/* m00mch.c */

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
 */

#include "asxxxx.h"
#include "m6800.h"

char	*cpu	= "Motorola 6800/6802/6808";
char	*dsft	= "asm";

/*
 * Opcode Cycle Definitions
 */
#define	OPCY_SDP	((char) (0xFF))
#define	OPCY_ERR	((char) (0xFE))

/*	OPCY_NONE	((char) (0x80))	*/
/*	OPCY_MASK	((char) (0x7F))	*/

#define	UN	((char) (OPCY_NONE | 0x00))

/*
 * 6800 Cycle Count
 *
 *	opcycles = m00cyc[opcode]
 */
char m00cyc[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/  UN, 2,UN,UN,UN,UN, 2, 2, 4, 4, 2, 2, 2, 2, 2, 2,
/*10*/   2, 2,UN,UN,UN,UN, 2, 2,UN, 2,UN, 2,UN,UN,UN,UN,
/*20*/   4,UN, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
/*30*/   4, 4, 4, 4, 4, 4, 4, 4,UN, 5,UN,10,UN,UN, 9,12,
/*40*/   2,UN,UN, 2, 2,UN, 2, 2, 2, 2, 2,UN, 2, 2,UN, 2,
/*50*/   2,UN,UN, 2, 2,UN, 2, 2, 2, 2, 2,UN, 2, 2,UN, 2,
/*60*/   7,UN,UN, 7, 7,UN, 7, 7, 7, 7, 7,UN, 7, 7, 4, 7,
/*70*/   6,UN,UN, 6, 6,UN, 6, 6, 6, 6, 6,UN, 6, 6, 3, 6,
/*80*/   2, 2, 2,UN, 2, 2, 2,UN, 2, 2, 2, 2, 3, 8, 3,UN,
/*90*/   3, 3, 3,UN, 3, 3, 3, 4, 3, 3, 3, 3, 4,UN, 4, 5,
/*A0*/   5, 5, 5,UN, 5, 5, 5, 6, 5, 5, 5, 5, 6, 8, 6, 7,
/*B0*/   4, 4, 4,UN, 4, 4, 4, 5, 4, 4, 4, 4, 5, 9, 5, 6,
/*C0*/   2, 2, 2,UN, 2, 2, 2,UN, 2, 2, 2, 2,UN,UN, 3,UN,
/*D0*/   3, 3, 3,UN, 3, 3, 3, 4, 3, 3, 3, 3,UN,UN, 4, 5,
/*E0*/   5, 5, 5,UN, 5, 5, 5, 6, 5, 5, 5, 5,UN,UN, 6, 7,
/*F0*/   4, 4, 4,UN, 4, 4, 4, 5, 4, 4, 4, 4,UN,UN, 5, 6
};

/*
 * Process a machine op.
 */
VOID
machine(mp)
struct mne *mp;
{
	int op, t1;
	struct expr e1;
	struct area *espa;
	char id[NCPS];
	int c, v1, reg;

	clrexpr(&e1);
	reg = 0;
	op = (int) mp->m_valu;
	switch (mp->m_type) {

	case S_SDP:
		opcycles = OPCY_SDP;
		espa = NULL;
		if (more()) {
			expr(&e1, 0);
			if (e1.e_flag == 0 && e1.e_base.e_ap == NULL) {
				if (e1.e_addr) {
					err('b');
				}
			}
			if ((c = getnb()) == ',') {
				getid(id, -1);
				espa = alookup(id);
				if (espa == NULL) {
					err('u');
				}
			} else {
				unget(c);
			}
		}
		if (espa) {
			outdp(espa, &e1, 0);
		} else {
			outdp(dot.s_area, &e1, 0);
		}
		lmode = SLIST;
		break;

	case S_INH:
		outab(op);
		break;

	case S_PUL:
		v1 = admode(abx);
		if (v1 == S_A) {
			outab(op);
			break;
		}
		if (v1 == S_B) {
			outab(op+1);
			break;
		}
		aerr();
		break;

	case S_BRA:
		expr(&e1, 0);
		outab(op);
		if (mchpcr(&e1)) {
			v1 = (int) (e1.e_addr - dot.s_addr - 1);
			if ((v1 < -128) || (v1 > 127))
				aerr();
			outab(v1);
		} else {
			outrb(&e1, R_PCR);
		}
		if (e1.e_mode != S_USER)
			rerr();
		break;

	case S_TYP1:
		t1 = addr(&e1);
		if (t1 == S_A) {
			outab(op|A);
			break;
		}
		if (t1 == S_B) {
			outab(op|B);
			break;
		}
		if ((t1 == S_EXT) || (t1 == S_DIR)) {
			outab(op|0x30);
			outrw(&e1, 0);
			break;
		}
		if (t1 == S_INDX) {
			outab(op|X);
			outrb(&e1, R_USGN);
			break;
		}
		aerr();
		break;

	case S_TYP2:
		if ((reg = admode(abx)) == 0)
			aerr();

	case S_TYP3:
		if (!reg) {
			reg = op & 0x40;
		} else if (reg == S_A) {
			reg = 0x00;
		} else if (reg == S_B) {
			reg = 0x40;
		} else {
			aerr();
			reg = 0x00;
		}
		t1 = addr(&e1);
		if (t1 == S_IMMED) {
			if ((op|0x40) == 0xC7)
				aerr();
			outab(op|reg);
			outrb(&e1, 0);
			break;
		}
		if (t1 == S_EXT) {
			outab(op|reg|0x30);
			outrw(&e1, 0);
			break;
		}
		if (t1 == S_DIR) {
			outab(op|reg|0x10);
			outrb(&e1, R_PAG0);
			break;
		}
		if (t1 == S_INDX) {
			outab(op|reg|0x20);
			outrb(&e1, R_USGN);
			break;
		}
		aerr();
		break;

	case S_TYP4:
		t1 = addr(&e1);
		if (t1 == S_IMMED) {
			if ((op&0x0D) == 0x0D)
				aerr();
			outab(op);
			outrw(&e1, 0);
			break;
		}
		if (t1 == S_EXT) {
			outab(op|0x30);
			outrw(&e1, 0);
			break;
		}
		if (t1 == S_DIR) {
			outab(op|0x10);
			outrb(&e1, R_PAG0);
			break;
		}
		if (t1 == S_INDX) {
			outab(op|0x20);
			outrb(&e1, R_USGN);
			break;
		}
		aerr();
		break;

	case S_TYP5:
		t1 = addr(&e1);
		if ((t1 == S_EXT) || (t1 == S_DIR)) {
			outab(op|0x10);
			outrw(&e1, 0);
			break;
		}
		if (t1 == S_INDX) {
			outab(op);
			outrb(&e1, R_USGN);
			break;
		}
		aerr();
		break;

	default:
		opcycles = OPCY_ERR;
		err('o');
		break;
	}

	if (opcycles == OPCY_NONE) {
		opcycles = m00cyc[cb[0] & 0xFF];
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
	hilo = 1;
}
