	.title	6809 Assembler Test

	.sbttl	All 6809 Instructions

	abx			;3a
	adca	#0x01		;89 01
	adcb	*0x02		;d9*02
	adda	#0x03		;8b 03
	addb	*0x04		;db*04
	addd	#0x05		;c3 00 05
	anda	*0x06		;94*06
	andb	#0x07		;c4 07
	andcc	#0x08		;1c 08
	asl	,x		;68 84
	asla			;48
	aslb			;58
	asr	,x		;67 84
	asra			;47
	asrb			;57
	bcc	.+0x12		;24 10
	bcs	.+0x12		;25 10
	beq	.+0x12		;27 10
	bge	.+0x12		;2c 10
	bgt	.+0x12		;2e 10
	bhi	.+0x12		;22 10
	bhis	.+0x12		;24 10
	bhs	.+0x12		;24 10
	bita	#0x09		;85 09
	bitb	*0x0a		;d5*0a
	ble	.+0x12		;2f 10
	blo	.+0x12		;25 10
	blos	.+0x12		;23 10
	bls	.+0x12		;23 10
	blt	.+0x12		;2d 10
	bmi	.+0x12		;2b 10
	bne	.+0x12		;26 10
	bpl	.+0x12		;2a 10
	bra	.+0x12		;20 10
	brn	.+0x12		;21 10
	bsr	.+0x12		;8d 10
	bvc	.+0x12		;28 10
	bvs	.+0x12		;29 10
	clr	,x		;6f 84
	clra			;4f
	clrb			;5f
	cmpa	#0x0b		;81 0b
	cmpb	*0x0c		;d1*0c
	cmpd	#0x0d		;10 83 00 0d
	cmps	*0x0e		;11 9c*0e
	cmpu	#0x0f		;11 83 00 0f
	cmpx	*0x10		;9c*10
	cmpy	#0x11		;10 8C 00 11
	com	,x		;63 84
	coma			;43
	comb			;53
	cwai	#0x12		;3c 12
	daa			;19
	dec	,x		;6a 84
	deca			;4a
	decb			;5a
	eora	#0x13		;88 13
	eorb	*0x14		;d8*14
	exg	a,b		;1e 89
	inc	,x		;6c 84
	inca			;4c
	incb			;5c
	jmp	.+0x13,pcr	;6e 8c 10
	jsr	.+0x13,pcr	;ad 8c 10
	lbcc	.+0x14		;10 24 00 10
	lbcs	.+0x14		;10 25 00 10
	lbeq	.+0x14		;10 27 00 10
	lbge	.+0x14		;10 2c 00 10
	lbgt	.+0x14		;10 2e 00 10
	lbhi	.+0x14		;10 22 00 10
	lbhis	.+0x14		;10 24 00 10
	lbhs	.+0x14		;10 24 00 10
	lble	.+0x14		;10 2f 00 10
	lblo	.+0x14		;10 25 00 10
	lblos	.+0x14		;10 23 00 10
	lbls	.+0x14		;10 23 00 10
	lblt	.+0x14		;10 2d 00 10
	lbmi	.+0x14		;10 2b 00 10
	lbne	.+0x14		;10 26 00 10
	lbpl	.+0x14		;10 2a 00 10
	lbra	.+0x13		;16 00 10
	lbrn	.+0x14		;10 21 00 10
	lbsr	.+0x13		;17 00 10
	lbvc	.+0x14		;10 28 00 10
	lbvs	.+0x14		;10 29 00 10
	lda	#0x15		;86 15
	ldaa	*0x16		;96*16
	ldab	#0x17		;c6 17
	ldb	*0x18		;d6*18
	ldd	#0x19		;cc 00 19
	lds	*0x1a		;10 de*1a
	ldu	#0x1b		;ce 00 1b
	ldx	*0x1c		;9e*1c
	ldy	#0x1d		;10 8e 00 1d
	leas	-1,s		;32 7f
	leau	-1,u		;33 5f
	leax	-1,x		;30 1f
	leay	-1,y		;31 3f
	lsl	,x		;68 84
	lsla			;48
	lslb			;58
	lsr	,x		;64 84
	lsra			;44
	lsrb			;54
	mul			;3d
	neg	,x		;60 84
	nega			;40
	negb			;50
	nop			;12
	ora	*0x1e		;9a*1e
	oraa	#0x1f		;8a 1f
	orab	*0x20		;da*20
	orb	#0x21		;ca 21
	orcc	#0x22		;1a 22
	pshs	a		;34 02
	pshu	b		;36 04
	puls	x		;35 10
	pulu	y		;37 20
	rol	,x		;69 84
	rola			;49
	rolb			;59
	ror	,x		;66 84
	rora			;46
	rorb			;56
	rti			;3b
	rts			;39
	sbca	#0x23		;82 23
	sbcb	*0x24		;d2*24
	sex			;1d
	sta	,x		;a7 84
	staa	,x		;a7 84
	stab	,x		;e7 84
	stb	,x		;e7 84
	std	,x		;ed 84
	sts	,x		;10 ef 84
	stu	,x		;ef 84
	stx	,x		;af 84
	sty	,x		;10 af 84
	suba	#0x25		;80 25
	subb	*0x26		;d0*26
	subd	#0x27		;83 00 27
	swi			;3f
	swi1			;3f
	swi2			;10 3f
	swi3			;11 3f
	sync			;13
	tfr	x,y		;1f 12
	tst	,x		;6d 84
	tsta			;4d
	tstb			;5d
	

	.page
	.sbttl	Post Byte Addressing Test (numerical constants)

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

	neg	0,y		;60 20
	neg	1,y		;60 21
	neg	2,y		;60 22
	neg	3,y		;60 23
	neg	4,y		;60 24
	neg	5,y		;60 25
	neg	6,y		;60 26
	neg	7,y		;60 27
	neg	8,y		;60 28
	neg	9,y		;60 29
	neg	10,y		;60 2A
	neg	11,y		;60 2B
	neg	12,y		;60 2C
	neg	13,y		;60 2D
	neg	14,y		;60 2E
	neg	15,y		;60 2F
	neg	-16,y		;60 30
	neg	-15,y		;60 31
	neg	-14,y		;60 32
	neg	-13,y		;60 33
	neg	-12,y		;60 34
	neg	-11,y		;60 35
	neg	-10,y		;60 36
	neg	-9,y		;60 37
	neg	-8,y		;60 38
	neg	-7,y		;60 39
	neg	-6,y		;60 3A
	neg	-5,y		;60 3B
	neg	-4,y		;60 3C
	neg	-3,y		;60 3D
	neg	-2,y		;60 3E
	neg	-1,y		;60 3F

	neg	0,u		;60 40
	neg	1,u		;60 41
	neg	2,u		;60 42
	neg	3,u		;60 43
	neg	4,u		;60 44
	neg	5,u		;60 45
	neg	6,u		;60 46
	neg	7,u		;60 47
	neg	8,u		;60 48
	neg	9,u		;60 49
	neg	10,u		;60 4A
	neg	11,u		;60 4B
	neg	12,u		;60 4C
	neg	13,u		;60 4D
	neg	14,u		;60 4E
	neg	15,u		;60 4F
	neg	-16,u		;60 50
	neg	-15,u		;60 51
	neg	-14,u		;60 52
	neg	-13,u		;60 53
	neg	-12,u		;60 54
	neg	-11,u		;60 55
	neg	-10,u		;60 56
	neg	-9,u		;60 57
	neg	-8,u		;60 58
	neg	-7,u		;60 59
	neg	-6,u		;60 5A
	neg	-5,u		;60 5B
	neg	-4,u		;60 5C
	neg	-3,u		;60 5D
	neg	-2,u		;60 5E
	neg	-1,u		;60 5F

	neg	0,s		;60 60
	neg	1,s		;60 61
	neg	2,s		;60 62
	neg	3,s		;60 63
	neg	4,s		;60 64
	neg	5,s		;60 65
	neg	6,s		;60 66
	neg	7,s		;60 67
	neg	8,s		;60 68
	neg	9,s		;60 69
	neg	10,s		;60 6A
	neg	11,s		;60 6B
	neg	12,s		;60 6C
	neg	13,s		;60 6D
	neg	14,s		;60 6E
	neg	15,s		;60 6F
	neg	-16,s		;60 70
	neg	-15,s		;60 71
	neg	-14,s		;60 72
	neg	-13,s		;60 73
	neg	-12,s		;60 74
	neg	-11,s		;60 75
	neg	-10,s		;60 76
	neg	-9,s		;60 77
	neg	-8,s		;60 78
	neg	-7,s		;60 79
	neg	-6,s		;60 7A
	neg	-5,s		;60 7B
	neg	-4,s		;60 7C
	neg	-3,s		;60 7D
	neg	-2,s		;60 7E
	neg	-1,s		;60 7F

	neg	,x+		;60 80
	neg	,x++		;60 81
	neg	,-x		;60 82
	neg	,--x		;60 83
	neg	,x		;60 84
	neg	b,x		;60 85
	neg	a,x		;60 86
	neg	0x11,x		;60 88 11
	neg	0x2233,x	;60 89 22 33
	neg	d,x		;60 8b
	neg	.+0x13,pcr	;60 8c 10
	neg	.+0x1004,pcr	;60 8d 10 00
;	neg	[,x+]		;illegal
	neg	[,x++]		;60 91
;	neg	[,-x]		;illegal
	neg	[,--x]		;60 93
	neg	[,x]		;60 94
	neg	[b,x]		;60 95
	neg	[a,x]		;60 96
	neg	[0x11,x]	;60 98 11
	neg	[0x2233,x]	;60 99 22 33
	neg	[d,x]		;60 9b
	neg	[.+0x13,pcr]	;60 9c 10
	neg	[.+0x1004,pcr]	;60 9d 10 00
	neg	[0x2233]	;60 9f 22 33

	neg	,y+		;60 a0
	neg	,y++		;60 a1
	neg	,-y		;60 a2
	neg	,--y		;60 a3
	neg	,y		;60 a4
	neg	b,y		;60 a5
	neg	a,y		;60 a6
	neg	0x11,y		;60 a8 11
	neg	0x2233,y	;60 a9 22 33
	neg	d,y		;60 ab
;	neg	.+0x13,pcr	;60 ac 10
;	neg	.+0x1004,pcr	;60 ad 10 00
;	neg	[,y+]		;illegal
	neg	[,y++]		;60 b1
;	neg	[,-y]		;illegal
	neg	[,--y]		;60 b3
	neg	[,y]		;60 b4
	neg	[b,y]		;60 b5
	neg	[a,y]		;60 b6
	neg	[0x11,y]	;60 b8 11
	neg	[0x2233,y]	;60 b9 22 33
	neg	[d,x]		;60 9b
;	neg	[.+0x13,pcr]	;60 bc 10
;	neg	[.+0x1004,pcr]	;60 bd 10 00
;	neg	[0x2233]	;60 bf 22 33

	neg	,u+		;60 c0
	neg	,u++		;60 c1
	neg	,-u		;60 c2
	neg	,--u		;60 c3
	neg	,u		;60 c4
	neg	b,u		;60 c5
	neg	a,u		;60 c6
	neg	0x11,u		;60 c8 11
	neg	0x2233,u	;60 c9 22 33
	neg	d,u		;60 cb
;	neg	.+0x13,pcr	;60 cc 10
;	neg	.+0x1004,pcr	;60 cd 10 00
;	neg	[,u+]		;illegal
	neg	[,u++]		;60 d1
;	neg	[,-u]		;illegal
	neg	[,--u]		;60 d3
	neg	[,u]		;60 d4
	neg	[b,u]		;60 d5
	neg	[a,u]		;60 d6
	neg	[0x11,u]	;60 d8 11
	neg	[0x2233,u]	;60 d9 22 33
	neg	[d,u]		;60 db
;	neg	[.+0x13,pcr]	;60 dc 10
;	neg	[.+0x1004,pcr]	;60 dd 10 00
;	neg	[0x2233]	;60 df 22 33

	neg	,s+		;60 e0
	neg	,s++		;60 e1
	neg	,-s		;60 e2
	neg	,--s		;60 e3
	neg	,s		;60 e4
	neg	b,s		;60 e5
	neg	a,s		;60 e6
	neg	0x11,s		;60 e8 11
	neg	0x2233,s	;60 e9 22 33
	neg	d,s		;60 eb
;	neg	.+0x13,pcr	;60 ec 10
;	neg	.+0x1004,pcr	;60 ed 10 00
;	neg	[,s+]		;illegal
	neg	[,s++]		;60 f1
;	neg	[,-s]		;illegal
	neg	[,--s]		;60 f3
	neg	[,s]		;60 f4
	neg	[b,s]		;60 f5
	neg	[a,s]		;60 f6
	neg	[0x11,s]	;60 f8 11
	neg	[0x2233,s]	;60 f9 22 33
	neg	[d,s]		;60 fb
;	neg	[.+0x13,pcr]	;60 fc 10
;	neg	[.+0x1004,pcr]	;60 fd 10 00
;	neg	[0x2233]	;60 ff 22 33



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

	neg	num0,y		;60 20
	neg	num1,y		;60 21
	neg	num2,y		;60 22
	neg	num3,y		;60 23
	neg	num4,y		;60 24
	neg	num5,y		;60 25
	neg	num6,y		;60 26
	neg	num7,y		;60 27
	neg	num8,y		;60 28
	neg	num9,y		;60 29
	neg	num10,y		;60 2A
	neg	num11,y		;60 2B
	neg	num12,y		;60 2C
	neg	num13,y		;60 2D
	neg	num14,y		;60 2E
	neg	num15,y		;60 2F
	neg	-num16,y	;60 30
	neg	-num15,y	;60 31
	neg	-num14,y	;60 32
	neg	-num13,y	;60 33
	neg	-num12,y	;60 34
	neg	-num11,y	;60 35
	neg	-num10,y	;60 36
	neg	-num9,y		;60 37
	neg	-num8,y		;60 38
	neg	-num7,y		;60 39
	neg	-num6,y		;60 3A
	neg	-num5,y		;60 3B
	neg	-num4,y		;60 3C
	neg	-num3,y		;60 3D
	neg	-num2,y		;60 3E
	neg	-num1,y		;60 3F

	neg	num0,u		;60 40
	neg	num1,u		;60 41
	neg	num2,u		;60 42
	neg	num3,u		;60 43
	neg	num4,u		;60 44
	neg	num5,u		;60 45
	neg	num6,u		;60 46
	neg	num7,u		;60 47
	neg	num8,u		;60 48
	neg	num9,u		;60 49
	neg	num10,u		;60 4A
	neg	num11,u		;60 4B
	neg	num12,u		;60 4C
	neg	num13,u		;60 4D
	neg	num14,u		;60 4E
	neg	num15,u		;60 4F
	neg	-num16,u	;60 50
	neg	-num15,u	;60 51
	neg	-num14,u	;60 52
	neg	-num13,u	;60 53
	neg	-num12,u	;60 54
	neg	-num11,u	;60 55
	neg	-num10,u	;60 56
	neg	-num9,u		;60 57
	neg	-num8,u		;60 58
	neg	-num7,u		;60 59
	neg	-num6,u		;60 5A
	neg	-num5,u		;60 5B
	neg	-num4,u		;60 5C
	neg	-num3,u		;60 5D
	neg	-num2,u		;60 5E
	neg	-num1,u		;60 5F

	neg	num0,s		;60 60
	neg	num1,s		;60 61
	neg	num2,s		;60 62
	neg	num3,s		;60 63
	neg	num4,s		;60 64
	neg	num5,s		;60 65
	neg	num6,s		;60 66
	neg	num7,s		;60 67
	neg	num8,s		;60 68
	neg	num9,s		;60 69
	neg	num10,s		;60 6A
	neg	num11,s		;60 6B
	neg	num12,s		;60 6C
	neg	num13,s		;60 6D
	neg	num14,s		;60 6E
	neg	num15,s		;60 6F
	neg	-num16,s	;60 70
	neg	-num15,s	;60 71
	neg	-num14,s	;60 72
	neg	-num13,s	;60 73
	neg	-num12,s	;60 74
	neg	-num11,s	;60 75
	neg	-num10,s	;60 76
	neg	-num9,s		;60 77
	neg	-num8,s		;60 78
	neg	-num7,s		;60 79
	neg	-num6,s		;60 7A
	neg	-num5,s		;60 7B
	neg	-num4,s		;60 7C
	neg	-num3,s		;60 7D
	neg	-num2,s		;60 7E
	neg	-num1,s		;60 7F

	neg	,x+		;60 80
	neg	,x++		;60 81
	neg	,-x		;60 82
	neg	,--x		;60 83
	neg	,x		;60 84
	neg	b,x		;60 85
	neg	a,x		;60 86
	neg	nn,x		;60 88 11
	neg	mmnn,x		;60 89 22 33
	neg	d,x		;60 8b
	neg	.+0x13,pcr	;60 8c 10
	neg	.+0x1004,pcr	;60 8d 10 00
;	neg	[,x+]		;illegal
	neg	[,x++]		;60 91
;	neg	[,-x]		;illegal
	neg	[,--x]		;60 93
	neg	[,x]		;60 94
	neg	[b,x]		;60 95
	neg	[a,x]		;60 96
	neg	[nn,x]		;60 98 11
	neg	[mmnn,x]	;60 99 22 33
	neg	[d,x]		;60 9b
	neg	[.+0x13,pcr]	;60 9c 10
	neg	[.+0x1004,pcr]	;60 9d 10 00
	neg	[mmnn]		;60 9f 22 33

	neg	,y+		;60 a0
	neg	,y++		;60 a1
	neg	,-y		;60 a2
	neg	,--y		;60 a3
	neg	,y		;60 a4
	neg	b,y		;60 a5
	neg	a,y		;60 a6
	neg	nn,y		;60 a8 11
	neg	mmnn,y		;60 a9 22 33
	neg	d,y		;60 ab
;	neg	.+0x13,pcr	;60 ac 10
;	neg	.+0x1004,pcr	;60 ad 10 00
;	neg	[,y+]		;illegal
	neg	[,y++]		;60 b1
;	neg	[,-y]		;illegal
	neg	[,--y]		;60 b3
	neg	[,y]		;60 b4
	neg	[b,y]		;60 b5
	neg	[a,y]		;60 b6
	neg	[nn,y]		;60 b8 11
	neg	[mmnn,y]	;60 b9 22 33
	neg	[d,x]		;60 9b
;	neg	[.+0x13,pcr]	;60 bc 10
;	neg	[.+0x1004,pcr]	;60 bd 10 00
;	neg	[mmnn]		;60 bf 22 33

	neg	,u+		;60 c0
	neg	,u++		;60 c1
	neg	,-u		;60 c2
	neg	,--u		;60 c3
	neg	,u		;60 c4
	neg	b,u		;60 c5
	neg	a,u		;60 c6
	neg	nn,u		;60 c8 11
	neg	mmnn,u		;60 c9 22 33
	neg	d,u		;60 cb
;	neg	.+0x13,pcr	;60 cc 10
;	neg	.+0x1004,pcr	;60 cd 10 00
;	neg	[,u+]		;illegal
	neg	[,u++]		;60 d1
;	neg	[,-u]		;illegal
	neg	[,--u]		;60 d3
	neg	[,u]		;60 d4
	neg	[b,u]		;60 d5
	neg	[a,u]		;60 d6
	neg	[nn,u]		;60 d8 11
	neg	[mmnn,u]	;60 d9 22 33
	neg	[d,u]		;60 db
;	neg	[.+0x13,pcr]	;60 dc 10
;	neg	[.+0x1004,pcr]	;60 dd 10 00
;	neg	[mmnn]		;60 df 22 33

	neg	,s+		;60 e0
	neg	,s++		;60 e1
	neg	,-s		;60 e2
	neg	,--s		;60 e3
	neg	,s		;60 e4
	neg	b,s		;60 e5
	neg	a,s		;60 e6
	neg	nn,s		;60 e8 11
	neg	mmnn,s		;60 e9 22 33
	neg	d,s		;60 eb
;	neg	.+0x13,pcr	;60 ec 10
;	neg	.+0x1004,pcr	;60 ed 10 00
;	neg	[,s+]		;illegal
	neg	[,s++]		;60 f1
;	neg	[,-s]		;illegal
	neg	[,--s]		;60 f3
	neg	[,s]		;60 f4
	neg	[b,s]		;60 f5
	neg	[a,s]		;60 f6
	neg	[nn,s]		;60 f8 11
	neg	[mmnn,s]	;60 f9 22 33
	neg	[d,s]		;60 fb
;	neg	[.+0x13,pcr]	;60 fc 10
;	neg	[.+0x1004,pcr]	;60 fd 10 00
;	neg	[mmnn]		;60 ff 22 33



	.page
	.sbttl	Defined constants

	nn	=	0x11
	mmnn	=	0x2233

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

	neg	num0,y		;60 20
	neg	num1,y		;60 21
	neg	num2,y		;60 22
	neg	num3,y		;60 23
	neg	num4,y		;60 24
	neg	num5,y		;60 25
	neg	num6,y		;60 26
	neg	num7,y		;60 27
	neg	num8,y		;60 28
	neg	num9,y		;60 29
	neg	num10,y		;60 2A
	neg	num11,y		;60 2B
	neg	num12,y		;60 2C
	neg	num13,y		;60 2D
	neg	num14,y		;60 2E
	neg	num15,y		;60 2F
	neg	-num16,y	;60 30
	neg	-num15,y	;60 31
	neg	-num14,y	;60 32
	neg	-num13,y	;60 33
	neg	-num12,y	;60 34
	neg	-num11,y	;60 35
	neg	-num10,y	;60 36
	neg	-num9,y		;60 37
	neg	-num8,y		;60 38
	neg	-num7,y		;60 39
	neg	-num6,y		;60 3A
	neg	-num5,y		;60 3B
	neg	-num4,y		;60 3C
	neg	-num3,y		;60 3D
	neg	-num2,y		;60 3E
	neg	-num1,y		;60 3F

	neg	num0,u		;60 40
	neg	num1,u		;60 41
	neg	num2,u		;60 42
	neg	num3,u		;60 43
	neg	num4,u		;60 44
	neg	num5,u		;60 45
	neg	num6,u		;60 46
	neg	num7,u		;60 47
	neg	num8,u		;60 48
	neg	num9,u		;60 49
	neg	num10,u		;60 4A
	neg	num11,u		;60 4B
	neg	num12,u		;60 4C
	neg	num13,u		;60 4D
	neg	num14,u		;60 4E
	neg	num15,u		;60 4F
	neg	-num16,u	;60 50
	neg	-num15,u	;60 51
	neg	-num14,u	;60 52
	neg	-num13,u	;60 53
	neg	-num12,u	;60 54
	neg	-num11,u	;60 55
	neg	-num10,u	;60 56
	neg	-num9,u		;60 57
	neg	-num8,u		;60 58
	neg	-num7,u		;60 59
	neg	-num6,u		;60 5A
	neg	-num5,u		;60 5B
	neg	-num4,u		;60 5C
	neg	-num3,u		;60 5D
	neg	-num2,u		;60 5E
	neg	-num1,u		;60 5F

	neg	num0,s		;60 60
	neg	num1,s		;60 61
	neg	num2,s		;60 62
	neg	num3,s		;60 63
	neg	num4,s		;60 64
	neg	num5,s		;60 65
	neg	num6,s		;60 66
	neg	num7,s		;60 67
	neg	num8,s		;60 68
	neg	num9,s		;60 69
	neg	num10,s		;60 6A
	neg	num11,s		;60 6B
	neg	num12,s		;60 6C
	neg	num13,s		;60 6D
	neg	num14,s		;60 6E
	neg	num15,s		;60 6F
	neg	-num16,s	;60 70
	neg	-num15,s	;60 71
	neg	-num14,s	;60 72
	neg	-num13,s	;60 73
	neg	-num12,s	;60 74
	neg	-num11,s	;60 75
	neg	-num10,s	;60 76
	neg	-num9,s		;60 77
	neg	-num8,s		;60 78
	neg	-num7,s		;60 79
	neg	-num6,s		;60 7A
	neg	-num5,s		;60 7B
	neg	-num4,s		;60 7C
	neg	-num3,s		;60 7D
	neg	-num2,s		;60 7E
	neg	-num1,s		;60 7F

	neg	,x+		;60 80
	neg	,x++		;60 81
	neg	,-x		;60 82
	neg	,--x		;60 83
	neg	,x		;60 84
	neg	b,x		;60 85
	neg	a,x		;60 86
	neg	nn,x		;60 88 11
	neg	mmnn,x		;60 89 22 33
	neg	d,x		;60 8b
	neg	.+0x13,pcr	;60 8c 10
	neg	.+0x1004,pcr	;60 8d 10 00
;	neg	[,x+]		;illegal
	neg	[,x++]		;60 91
;	neg	[,-x]		;illegal
	neg	[,--x]		;60 93
	neg	[,x]		;60 94
	neg	[b,x]		;60 95
	neg	[a,x]		;60 96
	neg	[nn,x]		;60 98 11
	neg	[mmnn,x]	;60 99 22 33
	neg	[d,x]		;60 9b
	neg	[.+0x13,pcr]	;60 9c 10
	neg	[.+0x1004,pcr]	;60 9d 10 00
	neg	[mmnn]		;60 9f 22 33

	neg	,y+		;60 a0
	neg	,y++		;60 a1
	neg	,-y		;60 a2
	neg	,--y		;60 a3
	neg	,y		;60 a4
	neg	b,y		;60 a5
	neg	a,y		;60 a6
	neg	nn,y		;60 a8 11
	neg	mmnn,y		;60 a9 22 33
	neg	d,y		;60 ab
;	neg	.+0x13,pcr	;60 ac 10 10
;	neg	.+0x1004,pcr	;60 ad 10 00
;	neg	[,y+]		;illegal
	neg	[,y++]		;60 b1
;	neg	[,-y]		;illegal
	neg	[,--y]		;60 b3
	neg	[,y]		;60 b4
	neg	[b,y]		;60 b5
	neg	[a,y]		;60 b6
	neg	[nn,y]		;60 b8 11
	neg	[mmnn,y]	;60 b9 22 33
	neg	[d,x]		;60 9b
;	neg	[.+0x13,pcr]	;60 bc 10
;	neg	[.+0x1004,pcr]	;60 bd 10 00
;	neg	[mmnn]		;60 bf 22 33

	neg	,u+		;60 c0
	neg	,u++		;60 c1
	neg	,-u		;60 c2
	neg	,--u		;60 c3
	neg	,u		;60 c4
	neg	b,u		;60 c5
	neg	a,u		;60 c6
	neg	nn,u		;60 c8 11
	neg	mmnn,u		;60 c9 22 33
	neg	d,u		;60 cb
;	neg	.+0x13,pcr	;60 cc 10
;	neg	.+0x1004,pcr	;60 cd 10 00
;	neg	[,u+]		;illegal
	neg	[,u++]		;60 d1
;	neg	[,-u]		;illegal
	neg	[,--u]		;60 d3
	neg	[,u]		;60 d4
	neg	[b,u]		;60 d5
	neg	[a,u]		;60 d6
	neg	[nn,u]		;60 d8 11
	neg	[mmnn,u]	;60 d9 22 33
	neg	[d,u]		;60 db
;	neg	[.+0x13,pcr]	;60 dc 10
;	neg	[.+0x1004,pcr]	;60 dd 10 00
;	neg	[mmnn]		;60 df 22 33

	neg	,s+		;60 e0
	neg	,s++		;60 e1
	neg	,-s		;60 e2
	neg	,--s		;60 e3
	neg	,s		;60 e4
	neg	b,s		;60 e5
	neg	a,s		;60 e6
	neg	nn,s		;60 e8 11
	neg	mmnn,s		;60 e9 22 33
	neg	d,s		;60 eb
;	neg	.+0x13,pcr	;60 ec 10
;	neg	.+0x1004,pcr	;60 ed 10 00
;	neg	[,s+]		;illegal
	neg	[,s++]		;60 f1
;	neg	[,-s]		;illegal
	neg	[,--s]		;60 f3
	neg	[,s]		;60 f4
	neg	[b,s]		;60 f5
	neg	[a,s]		;60 f6
	neg	[nn,s]		;60 f8 11
	neg	[mmnn,s]	;60 f9 22 33
	neg	[d,s]		;60 fb
;	neg	[.+0x13,pcr]	;60 fc 10
;	neg	[.+0x1004,pcr]	;60 fd 10 00
;	neg	[mmnn]		;60 ff 22 33



	.page
	.sbttl	push/pull instructions


	pshu	cc			;36 01
	pshu	cc,a			;36 03
	pshu	cc,a,b			;36 07
	pshu	cc,a,b,dp		;36 0f
	pshu	cc,a,b,dp,x		;36 1f
	pshu	cc,a,b,dp,x,y		;36 3f
	pshu	cc,a,b,dp,x,y,s		;36 7f
	pshu	cc,a,b,dp,x,y,s,pc	;36 ff

	pshs	cc			;34 01
	pshs	cc,a			;34 03
	pshs	cc,a,b			;34 07
	pshs	cc,a,b,dp		;34 0f
	pshs	cc,a,b,dp,x		;34 1f
	pshs	cc,a,b,dp,x,y		;34 3f
	pshs	cc,a,b,dp,x,y,u		;34 7f
	pshs	cc,a,b,dp,x,y,u,pc	;34 ff

	pulu	cc			;37 01
	pulu	cc,a			;37 03
	pulu	cc,a,b			;37 07
	pulu	cc,a,b,dp		;37 0f
	pulu	cc,a,b,dp,x		;37 1f
	pulu	cc,a,b,dp,x,y		;37 3f
	pulu	cc,a,b,dp,x,y,s		;37 7f
	pulu	cc,a,b,dp,x,y,s,pc	;37 ff

	puls	cc			;35 01
	puls	cc,a			;35 03
	puls	cc,a,b			;35 07
	puls	cc,a,b,dp		;35 0f
	puls	cc,a,b,dp,x		;35 1f
	puls	cc,a,b,dp,x,y		;35 3f
	puls	cc,a,b,dp,x,y,u		;35 7f
	puls	cc,a,b,dp,x,y,u,pc	;35 ff


	.page
	.sbttl	6800 compatibility instuctions with 6809 equivalents

	aba		;34 04 ab e0
	pshs	b	;34 04
	adda	,s+	;ab e0

	cba		;34 04 a1 e0
	pshs	b	;34 04
	cmpa	,s+	;a1 e0

	clc		;1c fe
	andcc	#0xFE	;1c fe

	cli		;1c ef
	andcc	#0xEF	;1c ef

	clv		;1c fd
	andcc	#0xFD	;1c fd

	des		;32 7f
	leas	-1,s	;32 7f

	dex		;30 1f
	leax	-1,x	;30 1f

	ins		;32 61
	leas	1,s	;32 61

	inx		;30 01
	leax	1,x	;30 01

	psha		;34 02
	pshs	a	;34 02

	pshb		;34 04
	pshs	b	;34 04

	pula		;35 02
	puls	a	;35 02

	pulb		;35 04
	puls	b	;35 04

	sba		;34 04 a0 e0
	pshs	b	;34 04
	suba	,s+	;a0 e0

	sec		;1a 01
	orcc	#0x01	;1a 01

	sei		;1a 10
	orcc	#0x10	;1a 10

	sev		;1a 02
	orcc	#0x02	;1a 02

	tab		;1f 89 4d
	tfr	a,b	;1f 89
	tsta		;4d

	tap		;1f 8a
	tfr	a,cc	;1f 8a

	tba		;1f 98 5d
	tfr	b,a	;1f 98
	tstb		;5d

	tpa		;1f a8
	tfr	cc,a	;1f a8

	tsx		;1f 41
	tfr	s,x	;1f 41

	txs		;1f 14
	tfr	x,s	;1f 14

	wai		;3c ff
	cwai	#0xFF	;3c ff


