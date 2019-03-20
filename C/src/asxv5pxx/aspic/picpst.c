/* picpst.c */

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

/*
 * Coding Banks
 */
struct	bank	bank[2] = {
    /*	The '_CODE' area/bank has a NULL default file suffix.	*/
    {	NULL,		"_CSEG",	NULL,		0,	0,	0,	0,	0	},
    {	&bank[0],	"_DSEG",	"_DS",		1,	0,	0,	0,	B_FSFX	}
};

/*
 * Coding Areas
 */
struct	area	area[2] = {
    {	NULL,		&bank[0],	"_CODE",	0,	0,	0,	A_2BYTE|A_BNK|A_CSEG	},
    {	&area[0],	&bank[1],	"_DATA",	1,	0,	0,	A_1BYTE|A_BNK|A_DSEG	}
};

/*
 * Basic Relocation Mode Definition
 *
 *	#define		R_NORM	0000		No Bit Positioning
 */
char mode0[32] = {	/* R_NORM */
	'\200',	'\201',	'\202',	'\203',	'\204',	'\205',	'\206',	'\207',
	'\210',	'\211',	'\212',	'\213',	'\214',	'\215',	'\216',	'\217',
	'\220',	'\221',	'\222',	'\223',	'\224',	'\225',	'\226',	'\227',
	'\230',	'\231',	'\232',	'\233',	'\234',	'\235',	'\236',	'\237'
};

/*
 * Additional Relocation Mode Definitions
 *
 * Specification for the 4-bit addressing mode (Low Nibble):
 */
char mode1[32] = {	/* R_4BTB */	/* --:--:16:-- */
	'\200',	'\201',	'\202',	'\203',	'\004',	'\005',	'\006',	'\007',
	'\010',	'\011',	'\012',	'\013',	'\014',	'\015',	'\016',	'\017',
	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};

/*
 * Specification for the 4-bit addressing mode (High Nibble):
 */
char mode2[32] = {	/* R_4BTR */	/* --:--:16:-- */
	'\204',	'\205',	'\206',	'\207',	'\004',	'\005',	'\006',	'\007',
	'\010',	'\011',	'\012',	'\013',	'\014',	'\015',	'\016',	'\017',
	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};

/*
 * Specification for the 5-bit addressing mode:
 */
char mode3[32] = {	/* R_5BIT */	/* 12:--:--:-- */
	'\200',	'\201',	'\202',	'\203',	'\204',	'\005',	'\006',	'\007',
	'\010',	'\011',	'\012',	'\013',	'\014',	'\015',	'\016',	'\017',
	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};

/*
 * PIC18Fxxx Extended Instructions 6-bit addressing mode.
 */
char mode4[32] = {	/* R_6BIT */	/* --:--:--:20 */
	'\200',	'\201',	'\202',	'\203',	'\204',	'\205',	'\006',	'\007',
	'\010',	'\011',	'\012',	'\013',	'\014',	'\015',	'\016',	'\017',
	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};

/*
 * Specification for the 7-bit addressing mode:
 */
char mode5[32] = {	/* R_7BIT */	/* --:14:--:20 */
	'\200',	'\201',	'\202',	'\203',	'\204',	'\205',	'\206',	'\007',
	'\010',	'\011',	'\012',	'\013',	'\014',	'\015',	'\016',	'\017',
	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};

/*
 * Specification for the 8-bit addressing mode:
 */
char mode6[32] = {	/* R_8BIT */	/* 12:14:16:20 */
	'\200',	'\201',	'\202',	'\203',	'\204',	'\205',	'\206',	'\207',
	'\010',	'\011',	'\012',	'\013',	'\014',	'\015',	'\016',	'\017',
	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};

/*
 * Specification for the 9-bit addressing mode:
 */
char mode7[32] = {	/* R_9BIT */	/* 12:--:--:-- */
	'\200',	'\201',	'\202',	'\203',	'\204',	'\205',	'\206',	'\207',
	'\210',	'\011',	'\012',	'\013',	'\014',	'\015',	'\016',	'\017',
	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};

/*
 * Specification for the 11-bit addressing mode:
 */
char mode8[32] = {	/* R_11BIT */	/* --:14:--:20 */
	'\200',	'\201',	'\202',	'\203',	'\204',	'\205',	'\206',	'\207',
	'\210',	'\211',	'\212',	'\013',	'\014',	'\015',	'\016',	'\017',
	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};

/*
 * Specification for the 12-bit addressing mode:
 */
char mode9[32] = {	/* R_12BIT */	/* --:--:--:20 */
	'\200',	'\201',	'\202',	'\203',	'\204',	'\205',	'\206',	'\207',
	'\210',	'\211',	'\212',	'\213',	'\014',	'\015',	'\016',	'\017',
	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};

/*
 * Specification for the 13-bit addressing mode:
 */
char mode10[32] = {	/* R_13BIT */	/* --:--:16:-- */
	'\200',	'\201',	'\202',	'\203',	'\204',	'\205',	'\206',	'\207',
	'\210',	'\211',	'\212',	'\213',	'\214',	'\015',	'\016',	'\017',
	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};

/*
 * Specification for the 20-bit addressing mode:
 */
char mode11[32] = {	/* R_20BIT */	/* --:--:--:20 */
	'\200',	'\201',	'\202',	'\203',	'\204',	'\205',	'\206',	'\207',
	'\220',	'\221',	'\222',	'\223',	'\224',	'\225',	'\226',	'\227',
	'\230',	'\231',	'\232',	'\233',	'\024',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};

/*
 * Specification for the 8-bit Conditional Branch addressing mode:
 */
char mode12[32] = {	/* R_CBRA */	/* --:--:--:20 */
	'\000',	'\200',	'\201',	'\202',	'\203',	'\204',	'\205',	'\206',
	'\207',	'\011',	'\012',	'\013',	'\014',	'\015',	'\016',	'\017',
	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};

/*
 * Specification for the 11-bit BrAnch addressing mode:
 */
char mode13[32] = {	/* R_BRA */	/* --:--:--:20 */
	'\000',	'\200',	'\201',	'\202',	'\203',	'\204',	'\205',	'\206',
	'\207',	'\210',	'\211',	'\212',	'\014',	'\015',	'\016',	'\017',
	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};

/*
 * Specification for the 12-bit LFSR addressing mode:
 */
char mode14[32] = {	/* R_LFSR */	/* --:--:--:20 */
	'\220',	'\221',	'\222',	'\223',	'\224',	'\225',	'\226',	'\227',
	'\200',	'\201',	'\202',	'\203',	'\014',	'\015',	'\016',	'\017',
	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};

/*
 * Specification for the 20-bit CALL/GOTO  addressing mode:
 */
char mode15[32] = {	/* R_CALL */	/* --:--:--:20 */
	'\000',	'\200',	'\201',	'\202',	'\203',	'\204',	'\205',	'\206',
	'\207',	'\220',	'\221',	'\222',	'\223',	'\224',	'\225',	'\226',
	'\227',	'\230',	'\231',	'\232',	'\233',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};

/*
 *     *m_def is a pointer to the bit relocation definition.
 *	m_flag indicates that bit position swapping is required.
 *	m_dbits contains the active bit positions for the output.
 *	m_sbits contains the active bit positions for the input.
 *
 *	struct	mode
 *	{
 *		char *	m_def;		Bit Relocation Definition
 *		a_uint	m_flag;		Bit Swapping Flag
 *		a_uint	m_dbits;	Destination Bit Mask
 *		a_uint	m_sbits;	Source Bit Mask
 *	};
 */
#ifdef	LONGINT
struct	mode	mode[16] = {
    {	&mode0[0],	0l,	0x0000FFFFl,	0x0000FFFFl	},	/* R_NORM  */
    {	&mode1[0],	0l,	0x0000000Fl,	0x0000000Fl	},	/* R_4BTB  */
    {	&mode2[0],	1l,	0x000000F0l,	0x0000000Fl	},	/* R_4BTR  */
    {	&mode3[0],	0l,	0x0000001Fl,	0x0000001Fl	},	/* R_5BIT  */
    {	&mode4[0],	0l,	0x0000003Fl,	0x0000003Fl	},	/* R_6BIT  */
    {	&mode5[0],	0l,	0x0000007Fl,	0x0000007Fl	},	/* R_7BIT  */
    {	&mode6[0],	0l,	0x000000FFl,	0x000000FFl	},	/* R_8BIT  */
    {	&mode7[0],	0l,	0x000001FFl,	0x000001FFl	},	/* R_9BIT  */
    {	&mode8[0],	0l,	0x000007FFl,	0x000007FFl	},	/* R_11BIT */
    {	&mode9[0],	0l,	0x00000FFFl,	0x00000FFFl	},	/* R_12BIT */
    {	&mode10[0],	0l,	0x00001FFFl,	0x00001FFFl	},	/* R_13BIT */
    {	&mode11[0],	1l,	0x0FFF00FFl,	0x000FFFFFl	},	/* R_20BIT */
    {	&mode12[0],	1l,	0x000000FFl,	0x000001FFl	},	/* R_CBRA  */
    {	&mode13[0],	1l,	0x000007FFl,	0x00000FFFl	},	/* R_BRA   */
    {	&mode14[0],	1l,	0x00FF000Fl,	0x00000FFFl	},	/* R_LFSR  */
    {	&mode15[0],	1l,	0x0FFF00FFl,	0x001FFFFFl	}	/* R_CALL  */
};
#else
struct	mode	mode[16] = {
    {	&mode0[0],	0,	0x0000FFFF,	0x0000FFFF	},	/* R_NORM  */
    {	&mode1[0],	0,	0x0000000F,	0x0000000F	},	/* R_4BTB  */
    {	&mode2[0],	1,	0x000000F0,	0x0000000F	},	/* R_4BTR  */
    {	&mode3[0],	0,	0x0000001F,	0x0000001F	},	/* R_5BIT  */
    {	&mode4[0],	0,	0x0000003F,	0x0000003F	},	/* R_6BIT  */
    {	&mode5[0],	0,	0x0000007F,	0x0000007F	},	/* R_7BIT  */
    {	&mode6[0],	0,	0x000000FF,	0x000000FF	},	/* R_8BIT  */
    {	&mode7[0],	0,	0x000001FF,	0x000001FF	},	/* R_9BIT  */
    {	&mode8[0],	0,	0x000007FF,	0x000007FF	},	/* R_11BIT */
    {	&mode9[0],	0,	0x00000FFF,	0x00000FFF	},	/* R_12BIT */
    {	&mode10[0],	0,	0x00001FFF,	0x00001FFF	},	/* R_13BIT */
    {	&mode11[0],	1,	0x0FFF00FF,	0x000FFFFF	},	/* R_20BIT */
    {	&mode12[0],	1,	0x000000FF,	0x000001FF	},	/* R_CBRA  */
    {	&mode13[0],	1,	0x000007FF,	0x00000FFF	},	/* R_BRA   */
    {	&mode14[0],	1,	0x00FF000F,	0x00000FFF	},	/* R_LFSR  */
    {	&mode15[0],	1,	0x0FFF00FF,	0x001FFFFF	}	/* R_CALL  */
};
#endif

#if 0
struct	mode	mode[16] = {
    {	&mode0[0],	0,	((a_uint) 0x0000FFFF),	((a_uint) 0x0000FFFF)	},	/* R_NORM  */
    {	&mode1[0],	0,	((a_uint) 0x0000000F),	((a_uint) 0x0000000F)	},	/* R_4BTB  */
    {	&mode2[0],	1,	((a_uint) 0x000000F0),	((a_uint) 0x0000000F)	},	/* R_4BTR  */
    {	&mode3[0],	0,	((a_uint) 0x0000001F),	((a_uint) 0x0000001F)	},	/* R_5BIT  */
    {	&mode4[0],	0,	((a_uint) 0x0000003F),	((a_uint) 0x0000003F)	},	/* R_6BIT  */
    {	&mode5[0],	0,	((a_uint) 0x0000007F),	((a_uint) 0x0000007F)	},	/* R_7BIT  */
    {	&mode6[0],	0,	((a_uint) 0x000000FF),	((a_uint) 0x000000FF)	},	/* R_8BIT  */
    {	&mode7[0],	0,	((a_uint) 0x000001FF),	((a_uint) 0x000001FF)	},	/* R_9BIT  */
    {	&mode8[0],	0,	((a_uint) 0x000007FF),	((a_uint) 0x000007FF)	},	/* R_11BIT */
    {	&mode9[0],	0,	((a_uint) 0x00000FFF),	((a_uint) 0x00000FFF)	},	/* R_12BIT */
    {	&mode10[0],	0,	((a_uint) 0x00001FFF),	((a_uint) 0x00001FFF)	},	/* R_13BIT */
    {	&mode11[0],	1,	((a_uint) 0x0FFF00FF),	((a_uint) 0x000FFFFF)	},	/* R_20BIT */
    {	&mode12[0],	1,	((a_uint) 0x000000FF),	((a_uint) 0x000001FF)	},	/* R_CBRA  */
    {	&mode13[0],	1,	((a_uint) 0x000007FF),	((a_uint) 0x00000FFF)	},	/* R_BRA   */
    {	&mode14[0],	1,	((a_uint) 0x00FF000F),	((a_uint) 0x00000FFF)	},	/* R_LFSR  */
    {	&mode15[0],	1,	((a_uint) 0x0FFF00FF),	((a_uint) 0x001FFFFF)	}	/* R_CALL  */
};
#endif
/*
 * Array of Pointers to mode Structures
 */
struct	mode	*modep[16] = {
	&mode[0],	&mode[1],	&mode[2],	&mode[3],
	&mode[4],	&mode[5],	&mode[6],	&mode[7],
	&mode[8],	&mode[9],	&mode[10],	&mode[11],
	&mode[12],	&mode[13],	&mode[14],	&mode[15]
};

/*
 * Mnemonic Structure
 */
struct	mne	mne[] = {

	/* machine */

    {	NULL,	"CSEG",		S_ATYP,		0,	A_CSEG|A_2BYTE	},
    {	NULL,	"DSEG",		S_ATYP,		0,	A_DSEG|A_1BYTE	},

    {	NULL,	".setdmm",	S_SDMM,		0,	0	},

    {	NULL,	".pic",		X_PTYPE,	0,	0	},
    {	NULL,	".picfix",	X_PFIX,		0,	0	},

    {	NULL,	".picgoto",	X_PGOTO,	0,	0	},

    {	NULL,	".picnopic",	X_PBITS,	0,	X_NOPIC	},
    {	NULL,	".pic12bit",	X_PBITS,	0,	X_12BIT	},
    {	NULL,	".pic14bit",	X_PBITS,	0,	X_14BIT	},
    {	NULL,	".pic16bit",	X_PBITS,	0,	X_16BIT	},
    {	NULL,	".pic20bit",	X_PBITS,	0,	X_20BIT	},

    {	NULL,	".maxram",	X_PMAXR,	0,	0	},
    {	NULL,	".badram",	X_PBADR,	0,	0	},

	/* system */

    {	NULL,	"BANK",		S_ATYP,		0,	A_BNK	},
    {	NULL,	"CON",		S_ATYP,		0,	A_CON	},
    {	NULL,	"OVR",		S_ATYP,		0,	A_OVR	},
    {	NULL,	"REL",		S_ATYP,		0,	A_REL	},
    {	NULL,	"ABS",		S_ATYP,		0,	A_ABS	},
    {	NULL,	"NOPAG",	S_ATYP,		0,	A_NOPAG	},
    {	NULL,	"PAG",		S_ATYP,		0,	A_PAG	},

    {	NULL,	"BASE",		S_BTYP,		0,	B_BASE	},
    {	NULL,	"SIZE",		S_BTYP,		0,	B_SIZE	},
    {	NULL,	"FSFX",		S_BTYP,		0,	B_FSFX	},
    {	NULL,	"MAP",		S_BTYP,		0,	B_MAP	},

    {	NULL,	".page",	S_PAGE,		0,	0	},
    {	NULL,	".title",	S_HEADER,	0,	O_TITLE	},
    {	NULL,	".sbttl",	S_HEADER,	0,	O_SBTTL	},
    {	NULL,	".module",	S_MODUL,	0,	0	},
    {	NULL,	".include",	S_INCL,		0,	0	},
    {	NULL,	".area",	S_AREA,		0,	0	},
    {	NULL,	".bank",	S_BANK,		0,	0	},
    {	NULL,	".org",		S_ORG,		0,	0	},
    {	NULL,	".radix",	S_RADIX,	0,	0	},
    {	NULL,	".globl",	S_GLOBL,	0,	0	},
    {	NULL,	".local",	S_LOCAL,	0,	0	},
    {	NULL,	".if",		S_CONDITIONAL,	0,	O_IF	},
    {	NULL,	".iff",		S_CONDITIONAL,	0,	O_IFF	},
    {	NULL,	".ift",		S_CONDITIONAL,	0,	O_IFT	},
    {	NULL,	".iftf",	S_CONDITIONAL,	0,	O_IFTF	},
    {	NULL,	".ifdef",	S_CONDITIONAL,	0,	O_IFDEF	},
    {	NULL,	".ifndef",	S_CONDITIONAL,	0,	O_IFNDEF},
    {	NULL,	".ifgt",	S_CONDITIONAL,	0,	O_IFGT	},
    {	NULL,	".iflt",	S_CONDITIONAL,	0,	O_IFLT	},
    {	NULL,	".ifge",	S_CONDITIONAL,	0,	O_IFGE	},
    {	NULL,	".ifle",	S_CONDITIONAL,	0,	O_IFLE	},
    {	NULL,	".ifeq",	S_CONDITIONAL,	0,	O_IFEQ	},
    {	NULL,	".ifne",	S_CONDITIONAL,	0,	O_IFNE	},
    {	NULL,	".ifb",		S_CONDITIONAL,	0,	O_IFB	},
    {	NULL,	".ifnb",	S_CONDITIONAL,	0,	O_IFNB	},
    {	NULL,	".ifidn",	S_CONDITIONAL,	0,	O_IFIDN	},
    {	NULL,	".ifdif",	S_CONDITIONAL,	0,	O_IFDIF	},
    {	NULL,	".iif",		S_CONDITIONAL,	0,	O_IIF	},
    {	NULL,	".iiff",	S_CONDITIONAL,	0,	O_IIFF	},
    {	NULL,	".iift",	S_CONDITIONAL,	0,	O_IIFT	},
    {	NULL,	".iiftf",	S_CONDITIONAL,	0,	O_IIFTF	},
    {	NULL,	".iifdef",	S_CONDITIONAL,	0,	O_IIFDEF},
    {	NULL,	".iifndef",	S_CONDITIONAL,	0,	O_IIFNDEF},
    {	NULL,	".iifgt",	S_CONDITIONAL,	0,	O_IIFGT	},
    {	NULL,	".iiflt",	S_CONDITIONAL,	0,	O_IIFLT	},
    {	NULL,	".iifge",	S_CONDITIONAL,	0,	O_IIFGE	},
    {	NULL,	".iifle",	S_CONDITIONAL,	0,	O_IIFLE	},
    {	NULL,	".iifeq",	S_CONDITIONAL,	0,	O_IIFEQ	},
    {	NULL,	".iifne",	S_CONDITIONAL,	0,	O_IIFNE	},
    {	NULL,	".iifb",	S_CONDITIONAL,	0,	O_IIFB	},
    {	NULL,	".iifnb",	S_CONDITIONAL,	0,	O_IIFNB	},
    {	NULL,	".iifidn",	S_CONDITIONAL,	0,	O_IIFIDN},
    {	NULL,	".iifdif",	S_CONDITIONAL,	0,	O_IIFDIF},
    {	NULL,	".else",	S_CONDITIONAL,	0,	O_ELSE	},
    {	NULL,	".endif",	S_CONDITIONAL,	0,	O_ENDIF	},
    {	NULL,	".list",	S_LISTING,	0,	O_LIST	},
    {	NULL,	".nlist",	S_LISTING,	0,	O_NLIST	},
    {	NULL,	".equ",		S_EQU,		0,	O_EQU	},
    {	NULL,	".gblequ",	S_EQU,		0,	O_GBLEQU},
    {	NULL,	".lclequ",	S_EQU,		0,	O_LCLEQU},
    {	NULL,	".byte",	S_DATA,		0,	O_1BYTE	},
    {	NULL,	".db",		S_DATA,		0,	O_1BYTE	},
    {	NULL,	".fcb",		S_DATA,		0,	O_1BYTE	},
    {	NULL,	".word",	S_DATA,		0,	O_2BYTE	},
    {	NULL,	".dw",		S_DATA,		0,	O_2BYTE	},
    {	NULL,	".fdb",		S_DATA,		0,	O_2BYTE	},
/*    {	NULL,	".3byte",	S_DATA,		0,	O_3BYTE	},	*/
/*    {	NULL,	".triple",	S_DATA,		0,	O_3BYTE	},	*/
    {	NULL,	".4byte",	S_DATA,		0,	O_4BYTE	},
    {	NULL,	".quad",	S_DATA,		0,	O_4BYTE	},
    {	NULL,	".blkb",	S_BLK,		0,	O_1BYTE	},
    {	NULL,	".ds",		S_BLK,		0,	O_1BYTE	},
    {	NULL,	".rmb",		S_BLK,		0,	O_1BYTE	},
    {	NULL,	".rs",		S_BLK,		0,	O_1BYTE	},
    {	NULL,	".blkw",	S_BLK,		0,	O_2BYTE	},
/*    {	NULL,	".blk3",	S_BLK,		0,	O_3BYTE	},	*/
    {	NULL,	".blk4",	S_BLK,		0,	O_4BYTE	},
    {	NULL,	".ascii",	S_ASCIX,	0,	O_ASCII	},
    {	NULL,	".ascis",	S_ASCIX,	0,	O_ASCIS	},
    {	NULL,	".asciz",	S_ASCIX,	0,	O_ASCIZ	},
    {	NULL,	".str",		S_ASCIX,	0,	O_ASCII	},
    {	NULL,	".strs",	S_ASCIX,	0,	O_ASCIS	},
    {	NULL,	".strz",	S_ASCIX,	0,	O_ASCIZ	},
    {	NULL,	".fcc",		S_ASCIX,	0,	O_ASCII	},
    {	NULL,	".define",	S_DEFINE,	0,	O_DEF	},
    {	NULL,	".undefine",	S_DEFINE,	0,	O_UNDEF	},
    {	NULL,	".even",	S_BOUNDARY,	0,	O_EVEN	},
    {	NULL,	".odd",		S_BOUNDARY,	0,	O_ODD	},
    {	NULL,	".bndry",	S_BOUNDARY,	0,	O_BNDRY	},
    {	NULL,	".msg"	,	S_MSG,		0,	0	},
    {	NULL,	".assume",	S_ERROR,	0,	O_ASSUME},
    {	NULL,	".error",	S_ERROR,	0,	O_ERROR	},
    {	NULL,	".msb",		S_MSB,		0,	0	},
/*    {	NULL,	".lohi",	S_MSB,		0,	O_LOHI	},	*/
/*    {	NULL,	".hilo",	S_MSB,		0,	O_HILO	},	*/
/*    {	NULL,	".8bit",	S_BITS,		0,	O_1BYTE	},	*/
    {	NULL,	".16bit",	S_BITS,		0,	O_2BYTE	},
/*    {	NULL,	".24bit",	S_BITS,		0,	O_3BYTE	},	*/
    {	NULL,	".32bit",	S_BITS,		0,	O_4BYTE	},
    {	NULL,	".end",		S_END,		0,	0	},

	/* Macro Processor */

    {	NULL,	".macro",	S_MACRO,	0,	O_MACRO	},
    {	NULL,	".endm",	S_MACRO,	0,	O_ENDM	},
    {	NULL,	".mexit",	S_MACRO,	0,	O_MEXIT	},

    {	NULL,	".narg",	S_MACRO,	0,	O_NARG	},
    {	NULL,	".nchr",	S_MACRO,	0,	O_NCHR	},
    {	NULL,	".ntyp",	S_MACRO,	0,	O_NTYP	},

    {	NULL,	".irp",		S_MACRO,	0,	O_IRP	},
    {	NULL,	".irpc",	S_MACRO,	0,	O_IRPC	},
    {	NULL,	".rept",	S_MACRO,	0,	O_REPT	},

    {	NULL,	".nval",	S_MACRO,	0,	O_NVAL	},

    {	NULL,	".mdelete",	S_MACRO,	0,	O_MDEL	},

    	/* machine */

    {	NULL,	"addwf",	S_FW,		0,	~0	},	/* PIC:12:14:16:20 */
    {	NULL,	"addwfc",	S_FW,		0,	~0	},	/* PIC:--:--:16:20 */
    {	NULL,	"andwf",	S_FW,		0,	~0	},	/* PIC:12:14:16:20 */
    {	NULL,	"comf",		S_FW,		0,	~0	},	/* PIC:12:14:16:20 */
    {	NULL,	"decf",		S_FW,		0,	~0	},	/* PIC:12:14:16:20 */
    {	NULL,	"decfsz",	S_FW,		0,	~0	},	/* PIC:12:14:16:20 */
    {	NULL,	"dcfsnz",	S_FW,		0,	~0	},	/* PIC:--:--:16:20 */
    {	NULL,	"incf",		S_FW,		0,	~0	},	/* PIC:12:14:16:20 */
    {	NULL,	"incfsz",	S_FW,		0,	~0	},	/* PIC:12:14:16:20 */
    {	NULL,	"infsnz",	S_FW,		0,	~0	},	/* PIC:--:--:16:20 */
    {	NULL,	"iorwf",	S_FW,		0,	~0	},	/* PIC:12:14:16:20 */
    {	NULL,	"movf",		S_FW,		0,	~0	},	/* PIC:12:14:--:20 */
    {	NULL,	"negw",		S_FW,		0,	~0	},	/* PIC:--:--:16:-- */
    {	NULL,	"rlf",		S_FW,		0,	~0	},	/* PIC:12:14:--:-- */
    {	NULL,	"rlcf",		S_FW,		0,	~0	},	/* PIC:--:--:16:20 */
    {	NULL,	"rlncf",	S_FW,		0,	~0	},	/* PIC:--:--:16:20 */
    {	NULL,	"rrf",		S_FW,		0,	~0	},	/* PIC:12:14:--:-- */
    {	NULL,	"rrcf",		S_FW,		0,	~0	},	/* PIC:--:--:16:20 */
    {	NULL,	"rrncf",	S_FW,		0,	~0	},	/* PIC:--:--:16:20 */
    {	NULL,	"subfwb",	S_FW,		0,	~0	},	/* PIC:--:--:--:20 */
    {	NULL,	"subwf",	S_FW,		0,	~0	},	/* PIC:12:14:16:20 */
    {	NULL,	"subwfb",	S_FW,		0,	~0	},	/* PIC:--:--:16:20 */
    {	NULL,	"swapf",	S_FW,		0,	~0	},	/* PIC:12:14:16:20 */
    {	NULL,	"xorwf",	S_FW,		0,	~0	},	/* PIC:12:14:16:20 */

    {	NULL,	"movfp",	S_MOVFP,	0,	~0	},	/* PIC:--:--:16:-- */
    {	NULL,	"movpf",	S_MOVPF,	0,	~0	},	/* PIC:--:--:16:-- */

    {	NULL,	"movlb",	S_MOVLB,	0,	~0	},	/* PIC:--:--:16:20 */
    {	NULL,	"movlr",	S_MOVLR,	0,	~0	},	/* PIC:--:--:16:-- */

    {	NULL,	"movff",	S_MOVFF,	0,	~0	},	/* PIC:--:--:--:20 */

    {	NULL,	"lfsr",		S_LFSR,		0,	~0	},	/* PIC:--:--:--:20 */

    {	NULL,	"clrf",		S_CLRF,		0,	~0	},	/* PIC:12:14:16:20 */
    {	NULL,	"cpfseq",	S_F,		0,	~0	},	/* PIC:--:--:16:20 */
    {	NULL,	"cpfsgt",	S_F,		0,	~0	},	/* PIC:--:--:16:20 */
    {	NULL,	"cpfslt",	S_F,		0,	~0	},	/* PIC:--:--:16:20 */
    {	NULL,	"movwf",	S_F,		0,	~0	},	/* PIC:12:14:16:20 */
    {	NULL,	"mulwf",	S_F,		0,	~0	},	/* PIC:--:--:16:20 */
    {	NULL,	"negf",		S_F,		0,	~0	},	/* PIC:--:--:--:20 */
    {	NULL,	"setf",		S_SETF,		0,	~0	},	/* PIC:--:--:16:20 */
    {	NULL,	"tstfsz",	S_F,		0,	~0	},	/* PIC:--:--:16:20 */

    {	NULL,	"bcf",		S_FBIT,		0,	~0	},	/* PIC:12:14:16:20 */
    {	NULL,	"bsf",		S_FBIT,		0,	~0	},	/* PIC:12:14:16:20 */
    {	NULL,	"btfsc",	S_FBIT,		0,	~0	},	/* PIC:12:14:16:20 */
    {	NULL,	"btfss",	S_FBIT,		0,	~0	},	/* PIC:12:14:16:20 */
    {	NULL,	"btg",		S_FBIT,		0,	~0	},	/* PIC:--:--:16:20 */

    {	NULL,	"addlw",	S_LIT,		0,	~0	},	/* PIC:--:14:16:20 */
    {	NULL,	"andlw",	S_LIT,		0,	~0	},	/* PIC:12:14:16:20 */
    {	NULL,	"iorlw",	S_LIT,		0,	~0	},	/* PIC:12:14:16:20 */
    {	NULL,	"movlw",	S_LIT,		0,	~0	},	/* PIC:12:14:16:20 */
    {	NULL,	"mullw",	S_LIT,		0,	~0	},	/* PIC:--:--:16:20 */
    {	NULL,	"retlw",	S_LIT,		0,	~0	},	/* PIC:12:14:16:20 */
    {	NULL,	"sublw",	S_LIT,		0,	~0	},	/* PIC:--:14:16:20 */
    {	NULL,	"xorlw",	S_LIT,		0,	~0	},	/* PIC:12:14:16:20 */

    {	NULL,	"call",		S_CALL,		0,	~0	},	/* PIC:12:14:16:20 */
    {	NULL,	"goto",		S_GOTO,		0,	~0	},	/* PIC:12:14:16:20 */
    {	NULL,	"lcall",	S_LCALL,	0,	~0	},	/* PIC:--:--:16:-- */

    {	NULL,	"bc",		S_CBRA,		0,	~0	},	/* PIC:--:--:--:20 */
    {	NULL,	"bn",		S_CBRA,		0,	~0	},	/* PIC:--:--:--:20 */
    {	NULL,	"bnc",		S_CBRA,		0,	~0	},	/* PIC:--:--:--:20 */
    {	NULL,	"bnn",		S_CBRA,		0,	~0	},	/* PIC:--:--:--:20 */
    {	NULL,	"bnov",		S_CBRA,		0,	~0	},	/* PIC:--:--:--:20 */
    {	NULL,	"bnz",		S_CBRA,		0,	~0	},	/* PIC:--:--:--:20 */
    {	NULL,	"bov",		S_CBRA,		0,	~0	},	/* PIC:--:--:--:20 */
    {	NULL,	"bz",		S_CBRA,		0,	~0	},	/* PIC:--:--:--:20 */

    {	NULL,	"bra",		S_BRA,		0,	~0	},	/* PIC:--:--:--:20 */
    {	NULL,	"rcall",	S_BRA,		0,	~0	},	/* PIC:--:--:--:20 */

    {	NULL,	"tablrd",	S_TIF,		0,	~0	},	/* PIC:--:--:16:-- */
    {	NULL,	"tablwt",	S_TIF,		0,	~0	},	/* PIC:--:--:16:-- */
    {	NULL,	"tlrd",		S_TF,		0,	~0	},	/* PIC:--:--:16:-- */
    {	NULL,	"tlwt",		S_TF,		0,	~0	},	/* PIC:--:--:16:-- */
    {	NULL,	"tblrd",	S_TBL,		0,	~0	},	/* PIC:--:--:--:20 */
    {	NULL,	"tblwt",	S_TBL,		0,	~0	},	/* PIC:--:--:--:20 */

    {	NULL,	"clrw",		S_CLRW,		0,	~0	},	/* PIC:12:14:--:-- */
    {	NULL,	"clrwdt",	S_INH,		0,	~0	},	/* PIC:12:14:16:20 */
    {	NULL,	"daw",		S_DAW,		0,	~0	},	/* PIC:--:--:16:20 */
    {	NULL,	"nop",		S_INH,		0,	~0	},	/* PIC:12:14:16:20 */
    {	NULL,	"option",	S_INH,		0,	~0	},	/* PIC:12:14:--:-- */
    {	NULL,	"pop",		S_INH,		0,	~0	},	/* PIC:--:--:--:20 */
    {	NULL,	"push",		S_INH,		0,	~0	},	/* PIC:--:--:--:20 */
    {	NULL,	"retfie",	S_RET,		0,	~0	},	/* PIC:--:14:16:20 */
    {	NULL,	"return",	S_RET,		0,	~0	},	/* PIC:--:14:16:20 */
    {	NULL,	"sleep",	S_INH,		0,	~0	},	/* PIC:12:14:16:20 */

    {	NULL,	"tris",		S_TRIS,		0,	~0	},	/* PIC:12:14:--:-- */

	/* PIC18Fxxx Extended Instructions */

    {	NULL,	"addfsr", 	S_ADDFSR, 	0, 	~0	},	/* PIC:--:--:--:20 */
    {	NULL,	"addulnk", 	S_ADDULNK, 	0, 	~0	},	/* PIC:--:--:--:20 */
    {	NULL,	"callw",	S_INH,		0, 	~0	},	/* PIC:--:--:--:20 */
    {	NULL,	"movsf",	S_MOVSF,	0,	~0	},	/* PIC:--:--:--:20 */
    {	NULL,	"movss",	S_MOVSS,	0,	~0	},	/* PIC:--:--:--:20 */
    {	NULL,	"pushl",	S_LIT,		0,	~0	},	/* PIC:--:--:--:20 */
    {	NULL,	"subfsr", 	S_ADDFSR, 	0, 	~0	},	/* PIC:--:--:--:20 */
    {	NULL,	"subulnk", 	S_ADDULNK, 	S_EOL, 	~0	}	/* PIC:--:--:--:20 */
};


/*
 * Basic 12-Bit PIC
 *
 * PIC12C5XX CPU Type
 *	PIC12C508,	PIC12C509,	PIC12CE518
 *	PIC12C508A,	PIC12C509A,	PIC12CE519
 *	PIC12CR509A
 *
 *
 * Basic 14-Bit PIC
 *
 * PIC12C67X CPU Type
 *	PIC12C671,	PIC12C672,	PIC12LC671,	PIC12LC672
 *	PIC12CE673,	PIC12CE674,	PIC12LCE673,	PIC12LCE674
 *
 * PIC14000 CPU Type
 *	PIC14000
 *
 * PIC16C15X CPU Type
 *	PIC16C154,	PIC16C156,	PIC16C158
 *	PIC16CR154,	PIC16CR156,	PIC16CR158
 *
 * PIC16C5X CPU Type
 *	PIC16C52
 *	PIC16C54,	PICC16C54A,	PIC16C54B,	PIC16C54C
 *	PIC16CR54,	PIC16CR54A,	PIC16C54B,	PIC16CR54C
 *	PIC16C55,	PIC16C55A,	PIC16C56,	PIC16C56A
 *	PIC16CR56A
 *	PIC16C57,	PIC16CR57A,	PIC16C57B,	PIC16C57C
 *	PIC16C58A,	PIC16CR58A,	PIC16C58B,	PIC16CR58B
 *
 * PIC16C55X CPU Type
 *	PIC16C554,	PIC16C556,	PIC16C558
 *
 * PIC16C62X, PIC16C64X and, PIC16C66X CPU Types
 *	PIC16C620,	PIC16C621,	PIC16C622
 *	PIC16C642,	PIC16C662
 *
 * PIC16C7XX CPU Type
 *	PIC16C71,	PIC16C72,	PIC16CR72
 *	PIC16C73A,	PIC16C74A,	PIC16C76,	PIC16C77
 *	PIC16C710,	PIC16C711,	PIC16C715
 *
 * PIC16C8X CPU Type
 *	PIC16F83,	PIC16CR83,	PIC16F84,	PIC16CR84
 *	PIC16HV540
 *	PIC16F627,	PIC16F628
 *	PIC16F870,	PIC16F871,	PIC16F872,	PIC16F873
 *	PIC16F874,	PIC16F876,	PIC16F877
 *
 * PIC16C9XX CPU Type
 *	PIC16C923,	PIC16C924
 *
 *
 * Basic 16-Bit PIC
 *
 * PIC17CXXX CPU Type
 *	PIC17C42,	PIC17C42A,	PIC17C43,	PIC17C44
 *	PIC17C752,	PIC17C756,	PIC17C756A
 *	PIC17C762,	PIC17C766,	PIC17CR42,	PIC17CR43
 *
 *
 * Basic 20-Bit PIC
 *
 * PIC18CXXX CPU Type
 *	PIC18C242,	PIC18C252
 *	PIC18C442,	PIC18C452
 *	PIC18C658,	PIC18C858
 */

struct CpuDef picDef[] = {
    /*	Instruction	~0	PIC12	PIC14	PIC16	PIC20	*/
    {	"addwf",    {	~0,	0x01c0,	0x0700,	0x0E00,	0x2400	}   },	/* PIC:12:14:16:20 */
    {	"addwfc",   {	~0,	~0,	~0,	0x1000,	0x2000	}   },	/* PIC:--:--:16:20 */
    {	"andwf",    {	~0,	0x0140,	0x0500,	0x0A00,	0x1400	}   },	/* PIC:12:14:16:20 */
    {	"comf",	    {	~0,	0x0240,	0x0900,	0x1200,	0x1C00	}   },	/* PIC:12:14:16:20 */
    {	"decf",	    {	~0,	0x00c0,	0x0300,	0x0600,	0x0400	}   },	/* PIC:12:14:16:20 */
    {	"decfsz",   {	~0,	0x02c0,	0x0B00,	0x1600,	0x2C00	}   },	/* PIC:12:14:16:20 */
    {	"dcfsnz",   {	~0,	~0,	~0,	0x2600,	0x4C00	}   },	/* PIC:--:--:16:20 */
    {	"incf",	    {	~0,	0x0280,	0x0A00,	0x1400,	0x2800	}   },	/* PIC:12:14:16:20 */
    {	"incfsz",   {	~0,	0x03c0,	0x0F00,	0x1E00,	0x3C00	}   },	/* PIC:12:14:16:20 */
    {	"infsnz",   {	~0,	~0,	~0,	0x2400,	0x4800	}   },	/* PIC:--:--:16:20 */
    {	"iorwf",    {	~0,	0x0100,	0x0400,	0x0800,	0x1000	}   },	/* PIC:12:14:16:20 */
    {	"movf",	    {	~0,	0x0200,	0x0800,	~0,	0x5000	}   },	/* PIC:12:14:--:20 */
    {	"negw",	    {	~0,	~0,	~0,	0x2C00,	~0	}   },	/* PIC:--:--:16:-- */
    {	"rlf",	    {	~0,	0x0340,	0x0D00,	~0,	~0	}   },	/* PIC:12:14:--:-- */
    {	"rlcf",	    {	~0,	~0,	~0,	0x1A00,	0x3400	}   },	/* PIC:--:--:16:20 */
    {	"rlncf",    {	~0,	~0,	~0,	0x2200,	0x4400	}   },	/* PIC:--:--:16:20 */
    {	"rrf",	    {	~0,	0x0300,	0x0C00,	~0,	~0	}   },	/* PIC:12:14:--:-- */
    {	"rrcf",	    {	~0,	~0,	~0,	0x1800,	0x3000	}   },	/* PIC:--:--:16:20 */
    {	"rrncf",    {	~0,	~0,	~0,	0x2000,	0x4000	}   },	/* PIC:--:--:16:20 */
    {	"subfwb",   {	~0,	~0,	~0,	~0,	0x5400	}   },	/* PIC:--:--:--:20 */
    {	"subwf",    {	~0,	0x0080,	0x0200,	0x0400,	0x5C00	}   },	/* PIC:12:14:16:20 */
    {	"subwfb",   {	~0,	~0,	~0,	0x0200,	0x5800	}   },	/* PIC:--:--:16:20 */
    {	"swapf",    {	~0,	0x0380,	0x0E00,	0x1C00,	0x3800	}   },	/* PIC:12:14:16:20 */
    {	"xorwf",    {	~0,	0x0180,	0x0600,	0x0C00,	0x1800	}   },	/* PIC:12:14:16:20 */

    {	"movfp",    {	~0,	~0,	~0,	0x6000,	~0	}   },	/* PIC:--:--:16:-- */
    {	"movpf",    {	~0,	~0,	~0,	0x4000,	~0	}   },	/* PIC:--:--:16:-- */

    {	"movlb",    {	~0,	~0,	~0,	0xB800,	0x0100	}   },	/* PIC:--:--:16:20 */
    {	"movlr",    {	~0,	~0,	~0,	0xBA00,	~0	}   },	/* PIC:--:--:16:-- */

    {	"movff",    {	~0,	~0,	~0,	~0,	0xC000	}   },	/* PIC:--:--:--:20 */

    {	"lfsr",	    {	~0,	~0,	~0,	~0,	0xEE00	}   },	/* PIC:--:--:--:20 */

    {	"clrf",	    {	~0,	0x0060,	0x0180,	0x2800,	0x6A00	}   },	/* PIC:12:14:16:20 */
    {	"cpfseq",   {	~0,	~0,	~0,	0x3100,	0x6200	}   },	/* PIC:--:--:16:20 */
    {	"cpfsgt",   {	~0,	~0,	~0,	0x3200,	0x6400	}   },	/* PIC:--:--:16:20 */
    {	"cpfslt",   {	~0,	~0,	~0,	0x3000,	0x6000	}   },	/* PIC:--:--:16:20 */
    {	"movwf",    {	~0,	0x0020,	0x0080,	0x0100,	0x6e00	}   },	/* PIC:12:14:16:20 */
    {	"mulwf",    {	~0,	~0,	~0,	0x3400,	0x0200	}   },	/* PIC:--:--:16:20 */
    {	"negf",	    {	~0,	~0,	~0,	~0,	0x6C00	}   },	/* PIC:--:--:--:20 */
    {	"setf",	    {	~0,	~0,	~0,	0x2A00,	0x6800	}   },	/* PIC:--:--:16:20 */
    {	"tstfsz",   {	~0,	~0,	~0,	0x3300,	0x6600	}   },	/* PIC:--:--:16:20 */

    {	"bcf",	    {	~0,	0x0400,	0x1000,	0x8800,	0x9000	}   },	/* PIC:12:14:16:20 */
    {	"bsf",	    {	~0,	0x0500,	0x1400,	0x8000,	0x8000	}   },	/* PIC:12:14:16:20 */
    {	"btfsc",    {	~0,	0x0600,	0x1800,	0x9800,	0xB000	}   },	/* PIC:12:14:16:20 */
    {	"btfss",    {	~0,	0x0700,	0x1C00,	0x9000,	0xA000	}   },	/* PIC:12:14:16:20 */
    {	"btg",	    {	~0,	~0,	~0,	0x3800,	0x7000	}   },	/* PIC:--:--:16:20 */

    {	"addlw",    {	~0,	~0,	0x3E00,	0xB100,	0x0F00	}   },	/* PIC:--:14:16:20 */
    {	"andlw",    {	~0,	0x0e00,	0x3900,	0xB500,	0x0B00	}   },	/* PIC:12:14:16:20 */
    {	"iorlw",    {	~0,	0x0d00,	0x3800,	0xB300,	0x0900	}   },	/* PIC:12:14:16:20 */
    {	"movlw",    {	~0,	0x0c00,	0x3000,	0xB000,	0x0E00	}   },	/* PIC:12:14:16:20 */
    {	"mullw",    {	~0,	~0,	~0,	0xBC00,	0x0D00	}   },	/* PIC:--:--:16:20 */
    {	"retlw",    {	~0,	0x0800,	0x3400,	0xB600,	0x0C00	}   },	/* PIC:12:14:16:20 */
    {	"sublw",    {	~0,	~0,	0x3C00,	0xB200,	0x0800	}   },	/* PIC:--:14:16:20 */
    {	"xorlw",    {	~0,	0x0f00,	0x3A00,	0xB400,	0x0A00	}   },	/* PIC:12:14:16:20 */

    {	"call",	    {	~0,	0x0900,	0x2000,	0xE000,	0xEC00	}   },	/* PIC:12:14:16:20 */
    {	"goto",	    {	~0,	0x0a00,	0x2800,	0xC000,	0xEF00	}   },	/* PIC:12:14:16:20 */
    {	"lcall",    {	~0,	~0,	~0,	0xB700,	~0	}   },	/* PIC:--:--:16:-- */

    {	"bc",	    {	~0,	~0,	~0,	~0,	0xE200	}   },	/* PIC:--:--:--:20 */
    {	"bn",	    {	~0,	~0,	~0,	~0,	0xE600	}   },	/* PIC:--:--:--:20 */
    {	"bnc",	    {	~0,	~0,	~0,	~0,	0xE300	}   },	/* PIC:--:--:--:20 */
    {	"bnn",	    {	~0,	~0,	~0,	~0,	0xE700	}   },	/* PIC:--:--:--:20 */
    {	"bnov",	    {	~0,	~0,	~0,	~0,	0xE500	}   },	/* PIC:--:--:--:20 */
    {	"bnz",	    {	~0,	~0,	~0,	~0,	0xE100	}   },	/* PIC:--:--:--:20 */
    {	"bov",	    {	~0,	~0,	~0,	~0,	0xE400	}   },	/* PIC:--:--:--:20 */
    {	"bz",	    {	~0,	~0,	~0,	~0,	0xE000	}   },	/* PIC:--:--:--:20 */

    {	"bra",	    {	~0,	~0,	~0,	~0,	0xD000	}   },	/* PIC:--:--:--:20 */
    {	"rcall",    {	~0,	~0,	~0,	~0,	0xD800	}   },	/* PIC:--:--:--:20 */

    {	"tablrd",   {	~0,	~0,	~0,	0xA800,	~0	}   },	/* PIC:--:--:16:-- */
    {	"tablwt",   {	~0,	~0,	~0,	0xAC00,	~0	}   },	/* PIC:--:--:16:-- */
    {	"tlrd",	    {	~0,	~0,	~0,	0xA000,	~0	}   },	/* PIC:--:--:16:-- */
    {	"tlwt",	    {	~0,	~0,	~0,	0xA400,	~0	}   },	/* PIC:--:--:16:-- */
    {	"tblrd",    {	~0,	~0,	~0,	~0,	0x0008	}   },	/* PIC:--:--:--:20 */
    {	"tblwt",    {	~0,	~0,	~0,	~0,	0x000C	}   },	/* PIC:--:--:--:20 */

    {	"clrw",	    {	~0,	0x0040,	0x0100,	~0,	~0	}   },	/* PIC:12:14:--:-- */
    {	"clrwdt",   {	~0,	0x0004,	0x0064,	0x0004,	0x0004	}   },	/* PIC:12:14:16:20 */
    {	"daw",	    {	~0,	~0,	~0,	0x2E00,	0x0007	}   },	/* PIC:--:--:16:20 */
    {	"nop",	    {	~0,	0x0000,	0x0000,	0x0000,	0x0000	}   },	/* PIC:12:14:16:20 */
    {	"option",   {	~0,	0x0002,	0x0062,	~0,	~0	}   },	/* PIC:12:14:--:-- */
    {	"pop",	    {	~0,	~0,	~0,	~0,	0x0006	}   },	/* PIC:--:--:--:20 */
    {	"push",	    {	~0,	~0,	~0,	~0,	0x0005	}   },	/* PIC:--:--:--:20 */
    {	"retfie",   {	~0,	~0,	0x0009,	0x0005,	0x0010	}   },	/* PIC:--:14:16:20 */
    {	"return",   {	~0,	~0,	0x0008,	0x0002,	0x0012	}   },	/* PIC:--:14:16:20 */
    {	"sleep",    {	~0,	0x0003,	0x0063,	0x0003,	0x0003	}   },	/* PIC:12:14:16:20 */

    {	"tris",	    {	~0,	0x0000,	0x0060,	~0,	~0	}   },	/* PIC:12:14:--:-- */

	/* PIC18Fxxx Extended Instructions */

    {	"addfsr",   {	~0,	~0,	~0,	~0,	0xE800	}   },	/* PIC:--:--:--:20 */
    {	"addulnk",  {	~0,	~0,	~0,	~0,	0xE8C0	}   },	/* PIC:--:--:--:20 */
    {	"callw",    {	~0,	~0,	~0,	~0,	0x0014	}   },	/* PIC:--:--:--:20 */
    {	"movsf",    {	~0,	~0,	~0,	~0,	0xEB00	}   },	/* PIC:--:--:--:20 */
    {	"movss",    {	~0,	~0,	~0,	~0,	0xEB80	}   },	/* PIC:--:--:--:20 */
    {	"pushl",    {	~0,	~0,	~0,	~0,	0xEA00	}   },	/* PIC:--:--:--:20 */
    {	"subfsr",   {	~0,	~0,	~0,	~0,	0xE900	}   },	/* PIC:--:--:--:20 */
    {	"subulnk",  {	~0,	~0,	~0,	~0,	0xE9C0	}   },	/* PIC:--:--:--:20 */

    {	NULL,	    {	~0,	~0,	~0,	~0,	~0	}   }
};

/*
 * Known CPU Fixes
 */
struct CpuFix picFix[] = {
    /*
     * P12C67X CPU Fix
     */
    {	"P12C671",	"clrw",		0x0103	},
    {	"P12C672",	"clrw",		0x0103	},
    {	"P12CE673",	"clrw",		0x0103	},
    {	"P12CE674",	"clrw",		0x0103	},
    /*
     * End of Fixes
     */
    {	NULL,		NULL,		0x0000	}
};


