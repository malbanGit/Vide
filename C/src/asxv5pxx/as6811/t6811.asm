	.title	AS6811 Assembler Test

	.area	DIRECT

	.blkb	0x33
dir:	.byte	0,0			; 00 00

	ext	=	0x1122
	offset	=	0x0044

	.area	AS6811

	.setdp	0,DIRECT

	aba				; 1B
	abx				; 3A
	aby				; 18 3A

	adca	#0x10			; 89 10
	adca	*dir			; 99*33
	adca	,x			; A9 00
	adca	*dir,x			; A9u33
	adca	offset,x		; A9 44
	adca	,y			; 18 A9 00
	adca	*dir,y			; 18 A9u33
	adca	offset,y		; 18 A9 44
	adca	ext			; B9 11 22

	adcb	#0x10			; C9 10
	adcb	*dir			; D9*33
	adcb	,x			; E9 00
	adcb	*dir,x			; E9u33
	adcb	offset,x		; E9 44
	adcb	,y			; 18 E9 00
	adcb	*dir,y			; 18 E9u33
	adcb	offset,y		; 18 E9 44
	adcb	ext			; F9 11 22

	adc a	#0x10			; 89 10
	adc a	*dir			; 99*33
	adc a	,x			; A9 00
	adc a	*dir,x			; A9u33
	adc a	offset,x		; A9 44
	adc a	,y			; 18 A9 00
	adc a	*dir,y			; 18 A9u33
	adc a	offset,y		; 18 A9 44
	adc a	ext			; B9 11 22

	adc b	#0x10			; C9 10
	adc b	*dir			; D9*33
	adc b	,x			; E9 00
	adc b	*dir,x			; E9u33
	adc b	offset,x		; E9 44
	adc b	,y			; 18 E9 00
	adc b	*dir,y			; 18 E9u33
	adc b	offset,y		; 18 E9 44
	adc b	ext			; F9 11 22

	adda	#0x10			; 8B 10
	adda	*dir			; 9B*33
	adda	,x			; AB 00
	adda	*dir,x			; ABu33
	adda	offset,x		; AB 44
	adda	,y			; 18 AB 00
	adda	*dir,y			; 18 ABu33
	adda	offset,y		; 18 AB 44
	adda	ext			; BB 11 22

	addb	#0x10			; CB 10
	addb	*dir			; DB*33
	addb	,x			; EB 00
	addb	*dir,x			; EBu33
	addb	offset,x		; EB 44
	addb	,y			; 18 EB 00
	addb	*dir,y			; 18 EBu33
	addb	offset,y		; 18 EB 44
	addb	ext			; FB 11 22

	addd	#0x5566			; C3 55 66
	addd	*dir			; D3*33
	addd	,x			; E3 00
	addd	*dir,x			; E3u33
	addd	offset,x		; E3 44
	addd	,y			; 18 E3 00
	addd	*dir,y			; 18 E3u33
	addd	offset,y		; 18 E3 44
	addd	ext			; F3 11 22

	add a	#0x10			; 8B 10
	add a	*dir			; 9B*33
	add a	,x			; AB 00
	add a	*dir,x			; ABu33
	add a	offset,x		; AB 44
	add a	,y			; 18 AB 00
	add a	*dir,y			; 18 ABu33
	add a	offset,y		; 18 AB 44
	add a	ext			; BB 11 22

	add b	#0x10			; CB 10
	add b	*dir			; DB*33
	add b	,x			; EB 00
	add b	*dir,x			; EBu33
	add b	offset,x		; EB 44
	add b	,y			; 18 EB 00
	add b	*dir,y			; 18 EBu33
	add b	offset,y		; 18 EB 44
	add b	ext			; FB 11 22

	add d	#0x5566			; C3 55 66
	add d	*dir			; D3*33
	add d	,x			; E3 00
	add d	*dir,x			; E3u33
	add d	offset,x		; E3 44
	add d	,y			; 18 E3 00
	add d	*dir,y			; 18 E3u33
	add d	offset,y		; 18 E3 44
	add d	ext			; F3 11 22

	anda	#0x10			; 84 10
	anda	*dir			; 94*33
	anda	,x			; A4 00
	anda	*dir,x			; A4u33
	anda	offset,x		; A4 44
	anda	,y			; 18 A4 00
	anda	*dir,y			; 18 A4u33
	anda	offset,y		; 18 A4 44
	anda	ext			; B4 11 22

	andb	#0x10			; C4 10
	andb	*dir			; D4*33
	andb	,x			; E4 00
	andb	*dir,x			; E4u33
	andb	offset,x		; E4 44
	andb	,y			; 18 E4 00
	andb	*dir,y			; 18 E4u33
	andb	offset,y		; 18 E4 44
	andb	ext			; F4 11 22

	and a	#0x10			; 84 10
	and a	*dir			; 94*33
	and a	,x			; A4 00
	and a	*dir,x			; A4u33
	and a	offset,x		; A4 44
	and a	,y			; 18 A4 00
	and a	*dir,y			; 18 A4u33
	and a	offset,y		; 18 A4 44
	and a	ext			; B4 11 22

	and b	#0x10			; C4 10
	and b	*dir			; D4*33
	and b	,x			; E4 00
	and b	*dir,x			; E4u33
	and b	offset,x		; E4 44
	and b	,y			; 18 E4 00
	and b	*dir,y			; 18 E4u33
	and b	offset,y		; 18 E4 44
	and b	ext			; F4 11 22

	asla				; 48
	aslb				; 58
	asld				; 05

	asl a				; 48
	asl b				; 58
	asl d				; 05
	asl	,x			; 68 00
	asl	*dir,x			; 68u33
	asl	offset,x		; 68 44
	asl	,y			; 18 68 00
	asl	*dir,y			; 18 68u33
	asl	offset,y		; 18 68 44
	asl	*dir			; 78s00r33
	asl	ext			; 78 11 22

	asra				; 47
	asrb				; 57

	asr a				; 47
	asr b				; 57
	asr	,x			; 67 00
	asr	*dir,x			; 67u33
	asr	offset,x		; 67 44
	asr	,y			; 18 67 00
	asr	*dir,y			; 18 67u33
	asr	offset,y		; 18 67 44
	asr	*dir			; 77s00r33
	asr	ext			; 77 11 22

	bclr	*dir,	#0x5A		; 15*33 5A
	bclr	*dir,x,	#0x5C		; 1Du33 5C
	bclr  offset,x,	#0x5D		; 1D 44 5D
	bclr	*dir,y,	#0x5C		; 18 1Du33 5C
	bclr  offset,y,	#0x5D		; 18 1D 44 5D

	bita	#0x10			; 85 10
	bita	*dir			; 95*33
	bita	,x			; A5 00
	bita	*dir,x			; A5u33
	bita	offset,x		; A5 44
	bita	,y			; 18 A5 00
	bita	*dir,y			; 18 A5u33
	bita	offset,y		; 18 A5 44
	bita	ext			; B5 11 22

	bitb	#0x10			; C5 10
	bitb	*dir			; D5*33
	bitb	,x			; E5 00
	bitb	*dir,x			; E5u33
	bitb	offset,x		; E5 44
	bitb	,y			; 18 E5 00
	bitb	*dir,y			; 18 E5u33
	bitb	offset,y		; 18 E5 44
	bitb	ext			; F5 11 22

	bit a	#0x10			; 85 10
	bit a	*dir			; 95*33
	bit a	,x			; A5 00
	bit a	*dir,x			; A5u33
	bit a	offset,x		; A5 44
	bit a	,y			; 18 A5 00
	bit a	*dir,y			; 18 A5u33
	bit a	offset,y		; 18 A5 44
	bit a	ext			; B5 11 22

	bit b	#0x10			; C5 10
	bit b	*dir			; D5*33
	bit b	,x			; E5 00
	bit b	*dir,x			; E5u33
	bit b	offset,x		; E5 44
	bit b	,y			; 18 E5 00
	bit b	*dir,y			; 18 E5u33
	bit b	offset,y		; 18 E5 44
	bit b	ext			; F5 11 22

1$:	brclr	*dir, #0x5A, 1$		; 13*33 5A FC
	brclr *dir,x, #0x5C, 1$		; 1Fu33 5C F8
	brclr offset,x,#0x5D,1$		; 1F 44 5D F4
	brclr *dir,y, #0x5C, 1$		; 18 1Fu33 5C EF
	brclr offset,y,#0x5D,1$		; 18 1F 44 5D EA

2$:	brset	*dir, #0x5A, 2$		; 12*33 5A FC
	brset *dir,x, #0x5C, 2$		; 1Eu33 5C F8
	brset offset,x,#0x5D,2$		; 1E 44 5D F4
	brset *dir,y, #0x5C, 2$		; 18 1Eu33 5C EF
	brset offset,y,#0x5D,2$		; 18 1E 44 5D EA

	bra	.			; 20 FE
	brn	.			; 21 FE
	bhi	.			; 22 FE
	bls	.			; 23 FE
	bcc	.			; 24 FE
	bhs	.			; 24 FE
	bcs	.			; 25 FE
	blo	.			; 25 FE
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

	bsr	.			; 8D FE

	bset	*dir,	#0x5A		; 14*33 5A
	bset 	*dir,x,	#0x5C		; 1Cu33 5C
	bset  offset,x,	#0x5D		; 1C 44 5D
	bset 	*dir,y,	#0x5C		; 18 1Cu33 5C
	bset  offset,y,	#0x5D		; 18 1C 44 5D

	cba				; 11

	clc				; 0C

	cli				; 0E

	clra				; 4F
	clrb				; 5F

	clr a				; 4F
	clr b				; 5F
	clr	,x			; 6F 00
	clr	*dir,x			; 6Fu33
	clr	offset,x		; 6F 44
	clr	,y			; 18 6F 00
	clr	*dir,y			; 18 6Fu33
	clr	offset,y		; 18 6F 44
	clr	*dir			; 7Fs00r33
	clr	ext			; 7F 11 22

	clv				; 0A

	cmpa	#0x10			; 81 10
	cmpa	*dir			; 91*33
	cmpa	,x			; A1 00
	cmpa	*dir,x			; A1u33
	cmpa	offset,x		; A1 44
	cmpa	,y			; 18 A1 00
	cmpa	*dir,y			; 18 A1u33
	cmpa	offset,y		; 18 A1 44
	cmpa	ext			; B1 11 22

	cmpb	#0x10			; C1 10
	cmpb	*dir			; D1*33
	cmpb	,x			; E1 00
	cmpb	*dir,x			; E1u33
	cmpb	offset,x		; E1 44
	cmpb	,y			; 18 E1 00
	cmpb	*dir,y			; 18 E1u33
	cmpb	offset,y		; 18 E1 44
	cmpb	ext			; F1 11 22

	cmp a	#0x10			; 81 10
	cmp a	*dir			; 91*33
	cmp a	,x			; A1 00
	cmp a	*dir,x			; A1u33
	cmp a	offset,x		; A1 44
	cmp a	,y			; 18 A1 00
	cmp a	*dir,y			; 18 A1u33
	cmp a	offset,y		; 18 A1 44
	cmp a	ext			; B1 11 22

	cmp b	#0x10			; C1 10
	cmp b	*dir			; D1*33
	cmp b	,x			; E1 00
	cmp b	*dir,x			; E1u33
	cmp b	offset,x		; E1 44
	cmp b	,y			; 18 E1 00
	cmp b	*dir,y			; 18 E1u33
	cmp b	offset,y		; 18 E1 44
	cmp b	ext			; F1 11 22

	coma				; 43
	comb				; 53

	com a				; 43
	com b				; 53
	com	,x			; 63 00
	com	*dir,x			; 63u33
	com	offset,x		; 63 44
	com	,y			; 18 63 00
	com	*dir,y			; 18 63u33
	com	offset,y		; 18 63 44
	com	*dir			; 73s00r33
	com	ext			; 73 11 22

	cpx	#0x5566			; 8C 55 66
	cpx	*dir			; 9C*33
	cpx	,x			; AC 00
	cpx	*dir,x			; ACu33
	cpx	offset,x		; AC 44
	cpx	,y			; CD AC 00
	cpx	*dir,y			; CD ACu33
	cpx	offset,y		; CD AC 44
	cpx	ext			; BC 11 22

	cpy	#0x5566			; 18 8C 55 66
	cpy	*dir			; 18 9C*33
	cpy	,x			; 1A AC 00
	cpy	*dir,x			; 1A ACu33
	cpy	offset,x		; 1A AC 44
	cpy	,y			; 18 AC 00
	cpy	*dir,y			; 18 ACu33
	cpy	offset,y		; 18 AC 44
	cpy	ext			; 18 BC 11 22

	daa				; 19

	deca				; 4A
	decb				; 5A

	dec a				; 4A
	dec b				; 5A
	dec	,x			; 6A 00
	dec	*dir,x			; 6Au33
	dec	offset,x		; 6A 44
	dec	,y			; 18 6A 00
	dec	*dir,y			; 18 6Au33
	dec	offset,y		; 18 6A 44
	dec	*dir			; 7As00r33
	dec	ext			; 7A 11 22

	des				; 34

	dex				; 09
	dey				; 18 09

	eora	#0x10			; 88 10
	eora	*dir			; 98*33
	eora	,x			; A8 00
	eora	*dir,x			; A8u33
	eora	offset,x		; A8 44
	eora	,y			; 18 A8 00
	eora	*dir,y			; 18 A8u33
	eora	offset,y		; 18 A8 44
	eora	ext			; B8 11 22

	eorb	#0x10			; C8 10
	eorb	*dir			; D8*33
	eorb	,x			; E8 00
	eorb	*dir,x			; E8u33
	eorb	offset,x		; E8 44
	eorb	,y			; 18 E8 00
	eorb	*dir,y			; 18 E8u33
	eorb	offset,y		; 18 E8 44
	eorb	ext			; F8 11 22

	eor a	#0x10			; 88 10
	eor a	*dir			; 98*33
	eor a	,x			; A8 00
	eor a	*dir,x			; A8u33
	eor a	offset,x		; A8 44
	eor a	,y			; 18 A8 00
	eor a	*dir,y			; 18 A8u33
	eor a	offset,y		; 18 A8 44
	eor a	ext			; B8 11 22

	eor b	#0x10			; C8 10
	eor b	*dir			; D8*33
	eor b	,x			; E8 00
	eor b	*dir,x			; E8u33
	eor b	offset,x		; E8 44
	eor b	,y			; 18 E8 00
	eor b	*dir,y			; 18 E8u33
	eor b	offset,y		; 18 E8 44
	eor b	ext			; F8 11 22

	fdiv				; 03

	idiv				; 02

	inca				; 4C
	incb				; 5C

	inc a				; 4C
	inc b				; 5C
	inc	,x			; 6C 00
	inc	*dir,x			; 6Cu33
	inc	offset,x		; 6C 44
	inc	,y			; 18 6C 00
	inc	*dir,y			; 18 6Cu33
	inc	offset,y		; 18 6C 44
	inc	*dir			; 7Cs00r33
	inc	ext			; 7C 11 22

	ins				; 31

	inx				; 08
	iny				; 18 08

	jmp	,x			; 6E 00
	jmp	*dir,x			; 6Eu33
	jmp	offset,x		; 6E 44
	jmp	,y			; 18 6E 00
	jmp	*dir,y			; 18 6Eu33
	jmp	offset,y		; 18 6E 44
	jmp	ext			; 7E 11 22

	jsr	*dir			; 9D*33
	jsr	,x			; AD 00
	jsr	*dir,x			; ADu33
	jsr	offset,x		; AD 44
	jsr	,y			; 18 AD 00
	jsr	*dir,y			; 18 ADu33
	jsr	offset,y		; 18 AD 44
	jsr	ext			; BD 11 22

	ldaa	#0x10			; 86 10
	ldaa	*dir			; 96*33
	ldaa	,x			; A6 00
	ldaa	*dir,x			; A6u33
	ldaa	offset,x		; A6 44
	ldaa	,y			; 18 A6 00
	ldaa	*dir,y			; 18 A6u33
	ldaa	offset,y		; 18 A6 44
	ldaa	ext			; B6 11 22

	ldab	#0x10			; C6 10
	ldab	*dir			; D6*33
	ldab	,x			; E6 00
	ldab	*dir,x			; E6u33
	ldab	offset,x		; E6 44
	ldab	,y			; 18 E6 00
	ldab	*dir,y			; 18 E6u33
	ldab	offset,y		; 18 E6 44
	ldab	ext			; F6 11 22

	lda a	#0x10			; 86 10
	lda a	*dir			; 96*33
	lda a	,x			; A6 00
	lda a	*dir,x			; A6u33
	lda a	offset,x		; A6 44
	lda a	,y			; 18 A6 00
	lda a	*dir,y			; 18 A6u33
	lda a	offset,y		; 18 A6 44
	lda a	ext			; B6 11 22

	lda b	#0x10			; C6 10
	lda b	*dir			; D6*33
	lda b	,x			; E6 00
	lda b	*dir,x			; E6u33
	lda b	offset,x		; E6 44
	lda b	,y			; 18 E6 00
	lda b	*dir,y			; 18 E6u33
	lda b	offset,y		; 18 E6 44
	lda b	ext			; F6 11 22

	ldd	#0x5566			; CC 55 66
	ldd	*dir			; DC*33
	ldd	,x			; EC 00
	ldd	*dir,x			; ECu33
	ldd	offset,x		; EC 44
	ldd	,y			; 18 EC 00
	ldd	*dir,y			; 18 ECu33
	ldd	offset,y		; 18 EC 44
	ldd	ext			; FC 11 22

	lds	#0x5566			; 8E 55 66
	lds	*dir			; 9E*33
	lds	,x			; AE 00
	lds	*dir,x			; AEu33
	lds	offset,x		; AE 44
	lds	,y			; 18 AE 00
	lds	*dir,y			; 18 AEu33
	lds	offset,y		; 18 AE 44
	lds	ext			; BE 11 22

	ldx	#0x5566			; CE 55 66
	ldx	*dir			; DE*33
	ldx	,x			; EE 00
	ldx	*dir,x			; EEu33
	ldx	offset,x		; EE 44
	ldx	,y			; CD EE 00
	ldx	*dir,y			; CD EEu33
	ldx	offset,y		; CD EE 44
	ldx	ext			; FE 11 22

	ldy	#0x5566			; 18 CE 55 66
	ldy	*dir			; 18 DE*33
	ldy	,x			; 1A EE 00
	ldy	*dir,x			; 1A EEu33
	ldy	offset,x		; 1A EE 44
	ldy	,y			; 18 EE 00
	ldy	*dir,y			; 18 EEu33
	ldy	offset,y		; 18 EE 44
	ldy	ext			; 18 FE 11 22

	lsla				; 48
	lslb				; 58
	lsld				; 05

	lsl a				; 48
	lsl b				; 58
	lsl d				; 05
	lsl	,x			; 68 00
	lsl	*dir,x			; 68u33
	lsl	offset,x		; 68 44
	lsl	,y			; 18 68 00
	lsl	*dir,y			; 18 68u33
	lsl	offset,y		; 18 68 44
	lsl	*dir			; 78s00r33
	lsl	ext			; 78 11 22

	lsra				; 44
	lsrb				; 54
	lsrd				; 04

	lsr a				; 44
	lsr b				; 54
	lsr d				; 04
	lsr	,x			; 64 00
	lsr	*dir,x			; 64u33
	lsr	offset,x		; 64 44
	lsr	,y			; 18 64 00
	lsr	*dir,y			; 18 64u33
	lsr	offset,y		; 18 64 44
	lsr	*dir			; 74s00r33
	lsr	ext			; 74 11 22

	mul				; 3D

	nega				; 40
	negb				; 50

	neg a				; 40
	neg b				; 50
	neg	,x			; 60 00
	neg	*dir,x			; 60u33
	neg	offset,x		; 60 44
	neg	,y			; 18 60 00
	neg	*dir,y			; 18 60u33
	neg	offset,y		; 18 60 44
	neg	*dir			; 70s00r33
	neg	ext			; 70 11 22

	nop				; 01

	oraa	#0x10			; 8A 10
	oraa	*dir			; 9A*33
	oraa	,x			; AA 00
	oraa	*dir,x			; AAu33
	oraa	offset,x		; AA 44
	oraa	,y			; 18 AA 00
	oraa	*dir,y			; 18 AAu33
	oraa	offset,y		; 18 AA 44
	oraa	ext			; BA 11 22

	orab	#0x10			; CA 10
	orab	*dir			; DA*33
	orab	,x			; EA 00
	orab	*dir,x			; EAu33
	orab	offset,x		; EA 44
	orab	,y			; 18 EA 00
	orab	*dir,y			; 18 EAu33
	orab	offset,y		; 18 EA 44
	orab	ext			; FA 11 22

	ora a	#0x10			; 8A 10
	ora a	*dir			; 9A*33
	ora a	,x			; AA 00
	ora a	*dir,x			; AAu33
	ora a	offset,x		; AA 44
	ora a	,y			; 18 AA 00
	ora a	*dir,y			; 18 AAu33
	ora a	offset,y		; 18 AA 44
	ora a	ext			; BA 11 22

	ora b	#0x10			; CA 10
	ora b	*dir			; DA*33
	ora b	,x			; EA 00
	ora b	*dir,x			; EAu33
	ora b	offset,x		; EA 44
	ora b	,y			; 18 EA 00
	ora b	*dir,y			; 18 EAu33
	ora b	offset,y		; 18 EA 44
	ora b	ext			; FA 11 22

	psha				; 36
	pshb				; 37
	pshx				; 3C
	pshy				; 18 3C

	psh a				; 36
	psh b				; 37
	psh x				; 3C
	psh y				; 18 3C

	pula				; 32
	pulb				; 33
	pulx				; 38
	puly				; 18 38

	pul a				; 32
	pul b				; 33
	pul x				; 38
	pul y				; 18 38

	rola				; 49
	rolb				; 59

	rol a				; 49
	rol b				; 59
	rol	,x			; 69 00
	rol	*dir,x			; 69u33
	rol	offset,x		; 69 44
	rol	,y			; 18 69 00
	rol	*dir,y			; 18 69u33
	rol	offset,y		; 18 69 44
	rol	*dir			; 79s00r33
	rol	ext			; 79 11 22

	rora				; 46
	rorb				; 56

	ror a				; 46
	ror b				; 56
	ror	,x			; 66 00
	ror	*dir,x			; 66u33
	ror	offset,x		; 66 44
	ror	,y			; 18 66 00
	ror	*dir,y			; 18 66u33
	ror	offset,y		; 18 66 44
	ror	*dir			; 76s00r33
	ror	ext			; 76 11 22

	rti				; 3B

	rts				; 39

	sba				; 10

	sbca	#0x10			; 82 10
	sbca	*dir			; 92*33
	sbca	,x			; A2 00
	sbca	*dir,x			; A2u33
	sbca	offset,x		; A2 44
	sbca	,y			; 18 A2 00
	sbca	*dir,y			; 18 A2u33
	sbca	offset,y		; 18 A2 44
	sbca	ext			; B2 11 22

	sbcb	#0x10			; C2 10
	sbcb	*dir			; D2*33
	sbcb	,x			; E2 00
	sbcb	*dir,x			; E2u33
	sbcb	offset,x		; E2 44
	sbcb	,y			; 18 E2 00
	sbcb	*dir,y			; 18 E2u33
	sbcb	offset,y		; 18 E2 44
	sbcb	ext			; F2 11 22

	sbc a	#0x10			; 82 10
	sbc a	*dir			; 92*33
	sbc a	,x			; A2 00
	sbc a	*dir,x			; A2u33
	sbc a	offset,x		; A2 44
	sbc a	,y			; 18 A2 00
	sbc a	*dir,y			; 18 A2u33
	sbc a	offset,y		; 18 A2 44
	sbc a	ext			; B2 11 22

	sbc b	#0x10			; C2 10
	sbc b	*dir			; D2*33
	sbc b	,x			; E2 00
	sbc b	*dir,x			; E2u33
	sbc b	offset,x		; E2 44
	sbc b	,y			; 18 E2 00
	sbc b	*dir,y			; 18 E2u33
	sbc b	offset,y		; 18 E2 44
	sbc b	ext			; F2 11 22

	sec				; 0D

	sei				; 0F

	sev				; 0B

	staa	*dir			; 97*33
	staa	,x			; A7 00
	staa	*dir,x			; A7u33
	staa	offset,x		; A7 44
	staa	,y			; 18 A7 00
	staa	*dir,y			; 18 A7u33
	staa	offset,y		; 18 A7 44
	staa	ext			; B7 11 22

	stab	*dir			; D7*33
	stab	,x			; E7 00
	stab	*dir,x			; E7u33
	stab	offset,x		; E7 44
	stab	,y			; 18 E7 00
	stab	*dir,y			; 18 E7u33
	stab	offset,y		; 18 E7 44
	stab	ext			; F7 11 22

	sta a	*dir			; 97*33
	sta a	,x			; A7 00
	sta a	*dir,x			; A7u33
	sta a	offset,x		; A7 44
	sta a	,y			; 18 A7 00
	sta a	*dir,y			; 18 A7u33
	sta a	offset,y		; 18 A7 44
	sta a	ext			; B7 11 22

	sta b	*dir			; D7*33
	sta b	,x			; E7 00
	sta b	*dir,x			; E7u33
	sta b	offset,x		; E7 44
	sta b	,y			; 18 E7 00
	sta b	*dir,y			; 18 E7u33
	sta b	offset,y		; 18 E7 44
	sta b	ext			; F7 11 22

	std	*dir			; DD*33
	std	,x			; ED 00
	std	*dir,x			; EDu33
	std	offset,x		; ED 44
	std	,y			; 18 ED 00
	std	*dir,y			; 18 EDu33
	std	offset,y		; 18 ED 44
	std	ext			; FD 11 22

	stop				; CF

	sts	*dir			; 9F*33
	sts	,x			; AF 00
	sts	*dir,x			; AFu33
	sts	offset,x		; AF 44
	sts	,y			; 18 AF 00
	sts	*dir,y			; 18 AFu33
	sts	offset,y		; 18 AF 44
	sts	ext			; BF 11 22

	stx	*dir			; DF*33
	stx	,x			; EF 00
	stx	*dir,x			; EFu33
	stx	offset,x		; EF 44
	stx	,y			; CD EF 00
	stx	*dir,y			; CD EFu33
	stx	offset,y		; CD EF 44
	stx	ext			; FF 11 22

	sty	*dir			; 18 DF*33
	sty	,x			; 1A EF 00
	sty	*dir,x			; 1A EFu33
	sty	offset,x		; 1A EF 44
	sty	,y			; 18 EF 00
	sty	*dir,y			; 18 EFu33
	sty	offset,y		; 18 EF 44
	sty	ext			; 18 FF 11 22

	suba	#0x10			; 80 10
	suba	*dir			; 90*33
	suba	,x			; A0 00
	suba	*dir,x			; A0u33
	suba	offset,x		; A0 44
	suba	,y			; 18 A0 00
	suba	*dir,y			; 18 A0u33
	suba	offset,y		; 18 A0 44
	suba	ext			; B0 11 22

	subb	#0x10			; C0 10
	subb	*dir			; D0*33
	subb	,x			; E0 00
	subb	*dir,x			; E0u33
	subb	offset,x		; E0 44
	subb	,y			; 18 E0 00
	subb	*dir,y			; 18 E0u33
	subb	offset,y		; 18 E0 44
	subb	ext			; F0 11 22

	subd	#0x5566			; 83 55 66
	subd	*dir			; 93*33
	subd	,x			; A3 00
	subd	*dir,x			; A3u33
	subd	offset,x		; A3 44
	subd	,y			; 18 A3 00
	subd	*dir,y			; 18 A3u33
	subd	offset,y		; 18 A3 44
	subd	ext			; B3 11 22

	sub a	#0x10			; 80 10
	sub a	*dir			; 90*33
	sub a	,x			; A0 00
	sub a	*dir,x			; A0u33
	sub a	offset,x		; A0 44
	sub a	,y			; 18 A0 00
	sub a	*dir,y			; 18 A0u33
	sub a	offset,y		; 18 A0 44
	sub a	ext			; B0 11 22

	sub b	#0x10			; C0 10
	sub b	*dir			; D0*33
	sub b	,x			; E0 00
	sub b	*dir,x			; E0u33
	sub b	offset,x		; E0 44
	sub b	,y			; 18 E0 00
	sub b	*dir,y			; 18 E0u33
	sub b	offset,y		; 18 E0 44
	sub b	ext			; F0 11 22

	sub d	#0x5566			; 83 55 66
	sub d	*dir			; 93*33
	sub d	,x			; A3 00
	sub d	*dir,x			; A3u33
	sub d	offset,x		; A3 44
	sub d	,y			; 18 A3 00
	sub d	*dir,y			; 18 A3u33
	sub d	offset,y		; 18 A3 44
	sub d	ext			; B3 11 22

	swi				; 3F

	tab				; 16

	tap				; 06

	tba				; 17

	tpa				; 07

	tsta				; 4D
	tstb				; 5D

	tst a				; 4D
	tst b				; 5D
	tst	,x			; 6D 00
	tst	*dir,x			; 6Du33
	tst	offset,x		; 6D 44
	tst	,y			; 18 6D 00
	tst	*dir,y			; 18 6Du33
	tst	offset,y		; 18 6D 44
	tst	*dir			; 7Ds00r33
	tst	ext			; 7D 11 22

	tsx				; 30

	txs				; 35

	wai				; 3E

	xgdx				; 8F
	xgdy				; 18 8F

