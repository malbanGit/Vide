/* m6800.h */

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
	$(PROGRAM) =	AS6800
	$(INCLUDE) = {
		ASXXXX.H
		M6800.H
	}
	$(FILES) = {
		M00MCH.C
		M00ADR.C
		M00PST.C
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
 * Registers
 */
#define	A	0x00
#define	B	0x10
#define	X	0x20

/*
 * Addressing types
 */
#define	S_A	30
#define	S_B	31
#define	S_X	32
#define	S_IMMED	33
#define	S_DIR	34
#define	S_EXT	35
#define	S_INDX	36

/*
 * Instruction types
 */
#define	S_INH	60
#define	S_PUL	61
#define	S_BRA	62
#define	S_TYP1	63
#define	S_TYP2	64
#define	S_TYP3	65
#define	S_TYP4	66
#define	S_TYP5	67

/*
 * Set Direct Pointer
 */
#define	S_SDP	80


	/* machine dependent functions */

#ifdef	OTHERSYSTEM

	/* m00adr.c */
extern	struct	adsym	abx[];
extern	int		addr(struct expr *esp);
extern	int		admode(struct adsym *sp);
extern	int		any(int c, char *str);
extern	int		srch(char *str);

	/* m00mch.c */
extern	VOID		machine(struct mne *mp);
extern	int		mchpcr(struct expr *esp);
extern	VOID		minit(void);

#else

	/* m00adr.c */
extern	struct	adsym	abx[];
extern	int		addr();
extern	int		admode();
extern	int		any();
extern	int		srch();

	/* m00mch.c */
extern	VOID		machine();
extern	int		mchpcr();
extern	VOID		minit();

#endif

