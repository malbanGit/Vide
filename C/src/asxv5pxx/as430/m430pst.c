/* m430pst.c */

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
 */

#include "asxxxx.h"
#include "m430.h"

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
 *
 *	#define		R_JXX	0001		No Bit Positioning
 */
char	mode1[32] = {	/* R_NORM */
	'\000',	'\200',	'\201',	'\202',	'\203',	'\204',	'\205',	'\206',
	'\207',	'\210',	'\211',	'\013',	'\014',	'\015',	'\016',	'\017',
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
struct	mode	mode[2] = {
    {	&mode0[0],	0,	0x0000FFFF,	0x0000FFFF	},
    {	&mode1[0],	1,	0x000003FF,	0x000007FE	}
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

	/* Double Operand */

    {	NULL,	"mov",		S_DOP,		0,	0x4000	},
    {	NULL,	"add",		S_DOP,		0,	0x5000	},
    {	NULL,	"addc",		S_DOP,		0,	0x6000	},
    {	NULL,	"sbb",		S_DOP,		0,	0x7000	},
    {	NULL,	"subc",		S_DOP,		0,	0x7000	},
    {	NULL,	"sub",		S_DOP,		0,	0x8000	},
    {	NULL,	"cmp",		S_DOP,		0,	0x9000	},
    {	NULL,	"dadd",		S_DOP,		0,	0xA000	},
    {	NULL,	"bit",		S_DOP,		0,	0xB000	},
    {	NULL,	"bic",		S_DOP,		0,	0xC000	},
    {	NULL,	"bis",		S_DOP,		0,	0xD000	},
    {	NULL,	"xor",		S_DOP,		0,	0xE000	},
    {	NULL,	"and",		S_DOP,		0,	0xF000	},

    {	NULL,	"mov.b",	S_DOP,		0,	0x4040	},
    {	NULL,	"add.b",	S_DOP,		0,	0x5040	},
    {	NULL,	"addc.b",	S_DOP,		0,	0x6040	},
    {	NULL,	"sbb.b",	S_DOP,		0,	0x7040	},
    {	NULL,	"subc.b",	S_DOP,		0,	0x7040	},
    {	NULL,	"sub.b",	S_DOP,		0,	0x8040	},
    {	NULL,	"cmp.b",	S_DOP,		0,	0x9040	},
    {	NULL,	"dadd.b",	S_DOP,		0,	0xA040	},
    {	NULL,	"bit.b",	S_DOP,		0,	0xB040	},
    {	NULL,	"bic.b",	S_DOP,		0,	0xC040	},
    {	NULL,	"bis.b",	S_DOP,		0,	0xD040	},
    {	NULL,	"xor.b",	S_DOP,		0,	0xE040	},
    {	NULL,	"and.b",	S_DOP,		0,	0xF040	},

    {	NULL,	"mov.w",	S_DOP,		0,	0x4000	},
    {	NULL,	"add.w",	S_DOP,		0,	0x5000	},
    {	NULL,	"addc.w",	S_DOP,		0,	0x6000	},
    {	NULL,	"sbb.w",	S_DOP,		0,	0x7000	},
    {	NULL,	"subc.w",	S_DOP,		0,	0x7000	},
    {	NULL,	"sub.w",	S_DOP,		0,	0x8000	},
    {	NULL,	"cmp.w",	S_DOP,		0,	0x9000	},
    {	NULL,	"dadd.w",	S_DOP,		0,	0xA000	},
    {	NULL,	"bit.w",	S_DOP,		0,	0xB000	},
    {	NULL,	"bic.w",	S_DOP,		0,	0xC000	},
    {	NULL,	"bis.w",	S_DOP,		0,	0xD000	},
    {	NULL,	"xor.w",	S_DOP,		0,	0xE000	},
    {	NULL,	"and.w",	S_DOP,		0,	0xF000	},

	/* Single Operand */

    {	NULL,	"rra",		S_SOP,		0,	0x1100	},
    {	NULL,	"rrc",		S_SOP,		0,	0x1000	},

    {	NULL,	"rra.b",	S_SOP,		0,	0x1140	},
    {	NULL,	"rrc.b",	S_SOP,		0,	0x1040	},

    {	NULL,	"rra.w",	S_SOP,		0,	0x1100	},
    {	NULL,	"rrc.w",	S_SOP,		0,	0x1000	},

    {	NULL,	"swpb",		S_SOP,		0,	0x1080	},
    {	NULL,	"sxt",		S_SOP,		0,	0x1180	},

    {	NULL,	"push",		S_PSH,		0,	0x1200	},
    {	NULL,	"push.b",	S_PSH,		0,	0x1240	},
    {	NULL,	"push.w",	S_PSH,		0,	0x1200	},

    {	NULL,	"call",		S_SOP,		0,	0x1280	},

	/* Short Jump Instructions */

    {	NULL,	"jne",		S_JXX,		0,	0x2000	},
    {	NULL,	"jnz",		S_JXX,		0,	0x2000	},
    {	NULL,	"jeq",		S_JXX,		0,	0x2400	},
    {	NULL,	"jz",		S_JXX,		0,	0x2400	},
    {	NULL,	"jnc",		S_JXX,		0,	0x2800	},
    {	NULL,	"jlo",		S_JXX,		0,	0x2800	},
    {	NULL,	"jc",		S_JXX,		0,	0x2C00	},
    {	NULL,	"jhs",		S_JXX,		0,	0x2C00	},
    {	NULL,	"jn",		S_JXX,		0,	0x3000	},
    {	NULL,	"jge",		S_JXX,		0,	0x3400	},
    {	NULL,	"jl",		S_JXX,		0,	0x3800	},
    {	NULL,	"jmp",		S_JXX,		0,	0x3C00	},

	/* Inherent Instructions */

    {	NULL,	"reti",		S_INH,		0,	0x1300	},

	/* Emulated Instructions */

    {	NULL,	"adc",		S_DST,		0,	0x6300	},  /*	addc	#0,dst	*/
    {	NULL,	"clr",		S_DST,		0,	0x4300	},  /*	mov	#0,dst	*/
    {	NULL,	"dadc",		S_DST,		0,	0xA300	},  /*	dadd	#0,dst	*/
    {	NULL,	"dec",		S_DST,		0,	0x8310	},  /*	sub	#1,dst	*/
    {	NULL,	"decd",		S_DST,		0,	0x8320	},  /*	sub	#2,dst	*/
    {	NULL,	"inc",		S_DST,		0,	0x5310	},  /*	add	#1,dst	*/
    {	NULL,	"incd",		S_DST,		0,	0x5320	},  /*	add	#2,dst	*/
    {	NULL,	"inv",		S_DST,		0,	0xE330	},  /*	xor	#0xFFFF,dst	*/
    {	NULL,	"pop",		S_DST,		0,	0x4130	},  /*	mov	@sp+,dst	*/
    {	NULL,	"rla",		S_RLX,		0,	0x5000	},  /*	add	dst,dst	*/
    {	NULL,	"rlc",		S_RLX,		0,	0x6000	},  /*	addc	dst,dst	*/
    {	NULL,	"sbc",		S_DST,		0,	0x7300	},  /*	subc	#0,dst	*/
    {	NULL,	"tst",		S_DST,		0,	0x9300	},  /*	cmp	#0,dst	*/

    {	NULL,	"adc.b",	S_DST,		0,	0x6340	},  /*	addc.b	#0,dst	*/
    {	NULL,	"clr.b",	S_DST,		0,	0x4340	},  /*	mov.b	#0,dst	*/
    {	NULL,	"dadc.b",	S_DST,		0,	0xA340	},  /*	dadd.b	#0,dst	*/
    {	NULL,	"dec.b",	S_DST,		0,	0x8350	},  /*	sub.b	#1,dst	*/
    {	NULL,	"decd.b",	S_DST,		0,	0x8360	},  /*	sub.b	#2,dst	*/
    {	NULL,	"inc.b",	S_DST,		0,	0x5350	},  /*	add.b	#1,dst	*/
    {	NULL,	"incd.b",	S_DST,		0,	0x5360	},  /*	add.b	#2,dst	*/
    {	NULL,	"inv.b",	S_DST,		0,	0xE370	},  /*	xor.b	#0xFF,dst	*/
    {	NULL,	"pop.b",	S_DST,		0,	0x4170	},  /*	mov.b	@sp+,dst	*/
    {	NULL,	"rla.b",	S_RLX,		0,	0x5040	},  /*	add.b	dst,dst	*/
    {	NULL,	"rlc.b",	S_RLX,		0,	0x6040	},  /*	addc.b	dst,dst	*/
    {	NULL,	"sbc.b",	S_DST,		0,	0x7340	},  /*	subc.b	#0,dst	*/
    {	NULL,	"tst.b",	S_DST,		0,	0x9340	},  /*	cmp.b	#0,dst	*/

    {	NULL,	"adc.w",	S_DST,		0,	0x6300	},  /*	addc.w	#0,dst	*/
    {	NULL,	"clr.w",	S_DST,		0,	0x4300	},  /*	mov.w	#0,dst	*/
    {	NULL,	"dadc.w",	S_DST,		0,	0xA300	},  /*	dadd.w	#0,dst	*/
    {	NULL,	"dec.w",	S_DST,		0,	0x8310	},  /*	sub.w	#1,dst	*/
    {	NULL,	"decd.w",	S_DST,		0,	0x8320	},  /*	sub.w	#2,dst	*/
    {	NULL,	"inc.w",	S_DST,		0,	0x5310	},  /*	add.w	#1,dst	*/
    {	NULL,	"incd.w",	S_DST,		0,	0x5320	},  /*	add.w	#2,dst	*/
    {	NULL,	"inv.w",	S_DST,		0,	0xE330	},  /*	xor.w	#0xFFFF,dst	*/
    {	NULL,	"pop.w",	S_DST,		0,	0x4130	},  /*	mov.w	@sp+,dst	*/
    {	NULL,	"rla.w",	S_RLX,		0,	0x5000	},  /*	add.w	dst,dst	*/
    {	NULL,	"rlc.w",	S_RLX,		0,	0x6000	},  /*	addc.w	dst,dst	*/
    {	NULL,	"sbc.w",	S_DST,		0,	0x7300	},  /*	subc.w	#0,dst	*/
    {	NULL,	"tst.w",	S_DST,		0,	0x9300	},  /*	cmp.w	#0,dst	*/

    {	NULL,	"br",		S_BRA,		0,	0x4000	},  /*	mov	src,PC	*/
    {	NULL,	"bra",		S_BRA,		0,	0x4000	},  /*	mov	src,PC	*/
    {	NULL,	"branch",	S_BRA,		0,	0x4000	},  /*	mov	src,PC	*/

    {	NULL,	"clrc",		S_INH,		0,	0xC312	},  /*	bic	#1,SR	*/
    {	NULL,	"clrn",		S_INH,		0,	0xC202	},  /*	bic	#4,SR	*/
    {	NULL,	"clrz",		S_INH,		0,	0xC322	},  /*	bic	#2,SR	*/

    {	NULL,	"setc",		S_INH,		0,	0xD312	},  /*	bis	#1,SR	*/
    {	NULL,	"setn",		S_INH,		0,	0xD202	},  /*	bis	#4,SR	*/
    {	NULL,	"setz",		S_INH,		0,	0xD322	},  /*	bis	#2,SR	*/

    {	NULL,	"dint",		S_INH,		0,	0xC332	},  /*	bic	#8,SR	*/
    {	NULL,	"eint",		S_INH,		0,	0xD332	},  /*	bis	#8,SR	*/

    {	NULL,	"nop",		S_INH,		0,	0x4303	},  /*	mov	#0,r3	*/

    {	NULL,	"ret",		S_INH,		S_EOL,	0x4130	}  /*	mov	@sp+,PC	*/
};
