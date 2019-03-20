	.title	Ascii <--> Integer Conversion Routines

	.module	aiconv

	.include	/area.def/
	.include	/define.def/


	;	Summary of routines
	;
	;	a$o$i		Ascii in Octal to integer
	;	a$d$i		Ascii in Decimal to integer
	;	a$h$i		Ascii in Hexidecimal to integer
	;
	;	Integer Conversions with Leading Zeros
	;
	;	i$b$o		Integer byte to Octal Ascii
	;	i$w$o		Integer word to Octal Ascii
	;	i$b$d		Integer byte to Decimal Ascii
	;	i$w$d		Integer word to Decimal Ascii
	;	i$b$h		Integer byte to Hexidecimal Ascii
	;	i$w$h		Integer word to Hexidecimal Ascii
	;
	;	Integer Conversion with Leading Zeros Suppressed
	;
	;	i$b$oz		Integer byte to Octal Ascii
	;	i$w$oz		Integer word to Octal Ascii
	;	i$b$dz		Integer byte to Decimal Ascii
	;	i$w$dz		Integer word to Decimal Ascii
	;	i$b$hz		Integer byte to Hexidecimal Ascii
	;	i$w$hz		Integer word to Hexidecimal Ascii
	;
	;	All integer to Ascii conversion routines
	;	terminate the resulting string with 0q200
	;
	;	All Ascii to integer conversion routines
	;	expect the string to be terminated with 0q000 or 0q200
	;
	;	The input or output string is pointed to by index register x
	;	The input or output data is in register d
	;
	;
	;	Variable Requirements
	;
	;	i$ndgt::	.blkb	1
	;	i$dcnt::	.blkb	1
	;	i$zero::	.blkb	1
	;	i$data::	.blkb	2
	;
	;

	.area	AICONV



	.page
	.sbttl	convert ascii in octal to integer

a$o$i::
	pshs	x
	ldd	#0		; initialize result

1$:	tst	,x		; check for end of string
	ble	2$
	aslb			; *8
	rola
	aslb
	rola
	aslb
	rola
	addb	,x+		; add in octal digit
	adca	#0
	subb	#'0
	sbca	#0
	bra	1$

2$:	puls	x
	rts

	.page
	.sbttl	convert ascii in decimal to integer

a$d$i::
	pshs	x
	ldd	#0		; initialize result

1$:	tst	,x		; check for end of string
	ble	2$
	aslb			; *2
	rola
	std	,--s
	aslb
	rola
	aslb			; *8
	rola
	addd	,s++		; *8 + *2
	addb	,x+		; add in decimal digit
	adca	#0
	subb	#'0
	sbca	#0
	bra	1$

2$:	puls	x
	rts


	.page
	.sbttl	convert ascii in hexidecimal to integer

a$h$i::
	pshs	x
	ldd	#0		; initialize result

1$:	tst	,x		; check for end of string
	ble	3$
	aslb			; *16
	rola
	aslb
	rola
	aslb
	rola
	aslb
	rola
	std	,--s
	clra
	ldb	,x+		; add in hexidecimal digit
	subb	#'A		; A-F check
	bmi	2$
	subb	#0d7		; A-F
2$:	addb	#'A-'0		; 0-9
	addd	,s++
	bra	1$

3$:	puls	x
	rts


	.page
	.sbttl	Octal byte to ascii conversion

i$b$o::
	pshs	x
	clr	*i$zero
	inc	*i$zero		; leading zeros enabled
	bra	i$b

i$b$oz::
	pshs	d
	clr	*i$zero		; leading zeros suppressed

i$b:	exg	a,b		; position data
	std	*i$data		; save data
	ldb	#3		; 3 digits
	stb	*i$ndgt
	clr	*i$dcnt		; initialize result
	ldd	*i$data		; load data
	bra	i$ob


	.sbttl	Octal word to ascii conversion

i$w$o::
	pshs	d
	clr	*i$zero
	inc	*i$zero		; leading zeros enabled
	bra	i$w

i$w$oz::
	pshs	d
	clr	*i$zero		; leading zeros suppressed

i$w:	std	*i$data		; save data
	ldb	#6		; 6 digits
	stb	*i$ndgt
	clr	*i$dcnt		; initialize result
	ldd	*i$data		; load data
	bra	i$ow


	.page

i$o:	clr	*i$dcnt		; initialize result
	ldd	*i$data		; load data
	aslb			; rotate 3 bits into position
	rola
i$ob:	rol	*i$dcnt
	aslb
	rola
	rol	*i$dcnt
i$ow:	aslb
	rola
	rol	*i$dcnt
	std	*i$data		; save data
	ldb	*i$dcnt		; get bits
	addb	#'0		; convert to ascii
1$:	dec	*i$ndgt		; last digit ?
	beq	2$		; yes - skip tests
	tst	*i$zero		; leading zeros ?
	bne	2$		; yes - skip
	cmpb	#'0
	beq	3$
2$:	stb	,x+		; place character
	inc	*i$zero		; enable zeros
3$:	tst	*i$ndgt		; any more ?
	bne	i$o
	ldb	#0q200		; terminator
	stb	,x
	puls	d
	rts


	.page
	.sbttl	Decimal byte to ascii conversion

i$b$d::
	pshs	d,y
	clra
	std	*i$data		; save date
	ldb	#3-1		; 3 characters for bytes
	stb	*i$ndgt
	stb	*i$zero		; leading zeros enabled
	ldy	#i$dt+4
	bra	i$d

i$b$dz::
	pshs	d,y
	clra
	std	*i$data		; save date
	ldb	#3-1		; 3 characters for bytes
	stb	*i$ndgt
	clr	*i$zero		; leading zeros suppressed
	ldy	#i$dt+4
	bra	i$d


	.sbttl	Decimal Word to ascii conversion

i$w$d::
	pshs	d,y
	std	*i$data		; save date
	ldb	#5-1		; 5 characters for words
	stb	*i$ndgt
	stb	*i$zero		; leading zeros enabled
	ldy	#i$dt
	bra	i$d

i$w$dz::
	pshs	d,y
	std	*i$data		; save date
	ldb	#5-1		; 5 characters for words
	stb	*i$ndgt
	clr	*i$zero		; leading zeros suppressed
	ldy	#i$dt


	.page

i$d:	ldd	*i$data		; get data
	clr	*i$dcnt		; initialize counter

1$:	cmpd	,y++		; trial
	blo	2$		; ok - skip
	subd	,--y
	inc	*i$dcnt		; one more count
	bra	1$

2$:	std	*i$data
	ldb	*i$dcnt		; convert count to ascii character
	addb	#'0
	tst	*i$zero		; leading zeros ?
	bne	3$		; yes - skip
	cmpb	#'0
	beq	4$
3$:	stb	,x+		; place character
	inc	*i$zero		; enable zeros
4$:	dec	*i$ndgt		; any more ?
	bgt	i$d		; yes - loop
	ldb	*i$data+1	; last digit
	addb	#'0
	stb	,x+
	ldb	#0q200
	stb	,x		; terminator

	puls	d,y
	rts


i$dt:	.word	0d10000		; conversion table
	.word	0d1000
	.word	0d100
	.word	0d10


	.page
	.sbttl	Hex byte to ascii conversion

i$b$h::
	pshs	d
	exg	a,b
	std	*i$data		; save data
	ldb	#2		; 2 digits
	stb	*i$ndgt
	stb	*i$zero		; leading zeros enabled
	bra	i$h

i$b$hz::
	pshs	d
	exg	a,b
	std	*i$data		; save data
	ldb	#2		; 2 digits
	stb	*i$ndgt
	clr	*i$zero		; leading zeros suppressed
	bra	i$h


	.sbttl	Hex word to ascii conversion

i$w$h::
	pshs	d
	std	*i$data		; save data
	ldb	#4		; 4 digits
	stb	*i$ndgt
	stb	*i$zero		; leading zeros enabled
	bra	i$h

i$w$hz::
	pshs	d
	std	*i$data		; save data
	ldb	#4		; 4 digits
	stb	*i$ndgt
	clr	*i$zero		; leading zeros suppressed


	.page

i$h:	clr	*i$dcnt		; initialize result
	ldd	*i$data		; get data
	aslb			; rotate 4 bits into position
	rola
	rol	*i$dcnt
	aslb
	rola
	rol	*i$dcnt
	aslb
	rola
	rol	*i$dcnt
	aslb
	rola
	rol	*i$dcnt
	std	*i$data		; save data
	ldb	*i$dcnt		; get bits
	addb	#'0		; convert to ascii
	cmpb	#'9
	blos	1$
	addb	#0d7
1$:	dec	*i$ndgt		; last digit ?
	beq	2$		; yes - skip tests
	tst	*i$zero		; leading zeros ?
	bne	2$		; yes - skip
	cmpb	#'0
	beq	3$
2$:	stb	,x+		; place character
	inc	*i$zero		; enable zeros
3$:	tst	*i$ndgt		; any more ?
	bne	i$h
	ldb	#0q200		; terminator
	stb	,x
	puls	d
	rts


