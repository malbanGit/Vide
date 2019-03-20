	.title	ASM8C Sequential Assembler Test


begin:

	ssc			; 00

	exprs	=	0x01
	exprd	=	0x02
	add	a,exprs		; 01 01
	add	a,[exprs]	; 02 01
	add	a,[x+exprs]	; 03 01
	add	[exprd],a	; 04 02
	add	[x+exprd],a	; 05 02
	add	[exprd],exprs	; 06 02 01
	add	[x+exprd],exprs	; 07 02 01

	push	a		; 08

	exprs	=	0x03
	exprd	=	0x04
	adc	a,exprs		; 09 03
	adc	a,[exprs]	; 0A 03
	adc	a,[x+exprs]	; 0B 03
	adc	[exprd],a	; 0C 04
	adc	[x+exprd],a	; 0D 04
	adc	[exprd],exprs	; 0E 04 03
	adc	[x+exprd],exprs	; 0F 04 03

	push	x		; 10

	exprs	=	0x05
	exprd	=	0x06
	sub	a,exprs		; 11 05
	sub	a,[exprs]	; 12 05
	sub	a,[x+exprs]	; 13 05
	sub	[exprd],a	; 14 06
	sub	[x+exprd],a	; 15 06
	sub	[exprd],exprs	; 16 06 05
	sub	[x+exprd],exprs	; 17 06 05

	pop	a		; 18

	exprs	=	0x07
	exprd	=	0x08
	sbb	a,exprs		; 19 07
	sbb	a,[exprs]	; 1A 07
	sbb	a,[x+exprs]	; 1B 07
	sbb	[exprd],a	; 1C 08
	sbb	[x+exprd],a	; 1D 08
	sbb	[exprd],exprs	; 1E 08 07
	sbb	[x+exprd],exprs	; 1F 08 07

	pop	x		; 20

	exprs	=	0x09
	exprd	=	0x0A
	and	a,exprs		; 21 09
	and	a,[exprs]	; 22 09
	and	a,[x+exprs]	; 23 09
	and	[exprd],a	; 24 0A
	and	[x+exprd],a	; 25 0A
	and	[exprd],exprs	; 26 0A 09
	and	[x+exprd],exprs	; 27 0A 09

	romx			; 28

	exprs	=	0x0B
	exprd	=	0x0C
	or	a,exprs		; 29 0B
	or	a,[exprs]	; 2A 0B
	or	a,[x+exprs]	; 2B 0B
	or	[exprd],a	; 2C 0C
	or	[x+exprd],a	; 2D 0C
	or	[exprd],exprs	; 2E 0C 0B
	or	[x+exprd],exprs	; 2F 0C 0B

	halt			; 30

	exprs	=	0x0D
	exprd	=	0x0E
	xor	a,exprs		; 31 0D
	xor	a,[exprs]	; 32 0D
	xor	a,[x+exprs]	; 33 0D
	xor	[exprd],a	; 34 0E
	xor	[x+exprd],a	; 35 0E
	xor	[exprd],exprs	; 36 0E 0D
	xor	[x+exprd],exprs	; 37 0E 0D

	add	sp,exprs	; 38 0D

	exprs	=	0x0F
	exprd	=	0x10
	cmp	a,exprs		; 39 0F
	cmp	a,[exprs]	; 3A 0F
	cmp	a,[x+exprs]	; 3B 0F
	cmp	[exprd],exprs	; 3C 10 0F
	cmp	[x+exprd],exprs	; 3D 10 0F

	mvi	a,[[exprs]++]	; 3E 0F
	mvi	[[exprd]++],a	; 3F 10

	nop			; 40

	exprs	=	0x11
	exprd	=	0x12
	and  reg[exprd],exprs	; 41 12 11
	and  reg[x+exprd],exprs	; 42 12 11
	or   reg[exprd],exprs	; 43 12 11
	or   reg[x+exprd],exprs	; 44 12 11
	xor  reg[exprd],exprs	; 45 12 11
	xor  reg[x+exprd],exprs	; 46 12 11

	tst	[exprd],exprs	; 47 12 11
	tst	[x+exprd],exprs	; 48 12 11
	tst  reg[exprd],exprs	; 49 12 11
	tst  reg[x+exprd],exprs	; 4A 12 11

	swap	a,x		; 4B
	swap	a,[exprs]	; 4C 11
	swap	x,[exprs]	; 4D 11
	swap	a,sp		; 4E

	exprs	=	0x13
	exprd	=	0x14
	mov	x,sp		; 4F
	mov	a,exprs		; 50 13
	mov	a,[exprs]	; 51 13
	mov	a,[x+exprs]	; 52 13
	mov	[exprd],a	; 53 14
	mov	[x+exprd],a	; 54 14
	mov	[exprd],exprs	; 55 14 13
	mov	[x+exprd],exprs	; 56 14 13
	mov	x,exprs		; 57 13
	mov	x,[exprs]	; 58 13
	mov	x,[x+exprs]	; 59 13
	mov	[exprd],x	; 5A 14
	mov	a,x		; 5B
	mov	x,a		; 5C
	mov	a,reg[exprs]	; 5D 13
	mov	a,reg[x+exprs]	; 5E 13
	mov	[exprd],[exprs]	; 5F 14 13
	mov  reg[exprd],a	; 60 14
	mov  reg[x+exprd],a	; 61 14
	mov  reg[exprd],exprs	; 62 14 13
	mov  reg[x+exprd],exprs	; 63 14 13

	exprs	=	0x15
	exprd	=	0x16
	asl	a		; 64
	asl	[exprd]		; 65 16
	asl	[x+exprd]	; 66 16

	asr	a		; 67
	asr	[exprd]		; 68 16
	asr	[x+exprd]	; 69 16

	rlc	a		; 6A
	rlc	[exprd]		; 6B 16
	rlc	[x+exprd]	; 6C 16

	rrc	a		; 6D
	rrc	[exprd]		; 6E 16
	rrc	[x+exprd]	; 6F 16

	exprs	=	0x17
	exprd	=	0x18
	and	f,exprs		; 70 17
	or	f,exprs		; 71 17
	xor	f,exprs		; 72 17

	cpl	a		; 73

	inc	a		; 74
	inc	x		; 75
	inc	[exprd]		; 76 18
	inc	[x+exprd]	; 77 18

	dec	a		; 78
	dec	x		; 79
	dec	[exprd]		; 7A 18
	dec	[x+exprd]	; 7B 18

	lcall	begin		; 7Cs00r00

	ljmp	begin+2		; 7Ds00r02

	reti			; 7E
	ret			; 7F

	jmp	.+0		; 8F FF
	jmp	.+2		; 80 01
	jmp	.+4		; 80 03

	call	.+0		; 9F FF
	call	.+2		; 90 01
	call	.+4		; 90 03

	jz	.+0		; AF FF
	jz	.+2		; A0 01
	jz	.+4		; A0 03

	jnz	.+0		; BF FF
	jnz	.+2		; B0 01
	jnz	.+4		; B0 03

	jc	.+0		; CF FF
	jc	.+2		; C0 01
	jc	.+4		; C0 03

	jnc	.+0		; DF FF
	jnc	.+2		; D0 01
	jnc	.+4		; D0 03

	jacc	.+0		; EF FF
	jacc	.+2		; E0 01
	jacc	.+4		; E0 03

	index	.+0		; FF FF
	index	.+2		; F0 01
	index	.+4		; F0 03

jmp1:	jmp	xjmp1 - 1	;q8FpFF
jmp2:	jmp	xjmp2 + 0	;q80p00
jmp3:	jmp	xjmp3 + 1	;q80p01

call1:	call	xcall1 - 1	;q9FpFF
call2:	call	xcall2 + 0	;q90p00
call3:	call	xcall3 + 1	;q90p01

jz1:	jz	xjz1 - 1	;qAFpFF
jz2:	jz	xjz2 + 0	;qA0p00
jz3:	jz	xjz3 + 1	;qA0p01

jnz1:	jnz	xjnz1 - 1	;qBFpFF
jnz2:	jnz	xjnz2 + 0	;qB0p00
jnz3:	jnz	xjnz3 + 1	;qB0p01

jc1:	jc	xjc1 - 1	;qCFpFF
jc2:	jc	xjc2 + 0	;qC0p00
jc3:	jc	xjc3 + 1	;qC0p01

jnc1:	jnc	xjnc1 - 1	;qDFpFF
jnc2:	jnc	xjnc2 + 0	;qD0p00
jnc3:	jnc	xjnc3 + 1	;qD0p01

jacc1:	jacc	xjacc1 - 1	;qEFpFF
jacc2:	jacc	xjacc2 + 0	;qE0p00
jacc3:	jacc	xjacc3 + 1	;qE0p01

index1:	index	xindex1 - 1	;qFFpFF
index2:	index	xindex2 + 0	;qF0p00
index3:	index	xindex3 + 1	;qF0p01


