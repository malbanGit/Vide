	.title	Pulse Height Stabilizer
	;
	;********************************************************
	;*							*
	;*	PULSE HEIGHT STABILIZER				*
	;*							*
	;*		WRITTEN BY				*
	;*			ALAN R. BALDWIN			*
	;*			PHYSISICS DEPARTMENT		*
	;*			KENT STATE UNIVERSITY		*
	;*			KENT, OHIO  44242		*
	;*							*
	;*							*
	;*	V01.00	COMPLETED				*
	;*		   JUNE 1992				*
	;*							*
	;*							*
	;********************************************************


	.page
	.sbttl	system definitions

	.module	phs

	.include	/area.def/
	.include	/define.def/

	.include	/system.def/
	.include	/data.def/


	.radix	o		; octal constants

;  6809 data and program space

	$xtrn0	==	0	; 4096 bytes allocated
	$xtrn1	==	4	; for optional functions
	$xtrn2	==	10	; which may be down loaded
	$xtrn3	==	14	; using $s1 / $s9 commands
	$xtrn4	==	20
	$xtrn5	==	24
	$xtrn6	==	30
	$xtrn7	==	34
	$xtrn8	==	40
	$xtrn9	==	44

	$xtend	==	007400		; optional functions	(3.75k)

;	workpg	==	007400		; PHSMON workpage	(0.25k)

	bufsav	==	010000		; buffers area		(27.5k)

	ioblok	==	077400		; i/o register block	(0.25k)

	stack	==	ioblok-2	; top of stack area	(0.25k)

	pgmsav	==	100000		; program space		(32.0k)

	irqvec	==	177660		; vector table


	.page
	.sbttl	Areas

	.area	BUFSAV		; buffers
port0:	.blkb	portalloc
port1:	.blkb	portalloc
port2:	.blkb	bufralloc

usrstk:	.blkb	0d2		; current user stack

exrsrvd::	.blkb	0d2	; vector addresses
exswi3::	.blkb	0d2
exswi2::	.blkb	0d2
exfirq::	.blkb	0d2
exirq::		.blkb	0d2
exswi::		.blkb	0d2
exnmi::		.blkb	0d2

	.area	PGMSAV		; program
chksm0:	.word	0		; rom checksum
clradc:	ldd	acq$adc		; clear adc
undfnd:	rti			; non-existent routines

	.area	IRQVEC

irqtbl:	.word	undfnd,	exrsrvd	; reserved	(unused)
	.word	debugp,	exswi3	; swi3
	.word	undfnd,	exswi2	; swi2		(unused)
	.word	clradc,	exfirq	; firq vector
	.word	clocki,	exirq	; irq  vector
	.word	undfnd,	exswi	; swi		(unused)
	.word	undfnd,	exnmi	; nmi		(unused)
	.word	0,	0	; end of table

1$:	jmp	[exrsrvd,pcr]	; use loaded vectors
2$:	jmp	[exswi3,pcr]
3$:	jmp	[exswi2,pcr]
4$:	jmp	[exfirq,pcr]
5$:	jmp	[exirq,pcr]
6$:	jmp	[exswi,pcr]
7$:	jmp	[exnmi,pcr]
8$:	jmp	pwrup,pcr

	.word	1$	; reserved	(unused)
	.word	2$	; swi3
	.word	3$	; swi2
	.word	4$	; firq vector
	.word	5$	; irq  vector
	.word	6$	; swi		(unused)
	.word	7$	; nmi		(unused)
	.word	8$	; power up entry point


	.page
	.sbttl	Copyright Notice

	.area	PGMSAV

	.radix	o

cpyrit:	phs$cr	=	.
	.byte	15,12
	.ascii	/PHS   0000  V01.01/
	.byte	15,12
	phs$id	=	.-phs$cr	; length of version
	.ascii	/Copyright 1992/
	.byte	15,12
	.ascii	/Kent State University/
	.byte	15,12
	.ascii	/Kent, Ohio  44242/
	.byte	15,12
	phs$cr	=	.-phs$cr	; length of notice




	.page
	.sbttl	Debug Printer

	.area	BUFSAV

debugr:	.blkb	0d1		; debugger flag

	.area	PGMSAV

debugp:	lda	,x+		; get character
	beq	1$
	bmi	2$
	jsr	plcbuf		; dump character
	bra	debugp

1$:	lda	#0q15		; <CR>
	jsr	plcbuf
	lda	#0q12		; <LF>
	jsr	plcbuf
2$:	rti

	.page
	.sbttl	rom checksum verification

	.radix	o

	;
	;  enter via	ldu	#1$
	;		jmp	verrom
	;	1$:	.word	start address
	;		.word	last address+1
	;		.word	checksum location
	;		.word	error code
	;  returns here ---
	;
verrom:	ldx	,u++		; start address
	clra			; init sum
	clrb
1$:	addb	,x+		; build sum
	adca	#0
	cmpx	,u		; finished ?
	bne	1$		; loop until all summed
	leau	2,u
	ldx	,u
	subb	,x		; take out checksum itself
	sbca	#0
	subb	1,x
	sbca	#0
	addd	,x		; this should give '0'
	bne	verror		; no - have an error
	jmp	4,u		; return

	.page
	.sbttl	ram verify routine
	;
	;  enter via	ldu	#1$
	;		jmp	verram
	;	1$:	.word	start address
	;		.word	last address+1
	;		.word	error code
	;  returns here ---
	;
verram:	ldx	,u++		; first location
	clra
1$:	sta	,x+		; incrementing pattern
	inca
	bne	2$
	inca
2$:	cmpx	,u		; finished settup ?
	bne	1$		; no - loop
	ldx	-2,u		; first location
	clra
3$:	cmpa	,x+
	bne	verror		; bad - error
	inca
	bne	4$
	inca
4$:	cmpx	,u		; finished checking ?
	bne	3$		; no - loop

	ldx	-2,u		; first address
	clra
5$:	coma
	sta	,x+		; complement of incrementing pattern
	coma
	inca
	bne	6$
	inca
6$:	cmpx	,u		; finished settup ?
	bne	5$		; no - loop
	ldx	-2,u		; first location
	clra
7$:	coma
	cmpa	,x+
	bne	verror		; bad - error
	coma
	inca
	bne	8$
	inca
8$:	cmpx	,u		; finished checking ?
	bne	7$		; no - loop
	jmp	4,u		; finished

	.page
	.sbttl	verify error routine

verror:	ldb	#0d10		; 10. flashes
1$:	lda	2,u		; error code byte
	ldx	#sys$led	; LED address
2$:	sta	,x+
	cmpx	#sys$led+0d32
	bne	2$
	ldx	#-0d25000	; .1 seconds @ 2mHZ
3$:	leax	1,x
	bne	3$
	lda	3,u		; error code byte
	ldx	#sys$led	; LED address
4$:	sta	,x+
	cmpx	#sys$led+0d32
	bne	4$
	ldx	#-0d25000
5$:	leax	1,x
	bne	5$
	decb
	bgt	1$		; loop for 10. flashes
	jmp	4,u		; and return

	.page
	.sbttl	6809 startup

	.area	PGMSAV
	.radix	o

pwrup:	orcc	#120		; disable interrupts

;  verify rom integrity
	ldu	#1$
	jmp	verrom
1$:	.word	pgmsav		; first address
	.word	000000		; last address+1
	.word	chksm0		; location of checksum word
	.byte	1,3		; error code

;  verify ram integrity
	ldu	#2$
	jmp	verram
2$:	.word	$xtend		; first address after user space
	.word	stack		; last address+1
	.byte	2,3		; error code

;  clear all ram data
	ldd	#0		; set all ram to zero
	lds	#$xtend		; after user space
3$:	std	,s++
	cmps	#stack
	bne	3$

;  set interrupt table
	ldx	#irqtbl		; table pointer
4$:	ldd	,x++		; get vector entry
	beq	5$
	std	[,x++]		; place in vector table
	bra	4$		; loop
5$:

;  set stack pointer

	lds	#stack		; set stack pointer

;  initialize i/o

	ldd	#0
	std	acq$dac		; clear dac
	clr	acq$slct	; clear select register
	ldb	#0d24		; wait for conversion
6$:	decb
	bgt	6$
	tst	acq$adc		; clear adc

;  initialize LCL port

	ldu	#port0		; pointer to port0
	tfr	u,d
	tfr	a,dp		; load direct page
	std	*lclstk		; and save in direct page
	lda	#1		; enable xon/xoff
	sta	*d.stat
	ldd	#0
	jsr	ini$6850	; initialize port

;  initialize CTL port

	ldu	#port1		; pointer to port1
	tfr	u,d
	tfr	a,dp		; load direct page
	std	*lclstk		; and save in direct page
	lda	#1		; enable xon/xoff
	sta	*d.stat
	ldd	#1
	jsr	ini$6850	; initialize port

;  initialize HVC port

	ldu	#port2		; pointer to port2
	tfr	u,d
	tfr	a,dp		; load direct page
	std	*lclstk		; and save in direct page
	lda	#0		; disable xon/xoff
	sta	*d.stat
	ldd	#2
	jsr	ini$6850	; initialize port

;  initialize LED's

	ldx	#sys$led	; clear the LED indicators
	lda	#0d32
	ldb	#0x03
7$:	stb	,x+
	deca
	bgt	7$

;  Initialize default values for acquisition

	jsr	phs$init

;  enable clock interrupt

	clr	clr$clk		; clear pending clock interrupt
	lda	#0x40		; set clock interrupt enable
	sta	sys$clk

;  startup LCL port

	ldu	#port0		; pointer to port0
	tfr	u,d
	tfr	a,dp		; load direct page
	std	usrstk		; and save user stack
	lda	*rstat0
	ora	#0q200		; unit enabled by default
	sta	*rstat0
	sta	*scrn$sts

	andcc	#257		; now allow interrupts
	jsr	sel$scrn	; go startup screen

	.page
	.sbttl	main routine

main:	orcc	#120		; disable interrupts
	lds	#stack		; reset stack pointer
	andcc	#257		; now allow interrupts

	ldd	#port0		; pointer to port0
	bsr	1$
	ldd	#port1		; pointer to port1
	bsr	1$

	bra	main		; keep going

1$:	tfr	d,u
	tfr	a,dp		; load direct page
	std	usrstk		; and save user stack

	jsr	syscin		; get character from scan buffer
	tst	*char		; if none - skip
	beq	2$

	jsr	sel$scrn	; go to screen selector

	tst	*char		; if none - skip
	beq	2$
	jsr	listpr		; enter list processor

2$:	rts


	.page
	.sbttl	clock and serial ports interrupt routine

	.area	BUFSAV

timflg::	.blkb	0d1	; timing flag


	.area	PGMSAV

	;  interrupt by 'irq'

clocki:	orcc	#120		; stop other interrupts

	ldu	#port0
	jsr	dlchck
	ldu	#port1
	jsr	dlchck
	ldu	#port2
	jsr	dlchck

	tst	sys$clk		; clock interrupt ?
	bpl	2$		; no - skip

	dec	timflg		; update timing flag
	bgt	1$
	clr	timflg
1$:	clr	clr$clk		; clear clock latch

	jsr	upd$scrn	; update screens

2$:	rti


	.page
	.sbttl	Host 'Data Link' checks

	; index register u must point to the port area

dlchck:	tfr	u,d		; setup direct page
	tfr	a,dp

1$:	lda	*bfstat
	bita	#scn		; scan buffer need data ?
	bne	3$		; if not - skip

2$:	lda	*d.stat
	bita	#1		; xon/xoff enabled ?
	beq	3$		; if not - skip
	tsta			; xoff'd ?
	bpl	3$		; no - skip
	anda	#177		; clear xoff'd
	sta	*d.stat
	ldb	#$xon		; get 'xon' character
	stb	*$dxonf		; place character for xmtr to see
	bra	5$

3$:	lda	*$dxonf		; special ?
	bne	5$		; yes - skip
	lda	*dlcntr		; any characters ?
	beq	6$		; no - skip
4$:	lda	*d.stat
	bita	#1		; xon/xoff enabled ?
	beq	5$		; no - skip
	bita	#100		; xoff'd ?
	bne	6$		; yes - skip
5$:	lda	*d.csr		; enable xmtr
	ora	#0x20
	sta	*d.csr
	sta	[dlcsr,u]	; enable xmtr
6$:				; fall through to dlrint

	.page
	.sbttl	host data link receiver interrupt handler

	; index register u must point to the port area

dlrint:	lda	[dlstat,u]	; data ?
	bita	#1
	lbeq	6$		; no - skip

	ldb	[dlrcv,u]	; get data
	andb	#0x7F		; 7-bit ascii

	lda	*d.stat
	bita	#1		; xon/xoff enabled ?
	beq	2$		; if not - skip
				;  check for xon/xoff characters
	cmpb	#$xon		; 'xon' ?
	bne	1$		; if not - skip
	anda	#277		; clear xoff
	sta	*d.stat
	bra	6$		; exit

1$:	cmpb	#$xoff		; 'xoff' ?
	bne	2$		; if not - skip
	ora	#100		; set xoff
	sta	*d.stat
	bra	6$		; exit

2$:	ldx	*scpntr		; get pointer
	stb	,x+		; place character
	cmpx	*scend		; at end of buffer ?
	bne	3$		; if not - skip
	leax	scbuf,u		; reset pointer
3$:	stx	*scpntr		; save new pointer
	lda	*scntr		; get count
	inca			; update count
	sta	*scntr		; save count

	cmpa	#scfull		; full ?
	bcs	6$		; if not - skip
	lda	*bfstat
	ora	#scn
	sta	*bfstat		; say full
	lda	*d.stat
	bita	#1		; xon/xoff enabled ?
	beq	6$		; if not - exit
	tsta			; already xoff'd ?
	bpl	4$		; if not - skip
	ldb	*scntr+1	; get count
	andb	#7		; after 8'th character do another xoff
	bne	6$		; exit

4$:	ora	#200		; xoff'd
	sta	*d.stat
	ldb	#$xoff		; get 'xoff' character
	lda	[dlstat,u]	; output ready ?
	bita	#2
	beq	5$		; no - exit
	stb	[dltrn,u]	; transmit data
	bra	6$

5$:	stb	*$dxonf		; place character for xmtr to see
6$:				; fall through to dltint

	.page
	.sbttl	host data link transmitter interrupt handler

	; index register u must point to the port area

dltint:	lda	[dlstat,u]	; output ready ?
	bita	#2
	beq	8$		; no - exit

	ldb	*$dxonf		; special ?
	bne	7$		; yes - skip
1$:	lda	*d.stat
	bita	#1		; xon/xoff enabled ?
	beq	2$		; no - skip
	bita	#100		; xoff'd ?
	bne	3$		; yes - exit
2$:	ldb	*dlcntr		; get character count
	bne	4$		; if characters left - skip
3$:	lda	*d.csr		; disable xmtr interrupts
	anda	#~0x20
	sta	*d.csr
	sta	[dlcsr,u]	; terminate transfers
	bra	8$		; finished

4$:	decb			; one less character
	stb	*dlcntr		; save count
	cmpb	#dlmpty		; buffer emptying ?
	bcc	5$		; if not - skip
	lda	*bfstat
	anda	#~dl
	sta	*bfstat		; else say - need data
5$:	ldx	*dlqntr		; get pointer to character
	ldb	,x+		; get character
	cmpx	*dlend		; at end of buffer ?
	bne	6$		; if not - skip
	leax	dlbuf,u		; reset pointer
6$:	stx	*dlqntr		; save new pointer
7$:	stb	[dltrn,u]	; transmit data
	clr	*$dxonf		; clear special
8$:	rts			; finished

	.page
	.sbttl	place data in data link buffer

	; index register u must point to the port area

plcbuf:	pshs	b

1$:	ldb	*bfstat
	bitb	#dl		; buffer full ?
	bne	1$		; yes - loop

	puls	b

tt_out::
	pshs	cc,d,x
	orcc	#120		; hold interrupts
	ldx	*dlpntr		; get pointer
	sta	,x+		; save character
	inc	*dlcntr		; update counter
	cmpx	*dlend		; at end of buffer ?
	bne	1$		; if not - skip
	leax	dlbuf,u		; reset pointer
1$:	stx	*dlpntr		; save new pointer
	ldb	*dlcntr		; get count
	cmpb	#dlfull		; buffer full ?
	bcs	2$		; if not - branch
	ldb	*bfstat
	orb	#dl
	stb	*bfstat		; set full

2$:	lda	1,s		; get character and
	bsr	hvc_oup		; send to monitoring port

	puls	cc,d,x
	rts			; finished

	.page
	.sbttl	get character from scan buffer

	; index register u must point to the port area

tt_inp::
	lda	*scntr		; any characters ?
	sta	*char
	bne	1$		; yes - skip
	rts

1$:	pshs	cc,b,x
	orcc	#120		; hold interrupts
	ldx	*scqntr		; get pointer
	lda	,x+		; get character
	sta	*char		; save character
	cmpx	*scend		; at end of buffer ?
	bne	2$		; if not skip
	leax	scbuf,u		; reset pointer
2$:	stx	*scqntr		; save pointer
	lda	*scntr		; update count
	deca
	sta	*scntr
	cmpa	#scmpty		; empty ?
	bcc	3$		; if not - skip
	lda	*bfstat
	anda	#~scn
	sta	*bfstat		; say empty

3$:	lda	*char		; get character and
	bsr	hvc_inp		; send to monitoring port

	puls	cc,b,x
	lda	*char		; return character
	rts			; finished


hvc_oup:
	ldx	.$ipoup		; monitoring port specified ?
	bne	hvc_mon
	rts

hvc_inp:
	ldx	.$ipinp		; monitoring port specified ?
	bne	hvc_mon
	rts

hvc_mon:
	cmpu	#port2		; HVC port ?
	bne	1$

	pshs	d,dp,u
	tfr	x,d		; LCL/CTL port
	tfr	d,u
	tfr	a,dp
	lda	,s		; send the HVC char
	jsr	tt_out		; to LCL/CTL port
	puls	d,dp,u

1$:	rts

	.page
	.sbttl	list processor

	;
	; 1.	if in single char mode, then:
	;		clear single char mode
	;		if not in special mode, then:
	;			scan for control characters, if found:
	;				clear gosub
	;				end
	;		do gosub (if defined)
	;		if character used - end
	;		else go to 2.

listpr:	lda	*lstat		; get status
	bpl	list.d		; not in single - skip
	anda	#177		; clear single mode
	sta	*lstat		; save status
	bita	#20		; special character mode ?
	beq	1$		; not special mode - skip
	anda	#357		; clear special
	sta	*lstat		; and save
	lda	*char		; get any character
	bra	list.a		; and go
1$:	lda	*char		; get character
	cmpa	#40		; a control ?
	bcc	list.a		; if not - skip
	ldx	#0		; else clear gosub
	stx	*gosub
	bra	list.b
list.a:	ldx	*gosub		; get process address
	beq	list.b		; if undefined - skip
	jsr	,x		; do it
	bcc	list.d		; character not used
list.b:	rts			; finished

	; 2.	do command scanner
	;	if command is found - finished

list.d:	jsr	cmdscn		; scan for commands
	bcs	list.e		; command found - done
	lda	*rstat0		; are we running
	bmi	list.f		; if so - skip ahead
list.e:	rts			; finished

	; 3.	check scan mode, if set then:
	;		if char is (+) then:
	;			clear scan
	;			set build
	;			reset list buffer
	;			end

list.f:	lda	*lstat
	bita	#100		; in scan mode ?
	beq	list.j		; if not - skip
	ldb	*char		; get character
	cmpb	#'+		; is it a (+)  ?
	bne	list.g		; if not - skip out
	anda	#277		; else clear scan mode
	ora	#40		; set build
	sta	*lstat		; save new status
	clr	*schflg		; clear seen flag
	clr	*lstcnt		; reset buffer
	leax	lsbuff,u
	stx	*lpntr
list.g:	rts			; finished

	; 4.	check build, if not set then:
	;		reset buffer
	;		if char is (0-9) or (-)
	;		   or free format   then:
	;			set build
	;			put char in buffer
	;			goto lcheck
	;		   else: set scan
	;			 go scan

list.j:	lda	*lstat
	bita	#40		; building ?
	bne	list.o		; if so - skip
	clr	*schflg		; clear seen flag
	clr	*lstcnt		; reset buffer
	leax	lsbuff,u
	stx	*lpntr
	ldb	*format		; in free format ?
	beq	list.k		; if so - set up build
	ldb	*char		; get character
	cmpb	#'-		; is it a (-) ?
	beq	list.k		; if so - skip
	cmpb	#'0		; bcd character ?
	bcs	list.l		; <0 - skip
	cmpb	#'9		; >9 ?
	bhi	list.l		; not a number - skip
list.k:	ora	#40		; set build
	sta	*lstat		; save status
	bra	list.o		; now process this character
list.l:	ora	#100		; set scan
	sta	*lstat		; save status
	bra	list.f		; go scan

	; 5.	build is set
	;		put character in buffer
	;		check bufffer

list.o:	lda	*format		; check for free format
	beq	list.q		; if so - skip
	lda	*char		; get character
	cmpa	#40		; any controls ?
	bcc	list.x		; if not  skip
list.p:	clr	*lstcnt		; reset buffer
	clr	*schflg		; seen character flag
	leax	lsbuff,u
	stx	*lpntr
	lda	*lstat		; set status for scan
	anda	#17		; save lower for ?
	ora	#100		; scanning
	sta	*lstat
	rts			; finished

list.q:	lda	*schflg		; seen a char ?
	bne	list.u		; if so - skip
	lda	*char		; else scan this character
	cmpa	#'-		; a - sign ?
	beq	list.r		; if so - save it
	cmpa	#'+		; a + sign ?
	beq	list.t		; strip +'s
	cmpa	#40		; space ?
	beq	list.t		; strip spaces
	cmpa	#'0		; only want numerals
	bcs	list.p
	cmpa	#':
	bcc	list.p
	bsr	list.r		; save character
list.s:	inc	*schflg		; character seen
list.t:	rts			; finished

list.r:	ldx	*lpntr		; get pointer
	sta	,x+		; save character
	stx	*lpntr
	inc	*lstcnt		; one more character
	rts			; and return

list.u:	lda	*char		; get character
	cmpa	#'-		; a - sign ?
	beq	list.w		; if so - skip
	cmpa	#'+		; a + sign ?
	beq	list.w		; if so - skip
	cmpa	#'0		; want only numerals
	bcs	list.w
	cmpa	#':
	bcc	list.w
	ldx	*lpntr		; get pointer
	sta	,x		; save character
	lda	*lstcnt		; at end of buffer ?
	cmpa	#0d8
	beq	list.v		; if so - skip update
	leax	1,x		; else update pointer
	stx	*lpntr
	inc	*lstcnt		; update counter
list.v:	rts			; finshed
list.w:	bsr	lche.a		; go evaluate and process
	clr	*schflg		; clear seen flag
	bra	list.q		; rescan last character

list.x:	cmpa	#'-		; save only +,-,spaces
	beq	list.y		; and numerals
	cmpa	#'+
	beq	list.y
	cmpa	#40
	beq	list.y
	cmpa	#'0
	bcs	lche.b
	cmpa	#':
	bcc	lche.b

list.y:	ldx	*lpntr		; get pointer
	sta	,x+		; save character
	stx	*lpntr
	inc	*lstcnt		; update count


lcheck:	lda	*lstcnt		; get count
	cmpa	*format		; enough characters ?
	bne	lche.c		; if not - skip
lche.a:	jsr	evaln		; go evaluate data
	clr	*lstcnt		; clear buffer
	leax	lsbuff,u
	stx	*lpntr
	ldx	*gosub		; get process
	beq	lche.c		; if undefined - skip
	jmp	,x		; else do process

lche.b:	clr	*lstcnt		; clear buffer
	leax	lsbuff,u
	stx	*lpntr
lche.c:	rts			; finished

	.page
	.sbttl	command scanner

cmdscn:	ldb	*char		; get character
	lda	*pchar		; get previous character
	stb	*pchar		; save new character
	cmpa	#'$		; old a ($) ?
	bne	5$		; if not - skip
	lda	*lstat
	anda	#~360
	sta	*lstat		; all new list control
	cmpb	#141		; allow lower case commands
	bcs	1$		; upper case - skip
	subb	#40		; make lower into upper
1$:	subb	#'A		; A=0,Z=31
	cmpb	#'U-'A		; U ?
	beq	2$		; yes - skip
	lda	*rstat0		; running ?
	bpl	5$		; if not - skip
	tstb			; A-Z ?
	bmi	3$		; not an internal command
	cmpb	#32		; not A-Z ?
	bcc	3$		; not an internal command
2$:	ldx	#cmdtbl		; table pointer
	aslb			; offset into table
	jsr	[b,x]		; do command
	sec			; found command
	rts			; finished

3$:	ldb	*char		; check if user function
	subb	#'0		; make bcd
	bmi	4$		; if not - bad command
	cmpb	#'9-'0		; must be a digit
	bhi	4$		; if not - bad command
	aslb
	aslb
	ldx	#$xtrn0
	leax	b,x		; add offset into entry table
	ldd	,x		; a function there ?
	beq	4$		; no - bad command
	subd	2,x		; verify entry
	cmpd	#0x5AA5		; check code
	bne	4$		; invalid - bad command
	jsr	[,x]		; and goto user function
	sec			; found command
	rts			; finished

;  bad command service
badcom=.
	leas	2,s		; pop return
4$:	jsr	errgos		; indicate error
	sec			; bad command
	rts			; finished
5$:	clc			; no command
	rts			; finished


	;command jump address table

cmdtbl:	.word	badcom ;.$a
	.word	badcom ;.$b
	.word	.$c
	.word	.$d
	.word	.$e
	.word	badcom ;.$f
	.word	badcom ;.$g
	.word	.$h
	.word	.$i
	.word	.$j
	.word	badcom ;.$k
	.word	.$l
	.word	.$m
	.word	.$n
	.word	badcom ;.$o
	.word	.$p
	.word	badcom ;.$q
	.word	.$r
	.word	.$s
	.word	.$t
	.word	.$u
	.word	.$v
	.word	badcom ;.$w
	.word	badcom ;.$x
	.word	badcom ;.$y
	.word	.$z

	.page
	.sbttl	evaluate number routine

evaln:	clr	*nsign		; clear sign
	clr	*bincntr	; initialize counter
	leay	nsign,u		; point to variables
	ldb	#ndigit		; maximum number of digits
	stb	*numcntr
1$:	clr	,y+		; clear ndigit bytes
	decb
	bne	1$		; loop until all cleared
	ldx	*lpntr		; string pointer
2$:	ldb	,-x		; get character
	cmpb	#'-		; a (-) ?
	bne	3$		; if not - skip
	lda	#377		; sign is negative
	sta	*nsign
	bra	5$		; skip ahead
3$:	tst	*numcntr	; got enough ?
	beq	7$		; if so - skip
	cmpb	#40		; a space ?
	beq	5$		; if so - skip
	cmpb	#'+		; a '+' ?
	beq	5$		; if so - skip
	subb	#'0		; make bcd
	bmi	4$		; if not -  skip
	cmpb	#0d9		; must be a digit
	bls	6$		; if so - skip
4$:				; error !
5$:	clrb
6$:	stb	,-y		; save character
	dec	*numcntr	; update counters
	inc	*bincntr
7$:	dec	*lstcnt		; any more ?
	bgt	2$		; loop until done


	.page
	.sbttl	bcd to binary conversion

bcdbin:	ldd	#0		; init result
	bra	2$		; go to entry
1$:	aslb			; *2
	rola
	std	,--s		; save
	aslb			; *8
	rola
	aslb
	rola
	addd	,s++		; *2+*8 -> *10
2$:	addb	,y+		; add in digit
	adca	#0
	dec	*bincntr	; end ?
	bne	1$

;  now use sign
	tst	*nsign		; negative ?
	beq	3$		; if positive - skip
	coma
	comb
	addd	#1
3$:	std	*number		; save result
	rts			; finished

	.page
	.sbttl	next character transfer routines

nxtspc:	lda	*lstat
	ora	#20
	sta	*lstat		; re-enable special character mode

nxtchr:	lda	*lstat
	ora	#200
	sta	*lstat		; re-enable character mode

	sec			; character used

nxtgos:	ldx	,s++		; next entry
	stx	*gosub
	rts			; finished

errgos:
endgos:	ldx	#0		; no entry
	stx	*gosub
	rts			; finished

;  table driven dispatcher

$dispatch:
	cmpa	#141		; allow lower case options
	bcs	1$		; skip if upper
	cmpa	#173
	bcc	1$		; not lower - skip
	suba	#40		; make upper
1$:	ldx	,s++		; table address
2$:	clc			; character unused if exits
	tst	,x		; end of table ?
	bmi	3$		; terminate scan and do service
	beq	endgos		; end of service
	cmpa	,x		; match table entry ?
	beq	3$		; yes - exit
	leax	3,x		; update table pointer
	bra	2$		; and loop

3$:	jmp	[1,x]		; go to service routine


	.page
	.sbttl	$c command

	; Calibrate a channel

.$c:	jsr	nxtgos
	lda	*number+1	; channel number
	jsr	phs$cal		; do a calibration
	rts

	.sbttl	$d command

	; Set a channel

.$d:	jsr	nxtgos
	ldd	*number
	std	*tempv1

	jsr	nxtgos
	lda	*tempv1+1	; channel number
	ldx	*number		; and DAC set value
	jsr	phs$set		; do a setup
	rts


	.page
	.sbttl	$e command

	;  $e controller communication setup

.$e:	jsr	nxtchr		; come back with character

	jsr	$dispatch	; go to service routine
	.byte	'4
	.word	1$
	.byte	'5
	.word	2$
	.byte	'X
	.word	3$
	.byte	0		; end of table


1$:	lda	*d.stat
	ora	#1
	sta	*d.stat		; enable xon/xoff 'link'
	bra	.$e
2$:	lda	*d.stat
	anda	#~1
	sta	*d.stat		; disable xon/xoff 'link'
	bra	.$e

	; This undocumented $e function sets
	; the debugging flags.
	;
	; $ex - loads new debugging flags

3$:	sec			; character used
	jsr	nxtgos		; come back with data
	ldb	*number+1	; low order
	stb	debugr		; new 'debug' flags
	jmp	endgos


	.page
	.sbttl	.$h command

	; Direct link to the HVC port

.$h:	stu	,--s		; save current port #
	stu	.$ipinp		; setup input monitoring

	; Transfer LCL / CTL port characters to the HVC port

1$:	ldd	,s		; current user
	tfr	d,u
	tfr	a,dp
	jsr	tt_inp
	beq	1$

	cmpa	#0q33		; check for escape
	beq	2$		; 'ESC'

	pshs	a

	ldd	#port2
	tfr	d,u
	tfr	a,dp

	puls	a
	jsr	tt_out		; send character

	bra	1$

2$:	ldd	#0		; clear monitoring
	std	.$ipinp
	std	.$ipoup
	leas	2,s
	jmp	endgos


	.page
	.sbttl	.$i command

	.area	BUFSAV

.$ipinp:
	.blkb	2		; input  monitoring port
.$ipoup:
	.blkb	2		; output monitoring port


	.area	PGMSAV

	; Monitor HVC Port

.$i:	jsr	nxtchr		; come back with character

	jsr	$dispatch	; go to service routine
	.byte	'C
	.word	.$ic
	.byte	'I
	.word	.$ii
	.byte	'O
	.word	.$io
	.byte	0		; end of table


.$ic:	ldd	#0		; clear port monitoring
	std	.$ipinp
	std	.$ipoup
	bra	.$i

.$ii:	stu	.$ipinp		; input port monitor
	bra	.$i

.$io:	stu	.$ipoup		; output port monitor
	bra	.$i


	.sbttl	.$j command

	; Empty the hvc queue

.$j:	pshs	cc,dp,u
	orcc	#0q120		; hold interrupts
	ldd	#port2
	tfr	d,u
	tfr	a,dp
	clr	*que$cntr	; clear queue variables
	clr	*que$inp
	clr	*que$oup
	ldd	#0
	std	*q$gosub
	puls	cc,dp,u
	rts	

	.page
	.sbttl	.$l command

	; Set the acquisition LED status

.$l:	jsr	nxtchr

	jsr	$dispatch
	.byte	'A
	.word	.$la
	.byte	'H
	.word	.$lh
	.byte	'F
	.word	.$lf
	.byte	'S
	.word	.$ls
	.byte	'C
	.word	.$lc
	.byte	0

.$la:	sec
	jsr	nxtgos		; .$la
	ldb	#$ACTIVE
	bra	.$lahfs

.$lh:	sec
	jsr	nxtgos		; .$lh
	ldb	#$HOLD
	bra	.$lahfs

.$lf:	sec
	jsr	nxtgos		; .$lf
	ldb	#$FAILED
	bra	.$lahfs

.$ls:	sec
	jsr	nxtgos		; .$ls
	ldb	#$SCAN
	bra	.$lahfs

.$lc:	sec
	jsr	nxtgos		; .$lo
	lda	*number+1	; get the variable address pointer
	ldb	#$STOP
	jsr	chng$sts	; change the status
	jsr	wait$sts
	rts

.$lahfs:
	stb	,-s		; save update
	lda	*number+1
	jsr	rd$sts		; get the status
	eorb	,s+		; update status
	jsr	chng$sts	; change the status
	jsr	wait$sts
	rts


	.page
	.sbttl	$m command - MONDEB-09

	; This monitor may not be invoked by more than
	; one port simultaneously

	.area	BUFSAV

uixsav:	.blkb	2		; index register u saved for i/o

	.area	PGMSAV

.$m:	jsr	nxtchr		; come back with character

	jsr	$dispatch	; go to service routine
	.byte	'A
	.word	.$ma
	.byte	'R
	.word	.$mr
	.byte	-1
	.word	.$mr
	.byte	0		; end of table


.$ma:	ldd	#0		; abort active state
	std	uixsav

.$mr:	ldd	uixsav		; active ?
	bne	1$		; yes - exit
	stu	uixsav		; save index register u
	ldd	#typswi
	std	exswi		; swi interrupt vector
	ldd	#phsidta
	std	conin
	std	altin
	ldd	#phsodta
	std	conout
	std	altout
	jsr	mond09		; start up MONDEB - 09
	ldd	#0
	std	uixsav		; inactive
	rts

1$:	cmpd	#port0		; port 0 using ?
	bne	2$		; no - skip
	ldx	#5$		; note
	bra	3$

2$:	cmpd	#port1		; port 1 using ?
	bne	.$ma		; no - then initialize
	ldx	#6$		; note

3$:	lda	,x+
	beq	4$
	jsr	plcbuf		; send help
	bra	3$

4$:	rts

5$:	.byte	0q015,0q012
	.ascii	"MONDEB-09 is active on the LCL Port."
	.byte	0q015,0q012,0

6$:	.byte	0q015,0q012
	.ascii	"MONDEB-09 is active on the CTL Port."
	.byte	0q015,0q012,0



	.page
	.sbttl	PHS I/O Drivers

	;********************************************************
	;*      default PHS i/o drivers
	;********************************************************

	;* phsidta - return console input character
	;* output: c=0 if no data ready, c=1 a=character

phsidta:
	andcc	#357		; enable 'irq' to allow characters
	pshs	b,dp,u		; save these

	bsr	prtscn		; scan other port

	ldd	uixsav		; access correct port
	lbeq	main		; this should never happen
	tfr	d,u
	tfr	a,dp

	jsr	tt_inp		; check for a character
	bne	3$		; yes - skip

	puls	b,dp,u		; restore these
	clc			; no character
	rts			; return to caller

3$:	cmpa	#0o141		; translate lower to upper
	bcs	4$
	cmpa	#0o173
	bcc	4$
	suba	#0o40
4$:	puls	b,dp,u		; restore these
	sec
	rts

	;* phsodta - output character to console device
	;* input: a=character to send
	;* all registers transparent

phsodta:
	andcc	#357		; enable 'irq' to allow characters
	pshs	d,dp,u		; save these
	pshs	a

	bsr	prtscn		; scan other port

	ldd	uixsav		; access correct port
	lbeq	main		; this should never happen
	tfr	d,u
	tfr	a,dp

	puls	a		; plcbuf requires character in a
	jsr	plcbuf		; send the character

	puls	d,dp,u		; restore these
	rts

	; Alternate Port Scanner

prtscn:	pshs	d,dp,x,y,u
	ldd	#port0		; pointer to port0
	bsr	1$
	ldd	#port1		; pointer to port1
	bsr	1$
	puls	d,dp,x,y,u
	rts

1$:	cmpd	uixsav		; only allow other port
	beq	2$
	tfr	d,u
	tfr	a,dp		; load direct page
	std	usrstk		; and save user stack

	jsr	syscin		; get character from scan buffer
	tst	*char		; if none - skip
	beq	2$

	jsr	sel$scrn	; go to screen selector

	tst	*char		; if none - skip
	beq	2$
	jsr	listpr		; enter list processor

2$:	rts


	.page
	.sbttl	$n command

.$n:	jsr	nxtgos		; wait for

	ldd	*number
	pshs	cc
	orcc	#0q120
	lda	*scrn$sts	; mask in new screen
	anda	#~0x0F
	aba
	sta	*scrn$sts
	clr	*s$state
	puls	cc
1$:	rts


	.page
	.sbttl	$p command

.$p:	jsr	nxtgos
	ldd	*number		; channel number
	std	*tempv1

	jsr	nxtgos
	ldd	*number		; 10% response voltage change
	std	*tempv2

	jsr	nxtgos
	ldd	*number		; update change threshold voltage
	std	*tempv3

	jsr	nxtgos
	ldd	*number		; maximum single step voltage change
	std	*tempv4

	ldd	*tempv1
	cmpd	#0d31		; valid channel
	bhi	1$		; no - exit
	ldx	#acqvtbl
	aslb
	leax	[b,x]
	ldd	*tempv2
	cmpd	#0d50		; valid 10% response change ?
	bhi	1$		; no - exit
	lda	#<(0d65535/0d50)
	mul
	std	,--s
	ldb	*tempv2+1
	lda	#>(0d65535/0d50)
	mul
	exg	a,b
	addd	,s++
	sta	dlta$vlt,x
	ldd	*tempv3
	cmpd	#0d255		; valid update change ?
	bhi	1$		; no - exit
	stb	dlta$min,x
	ldd	*tempv4
	cmpd	#0d255		; valid maximum single step voltage change ?
	bhi	1$		; no - exit
	stb	dlta$err,x

1$:	jmp	endgos


	.page
	.sbttl	$r command

.$r:	clr	*format		; set for free format

1$:	jsr	nxtchr		; wait for next

	jsr	$dispatch	; go to service routine
	.byte	'V
	.word	2$		; version select
	.byte	'C
	.word	3$		; copyright select
	.byte	-1
	.word	6$		; end dispatch

2$:	lda	#phs$id		; phs$id version #
	bra	4$

3$:	lda	#phs$cr		; phs$cr version # / copyright 

4$:	sta	*number
	ldx	#cpyrit		; version string
5$:	lda	,x+		; get character
	jsr	plcbuf		; send character
	dec	*number		; more ?
	bgt	5$		; yes - loop
	bra	1$

6$:	suba	#'0		; make bcd
	bcs	7$		; if not - skip
	cmpa	#0d9		; bcd ?
	bhi	7$		; if not - skip
	sta	*format		; save new format
	sec			; character used
	bra	8$
7$:	clc			; character not used
8$:	jmp	endgos		; don't come back


	.page
	.sbttl	$s command

.$s:	jsr	nxtchr		; get character

	jsr	$dispatch
	.byte	'1
	.word	1$
	.byte	'9
	.word	1$
	.byte	-1
	.word	endgos


1$:	clra
	sta	*$schksm	; clear checksum

	lda	#2
	sta	*$scntr		; for rbc
2$:	jsr	nxtchr
	bsr	$sghex		; convert hex to binary
	lbcs	errgos		; note input error
	dec	*$scntr
	bgt	2$
	stb	*$srbc		; save byte count
	addb	*$schksm	; update checksum
	stb	*$schksm

	lda	#4
	sta	*$scntr		; for address
3$:	jsr	nxtchr
	bsr	$sghex		; convert hex to binary
	lbcs	errgos		; note input error
	dec	*$scntr
	bgt	3$
	std	*$sladdr	; save load address
	aba
	adda	*$schksm	; update checksum
	sta	*$schksm
	dec	*$srbc
	dec	*$srbc

4$:	dec	*$srbc		; more data ?
	ble	6$		; no skip to checksum

	lda	#2
	sta	*$scntr		; for data bytes
5$:	jsr	nxtchr
	bsr	$sghex		; convert hex to binary
	lbcs	errgos		; note input error
	dec	*$scntr
	bgt	5$

	ldx	*$sladdr	; load data
	stb	,x+
	stx	*$sladdr	; save address
	addb	*$schksm	; update checksum
	stb	*$schksm
	bra	4$

6$:	lda	#2
	sta	*$scntr		; for checksum byte
7$:	jsr	nxtchr
	bsr	$sghex		; convert hex to binary
	lbcs	errgos		; note input error
	dec	*$scntr
	bgt	7$

	addb	*$schksm	; verify checksum
	incb
	lbeq	endgos		; good data
	lbra	errgos		; note checksum error

	.page
	.sbttl	Input Hex to Binary Conversion

$sghex:	lda	*char		; get character
	suba	#'0		; convert to binary
	bmi	2$		; error - skip
	cmpa	#'9-'0
	blos	1$		; 0-9 skip
	suba	#7
	cmpa	#0d15
	bhi	2$		; error - skip
1$:	pshs	a		; save value
	ldd	*$svalu		; update value
	aslb
	rola
	aslb
	rola
	aslb
	rola
	aslb
	rola
	orb	,s+		; or in new nibble
	std	*$svalu		; save result
	clc
	rts			; good return
2$:	sec
	rts			; error on input


	.page
	.sbttl	.$T -- Test routines

	.area	BUFSAV

acqopt:		.blkb	1	; acquisition options
ledpnl:		.blkb	2	; LED sequencer data
slctchan:	.blkb	1	; selected channel
dacval:		.blkb	2	; DAC value

	.area	PGMSAV

	; Various test routines are here

.$t:	inc	upd$inh		; inhibit acquisition
	jsr	abrt$upd	; abort firq entry

	ldd	#0
	std	ledpnl		; zero number

	jsr	nxtspc		; get character
				; special mode is used
				; so that acquisition always
				; gets re-enabled

	jsr	$dispatch
	.byte	'A	; acquisition (no LED pulsing)
	.word	.$ta
	.byte	'B	; acquisition (with LED pulsing)
	.word	.$tb
	.byte	'C	; ramping DAC and acquisition (no LED pulsing)
	.word	.$tc
	.byte	'D	; ramping DAC and acquisition (with LED pulsing)
	.word	.$td
	.byte	'E	; 16 level DAC and acquisition (with LED pulsing)
	.word	.$te
	.byte	'F	; Selected LED pulsing with acquisition
	.word	.$tf
	.byte	'G	; Selected LED pulsing / DAC amplitude and acquisition
	.word	.$tg
	.byte	'H	; Temperature sensor (no pulsing)
	.word	.$th
	.byte	'I	; Temperature sensor (with pulsing)
	.word	.$ti
	.byte	-1	; exit with re-enable
	.word	.$texit

.$texit:
	ldd	#0		; clear DAC
	jsr	dacseq
	clr	upd$seq		; restart acquisition cleanly
	clr	upd$inh		; now enable acquisition
	rts


	; infinite loop on acquisition sequencer
	; (looping through all selector channels)
	; (no LED pulsing)

.$ta:	lda	#0		; LED pulsing off
	sta	acqopt
	bra	.$tab

	; infinite loop on acquisition sequencer
	; (looping through all selector channels)
	; (with LED pulsing)

.$tb:	lda	#0q200		; LED pulsing on
	sta	acqopt

.$tab:	ldd	ledpnl		; use LED counter
	jsr	acqseq		; do a sequence
	jsr	ledseq
	jsr	tt_inp		; check for escape
	beq	.$tab
	cmpa	#0q33		; 'ESC'
	bne	.$tab
	jmp	.$texit


	; infinite loop on acquisition sequencer
	; (looping through all selector channels)
	; (with ramping dac and no LED pulsing)

.$tc:	lda	#0		; LED pulsing off
	sta	acqopt
	bra	.$tcd

	; infinite loop on acquisition sequencer
	; (looping through all selector channels)
	; (with ramping dac and  LED pulsing)

.$td:	lda	#0q200		; LED pulsing on
	sta	acqopt

.$tcd:
	ldd	#-0d4096
2$:	std	acq$dac		; sequence DAC
	jsr	acqseq		; do sequence
	jsr	ledseq
	addd	#1
	bmi	2$

	ldd	#0d4095
3$:	std	acq$dac		; sequence DAC
	jsr	acqseq		; do sequence
	jsr	ledseq
	subd	#1
	bpl	3$

	jsr	tt_inp		; check for escape
	beq	.$tcd
	cmpa	#0q33		; 'ESC'
	bne	.$tcd
	jmp	.$texit


	; infinite loop on acquisition sequencer
	; (looping through all selector channels)
	; (with 16 level dac and LED pulsing)

.$te:	lda	#0q200		; LED pulsing on
	sta	acqopt

1$:	ldd	ledpnl		; use LED counter
	clra
	asrb
	asrb
	asrb
	asrb
	andb	#0x0F
	exg	a,b
	jsr	dacseq
	ldd	ledpnl
	jsr	acqseq		; do sequence
	jsr	ledseq

	jsr	tt_inp		; check for escape
	beq	1$
	cmpa	#0q33		; 'ESC'
	bne	1$
	jmp	.$texit


	; infinite loop on acquisition sequencer
	; (using specified selector channel)
	; (with 0, 10, 30, and 90 ma. LED pulsing)

.$tf:	sec			; character used
	jsr	nxtgos		; wait for selector channel

	lda	#0q200		; pulsing on
	sta	acqopt

1$:	ldd	ledpnl		; use LED panel counter
	asrb
	asrb
	asrb
	andb	#0x0E
	ldx	#pulse
	ldd	b,x
	jsr	dacseq

	ldb	*number+1	; select LED channel
	jsr	acqseq		; do a sequence
	jsr	ledseq

	jsr	tt_inp		; check for escape
	beq	1$
	cmpa	#0q33		; 'ESC'
	bne	1$
	jmp	.$texit


	; infinite loop on acquisition sequencer
	; (using specified selector channel)
	; (using specified DAC value)

.$tg:	sec			; character used
	jsr	nxtgos		; wait for selector channel
	ldb	*number+1	; save select channel
	stb	slctchan
	jsr	nxtgos		; wait for selector channel
	ldd	*number		; save DAC Value
	std	dacval

	lda	#0q200		; pulsing on
	sta	acqopt

1$:	ldd	dacval		; load DAC value
	jsr	dacseq

	ldb	slctchan	; select LED channel
	jsr	acqseq		; do a sequence
	jsr	ledseq

	jsr	tt_inp		; check for escape
	beq	1$
	cmpa	#0q33		; 'ESC'
	bne	1$
	jmp	.$texit


	; infinite loop on temperature sensor
	; (no pulsing)

.$th:	lda	#0q40
	sta	acqopt
	bra	.$thi

	; infinite loop on temperature sensor
	; (with pulsing)

.$ti:	lda	#0q060
	sta	acqopt

.$thi:	ldd	#0
	jsr	acqseq		; do a sequence
	jsr	ledseq

	jsr	tt_inp		; check for escape
	beq	.$thi
	cmpa	#0q33		; 'ESC'
	bne	.$thi
	jmp	.$texit


acqseq:	pshs	d,x		; save

	andb	#0q037		; mask for select
	orb	acqopt		; enable options
	stb	acq$slct	; start sequence

	lda	#0d24
1$:	deca
	bne	1$

	ldd	acq$adc		; read adc to clear 'firq'

	puls	d,x		; restore
	rts

ledseq:	pshs	d,x		; save

	ldd	ledpnl		; play with the panel LEDs
	addd	#1
	std	ledpnl
	tfr	a,b

	ldx	#sys$led
	anda	#0x1F

	asrb
	asrb
	asrb
	asrb
	asrb
	andb	#0x03
	stb	a,x

	puls	d,x		; restore
	rts

dacseq:	cmpd	acq$dac
	beq	2$
	std	acq$dac

	pshs	x
	ldx	#0d250		; set up for 1 ms. wait
1$:	leax	-1,x
	bne	1$
	puls	x

2$:	rts


	; The DAC is 12-bit (0 - 4095)

pulse:	.word	0d0		; LED drive = 0 ma.
	.word	0d400		; LED drive = 10 ma.
	.word	0d1200		; LED drive = 30 ma.
	.word	0d3600		; LED drive = 90 ma.
	.word	0d3600		; LED drive = 90 ma.
	.word	0d1200		; LED drive = 30 ma.
	.word	0d400		; LED drive = 10 ma.
	.word	0d0		; LED drive = 0 ma.


	.page
	.sbttl	$u command

.$u:	jsr	nxtchr		; wait for next character

	cmpa	#141		; convert lower case to upper case
	bcs	1$
	cmpa	#173
	bcc	1$
	suba	#40
1$:	suba	#'0		; require 0-9 or A-F
	bmi	3$
	cmpa	#'9-'0
	blos	2$
	cmpa	#'A-'0
	blo	3$
	suba	#'A-'0-0d10
	cmpa	#0x0F
	bhi	3$
2$:	ldb	sys$id		; compare with system id
	andb	#0x0F
	cba
	bne	3$
	lda	*rstat0
	ora	#0q200
	sta	*rstat0		; unit enabled
	lda	#0q200
	sta	*scrn$sts	; screen enabled
	clr	*s$state	; redraw screen
	bra	4$
3$:	lda	*rstat0
	anda	#~0q200		; unit disabled
	sta	*rstat0
	lda	#0q000		; screen disabled
	sta	*scrn$sts
4$:	sec			; character used
	jmp	endgos		; don't come back


	.page
	.sbttl	$v command

.$v:	lda	*scrn$sts	; reverse screen flag
	eora	#0q200
	sta	*scrn$sts
	jmp	endgos


	.sbttl	$z command

.$z:
	ldy	#5$

1$:	ldx	,y++
	beq	4$

2$:	lda	,x+
	beq	3$
	jsr	plcbuf		; send character
	bra	2$
3$:	lda	#0q015
	jsr	plcbuf
	lda	#0q012
	jsr	plcbuf
	tst	,x		; end of text ?
	bpl	2$
	bra	1$

4$:	rts

5$:	.word	6$
	.word	phs$int1,	phs$int2,	phs$int3,	0

6$:	.asciz	""
	.asciz	"P.H.S. Internal Routines"
	.byte	0q200

	.end	pwrup


