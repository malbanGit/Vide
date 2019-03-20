/* i48mch.c */

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

#include "asxxxx.h"
#include "i8048.h"

char	*cpu	= "Intel 8048";
char	*dsft	= "asm";

int	mchtyp;

/*
 * Opcode Cycle Definitions
 */
#define	OPCY_SDP	((char) (0xFF))
#define	OPCY_ERR	((char) (0xFE))

/*	OPCY_NONE	((char) (0x80))	*/
/*	OPCY_MASK	((char) (0x7F))	*/

#define	UN		((char) (OPCY_NONE | 0x00))

#define	OPCY_CPU	((char) (0xFD))

/*
 * 8048 Cycle Count
 *
 *	opcycles = i48pg1[opcode]
 */
static char i48pg1[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/   1, 1, 2, 2, 2, 1,UN, 1, 2, 2, 2,UN, 2, 2, 2, 2,
/*10*/   1, 1, 2, 2, 2, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*20*/   1, 1, 1, 2, 2, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*30*/   1, 1, 2,UN, 2, 1, 2, 1, 2, 2, 2,UN, 2, 2, 2, 2,
/*40*/   1, 1, 1, 2, 2, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*50*/   1, 1, 2, 2, 2, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*60*/   1, 1, 1,UN, 2, 1,UN, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*70*/   1, 1, 2,UN, 2, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*80*/   2, 2,UN, 2, 2, 1, 2,UN, 2, 2, 2,UN, 2, 2, 2, 2,
/*90*/   2, 2, 2, 2, 2, 1, 2, 1, 2, 2, 2,UN, 2, 2, 2, 2,
/*A0*/   1, 1,UN, 2, 2, 1,UN, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*B0*/   2, 2, 2, 2, 2, 1, 2,UN, 2, 2, 2, 2, 2, 2, 2, 2,
/*C0*/  UN,UN,UN,UN, 2, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*D0*/   1, 1, 2, 2, 2, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*E0*/  UN,UN,UN, 2, 2, 1, 2, 1, 2, 2, 2, 2, 2, 2, 2, 2,
/*F0*/   1, 1, 2,UN, 2, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1
};

/*
 * Process machine ops.
 */
VOID
machine(mp)
struct mne *mp;
{
	int op, t1, t2, v1, v2;
	struct expr e1, e2;

	clrexpr(&e1);
	clrexpr(&e2);

	op = (int) mp->m_valu;
	switch (mp->m_type) {

	case S_CPU:
		mchtyp = op;
		sym[2].s_addr = op;
		opcycles = OPCY_CPU;
		lmode = SLIST;
		break;

	case S_ARL1:		/* ADD/ADDC/XRL  A,#imm; A,@R0; A,@R1; A,R0 to A,R7 */
	case S_ARL2:		/* ANL/ORL  PORT,#imm; A,#imm; A,@R0; A,@R1; A,R0 to A,R7 */
		t1 = addr(&e1);

		if ((t1 == S_PORT) && (mp->m_type == S_ARL2)) {
			comma(1);
			t2 = addr(&e2);
			if (t2 == S_IMMED) {
				v1 = (int) e1.e_addr;
				v2 = (int) e2.e_addr;
				if (v1 == 0) {
					if (mchtyp & ~X_8048) {
						opcycles = OPCY_ERR;
						err('o');
						break;
					}
					switch (op) {
					case 0x53:	outab(0x98 | v1);	outrb(&e2, R_NORM);	break;
 		        		case 0x43:	outab(0x88 | v1);	outrb(&e2, R_NORM);	break;
					default:	aerr();			break;
					}
					break;
				}
				if ((v1 == 1) || (v1 == 2))  {
					if (mchtyp & ~(X_8041 | X_8048)) {
						opcycles = OPCY_ERR;
						err('o');
						break;
					}
					switch (op) {
					case 0x53:	outab(0x98 | v1);	outrb(&e2, R_NORM);	break;
 		        		case 0x43:	outab(0x88 | v1);	outrb(&e2, R_NORM);	break;
					default:	aerr();			break;
					}
					break;
				}
			} else {
				aerr();
			}
		} else
		if (t1 == S_A) {
			comma(1);
			clrexpr(&e1);
			t1 = addr(&e1);
		}
		v1 = (int) e1.e_addr;
		switch (t1) {
		case S_IMMED:
			outab(op);
			outrb(&e1, R_NORM);
			break;

		case S_IR:
			switch (op) {
			case 0x03:	outab(0x60 | v1);	break;
 		        case 0x13:	outab(0x70 | v1);	break;
			case 0xD3:	outab(0xD0 | v1);	break;
			case 0x53:	outab(0x50 | v1);	break;
			case 0x43:	outab(0x40 | v1);	break;
			default:	aerr();			break;
			}
			break;

		case S_R:
			switch (op) {
			case 0x03:	outab(0x68 | v1);	break;
 		        case 0x13:	outab(0x78 | v1);	break;
			case 0xD3:	outab(0xD8 | v1);	break;
			case 0x53:	outab(0x58 | v1);	break;
			case 0x43:	outab(0x48 | v1);	break;
			default:	aerr();			break;
			}
			break;

		default:
			aerr();
			break;
		}
		if (more()) {
			aerr();
		}
		break;

	case S_ARL3:		/* ANLD/ORLD  EP,A */
		t1 = addr(&e1);
		v1 = (int) e1.e_addr;
		comma(1);
		t2 = addr(&e2);

		if (t2 != S_A) {
			aerr();
		} else
		if ((t1 == S_PORT) && (v1 > 3) && (v1 < 8)) {
			outab(op | (v1 & 0x03));
		} else {
			aerr();
		}
		break;

	case S_XCH:		/* XCH	A,RN; A,@Rn */
	case S_XCHD:		/* XCHD	A,@Rn */
		t1 = addr(&e1);
		if (t1 == S_A) {
			comma(1);
			clrexpr(&e1);
			t1 = addr(&e1);
		}
		v1 = (int) e1.e_addr;
		if (t1 == S_IR) {
			outab(op | v1);
		} else
		if ((t1 == S_R) && (mp->m_type == S_XCH)) {
			outab(op | 0x08 | v1);
		} else {
			aerr();
		}
		break;

	case S_DEC:		/* DEC	A; RN */
		if (more()) {
			t1 = addr(&e1);
			v1 = (int) e1.e_addr;
			if (t1 == S_A) {
				outab(op);
			} else
			if (t1 == S_R) {
				if (mchtyp & ~(X_8041 | X_8048)) {
					opcycles = OPCY_ERR;
					err('o');
					break;
				}
				outab(0xC8 | v1);
			} else {
				aerr();
			}
		} else {
			outab(op);
		}
		break;

	case S_INC:		/* INC	A; RN; @Rn */
		if (more()) {
			t1 = addr(&e1);
			v1 = (int) e1.e_addr;
			if (t1 == S_A) {
				outab(op);
			} else
			if (t1 == S_R) {
				outab(0x18 | v1);
			} else
			if (t1 == S_IR) {
				if (mchtyp & ~(X_8041 | X_8048)) {
					opcycles = OPCY_ERR;
					err('o');
					break;
				}
				outab(0x10 | v1);
			} else {
				aerr();
			}
		} else {
			outab(op);
		}
		break;

	case S_CLR:		/* CLR / CPL */
		if (more()) {
			t1 = addr(&e1);
			if (((t1 == S_F0) || (t1 == S_F1)) && (mchtyp & ~(X_8041 | X_8048))) {
				opcycles = OPCY_ERR;
				err('o');
				break;
			}
			switch (t1) {
			case S_A:	outab(op);		break;
			case S_F0:	outab(op + 0x5E);	break;
			case S_C:	outab(op + 0x70);	break;
			case S_F1:	outab(op + 0x7E);	break;
			default:	aerr();			break;
			}
		} else {
			outab(op);
		}
		break;


	case S_ACC:		/* DA / RAD / RL / RLC / RR / RRC / SWAP */
		if (more()) {
			t1 = addr(&e1);
			if (t1 != S_A) {
				aerr();
				break;
			}
		}
		if ((op == 0x80) && (mchtyp & ~X_8022)) {
			opcycles = OPCY_ERR;
			err('o');
			break;
		}
		outab(op);
		break;

	case S_MOV:		/* MOV instruction, all modes */
		t1 = addr(&e1);
		v1 = (int) e1.e_addr;
		switch (t1) {
		case S_A:	/* MOV  A,#DATA; A,T; A,PSW; A,@R; A,RN */
			comma(1);
			t2 = addr(&e2);
			v2 = (int) e2.e_addr;
			if ((t2 == S_PSW) && (mchtyp & ~(X_8041 | X_8048))) {
				opcycles = OPCY_ERR;
				err('o');
				break;
			}
			switch (t2) {
			case S_IMMED:	outab(0x23);		outrb(&e2, R_NORM);	break;
			case S_T:	outab(0x42);		break;
			case S_PSW:	outab(0xC7);		break;
			case S_IR:	outab(0xF0 | v2);	break;
			case S_R:	outab(0xF8 | v2);	break;
			default:	aerr();			break;
			}
			break;

		case S_PSW:	/* MOV  PSW,A */
			if (more()) {
				comma(1);
				t2 = addr(&e2);
				if (t2 != S_A) {
					aerr();
					break;
				}
				op = 0xD7;
			} else {
				op = 0xC7;
			}
			if (mchtyp & ~(X_8041 | X_8048)) {
				opcycles = OPCY_ERR;
				err('o');
				break;
			}
			outab(op);
			break;

		case S_T:	/* MOV  T,A */
			if (more()) {
				comma(1);
				t2 = addr(&e2);
				if (t2 != S_A) {
					aerr();
					break;
				}
				outab(0x62);
			} else {
				outab(0x42);
			}
			break;

		case S_R:	/* MOV  RN,A; RN,#DATA */
			if (more()) {
				comma(1);
				t2 = addr(&e2);
				switch (t2) {
				case S_A:	outab(0xA8 | v1);	break;
				case S_IMMED:	outab(0xB8 | v1);	outrb(&e2, R_NORM);	break;
				default:	aerr();			break;
				}
			} else {
				outab(0xF8 | v1);
			}
			break;

		case S_IR:	/* MOV  @R,A; @R,#DATA */
			if (more()) {
				comma(1);
				t2 = addr(&e2);
				switch (t2) {
				case S_A:	outab(0xA0 | v1);	break;
				case S_IMMED:	outab(0xB0 | v1);	outrb(&e2, R_NORM);	break;
				default:	aerr();			break;
				}
			} else {
				outab(0xF0 | v1);
			}
			break;

		case S_IMMED:	/* MOV  A,#DATA */
			if (more()) {
				aerr();
			} else {
				outab(0x23);
				outrb(&e1, R_NORM);
			}
			break;

		default:
			aerr();
			break;
		}
		break;

	case S_MOVD:		/* MOVD  A,EP; EP,A */
		t1 = addr(&e1);
		v1 = (int) e1.e_addr;
		if (t1 == S_A) {
			comma(1);
			t2 = addr(&e2);
			v2 = (int) e2.e_addr;
			if ((t2 == S_PORT) && (v2 > 3) && (v2 < 8)) {
				outab(op | (v2 & 0x03));
			} else {
				aerr();
			}
			break;
		} else
		if ((t1 == S_PORT) && (v1 > 3) && (v1 < 8)) {
			if (more()) {
				comma(1);
				t2 = addr(&e2);
				if (t2 != S_A) {
					aerr();
					break;
				}
				if (mchtyp & ~(X_8021 | X_8041 | X_8048)) {
					opcycles = OPCY_ERR;
					err('o');
					break;
				}
				op = op | 0x30;
			}
			outab(op | (v1 & 0x03));
		} else {
			aerr();
		}
		break;

	case S_MOVP:		/* MOVP  A,@A */
	case S_MOVP3:		/* MOVP3 A,@A */
		t1 = addr(&e1);
		if (t1 == S_A) {
			comma(1);
			clrexpr(&e1);
			t1 = addr(&e1);
		}
		v1 = (int) e1.e_addr;
		if (t1 == S_IA) {
			if ((mp->m_type == S_MOVP3) && (mchtyp & ~(X_8041 | X_8048))) {
				opcycles = OPCY_ERR;
				err('o');
				break;
			}
			outab(op);
		} else {
			aerr();
		}
		break;

	case S_MOVX:		/* A,@R0 / A,@R1 / @R0,A / @R1,A */
		t1 = addr(&e1);
		v1 = (int) e1.e_addr;
		if (t1 == S_A) {
			comma(1);
			t2 = addr(&e2);
			v2 = (int) e2.e_addr;
			if (mchtyp & ~X_8048) {
				opcycles = OPCY_ERR;
				err('o');
				break;
			}
			if (t2 == S_IR) {
				outab(op | v2);
			} else {
				aerr();
			}
			break;
		} else
		if (t1 == S_IR) {
			if (more()) {
				comma(1);
				t2 = addr(&e2);
				if (t2 != S_A) {
					aerr();
					break;
				}
				op = 0x90;
			}
			if (mchtyp & ~X_8048) {
				opcycles = OPCY_ERR;
				err('o');
				break;
			}
			outab(op | v1);
		} else {
			aerr();
		}
		break;

	case S_JMP11:		/* JMP Addr / CALL Addr */
		/*
		 * 11 bit destination.
		 * Top 3 bits become the MSBs of the op-code.
		 */
		expr(&e1, 0);
		mchrel(&e1);
		outrwm(&e1, R_PAGX0 | R_J11, op << 8);
		break;

	case S_JMPP:		/* JMP	@A */
		t1 = addr(&e1);
		if (t1 == S_IA) {
			outab(op);
		} else {
			aerr();
		}
		break;

	case S_BITBR:		/* JBN	Addr8 */
		/*
		 * 8 bit destination.
		 */
		expr(&e1, 0);
		mchrel(&e1);
		if (mchtyp & ~(X_8041 | X_8048)) {
			opcycles = OPCY_ERR;
			err('o');
			break;
		}
		outrwm(&e1, R_PAGX0 | R_J8, op << 8);
		break;

	case S_BR:		/* JMP on current page */
		/*
		 * 8 bit destination.
		 */
		expr(&e1, 0);
		mchrel(&e1);
		switch (mchtyp) {
		default:
		case X_8048:
			switch (op) {
			default:	outrwm(&e1, R_PAGX0 | R_J8, op << 8);	break;
			case 0xD6: /* JNIBF */
				opcycles = OPCY_ERR;
				err('o');
				break;
			}
			break;
		case X_8041:
			switch (op) {
			default:	outrwm(&e1, R_PAGX0 | R_J8, op << 8);	break;
			case 0x86: /* JNI / JOBF */
				opcycles = OPCY_ERR;
				err('o');
				break;
			}
			break;
		case X_8022:
		case X_8021:
			switch (op) {
			default:	outrwm(&e1, R_PAGX0 | R_J8, op << 8);	break;
			case 0x26: /* JNT0 */
			case 0x36: /* JT0 */
			case 0x46: /* JNT1 */
			case 0x76: /* JF1 */
			case 0x86: /* JNI / JOBF */
			case 0xB6: /* JF0 */
			case 0xD6: /* JNIBF */
				opcycles = OPCY_ERR;
				err('o');
				break;
			}
			break;
		}
		break;

	case S_DJNZ:		/* DJNZ	RN,Addr8 */
		t1 = addr(&e1);
		if (t1 == S_R) {
			v1 = (int) e1.e_addr;
			comma(1);
			expr(&e2, 0);
			mchrel(&e2);
			outrwm(&e2, R_PAGX0 | R_J8, (op | v1) << 8);
		} else {
			aerr();
		}
		break;

	case S_INH:		/* NOP / RET / RETR */
		if ((op == 0x93) && (mchtyp & ~(X_8041 | X_8048))) {
			opcycles = OPCY_ERR;
			err('o');
			break;
		}
		if ((op == 0x00) && (mchtyp & ~(X_8021 | X_8041 | X_8048))) {
			opcycles = OPCY_ERR;
			err('o');
			break;
		}
		outab(op);
		break;

	case S_DIS:		/* DIS / EN */
		t1 = addr(&e1);
		if (mchtyp & ~(X_8041 | X_8048)) {
			opcycles = OPCY_ERR;
			err('o');
			break;
		}
		switch (t1) {
		case S_I:	outab(op);		break;
		case S_TCNTI:	outab(op + 0x20);	break;
		default:	aerr();			break;
		}
		break;

	case S_IN:		/* IN A,PN / IN A,DBB */
		t1 = addr(&e1);
		if (t1 == S_A) {
			comma(1);
			clrexpr(&e1);
			t1 = addr(&e1);
		}
		v1 = (int) e1.e_addr;
		if ((t1 == S_PORT) && (v1 > 0) && (v1 < 3)) {
			outab(op | v1);
		} else
		if (t1 == S_DBB) {
			if (mchtyp & ~X_8041) {
				opcycles = OPCY_ERR;
				err('o');
				break;
			}
			outab(0x22);
		} else {
			aerr();
		}
		break;

	case S_INS:		/* INS A,BUS */
		t1 = addr(&e1);
		if (t1 == S_A) {
			comma(1);
			clrexpr(&e1);
			t1 = addr(&e1);
		}
		v1 = (int) e1.e_addr;
		if ((t1 == S_PORT) && (v1 == 0)) {
			if (mchtyp & ~X_8048) {
				opcycles = OPCY_ERR;
				err('o');
				break;
			}
			outab(op);
		} else {
			aerr();
		}
		break;

	case S_OUT:		/* OUT DBB,A */
		t1 = addr(&e1);
		v1 = (int) e1.e_addr;
		if (more()) {
			comma(1);
			t2 = addr(&e2);
			if (t2 != S_A) {
				aerr();
				break;
			}
		}
		if (t1 == S_DBB) {
			if (mchtyp & ~X_8041) {
				opcycles = OPCY_ERR;
				err('o');
				break;
			}
			outab(op);
		} else
		if ((t1 == S_PORT) && (v1 == 0)) {
			outab(op);
		} else {
			aerr();
		}
		break;

	case S_OUTL:		/* OUTL PORT,A / OUTL BUS,A */
		t1 = addr(&e1);
		v1 = (int) e1.e_addr;
		if (more()) {
			comma(1);
			t2 = addr(&e2);
			if (t2 != S_A) {
				aerr();
				break;
			}
		}
		if ((t1 == S_PORT) && (v1 == 0)) {
			if (mchtyp & ~X_8048) {
				opcycles = OPCY_ERR;
				err('o');
				break;
			}
			outab(op);
		} else
		if ((t1 == S_PORT) && (v1 > 0) && (v1 < 3)) {
				outab(0x38 | v1);
		} else {
			aerr();
		}
		break;

	case S_ENT0:		/* ENT0 CLK */
		t1 = addr(&e1);
		if (mchtyp & ~X_8048) {
			opcycles = OPCY_ERR;
			err('o');
			break;
		}
		switch (t1) {
		case S_CLK:	outab(op);		break;
		default:	aerr();			break;
		}
		break;

	case S_STRT: 		/* START CNT / START T */
		t1 = addr(&e1);
		switch (t1) {
		case S_CNT:	outab(op);		break;
		case S_T:	outab(0x55);		break;
		default:	aerr();			break;
		}
		break;

	case S_STOP: 		/* STOP TCNT */
		t1 = addr(&e1);
		switch (t1) {
		case S_TCNT:	outab(op);		break;
		default:	aerr();			break;
		}
		break;

	case S_SEL:		/* SEL	AN0/AN1/MB0/MB1/RB0/RB1 */
		t1 = addr(&e1);
		v1 = (int) e1.e_addr;
		switch (v1) {
		case 0x85: /* AN0 */
		case 0x95: /* AN1 */
			if (mchtyp & ~X_8022) {
				opcycles = OPCY_ERR;
				err('o');
				break;
			}
			outab(v1);
			break;
		case 0xC5: /* RB0 */
		case 0xD5: /* RB1 */
		case 0xE5: /* MB0 */
		case 0xF5: /* MB1 */
			if (mchtyp & ~X_8048) {
				opcycles = OPCY_ERR;
				err('o');
				break;
			}
			outab(v1);
			break;
		default:
			err('o');
			break;
		}
		break;

	default:
		opcycles = OPCY_ERR;
		err('o');
		break;
	}
	if (opcycles == OPCY_NONE) {
		opcycles = i48pg1[cb[0] & 0xFF];
		if (opcycles == 0) {
			err('o');
		}
	}
}

/*
 * Make Branch/Jump Relative to .__.ABS.
 */
VOID
mchrel(esp)
struct expr *esp;
{
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
}

/*
 * Machine specific initialization
 */
VOID
minit()
{
	/*
	 * Byte Order
	 */
	hilo = 1;

	if (pass == 0) {
		mchtyp = X_8048;
		sym[2].s_addr = X_8048;
	}
}

