/* ez80mch.c */

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
 *
 *
 * Ported by Patrick Head
 * from the ASZ80 assembler.
 *
 * patrick at phead dot net
 */

#include "asxxxx.h"
#include "ez80.h"

char	*cpu	= "Zilog eZ80";
char	*dsft	= "asm";

char	imtab[3] = { 0x46, 0x56, 0x5E };
int	m_mode;

/*
 * Opcode Cycle Definitions
 */
#define	OPCY_SDP	((char) (0xFF))
#define	OPCY_ERR	((char) (0xFE))

/*	OPCY_NONE	((char) (0x80))	*/
/*	OPCY_MASK	((char) (0x7F))	*/

#define	OPCY_AMOD	((char) (0xFD))

#define	UN	((char) (OPCY_NONE | 0x00))
#define	P2	((char) (OPCY_NONE | 0x01))
#define	P3	((char) (OPCY_NONE | 0x02))
#define	P4	((char) (OPCY_NONE | 0x03))
#define	P5	((char) (OPCY_NONE | 0x04))
#define	P6	((char) (OPCY_NONE | 0x05))
#define	P7	((char) (OPCY_NONE | 0x06))

#define	PF	((char) (OPCY_NONE | 0x10))

/*
 * EZ80 Opcode Cycle Pages
 */

static char  ez80pg1[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/   1, 3, 2, 1, 1, 1, 2, 1, 1, 1, 2, 1, 1, 1, 2, 1,
/*10*/   4, 3, 2, 1, 1, 1, 2, 1, 3, 1, 2, 1, 1, 1, 2, 1,
/*20*/   3, 3, 7, 1, 1, 1, 2, 1, 3, 1, 5, 1, 1, 1, 2, 1,
/*30*/   3, 3, 4, 1, 4, 4, 3, 1, 3, 1, 4, 1, 1, 1, 2, 1,
/*40*/  PF, 1, 1, 1, 1, 1, 2, 1, 1,PF, 1, 1, 1, 1, 2, 1,
/*50*/   1, 1,PF, 1, 1, 1, 2, 1, 1, 1, 1,PF, 1, 1, 2, 1,
/*60*/   1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 2, 1,
/*70*/   2, 2, 2, 2, 2, 2, 1, 2, 1, 1, 1, 1, 1, 1, 2, 1,
/*80*/   1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 2, 1,
/*90*/   1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 2, 1,
/*A0*/   1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 2, 1,
/*B0*/   1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 2, 1,
/*C0*/   6, 3, 4, 4, 6, 3, 2, 5, 6, 5, 4,P2, 6, 5, 2, 5,
/*D0*/   6, 3, 4, 3, 6, 3, 2, 5, 6, 1, 4, 3, 6,P3, 2, 5,
/*E0*/   6, 3, 4, 5, 6, 3, 2, 5, 6, 3, 4, 1, 6,P4, 2, 5,
/*F0*/   6, 3, 4, 1, 6, 3, 2, 5, 6, 1, 4, 1, 6,P5, 2, 5
};

static char  ez80pg2[256] = {  /* P2 == CB */
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/   2, 2, 2, 2, 2, 2, 5, 2, 2, 2, 2, 2, 2, 2, 5, 2,
/*10*/   2, 2, 2, 2, 2, 2, 5, 2, 2, 2, 2, 2, 2, 2, 5, 2,
/*20*/   2, 2, 2, 2, 2, 2, 5, 2, 2, 2, 2, 2, 2, 2, 5, 2,
/*30*/  UN,UN,UN,UN,UN,UN,UN,UN, 2, 2, 2, 2, 2, 2, 5, 2,
/*40*/   2, 2, 2, 2, 2, 2, 3, 2, 2, 2, 2, 2, 2, 2, 3, 2,
/*50*/   2, 2, 2, 2, 2, 2, 3, 2, 2, 2, 2, 2, 2, 2, 3, 2,
/*60*/   2, 2, 2, 2, 2, 2, 3, 2, 2, 2, 2, 2, 2, 2, 3, 2,
/*70*/   2, 2, 2, 2, 2, 2, 3, 2, 2, 2, 2, 2, 2, 2, 3, 2,
/*80*/   2, 2, 2, 2, 2, 2, 3, 2, 2, 2, 2, 2, 2, 2, 3, 2,
/*90*/   2, 2, 2, 2, 2, 2, 3, 2, 2, 2, 2, 2, 2, 2, 3, 2,
/*A0*/   2, 2, 2, 2, 2, 2, 3, 2, 2, 2, 2, 2, 2, 2, 3, 2,
/*B0*/   2, 2, 2, 2, 2, 2, 3, 2, 2, 2, 2, 2, 2, 2, 3, 2,
/*C0*/   2, 2, 2, 2, 2, 2, 3, 2, 2, 2, 2, 2, 2, 2, 3, 2,
/*D0*/   2, 2, 2, 2, 2, 2, 3, 2, 2, 2, 2, 2, 2, 2, 3, 2,
/*E0*/   2, 2, 2, 2, 2, 2, 3, 2, 2, 2, 2, 2, 2, 2, 3, 2,
/*F0*/   2, 2, 2, 2, 2, 2, 3, 2, 2, 2, 2, 2, 2, 2, 3, 2
};

static char  ez80pg3[256] = {  /* P3 == DD */
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/  UN,UN,UN,UN,UN,UN,UN, 5,UN, 2,UN,UN,UN,UN,UN, 5,
/*10*/  UN,UN,UN,UN,UN,UN,UN, 5,UN, 2,UN,UN,UN,UN,UN, 5,
/*20*/  UN, 4, 6, 2, 2, 2, 2, 5,UN, 2, 6, 2, 2, 2, 2, 5,
/*30*/  UN, 5,UN,UN, 6, 6, 5, 5,UN, 2,UN,UN,UN,UN, 5, 5,
/*40*/  UN,UN,UN,UN, 2, 2, 4,UN,UN,UN,UN,UN, 2, 2, 4,UN,
/*50*/  UN,UN,UN,UN, 2, 2, 4,UN,UN,UN,UN,UN, 2, 2, 4,UN,
/*60*/   2, 2, 2, 2, 2, 2, 4, 2, 2, 2, 2, 2, 2, 2, 4, 2,
/*70*/   4, 4, 4, 4, 4, 4,UN, 4,UN,UN,UN,UN, 2, 2, 4,UN,
/*80*/  UN,UN,UN,UN, 2, 2, 4,UN,UN,UN,UN,UN, 2, 2, 4,UN,
/*90*/  UN,UN,UN,UN, 2, 2, 4,UN,UN,UN,UN,UN, 2, 2, 4,UN,
/*A0*/  UN,UN,UN,UN, 2, 2, 4,UN,UN,UN,UN,UN, 2, 2, 4,UN,
/*B0*/  UN,UN,UN,UN, 2, 2, 4,UN,UN,UN,UN,UN, 2, 2, 4,UN,
/*C0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,P6,UN,UN,UN,UN,
/*D0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*E0*/  UN, 4,UN, 6,UN, 4,UN,UN,UN, 4,UN,UN,UN,UN,UN,UN,
/*F0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN, 2,UN,UN,UN,UN,UN,UN
};

static char  ez80pg4[256] = {  /* P4 == ED */
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/   4, 4, 3, 3, 2,UN,UN, 4, 4, 4,UN,UN, 2,UN,UN, 4,
/*10*/   4, 4, 3, 3, 2,UN,UN, 4, 4, 4,UN,UN, 2,UN,UN, 4,
/*20*/   4, 4, 3, 3, 2,UN,UN, 4, 4, 4,UN,UN, 2,UN,UN, 4,
/*30*/  UN, 4, 3, 3, 3,UN,UN, 4, 4, 4,UN,UN, 2,UN, 4, 4,
/*40*/   3, 3, 2, 6, 2, 6, 2, 2, 3, 3, 2, 6, 6, 6,UN, 2,
/*50*/   3, 3, 2, 6, 3, 3, 2, 2, 3, 3, 2, 6, 6,UN, 2, 2,
/*60*/   3, 3, 2,UN, 3, 5, 5, 5, 3, 3, 2,UN, 6, 2, 2, 5,
/*70*/  UN,UN, 2, 6, 4,UN, 2,UN, 3, 3, 2, 5, 6, 2, 2,UN,
/*80*/  UN,UN, 5, 5, 5,UN,UN,UN,UN,UN, 5, 5, 5,UN,UN,UN,
/*90*/  UN,UN, 2, 2, 2,UN,UN,UN,UN,UN, 2, 2, 2,UN,UN,UN,
/*A0*/   5, 3, 5, 5, 5,UN,UN,UN, 5, 3, 5, 5, 5,UN,UN,UN,
/*B0*/   2, 1, 2, 2, 2,UN,UN,UN, 2, 1, 2, 2, 2,UN,UN,UN,
/*C0*/  UN,UN, 2, 3,UN,UN,UN, 2,UN,UN, 2, 2,UN,UN,UN,UN,
/*D0*/  UN,UN,UN,UN,UN,UN,UN, 2,UN,UN,UN,UN,UN,UN,UN,UN,
/*E0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*F0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN
};

static char  ez80pg5[256] = {  /* P5 == FD */
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/  UN,UN,UN,UN,UN,UN,UN, 5,UN, 2,UN,UN,UN,UN,UN, 5,
/*10*/  UN,UN,UN,UN,UN,UN,UN, 5,UN, 2,UN,UN,UN,UN,UN, 5,
/*20*/  UN, 4, 6, 2, 2, 2, 2, 5,UN, 2, 6, 2, 2, 2, 2, 5,
/*30*/  UN, 5,UN,UN, 6, 6, 5, 5,UN, 2,UN,UN,UN,UN, 5, 5,
/*40*/  UN,UN,UN,UN, 2, 2, 4,UN,UN,UN,UN,UN, 2, 2, 4,UN,
/*50*/  UN,UN,UN,UN, 2, 2, 4,UN,UN,UN,UN,UN, 2, 2, 4,UN,
/*60*/   2, 2, 2, 2, 2, 2, 4, 2, 2, 2, 2, 2, 2, 2, 4, 2,
/*70*/   4, 4, 4, 4, 4, 4,UN, 4,UN,UN,UN,UN, 2, 2, 4,UN,
/*80*/  UN,UN,UN,UN, 2, 2, 4,UN,UN,UN,UN,UN, 2, 2, 4,UN,
/*90*/  UN,UN,UN,UN, 2, 2, 4,UN,UN,UN,UN,UN, 2, 2, 4,UN,
/*A0*/  UN,UN,UN,UN, 2, 2, 4,UN,UN,UN,UN,UN, 2, 2, 4,UN,
/*B0*/  UN,UN,UN,UN, 2, 2, 4,UN,UN,UN,UN,UN, 2, 2, 4,UN,
/*C0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,P7,UN,UN,UN,UN,
/*D0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*E0*/  UN, 4,UN, 6,UN, 4,UN,UN,UN, 4,UN,UN,UN,UN,UN,UN,
/*F0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN, 2,UN,UN,UN,UN,UN,UN
};

static char  ez80pg6[256] = {  /* P6 == DD CB */
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/  UN,UN,UN,UN,UN,UN, 7,UN,UN,UN,UN,UN,UN,UN, 7,UN,
/*10*/  UN,UN,UN,UN,UN,UN, 7,UN,UN,UN,UN,UN,UN,UN, 7,UN,
/*20*/  UN,UN,UN,UN,UN,UN, 7,UN,UN,UN,UN,UN,UN,UN, 7,UN,
/*30*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN, 7,UN,
/*40*/  UN,UN,UN,UN,UN,UN, 5,UN,UN,UN,UN,UN,UN,UN, 5,UN,
/*50*/  UN,UN,UN,UN,UN,UN, 5,UN,UN,UN,UN,UN,UN,UN, 5,UN,
/*60*/  UN,UN,UN,UN,UN,UN, 5,UN,UN,UN,UN,UN,UN,UN, 5,UN,
/*70*/  UN,UN,UN,UN,UN,UN, 5,UN,UN,UN,UN,UN,UN,UN, 5,UN,
/*80*/  UN,UN,UN,UN,UN,UN, 5,UN,UN,UN,UN,UN,UN,UN, 5,UN,
/*90*/  UN,UN,UN,UN,UN,UN, 5,UN,UN,UN,UN,UN,UN,UN, 5,UN,
/*A0*/  UN,UN,UN,UN,UN,UN, 5,UN,UN,UN,UN,UN,UN,UN, 5,UN,
/*B0*/  UN,UN,UN,UN,UN,UN, 5,UN,UN,UN,UN,UN,UN,UN, 5,UN,
/*C0*/  UN,UN,UN,UN,UN,UN, 5,UN,UN,UN,UN,UN,UN,UN, 5,UN,
/*D0*/  UN,UN,UN,UN,UN,UN, 5,UN,UN,UN,UN,UN,UN,UN, 5,UN,
/*E0*/  UN,UN,UN,UN,UN,UN, 5,UN,UN,UN,UN,UN,UN,UN, 5,UN,
/*F0*/  UN,UN,UN,UN,UN,UN, 5,UN,UN,UN,UN,UN,UN,UN, 5,UN
};

static char  ez80pg7[256] = {  /* P7 == FD CB */
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/  UN,UN,UN,UN,UN,UN, 7,UN,UN,UN,UN,UN,UN,UN, 7,UN,
/*10*/  UN,UN,UN,UN,UN,UN, 7,UN,UN,UN,UN,UN,UN,UN, 7,UN,
/*20*/  UN,UN,UN,UN,UN,UN, 7,UN,UN,UN,UN,UN,UN,UN, 7,UN,
/*30*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN, 7,UN,
/*40*/  UN,UN,UN,UN,UN,UN, 5,UN,UN,UN,UN,UN,UN,UN, 5,UN,
/*50*/  UN,UN,UN,UN,UN,UN, 5,UN,UN,UN,UN,UN,UN,UN, 5,UN,
/*60*/  UN,UN,UN,UN,UN,UN, 5,UN,UN,UN,UN,UN,UN,UN, 5,UN,
/*70*/  UN,UN,UN,UN,UN,UN, 5,UN,UN,UN,UN,UN,UN,UN, 5,UN,
/*80*/  UN,UN,UN,UN,UN,UN, 5,UN,UN,UN,UN,UN,UN,UN, 5,UN,
/*90*/  UN,UN,UN,UN,UN,UN, 5,UN,UN,UN,UN,UN,UN,UN, 5,UN,
/*A0*/  UN,UN,UN,UN,UN,UN, 5,UN,UN,UN,UN,UN,UN,UN, 5,UN,
/*B0*/  UN,UN,UN,UN,UN,UN, 5,UN,UN,UN,UN,UN,UN,UN, 5,UN,
/*C0*/  UN,UN,UN,UN,UN,UN, 5,UN,UN,UN,UN,UN,UN,UN, 5,UN,
/*D0*/  UN,UN,UN,UN,UN,UN, 5,UN,UN,UN,UN,UN,UN,UN, 5,UN,
/*E0*/  UN,UN,UN,UN,UN,UN, 5,UN,UN,UN,UN,UN,UN,UN, 5,UN,
/*F0*/  UN,UN,UN,UN,UN,UN, 5,UN,UN,UN,UN,UN,UN,UN, 5,UN
};

static char *ez80Page[7] = {
    ez80pg1, ez80pg2, ez80pg3, ez80pg4,
    ez80pg5, ez80pg6, ez80pg7
};

/*
 * Process a machine op.
 */
VOID
machine(mp)
struct mne *mp;
{
	int op, of, t1, t2;
	struct expr e1, e2;
	int rf, sf, v1, v2;
	int needPreamble, m_aerr;
	int opc1, opc2, opc3;

	clrexpr(&e1);
	clrexpr(&e2);
	op = (int) mp->m_valu;
	rf = mp->m_type;
	sf = mp->m_flag;

	needPreamble = 0;
	m_aerr = 0;

	/*
	 * This section processes the output of preamble bytes
	 * and any special needs for selected instructions.
	 */

 	switch (m_mode) {
	case MM_ADL:
		switch(sf) {
		case M_L:
			switch(rf) {
			case S_INH2:
				/* reti.l / retn.l */
				if ((op == 0x4D) || (op == 0x45)) {
					outab(0x5b);
					break;
				}	m_aerr = 1;		break;
			case S_JP:	needPreamble = 1;	break;
			case S_RET:	outab(0x5b);		break;
			default:	m_aerr = 1;		break;
			}
			break;
		case M_S:
			switch(rf) {
			case S_JP:	needPreamble = 1;	break;
			default:	outab(0x52);		break;
			}
			break;
		case M_IL:
			switch(rf) {
			case S_CALL:	outab(0x5b);		break;
			default:	m_aerr = 1;		break;
			}
			break;
		case M_IS:
			switch(rf) {
			case S_CALL:	outab(0x49);		break;
			case S_LD:	outab(0x40);		break;
			default:	m_aerr = 1;		break;
			}
			break;
		case M_LIL:
			switch(rf) {
			case S_JP:	outab(0x5B);		break;
			default:	m_aerr = 1;		break;
			}
			break;
		case M_SIS:
			switch(rf) {
			default:	outab(0x40);		break;
			}
			break;
		default:
			break;
		}
		break;

	case MM_Z80:
 		switch(sf) {
		case M_L:
			switch(rf) {
			case S_JP:	needPreamble = 1;	break;
			default:	outab(0x49);		break;
			}
			break;
		case M_S:
			switch(rf) {
			case S_JP:	needPreamble = 1;	break;
			default:	m_aerr = 1;		break;
			}
			break;
		case M_IL:
			switch(rf) {
			case S_CALL:	outab(0x52);		break;
			case S_LD:	outab(0x5B);		break;
			default:	m_aerr = 1;		break;
			}
			break;
		case M_IS:
			switch(rf) {
			case S_CALL:	outab(0x40);		break;
			default:	m_aerr = 1;		break;
			}
			break;
		case M_LIL:
			switch(rf) {
			default:	outab(0x5b);		break;
			}
			break;
		case M_SIS:
			switch(rf) {
			case S_JP:	outab(0x40);		break;
			default:	m_aerr = 1;		break;
			}
			break;
		default:
			break;
		}

	default:
		break;
	}

	if (m_aerr) {
		while (getnb()) { ; }
		aerr();
		return;
	}

	switch (rf) {

	case S_INH1:
		outab(op);
		break;

	case S_INH2:
	case S_MIX:
		outab(0xED);
		outab(op);
		break;

	case S_RET:
		if (more()) {
			/*
			 * ret  cc
			 */
			if ((v1 = admode(CND)) != 0) {
				outab(op | (v1<<3));
			} else {
				qerr();
			}
		} else {
			/*
			 * ret
			 */
			outab(0xC9);
		}
		break;

	case S_PUSH:
		/*
		 * push/pop af
		 */
		if (admode(RXX)) {
			outab(op+0x30);
			break;
		} else
		/*
		 * push/pop bc/de/hl/ix/iy	(not sp)
		 */
		if ((v1 = admode(RX)) != 0 && (v1 &= 0xFF) != SP) {
			if (v1 != gixiy(v1)) {
				outab(op+0x20);
				break;
			}
			outab(op | (v1<<4));
			break;
		}
		aerr();
		break;

	case S_RST:
		v1 = (int) absexpr();
		if (v1 & ~0x38) {
			aerr();
			v1 = 0;
		}
		outab(op|v1);
		break;

	case S_IM:
		expr(&e1, 0);
		abscheck(&e1);
		if (e1.e_addr > 2) {
			aerr();
			e1.e_addr = 0;
		}
		outab(op);
		outab(imtab[(int) e1.e_addr]);
		break;

	case S_BIT:
		expr(&e1, 0);
		t1 = (is_abs(&e1) && (e1.e_addr & ~7)) ? 1 : 0;
		comma(1);
		t2 = addr(&e2);
		/*
		 * bit  b,(hl)
		 * bit  b,(ix+d)
		 * bit  b,(iy+d)
		 * bit  b,r
		 */
		if (sf && (t2 == S_R8)) {	/* No Opcode Suffixes Allowed */
			aerr();
		}
		/*
		 * b
		 *	The bit number is allowed to be an
		 *	externally defined variable. At link
		 *	time the value will be merged with op.
		 */
		if (genopm(0xCB, op, &e1, &e2, 0) || t1) {
			aerr();
		}
		break;

	case S_RL:
		t1 = addr(&e1);
		/*
		 * rl  (hl)
		 * rl  (ix+d)
		 * rl  (iy+d)
		 * rl  r
		 */
		if (sf && (t1 == S_R8)) {	/* No Opcode Suffixes Allowed */
			aerr();
		}
		if (genop(0xCB, op, &e1, 0)) {
			aerr();
		}
		break;

	case S_AND:
	case S_SUB:
		/*
		 * op  (hl)
		 * op  (ix+d)
		 * op  (iy+d)
		 * op  r
		 * op  n	[#n]
		 * op    ixl
		 * op    ixh
		 * op    iyl
		 * op    iyh
		 */
		t1 = addr(&e1);
		if (t1 == S_USER)
			t1 = e1.e_mode = S_IMMED;
		if (more()) {
			/*
			 * op  a,(hl)
			 * op  a,(ix+d)
			 * op  a,(iy+d)
			 * op  a,r
			 * op  a,n	[a,#n]
			 * op  a,ixl
			 * op  a,ixh
			 * op  a,iyl
			 * op  a,iyh
			 */
			if ((t1 != S_R8) || (e1.e_addr != A))
				aerr();
			comma(1);
			clrexpr(&e1);
			t1 = addr(&e1);
			if (t1 == S_USER)
				t1 = e1.e_mode = S_IMMED;
		}
		if (t1 == S_R8X) {
			v1 = (int) e1.e_addr;
			v2 = 4;
			if ((v1 == IXL) || (v1 == IYL))
				++v2;
			if (sf) {	/* No Opcode Suffixes Allowed */
				aerr();
			}
			/*
			 * op  a,ixl
			 * op  a,ixh
			 * op    ixl
			 * op    ixh
			 */
			if ((v1 == IXH) || (v1 == IXL)) {
				outab(0xDD);
				outab(op + v2);
				break;
			} else
			/*
			 * op  a,iyl
			 * op  a,iyh
			 * op    iyl
			 * op    iyh
			 */
			if ((v1 == IYH) || (v1 == IYL)) {
				outab(0xFD);
				outab(op + v2);
				break;
			} else {
				aerr();
				break;
			}
		}
		/*
		 * op  (hl)
		 * op  (ix+d)
		 * op  (iy+d)
		 * op  r
		 * op  n	[#n]
		 *
		 * op  a,(hl)
		 * op  a,(ix+d)
		 * op  a,(iy+d)
		 * op  a,r
		 * op  a,n	[a,#n]
		 */
		if (sf && ((t1 == S_R8) || (t1 == S_IMMED))) {	/* No Opcode Suffixes Allowed */
			aerr();
		}
		if (genop(0, op, &e1, 1)) {
			aerr();
		}
		break;

	case S_ADD:
	case S_ADC:
	case S_SBC:
		t1 = addr(&e1);
		if (t1 == S_USER)
			t1 = e1.e_mode = S_IMMED;
		t2 = 0;
		if (more()) {
			comma(1);
			t2 = addr(&e2);
			if (t2 == S_USER)
				t2 = e2.e_mode = S_IMMED;
		}
		if ((t1 == S_RX) && (t2 == S_RX)) {
			if (rf == S_ADD)
				op = 0x09;
			if (rf == S_ADC)
				op = 0x4A;
			if (rf == S_SBC)
				op = 0x42;
			v1 = (int) e1.e_addr;
			v2 = (int) e2.e_addr;
			/*
			 * op  hl,bc
			 * op  hl,de
			 * op  hl,hl
			 * op  hl,sp
			 */
			if ((v1 == HL) && (v2 <= SP)) {
				if (rf != S_ADD)
					outab(0xED);
				outab(op | (v2<<4));
				break;
			}
			if (rf != S_ADD) {
				aerr();
				break;
			}
			/*
			 * add  ix,bc
			 * add  ix,de
			 * add  ix,ix
			 * add  ix,sp
			 */
			if ((v1 == IX) && (v2 != HL) && (v2 != IY)) {
				if (v2 == IX)
					v2 = HL;
				outab(0xDD);
				outab(op | (v2<<4));
				break;
			}
			/*
			 * add  iy,bc
			 * add  iy,de
			 * add  iy,iy
			 * add  iy,sp
			 */
			if ((v1 == IY) && (v2 != HL) && (v2 != IX)) {
				if (v2 == IY)
					v2 = HL;
				outab(0xFD);
				outab(op | (v2<<4));
				break;
			}
		}
		if ((t1 == S_R8X) || (t2 == S_R8X)) {
			if ((t1 == S_R8X) && t2) {
				aerr();
				break;
			} else if ((t2 == S_R8X) && e1.e_addr != A) {
				aerr();
				break;
			}
			if (t1 == S_R8X) {
				v1 = (int) e1.e_addr;
			} else {
				v1 = (int) e2.e_addr;
			}
			v2 = 4;
			if ((v1 == IXL) || (v1 == IYL))
				++v2;
			if (sf) {	/* No Opcode Suffixes Allowed */
				aerr();
			}
			/*
			 * op  a,ixl
			 * op  a,ixh
			 * op    ixl
			 * op    ixh
			 */
			if ((v1 == IXH) || (v1 == IXL)) {
				outab(0xDD);
				outab(op + v2);
				break;
			} else
			/*
			 * op  a,iyl
			 * op  a,iyh
			 * op    iyl
			 * op    iyh
			 */
			if ((v1 == IYH) || (v1 == IYL)) {
				outab(0xFD);
				outab(op + v2);
				break;
			}
		}
		if (t2 == 0) {
			/*
			 * op  (hl)
			 * op  (ix+d)
			 * op  (iy+d)
			 * op  r
			 * op  n	[#n]
			 */
			if (sf && ((t1 == S_R8) || (t1 == S_IMMED))) {	/* No Opcode Suffixes Allowed */
				aerr();
			}
			if (genop(0, op, &e1, 1))
				aerr();
			break;
		}
		if ((t1 == S_R8) && (e1.e_addr == A)) {
			/*
			 * op  a,(hl)
			 * op  a,(ix+d)
			 * op  a,(iy+d)
			 * op  a,r
			 * op  a,n	[a,#n]
			 */
			if (sf && ((t2 == S_R8) || (t2 == S_IMMED))) {	/* No Opcode Suffixes Allowed */
				aerr();
			}
			if (genop(0, op, &e2, 1))
				aerr();
			break;
		}
		aerr();
		break;

	case S_LD:
		/*
		 * Enumerated ld instructions:
		 *
		 * ld
		 * ld.l		ld.il		ld.lil
		 * ld.s		ld.is		ld.sis
		 */
		t1 = addr(&e1);
		v1 = (int) e1.e_addr;
		comma(1);
		t2 = addr(&e2);
		v2 = (int) e2.e_addr;
		if (t2 == S_USER)
			t2 = e2.e_mode = S_IMMED;
		/*
		 * ld  r,g
		 * ld  r,n	(r,#n)
		 * ld  r,(hl)
		 * ld  r,(ix+d)
		 * ld  r,(iy+d)
		 */
		if (t1 == S_R8) {
			/*
			 * ld  r,g
			 */
			if (t2 == S_R8) {
				if (((v1 == B) && (v2 == B)) ||		/* ld b,b ==>> 0x40 */
				    ((v1 == C) && (v2 == C)) ||		/* ld c,c ==>> 0x49 */
				    ((v1 == D) && (v2 == D)) ||		/* ld d,d ==>> 0x52 */
				    ((v1 == E) && (v2 == E))) {		/* ld e,e ==>> 0x5b */
					outab(0x00);			/* nop */
					aerr();
					break;
				}
				if (sf) {	/* No Opcode Suffixes Allowed */
					aerr();
				}
				genop(0, op | (v1<<3), &e2, 0);
				break;
			}
			/*
			 * ld  r,n	(r,#n)
			 */
			if (t2 == S_IMMED) {
				if (sf) {	/* No Opcode Suffixes Allowed */
					aerr();
				}
				outab((v1<<3) | 0x06);
				outrb(&e2,0);
				break;
			}
			/*
			 * ld  r,(hl)
			 * ld  r,(ix+d)
			 * ld  r,(iy+d)
			 */
			if (genop(0, op | (v1<<3), &e2, 0) == 0) {
				/*
				 * Only .S and .L Suffixes Allowed
				 */
				if ((sf == M_IS)  || (sf == M_IL)  ||
				    (sf == M_SIS) || (sf == M_LIL) ||
				    (sf == M_SIL) || (sf == M_LIS)) {
					aerr();
				}
				break;
			}
		}
		/*
		 * ld  be,mn	[be,#mn]
		 * ld  de,mn	[de,#mn]
		 * ld  hl,mn	[hl,#mn]
		 * ld  sp,mn	[sp,#mn]
		 * ld  ix,mn	[ix,#mn]
		 * ld  iy,mn	[iy,#mn]
		 */
		if ((t1 == S_RX) && (t2 == S_IMMED)) {
			/*
			 * Only .SIS and .LIL Suffixes Allowed
			 */
			if ((sf == M_S)   || (sf == M_L)   ||
			    (sf == M_IS)  || (sf == M_IL)  ||
			    (sf == M_SIL) || (sf == M_LIS)) {
				aerr();
			}
			v1 = gixiy(v1);
			outab(0x01 | (v1<<4));
			glilsis(m_mode, sf, &e2);
			break;
		}
		/*
		 * ld  bc,(hl)
		 * ld  de,(hl)
		 * ld  hl,(hl)
		 * ld  ix,(hl)
		 * ld  iy,(hl)
		 */
		if ((t1 == S_RX) && (t2 == S_IDHL)) {
			/*
			 * Only .S and .L Suffixes Allowed
			 */
			if ((sf == M_IS)  || (sf == M_IL)  ||
			    (sf == M_SIS) || (sf == M_LIL) ||
			    (sf == M_SIL) || (sf == M_LIS)) {
				aerr();
			}
			if (v1 == SP) {
				aerr();
				break;
			}
			outab(0xED);
			if (v1 == IX) {
				outab(0x37);
			} else
			if (v1 == IY) {
				outab(0x31);
			} else {
				outab(7 + (v1 << 4));
			}
			break;
		}
		/*
		 * ld  (hl),bc
		 * ld  (hl),de
		 * ld  (hl),hl
		 * ld  (hl),ix
		 * ld  (hl),iy
		 */
		if ((t2 == S_RX) && (t1 == S_IDHL)) {
			/*
			 * Only .S and .L Suffixes Allowed
			 */
			if ((sf == M_IS)  || (sf == M_IL)  ||
			    (sf == M_SIS) || (sf == M_LIL) ||
			    (sf == M_SIL) || (sf == M_LIS)) {
				aerr();
			}
			if (v2 == SP) {
				aerr();
				break;
			}
			outab(0xED);
			if (v2 == IX) {
				outab(0x3f);
			} else
			if (v2 == IY) {
				outab(0x3e);
			} else {
				outab(0xf + (v2 << 4));
			}
			break;
		}
		/*
		 * ld  bc,(ix+d)	ld  bc,(iy+d)
		 * ld  de,(ix+d)	ld  de,(iy+d)
		 * ld  hl,(ix+d)	ld  hl,(iy+d)
		 * ld  ix,(ix+d)	ld  ix,(iy+d)
		 * ld  iy,(ix+d)	ld  iy,(iy+d)
		 */
		if ((t1 == S_RX) && ((t2 == S_IDIX) || (t2 == S_IDIY))) {
			/*
			 * Only .S and .L Suffixes Allowed
			 */
			if ((sf == M_IS)  || (sf == M_IL)  ||
			    (sf == M_SIS) || (sf == M_LIL) ||
			    (sf == M_SIL) || (sf == M_LIS)) {
				aerr();
			}
			if (v1 == SP) {
				aerr();
				break;
			}
			if (t2 == S_IDIX) {
				outab(0xDD);
				if (v1 == IX) {
					outab(0x37);
				} else
				if (v1 == IY) {
					outab(0x31);
				}
			} else {
				outab(0xFD);
				if (v1 == IX) {
					outab(0x31);
				}else
				if (v1 == IY) {
					outab(0x37);
				}
			}
			if ((v1 == BC) || (v1 == DE) || (v1 == HL))
				outab((v1 << 4) + 7);
			outrb(&e2, R_SGND);
			break;
		}
		/*
		 * ld  (ix+d),bc	ld  (iy+d),bc
		 * ld  (ix+d),de	ld  (iy+d),de
		 * ld  (ix+d),hl	ld  (iy+d),hl
		 * ld  (ix+d),ix	ld  (iy+d),ix
		 * ld  (ix+d),iy	ld  (iy+d),iy
		 */
		if ((t2 == S_RX) && ((t1 == S_IDIX) || (t1 == S_IDIY))) {
			/*
			 * Only .S and .L Suffixes Allowed
			 */
			if ((sf == M_IS)  || (sf == M_IL)  ||
			    (sf == M_SIS) || (sf == M_LIL) ||
			    (sf == M_SIL) || (sf == M_LIS)) {
				aerr();
			}
			if (v2 == SP) {
				aerr();
				break;
			}
			if (t1 == S_IDIX) {
				outab(0xDD);
				if (v2 == IX) {
					outab(0x3F);
				} else
				if (v2 == IY) {
					outab(0x3E);
				}
			} else {
				outab(0xFD);
				if (v2 == IX) {
					outab(0x3E);
				} else
				if (v2 == IY) {
					outab(0x3F);
				}
			}
			if ((v2 == BC) || (v2 == DE) || (v2 == HL))
				outab((v2 << 4) + 0xf);
			outrb(&e1, R_SGND);
			break;
		}
		/*
		 * ld  be,(mn)	[be,(#mn)]
		 * ld  de,(mn)	[de,(#mn)]
		 * ld  hl,(mn)	[hl,(#mn)]
		 * ld  sp,(mn)	[sp,(#mn)]
		 * ld  ix,(mn)	[ix,(#mn)]
		 * ld  iy,(mn)	[iy,(#mn)]
		 */
		if ((t1 == S_RX) && (t2 == S_INDM)) {
			/*
			 * Only .SIS and .LIL Suffixes Allowed
			 */
			if ((sf == M_S)   || (sf == M_L)   ||
			    (sf == M_IS)  || (sf == M_IL)  ||
			    (sf == M_SIL) || (sf == M_LIS)) {
				aerr();
			}
			if (gixiy(v1) == HL) {
				outab(0x2A);
			} else {
				outab(0xED);
				outab(0x4B | (v1<<4));
			}
			glilsis(m_mode, sf, &e2);
			break;
		}
		/*
		 * ld  (mn),bc	[(#mn),bc]
		 * ld  (mn),de	[(#mn),de]
		 * ld  (mn),hl	[(#mn),hl]
		 * ld  (mn),sp	[(#mn),sp]
		 * ld  (mn),ix	[(#mn),ix]
		 * ld  (mn),iy	[(#mn),iy]
		 */
		if ((t1 == S_INDM) && (t2 == S_RX)) {
			/*
			 * Only .SIS and .LIL Suffixes Allowed
			 */
			if ((sf == M_S)   || (sf == M_L)   ||
			    (sf == M_IS)  || (sf == M_IL)  ||
			    (sf == M_SIL) || (sf == M_LIS)) {
				aerr();
			}
			if (gixiy(v2) == HL) {
				outab(0x22);
			} else {
				outab(0xED);
				outab(0x43 | (v2<<4));
			}
			glilsis(m_mode, sf, &e1);
			break;
		}
		/*
		 * ld  a,(mn)	[a,(#mn)]
		 */
		if ((t1 == S_R8) && (v1 == A) && (t2 == S_INDM)) {
			/*
			 * Only .SIS and .LIL Suffixes Allowed
			 */
			if ((sf == M_S)   || (sf == M_L)   ||
			    (sf == M_IS)  || (sf == M_IL)  ||
			    (sf == M_SIL) || (sf == M_LIS)) {
				aerr();
			}
			outab(0x3A);
			glilsis(m_mode, sf, &e2);
			break;
		}
		/*
		 * ld  (mn),a	[(#mn),a]
		 */
		if ((t1 == S_INDM) && (t2 == S_R8) && (v2 == A)) {
			/*
			 * Only .IS and .IL Suffixes Allowed
			 */
			if ((sf == M_S)   || (sf == M_L)   ||
			    (sf == M_SIS) || (sf == M_LIL) ||
			    (sf == M_SIL) || (sf == M_LIS)) {
				aerr();
			}
			outab(0x32);
			glilsis(m_mode, sf, &e1);
			break;
		}
		/*
		 * ld  (hl),r
		 * ld  (ix+d),r
		 * ld  (iy+d),r
		 */
		if ((t2 == S_R8) && (gixiy(t1) == S_IDHL)) {
			/*
			 * Only .S and .L Suffixes Allowed
			 */
			if ((sf == M_IS)  || (sf == M_IL)  ||
			    (sf == M_SIS) || (sf == M_LIL) ||
			    (sf == M_SIL) || (sf == M_LIS)) {
				aerr();
			}
			outab(0x70|v2);
			if (t1 != S_IDHL)
				outrb(&e1, R_SGND);
			break;
		}
		/*
		 * ld  (hl),n  		[(hl),#n]
		 * ld  (ix+d),n		[(ix+d),#n]
		 * ld  (iy+d),n		[(iy+d),#n]
		 */
		if ((t2 == S_IMMED) && (gixiy(t1) == S_IDHL)) {
			/*
			 * Only .S and .L Suffixes Allowed
			 */
			if ((sf == M_IS)  || (sf == M_IL)  ||
			    (sf == M_SIS) || (sf == M_LIL) ||
			    (sf == M_SIL) || (sf == M_LIS)) {
				aerr();
			}
			if ((t1 == S_IDHL) && ((e1.e_base.e_ap != NULL) || (e1.e_addr != 0)))
				aerr();
			outab(0x36);
			if (t1 != S_IDHL)
				outrb(&e1, R_SGND);
			outrb(&e2, 0);
			break;
		}
		/*
		 * ld  R,a
		 * ld  I,a
		 *
		 * ld  MB,a
		 *
		 * ld  ixl,r
		 * ld  ixh,r
		 * ld  iyl,r
		 * ld  iyh,r
		 */
		if ((t1 == S_R8X) && (t2 == S_R8)) {
			if ((v2 == H) || (v2 == L)) {
				aerr();
				break;
			}
			if (sf) {	/* No Opcode Suffixes Allowed */
				aerr();
			}
			/*
			 * ld  R,a
			 * ld  I,a
			 */
			if ((v1 == I) || (v1 == R)) {
				if (v2 == A) {
					outab(0xED);
					outab(v1);
				} else {
					aerr();
				}
				break;
			} else
			/*
			 * ld  MB,a
			 */
			if (v1 == MB) {
				if (v2 == A) {
					outab(0xED);
					outab(0x6D);
				} else {
					aerr();
				}
				break;
			} else
			/*
			 * ld  ixl,r
			 * ld  ixh,r
			 * ld  iyl,r
			 * ld  iyh,r
			 */
			{
				if ((v1 == IXH) || (v1 == IXL)) {
					outab(0xDD);
				} else {
					outab(0xFD);
				}
				if ((v1 == IXL) || (v1 == IYL)) {
					v1 = 0x08;
				} else {
					v1 = 0;
				}
				v1 += 0x60;
				outab(v1 + v2);
				break;
			}
		}
		/*
		 * ld  a,R
		 * ld  a,I
		 *
		 * ld  a,MB
		 *
		 * ld  r,ixl
		 * ld  r,ixh
		 * ld  r,iyl
		 * ld  r,iyh
		 */
		if ((t1 == S_R8) && (t2 == S_R8X)) {
			if ((v1 == H) || (v1 == L)) {
				aerr();
				break;
			}
			if (sf) {	/* No Opcode Suffixes Allowed */
				aerr();
			}
			/*
			 * ld  a,R
			 * ld  a,I
			 */
			if ((v2 == I) || (v2 == R)) {
				if (v1 == A) {
					outab(0xED);
					outab(v2|0x10);
				} else {
					aerr();
				}
				break;
			} else
			/*
			 * ld  a,MB
			 */
			if (v2 == MB) {
				if (v1 == A) {
					outab(0xED);
					outab(0x6E);
				} else {
					aerr();
				}
				break;
			} else
			/*
			 * ld  r,ixl
			 * ld  r,ixh
			 * ld  r,iyl
			 * ld  r,iyh
			 */
			{
				if ((v2 == IXH) || (v2 == IXL)) {
					outab(0xDD);
				} else {
					outab(0xFD);
				}
				if ((v2 == IXL) || (v2 == IYL)) {
					v2 = 5;
				} else {
					v2 = 4;
				}
				outab(0x40 + (v1 << 3) + v2);
				break;
			}
		}
		/*
		 * ld  ixh,ihx
		 * ld  ixh,ixl
		 * ld  ixl,ixh
		 * ld  ixl,ixl
		 * ld  iyh,iyh
		 * ld  iyh,iyl
		 * ld  iyl,iyh
		 * ld  iyl,iyl
		 */
		if ((t1 == S_R8X) && (t2 == S_R8X)) {
			if ((v1 == I) || (v1 == R) || (v1 == MB)) {
				aerr();
				break;
			}
			if ((v2 == I) || (v2 == R) || (v2 == MB)) {
				aerr();
				break;
			}
			if (sf) {	/* No Opcode Suffixes Allowed */
				aerr();
			}
			if ((v1 == IXH) || (v1 == IXL)) {
				if ((v2 == IYH) || (v2 == IYL)) {
					aerr();
					break;
				} else {
					outab(0xDD);
				}
			} else
			if ((v1 == IYH) || (v1 == IYL)) {
				if ((v2 == IXH) || (v2 == IXL)) {
					aerr();
					break;
				} else {
					outab(0xFD);
				}
			}
			if ((v1 == IXH) || (v1 == IYH)) {
				t1 = 0;
			} else {
				t1 = 8;
			}
			if ((v2 == IXH) || (v2 == IYH)) {
				t2 = 0;
			} else {
				t2 = 1;
			}
			outab(0x64 + t1 + t2);
			break;
		}
		/*
		 * ld  sp,hl
		 * ld  sp,ix
		 * ld  sp,iy
		 */
		if ((t1 == S_RX) && (v1 == SP)) {
			/*
			 * Only .S and .L Suffixes Allowed
			 */
			if ((sf == M_IS)  || (sf == M_IL)  ||
			    (sf == M_SIS) || (sf == M_LIL) ||
			    (sf == M_SIL) || (sf == M_LIS)) {
				aerr();
			}
			if ((t2 == S_RX) && (gixiy(v2) == HL)) {
				outab(0xF9);
				break;
			}
		}
		/*
		 * ld  a,(bc)
		 * ld  a,(de)
		 */
		if ((t1 == S_R8) && (v1 == A)) {
			/*
			 * Only .S and .L Suffixes Allowed
			 */
			if ((sf == M_IS)  || (sf == M_IL)  ||
			    (sf == M_SIS) || (sf == M_LIL) ||
			    (sf == M_SIL) || (sf == M_LIS)) {
				aerr();
			}
			if ((t2 == S_IDBC) || (t2 == S_IDDE)) {
				outab(0x0A | ((t2-S_INDR)<<4));
				break;
			}
		}
		/*
		 * ld  (bc),a
		 * ld  (de),a
		 */
		if ((t2 == S_R8) && (v2 == A)) {
			/*
			 * Only .S and .L Suffixes Allowed
			 */
			if ((sf == M_IS)  || (sf == M_IL)  ||
			    (sf == M_SIS) || (sf == M_LIL) ||
			    (sf == M_SIL) || (sf == M_LIS)) {
				aerr();
			}
			if ((t1 == S_IDBC) || (t1 == S_IDDE)) {
				outab(0x02 | ((t1-S_INDR)<<4));
				break;
			}
		}
		/*
		 * ld  hl,i
		 */
		if ((v1 == HL) && (v2 == I)) {
			if (sf) {	/* No Opcode Suffixes Allowed */
				aerr();
			}
			outab(0xED);
			outab(0xD7);
			break;
		}
		/*
		 * ld  i,hl
		 */
		if ((v2 == HL) && (v1 == I)) {
			if (sf) {	/* No Opcode Suffixes Allowed */
				aerr();
			}
			outab(0xED);
			outab(0xC7);
			break;
		}
		/*
		 * ld  ixh,n		ld  ixh,#n
		 * ld  ixl,n		ld  ixl,#n
		 * ld  iyh,n		ld  iyh,#n
		 * ld  iyl,n		ld  iyl,#n
		 */
		if ((t1 == S_R8X) && (t2 == S_IMMED)) {
			if (sf) {	/* No Opcode Suffixes Allowed */
				aerr();
			}
			if ((v1 == IXH) || (v1 == IXL)) {
				outab(0xDD);
			} else
			if ((v1 == IYH) || (v1 == IYL)) {
				outab(0xFD);
			}
			if ((v1 == IXH) || (v1 == IYH)) {
				outab(0x26);
			} else
			if ((v1 == IXL) || (v1 == IYL)) {
				outab(0x2E);
			}
			outrb(&e2, 0);
			break;
		}
		aerr();
		break;

	case S_EX:
		t1 = addr(&e1);
		comma(1);
		t2 = addr(&e2);
		if (t2 == S_RX) {
			v1 = (int) e1.e_addr;
			v2 = (int) e2.e_addr;
			/*
			 * ex  (sp),hl
			 * ex  (sp),ix
			 * ex  (sp),iy
			 */
			if ((t1 == S_IDSP) && (e1.e_base.e_ap == NULL) && (v1 == 0)) {
				if (gixiy(v2) == HL) {
					outab(op);
					break;
				}
			}
			/*
			 * ex  de,hl
			 */
			if (t1 == S_RX) {
				if (sf) {	/* No Opcode Suffixes Allowed */
					aerr();
				}
				if ((v1 == DE) && (v2 == HL)) {
					outab(0xEB);
					break;
				}
			}
		}
		/*
		 * ex  af,af'
		 */
		if ((t1 == S_RXX) && (t2 == S_RXX)) {
			if (sf) {	/* No Opcode Suffixes Allowed */
				aerr();
			}
			outab(0x08);
			break;
		}
		aerr();
		break;

	case S_IN:
	case S_OUT:
		if (rf == S_IN) {
			t1 = addr(&e1);
			comma(1);
			t2 = addr(&e2);
		} else {
			t2 = addr(&e2);
			comma(1);
			t1 = addr(&e1);
		}
		if (t1 == S_R8) {
			v1 = (int) e1.e_addr;
			v2 = (int)e2.e_addr;
			/*
			 * in   a,(n)	[in   a,(#n)]
			 * out  (n),a	[out  (#n),a]
			 */
			if ((v1 == A) && (t2 == S_INDM)) {
				outab(op);
				outrb(&e2, R_USGN);
				break;
			}
			/*
			 * in   r,(c)	[in   r,(bc)]
			 * out  (c),r	[out  (bc),r]
			 */
			if ((t2 == S_IDC) || (t2 == S_IDBC)) {
				outab(0xED);
				outab(((rf == S_IN) ? 0x40 : 0x41) + (v1<<3));
				break;
			}
		}
		aerr();
		break;

	case S_IN0:
	case S_OUT0:
		if (rf == S_IN0) {
			t1 = addr(&e1);
			comma(1);
			t2 = addr(&e2);
		} else {
			t2 = addr(&e2);
			comma(1);
			t1 = addr(&e1);
		}
		if (t1 == S_R8) {
			v1 = (int) e1.e_addr;
			v2 = (int) e2.e_addr;
			/*
			 * in0  r,(n)	[in0  r,(#n)]
			 * out0 (n),r	[out0 (#n),r]
			 */
			if (t2 == S_INDM) {
				outab(0xED);
				outab(op + (v1 << 3));
				outrb(&e2, R_USGN);
				break;
			}
		}
		aerr();
		break;

	case S_DEC:
	case S_INC:
		t1 = addr(&e1);
		v1 = (int) e1.e_addr;
		/*
		 * op  r
		 */
		if (t1 == S_R8) {
			if (sf) {	/* No Opcode Suffixes Allowed */
				aerr();
			}
			outab(op|(v1<<3));
			break;
		}
		/*
		 * op  (hl)
		 */
		if (t1 == S_IDHL) {
			if ((e1.e_base.e_ap != NULL) || (e1.e_addr != 0))
				aerr();
			outab(op|0x30);
			break;
		}
		/*
		 * op  (ix+d)
		 * op  (iy+d)
		 */
		if (t1 != gixiy(t1)) {
			outab(op|0x30);
			outrb(&e1, R_SGND);
			break;
		}
		/*
		 * op  bc
		 * op  de
		 * op  hl
		 * op  sp
		 * op  ix
		 * op  iy
		 */
		if (t1 == S_RX) {
			v1 = gixiy(v1);
			if (rf == S_DEC) {
				outab(0x0B|(v1<<4));
				break;
			} else {
				outab(0x03|(v1<<4));
				break;
			}
		}
		/*
		 * op  IXL
		 * op  IXH
		 * op  IYL
		 * op  IYH
		 */
		if (t1 == S_R8X) {
			v1 = (int) e1.e_addr;
			v2 = 0x20;
			if ((v1 == IXL) || (v1 == IYL))
				v2 += 8;
			if (sf) {	/* No Opcode Suffixes Allowed */
				aerr();
			}
			if ((v1 == IXH) || (v1 == IXL)) {
				outab(0xDD);
				outab(op + v2);
				break;
			} else
			if ((v1 == IYH) || (v1 == IYL)) {
				outab(0xFD);
				outab(op + v2);
				break;
			}
		}
		aerr();
		break;

	case S_DJNZ:
	case S_JR:
		/*
		 * jr  cc,e
		 */
		if (rf == S_JR && (v1 = admode(CND)) != 0) {
			if ((v1 &= 0xFF) <= 3) {
				op += (v1+1)<<3;
			} else {
				aerr();
			}
			comma(1);
		}
		/*
		 * jr  e
		 */
		expr(&e2, 0);
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

	case S_CALL:
		if ((v1 = admode(CND)) != 0) {
			/*
			 * call  cc,n
			 */
			op |= (v1&0xFF)<<3;
			comma(1);
		} else {
			/*
			 * call  n
			 */
			op = 0xCD;
		}
		expr(&e1, 0);
		outab(op);
		switch(m_mode) {
		case MM_ADL:
			switch(sf) {
			case M_IS:
				outrwm(&e1, R_Z80, 0);
				break;
			case M_IL:
			default:
				outr3b(&e1, R_ADL);
				break;
			}
			break;
		case MM_Z80:
			switch(sf) {
			case M_IL:
				outr3b(&e1, R_ADL);
				break;
			case M_IS:
			default:
				outrwm(&e1, R_Z80|R_PAGX1, 0);
				break;
			}
			break;
		default:
			break;
		}
		break;

	case S_JP:
		/*
		 * jp  cc,mn
		 */
		if ((v1 = admode(CND)) != 0) {
			op |= (v1&0xFF)<<3;
			comma(1);
		}
		/*
		 * jp  mn
		 */
		t1 = addr(&e1);
		if (t1 == S_USER) {
			if (v1) {
				outab(op);
			} else {
				outab(0xC3);
			}
			switch(m_mode) {
			case MM_ADL:
				switch(sf) {
				case M_S:
					aerr();
				case M_SIS:
					outrwm(&e1, R_Z80, 0);
					break;
				case M_L:
					aerr();
				case M_LIL:
				default:
					outr3b(&e1, R_ADL);
					break;
				}
				break;
			case MM_Z80:
				switch(sf) {
				case M_L:
					aerr();
				case M_LIL:
					outr3b(&e1, R_ADL);
					break;
				case M_S:
					aerr();
				case M_SIS:
				default:
					outrwm(&e1, R_Z80|R_PAGX1, 0);
					break;
				}
				break;
			default:
				break;
			}
			break;
		}
		/*
		 * jp  (hl)
		 * jp  (ix)
		 * jp  (iy)
		 */
		if ((t1 == S_IDHL) || (t1 == S_IDIX) || (t1 == S_IDIY)) {
			if ((e1.e_base.e_ap != NULL) || (e1.e_addr != 0)) {
				aerr();
				break;
			}
			if ((sf == M_SIS) || (sf == M_LIL)) {
				aerr();
				break;
			}
			if (needPreamble) {
				if (t1 == S_IDHL) {
					if (sf & M_L) {
						outab(0x49);
					} else {
						outab(0x52);
					}
				} else {
					if (sf & M_L) {
						outab(0x5B);
					} else {
						outab(0x40);
					}
				}
			}
 			gixiy(t1);
			outab(0xE9);
			break;
		}
		aerr();
		break;

	case S_MLT:
		t1 = addr(&e1);
		/*
		 * mlt  bc/de/hl/sp
		 */
		if ((t1 == S_RX) && ((v1 = (int) e1.e_addr) <= SP)) {
			if (sf && (v1 != SP)) {
				aerr();
			}
			outab(0xED);
			outab(op | (v1<<4));
			break;
		}
		aerr();
		break;

	case S_TST:
		/*
		 * op  (hl)
		 * op  r
		 * op  n	[#n]
		 */
		t1 = addr(&e1);
		if (t1 == S_USER)
			t1 = e1.e_mode = S_IMMED;
		if (more()) {
			/*
			 * op  a,(hl)
			 * op  a,r
			 * op  a,n	[a,#n]
			 */
			if ((t1 != S_R8) || (e1.e_addr != A))
				aerr();
			comma(1);
			clrexpr(&e1);
			t1 = addr(&e1);
			if (t1 == S_USER)
				t1 = e1.e_mode = S_IMMED;
		}
		/*
		 * tst  (hl)
		 */
		if (t1 == S_IDHL) {
			outab(0xED);
			outab(0x34);
			break;
		}
		/*
		 * tst  r
		 */
		if (t1 == S_R8) {
			if (sf) {	/* No Opcode Suffixes Allowed */
				aerr();
			}
			outab(0xED);
			outab(op | ((int) (e1.e_addr<<3)));
			break;
		}
		/*
		 * tst  n	[tst  #n]
		 */
		if (t1 == S_IMMED) {
			if (sf) {	/* No Opcode Suffixes Allowed */
				aerr();
			}
			outab(0xED);
			outab(0x64);
			outrb(&e1, 0);
			break;
		}
		aerr();
		break;

	case S_TSTIO:
		t1 = addr(&e1);
		if (t1 == S_USER)
			t1 = e1.e_mode = S_IMMED;
		/*
		 * tstio  n		[tstio  #n]
		 */
		if (t1 == S_IMMED) {
			outab(0xED);
			outab(op);
			outrb(&e1, 0);
			break;
		}
		aerr();
		break;

	case S_LEA:
		t1 = addr(&e1);
		v1 = (int) e1.e_addr;
		comma(1);
		t2 = addr(&e2);
		v2 = (int) e2.e_addr;
		if ((t1 == S_RX) && (v1 != SP) && (t2 == S_RX) && (v2==IX || v2==IY)) {
			if (more()) {
				t2 = e2.e_mode = S_INDR + v2;
				clrexpr(&e2);
				expr(&e2, 0);
			} else {
				while (getnb()) { ; }
				aerr();
			}
			outab(0xED);
			/*
			 * op  ix,ix+d
			 * op  ix,iy+d
			 */
			if (v1 == IX) {
				if (t2 == S_IDIX) {
					outab(0x32);
				} else {
					outab(0x54);
				}
			} else
			/*
			 * op  iy,ix+d
			 * op  iy,iy+d
			 */
			if (v1 == IY) {
				if (t2 == S_IDIX) {
					outab(0x55);
				} else {
					outab(0x33);
				}
			} else {
				if (t2 == S_IDIY) {
					/*
					 * op  bc,iy+d
					 * op  de,iy+d
					 * op  hl,iy+d
					 */
					outab((v1 << 4) + 3);
				} else {
					/*
					 * op  bc,ix+d
					 * op  de,ix+d
					 * op  hl,ix+d
					 */
					outab((v1 << 4) + 2);
				}
			}
			outrb(&e2, R_SGND);
			break;
		}
		aerr();
		break;

	case S_PEA:
		t1 = addr(&e1);
		v1 = (int) e1.e_addr;
		/*
		 * pea  ix+d
		 * pea  iy+d
		 */
		if ((t1 == S_RX) && (v1==IX || v1==IY)) {
			if (more()) {
				t1 = e1.e_mode = S_INDR + v1;
				clrexpr(&e1);
				expr(&e1, 0);
			} else {
				while (getnb()) { ; }
				aerr();
			}
			outab(0xED);
			if (t1 == S_IDIY)
				++op;
			outab(op);
			outrb(&e1, R_SGND);
			break;
		}
		aerr();
		break;

	case S_AMOD:
		opcycles = OPCY_AMOD;
		if (more()) {
			/*
			 * .adl	n
			 * .z80 n
			 */
			expr(&e1, 0);
			abscheck(&e1);
			if (op == MM_ADL) {
				m_mode = e1.e_addr ? MM_ADL : MM_Z80;
			} else {
				m_mode = e1.e_addr ? MM_Z80 : MM_ADL;
			}
		} else {
			/*
			 * .adl
			 * .z80
			 */
			m_mode = op;
		}
		lmode = SLIST;
		break;

	default:
		opcycles = OPCY_ERR;
		err('o');
		break;
	}

	if (opcycles == OPCY_NONE) {
		of = 0;
		opcycles = ez80pg1[cb[0] & 0xFF];
		while ((opcycles & OPCY_NONE) && (opcycles & OPCY_MASK)) {
			switch (opcycles) {
			case PF:	/* 40 / 49 / 52 / 5B */
				of = 1;
				opcycles = ez80pg1[cb[1] & 0xFF];
				break;
			case P2:	/* CB xx	*/
			case P3:	/* DD xx	*/
			case P4:	/* ED xx	*/
			case P5:	/* FD xx	*/
				opcycles = ez80Page[opcycles & OPCY_MASK][cb[of + 1] & 0xFF];
				break;
			case P6:	/* DD CB -- xx	*/
			case P7:	/* FD CB -- xx	*/
				opcycles = ez80Page[opcycles & OPCY_MASK][cb[of + 3] & 0xFF];
				break;
			default:
				opcycles = OPCY_NONE;
				break;
			}
		}
		/*
		 * Cycle Adjustments
		 */
		if (opcycles != OPCY_NONE) {
			opcycles += of;

			opc1 = cb[0] & 0xFF;
			opc2 = cb[1] & 0xFF;
			opc3 = cb[2] & 0xFF;

			switch(opc1) {
			case 0x40:
				switch(rf) {
				case S_CALL:
					switch(opc2) {
					case 0xCD:		opcycles += 1;	break;
					default:		opcycles += 0;	break;
					}					break;
				case S_EX:					break;
				case S_JP:					break;
				case S_LD:
					switch(opc2) {
					case 0xDD:
					case 0xFD:
						switch(opc3) {
						case 0x21:	opcycles += 1;	break;

						case 0x22:
						case 0x2A:	opcycles += 2;	break;
						default:			break;
						}				break;
					}					break;
				default:					break;
				}						break;

			case 0x49:
				switch(rf) {
				case S_CALL:
					switch(opc2) {
					case 0xCD:		opcycles += 2;	break;
					default:		opcycles += 1;	break;
					}					break;
				case S_EX:	opcycles += 2;			break;
				case S_JP:					break;
				case S_LD:
					switch(opc2) {
					case 0x32:		opcycles += 1;	break;

					case 0xED:
						switch(opc3) {
						case 0x07:
						case 0x0F:
						case 0x17:
						case 0x1F:
						case 0x27:
						case 0x2F:
						case 0x31:
						case 0x37:
						case 0x3E:
						case 0x3F:	opcycles += 1;	break;
						default:			break;
						}				break;

					case 0xDD:
					case 0xFD:
						switch(opc3) {
						case 0x07:
						case 0x0F:
						case 0x17:
						case 0x1F:
						case 0x27:
						case 0x2F:
						case 0x31:
						case 0x37:
						case 0x3E:
						case 0x3F:	opcycles += 1;	break;

						case 0x22:	opcycles += 2;	break;
						default:			break;
						}				break;
					}					break;
				case S_PEA:
				case S_PUSH:
				case S_RET:
				case S_RST:			opcycles += 1;	break;
				case S_INH2:
					switch(op) {
					case 0x45:
					case 0x4D:		opcycles += 3;	break;
					default:				break;
					}					break;
				default:					break;
				}						break;

			case 0x52:
				switch(rf) {
				case S_CALL:
					switch(opc2) {
					case 0xCD:		opcycles += 2;	break;
					default:		opcycles += 1;	break;
					}					break;
				case S_EX:					break;
				case S_JP:					break;
				case S_LD:
					switch(opc2) {
					case 0x32:		opcycles += 1;	break;

					case 0xDD:
					case 0xFD:
						switch(opc3) {
						case 0x07:
						case 0x0F:
						case 0x17:
						case 0x1F:
						case 0x27:
						case 0x2F:
						case 0x31:
						case 0x37:
						case 0x3E:
						case 0x3F:	opcycles += 1;	break;

						case 0x22:	opcycles += 2;	break;
						default:			break;
						}				break;
					}					break;
				case S_RST:			opcycles += 2;	break;
				default:					break;
				}						break;

			case 0x5B:
				switch(rf) {
				case S_CALL:
					switch(opc2) {
					case 0xCD:		opcycles += 3;	break;
					default:		opcycles += 2;	break;
					}					break;
				case S_EX:					break;
				case S_JP:
					switch(opc2) {
					case 0xDD:
					case 0xED:
					case 0xFD:				break;
					default:		opcycles += 1;	break;
					}					break;
				case S_LD:
					switch(opc2) {
					case 0x01:
					case 0x11:
					case 0x21:
					case 0x32:
					case 0x3A:		opcycles += 1;	break;

					case 0x22:
					case 0x2A:
					case 0x31:		opcycles += 2;	break;

					case 0xED:
						switch(opc3) {
						case 0x7B:	opcycles += 1;	break;

						case 0x43:
						case 0x4B:
						case 0x53:
						case 0x5B:
						case 0x73:	opcycles += 2;	break;
						default:			break;
						}				break;

					case 0xDD:
					case 0xFD:
						switch(opc3) {
						case 0x21:	opcycles += 1;	break;

						case 0x22:
						case 0x2A:	opcycles += 2;	break;
						default:			break;
						}				break;
					}					break;
				case S_RET:			opcycles += 1;	break;
				case S_INH2:
					switch(op) {
					case 0x45:
					case 0x4D:		opcycles += 3;	break;
					default:				break;
					}					break;
				default:					break;
				}						break;

			default:
				if (m_mode != MM_ADL)				break;

				switch(rf) {
				case S_CALL:
					switch(opc1) {
					case 0xCD:		opcycles += 2;	break;
					default:		opcycles += 1;	break;
					}					break;
				case S_EX:			opcycles += 2;	break;
				case S_JP:
					switch(opc1) {
					case 0xDD:
					case 0xED:
					case 0xFD:				break;
					default:		opcycles += 1;	break;
					}					break;
				case S_LD:
					switch(opc1) {
					case 0x01:
					case 0x11:
					case 0x21:
					case 0x32:
					case 0x3A:		opcycles += 1;	break;

					case 0x22:
					case 0x2A:
					case 0x31:		opcycles += 2;	break;

					case 0xED:
						switch(opc2) {
						case 0x07:
						case 0x0F:
						case 0x17:
						case 0x1F:
						case 0x27:
						case 0x2F:
						case 0x31:
						case 0x37:
						case 0x3E:
						case 0x3F:
						case 0x7B:	opcycles += 1;	break;

						case 0x43:
						case 0x4B:
						case 0x53:
						case 0x5B:
						case 0x73:	opcycles += 2;	break;
						default:			break;
						}				break;

					case 0xDD:
					case 0xFD:
						switch(opc2) {
						case 0x07:
						case 0x0F:
						case 0x17:
						case 0x1F:
						case 0x27:
						case 0x2F:
						case 0x21:
						case 0x31:
						case 0x37:
						case 0x3E:
						case 0x3F:	opcycles += 1;	break;

						case 0x22:
						case 0x2A:	opcycles += 2;	break;
						default:			break;
						}				break;
					}					break;
				case S_PEA:
				case S_PUSH:
				case S_RET:
				case S_RST:			opcycles += 1;	break;
				case S_INH2:
					switch(op) {
					case 0x45:
					case 0x4D:		opcycles += 1;	break;
					default:				break;
					}					break;
				default:					break;
				}						break;
			}
		}
	}
}

/*
 * general addressing evaluation
 * return(0) if general addressing mode output, else
 * return(esp->e_mode)
 */
int
genop(pop, op, esp, f)
int pop, op;
struct expr *esp;
int f;
{
	register int t1;
	if ((t1 = esp->e_mode) == S_R8) {
		if (pop)
			outab(pop);
		outab(op|esp->e_addr);
		return(0);
	}
	if (t1 == S_IDHL) {
		if (pop)
			outab(pop);
		outab(op|0x06);
		return(0);
	}
	if (gixiy(t1) == S_IDHL) {
		if (pop) {
			outab(pop);
			outrb(esp, R_SGND);
			outab(op|0x06);
		} else {
			outab(op|0x06);
			outrb(esp, R_SGND);
		}
		return(0);
	}
	if ((t1 == S_IMMED) && (f)) {
		if (pop)
			outab(pop);
		outab(op|0x46);
		outrb(esp, 0);
		return(0);
	}
	return(t1);
}

/*
 * general addressing evaluation with merge
 * return(0) if general addressing mode output, else
 * return(esp->e_mode)
 */
int
genopm(pop, op, esm, esp, f)
int pop, op;
struct expr *esm, *esp;
int f;
{
	register int t1;
	if ((t1 = esp->e_mode) == S_R8) {
		if (pop)
			outab(pop);
		outrbm(esm, R_3BIT|R_MBRO, op|esp->e_addr);
		return(0);
	}
	if (t1 == S_IDHL) {
		if (pop)
			outab(pop);
		outrbm(esm, R_3BIT|R_MBRO, op|0x06);
		return(0);
	}
	if (gixiy(t1) == S_IDHL) {
		if (pop) {
			outab(pop);
			outrb(esp, R_SGND);
			outrbm(esm, R_3BIT|R_MBRO, op|0x06);
		} else {
			outrbm(esm, R_3BIT|R_MBRO, op|0x06);
			outrb(esp, R_SGND);
		}
		return(0);
	}
	if ((t1 == S_IMMED) && (f)) {
		if (pop)
			outab(pop);
		outrbm(esm, R_3BIT|R_MBRO, op|0x46);
		outrb(esp, 0);
		return(0);
	}
	return(t1);
}

/*
 * IX and IY prebyte check
 */
int
gixiy(v)
int v;
{
	if (v == IX) {
		v = HL;
		outab(0xDD);
	} else if (v == IY) {
		v = HL;
		outab(0xFD);
	} else if (v == S_IDIX) {
		v = S_IDHL;
		outab(0xDD);
	} else if (v == S_IDIY) {
		v = S_IDHL;
		outab(0xFD);
	}
	return(v);
}

/*
 * .IL/.LIL and .IS/.SIS checks
 */
VOID
glilsis(mode, sfx, esp)
int mode, sfx;
struct expr *esp;
{
	switch(mode) {
	case MM_ADL:
		switch(sfx) {
		case M_IS:
		case M_SIS:
			outrw(esp, 0);
			break;
		case M_IL:
		case M_LIL:
			aerr();
			break;
		default:
			outr3b(esp, R_ADL);
			break;
		}
		break;
	case MM_Z80:
		switch(sfx) {
		case M_IS:
		case M_SIS:
			aerr();
			break;
		case M_IL:
		case M_LIL:
			outr3b(esp, R_ADL);
			break;
		default:
			outrwm(esp, R_Z80|R_PAGX1, 0);
			break;
		}
		break;
	default:
		break;
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
	hilo = 0;

	exprmasks(3);
	m_mode = MM_Z80;
}


