/* m11mch.c */

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
 *
 *   With enhancements from
 *
 *	Mike McCarty
 *	mike dot mccarty at sbcglobal dot net
 */

#include "asxxxx.h"
#include "m6811.h"

char	*cpu	= "Motorola 6811";
char	*dsft	= "asm";

/*
 * Opcode Cycle Definitions
 */
#define	OPCY_SDP	((char) (0xFF))
#define	OPCY_ERR	((char) (0xFE))

/*	OPCY_NONE	((char) (0x80))	*/
/*	OPCY_MASK	((char) (0x7F))	*/

#define	UN	((char) (OPCY_NONE | 0x00))
#define	P2	((char) (OPCY_NONE | 0x01))
#define	P3	((char) (OPCY_NONE | 0x02))
#define	P4	((char) (OPCY_NONE | 0x03))

static char  m11pg1[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/   0, 2,41,41, 3, 3, 2, 2, 3, 3, 2, 2, 2, 2, 2, 2,
/*10*/   2, 2, 6, 6, 6, 6, 2, 2,P2, 2,P3, 2, 7, 7, 7, 7,
/*20*/   3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
/*30*/   3, 3, 4, 4, 3, 3, 3, 3, 5, 5, 3,12, 4,10,14,14,
/*40*/   2,UN,UN, 2, 2,UN, 2, 2, 2, 2, 2,UN, 2, 2,UN, 2,
/*50*/   2,UN,UN, 2, 2,UN, 2, 2, 2, 2, 2,UN, 2, 2,UN, 2,
/*60*/   6,UN,UN, 6, 6,UN, 6, 6, 6, 6, 6,UN, 6, 6, 3, 6,
/*70*/   6,UN,UN, 6, 6,UN, 6, 6, 6, 6, 6,UN, 6, 6, 3, 6,
/*80*/   2, 2, 2, 4, 2, 2, 2,UN, 2, 2, 2, 2, 4, 6, 3, 3,
/*90*/   3, 3, 3, 5, 3, 3, 3, 3, 3, 3, 3, 3, 5, 5, 4, 4,
/*A0*/   4, 4, 4, 6, 4, 4, 4, 4, 4, 4, 4, 4, 6, 6, 5, 5,
/*B0*/   4, 4, 4, 6, 4, 4, 4, 4, 4, 4, 4, 4, 6, 6, 5, 5,
/*C0*/   2, 2, 2, 4, 2, 2, 2,UN, 2, 2, 2, 2, 3,P4, 3, 2,
/*D0*/   3, 3, 3, 5, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4,
/*E0*/   4, 4, 4, 6, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5,
/*F0*/   4, 4, 4, 6, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5
};

static char  m11pg2[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/  UN,UN,UN,UN,UN,UN,UN,UN, 4, 4,UN,UN,UN,UN,UN,UN,
/*10*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN, 8, 8, 8, 8,
/*20*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*30*/   4,UN,UN,UN,UN, 4,UN,UN, 6,UN, 4,UN, 5,UN,UN,UN,
/*40*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*50*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*60*/   7,UN,UN, 7, 7,UN, 7, 7, 7, 7, 7,UN, 7, 7, 4, 7,
/*70*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*80*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN, 5,UN,UN, 4,
/*90*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN, 6,UN,UN,UN,
/*A0*/   5, 5, 5, 7, 5, 5, 5, 5, 5, 5, 5, 5, 7, 7, 6, 6,
/*B0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN, 7,UN,UN,UN,
/*C0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN, 4,UN,
/*D0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN, 5, 5,
/*E0*/   5, 5, 5, 7, 5, 5, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6,
/*F0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN, 6, 6
};

static char  m11pg3[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*10*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*20*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*30*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*40*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*50*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*60*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*70*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*80*/  UN,UN,UN, 5,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*90*/  UN,UN,UN, 6,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*A0*/  UN,UN,UN, 7,UN,UN,UN,UN,UN,UN,UN,UN, 7,UN,UN,UN,
/*B0*/  UN,UN,UN, 7,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*C0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*D0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*E0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN, 6, 6,
/*F0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN
};

static char  m11pg4[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*10*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*20*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*30*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*40*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*50*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*60*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*70*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*80*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*90*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*A0*/  UN,UN,UN, 7,UN,UN,UN,UN,UN,UN,UN,UN, 7,UN,UN,UN,
/*B0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*C0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*D0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*E0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN, 6, 6,
/*F0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN
};

static char *Page[4] = {
    m11pg1, m11pg2, m11pg3, m11pg4
};


/*
 * Process a machine op.
 */
VOID
machine(mp)
struct mne *mp;
{
	int op, t1, t2;
	struct expr e1, e2, e3;
	struct area *espa;
	char id[NCPS];
	int c, reg, cpg, type, v1, v3;

	clrexpr(&e1);
	clrexpr(&e2);
	clrexpr(&e3);
	reg = 0;
	cpg = 0;
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

	case S_INH2:
		outab(PAGE2);

	case S_INH:
		outab(op);
		break;

	case S_PUL:
		v1 = admode(abdxy);
		if (v1 == S_A) {
			outab(op);
			break;
		}
		if (v1 == S_B) {
			outab(op+1);
			break;
		}
		if (v1 == S_X) {
			outab(op+6);
			break;
		}
		if (v1 == S_Y) {
			outab(PAGE2);
			outab(op+6);
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
		if (t1 == S_D) {
			if (op == 0x44) {
				outab(0x04);
				break;
			}
			if (op == 0x48) {
				outab(0x05);
				break;
			}
			aerr();
			break;
		}
		if (t1 == S_INDX || t1 == S_INDY) {
			if (t1 == S_INDY)
				outab(PAGE2);
			outab(op|X);
			outrb(&e1, R_USGN);
			break;
		}
		if (t1 == S_DIR || t1 == S_EXT) {
			outab(op|0x30);
			outrw(&e1, 0);
			break;
		}
		aerr();
		break;

	case S_TYP2:
		if ((reg = admode(abdxy)) == 0)
			aerr();

	case S_TYP3:
		if (!reg) {
			reg = op & 0x40;
		} else
		if (reg == S_A) {
			reg = 0x00;
		} else
		if (reg == S_B) {
			reg = 0x40;
		} else
		if (reg == S_D) {
			if (op == 0x80) {
				op = 0x83;
			} else
			if (op == 0x8B) {
				op = 0xC3;
			} else {
				aerr();
			}
			reg = 0x00;
		} else {
			aerr();
			reg = 0x00;
		}
		t1 = addr(&e1);
		if (t1 == S_IMMED) {
			if ((op|0x40) == 0xC7)
				aerr();
			if (op == 0x83 || op == 0xC3) {
				outab(op|reg);
				outrw(&e1, 0);
			} else {
				outab(op|reg);
				outrb(&e1, 0);
			}
			break;
		}
		if (t1 == S_DIR) {
			outab(op|reg|0x10);
			outrb(&e1, R_PAG0);
			break;
		}
		if (t1 == S_INDX || t1 == S_INDY) {
			if (t1 == S_INDY)
				outab(PAGE2);
			outab(op|reg|0x20);
			outrb(&e1, R_USGN);
			break;
		}
		if (t1 == S_EXT) {
			outab(op|reg|0x30);
			outrw(&e1, 0);
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
		if (t1 == S_DIR) {
			outab(op|0x10);
			outrb(&e1, R_PAG0);
			break;
		}
		if (t1 == S_INDX || t1 == S_INDY) {
			if (t1 == S_INDY)
				outab(PAGE2);
			outab(op|0x20);
			outrb(&e1, R_USGN);
			break;
		}
		if (t1 == S_EXT) {
			outab(op|0x30);
			outrw(&e1, 0);
			break;
		}
		aerr();
		break;

	case S_TYP5:
		t1 = addr(&e1);
		if (t1 == S_INDX || t1 == S_INDY) {
			if (t1 == S_INDY)
				outab(PAGE2);
			outab(op);
			outrb(&e1, R_USGN);
			break;
		}
		if ((t1 == S_DIR) || (t1 == S_EXT)) {
			outab(op|0x10);
			outrw(&e1, 0);
			break;
		}
		aerr();
		break;

	case S_PG3:
		cpg += (PAGE3-PAGE2);

	case S_PG2:
		cpg += PAGE2;

	case S_TYP6:
		t1 = addr(&e1);
		if (t1 == S_IMMED) {
			if (op == 0xCF)
				aerr();
			if (cpg)
				outab(cpg);
			outab(op);
			outrw(&e1, 0);
			break;
		}
		if (t1 == S_DIR) {
			if (cpg)
				outab(cpg);
			outab(op|0x10);
			outrb(&e1, R_PAG0);
			break;
		}
		if (t1 == S_INDX) {
			if (cpg)
				outab(PAGE3);
			outab(op|0x20);
			outrb(&e1, R_USGN);
			break;
		}
		if (t1 == S_INDY) {
			if (cpg == PAGE2) {
				outab(PAGE2);
			} else {
				outab(PAGE4);
			}
			outab(op|0x20);
			outrb(&e1, R_USGN);
			break;
		}
		if (t1 == S_EXT) {
			if (cpg)
				outab(cpg);
			outab(op|0x30);
			outrw(&e1, 0);
			break;
		}
		aerr();
		break;

	case S_BTB:
	case S_STCLR:
		t1 = addr(&e1);
		comma(1);
		t2 = addr(&e2);
		if (type == S_BTB) {
			comma(1);
			expr(&e3, 0);
		}
		if (t1 == S_DIR) {
			outab(op);
			outrb(&e1, R_PAG0);
		} else
		if (t1 == S_INDX || t1 == S_INDY) {
			if (type == S_BTB) {
				op += 0x0C;
			} else {
				op += 0x08;
			}
			if (t1 == S_INDY)
				outab(PAGE2);
			outab(op);
			outrb(&e1, R_USGN);
		} else {
			outab(op);
			outrb(&e1, 0);
			aerr();
		}
		if (t2 != S_IMMED)
			aerr();
		outrb(&e2, 0);
		if (type == S_BTB) {
			if (mchpcr(&e3)) {
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
		opcycles = m11pg1[cb[0] & 0xFF];
		if ((opcycles & OPCY_NONE) && (opcycles & OPCY_MASK)) {
			opcycles = Page[opcycles & OPCY_MASK][cb[1] & 0xFF];
		}
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
