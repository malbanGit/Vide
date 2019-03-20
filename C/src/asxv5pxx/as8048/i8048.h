/* i8048.h */

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
	$(PROGRAM) =	AS8048
	$(INCLUDE) = {
		ASXXXX.H
		I8048.H
	}
	$(FILES) = {
		I48MCH.C
		I48ADR.C
		I48PST.C
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
#define	S_ARL1	50		/* Arithmetic / Logical */
#define	S_ARL2	51		/* Arithmetic / Logical */
#define	S_ARL3	52		/* Arithmetic / Logical */
#define S_XCH	53		/* XCH */
#define S_XCHD  54		/* XCHD */
#define S_INC	55		/* INC */
#define S_DEC	56		/* DEC */
#define S_CLR	57		/* CLR / CPL */
#define	S_ACC	58		/* Accumulator */
#define S_MOV	59		/* MOV */
#define S_MOVD	60		/* MOVD */
#define S_MOVP	61		/* MOVP */
#define S_MOVP3	62		/* MOVP3 */
#define S_MOVX	63		/* MOVX */
#define	S_JMP11	64		/* JMP and CALL 11 bit. */
#define	S_JMPP	65		/* JMPP */
#define	S_BITBR	66		/* bit branch */
#define	S_BR	67		/* branch */
#define	S_DJNZ	68		/* DJNZ */
#define	S_INH	69		/* One byte inherent */
#define S_DIS	70		/* DIS / EN */
#define S_IN	71		/* IN */
#define S_INS	72		/* INS */
#define S_OUT	73		/* OUT */
#define S_OUTL	74		/* OUTL */
#define S_ENT0  75		/* ENT0 */
#define S_STRT	76		/* STRT */
#define S_STOP	77		/* STOP */
#define S_SEL	78		/* SEL */

#define	S_CPU	80		/* CPU Type */

/* Addressing modes */
#define S_A	30		/* A */
#define S_R	31		/* R0-R7 */
#define S_IA	32		/* @A */
#define	S_IR	33		/* @R0-@R1 */
#define	S_PORT	34		/* BUS, P1-P2, P4-P7 */
#define S_SLCT	35		/* AN0,AN1,MB0,MB1,RB0,RB1 */
#define	S_IMMED	36		/* immediate */
#define S_DIR   37		/* direct */
#define S_EXT	38		/* extended */

/* Miscellaneous */
#define S_C	39		/* C */
#define S_CLK	40		/* CLK */
#define S_CNT	41		/* CNT */
#define S_DBB	42		/* DBB */
#define S_F0	43		/* F0 */
#define S_F1	44		/* F1 */
#define S_I	45		/* I */
#define	S_PSW	46		/* PSW */
#define S_T	47		/* T */
#define S_TCNT	48		/* TCNT */
#define S_TCNTI	49		/* TCNTI */

/*
 * Processor Types (S_CPU)
 */
#define	X_8048		0x01
#define	X_8041		0x02
#define	X_8022		0x04
#define	X_8021		0x08


struct adsym
{
	char	a_str[6];	/* addressing string */
	int	a_val;		/* addressing mode value */
};

/* pre-defined symbol structure: name and value */
struct PreDef
{
   char *id;		/* ARB */
   int  value;
};
extern struct PreDef preDef[];

/*
 * Extended Addressing Modes
 */
#define	R_J8	0x0100		/*  8-Bit Addressing Mode */
#define	R_J11	0x0200		/* 11-Bit Addressing Mode */


	/* machine dependent functions */

#ifdef	OTHERSYSTEM
	
	/* i48adr.c */
extern	struct adsym	acc[];
extern	struct adsym	indacc[];
extern	struct adsym	reg[];
extern	struct adsym	indreg[];
extern	struct adsym	port[];
extern	struct adsym	slct[];
extern	struct adsym	misc[];
extern	int		addr(struct expr *esp);
extern	int		admode(struct adsym *sp);
extern	int		any(int c, char *str);
extern	int		srch(char *str);

	/* i48mch.c */
extern	VOID		machine(struct mne *mp);
extern	VOID		mchrel(struct expr *esp);
extern	VOID		minit(void);

#else

	/* i48adr.c */
extern	struct adsym	acc[];
extern	struct adsym	indacc[];
extern	struct adsym	reg[];
extern	struct adsym	indreg[];
extern	struct adsym	port[];
extern	struct adsym	slct[];
extern	struct adsym	misc[];
extern	int		addr();
extern	int		admode();
extern	int		any();
extern	int		srch();

	/* i48mch.c */
extern	VOID		machine();
extern	VOID		mchrel();
extern	VOID		minit();

#endif


