/* f8mch.c */

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

#include "asxxxx.h"
#include "f2mc8.h"

char	*cpu	= "Fujitsu F2MC8 Series";
char	*dsft	= "asm";

/*
 * Opcode Cycle Definitions
 */
#define	OPCY_SDP	((char) (0xFF))
#define	OPCY_ERR	((char) (0xFE))

/*	OPCY_NONE	((char) (0x80))	*/
/*	OPCY_MASK	((char) (0x7F))	*/

#define	OPCY_CPU	((char) (OPCY_NONE | 0xFD))

#define	UN		((char) (OPCY_NONE | 0x00))


/*
 * F2MC8L Cycle Count
 *
 *	opcycles = f8lcyc[opcode]
 */
char f8lcyc[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/   1,19, 2, 2, 2, 3, 4, 3, 3, 3, 3, 3, 3, 3, 3, 3,
/*10*/   2,21, 2, 3, 2, 3, 4, 3, 3, 3, 3, 3, 3, 3, 3, 3,
/*20*/   4, 3, 2, 3, 2, 3, 4, 3, 3, 3, 3, 3, 3, 3, 3, 3,
/*30*/   6, 6, 2, 3, 2, 3, 4, 3, 3, 3, 3, 3, 3, 3, 3, 3,
/*40*/   4, 4, 2, 3,UN, 3, 4, 3, 3, 3, 3, 3, 3, 3, 3, 3,
/*50*/   4, 4, 2, 3, 2, 3, 4, 3, 3, 3, 3, 3, 3, 3, 3, 3,
/*60*/   4, 4, 2, 3, 2, 3, 4, 3, 3, 3, 3, 3, 3, 3, 3, 3,
/*70*/   2, 2, 2, 3, 2, 3, 4, 3, 3, 3, 3, 3, 3, 3, 3, 3,
/*80*/   1, 1, 3, 4, 2, 4, 5, 4, 4, 4, 4, 4, 4, 4, 4, 4,
/*90*/   1, 1, 3, 4, 2, 5, 5, 4, 4, 4, 4, 4, 4, 4, 4, 4,
/*A0*/   4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
/*B0*/   5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
/*C0*/   3, 3, 3, 3, 5, 4, 5, 4, 4, 4, 4, 4, 4, 4, 4, 4,
/*D0*/   3, 3, 3, 3, 5, 4, 5, 4, 4, 4, 4, 4, 4, 4, 4, 4,
/*E0*/   2, 2, 2, 2, 3, 3, 3, 3, 6, 6, 6, 6, 6, 6, 6, 6,
/*F0*/   2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3
};

/*
 * F2MC8FX Cycle Count
 *
 *	opcycles = f8xcyc[opcode]
 */
static char  f8xcyc[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/   1, 8, 1, 1, 2, 3, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*10*/   1,17, 1, 1, 2, 3, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*20*/   6, 4, 1, 1, 2, 3, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*30*/   8, 6, 1, 1, 2, 3, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*40*/   4, 4, 1, 1,UN, 3, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*50*/   3, 3, 1, 1, 2, 3, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*60*/   4, 4, 1, 1, 2, 3, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*70*/   1, 1, 1, 1, 2, 3, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*80*/   1, 1, 2, 3, 1, 4, 4, 3, 3, 3, 3, 3, 3, 3, 3, 3,
/*90*/   1, 1, 2, 3, 1, 4, 4, 3, 3, 3, 3, 3, 3, 3, 3, 3,
/*A0*/   4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
/*B0*/   5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
/*C0*/   1, 1, 1, 1, 5, 4, 4, 3, 3, 3, 3, 3, 3, 3, 3, 3,
/*D0*/   1, 1, 1, 1, 5, 4, 4, 3, 3, 3, 3, 3, 3, 3, 3, 3,
/*E0*/   3, 1, 1, 1, 3, 3, 3, 3, 7, 7, 7, 7, 7, 7, 7, 7,
/*F0*/   2, 1, 1, 1, 3, 1, 1, 1, 4, 4, 4, 4, 4, 4, 4, 4
};

int	mchtyp;

/*
 * Process a machine op.
 */
VOID
machine(mp)
struct mne *mp;
{
	int c, op;
	struct expr e1, e2, e3;
	int t1, t2;
	int v1, v2, v3;
	struct area *espa;
	char id[NCPS];

	clrexpr(&e1);
	clrexpr(&e2);
	clrexpr(&e3);
	op = (int) mp->m_valu;
	switch (mp->m_type) {

	case S_CPU:
		opcycles = OPCY_CPU;
		mchtyp = op;
		sym[2].s_addr = op;
		lmode = SLIST;
		break;

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

	case S_AOP:
		if ((t1 = addr(&e1)) != S_A) {
			aerr();
		}
		outab(op);
		break;

	case S_MOV:
		t1 = addr(&e1);
		v1 = aindex;
		comma(1);
		t2 = addr(&e2);
		v2 = aindex;
		if (t1 == S_A) {
			switch(t2) {
			case S_IMMED:			/* MOV	A,#	*/
				outab(0x04);	outrb(&e2, 0);		break;
			case S_DIR:			/* MOV	A,dir	*/
				outab(0x05);	outrb(&e2, R_PAG0);	break;
			case S_EXT:			/* MOV	A,ext	*/
				if (is_abs(&e2) && ((e2.e_addr & ~0xFF) == 0)) {
					outab(0x05);
					outab(e2.e_addr);		break;
				}
				outab(0x60);	outrw(&e2, 0);		break;
			case S_R:			/* MOV	A,Rn	*/
				outab(0x08 + v2);			break;
			case S_INDX:
				if (v2 == S_IX) {	/* MOV	A,@IX+d	*/
					outab(0x06);	outrb(&e2, 0);	break;
				} else
				if (v2 == S_EP) {	/* MOV	A,@EP	*/
					outab(0x07);			break;
				} else
				if (v2 == S_A) {	/* MOV	A,@A	*/
					outab(0x92);			break;
				}
				aerr();					break;
			default:	aerr();				break;
			}
			break;
		}
		if (t2 == S_A) {
			switch(t1) {
			case S_DIR:			/* MOV	dir,A	*/
				outab(0x45);	outrb(&e1, R_PAG0);	break;
			case S_EXT:			/* MOV	ext,A	*/
				if (is_abs(&e1) && ((e1.e_addr & ~0xFF) == 0)) {
					outab(0x05);
					outab(e1.e_addr);		break;
				}
				outab(0x61);	outrw(&e1, 0);		break;
			case S_R:			/* MOV	Rn,A	*/
				outab(0x48 + v1);			break;
			case S_INDX:
				if (v1 == S_IX) {	/* MOV	@IX+d,A	*/
					outab(0x46);	outrb(&e1, 0);	break;
				} else
				if (v1 == S_EP) {	/* MOV	@EP,A	*/
					outab(0x47);			break;
				}
				aerr();					break;
			default:	aerr();				break;
			}
			break;
		}
		if (t2 == S_IMMED) {
			switch(t1) {
			case S_DIR:			/* MOV	dir,#	*/
			case S_EXT:
				outab(0x85);
				outrb(&e1, R_PAG0);	outrb(&e2, 0);	break;
			case S_INDX:
				if (v1 == S_IX) {	/* MOV	@IX+d,#	*/
					outab(0x86);
					outrb(&e1, 0);	outrb(&e2, 0);	break;
				} else
				if (v1 == S_EP) {	/* MOV	@EP,#	*/
					outab(0x87);  	outrb(&e2, 0);	break;
				}
				aerr();					break;
			case S_R:			/* MOV	Rn,#	*/
				outab(0x88 + v1);	outrb(&e2, 0);	break;
			default:	aerr();				break;
			}
			break;
		}
		if ((t2 == S_T) &&
		   ((t1 == S_INDX) && (v1 == S_A))) {	/* MOV	@A,T	*/
			outab(0x82);
			break;
		}
		aerr();
		break;

	case S_MOVW:
		t1 = addr(&e1);
		v1 = aindex;
		comma(1);
		t2 = addr(&e2);
		v2 = aindex;
		if (t1 == S_A) {
			switch(t2) {
			case S_IMMED:			/* MOVW	A,#	*/
				outab(0xE4);	outrw(&e2, 0);		break;
			case S_DIR:			/* MOVW	A,dir	*/
				outab(0xC5);	outrb(&e2, R_PAG0);	break;
			case S_EXT:			/* MOVW	A,ext	*/
				if (is_abs(&e2) && ((e2.e_addr & ~0xFF) == 0)) {
					outab(0xC5);
					outab(e2.e_addr);		break;
				}
				outab(0xC4);	outrw(&e2, 0);		break;
			case S_INDX:
				if (v2 == S_IX) {	/* MOVW	A,@IX+d	*/
					outab(0xC6);	outrb(&e2, 0);	break;
				} else
				if (v2 == S_EP) {	/* MOVW	A,@EP	*/
					outab(0xC7);			break;
				} else
				if (v2 == S_A) {	/* MOVW	A,@A	*/
					outab(0x93);			break;
				}					break;
			case S_PC:			/* MOVW	A,PC	*/
				outab(0xF0);				break;
			case S_SP:			/* MOVW	A,SP	*/
				outab(0xF1);				break;
			case S_IX:			/* MOVW	A,IX	*/
				outab(0xF2);				break;
			case S_EP:			/* MOVW	A,EP	*/
				outab(0xF3);				break;
			case S_PS:			/* MOVW	A,PS	*/
				outab(0x70);				break;
			default:	aerr();				break;
			}
			break;
		}
		if (t2 == S_A) {
			switch(t1) {
			case S_DIR:			/* MOVW	dir,A	*/
				outab(0xD5);	outrb(&e1, R_PAG0);	break;
			case S_EXT:			/* MOVW	ext,A	*/
				if (is_abs(&e1) && ((e1.e_addr & ~0xFF) == 0)) {
					outab(0xD5);
					outab(e1.e_addr);		break;
				}
				outab(0xD4);	outrw(&e1, 0);		break;
			case S_INDX:
				if (v1 == S_IX) {	/* MOVW	@IX+d,A	*/
					outab(0xD6);	outrb(&e1, 0);	break;
				} else
				if (v1 == S_EP) {	/* MOVW	@EP,A	*/
					outab(0xD7);			break;
				} else
				if (v1 == S_A) {	/* MOVW	@A,A	*/
					outab(0x93);			break;
				}					break;
			case S_PC:			/* JMP	@A	*/
				outab(0xE0);				break;
			case S_SP:			/* MOVW	SP,A	*/
				outab(0xE1);				break;
			case S_IX:			/* MOVW	IX,A	*/
				outab(0xE2);				break;
			case S_EP:			/* MOVW	EP,A	*/
				outab(0xE3);				break;
			case S_PS:			/* MOVW	PS,A	*/
				outab(0x71);				break;
			default:	aerr();				break;
			}
			break;
		}
		if (t2 == S_IMMED) {
			switch(t1) {
			case S_SP:			/* MOVW	SP,#	*/
				outab(0xE5);	outrw(&e2, 0);		break;
			case S_IX:			/* MOVW	IX,#	*/
				outab(0xE6);	outrw(&e2, 0);		break;
			case S_EP:			/* MOVW	EP,#	*/
				outab(0xE7);	outrw(&e2, 0);		break;
			default:	aerr();				break;
			}
			break;
		}
		if ((t2 == S_T) &&
		   ((t1 == S_INDX) && (v1 == S_A))) {		/* MOVW	@A,T	*/
			outab(0x83);
			break;
		}
		aerr();
		break;

	case S_OP:
		t1 = addr(&e1);
		v1 = aindex;
		if ((t1 == S_A) && !more()) {
			outab(op + mp->m_flag);			/* OP	A	*/
			break;
		}
		if (mp->m_flag) {
			aerr();				/* OPW	opcode error	*/
		}
		comma(1);
		t2 = addr(&e2);
		v2 = aindex;
		if ((t2 == S_IMMED) && (op == 0x12)) {		/* CMP	__,#	*/
			switch(t1) {
			case S_A:				/* CMP	A,#	*/
				outab(0x14);	outrb(&e2, 0);		break;
			case S_DIR:				/* CMP *dir,#	*/
			case S_EXT:
				outab(0x95);
				outrb(&e1, R_PAG0);	outrb(&e2, 0);	break;
			case S_INDX:
				if (v1 == S_IX) {		/* CMP @IX+d,#	*/
					outab(0x96);
					outrb(&e1, 0);	outrb(&e2, 0);	break;
				} else
				if (v1 == S_EP) {		/* CMP @EP,#	*/
					outab(0x97);	outrb(&e2, 0);	break;
				}
				aerr();					break;
			case S_R:				/* CMP	Rn,#	*/
				outab(0x98 + v1);	outrb(&e2, 0);	break;
			default:
				aerr();					break;
			}						break;
		}
		if (t1 == S_A) {
			switch(t2) {
			case S_IMMED:				/* OP	A,#	*/
				outab(op + 2);	outrb(&e2, 0);		break;
			case S_DIR:
			case S_EXT:				/* OP	A,*dir	*/
				outab(op + 3);	outrb(&e2, R_PAG0);	break;
			case S_INDX:
				if (v2 == S_IX) {		/* OP	A,@IX+d	*/
					outab(op + 4);	outrb(&e2, 0);	break;
				} else
				if (v2 == S_EP) {		/* OP	A,@EP	*/
					outab(op + 5);			break;
				}
				aerr();					break;
			case S_R:				/* OP	A,Rn	*/
				outab(op + 6 + aindex);			break;
			default:
				aerr();					break;
			}						break;
		}
		aerr();
		break;

	case S_JMP:
		t1 = addr(&e1);
		if ((t1 == S_INDX) && (aindex == S_A)) {
			outab(0xE0);
			break;
		}
		if ((t1 == S_EXT) || (t1 == S_DIR)) {
			outab(op);
			outrw(&e1, 0);
			break;
		}
		aerr();
		break;

	case S_CALL:
		t1 = addr(&e1);
		if ((t1 == S_EXT) || (t1 == S_DIR)) {	/* CALL	ext	*/
			outab(op);
			outrw(&e1, 0);
			break;
		}
		aerr();
		break;

	case S_CALLV:
		t1 = addr(&e1);
		if (t1 == S_IMMED) {			/* CALLV #	*/
			outrbm(&e1, R_3BIT | R_MBRO, op);
			break;
		}
		aerr();
		break;

	case S_PUSH:
		t1 = addr(&e1);
		if (t1 == S_A) {			/* OP	A	*/
			outab(op);
			break;
		}
		if (t1 == S_IX) {			/* OP	IX	*/
			outab(op + 1);
			break;
		}
		aerr();
		break;

	case S_XCH:
		t1 = addr(&e1);
		comma(1);
		t2 = addr(&e2);
		if ((t1 == S_A) && (t2 == S_T)) {	/* XCH	A,T	*/
			outab(op);
			break;
		}
		aerr();
		break;

	case S_XCHW:
		if ((t1 = addr(&e1)) != S_A) {
			aerr();
		}
		comma(1);
		t2 = addr(&e2);
		if (t2 == S_T) {			/* XCHW	A,T	*/
			outab(op);
			break;
		}
		if ((t2 == S_PC) || (t2 == S_SP) || (t2 == S_IX) || (t2 == S_EP)) {
			outab(0xF4 + aindex);
			break;
		}
		aerr();
		break;

	case S_BIT:
		t1 = addr(&e1);
		if ((t1 != S_DIR) && (t1 != S_EXT)) {
			aerr();
			break;
		}
		if ((c = getnb()) != ':') {
			qerr();
			break;
		}
		expr(&e2, 0);
		outrbm(&e2, R_3BIT | R_MBRO, op);
		outrb(&e1, R_PAG0);
		break;

	case S_BRAB:
		t1 = addr(&e1);
		if ((t1 != S_DIR) && (t1 != S_EXT)) {
			aerr();
			break;
		}
		if ((c = getnb()) != ':') {
			qerr();
			break;
		}
		expr(&e2, 0);
		comma(1);
		expr(&e3, 0);
		outrbm(&e2, R_3BIT | R_MBRO, op);
		outrb(&e1, R_PAG0);
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

	case S_DECW:
		t1 = addr(&e1);
		if ((t1 == S_A) || (t1 == S_SP) || (t1 == S_IX) || (t1 == S_EP)) {
			outab(op + aindex);
			break;
		}
		aerr();
		break;

	case S_DEC:
		t1 = addr(&e1);
		if (t1 == S_R) {
			outab(op + aindex);
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

	case S_INH:
		outab(op);
		break;

	default:
		opcycles = OPCY_ERR;
		err('o');
		break;
	}

	if (opcycles == OPCY_NONE) {
		switch(mchtyp) {
		default:
		case X_8L:	opcycles = f8lcyc[cb[0] & 0xFF];	break;
		case X_8FX:	opcycles = f8xcyc[cb[0] & 0xFF];	break;
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

	if (pass == 0) {
		mchtyp = X_8L;
		sym[2].s_addr = X_8L;
	}
}

