/* avrpst.c */

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

#include "asxxxx.h"
#include "avr.h"

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
 * Basic Merge Mode Definition
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
 * Additional Merge Mode Definitions
 */
char mode1[32] = {	/* S_IBYTE instructions */
	/* |----|KKKK|----|KKKK| */
	'\200',	'\201',	'\202',	'\203',	'\210',	'\211',	'\212',	'\213',
	'\010',	'\011',	'\012',	'\013',	'\014',	'\015',	'\016',	'\017',
	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};

char mode2[32] = {	/* S_IWORD instructions */
	/* |----|----|KK--|KKKK| */
	'\200',	'\201',	'\202',	'\203',	'\206',	'\207',	'\006',	'\007',
	'\010',	'\011',	'\012',	'\013',	'\014',	'\015',	'\016',	'\017',
	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};

char mode3[32] = {	/* S_BRA   instructions */
	/* |----|--KK|KKKK|K---| */
	'\203',	'\204',	'\205',	'\206',	'\207',	'\210',	'\211',	'\007',
	'\010',	'\011',	'\012',	'\013',	'\014',	'\015',	'\016',	'\017',
	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};

char mode4[32] = {	/* S_JMP  instructions */
	/* |----|---K|KKKK|---K| // |KKKK|KKKK|KKKK|KKKK| */
	'\220',	'\221',	'\222',	'\223',	'\224',	'\225',	'\226',	'\227',
	'\230',	'\231',	'\232',	'\233',	'\234',	'\235',	'\236',	'\237',
	'\200',	'\204',	'\205',	'\206',	'\207',	'\210',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};

char mode5[32] = {	/* S_IOP  instructions */
	/* |----|-KK-|----|KKKK| */
	'\200',	'\201',	'\202',	'\203',	'\211',	'\212',	'\006',	'\007',
	'\010',	'\011',	'\012',	'\013',	'\014',	'\015',	'\016',	'\017',
	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};

char mode6[32] = {	/* S_IOR  instructions */
	/* |----|----|KKKK|K---| */
	'\203',	'\204',	'\205',	'\206',	'\207',	'\005',	'\006',	'\007',
	'\010',	'\011',	'\012',	'\013',	'\014',	'\015',	'\016',	'\017',
	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};

char mode7[32] = {	/* S_ILDST instructions */
	/* |--K-|KK--|----|-KKK| */
	'\200',	'\201',	'\202',	'\212',	'\213',	'\215',	'\006',	'\007',
	'\010',	'\011',	'\012',	'\013',	'\014',	'\015',	'\016',	'\017',
	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};

char mode8[32] = {	/* S_RJMP instructions */
	/* |----|KKKK|KKKK|KKKK| */
	'\200',	'\201',	'\202',	'\203',	'\204',	'\205',	'\206',	'\207',
	'\210',	'\211',	'\212',	'\213',	'\014',	'\015',	'\016',	'\017',
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
struct	mode	mode[9] = {
    {	&mode0[0],	0l,	0xFFFFFFFFl,	0xFFFFFFFFl	},	/* R_NORM  */
    {	&mode1[0],	1l,	0x00000F0Fl,	0x000000FFl	},	/* S_IBYTE */
    {	&mode2[0],	1l,	0x000000CFl,	0x0000003Fl	},	/* S_IWORD */
    {	&mode3[0],	1l,	0x000003F8l,	0x0000007Fl	},	/* S_BRA   */
    {	&mode4[0],	1l,	0xFFFF01F1l,	0x003FFFFFl	},	/* S_JMP  */
    {	&mode5[0],	1l,	0x0000060Fl,	0x0000003Fl	},	/* S_IOP   */
    {	&mode6[0],	1l,	0x000000F8l,	0x0000001Fl	},	/* S_IOR   */
    {	&mode7[0],	1l,	0x00002C07l,	0x0000003Fl	},	/* S_ILDST */
    {	&mode8[0],	0l,	0x00000FFFl,	0x00000FFFl	},	/* S_RJMP  */
};
#else
struct	mode	mode[9] = {
    {	&mode0[0],	0,	0xFFFFFFFF,	0xFFFFFFFF	},	/* R_NORM  */
    {	&mode1[0],	1,	0x00000F0F,	0x000000FF	},	/* S_IBYTE */
    {	&mode2[0],	1,	0x000000CF,	0x0000003F	},	/* S_IWORD */
    {	&mode3[0],	1,	0x000003F8,	0x0000007F	},	/* S_BRA   */
    {	&mode4[0],	1,	0xFFFF01F1,	0x003FFFFF	},	/* S_JMP  */
    {	&mode5[0],	1,	0x0000060F,	0x0000003F	},	/* S_IOP   */
    {	&mode6[0],	1,	0x000000F8,	0x0000001F	},	/* S_IOR   */
    {	&mode7[0],	1,	0x00002C07,	0x0000003F	},	/* S_ILDST */
    {	&mode8[0],	0,	0x00000FFF,	0x00000FFF	},	/* S_RJMP  */
};
#endif

/*
 * Array of Pointers to mode Structures
 */
struct	mode	*modep[16] = {
	&mode[0],	&mode[1],	&mode[2],	&mode[3],
	&mode[4],	&mode[5],	&mode[6],	&mode[7],
	&mode[8],	NULL,		NULL,		NULL,
	NULL,		NULL,		NULL,		NULL
};

/*
 * Mnemonic Structure
 */
struct	mne	mne[] = {

	/* machine */

    {	NULL,	"CSEG",		S_ATYP,		0,	A_CSEG|A_2BYTE	},
    {	NULL,	"DSEG",		S_ATYP,		0,	A_DSEG|A_1BYTE	},

    {	NULL,	".avr_4k",	S_4K,		0,	0	},

    {	NULL,	".AT90SXXXX",	S_CPU,		0,	AT90Sxxxx	},
    {	NULL,	".AT90S1200",	S_CPU,		0,	AT90S1200	},
    {	NULL,	".AT90S2313",	S_CPU,		0,	AT90S2313	},
    {	NULL,	".AT90S2323",	S_CPU,		0,	AT90S2323	},
    {	NULL,	".AT90S2343",	S_CPU,		0,	AT90S2343	},
    {	NULL,	".AT90S2333",	S_CPU,		0,	AT90S2333	},
    {	NULL,	".AT90S4433",	S_CPU,		0,	AT90S4433	},
    {	NULL,	".AT90S4414",	S_CPU,		0,	AT90S4414	},
    {	NULL,	".AT90S4434",	S_CPU,		0,	AT90S4434	},
    {	NULL,	".AT90S8515",	S_CPU,		0,	AT90S8515	},
    {	NULL,	".AT90C8534",	S_CPU,		0,	AT90C8534	},
    {	NULL,	".AT90S8535",	S_CPU,		0,	AT90S8535	},
    {	NULL,	".ATmega103",	S_CPU,		0,	ATmega103	},
    {	NULL,	".ATmega603",	S_CPU,		0,	ATmega603	},
    {	NULL,	".ATmega161",	S_CPU,		0,	ATmega161	},
    {	NULL,	".ATmega163",	S_CPU,		0,	ATmega163	},
    {	NULL,	".ATtiny10",	S_CPU,		0,	ATtiny10	},
    {	NULL,	".ATtiny11",	S_CPU,		0,	ATtiny11	},
    {	NULL,	".ATtiny12",	S_CPU,		0,	ATtiny12	},
    {	NULL,	".ATtiny15",	S_CPU,		0,	ATtiny15	},
    {	NULL,	".ATtiny22",	S_CPU,		0,	ATtiny22	},
    {	NULL,	".ATtiny28",	S_CPU,		0,	ATtiny28	},

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
    {	NULL,	".4byte",	S_DATA,		0,	O_4BYTE	},
    {	NULL,	".quad",	S_DATA,		0,	O_4BYTE	},
    {	NULL,	".blkb",	S_BLK,		0,	O_1BYTE	},
    {	NULL,	".ds",		S_BLK,		0,	O_1BYTE	},
    {	NULL,	".rmb",		S_BLK,		0,	O_1BYTE	},
    {	NULL,	".rs",		S_BLK,		0,	O_1BYTE	},
    {	NULL,	".blkw",	S_BLK,		0,	O_2BYTE	},
    {	NULL,	".blk3",	S_BLK,		0,	O_3BYTE	},
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

    {	NULL,	"andi",		S_IBYTE,	0,	0x7000	},
    {	NULL,	"cpi",		S_IBYTE,	0,	0x3000	},
    {	NULL,	"ldi",		S_IBYTE,	0,	0xE000	},
    {	NULL,	"ori",		S_IBYTE,	0,	0x6000	},
    {	NULL,	"sbci",		S_IBYTE,	0,	0x4000	},
    {	NULL,	"sbr",		S_IBYTE,	0,	0x6000	},
    {	NULL,	"subi",		S_IBYTE,	0,	0x5000	},

    {	NULL,	"cbr",		S_CBR,		0,	0x7000	},

    {	NULL,	"adiw",		S_IWORD,	0,	0x9600	},
    {	NULL,	"sbiw",		S_IWORD,	0,	0x9700	},

    {	NULL,	"asr",		S_SNGL,		0,	0x9405	},
    {	NULL,	"com",		S_SNGL,		0,	0x9400	},
    {	NULL,	"dec",		S_SNGL,		0,	0x940A	},
    {	NULL,	"inc",		S_SNGL,		0,	0x9403	},
    {	NULL,	"lsr",		S_SNGL,		0,	0x9406	},
    {	NULL,	"neg",		S_SNGL,		0,	0x9401	},
    {	NULL,	"pop",		S_SNGL,		0,	0x900F	},
    {	NULL,	"push",		S_SNGL,		0,	0x920F	},
    {	NULL,	"ror",		S_SNGL,		0,	0x9407	},
    {	NULL,	"swap",		S_SNGL,		0,	0x9402	},
    
    {	NULL,	"clr",		S_SAME,		0,	0x2400	},
    {	NULL,	"lsl",		S_SAME,		0,	0x0C00	},
    {	NULL,	"rol",		S_SAME,		0,	0x1C00	},
    {	NULL,	"tst",		S_SAME,		0,	0x2000	},

    {	NULL,	"adc",		S_DUBL,		0,	0x1C00	},
    {	NULL,	"add",		S_DUBL,		0,	0x0C00	},
    {	NULL,	"and",		S_DUBL,		0,	0x2000	},
    {	NULL,	"cp",		S_DUBL,		0,	0x1400	},
    {	NULL,	"cpc",		S_DUBL,		0,	0x0400	},
    {	NULL,	"cpse",		S_DUBL,		0,	0x1000	},
    {	NULL,	"eor",		S_DUBL,		0,	0x2400	},
    {	NULL,	"mov",		S_DUBL,		0,	0x2C00	},
    {	NULL,	"or",		S_DUBL,		0,	0x2800	},
    {	NULL,	"sbc",		S_DUBL,		0,	0x0800	},
    {	NULL,	"sub",		S_DUBL,		0,	0x1800	},

    {	NULL,	"movw",		S_MOVW,		0,	0x0100	},

    {	NULL,	"mul",		S_MUL,		0,	0x9C00	},
    {	NULL,	"muls",		S_MULS,		0,	0x0200	},
    {	NULL,	"mulsu",	S_FMUL,		0,	0x0300	},
    {	NULL,	"fmul",		S_FMUL,		0,	0x0308	},
    {	NULL,	"fmuls",	S_FMUL,		0,	0x0380	},
    {	NULL,	"fmulsu",	S_FMUL,		0,	0x0388	},

    {	NULL,	"ser",		S_SER,		0,	0xEF0F	},

    {	NULL,	"bclr",		S_SREG,		0,	0x9488	},
    {	NULL,	"bset",		S_SREG,		0,	0x9408	},

    {	NULL,	"bld",		S_TFLG,		0,	0xF800	},
    {	NULL,	"bst",		S_TFLG,		0,	0xFA00	},

    {	NULL,	"brcc",		S_BRA,		0,	0xF400	},
    {	NULL,	"brcs",		S_BRA,		0,	0xF000	},
    {	NULL,	"breq",		S_BRA,		0,	0xF001	},
    {	NULL,	"brge",		S_BRA,		0,	0xF404	},
    {	NULL,	"brhc",		S_BRA,		0,	0xF405	},
    {	NULL,	"brhs",		S_BRA,		0,	0xF005	},
    {	NULL,	"brid",		S_BRA,		0,	0xF407	},
    {	NULL,	"brie",		S_BRA,		0,	0xF007	},
    {	NULL,	"brlo",		S_BRA,		0,	0xF000	},
    {	NULL,	"brlt",		S_BRA,		0,	0xF004	},
    {	NULL,	"brmi",		S_BRA,		0,	0xF002	},
    {	NULL,	"brne",		S_BRA,		0,	0xF401	},
    {	NULL,	"brpl",		S_BRA,		0,	0xF402	},
    {	NULL,	"brsh",		S_BRA,		0,	0xF400  },
    {	NULL,	"brtc",		S_BRA,		0,	0xF406	},
    {	NULL,	"brts",		S_BRA,		0,	0xF006	},
    {	NULL,	"brvc",		S_BRA,		0,	0xF403	},
    {	NULL,	"brvs",		S_BRA,		0,	0xF003	},

    {	NULL,	"brbc",		S_SBRA,		0,	0xF400	},
    {	NULL,	"brbs",		S_SBRA,		0,	0xF000	},

    {	NULL,	"sbrc",		S_SKIP,		0,	0xFC00	},
    {	NULL,	"sbrs",		S_SKIP,		0,	0xFE00	},

    {	NULL,	"call",		S_JMP,		0,	0x940E	},
    {	NULL,	"jmp",		S_JMP,		0,	0x940C	},

    {	NULL,	"rcall",	S_RJMP,		0,	0xD000	},
    {	NULL,	"rjmp",		S_RJMP,		0,	0xC000	},

    {	NULL,	"cbi",		S_IOR,		0,	0x9800	},
    {	NULL,	"sbi",		S_IOR,		0,	0x9A00	},
    {	NULL,	"sbic",		S_IOR,		0,	0x9900	},
    {	NULL,	"sbis",		S_IOR,		0,	0x9B00	},

    {	NULL,	"in",		S_IN,		0,	0xB000	},
    {	NULL,	"out",		S_OUT,		0,	0xB800	},

    {	NULL,	"ld",		S_LD,		0,	0x8000	},
    {	NULL,	"st",		S_ST,		0,	0x8200	},

    {	NULL,	"ldd",		S_ILD,		0,	0x8000	},
    {	NULL,	"std",		S_IST,		0,	0x8200	},

    {	NULL,	"lds",		S_LDS,		0,	0x9000	},
    {	NULL,	"sts",		S_STS,		0,	0x9200	},

    {	NULL,	"elpm",		S_ELPM,		0,	0x95D8	},
    {	NULL,	"lpm",		S_LPM,		0,	0x95C8	},

    {	NULL,	"eicall",	S_INH,		0,	0x9519	},
    {	NULL,	"eijmp",	S_INH,		0,	0x9419	},
    {	NULL,	"ijmp",		S_INH,		0,	0x9409	},
    {	NULL,	"icall",	S_INH,		0,	0x9509	},
    {	NULL,	"ret",		S_INH,		0,	0x9508	},
    {	NULL,	"reti",		S_INH,		0,	0x9518	},

    {	NULL,	"sec",		S_INH,		0,	0x9408	},
    {	NULL,	"sez",		S_INH,		0,	0x9418	},
    {	NULL,	"sen",		S_INH,		0,	0x9428	},
    {	NULL,	"sev",		S_INH,		0,	0x9438	},
    {	NULL,	"ses",		S_INH,		0,	0x9448	},
    {	NULL,	"seh",		S_INH,		0,	0x9458	},
    {	NULL,	"set",		S_INH,		0,	0x9468	},
    {	NULL,	"sei",		S_INH,		0,	0x9478	},

    {	NULL,	"clc",		S_INH,		0,	0x9488	},
    {	NULL,	"clz",		S_INH,		0,	0x9498	},
    {	NULL,	"cln",		S_INH,		0,	0x94A8	},
    {	NULL,	"clv",		S_INH,		0,	0x94B8	},
    {	NULL,	"cls",		S_INH,		0,	0x94C8	},
    {	NULL,	"clh",		S_INH,		0,	0x94D8	},
    {	NULL,	"clt",		S_INH,		0,	0x94E8	},
    {	NULL,	"cli",		S_INH,		0,	0x94F8	},

    {	NULL,	"nop",		S_INH,		0,	0x0000	},
    {	NULL,	"sleep",	S_INH,		0,	0x9588	},
    {	NULL,	"break",	S_INH,		0,	0x9598	},
    {	NULL,	"spm",		S_INH,		0,	0x95E8	},
    {	NULL,	"wdr",		S_INH,		S_EOL,	0x95A8	}
};




