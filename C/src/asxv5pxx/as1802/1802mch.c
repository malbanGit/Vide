/* 1802mch.c */

/*
 *  Copyright (C) 2002-2009  Alan R. Baldwin
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
 * Shujen Chen
 * 605 Balmoral Circle
 * Naperville, IL 60540
 */

#include "asxxxx.h"
#include "1802.h"

char	*cpu	= "RCA 1802 COSMAC";
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
 * 1802 Cycle Count
 *
 *	opcycles = 1802pg1[opcode]
 */
static char pg1802[256] = {
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
/*80*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*90*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*A0*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*B0*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*C0*/   3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
/*D0*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*E0*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*F0*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
};

/*
 * Process machine ops.
 */
VOID
machine(mp)
struct mne *mp;
{
	int op, v, rd;
	struct expr e;

	clrexpr(&e);
	op = (int) mp->m_valu;
	switch (mp->m_type) {

	case S_INH:
		outab(op);
		break;

	case S_LBR:
		expr(&e, 0);
		outab(op);
		outrw(&e, 0);
		break;

	case S_NIB:
		rd = reg();
		if (rd > R15)
			aerr();
		if (op == 0 && rd == 0) /* no "LDN R0" */
			aerr();
		outab(op | rd);
		break;

	case S_BR:
		expr(&e, 0);
		mchbr(&e);
		outrwm(&e, R_PAGX1 | R_BR, op << 8);
		break;

	case S_IMM:
		expr(&e, 0);
		if (is_abs(&e)) {
			v = (int) (e.e_addr & ~0xFF);
			if ( ((v & ~0xFF) != 0) && ((v & ~0x7F) != ~0x7F) )
				aerr();
		}
		outab(op);
		outrb(&e, 0);
		break;

	case S_INP:
	case S_OUT:
		expr(&e, 0);
		if (is_abs(&e)) {
			if ((e.e_addr & ~0x07) || (e.e_addr == 0)) {
				e.e_addr = 1;
				aerr();
			}
			outab(op | (e.e_addr & 0x07));
		} else {
			outrbm(&e, R_PAG0 | R_IO, op);
		}
		break;

	default:
		opcycles = OPCY_ERR;
		err('o');
		break;
	}
	if (opcycles == OPCY_NONE) {
		opcycles = pg1802[cb[0] & 0xFF];
	}
}

/*
 * Read a register name.
 */
int
reg()
{
	struct mne *mp;
	char id[NCPS];

	getid(id, -1);
	if ((mp = mlookup(id)) == NULL || mp->m_type != S_REG) {
		aerr();
		return (0);
	}
	return ((int) mp->m_valu);
}

/*
 * Branch Mode Check
 */
int
mchbr(esp)
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
 * Dummy machine specific init.
 */
VOID
minit()
{
	/*
	 * Byte Order
	 */
	hilo = 1;
}
