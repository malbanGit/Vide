	.title Error Test Module for the eZ80 Processor

	; This module attempts to verify the error
	; coding of the ASEZ80 assembler.  A selection
	; of valid and invalid instuction opcodes are
	; tested.  The comment (; ....) in the code
	; line contains either the error code (a,o,...)
	; or the valid instruction codes.
	;
	; Instruction forms that are not defined
	; by entries in ez80pst.c give 'o' errors.
	;
	; Instruction forms that are illegal
	; give 'a' errors.

	.radix h

	;var1=10
	.define	var1, "varx + 10"

	var2==20


	; Optional Forms Without Explicit A
	; are First in Each Section.

	.page
	.sbttl	Modes Common to ADC, ADD, and SBC

	.adl
	adc	(hl)		; 8E
	adc	ixh		; DD 8C
	adc	ixl		; DD 8D
	adc	iyh		; FD 8C
	adc	iyl		; FD 8D
	adc	(ix+var2)	; DD 8E 20
	adc	(iy+var2)	; FD 8E 20
	adc	var2		; CE 20
	adc	#var2		; CE 20
	adc	a		; 8F
	adc	b		; 88
	adc	c		; 89
	adc	d		; 8A
	adc	e		; 8B
	adc	h		; 8C
	adc	l		; 8D

	.z80
	adc	(hl)		; 8E
	adc	ixh		; DD 8C
	adc	ixl		; DD 8D
	adc	iyh		; FD 8C
	adc	iyl		; FD 8D
	adc	(ix+var2)	; DD 8E 20
	adc	(iy+var2)	; FD 8E 20
	adc	var2		; CE 20
	adc	#var2		; CE 20
	adc	a		; 8F
	adc	b		; 88
	adc	c		; 89
	adc	d		; 8A
	adc	e		; 8B
	adc	h		; 8C
	adc	l		; 8D

	.page
	
	.adl
	adc	a,(hl)		; 8E
	adc	a,ixh		; DD 8C
	adc	a,ixl		; DD 8D
	adc	a,iyh		; FD 8C
	adc	a,iyl		; FD 8D
	adc	a,(ix+var2)	; DD 8E 20
	adc	a,(iy+var2)	; FD 8E 20
	adc	a,var2		; CE 20
	adc	a,#var2		; CE 20
	adc	a,a		; 8F
	adc	a,b		; 88
	adc	a,c		; 89
	adc	a,d		; 8A
	adc	a,e		; 8B
	adc	a,h		; 8C
	adc	a,l		; 8D
	adc	hl,bc		; ED 4A
	adc	hl,de		; ED 5A
	adc	hl,hl		; ED 6A
	adc	hl,sp		; ED 7A

	.z80
	adc	a,(hl)		; 8E
	adc	a,ixh		; DD 8C
	adc	a,ixl		; DD 8D
	adc	a,iyh		; FD 8C
	adc	a,iyl		; FD 8D
	adc	a,(ix+var2)	; DD 8E 20
	adc	a,(iy+var2)	; FD 8E 20
	adc	a,var2		; CE 20
	adc	a,#var2		; CE 20
	adc	a,a		; 8F
	adc	a,b		; 88
	adc	a,c		; 89
	adc	a,d		; 8A
	adc	a,e		; 8B
	adc	a,h		; 8C
	adc	a,l		; 8D
	adc	hl,bc		; ED 4A
	adc	hl,de		; ED 5A
	adc	hl,hl		; ED 6A
	adc	hl,sp		; ED 7A

	.page
	
	.adl
	adc.s	(hl)		; 52 8E
	adc.s	ixh		;a
	adc.s	ixl		;a
	adc.s	iyh		;a
	adc.s	iyl		;a
	adc.s	(ix+var2)	; 52 DD 8E 20
	adc.s	(iy+var2)	; 52 FD 8E 20
	adc.s	var2		;a
	adc.s	#var2		;a
	adc.s	a		;a
	adc.s	b		;a
	adc.s	c		;a
	adc.s	d		;a
	adc.s	e		;a
	adc.s	h		;a
	adc.s	l		;a

	.z80
	adc.s	(hl)		;a
	adc.s	ixh		;a
	adc.s	ixl		;a
	adc.s	iyh		;a
	adc.s	iyl		;a
	adc.s	(ix+var2)	;a
	adc.s	(iy+var2)	;a
	adc.s	var2		;a
	adc.s	#var2		;a
	adc.s	a		;a
	adc.s	b		;a
	adc.s	c		;a
	adc.s	d		;a
	adc.s	e		;a
	adc.s	h		;a
	adc.s	l		;a

	.page

	.adl
	adc.s	a,(hl)		; 52 8E
	adc.s	a,ixh		;a
	adc.s	a,ixl		;a
	adc.s	a,iyh		;a
	adc.s	a,iyl		;a
	adc.s	a,(ix+var2)	; 52 DD 8E 20
	adc.s	a,(iy+var2)	; 52 FD 8E 20
	adc.s	a,var2		;a
	adc.s	a,#var2		;a
	adc.s	a,a		;a
	adc.s	a,b		;a
	adc.s	a,c		;a
	adc.s	a,d		;a
	adc.s	a,e		;a
	adc.s	a,h		;a
	adc.s	a,l		;a
	adc.s	hl,bc		; 52 ED 4A
	adc.s	hl,de		; 52 ED 5A
	adc.s	hl,hl		; 52 ED 6A
	adc.s	hl,sp		; 52 ED 7A

	.z80
	adc.s	a,(hl)		;a
	adc.s	a,ixh		;a
	adc.s	a,ixl		;a
	adc.s	a,iyh		;a
	adc.s	a,iyl		;a
	adc.s	a,(ix+var2)	;a
	adc.s	a,(iy+var2)	;a
	adc.s	a,var2		;a
	adc.s	a,#var2		;a
	adc.s	a,a		;a
	adc.s	a,b		;a
	adc.s	a,c		;a
	adc.s	a,d		;a
	adc.s	a,e		;a
	adc.s	a,h		;a
	adc.s	a,l		;a
	adc.s	hl,bc		;a
	adc.s	hl,de		;a
	adc.s	hl,hl		;a
	adc.s	hl,sp		;a

	.page

	.adl
	adc.l	(hl)		;a
	adc.l	ixh		;a
	adc.l	ixl		;a
	adc.l	iyh		;a
	adc.l	iyl		;a
	adc.l	(ix+var2)	;a
	adc.l	(iy+var2)	;a
	adc.l	var2		;a
	adc.l	#var2		;a
	adc.l	a		;a
	adc.l	b		;a
	adc.l	c		;a
	adc.l	d		;a
	adc.l	e		;a
	adc.l	h		;a
	adc.l	l		;a

	.z80
	adc.l	(hl)		; 49 8E
	adc.l	ixh		;a
	adc.l	ixl		;a
	adc.l	iyh		;a
	adc.l	iyl		;a
	adc.l	(ix+var2)	; 49 DD 8E 20
	adc.l	(iy+var2)	; 49 FD 8E 20
	adc.l	var2		;a
	adc.l	#var2		;a
	adc.l	a		;a
	adc.l	b		;a
	adc.l	c		;a
	adc.l	d		;a
	adc.l	e		;a
	adc.l	h		;a
	adc.l	l		;a

	.page

	.adl
	adc.l	a,(hl)		;a
	adc.l	a,ixh		;a
	adc.l	a,ixl		;a
	adc.l	a,iyh		;a
	adc.l	a,iyl		;a
	adc.l	a,(ix+var2)	;a
	adc.l	a,(iy+var2)	;a
	adc.l	a,var2		;a
	adc.l	a,#var2		;a
	adc.l	a,a		;a
	adc.l	a,b		;a
	adc.l	a,c		;a
	adc.l	a,d		;a
	adc.l	a,e		;a
	adc.l	a,h		;a
	adc.l	a,l		;a
	adc.l	hl,bc		;a
	adc.l	hl,de		;a
	adc.l	hl,hl		;a
	adc.l	hl,sp		;a

	.z80
	adc.l	a,(hl)		; 49 8E
	adc.l	a,ixh		;a
	adc.l	a,ixl		;a
	adc.l	a,iyh		;a
	adc.l	a,iyl		;a
	adc.l	a,(ix+var2)	; 49 DD 8E 20
	adc.l	a,(iy+var2)	; 49 FD 8E 20
	adc.l	a,var2		;a
	adc.l	a,#var2		;a
	adc.l	a,a		;a
	adc.l	a,b		;a
	adc.l	a,c		;a
	adc.l	a,d		;a
	adc.l	a,e		;a
	adc.l	a,h		;a
	adc.l	a,l		;a
	adc.l	hl,bc		; 49 ED 4A
	adc.l	hl,de		; 49 ED 5A
	adc.l	hl,hl		; 49 ED 6A
	adc.l	hl,sp		; 49 ED 7A

	.page

	; Instruction Forms Illegal in ADC & SBC
	.adl
	adc	ix,bc		;a
	adc	ix,de		;a
	adc	ix,ix		;a
	adc	ix,sp		;a
	adc.s	ix,bc		;a
	adc.s	ix,de		;a
	adc.s	ix,ix		;a
	adc.s	ix,sp		;a
	adc.l	ix,bc		;a
	adc.l	ix,de		;a
	adc.l	ix,ix		;a
	adc.l	ix,sp		;a

	.z80
	adc	ix,bc		;a
	adc	ix,de		;a
	adc	ix,ix		;a
	adc	ix,sp		;a
	adc.s	ix,bc		;a
	adc.s	ix,de		;a
	adc.s	ix,ix		;a
	adc.s	ix,sp		;a
	adc.l	ix,bc		;a
	adc.l	ix,de		;a
	adc.l	ix,ix		;a
	adc.l	ix,sp		;a

	.page

	; Instruction Forms Only in ADD
	.adl
	add	ix,bc		; DD 09
	add	ix,de		; DD 19
	add	ix,ix		; DD 29
	add	ix,sp		; DD 39
	add.s	ix,bc		; 52 DD 09
	add.s	ix,de		; 52 DD 19
	add.s	ix,ix		; 52 DD 29
	add.s	ix,sp		; 52 DD 39
	add.l	ix,bc		;a
	add.l	ix,de		;a
	add.l	ix,ix		;a
	add.l	ix,sp		;a

	.z80
	add	ix,bc		; DD 09
	add	ix,de		; DD 19
	add	ix,ix		; DD 29
	add	ix,sp		; DD 39
	add.s	ix,bc		;a
	add.s	ix,de		;a
	add.s	ix,ix		;a
	add.s	ix,sp		;a
	add.l	ix,bc		; 49 DD 09
	add.l	ix,de		; 49 DD 19
	add.l	ix,ix		; 49 DD 29
	add.l	ix,sp		; 49 DD 39

	.page
	.sbttl	Modes Common to AND, CP, OR, XOR, and SUB

	.adl
	and	(hl)		; A6
	and	ixh		; DD A4
	and	ixl		; DD A5
	and	iyh		; FD A4
	and	iyl		; FD A5
	and	(ix+var2)	; DD A6 20
	and	(iy+var2)	; FD A6 20
	and	var2		; E6 20
	and	a		; A7
	and	b		; A0
	and	c		; A1
	and	d		; A2
	and	e		; A3
	and	h		; A4
	and	l		; A5

	.z80
	and	(hl)		; A6
	and	ixh		; DD A4
	and	ixl		; DD A5
	and	iyh		; FD A4
	and	iyl		; FD A5
	and	(ix+var2)	; DD A6 20
	and	(iy+var2)	; FD A6 20
	and	var2		; E6 20
	and	a		; A7
	and	b		; A0
	and	c		; A1
	and	d		; A2
	and	e		; A3
	and	h		; A4
	and	l		; A5

	.page

	.adl
	and	a,(hl)		; A6
	and	a,ixh		; DD A4
	and	a,ixl		; DD A5
	and	a,iyh		; FD A4
	and	a,iyl		; FD A5
	and	a,(ix+var2)	; DD A6 20
	and	a,(iy+var2)	; FD A6 20
	and	a,var2		; E6 20
	and	a,a		; A7
	and	a,b		; A0
	and	a,c		; A1
	and	a,d		; A2
	and	a,e		; A3
	and	a,h		; A4
	and	a,l		; A5

	.z80
	and	a,(hl)		; A6
	and	a,ixh		; DD A4
	and	a,ixl		; DD A5
	and	a,iyh		; FD A4
	and	a,iyl		; FD A5
	and	a,(ix+var2)	; DD A6 20
	and	a,(iy+var2)	; FD A6 20
	and	a,var2		; E6 20
	and	a,a		; A7
	and	a,b		; A0
	and	a,c		; A1
	and	a,d		; A2
	and	a,e		; A3
	and	a,h		; A4
	and	a,l		; A5

	.page

	.adl
	and.s	(hl)		; 52 A6
	and.s	ixh		;a
	and.s	ixl		;a
	and.s	iyh		;a
	and.s	iyl		;a
	and.s	(ix+var2)	; 52 DD A6 20
	and.s	(iy+var2)	; 52 FD A6 20
	and.s	var2		;a
	and.s	a		;a
	and.s	b		;a
	and.s	c		;a
	and.s	d		;a
	and.s	e		;a
	and.s	h		;a
	and.s	l		;a

	.z80
	and.s	(hl)		;a
	and.s	ixh		;a
	and.s	ixl		;a
	and.s	iyh		;a
	and.s	iyl		;a
	and.s	(ix+var2)	;a
	and.s	(iy+var2)	;a
	and.s	var2		;a
	and.s	a		;a
	and.s	b		;a
	and.s	c		;a
	and.s	d		;a
	and.s	e		;a
	and.s	h		;a
	and.s	l		;a

	.page

	.adl
	and.s	a,(hl)		; 52 A6
	and.s	a,ixh		;a
	and.s	a,ixl		;a
	and.s	a,iyh		;a
	and.s	a,iyl		;a
	and.s	a,(ix+var2)	; 52 DD A6 20
	and.s	a,(iy+var2)	; 52 FD A6 20
	and.s	a,var2		;a
	and.s	a,a		;a
	and.s	a,b		;a
	and.s	a,c		;a
	and.s	a,d		;a
	and.s	a,e		;a
	and.s	a,h		;a
	and.s	a,l		;a

	.z80
	and.s	a,(hl)		;a
	and.s	a,ixh		;a
	and.s	a,ixl		;a
	and.s	a,iyh		;a
	and.s	a,iyl		;a
	and.s	a,(ix+var2)	;a
	and.s	a,(iy+var2)	;a
	and.s	a,var2		;a
	and.s	a,a		;a
	and.s	a,b		;a
	and.s	a,c		;a
	and.s	a,d		;a
	and.s	a,e		;a
	and.s	a,h		;a
	and.s	a,l		;a

	.page

	.adl
	and.l	(hl)		;a
	and.l	ixh		;a
	and.l	ixl		;a
	and.l	iyh		;a
	and.l	iyl		;a
	and.l	(ix+var2)	;a
	and.l	(iy+var2)	;a
	and.l	var2		;a
	and.l	a		;a
	and.l	b		;a
	and.l	c		;a
	and.l	d		;a
	and.l	e		;a
	and.l	h		;a
	and.l	l		;a

	.z80
	and.l	(hl)		; 49 A6
	and.l	ixh		;a
	and.l	ixl		;a
	and.l	iyh		;a
	and.l	iyl		;a
	and.l	(ix+var2)	; 49 DD A6 20
	and.l	(iy+var2)	; 49 FD A6 20
	and.l	var2		;a
	and.l	a		;a
	and.l	b		;a
	and.l	c		;a
	and.l	d		;a
	and.l	e		;a
	and.l	h		;a
	and.l	l		;a

	.page

	.adl
	and.l	a,(hl)		;a
	and.l	a,ixh		;a
	and.l	a,ixl		;a
	and.l	a,iyh		;a
	and.l	a,iyl		;a
	and.l	a,(ix+var2)	;a
	and.l	a,(iy+var2)	;a
	and.l	a,var2		;a
	and.l	a,a		;a
	and.l	a,b		;a
	and.l	a,c		;a
	and.l	a,d		;a
	and.l	a,e		;a
	and.l	a,h		;a
	and.l	a,l		;a

	.z80
	and.l	a,(hl)		; 49 A6
	and.l	a,ixh		;a
	and.l	a,ixl		;a
	and.l	a,iyh		;a
	and.l	a,iyl		;a
	and.l	a,(ix+var2)	; 49 DD A6 20
	and.l	a,(iy+var2)	; 49 FD A6 20
	and.l	a,var2		;a
	and.l	a,a		;a
	and.l	a,b		;a
	and.l	a,c		;a
	and.l	a,d		;a
	and.l	a,e		;a
	and.l	a,h		;a
	and.l	a,l		;a

	.page
	.sbttl	Modes Common to BIT, RES, and SET

	.adl
	bit	0,(hl)		; CB 46
	bit	1,(ix+var2)	; DD CB 20 4E
	bit	2,(iy+var2)	; FD CB 20 56
	bit	4,a		; CB 67
	bit	4,b		; CB 60
	bit	4,c		; CB 61
	bit	4,d		; CB 62
	bit	4,e		; CB 63
	bit	4,h		; CB 64
	bit	4,l		; CB 65

	.z80
	bit	0,(hl)		; CB 46
	bit	1,(ix+var2)	; DD CB 20 4E
	bit	2,(iy+var2)	; FD CB 20 56
	bit	4,a		; CB 67
	bit	4,b		; CB 60
	bit	4,c		; CB 61
	bit	4,d		; CB 62
	bit	4,e		; CB 63
	bit	4,h		; CB 64
	bit	4,l		; CB 65

	.page

	.adl
	bit.s	0,(hl)		; 52 CB 46
	bit.s	1,(ix+var2)	; 52 DD CB 20 4E
	bit.s	2,(iy+var2)	; 52 FD CB 20 56
	bit.s	4,a		;a
	bit.s	4,b		;a
	bit.s	4,c		;a
	bit.s	4,d		;a
	bit.s	4,e		;a
	bit.s	4,h		;a
	bit.s	4,l		;a

	.z80
	bit.s	0,(hl)		;a
	bit.s	1,(ix+var2)	;a
	bit.s	2,(iy+var2)	;a
	bit.s	4,a		;a
	bit.s	4,b		;a
	bit.s	4,c		;a
	bit.s	4,d		;a
	bit.s	4,e		;a
	bit.s	4,h		;a
	bit.s	4,l		;a

	.page

	.adl
	bit.l	0,(hl)		;a
	bit.l	1,(ix+var2)	;a
	bit.l	2,(iy+var2)	;a
	bit.l	4,a		;a
	bit.l	4,b		;a
	bit.l	4,c		;a
	bit.l	4,d		;a
	bit.l	4,e		;a
	bit.l	4,h		;a
	bit.l	4,l		;a

	.z80
	bit.l	0,(hl)		; 49 CB 46
	bit.l	1,(ix+var2)	; 49 DD CB 20 4E
	bit.l	2,(iy+var2)	; 49 FD CB 20 56
	bit.l	4,a		;a
	bit.l	4,b		;a
	bit.l	4,c		;a
	bit.l	4,d		;a
	bit.l	4,e		;a
	bit.l	4,h		;a
	bit.l	4,l		;a

	.page
	.sbttl	Modes of CALL

	.adl
	call	nz,var1		; C4r10s00R00
	call.is	nz,var2		; 49 C4 20 00
	call.il	nz,var2		; 5B C4 20 00 00
	call	var1		; CDr10s00R00
	call.is	var2		; 49 CD 20 00
	call.il	var2		; 5B CD 20 00 00

	.z80
	call	nz,var1		; C4*10n00
	call.is	nz,var2		; 40 C4 20 00
	call.il	nz,var2		; 52 C4 20 00 00
	call	var1		; CD*10n00
	call.is	var2		; 40 CD 20 00
	call.il	var2		; 52 CD 20 00 00

	.page
	.sbttl	Modes of INH1 Instructions

	.adl
	ccf			; 3F
	ccf.s			;q
	ccf.l			;q

	.z80
	ccf			; 3F
	ccf.s			;q
	ccf.l			;q

	.page
	.sbttl	Modes of INH2 Instructions

	.adl
	cpd			; ED A9
	cpd.s			; 52 ED A9
	cpd.l			;a

	.z80
	cpd			; ED A9
	cpd.s			;a
	cpd.l			; 49 ED A9

	; Exceptions for INH2 Instructions

	.adl
	reti			; ED 4D
	reti.s			;q
	reti.l			; 5B ED 4D
	retn			; ED 45
	retn.s			;q
	retn.l			; 5B ED 45
	slp			; ED 76
	slp.s			;q
	slp.l			;q

	.z80
	reti			; ED 4D
	reti.s			;q
	reti.l			; 49 ED 4D
	retn			; ED 45
	retn.s			;q
	retn.l			; 49 ED 45
	slp			; ED 76
	slp.s			;q
	slp.l			;q

	.page
	.sbttl	Modes Common to DEC and INC

	.adl
	dec	(hl)		; 35
	dec	ixh		; DD 25
	dec	ixl		; DD 2D
	dec	iyh		; FD 25
	dec	iyl		; FD 2D
	dec	ix		; DD 2B
	dec	iy		; FD 2B
	dec	(ix+var1)	; DD 35r10
	dec	(iy+var1)	; FD 35r10
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
	dec	sp		; 3B

	.z80
	dec	(hl)		; 35
	dec	ixh		; DD 25
	dec	ixl		; DD 2D
	dec	iyh		; FD 25
	dec	iyl		; FD 2D
	dec	ix		; DD 2B
	dec	iy		; FD 2B
	dec	(ix+var1)	; DD 35r10
	dec	(iy+var1)	; FD 35r10
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
	dec	sp		; 3B

	.page

	.adl
	dec.s	(hl)		; 52 35
	dec.s	ixh		;a
	dec.s	ixl		;a
	dec.s	iyh		;a
	dec.s	iyl		;a
	dec.s	ix		; 52 DD 2B
	dec.s	iy		; 52 FD 2B
	dec.s	(ix+var1)	; 52 DD 35r10
	dec.s	(iy+var1)	; 52 FD 35r10
	dec.s	a		;a
	dec.s	b		;a
	dec.s	c		;a
	dec.s	d		;a
	dec.s	e		;a
	dec.s	h		;a
	dec.s	l		;a
	dec.s	bc		; 52 0B
	dec.s	de		; 52 1B
	dec.s	hl		; 52 2B
	dec.s	sp		; 52 3B

	.z80
	dec.s	(hl)		;a
	dec.s	ixh		;a
	dec.s	ixl		;a
	dec.s	iyh		;a
	dec.s	iyl		;a
	dec.s	ix		;a
	dec.s	iy		;a
	dec.s	(ix+var1)	;a
	dec.s	(iy+var1)	;a
	dec.s	a		;a
	dec.s	b		;a
	dec.s	c		;a
	dec.s	d		;a
	dec.s	e		;a
	dec.s	h		;a
	dec.s	l		;a
	dec.s	bc		;a
	dec.s	de		;a
	dec.s	hl		;a
	dec.s	sp		;a

	.page

	.adl
	dec.l	(hl)		;a
	dec.l	ixh		;a
	dec.l	ixl		;a
	dec.l	iyh		;a
	dec.l	iyl		;a
	dec.l	ix		;a
	dec.l	iy		;a
	dec.l	(ix+var1)	;a
	dec.l	(iy+var1)	;a
	dec.l	a		;a
	dec.l	b		;a
	dec.l	c		;a
	dec.l	d		;a
	dec.l	e		;a
	dec.l	h		;a
	dec.l	l		;a
	dec.l	bc		;a
	dec.l	de		;a
	dec.l	hl		;a
	dec.l	sp		;a

	.z80
	dec.l	(hl)		; 49 35
	dec.l	ixh		;a
	dec.l	ixl		;a
	dec.l	iyh		;a
	dec.l	iyl		;a
	dec.l	ix		; 49 DD 2B
	dec.l	iy		; 49 FD 2B
	dec.l	(ix+var1)	; 49 DD 35r10
	dec.l	(iy+var1)	; 49 FD 35r10
	dec.l	a		;a
	dec.l	b		;a
	dec.l	c		;a
	dec.l	d		;a
	dec.l	e		;a
	dec.l	h		;a
	dec.l	l		;a
	dec.l	bc		; 49 0B
	dec.l	de		; 49 1B
	dec.l	hl		; 49 2B
	dec.l	sp		; 49 3B

	.page
	.sbttl	Modes of EX

	.adl
	ex	af,af'		; 08
	ex	de,hl		; EB
	ex	(sp),hl		; E3
	ex	(sp),ix		; DD E3
	ex	(sp),iy		; FD E3
	ex.s	af,af'		;a
	ex.s	de,hl		;a
	ex.s	(sp),hl		; 52 E3
	ex.s	(sp),ix		; 52 DD E3
	ex.s	(sp),iy		; 52 FD E3
	ex.l	af,af'		;a
	ex.l	de,hl		;a
	ex.l	(sp),hl		;a
	ex.l	(sp),ix		;a
	ex.l	(sp),iy		;a

	.z80
	ex	af,af'		; 08
	ex	de,hl		; EB
	ex	(sp),hl		; E3
	ex	(sp),ix		; DD E3
	ex	(sp),iy		; FD E3
	ex.s	af,af'		;a
	ex.s	de,hl		;a
	ex.s	(sp),hl		;a
	ex.s	(sp),ix		;a
	ex.s	(sp),iy		;a
	ex.l	af,af'		;a
	ex.l	de,hl		;a
	ex.l	(sp),hl		; 49 E3
	ex.l	(sp),ix		; 49 DD E3
	ex.l	(sp),iy		; 49 FD E3

	.page
	.sbttl	Modes for JP

	.adl
	jp	nz,var2		; C2 20 00 00
	jp.s	nz,var2		;a
	jp.l	nz,var2		;a
	jp.sis	nz,var2		; 40 C2 20 00
	jp.lil	nz,var2		; 5B C2 20 00 00

	jp	var2		; C3 20 00 00
	jp.s	var2		;a
	jp.l	var2		;a
	jp.sis	var2		; 40 C3 20 00
	jp.lil	var2		; 5B C3 20 00 00

	jp	(hl)		; E9
	jp.s	(hl)		; 52 E9
	jp.l	(hl)		; 49 e9
	jp.sis	(hl)		; 40 e9
	jp.lil	(hl)		; 49 e9

	jp	(ix)		; DD E9
	jp.s	(ix)		; 40 DD E9
	jp.l	(ix)		; 5B DD E9
	jp.sis	(ix)		; 40 DD E9
	jp.lil	(ix)		; 5B DD E9

	jp	(iy)		; FD E9
	jp.s	(iy)		; 40 FD E9
	jp.l	(iy)		; 5B FD E9
	jp.sis	(iy)		; 40 FD E9
	jp.lil	(iy)		; 5B FD E9

	.z80
	jp	nz,var2		; C2 20 00
	jp.s	nz,var2		;a
	jp.l	nz,var2		;a
	jp.sis	nz,var2		; 40 C2 20 00
	jp.lil	nz,var2		; 5B C2 20 00 00

	jp	var2		; C3 20 00
	jp.s	var2		;a
	jp.l	var2		;a
	jp.sis	var2		; 40 C3 20 00
	jp.lil	var2		; 5B C3 20 00 00

	jp	(hl)		; E9
	jp.s	(hl)		; 52 E9
	jp.l	(hl)		; 49 e9
	jp.sis	(hl)		;a
	jp.lil	(hl)		;a

	jp	(ix)		; DD E9
	jp.s	(ix)		; 40 DD E9
	jp.l	(ix)		; 5B DD E9
	jp.sis	(ix)		;a
	jp.lil	(ix)		;a

	jp	(iy)		; FD E9
	jp.s	(iy)		; 40 FD E9
	jp.l	(iy)		; 5B FD E9
	jp.sis	(iy)		;a
	jp.lil	(iy)		;a

	.page
	.sbttl	Modes for LD

	.adl
	ld	a,i		; ED 57
	ld	a,(ix+19)	; DD 7E 19
	ld	a,(iy+19)	; FD 7E 19
	ld	a,mb		; ED 6E
	ld	a,(var2)	; 3A 20 00 00
	ld	a,r		; ED 5F
	ld	a,(bc)		; 0A
	ld	a,(de)		; 1A
	ld	a,(hl)		; 7E

	ld.s	a,i		;a
	ld.s	a,(iy+var1)	; 52 FD 7Er10
	ld.s	a,(ix+var1)	; 52 DD 7Er10
	ld.s	a,mb		;a
	ld.s	a,(var2)	;a
	ld.s	a,r		;a
	ld.s	a,(bc)		; 52 0A
	ld.s	a,(de)		; 52 1A
	ld.s	a,(hl)		; 52 7E

	ld.l	a,i		;a
	ld.l	a,(ix+var2)	;a
	ld.l	a,(iy+var2)	;a
	ld.l	a,mb		;a
	ld.l	a,(var1)	;a
	ld.l	a,r		;a
	ld.l	a,(bc)		;a
	ld.l	a,(de)		;a
	ld.l	a,(hl)		;a

	.page
 
	ld.is	a,i		;a
	ld.is	a,(iy+var1)	;a
	ld.is	a,(ix+var1)	;a
	ld.is	a,mb		;a
	ld.is	a,(var2)	;a
	ld.is	a,r		;a
	ld.is	a,(bc)		; 52 0A
	ld.is	a,(de)		; 52 1A
	ld.is	a,(hl)		; 52 7E

	ld.il	a,i		;a
	ld.il	a,(ix+var2)	;a
	ld.il	a,(iy+var2)	;a
	ld.il	a,mb		;a
	ld.il	a,(var1)	;a
	ld.il	a,r		;a
	ld.il	a,(bc)		;a
	ld.il	a,(de)		;a
	ld.il	a,(hl)		;a
 
	ld.sis	a,i		;a
	ld.sis	a,(iy+var1)	;a
	ld.sis	a,(ix+var1)	;a
	ld.sis	a,mb		;a
	ld.sis	a,(var2)	; 40 3A 20 00
	ld.sis	a,r		;a
	ld.sis	a,(bc)		;a
	ld.sis	a,(de)		;a
	ld.sis	a,(hl)		;a

	ld.lil	a,i		;a
	ld.lil	a,(ix+var2)	;a
	ld.lil	a,(iy+var2)	;a
	ld.lil	a,mb		;a
	ld.lil	a,(var1)	;a
	ld.lil	a,r		;a
	ld.lil	a,(bc)		;a
	ld.lil	a,(de)		;a
	ld.lil	a,(hl)		;a
 
	.page

	.z80
	ld	a,i		; ED 57
	ld	a,(ix+19)	; DD 7E 19
	ld	a,(iy+19)	; FD 7E 19
	ld	a,mb		; ED 6E
	ld	a,(var2)	; 3A 20 00
	ld	a,r		; ED 5F
	ld	a,(bc)		; 0A
	ld	a,(de)		; 1A
	ld	a,(hl)		; 7E

	ld.s	a,i		;a
	ld.s	a,(iy+var1)	;a
	ld.s	a,(ix+var1)	;a
	ld.s	a,mb		;a
	ld.s	a,(var2)	;a
	ld.s	a,r		;a
	ld.s	a,(bc)		;a
	ld.s	a,(de)		;a
	ld.s	a,(hl)		;a

	ld.l	a,i		;a
	ld.l	a,(ix+var2)	; 49 DD 7E 20
	ld.l	a,(iy+var2)	; 49 FD 7E 20
	ld.l	a,mb		;a
	ld.l	a,(var1)	;a
	ld.l	a,r		;a
	ld.l	a,(bc)		; 49 0A
	ld.l	a,(de)		; 49 1A
	ld.l	a,(hl)		; 49 7E

	.page

	ld.is	a,i		;a
	ld.is	a,(iy+var1)	;a
	ld.is	a,(ix+var1)	;a
	ld.is	a,mb		;a
	ld.is	a,(var2)	;a
	ld.is	a,r		;a
	ld.is	a,(bc)		;a
	ld.is	a,(de)		;a
	ld.is	a,(hl)		;a

	ld.il	a,i		;a
	ld.il	a,(ix+var2)	;a
	ld.il	a,(iy+var2)	;a
	ld.il	a,mb		;a
	ld.il	a,(var1)	;a
	ld.il	a,r		;a
	ld.il	a,(bc)		;a
	ld.il	a,(de)		;a
	ld.il	a,(hl)		;a
 
	ld.sis	a,i		;a
	ld.sis	a,(iy+var1)	;a
	ld.sis	a,(ix+var1)	;a
	ld.sis	a,mb		;a
	ld.sis	a,(var2)	;a
	ld.sis	a,r		;a
	ld.sis	a,(bc)		;a
	ld.sis	a,(de)		;a
	ld.sis	a,(hl)		;a

	ld.lil	a,i		;a
	ld.lil	a,(ix+var2)	;a
	ld.lil	a,(iy+var2)	;a
	ld.lil	a,mb		;a
	ld.lil	a,(var1)	; 5B 3Ar10s00R00
	ld.lil	a,r		;a
	ld.lil	a,(bc)		;a
	ld.lil	a,(de)		;a
	ld.lil	a,(hl)		;a
 
	.page

	.adl
	ld	hl,i		; ED D7
	ld	i,hl		; ED C7
	ld	i,a		; ED 47
	ld	(hl),a		; 77
	ld	(hl),bc		; ED 0F
	ld	(hl),ix		; ED 3F
	ld	(hl),iy		; ED 3E
	ld	(hl),var1	; 36r10

	ld.s	hl,i		;a
	ld.s	i,hl		;a
	ld.s	i,a		;a
	ld.s	(hl),a		; 52 77
	ld.s	(hl),bc		; 52 ED 0F
	ld.s	(hl),ix		; 52 ED 3F
	ld.s	(hl),iy		; 52 ED 3E
	ld.s	(hl),var2	; 52 36 20

	ld.l	hl,i		;a
	ld.l	i,hl		;a
	ld.l	i,a		;a
	ld.l	(hl),a		;a
	ld.l	(hl),bc		;a
	ld.l	(hl),ix		;a
	ld.l	(hl),iy		;a
	ld.l	(hl),19		;a

	.page

	ld.is	hl,i		;a
	ld.is	i,hl		;a
	ld.is	i,a		;a
	ld.is	(hl),a		;a
	ld.is	(hl),bc		;a
	ld.is	(hl),ix		;a
	ld.is	(hl),iy		;a
	ld.is	(hl),var2	;a

	ld.il	hl,i		;a
	ld.il	i,hl		;a
	ld.il	i,a		;a
	ld.il	(hl),a		;a
	ld.il	(hl),bc		;a
	ld.il	(hl),ix		;a
	ld.il	(hl),iy		;a
	ld.il	(hl),19		;a

	ld.sis	hl,i		;a
	ld.sis	i,hl		;a
	ld.sis	i,a		;a
	ld.sis	(hl),a		;a
	ld.sis	(hl),bc		;a
	ld.sis	(hl),ix		;a
	ld.sis	(hl),iy		;a
	ld.sis	(hl),var2	;a

	ld.lil	hl,i		;a
	ld.lil	i,hl		;a
	ld.lil	i,a		;a
	ld.lil	(hl),a		;a
	ld.lil	(hl),bc		;a
	ld.lil	(hl),ix		;a
	ld.lil	(hl),iy		;a
	ld.lil	(hl),19		;a

	.page

	.z80
	ld	hl,i		; ED D7
	ld	i,hl		; ED C7
	ld	i,a		; ED 47
	ld	(hl),a		; 77
	ld	(hl),bc		; ED 0F
	ld	(hl),ix		; ED 3F
	ld	(hl),iy		; ED 3E
	ld	(hl),var1	; 36r10

	ld.s	hl,i		;a
	ld.s	i,hl		;a
	ld.s	i,a		;a
	ld.s	(hl),a		;a
	ld.s	(hl),bc		;a
	ld.s	(hl),ix		;a
	ld.s	(hl),iy		;a
	ld.s	(hl),var2	;a

	ld.l	hl,i		; ED D7
	ld.l	i,hl		; ED C7
	ld.l	i,a		; ED 47
	ld.l	(hl),a		; 49 77
	ld.l	(hl),bc		; 49 ED 0F
	ld.l	(hl),ix		; 49 ED 3F
	ld.l	(hl),iy		; 49 ED 3E
	ld.l	(hl),19		; 49 36 19

	.page

	ld.is	hl,i		;a
	ld.is	i,hl		;a
	ld.is	i,a		;a
	ld.is	(hl),a		;a
	ld.is	(hl),bc		;a
	ld.is	(hl),ix		;a
	ld.is	(hl),iy		;a
	ld.is	(hl),var2	;a

	ld.il	hl,i		;a
	ld.il	i,hl		;a
	ld.il	i,a		;a
	ld.il	(hl),a		;a
	ld.il	(hl),bc		;a
	ld.il	(hl),ix		;a
	ld.il	(hl),iy		;a
	ld.il	(hl),19		;a

	ld.sis	hl,i		;a
	ld.sis	i,hl		;a
	ld.sis	i,a		;a
	ld.sis	(hl),a		;a
	ld.sis	(hl),bc		;a
	ld.sis	(hl),ix		;a
	ld.sis	(hl),iy		;a
	ld.sis	(hl),var2	;a

	ld.lil	hl,i		;a
	ld.lil	i,hl		;a
	ld.lil	i,a		;a
	ld.lil	(hl),a		;a
	ld.lil	(hl),bc		;a
	ld.lil	(hl),ix		;a
	ld.lil	(hl),iy		;a
	ld.lil	(hl),19		;a

	.page

	.adl
	ld	ixh,ixl		; DD 65
	ld	iyl,iyh		; FD 6C
	ld	ixl,var2	; DD 2E 20
	ld	iyl,var2	; FD 2E 20
	ld	ixh,a		; DD 67

	ld.s	ixh,ixl		;a
	ld.s	iyl,iyh		;a
	ld.s	ixl,var2	;a
	ld.s	iyl,var2	;a
	ld.s	ixh,a		;a

	ld.l	ixh,ixl		;a
	ld.l	iyl,iyh		;a
	ld.l	ixl,var2	;a
	ld.l	iyl,var2	;a
	ld.l	ixh,a		;a

	ld.is	ixh,ixl		;a
	ld.is	iyl,iyh		;a
	ld.is	ixl,var2	;a
	ld.is	iyl,var2	;a
	ld.is	ixh,a		;a

	ld.il	ixh,ixl		;a
	ld.il	iyl,iyh		;a
	ld.il	ixl,var2	;a
	ld.il	iyl,var2	;a
	ld.il	ixh,a		;a

	ld.sis	ixh,ixl		;a
	ld.sis	iyl,iyh		;a
	ld.sis	ixl,var2	;a
	ld.sis	iyl,var2	;a
	ld.sis	ixh,a		;a

	ld.lil	ixh,ixl		;a
	ld.lil	iyl,iyh		;a
	ld.lil	ixl,var2	;a
	ld.lil	iyl,var2	;a
	ld.lil	ixh,a		;a

	.page

	.z80
	ld	ixh,ixl		; DD 65
	ld	iyl,iyh		; FD 6C
	ld	ixl,var2	; DD 2E 20
	ld	iyl,var2	; FD 2E 20
	ld	ixh,a		; DD 67

	ld.s	ixh,ixl		;a
	ld.s	iyl,iyh		;a
	ld.s	ixl,var2	;a
	ld.s	iyl,var2	;a
	ld.s	ixh,a		;a

	ld.l	ixh,ixl		;a
	ld.l	iyl,iyh		;a
	ld.l	ixl,var2	;a
	ld.l	iyl,var2	;a
	ld.l	ixh,a		;a

	ld.is	ixh,ixl		;a
	ld.is	iyl,iyh		;a
	ld.is	ixl,var2	;a
	ld.is	iyl,var2	;a
	ld.is	ixh,a		;a

	ld.il	ixh,ixl		;a
	ld.il	iyl,iyh		;a
	ld.il	ixl,var2	;a
	ld.il	iyl,var2	;a
	ld.il	ixh,a		;a

	ld.sis	ixh,ixl		;a
	ld.sis	iyl,iyh		;a
	ld.sis	ixl,var2	;a
	ld.sis	iyl,var2	;a
	ld.sis	ixh,a		;a

	ld.lil	ixh,ixl		;a
	ld.lil	iyl,iyh		;a
	ld.lil	ixl,var2	;a
	ld.lil	iyl,var2	;a
	ld.lil	ixh,a		;a

	.page

	.adl
	ld	iy,var1		; FD 21r10s00R00
	ld	ix,(var2)	; DD 2A 20 00
	ld	iy,(hl)		; ED 31
	ld	ix,(hl)		; ED 37
	ld	iy,(ix+var1)	; DD 31r10
	ld	ix,(iy+var2)	; FD 31 20

	ld.s	iy,var1		;a
	ld.s	ix,(var2)	;a
	ld.s	iy,(hl)		; 52 ED 31
	ld.s	ix,(hl)		; 52 ED 37
	ld.s	iy,(ix+var1)	; 52 DD 31r10
	ld.s	ix,(iy+var2)	; 52 FD 31 20

	ld.l	iy,var1		;a
	ld.l	ix,(var2)	;a
	ld.l	iy,(hl)		;a
	ld.l	ix,(hl)		;a
	ld.l	iy,(ix+var1)	;a
	ld.l	ix,(iy+var2)	;a

	ld.is	iy,var1		;a
	ld.is	ix,(var2)	;a
	ld.is	iy,(hl)		;a
	ld.is	ix,(hl)		;a
	ld.is	iy,(ix+var1)	;a
	ld.is	ix,(iy+var2)	;a

	ld.il	iy,var1		;a
	ld.il	ix,(var2)	;a
	ld.il	iy,(hl)		;a
	ld.il	ix,(hl)		;a
	ld.il	iy,(ix+var1)	;a
	ld.il	ix,(iy+var2)	;a

	ld.sis	iy,var1		; 40 FD 21r10s00
	ld.sis	ix,(var2)	; 40 DD 2A 20 00
	ld.sis	iy,(hl)		;a
	ld.sis	ix,(hl)		;a
	ld.sis	iy,(ix+var1)	;a
	ld.sis	ix,(iy+var2)	;a

	ld.lil	iy,var1		;a
	ld.lil	ix,(var2)	;a
	ld.lil	iy,(hl)		;a
	ld.lil	ix,(hl)		;a
	ld.lil	iy,(ix+var1)	;a
	ld.lil	ix,(iy+var2)	;a

	.page

	.z80
	ld	iy,var1		; FD 21*10n00
	ld	ix,(var2)	; DD 2A 20 00
	ld	iy,(hl)		; ED 31
	ld	ix,(hl)		; ED 37
	ld	iy,(ix+var1)	; DD 31r10
	ld	ix,(iy+var2)	; FD 31 20

	ld.s	iy,var1		;a
	ld.s	ix,(var2)	;a
	ld.s	iy,(hl)		;a
	ld.s	ix,(hl)		;a
	ld.s	iy,(ix+var1)	;a
	ld.s	ix,(iy+var2)	;a

	ld.l	iy,var1		;a
	ld.l	ix,(var2)	;a
	ld.l	iy,(hl)		; 49 ED 31
	ld.l	ix,(hl)		; 49 ED 37
	ld.l	iy,(ix+var1)	; 49 DD 31r10
	ld.l	ix,(iy+var2)	; 49 FD 31 20

	ld.is	iy,var1		;a
	ld.is	ix,(var2)	;a
	ld.is	iy,(hl)		;a
	ld.is	ix,(hl)		;a
	ld.is	iy,(ix+var1)	;a
	ld.is	ix,(iy+var2)	;a

	ld.il	iy,var1		;a
	ld.il	ix,(var2)	;a
	ld.il	iy,(hl)		;a
	ld.il	ix,(hl)		;a
	ld.il	iy,(ix+var1)	;a
	ld.il	ix,(iy+var2)	;a

	ld.sis	iy,var1		;a
	ld.sis	ix,(var2)	;a
	ld.sis	iy,(hl)		;a
	ld.sis	ix,(hl)		;a
	ld.sis	iy,(ix+var1)	;a
	ld.sis	ix,(iy+var2)	;a

	ld.lil	iy,var1		; 5B FD 21r10s00R00
	ld.lil	ix,(var2)	; 5B DD 2A 20 00 00
	ld.lil	iy,(hl)		;a
	ld.lil	ix,(hl)		;a
	ld.lil	iy,(ix+var1)	;a
	ld.lil	ix,(iy+var2)	;a

	.page

	.adl
	ld	(iy+var1),a	; FD 77r10
	ld	(ix+var1),iy	; DD 3Er10
	ld	(iy+var1),#var1	; FD 36r10r10
	ld	(ix+var1),bc	; DD 0Fr10

	ld.s	(iy+var1),a	; 52 FD 77r10
	ld.s	(ix+var1),iy	; 52 DD 3Er10
	ld.s	(iy+var1),#var1	; 52 FD 36r10r10
	ld.s	(ix+var1),bc	; 52 DD 0Fr10

	ld.l	(iy+var1),a	;a
	ld.l	(ix+var1),iy	;a
	ld.l	(iy+var1),#var1	;a
	ld.l	(ix+var1),bc	;a

	ld.is	(iy+var1),a	;a
	ld.is	(ix+var1),iy	;a
	ld.is	(iy+var1),#var1	;a
	ld.is	(ix+var1),bc	;a

	ld.il	(iy+var1),a	;a
	ld.il	(ix+var1),iy	;a
	ld.il	(iy+var1),#var1	;a
	ld.il	(ix+var1),bc	;a

	ld.sis	(iy+var1),a	;a
	ld.sis	(ix+var1),iy	;a
	ld.sis	(iy+var1),#var1	;a
	ld.sis	(ix+var1),bc	;a

	ld.lil	(iy+var1),a	;a
	ld.lil	(ix+var1),iy	;a
	ld.lil	(iy+var1),#var1	;a
	ld.lil	(ix+var1),bc	;a

	.page

	.z80
	ld	(iy+var1),a	; FD 77r10
	ld	(ix+var1),iy	; DD 3Er10
	ld	(iy+var1),#var1	; FD 36r10r10
	ld	(ix+var1),bc	; DD 0Fr10

	ld.s	(iy+var1),a	; FD 77r10
	ld.s	(ix+var1),iy	; DD 3Er10
	ld.s	(iy+var1),#var1	; FD 36r10r10s00
	ld.s	(ix+var1),bc	; DD 0Fr10

	ld.l	(iy+var1),a	; 49 FD 77r10
	ld.l	(ix+var1),iy	; 49 DD 3Er10
	ld.l	(iy+var1),#var1	; 49 FD 36r10r10
	ld.l	(ix+var1),bc	; 49 DD 0Fr10

	ld.is	(iy+var1),a	;a
	ld.is	(ix+var1),iy	;a
	ld.is	(iy+var1),#var1	;a
	ld.is	(ix+var1),bc	;a

	ld.il	(iy+var1),a	;a
	ld.il	(ix+var1),iy	;a
	ld.il	(iy+var1),#var1	;a
	ld.il	(ix+var1),bc	;a

	ld.sis	(iy+var1),a	;a
	ld.sis	(ix+var1),iy	;a
	ld.sis	(iy+var1),#var1	;a
	ld.sis	(ix+var1),bc	;a

	ld.lil	(iy+var1),a	;a
	ld.lil	(ix+var1),iy	;a
	ld.lil	(iy+var1),#var1	;a
	ld.lil	(ix+var1),bc	;a

	.page

	.adl
	ld	a,ixl		; DD 7D
	ld	mb,a		; ED 6D
	ld	r,a		; ED 4F
	ld	(var1),a	; 32r10s00R00
	ld	(var1),iy	; FD 22r10s00R00
	ld	(var1),bc	; ED 43r10s00R00

	ld.s	a,ixl		;a
	ld.s	mb,a		;a
	ld.s	r,a		;a
	ld.s	(var1),a	;a
	ld.s	(var1),iy	;a
	ld.s	(var1),bc	;a

	ld.l	a,ixl		;a
	ld.l	mb,a		;a
	ld.l	r,a		;a
	ld.l	(var1),a	;a
	ld.l	(var1),iy	;a
	ld.l	(var1),bc	;a

	ld.is	a,ixl		;a
	ld.is	mb,a		;a
	ld.is	r,a		;a
	ld.is	(var1),a	; 40 32r10s00
	ld.is	(var1),iy	;a
	ld.is	(var1),bc	;a

	ld.il	a,ixl		;a
	ld.il	mb,a		;a
	ld.il	r,a		;a
	ld.il	(var1),a	;a
	ld.il	(var1),iy	;a
	ld.il	(var1),bc	;a

	ld.sis	a,ixl		;a
	ld.sis	mb,a		;a
	ld.sis	r,a		;a
	ld.sis	(var1),a	;a
	ld.sis	(var1),iy	; 40 FD 22r10s00
	ld.sis	(var1),bc	; 40 ED 43r10s00

	ld.lil	a,ixl		;a
	ld.lil	mb,a		;a
	ld.lil	r,a		;a
	ld.lil	(var1),a	;a
	ld.lil	(var1),iy	;a
	ld.lil	(var1),bc	;a

	.page

	.z80
	ld	a,ixl		; DD 7D
	ld	mb,a		; ED 6D
	ld	r,a		; ED 4F
	ld	(var1),a	; 32*10n00
	ld	(var1),iy	; FD 22*10n00
	ld	(var1),bc	; ED 43*10n00

	ld.s	a,ixl		;a
	ld.s	mb,a		;a
	ld.s	r,a		;a
	ld.s	(var1),a	;a
	ld.s	(var1),iy	;a
	ld.s	(var1),bc	;a

	ld.l	a,ixl		;a
	ld.l	mb,a		;a
	ld.l	r,a		;a
	ld.l	(var1),a	;a
	ld.l	(var1),iy	;a
	ld.l	(var1),bc	;a

	ld.is	a,ixl		;a
	ld.is	mb,a		;a
	ld.is	r,a		;a
	ld.is	(var1),a	;a
	ld.is	(var1),iy	;a
	ld.is	(var1),bc	;a

	ld.il	a,ixl		;a
	ld.il	mb,a		;a
	ld.il	r,a		;a
	ld.il	(var1),a	; 5B 32r10s00R00
	ld.il	(var1),iy	;a
	ld.il	(var1),bc	;a

	ld.sis	a,ixl		;a
	ld.sis	mb,a		;a
	ld.sis	r,a		;a
	ld.sis	(var1),a	;a
	ld.sis	(var1),iy	;a
	ld.sis	(var1),bc	;a

	ld.lil	a,ixl		;a
	ld.lil	mb,a		;a
	ld.lil	r,a		;a
	ld.lil	(var1),a	;a
	ld.lil	(var1),iy	; 5B FD 22r10s00R00
	ld.lil	(var1),bc	; 5B ED 43r10s00R00

	.page

	.adl
	ld	a,a		; 7F
	ld	b,b		;a
	ld	c,c		;a
	ld	d,d		;a
	ld	e,e		;a

	ld.s	a,a		;a
	ld.s	b,b		;a
	ld.s	c,c		;a
	ld.s	d,d		;a
	ld.s	e,e		;a

	ld.l	a,a		;a
	ld.l	b,b		;a
	ld.l	c,c		;a
	ld.l	d,d		;a
	ld.l	e,e		;a

	ld.is	a,a		;a
	ld.is	b,b		;a
	ld.is	c,c		;a
	ld.is	d,d		;a
	ld.is	e,e		;a

	ld.il	a,a		;a
	ld.il	b,b		;a
	ld.il	c,c		;a
	ld.il	d,d		;a
	ld.il	e,e		;a

	ld.sis	a,a		;a
	ld.sis	b,b		;a
	ld.sis	c,c		;a
	ld.sis	d,d		;a
	ld.sis	e,e		;a

	ld.lil	a,a		;a
	ld.lil	b,b		;a
	ld.lil	c,c		;a
	ld.lil	d,d		;a
	ld.lil	e,e		;a

	.page

	.z80
	ld	a,a		; 7F
	ld	b,b		; 40
	ld	c,c		; 49
	ld	d,d		; 52
	ld	e,e		; 5B

	ld.s	a,a		; 7F
	ld.s	b,b		; 40
	ld.s	c,c		; 49
	ld.s	d,d		; 52
	ld.s	e,e		; 5B

	ld.l	a,a		; 7F
	ld.l	b,b		; 40
	ld.l	c,c		; 49
	ld.l	d,d		; 52
	ld.l	e,e		; 5B

	ld.is	a,a		; 7F
	ld.is	b,b		; 40
	ld.is	c,c		; 49
	ld.is	d,d		; 52
	ld.is	e,e		; 5B

	ld.il	a,a		; 7F
	ld.il	b,b		; 40
	ld.il	c,c		; 49
	ld.il	d,d		; 52
	ld.il	e,e		; 5B

	ld.sis	a,a		; 7F
	ld.sis	b,b		; 40
	ld.sis	c,c		; 49
	ld.sis	d,d		; 52
	ld.sis	e,e		; 5B

	ld.lil	a,a		; 7F
	ld.lil	b,b		; 40
	ld.lil	c,c		; 49
	ld.lil	d,d		; 52
	ld.lil	e,e		; 5B

	.page

	.adl
	ld	bc,var1		; 01r10s00R00
	ld	bc,(hl)		; ED 07
	ld	de,(ix+var1)	; DD 17r10
	ld	hl,(var1)	; 2Ar10s00R00

	ld.s	bc,var1		;a
	ld.s	bc,(hl)		; 52 ED 07
	ld.s	de,(ix+var2)	; 52 DD 17 20
	ld.s	hl,(var2)	;a

	ld.l	bc,var1		;a
	ld.l	bc,(hl)		;a
	ld.l	de,(ix+var1)	;a
	ld.l	hl,(var1)	;a

	ld.is	bc,var1		;a
	ld.is	bc,(hl)		;a
	ld.is	de,(ix+var2)	;a
	ld.is	hl,(var2)	;a

	ld.il	bc,var1		;a
	ld.il	bc,(hl)		;a
	ld.il	de,(ix+var1)	;a
	ld.il	hl,(var1)	;a

	ld.sis	bc,var1		; 40 01r10s00
	ld.sis	bc,(hl)		;a
	ld.sis	de,(ix+var2)	;a
	ld.sis	hl,(var2)	; 40 2A 20 00

	ld.lil	bc,var1		;a
	ld.lil	bc,(hl)		;a
	ld.lil	de,(ix+var1)	;a
	ld.lil	hl,(var1)	;a

	.page

	.z80
	ld	bc,var1		; 01*10n00
	ld	bc,(hl)		; ED 07
	ld	de,(ix+var1)	; DD 17r10
	ld	hl,(var1)	; 2A*10n00

	ld.s	bc,var1		;a
	ld.s	bc,(hl)		;a
	ld.s	de,(ix+var2)	;a
	ld.s	hl,(var2)	;a

	ld.l	bc,var1		;a
	ld.l	bc,(hl)		; 49 ED 07
	ld.l	de,(ix+var1)	; 49 DD 17r10
	ld.l	hl,(var1)	;a

	ld.is	bc,var1		;a
	ld.is	bc,(hl)		;a
	ld.is	de,(ix+var2)	;a
	ld.is	hl,(var2)	;a

	ld.il	bc,var1		;a
	ld.il	bc,(hl)		;a
	ld.il	de,(ix+var1)	;a
	ld.il	hl,(var1)	;a

	ld.sis	bc,var1		;a
	ld.sis	bc,(hl)		;a
	ld.sis	de,(ix+var2)	;a
	ld.sis	hl,(var2)	;a

	ld.lil	bc,var1		; 5B 01r10s00R00
	ld.lil	bc,(hl)		;a
	ld.lil	de,(ix+var1)	;a
	ld.lil	hl,(var1)	; 5B 2Ar10s00R00

	.page
	
	.adl
	ld	(bc),a		; 02
	ld.s	(bc),a		; 52 02
	ld.l	(bc),a		;a
	ld.is	(bc),a		;a
	ld.il	(bc),a		;a
	ld.sis	(bc),a		;a
	ld.lil	(bc),a		;a

	.z80
	ld	(bc),a		; 02
	ld.s	(bc),a		;a
	ld.l	(bc),a		; 49 02
	ld.is	(bc),a		;a
	ld.il	(bc),a		;a
	ld.sis	(bc),a		;a
	ld.lil	(bc),a		;a

	.page

	.adl
	ld	sp,bc		;a
	ld	sp,hl		; F9
	ld	sp,ix		; DD F9
	ld	sp,iy		; FD F9
	ld	sp,var1		; 31r10s00R00
	ld	sp,(var1)	; ED 7Br10s00R00

	ld.s	sp,bc		;a
	ld.s	sp,hl		; 52 F9
	ld.s	sp,ix		; 52 DD F9
	ld.s	sp,iy		; 52 FD F9
	ld.s	sp,var1		;a
	ld.s	sp,(var1)	;a

	ld.l	sp,bc		;a
	ld.l	sp,hl		;a
	ld.l	sp,ix		;a
	ld.l	sp,iy		;a
	ld.l	sp,var1		;a
	ld.l	sp,(var1)	;a

	ld.is	sp,bc		;a
	ld.is	sp,hl		;a
	ld.is	sp,ix		;a
	ld.is	sp,iy		;a
	ld.is	sp,var1		;a
	ld.is	sp,(var1)	;a

	ld.il	sp,bc		;a
	ld.il	sp,hl		;a
	ld.il	sp,ix		;a
	ld.il	sp,iy		;a
	ld.il	sp,var1		;a
	ld.il	sp,(var1)	;a

	ld.sis	sp,bc		;a
	ld.sis	sp,hl		;a
	ld.sis	sp,ix		;a
	ld.sis	sp,iy		;a
	ld.sis	sp,var1		; 40 31r10s00
	ld.sis	sp,(var1)	; 40 ED 7Br10s00

	ld.lil	sp,bc		;a
	ld.lil	sp,hl		;a
	ld.lil	sp,ix		;a
	ld.lil	sp,iy		;a
	ld.lil	sp,var1		;a
	ld.lil	sp,(var1)	;a

	.z80
	ld	sp,bc		;a
	ld	sp,hl		; F9
	ld	sp,ix		; DD F9
	ld	sp,iy		; FD F9
	ld	sp,var1		; 31*10n00
	ld	sp,(var1)	; ED 7B*10n00

	ld.s	sp,bc		;a
	ld.s	sp,hl		;a
	ld.s	sp,ix		;a
	ld.s	sp,iy		;a
	ld.s	sp,var1		;a
	ld.s	sp,(var1)	;a

	ld.l	sp,bc		;a
	ld.l	sp,hl		; 49 F9
	ld.l	sp,ix		; 49 DD F9
	ld.l	sp,iy		; 49 FD F9
	ld.l	sp,var1		;a
	ld.l	sp,(var1)	;a

	ld.is	sp,bc		;a
	ld.is	sp,hl		;a
	ld.is	sp,ix		;a
	ld.is	sp,iy		;a
	ld.is	sp,var1		;a
	ld.is	sp,(var1)	;a

	ld.il	sp,bc		;a
	ld.il	sp,hl		;a
	ld.il	sp,ix		;a
	ld.il	sp,iy		;a
	ld.il	sp,var1		;a
	ld.il	sp,(var1)	;a

	ld.sis	sp,bc		;a
	ld.sis	sp,hl		;a
	ld.sis	sp,ix		;a
	ld.sis	sp,iy		;a
	ld.sis	sp,var1		;a
	ld.sis	sp,(var1)	;a

	ld.lil	sp,bc		;a
	ld.lil	sp,hl		;a
	ld.lil	sp,ix		;a
	ld.lil	sp,iy		;a
	ld.lil	sp,var1		; 5B 31r10s00R00
	ld.lil	sp,(var1)	; 5B ED 7Br10s00R00

	.page
	.sbttl	Modes for LEA

	.adl
	lea	bc,ix+19	; ED 02 19
	lea	de,ix+var1	; ED 12r10
	lea	hl,ix+var2	; ED 22 20
	lea	ix,ix+var1	; ED 32r10
	lea	iy,ix+var2	; ED 55 20

	lea	bc,iy+19	; ED 03 19
	lea	de,iy+var1	; ED 13r10
	lea	hl,iy+var2	; ED 23 20
	lea	ix,iy+var1	; ED 54r10
	lea	iy,iy+var2	; ED 33 20

	lea.s	bc,ix+19	; 52 ED 02 19
	lea.s	de,ix+var1	; 52 ED 12r10
	lea.s	hl,ix+var2	; 52 ED 22 20
	lea.s	ix,ix+var1	; 52 ED 32r10
	lea.s	iy,ix+var2	; 52 ED 55 20

	lea.s	bc,iy+19	; 52 ED 03 19
	lea.s	de,iy+var1	; 52 ED 13r10
	lea.s	hl,iy+var2	; 52 ED 23 20
	lea.s	ix,iy+var1	; 52 ED 54r10
	lea.s	iy,iy+var2	; 52 ED 33 20

	lea.l	bc,ix+19	;a
	lea.l	de,ix+var1	;a
	lea.l	hl,ix+var2	;a
	lea.l	ix,ix+var2	;a
	lea.l	iy,ix+var2	;a

	lea.l	bc,iy+19	;a
	lea.l	de,iy+var1	;a
	lea.l	hl,iy+var2	;a
	lea.l	ix,iy+var2	;a
	lea.l	iy,iy+var2	;a

	.page

	.z80
	lea	bc,ix+19	; ED 02 19
	lea	de,ix+var1	; ED 12r10
	lea	hl,ix+var2	; ED 22 20
	lea	ix,ix+var1	; ED 32r10
	lea	iy,ix+var2	; ED 55 20

	lea	bc,iy+19	; ED 03 19
	lea	de,iy+var1	; ED 13r10
	lea	hl,iy+var2	; ED 23 20
	lea	ix,iy+var1	; ED 54r10
	lea	iy,iy+var2	; ED 33 20

	lea.s	bc,ix+19	;a
	lea.s	de,ix+var1	;a
	lea.s	hl,ix+var2	;a
	lea.s	ix,ix+var1	;a
	lea.s	iy,ix+var2	;a

	lea.s	bc,iy+19	;a
	lea.s	de,iy+var1	;a
	lea.s	hl,iy+var2	;a
	lea.s	ix,iy+var1	;a
	lea.s	iy,iy+var2	;a

	lea.l	bc,ix+19	; 49 ED 02 19
	lea.l	de,ix+var1	; 49 ED 12r10
	lea.l	hl,ix+var2	; 49 ED 22 20
	lea.l	ix,ix+var2	; 49 ED 32 20
	lea.l	iy,ix+var2	; 49 ED 55 20

	lea.l	bc,iy+19	; 49 ED 03 19
	lea.l	de,iy+var1	; 49 ED 13r10
	lea.l	hl,iy+var2	; 49 ED 23 20
	lea.l	ix,iy+var2	; 49 ED 54 20
	lea.l	iy,iy+var2	; 49 ED 33 20

 	.page
	.sbttl	Modes for MLT

	.adl
	mlt	bc		; ED 4C
	mlt	de		; ED 5C
	mlt	hl		; ED 6C
	mlt	sp		; ED 7C
	mlt.s	bc		;a52 ED 4C
	mlt.s	de		;a52 ED 5C
	mlt.s	hl		;a52 ED 6C
	mlt.s	sp		; 52 ED 7C
	mlt.l	bc		;a
	mlt.l	de		;a
	mlt.l	hl		;a
	mlt.l	sp		;a
 
	.z80
	mlt	bc		; ED 4C
	mlt	de		; ED 5C
	mlt	hl		; ED 6C
	mlt	sp		; ED 7C
	mlt.s	bc		;a
	mlt.s	de		;a
	mlt.s	hl		;a
	mlt.s	sp		;a
	mlt.l	bc		;a
	mlt.l	de		;a
	mlt.l	hl		;a
	mlt.l	sp		; 49 ED 7C
 
	.page
	.sbttl	Modes for PEA

	.adl
	pea	ix+19		; ED 65 19
	pea.s	ix+var1		; 52 ED 65r10
	pea.l	ix+var2		;a
	pea	iy+19		; ED 66 19
	pea.s	iy+var1		; 52 ED 66r10
	pea.l	iy+var2		;a

	.z80
	pea	ix+19		; ED 65 19
	pea.s	ix+var1		;a
	pea.l	ix+var2		; 49 ED 65 20
	pea	iy+19		; ED 66 19
	pea.s	iy+var1		;a
	pea.l	iy+var2		; 49 ED 66 20
 	
	.page
	.sbttl	Modes for POP and PUSH

	.adl
	pop	af		; F1
	pop	bc		; C1
	pop	de		; D1
	pop	hl		; E1
	pop	ix		; DD E1
	pop	iy		; FD E1
	pop.s	af		; 52 F1
	pop.s	ix		; 52 DD E1
	pop.s	iy		; 52 FD E1
	pop.s	bc		; 52 C1
	pop.s	de		; 52 D1
	pop.s	hl		; 52 E1
	pop.l	af		;a
	pop.l	bc		;a
	pop.l	de		;a
	pop.l	hl		;a
	pop.l	ix		;a
	pop.l	iy		;a
 
	.z80
	pop	af		; F1
	pop	bc		; C1
	pop	de		; D1
	pop	hl		; E1
	pop	ix		; DD E1
	pop	iy		; FD E1
	pop.s	af		;a
	pop.s	ix		;a
	pop.s	iy		;a
	pop.s	bc		;a
	pop.s	de		;a
	pop.s	hl		;a
	pop.l	af		; 49 F1
	pop.l	bc		; 49 C1
	pop.l	de		; 49 D1
	pop.l	hl		; 49 E1
	pop.l	ix		; 49 DD E1
	pop.l	iy		; 49 FD E1
 
	.page
	.sbttl	Modes for RET

	.adl
	ret			; C9
	ret	nz		; C0
	ret.s			;q
	ret.s	nz		;q
	ret.l			; 5B C9
	ret.l	nz		; 5B C0

	.z80
	ret			; C9
	ret	nz		; C0
	ret.s			;q
	ret.s	nz		;q
	ret.l			; 49 C9
	ret.l	nz		; 49 C0
 
	.page
	.sbttl	Modes for RL, RLC, RR, RRC, SLA, SRA, and SRL

	.adl
	rl	a		; CB 17
	rl	b		; CB 10
	rl	c		; CB 11
	rl	d		; CB 12
	rl	e		; CB 13
	rl	h		; CB 14
	rl	l		; CB 15
	rl	(hl)		; CB 16
	rl	(ix+var2)	; DD CB 20 16
	rl	(iy+var2)	; FD CB 20 16
	rl.s	a		;a
	rl.s	b		;a
	rl.s	c		;a
	rl.s	d		;a
	rl.s	e		;a
	rl.s	h		;a
	rl.s	l		;a
	rl.s	(hl)		; 52 CB 16
	rl.s	(ix+19)		; 52 DD CB 19 16
	rl.s	(iy+19)		; 52 FD CB 19 16
	rl.l	a		;a
	rl.l	b		;a
	rl.l	c		;a
	rl.l	d		;a
	rl.l	e		;a
	rl.l	h		;a
	rl.l	l		;a
	rl.l	(hl)		;a
	rl.l	(ix+var1)	;a
	rl.l	(iy+var1)	;a

	.page
 
	.z80
	rl	a		; CB 17
	rl	b		; CB 10
	rl	c		; CB 11
	rl	d		; CB 12
	rl	e		; CB 13
	rl	h		; CB 14
	rl	l		; CB 15
	rl	(hl)		; CB 16
	rl	(ix+var2)	; DD CB 20 16
	rl	(iy+var2)	; FD CB 20 16
	rl.s	a		;a
	rl.s	b		;a
	rl.s	c		;a
	rl.s	d		;a
	rl.s	e		;a
	rl.s	h		;a
	rl.s	l		;a
	rl.s	(hl)		;a
	rl.s	(ix+19)		;a
	rl.s	(iy+19)		;a
	rl.l	a		;a
	rl.l	b		;a
	rl.l	c		;a
	rl.l	d		;a
	rl.l	e		;a
	rl.l	h		;a
	rl.l	l		;a
	rl.l	(hl)		; 49 CB 16
	rl.l	(ix+var1)	; 49 DD CBr10 16
	rl.l	(iy+var1)	; 49 FD CBr10 16
 
	.page
	.sbttl	Modes for RST

	.adl
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
	rst.l	00		;a
	rst.l	08		;a
	rst.l	10		;a
	rst.l	18		;a
	rst.l	20		;a
	rst.l	28		;a
	rst.l	30		;a
	rst.l	38		;a

	.z80
	rst	00		; C7
	rst	08		; CF
	rst	10		; D7
	rst	18		; DF
	rst	20		; E7
	rst	28		; EF
	rst	30		; F7
	rst	38		; FF
	rst.s	00		;a
	rst.s	08		;a
	rst.s	10		;a
	rst.s	18		;a
	rst.s	20		;a
	rst.s	28		;a
	rst.s	30		;a
	rst.s	38		;a
	rst.l	00		; 49 C7
	rst.l	08		; 49 CF
	rst.l	10		; 49 D7
	rst.l	18		; 49 DF
	rst.l	20		; 49 E7
	rst.l	28		; 49 EF
	rst.l	30		; 49 F7
	rst.l	38		; 49 FF

 	.page
	.sbttl	Modes for TST

	.adl
	tst	a,a		; ED 3C
	tst	a,b		; ED 04
	tst	a,c		; ED 0C
	tst	a,d		; ED 14
	tst	a,e		; ED 1C
	tst	a,h		; ED 24
	tst	a,l		; ED 2C
	tst	a,var2		; ED 64 20
	tst	a,(hl)		; ED 34

	tst.s	a,a		;a
	tst.s	a,b		;a
	tst.s	a,c		;a
	tst.s	a,d		;a
	tst.s	a,e		;a
	tst.s	a,h		;a
	tst.s	a,l		;a
	tst.s	a,var2		;a
	tst.s	a,(hl)		; 52 ED 34

	tst.l	a,a		;a
	tst.l	a,b		;a
	tst.l	a,c		;a
	tst.l	a,d		;a
	tst.l	a,e		;a
	tst.l	a,h		;a
	tst.l	a,l		;a
	tst.l	a,var2		;a

	; The following line has errata in
	; in manual codes (49,ed,73), the
	; codes listed here are correct

	tst.l	a,(hl)		;a

	.page

	.z80
	tst	a,a		; ED 3C
	tst	a,b		; ED 04
	tst	a,c		; ED 0C
	tst	a,d		; ED 14
	tst	a,e		; ED 1C
	tst	a,h		; ED 24
	tst	a,l		; ED 2C
	tst	a,var2		; ED 64 20
	tst	a,(hl)		; ED 34

	tst.s	a,a		;a
	tst.s	a,b		;a
	tst.s	a,c		;a
	tst.s	a,d		;a
	tst.s	a,e		;a
	tst.s	a,h		;a
	tst.s	a,l		;a
	tst.s	a,var2		;a
	tst.s	a,(hl)		;a

	tst.l	a,a		;a
	tst.l	a,b		;a
	tst.l	a,c		;a
	tst.l	a,d		;a
	tst.l	a,e		;a
	tst.l	a,h		;a
	tst.l	a,l		;a
	tst.l	a,var2		;a

	; The following line has errata in
	; in manual codes (49,ed,73), the
	; codes listed here are correct

	tst.l	a,(hl)		; 49 ED 34

