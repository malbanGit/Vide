/* s6186pst.c */

/*
 *  Copyright (C) 2003-2009  Alan R. Baldwin
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
 *
 * Ported for SC61860 by Edgar Puehringer
 */

#include "asxxxx.h"
#include "s61860.h"

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
 * Basic Relocation Mode Definitions
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
 *
 * Specification for the 6-bit addressing mode:
 */
char mode1[32] = {	/* R_6BIT */
	'\200',	'\201',	'\202',	'\203',	'\204',	'\205',	'\006',	'\007',
	'\010',	'\011',	'\012',	'\013',	'\014',	'\015',	'\016',	'\017',
	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};

/*
 * Specification for the 13-bit addressing mode:
 */
char mode2[32] = {	/* R_13BIT */
	'\200',	'\201',	'\202',	'\203',	'\204',	'\205',	'\206',	'\207',
	'\210',	'\211',	'\212',	'\213',	'\214',	'\015',	'\016',	'\017',
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
struct	mode	mode[3] = {
    {	&mode0[0],	0,	0x0000FFFF,	0x0000FFFF	},
    {	&mode1[0],	0,	0x0000003F,	0x0000003F	},
    {	&mode2[0],	0,	0x00001FFF,	0x00001FFF	}
};

/*
 * Array of Pointers to mode Structures
 */
struct	mode	*modep[16] = {
	&mode[0],	&mode[1],	&mode[2],	NULL,
	NULL,		NULL,		NULL,		NULL,
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

    {	NULL,	".case",	S_CASE,	        0,	0	},
    {	NULL,	".default",	S_DEFA,	        0,	0	},
    {	NULL,	".sbasic",	S_BASIC,        0,	0	},

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

	/* 61860 */

    {	NULL,	"ix",		S_INH,		0,	0x04	},
    {	NULL,	"dx",		S_INH,		0,	0x05	},
    {	NULL,	"iy",		S_INH,		0,	0x06	},
    {	NULL,	"dy",		S_INH,		0,	0x07	},
    {	NULL,	"mvw",		S_INH,		0,	0x08	},
    {	NULL,	"exw",		S_INH,		0,	0x09	},
    {	NULL,	"mvb",		S_INH,		0,	0x0a	},
    {	NULL,	"exb",		S_INH,		0,	0x0b	},
    {	NULL,	"adn",		S_INH,		0,	0x0c	},
    {	NULL,	"sbn",		S_INH,		0,	0x0d	},
    {	NULL,	"adw",		S_INH,		0,	0x0e	},
    {	NULL,	"sbw",		S_INH,		0,	0x0f	},
    {	NULL,	"adb",		S_INH,		0,	0x14	},
    {	NULL,	"sbb",		S_INH,		0,	0x15	},
    {	NULL,	"mvwd",		S_INH,		0,	0x18	},
    {	NULL,	"exwd",		S_INH,		0,	0x19	},
    {	NULL,	"mvbd",		S_INH,		0,	0x1a	},
    {	NULL,	"exbd",		S_INH,		0,	0x1b	},
    {	NULL,	"srw",		S_INH,		0,	0x1c	},
    {	NULL,	"slw",		S_INH,		0,	0x1d	},
    {	NULL,	"film",		S_INH,		0,	0x1e	},
    {	NULL,	"fild",		S_INH,		0,	0x1f	},
    {	NULL,	"ldp",		S_INH,		0,	0x20	},
    {	NULL,	"ldq",		S_INH,		0,	0x21	},
    {	NULL,	"ldr",		S_INH,		0,	0x22	},
    {	NULL,	"clra",		S_INH,		0,	0x23	},
    {	NULL,	"ra",		S_INH,		0,	0x23	},
    {	NULL,	"ixl",		S_INH,		0,	0x24	},
    {	NULL,	"dxl",		S_INH,		0,	0x25	},
    {	NULL,	"iys",		S_INH,		0,	0x26	},
    {	NULL,	"dys",		S_INH,		0,	0x27	},
    {	NULL,	"stp",		S_INH,		0,	0x30	},
    {	NULL,	"stq",		S_INH,		0,	0x31	},
    {	NULL,	"str",		S_INH,		0,	0x32	},
    {	NULL,	"push",		S_INH,		0,	0x34	},
    {	NULL,	"rst",		S_INH,		0,	0x35	},
    {	NULL,	"data",		S_INH,		0,	0x35	},
    {	NULL,	"rtn",		S_INH,		0,	0x37	},
    {	NULL,	"inci",		S_INH,		0,	0x40	},
    {	NULL,	"deci",		S_INH,		0,	0x41	},
    {	NULL,	"inca",		S_INH,		0,	0x42	},
    {	NULL,	"deca",		S_INH,		0,	0x43	},
    {	NULL,	"adm",		S_INH,		0,	0x44	},
    {	NULL,	"sbm",		S_INH,		0,	0x45	},
    {	NULL,	"anma",		S_INH,		0,	0x46	},
    {	NULL,	"orma",		S_INH,		0,	0x47	},
    {	NULL,	"inck",		S_INH,		0,	0x48	},
    {	NULL,	"deck",		S_INH,		0,	0x49	},
    {	NULL,	"incm",		S_INH,		0,	0x4a	},
    {	NULL,	"decm",		S_INH,		0,	0x4b	},
    {	NULL,	"ina",		S_INH,		0,	0x4c	},
    {	NULL,	"nopw",		S_INH,		0,	0x4d	},
    {	NULL,	"cup",		S_INH,		0,	0x4f	},
    {	NULL,	"waitj",	S_INH,		0,	0x4f	},
    {	NULL,	"wait1",	S_INH,		0,	0x4f	},
    {	NULL,	"incp",		S_INH,		0,	0x50	},
    {	NULL,	"decp",		S_INH,		0,	0x51	},
    {	NULL,	"std",		S_INH,		0,	0x52	},
    {	NULL,	"mvdm",		S_INH,		0,	0x53	},
    {	NULL,	"readm",       	S_INH,		0,	0x54	},
    {	NULL,	"mvmd",		S_INH,		0,	0x55	},
    {	NULL,	"read",		S_INH,		0,	0x56	},
    {	NULL,	"ldd",		S_INH,		0,	0x57	},
    {	NULL,	"swp",		S_INH,		0,	0x58	},
    {	NULL,	"ldm",		S_INH,		0,	0x59	},
    {	NULL,	"sl",		S_INH,		0,	0x5a	},
    {	NULL,	"pop",		S_INH,		0,	0x5b	},
    {	NULL,	"outa",		S_INH,		0,	0x5d	},
    {	NULL,	"outf",		S_INH,		0,	0x5f	},
    {	NULL,	"dtc",       	S_INH,		0,	0x69	},
    {	NULL,	"dtj",       	S_INH,		0,	0x69	},
    {	NULL,	"cpcal",       	S_INH,		0,	0x69	},
    {	NULL,	"case2",       	S_INH,		0,	0x69	},
    {	NULL,	"jst",		S_INH,		0,	0x69	},
    {	NULL,	"cdn",		S_INH,		0,	0x6f	},
    {	NULL,	"waiti",	S_INH,		0,	0x6f	},
    {	NULL,	"wait0",	S_INH,		0,	0x6f	},
    {	NULL,	"ptc",       	S_PTC,		0,	0x7a	},
    {	NULL,	"ptj",       	S_PTC,		0,	0x7a	},
    {	NULL,	"dtlra",       	S_PTC,		0,	0x7a	},
    {	NULL,	"case1",       	S_PTC,		0,	0x7a	},
    {	NULL,	"sett",		S_PTC,		0,	0x7a	},
    {	NULL,	"incj",		S_INH,		0,	0xc0	},
    {	NULL,	"decj",		S_INH,		0,	0xc1	},
    {	NULL,	"incb",		S_INH,		0,	0xc2	},
    {	NULL,	"decb",		S_INH,		0,	0xc3	},
    {	NULL,	"adcm",		S_INH,		0,	0xc4	},
    {	NULL,	"sbcm",		S_INH,		0,	0xc5	},
    {	NULL,	"tsma",		S_INH,		0,	0xc6	},
    {	NULL,	"cpma",		S_INH,		0,	0xc7	},
    {	NULL,	"incl",		S_INH,		0,	0xc8	},
    {	NULL,	"decl",		S_INH,		0,	0xc9	},
    {	NULL,	"incn",		S_INH,		0,	0xca	},
    {	NULL,	"decn",		S_INH,		0,	0xcb	},
    {	NULL,	"inb",		S_INH,		0,	0xcc	},
    {	NULL,	"nopt",		S_INH,		0,	0xce	},
    {	NULL,	"sc",		S_INH,		0,	0xd0	},
    {	NULL,	"rc",		S_INH,		0,	0xd1	},
    {	NULL,	"sr",		S_INH,		0,	0xd2	},
    {   NULL,   "writ",         S_INH,          0,      0xd3    },
    {	NULL,	"leave",       	S_INH,		0,	0xd8	},
    {	NULL,	"exab",		S_INH,		0,	0xda	},
    {	NULL,	"exam",		S_INH,		0,	0xdb	},
    {	NULL,	"outb",		S_INH,		0,	0xdd	},
    {	NULL,	"outc",		S_INH,		0,	0xdf	},
    {	NULL,	"tsip",       	S_INH,		0,	0xc6	},

    {	NULL,	"lii",		S_ADI,		0,      0x00	},
    {	NULL,	"lij",       	S_ADI,		0,	0x01	},
    {	NULL,	"lia",       	S_ADI,		0,	0x02	},
    {	NULL,	"lib",       	S_ADI,		0,	0x03	},
    {	NULL,	"lidl",       	S_ADI,		0,	0x11	},
    {	NULL,	"lip",       	S_ADI,		0,	0x12	},
    {	NULL,	"liq",       	S_ADI,		0,	0x13	},
    {	NULL,	"wait",       	S_ADI,		0,	0x4e	},
    {	NULL,	"anim",       	S_ADI,		0,	0x60	},
    {	NULL,	"orim",       	S_ADI,		0,	0x61	},
    {	NULL,	"tsim",       	S_ADI,		0,	0x62	},
    {	NULL,	"cpim",       	S_ADI,		0,	0x63	},
    {	NULL,	"ania",       	S_ADI,		0,	0x64	},
    {	NULL,	"oria",       	S_ADI,		0,	0x65	},
    {	NULL,	"tsia",       	S_ADI,		0,	0x66	},
    {	NULL,	"cpia",       	S_ADI,		0,	0x67	},
    {	NULL,	"test",       	S_ADI,		0,	0x6b	},
    {	NULL,	"adim",       	S_ADI,		0,	0x70	},
    {	NULL,	"sbim",       	S_ADI,		0,	0x71	},
    {	NULL,	"adia",       	S_ADI,		0,	0x74	},
    {	NULL,	"sbia",       	S_ADI,		0,	0x75	},
    {	NULL,	"anid",       	S_ADI,		0,	0xd4	},
    {	NULL,	"orid",       	S_ADI,		0,	0xd5	},
    {	NULL,	"tsid",       	S_ADI,		0,	0xd6	},

    {	NULL,	"lidp",       	S_JMP,		0,	0x10	},
    {	NULL,	"call",       	S_JMP,		0,	0x78	},
    {	NULL,	"jp",      	S_JMP,		0,	0x79	},
    {	NULL,	"jpnz",      	S_JMP,		0,	0x7c	},
    {	NULL,	"jpnc",       	S_JMP,		0,	0x7d	},
    {	NULL,	"jpz",		S_JMP,		0,	0x7e	},
    {	NULL,	"jpc",       	S_JMP,		0,	0x7f	},

    {	NULL,	"cal",       	S_CAL,		0,	0xe0	},

    {	NULL,	"lp",       	S_LP,		0,	0x80	},

    {	NULL,	"jrnzp",       	S_JRP,		0,	0x28	},
    {	NULL,	"jrnzm",       	S_JRM,		0,	0x29	},
    {	NULL,	"jrncp",       	S_JRP,		0,	0x2a	},
    {	NULL,	"jrncm",       	S_JRM,		0,	0x2b	},
    {	NULL,	"jrp",       	S_JRP,		0,	0x2c	},
    {	NULL,	"jrm",       	S_JRM,		0,	0x2d	},
    {	NULL,	"loop",       	S_JRM,		0,	0x2f	},
    {	NULL,	"jrzp",       	S_JRP,		0,	0x38	},
    {	NULL,	"jrzm",       	S_JRM,		0,	0x39	},
    {	NULL,	"jrcp",       	S_JRP,		0,	0x3a	},
    {	NULL,	"jrcm",       	S_JRM,		S_EOL,	0x3b	}
};
