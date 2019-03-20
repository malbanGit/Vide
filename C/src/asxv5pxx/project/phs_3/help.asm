	.page
	.sbttl	Help Screens

	.module	help

	.include	/area.def/
	.include	/define.def/

	.area	SCREEN


hlp$scrn::
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

4$:	.word	5$,6$,8$,10$

5$:	ldd	r$hlp1		; default option position
	jsr	init$opt
	std	*scrn$pos
	inc	*s$state	; next state

6$:	jsr	clr$scrn	; clear the screen

	tst	*o$state	; active options sequence ?
	beq	7$		; no - skip
	lda	#ENTER		; redo question
	jsr	hlp$ques
7$:	inc	*s$state	; next state

8$:	tst	*o$state	; processing an option ?
	bne	9$		; yes - skip
	jsr	hlp$lgnd	; load up legends
	ldd	*scrn$pos	; reload cursor position
	jsr	pos$scrn
9$:	inc	*s$state	; next state

10$:	tst	*o$state	; processing an option ?
	beq	11$		; no  - skip

	lda	*char		; get the character
	jsr	hlp$optn	; yes - service the option
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
	jsr	hlp$ques	; try selecting an option
	sta	*char

12$:	puls	d,x,y
	rts


	;
	; hlp$scrn Legends
	;

hlp$lgnd::
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


6$:	.word	n$hlp,	r$hlp1,	r$hlp2,	r$hlp3,	r$hlp4
	.word	r$hlp5,	r$hlp6,	r$hlp7,	0

	;	row		column		video		option
	;-------------------------------------------------------------
n$hlp::
	.byte	SCRNTP+0d3,	0d24,		NORMAL,		0
	.word	1$		; "P.H.S. Status Screen"
r$hlp1	= .
	.byte	SCRNTP+0d6,	0d24,		REVERSE,	1
	.word	2$		; "Exit"
r$hlp2	= .
	.byte	SCRNTP+0d9,	0d24,		REVERSE,	2
	.word	3$		; "PHS Detector Setup"
r$hlp3	= .
	.byte	SCRNTP+0d10,	0d24,		REVERSE,	3
	.word	4$		; "PHS Comm Setup"
r$hlp4	= .
	.byte	SCRNTP+0d11,	0d24,		REVERSE,	4
	.word	5$		; "HV4032A Setup""
r$hlp5	= .
	.byte	SCRNTP+0d12,	0d24,		REVERSE,	5
	.word	6$		; "PHS Internals 1"
r$hlp6	= .
	.byte	SCRNTP+0d13,	0d24,		REVERSE,	6
	.word	7$		; "PHS Internals 2"
r$hlp7	= .
	.byte	SCRNTP+0d14,	0d24,		REVERSE,	7
	.word	8$		; "PHS Internals 3"


;01234567890123456789012345678901234567890123456789012345678901234567890123456
1$:	.asciz	        "  Setup and Help Screen Select    "

2$:	.asciz		"           Exit Screen            "

3$:	.asciz		"   P.H.S. Detector Setup Notes    "
4$:	.asciz		" P.H.S. Communication Setup Notes "
5$:	.asciz		"       HV4032A Setup Notes        "
6$:	.asciz		"       P.H.S. Internals  1        "
7$:	.asciz		"       P.H.S. Internals  2        "
8$:	.asciz		"       P.H.S. Internals  3        "


	;
	; hlp$scrn Questions
	;

hlp$ques::
	cmpa	#ENTER		; selecting ?
	bne	6$		; no - exit

	pshs	b,x,y

	leax	optarray,u	; get option
	ldb	*opt$posn
	ldb	b,x

	cmpb	#1		; exiting this screen ?
	bne	1$		; no - skip
	clr	*s$state	; yes
	bra	5$

1$:	aslb
	cmpb	#8$-7$		; valid option ?
	bhis	5$		; no - exit

	jsr	clr$scrn	; clear the screen

	ldx	#7$
	leax	[b,x]		; address of text

	lda	#SCRNTP-1	; top of screen
	ldb	#0d12

2$:	inca
	pshs	d
	jsr	fmthtxt
	puls	d
3$:	tst	,x+		; skip to end of line
	bgt	3$
	tst	,x		; end of text ?
	bpl	2$

4$:	lda	#SCRNBT		; load new cursor position
	ldb	#0
	jsr	pos$scrn
	lda	#1		; option processing
	sta	*o$state
5$:	clra			; dump character
	puls	b,x,y
6$:	rts


7$:	.word	8$,6$,9$,10$,11$,12$,13$,14$


8$:	.asciz	"Invalid Option"
	.byte	0q200

		;012345678901234567890123456789012345678901234567890
9$:	.asciz	"P.H.S. Detector Setup Notes:"
	.asciz	""
	.asciz	"(1)  Each P.H.S. / HV4032A channel is treated as a"
	.asciz	"     unique and individually programmable high voltage"
	.asciz	"     supply with a companion pulse height stabilizer."
	.asciz	""
	.asciz	"(2)  Connect the corresponding LED drive line, high"
	.asciz	"     voltage line, and PMT signal (input) lines to"
	.asciz	"     the detector."
	.asciz	""
	.asciz	"(3)  Connect the remote temperature sensor so that"
	.asciz	"     the P.H.S. system may compensate for the"
	.asciz	"     LED light output variations caused by ambient"
	.asciz	"     temperature changes."
	.asciz	""
	.asciz	"(4)  Use the Channel Control / Status screen to"
	.asciz	"     select a particular channel and set the"
	.asciz	"     appropriate voltage for your detector."
	.asciz	""
	.asciz	"(5)  Use the Channel Control / Status screen to"
	.asciz	"     calibrate the LED driver and activate the"
	.asciz	"     P.H.S. stabilizer. Once activated the channels'"
	.asciz	"     high voltage is automatically adjusted to"
	.asciz	"     maintain a constant response from the detector."
	.byte	0q200

		;012345678901234567890123456789012345678901234567890
10$:	.asciz	"P.H.S. Communication Setup Notes:"
	.asciz	""
	.asciz	"(1)  Each P.H.S. / HV4032A system may be controlled"
	.asciz	"     locally through the LCL port or remotely through"
	.asciz	"     the CTL port."
	.asciz	""
	.asciz	"(2)  The P.H.S. / HV4032A systems may be daisy"
	.asciz	"     chained by connecting the REM port to the CTL"
	.asciz	"     port of the next P.H.S. / HV4032A system."
	.asciz	""
	.asciz	"(3)  Daisy chained P.H.S. / HV4032A systems must have"
	.asciz	"     unique unit numbers as selected using the front"
	.asciz	"     panel thumbwheel switch."
	.asciz	""
	.asciz	"(4)  Select a particular P.H.S. / HV4032A system on"
	.asciz	"     the CTL port by the command $Un (n=0-9,A-F)."
	.asciz	""
	.asciz	"(5)  The P.H.S. system sends commands to the HV4032A"
	.asciz	"     system via the HVC port. Commands are queued and"
	.asciz	"     will be repeated until the HV4032A returns a"
	.asciz	"     proper response. (Commands sent to an off or"
	.asciz	"     disconnected HV4032A may be aborted with the"
	.asciz	"     $J command.)"
	.byte	0q200

		;012345678901234567890123456789012345678901234567890
11$:	.asciz	"HV4032A Setup Notes:"
	.asciz	""
	.asciz	"(1)  Connect the HV4032A High Voltage Power Supply"
	.asciz	"     J1 connector to the P.H.S. System HVC port."
	.asciz	""
	.asciz	"(2)  Set the HV4032A to use channel 16 and place the"
	.asciz	"     remote/local selector in the remote position."
	.asciz	""
	.asciz	"(3)  From the HV4032A Status screen select and"
	.asciz	"     execute the 'Read HV4032A' function to retrieve"
	.asciz	"     the complete state of the high voltage system."
	.asciz	""
	.asciz	"(4)  The Channel Control/Status screen may be used"
	.asciz	"     to Zero, Restore, and Set any individual"
	.asciz	"     high voltage channel."
	.asciz	""
	.asciz	"     The execution of the Power ON or OFF command"
	.asciz	"     from the HV4032A Status screen will do an"
	.asciz	"     implicit HOLD on all active P.H.S. channels."
	.asciz	"     The execution of the Zero, Restore, or HV-Set"
	.asciz	"     channel function will perform an implicit HOLD"
	.asciz	"     on the channel if it is active. A HV4032A power"
	.asciz	"     supply channel failure will do an implicit HOLD"
	.asciz	"     on the associated P.H.S. channel if it is active."
	.byte	0q200

		;012345678901234567890123456789012345678901234567890
12$:	.asciz	"P.H.S. Internals  1"
phs$int1  == .
	.asciz	""
	.asciz	"$C n     Calibrate the PHS channel number n (0-31)."
	.asciz	""
	.asciz	"$D n v   Set PHS channel n (0-31) LED drive level to "
	.asciz	"         value v (0-4095)."
	.asciz	""
	.asciz	"$E4      Enable  port xon/xoff (default)."
	.asciz	"$E5      Disable port xon/xoff."
	.asciz	""
	.asciz	"$H       Cross links current port with the HV4032A's"
	.asciz	"         HVC port for direct command entry."
	.asciz	""
	.asciz	"$IC      Clear input/output monitoring of HVC port"
	.asciz	"$II      Enable monitoring of data received from HVC"
	.asciz	"$IO      Enable monitoring of data transmitted to HVC"
	.asciz	""
	.asciz	"$J       Clear the HVC control queue."
	.asciz	""
	.asciz	"$LA      Toggle P.H.S. LED/acquisition 'active' flag."
	.asciz	"$LH      Toggle P.H.S. LED/acquisition 'hold' flag."
	.asciz	"$LF      Toggle P.H.S. LED/acquisition 'fail' flag."
	.asciz	"$LS      Toggle P.H.S. LED/acquisition 'scan' flag."
	.asciz	"$LC      Clear the P.H.S. LED/acquisition flags."
	.byte	0q200

		;012345678901234567890123456789012345678901234567890
13$:	.asciz	"P.H.S. Internals  2"
phs$int2  == .
	.asciz	""
	.asciz	"$MR      Run the MONDEB-09 monitor/debugger."
	.asciz	"$MA      Abort the monitor/debugger."
	.asciz	""
	.asciz	"$N n     Manually select the display screen n."
	.asciz	""
	.asciz	"$P ...   Stabilization Parameters for PHS"
	.asciz	"   n     channel number"
	.asciz	"   rsp   10% response voltage change"
	.asciz	"   thr   update change threshold voltage"
	.asciz	"   max   maximum single step voltage change"
	.asciz	""
	.asciz	"$RV      Returns the P.H.S. version."
	.asciz	""
	.asciz	"$S1      Motorola S1/S9 code loader."
	.asciz	"$S9"
	.asciz	""
	.asciz	"$Un      Select the specified P.H.S. unit n"
	.asciz	"         and enable the screen selector."
	.asciz	""
	.asciz	"$V       Toggle video screen enable/disable."
	.asciz	""
	.asciz	"$Z       List all P.H.S. Internal Options"
	.byte	0q200

		;012345678901234567890123456789012345678901234567890
14$:	.asciz	"P.H.S. Internals  3"
phs$int3  == .
	.asciz	""
	.asciz	"$T Channel Diagnostic Routines  (Escape = 'ESC')"
	.asciz	""
	.asciz	"$TA      Acq / Sel / no LED pulsing"
	.asciz	"$TB      Acq / Sel / with LED pulsing"
	.asciz	"$TC      Acq / Sel / ramping DAC / no LED pulsing"
	.asciz	"$TD      Acq / Sel / ramping DAC / with LED pulsing"
	.asciz	"$TE      Acq / Sel / 16 level DAC / with LED pulsing"
	.asciz	""
	.asciz	""
	.asciz	"$TF n    Acq / Selected single channel"
	.asciz	"         0, 10, 30, and 90 ma. LED drive"
	.asciz	""
	.asciz	""
	.asciz	"$TG n v  Acq / Selected single channel"
	.asciz	"         Specified LED drive level:"
	.asciz	"         (0 - 4095 == 0 - 100 ma.)"
	.asciz	""
	.asciz	""
	.asciz	"$TH      Acq / Sel / Temperature / no pulsing"
	.asciz	"$TI      Acq / Sel / Temperature / with pulsing"
	.byte	0q200


	;
	; hlp$scrn Options
	;

hlp$optn::
	cmpa	#CTRLW
	beq	1$

	clr	*o$state	; option completed
	ldb	#1
	stb	*s$state	; new state

	ldd	*opt$posn	; option position
	jsr	pos$scrn	; restore cursor

1$:	clra			; input character always used
	rts


