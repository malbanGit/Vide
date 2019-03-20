/* m74mch.c */

/*
 *  Copyright (C) 2005-2009  Alan R. Baldwin
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

/*
 * Contributions by
 *
 * Uwe Steller
 */

#include "asxxxx.h"
#include "m740.h"

char *cpu  = "Mitsubishi 740 family";
char *dsft = "asm";

/*
 * Opcode Cycle Definitions
 */
#define	OPCY_SDP	((char) (0xFF))
#define	OPCY_ERR	((char) (0xFE))

/*	OPCY_NONE	((char) (0x80))	*/
/*	OPCY_MASK	((char) (0x7F))	*/

#define	UN	((char) (OPCY_NONE | 0x00))

/*
 * 740 Cycle Count
 *
 *	opcycles = m74pg1[opcode]
 */
static char m74pg1[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/   7, 9, 7, 6,UN, 6, 5, 7, 3, 5, 2, 2,UN, 7, 6, 5,
/*10*/   4, 9, 2, 6,UN, 7, 6, 7, 2, 8, 2, 2,UN, 8, 7, 5,
/*20*/   6, 9, 5, 6, 3, 6, 5, 7, 4, 5, 2, 2, 4, 7, 6, 5,
/*30*/   4, 9, 2, 6,UN, 7, 6, 7, 2, 8, 2, 2, 4, 8, 7, 5,
/*40*/   6, 9, 5, 6, 5, 6, 5, 7, 3, 5, 2, 2, 3, 7, 6, 5,
/*50*/   4, 9,UN, 6,UN, 7, 6, 7, 2, 8,UN, 2,UN, 8, 7, 5,
/*60*/   6, 9,15, 6, 3, 6, 5, 7, 4, 5, 2, 2, 5, 7, 6, 5,
/*70*/   4, 9,UN, 6,UN, 7, 6, 7, 2, 8,UN, 2,UN, 8, 7, 5,
/*80*/   6, 7, 8, 6, 4, 4, 4, 7, 2,UN, 2, 2, 6, 5, 5, 5,
/*90*/   4, 7,UN, 6, 5, 5, 5, 7, 2, 6, 2, 2,UN, 6,UN, 5,
/*A0*/   2, 8, 2, 6, 3, 5, 4, 7, 2, 4, 2, 2, 4, 6, 4, 5,
/*B0*/   4, 8, 4, 6, 4, 6, 4, 7, 2, 7, 2, 2, 5, 7, 4, 5,
/*C0*/   2, 7, 2, 6, 3, 4, 5, 7, 2, 3, 2, 2, 4, 5, 6, 5,
/*D0*/   4, 7,UN, 6,UN, 5, 6, 7, 2, 6,UN, 2,UN, 6, 7, 5,
/*E0*/   2, 9,16, 6, 3, 6, 5, 7, 2, 5, 2, 2, 4, 7, 6, 5,
/*F0*/   4, 9,UN, 6,UN, 7, 6, 7, 2, 8,UN, 2,UN, 8, 7, 5
};

/*
 * Process a machine op.
 */
VOID
machine(mp)
struct mne *mp;
	{
	int op, t1, t2;
	struct expr e1,e2,e3;
	struct area *espa;
	char id[NCPS];
	int c;

	clrexpr(&e1);
	clrexpr(&e2);
	clrexpr(&e3);
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

	case S_BRA:
		expr(&e1, 0);
		outab(op);
		genbad(&e1);
		break;

	case S_JSR:
		t1 = addr(&e1);
		switch (t1) {
		case S_IND:
		case S_ZIND:
			outab(0x02);
			outrb(&e1, R_PAG0);
			break;
		case S_ZP:
		case S_ABS:
			outab(op);
			outrw(&e1, R_NORM);
			break;
		case S_SPEC:
			outab(0x22);
			outrb(&e1, 0);
			break;
		default:
			aerr();
			break;
		}
		break;

	case S_JMP:
		t1 = addr(&e1);
		switch (t1) {
		case S_IND:
			outab(op + 0x20);
			outrw(&e1, R_NORM);
			break;
		case S_ZIND:
			outab(0xB2);
			outrb(&e1, R_PAG0);
			break;
		case S_ZP:
		case S_ABS:
			outab(op);
			outrw(&e1, R_NORM);
			break;
		default:
			aerr();
			break;
		}
		break;

	case S_DOP:
		t1 = addr(&e1);
		switch (t1) {
		case S_IMMED:
			outab(op + 0x09);
			outrb(&e1, R_NORM);
			if (op == 0x80)
				aerr();
			break;
		case S_ZP:
			outab(op + 0x05);
			outrb(&e1, R_PAG0);
			break;
		case S_ZPX:
			outab(op + 0x15);
			outrb(&e1, R_PAG0);
			break;
		case S_ABS:
			outab(op + 0x0D);
			outrw(&e1, R_NORM);
			break;
		case S_ABSX:
			outab(op + 0x1D);
			outrw(&e1, R_NORM);
			break;
		case S_ZPY:
		case S_ABSY:
			outab(op + 0x19);
			outrw(&e1, R_NORM);
			break;
		case S_INDX:
			outab(op + 0x01);
			outrb(&e1, R_PAG0);
			if ((!e1.e_flag)
			    && (e1.e_base.e_ap==NULL)
				&& (e1.e_addr & ~0xFF))
				    err('d');
			break;
		case S_INDY:
			outab(op + 0x11);
			outrb(&e1, R_PAG0);
			if ((!e1.e_flag)
			    && (e1.e_base.e_ap==NULL)
				&& (e1.e_addr & ~0xFF))
				    err('d');
			break;
		default:
			aerr();
			break;
		}
		break;

	case S_SOP:
		t1 = addr(&e1);
		switch (t1) {
		case S_ACC:
			if (op == 0xC0) {
				outab(0x1A);
			} else
			if (op == 0xE0) {
				outab(0x3A);
			} else {
				outab(op + 0x0A);
			}
			break;
		case S_ZP:
			outab(op + 0x06);
			outrb(&e1, R_PAG0);
			break;
		case S_ZPX:
			outab(op + 0x16);
			outrb(&e1, R_PAG0);
			break;
		case S_ABS:
			outab(op + 0x0E);
			outrw(&e1, R_NORM);
			break;
		case S_ABSX:
			outab(op + 0x1E);
			outrw(&e1, R_NORM);
			break;
		default:
			aerr();
			break;
		}
		break;

	case S_BIT:
		t1 = addr(&e1);
		switch (t1) {
		case S_ZP:
			outab(op + 0x04);
			outrb(&e1, R_PAG0);
			break;
		case S_ABS:
			outab(op + 0x0C);
			outrw(&e1, R_NORM);
			break;
		default:
			aerr();
			break;
		}
		break;

	case S_CP:
		t1 = addr(&e1);
		switch (t1) {
		case S_IMMED:
			outab(op);
			outrb(&e1, R_NORM);
			break;
		case S_ZP:
			outab(op + 0x04);
			outrb(&e1, R_PAG0);
			break;
		case S_ABS:
			outab(op+0x0C);
			outrw(&e1, R_NORM);
			break;
		default:
			aerr();
			break;
		}
		break;

	case S_LDX:
		t1 = addr(&e1);
		switch (t1) {
		case S_IMMED:
			outab(op + 0x02);
			outrb(&e1, R_NORM);
			break;
		case S_ZP:
			outab(op + 0x06);
			outrb(&e1, R_PAG0);
			break;
		case S_ZPY:
			outab(op + 0x16);
			outrb(&e1, R_PAG0);
			break;
		case S_ABS:
			outab(op + 0x0E);
			outrw(&e1, R_NORM);
			break;
		case S_ABSY:
			outab(op + 0x1E);
			outrw(&e1, R_NORM);
			break;
		default:
			aerr();
			break;
		}
		break;

	case S_STX:
		t1 = addr(&e1);
		switch (t1) {
		case S_ZP:
			outab(op + 0x06);
			outrb(&e1, R_PAG0);
			break;
		case S_ZPY:
		case S_ABSY:
			outab(op + 0x16);
			outrb(&e1, R_PAG0);
			break;
		case S_ABS:
			outab(op + 0x0E);
			outrw(&e1, R_NORM);
			break;
		default:
			aerr();
			break;
		}
		break;

	case S_LDY:
		t1 = addr(&e1);
		switch (t1) {
		case S_IMMED:
			outab(op);
			outrb(&e1, R_NORM);
			break;
		case S_ZP:
			outab(op + 0x04);
			outrb(&e1, R_PAG0);
			break;
		case S_ZPX:
			outab(op + 0x14);
			outrb(&e1, R_PAG0);
			break;
		case S_ABS:
			outab(op + 0x0C);
			outrw(&e1, R_NORM);
			break;
		case S_ABSX:
			outab(op + 0x1C);
			outrw(&e1, R_NORM);
			break;
		default:
			aerr();
			break;
		}
		break;

	case S_STY:
		t1 = addr(&e1);
		switch (t1) {
		case S_ZP:
			outab(op + 0x04);
			outrb(&e1, R_PAG0);
			break;
		case S_ZPX:
		case S_ABSX:
			outab(op + 0x14);
			outrb(&e1, R_PAG0);
			break;
		case S_ABS:
			outab(op + 0x0C);
			outrw(&e1, R_NORM);
			break;
		default:
			aerr();
			break;
		}
		break;

	case S_BB:
		t1 = addr(&e1);
		switch (t1) {
		case S_NBITA:
			comma(1);
			expr(&e3, 0);
			outrbm(&e1, R_3BIT | R_USGN, op);
			genbad(&e3);
			break;

		case S_NBIT:
			comma(1);
			if ((c = getnb()) != '*') {
				unget(c);
			}
			expr(&e2, 0);
			comma(1);
			expr(&e3, 0);
			outrbm(&e1, R_3BIT | R_USGN, op + 0x04);
			outrb(&e2, R_PAG0);
			genbad(&e3);
			break;

		default:
			aerr();
			break;
		}
		break;

	case S_LDM:
		t1 = addr(&e1);
		if (t1 != S_IMMED) {
			aerr();
		}
		comma(1);
		t2 = addr(&e2);
		if (t2 != S_ZP && t2 != S_ABS) {
			aerr();
		}
		/* create LDM instr */
		outab(op);
		outrb(&e1, R_USGN);
		outrb(&e2, R_PAG0);
		break;

	case S_ZERO:
		t1 = addr(&e1);
		if (t1 != S_ZP && t1 != S_ABS) {
			aerr();
		}
		outab(op);
		outrb(&e1, R_PAG0);
		break;

	case S_ZEROX:
		t1 = addr(&e1);
		if (t1 != S_ZPX && t1 != S_ABSX) {
			aerr();
		}
		outab(op);
		outrb(&e1, R_PAG0);
		break;

	case S_BITE:
		t1 = addr(&e1);
		switch (t1) {
		case S_NBITA:
			outrbm(&e1, R_3BIT | R_USGN, op);
			break;
		case S_NBIT:
			comma(1);
			t2 = addr(&e2);
			if (t2 != S_ZP && t2 != S_ABS) {
				aerr();
			}
			outrbm(&e1, R_3BIT | R_USGN, op + 0x04);
			outrb(&e2, R_PAG0);
			break;
		default:
			aerr();
		}
		break;


	default:
		opcycles = OPCY_ERR;
		err('o');
		break;
	}
	if (opcycles == OPCY_NONE) {
		opcycles = m74pg1[cb[0] & 0xFF];
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
}


/*
 * Create address for S_BRA type instruction
 */
VOID
genbad(esp)
struct expr *esp;
{
	int v1;

	if (mchpcr(esp)) {
		v1 = (int) (esp->e_addr - dot.s_addr - 1);
		if ((v1 < -128) || (v1 > 127))
			aerr();
		outab(v1);
	} else {
		outrb(esp, R_PCR);
	}
	if (esp->e_mode != S_USER)
		rerr();
}
