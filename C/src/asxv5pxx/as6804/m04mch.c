/* m04mch.c */

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
#include "m6804.h"

char	*cpu	= "Motorola 6804";
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
 * 6804 Cycle Count
 *
 *	opcycles = m04cyc[opcode]
 */
char m04cyc[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*10*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*20*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*30*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*40*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*50*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*60*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*70*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*80*/   4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
/*90*/   4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
/*A0*/  UN,UN,UN,UN,UN,UN,UN,UN, 4, 4, 4, 4, 4, 4, 4, 4,
/*B0*/   4,UN, 2, 2, 4, 4,UN,UN, 4, 4, 4, 4, 4, 4, 4, 4,
/*C0*/   5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
/*D0*/   4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
/*E0*/   4, 4, 4, 4, 4, 4, 4, 4, 4,UN, 4, 4, 4, 4,UN,UN,
/*F0*/   4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
};

/*
 * Process a machine op.
 */
VOID
machine(mp)
struct mne *mp;
{
	int op, t1, t2, type;
	struct expr e1, e2, e3;
	struct area *espa;
	int c, v1, v2, v3;
	char id[NCPS];

	clrexpr(&e1);
	clrexpr(&e2);
	clrexpr(&e3);
	op = (int) mp->m_valu;
	type = mp->m_type;
	switch (type) {

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

	case S_BRA:
		expr(&e1, 0);
		v1 = (int) (e1.e_addr - dot.s_addr - 1);
		if ((v1 < -16) || (v1 > 15))
			aerr();
		if (e1.e_base.e_ap != dot.s_area)
			rerr();
		outab(op | (v1&0x1F));
		break;

	case S_TYP1:
		expr(&e1, 0);
		v1 = (int) e1.e_addr;
		if ((v1 < -4096) || (v1 > 4095))
			aerr();
		e1.e_addr += op;
		outrw(&e1, 0);
		break;

	case S_TYP2:
	case S_TYP3:
		t1 = addr(&e1);
		if ((type == S_TYP3) & (t1 == S_IMMED)) {
			outab(op|0x08);
			outrb(&e1, 0);
			break;
		}
		if (t1 == S_DIR) {
			v1 = (int) e1.e_addr;
			if ((e1.e_base.e_ap == NULL) &
			    (v1 >= 0x80) & (v1 <= 0x83)) {
				v1 &= 0x03;
				if (op == 0xE0) {
					outab(0xAC | v1);
					break;
				}
				if (op == 0xE1) {
					outab(0xBC | v1);
					break;
				}
				if (op == 0xE6) {
					outab(0xA8 | v1);
					break;
				}
				if (op == 0xE7) {
					outab(0xB8 | v1);
					break;
				}
			}
			outab(op|0x18);
			outrb(&e1, R_PAG0);
			break;
		}
		if (t1 == S_IX) {
			outab(op);
			break;
		}
		if (t1 == S_IY) {
			outab(op|0x10);
			break;
		}
		aerr();
		break;

	case S_CLR:
		outab(0xB0);
		outab(op);
		outab(0x00);
		break;

	case S_LD:
		t1 = addr(&e1);
		if (t1 == S_IMMED) {
			outab(0xB0);
			outab(op);
			outrb(&e1, 0);
			break;
		}
		aerr();
		break;

	case S_MVI:
		t1 = addr(&e1);
		if (t1 != S_DIR)
			aerr();
		comma(1);
		t2 = addr(&e2);
		if (t2 != S_IMMED)
			aerr();
		outab(op);
		outrb(&e1, R_PAG0);
		outrb(&e2, 0);
		break;

	case S_APOST:
		outab(op);
		outab(0xFF);
		break;

	case S_BPM:
	case S_BXPM:
	case S_BYPM:
		v1 = 0xFF;
		if (type == S_BXPM)
			v1 = 0x80;
		if (type == S_BYPM)
			v1 = 0x81;
		expr(&e2, 0);
		outab(op);
		outab(v1);
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

	case S_BTB:
	case S_BSC:
		t1 = addr(&e1);
		if (t1 != S_IMMED || e1.e_addr & ~0x07)
			aerr();
		comma(1);
		t2 = addr(&e2);
		if (t2 != S_DIR)
			aerr();
		if (type == S_BTB) {
			comma(1);
			expr(&e3, 0);
		}
		outab(op + (e1.e_addr & 0x07));
		outrb(&e2, R_PAG0);
		if (type == S_BTB) {
			if (e3.e_base.e_ap == dot.s_area) {
				v3 = (int) (e3.e_addr - dot.s_addr - 1);
				if ((v3 < -128) || (v3 > 127))
					aerr();
				outab(v3);
			} else {
				outrb(&e3, R_PCR);
			}
			if (e3.e_mode != S_USER)
				rerr();
		}
		break;

	default:
		opcycles = OPCY_ERR;
		err('o');
		break;
	}

	if (opcycles == OPCY_NONE) {
		opcycles = m04cyc[cb[0] & 0xFF];
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
 * Machine specific initialization.
 */
VOID
minit()
{
	/*
	 * Byte Order
	 */
	hilo = 1;
}
