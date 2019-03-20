	.title	68HC12 Assembler Test

	.sbttl	All 6812 Instructions

	aba			;18 06
	abx			;1A E5
	aby			;19 ED
	adca	#0x01		;89 01
	adcb	*0x02		;D9*02
	adda	#0x03		;8B 03
	addb	*0x04		;DB*04
	addd	#0x05		;C3 00 05
	anda	*0x06		;94*06
	andb	#0x07		;C4 07
	andcc	#0x08		;10 08
	asl	0,x		;68 00
	asla			;48
	aslb			;58
	asld			;59
	asr	1,x		;67 01
	asra			;47
	asrb			;57
	bcc	.+0x12		;24 10
	bclr	*0xFF,#0xFE	;4D*FF FE
	bcs	.+0x12		;25 10
	beq	.+0x12		;27 10
	bge	.+0x12		;2C 10
	bgnd			;00
	bgt	.+0x12		;2E 10
	bhi	.+0x12		;22 10
	bhis	.+0x12		;24 10
	bhs	.+0x12		;24 10
	bita	#0x09		;85 09
	bitb	*0x0a		;D5*0A
	ble	.+0x12		;2F 10
	blo	.+0x12		;25 10
	blos	.+0x12		;23 10
	bls	.+0x12		;23 10
	blt	.+0x12		;2D 10
	bmi	.+0x12		;2B 10
	bne	.+0x12		;26 10
	bpl	.+0x12		;2A 10
	bra	.+0x12		;20 10
	brclr	*0xFD,#0xFC,.+0x12	;4F*FD FC 0E
	brn	.+0x12		;21 10
	brset	*0xFB,#0xFA,.+0x12	;4E*FB FA 0E
	bset	*0xF9,#0xF8	;4C*F9 F8
	bsr	.+0x12		;07 10
	bvc	.+0x12		;28 10
	bvs	.+0x12		;29 10
	call	0x8000,#0x34	;4A 80 00 34
	cba			;18 17
	clc			;10 FE
	cli			;10 EF
	clr	,x		;69 00
	clra			;87
	clrb			;C7
	clv			;10 FD
	cmpa	#0x0b		;81 0B
	cmpb	*0x0c		;D1*0C
	cmpd	#0x0d		;8C 00 0D
	cmps	*0x0e		;9F*0E
	cmpx	#0x10		;8E 00 10
	cmpy	*0x11		;9D*11
	com	,x		;61 00
	coma			;41
	comb			;51
	cpd	#0x0d		;8C 00 0D
	cps	*0x0e		;9F*0E
	cpx	#0x10		;8E 00 10
	cpy	*0x11		;9D*11
	daa			;18 07
	dbeq	a,.+0x100	;04 00 FD
	dbne	b,.+0x100	;04 21 FD
	dec	,x		;63 00
	deca			;43
	decb			;53
	des			;1B 9F
	dex			;09
	dey			;03
	ediv			;11
	edivs			;18 14
	emacs	0x5678		;18 12 56 78
	emaxd	0,x		;18 1A 00
	emaxm	1,x		;18 1E 01
	emind	2,x		;18 1B 02
	eminm	3,x		;18 1F 03
	emul			;13
	emuls			;18 13
	eora	#0x13		;88 13
	eorb	*0x14		;D8*14
	etbl	5,x		;18 3F 05
	exg	a,b		;B7 81
	fdiv			;18 11
	ibeq	a,.+3		;04 80 00
	ibne	b,.+3		;04 A1 00
	idiv			;18 10
	idivs			;18 15
	inc	,x		;62 00
	inca			;42
	incb			;52
	ins			;1B 81
	inx			;08
	iny			;02
	jmp	0x1234		;06 12 34
	jsr	2,x		;15 02
	lbcc	.+0x14		;18 24 00 10
	lbcs	.+0x14		;18 25 00 10
	lbeq	.+0x14		;18 27 00 10
	lbge	.+0x14		;18 2C 00 10
	lbgt	.+0x14		;18 2E 00 10
	lbhi	.+0x14		;18 22 00 10
	lbhis	.+0x14		;18 24 00 10
	lbhs	.+0x14		;18 24 00 10
	lble	.+0x14		;18 2F 00 10
	lblo	.+0x14		;18 25 00 10
	lblos	.+0x14		;18 23 00 10
	lbls	.+0x14		;18 23 00 10
	lblt	.+0x14		;18 2D 00 10
	lbmi	.+0x14		;18 2B 00 10
	lbne	.+0x14		;18 26 00 10
	lbpl	.+0x14		;18 2A 00 10
	lbra	.+0x14		;18 20 00 10
	lbrn	.+0x14		;18 21 00 10
	lbvc	.+0x14		;18 28 00 10
	lbvs	.+0x14		;18 29 00 10
	lda	#0x15		;86 15
	ldaa	*0x16		;96*16
	ldb	#0x17		;C6 17
	ldab	*0x18		;D6*18
	ldd	#0x19		;CC 00 19
	lds	*0x1a		;DF*1A
	ldx	#0x1c		;CE 00 1C
	ldy	*0x1d		;DD*1D
	leas	-1,s		;1B 9F
	leax	-1,x		;1A 1F
	leay	-1,y		;19 5F
	lsl	,x		;68 00
	lsla			;48
	lslb			;58
	lsld			;59
	lsr	,x		;64 00
	lsra			;44
	lsrb			;54
	lsrd			;49
	maxa	0,x		;18 18 00
	maxm	1,x		;18 1C 01
	mem			;01
	mina	2,x		;18 19 02
	minm	3,x		;18 1D 03
	movb	#0x80,0x1234	;18 0B 80 12 34
	movw	#0x8000,0x1234	;18 03 80 00 12 34
	mul			;12
	neg	,x		;60 00
	nega			;40
	negb			;50
	nop			;A7
	ora	*0x1e		;9A*1E
	oraa	#0x1f		;8A 1F
	orb	*0x20		;DA*20
	orab	#0x21		;CA 21
	orcc	#0x22		;14 22
	psha			;36
	pshb			;37
	pshc			;39
	pshd			;3B
	pshx			;34
	pshy			;35
	pula			;32
	pulb			;33
	pulc			;38
	puld			;3A
	pulx			;30
	puly			;31
	rev			;18 3A
	revw			;18 3B
	rol	,x		;65 00
	rola			;45
	rolb			;55
	ror	,x		;66 00
	rora			;46
	rorb			;56
	rtc			;0A
	rti			;0B
	rts			;3D
	sba			;18 16
	sbca	#0x23		;82 23
	sbcb	*0x24		;D2*24
	sec			;14 01
	sei			;14 10
	sev			;14 02
	sex	a,d		;B7 04
	sta	,x		;6A 00
	staa	,x		;6A 00
	stab	,x		;6B 00
	stb	,x		;6B 00
	std	,x		;6C 00
	stop			;18 3E
	sts	,x		;6F 00
	stx	,x		;6E 00
	sty	,x		;6D 00
	suba	#0x25		;80 25
	subb	*0x26		;D0*26
	subd	#0x27		;83 00 27
	swi			;3F
	tab			;18 0E
	tap			;B7 02
	tba			;18 0F
	tbeq	d,.+0x100	;04 44 FD
	tbl	,x		;18 3D 00
	tbne	x,.+0x100	;04 65 FD
	tfr	x,y		;B7 56
	tpa			;B7 20
	trap	#0x40		;18 40
	tst	,x		;E7 00
	tsta			;97
	tstb			;D7
	tsx			;B7 75
	tsy			;B7 76
	txs			;B7 57
	tys			;B7 67
	wai			;3E
	wav			;18 3C
	xgdx			;B7 C5
	xgdy			;B7 C6


	.page
	.sbttl	Post Byte Addressing Test (numerical constants)

	; All Indexed Addressing Modes

	neg	0,x		;60 00
	neg	1,x		;60 01
	neg	2,x		;60 02
	neg	3,x		;60 03
	neg	4,x		;60 04
	neg	5,x		;60 05
	neg	6,x		;60 06
	neg	7,x		;60 07
	neg	8,x		;60 08
	neg	9,x		;60 09
	neg	10,x		;60 0A
	neg	11,x		;60 0B
	neg	12,x		;60 0C
	neg	13,x		;60 0D
	neg	14,x		;60 0E
	neg	15,x		;60 0F
	neg	-16,x		;60 10
	neg	-15,x		;60 11
	neg	-14,x		;60 12
	neg	-13,x		;60 13
	neg	-12,x		;60 14
	neg	-11,x		;60 15
	neg	-10,x		;60 16
	neg	-9,x		;60 17
	neg	-8,x		;60 18
	neg	-7,x		;60 19
	neg	-6,x		;60 1A
	neg	-5,x		;60 1B
	neg	-4,x		;60 1C
	neg	-3,x		;60 1D
	neg	-2,x		;60 1E
	neg	-1,x		;60 1F

	neg	1,+x		;60 20
	neg	2,+x		;60 21
	neg	3,+x		;60 22
	neg	4,+x		;60 23
	neg	5,+x		;60 24
	neg	6,+x		;60 25
	neg	7,+x		;60 26
	neg	8,+x		;60 27
	neg	8,-x		;60 28
	neg	7,-x		;60 29
	neg	6,-x		;60 2A
	neg	5,-x		;60 2B
	neg	4,-x		;60 2C
	neg	3,-x		;60 2D
	neg	2,-x		;60 2E
	neg	1,-x		;60 2F
	neg	1,x+		;60 30
	neg	2,x+		;60 31
	neg	3,x+		;60 32
	neg	4,x+		;60 33
	neg	5,x+		;60 34
	neg	6,x+		;60 35
	neg	7,x+		;60 36
	neg	8,x+		;60 37
	neg	8,x-		;60 38
	neg	7,x-		;60 39
	neg	6,x-		;60 3A
	neg	5,x-		;60 3B
	neg	4,x-		;60 3C
	neg	3,x-		;60 3D
	neg	2,x-		;60 3E
	neg	1,x-		;60 3F

	neg	0,y		;60 40
	neg	1,y		;60 41
	neg	2,y		;60 42
	neg	3,y		;60 43
	neg	4,y		;60 44
	neg	5,y		;60 45
	neg	6,y		;60 46
	neg	7,y		;60 47
	neg	8,y		;60 48
	neg	9,y		;60 49
	neg	10,y		;60 4A
	neg	11,y		;60 4B
	neg	12,y		;60 4C
	neg	13,y		;60 4D
	neg	14,y		;60 4E
	neg	15,y		;60 4F
	neg	-16,y		;60 50
	neg	-15,y		;60 51
	neg	-14,y		;60 52
	neg	-13,y		;60 53
	neg	-12,y		;60 54
	neg	-11,y		;60 55
	neg	-10,y		;60 56
	neg	-9,y		;60 57
	neg	-8,y		;60 58
	neg	-7,y		;60 59
	neg	-6,y		;60 5A
	neg	-5,y		;60 5B
	neg	-4,y		;60 5C
	neg	-3,y		;60 5D
	neg	-2,y		;60 5E
	neg	-1,y		;60 5F

	neg	1,+y		;60 60
	neg	2,+y		;60 61
	neg	3,+y		;60 62
	neg	4,+y		;60 63
	neg	5,+y		;60 64
	neg	6,+y		;60 65
	neg	7,+y		;60 66
	neg	8,+y		;60 67
	neg	8,-y		;60 68
	neg	7,-y		;60 69
	neg	6,-y		;60 6A
	neg	5,-y		;60 6B
	neg	4,-y		;60 6C
	neg	3,-y		;60 6D
	neg	2,-y		;60 6E
	neg	1,-y		;60 6F
	neg	1,y+		;60 70
	neg	2,y+		;60 71
	neg	3,y+		;60 72
	neg	4,y+		;60 73
	neg	5,y+		;60 74
	neg	6,y+		;60 75
	neg	7,y+		;60 76
	neg	8,y+		;60 77
	neg	8,y-		;60 78
	neg	7,y-		;60 79
	neg	6,y-		;60 7A
	neg	5,y-		;60 7B
	neg	4,y-		;60 7C
	neg	3,y-		;60 7D
	neg	2,y-		;60 7E
	neg	1,y-		;60 7F

	neg	0,sp		;60 80
	neg	1,sp		;60 81
	neg	2,sp		;60 82
	neg	3,sp		;60 83
	neg	4,sp		;60 84
	neg	5,sp		;60 85
	neg	6,sp		;60 86
	neg	7,sp		;60 87
	neg	8,sp		;60 88
	neg	9,sp		;60 89
	neg	10,sp		;60 8A
	neg	11,sp		;60 8B
	neg	12,sp		;60 8C
	neg	13,sp		;60 8D
	neg	14,sp		;60 8E
	neg	15,sp		;60 8F
	neg	-16,sp		;60 90
	neg	-15,sp		;60 91
	neg	-14,sp		;60 92
	neg	-13,sp		;60 93
	neg	-12,sp		;60 94
	neg	-11,sp		;60 95
	neg	-10,sp		;60 96
	neg	-9,sp		;60 97
	neg	-8,sp		;60 98
	neg	-7,sp		;60 99
	neg	-6,sp		;60 9A
	neg	-5,sp		;60 9B
	neg	-4,sp		;60 9C
	neg	-3,sp		;60 9D
	neg	-2,sp		;60 9E
	neg	-1,sp		;60 9F

	neg	1,+sp		;60 A0
	neg	2,+sp		;60 A1
	neg	3,+sp		;60 A2
	neg	4,+sp		;60 A3
	neg	5,+sp		;60 A4
	neg	6,+sp		;60 A5
	neg	7,+sp		;60 A6
	neg	8,+sp		;60 A7
	neg	8,-sp		;60 A8
	neg	7,-sp		;60 A9
	neg	6,-sp		;60 AA
	neg	5,-sp		;60 AB
	neg	4,-sp		;60 AC
	neg	3,-sp		;60 AD
	neg	2,-sp		;60 AE
	neg	1,-sp		;60 AF
	neg	1,sp+		;60 B0
	neg	2,sp+		;60 B1
	neg	3,sp+		;60 B2
	neg	4,sp+		;60 B3
	neg	5,sp+		;60 B4
	neg	6,sp+		;60 B5
	neg	7,sp+		;60 B6
	neg	8,sp+		;60 B7
	neg	8,sp-		;60 B8
	neg	7,sp-		;60 B9
	neg	6,sp-		;60 BA
	neg	5,sp-		;60 BB
	neg	4,sp-		;60 BC
	neg	3,sp-		;60 BD
	neg	2,sp-		;60 BE
	neg	1,sp-		;60 BF

	neg	0,pc		;60 C0
	neg	1,pc		;60 C1
	neg	2,pc		;60 C2
	neg	3,pc		;60 C3
	neg	4,pc		;60 C4
	neg	5,pc		;60 C5
	neg	6,pc		;60 C6
	neg	7,pc		;60 C7
	neg	8,pc		;60 C8
	neg	9,pc		;60 C9
	neg	10,pc		;60 CA
	neg	11,pc		;60 CB
	neg	12,pc		;60 CC
	neg	13,pc		;60 CD
	neg	14,pc		;60 CE
	neg	15,pc		;60 CF
	neg	-16,pc		;60 D0
	neg	-15,pc		;60 D1
	neg	-14,pc		;60 D2
	neg	-13,pc		;60 D3
	neg	-12,pc		;60 D4
	neg	-11,pc		;60 D5
	neg	-10,pc		;60 D6
	neg	-9,pc		;60 D7
	neg	-8,pc		;60 D8
	neg	-7,pc		;60 D9
	neg	-6,pc		;60 DA
	neg	-5,pc		;60 DB
	neg	-4,pc		;60 DC
	neg	-3,pc		;60 DD
	neg	-2,pc		;60 DE
	neg	-1,pc		;60 DF

	neg	0x0F,x		;60 0F
	neg	0xFFF0,x	;60 10
	neg	0xFF,x		;60 E0 FF
	neg	0xFF00,x	;60 E1 00
	neg	0x1000,x	;60 E2 10 00
	neg	[0x1000,x]	;60 E3 10 00
	neg	a,x		;60 E4
	neg	b,x		;60 E5
	neg	d,x		;60 E6
	neg	[d,x]		;60 E7
	neg	0x0F,y		;60 4F
	neg	0xFFF0,y	;60 50
	neg	0xFF,y		;60 E8 FF
	neg	0xFF00,y	;60 E9 00
	neg	0x1000,y	;60 EA 10 00
	neg	[0x1000,y]	;60 EB 10 00
	neg	a,y		;60 EC
	neg	b,y		;60 ED
	neg	d,y		;60 EE
	neg	[d,y]		;60 EF
	neg	0x0F,sp		;60 8F
	neg	0xFFF0,sp	;60 90
	neg	0xFF,sp		;60 F0 FF
	neg	0xFF00,sp	;60 F1 00
	neg	0x1000,sp	;60 F2 10 00
	neg	[0x1000,sp]	;60 F3 10 00
	neg	a,sp		;60 F4
	neg	b,sp		;60 F5
	neg	d,sp		;60 F6
	neg	[d,sp]		;60 F7
	neg	0x0F,pc		;60 CF
	neg	0xFFF0,pc	;60 D0
	neg	0xFF,pc		;60 F8 FF
	neg	0xFF00,pc	;60 F9 00
	neg	0x1000,pc	;60 FA 10 00
	neg	[0x1000,pc]	;60 FB 10 00
	neg	a,pc		;60 FC
	neg	b,pc		;60 FD
	neg	d,pc		;60 FE
	neg	[d,pc]		;60 FF


	.page
	.sbttl	Post Byte Addressing Test (post defined constants)

	neg	num0,x		;60 00
	neg	num1,x		;60 01
	neg	num2,x		;60 02
	neg	num3,x		;60 03
	neg	num4,x		;60 04
	neg	num5,x		;60 05
	neg	num6,x		;60 06
	neg	num7,x		;60 07
	neg	num8,x		;60 08
	neg	num9,x		;60 09
	neg	num10,x		;60 0A
	neg	num11,x		;60 0B
	neg	num12,x		;60 0C
	neg	num13,x		;60 0D
	neg	num14,x		;60 0E
	neg	num15,x		;60 0F
	neg	-num16,x	;60 10
	neg	-num15,x	;60 11
	neg	-num14,x	;60 12
	neg	-num13,x	;60 13
	neg	-num12,x	;60 14
	neg	-num11,x	;60 15
	neg	-num10,x	;60 16
	neg	-num9,x		;60 17
	neg	-num8,x		;60 18
	neg	-num7,x		;60 19
	neg	-num6,x		;60 1A
	neg	-num5,x		;60 1B
	neg	-num4,x		;60 1C
	neg	-num3,x		;60 1D
	neg	-num2,x		;60 1E
	neg	-num1,x		;60 1F

	neg	num1,+x		;60 20
	neg	num2,+x		;60 21
	neg	num3,+x		;60 22
	neg	num4,+x		;60 23
	neg	num5,+x		;60 24
	neg	num6,+x		;60 25
	neg	num7,+x		;60 26
	neg	num8,+x		;60 27
	neg	num8,-x		;60 28
	neg	num7,-x		;60 29
	neg	num6,-x		;60 2A
	neg	num5,-x		;60 2B
	neg	num4,-x		;60 2C
	neg	num3,-x		;60 2D
	neg	num2,-x		;60 2E
	neg	num1,-x		;60 2F
	neg	num1,x+		;60 30
	neg	num2,x+		;60 31
	neg	num3,x+		;60 32
	neg	num4,x+		;60 33
	neg	num5,x+		;60 34
	neg	num6,x+		;60 35
	neg	num7,x+		;60 36
	neg	num8,x+		;60 37
	neg	num8,x-		;60 38
	neg	num7,x-		;60 39
	neg	num6,x-		;60 3A
	neg	num5,x-		;60 3B
	neg	num4,x-		;60 3C
	neg	num3,x-		;60 3D
	neg	num2,x-		;60 3E
	neg	num1,x-		;60 3F

	neg	num0,y		;60 40
	neg	num1,y		;60 41
	neg	num2,y		;60 42
	neg	num3,y		;60 43
	neg	num4,y		;60 44
	neg	num5,y		;60 45
	neg	num6,y		;60 46
	neg	num7,y		;60 47
	neg	num8,y		;60 48
	neg	num9,y		;60 49
	neg	num10,y		;60 4A
	neg	num11,y		;60 4B
	neg	num12,y		;60 4C
	neg	num13,y		;60 4D
	neg	num14,y		;60 4E
	neg	num15,y		;60 4F
	neg	-num16,y	;60 50
	neg	-num15,y	;60 51
	neg	-num14,y	;60 52
	neg	-num13,y	;60 53
	neg	-num12,y	;60 54
	neg	-num11,y	;60 55
	neg	-num10,y	;60 56
	neg	-num9,y		;60 57
	neg	-num8,y		;60 58
	neg	-num7,y		;60 59
	neg	-num6,y		;60 5A
	neg	-num5,y		;60 5B
	neg	-num4,y		;60 5C
	neg	-num3,y		;60 5D
	neg	-num2,y		;60 5E
	neg	-num1,y		;60 5F

	neg	num1,+y		;60 60
	neg	num2,+y		;60 61
	neg	num3,+y		;60 62
	neg	num4,+y		;60 63
	neg	num5,+y		;60 64
	neg	num6,+y		;60 65
	neg	num7,+y		;60 66
	neg	num8,+y		;60 67
	neg	num8,-y		;60 68
	neg	num7,-y		;60 69
	neg	num6,-y		;60 6A
	neg	num5,-y		;60 6B
	neg	num4,-y		;60 6C
	neg	num3,-y		;60 6D
	neg	num2,-y		;60 6E
	neg	num1,-y		;60 6F
	neg	num1,y+		;60 70
	neg	num2,y+		;60 71
	neg	num3,y+		;60 72
	neg	num4,y+		;60 73
	neg	num5,y+		;60 74
	neg	num6,y+		;60 75
	neg	num7,y+		;60 76
	neg	num8,y+		;60 77
	neg	num8,y-		;60 78
	neg	num7,y-		;60 79
	neg	num6,y-		;60 7A
	neg	num5,y-		;60 7B
	neg	num4,y-		;60 7C
	neg	num3,y-		;60 7D
	neg	num2,y-		;60 7E
	neg	num1,y-		;60 7F

	neg	num0,sp		;60 80
	neg	num1,sp		;60 81
	neg	num2,sp		;60 82
	neg	num3,sp		;60 83
	neg	num4,sp		;60 84
	neg	num5,sp		;60 85
	neg	num6,sp		;60 86
	neg	num7,sp		;60 87
	neg	num8,sp		;60 88
	neg	num9,sp		;60 89
	neg	num10,sp	;60 8A
	neg	num11,sp	;60 8B
	neg	num12,sp	;60 8C
	neg	num13,sp	;60 8D
	neg	num14,sp	;60 8E
	neg	num15,sp	;60 8F
	neg	-num16,sp	;60 90
	neg	-num15,sp	;60 91
	neg	-num14,sp	;60 92
	neg	-num13,sp	;60 93
	neg	-num12,sp	;60 94
	neg	-num11,sp	;60 95
	neg	-num10,sp	;60 96
	neg	-num9,sp	;60 97
	neg	-num8,sp	;60 98
	neg	-num7,sp	;60 99
	neg	-num6,sp	;60 9A
	neg	-num5,sp	;60 9B
	neg	-num4,sp	;60 9C
	neg	-num3,sp	;60 9D
	neg	-num2,sp	;60 9E
	neg	-num1,sp	;60 9F

	neg	num1,+sp	;60 A0
	neg	num2,+sp	;60 A1
	neg	num3,+sp	;60 A2
	neg	num4,+sp	;60 A3
	neg	num5,+sp	;60 A4
	neg	num6,+sp	;60 A5
	neg	num7,+sp	;60 A6
	neg	num8,+sp	;60 A7
	neg	num8,-sp	;60 A8
	neg	num7,-sp	;60 A9
	neg	num6,-sp	;60 AA
	neg	num5,-sp	;60 AB
	neg	num4,-sp	;60 AC
	neg	num3,-sp	;60 AD
	neg	num2,-sp	;60 AE
	neg	num1,-sp	;60 AF
	neg	num1,sp+	;60 B0
	neg	num2,sp+	;60 B1
	neg	num3,sp+	;60 B2
	neg	num4,sp+	;60 B3
	neg	num5,sp+	;60 B4
	neg	num6,sp+	;60 B5
	neg	num7,sp+	;60 B6
	neg	num8,sp+	;60 B7
	neg	num8,sp-	;60 B8
	neg	num7,sp-	;60 B9
	neg	num6,sp-	;60 BA
	neg	num5,sp-	;60 BB
	neg	num4,sp-	;60 BC
	neg	num3,sp-	;60 BD
	neg	num2,sp-	;60 BE
	neg	num1,sp-	;60 BF

	neg	num0,pc		;60 C0
	neg	num1,pc		;60 C1
	neg	num2,pc		;60 C2
	neg	num3,pc		;60 C3
	neg	num4,pc		;60 C4
	neg	num5,pc		;60 C5
	neg	num6,pc		;60 C6
	neg	num7,pc		;60 C7
	neg	num8,pc		;60 C8
	neg	num9,pc		;60 C9
	neg	num10,pc	;60 CA
	neg	num11,pc	;60 CB
	neg	num12,pc	;60 CC
	neg	num13,pc	;60 CD
	neg	num14,pc	;60 CE
	neg	num15,pc	;60 CF
	neg	-num16,pc	;60 D0
	neg	-num15,pc	;60 D1
	neg	-num14,pc	;60 D2
	neg	-num13,pc	;60 D3
	neg	-num12,pc	;60 D4
	neg	-num11,pc	;60 D5
	neg	-num10,pc	;60 D6
	neg	-num9,pc	;60 D7
	neg	-num8,pc	;60 D8
	neg	-num7,pc	;60 D9
	neg	-num6,pc	;60 DA
	neg	-num5,pc	;60 DB
	neg	-num4,pc	;60 DC
	neg	-num3,pc	;60 DD
	neg	-num2,pc	;60 DE
	neg	-num1,pc	;60 DF

	neg	snn,x		;60 0F
	neg	smnn,x		;60 10
	neg	nn,x		;60 E0 FF
	neg	mnn,x		;60 E1 00
	neg	mmnn,x		;60 E2 10 00
	neg	[mmnn,x]	;60 E3 10 00
	neg	a,x		;60 E4
	neg	b,x		;60 E5
	neg	d,x		;60 E6
	neg	[d,x]		;60 E7
	neg	snn,y		;60 4F
	neg	smnn,y		;60 50
	neg	nn,y		;60 E8 FF
	neg	mnn,y		;60 E9 00
	neg	mmnn,y		;60 EA 10 00
	neg	[mmnn,y]	;60 EB 10 00
	neg	a,y		;60 EC
	neg	b,y		;60 ED
	neg	d,y		;60 EE
	neg	[d,y]		;60 EF
	neg	snn,sp		;60 8F
	neg	smnn,sp		;60 90
	neg	nn,sp		;60 F0 FF
	neg	mnn,sp		;60 F1 00
	neg	mmnn,sp		;60 F2 10 00
	neg	[mmnn,sp]	;60 F3 10 00
	neg	a,sp		;60 F4
	neg	b,sp		;60 F5
	neg	d,sp		;60 F6
	neg	[d,sp]		;60 F7
	neg	snn,pc		;60 CF
	neg	smnn,pc		;60 D0
	neg	nn,pc		;60 F8 FF
	neg	mnn,pc		;60 F9 00
	neg	mmnn,pc		;60 FA 10 00
	neg	[mmnn,pc]	;60 FB 10 00
	neg	a,pc		;60 FC
	neg	b,pc		;60 FD
	neg	d,pc		;60 FE
	neg	[d,pc]		;60 FF


	.page
	.sbttl	Defined constants

	snn	=	0x0F
	smnn	=	0xFFF0
	nn	=	0xFF
	mnn	=	0xFF00
	mmnn	=	0x1000

	num0	=	0
	num1	=	1
	num2	=	2
	num3	=	3
	num4	=	4
	num5	=	5
	num6	=	6
	num7	=	7
	num8	=	8
	num9	=	9
	num10	=	10
	num11	=	11
	num12	=	12
	num13	=	13
	num14	=	14
	num15	=	15
	num16	=	16


	.page
	.sbttl	Post Byte Addressing Test (predefined constants)

	neg	num0,x		;60 00
	neg	num1,x		;60 01
	neg	num2,x		;60 02
	neg	num3,x		;60 03
	neg	num4,x		;60 04
	neg	num5,x		;60 05
	neg	num6,x		;60 06
	neg	num7,x		;60 07
	neg	num8,x		;60 08
	neg	num9,x		;60 09
	neg	num10,x		;60 0A
	neg	num11,x		;60 0B
	neg	num12,x		;60 0C
	neg	num13,x		;60 0D
	neg	num14,x		;60 0E
	neg	num15,x		;60 0F
	neg	-num16,x	;60 10
	neg	-num15,x	;60 11
	neg	-num14,x	;60 12
	neg	-num13,x	;60 13
	neg	-num12,x	;60 14
	neg	-num11,x	;60 15
	neg	-num10,x	;60 16
	neg	-num9,x		;60 17
	neg	-num8,x		;60 18
	neg	-num7,x		;60 19
	neg	-num6,x		;60 1A
	neg	-num5,x		;60 1B
	neg	-num4,x		;60 1C
	neg	-num3,x		;60 1D
	neg	-num2,x		;60 1E
	neg	-num1,x		;60 1F

	neg	num1,+x		;60 20
	neg	num2,+x		;60 21
	neg	num3,+x		;60 22
	neg	num4,+x		;60 23
	neg	num5,+x		;60 24
	neg	num6,+x		;60 25
	neg	num7,+x		;60 26
	neg	num8,+x		;60 27
	neg	num8,-x		;60 28
	neg	num7,-x		;60 29
	neg	num6,-x		;60 2A
	neg	num5,-x		;60 2B
	neg	num4,-x		;60 2C
	neg	num3,-x		;60 2D
	neg	num2,-x		;60 2E
	neg	num1,-x		;60 2F
	neg	num1,x+		;60 30
	neg	num2,x+		;60 31
	neg	num3,x+		;60 32
	neg	num4,x+		;60 33
	neg	num5,x+		;60 34
	neg	num6,x+		;60 35
	neg	num7,x+		;60 36
	neg	num8,x+		;60 37
	neg	num8,x-		;60 38
	neg	num7,x-		;60 39
	neg	num6,x-		;60 3A
	neg	num5,x-		;60 3B
	neg	num4,x-		;60 3C
	neg	num3,x-		;60 3D
	neg	num2,x-		;60 3E
	neg	num1,x-		;60 3F

	neg	num0,y		;60 40
	neg	num1,y		;60 41
	neg	num2,y		;60 42
	neg	num3,y		;60 43
	neg	num4,y		;60 44
	neg	num5,y		;60 45
	neg	num6,y		;60 46
	neg	num7,y		;60 47
	neg	num8,y		;60 48
	neg	num9,y		;60 49
	neg	num10,y		;60 4A
	neg	num11,y		;60 4B
	neg	num12,y		;60 4C
	neg	num13,y		;60 4D
	neg	num14,y		;60 4E
	neg	num15,y		;60 4F
	neg	-num16,y	;60 50
	neg	-num15,y	;60 51
	neg	-num14,y	;60 52
	neg	-num13,y	;60 53
	neg	-num12,y	;60 54
	neg	-num11,y	;60 55
	neg	-num10,y	;60 56
	neg	-num9,y		;60 57
	neg	-num8,y		;60 58
	neg	-num7,y		;60 59
	neg	-num6,y		;60 5A
	neg	-num5,y		;60 5B
	neg	-num4,y		;60 5C
	neg	-num3,y		;60 5D
	neg	-num2,y		;60 5E
	neg	-num1,y		;60 5F

	neg	num1,+y		;60 60
	neg	num2,+y		;60 61
	neg	num3,+y		;60 62
	neg	num4,+y		;60 63
	neg	num5,+y		;60 64
	neg	num6,+y		;60 65
	neg	num7,+y		;60 66
	neg	num8,+y		;60 67
	neg	num8,-y		;60 68
	neg	num7,-y		;60 69
	neg	num6,-y		;60 6A
	neg	num5,-y		;60 6B
	neg	num4,-y		;60 6C
	neg	num3,-y		;60 6D
	neg	num2,-y		;60 6E
	neg	num1,-y		;60 6F
	neg	num1,y+		;60 70
	neg	num2,y+		;60 71
	neg	num3,y+		;60 72
	neg	num4,y+		;60 73
	neg	num5,y+		;60 74
	neg	num6,y+		;60 75
	neg	num7,y+		;60 76
	neg	num8,y+		;60 77
	neg	num8,y-		;60 78
	neg	num7,y-		;60 79
	neg	num6,y-		;60 7A
	neg	num5,y-		;60 7B
	neg	num4,y-		;60 7C
	neg	num3,y-		;60 7D
	neg	num2,y-		;60 7E
	neg	num1,y-		;60 7F

	neg	num0,sp		;60 80
	neg	num1,sp		;60 81
	neg	num2,sp		;60 82
	neg	num3,sp		;60 83
	neg	num4,sp		;60 84
	neg	num5,sp		;60 85
	neg	num6,sp		;60 86
	neg	num7,sp		;60 87
	neg	num8,sp		;60 88
	neg	num9,sp		;60 89
	neg	num10,sp	;60 8A
	neg	num11,sp	;60 8B
	neg	num12,sp	;60 8C
	neg	num13,sp	;60 8D
	neg	num14,sp	;60 8E
	neg	num15,sp	;60 8F
	neg	-num16,sp	;60 90
	neg	-num15,sp	;60 91
	neg	-num14,sp	;60 92
	neg	-num13,sp	;60 93
	neg	-num12,sp	;60 94
	neg	-num11,sp	;60 95
	neg	-num10,sp	;60 96
	neg	-num9,sp	;60 97
	neg	-num8,sp	;60 98
	neg	-num7,sp	;60 99
	neg	-num6,sp	;60 9A
	neg	-num5,sp	;60 9B
	neg	-num4,sp	;60 9C
	neg	-num3,sp	;60 9D
	neg	-num2,sp	;60 9E
	neg	-num1,sp	;60 9F

	neg	num1,+sp	;60 A0
	neg	num2,+sp	;60 A1
	neg	num3,+sp	;60 A2
	neg	num4,+sp	;60 A3
	neg	num5,+sp	;60 A4
	neg	num6,+sp	;60 A5
	neg	num7,+sp	;60 A6
	neg	num8,+sp	;60 A7
	neg	num8,-sp	;60 A8
	neg	num7,-sp	;60 A9
	neg	num6,-sp	;60 AA
	neg	num5,-sp	;60 AB
	neg	num4,-sp	;60 AC
	neg	num3,-sp	;60 AD
	neg	num2,-sp	;60 AE
	neg	num1,-sp	;60 AF
	neg	num1,sp+	;60 B0
	neg	num2,sp+	;60 B1
	neg	num3,sp+	;60 B2
	neg	num4,sp+	;60 B3
	neg	num5,sp+	;60 B4
	neg	num6,sp+	;60 B5
	neg	num7,sp+	;60 B6
	neg	num8,sp+	;60 B7
	neg	num8,sp-	;60 B8
	neg	num7,sp-	;60 B9
	neg	num6,sp-	;60 BA
	neg	num5,sp-	;60 BB
	neg	num4,sp-	;60 BC
	neg	num3,sp-	;60 BD
	neg	num2,sp-	;60 BE
	neg	num1,sp-	;60 BF

	neg	num0,pc		;60 C0
	neg	num1,pc		;60 C1
	neg	num2,pc		;60 C2
	neg	num3,pc		;60 C3
	neg	num4,pc		;60 C4
	neg	num5,pc		;60 C5
	neg	num6,pc		;60 C6
	neg	num7,pc		;60 C7
	neg	num8,pc		;60 C8
	neg	num9,pc		;60 C9
	neg	num10,pc	;60 CA
	neg	num11,pc	;60 CB
	neg	num12,pc	;60 CC
	neg	num13,pc	;60 CD
	neg	num14,pc	;60 CE
	neg	num15,pc	;60 CF
	neg	-num16,pc	;60 D0
	neg	-num15,pc	;60 D1
	neg	-num14,pc	;60 D2
	neg	-num13,pc	;60 D3
	neg	-num12,pc	;60 D4
	neg	-num11,pc	;60 D5
	neg	-num10,pc	;60 D6
	neg	-num9,pc	;60 D7
	neg	-num8,pc	;60 D8
	neg	-num7,pc	;60 D9
	neg	-num6,pc	;60 DA
	neg	-num5,pc	;60 DB
	neg	-num4,pc	;60 DC
	neg	-num3,pc	;60 DD
	neg	-num2,pc	;60 DE
	neg	-num1,pc	;60 DF

	neg	snn,x		;60 0F
	neg	smnn,x		;60 10
	neg	nn,x		;60 E0 FF
	neg	mnn,x		;60 E1 00
	neg	mmnn,x		;60 E2 10 00
	neg	[mmnn,x]	;60 E3 10 00
	neg	a,x		;60 E4
	neg	b,x		;60 E5
	neg	d,x		;60 E6
	neg	[d,x]		;60 E7
	neg	snn,y		;60 4F
	neg	smnn,y		;60 50
	neg	nn,y		;60 E8 FF
	neg	mnn,y		;60 E9 00
	neg	mmnn,y		;60 EA 10 00
	neg	[mmnn,y]	;60 EB 10 00
	neg	a,y		;60 EC
	neg	b,y		;60 ED
	neg	d,y		;60 EE
	neg	[d,y]		;60 EF
	neg	snn,sp		;60 8F
	neg	smnn,sp		;60 90
	neg	nn,sp		;60 F0 FF
	neg	mnn,sp		;60 F1 00
	neg	mmnn,sp		;60 F2 10 00
	neg	[mmnn,sp]	;60 F3 10 00
	neg	a,sp		;60 F4
	neg	b,sp		;60 F5
	neg	d,sp		;60 F6
	neg	[d,sp]		;60 F7
	neg	snn,pc		;60 CF
	neg	smnn,pc		;60 D0
	neg	nn,pc		;60 F8 FF
	neg	mnn,pc		;60 F9 00
	neg	mmnn,pc		;60 FA 10 00
	neg	[mmnn,pc]	;60 FB 10 00
	neg	a,pc		;60 FC
	neg	b,pc		;60 FD
	neg	d,pc		;60 FE
	neg	[d,pc]		;60 FF


	.page
	.sbttl	Tests of All Valid Modes for Instruction Groups
	.sbttl	Transfer / Exchange / Sign Extend Post Byte Encoding

	; All Transfer Modes

	tfr	a,a		;B7 00
	tfr	a,b		;B7 01
	tfr	a,ccr		;B7 02
	tfr	a,t2		;B7 03
	tfr	a,d		;B7 04
	tfr	a,x		;B7 05
	tfr	a,y		;B7 06
	tfr	a,sp		;B7 07
	tfr	b,a		;B7 10
	tfr	b,b		;B7 11
	tfr	b,ccr		;B7 12
	tfr	b,t2		;B7 13
	tfr	b,d		;B7 14
	tfr	b,x		;B7 15
	tfr	b,y		;B7 16
	tfr	b,sp		;B7 17
	tfr	ccr,a		;B7 20
	tfr	ccr,b		;B7 21
	tfr	ccr,ccr		;B7 22
	tfr	ccr,t2		;B7 23
	tfr	ccr,d		;B7 24
	tfr	ccr,x		;B7 25
	tfr	ccr,y		;B7 26
	tfr	ccr,sp		;B7 27
	tfr	t3,a		;B7 30
	tfr	t3,b		;B7 31
	tfr	t3,ccr		;B7 32
	tfr	t3,t2		;B7 33
	tfr	t3,d		;B7 34
	tfr	t3,x		;B7 35
	tfr	t3,y		;B7 36
	tfr	t3,sp		;B7 37
;	tfr	b,a		;B7 40
;	tfr	b,b		;B7 41
;	tfr	b,ccr		;B7 42
	tfr	d,t2		;B7 43
	tfr	d,d		;B7 44
	tfr	d,x		;B7 45
	tfr	d,y		;B7 46
	tfr	d,sp		;B7 47
	tfr	x,a		;B7 50
	tfr	x,b		;B7 51
	tfr	x,ccr		;B7 52
	tfr	x,t2		;B7 53
	tfr	x,d		;B7 54
	tfr	x,x		;B7 55
	tfr	x,y		;B7 56
	tfr	x,sp		;B7 57
	tfr	y,a		;B7 60
	tfr	y,b		;B7 61
	tfr	y,ccr		;B7 62
	tfr	y,t2		;B7 63
	tfr	y,d		;B7 64
	tfr	y,x		;B7 65
	tfr	y,y		;B7 66
	tfr	y,sp		;B7 67
	tfr	sp,a		;B7 70
	tfr	sp,b		;B7 71
	tfr	sp,ccr		;B7 72
	tfr	sp,t2		;B7 73
	tfr	sp,d		;B7 74
	tfr	sp,x		;B7 75
	tfr	sp,y		;B7 76
	tfr	sp,sp		;B7 77

	; All Exchange Modes

	exg	a,a		;B7 80
	exg	a,b		;B7 81
	exg	a,ccr		;B7 82
	exg	a,t2		;B7 83
	exg	a,d		;B7 84
	exg	a,x		;B7 85
	exg	a,y		;B7 86
	exg	a,sp		;B7 87
	exg	b,a		;B7 90
	exg	b,b		;B7 91
	exg	b,ccr		;B7 92
	exg	b,t2		;B7 93
	exg	b,d		;B7 94
	exg	b,x		;B7 95
	exg	b,y		;B7 96
	exg	b,sp		;B7 97
	exg	ccr,a		;B7 A0
	exg	ccr,b		;B7 A1
	exg	ccr,ccr		;B7 A2
	exg	ccr,t2		;B7 A3
	exg	ccr,d		;B7 A4
	exg	ccr,x		;B7 A5
	exg	ccr,y		;B7 A6
	exg	ccr,sp		;B7 A7
	exg	t3,a		;B7 B0
	exg	t3,b		;B7 B1
	exg	t3,ccr		;B7 B2
	exg	t3,t2		;B7 B3
	exg	t3,d		;B7 B4
	exg	t3,x		;B7 B5
	exg	t3,y		;B7 B6
	exg	t3,sp		;B7 B7
;	exg	b,a		;B7 C0
;	exg	b,b		;B7 C1
;	exg	b,ccr		;B7 C2
	exg	d,t2		;B7 C3
	exg	d,d		;B7 C4
	exg	d,x		;B7 C5
	exg	d,y		;B7 C6
	exg	d,sp		;B7 C7
	exg	x,a		;B7 D0
	exg	x,b		;B7 D1
	exg	x,ccr		;B7 D2
	exg	x,t2		;B7 D3
	exg	x,d		;B7 D4
	exg	x,x		;B7 D5
	exg	x,y		;B7 D6
	exg	x,sp		;B7 D7
	exg	y,a		;B7 E0
	exg	y,b		;B7 E1
	exg	y,ccr		;B7 E2
	exg	y,t2		;B7 E3
	exg	y,d		;B7 E4
	exg	y,x		;B7 E5
	exg	y,y		;B7 E6
	exg	y,sp		;B7 E7
	exg	sp,a		;B7 F0
	exg	sp,b		;B7 F1
	exg	sp,ccr		;B7 F2
	exg	sp,t2		;B7 F3
	exg	sp,d		;B7 F4
	exg	sp,x		;B7 F5
	exg	sp,y		;B7 F6
	exg	sp,sp		;B7 F7

	; Valid Sign Extend Modes

;	sex	a,a		;B7 00
;	sex	a,b		;B7 01
;	sex	a,ccr		;B7 02
	sex	a,t2		;B7 03
	sex	a,d		;B7 04
	sex	a,x		;B7 05
	sex	a,y		;B7 06
	sex	a,sp		;B7 07
;	sex	b,a		;B7 10
;	sex	b,b		;B7 11
;	sex	b,ccr		;B7 12
	sex	b,t2		;B7 13
	sex	b,d		;B7 14
	sex	b,x		;B7 15
	sex	b,y		;B7 16
	sex	b,sp		;B7 17
;	sex	ccr,a		;B7 20
;	sex	ccr,b		;B7 21
;	sex	ccr,ccr		;B7 22
	sex	ccr,t2		;B7 23
	sex	ccr,d		;B7 24
	sex	ccr,x		;B7 25
	sex	ccr,y		;B7 26
	sex	ccr,sp		;B7 27
;	sex	t3,a		;B7 30
;	sex	t3,b		;B7 31
;	sex	t3,ccr		;B7 32
;	sex	t3,t2		;B7 33
;	sex	t3,d		;B7 34
;	sex	t3,x		;B7 35
;	sex	t3,y		;B7 36
;	sex	t3,sp		;B7 37
;	sex	b,a		;B7 40
;	sex	b,b		;B7 41
;	sex	b,ccr		;B7 42
;	sex	d,t2		;B7 43
;	sex	d,d		;B7 44
;	sex	d,x		;B7 45
;	sex	d,y		;B7 46
;	sex	d,sp		;B7 47
;	sex	x,a		;B7 50
;	sex	x,b		;B7 51
;	sex	x,ccr		;B7 52
;	sex	x,t2		;B7 53
;	sex	x,d		;B7 54
;	sex	x,x		;B7 55
;	sex	x,y		;B7 56
;	sex	x,sp		;B7 57
;	sex	y,a		;B7 60
;	sex	y,b		;B7 61
;	sex	y,ccr		;B7 62
;	sex	y,t2		;B7 63
;	sex	y,d		;B7 64
;	sex	y,x		;B7 65
;	sex	y,y		;B7 66
;	sex	y,sp		;B7 67
;	sex	sp,a		;B7 70
;	sex	sp,b		;B7 71
;	sex	sp,ccr		;B7 72
;	sex	sp,t2		;B7 73
;	sex	sp,d		;B7 74
;	sex	sp,x		;B7 75
;	sex	sp,y		;B7 76
;	sex	sp,sp		;B7 77


	.page
	.sbttl	Call Instruction

	pg = 0x90

	ext = 0x1234
	idx = 0x01
	idx1 = 0x00FF
	idx2 = 0x5678

	call	ext,pg		;4A 12 34 90
	call	idx,x,pg	;4B 01 90
	call	idx1,x,pg	;4B E0 FF 90
	call	idx2,x,pg	;4B E2 56 78 90
	call	[idx2,x]	;4B E3 56 78
	call	[d,x]		;4B E7
	

	.page
	.sbttl	bclr / bset instructions

	msk = 0xA5

	dir = 0x22
	ext = 0x1234
	idx = 0x01
	idx1 = 0x00FF
	idx2 = 0x5678

	bclr	*dir,msk	;4D*22 A5
	bclr	ext,msk		;1D 12 34 A5
	bclr	1,x,msk		;0D 01 A5
	bclr	idx1,x,msk	;0D E0 FF A5
	bclr	idx2,x,msk	;0D E2 56 78 A5

	bset	*dir,msk	;4C*22 A5
	bset	ext,msk		;1C 12 34 A5
	bset	1,x,msk		;0C 01 A5
	bset	idx1,x,msk	;0C E0 FF A5
	bset	idx2,x,msk	;0C E2 56 78 A5


	.page
	.sbttl	brclr / brset instructions

	msk = 0xA5

	dir = 0x22
	ext = 0x1234
	idx = 0x01
	idx1 = 0x00FF
	idx2 = 0x5678

	brclr	*dir,msk,.+6		;4F*22 A5 02
	brclr	ext,msk,.+6		;1F 12 34 A5 01
	brclr	1,x,msk,.+6		;0F 01 A5 02
	brclr	idx1,x,msk,.+6		;0F E0 FF A5 01
	brclr	idx2,x,msk,.+6		;0F E2 56 78 A5 00

	brset	*dir,msk,.+6		;4E*22 A5 02
	brset	ext,msk,.+6		;1E 12 34 A5 01
	brset	1,x,msk,.+6		;0E 01 A5 02
	brset	idx1,x,msk,.+6		;0E E0 FF A5 01
	brset	idx2,x,msk,.+6		;0E E2 56 78 A5 00


	.page
	.sbttl	movb / movw instructions

	imm = 0x5A

	dir = 0x22
	ext = 0x1234
	extd = 0x5678
	idx = 0x01
	idxd = 0x02

	movb	#imm,ext		;18 0B 5A 12 34
	movb	#imm,idx,x		;18 08 01 5A
	movb	ext,extd		;18 0C 12 34 56 78
	movb	*dir,extd		;18 0C 00 22 56 78
	movb	ext,idx,x		;18 09 01 12 34
	movb	*dir,idx,x		;18 09 01 00 22
	movb	idx,x,ext		;18 0D 01 12 34
	movb	idx,x,*dir		;18 0D 01 00 22
	movb	idx,x,idxd,x		;18 0A 01 02


	.sbttl	PC Offsets for Move Byte Instructions

	movb	#imm,	4,pc		;18 08 c3 5A
	movb	ext,	4,pc		;18 09 c2 12 34
	movb	4,pc,	ext		;18 0D c6 12 34
	movb	4,pc,	8,pc		;18 0A c5 c7

	movb	#imm,	a,pc		;18 08 fc 5A
	movb	ext,	a,pc		;18 09 fc 12 34
	movb	a,pc,	ext		;18 0D fc 12 34
	movb	a,pc,	b,pc		;18 0A fc fd


	.sbttl	PC Offsets for Move Word Instructions

	movw	#imm,	4,pc		;18 00 c2 00 5A
	movw	ext,	4,pc		;18 01 c2 12 34
	movw	4,pc,	ext		;18 05 c6 12 34
	movw	4,pc,	8,pc		;18 02 c5 c7

	movw	#imm,	a,pc		;18 00 fc 00 5A
	movw	ext,	a,pc		;18 01 fc 12 34
	movw	a,pc,	ext		;18 05 fc 12 34
	movw	a,pc,	b,pc		;18 02 fc fd


	.page
	.sbttl	External Modes


;	xsnn	=	0x0F
;	xsmnn	=	0xFFF0
;	xnn	=	0xFF
;	xmnn	=	0xFF00
;	xmmnn	=	0x1000


	neg	xsnn,x		;60 E2s00r00
	neg	xsmnn,x		;60 E2s00r00
	neg	xnn,x		;60 E2s00r00
	neg	xmnn,x		;60 E2s00r00
	neg	xmmnn,x		;60 E2s00r00
	neg	[xmmnn,x]	;60 E3s00r00
	neg	a,x		;60 E4
	neg	b,x		;60 E5
	neg	d,x		;60 E6
	neg	[d,x]		;60 E7
	neg	xsnn,y		;60 EAs00r00
	neg	xsmnn,y		;60 EAs00r00
	neg	xnn,y		;60 EAs00r00
	neg	xmnn,y		;60 EAs00r00
	neg	xmmnn,y		;60 EAs00r00
	neg	[xmmnn,y]	;60 EBs00r00
	neg	a,y		;60 EC
	neg	b,y		;60 ED
	neg	d,y		;60 EE
	neg	[d,y]		;60 EF
	neg	sxnn,sp		;60 F2s00r00
	neg	sxmnn,sp	;60 F2s00r00
	neg	xnn,sp		;60 F2s00r00
	neg	xmnn,sp		;60 F2s00r00
	neg	xmmnn,sp	;60 F2s00r00
	neg	[xmmnn,sp]	;60 F3s00r00
	neg	a,sp		;60 F4
	neg	b,sp		;60 F5
	neg	d,sp		;60 F6
	neg	[d,sp]		;60 F7
	neg	sxnn,pc		;60 FAs00r00
	neg	sxmnn,pc	;60 FAs00r00
	neg	xnn,pc		;60 FAs00r00
	neg	xmnn,pc		;60 FAs00r00
	neg	xmmnn,pc	;60 FAs00r00
	neg	[xmmnn,pc]	;60 FBs00r00
	neg	a,pc		;60 FC
	neg	b,pc		;60 FD
	neg	d,pc		;60 FE
	neg	[d,pc]		;60 FF


	.page
	.sbttl	Call Instruction

;	xpg = 0x90

;	xext = 0x1234
;	xidx = 0x01
;	xidx1 = 0x00FF
;	xidx2 = 0x5678

	call	xext,xpg	;4As00r00u00
	call	xidx,x,xpg	;4B E2s00r00u00
	call	xidx1,x,xpg	;4B E2s00r00u00
	call	xidx2,x,xpg	;4B E2s00r00u00
	call	[xidx2,x]	;4B E3s00r00
	call	[d,x]		;4B E7
	

	.page
	.sbttl	bclr / bset instructions

;	xmsk = 0xA5

;	xdir = 0x22
;	xext = 0x1234
;	xidx = 0x01
;	xidx1 = 0x00FF
;	xidx2 = 0x5678

	bclr	*xdir,xmsk	;4D*00r00
	bclr	xext,xmsk	;1Ds00r00r00
	bclr	1,x,xmsk	;0D 01r00
	bclr	xidx1,x,xmsk	;0D E2s00r00r00
	bclr	xidx2,x,xmsk	;0D E2s00r00r00

	bset	*xdir,xmsk	;4C*00r00
	bset	xext,xmsk	;1Cs00r00r00
	bset	1,x,xmsk	;0C 01r00
	bset	xidx1,x,xmsk	;0C E2s00r00r00
	bset	xidx2,x,xmsk	;0C E2s00r00r00


	.page
	.sbttl	brclr / brset instructions

;	xmsk = 0xA5
;	label = (.+6)

;	xdir = 0x22
;	xext = 0x1234
;	xidx = 0x01
;	xidx1 = 0x00FF
;	xidx2 = 0x5678

	brclr	*xdir,xmsk,label	;4F*00r00p00
	brclr	xext,xmsk,label		;1Fs00r00r00p00
	brclr	1,x,xmsk,label		;0F 01r00p00
	brclr	xidx1,x,xmsk,label	;0F E2s00r00r00p00
	brclr	xidx2,x,xmsk,label	;0F E2s00r00r00p00

	brset	*xdir,xmsk,label	;4E*00r00p00
	brset	xext,xmsk,label		;1Es00r00r00p00
	brset	1,x,xmsk,label		;0E 01r00p00
	brset	xidx1,x,xmsk,label	;0E E2s00r00r00p00
	brset	xidx2,x,xmsk,label	;0E E2s00r00r00p00


	.page
	.sbttl	movb / movw instructions

;	ximm = 0x5A

;	xdir = 0x22
;	xext = 0x1234
;	xextd = 0x5678
	idx = 0x01
	idxd = 0x02

	movb	#ximm,xext		;18 0Br00s00r00
	movb	#ximm,idx,x		;18 08 01r00
	movb	xext,xextd		;18 0Cs00r00s00r00
	movb	*xdir,xextd		;18 0Cs00r00s00r00
	movb	xext,idx,x		;18 09 01s00r00
	movb	*xdir,idx,x		;18 09 01s00r00
	movb	idx,x,xext		;18 0D 01s00r00
	movb	idx,x,*xdir		;18 0D 01s00r00
	movb	idx,x,idxd,x		;18 0A 01 02


	.sbttl	PC Offsets for Move Byte Instructions

	movb	#ximm,	4,pc		;18 08 c3r00
	movb	xext,	4,pc		;18 09 c2s00r00
	movb	4,pc,	xext		;18 0D c6s00r00
	movb	4,pc,	8,pc		;18 0A c5 c7

	movb	#ximm,	a,pc		;18 08 fcr00
	movb	xext,	a,pc		;18 09 fcs00r00
	movb	a,pc,	xext		;18 0D fcs00r00
	movb	a,pc,	b,pc		;18 0A fc fd


	.sbttl	PC Offsets for Move Word Instructions

	movw	#ximm,	4,pc		;18 00 c2s00r00
	movw	xext,	4,pc		;18 01 c2s00r00
	movw	4,pc,	xext		;18 05 c6s00r00
	movw	4,pc,	8,pc		;18 02 c5 c7

	movw	#ximm,	a,pc		;18 00 fcs00r00
	movw	xext,	a,pc		;18 01 fcs00r00
	movw	a,pc,	xext		;18 05 fcs00r00
	movw	a,pc,	b,pc		;18 02 fc fd


