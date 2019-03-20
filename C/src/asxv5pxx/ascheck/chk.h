/* chk.h */

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

/*)BUILD
	$(PROGRAM) =	ASCHECK
	$(INCLUDE) = {
		ASXXXX.H
		CHK.H
	}
	$(FILES) = {
		CHKMCH.C
		CHKADR.C
		CHKPST.C
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

/*
 * Addressing types
 */

/*
 * Instruction types
 */
#define	S_OPCODE	40

/*
 * Set Direct Pointer
 */
#define	S_SDP		80

/*
 * Machine Type
 */
#define	S_CPU		81

/*
 * Processor Types (S_CPU)
 */
#define	X_NOCPU		0



	/* machine dependent functions */

#ifdef	OTHERSYSTEM

	/* chkadr.c */
extern	struct	adsym	reg[];
extern	int		addr(struct expr *esp);
extern	int		admode(struct adsym *sp);
extern	int		any(int c, char *str);
extern	int		srch(char *str);

	/* chkmch.c */
extern	VOID		machine(struct mne *mp);
extern	int		mchpcr(struct expr *esp);
extern	VOID		minit(void);

#else

	/* chkadr.c */
extern	struct	adsym	reg[];
extern	int		addr();
extern	int		admode();
extern	int		any();
extern	int		srch();

	/* chkmch.c */
extern	VOID		machine();
extern	int		mchpcr();
extern	VOID		minit();

#endif

