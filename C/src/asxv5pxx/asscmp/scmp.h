/* scmp.h */

/*
 *  Copyright (C) 2009  Alan R. Baldwin
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
	$(PROGRAM) =	ASSCMP
	$(INCLUDE) = {
		ASXXXX.H
		SCMP.H
	}
	$(FILES) = {
		SCMPMCH.C
		SCMPADR.C
		SCMPPST.C
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
 * Addressing types
 */
#define	S_PTR	30
#define	S_IMM	31
#define	S_EXT	32
#define	S_IDX	33

/*
 * Instruction types
 */
#define	S_MRI	60
#define	S_DLY	61
#define	S_II	62
#define	S_MID	63
#define	S_JMP	64
#define	S_XP	65
#define	S_INH	66

/*
 * Set Direct Pointer
 */
#define	S_SDP	80


	/* machine dependent functions */

#ifdef	OTHERSYSTEM

	/* scmpadr.c */
extern 	int		aindx;
extern	struct	adsym	ptr[];
extern	int		addr(struct expr *esp);
extern	int		admode(struct adsym *sp);
extern	int		any(int c, char *str);
extern	int		srch(char *str);

	/* scmpmch.c */
extern	VOID		machine(struct mne *mp);
extern	int		mchpcr(struct expr *esp);
extern	VOID		minit(void);

#else

	/* scmpadr.c */
extern 	int		aindx;
extern	struct	adsym	ptr[];
extern	int		addr();
extern	int		admode();
extern	int		any();
extern	int		srch();

	/* scmpmch.c */
extern	VOID		machine();
extern	int		mchpcr();
extern	VOID		minit();

#endif

