/* avr.h */

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
	$(PROGRAM) =	ASAVR
	$(INCLUDE) = {
		ASXXXX.H
		AVR.H
	}
	$(FILES) = {
		AVRMCH.C
		AVRADR.C
		AVRPST.C
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
#define	S_INH	50		/* One word inherent */
#define	S_IBYTE	51		/* ANDI ... */
#define	S_CBR	52		/* CBR */
#define	S_IWORD	53		/* ANDIW ... */
#define	S_SNGL	54		/* ASR ... */
#define	S_SAME	55		/* LSL ... */
#define	S_DUBL	56		/* ADC ... */
#define	S_SER	57		/* SER */
#define	S_SREG	58		/* BCLR ... */
#define	S_TFLG	59		/* BLD ... */
#define	S_BRA	60		/* BRCC ... */
#define	S_SBRA	61		/* BRBC ... */
#define S_SKIP	62		/* SBRC ... */
#define S_JMP	63		/* CALL ... */
#define S_RJMP	64		/* RCALL ... */
#define S_IOR	65		/* CBI ... */
#define S_IN	66		/* IN */
#define S_OUT	67		/* OUT */
#define S_LD	68		/* LD */
#define S_ILD	69		/* LDD */
#define S_ST	70		/* ST */
#define S_IST	71		/* STD */
#define S_LDS	72		/* LDS */
#define S_STS	73		/* STS */
#define	S_MOVW	74		/* MOVW */
#define	S_MUL	75		/* MUL */
#define	S_MULS	76		/* MULS */
#define	S_FMUL	77		/* FMUL ... */
#define	S_LPM	78		/* LPM */
#define	S_ELPM	79		/* ELPM */
#define	S_4K	80		/* .4k_avr */

#define	S_CPU	90		/* Processor Type */

/*
 * Processor Types (S_CPU)
 */
#define	X_AT_USER	0
#define	X_AT90Sxxxx	1
#define	X_AT90S1200	2
#define	X_AT90S2313	3
#define	X_AT90S2323	4
#define	X_AT90S2343	5
#define	X_AT90S2333	6
#define	X_AT90S4433	7
#define	X_AT90S4414	8
#define	X_AT90S4434	9
#define	X_AT90S8515	10
#define	X_AT90C8534	11
#define	X_AT90S8535	12
#define	X_ATmega103	13
#define	X_ATmega603	14
#define	X_ATmega161	15
#define	X_ATmega163	16
#define	X_ATtiny10	17
#define	X_ATtiny11	18
#define	X_ATtiny12	19
#define	X_ATtiny15	20
#define	X_ATtiny22	21
#define	X_ATtiny28	22

/*
 * Addressing modes
 */
#define	S_REG	30		/* Register R0-R31 */
#define S_IMMED 31		/* immediate */
#define S_DIR   32		/* direct */
#define S_EXT	33		/* extended */
#define S_IND	34		/* Indexed */


/*
 * Address Symbol Structure
 */
struct adsym
{
	char	a_str[4];	/* addressing string */
	int	a_val;		/* addressing mode value */
};

/* pre-defined symbol structure: name, value, processor type */
struct PreDef
{
   char *id;		/* ARB */
   int  value;
   int	ptype;
};
extern struct PreDef preDef[];

/*
 * Merge Modes
 */

#define	M_IBYTE		0x0100		/* S_IBYTE */
#define	M_IWORD		0x0200		/* S_IWORD */
#define	M_BRA		0x0300		/* S_BRA   */
#define	M_JMP		0x0400		/* S_LJMP  */
#define	M_IOP		0x0500		/* S_IN    */ /* S_OUT */
#define	M_IOR		0x0600		/* S_IOR   */
#define	M_ILDST		0x0700		/* S_ILD   */ /* S_IST */
#define	M_RJMP		0x0800		/* S_RJMP  */

/*
 * Assembler Types
 */
#ifdef	LONGINT
#define AT90Sxxxx	((a_uint) 0x00000001l)
#define AT90S1200	((a_uint) 0x00000002l)
#define AT90S2313	((a_uint) 0x00000004l)
#define AT90S2323	((a_uint) 0x00000008l)
#define	AT90S2343	((a_uint) 0x00000010l)
#define AT90S2333	((a_uint) 0x00000020l)
#define	AT90S4433	((a_uint) 0x00000040l)
#define AT90S4414	((a_uint) 0x00000080l)
#define AT90S4434	((a_uint) 0x00000100l)
#define AT90S8515	((a_uint) 0x00000200l)
#define	AT90C8534	((a_uint) 0x00000400l)
#define	AT90S8535	((a_uint) 0x00000800l)
#define	ATmega103	((a_uint) 0x00001000l)
#define ATmega603	((a_uint) 0x00002000l)
#define	ATmega161	((a_uint) 0x00004000l)
#define	ATmega163	((a_uint) 0x00008000l)
#define	ATtiny10	((a_uint) 0x00010000l)
#define	ATtiny11	((a_uint) 0x00020000l)
#define	ATtiny12	((a_uint) 0x00040000l)
#define	ATtiny15	((a_uint) 0x00080000l)
#define	ATtiny22	((a_uint) 0x00100000l)
#define	ATtiny28	((a_uint) 0x00200000l)

#define	SFR_BITS	((a_uint) 0x80000000l)
#else
#define AT90Sxxxx	((a_uint) 0x00000001)
#define AT90S1200	((a_uint) 0x00000002)
#define AT90S2313	((a_uint) 0x00000004)
#define AT90S2323	((a_uint) 0x00000008)
#define	AT90S2343	((a_uint) 0x00000010)
#define AT90S2333	((a_uint) 0x00000020)
#define	AT90S4433	((a_uint) 0x00000040)
#define AT90S4414	((a_uint) 0x00000080)
#define AT90S4434	((a_uint) 0x00000100)
#define AT90S8515	((a_uint) 0x00000200)
#define	AT90C8534	((a_uint) 0x00000400)
#define	AT90S8535	((a_uint) 0x00000800)
#define	ATmega103	((a_uint) 0x00001000)
#define ATmega603	((a_uint) 0x00002000)
#define	ATmega161	((a_uint) 0x00004000)
#define	ATmega163	((a_uint) 0x00008000)
#define	ATtiny10	((a_uint) 0x00010000)
#define	ATtiny11	((a_uint) 0x00020000)
#define	ATtiny12	((a_uint) 0x00040000)
#define	ATtiny15	((a_uint) 0x00080000)
#define	ATtiny22	((a_uint) 0x00100000)
#define	ATtiny28	((a_uint) 0x00200000)

#define	SFR_BITS	((a_uint) 0x80000000)
#endif

	/* machine dependent functions */

#define	ATMEL_CPU	"ATMEL Corporation"

	/* machine dependent functions */

extern	int	aindx;

#ifdef	OTHERSYSTEM
	
	/* avradr.c */
extern	struct	adsym	regAVR[];
extern	struct	adsym	xyz[];
extern	int		addr(struct expr *esp);
extern	int		addr1(struct expr *esp);
extern	int		admode(struct adsym *sp);
extern	int		any(int c, char *str);
extern	int		srch(char *str);

	/* avrmch.c */
extern	VOID		machine(struct mne *mp);
extern	int		mchpcr(struct expr *esp);
extern	VOID		minit(void);

#else

	/* avradr.c */
extern	struct	adsym	regAVR[];
extern	struct	adsym	xyz[];
extern	int		addr();
extern	int		addr1();)
extern	int		admode();
extern	int		any();
extern	int		srch();

	/* avrmch.c */
extern	VOID		machine();
extern	int		mchpcr();
extern	VOID		minit();

#endif

