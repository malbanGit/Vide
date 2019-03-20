/* m12adr.c */

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
 */

#include "asxxxx.h"
#include "m6812.h"

int aindx;

int
addr(esp)
struct expr *esp;
{
	int c;

	aindx = 0;
	/*
	 * #	- Immediate Constant
	 */
	if ((c = getnb()) == '#') {
		expr(esp, 0);
		esp->e_mode = S_IMMED;
	} else
	/*
	 * [ ]	- Indexed Indirect
	 */
	if (c == '[') {
		addr1(esp);
		if (getnb() != ']') {
			aerr();
		}
		/*
		 * [n,r]  - 16-bit offset indexed-indirect
		 */
		if (esp->e_mode == S_OFST) {
			esp->e_mode = S_IND;
		} else
		/*
		 * [D,r]  - Accumulator D offset indexed-indirect
		 */
		if (esp->e_mode == S_AOFST) {
			esp->e_mode = S_AIND;
			if ((aindx & 0x03) != 0x02) {
				aerr();
			}
			aindx |= 0x03;
		} else {
			esp->e_mode = S_IND;
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

	/*
	 * A,r	- Accumulator Offset
	 */
	if (admode(abd)) {
		comma(1);
		if (!admode(xysp))
			aerr();
		aindx |= 0xE4;
		esp->e_mode = S_AOFST;
	} else
	/*
	 *  -r	- Auto Pre-Decrement (1)
	 *  +r	- Auto Pre-Increment (1)
	 *  r-	- Auto Post-Decrement (1)
	 *  r+	- Auto Post-Increment (1)
	 */
	if (admode(prepost)) {
		esp->e_mode = S_AUTO;
		esp->e_addr = 1;
		if ((aindx & 0xE0) == 0xE0) {
			aerr();
		}
	} else
	/*
	 *  ,r	- Offset == Zero
	 *  ,-r	- Auto Pre-Decrement (1)
	 *  ,+r	- Auto Pre-Increment (1)
	 *  ,r-	- Auto Post-Decrement (1)
	 *  ,r+	- Auto Post-Increment (1)
	 */
	if ((c = getnb()) == ',') {
		if (admode(xysp)) {
			esp->e_mode = S_OFST;
		} else
		if (admode(prepost)) {
			esp->e_mode = S_AUTO;
			esp->e_addr = 1;
			if ((aindx & 0xE0) == 0xE0) {
				aerr();
			}
		} else {
			aerr();
		}
	} else
	if (c == '*') {
		expr(esp, 0);
		esp->e_mode = S_DIR;
		if ((c = getnb()) == ',') {
			if (admode(xysp)) {
				esp->e_mode = S_OFST;
			} else {
				unget(c);
			}
		} else {
			unget(c);
		}
	} else {
		unget(c);
		expr(esp, 0);
		esp->e_mode = S_EXT;
		if ((c = getnb()) == ',') {
			if (admode(xysp)) {
				esp->e_mode = S_OFST;
			} else
			if (admode(prepost)) {
				esp->e_mode = S_AUTO;
				if ((aindx & 0xE0) == 0xE0) {
					aerr();
				}
			} else {
				unget(c);
			}
		} else {
			unget(c);
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
			v = ADMODE_FLAG | sp[i].a_val;
			aindx |= v;
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
    {	"a",	0x00	},
    {	"b",	0x01	},
    {	"d",	0x02	},
    {	"",	0x00	}
};

struct adsym	xysp[] = {	/* x, y, sp, or pc index register */
    {	"x",	0x00	},
    {	"y",	0x08	},
    {	"s",	0x10	},
    {	"sp",	0x10	},
    {	"pc",	0x18	},
    {	"",	0x00	}
};

struct adsym	abdxys[] = {	/* a, b, d, x, y, or sp */
    {	"a",	0x00	},
    {	"b",	0x01	},
    {	"d",	0x04	},
    {	"x",	0x05	},
    {	"y",	0x06	},
    {	"s",	0x07	},
    {	"sp",	0x07	},
    {	"",	0x00	}
};

struct adsym	prepost[] = {	/* pre/post increment/decrement */
    {	"+x",	0x20	},
    {	"-x",	0x28	},
    {	"x+",	0x30	},
    {	"x-",	0x38	},
    {	"+y",	0x60	},
    {	"-y",	0x68	},
    {	"y+",	0x70	},
    {	"y-",	0x78	},
    {	"+s",	0xA0	},
    {	"-s",	0xA8	},
    {	"s+",	0xB0	},
    {	"s-",	0xB8	},
    {	"+sp",	0xA0	},
    {	"-sp",	0xA8	},
    {	"sp+",	0xB0	},
    {	"sp-",	0xB8	},
    {	"+pc",	0xE0	},
    {	"-pc",	0xE8	},
    {	"pc+",	0xF0	},
    {	"pc-",	0xF8	},
    {	"",	0x00	}
};

struct adsym	dstreg[] = {	/* exg, tfr register coding */
    {	"a",	0x00	},
    {	"b",	0x01	},
    {	"cc",	0x02	},
    {	"ccr",	0x02	},
    {	"t2",	0x03	},
    {	"d",	0x04	},
    {	"x",	0x05	},
    {	"y",	0x06	},
    {	"s",	0x07	},
    {	"sp",	0x07	},
    {	"",	0x00	}
};

struct adsym	srcreg[] = {	/* exg, tfr register coding */
    {	"a",	0x00	},
    {	"b",	0x10	},
    {	"cc",	0x20	},
    {	"ccr",	0x20	},
    {	"t3",	0x30	},
    {	"d",	0x40	},
    {	"x",	0x50	},
    {	"y",	0x60	},
    {	"s",	0x70	},
    {	"sp",	0x70	},
    {	"",	0x00	}
};

struct adsym	pushstk[] = {	/* push on stack */
    {	"x",	0x04	},
    {	"y",	0x05	},
    {	"a",	0x06	},
    {	"b",	0x07	},
    {	"cc",	0x09	},
    {	"ccr",	0x09	},
    {	"d",	0x0B	},
    {	"",	0x00	}
};

struct adsym	pullstk[] = {	/* pull from stack */
    {	"x",	0x00	},
    {	"y",	0x01	},
    {	"a",	0x02	},
    {	"b",	0x03	},
    {	"cc",	0x08	},
    {	"ccr",	0x08	},
    {	"d",	0x0A	},
    {	"",	0x00	}
};
