/* avradr.c */

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

int aindx;

int
addr(esp)
struct expr *esp;
{
	int c;

	aindx = 0;
	if ((c = getnb()) == '#') {
		expr(esp, 0);
		esp->e_mode = S_IMMED;
	} else {
		unget(c);
		addr1(esp);
	}
	return (esp->e_mode);
}

int
addr1(esp)
struct expr *esp;
{
	int c;

	if (admode(regAVR)) {
		esp->e_mode = S_REG;
		esp->e_addr = aindx;
	} else
	if (admode(xyz)) {
		esp->e_mode = S_IND;
		esp->e_addr = aindx;
	} else
	if ((c = getnb()) == '*') {
		expr(esp, 0);
		esp->e_mode = S_DIR;
	} else {
		unget(c);
		expr(esp, 0);
		esp->e_mode = S_EXT;
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
			aindx = sp[i].a_val;
			return(1);
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
		if (any(*ptr," \t\n,;")) {
			ip = ptr;
			return(1);
		}
	return(0);
}

/*
 *      any --- does str contain c?
 */
int
any(c,str)
int c;
char *str;
{
	while (*str)
		if(*str++ == c)
			return(1);
	return(0);
}


struct adsym regAVR[] = {	/* r0 thru r31 registers */
    {	"r0",	0	},
    {	"r1",	1	},
    {	"r2",	2	},
    {	"r3",	3	},
    {	"r4",	4	},
    {	"r5",	5	},
    {	"r6",	6	},
    {	"r7",	7	},
    {	"r8",	8	},
    {	"r9",	9	},
    {	"r10",	10	},
    {	"r11",	11	},
    {	"r12",	12	},
    {	"r13",	13	},
    {	"r14",	14	},
    {	"r15",	15	},
    {	"r16",	16	},
    {	"r17",	17	},
    {	"r18",	18	},
    {	"r19",	19	},
    {	"r20",	20	},
    {	"r21",	21	},
    {	"r22",	22	},
    {	"r23",	23	},
    {	"r24",	24	},
    {	"r25",	25	},
    {	"r26",	26	},
    {	"r27",	27	},
    {	"r28",	28	},
    {	"r29",	29	},
    {	"r30",	30	},
    {	"r31",	31	},
    {	"",	0x00	}
};

struct adsym	xyz[] = {	/* x, y, or z index register */
    {	"x",	0x100C	},
    {	"x+",	0x100D	},
    {	"-x",	0x100E	},
    {	"y",	0x0008	},
    {	"y+",	0x1009	},
    {	"-y",	0x100A	},
    {	"z",	0x0000	},
    {	"z+",	0x1001	},
    {	"-z",	0x1002	},
    {	"",	0x0000	}
};


