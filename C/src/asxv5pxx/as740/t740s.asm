	.title t740s.asm

	; Note:
	;	The external symbols are lower case and
	;	the internal symbols are upper case.
	;
	;	as740 -laff t740s


	; Constants

	BIT0	=	0
	BIT1	=	1
	BIT2	=	2
	BIT3	=	3
	BIT4	=	4
	BIT5	=	5
	BIT6	=	6
	BIT7	=	7

	; Internal Symbols

	IMM	=	0x0001
	ZP	=	0x0023
	ABS	=	0x4567
	SPECIAL	=	0x89AB

	
	; External Symbols

	.globl		imm,	zp,	abs,	special
	.globl		bit0,	bit1,	bit2,	bit3
	.globl		bit4,	bit5,	bit6,	bit7


	.sbttl	Sequential Instruction Code Test with Internals

	; Internal Variables
	;
	;	#IMM		Immediate constant
	;	*ZP		direct page variable
	;	ABS		16-bit address
	;	SPECIAL		special page (0xFF__)
	;
	; All addressing modes are explicitly specified
	;

	.area	AREA1

	brk			; 00
	ora	[*ZP,x]		; 01 23
	jsr	[*ZP]		; 02 23
	bbs	BIT0,a,.+2	; 03 00
;	illegal			; 04
	ora	*ZP		; 05 23
	asl	*ZP		; 06 23
	bbs	BIT0,*ZP,.+3	; 07 23 00
	php			; 08
	ora	#IMM		; 09 01
	asl	a		; 0A
	seb	BIT0,a		; 0B
;	illegal			; 0C
	ora	ABS		; 0D 67 45
	asl	ABS		; 0E 67 45
	seb	BIT0,*ZP	; 0F 23

	; *****-----*****

	bpl	.+2		; 10 00
	ora	[*ZP],y		; 11 23
	clt			; 12
	bbc	BIT0,a,.+2	; 13 00
;	illegal			; 14
	ora	*ZP,x		; 15 23
	asl	*ZP,x		; 16 23
	bbc	BIT0,*ZP,.+3	; 17 23 00
	clc			; 18
	ora	ABS,y		; 19 67 45
	dec	a		; 1A
	clb	BIT0,a		; 1B
;	illegal			; 1C
	ora	ABS,x		; 1D 67 45
	asl	ABS,x		; 1E 67 45
	clb	BIT0,*ZP	; 1F 23

	; *****-----*****

	jsr	ABS		; 20 67 45
	and	[*ZP,x]		; 21 23
	jsr	\SPECIAL	; 22 AB
	bbs	BIT1,a,.+2	; 23 00
	bit	*ZP		; 24 23
	and	*ZP		; 25 23
	rol	*ZP		; 26 23
	bbs	BIT1,*ZP,.+3	; 27 23 00
	plp			; 28
	and	#IMM		; 29 01
	rol	a		; 2A
	seb	BIT1,a		; 2B
	bit	ABS		; 2C 67 45
	and	ABS		; 2D 67 45
	rol	ABS		; 2E 67 45
	seb	BIT1,*ZP	; 2F 23

	; *****-----*****

	bmi	.+2		; 30 00
	and	[*ZP],y		; 31 23
	set			; 32
	bbc	BIT1,a,.+2	; 33 00
;	illegal			; 34
	and	*ZP,x		; 35 23
	rol	*ZP,x		; 36 23
	bbc	BIT1,*ZP,.+3	; 37 23 00
	sec			; 38
	and	ABS,y		; 39 67 45
	inc	a		; 3A
	clb	BIT1,a		; 3B
	ldm	#IMM,*ZP	; 3C 01 23
	and	ABS,x		; 3D 67 45
	rol	ABS,x		; 3E 67 45
	clb	BIT1,*ZP	; 3F 23

	; *****-----*****

	rti			; 40
	eor	[*ZP,x]		; 41 23
	stp			; 42
	bbs	BIT2,a,.+2	; 43 00
	com	*ZP		; 44 23
	eor	*ZP		; 45 23
	lsr	*ZP		; 46 23
	bbs	BIT2,*ZP,.+3	; 47 23 00
	pha			; 48
	eor	#IMM		; 49 01
	lsr	a		; 4A
	seb	BIT2,a		; 4B
	jmp	ABS		; 4C 67 45
	eor	ABS		; 4D 67 45
	lsr	ABS		; 4E 67 45
	seb	BIT2,*ZP	; 4F 23

	; *****-----*****

	bvc	.+2		; 50 00
	eor	[*ZP],y		; 51 23
;	illegal			; 52
	bbc	BIT2,a,.+2	; 53 00
;	illegal			; 54
	eor	*ZP,x		; 55 23
	lsr	*ZP,x		; 56 23
	bbc	BIT2,*ZP,.+3	; 57 23 00
	cli			; 58
	eor	ABS,y		; 59 67 45
;	illegal			; 5A
	clb	BIT2,a		; 5B
;	illegal			; 5C
	eor	ABS,x		; 5D 67 45
	lsr	ABS,x		; 5E 67 45
	clb	BIT2,*ZP	; 5F 23

	; *****-----*****

	rts			; 60
	adc	[*ZP,x]		; 61 23
	mul	*ZP,x		; 62 23
	bbs	BIT3,a,.+2	; 63 00
	tst	*ZP		; 64 23
	adc	*ZP		; 65 23
	ror	*ZP		; 66 23
	bbs	BIT3,*ZP,.+3	; 67 23 00
	pla			; 68
	adc	#IMM		; 69 01
	ror	a		; 6A
	seb	BIT3,a		; 6B
	jmp	[ABS]		; 6C 67 45
	adc	ABS		; 6D 67 45
	ror	ABS		; 6E 67 45
	seb	BIT3,*ZP	; 6F 23

	; *****-----*****

	bvs	.+2		; 70 00
	adc	[*ZP],y		; 71 23
;	illegal			; 72
	bbc	BIT3,a,.+2	; 73 00
;	illegal			; 74
	adc	*ZP,x		; 75 23
	ror	*ZP,x		; 76 23
	bbc	BIT3,*ZP,.+3	; 77 23 00
	sei			; 78
	adc	ABS,y		; 79 67 45
;	illegal			; 7A
	clb	BIT3,a		; 7B
;	illegal			; 7C
	adc	ABS,x		; 7D 67 45
	ror	ABS,x		; 7E 67 45
	clb	BIT3,*ZP	; 7F 23

	; *****-----*****

	bra	.+2		; 80 00
	sta	[*ZP,x]		; 81 23
	rrf	*ZP		; 82 23
	bbs	BIT4,a,.+2	; 83 00
	sty	*ZP		; 84 23
	sta	*ZP		; 85 23
	stx	*ZP		; 86 23
	bbs	BIT4,*ZP,.+3	; 87 23 00
	dey			; 88
;	illegal			; 89
	txa			; 8A
	seb	BIT4,a		; 8B
	sty	ABS		; 8C 67 45
	sta	ABS		; 8D 67 45
	stx	ABS		; 8E 67 45
	seb	BIT4,*ZP	; 8F 23

	; *****-----*****

	bcc	.+2		; 90 00
	sta	[*ZP],y		; 91 23
;	illegal			; 92
	bbc	BIT4,a,.+2	; 93 00
	sty	*ZP,x		; 94 23
	sta	*ZP,x		; 95 23
	stx	*ZP,y		; 96 23
	bbc	BIT4,*ZP,.+3	; 97 23 00
	tya			; 98
	sta	ABS,y		; 99 67 45
	txs			; 9A
	clb	BIT4,a		; 9B
;	illegal			; 9C
	sta	ABS,x		; 9D 67 45
;	illegal			; 9E
	clb	BIT4,*ZP	; 9F 23

	; *****-----*****

	ldy	#IMM		; A0 01
	lda	[*ZP,x]		; A1 23
	ldx	#IMM		; A2 01
	bbs	BIT5,a,.+2	; A3 00
	ldy	*ZP		; A4 23
	lda	*ZP		; A5 23
	ldx	*ZP		; A6 23
	bbs	BIT5,*ZP,.+3	; A7 23 00
	tay			; A8
	lda	#IMM		; A9 01
	tax			; AA
	seb	BIT5,a		; AB
	ldy	ABS		; AC 67 45
	lda	ABS		; AD 67 45
	ldx	ABS		; AE 67 45
	seb	BIT5,*ZP	; AF 23

	; *****-----*****

	bcs	.+2		; B0 00
	lda	[*ZP],y		; B1 23
	jmp	[*ZP]		; B2 23
	bbc	BIT5,a,.+2	; B3 00
	ldy	*ZP,x		; B4 23
	lda	*ZP,x		; B5 23
	ldx	*ZP,y		; B6 23
	bbc	BIT5,*ZP,.+3	; B7 23 00
	clv			; B8
	lda	ABS,y		; B9 67 45
	tsx			; BA
	clb	BIT5,a		; BB
	ldy	ABS,x		; BC 67 45
	lda	ABS,x		; BD 67 45
	ldx	ABS,y		; BE 67 45
	clb	BIT5,*ZP	; BF 23

	; *****-----*****

	cpy	#IMM		; C0 01
	cmp	[*ZP,x]		; C1 23
	wit			; C2
	bbs	BIT6,a,.+2	; C3 00
	cpy	*ZP		; C4 23
	cmp	*ZP		; C5 23
	dec	*ZP		; C6 23
	bbs	BIT6,*ZP,.+3	; C7 23 00
	iny			; C8
	cmp	#IMM		; C9 01
	dex			; CA
	seb	BIT6,a		; CB
	cpy	ABS		; CC 67 45
	cmp	ABS		; CD 67 45
	dec	ABS		; CE 67 45
	seb	BIT6,*ZP	; CF 23

	; *****-----*****

	bne	.+2		; D0 00
	cmp	[*ZP],y		; D1 23
;	illegal			; D2
	bbc	BIT6,a,.+2	; D3 00
;	illegal			; D4
	cmp	*ZP,x		; D5 23
	dec	*ZP,x		; D6 23
	bbc	BIT6,*ZP,.+3	; D7 23 00
	cld			; D8
	cmp	ABS,y		; D9 67 45
;	illegal			; DA
	clb	BIT6,a		; DB
;	illegal			; DC
	cmp	ABS,x		; DD 67 45
	dec	ABS,x		; DE 67 45
	clb	BIT6,*ZP	; DF 23

	; *****-----*****

	cpx	#IMM		; E0 01
	sbc	[*ZP,x]		; E1 23
	div	*ZP,x		; E2 23
	bbs	BIT7,a,.+2	; E3 00
	cpx	*ZP		; E4 23
	sbc	*ZP		; E5 23
	inc	*ZP		; E6 23
	bbs	BIT7,*ZP,.+3	; E7 23 00
	inx			; E8
	sbc	#IMM		; E9 01
	nop			; EA
	seb	BIT7,a		; EB
	cpx	ABS		; EC 67 45
	sbc	ABS		; ED 67 45
	inc	ABS		; EE 67 45
	seb	BIT7,*ZP	; EF 23

	; *****-----*****

	beq	.+2		; F0 00
	sbc	[*ZP],y		; F1 23
;	illegal			; F2
	bbc	BIT7,a,.+2		; F3 00
;	illegal			; F4
	sbc	*ZP,x		; F5 23
	inc	*ZP,x		; F6 23
	bbc	BIT7,*ZP,.+3	; F7 23 00
	sed			; F8
	sbc	ABS,y		; F9 67 45
;	illegal			; FA
	clb	BIT7,a		; FB
;	illegal			; FC
	sbc	ABS,x		; FD 67 45
	inc	ABS,x		; FE 67 45
	clb	BIT7,*ZP		; FF 23


	.sbttl	Sequential Instruction Code Test with Externals

	; External Variables
	;
	;	#imm		immediate constant
	;	*zp		zero page symbol
	;	abs		16-bit address
	;	special		special page (0xFF__)
	;
	; All addressing modes are explicitly specified
	;

	.area	AREA2

	brk			; 00
	ora	[*zp,x]		; 01*00
	jsr	[*zp]		; 02*00
	bbs	bit0,a,.+2	;u03 00
;	illegal			; 04
	ora	*zp		; 05*00
	asl	*zp		; 06*00
	bbs	bit0,*zp,.+3	;u07*00 00
	php			; 08
	ora	#imm		; 09r00
	asl	a		; 0A
	seb	bit0,a		;u0B
;	illegal			; 0C
	ora	abs		; 0Dr00s00
	asl	abs		; 0Er00s00
	seb	bit0,*zp	;u0F*00

	; *****-----*****

	bpl	.+2		; 10 00
	ora	[*zp],y		; 11*00
	clt			; 12
	bbc	bit0,a,.+2	;u13 00
;	illegal			; 14
	ora	*zp,x		; 15*00
	asl	*zp,x		; 16*00
	bbc	bit0,*zp,.+3	;u17*00 00
	clc			; 18
	ora	abs,y		; 19r00s00
	dec	a		; 1A
	clb	bit0,a		;u1B
;	illegal			; 1C
	ora	abs,x		; 1Dr00s00
	asl	abs,x		; 1Er00s00
	clb	bit0,*zp	;u1F*00

	; *****-----*****

	jsr	abs		; 20r00s00
	and	[*zp,x]		; 21*00
	jsr	\special	; 22r00
	bbs	bit1,a,.+2	;u03 00
	bit	*zp		; 24*00
	and	*zp		; 25*00
	rol	*zp		; 26*00
	bbs	bit1,*zp,.+3	;u07*00 00
	plp			; 28
	and	#imm		; 29r00
	rol	a		; 2A
	seb	bit1,a		;u0B
	bit	abs		; 2Cr00s00
	and	abs		; 2Dr00s00
	rol	abs		; 2Er00s00
	seb	bit1,*zp	;u0F*00

	; *****-----*****

	bmi	.+2		; 30 00
	and	[*zp],y		; 31*00
	set			; 32
	bbc	bit1,a,.+2	;u13 00
;	illegal			; 34
	and	*zp,x		; 35*00
	rol	*zp,x		; 36*00
	bbc	bit1,*zp,.+3	;u17*00 00
	sec			; 38
	and	abs,y		; 39r00s00
	inc	a		; 3A
	clb	bit1,a		;u1B
	ldm	#imm,*zp	; 3Cu00*00
	and	abs,x		; 3Dr00s00
	rol	abs,x		; 3Er00s00
	clb	bit1,*zp	;u1F*00

	; *****-----*****

	rti			; 40
	eor	[*zp,x]		; 41*00
	stp			; 42
	bbs	bit2,a,.+2	;u03 00
	com	*zp		; 44*00
	eor	*zp		; 45*00
	lsr	*zp		; 46*00
	bbs	bit2,*zp,.+3	;u07*00 00
	pha			; 48
	eor	#imm		; 49r00
	lsr	a		; 4A
	seb	bit2,a		;u0B
	jmp	abs		; 4Cr00s00
	eor	abs		; 4Dr00s00
	lsr	abs		; 4Er00s00
	seb	bit2,*zp	;u0F*00

	; *****-----*****

	bvc	.+2		; 50 00
	eor	[*zp],y		; 51*00
;	illegal			; 52
	bbc	bit2,a,.+2	;u13 00
;	illegal			; 54
	eor	*zp,x		; 55*00
	lsr	*zp,x		; 56*00
	bbc	bit2,*zp,.+3	;u17*00 00
	cli			; 58
	eor	abs,y		; 59r00s00
;	illegal			; 5A
	clb	bit2,a		;u1B
;	illegal			; 5C
	eor	abs,x		; 5Dr00s00
	lsr	abs,x		; 5Er00s00
	clb	bit2,*zp	;u1F*00

	; *****-----*****

	rts			; 60
	adc	[*zp,x]		; 61*00
	mul	*zp,x		; 62*00
	bbs	bit3,a,.+2	;u03 00
	tst	*zp		; 64*00
	adc	*zp		; 65*00
	ror	*zp		; 66*00
	bbs	bit3,*zp,.+3	;u07*00 00
	pla			; 68
	adc	#imm		; 69r00
	ror	a		; 6A
	seb	bit3,a		;u0B
	jmp	[abs]		; 6Cr00s00
	adc	abs		; 6Dr00s00
	ror	abs		; 6Er00s00
	seb	bit3,*zp	;u0F*00

	; *****-----*****

	bvs	.+2		; 70 00
	adc	[*zp],y		; 71*00
;	illegal			; 72
	bbc	bit3,a,.+2	;u13 00
;	illegal			; 74
	adc	*zp,x		; 75*00
	ror	*zp,x		; 76*00
	bbc	bit3,*zp,.+3	;u17*00 00
	sei			; 78
	adc	abs,y		; 79r00s00
;	illegal			; 7A
	clb	bit3,a		;u1B
;	illegal			; 7C
	adc	abs,x		; 7Dr00s00
	ror	abs,x		; 7Er00s00
	clb	bit3,*zp	;u1F*00

	; *****-----*****

	bra	.+2		; 80 00
	sta	[*zp,x]		; 81*00
	rrf	*zp		; 82*00
	bbs	bit4,a,.+2	;u03 00
	sty	*zp		; 84*00
	sta	*zp		; 85*00
	stx	*zp		; 86*00
	bbs	bit4,*zp,.+3	;u07*00 00
	dey			; 88
;	illegal			; 89
	txa			; 8A
	seb	bit4,a		;u0B
	sty	abs		; 8Cr00s00
	sta	abs		; 8Dr00s00
	stx	abs		; 8Er00s00
	seb	bit4,*zp	;u0F*00

	; *****-----*****

	bcc	.+2		; 90 00
	sta	[*zp],y		; 91*00
;	illegal			; 92
	bbc	bit4,a,.+2	;u13 00
	sty	*zp,x		; 94*00
	sta	*zp,x		; 95*00
	stx	*zp,y		; 96*00
	bbc	bit4,*zp,.+3	;u17*00 00
	tya			; 98
	sta	abs,y		; 99r00s00
	txs			; 9A
	clb	bit4,a		;u1B
;	illegal			; 9C
	sta	abs,x		; 9Dr00s00
;	illegal			; 9E
	clb	bit4,*zp	;u1F*00

	; *****-----*****

	ldy	#imm		; A0r00
	lda	[*zp,x]		; A1*00
	ldx	#imm		; A2r00
	bbs	bit5,a,.+2	;u03 00
	ldy	*zp		; A4*00
	lda	*zp		; A5*00
	ldx	*zp		; A6*00
	bbs	bit5,*zp,.+3	;u07*00 00
	tay			; A8
	lda	#imm		; A9r00
	tax			; AA
	seb	bit5,a		;u0B
	ldy	abs		; ACr00s00
	lda	abs		; ADr00s00
	ldx	abs		; AEr00s00
	seb	bit5,*zp	;u0F*00

	; *****-----*****

	bcs	.+2		; B0 00
	lda	[*zp],y		; B1*00
	jmp	[*zp]		; B2*00
	bbc	bit5,a,.+2	;u13 00
	ldy	*zp,x		; B4*00
	lda	*zp,x		; B5*00
	ldx	*zp,y		; B6*00
	bbc	bit5,*zp,.+3	;u17*00 00
	clv			; B8
	lda	abs,y		; B9r00s00
	tsx			; BA
	clb	bit5,a		;u1B
	ldy	abs,x		; BCr00s00
	lda	abs,x		; BDr00s00
	ldx	abs,y		; BEr00s00
	clb	bit5,*zp	;u1F*00

	; *****-----*****

	cpy	#imm		; C0r00
	cmp	[*zp,x]		; C1*00
	wit			; C2
	bbs	bit6,a,.+2	;u03 00
	cpy	*zp		; C4*00
	cmp	*zp		; C5*00
	dec	*zp		; C6*00
	bbs	bit6,*zp,.+3	;u07*00 00
	iny			; C8
	cmp	#imm		; C9r00
	dex			; CA
	seb	bit6,a		;u0B
	cpy	abs		; CCr00s00
	cmp	abs		; CDr00s00
	dec	abs		; CEr00s00
	seb	bit6,*zp	;u0F*00

	; *****-----*****

	bne	.+2		; D0 00
	cmp	[*zp],y		; D1*00
;	illegal			; D2
	bbc	bit6,a,.+2	;u13 00
;	illegal			; D4
	cmp	*zp,x		; D5*00
	dec	*zp,x		; D6*00
	bbc	bit6,*zp,.+3	;u17*00 00
	cld			; D8
	cmp	abs,y		; D9r00s00
;	illegal			; DA
	clb	bit6,a		;u1B
;	illegal			; DC
	cmp	abs,x		; DDr00s00
	dec	abs,x		; DEr00s00
	clb	bit6,*zp	;u1F*00

	; *****-----*****

	cpx	#imm		; E0r00
	sbc	[*zp,x]		; E1*00
	div	*zp,x		; E2*00
	bbs	bit7,a,.+2	;u03 00
	cpx	*zp		; E4*00
	sbc	*zp		; E5*00
	inc	*zp		; E6*00
	bbs	bit7,*zp,.+3	;u07*00 00
	inx			; E8
	sbc	#imm		; E9r00
	nop			; EA
	seb	bit7,a		;u0B
	cpx	abs		; ECr00s00
	sbc	abs		; EDr00s00
	inc	abs		; EEr00s00
	seb	bit7,*zp	;u0F*00

	; *****-----*****

	beq	.+2		; F0 00
	sbc	[*zp],y		; F1*00
;	illegal			; F2
	bbc	bit7,a,.+2	;u13 00
;	illegal			; F4
	sbc	*zp,x		; F5*00
	inc	*zp,x		; F6*00
	bbc	bit7,*zp,.+3	;u17*00 00
	sed			; F8
	sbc	abs,y		; F9r00s00
;	illegal			; FA
	clb	bit7,a		;u1B
;	illegal			; FC
	sbc	abs,x		; FDr00s00
	inc	abs,x		; FEr00s00
	clb	bit7,*zp	;u1F*00


	.sbttl	Sequential Instruction Code Test with Internals

	; Internal Variables
	;
	;	#IMM		Immediate constant
	;	*ZP		direct page variable
	;	ABS		16-bit address
	;	SPECIAL		special page (0xFF__)
	;
	; N O T E   ---- ---- ---------- ----- --- --- ---------- ---------	N O T E
	; N O T E   zero page addressing modes are not explicitly specified	N O T E
	; N O T E   ---- ---- ---------- ----- --- --- ---------- ---------	N O T E
	;
	; This verifies that if the addresses are absolute and within page zero
	; then the code is assembled the same as an explicitly specified
	; page zero addressing mode.

	.area	AREA3

	brk			; 00
	ora	[ZP,x]		; 01 23
	jsr	[ZP]		; 02 23
	bbs	0,a,.+2		; 03 00
;	illegal			; 04
	ora	ZP		; 05 23
	asl	ZP		; 06 23
	bbs	0,ZP,.+3	; 07 23 00
	php			; 08
	ora	#IMM		; 09 01
	asl	a		; 0A
	seb	0,a		; 0B
;	illegal			; 0C
	ora	ABS		; 0D 67 45
	asl	ABS		; 0E 67 45
	seb	0,ZP		; 0F 23

	; *****-----*****

	bpl	.+2		; 10 00
	ora	[ZP],y		; 11 23
	clt			; 12
	bbc	0,a,.+2		; 13 00
;	illegal			; 14
	ora	ZP,x		; 15 23
	asl	ZP,x		; 16 23
	bbc	0,ZP,.+3	; 17 23 00
	clc			; 18
	ora	ABS,y		; 19 67 45
	dec	a		; 1A
	clb	0,a		; 1B
;	illegal			; 1C
	ora	ABS,x		; 1D 67 45
	asl	ABS,x		; 1E 67 45
	clb	0,ZP		; 1F 23

	; *****-----*****

	jsr	ABS		; 20 67 45
	and	[ZP,x]		; 21 23
	jsr	\SPECIAL	; 22 AB
	bbs	1,a,.+2		; 23 00
	bit	ZP		; 24 23
	and	ZP		; 25 23
	rol	ZP		; 26 23
	bbs	1,ZP,.+3	; 27 23 00
	plp			; 28
	and	#IMM		; 29 01
	rol	a		; 2A
	seb	1,a		; 2B
	bit	ABS		; 2C 67 45
	and	ABS		; 2D 67 45
	rol	ABS		; 2E 67 45
	seb	1,ZP		; 2F 23

	; *****-----*****

	bmi	.+2		; 30 00
	and	[ZP],y		; 31 23
	set			; 32
	bbc	1,a,.+2		; 33 00
;	illegal			; 34
	and	ZP,x		; 35 23
	rol	ZP,x		; 36 23
	bbc	1,ZP,.+3	; 37 23 00
	sec			; 38
	and	ABS,y		; 39 67 45
	inc	a		; 3A
	clb	1,a		; 3B
	ldm	#IMM,ZP		; 3C 01 23
	and	ABS,x		; 3D 67 45
	rol	ABS,x		; 3E 67 45
	clb	1,ZP		; 3F 23

	; *****-----*****

	rti			; 40
	eor	[ZP,x]		; 41 23
	stp			; 42
	bbs	2,a,.+2		; 43 00
	com	ZP		; 44 23
	eor	ZP		; 45 23
	lsr	ZP		; 46 23
	bbs	2,ZP,.+3	; 47 23 00
	pha			; 48
	eor	#IMM		; 49 01
	lsr	a		; 4A
	seb	2,a		; 4B
	jmp	ABS		; 4C 67 45
	eor	ABS		; 4D 67 45
	lsr	ABS		; 4E 67 45
	seb	2,ZP		; 4F 23

	; *****-----*****

	bvc	.+2		; 50 00
	eor	[ZP],y		; 51 23
;	illegal			; 52
	bbc	2,a,.+2		; 53 00
;	illegal			; 54
	eor	ZP,x		; 55 23
	lsr	ZP,x		; 56 23
	bbc	2,ZP,.+3	; 57 23 00
	cli			; 58
	eor	ABS,y		; 59 67 45
;	illegal			; 5A
	clb	2,a		; 5B
;	illegal			; 5C
	eor	ABS,x		; 5D 67 45
	lsr	ABS,x		; 5E 67 45
	clb	2,ZP		; 5F 23

	; *****-----*****

	rts			; 60
	adc	[ZP,x]		; 61 23
	mul	ZP,x		; 62 23
	bbs	3,a,.+2		; 63 00
	tst	ZP		; 64 23
	adc	ZP		; 65 23
	ror	ZP		; 66 23
	bbs	3,ZP,.+3	; 67 23 00
	pla			; 68
	adc	#IMM		; 69 01
	ror	a		; 6A
	seb	3,a		; 6B
	jmp	[ABS]		; 6C 67 45
	adc	ABS		; 6D 67 45
	ror	ABS		; 6E 67 45
	seb	3,ZP		; 6F 23

	; *****-----*****

	bvs	.+2		; 70 00
	adc	[ZP],y		; 71 23
;	illegal			; 72
	bbc	3,a,.+2		; 73 00
;	illegal			; 74
	adc	ZP,x		; 75 23
	ror	ZP,x		; 76 23
	bbc	3,ZP,.+3	; 77 23 00
	sei			; 78
	adc	ABS,y		; 79 67 45
;	illegal			; 7A
	clb	3,a		; 7B
;	illegal			; 7C
	adc	ABS,x		; 7D 67 45
	ror	ABS,x		; 7E 67 45
	clb	3,ZP		; 7F 23

	; *****-----*****

	bra	.+2		; 80 00
	sta	[ZP,x]		; 81 23
	rrf	ZP		; 82 23
	bbs	4,a,.+2		; 83 00
	sty	ZP		; 84 23
	sta	ZP		; 85 23
	stx	ZP		; 86 23
	bbs	4,ZP,.+3	; 87 23 00
	dey			; 88
;	illegal			; 89
	txa			; 8A
	seb	4,a		; 8B
	sty	ABS		; 8C 67 45
	sta	ABS		; 8D 67 45
	stx	ABS		; 8E 67 45
	seb	4,ZP		; 8F 23

	; *****-----*****

	bcc	.+2		; 90 00
	sta	[ZP],y		; 91 23
;	illegal			; 92
	bbc	4,a,.+2		; 93 00
	sty	ZP,x		; 94 23
	sta	ZP,x		; 95 23
	stx	ZP,y		; 96 23
	bbc	4,ZP,.+3	; 97 23 00
	tya			; 98
	sta	ABS,y		; 99 67 45
	txs			; 9A
	clb	4,a		; 9B
;	illegal			; 9C
	sta	ABS,x		; 9D 67 45
;	illegal			; 9E
	clb	4,ZP		; 9F 23

	; *****-----*****

	ldy	#IMM		; A0 01
	lda	[ZP,x]		; A1 23
	ldx	#IMM		; A2 01
	bbs	5,a,.+2		; A3 00
	ldy	ZP		; A4 23
	lda	ZP		; A5 23
	ldx	ZP		; A6 23
	bbs	5,ZP,.+3	; A7 23 00
	tay			; A8
	lda	#IMM		; A9 01
	tax			; AA
	seb	5,a		; AB
	ldy	ABS		; AC 67 45
	lda	ABS		; AD 67 45
	ldx	ABS		; AE 67 45
	seb	5,ZP		; AF 23

	; *****-----*****

	bcs	.+2		; B0 00
	lda	[ZP],y		; B1 23
	jmp	[ZP]		; B2 23
	bbc	5,a,.+2		; B3 00
	ldy	ZP,x		; B4 23
	lda	ZP,x		; B5 23
	ldx	ZP,y		; B6 23
	bbc	5,ZP,.+3	; B7 23 00
	clv			; B8
	lda	ABS,y		; B9 67 45
	tsx			; BA
	clb	5,a		; BB
	ldy	ABS,x		; BC 67 45
	lda	ABS,x		; BD 67 45
	ldx	ABS,y		; BE 67 45
	clb	5,ZP		; BF 23

	; *****-----*****

	cpy	#IMM		; C0 01
	cmp	[ZP,x]		; C1 23
	wit			; C2
	bbs	6,a,.+2		; C3 00
	cpy	ZP		; C4 23
	cmp	ZP		; C5 23
	dec	ZP		; C6 23
	bbs	6,ZP,.+3	; C7 23 00
	iny			; C8
	cmp	#IMM		; C9 01
	dex			; CA
	seb	6,a		; CB
	cpy	ABS		; CC 67 45
	cmp	ABS		; CD 67 45
	dec	ABS		; CE 67 45
	seb	6,ZP		; CF 23

	; *****-----*****

	bne	.+2		; D0 00
	cmp	[ZP],y		; D1 23
;	illegal			; D2
	bbc	6,a,.+2		; D3 00
;	illegal			; D4
	cmp	ZP,x		; D5 23
	dec	ZP,x		; D6 23
	bbc	6,ZP,.+3	; D7 23 00
	cld			; D8
	cmp	ABS,y		; D9 67 45
;	illegal			; DA
	clb	6,a		; DB
;	illegal			; DC
	cmp	ABS,x		; DD 67 45
	dec	ABS,x		; DE 67 45
	clb	6,ZP		; DF 23

	; *****-----*****

	cpx	#IMM		; E0 01
	sbc	[ZP,x]		; E1 23
	div	ZP,x		; E2 23
	bbs	7,a,.+2		; E3 00
	cpx	ZP		; E4 23
	sbc	ZP		; E5 23
	inc	ZP		; E6 23
	bbs	7,ZP,.+3	; E7 23 00
	inx			; E8
	sbc	#IMM		; E9 01
	nop			; EA
	seb	7,a		; EB
	cpx	ABS		; EC 67 45
	sbc	ABS		; ED 67 45
	inc	ABS		; EE 67 45
	seb	7,ZP		; EF 23

	; *****-----*****

	beq	.+2		; F0 00
	sbc	[ZP],y		; F1 23
;	illegal			; F2
	bbc	7,a,.+2		; F3 00
;	illegal			; F4
	sbc	ZP,x		; F5 23
	inc	ZP,x		; F6 23
	bbc	7,ZP,.+3	; F7 23 00
	sed			; F8
	sbc	ABS,y		; F9 67 45
;	illegal			; FA
	clb	7,a		; FB
;	illegal			; FC
	sbc	ABS,x		; FD 67 45
	inc	ABS,x		; FE 67 45
	clb	7,ZP		; FF 23


	.sbttl	Sequential Instruction Code Test with Externals

	; External Variables
	;
	;	#imm		immediate constant
	;	*zp		zero page symbol
	;	abs		16-bit address
	;	special		special page (0xFF__)
	;
	; N O T E   ---- ---- ---------- ----- --- --- ---------- ---------	N O T E
	; N O T E   zero page addressing modes are not explicitly specified	N O T E
	; N O T E   ---- ---- ---------- ----- --- --- ---------- ---------	N O T E
	;
	; The S_BIT, S_SOP and S_DOP instructions with *zp,x and abs,x modes
	; will default to the abs,x mode for an external reference.
	; S_BIT --- (bit)
	; S_SOP --- (asl, lsr, rol, ror, dec, inc)
	; S_DOP --- (adc, and, cmp, eor, lda, ora, sbc, and sta)
	;
	; The S_JMP instructions with [*zp] and [abs] modes will
	; default to the [abs] mode for an external reference.
	; S_JMP --- (jmp)
	;
	; The S_CP, S_LDX, S_LDY, S_STX, and S_STY instructions with *zp and abs modes
	; will default to the abs mode for an external reference.
	; S_CP  --- (cpx, cpy)
	; S_LDX --- (ldx)
	; S_LDY --- (ldy)
	; S_STX --- (stx)
	; S_STY --- (sty)
	;
	; The S_LDX instruction with *zp,y and abs,y modes
	; will default to the abs,y mode for an external reference.
	; S_LDX --- (ldx)
	;
	; The S_LDY instruction with *zp,x and abs,x modes
	; will default to the abs,x mode for an external reference.
	; S_LDY --- (ldy)
	;

	.area	AREA4

	brk			; 00
	ora	[zp,x]		; 01*00
	jsr	[zp]		; 02*00
	bbs	bit0,a,.+2	;u03 00
;	illegal			; 04
	ora	zp		; 0Dr00s00
	asl	zp		; 0Er00s00
	bbs	bit0,zp,.+3	;u07*00 00
	php			; 08
	ora	#imm		; 09r00
	asl	a		; 0A
	seb	bit0,a		;u0B
;	illegal			; 0C
	ora	abs		; 0Dr00s00
	asl	abs		; 0Er00s00
	seb	bit0,zp		;u0F*00

	; *****-----*****

	bpl	.+2		; 10 00
	ora	[zp],y		; 11*00
	clt			; 12
	bbc	bit0,a,.+2	;u13 00
;	illegal			; 14
	ora	zp,x		; 1Dr00s00
	asl	zp,x		; 1Er00s00
	bbc	bit0,zp,.+3	;u17*00 00
	clc			; 18
	ora	abs,y		; 19r00s00
	dec	a		; 1A
	clb	bit0,a		;u1B
;	illegal			; 1C
	ora	abs,x		; 1Dr00s00
	asl	abs,x		; 1Er00s00
	clb	bit0,zp		;u1F*00

	; *****-----*****

	jsr	abs		; 20r00s00
	and	[zp,x]		; 21*00
	jsr	\special	; 22r00
	bbs	bit1,a,.+2	;u03 00
	bit	zp		; 2Cr00s00
	and	zp		; 2Dr00s00
	rol	zp		; 2Er00s00
	bbs	bit1,zp,.+3	;u07*00 00
	plp			; 28
	and	#imm		; 29r00
	rol	a		; 2A
	seb	bit1,a		;u0B
	bit	abs		; 2Cr00s00
	and	abs		; 2Dr00s00
	rol	abs		; 2Er00s00
	seb	bit1,zp		;u0F*00

	; *****-----*****

	bmi	.+2		; 30 00
	and	[zp],y		; 31*00
	set			; 32
	bbc	bit1,a,.+2	;u13 00
;	illegal			; 34
	and	zp,x		; 3Dr00s00
	rol	zp,x		; 3Er00s00
	bbc	bit1,zp,.+3	;u17*00 00
	sec			; 38
	and	abs,y		; 39r00s00
	inc	a		; 3A
	clb	bit1,a		;u1B
	ldm	#imm,zp		; 3Cu00*00
	and	abs,x		; 3Dr00s00
	rol	abs,x		; 3Er00s00
	clb	bit1,zp		;u1F*00

	; *****-----*****

	rti			; 40
	eor	[zp,x]		; 41*00
	stp			; 42
	bbs	bit2,a,.+2	;u03 00
	com	zp		; 44*00
	eor	zp		; 4Dr00s00
	lsr	zp		; 4Er00s00
	bbs	bit2,zp,.+3	;u07*00 00
	pha			; 48
	eor	#imm		; 49r00
	lsr	a		; 4A
	seb	bit2,a		;u0B
	jmp	abs		; 4Cr00s00
	eor	abs		; 4Dr00s00
	lsr	abs		; 4Er00s00
	seb	bit2,zp		;u0F*00

	; *****-----*****

	bvc	.+2		; 50 00
	eor	[zp],y		; 51*00
;	illegal			; 52
	bbc	bit2,a,.+2	;u13 00
;	illegal			; 54
	eor	zp,x		; 5Dr00s00
	lsr	zp,x		; 5Er00s00
	bbc	bit2,zp,.+3	;u17*00 00
	cli			; 58
	eor	abs,y		; 59r00s00
;	illegal			; 5A
	clb	bit2,a		;u1B
;	illegal			; 5C
	eor	abs,x		; 5Dr00s00
	lsr	abs,x		; 5Er00s00
	clb	bit2,zp		;u1F*00

	; *****-----*****

	rts			; 60
	adc	[zp,x]		; 61*00
	mul	zp,x		; 62*00
	bbs	bit3,a,.+2	;u03 00
	tst	zp		; 64*00
	adc	zp		; 6Dr00s00
	ror	zp		; 6Er00s00
	bbs	bit3,zp,.+3	;u07*00 00
	pla			; 68
	adc	#imm		; 69r00
	ror	a		; 6A
	seb	bit3,a		;u0B
	jmp	[abs]		; 6Cr00s00
	adc	abs		; 6Dr00s00
	ror	abs		; 6Er00s00
	seb	bit3,zp		;u0F*00

	; *****-----*****

	bvs	.+2		; 70 00
	adc	[zp],y		; 71*00
;	illegal			; 72
	bbc	bit3,a,.+2	;u13 00
;	illegal			; 74
	adc	zp,x		; 7Dr00s00
	ror	zp,x		; 7Er00s00
	bbc	bit3,zp,.+3	;u17*00 00
	sei			; 78
	adc	abs,y		; 79r00s00
;	illegal			; 7A
	clb	bit3,a		;u1B
;	illegal			; 7C
	adc	abs,x		; 7Dr00s00
	ror	abs,x		; 7Er00s00
	clb	bit3,zp		;u1F*00

	; *****-----*****

	bra	.+2		; 80 00
	sta	[zp,x]		; 81*00
	rrf	zp		; 82*00
	bbs	bit4,a,.+2	;u03 00
	sty	zp		; 8Cr00s00
	sta	zp		; 8Dr00s00
	stx	zp		; 8Er00s00
	bbs	bit4,zp,.+3	;u07*00 00
	dey			; 88
;	illegal			; 89
	txa			; 8A
	seb	bit4,a		;u0B
	sty	abs		; 8Cr00s00
	sta	abs		; 8Dr00s00
	stx	abs		; 8Er00s00
	seb	bit4,zp		;u0F*00

	; *****-----*****

	bcc	.+2		; 90 00
	sta	[zp],y		; 91*00
;	illegal			; 92
	bbc	bit4,a,.+2	;u13 00
	sty	zp,x		; 94*00
	sta	zp,x		; 9Dr00s00
	stx	zp,y		; 96*00
	bbc	bit4,zp,.+3	;u17*00 00
	tya			; 98
	sta	abs,y		; 99r00s00
	txs			; 9A
	clb	bit4,a		;u1B
;	illegal			; 9C
	sta	abs,x		; 9Dr00s00
;	illegal			; 9E
	clb	bit4,zp		;u1F*00

	; *****-----*****

	ldy	#imm		; A0r00
	lda	[zp,x]		; A1*00
	ldx	#imm		; A2r00
	bbs	bit5,a,.+2	;u03 00
	ldy	zp		; ACr00s00
	lda	zp		; ADr00s00
	ldx	zp		; AEr00s00
	bbs	bit5,zp,.+3	;u07*00 00
	tay			; A8
	lda	#imm		; A9r00
	tax			; AA
	seb	bit5,a		;u0B
	ldy	abs		; ACr00s00
	lda	abs		; ADr00s00
	ldx	abs		; AEr00s00
	seb	bit5,zp		;u0F*00

	; *****-----*****

	bcs	.+2		; B0 00
	lda	[zp],y		; B1*00
	jmp	[zp]		; 6Cr00s00
	bbc	bit5,a,.+2	;u13 00
	ldy	zp,x		; BCr00s00
	lda	zp,x		; BDr00s00
	ldx	zp,y		; BEr00s00
	bbc	bit5,zp,.+3	;u17*00 00
	clv			; B8
	lda	abs,y		; B9r00s00
	tsx			; BA
	clb	bit5,a		;u1B
	ldy	abs,x		; BCr00s00
	lda	abs,x		; BDr00s00
	ldx	abs,y		; BEr00s00
	clb	bit5,zp		;u1F*00

	; *****-----*****

	cpy	#imm		; C0r00
	cmp	[zp,x]		; C1*00
	wit			; C2
	bbs	bit6,a,.+2	;u03 00
	cpy	zp		; CCr00s00
	cmp	zp		; CDr00s00
	dec	zp		; CEr00s00
	bbs	bit6,zp,.+3	;u07*00 00
	iny			; C8
	cmp	#imm		; C9r00
	dex			; CA
	seb	bit6,a		;u0B
	cpy	abs		; CCr00s00
	cmp	abs		; CDr00s00
	dec	abs		; CEr00s00
	seb	bit6,zp		;u0F*00

	; *****-----*****

	bne	.+2		; D0 00
	cmp	[zp],y		; D1*00
;	illegal			; D2
	bbc	bit6,a,.+2	;u13 00
;	illegal			; D4
	cmp	zp,x		; DDr00s00
	dec	zp,x		; DEr00s00
	bbc	bit6,zp,.+3	;u17*00 00
	cld			; D8
	cmp	abs,y		; D9r00s00
;	illegal			; DA
	clb	bit6,a		;u1B
;	illegal			; DC
	cmp	abs,x		; DDr00s00
	dec	abs,x		; DEr00s00
	clb	bit6,zp		;u1F*00

	; *****-----*****

	cpx	#imm		; E0r00
	sbc	[zp,x]		; E1*00
	div	zp,x		; E2*00
	bbs	bit7,a,.+2	;u03 00
	cpx	zp		; ECr00s00
	sbc	zp		; EDr00s00
	inc	zp		; EEr00s00
	bbs	bit7,zp,.+3	;u07*00 00
	inx			; E8
	sbc	#imm		; E9r00
	nop			; EA
	seb	bit7,a		;u0B
	cpx	abs		; ECr00s00
	sbc	abs		; EDr00s00
	inc	abs		; EEr00s00
	seb	bit7,zp		;u0F*00

	; *****-----*****

	beq	.+2		; F0 00
	sbc	[zp],y		; F1*00
;	illegal			; F2
	bbc	bit7,a,.+2	;u13 00
;	illegal			; F4
	sbc	zp,x		; FDr00s00
	inc	zp,x		; FEr00s00
	bbc	bit7,zp,.+3	;u17*00 00
	sed			; F8
	sbc	abs,y		; F9r00s00
;	illegal			; FA
	clb	bit7,a		;u1B
;	illegal			; FC
	sbc	abs,x		; FDr00s00
	inc	abs,x		; FEr00s00
	clb	bit7,zp		;u1F*00



