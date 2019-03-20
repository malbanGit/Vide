/* m8c.h */

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
	$(PROGRAM) =	ASM8C
	$(INCLUDE) = {
		ASXXXX.H
		M8C.H
	}
	$(FILES) = {
		M8CMCH.C
		M8CADR.C
		M8CPST.C
		ASMAIN.C
		ASMCRO.C
		ASDBG.C
		ASLEX.C
		ASSYM.C
		ASSUBR.C
		ASEXPR.C
		ASDATA.C
		ASLIST.C
		ASDBG.C
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
 * Registers
 */
#define	S_A		30
#define	S_F		31
#define	S_X		32
#define	S_SP		33
#define	S_REG		34

/*
 * Addressing types
 */
#define	S_IMM		40
#define	S_EXT		41
#define	S_INDX		42
#define	S_REXT		43
#define	S_RINDX		44
#define	S_EXTIAU	45

/*
 * Instruction types
 */
#define	S_MATH		60
#define	S_CMP		61
#define	S_LGC		62
#define	S_SHFT		63
#define	S_CPL		64
#define	S_CNT		65
#define	S_TST		66
#define	S_SWAP		67
#define	S_MVI		68
#define	S_MOV		69
#define	S_PUSH		70
#define	S_INH		71
#define	S_JMP		72
#define	S_BRA		73

/*
 * Merge Modes
 */

#define	M_BRA		0x0100		/* S_BRA */


	/* machine dependent functions */

#ifdef	OTHERSYSTEM

	/* 8mcadr.c */
extern	struct	adsym	regs[];
extern	int		addr(struct expr *esp);
extern	int		addr1(struct expr *esp);
extern	int		admode(struct adsym *sp);
extern	int		any(int c, char *str);
extern	int		srch(char *str);

	/* 8mcmch.c */
extern	VOID		machine(struct mne *mp);
extern	int		mchpcr(struct expr *esp);
extern	VOID		minit(void);

#else

	/* 8mcadr.c */
extern	struct	adsym	regs[];
extern	int		addr();
extern	int		addr1();
extern	int		admode();
extern	int		any();
extern	int		srch();

	/* 8mcmch.c */
extern	VOID		machine();
extern	int		mchpcr();
extern	VOID		minit();

#endif

