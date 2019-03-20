/* m8cadr.c */

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

#include <stdio.h>
#include <setjmp.h>
#include "asxxxx.h"
#include "m8c.h"

int
addr(esp)
struct expr *esp;
{
	int c;
	int rmode, amode;

	/* Registers A, X, F, SP */
	if ((rmode = admode(regs)) != 0) {
		if (rmode != S_REG) {
			return(esp->e_mode = rmode);
		}
	}

	/* Immediate Data */
	if ((c = getnb()) == '#') {
		expr(esp, 0);
		return(esp->e_mode = S_IMM);
	} else
	/* Extended, Indexed, and Indirect Indexed (++) Mode */
	if (c == '[') {
		amode = addr1(esp);
		if (getnb() != ']') {
			aerr();
		}
		if (rmode == S_REG) {
			switch (amode) {
			case S_EXT:	esp->e_mode = S_REXT;	break;
			case S_INDX:	esp->e_mode = S_RINDX;	break;
			default:	aerr();			break;
			}
		}
	} else
	/* Immediate Data */
	{
		unget(c);
		expr(esp, 0);
		esp->e_mode = S_IMM;
	}
	return (esp->e_mode);
}

int
addr1(esp)
struct expr *esp;
{
	int c, mode;
	char *ips;

	ips = ip;
	if ((c = getnb()) == '[') {
		expr(esp, 0);
		mode = S_EXTIAU;
		if (((c = getnb()) != ']') ||
		    ((c = getnb()) != '+') ||
		    ((c = getnb()) != '+')) {
			aerr();
		}
		return(esp->e_mode = mode);
	} else
	if (((c == 'x') || (c == 'X')) &&
	    ((ctype[(c = getnb()) & 0xFF] & (DIGIT|LETTER)) == 0)) {
	    	mode = S_INDX;
		unget(c);
	} else {
		mode = S_EXT;
		ip = ips;
	}
	expr(esp, 0);
	return(esp->e_mode = mode);
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
		if(ccase[*ptr & 0x007F] != ccase[*str & 0x007F])
			break;
		ptr++;
		str++;
	}
	if (ccase[*ptr & 0x007F] == ccase[*str & 0x007F]) {
		ip = ptr;
		return(1);
	}

	if (!*str)
		if (any(*ptr," \t\n,[];")) {
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

struct adsym	regs[] = {	/* a, f, x, sp, and reg registers */
    {	"a",	S_A	},
    {	"f",	S_F	},
    {	"x",	S_X	},
    {	"sp",	S_SP	},
    {	"reg",	S_REG	},
    {	"",	0x00	}
};
