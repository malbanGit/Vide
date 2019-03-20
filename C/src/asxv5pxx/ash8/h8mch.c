/* h8mch.c */

/*
 *  Copyright (C) 1994-2009  Alan R. Baldwin
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
#include "h8.h"

char	*cpu	= "Hitachi H8/3xx";
char	*dsft	= "asm";

#define	NB	512

int	*bp;
int	bm;
int	bb[NB];

/*
 * Opcode Cycle Definitions
 */
#define	OPCY_SDP	(-1)
#define	OPCY_ERR	(-2)

/*	OPCY_NONE	(0x80)	*/
/*	OPCY_MASK	(0x7F)	*/

#define	UN	(OPCY_NONE | 0x00)

/*
 * H8 Cycle Count
 *
 *	opcycles = h8pg1[opcode]
 */
static char h8pg1[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*10*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*20*/   4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
/*30*/   4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
/*40*/   4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
/*50*/  14,14,UN,UN, 8, 6,10,UN,UN, 4, 6, 8,UN, 6, 8, 8,
/*60*/   2, 2, 2, 2,UN,UN,UN, 2, 4, 4, 6, 6, 6, 6, 6, 6,
/*70*/   2, 2, 2, 2, 2, 2, 2, 2,UN, 4,UN, 8, 6, 8, 6, 8,
/*80*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*90*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*A0*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*B0*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*C0*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*D0*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*E0*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*F0*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
};

/*
 * Process a machine op.
 */
VOID
machine(mp)
struct mne *mp;
{
	int op, opflag;
	int oplb, ophb;
	int rf, opcode, c;
	struct expr e1, e2;
	struct area *espa;
	int t1, t2, v1, v2;
	char id[NCPS];
	a_uint pc;

	clrexpr(&e1);
	clrexpr(&e2);
	pc = dot.s_addr;
	op = (int) mp->m_valu;
	opflag = mp->m_flag;
	ophb = (op >> 8) & 0xFF;
	oplb = op & 0xFF;
	switch (rf = mp->m_type) {

	case S_SDP:
		opcycles = OPCY_SDP;
		espa = NULL;
		if (more()) {
			expr(&e1, 0);
			if (e1.e_flag == 0 && e1.e_base.e_ap == NULL) {
				if (e1.e_addr != ~0x00FF) {
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
			e1.e_addr = ~0x00FF;
			outdp(dot.s_area, &e1, 0);
		}
		lmode = SLIST;
		break;

	case S_OPS:
		t1 = addr(&e1);
		v1 = aindx;
		comma(1);
		t2 = addr(&e2);
		v2 = aindx;
		if ((t1 != S_IMMB) || (t2 != S_WREG)) {
			aerr();
		}
		if (e1.e_addr == 1) {	/* #1,Rd */
			outaw(op | (v2 & 0x0007));
		} else
		if (e1.e_addr == 2) {	/* #2,Rd */
			outaw(op | 0x0080 | (v2 & 0x0007));
		} else {		/* Error - #1,Rd */
			outaw(op | (v2 & 0x0007));
			aerr();
		}
		break;

	case S_OPX:
		t1 = addr(&e1);
		v1 = aindx;
		comma(1);
		t2 = addr(&e2);
		v2 = aindx;
		if (t2 != S_BREG) {
			aerr();
		}
		switch(t1) {
		default:
			aerr();

		case S_BREG:		/* Rs,Rd */
			outab(oplb);
			outab(((v1 & 0x000F) << 4) | (v2 & 0x000F));
			break;

		case S_IMMB:		/*  #xx:8,Rd */
		case S_IMMW:		/* #xx:16,Rd */
			outab(ophb | (v2 & 0x000F));
			outrb(&e1, R_NORM);
			normbyte(&e1);
			break;
		}
		break;

	case S_OP:
		t1 = addr(&e1);
		v1 = aindx;
		comma(1);
		t2 = addr(&e2);
		v2 = aindx;
		switch(t1) {
		default:
			aerr();

		case S_BREG:		/* Rs,Rd */
			if (t2 != S_BREG) {
				aerr();
			}
			outab(oplb);
			outab(((v1 & 0x000F) << 4) | (v2 & 0x000F));
			break;

		case S_IMMB:		/*  #xx:8,Rd /  #xx:8,ccr */
		case S_IMMW:		/* #xx:16,Rd / #xx:16,ccr */
			switch(t2) {
			default:
				aerr();

			case S_BREG:	/* #xx:8,Rd */
				outab(ophb | (v2 & 0x000F));
				outrb(&e1, R_NORM);
				normbyte(&e1);
				break;

			case S_CREG:	/* #xx:8,ccr */
				outab(oplb & 0x0F);
				outrb(&e1, R_NORM);
				normbyte(&e1);
				break;
			}
			break;
		}
		break;

	case S_MOV:
		t1 = addr(&e1);
		v1 = aindx;
		comma(1);
		t2 = addr(&e2);
		v2 = aindx;
		/*
		 * Evaluate Byte/Word Errors
		 */
		if (opflag == 1) {
			if (t1 == S_WREG) {
				t1 = S_BREG;
				aerr();
			}
			if (t2 == S_WREG) {
				t2 = S_BREG;
				aerr();
			}
		} else
		if (opflag == 2) {
			if (t1 == S_BREG) {
				t1 = S_WREG;
				aerr();
			}
			if (t2 == S_BREG) {
				t2 = S_WREG;
				aerr();
			}
		} else
		if (t1 == S_BREG) {
			if (t2 == S_WREG) {
				t2 = S_BREG;
				aerr();
			}
		} else
		if (t1 == S_WREG) {
			if (t2 == S_BREG) {
				t2 = S_WREG;
				aerr();
			}
		}
		if ((opflag == 2) || (t1 == S_WREG) || (t2 == S_WREG)) {
			v1 &= 0x0007;
			v2 &= 0x0007;
			opcode = 0x69;
		} else {
			v1 &= 0x000F;
			v2 &= 0x000F;
			opcode = 0x68;
		}
		/*
		 * Rn,...
		 */
		if ((t1 == S_BREG) || (t1 == S_WREG)) {
			switch(t2) {
			default:
				aerr();

			case S_BREG:	/* Rs,Rd (byte) */
				outab(0x0C);
				outab((v1 << 4) | v2);
				break;

			case S_WREG:	/* Rs,Rd (word) */
				outab(0x0D);
				outab((v1 << 4) | v2);
				break;

			case S_INDR:	/* Rs,@Rd */
				outab(opcode);
				outab(0x80 | (v2 << 4) | v1);
				break;

			case S_DIR:	/* Rs,*@aa:8 */
				if (t1 == S_WREG) {
					outab(opcode + 0x02);
					outab(0x80 | v1);
					outrw(&e2, R_NORM);
				} else {
					outab(0x30 | v1);
					outrb(&e2, R_PAGN);
					pagebyte(&e2);
				}
				break;

			case S_EXT:	/* Rs,@aa:16 */
				if (abstype(&e2) || t1 == S_WREG) {
					outab(opcode + 0x02);
					outab(0x80 | v1);
					outrw(&e2, R_NORM);
				} else {
					outab(0x30 | v1);
					outrb(&e2, R_PAGN);
					pagebyte(&e2);
				}
				break;

			case S_INDD:	/* Rs,@-Rd */
				if ((t1 == S_BREG) && ((v2 & 0x07) == 0x07)) {
					aerr();
				}
				outab(opcode + 0x04);
				outab(0x80 | (v2 << 4) | v1);
				break;

			case S_INDO:	/* Rs,@[d:16,Rd] */
				outab(opcode + 0x06);
				outab(0x80 | (v2 << 4) | v1);
				outrw(&e2, R_NORM);
				break;
			}
			break;
		}
		/*
		 * ...,Rn
		 */
		if ((t2 == S_BREG) || (t2 == S_WREG)) {
			switch(t1) {
			default:
				aerr();

			case S_BREG:	/* Rs,Rd (byte) */
				outab(0x0C);
				outab((v1 << 4) | v2);
				break;

			case S_WREG:	/* Rs,Rd (word) */
				outab(0x0D);
				outab((v1 << 4) | v2);
				break;

			case S_INDR:	/* @Rs,Rd */
				outab(opcode);
				outab((v1 << 4) | v2);
				break;

			case S_DIR:	/* *@aa:8,Rd */
				if (t2 == S_WREG) {
					outab(opcode + 0x02);
					outab(v2);
					outrw(&e1, R_NORM);
				} else {
					outab(0x20 | v2);
					outrb(&e1, R_PAGN);
					pagebyte(&e1);
				}
				break;

			case S_EXT:	/* @aa:16,Rd */
				if (abstype(&e1) || (t2 == S_WREG)) {
					outab(opcode + 0x02);
					outab(v2);
					outrw(&e1, R_NORM);
				} else {
					outab(0x20 | v2);
					outrb(&e1, R_PAGN);
					pagebyte(&e1);
				}
				break;

			case S_INDI:	/* @Rs+,Rd */
				if ((t2 == S_BREG) && ((v1 & 0x07) == 0x07)) {
					aerr();
				}
				outab(opcode + 0x04);
				outab((v1 << 4) | v2);
				break;

			case S_INDO:	/* @[d:16,Rs],Rd */
				outab(opcode + 0x06);
				outab((v1 << 4) | v2);
				outrw(&e1, R_NORM);
				break;

			case S_IMMB:	/* #xx,Rd */
			case S_IMMW:	/* #xx,Rd */
				if (t2 == S_BREG) {
					outab(0xF0 | v2);
					outrb(&e1, R_NORM);
					normbyte(&e1);
				} else {
					outaw(0x7900 | v2);
					outrw(&e1, R_NORM);
				}
				break;
			}
			break;
		}
		/*
		 * Error
		 */
		if (opflag == 2) {
			outaw(0x7900);
			outaw(0x0000);
		} else {
			outaw(0xF000);
		}
		aerr();
		break;

	case S_ADD:
	case S_CMP:
	case S_SUB:
		t1 = addr(&e1);
		v1 = aindx;
		comma(1);
		t2 = addr(&e2);
		v2 = aindx;
		if ((rf != S_SUB) && ((t1 == S_IMMB) || (t1 == S_IMMW))) {
			if (t2 != S_BREG) {
				aerr();
			}
			outab(ophb | (v2 & 0x000F));
			outrb(&e1, R_NORM);
			normbyte(&e1);
			break;
		}
		/*
 		 * Rs,Rd (byte)
		 */
		if (opflag == 1) {
			if ((t1 != S_BREG) || (t2 != S_BREG)) {
				aerr();
			}
		} else
		/*
 		 * Rs,Rd (word)
		 */
		if (opflag == 2) {
			if ((t1 != S_WREG) || (t2 != S_WREG)) {
				aerr();
			}
			v1 &= 0x0007;
			v2 &= 0x0007;
		} else
		/*
 		 * Rs,Rd (byte/word)
		 */
		{
			if ((t1 != S_BREG) && (t1 != S_WREG)) {
				aerr();
			}
			if ((t2 != S_BREG) && (t2 != S_WREG)) {
				aerr();
			}
			if (t1 != t2) {
				aerr();
			}
		}
		if ((opflag == 2) || (t1 == S_WREG)) {
			outab(op | 0x01);
			outab(((v1 & 0x0007) << 4) | (v2 & 0x0007));
		} else {
			outab(op);
			outab(((v1 & 0x000F) << 4) | (v2 & 0x000F));
		}
		break;

	case S_SOP:
		t1 = addr(&e1);
		v1 = aindx;
		if ( t1 != S_BREG) {
			aerr();
		}
		outaw(op | (v1 & 0x0F));
		break;

	case S_CCR:
		t1 = addr(&e1);
		v1 = aindx;
		/*
		 * #xx (,ccr)		andc, ldc, orc, xorc
		 */
		if ((opflag != 2) && ((t1 == S_IMMB) || (t1 == S_IMMW))) {
			/*
			 * Optional ,ccr
			 */
			if (more()) {
				comma(1);
				if (!admode(ccr_reg)) {
					aerr();
				}
			}
			outab(ophb);
			outrb(&e1, R_NORM);
			normbyte(&e1);
			break;
		}
		/*
		 * Rs (,ccr)		ldc
		 */
		if ((opflag == 1) && ((t1 == S_BREG) || (t1 == S_WREG))) {
			/*
			 * Optional ,ccr
			 */
			if (more()) {
				comma(1);
				if (!admode(ccr_reg)) {
					aerr();
				}
			}
			outab(0x03);
			outab(v1 & 0x000F);
			if (t1 == S_WREG) {
				aerr();
			}
			break;
		}
		/*
		 * (ccr,) Rs		stc
		 */
		if ((opflag == 2) && (t1 == S_CREG)) {
			comma(1);
			t2 = addr(&e1);
			v2 = aindx;
			outab(0x02);
			outab(v2 & 0x000F);
			if (t2 != S_BREG) {
				aerr();
			}
			break;
		} else
		if ((opflag == 2) && ((t1 == S_BREG) || (t1 == S_WREG))) {
			outab(0x02);
			outab(v1 & 0x000F);
			if ((t1 != S_BREG) || more()) {
				aerr();
			}
			break;
		}
		/*
		 * Error
		 */
		outaw(op);
		aerr();
		break;

	case S_INH:
		outaw(op);
		break;

	case S_MLDV:
		t1 = addr(&e1);
		v1 = aindx;
		comma(1);
		t2 = addr(&e2);
		v2 = aindx;
		if (t1 != S_BREG) {
			aerr();
		}
		if (t2 != S_WREG) {
			aerr();
		}
		outaw(op | ((v1 & 0x000F) << 4) | (v2 & 0x0007));
		break;

	case S_ROSH:
		t1 = addr(&e1);
		v1 = aindx;
		if ( t1 != S_BREG) {
			aerr();
		}
		outaw(op | (v1 & 0x000F));
		break;

	case S_PP:
		t1 = addr(&e1);
		v1 = aindx;
		if ( t1 != S_WREG) {
			aerr();
		}
		outaw(op | (v1 & 0x0007));
		break;

	case S_MVFPE:
		t1 = addr(&e1);
		v1 = aindx;
		comma(1);
		t2 = addr(&e2);
		v2 = aindx;
		if ((t1 != S_EXT) && (t1 != S_DIR)) {
			aerr();
		}
		if (t2 != S_BREG) {
			aerr();
		}
		outaw(op | (v2 & 0x000F));
		outrw(&e1, R_NORM);
		break;

	case S_MVTPE:
		t1 = addr(&e1);
		v1 = aindx;
		comma(1);
		t2 = addr(&e2);
		v2 = aindx;
		if (t1 != S_BREG) {
			aerr();
		}
		if ((t2 != S_EXT) && (t2 != S_DIR)) {
			aerr();
		}
		outaw(op | (v1 & 0x000F));
		outrw(&e2, R_NORM);
		break;

	case S_EEPMOV:
		outaw(op);
		outaw(0x598F);
		break;

	case S_JXX:
		t1 = addr(&e1);
		v1 = aindx;
		switch(t1) {
		case S_INDR:	/* @Rn */
			outaw(op | ((v1 & 0x0007) << 4));
			break;

		case S_EXT:	/* @aa:16  */
		case S_DIR:	/* *@aa:8 */
			outaw(op + 0x0100);
			outrw(&e1, R_NORM);
			break;

		case S_INDM:	/* @@aa:8 */
			outab(ophb + 0x02);
			outrb(&e1, R_USGN);
			usgnbyte(&e1);
			break;

		default:
			outaw(op);
			aerr();
			break;
		}
		break;

	case S_BIT1:
		t1 = addr(&e1);
		v1 = aindx;
		comma(1);
		t2 = addr(&e2);
		v2 = aindx;
		switch(t1) {
		default:
		case S_WREG:		/* Rn(word),xxx */
			aerr();

		case S_BREG:		/* Rn(byte),xxx */
			switch(t2) {
			default:
			case S_WREG:	/* Rn(byte),Rd(word) */
				aerr();

			case S_BREG:	/* Rn(byte),Rd(byte) */
				outaw(op | ((v1&0x000F) << 4) | (v2&0x000F));
				break;

			case S_INDR:	/* Rn(byte),@Rd(word) */
				outaw(0x7D00 | ((v2 & 0x0007) << 4));
				outaw(op | ((v1&0x000F) << 4));
				break;

			case S_EXT:	/* Rn(byte),@aa:16 */
			case S_DIR:	/* Rn(byte),*@aa:8 */
				outab(0x7F);
				outrb(&e2, R_PAGN);
				pagebyte(&e2);
				outaw(op | ((v1&0x000F) << 4));
				break;
			}
			break;

		case S_IMMB:
			if ((v1 = (int) e1.e_addr) & ~0x07) {
				aerr();
			}
			if (e1.e_flag != 0 || e1.e_base.e_ap != NULL) {
				aerr();
			}
			op |= 0x1000;
			switch(t2) {
			default:
			case S_WREG:	/* #xx:3,Rd(word) */
				aerr();

			case S_BREG:	/* #xx:3,Rd(byte) */
				outaw(op | ((v1&0x0007) << 4) | (v2&0x000F));
				break;

			case S_INDR:	/* #xx:3,@Rd(word) */
				outaw(0x7D00 | ((v2 & 0x0007) << 4));
				outaw(op | ((v1&0x0007) << 4));
				break;

			case S_EXT:	/* #xx:3,@aa:16 */
			case S_DIR:	/* #xx:3,*@aa:8 */
				outab(0x7F);
				outrb(&e2, R_PAGN);
				pagebyte(&e2);
				outaw(op | ((v1&0x0007) << 4));
				break;
			}
			break;
		}
		break;

	case S_BIT2:
		t1 = addr(&e1);
		v1 = aindx;
		comma(1);
		t2 = addr(&e2);
		v2 = aindx;
		switch(t1) {
		default:
			aerr();

		case S_IMMB:
			if ((v1 = (int) e1.e_addr) & ~0x07) {
				aerr();
			}
			if (e1.e_flag != 0 || e1.e_base.e_ap != NULL) {
				aerr();
			}
			switch(t2) {
			default:
			case S_WREG:	/* #xx:3,Rd(word) */
				aerr();

			case S_BREG:	/* #xx:3,Rd(byte) */
				outaw(op | ((v1&0x0007) << 4) | (v2&0x000F));
				break;

			case S_INDR:	/* #xx:3,@Rd(word) */
				if (op & 0x1000) {
					outaw(0x7C00 | ((v2 & 0x0007) << 4));
				} else {
					outaw(0x7D00 | ((v2 & 0x0007) << 4));
				}
				outaw(op | ((v1&0x000F) << 4));
				break;

			case S_EXT:	/* #xx:3,@aa:16 */
			case S_DIR:	/* #xx:3,*@aa:8 */
				if (op & 0x1000) {
					outab(0x7E);
				} else {
					outab(0x7F);
				}
				outrb(&e2, R_PAGN);
				pagebyte(&e2);
				outaw(op | ((v1&0x000F) << 4));
				break;
			}
			break;
		}
		break;

	case S_BRA:
		expr(&e1, 0);
		outab(ophb);
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

	default:
		opcycles = OPCY_ERR;
		err('o');
		break;
	}
	if (pc & 0x0001) {
		err('b');
		dot.s_addr += 1;
	}
	if (opcycles == OPCY_NONE) {
		opcycles = h8pg1[cb[0] & 0xFF];
	}
}

VOID
normbyte(esp)
struct expr *esp;
{
	int v;

	if (esp->e_flag == 0 && esp->e_base.e_ap == NULL) {
		v = (int) esp->e_addr;
		if (((v & ~0x007F) != ~0x007F) && ((v & 0x00FF) != v)) {
			aerr();
		}
	}
}

VOID
usgnbyte(esp)
struct expr *esp;
{
	if (esp->e_flag == 0 && esp->e_base.e_ap == NULL) {
		if (esp->e_addr & ~0x00FF) {
			aerr();
		}
	}
}

VOID
pagebyte(esp)
struct expr *esp;
{
	if (esp->e_flag == 0 && esp->e_base.e_ap == NULL) {
		if ((esp->e_addr & ~0x00FF) != ~0x00FF) {
			aerr();
		}
	}
}

int
abstype(esp)
struct expr *esp;
{
	a_uint espv;
	struct area *espa;

	espv = esp->e_addr;
	espa = esp->e_base.e_ap;

	if (pass == 0) {
		return(1);
	} else
	if (espa) {
		return(1);
	} else
	if (pass == 1) {
		if (espv >= dot.s_addr) {
			espv = (esp->e_addr -= fuzz);
		}
		return(setbit(((espv & ~0x00FF) != ~0x00FF) ? 1 : 0));
	} else {
		return(getbit());
	}
}

/*
 * Machine specific initialization.
 * Set up the bit table.
 * Process any setup code.
 */
VOID
minit()
{
	char **dp;

	/*
	 * Byte Order
	 */
	hilo = 1;

	bp = bb;
	bm = 1;

	for (dp = dpcode; *dp; dp++) {
		strcpy(ib,*dp);
		cp = cb;
		cpt = cbt;
		ep = eb;
		ip = ib;
		asmbl();
	}
}

/*
 * H8/3xx Initialization Coding
 */
char *dpcode[] = {
	";	H8/3xx Direct Page Initialization",
	"	.setdp	0xFF00,_CODE",
	"",
	NULL
};

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


