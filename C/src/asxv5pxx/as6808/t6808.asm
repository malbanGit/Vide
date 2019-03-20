	.title	AS6808 Sequential Test

	;	This is the AS6805 Sequential Test file
	;	t6805s.asm updated to include the 68HC08
	;	and 68HCS08 instructions.

	; Internal Control Definitions

.ifndef	I$C$D
	I$C$D	=:	1
.endif

.if I$C$D
	.hcs08

	gbltest	=	0

	.define		hc$05,	""
	.define		hc$08,	""
	.define		hc$s08,	""

	.define		er$05,	";er05"		; 05/08/S08 errors
	.define		er$08,	";er08"		; 08/S08 errors 
	.define		er$s08,	";ers08"	; S08 errors
.endif

	; Global/Local Variable Options

.if gbltest
.define	ext, "0x0123 + extE"
.define	ix1, "0x00EF + ix1E"
.define	ix2, "0xABCD + ix2E"
.else
	ext = 0x0123
	ix1 = 0x00EF
	ix2 = 0xABCD
.endif

	.area	DIRECT

	.setdp	0,DIRECT

	bit0	=	0
	bit1	=	1
	bit2	=	2
	bit3	=	3
	bit4	=	4
	bit5	=	5
	bit6	=	6
	bit7	=	7


.ifndef	dir$var
begin:	.byte	0			; 00
loca:	.byte	0			; 00
locb:	.byte	0			; 00
locc:	.byte	0			; 00
locd:	.byte	0			; 00
loce:	.byte	0			; 00

	dir$var	=	1
.endif

.ifeq (.__.CPU. - 0)
	.area	AS6808A$68HC08	(ABS,OVR)
A$68HC08:
.else
	.ifeq (.__.CPU. - 1)
	.area	AS6808A$68HCS08	(ABS,OVR)
A$68HCS08:
	.else
		.ifeq (.__.CPU. - 2)
	.area	AS6808A$6805	(ABS,OVR)
A$6805:
		.else
			.ifeq (.__.CPU. - 3)
	.area	AS6808A$146805	(ABS,OVR)
A$146805:
			.else
	.area	AS6808A		(ABS,OVR)
A:
			.endif
		.endif
	.endif
.endif

1$:
hc$05	jsr	1$			; CDs00r00
hc$05	jmp	1$			; CCs00r00
hc$05	sub	1$			; C0s00r00

	.org	256

2$:
hc$05	brset	#bit0,*loca, .		; 00*01 FD
hc$05	brclr	#bit0,*loca,2$		; 01*01 FA
hc$05	brset	#bit1,*loca,2$		; 02*01 F7
hc$05	brclr	#bit1,*loca,2$		; 03*01 F4
hc$05	brset	#bit2,*loca,2$		; 04*01 F1
hc$05	brclr	#bit2,*loca,2$		; 05*01 EE
hc$05	brset	#bit3,*loca,2$		; 06*01 EB
hc$05	brclr	#bit3,*loca,2$		; 07*01 E8
hc$05	brset	#bit4,*loca,2$		; 08*01 E5
hc$05	brclr	#bit4,*loca,2$		; 09*01 E2
hc$05	brset	#bit5,*loca,2$		; 0A*01 DF
hc$05	brclr	#bit5,*loca,2$		; 0B*01 DC
hc$05	brset	#bit6,*loca,2$		; 0C*01 D9
hc$05	brclr	#bit6,*loca,2$		; 0D*01 D6
hc$05	brset	#bit7,*loca,2$		; 0E*01 D3
hc$05	brclr	#bit7,*loca,2$		; 0F*01 D0


hc$05	bset	#bit0,*locb		; 10*02
hc$05	bclr	#bit0,*locb		; 11*02
hc$05	bset	#bit1,*locb		; 12*02
hc$05	bclr	#bit1,*locb		; 13*02
hc$05	bset	#bit2,*locb		; 14*02
hc$05	bclr	#bit2,*locb		; 15*02
hc$05	bset	#bit3,*locb		; 16*02
hc$05	bclr	#bit3,*locb		; 17*02
hc$05	bset	#bit4,*locb		; 18*02
hc$05	bclr	#bit4,*locb		; 19*02
hc$05	bset	#bit5,*locb		; 1A*02
hc$05	bclr	#bit5,*locb		; 1B*02
hc$05	bset	#bit6,*locb		; 1C*02
hc$05	bclr	#bit6,*locb		; 1D*02
hc$05	bset	#bit7,*locb		; 1E*02
hc$05	bclr	#bit7,*locb		; 1F*02


3$:
hc$05	bra	3$			; 20 FE
hc$05	brn	3$			; 21 FC
hc$05	bhi	3$			; 22 FA
hc$05	bls	3$			; 23 F8
hc$05	bcc	3$			; 24 F6
hc$05	bcs	3$			; 25 F4
hc$05	bne	3$			; 26 F2
hc$05	beq	3$			; 27 F0
hc$05	bhcc	3$			; 28 EE
hc$05	bhcs	3$			; 29 EC
hc$05	bpl	3$			; 2A EA
hc$05	bmi	3$			; 2B E8
hc$05	bmc	3$			; 2C E6
hc$05	bms	3$			; 2D E4
hc$05	bil	3$			; 2E E2
hc$05	bih	3$			; 2F E0


hc$05	neg	*locc			; 30*03

4$:
hc$08	cbeq	*locc,4$		; 31*03 FD

.if gbltest
hc$s08	ldhx	ext			; 32s01r23
.else
hc$s08	ldhx	ext			; 32 01 23
.endif

hc$05	com	*locc			; 33*03
hc$05	lsr	*locc			; 34*03
hc$08	sthx	*locc			; 35*03
hc$05	ror	*locc			; 36*03
hc$05	asr	*locc			; 37*03
hc$05	lsl	*locc			; 38*03
hc$05	rol	*locc			; 39*03
hc$05	dec	*locc			; 3A*03

5$:
hc$08	dbnz	*locc,5$		; 3B*03 FD
	inc	*locc			; 3C*03
	tst	*locc			; 3D*03
				;3E
.if gbltest
hc$s08	cphx	ext			; 3Es01r23
.else
hc$s08	cphx	ext			; 3E 01 23
.endif

clr	*locc			; 3F*03


	nega				; 40

6$:
hc$08	cbeqa	#0x21,6$		; 41 21 FD
hc$08	mul				; 42
hc$05	coma				; 43
hc$05	lsra				; 44
hc$08	ldhx	#0x21			; 45 00 21
hc$05	rora				; 46
hc$05	asra				; 47
hc$05	lsla				; 48
hc$05	rola				; 49
hc$05	deca				; 4A

7$:
hc$08	dbnza	7$			; 4B FE
hc$05	inca				; 4C
hc$05	tsta				; 4D
hc$08	mov	*loca,*locb		; 4E*01*02
hc$05	clra				; 4F


	negx				; 50

8$:
hc$08	cbeqx	#0x21,8$		; 51 21 FD
hc$08	div				; 52
hc$05	comx				; 53
hc$05	lsrx				; 54
hc$08	ldhx	*loca			; 55*01
hc$05	rorx				; 56
hc$05	asrx				; 57
hc$05	lslx				; 58
hc$05	rolx				; 59
hc$05	decx				; 5A

9$:
hc$08	dbnzx	9$			; 5B FE
hc$05	incx				; 5C
hc$05	tstx				; 5D
hc$08	mov	*loca,x+		; 5E*01
hc$05	clrx				; 5F


hc$05	neg	locd,x			; 60u04

10$:
hc$08	cbeq	4,x+,10$		; 61 04 FD
hc$08	nsa				; 62
hc$05	com	locd,x			; 63u04
hc$05	lsr	locd,x			; 64u04
hc$08	cphx	#0x21			; 65 00 21
hc$05	ror	locd,x			; 66u04
hc$05	asr	locd,x			; 67u04
hc$05	lsl	locd,x			; 68u04
hc$05	rol	locd,x			; 69u04
hc$05	dec	locd,x			; 6Au04

11$:
hc$08	dbnz	locd,x,11$		; 6Bu04 FD
hc$05	inc	locd,x			; 6Cu04
hc$05	tst	locd,x			; 6Du04
hc$08	mov	#0x21,*loca		; 6E 21*01
hc$05	clr	locd,x			; 6Fu04


hc$08	neg	locd,s			; 9E 60u04

12$:
hc$08	cbeq	locd,s,12$		; 9E 61u04 FC
				;9E 62
hc$08	com	locd,s			; 9E 63u04
hc$08	lsr	locd,s			; 9E 64u04
				;9E 65
hc$08	ror	locd,s			; 9E 66u04
hc$08	asr	locd,s			; 9E 67u04
hc$08	lsl	locd,s			; 9E 68u04
hc$08	rol	locd,s			; 9E 69u04
hc$08	dec	locd,s			; 9E 6Au04

13$:
hc$08	dbnz	locd,s,13$		; 9E 6Bu04 FC
hc$08	inc	locd,s			; 9E 6Cu04
hc$08	tst	locd,s			; 9E 6Du04
				;9E 6E
hc$08	clr	locd,s			; 9E 6Fu04


hc$05	neg	,x			; 70

14$:
hc$08	cbeq	,x+,14$			; 71 FE
hc$08	daa				; 72
hc$05	com	,x			; 73
hc$05	lsr	,x			; 74
hc$08	cphx	*loca			; 75*01
hc$05	ror	,x			; 76
hc$05	asr	,x			; 77
hc$05	lsl	,x			; 78
hc$05	rol	,x			; 79
hc$05	dec	,x			; 7A

15$:
hc$08	dbnz	,x,15$			; 7B FE
hc$05	inc	,x			; 7C
hc$05	tst	,x			; 7D
hc$08	mov	,x+,*loca		; 7E*01
hc$05	clr	,x			; 7F


hc$05	rti				; 80
hc$05	rts				; 81
hc$s08	bgnd				; 82
hc$05	swi				; 83
hc$08	tap				; 84
hc$08	tpa				; 85
hc$08	pula				; 86
hc$08	psha				; 87
hc$08	pulx				; 88
hc$08	pshx				; 89
hc$08	pulh				; 8A
hc$08	pshh				; 8B
hc$08	clrh				; 8C
				;8D 
hc$05	stop				; 8E
hc$05	wait				; 8F


16$:
hc$08	bge	16$			; 90 FE
hc$08	blt	16$			; 91 FC
hc$08	bgt	16$			; 92 FA
hc$08	ble	16$			; 93 F8
hc$08	txs				; 94
hc$08	tsx				; 95

.if gbltest
hc$s08	sthx	ext			; 96s01r23
.else
hc$s08	sthx	ext			; 96 01 23
.endif

hc$05	tax				; 97
hc$05	clc				; 98
hc$05	sec				; 99
hc$05	cli				; 9A
hc$05	sei				; 9B
hc$05	rsp				; 9C
hc$05	nop				; 9D
				;9E
hc$05	txa				; 9F

				
hc$05	sub	#0x21			; A0 21
hc$05	cmp	#0x21			; A1 21
hc$05	sbc	#0x21			; A2 21
hc$05	cpx	#0x21			; A3 21
hc$05	and	#0x21			; A4 21
hc$05	bit	#0x21			; A5 21
hc$05	lda	#0x21			; A6 21
hc$08	ais	#0x21			; A7 21
hc$05	eor	#0x21			; A8 21
hc$05	adc	#0x21			; A9 21
hc$05	ora	#0x21			; AA 21
hc$05	add	#0x21			; AB 21
				;AC
17$:
hc$05	bsr	17$			; AD FE
hc$05	ldx	#0x21			; AE 21

hc$s08	ldhx	,x			; 9E AE

hc$08	aix	#0x21			; AF 21


hc$05	sub	*loce			; B0*05
hc$05	cmp	*loce			; B1*05
hc$05	sbc	*loce			; B2*05
hc$05	cpx	*loce			; B3*05
hc$05	and	*loce			; B4*05
hc$05	bit	*loce			; B5*05
hc$05	lda	*loce			; B6*05
hc$05	sta	*loce			; B7*05
hc$05	eor	*loce			; B8*05
hc$05	adc	*loce			; B9*05
hc$05	ora	*loce			; BA*05
hc$05	add	*loce			; BB*05
hc$05	jmp	*loce			; BC*05
hc$05	jsr	*loce			; BD*05
hc$05	ldx	*loce			; BE*05

.if gbltest
hc$s08	ldhx	ix2,x			; 9E BEsABrCD
.else
hc$s08	ldhx	ix2,x			; 9E BE AB CD
.endif

hc$05	stx	*loce			; BF*05

.if gbltest
hc$05	sub	ext			; C0s01r23
hc$05	cmp	ext			; C1s01r23
hc$05	sbc	ext			; C2s01r23
hc$05	cpx	ext			; C3s01r23
hc$05	and	ext			; C4s01r23
hc$05	bit	ext			; C5s01r23
hc$05	lda	ext			; C6s01r23
hc$05	sta	ext			; C7s01r23
hc$05	eor	ext			; C8s01r23
hc$05	adc	ext			; C9s01r23
hc$05	ora	ext			; CAs01r23
hc$05	add	ext			; CBs01r23
hc$05	jmp	ext			; CCs01r23
hc$05	jsr	ext			; CDs01r23
hc$05	ldx	ext			; CEs01r23

hc$s08	ldhx	ix1,x			; 9E BEs00rEF

hc$05	stx	ext			; CFs01r23
.else
hc$05	sub	ext			; C0 01 23
hc$05	cmp	ext			; C1 01 23
hc$05	sbc	ext			; C2 01 23
hc$05	cpx	ext			; C3 01 23
hc$05	and	ext			; C4 01 23
hc$05	bit	ext			; C5 01 23
hc$05	lda	ext			; C6 01 23
hc$05	sta	ext			; C7 01 23
hc$05	eor	ext			; C8 01 23
hc$05	adc	ext			; C9 01 23
hc$05	ora	ext			; CA 01 23
hc$05	add	ext			; CB 01 23
hc$05	jmp	ext			; CC 01 23
hc$05	jsr	ext			; CD 01 23
hc$05	ldx	ext			; CE 01 23

hc$s08	ldhx	ix1,x			; 9E CE EF

hc$05	stx	ext			; CF 01 23
.endif


.if gbltest
hc$05	sub	ix2,x			; D0sABrCD
hc$05	cmp	ix2,x			; D1sABrCD
hc$05	sbc	ix2,x			; D2sABrCD
hc$05	cpx	ix2,x			; D3sABrCD
hc$05	and	ix2,x			; D4sABrCD
hc$05	bit	ix2,x			; D5sABrCD
hc$05	lda	ix2,x			; D6sABrCD
hc$05	sta	ix2,x			; D7sABrCD
hc$05	eor	ix2,x			; D8sABrCD
hc$05	adc	ix2,x			; D9sABrCD
hc$05	ora	ix2,x			; DAsABrCD
hc$05	add	ix2,x			; DBsABrCD
hc$05	jmp	ix2,x			; DCsABrCD
hc$05	jsr	ix2,x			; DDsABrCD
hc$05	ldx	ix2,x			; DEsABrCD
hc$05	stx	ix2,x			; DFsABrCD
.else
hc$05	sub	ix2,x			; D0 AB CD
hc$05	cmp	ix2,x			; D1 AB CD
hc$05	sbc	ix2,x			; D2 AB CD
hc$05	cpx	ix2,x			; D3 AB CD
hc$05	and	ix2,x			; D4 AB CD
hc$05	bit	ix2,x			; D5 AB CD
hc$05	lda	ix2,x			; D6 AB CD
hc$05	sta	ix2,x			; D7 AB CD
hc$05	eor	ix2,x			; D8 AB CD
hc$05	adc	ix2,x			; D9 AB CD
hc$05	ora	ix2,x			; DA AB CD
hc$05	add	ix2,x			; DB AB CD
hc$05	jmp	ix2,x			; DC AB CD
hc$05	jsr	ix2,x			; DD AB CD
hc$05	ldx	ix2,x			; DE AB CD
hc$05	stx	ix2,x			; DF AB CD
.endif

; /* HC08

.if gbltest
hc$08	sub	ix2,s			; 9E D0sABrCD
hc$08	cmp	ix2,s			; 9E D1sABrCD
hc$08	sbc	ix2,s			; 9E D2sABrCD
hc$08	cpx	ix2,s			; 9E D3sABrCD
hc$08	and	ix2,s			; 9E D4sABrCD
hc$08	bit	ix2,s			; 9E D5sABrCD
hc$08	lda	ix2,s			; 9E D6sABrCD
hc$08	sta	ix2,s			; 9E D7sABrCD
hc$08	eor	ix2,s			; 9E D8sABrCD
hc$08	adc	ix2,s			; 9E D9sABrCD
hc$08	ora	ix2,s			; 9E DAsABrCD
hc$08	add	ix2,s			; 9E DBsABrCD
				;9E DC
				;9E DD
hc$08	ldx	ix2,s			; 9E DEsABrCD
hc$08	stx	ix2,s			; 9E DFsABrCD
.else
hc$08	sub	ix2,s			; 9E D0 AB CD
hc$08	cmp	ix2,s			; 9E D1 AB CD
hc$08	sbc	ix2,s			; 9E D2 AB CD
hc$08	cpx	ix2,s			; 9E D3 AB CD
hc$08	and	ix2,s			; 9E D4 AB CD
hc$08	bit	ix2,s			; 9E D5 AB CD
hc$08	lda	ix2,s			; 9E D6 AB CD
hc$08	sta	ix2,s			; 9E D7 AB CD
hc$08	eor	ix2,s			; 9E D8 AB CD
hc$08	adc	ix2,s			; 9E D9 AB CD
hc$08	ora	ix2,s			; 9E DA AB CD
hc$08	add	ix2,s			; 9E DB AB CD
				;9E DC
				;9E DD
hc$08	ldx	ix2,s			; 9E DE AB CD
hc$08	stx	ix2,s			; 9E DF AB CD
.endif


.if gbltest
hc$05	sub	ix1,x			; D0s00rEF
hc$05	cmp	ix1,x			; D1s00rEF
hc$05	sbc	ix1,x			; D2s00rEF
hc$05	cpx	ix1,x			; D3s00rEF
hc$05	and	ix1,x			; D4s00rEF
hc$05	bit	ix1,x			; D5s00rEF
hc$05	lda	ix1,x			; D6s00rEF
hc$05	sta	ix1,x			; D7s00rEF
hc$05	eor	ix1,x			; D8s00rEF
hc$05	adc	ix1,x			; D9s00rEF
hc$05	ora	ix1,x			; DAs00rEF
hc$05	add	ix1,x			; DBs00rEF
hc$05	jmp	ix1,x			; DCs00rEF
hc$05	jsr	ix1,x			; DDs00rEF
hc$05	ldx	ix1,x			; DEs00rEF
hc$05	stx	ix1,x			; DFs00rEF
.else
hc$05	sub	ix1,x			; E0 EF
hc$05	cmp	ix1,x			; E1 EF
hc$05	sbc	ix1,x			; E2 EF
hc$05	cpx	ix1,x			; E3 EF
hc$05	and	ix1,x			; E4 EF
hc$05	bit	ix1,x			; E5 EF
hc$05	lda	ix1,x			; E6 EF
hc$05	sta	ix1,x			; E7 EF
hc$05	eor	ix1,x			; E8 EF
hc$05	adc	ix1,x			; E9 EF
hc$05	ora	ix1,x			; EA EF
hc$05	add	ix1,x			; EB EF
hc$05	jmp	ix1,x			; EC EF
hc$05	jsr	ix1,x			; ED EF
hc$05	ldx	ix1,x			; EE EF
hc$05	stx	ix1,x			; EF EF
.endif


.if gbltest
hc$08	sub	ix1,s			; 9E D0s00rEF
hc$08	cmp	ix1,s			; 9E D1s00rEF
hc$08	sbc	ix1,s			; 9E D2s00rEF
hc$08	cpx	ix1,s			; 9E D3s00rEF
hc$08	and	ix1,s			; 9E D4s00rEF
hc$08	bit	ix1,s			; 9E D5s00rEF
hc$08	lda	ix1,s			; 9E D6s00rEF
hc$08	sta	ix1,s			; 9E D7s00rEF
hc$08	eor	ix1,s			; 9E D8s00rEF
hc$08	adc	ix1,s			; 9E D9s00rEF
hc$08	ora	ix1,s			; 9E DAs00rEF
hc$08	add	ix1,s			; 9E DBs00rEF
				;9E DC
				;9E DD
hc$08	ldx	ix1,s			; 9E DEs00rEF
hc$08	stx	ix1,s			; 9E DFs00rEF
.else
hc$08	sub	ix1,s			; 9E E0 EF
hc$08	cmp	ix1,s			; 9E E1 EF
hc$08	sbc	ix1,s			; 9E E2 EF
hc$08	cpx	ix1,s			; 9E E3 EF
hc$08	and	ix1,s			; 9E E4 EF
hc$08	bit	ix1,s			; 9E E5 EF
hc$08	lda	ix1,s			; 9E E6 EF
hc$08	sta	ix1,s			; 9E E7 EF
hc$08	eor	ix1,s			; 9E E8 EF
hc$08	adc	ix1,s			; 9E E9 EF
hc$08	ora	ix1,s			; 9E EA EF
hc$08	add	ix1,s			; 9E EB EF
				;9E EC
				;9E ED
hc$08	ldx	ix1,s			; 9E EE EF
hc$08	stx	ix1,s			; 9E EF EF
.endif


hc$05	sub	,x			; F0
hc$05	cmp	,x			; F1
hc$05	sbc	,x			; F2
hc$05	cpx	,x			; F3

hc$s08	cphx	locd,s			; 9E F3u04

hc$05	and	,x			; F4
hc$05	bit	,x			; F5
hc$05	lda	,x			; F6
hc$05	sta	,x			; F7
hc$05	eor	,x			; F8
hc$05	adc	,x			; F9
hc$05	ora	,x			; FA
hc$05	add	,x			; FB
hc$05	jmp	,x			; FC
hc$05	jsr	,x			; FD
hc$05	ldx	,x			; FE

hc$s08	ldhx	locd,s			; 9E FEu04

hc$05	stx	,x			; FF

hc$s08	sthx	locd,s			; 9E FFu04



18$:
hc$05	jsr	*begin			; BD*00
hc$05	jmp	*begin			; BC*00
hc$05	sub	*begin			; B0*00

19$:
hc$05	jsr	1$			; CDs00r00
20$:
hc$05	jmp	1$			; CCs00r00
21$:
hc$05	sub	1$			; C0s00r00



.ifeq (.__.CPU. - 0)
	.area	AS6808B$68HC08	(ABS,OVR)
B$68HC08:
.else
	.ifeq (.__.CPU. - 1)
	.area	AS6808B$68HCS08	(ABS,OVR)
B$68HCS08:
	.else
		.ifeq (.__.CPU. - 2)
	.area	AS6808B$6805	(ABS,OVR)
B$6805:
		.else
			.ifeq (.__.CPU. - 3)
	.area	AS6808B$146805	(ABS,OVR)
B$146805:
			.else
	.area	AS6808B		(ABS,OVR)
B:
			.endif
		.endif
	.endif
.endif

	.org	256
1$:

	; Illegal Modes for:
	;	neg, com, lsr, ror,
	;	asr, lsl, rol, asl,
	;	dec, inc, tst and clr

er$05	neg	,s		;a
er$05	neg	ix2,x		;a (may cause a link error if ix2 is external)
er$05	neg	ix2,s		;a (may cause a link error if ix2 is external)
er$05	neg	,x+		;a
er$05	neg	ix1,x+		;a

	; Illegal Modes for:
	;	sub, cmp, sbc, cpx,
	;	and, bit, lda, sta,
	;	eor, adc, ora, add,
	;	jmp, jsr, ldx, and stx

er$05	sub	,s		;a
er$05	sub	,x+		;a
er$05	sub	ix1,x+		;a

	; Additional Illegal Modes for:
	;	sta and stx

er$05	sta	#0		;a

	; Additional Illegal Modes for:
	;	jmp and jsr

er$05	jmp	#0		;a
er$05	jmp	ix2,s		;a
er$05	jmp	ix1,s		;a
er$05	jmp	,x+		;a
er$05	jmp	ix1,x+		;a

	; Illegal Modes for:
	;	cbeqa and cbeqx

2$:
er$08	cbeqa	*loca,2$	;a
3$:
er$08	cbeqa	,x,3$		;a
4$:
er$08	cbeqa	ix1,x,4$	;a
5$:
er$08	cbeqa	ix2,x,5$	;a
6$:
er$08	cbeqa	,x+,6$		;a
7$:
er$08	cbeqa	ix1,x+,7$	;a
8$:
er$08	cbeqa	ix1,s,8$	;a
9$:
er$08	cbeqa	ix2,s,9$	;a

	; Illegal Modes for:
	;	cbeq

10$:
er$08	cbeq	#0x21,10$	;a
11$:
er$08	cbeq	,x,11$		;a
12$:
er$08	cbeq	ix1,x,12$	;a
13$:
er$08	cbeq	ix2,x,13$	;a (may cause link error if ix2 is external)
14$:
er$08	cbeq	ix2,s,14$	;a (may cause link error if ix2 is external)

	; Illegal Modes for:
	;	dbnza and dbnzx

15$:
er$08	dbnza	*loca,15$	;q
16$:
er$08	dbnza	,x,16$		;q
17$:
er$08	dbnza	ix1,x,17$	;q
18$:
er$08	dbnza	ix2,x,18$	;aq
19$:
er$08	dbnza	,x+,19$		;q
20$:
er$08	dbnza	ix1,x+,20$	;q
21$:
er$08	dbnza	ix1,s,21$	;q
22$:
er$08	dbnza	ix2,s,22$	;aq

	; Illegal Modes for:
	;	dbnz

23$:
er$08	dbnz	#0x21,23$	;a
24$:
er$08	dbnz	,x+,24$		;a
25$:
er$08	dbnz	ix1,x+,25$	;a
26$:
er$08	dbnz	ix2,x+,26$	;a
27$:
er$08	dbnz	ix2,s,27$	;a (may cause link error if ix2 is external)

	; Illegal Instruction
	;	bgnd

er$05	bgnd
er$08	bgnd




