	.title	6800 Assembler Test

	dir	=	0x0033
	ext	=	0x1122
	offset	=	0x0044

	aba			;1B

	adca	#0x10		;89 10
	adca	*dir		;99 33
	adca	,x		;A9 00
	adca	offset,x	;A9 44
	adca	ext		;B9 11 22

	adcb	#0x10		;C9 10
	adcb	*dir		;D9 33
	adcb	,x		;E9 00
	adcb	offset,x	;E9 44
	adcb	ext		;F9 11 22

	adc a	#0x10		;89 10
	adc a	*dir		;99 33
	adc a	,x		;A9 00
	adc a	offset,x	;A9 44
	adc a	ext		;B9 11 22

	adc b	#0x10		;C9 10
	adc b	*dir		;D9 33
	adc b	,x		;E9 00
	adc b	offset,x	;E9 44
	adc b	ext		;F9 11 22

	adda	#0x10		;8B 10
	adda	*dir		;9B 33
	adda	,x		;AB 00
	adda	offset,x	;AB 44
	adda	ext		;BB 11 22

	addb	#0x10		;CB 10
	addb	*dir		;DB 33
	addb	,x		;EB 00
	addb	offset,x	;EB 44
	addb	ext		;FB 11 22

	add a	#0x10		;8B 10
	add a	*dir		;9B 33
	add a	,x		;AB 00
	add a	offset,x	;AB 44
	add a	ext		;BB 11 22

	add b	#0x10		;CB 10
	add b	*dir		;DB 33
	add b	,x		;EB 00
	add b	offset,x	;EB 44
	add b	ext		;FB 11 22

	anda	#0x10		;84 10
	anda	*dir		;94 33
	anda	,x		;A4 00
	anda	offset,x	;A4 44
	anda	ext		;B4 11 22

	andb	#0x10		;C4 10
	andb	*dir		;D4 33
	andb	,x		;E4 00
	andb	offset,x	;E4 44
	andb	ext		;F4 11 22

	and a	#0x10		;84 10
	and a	*dir		;94 33
	and a	,x		;A4 00
	and a	offset,x	;A4 44
	and a	ext		;B4 11 22

	and b	#0x10		;C4 10
	and b	*dir		;D4 33
	and b	,x		;E4 00
	and b	offset,x	;E4 44
	and b	ext		;F4 11 22

	asla			;48
	aslb			;58

	asl a			;48
	asl b			;58
	asl	,x		;68 00
	asl	offset,x	;68 44
	asl	ext		;78 11 22

	asra			;47
	asrb			;57

	asr a			;47
	asr b			;57
	asr	,x		;67 00
	asr	offset,x	;67 44
	asr	ext		;77 11 22

	bita	#0x10		;85 10
	bita	*dir		;95 33
	bita	,x		;A5 00
	bita	offset,x	;A5 44
	bita	ext		;B5 11 22

	bitb	#0x10		;C5 10
	bitb	*dir		;D5 33
	bitb	,x		;E5 00
	bitb	offset,x	;E5 44
	bitb	ext		;F5 11 22

	bit a	#0x10		;85 10
	bit a	*dir		;95 33
	bit a	,x		;A5 00
	bit a	offset,x	;A5 44
	bit a	ext		;B5 11 22

	bit b	#0x10		;C5 10
	bit b	*dir		;D5 33
	bit b	,x		;E5 00
	bit b	offset,x	;E5 44
	bit b	ext		;F5 11 22

	bra	.		;20 FE
	bhi	.		;22 FE
	bls	.		;23 FE
	bcc	.		;24 FE
	bhs	.		;24 FE
	bcs	.		;25 FE
	blo	.		;25 FE
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

	bsr	.		;8D FE

	cba			;11

	clc			;0C

	cli			;0E

	clra			;4F
	clrb			;5F

	clr a			;4F
	clr b			;5F
	clr	,x		;6F 00
	clr	offset,x	;6F 44
	clr	ext		;7F 11 22

	clv			;0A

	cmpa	#0x10		;81 10
	cmpa	*dir		;91 33
	cmpa	,x		;A1 00
	cmpa	offset,x	;A1 44
	cmpa	ext		;B1 11 22

	cmpb	#0x10		;C1 10
	cmpb	*dir		;D1 33
	cmpb	,x		;E1 00
	cmpb	offset,x	;E1 44
	cmpb	ext		;F1 11 22

	cmp a	#0x10		;81 10
	cmp a	*dir		;91 33
	cmp a	,x		;A1 00
	cmp a	offset,x	;A1 44
	cmp a	ext		;B1 11 22

	cmp b	#0x10		;C1 10
	cmp b	*dir		;D1 33
	cmp b	,x		;E1 00
	cmp b	offset,x	;E1 44
	cmp b	ext		;F1 11 22

	coma			;43
	comb			;53

	com a			;43
	com b			;53
	com	,x		;63 00
	com	offset,x	;63 44
	com	ext		;73 11 22

	cpx	#0x5566		;8C 55 66
	cpx	*dir		;9C 33
	cpx	,x		;AC 00
	cpx	offset,x	;AC 44
	cpx	ext		;BC 11 22

	daa			;19

	deca			;4A
	decb			;5A

	dec a			;4A
	dec b			;5A
	dec	,x		;6A 00
	dec	offset,x	;6A 44
	dec	ext		;7A 11 22

	des			;34

	dex			;09

	eora	#0x10		;88 10
	eora	*dir		;98 33
	eora	,x		;A8 00
	eora	offset,x	;A8 44
	eora	ext		;B8 11 22

	eorb	#0x10		;C8 10
	eorb	*dir		;D8 33
	eorb	,x		;E8 00
	eorb	offset,x	;E8 44
	eorb	ext		;F8 11 22

	eor a	#0x10		;88 10
	eor a	*dir		;98 33
	eor a	,x		;A8 00
	eor a	offset,x	;A8 44
	eor a	ext		;B8 11 22

	eor b	#0x10		;C8 10
	eor b	*dir		;D8 33
	eor b	,x		;E8 00
	eor b	offset,x	;E8 44
	eor b	ext		;F8 11 22

	inca			;4C
	incb			;5C

	inc a			;4C
	inc b			;5C
	inc	,x		;6C 00
	inc	offset,x	;6C 44
	inc	ext		;7C 11 22

	ins			;31

	inx			;08

	jmp	,x		;6E 00
	jmp	offset,x	;6E 44
	jmp	ext		;7E 11 22

	jsr	,x		;AD 00
	jsr	offset,x	;AD 44
	jsr	ext		;BD 11 22

	ldaa	#0x10		;86 10
	ldaa	*dir		;96 33
	ldaa	,x		;A6 00
	ldaa	offset,x	;A6 44
	ldaa	ext		;B6 11 22

	ldab	#0x10		;C6 10
	ldab	*dir		;D6 33
	ldab	,x		;E6 00
	ldab	offset,x	;E6 44
	ldab	ext		;F6 11 22

	lda a	#0x10		;86 10
	lda a	*dir		;96 33
	lda a	,x		;A6 00
	lda a	offset,x	;A6 44
	lda a	ext		;B6 11 22

	lda b	#0x10		;C6 10
	lda b	*dir		;D6 33
	lda b	,x		;E6 00
	lda b	offset,x	;E6 44
	lda b	ext		;F6 11 22

	lds	#0x5566		;8E 55 66
	lds	*dir		;9E 33
	lds	,x		;AE 00
	lds	offset,x	;AE 44
	lds	ext		;BE 11 22

	ldx	#0x5566		;CE 55 66
	ldx	*dir		;DE 33
	ldx	,x		;EE 00
	ldx	offset,x	;EE 44
	ldx	ext		;FE 11 22

	lsla			;48
	lslb			;58

	lsl a			;48
	lsl b			;58
	lsl	,x		;68 00
	lsl	offset,x	;68 44
	lsl	ext		;78 11 22

	lsra			;44
	lsrb			;54

	lsr a			;44
	lsr b			;54
	lsr	,x		;64 00
	lsr	offset,x	;64 44
	lsr	ext		;74 11 22

	nega			;40
	negb			;50

	neg a			;40
	neg b			;50
	neg	,x		;60 00
	neg	offset,x	;60 44
	neg	ext		;70 11 22

	nop			;01

	oraa	#0x10		;8A 10
	oraa	*dir		;9A 33
	oraa	,x		;AA 00
	oraa	offset,x	;AA 44
	oraa	ext		;BA 11 22

	orab	#0x10		;CA 10
	orab	*dir		;DA 33
	orab	,x		;EA 00
	orab	offset,x	;EA 44
	orab	ext		;FA 11 22

	ora a	#0x10		;8A 10
	ora a	*dir		;9A 33
	ora a	,x		;AA 00
	ora a	offset,x	;AA 44
	ora a	ext		;BA 11 22

	ora b	#0x10		;CA 10
	ora b	*dir		;DA 33
	ora b	,x		;EA 00
	ora b	offset,x	;EA 44
	ora b	ext		;FA 11 22

	psha			;36
	pshb			;37

	psh a			;36
	psh b			;37

	pula			;32
	pulb			;33

	pul a			;32
	pul b			;33

	rola			;49
	rolb			;59

	rol a			;49
	rol b			;59
	rol	,x		;69 00
	rol	offset,x	;69 44
	rol	ext		;79 11 22

	rora			;46
	rorb			;56

	ror a			;46
	ror b			;56
	ror	,x		;66 00
	ror	offset,x	;66 44
	ror	ext		;76 11 22

	rti			;3B

	rts			;39

	sba			;10

	sbca	#0x10		;82 10
	sbca	*dir		;92 33
	sbca	,x		;A2 00
	sbca	offset,x	;A2 44
	sbca	ext		;B2 11 22

	sbcb	#0x10		;C2 10
	sbcb	*dir		;D2 33
	sbcb	,x		;E2 00
	sbcb	offset,x	;E2 44
	sbcb	ext		;F2 11 22

	sbc a	#0x10		;82 10
	sbc a	*dir		;92 33
	sbc a	,x		;A2 00
	sbc a	offset,x	;A2 44
	sbc a	ext		;B2 11 22

	sbc b	#0x10		;C2 10
	sbc b	*dir		;D2 33
	sbc b	,x		;E2 00
	sbc b	offset,x	;E2 44
	sbc b	ext		;F2 11 22

	sec			;0D

	sei			;0F

	sev			;0B

	staa	*dir		;97 33
	staa	,x		;A7 00
	staa	offset,x	;A7 44
	staa	ext		;B7 11 22

	stab	*dir		;D7 33
	stab	,x		;E7 00
	stab	offset,x	;E7 44
	stab	ext		;F7 11 22

	sta a	*dir		;97 33
	sta a	,x		;A7 00
	sta a	offset,x	;A7 44
	sta a	ext		;B7 11 22

	sta b	*dir		;D7 33
	sta b	,x		;E7 00
	sta b	offset,x	;E7 44
	sta b	ext		;F7 11 22

	sts	*dir		;9F 33
	sts	,x		;AF 00
	sts	offset,x	;AF 44
	sts	ext		;BF 11 22

	stx	*dir		;DF 33
	stx	,x		;EF 00
	stx	offset,x	;EF 44
	stx	ext		;FF 11 22

	suba	#0x10		;80 10
	suba	*dir		;90 33
	suba	,x		;A0 00
	suba	offset,x	;A0 44
	suba	ext		;B0 11 22

	subb	#0x10		;C0 10
	subb	*dir		;D0 33
	subb	,x		;E0 00
	subb	offset,x	;E0 44
	subb	ext		;F0 11 22

	sub a	#0x10		;80 10
	sub a	*dir		;90 33
	sub a	,x		;A0 00
	sub a	offset,x	;A0 44
	sub a	ext		;B0 11 22

	sub b	#0x10		;C0 10
	sub b	*dir		;D0 33
	sub b	,x		;E0 00
	sub b	offset,x	;E0 44
	sub b	ext		;F0 11 22

	swi			;3F

	tab			;16

	tap			;06

	tba			;17

	tpa			;07

	tsta			;4D
	tstb			;5D

	tst a			;4D
	tst b			;5D
	tst	,x		;6D 00
	tst	offset,x	;6D 44
	tst	ext		;7D 11 22

	tsx			;30

	txs			;35

	wai			;3E

