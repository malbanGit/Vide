	.title	AS6800 Sequential Test

	.area	DIRECT

	.setdp	0,DIRECT

	ext	= 0x1234	; extended address
	.blkb	0x12
				; direct page location
dirpag:				;  

	.area	AS6800

				;00
	nop			;01
				;02
				;03
				;04
				;05
	tap			;06
	tpa			;07
	inx			;08
	dex			;09
	clv			;0A
	sev			;0B
	clc			;0C
	sec			;0D
	cli			;0E
	sei			;0F
	sba			;10
	cba			;11
				;12
				;13
				;14
				;15
	tab			;16
	tba			;17
				;18
	daa			;19
				;1A
	aba			;1B
				;1C
				;1D
				;1E
				;1F

	.page

	bra	.		;20 FE
				;21 FE
	bhi	.		;22 FE
	bls	.		;23 FE
	bcc	.		;24 FE
	bcs	.		;25 FE
	bne	.		;26 FE
	beq	.		;27 FE
	bvc	.		;28 FE
	bvs	.		;29 FE
	bpl	.		;2A FE
	bmi	.		;2B FE
	bge	.		;2C FE
	blt	.		;2D FE
	bgt	.		;2E FE
	ble	.		;2F FE
	tsx			;30
	ins			;31
	pula			;32
	pulb			;33
	des			;34
	txs			;35
	psha			;36
	pshb			;37
				;38
	rts			;39
				;3A
	rti			;3B
				;3C
				;3D
	wai			;3E
	swi			;3F


	.page

	nega			;40
				;41
				;42
	coma			;43
	lsra			;44
				;45
	rora			;46
	asra			;47
	asla			;48
	rola			;49
	deca			;4A
				;4B
	inca			;4C
	tsta			;4D
				;4E
	clra			;4F
	negb			;50
				;51
				;52
	comb			;53
	lsrb			;54
				;55
	rorb			;56
	asrb			;57
	aslb			;58
	rolb			;59
	decb			;5A
				;5B
	incb			;5C
	tstb			;5D
				;5E
	clrb			;5F


	.page

	neg	,x		;60 00
				;61
				;62
	com	,x		;63 00
	lsr	,x		;64 00
				;65
	ror	,x		;66 00
	asr	,x		;67 00
	asl	,x		;68 00
	rol	,x		;69 00
	dec	,x		;6A 00
				;6B
	inc	,x		;6C 00
	tst	,x		;6D 00
	jmp	,x		;6E 00
	clr	,x		;6F 00
	neg	ext		;70 12 34
				;71
				;72
	com	ext		;73 12 34
	lsr	ext		;74 12 34
				;75
	ror	ext		;76 12 34
	asr	ext		;77 12 34
	asl	ext		;78 12 34
	rol	ext		;79 12 34
	dec	ext		;7A 12 34
				;7B
	inc	ext		;7C 12 34
	tst	ext		;7D 12 34
	jmp	ext		;7E 12 34
	clr	ext		;7F 12 34


	.page

	suba	#1		;80 01
	cmpa	#1		;81 01
	sbca	#1		;82 01
				;83
	anda	#1		;84 01
	bita	#1		;85 01
	ldaa	#1		;86 01
				;87
	eora	#1		;88 01
	adca	#1		;89 01
	oraa	#1		;8A 01
	adda	#1		;8B 01
	cpx	#1		;8C 00 01
	bsr	.		;8D FE
	lds	#1		;8E 00 01
				;8F
	suba	*dirpag		;90*12
	cmpa	*dirpag		;91*12
	sbca	*dirpag		;92*12
				;93
	anda	*dirpag		;94*12
	bita	*dirpag		;95*12
	ldaa	*dirpag		;96*12
	staa	*dirpag		;97*12
	eora	*dirpag		;98*12
	adca	*dirpag		;99*12
	oraa	*dirpag		;9A*12
	adda	*dirpag		;9B*12
	cpx	*dirpag		;9C*12
				;9D
	lds	*dirpag		;9E*12
	sts	*dirpag		;9F*12


	.page

	suba	4,x		;A0 04
	cmpa	4,x		;A1 04
	sbca	4,x		;A2 04
				;A3
	anda	4,x		;A4 04
	bita	4,x		;A5 04
	ldaa	4,x		;A6 04
	staa	4,x		;A7 04
	eora	4,x		;A8 04
	adca	4,x		;A9 04
	oraa	4,x		;AA 04
	adda	4,x		;AB 04
	cpx	4,x		;AC 04
	jsr	4,x		;AD 04
	lds	4,x		;AE 04
	sts	4,x		;AF 04
	suba	ext		;B0 12 34
	cmpa	ext		;B1 12 34
	sbca	ext		;B2 12 34
				;B3
	anda	ext		;B4 12 34
	bita	ext		;B5 12 34
	ldaa	ext		;B6 12 34
	staa	ext		;B7 12 34
	eora	ext		;B8 12 34
	adca	ext		;B9 12 34
	oraa	ext		;BA 12 34
	adda	ext		;BB 12 34
	cpx	ext		;BC 12 34
	jsr	ext		;BD 12 34
	lds	ext		;BE 12 34
	sts	ext		;BF 12 34


	.page

	subb	#1		;C0 01
	cmpb	#1		;C1 01
	sbcb	#1		;C2 01
				;C3
	andb	#1		;C4 01
	bitb	#1		;C5 01
	ldab	#1		;C6 01
				;C7
	eorb	#1		;C8 01
	adcb	#1		;C9 01
	orab	#1		;CA 01
	addb	#1		;CB 01
				;CC
				;CD
	ldx	#1		;CE 00 01
				;CF
	subb	*dirpag		;D0*12
	cmpb	*dirpag		;D1*12
	sbcb	*dirpag		;D2*12
				;D3
	andb	*dirpag		;D4*12
	bitb	*dirpag		;D5*12
	ldab	*dirpag		;D6*12
	stab	*dirpag		;D7*12
	eorb	*dirpag		;D8*12
	adcb	*dirpag		;D9*12
	orab	*dirpag		;DA*12
	addb	*dirpag		;DB*12
				;DC
				;DD
	ldx	*dirpag		;DE*12
	stx	*dirpag		;DF*12


	.page

	subb	dirpag,x	;E0u12
	cmpb	dirpag,x	;E1u12
	sbcb	dirpag,x	;E2u12
				;E3
	andb	dirpag,x	;E4u12
	bitb	dirpag,x	;E5u12
	ldab	dirpag,x	;E6u12
	stab	dirpag,x	;E7u12
	eorb	dirpag,x	;E8u12
	adcb	dirpag,x	;E9u12
	orab	dirpag,x	;EAu12
	addb	dirpag,x	;EBu12
				;EC
				;ED
	ldx	dirpag,x	;EEu12
	stx	dirpag,x	;EFu12
	subb	ext		;F0 12 34
	cmpb	ext		;F1 12 34
	sbcb	ext		;F2 12 34
				;F3
	andb	ext		;F4 12 34
	bitb	ext		;F5 12 34
	ldab	ext		;F6 12 34
	stab	ext		;F7 12 34
	eorb	ext		;F8 12 34
	adcb	ext		;F9 12 34
	orab	ext		;FA 12 34
	addb	ext		;FB 12 34
				;FC
				;FD
	ldx	ext		;FE 12 34
	stx	ext		;FF 12 34
