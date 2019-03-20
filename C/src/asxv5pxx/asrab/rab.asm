	.page
	;***********************************************************
	; 	Z80 / HD64180 / Rabbit 2K/3K
	;***********************************************************

	; notes:
	;	Leading 'a' operand is optional.
	;	If offset is ommitted 0 is assumed.

	;***********************************************************
	; add with carry to 'a'
z80$b	adc	a,(hl)			; 8E
z80$b	adc	a,offset(ix)		; DD 8E 33
z80$b	adc	a,offset(iy)		; FD 8E 33
z80$b	adc	a,(ix+offset)		; DD 8E 33
z80$b	adc	a,(iy+offset)		; FD 8E 33
z80$b	adc	a,a			; 8F
z80$b	adc	a,b			; 88
z80$b	adc	a,c			; 89
z80$b	adc	a,d			; 8A
z80$b	adc	a,e			; 8B
z80$b	adc	a,h			; 8C
z80$b	adc	a,l			; 8D
z80$b	adc	a,#n			; CE 20
z80$b	adc	a, n			; CE 20
	;***********************************************************
z80$b	adc	(hl)			; 8E
z80$b	adc	offset(ix)		; DD 8E 33
z80$b	adc	offset(iy)		; FD 8E 33
z80$b	adc	(ix+offset)		; DD 8E 33
z80$b	adc	(iy+offset)		; FD 8E 33
z80$b	adc	a			; 8F
z80$b	adc	b			; 88
z80$b	adc	c			; 89
z80$b	adc	d			; 8A
z80$b	adc	e			; 8B
z80$b	adc	h			; 8C
z80$b	adc	l			; 8D
z80$b	adc	#n			; CE 20
z80$b	adc	 n			; CE 20
	;***********************************************************
	; add with carry register pair to 'hl'
z80$b	adc	hl,bc			; ED 4A
z80$b	adc	hl,de			; ED 5A
z80$b	adc	hl,hl			; ED 6A
z80$b	adc	hl,sp			; ED 7A
	;***********************************************************
	; illegal constant values
	; representative add with carry opcodes
err$y	adc	a,(ix+128)		; DD 8E 80
err$n	adc	a,(ix+127)		; DD 8E 7F
err$n	adc	a,(ix+1)		; DD 8E 01
err$n	adc	a,(ix+0)		; DD 8E 00
err$n	adc	a,(ix-1)		; DD 8E FF
err$n	adc	a,(ix-128)		; DD 8E 80
err$y	adc	a,(ix-129)		; DD 8E 7F
	;***********************************************************
	; illegal addressing  modes
	; representative add with carry opcodes
err$y	adc	(hl+offset)		; 8E
err$y	adc	offset(hl)		; 8E
	;***********************************************************
err$y	adc	hl,ix			;
	;***********************************************************
err$y	adc	ix,bc			;
err$y	adc	iy,bc			;
	;***********************************************************
err$y	adc	sp,#n			;
err$y	adc	sp, n			;
	;***********************************************************
	; altd / ioe / ioi  modes
	; representative add with carry opcodes
alt$y	adc	a,(hl)			; 76 8E
ioe$y	adc	a,(hl)			; DB 8E
ioi$y	adc	a,(hl)			; D3 8E
	;***********************************************************
alt$y	adc	(hl)			; 76 8E
ioe$y	adc	(hl)			; DB 8E
ioi$y	adc	(hl)			; D3 8E
	;***********************************************************
alt$y	adc	a,c			; 76 89
ioe$n	adc	a,c			; DB 89
ioi$n	adc	a,c			; D3 89
	;***********************************************************
alt$y	adc	c			; 76 89
ioe$n	adc	c			; DB 89
ioi$n	adc	c			; D3 89
	;***********************************************************
alt$y	adc	a,#n			; 76 CE 20
ioe$n	adc	a,#n			; DB CE 20
ioi$n	adc	a,#n			; D3 CE 20
alt$y	adc	a, n			; 76 CE 20
ioe$n	adc	a, n			; DB CE 20
ioi$n	adc	a, n			; D3 CE 20
	;***********************************************************
alt$y	adc	#n			; 76 CE 20
ioe$n	adc	#n			; DB CE 20
ioi$n	adc	#n			; D3 CE 20
alt$y	adc	 n			; 76 CE 20
ioe$n	adc	 n			; DB CE 20
ioi$n	adc	 n			; D3 CE 20
	;***********************************************************
alt$y	adc	hl,bc			; 76 ED 4A
ioe$n	adc	hl,bc			; DB ED 4A
ioi$n	adc	hl,bc			; D3 ED 4A
	;***********************************************************
	; add operand to 'a'
z80$b	add	a,(hl)			; 86
z80$b	add	a,offset(ix)		; DD 86 33
z80$b	add	a,offset(iy)		; FD 86 33
z80$b	add	a,(ix+offset)		; DD 86 33
z80$b	add	a,(iy+offset)		; FD 86 33
z80$b	add	a,a			; 87
z80$b	add	a,b			; 80
z80$b	add	a,c			; 81
z80$b	add	a,d			; 82
z80$b	add	a,e			; 83
z80$b	add	a,h			; 84
z80$b	add	a,l			; 85
z80$b	add	a,#n			; C6 20
z80$b	add	a, n			; C6 20
	;***********************************************************
z80$b	add	(hl)			; 86
z80$b	add	offset(ix)		; DD 86 33
z80$b	add	offset(iy)		; FD 86 33
z80$b	add	(ix+offset)		; DD 86 33
z80$b	add	(iy+offset)		; FD 86 33
z80$b	add	a			; 87
z80$b	add	b			; 80
z80$b	add	c			; 81
z80$b	add	d			; 82
z80$b	add	e			; 83
z80$b	add	h			; 84
z80$b	add	l			; 85
z80$b	add	#n			; C6 20
z80$b	add	 n			; C6 20
	;***********************************************************
	; add register pair to 'hl'
z80$b	add	hl,bc			; 09
z80$b	add	hl,de			; 19
z80$b	add	hl,hl			; 29
z80$b	add	hl,sp			; 39
	;***********************************************************
	; add register pair to 'ix'
z80$b	add	ix,bc			; DD 09
z80$b	add	ix,de			; DD 19
z80$b	add	ix,ix			; DD 29
z80$b	add	ix,sp			; DD 39
	;***********************************************************
	; add operand to 'sp'
r$2k	add	sp,#n			; 27 20
r$2k	add	sp, n			; 27 20
	;***********************************************************
	; add register pair to 'iy'
z80$b	add	iy,bc			; FD 09
z80$b	add	iy,de			; FD 19
z80$b	add	iy,iy			; FD 29
z80$b	add	iy,sp			; FD 39
	;***********************************************************
	; illegal constant values
	; representative add opcodes
err$y	add	a,(ix+128)		; DD 86 80
err$n	add	a,(ix+127)		; DD 86 7F
err$n	add	a,(ix+1)		; DD 86 01
err$n	add	a,(ix+0)		; DD 86 00
err$n	add	a,(ix-1)		; DD 86 FF
err$n	add	a,(ix-128)		; DD 86 80
err$y	add	a,(ix-129)		; DD 86 7F
	;***********************************************************
	; illegal addressing  modes
	; representative add opcodes
err$y	add	(hl+offset)		; 86
err$y	add	offset(hl)		; 86
	;***********************************************************
err$y	add	hl,ix			;
	;***********************************************************
	; altd / ioe / ioi  modes
	; representative add opcodes
alt$y	add	a,(hl)			; 76 86
ioe$y	add	a,(hl)			; DB 86
ioi$y	add	a,(hl)			; D3 86
	;***********************************************************
alt$y	add	(hl)			; 76 86
ioe$y	add	(hl)			; DB 86
ioi$y	add	(hl)			; D3 86
	;***********************************************************
alt$y	add	a,c			; 76 81
ioe$n	add	a,c			; DB 81
ioi$n	add	a,c			; D3 81
	;***********************************************************
alt$y	add	c			; 76 81
ioe$n	add	c			; DB 81
ioi$n	add	c			; D3 81
	;***********************************************************
alt$y	add	a,#n			; 76 C6 20
ioe$n	add	a,#n			; DB C6 20
ioi$n	add	a,#n			; D3 C6 20
alt$y	add	a, n			; 76 C6 20
ioe$n	add	a, n			; DB C6 20
ioi$n	add	a, n			; D3 C6 20
	;***********************************************************
alt$y	add	#n			; 76 C6 20
ioe$n	add	#n			; DB C6 20
ioi$n	add	#n			; D3 C6 20
alt$y	add	 n			; 76 C6 20
ioe$n	add	 n			; DB C6 20
ioi$n	add	 n			; D3 C6 20
	;***********************************************************
alt$y	add	hl,bc			; 76 09
ioe$n	add	hl,bc			; DB 09
ioi$n	add	hl,bc			; D3 09
	;***********************************************************
alt$y	add	ix,bc			; 76 DD 09
ioe$n	add	ix,bc			; DB DD 09
ioi$n	add	ix,bc			; D3 DD 09
	;***********************************************************
alt$y	add	iy,bc			; 76 FD 09
ioe$n	add	iy,bc			; DB FD 09
ioi$n	add	iy,bc			; D3 FD 09
	;***********************************************************
alt$y	add	sp,#n			; 76 27 20
ioe$n	add	sp,#n			; DB 27 20
ioi$n	add	sp,#n			; D3 27 20
alt$y	add	sp, n			; 76 27 20
ioe$n	add	sp, n			; DB 27 20
ioi$n	add	sp, n			; D3 27 20
	;***********************************************************
	; logical 'and' operand with 'a'
z80$b	and	a,(hl)			; A6
z80$b	and	a,offset(ix)		; DD A6 33
z80$b	and	a,offset(iy)		; FD A6 33
z80$b	and	a,(ix+offset)		; DD A6 33
z80$b	and	a,(iy+offset)		; FD A6 33
z80$b	and	a,a			; A7
z80$b	and	a,b			; A0
z80$b	and	a,c			; A1
z80$b	and	a,d			; A2
z80$b	and	a,e			; A3
z80$b	and	a,h			; A4
z80$b	and	a,l			; A5
z80$b	and	a,#n			; E6 20
z80$b	and	a, n			; E6 20
	;***********************************************************
z80$b	and	(hl)			; A6
z80$b	and	offset(ix)		; DD A6 33
z80$b	and	offset(iy)		; FD A6 33
z80$b	and	(ix+offset)		; DD A6 33
z80$b	and	(iy+offset)		; FD A6 33
z80$b	and	a			; A7
z80$b	and	b			; A0
z80$b	and	c			; A1
z80$b	and	d			; A2
z80$b	and	e			; A3
z80$b	and	h			; A4
z80$b	and	l			; A5
z80$b	and	#n			; E6 20
z80$b	and	 n			; E6 20
	;***********************************************************
	; and the register 'de' to a register
r$2k	and	hl,de			; DC
r$2k	and	ix,de			; DD DC
r$2k	and	iy,de			; FD DC
	;***********************************************************
	; illegal constant values
	; representative and opcodes
err$y	and	a,(ix+128)		; DD 8A6 80
err$n	and	a,(ix+127)		; DD A6 7F
err$n	and	a,(ix+1)		; DD A6 01
err$n	and	a,(ix+0)		; DD A6 00
err$n	and	a,(ix-1)		; DD A6 FF
err$n	and	a,(ix-128)		; DD A6 80
err$y	and	a,(ix-129)		; DD A6 7F
	;***********************************************************
	; illegal addressing  modes
	; representative and opcodes
err$y	and	(hl+offset)		; A6
err$y	and	offset(hl)		; A6
	;***********************************************************
err$y	and	hl,ix			;
	;***********************************************************
err$y	and	hl,bc			;
err$y	and	ix,bc			;
err$y	and	iy,bc			;
	;***********************************************************
err$y	and	sp,de			;
	;***********************************************************
	; altd / ioe / ioi  modes
	; representative and opcodes
alt$y	and	a,(hl)			; 76 A6
ioe$y	and	a,(hl)			; DB A6
ioi$y	and	a,(hl)			; D3 A6
	;***********************************************************
alt$y	and	(hl)			; 76 A6
ioe$y	and	(hl)			; DB A6
ioi$y	and	(hl)			; D3 A6
	;***********************************************************
alt$y	and	a,c			; 76 A1
ioe$n	and	a,c			; DB A1
ioi$n	and	a,c			; D3 A1
	;***********************************************************
alt$y	and	c			; 76 A1
ioe$n	and	c			; DB A1
ioi$n	and	c			; D3 A1
	;***********************************************************
alt$y	and	a,#n			; 76 E6 20
ioe$n	and	a,#n			; DB E6 20
ioi$n	and	a,#n			; D3 E6 20
alt$y	and	a, n			; 76 E6 20
ioe$n	and	a, n			; DB E6 20
ioi$n	and	a, n			; D3 E6 20
	;***********************************************************
alt$y	and	#n			; 76 E6 20
ioe$n	and	#n			; DB E6 20
ioi$n	and	#n			; D3 E6 20
alt$y	and	 n			; 76 E6 20
ioe$n	and	 n			; DB E6 20
ioi$n	and	 n			; D3 E6 20
	;***********************************************************
alt$y	and	hl,de			; 76 DC
ioe$n	and	hl,de			; DB DC
ioi$n	and	hl,de			; D3 DC
	;***********************************************************
	; test bit of location or register
z80$b	bit	0,(hl)			; CB 46
z80$b	bit	0,offset(ix)		; DD CB 33 46
z80$b	bit	0,offset(iy)		; FD CB 33 46
z80$b	bit	0,(ix+offset)		; DD CB 33 46
z80$b	bit	0,(iy+offset)		; FD CB 33 46
z80$b	bit	0,a			; CB 47
z80$b	bit	0,b			; CB 40
z80$b	bit	0,c			; CB 41
z80$b	bit	0,d			; CB 42
z80$b	bit	0,e			; CB 43
z80$b	bit	0,h			; CB 44
z80$b	bit	0,l			; CB 45
z80$b	bit	1,(hl)			; CB 4E
z80$b	bit	1,offset(ix)		; DD CB 33 4E
z80$b	bit	1,offset(iy)		; FD CB 33 4E
z80$b	bit	1,(ix+offset)		; DD CB 33 4E
z80$b	bit	1,(iy+offset)		; FD CB 33 4E
z80$b	bit	1,a			; CB 4F
z80$b	bit	1,b			; CB 48
z80$b	bit	1,c			; CB 49
z80$b	bit	1,d			; CB 4A
z80$b	bit	1,e			; CB 4B
z80$b	bit	1,h			; CB 4C
z80$b	bit	1,l			; CB 4D
z80$b	bit	2,(hl)			; CB 56
z80$b	bit	2,offset(ix)		; DD CB 33 56
z80$b	bit	2,offset(iy)		; FD CB 33 56
z80$b	bit	2,(ix+offset)		; DD CB 33 56
z80$b	bit	2,(iy+offset)		; FD CB 33 56
z80$b	bit	2,a			; CB 57
z80$b	bit	2,b			; CB 50
z80$b	bit	2,c			; CB 51
z80$b	bit	2,d			; CB 52
z80$b	bit	2,e			; CB 53
z80$b	bit	2,h			; CB 54
z80$b	bit	2,l			; CB 55
z80$b	bit	3,(hl)			; CB 5E
z80$b	bit	3,offset(ix)		; DD CB 33 5E
z80$b	bit	3,offset(iy)		; FD CB 33 5E
z80$b	bit	3,(ix+offset)		; DD CB 33 5E
z80$b	bit	3,(iy+offset)		; FD CB 33 5E
z80$b	bit	3,a			; CB 5F
z80$b	bit	3,b			; CB 58
z80$b	bit	3,c			; CB 59
z80$b	bit	3,d			; CB 5A
z80$b	bit	3,e			; CB 5B
z80$b	bit	3,h			; CB 5C
z80$b	bit	3,l			; CB 5D
z80$b	bit	4,(hl)			; CB 66
z80$b	bit	4,offset(ix)		; DD CB 33 66
z80$b	bit	4,offset(iy)		; FD CB 33 66
z80$b	bit	4,(ix+offset)		; DD CB 33 66
z80$b	bit	4,(iy+offset)		; FD CB 33 66
z80$b	bit	4,a			; CB 67
z80$b	bit	4,b			; CB 60
z80$b	bit	4,c			; CB 61
z80$b	bit	4,d			; CB 62
z80$b	bit	4,e			; CB 63
z80$b	bit	4,h			; CB 64
z80$b	bit	4,l			; CB 65
z80$b	bit	5,(hl)			; CB 6E
z80$b	bit	5,offset(ix)		; DD CB 33 6E
z80$b	bit	5,offset(iy)		; FD CB 33 6E
z80$b	bit	5,(ix+offset)		; DD CB 33 6E
z80$b	bit	5,(iy+offset)		; FD CB 33 6E
z80$b	bit	5,a			; CB 6F
z80$b	bit	5,b			; CB 68
z80$b	bit	5,c			; CB 69
z80$b	bit	5,d			; CB 6A
z80$b	bit	5,e			; CB 6B
z80$b	bit	5,h			; CB 6C
z80$b	bit	5,l			; CB 6D
z80$b	bit	6,(hl)			; CB 76
z80$b	bit	6,offset(ix)		; DD CB 33 76
z80$b	bit	6,offset(iy)		; FD CB 33 76
z80$b	bit	6,(ix+offset)		; DD CB 33 76
z80$b	bit	6,(iy+offset)		; FD CB 33 76
z80$b	bit	6,a			; CB 77
z80$b	bit	6,b			; CB 70
z80$b	bit	6,c			; CB 71
z80$b	bit	6,d			; CB 72
z80$b	bit	6,e			; CB 73
z80$b	bit	6,h			; CB 74
z80$b	bit	6,l			; CB 75
z80$b	bit	7,(hl)			; CB 7E
z80$b	bit	7,offset(ix)		; DD CB 33 7E
z80$b	bit	7,offset(iy)		; FD CB 33 7E
z80$b	bit	7,(ix+offset)		; DD CB 33 7E
z80$b	bit	7,(iy+offset)		; FD CB 33 7E
z80$b	bit	7,a			; CB 7F
z80$b	bit	7,b			; CB 78
z80$b	bit	7,c			; CB 79
z80$b	bit	7,d			; CB 7A
z80$b	bit	7,e			; CB 7B
z80$b	bit	7,h			; CB 7C
z80$b	bit	7,l			; CB 7D
	;***********************************************************
	; illegal constant values
	; representative bit opcodes
err$y	bit	0,(ix+128)		; DD CB 80 46
err$n	bit	0,(ix+127)		; DD CB 7F 46
err$n	bit	0,(ix+1)		; DD CB 01 46
err$n	bit	0,(ix+0)		; DD CB 00 46
err$n	bit	0,(ix-1)		; DD CB FF 46
err$n	bit	0,(ix-128)		; DD CB 80 46
err$y	bit	0,(ix-129)		; DD CB 7F 46
	;***********************************************************
	; illegal addressing  modes
	; representative bit opcodes
err$y	bit	0,(hl+offset)		; CB 46
err$y	bit	0,offset(hl)		; CB 46
	;***********************************************************
err$y	bit	0,hl			;
err$y	bit	0,ix			;
	;***********************************************************
	; altd / ioe / ioi  modes
	; representative bit opcodes
alt$y	bit	1,(hl)			; 76 CB 4E
ioe$y	bit	1,(hl)			; DB CB 4E
ioi$y	bit	1,(hl)			; D3 CB 4E
alt$y	bit	1,offset(ix)		; 76 DD CB 33 4E
ioe$y	bit	1,offset(ix)		; DB DD CB 33 4E
ioi$y	bit	1,offset(ix)		; D3 DD CB 33 4E
alt$y	bit	1,(ix+offset)		; 76 DD CB 33 4E
ioe$y	bit	1,(ix+offset)		; DB DD CB 33 4E
ioi$y	bit	1,(ix+offset)		; D3 DD CB 33 4E
	;***********************************************************
alt$y	bit	1,c			; 76 CB 49
ioe$n	bit	1,c			; DB CB 49
ioi$n	bit	1,c			; D3 CB 49
	;***********************************************************
	; boolean test of register
r$2k	bool	hl			; CC
r$2k	bool	ix			; DD CC
r$2k	bool	iy			; FD CC
	;***********************************************************
	; illegal addressing  modes
	; representative bool opcodes
err$y	bool	a			;
err$y	bool	bc			;
	;***********************************************************
	; altd / ioe / ioi  modes
	; representative bool opcodes
alt$y	bool	hl			; 76 CC
ioe$n	bool	hl			; DB CC
ioi$n	bool	hl			; D3 CC
	;***********************************************************
	; call subroutine at mn if condition is true
z80$x	call	C,mn			; DC 84 05
z80$x	call	M,mn			; FC 84 05
z80$x	call	NC,mn			; D4 84 05
z80$x	call	NZ,mn			; C4 84 05
z80$x	call	P,mn			; F4 84 05
z80$x	call	PE,mn			; EC 84 05
z80$x	call	PO,mn			; E4 84 05
z80$x	call	Z,mn			; CC 84 05
	;***********************************************************
	; unconditional call to subroutine at mn
z80$b	call	mn			; CD 84 05
	;***********************************************************
	; complement carry flag
z80$b	ccf				; 3F
	;***********************************************************
	; altd / ioe / ioi  modes
	; representative ccf opcodes
alt$y	ccf				; 76 3F
ioe$n	ccf				; DB 3F
ioi$n	ccf				; D3 3F
	;***********************************************************
	; compare operand with 'a'
z80$b	cp	a,(hl)			; BE
z80$b	cp	a,offset(ix)		; DD BE 33
z80$b	cp	a,offset(iy)		; FD BE 33
z80$b	cp	a,(ix+offset)		; DD BE 33
z80$b	cp	a,(iy+offset)		; FD BE 33
z80$b	cp	a,a			; BF
z80$b	cp	a,b			; B8
z80$b	cp	a,c			; B9
z80$b	cp	a,d			; BA
z80$b	cp	a,e			; BB
z80$b	cp	a,h			; BC
z80$b	cp	a,l			; BD
z80$b	cp	a,#n			; FE 20
z80$b	cp	a, n			; FE 20
	;***********************************************************
z80$b	cp	(hl)			; BE
z80$b	cp	offset(ix)		; DD BE 33
z80$b	cp	offset(iy)		; FD BE 33
z80$b	cp	(ix+offset)		; DD BE 33
z80$b	cp	(iy+offset)		; FD BE 33
z80$b	cp	a			; BF
z80$b	cp	b			; B8
z80$b	cp	c			; B9
z80$b	cp	d			; BA
z80$b	cp	e			; BB
z80$b	cp	h			; BC
z80$b	cp	l			; BD
z80$b	cp	#n			; FE 20
z80$b	cp	 n			; FE 20
	;***********************************************************
	; illegal addressing  modes
	; representative cp opcodes
err$y	cp	(hl+offset)		; BE
err$y	cp	offset(hl)		; BE
	;***********************************************************
err$y	cp	hl,de			;
err$y	cp	ix,de			;
err$y	cp	iy,de			;
	;***********************************************************
	; altd / ioe / ioi  modes
	; representative cp opcodes
alt$y	cp	a,(hl)			; 76 BE
ioe$y	cp	a,(hl)			; DB BE
ioi$y	cp	a,(hl)			; D3 BE
	;***********************************************************
alt$y	cp	(hl)			; 76 BE
ioe$y	cp	(hl)			; DB BE
ioi$y	cp	(hl)			; D3 BE
	;***********************************************************
alt$y	cp	a,c			; 76 B9
ioe$n	cp	a,c			; DB B9
ioi$n	cp	a,c			; D3 B9
	;***********************************************************
alt$y	cp	c			; 76 B9
ioe$n	cp	c			; DB B9
ioi$n	cp	c			; D3 B9
	;***********************************************************
alt$y	cp	a,#n			; 76 FE 20
ioe$n	cp	a,#n			; DB FE 20
ioi$n	cp	a,#n			; D3 FE 20
alt$y	cp	a, n			; 76 FE 20
ioe$n	cp	a, n			; DB FE 20
ioi$n	cp	a, n			; D3 FE 20
	;***********************************************************
alt$y	cp	#n			; 76 FE 20
ioe$n	cp	#n			; DB FE 20
ioi$n	cp	#n			; D3 FE 20
alt$y	cp	 n			; 76 FE 20
ioe$n	cp	 n			; DB FE 20
ioi$n	cp	 n			; D3 FE 20
	;***********************************************************
	; compare location (hl) and 'a'
	; decrement 'hl' and 'bc'
z80$x	cpd				; ED A9
	;***********************************************************
	; compare location (hl) and 'a'
	; decrement 'hl' and 'bc'
	; repeat until 'bc' = 0
z80$x	cpdr				; ED B9
	;***********************************************************
	; compare location (hl) and 'a'
	; increment 'hl' and decrement 'bc'
z80$x	cpi				; ED A1
	;***********************************************************
	; compare location (hl) and 'a'
	; increment 'hl' and decrement 'bc'
	; repeat until 'bc' = 0
z80$x	cpir				; ED B1
	;***********************************************************
	; 1's complement of 'a'
z80$b	cpl				; 2F
	;***********************************************************
	; altd / ioe / ioi  modes
	; representative cpl opcodes
alt$y	cpl				; 76 2F
ioe$n	cpl				; DB 2F
ioi$n	cpl				; D3 2F
	;***********************************************************
	; decimal adjust 'a'
z80$x	daa				; 27
	;***********************************************************
	; decrement operand
z80$b	dec	(hl)			; 35
z80$b	dec	offset(ix)		; DD 35 33
z80$b	dec	offset(iy)		; FD 35 33
z80$b	dec	(ix+offset)		; DD 35 33
z80$b	dec	(iy+offset)		; FD 35 33
z80$b	dec	a			; 3D
z80$b	dec	b			; 05
z80$b	dec	c			; 0D
z80$b	dec	d			; 15
z80$b	dec	e			; 1D
z80$b	dec	h			; 25
z80$b	dec	l			; 2D
	;***********************************************************
z80$b	dec	bc			; 0B
z80$b	dec	de			; 1B
z80$b	dec	hl			; 2B
z80$b	dec	sp			; 3B
	;***********************************************************
z80$b	dec	ix			; DD 2B
z80$b	dec	iy			; FD 2B
	;***********************************************************
	; illegal addressing  modes
	; representative dec opcodes
err$y	dec	(hl+offset)		; 35
err$y	dec	offset(hl)		; 35
err$y	dec	af			;
err$y	dec	mn			;
	;***********************************************************
	; altd / ioe / ioi  modes
	; representative dec opcodes
alt$y	dec	(hl)			; 76 35
ioe$y	dec	(hl)			; DB 35
ioi$y	dec	(hl)			; D3 35
	;***********************************************************
alt$y	dec	c			; 76 0D
ioe$n	dec	c			; DB 0D
ioi$n	dec	c			; D3 0D
	;***********************************************************
alt$y	dec	de			; 76 1B
ioe$n	dec	de			; DB 1B
ioi$n	dec	de			; D3 1B
	;***********************************************************
alt$n	dec	ix			; 76 DD 2B
ioe$n	dec	ix			; DB DD 2B
ioi$n	dec	ix			; D3 DD 2B
	;***********************************************************
	; disable interrupts
z80$x	di				; F3
	;***********************************************************
	; decrement b and jump relative if b # 0
z80$b	djnz	.+0x12			; 10 10
	;***********************************************************
	; altd / ioe / ioi  modes
	; representative djnc opcodes
alt$y	djnz	.+0x12			; 76 10 10
ioe$n	djnz	.+0x12			; DB 10 10
ioi$n	djnz	.+0x12			; D3 10 10
	;***********************************************************
	; enable interrupts
z80$x	ei				; FB
	;***********************************************************
	; exchange location and (sp)
z80$x	ex	(sp),hl			; E3
r$2k	ex	(sp),hl			; ED 54
z80$b	ex	(sp),ix			; DD E3
z80$b	ex	(sp),iy			; FD E3
	;***********************************************************
	; exchange af and af'
z80$b	ex	af,af'			; 08
	;***********************************************************
	; exchange de and hl
z80$b	ex	de,hl			; EB
r$2k	ex	de',hl			; E3
r$2k	ex	de,hl'			; 76 EB
r$2k	ex	de',hl'			; 76 E3
	;***********************************************************
	; illegal addressing  modes
	; representative ex opcodes
err$y	ex	(sp),bc			;
err$y	ex	bc,hl			;
err$y	ex	bc',hl			;
	;***********************************************************
	; altd / ioe / ioi  modes
	; representative ex opcodes
alt$y	ex	(sp),hl			; 76 ED 54
ioe$n	ex	(sp),hl			; DB ED 54
ioi$n	ex	(sp),hl			; D3 ED 54
	;***********************************************************
alt$n	ex	(sp),ix			; 76 DD E3
ioe$n	ex	(sp),ix			; DB DD E3
ioi$n	ex	(sp),ix			; D3 DD E3
	;***********************************************************
alt$n	ex	af,af'			; 76 08
ioe$n	ex	af,af'			; DB 08
ioi$n	ex	af,af'			; D3 08
	;***********************************************************
alt$y	ex	de,hl			; 76 EB
ioe$n	ex	de,hl			; DB EB
ioi$n	ex	de,hl			; D3 EB
	;***********************************************************
alt$n	ex	de,hl'			; 76 76 EB
ioe$n	ex	de,hl'			; DB 76 EB
ioi$n	ex	de,hl'			; D3 76 EB
	;***********************************************************
	; exchange:
	;	bc <-> bc'
	;	de <-> de'
	;	hl <-> hl'
z80$b	exx				; D9
	;***********************************************************
	; halt (wait for interrupt or reset)
z80$x	halt				; 76
	;***********************************************************
	; set interrupt mode
z80$x	im	0			; ED 46
z80$x	im	1			; ED 56
z80$x	im	2			; ED 5E
	;***********************************************************
	; load 'a' with input from device n
z80$x	in	a,(n)			; DB 20
	;***********************************************************
	; load register with input from (c)
z80$x	in	a,(c)			; ED 78
z80$x	in	b,(c)			; ED 40
z80$x	in	c,(c)			; ED 48
z80$x	in	d,(c)			; ED 50
z80$x	in	e,(c)			; ED 58
z80$x	in	h,(c)			; ED 60
z80$x	in	l,(c)			; ED 68
	;***********************************************************
	; increment operand
z80$b	inc	(hl)			; 34
z80$b	inc	offset(ix)		; DD 34 33
z80$b	inc	offset(iy)		; FD 34 33
z80$b	inc	(ix+offset)		; DD 34 33
z80$b	inc	(iy+offset)		; FD 34 33
z80$b	inc	a			; 3C
z80$b	inc	b			; 04
z80$b	inc	c			; 0C
z80$b	inc	d			; 14
z80$b	inc	e			; 1C
z80$b	inc	h			; 24
z80$b	inc	l			; 2C
	;***********************************************************
z80$b	inc	bc			; 03
z80$b	inc	de			; 13
z80$b	inc	hl			; 23
z80$b	inc	sp			; 33
	;***********************************************************
z80$b	inc	ix			; DD 23
z80$b	inc	iy			; FD 23
	;***********************************************************
	; illegal addressing  modes
	; representative inc opcodes
err$y	inc	(hl+offset)		; 34
err$y	inc	offset(hl)		; 34
err$y	inc	af			;
err$y	inc	mn			;
	;***********************************************************
	; altd / ioe / ioi  modes
	; representative inc opcodes
alt$y	inc	(hl)			; 76 34
ioe$y	inc	(hl)			; DB 34
ioi$y	inc	(hl)			; D3 34
	;***********************************************************
alt$y	inc	c			; 76 0C
ioe$n	inc	c			; DB 0C
ioi$n	inc	c			; D3 0C
	;***********************************************************
alt$y	inc	de			; 76 13
ioe$n	inc	de			; DB 13
ioi$n	inc	de			; D3 13
	;***********************************************************
alt$n	inc	ix			; 76 DD 23
ioe$n	inc	ix			; DB DD 23
ioi$n	inc	ix			; D3 DD 23
	;***********************************************************
	; load location (hl) with input
	; from port (c)
	; decrement 'hl' and 'b'
z80$x	ind				; ED AA
	;***********************************************************
	; load location (hl) with input
	; from port (c)
	; decrement 'hl' and 'b'
	; repeat until 'b' = 0
z80$x	indr				; ED BA
	;***********************************************************
	; load location (hl) with input
	; from port (c)
	; increment 'hl' and decrement 'b'
z80$x	ini				; ED A2
	;***********************************************************
	; load location (hl) with input
	; from port (c)
	; increment 'hl' and decrement 'b'
	; repeat until 'b' = 0
z80$x	inir				; ED B2
	;***********************************************************
	; set interrupt priority register
r$2k	ipset	0			; ED 46
r$2k	ipset	1			; ED 56
r$2k	ipset	2			; ED 4E
r$2k	ipset	3			; ED 5E
	;***********************************************************
	; illegal addressing  modes
	; representative ipset opcodes
err$y	ipset	4			; ED 46
err$y	ipset	7			; ED 5E
	;***********************************************************
	; restore previous interrupt priority
r$2k	ipres				; ED 5D
	;***********************************************************
	; unconditional jump to location mn
z80$b	jp	mn			; C3 84 05
z80$b	jp	(hl)			; E9
z80$b	jp	(ix)			; DD E9
z80$b	jp	(iy)			; FD E9
	;***********************************************************
	; jump to location if condition is true
z80$b	jp	NZ,mn			; C2 84 05
z80$b	jp	Z,mn			; CA 84 05
z80$b	jp	NC,mn			; D2 84 05
z80$b	jp	C,mn			; DA 84 05
z80$b	jp	PO,mn			; E2 84 05
z80$b	jp	PE,mn			; EA 84 05
z80$b	jp	P,mn			; F2 84 05
z80$b	jp	M,mn			; FA 84 05
	;***********************************************************
	; illegal addressing  modes
	; representative jp opcodes
err$y	jp	(bc)			;
	;***********************************************************
	; unconditional jump relative to PC+e
z80$b	jr	1$+0x10			; 18 10
	;***********************************************************
	; jump relative to PC+e if condition is true
z80$b	1$:	jr	NZ,2$+0x10	; 20 10
z80$b	2$:	jr	Z,3$+0x10	; 28 10
z80$b	3$:	jr	NC,4$+0x10	; 30 10
z80$b	4$:	jr	C,5$+0x10	; 38 10
z80$b	5$:
	;***********************************************************
	; illegal addressing  modes
	; representative jr opcodes
err$y	6$:	jr	PO,7$+0x10	; 18 00
err$y	7$:	jr	PE,8$+0x10	; 18 00
err$y	8$:	jr	P,9$+0x10	; 18 00
err$y	9$:	jr	M,10$+0x10	; 18 00
err$y	10$:
	;***********************************************************
	; extended call
r$2k	lcall	n,mn			; CF 84 05 20
	;***********************************************************
	; load source to destination
z80$b	ld	a,(hl)			; 7E
z80$b	ld	a,offset(ix)		; DD 7E 33
z80$b	ld	a,offset(iy)		; FD 7E 33
z80$b	ld	a,(ix+offset)		; DD 7E 33
z80$b	ld	a,(iy+offset)		; FD 7E 33
z80$b	ld	a,a			; 7F
z80$b	ld	a,b			; 78
z80$b	ld	a,c			; 79
z80$b	ld	a,d			; 7A
z80$b	ld	a,e			; 7B
z80$b	ld	a,h			; 7C
z80$b	ld	a,l			; 7D
z80$b	ld	a,#n			; 3E 20
z80$b	ld	a, n			; 3E 20
z80$b	ld	b,(hl)			; 46
z80$b	ld	b,offset(ix)		; DD 46 33
z80$b	ld	b,offset(iy)		; FD 46 33
z80$b	ld	b,(ix+offset)		; DD 46 33
z80$b	ld	b,(iy+offset)		; FD 46 33
z80$b	ld	b,a			; 47
z80$b	ld	b,b			; 40
z80$b	ld	b,c			; 41
z80$b	ld	b,d			; 42
z80$b	ld	b,e			; 43
z80$b	ld	b,h			; 44
z80$b	ld	b,l			; 45
z80$b	ld	b,#n			; 06 20
z80$b	ld	b, n			; 06 20
z80$b	ld	c,(hl)			; 4E
z80$b	ld	c,offset(ix)		; DD 4E 33
z80$b	ld	c,offset(iy)		; FD 4E 33
z80$b	ld	c,(ix+offset)		; DD 4E 33
z80$b	ld	c,(iy+offset)		; FD 4E 33
z80$b	ld	c,a			; 4F
z80$b	ld	c,b			; 48
z80$b	ld	c,c			; 49
z80$b	ld	c,d			; 4A
z80$b	ld	c,e			; 4B
z80$b	ld	c,h			; 4C
z80$b	ld	c,l			; 4D
z80$b	ld	c,#n			; 0E 20
z80$b	ld	c, n			; 0E 20
z80$b	ld	d,(hl)			; 56
z80$b	ld	d,offset(ix)		; DD 56 33
z80$b	ld	d,offset(iy)		; FD 56 33
z80$b	ld	d,(ix+offset)		; DD 56 33
z80$b	ld	d,(iy+offset)		; FD 56 33
z80$b	ld	d,a			; 57
z80$b	ld	d,b			; 50
z80$b	ld	d,c			; 51
z80$b	ld	d,d			; 52
z80$b	ld	d,e			; 53
z80$b	ld	d,h			; 54
z80$b	ld	d,l			; 55
z80$b	ld	d,#n			; 16 20
z80$b	ld	d, n			; 16 20
z80$b	ld	e,(hl)			; 5E
z80$b	ld	e,offset(ix)		; DD 5E 33
z80$b	ld	e,offset(iy)		; FD 5E 33
z80$b	ld	e,(ix+offset)		; DD 5E 33
z80$b	ld	e,(iy+offset)		; FD 5E 33
z80$b	ld	e,a			; 5F
z80$b	ld	e,b			; 58
z80$b	ld	e,c			; 59
z80$b	ld	e,d			; 5A
z80$b	ld	e,e			; 5B
z80$b	ld	e,h			; 5C
z80$b	ld	e,l			; 5D
z80$b	ld	e,#n			; 1E 20
z80$b	ld	e, n			; 1E 20
z80$b	ld	h,(hl)			; 66
z80$b	ld	h,offset(ix)		; DD 66 33
z80$b	ld	h,offset(iy)		; FD 66 33
z80$b	ld	h,(ix+offset)		; DD 66 33
z80$b	ld	h,(iy+offset)		; FD 66 33
z80$b	ld	h,a			; 67
z80$b	ld	h,b			; 60
z80$b	ld	h,c			; 61
z80$b	ld	h,d			; 62
z80$b	ld	h,e			; 63
z80$b	ld	h,h			; 64
z80$b	ld	h,l			; 65
z80$b	ld	h,#n			; 26 20
z80$b	ld	h, n			; 26 20
z80$b	ld	l,(hl)			; 6E
z80$b	ld	l,offset(ix)		; DD 6E 33
z80$b	ld	l,offset(iy)		; FD 6E 33
z80$b	ld	l,(ix+offset)		; DD 6E 33
z80$b	ld	l,(iy+offset)		; FD 6E 33
z80$b	ld	l,a			; 6F
z80$b	ld	l,b			; 68
z80$b	ld	l,c			; 69
z80$b	ld	l,d			; 6A
z80$b	ld	l,e			; 6B
z80$b	ld	l,h			; 6C
z80$b	ld	l,l			; 6D
z80$b	ld	l,#n			; 2E 20
z80$b	ld	l, n			; 2E 20
	;***********************************************************
z80$x	ld	i,a			; ED 47
z80$x	ld	r,a			; ED 4F
z80$x	ld	a,i			; ED 57
z80$x	ld	a,r			; ED 5F
r$2k	ld	iir,a			; ED 47
r$2k	ld	eir,a			; ED 4F
r$2k	ld	xpc,a			; ED 67
r$2k	ld	a,iir			; ED 57
r$2k	ld	a,eir			; ED 5F
r$2k	ld	a,xpc			; ED 77
	;***********************************************************
z80$b	ld	(bc),a			; 02
z80$b	ld	(de),a			; 12
z80$b	ld	a,(bc)			; 0A
z80$b	ld	a,(de)			; 1A
	;***********************************************************
z80$b	ld	(hl),a			; 77
z80$b	ld	(hl),b			; 70
z80$b	ld	(hl),c			; 71
z80$b	ld	(hl),d			; 72
z80$b	ld	(hl),e			; 73
z80$b	ld	(hl),h			; 74
z80$b	ld	(hl),l			; 75
z80$b	ld	(hl),#n			; 36 20
z80$b	ld	(hl), n			; 36 20
	;***********************************************************
z80$b	ld	offset(ix),a		; DD 77 33
z80$b	ld	offset(ix),b		; DD 70 33
z80$b	ld	offset(ix),c		; DD 71 33
z80$b	ld	offset(ix),d		; DD 72 33
z80$b	ld	offset(ix),e		; DD 73 33
z80$b	ld	offset(ix),h		; DD 74 33
z80$b	ld	offset(ix),l		; DD 75 33
z80$b	ld	offset(ix),#n		; DD 36 33 20
z80$b	ld	offset(ix), n		; DD 36 33 20
	;***********************************************************
z80$b	ld	(ix+offset),a		; DD 77 33
z80$b	ld	(ix+offset),b		; DD 70 33
z80$b	ld	(ix+offset),c		; DD 71 33
z80$b	ld	(ix+offset),d		; DD 72 33
z80$b	ld	(ix+offset),e		; DD 73 33
z80$b	ld	(ix+offset),h		; DD 74 33
z80$b	ld	(ix+offset),l		; DD 75 33
z80$b	ld	(ix+offset),#n		; DD 36 33 20
z80$b	ld	(ix+offset), n		; DD 36 33 20
	;***********************************************************
z80$b	ld	offset(iy),a		; FD 77 33
z80$b	ld	offset(iy),b		; FD 70 33
z80$b	ld	offset(iy),c		; FD 71 33
z80$b	ld	offset(iy),d		; FD 72 33
z80$b	ld	offset(iy),e		; FD 73 33
z80$b	ld	offset(iy),h		; FD 74 33
z80$b	ld	offset(iy),l		; FD 75 33
z80$b	ld	offset(iy),#n		; FD 36 33 20
z80$b	ld	offset(iy), n		; FD 36 33 20
	;***********************************************************
z80$b	ld	(iy+offset),a		; FD 77 33
z80$b	ld	(iy+offset),b		; FD 70 33
z80$b	ld	(iy+offset),c		; FD 71 33
z80$b	ld	(iy+offset),d		; FD 72 33
z80$b	ld	(iy+offset),e		; FD 73 33
z80$b	ld	(iy+offset),h		; FD 74 33
z80$b	ld	(iy+offset),l		; FD 75 33
z80$b	ld	(iy+offset),#n		; FD 36 33 20
z80$b	ld	(iy+offset), n		; FD 36 33 20
	;***********************************************************
z80$b	ld	(mn),a			; 32 84 05
z80$b	ld	(mn),bc			; ED 43 84 05
z80$b	ld	(mn),de			; ED 53 84 05
z80$b	ld	(mn),hl			; 22 84 05
z80$b	ld	(mn),sp			; ED 73 84 05
z80$b	ld	(mn),ix			; DD 22 84 05
z80$b	ld	(mn),iy			; FD 22 84 05
	;***********************************************************
z80$b	ld	a,(mn)			; 3A 84 05
z80$b	ld	bc,(mn)			; ED 4B 84 05
z80$b	ld	de,(mn)			; ED 5B 84 05
z80$b	ld	hl,(mn)			; 2A 84 05
z80$b	ld	sp,(mn)			; ED 7B 84 05
z80$b	ld	ix,(mn)			; DD 2A 84 05
z80$b	ld	iy,(mn)			; FD 2A 84 05
	;***********************************************************
z80$b	ld	bc,#mn			; 01 84 05
z80$b	ld	bc, mn			; 01 84 05
z80$b	ld	de,#mn			; 11 84 05
z80$b	ld	de, mn			; 11 84 05
z80$b	ld	hl,#mn			; 21 84 05
z80$b	ld	hl, mn			; 21 84 05
z80$b	ld	sp,#mn			; 31 84 05
z80$b	ld	sp, mn			; 31 84 05
z80$b	ld	ix,#mn			; DD 21 84 05
z80$b	ld	ix, mn			; DD 21 84 05
z80$b	ld	iy,#mn			; FD 21 84 05
z80$b	ld	iy, mn			; FD 21 84 05
	;***********************************************************
r$2k	ld	bc',bc			; ED 49
r$2k	ld	de',bc			; ED 59
r$2k	ld	hl',bc			; ED 69
r$2k	ld	bc',de			; ED 41
r$2k	ld	de',de			; ED 51
r$2k	ld	hl',de			; ED 61
	;***********************************************************
z80$b	ld	sp,hl			; F9
z80$b	ld	sp,ix			; DD F9
z80$b	ld	sp,iy			; FD F9
	;***********************************************************
r$2k	ld	(hl+offset),hl		; DD F4 33
r$2k	ld	(ix+offset),hl		; F4 33
r$2k	ld	(iy+offset),hl		; FD F4 33
r$2k	ld	(sp+offset),hl		; D4 33
r$2k	ld	offset(hl),hl		; DD F4 33
r$2k	ld	offset(ix),hl		; F4 33
r$2k	ld	offset(iy),hl		; FD F4 33
r$2k	ld	offset(sp),hl		; D4 33
	;***********************************************************
r$2k	ld	hl,(hl+offset)		; DD E4 33
r$2k	ld	hl,(ix+offset)		; E4 33
r$2k	ld	hl,(iy+offset)		; FD E4 33
r$2k	ld	hl,(sp+offset)		; C4 33
r$2k	ld	hl,offset(hl)		; DD E4 33
r$2k	ld	hl,offset(ix)		; E4 33
r$2k	ld	hl,offset(iy)		; FD E4 33
r$2k	ld	hl,offset(sp)		; C4 33
	;***********************************************************
r$2k	ld	hl,ix			; DD 7C
r$2k	ld	hl,iy			; FD 7C
	;***********************************************************
r$2k	ld	ix,(sp+offset)		; DD C4 33
r$2k	ld	ix,offset(sp)		; DD C4 33
	;***********************************************************
r$2k	ld	(sp+offset),ix		; DD D4 33
r$2k	ld	offset(sp),ix		; DD D4 33
	;***********************************************************
r$2k	ld	ix,hl			; DD 7D
r$2k	ld	iy,hl			; FD 7D
	;***********************************************************
r$2k	ld	iy,(sp+offset)		; FD C4 33
r$2k	ld	iy,offset(sp)		; FD C4 33
	;***********************************************************
r$2k	ld	(sp+offset),iy		; FD D4 33
r$2k	ld	offset(sp),iy		; FD D4 33
	;***********************************************************
	; illegal constant values
	; representative ld opcodes
err$y	ld	a,(ix+128)		; DD 7E 80
err$n	ld	a,(ix+127)		; DD 7E 7F
err$n	ld	a,(ix+1)		; DD 7E 01
err$n	ld	a,(ix+0)		; DD 7E 00
err$n	ld	a,(ix-1)		; DD 7E FF
err$n	ld	a,(ix-128)		; DD 7E 80
err$y	ld	a,(ix-129)		; DD 7E 7F
	;***********************************************************
err$y	ld	hl,(ix+128)		; E4 80
err$n	ld	hl,(ix+127)		; E4 7F
err$n	ld	hl,(ix+1)		; E4 01
err$n	ld	hl,(ix+0)		; E4 00
err$n	ld	hl,(ix-1)		; E4 FF
err$n	ld	hl,(ix-128)		; E4 80
err$y	ld	hl,(ix-129)		; E4 7F
	;***********************************************************
err$y	ld	ix,(sp-1)		; DD C4 FF
err$n	ld	ix,(sp+0)		; DD C4 00
err$n	ld	ix,(sp+1)		; DD C4 01
err$n	ld	ix,(sp+255)		; DD C4 FF
err$y	ld	ix,(sp+256)		; DD C4 00
	;***********************************************************
err$y	ld	(ix+128),hl		; F4 80
err$n	ld	(ix+127),hl		; F4 7F
err$n	ld	(ix+1),hl		; F4 01
err$n	ld	(ix+0),hl		; F4 00
err$n	ld	(ix-1),hl		; F4 FF
err$n	ld	(ix-128),hl		; F4 80
err$y	ld	(ix-129),hl		; F4 7F
	;***********************************************************
err$y	ld	(sp-1),ix		; DD D4 FF
err$n	ld	(sp+0),ix		; DD D4 00
err$n	ld	(sp+1),ix		; DD D4 01
err$n	ld	(sp+255),ix		; DD D4 FF
err$y	ld	(sp+256),ix		; DD D4 00
	;***********************************************************
err$y	ld	(ix+128),a		; DD 77 80
err$n	ld	(ix+127),a		; DD 77 7F
err$n	ld	(ix+1),a		; DD 77 01
err$n	ld	(ix+0),a		; DD 77 00
err$n	ld	(ix-1),a		; DD 77 FF
err$n	ld	(ix-128),a		; DD 77 80
err$y	ld	(ix-129),a		; DD 77 7F
	;***********************************************************
err$y	ld	(ix+128),n		; DD 36 80 20
err$n	ld	(ix+127),n		; DD 36 7F 20
err$n	ld	(ix+1),n		; DD 36 01 20
err$n	ld	(ix+0),n		; DD 36 00 20
err$n	ld	(ix-1),n		; DD 36 FF 20
err$n	ld	(ix-128),n		; DD 36 80 20
err$y	ld	(ix-129),n		; DD 36 7F 20
	;***********************************************************
	; illegal addressing  modes
	; representative ld opcodes
err$y	ld	a,(hl+offset)		; 7E
err$y	ld	a,offset(hl)		; 7E
	;***********************************************************
err$y	ld	(bc),b			;
err$y	ld	(de),b			;
err$y	ld	b,(bc)			;
err$y	ld	b,(de)			;
	;***********************************************************
err$y	ld	(mn),b			;
	;***********************************************************
err$y	ld	b,(mn)			;
	;***********************************************************
err$y	ld	hl,sp			;
	;***********************************************************
	; altd / ioe / ioi  modes
	; representative ld opcodes
alt$y	ld	a,(hl)			; 76 7E
ioe$y	ld	a,(hl)			; DB 7E
ioi$y	ld	a,(hl)			; D3 7E
	;***********************************************************
alt$y	ld	a,c			; 76 79
ioe$n	ld	a,c			; DB 79
ioi$n	ld	a,c			; D3 79
	;***********************************************************
alt$y	ld	a,#n			; 76 3E 20
ioe$n	ld	a,#n			; DB 3E 20
ioi$n	ld	a,#n			; D3 3E 20
alt$y	ld	a, n			; 76 3E 20
ioe$n	ld	a, n			; DB 3E 20
ioi$n	ld	a, n			; D3 3E 20
	;***********************************************************
alt$y	ld	bc,#mn			; 76 01 84 05
ioe$n	ld	bc,#mn			; DB 01 84 05
ioi$n	ld	bc,#mn			; D3 01 84 05
alt$y	ld	bc, mn			; 76 01 84 05
ioe$n	ld	bc, mn			; DB 01 84 05
ioi$n	ld	bc, mn			; D3 01 84 05
alt$n	ld	sp,#mn			; 76 31 84 05
ioe$n	ld	sp,#mn			; DB 31 84 05
ioi$n	ld	sp,#mn			; D3 31 84 05
alt$n	ld	sp, mn			; 76 31 84 05
ioe$n	ld	sp, mn			; DB 31 84 05
ioi$n	ld	sp, mn			; D3 31 84 05
	;***********************************************************
alt$y	ld	a,(#mn)			; 76 3A 84 05
ioe$y	ld	a,(#mn)			; DB 3A 84 05
ioi$y	ld	a,(#mn)			; D3 3A 84 05
alt$y	ld	a,( mn)			; 76 3A 84 05
ioe$y	ld	a,( mn)			; DB 3A 84 05
ioi$y	ld	a,( mn)			; D3 3A 84 05
	;***********************************************************
alt$y	ld	bc,(#mn)		; 76 ED 4B 84 05
ioe$y	ld	bc,(#mn)		; DB ED 4B 84 05
ioi$y	ld	bc,(#mn)		; D3 ED 4B 84 05
alt$y	ld	bc,( mn)		; 76 ED 4B 84 05
ioe$y	ld	bc,( mn)		; DB ED 4B 84 05
ioi$y	ld	bc,( mn)		; D3 ED 4B 84 05
alt$n	ld	sp,(#mn)		; 76 ED 7B 84 05
ioe$y	ld	sp,(#mn)		; DB ED 7B 84 05
ioi$y	ld	sp,(#mn)		; D3 ED 7B 84 05
alt$n	ld	sp,( mn)		; 76 ED 7B 84 05
ioe$y	ld	sp,( mn)		; DB ED 7B 84 05
ioi$y	ld	sp,( mn)		; D3 ED 7B 84 05
	;***********************************************************
alt$n	ld	(hl+offset),hl		; 76 DD F4 33
ioe$y	ld	(hl+offset),hl		; DB DD F4 33
ioi$y	ld	(hl+offset),hl		; D3 DD F4 33
alt$n	ld	(ix+offset),hl		; 76 F4 33
ioe$y	ld	(ix+offset),hl		; DB F4 33
ioi$y	ld	(ix+offset),hl		; D3 F4 33
alt$n	ld	(iy+offset),hl		; 76 FD F4 33
ioe$y	ld	(iy+offset),hl		; DB FD F4 33
ioi$y	ld	(iy+offset),hl		; D3 FD F4 33
alt$n	ld	(sp+offset),hl		; 76 D4 33
ioe$n	ld	(sp+offset),hl		; DB D4 33
ioi$n	ld	(sp+offset),hl		; D3 D4 33
	;***********************************************************
alt$y	ld	hl,(hl+offset)		; 76 DD E4 33
ioe$y	ld	hl,(hl+offset)		; DB DD E4 33
ioi$y	ld	hl,(hl+offset)		; D3 DD E4 33
alt$y	ld	hl,(ix+offset)		; 76 E4 33
ioe$y	ld	hl,(ix+offset)		; DB E4 33
ioi$y	ld	hl,(ix+offset)		; D3 E4 33
alt$y	ld	hl,(iy+offset)		; 76 FD E4 33
ioe$y	ld	hl,(iy+offset)		; DB FD E4 33
ioi$y	ld	hl,(iy+offset)		; D3 FD E4 33
alt$y	ld	hl,(sp+offset)		; 76 C4 33
ioe$n	ld	hl,(sp+offset)		; DB C4 33
ioi$n	ld	hl,(sp+offset)		; D3 C4 33
	;***********************************************************
alt$y	ld	hl,ix			; 76 DD 7C
ioe$n	ld	hl,ix			; DB DD 7C
ioi$n	ld	hl,ix			; D3 DD 7C
alt$n	ld	ix,hl			; 76 DD 7D
ioe$n	ld	ix,hl			; DB DD 7D
ioi$n	ld	ix,hl			; D3 DD 7D
	;***********************************************************
alt$n	ld	ix,(sp+offset)		; 76 DD C4 33
ioe$n	ld	ix,(sp+offset)		; DB DD C4 33
ioi$n	ld	ix,(sp+offset)		; D3 DD C4 33
alt$n	ld	(sp+offset),ix		; 76 DD D4 33
ioe$n	ld	(sp+offset),ix		; DB DD D4 33
ioi$n	ld	(sp+offset),ix		; D3 DD D4 33
	;***********************************************************
alt$n	ld	(#mn),a			; 76 32 84 05
ioe$y	ld	(#mn),a			; DB 32 84 05
ioi$y	ld	(#mn),a			; D3 32 84 05
alt$n	ld	( mn),a			; 76 32 84 05
ioe$y	ld	( mn),a			; DB 32 84 05
ioi$y	ld	( mn),a			; D3 32 84 05
	;***********************************************************
alt$n	ld	(#mn),bc		; 76 ED 43 84 05
ioe$y	ld	(#mn),bc		; DB ED 43 84 05
ioi$y	ld	(#mn),bc		; D3 ED 43 84 05
alt$n	ld	( mn),bc		; 76 ED 43 84 05
ioe$y	ld	( mn),bc		; DB ED 43 84 05
ioi$y	ld	( mn),bc		; D3 ED 43 84 05
alt$n	ld	(#mn),sp		; 76 ED 73 84 05
ioe$y	ld	(#mn),sp		; DB ED 73 84 05
ioi$y	ld	(#mn),sp		; D3 ED 73 84 05
alt$n	ld	( mn),sp		; 76 ED 73 84 05
ioe$y	ld	( mn),sp		; DB ED 73 84 05
ioi$y	ld	( mn),sp		; D3 ED 73 84 05
	;***********************************************************
alt$n	ld	(hl),a			; 76 77
ioe$y	ld	(hl),a			; DB 77
ioi$y	ld	(hl),a			; D3 77
alt$n	ld	(ix+offset),a		; 76 DD 77 33
ioe$y	ld	(ix+offset),a		; DB DD 77 33
ioi$y	ld	(ix+offset),a		; D3 DD 77 33
alt$n	ld	offset(ix),a		; 76 DD 77 33
ioe$y	ld	offset(ix),a		; DB DD 77 33
ioi$y	ld	offset(ix),a		; D3 DD 77 33
	;***********************************************************
alt$n	ld	(hl),#n			; 76 36 20
ioe$y	ld	(hl),#n			; DB 36 20
ioi$y	ld	(hl),#n			; D3 36 20
alt$n	ld	(hl), n			; 76 36 20
ioe$y	ld	(hl), n			; DB 36 20
ioi$y	ld	(hl), n			; D3 36 20
alt$n	ld	(ix+offset),#n		; 76 DD 36 33 20
ioe$n	ld	(ix+offset),#n		; DB DD 36 33 20
ioi$n	ld	(ix+offset),#n		; D3 DD 36 33 20
alt$n	ld	(ix+offset), n		; 76 DD 36 33 20
ioe$n	ld	(ix+offset), n		; DB DD 36 33 20
ioi$n	ld	(ix+offset), n		; D3 DD 36 33 20
alt$n	ld	offset(ix),#n		; 76 DD 36 33 20
ioe$n	ld	offset(ix),#n		; DB DD 36 33 20
ioi$n	ld	offset(ix),#n		; D3 DD 36 33 20
alt$n	ld	offset(ix), n		; 76 DD 36 33 20
ioe$n	ld	offset(ix), n		; DB DD 36 33 20
ioi$n	ld	offset(ix), n		; D3 DD 36 33 20
	;***********************************************************
alt$n	ld	iir,a			; 76 ED 47
ioe$n	ld	iir,a			; DB ED 47
ioi$n	ld	iir,a			; D3 ED 47
alt$y	ld	a,iir			; 76 ED 57
ioe$n	ld	a,iir			; DB ED 57
ioi$n	ld	a,iir			; D3 ED 57
	;***********************************************************
alt$n	ld	sp,hl			; 76 F9
ioe$n	ld	sp,hl			; DB F9
ioi$n	ld	sp,hl			; D3 F9
	;***********************************************************
alt$n	ld	(bc),a			; 76 02
ioe$y	ld	(bc),a			; DB 02
ioi$y	ld	(bc),a			; D3 02
	;***********************************************************
alt$y	ld	a,(bc)			; 76 0A
ioe$y	ld	a,(bc)			; DB 0A
ioi$y	ld	a,(bc)			; D3 0A
	;***********************************************************
alt$n	ld	bc',bc			; 76 ED 49
ioe$n	ld	bc',bc			; DB ED 49
ioi$n	ld	bc',bc			; D3 ED 49
	;***********************************************************
	; load location (hl)
	; with location (de)
	; decrement de, hl
	; decrement bc
z80$b	ldd				; ED A8
	;***********************************************************
	; altd / ioe / ioi  modes
	; representative ldd opcodes
alt$n	ldd				; 76 ED A8
ioe$y	ldd				; DB ED A8
ioi$y	ldd				; D3 ED A8
	;***********************************************************
	; load location (hl)
	; with location (de)
	; decrement de, hl
	; decrement bc
	; repeat until bc = 0
z80$b	lddr				; ED B8
	;***********************************************************
	; altd / ioe / ioi  modes
	; representative lddr opcodes
alt$n	lddr				; 76 ED B8
ioe$y	lddr				; DB ED B8
ioi$y	lddr				; D3 ED B8
	;***********************************************************
	; load location (hl)
	; with location (de)
	; increment de, hl
	; decrement bc
z80$b	ldi				; ED A0
	;***********************************************************
	; altd / ioe / ioi  modes
	; representative ldi opcodes
alt$n	ldi				; 76 ED A0
ioe$y	ldi				; DB ED A0
ioi$y	ldi				; D3 ED A0
	;***********************************************************
	; load location (hl)
	; with location (de)
	; increment de, hl
	; decrement bc
	; repeat until bc = 0
z80$b	ldir				; ED B0
	;***********************************************************
	; altd / ioe / ioi  modes
	; representative ldir opcodes
alt$n	ldir				; 76 ED B0
ioe$y	ldir				; DB ED B0
ioi$y	ldir				; D3 ED B0
	;***********************************************************
	; ldp instructions
r$2k	ldp	(hl),hl			; ED 64
r$2k	ldp	(ix),hl			; DD 64
r$2k	ldp	(iy),hl			; FD 64
	;***********************************************************
r$2k	ldp	(mn),hl			; ED 65 84 05
r$2k	ldp	(mn),ix			; DD 65 84 05
r$2k	ldp	(mn),iy			; FD 65 84 05
	;***********************************************************
r$2k	ldp	hl,(hl)			; ED 6C
r$2k	ldp	hl,(ix)			; DD 6C
r$2k	ldp	hl,(iy)			; FD 6C
	;***********************************************************
r$2k	ldp	hl,(mn)			; ED 6D 84 05
r$2k	ldp	ix,(mn)			; DD 6D 84 05
r$2k	ldp	iy,(mn)			; FD 6D 84 05
	;***********************************************************
	; illegal addressing  modes
	; representative ldp opcodes
err$y	ldp	(bc),hl			;
	;***********************************************************
err$y	ldp	(mn),bc			;
	;***********************************************************
err$y	ldp	hl,(bc)			;
	;***********************************************************
err$y	ldp	bc,(mn)			;
	;***********************************************************
	; ljp instruction
r$2k	ljp	n,mn			; C7 84 05 20
	;***********************************************************
	; lret instruction
r$2k	lret				; ED 45
	;***********************************************************
	; multiply bc and de ==>> <hl:bc>
r$2k	mul				; F7
	;***********************************************************
	; 2's complement of 'a'
z80$b	neg				; ED 44
	;***********************************************************
	; altd / ioe / ioi  modes
	; representative neg opcodes
alt$y	neg				; 76 ED 44
ioe$n	neg				; DB ED 44
ioi$n	neg				; D3 ED 44
	;***********************************************************
	; no operation
z80$b	nop				; 00
	;***********************************************************
	; logical 'or' operand with 'a'
z80$b	or	a,(hl)			; B6
z80$b	or	a,offset(ix)		; DD B6 33
z80$b	or	a,offset(iy)		; FD B6 33
z80$b	or	a,(ix+offset)		; DD B6 33
z80$b	or	a,(iy+offset)		; FD B6 33
z80$b	or	a,a			; B7
z80$b	or	a,b			; B0
z80$b	or	a,c			; B1
z80$b	or	a,d			; B2
z80$b	or	a,e			; B3
z80$b	or	a,h			; B4
z80$b	or	a,l			; B5
z80$b	or	a,#n			; F6 20
z80$b	or	a, n			; F6 20
	;***********************************************************
z80$b	or	(hl)			; B6
z80$b	or	offset(ix)		; DD B6 33
z80$b	or	offset(iy)		; FD B6 33
z80$b	or	(ix+offset)		; DD B6 33
z80$b	or	(iy+offset)		; FD B6 33
z80$b	or	a			; B7
z80$b	or	b			; B0
z80$b	or	c			; B1
z80$b	or	d			; B2
z80$b	or	e			; B3
z80$b	or	h			; B4
z80$b	or	l			; B5
z80$b	or	#n			; F6 20
z80$b	or	 n			; F6 20
	;***********************************************************
r$2k	or	hl,de			; EC
r$2k	or	ix,de			; DD EC
r$2k	or	iy,de			; FD EC
	;***********************************************************
	; illegal constant values
	; representative or opcodes
err$y	or	a,(ix+128)		; DD B6 80
err$n	or	a,(ix+127)		; DD B6 7F
err$n	or	a,(ix+1)		; DD B6 01
err$n	or	a,(ix+0)		; DD B6 00
err$n	or	a,(ix-1)		; DD B6 FF
err$n	or	a,(ix-128)		; DD B6 80
err$y	or	a,(ix-129)		; DD B6 7F
	;***********************************************************
	; illegal addressing  modes
	; representative or opcodes
err$y	or	(hl+offset)		; B6
err$y	or	offset(hl)		; B6
	;***********************************************************
err$y	or	hl,ix			;
	;***********************************************************
err$y	or	hl,bc			;
err$y	or	ix,bc			;
err$y	or	iy,bc			;
	;***********************************************************
err$y	or	sp,de			;
	;***********************************************************
	; altd / ioe / ioi  modes
	; representative or opcodes
alt$y	or	a,(hl)			; 76 B6
ioe$y	or	a,(hl)			; DB B6
ioi$y	or	a,(hl)			; D3 B6
	;***********************************************************
alt$y	or	(hl)			; 76 B6
ioe$y	or	(hl)			; DB B6
ioi$y	or	(hl)			; D3 B6
	;***********************************************************
alt$y	or	a,c			; 76 B1
ioe$n	or	a,c			; DB B1
ioi$n	or	a,c			; D3 B1
	;***********************************************************
alt$y	or	c			; 76 B1
ioe$n	or	c			; DB B1
ioi$n	or	c			; D3 B1
	;***********************************************************
alt$y	or	a,#n			; 76 F6 20
ioe$n	or	a,#n			; DB F6 20
ioi$n	or	a,#n			; D3 F6 20
alt$y	or	a, n			; 76 F6 20
ioe$n	or	a, n			; DB F6 20
ioi$n	or	a, n			; D3 F6 20
	;***********************************************************
alt$y	or	#n			; 76 F6 20
ioe$n	or	#n			; DB F6 20
ioi$n	or	#n			; D3 F6 20
alt$y	or	 n			; 76 F6 20
ioe$n	or	 n			; DB F6 20
ioi$n	or	 n			; D3 F6 20
	;***********************************************************
alt$y	or	hl,de			; 76 EC
ioe$n	or	hl,de			; DB EC
ioi$n	or	hl,de			; D3 EC
	;***********************************************************
	; load output port (c)
	; with location (hl)
	; decrement hl and decrement b
	; repeat until b = 0
z80$x	otdr				; ED BB
	;***********************************************************
	; load output port (c)
	; with location (hl)
	; increment hl and decrement b
	; repeat until b = 0
z80$x	otir				; ED B3
	;***********************************************************
	; load output port (c) with reg
z80$x	out	(c),a			; ED 79
z80$x	out	(c),b			; ED 41
z80$x	out	(c),c			; ED 49
z80$x	out	(c),d			; ED 51
z80$x	out	(c),e			; ED 59
z80$x	out	(c),h			; ED 61
z80$x	out	(c),l			; ED 69
	;***********************************************************
	; load output port (n) with 'a'
z80$x	out	(n),a			; D3 20
	;***********************************************************
	; load output port (c)
	; with location (hl)
	; decrement hl and decrement b
z80$x	outd				; ED AB
	;***********************************************************
	; load output port (c)
	; with location (hl)
	; increment hl and decrement b
z80$x	outi				; ED A3
	;***********************************************************
	; load destination with top of stack
z80$b	pop	af			; F1
z80$b	pop	bc			; C1
z80$b	pop	de			; D1
z80$b	pop	hl			; E1
z80$b	pop	ix			; DD E1
z80$b	pop	iy			; FD E1
	;***********************************************************
r$2k	pop	ip			; ED 7E
	;***********************************************************
	; illegal addressing  modes
	; representative pop opcodes
err$y	pop	sp			;
	;***********************************************************
	; altd / ioe / ioi  modes
	; representative pop opcodes
alt$y	pop	af			; 76 F1
ioe$n	pop	af			; DB F1
ioi$n	pop	af			; D3 F1
	;***********************************************************
alt$y	pop	bc			; 76 C1
ioe$n	pop	bc			; DB C1
ioi$n	pop	bc			; D3 C1
	;***********************************************************
alt$n	pop	ix			; 76 DD E1
ioe$n	pop	ix			; DB DD E1
ioi$n	pop	ix			; D3 DD E1
	;***********************************************************
alt$n	pop	ip			; 76 ED 7E
ioe$n	pop	ip			; DB ED 7E
ioi$n	pop	ip			; D3 ED 7E
	;***********************************************************
	; put source on stack
z80$b	push	af			; F5
z80$b	push	bc			; C5
z80$b	push	de			; D5
z80$b	push	hl			; E5
z80$b	push	ix			; DD E5
z80$b	push	iy			; FD E5
	;***********************************************************
r$2k	push	ip			; ED 76
	;***********************************************************
	; illegal addressing  modes
	; representative push opcodes
err$y	push	sp			;
	;***********************************************************
	; altd / ioe / ioi  modes
	; representative push opcodes
alt$n	push	af			; 76 F5
ioe$n	push	af			; DB F5
ioi$n	push	af			; D3 F5
	;***********************************************************
alt$n	push	bc			; 76 C5
ioe$n	push	bc			; DB C5
ioi$n	push	bc			; D3 C5
	;***********************************************************
alt$n	push	ix			; 76 DD E5
ioe$n	push	ix			; DB DD E5
ioi$n	push	ix			; D3 DD E5
	;***********************************************************
alt$n	push	ip			; 76 ED 76
ioe$n	push	ip			; DB ED 76
ioi$n	push	ip			; D3 ED 76
	;***********************************************************
	; reset bit of location or register
z80$b	res	0,(hl)			; CB 86
z80$b	res	0,offset(ix)		; DD CB 33 86
z80$b	res	0,offset(iy)		; FD CB 33 86
z80$b	res	0,(ix+offset)		; DD CB 33 86
z80$b	res	0,(iy+offset)		; FD CB 33 86
z80$b	res	0,a			; CB 87
z80$b	res	0,b			; CB 80
z80$b	res	0,c			; CB 81
z80$b	res	0,d			; CB 82
z80$b	res	0,e			; CB 83
z80$b	res	0,h			; CB 84
z80$b	res	0,l			; CB 85
z80$b	res	1,(hl)			; CB 8E
z80$b	res	1,offset(ix)		; DD CB 33 8E
z80$b	res	1,offset(iy)		; FD CB 33 8E
z80$b	res	1,(ix+offset)		; DD CB 33 8E
z80$b	res	1,(iy+offset)		; FD CB 33 8E
z80$b	res	1,a			; CB 8F
z80$b	res	1,b			; CB 88
z80$b	res	1,c			; CB 89
z80$b	res	1,d			; CB 8A
z80$b	res	1,e			; CB 8B
z80$b	res	1,h			; CB 8C
z80$b	res	1,l			; CB 8D
z80$b	res	2,(hl)			; CB 96
z80$b	res	2,offset(ix)		; DD CB 33 96
z80$b	res	2,offset(iy)		; FD CB 33 96
z80$b	res	2,(ix+offset)		; DD CB 33 96
z80$b	res	2,(iy+offset)		; FD CB 33 96
z80$b	res	2,a			; CB 97
z80$b	res	2,b			; CB 90
z80$b	res	2,c			; CB 91
z80$b	res	2,d			; CB 92
z80$b	res	2,e			; CB 93
z80$b	res	2,h			; CB 94
z80$b	res	2,l			; CB 95
z80$b	res	3,(hl)			; CB 9E
z80$b	res	3,offset(ix)		; DD CB 33 9E
z80$b	res	3,offset(iy)		; FD CB 33 9E
z80$b	res	3,(ix+offset)		; DD CB 33 9E
z80$b	res	3,(iy+offset)		; FD CB 33 9E
z80$b	res	3,a			; CB 9F
z80$b	res	3,b			; CB 98
z80$b	res	3,c			; CB 99
z80$b	res	3,d			; CB 9A
z80$b	res	3,e			; CB 9B
z80$b	res	3,h			; CB 9C
z80$b	res	3,l			; CB 9D
z80$b	res	4,(hl)			; CB A6
z80$b	res	4,offset(ix)		; DD CB 33 A6
z80$b	res	4,offset(iy)		; FD CB 33 A6
z80$b	res	4,(ix+offset)		; DD CB 33 A6
z80$b	res	4,(iy+offset)		; FD CB 33 A6
z80$b	res	4,a			; CB A7
z80$b	res	4,b			; CB A0
z80$b	res	4,c			; CB A1
z80$b	res	4,d			; CB A2
z80$b	res	4,e			; CB A3
z80$b	res	4,h			; CB A4
z80$b	res	4,l			; CB A5
z80$b	res	5,(hl)			; CB AE
z80$b	res	5,offset(ix)		; DD CB 33 AE
z80$b	res	5,offset(iy)		; FD CB 33 AE
z80$b	res	5,(ix+offset)		; DD CB 33 AE
z80$b	res	5,(iy+offset)		; FD CB 33 AE
z80$b	res	5,a			; CB AF
z80$b	res	5,b			; CB A8
z80$b	res	5,c			; CB A9
z80$b	res	5,d			; CB AA
z80$b	res	5,e			; CB AB
z80$b	res	5,h			; CB AC
z80$b	res	5,l			; CB AD
z80$b	res	6,(hl)			; CB B6
z80$b	res	6,offset(ix)		; DD CB 33 B6
z80$b	res	6,offset(iy)		; FD CB 33 B6
z80$b	res	6,(ix+offset)		; DD CB 33 B6
z80$b	res	6,(iy+offset)		; FD CB 33 B6
z80$b	res	6,a			; CB B7
z80$b	res	6,b			; CB B0
z80$b	res	6,c			; CB B1
z80$b	res	6,d			; CB B2
z80$b	res	6,e			; CB B3
z80$b	res	6,h			; CB B4
z80$b	res	6,l			; CB B5
z80$b	res	7,(hl)			; CB BE
z80$b	res	7,offset(ix)		; DD CB 33 BE
z80$b	res	7,offset(iy)		; FD CB 33 BE
z80$b	res	7,(ix+offset)		; DD CB 33 BE
z80$b	res	7,(iy+offset)		; FD CB 33 BE
z80$b	res	7,a			; CB BF
z80$b	res	7,b			; CB B8
z80$b	res	7,c			; CB B9
z80$b	res	7,d			; CB BA
z80$b	res	7,e			; CB BB
z80$b	res	7,h			; CB BC
z80$b	res	7,l			; CB BD
	;***********************************************************
	; illegal constant values
	; representative res opcodes
err$y	res	0,(ix+128)		; DD CB 80 86
err$n	res	0,(ix+127)		; DD CB 7F 86
err$n	res	0,(ix+1)		; DD CB 01 86
err$n	res	0,(ix+0)		; DD CB 00 86
err$n	res	0,(ix-1)		; DD CB FF 86
err$n	res	0,(ix-128)		; DD CB 80 86
err$y	res	0,(ix-129)		; DD CB 7F 86
	;***********************************************************
	; illegal addressing  modes
	; representative res opcodes
err$y	res	0,(hl+offset)		; CB 86
err$y	res	0,offset(hl)		; CB 86
	;***********************************************************
err$y	res	0,hl			;
err$y	res	0,ix			;
	;***********************************************************
	; altd / ioe / ioi  modes
	; representative res opcodes
alt$y	res	1,(hl)			; 76 CB 8E
ioe$y	res	1,(hl)			; DB CB 8E
ioi$y	res	1,(hl)			; D3 CB 8E
alt$y	res	1,offset(ix)		; 76 DD CB 33 8E
ioe$y	res	1,offset(ix)		; DB DD CB 33 8E
ioi$y	res	1,offset(ix)		; D3 DD CB 33 8E
alt$y	res	1,(ix+offset)		; 76 DD CB 33 8E
ioe$y	res	1,(ix+offset)		; DB DD CB 33 8E
ioi$y	res	1,(ix+offset)		; D3 DD CB 33 8E
	;***********************************************************
alt$y	res	1,c			; 76 CB 89
ioe$n	res	1,c			; DB CB 89
ioi$n	res	1,c			; D3 CB 89
	;***********************************************************
	; return from subroutine
z80$b	ret				; C9
	;***********************************************************
	; return from subroutine if condition is true
z80$b	ret	C			; D8
z80$b	ret	M			; F8
z80$b	ret	NC			; D0
z80$b	ret	NZ			; C0
z80$b	ret	P			; F0
z80$b	ret	PE			; E8
z80$b	ret	PO			; E0
z80$b	ret	Z			; C8
	;***********************************************************
	; return from interrupt
z80$b	reti				; ED 4D
	;***********************************************************
	; return from non-maskable interrupt
z80$x	retn				; ED 45
	;***********************************************************
	; rotate left through carry
z80$b	rl	(hl)			; CB 16
z80$b	rl	offset(ix)		; DD CB 33 16
z80$b	rl	offset(iy)		; FD CB 33 16
z80$b	rl	(ix+offset)		; DD CB 33 16
z80$b	rl	(iy+offset)		; FD CB 33 16
z80$b	rl	a			; CB 17
z80$b	rl	b			; CB 10
z80$b	rl	c			; CB 11
z80$b	rl	d			; CB 12
z80$b	rl	e			; CB 13
z80$b	rl	h			; CB 14
z80$b	rl	l			; CB 15
	;***********************************************************
r$2k	rl	de			; F3
	;***********************************************************
	; illegal constant values
	; representative rl opcodes
err$y	rl	(ix+128)		; DD CB 80 16
err$n	rl	(ix+127)		; DD CB 7F 16
err$n	rl	(ix+1)			; DD CB 01 16
err$n	rl	(ix+0)			; DD CB 00 16
err$n	rl	(ix-1)			; DD CB FF 16
err$n	rl	(ix-128)		; DD CB 80 16
err$y	rl	(ix-129)		; DD CB 7F 16
	;***********************************************************
	; illegal addressing  modes
	; representative rl opcodes
err$y	rl	(hl+offset)		; CB 16
err$y	rl	offset(hl)		; CB 16
	;***********************************************************
err$y	rl	bc			;
	;***********************************************************
	; altd / ioe / ioi  modes
	; representative rl opcodes
alt$y	rl	(hl)			; 76 CB 16
ioe$y	rl	(hl)			; DB CB 16
ioi$y	rl	(hl)			; D3 CB 16
	;***********************************************************
alt$y	rl	c			; 76 CB 11
ioe$n	rl	c			; DB CB 11
ioi$n	rl	c			; D3 CB 11
	;***********************************************************
alt$y	rl	de			; 76 F3
ioe$n	rl	de			; DB F3
ioi$n	rl	de			; D3 F3
	;***********************************************************
	; rotate left 'a' with carry
z80$b	rla				; 17
	;***********************************************************
	; altd / ioe / ioi  modes
	; representative rla opcodes
alt$y	rla				; 76 17
ioe$n	rla				; DB 17
ioi$n	rla				; D3 17
	;***********************************************************
	; rotate left circular
z80$b	rlc	(hl)			; CB 06
z80$b	rlc	offset(ix)		; DD CB 33 06
z80$b	rlc	offset(iy)		; FD CB 33 06
z80$b	rlc	(ix+offset)		; DD CB 33 06
z80$b	rlc	(iy+offset)		; FD CB 33 06
z80$b	rlc	a			; CB 07
z80$b	rlc	b			; CB 00
z80$b	rlc	c			; CB 01
z80$b	rlc	d			; CB 02
z80$b	rlc	e			; CB 03
z80$b	rlc	h			; CB 04
z80$b	rlc	l			; CB 05
	;***********************************************************
	; illegal constant values
	; representative rlc opcodes
err$y	rlc	(ix+128)		; DD CB 80 06
err$n	rlc	(ix+127)		; DD CB 7F 06
err$n	rlc	(ix+1)			; DD CB 01 06
err$n	rlc	(ix+0)			; DD CB 00 06
err$n	rlc	(ix-1)			; DD CB FF 06
err$n	rlc	(ix-128)		; DD CB 80 06
err$y	rlc	(ix-129)		; DD CB 7F 06
	;***********************************************************
	; illegal addressing  modes
	; representative rlc opcodes
err$y	rlc	(hl+offset)		; CB 06
err$y	rlc	offset(hl)		; CB 06
	;***********************************************************
err$y	rlc	bc			;
	;***********************************************************
	; altd / ioe / ioi  modes
	; representative rlc opcodes
alt$y	rlc	(hl)			; 76 CB 06
ioe$y	rlc	(hl)			; DB CB 06
ioi$y	rlc	(hl)			; D3 CB 06
	;***********************************************************
alt$y	rlc	c			; 76 CB 01
ioe$n	rlc	c			; DB CB 01
ioi$n	rlc	c			; D3 CB 01
	;***********************************************************
	; rotate left 'a' circular
z80$b	rlca				; 07
	;***********************************************************
	; altd / ioe / ioi  modes
	; representative rlca opcodes
alt$y	rlca				; 76 07
ioe$n	rlca				; DB 07
ioi$n	rlca				; D3 07
	;***********************************************************
	; rotate digit left and right
	; between 'a' and location (hl)
z80$x	rld				; ED 6F
	;***********************************************************
	; rotate right through carry
z80$b	rr	(hl)			; CB 1E
z80$b	rr	offset(ix)		; DD CB 33 1E
z80$b	rr	offset(iy)		; FD CB 33 1E
z80$b	rr	(ix+offset)		; DD CB 33 1E
z80$b	rr	(iy+offset)		; FD CB 33 1E
z80$b	rr	a			; CB 1F
z80$b	rr	b			; CB 18
z80$b	rr	c			; CB 19
z80$b	rr	d			; CB 1A
z80$b	rr	e			; CB 1B
z80$b	rr	h			; CB 1C
z80$b	rr	l			; CB 1D
	;***********************************************************
r$2k	rr	de			; FB
r$2k	rr	hl			; FC
r$2k	rr	ix			; DD FC
r$2k	rr	iy			; FD FC
	;***********************************************************
	; illegal constant values
	; representative rr opcodes
err$y	rr	(ix+128)		; DD CB 80 1E
err$n	rr	(ix+127)		; DD CB 7F 1E
err$n	rr	(ix+1)			; DD CB 01 1E
err$n	rr	(ix+0)			; DD CB 00 1E
err$n	rr	(ix-1)			; DD CB FF 1E
err$n	rr	(ix-128)		; DD CB 80 1E
err$y	rr	(ix-129)		; DD CB 7F 1E
	;***********************************************************
	; illegal addressing  modes
	; representative rr opcodes
err$y	rr	(hl+offset)		; CB 1E
err$y	rr	offset(hl)		; CB 1E
	;***********************************************************
err$y	rr	bc			;
	;***********************************************************
	; altd / ioe / ioi  modes
	; representative rr opcodes
alt$y	rr	(hl)			; 76 CB 1E
ioe$y	rr	(hl)			; DB CB 1E
ioi$y	rr	(hl)			; D3 CB 1E
	;***********************************************************
alt$y	rr	c			; 76 CB 19
ioe$n	rr	c			; DB CB 19
ioi$n	rr	c			; D3 CB 19
	;***********************************************************
alt$y	rr	de			; 76 FB
ioe$n	rr	de			; DB FB
ioi$n	rr	de			; D3 FB
	;***********************************************************
	; rotate 'a' right with carry
z80$b	rra				; 1F
	;***********************************************************
	; altd / ioe / ioi  modes
	; representative rra opcodes
alt$y	rra				; 76 1F
ioe$n	rra				; DB 1F
ioi$n	rra				; D3 1F
	;***********************************************************
	; rotate right circular
z80$b	rrc	(hl)			; CB 0E
z80$b	rrc	offset(ix)		; DD CB 33 0E
z80$b	rrc	offset(iy)		; FD CB 33 0E
z80$b	rrc	(ix+offset)		; DD CB 33 0E
z80$b	rrc	(iy+offset)		; FD CB 33 0E
z80$b	rrc	a			; CB 0F
z80$b	rrc	b			; CB 08
z80$b	rrc	c			; CB 09
z80$b	rrc	d			; CB 0A
z80$b	rrc	e			; CB 0B
z80$b	rrc	h			; CB 0C
z80$b	rrc	l			; CB 0D
	;***********************************************************
	; illegal constant values
	; representative rrc opcodes
err$y	rrc	(ix+128)		; DD CB 80 0E
err$n	rrc	(ix+127)		; DD CB 7F 0E
err$n	rrc	(ix+1)			; DD CB 01 0E
err$n	rrc	(ix+0)			; DD CB 00 0E
err$n	rrc	(ix-1)			; DD CB FF 0E
err$n	rrc	(ix-128)		; DD CB 80 0E
err$y	rrc	(ix-129)		; DD CB 7F 0E
	;***********************************************************
	; illegal addressing  modes
	; representative rrc opcodes
err$y	rrc	(hl+offset)		; CB 0E
err$y	rrc	offset(hl)		; CB 0E
	;***********************************************************
err$y	rrc	bc			;
	;***********************************************************
	; altd / ioe / ioi  modes
	; representative rrc opcodes
alt$y	rrc	(hl)			; 76 CB 0E
ioe$y	rrc	(hl)			; DB CB 0E
ioi$y	rrc	(hl)			; D3 CB 0E
	;***********************************************************
alt$y	rrc	c			; 76 CB 09
ioe$n	rrc	c			; DB CB 09
ioi$n	rrc	c			; D3 CB 09
	;***********************************************************
	; rotate 'a' right circular
z80$b	rrca				; 0F
	;***********************************************************
	; altd / ioe / ioi  modes
	; representative rrca opcodes
alt$y	rrca				; 76 0F
ioe$n	rrca				; DB 0F
ioi$n	rrca				; D3 0F
	;***********************************************************
	; rotate digit right and left
	; between 'a' and location (hl)
z80$x	rrd				; ED 67
	;***********************************************************
	; restart location
z80$x	rst	0x00			; C7
z80$x	rst	0x08			; CF
z80$b	rst	0x10			; D7
z80$b	rst	0x18			; DF
z80$b	rst	0x20			; E7
z80$b	rst	0x28			; EF
z80$x	rst	0x30			; F7
z80$b	rst	0x38			; FF
	;***********************************************************
	; subtract with carry to 'a'
z80$b	sbc	a,(hl)			; 9E
z80$b	sbc	a,offset(ix)		; DD 9E 33
z80$b	sbc	a,offset(iy)		; FD 9E 33
z80$b	sbc	a,(ix+offset)		; DD 9E 33
z80$b	sbc	a,(iy+offset)		; FD 9E 33
z80$b	sbc	a,a			; 9F
z80$b	sbc	a,b			; 98
z80$b	sbc	a,c			; 99
z80$b	sbc	a,d			; 9A
z80$b	sbc	a,e			; 9B
z80$b	sbc	a,h			; 9C
z80$b	sbc	a,l			; 9D
z80$b	sbc	a,#n			; DE 20
z80$b	sbc	a, n			; DE 20
	;***********************************************************
z80$b	sbc	(hl)			; 9E
z80$b	sbc	offset(ix)		; DD 9E 33
z80$b	sbc	offset(iy)		; FD 9E 33
z80$b	sbc	(ix+offset)		; DD 9E 33
z80$b	sbc	(iy+offset)		; FD 9E 33
z80$b	sbc	a			; 9F
z80$b	sbc	b			; 98
z80$b	sbc	c			; 99
z80$b	sbc	d			; 9A
z80$b	sbc	e			; 9B
z80$b	sbc	h			; 9C
z80$b	sbc	l			; 9D
z80$b	sbc	#n			; DE 20
z80$b	sbc	 n			; DE 20
	;***********************************************************
	; add with carry register pair to 'hl'
z80$b	sbc	hl,bc			; ED 42
z80$b	sbc	hl,de			; ED 52
z80$b	sbc	hl,hl			; ED 62
z80$b	sbc	hl,sp			; ED 72
	;***********************************************************
	; illegal constant values
	; representative subtract with carry opcodes
err$y	sbc	a,(ix+128)		; DD 9E 80
err$n	sbc	a,(ix+127)		; DD 9E 7F
err$n	sbc	a,(ix+1)		; DD 9E 01
err$n	sbc	a,(ix+0)		; DD 9E 00
err$n	sbc	a,(ix-1)		; DD 9E FF
err$n	sbc	a,(ix-128)		; DD 9E 80
err$y	sbc	a,(ix-129)		; DD 9E 7F
	;***********************************************************
	; illegal addressing  modes
	; representative subtract with carry opcodes
err$y	sbc	(hl+offset)		; 9E
err$y	sbc	offset(hl)		; 9E
	;***********************************************************
err$y	sbc	hl,ix			;
	;***********************************************************
err$y	sbc	ix,bc			;
err$y	sbc	iy,bc			;
	;***********************************************************
err$y	sbc	sp,#n			;
err$y	sbc	sp, n			;
	;***********************************************************
	; altd / ioe / ioi  modes
	; representative subtract with carry opcodes
alt$y	sbc	a,(hl)			; 76 9E
ioe$y	sbc	a,(hl)			; DB 9E
ioi$y	sbc	a,(hl)			; D3 9E
	;***********************************************************
alt$y	sbc	(hl)			; 76 9E
ioe$y	sbc	(hl)			; DB 9E
ioi$y	sbc	(hl)			; D3 9E
	;***********************************************************
alt$y	sbc	a,c			; 76 99
ioe$n	sbc	a,c			; DB 99
ioi$n	sbc	a,c			; D3 99
	;***********************************************************
alt$y	sbc	c			; 76 99
ioe$n	sbc	c			; DB 99
ioi$n	sbc	c			; D3 99
	;***********************************************************
alt$y	sbc	a,#n			; 76 DE 20
ioe$n	sbc	a,#n			; DB DE 20
ioi$n	sbc	a,#n			; D3 DE 20
alt$y	sbc	a, n			; 76 DE 20
ioe$n	sbc	a, n			; DB DE 20
ioi$n	sbc	a, n			; D3 DE 20
	;***********************************************************
alt$y	sbc	#n			; 76 DE 20
ioe$n	sbc	#n			; DB DE 20
ioi$n	sbc	#n			; D3 DE 20
alt$y	sbc	 n			; 76 DE 20
ioe$n	sbc	 n			; DB DE 20
ioi$n	sbc	 n			; D3 DE 20
	;***********************************************************
alt$y	sbc	hl,bc			; 76 ED 42
ioe$n	sbc	hl,bc			; DB ED 42
ioi$n	sbc	hl,bc			; D3 ED 42
	;***********************************************************
	; set carry flag (C=1)
z80$b	scf				; 37
	;***********************************************************
	; altd / ioe / ioi  modes
	; representative scf opcodes
alt$y	scf				; 76 37
ioe$n	scf				; DB 37
ioi$n	scf				; D3 37
	;***********************************************************
	; set bit of location or register
z80$b	set	0,(hl)			; CB C6
z80$b	set	0,offset(ix)		; DD CB 33 C6
z80$b	set	0,offset(iy)		; FD CB 33 C6
z80$b	set	0,(ix+offset)		; DD CB 33 C6
z80$b	set	0,(iy+offset)		; FD CB 33 C6
z80$b	set	0,a			; CB C7
z80$b	set	0,b			; CB C0
z80$b	set	0,c			; CB C1
z80$b	set	0,d			; CB C2
z80$b	set	0,e			; CB C3
z80$b	set	0,h			; CB C4
z80$b	set	0,l			; CB C5
z80$b	set	1,(hl)			; CB CE
z80$b	set	1,offset(ix)		; DD CB 33 CE
z80$b	set	1,offset(iy)		; FD CB 33 CE
z80$b	set	1,(ix+offset)		; DD CB 33 CE
z80$b	set	1,(iy+offset)		; FD CB 33 CE
z80$b	set	1,a			; CB CF
z80$b	set	1,b			; CB C8
z80$b	set	1,c			; CB C9
z80$b	set	1,d			; CB CA
z80$b	set	1,e			; CB CB
z80$b	set	1,h			; CB CC
z80$b	set	1,l			; CB CD
z80$b	set	2,(hl)			; CB D6
z80$b	set	2,offset(ix)		; DD CB 33 D6
z80$b	set	2,offset(iy)		; FD CB 33 D6
z80$b	set	2,(ix+offset)		; DD CB 33 D6
z80$b	set	2,(iy+offset)		; FD CB 33 D6
z80$b	set	2,a			; CB D7
z80$b	set	2,b			; CB D0
z80$b	set	2,c			; CB D1
z80$b	set	2,d			; CB D2
z80$b	set	2,e			; CB D3
z80$b	set	2,h			; CB D4
z80$b	set	2,l			; CB D5
z80$b	set	3,(hl)			; CB DE
z80$b	set	3,offset(ix)		; DD CB 33 DE
z80$b	set	3,offset(iy)		; FD CB 33 DE
z80$b	set	3,(ix+offset)		; DD CB 33 DE
z80$b	set	3,(iy+offset)		; FD CB 33 DE
z80$b	set	3,a			; CB DF
z80$b	set	3,b			; CB D8
z80$b	set	3,c			; CB D9
z80$b	set	3,d			; CB DA
z80$b	set	3,e			; CB DB
z80$b	set	3,h			; CB DC
z80$b	set	3,l			; CB DD
z80$b	set	4,(hl)			; CB E6
z80$b	set	4,offset(ix)		; DD CB 33 E6
z80$b	set	4,offset(iy)		; FD CB 33 E6
z80$b	set	4,(ix+offset)		; DD CB 33 E6
z80$b	set	4,(iy+offset)		; FD CB 33 E6
z80$b	set	4,a			; CB E7
z80$b	set	4,b			; CB E0
z80$b	set	4,c			; CB E1
z80$b	set	4,d			; CB E2
z80$b	set	4,e			; CB E3
z80$b	set	4,h			; CB E4
z80$b	set	4,l			; CB E5
z80$b	set	5,(hl)			; CB EE
z80$b	set	5,offset(ix)		; DD CB 33 EE
z80$b	set	5,offset(iy)		; FD CB 33 EE
z80$b	set	5,(ix+offset)		; DD CB 33 EE
z80$b	set	5,(iy+offset)		; FD CB 33 EE
z80$b	set	5,a			; CB EF
z80$b	set	5,b			; CB E8
z80$b	set	5,c			; CB E9
z80$b	set	5,d			; CB EA
z80$b	set	5,e			; CB EB
z80$b	set	5,h			; CB EC
z80$b	set	5,l			; CB ED
z80$b	set	6,(hl)			; CB F6
z80$b	set	6,offset(ix)		; DD CB 33 F6
z80$b	set	6,offset(iy)		; FD CB 33 F6
z80$b	set	6,(ix+offset)		; DD CB 33 F6
z80$b	set	6,(iy+offset)		; FD CB 33 F6
z80$b	set	6,a			; CB F7
z80$b	set	6,b			; CB F0
z80$b	set	6,c			; CB F1
z80$b	set	6,d			; CB F2
z80$b	set	6,e			; CB F3
z80$b	set	6,h			; CB F4
z80$b	set	6,l			; CB F5
z80$b	set	7,(hl)			; CB FE
z80$b	set	7,offset(ix)		; DD CB 33 FE
z80$b	set	7,offset(iy)		; FD CB 33 FE
z80$b	set	7,(ix+offset)		; DD CB 33 FE
z80$b	set	7,(iy+offset)		; FD CB 33 FE
z80$b	set	7,a			; CB FF
z80$b	set	7,b			; CB F8
z80$b	set	7,c			; CB F9
z80$b	set	7,d			; CB FA
z80$b	set	7,e			; CB FB
z80$b	set	7,h			; CB FC
z80$b	set	7,l			; CB FD
	;***********************************************************
	; illegal constant values
	; representative set opcodes
err$y	set	0,(ix+128)		; DD CB 80 C6
err$n	set	0,(ix+127)		; DD CB 7F C6
err$n	set	0,(ix+1)		; DD CB 01 C6
err$n	set	0,(ix+0)		; DD CB 00 C6
err$n	set	0,(ix-1)		; DD CB FF C6
err$n	set	0,(ix-128)		; DD CB 80 C6
err$y	set	0,(ix-129)		; DD CB 7F C6
	;***********************************************************
	; illegal addressing  modes
	; representative set opcodes
err$y	set	0,(hl+offset)		; CB C6
err$y	set	0,offset(hl)		; CB C6
	;***********************************************************
err$y	set	0,hl			;
err$y	set	0,ix			;
	;***********************************************************
	; altd / ioe / ioi  modes
	; representative set opcodes
alt$y	set	1,(hl)			; 76 CB CE
ioe$y	set	1,(hl)			; DB CB CE
ioi$y	set	1,(hl)			; D3 CB CE
alt$y	set	1,offset(ix)		; 76 DD CB 33 CE
ioe$y	set	1,offset(ix)		; DB DD CB 33 CE
ioi$y	set	1,offset(ix)		; D3 DD CB 33 CE
alt$y	set	1,(ix+offset)		; 76 DD CB 33 CE
ioe$y	set	1,(ix+offset)		; DB DD CB 33 CE
ioi$y	set	1,(ix+offset)		; D3 DD CB 33 CE
	;***********************************************************
alt$y	set	1,c			; 76 CB C9
ioe$n	set	1,c			; DB CB C9
ioi$n	set	1,c			; D3 CB C9
	;***********************************************************
	; shift operand left arithmetic
z80$b	sla	(hl)			; CB 26
z80$b	sla	offset(ix)		; DD CB 33 26
z80$b	sla	offset(iy)		; FD CB 33 26
z80$b	sla	(ix+offset)		; DD CB 33 26
z80$b	sla	(iy+offset)		; FD CB 33 26
z80$b	sla	a			; CB 27
z80$b	sla	b			; CB 20
z80$b	sla	c			; CB 21
z80$b	sla	d			; CB 22
z80$b	sla	e			; CB 23
z80$b	sla	h			; CB 24
z80$b	sla	l			; CB 25
	;***********************************************************
	; illegal constant values
	; representative sla opcodes
err$y	sla	(ix+128)		; DD CB 80 26
err$n	sla	(ix+127)		; DD CB 7F 26
err$n	sla	(ix+1)			; DD CB 01 26
err$n	sla	(ix+0)			; DD CB 00 26
err$n	sla	(ix-1)			; DD CB FF 26
err$n	sla	(ix-128)		; DD CB 80 26
err$y	sla	(ix-129)		; DD CB 7F 26
	;***********************************************************
	; illegal addressing  modes
	; representative sla opcodes
err$y	sla	(hl+offset)		; CB 26
err$y	sla	offset(hl)		; CB 26
	;***********************************************************
err$y	sla	bc			;
	;***********************************************************
	; altd / ioe / ioi  modes
	; representative sla opcodes
alt$y	sla	(hl)			; 76 CB 26
ioe$y	sla	(hl)			; DB CB 26
ioi$y	sla	(hl)			; D3 CB 26
	;***********************************************************
alt$y	sla	c			; 76 CB 21
ioe$n	sla	c			; DB CB 21
ioi$n	sla	c			; D3 CB 21
	;***********************************************************
	; shift operand right arithmetic
z80$b	sra	(hl)			; CB 2E
z80$b	sra	offset(ix)		; DD CB 33 2E
z80$b	sra	offset(iy)		; FD CB 33 2E
z80$b	sra	(ix+offset)		; DD CB 33 2E
z80$b	sra	(iy+offset)		; FD CB 33 2E
z80$b	sra	a			; CB 2F
z80$b	sra	b			; CB 28
z80$b	sra	c			; CB 29
z80$b	sra	d			; CB 2A
z80$b	sra	e			; CB 2B
z80$b	sra	h			; CB 2C
z80$b	sra	l			; CB 2D
	;***********************************************************
	; illegal constant values
	; representative sra opcodes
err$y	sra	(ix+128)		; DD CB 80 2E
err$n	sra	(ix+127)		; DD CB 7F 2E
err$n	sra	(ix+1)			; DD CB 01 2E
err$n	sra	(ix+0)			; DD CB 00 2E
err$n	sra	(ix-1)			; DD CB FF 2E
err$n	sra	(ix-128)		; DD CB 80 2E
err$y	sra	(ix-129)		; DD CB 7F 2E
	;***********************************************************
	; illegal addressing  modes
	; representative sra opcodes
err$y	sra	(hl+offset)		; CB 2E
err$y	sra	offset(hl)		; CB 2E
	;***********************************************************
err$y	sra	bc			;
	;***********************************************************
	; altd / ioe / ioi  modes
	; representative sra opcodes
alt$y	sra	(hl)			; 76 CB 2E
ioe$y	sra	(hl)			; DB CB 2E
ioi$y	sra	(hl)			; D3 CB 2E
	;***********************************************************
alt$y	sra	c			; 76 CB 29
ioe$n	sra	c			; DB CB 29
ioi$n	sra	c			; D3 CB 29
	;***********************************************************
	; shift operand right logical
z80$b	srl	(hl)			; CB 3E
z80$b	srl	offset(ix)		; DD CB 33 3E
z80$b	srl	offset(iy)		; FD CB 33 3E
z80$b	srl	(ix+offset)		; DD CB 33 3E
z80$b	srl	(iy+offset)		; FD CB 33 3E
z80$b	srl	a			; CB 3F
z80$b	srl	b			; CB 38
z80$b	srl	c			; CB 39
z80$b	srl	d			; CB 3A
z80$b	srl	e			; CB 3B
z80$b	srl	h			; CB 3C
z80$b	srl	l			; CB 3D
	;***********************************************************
	; illegal constant values
	; representative srl opcodes
err$y	srl	(ix+128)		; DD CB 80 3E
err$n	srl	(ix+127)		; DD CB 7F 3E
err$n	srl	(ix+1)			; DD CB 01 3E
err$n	srl	(ix+0)			; DD CB 00 3E
err$n	srl	(ix-1)			; DD CB FF 3E
err$n	srl	(ix-128)		; DD CB 80 3E
err$y	srl	(ix-129)		; DD CB 7F 3E
	;***********************************************************
	; illegal addressing  modes
	; representative srl opcodes
err$y	srl	(hl+offset)		; CB 3E
err$y	srl	offset(hl)		; CB 3E
	;***********************************************************
err$y	srl	bc			;
	;***********************************************************
	; altd / ioe / ioi  modes
	; representative srl opcodes
alt$y	srl	(hl)			; 76 CB 3E
ioe$y	srl	(hl)			; DB CB 3E
ioi$y	srl	(hl)			; D3 CB 3E
	;***********************************************************
alt$y	srl	c			; 76 CB 39
ioe$n	srl	c			; DB CB 39
ioi$n	srl	c			; D3 CB 39
	;***********************************************************
	; subtract operand from 'a'
z80$b	sub	a,(hl)			; 96
z80$b	sub	a,offset(ix)		; DD 96 33
z80$b	sub	a,offset(iy)		; FD 96 33
z80$b	sub	a,(ix+offset)		; DD 96 33
z80$b	sub	a,(iy+offset)		; FD 96 33
z80$b	sub	a,a			; 97
z80$b	sub	a,b			; 90
z80$b	sub	a,c			; 91
z80$b	sub	a,d			; 92
z80$b	sub	a,e			; 93
z80$b	sub	a,h			; 94
z80$b	sub	a,l			; 95
z80$b	sub	a,#n			; D6 20
z80$b	sub	a, n			; D6 20
	;***********************************************************
z80$b	sub	(hl)			; 96
z80$b	sub	offset(ix)		; DD 96 33
z80$b	sub	offset(iy)		; FD 96 33
z80$b	sub	(ix+offset)		; DD 96 33
z80$b	sub	(iy+offset)		; FD 96 33
z80$b	sub	a			; 97
z80$b	sub	b			; 90
z80$b	sub	c			; 91
z80$b	sub	d			; 92
z80$b	sub	e			; 93
z80$b	sub	h			; 94
z80$b	sub	l			; 95
z80$b	sub	#n			; D6 20
z80$b	sub	 n			; D6 20
	;***********************************************************
	; illegal constant values
	; representative subtract opcodes
err$y	sub	a,(ix+128)		; DD 96 80
err$n	sub	a,(ix+127)		; DD 96 7F
err$n	sub	a,(ix+1)		; DD 96 01
err$n	sub	a,(ix+0)		; DD 96 00
err$n	sub	a,(ix-1)		; DD 96 FF
err$n	sub	a,(ix-128)		; DD 96 80
err$y	sub	a,(ix-129)		; DD 96 7F
	;***********************************************************
	; illegal addressing  modes
	; representative sub opcodes
err$y	sub	(hl+offset)		; 96
err$y	sub	offset(hl)		; 96
	;***********************************************************
err$y	sub	hl,de			;
err$y	sub	ix,de			;
err$y	sub	iy,de			;
	;***********************************************************
	; altd / ioe / ioi  modes
	; representative SUB opcodes
alt$y	sub	a,(hl)			; 76 96
ioe$y	sub	a,(hl)			; DB 96
ioi$y	sub	a,(hl)			; D3 96
	;***********************************************************
alt$y	sub	(hl)			; 76 96
ioe$y	sub	(hl)			; DB 96
ioi$y	sub	(hl)			; D3 96
	;***********************************************************
alt$y	sub	a,c			; 76 91
ioe$n	sub	a,c			; DB 91
ioi$n	sub	a,c			; D3 91
	;***********************************************************
alt$y	sub	c			; 76 91
ioe$n	sub	c			; DB 91
ioi$n	sub	c			; D3 91
	;***********************************************************
alt$y	sub	a,#n			; 76 D6 20
ioe$n	sub	a,#n			; DB D6 20
ioi$n	sub	a,#n			; D3 D6 20
alt$y	sub	a, n			; 76 D6 20
ioe$n	sub	a, n			; DB D6 20
ioi$n	sub	a, n			; D3 D6 20
	;***********************************************************
alt$y	sub	#n			; 76 D6 20
ioe$n	sub	#n			; DB D6 20
ioi$n	sub	#n			; D3 D6 20
alt$y	sub	 n			; 76 D6 20
ioe$n	sub	 n			; DB D6 20
ioi$n	sub	 n			; D3 D6 20
	;***********************************************************
	; logical 'xor' operand with 'a'
z80$b	xor	a,(hl)			; AE
z80$b	xor	a,offset(ix)		; DD AE 33
z80$b	xor	a,offset(iy)		; FD AE 33
z80$b	xor	a,(ix+offset)		; DD AE 33
z80$b	xor	a,(iy+offset)		; FD AE 33
z80$b	xor	a,a			; AF
z80$b	xor	a,b			; A8
z80$b	xor	a,c			; A9
z80$b	xor	a,d			; AA
z80$b	xor	a,e			; AB
z80$b	xor	a,h			; AC
z80$b	xor	a,l			; AD
z80$b	xor	a,#n			; EE 20
z80$b	xor	a, n			; EE 20
	;***********************************************************
z80$b	xor	(hl)			; AE
z80$b	xor	offset(ix)		; DD AE 33
z80$b	xor	offset(iy)		; FD AE 33
z80$b	xor	(ix+offset)		; DD AE 33
z80$b	xor	(iy+offset)		; FD AE 33
z80$b	xor	a			; AF
z80$b	xor	b			; A8
z80$b	xor	c			; A9
z80$b	xor	d			; AA
z80$b	xor	e			; AB
z80$b	xor	h			; AC
z80$b	xor	l			; AD
z80$b	xor	#n			; EE 20
z80$b	xor	 n			; EE 20
	;***********************************************************
	; illegal addressing  modes
	; representative xor opcodes
err$y	xor	(hl+offset)		; AE
err$y	xor	offset(hl)		; AE
	;***********************************************************
err$y	xor	hl,de			;
err$y	xor	ix,de			;
err$y	xor	iy,de			;
	;***********************************************************
	; altd / ioe / ioi  modes
	; representative xor opcodes
alt$y	xor	a,(hl)			; 76 AE
ioe$y	xor	a,(hl)			; DB AE
ioi$y	xor	a,(hl)			; D3 AE
	;***********************************************************
alt$y	xor	(hl)			; 76 AE
ioe$y	xor	(hl)			; DB AE
ioi$y	xor	(hl)			; D3 AE
	;***********************************************************
alt$y	xor	a,c			; 76 A9
ioe$n	xor	a,c			; DB A9
ioi$n	xor	a,c			; D3 A9
	;***********************************************************
alt$y	xor	c			; 76 A9
ioe$n	xor	c			; DB A9
ioi$n	xor	c			; D3 A9
	;***********************************************************
alt$y	xor	a,#n			; 76 EE 20
ioe$n	xor	a,#n			; DB EE 20
ioi$n	xor	a,#n			; D3 EE 20
alt$y	xor	a, n			; 76 EE 20
ioe$n	xor	a, n			; DB EE 20
ioi$n	xor	a, n			; D3 EE 20
	;***********************************************************
alt$y	xor	#n			; 76 EE 20
ioe$n	xor	#n			; DB EE 20
ioi$n	xor	#n			; D3 EE 20
alt$y	xor	 n			; 76 EE 20
ioe$n	xor	 n			; DB EE 20
ioi$n	xor	 n			; D3 EE 20


	.page
	;***********************************************************
	; Hitachi HD64180 Codes
	;***********************************************************

	;***********************************************************
	; load register with input from port (n)
hd$64	in0	a,(n)			; ED 38 20
hd$64	in0	b,(n)			; ED 00 20
hd$64	in0	c,(n)			; ED 08 20
hd$64	in0	d,(n)			; ED 10 20
hd$64	in0	e,(n)			; ED 18 20
hd$64	in0	h,(n)			; ED 20 20
hd$64	in0	l,(n)			; ED 28 20
	;***********************************************************
	; multiplication of each half
	; of the specified register pair
	; with the 16-bit result going to
	; the specified register pair
hd$64	mlt	bc			; ED 4C
hd$64	mlt	de			; ED 5C
hd$64	mlt	hl			; ED 6C
hd$64	mlt	sp			; ED 7C
	;***********************************************************
	; load output port (c) with
	; location (hl),
	; decrement hl and b
	; decrement c
hd$64	otdm				; ED 8B
	;***********************************************************
	; load output port (c) with
	; location (hl),
	; decrement hl and c
	; decrement b
	; repeat until b = 0
hd$64	otdmr				; ED 9B
	;***********************************************************
	; load output port (c) with
	; location (hl),
	; increment hl and b
	; decrement c
hd$64	otim				; ED 83
	;***********************************************************
	; load output port (c) with
	; location (hl),
	; increment hl and c
	; decrement b
	; repeat until b = 0
hd$64	otimr				; ED 93
	;***********************************************************
	; load output port (n) from register
hd$64	out0	(n),a			; ED 39 20
hd$64	out0	(n),b			; ED 01 20
hd$64	out0	(n),c			; ED 09 20
hd$64	out0	(n),d			; ED 11 20
hd$64	out0	(n),e			; ED 19 20
hd$64	out0	(n),h			; ED 21 20
hd$64	out0	(n),l			; ED 29 20
	;***********************************************************
	; enter sleep mode
hd$64	slp				; ED 76
	;***********************************************************
	; non-destructive 'and' with accumulator and specified operand
hd$64	tst	a			; ED 3C
hd$64	tst	b			; ED 04
hd$64	tst	c			; ED 0C
hd$64	tst	d			; ED 14
hd$64	tst	e			; ED 1C
hd$64	tst	h			; ED 24
hd$64	tst	l			; ED 2C
hd$64	tst	#n			; ED 64 20
hd$64	tst	 n			; ED 64 20
hd$64	tst	(hl)			; ED 34
	;***********************************************************
	; non-destructive 'and' of n and the contents of port (c)
hd$64	tstio	#n			; ED 74 20
hd$64	tstio	 n			; ED 74 20
	;***********************************************************


