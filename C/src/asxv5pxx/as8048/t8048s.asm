	.title	AS8048 Sequential Test

	; Select 8048 Processor
	.8048

	DATA	=	0xFF
	ADDR8	=	0x12
	ADDR11	=	0x0FF

	.globl		Val8
	.globl		Ext8
	.globl		Ext11

	.area	as8048	(ABS, OVR)


	.page
	.sbttl	Basic Opcodes

	.org	0
	;
	nop			; 00
.8041
	out	dbb,a		; 02
.8048
	outl	bus,a		; 02
	add	a,#DATA		; 03 FF
	jmp	ADDR11+0x000	; 04 FF
	en	i		; 05
	;			; 06
	dec	a		; 07
	ins	a,bus		; 08
	in	a,p1		; 09
	in	a,p2		; 0A
	;			; 0B
	movd	a,p4		; 0C
	movd	a,p5		; 0D
	movd	a,p6		; 0E
	movd	a,p7		; 0F
	;
	inc	@r0		; 10
	inc	@r1		; 11
	jb0	ADDR8		; 12 12
	addc	a,#DATA		; 13 FF
	call	ADDR11+0x000	; 14 FF
	dis	i		; 15
	jtf	ADDR8		; 16 12 
	inc	a		; 17
	inc	r0		; 18
	inc	r1		; 19
	inc	r2		; 1A
	inc	r3		; 1B
	inc	r4		; 1C
	inc	r5		; 1D
	inc	r6		; 1E
	inc	r7		; 1F
	;
	xch	a,@r0		; 20
	xch	a,@r1		; 21
.8041
	in	a,dbb		; 22
.8048
	mov	a,#DATA		; 23 FF
	jmp	ADDR11+0x100	; 24 FF
	en	tcnti		; 25
	jnt0	ADDR8		; 26 12 
	clr	a		; 27
	xch	a,r0		; 28
	xch	a,r1		; 29
	xch	a,r2		; 2A
	xch	a,r3		; 2B
	xch	a,r4		; 2C
	xch	a,r5		; 2D
	xch	a,r6		; 2E
	xch	a,r7		; 2F
	;
	xchd	a,@r0		; 30
	xchd	a,@r1		; 31
	jb1	ADDR8		; 32 12
	;			; 33
	call	ADDR11+0x100	; 34 FF
	dis	tcnti		; 35
	jt0	ADDR8		; 36 12 
	cpl	a		; 37
	;			; 38
	outl	p1,a		; 39
	outl	p2,a		; 3A
	;			; 3B
	movd	p4,a		; 3C
	movd	p5,a		; 3D
	movd	p6,a		; 3E
	movd	p7,a		; 3F
	;
	orl	a,@r0		; 40
	orl	a,@r1		; 41
	mov	a,t		; 42
	orl	a,#DATA		; 43 FF
	jmp	ADDR11+0x200	; 44 FF
	strt	cnt		; 45
	jnt1	ADDR8		; 46 12 
	swap	a		; 47
	orl	a,r0		; 48
	orl	a,r1		; 49
	orl	a,r2		; 4A
	orl	a,r3		; 4B
	orl	a,r4		; 4C
	orl	a,r5		; 4D
	orl	a,r6		; 4E
	orl	a,r7		; 4F
	;
	anl	a,@r0		; 50
	anl	a,@r1		; 51
	jb2	ADDR8		; 52 12
	anl	a,#DATA		; 53 FF
	call	ADDR11+0x200	; 54 FF
	strt	t		; 55
	jt1	ADDR8		; 56 12 
	da	a		; 57
	anl	a,r0		; 58
	anl	a,r1		; 59
	anl	a,r2		; 5A
	anl	a,r3		; 5B
	anl	a,r4		; 5C
	anl	a,r5		; 5D
	anl	a,r6		; 5E
	anl	a,r7		; 5F
	;
	add	a,@r0		; 60
	add	a,@r1		; 61
	mov	t,a		; 62
	;			; 63
	jmp	ADDR11+0x300	; 64 FF
	stop	tcnt		; 65
	;			; 66
	rrc	a		; 67
	add	a,r0		; 68
	add	a,r1		; 69
	add	a,r2		; 6A
	add	a,r3		; 6B
	add	a,r4		; 6C
	add	a,r5		; 6D
	add	a,r6		; 6E
	add	a,r7		; 6F
	;
	addc	a,@r0		; 70
	addc	a,@r1		; 71
	jb3	ADDR8		; 72 12
	;			; 73
	call	ADDR11+0x300	; 74 FF
	ent0	clk		; 75
	jf1	ADDR8		; 76 12 
	rr	a		; 77
	addc	a,r0		; 78
	addc	a,r1		; 79
	addc	a,r2		; 7A
	addc	a,r3		; 7B
	addc	a,r4		; 7C
	addc	a,r5		; 7D
	addc	a,r6		; 7E
	addc	a,r7		; 7F
	;
	.org	0
	;
	movx	a,@r0		; 80
	movx	a,@r1		; 81
	;			; 82
	ret			; 83
	jmp	ADDR11+0x400	; 84 FF
.8022
	sel	an0		; 85
.8048
	clr	f0		; 85
	jni	ADDR8		; 86 12 
	jobf	ADDR8		; 86 12 
	;			; 87
	orl	bus,#DATA	; 88 FF
	orl	p1,#DATA	; 89 FF
	orl	p2,#DATA	; 8A FF
	;			; 8B
	orld	p4,a		; 8C
	orld	p5,a		; 8D
	orld	p6,a		; 8E
	orld	p7,a		; 8F
	;
	movx	@r0,a		; 90
	movx	@r1,a		; 91
	jb4	ADDR8		; 92 12
	retr			; 93
	call	ADDR11+0x400	; 94 FF
	cpl	f0		; 95
.8022
	sel	an1		; 95
.8048
	jnz	ADDR8		; 96 12 
	clr	c		; 97
	anl	bus,#DATA	; 98 FF
	anl	p1,#DATA	; 99 FF
	anl	p2,#DATA	; 9A FF
	;			; 9B
	anld	p4,a		; 9C
	anld	p5,a		; 9D
	anld	p6,a		; 9E
	anld	p7,a		; 9F
	;
	mov	@r0,a		; A0
	mov	@r1,a		; A1
	;			; A2
	movp	a,@a		; A3
	jmp	ADDR11+0x500	; A4 FF
	clr	f1		; A5
	;			; A6
	cpl	c		; A7
	mov	r0,a		; A8
	mov	r1,a		; A9
	mov	r2,a		; AA
	mov	r3,a		; AB
	mov	r4,a		; AC
	mov	r5,a		; AD
	mov	r6,a		; AE
	mov	r7,a		; AF
	;
	mov	@r0,#DATA	; B0 FF
	mov	@r1,#DATA	; B1 FF
	jb5	ADDR8		; B2 12
	call	ADDR11+0x500	; B4 FF
	cpl	f1		; B5
	jf0	ADDR8		; B6 12 
	;			; B7
	mov	r0,#DATA	; B8 FF
	mov	r1,#DATA	; B9 FF
	mov	r2,#DATA	; BA FF
	mov	r3,#DATA	; BB FF
	mov	r4,#DATA	; BC FF
	mov	r5,#DATA	; BD FF
	mov	r6,#DATA	; BE FF
	mov	r7,#DATA	; BF FF
	;
	;			; C0
	;			; C1
	;			; C2
	jmp	ADDR11+0x600	; C4 FF
	sel	rb0		; C5
	jz	ADDR8		; C6 12 
	mov	a,psw		; C7
	dec	r0		; C8
	dec	r1		; C9
	dec	r2		; CA
	dec	r3		; CB
	dec	r4		; CC
	dec	r5		; CD
	dec	r6		; CE
	dec	r7		; CF
	;
	xrl	a,@r0		; D0
	xrl	a,@r1		; D1
	jb6	ADDR8		; D2 12
	xrl	a,#DATA		; D3 FF
	call	ADDR11+0x600	; D4 FF
	sel	rb1		; D5
.8041
	jnibf	ADDR8		; D6 12 
.8048
	mov	psw,a		; D7
	xrl	a,r0		; D8
	xrl	a,r1		; D9
	xrl	a,r2		; DA
	xrl	a,r3		; DB
	xrl	a,r4		; DC
	xrl	a,r5		; DD
	xrl	a,r6		; DE
	xrl	a,r7		; DF
	;
	;			; E0
	;			; E1
	;			; E2
	movp3	a,@a		; E3
	jmp	ADDR11+0x700	; E4 FF
	sel	mb0		; E5
	jnc	ADDR8		; E6 12
	rl	a		; E7
	djnz	r0,ADDR8	; E8 12
	djnz	r1,ADDR8	; E9 12
	djnz	r2,ADDR8	; EA 12
	djnz	r3,ADDR8	; EB 12
	djnz	r4,ADDR8	; EC 12
	djnz	r5,ADDR8	; ED 12
	djnz	r6,ADDR8	; EE 12
	djnz	r7,ADDR8	; EF 12
	;
	mov	a,@r0		; F0
	mov	a,@r1		; F1
	jb7	ADDR8		; F2 12
	;			; F3
	call	ADDR11+0x700	; F4 FF
	sel	mb1		; F5
	jc	ADDR8		; F6 12 
	rlc	a		; F7
	mov	a,r0		; F8
	mov	a,r1		; F9
	mov	a,r2		; FA
	mov	a,r3		; FB
	mov	a,r4		; FC
	mov	a,r5		; FD
	mov	a,r6		; FE
	mov	a,r7		; FF



	.page
	.sbttl	Alternate Arguments

	.org	0
	;
	nop			; 00
.8041
	out	dbb,a		; 02
.8048
	outl	bus,a		; 02
	add	a,#DATA		; 03 FF
	jmp	ADDR11+0x000	; 04 FF
	en	i		; 05
	;			; 06
	dec			; 07
	ins	bus		; 08
	in	p1		; 09
	in	p2		; 0A
	;			; 0B
	movd	p4		; 0C
	movd	p5		; 0D
	movd	p6		; 0E
	movd	p7		; 0F
	;
	inc	@r0		; 10
	inc	@r1		; 11
	jb0	ADDR8		; 12 12
	addc	#DATA		; 13 FF
	call	ADDR11+0x000	; 14 FF
	dis	i		; 15
	jtf	ADDR8		; 16 12 
	inc			; 17
	inc	r0		; 18
	inc	r1		; 19
	inc	r2		; 1A
	inc	r3		; 1B
	inc	r4		; 1C
	inc	r5		; 1D
	inc	r6		; 1E
	inc	r7		; 1F
	;
	xch	@r0		; 20
	xch	@r1		; 21
.8041
	in	dbb		; 22
.8048
	mov	#DATA		; 23 FF
	jmp	ADDR11+0x100	; 24 FF
	en	tcnti		; 25
	jnt0	ADDR8		; 26 12 
	clr			; 27
	xch	r0		; 28
	xch	r1		; 29
	xch	r2		; 2A
	xch	r3		; 2B
	xch	r4		; 2C
	xch	r5		; 2D
	xch	r6		; 2E
	xch	r7		; 2F
	;
	xchd	@r0		; 30
	xchd	@r1		; 31
	jb1	ADDR8		; 32 12
	;			; 33
	call	ADDR11+0x100	; 34 FF
	dis	tcnti		; 35
	jt0	ADDR8		; 36 12 
	cpl			; 37
	;			; 38
	outl	p1,a		; 39
	outl	p2,a		; 3A
	;			; 3B
	movd	p4,a		; 3C
	movd	p5,a		; 3D
	movd	p6,a		; 3E
	movd	p7,a		; 3F
	;
	orl	@r0		; 40
	orl	@r1		; 41
	mov	t		; 42
	orl	#DATA		; 43 FF
	jmp	ADDR11+0x200	; 44 FF
	strt	cnt		; 45
	jnt1	ADDR8		; 46 12 
	swap			; 47
	orl	r0		; 48
	orl	r1		; 49
	orl	r2		; 4A
	orl	r3		; 4B
	orl	r4		; 4C
	orl	r5		; 4D
	orl	r6		; 4E
	orl	r7		; 4F
	;
	anl	@r0		; 50
	anl	@r1		; 51
	jb2	ADDR8		; 52 12
	anl	#DATA		; 53 FF
	call	ADDR11+0x200	; 54 FF
	strt	t		; 55
	jt1	ADDR8		; 56 12 
	da			; 57
	anl	r0		; 58
	anl	r1		; 59
	anl	r2		; 5A
	anl	r3		; 5B
	anl	r4		; 5C
	anl	r5		; 5D
	anl	r6		; 5E
	anl	r7		; 5F
	;
	add	@r0		; 60
	add	@r1		; 61
	mov	t,a		; 62
	;			; 63
	jmp	ADDR11+0x300	; 64 FF
	stop	tcnt		; 65
	;			; 66
	rrc			; 67
	add	r0		; 68
	add	r1		; 69
	add	r2		; 6A
	add	r3		; 6B
	add	r4		; 6C
	add	r5		; 6D
	add	r6		; 6E
	add	r7		; 6F
	;
	addc	@r0		; 70
	addc	@r1		; 71
	jb3	ADDR8		; 72 12
	;			; 73
	call	ADDR11+0x300	; 74 FF
	ent0	clk		; 75
	jf1	ADDR8		; 76 12 
	rr			; 77
	addc	r0		; 78
	addc	r1		; 79
	addc	r2		; 7A
	addc	r3		; 7B
	addc	r4		; 7C
	addc	r5		; 7D
	addc	r6		; 7E
	addc	r7		; 7F
	;
	.org	0
	;
	movx	@r0		; 80
	movx	@r1		; 81
	;			; 82
	ret			; 83
	jmp	ADDR11+0x400	; 84 FF
.8022
	sel	an0		; 85
.8048
	clr	f0		; 85
	jni	ADDR8		; 86 12 
	jobf	ADDR8		; 86 12 
	;			; 87
	orl	bus,#DATA	; 88 FF
	orl	p1,#DATA	; 89 FF
	orl	p2,#DATA	; 8A FF
	;			; 8B
	orld	p4,a		; 8C
	orld	p5,a		; 8D
	orld	p6,a		; 8E
	orld	p7,a		; 8F
	;
	movx	@r0,a		; 90
	movx	@r1,a		; 91
	jb4	ADDR8		; 92 12
	retr			; 93
	call	ADDR11+0x400	; 94 FF
	cpl	f0		; 95
.8022
	sel	an1		; 95
.8048
	jnz	ADDR8		; 96 12 
	clr	c		; 97
	anl	bus,#DATA	; 98 FF
	anl	p1,#DATA	; 99 FF
	anl	p2,#DATA	; 9A FF
	;			; 9B
	anld	p4,a		; 9C
	anld	p5,a		; 9D
	anld	p6,a		; 9E
	anld	p7,a		; 9F
	;
	mov	@r0,a		; A0
	mov	@r1,a		; A1
	;			; A2
	movp	@a		; A3
	jmp	ADDR11+0x500	; A4 FF
	clr	f1		; A5
	;			; A6
	cpl	c		; A7
	mov	r0,a		; A8
	mov	r1,a		; A9
	mov	r2,a		; AA
	mov	r3,a		; AB
	mov	r4,a		; AC
	mov	r5,a		; AD
	mov	r6,a		; AE
	mov	r7,a		; AF
	;
	mov	@r0,#DATA	; B0 FF
	mov	@r1,#DATA	; B1 FF
	jb5	ADDR8		; B2 12
	call	ADDR11+0x500	; B4 FF
	cpl	f1		; B5
	jf0	ADDR8		; B6 12 
	;			; B7
	mov	r0,#DATA	; B8 FF
	mov	r1,#DATA	; B9 FF
	mov	r2,#DATA	; BA FF
	mov	r3,#DATA	; BB FF
	mov	r4,#DATA	; BC FF
	mov	r5,#DATA	; BD FF
	mov	r6,#DATA	; BE FF
	mov	r7,#DATA	; BF FF
	;
	;			; C0
	;			; C1
	;			; C2
	jmp	ADDR11+0x600	; C4 FF
	sel	rb0		; C5
	jz	ADDR8		; C6 12 
	mov	psw		; C7
	dec	r0		; C8
	dec	r1		; C9
	dec	r2		; CA
	dec	r3		; CB
	dec	r4		; CC
	dec	r5		; CD
	dec	r6		; CE
	dec	r7		; CF
	;
	xrl	@r0		; D0
	xrl	@r1		; D1
	jb6	ADDR8		; D2 12
	xrl	#DATA		; D3 FF
	call	ADDR11+0x600	; D4 FF
	sel	rb1		; D5
.8041
	jnibf	ADDR8		; D6 12 
.8048
	mov	psw,a		; D7
	xrl	r0		; D8
	xrl	r1		; D9
	xrl	r2		; DA
	xrl	r3		; DB
	xrl	r4		; DC
	xrl	r5		; DD
	xrl	r6		; DE
	xrl	r7		; DF
	;
	;			; E0
	;			; E1
	;			; E2
	movp3	@a		; E3
	jmp	ADDR11+0x700	; E4 FF
	sel	mb0		; E5
	jnc	ADDR8		; E6 12
	rl			; E7
	djnz	r0,ADDR8	; E8 12
	djnz	r1,ADDR8	; E9 12
	djnz	r2,ADDR8	; EA 12
	djnz	r3,ADDR8	; EB 12
	djnz	r4,ADDR8	; EC 12
	djnz	r5,ADDR8	; ED 12
	djnz	r6,ADDR8	; EE 12
	djnz	r7,ADDR8	; EF 12
	;
	mov	@r0		; F0
	mov	@r1		; F1
	jb7	ADDR8		; F2 12
	;			; F3
	call	ADDR11+0x700	; F4 FF
	sel	mb1		; F5
	jc	ADDR8		; F6 12 
	rlc			; F7
	mov	r0		; F8
	mov	r1		; F9
	mov	r2		; FA
	mov	r3		; FB
	mov	r4		; FC
	mov	r5		; FD
	mov	r6		; FE
	mov	r7		; FF



	.page
	.sbttl	Basic Opcodes (External Values)

	.org	0
	;
	nop				; 00
.8041
	out	dbb,a			; 02
.8048
	outl	bus,a			; 02
	add	a,#Val8+DATA		; 03 FF
	jmp	Ext11+ADDR11+0x000	; 04 FF
	en	i			; 05
	;				; 06
	dec	a			; 07
	ins	a,bus			; 08
	in	a,p1			; 09
	in	a,p2			; 0A
	;				; 0B
	movd	a,p4			; 0C
	movd	a,p5			; 0D
	movd	a,p6			; 0E
	movd	a,p7			; 0F
	;			        
	inc	@r0			; 10
	inc	@r1			; 11
	jb0	Ext8+ADDR8		; 12 12
	addc	a,#Val8+DATA		; 13 FF
	call	Ext11+ADDR11+0x000	; 14 FF
	dis	i			; 15
	jtf	Ext8+ADDR8		; 16 12 
	inc	a			; 17
	inc	r0			; 18
	inc	r1			; 19
	inc	r2			; 1A
	inc	r3			; 1B
	inc	r4			; 1C
	inc	r5			; 1D
	inc	r6			; 1E
	inc	r7			; 1F
	;
	xch	a,@r0			; 20
	xch	a,@r1			; 21
.8041
	in	a,dbb			; 22
.8048
	mov	a,#Val8+DATA		; 23 FF
	jmp	Ext11+ADDR11+0x100	; 24 FF
	en	tcnti			; 25
	jnt0	Ext8+ADDR8		; 26 12 
	clr	a			; 27
	xch	a,r0			; 28
	xch	a,r1			; 29
	xch	a,r2			; 2A
	xch	a,r3			; 2B
	xch	a,r4			; 2C
	xch	a,r5			; 2D
	xch	a,r6			; 2E
	xch	a,r7			; 2F
	;
	xchd	a,@r0			; 30
	xchd	a,@r1			; 31
	jb1	Ext8+ADDR8		; 32 12
	;				; 33
	call	Ext11+ADDR11+0x100	; 34 FF
	dis	tcnti			; 35
	jt0	Ext8+ADDR8		; 36 12 
	cpl	a			; 37
	;				; 38
	outl	p1,a			; 39
	outl	p2,a			; 3A
	;				; 3B
	movd	p4,a			; 3C
	movd	p5,a			; 3D
	movd	p6,a			; 3E
	movd	p7,a			; 3F
	;
	orl	a,@r0			; 40
	orl	a,@r1			; 41
	mov	a,t			; 42
	orl	a,#Val8+DATA		; 43 FF
	jmp	Ext11+ADDR11+0x200	; 44 FF
	strt	cnt			; 45
	jnt1	Ext8+ADDR8		; 46 12 
	swap	a			; 47
	orl	a,r0			; 48
	orl	a,r1			; 49
	orl	a,r2			; 4A
	orl	a,r3			; 4B
	orl	a,r4			; 4C
	orl	a,r5			; 4D
	orl	a,r6			; 4E
	orl	a,r7			; 4F
	;
	anl	a,@r0			; 50
	anl	a,@r1			; 51
	jb2	Ext8+ADDR8		; 52 12
	anl	a,#Val8+DATA		; 53 FF
	call	Ext11+ADDR11+0x200	; 54 FF
	strt	t			; 55
	jt1	Ext8+ADDR8		; 56 12 
	da	a			; 57
	anl	a,r0			; 58
	anl	a,r1			; 59
	anl	a,r2			; 5A
	anl	a,r3			; 5B
	anl	a,r4			; 5C
	anl	a,r5			; 5D
	anl	a,r6			; 5E
	anl	a,r7			; 5F
	;
	add	a,@r0			; 60
	add	a,@r1			; 61
	mov	t,a			; 62
	;				; 63
	jmp	Ext11+ADDR11+0x300	; 64 FF
	stop	tcnt			; 65
	;				; 66
	rrc	a			; 67
	add	a,r0			; 68
	add	a,r1			; 69
	add	a,r2			; 6A
	add	a,r3			; 6B
	add	a,r4			; 6C
	add	a,r5			; 6D
	add	a,r6			; 6E
	add	a,r7			; 6F
	;
	addc	a,@r0			; 70
	addc	a,@r1			; 71
	jb3	Ext8+ADDR8		; 72 12
	;				; 73
	call	Ext11+ADDR11+0x300	; 74 FF
	ent0	clk			; 75
	jf1	Ext8+ADDR8		; 76 12 
	rr	a			; 77
	addc	a,r0			; 78
	addc	a,r1			; 79
	addc	a,r2			; 7A
	addc	a,r3			; 7B
	addc	a,r4			; 7C
	addc	a,r5			; 7D
	addc	a,r6			; 7E
	addc	a,r7			; 7F
	;
	.org	0
	;
	movx	a,@r0			; 80
	movx	a,@r1			; 81
	;				; 82
	ret				; 83
	jmp	Ext11+ADDR11+0x400	; 84 FF
.8022
	sel	an0			; 85
.8048
	clr	f0			; 85
	jni	Ext8+ADDR8		; 86 12 
	jobf	Ext8+ADDR8		; 86 12 
	;				; 87
	orl	bus,#Val8+DATA		; 88 FF
	orl	p1,#Val8+DATA		; 89 FF
	orl	p2,#Val8+DATA		; 8A FF
	;				; 8B
	orld	p4,a			; 8C
	orld	p5,a			; 8D
	orld	p6,a			; 8E
	orld	p7,a			; 8F
	;
	movx	@r0,a			; 90
	movx	@r1,a			; 91
	jb4	Ext8+ADDR8		; 92 12
	retr				; 93
	call	Ext11+ADDR11+0x400	; 94 FF
	cpl	f0			; 95
.8022
	sel	an1			; 95
.8048
	jnz	Ext8+ADDR8		; 96 12 
	clr	c			; 97
	anl	bus,#Val8+DATA		; 98 FF
	anl	p1,#Val8+DATA		; 99 FF
	anl	p2,#Val8+DATA		; 9A FF
	;				; 9B
	anld	p4,a			; 9C
	anld	p5,a			; 9D
	anld	p6,a			; 9E
	anld	p7,a			; 9F
	;
	mov	@r0,a			; A0
	mov	@r1,a			; A1
	;				; A2
	movp	a,@a			; A3
	jmp	Ext11+ADDR11+0x500	; A4 FF
	clr	f1			; A5
	;				; A6
	cpl	c			; A7
	mov	r0,a			; A8
	mov	r1,a			; A9
	mov	r2,a			; AA
	mov	r3,a			; AB
	mov	r4,a			; AC
	mov	r5,a			; AD
	mov	r6,a			; AE
	mov	r7,a			; AF
	;
	mov	@r0,#Val8+DATA		; B0 FF
	mov	@r1,#Val8+DATA		; B1 FF
	jb5	Ext8+ADDR8		; B2 12
	call	Ext11+ADDR11+0x500	; B4 FF
	cpl	f1			; B5
	jf0	Ext8+ADDR8		; B6 12 
	;				; B7
	mov	r0,#Val8+DATA		; B8 FF
	mov	r1,#Val8+DATA		; B9 FF
	mov	r2,#Val8+DATA		; BA FF
	mov	r3,#Val8+DATA		; BB FF
	mov	r4,#Val8+DATA		; BC FF
	mov	r5,#Val8+DATA		; BD FF
	mov	r6,#Val8+DATA		; BE FF
	mov	r7,#Val8+DATA		; BF FF
	;
	;				; C0
	;				; C1
	;				; C2
	jmp	Ext11+ADDR11+0x600	; C4 FF
	sel	rb0			; C5
	jz	Ext8+ADDR8		; C6 12 
	mov	a,psw			; C7
	dec	r0			; C8
	dec	r1			; C9
	dec	r2			; CA
	dec	r3			; CB
	dec	r4			; CC
	dec	r5			; CD
	dec	r6			; CE
	dec	r7			; CF
	;
	xrl	a,@r0			; D0
	xrl	a,@r1			; D1
	jb6	Ext8+ADDR8		; D2 12
	xrl	a,#Val8+DATA		; D3 FF
	call	Ext11+ADDR11+0x600	; D4 FF
	sel	rb1			; D5
.8041
	jnibf	Ext8+ADDR8		; D6 12 
.8048
	mov	psw,a			; D7
	xrl	a,r0			; D8
	xrl	a,r1			; D9
	xrl	a,r2			; DA
	xrl	a,r3			; DB
	xrl	a,r4			; DC
	xrl	a,r5			; DD
	xrl	a,r6			; DE
	xrl	a,r7			; DF
	;
	;				; E0
	;				; E1
	;				; E2
	movp3	a,@a			; E3
	jmp	Ext11+ADDR11+0x700	; E4 FF
	sel	mb0			; E5
	jnc	Ext8+ADDR8		; E6 12
	rl	a			; E7
	djnz	r0,Ext8+ADDR8		; E8 12
	djnz	r1,Ext8+ADDR8		; E9 12
	djnz	r2,Ext8+ADDR8		; EA 12
	djnz	r3,Ext8+ADDR8		; EB 12
	djnz	r4,Ext8+ADDR8		; EC 12
	djnz	r5,Ext8+ADDR8		; ED 12
	djnz	r6,Ext8+ADDR8		; EE 12
	djnz	r7,Ext8+ADDR8		; EF 12
	;
	mov	a,@r0			; F0
	mov	a,@r1			; F1
	jb7	Ext8+ADDR8		; F2 12
	;				; F3
	call	Ext11+ADDR11+0x700	; F4 FF
	sel	mb1			; F5
	jc	Ext8+ADDR8		; F6 12 
	rlc	a			; F7
	mov	a,r0			; F8
	mov	a,r1			; F9
	mov	a,r2			; FA
	mov	a,r3			; FB
	mov	a,r4			; FC
	mov	a,r5			; FD
	mov	a,r6			; FE
	mov	a,r7			; FF



	.page
	.sbttl	Alternate Arguments

	.org	0
	;
	nop				; 00
.8041
	out	dbb,a			; 02
.8048
	outl	bus,a			; 02
	add	a,#Val8+DATA		; 03 FF
	jmp	Ext11+ADDR11+0x000	; 04 FF
	en	i			; 05
	;				; 06
	dec				; 07
	ins	bus			; 08
	in	p1			; 09
	in	p2			; 0A
	;				; 0B
	movd	p4			; 0C
	movd	p5			; 0D
	movd	p6			; 0E
	movd	p7			; 0F
	;
	inc	@r0			; 10
	inc	@r1			; 11
	jb0	Ext8+ADDR8		; 12 12
	addc	#Val8+DATA		; 13 FF
	call	Ext11+ADDR11+0x000	; 14 FF
	dis	i			; 15
	jtf	Ext8+ADDR8		; 16 12 
	inc				; 17
	inc	r0			; 18
	inc	r1			; 19
	inc	r2			; 1A
	inc	r3			; 1B
	inc	r4			; 1C
	inc	r5			; 1D
	inc	r6			; 1E
	inc	r7			; 1F
	;
	xch	@r0			; 20
	xch	@r1			; 21
.8041
	in	dbb			; 22
.8048
	mov	#Val8+DATA		; 23 FF
	jmp	Ext11+ADDR11+0x100	; 24 FF
	en	tcnti			; 25
	jnt0	Ext8+ADDR8		; 26 12 
	clr				; 27
	xch	r0			; 28
	xch	r1			; 29
	xch	r2			; 2A
	xch	r3			; 2B
	xch	r4			; 2C
	xch	r5			; 2D
	xch	r6			; 2E
	xch	r7			; 2F
	;
	xchd	@r0			; 30
	xchd	@r1			; 31
	jb1	Ext8+ADDR8		; 32 12
	;				; 33
	call	Ext11+ADDR11+0x100	; 34 FF
	dis	tcnti			; 35
	jt0	Ext8+ADDR8		; 36 12 
	cpl				; 37
	;				; 38
	outl	p1,a			; 39
	outl	p2,a			; 3A
	;				; 3B
	movd	p4,a			; 3C
	movd	p5,a			; 3D
	movd	p6,a			; 3E
	movd	p7,a			; 3F
	;
	orl	@r0			; 40
	orl	@r1			; 41
	mov	t			; 42
	orl	#Val8+DATA		; 43 FF
	jmp	Ext11+ADDR11+0x200	; 44 FF
	strt	cnt			; 45
	jnt1	Ext8+ADDR8		; 46 12 
	swap				; 47
	orl	r0			; 48
	orl	r1			; 49
	orl	r2			; 4A
	orl	r3			; 4B
	orl	r4			; 4C
	orl	r5			; 4D
	orl	r6			; 4E
	orl	r7			; 4F
	;
	anl	@r0			; 50
	anl	@r1			; 51
	jb2	Ext8+ADDR8		; 52 12
	anl	#Val8+DATA		; 53 FF
	call	Ext11+ADDR11+0x200	; 54 FF
	strt	t			; 55
	jt1	Ext8+ADDR8		; 56 12 
	da				; 57
	anl	r0			; 58
	anl	r1			; 59
	anl	r2			; 5A
	anl	r3			; 5B
	anl	r4			; 5C
	anl	r5			; 5D
	anl	r6			; 5E
	anl	r7			; 5F
	;
	add	@r0			; 60
	add	@r1			; 61
	mov	t,a			; 62
	;				; 63
	jmp	Ext11+ADDR11+0x300	; 64 FF
	stop	tcnt			; 65
	;				; 66
	rrc				; 67
	add	r0			; 68
	add	r1			; 69
	add	r2			; 6A
	add	r3			; 6B
	add	r4			; 6C
	add	r5			; 6D
	add	r6			; 6E
	add	r7			; 6F
	;
	addc	@r0			; 70
	addc	@r1			; 71
	jb3	Ext8+ADDR8		; 72 12
	;				; 73
	call	Ext11+ADDR11+0x300	; 74 FF
	ent0	clk			; 75
	jf1	Ext8+ADDR8		; 76 12 
	rr				; 77
	addc	r0			; 78
	addc	r1			; 79
	addc	r2			; 7A
	addc	r3			; 7B
	addc	r4			; 7C
	addc	r5			; 7D
	addc	r6			; 7E
	addc	r7			; 7F
	;
	.org	0
	;
	movx	@r0			; 80
	movx	@r1			; 81
	;				; 82
	ret				; 83
	jmp	Ext11+ADDR11+0x400	; 84 FF
.8022
	sel	an0			; 85
.8048
	clr	f0			; 85
	jni	Ext8+ADDR8		; 86 12 
	jobf	Ext8+ADDR8		; 86 12 
	;				; 87
	orl	bus,#Val8+DATA		; 88 FF
	orl	p1,#Val8+DATA		; 89 FF
	orl	p2,#Val8+DATA		; 8A FF
	;				; 8B
	orld	p4,a			; 8C
	orld	p5,a			; 8D
	orld	p6,a			; 8E
	orld	p7,a			; 8F
	;
	movx	@r0,a			; 90
	movx	@r1,a			; 91
	jb4	Ext8+ADDR8		; 92 12
	retr				; 93
	call	Ext11+ADDR11+0x400	; 94 FF
	cpl	f0			; 95
.8022
	sel	an1			; 95
.8048
	jnz	Ext8+ADDR8		; 96 12 
	clr	c			; 97
	anl	bus,#Val8+DATA		; 98 FF
	anl	p1,#Val8+DATA		; 99 FF
	anl	p2,#Val8+DATA		; 9A FF
	;				; 9B
	anld	p4,a			; 9C
	anld	p5,a			; 9D
	anld	p6,a			; 9E
	anld	p7,a			; 9F
	;
	mov	@r0,a			; A0
	mov	@r1,a			; A1
	;				; A2
	movp	@a			; A3
	jmp	Ext11+ADDR11+0x500	; A4 FF
	clr	f1			; A5
	;				; A6
	cpl	c			; A7
	mov	r0,a			; A8
	mov	r1,a			; A9
	mov	r2,a			; AA
	mov	r3,a			; AB
	mov	r4,a			; AC
	mov	r5,a			; AD
	mov	r6,a			; AE
	mov	r7,a			; AF
	;
	mov	@r0,#Val8+DATA		; B0 FF
	mov	@r1,#Val8+DATA		; B1 FF
	jb5	Ext8+ADDR8		; B2 12
	call	Ext11+ADDR11+0x500	; B4 FF
	cpl	f1			; B5
	jf0	Ext8+ADDR8		; B6 12 
	;				; B7
	mov	r0,#Val8+DATA		; B8 FF
	mov	r1,#Val8+DATA		; B9 FF
	mov	r2,#Val8+DATA		; BA FF
	mov	r3,#Val8+DATA		; BB FF
	mov	r4,#Val8+DATA		; BC FF
	mov	r5,#Val8+DATA		; BD FF
	mov	r6,#Val8+DATA		; BE FF
	mov	r7,#Val8+DATA		; BF FF
	;
	;				; C0
	;				; C1
	;				; C2
	jmp	Ext11+ADDR11+0x600	; C4 FF
	sel	rb0			; C5
	jz	Ext8+ADDR8		; C6 12 
	mov	psw			; C7
	dec	r0			; C8
	dec	r1			; C9
	dec	r2			; CA
	dec	r3			; CB
	dec	r4			; CC
	dec	r5			; CD
	dec	r6			; CE
	dec	r7			; CF
	;
	xrl	@r0			; D0
	xrl	@r1			; D1
	jb6	Ext8+ADDR8		; D2 12
	xrl	#Val8+DATA		; D3 FF
	call	Ext11+ADDR11+0x600	; D4 FF
	sel	rb1			; D5
.8041
	jnibf	Ext8+ADDR8		; D6 12 
.8048
	mov	psw,a			; D7
	xrl	r0			; D8
	xrl	r1			; D9
	xrl	r2			; DA
	xrl	r3			; DB
	xrl	r4			; DC
	xrl	r5			; DD
	xrl	r6			; DE
	xrl	r7			; DF
	;
	;				; E0
	;				; E1
	;				; E2
	movp3	@a			; E3
	jmp	Ext11+ADDR11+0x700	; E4 FF
	sel	mb0			; E5
	jnc	Ext8+ADDR8		; E6 12
	rl				; E7
	djnz	r0,Ext8+ADDR8		; E8 12
	djnz	r1,Ext8+ADDR8		; E9 12
	djnz	r2,Ext8+ADDR8		; EA 12
	djnz	r3,Ext8+ADDR8		; EB 12
	djnz	r4,Ext8+ADDR8		; EC 12
	djnz	r5,Ext8+ADDR8		; ED 12
	djnz	r6,Ext8+ADDR8		; EE 12
	djnz	r7,Ext8+ADDR8		; EF 12
	;
	mov	@r0			; F0
	mov	@r1			; F1
	jb7	Ext8+ADDR8		; F2 12
	;				; F3
	call	Ext11+ADDR11+0x700	; F4 FF
	sel	mb1			; F5
	jc	Ext8+ADDR8		; F6 12 
	rlc				; F7
	mov	r0			; F8
	mov	r1			; F9
	mov	r2			; FA
	mov	r3			; FB
	mov	r4			; FC
	mov	r5			; FD
	mov	r6			; FE
	mov	r7			; FF

