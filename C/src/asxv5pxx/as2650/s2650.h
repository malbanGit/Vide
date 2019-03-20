/* s2650.h */

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
	$(PROGRAM) =	AS2650
	$(INCLUDE) = {
		ASXXXX.H
		S2650.H
	}
	$(FILES) = {
		S26MCH.C
		S26ADR.C
		S26PST.C
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
	char	a_str[6];	/* addressing string */
	int	a_val;		/* addressing mode value */
};

/*
 * Merge Modes
 */

#define	M_2BIT		0x0100
#define	M_7BIT		0x0200
#define	M_13BIT		0x0300
#define	M_15BIT		0x0400

/*
 * Addressing types
 */
#define	S_REG	30
#define	S_IMMED	31
#define	S_EXT	32
#define	S_INDX	33
#define	S_CC	34

/*
 * Instruction types
 */
#define	S_IO	60
#define	S_IOE	61
#define	S_TYP1	62
#define	S_TYP2	63
#define	S_TYP3	64
#define	S_TYP4	65
#define	S_TYP5	66
#define	S_RET	67
#define	S_INH	68

#define	S_BRAZ	70
#define	S_BRAE	71
#define	S_BRCR	72
#define	S_BRCA	73
#define	S_BRRR	74
#define	S_BRRA	75

/*
 * Set Direct Pointer
 */
#define	S_SDP	80


	/* machine dependent functions */

#ifdef	OTHERSYSTEM

	/* s26adr.c */
extern 	int		aindx;
extern	struct	adsym	cc[];
extern	struct	adsym	reg[];
extern	struct	adsym	ireg[];
extern	int		addr(struct expr *esp);
extern	int		admode(struct adsym *sp);
extern	int		any(int c, char *str);
extern	int		srch(char *str);

	/* s26mch.c */
extern	VOID		machine(struct mne *mp);
extern	int		mchpcr(struct expr *esp);
extern	VOID		minit(void);

#else

	/* s26adr.c */
extern 	int		aindx;
extern	struct	adsym	cc[];
extern	struct	adsym	reg[];
extern	struct	adsym	ireg[];
extern	int		addr();
extern	int		admode();
extern	int		any();
extern	int		srch();

	/* s26mch.c */
extern	VOID		machine();
extern	int		mchpcr();
extern	VOID		minit();

#endif

