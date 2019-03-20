/* m6805.h */

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

/*)BUILD
	$(PROGRAM) =	AS6805
	$(INCLUDE) = {
		ASXXXX.H
		M6805.H
	}
	$(FILES) = {
		M05MCH.C
		M05ADR.C
		M05PST.C
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
	char	a_str[2];	/* addressing string */
	int	a_val;		/* addressing mode value */
};

/*
 * Addressing types
 */
#define	S_IMMED	30
#define	S_DIR	31
#define	S_EXT	32
#define	S_IX	33
#define	S_I8X	34
#define	S_INDX	35
#define	S_A	36
#define	S_X	37

/*
 * Instruction types
 */
#define	S_INH	60
#define	S_BRA	61
#define	S_TYP1	62
#define	S_TYP2	63
#define	S_TYP3	64
#define	S_TYP4	65

/*
 * Special Types
 */
#define	S_SDP	80
#define	S_CPU	81

/*
 * Processor Types (S_CPU)
 */
#define	X_6805	0
#define	X_HC05	1


	/* machine dependent functions */

#ifdef	OTHERSYSTEM
	
	/* m05adr.c */
extern	struct	adsym	ax[];
extern	int		addr(struct expr *esp);
extern	int		admode(struct adsym *sp);
extern	int		any(int c, char *str);
extern	int		srch(char *str);

	/* m05mch.c */
extern	VOID		machine(struct mne *mp);
extern	int		mchpcr(struct expr *esp);
extern	VOID		minit(void);

#else

	/* m05adr.c */
extern	struct	adsym	ax[];
extern	int		addr();
extern	int		admode();
extern	int		any();
extern	int		srch();

	/* m05mch.c */
extern	VOID		machine();
extern	int		mchpcr();
extern	VOID		minit();

#endif

