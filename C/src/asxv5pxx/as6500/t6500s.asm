	.title t6500s.asm
	
	;Sequential Instruction Code Test
	
	.r65c02
	
	idx   == $$83
	value == $$85
	ext   == $$C789
	dir   == $$AB
	
	brk			;00
	ora	[idx,x]		;01 83
				;02
				;03
	tsb	*dir		;04 AB
	ora	*dir		;05 AB
	asl	*dir		;06 AB
	rmb0	*dir		;07 AB
	php			;08
	ora	#value		;09 85
	asl			;0A
				;0B
	tsb	ext		;0C 89 C7
	ora	ext		;0D 89 C7
	asl	ext		;0E 89 C7
	bbr0	*dir,.		;0F AB FD

	bpl	.		;10 FE
	ora	[idx],y		;11 83
	ora	[idx]		;12 83
				;13
	trb	*dir		;14 AB
	ora	*dir,x		;15 AB
	asl	*dir,x		;16 AB
	rmb1	*dir		;17 AB
	clc			;18
	ora	ext,y		;19 89 C7
	inc			;1A
				;1B
	trb	ext		;1C 89 C7
	ora	ext,x		;1D 89 C7
	asl	ext,x		;1E 89 C7
	bbr1	*dir,.		;1F AB FD

	jsr	ext		;20 89 C7
	and	[idx,x]		;21 83
				;22
				;23
	bit	*dir		;24 AB
	and	*dir		;25 AB
	rol	*dir		;26 AB
	rmb2	*dir		;27 AB
	plp			;28
	and	#value		;29 85
	rol			;2A
				;2B
	bit	ext		;2C 89 C7
	and	ext		;2D 89 C7
	rol	ext		;2E 89 C7
	bbr2	*dir,.		;2F AB FD
	
	bmi	.		;30 FE
	and	[idx],y		;31 83
	and	[idx]		;32 83
				;33
	bit	*dir,x		;34 AB
	and	*dir,x		;35 AB
	rol	*dir,x		;36 AB
	rmb3	*dir		;37 AB
	sec			;38
	and	ext,y		;39 89 C7
	dec			;3A
				;3B
	bit	ext,x		;3C 89 C7
	and	ext,x		;3D 89 C7
	rol	ext,x		;3E 89 C7
	bbr3	*dir,.		;3F AB FD

	rti			;40
	eor	[idx,x]		;41 83
				;42
				;43
				;44
	eor	*dir		;45 AB
	lsr	*dir		;46 AB
	rmb4	*dir		;47 AB
	pha			;48
	eor	#value		;49 85
	lsr			;4A
				;4B
	jmp	ext		;4C 89 C7
	eor	ext		;4D 89 C7
	lsr	ext		;4E 89 C7
	bbr4	*dir,.		;4F AB FD
	
	bvc	.		;50 FE
	eor	[idx],y		;51 83
	eor	[idx]		;52 83
				;53
				;54
	eor	*dir,x		;55 AB
	lsr	*dir,x		;56 AB
	rmb5	*dir		;57 AB
	cli			;58
	eor	ext,y		;59 89 C7
	phy			;5A
				;5B
				;5C
	eor	ext,x		;5D 89 C7
	lsr	ext,x		;5E 89 C7
	bbr5	*dir,.		;5F AB FD

	rts			;60
	adc	[idx,x]		;61 83
				;62
				;63
	stz	*dir		;64 AB
	adc	*dir		;65 AB
	ror	*dir		;66 AB
	rmb6	*dir		;67 AB
	pla			;68
	adc	#value		;69 85
	ror			;6A
				;6B
	jmp	[ext]		;6C 89 C7
	adc	ext		;6D 89 C7
	ror	ext		;6E 89 C7
	bbr6	*dir,.		;6F AB FD
	
	bvs	.		;70 FE
	adc	[idx],y		;71 83
	adc	[idx]		;72 83
				;73
	stz	*dir,x		;74 AB
	adc	*dir,x		;75 AB
	ror	*dir,x		;76 AB
	rmb7	*dir		;77 AB
	sei			;78
	adc	ext,y		;79 89 C7
	ply			;7A
				;7B
	jmp	[ext,x]		;7C 89 C7
	adc	ext,x		;7D 89 C7
	ror	ext,x		;7E 89 C7
	bbr7	*dir,.		;7F AB FD

	bra	.		;80 FE
	sta	[idx,x]		;81 83
				;82
				;83
	sty	*dir		;84 AB
	sta	*dir		;85 AB
	stx	*dir		;86 AB
	smb0	*dir		;87 AB
	dey			;88
	bit	#value		;89 85
	txa			;8A
				;8B
	sty	ext		;8C 89 C7
	sta	ext		;8D 89 C7
	stx	ext		;8E 89 C7
	bbs0	*dir,.		;8F AB FD
	
	bcc	.		;90 FE
	sta	[idx],y		;91 83
	sta	[idx]		;92 83
				;93
	sty	*dir,x		;94 AB
	sta	*dir,x		;95 AB
	stx	*dir,y		;96 AB
	smb1	*dir		;97 AB
	tya			;98
	sta	ext,y		;99 89 C7
	txs			;9A
				;9B
	stz	ext		;9C 89 C7
	sta	ext,x		;9D 89 C7
	stz	ext,x		;9E 89 C7
	bbs1	*dir,.		;9F AB FD

	ldy	#value		;A0 85
	lda	[idx,x]		;A1 83
	ldx	#value		;A2 85
				;A3
	ldy	*dir		;A4 AB
	lda	*dir		;A5 AB
	ldx	*dir		;A6 AB
	smb2	*dir		;A7 AB
	tay			;A8
	lda	#value		;A9 85
	tax			;AA
				;AB
	ldy	ext		;AC 89 C7
	lda	ext		;AD 89 C7
	ldx	ext		;AE 89 C7
	bbs2	*dir,.		;AF AB FD
	
	bcs	.		;B0 FE
	lda	[idx],y		;B1 83
	lda	[idx]		;B2 83
				;B3
	ldy	*dir,x		;B4 AB
	lda	*dir,x		;B5 AB
	ldx	*dir,y		;B6 AB
	smb3	*dir		;B7 AB
	clv			;B8
	lda	ext,y		;B9 89 C7
	tsx			;BA
				;BB
	ldy	ext,x		;BC 89 C7
	lda	ext,x		;BD 89 C7
	ldx	ext,y		;BE 89 C7
	bbs3	*dir,.		;BF AB FD

	cpy	#value		;C0 85
	cmp	[idx,x]		;C1 83
				;C2
				;C3
	cpy	*dir		;C4 AB
	cmp	*dir		;C5 AB
	dec	*dir		;C6 AB
	smb4	*dir		;C7 AB
	iny			;C8
	cmp	#value		;C9 85
	dex			;CA
				;CB
	cpy	ext		;CC 89 C7
	cmp	ext		;CD 89 C7
	dec	ext		;CE 89 C7
	bbs4	*dir,.		;CF AB FD
	
	bne	.		;D0 FE
	cmp	[idx],y		;D1 83
	cmp	[idx]		;D2 83
				;D3
				;D4
	cmp	*dir,x		;D5 AB
	dec	*dir,x		;D6 AB
	smb5	*dir		;D7 AB
	cld			;D8
	cmp	ext,y		;D9 89 C7
	phx			;DA
				;DB
				;DC
	cmp	ext,x		;DD 89 C7
	dec	ext,x		;DE 89 C7
	bbs5	*dir,.		;DF AB FD

	cpx	#value		;E0 85
	sbc	[idx,x]		;E1 83
				;E2
				;E3
	cpx	*dir		;E4 AB
	sbc	*dir		;E5 AB
	inc	*dir		;E6 AB
	smb6	*dir		;E7 AB
	inx			;E8
	sbc	#value		;E9 85
	nop			;EA
				;EB
	cpx	ext		;EC 89 C7
	sbc	ext		;ED 89 C7
	inc	ext		;EE 89 C7
	bbs6	*dir,.		;EF AB FD
	
	beq	.		;F0 FE
	sbc	[idx],y		;F1 83
	sbc	[idx]		;F2 83
				;F3
				;F4
	sbc	*dir,x		;F5 AB
	inc	*dir,x		;F6 AB
	smb7	*dir		;F7 AB
	sed			;F8
	sbc	ext,y		;F9 89 C7
	plx			;FA
				;FB
				;FC
	sbc	ext,x		;FD 89 C7
	inc	ext,x		;FE 89 C7
	bbs7	*dir,.		;FF AB FD

