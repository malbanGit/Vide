/* z8mch.c */

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
#include "z8.h"

char	*cpu	= "Zilog Z8";
char	*dsft	= "asm";

char	imtab[3] = { 0x46, 0x56, 0x5E };
int	hd64;

/*
 * Opcode Cycle Definitions
 */
#define	OPCY_SDP	((char) (0xFF))
#define	OPCY_ERR	((char) (0xFE))

/*	OPCY_NONE	((char) (0x80))	*/
/*	OPCY_MASK	((char) (0x7F))	*/

#define	UN	((char) (OPCY_NONE | 0x00))

/*
 * Z8 Opcode Cycle Pages
 */

static char  z8pg1[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/   6, 6, 6, 6,10,10,10,10, 6, 6,12,12, 6,12, 6,UN,
/*10*/   6, 6, 6, 6,10,10,10,10, 6, 6,12,12, 6,12, 6,UN,
/*20*/   6, 6, 6, 6,10,10,10,10, 6, 6,12,12, 6,12, 6,UN,
/*30*/   8, 6, 6, 6,10,10,10,10, 6, 6,12,12, 6,12, 6,UN,
/*40*/   6, 6, 6, 6,10,10,10,10, 6, 6,12,12, 6,12, 6, 6,
/*50*/  10,10, 6, 6,10,10,10,10, 6, 6,12,12, 6,12, 6, 6,
/*60*/   6, 6, 6, 6,10,10,10,10, 6, 6,12,12, 6,12, 6, 6,
/*70*/  12,12, 6, 6,10,10,10,10, 6, 6,12,12, 6,12, 6, 6,
/*80*/  10,10,12,18,UN,UN,UN,UN, 6, 6,12,12, 6,12, 6, 6,
/*90*/   6, 6,12,18,UN,UN,UN,UN, 6, 6,12,12, 6,12, 6, 6,
/*A0*/  10,10, 6, 6,10,10,10,10, 6, 6,12,12, 6,12, 6,14,
/*B0*/   6, 6, 6, 6,10,10,10,10, 6, 6,12,12, 6,12, 6,16,
/*C0*/   6, 6,12,18,UN,UN,UN,10, 6, 6,12,12, 6,12, 6, 6,
/*D0*/   6, 6,12,18,20,UN,20,10, 6, 6,12,12, 6,12, 6, 6,
/*E0*/   6, 6,UN, 6,10,10,10,10, 6, 6,12,12, 6,12, 6, 6,
/*F0*/   6, 6,UN, 6,UN,10,UN,UN, 6, 6,12,12, 6,12, 6, 6
};

/*
 * Process a machine op.
 */
VOID
machine(mp)
struct mne *mp;
{
	int op, t1, t2;
	struct expr e1, e2;
	int rf, v1, v2;

	clrexpr(&e1);
	clrexpr(&e2);
	op = (int) mp->m_valu;
	rf = mp->m_type;
	switch (rf) {

	case S_INC:
	case S_SOP:
		t1 = addr(&e1);
		v1 = (int) e1.e_addr;
		if (t1 == S_R) {			/* op   r  */
			if (rf == S_INC) {
				outab(0x0E + (v1 << 4));
			} else {
				outab(op);
				outab(0xE0 + v1);
			}
		} else
		if (t1 == S_USER) {			/* op   R  */
			outab(op);
			outrb(&e1, 0);
		} else
		if ((t1 == S_IR) || (t1 == S_INDX)) {	/* op  @R  */
			outab(op + 1);
			if (t1 == S_IR) {
				outab(0xE0 + v1);	/* op  @r  */
			} else {
				outrb(&e1, 0);		/* op  @R  */
			}
		} else {
			aerr();
		}
		break;

	case S_DECW:
	case S_INCW:
		t1 = addr(&e1);
		v1 = (int) e1.e_addr;
		if ((t1 == S_RR) || (t1 == S_USER)) {
			outab(op);
			if (t1 == S_RR) {
				outab(0xE0 + v1);
			} else {
				if (is_abs(&e1) && (v1 & 0x01)) {
					aerr();
				}
				outrb(&e1, 0);
			}
		} else
		if ((t1 == S_IR) || (t1 == S_INDX)) {
			outab(op + 1);
			if (t1 == S_IR) {
				outab(0xE0 + v1);
			} else {
				outrb(&e1, 0);
			}
		} else {
			aerr();
		}
		break;

	case S_DOP:
		t1 = addr(&e1);
		v1 = (int) e1.e_addr;
		comma(1);
		t2 = addr(&e2);
		v2 = (int) e2.e_addr;
		if ((t1 == S_R) && (t2 == S_R)) {	/* op   r,r   */
			outab(op);
			outab((v1 << 4) + v2);
		} else
		if ((t1 == S_R) && (t2 == S_IR)) {	/* op   r,@r  */
			outab(op + 1);
			outab((v1 << 4) + v2);
		} else
		if (((t1 == S_R) || (t1 == S_USER)) &&
		    ((t2 == S_R) || (t2 == S_USER))) {	/* op   R,R  */
			outab(op + 2);
			if (t2 == S_R) {
				outab(0xE0 + v2);	/* op   _,r   */
			} else {
				outrb(&e2, 0);		/* op   _,R   */
			}
			if (t1 == S_R) {
				outab(0xE0 + v1);	/* op   r,_   */
			} else {
				outrb(&e1, 0);		/* op   R,_   */
			}
		} else
		if (((t1 == S_R)  || (t1 == S_USER)) &&
		    ((t2 == S_IR) || (t2 == S_INDX))) {	/* op   R,@R  */
			outab(op + 3);
			if (t2 == S_IR) {
				outab(0xE0 + v2);	/* op   _,@r   */
			} else {
				outrb(&e2, 0);		/* op   _,@R   */
			}
			if (t1 == S_R) {
				outab(0xE0 + v1);	/* op   r,_   */
			} else {
				outrb(&e1, 0);		/* op   R,_   */
			}
		} else
		if (((t1 == S_R) || (t1 == S_USER)) &&
		     (t2 == S_IMMED)) {			/* op   R,#  */
			if (t1 == S_R) {
				outab(op + 4);
				outab(0xE0 + v1);	/* op   r,#   */
			} else {
				outab(op + 4);
				outrb(&e1, 0);		/* op   R,#   */
			}
			outrb(&e2, 0);
		} else
		if (((t1 == S_IR) || (t1 == S_INDX)) &&
		     (t2 == S_IMMED)) {			/* op   @R,#  */
			if (t1 == S_IR) {
				outab(op + 5);
				outab(0xE0 + v1);	/* op   @r,#   */
			} else {
				outab(op + 5);
				outrb(&e1, 0);		/* op   @R,#   */
			}
			outrb(&e2, 0);
		} else {
			aerr();
		}
		break;

	case S_LD:
		t1 = addr(&e1);
		v1 = (int) e1.e_addr;
		comma(1);
		t2 = addr(&e2);
		v2 = (int) e2.e_addr;
		if ((t1 == S_R) && (t2 == S_R)) {	/* LD   r,r   */
			outab(0x09 + (v2 << 4));
			outab(0xE0 + v1);
		} else
		if ((t1 == S_R) && (t2 == S_USER)) {	/* LD   r,R   */
			outab(0x08 + (v1 << 4));
			outrb(&e2, 0);
		} else
		if ((t1 == S_USER) && (t2 == S_R)) {	/* LD   R,r  */
			outab(0x09 + (v2 << 4));
			outrb(&e1, 0);
		} else
		if ((t1 == S_USER) && (t2 == S_USER)) {	/* LD   R,R  */
			outab(0xE4);
			outrb(&e2, 0);
			outrb(&e1, 0);
		} else
		if ((t1 == S_R) && (t2 == S_IMMED)) {	/* LD   r,#  */
			outab(0x0C + (v1 << 4));
			outrb(&e2, 0);
		} else
		if ((t1 == S_USER) && (t2 == S_IMMED)) {/* LD   R,#   */
			outab(0xE6);
			outrb(&e1, 0);
			outrb(&e2, 0);
		} else
		if ((t1 == S_IR) && (t2 == S_IMMED)) {	/* LD   @r,#  */
			outab(0xE7);
			outab(0xE0 + v1);
			outrb(&e2, 0);
		} else
		if ((t1 == S_INDX) && (t2 == S_IMMED)) {/* LD   @R,#  */
			outab(0xE7);
			outrb(&e1, 0);
			outrb(&e2, 0);
		} else
		if ((t1 == S_R) && (t2 == S_IR)) {	/* LD   r,@r  */
			outab(0xE3);
			outab((v1 << 4) + v2);
		} else
		if ((t1 == S_IR) && (t2 == S_R)) {	/* LD   @r,r  */
			outab(0xF3);
			outab((v1 << 4) + v2);
		} else
		if (((t1 == S_R) || (t1 == S_USER)) &&
		    ((t2 == S_IR) || (t2 == S_INDX))) {	/* LD   R,@R  */
		    	outab(0xE5);
		    	if (t2 == S_IR) {	/* src */
				outab(0xE0 + v2);	/* LD   _,@r  */
			} else {
				outrb(&e2, 0);		/* LD   _,@R  */
			}
		    	if (t1 == S_R) {	/* dst */
				outab(0xE0 + v1);	/* LD   r,_   */
			} else {
				outrb(&e1, 0);		/* LD   R,_   */
			}
		} else
		if (((t1 == S_IR) || (t1 == S_INDX)) &&
		    ((t2 == S_R) || (t2 == S_USER))) {	/* LD   @R,R  */
		    	outab(0xF5);
		    	if (t2 == S_R) {	/* src */
				outab(0xE0 + v2);	/* LD   _,r   */
			} else {
				outrb(&e2, 0);		/* LD   _,R   */
			}
		    	if (t1 == S_IR) {	/* dst */
				outab(0xE0 + v1);	/* LD   @r,_  */
			} else {
				outrb(&e1, 0);		/* LD   @R,_  */
			}
		} else
		if ((t1 == S_R) && ((t2 & S_INDM) == S_INDR)) {
			outab(0xC7);			/* LD  r,offset(r)  */
			outab((v1 << 4) + (t2 & 0x0F));
			outrb(&e2, 0);
		} else
		if (((t1 & S_INDM) == S_INDR) && (t2 == S_R)) {
			outab(0xD7);			/* LD  offset(r),r  */
			outab((v2 << 4) + (t1 & 0x0F));
			outrb(&e1, 0);
		} else {
			aerr();
		}
		break;
			
	case S_LDCE:
		t1 = addr(&e1);
		v1 = (int) e1.e_addr;
		comma(1);
		t2 = addr(&e2);
		v2 = (int) e2.e_addr;
		if ((t1 == S_R) && (t2 == S_IRR)) {	/* op  r,@rr  */
			outab(op);
			outab((v1 << 4) + v2);
		} else
		if ((t1 == S_IRR) && (t2 == S_R)) {	/* op  @rr,r  */
			outab(op + 0x10);
			outab((v2 << 4) + v1);
		} else {
 	        	aerr();
		}
		break;

	case S_LDCEI:
		t1 = addr(&e1);
		v1 = (int) e1.e_addr;
		comma(1);
		t2 = addr(&e2);
		v2 = (int) e2.e_addr;
		if ((t1 == S_IR) && (t2 == S_IRR)) {	/* op  @r,@rr */
			outab(op);
			outab((v1 << 4) + v2);
		} else
		if ((t1 == S_IRR) && (t2 == S_IR)) {	/* op  @rr,@r */
			outab(op + 0x10);
			outab((v2 << 4) + v1);
		} else {
 	        	aerr();
		}
		break;

	case S_DJNZ:
		t1 = addr(&e1);
		v1 = (int) e1.e_addr;
		comma(1);
		expr(&e2, 0);
		if (t1 == S_R) {
			op |= (v1 << 4);
		} else {
			aerr();
		}
		outab(op);
		if (mchpcr(&e2)) {
			v2 = (int) (e2.e_addr - dot.s_addr - 1);
			if ((v2 < -128) || (v2 > 127))
				aerr();
			outab(v2);
		} else {
			outrb(&e2, R_PCR);
		}
		if (e2.e_mode != S_USER)
			rerr();
		break;

	case S_JR:
		if ((v1 = admode(CND)) != 0) {
			op |= (v1 << 4);		/* op CC,_  */
			comma(1);
		} else {
			op |= 0x80;			/* op  T,_  */
		}
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

	case S_JP:
		if ((v1 = admode(CND)) != 0) {
			op |= (v1 << 4);		/* JP  CC,_  */
			comma(1);
		} else {
			op |= 0x80;			/* JP   T,_  */
		}
		t2 = addr(&e2);
		v2 = (int) e2.e_addr;
		if (t2 == S_USER) {
			outab(op);			/* JP  CC,_   */
			outrw(&e2, 0);
		} else
		if ((v1 == 0) && ((t2 == S_IRR) || (t2 == S_INDX))) {
			outab(0x30);
			if (t2 == S_IRR) {
				outab(0xE0 + v2);	/* JP  @rr    */
			} else {
				outrb(&e2, 0);		/* JP  @RR    */
			}
		} else {
			aerr();
		}
		break;

	case S_CALL:
		t1 = addr(&e1);
		v1 = (int) e1.e_addr;
		if ((t1 == S_IRR) || (t1 == S_INDX)) {	/* op  @RR  */
			outab(op);
			if (t1 == S_IRR) {
				outab(0xE0 + v1);	/* op  @rr  */
			} else {
				outrb(&e1, 0);		/* op  @RR  */
			}
		} else
		if (t1 == S_USER) {		
			outab(op + 2);
			outrw(&e1, 0);
		} else {
			aerr();
		}
		break;

	case S_SRP:
		t1 = addr(&e1);
		v1 = (int) e1.e_addr;
		if ((t1 == S_IMMED) || (t1 == S_USER)) {
			outab(op);
			outrb(&e1, 0);
		} else {
			aerr();
		}
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
		opcycles = z8pg1[cb[0] & 0xFF];
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

