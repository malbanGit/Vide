/* ez80pst.c */

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
 * Kent,	Ohio  44240
 *
 *
 * Ported by Patrick Head
 * from the ASZ80 assembler.
 *
 * patrick at phead dot net
 */

#include "asxxxx.h"
#include "ez80.h"

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
char	mode0[32] = {	/* R_NORM */ /* R_ADL */
	'\200',	'\201',	'\202',	'\203',	'\204',	'\205',	'\206',	'\207',
	'\210',	'\211',	'\212',	'\213',	'\214',	'\215',	'\216',	'\217',
	'\220',	'\221',	'\222',	'\223',	'\224',	'\225',	'\226',	'\227',
	'\230',	'\231',	'\232',	'\233',	'\234',	'\235',	'\236',	'\237'
};

/*
 * Additional Relocation Mode Definitions
 */

/*
 * Basic Relocation Mode Definition
 *
 *	#define		R_Z80	0100		No Bit Positioning
 */
char	mode1[32] = {	/* R_Z80 */
	'\200',	'\201',	'\202',	'\203',	'\204',	'\205',	'\206',	'\207',
	'\210',	'\211',	'\212',	'\213',	'\214',	'\215',	'\216',	'\217',
	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};

/*
 * 3-BIT Relocation for BIT, RES, and SET
 *
 *	#define		R_3BIT	0200		3-Bit Positioning
 */
char	mode2[32] = {	/* R_3BIT */
	'\203',	'\204',	'\205',	'\003',	'\004',	'\005',	'\006',	'\007',
	'\010',	'\011',	'\012',	'\013',	'\014',	'\015',	'\016',	'\017',
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
#ifdef	LONGINT
struct	mode	mode[3] = {
    {	&mode0[0],	0,	0x00FFFFFFl,	0x00FFFFFFl	},	/* Normal 24-BIT Mode */
    {	&mode1[0],	0,	0x0000FFFFl,	0x0000FFFFl	},	/* Z80 16-BIT Mode */
    {	&mode2[0],	1,	0x00000038l,	0x00000007l	}	/* BIT, RST and SET 3-BIT Mode */
};
#else
struct	mode	mode[3] = {
    {	&mode0[0],	0,	0x00FFFFFF,	0x00FFFFFF	},	/* Normal 24-BIT Mode */
    {	&mode1[0],	0,	0x0000FFFF,	0x0000FFFF	},	/* Z80 16-BIT Mode */
    {	&mode2[0],	1,	0x00000038,	0x00000007	}	/* BIT, RST and SET 3-BIT Mode */
};
#endif

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
    {	NULL,	".3byte",	S_DATA,		0,	O_3BYTE	},
    {	NULL,	".triple",	S_DATA,		0,	O_3BYTE	},
/*    {	NULL,	".4byte",	S_DATA,		0,	O_4BYTE	},	*/
/*    {	NULL,	".quad",	S_DATA,		0,	O_4BYTE	},	*/
    {	NULL,	".blkb",	S_BLK,		0,	O_1BYTE	},
    {	NULL,	".ds",		S_BLK,		0,	O_1BYTE	},
    {	NULL,	".rmb",		S_BLK,		0,	O_1BYTE	},
    {	NULL,	".rs",		S_BLK,		0,	O_1BYTE	},
    {	NULL,	".blkw",	S_BLK,		0,	O_2BYTE	},
    {	NULL,	".blk3",	S_BLK,		0,	O_3BYTE	},
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
    {	NULL,	".msb",		S_MSB,		0,	0	},
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

	/* eZ80 */

    {	NULL,	".adl",		S_AMOD,		0,	MM_ADL	},
    {	NULL,	".z80",		S_AMOD,		0,	MM_Z80	},

    {	NULL,	"ld",		S_LD,		0,	0x40 },
    {	NULL,	"ld.il",	S_LD,		M_IL,	0x40 },
    {	NULL,	"ld.is",	S_LD,		M_IS,	0x40 },
    {	NULL,	"ld.l",		S_LD,		M_L,	0x40 },
    {	NULL,	"ld.lil",	S_LD,		M_LIL,	0x40 },
    {	NULL,	"ld.s",		S_LD,		M_S,	0x40 },
    {	NULL,	"ld.sis",	S_LD,		M_SIS,	0x40 },

    {	NULL,	"call",		S_CALL,		0,	0xC4 },
    {	NULL,	"call.il",	S_CALL,		M_IL,	0xC4 },
    {	NULL,	"call.is",	S_CALL,		M_IS,	0xC4 },

    {	NULL,	"jp",		S_JP,		0,	0xC2 },
    {	NULL,	"jp.l",		S_JP,		M_L,	0xC2 },
    {	NULL,	"jp.lil",	S_JP,		M_LIL,	0xC2 },
    {	NULL,	"jp.s",		S_JP,		M_S,	0xC2 },
    {	NULL,	"jp.sis",	S_JP,		M_SIS,	0xC2 },

    {	NULL,	"jr",		S_JR,		0,	0x18 },

    {	NULL,	"djnz",		S_DJNZ,		0,	0x10 },

    {	NULL,	"ret",		S_RET,		0,	0xC0 },
    {	NULL,	"ret.l",	S_RET,		M_L,	0xC0 },

    {	NULL,	"bit",		S_BIT,		0,	0x40 },
    {	NULL,	"bit.l",	S_BIT,		M_L,	0x40 },
    {	NULL,	"bit.s",	S_BIT,		M_S,	0x40 },
    {	NULL,	"res",		S_BIT,		0,	0x80 },
    {	NULL,	"res.l",	S_BIT,		M_L,	0x80 },
    {	NULL,	"res.s",	S_BIT,		M_S,	0x80 },
    {	NULL,	"set",		S_BIT,		0,	0xC0 },
    {	NULL,	"set.l",	S_BIT,		M_L,	0xC0 },
    {	NULL,	"set.s",	S_BIT,		M_S,	0xC0 },

    {	NULL,	"inc",		S_INC,		0,	0x04 },
    {	NULL,	"inc.l",	S_INC,		M_L,	0x04 },
    {	NULL,	"inc.s",	S_INC,		M_S,	0x04 },
	
    {	NULL,	"dec",		S_DEC,		0,	0x05 },
    {	NULL,	"dec.l",	S_DEC,		M_L,	0x05 },
    {	NULL,	"dec.s",	S_DEC,		M_S,	0x05 },

    {	NULL,	"add",		S_ADD,		0,	0x80 },
    {	NULL,	"add.l",	S_ADD,		M_L,	0x80 },
    {	NULL,	"add.s",	S_ADD,		M_S,	0x80 },

    {	NULL,	"adc",		S_ADC,		0,	0x88 },
    {	NULL,	"adc.l",	S_ADC,		M_L,	0x88 },
    {	NULL,	"adc.s",	S_ADC,		M_S,	0x88 },

    {	NULL,	"sub",		S_SUB,		0,	0x90 },
    {	NULL,	"sub.l",	S_SUB,		M_L,	0x90 },
    {	NULL,	"sub.s",	S_SUB,		M_S,	0x90 },

    {	NULL,	"sbc",		S_SBC,		0,	0x98 },
    {	NULL,	"sbc.l",	S_SBC,		M_L,	0x98 },
    {	NULL,	"sbc.s",	S_SBC,		M_S,	0x98 },

    {	NULL,	"and",		S_AND,		0,	0xA0 },
    {	NULL,	"and.l",	S_AND,		M_L,	0xA0 },
    {	NULL,	"and.s",	S_AND,		M_S,	0xA0 },
    {	NULL,	"cp",		S_AND,		0,	0xB8 },
    {	NULL,	"cp.l",		S_AND,		M_L,	0xB8 },
    {	NULL,	"cp.s",		S_AND,		M_S,	0xB8 },
    {	NULL,	"or",		S_AND,		0,	0xB0 },
    {	NULL,	"or.l",		S_AND,		M_L,	0xB0 },
    {	NULL,	"or.s",		S_AND,		M_S,	0xB0 },
    {	NULL,	"xor",		S_AND,		0,	0xA8 },
    {	NULL,	"xor.l",	S_AND,		M_L,	0xA8 },
    {	NULL,	"xor.s",	S_AND,		M_S,	0xA8 },

    {	NULL,	"ex",		S_EX,		0,	0xE3 },
    {	NULL,	"ex.l",		S_EX,		M_L,	0xE3 },
    {	NULL,	"ex.s",		S_EX,		M_S,	0xE3 },

    {	NULL,	"push",		S_PUSH,		0,	0xC5 },
    {	NULL,	"push.l",	S_PUSH,		M_L,	0xC5 },
    {	NULL,	"push.s",	S_PUSH,		M_S,	0xC5 },
    {	NULL,	"pop",		S_PUSH,		0,	0xC1 },
    {	NULL,	"pop.l",	S_PUSH,		M_L,	0xC1 },
    {	NULL,	"pop.s",	S_PUSH,		M_S,	0xC1 },

    {	NULL,	"in",		S_IN,		0,	0xDB },
    {	NULL,	"in0",		S_IN0,		0,	0x00 },

    {	NULL,	"out",		S_OUT,		0,	0xD3 },
    {	NULL,	"out0",		S_OUT0,		0,	0x01 },

    {	NULL,	"rl",		S_RL,		0,	0x10 },
    {	NULL,	"rl.l",		S_RL,		M_L,	0x10 },
    {	NULL,	"rl.s",		S_RL,		M_S,	0x10 },
    {	NULL,	"rlc",		S_RL,		0,	0x00 },
    {	NULL,	"rlc.l",	S_RL,		M_L,	0x00 },
    {	NULL,	"rlc.s",	S_RL,		M_S,	0x00 },
    {	NULL,	"rr",		S_RL,		0,	0x18 },
    {	NULL,	"rr.l",		S_RL,		M_L,	0x18 },
    {	NULL,	"rr.s",		S_RL,		M_S,	0x18 },
    {	NULL,	"rrc",		S_RL,		0,	0x08 },
    {	NULL,	"rrc.l",	S_RL,		M_L,	0x08 },
    {	NULL,	"rrc.s",	S_RL,		M_S,	0x08 },
    {	NULL,	"sla",		S_RL,		0,	0x20 },
    {	NULL,	"sla.l",	S_RL,		M_L,	0x20 },
    {	NULL,	"sla.s",	S_RL,		M_S,	0x20 },
    {	NULL,	"sra",		S_RL,		0,	0x28 },
    {	NULL,	"sra.l",	S_RL,		M_L,	0x28 },
    {	NULL,	"sra.s",	S_RL,		M_S,	0x28 },
    {	NULL,	"srl",		S_RL,		0,	0x38 },
    {	NULL,	"srl.l",	S_RL,		M_L,	0x38 },
    {	NULL,	"srl.s",	S_RL,		M_S,	0x38 },

    {	NULL,	"rst",		S_RST,		0,	0xC7 },
    {	NULL,	"rst.l",	S_RST,		M_L,	0xC7 },
    {	NULL,	"rst.s",	S_RST,		M_S,	0xC7 },

    {	NULL,	"im",		S_IM,		0,	0xED },

    {	NULL,	"ccf",		S_INH1,		0,	0x3F },
    {	NULL,	"cpl",		S_INH1,		0,	0x2F },
    {	NULL,	"daa",		S_INH1,		0,	0x27 },
    {	NULL,	"di",		S_INH1,		0,	0xF3 },
    {	NULL,	"ei",		S_INH1,		0,	0xFB },
    {	NULL,	"exx",		S_INH1,		0,	0xD9 },
    {	NULL,	"nop",		S_INH1,		0,	0x00 },
    {	NULL,	"halt",		S_INH1,		0,	0x76 },
    {	NULL,	"rla",		S_INH1,		0,	0x17 },
    {	NULL,	"rlca",		S_INH1,		0,	0x07 },
    {	NULL,	"rra",		S_INH1,		0,	0x1F },
    {	NULL,	"rrca",		S_INH1,		0,	0x0F },
    {	NULL,	"scf",		S_INH1,		0,	0x37 },

    {	NULL,	"cpd",		S_INH2,		0,	0xA9 },
    {	NULL,	"cpd.l",	S_INH2,		M_L,	0xA9 },
    {	NULL,	"cpd.s",	S_INH2,		M_S,	0xA9 },
    {	NULL,	"cpdr",		S_INH2,		0,	0xB9 },
    {	NULL,	"cpdr.l",	S_INH2,		M_L,	0xB9 },
    {	NULL,	"cpdr.s",	S_INH2,		M_S,	0xB9 },
    {	NULL,	"cpi",		S_INH2,		0,	0xA1 },
    {	NULL,	"cpi.l",	S_INH2,		M_L,	0xA1 },
    {	NULL,	"cpi.s",	S_INH2,		M_S,	0xA1 },
    {	NULL,	"cpir",		S_INH2,		0,	0xB1 },
    {	NULL,	"cpir.l",	S_INH2,		M_L,	0xB1 },
    {	NULL,	"cpir.s",	S_INH2,		M_S,	0xB1 },
    {	NULL,	"ind",		S_INH2,		0,	0xAA },
    {	NULL,	"ind.l",	S_INH2,		M_L,	0xAA },
    {	NULL,	"ind.s",	S_INH2,		M_S,	0xAA },
    {	NULL,	"ind2",		S_INH2,		0,	0x8C },
    {	NULL,	"ind2.l",	S_INH2,		M_L,	0x8C },
    {	NULL,	"ind2.s",	S_INH2,		M_S,	0x8C },
    {	NULL,	"indr",		S_INH2,		0,	0xBA },
    {	NULL,	"indr.l",	S_INH2,		M_L,	0xBA },
    {	NULL,	"indr.s",	S_INH2,		M_S,	0xBA },
    {	NULL,	"ind2r",	S_INH2,		0,	0x9C },
    {	NULL,	"ind2r.l",	S_INH2,		M_L,	0x9C },
    {	NULL,	"ind2r.s",	S_INH2,		M_S,	0x9C },
    {	NULL,	"indrx",	S_INH2,		0,	0xCA },
    {	NULL,	"indrx.l",	S_INH2,		M_L,	0xCA },
    {	NULL,	"indrx.s",	S_INH2,		M_S,	0xCA },
    {	NULL,	"indm",		S_INH2,		0,	0x8A },
    {	NULL,	"indm.l",	S_INH2,		M_L,	0x8A },
    {	NULL,	"indm.s",	S_INH2,		M_S,	0x8A },
    {	NULL,	"indmr",	S_INH2,		0,	0x9A },
    {	NULL,	"indmr.l",	S_INH2,		M_L,	0x9A },
    {	NULL,	"indmr.s",	S_INH2,		M_S,	0x9A },
    {	NULL,	"ini",		S_INH2,		0,	0xA2 },
    {	NULL,	"ini.l",	S_INH2,		M_L,	0xA2 },
    {	NULL,	"ini.s",	S_INH2,		M_S,	0xA2 },
    {	NULL,	"ini2",		S_INH2,		0,	0x84 },
    {	NULL,	"ini2.l",	S_INH2,		M_L,	0x84 },
    {	NULL,	"ini2.s",	S_INH2,		M_S,	0x84 },
    {	NULL,	"inir",		S_INH2,		0,	0xB2 },
    {	NULL,	"inir.l",	S_INH2,		M_L,	0xB2 },
    {	NULL,	"inir.s",	S_INH2,		M_S,	0xB2 },
    {	NULL,	"inirx",	S_INH2,		0,	0xC2 },
    {	NULL,	"inirx.l",	S_INH2,		M_L,	0xC2 },
    {	NULL,	"inirx.s",	S_INH2,		M_S,	0xC2 },
    {	NULL,	"ini2r",	S_INH2,		0,	0x94 },
    {	NULL,	"ini2r.l",	S_INH2,		M_L,	0x94 },
    {	NULL,	"ini2r.s",	S_INH2,		M_S,	0x94 },
    {	NULL,	"inim",		S_INH2,		0,	0x82 },
    {	NULL,	"inim.l",	S_INH2,		M_L,	0x82 },
    {	NULL,	"inim.s",	S_INH2,		M_S,	0x82 },
    {	NULL,	"inimr",	S_INH2,		0,	0x92 },
    {	NULL,	"inimr.l",	S_INH2,		M_L,	0x92 },
    {	NULL,	"inimr.s",	S_INH2,		M_S,	0x92 },
    {	NULL,	"ldd",		S_INH2,		0,	0xA8 },
    {	NULL,	"ldd.l",	S_INH2,		M_L,	0xA8 },
    {	NULL,	"ldd.s",	S_INH2,		M_S,	0xA8 },
    {	NULL,	"lddr",		S_INH2,		0,	0xB8 },
    {	NULL,	"lddr.l",	S_INH2,		M_L,	0xB8 },
    {	NULL,	"lddr.s",	S_INH2,		M_S,	0xB8 },
    {	NULL,	"ldi",		S_INH2,		0,	0xA0 },
    {	NULL,	"ldi.l",	S_INH2,		M_L,	0xA0 },
    {	NULL,	"ldi.s",	S_INH2,		M_S,	0xA0 },
    {	NULL,	"ldir",		S_INH2,		0,	0xB0 },
    {	NULL,	"ldir.l",	S_INH2,		M_L,	0xB0 },
    {	NULL,	"ldir.s",	S_INH2,		M_S,	0xB0 },
    {	NULL,	"neg",		S_INH2,		0,	0x44 },
    {	NULL,	"otdr",		S_INH2,		0,	0xBB },
    {	NULL,	"otdr.l",	S_INH2,		M_L,	0xBB },
    {	NULL,	"otdr.s",	S_INH2,		M_S,	0xBB },
    {	NULL,	"otd2r",	S_INH2,		0,	0xBC },
    {	NULL,	"otd2r.l",	S_INH2,		M_L,	0xBC },
    {	NULL,	"otd2r.s",	S_INH2,		M_S,	0xBC },
    {	NULL,	"otdrx",	S_INH2,		0,	0xCB },
    {	NULL,	"otdrx.l",	S_INH2,		M_L,	0xCB },
    {	NULL,	"otdrx.s",	S_INH2,		M_S,	0xCB },
    {	NULL,	"otir",		S_INH2,		0,	0xB3 },
    {	NULL,	"otir.l",	S_INH2,		M_L,	0xB3 },
    {	NULL,	"otir.s",	S_INH2,		M_S,	0xB3 },
    {	NULL,	"oti2r",	S_INH2,		0,	0xB4 },
    {	NULL,	"oti2r.l",	S_INH2,		M_L,	0xB4 },
    {	NULL,	"oti2r.s",	S_INH2,		M_S,	0xB4 },
    {	NULL,	"otirx",	S_INH2,		0,	0xC3 },
    {	NULL,	"otirx.l",	S_INH2,		M_L,	0xC3 },
    {	NULL,	"otirx.s",	S_INH2,		M_S,	0xC3 },
    {	NULL,	"outd",		S_INH2,		0,	0xAB },
    {	NULL,	"outd.l",	S_INH2,		M_L,	0xAB },
    {	NULL,	"outd.s",	S_INH2,		M_S,	0xAB },
    {	NULL,	"outd2",	S_INH2,		0,	0xAC },
    {	NULL,	"outd2.l",	S_INH2,		M_L,	0xAC },
    {	NULL,	"outd2.s",	S_INH2,		M_S,	0xAC },
    {	NULL,	"outi",		S_INH2,		0,	0xA3 },
    {	NULL,	"outi.l",	S_INH2,		M_L,	0xA3 },
    {	NULL,	"outi.s",	S_INH2,		M_S,	0xA3 },
    {	NULL,	"outi2",	S_INH2,		0,	0xA4 },
    {	NULL,	"outi2.l",	S_INH2,		M_L,	0xA4 },
    {	NULL,	"outi2.s",	S_INH2,		M_S,	0xA4 },
    {	NULL,	"otdm",		S_INH2,		0,	0x8B },
    {	NULL,	"otdm.l",	S_INH2,		M_L,	0x8B },
    {	NULL,	"otdm.s",	S_INH2,		M_S,	0x8B },
    {	NULL,	"otdmr",	S_INH2,		0,	0x9B },
    {	NULL,	"otdmr.l",	S_INH2,		M_L,	0x9B },
    {	NULL,	"otdmr.s",	S_INH2,		M_S,	0x9B },
    {	NULL,	"otim",		S_INH2,		0,	0x83 },
    {	NULL,	"otim.l",	S_INH2,		M_L,	0x83 },
    {	NULL,	"otim.s",	S_INH2,		M_S,	0x83 },
    {	NULL,	"otimr",	S_INH2,		0,	0x93 },
    {	NULL,	"otimr.l",	S_INH2,		M_L,	0x93 },
    {	NULL,	"otimr.s",	S_INH2,		M_S,	0x93 },
    {	NULL,	"reti",		S_INH2,		0,	0x4D },
    {	NULL,	"reti.l",	S_INH2,		M_L,	0x4D },
    {	NULL,	"retn",		S_INH2,		0,	0x45 },
    {	NULL,	"retn.l",	S_INH2,		M_L,	0x45 },
    {	NULL,	"rld",		S_INH2,		0,	0x6F },
    {	NULL,	"rrd",		S_INH2,		0,	0x67 },
    {	NULL,	"slp",		S_INH2,		0,	0x76 },

    {	NULL,	"mlt",		S_MLT,		0,	0x4C },
    {	NULL,	"mlt.l",	S_MLT,		M_L,	0x4C },
    {	NULL,	"mlt.s",	S_MLT,		M_S,	0x4C },

    {	NULL,	"tst",		S_TST,		0,	0x04 },
    {	NULL,	"tst.l",	S_TST,		M_L,	0x04 },
    {	NULL,	"tst.s",	S_TST,		M_S,	0x04 },

    {	NULL,	"tstio",	S_TSTIO,	0,	0x74 },

    {	NULL,	"lea",		S_LEA,		0,	0x00 },
    {	NULL,	"lea.l",	S_LEA,		M_L,	0x00 },
    {	NULL,	"lea.s",	S_LEA,		M_S,	0x00 },

    {	NULL,	"pea",		S_PEA,		0,	0x65 },
    {	NULL,	"pea.l",	S_PEA,		M_L,	0x65 },
    {	NULL,	"pea.s",	S_PEA,		M_S,	0x65 },

    {	NULL,	"rsmix",	S_MIX,		0,	0x7E },
    {	NULL,	"stmix",	S_MIX,		S_EOL,	0x7D }
};
