	.title	AS6811 Sequential Test

	.area	DIRECT

	.blkb	0x12
				; direct page location
dirpag:				;  
	ext	= 0x1234	; extended address


	.area	AS6801

	.setdp	DIRECT

					; 00
	nop				; 01
	idiv				; 02
	fdiv				; 03
	lsrd				; 04
	asld				; 05
	tap				; 06
	tpa				; 07
	inx				; 08
	dex				; 09
	clv				; 0A
	sev				; 0B
	clc				; 0C
	sec				; 0D
	cli				; 0E
	sei				; 0F
	sba				; 10
	cba				; 11
1$:	brset *dirpag,#0x5A, 1$		; 12*12 5A FC
	brclr *dirpag,#0x5B, 1$		; 13*12 5B F8
	bset	*dirpag,#0x5C		; 14*12 5C
	bclr	*dirpag,#0x5D		; 15*12 5D
	tab				; 16
	tba				; 17
					; 18	PAGE 2
	daa				; 19
					; 1A	PAGE 3
	aba				; 1B
	bset  4,x, #0x5C		; 1C 04 5C
	bclr  5,x, #0x5D		; 1D 05 5D
2$:	brset 6,x, #0x5A, 2$		; 1E 06 5A FC
	brclr 7,x, #0x5B, 2$		; 1F 07 5B F8


	bra	.			; 20 FE
	brn	.			; 21 FE
	bhi	.			; 22 FE
	bls	.			; 23 FE
	bcc	.			; 24 FE
	bcs	.			; 25 FE
	bne	.			; 26 FE
	beq	.			; 27 FE
	bvc	.			; 28 FE
	bvs	.			; 29 FE
	bpl	.			; 2A FE
	bmi	.			; 2B FE
	bge	.			; 2C FE
	blt	.			; 2D FE
	bgt	.			; 2E FE
	ble	.			; 2F FE
	tsx				; 30
	ins				; 31
	pula				; 32
	pulb				; 33
	des				; 34
	txs				; 35
	psha				; 36
	pshb				; 37
	pulx				; 38
	rts				; 39
	abx				; 3A
	rti				; 3B
	pshx				; 3C
	mul				; 3D
	wai				; 3E
	swi				; 3F



	nega				; 40
					; 41
					; 42
	coma				; 43
	lsra				; 44
					; 45
	rora				; 46
	asra				; 47
	asla				; 48
	rola				; 49
	deca				; 4A
					; 4B
	inca				; 4C
	tsta				; 4D
					; 4E
	clra				; 4F
	negb				; 50
					; 51
					; 52
	comb				; 53
	lsrb				; 54
					; 55
	rorb				; 56
	asrb				; 57
	aslb				; 58
	rolb				; 59
	decb				; 5A
					; 5B
	incb				; 5C
	tstb				; 5D
					; 5E
	clrb				; 5F



	neg	,x			; 60 00
					; 61
					; 62
	com	,x			; 63 00
	lsr	,x			; 64 00
					; 65
	ror	,x			; 66 00
	asr	,x			; 67 00
	asl	,x			; 68 00
	rol	,x			; 69 00
	dec	,x			; 6A 00
					; 6B
	inc	,x			; 6C 00
	tst	,x			; 6D 00
	jmp	,x			; 6E 00
	clr	,x			; 6F 00
	neg	ext			; 70 12 34
					; 71
					; 72
	com	ext			; 73 12 34
	lsr	ext			; 74 12 34
					; 75
	ror	ext			; 76 12 34
	asr	ext			; 77 12 34
	asl	ext			; 78 12 34
	rol	ext			; 79 12 34
	dec	ext			; 7A 12 34
					; 7B
	inc	ext			; 7C 12 34
	tst	ext			; 7D 12 34
	jmp	ext			; 7E 12 34
	clr	ext			; 7F 12 34



	suba	#1			; 80 01
	cmpa	#1			; 81 01
	sbca	#1			; 82 01
	subd	#1			; 83 00 01
	anda	#1			; 84 01
	bita	#1			; 85 01
	ldaa	#1			; 86 01
					; 87
	eora	#1			; 88 01
	adca	#1			; 89 01
	oraa	#1			; 8A 01
	adda	#1			; 8B 01
	cpx	#1			; 8C 00 01
	bsr	.			; 8D FE
	lds	#1			; 8E 00 01
	xgdx				; 8F
	suba	*dirpag			; 90*12
	cmpa	*dirpag			; 91*12
	sbca	*dirpag			; 92*12
	subd	*dirpag			; 93*12
	anda	*dirpag			; 94*12
	bita	*dirpag			; 95*12
	ldaa	*dirpag			; 96*12
	staa	*dirpag			; 97*12
	eora	*dirpag			; 98*12
	adca	*dirpag			; 99*12
	oraa	*dirpag			; 9A*12
	adda	*dirpag			; 9B*12
	cpx	*dirpag			; 9C*12
	jsr	*dirpag			; 9D*12
	lds	*dirpag			; 9E*12
	sts	*dirpag			; 9F*12



	suba	4,x			; A0 04
	cmpa	4,x			; A1 04
	sbca	4,x			; A2 04
	subd	4,x			; A3 04
	anda	4,x			; A4 04
	bita	4,x			; A5 04
	ldaa	4,x			; A6 04
	staa	4,x			; A7 04
	eora	4,x			; A8 04
	adca	4,x			; A9 04
	oraa	4,x			; AA 04
	adda	4,x			; AB 04
	cpx	4,x			; AC 04
	jsr	4,x			; AD 04
	lds	4,x			; AE 04
	sts	4,x			; AF 04
	suba	ext			; B0 12 34
	cmpa	ext			; B1 12 34
	sbca	ext			; B2 12 34
	subd	ext			; B3 12 34
	anda	ext			; B4 12 34
	bita	ext			; B5 12 34
	ldaa	ext			; B6 12 34
	staa	ext			; B7 12 34
	eora	ext			; B8 12 34
	adca	ext			; B9 12 34
	oraa	ext			; BA 12 34
	adda	ext			; BB 12 34
	cpx	ext			; BC 12 34
	jsr	ext			; BD 12 34
	lds	ext			; BE 12 34
	sts	ext			; BF 12 34



	subb	#1			; C0 01
	cmpb	#1			; C1 01
	sbcb	#1			; C2 01
	addd	#1			; C3 00 01
	andb	#1			; C4 01
	bitb	#1			; C5 01
	ldab	#1			; C6 01
					; C7
	eorb	#1			; C8 01
	adcb	#1			; C9 01
	orab	#1			; CA 01
	addb	#1			; CB 01
	ldd	#1			; CC 00 01
					; CD	PAGE 4
	ldx	#1			; CE 00 01
	stop				; CF
	subb	*dirpag			; D0*12
	cmpb	*dirpag			; D1*12
	sbcb	*dirpag			; D2*12
	addd	*dirpag			; D3*12
	andb	*dirpag			; D4*12
	bitb	*dirpag			; D5*12
	ldab	*dirpag			; D6*12
	stab	*dirpag			; D7*12
	eorb	*dirpag			; D8*12
	adcb	*dirpag			; D9*12
	orab	*dirpag			; DA*12
	addb	*dirpag			; DB*12
	ldd	*dirpag			; DC*12
	std	*dirpag			; DD*12
	ldx	*dirpag			; DE*12
	stx	*dirpag			; DF*12



	subb	dirpag,x		; E0u12
	cmpb	dirpag,x		; E1u12
	sbcb	dirpag,x		; E2u12
	addd	dirpag,x		; E3u12
	andb	dirpag,x		; E4u12
	bitb	dirpag,x		; E5u12
	ldab	dirpag,x		; E6u12
	stab	dirpag,x		; E7u12
	eorb	dirpag,x		; E8u12
	adcb	dirpag,x		; E9u12
	orab	dirpag,x		; EAu12
	addb	dirpag,x		; EBu12
	ldd	dirpag,x		; ECu12
	std	dirpag,x		; EDu12
	ldx	dirpag,x		; EEu12
	stx	dirpag,x		; EFu12
	subb	ext			; F0 12 34
	cmpb	ext			; F1 12 34
	sbcb	ext			; F2 12 34
	addd	ext			; F3 12 34
	andb	ext			; F4 12 34
	bitb	ext			; F5 12 34
	ldab	ext			; F6 12 34
	stab	ext			; F7 12 34
	eorb	ext			; F8 12 34
	adcb	ext			; F9 12 34
	orab	ext			; FA 12 34
	addb	ext			; FB 12 34
	ldd	ext			; FC 12 34
	std	ext			; FD 12 34
	ldx	ext			; FE 12 34
	stx	ext			; FF 12 34

	.sbttl	Page 2 instructions

	iny				; 18 08
	dey				; 18 09
	tsy				; 18 30
	tys				; 18 35
	puly				; 18 38
	aby				; 18 3A
	pshy				; 18 3C
	cpy	#ext			; 18 8C 12 34
	xgdy				; 18 8F
	cpy	*dirpag			; 18 9C*12

	suba	4,y			; 18 A0 04
	cmpa	4,y			; 18 A1 04
	sbca	4,y			; 18 A2 04
	subd	4,y			; 18 A3 04
	anda	4,y			; 18 A4 04
	bita	4,y			; 18 A5 04
	ldaa	4,y			; 18 A6 04
	staa	4,y			; 18 A7 04
	eora	4,y			; 18 A8 04
	adca	4,y			; 18 A9 04
	oraa	4,y			; 18 AA 04
	adda	4,y			; 18 AB 04
	cpy	4,y			; 18 AC 04
	jsr	4,y			; 18 AD 04
	lds	4,y			; 18 AE 04
	sts	4,y			; 18 AF 04

	cpy	ext			; 18 BC 12 34

	ldy	#ext			; 18 CE 12 34
	ldy	*dirpag			; 18 DE*12
	sty	*dirpag			; 18 DF*12

	subb	dirpag,y		; 18 E0u12
	cmpb	dirpag,y		; 18 E1u12
	sbcb	dirpag,y		; 18 E2u12
	addd	dirpag,y		; 18 E3u12
	andb	dirpag,y		; 18 E4u12
	bitb	dirpag,y		; 18 E5u12
	ldab	dirpag,y		; 18 E6u12
	stab	dirpag,y		; 18 E7u12
	eorb	dirpag,y		; 18 E8u12
	adcb	dirpag,y		; 18 E9u12
	orab	dirpag,y		; 18 EAu12
	addb	dirpag,y		; 18 EBu12
	ldd	dirpag,y		; 18 ECu12
	std	dirpag,y		; 18 EDu12
	ldy	dirpag,y		; 18 EEu12
	sty	dirpag,y		; 18 EFu12

	ldy	ext			; 18 FE 12 34
	sty	ext			; 18 FF 12 34

	.sbttl	Page 3 instructions

	cpd	#ext			; 1A 83 12 34
	cpd	*dirpag			; 1A 93*12
	cpd	4,x			; 1A A3 04
	cpy	4,x			; 1A AC 04
	cpd	ext			; 1A B3 12 34
	ldy	4,x			; 1A EE 04
	sty	4,x			; 1A EF 04

	.sbttl	Page 4 instructions

	cpd	4,y			; CD A3 04
	cpx	4,y			; CD AC 04
	ldx	4,y			; CD EE 04
	stx	4,y			; CD EF 04

