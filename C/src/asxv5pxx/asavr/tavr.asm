	.title	ASxxxx Test AVR Processors

	; All instructions
	.AT90Sxxxx

	.32bit

	.area	AREA

	.sbttl	Arithmetic and Logic Instruction Tests

	adc	r0,r0		; 00 1C
	adc	r0,r31		; 0F 1E
	adc	r31,r0		; F0 1D
	adc	r31,r31		; FF 1F

	add	r0,r0		; 00 0C
	add	r0,r31		; 0F 0E
	add	r31,r0		; F0 0D
	add	r31,r31		; FF 0F

	adiw	r24,#0		; 00 96
	adiw	r24,#63		; CF 96
	adiw	r30,#0		; 30 96
	adiw	r30,#63		; FF 96

	and	r0,r0		; 00 20
	and	r0,r31		; 0F 22
	and	r31,r0		; F0 21
	and	r31,r31		; FF 23

	andi	r16,#0		; 00 70
	andi	r16,#255	; 0F 7F
	andi	r31,#0		; F0 70
	andi	r31,#255	; FF 7F

	cbr	r16,#0xFF	; 00 70
	cbr	r16,#0x00	; 0F 7F
	cbr	r31,#0xFF	; F0 70
	cbr	r31,#0x00	; FF 7F

	com	r0		; 00 94
	com	r31		; F0 95

	clr	r0		; 00 24
	clr	r31		; FF 27

	cp	r0,r0		; 00 14
	cp	r0,r31		; 0F 16
	cp	r31,r0		; F0 15
	cp	r31,r31		; FF 17

	cpc	r0,r0		; 00 04
	cpc	r0,r31		; 0F 06
	cpc	r31,r0		; F0 05
	cpc	r31,r31		; FF 07

	cpi	r16,#0		; 00 30
	cpi	r16,#0xFF	; 0F 3F
	cpi	r31,#0		; F0 30
	cpi	r31,#0xFF	; FF 3F

	dec	r0		; 0A 94
	dec	r31		; FA 95

	eor	r0,r0		; 00 24
	eor	r0,r31		; 0F 26
	eor	r31,r0		; F0 25
	eor	r31,r31		; FF 27

	fmul	r16,r16		; 08 03
	fmul	r16,r23		; 0F 03
	fmul	r23,r16		; 78 03
	fmul	r23,r23		; 7F 03

	fmuls	r16,r16		; 80 03
	fmuls	r16,r23		; 87 03
	fmuls	r23,r16		; F0 03
	fmuls	r23,r23		; F7 03

	fmulsu	r16,r16		; 88 03
	fmulsu	r16,r23		; 8F 03
	fmulsu	r23,r16		; F8 03
	fmulsu	r23,r23		; FF 03

	inc	r0		; 03 94
	inc	r31		; F3 95

	mul	r0,r0		; 00 9C
	mul	r0,r31		; 0F 9E
	mul	r31,r0		; F0 9D
	mul	r31,r31		; FF 9F

	muls	r16,r16		; 00 02
	muls	r16,r31		; 0F 02
	muls	r31,r16		; F0 02
	muls	r31,r31		; FF 02

	mulsu	r16,r16		; 00 03
	mulsu	r16,r23		; 07 03
	mulsu	r23,r16		; 70 03
	mulsu	r23,r23		; 77 03

	neg	r0		; 01 94
	neg	r31		; F1 95

	or	r0,r0		; 00 28
	or	r0,r31		; 0F 2A
	or	r31,r0		; F0 29
	or	r31,r31		; FF 2B

	ori	r16,#0		; 00 60
	ori	r16,#0xFF	; 0F 6F
	ori	r31,#0		; F0 60
	ori	r31,#0xFF	; FF 6F

	sbc	r0,r0		; 00 08
	sbc	r0,r31		; 0F 0A
	sbc	r31,r0		; F0 09
	sbc	r31,r31		; FF 0B

	sbci	r16,#0		; 00 40
	sbci	r16,#0xFF	; 0F 4F
	sbci	r31,#0		; F0 40
	sbci	r31,#0xFF	; FF 4F

	sbiw	r24,#0		; 00 97
	sbiw	r24,#63		; CF 97
	sbiw	r30,#0		; 30 97
	sbiw	r30,#63		; FF 97

	sbr	r16,#0		; 00 60
	sbr	r16,#0xFF	; 0F 6F
	sbr	r31,#0		; F0 60
	sbr	r31,#0xFF	; FF 6F

	ser	r16		; 0F EF
	ser	r31		; FF EF

	sub	r0,r0		; 00 18
	sub	r0,r31		; 0F 1A
	sub	r31,r0		; F0 19
	sub	r31,r31		; FF 1B

	subi	r16,#0		; 00 50
	subi	r16,#0xFF	; 0F 5F
	subi	r31,#0		; F0 50
	subi	r31,#0xFF	; FF 5F

	tst	r0		; 00 20
	tst	r31		; FF 23


	.sbttl	Branch Instruction Tests

	brbc	0,.+1		; 00 F4
	brbc	7,.+1		; 07 F4
	brbc	0,.		; F8 F7
	brbc	7,.		; FF F7

	brbs	0,.+1		; 00 F0
	brbs	7,.+1		; 07 F0
	brbs	0,.		; F8 F3
	brbs	7,.		; FF F3

	brcc	.+1		; 00 F4
	brcc	.		; F8 F7

	brcs	.+1		; 00 F0
	brcs	.		; F8 F3

	breq	.+1		; 01 F0
	breq	.		; F9 F3

	brge	.+1		; 04 F4
	brge	.		; FC F7

	brhc	.+1		; 05 F4
	brhc	.		; FD F7

	brhs	.+1		; 05 F0
	brhs	.		; FD F3

	brid	.+1		; 07 F4
	brid	.		; FF F7

	brie	.+1		; 07 F0
	brie	.		; FF F3

	brlo	.+1		; 00 F0
	brlo	.		; F8 F3

	brlt	.+1		; 04 F0
	brlt	.		; FC F3

	brmi	.+1		; 02 F0
	brmi	.		; FA F3

	brne	.+1		; 01 F4
	brne	.		; F9 F7

	brpl	.+1		; 02 F4
	brpl	.		; FA F7

	brsh	.+1		; 00 F4
	brsh	.		; F8 F7

	brtc	.+1		; 06 F4
	brtc	.		; FE F7

	brts	.+1		; 06 F0
	brts	.		; FE F3

	brvc	.+1		; 03 F4
	brvc	.		; FB F7

	brvs	.+1		; 03 F0
	brvs	.		; FB F3

	call	0		; 0E 94 00 00
	call	0x03FFFFF	; FF 95 FF FF

	cpse	r0,r0		; 00 10
	cpse	r0,r31		; 0F 12
	cpse	r31,r0		; F0 11
	cpse	r31,r31		; FF 13

	eicall			; 19 95
	eijmp			; 19 94

	icall			; 09 95
   	ijmp			; 09 94

	jmp	0		; 0C 94 00 00
	jmp	0x03FFFFF	; FD 95 FF FF

	rcall	.+1		; 00 D0
	rcall	.		; FF DF

	ret			; 08 95
	reti			; 18 95

	rjmp	.+1		; 00 C0
	rjmp	.		; FF CF

	sbic	0,0		; 00 99
	sbic	0,7		; 07 99
	sbic	31,0		; F8 99
	sbic	31,7		; FF 99

	sbis	0,0		; 00 9B
	sbis	0,7		; 07 9B
	sbis	31,0		; F8 9B
	sbis	31,7		; FF 9B

	sbrc	r0,0		; 00 FC
	sbrc	r0,7		; 07 FC
	sbrc	r31,0		; F0 FD
	sbrc	r31,7		; F7 FD

	sbrs	r0,0		; 00 FE
	sbrs	r0,7		; 07 FE
	sbrs	r31,0		; F0 FF
	sbrs	r31,7		; F7 FF


	.sbttl	Data Transfer Instruction Tests

	elpm			; D8 95

	elpm	r0,z 		; 06 90
	elpm	r31,z 		; F6 91

	elpm	r0,z+		; 07 90
	elpm	r31,z+		; F7 91

	in	r0,0		; 00 B0
	in	r0,63		; 0F B6
	in	r31,0		; F0 B1
	in	r31,63		; FF B7

	ld	r0,x		; 0C 90
	ld	r31,x		; FC 91

	ld	r0,x+		; 0D 90
	ld	r31,x+		; FD 91

	ld	r0,-x		; 0E 90
	ld	r31,-x		; FE 91

	ld	r0,y		; 08 80
	ld	r31,y		; F8 81

	ld	r0,y+		; 09 90
	ld	r31,y+		; F9 91

	ld	r0,-y		; 0A 90
	ld	r31,-y		; FA 91

	ldd	r0,y+0		; 08 80
	ldd	r0,y+63		; 0F AC
	ldd	r31,y+0		; F8 81
	ldd	r31,y+63	; FF AD

	ld	r0,z		; 00 80
	ld	r31,z		; F0 81

	ld	r0,z+		; 01 90
	ld	r31,z+		; F1 91

	ld	r0,-z		; 02 90
	ld	r31,-z		; F2 91

	ldd	r0,z+0		; 00 80
	ldd	r0,z+63		; 07 AC
	ldd	r31,z+0		; F0 81
	ldd	r31,z+63	; F7 AD

	ldi	r16,0		; 00 E0
	ldi	r16,0xFF	; 0F EF
	ldi	r31,0		; F0 E0
	ldi	r31,0xFF	; FF EF

	lds	r0,0		; 00 90 00 00
	lds	r0,0xFFFF	; 00 90 FF FF
	lds	r31,0		; F0 91 00 00
	lds	r31,0xFFFF	; F0 91 FF FF

	lpm			; C8 95

	lpm	r0,z		; 04 90
	lpm	r31,z		; F4 91

	lpm	r0,z+		; 05 90
	lpm	r31,z+		; F5 91

	mov	r0,r0		; 00 2C
	mov	r0,r31		; 0F 2E
	mov	r31,r0		; F0 2D
	mov	r31,r31		; FF 2F

	movw	r0,r0		; 00 01
	movw	r0,r30		; 0F 01
	movw	r30,r0		; F0 01
	movw	r30,r30		; FF 01

	out	0,r0		; 00 B8
	out	0,r31		; F0 B9
	out	63,r0		; 0F BE
	out	63,r31		; FF BF

	pop	r0		; 0F 90
	pop	r31		; FF 91

	push	r0		; 0F 92
	push	r31		; FF 93

	spm			; E8 95

	st	x,r0		; 0C 92
	st	x,r31		; FC 93

	st	x+,r0		; 0D 92
	st	x+,r31		; FD 93

	st	-x,r0		; 0E 92
	st	-x,r31		; FE 93

	st	y,r0		; 08 82
	st	y,r31		; F8 83

	st	y+,r0		; 09 92
	st	y+,r31		; F9 93

	st	-y,r0		; 0A 92
	st	-y,r31		; FA 93

	std	y+0,r0		; 08 82
	std	y+0,r31		; F8 83
	std	y+63,r0		; 0F AE
	std	y+63,r31	; FF AF

	st	z,r0		; 00 82
	st	z,r31		; F0 83

	st	z+,r0		; 01 92
	st	z+,r31		; F1 93

	st	-z,r0		; 02 92
	st	-z,r31		; F2 93

	std	z+0,r0		; 00 82
	std	z+0,r31		; F0 83
	std	z+63,r0		; 07 AE
	std	z+63,r31	; F7 AF

	sts	0,r0		; 00 92 00 00
	sts	0,r31		; F0 93 00 00
	sts	0xFFFF,r0	; 00 92 FF FF
	sts	0xFFFF,r31	; F0 93 FF FF


	.sbttl	Bit and Bit-Test Instruction Tests

	asr	r0		; 05 94
	asr	r31		; F5 95

	bclr	0		; 88 94
	bclr	7		; F8 94

	bld	r0,0		; 00 F8
	bld	r0,7		; 07 F8
	bld	r31,0		; F0 F9
	bld	r31,7		; F7 F9

	bset	0		; 08 94
	bset	7		; 78 94

	bst	r0,0		; 00 FA
	bst	r0,7		; 07 FA
	bst	r31,0		; F0 FB
	bst	r31,7		; F7 FB

	cbi	0,0		; 00 98
	cbi	0,7		; 07 98
	cbi	31,0		; F8 98
	cbi	31,7		; FF 98

	clc			; 88 94
	clh			; D8 94
	cli			; F8 94
	cln			; A8 94
	cls			; C8 94
	clt			; E8 94
	clv			; B8 94
	clz			; 98 94

	lsl	r0		; 00 0C
	lsl	r31		; FF 0F

	lsr	r0		; 06 94
	lsr	r31		; F6 95

	rol	r0		; 00 1C
	rol	r31		; FF 1F

	ror	r0		; 07 94
	ror	r31		; F7 95

	sbi	0,0		; 00 9A
	sbi	0,7		; 07 9A
	sbi	31,0		; F8 9A
	sbi	31,7		; FF 9A

	sec			; 08 94
	seh			; 58 94
	sei			; 78 94
	sen			; 28 94
	ses			; 48 94
	set			; 68 94
	sev			; 38 94
	sez			; 18 94

	swap	r0		; 02 94
	swap	r31		; F2 95


	.sbttl	Other Instructions

	nop			; 00 00
	sleep			; 88 95
	wdr			; A8 95


	.page
	.sbttl	Merge Mode Bit Positioning Tests (Assembler)

	;S_IBYTE	/* |----|KKKK|----|KKKK| */
	andi	r16,#0		; 00 70
	andi	r16,#1		; 01 70
	andi	r16,#2		; 02 70
	andi	r16,#4		; 04 70
	andi	r16,#8		; 08 70
	andi	r16,#16		; 00 71
	andi	r16,#32		; 00 72
	andi	r16,#64		; 00 74
	andi	r16,#128	; 00 78

	;S_IWORD	/* |----|----|KK--|KKKK| */
	adiw	r24,#0		; 00 96
	adiw	r24,#1		; 01 96
	adiw	r24,#2		; 02 96
	adiw	r24,#4		; 04 96
	adiw	r24,#8		; 08 96
	adiw	r24,#16		; 40 96
	adiw	r24,#32		; 80 96

	;S_IOP		/* |----|-KK-|----|KKKK| */
	in	r0,0		; 00 B0
	in	r0,1		; 01 B0
	in	r0,2		; 02 B0
	in	r0,4		; 04 B0
	in	r0,8		; 08 B0
	in	r0,16		; 00 B2
	in	r0,32		; 00 B4

	;S_IOR		/* |----|----|KKKK|K---| */
	cbi	0,0		; 00 98
	cbi	1,0		; 08 98
	cbi	2,0		; 10 98
	cbi	4,0		; 20 98
	cbi	8,0		; 40 98
	cbi	16,0		; 80 98

	;S_ILDST	/* |--K-|KK--|----|-KKK| */
	ldd	r0,z+0		; 00 80
	ldd	r0,z+1		; 01 80
	ldd	r0,z+2		; 02 80
	ldd	r0,z+4		; 04 80
	ldd	r0,z+8		; 00 84
	ldd	r0,z+16		; 00 88
	ldd	r0,z+32		; 00 A0

	;S_BRA		/* |----|--KK|KKKK|K---| */
	brcs	.+1		; 00 F0
	brcs	.+1+1		; 08 F0
	brcs	.+1+2		; 10 F0
	brcs	.+1+4		; 20 F0
	brcs	.+1+8		; 40 F0
	brcs	.+1+16		; 80 F0
	brcs	.+1+32		; 00 F1
	brcs	.+1-64		; 00 F2

	;S_RJMP		/* |----|KKKK|KKKK|KKKK| */
	rjmp	.+1		; 00 C0
	rjmp	.+1+1		; 01 C0
	rjmp	.+1+2		; 02 C0
	rjmp	.+1+4		; 04 C0
	rjmp	.+1+8		; 08 C0
	rjmp	.+1+16		; 10 C0
	rjmp	.+1+32		; 20 C0
	rjmp	.+1+64		; 40 C0
	rjmp	.+1+128		; 80 C0
	rjmp	.+1+256		; 00 C1
	rjmp	.+1+512		; 00 C2
	rjmp	.+1+1024	; 00 C4
	rjmp	.+1-2048	; 00 C8

	;S_JMP		/* |----|---K|KKKK|---K| // |KKKK|KKKK|KKKK|KKKK| */
	jmp	0x00000000	; 0C 94 00 00
	jmp	0x00000001	; 0C 94 01 00
	jmp	0x00000002	; 0C 94 02 00
	jmp	0x00000004	; 0C 94 04 00
	jmp	0x00000008	; 0C 94 08 00
	jmp	0x00000010	; 0C 94 10 00
	jmp	0x00000020	; 0C 94 20 00
	jmp	0x00000040	; 0C 94 40 00
	jmp	0x00000080	; 0C 94 80 00
	jmp	0x00000100	; 0C 94 00 01
	jmp	0x00000200	; 0C 94 00 02
	jmp	0x00000400	; 0C 94 00 04
	jmp	0x00000800	; 0C 94 00 08
	jmp	0x00001000	; 0C 94 00 10
	jmp	0x00002000	; 0C 94 00 20
	jmp	0x00004000	; 0C 94 00 40
	jmp	0x00008000	; 0C 94 00 80
	jmp	0x00010000	; 0D 94 00 00
	jmp	0x00020000	; 1C 94 00 00
	jmp	0x00040000	; 2C 94 00 00
	jmp	0x00080000	; 4C 94 00 00
	jmp	0x00100000	; 8C 94 00 00
	jmp	0x00200000	; 0C 95 00 00


	.page
	.sbttl	Merge Mode Bit Positioning Tests (Linker)

	; -g zero=0
	; -g blbl=s_bra
	; -g rlbl=s_rjmp

	;S_IBYTE	/* |----|KKKK|----|KKKK| */
	andi	r16,#zero+0	; 00 70
	andi	r16,#zero+1	; 01 70
	andi	r16,#zero+2	; 02 70
	andi	r16,#zero+4	; 04 70
	andi	r16,#zero+8	; 08 70
	andi	r16,#zero+16	; 00 71
	andi	r16,#zero+32	; 00 72
	andi	r16,#zero+64	; 00 74
	andi	r16,#zero+128	; 00 78

	;S_IWORD	/* |----|----|KK--|KKKK| */
	adiw	r24,#zero+0	; 00 96
	adiw	r24,#zero+1	; 01 96
	adiw	r24,#zero+2	; 02 96
	adiw	r24,#zero+4	; 04 96
	adiw	r24,#zero+8	; 08 96
	adiw	r24,#zero+16	; 40 96
	adiw	r24,#zero+32	; 80 96

	;S_IOP		/* |----|-KK-|----|KKKK| */
	in	r0,zero+0	; 00 B0
	in	r0,zero+1	; 01 B0
	in	r0,zero+2	; 02 B0
	in	r0,zero+4	; 04 B0
	in	r0,zero+8	; 08 B0
	in	r0,zero+16	; 00 B2
	in	r0,zero+32	; 00 B4

	;S_IOR		/* |----|----|KKKK|K---| */
	cbi	zero+0,0	; 00 98
	cbi	zero+1,0	; 08 98
	cbi	zero+2,0	; 10 98
	cbi	zero+4,0	; 20 98
	cbi	zero+8,0	; 40 98
	cbi	zero+16,0	; 80 98

	;S_ILDST	/* |--K-|KK--|----|-KKK| */
	ldd	r0,z+zero+0	; 00 80
	ldd	r0,z+zero+1	; 01 80
	ldd	r0,z+zero+2	; 02 80
	ldd	r0,z+zero+4	; 04 80
	ldd	r0,z+zero+8	; 00 84
	ldd	r0,z+zero+16	; 00 88
	ldd	r0,z+zero+32	; 00 A0

	;S_BRA		/* |----|--KK|KKKK|K---| */
s_bra:	brcs	blbl+1		; 00 F0
	brcs	blbl+2+1	; 08 F0
	brcs	blbl+3+2	; 10 F0
	brcs	blbl+4+4	; 20 F0
	brcs	blbl+5+8	; 40 F0
	brcs	blbl+6+16	; 80 F0
	brcs	blbl+7+32	; 00 F1
	brcs	blbl+8-64	; 00 F2

	;S_RJMP		/* |----|KKKK|KKKK|KKKK| */
s_rjmp:	rjmp	rlbl+1		; 00 C0
	rjmp	rlbl+2+1	; 01 C0
	rjmp	rlbl+3+2	; 02 C0
	rjmp	rlbl+4+4	; 04 C0
	rjmp	rlbl+5+8	; 08 C0
	rjmp	rlbl+6+16	; 10 C0
	rjmp	rlbl+7+32	; 20 C0
	rjmp	rlbl+8+64	; 40 C0
	rjmp	rlbl+9+128	; 80 C0
	rjmp	rlbl+10+256	; 00 C1
	rjmp	rlbl+11+512	; 00 C2
	rjmp	rlbl+12+1024	; 00 C4
	rjmp	rlbl+13-2048	; 00 C8

	;S_JMP		/* |----|---K|KKKK|---K| // |KKKK|KKKK|KKKK|KKKK| */
	jmp	zero+0x00000000	; 0C 94 00 00
	jmp	zero+0x00000001	; 0C 94 01 00
	jmp	zero+0x00000002	; 0C 94 02 00
	jmp	zero+0x00000004	; 0C 94 04 00
	jmp	zero+0x00000008	; 0C 94 08 00
	jmp	zero+0x00000010	; 0C 94 10 00
	jmp	zero+0x00000020	; 0C 94 20 00
	jmp	zero+0x00000040	; 0C 94 40 00
	jmp	zero+0x00000080	; 0C 94 80 00
	jmp	zero+0x00000100	; 0C 94 00 01
	jmp	zero+0x00000200	; 0C 94 00 02
	jmp	zero+0x00000400	; 0C 94 00 04
	jmp	zero+0x00000800	; 0C 94 00 08
	jmp	zero+0x00001000	; 0C 94 00 10
	jmp	zero+0x00002000	; 0C 94 00 20
	jmp	zero+0x00004000	; 0C 94 00 40
	jmp	zero+0x00008000	; 0C 94 00 80
	jmp	zero+0x00010000	; 0D 94 00 00
	jmp	zero+0x00020000	; 1C 94 00 00
	jmp	zero+0x00040000	; 2C 94 00 00
	jmp	zero+0x00080000	; 4C 94 00 00
	jmp	zero+0x00100000	; 8C 94 00 00
	jmp	zero+0x00200000	; 0C 95 00 00



