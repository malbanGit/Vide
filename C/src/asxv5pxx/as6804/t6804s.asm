	.title	AS6804 Sequential Test

	.radix	x

	.area	DATA (ABS,OVR)

	bit0	=	0
	bit1	=	1
	bit2	=	2
	bit3	=	3
	bit4	=	4
	bit5	=	5
	bit6	=	6
	bit7	=	7

	defg = 0xFE

loc0:	.blkb	1
abcd:	.blkb	1
ram:	.blkb	1
	. = loc0 + 0x0100
loc1:
	. = loc0 + 0x0200
loc2:
	. = loc0 + 0x0300
loc3:
	. = loc0 + 0x0400
loc4:
	. = loc0 + 0x0500
loc5:
	. = loc0 + 0x0600
loc6:
	. = loc0 + 0x0700
loc7:
	. = loc0 + 0x0800
loc8:
	. = loc0 + 0x0900
loc9:
	. = loc0 + 0x0A00
loc10:
	. = loc0 + 0x0B00
loc11:
	. = loc0 + 0x0C00
loc12:
	. = loc0 + 0x0D00
loc13:
	. = loc0 + 0x0E00
loc14:
	. = loc0 + 0x0F00
loc15:


	.area	AS6804

	bne	.+0x01			; 00
	bne	.+0x02			; 01
	bne	.+0x03			; 02
	bne	.+0x04			; 03
	bne	.+0x05			; 04
	bne	.+0x06			; 05
	bne	.+0x07			; 06
	bne	.+0x08			; 07
	bne	.+0x09			; 08
	bne	.+0x0A			; 09
	bne	.+0x0B			; 0A
	bne	.+0x0C			; 0B
	bne	.+0x0D			; 0C
	bne	.+0x0E			; 0D
	bne	.+0x0F			; 0E
	bne	.+0x10			; 0F
	bne	.-0x0F			; 10
	bne	.-0x0E			; 11
	bne	.-0x0D			; 12
	bne	.-0x0C			; 13
	bne	.-0x0B			; 14
	bne	.-0x0A			; 15
	bne	.-0x09			; 16
	bne	.-0x08			; 17
	bne	.-0x07			; 18
	bne	.-0x06			; 19
	bne	.-0x05			; 1A
	bne	.-0x04			; 1B
	bne	.-0x03			; 1C
	bne	.-0x02			; 1D
	bne	.-0x01			; 1E
	bne	.			; 1F


	beq	.+0x01			; 20
	beq	.+0x02			; 21
	beq	.+0x03			; 22
	beq	.+0x04			; 23
	beq	.+0x05			; 24
	beq	.+0x06			; 25
	beq	.+0x07			; 26
	beq	.+0x08			; 27
	beq	.+0x09			; 28
	beq	.+0x0A			; 29
	beq	.+0x0B			; 2A
	beq	.+0x0C			; 2B
	beq	.+0x0D			; 2C
	beq	.+0x0E			; 2D
	beq	.+0x0F			; 2E
	beq	.+0x10			; 2F
	beq	.-0x0F			; 30
	beq	.-0x0E			; 31
	beq	.-0x0D			; 32
	beq	.-0x0C			; 33
	beq	.-0x0B			; 34
	beq	.-0x0A			; 35
	beq	.-0x09			; 36
	beq	.-0x08			; 37
	beq	.-0x07			; 38
	beq	.-0x06			; 39
	beq	.-0x05			; 3A
	beq	.-0x04			; 3B
	beq	.-0x03			; 3C
	beq	.-0x02			; 3D
	beq	.-0x01			; 3E
	beq	.			; 3F


	bcc	.+0x01			; 40
	bcc	.+0x02			; 41
	bcc	.+0x03			; 42
	bcc	.+0x04			; 43
	bcc	.+0x05			; 44
	bcc	.+0x06			; 45
	bcc	.+0x07			; 46
	bcc	.+0x08			; 47
	bcc	.+0x09			; 48
	bcc	.+0x0A			; 49
	bcc	.+0x0B			; 4A
	bcc	.+0x0C			; 4B
	bcc	.+0x0D			; 4C
	bcc	.+0x0E			; 4D
	bcc	.+0x0F			; 4E
	bcc	.+0x10			; 4F
	bcc	.-0x0F			; 50
	bcc	.-0x0E			; 51
	bcc	.-0x0D			; 52
	bcc	.-0x0C			; 53
	bcc	.-0x0B			; 54
	bcc	.-0x0A			; 55
	bcc	.-0x09			; 56
	bcc	.-0x08			; 57
	bcc	.-0x07			; 58
	bcc	.-0x06			; 59
	bcc	.-0x05			; 5A
	bcc	.-0x04			; 5B
	bcc	.-0x03			; 5C
	bcc	.-0x02			; 5D
	bcc	.-0x01			; 5E
	bcc	.			; 5F


	bcs	.+0x01			; 60
	bcs	.+0x02			; 61
	bcs	.+0x03			; 62
	bcs	.+0x04			; 63
	bcs	.+0x05			; 64
	bcs	.+0x06			; 65
	bcs	.+0x07			; 66
	bcs	.+0x08			; 67
	bcs	.+0x09			; 68
	bcs	.+0x0A			; 69
	bcs	.+0x0B			; 6A
	bcs	.+0x0C			; 6B
	bcs	.+0x0D			; 6C
	bcs	.+0x0E			; 6D
	bcs	.+0x0F			; 6E
	bcs	.+0x10			; 6F
	bcs	.-0x0F			; 70
	bcs	.-0x0E			; 71
	bcs	.-0x0D			; 72
	bcs	.-0x0C			; 73
	bcs	.-0x0B			; 74
	bcs	.-0x0A			; 75
	bcs	.-0x09			; 76
	bcs	.-0x08			; 77
	bcs	.-0x07			; 78
	bcs	.-0x06			; 79
	bcs	.-0x05			; 7A
	bcs	.-0x04			; 7B
	bcs	.-0x03			; 7C
	bcs	.-0x02			; 7D
	bcs	.-0x01			; 7E
	bcs	.			; 7F


	jsr	loc0			;s80r00
	jsr	loc1			;s81r00
	jsr	loc2			;s82r00
	jsr	loc3			;s83r00
	jsr	loc4			;s84r00
	jsr	loc5			;s85r00
	jsr	loc6			;s86r00
	jsr	loc7			;s87r00
	jsr	loc8			;s88r00
	jsr	loc9			;s89r00
	jsr	loc10			;s8Ar00
	jsr	loc11			;s8Br00
	jsr	loc12			;s8Cr00
	jsr	loc13			;s8Dr00
	jsr	loc14			;s8Er00
	jsr	loc15			;s8Fr00

	jmp	loc0			;s90r00
	jmp	loc1			;s91r00
	jmp	loc2			;s92r00
	jmp	loc3			;s93r00
	jmp	loc4			;s94r00
	jmp	loc5			;s95r00
	jmp	loc6			;s96r00
	jmp	loc7			;s97r00
	jmp	loc8			;s98r00
	jmp	loc9			;s99r00
	jmp	loc10			;s9Ar00
	jmp	loc11			;s9Br00
	jmp	loc12			;s9Cr00
	jmp	loc13			;s9Dr00
	jmp	loc14			;s9Er00
	jmp	loc15			;s9Fr00


					; A0
					; A1
					; A2
					; A3
					; A4
					; A5
					; A6
					; A7
	incx				; A8
	incy				; A9
					; AA
					; AB
	txa				; AC
	tya				; AD
					; AE
					; AF

	mvi	abcd,#defg		; B0*01 FE
					; B1
	rti				; B2
	rts				; B3
	coma				; B4
	rola				; B5
	stop				; B6
	wait				; B7
	decx				; B8
	decy				; B9
					; BA
					; BB
	tax				; BC
	tay				; BD
					; BE
					; BF


1$:	brclr	#bit0,ram, .		; C0*02 FD
2$:	brclr	#bit1,ram,2$		; C1*02 FD
3$:	brclr	#bit2,ram,3$		; C2*02 FD
4$:	brclr	#bit3,ram,4$		; C3*02 FD
5$:	brclr	#bit4,ram,5$		; C4*02 FD
6$:	brclr	#bit5,ram,6$		; C5*02 FD
7$:	brclr	#bit6,ram,7$		; C6*02 FD
8$:	brclr	#bit7,ram,8$		; C7*02 FD

9$:	brset	#bit0,ram,9$		; C8*02 FD
10$:	brset	#bit1,ram,10$		; C9*02 FD
11$:	brset	#bit2,ram,11$		; CA*02 FD
12$:	brset	#bit3,ram,12$		; CB*02 FD
13$:	brset	#bit4,ram,13$		; CC*02 FD
14$:	brset	#bit5,ram,14$		; CD*02 FD
15$:	brset	#bit6,ram,15$		; CE*02 FD
16$:	brset	#bit7,ram,16$		; CF*02 FD

	bclr	#bit0,ram		; D0*02
	bclr	#bit1,ram		; D1*02
	bclr	#bit2,ram		; D2*02
	bclr	#bit3,ram		; D3*02
	bclr	#bit4,ram		; D4*02
	bclr	#bit5,ram		; D5*02
	bclr	#bit6,ram		; D6*02
	bclr	#bit7,ram		; D7*02

	bset	#bit0,ram		; D8*02
	bset	#bit1,ram		; D9*02
	bset	#bit2,ram		; DA*02
	bset	#bit3,ram		; DB*02
	bset	#bit4,ram		; DC*02
	bset	#bit5,ram		; DD*02
	bset	#bit6,ram		; DE*02
	bset	#bit7,ram		; DF*02


	lda	,x			; E0
	sta	,x			; E1
	add	,x			; E2
	sub	,x			; E3
	cmp	,x			; E4
	and	,x			; E5
	inc	,x			; E6
	dec	,x			; E7

	lda	#defg			; E8 FE
					; E9
	add	#defg			; EA FE
	sub	#defg			; EB FE
	cmp	#defg			; EC FE
	and	#defg			; ED FE
					; EE
					; EF

	lda	,y			; F0
	sta	,y			; F1
	add	,y			; F2
	sub	,y			; F3
	cmp	,y			; F4
	and	,y			; F5
	inc	,y			; F6
	dec	,y			; F7

	lda	ram			; F8*02
	sta	ram			; F9*02
	add	ram			; FA*02
	sub	ram			; FB*02
	cmp	ram			; FC*02
	and	ram			; FD*02
	inc	ram			; FE*02
	dec	ram			; FF*02

	.sbttl	Special Forms of inc, dec, lda, and sta

	; incx
	inc	0x80			; A8
	; incy
	inc	0x81			; A9
	inc	0x82			; AA
	inc	0x83			; AB
	; txa
	lda	0x80			; AC
	; tya
	lda	0x81			; AD
	lda	0x82			; AE
	lda	0x83			; AF

	; decx
	dec	0x80			; B8
	; decy
	dec	0x81			; B9
	dec	0x82			; BA
	dec	0x83			; BB
	; tax
	sta	0x80			; BC
	; tay
	sta	0x81			; BD
	sta	0x82			; BE
	sta	0x83			; BF

	.sbttl	Derived Instructions

	asla				; FA FF
17$:	bam	17$			; CF FF FD
18$:	bap	18$			; C7 FF FD
19$:	bxmi	19$			; CF 80 FD
20$:	bxpl	20$			; C7 80 FD
21$:	bymi	21$			; CF 81 FD
22$:	bypl	22$			; C7 81 FD
	clra				; FB FF
	clrx				; B0 80 00
	clry				; B0 81 00
	deca				; FF FF
	decx				; B8
	decy				; B9
	inca				; FE FF
	incx				; A8
	incy				; A9
	ldxi	#defg			; B0 80 FE
	ldyi	#defg			; B0 81 FE
	nop				; 20
	tax				; BC
	tay				; BD
	txa				; AC
	tya				; AD

