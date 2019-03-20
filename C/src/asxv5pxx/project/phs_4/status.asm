	.page
	.sbttl	Status Screens

	.module	status

	.include	/area.def/
	.include	/define.def/

	.area	SCREEN

	.sbttl	P.H.S. Status Screen

sph$scrn::
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

5$:	ldd	r$sph1		; default option position
	jsr	init$opt
	std	*scrn$pos
	inc	*s$state	; next state

6$:	jsr	clr$scrn	; clear the screen
	jsr	sph$page	; draw the axis

	tst	*o$state	; active options sequence ?
	beq	8$		; no - skip
	lda	#ENTER		; redo question
	jsr	sph$ques
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

9$:	jsr	sph$lgnd	; load up legends
	ldd	*scrn$pos	; reload cursor position
	jsr	pos$scrn
	inc	*s$state	; next state

10$:	tst	*o$state	; processing an option ?
	beq	11$		; no  - skip

	lda	*char		; get the character
	jsr	sph$optn	; yes - service the option
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
	jsr	sph$ques	; try selecting an option
	sta	*char

12$:	puls	d,x,y
	rts


	; sph$scrn  Page Outline

sph$page::
	ldy	#5$
1$:	ldd	,y++
	ldx	,y++
	beq	2$
	jsr	fmthtxt
	bra	1$

	; fill in unit number

2$:	ldd	*fmtrow		; last entry
	jsr	scn$unit

	; fill in channel numbers

	lda	#SCRNTP+0d7
	ldb	#$CHNL
	ldx	#0d0		; first channel

3$:	jsr	fmt4rjint	; load channel
	inca			; next row
	leax	1,x		; next channel
	cmpx	#0d16
	bne	4$
	lda	#SCRNTP+0d7
	ldb	#$CHNL+0d40
4$:	cmpx	#0d32
	bne	3$

	rts


5$:	.byte	SCRNTP+4,	0
	.word	6$
	.byte	SCRNTP+5,	0
	.word	7$
	.byte	SCRNTP+6,	0
	.word	8$
	.byte	SCRNTP+4,	0d40
	.word	6$
	.byte	SCRNTP+5,	0d40
	.word	7$
	.byte	SCRNTP+6,	0d40
	.word	8$
n$spht	= .
	.byte	SCRNTP+2,	0d41
	.word	10$
	.byte	SCRNTP+0,	0d41		; must be last
	.word	9$
	.byte	0,		0		; end of list
	.word	0

	;	 0123456789012345678901234567890123456789"
6$:	.asciz	"              UPDATING  CALIBRATION     "
7$:	.asciz	" CHNL PHS-STS PEAK LDRV PEAK LDRV TEMP  "
8$:	.asciz	" ---- ------- ---- ---- ---- ---- ----  "

9$:	.asciz	"P.H.S. System Status     Unit # "
10$:	.asciz	"Temperature ADC = "

	$CHNL		=	0d0
	$PHSSTS		=	0d7
	$UPDTPEAK	=	0d14
	$UPDTLDRV	=	0d19
	$CALPEAK	=	0d24
	$CALLDRV	=	0d29
	$CALTEMP	=	0d34
	$TMPPOS		=	0d18


	;
	; sph$scrn Legends
	;

sph$lgnd::
	pshs	d,x,y
	leas	-3,s

	ldx	#6$

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
	puls	d,x,y
	rts


6$:	.word	r$sph1,	0

	;	row		column		video		option
	;-------------------------------------------------------------
r$sph1:	.byte	SCRNTP+0d0,	3,		REVERSE,	1
	.word	1$		; "Exit"


1$:	.asciz	"  Exit Screen   "		; 1



	;
	; sph$scrn Questions
	;

sph$ques::
	cmpa	#ENTER		; selecting ?
	bne	5$		; no - exit

	pshs	b,x,y

	lda	#SCRNBT		; common question position
	ldb	#0
	jsr	fmtindex

	leax	optarray,u	; get option
	ldb	*opt$posn
	ldb	b,x

	cmpb	#1		; exiting this screen ?
	bne	1$		; no - skip
	clr	*s$state	; yes

1$:	aslb
	cmpb	#7$-6$		; valid option ?
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


6$:	.word	7$,8$

7$:	.asciz	"Invalid Option"
8$:	.asciz	"... Exiting this Screen ..."			; 1

	;
	; sph$scrn Options
	;

sph$optn::
	jsr	scn$gets	; build a response string
	beq	3$		; not finished
	tst	*s$string	; NULL string ?
	ble	2$		; yes - terminate option

	jsr	option		; get the option number
	aslb
	cmpb	#5$-4$		; valid option ?
	bhis	2$		; no - terminate request

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
	.word	5$		; exit screen

	; Exit Screen

5$:	jsr	ans$yes
	bne	6$
	clr	*s$state	; just exit
6$:	rts


	; sph$scrn  Update Routine

	.area	SCRNUPDT

sph$updt::

	; Temperature ADC Data

	ldy	#tmpvar

	ldd	n$spht		; get entry
	addb	#$TMPPOS	; position

	tst	tmp$flag,y
	beq	1$

	ldx	phs$avrg,y	; get last scan
	jsr	fmt4rjint
	bra	2$

1$:	ldx	#27$		; inactive
	jsr	fmthtxt

	; fill in acquisition status

2$:	ldy	#acqvar		; acquisition variables
	lda	#SCRNTP+0d7	; screen position
	ldb	#$PHSSTS

3$:	pshs	d
	lda	acq$sts,y
	anda	#0x0F		; just acq status
	asla
	ldx	#26$
	leax	[a,x]
	ldd	,s
	jsr	fmthtxt
	puls	d

	leay	ACQVARSZ,y	; next channel
	inca			; next row
	cmpa	#SCRNTP+0d7+0d16
	bne	3$
	lda	#SCRNTP+0d7
	cmpb	#$PHSSTS+0d40
	beq	4$
	ldb	#$PHSSTS+0d40
	bra	3$

	; fill in current PHS value

4$:	ldy	#acqvar		; acquisition variables
	lda	#SCRNTP+0d7	; screen position
	ldb	#$UPDTPEAK

5$:	pshs	d
	lda	acq$sts,y
	anda	#0x0F
	beq	6$

	ldx	phs$avrg,y	; last PHS scan
	ldd	,s
	jsr	fmt4rjint
	bra	7$

6$:	ldx	#27$		; inactive
	ldd	,s
	jsr	fmthtxt
7$:	puls	d

	leax	ACQBUFSZ,x	; next channel
	leay	ACQVARSZ,y
	inca			; next row
	cmpa	#SCRNTP+0d7+0d16
	bne	5$
	lda	#SCRNTP+0d7
	cmpb	#$UPDTPEAK+0d40
	beq	8$
	ldb	#$UPDTPEAK+0d40
	bra	5$

	; fill in current LED drive

8$:	ldy	#acqvar		; acquisition variables
	lda	#SCRNTP+0d7	; screen position
	ldb	#$UPDTLDRV

9$:	pshs	d
	lda	acq$sts,y
	anda	#0x0F
	beq	10$

	ldx	cor$lpht,y	; current
	ldd	,s
	jsr	fmt4rjint
	bra	11$

10$:	ldx	#27$		; inactive
	ldd	,s
	jsr	fmthtxt
11$:	puls	d

	leax	ACQBUFSZ,x	; next channel
	leay	ACQVARSZ,y
	inca			; next row
	cmpa	#SCRNTP+0d7+0d16
	bne	9$
	lda	#SCRNTP+0d7
	cmpb	#$UPDTLDRV+0d40
	beq	12$
	ldb	#$UPDTLDRV+0d40
	bra	9$

	; fill in PHS Calibration

12$:	ldy	#acqvar		; acquisition variables
	lda	#SCRNTP+0d7	; screen position
	ldb	#$CALPEAK

13$:	pshs	d
	lda	acq$sts,y
	anda	#0x0F
	beq	15$
	ldx	phs$lpht,y	; calibration ready ?
	bne	14$		; yes - use it
				; else use updating value

	; divide acq$sum by 64

	ldd	acq$sum,y	; get sum
	rolb			; divide by 64
	rola
	rolb
	rola
	rolb
	exg	a,b
	anda	#0x03
	tfr	d,x
14$:	ldd	,s
	jsr	fmt4rjint
	bra	16$

15$:	ldx	#27$		; inactive
	ldd	,s
	jsr	fmthtxt
16$:	puls	d

	leay	ACQVARSZ,y	; next channel
	inca			; next row
	cmpa	#SCRNTP+0d7+0d16
	bne	13$
	lda	#SCRNTP+0d7
	cmpb	#$CALPEAK+0d40
	beq	17$
	ldb	#$CALPEAK+0d40
	bra	13$

	; fill in LED calibration

17$:	ldy	#acqvar		; acquisition variables
	lda	#SCRNTP+0d7	; screen position
	ldb	#$CALLDRV

18$:	pshs	d
	lda	acq$sts,y
	anda	#0x0F
	beq	19$

	ldx	cal$lpht,y	; LED calibration
	ldd	,s
	jsr	fmt4rjint
	bra	20$

19$:	ldx	#27$		; inactive
	ldd	,s
	jsr	fmthtxt
20$:	puls	d

	leax	ACQBUFSZ,x	; next channel
	leay	ACQVARSZ,y
	inca			; next row
	cmpa	#SCRNTP+0d7+0d16
	bne	18$
	lda	#SCRNTP+0d7
	cmpb	#$CALLDRV+0d40
	beq	21$
	ldb	#$CALLDRV+0d40
	bra	18$

	; fill in calibration temperature

21$:	ldy	#acqvar		; acquisition variables
	lda	#SCRNTP+0d7	; screen position
	ldb	#$CALTEMP

22$:	pshs	d
	lda	acq$sts,y
	anda	#0x0F
	beq	23$

	tst	tmp$flag,y
	beq	23$

	ldx	tmp$lpht,y	; Temperature calibration
	ldd	,s
	jsr	fmt4rjint
	bra	24$

23$:	ldx	#27$		; inactive
	ldd	,s
	jsr	fmthtxt
24$:	puls	d

	leax	ACQBUFSZ,x	; next channel
	leay	ACQVARSZ,y
	inca			; next row
	cmpa	#SCRNTP+0d7+0d16
	bne	22$
	lda	#SCRNTP+0d7
	cmpb	#$CALTEMP+0d40
	beq	25$
	ldb	#$CALTEMP+0d40
	bra	22$

25$:	rts


	; Acquisition Status Table

				; 0bxxxxxxxx
				;	|||`---- $SCAN
				;	||`----- $FAILED
				;	|`------ $HOLD
				;	`------- $ACTIVE
26$:	.word	28$		;       0000	inactive
	.word	29$		;	0001	cal
	.word	30$		;	0010	failed
	.word	30$		;	0011	failed
	.word	31$		;	0100	hold
	.word	31$		;	0101	hold
	.word	30$		;	0110	failed
	.word	30$		;	0111	failed
	.word	32$		;	1000	active
	.word	32$		;	1001	active
	.word	30$		;	1010	failed
	.word	30$		;	1011	failed
	.word	31$		;	1100	hold
	.word	31$		;	1101	hold
	.word	30$		;	1110	failed
	.word	30$		;	1111	failed


27$:	.asciz	"    "		; inactive (data)
28$:	.asciz	"      "	; inactive (ascii)
29$:	.asciz	"   Cal"
30$:	.asciz	"  Fail"
31$:	.asciz	"  Hold"
32$:	.asciz	"Active"


	.area	SCREEN

	.sbttl	HV4032A Status Screen

shv$scrn::
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

5$:	ldb	#0d32		; always check HV status
	lda	#M16S
	jsr	en$que
	ldd	r$shv1		; default option position
	jsr	init$opt
	std	*scrn$pos
	inc	*s$state	; next state

6$:	jsr	clr$scrn	; clear the screen
	jsr	shv$page	; draw the axis

	tst	*o$state	; active options sequence ?
	beq	8$		; no - skip
	lda	#ENTER		; redo question
	jsr	shv$ques
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

9$:	jsr	shv$lgnd	; load up legends
	ldd	*scrn$pos	; reload cursor position
	jsr	pos$scrn
	inc	*s$state	; next state

10$:	tst	*o$state	; processing an option ?
	beq	11$		; no  - skip

	lda	*char		; get the character
	jsr	shv$optn	; yes - service the option
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
	jsr	shv$ques	; try selecting an option
	sta	*char

12$:	puls	d,x,y
	rts


	; shv$scrn  Page Outline

shv$page::
	ldy	#5$
1$:	ldd	,y++
	ldx	,y++
	beq	2$
	jsr	fmthtxt
	bra	1$

	; fill in unit number

2$:	ldd	*fmtrow		; last entry
	jsr	scn$unit

	; fill in channel numbers

	lda	#SCRNTP+6
	ldb	#$CHNL
	ldx	#0d0		; first channel

3$:	jsr	fmt6rjint	; load channel
	inca			; next row
	leax	1,x		; next channel
	cmpx	#0d16
	bne	4$
	lda	#SCRNTP+6
	ldb	#$CHNL+0d40
4$:	cmpx	#0d32
	bne	3$

	rts


5$:	.byte	SCRNTP+4,	0d0
	.word	6$
	.byte	SCRNTP+5,	0d0
	.word	7$
	.byte	SCRNTP+4,	0d40
	.word	6$
	.byte	SCRNTP+5,	0d40
	.word	7$
n$shv = .
	.byte	SCRNTP+0,	0d43		; must be last
	.word	8$
	.byte	0,		0
	.word	0

	;	 0123456789012345678901234567890123456789"
6$:	.asciz	"   CHNL  HV-STS  VOLTAGE DEMAND HV-SET  "
7$:	.asciz	"   ----  ------  ------- ------ ------  "

8$:	.asciz	"HV4032A System Status     Unit # "


	$CHNL		=	0d0
	$HVSTS		=	0d9
	$VOLTAGE	=	0d17
	$DEMAND		=	0d24
	$HVSET		=	0d31


	;
	; shv$scrn Legends
	;

shv$lgnd::
	pshs	d,x,y
	leas	-3,s

	ldx	#6$

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
	puls	d,x,y
	rts


6$:	.word	r$shv1,	r$shv2,	r$shv3,	r$shv4,	0

	;	row		column		video		option
	;-------------------------------------------------------------
r$shv1:
	.byte	SCRNTP+0d0,	3,		REVERSE,	1
	.word	1$		; "Exit"
r$shv2	= .
	.byte	SCRNTP+0d1,	3,		REVERSE,	2
	.word	2$		; "Turn Power Off"
r$shv3	= .
	.byte	SCRNTP+0d2,	3,		REVERSE,	3
	.word	3$		; "Turn Power On"
r$shv4	= .
	.byte	SCRNTP+0d3,	3,		REVERSE,	4
	.word	4$		; "Read HV4032A"


1$:	.asciz	"  Exit Screen   "		; 1
2$:	.asciz	" Turn Power OFF "		; 2
3$:	.asciz	" Turn Power ON  "		; 3
4$:	.asciz	"  Read HV4032A  "		; 4


	;
	; shv$scrn Questions
	;

shv$ques::
	cmpa	#ENTER		; selecting ?
	bne	5$		; no - exit

	pshs	b,x,y

	lda	#SCRNBT		; common question position
	ldb	#0
	jsr	fmtindex

	leax	optarray,u	; get option
	ldb	*opt$posn
	ldb	b,x

	cmpb	#1		; exiting this screen ?
	bne	1$		; no - skip
	clr	*s$state	; yes

1$:	aslb
	cmpb	#7$-6$		; valid option ?
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


6$:	.word	7$,8$,9$,10$,11$

7$:	.asciz	"Invalid Option"
8$:	.asciz	"... Exiting this Screen ..."			; 1
9$:	.asciz	"Turn HV4032A High Voltage OFF (Y/N) ? "	; 2
10$:	.asciz	"Turn HV4032A High Voltage ON (Y/N) ? "		; 3
11$:	.asciz	"Read All HV4032A Voltages/Demands (Y/N) ? "	; 4

	;
	; shv$scrn Options
	;

shv$optn::
	jsr	scn$gets	; build a response string
	beq	3$		; not finished
	tst	*s$string	; NULL string ?
	ble	2$		; yes - terminate option

	jsr	option		; get the option number
	aslb
	cmpb	#5$-4$		; valid option ?
	bhis	2$		; no - terminate request

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
	.word	5$		; exit screen
	.word	7$		; turn voltage off
	.word	8$		; turn voltage on
	.word	11$		; read out HV4032A

	; Exit Screen

5$:	jsr	ans$yes
	bne	6$
	clr	*s$state	; just exit
6$:	rts

	; Turn Voltage Off

7$:	jsr	ans$yes
	bne	10$
	lda	#M16F
	bra	9$

	; Turn Voltage On

8$:	jsr	ans$yes
	bne	10$
	lda	#M16N

9$:	pshs	cc
	orcc	#0q120
	ldb	#0d32
	jsr	en$que
	lda	#M16WAIT
	jsr	en$que
	lda	#M16V
	jsr	en$que
	lda	#M16D
	jsr	en$que
	lda	#M16S
	jsr	en$que
	puls	cc
10$:	rts

	; Read Out HV4032A

11$:	jsr	ans$yes
	bne	12$
	pshs	cc
	orcc	#0q120
	ldb	#0d32
	lda	#M16V
	jsr	en$que
	lda	#M16D
	jsr	en$que
	puls	cc
12$:	rts


	; shv$scrn  Update Routine

	.area	SCRNUPDT

shv$updt::

	; fill in HV Updating status / failure mode

	ldx	#tmpvar
	lda	hvc$sts,x	; current status
	asla
	ldx	#hvc$optn	; table of pointers
	leax	[a,x]
	lda	#SCRNTP+0d22	; position
	clrb
	jsr	fmthtxt		; load current status

	; fill in high voltage supply status

	ldx	#tmpvar
	lda	hv$sts,x	; current status
	asla
	ldx	#16$		; table of pointers
	leax	[a,x]
	ldd	n$shv		; position
	adda	#0d2
	jsr	fmthtxt		; load current status

	; fill in high voltage status

1$:	ldy	#acqvar		; acquisition variables
	lda	#SCRNTP+0d6	; screen position
	ldb	#$HVSTS

2$:	pshs	d
	lda	hv$sts,y
	asla
	ldx	#10$
	leax	[a,x]
	ldd	,s
	jsr	fmthtxt
	puls	d

	leay	ACQVARSZ,y	; next channel
	inca			; next row
	cmpa	#SCRNTP+0d6+0d16
	bne	2$
	lda	#SCRNTP+0d6
	cmpb	#$HVSTS+0d40
	beq	3$
	ldb	#$HVSTS+0d40
	bra	2$

	; fill in high voltage

3$:	ldy	#acqvar		; acquisition variables
	lda	#SCRNTP+0d6	; screen position
	ldb	#$VOLTAGE

4$:	pshs	d
	ldx	hv$volt,y	; voltage
	ldd	,s
	jsr	fmt6rjint
	puls	d

	leay	ACQVARSZ,y	; next channel
	inca			; next row
	cmpa	#SCRNTP+0d6+0d16
	bne	4$
	lda	#SCRNTP+0d6
	cmpb	#$VOLTAGE+0d40
	beq	5$
	ldb	#$VOLTAGE+0d40
	bra	4$

	; fill in high voltage demand

5$:	ldy	#acqvar		; acquisition variables
	lda	#SCRNTP+0d6	; screen position
	ldb	#$DEMAND

6$:	pshs	d
	ldx	hv$dmnd,y	; voltage
	ldd	,s
	jsr	fmt6rjint
	puls	d

	leax	ACQBUFSZ,x	; next channel
	leay	ACQVARSZ,y
	inca			; next row
	cmpa	#SCRNTP+0d6+0d16
	bne	6$
	lda	#SCRNTP+0d6
	cmpb	#$DEMAND+0d40
	beq	7$
	ldb	#$DEMAND+0d40
	bra	6$

	; fill in high voltage set

7$:	ldy	#acqvar		; acquisition variables
	lda	#SCRNTP+0d6	; screen position
	ldb	#$HVSET

8$:	pshs	d
	ldx	hv$setv,y	; voltage
	ldd	,s
	jsr	fmt6rjint
	puls	d

	leax	ACQBUFSZ,x	; next channel
	leay	ACQVARSZ,y
	inca			; next row
	cmpa	#SCRNTP+0d6+0d16
	bne	8$
	lda	#SCRNTP+0d6
	cmpb	#$HVSET+0d40
	beq	9$
	ldb	#$HVSET+0d40
	bra	8$

9$:	rts


	; High-Voltage Channel Status Table

10$:	.word	15$		; 0	?
	.word	11$		; 1	off
	.word	12$		; 2	on
	.word	13$		; 3	zero
	.word	14$		; 4	fail

11$:	.asciz	"  Off "
12$:	.asciz	"   On "
13$:	.asciz	" Zero "
14$:	.asciz	" Fail "
15$:	.asciz	"    ? "

	; High-Voltage Supply Status Table

16$:	.word	17$		; 0	?
	.word	18$		; 1	off
	.word	19$		; 2	on
	.word	17$		; 3 	----
	.word	17$		; 4	----

17$:	.asciz	"                "
18$:	.asciz	"High-Voltage OFF"
19$:	.asciz	"High-Voltage ON "


	.page
	.sbttl	Channel Status Screen

	.area	SCREEN

chn$scrn::
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

5$:	ldd	r$chn3		; default option position
	jsr	init$opt
	std	*scrn$pos
	inc	*s$state	; next state

6$:	jsr	clr$scrn	; clear the screen
	jsr	chn$page	; draw the page

	tst	*o$state	; active options sequence ?
	beq	8$		; no - skip
	lda	#ENTER		; redo question
	jsr	chn$ques
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

9$:	jsr	chn$lgnd	; load up legends
	ldd	*scrn$pos	; reload cursor position
	jsr	pos$scrn
	inc	*s$state	; next state

10$:	tst	*o$state	; processing an option ?
	beq	11$		; no  - skip

	lda	*char		; get the character
	jsr	chn$optn	; yes - service the option
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
	jsr	chn$ques	; try selecting an option
	sta	*char

12$:	puls	d,x,y
	rts


	; chn$scrn  Page Outline

chn$page::
	ldy	#3$
1$:	ldd	,y++
	ldx	,y++
	beq	2$
	jsr	fmthtxt
	bra	1$

2$:	rts


3$:	.byte	SCRNTP+0d0,	0d35
	.word	4$
	.byte	SCRNTP+0d4,	0d35
	.word	6$
	.byte	SCRNTP+0d10,	0d35
	.word	7$

chn$ntry = .

	.byte	SCRNTP+0d2,	0d35
	.word	5$
	.byte	SCRNTP+0d6,	0d35
	.word	8$
	.byte	SCRNTP+0d7,	0d35
	.word	9$
	.byte	SCRNTP+0d8,	0d35
	.word	10$
	.byte	SCRNTP+0d12,	0d35
	.word	8$
	.byte	SCRNTP+0d13,	0d35
	.word	9$
	.byte	SCRNTP+0d14,	0d35
	.word	10$
	.byte	SCRNTP+0d17,	0d35
	.word	11$
	.byte	SCRNTP+0d19,	0d35
	.word	12$
	.byte	SCRNTP+0d20,	0d35
	.word	13$
	.word	0,0


	STS$POS	=	0d19		; offset position for update

		;012345678901234567890123456789
4$:	.asciz	"          Channel Status"

5$:	.asciz	"      PHS Status ="

6$:	.asciz	"         Calibration Data"
7$:	.asciz	"          Updating Data"

8$:	.asciz	"Pulse Height ADC ="
9$:	.asciz	" Temperature ADC ="
10$:	.asciz	"   LED Drive DAC ="

11$:	.asciz	"       HV Status ="

12$:	.asciz	"         Voltage ="
13$:	.asciz	"          HV-Set ="


	;
	; chn$scrn Legends
	;

chn$lgnd::
	pshs	d,x

	lda	*scrn$sts+1	; channel number
	cmpa	#0d31		; valid LED channel ?
	blos	1$		; yes - skip
	cmpa	#0d32		; valid channel ?
	bhi	2$		; no - exit
	clra			; set to channel 0		
	sta	*scrn$sts+1
1$:	asla

	; Conditional Acquisition Legends

	ldx	#acqvtbl
	leax	[a,x]		; this channels variables
	lda	acq$sts,x	; get acquisition status
	anda	#0x0F
	asla
	ldx	#4$
	leax	[a,x]		; get legend list
	jsr	scn$lgnd	; do legends

	; UnCondition Legends

	ldx	#3$
	jsr	scn$lgnd	; do legends
	jsr	scn$chnl	; and channel

2$:	puls	d,x
	rts

	; Channel Control

3$:	.word	n$chn10,r$chn11,r$chn12,r$chn13
	.word	n$chn1c,r$chn3,	n$chn4,	r$chn2,	0

	; PHS Control

	; Acquisition Status Table

				; 0bxxxxxxxx
				;	|||`---- $SCAN
				;	||`----- $FAILED
				;	|`------ $HOLD
				;	`------- $ACTIVE
4$:	.word	5$		;       0000	inactive
	.word	6$		;	0001	cal
	.word	7$		;	0010	failed
	.word	7$		;	0011	failed
	.word	8$		;	0100	hold
	.word	8$		;	0101	hold
	.word	7$		;	0110	failed
	.word	7$		;	0111	failed
	.word	9$		;	1000	active
	.word	9$		;	1001	active
	.word	7$		;	1010	failed
	.word	7$		;	1011	failed
	.word	8$		;	1100	hold
	.word	8$		;	1101	hold
	.word	7$		;	1110	failed
	.word	7$		;	1111	failed


5$:	.word	n$chn5,	n$chn6, r$chn7,	r$chn8,	r$chn9,	0	; inactive
6$:	.word	n$chn5,	n$chn6,	n$chn7,	n$chn8,	n$chn9,	0	; cal
7$:	.word	n$chn5,	n$chn6,	r$chn7,	r$chn8,	r$chn9,	0	; failed
8$:	.word	r$chn5,	n$chn6,	r$chn7,	r$chn8,	r$chn9,	0	; hold
9$:	.word	n$chn5,	r$chn6,	r$chn7,	r$chn8,	r$chn9,	0	; active


	;	row		column		video		option
	;-------------------------------------------------------------
n$chn1c:
	.byte	SCRNTP+0d0,	1,		NORMAL,		0
	.word	1$		; "Channel Control"
r$chn2	= .
	.byte	SCRNTP+0d2,	3,		REVERSE,	1
	.word	2$		; "Channel #"
r$chn3	= .
	.byte	SCRNTP+0d4,	3,		REVERSE,	2
	.word	3$		; "Exit"
n$chn4	= .
	.byte	SCRNTP+0d7,	3,		NORMAL,		0
	.word	4$		; "PHS Control"
n$chn5	= .
	.byte	SCRNTP+0d9,	3,		NORMAL,		0
	.word	5$		; "Active"
r$chn5	= .
	.byte	SCRNTP+0d9,	3,		REVERSE,	3
	.word	5$		; "Active"
n$chn6	= .
	.byte	SCRNTP+0d10,	3,		NORMAL,		0
	.word	6$		; "Hold"
r$chn6	= .
	.byte	SCRNTP+0d10,	3,		REVERSE,	4
	.word	6$		; "Hold"
n$chn7	= .
	.byte	SCRNTP+0d11,	3,		NORMAL,		0
	.word	7$		; "Cal"
r$chn7	= .
	.byte	SCRNTP+0d11,	3,		REVERSE,	5
	.word	7$		; "Cal"
n$chn8	= .
	.byte	SCRNTP+0d12,	3,		NORMAL,		0
	.word	8$		; "Set"
r$chn8	= .
	.byte	SCRNTP+0d12,	3,		REVERSE,	6
	.word	8$		; "Set"
n$chn9	= .
	.byte	SCRNTP+0d13,	3,		NORMAL,		0
	.word	9$		; "Clear"
r$chn9	= .
	.byte	SCRNTP+0d13,	3,		REVERSE,	7
	.word	9$		; "Clear"
n$chn10	= .
	.byte	SCRNTP+0d16,	3,		NORMAL,		0
	.word	10$		; "HV Control"
r$chn11	= .
	.byte	SCRNTP+0d18,	3,		REVERSE,	8
	.word	11$		; "Zero"
r$chn12	= .
	.byte	SCRNTP+0d19,	3,		REVERSE,	9
	.word	12$		; "Restore"
r$chn13	= .
	.byte	SCRNTP+0d20,	3,		REVERSE,	10
	.word	13$		; "HV-Set"

1$:	.asciz	"Channel Control"
2$:	.asciz	"Channel #  "		; 1
3$:	.asciz	"Exit Screen"		; 2
4$:	.asciz	"PHS Control"
5$:	.asciz	"  Active   "		; 3
6$:	.asciz	"   Hold    "		; 4
7$:	.asciz	"   Cal     "		; 5
8$:	.asciz	"   Set     "		; 6
9$:	.asciz	"   Clear   "		; 7
10$:	.asciz	"HV  Control"
11$:	.asciz	"   Zero    "		; 8
12$:	.asciz	"  Restore  "		; 9
13$:	.asciz	"  HV-Set   "		; 10

	;
	; chn$scrn Questions
	;

chn$ques::
	cmpa	#ENTER		; selecting ?
	bne	5$		; no - exit

	pshs	b,x,y

	lda	#SCRNBT		; common question position
	ldb	#0
	jsr	fmtindex

	leax	optarray,u	; get option
	ldb	*opt$posn
	ldb	b,x

	cmpb	#2		; exiting this screen
	bne	1$		; no - skip
	clr	*s$state	; yes

1$:	aslb
	cmpb	#7$-6$		; valid option ?
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


6$:	.word	7$,8$,9$,10$,11$,12$,13$,14$,15$,16$,17$

7$:	.asciz	"Invalid Option"
8$:	.asciz	"Select New Channel -> "				; 1
9$:	.asciz	"... Exiting this Screen ..."				; 2
10$:	.asciz	"Activate Channel (Y,N) ? -> "				; 3
11$:	.asciz	"Place Channel on Hold (Y,N) ? -> "			; 4
12$:	.asciz	"Calibrate Channel (Y,N) ? -> "				; 5
13$:	.asciz	"Enter Set Value for LED DAC (0-4095) -> "		; 6
14$:	.asciz	"Clear Channel (Y,N) ? -> "				; 7
15$:	.asciz	"Zero High-Voltage (Y,N) ? -> "				; 8
16$:	.asciz	"Restore High-Voltage (Y,N) ? -> "			; 9
17$:	.asciz	"Set High-Voltage (100-3000) -> "			; 10

	;
	; chn$scrn Options
	;

chn$optn::
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

	tst	*s$state	; new screen
	beq	3$		; no - skip
	lda	#2		; redraw legends always
	sta	*s$state	

3$:	clra			; input character always used
	rts

4$:	.word	1$		; invalid option
	.word	5$		; new channel
	.word	7$		; exit screen
	.word	9$		; activate
	.word	11$		; hold
	.word	13$		; cal
	.word	16$		; set
	.word	18$		; clear
	.word	20$		; zero
	.word	23$		; restore
	.word	26$		; set hv

	; New Channel Number

5$:	jsr	a$d$i		; convert to an integer
	cmpb	#0d31		; valid ?
	bhi	6$		; no - skip
	stb	*scrn$sts+1	; save new channel #
6$:	rts

	; Exit Screen

7$:	jsr	ans$yes
	bne	8$
	clr	*s$state	; just exit
8$:	rts

	; Activate

9$:	jsr	ans$yes
	bne	10$
	lda	*scrn$sts+1	; channel number
	ldb	acq$sts,y
	andb	#~$HOLD		; clear the hold status
	jsr	chng$sts	; change the status
	jsr	wait$sts	; wait for change
10$:	rts

	; Hold

11$:	jsr	ans$yes
	bne	12$
	lda	*scrn$sts+1	; channel number
	ldb	acq$sts,y
	orb	#$HOLD		; set the hold status
	jsr	chng$sts	; change the status
	jsr	wait$sts	; wait for change
12$:	rts

	; Calibrate

13$:	jsr	ans$yes
	bne	14$

	lda	#SCRNBT
	ldb	#0
	jsr	fmtdeol		; clear option question and answer
	ldx	#15$
	jsr	fmthtxt		; note calibration

	lda	*scrn$sts+1	; channel number
	jsr	phs$cal		; calibrate
14$:	rts

15$:	.asciz	"... Calibrating Channel ..."

	; Set

16$:	jsr	a$d$i		; convert to an integer
	cmpd	#0d4095		; valid ?
	bhi	17$		; no - skip
	tfr	d,x		; set value
	lda	*scrn$sts+1	; channel number
	jsr	phs$set		; set calibration
17$:	rts

	; Clear

18$:	jsr	ans$yes
	bne	19$
	lda	*scrn$sts+1	; channel number
	ldb	acq$sts,y
	andb	#~0x0F		; clear all acquisition flags
	jsr	chng$sts	; change the status
	jsr	wait$sts	; wait for change
19$:	rts

	; Zero

20$:	jsr	ans$yes
	bne	22$
	lda	*scrn$sts+1	; channel number
	ldb	acq$sts,y
	beq	21$
	orb	#$HOLD		; set the hold status
	jsr	chng$sts	; change the status
	jsr	wait$sts	; wait for change
21$:	pshs	cc
	orcc	#0q120
	ldb	*scrn$sts+1	; channel number
	lda	#M16CxxZ	; function
	jsr	en$que
	lda	#M16WAIT	; function
	jsr	en$que
	lda	#M16CxxG	; function
	jsr	en$que
	puls	cc
22$:	rts

	; Restore

23$:	jsr	ans$yes
	bne	25$
	lda	*scrn$sts+1	; channel number
	ldb	acq$sts,y
	beq	24$
	orb	#$HOLD		; set the hold status
	jsr	chng$sts	; change the status
	jsr	wait$sts	; wait for change
24$:	pshs	cc
	orcc	#0q120
	ldb	*scrn$sts+1	; channel number
	lda	#M16CxxR	; function
	jsr	en$que
	lda	#M16WAIT	; function
	jsr	en$que
	lda	#M16CxxG	; function
	jsr	en$que
	puls	cc
25$:	rts

	; HV-Set

26$:	jsr	a$d$i		; convert to an integer
	cmpd	#0d3000		; maximum voltage allowed
	bhi	28$
	std	hv$setv,y
	lda	*scrn$sts+1	; channel number
	ldb	acq$sts,y
	beq	27$
	orb	#$HOLD		; set the hold status
	jsr	chng$sts	; change the status
	jsr	wait$sts	; wait for change
27$:	pshs	cc
	orcc	#0q120
	ldb	*scrn$sts+1	; channel number
	lda	#M16CxxS	; function
	jsr	en$que
	lda	#M16WAIT	; function
	jsr	en$que
	lda	#M16CxxG	; function
	jsr	en$que
	puls	cc
28$:	rts


	; chn$scrn  Update Routine
	;
	; The ordering of the updates is determined by
	; the list chn$ntry

	.area	SCRNUPDT

chn$updt::
	lda	*scrn$sts+1	; get channel #
	cmpa	#0d31
	lbhi	16$
	asla
	ldy	#acqvtbl	; acquisition variable table
	leay	[a,y]		; this channels variables

	; fill in HV Updating status / failure mode

	lda	hvc$sts,y	; current status
	asla
	ldx	#hvc$optn	; table of pointers
	leax	[a,x]
	lda	#SCRNTP+0d22	; position
	clrb
	jsr	fmthtxt		; load current status

	; Acquisition Status

	ldx	#chn$ntry	; sequence of entries

	ldd	,x		; get entry
	addb	#STS$POS	; position
	leax	4,x
	pshs	d,x

	lda	acq$sts,y
	anda	#0x0F		; just acq status
	asla
	ldx	#17$
	leax	[a,x]
	puls	d
	jsr	fmthtxt
	puls	x

	; Pulse Height ADC Calibration Data

	ldd	,x		; get entry
	addb	#STS$POS	; position
	leax	4,x
	pshs	d,x

	lda	acq$sts,y
	anda	#0x0F
	beq	2$

	ldx	phs$lpht,y	; calibration ready ?
	bne	1$		; yes - use it
				; else use updating value

	; divide acq$sum by 64

	ldd	acq$sum,y	; get sum
	rolb			; divide by 64
	rola
	rolb
	rola
	rolb
	exg	a,b
	anda	#0x03
	tfr	d,x

1$:	ldd	,s
	pshs	x
	ldx	#28$
	jsr	fmthtxt		; clear old status
	puls	x
	puls	d
	jsr	fmt6rjint
	bra	3$

2$:	ldx	#28$		; inactive
	puls	d
	jsr	fmthtxt
3$:	puls	x

	; Temperature ADC Calibration Data

	ldd	,x		; get entry
	addb	#STS$POS	; position
	leax	4,x
	pshs	d,x

	lda	acq$sts,y
	anda	#0x0F
	beq	4$

	lda	tmp$flag,y
	beq	4$

	ldd	,s
	ldx	#28$
	jsr	fmthtxt		; clear old status
	ldx	tmp$lpht,y	; temperature
	puls	d
	jsr	fmt6rjint
	bra	5$

4$:	ldx	#28$		; inactive
	puls	d
	jsr	fmthtxt
5$:	puls	x

	; LED Drive ADC Data

	ldd	,x		; get entry
	addb	#STS$POS	; position
	leax	4,x
	pshs	d,x

	lda	acq$sts,y
	anda	#0x0F
	beq	6$

	ldd	,s
	ldx	#28$
	jsr	fmthtxt		; clear old status
	ldx	cal$lpht,y	; LED Drive
	puls	d
	jsr	fmt6rjint
	bra	7$

6$:	ldx	#28$		; inactive
	puls	d
	jsr	fmthtxt
7$:	puls	x

	; Updating Pulse Height ADC Data

	ldd	,x		; get entry
	addb	#STS$POS	; position
	leax	4,x
	pshs	d,x

	lda	acq$sts,y
	anda	#0x0F
	beq	8$

	ldd	,s
	ldx	#28$
	jsr	fmthtxt		; clear old status
	puls	d
	ldx	phs$avrg,y	; get average of last scan
	jsr	fmt6rjint
	bra	9$

8$:	ldx	#28$		; inactive
	puls	d
	jsr	fmthtxt
9$:	puls	x

	; Updating Temperature ADC Data

	ldd	,x		; get entry
	addb	#STS$POS	; position
	leax	4,x
	pshs	d,x,y

	lda	acq$sts,y
	anda	#0x0F
	beq	10$

	lda	tmp$flag,y
	beq	10$

	ldy	#tmpvar

	lda	tmp$flag,y
	beq	10$

	ldd	,s
	ldx	#28$
	jsr	fmthtxt		; clear old status

	puls	d
	ldx	phs$avrg,y	; get last scan
	jsr	fmt6rjint
	bra	11$

10$:	ldx	#28$		; inactive
	puls	d
	jsr	fmthtxt
11$:	puls	x,y

	; Updating LED Drive ADC Data

	ldd	,x		; get entry
	addb	#STS$POS	; position
	leax	4,x
	pshs	d,x

	lda	acq$sts,y
	anda	#0x0F
	beq	12$

	ldd	,s
	ldx	#28$
	jsr	fmthtxt		; clear old status
	ldx	cor$lpht,y	; LED Drive
	puls	d
	jsr	fmt6rjint
	bra	13$

12$:	ldx	#28$		; inactive
	puls	d
	jsr	fmthtxt
13$:	puls	x

	; fill in high voltage status

	ldd	,x		; get entry
	addb	#STS$POS	; position
	leax	4,x
	pshs	d,x

	lda	hv$sts,y
	asla
	ldx	#18$
	leax	[a,x]
	puls	d
	jsr	fmthtxt
	puls	x

	; fill in high voltage read from HV4032A

	ldd	,x		; get entry
	addb	#STS$POS	; position
	leax	4,x
	pshs	d,x

	lda	hv$sts,y
	beq	14$		; ?

	ldd	,s
	ldx	#28$
	jsr	fmthtxt		; clear old status
	ldx	hv$volt,y	; voltage
	puls	d
	jsr	fmt6rjint
	bra	15$

14$:	ldx	#27$		; ?
	puls	d
	jsr	fmthtxt
15$:	puls	x

	; fill in last high voltage set point

	ldd	,x		; get entry
	addb	#STS$POS	; position
	leax	4,x
	pshs	x

	ldx	hv$setv,y	; voltage
	jsr	fmt6rjint
	puls	x

16$:	rts


	; Acquisition Status Table

				; 0bxxxxxxxx
				;	|||`---- $SCAN
				;	||`----- $FAILED
				;	|`------ $HOLD
				;	`------- $ACTIVE
17$:	.word	19$		;       0000	inactive
	.word	20$		;	0001	cal
	.word	21$		;	0010	failed
	.word	21$		;	0011	failed
	.word	22$		;	0100	hold
	.word	22$		;	0101	hold
	.word	21$		;	0110	failed
	.word	21$		;	0111	failed
	.word	23$		;	1000	active
	.word	23$		;	1001	active
	.word	21$		;	1010	failed
	.word	21$		;	1011	failed
	.word	22$		;	1100	hold
	.word	22$		;	1101	hold
	.word	21$		;	1110	failed
	.word	21$		;	1111	failed


	; High-Voltage Status Table

18$:	.word	27$		; 0	?
	.word	24$		; 1	off
	.word	25$		; 2	on
	.word	26$		; 3	zero
	.word	21$		; 4	fail


19$:	.asciz	"Inactive"	; inactive
20$:	.asciz	"   Cal  "
21$:	.asciz	"  Fail  "
22$:	.asciz	"  Hold  "
23$:	.asciz	"Active  "
24$:	.asciz	"   Off  "
25$:	.asciz	"    On  "
26$:	.asciz	"  Zero  "
27$:	.asciz	"     ?  "
28$:	.asciz	"        "


	.page
	.sbttl	High Voltage Update Screen

	.area	SCREEN

hvu$scrn::
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

5$:	ldd	r$hvu2		; default option position
	jsr	init$opt
	std	*scrn$pos
	inc	*s$state	; next state

6$:	jsr	clr$scrn	; clear the screen
	jsr	hvu$page	; draw the page

	tst	*o$state	; active options sequence ?
	beq	8$		; no - skip
	lda	#ENTER		; redo question
	jsr	hvu$ques
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

9$:	jsr	hvu$lgnd	; load up legends
	ldd	*scrn$pos	; reload cursor position
	jsr	pos$scrn
	inc	*s$state	; next state

10$:	tst	*o$state	; processing an option ?
	beq	11$		; no  - skip

	lda	*char		; get the character
	jsr	hvu$optn	; yes - service the option
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
	jsr	hvu$ques	; try selecting an option
	sta	*char

12$:	puls	d,x,y
	rts


	; hvu$scrn  Page Outline

hvu$page::
	ldy	#3$
1$:	ldd	,y++
	ldx	,y++
	beq	2$
	jsr	fmthtxt
	bra	1$

2$:	rts


3$:	.byte	SCRNTP+4,	0
	.word	4$
	.byte	SCRNTP+5,	0
	.word	5$
	.byte	SCRNTP+4,	20
	.word	4$
	.byte	SCRNTP+5,	20
	.word	5$
	.byte	SCRNTP+4,	40
	.word	4$
	.byte	SCRNTP+5,	40
	.word	5$
	.byte	SCRNTP+4,	60
	.word	4$
	.byte	SCRNTP+5,	60
	.word	5$
	.word	0,0

	;	 0123456789012345678901234567890123456789"
4$:	.asciz	"   VLTG  DAY/TIME   "
5$:	.asciz	"   ----  --------   "

	$VLTG		=	0d1
	$DAYTIME	=	0d9


	;
	; hvu$scrn Legends
	;

hvu$lgnd::
	pshs	d,x

	lda	*scrn$sts+1	; channel number
	cmpa	#0d31		; valid LED channel ?
	blos	1$		; yes - skip
	cmpa	#0d32		; valid channel ?
	bhi	2$		; no - exit
	clra			; set to channel 0		
	sta	*scrn$sts+1
1$:	ldx	#3$
	jsr	scn$lgnd	; do legends
	jsr	scn$chnl	; and channel

2$:	puls	d,x
	rts


3$:	.word	n$hvu4,	n$hvu3,	r$hvu2,	r$hvu1,	0

	;	row		column		video		option
	;-------------------------------------------------------------
r$hvu1:
	.byte	SCRNTP+0d0,	3,		REVERSE,	1
	.word	1$		; "Channel #"
r$hvu2	= .
	.byte	SCRNTP+0d2,	3,		REVERSE,	2
	.word	2$		; "Exit"
n$hvu3	= .
	.byte	SCRNTP+0d0,	0d31,		NORMAL,		0
	.word	3$		; "High Voltage Updates"
n$hvu4	= .
	.byte	SCRNTP+0d2,	0d31,		NORMAL,		0
	.word	4$		; " Current DAY/TIME ="

1$:	.asciz	"Channel #  "		; 1
2$:	.asciz	"Exit Screen"		; 2
3$:	.asciz	"High Voltage Updates"
4$:	.asciz	"Current DAY/TIME = "

	$CDAYTIM  =  0d19		; offset


	;
	; hvu$scrn Questions
	;

hvu$ques::
	cmpa	#ENTER		; selecting ?
	bne	5$		; no - exit

	pshs	b,x,y

	lda	#SCRNBT		; common question position
	ldb	#0
	jsr	fmtindex

	leax	optarray,u	; get option
	ldb	*opt$posn
	ldb	b,x

	cmpb	#2		; exiting this screen ?
	bne	1$		; no - skip
	clr	*s$state	; yes

1$:	aslb
	cmpb	#7$-6$		; valid option ?
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


6$:	.word	7$,8$,9$

7$:	.asciz	"Invalid Option"
8$:	.asciz	"Select New Channel -> "			; 1
9$:	.asciz	"... Exiting this Screen ..."			; 2


	;
	; hvu$scrn Options
	;

hvu$optn::
	jsr	scn$gets	; build a response string
	beq	3$		; not finished
	tst	*s$string	; NULL string ?
	ble	2$		; yes - terminate option

	jsr	option		; get the option number
	aslb
	cmpb	#5$-4$		; valid option ?
	bhis	2$		; no - terminate request

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
	.word	5$		; channel #
	.word	7$		; exit screen

	; New Channel Number

5$:	jsr	a$d$i		; convert to an integer
	cmpb	#0d31		; valid ?
	bhi	6$		; no - skip
	stb	*scrn$sts+1	; save new channel #
	lda	#2		; redraw legends
	sta	*s$state	
6$:	rts

	; Exit Screen

7$:	jsr	ans$yes
	bne	8$
	clr	*s$state	; just exit
8$:	rts


	; hvu$scrn  Update Routine

	.area	SCRNUPDT

hvu$updt::
	pshs	d,x,y

	lda	*scrn$sts+1	; channel #
	cmpa	#0d31		; only LED channels allowed
	lbhi	5$
	asla
	ldx	#acqbtbl	; acquisition buffers
	leax	[a,x]
	ldy	#acqvtbl	; acquisition variables
	leay	[a,y]

	; show current DAY/TIME

	lda	days		; compute time
	ldb	#0d5		; 1440. * days
	mul			; days <= 44.
	exg	a,b
	std	,--s
	lda	days
	ldb	#0d160
	mul
	addd	,s
	std	,s
	lda	hours
	ldb	#0d60		; 60. * hours
	mul
	addd	,s++
	addb	minutes
	adca	#0

	pshs	x
	leas	-0d10,s		; buffer
	tfr	s,x
	jsr	i$tw$dt

	ldd	n$hvu4		; get position
	addb	#$CDAYTIM
	tfr	s,x
	jsr	fmthtxt
	leas	0d10,s
	puls	x

	; list all updates

	lda	hv$index,y	; next update index
	deca
	bpl	1$	
	lda	#0d63
1$:	sta	run$index,y	; last voltage update

	lda	#SCRNTP+0d6	; screen position
	ldb	#0

2$:	pshs	d,x

	addb	#$VLTG
	ldx	acq$vltg,x	; voltage
	jsr	fmt6rjint

	ldx	2,s

	ldd	acq$time,x
	leas	-0d10,s		; buffer
	tfr	s,x
	jsr	i$tw$dt

	tst	run$index,y
	bne	4$

	tfr	s,x
3$:	lda	,x
	ble	4$
	ora	#REVERSE	; REVERSE Video
	sta	,x+
	bra	3$

4$:	ldd	0d10,s		; get position
	addb	#$DAYTIME
	tfr	s,x
	jsr	fmthtxt
	leas	0d10,s

	puls	d,x

	leax	2,x		; next element
	dec	run$index,y
	inca			; next row
	cmpa	#SCRNTP+0d6+0d16
	bne	2$
	lda	#SCRNTP+0d6
	addb	#0d20		; next column
	cmpb	#0d80
	bne	2$

5$:	puls	d,x,y
	rts


	.sbttl	Time Word to Date and Time Conversion

	; Integer is converted to 00/00:00 format
	;			  DA/HR:MN

i$tw$dt::
	pshs	d,y
	std	*i$data		; save date
	ldb	#8-1		; 8 characters for conversion
	stb	*i$ndgt
	ldy	#6$

1$:	ldd	*i$data		; get data
	clr	*i$dcnt		; initialize counter

2$:	cmpd	,y++		; trial
	blo	3$		; ok - skip
	subd	,--y
	inc	*i$dcnt		; one more count
	bra	2$

3$:	std	*i$data
	tst	-2,y		; special option in table ?
	bpl	4$		; no - skip
	ldb	-1,y		; get character
	bra	5$

4$:	ldb	*i$dcnt		; convert count to ascii character
	addb	#'0
5$:	stb	,x+		; place character
	dec	*i$ndgt		; any more ?
	bgt	1$		; yes - loop
	ldb	*i$data+1	; last digit
	addb	#'0
	stb	,x+
	ldb	#0q200
	stb	,x		; terminator

	puls	d,y
	rts

	; conversion table

6$:	.word	0d14400		; 10 days
	.word	0d1440		;  1 day
	.word	0xFF00 + '/	;  /
	.word	0d600		; 10 hours
	.word	0d60		;  1 hour
	.word	0xFF00 + ':	;  :
	.word	0d10		; 10 minutes


	.page
	.sbttl	Stabilization Parameters Screen

	.area	SCREEN

prm$scrn::
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

5$:	ldd	r$prm3		; default option position
	jsr	init$opt
	std	*scrn$pos
	inc	*s$state	; next state

6$:	jsr	clr$scrn	; clear the screen
	jsr	prm$page	; draw the page

	tst	*o$state	; active options sequence ?
	beq	8$		; no - skip
	lda	#ENTER		; redo question
	jsr	prm$ques
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

9$:	jsr	prm$lgnd	; load up legends
	ldd	*scrn$pos	; reload cursor position
	jsr	pos$scrn
	inc	*s$state	; next state

10$:	tst	*o$state	; processing an option ?
	beq	11$		; no  - skip

	lda	*char		; get the character
	jsr	prm$optn	; yes - service the option
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
	jsr	prm$ques	; try selecting an option
	sta	*char

12$:	puls	d,x,y
	rts


	; prm$scrn  Page Outline

prm$page::
	pshs	d,x,y

	ldx	#3$
	lda	#SCRNTP+0d6-0d1	; top of screen
	ldb	#0d8

1$:	inca
	pshs	d
	jsr	fmthtxt
	puls	d
2$:	tst	,x+		; skip to end of line
	bgt	2$
	tst	,x		; end of text ?
	bpl	1$

	puls	d,x,y
	rts

3$:	.asciz	"  Three parameters are required by the P.H.S. system to"
	.asciz	"perform the stabilization function:"
.asciz	""
.asciz	"  (1)  A value specifying the change in high-voltage required"
.asciz	"       to produce a 10% change in the detector response"
.asciz	"       (the default is 25 volts / 10%)."
.asciz	""
.asciz	"  (2)  A value specifying the minimum voltage change required before"
.asciz	"       an update will be performed (the default is 5 volts)."
.asciz	""
.asciz	"  (3)  A value specifying the single step voltage change"
.asciz	"       indicating a channel failure (the default is 64 volts)."
.byte	0q200

	;
	; prm$scrn Legends
	;

prm$lgnd::
	pshs	d,x

	ldx	#1$
	jsr	scn$lgnd	; do legends
	jsr	scn$chnl	; and channel

	puls	d,x
	rts

	; Parameter Setup

1$:	.word	n$prm1,	r$prm3,	r$prm4,	r$prm5,	r$prm6,	r$prm2,	0


	;	row		column		video		option
	;-------------------------------------------------------------
n$prm1:
	.byte	SCRNTP+0d0,	1,		NORMAL,		0
	.word	1$		; "Stabilization Parameters"
r$prm2	= .
	.byte	SCRNTP+0d2,	3,		REVERSE,	1
	.word	2$		; "Channel #"
r$prm3	= .
	.byte	SCRNTP+0d4,	3,		REVERSE,	2
	.word	3$		; "Exit"
r$prm4	= .
	.byte	SCRNTP+0d19,	3,		REVERSE,	3
	.word	4$		; "10% of Response Voltage Change"
r$prm5	= .
	.byte	SCRNTP+0d20,	3,		REVERSE,	4
	.word	5$		; "Update Change Threshold Voltage"
r$prm6	= .
	.byte	SCRNTP+0d21,	3,		REVERSE,	5
	.word	6$		; "Maximum Single Step Voltage Change"

	;     0123456789012345678901234567890123456789012345
1$:	.asciz	"Stabilization Parameter Setup"
2$:	.asciz	"Channel #  "				; 1
3$:	.asciz	"Exit Screen"				; 2
4$:	.asciz	"    10% Response Voltage Change     "	; 3
5$:	.asciz	"  Update Change Threshold Voltage   "	; 4
6$:	.asciz	" Maximum Single Step Voltage Change "	; 5

	$PRMPOS  =  0d40

	;
	; prm$scrn Questions
	;

prm$ques::
	cmpa	#ENTER		; selecting ?
	bne	5$		; no - exit

	pshs	b,x,y

	lda	#SCRNBT		; common question position
	ldb	#0
	jsr	fmtindex

	leax	optarray,u	; get option
	ldb	*opt$posn
	ldb	b,x

	cmpb	#2		; exiting this screen
	bne	1$		; no - skip
	clr	*s$state	; yes

1$:	aslb
	cmpb	#7$-6$		; valid option ?
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


6$:	.word	7$,8$,9$,10$,11$,12$

7$:	.asciz	"Invalid Option"
8$:	.asciz	"Select New Channel -> "				; 1
9$:	.asciz	"... Exiting this Screen ..."				; 2
10$:	.asciz	"Enter the 10% Response in Volts (0-50) -> "		; 3
11$:	.asciz	"Enter Update Threshold Change Voltage (0-255) -> "	; 4
12$:	.asciz	"Enter Maximum Single Step Change in Volts (0-255) -> "	; 5

	;
	; prm$scrn Options
	;

prm$optn::
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

	tst	*s$state	; new screen
	beq	3$		; no - skip
	lda	#2		; redraw legends always
	sta	*s$state	

3$:	clra			; input character always used
	rts

4$:	.word	1$		; invalid option
	.word	5$		; new channel
	.word	7$		; exit screen
	.word	9$		; correction
	.word	11$		; threshold
	.word	13$		; single step limit

	; New Channel Number

5$:	jsr	a$d$i		; convert to an integer
	cmpb	#0d31		; valid ?
	bhi	6$		; no - skip
	stb	*scrn$sts+1	; save new channel #
6$:	rts

	; Exit Screen

7$:	jsr	ans$yes
	bne	8$
	clr	*s$state	; just exit
8$:	rts

	; Correction Size

9$:	jsr	a$d$i		; convert to an integer
	cmpd	#0d50		; valid ?
	bhi	6$		; no - skip
	tfr	d,x		; save
	lda	#<(0d65535/0d50)
	mul
	std	,--s
	tfr	x,d
	lda	#>(0d65535/0d50)
	mul
	exg	a,b
	addd	,s++
	sta	dlta$vlt,y
10$:	rts

	; Threshold

11$:	jsr	a$d$i		; convert to an integer
	cmpd	#0d255		; valid ?
	bhi	6$		; no - skip
	stb	dlta$min,y
12$:	rts

	; Single Step Limit

13$:	jsr	a$d$i		; convert to an integer
	cmpd	#0d255		; valid ?
	bhi	6$		; no - skip
	stb	dlta$err,y
14$:	rts


	; prm$scrn  Update Routine

	.area	SCRNUPDT

prm$updt::
	pshs	d,x,y

	lda	*scrn$sts+1	; get channel #
	cmpa	#0d31
	bhi	1$
	asla
	ldy	#acqvtbl	; acquisition variable table
	leay	[a,y]		; this channels variables

	; fill in 10% response

	lda	#0d50		; 50 * fraction
	ldb	dlta$vlt,y
	mul
	addd	#0d128		; carry
	tfr	a,b
	clra
	std	,--s
	ldd	r$prm4
	ldb	#$PRMPOS
	ldx	#2$
	jsr	fmthtxt		; load ' = '
	ldx	,s++
	jsr	fmt4rjint

	; fill in minimum change

	clra
	ldb	dlta$min,y
	std	,--s
	ldd	r$prm5
	ldb	#$PRMPOS
	ldx	#2$
	jsr	fmthtxt		; load ' = '
	ldx	,s++
	jsr	fmt4rjint

	; fill in single step maximum

	clra
	ldb	dlta$err,y
	std	,--s
	ldd	r$prm6
	ldb	#$PRMPOS
	ldx	#2$
	jsr	fmthtxt		; load ' = '
	ldx	,s++
	jsr	fmt4rjint

1$:	puls	d,x,y
	rts


2$:	.asciz	" = "

