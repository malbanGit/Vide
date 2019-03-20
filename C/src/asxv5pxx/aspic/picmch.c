/* picmch.c */

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

/*
 * PIC18Fxxx Extended Instructions
 * added by Mengjin Su.
 * msu at micron dot com
 */

#include "asxxxx.h"
#include "pic.h"

char	*cpu	= "Microchip Technology Inc.,  [User Defined]";
char	*dsft	= "asm";

static char buff[NINPUT];
static char pic_cpu[80];
static int  pic_type;
static int  pic_bytes;
static int  pic_goto;
static a_uint pic_fsr;
static struct badram *br;

/*
 * Opcode Cycle Definitions
 */
#define	OPCY_SDP	((char) (0xFF))
#define	OPCY_ERR	((char) (0xFE))

/*	OPCY_NONE	((char) (0x80))	*/
/*	OPCY_MASK	((char) (0x7F))	*/

#define	OPCY_SBITS	((char) (0xFD))
#define	OPCY_PMAXR	((char) (0xFC))
#define	OPCY_PBADR	((char) (0xFB))
#define	OPCY_PTYPE	((char) (0xFA))
#define	OPCY_PBITS	((char) (0xF9))
#define	OPCY_PFIX	((char) (0xF8))
#define	OPCY_SDMM	((char) (0xF7))

#define	UN	((char) (OPCY_NONE | 0x00))
#define	P2	((char) (OPCY_NONE | 0x01))


/*
 * Process machine ops.
 */
VOID
machine(mp)
struct mne *mp;
{
	int c, d;
	a_uint op;
	char *cp, *p;
	char id[NINPUT];
	char picmne[NINPUT];
	struct CpuDef *cd;
	struct CpuFix *cf;
	struct badram *brp;
	struct sym *sp;
	struct expr e1;
	struct expr e2;

	op = mp->m_valu;
	switch (mp->m_type) {

	case S_BITS:
		if (pic_bytes == 0) {
			pic_bytes = (int) op;
			exprmasks(pic_bytes);
		} else
		if (pic_bytes != (int) op) {
			err('m');
		}
		opcycles = OPCY_SBITS;
		lmode = SLIST;
		break;

	case X_PMAXR:		/*	.maxram		valu	*/
		opcycles = OPCY_PMAXR;
		lmode = SLIST;
		clrexpr(&e1);
		expr(&e1, 0);
		if (pass == 1) {
			brp = (struct badram *) new (sizeof(struct badram));
			if (br == NULL) {
				brp->b_badram = NULL;
			} else {
				brp->b_badram = br;
			}
			br = brp;
			br->b_lo = e1.e_addr;
			br->b_hi = ~((a_uint) 0);
			if (is_abs(&e1) == 0) {
				err('e');
			}
		}
		if (more()) {
			err('e');
			while (getnb()) ;
		}
		break;

	case X_PBADR:		/*	.badram		valu [,	lovalu:hivalu]	*/
		opcycles = OPCY_PBADR;
		lmode = SLIST;
		do {
			clrexpr(&e1);
			expr(&e1, 0);
			if (pass == 1) {
				brp = (struct badram *) new (sizeof(struct badram));
				if (br == NULL) {
					brp->b_badram = NULL;
				} else {
					brp->b_badram = br;
				}
				br = brp;
				br->b_lo = e1.e_addr;
				br->b_hi = e1.e_addr;
				if (is_abs(&e1) == 0) {
					err('e');
				}
			}
			if ((c = getnb()) == ':') {
				clrexpr(&e2);
				expr(&e2, 0);
				if (pass == 1) {
					br->b_hi = e2.e_addr;
					if (is_abs(&e2) == 0) {
						err('e');
					}
				}
			} else {
				unget(c);
			}
		} while (getnb() == ',');
		break;

	case X_PTYPE:
		opcycles = OPCY_PTYPE;
		lmode = SLIST;
		/*
		 * Append CPU Type to PIC_CPU
		 */
		if (more()) {
			cp = p = id;
			if ((d = getnb()) == '^') {
				d = get();
			}
			while ((c = get()) != d) {
				if (c == '\0') {
					qerr();
				}
				if (p < &id[sizeof(id)-1]) {
					*p++ = c;
				} else {
					break;
				}
			}
			*p = 0;
		} else {
			cp = "_PIC_Not_Selected";
		}
		strcpy(pic_cpu, cp);

		sprintf(id, "__%s", pic_cpu + 1);
		sp = lookup(id);
		if (sp->s_type != S_NEW && (sp->s_flag & S_ASG) == 0) {
			err('m');
		}
		sp->s_type = S_USER;
		sp->s_addr = 1;
		sp->s_flag |= S_ASG;

		sprintf(buff, "%s,  %s", PIC_CPU, pic_cpu);
		cpu = buff;
		break;

	case X_PBITS:
		opcycles = OPCY_PBITS;
		lmode = SLIST;
		pic_type = (int) op;
		cd = picDef;
		while (cd->id) {
			mp = mlookup(cd->id);
			if (mp) {
				mp->m_valu = cd->opcode[(int) op];
			} else
			if (pass == 0) {
				printf("?ASPIC-Internal-Error-<picpst.c: mne[]/picDef[]>\n");
			}
			cd++;
		}
		/*
		 * Load Cpu Addressing
		 */
		switch(op) {
		default:
		case X_NOPIC:
		case X_12BIT:
		case X_14BIT:
		case X_16BIT:
			exprmasks(2);
			/* Set "CSEG" Characteristics */
			/* To 2-bytes per PC Increment */
			mp = mlookup("CSEG");
			mp->m_valu = A_CSEG|A_2BYTE;
			/* Set _CODE Area Characteristics */
			area[0].a_flag = A_CSEG|A_2BYTE|A_BNK;
			break;
		case X_20BIT:
			exprmasks(4);
			/* Set "CSEG" Characteristics */
			/* To 1-byte per PC Increment */
			mp = mlookup("CSEG");
			mp->m_valu = A_CSEG|A_1BYTE;
			/* Set _CODE Area Characteristics */
			area[0].a_flag = A_CSEG|A_1BYTE|A_BNK;
			break;
		}
		/*
		 * Load Known Cpu Fixes
		 */
		cf = picFix;
		while (cf->picid) {
			if (symeq(pic_cpu, cf->picid,  1)) {
				mp = mlookup(cf->picmne);
				if (mp) {
					mp->m_valu = cf->opcode;
				} else
				if (pass == 0) {
					printf("?ASPIC-Internal-Error-<picpst.c: mne[]/picFix[]>\n");
				}
			}
			cf++;
		}
		if (pic_bytes == 0) {
			pic_bytes = (int) a_bytes;
		} else
		if (pic_bytes != (int) a_bytes) {
			err('m');
		}
		break;

	case X_PFIX:
		opcycles = OPCY_PFIX;
		lmode = SLIST;
		/*
		 * Get the CPU type
		 */
		if (!more()) {
			qerr();
		}
		p = id;
		if ((d = getnb()) == '^') {
			d = get();
		}
		while ((c = get()) != d) {
			if (c == '\0') {
				qerr();
			}
			if (p < &id[sizeof(id)-1]) {
				*p++ = c;
			} else {
				break;
			}
		}
		*p = 0;
		/*
		 * Get the mnemonic
		 */
		comma(1);
		if (!more()) {
			qerr();
		}
		p = picmne;
		if ((d = getnb()) == '^') {
			d = get();
		}
		while ((c = get()) != d) {
			if (c == '\0') {
				qerr();
			}
			if (p < &picmne[sizeof(picmne)-1]) {
				*p++ = c;
			} else {
				break;
			}
		}
		*p = 0;
		/*
		 * Get the new opcode value
		 */
		comma(1);
		if (!more()) {
			qerr();
		}
		op = absexpr();
		/*
		 * Change Opcode Value
		 */
		if (symeq(pic_cpu, id,  1)) {
			mp = mlookup(picmne);
			if (mp) {
				mp->m_valu = op;
			} else {
				err('u');
			}
		} else {
			err('u');
		}
		lmode = SLIST;
		break;

	case X_PGOTO:
		if (more()) {
			pic_goto = absexpr();
		} else {
			pic_goto = 1;
		}
		break;

	default:
		/*
		 * Process According to CPU Type
		 */
		switch(pic_type) {
		case X_NOPIC:					break;
		case X_12BIT:		pic12bit(mp);		break;
		case X_14BIT:		pic14bit(mp);		break;
		case X_16BIT:		pic16bit(mp);		break;
		case X_20BIT:		pic20bit(mp);		break;
		default:					break;
		}
		break;
	}
}


/*
 * PIC12BIT CPU Type
 */
VOID
pic12bit(mp)
struct mne *mp;
{
	a_uint op;
	int c;
	int t1, t2;
	int r_mode;
	struct expr e1, e2;
	char id[NINPUT];
	struct area *espa;

	clrexpr(&e1);
	clrexpr(&e2);

	op = mp->m_valu;
	if (op == ~0) {			/* Undefined Instructions */
		err('o');
		op = 0;
	}
	switch (mp->m_type) {
	case S_SDMM:
		opcycles = OPCY_SDMM;
		lmode = SLIST;
		espa = NULL;
		if (more()) {
			expr(&e1, 0);
			abscheck(&e1);
			if (e1.e_flag == 0 && e1.e_base.e_ap == NULL) {
				if (e1.e_addr & 0x1F) {
					err('b');
				}
			}
			e1.e_addr &= ~((a_uint) 0x1F);
			if ((c = getnb()) == ',') {
				getid(id, -1);
				espa = alookup(id);
				if (espa == NULL) {
					err('u');
				}
			} else {
				unget(c);
			}
			pic_fsr = e1.e_addr;
		} else {
			pic_fsr = 0;
		}
		if (espa) {
			outdp(espa, &e1, 0);
		} else {
			outdp(dot.s_area, &e1, 0);
		}
		break;

	case S_FW:			/* inst f,d */
		t1 = addr(&e1);		/* f */
		if ((t1 != S_DIR) && (t1 != S_EXT)) {
			aerr();
		} else
		if (mchramchk(&e1)) {
			aerr();
		}
		comma(1);
		t2 = addr(&e2);		/* d */
		if (t2 == S_WREG) {
			e2.e_addr = 0;
		} else
		if (t2 == S_FREG) {
			e2.e_addr = 1;
		} else {
			abscheck(&e2);
			if (e2.e_addr & ~((a_uint) 0x01)) {
				aerr();
				e2.e_addr &= 0x01;
			}
			if (t2 == S_DIR) {
				aerr();
			}
		}
		if (is_abs(&e1)) {
			mch12fsr(&e1);
			r_mode = R_5BIT;
		} else {
			r_mode = R_PAGN | R_5BIT;
		}
		outrwm(&e1, r_mode, op + (e2.e_addr << 5));
		break;

	case S_CLRF:			/* clrf */
	case S_F:			/* inst f */
		t1 = addr(&e1);		/* f */
		if ((t1 != S_DIR) && (t1 != S_EXT)) {
			aerr();
		} else
		if (mchramchk(&e1)) {
			aerr();
		}
		if (is_abs(&e1)) {
			mch12fsr(&e1);
			r_mode = R_5BIT;
		} else {
			r_mode = R_PAGN | R_5BIT;
		}
		outrwm(&e1, r_mode, op);
		break;

	case S_FBIT:			/* inst f,b */
		t1 = addr(&e1);		/* f */
		if ((t1 != S_DIR) && (t1 != S_EXT)) {
			aerr();
		} else
		if (mchramchk(&e1)) {
			aerr();
		}
		comma(1);
		t2 = addr(&e2);		/* b */
		if ((t2 != S_IMMED) && (t2 != S_EXT)) {
			aerr();
		}
		abscheck(&e2);
		if (e2.e_addr & ~((a_uint) 0x07)) {
			aerr();
			e2.e_addr &= 0x07;
		}
		if (is_abs(&e1)) {
			mch12fsr(&e1);
			r_mode = R_5BIT;
		} else {
			r_mode = R_PAGN | R_5BIT;
		}
		outrwm(&e1, r_mode, op + (e2.e_addr << 5));
		break;

	case S_LIT:			/* inst k */
		t1 = addr(&e1);		/* k */
		if ((t1 != S_IMMED) && (t1 != S_EXT)) {
			aerr();
		}
		outrwm(&e1, R_8BIT, op);
		break;

	case S_CALL:			/* inst k */
		t1 = addr(&e1);		/* k */
		if (t1 != S_EXT) {
			aerr();
		}
		outrwm(&e1, R_8BIT, op);
		break;

	case S_GOTO:			/* inst k */
		t1 = addr(&e1);		/* k */
		if (t1 != S_EXT) {
			aerr();
		}
		outrwm(&e1, R_9BIT, op);
		break;

	case S_CLRW:			/* clrw */
	case S_INH:			/* inst */
		outaw(op);
		break;

	case S_TRIS:			/* inst [k] */
		t1 = addr(&e1);		/* k */
		if ((t1 != S_IMMED) && (t1 != S_EXT)) {
			aerr();
		}
		abscheck(&e1);
		if (e1.e_addr != 6) {
			aerr();
			e1.e_addr = 6;
		}
		outaw(op + e1.e_addr);
		break;

	default:
		opcycles = OPCY_ERR;
		err('o');
		break;
	}

	if (opcycles == OPCY_NONE) {
		switch(cb[0] & 0x000F) {
		case 0x02:
		case 0x03:
			if ((cb[1] & 0xC0) == 0xC0) {
				opcycles = 2;
			} else {
				opcycles = 1;
			}			break;
		case 0x06:
		case 0x07:
		case 0x08:
		case 0x09:
		case 0x0A:
		case 0x0B:	opcycles = 2;	break;
		default:	opcycles = 1;	break;
		}
	}
}

/*
 * Select Register File Map
 */
VOID
mch12fsr(esp)
struct expr *esp;
{
	if ((esp->e_addr & ~((a_uint) 0x1F)) != pic_fsr) {
		aerr();
	}
}


/*
 * PIC14BIT CPU Type
 */
VOID
pic14bit(mp)
struct mne *mp;
{
	a_uint op;
	int c;
	int t1, t2;
	int r_mode;
	struct expr e1, e2;
	char id[NINPUT];
	struct area *espa;

	clrexpr(&e1);
	clrexpr(&e2);

	op = mp->m_valu;
	if (op == ~0) {			/* Undefined Instructions */
		err('o');
		op = 0;
	}
	switch (mp->m_type) {
	case S_SDMM:
		opcycles = OPCY_SDMM;
		lmode = SLIST;
		espa = NULL;
		if (more()) {
			expr(&e1, 0);
			abscheck(&e1);
			if (e1.e_flag == 0 && e1.e_base.e_ap == NULL) {
				if (e1.e_addr & 0x7F) {
					err('b');
				}
			}
			e1.e_addr &= ~((a_uint) 0x7F);
			if ((c = getnb()) == ',') {
				getid(id, -1);
				espa = alookup(id);
				if (espa == NULL) {
					err('u');
				}
			} else {
				unget(c);
			}
			pic_fsr = e1.e_addr;
		} else {
			pic_fsr = 0;
		}
		if (espa) {
			outdp(espa, &e1, 0);
		} else {
			outdp(dot.s_area, &e1, 0);
		}
		break;

	case S_FW:			/* inst f,d */
		t1 = addr(&e1);		/* f */
		if ((t1 != S_DIR) && (t1 != S_EXT)) {
			aerr();
		} else
		if (mchramchk(&e1)) {
			aerr();
		}
		comma(1);
		t2 = addr(&e2);		/* d */
		if (t2 == S_WREG) {
			e2.e_addr = 0;
		} else
		if (t2 == S_FREG) {
			e2.e_addr = 1;
		} else {
			abscheck(&e2);
			if (e2.e_addr & ~((a_uint) 0x01)) {
				aerr();
				e2.e_addr &= 0x01;
			}
			if (t2 == S_DIR) {
				aerr();
			}
		}
		if (is_abs(&e1)) {
			mch14fsr(&e1);
			r_mode = R_7BIT;
		} else {
			r_mode = R_PAGN | R_7BIT;
		}
		outrwm(&e1, r_mode, op + (e2.e_addr << 7));
		break;

	case S_CLRF:			/* clrf */
	case S_F:			/* inst f */
		t1 = addr(&e1);		/* f */
		if ((t1 != S_DIR) && (t1 != S_EXT)) {
			aerr();
		} else
		if (mchramchk(&e1)) {
			aerr();
		}
		if (is_abs(&e1)) {
			mch14fsr(&e1);
			r_mode = R_7BIT;
		} else {
			r_mode = R_PAGN | R_7BIT;
		}
		outrwm(&e1, r_mode, op);
		break;

	case S_FBIT:			/* inst f,b */
		t1 = addr(&e1);		/* f */
		if ((t1 != S_DIR) && (t1 != S_EXT)) {
			aerr();
		} else
		if (mchramchk(&e1)) {
			aerr();
		}
		comma(1);
		t2 = addr(&e2);		/* b */
		if ((t2 != S_IMMED) && (t2 != S_EXT)) {
			aerr();
		}
		abscheck(&e2);
		if (e2.e_addr & ~((a_uint) 0x07)) {
			aerr();
			e2.e_addr &= 0x07;
		}
		if (is_abs(&e1)) {
			mch14fsr(&e1);
			r_mode = R_7BIT;
		} else {
			r_mode = R_PAGN | R_7BIT;
		}
		outrwm(&e1, r_mode, op + (e2.e_addr << 7));
		break;

	case S_LIT:			/* inst k */
		t1 = addr(&e1);		/* k */
		if ((t1 != S_IMMED) && (t1 != S_EXT)) {
			aerr();
		}
		outrwm(&e1, R_8BIT, op);
		break;

	case S_CALL:			/* inst k */
	case S_GOTO:			/* inst k */
		t1 = addr(&e1);		/* k */
		if (t1 != S_EXT) {
			aerr();
		}
		outrwm(&e1, R_11BIT, op);
		break;

	case S_RET:			/* return, retfie */
	case S_CLRW:			/* clrw */
	case S_INH:			/* inst */
		outaw(op);
		break;

	case S_TRIS:			/* inst [k] */
		t1 = addr(&e1);	/* k */
		if ((t1 != S_IMMED) && (t1 != S_EXT)) {
			aerr();
		}
		abscheck(&e1);
		if ((e1.e_addr < 5) || (e1.e_addr > 7)) {
			aerr();
		}
		outaw(op + (e1.e_addr & 0x07));
		break;

	default:
		opcycles = OPCY_ERR;
		err('o');
		break;
	}

	if (opcycles == OPCY_NONE) {
		switch((cb[0] >> 2) & 0x000F) {
		case 0x02:
		case 0x03:
			if ((cb[0] & 0x03) == 0x03) {
				opcycles = 2;
			} else {
				opcycles = 1;
			}			break;
		case 0x06:
		case 0x07:
		case 0x08:
		case 0x09:
		case 0x0A:
		case 0x0B:
		case 0x0D:	opcycles = 2;	break;
		default:	opcycles = 1;
			if ((cb[0] == 0) &&
			   ((cb[1] == 0x08) || (cb[1] == 0x09))) {
				opcycles = 2;
			}			break;
		}
	}
}


/*
 * Select Register File Map
 */
VOID
mch14fsr(esp)
struct expr *esp;
{
	if ((esp->e_addr & ~((a_uint) 0x7F)) != pic_fsr) {
		aerr();
	}
}


/*
 * pic16 Cycle Count
 *
 *	opcycles = p16pgx[opcode]
 */
static char  p16pg1[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/  P2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*10*/   1, 1, 1, 1, 1, 1, 2, 2, 1, 1, 1, 1, 1, 1, 2, 2,
/*20*/   1, 1, 1, 1, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1,
/*30*/   2, 2, 2, 2, 1,UN,UN,UN, 1, 1, 1, 1, 1, 1, 1, 1,
/*40*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*50*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*60*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*70*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*80*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*90*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*A0*/   1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 3, 2, 2, 2, 2,
/*B0*/   1, 1, 1, 1, 1, 1, 2, 2, 1,UN, 1, 1, 1,UN,UN,UN,
/*C0*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*D0*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*E0*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*F0*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
};

static char  p16pg2[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/   1,UN, 2, 1, 1, 2,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*10*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*20*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*30*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*40*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*50*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*60*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*70*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*80*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*90*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*A0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*B0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*C0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*D0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*E0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*F0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN
};

static char *P16Page[2] = {
    p16pg1, p16pg2
};


/*
 * PIC16BIT CPU Type
 */
VOID
pic16bit(mp)
struct mne *mp;
{
	a_uint op;
	int c;
	int t1, t2, t3;
	int r_mode;
	struct expr e1, e2, e3;
	char id[NINPUT];
	struct area *espa;

	clrexpr(&e1);
	clrexpr(&e2);
	clrexpr(&e3);

	op = mp->m_valu;
	if (op == ~0) {			/* Undefined Instructions */
		err('o');
		op = 0;
	}
	switch (mp->m_type) {
	case S_SDMM:
		opcycles = OPCY_SDMM;
		lmode = SLIST;
		espa = NULL;
		if (more()) {
			expr(&e1, 0);
			if (e1.e_flag == 0 && e1.e_base.e_ap == NULL) {
				if (e1.e_addr & 0xFF) {
					err('b');
				}
			}
			e1.e_addr &= ~((a_uint) 0xFF);
			if ((c = getnb()) == ',') {
				getid(id, -1);
				espa = alookup(id);
				if (espa == NULL) {
					err('u');
				}
			} else {
				unget(c);
			}
			pic_fsr = e1.e_addr;
		} else {
			pic_fsr = 0;
		}
		if (espa) {
			outdp(espa, &e1, 0);
		} else {
			outdp(dot.s_area, &e1, 0);
		}
		break;

	case S_DAW:			/* daw  f,s */
	case S_CLRF:			/* clrf f,s */
	case S_SETF:			/* setf f,s */
	case S_FW:			/* inst f,d */
		t1 = addr(&e1);		/* f */
		if ((t1 != S_DIR) && (t1 != S_EXT)) {
			aerr();
		} else
		if (mchramchk(&e1)) {
			aerr();
		}
		comma(1);
		t2 = addr(&e2);		/* d/s */
		if (t2 == S_WREG) {
			e2.e_addr = 0;
		} else
		if (t2 == S_FREG) {
			e2.e_addr = 1;
		} else {
			abscheck(&e2);
			if (e2.e_addr & ~((a_uint) 0x01)) {
				aerr();
				e2.e_addr &= 0x01;
			}
			if (t2 == S_DIR) {
				aerr();
			}
		}
		if (is_abs(&e1)) {
			mch16fsr(&e1);
			r_mode = R_8BIT;
		} else {
			r_mode = R_PAGN | R_8BIT;
		}
		outrwm(&e1, r_mode, op + (e2.e_addr << 8));
		break;

	case S_F:			/* inst f */
		t1 = addr(&e1);		/* f */
		if ((t1 != S_DIR) && (t1 != S_EXT)) {
			aerr();
		} else
		if (mchramchk(&e1)) {
			aerr();
		}
		if (is_abs(&e1)) {
			mch16fsr(&e1);
			r_mode = R_8BIT;
		} else {
			r_mode = R_PAGN | R_8BIT;
		}
		outrwm(&e1, r_mode, op);
		break;

	case S_FBIT:			/* inst f,b */
		t1 = addr(&e1);		/* f */
		if ((t1 != S_DIR) && (t1 != S_EXT)) {
			aerr();
		} else
		if (mchramchk(&e1)) {
			aerr();
		}
		comma(1);
		t2 = addr(&e2);		/* b */
		if ((t2 != S_IMMED) && (t2 != S_EXT)) {
			aerr();
		}
		abscheck(&e2);
		if (e2.e_addr & ~((a_uint) 0x07)) {
			aerr();
			e2.e_addr &= 0x07;
		}
		if (is_abs(&e1)) {
			mch16fsr(&e1);
			r_mode = R_8BIT;
		} else {
			r_mode = R_PAGN | R_8BIT;
		}
		outrwm(&e1, r_mode, op + (e2.e_addr << 8));
		break;

	case S_LIT:			/* inst k */
		t1 = addr(&e1);		/* k */
		if ((t1 != S_IMMED) && (t1 != S_EXT)) {
			aerr();
		}
		outrwm(&e1, R_8BIT, op);
		break;

	case S_CALL:			/* inst k */
	case S_GOTO:			/* inst k */
		t1 = addr(&e1);		/* k */
		if (t1 != S_EXT) {
			aerr();
		}
		outrwm(&e1, R_13BIT, op);
		break;

	case S_LCALL:			/* inst k */
		t1 = addr(&e1);		/* k */
		if (t1 != S_EXT) {
			aerr();
		}
		outrwm(&e1, R_PAGN | R_8BIT, op);
		break;

	case S_MOVLB:			/* movlb k */
		t1 = addr(&e1);		/* k */
		if ((t1 != S_IMMED) && (t1 != S_EXT)) {
			aerr();
		}
		outrwm(&e1, R_4BTB, op);
		break;

	case S_MOVLR:			/* movlr k */
		t1 = addr(&e1);		/* k */
		if ((t1 != S_IMMED) && (t1 != S_EXT)) {
			aerr();
		}
		outrwm(&e1, R_4BTR, op);
		break;

	case S_MOVFP:			/* movfp f,p */
		t1 = addr(&e1);		/* f */
		if ((t1 != S_DIR) && (t1 != S_EXT)) {
			aerr();
		} else
		if (mchramchk(&e1)) {
			aerr();
		}
		comma(1);
		t2 = addr(&e2);		/* p */
		if ((t2 != S_DIR) && (t2 != S_EXT)) {
			aerr();
		}
		abscheck(&e2);
		if (e2.e_addr & ~((a_uint) 0x1F)) {
			aerr();
			e2.e_addr &= 0x1F;
		}
		if (is_abs(&e1)) {
			mch16fsr(&e1);
			r_mode = R_8BIT;
		} else {
			r_mode = R_PAGN | R_8BIT;
		}
		outrwm(&e1, r_mode, op + (e2.e_addr << 8));
		break;

	case S_MOVPF:			/* movpf p,f */
		t2 = addr(&e2);		/* p */
		if ((t2 != S_DIR) && (t2 != S_EXT)) {
			aerr();
		}
		abscheck(&e2);
		if (e2.e_addr & ~((a_uint) 0x1F)) {
			aerr();
			e2.e_addr &= 0x1F;
		}
		comma(1);
		t1 = addr(&e1);		/* f */
		if ((t1 != S_DIR) && (t1 != S_EXT)) {
			aerr();
		} else
		if (mchramchk(&e1)) {
			aerr();
		}
		if (is_abs(&e1)) {
			mch16fsr(&e1);
			r_mode = R_8BIT;
		} else {
			r_mode = R_PAGN | R_8BIT;
		}
		outrwm(&e1, r_mode, op + (e2.e_addr << 8));
		break;

	case S_TF:			/* inst t,f */
		t1 = addr(&e1);		/* t */
		abscheck(&e1);
		if (e1.e_addr & ~((a_uint) 0x01)) {
			aerr();
			e1.e_addr &= 0x01;
		}
		comma(1);
		t2 = addr(&e2);		/* f */
		if ((t2 != S_DIR) && (t2 != S_EXT)) {
			aerr();
		} else
		if (mchramchk(&e2)) {
			aerr();
		}
		if (is_abs(&e2)) {
			mch16fsr(&e2);
			r_mode = R_8BIT;
		} else {
			r_mode = R_PAGN | R_8BIT;
		}
		outrwm(&e2, r_mode, op + (e1.e_addr << 9));
		break;

	case S_TIF:			/* inst t,i,f */
		t1 = addr(&e1);		/* t */
		abscheck(&e1);
		if (e1.e_addr & ~((a_uint) 0x01)) {
			aerr();
			e1.e_addr &= 0x01;
		}
		comma(1);
		t2 = addr(&e2);		/* i */
		abscheck(&e2);
		if (e2.e_addr & ~((a_uint) 0x01)) {
			aerr();
			e2.e_addr &= 0x01;
		}
		comma(1);
		t3 = addr(&e3);		/* f */
		if ((t3 != S_DIR) && (t3 != S_EXT)) {
			aerr();
		} else
		if (mchramchk(&e3)) {
			aerr();
		}
		if (is_abs(&e3)) {
			mch16fsr(&e3);
			r_mode = R_8BIT;
		} else {
			r_mode = R_PAGN | R_8BIT;
		}
		outrwm(&e3, r_mode, op + (e1.e_addr << 9) + (e2.e_addr << 8));
		break;


	case S_RET:			/* return, retfie */
	case S_INH:			/* inst */
		outaw(op);
		break;

	default:
		opcycles = OPCY_ERR;
		err('o');
		break;
	}

	if (opcycles == OPCY_NONE) {
		opcycles = p16pg1[cb[0] & 0xFF];
		if ((opcycles & OPCY_NONE) && (opcycles & OPCY_MASK)) {
			opcycles = P16Page[opcycles & OPCY_MASK][cb[1] & 0xFF];
		}
	}
}


/*
 * Select Register File Map
 */
VOID
mch16fsr(esp)
struct expr *esp;
{
	if ((esp->e_addr & ~((a_uint) 0xFF)) != pic_fsr) {
		aerr();
	}
}


/*
 * pic20 Cycle Count
 *
 *	opcycles = p20pgx[opcode]
 */
static char  p20pg1[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/  P2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1,
/*10*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*20*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 3,
/*30*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 3,
/*40*/   1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 3, 3, 3, 3, 3,
/*50*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*60*/   3, 3, 3, 3, 3, 3, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1,
/*70*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*80*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*90*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*A0*/   3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
/*B0*/   3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
/*C0*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*D0*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*E0*/   2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 2, 2, 2, 2, 2,
/*F0*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
};

static char  p20pg2[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/   1,UN,UN, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2,
/*10*/   2, 2, 2, 2, 2,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*20*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*30*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*40*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*50*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*60*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*70*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*80*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*90*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*A0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*B0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*C0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*D0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*E0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*F0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN, 1
};

static char *P20Page[2] = {
    p20pg1, p20pg2
};


/*
 * PIC20BIT CPU Type
 */
VOID
pic20bit(mp)
struct mne *mp;
{
	a_uint op;
	v_sint v1;
	int c;
	int t1, t2;
	int r_mode;
	struct expr e1, e2, e3;
	char id[NINPUT];
	struct area *espa;

	clrexpr(&e1);
	clrexpr(&e2);
	clrexpr(&e3);

	if (((dot.s_area->a_flag & (A_CSEG|A_DSEG)) == A_CSEG) && (dot.s_addr & (a_uint) 0x0001)) {
		err('b');
		;dot.s_addr += 1;
	}

	op = mp->m_valu;
	if (op == ~0) {			/* Undefined Instructions */
		err('o');
		op = 0;
	}
	switch (mp->m_type) {
	case S_SDMM:
		opcycles = OPCY_SDMM;
		lmode = SLIST;
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
		break;

	case S_FW:			/* inst f,d(,a) */
		t1 = addr(&e1);		/* f */
		if ((t1 != S_DIR) && (t1 != S_EXT)) {
			aerr();
		} else
		if (mchramchk(&e1)) {
			aerr();
		}
		comma(1);
		t2 = addr(&e2);		/* d */
		if (t2 == S_WREG) {
			e2.e_addr = 0;
		} else
		if (t2 == S_FREG) {
			e2.e_addr = 1;
		} else {
			abscheck(&e2);
			if (e2.e_addr & ~((a_uint) 0x01)) {
				aerr();
				e2.e_addr &= 0x01;
			}
			if (t2 == S_DIR) {
				aerr();
			}
		}
		if (more()) {
			comma(1);
			expr(&e3, 0);	/* a */
			abscheck(&e3);
			if (e3.e_addr & ~((a_uint) 0x01)) {
				aerr();
				e3.e_addr &= 0x01;
			}
			if (is_abs(&e1)) {
				/*
				 * With Force Access Bank
				 * if e1.e_addr is not in the range
				 * 0x00-0x7F or 0xF80-0xFFF
				 * report an error.
				 */
				if (e3.e_addr == 0) {
					if (((e1.e_addr & ~((a_uint) 0x7F)) != 0x000) &&
					    ((e1.e_addr & ~((a_uint) 0x7F)) != 0xF80)) {
						aerr();
					}
				}
			}
		} else {
			if (is_abs(&e1)) {
				/*
				 * If e_addr is in the range
				 * 0x00-0x7F or 0xF80-0xFFF
				 * then a = 0.  Force Access Bank.
				 */
				if (((e1.e_addr & ~((a_uint) 0x7F)) == 0x000) ||
				    ((e1.e_addr & ~((a_uint) 0x7F)) == 0xF80)) {
					e3.e_addr = 0;
				/*
				 * Else use Bank Select Register (BSR).
				 */
				} else {
					e3.e_addr = 1;
				}
			} else {
				e3.e_addr = 1;
			}
		}
		/*
		 * Bank Select Register Mode
		 */
		if (e3.e_addr) {
			r_mode = R_PAGN | R_8BIT;
			mchdpm(&e1);
		/*
		 * Force Access Bank Mode
		 */
		} else {
			r_mode = R_8BIT;
		}
		outrwm(&e1, r_mode, op + (e2.e_addr << 9) + (e3.e_addr << 8));
		break;

	case S_CLRF:			/* clrf f(,a) */
	case S_SETF:			/* setf f(,a) */
	case S_F:			/* inst f(,a) */
		t1 = addr(&e1);		/* f */
		if ((t1 != S_DIR) && (t1 != S_EXT)) {
			aerr();
		} else
		if (mchramchk(&e1)) {
			aerr();
		}
		if (more()) {
			comma(1);
			expr(&e2, 0);	/* a */
			abscheck(&e2);
			if (e2.e_addr & ~((a_uint) 0x01)) {
				aerr();
				e2.e_addr &= 0x01;
			}
			if (is_abs(&e1)) {
				/*
				 * With Force Access Bank
				 * if e1.e_addr is not in the range
				 * 0x00-0x7F or 0xF80-0xFFF
				 * report an error.
				 */
				if (e2.e_addr == 0) {
					if (((e1.e_addr & ~((a_uint) 0x7F)) != 0x000) &&
					    ((e1.e_addr & ~((a_uint) 0x7F)) != 0xF80)) {
						aerr();
					}
				}
			}
		} else {
			if (is_abs(&e1)) {
				/*
				 * If e_addr is in the range
				 * 0x00-0x7F or 0xF80-0xFFF
				 * then a = 0.  Force Access Bank.
				 */
				if (((e1.e_addr & ~((a_uint) 0x7F)) == 0x000) ||
				    ((e1.e_addr & ~((a_uint) 0x7F)) == 0xF80)) {
					e2.e_addr = 0;
				/*
				 * Else use Bank Select Register (BSR).
				 */
				} else {
					e2.e_addr = 1;
				}
			} else {
				e2.e_addr = 1;
			}
		}
		/*
		 * Bank Select Register Mode
		 */
		if (e2.e_addr) {
			r_mode = R_PAGN | R_8BIT;
			mchdpm(&e1);
		/*
		 * Force Access Bank Mode
		 */
		} else {
			r_mode = R_8BIT;
		}
		outrwm(&e1, r_mode, op + (e2.e_addr << 8));
		break;

	case S_FBIT:			/* inst f,b(,a) */
		t1 = addr(&e1);		/* f */
		if ((t1 != S_DIR) && (t1 != S_EXT)) {
			aerr();
		} else
		if (mchramchk(&e1)) {
			aerr();
		}
		comma(1);
		t2 = addr(&e2);		/* b */
		if ((t2 != S_IMMED) && (t2 != S_EXT)) {
			aerr();
		}
		abscheck(&e2);
		if (e2.e_addr & ~((a_uint) 0x07)) {
			aerr();
			e2.e_addr &= 0x07;
		}
		if (more()) {
			comma(1);
			expr(&e3, 0);	/* a */
			abscheck(&e3);
			if (e3.e_addr & ~((a_uint) 0x01)) {
				aerr();
				e3.e_addr &= 0x01;
			}
			if (is_abs(&e1)) {
				/*
				 * With Force Access Bank
				 * if e1.e_addr is not in the range
				 * 0x00-0x7F or 0xF80-0xFFF
				 * report an error.
				 */
				if (e3.e_addr == 0) {
					if (((e1.e_addr & ~((a_uint) 0x7F)) != 0x000) &&
					    ((e1.e_addr & ~((a_uint) 0x7F)) != 0xF80)) {
						aerr();
					}
				}
			}
		} else {
			if (is_abs(&e1)) {
				/*
				 * If e_addr is in the range
				 * 0x00-0x7F or 0xF80-0xFFF
				 * then a = 0.  Force Access Bank.
				 */
				if (((e1.e_addr & ~((a_uint) 0x7F)) == 0x000) ||
				    ((e1.e_addr & ~((a_uint) 0x7F)) == 0xF80)) {
					e3.e_addr = 0;
				/*
				 * Else use Bank Select Register (BSR).
				 */
				} else {
					e3.e_addr = 1;
				}
			} else {
				e3.e_addr = 1;
			}
		}
		/*
		 * Bank Select Register Mode
		 */
		if (e3.e_addr) {
			r_mode = R_PAGN | R_8BIT;
			mchdpm(&e1);
		/*
		 * Force Access Bank Mode
		 */
		} else {
			r_mode = R_8BIT;
		}
		outrwm(&e1, r_mode, op + (e2.e_addr << 9) + (e3.e_addr << 8));
		break;

	case S_LIT:			/* inst k */
		t1 = addr(&e1);		/* k */
		if ((t1 != S_IMMED) && (t1 != S_EXT)) {
			aerr();
		}
		outrwm(&e1, R_8BIT, op);
		break;

	case S_CALL:			/* call k */
		t1 = addr(&e1);		/* k */
		if (more()) {
			comma(1);
			expr(&e2, 0);	/* s */
			abscheck(&e2);
			if (e2.e_addr & ~((a_uint) 0x01)) {
				aerr();
				e2.e_addr &= 0x01;
			}
		} else {
			e2.e_addr = 0;
		}
		if (pic_goto) {
			/* Use PIC Mode for Branch */
			if ((t1 != S_IMMED) && (t1 != S_EXT)) {
				aerr();
			}
			outr4bm(&e1, R_20BIT | R_MBRO, op + (e2.e_addr << 8) + ((a_uint) 0x0000F000 << 16));
		} else {
			/* Use ASxxxx Mode for Branch */
			if (t1 != S_EXT) {
				aerr();
			}
			outr4bm(&e1, R_CALL, op + (e2.e_addr << 8) + ((a_uint) 0x0000F000 << 16));
		}
		break;

	case S_GOTO:			/* goto k */
		t1 = addr(&e1);		/* k */
		if (pic_goto) {
			/* Use PIC Mode for Branch */
			if ((t1 != S_IMMED) && (t1 != S_EXT)) {
				aerr();
			}
			outr4bm(&e1, R_20BIT | R_MBRO, op + ((a_uint) 0x0000F000 << 16));
		} else {
			/* Use ASxxxx Mode for Branch */
			if (t1 != S_EXT) {
				aerr();
			}
			outr4bm(&e1, R_CALL, op + ((a_uint) 0x0000F000 << 16));
		}
		break;

	case S_BRA:			/* bra */
		/* Relative branch */
		expr(&e1, 0);
		if (pic_goto) {
			/* Use PIC Mode for Branch */
			if (is_abs(&e1)) {
				v1 = e1.e_addr;
				if ((v1 < -1024) || (v1 > 1023))
					aerr();
				outaw(op + (v1 & 0x7FF));
			} else {
				outrwm(&e1, R_SGND | R_11BIT, op);
			}
		} else {
			/* Use ASxxxx Mode for Branch */
			if (mchpcr(&e1)) {
				v1 = e1.e_addr - dot.s_addr - 2;
				if ((v1 < -2048) || (v1 > 2047))
					aerr();
				outaw(op + ((v1 >> 1) & 0x7FF));
			} else {
				outrwm(&e1, R_PCR | R_BRA, op);
			}
		}
		if (e1.e_mode != S_USER) {
			rerr();
		}
		break;

	case S_CBRA:			/* Conditional branches */
		/* Relative branch */
		expr(&e1, 0);
		if (pic_goto) {
			/* Use PIC Mode for Branch */
			if (is_abs(&e1)) {
				v1 = e1.e_addr;
				if ((v1 < -128) || (v1 > 127))
					aerr();
				outaw(op + (v1 & 0xFF));
			} else {
				outrwm(&e1, R_SGND | R_8BIT, op);
			}
		} else {
			/* Use ASxxxx Mode for Branch */
			if (mchpcr(&e1)) {
				v1 = e1.e_addr - dot.s_addr - 2;
				if ((v1 < -256) || (v1 > 255))
					aerr();
				outaw(op + ((v1 >> 1) & 0xFF));
			} else {
				outrwm(&e1, R_PCR | R_CBRA, op);
			}
		}
		if (e1.e_mode != S_USER) {
			rerr();
		}
		break;

	case S_MOVLB:			/* movlb k */
		t1 = addr(&e1);		/* k */
		if ((t1 != S_IMMED) && (t1 != S_EXT)) {
			aerr();
		}
		outrwm(&e1, R_8BIT, op);
		break;

	case S_LFSR:			/* lfsr f,k */
		t1 = addr(&e1);		/* f */
		if ((t1 != S_DIR) && (t1 != S_EXT)) {
			aerr();
		} else
		if (mchramchk(&e1)) {
			aerr();
		}
		abscheck(&e1);
		if ((e1.e_addr & ~((a_uint) 0x03)) || (e1.e_addr == 3)) {
			aerr();
			e1.e_addr = 0x00;
		}
		comma(1);
		t2 = addr(&e2);		/* k */
		if (t2 != S_IMMED) {
			aerr();
		}
		if (is_abs(&e2)) {
			r_mode = R_MBRO | R_LFSR;
		} else {
			r_mode = R_PAG0 | R_LFSR;
		}
		outr4bm(&e2, r_mode, (op + (e1.e_addr << 4)) | ((a_uint) 0x0000F000 << 16));
		break;

	case S_MOVFF:			/* movff f,f */
		t1 = addr(&e1);		/* f */
		if ((t1 != S_DIR) && (t1 != S_EXT)) {
			aerr();
		} else
		if (mchramchk(&e1)) {
			aerr();
		}
		comma(1);
		t2 = addr(&e2);		/* f */
		if ((t2 != S_DIR) && (t2 != S_EXT)) {
			aerr();
		} else
		if (mchramchk(&e2)) {
			aerr();
		}
		outrwm(&e1, R_12BIT | R_MBRO, op);
		outrwm(&e2, R_12BIT | R_MBRO, (a_uint) 0x0000F000);
		break;

	case S_TBL:			/* tblrd/tblwt '*','*+','*-','+*'  */
		if ((c=get()) == '*') {
			if ((c = get()) == '+') {
				op += 1;
			} else
			if (c == '-') {
				op += 2;
			} else
			if ((c != ' ') && (c != '\t') && (c != ';')) {
				unget(c);
				unget('*');
			}
		} else
		if (c == '+') {
			if ((c = get()) == '*') {
				op += 3;
			} else {
				unget(c);
				unget('+');
			}
		} else {
			unget(c);
		}
		outaw(op);
		break;


	case S_RET:			/* return, retfie */
		if (more()) {
			expr(&e1, 0);   /* s */
			abscheck(&e1);
			if (e1.e_addr & ~((a_uint) 0x01)) {
				aerr();
				e1.e_addr &= 0x01;
			}
		} else {
			e1.e_addr = 0;
		}
		outaw(op + e1.e_addr);
		break;

	case S_DAW:			/* daw */
	case S_INH:			/* inst */
		outaw(op);
		break;

	case S_ADDFSR:			/* addfsr, subfsr */
		expr(&e1, 0);		/* f */
		abscheck(&e1);
		if ((e1.e_addr & ~((a_uint) 0x03)) || (e1.e_addr == 3)) {
			aerr();
			e1.e_addr = 0x00;
		}
		comma(1);
		t2 = addr(&e2);		/* k */
		if ((t2 != S_IMMED) && (t2 != S_EXT)) {
			aerr();
		}
		outrwm(&e2, R_MBRO | R_6BIT, op + (e1.e_addr << 6));
		break;

	case S_ADDULNK:			/* addulnk, subulnk */
		t1 = addr(&e1);		/* k */
		if ((t1 != S_IMMED) && (t1 != S_EXT)) {
			aerr();
		} else
		if (mchramchk(&e1)) {
			aerr();
		}
		outrwm(&e1, R_MBRO | R_6BIT, op);
		/* overide cycles table */
		opcycles = 2;
		break;

	case S_CALLW:			/* callw */
		outaw(op);
		break;

	case S_MOVSS:			/* movss */
		t1 = addr(&e1);		/* Zs */
		if ((t1 != S_DIR) && (t1 != S_EXT)) {
			aerr();
		} else
		if (mchramchk(&e1)) {
			aerr();
		}
		comma(1);
		t2 = addr(&e2);		/* Zd */
		if ((t2 != S_DIR) && (t2 != S_EXT)) {
			aerr();
		} else
		if (mchramchk(&e2)) {
			aerr();
		}
		outrwm(&e1, R_MBRO | R_7BIT, op);
		outrwm(&e2, R_MBRO | R_7BIT, (a_uint) 0x0000F000);
		break;

	case S_MOVSF:			/* movfs */
		t1 = addr(&e1);		/* Zs */
		if ((t1 != S_DIR) && (t1 != S_EXT)) {
			aerr();
		} else
		if (mchramchk(&e1)) {
			aerr();
		}
		comma(1);
		t2 = addr(&e2);		/* f */
		if ((t2 != S_DIR) && (t2 != S_EXT)) {
			aerr();
		} else
		if (mchramchk(&e2)) {
			aerr();
		}
		outrwm(&e1, R_MBRO | R_7BIT, op);
		outrwm(&e2, R_MBRO | R_12BIT, (a_uint) 0x0000F000);
		break;

	default:
		opcycles = OPCY_ERR;
		err('o');
		break;
	}

	if (((dot.s_area->a_flag & (A_CSEG|A_DSEG)) == A_CSEG) && (dot.s_addr & (a_uint) 0x0001)) {
		err('b');
		dot.s_addr += 1;
	}

	if (opcycles == OPCY_NONE) {
		opcycles = p20pg1[cb[0] & 0xFF];
		if ((opcycles & OPCY_NONE) && (opcycles & OPCY_MASK)) {
			opcycles = P20Page[opcycles & OPCY_MASK][cb[1] & 0xFF];
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
 * Direct Page Map
 */
VOID
mchdpm(esp)
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
 * Machine Ram Check
 */
int
mchramchk(esp)
struct expr *esp;
{
	struct badram *brp;

	if (is_abs(esp)) {
		brp = br;
		while (brp != NULL) {
			if ((brp->b_lo <= esp->e_addr) &&
			    (esp->e_addr <= brp->b_hi)) {
				return(1);
			}
			brp = brp->b_badram;
		}
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

	if (pass == 0) {
		pic_bytes = 0;
		br = NULL;
	}
	pic_type = 0;
	pic_fsr  = 0;
	pic_goto = 0;
}

