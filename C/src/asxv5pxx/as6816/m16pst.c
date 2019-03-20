/* m16pst.c */

/*
 *  Copyright (C) 1991-2009  Alan R. Baldwin
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
#include "m6816.h"

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

	/* machine */

    {	NULL,	"ais",		S_IMMA,		0,	0x3F	},
    {	NULL,	"aix",		S_IMMA,		0,	0x3C	},
    {	NULL,	"aiy",		S_IMMA,		0,	0x3D	},
    {	NULL,	"aiz",		S_IMMA,		0,	0x3E	},

    {	NULL,	"andp",		S_IM16,		0,	0x3A	},
    {	NULL,	"orp",		S_IM16,		0,	0x3B	},

    {	NULL,	"bclr",		S_BIT,		0,	0x08	},
    {	NULL,	"bset",		S_BIT,		0,	0x09	},

    {	NULL,	"bclrw",	S_BITW,		0,	0x08	},
    {	NULL,	"bsetw",	S_BITW,		0,	0x09	},

    {	NULL,	"brclr",	S_BRBT,		0,	0x0A	},
    {	NULL,	"brset",	S_BRBT,		0,	0x0B	},

    {	NULL,	"lded",		S_LDED,		0,	0x71	},

    {	NULL,	"mac",		S_MAC,		0,	0x7B	},
    {	NULL,	"rmac",		S_MAC,		0,	0xFB	},

    {	NULL,	"pshm",		S_PSHM,		0,	0x34	},
    {	NULL,	"pulm",		S_PULM,		0,	0x35	},

    {	NULL,	"jmp",		S_JXX,		0,	0x4B	},
    {	NULL,	"jsr",		S_JXX,		0,	0x89	},

    {	NULL,	"movb",		S_MOVB,		0,	0x30	},
    {	NULL,	"movw",		S_MOVW,		0,	0x31	},

    {	NULL,	"cps",		S_CMP,		0,	0x4F	},
    {	NULL,	"cpx",		S_CMP,		0,	0x4C	},
    {	NULL,	"cpy",		S_CMP,		0,	0x4D	},
    {	NULL,	"cpz",		S_CMP,		0,	0x4E	},

    {	NULL,	"lds",		S_LOAD,		0,	0xCF	},
    {	NULL,	"ldx",		S_LOAD,		0,	0xCC	},
    {	NULL,	"ldy",		S_LOAD,		0,	0xCD	},
    {	NULL,	"ldz",		S_LOAD,		0,	0xCE	},

    {	NULL,	"sts",		S_STOR,		0,	0x8F	},
    {	NULL,	"stx",		S_STOR,		0,	0x8C	},
    {	NULL,	"sty",		S_STOR,		0,	0x8D	},
    {	NULL,	"stz",		S_STOR,		0,	0x8E	},

    {	NULL,	"aslw",		S_SOPW,		0,	0x04	},
    {	NULL,	"asrw",		S_SOPW,		0,	0x0D	},
    {	NULL,	"clrw",		S_SOPW,		0,	0x05	},
    {	NULL,	"comw",		S_SOPW,		0,	0x00	},
    {	NULL,	"decw",		S_SOPW,		0,	0x01	},
    {	NULL,	"incw",		S_SOPW,		0,	0x03	},
    {	NULL,	"lslw",		S_SOPW,		0,	0x04	},
    {	NULL,	"lsrw",		S_SOPW,		0,	0x0F	},
    {	NULL,	"negw",		S_SOPW,		0,	0x02	},
    {	NULL,	"rolw",		S_SOPW,		0,	0x0C	},
    {	NULL,	"rorw",		S_SOPW,		0,	0x0E	},
    {	NULL,	"tstw",		S_SOPW,		0,	0x06	},

    {	NULL,	"asl",		S_SOP,		0,	0x04	},
    {	NULL,	"asr",		S_SOP,		0,	0x0D	},
    {	NULL,	"clr",		S_SOP,		0,	0x05	},
    {	NULL,	"com",		S_SOP,		0,	0x00	},
    {	NULL,	"dec",		S_SOP,		0,	0x01	},
    {	NULL,	"inc",		S_SOP,		0,	0x03	},
    {	NULL,	"lsl",		S_SOP,		0,	0x04	},
    {	NULL,	"lsr",		S_SOP,		0,	0x0F	},
    {	NULL,	"neg",		S_SOP,		0,	0x02	},
    {	NULL,	"rol",		S_SOP,		0,	0x0C	},
    {	NULL,	"ror",		S_SOP,		0,	0x0E	},
    {	NULL,	"tst",		S_SOP,		0,	0x06	},

    {	NULL,	"adce",		S_DOPE,		0,	0x43	},
    {	NULL,	"adde",		S_DOPE,		0,	0x41	},
    {	NULL,	"ande",		S_DOPE,		0,	0x46	},
    {	NULL,	"cpe",		S_DOPE,		0,	0x48	},
    {	NULL,	"eore",		S_DOPE,		0,	0x44	},
    {	NULL,	"lde",		S_DOPE,		0,	0x45	},
    {	NULL,	"ore",		S_DOPE,		0,	0x47	},
    {	NULL,	"sbce",		S_DOPE,		0,	0x42	},
    {	NULL,	"ste",		S_DOPE,		0,	0x4A	},
    {	NULL,	"sube",		S_DOPE,		0,	0x40	},

    {	NULL,	"adcd",		S_DOPD,		0,	0x83	},
    {	NULL,	"addd",		S_DOPD,		0,	0x81	},
    {	NULL,	"andd",		S_DOPD,		0,	0x86	},
    {	NULL,	"cpd",		S_DOPD,		0,	0x88	},
    {	NULL,	"eord",		S_DOPD,		0,	0x84	},
    {	NULL,	"ldd",		S_DOPD,		0,	0x85	},
    {	NULL,	"ord",		S_DOPD,		0,	0x87	},
    {	NULL,	"sbcd",		S_DOPD,		0,	0x82	},
    {	NULL,	"std",		S_DOPD,		0,	0x8A	},
    {	NULL,	"subd",		S_DOPD,		0,	0x80	},

    {	NULL,	"adca",		S_DOP,		0,	0x43	},
    {	NULL,	"adcb",		S_DOP,		0,	0xC3	},
    {	NULL,	"adda",		S_DOP,		0,	0x41	},
    {	NULL,	"addb",		S_DOP,		0,	0xC1	},
    {	NULL,	"anda",		S_DOP,		0,	0x46	},
    {	NULL,	"andb",		S_DOP,		0,	0xC6	},
    {	NULL,	"bita",		S_DOP,		0,	0x49	},
    {	NULL,	"bitb",		S_DOP,		0,	0xC9	},
    {	NULL,	"cmpa",		S_DOP,		0,	0x48	},
    {	NULL,	"cmpb",		S_DOP,		0,	0xC8	},
    {	NULL,	"eora",		S_DOP,		0,	0x44	},
    {	NULL,	"eorb",		S_DOP,		0,	0xC4	},
    {	NULL,	"ldaa",		S_DOP,		0,	0x45	},
    {	NULL,	"ldab",		S_DOP,		0,	0xC5	},
    {	NULL,	"oraa",		S_DOP,		0,	0x47	},
    {	NULL,	"orab",		S_DOP,		0,	0xC7	},
    {	NULL,	"sbca",		S_DOP,		0,	0x42	},
    {	NULL,	"sbcb",		S_DOP,		0,	0xC2	},
    {	NULL,	"staa",		S_DOP,		0,	0x4A	},
    {	NULL,	"stab",		S_DOP,		0,	0xCA	},
    {	NULL,	"suba",		S_DOP,		0,	0x40	},
    {	NULL,	"subb",		S_DOP,		0,	0xC0	},

    {	NULL,	"aba",		S_INH37,	0,	0x0B	},
    {	NULL,	"abx",		S_INH37,	0,	0x4F	},
    {	NULL,	"aby",		S_INH37,	0,	0x5F	},
    {	NULL,	"abz",		S_INH37,	0,	0x6F	},
    {	NULL,	"ace",		S_INH37,	0,	0x22	},
    {	NULL,	"aced",		S_INH37,	0,	0x23	},
    {	NULL,	"adx",		S_INH37,	0,	0xCD	},
    {	NULL,	"ady",		S_INH37,	0,	0xDD	},
    {	NULL,	"adz",		S_INH37,	0,	0xED	},
    {	NULL,	"aex",		S_INH37,	0,	0x4D	},
    {	NULL,	"aey",		S_INH37,	0,	0x5D	},
    {	NULL,	"aez",		S_INH37,	0,	0x6D	},
    {	NULL,	"asla",		S_INH37,	0,	0x04	},
    {	NULL,	"aslb",		S_INH37,	0,	0x14	},
    {	NULL,	"asra",		S_INH37,	0,	0x0D	},
    {	NULL,	"asrb",		S_INH37,	0,	0x1D	},
    {	NULL,	"bgnd",		S_INH37,	0,	0xA6	},
    {	NULL,	"cba",		S_INH37,	0,	0x1B	},
    {	NULL,	"clra",		S_INH37,	0,	0x05	},
    {	NULL,	"clrb",		S_INH37,	0,	0x15	},
    {	NULL,	"coma",		S_INH37,	0,	0x00	},
    {	NULL,	"comb",		S_INH37,	0,	0x10	},
    {	NULL,	"daa",		S_INH37,	0,	0x21	},
    {	NULL,	"deca",		S_INH37,	0,	0x01	},
    {	NULL,	"decb",		S_INH37,	0,	0x11	},
    {	NULL,	"ediv",		S_INH37,	0,	0x28	},
    {	NULL,	"edivs",	S_INH37,	0,	0x29	},
    {	NULL,	"emul",		S_INH37,	0,	0x25	},
    {	NULL,	"emuls",	S_INH37,	0,	0x26	},
    {	NULL,	"fdiv",		S_INH37,	0,	0x2B	},
    {	NULL,	"fmuls",	S_INH37,	0,	0x27	},
    {	NULL,	"idiv",		S_INH37,	0,	0x2A	},
    {	NULL,	"inca",		S_INH37,	0,	0x03	},
    {	NULL,	"incb",		S_INH37,	0,	0x13	},
    {	NULL,	"lsla",		S_INH37,	0,	0x04	},
    {	NULL,	"lslb",		S_INH37,	0,	0x14	},
    {	NULL,	"lsra",		S_INH37,	0,	0x0F	},
    {	NULL,	"lsrb",		S_INH37,	0,	0x1F	},
    {	NULL,	"mul",		S_INH37,	0,	0x24	},
    {	NULL,	"nega",		S_INH37,	0,	0x02	},
    {	NULL,	"negb",		S_INH37,	0,	0x12	},
    {	NULL,	"psha",		S_INH37,	0,	0x08	},
    {	NULL,	"pshb",		S_INH37,	0,	0x18	},
    {	NULL,	"pula",		S_INH37,	0,	0x09	},
    {	NULL,	"pulb",		S_INH37,	0,	0x19	},
    {	NULL,	"rola",		S_INH37,	0,	0x0C	},
    {	NULL,	"rolb",		S_INH37,	0,	0x1C	},
    {	NULL,	"rora",		S_INH37,	0,	0x0E	},
    {	NULL,	"rorb",		S_INH37,	0,	0x1E	},
    {	NULL,	"sba",		S_INH37,	0,	0x0A	},
    {	NULL,	"swi",		S_INH37,	0,	0x20	},
    {	NULL,	"tab",		S_INH37,	0,	0x17	},
    {	NULL,	"tap",		S_INH37,	0,	0xFD	},
    {	NULL,	"tba",		S_INH37,	0,	0x07	},
    {	NULL,	"tbsk",		S_INH37,	0,	0x9F	},
    {	NULL,	"tbxk",		S_INH37,	0,	0x9C	},
    {	NULL,	"tbyk",		S_INH37,	0,	0x9D	},
    {	NULL,	"tbzk",		S_INH37,	0,	0x9E	},
    {	NULL,	"tdmsk",	S_INH37,	0,	0x2F	},
    {	NULL,	"tdp",		S_INH37,	0,	0x2D	},
    {	NULL,	"tpa",		S_INH37,	0,	0xFC	},
    {	NULL,	"tpd",		S_INH37,	0,	0x2C	},
    {	NULL,	"tskb",		S_INH37,	0,	0xAF	},
    {	NULL,	"tsta",		S_INH37,	0,	0x06	},
    {	NULL,	"tstb",		S_INH37,	0,	0x16	},
    {	NULL,	"txkb",		S_INH37,	0,	0xAC	},
    {	NULL,	"txs",		S_INH37,	0,	0x4E	},
    {	NULL,	"tykb",		S_INH37,	0,	0xAD	},
    {	NULL,	"tys",		S_INH37,	0,	0x5E	},
    {	NULL,	"tzkb",		S_INH37,	0,	0xAE	},
    {	NULL,	"tzs",		S_INH37,	0,	0x6E	},
    {	NULL,	"xgab",		S_INH37,	0,	0x1A	},
    {	NULL,	"xgdx",		S_INH37,	0,	0xCC	},
    {	NULL,	"xgdy",		S_INH37,	0,	0xDC	},
    {	NULL,	"xgdz",		S_INH37,	0,	0xEC	},
    {	NULL,	"xgex",		S_INH37,	0,	0x4C	},
    {	NULL,	"xgey",		S_INH37,	0,	0x5C	},
    {	NULL,	"xgez",		S_INH37,	0,	0x6C	},

    {	NULL,	"ade",		S_INH27,	0,	0x78	},
    {	NULL,	"asld",		S_INH27,	0,	0xF4	},
    {	NULL,	"asle",		S_INH27,	0,	0x74	},
    {	NULL,	"aslm",		S_INH27,	0,	0xB6	},
    {	NULL,	"asrd",		S_INH27,	0,	0xFD	},
    {	NULL,	"asre",		S_INH27,	0,	0x7D	},
    {	NULL,	"asrm",		S_INH27,	0,	0xBA	},
    {	NULL,	"clrd",		S_INH27,	0,	0xF5	},
    {	NULL,	"clre",		S_INH27,	0,	0x75	},
    {	NULL,	"clrm",		S_INH27,	0,	0xB7	},
    {	NULL,	"comd",		S_INH27,	0,	0xF0	},
    {	NULL,	"come",		S_INH27,	0,	0x70	},
    {	NULL,	"ldhi",		S_INH27,	0,	0xB0	},
    {	NULL,	"lpstop",	S_INH27,	0,	0xF1	},
    {	NULL,	"lsld",		S_INH27,	0,	0xF4	},
    {	NULL,	"lsle",		S_INH27,	0,	0x74	},
    {	NULL,	"lslm",		S_INH27,	0,	0xB6	},
    {	NULL,	"lsrd",		S_INH27,	0,	0xFF	},
    {	NULL,	"lsre",		S_INH27,	0,	0x7F	},
    {	NULL,	"negd",		S_INH27,	0,	0xF2	},
    {	NULL,	"nege",		S_INH27,	0,	0x72	},
    {	NULL,	"nop",		S_INH27,	0,	0x4C	},
    {	NULL,	"pshmac",	S_INH27,	0,	0xB8	},
    {	NULL,	"pulmac",	S_INH27,	0,	0xB9	},
    {	NULL,	"rold",		S_INH27,	0,	0xFC	},
    {	NULL,	"role",		S_INH27,	0,	0x7C	},
    {	NULL,	"rord",		S_INH27,	0,	0xFE	},
    {	NULL,	"rore",		S_INH27,	0,	0x7E	},
    {	NULL,	"rti",		S_INH27,	0,	0x77	},
    {	NULL,	"rts",		S_INH27,	0,	0xF7	},
    {	NULL,	"sde",		S_INH27,	0,	0x79	},
    {	NULL,	"sted",		S_INH27,	0,	0x73	},
    {	NULL,	"sxt",		S_INH27,	0,	0xF8	},
    {	NULL,	"tbek",		S_INH27,	0,	0xFA	},
    {	NULL,	"tde",		S_INH27,	0,	0x7B	},
    {	NULL,	"ted",		S_INH27,	0,	0xFB	},
    {	NULL,	"tedm",		S_INH27,	0,	0xB1	},
    {	NULL,	"tekb",		S_INH27,	0,	0xBB	},
    {	NULL,	"tem",		S_INH27,	0,	0xB2	},
    {	NULL,	"tmer",		S_INH27,	0,	0xB4	},
    {	NULL,	"tmet",		S_INH27,	0,	0xB5	},
    {	NULL,	"tmxed",	S_INH27,	0,	0xB3	},
    {	NULL,	"tstd",		S_INH27,	0,	0xF6	},
    {	NULL,	"tste",		S_INH27,	0,	0x76	},
    {	NULL,	"tsx",		S_INH27,	0,	0x4F	},
    {	NULL,	"tsy",		S_INH27,	0,	0x5F	},
    {	NULL,	"tsz",		S_INH27,	0,	0x6F	},
    {	NULL,	"txy",		S_INH27,	0,	0x5C	},
    {	NULL,	"txz",		S_INH27,	0,	0x6C	},
    {	NULL,	"tyx",		S_INH27,	0,	0x4D	},
    {	NULL,	"tyz",		S_INH27,	0,	0x6D	},
    {	NULL,	"tzx",		S_INH27,	0,	0x4E	},
    {	NULL,	"tzy",		S_INH27,	0,	0x5E	},
    {	NULL,	"wai",		S_INH27,	0,	0xF3	},
    {	NULL,	"xgde",		S_INH27,	0,	0x7A	},

    {	NULL,	"lbcc",		S_LBRA,		0,	0x84	},
    {	NULL,	"lbhs",		S_LBRA,		0,	0x84	},
    {	NULL,	"lbhis",	S_LBRA,		0,	0x84	},
    {	NULL,	"lbcs",		S_LBRA,		0,	0x85	},
    {	NULL,	"lblo",		S_LBRA,		0,	0x85	},
    {	NULL,	"lbeq",		S_LBRA,		0,	0x87	},
    {	NULL,	"lbev",		S_LBRA,		0,	0x91	},
    {	NULL,	"lbge",		S_LBRA,		0,	0x8C	},
    {	NULL,	"lbgt",		S_LBRA,		0,	0x8E	},
    {	NULL,	"lbhi",		S_LBRA,		0,	0x82	},
    {	NULL,	"lble",		S_LBRA,		0,	0x8F	},
    {	NULL,	"lbls",		S_LBRA,		0,	0x83	},
    {	NULL,	"lblos",	S_LBRA,		0,	0x83	},
    {	NULL,	"lblt",		S_LBRA,		0,	0x8D	},
    {	NULL,	"lbmi",		S_LBRA,		0,	0x8B	},
    {	NULL,	"lbmv",		S_LBRA,		0,	0x90	},
    {	NULL,	"lbne",		S_LBRA,		0,	0x86	},
    {	NULL,	"lbpl",		S_LBRA,		0,	0x8A	},
    {	NULL,	"lbra",		S_LBRA,		0,	0x80	},
    {	NULL,	"lbrn",		S_LBRA,		0,	0x81	},
    {	NULL,	"lbvc",		S_LBRA,		0,	0x88	},
    {	NULL,	"lbvs",		S_LBRA,		0,	0x89	},

    {	NULL,	"lbsr",		S_LBSR,		0,	0xF9	},

    {	NULL,	"bcc",		S_BRA,		0,	0xB4	},
    {	NULL,	"bhs",		S_BRA,		0,	0xB4	},
    {	NULL,	"bhis",		S_BRA,		0,	0xB4	},
    {	NULL,	"bcs",		S_BRA,		0,	0xB5	},
    {	NULL,	"blo",		S_BRA,		0,	0xB5	},
    {	NULL,	"beq",		S_BRA,		0,	0xB7	},
    {	NULL,	"bge",		S_BRA,		0,	0xBC	},
    {	NULL,	"bgt",		S_BRA,		0,	0xBE	},
    {	NULL,	"bhi",		S_BRA,		0,	0xB2	},
    {	NULL,	"ble",		S_BRA,		0,	0xBF	},
    {	NULL,	"bls",		S_BRA,		0,	0xB3	},
    {	NULL,	"blos",		S_BRA,		0,	0xB3	},
    {	NULL,	"blt",		S_BRA,		0,	0xBD	},
    {	NULL,	"bmi",		S_BRA,		0,	0xBB	},
    {	NULL,	"bne",		S_BRA,		0,	0xB6	},
    {	NULL,	"bpl",		S_BRA,		0,	0xBA	},
    {	NULL,	"bra",		S_BRA,		0,	0xB0	},
    {	NULL,	"brn",		S_BRA,		0,	0xB1	},
    {	NULL,	"bvc",		S_BRA,		0,	0xB8	},
    {	NULL,	"bvs",		S_BRA,		0,	0xB9	},

    {	NULL,	"bsr",		S_BSR,		S_EOL,	0x36	}
};
