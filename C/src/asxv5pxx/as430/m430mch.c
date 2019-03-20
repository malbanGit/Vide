/* m430mch.c */

/*
 *  Copyright (C) 2003-2009  Alan R. Baldwin
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
#include "m430.h"

char	*cpu	= "Texas Instruments MSP430";
char	*dsft	= "asm";

/*
 * Opcode Cycle Definitions
 */
#define	OPCY_SDP	((char) (0xFF))
#define	OPCY_ERR	((char) (0xFE))

/*	OPCY_NONE	((char) (0x80))	*/
/*	OPCY_MASK	((char) (0x7F))	*/

#define	UN	((char) (OPCY_NONE | 0x00))

#define	OPCY_PC	((char) (0x40))

/*
 * Process a machine op.
 */
VOID
machine(mp)
struct mne *mp;
{
	int op;
	int rf;
	struct expr e1, e2;
	int t1, t2, v1, v2;

	clrexpr(&e1);
	clrexpr(&e2);

	/*
	 * Instructions on a Word Boundary
	 */
	if (dot.s_addr & 0x0001) {
		outall();
		err('b');
		dot.s_addr += 1;
	}

	op = (int) mp->m_valu;
	switch (rf = mp->m_type) {

	case S_DOP:
	case S_BRA:
		t1 = addr(&e1);
		v1 = (aindx & 0x000F) << 8;
		t2 = 0;
		v2 = 0;
		switch (rf) {
		case S_DOP:
		    /*
		     * Special Constant Processing
		     */
		    if ((t1 == S_IMM) && is_abs(&e1)) {
			switch (e1.e_addr) {
			case (a_uint)  4:	t1 = S_REG;	op += 0x0020;	v1 = 2 << 8;	break;
			case (a_uint)  8:	t1 = S_REG;	op += 0x0030;	v1 = 2 << 8;	break;
			case (a_uint)  0:	t1 = S_REG;	op += 0x0000;	v1 = 3 << 8;	break;
			case (a_uint)  1:	t1 = S_REG;	op += 0x0010;	v1 = 3 << 8;	break;
			case (a_uint)  2:	t1 = S_REG;	op += 0x0020;	v1 = 3 << 8;	break;
			case (a_uint) ~0:	t1 = S_REG;	op += 0x0030;	v1 = 3 << 8;	break;
			default:								break;
			}
		    }
		    comma(1);			t2 = addr(&e2);		v2 = (aindx & 0x000F);	break;
		case S_BRA:			t2 = S_REG;		v2 = 0;			break;
		default:									break;
		}

		/*
		 * Opcode Processing
		 */
		/* DOPSRC */
		switch(t1) {
		case S_REG:	op += 0x0000 + v1;	break;	/*	Rn	As=0		*/
		case S_RIDX:	op += 0x0010 + v1;	break;	/*	X(Rn)	As=1		*/
		case S_SYM:	op += 0x0010;		break;	/*	addr	As=1, Sreg=PC	*/
		case S_ABS:	op += 0x0210;		break;	/*	&Addr	As=1, Sreg=SR	*/
		case S_RIN:	op += 0x0020 + v1;	break;	/*	@Rn	As=2		*/
		case S_RIN2:	op += 0x0030 + v1;	break;	/*	@Rn+	As=3		*/
		case S_IMM:	op += 0x0030;		break;	/*	#N	As=3, Sreg=PC	*/
		default:	aerr();			break;
		}

		/* DOPDST */
		switch(t2) {
		case S_REG:	op += 0x0000 + v2;	break;	/*	Rn	Ad=0		*/
		case S_RIDX:	op += 0x0080 + v2;	break;	/*	X(Rn)	Ad=1		*/
		case S_SYM:	op += 0x0080;		break;	/*	addr	Ad=1, Sreg=PC	*/
		case S_IMM:					/*	#N	==>> &Addr	*/
		case S_ABS:	op += 0x0082;		break;	/*	&Addr	Ad=1, Sreg=SR	*/
		case S_RIN:	op += 0x0080 + v2;	break;	/*	@Rn	Ad=1		*/
		case S_RIN2:	op += 0x0080 + v2;	break;	/*	@Rn+	Ad=1		*/
		default:	aerr();			break;
		}

		outaw(op);
		/*
		 * Source Processing
		 */
		switch(t1) {
		case S_REG:				break;	/*	Rn	As=0		*/
		case S_RIDX:	outrw(&e1, 0);		break;	/*	X(Rn)	As=1		*/
		case S_SYM:	if (mchpcr(&e1)) {
					e1.e_addr -= dot.s_addr;
					outaw(e1.e_addr);
				} else {
					outrw(&e1, R_PCR0);
				}
							break;	/*	addr	As=1, Sreg=PC	*/
		case S_ABS:	outrw(&e1, 0);		break;	/*	&Addr	As=1, Sreg=SR	*/
		case S_RIN:				break;	/*	@Rn	As=2		*/
		case S_RIN2:				break;	/*	@Rn+	As=3		*/
		case S_IMM:	outrw(&e1, 0);		break;	/*	#N	As=3, Sreg=PC	*/
		default:	aerr();			break;
		}
		/*
		 * Destination Processing
		 */
		switch(t2) {
		case S_REG:				break;	/*	Rn	Ad=0		*/
		case S_RIDX:	outrw(&e2, 0);		break;	/*	X(Rn)	Ad=1		*/
		case S_SYM:	if (mchpcr(&e2)) {
					e2.e_addr -= dot.s_addr;
					outaw(e2.e_addr);
				} else {
					outrw(&e2, R_PCR0);
				}
							break;	/*	addr	Ad=1, Sreg=PC	*/
		case S_IMM:	aerr();				/*	#N	==>> &Addr	*/
		case S_ABS:	outrw(&e2, 0);		break;	/*	&Addr	Ad=1, Sreg=SR	*/
		case S_RIN:	outaw(0);		break;	/*	@Rn	Ad=1		*/
		case S_RIN2:				        /*	@Rn+	Ad=1		*/
				if (rf == S_RLX) {
					if (op & 0x0040) {
						outaw(~0);	/*	RLX.b	@Rn+,-1(Rn)	*/
					} else {
						outaw(~1);	/*	RLX.w	@Rn+,-2(Rn)	*/
					}
				} else {
					outaw(0);
					if ((op & 0x0040) && (v2 != 0)) {
						outaw(0x5310 + v2);	/*	add	#1,Rn		*/
					} else {
						outaw(0x5320 + v2);	/*	add	#2,Rn		*/
					}
				}
							break;
		default:	aerr();			break;
		}
		break;

	case S_SOP:
		t1 = addr(&e1);
		v1 = aindx & 0x000F;

		/*
		 * Opcode Processing
		 */
		/* SRCDST */
		switch(t1) {
		case S_REG:	op += 0x0000 + v1;	break;	/*	Rn	As=0		*/
		case S_RIDX:	op += 0x0010 + v1;	break;	/*	X(Rn)	As=1		*/
		case S_SYM:	op += 0x0010;		break;	/*	addr	As=1, Sreg=PC	*/
		case S_IMM:					/*	#N	==>> &Addr	*/
		case S_ABS:	op += 0x0210;		break;	/*	&Addr	As=1, Sreg=SR	*/
		case S_RIN:	op += 0x0020 + v1;	break;	/*	@Rn	As=2		*/
		case S_RIN2:	op += 0x0030 + v1;	break;	/*	@Rn+	As=3		*/
		default:	aerr();			break;
		}

		outaw(op);
		/*
		 * Source/Destination Processing
		 */
		switch(t1) {
		case S_REG:				break;	/*	Rn	As=0		*/
		case S_RIDX:	outrw(&e1, 0);		break;	/*	X(Rn)	As=1		*/
		case S_SYM:	if (mchpcr(&e1)) {
					e1.e_addr -= dot.s_addr;
					outaw(e1.e_addr);
				} else {
					outrw(&e1, R_PCR0);
				}
							break;	/*	addr	As=1, Sreg=PC	*/
		case S_IMM:	aerr();				/*	#N	==>> &Addr	*/
		case S_ABS:	outrw(&e1, 0);		break;	/*	&Addr	As=1, Sreg=SR	*/
		case S_RIN:				break;	/*	@Rn	As=2		*/
		case S_RIN2:				break;	/*	@Rn+	As=3		*/
		default:	aerr();			break;
		}
		break;

	case S_PSH:
		t1 = addr(&e1);
		v1 = aindx & 0x000F;

		/*
		 * Special Constant Processing
		 */
		if ((t1 == S_IMM) && is_abs(&e1)) {
			switch (e1.e_addr) {
			case (a_uint)  4:	t1 = S_REG;	op += 0x0020;	v1 = 2;		break;
			case (a_uint)  8:	t1 = S_REG;	op += 0x0030;	v1 = 2;		break;
			case (a_uint)  0:	t1 = S_REG;	op += 0x0000;	v1 = 3;		break;
			case (a_uint)  1:	t1 = S_REG;	op += 0x0010;	v1 = 3;		break;
			case (a_uint)  2:	t1 = S_REG;	op += 0x0020;	v1 = 3;		break;
			case (a_uint) ~0:	t1 = S_REG;	op += 0x0030;	v1 = 3;		break;
			default:								break;
			}
		}

		/*
		 * Opcode Processing
		 */
		/* SRC */
		switch(t1) {
		case S_REG:	op += 0x0000 + v1;	break;	/*	Rn	As=0		*/
		case S_RIDX:	op += 0x0010 + v1;	break;	/*	X(Rn)	As=1		*/
		case S_SYM:	op += 0x0010;		break;	/*	addr	As=1, Sreg=PC	*/
		case S_ABS:	op += 0x0210;		break;	/*	&Addr	As=1, Sreg=SR	*/
		case S_RIN:	op += 0x0020 + v1;	break;	/*	@Rn	As=2		*/
		case S_RIN2:	op += 0x0030 + v1;	break;	/*	@Rn+	As=3		*/
		case S_IMM:	op += 0x0030;		break;	/*	#N	As=3, Sreg=PC	*/
		default:	aerr();			break;
		}

		outaw(op);
		/*
		 * Source Processing
		 */
		switch(t1) {
		case S_REG:				break;	/*	Rn	As=0		*/
		case S_RIDX:	outrw(&e1, 0);		break;	/*	X(Rn)	As=1		*/
		case S_SYM:	if (mchpcr(&e1)) {
					e1.e_addr -= dot.s_addr;
					outaw(e1.e_addr);
				} else {
					outrw(&e1, R_PCR0);
				}
							break;	/*	addr	As=1, Sreg=PC	*/
		case S_ABS:	outrw(&e1, 0);		break;	/*	&Addr	As=1, Sreg=SR	*/
		case S_RIN:				break;	/*	@Rn	As=2		*/
		case S_RIN2:				break;	/*	@Rn+	As=3		*/
		case S_IMM:	outrw(&e1, 0);		break;	/*	#N	As=3, Sreg=PC	*/
		default:	aerr();			break;
		}
		break;

	case S_DST:
		t1 = addr(&e1);
		v1 = (aindx & 0x000F);

		/*
		 * Opcode Processing
		 */
		/* DSTDST */
		switch(t1) {
		case S_REG:	op += 0x0000 + v1;	break;	/*	Rn	Ad=0		*/
		case S_RIDX:	op += 0x0080 + v1;	break;	/*	X(Rn)	Ad=1		*/
		case S_SYM:	op += 0x0080;		break;	/*	addr	Ad=1, Sreg=PC	*/
		case S_IMM:					/*	#N	==>> &Addr	*/
		case S_ABS:	op += 0x0082;		break;	/*	&Addr	Ad=1, Sreg=SR	*/
		case S_RIN:	op += 0x0080 + v1;	break;	/*	@Rn	Ad=1		*/
		case S_RIN2:	op += 0x0080 + v1;	break;	/*	@Rn+	Ad=1		*/
		default:	aerr();			break;
		}

		outaw(op);
		/*
		 * Destination Processing
		 */
		switch(t1) {
		case S_REG:				break;	/*	Rn	Ad=0		*/
		case S_RIDX:	outrw(&e1, 0);		break;	/*	X(Rn)	Ad=1		*/
		case S_SYM:	if (mchpcr(&e1)) {
					e1.e_addr -= dot.s_addr;
					outaw(e1.e_addr);
				} else {
					outrw(&e1, R_PCR0);
				}
							break;	/*	addr	Ad=1, Sreg=PC	*/
		case S_IMM:	aerr();				/*	#N	==>> &Addr	*/
		case S_ABS:	outrw(&e1, 0);		break;	/*	&Addr	Ad=1, Sreg=SR	*/
		case S_RIN:	outaw(0);		break;	/*	@Rn	Ad=1		*/
		case S_RIN2:	outaw(0);		        /*	@Rn+	Ad=1		*/
				if ((op & 0x0040) && (v1 != 0)) {
					outaw(0x5310 + v1);		/*	add	#1,Rn		*/
				} else {
					outaw(0x5320 + v1);	;	/*	add	#2,Rn		*/
				}
							break;
		default:	aerr();			break;
		}
		break;

	case S_RLX:
		t1 = addr(&e1);
		v1 = (aindx & 0x000F) << 8;

		/*
		 * Duplicate Argument
		 */
		e2.e_mode = e1.e_mode;
		e2.e_flag = e1.e_flag;
		e2.e_addr = e1.e_addr;
		e2.e_base.e_sp = e1.e_base.e_sp;
		e2.e_rlcf = e1.e_rlcf;

		t2 = t1;
		v2 = (aindx & 0x000F);

		/*
		 * Opcode Processing
		 */
		/* DOPSRC */
		switch(t1) {
		case S_REG:	op += 0x0000 + v1;	break;	/*	Rn	As=0		*/
		case S_RIDX:	op += 0x0010 + v1;	break;	/*	X(Rn)	As=1		*/
		case S_SYM:	op += 0x0010;		break;	/*	addr	As=1, Sreg=PC	*/
		case S_IMM:					/*	#N	==>> &Addr	*/
		case S_ABS:	op += 0x0210;		break;	/*	&Addr	As=1, Sreg=SR	*/
		case S_RIN:	op += 0x0020 + v1;	break;	/*	@Rn	As=2		*/
		case S_RIN2:	op += 0x0030 + v1;	break;	/*	@Rn+	As=3		*/
		default:	aerr();			break;
		}

		/* DOPDST */
		switch(t2) {
		case S_REG:	op += 0x0000 + v2;	break;	/*	Rn	Ad=0		*/
		case S_RIDX:	op += 0x0080 + v2;	break;	/*	X(Rn)	Ad=1		*/
		case S_SYM:	op += 0x0080;		break;	/*	addr	Ad=1, Sreg=PC	*/
		case S_IMM:					/*	#N	==>> &Addr	*/
		case S_ABS:	op += 0x0082;		break;	/*	&Addr	Ad=1, Sreg=SR	*/
		case S_RIN:	op += 0x0080 + v2;	break;	/*	@Rn	Ad=1		*/
		case S_RIN2:	op += 0x0080 + v2;	break;	/*	@Rn+	Ad=1		*/
		default:	aerr();			break;
		}

		outaw(op);
		/*
		 * Source Processing
		 */
		switch(t1) {
		case S_REG:				break;	/*	Rn	As=0		*/
		case S_RIDX:	outrw(&e1, 0);		break;	/*	X(Rn)	As=1		*/
		case S_SYM:	if (mchpcr(&e1)) {
					e1.e_addr -= dot.s_addr;
					outaw(e1.e_addr);
				} else {
					outrw(&e1, R_PCR0);
				}
							break;	/*	addr	As=1, Sreg=PC	*/
		case S_IMM:					/*	#N	==>> &Addr	*/
		case S_ABS:	outrw(&e1, 0);		break;	/*	&Addr	As=1, Sreg=SR	*/
		case S_RIN:				break;	/*	@Rn	As=2		*/
		case S_RIN2:				break;	/*	@Rn+	As=3		*/
		default:	aerr();			break;
		}
		/*
		 * Destination Processing
		 */
		switch(t2) {
		case S_REG:				break;	/*	Rn	Ad=0		*/
		case S_RIDX:	outrw(&e2, 0);		break;	/*	X(Rn)	Ad=1		*/
		case S_SYM:	if (mchpcr(&e2)) {
					e2.e_addr -= dot.s_addr;
					outaw(e2.e_addr);
				} else {
					outrw(&e2, R_PCR0);
				}
							break;	/*	addr	Ad=1, Sreg=PC	*/
		case S_IMM:	aerr();				/*	#N	==>> &Addr	*/
		case S_ABS:	outrw(&e2, 0);		break;	/*	&Addr	Ad=1, Sreg=SR	*/
		case S_RIN:	outaw(0);		break;	/*	@Rn	Ad=1		*/
		case S_RIN2:				        /*	@Rn+	Ad=1		*/
				if (rf == S_RLX) {
					if (op & 0x0040) {
						outaw(~0);	/*	RLX.b	@Rn+,-1(Rn)	*/
					} else {
						outaw(~1);	/*	RLX.w	@Rn+,-2(Rn)	*/
					}
				} else {
					outaw(0);
					if ((op & 0x0040) && (v2 != 0)) {
						outaw(0x5310 + v2);	/*	add	#1,Rn		*/
					} else {
						outaw(0x5320 + v2);	/*	add	#2,Rn		*/
					}
				}
							break;
		default:	aerr();			break;
		}
		break;

	case S_INH:
		outaw(op);
		break;

	case S_JXX:
		expr(&e1, 0);
		if (mchpcr(&e1)) {
			v1 = (int) (e1.e_addr - dot.s_addr - 2);
			v1 >>= 1;
			if ((v1 < -512) || (v1 > 511))
				aerr();
			outaw(op + (v1 & 0x03FF));
		} else {
			outrwm(&e1, R_PCR | R_JXX, op);
		}
		if (e1.e_mode != S_USER)
			rerr();
		break;

	default:
		opcycles = OPCY_ERR;
		err('o');
		break;
	}

	if (opcycles == OPCY_NONE) {
		v1 = cb[0];
		v2 = cb[1];
		if (v2 & 0xC0) {		/* Format 1 Instructions */
			/*
			 * Check For Internal Constant Modes
			 *	R3, As=xx
			 *	R2, AS=10/11
			 */
			if (((v2 & 0x0F) == 0x03) ||
			   (((v2 & 0x0F) == 0x02) && (v1 & 0x20))) {
			   	v1 &= 0xCF;
			}
			switch(v1 & 0xB0) {
			default:
	/* Ad=0,As=00 */case 0x00:	opcycles = 1 | OPCY_PC;		break;
	/* Ad=0,As=01 */case 0x10:	opcycles = 3;			break;
	/* Ad=0,As=10 */case 0x20:	opcycles = 2;			break;
	/* Ad=0,As=11 */case 0x30:	opcycles = 2 | OPCY_PC;		break;
	/* Ad=1,As=00 */case 0x80:	opcycles = 4;			break;
	/* Ad=1,As=01 */case 0x90:	opcycles = 6;			break;
	/* Ad=1,As=10 */case 0xA0:	opcycles = 5;			break;
	/* Ad=1,As=11 */case 0xB0:	opcycles = 5;			break;
			}
			if (opcycles & OPCY_PC) {
				if ((v1 & 0x0F) == 0) opcycles += 1;
				opcycles &= ~OPCY_PC;
			}
		} else
		if ((v2 & 0xF8) == 0x10) {	/* Format 2 Instructions */
			switch(((v2 << 8) + v1) & 0x03C0) {
			case 0x0000:	/* RRC   */
			case 0x0040:	/* RRC.B */
			case 0x0080:	/* SWPB  */
			case 0x0100:	/* RRA   */
			case 0x0140:	/* RRA.B */
			case 0x0180:	/* SXT   */
				switch(v1 & 0x30) {
		/* As/Ad=00 */	case 0x00:	opcycles = 1;	break;
		/* As/Ad=01 */	case 0x10:	opcycles = 4;	break;
		/* As/Ad=10 */	case 0x20:	opcycles = 3;	break;
		/* As/Ad=11 */	case 0x30:	opcycles = 3;	break;
				}
				break;
			case 0x0200:	/* PUSH   */
			case 0x0240:	/* PUSH.B */
				switch(v1 & 0x30) {
		/* As/Ad=00 */	case 0x00:	opcycles = 3;	break;
		/* As/Ad=01 */	case 0x10:	opcycles = 5;	break;
		/* As/Ad=10 */	case 0x20:	opcycles = 4;	break;
		/* As/Ad=11 */	case 0x30:	opcycles = 4;	break;
				}
				break;
			case 0x280:	/* CALL */
				switch(v1 & 0x30) {
		/* As/Ad=00 */	case 0x00:	opcycles = 4;	break;
		/* As/Ad=01 */	case 0x10:	opcycles = 4;	break;
		/* As/Ad=10 */	case 0x20:	opcycles = 5;	break;
		/* As/Ad=11 */	case 0x30:	opcycles = 5;	break;
				}
				break;
			case 0x0300:	/* RETI */
				opcycles = 5;
				break;
			default:
				break;
			}
		} else
		if (v2 & 0x20) {		/* Format 3 Instructions */
			opcycles = 2;
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
 * Process any setup code.
 */
VOID
minit()
{
	/*
	 * Byte Order
	 */
	hilo = 0;
}


