/* m430.h */

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

/*)BUILD
	$(PROGRAM) =	AS430
	$(INCLUDE) = {
		ASXXXX.H
		M430.H
	}
	$(FILES) = {
		M430MCH.C
		M430ADR.C
		M430PST.C
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
 * Addressing types
 */
#define	S_REG		30
#define	S_RIDX		31
#define	S_SYM		32
#define	S_ABS		33
#define	S_RIN		34
#define	S_RIN2		35
#define	S_IMM		36

/*
 * H8 Instruction types
 */
#define	S_DOP		50
#define	S_BRA		51
#define	S_SOP		52
#define	S_PSH		53
#define	S_DST		54
#define	S_RLX		55
#define	S_JXX		56
#define	S_INH		57

/*
 * Extended Addressing Modes
 */
#define	R_JXX	0x0100		/* 10-Bit Jump Addressing Mode */

/*
 * Variables
 */
extern int aindx;

struct adsym
{
	char	a_str[4];	/* addressing string */
	int	a_val;		/* addressing mode value */
};

extern struct adsym reg[];


	/* machine dependent functions */

#ifdef	OTHERSYSTEM
	
	/* m430adr.c */
extern	int		addr(struct expr *esp);
extern	int		admode(struct adsym *sp);
extern	int		any(int c, char *str);
extern	int		srch(char *str);

	/* m430mch.c */
extern	VOID		machine(struct mne *mp);
extern	int		abstype(struct expr *esp);
extern	int		mchpcr(struct expr *esp);
extern	VOID		minit(void);

#else

	/* m430adr.c */
extern	int		addr();
extern	int		admode();
extern	int		any();
extern	int		srch();

	/* m430mch.c */
extern	VOID		machine();
extern	int		abstype();
extern	int		mchpcr();
extern	VOID		minit();

#endif

