/* M09ADR.C */

/*
 *  Copyright (C) 1989-2014  Alan R. Baldwin
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
#include "m6809.h"

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
	} else
	if (c == '[') {
		aindx = 0x90;
		addr1(esp);
		if (getnb() != ']') {
			aerr();
		}
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

	if (admode(abd)) {
		comma(1);
		if (!admode(xyus))
			aerr();
		esp->e_mode = S_IND;
	} else
	if ((c = getnb()) == ',') {
		if (admode(xyus)) {
			aindx |= 0x04;
		} else
		if (admode(auto2)) {
			;
		} else
		if (!(aindx & 0x10) && admode(auto1)) {
			;
		} else {
			aerr();
		}
		esp->e_mode = S_IND;
	} else
	if (c == '*') {
		expr(esp, 0);
		esp->e_mode = S_DIR;
		if (comma(0)) {
			if (admode(xyus)) {
				esp->e_mode = S_OFST;
			} else
			if (admode(pcr)) {
				esp->e_mode = S_PCR;
			} else
			if (admode(pc)) {
				esp->e_mode = S_PC;
			} else {
				aerr();
			}
		}
	} else {
		unget(c);
		expr(esp, 0);
		if (comma(0)) {
			if (admode(xyus)) {
				esp->e_mode = S_OFST;
			} else
			if (admode(pcr)) {
				esp->e_mode = S_PCR;
			} else
			if (admode(pc)) {
				esp->e_mode = S_PC;
			} else {
				aerr();
			}
		} else {
			esp->e_mode = S_EXT;
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
	int i, v;
	char *ips;

	ips = ip;
	unget(getnb());

	i = 0;
	while ( *(ptr = &sp[i].a_str[0]) ) {
		if (srch(ptr)) {
			v = sp[i].a_val;
			aindx |= (v | 0x80);
			return(v);
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
		if (any(*ptr," \t\n,];")) {
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

struct adsym	abd[] = {	/* a, b, or d indexed offset */
    {	"a",	0x06	},
    {	"b",	0x05	},
    {	"d",	0x0B	},
    {	"",	0x00	}
};

struct adsym	xyus[] = {	/* x, y, u, or s index register */
    {	"x",	0x100	},
    {	"y",	0x120	},
    {	"u",	0x140	},
    {	"s",	0x160	},
    {	"",	0x000	}
};

struct adsym	auto1[] = {	/* auto increment/decrement by 1 */
    {	"x+",	0x100	},
    {	"-x",	0x102	},
    {	"y+",	0x120	},
    {	"-y",	0x122	},
    {	"u+",	0x140	},
    {	"-u",	0x142	},
    {	"s+",	0x160	},
    {	"-s",	0x162	},
    {	"",	0x000	}
};

struct adsym	auto2[] = {	/* auto increment/decrement by 2 */
    {	"x++",	0x101	},
    {	"--x",	0x103	},
    {	"y++",	0x121	},
    {	"--y",	0x123	},
    {	"u++",	0x141	},
    {	"--u",	0x143	},
    {	"s++",	0x161	},
    {	"--s",	0x163	},
    {	"",	0x000	}
};

struct adsym	pc[] = {	/* pc */
    {	"pc",	0x0C	},
    {	"",	0x00	}
};

struct adsym	pcr[] = {	/* pc relative */
    {	"pcr",	0x0C	},
    {	"",	0x00	}
};

struct adsym	regs[] = {	/* exg, tfr register coding */
    {	"d",	0x100	},
    {	"x",	0x101	},
    {	"y",	0x102	},
    {	"u",	0x103	},
    {	"s",	0x104	},
    {	"pc",	0x105	},
    {	"a",	0x108	},
    {	"b",	0x109	},
    {	"cc",	0x10A	},
    {	"dp",	0x10B	},
    {	"",	0x000	}
};

struct adsym	stks[] = {	/* push/pull on system stack */
    {	"cc",	0x01	},
    {	"a",	0x02	},
    {	"b",	0x04	},
    {	"d",	0x06	},
    {	"dp",	0x08	},
    {	"x",	0x10	},
    {	"y",	0x20	},
    {	"u",	0x40	},
    {	"pc",	0x80	},
    {	"",	0x00	}
};

struct adsym	stku[] = {	/* push/pull on user stack */
    {	"cc",	0x01	},
    {	"a",	0x02	},
    {	"b",	0x04	},
    {	"d",	0x06	},
    {	"dp",	0x08	},
    {	"x",	0x10	},
    {	"y",	0x20	},
    {	"s",	0x40	},
    {	"pc",	0x80	},
    {	"",	0x00	}
};
