/* f8adr.c */

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
#include "f2mc8.h"

int aindex;

int
addr(esp)
struct expr *esp;
{
	int c, mode;

	if ((c = getnb()) == '#') {
		expr(esp, 0);
		esp->e_mode = S_IMMED;
	} else if (c == '*') {
		expr(esp, 0);
		esp->e_mode = S_DIR;
	} else {
		if (c == '@') {
			aindex = admode(reg);
			if (aindex == S_IX) {
				if ((c = getnb()) == '+') {
					expr(esp, 0);		/* @IX+d  */
				} else {
					unget(c);		/* @IX    */
				}
			}
			esp->e_mode = S_INDX;
		} else {
			unget(c);
			if ((mode = admode(reg)) != 0) {
				esp->e_mode = mode;
			} else {
				expr(esp, 0);
				if ((!esp->e_flag)
					&& (esp->e_base.e_ap==NULL)
					&& !(esp->e_addr & ~0xFF)) {
					esp->e_mode = S_DIR;
				} else {
					esp->e_mode = S_EXT;
				}
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
	int i, v;
	char *ips;

	ips = ip;
	unget(getnb());

	i = 0;
	while ( *(ptr = &sp[i].a_str[0]) ) {
		if (srch(ptr)) {
			v = sp[i].a_val;
			switch(v) {
			case S_PC:	aindex = 0;	break;
			case S_SP:	aindex = 1;	break;
			case S_IX:	aindex = 2;	break;
			case S_EP:	aindex = 3;	break;

			case S_R + 0:
			case S_R + 1:
			case S_R + 2:
			case S_R + 3:
			case S_R + 4:
			case S_R + 5:
			case S_R + 6:
			case S_R + 7:	aindex = v - S_R;
					v = S_R;	break;

			default:	aindex = 0;	break;
			}
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
		if (any(*ptr," \t\n,+;")) {
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

struct adsym	reg[] = {	/* registers */
    {	"a",	S_A	},
    {	"t",	S_T	},

    {	"pc",	S_PC	},
    {	"sp",	S_SP	},
    {	"ix",	S_IX	},
    {	"ep",	S_EP	},

    {	"ps",	S_PS	},

    {	"r0",	S_R + 0	},
    {	"r1",	S_R + 1	},
    {	"r2",	S_R + 2	},
    {	"r3",	S_R + 3	},
    {	"r4",	S_R + 4	},
    {	"r5",	S_R + 5	},
    {	"r6",	S_R + 6	},
    {	"r7",	S_R + 7	},
    {	"",	0x00	}
};
