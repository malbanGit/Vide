/* m00pst.c */

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
#include "m6800.h"

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

	/* 6800/6802/6808 */

    {	NULL,	"bra",		S_BRA,		0,	0x20	},
    {	NULL,	"bhi",		S_BRA,		0,	0x22	},
    {	NULL,	"bls",		S_BRA,		0,	0x23	},
    {	NULL,	"bcc",		S_BRA,		0,	0x24	},
    {	NULL,	"bhs",		S_BRA,		0,	0x24	},
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
    {	NULL,	"bsr",		S_BRA,		0,	0x8D	},

    {	NULL,	"neg",		S_TYP1,		0,	0x40	},
    {	NULL,	"com",		S_TYP1,		0,	0x43	},
    {	NULL,	"lsr",		S_TYP1,		0,	0x44	},
    {	NULL,	"ror",		S_TYP1,		0,	0x46	},
    {	NULL,	"asr",		S_TYP1,		0,	0x47	},
    {	NULL,	"asl",		S_TYP1,		0,	0x48	},
    {	NULL,	"lsl",		S_TYP1,		0,	0x48	},
    {	NULL,	"rol",		S_TYP1,		0,	0x49	},
    {	NULL,	"dec",		S_TYP1,		0,	0x4A	},
    {	NULL,	"inc",		S_TYP1,		0,	0x4C	},
    {	NULL,	"tst",		S_TYP1,		0,	0x4D	},
    {	NULL,	"clr",		S_TYP1,		0,	0x4F	},

    {	NULL,	"sub",		S_TYP2,		0,	0x80	},
    {	NULL,	"cmp",		S_TYP2,		0,	0x81	},
    {	NULL,	"sbc",		S_TYP2,		0,	0x82	},
    {	NULL,	"and",		S_TYP2,		0,	0x84	},
    {	NULL,	"bit",		S_TYP2,		0,	0x85	},
    {	NULL,	"lda",		S_TYP2,		0,	0x86	},
    {	NULL,	"sta",		S_TYP2,		0,	0x87	},
    {	NULL,	"eor",		S_TYP2,		0,	0x88	},
    {	NULL,	"adc",		S_TYP2,		0,	0x89	},
    {	NULL,	"ora",		S_TYP2,		0,	0x8A	},
    {	NULL,	"add",		S_TYP2,		0,	0x8B	},

    {	NULL,	"suba",		S_TYP3,		0,	0x80	},
    {	NULL,	"subb",		S_TYP3,		0,	0xC0	},
    {	NULL,	"cmpa",		S_TYP3,		0,	0x81	},
    {	NULL,	"cmpb",		S_TYP3,		0,	0xC1	},
    {	NULL,	"sbca",		S_TYP3,		0,	0x82	},
    {	NULL,	"sbcb",		S_TYP3,		0,	0xC2	},
    {	NULL,	"anda",		S_TYP3,		0,	0x84	},
    {	NULL,	"andb",		S_TYP3,		0,	0xC4	},
    {	NULL,	"bita",		S_TYP3,		0,	0x85	},
    {	NULL,	"bitb",		S_TYP3,		0,	0xC5	},
    {	NULL,	"ldaa",		S_TYP3,		0,	0x86	},
    {	NULL,	"ldab",		S_TYP3,		0,	0xC6	},
    {	NULL,	"staa",		S_TYP3,		0,	0x87	},
    {	NULL,	"stab",		S_TYP3,		0,	0xC7	},
    {	NULL,	"eora",		S_TYP3,		0,	0x88	},
    {	NULL,	"eorb",		S_TYP3,		0,	0xC8	},
    {	NULL,	"adca",		S_TYP3,		0,	0x89	},
    {	NULL,	"adcb",		S_TYP3,		0,	0xC9	},
    {	NULL,	"oraa",		S_TYP3,		0,	0x8A	},
    {	NULL,	"orab",		S_TYP3,		0,	0xCA	},
    {	NULL,	"adda",		S_TYP3,		0,	0x8B	},
    {	NULL,	"addb",		S_TYP3,		0,	0xCB	},

    {	NULL,	"cpx",		S_TYP4,		0,	0x8C	},
    {	NULL,	"cmpx",		S_TYP4,		0,	0x8C	},
    {	NULL,	"lds",		S_TYP4,		0,	0x8E	},
    {	NULL,	"ldx",		S_TYP4,		0,	0xCE	},
    {	NULL,	"sts",		S_TYP4,		0,	0x8F	},
    {	NULL,	"stx",		S_TYP4,		0,	0xCF	},

    {	NULL,	"jmp",		S_TYP5,		0,	0x6E	},
    {	NULL,	"jsr",		S_TYP5,		0,	0xAD	},

    {	NULL,	"aba",		S_INH,		0,	0x1B	},
    {	NULL,	"asla",		S_INH,		0,	0x48	},
    {	NULL,	"aslb",		S_INH,		0,	0x58	},
    {	NULL,	"lsla",		S_INH,		0,	0x48	},
    {	NULL,	"lslb",		S_INH,		0,	0x58	},
    {	NULL,	"asra",		S_INH,		0,	0x47	},
    {	NULL,	"asrb",		S_INH,		0,	0x57	},
    {	NULL,	"cba",		S_INH,		0,	0x11	},
    {	NULL,	"clc",		S_INH,		0,	0x0C	},
    {	NULL,	"cli",		S_INH,		0,	0x0E	},
    {	NULL,	"clra",		S_INH,		0,	0x4F	},
    {	NULL,	"clrb",		S_INH,		0,	0x5F	},
    {	NULL,	"clv",		S_INH,		0,	0x0A	},
    {	NULL,	"coma",		S_INH,		0,	0x43	},
    {	NULL,	"comb",		S_INH,		0,	0x53	},
    {	NULL,	"daa",		S_INH,		0,	0x19	},
    {	NULL,	"deca",		S_INH,		0,	0x4A	},
    {	NULL,	"decb",		S_INH,		0,	0x5A	},
    {	NULL,	"des",		S_INH,		0,	0x34	},
    {	NULL,	"dex",		S_INH,		0,	0x09	},
    {	NULL,	"inca",		S_INH,		0,	0x4C	},
    {	NULL,	"incb",		S_INH,		0,	0x5C	},
    {	NULL,	"ins",		S_INH,		0,	0x31	},
    {	NULL,	"inx",		S_INH,		0,	0x08	},
    {	NULL,	"lsra",		S_INH,		0,	0x44	},
    {	NULL,	"lsrb",		S_INH,		0,	0x54	},
    {	NULL,	"nega",		S_INH,		0,	0x40	},
    {	NULL,	"negb",		S_INH,		0,	0x50	},
    {	NULL,	"nop",		S_INH,		0,	0x01	},
    {	NULL,	"psha",		S_INH,		0,	0x36	},
    {	NULL,	"pshb",		S_INH,		0,	0x37	},
    {	NULL,	"pula",		S_INH,		0,	0x32	},
    {	NULL,	"pulb",		S_INH,		0,	0x33	},
    {	NULL,	"rola",		S_INH,		0,	0x49	},
    {	NULL,	"rolb",		S_INH,		0,	0x59	},
    {	NULL,	"rora",		S_INH,		0,	0x46	},
    {	NULL,	"rorb",		S_INH,		0,	0x56	},
    {	NULL,	"rti",		S_INH,		0,	0x3B	},
    {	NULL,	"rts",		S_INH,		0,	0x39	},
    {	NULL,	"sba",		S_INH,		0,	0x10	},
    {	NULL,	"sec",		S_INH,		0,	0x0D	},
    {	NULL,	"sei",		S_INH,		0,	0x0F	},
    {	NULL,	"sev",		S_INH,		0,	0x0B	},
    {	NULL,	"swi",		S_INH,		0,	0x3F	},
    {	NULL,	"tab",		S_INH,		0,	0x16	},
    {	NULL,	"tap",		S_INH,		0,	0x06	},
    {	NULL,	"tba",		S_INH,		0,	0x17	},
    {	NULL,	"tpa",		S_INH,		0,	0x07	},
    {	NULL,	"tsta",		S_INH,		0,	0x4D	},
    {	NULL,	"tstb",		S_INH,		0,	0x5D	},
    {	NULL,	"tsx",		S_INH,		0,	0x30	},
    {	NULL,	"txs",		S_INH,		0,	0x35	},
    {	NULL,	"wai",		S_INH,		0,	0x3E	},

    {	NULL,	"pul",		S_PUL,		0,	0x32	},
    {	NULL,	"psh",		S_PUL,		S_EOL,	0x36	}
};


