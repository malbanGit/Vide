/* rab.h */

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
 * 
 * ported to the Rabbit2000 by
 * Ulrich Raich and Razaq Ijoduola
 * PS Division
 * CERN
 * CH-1211 Geneva-23
 * email: Ulrich dot Raich at cern dot ch
 */

/*)BUILD
	$(PROGRAM) =	ASRAB
	$(INCLUDE) = {
		ASXXXX.H
		RAB.H
	}
	$(FILES) = {
		RABMCH.C
		RABADR.C
		RABPST.C
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
#define	LFIND		'('
#define RTIND		')'

/*
 * Registers
 */
#define B		0
#define C		1
#define D		2
#define E		3
#define H		4
#define L		5
#define A		7

#define BC		0
#define DE		1
#define HL		2
#define SP		3
#define AF		4
#define IX		5
#define IY		6

#define I		0x47
#define R		0x4f

#define IIR		0x47
#define EIR		0x4f
#define XPC		0x67

#define IP		4

/*
 * Conditional definitions
 */
#define	NZ		0
#define	Z		1
#define	NC		2
#define	CS		3
#define	PO		4
#define	PE		5
#define	P		6
#define	M		7

/*
 * Symbol types
 */
#define	S_IMMED		30
#define	S_R8		31
#define	S_R8X		32
#define	S_R16AF		33
#define	S_R16		34
#define S_R16ALT	35
#define	S_CND		36
#define	S_FLAG		37

/*
 * Indexing modes
 */
#define	S_INDB		40
#define	S_IDC		41
#define	S_INDR		50
#define	S_IDBC		50
#define	S_IDDE		51
#define	S_IDHL		52
#define	S_IDSP		53
#define	S_IDIX		55
#define	S_IDIY		56
#define	S_INDM		57

/*
 * Instruction types
 */
#define	S_LD		60
#define	S_CALL		61
#define	S_JP		62
#define	S_JR		63
#define	S_RET		64
#define	S_BIT		65
#define	S_INC		66
#define	S_DEC		67
#define	S_ADD		68
#define	S_ADC		69
#define	S_AND		70
#define	S_EX		71
#define	S_PUSH		72
#define	S_IN		73
#define	S_OUT		74
#define	S_RL		75
#define	S_RST		76
#define	S_IM		77
#define	S_INH1		78
#define	S_INH1R		79
#define	S_INH1X		80
#define	S_INH2		81
#define	S_INH2R		82
#define	S_INH2X		83
#define	S_DJNZ		84
#define	S_SUB		85
#define	S_SBC		86
#define S_OR    	87
#define	S_CPU		88

/*
 * Processor Types (S_CPU)
 */
#define	X_R2K		0
#define	X_HD64		1
#define	X_Z80		2


/*
 * HD64180 Instructions
 */
#define	HD_INH2		90
#define	HD_IN		91
#define	HD_OUT		92
#define	HD_MLT		93
#define	HD_TST		94
#define	HD_TSTIO	95

/*
 * Rabbit 2000 specific instructions
 */
#define RB_PRE		100	/* prefixes */
#define RB_BOOL		101
#define RB_IPSET	102
#define RB_LDP		103
#define RB_LCALL	104

#define P_ALTD		0x01
#define P_IO		0x02


struct adsym
{
	char	a_str[4];	/* addressing string */
	int	a_val;		/* addressing mode value */
};

struct preByteType
{
        int     altd;
        int     ioi;
        int     ioe;
};

/*
 * Merge Modes
 */

#define	M_S7BIT		0x0100	/* (HL+d) / (IX+d) / (IY+d) */


extern	struct	adsym	R8[];
extern	struct	adsym	R8X[];
extern	struct	adsym	R8XR2K[];
extern	struct	adsym	R2KIP[];
extern	struct	adsym	R16AF[];
extern	struct	adsym	R16[];
extern	struct	adsym	R16ALT[];
extern	struct	adsym	CND[];

extern	int		mchtyp;

	/* machine dependent functions */

#ifdef	OTHERSYSTEM
	
        /* rabadr.c */
extern	int		addr(struct expr *esp);
extern	int		admode(struct adsym *sp);
extern	int		any(int c, char *str);
extern	int		srch(char *str);

	/* rabmch.c */
extern	int		genop(int pop, int op, struct expr *esp, int f);
extern	int		gixiy(int v);
extern	VOID		machine(struct mne *mp);
extern	int		mchpcr(struct expr *esp);
extern	VOID		minit(void);
extern  VOID            clrPreByte(void);
extern  VOID            chkPreByte(struct mne *mp);
extern  VOID            chkIOPreByte(int addrMode);
#else

	/* rabadr.c */
extern	int		addr();
extern	int		admode();
extern	int		any();
extern	int		srch();

	/* rabmch.c */
extern	int		genop();
extern	int		gixiy();
extern	VOID		machine();
extern	int		mchpcr();
extern	VOID		minit();
extern  VOID            clrPreByte();
extern  VOID            chkPreByte();
extern  VOID            chkIOPreByte();

#endif

