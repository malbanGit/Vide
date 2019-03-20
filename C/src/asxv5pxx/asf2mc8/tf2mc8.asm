	.title Test Module for the Fujitsu F2MC8 processor

	.radix h

	.page
	.sbttl	All values are local constants

	dir	= 0x33			; direct address
	ext	= 0x1234		; extended address
	off	= 0x44			; indexed offset

	v22	= 0x22			; constants
	v5678	= 0x5678

	b0	= 0			; Bit Positions
	b1	= 1
	b2	= 2
	b3	= 3
	b4	= 4
	b5	= 5
	b6	= 6
	b7	= 7

	v0	= 0			; CALLV vectors
	v1	= 1
	v2	= 2
	v3	= 3
	v4	= 4
	v5	= 5
	v6	= 6
	v7	= 7

	.page
	.sbttl	F2MC8L Mode

	; Sequencial Opcodes for F2MC8L

	.F2MC8L

	nop				; 00
	mulu	a			; 01
	rolc	a			; 02
	rorc	a			; 03
	mov	a,#v22			; 04 22
	mov	a,*dir			; 05 33
	mov	a,@ix+off		; 06 44
	mov	a,@ep			; 07
	mov	a,r0			; 08
	mov	a,r1			; 09
	mov	a,r2			; 0A
	mov	a,r3			; 0B
	mov	a,r4			; 0C
	mov	a,r5			; 0D
	mov	a,r6			; 0E
	mov	a,r7			; 0F

	swap				; 10
	divu	a			; 11
	cmp	a			; 12
	cmpw	a			; 13
	cmp	a,#v22			; 14 22
	cmp	a,*dir			; 15 33
	cmp	a,@ix+off		; 16 44
	cmp	a,@ep			; 17
	cmp	a,r0			; 18
	cmp	a,r1			; 19
	cmp	a,r2			; 1A
	cmp	a,r3			; 1B
	cmp	a,r4			; 1C
	cmp	a,r5			; 1D
	cmp	a,r6			; 1E
	cmp	a,r7			; 1F

	ret				; 20
	jmp	ext			; 21 12 34
	addc	a			; 22
	addcw	a			; 23
	addc	a,#v22			; 24 22
	addc	a,*dir			; 25 33
	addc	a,@ix+off		; 26 44
	addc	a,@ep			; 27
	addc	a,r0			; 28
	addc	a,r1			; 29
	addc	a,r2			; 2A
	addc	a,r3			; 2B
	addc	a,r4			; 2C
	addc	a,r5			; 2D
	addc	a,r6			; 2E
	addc	a,r7			; 2F

	reti				; 30
	call	ext			; 31 12 34
	subc	a			; 32
	subcw	a			; 33
	subc	a,#v22			; 34 22
	subc	a,*dir			; 35 33
	subc	a,@ix+off		; 36 44
	subc	a,@ep			; 37
	subc	a,r0			; 38
	subc	a,r1			; 39
	subc	a,r2			; 3A
	subc	a,r3			; 3B
	subc	a,r4			; 3C
	subc	a,r5			; 3D
	subc	a,r6			; 3E
	subc	a,r7			; 3F

	pushw	a			; 40
	pushw	ix			; 41
	xch	a,t			; 42
	xchw	a,t			; 43
	;
	mov	*dir,a			; 45 33
	mov	@ix+off,a		; 46 44
	mov	@ep,a			; 47
	mov	r0,a			; 48
	mov	r1,a			; 49
	mov	r2,a			; 4A
	mov	r3,a			; 4B
	mov	r4,a			; 4C
	mov	r5,a			; 4D
	mov	r6,a			; 4E
	mov	r7,a			; 4F

	popw	a			; 50
	popw	ix			; 51
	xor	a			; 52
	xorw	a			; 53
	xor	a,#v22			; 54 22
	xor	a,*dir			; 55 33
	xor	a,@ix+off		; 56 44
	xor	a,@ep			; 57
	xor	a,r0			; 58
	xor	a,r1			; 59
	xor	a,r2			; 5A
	xor	a,r3			; 5B
	xor	a,r4			; 5C
	xor	a,r5			; 5D
	xor	a,r6			; 5E
	xor	a,r7			; 5F

	mov	a,ext			; 60 12 34
	mov	ext,a			; 61 12 34
	and	a			; 62
	andw	a			; 63
	and	a,#v22			; 64 22
	and	a,*dir			; 65 33
	and	a,@ix+off		; 66 44
	and	a,@ep			; 67
	and	a,r0			; 68
	and	a,r1			; 69
	and	a,r2			; 6A
	and	a,r3			; 6B
	and	a,r4			; 6C
	and	a,r5			; 6D
	and	a,r6			; 6E
	and	a,r7			; 6F

	movw	a,ps			; 70
	movw	ps,a			; 71
	or	a			; 72
	orw	a			; 73
	or	a,#v22			; 74 22
	or	a,*dir			; 75 33
	or	a,@ix+off		; 76 44
	or	a,@ep			; 77
	or	a,r0			; 78
	or	a,r1			; 79
	or	a,r2			; 7A
	or	a,r3			; 7B
	or	a,r4			; 7C
	or	a,r5			; 7D
	or	a,r6			; 7E
	or	a,r7			; 7F

	clri				; 80
	clrc				; 81
	mov	@a,t			; 82
	movw	@a,t			; 83
	daa				; 84
	mov	*dir,#v22		; 85 33 22
	mov	@ix+off,#v22		; 86 44 22
	mov	@ep,#v22		; 87 22
	mov	r0,#v22			; 88 22
	mov	r1,#v22			; 89 22
	mov	r2,#v22			; 8A 22
	mov	r3,#v22			; 8B 22
	mov	r4,#v22			; 8C 22
	mov	r5,#v22			; 8D 22
	mov	r6,#v22			; 8E 22
	mov	r7,#v22			; 8F 22

	seti				; 90
	setc				; 91
	mov	a,@a			; 92
	movw	a,@a			; 93
	das				; 94
	cmp	*dir,#v22		; 95 33 22
	cmp	@ix+off,#v22		; 96 44 22
	cmp	@ep,#v22		; 97 22
	cmp	r0,#v22			; 98 22
	cmp	r1,#v22			; 99 22
	cmp	r2,#v22			; 9A 22
	cmp	r3,#v22			; 9B 22
	cmp	r4,#v22			; 9C 22
	cmp	r5,#v22			; 9D 22
	cmp	r6,#v22			; 9E 22
	cmp	r7,#v22			; 9F 22

	clrb	*dir:b0			; A0 33
	clrb	*dir:b1			; A1 33
	clrb	*dir:b2			; A2 33
	clrb	*dir:b3			; A3 33
	clrb	*dir:b4			; A4 33
	clrb	*dir:b5			; A5 33
	clrb	*dir:b6			; A6 33
	clrb	*dir:b7			; A7 33
	setb	*dir:b0			; A8 33
	setb	*dir:b1			; A9 33
	setb	*dir:b2			; AA 33
	setb	*dir:b3			; AB 33
	setb	*dir:b4			; AC 33
	setb	*dir:b5			; AD 33
	setb	*dir:b6			; AE 33
	setb	*dir:b7			; AF 33

	bbc	*dir:b0,.		; B0 33 FD
	bbc	*dir:b1,.		; B1 33 FD
	bbc	*dir:b2,.		; B2 33 FD
	bbc	*dir:b3,.		; B3 33 FD
	bbc	*dir:b4,.		; B4 33 FD
	bbc	*dir:b5,.		; B5 33 FD
	bbc	*dir:b6,.		; B6 33 FD
	bbc	*dir:b7,.		; B7 33 FD
	bbs	*dir:b0,.		; B8 33 FD
	bbs	*dir:b1,.		; B9 33 FD
	bbs	*dir:b2,.		; BA 33 FD
	bbs	*dir:b3,.		; BB 33 FD
	bbs	*dir:b4,.		; BC 33 FD
	bbs	*dir:b5,.		; BD 33 FD
	bbs	*dir:b6,.		; BE 33 FD
	bbs	*dir:b7,.		; BF 33 FD

	incw	a			; C0
	incw	sp			; C1
	incw	ix			; C2
	incw	ep			; C3
	movw	a,ext			; C4 12 34
	movw	a,*dir			; C5 33
	movw	a,@ix+off		; C6 44
	movw	a,@ep			; C7
	inc	r0			; C8
	inc	r1			; C9
	inc	r2			; CA
	inc	r3			; CB
	inc	r4			; CC
	inc	r5			; CD
	inc	r6			; CE
	inc	r7			; CF

	decw	a			; D0
	decw	sp			; D1
	decw	ix			; D2
	decw	ep			; D3
	movw	ext,a			; D4 12 34
	movw	*dir,a			; D5 33
	movw	@ix+off,a		; D6 44
	movw	@ep,a			; D7
	dec	r0			; D8
	dec	r1			; D9
	dec	r2			; DA
	dec	r3			; DB
	dec	r4			; DC
	dec	r5			; DD
	dec	r6			; DE
	dec	r7			; DF

	jmp	@a			; E0
	movw	sp,a			; E1
	movw	ix,a			; E2
	movw	ep,a			; E3
	movw	a,#v5678		; E4 56 78
	movw	sp,#v5678		; E5 56 78
	movw	ix,#v5678		; E6 56 78
	movw	ep,#v5678		; E7 56 78
	callv	#0			; E8
	callv	#1			; E9
	callv	#2			; EA
	callv	#3			; EB
	callv	#4			; EC
	callv	#5			; ED
	callv	#6			; EE
	callv	#7			; EF

	movw	a,pc			; F0
	movw	a,sp			; F1
	movw	a,ix			; F2
	movw	a,ep			; F3
	xchw	a,pc			; F4
	xchw	a,sp			; F5
	xchw	a,ix			; F6
	xchw	a,ep			; F7
	bnc	.+2			; F8 00
	bc	.+3			; F9 01
	bp	.+4			; FA 02
	bn	.+5			; FB 03
	bnz	.+6			; FC 04
	bz	.+7			; FD 05
	bge	.+8			; FE 06
	blt	.+9			; FF 07


	; Sequencial Opcodes for F2MC8FX

	.F2MC8FX

	nop				; 00
	mulu	a			; 01
	rolc	a			; 02
	rorc	a			; 03
	mov	a,#v22			; 04 22
	mov	a,*dir			; 05 33
	mov	a,@ix+off		; 06 44
	mov	a,@ep			; 07
	mov	a,r0			; 08
	mov	a,r1			; 09
	mov	a,r2			; 0A
	mov	a,r3			; 0B
	mov	a,r4			; 0C
	mov	a,r5			; 0D
	mov	a,r6			; 0E
	mov	a,r7			; 0F

	swap				; 10
	divu	a			; 11
	cmp	a			; 12
	cmpw	a			; 13
	cmp	a,#v22			; 14 22
	cmp	a,*dir			; 15 33
	cmp	a,@ix+off		; 16 44
	cmp	a,@ep			; 17
	cmp	a,r0			; 18
	cmp	a,r1			; 19
	cmp	a,r2			; 1A
	cmp	a,r3			; 1B
	cmp	a,r4			; 1C
	cmp	a,r5			; 1D
	cmp	a,r6			; 1E
	cmp	a,r7			; 1F

	ret				; 20
	jmp	ext			; 21 12 34
	addc	a			; 22
	addcw	a			; 23
	addc	a,#v22			; 24 22
	addc	a,*dir			; 25 33
	addc	a,@ix+off		; 26 44
	addc	a,@ep			; 27
	addc	a,r0			; 28
	addc	a,r1			; 29
	addc	a,r2			; 2A
	addc	a,r3			; 2B
	addc	a,r4			; 2C
	addc	a,r5			; 2D
	addc	a,r6			; 2E
	addc	a,r7			; 2F

	reti				; 30
	call	ext			; 31 12 34
	subc	a			; 32
	subcw	a			; 33
	subc	a,#v22			; 34 22
	subc	a,*dir			; 35 33
	subc	a,@ix+off		; 36 44
	subc	a,@ep			; 37
	subc	a,r0			; 38
	subc	a,r1			; 39
	subc	a,r2			; 3A
	subc	a,r3			; 3B
	subc	a,r4			; 3C
	subc	a,r5			; 3D
	subc	a,r6			; 3E
	subc	a,r7			; 3F

	pushw	a			; 40
	pushw	ix			; 41
	xch	a,t			; 42
	xchw	a,t			; 43
	;
	mov	*dir,a			; 45 33
	mov	@ix+off,a		; 46 44
	mov	@ep,a			; 47
	mov	r0,a			; 48
	mov	r1,a			; 49
	mov	r2,a			; 4A
	mov	r3,a			; 4B
	mov	r4,a			; 4C
	mov	r5,a			; 4D
	mov	r6,a			; 4E
	mov	r7,a			; 4F

	popw	a			; 50
	popw	ix			; 51
	xor	a			; 52
	xorw	a			; 53
	xor	a,#v22			; 54 22
	xor	a,*dir			; 55 33
	xor	a,@ix+off		; 56 44
	xor	a,@ep			; 57
	xor	a,r0			; 58
	xor	a,r1			; 59
	xor	a,r2			; 5A
	xor	a,r3			; 5B
	xor	a,r4			; 5C
	xor	a,r5			; 5D
	xor	a,r6			; 5E
	xor	a,r7			; 5F

	mov	a,ext			; 60 12 34
	mov	ext,a			; 61 12 34
	and	a			; 62
	andw	a			; 63
	and	a,#v22			; 64 22
	and	a,*dir			; 65 33
	and	a,@ix+off		; 66 44
	and	a,@ep			; 67
	and	a,r0			; 68
	and	a,r1			; 69
	and	a,r2			; 6A
	and	a,r3			; 6B
	and	a,r4			; 6C
	and	a,r5			; 6D
	and	a,r6			; 6E
	and	a,r7			; 6F

	movw	a,ps			; 70
	movw	ps,a			; 71
	or	a			; 72
	orw	a			; 73
	or	a,#v22			; 74 22
	or	a,*dir			; 75 33
	or	a,@ix+off		; 76 44
	or	a,@ep			; 77
	or	a,r0			; 78
	or	a,r1			; 79
	or	a,r2			; 7A
	or	a,r3			; 7B
	or	a,r4			; 7C
	or	a,r5			; 7D
	or	a,r6			; 7E
	or	a,r7			; 7F

	clri				; 80
	clrc				; 81
	mov	@a,t			; 82
	movw	@a,t			; 83
	daa				; 84
	mov	*dir,#v22		; 85 33 22
	mov	@ix+off,#v22		; 86 44 22
	mov	@ep,#v22		; 87 22
	mov	r0,#v22			; 88 22
	mov	r1,#v22			; 89 22
	mov	r2,#v22			; 8A 22
	mov	r3,#v22			; 8B 22
	mov	r4,#v22			; 8C 22
	mov	r5,#v22			; 8D 22
	mov	r6,#v22			; 8E 22
	mov	r7,#v22			; 8F 22

	seti				; 90
	setc				; 91
	mov	a,@a			; 92
	movw	a,@a			; 93
	das				; 94
	cmp	*dir,#v22		; 95 33 22
	cmp	@ix+off,#v22		; 96 44 22
	cmp	@ep,#v22		; 97 22
	cmp	r0,#v22			; 98 22
	cmp	r1,#v22			; 99 22
	cmp	r2,#v22			; 9A 22
	cmp	r3,#v22			; 9B 22
	cmp	r4,#v22			; 9C 22
	cmp	r5,#v22			; 9D 22
	cmp	r6,#v22			; 9E 22
	cmp	r7,#v22			; 9F 22

	clrb	*dir:b0			; A0 33
	clrb	*dir:b1			; A1 33
	clrb	*dir:b2			; A2 33
	clrb	*dir:b3			; A3 33
	clrb	*dir:b4			; A4 33
	clrb	*dir:b5			; A5 33
	clrb	*dir:b6			; A6 33
	clrb	*dir:b7			; A7 33
	setb	*dir:b0			; A8 33
	setb	*dir:b1			; A9 33
	setb	*dir:b2			; AA 33
	setb	*dir:b3			; AB 33
	setb	*dir:b4			; AC 33
	setb	*dir:b5			; AD 33
	setb	*dir:b6			; AE 33
	setb	*dir:b7			; AF 33

	bbc	*dir:b0,.		; B0 33 FD
	bbc	*dir:b1,.		; B1 33 FD
	bbc	*dir:b2,.		; B2 33 FD
	bbc	*dir:b3,.		; B3 33 FD
	bbc	*dir:b4,.		; B4 33 FD
	bbc	*dir:b5,.		; B5 33 FD
	bbc	*dir:b6,.		; B6 33 FD
	bbc	*dir:b7,.		; B7 33 FD
	bbs	*dir:b0,.		; B8 33 FD
	bbs	*dir:b1,.		; B9 33 FD
	bbs	*dir:b2,.		; BA 33 FD
	bbs	*dir:b3,.		; BB 33 FD
	bbs	*dir:b4,.		; BC 33 FD
	bbs	*dir:b5,.		; BD 33 FD
	bbs	*dir:b6,.		; BE 33 FD
	bbs	*dir:b7,.		; BF 33 FD

	incw	a			; C0
	incw	sp			; C1
	incw	ix			; C2
	incw	ep			; C3
	movw	a,ext			; C4 12 34
	movw	a,*dir			; C5 33
	movw	a,@ix+off		; C6 44
	movw	a,@ep			; C7
	inc	r0			; C8
	inc	r1			; C9
	inc	r2			; CA
	inc	r3			; CB
	inc	r4			; CC
	inc	r5			; CD
	inc	r6			; CE
	inc	r7			; CF

	decw	a			; D0
	decw	sp			; D1
	decw	ix			; D2
	decw	ep			; D3
	movw	ext,a			; D4 12 34
	movw	*dir,a			; D5 33
	movw	@ix+off,a		; D6 44
	movw	@ep,a			; D7
	dec	r0			; D8
	dec	r1			; D9
	dec	r2			; DA
	dec	r3			; DB
	dec	r4			; DC
	dec	r5			; DD
	dec	r6			; DE
	dec	r7			; DF

	jmp	@a			; E0
	movw	sp,a			; E1
	movw	ix,a			; E2
	movw	ep,a			; E3
	movw	a,#v5678		; E4 56 78
	movw	sp,#v5678		; E5 56 78
	movw	ix,#v5678		; E6 56 78
	movw	ep,#v5678		; E7 56 78
	callv	#0			; E8
	callv	#1			; E9
	callv	#2			; EA
	callv	#3			; EB
	callv	#4			; EC
	callv	#5			; ED
	callv	#6			; EE
	callv	#7			; EF

	movw	a,pc			; F0
	movw	a,sp			; F1
	movw	a,ix			; F2
	movw	a,ep			; F3
	xchw	a,pc			; F4
	xchw	a,sp			; F5
	xchw	a,ix			; F6
	xchw	a,ep			; F7
	bnc	.+2			; F8 00
	bc	.+3			; F9 01
	bp	.+4			; FA 02
	bn	.+5			; FB 03
	bnz	.+6			; FC 04
	bz	.+7			; FD 05
	bge	.+8			; FE 06
	blt	.+9			; FF 07


	.page
	.sbttl	All values are external constants

	.define	dir,	"dirx + 0x33"	; external dir address
	.define	ext,	"extx + 0x1234"	; external ext address
	.define	off,	"offx + 0x44"	; external off address

	.define	v22,	"v22x + 0x22"	; external constants
	.define	v5678,	"v5678x + 0x5678"

	.define b0,	"bx + 0"	; external Bit Positions
	.define	b1,	"bx + 1"
	.define	b2,	"bx + 2"
	.define	b3,	"bx + 3"
	.define	b4,	"bx + 4"
	.define	b5,	"bx + 5"
	.define	b6,	"bx + 6"
	.define	b7,	"bx + 7"


	.define	v0,	"vx + 0"	; external CALLV vectors
	.define v1,	"vx + 1"
	.define v2,	"vx + 2"
	.define v3,	"vx + 3"
	.define v4,	"vx + 4"
	.define v5,	"vx + 5"
	.define v6,	"vx + 6"
	.define v7,	"vx + 7"

	.page
	.sbttl	F2MC8L Mode

	; Sequencial Opcodes for F2MC8L

	.F2MC8L

	nop				; 00
	mulu	a			; 01
	rolc	a			; 02
	rorc	a			; 03
	mov	a,#v22			; 04r22
	mov	a,*dir			; 05*33
	mov	a,@ix+off		; 06r44
	mov	a,@ep			; 07
	mov	a,r0			; 08
	mov	a,r1			; 09
	mov	a,r2			; 0A
	mov	a,r3			; 0B
	mov	a,r4			; 0C
	mov	a,r5			; 0D
	mov	a,r6			; 0E
	mov	a,r7			; 0F

	swap				; 10
	divu	a			; 11
	cmp	a			; 12
	cmpw	a			; 13
	cmp	a,#v22			; 14r22
	cmp	a,*dir			; 15*33
	cmp	a,@ix+off		; 16r44
	cmp	a,@ep			; 17
	cmp	a,r0			; 18
	cmp	a,r1			; 19
	cmp	a,r2			; 1A
	cmp	a,r3			; 1B
	cmp	a,r4			; 1C
	cmp	a,r5			; 1D
	cmp	a,r6			; 1E
	cmp	a,r7			; 1F

	ret				; 20
	jmp	ext			; 21s12r34
	addc	a			; 22
	addcw	a			; 23
	addc	a,#v22			; 24r22
	addc	a,*dir			; 25*33
	addc	a,@ix+off		; 26r44
	addc	a,@ep			; 27
	addc	a,r0			; 28
	addc	a,r1			; 29
	addc	a,r2			; 2A
	addc	a,r3			; 2B
	addc	a,r4			; 2C
	addc	a,r5			; 2D
	addc	a,r6			; 2E
	addc	a,r7			; 2F

	reti				; 30
	call	ext			; 31s12r34
	subc	a			; 32
	subcw	a			; 33
	subc	a,#v22			; 34r22
	subc	a,*dir			; 35*33
	subc	a,@ix+off		; 36r44
	subc	a,@ep			; 37
	subc	a,r0			; 38
	subc	a,r1			; 39
	subc	a,r2			; 3A
	subc	a,r3			; 3B
	subc	a,r4			; 3C
	subc	a,r5			; 3D
	subc	a,r6			; 3E
	subc	a,r7			; 3F

	pushw	a			; 40
	pushw	ix			; 41
	xch	a,t			; 42
	xchw	a,t			; 43
	;
	mov	*dir,a			; 45*3
	mov	@ix+off,a		; 46r44
	mov	@ep,a			; 47
	mov	r0,a			; 48
	mov	r1,a			; 49
	mov	r2,a			; 4A
	mov	r3,a			; 4B
	mov	r4,a			; 4C
	mov	r5,a			; 4D
	mov	r6,a			; 4E
	mov	r7,a			; 4F

	popw	a			; 50
	popw	ix			; 51
	xor	a			; 52
	xorw	a			; 53
	xor	a,#v22			; 54r22
	xor	a,*dir			; 55*33
	xor	a,@ix+off		; 56r44
	xor	a,@ep			; 57
	xor	a,r0			; 58
	xor	a,r1			; 59
	xor	a,r2			; 5A
	xor	a,r3			; 5B
	xor	a,r4			; 5C
	xor	a,r5			; 5D
	xor	a,r6			; 5E
	xor	a,r7			; 5F

	mov	a,ext			; 60s12r34
	mov	ext,a			; 61s12r34
	and	a			; 62
	andw	a			; 63
	and	a,#v22			; 64r22
	and	a,*dir			; 65*33
	and	a,@ix+off		; 66r44
	and	a,@ep			; 67
	and	a,r0			; 68
	and	a,r1			; 69
	and	a,r2			; 6A
	and	a,r3			; 6B
	and	a,r4			; 6C
	and	a,r5			; 6D
	and	a,r6			; 6E
	and	a,r7			; 6F

	movw	a,ps			; 70
	movw	ps,a			; 71
	or	a			; 72
	orw	a			; 73
	or	a,#v22			; 74r22
	or	a,*dir			; 75*33
	or	a,@ix+off		; 76r44
	or	a,@ep			; 77
	or	a,r0			; 78
	or	a,r1			; 79
	or	a,r2			; 7A
	or	a,r3			; 7B
	or	a,r4			; 7C
	or	a,r5			; 7D
	or	a,r6			; 7E
	or	a,r7			; 7F

	clri				; 80
	clrc				; 81
	mov	@a,t			; 82
	movw	@a,t			; 83
	daa				; 84
	mov	*dir,#v22		; 85*33r22
	mov	@ix+off,#v22		; 86r44r22
	mov	@ep,#v22		; 87r22
	mov	r0,#v22			; 88r22
	mov	r1,#v22			; 89r22
	mov	r2,#v22			; 8Ar22
	mov	r3,#v22			; 8Br22
	mov	r4,#v22			; 8Cr22
	mov	r5,#v22			; 8Dr22
	mov	r6,#v22			; 8Er22
	mov	r7,#v22			; 8Fr22

	seti				; 90
	setc				; 91
	mov	a,@a			; 92
	movw	a,@a			; 93
	das				; 94
	cmp	*dir,#v22		; 95*33r22
	cmp	@ix+off,#v22		; 96r44r22
	cmp	@ep,#v22		; 97r22
	cmp	r0,#v22			; 98r22
	cmp	r1,#v22			; 99r22
	cmp	r2,#v22			; 9Ar22
	cmp	r3,#v22			; 9Br22
	cmp	r4,#v22			; 9Cr22
	cmp	r5,#v22			; 9Dr22
	cmp	r6,#v22			; 9Er22
	cmp	r7,#v22			; 9Fr22

	clrb	*dir:b0			;uA0*33
	clrb	*dir:b1			;uA1*33
	clrb	*dir:b2			;uA2*33
	clrb	*dir:b3			;uA3*33
	clrb	*dir:b4			;uA4*33
	clrb	*dir:b5			;uA5*33
	clrb	*dir:b6			;uA6*33
	clrb	*dir:b7			;uA7*33
	setb	*dir:b0			;uA8*33
	setb	*dir:b1			;uA9*33
	setb	*dir:b2			;uAA*33
	setb	*dir:b3			;uAB*33
	setb	*dir:b4			;uAC*33
	setb	*dir:b5			;uAD*33
	setb	*dir:b6			;uAE*33
	setb	*dir:b7			;uAF*33

	bbc	*dir:b0,.		;uB0*33 FD
	bbc	*dir:b1,.		;uB1*33 FD
	bbc	*dir:b2,.		;uB2*33 FD
	bbc	*dir:b3,.		;uB3*33 FD
	bbc	*dir:b4,.		;uB4*33 FD
	bbc	*dir:b5,.		;uB5*33 FD
	bbc	*dir:b6,.		;uB6*33 FD
	bbc	*dir:b7,.		;uB7*33 FD
	bbs	*dir:b0,.		;uB8*33 FD
	bbs	*dir:b1,.		;uB9*33 FD
	bbs	*dir:b2,.		;uBA*33 FD
	bbs	*dir:b3,.		;uBB*33 FD
	bbs	*dir:b4,.		;uBC*33 FD
	bbs	*dir:b5,.		;uBD*33 FD
	bbs	*dir:b6,.		;uBE*33 FD
	bbs	*dir:b7,.		;uBF*33 FD

	incw	a			; C0
	incw	sp			; C1
	incw	ix			; C2
	incw	ep			; C3
	movw	a,ext			; C4s12r34
	movw	a,*dir			; C5*33
	movw	a,@ix+off		; C6r44
	movw	a,@ep			; C7
	inc	r0			; C8
	inc	r1			; C9
	inc	r2			; CA
	inc	r3			; CB
	inc	r4			; CC
	inc	r5			; CD
	inc	r6			; CE
	inc	r7			; CF

	decw	a			; D0
	decw	sp			; D1
	decw	ix			; D2
	decw	ep			; D3
	movw	ext,a			; D4s12r34
	movw	*dir,a			; D5*33
	movw	@ix+off,a		; D6r44
	movw	@ep,a			; D7
	dec	r0			; D8
	dec	r1			; D9
	dec	r2			; DA
	dec	r3			; DB
	dec	r4			; DC
	dec	r5			; DD
	dec	r6			; DE
	dec	r7			; DF

	jmp	@a			; E0
	movw	sp,a			; E1
	movw	ix,a			; E2
	movw	ep,a			; E3
	movw	a,#v5678		; E4s56r78
	movw	sp,#v5678		; E5s56r78
	movw	ix,#v5678		; E6s56r78
	movw	ep,#v5678		; E7s56r78
	callv	#v0			;uE8
	callv	#v1			;uE9
	callv	#v2			;uEA
	callv	#v3			;uEB
	callv	#v4			;uEC
	callv	#v5			;uED
	callv	#v6			;uEE
	callv	#v7			;uEF

	movw	a,pc			; F0
	movw	a,sp			; F1
	movw	a,ix			; F2
	movw	a,ep			; F3
	xchw	a,pc			; F4
	xchw	a,sp			; F5
	xchw	a,ix			; F6
	xchw	a,ep			; F7
	bnc	.+2			; F8 00
	bc	.+3			; F9 01
	bp	.+4			; FA 02
	bn	.+5			; FB 03
	bnz	.+6			; FC 04
	bz	.+7			; FD 05
	bge	.+8			; FE 06
	blt	.+9			; FF 07


	; Sequencial Opcodes for F2MC8FX

	.F2MC8FX

	nop				; 00
	mulu	a			; 01
	rolc	a			; 02
	rorc	a			; 03
	mov	a,#v22			; 04r22
	mov	a,*dir			; 05*33
	mov	a,@ix+off		; 06r44
	mov	a,@ep			; 07
	mov	a,r0			; 08
	mov	a,r1			; 09
	mov	a,r2			; 0A
	mov	a,r3			; 0B
	mov	a,r4			; 0C
	mov	a,r5			; 0D
	mov	a,r6			; 0E
	mov	a,r7			; 0F

	swap				; 10
	divu	a			; 11
	cmp	a			; 12
	cmpw	a			; 13
	cmp	a,#v22			; 14r22
	cmp	a,*dir			; 15*33
	cmp	a,@ix+off		; 16r44
	cmp	a,@ep			; 17
	cmp	a,r0			; 18
	cmp	a,r1			; 19
	cmp	a,r2			; 1A
	cmp	a,r3			; 1B
	cmp	a,r4			; 1C
	cmp	a,r5			; 1D
	cmp	a,r6			; 1E
	cmp	a,r7			; 1F

	ret				; 20
	jmp	ext			; 21s12r34
	addc	a			; 22
	addcw	a			; 23
	addc	a,#v22			; 24r22
	addc	a,*dir			; 25*33
	addc	a,@ix+off		; 26r44
	addc	a,@ep			; 27
	addc	a,r0			; 28
	addc	a,r1			; 29
	addc	a,r2			; 2A
	addc	a,r3			; 2B
	addc	a,r4			; 2C
	addc	a,r5			; 2D
	addc	a,r6			; 2E
	addc	a,r7			; 2F

	reti				; 30
	call	ext			; 31s12r34
	subc	a			; 32
	subcw	a			; 33
	subc	a,#v22			; 34r22
	subc	a,*dir			; 35*33
	subc	a,@ix+off		; 36r44
	subc	a,@ep			; 37
	subc	a,r0			; 38
	subc	a,r1			; 39
	subc	a,r2			; 3A
	subc	a,r3			; 3B
	subc	a,r4			; 3C
	subc	a,r5			; 3D
	subc	a,r6			; 3E
	subc	a,r7			; 3F

	pushw	a			; 40
	pushw	ix			; 41
	xch	a,t			; 42
	xchw	a,t			; 43
	;
	mov	*dir,a			; 45*33
	mov	@ix+off,a		; 46r44
	mov	@ep,a			; 47
	mov	r0,a			; 48
	mov	r1,a			; 49
	mov	r2,a			; 4A
	mov	r3,a			; 4B
	mov	r4,a			; 4C
	mov	r5,a			; 4D
	mov	r6,a			; 4E
	mov	r7,a			; 4F

	popw	a			; 50
	popw	ix			; 51
	xor	a			; 52
	xorw	a			; 53
	xor	a,#v22			; 54r22
	xor	a,*dir			; 55*33
	xor	a,@ix+off		; 56r44
	xor	a,@ep			; 57
	xor	a,r0			; 58
	xor	a,r1			; 59
	xor	a,r2			; 5A
	xor	a,r3			; 5B
	xor	a,r4			; 5C
	xor	a,r5			; 5D
	xor	a,r6			; 5E
	xor	a,r7			; 5F

	mov	a,ext			; 60s12r34
	mov	ext,a			; 61s12r34
	and	a			; 62
	andw	a			; 63
	and	a,#v22			; 64r22
	and	a,*dir			; 65*33
	and	a,@ix+off		; 66r44
	and	a,@ep			; 67
	and	a,r0			; 68
	and	a,r1			; 69
	and	a,r2			; 6A
	and	a,r3			; 6B
	and	a,r4			; 6C
	and	a,r5			; 6D
	and	a,r6			; 6E
	and	a,r7			; 6F

	movw	a,ps			; 70
	movw	ps,a			; 71
	or	a			; 72
	orw	a			; 73
	or	a,#v22			; 74r22
	or	a,*dir			; 75*33
	or	a,@ix+off		; 76r44
	or	a,@ep			; 77
	or	a,r0			; 78
	or	a,r1			; 79
	or	a,r2			; 7A
	or	a,r3			; 7B
	or	a,r4			; 7C
	or	a,r5			; 7D
	or	a,r6			; 7E
	or	a,r7			; 7F

	clri				; 80
	clrc				; 81
	mov	@a,t			; 82
	movw	@a,t			; 83
	daa				; 84
	mov	*dir,#v22		; 85*33r22
	mov	@ix+off,#v22		; 86r44r22
	mov	@ep,#v22		; 87r22
	mov	r0,#v22			; 88r22
	mov	r1,#v22			; 89r22
	mov	r2,#v22			; 8Ar22
	mov	r3,#v22			; 8Br22
	mov	r4,#v22			; 8Cr22
	mov	r5,#v22			; 8Dr22
	mov	r6,#v22			; 8Er22
	mov	r7,#v22			; 8Fr22

	seti				; 90
	setc				; 91
	mov	a,@a			; 92
	movw	a,@a			; 93
	das				; 94
	cmp	*dir,#v22		; 95*33r22
	cmp	@ix+off,#v22		; 96r44r22
	cmp	@ep,#v22		; 97r22
	cmp	r0,#v22			; 98r22
	cmp	r1,#v22			; 99r22
	cmp	r2,#v22			; 9Ar22
	cmp	r3,#v22			; 9Br22
	cmp	r4,#v22			; 9Cr22
	cmp	r5,#v22			; 9Dr22
	cmp	r6,#v22			; 9Er22
	cmp	r7,#v22			; 9Fr22

	clrb	*dir:b0			;uA0*33
	clrb	*dir:b1			;uA1*33
	clrb	*dir:b2			;uA2*33
	clrb	*dir:b3			;uA3*33
	clrb	*dir:b4			;uA4*33
	clrb	*dir:b5			;uA5*33
	clrb	*dir:b6			;uA6*33
	clrb	*dir:b7			;uA7*33
	setb	*dir:b0			;uA8*33
	setb	*dir:b1			;uA9*33
	setb	*dir:b2			;uAA*33
	setb	*dir:b3			;uAB*33
	setb	*dir:b4			;uAC*33
	setb	*dir:b5			;uAD*33
	setb	*dir:b6			;uAE*33
	setb	*dir:b7			;uAF*33

	bbc	*dir:b0,.		;uB0*33 FD
	bbc	*dir:b1,.		;uB1*33 FD
	bbc	*dir:b2,.		;uB2*33 FD
	bbc	*dir:b3,.		;uB3*33 FD
	bbc	*dir:b4,.		;uB4*33 FD
	bbc	*dir:b5,.		;uB5*33 FD
	bbc	*dir:b6,.		;uB6*33 FD
	bbc	*dir:b7,.		;uB7*33 FD
	bbs	*dir:b0,.		;uB8*33 FD
	bbs	*dir:b1,.		;uB9*33 FD
	bbs	*dir:b2,.		;uBA*33 FD
	bbs	*dir:b3,.		;uBB*33 FD
	bbs	*dir:b4,.		;uBC*33 FD
	bbs	*dir:b5,.		;uBD*33 FD
	bbs	*dir:b6,.		;uBE*33 FD
	bbs	*dir:b7,.		;uBF*33 FD

	incw	a			; C0
	incw	sp			; C1
	incw	ix			; C2
	incw	ep			; C3
	movw	a,ext			; C4s12r34
	movw	a,*dir			; C5*33
	movw	a,@ix+off		; C6r44
	movw	a,@ep			; C7
	inc	r0			; C8
	inc	r1			; C9
	inc	r2			; CA
	inc	r3			; CB
	inc	r4			; CC
	inc	r5			; CD
	inc	r6			; CE
	inc	r7			; CF

	decw	a			; D0
	decw	sp			; D1
	decw	ix			; D2
	decw	ep			; D3
	movw	ext,a			; D4s12r34
	movw	*dir,a			; D5*33
	movw	@ix+off,a		; D6r44
	movw	@ep,a			; D7
	dec	r0			; D8
	dec	r1			; D9
	dec	r2			; DA
	dec	r3			; DB
	dec	r4			; DC
	dec	r5			; DD
	dec	r6			; DE
	dec	r7			; DF

	jmp	@a			; E0
	movw	sp,a			; E1
	movw	ix,a			; E2
	movw	ep,a			; E3
	movw	a,#v5678		; E4s56r78
	movw	sp,#v5678		; E5s56r78
	movw	ix,#v5678		; E6s56r78
	movw	ep,#v5678		; E7s56r78
	callv	#v0			;uE8
	callv	#v1			;uE9
	callv	#v2			;uEA
	callv	#v3			;uEB
	callv	#v4			;uEC
	callv	#v5			;uED
	callv	#v6			;uEE
	callv	#v7			;uEF

	movw	a,pc			; F0
	movw	a,sp			; F1
	movw	a,ix			; F2
	movw	a,ep			; F3
	xchw	a,pc			; F4
	xchw	a,sp			; F5
	xchw	a,ix			; F6
	xchw	a,ep			; F7
	bnc	.+2			; F8 00
	bc	.+3			; F9 01
	bp	.+4			; FA 02
	bn	.+5			; FB 03
	bnz	.+6			; FC 04
	bz	.+7			; FD 05
	bge	.+8			; FE 06
	blt	.+9			; FF 07


