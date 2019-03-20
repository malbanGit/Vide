/* I48ADR.C */

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
		return (esp->e_mode);
	}
	unget(c);
	if (admode(acc)) {
		esp->e_mode = S_A;
	} else
	if (admode(indacc)) {
		esp->e_mode = S_IA;
	} else
	if (admode(reg)) {
		esp->e_mode = S_R;
	} else
	if (admode(indreg)) {
		esp->e_mode = S_IR;
	} else
	if (admode(port)) {
		esp->e_mode = S_PORT;
	} else
	if (admode(slct)) {
		esp->e_mode = S_SLCT;
	} else
	if (admode(misc)) {
		esp->e_mode = aindx;
	} else {
		unget(c);
		expr(esp, 0);
		esp->e_mode = S_EXT;
		return (esp->e_mode);
	}
	esp->e_addr = aindx;
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
		if (any(*ptr," \t,;")) {
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

struct adsym	acc[] = {	/* accumulator */
    {	"a",	0x00	},
    {	"",	0x00	}
};

struct adsym	indacc[] = {	/* accumulator indirect */
    {	"@a",	0x00	},
    {	"",	0x00	}
};

struct adsym	reg[] = {	/* register */
    {	"r0",	0x00	},
    {	"r1",	0x01	},
    {	"r2",	0x02	},
    {	"r3",	0x03	},
    {	"r4",	0x04	},
    {	"r5",	0x05	},
    {	"r6",	0x06	},
    {	"r7",	0x07	},
    {	"",	0x00	}
};

struct adsym	indreg[] = {	/* register indirect */
    {	"@r0",	0x00	},
    {	"@r1",	0x01	},
    {	"",	0x00	}
};
struct adsym	port[] = {	/* I/O Ports */
    {	"bus",	0x00	},
    {	"p1",	0x01	},
    {	"p2",	0x02	},
    {	"p4",	0x04	},
    {	"p5",	0x05	},
    {	"p6",	0x06	},
    {	"p7",	0x07	},
    {	"",	0x00	}
};

struct adsym	slct[] = {	/* selects */
    {	"an0",	0x85	},	/* 8022 only */
    {	"an1",	0x95	},	/* 8022 only */
    {	"rb0",	0xC5	},
    {	"rb1",	0xD5	},
    {	"mb0",	0xE5	},
    {	"mb1",	0xF5	},
    {	"",	0x00	}
};

struct adsym	misc[] = {	/* others */
    {	"c",	S_C	},
    {	"clk",	S_CLK	},
    {	"cnt",	S_CNT	},
    {	"dbb",	S_DBB	},
    {	"f0",	S_F0	},
    {	"f1",	S_F1	},
    {	"i",	S_I	},
    {	"psw",	S_PSW	},
    {	"t",	S_T	},
    {	"tcnt",	S_TCNT	},
    {	"tcnti",S_TCNTI	},
    {	"",	0x00	}
};


