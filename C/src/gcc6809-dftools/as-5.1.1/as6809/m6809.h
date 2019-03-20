/* m6809.h */

/*
 *  Copyright (C) 1989-2014  Alan R. Baldwin
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
	$(PROGRAM) =	AS6809
	$(INCLUDE) = {
		ASXXXX.H
		M6809.H
	}
	$(FILES) = {
		M09MCH.C
		M09ADR.C
		M09PST.C
		ASMAIN.C
		ASMCRO.C
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
 * Addressing types
 */
#define	S_EXT	30
#define	S_IMMED	31
#define	S_IMB	32
#define	S_IMW	33
#define	S_IMER	34
#define	S_DIR	35
#define	S_IND	36
#define	S_OFST	37
#define	S_PC	38
#define	S_PCR	39

/*
 * 6809 Instruction types
 */
#define	S_BRA	40
#define	S_LBRA	41
#define	S_LBSR	42
#define	S_SOP	43
#define	S_ACC	44
#define	S_STR1	45
#define	S_STR	46
#define	S_LR2	47
#define	S_LR1	48
#define	S_LR	49
#define	S_LEA	50
#define	S_PULS	51
#define	S_PULU	52
#define	S_EXG	53
#define	S_CC	54
#define	S_INH2	55
#define	S_INH1	56
#define	S_INH	57

/*
 * Other Information
 */
#define	S_FLAG	60

/*
 * 6800 Instruction types
 */
#if	!M6809STRICT
#define	S_6800	70
#endif

/*
 * Set Direct Pointer
 */
#define	S_SDP	80


extern	int	aindx;

struct	sdp
{
	a_uint	s_addr;
	struct	area *	s_area;
};

struct adsym
{
	char	a_str[4];	/* addressing string */
	int	a_val;		/* addressing mode value */
};

extern struct adsym abd[];
extern struct adsym xyus[];
extern struct adsym auto1[];
extern struct adsym auto2[];
extern struct adsym pc[];
extern struct adsym pcr[];
extern struct adsym regs[];
extern struct adsym stks[];
extern struct adsym stku[];

struct opdata
{
	char	opcode[4];	/* byte data */
};

#if	!M6809STRICT
extern struct opdata mc6800[];
#endif


	/* machine dependent functions */

#ifdef	OTHERSYSTEM
	
	/* m09adr.c */
extern	int		addr(struct expr *esp);
extern	int		addr1(struct expr *esp);
extern	int		admode(struct adsym *sp);
extern	int		any(int c, char *str);
extern	int		srch(char *str);

	/* m09mch.c */
extern	VOID		machine(struct mne *mp);
extern	VOID		genout(int cpg, int op, int rf, struct expr *esp);
extern	VOID		m68out(int i);
extern	int		mchpcr(struct expr *esp);
extern	VOID		minit(void);
extern	int		setbit(int b);
extern	int		getbit(void);
extern	struct	sdp	sdp;

#else

	/* m09adr.c */
extern	int		addr();
extern	int		addr1();
extern	int		admode();
extern	int		any();
extern	int		srch();

	/* m09mch.c */
extern	VOID		machine();
extern	VOID		genout();
extern	VOID		m68out();
extern	int		mchpcr();
extern	VOID		minit();
extern	int		setbit();
extern	int		getbit();
extern	struct	sdp	sdp;

#endif

