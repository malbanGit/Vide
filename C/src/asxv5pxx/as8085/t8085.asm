	.title	Test of 8085/8080 Assembler
	.sbttl	All 8085/8080 instructions

	aci	#1			; CE 01

	adc	b			; 88
	adc	m			; 8E

	add	c			; 81
	add	m			; 86

	adi	#2			; C6 02

	ana	d			; A2
	ana	m			; A6

	ani	#3			; E6 03

	arhl				; 10

	call	next1			; CDr28s00

	cc	next1			; DCr28s00

	cm	next1			; FCr28s00

	cnc	next1			; D4r28s00

	cnz	next1			; C4r28s00

	cp	next1			; F4r28s00

	cpe	next1			; ECr28s00

	cpo	next1			; E4r28s00

	cz	next1			; CCr28s00

next1:

	cma				; 2F

	cmc				; 3F

	cmp	e			; BB
	cmp	m			; BE

	cpi	#4			; FE 04

	daa				; 27

	dad	b			; 09

	dcr	a			; 3D
	dcr	m			; 35

	dcx	b			; 0B

	di				; F3

	dsub				; 08

	ei				; FB

	hlt				; 76

	in	#5			; DB 05

	inr	a			; 3C
	inr	m			; 34

	inx	h			; 23

	jc	jmpadr			; DAr5Ds00

	jm	jmpadr			; FAr5Ds00

	jmp	jmpadr			; C3r5Ds00

	jnc	jmpadr			; D2r5Ds00

	jnz	jmpadr			; C2r5Ds00

	jp	jmpadr			; F2r5Ds00

	jpe	jmpadr			; EAr5Ds00

	jpo	jmpadr			; E2r5Ds00

	jz	jmpadr			; CAr5Ds00

	jnx5	jmpadr			; DDr5Ds00

	jx5	jmpadr			; FDr5Ds00

jmpadr:	.word	jmpadr			;r5Ds00

	lda	jmpadr			; 3Ar5Ds00

	ldax	b			; 0A

	ldhi	#4			; 28 04

	ldsi	#5			; 38 05

	lhld	jmpadr			; 2Ar5Ds00

	lhlx				; ED

	lxi	sp,#0xeeee		; 31 EE EE

	mov	c,d			; 4A
	mov	c,m			; 4E
	mov	m,c			; 71

	mvi	c,#0xff			; 0E FF
	mvi	m,#0h2c			; 36 2C

	nop				; 00

	ora	b			; B0
	ora	m			; B6

	ori	#4			; F6 04

	out	#5			; D3 05

	pchl				; E9

	pop	h			; E1

	push	b			; C5

	ral				; 17

	rar				; 1F

	rdel				; 18

	ret				; C9

	rim				; 20

	rc				; D8
	rlc				; 07
	rm				; F8
	rnc				; D0
	rnz				; C0
	rp				; F0
	rpe				; E8
	rpo				; E0
	rz				; C8

	rrc				; 0F

	rst	#3			; DF

	rstv				; CB

	sbb	c			; 99
	sbb	m			; 9E

	sbi	#5			; DE 05

	shld	jmpadr			; 22r5Ds00

	shlx				; D9

	sim				; 30

	sphl				; F9

	sta	jmpadr+1		; 32r5Es00

	stax	b			; 02

	stc				; 37

	sub	l			; 95
	sub	m			; 96

	sui	#0x22			; D6 22

	xchg				; EB

	xra	b			; A8
	xra	m			; AE

	xri	#0o377			; EE FF

	xthl				; E3

