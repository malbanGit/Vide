/* 1802.h */

/*
 *  Copyright (C) 2002-2009  Alan R. Baldwin
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
 * Shujen Chen
 * 605 Balmoral Circle
 * Naperville, IL 60540
 */

/*)BUILD
	$(PROGRAM) =	AS1802
	$(INCLUDE) = {
		ASXXXX.H
		1802.H
	}
	$(FILES) = {
		1802MCH.C
		1802PST.C
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
 * Symbol types.
 */
#define	S_INH	50		/* inherent */
#define	S_BR	51		/* short branch */
#define	S_IMM	52		/* One byte immediate */
#define	S_NIB	53		/* One nibble for register */
#define	S_LBR	54		/* long branch */
#define	S_INP	55		/* input */
#define	S_OUT	56		/* output */
#define	S_REG	57		/* registers */

/*
 * Other
 */
#define	S_FLAG	70

/*
 * Registers.
 */
#define	R0	0
#define	R1	1
#define	R2	2
#define	R3	3
#define	R4	4
#define	R5	5
#define	R6	6
#define	R7	7
#define	R8	8
#define	R9	9
#define	R10	10
#define	R11	11
#define	R12	12
#define	R13	13
#define	R14	14
#define	R15	15

/*
 * Extended Addressing Modes
 */
#define	R_BR	0x0100		/* 8-Bit Addressing Mode */
#define	R_IO	0x0200		/* 3-Bit Addressing Mode */


	/* machine dependent functions */

#ifdef	OTHERSYSTEM
	
	/* 1802mch.c */
extern	VOID		machine(struct mne *mp);
extern	int		mchbr(struct expr *esp);
extern	VOID		minit(void);
extern	int		reg(void);

#else

	/* 1802mch.c */
extern	VOID		machine();
extern	int		mchbr();
extern	VOID		minit();
extern	int		reg();

#endif

