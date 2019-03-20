/* h8pst.c */

/*
 *  Copyright (C) 1994-2009  Alan R. Baldwin
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
#include "h8.h"

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

/* None Required */

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
struct	mode	mode[1] = {
    {	&mode0[0],	0,	0x0000FFFF,	0x0000FFFF	}
};

/*
 * Array of Pointers to mode Structures
 */
struct	mode	*modep[16] = {
	&mode[0],	NULL,		NULL,		NULL,
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

					/*	0 = xxx		*/
	/* H8/3xx */			/*	1 = xxx.b	*/
					/*	2 = xxx.w	*/

    {	NULL,	"adds",		S_OPS,		0,	0x0B00	},
    {	NULL,	"subs",		S_OPS,		0,	0x1B00	},

    {	NULL,	"adds.w",	S_OPS,		2,	0x0B00	},
    {	NULL,	"subs.w",	S_OPS,		2,	0x1B00	},

    {	NULL,	"add",		S_ADD,		0,	0x8008	},
    {	NULL,	"addx",		S_OPX,		0,	0x900E	},
    {	NULL,	"cmp",		S_CMP,		0,	0xA01C	},
    {	NULL,	"subx",		S_OPX,		0,	0xB01E	},
    {	NULL,	"or",		S_OP,		0,	0xC014	},
    {	NULL,	"xor",		S_OP,		0,	0xD015	},
    {	NULL,	"and",		S_OP,		0,	0xE016	},
    {	NULL,	"mov",		S_MOV,		0,	0xF00C	},

    {	NULL,	"add.b",	S_ADD,		1,	0x8008	},
    {	NULL,	"addx.b",	S_OP,		1,	0x900E	},
    {	NULL,	"cmp.b",	S_CMP,		1,	0xA01C	},
    {	NULL,	"subx.b",	S_OP,		1,	0xB01E	},
    {	NULL,	"or.b",		S_OP,		1,	0xC014	},
    {	NULL,	"xor.b",	S_OP,		1,	0xD015	},
    {	NULL,	"and.b",	S_OP,		1,	0xE016	},
    {	NULL,	"mov.b",	S_MOV,		1,	0xF00C	},

    {	NULL,	"add.w",	S_ADD,		2,	0x8009	},
    {	NULL,	"cmp.w",	S_CMP,		2,	0xA01D	},
    {	NULL,	"mov.w",	S_MOV,		2,	0xF00D	},

    {	NULL,	"sub",		S_SUB,		0,	0x0018	},
    {	NULL,	"sub.b",	S_SUB,		1,	0x0018	},
    {	NULL,	"sub.w",	S_SUB,		2,	0x0019	},

    {	NULL,	"orc",		S_CCR,		0,	0x0400	},
    {	NULL,	"xorc",		S_CCR,		0,	0x0500	},
    {	NULL,	"andc",		S_CCR,		0,	0x0600	},
    {	NULL,	"ldc",		S_CCR,		1,	0x0700	},
    {	NULL,	"stc",		S_CCR,		2,	0x0200	},

    {	NULL,	"inc",		S_SOP,		0,	0x0A00	},
    {	NULL,	"daa",		S_SOP,		0,	0x0F00	},
    {	NULL,	"dec",		S_SOP,		0,	0x1A00	},
    {	NULL,	"das",		S_SOP,		0,	0x1F00	},

    {	NULL,	"inc.b",	S_SOP,		1,	0x0A00	},
    {	NULL,	"daa.b",	S_SOP,		1,	0x0F00	},
    {	NULL,	"dec.b",	S_SOP,		1,	0x1A00	},
    {	NULL,	"das.b",	S_SOP,		1,	0x1F00	},

    {	NULL,	"not",		S_SOP,		0,	0x1700	},
    {	NULL,	"neg",		S_SOP,		0,	0x1780	},

    {	NULL,	"not.b",	S_SOP,		1,	0x1700	},
    {	NULL,	"neg.b",	S_SOP,		1,	0x1780	},

    {	NULL,	"nop",		S_INH,		0,	0x0000	},
    {	NULL,	"sleep",	S_INH,		0,	0x0180	},
    {	NULL,	"rts",		S_INH,		0,	0x5470	},
    {	NULL,	"rte",		S_INH,		0,	0x5670	},

    {	NULL,	"mulxu",	S_MLDV,		0,	0x5000	},
    {	NULL,	"divxu",	S_MLDV,		0,	0x5100	},

    {	NULL,	"mulxu.b",	S_MLDV,		1,	0x5000	},
    {	NULL,	"divxu.b",	S_MLDV,		1,	0x5100	},

    {	NULL,	"shll",		S_ROSH,		0,	0x1000	},
    {	NULL,	"shal",		S_ROSH,		0,	0x1080	},
    {	NULL,	"shlr",		S_ROSH,		0,	0x1100	},
    {	NULL,	"shar",		S_ROSH,		0,	0x1180	},
    {	NULL,	"rotxl",	S_ROSH,		0,	0x1200	},
    {	NULL,	"rotl",		S_ROSH,		0,	0x1280	},
    {	NULL,	"rotxr",	S_ROSH,		0,	0x1300	},
    {	NULL,	"rotr",		S_ROSH,		0,	0x1380	},

    {	NULL,	"shll.b",	S_ROSH,		1,	0x1000	},
    {	NULL,	"shal.b",	S_ROSH,		1,	0x1080	},
    {	NULL,	"shlr.b",	S_ROSH,		1,	0x1100	},
    {	NULL,	"shar.b",	S_ROSH,		1,	0x1180	},
    {	NULL,	"rotxl.b",	S_ROSH,		1,	0x1200	},
    {	NULL,	"rotl.b",	S_ROSH,		1,	0x1280	},
    {	NULL,	"rotxr.b",	S_ROSH,		1,	0x1300	},
    {	NULL,	"rotr.b",	S_ROSH,		1,	0x1380	},

    {	NULL,	"pop",		S_PP,		0,	0x6D70	},
    {	NULL,	"push",		S_PP,		0,	0x6DF0	},

    {	NULL,	"pop.w",	S_PP,		2,	0x6D70	},
    {	NULL,	"push.w",	S_PP,		2,	0x6DF0	},

    {	NULL,	"movfpe",	S_MVFPE,	0,	0x6A40	},
    {	NULL,	"movtpe",	S_MVTPE,	0,	0x6AC0	},

    {	NULL,	"movfpe.b",	S_MVFPE,	0,	0x6A40	},
    {	NULL,	"movtpe.b",	S_MVTPE,	0,	0x6AC0	},

    {	NULL,	"eepmov",	S_EEPMOV,	0,	0x7B5C	},

    {	NULL,	"jmp",		S_JXX,		0,	0x5900	},
    {	NULL,	"jsr",		S_JXX,		0,	0x5D00	},

    {	NULL,	"bset",		S_BIT1,		0,	0x6000	},
    {	NULL,	"bnot",		S_BIT1,		0,	0x6100	},
    {	NULL,	"bclr",		S_BIT1,		0,	0x6200	},
    {	NULL,	"btst",		S_BIT1,		0,	0x6300	},

    {	NULL,	"bst",		S_BIT2,		0,	0x6700	},
    {	NULL,	"bist",		S_BIT2,		0,	0x6780	},
    {	NULL,	"bor",		S_BIT2,		0,	0x7400	},
    {	NULL,	"bior",		S_BIT2,		0,	0x7480	},
    {	NULL,	"bxor",		S_BIT2,		0,	0x7500	},
    {	NULL,	"bixor",	S_BIT2,		0,	0x7580	},
    {	NULL,	"band",		S_BIT2,		0,	0x7600	},
    {	NULL,	"biand",	S_BIT2,		0,	0x7680	},
    {	NULL,	"bld",		S_BIT2,		0,	0x7700	},
    {	NULL,	"bild",		S_BIT2,		0,	0x7780	},

    {	NULL,	"bra",		S_BRA,		0,	0x4000	},
    {	NULL,	"bt",		S_BRA,		0,	0x4000	},
    {	NULL,	"brn",		S_BRA,		0,	0x4100	},
    {	NULL,	"bf",		S_BRA,		0,	0x4100	},
    {	NULL,	"bhi",		S_BRA,		0,	0x4200	},
    {	NULL,	"bls",		S_BRA,		0,	0x4300	},
    {	NULL,	"blos",		S_BRA,		0,	0x4300	},
    {	NULL,	"bcc",		S_BRA,		0,	0x4400	},
    {	NULL,	"bhs",		S_BRA,		0,	0x4400	},
    {	NULL,	"bhis",		S_BRA,		0,	0x4400	},
    {	NULL,	"bcs",		S_BRA,		0,	0x4500	},
    {	NULL,	"blo",		S_BRA,		0,	0x4500	},
    {	NULL,	"bne",		S_BRA,		0,	0x4600	},
    {	NULL,	"beq",		S_BRA,		0,	0x4700	},
    {	NULL,	"bvc",		S_BRA,		0,	0x4800	},
    {	NULL,	"bvs",		S_BRA,		0,	0x4900	},
    {	NULL,	"bpl",		S_BRA,		0,	0x4A00	},
    {	NULL,	"bmi",		S_BRA,		0,	0x4B00	},
    {	NULL,	"bge",		S_BRA,		0,	0x4C00	},
    {	NULL,	"blt",		S_BRA,		0,	0x4D00	},
    {	NULL,	"bgt",		S_BRA,		0,	0x4E00	},
    {	NULL,	"ble",		S_BRA,		0,	0x4F00	},
    {	NULL,	"bsr",		S_BRA,		S_EOL,	0x5500	}
};
