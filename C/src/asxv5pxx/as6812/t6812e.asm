	.title	68HC12 Assembler Error Test

	.sbttl	All 6812 Instruction Error Modes

	; every instruction in this file causes an error -
	; a, q, or r
	;
	; errors reflect unsupported or illegal addressing modes


	.setdp	0,_CODE

	msk = 0x10

	imm = 0xA5
	dir = 0x22
	ext = 0x1234
	idx = 0x01
	idx1 = 0x00FF
	idx2 = 0x5678

	.globl	extern		; an external label

	.area	t6812

	asl	#imm

	asr	#imm

	bclr	#imm,msk
	bclr	[d,x],msk
	bclr	[idx2,x],msk

	brclr	#imm,msk,.+6
	brclr	[d,x],msk,.+6
	brclr	[idx2,x],msk,.+6

	brset	#imm,msk,.+6
	brset	[d,x],msk,.+6
	brset	[idx2,x],msk,.+6

	bset	#imm,msk
	bset	[d,x],msk
	bset	[idx2,x],msk

	call	#imm,#0x34

	clr	#imm

	com	#imm

	dbeq	a,extern
	dbeq	a,*dir

	dbne	a,extern
	dbne	a,*dir

	emaxd	#imm
	emaxd	*dir
	emaxd	ext

	emaxm	#imm
	emaxm	*dir
	emaxm	ext

	emind	#imm
	emind	*dir
	emind	ext

	eminm	#imm
	eminm	*dir
	eminm	ext

	etbl	#imm
	etbl	*dir
	etbl	ext
	etbl	[d,x]
	etbl	[idx2,x]

	ibeq	a,extern
	ibeq	a,*dir

	ibne	a,extern
	ibne	a,*dir

	inc	#imm

	jmp	#imm

	jsr	#imm

	leas	#imm
	leas	*dir
	leas	ext
	leas	[d,x]
	leas	[idx2,x]

	leax	#imm
	leax	*dir
	leax	ext
	leax	[d,x]
	leax	[idx2,x]

	leay	#imm
	leay	*dir
	leay	ext
	leay	[d,x]
	leay	[idx2,x]

	lsl	#imm

	lsr	#imm

	maxa	#imm
	maxa	*dir
	maxa	ext

	maxm	#imm
	maxm	*dir
	maxm	ext

	mina	#imm
	mina	*dir
	mina	ext

	minm	#imm
	minm	*dir
	minm	ext

	movb	#imm,	#imm
	movb	#imm,	idx1,x
	movb	#imm,	[idx2,x]
	movb	#imm,	[d,x]

	movw	#imm,	#imm
	movw	#imm,	idx1,x
	movw	#imm,	[idx2,x]
	movw	#imm,	[d,x]

	neg	#imm

	rol	#imm

	ror	#imm

	sta	#imm
	staa	#imm

	stab	#imm
	stb	#imm

	std	#imm

	sts	#imm

	stx	#imm

	sty	#imm

	tbeq	a,extern
	tbeq	a,*dir

	tbl	#imm
	tbl	*dir
	tbl	ext
	tbl	idx1,x
	tbl	[d,x]
	tbl	[idx2,x]

	tbne	a,extern
	tbne	a,*dir

	tst	#imm

	;  Valid Sign Extend Modes

	sex	a,a
	sex	a,b
	sex	a,ccr
;	sex	a,t2
;	sex	a,d
;	sex	a,x
;	sex	a,y
;	sex	a,sp
	sex	b,a
	sex	b,b
	sex	b,ccr
;	sex	b,t2
;	sex	b,d
;	sex	b,x
;	sex	b,y
;	sex	b,sp
	sex	ccr,a
	sex	ccr,b
	sex	ccr,ccr
;	sex	ccr,t2
;	sex	ccr,d
;	sex	ccr,x
;	sex	ccr,y
;	sex	ccr,sp
	sex	t3,a
	sex	t3,b
	sex	t3,ccr
	sex	t3,t2
	sex	t3,d
	sex	t3,x
	sex	t3,y
	sex	t3,sp
	sex	b,a
	sex	b,b
	sex	b,ccr
	sex	d,t2
	sex	d,d
	sex	d,x
	sex	d,y
	sex	d,sp
	sex	x,a
	sex	x,b
	sex	x,ccr
	sex	x,t2
	sex	x,d
	sex	x,x
	sex	x,y
	sex	x,sp
	sex	y,a
	sex	y,b
	sex	y,ccr
	sex	y,t2
	sex	y,d
	sex	y,x
	sex	y,y
	sex	y,sp
	sex	sp,a
	sex	sp,b
	sex	sp,ccr
	sex	sp,t2
	sex	sp,d
	sex	sp,x
	sex	sp,y
	sex	sp,sp

