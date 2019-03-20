/* m6812.h */

/*
 *  Copyright (C) 1989-2009  Alan R. Baldwin
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
	$(PROGRAM) =	AS6812
	$(INCLUDE) = {
		ASXXXX.H
		M6812.H
	}
	$(FILES) = {
		M12MCH.C
		M12ADR.C
		M12PST.C
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
 * Pages
 */
#define	PAGE1		0x00
#define	PAGE2		0x18

/*
 * Addressing Mode Flag
 */
#define	ADMODE_FLAG	0x8000

/*
 * Addressing types
 */
#define	S_IMMED		30
#define	S_IMB		31
#define	S_IMW		32
#define	S_DIR		33
#define	S_EXT		34
#define	S_OFST		35
#define	S_AOFST		36
#define	S_IND		37
#define	S_AIND		38
#define	S_AUTO		39

/*
 * Instruction types
 */
#define	S_6811		50
#define	S_BRA		51
#define	S_LBRA		52
#define	S_XBRA		53
#define	S_SOP		54
#define	S_DOP		55
#define	S_STR		56
#define	S_LONG		57
#define	S_JMP		58
#define	S_JSR		59
#define	S_CALL		60
#define	S_LEA		61
#define	S_EMACS		62
#define	S_EMNMX		63
#define	S_MOVB		64
#define	S_MOVW		65
#define	S_SEX		66
#define	S_TFR		67
#define	S_EXG		68
#define	S_TBL		69
#define	S_TRAP		70
#define	S_BIT		71
#define	S_BRBIT		72
#define	S_CC		73
#define	S_INH		74
#define	S_INH2		75
#define	S_PUL		76
#define	S_PSH		77

/*
 * Set Direct Pointer
 */
#define	S_SDP		80
#define	S_CPU		81

/*
 * Processor Type
 */
#define	X_HC12		0
#define X_HCS12		1


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

/*
 * Extended Addressing Modes
 */
#define	M_XBRA	0x0100		/* 9-Bit Addressing Mode */


extern struct adsym abd[];
extern struct adsym xysp[];
extern struct adsym abdxys[];
extern struct adsym prepost[];
extern struct adsym dstreg[];
extern struct adsym srcreg[];
extern struct adsym pushstk[];
extern struct adsym pullstk[];

struct opdata
{
	char	opcode[4];	/* byte data */
};

extern struct opdata mc6811[];


	/* machine dependent functions */

#ifdef	OTHERSYSTEM
	
	/* m12adr.c */
extern	int		addr(struct expr *esp);
extern	int		addr1(struct expr *esp);
extern	int		admode(struct adsym *sp);
extern	int		any(int c, char *str);
extern	int		srch(char *str);

	/* m12mch.c */
extern	VOID		machine(struct mne *mp);
extern	VOID		genout(int cpg, int op, int rf, struct expr *esp);
extern	VOID		movout(struct expr *esp, int indx, int offset);
extern	VOID		m68out(int i);
extern	int		setbit(int b);
extern	int		getbit(void);
extern	int		mchpcr(struct expr *esp);
extern	VOID		minit(void);

#else

	/* m12adr.c */
extern	int		addr();
extern	int		addr1();
extern	int		admode();
extern	int		any();
extern	int		srch();

	/* m12mch.c */
extern	VOID		machine();
extern	VOID		genout();
extern	VOID		movout();
extern	VOID		m68out();
extern	int		setbit();
extern	int		getbit();
extern	int		mchpcr();
extern	VOID		minit();

#endif

