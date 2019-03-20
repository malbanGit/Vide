/* m12pst.c */

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
#include "m6812.h"

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
char	mode1[32] = {	/* M_XBRA 9-Bit Branching Instructions */
	/* |---K|----|KKKK|KKKK| */
	'\200',	'\201',	'\202',	'\203',	'\204',	'\205',	'\206',	'\207',
	'\214',	'\011',	'\012',	'\013',	'\014',	'\015',	'\016',	'\017',
	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};


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
struct	mode	mode[2] = {
    {	&mode0[0],	0,	0x0000FFFF,	0x0000FFFF	},
    {	&mode1[0],	0,	0x000010FF,	0x000001FF	}
};

/*
 * Array of Pointers to mode Structures
 */
struct	mode	*modep[16] = {
	&mode[0],	&mode[1],	NULL,		NULL,
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

	/* Machines */

    {	NULL,	".hc12",	S_CPU,		0,	X_HC12	},
    {	NULL,	".hcs12",	S_CPU,		0,	X_HCS12	},

	/* 6811 Compatibility */

	/* If this is changed, change struct opdata mc6811[] */

    {	NULL,	"abx",		S_6811,		0,	0	},
    {	NULL,	"aby",		S_6811,		0,	1	},
    {	NULL,	"clc",		S_6811,		0,	2	},
    {	NULL,	"cli",		S_6811,		0,	3	},
    {	NULL,	"clv",		S_6811,		0,	4	},
    {	NULL,	"des",		S_6811,		0,	5	},
    {	NULL,	"ins",		S_6811,		0,	6	},
    {	NULL,	"sec",		S_6811,		0,	7	},
    {	NULL,	"sei",		S_6811,		0,	8	},
    {	NULL,	"sev",		S_6811,		0,	9	},
    {	NULL,	"tap",		S_6811,		0,	10	},
    {	NULL,	"tpa",		S_6811,		0,	11	},
    {	NULL,	"tsx",		S_6811,		0,	12	},
    {	NULL,	"tsy",		S_6811,		0,	13	},
    {	NULL,	"txs",		S_6811,		0,	14	},
    {	NULL,	"tys",		S_6811,		0,	15	},
    {	NULL,	"xgdx",		S_6811,		0,	16	},
    {	NULL,	"xgdy",		S_6811,		0,	17	},

	/* 6812 */

	/* Relative Branches */
	/* op rr */

    {	NULL,	"bra",		S_BRA,		0,	0x20	},
    {	NULL,	"brn",		S_BRA,		0,	0x21	},
    {	NULL,	"bhi",		S_BRA,		0,	0x22	},
    {	NULL,	"bls",		S_BRA,		0,	0x23	},
    {	NULL,	"blos",		S_BRA,		0,	0x23	},
    {	NULL,	"bcc",		S_BRA,		0,	0x24	},
    {	NULL,	"bhs",		S_BRA,		0,	0x24	},
    {	NULL,	"bhis",		S_BRA,		0,	0x24	},
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
    {	NULL,	"bsr",		S_BRA,		0,	0x07	},

	/* Relative Long Branches */
	/* 18 op qq rr */

    {	NULL,	"lbra",		S_LBRA,		0,	0x20	},
    {	NULL,	"lbrn",		S_LBRA,		0,	0x21	},
    {	NULL,	"lbhi",		S_LBRA,		0,	0x22	},
    {	NULL,	"lbls",		S_LBRA,		0,	0x23	},
    {	NULL,	"lblos",	S_LBRA,		0,	0x23	},
    {	NULL,	"lbcc",		S_LBRA,		0,	0x24	},
    {	NULL,	"lbhs",		S_LBRA,		0,	0x24	},
    {	NULL,	"lbhis",	S_LBRA,		0,	0x24	},
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

	/* Inc/Dec/Tst Register and Branch Instructions */
	/* op lb rr */

    {	NULL,	"dbeq",		S_XBRA,		0,	0x00	},
    {	NULL,	"dbne",		S_XBRA,		0,	0x20	},
    {	NULL,	"ibeq",		S_XBRA,		0,	0x80	},
    {	NULL,	"ibne",		S_XBRA,		0,	0xA0	},
    {	NULL,	"tbeq",		S_XBRA,		0,	0x40	},
    {	NULL,	"tbne",		S_XBRA,		0,	0x60	},

	/* Single Operand - SOP		*/
	/* EXT		op hh ll	*/
	/* IDX		op xb		*/
	/* IDX1		op xb ff	*/
	/* IDX2		op xb ee ff	*/
	/* [D,IDX]	op xb		*/
	/* [IDX2]	op xb ee ff	*/

    {	NULL,	"neg",		S_SOP,		0,	0x60	},
    {	NULL,	"com",		S_SOP,		0,	0x61	},
    {	NULL,	"inc",		S_SOP,		0,	0x62	},
    {	NULL,	"dec",		S_SOP,		0,	0x63	},
    {	NULL,	"lsr",		S_SOP,		0,	0x64	},
    {	NULL,	"rol",		S_SOP,		0,	0x65	},
    {	NULL,	"ror",		S_SOP,		0,	0x66	},
    {	NULL,	"asr",		S_SOP,		0,	0x67	},
    {	NULL,	"asl",		S_SOP,		0,	0x68	},
    {	NULL,	"lsl",		S_SOP,		0,	0x68	},
    {	NULL,	"clr",		S_SOP,		0,	0x69	},
    {	NULL,	"tst",		S_SOP,		0,	0xE7	},

	/* Double Operand - DOP		*/
	/* IMM		op ii		*/
	/* DIR		op dd		*/
	/* EXT		op hh ll	*/
	/* IDX		op xb		*/
	/* IDX1		op xb ff	*/
	/* IDX2		op xb ee ff	*/
	/* [D,IDX]	op xb		*/
	/* [IDX2]	op xb ee ff	*/

    {	NULL,	"suba",		S_DOP,		0,	0x80	},
    {	NULL,	"subb",		S_DOP,		0,	0xC0	},
    {	NULL,	"cmpa",		S_DOP,		0,	0x81	},
    {	NULL,	"cmpb",		S_DOP,		0,	0xC1	},
    {	NULL,	"sbca",		S_DOP,		0,	0x82	},
    {	NULL,	"sbcb",		S_DOP,		0,	0xC2	},
    {	NULL,	"anda",		S_DOP,		0,	0x84	},
    {	NULL,	"andb",		S_DOP,		0,	0xC4	},
    {	NULL,	"bita",		S_DOP,		0,	0x85	},
    {	NULL,	"bitb",		S_DOP,		0,	0xC5	},
    {	NULL,	"lda",		S_DOP,		0,	0x86	},
    {	NULL,	"ldaa",		S_DOP,		0,	0x86	},
    {	NULL,	"ldb",		S_DOP,		0,	0xC6	},
    {	NULL,	"ldab",		S_DOP,		0,	0xC6	},
    {	NULL,	"eora",		S_DOP,		0,	0x88	},
    {	NULL,	"eorb",		S_DOP,		0,	0xC8	},
    {	NULL,	"adca",		S_DOP,		0,	0x89	},
    {	NULL,	"adcb",		S_DOP,		0,	0xC9	},
    {	NULL,	"ora",		S_DOP,		0,	0x8A	},
    {	NULL,	"oraa",		S_DOP,		0,	0x8A	},
    {	NULL,	"orb",		S_DOP,		0,	0xCA	},
    {	NULL,	"orab",		S_DOP,		0,	0xCA	},
    {	NULL,	"adda",		S_DOP,		0,	0x8B	},
    {	NULL,	"addb",		S_DOP,		0,	0xCB	},

	/* Store Instructions - STR	*/
	/* DIR		op dd		*/
	/* EXT		op hh ll	*/
	/* IDX		op xb		*/
	/* IDX1		op xb ff	*/
	/* IDX2		op xb ee ff	*/
	/* [D,IDX]	op xb		*/
	/* [IDX2]	op xb ee ff	*/

    {	NULL,	"staa",		S_STR,		0,	0x4A	},
    {	NULL,	"sta",		S_STR,		0,	0x4A	},
    {	NULL,	"stab",		S_STR,		0,	0x4B	},
    {	NULL,	"stb",		S_STR,		0,	0x4B	},
    {	NULL,	"std",		S_STR,		0,	0x4C	},
    {	NULL,	"sty",		S_STR,		0,	0x4D	},
    {	NULL,	"stx",		S_STR,		0,	0x4E	},
    {	NULL,	"sts",		S_STR,		0,	0x4F	},

	/* Long Register Operand - LONG	*/
	/* IMM		op jj kk	*/
	/* DIR		op dd		*/
	/* EXT		op hh ll	*/
	/* IDX		op xb		*/
	/* IDX1		op xb ff	*/
	/* IDX2		op xb ee ff	*/
	/* [D,IDX]	op xb		*/
	/* [IDX2]	op xb ee ff	*/

    {	NULL,	"addd",		S_LONG,		0,	0xC3	},
    {	NULL,	"subd",		S_LONG,		0,	0x83	},
    {	NULL,	"cpd",		S_LONG,		0,	0x8C	},
    {	NULL,	"cmpd",		S_LONG,		0,	0x8C	},
    {	NULL,	"cpy",		S_LONG,		0,	0x8D	},
    {	NULL,	"cmpy",		S_LONG,		0,	0x8D	},
    {	NULL,	"cpx",		S_LONG,		0,	0x8E	},
    {	NULL,	"cmpx",		S_LONG,		0,	0x8E	},
    {	NULL,	"cps",		S_LONG,		0,	0x8F	},
    {	NULL,	"cmps",		S_LONG,		0,	0x8F	},
    {	NULL,	"ldd",		S_LONG,		0,	0xCC	},
    {	NULL,	"ldy",		S_LONG,		0,	0xCD	},
    {	NULL,	"ldx",		S_LONG,		0,	0xCE	},
    {	NULL,	"lds",		S_LONG,		0,	0xCF	},

	/* JMP and JSR Instructions	*/
	/* DIR		op dd		*/
	/* EXT		op hh ll	*/
	/* IDX		op xb		*/
	/* IDX1		op xb ff	*/
	/* IDX2		op xb ee ff	*/
	/* [D,IDX]	op xb		*/
	/* [IDX2]	op xb ee ff	*/
	/* ---------------------------- */
	/* JMP DIR	ILLEGAL		*/

    {	NULL,	"jmp",		S_JMP,		0,	0x05	},
    {	NULL,	"jsr",		S_JSR,		0,	0x15	},

	/* CALL Instruction		*/
	/* EXT		op hh ll pg	*/
	/* IDX		op xb pg	*/
	/* IDX1		op xb ff pg	*/
	/* IDX2		op xb ee ff pg	*/
	/* [D,IDX]	op xb		*/
	/* [IDX2]	op xb ee ff	*/

    {	NULL,	"call",		S_CALL,		0,	0x4A	},

	/* Load Effective Address Instructions	*/
	/* IDX		op xb			*/
	/* ID1		op xb ff		*/
	/* ID2		op xb ee ff		*/

    {	NULL,	"leay",		S_LEA,		0,	0x19	},
    {	NULL,	"leax",		S_LEA,		0,	0x1A	},
    {	NULL,	"leas",		S_LEA,		0,	0x1B	},

	/* EMACS Instruction		*/
	/* EXT		18 op hh ll	*/

    {	NULL,	"emacs",	S_EMACS,	0,	0x12	},

	/* Min / Max Operations 	*/
	/* IDX		op xb		*/
	/* IDX1		op xb ff	*/
	/* IDX2		op xb ee ff	*/
	/* [D,IDX]	op xb		*/
	/* [IDX2]	op xb ee ff	*/

    {	NULL,	"maxa",		S_EMNMX,	0,	0x18	},
    {	NULL,	"mina",		S_EMNMX,	0,	0x19	},
    {	NULL,	"maxm",		S_EMNMX,	0,	0x1C	},
    {	NULL,	"minm",		S_EMNMX,	0,	0x1D	},
    {	NULL,	"emaxd",	S_EMNMX,	0,	0x1A	},
    {	NULL,	"emind",	S_EMNMX,	0,	0x1B	},
    {	NULL,	"emaxm",	S_EMNMX,	0,	0x1E	},
    {	NULL,	"eminm",	S_EMNMX,	0,	0x1F	},

	/* Move byte/word Operations 		*/
	/* IMM - EXT	18 op ii hh ll		*/
	/* IMM - IDX	18 op xb ii		*/
	/* EXT - EXT	18 op hh ll hh ll	*/
	/* EXT - IDX	18 op xb hh ll		*/
	/* IDX - EXT	18 op xb hh ll		*/
	/* IDX - IDX	18 op xb xb		*/

    {	NULL,	"movb",		S_MOVB,		0,	0x08	},
    {	NULL,	"movw",		S_MOVW,		0,	0x00	},

	/* Register <--> Register transfer instructions	*/
	/* INH		op eb				*/

    {	NULL,	"sex",		S_SEX,		0,	0xB7	},
    {	NULL,	"tfr",		S_TFR,		0,	0xB7	},
    {	NULL,	"exg",		S_EXG,		0,	0xB7	},

	/* Table Lookup Instructions	*/
	/* IDX		18 op xb	*/

    {	NULL,	"tbl",		S_TBL,		0,	0x3D	},
    {	NULL,	"etbl",		S_TBL,		0,	0x3F	},

	/* TRAP Instructions		*/
	/* INH		18 0x30 - 0x39	*/
	/* INH		18 0x40 - 0xFF	*/

    {	NULL,	"trap",		S_TRAP,		0,	0x18	},

	/* Bit SET / CLR Instructions	*/
	/* DIR		op dd mm	*/
	/* EXT		op hh ll mm	*/
	/* IDX		op xb mm	*/
	/* IDX1		op xb ff mm	*/
	/* IDX2		op xb ee ff mm	*/

    {	NULL,	"bset",		S_BIT,		0,	0x0C	},
    {	NULL,	"bclr",		S_BIT,		0,	0x0D	},

	/* Branch on				*/
	/* Bit SET / CLR Instructions		*/
	/* DIR		op dd mm rr		*/
	/* EXT		op hh ll mm rr		*/
	/* IDX		op xb mm rr		*/
	/* IDX1		op xb ff mm rr		*/
	/* IDX2		op xb ee ff mm rr	*/

    {	NULL,	"brset",	S_BRBIT,	0,	0x0E	},
    {	NULL,	"brclr",	S_BRBIT,	0,	0x0F	},

	/* Condition Code Instructions	*/
	/* IMM		op ii		*/

    {	NULL,	"andcc",	S_CC,		0,	0x10	},
    {	NULL,	"orcc",		S_CC,		0,	0x14	},

	/* Page1 Inherent Instructions	*/
	/* INH		op		*/

    {	NULL,	"asla",		S_INH,		0,	0x48	},
    {	NULL,	"aslb",		S_INH,		0,	0x58	},
    {	NULL,	"asld",		S_INH,		0,	0x59	},
    {	NULL,	"asra",		S_INH,		0,	0x47	},
    {	NULL,	"asrb",		S_INH,		0,	0x57	},
    {	NULL,	"bgnd",		S_INH,		0,	0x00	},
    {	NULL,	"clra",		S_INH,		0,	0x87	},
    {	NULL,	"clrb",		S_INH,		0,	0xC7	},
    {	NULL,	"coma",		S_INH,		0,	0x41	},
    {	NULL,	"comb",		S_INH,		0,	0x51	},
    {	NULL,	"deca",		S_INH,		0,	0x43	},
    {	NULL,	"decb",		S_INH,		0,	0x53	},
    {	NULL,	"dex",		S_INH,		0,	0x09	},
    {	NULL,	"dey",		S_INH,		0,	0x03	},
    {	NULL,	"ediv",		S_INH,		0,	0x11	},
    {	NULL,	"emul",		S_INH,		0,	0x13	},
    {	NULL,	"inca",		S_INH,		0,	0x42	},
    {	NULL,	"incb",		S_INH,		0,	0x52	},
    {	NULL,	"inx",		S_INH,		0,	0x08	},
    {	NULL,	"iny",		S_INH,		0,	0x02	},
    {	NULL,	"lsla",		S_INH,		0,	0x48	},
    {	NULL,	"lslb",		S_INH,		0,	0x58	},
    {	NULL,	"lsld",		S_INH,		0,	0x59	},
    {	NULL,	"lsra",		S_INH,		0,	0x44	},
    {	NULL,	"lsrb",		S_INH,		0,	0x54	},
    {	NULL,	"lsrd",		S_INH,		0,	0x49	},
    {	NULL,	"mem",		S_INH,		0,	0x01	},
    {	NULL,	"mul",		S_INH,		0,	0x12	},
    {	NULL,	"nega",		S_INH,		0,	0x40	},
    {	NULL,	"negb",		S_INH,		0,	0x50	},
    {	NULL,	"nop",		S_INH,		0,	0xA7	},
    {	NULL,	"psha",		S_INH,		0,	0x36	},
    {	NULL,	"pshb",		S_INH,		0,	0x37	},
    {	NULL,	"pshc",		S_INH,		0,	0x39	},
    {	NULL,	"pshd",		S_INH,		0,	0x3B	},
    {	NULL,	"pshx",		S_INH,		0,	0x34	},
    {	NULL,	"pshy",		S_INH,		0,	0x35	},
    {	NULL,	"pula",		S_INH,		0,	0x32	},
    {	NULL,	"pulb",		S_INH,		0,	0x33	},
    {	NULL,	"pulc",		S_INH,		0,	0x38	},
    {	NULL,	"puld",		S_INH,		0,	0x3A	},
    {	NULL,	"pulx",		S_INH,		0,	0x30	},
    {	NULL,	"puly",		S_INH,		0,	0x31	},
    {	NULL,	"rola",		S_INH,		0,	0x45	},
    {	NULL,	"rolb",		S_INH,		0,	0x55	},
    {	NULL,	"rora",		S_INH,		0,	0x46	},
    {	NULL,	"rorb",		S_INH,		0,	0x56	},
    {	NULL,	"rtc",		S_INH,		0,	0x0A	},
    {	NULL,	"rti",		S_INH,		0,	0x0B	},
    {	NULL,	"rts",		S_INH,		0,	0x3D	},
    {	NULL,	"swi",		S_INH,		0,	0x3F	},
    {	NULL,	"tsta",		S_INH,		0,	0x97	},
    {	NULL,	"tstb",		S_INH,		0,	0xD7	},
    {	NULL,	"wai",		S_INH,		0,	0x3E	},
    {	NULL,	"wavr",		S_INH,		0,	0x3C	},

	/* Page2 Inherent Instructions	*/
	/* INH		18 op		*/

    {	NULL,	"aba",		S_INH2,		0,	0x06	},
    {	NULL,	"cba",		S_INH2,		0,	0x17	},
    {	NULL,	"daa",		S_INH2,		0,	0x07	},
    {	NULL,	"edivs",	S_INH2,		0,	0x14	},
    {	NULL,	"emuls",	S_INH2,		0,	0x13	},
    {	NULL,	"fdiv",		S_INH2,		0,	0x11	},
    {	NULL,	"idiv",		S_INH2,		0,	0x10	},
    {	NULL,	"idivs",	S_INH2,		0,	0x15	},
    {	NULL,	"rev",		S_INH2,		0,	0x3A	},
    {	NULL,	"revw",		S_INH2,		0,	0x3B	},
    {	NULL,	"sba",		S_INH2,		0,	0x16	},
    {	NULL,	"stop",		S_INH2,		0,	0x3E	},
    {	NULL,	"tab",		S_INH2,		0,	0x0E	},
    {	NULL,	"tba",		S_INH2,		0,	0x0F	},
    {	NULL,	"wav",		S_INH2,		0,	0x3C	},

	/* Alternate PSH / PUL Form	*/
	/* INH		op		*/

    {	NULL,	"pul",		S_PUL,		0,	0x30	},
    {	NULL,	"psh",		S_PSH,		S_EOL,	0x30	},
};

struct opdata mc6811[] = {

    {{	(char) 0x1A, (char) 0xE5,	/*	leax	b,x	;abx	*/
	(char) 0x00, (char) 0x00	}},

    {{	(char) 0x19, (char) 0xED,	/*	leay	b,y	;aby	*/
	(char) 0x00, (char) 0x00	}},

    {{	(char) 0x10, (char) 0xFE,	/*	andcc	#0xFE	;clc	*/
	(char) 0x00, (char) 0x00	}},

    {{	(char) 0x10, (char) 0xEF,	/*	andcc	#0xEF	;cli	*/
	(char) 0x00, (char) 0x00	}},

    {{	(char) 0x10, (char) 0xFD,	/*	andcc	#0xFD	;clv	*/
	(char) 0x00, (char) 0x00	}},

    {{	(char) 0x1B, (char) 0x9F,	/*	leas	-1,s	;des	*/
	(char) 0x00, (char) 0x00	}},

    {{	(char) 0x1B, (char) 0x81,	/*	leas	1,s	;ins	*/
	(char) 0x00, (char) 0x00	}},

    {{	(char) 0x14, (char) 0x01,	/*	orcc	#0x01	;sec	*/
	(char) 0x00, (char) 0x00	}},

    {{	(char) 0x14, (char) 0x10,	/*	orcc	#0x10	;sei	*/
	(char) 0x00, (char) 0x00	}},

    {{	(char) 0x14, (char) 0x02,	/*	orcc	#0x02	;sev	*/
	(char) 0x00, (char) 0x00	}},

    {{	(char) 0xB7, (char) 0x02,	/*	tfr	a,cc	;tap	*/
	(char) 0x00, (char) 0x00	}},

    {{	(char) 0xB7, (char) 0x20,	/*	tfr	cc,a	;tpa	*/
	(char) 0x00, (char) 0x00	}},

    {{	(char) 0xB7, (char) 0x75,	/*	tfr	s,x	;tsx	*/
	(char) 0x00, (char) 0x00	}},

    {{	(char) 0xB7, (char) 0x76,	/*	tfr	s,y	;tsy	*/
	(char) 0x00, (char) 0x00	}},

    {{	(char) 0xB7, (char) 0x57,	/*	tfr	x,s	;txs	*/
	(char) 0x00, (char) 0x00	}},

    {{	(char) 0xB7, (char) 0x67,	/*	tfr	y,s	;tys	*/
	(char) 0x00, (char) 0x00	}},

    {{	(char) 0xB7, (char) 0xC5,	/*	exg	d,x	;xgdx	*/
	(char) 0x00, (char) 0x00	}},

    {{	(char) 0xB7, (char) 0xC6,	/*	exg	d,y	;xgdy	*/
	(char) 0x00, (char) 0x00	}}
};
