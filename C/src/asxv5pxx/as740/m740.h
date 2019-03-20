/* m740.h */

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

/*
 * Contributions by
 *
 * Uwe Steller
 */

/*)BUILD
	$(PROGRAM) = AS740
	$(INCLUDE) = {
		ASXXXX.H
		M740.H
	}
	$(FILES) = {
		M74MCH.C
		M74ADR.C
		M74PST.C
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

#define	S_A	1
#define	S_X	2
#define	S_Y	3

/*
 * Machine Extensions
 */
#define	S_SDP		30
#define	S_M740		31

/*
 * Addressing types
 */
#define	S_IMMED		40		/* immediate operand		*/
#define	S_ACC		41		/* accumulator			*/
#define	S_ZP		42		/* zero page			*/
#define	S_ZPX		43		/* zero page, X			*/
#define	S_ZPY		44		/* zero page, Y			*/
#define	S_ABS		45		/* extended (16bit) addr	*/
#define	S_ABSX		46		/* extended (16bit) addr, X	*/
#define	S_ABSY		47		/* extended (16bit) addr, Y	*/
#define	S_ZIND		48		/* indirect: [$xx]		*/
#define	S_IND		49		/* indirect: [$xxxx]		*/
#define	S_INDX		50		/* indirect: [$xxxx, X]		*/
#define	S_INDY		51		/* indirect: [$xxxx], Y		*/
#define	S_NBIT		52		/* bit #			*/
#define	S_NBITA		53		/* bit #, A			*/
#define	S_SPEC		54		/* special page (H'FFxx, \xx)	*/

/*
 * 740 Instructions
 */
#define	S_INH		60
#define	S_BRA		61
#define	S_JSR		62
#define	S_JMP		63
#define	S_DOP		64
#define	S_SOP		65
#define	S_BIT		66
#define	S_CP		67
#define	S_LDX		68
#define	S_STX		69
#define	S_LDY		70
#define	S_STY		71
#define	S_BB		72
#define	S_ZERO		73
#define	S_ZEROX		74
#define	S_LDM		75
#define	S_BITE		76

/*
 * Extended Addressing Modes
 */
#define	R_3BIT	0x0100		/* 3-Bit Addressing Mode */

/*
 * machine dependent functions
 */

#ifdef	OTHERSYSTEM

	/* m74adr.c */
extern	struct	adsym	axy[];
extern	int		addr(struct expr *esp);
extern	int		admode(struct adsym *sp);
extern	int		any(int c, char *str);
extern	int		srch(char *str);
extern	int		zpage(struct expr *esp);

	/* m74mch.c */
extern	VOID		machine(struct mne *mp);
extern	int		mchpcr(struct expr *esp);
extern	VOID		minit(void);
extern	VOID		genbad(struct expr *esp);

#else

	/* m74adr.c */
extern	struct	adsym	axy[];
extern	int		addr();
extern	int		admode();
extern	int		any();
extern	int		srch();
extern	int		zpage();

	/* m74mch.c */
extern	VOID		machine();
extern	int		mchpcr();
extern	VOID		minit();
extern	VOID		genbad();

#endif

