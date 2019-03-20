/* pic.h */

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

/*
 * PIC18Fxxx Extended Instructions
 * added by Mengjin Su.
 * msu at micron dot com
 */

/*)BUILD
	$(PROGRAM) =	ASP1C
	$(INCLUDE) = {
		ASXXXX.H
		PIC.H
	}
	$(FILES) = {
		PICMCH.C
		PICPST.C
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
 *Register Addressing
 */
#define S_FREG	30		/* F */
#define S_WREG	31		/* W */

/*
 * Addressing Modes
 */
#define	S_IMMED	40		/* Immediate Value */
#define	S_DIR	41		/* Direct Page */
#define	S_EXT	42		/* Extended Addressing */

/*
 * Symbol types.
 */
#define	S_INH	50		/* Inherent Instructions */
#define	S_FW	51		/* Register File and W Register Instructions */
#define	S_F	52		/* Register File Instructions*/
#define	S_FBIT	53		/* Bit and Register File Instructions */
#define	S_LIT	54		/* Instructions with literal arguments */
#define	S_CLRF	55		/* CLRF instruction */
#define	S_CLRW	56		/* CLRW instruction */
#define	S_CALL	57		/* Call Instruction */
#define	S_GOTO	58		/* Goto Instruction */
#define	S_TRIS	59		/* Tris Instruction */
#define	S_MOVLB	60		/* MOVLB Instruction */
#define	S_MOVLR	61		/* MOVLR Instruction */
#define	S_MOVFP	62		/* MOVFP Instruction */
#define	S_MOVPF	63		/* MOVPF Instruction */
#define	S_MOVFF	70		/* MOVFF Instruction */
#define	S_TF	64		/* TL__ Instructions */
#define	S_TIF	65		/* TABL__ Instructions */
#define	S_LCALL	66		/* LCALL Instruction */
#define	S_CBRA	67		/* Conditional Branches */
#define	S_BRA	68		/* BRA / RCALL Instructions */
#define	S_RET	69		/* RETURN/RETFIE Instructions */
#define	S_TBL	71		/* TBLRD/TBLWT Instructions */
#define	S_DAW	72		/* DAW Instruction */
#define	S_LFSR	73		/* LFSR Instruction */
#define	S_SETF	74		/* SETF Instruction */

/*
 * PIC18Fxxxx Extended Instructions
 */
#define	S_ADDFSR	75	/* ADDFSR and SUBFSR Instructions */
#define S_ADDULNK	76	/* ADDULNK and SUBULNK Instructions */
#define	S_CALLW		77	/* CALLW Instruction */
#define	S_MOVSF		78	/* MOVSF Instruction */
#define	S_MOVSS		79	/* MOVSS Instruction */

/*
 * Set Direct Memory Map
 */
#define	S_SDMM	85

/*
 * Machine Specific
 */
#define	X_PTYPE		90	/* Processor Type */
#define	X_PBITS		91	/* Addressing Bits */
#define	X_PFIX		92	/* Processor Fix */
#define	X_PMAXR		93	/* .maxram */
#define	X_PBADR 	94	/* .badram */
#define	X_PGOTO		95	/* PIC / ASxxxx Mode CALL, GOTO, Branches */

/*
 *	The badram structure is used to specify
 *	the non-existant ram address ranges.
 */
struct badram
{
	struct badram	*b_badram;	/* link to next structure */
	a_uint		b_lo;		/* lower limit */
	a_uint		b_hi;		/* upper limit */
};


struct adsym
{
	char	a_str[2];	/* addressing string */
	int	a_val;		/* addressing mode value */
};

/*
 * Extended Addressing Modes
 */
#define	R_4BTB	0x0100		/* 4-Bit Addressing Mode */
#define	R_4BTR	0x0200		/* 4-Bit Addressing Mode */
#define	R_5BIT	0x0300		/* 5-Bit Addressing Mode */
#define	R_6BIT	0x0400		/* 6-Bit Addressing Mode */
#define	R_7BIT	0x0500		/* 7-Bit Addressing Mode */
#define	R_8BIT	0x0600		/* 8-Bit Addressing Mode */
#define	R_9BIT	0x0700		/* 9-Bit Addressing Mode */
#define	R_11BIT	0x0800		/* 11-Bit Addressing Mode */
#define	R_12BIT	0x0900		/* 12-Bit Addressing Mode */
#define	R_13BIT	0x0A00		/* 13-Bit Addressing Mode */
#define	R_20BIT	0x0B00		/* 20-Bit Addressing Mode */
#define	R_CBRA	0x0C00		/* CBRA  8-Bit Addressing Mode */
#define	R_BRA	0x0D00		/* BRA 	11-Bit Addressing Mode */
#define	R_LFSR	0x0E00		/* LFSR 12-Bit Addressing Mode */
#define	R_CALL	0x0F00		/* CALL 20-Bit Addressing Mode */

	/* machine dependent functions */

#define	PIC_CPU	"Microchip Technology Inc."

/*
 * CPU Opcode Definition Array
 */
struct CpuDef
{
   char *id;
   a_uint opcode[5];
};

#define	X_NOPIC		0
#define	X_12BIT		1
#define	X_14BIT		2
#define	X_16BIT		3
#define	X_20BIT		4

/*
 * CPU Fix Definition Array
 */
struct CpuFix
{
   char *picid;
   char *picmne;
   a_uint opcode;
};

	/* picpst.c */
extern struct CpuDef picDef[];
extern struct CpuFix picFix[];

#ifdef	OTHERSYSTEM

	/* picmch.c */
extern	VOID		machine(struct mne *mp);
extern	VOID		mch12fsr(struct expr *esp);
extern	VOID		mch14fsr(struct expr *esp);
extern	VOID		mch16fsr(struct expr *esp);
extern	VOID		mchdpm(struct expr *esp);
extern	int		mchpcr(struct expr *esp);
extern	int		mchramchk(struct expr *esp);
extern	VOID		minit(void);
extern	VOID		pic12bit(struct mne *mp);
extern	VOID		pic14bit(struct mne *mp);
extern	VOID		pic16bit(struct mne *mp);
extern	VOID		pic20bit(struct mne *mp);

	/* picadr.c */
extern	struct	adsym	regfw[];
extern	int		addr(struct expr *esp);
extern	int		admode(struct adsym *sp);
extern	int		any(int c, char *str);
extern	int		srch(char *str);

#else

	/* picmch.c */
extern	VOID		machine();
extern	VOID		mch12fsr();
extern	VOID		mch14fsr();
extern	VOID		mch16fsr();
extern	VOID		mchdpm();
extern	int		mchpcr();
extern	int		mchramchk();
extern	VOID		minit();
extern	VOID		pic12bit();
extern	VOID		pic14bit();
extern	VOID		pic16bit();
extern	VOID		pic20bit();

	/* picadr.c */
extern	struct	adsym	regfw[];
extern	int		addr();
extern	int		admode();
extern	int		any();
extern	int		srch();

#endif

