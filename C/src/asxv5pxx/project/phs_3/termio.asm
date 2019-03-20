	.sbttl	terminal screen control

	.globl	tt_inp,	tt_out

	.module	termio

	.include	/area.def/
	.include	/define.def/


	.area	TERMIO

	; These routines require the following variables and buffers.
	;
	; syscin
	;	cstate		translator state
	;
	; format buffer routine variables
	;	fmtrow		format buffer row
	;	fmtcol		format buffer column
	;	findex		address of character in format buffer
	;	rflag		normal/reverse video flag
	;
	;	fmtbuf		format buffer allocation
	;
	; output buffer routine variables
	;	ostate		current state of output buffer scanner
	;	index		current output scanner index
	;	first		first changed character in line
	;	count		number of changed characters in line
	;	outz		current screen video mode
	;	savez		saved screen video mode
	;
	;	outbuf		output buffer allocation
	;

	; Terminal escape sequence translator
	; vt1xx keypad mode

sysnxt:
	inc	*cstate		; next state
syscin::
	jsr	tt_inp		; get a character
	beq	2$

	pshs	x,b
	leax	3$,pcr
	ldb	*cstate
	aslb
	cmpb	#4$-3$		; valid cstate ?
	blo	1$		; yes - skip
	clrb
	stb	*cstate		; reset state
1$:	jsr	[b,x]		; go to state
	puls	x,b
	sta	*char		; save character
2$:	rts

3$:	.word	4$,	5$,	6$,	7$


;state0
4$:	cmpa	#ESCAPE		; start an escape sequence ?
	beq	sysnxt		; yes - loop
	rts			; return character

;state1
5$:	cmpa	#'O		; next state = 2 ?
	beq	sysnxt		; yes - loop
	inc	*cstate
	cmpa	#'[		; next state = 3 ?
	beq	sysnxt		; yes - loop
	lda	#ERROR		; not a valid sequence
	clr	*cstate
	rts

;state2
6$:	leax	10$,pcr
	bra	8$

;state3
7$:	leax	11$,pcr

;statex
8$:	cmpa	,x++		; match table entry ?
	beq	9$
	tst	-2,x		; end of table ?
	bne	8$
9$:	lda	-1,x		; get translation
	clr	*cstate
	rts


10$:	.byte	'l,DELC,	'm,DELW,	'n,SELECT,	'p,LINE
	.byte	'q,WORD,	'r,EOL,		's,CHAR,	't,ADVANCE
	.byte	'u,BACKUP,	'v,CUT,		'w,PAGE,	'x,SECTION
	.byte	'y,APPEND,	'M,ENTER,	'P,GOLD,	'Q,HELP
	.byte	'R,FNDNXT,	'S,DELL,	 0,ERROR

11$:	.byte	'A,SCRLU,	'B,SCRLD,	'C,SCRLR,	'D,SCRLL
	.byte	 0,ERROR


	;
	; fmtindex	-	calculate the pointer into
	;			the fmt buffer.
	;	a	-	row
	;	b	-	column
	;
	; returns:
	;	y	-	returns address for fmtbuf(row,column)

fmtindex::
	pshs	d
	std	*fmtrow		; row,column
	leay	fmtbuf,u
	ldb	#SCRNW
	mul
	addb	*fmtcol
	adca	#0
	leay	d,y
	sty	*findex		; save &fmtbuf(row,column)
	puls	d
	rts


	;
	; fmtdeol	-	Clear to end of line.
	;
	;	a	-	row
	;	b	-	column

fmtdeol::
	pshs	y,d
	jsr	fmtindex
	lda	#SCRNW
	suba	*fmtcol
	beq	2$
	ldb	#(' )		; space character
1$:	stb	,y+
	deca
	bgt	1$

2$:	puls	y,d
	rts


	;
	;  fmtchar	-	Output a single character
	;			to the screen buffer.
	;

fmtchar::
	pshs	y
	pshs	d
	ldd	*fmtrow		; load row,column
	jsr	fmtindex
	puls	d
	sta	,y		; place character
	puls	y
	rts


	; fmthtxt	-	Format the character string
	;			horizontally into the format buffer.
	;
	;	x	-	pointer to string
	;	a	-	row
	;	b	-	column
	;
	;	returns:
	;	a	-	row
	;	b	-	new column position

fmthtxt::
	pshs	x,y		; save registers

	jsr	fmtindex	; pointer to character position in fmtbuf

1$:	lda	,x		; set reverse video flag
	anda	#REVERSE
	sta	*rflag

	lda	,x+
	anda	#0x7F
	beq	5$
	cmpa	#CRLF
	beq	5$

	; TAB processing

	cmpa	#TAB		; TAB's are expanded to spaces
	bne	3$		; with a fixed spacing of 8 characters
	lda	#0d8
	ldb	*fmtcol
	andb	#0x07
	sba			; character positions to fill
	addb	*fmtcol		; update column position
	stb	*fmtcol

	ldb	#(' )		; space character
	orb	*rflag		; set video mode bit
2$:	stb	,y+		; place characters
	deca
	bgt	2$
	bra	1$

	; Nonprinting character processing

3$:	cmpa	#0d32		; nonprinting character ?
	bhis	4$		; no - skip

	ldb	#'^		; show as ^_
	orb	*rflag
	stb	,y+
	adda	#0d64
	ora	*rflag
	sta	,y+

	inc	*fmtcol		; update column
	inc	*fmtcol
	bra	1$

	; Process all normal characters

4$:	ora	*rflag
	sta	,y+
	inc	*fmtcol
	bra	1$

5$:	puls	x,y		; restore registers
	ldd	*fmtrow		; return current row,column
	rts


	; fmtvtxt	-	Format the character string
	;			vertically into the format buffer.
	;
	;	x	-	pointer to string
	;	a	-	row
	;	b	-	column
	;
	;	returns:
	;	a	-	new row position
	;	b	-	column position

fmtvtxt::
	pshs	x,y		; save registers

	jsr	fmtindex	; pointer to character position in fmtbuf

1$:	lda	,x		; set reverse video flag
	anda	#REVERSE
	sta	*rflag

	lda	,x+
	anda	#0x7F
	beq	5$
	cmpa	#CRLF
	beq	5$

	; TAB processing

	cmpa	#TAB		; TAB's are expanded to spaces
	bne	3$		; with a fixed spacing of 8 characters
	lda	#0d8
	ldb	*fmtrow
	andb	#0x07
	sba			; character positions to fill
	addb	*fmtrow		; update row position
	stb	*fmtrow

	ldb	#(' )		; space character
	orb	*rflag		; set video mode bit
2$:	stb	,y		; place characters
	leay	SCRNW,y		; update buffer location
	deca
	bgt	2$
	bra	1$

	; Nonprinting character processing

3$:	cmpa	#0d32		; nonprinting character ?
	bhis	4$		; no - skip

	ldb	#'^		; show as ^_
	orb	*rflag
	stb	,y
	leay	SCRNW,y		; update buffer location
	adda	#0d64
	ora	*rflag
	sta	,y
	leay	SCRNW,y		; update buffer location

	inc	*fmtrow		; update column
	inc	*fmtrow
	bra	1$

	; Process all normal characters

4$:	ora	*rflag
	sta	,y
	leay	SCRNW,y		; update buffer location
	inc	*fmtrow
	bra	1$

5$:	puls	x,y		; restore registers
	ldd	*fmtrow		; return current row,column
	rts


	;	x	-	integer value to convert to ascii
	;	d	-	row / column of the first position
	;			of the 6 character string space to
	;			right justify the converted integer

fmt4rjint::
	pshs	d,x,y
	jsr	fmtindex	; get buffer position in y
	tfr	x,d		; convert integer in x
	leas	-6,s		; space for string
	tfr	s,x		; string address
	clr	,-s		; front termination
	jsr	i$w$dz		; convert to ascii

	lda	#(' )		; clear old string in buffer
	ldb	#4
1$:	sta	,y+
	decb
	bgt	1$

2$:	lda	,-x		; copy string into buffer
	ble	3$
	sta	,-y
	bra	2$

3$:	leas	7,s		; pop string
	puls	d,x,y
	rts


	;	x	-	integer value to convert to ascii
	;	d	-	row / column of the first position
	;			of the 6 character string space to
	;			left justify the converted integer

fmt4ljint::
	pshs	d,x,y
	jsr	fmtindex	; get buffer position in y
	tfr	x,d		; convert integer in x
	leas	-6,s		; space for string
	tfr	s,x		; string address
	jsr	i$w$dz		; convert to ascii

	ldb	#4
	tfr	s,x
1$:	lda	,x+		; copy string into buffer
	ble	2$
	sta	,y+
	decb
	bra	1$

2$:	lda	#(' )		; clear old string in buffer
	bra	4$

3$:	sta	,y+
4$:	decb
	bge	3$

5$:	leas	6,s		; pop string
	puls	d,x,y
	rts


	;	x	-	integer value to convert to ascii
	;	d	-	row / column of the first position
	;			of the 6 character string space to
	;			right justify the converted integer

fmt6rjint::
	pshs	d,x,y
	jsr	fmtindex	; get buffer position in y
	tfr	x,d		; convert integer in x
	leas	-6,s		; space for string
	tfr	s,x		; string address
	clr	,-s		; front termination
	jsr	i$w$dz		; convert to ascii

	lda	#(' )		; clear old string in buffer
	ldb	#6
1$:	sta	,y+
	decb
	bgt	1$

2$:	lda	,-x		; copy string into buffer
	ble	3$
	sta	,-y
	bra	2$

3$:	leas	7,s		; pop string
	puls	d,x,y
	rts


	;	x	-	integer value to convert to ascii
	;	d	-	row / column of the first position
	;			of the 6 character string space to
	;			left justify the converted integer

fmt6ljint::
	pshs	d,x,y
	jsr	fmtindex	; get buffer position in y
	tfr	x,d		; convert integer in x
	leas	-6,s		; space for string
	tfr	s,x		; string address
	jsr	i$w$dz		; convert to ascii

	ldb	#6
	tfr	s,x
1$:	lda	,x+		; copy string into buffer
	ble	2$
	sta	,y+
	decb
	bra	1$

2$:	lda	#(' )		; clear old string in buffer
	bra	4$

3$:	sta	,y+
4$:	decb
	bge	3$

5$:	leas	6,s		; pop string
	puls	d,x,y
	rts


	;
	; outpos	-	output the current position to the screen
	;
	;	u	-	current user structure
	;	a	-	row
	;	b	-	column

outpos::
	pshs	d
	lda	#ESCAPE
	jsr	tt_out
	lda	#'[
	jsr	tt_out
	lda	0,s		; row first
	jsr	outarg
	lda	#';
	jsr	tt_out
	lda	1,s		; column last
	jsr	outarg
	lda	#'H
	jsr	tt_out
	puls	d
	rts

	;
	; outarg	-	output the position as an ascii string
	;
	;	u	-	current user structure
	;	a	-	argument

outarg::
	pshs	x,d

	clrb			;	- tens
	inca			; +1	- ones

1$:	cmpa	#0d10		; tens digits
	blo	2$
	incb
	suba	#0d10
	bra	1$

2$:	tstb
	beq	3$
	exg	a,b
	adda	#'0
	jsr	tt_out		; tens digit
	exg	a,b

3$:	adda	#'0
	jsr	tt_out		; ones digit

	puls	x,d
	rts


	;
	; outzset	-	set the video mode
	;			return old video mode
	;
	;	u	-	current user structure
	;	a	-	returns old mode
	;		0	normal
	;		1	reverse

outzset::
	tsta
	bne	outrev		; go to outrev
				; fall through to outnorm
	
	;
	; outnorm	-	set normal video mode
	;			return old video mode
	;
	;	u	-	current user structure
	;	a	-	returns old mode
	;		0	normal
	;		1	reverse

outnorm::
	lda	*outz		; check current mode
	beq	1$		; normal - exit
	pshs	x
	clr	*outz		; change to normal
	leax	2$,pcr
	bsr	escout
	lda	#1		; was reverse
	puls	x
1$:	rts

2$:	.asciz	"[m"


	;
	; outrev	-	set reverse video mode
	;			return old video mode
	;
	;	u	-	current user structure
	;	a	-	returns old mode
	;		0	normal
	;		1	reverse

outrev::
	lda	*outz		; check current mode
	bne	1$		; reverse - exit
	pshs	x
	inc	*outz		; change to reverse
	leax	2$,pcr
	bsr	escout
	clra			; was normal
	puls	x
1$:	rts

2$:	.asciz	"[7m"


	;
	; outclr	-	clear screen
	;
	;	u	-	current user structure

outclr::
	pshs	x,a
	leax	1$,pcr		; clear screen
	bra	escgo

1$:	.asciz	"[2J"


	;
	; outdeol	-	clear to end of line
	;
	;	u	-	current user structure

outdeol::
	pshs	x,a
	leax	1$,pcr		; clear to end of line
	bra	escgo

1$:	.asciz	"[K"


	;
	; escout	-	output the escape sequence
	;
	;	u	-	current user structure
	;	x	-	character string
	;	a	-	temporary

escout::
	pshs	x,a

escgo:	lda	#ESCAPE

1$:	jsr	tt_out
	lda	,x+
	bne	1$

	puls	x,a
	rts


	;
	; outekp	-	enable alternate keypad mode
	;			set scroll region
	;
	;	u	-	current user structure

outekp::
	pshs	d
	lda	#ESCAPE
	jsr	tt_out
	lda	#'=		; enable alternate keypad mode
	jsr	tt_out
	lda	#SCRNTP
	ldb	#SCRNBT
	bsr	outscroll
	puls	d
	rts


	;
	; outdkp	-	disable alternate keypad mode
	;			reset scroll rgion
	;
	;	u	-	current user structure

outdkp::
	pshs	d
	lda	#ESCAPE
	jsr	tt_out
	lda	#'<		; disable alternate keypad mode
	jsr	tt_out
	clra			; reset scroll region and scroll
	ldb	#SCRNL-1
	bsr	outscroll
	puls	d
	rts

	;
	; outscroll	-	scroll region
	;
	;	u	-	current user structure
	;	a	-	TOP of region
	;	b	-	BOTTOM of region

outscroll::
	pshs	d
	lda	#ESCAPE
	jsr	tt_out
	lda	#'[
	jsr	tt_out
	lda	0,s		; screen top
	jsr	outarg
	lda	#';
	jsr	tt_out
	lda	1,s		; screen bottom
	jsr	outarg
	lda	#'r
	jsr	tt_out
	puls	d
	rts


	;
	; clrsbufs	-	clear the screen buffers
	;
	;			fills fmtbuf with spaces
	;			fills outbuf with spaces

clrsbufs::
	pshs	x,y,u,a
	leax	outbuf,u	; output buffer
	leau	fmtbuf,u	; format buffer
	ldy	#(SCRNBT-SCRNTP+1)*SCRNW
	lda	#(' )		; space character
1$:	sta	,x+		; load outbuf with spaces
	sta	,u+		; load fmtbuf with spaces
	leay	-1,y
	bne	1$
	puls	x,y,u,a
	rts


	;
	; outblk	-	output block buffer
	;
	;	This routine outputs any updates to the
	;	video terminal screen.  This routine
	;	never blocks and updates one screen line
	;	per call if there is space available in the
	;	port output buffer.
	;
	;	registers are not preserved
	;
	;	enter with u pointing to the work page
	;

outblk::
	tfr	u,d
	tfr	a,dp		; set direct page
	ldb	*scrn$sts	; this screen active ?
	bpl	8$		; no - exit
	lda	*bfstat		; check if space available
	bita	#dl		; empty ?
	bne	8$		; no - exit

	bitb	#0q100		; clear screen ?
	beq	1$		; no - skip
	andb	#~0q100		; clear flag bit
	stb	*scrn$sts
	jsr	clrsbufs	; clear the screen buffers
	jsr	outclr		; and the screen
	jsr	outnorm		; normal video
	jsr	outekp		; enable the keypad

1$:	bitb	#0q040		; move cursor ?
	beq	2$		; no - skip
	andb	#~0q040		; clear flag bit
	stb	*scrn$sts
	ldd	*scrn$pos
	jsr	outpos		; and move screen cursor

2$:	lda	*outz		; save video status
	sta	*savez

	leax	4$,pcr
	ldb	*ostate
	cmpb	#2		; valid state ?
	blo	3$		; yes - skip
	clrb			; reset state
	clr	*ostate
3$:	aslb
	jmp	[b,x]		; go to state

4$:	.word	5$,	6$

; state0
5$:	clr	*index
	inc	*ostate

; state1
6$:	bsr	9$		; scan line for changes
	lda	*index		; update line index
	inca
	cmpa	#SCRNBT-SCRNTP	; finished after #() lines
	blos	7$
	clra			; restart sequence scan
	sta	*ostate
7$:	sta	*index	
8$:	rts

	;
	;	scan a line of text for changes
	;

9$:	lda	*index		; line number
	ldb	#SCRNW		; line width
	mul
	leax	fmtbuf,u	; compute pointer into fmtbuf
	leax	d,x
	leay	outbuf,u	; compute pointer into outbuf
	leay	d,y
	pshs	x,y		; save buffer pointers

	clr	*first		; first
	clr	*count		; count

	clrb
10$:	lda	,x+		; compare character by character
	cmpa	,y+
	bne	11$
	incb
	cmpb	#SCRNW
	bne	10$
	lbra	18$		; no changes - just exit

11$:	stb	*first		; save first changed location
	puls	x,y		; get pointers back
	pshs	x,y
	leax	SCRNW,x		; end of string pointers
	leay	SCRNW,y
	ldb	#SCRNW
12$:	lda	,-x		; scan back from end
	cmpa	,-y
	bne	13$
	decb
	bne	12$
13$:	subb	*first		; compute number of characters changed
	stb	*count

	puls	x,y		; restore buffer pointers
	pshs	x,y
	ldb	*first		; column
	leax	b,x		; fmtbuf + index*SCRNW + first
	leay	b,y		; outbuf + index*SCRNW + first

	lda	*index		; row
	adda	#SCRNTP
	jsr	outpos		; position cursor at first position

	ldb	*count		; number of changed characters
14$:	decb
	bmi	17$
	lda	,x+		; update character in buffer
	sta	,y+
	pshs	a
	bmi	15$		; reverse video

	jsr	outnorm		; normal video character
	bra	16$

15$:	jsr	outrev		; reverse video character

16$:	puls	a
	anda	#0x7F		; mask video mode and update
	jsr	tt_out
	bra	14$		; loop for count characters

17$:	ldd	*scrn$pos	; restore cursor position
	jsr	outpos

	lda	*savez
	jsr	outzset
18$:	leas	4,s		; pop buffer pointers
	rts


