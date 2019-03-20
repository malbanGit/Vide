/* f2mc8.h */

/*
 *  Copyright (C) 2005-2009  Alan R. Baldwin
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

/*)BUILD
	$(PROGRAM) =	ASF2MC8
	$(INCLUDE) = {
		ASXXXX.H
		F2MC8.H
	}
	$(FILES) = {
		F8MCH.C
		F8ADR.C
		F8PST.C
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

struct adsym
{
	char	a_str[4];	/* addressing string */
	int	a_val;		/* addressing mode value */
};


/*
 * Extended Addressing Modes
 */
#define	R_3BIT	0x0100		/* 3-Bit Addressing Mode */


/*
 * Addressing types
 */
#define	S_A	30
#define	S_T	31

/*
 * PC, SP, IX, EP  ->  aindex = 0, 1, 2, 3
 */
#define	S_PC	32
#define	S_SP	33
#define	S_IX	34
#define	S_EP	35

#define	S_PS	36

#define	S_IMMED	37
#define	S_DIR	38
#define	S_EXT	39
#define	S_INDX	40

/*
 * R0 - R7,  aindex = 0 - 7
 */
#define	S_R	48

/*
 * Instruction types
 */
#define	S_AOP	60

#define	S_MOV	62
#define	S_MOVW	63
#define	S_OP	64

#define	S_JMP	66
#define	S_CALL	67
#define	S_CALLV	68
#define	S_PUSH	69
#define	S_XCH	70
#define	S_XCHW	71
#define	S_BIT	72
#define	S_BRAB	73
#define	S_DEC	74
#define	S_DECW	75
#define	S_BRA	76
#define	S_INH	77

/*
 * Set Direct Pointer
 */
#define	S_SDP	80

/*
 * Machine Type
 */
#define	S_CPU	81

/*
 * Processor Types (S_CPU)
 */
#define	X_8L	0
#define	X_8FX	1



	/* machine dependent functions */

#ifdef	OTHERSYSTEM

	/* f8adr.c */
extern	int		aindex;
extern	struct	adsym	reg[];
extern	int		addr(struct expr *esp);
extern	int		admode(struct adsym *sp);
extern	int		any(int c, char *str);
extern	int		srch(char *str);

	/* f8mch.c */
extern	VOID		machine(struct mne *mp);
extern	int		mchpcr(struct expr *esp);
extern	VOID		minit(void);

#else

	/* f8adr.c */
extern	int		aindex;
extern	struct	adsym	reg[];
extern	int		addr();
extern	int		admode();
extern	int		any();
extern	int		srch();

	/* f8mch.c */
extern	VOID		machine();
extern	int		mchpcr();
extern	VOID		minit();

#endif

