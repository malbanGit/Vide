/* M09PST.C */

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

	/* 6800 Compatibility */

#if	!M6809STRICT
    {	NULL,	"ldaa",		S_ACC,		0,	0x86	},
    {	NULL,	"ldab",		S_ACC,		0,	0xC6	},
    {	NULL,	"oraa",		S_ACC,		0,	0x8A	},
    {	NULL,	"orab",		S_ACC,		0,	0xCA	},
    {	NULL,	"staa",		S_STR,		0,	0x87	},
    {	NULL,	"stab",		S_STR,		0,	0xC7	},

	/* if this is changed, change struct opdata mc6800[] */

    {	NULL,	"aba",		S_6800,		0,	0	},
    {	NULL,	"cba",		S_6800,		0,	1	},
    {	NULL,	"clc",		S_6800,		0,	2	},
    {	NULL,	"cli",		S_6800,		0,	3	},
    {	NULL,	"clv",		S_6800,		0,	4	},
    {	NULL,	"des",		S_6800,		0,	5	},
    {	NULL,	"dex",		S_6800,		0,	6	},
    {	NULL,	"ins",		S_6800,		0,	7	},
    {	NULL,	"inx",		S_6800,		0,	8	},
    {	NULL,	"psha",		S_6800,		0,	9	},
    {	NULL,	"pshb",		S_6800,		0,	10	},
    {	NULL,	"pula",		S_6800,		0,	11	},
    {	NULL,	"pulb",		S_6800,		0,	12	},
    {	NULL,	"sba",		S_6800,		0,	13	},
    {	NULL,	"sec",		S_6800,		0,	14	},
    {	NULL,	"sei",		S_6800,		0,	15	},
    {	NULL,	"sev",		S_6800,		0,	16	},
    {	NULL,	"tab",		S_6800,		0,	17	},
    {	NULL,	"tap",		S_6800,		0,	18	},
    {	NULL,	"tba",		S_6800,		0,	19	},
    {	NULL,	"tpa",		S_6800,		0,	20	},
    {	NULL,	"tsx",		S_6800,		0,	21	},
    {	NULL,	"txs",		S_6800,		0,	22	},
    {	NULL,	"wai",		S_6800,		0,	23	},
#endif

	/* 6809 */

    {	NULL,	"sty",		S_STR1,		0,	0x8F	},
    {	NULL,	"sts",		S_STR1,		0,	0xCF	},

    {	NULL,	"sta",		S_STR,		0,	0x87	},
    {	NULL,	"stb",		S_STR,		0,	0xC7	},
    {	NULL,	"std",		S_STR,		0,	0xCD	},
    {	NULL,	"stx",		S_STR,		0,	0x8F	},
    {	NULL,	"stu",		S_STR,		0,	0xCF	},
    {	NULL,	"jsr",		S_STR,		0,	0x8D	},

    {	NULL,	"cmpu",		S_LR2,		0,	0x83	},
    {	NULL,	"cmps",		S_LR2,		0,	0x8C	},

    {	NULL,	"cmpd",		S_LR1,		0,	0x83	},
    {	NULL,	"cmpy",		S_LR1,		0,	0x8C	},
    {	NULL,	"ldy",		S_LR1,		0,	0x8E	},
    {	NULL,	"lds",		S_LR1,		0,	0xCE	},

    {	NULL,	"subd",		S_LR,		0,	0x83	},
    {	NULL,	"addd",		S_LR,		0,	0xC3	},
    {	NULL,	"cmpx",		S_LR,		0,	0x8C	},
#if	!M6809STRICT
    {	NULL,	"cpx",		S_LR,		0,	0x8C	},
#endif
    {	NULL,	"ldd",		S_LR,		0,	0xCC	},
    {	NULL,	"ldx",		S_LR,		0,	0x8E	},
    {	NULL,	"ldu",		S_LR,		0,	0xCE	},
    {	NULL,	"ldq",		S_LRQ,		0,	0xCD	},

    {	NULL,	"leax",		S_LEA,		0,	0x30	},
    {	NULL,	"leay",		S_LEA,		0,	0x31	},
    {	NULL,	"leas",		S_LEA,		0,	0x32	},
    {	NULL,	"leau",		S_LEA,		0,	0x33	},

    {	NULL,	"pshs",		S_PULS,		0,	0x34	},
    {	NULL,	"puls",		S_PULS,		0,	0x35	},
    {	NULL,	"pshu",		S_PULU,		0,	0x36	},
    {	NULL,	"pulu",		S_PULU,		0,	0x37	},

    {	NULL,	"exg",		S_EXG,		0,	0x1E	},
    {	NULL,	"tfr",		S_EXG,		0,	0x1F	},

    {	NULL,	"addr",		S_IR,		0,	0x30	},
    {	NULL,	"adcr",		S_IR,		0,	0x31	},
    {	NULL,	"subr",		S_IR,		0,	0x32	},
    {	NULL,	"sbcr",		S_IR,		0,	0x33	},
    {	NULL,	"andr",		S_IR,		0,	0x34	},
    {	NULL,	"orr",		S_IR,		0,	0x35	},
    {	NULL,	"eorr",		S_IR,		0,	0x36	},
    {	NULL,	"cmpr",		S_IR,		0,	0x37	},

    {	NULL,	"cwai",		S_CC,		0,	0x3C	},
    {	NULL,	"orcc",		S_CC,		0,	0x1A	},
    {	NULL,	"andcc",	S_CC,		0,	0x1C	},

    {	NULL,	"swi3",		S_INH2,		0,	0x3F	},
    {	NULL,	"swi2",		S_INH1,		0,	0x3F	},
#if	!M6809STRICT
    {	NULL,	"swi1",		S_INH,		0,	0x3F	},
#endif

    {	NULL,	"abx",		S_INH,		0,	0x3A	},
    {	NULL,	"asla",		S_INH,		0,	0x48	},
    {	NULL,	"aslb",		S_INH,		0,	0x58	},
    {	NULL,	"asra",		S_INH,		0,	0x47	},
    {	NULL,	"asrb",		S_INH,		0,	0x57	},
    {	NULL,	"clra",		S_INH,		0,	0x4F	},
    {	NULL,	"clrb",		S_INH,		0,	0x5F	},
    {	NULL,	"coma",		S_INH,		0,	0x43	},
    {	NULL,	"comb",		S_INH,		0,	0x53	},
    {	NULL,	"daa",		S_INH,		0,	0x19	},
    {	NULL,	"deca",		S_INH,		0,	0x4A	},
    {	NULL,	"decb",		S_INH,		0,	0x5A	},
    {	NULL,	"inca",		S_INH,		0,	0x4C	},
    {	NULL,	"incb",		S_INH,		0,	0x5C	},
    {	NULL,	"lsla",		S_INH,		0,	0x48	},
    {	NULL,	"lslb",		S_INH,		0,	0x58	},
    {	NULL,	"lsra",		S_INH,		0,	0x44	},
    {	NULL,	"lsrb",		S_INH,		0,	0x54	},
    {	NULL,	"mul",		S_INH,		0,	0x3D	},
    {	NULL,	"nega",		S_INH,		0,	0x40	},
    {	NULL,	"negb",		S_INH,		0,	0x50	},
    {	NULL,	"nop",		S_INH,		0,	0x12	},
    {	NULL,	"rola",		S_INH,		0,	0x49	},
    {	NULL,	"rolb",		S_INH,		0,	0x59	},
    {	NULL,	"rora",		S_INH,		0,	0x46	},
    {	NULL,	"rorb",		S_INH,		0,	0x56	},
    {	NULL,	"rti",		S_INH,		0,	0x3B	},
    {	NULL,	"rts",		S_INH,		0,	0x39	},
    {	NULL,	"sex",		S_INH,		0,	0x1D	},
    {	NULL,	"swi",		S_INH,		0,	0x3F	},
    {	NULL,	"sync",		S_INH,		0,	0x13	},
    {	NULL,	"tsta",		S_INH,		0,	0x4D	},
    {	NULL,	"tstb",		S_INH,		0,	0x5D	},

    {	NULL,	"lbrn",		S_LBRA,		0,	0x21	},
    {	NULL,	"lbhi",		S_LBRA,		0,	0x22	},
    {	NULL,	"lbls",		S_LBRA,		0,	0x23	},
#if	!M6809STRICT
    {	NULL,	"lblos",	S_LBRA,		0,	0x23	},
#endif
    {	NULL,	"lbcc",		S_LBRA,		0,	0x24	},
    {	NULL,	"lbhs",		S_LBRA,		0,	0x24	},
#if	!M6809STRICT
    {	NULL,	"lbhis",	S_LBRA,		0,	0x24	},
#endif
    {	NULL,	"lbcs",		S_LBRA,		0,	0x25	},
    {	NULL,	"lblo",		S_LBRA,		0,	0x25	},
    {	NULL,	"lbne",		S_LBRA,		0,	0x26	},
    {	NULL,	"lbeq",		S_LBRA,		0,	0x27	},
    {	NULL,	"lbvc",		S_LBRA,		0,	0x28	},
    {	NULL,	"lbvs",		S_LBRA,		0,	0x29	},
    {	NULL,	"lbpl",		S_LBRA,		0,	0x2A	},
    {	NULL,	"lbmi",		S_LBRA,		0,	0x2B	},
    {	NULL,	"lbge",		S_LBRA,		0,	0x2C	},
    {	NULL,	"lblt",		S_LBRA,		0,	0x2D	},
    {	NULL,	"lbgt",		S_LBRA,		0,	0x2E	},
    {	NULL,	"lble",		S_LBRA,		0,	0x2F	},

    {	NULL,	"lbra",		S_LBSR,		0,	0x16	},
    {	NULL,	"lbsr",		S_LBSR,		0,	0x17	},

    {	NULL,	"neg",		S_SOP,		0,	0x40	},
    {	NULL,	"oim",		S_SOP,		0,	0x41	},
    {	NULL,	"aim",		S_SOP,		0,	0x42	},
    {	NULL,	"com",		S_SOP,		0,	0x43	},
    {	NULL,	"lsr",		S_SOP,		0,	0x44	},
    {	NULL,	"eim",		S_SOP,		0,	0x45	},
    {	NULL,	"ror",		S_SOP,		0,	0x46	},
    {	NULL,	"asr",		S_SOP,		0,	0x47	},
    {	NULL,	"asl",		S_SOP,		0,	0x48	},
    {	NULL,	"lsl",		S_SOP,		0,	0x48	},
    {	NULL,	"rol",		S_SOP,		0,	0x49	},
    {	NULL,	"dec",		S_SOP,		0,	0x4A	},
    {	NULL,	"tim",		S_SOP,		0,	0x4B	},
    {	NULL,	"inc",		S_SOP,		0,	0x4C	},
    {	NULL,	"tst",		S_SOP,		0,	0x4D	},
    {	NULL,	"clr",		S_SOP,		0,	0x4F	},
    {	NULL,	"jmp",		S_SOP,		0,	0x4E	},

    {	NULL,	"suba",		S_ACC,		0,	0x80	},
    {	NULL,	"subb",		S_ACC,		0,	0xC0	},
    {	NULL,	"cmpa",		S_ACC,		0,	0x81	},
    {	NULL,	"cmpb",		S_ACC,		0,	0xC1	},
    {	NULL,	"sbca",		S_ACC,		0,	0x82	},
    {	NULL,	"sbcb",		S_ACC,		0,	0xC2	},
    {	NULL,	"anda",		S_ACC,		0,	0x84	},
    {	NULL,	"andb",		S_ACC,		0,	0xC4	},
    {	NULL,	"bita",		S_ACC,		0,	0x85	},
    {	NULL,	"bitb",		S_ACC,		0,	0xC5	},
    {	NULL,	"lda",		S_ACC,		0,	0x86	},
    {	NULL,	"ldb",		S_ACC,		0,	0xC6	},
    {	NULL,	"eora",		S_ACC,		0,	0x88	},
    {	NULL,	"eorb",		S_ACC,		0,	0xC8	},
    {	NULL,	"adca",		S_ACC,		0,	0x89	},
    {	NULL,	"adcb",		S_ACC,		0,	0xC9	},
    {	NULL,	"ora",		S_ACC,		0,	0x8A	},
    {	NULL,	"orb",		S_ACC,		0,	0xCA	},
    {	NULL,	"adda",		S_ACC,		0,	0x8B	},
    {	NULL,	"addb",		S_ACC,		0,	0xCB	},

    {	NULL,	"bra",		S_BRA,		0,	0x20	},
    {	NULL,	"brn",		S_BRA,		0,	0x21	},
    {	NULL,	"bhi",		S_BRA,		0,	0x22	},
    {	NULL,	"bls",		S_BRA,		0,	0x23	},
#if	!M6809STRICT
    {	NULL,	"blos",		S_BRA,		0,	0x23	},
#endif
    {	NULL,	"bcc",		S_BRA,		0,	0x24	},
    {	NULL,	"bhs",		S_BRA,		0,	0x24	},
#if	!M6809STRICT
    {	NULL,	"bhis",		S_BRA,		0,	0x24	},
#endif
    {	NULL,	"bcs",		S_BRA,		0,	0x25	},
    {	NULL,	"blo",		S_BRA,		0,	0x25	},
    {	NULL,	"bne",		S_BRA,		0,	0x26	},
    {	NULL,	"beq",		S_BRA,		0,	0x27	},
    {	NULL,	"bvc",		S_BRA,		0,	0x28	},
    {	NULL,	"bvs",		S_BRA,		0,	0x29	},
    {	NULL,	"bpl",		S_BRA,		0,	0x2A	},
    {	NULL,	"bmi",		S_BRA,		0,	0x2B	},
    {	NULL,	"bge",		S_BRA,		0,	0x2C	},
    {	NULL,	"blt",		S_BRA,		0,	0x2D	},
    {	NULL,	"bgt",		S_BRA,		0,	0x2E	},
    {	NULL,	"ble",		S_BRA,		0,	0x2F	},

		/* New to the 6309 - prebyte 0x10 */

    {	NULL,	"negd",		S_INH1,		0,	0x40	},
    {	NULL,	"comd",		S_INH1,		0,	0x43	},
    {	NULL,	"lsrd",		S_INH1,		0,	0x44	},
    {	NULL,	"rord",		S_INH1,		0,	0x46	},
    {	NULL,	"asrd",		S_INH1,		0,	0x47	},
    {	NULL,	"asld",		S_INH1,		0,	0x48	},
    {	NULL,	"rold",		S_INH1,		0,	0x49	},
    {	NULL,	"decd",		S_INH1,		0,	0x4A	},
    {	NULL,	"incd",		S_INH1,		0,	0x4C	},
    {	NULL,	"tstd",		S_INH1,		0,	0x4D	},
    {	NULL,	"clrd",		S_INH1,		0,	0x4F	},

    {	NULL,	"comw",		S_INH1,		0,	0x53	},
    {	NULL,	"lsrw",		S_INH1,		0,	0x54	},
    {	NULL,	"rorw",		S_INH1,		0,	0x56	},
    {	NULL,	"rolw",		S_INH1,		0,	0x59	},
    {	NULL,	"decw",		S_INH1,		0,	0x5A	},
    {	NULL,	"incw",		S_INH1,		0,	0x5C	},
    {	NULL,	"tstw",		S_INH1,		0,	0x5D	},
    {	NULL,	"clrw",		S_INH1,		0,	0x5F	},

    {	NULL,	"subw",		S_LR1,		0,	0x80	},
    {	NULL,	"cmpw",		S_LR1,		0,	0x81	},
    {	NULL,	"sbcd",		S_LR1,		0,	0x82	},
    {	NULL,	"andd",		S_LR1,		0,	0x84	},
    {	NULL,	"bitd",		S_LR1,		0,	0x85	},
    {	NULL,	"ldw",		S_LR1,		0,	0x86	},
    {	NULL,	"stw",		S_STR1,		0,	0x87	},
    {	NULL,	"eord",		S_LR1,		0,	0x88	},
    {	NULL,	"adcd",		S_LR1,		0,	0x89	},
    {	NULL,	"ord",		S_LR1,		0,	0x8A	},
    {	NULL,	"addw",		S_LR1,		0,	0x8B	},

		/* New to the 6309 - prebyte 0x11 */

    {	NULL,	"bitmd",	S_IMM2,		0,	0x3C	},
    {	NULL,	"ldmd",		S_IMM2,		0,	0x3D	},

    {	NULL,	"come",		S_INH2,		0,	0x43	},
    {	NULL,	"dece",		S_INH2,		0,	0x4A	},
    {	NULL,	"ince",		S_INH2,		0,	0x4C	},
    {	NULL,	"tste",		S_INH2,		0,	0x4D	},
    {	NULL,	"clre",		S_INH2,		0,	0x4F	},

    {	NULL,	"comf",		S_INH2,		0,	0x53	},
    {	NULL,	"decf",		S_INH2,		0,	0x5A	},
    {	NULL,	"incf",		S_INH2,		0,	0x5C	},
    {	NULL,	"tstf",		S_INH2,		0,	0x5D	},
    {	NULL,	"clrf",		S_INH2,		0,	0x5F	},

    {	NULL,	"sube",		S_LR2,		0,	0x80	},
    {	NULL,	"cmpe",		S_LR2,		0,	0x81	},
    {	NULL,	"lde",		S_LR2,		0,	0x86	},
    {	NULL,	"ste",		S_STR2,		0,	0x87	},
    {	NULL,	"adde",		S_LR2,		0,	0x8B	},
    {	NULL,	"divd",		S_LR2,		0,	0x8D	},
    {	NULL,	"muld",		S_LR2,		0,	0x8F	},

    {	NULL,	"subf",		S_LR2,		0,	0xC0	},
    {	NULL,	"cmpf",		S_LR2,		0,	0xC1	},
    {	NULL,	"ldf",		S_LR2,		0,	0xC6	},
    {	NULL,	"stf",		S_STR2,		0,	0xC7	},
    {	NULL,	"addf",		S_LR2,		0,	0xCB	},

    {	NULL,	"bsr",		S_BRA,		S_EOL,	0x8D	}
};

#if	!M6809STRICT
struct opdata mc6800[] = {

    {{	(char) 0x34, (char) 0x04,	/*	pshs	b	;aba	*/
	(char) 0xab, (char) 0xe0	/*	adda	,s+	*/	}},

    {{	(char) 0x34, (char) 0x04,	/*	pshs	b	;cba	*/
	(char) 0xa1, (char) 0xe0	/*	cmpa	,s+	*/	}},

    {{	(char) 0x1c, (char) 0xfe,	/*	andcc	#0xFE	;clc	*/
	(char) 0x00, (char) 0x00	}},

    {{	(char) 0x1c, (char) 0xef,	/*	andcc	#0xEF	;cli	*/
	(char) 0x00, (char) 0x00	}},

    {{	(char) 0x1c, (char) 0xfd,	/*	andcc	#0xFD	;clv	*/
	(char) 0x00, (char) 0x00	}},

    {{	(char) 0x32, (char) 0x7f,	/*	leas	-1,s	;des	*/
	(char) 0x00, (char) 0x00	}},

    {{	(char) 0x30, (char) 0x1f,	/*	leax	-1,x	;dex	*/
	(char) 0x00, (char) 0x00	}},

    {{	(char) 0x32, (char) 0x61,	/*	leas	1,s	;ins	*/
	(char) 0x00, (char) 0x00	}},

    {{	(char) 0x30, (char) 0x01,	/*	leax	1,x	;inx	*/
	(char) 0x00, (char) 0x00	}},

    {{	(char) 0x34, (char) 0x02,	/*	pshs	a	;psha	*/
	(char) 0x00, (char) 0x00	}},

    {{	(char) 0x34, (char) 0x04,	/*	pshs	b	;pshb	*/
	(char) 0x00, (char) 0x00	}},

    {{	(char) 0x35, (char) 0x02,	/*	puls	a	;pula	*/
	(char) 0x00, (char) 0x00	}},

    {{	(char) 0x35, (char) 0x04,	/*	puls	b	;pulb	*/
	(char) 0x00, (char) 0x00	}},

    {{	(char) 0x34, (char) 0x04,	/*	pshs	b	;sba	*/
	(char) 0xa0, (char) 0xe0	/*	suba	,s+	*/	}},

    {{	(char) 0x1a, (char) 0x01,	/*	orcc	#0x01	;sec	*/
	(char) 0x00, (char) 0x00	}},

    {{	(char) 0x1a, (char) 0x10,	/*	orcc	#0x10	;sei	*/
	(char) 0x00, (char) 0x00	}},

    {{	(char) 0x1a, (char) 0x02,	/*	orcc	#0x02	;sev	*/
	(char) 0x00, (char) 0x00	}},

    {{	(char) 0x1f, (char) 0x89,	/*	tfr	a,b	;tab	*/
	(char) 0x4d, (char) 0x00	/*	tsta	*/	}},

    {{	(char) 0x1f, (char) 0x8a,	/*	tfr	a,cc	;tap	*/
	(char) 0x00, (char) 0x00	}},

    {{	(char) 0x1f, (char) 0x98,	/*	tfr	b,a	;tba	*/
	(char) 0x5d, (char) 0x00	/*	tstb	*/	}},

    {{	(char) 0x1f, (char) 0xa8,	/*	tfr	cc,a	;tpa	*/
	(char) 0x00, (char) 0x00	}},

    {{	(char) 0x1f, (char) 0x41,	/*	tfr	s,x	;tsx	*/
	(char) 0x00, (char) 0x00	}},

    {{	(char) 0x1f, (char) 0x14,	/*	tfr	x,s	;txs	*/
	(char) 0x00, (char) 0x00	}},

    {{	(char) 0x3c, (char) 0xff,	/*	cwai	#0xFF	;wai	*/
	(char) 0x00, (char) 0x00	}}
};
#endif
