/* scmpadr:c */

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
#include "scmp.h"

int aindx;

int
addr(esp)
struct expr *esp;
{
	int c, d, mode;

	aindx = 0;
	if ((d = admode(ptr)) != 0) {		/* ptr */
		aindx |= d;
		return (S_PTR);
	}
	c = getnb();
	if (c == '#') {				/* # DATA */
		expr(esp, 0);
		return (S_IMM);
	}
	if (c == '@') {
		aindx = 0x04;			/* auto-increment */
		c = getnb();
	}
	if (c == '[') {
		if ((d = admode(ptr)) != 0) {	/* _[ptr] ==>> _0[ptr] */
			aindx |= d;
			if (getnb() != ']') {
				aerr();
			}
			esp->e_mode = S_USER;
			return (S_IDX);
		}
	}
	if (c == '(') {
		if ((d = admode(ptr)) != 0) {	/* _(ptr) ==>> _0(ptr) */
			aindx |= d;
			if (getnb() != ')') {
				aerr();
			}
			esp->e_mode = S_USER;
			return (S_IDX);
		}
	}
	unget(c);
	expr(esp, 0);				/* _DISP_ */
	if (more()) {
		c = getnb();
		if (c == '[') {
			if ((d = admode(ptr)) != 0) {
				aindx |= d;		/* _DISP[ptr] */
				if (getnb() != ']') {
					aerr();
				}
				return (S_IDX);
			}
		}
		if (c == '(') {
			if ((d = admode(ptr)) != 0) {
				aindx |= d;		/* _DISP(ptr) */
				if (getnb() != ')') {
					aerr();
				}
				return (S_IDX);
			}
		}
	}
	if (aindx & 0x04) {
		aindx |= ptr[4].a_val;		/* @DISP ==>> @DISP(PC) */
		mode = S_IDX;
	} else {
		mode = S_EXT;
	}
	return (mode);
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
			aindx |= sp[i].a_val;
			return(aindx);
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
		if (any(*ptr," \t\n,)];")) {
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

struct adsym	ptr[] = {	/* pointer registers */
    {	"p0",	0x100	},
    {	"p1",	0x101	},
    {	"p2",	0x102	},
    {	"p3",	0x103	},
    {	"pc",	0x100	},
    {	"",	0x000	}
};


