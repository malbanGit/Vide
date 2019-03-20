	.title Test Module for the Zilog eZ80 processor

	.sbttl	EZ80 Mode

	.adl
	.radix h

	.ascii	/Hello,	world/

	;var1=10
	.define	var1, "varx + 10"

	var2==20

	;_bit7= 7
	.define	_bit7, "varx + 7"


	adc	a,(hl)		; 8E
	adc.s	a,(hl)		; 52 8E
	adc	a,ixh		; DD 8C
	adc	a,ixl		; DD 8D
	adc	a,iyh		; FD 8C
	adc	a,iyl		; FD 8D
	adc	a,(ix+var2)	; DD 8E 20
	adc.s	a,(ix+19)	; 52 DD 8E 19
	adc	a,(iy+var2)	; FD 8E 20
	adc.s	a,(iy+19)	; 52 FD 8E 19
	adc	a,var2		; CE 20
	adc	a,a		; 8F
	adc	a,b		; 88
	adc	a,c		; 89
	adc	a,d		; 8A
	adc	a,e		; 8B
	adc	a,h		; 8C
	adc	a,l		; 8D

	;These are added for backward compatibility with
	;the original Z80 assembler which optionally
	;does not require the 'A' register to be named.

	adc	(hl)		; 8E
	adc.s	(hl)		; 52 8E
	adc	ixh		; DD 8C
	adc	ixl		; DD 8D
	adc	iyh		; FD 8C
	adc	iyl		; FD 8D
	adc	(ix+var2)	; DD 8E 20
	adc.s	(ix+19)		; 52 DD 8E 19
	adc	(iy+var2)	; FD 8E 20
	adc.s	(iy+19)		; 52 FD 8E 19
	adc	var2		; CE 20
	adc	a		; 8F
	adc	b		; 88
	adc	c		; 89
	adc	d		; 8A
	adc	e		; 8B
	adc	h		; 8C
	adc	l		; 8D

	;End of Z80 compatibility section

	adc	hl,bc		; ED 4A
	adc	hl,de		; ED 5A
	adc	hl,hl		; ED 6A
	adc.s	hl,bc		; 52 ED 4A
	adc.s	hl,de		; 52 ED 5A
	adc.s	hl,hl		; 52 ED 6A
	adc	hl,sp		; ED 7A
	adc.s	hl,sp		; 52 ED 7A

	add	a,(hl)		; 86
	add.s	a,(hl)		; 52 86
	add	a,ixh		; DD 84
	add	a,ixl		; DD 85
	add	a,iyh		; FD 84
	add	a,iyl		; FD 85
	add	a,(ix+var2)	; DD 86 20
	add.s	a,(ix+19)	; 52 DD 86 19
	add	a,(iy+var2)	; FD 86 20
	add.s	a,(iy+19)	; 52 FD 86 19
	add	a,var2		; C6 20
	add	a,a		; 87
	add	a,b		; 80
	add	a,c		; 81
	add	a,d		; 82
	add	a,e		; 83
	add	a,h		; 84
	add	a,l		; 85
	add	hl,bc		; 09
	add	hl,de		; 19
	add	hl,hl		; 29
	add.s	hl,bc		; 52 09
	add.s	hl,de		; 52 19
	add.s	hl,hl		; 52 29
	add	hl,sp		; 39
	add.s	hl,sp		; 52 39
	add	ix,bc		; DD 09
	add	ix,de		; DD 19
	add	ix,ix		; DD 29
	add.s	ix,bc		; 52 DD 09
	add.s	ix,de		; 52 DD 19
	add.s	ix,ix		; 52 DD 29
	add	iy,bc		; FD 09
	add	iy,de		; FD 19
	add	iy,iy		; FD 29
	add.s	iy,bc		; 52 FD 09
	add.s	iy,de		; 52 FD 19
	add.s	iy,iy		; 52 FD 29
	add	ix,sp		; DD 39
	add.s	ix,sp		; 52 DD 39
	add	iy,sp		; FD 39
	add.s	iy,sp		; 52 FD 39

	and	a,(hl)		; A6
	and.s	a,(hl)		; 52 A6
	and	a,ixh		; DD A4
	and	a,ixl		; DD A5
	and	a,iyh		; FD A4
	and	a,iyl		; FD A5
	and	a,(ix+var2)	; DD A6 20
	and.s	a,(ix+19)	; 52 DD A6 19
	and	a,(iy+var2)	; FD A6 20
	and.s	a,(iy+19)	; 52 FD A6 19
	and	a,var2		; E6 20
	and	a,a		; A7
	and	a,b		; A0
	and	a,c		; A1
	and	a,d		; A2
	and	a,e		; A3
	and	a,h		; A4
	and	a,l		; A5

	bit	0,(hl)		; CB 46
	bit	1,(hl)		; CB 4E
	bit	2,(hl)		; CB 56
	bit	3,(hl)		; CB 5E
	bit	4,(hl)		; CB 66
	bit	5,(hl)		; CB 6E
	bit	6,(hl)		; CB 76
	bit	_bit7,(hl)	; CBu7E
	bit.s	0,(hl)		; 52 CB 46
	bit.s	1,(hl)		; 52 CB 4E
	bit.s	2,(hl)		; 52 CB 56
	bit.s	3,(hl)		; 52 CB 5E
	bit.s	4,(hl)		; 52 CB 66
	bit.s	5,(hl)		; 52 CB 6E
	bit.s	6,(hl)		; 52 CB 76
	bit.s	_bit7,(hl)	; 52 CBu7E
	bit	0,(ix+var1)	; DD CBr10 46
	bit	1,(ix+var2)	; DD CB 20 4E
	bit	2,(ix+19)	; DD CB 19 56
	bit	3,(ix+var1)	; DD CBr10 5E
	bit	4,(ix+var2)	; DD CB 20 66
	bit	5,(ix+19)	; DD CB 19 6E
	bit	6,(ix+var1)	; DD CBr10 76
	bit	_bit7,(ix+var2)	; DD CB 20u7E
	bit.s	0,(ix+19)	; 52 DD CB 19 46
	bit.s	1,(ix+var1)	; 52 DD CBr10 4E
	bit.s	2,(ix+var2)	; 52 DD CB 20 56
	bit.s	3,(ix+19)	; 52 DD CB 19 5E
	bit.s	4,(ix+var1)	; 52 DD CBr10 66
	bit.s	5,(ix+var2)	; 52 DD CB 20 6E
	bit.s	6,(ix+19)	; 52 DD CB 19 76
	bit.s	_bit7,(ix+var1)	; 52 DD CBr10u7E
	bit	0,(iy+var1)	; FD CBr10 46
	bit	1,(iy+var2)	; FD CB 20 4E
	bit	2,(iy+19)	; FD CB 19 56
	bit	3,(iy+var1)	; FD CBr10 5E
	bit	4,(iy+var2)	; FD CB 20 66
	bit	5,(iy+19)	; FD CB 19 6E
	bit	6,(iy+var1)	; FD CBr10 76
	bit	_bit7,(iy+var2)	; FD CB 20u7E
	bit.s	0,(iy+19)	; 52 FD CB 19 46
	bit.s	1,(iy+var1)	; 52 FD CBr10 4E
	bit.s	2,(iy+var2)	; 52 FD CB 20 56
	bit.s	3,(iy+19)	; 52 FD CB 19 5E
	bit.s	4,(iy+var1)	; 52 FD CBr10 66
	bit.s	5,(iy+var2)	; 52 FD CB 20 6E
	bit.s	6,(iy+19)	; 52 FD CB 19 76
	bit.s	_bit7,(iy+var1)	; 52 FD CBr10u7E
	bit	0,a		; CB 47
	bit	0,b		; CB 40
	bit	0,c		; CB 41
	bit	0,d		; CB 42
	bit	0,e		; CB 43
	bit	0,h		; CB 44
	bit	0,l		; CB 45
	bit	1,a		; CB 4F
	bit	1,b		; CB 48
	bit	1,c		; CB 49
	bit	1,d		; CB 4A
	bit	1,e		; CB 4B
	bit	1,h		; CB 4C
	bit	1,l		; CB 4D
	bit	2,a		; CB 57
	bit	2,b		; CB 50
	bit	2,c		; CB 51
	bit	2,d		; CB 52
	bit	2,e		; CB 53
	bit	2,h		; CB 54
	bit	2,l		; CB 55
	bit	3,a		; CB 5F
	bit	3,b		; CB 58
	bit	3,c		; CB 59
	bit	3,d		; CB 5A
	bit	3,e		; CB 5B
	bit	3,h		; CB 5C
	bit	3,l		; CB 5D
	bit	4,a		; CB 67
	bit	4,b		; CB 60
	bit	4,c		; CB 61
	bit	4,d		; CB 62
	bit	4,e		; CB 63
	bit	4,h		; CB 64
	bit	4,l		; CB 65
	bit	5,a		; CB 6F
	bit	5,b		; CB 68
	bit	5,c		; CB 69
	bit	5,d		; CB 6A
	bit	5,e		; CB 6B
	bit	5,h		; CB 6C
	bit	5,l		; CB 6D
	bit	6,a		; CB 77
	bit	6,b		; CB 70
	bit	6,c		; CB 71
	bit	6,d		; CB 72
	bit	6,e		; CB 73
	bit	6,h		; CB 74
	bit	6,l		; CB 75
	bit	_bit7,a		; CBu7F
	bit	_bit7,b		; CBu78
	bit	_bit7,c		; CBu79
	bit	_bit7,d		; CBu7A
	bit	_bit7,e		; CBu7B
	bit	_bit7,h		; CBu7C
	bit	_bit7,l		; CBu7D

	call	nz,var1		; C4r10s00R00
	call.il	nz,var2		; 5B C4 20 00 00
	call	z,var1		; CCr10s00R00
	call.il	z,var2		; 5B CC 20 00 00
	call	nc,var1		; D4r10s00R00
	call.il	nc,var2		; 5B D4 20 00 00
	call	c,var1		; DCr10s00R00
	call.il	c,var2		; 5B DC 20 00 00
	call	po,var1		; E4r10s00R00
	call.il	po,var2		; 5B E4 20 00 00
	call	pe,var1		; ECr10s00R00
	call.il	pe,var2		; 5B EC 20 00 00
	call	p,var1		; F4r10s00R00
	call.il	p,var2		; 5B F4 20 00 00
	call	m,var1		; FCr10s00R00
	call.il	m,var2		; 5B FC 20 00 00
	call	var1		; CDr10s00R00
	call.il	var2		; 5B CD 20 00 00

	ccf			; 3F

	cp	a,(hl)		; BE
	cp.s	a,(hl)		; 52 BE
	cp	a,ixh		; DD BC
	cp	a,ixl		; DD BD
	cp	a,iyh		; FD BC
	cp	a,iyl		; FD BD
	cp	a,(ix+var2)	; DD BE 20
	cp.s	a,(ix+19)	; 52 DD BE 19
	cp	a,(iy+var2)	; FD BE 20
	cp.s	a,(iy+19)	; 52 FD BE 19
	cp	a,var2		; FE 20
	cp	a,a		; BF
	cp	a,b		; B8
	cp	a,c		; B9
	cp	a,d		; BA
	cp	a,e		; BB
	cp	a,h		; BC
	cp	a,l		; BD

	cpd			; ED A9
	cpd.s			; 52 ED A9

	cpdr			; ED B9
	cpdr.s			; 52 ED B9

	cpi			; ED A1
	cpi.s			; 52 ED A1

	cpir			; ED B1
	cpir.s			; 52 ED B1

	cpl			; 2F

	daa			; 27

	dec	(hl)		; 35
	dec.s	(hl)		; 52 35
	dec	ixh		; DD 25
	dec	ixl		; DD 2D
	dec	iyh		; FD 25
	dec	iyl		; FD 2D
	dec	ix		; DD 2B
	dec.s	ix		; 52 DD 2B
	dec	iy		; FD 2B
	dec.s	iy		; 52 FD 2B
	dec	(ix+var1)	; DD 35r10
	dec.s	(ix+var2)	; 52 DD 35 20
	dec	(iy+var1)	; FD 35r10
	dec.s	(iy+var2)	; 52 FD 35 20
	dec	a		; 3D
	dec	b		; 05
	dec	c		; 0D
	dec	d		; 15
	dec	e		; 1D
	dec	h		; 25
	dec	l		; 2D
	dec	bc		; 0B
	dec	de		; 1B
	dec	hl		; 2B
	dec.s	bc		; 52 0B
	dec.s	de		; 52 1B
	dec.s	hl		; 52 2B
	dec	sp		; 3B
	dec.s	sp		; 52 3B

	di			; F3

	djnz	jr0adl		; 10 00
	jr0adl:

	ei			; FB

	ex	af,af'		; 08
	ex	de,hl		; EB
	ex	(sp),hl		; E3
	ex.s	(sp),hl		; 52 E3
	ex	(sp),ix		; DD E3
	ex.s	(sp),ix		; 52 DD E3
	ex	(sp),iy		; FD E3
	ex.s	(sp),iy		; 52 FD E3

	exx			; D9

	halt			; 76

	im	0		; ED 46
	im	1		; ED 56
	im	2		; ED 5E

	in	a,(19)		; DB 19
	in	a,(bc)		; ED 78
	in	b,(bc)		; ED 40
	in	c,(bc)		; ED 48
	in	d,(bc)		; ED 50
	in	e,(bc)		; ED 58
	in	h,(bc)		; ED 60
	in	l,(bc)		; ED 68
	in	a,(c)		; ED 78
	in	b,(c)		; ED 40
	in	c,(c)		; ED 48
	in	d,(c)		; ED 50
	in	e,(c)		; ED 58
	in	h,(c)		; ED 60
	in	l,(c)		; ED 68

	in0	a,(19)		; ED 38 19
	in0	b,(var1)	; ED 00u10
	in0	c,(var2)	; ED 08 20
	in0	d,(19)		; ED 10 19
	in0	e,(var1)	; ED 18u10
	in0	h,(var2)	; ED 20 20
	in0	l,(19)		; ED 28 19

	inc	(hl)		; 34
	inc.s	(hl)		; 52 34
	inc	ixh		; DD 24
	inc	ixl		; DD 2C
	inc	iyh		; FD 24
	inc	iyl		; FD 2C
	inc	ix		; DD 23
	inc.s	ix		; 52 DD 23
	inc	iy		; FD 23
	inc.s	iy		; 52 FD 23
	inc	(ix+var2)	; DD 34 20
	inc.s	(ix+19)		; 52 DD 34 19
	inc	(iy+var2)	; FD 34 20
	inc.s	(iy+19)		; 52 FD 34 19
	inc	a		; 3C
	inc	b		; 04
	inc	c		; 0C
	inc	d		; 14
	inc	e		; 1C
	inc	h		; 24
	inc	l		; 2C
	inc	bc		; 03
	inc	de		; 13
	inc	hl		; 23
	inc.s	bc		; 52 03
	inc.s	de		; 52 13
	inc.s	hl		; 52 23
	inc	sp		; 33
	inc.s	sp		; 52 33

	ind			; ED AA
	ind.s			; 52 ED AA

	ind2			; ED 8C
	ind2.s			; 52 ED 8C

	ind2r			; ED 9C
	ind2r.s			; 52 ED 9C

	indm			; ED 8A
	indm.s			; 52 ED 8A

	indmr			; ED 9A
	indmr.s			; 52 ED 9A

	indr			; ED BA
	indr.s			; 52 ED BA

	indrx			; ED CA
	indrx.s			; 52 ED CA

	ini			; ED A2
	ini.s			; 52 ED A2

	ini2			; ED 84
	ini2.s			; 52 ED 84

	ini2r			; ED 94
	ini2r.s			; 52 ED 94

	inim			; ED 82
	inim.s			; 52 ED 82

	inimr			; ED 92
	inimr.s			; 52 ED 92

	inir			; ED B2
	inir.s			; 52 ED B2

	inirx			; ED C2
	inirx.s			; 52 ED C2

	jp	nz,var2		; C2 20 00 00
	jp	z,19		; CA 19 00 00
	jp	nc,var1		; D2r10s00R00
	jp	c,var2		; DA 20 00 00
	jp	po,19		; E2 19 00 00
	jp	pe,var1		; EAr10s00R00
	jp	p,var2		; F2 20 00 00
	jp	m,19		; FA 19 00 00
	jp.lil	nz,19		; 5B C2 19 00 00
	jp.lil	z,var1		; 5B CAr10s00R00
	jp.lil	nc,var2		; 5B D2 20 00 00
	jp.lil	c,19		; 5B DA 19 00 00
	jp.lil	po,var1		; 5B E2r10s00R00
	jp.lil	pe,var2		; 5B EA 20 00 00
	jp.lil	p,19		; 5B F2 19 00 00
	jp.lil	m,var1		; 5B FAr10s00R00
	jp	(hl)		; E9
	jp.s	(hl)		; 52 E9
	jp	(ix)		; DD E9
	jp.s	(ix)		; 40 DD E9
	jp.l	(ix)		; 5B DD E9
	jp	(iy)		; FD E9
	jp.s	(iy)		; 40 FD E9
	jp.l	(iy)		; 5B FD E9
	jp	19		; C3 19 00 00
	jp.lil	var2		; 5B C3 20 00 00

	jr	nz,jr1adl	; 20 08
	jr	z,jr2adl	; 28 06
	jr	nc,jr3adl	; 30 04
	jr	c,jr4adl	; 38 02
	jr	jr5adl		; 18 0

	jr1adl:	jr2adl: jr3adl: jr4adl: jr5adl:

	ld	a,i		; ED 57
	ld	a,(ix+19)	; DD 7E 19
	ld.s	a,(ix+var1)	; 52 DD 7Er10
	ld	a,(iy+19)	; FD 7E 19
	ld.s	a,(iy+var1)	; 52 FD 7Er10
	ld	a,mb		; ED 6E
	ld	a,(var2)	; 3A 20 00 00
	ld	a,r		; ED 5F
	ld	a,(bc)		; 0A
	ld.s	a,(bc)		; 52 0A
	ld	a,(de)		; 1A
	ld.s	a,(de)		; 52 1A
	ld	a,(hl)		; 7E
	ld.s	a,(hl)		; 52 7E
	ld	hl,i		; ED D7
	ld	(hl),ix		; ED 3F
	ld.s	(hl),ix		; 52 ED 3F
	ld	(hl),iy		; ED 3E
	ld.s	(hl),iy		; 52 ED 3E
	ld	(hl),var1	; 36r10
	ld.s	(hl),var2	; 52 36 20
	ld	(hl),a		; 77
	ld	(hl),b		; 70
	ld	(hl),c		; 71
	ld	(hl),d		; 72
	ld	(hl),e		; 73
	ld	(hl),h		; 74
	ld	(hl),l		; 75
	ld.s	(hl),a		; 52 77
	ld.s	(hl),b		; 52 70
	ld.s	(hl),c		; 52 71
	ld.s	(hl),d		; 52 72
	ld.s	(hl),e		; 52 73
	ld.s	(hl),h		; 52 74
	ld.s	(hl),l		; 52 75
	ld	(hl),bc		; ED 0F
	ld.s	(hl),bc		; 52 ED 0F
	ld	(hl),de		; ED 1F
	ld.s	(hl),de		; 52 ED 1F
	ld	(hl),hl		; ED 2F
	ld.s	(hl),hl		; 52 ED 2F
	ld	i,hl		; ED C7
	ld	i,a		; ED 47
	ld	ixh,ixh		; DD 64
	ld	ixh,ixl		; DD 65
	ld	ixl,ixh		; DD 6C
	ld	ixl,ixl		; DD 6D
	ld	iyh,iyh		; FD 64
	ld	iyh,iyl		; FD 65
	ld	iyl,iyh		; FD 6C
	ld	iyl,iyl		; FD 6D
	ld	ixh,var2	; DD 26 20
	ld	ixl,19		; DD 2E 19
	ld	iyh,var1	; FD 26r10
	ld	iyl,var2	; FD 2E 20
	ld	ixh,a		; DD 67
	ld	ixh,b		; DD 60
	ld	ixh,c		; DD 61
	ld	ixh,d		; DD 62
	ld	ixh,e		; DD 63
	ld	ixl,a		; DD 6F
	ld	ixl,b		; DD 68
	ld	ixl,c		; DD 69
	ld	ixl,d		; DD 6A
	ld	ixl,e		; DD 6B
	ld	iyh,a		; FD 67
	ld	iyh,b		; FD 60
	ld	iyh,c		; FD 61
	ld	iyh,d		; FD 62
	ld	iyh,e		; FD 63
	ld	iyl,a		; FD 6F
	ld	iyl,b		; FD 68
	ld	iyl,c		; FD 69
	ld	iyl,d		; FD 6A
	ld	iyl,e		; FD 6B
	ld	ix,(hl)		; ED 37
	ld.s	ix,(hl)		; 52 ED 37
	ld	iy,(hl)		; ED 31
	ld.s	iy,(hl)		; 52 ED 31
	ld	ix,(ix+var2)	; DD 37 20
	ld.s	ix,(ix+19)	; 52 DD 37 19
	ld	iy,(ix+var2)	; DD 31 20
	ld.s	iy,(ix+19)	; 52 DD 31 19
	ld	ix,(iy+var2)	; FD 31 20
	ld.s	ix,(iy+19)	; 52 FD 31 19
	ld	iy,(iy+var2)	; FD 37 20
	ld.s	iy,(iy+19)	; 52 FD 37 19
	ld	ix,19		; DD 21 19 00 00
	ld	iy,var1		; FD 21r10s00R00
	ld	ix,(var2)	; DD 2A 20 00 00
	ld	iy,(19)		; FD 2A 19 00 00
	ld	(ix+19),ix	; DD 3F 19
	ld.s	(ix+var1),ix	; 52 DD 3Fr10
	ld	(ix+19),iy	; DD 3E 19
	ld.s	(ix+var1),iy	; 52 DD 3Er10
	ld	(iy+19),ix	; FD 3E 19
	ld.s	(iy+var1),ix	; 52 FD 3Er10
	ld	(iy+19),iy	; FD 3F 19
	ld.s	(iy+var1),iy	; 52 FD 3Fr10
	ld	(ix+19),#19	; DD 36 19 19
	ld.s	(ix+var1),var1	; 52 DD 36r10r10
	ld	(iy+19),#19	; FD 36 19 19
	ld.s	(iy+var1),var1	; 52 FD 36r10r10
	ld	(ix+19),a	; DD 77 19
	ld	(ix+var1),b	; DD 70r10
	ld	(ix+var2),c	; DD 71 20
	ld	(ix+19),d	; DD 72 19
	ld	(ix+var1),e	; DD 73r10
	ld	(ix+var2),h	; DD 74 20
	ld	(ix+19),l	; DD 75 19
	ld.s	(ix+var1),a	; 52 DD 77r10
	ld.s	(ix+var2),b	; 52 DD 70 20
	ld.s	(ix+19),c	; 52 DD 71 19
	ld.s	(ix+var1),d	; 52 DD 72r10
	ld.s	(ix+var2),e	; 52 DD 73 20
	ld.s	(ix+19),h	; 52 DD 74 19
	ld.s	(ix+var1),l	; 52 DD 75r10
	ld	(iy+19),a	; FD 77 19
	ld	(iy+var1),b	; FD 70r10
	ld	(iy+var2),c	; FD 71 20
	ld	(iy+19),d	; FD 72 19
	ld	(iy+var1),e	; FD 73r10
	ld	(iy+var2),h	; FD 74 20
	ld	(iy+19),l	; FD 75 19
	ld.s	(iy+var1),a	; 52 FD 77r10
	ld.s	(iy+var2),b	; 52 FD 70 20
	ld.s	(iy+19),c	; 52 FD 71 19
	ld.s	(iy+var1),d	; 52 FD 72r10
	ld.s	(iy+var2),e	; 52 FD 73 20
	ld.s	(iy+19),h	; 52 FD 74 19
	ld.s	(iy+var1),l	; 52 FD 75r10
	ld	(ix+19),bc	; DD 0F 19
	ld.s	(ix+var1),bc	; 52 DD 0Fr10
	ld	(ix+19),de	; DD 1F 19
	ld.s	(ix+var1),de	; 52 DD 1Fr10
	ld	(ix+19),hl	; DD 2F 19
	ld.s	(ix+var1),hl	; 52 DD 2Fr10
	ld	(iy+19),bc	; FD 0F 19
	ld.s	(iy+var1),bc	; 52 FD 0Fr10
	ld	(iy+19),de	; FD 1F 19
	ld.s	(iy+var1),de	; 52 FD 1Fr10
	ld	(iy+19),hl	; FD 2F 19
	ld.s	(iy+var1),hl	; 52 FD 2Fr10
	ld	mb,a		; ED 6D
	ld	(var2),a	; 32 20 00 00
	ld	(19),ix		; DD 22 19 00 00
	ld	(var1),iy	; FD 22r10s00R00
	ld	(var2),bc	; ED 43 20 00 00
	ld	(19),de		; ED 53 19 00 00
	ld	(var1),hl	; 22r10s00R00
	ld	(var2),sp	; ED 73 20 00 00
	ld	r,a		; ED 4F
	ld	b,(hl)		; 46
	ld	c,(hl)		; 4E
	ld	d,(hl)		; 56
	ld	e,(hl)		; 5E
	ld	h,(hl)		; 66
	ld	l,(hl)		; 6E
	ld.s	b,(hl)		; 52 46
	ld.s	c,(hl)		; 52 4E
	ld.s	d,(hl)		; 52 56
	ld.s	e,(hl)		; 52 5E
	ld.s	h,(hl)		; 52 66
	ld.s	l,(hl)		; 52 6E
	ld	a,ixh		; DD 7C
	ld	a,ixl		; DD 7D
	ld	a,iyh		; FD 7C
	ld	a,iyl		; FD 7D
	ld	b,ixh		; DD 44
	ld	b,ixl		; DD 45
	ld	b,iyh		; FD 44
	ld	b,iyl		; FD 45
	ld	c,ixh		; DD 4C
	ld	c,ixl		; DD 4D
	ld	c,iyh		; FD 4C
	ld	c,iyl		; FD 4D
	ld	d,ixh		; DD 54
	ld	d,ixl		; DD 55
	ld	d,iyh		; FD 54
	ld	d,iyl		; FD 55
	ld	e,ixh		; DD 5C
	ld	e,ixl		; DD 5D
	ld	e,iyh		; FD 5C
	ld	e,iyl		; FD 5D
	ld	b,(ix+var2)	; DD 46 20
	ld	c,(ix+19)	; DD 4E 19
	ld	d,(ix+var1)	; DD 56r10
	ld	e,(ix+var2)	; DD 5E 20
	ld	h,(ix+19)	; DD 66 19
	ld	l,(ix+var1)	; DD 6Er10
	ld.s	b,(ix+var2)	; 52 DD 46 20
	ld.s	c,(ix+19)	; 52 DD 4E 19
	ld.s	d,(ix+var1)	; 52 DD 56r10
	ld.s	e,(ix+var2)	; 52 DD 5E 20
	ld.s	h,(ix+19)	; 52 DD 66 19
	ld.s	l,(ix+var1)	; 52 DD 6Er10
	ld	b,(iy+var2)	; FD 46 20
	ld	c,(iy+19)	; FD 4E 19
	ld	d,(iy+var1)	; FD 56r10
	ld	e,(iy+var2)	; FD 5E 20
	ld	h,(iy+19)	; FD 66 19
	ld	l,(iy+var1)	; FD 6Er10
	ld.s	b,(iy+var2)	; 52 FD 46 20
	ld.s	c,(iy+19)	; 52 FD 4E 19
	ld.s	d,(iy+var1)	; 52 FD 56r10
	ld.s	e,(iy+var2)	; 52 FD 5E 20
	ld.s	h,(iy+19)	; 52 FD 66 19

	;intentional error here

	ld.s	l,(iy+var1)	; 52 FD 6Er10
	ld	a,var2		; 3E 20
	ld	b,19		; 06 19
	ld	c,var1		; 0Er10
	ld	d,var2		; 16 20
	ld	e,19		; 1E 19
	ld	h,var1		; 26r10
	ld	l,var2		; 2E 20
	ld	a,a		; 7F
	ld	a,b		; 78
	ld	a,c		; 79
	ld	a,d		; 7A
	ld	a,e		; 7B
	ld	a,h		; 7C
	ld	a,l		; 7D
	ld	b,a		; 47
;a	ld	b,b		; 40
	ld	b,c		; 41
	ld	b,d		; 42
	ld	b,e		; 43
	ld	b,h		; 44
	ld	b,l		; 45
	ld	c,a		; 4F
	ld	c,b		; 48
;a	ld	c,c		; 49
	ld	c,d		; 4A
	ld	c,e		; 4B
	ld	c,h		; 4C
	ld	c,l		; 4D
	ld	d,a		; 57
	ld	d,b		; 50
	ld	d,c		; 51
;a	ld	d,d		; 52
	ld	d,e		; 53
	ld	d,h		; 54
	ld	d,l		; 55
	ld	e,a		; 5F
	ld	e,b		; 58
	ld	e,c		; 59
	ld	e,d		; 5A
;a	ld	e,e		; 5B
	ld	e,h		; 5C
	ld	e,l		; 5D
	ld	h,a		; 67
	ld	h,b		; 60
	ld	h,c		; 61
	ld	h,d		; 62
	ld	h,e		; 63
	ld	h,h		; 64
	ld	h,l		; 65
	ld	l,a		; 6F
	ld	l,b		; 68
	ld	l,c		; 69
	ld	l,d		; 6A
	ld	l,e		; 6B
	ld	l,h		; 6C
	ld	l,l		; 6D
	ld	bc,(hl)		; ED 07
	ld.s	bc,(hl)		; 52 ED 07
	ld	de,(hl)		; ED 17
	ld.s	de,(hl)		; 52 ED 17
	ld	hl,(hl)		; ED 27
	ld.s	hl,(hl)		; 52 ED 27
	ld	bc,(ix+var1)	; DD 07r10
	ld.s	bc,(ix+var2)	; 52 DD 07 20
	ld	de,(ix+var1)	; DD 17r10
	ld.s	de,(ix+var2)	; 52 DD 17 20
	ld	hl,(ix+var1)	; DD 27r10
	ld.s	hl,(ix+var2)	; 52 DD 27 20
	ld	bc,(iy+var1)	; FD 07r10
	ld.s	bc,(iy+var2)	; 52 FD 07 20
	ld	de,(iy+var1)	; FD 17r10
	ld.s	de,(iy+var2)	; 52 FD 17 20
	ld	hl,(iy+var1)	; FD 27r10
	ld.s	hl,(iy+var2)	; 52 FD 27 20
	ld	bc,var1		; 01r10s00R00
	ld	de,var2		; 11 20 00 00
	ld	hl,19		; 21 19 00 00
	ld	bc,(19)		; ED 4B 19 00 00
	ld	de,(var1)	; ED 5Br10s00R00
	ld	hl,(var1)	; 2Ar10s00R00
	ld	(bc),a		; 02
	ld.s	(bc),a		; 52 02
	ld	(de),a		; 12
	ld.s	(de),a		; 52 12
	ld	sp,hl		; F9
	ld.s	sp,hl		; 52 F9
	ld	sp,ix		; DD F9
	ld.s	sp,ix		; 52 DD F9
	ld	sp,iy		; FD F9
	ld.s	sp,iy		; 52 FD F9
	ld	sp,var2		; 31 20 00 00
	ld	sp,(19)		; ED 7B 19 00 00
	ldd			; ED A8
	ldd.s			; 52 ED A8
	lddr			; ED B8
	lddr.s			; 52 ED B8
	ldi			; ED A0
	ldi.s			; 52 ED A0
	ldir			; ED B0
	ldir.s			; 52 ED B0
	lea	ix,ix+19	; ED 32 19
	lea.s	ix,ix+var1	; 52 ED 32r10
	lea	iy,ix+19	; ED 55 19
	lea.s	iy,ix+var1	; 52 ED 55r10
	lea	ix,iy+19	; ED 54 19
	lea.s	ix,iy+var1	; 52 ED 54r10
	lea	iy,iy+19	; ED 33 19
	lea.s	iy,iy+var1	; 52 ED 33r10
	lea	bc,ix+19	; ED 02 19
	lea	de,ix+var1	; ED 12r10
	lea	hl,ix+var2	; ED 22 20
	lea.s	bc,ix+19	; 52 ED 02 19
	lea.s	de,ix+var1	; 52 ED 12r10
	lea.s	hl,ix+var2	; 52 ED 22 20
	lea	bc,iy+19	; ED 03 19
	lea	de,iy+var1	; ED 13r10
	lea	hl,iy+var2	; ED 23 20
	lea.s	bc,iy+19	; 52 ED 03 19
	lea.s	de,iy+var1	; 52 ED 13r10
	lea.s	hl,iy+var2	; 52 ED 23 20

	mlt	bc		; ED 4C
	mlt	de		; ED 5C
	mlt	hl		; ED 6C
	mlt	sp		; ED 7C
	mlt.s	sp		; 52 ED 7C

	neg			; ED 44

	nop			; 00

	or	a,(hl)		; B6
	or.s	a,(hl)		; 52 B6
	or	a,ixh		; DD B4
	or	a,ixl		; DD B5
	or	a,iyh		; FD B4
	or	a,iyl		; FD B5
	or	a,(ix+19)	; DD B6 19
	or.s	a,(ix+var1)	; 52 DD B6r10
	or	a,(iy+19)	; FD B6 19
	or.s	a,(iy+var1)	; 52 FD B6r10
	or	a,19		; F6 19
	or	a,a		; B7
	or	a,b		; B0
	or	a,c		; B1
	or	a,d		; B2
	or	a,e		; B3
	or	a,h		; B4
	or	a,l		; B5

	otd2r			; ED BC
	otd2r.s			; 52 ED BC

	otdm			; ED 8B
	otdm.s			; 52 ED 8B

	otdmr			; ED 9B
	otdmr.s			; 52 ED 9B

	otdr			; ED BB
	otdr.s			; 52 ED BB

	otdrx			; ED CB
	otdrx.s			; 52 ED CB

	oti2r			; ED B4
	oti2r.s			; 52 ED B4

	otim			; ED 83
	otim.s			; 52 ED 83

	otimr			; ED 93
	otimr.s			; 52 ED 93

	otir			; ED B3
	otir.s			; 52 ED B3

	otirx			; ED C3
	otirx.s			; 52 ED C3

	;Z80 assembler variant section

	out	(c),a		; ED 79
	out	(c),b		; ED 41
	out	(c),c		; ED 49
	out	(c),d		; ED 51
	out	(c),e		; ED 59
	out	(c),h		; ED 61
	out	(c),l		; ED 69

	;End of Z80 assembler variant section

	out	(bc),a		; ED 79
	out	(bc),b		; ED 41
	out	(bc),c		; ED 49
	out	(bc),d		; ED 51
	out	(bc),e		; ED 59
	out	(bc),h		; ED 61
	out	(bc),l		; ED 69
	out	(var1),a	; D3u10

	out0	(var2),a	; ED 39 20
	out0	(19),b		; ED 01 19
	out0	(var1),c	; ED 09u10
	out0	(var2),d	; ED 11 20
	out0	(19),e		; ED 19 19
	out0	(var1),h	; ED 21u10
	out0	(var2),l	; ED 29 20

	outd			; ED AB
	outd.s			; 52 ED AB

	outd2			; ED AC
	outd2.s			; 52 ED AC

	outi			; ED A3
	outi.s			; 52 ED A3

	outi2			; ED A4
	outi2.s			; 52 ED A4

	pea	ix+19		; ED 65 19
	pea.s	ix+var1		; 52 ED 65r10

	pea	iy+19		; ED 66 19
	pea.s	iy+var1		; 52 ED 66r10

	pop	af		; F1
	pop.s	af		; 52 F1
	pop	ix		; DD E1
	pop.s	ix		; 52 DD E1
	pop	iy		; FD E1
	pop.s	iy		; 52 FD E1
	pop	bc		; C1
	pop	de		; D1
	pop	hl		; E1
	pop.s	bc		; 52 C1
	pop.s	de		; 52 D1
	pop.s	hl		; 52 E1

	push	af		; F5
	push.s	af		; 52 F5
	push	ix		; DD E5
	push.s	ix		; 52 DD E5
	push	iy		; FD E5
	push.s	iy		; 52 FD E5
	push	bc		; C5
	push	de		; D5
	push	hl		; E5
	push.s	bc		; 52 C5
	push.s	de		; 52 D5
	push.s	hl		; 52 E5

	res	0,(hl)		; CB 86
	res.s	0,(hl)		; 52 CB 86
	res	1,(hl)		; CB 8E
	res.s	1,(hl)		; 52 CB 8E
	res	2,(hl)		; CB 96
	res.s	2,(hl)		; 52 CB 96
	res	3,(hl)		; CB 9E
	res.s	3,(hl)		; 52 CB 9E
	res	4,(hl)		; CB A6
	res.s	4,(hl)		; 52 CB A6
	res	5,(hl)		; CB AE
	res.s	5,(hl)		; 52 CB AE
	res	6,(hl)		; CB B6
	res.s	6,(hl)		; 52 CB B6
	res	_bit7,(hl)	; CBuBE
	res.s	_bit7,(hl)	; 52 CBuBE
	res	0,(ix+19)	; DD CB 19 86
	res.s	0,(ix+var1)	; 52 DD CBr10 86
	res	0,(iy+19)	; FD CB 19 86
	res.s	0,(iy+var1)	; 52 FD CBr10 86
	res	1,(ix+19)	; DD CB 19 8E
	res.s	1,(ix+var1)	; 52 DD CBr10 8E
	res	1,(iy+19)	; FD CB 19 8E
	res.s	1,(iy+var1)	; 52 FD CBr10 8E
	res	2,(ix+19)	; DD CB 19 96
	res.s	2,(ix+var1)	; 52 DD CBr10 96
	res	2,(iy+19)	; FD CB 19 96
	res.s	2,(iy+var1)	; 52 FD CBr10 96
	res	3,(ix+19)	; DD CB 19 9E
	res.s	3,(ix+var1)	; 52 DD CBr10 9E
	res	3,(iy+19)	; FD CB 19 9E
	res.s	3,(iy+var1)	; 52 FD CBr10 9E
	res	4,(ix+19)	; DD CB 19 A6
	res.s	4,(ix+var1)	; 52 DD CBr10 A6
	res	4,(iy+19)	; FD CB 19 A6
	res.s	4,(iy+var1)	; 52 FD CBr10 A6
	res	5,(ix+19)	; DD CB 19 AE
	res.s	5,(ix+var1)	; 52 DD CBr10 AE
	res	5,(iy+19)	; FD CB 19 AE
	res.s	5,(iy+var1)	; 52 FD CBr10 AE
	res	6,(ix+19)	; DD CB 19 B6
	res.s	6,(ix+var1)	; 52 DD CBr10 B6
	res	6,(iy+19)	; FD CB 19 B6
	res.s	6,(iy+var1)	; 52 FD CBr10 B6
	res	_bit7,(ix+19)	; DD CB 19uBE
	res.s	_bit7,(ix+var1)	; 52 DD CBr10uBE
	res	_bit7,(iy+19)	; FD CB 19uBE
	res.s	_bit7,(iy+var1)	; 52 FD CBr10uBE
	res	0,a		; CB 87
	res	0,b		; CB 80
	res	0,c		; CB 81
	res	0,d		; CB 82
	res	0,e		; CB 83
	res	0,h		; CB 84
	res	0,l		; CB 85
	res	1,a		; CB 8F
	res	1,b		; CB 88
	res	1,c		; CB 89
	res	1,d		; CB 8A
	res	1,e		; CB 8B
	res	1,h		; CB 8C
	res	1,l		; CB 8D
	res	2,a		; CB 97
	res	2,b		; CB 90
	res	2,c		; CB 91
	res	2,d		; CB 92
	res	2,e		; CB 93
	res	2,h		; CB 94
	res	2,l		; CB 95
	res	3,a		; CB 9F
	res	3,b		; CB 98
	res	3,c		; CB 99
	res	3,d		; CB 9A
	res	3,e		; CB 9B
	res	3,h		; CB 9C
	res	3,l		; CB 9D
	res	4,a		; CB A7
	res	4,b		; CB A0
	res	4,c		; CB A1
	res	4,d		; CB A2
	res	4,e		; CB A3
	res	4,h		; CB A4
	res	4,l		; CB A5
	res	5,a		; CB AF
	res	5,b		; CB A8
	res	5,c		; CB A9
	res	5,d		; CB AA
	res	5,e		; CB AB
	res	5,h		; CB AC
	res	5,l		; CB AD
	res	6,a		; CB B7
	res	6,b		; CB B0
	res	6,c		; CB B1
	res	6,d		; CB B2
	res	6,e		; CB B3
	res	6,h		; CB B4
	res	6,l		; CB B5
	res	_bit7,a		; CBuBF
	res	_bit7,b		; CBuB8
	res	_bit7,c		; CBuB9
	res	_bit7,d		; CBuBA
	res	_bit7,e		; CBuBB
	res	_bit7,h		; CBuBC
	res	_bit7,l		; CBuBD

	ret			; C9
	ret.l			; 5B C9
	ret	nz		; C0
	ret	z		; C8
	ret	nc		; D0
	ret	c		; D8
	ret	po		; E0
	ret	pe		; E8
	ret	p		; F0
	ret	m		; F8
	ret.l	nz		; 5B C0
	ret.l	z		; 5B C8
	ret.l	nc		; 5B D0
	ret.l	c		; 5B D8
	ret.l	po		; 5B E0
	ret.l	pe		; 5B E8
	ret.l	p		; 5B F0
	ret.l	m		; 5B F8

	reti			; ED 4D
	reti.l			; 5B ED 4D

	retn			; ED 45
	retn.l			; 5B ED 45

	rl	(hl)		; CB 16
	rl.s	(hl)		; 52 CB 16
	rl	(ix+var2)	; DD CB 20 16
	rl.s	(ix+19)		; 52 DD CB 19 16
	rl	(iy+var2)	; FD CB 20 16
	rl.s	(iy+19)		; 52 FD CB 19 16
	rl	a		; CB 17
	rl	b		; CB 10
	rl	c		; CB 11
	rl	d		; CB 12
	rl	e		; CB 13
	rl	h		; CB 14
	rl	l		; CB 15

	rla			; 17

	rlc	(hl)		; CB 06
	rlc.s	(hl)		; 52 CB 06
	rlc	(ix+var2)	; DD CB 20 06
	rlc.s	(ix+19)		; 52 DD CB 19 06
	rlc	(iy+var2)	; FD CB 20 06
	rlc.s	(iy+19)		; 52 FD CB 19 06
	rlc	a		; CB 07
	rlc	b		; CB 00
	rlc	c		; CB 01
	rlc	d		; CB 02
	rlc	e		; CB 03
	rlc	h		; CB 04
	rlc	l		; CB 05

	rlca			; 07

	rld			; ED 6F

	rr	(hl)		; CB 1E
	rr.s	(hl)		; 52 CB 1E
	rr	(ix+19)		; DD CB 19 1E
	rr.s	(ix+var1)	; 52 DD CBr10 1E
	rr	(iy+19)		; FD CB 19 1E
	rr.s	(iy+var1)	; 52 FD CBr10 1E
	rr	a		; CB 1F
	rr	b		; CB 18
	rr	c		; CB 19
	rr	d		; CB 1A
	rr	e		; CB 1B
	rr	h		; CB 1C
	rr	l		; CB 1D

	rra			; 1F

	rrc	(hl)		; CB 0E
	rrc.s	(hl)		; 52 CB 0E
	rrc	(ix+19)		; DD CB 19 0E
	rrc.s	(ix+var1)	; 52 DD CBr10 0E
	rrc	(iy+19)		; FD CB 19 0E
	rrc.s	(iy+var1)	; 52 FD CBr10 0E
	rrc	a		; CB 0F
	rrc	b		; CB 08
	rrc	c		; CB 09
	rrc	d		; CB 0A
	rrc	e		; CB 0B
	rrc	h		; CB 0C
	rrc	l		; CB 0D

	rrca			; 0F

	rrd			; ED 67

	rsmix			; ED 7E

	rst	00		; C7
	rst	08		; CF
	rst	10		; D7
	rst	18		; DF
	rst	20		; E7
	rst	28		; EF
	rst	30		; F7
	rst	38		; FF
	rst.s	00		; 52 C7
	rst.s	08		; 52 CF
	rst.s	10		; 52 D7
	rst.s	18		; 52 DF
	rst.s	20		; 52 E7
	rst.s	28		; 52 EF
	rst.s	30		; 52 F7
	rst.s	38		; 52 FF

	sbc	a,(hl)		; 9E
	sbc.s	a,(hl)		; 52 9E
	sbc	a,ixh		; DD 9C
	sbc	a,ixl		; DD 9D
	sbc	a,iyh		; FD 9C
	sbc	a,iyl		; FD 9D
	sbc	a,(ix+19)	; DD 9E 19
	sbc.s	a,(ix+var1)	; 52 DD 9Er10
	sbc	a,(iy+19)	; FD 9E 19
	sbc.s	a,(iy+var1)	; 52 FD 9Er10
	sbc	a,19		; DE 19
	sbc	a,a		; 9F
	sbc	a,b		; 98
	sbc	a,c		; 99
	sbc	a,d		; 9A
	sbc	a,e		; 9B
	sbc	a,h		; 9C
	sbc	a,l		; 9D
	sbc	hl,bc		; ED 42
	sbc	hl,de		; ED 52
	sbc	hl,hl		; ED 62
	sbc.s	hl,bc		; 52 ED 42
	sbc.s	hl,de		; 52 ED 52
	sbc.s	hl,hl		; 52 ED 62
	sbc	hl,sp		; ED 72
	sbc.s	hl,sp		; 52 ED 72

	scf			; 37

	set	0,(hl)		; CB C6
	set.s	0,(hl)		; 52 CB C6
	set	0,(ix+19)	; DD CB 19 C6
	set.s	0,(ix+var1)	; 52 DD CBr10 C6
	set	0,(iy+19)	; FD CB 19 C6
	set.s	0,(iy+var1)	; 52 FD CBr10 C6
	set	1,(hl)		; CB CE
	set.s	1,(hl)		; 52 CB CE
	set	1,(ix+19)	; DD CB 19 CE
	set.s	1,(ix+var1)	; 52 DD CBr10 CE
	set	1,(iy+19)	; FD CB 19 CE
	set.s	1,(iy+var1)	; 52 FD CBr10 CE
	set	2,(hl)		; CB D6
	set.s	2,(hl)		; 52 CB D6
	set	2,(ix+19)	; DD CB 19 D6
	set.s	2,(ix+var1)	; 52 DD CBr10 D6
	set	2,(iy+19)	; FD CB 19 D6
	set.s	2,(iy+var1)	; 52 FD CBr10 D6
	set	3,(hl)		; CB DE
	set.s	3,(hl)		; 52 CB DE
	set	3,(ix+19)	; DD CB 19 DE
	set.s	3,(ix+var1)	; 52 DD CBr10 DE
	set	3,(iy+19)	; FD CB 19 DE
	set.s	3,(iy+var1)	; 52 FD CBr10 DE
	set	4,(hl)		; CB E6
	set.s	4,(hl)		; 52 CB E6
	set	4,(ix+19)	; DD CB 19 E6
	set.s	4,(ix+var1)	; 52 DD CBr10 E6
	set	4,(iy+19)	; FD CB 19 E6
	set.s	4,(iy+var1)	; 52 FD CBr10 E6
	set	5,(hl)		; CB EE
	set.s	5,(hl)		; 52 CB EE
	set	5,(ix+19)	; DD CB 19 EE
	set.s	5,(ix+var1)	; 52 DD CBr10 EE
	set	5,(iy+19)	; FD CB 19 EE
	set.s	5,(iy+var1)	; 52 FD CBr10 EE
	set	6,(hl)		; CB F6
	set.s	6,(hl)		; 52 CB F6
	set	6,(ix+19)	; DD CB 19 F6
	set.s	6,(ix+var1)	; 52 DD CBr10 F6
	set	6,(iy+19)	; FD CB 19 F6
	set.s	6,(iy+var1)	; 52 FD CBr10 F6
	set	_bit7,(hl)	; CBuFE
	set.s	_bit7,(hl)	; 52 CBuFE
	set	_bit7,(ix+19)	; DD CB 19uFE
	set.s	_bit7,(ix+var1)	; 52 DD CBr10uFE
	set	_bit7,(iy+19)	; FD CB 19uFE
	set.s	_bit7,(iy+var1)	; 52 FD CBr10uFE
	set	0,a		; CB C7
	set	0,b		; CB C0
	set	0,c		; CB C1
	set	0,d		; CB C2
	set	0,e		; CB C3
	set	0,h		; CB C4
	set	0,l		; CB C5
	set	1,a		; CB CF
	set	1,b		; CB C8
	set	1,c		; CB C9
	set	1,d		; CB CA
	set	1,e		; CB CB
	set	1,h		; CB CC
	set	1,l		; CB CD
	set	2,a		; CB D7
	set	2,b		; CB D0
	set	2,c		; CB D1
	set	2,d		; CB D2
	set	2,e		; CB D3
	set	2,h		; CB D4
	set	2,l		; CB D5
	set	3,a		; CB DF
	set	3,b		; CB D8
	set	3,c		; CB D9
	set	3,d		; CB DA
	set	3,e		; CB DB
	set	3,h		; CB DC
	set	3,l		; CB DD
	set	4,a		; CB E7
	set	4,b		; CB E0
	set	4,c		; CB E1
	set	4,d		; CB E2
	set	4,e		; CB E3
	set	4,h		; CB E4
	set	4,l		; CB E5
	set	5,a		; CB EF
	set	5,b		; CB E8
	set	5,c		; CB E9
	set	5,d		; CB EA
	set	5,e		; CB EB
	set	5,h		; CB EC
	set	5,l		; CB ED
	set	6,a		; CB F7
	set	6,b		; CB F0
	set	6,c		; CB F1
	set	6,d		; CB F2
	set	6,e		; CB F3
	set	6,h		; CB F4
	set	6,l		; CB F5
	set	_bit7,a		; CBuFF
	set	_bit7,b		; CBuF8
	set	_bit7,c		; CBuF9
	set	_bit7,d		; CBuFA
	set	_bit7,e		; CBuFB
	set	_bit7,h		; CBuFC
	set	_bit7,l		; CBuFD

	sla	(hl)		; CB 26
	sla.s	(hl)		; 52 CB 26
	sla	(ix+var2)	; DD CB 20 26
	sla.s	(ix+19)		; 52 DD CB 19 26
	sla	(iy+var2)	; FD CB 20 26
	sla.s	(iy+19)		; 52 FD CB 19 26
	sla	a		; CB 27
	sla	b		; CB 20
	sla	c		; CB 21
	sla	d		; CB 22
	sla	e		; CB 23
	sla	h		; CB 24
	sla	l		; CB 25

	slp			; ED 76

	sra	(hl)		; CB 2E
	sra.s	(hl)		; 52 CB 2E
	sra	(ix+var2)	; DD CB 20 2E
	sra.s	(ix+19)		; 52 DD CB 19 2E
	sra	(iy+var2)	; FD CB 20 2E
	sra.s	(iy+19)		; 52 FD CB 19 2E
	sra	a		; CB 2F
	sra	b		; CB 28
	sra	c		; CB 29
	sra	d		; CB 2A
	sra	e		; CB 2B
	sra	h		; CB 2C
	sra	l		; CB 2D

	srl	(hl)		; CB 3E
	srl.s	(hl)		; 52 CB 3E
	srl	(ix+var1)	; DD CBr10 3E
	srl.s	(ix+var2)	; 52 DD CB 20 3E
	srl	(iy+var1)	; FD CBr10 3E
	srl.s	(iy+var2)	; 52 FD CB 20 3E
	srl	a		; CB 3F
	srl	b		; CB 38
	srl	c		; CB 39
	srl	d		; CB 3A
	srl	e		; CB 3B
	srl	h		; CB 3C
	srl	l		; CB 3D

	stmix			; ED 7D

	sub	a,(hl)		; 96
	sub.s	a,(hl)		; 52 96
	sub	a,ixh		; DD 94
	sub	a,ixl		; DD 95
	sub	a,iyh		; FD 94
	sub	a,iyl		; FD 95
	sub	a,(ix+var2)	; DD 96 20
	sub.s	a,(ix+19)	; 52 DD 96 19
	sub	a,(iy+var2)	; FD 96 20
	sub.s	a,(iy+19)	; 52 FD 96 19
	sub	a,var2		; D6 20
	sub	a,a		; 97
	sub	a,b		; 90
	sub	a,c		; 91
	sub	a,d		; 92
	sub	a,e		; 93
	sub	a,h		; 94
	sub	a,l		; 95
	tst	a,(hl)		; ED 34

	tst.s	a,(hl)		; 52 ED 34

	; The following line has errata in
	; manual codes (49,ed,73), the ones
	; listed here are correct

	tst	a,19		; ED 64 19
	tst	a,a		; ED 3C
	tst	a,b		; ED 04
	tst	a,c		; ED 0C
	tst	a,d		; ED 14
	tst	a,e		; ED 1C
	tst	a,h		; ED 24
	tst	a,l		; ED 2C

	tstio	var2		; ED 74 20

	xor	a,(hl)		; AE
	xor.s	a,(hl)		; 52 AE
	xor	a,ixh		; DD AC
	xor	a,ixl		; DD AD
	xor	a,iyh		; FD AC
	xor	a,iyl		; FD AD
	xor	a,(ix+var1)	; DD AEr10
	xor.s	a,(ix+var2)	; 52 DD AE 20
	xor	a,(iy+var1)	; FD AEr10
	xor.s	a,(iy+var2)	; 52 FD AE 20
	xor	a,var1		; EEr10
	xor	a,a		; AF
	xor	a,b		; A8
	xor	a,c		; A9
	xor	a,d		; AA
	xor	a,e		; AB
	xor	a,h		; AC
	xor	a,l		; AD

	.sbttl	Z80 Mode

	.z80
	.radix	h

	.ascii	/Hello,	world/

	;var1=10
	.define	var1, "varx + 10"

	var2==20
  
	adc	a,(hl)		; 8E
	adc.l	a,(hl)		; 49 8E
	adc	a,ixh		; DD 8C
	adc	a,ixl		; DD 8D
	adc	a,iyh		; FD 8C
	adc	a,iyl		; FD 8D
	adc	a,(ix+var2)	; DD 8E 20
	adc.l	a,(ix+var1)	; 49 DD 8Er10
	adc	a,(iy+var2)	; FD 8E 20
	adc.l	a,(iy+var1)	; 49 FD 8Er10
	adc	a,var2		; CE 20
	adc	a,a		; 8F
	adc	a,b		; 88
	adc	a,c		; 89
	adc	a,d		; 8A
	adc	a,e		; 8B
	adc	a,h		; 8C
	adc	a,l		; 8D

	;These are added for backward compatibility with
	;the original Z80 assembler which optionally
	;does not require the 'A' register to be named.

	adc	(hl)		; 8E
	adc.l	(hl)		; 49 8E
	adc	ixh		; DD 8C
	adc	ixl		; DD 8D
	adc	iyh		; FD 8C
	adc	iyl		; FD 8D
	adc	(ix+var2)	; DD 8E 20
	adc.l	(ix+var1)	; 49 DD 8Er10
	adc	(iy+var2)	; FD 8E 20
	adc.l	(iy+var1)	; 49 FD 8Er10
	adc	var2		; CE 20
	adc	a		; 8F
	adc	b		; 88
	adc	c		; 89
	adc	d		; 8A
	adc	e		; 8B
	adc	h		; 8C
	adc	l		; 8D

	;End of Z80 compatibility section

	adc	hl,bc		; ED 4A
	adc	hl,de		; ED 5A
	adc	hl,hl		; ED 6A
	adc.l	hl,bc		; 49 ED 4A
	adc.l	hl,de		; 49 ED 5A
	adc.l	hl,hl		; 49 ED 6A
	adc	hl,sp		; ED 7A
	adc.l	hl,sp		; 49 ED 7A

	add	a,(hl)		; 86
	add.l	a,(hl)		; 49 86
	add	a,ixh		; DD 84
	add	a,ixl		; DD 85
	add	a,iyh		; FD 84
	add	a,iyl		; FD 85
	add	a,(ix+var2)	; DD 86 20
	add.l	a,(ix+var1)	; 49 DD 86r10
	add	a,(iy+var2)	; FD 86 20
	add.l	a,(iy+var1)	; 49 FD 86r10
	add	a,var2		; C6 20
	add	a,a		; 87
	add	a,b		; 80
	add	a,c		; 81
	add	a,d		; 82
	add	a,e		; 83
	add	a,h		; 84
	add	a,l		; 85
	add	hl,bc		; 09
	add	hl,de		; 19
	add	hl,hl		; 29
	add.l	hl,bc		; 49 09
	add.l	hl,de		; 49 19
	add.l	hl,hl		; 49 29
	add	hl,sp		; 39
	add.l	hl,sp		; 49 39
	add	ix,bc		; DD 09
	add	ix,de		; DD 19
	add	ix,ix		; DD 29
	add.l	ix,bc		; 49 DD 09
	add.l	ix,de		; 49 DD 19
	add.l	ix,ix		; 49 DD 29
	add	iy,bc		; FD 09
	add	iy,de		; FD 19
	add	iy,iy		; FD 29
	add.l	iy,bc		; 49 FD 09
	add.l	iy,de		; 49 FD 19
	add.l	iy,iy		; 49 FD 29
	add	ix,sp		; DD 39
	add.l	ix,sp		; 49 DD 39
	add	iy,sp		; FD 39
	add.l	iy,sp		; 49 FD 39

	and	a,(hl)		; A6
	and.l	a,(hl)		; 49 A6
	and	a,ixh		; DD A4
	and	a,ixl		; DD A5
	and	a,iyh		; FD A4
	and	a,iyl		; FD A5
	and	a,(ix+var2)	; DD A6 20
	and.l	a,(ix+var1)	; 49 DD A6r10
	and	a,(iy+var2)	; FD A6 20
	and.l	a,(iy+var1)	; 49 FD A6r10
	and	a,var2		; E6 20
	and	a,a		; A7
	and	a,b		; A0
	and	a,c		; A1
	and	a,d		; A2
	and	a,e		; A3
	and	a,h		; A4
	and	a,l		; A5

	bit	0,(hl)		; CB 46
	bit	1,(hl)		; CB 4E
	bit	2,(hl)		; CB 56
	bit	3,(hl)		; CB 5E
	bit	4,(hl)		; CB 66
	bit	5,(hl)		; CB 6E
	bit	6,(hl)		; CB 76
	bit	_bit7,(hl)	; CBu7E
	bit.l	0,(hl)		; 49 CB 46
	bit.l	1,(hl)		; 49 CB 4E
	bit.l	2,(hl)		; 49 CB 56
	bit.l	3,(hl)		; 49 CB 5E
	bit.l	4,(hl)		; 49 CB 66
	bit.l	5,(hl)		; 49 CB 6E
	bit.l	6,(hl)		; 49 CB 76
	bit.l	_bit7,(hl)	; 49 CBu7E
	bit	0,(ix+var1)	; DD CBr10 46
	bit	1,(ix+var2)	; DD CB 20 4E
	bit	2,(ix+19)	; DD CB 19 56
	bit	3,(ix+var1)	; DD CBr10 5E
	bit	4,(ix+var2)	; DD CB 20 66
	bit	5,(ix+19)	; DD CB 19 6E
	bit	6,(ix+var1)	; DD CBr10 76
	bit	_bit7,(ix+var2)	; DD CB 20u7E
	bit.l	0,(ix+var2)	; 49 DD CB 20 46
	bit.l	1,(ix+19)	; 49 DD CB 19 4E
	bit.l	2,(ix+var1)	; 49 DD CBr10 56
	bit.l	3,(ix+var2)	; 49 DD CB 20 5E
	bit.l	4,(ix+19)	; 49 DD CB 19 66
	bit.l	5,(ix+var1)	; 49 DD CBr10 6E
	bit.l	6,(ix+var2)	; 49 DD CB 20 76
	bit.l	_bit7,(ix+19)	; 49 DD CB 19u7E
	bit	0,(iy+var1)	; FD CBr10 46
	bit	1,(iy+var2)	; FD CB 20 4E
	bit	2,(iy+19)	; FD CB 19 56
	bit	3,(iy+var1)	; FD CBr10 5E
	bit	4,(iy+var2)	; FD CB 20 66
	bit	5,(iy+19)	; FD CB 19 6E
	bit	6,(iy+var1)	; FD CBr10 76
	bit	_bit7,(iy+var2)	; FD CB 20u7E
	bit.l	0,(iy+var2)	; 49 FD CB 20 46
	bit.l	1,(iy+19)	; 49 FD CB 19 4E
	bit.l	2,(iy+var1)	; 49 FD CBr10 56
	bit.l	3,(iy+var2)	; 49 FD CB 20 5E
	bit.l	4,(iy+19)	; 49 FD CB 19 66
	bit.l	5,(iy+var1)	; 49 FD CBr10 6E
	bit.l	6,(iy+var2)	; 49 FD CB 20 76
	bit.l	_bit7,(iy+19)	; 49 FD CB 19u7E
	bit	0,a		; CB 47
	bit	0,b		; CB 40
	bit	0,c		; CB 41
	bit	0,d		; CB 42
	bit	0,e		; CB 43
	bit	0,h		; CB 44
	bit	0,l		; CB 45
	bit	1,a		; CB 4F
	bit	1,b		; CB 48
	bit	1,c		; CB 49
	bit	1,d		; CB 4A
	bit	1,e		; CB 4B
	bit	1,h		; CB 4C
	bit	1,l		; CB 4D
	bit	2,a		; CB 57
	bit	2,b		; CB 50
	bit	2,c		; cb 51
	bit	2,d		; CB 52
	bit	2,e		; cb 53
	bit	2,h		; CB 54
	bit	2,l		; CB 55
	bit	3,a		; CB 5F
	bit	3,b		; CB 58
	bit	3,c		; CB 59
	bit	3,d		; CB 5A
	bit	3,e		; CB 5B
	bit	3,h		; CB 5C
	bit	3,l		; CB 5D
	bit	4,a		; CB 67
	bit	4,b		; CB 60
	bit	4,c		; CB 61
	bit	4,d		; CB 62
	bit	4,e		; CB 63
	bit	4,h		; CB 64
	bit	4,l		; CB 65
	bit	5,a		; CB 6F
	bit	5,b		; CB 68
	bit	5,c		; CB 69
	bit	5,d		; CB 6A
	bit	5,e		; CB 6B
	bit	5,h		; CB 6C
	bit	5,l		; CB 6D
	bit	6,a		; CB 77
	bit	6,b		; CB 70
	bit	6,c		; CB 71
	bit	6,d		; CB 72
	bit	6,e		; CB 73
	bit	6,h		; CB 74
	bit	6,l		; CB 75
	bit	_bit7,a		; CBu7F
	bit	_bit7,b		; CBu78
	bit	_bit7,c		; CBu79
	bit	_bit7,d		; CBu7A
	bit	_bit7,e		; CBu7B
	bit	_bit7,h		; CBu7C
	bit	_bit7,l		; CBu7D

	call	nz,19		; C4 19 00
	call.is	nz,var2		; 40 C4 20 00
	call	z,19		; CC 19 00
	call.is	z,var2		; 40 CC 20 00
	call	nc,19		; D4 19 00
	call.is	nc,var2		; 40 D4 20 00
	call	c,19		; DC 19 00
	call.is	c,var2		; 40 DC 20 00
	call	po,19		; E4 19 00
	call.is	po,var2		; 40 E4 20 00
	call	pe,19		; EC 19 00
	call.is	pe,var2		; 40 EC 20 00
	call	p,19		; F4 19 00
	call.is	p,var2		; 40 F4 20 00
	call	m,19		; FC 19 00
	call.is	m,var2		; 40 FC 20 00
	call	19		; CD 19 00
	call.is	var2		; 40 CD 20 00

	ccf			; 3F

	cp	a,(hl)		; BE
	cp.l	a,(hl)		; 49 BE
	cp	a,ixh		; DD BC
	cp	a,ixl		; DD BD
	cp	a,iyh		; FD BC
	cp	a,iyl		; FD BD
	cp	a,(ix+var2)	; DD BE 20
	cp.l	a,(ix+var1)	; 49 DD BEr10
	cp	a,(iy+var2)	; FD BE 20
	cp.l	a,(iy+var1)	; 49 FD BEr10
	cp	a,var2		; FE 20
	cp	a,a		; BF
	cp	a,b		; B8
	cp	a,c		; B9
	cp	a,d		; BA
	cp	a,e		; BB
	cp	a,h		; BC
	cp	a,l		; BD

	cpd			; ED A9
	cpd.l			; 49 ED A9

	cpdr			; ED B9
	cpdr.l			; 49 ED B9

	cpi			; ED A1
	cpi.l			; 49 ED A1

	cpir			; ED B1
	cpir.l			; 49 ED B1

	cpl			; 2F

	daa			; 27

	dec	(hl)		; 35
	dec.l	(hl)		; 49 35
	dec	ixh		; DD 25
	dec	ixl		; DD 2D
	dec	iyh		; FD 25
	dec	iyl		; FD 2D
	dec	ix		; DD 2B
	dec.l	ix		; 49 DD 2B
	dec	iy		; FD 2B
	dec.l	iy		; 49 FD 2B
	dec	(ix+var1)	; DD 35r10
	dec.l	(ix+19)		; 49 DD 35 19
	dec	(iy+var1)	; FD 35r10
	dec.l	(iy+19)		; 49 FD 35 19
	dec	a		; 3D
	dec	b		; 05
	dec	c		; 0D
	dec	d		; 15
	dec	e		; 1D
	dec	h		; 25
	dec	l		; 2D
	dec	bc		; 0B
	dec	de		; 1B
	dec	hl		; 2b
	dec.l	bc		; 49 0B
	dec.l	de		; 49 1B
	dec.l	hl		; 49 2B
	dec	sp		; 3B
	dec.l	sp		; 49 3B

	di			; F3

	djnz	jr0z80		; 10 00
	jr0z80:

	ei			; FB

	ex	af,af'		; 08
	ex	de,hl		; EB
	ex	(sp),hl		; E3
	ex.l	(sp),hl		; 49 E3
	ex	(sp),ix		; DD E3
	ex.l	(sp),ix		; 49 DD E3
	ex	(sp),iy		; FD E3
	ex.l	(sp),iy		; 49 FD E3

	exx			; D9

	halt			; 76

	im	0		; ED 46
	im	1		; ED 56
	im	2		; ED 5E

	in	a,(19)		; DB 19
	in	a,(bc)		; ED 78
	in	b,(bc)		; ED 40
	in	c,(bc)		; ED 48
	in	d,(bc)		; ED 50
	in	e,(bc)		; ED 58
	in	h,(bc)		; ED 60
	in	l,(bc)		; ED 68
	in	a,(c)		; ED 78
	in	b,(c)		; ED 40
	in	c,(c)		; ED 48
	in	d,(c)		; ED 50
	in	e,(c)		; ED 58
	in	h,(c)		; ED 60
	in	l,(c)		; ED 68

	in0	a,(19)		; ED 38 19
	in0	b,(var1)	; ED 00u10
	in0	c,(var2)	; ED 08 20
	in0	d,(19)		; ED 10 19
	in0	e,(var1)	; ED 18u10
	in0	h,(var2)	; ED 20 20
	in0	l,(19)		; ED 28 19

	inc	(hl)		; 34
	inc.l	(hl)		; 49 34
	inc	ixh		; DD 24
	inc	ixl		; DD 2C
	inc	iyh		; FD 24
	inc	iyl		; FD 2C
	inc	ix		; DD 23
	inc.l	ix		; 49 DD 23
	inc	iy		; FD 23
	inc.l	iy		; 49 FD 23
	inc	(ix+var2)	; DD 34 20
	inc.l	(ix+var1)	; 49 DD 34r10
	inc	(iy+var2)	; FD 34 20
	inc.l	(iy+var1)	; 49 FD 34r10
	inc	a		; 3C
	inc	b		; 04
	inc	c		; 0C
	inc	d		; 14
	inc	e		; 1C
	inc	h		; 24
	inc	l		; 2C
	inc	bc		; 03
	inc	de		; 13
	inc	hl		; 23
	inc.l	bc		; 49 03
	inc.l	de		; 49 13
	inc.l	hl		; 49 23
	inc	sp		; 33
	inc.l	sp		; 49 33

	ind			; ED AA
	ind.l			; 49 ED AA

	ind2			; ED 8C
	ind2.l			; 49 ED 8C

	ind2r			; ED 9C
	ind2r.l			; 49 ED 9C

	indm			; ED 8A
	indm.l			; 49 ED 8A

	indmr			; ED 9A
	indmr.l			; 49 ED 9A

	indr			; ED BA
	indr.l			; 49 ED BA

	indrx			; ED CA
	indrx.l			; 49 ED CA

	ini			; ED A2
	ini.l			; 49 ED A2

	ini2			; ED 84
	ini2.l			; 49 ED 84

	ini2r			; ED 94
	ini2r.l			; 49 ED 94

	inim			; ED 82
	inim.l			; 49 ED 82

	inimr			; ED 92
	inimr.l			; 49 ED 92

	inir			; ED B2
	inir.l			; 49 ED B2

	inirx			; ED C2
	inirx.l			; 49 ED C2

	jp	nz,19		; C2 19 00
	jp	z,var1		; CA*10n00
	jp	nc,var2		; D2 20 00
	jp	c,19		; DA 19 00
	jp	po,var1		; E2*10n00
	jp	pe,var2		; EA 20 00
	jp	p,19		; F2 19 00
	jp	m,var1		; FA*10n00
	jp.sis	nz,var1		; 40 C2*10n00
	jp.sis	z,var2		; 40 CA 20 00
	jp.sis	nc,19		; 40 D2 19 00
	jp.sis	c,var1		; 40 DA*10n00
	jp.sis	po,var2		; 40 E2 20 00
	jp.sis	pe,19		; 40 EA 19 00
	jp.sis	p,var1		; 40 F2*10n00
	jp.sis	m,var2		; 40 FA 20 00
	jp	(hl)		; E9
	jp.l	(hl)		; 49 E9
	jp	(ix)		; DD E9
	jp.s	(ix)		; 40 DD E9
	jp.l	(ix)		; 5B DD E9
	jp	(iy)		; FD E9
	jp.s	(iy)		; 40 FD E9
	jp.l	(iy)		; 5B FD E9
	jp	var2		; C3 20 00
	jp.sis	var1		; 40 C3*10n00

	jr	nz,jr1z80	; 20 08
	jr	z,jr2z80	; 28 06
	jr	nc,jr3z80	; 30 04
	jr	c,jr4z80	; 38 02
	jr	jr5z80		; 18 00

	jr1z80:	jr2z80:	jr3z80:	jr4z80:	jr5z80:

	ld	a,i		; ED 57
	ld	a,(ix+19)	; DD 7E 19
	ld.l	a,(ix+var2)	; 49 DD 7E 20
	ld	a,(iy+19)	; FD 7E 19
	ld.l	a,(iy+var2)	; 49 FD 7E 20
	ld	a,mb		; ED 6E
	ld	a,(var1)	; 3A*10n00
	ld	a,r		; ED 5F
	ld	a,(bc)		; 0A
	ld.l	a,(bc)		; 49 0A
	ld	a,(de)		; 1A
	ld.l	a,(de)		; 49 1A
	ld	a,(hl)		; 7E
	ld.l	a,(hl)		; 49 7E
	ld	hl,i		; ED D7
	ld	(hl),ix		; ED 3F
	ld.l	(hl),ix		; 49 ED 3F
	ld	(hl),iy		; ED 3E
	ld.l	(hl),iy		; 49 ED 3E
	ld	(hl),var1	; 36r10
	ld.l	(hl),19		; 49 36 19
	ld	(hl),a		; 77
	ld	(hl),b		; 70
	ld	(hl),c		; 71
	ld	(hl),d		; 72
	ld	(hl),e		; 73
	ld	(hl),h		; 74
	ld	(hl),l		; 75
	ld.l	(hl),a		; 49 77
	ld.l	(hl),b		; 49 70
	ld.l	(hl),c		; 49 71
	ld.l	(hl),d		; 49 72
	ld.l	(hl),e		; 49 73
	ld.l	(hl),h		; 49 74
	ld.l	(hl),l		; 49 75
	ld	(hl),bc		; ED 0F
	ld.l	(hl),bc		; 49 ED 0F
	ld	(hl),de		; ED 1F
	ld.l	(hl),de		; 49 ED 1F
	ld	(hl),hl		; ED 2F
	ld.l	(hl),hl		; 49 ED 2F
	ld	i,hl		; ED C7
	ld	i,a		; ED 47
	ld	ixh,ixh		; DD 64
	ld	ixh,ixl		; DD 65
	ld	ixl,ixh		; DD 6C
	ld	ixl,ixl		; DD 6D
	ld	iyh,iyh		; FD 64
	ld	iyh,iyl		; FD 65
	ld	iyl,iyh		; FD 6C
	ld	iyl,iyl		; FD 6D
	ld	ixh,var2	; DD 26 20
	ld	ixl,19		; DD 2E 19
	ld	iyh,var1	; FD 26r10
	ld	iyl,var2	; FD 2E 20
	ld	ixh,a		; DD 67
	ld	ixh,b		; DD 60
	ld	ixh,c		; DD 61
	ld	ixh,d		; DD 62
	ld	ixh,e		; DD 63
	ld	ixl,a		; DD 6F
	ld	ixl,b		; DD 68
	ld	ixl,c		; DD 69
	ld	ixl,d		; DD 6A
	ld	ixl,e		; DD 6B
	ld	iyh,a		; FD 67
	ld	iyh,b		; FD 60
	ld	iyh,c		; FD 61
	ld	iyh,d		; FD 62
	ld	iyh,e		; FD 63
	ld	iyl,a		; FD 6F
	ld	iyl,b		; FD 68
	ld	iyl,c		; FD 69
	ld	iyl,d		; FD 6A
	ld	iyl,e		; FD 6B
	ld	ix,(hl)		; ED 37
	ld.l	ix,(hl)		; 49 ED 37
	ld	iy,(hl)		; ED 31
	ld.l	iy,(hl)		; 49 ED 31
	ld	ix,(ix+var2)	; DD 37 20
	ld.l	ix,(ix+var1)	; 49 DD 37r10
	ld	iy,(ix+var2)	; DD 31 20
	ld.l	iy,(ix+var1)	; 49 DD 31r10
	ld	ix,(iy+var2)	; FD 31 20
	ld.l	ix,(iy+var1)	; 49 FD 31r10
	ld	iy,(iy+var2)	; FD 37 20
	ld.l	iy,(iy+var1)	; 49 FD 37r10
	ld	ix,var2		; DD 21 20 00
	ld	iy,19		; FD 21 19 00
	ld	ix,(var1)	; DD 2A*10n00
	ld	iy,(var2)	; FD 2A 20 00
	ld	(ix+19),ix	; DD 3F 19
	ld.l	(ix+var2),ix	; 49 DD 3F 20
	ld	(ix+19),iy	; DD 3E 19
	ld.l	(ix+var2),iy	; 49 DD 3E 20
	ld	(iy+19),ix	; FD 3E 19
	ld.l	(iy+var2),ix	; 49 FD 3E 20
	ld	(iy+19),iy	; FD 3F 19
	ld.l	(iy+var2),iy	; 49 FD 3F 20
	ld	(ix+19),#29	; DD 36 19 29
	ld.l	(ix+var2),var2	; 49 DD 36 20 20
	ld	(iy+19),#29	; FD 36 19 29
	ld.l	(iy+var2),var2	; 49 FD 36 20 20
	ld	(ix+19),a	; DD 77 19
	ld	(ix+var1),b	; DD 70r10
	ld	(ix+var2),c	; DD 71 20
	ld	(ix+19),d	; DD 72 19
	ld	(ix+var1),e	; DD 73r10
	ld	(ix+var2),h	; DD 74 20
	ld	(ix+19),l	; DD 75 19
	ld.l	(ix+var2),a	; 49 DD 77 20
	ld.l	(ix+19),b	; 49 DD 70 19
	ld.l	(ix+var1),c	; 49 DD 71r10
	ld.l	(ix+var2),d	; 49 DD 72 20
	ld.l	(ix+19),e	; 49 DD 73 19
	ld.l	(ix+var1),h	; 49 DD 74r10
	ld.l	(ix+var2),l	; 49 DD 75 20
	ld	(iy+19),a	; FD 77 19
	ld	(iy+var1),b	; FD 70r10
	ld	(iy+var2),c	; FD 71 20
	ld	(iy+19),d	; FD 72 19
	ld	(iy+var1),e	; FD 73r10
	ld	(iy+var2),h	; FD 74 20
	ld	(iy+19),l	; FD 75 19
	ld.l	(iy+var2),a	; 49 FD 77 20
	ld.l	(iy+19),b	; 49 FD 70 19
	ld.l	(iy+var1),c	; 49 FD 71r10
	ld.l	(iy+var2),d	; 49 FD 72 20
	ld.l	(iy+19),e	; 49 FD 73 19
	ld.l	(iy+var1),h	; 49 FD 74r10
	ld.l	(iy+var2),l	; 49 FD 75 20
	ld	(ix+19),bc	; DD 0F 19
	ld.l	(ix+var2),bc	; 49 DD 0F 20
	ld	(ix+19),de	; DD 1F 19
	ld.l	(ix+var2),de	; 49 DD 1F 20
	ld	(ix+19),hl	; DD 2F 19
	ld.l	(ix+var2),hl	; 49 DD 2F 20
	ld	(iy+19),bc	; FD 0F 19
	ld.l	(iy+var2),bc	; 49 FD 0F 20
	ld	(iy+19),de	; fD 1F 19
	ld.l	(iy+var2),de	; 49 FD 1F 20
	ld	(iy+19),hl	; FD 2F 19
	ld.l	(iy+var2),hl	; 49 FD 2F 20
	ld	mb,a		; ED 6D
	ld	(var1),a	; 32*10n00
	ld	(var2),ix	; DD 22 20 00
	ld	(19),iy		; FD 22 19 00
	ld	(var1),bc	; ED 43*10n00
	ld	(var2),de	; ED 53 20 00
	ld	(19),hl		; 22 19 00
	ld	(var1),sp	; ED 73*10n00
	ld	r,a		; ED 4F
	ld	b,(hl)		; 46
	ld	c,(hl)		; 4E
	ld	d,(hl)		; 56
	ld	e,(hl)		; 5E
	ld	h,(hl)		; 66
	ld	l,(hl)		; 6E
	ld.l	b,(hl)		; 49 46
	ld.l	c,(hl)		; 49 4E
	ld.l	d,(hl)		; 49 56
	ld.l	e,(hl)		; 49 5E
	ld.l	h,(hl)		; 49 66
	ld.l	l,(hl)		; 49 6E
	ld	a,ixh		; DD 7C
	ld	a,ixl		; DD 7D
	ld	a,iyh		; FD 7C
	ld	a,iyl		; FD 7D
	ld	b,ixh		; DD 44
	ld	b,ixl		; DD 45
	ld	b,iyh		; FD 44
	ld	b,iyl		; FD 45
	ld	c,ixh		; DD 4C
	ld	c,ixl		; DD 4D
	ld	c,iyh		; FD 4C
	ld	c,iyl		; FD 4D
	ld	d,ixh		; DD 54
	ld	d,ixl		; DD 55
	ld	d,iyh		; FD 54
	ld	d,iyl		; FD 55
	ld	e,ixh		; DD 5C
	ld	e,ixl		; DD 5D
	ld	e,iyh		; FD 5C
	ld	e,iyl		; FD 5D
	ld	b,(ix+var2)	; DD 46 20
	ld	c,(ix+19)	; DD 4E 19
	ld	d,(ix+var1)	; DD 56r10
	ld	e,(ix+var2)	; DD 5E 20
	ld	h,(ix+19)	; DD 66 19
	ld	l,(ix+var1)	; DD 6Er10
	ld.l	b,(ix+var2)	; 49 DD 46 20
	ld.l	c,(ix+19)	; 49 DD 4E 19
	ld.l	d,(ix+var1)	; 49 DD 56r10
	ld.l	e,(ix+var2)	; 49 DD 5E 20
	ld.l	h,(ix+19)	; 49 DD 66 19
	ld.l	l,(ix+var1)	; 49 DD 6Er10
	ld	b,(iy+var2)	; FD 46 20
	ld	c,(iy+19)	; FD 4E 19
	ld	d,(iy+var1)	; FD 56r10
	ld	e,(iy+var2)	; FD 5E 20
	ld	h,(iy+19)	; FD 66 19
	ld	l,(iy+var1)	; FD 6Er10

	;intentional error here

	ld.l	b,(iy+var2)	; 49 FD 46 20
	ld.l	c,(iy+19)	; 49 FD 4E 19
	ld.l	d,(iy+var1)	; 49 FD 56r10
	ld.l	e,(iy+var2)	; 49 FD 5E 20
	ld.l	h,(iy+19)	; 49 FD 66 19
	ld.l	l,(iy+var1)	; 49 FD 6Er10
	ld	a,var2		; 3E 20
	ld	b,19		; 06 19
	ld	c,var1		; 0Er10
	ld	d,var2		; 16 20
	ld	e,19		; 1E 19
	ld	h,var1		; 26r10
	ld	l,var2		; 2E 20
	ld	a,a		; 7F
	ld	a,b		; 78
	ld	a,c		; 79
	ld	a,d		; 7A
	ld	a,e		; 7B
	ld	a,h		; 7C
	ld	a,l		; 7D
	ld	b,a		; 47
;a	ld	b,b		; 40
	ld	b,c		; 41
	ld	b,d		; 42
	ld	b,e		; 43
	ld	b,h		; 44
	ld	b,l		; 45
	ld	c,a		; 4F
	ld	c,b		; 48
;a	ld	c,c		; 49
	ld	c,d		; 4A
	ld	c,e		; 4B
	ld	c,h		; 4C
	ld	c,l		; 4D
	ld	d,a		; 57
	ld	d,b		; 50
	ld	d,c		; 51
;a	ld	d,d		; 52
	ld	d,e		; 53
	ld	d,h		; 54
	ld	d,l		; 55
	ld	e,a		; 5F
	ld	e,b		; 58
	ld	e,c		; 59
	ld	e,d		; 5A
;a	ld	e,e		; 5B
	ld	e,h		; 5C
	ld	e,l		; 5D
	ld	h,a		; 67
	ld	h,b		; 60
	ld	h,c		; 61
	ld	h,d		; 62
	ld	h,e		; 63
	ld	h,h		; 64
	ld	h,l		; 65
	ld	l,a		; 6F
	ld	l,b		; 68
	ld	l,c		; 69
	ld	l,d		; 6A
	ld	l,e		; 6B
	ld	l,h		; 6C
	ld	l,l		; 6D
	ld	bc,(hl)		; ED 07
	ld.l	bc,(hl)		; 49 ED 07
	ld	de,(hl)		; ED 17
	ld.l	de,(hl)		; 49 ED 17
	ld	hl,(hl)		; ED 27
	ld.l	hl,(hl)		; 49 ED 27
	ld	bc,(ix+var1)	; DD 07r10
	ld.l	bc,(ix+19)	; 49 DD 07 19
	ld	de,(ix+var1)	; DD 17r10
	ld.l	de,(ix+19)	; 49 DD 17 19
	ld	hl,(ix+var1)	; DD 27r10
	ld.l	hl,(ix+19)	; 49 DD 27 19
	ld	bc,(iy+var1)	; FD 07r10
	ld.l	bc,(iy+19)	; 49 FD 07 19
	ld	de,(iy+var1)	; FD 17r10
	ld.l	de,(iy+19)	; 49 FD 17 19
	ld	hl,(iy+var1)	; FD 27r10
	ld.l	hl,(iy+19)	; 49 FD 27 19
	ld	bc,var1		; 01*10n00
	ld	de,var2		; 11 20 00
	ld	hl,19		; 21 19 00
	ld	bc,(var1)	; ED 4B*10n00
	ld	de,(var2)	; ED 5B 20 00
	ld	hl,(19)		; 2A 19 00
	ld	(bc),a		; 02
	ld.l	(bc),a		; 49 02
	ld	(de),a		; 12
	ld.l	(de),a		; 49 12
	ld	sp,hl		; F9
	ld.l	sp,hl		; 49 F9
	ld	sp,ix		; DD F9
	ld.l	sp,ix		; 49 DD F9
	ld	sp,iy		; FD F9
	ld.l	sp,iy		; 49 FD F9
	ld	sp,var1		; 31*10n00
	ld	sp,(var2)	; ED 7B 20 00
	ldd			; ED A8
	ldd.l			; 49 ED A8
	lddr			; ED B8
	lddr.l			; 49 ED B8
	ldi			; ED A0
	ldi.l			; 49 ED A0
	ldir			; ED B0
	ldir.l			; 49 ED B0
	lea	ix,ix+19	; ED 32 19
	lea.l	ix,ix+var2	; 49 ED 32 20
	lea	iy,ix+19	; ED 55 19
	lea.l	iy,ix+var2	; 49 ED 55 20
	lea	ix,iy+19	; ED 54 19
	lea.l	ix,iy+var2	; 49 ED 54 20
	lea	iy,iy+19	; ED 33 19
	lea.l	iy,iy+var2	; 49 ED 33 20
	lea	bc,ix+19	; ED 02 19
	lea	de,ix+var1	; ED 12r10
	lea	hl,ix+var2	; ED 22 20
	lea.l	bc,ix+19	; 49 ED 02 19
	lea.l	de,ix+var1	; 49 ED 12r10
	lea.l	hl,ix+var2	; 49 ED 22 20
	lea	bc,iy+19	; ED 03 19
	lea	de,iy+var1	; ED 13r10
	lea	hl,iy+var2	; ED 23 20
	lea.l	bc,iy+19	; 49 ED 03 19
	lea.l	de,iy+var1	; 49 ED 13r10
	lea.l	hl,iy+var2	; 49 ED 23 20

	mlt	bc		; ED 4C
	mlt	de		; ED 5C
	mlt	hl		; ED 6C
	mlt	sp		; ED 7C
	mlt.l	sp		; 49 ED 7C

	neg			; ED 44

	nop			; 00

	or	a,(hl)		; B6
	or.l	a,(hl)		; 49 B6
	or	a,ixh		; DD B4
	or	a,ixl		; DD B5
	or	a,iyh		; FD B4
	or	a,iyl		; FD B5
	or	a,(ix+19)	; DD B6 19
	or.l	a,(ix+var2)	; 49 DD B6 20
	or	a,(iy+19)	; FD B6 19
	or.l	a,(iy+var2)	; 49 FD B6 20
	or	a,19		; F6 19
	or	a,a		; B7
	or	a,b		; B0
	or	a,c		; B1
	or	a,d		; B2
	or	a,e		; B3
	or	a,h		; B4
	or	a,l		; B5

	otd2r			; ED BC
	otd2r.l			; 49 ED BC

	otdm			; ED 8B
	otdm.l			; 49 ED 8B

	otdmr			; ED 9B
	otdmr.l			; 49 ED 9B

	otdr			; ED BB
	otdr.l			; 49 ED BB

	otdrx			; ED CB
	otdrx.l			; 49 ED CB

	oti2r			; ED B4
	oti2r.l			; 49 ED B4

	otim			; ED 83
	otim.l			; 49 ED 83

	otimr			; ED 93
	otimr.l			; 49 ED 93

	otir			; ED B3
	otir.l			; 49 ED B3

	otirx			; ED C3
	otirx.l			; 49 ED C3

	;Z80 assembler variant section

	out	(c),a		; ED 79
	out	(c),b		; ED 41
	out	(c),c		; ED 49
	out	(c),d		; ED 51
	out	(c),e		; ED 59
	out	(c),h		; ED 61
	out	(c),l		; ED 69

	;End of Z80 assembler variant section

	out	(bc),a		; ED 79
	out	(bc),b		; ED 41
	out	(bc),c		; ED 49
	out	(bc),d		; ED 51
	out	(bc),e		; ED 59
	out	(bc),h		; ED 61
	out	(bc),l		; ED 69
	out	(var1),a	; D3u10

	out0	(var2),a	; ED 39 20
	out0	(19),b		; ED 01 19
	out0	(var1),c	; ED 09u10
	out0	(var2),d	; ED 11 20
	out0	(19),e		; ED 19 19
	out0	(var1),h	; ED 21u10
	out0	(var2),l	; ED 29 20

	outd			; ED AB
	outd.l			; 49 ED AB

	outd2			; ED AC
	outd2.l			; 49 ED AC

	outi			; ED A3
	outi.l			; 49 ED A3

	outi2			; ED A4
	outi2.l			; 49 ED A4

	pea	ix+19		; ED 65 19
	pea.l	ix+var2		; 49 ED 65 20
	pea	iy+19		; ED 66 19
	pea.l	iy+var2		; 49 ED 66 20

	pop	af		; F1
	pop.l	af		; 49 F1
	pop	ix		; DD E1
	pop.l	ix		; 49 DD E1
	pop	iy		; FD E1
	pop.l	iy		; 49 FD E1
	pop	bc		; C1
	pop	de		; D1
	pop	hl		; E1
	pop.l	bc		; 49 C1
	pop.l	de		; 49 D1
	pop.l	hl		; 49 E1

	push	af		; F5
	push.l	af		; 49 F5
	push	ix		; DD E5
	push.l	ix		; 49 DD E5
	push	iy		; FD E5
	push.l	iy		; 49 FD E5
	push	bc		; C5
	push	de		; D5
	push	hl		; E5
	push.l	bc		; 49 C5
	push.l	de		; 49 D5
	push.l	hl		; 49 E5

	res	0,(hl)		; CB 86
	res.l	0,(hl)		; 49 CB 86
	res	1,(hl)		; CB 8E
	res.l	1,(hl)		; 49 CB 8E
	res	2,(hl)		; CB 96
	res.l	2,(hl)		; 49 CB 96
	res	3,(hl)		; CB 9E
	res.l	3,(hl)		; 49 CB 9E
	res	4,(hl)		; CB A6
	res.l	4,(hl)		; 49 CB A6
	res	5,(hl)		; CB AE
	res.l	5,(hl)		; 49 CB AE
	res	6,(hl)		; CB B6
	res.l	6,(hl)		; 49 CB B6
	res	_bit7,(hl)	; CBuBE
	res.l	_bit7,(hl)	; 49 CBuBE
	res	0,(ix+19)	; DD CB 19 86
	res.l	0,(ix+var2)	; 49 DD CB 20 86
	res	0,(iy+19)	; FD CB 19 86
	res.l	0,(iy+var2)	; 49 FD CB 20 86
	res	1,(ix+19)	; DD CB 19 8E
	res.l	1,(ix+var2)	; 49 DD CB 20 8E
	res	1,(iy+19)	; FD CB 19 8E
	res.l	1,(iy+var2)	; 49 FD CB 20 8E
	res	2,(ix+19)	; dD CB 19 96
	res.l	2,(ix+var2)	; 49 DD CB 20 96
	res	2,(iy+19)	; FD CB 19 96
	res.l	2,(iy+var2)	; 49 FD CB 20 96
	res	3,(ix+19)	; DD CB 19 9E
	res.l	3,(ix+var2)	; 49 DD CB 20 9E
	res	3,(iy+19)	; fD CB 19 9E
	res.l	3,(iy+var2)	; 49 FD CB 20 9E
	res	4,(ix+19)	; DD CB 19 A6
	res.l	4,(ix+var2)	; 49 DD CB 20 A6
	res	4,(iy+19)	; FD CB 19 A6
	res.l	4,(iy+var2)	; 49 FD CB 20 A6
	res	5,(ix+19)	; DD CB 19 AE
	res.l	5,(ix+var2)	; 49 DD CB 20 AE
	res	5,(iy+19)	; fD CB 19 AE
	res.l	5,(iy+var2)	; 49 FD CB 20 AE
	res	6,(ix+19)	; DD CB 19 B6
	res.l	6,(ix+var2)	; 49 DD CB 20 B6
	res	6,(iy+19)	; FD CB 19 B6
	res.l	6,(iy+var2)	; 49 FD CB 20 B6
	res	_bit7,(ix+19)	; DD CB 19uBE
	res.l	_bit7,(ix+var2)	; 49 DD CB 20uBE
	res	_bit7,(iy+19)	; FD CB 19uBE
	res.l	_bit7,(iy+var2)	; 49 FD CB 20uBE
	res	0,a		; CB 87
	res	0,b		; CB 80
	res	0,c		; CB 81
	res	0,d		; CB 82
	res	0,e		; CB 83
	res	0,h		; CB 84
	res	0,l		; CB 85
	res	1,a		; CB 8F
	RES	1,B		; CB 88
	res	1,c		; CB 89
	res	1,d		; CB 8A
	res	1,e		; CB 8B
	res	1,h		; CB 8C
	res	1,l		; CB 8D
	res	2,a		; CB 97
	res	2,b		; CB 90
	res	2,c		; CB 91
	res	2,d		; CB 92
	res	2,e		; CB 93
	res	2,h		; CB 94
	res	2,l		; CB 95
	res	3,a		; CB 9F
	res	3,b		; CB 98
	res	3,c		; CB 99
	res	3,d		; CB 9A
	res	3,e		; CB 9B
	res	3,h		; CB 9C
	res	3,l		; CB 9D
	res	4,a		; CB A7
	res	4,b		; CB A0
	res	4,c		; CB A1
	res	4,d		; CB A2
	res	4,e		; CB A3
	res	4,h		; CB A4
	res	4,l		; CB A5
	res	5,a		; CB AF
	res	5,b		; CB A8
	res	5,c		; CB A9
	res	5,d		; CB AA
	res	5,e		; CB AB
	res	5,h		; CB AC
	res	5,l		; CB AD
	res	6,a		; CB B7
	res	6,b		; CB B0
	res	6,c		; CB B1
	res	6,d		; CB B2
	res	6,e		; CB B3
	res	6,h		; CB B4
	res	6,l		; CB B5
	res	_bit7,a		; CBuBF
	res	_bit7,b		; CBuB8
	res	_bit7,c		; CBuB9
	res	_bit7,d		; CBuBA
	res	_bit7,e		; CBuBB
	res	_bit7,h		; CBuBC
	res	_bit7,l		; CBuBD

	ret			; C9
	ret.l			; 49 C9
	ret	nz		; C0
	ret	z		; C8
	ret	nc		; D0
	ret	c		; D8
	ret	po		; E0
	ret	pe		; E8
	ret	p		; F0
	ret	m		; F8
	ret.l	nz		; 49 C0
	ret.l	z		; 49 C8
	ret.l	nc		; 49 D0
	ret.l	c		; 49 D8
	ret.l	po		; 49 E0
	ret.l	pe		; 49 E8
	ret.l	p		; 49 F0
	ret.l	m		; 49 F8

	reti			; ED 4D
	reti.l			; 49 ED 4D

	retn			; ED 45
	retn.l			; 49 ED 45

	rl	(hl)		; CB 16
	rl.l	(hl)		; 49 CB 16
	rl	(ix+var2)	; DD CB 20 16
	rl.l	(ix+var1)	; 49 DD CBr10 16
	rl	(iy+var2)	; FD CB 20 16
	rl.l	(iy+var1)	; 49 FD CBr10 16
	rl	a		; CB 17
	rl	b		; CB 10
	rl	c		; CB 11
	rl	d		; CB 12
	rl	e		; CB 13
	rl	h		; CB 14
	rl	l		; CB 15

	rla			; 17

	rlc	(hl)		; CB 06
	rlc.l	(hl)		; 49 CB 06
	rlc	(ix+var2)	; DD CB 20 06
	rlc.l	(ix+var1)	; 49 DD CBr10 06
	rlc	(iy+var2)	; FD CB 20 06
	rlc.l	(iy+var1)	; 49 FD CBr10 06
	rlc	a		; CB 07
	rlc	b		; CB 00
	rlc	c		; CB 01
	rlc	d		; CB 02
	rlc	e		; CB 03
	rlc	h		; CB 04
	rlc	l		; CB 05
	rlca			; 07

	rld			; ED 6F

	rr	(hl)		; CB 1E
	rr.l	(hl)		; 49 CB 1E
	rr	(ix+19)		; DD CB 19 1E
	rr.l	(ix+var2)	; 49 DD CB 20 1E
	rr	(iy+19)		; FD CB 19 1E
	rr.l	(iy+var2)	; 49 FD CB 20 1E
	rr	a		; CB 1F
	rr	b		; CB 18
	rr	c		; CB 19
	rr	d		; CB 1A
	rr	e		; CB 1B
	rr	h		; CB 1C
	rr	l		; CB 1D

	rra			; 1F

	rrc	(hl)		; CB 0E
	rrc.l	(hl)		; 49 CB 0E
	rrc	(ix+19)		; DD CB 19 0E
	rrc.l	(ix+var2)	; 49 DD CB 20 0E
	rrc	(iy+19)		; fD CB 19 0E
	rrc.l	(iy+var2)	; 49 FD CB 20 0E
	rrc	a		; cB 0F
	rrc	b		; CB 08
	rrc	c		; CB 09
	rrc	d		; CB 0A
	rrc	e		; CB 0B
	rrc	h		; CB 0C
	rrc	l		; CB 0D

	rrca			; 0F

	rrd			; ED 67

	rsmix			; ED 7E

	rst	00		; C7
	rst	08		; CF
	rst	10		; D7
	rst	18		; DF
	rst	20		; E7
	rst	28		; EF
	rst	30		; F7
	rst	38		; FF
	rst.l	00		; 49 C7
	rst.l	08		; 49 CF
	rst.l	10		; 49 D7
	rst.l	18		; 49 DF
	rst.l	20		; 49 E7
	rst.l	28		; 49 EF
	rst.l	30		; 49 F7
	rst.l	38		; 49 FF

	sbc	a,(hl)		; 9E
	sbc.l	a,(hl)		; 49 9E
	sbc	a,ixh		; DD 9C
	sbc	a,ixl		; DD 9D
	sbc	a,iyh		; FD 9C
	sbc	a,iyl		; FD 9D
	sbc	a,(ix+19)	; DD 9E 19
	sbc.l	a,(ix+var2)	; 49 DD 9E 20
	sbc	a,(iy+19)	; FD 9E 19
	sbc.l	a,(iy+var2)	; 49 FD 9E 20
	sbc	a,19		; DE 19
	sbc	a,a		; 9F
	sbc	a,b		; 98
	sbc	a,c		; 99
	sbc	a,d		; 9A
	sbc	a,e		; 9B
	sbc	a,h		; 9C
	sbc	a,l		; 9D
	sbc	hl,bc		; ED 42
	sbc	hl,de		; ED 52
	sbc	hl,hl		; ED 62
	sbc.l	hl,bc		; 49 ED 42
	sbc.l	hl,de		; 49 ED 52
	sbc.l	hl,hl		; 49 ED 62
	sbc	hl,sp		; ED 72
	sbc.l	hl,sp		; 49 ED 72

	scf			; 37

	set	0,(hl)		; cb c6
	set.l	0,(hl)		; 49 CB C6
	set	0,(ix+19)	; DD CB 19 C6
	set.l	0,(ix+var2)	; 49 DD CB 20 C6
	set	0,(iy+19)	; FD CB 19 C6
	set.l	0,(iy+var2)	; 49 FD CB 20 C6
	set	1,(hl)		; CB CE
	set.l	1,(hl)		; 49 CB CE
	set	1,(ix+19)	; DD CB 19 CE
	set.l	1,(ix+var2)	; 49 DD CB 20 CE
	set	1,(iy+19)	; FD CB 19 CE
	set.l	1,(iy+var2)	; 49 FD CB 20 CE
	set	2,(hl)		; CB D6
	set.l	2,(hl)		; 49 CB D6
	set	2,(ix+19)	; DD CB 19 D6
	set.l	2,(ix+var2)	; 49 DD CB 20 D6
	set	2,(iy+19)	; FD CB 19 D6
	set.l	2,(iy+var2)	; 49 FD CB 20 D6
	set	3,(hl)		; CB DE
	set.l	3,(hl)		; 49 CB DE
	set	3,(ix+19)	; DD CB 19 DE
	set.l	3,(ix+var2)	; 49 DD CB 20 DE
	set	3,(iy+19)	; FD CB 19 DE
	set.l	3,(iy+var2)	; 49 FD CB 20 DE
	set	4,(hl)		; CB E6
	set.l	4,(hl)		; 49 CB E6
	set	4,(ix+19)	; DD CB 19 E6
	set.l	4,(ix+var2)	; 49 DD CB 20 E6
	set	4,(iy+19)	; FD CB 19 E6
	set.l	4,(iy+var2)	; 49 FD CB 20 E6
	set	5,(hl)		; CB EE
	set.l	5,(hl)		; 49 CB EE
	set	5,(ix+19)	; DD CB 19 EE
	set.l	5,(ix+var2)	; 49 DD CB 20 EE
	set	5,(iy+19)	; FD CB 19 EE
	set.l	5,(iy+var2)	; 49 FD CB 20 EE
	set	6,(hl)		; CB F6
	set.l	6,(hl)		; 49 CB F6
	set	6,(ix+19)	; DD CB 19 F6
	set.l	6,(ix+var2)	; 49 DD CB 20 F6
	set	6,(iy+19)	; FD CB 19 F6
	set.l	6,(iy+var2)	; 49 FD CB 20 F6
	set	_bit7,(hl)	; CBuFE
	set.l	_bit7,(hl)	; 49 CBuFE
	set	_bit7,(ix+19)	; DD CB 19uFE
	set.l	_bit7,(ix+var2)	; 49 DD CB 20uFE
	set	_bit7,(iy+19)	; FD CB 19uFE
	set.l	_bit7,(iy+var2)	; 49 FD CB 20uFE
	set	0,a		; CB C7
	set	0,b		; CB C0
	set	0,c		; CB C1
	set	0,d		; CB C2
	set	0,e		; CB C3
	set	0,h		; CB C4
	set	0,l		; CB C5
	set	1,a		; CB CF
	set	1,b		; CB C8
	set	1,c		; CB C9
	set	1,d		; CB CA
	set	1,e		; CB CB
	set	1,h		; CB CC
	set	1,l		; CB CD
	set	2,a		; CB D7
	set	2,b		; CB D0
	set	2,c		; CB D1
	set	2,d		; CB D2
	set	2,e		; CB D3
	set	2,h		; CB D4
	set	2,l		; CB D5
	set	3,a		; CB DF
	set	3,b		; CB D8
	set	3,c		; CB D9
	set	3,d		; CB DA
	set	3,e		; CB DB
	set	3,h		; CB DC
	set	3,l		; CB DD
	set	4,a		; CB E7
	set	4,b		; CB E0
	set	4,c		; CB E1
	set	4,d		; CB E2
	set	4,e		; CB E3
	set	4,h		; CB E4
	set	4,l		; CB E5
	set	5,a		; CB EF
	set	5,b		; CB E8
	set	5,c		; CB E9
	set	5,d		; CB EA
	set	5,e		; CB EB
	set	5,h		; CB EC
	set	5,l		; CB ED
	set	6,a		; CB F7
	set	6,b		; CB F0
	set	6,c		; CB F1
	set	6,d		; CB F2
	set	6,e		; CB F3
	set	6,h		; CB F4
	set	6,l		; CB F5
	set	_bit7,a		; CBuFF
	set	_bit7,b		; CBuF8
	set	_bit7,c		; CBuF9
	set	_bit7,d		; CBuFA
	set	_bit7,e		; CBuFB
	set	_bit7,h		; CBuFC
	set	_bit7,l		; CBuFD

	sla	(hl)		; CB 26
	sla.l	(hl)		; 49 CB 26
	sla	(ix+var2)	; DD CB 20 26
	sla.l	(ix+var1)	; 49 DD CBr10 26
	sla	(iy+var2)	; FD CB 20 26
	sla.l	(iy+var1)	; 49 FD CBr10 26
	sla	a		; CB 27
	sla	b		; CB 20
	sla	c		; CB 21
	sla	d		; CB 22
	sla	e		; CB 23
	sla	h		; CB 24
	sla	l		; CB 25

	slp			; ED 76

	sra	(hl)		; CB 2E
	sra.l	(hl)		; 49 CB 2E
	sra	(ix+var2)	; DD CB 20 2E
	sra.l	(ix+var1)	; 49 DD CBr10 2E
	sra	(iy+var2)	; FD CB 20 2E
	sra.l	(iy+var1)	; 49 fD CBr10 2E
	sra	a		; CB 2F
	sra	b		; CB 28
	sra	c		; CB 29
	sra	d		; CB 2A
	sra	e		; CB 2B
	sra	h		; CB 2C
	sra	l		; CB 2D

	srl	(hl)		; CB 3E
	srl.l	(hl)		; 49 CB 3E
	srl	(ix+var1)	; DD CBr10 3E
	srl.l	(ix+19)		; 49 DD CB 19 3E
	srl	(iy+var1)	; fD CBr10 3E
	srl.l	(iy+19)		; 49 FD CB 19 3E
	srl	a		; CB 3F
	srl	b		; CB 38
	srl	c		; CB 39
	srl	d		; CB 3A
	srl	e		; CB 3B
	srl	h		; CB 3C
	srl	l		; CB 3D

	stmix			; ED 7D

	sub	a,(hl)		; 96
	sub.l	a,(hl)		; 49 96
	sub	a,ixh		; DD 94
	sub	a,ixl		; DD 95
	sub	a,iyh		; FD 94
	sub	a,iyl		; FD 95
	sub	a,(ix+var2)	; DD 96 20
	sub.l	a,(ix+var1)	; 49 DD 96r10
	sub	a,(iy+var2)	; FD 96 20
	sub.l	a,(iy+var1)	; 49 FD 96r10
	sub	a,var2		; D6 20
	sub	a,a		; 97
	sub	a,b		; 90
	sub	a,c		; 91
	sub	a,d		; 92
	sub	a,e		; 93
	sub	a,h		; 94
	sub	a,l		; 95

	tst	a,(hl)		; ED 34

	; The following line has errata in
	; manual codes (49,ed,73), the ones
	; listed here are correct

	tst.l	a,(hl)		; 49 ED 34
	tst	a,19		; ED 64 19
	tst	a,a		; ED 3C
	tst	a,b		; ED 04
	tst	a,c		; ED 0C
	tst	a,d		; ED 14
	tst	a,e		; ED 1C
	tst	a,h		; ED 24
	tst	a,l		; ED 2C

	tstio	var2		; ED 74 20

	xor	a,(hl)		; AE
	xor.l	a,(hl)		; 49 AE
	xor	a,ixh		; DD AC
	xor	a,ixl		; DD AD
	xor	a,iyh		; FD AC
	xor	a,iyl		; FD AD
	xor	a,(ix+var1)	; DD AEr10
	xor.l	a,(ix+19)	; 49 DD AE 19
	xor	a,(iy+var1)	; FD AEr10
	xor.l	a,(iy+19)	; 49 FD AE 19
	xor	a,var1		; EEr10
	XOR	a,a		; AF
	xor	a,b		; A8
	xor	a,c		; A9
	xor	a,d		; AA
	xor	a,e		; AB
	xor	a,h		; AC
	xor	a,l		; AD


