/* h8.h */

/*
 *  Copyright (C) 1994-2009  Alan R. Baldwin
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
	$(PROGRAM) =	ASH8
	$(INCLUDE) = {
		ASXXXX.H
		H8.H
	}
	$(FILES) = {
		H8MCH.C
		H8ADR.C
		H8PST.C
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
 * Addressing types
 */
#define	S_BREG		30
#define	S_WREG		31
#define	S_CREG		32
#define	S_IMMB		33
#define	S_IMMW		34
#define	S_INDR		35
#define	S_INDI		36
#define	S_INDD		37
#define	S_INDO		38
#define	S_INDM		39
#define	S_EXT		40
#define S_DIR		41

/*
 * Direct Page (last 256 bytes)
 */
#define	S_SDP		49

/*
 * H8 Instruction types
 */
#define	S_OP		50
#define	S_OPS		51
#define	S_OPX		52
#define	S_ADD		53
#define	S_CMP		54
#define	S_MOV		55
#define	S_SUB		56
#define	S_SOP		57
#define	S_CCR		58
#define	S_INH		59
#define	S_MLDV		60
#define	S_ROSH		61
#define	S_PP		62
#define	S_MVFPE		63
#define	S_MVTPE		64
#define	S_EEPMOV	65
#define	S_JXX		66
#define	S_BIT1		67
#define	S_BIT2		68
#define	S_BRA		69

/*
 * Variables
 */
extern int aindx;

extern char *dpcode[];

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

extern struct adsym bytereg[];
extern struct adsym wordreg[];
extern struct adsym autoinc[];
extern struct adsym autodec[];
extern struct adsym ccr_reg[];


	/* machine dependent functions */

#ifdef	OTHERSYSTEM
	
	/* h8adr.c */
extern	int		addr(struct expr *esp);
extern	int		addr1(struct expr *esp);
extern	int		admode(struct adsym *sp);
extern	int		any(int c, char *str);
extern	int		srch(char *str);

	/* h8mch.c */
extern	VOID		machine(struct mne *mp);
extern	VOID		normbyte(struct expr *esp);
extern	VOID		usgnbyte(struct expr *esp);
extern	VOID		pagebyte(struct expr *esp);
extern	int		abstype(struct expr *esp);
extern	int		mchpcr(struct expr *esp);
extern	VOID		minit(void);
extern	int		setbit(int b);
extern	int		getbit(void);

#else

	/* h8adr.c */
extern	int		addr();
extern	int		addr1();
extern	int		admode();
extern	int		any();
extern	int		srch();

	/* h8mch.c */
extern	VOID		machine();
extern	VOID		normbyte();
extern	VOID		usgnbyte();
extern	VOID		pagebyte();
extern	int		abstype();
extern	int		mchpcr();
extern	VOID		minit();
extern	int		setbit();
extern	int		getbit();

#endif

