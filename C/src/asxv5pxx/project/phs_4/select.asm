	.sbttl	Screen Selector

	.module	select

	.include	/area.def/
	.include	/define.def/

	.area	SELECT

sel$scrn::
	ldd	*scrn$sts	; screen status
	bpl	2$		; inactive - skip
	anda	#0x0F		; mask to screen select
	beq	1$		; if slc$scrn - skip
	asla
	cmpa	#4$-3$		; valid screen ?
	bhis	2$		; no - skip
	ldx	#3$		; screen execution list
	jsr	[a,x]		; execute routine

	tst	*s$state	; exiting from a screen ?
	bne	2$		; no - skip
	clr	*char		; no character
	lda	*scrn$sts	; screen #
	anda	#~0x0F
	sta	*scrn$sts
	bra	sel$scrn	; else - rescan

1$:	jsr	[3$,pcr]	; selection screen
	tst	*s$state	; exiting to a screen ?
	beq	sel$scrn	; yes - loop

2$:	rts

	; Forground Screen Update List

3$:	.word	slc$scrn	; selection screen
	.word	sph$scrn	; P.H.S. status screen
	.word	chn$scrn	; channel control / status screen
	.word	phs$scrn	; pulse height screen
	.word	avg$scrn	; average pulse height screen
	.word	prm$scrn	; stabilization parameters screen
	.word	shv$scrn	; HV4032A status screen
	.word	hvh$scrn	; high voltage histo screen
	.word	hvu$scrn	; high voltage update screen
	.word	hlp$scrn	; setup / help screens
4$:

	.page
	.sbttl	Update Variables

	.area	BUFSAV

tics::		.blkb	0d1	; tics
seconds::	.blkb	0d1	; seconds
minutes::	.blkb	0d1	; minutes
hours::		.blkb	0d1	; hours
days::		.blkb	0d1	; days
pri$low::	.blkb	0d1	; low priority active flag


	.area	SCRNUPDT

upd$scrn::
	inc	tics
	lda	#0d120		; ~ 120 tics per second
	cmpa	tics
	bhi	1$
	clr	tics
	
	inc	seconds
	lda	#0d60
	cmpa	seconds
	bhi	1$
	clr	seconds

	inc	minutes
	lda	#0d60
	cmpa	minutes
	bhi	1$
	clr	minutes

	inc	hours
	lda	#0d24
	cmpa	hours
	bhi	1$
	clr	hours

	inc	days		; maximum is 44/23:59
	lda	#0d45
	cmpa	days
	bhi	1$
	clr	days

	; High Priority Acquisition

1$:	jsr	chan$upd	; do acquisition / LED panel

	; Low Priority Routines

	tst	pri$low		; busy ?
	bne	3$		; yes - skip

	inc	pri$low		; busy
	pshs	cc
	andcc	#0q257		; enable interrupts

	jsr	que$proc	; process the HV queue/port

	ldu	#port0		; local port
	jsr	outblk
	ldu	#port1		; remote port
	jsr	outblk

	tst	tics		; 1 second routines
	bne	2$

	jsr	led$comp	; LED temperature compensation

	; Specific Screen Update Routines

	ldu	#port0		; local port
	bsr	4$
	ldu	#port1		; remote port
	bsr	4$

2$:	puls	cc
	clr	pri$low		; not busy

3$:	rts

4$:	tfr	u,d		; setup dp
	tfr	a,dp
	ldd	*scrn$sts	; screen status
	bpl	5$		; inactive - exit
	anda	#0x0F		; mask to screen select
	asla
	cmpa	#7$-6$		; valid screen
	bhis	5$		; no - skip
	ldx	#6$		; screen execution list
	jsr	[a,x]		; execute routine
5$:	rts

	; Background Screen Update List

6$:	.word	5$		; screen 0
	.word	sph$updt	; screen 1
	.word	chn$updt	; screen 2
	.word	phs$hst		; screen 3
	.word	avg$hst		; screen 4
	.word	prm$updt	; screen 5
	.word	shv$updt	; screen 6
	.word	hvh$hst		; screen 7
	.word	hvu$updt	; screen 8
	.word	5$		; screen 9
7$:

	.page
	.sbttl	Channel Status Screen

	.area	SCREEN

slc$scrn::
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

4$:	.word	5$,7$,8$,9$

5$:	ldd	*slc$optp	; get last position
	bne	6$		; if none - use default
	ldd	r$slc1		; default option position
6$:	jsr	init$opt
	std	*scrn$pos
	inc	*s$state	; next state

7$:	jsr	clr$scrn	; clear the screen
	jsr	slc$page	; do page outline
	inc	*s$state	; next state

8$:	jsr	slc$lgnd	; load up legends
	ldd	*scrn$pos	; reload cursor position
	jsr	pos$scrn
	inc	*s$state	; next state

9$:	lda	*char
	jsr	scn$scrl	; try scrolling to a new option
	sta	*char
	bne	10$
	lda	*opt$posn	; save the option position
	ldb	#$SLCPOS
	std	*slc$optp
	bra	11$
10$:	jsr	slc$slct	; try selecting a new screen
	sta	*char

11$:	puls	d,x,y
	rts


	; slc$scrn  Page Outline

slc$page::
	ldy	#3$
1$:	ldd	,y++
	ldx	,y++
	beq	2$
	jsr	fmthtxt
	bra	1$

	; fill in unit number

2$:	ldd	*fmtrow		; end of last entry
	jsr	scn$unit
	rts


3$:	.byte	SCRNTP+0d0,	0d30
	.word	4$
	.byte	SCRNTP+0d19,	0d24
	.word	6$
	.byte	SCRNTP+0d20,	0d18
	.word	7$
	.byte	SCRNTP+0d21,	0d18
	.word	8$
	.byte	SCRNTP+0d22,	0d16
	.word	9$
	.byte	SCRNTP+0d15,	0d30		; unit number
	.word	5$
	.byte	0,		0		; end of list
	.word	0

4$:	.asciz	              "P.H.S.   System"

5$:	.asciz		      "P.H.S. Unit # "

6$:	.asciz	        "^W (control-W) redraws screen"
7$:	.asciz	  "Use UP / DOWN Arrows to move to an option"
8$:	.asciz	  "Select option with the keypad 'ENTER' key"
9$:	.asciz	"Terminate option entry with 'RETURN' or 'ENTER'"


	;
	; slc$scrn Legends
	;

slc$lgnd::
	pshs	x

	ldx	#1$
	jsr	scn$lgnd	; do legends

	puls	x
	rts

	; Channel Control

1$:	.word	r$slc1,	r$slc2,	r$slc3,	r$slc4,	r$slc5
	.word	r$slc6,	r$slc7, r$slc8, r$slc9,	0

	$SLCPOS  =  0d25

	;	row		column		video		option
	;-------------------------------------------------------------
r$slc1:
	.byte	SCRNTP+0d3,	$SLCPOS,	REVERSE,	1
	.word	2$		; "P.H.S. System Status"
r$slc2	= .
	.byte	SCRNTP+0d4,	$SLCPOS,	REVERSE,	2
	.word	3$		; "Channel Control / Status"
r$slc3	= .
	.byte	SCRNTP+0d5,	$SLCPOS,	REVERSE,	3
	.word	4$		; "Pulse Height Spectra"
r$slc4	= .
	.byte	SCRNTP+0d6,	$SLCPOS,	REVERSE,	4
	.word	5$		; "Pulse Height Averages"
r$slc5	= .
	.byte	SCRNTP+0d7,	$SLCPOS,	REVERSE,	5
	.word	6$		; "Stabilization Parameters"
r$slc6	= .
	.byte	SCRNTP+0d8,	$SLCPOS,	REVERSE,	6
	.word	7$		; "HV4032A Status"
r$slc7	= .
	.byte	SCRNTP+0d9,	$SLCPOS,	REVERSE,	7
	.word	8$		; "High Voltage Histograms"
r$slc8	= .
	.byte	SCRNTP+0d10,	$SLCPOS,	REVERSE,	8
	.word	9$		; "High Voltage Updates"
r$slc9	= .
	.byte	SCRNTP+0d11,	$SLCPOS,	REVERSE,	9
	.word	10$		; "Setup and Help"

;          1111111111222222222233333333334444444444555555555566666666667
;01234567890123456789012345678901234567890123456789012345678901234567890
2$:	.asciz		 "   P.H.S. System Status   "	; 1
3$:	.asciz	         " Channel Control / Status "	; 2
4$:	.asciz	         "   Pulse Height Spectra   "	; 3
5$:	.asciz	         "   Pulse Height Averages  "	; 4
6$:	.asciz		 " Stabilization Parameters "	; 5
7$:	.asciz	         "      HV4032A Status      "	; 6
8$:	.asciz	         "  High Voltage Histograms "	; 7
9$:	.asciz	         "   High Voltage Updates   "	; 8
10$:	.asciz	         "      Setup and Help      "	; 9


	;
	; slc$scrn Selection
	;

slc$slct::
	cmpa	#ENTER		; selecting ?
	bne	1$		; no - exit

	pshs	b,x
	lda	*scrn$sts
	anda	#~0x0F		; mask out old screen number
	leax	optarray,u	; get option
	ldb	*opt$posn
	ora	b,x		; mask in new screen number
	sta	*scrn$sts
	clr	*s$state	; new screen
	clra			; dump character
	puls	b,x

1$:	rts


	.page
	.sbttl	Screen Utilities

	; Clear Screen

clr$scrn::
	pshs	a

	pshs	cc
	orcc	#0q120		; hold interrupts
	lda	*scrn$sts	; set clear screen bit
	ora	#0q100
	sta	*scrn$sts
	puls	cc		; restore interrupts

	tst	*scrn$sts
	bpl	2$		; screen not on - don't wait
1$:	lda	#0q100
	bita	*scrn$sts	; wait for completion
	bne	1$
2$:	puls	a
	rts


	; Position Cursor on Screen

pos$scrn::
	pshs	d
	std	*scrn$pos	; load position

	pshs	cc
	orcc	#0q120		; hold interrupts
	lda	*scrn$sts	; set position flag
	ora	#0q040
	sta	*scrn$sts
	puls	cc		; restore interrupts

	puls	d
	rts

	;
	;  Initialize the scanning options array
	;

init$opt::
	pshs	d,x

	ldb	#SCRNBT-SCRNTP+1
	leax	optarray,u
1$:	clr	,x+		; clear options list
	decb
	bgt	1$

	puls	d,x

	tstb
	beq	2$
	decb
	beq	2$
	decb
2$:	std	*opt$posn	; save default option position
	clr	*o$state	; no options selected
	rts

	;
	; Return current option display row in a
	; Return current option number in b
	;

option::
	pshs	x
	leax	optarray,u
	lda	*opt$posn
	ldb	a,x
	puls	x
	rts


	; Check for a 'yes' answer
	;
	;	eq if yes
	;	ne if no
	;

ans$yes::
	lda	*s$string	; get character
	cmpa	#'Y
	beq	1$
	cmpa	#'y
1$:	rts


	; Build a string from the input character stream.
	;
	; This routine never blocks and returns a NULL
	; until a terminator is found.
	;
	; input:
	;	a	-	keyboard input
	;
	; output:
	;	a	-	NULL or termination character
	;

scn$gets::
	pshs	b,x,y
	pshs	a

	leax	s$string,u	; local string buffer
	lda	*s$strlen
	leax	a,x		; next string position ,x
	ldd	*scrn$pos	; screen
	std	*fmtrow
	jsr	fmtindex	; next fmtbuf position ,y

	puls	a

	; DEL and BS checks

	cmpa	#0q010		; BS ?
	beq	1$
	cmpa	#0q177		; DEL ?
	bne	3$

1$:	tst	*s$strlen	; any characters ?
	beq	2$
	jsr	13$		; delete a character
2$:	bra	11$

	; ^U check

3$:	cmpa	#'U & 0x1F	; ^U ?
	bne	6$

	ldb	*s$strlen	; any characters ?
	beq	5$
4$:	jsr	13$		; delete the characters
	decb
	bgt	4$
5$:	bra	11$

	; Termination of line

6$:	cmpa	#0q015		; CR ?
	beq	7$		; yes - finish up
	cmpa	#ENTER		; keypad ENTER ?
	bne	8$		; no - skip

7$:	clr	*s$strlen	; input done
	bra	12$		; return termination character

	; Any non printing character

8$:	cmpa	#(' )		; any non printing character ?
	blt	9$		; yes - just ring BELL

	; Room Check

	ldb	#0d16-1		; space ?
	cmpb	*s$strlen
	bhi	10$		; yes - skip

9$:	lda	#0q007		; BELL
	jsr	tt_out
	bra	11$

	; Add a character

10$:	sta	,x+		; in string
	sta	,y		; in buffer
	inc	*scrn$pos+1	; forward one space
	inc	*s$strlen	; one more character in string
	lda	*scrn$pos	; make outblk scan this line
	sta	*index

	; Exit

11$:	clra			; NULL return

12$:	clr	,x		; terminate string always
	puls	b,x,y
	tsta			; set cc's
	rts

	; Delete Character Routine
	
13$:	lda	#(' )		; erase buffer charatcer
	sta	,-y
	dec	*scrn$pos+1	; backup up one space
	dec	*s$strlen	; one less character in string
	lda	*scrn$pos	; make outblk scan this line
	sta	*index
	rts


	;
	; xxx$scrn  Scroll to next option position
	;

scn$scrl::
	pshs	b,x
	leax	optarray,u	; get current option line
	ldb	*opt$posn

	; moving cursor up

	cmpa	#SCRLU
	bne	2$
1$:	cmpb	#SCRNTP
	beq	4$
	decb
	tst	b,x
	beq	1$
	bra	4$

	; moving cursor down

2$:	cmpa	#SCRLD
	bne	6$
3$:	cmpb	#SCRNBT
	beq	4$
	incb
	tst	b,x
	beq	3$

4$:	tst	b,x		; new option ?
	beq	5$		; no - exit
	stb	*opt$posn

	ldd	*opt$posn
	jsr	pos$scrn

5$:	clra			; character used

6$:	puls	b,x
	rts			; return position


	.page
	.sbttl	Screen Legends

	; This puts the list of legends on the screen
	;
	; Enter with x pointing to a list of screen entries.
	; If the scn$chnl routine is to be used, the last screen
	; line must must be the "Channel #  " entry.

scn$lgnd::
	pshs	d,y
	leas	-3,s

1$:	stx	1,s
	ldx	,x		; next entry
	beq	5$		; finished
	ldd	,x++		; row/column
	jsr	fmtindex
	ldb	,x+		; video mode
	stb	,s
	ldb	,x+		; option
	ldx	,x++		; get string address

2$:	lda	,x+		; get string character
	beq	3$
	ora	,s		; set NORMAL/REVERSE video
	sta	,y+		; place in buffer
	bra	2$

3$:	sty	*findex		; save position
	leay	optarray,u	; save option number
	lda	*fmtrow
	stb	a,y
4$:	ldx	1,s
	leax	2,x		; next entry
	bra	1$

5$:	leas	3,s
	puls	d,y
	rts

	; Place the channel number on the screen

scn$chnl::
	pshs	d,x,y
	leas	-4,s		; result space

	tfr	s,x		; place output string at ,s
	clr	,-s		; front termination
	ldb	*scrn$sts+1	; channel #
	jsr	i$b$dz		; convert to decimal ascii / zeros suppressed
				; returns x pointing at string termination
	ldy	*findex		; output position + 1

1$:	lda	,-x		; get character
	ble	2$
	ora	#0q200		; reverse video !
	sta	,-y
	bra	1$

2$:	leas	5,s		; pop output string
	puls	d,x,y
	rts

	; Place the unit number on the screen

scn$unit::
	pshs	d,x,y
	jsr	fmtindex	; position to place unit number

	leas	-4,s		; result space

	tfr	s,x		; place output string at ,s
	clr	,-s		; front termination
	ldb	sys$id		; unit #
	andb	#0x0F
	jsr	i$b$hz		; convert to hexidecimal / zeros suppressed
				; returns x pointing at string termination

	lda	,-x		; get character
	sta	,y

	leas	5,s		; pop output string
	puls	d,x,y
	rts

