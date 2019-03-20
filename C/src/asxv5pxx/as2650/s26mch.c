/* s26mch.c */

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
#include "s2650.h"

char	*cpu	= "Signetics S2650(A)";
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
 * S2650 Cycle Count
 *
 *	opcycles = s26cyc[opcode]
 */
char s26cyc[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/  UN, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4,
/*10*/  UN,UN, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
/*20*/   2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4,
/*30*/   2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
/*40*/   2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4,
/*50*/   2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
/*60*/   2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4,
/*70*/   2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
/*80*/   2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4,
/*90*/  UN,UN, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
/*A0*/   2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4,
/*B0*/   2, 2, 2, 2, 3, 3,UN,UN, 3, 3, 3, 3, 3, 3, 3, 3,
/*C0*/   2, 2, 2, 2,UN,UN,UN,UN, 3, 3, 3, 3, 4, 4, 4, 4,
/*D0*/   2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
/*E0*/   2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4,
/*F0*/   2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
};

/*
 * Process a machine op.
 */
VOID
machine(mp)
struct mne *mp;
{
	int op, c;
	struct expr e1, e2;
	struct area *espa;
	char id[NCPS];
	int t1, a1, v1;
	int t2, a2, v2;

	clrexpr(&e1);
	clrexpr(&e2);
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

	case S_IO:
		/*
		 * redc	r
		 * redd	r
		 * wrtc	r
		 * wrtd	r
		 */
		t1 = addr(&e1);
		a1 = aindx;
		outab(op | (0x03 & a1));
		if (t1 != S_REG) {
			aerr();
		}
		break;

	case S_IOE:
		/*
		 * rede	r,#P
		 * wrte	r,#P
		 */
		t1 = addr(&e1);
		a1 = aindx;
		comma(1);
		t2 = addr(&e2);
		outab(op | (0x03 & a1));
		outrb(&e2, 0);
		if (t1 != S_REG) {
			aerr();
		}
		if (t2 != S_IMMED) {
			aerr();
		}
		break;

	case S_TYP1:
		/*
		 * lodr	r,*DISP
		 * strr	r,*DISP
		 * addr	r,*DISP
		 * subr	r,*DISP
		 * andr	r,*DISP
		 * iorr	r,*DISP
		 * eorr	r,*DISP
		 * comr	r,*DISP
		 * cmpr	r,*DISP
		 */
		t1 = addr(&e1);
		a1 = aindx;
		comma(1);
		a2 = 0;		/* Indirect Bit */
		if (((c = getnb()) == '@') || (c == '[')) {
			a2 = 0x80;
		} else {
			unget(c);
		}
		expr(&e2, 0);
		outab(op | (0x03 & a1));
		if (mchpcr(&e2)) {
			v2 = (int) (e2.e_addr - dot.s_addr - 1);
			if ((v2 < -64) || (v2 > 63)) {
				aerr();
			}
			outab(a2 | (0x7F & v2));
		} else {
			outrbm(&e2, R_PCR | M_7BIT, a2);
		}
		if (c == '[') {
			if (getnb() != ']') {
				aerr();
			}
		}
		if (t1 != S_REG) {
			aerr();
		}
		if (e2.e_mode != S_USER) {
			rerr();
		}
		break;

	case S_TYP2:
		/*
		 * loda	r,*ADDR(X)
		 * stra	r,*ADDR(X)
		 * adda	r,*ADDR(X)
		 * suba	r,*ADDR(X)
		 * anda	r,*ADDR(X)
		 * iora	r,*ADDR(X)
		 * eora	r,*ADDR(X)
		 * coma	r,*ADDR(X)
		 * cmpa	r,*ADDR(X)
		 */
		t1 = addr(&e1);
		a1 = aindx;
		comma(1);
		t2 = addr(&e2);
		a2 = aindx;
		if (t2 == S_INDX) {
			outab(op | (0x03 & a2));
			if ((0x03 & a1) != 0x00) {
				aerr();
			}
		} else {
			outab(op | (0x03 & a1));
		}
		outrwm(&e2, M_13BIT, (0xE0 & a2) << 8);
		if (t1 != S_REG) {
			aerr();
		}
		if ((t2 != S_EXT) && (t2 != S_INDX)) {
			aerr();
		}
		break;

	case S_TYP3:
		/*
		 * lodi	r,#DATA8
		 * addi	r,#DATA8
		 * subi	r,#DATA8
		 * andi	r,#DATA8
		 * iori	r,#DATA8
		 * eori	r,#DATA8
		 * comi	r,#DATA8
		 * cmpi	r,#DATA8
		 * tmi	r,#DATA8
		 */
		t1 = addr(&e1);
		a1 = aindx;
		comma(1);
		t2 = addr(&e2);
		outab(op | (0x03 & a1));
		outrb(&e2, 0);
		if ((t1 != S_REG) || (t2 != S_IMMED)) {
			aerr();
		}
		break;

	case S_TYP4:
		/*
		 * lodz	r	lodz r0		==>> iorz r0
		 * strz	r
		 * addz	r
		 * subz	r
		 * andz	r	andz r0		is illegal
		 * iorz	r
		 * eorz	r
		 * comz	r
		 * cmpz	r
		 * rrl	r
		 * rrr	r
		 * dar	r
		 */
		t1 = addr(&e1);
		a1 = aindx;
		v1 = op | (0x03 & a1);
		if (v1 == 0) {
			outab(0x60);
		} else {
			outab(v1);
			if (v1 == 0x40) {
				err('o');
			}
		}
		if (t1 != S_REG) {
			aerr();
		}
		break;

	case S_TYP5:
		/*
		 * ppsu	#DATA8
		 * ppsl	#DATA8
		 * cpsu	#DATA8
		 * cpsu	#DATA8
		 * tpsu	#DATA8
		 * tpsu	#DATA8
		 */
		t1 = addr(&e1);
		outab(op);
		outrb(&e1, 0);
		if (t1 != S_IMMED) {
			aerr();
		}
		break;

	case S_BRAZ:
		/*
		 * zbrr	*DISP
		 * zbsr	*DISP
		 */
		a1 = 0;		/* Indirect Bit */
		if (((c = getnb()) == '@') || (c == '[')) {
			a1 = 0x80;
		} else {
			unget(c);
		}
		expr(&e1, 0);
		outab(op);
		if (mchpcr(&e1)) {
			v1 = (int) (e1.e_addr - dot.s_addr - 1);
			if ((v1 < -64) || (v1 > 63)) {
				aerr();
			}
			outab(a1 | (0x7F & v1));
		} else {
			outrbm(&e1, R_MBRS | M_7BIT, a1);
		}
		if (c == '[') {
			if (getnb() != ']') {
				aerr();
			}
		}
		if (e1.e_mode != S_USER) {
			rerr();
		}
		break;

	case S_BRAE:
		/*
		 * bsxa	*BADD
		 * bxa	*BADD
		 */
		t1 = addr(&e1);
		a1 = aindx;
		outab(op);
		outrwm(&e1, M_15BIT | R_MBRO, (0x80 & a1) << 8);
		if (t1 != S_EXT) {
			aerr();
		}
		break;

	case S_BRCR:
		/*
		 * bctr	#DATA2,*DISP
		 * bcfr	#DATA2,*DISP	bcfr 3,*DISP	is illegal
		 * bstr	#DATA2,*DISP
		 * bsfr	#DATA2,*DISP	bsfr 3,*DISP	is illegal
		 */
		t1 = addr(&e1);
		a1 = aindx;
		comma(1);
		a2 = 0;		/* Indirect Bit */
		if (((c = getnb()) == '@') || (c == '[')) {
			a2 = 0x80;
		} else {
			unget(c);
		}
		expr(&e2, 0);
		if (t1 == S_CC) {
			v1 = op | (0x03 & a1);
			outab(v1);
		} else
		if (is_abs(&e1)) {
			if (e1.e_addr & ~0x03) {
				aerr();
			}
			v1 = op | (0x03 & (int) e1.e_addr);
			outab(v1);
		} else {
			v1 = 0;
			outrbm(&e1, M_2BIT | R_MBRO, op);
		}
		if (mchpcr(&e2)) {
			v2 = (int) (e2.e_addr - dot.s_addr - 1);
			if ((v2 < -64) || (v2 > 63)) {
				aerr();
			}
			outab(a2 | (0x7F & v2));
		} else {
			outrbm(&e2, R_PCR | M_7BIT, a2);
		}
		if (c == '[') {
			if (getnb() != ']') {
				aerr();
			}
		}
		if ((v1 == 0x9B) || (v1 == 0xBB)) {
			err('o');
		}
		if ((t1 != S_CC) && (t1 != S_IMMED)) {
			aerr();
		}
		if (e2.e_mode != S_USER) {
			rerr();
		}
		break;
		
	case S_BRCA:
		/*
		 * bcta	#DATA2,*BADD
		 * bcfa	#DATA2,*BADD	bcfa 3,*BADD	is illegal
		 * bsta	#DATA2,*BADD
		 * bsfa	#DATA2,*BADD	bsfa 3,*BADD	is illegal
		 */
		t1 = addr(&e1);
		a1 = aindx;
		comma(1);
		t2 = addr(&e2);
		a2 = aindx;
		if (t1 == S_CC) {
			v1 = op | (0x03 & a1);
			outab(v1);
		} else
		if (is_abs(&e1)) {
			if (e1.e_addr & ~0x03) {
				aerr();
			}
			v1 = op | (0x03 & (int) e1.e_addr);
			outab(v1);
		} else {
			v1 = 0;
			outrbm(&e1, M_2BIT | R_MBRO, op);
		}
		outrwm(&e2, M_15BIT | R_MBRO, (0x80 & a2) << 8);
		if ((v1 == 0x9F) || (v1 == 0xBF)) {
			err('o');
		}
		if ((t1 != S_CC) && (t1 != S_IMMED)) {
			aerr();
		}
		if (t2 != S_EXT) {
			aerr();
		}
		break;

	case S_BRRR:
		/*
		 * birr	r,*DISP
		 * bdrr	r,*DISP
		 * brnr	r,*DISP
		 * bsnr	r,*DISP
		 */
		t1 = addr(&e1);
		a1 = aindx;
		comma(1);
		a2 = 0;		/* Indirect Bit */
		if (((c = getnb()) == '@') || (c == '[')) {
			a2 = 0x80;
		} else {
			unget(c);
		}
		expr(&e2, 0);
		outab(op | (0x03 & a1));
		if (mchpcr(&e2)) {
			v2 = (int) (e2.e_addr - dot.s_addr - 1);
			if ((v2 < -64) || (v2 > 63)) {
				aerr();
			}
			outab(a2 | (0x7F & v2));
		} else {
			outrbm(&e2, R_PCR | M_7BIT, a2);
		}
		if (c == '[') {
			if (getnb() != ']') {
				aerr();
			}
		}
		if (t1 != S_REG) {
			aerr();
		}
		if (e2.e_mode != S_USER) {
			rerr();
		}
		break;

	case S_BRRA:
		/*
		 * bira	r,*BADD
		 * bdra	r,*BADD
		 * brna	r,*BADD
		 * bsna	r,*BADD
		 */
		t1 = addr(&e1);
		a1 = aindx;
		comma(1);
		t2 = addr(&e2);
		a2 = aindx;
		outab(op | (0x03 & a1));
		outrwm(&e2, M_15BIT | R_MBRO, (0x80 & a2) << 8);
		if (t1 != S_REG) {
			aerr();
		}
		if (t2 != S_EXT) {
			aerr();
		}
		break;

	case S_RET:
		/*
		 * retc	#DATA2
		 * rete	#DATA2
		 */
		t1 = addr(&e1);
		a1 = aindx;	
		if (t1 == S_CC) {
			outab(op | (0x03 & a1));
		} else
		if (is_abs(&e1)) {
			v1 = (int) e1.e_addr;
			if (v1 & ~0x03) {
				aerr();
			}
			outab(op | (0x03 & v1));
		} else {
			outrbm(&e1, M_2BIT | R_MBRO, op);
		}
		if ((t1 != S_IMMED) && (t1 != S_CC)) {
			aerr();
		}
		break;
			
	case S_INH:
		/*
		 * lpsu
		 * lpsl
		 * spsu
		 * spsl
		 * nop
		 * halt
		 * wait
		 */
		outab(op);
		break;

	default:
		opcycles = OPCY_ERR;
		err('o');
		break;
	}

	if (opcycles == OPCY_NONE) {
		opcycles = s26cyc[cb[0] & 0xFF];
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
