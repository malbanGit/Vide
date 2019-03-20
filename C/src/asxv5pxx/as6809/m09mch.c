/* M09MCH.C */

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
#include "m6809.h"

char	*cpu	= "Motorola 6809";
char	*dsft	= "asm";

#define	NB	512

int	*bp;
int	bm;
int	bb[NB];

/*
 * Opcode Cycle Definitions
 */
#define	OPCY_SDP	((char) (0xFF))
#define	OPCY_ERR	((char) (0xFE))

/*	OPCY_NONE	((char) (0x80))	*/
/*	OPCY_MASK	((char) (0x7F))	*/

#define	OPCY_INDX	((char) (0x40))
#define	OPCY_PSPL	((char) (0x20))

#define	VALU_MASK	((char) (0x1F))

#define	UN	((char) (OPCY_NONE | 0x00))
#define	P2	((char) (OPCY_NONE | 0x01))
#define	P3	((char) (OPCY_NONE | 0x02))

#define	I3	((char) (OPCY_INDX | 0x03))
#define	I4	((char) (OPCY_INDX | 0x04))
#define	I5	((char) (OPCY_INDX | 0x05))
#define	I6	((char) (OPCY_INDX | 0x06))
#define	I7	((char) (OPCY_INDX | 0x07))

#define	PP	((char) (OPCY_PSPL | 0x05))

/*
 * 6809 Cycle Count
 *
 *	opcycles = m09pg1[opcode]
 */
static char m09pg1[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/   6,UN,UN, 6, 6,UN, 6, 6, 6, 6, 6,UN, 6, 6, 3, 6,
/*10*/  P2,P3, 2, 4,UN,UN, 5, 9,UN, 2, 3,UN, 3, 2, 8, 6,
/*20*/   3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
/*30*/  I4,I4,I4,I4,PP,PP,PP,PP,UN, 5, 3,15,20,11,UN,19,
/*40*/   2,UN,UN, 2, 2,UN, 2, 2, 2, 2, 2,UN, 2, 2,UN, 2,
/*50*/   2,UN,UN, 2, 2,UN, 2, 2, 2, 2, 2,UN, 2, 2,UN, 2,
/*60*/  I6,UN,UN,I6,I6,UN,I6,I6,I6,I6,I6,UN,I6,I6,I3,I6,
/*70*/   7,UN,UN, 7, 7,UN, 7, 7, 7, 7, 7,UN, 7, 7, 4, 7,
/*80*/   2, 2, 2, 4, 2, 2, 2,UN, 2, 2, 2, 2, 4, 7, 3,UN,
/*90*/   4, 4, 4, 6, 4, 4, 4, 4, 4, 4, 4, 4, 6, 7, 5, 5,
/*A0*/  I4,I4,I4,I6,I4,I4,I4,I4,I4,I4,I4,I4,I6,I7,I5,I5,
/*B0*/   5, 5, 5, 7, 5, 5, 5, 5, 5, 5, 5, 5, 7, 8, 6, 6,
/*C0*/   2, 2, 2, 4, 2, 2, 2,UN, 2, 2, 2, 2, 3,UN, 3,UN,
/*D0*/   4, 4, 4, 6, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5,
/*E0*/  I4,I4,I4,I6,I4,I4,I4,I4,I4,I4,I4,I4,I5,I5,I5,I5,
/*F0*/   5, 5, 5, 7, 5, 5, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6
};

static char m09pg2[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*10*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*20*/  UN, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6,
/*30*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,20,
/*40*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*50*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*60*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*70*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*80*/  UN,UN,UN, 5,UN,UN,UN,UN,UN,UN,UN,UN, 5,UN, 4,UN,
/*90*/  UN,UN,UN, 7,UN,UN,UN,UN,UN,UN,UN,UN, 7,UN, 6,UN,
/*A0*/  UN,UN,UN,I7,UN,UN,UN,UN,UN,UN,UN,UN,I7,UN,I6,I6,
/*B0*/  UN,UN,UN, 8,UN,UN,UN,UN,UN,UN,UN,UN, 8,UN, 7, 7,
/*C0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN, 4,UN,
/*D0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN, 6, 6,
/*E0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,I6,I6,
/*F0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN, 7, 7
};

static char m09pg3[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*10*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*20*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*30*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,20,
/*40*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*50*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*60*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*70*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*80*/  UN,UN,UN, 5,UN,UN,UN,UN,UN,UN,UN,UN, 5,UN,UN,UN,
/*90*/  UN,UN,UN, 7,UN,UN,UN,UN,UN,UN,UN,UN, 7,UN,UN,UN,
/*A0*/  UN,UN,UN,I7,UN,UN,UN,UN,UN,UN,UN,UN,I7,UN,UN,UN,
/*B0*/  UN,UN,UN, 8,UN,UN,UN,UN,UN,UN,UN,UN, 8,UN,UN,UN,
/*C0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*D0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*E0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*F0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN
};

static char *Page[3] = {
    m09pg1, m09pg2, m09pg3
};

static char m09idx[32] = {
/*    ,R+	*/	2,	/*    ,R++	*/	3,
/*    ,-R	*/	2,	/*    ,--R	*/	3,
/*    ,R	*/	0,	/*   B,R	*/	1,
/*   A,R	*/	1,	/*   ---	*/	0,
/*   n,R     (8)*/	1,	/*   n,R    (16)*/	4,
/*   ---	*/	0,	/*   D,R	*/	4,
/*   n,PCR   (8)*/	1,	/*   n,PCR  (16)*/	5,
/*   ---	*/	0,	/*   ---	*/	0,
/*   ---	*/	0,	/*   [,R++]	*/	6,
/*   ---	*/	0,	/*   [,--R]	*/	6,
/*   [,R]	*/	3,	/*  [B,R]	*/	4,
/*  [A,R]	*/	4,	/*   ---	*/	0,
/*  [n,R]    (8)*/	4,	/*  [n,R]   (16)*/	7,
/*   ---	*/	0,	/*  [D,R]	*/	7,
/*  [n,PCR]  (8)*/	4,	/*  [n,PCR] (16)*/	8,
/*   ---	*/	0,	/*  [n]		*/	5
};

static char m00cyc[24] = {
	12,12, 3, 3, 3, 5, 5, 5,
	 5, 6, 6, 6, 6,12, 3, 3,
	 3, 8, 6, 8, 6, 6, 6,20
};


/*
 * Process a machine op.
 */
VOID
machine(mp)
struct mne *mp;
{
	int op, rf, cpg, c;
	struct expr e1;
	int t1, v1, v2;
	struct area *espa;
	char id[NCPS];

	cpg = 0;
	clrexpr(&e1);
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

	case S_INH2:
		cpg += 0x01;

	case S_INH1:
		cpg += 0x10;

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
		cpg += 0x10;

	case S_LBSR:
		expr(&e1, 0);
		if (cpg)
			outab(cpg);
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

	case S_PULS:
		v1 = 0;
		do {
			if ((t1 = admode(stks)) == 0 || v1 & t1)
				aerr();
			v1 |= t1;
		} while (more() && comma(1));
		outab(op);
		outab(v1);
		break;

	case S_PULU:
		v1 = 0;
		do {
			if ((t1 = admode(stku)) == 0 || v1 & t1)
				aerr();
			v1 |= t1;
		} while (more() && comma(1));
		outab(op);
		outab(v1);
		break;

	case S_EXG:
		v1 = admode(regs);
		comma(1);
		v2 = admode(regs);
		if ((v1 & 0x08) != (v2 & 0x08))
			aerr();
		outab(op);
		outab((v1<<4)|v2);
		break;

	case S_ACC:
		t1 = addr(&e1);
		if (t1 == S_IMMED)
			e1.e_mode = S_IMB;
		genout(cpg, op, rf, &e1);
		break;

	case S_STR1:
		cpg += 0x10;

	case S_SOP:
	case S_STR:
		t1 = addr(&e1);
		if (t1 == S_IMMED)
			e1.e_mode = S_IMER;
		genout(cpg, op, rf, &e1);
		break;

	case S_LR2:
		cpg += 0x01;

	case S_LR1:
		cpg += 0x10;

	case S_LR:
		t1 = addr(&e1);
		if (t1 == S_IMMED)
			e1.e_mode = S_IMW;
		genout(cpg, op, rf, &e1);
		break;

	case S_LEA:
		t1 = addr(&e1);
		if (aindx) {
			genout(cpg, op, rf, &e1);
			break;
		}
		aerr();
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

	case S_6800:
		m68out(op);
		opcycles = m00cyc[op];
		break;

	default:
		opcycles = OPCY_ERR;
		err('o');
		break;
	}

	if (opcycles == OPCY_NONE) {
		v2 = 1;
		opcycles = m09pg1[cb[0] & 0xFF];
		if ((opcycles & OPCY_NONE) && (opcycles & OPCY_MASK)) {
			v2 += 1;
			opcycles = Page[opcycles & OPCY_MASK][cb[1] & 0xFF];
		}
		if (opcycles & OPCY_INDX) {
			if (cb[v2] & 0x80) {
				opcycles = (opcycles & VALU_MASK) + m09idx[cb[v2] & 0x1F];
			} else {
				opcycles = (opcycles & VALU_MASK) + 1;
			}
		} else
		if (opcycles & OPCY_PSPL) {
			for (t1=0x01,v1=0; t1 < 0x0100; t1 <<= 1) {
				if (cb[1] & t1) {
			    		v1 += 1;
				}
			}
			opcycles = (opcycles & VALU_MASK) + v1;
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
	int disp, flag;

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
		if (rf == S_SOP) {
			outab(op&0x0F);
		} else {
			outab(op|0x10);
		}
		outrb(esp, R_PAGN);
		break;

	case S_EXT:
		if (cpg)
			outab(cpg);
		if (aindx) {
			outab(op|0x20);
			outab(aindx|0x0F);
			outrw(esp, R_NORM);
			break;
		}
		outab(op|0x30);
		outrw(esp, R_NORM);
		break;

	case S_IND:
		if (cpg)
			outab(cpg);
		outab(op|0x20);
		outab(aindx);
		break;

	case S_PC:
		if (espa) {
			aerr();
			break;
		}
		if (cpg)
			outab(cpg);
		outab(op|0x20);
		if (pass == 0) {
			dot.s_addr += 3;
		} else
		if (pass == 1) {
			if (esp->e_addr >= dot.s_addr)
				esp->e_addr -= fuzz;
			dot.s_addr += 2;
			disp = (int) esp->e_addr;
			flag = 0;
			if (disp < -128 || disp > 127)
				++flag;
			if (setbit(flag))
				++dot.s_addr;
		} else {
			if (getbit()) {
				outab(aindx|0x01);
				outaw(espv);
			} else {
				outab(aindx);
				outab(espv);
			}
		}
		break;

	case S_PCR:
		if (cpg)
			outab(cpg);
		outab(op|0x20);
		if (pass == 0) {
			dot.s_addr += 3;
		} else
		if (espa && espa != dot.s_area) {
			outab(aindx|0x01);
			outrw(esp, R_PCR);
		} else
		if (pass == 1) {
			if (esp->e_addr >= dot.s_addr)
				esp->e_addr -= fuzz;
			dot.s_addr += 2;
			disp = (int) (esp->e_addr - dot.s_addr);
			flag = 0;
			if (disp < -128 || disp > 127)
				++flag;
			if (setbit(flag))
				++dot.s_addr;
		} else {
			if (getbit()) {
				outab(aindx|0x01);
				disp = (int) (espv - dot.s_addr - 2);
				outaw(disp);
			} else {
				outab(aindx);
				disp = (int) (espv - dot.s_addr - 1);
				outab(disp);
			}
		}
		break;

	case S_OFST:
		if (cpg)
			outab(cpg);
		outab(op|0x20);
		if (pass == 0) {
			dot.s_addr += 3;
		} else
		if (espa) {
			outab(aindx|0x09);
			outrw(esp, R_NORM);
		} else
		if (pass == 1) {
			if (esp->e_addr >= dot.s_addr)
				esp->e_addr -= fuzz;
			dot.s_addr += 1;
			flag = 0;
			if (espv < -128 || espv > 127)
				++flag;
			if (setbit(flag)) {
				dot.s_addr += 2;
			} else {
				flag = aindx & 0x10;
				if (espv < -16 || espv > 15)
					++flag;
				if (setbit(flag))
					++dot.s_addr;
			}
		} else {
			if (getbit()) {
				outab(aindx|0x09);
				outaw(espv);
			} else {
				if (getbit()) {
					outab(aindx|0x08);
					outab(espv);
				} else {
					outab((aindx & 0x60) | (espv & 0x1F));
				}
			}
		}
		break;

	case S_IMER:
	default:
		aerr();
	}
}

/*
 * mc6800 compatibility output routine
 */
VOID
m68out(i)
int i;
{
	char *ptr;
	int j;

	ptr = (char *) &mc6800[i];
	for (j=0; j<4 ; j++) {
		if ((i = *ptr++) != 0) {
			outab(i);
		} else {
			break;
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
	register int f;

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

