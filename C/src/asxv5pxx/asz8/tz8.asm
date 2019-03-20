	.title	Test of Z8 assembler

	.sbttl	Z8 Sequential Opcodes

	dec	r1			; 00 E1
	dec	@r15			; 01 EF
	add	r1,r14			; 02 1E
	add	r1,@r14			; 03 1E
	add	0x20,0x30		; 04 30 20
	add	0x20,@0x30		; 05 30 20
	add	r1,#0x12		; 06 E1 12
	add	@r14,#0x12		; 07 EE 12
	ld	r0,0x20			; 08 20
	ld	0x20,r0			; 09 20
	djnz	r0,.+2			; 0A 00
	jr	F,.+2			; 0B 00
	ld	r0,#0x12		; 0C 12
	jp	F,.+3			; 0Ds00r21
	inc	r0			; 0E
	; 0F

	rlc	r1			; 10 E1
	rlc	@r15			; 11 EF
	adc	r1,r14			; 12 1E
	adc	r1,@r14			; 13 1E
	adc	0x20,0x30		; 14 30 20
	adc	0x20,@0x30		; 15 30 20
	adc	r1,#0x12		; 16 E1 12
	adc	@r14,#0x12		; 17 EE 12
	ld	r1,0x20			; 18 20
	ld	0x20,r1			; 19 20
	djnz	r1,.+2			; 1A 00
	jr	LT,.+2			; 1B 00
	ld	r1,#0x12		; 1C 12
	jp	LT,.+3			; 1Ds00r43
	inc	r1			; 1E
	; 1F

	inc	0xE1			; 20 E1
	inc	@r15			; 21 EF
	sub	r1,r14			; 22 1E
	sub	r1,@r14			; 23 1E
	sub	0x20,0x30		; 24 30 20
	sub	0x20,@0x30		; 25 30 20
	sub	r1,#0x12		; 26 E1 12
	sub	@r14,#0x12		; 27 EE 12
	ld	r2,0x20			; 28 20
	ld	0x20,r2			; 29 20
	djnz	r2,.+2			; 2A 00
	jr	LE,.+2			; 2B 00
	ld	r2,#0x12		; 2C 12
	jp	LE,.+3			; 2Ds00r65
	inc	r2			; 2E
	; 2F

	jp	@rr2			; 30 E2
	srp	#0x12			; 31 12
	sbc	r1,r14			; 32 1E
	sbc	r1,@r14			; 33 1E
	sbc	0x20,0x30		; 34 30 20
	sbc	0x20,@0x30		; 35 30 20
	sbc	r1,#0x12		; 36 E1 12
	sbc	@r14,#0x12		; 37 EE 12
	ld	r3,0x20			; 38 20
	ld	0x20,r3			; 39 20
	djnz	r3,.+2			; 3A 00
	jr	ULE,.+2			; 3B 00
	ld	r3,#0x12		; 3C 12
	jp	ULE,.+3			; 3Ds00r87
	inc	r3			; 3E
	; 3F

	da	r1			; 40 E1
	da	@r15			; 41 EF
	or	r1,r14			; 42 1E
	or	r1,@r14			; 43 1E
	or	0x20,0x30		; 44 30 20
	or	0x20,@0x30		; 45 30 20
	or	r1,#0x12		; 46 E1 12
	or	@r14,#0x12		; 47 EE 12
	ld	r4,0x20			; 48 20
	ld	0x20,r4			; 49 20
	djnz	r4,.+2			; 4A 00
	jr	OV,.+2			; 4B 00
	ld	r4,#0x12		; 4C 12
	jp	OV,.+3			; 4Ds00rA9
	inc	r4			; 4E
	wdh				; 4F

	pop	r1			; 50 E1
	pop	@r15			; 51 EF
	and	r1,r14			; 52 1E
	and	r1,@r14			; 53 1E
	and	0x20,0x30		; 54 30 20
	and	0x20,@0x30		; 55 30 20
	and	r1,#0x12		; 56 E1 12
	and	@r14,#0x12		; 57 EE 12
	ld	r5,0x20			; 58 20
	ld	0x20,r5			; 59 20
	djnz	r5,.+2			; 5A 00
	jr	MI,.+2			; 5B 00
	ld	r5,#0x12		; 5C 12
	jp	MI,.+3			; 5Ds00rCC
	inc	r5			; 5E
	wdt				; 5F

	com	r1			; 60 E1
	com	@r15			; 61 EF
	tcm	r1,r14			; 62 1E
	tcm	r1,@r14			; 63 1E
	tcm	0x20,0x30		; 64 30 20
	tcm	0x20,@0x30		; 65 30 20
	tcm	r1,#0x12		; 66 E1 12
	tcm	@r14,#0x12		; 67 EE 12
	ld	r6,0x20			; 68 20
	ld	0x20,r6			; 69 20
	djnz	r6,.+2			; 6A 00
	jr	Z,.+2			; 6B 00
	ld	r6,#0x12		; 6C 12
	jp	Z,.+3			; 6Ds00rEF
	inc	r6			; 6E
	stop				; 6F

	push	r1			; 70 E1
	push	@r15			; 71 EF
	tm	r1,r14			; 72 1E
	tm	r1,@r14			; 73 1E
	tm	0x20,0x30		; 74 30 20
	tm	0x20,@0x30		; 75 30 20
	tm	r1,#0x12		; 76 E1 12
	tm	@r14,#0x12		; 77 EE 12
	ld	r7,0x20			; 78 20
	ld	0x20,r7			; 79 20
	djnz	r7,.+2			; 7A 00
	jr	C,.+2			; 7B 00
	ld	r7,#0x12		; 7C 12
	jp	C,.+3			; 7Ds01r12
	inc	r7			; 7E
	halt				; 7F

	decw	rr2			; 80 E2
	decw	@r14			; 81 EE
	lde	r1,@rr14		; 82 1E
	ldei	@r1,@rr14		; 83 1E
	; 84
	; 85
	; 86
	; 87
	ld	r8,0x20			; 88 20
	ld	0x20,r8			; 89 20
	djnz	r8,.+2			; 8A 00
	jr	T,.+2			; 8B 00
	ld	r8,#0x12		; 8C 12
	jp	T,.+3			; 8Ds01r29
	inc	r8			; 8E
	di				; 8F

	rl	r1			; 90 E1
	rl	@r15			; 91 EF
	lde	@rr14,r1		; 92 1E
	ldei	@rr14,@r1		; 93 1E
	; 94
	; 95
	; 96
	; 97
	ld	r9,0x20			; 98 20
	ld	0x20,r9			; 99 20
	djnz	r9,.+2			; 9A 00
	jr	GE,.+2			; 9B 00
	ld	r9,#0x12		; 9C 12
	jp	GE,.+3			; 9Ds01r40
	inc	r9			; 9E
	ei				; 9F

	incw	rr2			; A0 E2
	incw	@r14			; A1 EE
	cp	r1,r14			; A2 1E
	cp	r1,@r14			; A3 1E
	cp	0x20,0x30		; A4 30 20
	cp	0x20,@0x30		; A5 30 20
	cp	r1,#0x12		; A6 E1 12
	cp	@r14,#0x12		; A7 EE 12
	ld	r10,0x20		; A8 20
	ld	0x20,r10		; A9 20
	djnz	r10,.+2			; AA 00
	jr	GT,.+2			; AB 00
	ld	r10,#0x12		; AC 12
	jp	GT,.+3			; ADs01r63
	inc	r10			; AE
	ret				; AF

	clr	r1			; B0 E1
	clr	@r15			; B1 EF
	xor	r1,r14			; B2 1E
	xor	r1,@r14			; B3 1E
	xor	0x20,0x30		; B4 30 20
	xor	0x20,@0x30		; B5 30 20
	xor	r1,#0x12		; B6 E1 12
	xor	@r14,#0x12		; B7 EE 12
	ld	r11,0x20		; B8 20
	ld	0x20,r11		; B9 20
	djnz	r11,.+2			; BA 00
	jr	UGT,.+2			; BB 00
	ld	r11,#0x12		; BC 12
	jp	UGT,.+3			; BDs01r86
	inc	r11			; BE
	iret				; BF

	rrc	r1			; C0 E1
	rrc	@r15			; C1 EF
	ldc	r1,@rr14		; C2 1E
	ldci	@r1,@rr14		; C3 1E
	; C4
	; C5
	; C6
	ld	r1,0x12(r14)		; C7 1E 12
	ld	r12,0x20		; C8 20
	ld	0x20,r12		; C9 20
	djnz	r12,.+2			; CA 00
	jr	NOV,.+2			; CB 00
	ld	r12,#0x12		; CC 12
	jp	NOV,.+3			; CDs01rA0
	inc	r12			; CE
	rcf				; CF

	sra	r1			; D0 E1
	sra	@r15			; D1 EF
	ldc	@rr14,r1		; D2 1E
	ldci	@rr14,@r1		; D3 1E
	call	@rr4			; D4 E4
	; D5
	call	0x1234			; D6 12 34
	ld	0x12(r14),r1		; D7 1E 12
	ld	r13,0x20		; D8 20
	ld	0x20,r13		; D9 20
	djnz	r13,.+2			; DA 00
	jr	PL,.+2			; DB 00
	ld	r13,#0x12		; DC 12
	jp	PL,.+3			; DDs01rBF
	inc	r13			; DE
	scf				; DF

	rr	r1			; E0 E1
	rr	@r15			; E1 EF
	; E2
	ld	r1,@r14			; E3 1E
	ld	0x20,0x30		; E4 30 20
	ld	0x20,@0x30		; E5 30 20
	ld	0x20,#0x12		; E6 20 12
	ld	@0x20,#0x12		; E7 20 12
	ld	r14,0x20		; E8 20
	ld	0x20,r14		; E9 20
	djnz	r14,.+2			; EA 00
	jr	NZ,.+2			; EB 00
	ld	r14,#0x12		; EC 12
	jp	NZ,.+3			; EDs01rE0
	inc	r14			; EE
	ccf				; EF

	swap	r1			; F0 E1
	swap	@r15			; F1 EF
	; F2
	ld	@r1,r14			; F3 1E
	; F4
	ld	@0x20,0x30		; F5 30 20
	; F6
	; F7
	ld	r15,0x20		; F8 20
	ld	0x20,r15		; F9 20
	djnz	r15,.+2			; FA 00
	jr	NC,.+2			; FB 00
	ld	r15,#0x12		; FC 12
	jp	NC,.+3			; FDs01rF8
	inc	r15			; FE
	nop				; FF

	.sbttl	Assembler Addressing Mode Tests

	.radix	d		        ; decimal radix

	n0	=	0		; constants
	n15	=	15
	n16	=	16
	n255	=	255

	; S_SOP:
	;	DEC	RLC	INC	DA	POP	COM	PUSH
	;	RL	CLR	RRC	SRA	RR	SWAP

	dec	r0			; 00 E0
	dec	r15			; 00 EF

	dec	0			; 00 00
	dec	15			; 00 0F
	dec	16			; 00 10
	dec	255			; 00 FF

	dec	@r0			; 01 E0
	dec	@r15			; 01 EF

	dec	@0			; 01 00
	dec	@15			; 01 0F
	dec	@16			; 01 10
	dec	@255			; 01 FF

	dec	(r0)			; 01 E0
	dec	(r15)			; 01 EF

	dec	(0)			; 01 00
	dec	(15)			; 01 0F
	dec	(16)			; 01 10
	dec	(255)			; 01 FF


	dec	n0			; 00 00
	dec	n15			; 00 0F
	dec	n16			; 00 10
	dec	n255			; 00 FF

	dec	@n0			; 01 00
	dec	@n15			; 01 0F
	dec	@n16			; 01 10
	dec	@n255			; 01 FF

	dec	(n0)			; 01 00
	dec	(n15)			; 01 0F
	dec	(n16)			; 01 10
	dec	(n255)			; 01 FF

	; S_INCW
	; S_DECW
	;	incw	decw

	;	INCW	RR
	incw	rr0			; A0 E0
	incw	rr14			; A0 EE
	incw	0			; A0 00
	incw	16			; A0 10
	; symbols
	incw	n0			; A0 00
	incw	n16			; A0 10

	;	INCW	@R
	incw	@r0			; A1 E0
	incw	@r14			; A1 EE
	incw	@0			; A1 00
	incw	@16			; A1 10
	; symbols
	incw	@n0			; A1 00
	incw	@n16			; A1 10

	;	INCW	@R	<<== (R)
	incw	(r0)			; A1 E0
	incw	(r14)			; A1 EE
	incw	(0)			; A1 00
	incw	(16)			; A1 10
	; symbols
	incw	(n0)			; A1 00
	incw	(n16)			; A1 10

	; S_DOP:
	;	ADD	ADC	SUB	SBC	OR
	;	AND	TCM	TM	CP	XOR

	;	ADD	r,r
	add	r0,r0			; 02 00
	add	r0,r15			; 02 0F
	add	r15,r0			; 02 F0
	add	r15,r15			; 02 FF

	;	ADD	r,@r
	add	r0,@r0			; 03 00
	add	r0,@r15			; 03 0F
	add	r15,@r0			; 03 F0
	add	r15,@r15		; 03 FF

	;	ADD	r,@r	<<== r,(r)
	add	r0,(r0)			; 03 00
	add	r0,(r15)		; 03 0F
	add	r15,(r0)		; 03 F0
	add	r15,(r15)		; 03 FF

	;	ADD	R,R
	add	0,0			; 04 00 00
	add	0,15			; 04 0F 00
	add	0,16			; 04 10 00
	add	0,255			; 04 FF 00
	add	15,0			; 04 00 0F
	add	15,15			; 04 0F 0F
	add	15,16			; 04 10 0F
	add	15,255			; 04 FF 0F
	add	16,0			; 04 00 10
	add	16,15			; 04 0F 10
	add	16,16			; 04 10 10
	add	16,255			; 04 FF 10
	add	255,0			; 04 00 FF
	add	255,15			; 04 0F FF
	add	255,16			; 04 10 FF
	add	255,255			; 04 FF FF

	;	ADD	R,R	<<== r,R / R,r
	add	r0,0			; 04 00 E0
	add	r0,15			; 04 0F E0
	add	r0,16			; 04 10 E0
	add	r0,255			; 04 FF E0
	add	r15,0			; 04 00 EF
	add	r15,15			; 04 0F EF
	add	r15,16			; 04 10 EF
	add	r15,255			; 04 FF EF
	add	0,r0			; 04 E0 00
	add	15,r0			; 04 E0 0F
	add	16,r0			; 04 E0 10
	add	255,r0			; 04 E0 FF
	add	0,r15			; 04 EF 00
	add	15,r15			; 04 EF 0F
	add	16,r15			; 04 EF 10
	add	255,r15			; 04 EF FF

	;	ADD	R,@R
	add	0,@0			; 05 00 00
	add	0,@15			; 05 0F 00
	add	0,@16			; 05 10 00
	add	0,@255			; 05 FF 00
	add	15,@0			; 05 00 0F
	add	15,@15			; 05 0F 0F
	add	15,@16			; 05 10 0F
	add	15,@255			; 05 FF 0F
	add	16,@0			; 05 00 10
	add	16,@15			; 05 0F 10
	add	16,@16			; 05 10 10
	add	16,@255			; 05 FF 10
	add	255,@0			; 05 00 FF
	add	255,@15			; 05 0F FF
	add	255,@16			; 05 10 FF
	add	255,@255		; 05 FF FF

	;	ADD	R,@R	<<== r,@R / R,@r
	add	r0,@0			; 05 00 E0
	add	r0,@15			; 05 0F E0
	add	r0,@16			; 05 10 E0
	add	r0,@255			; 05 FF E0
	add	r15,@0			; 05 00 EF
	add	r15,@15			; 05 0F EF
	add	r15,@16			; 05 10 EF
	add	r15,@255		; 05 FF EF
	add	0,@r0			; 05 E0 00
	add	15,@r0			; 05 E0 0F
	add	16,@r0			; 05 E0 10
	add	255,@r0			; 05 E0 FF
	add	0,@r15			; 05 EF 00
	add	15,@r15			; 05 EF 0F
	add	16,@r15			; 05 EF 10
	add	255,@r15		; 05 EF FF

	;	ADD	R,@R	<<== R,(R)
	add	0,(0)			; 05 00 00
	add	0,(15)			; 05 0F 00
	add	0,(16)			; 05 10 00
	add	0,(255)			; 05 FF 00
	add	15,(0)			; 05 00 0F
	add	15,(15)			; 05 0F 0F
	add	15,(16)			; 05 10 0F
	add	15,(255)		; 05 FF 0F
	add	16,(0)			; 05 00 10
	add	16,(15)			; 05 0F 10
	add	16,(16)			; 05 10 10
	add	16,(255)		; 05 FF 10
	add	255,(0)			; 05 00 FF
	add	255,(15)		; 05 0F FF
	add	255,(16)		; 05 10 FF
	add	255,(255)		; 05 FF FF

	;	ADD	R,@R	<<== r,(R) / R,(r)
	add	r0,(0)			; 05 00 E0
	add	r0,(15)			; 05 0F E0
	add	r0,(16)			; 05 10 E0
	add	r0,(255)		; 05 FF E0
	add	r15,(0)			; 05 00 EF
	add	r15,(15)		; 05 0F EF
	add	r15,(16)		; 05 10 EF
	add	r15,(255)		; 05 FF EF
	add	0,(r0)			; 05 E0 00
	add	15,(r0)			; 05 E0 0F
	add	16,(r0)			; 05 E0 10
	add	255,(r0)		; 05 E0 FF
	add	0,(r15)			; 05 EF 00
	add	15,(r15)		; 05 EF 0F
	add	16,(r15)		; 05 EF 10
	add	255,(r15)		; 05 EF FF

	;	ADD	R,R
	; (symbols)
	add	15,16			; 04 10 0F
	add	15,n16			; 04 10 0F
	add	n15,16			; 04 10 0F
	add	n15,n16			; 04 10 0F

	;	ADD	R,R	<<== r,R / R,r
	; (symbols)
	add	r15,16			; 04 10 EF
	add	r15,n16			; 04 10 EF
	add	16,r15			; 04 EF 10
	add	n16,r15			; 04 EF 10

	;	ADD	R,@R
	; (symbols)
	add	15,@16			; 05 10 0F
	add	15,@n16			; 05 10 0F
	add	n15,@16			; 05 10 0F
	add	n15,@n16		; 05 10 0F

	;	ADD	R,@R	<<== r,@R / R,@r
	; (symbols)
	add	r15,@15			; 05 0F EF
	add	r15,@n15		; 05 0F EF
	add	15,@r15			; 05 EF 0F
	add	n15,@r15		; 05 EF 0F

	;	ADD	R,@R	<<== R,(R)
	; (symbols)
	add	15,(16)			; 05 10 0F
	add	15,(n16)		; 05 10 0F
	add	n15,(16)		; 05 10 0F
	add	n15,(n16)		; 05 10 0F

	;	ADD	R,@R	<<== r,(R) / R,(r)
	; (symbols)
	add	r15,(15)		; 05 0F EF
	add	r15,(n15)		; 05 0F EF
	add	15,(r15)		; 05 EF 0F
	add	n15,(r15)		; 05 EF 0F

	;	ADD	R,#
	add	0,#0			; 06 00 00
	add	0,#15			; 06 00 0F
	add	0,#16			; 06 00 10
	add	0,#255			; 06 00 FF
	add	15,#0			; 06 0F 00
	add	15,#15			; 06 0F 0F
	add	15,#16			; 06 0F 10
	add	15,#255			; 06 0F FF
	add	16,#0			; 06 10 00
	add	16,#15			; 06 10 0F
	add	16,#16			; 06 10 10
	add	16,#255			; 06 10 FF
	add	255,#0			; 06 FF 00
	add	255,#15			; 06 FF 0F
	add	255,#16			; 06 FF 10
	add	255,#255		; 06 FF FF

	;	ADD	R,#	<<== r,#
	add	r0,#0			; 06 E0 00
	add	r0,#15			; 06 E0 0F
	add	r0,#16			; 06 E0 10
	add	r0,#255			; 06 E0 FF
	add	r15,#0			; 06 EF 00
	add	r15,#15			; 06 EF 0F
	add	r15,#16			; 06 EF 10
	add	r15,#255		; 06 EF FF

	;	ADD	R,#
	; (symbols)
	add	0,#n0			; 06 00 00
	add	0,#n15			; 06 00 0F
	add	0,#n16			; 06 00 10
	add	0,#n255			; 06 00 FF
	add	15,#n0			; 06 0F 00
	add	15,#n15			; 06 0F 0F
	add	15,#n16			; 06 0F 10
	add	15,#n255		; 06 0F FF
	add	16,#n0			; 06 10 00
	add	16,#n15			; 06 10 0F
	add	16,#n16			; 06 10 10
	add	16,#n255		; 06 10 FF
	add	255,#n0			; 06 FF 00
	add	255,#n15		; 06 FF 0F
	add	255,#n16		; 06 FF 10
	add	255,#n255		; 06 FF FF

	;	ADD	R,#	<<== r,#
	; (symbols)
	add	r0,#n0			; 06 E0 00
	add	r0,#n15			; 06 E0 0F
	add	r0,#n16			; 06 E0 10
	add	r0,#n255		; 06 E0 FF
	add	r15,#n0			; 06 EF 00
	add	r15,#n15		; 06 EF 0F
	add	r15,#n16		; 06 EF 10
	add	r15,#n255		; 06 EF FF

	;	ADD	@R,#
	add	@0,#0			; 07 00 00
	add	@0,#15			; 07 00 0F
	add	@0,#16			; 07 00 10
	add	@0,#255			; 07 00 FF
	add	@15,#0			; 07 0F 00
	add	@15,#15			; 07 0F 0F
	add	@15,#16			; 07 0F 10
	add	@15,#255		; 07 0F FF
	add	@16,#0			; 07 10 00
	add	@16,#15			; 07 10 0F
	add	@16,#16			; 07 10 10
	add	@16,#255		; 07 10 FF
	add	@255,#0			; 07 FF 00
	add	@255,#15		; 07 FF 0F
	add	@255,#16		; 07 FF 10
	add	@255,#255		; 07 FF FF

	;	ADD	R,#	<<== r,#
	add	@r0,#0			; 07 E0 00
	add	@r0,#15			; 07 E0 0F
	add	@r0,#16			; 07 E0 10
	add	@r0,#255		; 07 E0 FF
	add	@r15,#0			; 07 EF 00
	add	@r15,#15		; 07 EF 0F
	add	@r15,#16		; 07 EF 10
	add	@r15,#255		; 07 EF FF

	;	ADD	@R,#
	; (symbols)
	add	@0,#n0			; 07 00 00
	add	@0,#n15			; 07 00 0F
	add	@0,#n16			; 07 00 10
	add	@0,#n255		; 07 00 FF
	add	@15,#n0			; 07 0F 00
	add	@15,#n15		; 07 0F 0F
	add	@15,#n16		; 07 0F 10
	add	@15,#n255		; 07 0F FF
	add	@16,#n0			; 07 10 00
	add	@16,#n15		; 07 10 0F
	add	@16,#n16		; 07 10 10
	add	@16,#n255		; 07 10 FF
	add	@255,#n0		; 07 FF 00
	add	@255,#n15		; 07 FF 0F
	add	@255,#n16		; 07 FF 10
	add	@255,#n255		; 07 FF FF

	;	ADD	R,#	<<== r,#
	; (symbols)
	add	@r0,#n0			; 07 E0 00
	add	@r0,#n15		; 07 E0 0F
	add	@r0,#n16		; 07 E0 10
	add	@r0,#n255		; 07 E0 FF
	add	@r15,#n0		; 07 EF 00
	add	@r15,#n15		; 07 EF 0F
	add	@r15,#n16		; 07 EF 10
	add	@r15,#n255		; 07 EF FF

	;	DJNZ	r,'Relative Jump Address'
	djnz	r0,.-126		; 0A 80
	djnz	r0,.-125		; 0A 81
	djnz	r0,.-3			; 0A FB
	djnz	r0,.-2			; 0A FC
	djnz	r0,.-1			; 0A FD
	djnz	r0,.+0			; 0A FE
	djnz	r0,.+1			; 0A FF
	djnz	r0,.+2			; 0A 00
	djnz	r0,.+3			; 0A 01
	djnz	r0,.+128		; 0A 7E
	djnz	r0,.+129		; 0A 7F

	;	JR	CC,'Relative Jump Address'
	jr	f,.-126			; 0B 80
	jr	f,.-125			; 0B 81
	jr	f,.-3			; 0B FB
	jr	f,.-2			; 0B FC
	jr	f,.-1			; 0B FD
	jr	f,.+0			; 0B FE
	jr	f,.+1			; 0B FF
	jr	f,.+2			; 0B 00
	jr	f,.+3			; 0B 01
	jr	f,.+128			; 0B 7E
	jr	f,.+129			; 0B 7F

	;	JP	CC,'Jump Address'
jpadr1:	jp	f,jpadr5		; 0Ds05r32
jpadr2:	jp	f,jpadr4		; 0Ds05r2F
jpadr3:	jp	f,.			; 0Ds05r2C
jpadr4:	jp	f,jpadr2		; 0Ds05r29
jpadr5:	jp	f,jpadr1		; 0Ds05r26

	;	JP	@RR
	jp	@rr0			; 30 E0
	jp	(rr0)			; 30 E0
	jp	@0x20			; 30 20
	jp	(0x20)			; 30 20

	;	CALL	@RR
	call	@rr0			; D4 E0
	call	(rr0)			; D4 E0
	call	@0x20			; D4 20
	call	(0x20)			; D4 20

	; S_LDCE
	;	LDC	LDE

	;	LDC	r,@rr
	ldc	r0,@RR0			; C2 00
	ldc	r0,@RR14		; C2 0E
	ldc	r0,(RR0)		; C2 00
	ldc	r0,(RR14)		; C2 0E
	ldc	r15,@RR0		; C2 F0
	ldc	r15,@RR14		; C2 FE
	ldc	r15,(RR0)		; C2 F0
	ldc	r15,(RR14)		; C2 FE

	;	LDC	@rr,r
	ldc	@RR0,r0			; D2 00
	ldc	@RR14,r0		; D2 0E
	ldc	(RR0),r0		; D2 00
	ldc	(RR14),r0		; D2 0E
	ldc	@RR0,r15		; D2 F0
	ldc	@RR14,r15		; D2 FE
	ldc	(RR0),r15		; D2 F0
	ldc	(RR14),r15		; D2 FE

	; S_LDCEI
	;	LDCI	LDEI

	;	LDCI	@r,@rr
	ldci	@r0,@RR0		; C3 00
	ldci	@r0,@RR14		; C3 0E
	ldci	@r0,(RR0)		; C3 00
	ldci	@r0,(RR14)		; C3 0E
	ldci	@r15,@RR0		; C3 F0
	ldci	@r15,@RR14		; C3 FE
	ldci	@r15,(RR0)		; C3 F0
	ldci	@r15,(RR14)		; C3 FE

	;	LDCI	@rr,@r
	ldci	@RR0,@r0		; D3 00
	ldci	@RR14,@r0		; D3 0E
	ldci	(RR0),@r0		; D3 00
	ldci	(RR14),@r0		; D3 0E
	ldci	@RR0,@r15		; D3 F0
	ldci	@RR14,@r15		; D3 FE
	ldci	(RR0),@r15		; D3 F0
	ldci	(RR14),@r15		; D3 FE

	; S_LD
	;	LD

	;	LD	r,R
	ld	r0,0			; 08 00
	ld	r0,15			; 08 0F
	ld	r0,16			; 08 10
	ld	r0,255			; 08 FF
	ld	r15,0			; F8 00
	ld	r15,15			; F8 0F
	ld	r15,16			; F8 10
	ld	r15,255			; F8 FF

	;	LD	r,R
	; symbols
	ld	r0,n0			; 08 00
	ld	r0,n15			; 08 0F
	ld	r0,n16			; 08 10
	ld	r0,n255			; 08 FF
	ld	r15,n0			; F8 00
	ld	r15,n15			; F8 0F
	ld	r15,n16			; F8 10
	ld	r15,n255		; F8 FF

	;	LD	R,r
	ld	0,r0			; 09 00
	ld	15,r0			; 09 0F
	ld	16,r0			; 09 10
	ld	255,r0			; 09 FF
	ld	0,r15			; F9 00
	ld	15,r15			; F9 0F
	ld	16,r15			; F9 10
	ld	255,r15			; F9 FF

	;	LD	R,r
	; symbols
	ld	n0,r0			; 09 00
	ld	n15,r0			; 09 0F
	ld	n16,r0			; 09 10
	ld	n255,r0			; 09 FF
	ld	n0,r15			; F9 00
	ld	n15,r15			; F9 0F
	ld	n16,r15			; F9 10
	ld	n255,r15		; F9 FF

	;	LD	R,r	<<= r,r
	ld	r0,r0			; 09 E0
	ld	r0,r15			; F9 E0
	ld	r15,r0			; 09 EF
	ld	r15,r15			; F9 EF

	;	LD	r,@r
	ld	r0,@r0			; E3 00
	ld	r0,@r15			; E3 0F
	ld	r15,@r0			; E3 F0
	ld	r15,@r15		; E3 FF

	;	LD	r,@r	<<== r,(r)
	ld	r0,(r0)			; E3 00
	ld	r0,(r15)		; E3 0F
	ld	r15,(r0)		; E3 F0
	ld	r15,(r15)		; E3 FF

	;	LD	@r,r
	ld	@r0,r0			; F3 00
	ld	@r15,r0			; F3 F0
	ld	@r0,r15			; F3 0F
	ld	@r15,r15		; F3 FF

	;	LD	@r,r	<<== (r),r
	ld	(r0),r0			; F3 00
	ld	(r15),r0		; F3 F0
	ld	(r0),r15		; F3 0F
	ld	(r15),r15		; F3 FF

	;	LD	R,R
	ld	0,0			; E4 00 00
	ld	0,15			; E4 0F 00
	ld	0,16			; E4 10 00
	ld	0,255			; E4 FF 00
	ld	15,0			; E4 00 0F
	ld	15,15			; E4 0F 0F
	ld	15,16			; E4 10 0F
	ld	15,255			; E4 FF 0F
	ld	16,0			; E4 00 10
	ld	16,15			; E4 0F 10
	ld	16,16			; E4 10 10
	ld	16,255			; E4 FF 10
	ld	255,0			; E4 00 FF
	ld	255,15			; E4 0F FF
	ld	255,16			; E4 10 FF
	ld	255,255			; E4 FF FF

	;	LD	R,R
	; symbols
	ld	n0,15			; E4 0F 00
	ld	n15,16			; E4 10 0F
	ld	n16,255			; E4 FF 10
	ld	n255,0			; E4 00 FF

	;	LD	R,R
	; symbols
	ld	0,n15			; E4 0F 00
	ld	15,n16			; E4 10 0F
	ld	16,n255			; E4 FF 10
	ld	255,n0			; E4 00 FF

	;	LD	R,R
	; symbols
	ld	n0,n15			; E4 0F 00
	ld	n15,n16			; E4 10 0F
	ld	n16,n255		; E4 FF 10
	ld	n255,n0			; E4 00 FF

	;	LD	R,@R
	ld	0,@0			; E5 00 00
	ld	0,@15			; E5 0F 00
	ld	0,@16			; E5 10 00
	ld	0,@255			; E5 FF 00
	ld	15,@0			; E5 00 0F
	ld	15,@15			; E5 0F 0F
	ld	15,@16			; E5 10 0F
	ld	15,@255			; E5 FF 0F
	ld	16,@0			; E5 00 10
	ld	16,@15			; E5 0F 10
	ld	16,@16			; E5 10 10
	ld	16,@255			; E5 FF 10
	ld	255,@0			; E5 00 FF
	ld	255,@15			; E5 0F FF
	ld	255,@16			; E5 10 FF
	ld	255,@255		; E5 FF FF

	;	LD	R,@R
	; symbols
	ld	n0,@15			; E5 0F 00
	ld	n15,@16			; E5 10 0F
	ld	n16,@255		; E5 FF 10
	ld	n255,@0			; E5 00 FF

	;	LD	R,@R
	; symbols
	ld	0,@n15			; E5 0F 00
	ld	15,@n16			; E5 10 0F
	ld	16,@n255		; E5 FF 10
	ld	255,@n0			; E5 00 FF

	;	LD	R,@R
	; symbols
	ld	n0,@n15			; E5 0F 00
	ld	n15,@n16		; E5 10 0F
	ld	n16,@n255		; E5 FF 10
	ld	n255,@n0		; E5 00 FF

	;	LD	R,@R	<<== R,(R)
	ld	0,(0)			; E5 00 00
	ld	0,(15)			; E5 0F 00
	ld	0,(16)			; E5 10 00
	ld	0,(255)			; E5 FF 00
	ld	15,(0)			; E5 00 0F
	ld	15,(15)			; E5 0F 0F
	ld	15,(16)			; E5 10 0F
	ld	15,(255)		; E5 FF 0F
	ld	16,(0)			; E5 00 10
	ld	16,(15)			; E5 0F 10
	ld	16,(16)			; E5 10 10
	ld	16,(255)		; E5 FF 10
	ld	255,(0)			; E5 00 FF
	ld	255,(15)		; E5 0F FF
	ld	255,(16)		; E5 10 FF
	ld	255,(255)		; E5 FF FF

	;	LD	R,(R)
	; symbols
	ld	n0,(15)			; E5 0F 00
	ld	n15,(16)		; E5 10 0F
	ld	n16,(255)		; E5 FF 10
	ld	n255,(0)		; E5 00 FF

	;	LD	R,(R)
	; symbols
	ld	0,(n15)			; E5 0F 00
	ld	15,(n16)		; E5 10 0F
	ld	16,(n255)		; E5 FF 10
	ld	255,(n0)		; E5 00 FF

	;	LD	R,(R)
	; symbols
	ld	n0,(n15)		; E5 0F 00
	ld	n15,(n16)		; E5 10 0F
	ld	n16,(n255)		; E5 FF 10
	ld	n255,(n0)		; E5 00 FF

	;	LD	@R,R
	ld	@0,0			; F5 00 00
	ld	@0,15			; F5 0F 00
	ld	@0,16			; F5 10 00
	ld	@0,255			; F5 FF 00
	ld	@15,0			; F5 00 0F
	ld	@15,15			; F5 0F 0F
	ld	@15,16			; F5 10 0F
	ld	@15,255			; F5 FF 0F
	ld	@16,0			; F5 00 10
	ld	@16,15			; F5 0F 10
	ld	@16,16			; F5 10 10
	ld	@16,255			; F5 FF 10
	ld	@255,0			; F5 00 FF
	ld	@255,15			; F5 0F FF
	ld	@255,16			; F5 10 FF
	ld	@255,255		; F5 FF FF

	;	LD	@R,R
	; symbols
	ld	@n0,15			; F5 0F 00
	ld	@n15,16			; F5 10 0F
	ld	@n16,255		; F5 FF 10
	ld	@n255,0			; F5 00 FF

	;	LD	@R,R
	; symbols
	ld	@0,n15			; F5 0F 00
	ld	@15,n16			; F5 10 0F
	ld	@16,n255		; F5 FF 10
	ld	@255,n0			; F5 00 FF

	;	LD	@R,R
	; symbols
	ld	@n0,n15			; F5 0F 00
	ld	@n15,n16		; F5 10 0F
	ld	@n16,n255		; F5 FF 10
	ld	@n255,n0		; F5 00 FF

	;	LD	R,#
	ld	0,#0			; E6 00 00
	ld	0,#15			; E6 00 0F
	ld	0,#16			; E6 00 10
	ld	0,#255			; E6 00 FF
	ld	15,#0			; E6 0F 00
	ld	15,#15			; E6 0F 0F
	ld	15,#16			; E6 0F 10
	ld	15,#255			; E6 0F FF
	ld	16,#0			; E6 10 00
	ld	16,#15			; E6 10 0F
	ld	16,#16			; E6 10 10
	ld	16,#255			; E6 10 FF
	ld	255,#0			; E6 FF 00
	ld	255,#15			; E6 FF 0F
	ld	255,#16			; E6 FF 10
	ld	255,#255		; E6 FF FF

	;	LD	R,#
	; (symbols)
	ld	0,#n0			; E6 00 00
	ld	0,#n15			; E6 00 0F
	ld	0,#n16			; E6 00 10
	ld	0,#n255			; E6 00 FF
	ld	15,#n0			; E6 0F 00
	ld	15,#n15			; E6 0F 0F
	ld	15,#n16			; E6 0F 10
	ld	15,#n255		; E6 0F FF
	ld	16,#n0			; E6 10 00
	ld	16,#n15			; E6 10 0F
	ld	16,#n16			; E6 10 10
	ld	16,#n255		; E6 10 FF
	ld	255,#n0			; E6 FF 00
	ld	255,#n15		; E6 FF 0F
	ld	255,#n16		; E6 FF 10
	ld	255,#n255		; E6 FF FF

	;	LD	@R,#
	ld	@0,#0			; E7 00 00
	ld	@0,#15			; E7 00 0F
	ld	@0,#16			; E7 00 10
	ld	@0,#255			; E7 00 FF
	ld	@15,#0			; E7 0F 00
	ld	@15,#15			; E7 0F 0F
	ld	@15,#16			; E7 0F 10
	ld	@15,#255		; E7 0F FF
	ld	@16,#0			; E7 10 00
	ld	@16,#15			; E7 10 0F
	ld	@16,#16			; E7 10 10
	ld	@16,#255		; E7 10 FF
	ld	@255,#0			; E7 FF 00
	ld	@255,#15		; E7 FF 0F
	ld	@255,#16		; E7 FF 10
	ld	@255,#255		; E7 FF FF

	;	LD	@R,#	<<== (R),#
	ld	(0),#0			; E7 00 00
	ld	(0),#15			; E7 00 0F
	ld	(0),#16			; E7 00 10
	ld	(0),#255		; E7 00 FF
	ld	(15),#0			; E7 0F 00
	ld	(15),#15		; E7 0F 0F
	ld	(15),#16		; E7 0F 10
	ld	(15),#255		; E7 0F FF
	ld	(16),#0			; E7 10 00
	ld	(16),#15		; E7 10 0F
	ld	(16),#16		; E7 10 10
	ld	(16),#255		; E7 10 FF
	ld	(255),#0		; E7 FF 00
	ld	(255),#15		; E7 FF 0F
	ld	(255),#16		; E7 FF 10
	ld	(255),#255		; E7 FF FF

	;	LD	@R,#
	; (symbols)
	ld	@0,#n0			; E7 00 00
	ld	@0,#n15			; E7 00 0F
	ld	@0,#n16			; E7 00 10
	ld	@0,#n255		; E7 00 FF
	ld	@15,#n0			; E7 0F 00
	ld	@15,#n15		; E7 0F 0F
	ld	@15,#n16		; E7 0F 10
	ld	@15,#n255		; E7 0F FF
	ld	@16,#n0			; E7 10 00
	ld	@16,#n15		; E7 10 0F
	ld	@16,#n16		; E7 10 10
	ld	@16,#n255		; E7 10 FF
	ld	@255,#n0		; E7 FF 00
	ld	@255,#n15		; E7 FF 0F
	ld	@255,#n16		; E7 FF 10
	ld	@255,#n255		; E7 FF FF

	;	LD	@R,#	<<== (R),#
	; (symbols)
	ld	(0),#n0			; E7 00 00
	ld	(0),#n15		; E7 00 0F
	ld	(0),#n16		; E7 00 10
	ld	(0),#n255		; E7 00 FF
	ld	(15),#n0		; E7 0F 00
	ld	(15),#n15		; E7 0F 0F
	ld	(15),#n16		; E7 0F 10
	ld	(15),#n255		; E7 0F FF
	ld	(16),#n0		; E7 10 00
	ld	(16),#n15		; E7 10 0F
	ld	(16),#n16		; E7 10 10
	ld	(16),#n255		; E7 10 FF
	ld	(255),#n0		; E7 FF 00
	ld	(255),#n15		; E7 FF 0F
	ld	(255),#n16		; E7 FF 10
	ld	(255),#n255		; E7 FF FF

	;	LD	@R,#	<<== @r,#
	ld	@r0,#0			; E7 E0 00
	ld	@r0,#15			; E7 E0 0F
	ld	@r0,#16			; E7 E0 10
	ld	@r0,#255		; E7 E0 FF
	ld	@r15,#0			; E7 EF 00
	ld	@r15,#15		; E7 EF 0F
	ld	@r15,#16		; E7 EF 10
	ld	@r15,#255		; E7 EF FF

	;	LD	@R,#	<<== (r),#
	ld	(r0),#0			; E7 E0 00
	ld	(r0),#15		; E7 E0 0F
	ld	(r0),#16		; E7 E0 10
	ld	(r0),#255		; E7 E0 FF
	ld	(r15),#0		; E7 EF 00
	ld	(r15),#15		; E7 EF 0F
	ld	(r15),#16		; E7 EF 10
	ld	(r15),#255		; E7 EF FF

	;	LD	@R,#	<<== @r,#
	; symbols
	ld	@r0,#n0			; E7 E0 00
	ld	@r0,#n15		; E7 E0 0F
	ld	@r0,#n16		; E7 E0 10
	ld	@r0,#n255		; E7 E0 FF
	ld	@r15,#n0		; E7 EF 00
	ld	@r15,#n15		; E7 EF 0F
	ld	@r15,#n16		; E7 EF 10
	ld	@r15,#n255		; E7 EF FF

	;	LD	@R,#	<<== (r),#
	; symbols
	ld	(r0),#n0		; E7 E0 00
	ld	(r0),#n15		; E7 E0 0F
	ld	(r0),#n16		; E7 E0 10
	ld	(r0),#n255		; E7 E0 FF
	ld	(r15),#n0		; E7 EF 00
	ld	(r15),#n15		; E7 EF 0F
	ld	(r15),#n16		; E7 EF 10
	ld	(r15),#n255		; E7 EF FF

	;	LD	r,offset(r)
	ld	r0,0(r15)		; C7 0F 00
	ld	r1,15(r14)		; C7 1E 0F
	ld	r2,16(r13)		; C7 2D 10
	ld	r3,255(r12)		; C7 3C FF

	;	LD	r,offset(r)
	; symbols
	ld	r0,n0(r15)		; C7 0F 00
	ld	r1,n15(r14)		; C7 1E 0F
	ld	r2,n16(r13)		; C7 2D 10
	ld	r3,n255(r12)		; C7 3C FF

	;	LD	offset(r),r
	ld	0(r15),r0		; D7 0F 00
	ld	15(r14),r1		; D7 1E 0F
	ld	16(r13),r2		; D7 2D 10
	ld	255(r12),r3		; D7 3C FF

	;	LD	offset(r),r
	; symbols
	ld	n0(r15),r0		; D7 0F 00
	ld	n15(r14),r1		; D7 1E 0F
	ld	n16(r13),r2		; D7 2D 10
	ld	n255(r12),r3		; D7 3C FF



