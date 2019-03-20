/* ez80.h */

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
 *
 *
 * Ported by Patrick Head
 * from the ASZ80 assembler.
 *
 * patrick at phead dot net
 */

/*)BUILD
	$(PROGRAM) =	ASEZ80
	$(INCLUDE) = {
		ASXXXX.H
		EZ80.H
	}
	$(FILES) = {
		EZ80MCH.C
		EZ80ADR.C
		EZ80PST.C
		ASMAIN.C
		ASDBG.C
		ASLEX.C
		ASSYM.C
		ASSUBR.C
		ASEXPR.C
		ASDATA.C
		ASLIST.C
		ASOUT.C
	}
	$(STACK) = 3000
*/

/*
 * Indirect Addressing delimeters
 */
#define	LFIND	'('
#define RTIND	')'

/*
 * Registers
 */
#define B	0
#define C	1
#define D	2
#define E	3
#define H	4
#define L	5
#define A	7

#define I	0107
#define R	0117

#define BC	0
#define DE	1
#define HL	2
#define SP	3
#define AF	4
#define IX	5
#define IY	6
#define IXH	7
#define IXL	8
#define IYH	9
#define IYL	10
#define MB	11

/*
 * Conditional definitions
 */
#define	NZ	0
#define	Z	1
#define	NC	2
#define	CS	3
#define	PO	4
#define	PE	5
#define	P	6
#define	M	7

/*
 * Symbol types
 */
#define	S_IMMED	30
#define	S_R8	31
#define	S_R8X	32
#define	S_RX	33
#define	S_RXX	34
#define	S_CND	35
#define	S_FLAG	36

/*
 * Indexing modes
 */
#define	S_INDB	40
#define	S_IDC	41
#define	S_INDR	50
#define	S_IDBC	50
#define	S_IDDE	51
#define	S_IDHL	52
#define	S_IDSP	53
#define	S_IDIX	55
#define	S_IDIY	56
#define	S_INDM	57

/*
 * Instruction types
 */
#define	S_LD	60
#define	S_CALL	61
#define	S_JP	62
#define	S_JR	63
#define	S_RET	64
#define	S_BIT	65
#define	S_INC	66
#define	S_DEC	67
#define	S_ADD	68
#define	S_ADC	69
#define	S_AND	70
#define	S_EX	71
#define	S_PUSH	72
#define	S_IN	73
#define	S_OUT	74
#define	S_IN0	75
#define	S_OUT0	76
#define	S_RL	77
#define	S_RST	78
#define	S_IM	79
#define	S_INH1	80
#define	S_INH2	81
#define	S_DJNZ	82
#define	S_SUB	83
#define	S_SBC	84

/*
 * eZ80 specific instructions
 */
#define	S_AMOD	90
#define	S_LEA	91
#define	S_MIX	92
#define S_MLT   93
#define	S_PEA	94
#define S_TST   95
#define S_TSTIO 96

/*
 * eZ80 specific addressing modes
 */
#define MM_ADL	0
#define MM_Z80	1

/*
 * eZ80 specific addressing extensions (used in mne m_flag)
 */
#define	M_L	0x01
#define	M_S	0x02
#define	M_IL	0x04
#define	M_IS	0x08
#define M_LIL	(M_L | M_IL)
#define M_LIS	(M_L | M_IS)
#define	M_SIL	(M_S | M_IL)
#define	M_SIS	(M_S | M_IS)

/*
 * Extended Addressing Modes
 */
#define	R_ADL	0x0000		/* 24-Bit Addressing Mode */
#define	R_Z80	0x0100		/* 16-Bit Addressing Mode */
#define	R_3BIT	0x0200		/*  3-Bit Addressing Mode */

struct adsym
{
	char	a_str[4];	/* addressing string */
	int	a_val;		/* addressing mode value */
};

extern	struct	adsym	R8[];
extern	struct	adsym	R8X[];
extern	struct	adsym	RX[];
extern	struct	adsym	RXX[];
extern	struct	adsym	CND[];

	/* machine dependent functions */

#ifdef	OTHERSYSTEM
	
	/* ez80adr.c */
extern	int		addr(struct expr *esp);
extern	int		admode(struct adsym *sp);
extern	int		srch(char *str);

	/* ez80mch.c */
extern	int		genop(int pop, int op, struct expr *esp, int f);
extern	int		genopm(int pop, int op, struct expr *esm, struct expr *esp, int f);
extern	int		gixiy(int v);
extern	VOID		glilsis(int mode, int sfx, struct expr *esp);
extern	VOID		machine(struct mne *mp);
extern	int		mchpcr(struct expr *esp);
extern	VOID		minit(void);

#else

	/* ez80adr.c */
extern	int		addr();
extern	int		admode();
extern	int		srch();

	/* ez80mch.c */
extern	int		genop();
extern	int		genopm();
extern	int		gixiy();
extern	VOID		glilsis();
extern	VOID		machine();
extern	int		mchpcr();
extern	VOID		minit();

#endif

