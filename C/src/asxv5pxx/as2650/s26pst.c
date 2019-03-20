/* s26pst.c */

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
#include "s2650.h"

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
    {	NULL,		&bank[0],	"_CODE",	0,	0,	0,	A_1BYTE|A_BNK|A_CSEG	},
    {	&area[0],	&bank[1],	"_DATA",	1,	0,	0,	A_1BYTE|A_BNK|A_DSEG	}
};

/*
 * Basic Relocation Mode Definition
 *
 *	#define		R_NORM	0000		No Bit Positioning
 */
char	mode0[32] = {	/* R_NORM */
	'\200',	'\201',	'\202',	'\203',	'\204',	'\205',	'\206',	'\207',
	'\210',	'\211',	'\212',	'\213',	'\214',	'\215',	'\216',	'\217',
	'\220',	'\221',	'\222',	'\223',	'\224',	'\225',	'\226',	'\227',
	'\230',	'\231',	'\232',	'\233',	'\234',	'\235',	'\236',	'\237'
};

/*
 * Additional Relocation Mode Definitions
 */
char	mode1[32] = {	/* M_2BIT instructions */
	/* |----|----|----|--KK| */
	'\200',	'\201',	'\002',	'\003',	'\004',	'\005',	'\006',	'\007',
	'\010',	'\011',	'\012',	'\013',	'\014',	'\015',	'\016',	'\017',
	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};

char	mode2[32] = {	/* M_7BIT instructions */
	/* |----|----|-KKK|KKKK| */
	'\200',	'\201',	'\202',	'\203',	'\204',	'\205',	'\206',	'\007',
	'\010',	'\011',	'\012',	'\013',	'\014',	'\015',	'\016',	'\017',
	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};

char	mode3[32] = {	/* M_13BIT instructions */
	/* |---K|KKKK|KKKK|KKKK| */
	'\200',	'\201',	'\202',	'\203',	'\204',	'\205',	'\206',	'\207',
	'\210',	'\211',	'\212',	'\213',	'\214',	'\015',	'\016',	'\017',
	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};

char	mode4[32] = {	/* M_15BIT instructions */
	/* |-KKK|KKKK|KKKK|KKKK| */
	'\200',	'\201',	'\202',	'\203',	'\204',	'\205',	'\206',	'\207',
	'\210',	'\211',	'\212',	'\213',	'\214',	'\215',	'\216',	'\017',
	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
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
struct	mode	mode[5] = {
    {	&mode0[0],	0,	0x0000FFFF,	0x0000FFFF	},
    {	&mode1[0],	0,	0x00000003,	0x00000003	},
    {	&mode2[0],	0,	0x0000007F,	0x0000007F	},
    {	&mode3[0],	0,	0x00001FFF,	0x00001FFF	},
    {	&mode4[0],	0,	0x00007FFF,	0x00007FFF	}
};

/*
 * Array of Pointers to mode Structures
 */
struct	mode	*modep[16] = {
	&mode[0],	&mode[1],	&mode[2],	&mode[3],
	&mode[4],	NULL,		NULL,		NULL,
	NULL,		NULL,		NULL,		NULL,
	NULL,		NULL,		NULL,		NULL
};

/*
 * Mnemonic Structure
 */
struct	mne	mne[] = {

	/* machine */

    {	NULL,	"CSEG",		S_ATYP,		0,	A_CSEG|A_1BYTE	},
    {	NULL,	"DSEG",		S_ATYP,		0,	A_DSEG|A_1BYTE	},

    {	NULL,	".setdp",	S_SDP,		0,	0	},

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
/*    {	NULL,	".4byte",	S_DATA,		0,	O_4BYTE	},	*/
/*    {	NULL,	".quad",	S_DATA,		0,	O_4BYTE	},	*/
    {	NULL,	".blkb",	S_BLK,		0,	O_1BYTE	},
    {	NULL,	".ds",		S_BLK,		0,	O_1BYTE	},
    {	NULL,	".rmb",		S_BLK,		0,	O_1BYTE	},
    {	NULL,	".rs",		S_BLK,		0,	O_1BYTE	},
    {	NULL,	".blkw",	S_BLK,		0,	O_2BYTE	},
/*    {	NULL,	".blk3",	S_BLK,		0,	O_3BYTE	},	*/
/*    {	NULL,	".blk4",	S_BLK,		0,	O_4BYTE	},	*/
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
/*    {	NULL,	".msb",		S_MSB,		0,	0	},	*/
/*    {	NULL,	".lohi",	S_MSB,		0,	O_LOHI	},	*/
/*    {	NULL,	".hilo",	S_MSB,		0,	O_HILO	},	*/
/*    {	NULL,	".8bit",	S_BITS,		0,	O_1BYTE	},	*/
/*    {	NULL,	".16bit",	S_BITS,		0,	O_2BYTE	},	*/
/*    {	NULL,	".24bit",	S_BITS,		0,	O_3BYTE	},	*/
/*    {	NULL,	".32bit",	S_BITS,		0,	O_4BYTE	},	*/
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

	/* S2650(A) */

    {	NULL,	"redc",		S_IO,		0,	0x30	},
    {	NULL,	"redd",		S_IO,		0,	0x70	},
    {	NULL,	"wrtc",		S_IO,		0,	0Xb0	},
    {	NULL,	"wrtd",		S_IO,		0,	0Xf0	},

    {	NULL,	"rede",		S_IOE,		0,	0x54	},
    {	NULL,	"wrte",		S_IOE,		0,	0Xd4	},

    {	NULL,	"lodr",		S_TYP1,		0,	0x08	},
    {	NULL,	"strr",		S_TYP1,		0,	0xC8	},
    {	NULL,	"addr",		S_TYP1,		0,	0x88	},
    {	NULL,	"subr",		S_TYP1,		0,	0xA8	},
    {	NULL,	"andr",		S_TYP1,		0,	0x48	},
    {	NULL,	"iorr",		S_TYP1,		0,	0x68	},
    {	NULL,	"eorr",		S_TYP1,		0,	0x28	},
    {	NULL,	"comr",		S_TYP1,		0,	0xE8	},
    {	NULL,	"cmpr",		S_TYP1,		0,	0xE8	},

    {	NULL,	"loda",		S_TYP2,		0,	0x0C	},
    {	NULL,	"stra",		S_TYP2,		0,	0xCC	},
    {	NULL,	"adda",		S_TYP2,		0,	0x8C	},
    {	NULL,	"suba",		S_TYP2,		0,	0xAC	},
    {	NULL,	"anda",		S_TYP2,		0,	0x4C	},
    {	NULL,	"iora",		S_TYP2,		0,	0x6C	},
    {	NULL,	"eora",		S_TYP2,		0,	0x2C	},
    {	NULL,	"coma",		S_TYP2,		0,	0xEC	},
    {	NULL,	"cmpa",		S_TYP2,		0,	0xEC	},

    {	NULL,	"lodi",		S_TYP3,		0,	0x04	},
    {	NULL,	"addi",		S_TYP3,		0,	0x84	},
    {	NULL,	"subi",		S_TYP3,		0,	0xA4	},
    {	NULL,	"andi",		S_TYP3,		0,	0x44	},
    {	NULL,	"iori",		S_TYP3,		0,	0x64	},
    {	NULL,	"eori",		S_TYP3,		0,	0x24	},
    {	NULL,	"comi",		S_TYP3,		0,	0xE4	},
    {	NULL,	"cmpi",		S_TYP3,		0,	0xE4	},
    {	NULL,	"tmi",		S_TYP3,		0,	0xF4	},

    {	NULL,	"lodz",		S_TYP4,		0,	0x00	},
    {	NULL,	"strz",		S_TYP4,		0,	0xC0	},
    {	NULL,	"addz",		S_TYP4,		0,	0x80	},
    {	NULL,	"subz",		S_TYP4,		0,	0xA0	},
    {	NULL,	"andz",		S_TYP4,		0,	0x40	},
    {	NULL,	"iorz",		S_TYP4,		0,	0x60	},
    {	NULL,	"eorz",		S_TYP4,		0,	0x20	},
    {	NULL,	"comz",		S_TYP4,		0,	0xE0	},
    {	NULL,	"cmpz",		S_TYP4,		0,	0xE0	},
    {	NULL,	"rrl",		S_TYP4,		0,	0xD0	},
    {	NULL,	"rrr",		S_TYP4,		0,	0x50	},
    {	NULL,	"dar",		S_TYP4,		0,	0x94	},

    {	NULL,	"ppsu",		S_TYP5,		0,	0x76	},
    {	NULL,	"ppsl",		S_TYP5,		0,	0x77	},
    {	NULL,	"cpsu",		S_TYP5,		0,	0X74	},
    {	NULL,	"cpsl",		S_TYP5,		0,	0x75	},
    {	NULL,	"tpsu",		S_TYP5,		0,	0xb4	},
    {	NULL,	"tpsl",		S_TYP5,		0,	0xB5	},

    {	NULL,	"zbrr",		S_BRAZ,		0,	0x9B	},
    {	NULL,	"zbsr",		S_BRAZ,		0,	0xBB	},

    {	NULL,	"bxa",		S_BRAE,		0,	0x9F	},
    {	NULL,	"bsxa",		S_BRAE,		0,	0xBF	},

    {	NULL,	"bctr",		S_BRCR,		0,	0x18	},
    {	NULL,	"bcfr",		S_BRCR,		0,	0x98	},
    {	NULL,	"bstr",		S_BRCR,		0,	0x38	},
    {	NULL,	"bsfr",		S_BRCR,		0,	0xB8	},

    {	NULL,	"bcta",		S_BRCA,		0,	0x1C	},
    {	NULL,	"bcfa",		S_BRCA,		0,	0x9C	},
    {	NULL,	"bsta",		S_BRCA,		0,	0x3C	},
    {	NULL,	"bsfa",		S_BRCA,		0,	0xBC	},

    {	NULL,	"birr",		S_BRRR,		0,	0xD8	},
    {	NULL,	"bdrr",		S_BRRR,		0,	0xF8	},
    {	NULL,	"brnr",		S_BRRR,		0,	0x58	},
    {	NULL,	"bsnr",		S_BRRR,		0,	0x78	},

    {	NULL,	"bira",		S_BRRA,		0,	0xDC	},
    {	NULL,	"bdra",		S_BRRA,		0,	0xFC	},
    {	NULL,	"brna",		S_BRRA,		0,	0x5C	},
    {	NULL,	"bsna",		S_BRRA,		0,	0x7C	},

    {	NULL,	"retc",		S_RET,		0,	0x14	},
    {	NULL,	"rete",		S_RET,		0,	0x34	},

    {	NULL,	"lpsu",		S_INH,		0,	0x92	},
    {	NULL,	"lpsl",		S_INH,		0,	0x93	},
    {	NULL,	"spsu",		S_INH,		0,	0x12	},
    {	NULL,	"spsl",		S_INH,		0,	0x13	},
    {	NULL,	"nop",		S_INH,		0,	0xC0	},
    {	NULL,	"halt",		S_INH,		0,	0x40	},
    {	NULL,	"wait",		S_INH,		S_EOL,	0x40	}
};


