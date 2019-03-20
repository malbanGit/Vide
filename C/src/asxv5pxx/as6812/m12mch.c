/* m12mch.c */

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
#include "m6812.h"

char	*cpu	= "Motorola 68HC12";
char	*dsft	= "asm";

#define	NB	512

int	*bp;
int	bm;
int	bb[NB];

int	mchtyp;

/*
 * Opcode Cycle Definitions
 */
#define	OPCY_SDP	((char) (0xFF))
#define	OPCY_ERR	((char) (0xFE))
#define	OPCY_CPU	((char)	(0xFD))

/*	OPCY_NONE	((char) (0x80))	*/
/*	OPCY_MASK	((char) (0x7F))	*/

#define	OPCY_INDX	((char) (0x40))

#define	VALU_MASK	((char) (0x3F))

#define	UN	((char) (OPCY_NONE | 0x00))
#define	P2	((char) (OPCY_NONE | 0x01))

#define	I0	((char) (OPCY_INDX | 0x00))
#define	I1	((char) (OPCY_INDX | 0x01))
#define	I2	((char) (OPCY_INDX | 0x02))
#define	I3	((char) (OPCY_INDX | 0x03))
#define	I4	((char) (OPCY_INDX | 0x04))
#define	I5	((char) (OPCY_INDX | 0x05))
#define	I6	((char) (OPCY_INDX | 0x06))
#define	I7	((char) (OPCY_INDX | 0x07))

static char  m12pg1[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/   5, 5, 1, 1, 3, 6, 3, 4, 1, 1, 6, 8,I3,I3,I4,I4,
/*10*/   1,11, 3, 3, 1, 7, 4, 4,P2, 2, 2, 2, 4, 4, 5, 5,
/*20*/   3, 1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
/*30*/   3, 3, 3, 3, 2, 2, 2, 2, 3, 2, 3, 2, 9, 5, 8, 9,
/*40*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 8,I5, 4, 4, 4, 4,
/*50*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2,
/*60*/  I2,I2,I2,I2,I2,I2,I2,I2,I2,I6,I6,I6,I6,I6,I6,I6,
/*70*/   4, 4, 4, 4, 4, 4, 4, 4, 4, 3, 3, 3, 3, 3, 3, 3,
/*80*/   1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2,
/*90*/   3, 3, 3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 3, 3, 3,
/*A0*/  I1,I1,I1,I1,I1,I1,I1, 1,I1,I1,I1,I1,I1,I1,I1,I1,
/*B0*/   3, 3, 3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 3, 3, 3,
/*C0*/   1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2,
/*D0*/   3, 3, 3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 3, 3, 3,
/*E0*/  I1,I1,I1,I1,I1,I1,I1,I1,I1,I1,I1,I1,I1,I1,I1,I1,
/*F0*/   3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
};

static char  m12pg2[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/   4, 5, 5, 5, 6, 5, 2, 3, 4, 5, 5, 4, 6, 5, 2, 2,
/*10*/  12,12,13, 3,12,12, 2, 2,I7,I7,I7,I7,I7,I7,I7,I7,
/*20*/   4, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
/*30*/  10,10,10,10,10,10,10,10,10,10, 3, 3, 8, 8,14,10,
/*40*/  10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,
/*50*/  10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,
/*60*/  10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,
/*70*/  10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,
/*80*/  10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,
/*90*/  10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,
/*A0*/  10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,
/*B0*/  10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,
/*C0*/  10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,
/*D0*/  10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,
/*E0*/  10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,
/*F0*/  10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10
};

static char *mPage[2] = {
    m12pg1, m12pg2
};

static char m12idx[8][5] = {
/*--*--*      IDX     IDX1    IDX2    [D,R]   [n,R]     */
/*--*--*      ---     ----    ----    -----   -----     */
/*I0*/  {      UN,     UN,     UN,     UN,     UN,      },
/*I1*/  {       3,      3,      4,      6,      6,      }, /* ADC_  ... */
/*I2*/  {       3,      4,      5,      6,      6,      }, /* ASL   ... */
/*I3*/  {       4,      4,      6,     UN,     UN,      }, /* BCLR  ... */
/*I4*/  {       4,      6,      8,     UN,     UN,      }, /* BRCLR ... */
/*I5*/  {       8,      8,      9,     10,     10,      }, /* CALL      */
/*I6*/  {       2,      3,      3,      5,      5,      }, /* CLR   ... */
/*I7*/  {       4,      4,      5,      7,      7,      }  /* EMAX_ ... */
};

static char  s12pg1[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/   5, 5, 1, 1, 3, 6, 3, 4, 1, 1, 7, 8,I3,I3,I4,I4,
/*10*/   1,11, 1, 3, 1, 7, 4, 4,P2, 2, 2, 2, 4, 4, 5, 5,
/*20*/   3, 1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
/*30*/   3, 3, 3, 3, 2, 2, 2, 2, 3, 2, 3, 2, 5, 5, 7, 9,
/*40*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 8,I5, 4, 4, 4, 4,
/*50*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2,
/*60*/  I2,I2,I2,I2,I2,I2,I2,I2,I2,I6,I6,I6,I6,I6,I6,I6,
/*70*/   4, 4, 4, 4, 4, 4, 4, 4, 4, 3, 3, 3, 3, 3, 3, 3,
/*80*/   1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2,
/*90*/   3, 3, 3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 3, 3, 3,
/*A0*/  I1,I1,I1,I1,I1,I1,I1, 1,I1,I1,I1,I1,I1,I1,I1,I1,
/*B0*/   3, 3, 3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 3, 3, 3,
/*C0*/   1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2,
/*D0*/   3, 3, 3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 3, 3, 3,
/*E0*/  I1,I1,I1,I1,I1,I1,I1,I1,I1,I1,I1,I1,I1,I1,I1,I1,
/*F0*/   3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
};

static char  s12pg2[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/   4, 5, 5, 5, 6, 5, 2, 3, 4, 5, 5, 4, 6, 5, 2, 2,
/*10*/  12,12,13, 3,12,12, 2, 2,I7,I7,I7,I7,I7,I7,I7,I7,
/*20*/   4, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
/*30*/  10,10,10,10,10,10,10,10,10,10, 3, 3, 7, 6, 8,10,
/*40*/  10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,
/*50*/  10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,
/*60*/  10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,
/*70*/  10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,
/*80*/  10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,
/*90*/  10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,
/*A0*/  10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,
/*B0*/  10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,
/*C0*/  10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,
/*D0*/  10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,
/*E0*/  10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,
/*F0*/  10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10
};

static char *sPage[2] = {
    s12pg1, s12pg2
};

static char s12idx[8][5] = {
/*--*--*      IDX     IDX1    IDX2    [D,R]   [n,R]     */
/*--*--*      ---     ----    ----    -----   -----     */
/*I0*/  {      UN,     UN,     UN,     UN,     UN,      },
/*I1*/  {       3,      3,      4,      6,      6,      }, /* ADC_  ... */
/*I2*/  {       3,      4,      5,      6,      6,      }, /* ASL   ... */
/*I3*/  {       4,      4,      6,     UN,     UN,      }, /* BCLR  ... */
/*I4*/  {       4,      5,      6,     UN,     UN,      }, /* BRCLR ... */
/*I5*/  {       7,      7,      8,     10,     10,      }, /* CALL      */
/*I6*/  {       2,      3,      3,      4,      4,      }, /* CLR   ... */
/*I7*/  {       4,      4,      5,      7,      7,      }  /* EMAX_ ... */
};

/*
 * Process a machine op.
 */
VOID
machine(mp)
struct mne *mp;
{
	int op, rf, cpg, c;
	struct expr e1, e2, e3;
	int t1, t2;
	int v1, v2, v3;
	struct area *espa;
	char id[NCPS];

	cpg = 0;
	clrexpr(&e1);
	clrexpr(&e2);
	clrexpr(&e3);

	op = (int) mp->m_valu;
	switch (rf = mp->m_type) {

	case S_SDP:
		opcycles = OPCY_SDP;
		espa = NULL;
		if (more()) {
			expr(&e1, 0);
			if (e1.e_flag == 0 && e1.e_base.e_ap == NULL) {
				if (e1.e_addr & 0xFF) {
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

	case S_CPU:
		opcycles = OPCY_CPU;
		mchtyp = op;
		sym[2].s_addr = op;
		lmode = SLIST;
		break;

	case S_INH2:
		cpg = PAGE2;

	case S_INH:
		if (cpg)
			outab(cpg);
		outab(op);
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

	case S_LBRA:
		expr(&e1, 0);
		outab(PAGE2);
		outab(op);
		if (mchpcr(&e1)) {
			v1 = (int) (e1.e_addr - dot.s_addr - 2);
			outaw(v1);
		} else {
			outrw(&e1, R_PCR);
		}
		if (e1.e_mode != S_USER)
			aerr();
		break;

	case S_XBRA:
		if ((t1 = admode(abdxys)) == 0)
			aerr();
		op |= (t1 & 0xFF);
		comma(1);
		expr(&e1, 0);
		outab(0x04);
		if (mchpcr(&e1)) {
			v1 = (int) (e1.e_addr - dot.s_addr - 2);
			if ((v1 < -256) || (v1 > 255))
				aerr();
			if (v1 >= 0) {
				outab(op);
			} else {
				outab(op | 0x10);
			}
			outab(v1);
		} else {
			outrwm(&e1, M_XBRA | R_PCR, op << 8);
		}
		if (e1.e_mode != S_USER)
			rerr();
		break;

	case S_TRAP:
		t1 = addr(&e1);
		if (t1 == S_IMMED || t1 == S_EXT) {
			e1.e_mode = S_IMB;
		} else {
			aerr();
		}
		genout(cpg, op, rf, &e1);
		break;


	case S_PUL:
		if ((t1 = admode(pullstk)) == 0)
			aerr();
		outab(op | t1);
		break;

	case S_PSH:
		if ((t1 = admode(pushstk)) == 0)
			aerr();
		outab(op | t1);
		break;

	case S_SEX:
		if ((v1 = admode(srcreg)) == 0)
			aerr();
		if ((v1 & 0xFF) > 0x20)
			aerr();
		comma(1);
		if ((v2 = admode(dstreg)) == 0)
			aerr();
		if ((v2 & 0xFF) < 0x03)
			aerr();
		outab(op);
		outab(v1 | v2);
		break;

	case S_TFR:
		if ((v1 = admode(srcreg)) == 0)
			aerr();
		comma(1);
		if ((v2 = admode(dstreg)) == 0)
			aerr();
		outab(op);
		outab(v1 | v2);
		break;

	case S_EXG:
		if ((v1 = admode(srcreg)) == 0)
			aerr();
		comma(1);
		if ((v2 = admode(dstreg)) == 0)
			aerr();
		outab(op);
		outab(v1 | v2 | 0x80);
		break;

	case S_SOP:
		t1 = addr(&e1);
		if (t1 == S_DIR) {
			e1.e_mode = S_EXT;
		} else
		if (t1 == S_IMMED) {
			e1.e_mode = S_IMB;
			aerr();
		}
		genout(cpg, op, rf, &e1);
		break;

	case S_DOP:
		t1 = addr(&e1);
		if (t1 == S_IMMED)
			e1.e_mode = S_IMB;
		genout(cpg, op, rf, &e1);
		break;

	case S_STR:
		t1 = addr(&e1);
		if (t1 == S_IMMED) {
			e1.e_mode = S_IMB;
			aerr();
		}
		genout(cpg, op, rf, &e1);
		break;

	case S_LONG:
		t1 = addr(&e1);
		if (t1 == S_IMMED)
			e1.e_mode = S_IMW;
		genout(cpg, op, rf, &e1);
		break;

	case S_LEA:
		t1 = addr(&e1);
		if ((t1 == S_IMMED) || (t1 == S_DIR) ||
		    (t1 == S_EXT) || (t1 == S_IND) || (t1 == S_AIND))
			aerr();
		genout(cpg, op, rf, &e1);
		break;

	case S_JMP:
	case S_JSR:
		t1 = addr(&e1);
		if ((t1 == S_DIR) && (rf == S_JMP)) {
			e1.e_mode = S_EXT;
		} else
		if (t1 == S_IMMED) {
			e1.e_mode = S_IMB;
			aerr();
		}
		genout(cpg, op, rf, &e1);
		break;

	case S_CALL:
		t1 = addr(&e1);
		if (t1 == S_DIR) {
			e1.e_mode = S_EXT;
		} else
		if (t1 == S_IMMED) {
			e1.e_mode = S_IMB;
			aerr();
		}
		genout(cpg, op, rf, &e1);
		if ((t1 != S_IND) && (t1 != S_AIND)) {
			comma(1);
			expr(&e2, 0);
			outrb(&e2, R_USGN);
		}
		break;

	case S_TBL:
		cpg = PAGE2;
		t1 = addr(&e1);
		v1 = (int) e1.e_addr;
		if ((t1 == S_IND) || (t1 == S_AIND))
			aerr();
		if (e1.e_base.e_ap || (v1 < -16) || (v1 > 15))
			rerr();
		genout(cpg, op, rf, &e1);
		break;

	case S_EMNMX:
		cpg = PAGE2;
		t1 = addr(&e1);
		if (t1 == S_IMMED) {
			e1.e_mode = S_IMB;
			aerr();
		} else
		if ((t1 == S_DIR) || (t1 == S_EXT)) {
			aerr();
		}
		genout(cpg, op, rf, &e1);
		break;

	case S_EMACS:
		cpg = PAGE2;
		t1 = addr(&e1);
		if (t1 == S_DIR) {
			e1.e_mode = S_EXT;
		} else
		if (t1 != S_EXT) {
			aerr();
		}
		genout(cpg, op, rf, &e1);
		break;

	case S_BIT:
		t1 = addr(&e1);
		if (t1 == S_IMMED) {
			e1.e_mode = S_IMB;
			aerr();
		} else
		if ((t1 == S_IND) || (t1 == S_AIND)) {
			aerr();
		}
		comma(1);
		expr(&e2, 0);
		genout(cpg, op, rf, &e1);
		outrb(&e2, R_NORM);
		break;

	case S_BRBIT:
		t1 = addr(&e1);
		if (t1 == S_IMMED) {
			e1.e_mode = S_IMB;
			aerr();
		} else
		if ((t1 == S_IND) || (t1 == S_AIND)) {
			aerr();
		}
		comma(1);
		expr(&e2, 0);
		comma(1);
		expr(&e3, 0);
		genout(cpg, op, rf, &e1);
		outrb(&e2, R_NORM);
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
		break;

	case S_MOVB:
	case S_MOVW:
		t1 = addr(&e1);
		v1 = aindx;
		comma(1);
		t2 = addr(&e2);
		v2 = aindx;

		/*
		 * Byte / Word Checks
		 */
		if (rf == S_MOVB) {
			if (t1 == S_IMMED)
				t1 = e1.e_mode = S_IMB;
			if (t2 == S_IMMED)
				t2 = e2.e_mode = S_IMB;
		} else
		if (rf == S_MOVW) {
			if (t1 == S_IMMED)
				t1 = e1.e_mode = S_IMW;
			if (t2 == S_IMMED)
				t2 = e2.e_mode = S_IMW;
		}

		/*
		 * Source Checks
		 */
		if (t1 == S_DIR)
			t1 = e1.e_mode = S_EXT;
		if (t2 == S_DIR)
			t2 = e2.e_mode = S_EXT;

		/*
		 * Destination Checks
		 */
		if ((t2 == S_IMB) || (t2 == S_IMW))
			aerr();
		/*
		 * Opcode Updates
		 */
		if (t1 == S_EXT)
			op += 1;
		if ((t1 == S_AUTO) || (t1 == S_OFST) || (t1 == S_AOFST))
			op += 2;
		if (t2 == S_EXT)
			op += 3;

		outab(PAGE2);
		outab(op);

		/*
		 * IM_ => EXT
		 */
		if (((t1 == S_IMB) || (t1 == S_IMW)) && (t2 == S_EXT)) {
			movout(&e1, v1,  0);	/* IM_ */
			movout(&e2, v2,  0);	/* EXT */
		} else
		/*
		 * IMB => IDX
		 */
		if (t1 == S_IMB) {
			movout(&e2, v2,  1);	/* IDX */
			movout(&e1, v1,  0);	/* IMB */
		} else
		/*
		 * IMW => IDX
		 */
		if (t1 == S_IMW) {
			movout(&e2, v2,  2);	/* IDX */
			movout(&e1, v1,  0);	/* IMW */
		} else
		/*
		 * EXT => EXT
		 */
		if ((t1 == S_EXT) && (t2 == S_EXT)) {
			movout(&e1, v1,  0);	/* EXT */
			movout(&e2, v2,  0);	/* EXT */
		} else
		/*
		 * EXT => IDX
		 */
		if (t1 == S_EXT) {
			movout(&e2, v2,  2);	/* IDX */
			movout(&e1, v1,  0);	/* EXT */
		} else
		/*
		 * IDX => EXT
		 */
		if (t2 == S_EXT) {
			movout(&e1, v1, -2);	/* IDX */
			movout(&e2, v2,  0);	/* EXT */
		} else {
		/*
		 * IDX => IDX
		 */
			movout(&e1, v1, -1);	/* IDX */
			movout(&e2, v2,  1);	/* IDX */
		}
		break;

	case S_CC:
		t1 = addr(&e1);
		if (t1 == S_IMMED) {
			e1.e_mode = S_IMB;
			genout(cpg, op, rf, &e1);
			break;
		}
		aerr();
		break;

	case S_6811:
		m68out(op);
		break;		

	default:
		opcycles = OPCY_ERR;
		err('o');
		break;
	}

	if ((opcycles == OPCY_NONE) && (mchtyp == X_HC12)) {
		v1 = 1;
		opcycles = m12pg1[cb[0] & 0xFF];
		if ((opcycles & OPCY_NONE) && (opcycles & OPCY_MASK)) {
			v1 += 1;
			opcycles = mPage[opcycles & OPCY_MASK][cb[1] & 0xFF];
		}
		if (opcycles & OPCY_INDX) {
			v2 = opcycles & VALU_MASK;
			switch (cb[v1] & 0xE0) {
			default:
			case 0x00:	/* 5-bit constant offset */
			case 0x40:
			case 0x80:
			case 0xC0:
				opcycles = m12idx[v2][0];
				break;
			case 0x20:	/* Auto (+/-) xys (+/-) */
			case 0x60:
			case 0xA0:
				opcycles = m12idx[v2][0];
				break;
			case 0xE0:
				switch (cb[v1] & 0x07) {
				default:
				case 0x00:	/* 9-bit offset */
				case 0x01:
					opcycles = m12idx[v2][1];
					break;
				case 0x02:	/* 16-bit offset */
					opcycles = m12idx[v2][2];
					break;
				case 0x03:	/* 16-bit offset indexed-indirect */
					opcycles = m12idx[v2][4];
					break;
				case 0x04:	/* accumulator offset */
				case 0x05:
				case 0x06:
					opcycles = m12idx[v2][0];
					break;
				case 0x07:	/* accumulator D offset indexed-indirect */
					opcycles = m12idx[v2][3];
					break;
				}
			}
		}
	} else
	if ((opcycles == OPCY_NONE) && (mchtyp == X_HCS12)) {
		v1 = 1;
		opcycles = s12pg1[cb[0] & 0xFF];
		if ((opcycles & OPCY_NONE) && (opcycles & OPCY_MASK)) {
			v1 += 1;
			opcycles = sPage[opcycles & OPCY_MASK][cb[1] & 0xFF];
		}
		if (opcycles & OPCY_INDX) {
			v2 = opcycles & VALU_MASK;
			switch (cb[v1] & 0xE0) {
			default:
			case 0x00:	/* 5-bit constant offset */
			case 0x40:
			case 0x80:
			case 0xC0:
				opcycles = s12idx[v2][0];
				break;
			case 0x20:	/* Auto (+/-) xys (+/-) */
			case 0x60:
			case 0xA0:
				opcycles = s12idx[v2][0];
				break;
			case 0xE0:
				switch (cb[v1] & 0x07) {
				default:
				case 0x00:	/* 9-bit offset */
				case 0x01:
					opcycles = s12idx[v2][1];
					break;
				case 0x02:	/* 16-bit offset */
					opcycles = s12idx[v2][2];
					break;
				case 0x03:	/* 16-bit offset indexed-indirect */
					opcycles = s12idx[v2][4];
					break;
				case 0x04:	/* accumulator offset */
				case 0x05:
				case 0x06:
					opcycles = s12idx[v2][0];
					break;
				case 0x07:	/* accumulator D offset indexed-indirect */
					opcycles = s12idx[v2][3];
					break;
				}
			}
		}
	}
}

/*
 * General Output Routine
 */
VOID
genout(cpg, op, rf, esp)
int cpg, op, rf;
struct expr *esp;
{
	int espv;
	struct area *espa;
	int flag;

	espv = (int) esp->e_addr;
	espa = esp->e_base.e_ap;
	switch (esp->e_mode) {

	case S_IMB:
		if (cpg)
			outab(cpg);
		outab(op);
		outrb(esp, R_NORM);
		break;

	case S_IMW:
		if (cpg)
			outab(cpg);
		outab(op);
		outrw(esp, R_NORM);
		break;

	case S_DIR:
		if (cpg)
			outab(cpg);
		switch(rf) {
		case S_DOP:
		case S_STR:
		case S_LONG:
			outab(op + 0x10);
			break;
		case S_BIT:
		case S_BRBIT:
			outab(op + 0x40);
			break;
		case S_JMP:
		case S_JSR:
			outab(op + 0x02);
			break;
		default:
			outab(op);
			break;
		}
		outrb(esp, R_PAGN);
		break;

	case S_EXT:
		if (cpg)
			outab(cpg);
		switch(rf) {
		case S_DOP:
		case S_STR:
		case S_LONG:
			outab(op + 0x30);
			break;
		case S_BIT:
		case S_BRBIT:
		case S_SOP:
			outab(op + 0x10);
			break;
		case S_JMP:
		case S_JSR:
			outab(op + 0x01);
			break;
		default:
			outab(op);
			break;
		}
		outrw(esp, R_NORM);
		break;

	case S_AUTO:
		if (cpg)
			outab(cpg);
		switch(rf) {
		case S_DOP:
		case S_STR:
		case S_LONG:
			outab(op + 0x20);
			break;
		case S_CALL:
			outab(op + 0x01);
			break;
		default:
			outab(op);
			break;
		}
		if ((espv < 1) || (espv > 8))
			aerr();
		espv -= 1;
		if (aindx & 0x08)
			espv = ~espv;
		outab(aindx + (espv & 0x07));
		break;

	case S_IND:
		if (cpg)
			outab(cpg);
		switch(rf) {
		case S_DOP:
		case S_STR:
		case S_LONG:
			outab(op + 0x20);
			break;
		case S_CALL:
			outab(op + 0x01);
			break;
		default:
			outab(op);
			break;
		}
		outab(aindx | 0xE3);
		outrw(esp, R_NORM);
		break;

	case S_AIND:
	case S_AOFST:
		if (cpg)
			outab(cpg);
		switch(rf) {
		case S_DOP:
		case S_STR:
		case S_LONG:
			outab(op + 0x20);
			break;
		case S_CALL:
			outab(op + 0x01);
			break;
		default:
			outab(op);
			break;
		}
		outab(aindx);
		break;

	case S_OFST:
		if (cpg)
			outab(cpg);
		switch(rf) {
		case S_DOP:
		case S_STR:
		case S_LONG:
			outab(op + 0x20);
			break;
		case S_CALL:
			outab(op + 0x01);
			break;
		default:
			outab(op);
			break;
		}
		if (pass == 0) {
			dot.s_addr += 3;
		} else
		if (espa) {
			outab(aindx | 0xE2);
			outrw(esp, R_NORM);
		} else
		if (pass == 1) {
			if (esp->e_addr >= dot.s_addr)
				esp->e_addr -= fuzz;
			dot.s_addr += 1;
			flag = 0;
			if (espv < -256 || espv > 255)
				++flag;
			if (setbit(flag)) {
				dot.s_addr += 2;
			} else {
				if (espv < -16 || espv > 15)
					++flag;
				if (setbit(flag))
					++dot.s_addr;
			}
		} else {
			if (getbit()) {
				outab(aindx | 0xE2);
				outaw(espv);
			} else {
				if (getbit()) {
					aindx |= 0xE0 | ((espv >> 8) & 0x01);
					outab(aindx);
					outab(espv);
				} else {
					aindx = (aindx << 3) | (espv & 0x1F);
					outab(aindx);
				}
			}
		}
		break;

	default:
		aerr();
		break;
	}
}

/*
 * Mov Output Routine
 */
VOID
movout(esp, indx, offset)
struct expr *esp;
int indx, offset;
{
	int espv;
	struct area *espa;
	int flag;

	espa = esp->e_base.e_ap;
	espv = (int) esp->e_addr;

	switch (esp->e_mode) {

	case S_IMB:
		outrb(esp, R_NORM);
		break;

	case S_IMW:
		outrw(esp, R_NORM);
		break;

	case S_DIR:
	case S_EXT:
		outrw(esp, R_NORM);
		break;

	case S_AUTO:
		if ((indx & 0xF8) == 0xF8)
			espv -= offset;
		if ((espv < 1) || (espv > 8))
			aerr();
		espv -= 1;
		if (indx & 0x08)
			espv = ~espv;
		outab(indx + (espv & 0x07));
		break;

	case S_AIND:
		outab(indx);
		aerr();
		break;

	case S_IND:
		outab(indx | 0xE3);
		aerr();
		break;

	case S_AOFST:
		outab(indx);
		break;

	case S_OFST:
		if ((indx & 0x18) == 0x18)
			espv -= offset;
		if (pass == 0) {
			dot.s_addr += 3;
		} else
		if (espa) {
			outab(indx | 0xE2);
			aerr();
		} else
		if (pass == 1) {
			if (esp->e_addr >= dot.s_addr)
				esp->e_addr -= fuzz;
			dot.s_addr += 1;
			flag = 0;
			if (espv < -256 || espv > 255)
				++flag;
			if (setbit(flag)) {
				dot.s_addr += 2;
			} else {
				if (espv < -16 || espv > 15)
					++flag;
				if (setbit(flag))
					++dot.s_addr;
			}
		} else {
			if (getbit()) {
				outab(indx | 0xE2);
				aerr();
			} else {
				if (getbit()) {
					indx |= 0xE0 | ((espv >> 8) & 0x01);
					outab(indx);
					aerr();
				} else {
					indx = (indx << 3) | (espv & 0x1F);
					outab(indx);
				}
			}
		}
		break;

	default:
		aerr();
		break;
	}
}

/*
 * mc6811 compatibility output routine
 */
VOID
m68out(i)
int i;
{
	char *ptr;
	int j;

	ptr = (char *) &mc6811[i];
	for (j=0; j<4 ; j++) {
		if ((i = *ptr++) != 0) {
			outab(i);
		} else {
			break;
		}
	}
}

/*
 * Machine specific initialization.
 * Set up the bit table.
 */
VOID
minit()
{
	/*
	 * Byte Order
	 */
	hilo = 1;

	bp = bb;
	bm = 1;
	if (pass == 0) {
		mchtyp = X_HC12;
		sym[2].s_addr = X_HC12;
	}
}

/*
 * Store `b' in the next slot of the bit table.
 * If no room, force the longer form of the offset.
 */
int
setbit(b)
int b;
{
	if (bp >= &bb[NB])
		return(1);
	if (b)
		*bp |= bm;
	bm <<= 1;
	if (bm == 0) {
		bm = 1;
		++bp;
	}
	return(b);
}

/*
 * Get the next bit from the bit table.
 * If none left, return a `1'.
 * This will force the longer form of the offset.
 */
int
getbit()
{
	int f;

	if (bp >= &bb[NB])
		return (1);
	f = *bp & bm;
	bm <<= 1;
	if (bm == 0) {
		bm = 1;
		++bp;
	}
	return (f);
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

