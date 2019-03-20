/* z8.h */

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
	$(PROGRAM) =	ASZ8
	$(INCLUDE) = {
		ASXXXX.H
		Z8.H
	}
	$(FILES) = {
		Z8MCH.C
		Z8ADR.C
		Z8PST.C
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
 * Offset Indexing modes
 */
#define	S_INDR	0x20
#define	S_INDM	0xF0
/*
 *	S_INDR0		0x20	==>>	32
 *	S_INDR1		0x21
 *	...
 *	S_INDR14	0x2E
 *	S_INDR15	0x2F	==>>	47
 */

/*
 * Symbol types
 */
#define	S_IMMED	50
#define	S_R	51
#define	S_RR	52

#define	S_IR	53
#define	S_IRR	54
#define	S_INDX	55

/*
 * Instruction types
 */
#define	S_SOP	60
#define	S_DOP	61
#define	S_INC	62
#define	S_INCW	63
#define	S_DECW	64
#define	S_LD	65
#define	S_LDCE	66
#define	S_LDCEI	67
#define	S_DJNZ	68
#define	S_JR	69
#define	S_JP	70
#define	S_CALL	71
#define	S_SRP	72
#define	S_INH	73

struct adsym
{
	char	a_str[8];	/* addressing string */
	int	a_val;		/* addressing mode value */
};

extern	struct	adsym	R[];
extern	struct	adsym	RR[];
extern	struct	adsym	CND[];

	/* machine dependent functions */

#ifdef	OTHERSYSTEM
	
	/* z8adr.c */
extern	int		addr(struct expr *esp);
extern	int		admode(struct adsym *sp);
extern	int		srch(char *str);

	/* z8mch.c */
extern	VOID		machine(struct mne *mp);
extern	int		mchpcr(struct expr *esp);
extern	VOID		minit(void);

#else

	/* z8adr.c */
extern	int		addr();
extern	int		admode();
extern	int		srch();

	/* z8mch.c */
extern	VOID		machine();
extern	int		mchpcr();
extern	VOID		minit();

#endif

