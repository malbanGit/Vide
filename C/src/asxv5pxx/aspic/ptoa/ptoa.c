/* PtoA.c */

/*
 *  Copyright (C) 2002-2009  Alan R. Baldwin
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
#include <string.h>

#ifdef WIN32
#include <stdlib.h>
#else
#include <alloc.h>
#endif

#include "ptoa.h"


char	afn[FILSPC];	/*	current input file specification
			 */
int	afp;		/*	current input file path length
			 */
char	afntmp[FILSPC];	/*	temporaryr input file specification
			 */
int	afptmp;		/*	temporary input file path length
			 */

int	zflag;		/*	-z, enable symbol case sensitivity
			 */

char	*ip;		/*	pointer into the assembler-source
			 *	text line in ib[]
			 */
char	ib[NINPUT*2];	/*	assembler-source text line for processing
			 */
FILE	*ifp = NULL;	/*	input file handle
			 */
FILE	*ofp = NULL;	/*	output file handle
			 */
/*
 *	The defk[] structure is used to define a
 *	substitution string for a single key word.
 *	The def structure contains the key word,
 *	and the string to substitute for the
 *	key word.  The key word string is a sequence
 *	of characters not containing any white space
 *	(i.e. NO SPACEs or TABs).  The substitution string
 *	may contain SPACES and/or TABs.
 */
struct	def	defk[] = {
	{	"list",		".list"		},
	{	"nolist",	".nlist"	},
/*	{	"equ",		".equ"		},	*/
	{	"equ",		"=:"		},
	{	"if",		".if"		},
	{	"else",		".else"		},
	{	"ifdef",	".ifdef"	},
	{	"ifndef",	".ifndef"	},
	{	"endif",	".endif"	},
	{	"messg",	".msg"		},
	{	"__maxram",	".maxram"	},
	{	"__badram",	".badram"	},

	{	"LIST",		".LIST"		},
	{	"NOLIST",	".NLIST"	},
/*	{	"EQU",		".EQU"		},	*/
	{	"EQU",		"=:"		},
	{	"IF",		".IF"		},
	{	"ELSE",		".ELSE"		},
	{	"IFDEF",	".IFDEF"	},
	{	"IFNDEF",	".IFNDEF"	},
	{	"ENDIF",	".ENDIF"	},
	{	"MESSG",	".MSG"		},
	{	"__MAXRAM",	".MAXRAM"	},
	{	"__BADRAM",	".BADRAM"	},

	{	NULL,		NULL		},
};


/*
 *	The defs[] structure is used to define a
 *	substitution string for an imbedded string.
 *	The def structure contains the search string,
 *	and the substitution string to replace the
 *	search string.  The search string is any sequence
 *	of characters and may contain white space.
 *	The replacement string may contain any character.
 */
struct	def	defs[] = {
	{	"#define",	".define"	},
	{	"#undefine",	".undefine"	},

	{	"#DEFINE",	".DEFINE"	},
	{	"#UNDEFINE",	".UNDEFINE"	},

	{	NULL,		NULL		},
};


/*
 *	an array of character types,
 *	one per ASCII character
 */
char	ctype[128] = {
/*NUL*/	ILL,	ILL,	ILL,	ILL,	ILL,	ILL,	ILL,	ILL,
/*BS*/	ILL,	SPACE,	ILL,	ILL,	SPACE,	ILL,	ILL,	ILL,
/*DLE*/	ILL,	ILL,	ILL,	ILL,	ILL,	ILL,	ILL,	ILL,
/*CAN*/	ILL,	ILL,	ILL,	ILL,	ILL,	ILL,	ILL,	ILL,
/*SPC*/	SPACE,	ETC,	ETC,	ETC,	LETTER,	BINOP,	BINOP,	ETC,
/*(*/	ETC,	ETC,	BINOP,	BINOP,	ETC,	BINOP,	LETTER,	BINOP,
/*0*/	DGT2,	DGT2,	DGT8,	DGT8,	DGT8,	DGT8,	DGT8,	DGT8,
/*8*/	DGT10,	DGT10,	ETC,	ETC,	BINOP,	ETC,	BINOP,	ETC,
/*@*/	ETC,	LTR16,	LTR16,	LTR16,	LTR16,	LTR16,	LTR16,	LETTER,
/*H*/	LETTER,	LETTER,	LETTER,	LETTER,	LETTER,	LETTER,	LETTER,	LETTER,
/*P*/	LETTER,	LETTER,	LETTER,	LETTER,	LETTER,	LETTER,	LETTER,	LETTER,
/*X*/	LETTER,	LETTER,	LETTER,	ETC,	ETC,	ETC,	BINOP,	LETTER,
/*`*/	ETC,	LTR16,	LTR16,	LTR16,	LTR16,	LTR16,	LTR16,	LETTER,
/*h*/	LETTER,	LETTER,	LETTER,	LETTER,	LETTER,	LETTER,	LETTER,	LETTER,
/*p*/	LETTER,	LETTER,	LETTER,	LETTER,	LETTER,	LETTER,	LETTER,	LETTER,
/*x*/	LETTER,	LETTER,	LETTER,	ETC,	BINOP,	ETC,	ETC,	ETC
};

/*
 *	an array of characters which
 *	perform the case translation function
 */
char	ccase[128] = {
/*NUL*/	'\000',	'\001',	'\002',	'\003',	'\004',	'\005',	'\006',	'\007',
/*BS*/	'\010',	'\011',	'\012',	'\013',	'\014',	'\015',	'\016',	'\017',
/*DLE*/	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
/*CAN*/	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037',
/*SPC*/	'\040',	'\041',	'\042',	'\043',	'\044',	'\045',	'\046',	'\047',
/*(*/	'\050',	'\051',	'\052',	'\053',	'\054',	'\055',	'\056',	'\057',
/*0*/	'\060',	'\061',	'\062',	'\063',	'\064',	'\065',	'\066',	'\067',
/*8*/	'\070',	'\071',	'\072',	'\073',	'\074',	'\075',	'\076',	'\077',
/*@*/	'\100',	'\141',	'\142',	'\143',	'\144',	'\145',	'\146',	'\147',
/*H*/	'\150',	'\151',	'\152',	'\153',	'\154',	'\155',	'\156',	'\157',
/*P*/	'\160',	'\161',	'\162',	'\163',	'\164',	'\165',	'\166',	'\167',
/*X*/	'\170',	'\171',	'\172',	'\133',	'\134',	'\135',	'\136',	'\137',
/*`*/	'\140',	'\141',	'\142',	'\143',	'\144',	'\145',	'\146',	'\147',
/*h*/	'\150',	'\151',	'\152',	'\153',	'\154',	'\155',	'\156',	'\157',
/*p*/	'\160',	'\161',	'\162',	'\163',	'\164',	'\165',	'\166',	'\167',
/*x*/	'\170',	'\171',	'\172',	'\173',	'\174',	'\175',	'\176',	'\177'
};

