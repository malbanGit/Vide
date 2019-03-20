/* avrmch.c */

/*
 *  Copyright (C) 2001-2009  Alan R. Baldwin
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
#include "avr.h"

char	*cpu	= "Atmel AVR 8-Bit RISC";
char	*dsft	= "asm";

static char buff[80];
static int avr_4k;
static int avr_bytes;
static a_uint mchtyp;

#define	OPCODE_ERRORS	(1)

#if 0
/* *****-----*****-----***** */ /* Opcode Error Prototype */
#if OPCODE_ERRORS
	if (mchtyp &   (AT90S1200|AT90S2313|AT90S2343|AT90S2323|AT90S2333|AT90S4433|
			AT90S4414|AT90S8515|AT90S4434|AT90S8535|AT90C8534|
			ATmega603|ATmega103|ATmega161|ATmega163|
			ATtiny10|ATtiny11|ATtiny12|ATtiny15|ATtiny22|ATtiny28)	) {
		err('o');
	}
#endif
/* *****-----*****-----***** */
#endif


/*
 * Opcode Cycle Definitions
 */
#define	OPCY_SDP	((char) (0xFF))
#define	OPCY_ERR	((char) (0xFE))

/*	OPCY_NONE	((char) (0x80))	*/
/*	OPCY_MASK	((char) (0x7F))	*/

#define	OPCY_4K		((char) (0xFD))
#define	OPCY_CPU	((char) (0xFC))
#define	OPCY_BITS	((char) (0xFB))

#define	UN	((char) (OPCY_NONE | 0x00))
#define	PX	((char) (OPCY_NONE | 0x01))

static char  avrpg1[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/  PX, 1, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*10*/   3, 3, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*20*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*30*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*40*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*50*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*60*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*70*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*80*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*90*/  PX,PX,PX,PX,PX,PX, 2, 2, 2, 3, 2, 3, 2, 2, 2, 2,
/*A0*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*B0*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*C0*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*D0*/  PX,PX,PX,PX,PX,PX,PX,PX,PX,PX,PX,PX,PX,PX,PX,PX,
/*E0*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*F0*/   2, 2, 2, 2, 2, 2, 2, 2,PX,PX,PX,PX,PX,PX,PX,PX
};

/*
 * Process machine ops.
 */
VOID
machine(mp)
struct mne *mp;
{
	char *str;
	int c, t, t1, v, v1;
	a_uint op;
	struct expr e, e1;

	clrexpr(&e);
	clrexpr(&e1);

	op = mp->m_valu;
	switch (mp->m_type) {

	case S_CPU:
		opcycles = OPCY_CPU;
		lmode = SLIST;
		switch(op) {
		default: op = AT90Sxxxx;
		case AT90Sxxxx: str = "AT90Sxxxx"; sym[2].s_addr = X_AT90Sxxxx; break;
		case AT90S1200: str = "AT90S1200"; sym[2].s_addr = X_AT90S1200; break;
		case AT90S2313: str = "AT90S2313"; sym[2].s_addr = X_AT90S2313; break;
		case AT90S2323: str = "AT90S2323"; sym[2].s_addr = X_AT90S2323; break;
		case AT90S2343: str = "AT90S2343"; sym[2].s_addr = X_AT90S2343; break;
		case AT90S2333: str = "AT90S2333"; sym[2].s_addr = X_AT90S2333; break;
		case AT90S4433: str = "AT90S4433"; sym[2].s_addr = X_AT90S4433; break;
		case AT90S4414: str = "AT90S4414"; sym[2].s_addr = X_AT90S4414; break;
		case AT90S4434: str = "AT90S4434"; sym[2].s_addr = X_AT90S4434; break;
		case AT90S8515: str = "AT90S8515"; sym[2].s_addr = X_AT90S8515; break;
		case AT90C8534:	str = "AT90C8534"; sym[2].s_addr = X_AT90C8534; break;
		case AT90S8535: str = "AT90S8535"; sym[2].s_addr = X_AT90S8535; break;
		case ATmega103: str = "ATmega103"; sym[2].s_addr = X_ATmega103; break;
		case ATmega603: str = "ATmega603"; sym[2].s_addr = X_ATmega603; break;
		case ATmega161:	str = "ATmega161"; sym[2].s_addr = X_ATmega161; break;
		case ATmega163:	str = "ATmega163"; sym[2].s_addr = X_ATmega163; break;
		case ATtiny10:  str = "ATtiny10";  sym[2].s_addr = X_ATtiny10;  break;
		case ATtiny11:  str = "ATtiny11";  sym[2].s_addr = X_ATtiny11;  break;
		case ATtiny12:  str = "ATtiny12";  sym[2].s_addr = X_ATtiny12;  break;
		case ATtiny15:  str = "ATtiny15";  sym[2].s_addr = X_ATtiny15;  break;
		case ATtiny22:  str = "ATtiny22";  sym[2].s_addr = X_ATtiny22;  break;
		case ATtiny28:  str = "ATtiny28";  sym[2].s_addr = X_ATtiny28;  break;
		}
		mchtyp = op;
		sprintf(buff, "%s %s", ATMEL_CPU, str);
		cpu = buff;
		break;

	case S_4K:
		opcycles = OPCY_4K;
		lmode = SLIST;
		expr(&e, 0);
		if (is_abs(&e)) {
			avr_4k = (int) e.e_addr;
		} else {
			err('o');
		}
		break;

	case S_BITS:
		if (avr_bytes == 0) {
			avr_bytes = (int) op;
			exprmasks(avr_bytes);
		} else
		if (avr_bytes != (int) op) {
			err('m');
		}
		opcycles = OPCY_BITS;
		lmode = SLIST;
		break;

	case S_INH:

#if OPCODE_ERRORS
		if (op == 0x9409) {	/* ijmp */
			if (mchtyp &   (AT90S1200|
					ATtiny10|ATtiny11|ATtiny12|ATtiny15|ATtiny28)	) {
				err('o');
			}
		}
#endif

#if OPCODE_ERRORS
		if (op == 0x9419) {	/* eijmp */
			if (mchtyp &   (AT90S1200|AT90S2313|AT90S2343|AT90S2323|AT90S2333|AT90S4433|
					AT90S4414|AT90S8515|AT90S4434|AT90S8535|AT90C8534|
					ATmega603|ATmega103|ATmega161|ATmega163|
					ATtiny10|ATtiny11|ATtiny12|ATtiny15|ATtiny22|ATtiny28)	) {
				err('o');
			}
		}
#endif

#if OPCODE_ERRORS
		if (op == 0x9509) {	/* icall */
			if (mchtyp &   (AT90S1200|
					ATtiny10|ATtiny11|ATtiny12|ATtiny15|ATtiny28)	) {
				err('o');
			}
		}
#endif

#if OPCODE_ERRORS
		if (op == 0x9519) {	/* eicall */
			if (mchtyp &   (AT90S1200|AT90S2313|AT90S2343|AT90S2323|AT90S2333|AT90S4433|
					AT90S4414|AT90S8515|AT90S4434|AT90S8535|AT90C8534|
					ATmega603|ATmega103|ATmega163|
					ATtiny10|ATtiny11|ATtiny12|ATtiny15|ATtiny22|ATtiny28)	) {
				err('o');
			}
		}
#endif

#if OPCODE_ERRORS
		if (op == 0x9598) {	/* break */
			if (mchtyp &   (AT90S1200|
					ATtiny10|ATtiny11|ATtiny12|ATtiny15|ATtiny28)	) {
				err('o');
			}
		}
#endif

#if OPCODE_ERRORS
		if (op == 0x95E8) {	/* spm */
			if (mchtyp &   (AT90S1200|AT90S2313|AT90S2343|AT90S2323|AT90S2333|AT90S4433|
					AT90S4414|AT90S8515|AT90S4434|AT90S8535|AT90C8534|
					ATmega603|ATmega103|
					ATtiny10|ATtiny11|ATtiny12|ATtiny15|ATtiny22|ATtiny28)	) {
				err('o');
			}
		}
#endif

		outaw(op);
		break;

	case S_IBYTE:	/* Rd,#imm  /  16 <= Rd <= 31, # */
		/*
		 * The addressing mode can be S_REG
		 * or any constant from 16 to 31.
		 */
		t = addr(&e);
		if (!is_abs(&e) || (e.e_addr < 16) || (e.e_addr > 31)) {
			aerr();
		}
		comma(1);
		t1 = addr(&e1);
		if (is_abs(&e1)) {
			if (e1.e_addr > 255)
				aerr();
		} else
		if ((t1 != S_IMMED) && (t1 != S_EXT)) {
			aerr();
		}
		outrwm(&e1, M_IBYTE, op | ((e.e_addr & 0x0F) << 4));
		break;

	case S_CBR:	/* cbr  Rd,#imm  /  16 <= Rd <= 31, # */
		/*
		 * The addressing mode can be S_REG
		 * or any constant from 16 to 31.
		 */
		t = addr(&e);
		if (!is_abs(&e) || (e.e_addr < 16) || (e.e_addr > 31)) {
			aerr();
		}
		comma(1);
		t1 = addr(&e1);
		if (is_abs(&e1)) {
			if (e1.e_addr > 255)
				aerr();
		} else {
			aerr();
		}
		v1 = (int) (((~e1.e_addr & 0xF0) << 4) + (~e1.e_addr & 0xF));
		outaw(op | ((e.e_addr & 0x0F) << 4) | v1);
		break;

	case S_IWORD:	/* Rd,#imm  /  Rd == R24,R26,R28,R30, # */

#if OPCODE_ERRORS
		if (mchtyp &   (AT90S1200|
				ATtiny10|ATtiny11|ATtiny12|ATtiny15|ATtiny28)	) {
			err('o');
		}
#endif

		/*
		 * The addressing mode can be S_REG
		 * or any constant from 24 to 30.
		 */
		t = addr(&e);
		if (!is_abs(&e) || ((e.e_addr & 0x19) != 0x18)) {
			aerr();
		}
		comma(1);
		t1 = addr(&e1);
		if (is_abs(&e1)) {
			if (e1.e_addr > 63)
				aerr();
		} else
		if ((t1 != S_IMMED) && (t1 != S_EXT)) {
			aerr();
		}
		outrwm(&e1, R_MBRO | M_IWORD, op | ((e.e_addr & 0x06) << 3));
		break;

	case S_SNGL:	/* Rd  /  0 <= Rd <= 31 */

#if OPCODE_ERRORS
		if ((op == 0x900F) || (op == 0x920F)) {		/* pop, push */
			if (mchtyp &   (AT90S1200|
					ATtiny10|ATtiny11|ATtiny12|ATtiny15|ATtiny28)	) {
				err('o');
			}
		}
#endif

		/*
		 * The addressing mode can be S_REG
		 * or any constant from 0 to 31.
		 */
		t = addr(&e);
		if (!is_abs(&e) ||  (e.e_addr > 31)) {
			aerr();
		}
		outaw(op | ((e.e_addr & 0x1F) << 4));
		break;

	case S_SAME:	/* Rd  /  0 <= Rd <= 31 */
		/*
		 * The addressing mode can be S_REG
		 * or any constant from 0 to 31.
		 */
		t = addr(&e);
		if (!is_abs(&e) ||  (e.e_addr > 31)) {
			aerr();
		}
		outaw(op | ((e.e_addr & 0x1F) << 4) | ((e.e_addr & 0x10) << 5) | (e.e_addr & 0x0F));
		break;

	case S_DUBL:	/* Rd,Rr  /  0 <= Rd,Rr <= 31 */
		/*
		 * The addressing mode can be S_REG
		 * or any constant from 0 to 31.
		 */
		t = addr(&e);
		if (!is_abs(&e) ||  (e.e_addr > 31)) {
			aerr();
		}
		comma(1);
		t1 = addr(&e1);
		if (!is_abs(&e1) ||  (e1.e_addr > 31)) {
			aerr();
		}
		outaw(op | ((e.e_addr & 0x1F) << 4) | ((e1.e_addr & 0x10) << 5) | (e1.e_addr & 0x0F));
		break;

	case S_MOVW:	/* Rd,Rr  /  0,2,... <= Rd,Rr <= ...,28,30 */

#if OPCODE_ERRORS
		if (mchtyp &   (AT90S1200|AT90S2313|AT90S2343|AT90S2323|AT90S2333|AT90S4433|
				AT90S4414|AT90S8515|AT90S4434|AT90S8535|AT90C8534|
				ATtiny10|ATtiny11|ATtiny12|ATtiny15|ATtiny22|ATtiny28)	) {
			err('o');
		}
#endif

		/*
		 * The addressing mode can be S_REG
		 * or any constant from 0 to 31.
		 */
		t = addr(&e);
		if (!is_abs(&e) || (e.e_addr > 31) || (e.e_addr & 0x01)) {
			aerr();
		}
		comma(1);
		t1 = addr(&e1);
		if (!is_abs(&e1) || (e1.e_addr > 31) || (e1.e_addr & 0x01)) {
			aerr();
		}
		outaw(op | (((e.e_addr >> 1) & 0x0F) << 4) | ((e1.e_addr >> 1) & 0x0F));
		break;

	/*
	 * mul
	 */
	case S_MUL:	/* Rd,Rr  /  0 <= Rd,Rr <= 31 */

#if OPCODE_ERRORS
		if (mchtyp &   (AT90S1200|AT90S2313|AT90S2343|AT90S2323|AT90S2333|AT90S4433|
				AT90S4414|AT90S8515|AT90S4434|AT90S8535|AT90C8534|
				ATmega603|ATmega103|
				ATtiny10|ATtiny11|ATtiny12|ATtiny15|ATtiny22|ATtiny28)	) {
			err('o');
		}
#endif

		/*
		 * The addressing mode can be S_REG
		 * or any constant from 0 to 31.
		 */
		t = addr(&e);
		if (!is_abs(&e) ||  (e.e_addr > 31)) {
			aerr();
		}
		comma(1);
		t1 = addr(&e1);
		if (!is_abs(&e1) ||  (e1.e_addr > 31)) {
			aerr();
		}
		outaw(op | ((e.e_addr & 0x1F) << 4) | ((e1.e_addr & 0x10) << 5) | (e1.e_addr & 0x0F));
		break;

	/*
	 * muls
	 */
	case S_MULS:	/* Rd,Rr  /  16 <= Rd,Rr <= 31 */

#if OPCODE_ERRORS
		if (mchtyp &   (AT90S1200|AT90S2313|AT90S2343|AT90S2323|AT90S2333|AT90S4433|
				AT90S4414|AT90S8515|AT90S4434|AT90S8535|AT90C8534|
				ATmega603|ATmega103|
				ATtiny10|ATtiny11|ATtiny12|ATtiny15|ATtiny22|ATtiny28)	) {
			err('o');
		}
#endif

		/*
		 * The addressing mode can be S_REG
		 * or any constant from 16 to 31.
		 */
		t = addr(&e);
		if (!is_abs(&e) || (e.e_addr < 16) || (e.e_addr > 31)) {
			aerr();
		}
		comma(1);
		t1 = addr(&e1);
		if (!is_abs(&e1) || (e1.e_addr < 16) || (e1.e_addr > 31)) {
			aerr();
		}
		outaw(op | ((e.e_addr & 0x0F) << 4) | (e1.e_addr & 0x0F));
		break;

	/*
	 * mulsu
	 * fmul
	 * fmuls
	 * fmulsu
	 */
	case S_FMUL:	/* Rd,Rr  /  16 <= Rd,Rr <= 23 */

#if OPCODE_ERRORS
		if (mchtyp &   (AT90S1200|AT90S2313|AT90S2343|AT90S2323|AT90S2333|AT90S4433|
				AT90S4414|AT90S8515|AT90S4434|AT90S8535|AT90C8534|
				ATmega603|ATmega103|
				ATtiny10|ATtiny11|ATtiny12|ATtiny15|ATtiny22|ATtiny28)	) {
			err('o');
		}
#endif

		/*
		 * The addressing mode can be S_REG
		 * or any constant from 16 to 23.
		 */
		t = addr(&e);
		if (!is_abs(&e) || (e.e_addr < 16) || (e.e_addr > 23)) {
			aerr();
		}
		comma(1);
		t1 = addr(&e1);
		if (!is_abs(&e1) || (e1.e_addr < 16) || (e1.e_addr > 23)) {
			aerr();
		}
		outaw(op | ((e.e_addr & 0x07) << 4) | (e1.e_addr & 0x07));
		break;

	case S_SER:	/* Rd  /  16 <= Rd <= 31 */
		/*
		 * The addressing mode can be S_REG
		 * or any constant from 16 to 31.
		 */
		t = addr(&e);
		if (!is_abs(&e) || (e.e_addr < 16) || (e.e_addr > 31)) {
			aerr();
		}
		outaw(op | ((e.e_addr & 0xF) << 4));
		break;

	case S_SREG:	/* Bit Number  /  b <= 7 */
		t = addr(&e);
		abscheck(&e);
		if (e.e_addr > 7)
			aerr();
		outaw(op | ((e.e_addr & 0x07) << 4));
		break;

	case S_SKIP:
	case S_TFLG:	/* Rd,b  /  0 <= Rd <= 31, b <= 7 */
		/*
		 * The addressing mode can be S_REG
		 * or any constant from 0 to 31.
		 */
		t = addr(&e);
		if (!is_abs(&e) ||  (e.e_addr > 31)) {
			aerr();
		}
		comma(1);
		expr(&e1, 0);
		abscheck(&e1);
		if (e1.e_addr > 7)
			aerr();
		outaw(op | ((e.e_addr & 0x1F) << 4) | (e1.e_addr & 7));
		break;

	case S_BRA:	/* BR__  label */
		/* Relative branch */
		expr(&e, 0);
		if (mchpcr(&e)) {
			v = (int) (e.e_addr - dot.s_addr - 1);
			if ((v < -64) || (v > 63))
				aerr();
			outaw(op | ((v & 0x7F) << 3));
		} else {
			outrwm(&e, R_PCR | M_BRA, op);
		}
		if (e.e_mode != S_USER)
			rerr();
		break;

	case S_SBRA:	/* BR__  b,label  /  b <= 7 */
		/* Relative branch */
		expr(&e, 0);
		abscheck(&e);
		if (e.e_addr > 7)
			aerr();
		comma(1);
		expr(&e1, 0);
		if (mchpcr(&e1)) {
			v = (int) (e1.e_addr - dot.s_addr - 1);
			if ((v < -64) || (v > 63))
				aerr();
			outaw(op | ((v & 0x7F) << 3) | (e.e_addr & 0x07));
		} else {
			outrwm(&e1, R_PCR | M_BRA, op | (e.e_addr & 0x07));
		}
		if (e1.e_mode != S_USER)
			rerr();
		break;

	case S_JMP:	/* label */

#if OPCODE_ERRORS
		if (mchtyp &   (AT90S1200|AT90S2313|AT90S2343|AT90S2323|AT90S2333|AT90S4433|
				AT90S4414|AT90S8515|AT90S4434|AT90S8535|AT90C8534|
				ATtiny10|ATtiny11|ATtiny12|ATtiny15|ATtiny22|ATtiny28)	) {
			err('o');
		}
#endif

		if (a_bytes != 4) {
			aerr();
		}
		expr(&e, 0);
		outr4bm(&e, R_MBRO | M_JMP, op);
		break;

	case S_RJMP:	/* label */
		expr(&e, 0);
		if (mchpcr(&e)) {
			v = (int) (e.e_addr - dot.s_addr - 1);
			if (avr_4k == 0)
				if ((v < -2048) || (v > 2047))
					aerr();
			outaw(op | (v & 0x0FFF));
		} else {
			outrwm(&e, (avr_4k ? R_PCRN : R_PCR) | M_RJMP, op);
		}
		if (e.e_mode != S_USER)
			rerr();
		break;


	case S_IOR:	/* P,b  /  0 <= P <= 31,  b <= 7 */
		t = addr(&e);
		if (is_abs(&e)) {
			if (e.e_addr > 31)
				aerr();
		} else
		if ((t != S_IMMED) && (t != S_EXT)) {
			aerr();
		}
		comma(1);
		expr(&e1, 0);
		abscheck(&e1);
		if (e1.e_addr > 7)
			aerr();
		outrwm(&e, R_MBRO | M_IOR, op | (e1.e_addr & 7));
		break;

	case S_IN:	/* Rd,P  /  0 <= Rd <= 31,  0 <= P <= 63 */
		/*
		 * The addressing mode can be S_REG
		 * or any constant from 0 to 31.
		 */
		t = addr(&e);
		if (!is_abs(&e) ||  (e.e_addr > 31)) {
			aerr();
		}
		comma(1);
		t1 = addr(&e1);
		if (is_abs(&e1)) {
			if (e1.e_addr > 63)
				aerr();
		} else
		if ((t1 != S_IMMED) && (t1 != S_EXT)) {
			aerr();
		}
		outrwm(&e1, R_MBRO | M_IOP, op | ((e.e_addr & 0x1F) << 4));
		break;

	case S_OUT:	/* P,Rd  /  0 <= Rd <= 31,  0 <= P <= 63 */
		t = addr(&e);
		if (is_abs(&e)) {
			if (e.e_addr > 63)
				aerr();
		} else
		if ((t != S_IMMED) && (t != S_EXT)) {
			aerr();
		}
		comma(1);
		/*
		 * The addressing mode can be S_REG
		 * or any constant from 0 to 31.
		 */
		t1 = addr(&e1);
		if (!is_abs(&e1) ||  (e1.e_addr > 31)) {
			aerr();
		}
		outrwm(&e, R_MBRO | M_IOP, op | ((e1.e_addr & 0x1F) << 4));
		break;

	case S_LD:	/* Rd,X */
		/*
		 * The addressing mode can be S_REG
		 * or any constant from 0 to 31.
		 */
		t = addr(&e);
		if (!is_abs(&e) || (e.e_addr > 31)) {
			aerr();
		}
		comma(1);
		t1 = addr(&e1);
		if (t1 != S_IND)
			aerr();

#if OPCODE_ERRORS
		if (e1.e_addr) {	/* != Rd,Z */
			if (mchtyp &   (AT90S1200|
					ATtiny10|ATtiny11|ATtiny12|ATtiny15|ATtiny28)	) {
				err('o');
			}
		}
#endif

		outaw(op | e1.e_addr | ((e.e_addr & 0x1F) << 4));
		break;

	case S_ST:	/* X,Rd */
		t = addr(&e);
		if (t != S_IND)
			aerr();

#if OPCODE_ERRORS
		if (e.e_addr) {		/* != Rd,Z */
			if (mchtyp &   (AT90S1200|
					ATtiny10|ATtiny11|ATtiny12|ATtiny15|ATtiny28)	) {
				err('o');
			}
		}
#endif

		comma(1);
		/*
		 * The addressing mode can be S_REG
		 * or any constant from 0 to 31.
		 */
		t1 = addr(&e1);
		if (!is_abs(&e1) || (e1.e_addr > 31)) {
			aerr();
		}
		outaw(op | e.e_addr | ((e1.e_addr & 0x1F) << 4));
		break;

	case S_ILD:	/* Rd,Y+Q  /  0 <= Rd <= 31, 0 <= Q <= 63 */

#if OPCODE_ERRORS
		if (mchtyp &   (AT90S1200|
				ATtiny10|ATtiny11|ATtiny12|ATtiny15|ATtiny28)	) {
			err('o');
		}
#endif

		/*
		 * The addressing mode can be S_REG
		 * or any constant from 0 to 31.
		 */
		t = addr(&e);
		if (!is_abs(&e) || (e.e_addr > 31)) {
			aerr();
		}
		comma(1);
		c = getnb();
		if (getnb() != '+')
			qerr();
		t1 = addr(&e1);
		if (is_abs(&e1)) {
			if (e1.e_addr > 63)
				aerr();
		} else
		if ((t1 != S_IMMED) && (t1 != S_EXT)) {
			aerr();
		}
		switch(ccase[c & 0x7F]) {
		default:
		case 'x':
			aerr();
			outaw(0);
			break;
		case 'y':
			op |= 0x08;
		case 'z':
			outrwm(&e1, R_MBRO | M_ILDST, op | ((e.e_addr & 0x1F) << 4));
			break;
		}
		break;

	case S_IST:	/* Y+Q,Rd  /  0 <= Rd <= 31, 0 <= Q <= 63 */

#if OPCODE_ERRORS
		if (mchtyp &   (AT90S1200|
				ATtiny10|ATtiny11|ATtiny12|ATtiny15|ATtiny28)	) {
			err('o');
		}
#endif

		c = getnb();
		if (getnb() != '+')
			qerr();
		t = addr(&e);
		if (is_abs(&e)) {
			if (e.e_addr > 63)
				aerr();
		} else
		if ((t != S_IMMED) && (t != S_EXT)) {
			aerr();
		}
		comma(1);
		/*
		 * The addressing mode can be S_REG
		 * or any constant from 0 to 31.
		 */
		t1 = addr(&e1);
		if (!is_abs(&e1) ||  (e1.e_addr > 31)) {
			aerr();
		}
		switch(ccase[c & 0x7F]) {
		default:
		case 'x':
			aerr();
			outaw(0);
			break;
		case 'y':
			op |= 0x08;
		case 'z':
			outrwm(&e, R_MBRO | M_ILDST, op | ((e1.e_addr & 0x1F) << 4));
			break;
		}
		break;

	case S_LDS:	/* Rd,label  /  0 <= Rd <= 31 */

#if OPCODE_ERRORS
		if (mchtyp &   (AT90S1200|
				ATtiny10|ATtiny11|ATtiny12|ATtiny15|ATtiny28)	) {
			err('o');
		}
#endif

		/*
		 * The addressing mode can be S_REG
		 * or any constant from 0 to 31.
		 */
		t = addr(&e);
		if (!is_abs(&e) ||  (e.e_addr > 31)) {
			aerr();
		}
		comma(1);
		t1 = addr(&e1);
		if (t1 != S_EXT)
			aerr();
		outaw(op | ((e.e_addr & 0x1F) << 4));
		outrw(&e1, R_NORM);
		break;

	case S_STS:	/* label,Rd  /  0 <= Rd <= 31 */

#if OPCODE_ERRORS
		if (mchtyp &   (AT90S1200|
				ATtiny10|ATtiny11|ATtiny12|ATtiny15|ATtiny28)	) {
			err('o');
		}
#endif

		t = addr(&e);
		if (t != S_EXT)
			aerr();
		comma(1);
		/*
		 * The addressing mode can be S_REG
		 * or any constant from 0 to 31.
		 */
		t1 = addr(&e1);
		if (!is_abs(&e1) ||  (e1.e_addr > 31)) {
			aerr();
		}
		outaw(op | ((e1.e_addr & 0x1F) << 4));
		outrw(&e, R_NORM);
		break;

	case S_LPM:	/* blank, Rd,z, or Rd,z+  /  0 <= Rd <= 31 */
		if (more()) {

#if OPCODE_ERRORS
			if (mchtyp &   (AT90S1200|AT90S2313|AT90S2343|AT90S2323|AT90S2333|AT90S4433|
					AT90S4414|AT90S8515|AT90S4434|AT90S8535|AT90C8534|
					ATtiny10|ATtiny11|ATtiny12|ATtiny15|ATtiny22|ATtiny28)	) {
				err('o');
			}
#endif

			/*
			 * The addressing mode can be S_REG
			 * or any constant from 0 to 31.
			 */
			t = addr(&e);
			if (!is_abs(&e) ||  (e.e_addr > 31)) {
				aerr();
			}
			comma(1);
			t1 = addr(&e1);
			if (t1 != S_IND)
				aerr();
			if (e1.e_addr == 0x0000) {	/* Rd,z  */
				outaw(0x9004 | ((e.e_addr & 0x1F) << 4));
			} else
			if (e1.e_addr == 0x1001) {	/* Rd,z+ */
				outaw(0x9005 | ((e.e_addr & 0x1F) << 4));
			} else {
				outaw(op);
				aerr();
			}
		} else {				/* blank */

#if OPCODE_ERRORS
			if (mchtyp &   (AT90S1200|
					ATtiny10|ATtiny11|ATtiny12)	) {
				err('o');
			}
#endif

			outaw(op);
		}
		break;

	case S_ELPM:	/* blank, Rd,z, or Rd,z+  /  0 <= Rd <= 31 */
		if (more()) {

#if OPCODE_ERRORS
		if (mchtyp &   (AT90S1200|AT90S2313|AT90S2343|AT90S2323|AT90S2333|AT90S4433|
				AT90S4414|AT90S8515|AT90S4434|AT90S8535|AT90C8534|
				ATmega603|ATmega103|ATmega161|ATmega163|
				ATtiny10|ATtiny11|ATtiny12|ATtiny15|ATtiny22|ATtiny28)	) {
			err('o');
		}
#endif

			/*
			 * The addressing mode can be S_REG
			 * or any constant from 0 to 31.
			 */
			t = addr(&e);
			if (!is_abs(&e) ||  (e.e_addr > 31)) {
				aerr();
			}
			comma(1);
			t1 = addr(&e1);
			if (t1 != S_IND)
				aerr();
			if (e1.e_addr == 0) {		/* Rd,z  */
				outaw(0x9006 | ((e.e_addr & 0x1F) << 4));
			} else
			if (e1.e_addr == 0x1001) {	/* Rd,z+ */
				outaw(0x9007 | ((e.e_addr & 0x1F) << 4));
			} else {
				outaw(op);
				aerr();
			}
		} else {				/* blank */

#if OPCODE_ERRORS
			if (mchtyp &   (AT90S1200|AT90S2313|AT90S2343|AT90S2323|AT90S2333|AT90S4433|
					AT90S4414|AT90S8515|AT90S4434|AT90S8535|AT90C8534|
					ATmega603|ATmega103|ATmega163|
					ATtiny10|ATtiny11|ATtiny12|ATtiny15|ATtiny22|ATtiny28)	) {
				err('o');
			}
#endif

			outaw(op);
		}
		break;

	default:
		opcycles = OPCY_ERR;
		err('o');
		break;
	}

	if (opcycles == OPCY_NONE) {
		opcycles = avrpg1[cb[1] & 0xFF];
		if ((opcycles & OPCY_NONE) && (opcycles & OPCY_MASK)) {
			op = ((cb[1] << 8) + cb[0]) & (a_uint) 0x0000FFFF;
			if ((op & (a_uint) 0xF000) == (a_uint) 0xD000) {
				/* RCALL */
#ifdef	LONGINT
				if (a_mask & (a_uint) 0xFF000000l) {
#else
				if (a_mask & (a_uint) 0xFF000000) {
#endif
					opcycles = 4;
				} else {
					opcycles = 3;
				}
			} else if ((op & (a_uint) 0xFE00) == (a_uint) 0x9000) {
				switch(op & (a_uint) 0x000F) {
				case (a_uint) 0x00:	/* LDS Rd,k  */

				case (a_uint) 0x01:	/* LD  Rd,Z+ */
				case (a_uint) 0x02:	/* LD  Rd,-Z */

				case (a_uint) 0x09:	/* LD  Rd,Y+ */
				case (a_uint) 0x0A:	/* LD  Rd,-Y */

				case (a_uint) 0x0C:	/* LD  Rd,X  */
				case (a_uint) 0x0D:	/* LD  Rd,X+ */
				case (a_uint) 0x0E:	/* LD  Rd,-X */

				case (a_uint) 0x0F:	/* POP Rd    */
					opcycles = 2;	break;

				case (a_uint) 0x04:	/* LPM Rd,Z  */
				case (a_uint) 0x05:	/* LPM Rd,Z+ */
				case (a_uint) 0x06:	/* ELPM Rd,Z  */
				case (a_uint) 0x07:	/* ELPM Rd,Z+ */
					opcycles = 3;	break;

				default:		break;
				}
			} else if ((op & (a_uint) 0xFE00) == (a_uint) 0x9200) {
				switch(op & (a_uint) 0x000F) {
				case (a_uint) 0x00:	/* STS k,Rd  */

				case (a_uint) 0x01:	/* ST  Z+,Rd */
				case (a_uint) 0x02:	/* ST  -Z,Rd */

				case (a_uint) 0x09:	/* ST  Y+,Rd */
				case (a_uint) 0x0A:	/* ST  -Y,Rd */

				case (a_uint) 0x0C:	/* ST  X,Rd  */
				case (a_uint) 0x0D:	/* ST  X+,Rd */
				case (a_uint) 0x0E:	/* ST  -X,Rd */

				case (a_uint) 0x0F:	/* PUSH Rd   */
					opcycles = 2;	break;

				default:		break;
				}
			} else if ((op & (a_uint) 0xFE00) == (a_uint) 0x9400) {
				switch(op & (a_uint) 0x000F) {
				case (a_uint) 0x00:	/* COM  */
				case (a_uint) 0x01:	/* NEG  */
				case (a_uint) 0x02:	/* SWAP */
				case (a_uint) 0x03:	/* INC  */

				case (a_uint) 0x05:	/* ASR  */
				case (a_uint) 0x06:	/* LSR  */
				case (a_uint) 0x07:	/* ROR  */
					opcycles = 1;	break;

				case (a_uint) 0x08:
					if ((op & (a_uint) 0xFF0F) == (a_uint) 0x9408) {
						opcycles = 1;		/* SEx / CLx */
						break;
					}
					switch(op) {
					case (a_uint) 0x9508:		/* RET      */
					case (a_uint) 0x9518:		/* RETI     */
#ifdef	LONGINT
						if (a_mask & (a_uint) 0xFF000000l) {
#else
						if (a_mask & (a_uint) 0xFF000000) {
#endif
							opcycles = 5;
						} else {
							opcycles = 4;
						}		break;

					case (a_uint) 0x9588:		/* SLEEP    */
					case (a_uint) 0x9598:		/* BREAK    */
					case (a_uint) 0x95A8:		/* WDR      */
						opcycles = 1;	break;

					case (a_uint) 0x95C8:		/* LPM      */
					case (a_uint) 0x95D8:		/* ELPM     */
						opcycles = 3;	break;

					case (a_uint) 0x95E8:		/* SPM      */
						opcycles = 0;	break;

					default:		break;
					}
					break;

				case (a_uint) 0x09:
					switch(op) {
					case (a_uint) 0x9409:		/* IJMP      */
					case (a_uint) 0x9419:		/* EIJMP     */
						opcycles = 2;	break;

					case (a_uint) 0x9509:		/* ICALL    */
#ifdef	LONGINT
						if (a_mask & (a_uint) 0xFF000000l) {
#else
						if (a_mask & (a_uint) 0xFF000000) {
#endif
							opcycles = 4;
						} else {
							opcycles = 3;
						}		break;

					case (a_uint) 0x9519:		/* EICALL    */
#ifdef	LONGINT
						if (a_mask & (a_uint) 0xFF000000l) {
#else
						if (a_mask & (a_uint) 0xFF000000) {
#endif
							opcycles = 4;
						}		break;

					default:		break;
					}
					break;

				case (a_uint) 0x0A:	/* DEC  */
					opcycles = 1;	break;

				case (a_uint) 0x0C:	/* JMP  */
				case (a_uint) 0x0D:	/* JMP  */
					opcycles = 3;	break;

				case (a_uint) 0x0E:	/* CALL */
				case (a_uint) 0x0F:	/* CALL */
#ifdef	LONGINT
					if (a_mask & (a_uint) 0xFF000000l) {
#else
					if (a_mask & (a_uint) 0xFF000000) {
#endif
						opcycles = 5;
					} else {
						opcycles = 4;
					}		break;

				default:		break;
				}
			} else if ((op & (a_uint) 0xF808) == (a_uint) 0xF800) {
				if (op & (a_uint) 0x0400) {
					opcycles = 3;	/* SBRC / SBRS */
				} else {
					opcycles = 1;	/* BSET / BCLR */
				}
			} else if (op == (a_uint) 0x000) {
				opcycles = 1;		/* NOP */
			}
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
 * Machine specific initialization
 */

VOID
minit()
{
	/*
	 * Byte Order
	 */
	hilo = 0;

	avr_4k = 0;
	if (pass == 0) {
		avr_bytes = 0;
		mchtyp = X_AT_USER;
		sym[2].s_addr = X_AT_USER;
	}
}

