/* s61860.h */

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
 *
 * Ported for SC61860 by Edgar Puehringer
 */

/*)BUILD
	$(PROGRAM) =	AS61860
	$(INCLUDE) = {
		ASXXXX.H
		S61860.H
	}
	$(FILES) = {
		S6186MCH.C
		S6186ADR.C
		S6186PST.C
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
 * Addressing Modes
 */
#define	S_IMM	40		/* Immediate Value */
#define	S_EXT	41		/* Extended Addressing */

/*
 * Symbol types.
 */
#define	S_INH	50		/* One byte */
#define	S_CAL	51		/* The CAL mnemonic */
#define	S_ADI	52		/* One byte immediate */
#define	S_LP	53	        /* The LP mnemonic */
#define	S_JMP	54		/* Jumps, calls, etc. */
#define	S_JRP	55		/* Jump relative plus */
#define	S_JRM	56		/* Jump relative minus */
#define	S_PTC	57		/* Prepare table call */

/*
 * Machine Specific
 */
#define	S_CASE	90		/* .case dummy instructions */
#define	S_DEFA	91		/* default dummy instruction */
#define	S_BASIC	92		/* old (non ascii) string */

/*
 * Extended Addressing Modes
 */
#define	R_6BIT	0x0100		/*  6-Bit Addressing Mode */
#define	R_13BIT	0x0200		/* 13-Bit Addressing Mode */


	/* machine dependent functions */

#ifdef	OTHERSYSTEM
	
	/* s6186mch.c */
extern	int		ascii2sbasic(int c);
extern	VOID		machine(struct mne *mp);
extern	int		mchpcr(struct expr *esp);
extern	VOID		minit(void);

	/* s6186adr.c */
extern	int		addr(struct expr *esp);

#else

	/* s6186mch.c */
extern	int		ascii2sbasic();
extern	VOID		machine();
extern	int		mchpcr();
extern	VOID		minit();

	/* s6186adr.c */
extern	int		addr();

#endif
