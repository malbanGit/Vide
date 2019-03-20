	.sbttl	Histogramming

	.module	histos

	.include	/area.def/
	.include	/define.def/

	$HSTWIDTH	==	0d64
	$HSTROW		==	SCRNTP+1
	$HSTCOL		==	0d14

	.area	SCREEN

	.sbttl	Pulse Height Spectrum Screen


phs$scrn::
	pshs	d,x,y

1$:	ldb	*s$state	; check state
	beq	3$
	lda	*char
	cmpa	#CTRLW		; redraw screen ?
	bne	2$
	clr	,s		; CTRLW seen
	ldb	#1
	stb	*s$state	; new state
2$:	aslb
	cmpb	#5$-4$		; check for valid state
	blo	3$
	clrb
	stb	*s$state
3$:	ldx	#4$
	jmp	[b,x]

4$:	.word	5$,6$,9$,10$

5$:	ldd	r$lin4		; default option position
	jsr	init$opt
	std	*scrn$pos
	inc	*s$state	; next state

6$:	jsr	clr$scrn	; clear the screen
	jsr	hst$axis	; draw the axis

	tst	*o$state	; active options sequence ?
	beq	8$		; no - skip
	lda	#ENTER		; redo question
	jsr	hst$ques
	tst	*s$strlen	; answer ?
	beq	8$		; no - skip
	ldd	*scrn$pos	; cursor position
	jsr	fmtindex
	leax	s$string,u	; answer string
7$:	lda	,x+		; copy string
	ble	8$
	sta	,y+
	inc	*scrn$pos+1	; update cursor position
	bra	7$

8$:	inc	*s$state	; next state

9$:	jsr	phs$lgnd	; load up legends
	ldd	*scrn$pos	; reload cursor position
	jsr	pos$scrn
	inc	*s$state	; next state

10$:	tst	*o$state	; processing an option ?
	beq	11$		; no  - skip

	lda	*char		; get the character
	jsr	phs$optn	; yes - service the option
	sta	*char		; character used

	tst	*s$state	; exit screen ?
	beq	12$		; yes - doit

	tst	*o$state	; processing finished ?
	lbeq	1$		; yes - rescan new settup
	bra	12$

11$:	lda	*char
	jsr	scn$scrl	; try scrolling to a new option
	sta	*char
	beq	12$
	jsr	hst$ques	; try selecting an option
	sta	*char

12$:	puls	d,x,y
	rts


	;
	; phs$scrn Legends
	;

phs$lgnd::
	pshs	d,x

	clrb			; compute screen entry
	lda	*scrn$sts+1	; channel #
	cmpa	#0d32		; valid channel ?
	bhi	3$		; no - exit
	blo	1$		; detector
	addb	#2		; temperature
1$:	asla
	ldx	#acqvtbl	; acquisition variable table
	leax	[a,x]		; this channel's variables
	tst	phs$vscl,x
	bpl	2$		; autoscaling
	addb	#4		; scaling
2$:	ldx	#phs$list	; now get list pointer
	leax	[b,x]

	jsr	scn$lgnd	; do legends
	jsr	scn$chnl	; and channel

3$:	puls	d,x
	rts


	;
	; phs$scrn Options
	;

phs$optn::
	jsr	scn$gets	; build a response string
	beq	3$		; not finished
	tst	*s$string	; NULL string ?
	ble	2$		; yes - terminate option

	jsr	option		; get the option number
	aslb
	cmpb	#5$-4$		; valid option ?
	bhis	2$		; no - terminate request

	lda	*scrn$sts+1	; get channel number
	cmpa	#0d32		; valid channel ?
	bhi	2$		; no - terminate option
	asla

	ldy	#2$		; options return address
	pshs	y

	ldy	#4$		; jump table
	leay	[b,y]		; get address of option routine
	pshs	y		; push as a return address

	leax	s$string,u	; string pointer

	ldy	#acqvtbl	; variables address for this channel
	leay	[a,y]

1$:	rts			; do option

2$:	clr	*o$state	; option completed
	lda	#SCRNBT
	ldb	#0
	jsr	fmtdeol		; clear option question and answer

	ldd	*opt$posn	; option position
	jsr	pos$scrn	; restore cursor

3$:	clra			; input character always used
	rts

4$:	.word	1$		; invalid option
	.word	5$		; new channel
	.word	7$		; exit screen
	.word	9$		; change to fixed scale
	.word	11$		; change to auto scale
	.word	13$		; zero
	.word	15$		; set vertical scale
	.word	17$		; set vertical offset
	.word	19$		; set horizontal scale
	.word	21$		; set horizontal offset

	; New Channel Number

5$:	jsr	a$d$i		; convert to an integer
	cmpb	#0d32		; valid ?
	bhi	6$		; no - skip
	stb	*scrn$sts+1	; save new channel #
	lda	#2		; redraw legends
	sta	*s$state	
6$:	rts

	; Exit Screen

7$:	jsr	ans$yes		; yes ?
	bne	8$		; no - skip
	clr	*s$state	; just exit
8$:	rts

	; Change to Fixed Scale

9$:	jsr	ans$yes		; yes ?
	bne	10$		; no - skip
	lda	phs$vscl,y	; make fixed scale
	ora	#0q200
	sta	phs$vscl,y
	lda	#2		; redraw legends
	sta	*s$state	
10$:	rts

	; Change to Auto Scale

11$:	jsr	ans$yes		; yes ?
	bne	12$		; no - skip
	lda	phs$vscl,y	; make fixed scale
	anda	#~0q200
	sta	phs$vscl,y
	lda	#2		; redraw legends
	sta	*s$state	
12$:	rts

	; Zero

13$:	jsr	ans$yes		; yes ?
	bne	14$		; no - skip
	jsr	phs$clr		; clear the histogram
14$:	rts

	; Vertical scale

15$:	jsr	a$d$i		; convert to an integer
	cmpb	#0d15
	bhi	16$
	cmpb	#0d4
	blo	16$
	subb	#4		; 2^4 is 16, minimum full scale
	stb	,-s
	ldb	phs$vscl,y	; mask out scale
	andb	#0xF0
	orb	,s+
	stb	phs$vscl,y
16$:	rts
	
	; Vertical Offset

17$:	jsr	a$d$i		; convert to an integer
	tsta
	bmi	18$
	std	phs$vofs,y
18$:	rts

	; Horizontal Scale

19$:	jsr	a$d$i		; convert to an integer
	cmpb	#0d10
	bhi	20$
	cmpb	#0d6
	blo	20$
	negb
	addb	#0d10		; 10 - n
	stb	phs$hscl,y
	jsr	phs$clr		; clear the histogram
20$:	rts
	
	; Horizontal Offset

21$:	jsr	a$d$i		; convert to an integer
	cmpd	#0d1023
	bhi	22$
	std	phs$hofs,y
	jsr	phs$clr		; clear the histogram
22$:	rts


	.page
	.sbttl	Pulse Height Histogram Clear Routine

	;	Clear histogram specified by *scrn$sts

phs$clr::
	pshs	d,x,y

	lda	*scrn$sts+1	; selected channel
	cmpa	#0d32		; temperature or LED data ?
	bhi	4$		; no - exit
	asla
	ldx	#acqbtbl	; data pointers
	leax	[a,x]

2$:	leax	acq$phs,x
	ldy	#0d64
	ldd	#0
3$:	std	,x++
	leay	-1,y
	bne	3$

4$:	puls	d,x,y
	rts


	.page
	.sbttl	Pulse Height Histogramming Routine

	.area	SCRNUPDT

	;	Enter with channel number in b
	;
	;	the following stack frame is created :
	;
	;	8,s	u
	;	6,s	y
	;	4,s	x
	;	2,s	d	(4,s)	a	(5,s)	b
	;	0,s	scale jump address
	;

	$OLDU	= 0d8
	$OLDY	= 0d6
	$OLDX	= 0d4
	$OLDD	= 0d2
	$JUMP	= 0d0

phs$hst::
	pshs	d,x,y,u		; save all
	leas	-2,s		; jump address

	cmpb	#0d32		; temperature or LED data ?
	lbhi	10$		; no - exit
	aslb
	ldx	#acqbtbl	; data pointers
	leax	[b,x]
	ldy	#acqvtbl
	leay	[b,y]

1$:	lda	phs$vscl,y
	bmi	6$		; skip if not auto scale

	; auto scaling routine

	pshs	x,y
	leax	acq$phs,x	; histo data
	ldy	#0d64		; histo length
	ldd	#0		; smallest value
2$:	cmpd	,x++		; find largest
	bhis	3$
	ldd	-2,x
3$:	leay	-1,y
	bne	2$
	puls	x,y

	clr	phs$vscl,y	; auto scale

4$:	cmpd	#0d19		; now compute scaling factor
	blos	5$		; 0 - 19 is allowed pulse height
	clc			; divide by two
	rora
	rorb
	inc	phs$vscl,y	; update scaling
	bra	4$

5$:	ldd	#0		; clear the offset
	std	phs$vofs,y

	; scale the data and plot

6$:	lda	phs$vscl,y	; get the scaling factor
	anda	#0x0F
	asla
	nega
	leau	8$,pcr		; compute jump address for scaling
	leau	a,u
	stu	$JUMP,s
	leau	acq$phs,x	; data buffer address
	clr	phs$index,y	; clear the index

7$:	ldd	,u++		; get the data
	subd	phs$vofs,y	; take off offset
	jmp	[$JUMP,s]	; do proper scaling
	asra			; / 2^15
	rorb
	asra			; / 2^14
	rorb
	asra			; / 2^13
	rorb
	asra			; / 2^12
	rorb
	asra			; / 2^11
	rorb
	asra			; / 2^10
	rorb
	asra			; / 2^9
	rorb
	asra			; / 2^8
	rorb
	asra			; / 2^7
	rorb
	asra			; / 2^6
	rorb
	asra			; / 2^5
	rorb
	asra			; / 2^4
	rorb
	asra			; / 2^3
	rorb
	asra			; / 2^2
	rorb
	asra			; / 2^1
	rorb
8$:	lda	phs$index,y	; column
	jsr	phs$clmn	; plot the data
	inca
	sta	phs$index,y	; next column
	cmpa	#0d64		; finished
	blo	7$		; no - loop
	ldu	$OLDU,s		; restore u

	; Vertical Scale Update

	lda	phs$vscl,y	; get the scaling factor
	anda	#0x0F
	asla
	ldx	#11$
	ldd	a,x		; 1/2 full scale
	ldx	phs$vofs,y	; offset
	stx	,--s
	leax	d,x		; offset + 1/2 full scale
	stx	,--s
	leax	d,x		; offset + 2/2 full scale
	lda	#SCRNTP
	ldb	#$HSTCOL-0d8
	jsr	fmt6rjint

	ldx	,s++
	lda	#SCRNTP+0d10
	ldb	#$HSTCOL-0d8
	jsr	fmt6rjint

	ldx	,s++
	lda	#SCRNTP+0d20
	ldb	#$HSTCOL-0d8
	jsr	fmt6rjint

	; Horizontal Scale Update

	lda	phs$hscl,y	; get the scaling factor
	cmpa	#0d4
	blos	9$
	clra
9$:	asla
	ldx	#12$
	ldd	a,x		; full scale
	ldx	phs$hofs,y	; offset
	stx	,--s
	leax	d,x		; offset + full scale
	lda	#SCRNTP+0d22
	ldb	#$HSTCOL+$HSTWIDTH-0d5
	jsr	fmt6rjint

	ldx	,s++
	lda	#SCRNTP+0d22
	ldb	#$HSTCOL
	jsr	fmt6ljint

	; Average Update

	ldd	acq$sum,y	; get sum of array
	rolb			; divide by 64
	rola
	rolb
	rola
	rolb
	exg	a,b
	anda	#0x03
	std	,--s		; current average

	ldx	#13$
	lda	#SCRNTP+0d22
	ldb	#$HSTCOL+($HSTWIDTH/2)-0d8
	jsr	fmthtxt

	ldx	,s++
	jsr	fmt6ljint

	; finished

10$:	leas	2,s		; pop jump address
	puls	d,x,y,u		; restore all
	rts


11$:	.word	0d10,	0d20,	0d40,	0d80,	0d160,	0d320
	.word	0d640,	0d1280,	0d2560,	0d5120,	0d10240,0d20480

12$:	.word	0d1024,	0d512,	0d256,	0d128,	0d64

13$:	.asciz	"average = "


	.page
	.sbttl	Plot Data in Column

	;  a	-	histo column for new data point
	;  b	-	data value to plot

phs$clmn::
	pshs	d,x		; have added 0d6 to stack frame

	ldx	$OLDU+0d6,s	; get original u
	leax	fmtbuf+$HSTROW*SCRNW+$HSTCOL,x
	leax	a,x		; top of selected column
	lda	#(' )		; space character
	sta	0d0  * SCRNW,x	; clear the whole column fast !
	sta	0d1  * SCRNW,x
	sta	0d2  * SCRNW,x
	sta	0d3  * SCRNW,x
	sta	0d4  * SCRNW,x
	sta	0d5  * SCRNW,x
	sta	0d6  * SCRNW,x
	sta	0d7  * SCRNW,x
	sta	0d8  * SCRNW,x
	sta	0d9  * SCRNW,x
	sta	0d10 * SCRNW,x
	sta	0d11 * SCRNW,x
	sta	0d12 * SCRNW,x
	sta	0d13 * SCRNW,x
	sta	0d14 * SCRNW,x
	sta	0d15 * SCRNW,x
	sta	0d16 * SCRNW,x
	sta	0d17 * SCRNW,x
	sta	0d18 * SCRNW,x
	sta	0d19 * SCRNW,x

	cmpb	#0d19		; check range
	bhi	1$		; don't plot if out of range

	negb			; compute data position within this column
	addb	#0d19
	lda	#SCRNW
	mul
	leax	d,x
	lda	#'*		; plot data point
	sta	,x

1$:	puls	d,x
	rts


	.page
	.sbttl	Average Pulse Height Spectrum Screen

	.area	SCREEN

avg$scrn::
	pshs	d,x,y

1$:	ldb	*s$state	; check state
	beq	3$
	lda	*char
	cmpa	#CTRLW		; redraw screen ?
	bne	2$
	clr	,s		; CTRLW seen
	ldb	#1
	stb	*s$state	; new state
2$:	aslb
	cmpb	#5$-4$		; check for valid state
	blo	3$
	clrb
	stb	*s$state
3$:	ldx	#4$
	jmp	[b,x]

4$:	.word	5$,6$,9$,10$

5$:	ldd	r$lin4		; default option position
	jsr	init$opt
	std	*scrn$pos
	inc	*s$state	; next state

6$:	jsr	clr$scrn	; clear the screen
	jsr	hst$axis	; draw the axis

	tst	*o$state	; active options sequence ?
	beq	8$		; no - skip
	lda	#ENTER		; redo question
	jsr	hst$ques
	tst	*s$strlen	; answer ?
	beq	8$		; no - skip
	ldd	*scrn$pos	; cursor position
	jsr	fmtindex
	leax	s$string,u	; answer string
7$:	lda	,x+		; copy string
	ble	8$
	sta	,y+
	inc	*scrn$pos+1	; update cursor position
	bra	7$

8$:	inc	*s$state	; next state

9$:	jsr	avg$lgnd	; load up legends
	ldd	*scrn$pos	; reload cursor position
	jsr	pos$scrn
	inc	*s$state	; next state

10$:	tst	*o$state	; processing an option ?
	beq	11$		; no  - skip

	lda	*char		; get the character
	jsr	avg$optn	; yes - service the option
	sta	*char		; character used

	tst	*s$state	; exit screen ?
	beq	12$		; yes - doit

	tst	*o$state	; processing finished ?
	lbeq	1$		; yes - rescan new settup
	bra	12$

11$:	lda	*char
	jsr	scn$scrl	; try scrolling to a new option
	sta	*char
	beq	12$
	jsr	hst$ques	; try selecting an option
	sta	*char

12$:	puls	d,x,y
	rts


	;
	; avg$scrn Legends
	;

avg$lgnd::
	pshs	d,x

	clrb			; compute screen entry
	lda	*scrn$sts+1	; channel #
	cmpa	#0d32		; valid channel ?
	bhi	3$		; no - exit
	blo	1$		; detector
	addb	#2		; temperature
1$:	asla
	ldx	#acqvtbl	; acquisition variable table
	leax	[a,x]		; this channel's variables
	tst	avg$vscl,x
	bpl	2$		; autoscaling
	addb	#4		; scaling
2$:	ldx	#avg$list	; now get list pointer
	leax	[b,x]

	jsr	scn$lgnd	; do legends
	jsr	scn$chnl	; and channel number

3$:	puls	d,x
	rts


	;
	; avg$scrn Options
	;

avg$optn::
	jsr	scn$gets	; build a response string
	beq	3$		; not finished
	tst	*s$string	; NULL string ?
	ble	2$		; yes - terminate option

	jsr	option		; get the option number
	aslb
	cmpb	#5$-4$		; valid option ?
	bhis	2$		; no - terminate request

	lda	*scrn$sts+1	; get channel number
	cmpa	#0d32		; valid channel ?
	bhi	2$		; no - terminate option
	asla

	ldy	#2$		; options return address
	pshs	y

	ldy	#4$		; jump table
	leay	[b,y]		; get address of option routine
	pshs	y		; push as a return address

	leax	s$string,u	; string pointer

	ldy	#acqvtbl	; variables address for this channel
	leay	[a,y]

1$:	rts			; do option

2$:	clr	*o$state	; option completed
	lda	#SCRNBT
	ldb	#0
	jsr	fmtdeol		; clear option question and answer

	ldd	*opt$posn	; option position
	jsr	pos$scrn	; restore cursor

3$:	clra			; input character always used
	rts

4$:	.word	1$		; invalid option
	.word	5$		; new channel
	.word	7$		; exit screen
	.word	9$		; change to fixed scale
	.word	11$		; change to auto scale
	.word	13$		; zero				unused
	.word	14$		; set vertical scale
	.word	16$		; set vertical offset
	.word	18$		; set horizontal scale		unused
	.word	19$		; set horizontal offset		unused

	; New Channel Number

5$:	jsr	a$d$i		; convert to an integer
	cmpb	#0d32		; valid ?
	bhi	6$		; no - skip
	stb	*scrn$sts+1	; save new channel #
	lda	#2		; redraw legends
	sta	*s$state	
6$:	rts

	; Exit Screen

7$:	jsr	ans$yes		; yes ?
	bne	8$		; no - skip
	clr	*s$state	; just exit
8$:	rts

	; Change to Fixed Scale

9$:	jsr	ans$yes		; yes ?
	bne	10$		; no - skip
	lda	avg$vscl,y	; make fixed scale
	ora	#0q200
	sta	avg$vscl,y
	lda	#2		; redraw legends
	sta	*s$state	
10$:	rts

	; Change to Auto Scale

11$:	jsr	ans$yes		; yes ?
	bne	12$		; no - skip
	lda	avg$vscl,y	; make fixed scale
	anda	#~0q200
	sta	avg$vscl,y
	lda	#2		; redraw legends
	sta	*s$state	
12$:	rts

	; Zero

13$:	rts			; unused option

	; Vertical scale

14$:	jsr	a$d$i		; convert to an integer
	cmpb	#0d15
	bhi	15$
	cmpb	#0d4
	blo	15$
	subb	#4		; 2^4 is 16, minimum full scale
	stb	,-s
	ldb	avg$vscl,y	; mask out scale
	andb	#0xF0
	orb	,s+
	stb	avg$vscl,y
15$:	rts
	
	; Vertical Offset

16$:	jsr	a$d$i		; convert to an integer
	tsta
	bmi	17$
	std	avg$vofs,y
17$:	rts

	; Horizontal Scale

18$:	rts			; unused option
	
	; Horizontal Offset

19$:	rts			; unused option


	.page
	.sbttl	Average Pulse Height Histogramming Routine

	.area	SCRNUPDT

	;	Enter with channel number in b
	;
	;	the following stack frame is created :
	;
	;	8,s	u
	;	6,s	y
	;	4,s	x
	;	2,s	d	(4,s)	a	(5,s)	b
	;	0,s	scale jump address
	;

	$OLDU	= 0d8
	$OLDY	= 0d6
	$OLDX	= 0d4
	$OLDD	= 0d2
	$JUMP	= 0d0

avg$hst::
	pshs	d,x,y,u		; save all
	leas	-2,s		; jump address

	cmpb	#0d32		; temperature or LED data ?
	lbhi	12$		; no - exit
	aslb
	ldx	#acqbtbl	; data pointers
	leax	[b,x]
	ldy	#acqvtbl
	leay	[b,y]

1$:	lda	avg$vscl,y
	bmi	9$		; skip if not auto scale

	; auto scaling routine

	pshs	x,y
	leax	acq$avrg,x	; averaged histo data
	ldy	#0d64		; histo length
	ldd	#0		; smallest value
2$:	cmpd	,x++		; find largest
	bhis	3$
	ldd	-2,x
3$:	leay	-1,y
	bne	2$
	puls	x,y

	std	,--s		; save largest

	pshs	x,y
	leax	acq$avrg,x	; averaged histo data
	ldy	#0d64		; histo length
	ldd	#-1		; largest value
4$:	cmpd	,x++		; find smallest
	blos	5$
	ldd	-2,x
5$:	leay	-1,y
	bne	4$
	puls	x,y

	std	,--s		; save smallest

	ldd	2,s		; largest
	subd	0,s		; smallest
	aslb			; (l-s)*2
	rola

	clr	avg$vscl,y	; auto scale

6$:	cmpd	#0d19		; now compute scaling factor
	blos	7$		; 0 - 19 is allowed pulse height
	clc			; divide by two
	rora
	rorb
	inc	avg$vscl,y	; update scaling
	bra	6$

7$:	ldd	,s++		; smallest
	addd	,s++		; smallest
	clc			; (l+s)/2
	rora
	rorb
	std	avg$vofs,y	; save average of min/max

	pshs	x
	lda	avg$vscl,y	; get the scaling factor
	anda	#0x0F
	asla
	ldx	#13$
	ldd	a,x		; 1/2 full scale
	std	,--s

	ldd	avg$vofs,y
	subd	,s++		; (l+s)/2 - 1/2 full scale
	bpl	8$		; no negative offsets
	ldd	#0
8$:	std	avg$vofs,y
	puls	x

	; scale the data and plot

9$:	lda	avg$vscl,y	; get the scaling factor
	anda	#0x0F
	asla
	nega
	leau	11$,pcr		; compute jump address for scaling
	leau	a,u
	stu	$JUMP,s
	leau	acq$avrg,x	; data buffer address
	clr	run$index,y	; clear the index

10$:	ldd	,u++		; get the data
	subd	avg$vofs,y	; take off offset
	jmp	[$JUMP,s]	; do proper scaling
	asra			; / 2^15
	rorb
	asra			; / 2^14
	rorb
	asra			; / 2^13
	rorb
	asra			; / 2^12
	rorb
	asra			; / 2^11
	rorb
	asra			; / 2^10
	rorb
	asra			; / 2^9
	rorb
	asra			; / 2^8
	rorb
	asra			; / 2^7
	rorb
	asra			; / 2^6
	rorb
	asra			; / 2^5
	rorb
	asra			; / 2^4
	rorb
	asra			; / 2^3
	rorb
	asra			; / 2^2
	rorb
	asra			; / 2^1
	rorb
11$:	lda	run$index,y	; column
	jsr	avg$clmn	; plot the data
	inca
	sta	run$index,y	; next column
	cmpa	#0d64		; finished
	blo	10$		; no - loop
	ldu	$OLDU,s		; restore u

	; Vertical Scale Update

	lda	avg$vscl,y	; get the scaling factor
	anda	#0x0F
	asla
	ldx	#13$
	ldd	a,x		; 1/2 full scale
	ldx	avg$vofs,y	; offset
	stx	,--s
	leax	d,x		; offset + 1/2 full scale
	stx	,--s
	leax	d,x		; offset + 2/2 full scale
	lda	#SCRNTP
	ldb	#$HSTCOL-0d8
	jsr	fmt6rjint

	ldx	,s++
	lda	#SCRNTP+0d10
	ldb	#$HSTCOL-0d8
	jsr	fmt6rjint

	ldx	,s++
	lda	#SCRNTP+0d20
	ldb	#$HSTCOL-0d8
	jsr	fmt6rjint

	; Horizontal Scale Update

	ldx	#0d64
	lda	#SCRNTP+0d22
	ldb	#$HSTCOL+$HSTWIDTH-0d5
	jsr	fmt6rjint

	ldx	#0
	lda	#SCRNTP+0d22
	ldb	#$HSTCOL
	jsr	fmt6ljint

	; Average Update

	ldd	acq$sum,y	; get sum of array
	rolb			; divide by 64
	rola
	rolb
	rola
	rolb
	exg	a,b
	anda	#0x03
	std	,--s		; current average

	ldx	#15$
	lda	#SCRNTP+0d22
	ldb	#$HSTCOL+($HSTWIDTH/2)-0d8
	jsr	fmthtxt

	ldx	,s++
	jsr	fmt6ljint

	; finished

12$:	leas	2,s		; pop jump address
	puls	d,x,y,u		; restore all
	rts


13$:	.word	0d10,	0d20,	0d40,	0d80,	0d160,	0d320
	.word	0d640,	0d1280,	0d2560,	0d5120,	0d10240,0d20480

14$:	.word	0d1024,	0d512,	0d256,	0d128,	0d64

15$:	.asciz	"average = "


	.page
	.sbttl	Plot Data in Column

	;  a	-	histo column for new data point
	;  b	-	data value to plot

avg$clmn::
	pshs	d,x		; have added 0d6 to stack frame

	ldx	$OLDU+0d6,s	; get original u
	leax	fmtbuf+$HSTROW*SCRNW+$HSTCOL,x
	leax	a,x		; top of selected column
	lda	#(' )		; space character
	sta	0d0  * SCRNW,x	; clear the whole column fast !
	sta	0d1  * SCRNW,x
	sta	0d2  * SCRNW,x
	sta	0d3  * SCRNW,x
	sta	0d4  * SCRNW,x
	sta	0d5  * SCRNW,x
	sta	0d6  * SCRNW,x
	sta	0d7  * SCRNW,x
	sta	0d8  * SCRNW,x
	sta	0d9  * SCRNW,x
	sta	0d10 * SCRNW,x
	sta	0d11 * SCRNW,x
	sta	0d12 * SCRNW,x
	sta	0d13 * SCRNW,x
	sta	0d14 * SCRNW,x
	sta	0d15 * SCRNW,x
	sta	0d16 * SCRNW,x
	sta	0d17 * SCRNW,x
	sta	0d18 * SCRNW,x
	sta	0d19 * SCRNW,x

	cmpb	#0d19		; check range
	bhi	3$		; don't plot if out of range

	negb			; compute data position within this column
	addb	#0d19
	lda	#SCRNW
	mul
	leax	d,x
	lda	#'*		; plot data point
	ldb	acq$index,y	; check for most recent update
	decb
	bpl	1$
	ldb	#0d63
1$:	cmpb	run$index,y
	bne	2$
	lda	#'@		; most recent
2$:	sta	,x

3$:	puls	d,x
	rts


	.page
	.sbttl	High Voltage Spectrum Screen

	.area	SCREEN

hvh$scrn::
	pshs	d,x,y

1$:	ldb	*s$state	; check state
	beq	3$
	lda	*char
	cmpa	#CTRLW		; redraw screen ?
	bne	2$
	clr	,s		; CTRLW seen
	ldb	#1
	stb	*s$state	; new state
2$:	aslb
	cmpb	#5$-4$		; check for valid state
	blo	3$
	clrb
	stb	*s$state
3$:	ldx	#4$
	jmp	[b,x]

4$:	.word	5$,6$,9$,10$

5$:	ldd	r$lin4		; default option position
	jsr	init$opt
	std	*scrn$pos
	inc	*s$state	; next state

6$:	jsr	clr$scrn	; clear the screen
	jsr	hst$axis	; draw the axis

	tst	*o$state	; active options sequence ?
	beq	8$		; no - skip
	lda	#ENTER		; redo question
	jsr	hst$ques
	tst	*s$strlen	; answer ?
	beq	8$		; no - skip
	ldd	*scrn$pos	; cursor position
	jsr	fmtindex
	leax	s$string,u	; answer string
7$:	lda	,x+		; copy string
	ble	8$
	sta	,y+
	inc	*scrn$pos+1	; update cursor position
	bra	7$

8$:	inc	*s$state	; next state

9$:	jsr	hvh$lgnd	; load up legends
	ldd	*scrn$pos	; reload cursor position
	jsr	pos$scrn
	inc	*s$state	; next state

10$:	tst	*o$state	; processing an option ?
	beq	11$		; no  - skip

	lda	*char		; get the character
	jsr	hvh$optn	; yes - service the option
	sta	*char		; character used

	tst	*s$state	; exit screen ?
	beq	12$		; yes - doit

	tst	*o$state	; processing finished ?
	lbeq	1$		; yes - rescan new settup
	bra	12$

11$:	lda	*char
	jsr	scn$scrl	; try scrolling to a new option
	sta	*char
	beq	12$
	jsr	hst$ques	; try selecting an option
	sta	*char

12$:	puls	d,x,y
	rts


	;
	; hvh$scrn Legends
	;

hvh$lgnd::
	pshs	d,x

	lda	*scrn$sts+1	; channel #
	cmpa	#0d31		; valid LED channel ?
	blos	1$		; yes - skip
	cmpa	#0d32		; valid channel ?
	bhi	3$		; no - exit
	clra			; set to channel 0		
	sta	*scrn$sts+1
1$:	asla
	ldx	#acqvtbl	; acquisition variable table
	leax	[a,x]		; this channel's variables
	clrb			; compute screen entry
	tst	hv$vscl,x
	bpl	2$		; autoscaling
	addb	#2		; scaling
2$:	ldx	#hvh$list	; now get list pointer
	leax	[b,x]

	jsr	scn$lgnd	; do legends
	jsr	scn$chnl	; and channel number

3$:	puls	d,x
	rts


	;
	; hvh$scrn Options
	;

hvh$optn::
	jsr	scn$gets	; build a response string
	beq	3$		; not finished
	tst	*s$string	; NULL string ?
	ble	2$		; yes - terminate option

	jsr	option		; get the option number
	aslb
	cmpb	#5$-4$		; valid option ?
	bhis	2$		; no - terminate request

	lda	*scrn$sts+1	; get channel number
	cmpa	#0d31		; valid channel ?
	bhi	2$		; no - terminate option
	asla

	ldy	#2$		; options return address
	pshs	y

	ldy	#4$		; jump table
	leay	[b,y]		; get address of option routine
	pshs	y		; push as a return address

	leax	s$string,u	; string pointer

	ldy	#acqvtbl	; variables address for this channel
	leay	[a,y]

1$:	rts			; do option

2$:	clr	*o$state	; option completed
	lda	#SCRNBT
	ldb	#0
	jsr	fmtdeol		; clear option question and answer

	ldd	*opt$posn	; option position
	jsr	pos$scrn	; restore cursor

3$:	clra			; input character always used
	rts

4$:	.word	1$		; invalid option
	.word	5$		; new channel
	.word	7$		; exit screen
	.word	9$		; change to fixed scale
	.word	11$		; change to auto scale
	.word	13$		; zero				unused
	.word	14$		; set vertical scale
	.word	16$		; set vertical offset
	.word	18$		; set horizontal scale		unused
	.word	19$		; set horizontal offset		unused

	; New Channel Number

5$:	jsr	a$d$i		; convert to an integer
	cmpb	#0d31		; valid ?
	bhi	6$		; no - skip
	stb	*scrn$sts+1	; save new channel #
	lda	#2		; redraw legends
	sta	*s$state	
6$:	rts

	; Exit Screen

7$:	jsr	ans$yes		; yes ?
	bne	8$		; no - skip
	clr	*s$state	; just exit
8$:	rts

	; Change to Fixed Scale

9$:	jsr	ans$yes		; yes ?
	bne	10$		; no - skip
	lda	hv$vscl,y	; make fixed scale
	ora	#0q200
	sta	hv$vscl,y
	lda	#2		; redraw legends
	sta	*s$state	
10$:	rts

	; Change to Auto Scale

11$:	jsr	ans$yes		; yes ?
	bne	12$		; no - skip
	lda	hv$vscl,y	; make fixed scale
	anda	#~0q200
	sta	hv$vscl,y
	lda	#2		; redraw legends
	sta	*s$state	
12$:	rts

	; Zero

13$:	rts			; unused option

	; Vertical scale

14$:	jsr	a$d$i		; convert to an integer
	cmpb	#0d15
	bhi	15$
	cmpb	#0d4
	blo	15$
	subb	#4		; 2^4 is 16, minimum full scale
	stb	,-s
	ldb	hv$vscl,y	; mask out scale
	andb	#0xF0
	orb	,s+
	stb	hv$vscl,y
15$:	rts
	
	; Vertical Offset

16$:	jsr	a$d$i		; convert to an integer
	tsta
	bmi	17$
	std	hv$vofs,y
17$:	rts

	; Horizontal Scale

18$:	rts			; unused option
	
	; Horizontal Offset

19$:	rts			; unused option


	.page
	.sbttl	High Voltage Histogramming Routine

	.area	SCRNUPDT

	;	Enter with channel number in b
	;
	;	the following stack frame is created :
	;
	;	8,s	u
	;	6,s	y
	;	4,s	x
	;	2,s	d	(4,s)	a	(5,s)	b
	;	0,s	scale jump address
	;

	$OLDU	= 0d8
	$OLDY	= 0d6
	$OLDX	= 0d4
	$OLDD	= 0d2
	$JUMP	= 0d0

hvh$hst::
	pshs	d,x,y,u		; save all
	leas	-2,s		; jump address

	cmpb	#0d31		; LED data ?
	lbhi	13$		; no - exit
	aslb
	ldx	#acqbtbl	; data pointers
	leax	[b,x]
	ldy	#acqvtbl
	leay	[b,y]

1$:	lda	hv$vscl,y
	lbmi	10$		; skip if not auto scale

	; auto scaling routine

	pshs	x,y
	leax	acq$vltg,x	; voltage data
	ldy	#0d64		; histo length
	ldd	#0		; smallest value
2$:	cmpd	,x++		; find largest
	bhis	3$
	ldd	-2,x
3$:	leay	-1,y
	bne	2$
	puls	x,y

	std	,--s		; save largest

	pshs	x,y
	leax	acq$vltg,x	; voltage data
	ldy	#0d64		; histo length
	ldd	#-1		; largest value
	std	,--s
4$:	ldd	,x++		; find smallest greater than 0
	beq	5$
	cmpd	,s		; find smallest
	bhis	5$
	std	,s
5$:	leay	-1,y
	bne	4$
	ldd	,s++
	bpl	6$
	ldd	#0		; if none found then use 0
6$:	puls	x,y

	std	,--s		; save smallest

	ldd	2,s		; largest
	subd	0,s		; smallest
	aslb			; (l-s)*2
	rola

	clr	hv$vscl,y	; auto scale

7$:	cmpd	#0d19		; now compute scaling factor
	blos	8$		; 0 - 19 is allowed pulse height
	clc			; divide by two
	rora
	rorb
	inc	hv$vscl,y	; update scaling
	bra	7$

8$:	ldd	,s++		; smallest
	addd	,s++		; smallest
	clc			; (l+s)/2
	rora
	rorb
	std	hv$vofs,y	; save average of min/max

	pshs	x
	lda	hv$vscl,y	; get the scaling factor
	anda	#0x0F
	asla
	ldx	#14$
	ldd	a,x		; 1/2 full scale
	std	,--s

	ldd	hv$vofs,y
	subd	,s++		; (l+s)/2 - 1/2 full scale
	bpl	9$		; no negative offsets
	ldd	#0
9$:	std	hv$vofs,y
	puls	x

	; scale the data and plot

10$:	lda	hv$vscl,y	; get the scaling factor
	anda	#0x0F
	asla
	nega
	leau	12$,pcr		; compute jump address for scaling
	leau	a,u
	stu	$JUMP,s
	leau	acq$vltg,x	; data buffer address
	clr	run$index,y	; clear the index

11$:	ldd	,u++		; get the data
	subd	hv$vofs,y	; take off offset
	jmp	[$JUMP,s]	; do proper scaling
	asra			; / 2^15
	rorb
	asra			; / 2^14
	rorb
	asra			; / 2^13
	rorb
	asra			; / 2^12
	rorb
	asra			; / 2^11
	rorb
	asra			; / 2^10
	rorb
	asra			; / 2^9
	rorb
	asra			; / 2^8
	rorb
	asra			; / 2^7
	rorb
	asra			; / 2^6
	rorb
	asra			; / 2^5
	rorb
	asra			; / 2^4
	rorb
	asra			; / 2^3
	rorb
	asra			; / 2^2
	rorb
	asra			; / 2^1
	rorb
12$:	lda	run$index,y	; column
	jsr	hvh$clmn	; plot the data
	inca
	sta	run$index,y	; next column
	cmpa	#0d64		; finished
	blo	11$		; no - loop
	ldu	$OLDU,s		; restore u

	; Vertical Scale Update

	lda	hv$vscl,y	; get the scaling factor
	anda	#0x0F
	asla
	ldx	#14$
	ldd	a,x		; 1/2 full scale
	ldx	hv$vofs,y	; offset
	stx	,--s
	leax	d,x		; offset + 1/2 full scale
	stx	,--s
	leax	d,x		; offset + 2/2 full scale
	lda	#SCRNTP
	ldb	#$HSTCOL-0d8
	jsr	fmt6rjint

	ldx	,s++
	lda	#SCRNTP+0d10
	ldb	#$HSTCOL-0d8
	jsr	fmt6rjint

	ldx	,s++
	lda	#SCRNTP+0d20
	ldb	#$HSTCOL-0d8
	jsr	fmt6rjint

	; Horizontal Scale Update

	ldx	#0d64
	lda	#SCRNTP+0d22
	ldb	#$HSTCOL+$HSTWIDTH-0d5
	jsr	fmt6rjint

	ldx	#0
	lda	#SCRNTP+0d22
	ldb	#$HSTCOL
	jsr	fmt6ljint

	; finished

13$:	leas	2,s		; pop jump address
	puls	d,x,y,u		; restore all
	rts


14$:	.word	0d10,	0d20,	0d40,	0d80,	0d160,	0d320
	.word	0d640,	0d1280,	0d2560,	0d5120,	0d10240,0d20480

15$:	.word	0d1024,	0d512,	0d256,	0d128,	0d64


	.page
	.sbttl	Plot Data in Column

	;  a	-	histo column for new data point
	;  b	-	data value to plot

hvh$clmn::
	pshs	d,x		; have added 0d6 to stack frame

	ldx	$OLDU+0d6,s	; get original u
	leax	fmtbuf+$HSTROW*SCRNW+$HSTCOL,x
	leax	a,x		; top of selected column
	lda	#(' )		; space character
	sta	0d0  * SCRNW,x	; clear the whole column fast !
	sta	0d1  * SCRNW,x
	sta	0d2  * SCRNW,x
	sta	0d3  * SCRNW,x
	sta	0d4  * SCRNW,x
	sta	0d5  * SCRNW,x
	sta	0d6  * SCRNW,x
	sta	0d7  * SCRNW,x
	sta	0d8  * SCRNW,x
	sta	0d9  * SCRNW,x
	sta	0d10 * SCRNW,x
	sta	0d11 * SCRNW,x
	sta	0d12 * SCRNW,x
	sta	0d13 * SCRNW,x
	sta	0d14 * SCRNW,x
	sta	0d15 * SCRNW,x
	sta	0d16 * SCRNW,x
	sta	0d17 * SCRNW,x
	sta	0d18 * SCRNW,x
	sta	0d19 * SCRNW,x

	cmpb	#0d19		; check range
	bhi	3$		; don't plot if out of range

	negb			; compute data position within this column
	addb	#0d19
	lda	#SCRNW
	mul
	leax	d,x
	lda	#'*		; plot data point
	ldb	hv$index,y	; check for most recent update
	decb
	bpl	1$
	ldb	#0d63
1$:	cmpb	run$index,y
	bne	2$
	lda	#'@		; most recent
2$:	sta	,x

3$:	puls	d,x
	rts


	.page
	.sbttl	Histogram Axis Drawing

	.area	SCREEN

hst$axis::
	pshs	d,x,y

	ldy	#3$
1$:	ldd	,y++		; get row and column
	std	*fmtrow
	ldx	,y++		; get string
	beq	2$
	jsr	[,y++]		; do proper format routine
	bra	1$

2$:	puls	d,x,y
	rts

3$:	.byte	$HSTROW-1,		$HSTCOL
	.word	4$,  fmthtxt

	.byte	$HSTROW+0d19+1,		$HSTCOL
	.word	4$,  fmthtxt

	.byte	$HSTROW-1,		$HSTCOL-1
	.word	5$,  fmtvtxt

	.byte	$HSTROW-1,		$HSTCOL+$HSTWIDTH
	.word	5$,  fmtvtxt

	.byte	0,			0
	.word	0

4$:
.asciz	"+-------+-------+-------+-------+-------+-------+-------+-------+"

5$:
.asciz	"+IIII+IIII+IIII+IIII++"


	.page
	.sbttl	Screen Lists

phs$list:
	.word	phs$dauto,	phs$tauto,	phs$dscal,	phs$tscal

phs$dauto:
	.word	n$lind,	n$lin2p,r$lin4,	r$lin5a,r$lin6
	.word	n$lin7,	n$lin8,	r$lin9,	r$lin10,r$lin3,	0

phs$tauto:
	.word	n$lint,	n$lin2p,r$lin4,	r$lin5a,r$lin6
	.word	n$lin7,	n$lin8,	r$lin9,	r$lin10,r$lin3,	0

phs$dscal:
	.word	n$lind,	n$lin2p,r$lin4,	r$lin5s,r$lin6
	.word	r$lin7,	r$lin8,	r$lin9,	r$lin10,r$lin3,	0

phs$tscal:
	.word	n$lint,	n$lin2p,r$lin4,	r$lin5s,r$lin6
	.word	r$lin7,	r$lin8,	r$lin9,	r$lin10,r$lin3,	0


avg$list:
	.word	avg$dauto,	avg$tauto,	avg$dscal,	avg$tscal

avg$dauto:
	.word	n$lind,	n$lin2a,r$lin4,	r$lin5a
	.word	n$lin7,	n$lin8,	r$lin3,	0

avg$tauto:
	.word	n$lint,	n$lin2a,r$lin4,	r$lin5a
	.word	n$lin7,	n$lin8,	r$lin3,	0

avg$dscal:
	.word	n$lind,	n$lin2a,r$lin4,	r$lin5s
	.word	r$lin7,	r$lin8,	r$lin3,	0

avg$tscal:
	.word	n$lint,	n$lin2a,r$lin4,	r$lin5s
	.word	r$lin7,	r$lin8,	r$lin3,	0


hvh$list:
	.word	hvh$dauto,	hvh$dscal

hvh$dauto:
	.word	n$linh,	n$lin2h,r$lin4,	r$lin5a
	.word	n$lin7,	n$lin8,	r$lin3,	0

hvh$dscal:
	.word	n$lind,	n$lin2h,r$lin4,	r$lin5s
	.word	r$lin7,	r$lin8,	r$lin3,	0

	;	row		column		video		option
	;-------------------------------------------------------------
n$lind	= .
	.byte	SCRNTP+0d1,	1,		NORMAL,		0
	.word	1$		; "Detector"
n$lint	= .
	.byte	SCRNTP+0d1,	1,		NORMAL,		0
	.word	2$		; "Temperature"
n$linh	= .
	.byte	SCRNTP+0d1,	1,		NORMAL,		0
	.word	5$		; "H. V."
n$lin2p	= .
	.byte	SCRNTP+0d2,	1,		NORMAL,		0
	.word	3$		; "P.H.S."
n$lin2a	= .
	.byte	SCRNTP+0d2,	1,		NORMAL,		0
	.word	4$		; "Averages"
n$lin2h	= .
	.byte	SCRNTP+0d2,	1,		NORMAL,		0
	.word	6$		; "Updates"
r$lin3	= .
	.byte	SCRNTP+0d4,	1,		REVERSE,	1
	.word	7$		; "Channel #"
r$lin4	= .
	.byte	SCRNTP+0d6,	1,		REVERSE,	2
	.word	8$		; "Exit"
r$lin5a	= .
	.byte	SCRNTP+0d8,	1,		REVERSE,	3
	.word	9$		; "Change Mode"
r$lin5s	= .
	.byte	SCRNTP+0d8,	1,		REVERSE,	4
	.word	9$		; "Change Mode"
r$lin6	= .
	.byte	SCRNTP+0d12,	1,		REVERSE,	5
	.word	10$		; "Zero"
n$lin7	= .
	.byte	SCRNTP+0d14,	1,		NORMAL,		0
	.word	11$		; "V Scale"
r$lin7	= .
	.byte	SCRNTP+0d14,	1,		REVERSE,	6
	.word	11$		; "V Scale"
n$lin8	= .
	.byte	SCRNTP+0d15,	1,		NORMAL,		0
	.word	12$		; "V Offset"
r$lin8	= .
	.byte	SCRNTP+0d15,	1,		REVERSE,	7
	.word	12$		; "V Offset"
r$lin9	= .
	.byte	SCRNTP+0d17,	1,		REVERSE,	8
	.word	13$		; "H Scale"
r$lin10	= .
	.byte	SCRNTP+0d18,	1,		REVERSE,	9
	.word	14$		; "H Offset"


1$:	.asciz	"  Detector "		; channels 0-31
2$:	.asciz	"Temperature"		; channel 32
3$:	.asciz	"   P.H.S.  "
4$:	.asciz	"  Averages "
5$:	.asciz	"   H. V.   "
6$:	.asciz	"  Updates  "
7$:	.asciz	"Channel #  "		; 1
8$:	.asciz	"Exit Screen"		; 2
9$:	.asciz	"Change Mode"		; 3/4
10$:	.asciz	"    Zero   "		; 5
11$:	.asciz	" V. Scale  "		; 6
12$:	.asciz	" V. Offset "		; 7
13$:	.asciz	" H. Scale  "		; 8
14$:	.asciz	" H. Offset "		; 9


	;
	; xxx$scrn Questions
	;

hst$ques::
	cmpa	#ENTER		; selecting ?
	bne	5$		; no - exit

	pshs	b,x,y

	lda	#SCRNBT		; common question position
	ldb	#0
	jsr	fmtindex

	leax	optarray,u	; get option
	ldb	*opt$posn
	ldb	b,x

	cmpb	#2		; exit screen option ?
	bne	1$		; no - skip
	clr	*s$state	; immediate exit

1$:	aslb
	cmpb	#8$-6$		; valid option ?
	bhis	4$		; no - exit
	ldx	#6$
	leax	[b,x]
2$:	lda	,x+
	beq	3$
	sta	,y+
	inc	*fmtcol		; next column
	bra	2$

3$:	ldd	*fmtrow		; load new cursor position
	jsr	pos$scrn
	lda	#1		; option processing
	sta	*o$state
4$:	clra			; dump character
	puls	b,x,y
5$:	rts


6$:	.word	7$,8$,9$,10$,11$,12$,13$,14$,15$,16$

7$:	.asciz	"Invalid Selection"					; 0
8$:	.asciz	"Select New Channel -> "				; 1
9$:	.asciz	"... Exitting this Screen ..."				; 2
10$:	.asciz	"Change to Fixed Scaling (Y,N) ? -> "			; 3
11$:	.asciz	"Change to Auto Scaling (Y,N) ? -> "			; 4
12$:	.asciz	"Zero Histogram (Y,N) ? -> "				; 5
13$:	.asciz	"Enter Vertical Scale = 2^n (n = 4,15) -> "		; 6
14$:	.asciz	"Enter Vertical Offset (0-32767) -> "			; 7
15$:	.asciz	"Enter Horizontal Scale = 2^n (n = 6,10) -> "		; 8
16$:	.asciz	"Enter Horizontal Offset (0-1023) -> "			; 9


