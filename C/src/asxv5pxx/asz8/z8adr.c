/* z8adr.c */

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

/*
 * Read an address specifier. Pack the
 * address information into the supplied
 * `expr' structure. Return the mode of
 * the address.
 *
 * This addr(esp) routine performs the following addressing decoding:
 *
 *	address		mode		flag		addr		base
 *	#n		S_IMMED		0		n		NULL
 *	value		s_type		----		s_addr		s_area
 *	Rn		S_R		0		rcode		NULL
 *	RRn		S_RR		0		rcode		NULL
 *	@Rn,  (Rn)	S_IR		0		rcode		NULL
 *	@RRn, (RRn)	S_IRR		0		rcode		NULL
 *	@value, (value)	S_INDX		----		s_addr		direct page 0
 *	offset(Rn)	S_IND + ncode	----		offset		direct page 0
 */
int
addr(esp)
struct expr *esp;
{
	int c, mode, indx;

	mode = 0;
	if ((c = getnb()) == '#') {
		expr(esp, 0);
		esp->e_mode = S_IMMED;
	} else
	if ((c == '@') || (c == LFIND)) {
		if ((indx = admode(R)) != 0) {		/*     @R or (R)     */
			mode = S_IR;
		} else
		if ((indx = admode(RR)) != 0) {		/*    @RR or (RR)    */
			mode = S_IRR;
			if (indx & 0x01) {
				aerr();
			}
		} else {				/* @value or (value) */
			expr(esp, 0);
			esp->e_mode = S_INDX;
		}
		if (indx) {
			esp->e_addr = indx&0xFF;
			esp->e_mode = mode;
			esp->e_base.e_ap = NULL;
		}
		if ((c == LFIND) && ((c = getnb()) != RTIND)) {
			qerr();
		}
	} else {
		unget(c);
		if ((indx = admode(R)) != 0) {		/*  R    */
			mode = S_R;
		} else
		if ((indx = admode(RR)) != 0) {		/*  RR   */
			mode = S_RR;
			if (indx & 0x01) {
				aerr();
			}
		} else {				/* value */
			expr(esp, 0);
			esp->e_mode = S_USER;
		}
		if (indx) {
			esp->e_addr = indx&0xFF;
			esp->e_mode = mode;
			esp->e_base.e_ap = NULL;
		}
		if (esp->e_mode == S_USER) {
			if ((c = getnb()) == LFIND) {	/* offset(R) */ 
				indx = admode(R);
				if (indx) {
					esp->e_mode = S_INDR + (indx&0xFF);
				} else {
					aerr();
				}
				if ((c = getnb()) != RTIND)
					qerr();
			} else {
				unget(c);
			}
		}
	}
	return (esp->e_mode);
}

/*
 * Enter admode() to search a specific addressing mode table
 * for a match. Return the addressing value on a match or
 * zero for no match.
 */
int
admode(sp)
struct adsym *sp;
{
	char *ptr;
	int i;
	char *ips;

	ips = ip;
	unget(getnb());

	i = 0;
	while ( *(ptr = &sp[i].a_str[0]) ) {
		if (srch(ptr)) {
			return(sp[i].a_val);
		}
		i++;
	}
	ip = ips;
	return(0);
}

/*
 *      srch --- does string match ?
 */
int
srch(str)
char *str;
{
	char *ptr;
	ptr = ip;

	while (*ptr && *str) {
		if (ccase[*ptr & 0x007F] != ccase[*str & 0x007F])
			break;
		ptr++;
		str++;
	}
	if (ccase[*ptr & 0x007F] == ccase[*str & 0x007F]) {
		ip = ptr;
		return(1);
	}

	if (!*str)
		if (!(ctype[*ptr & 0x007F] & LTR16)) {
			ip = ptr;
			return(1);
		}
	return(0);
}

/*
 * Registers
 */

struct	adsym	R[] = {
    {	"r0",	0000|0400	},
    {	"r1",	0001|0400	},
    {	"r2",	0002|0400	},
    {	"r3",	0003|0400	},
    {	"r4",	0004|0400	},
    {	"r5",	0005|0400	},
    {	"r6",	0006|0400	},
    {	"r7",	0007|0400	},
    {	"r8",	0010|0400	},
    {	"r9",	0011|0400	},
    {	"r10",	0012|0400	},
    {	"r11",	0013|0400	},
    {	"r12",	0014|0400	},
    {	"r13",	0015|0400	},
    {	"r14",	0016|0400	},
    {	"r15",	0017|0400	},
    {	"",	0000	}
};

struct	adsym	RR[] = {
    {	"rr0",	0000|0400	},
    {	"rr1",	0001|0400	},
    {	"rr2",	0002|0400	},
    {	"rr3",	0003|0400	},
    {	"rr4",	0004|0400	},
    {	"rr5",	0005|0400	},
    {	"rr6",	0006|0400	},
    {	"rr7",	0007|0400	},
    {	"rr8",	0010|0400	},
    {	"rr9",	0011|0400	},
    {	"rr10",	0012|0400	},
    {	"rr11",	0013|0400	},
    {	"rr12",	0014|0400	},
    {	"rr13",	0015|0400	},
    {	"rr14",	0016|0400	},
    {	"rr15",	0017|0400	},
    {	"",	0000	}
};

/*
 * Conditional definitions
 */

struct	adsym	CND[] = {
    {	"f",	0000|0400	},
    {	"lt",	0001|0400	},
    {	"le",	0002|0400	},
    {	"ule",	0003|0400	},
    {	"ov",	0004|0400	},
    {	"mi",	0005|0400	},
    {	"z",	0006|0400	},
    {	"c",	0007|0400	},
    {	"t",	0010|0400	},
    {	"ge",	0011|0400	},
    {	"gt",	0012|0400	},
    {	"ugt",	0013|0400	},
    {	"nov",	0014|0400	},
    {	"pl",	0015|0400	},
    {	"nz",	0016|0400	},
    {	"nc",	0017|0400	},

    {	"eq",	0006|0400	},
    {	"ult",	0007|0400	},

    {	"ne",	0016|0400	},
    {	"uge",	0017|0400	},
    {	"",	0000		}
};
