	.sbttl	HV-Control

	.module	hvctrl

	.include	/area.def/
	.include	/define.def/

	.area	HVCTRL



	; Enqueue a HV command

en$que::
	pshs	cc,d,dp,x,u
	orcc	#0q120			; hold interrupts

	ldd	#port2			; HV port
	tfr	d,u
	tfr	a,dp

	lda	*que$cntr		; elements queued
	cmpa	#0d32
	bhis	1$			; too many - just exit
	leax	que$bufr,u		; buffer address
	lda	*que$inp		; input position
	anda	#0x1F			; mod 32
	asla
	leax	a,x			; que$inp pointer
	ldd	1,s			; new element
	std	,x
	inc	*que$inp		; next position
	inc	*que$cntr		; one more queued

1$:	puls	cc,d,dp,x,u
	rts

	; Dequeue a HV command

de$que::
	pshs	d,cc,dp,u
	orcc	#0q120			; hold interrupts

	ldd	#port2			; HV port
	tfr	d,u
	tfr	a,dp

	inc	*que$oup		; next position
	dec	*que$cntr		; one less element

	puls	d,cc,dp,u
	rts


que$proc::
	pshs	d,dp,x,y,u

	ldd	#port2
	tfr	d,u
	tfr	a,dp

	tst	*que$cntr		; active ?
	beq	5$			; no - skip

	leay	que$bufr,u		; buffer
	lda	*que$oup		; current queue element
	anda	#0x1F
	asla
	leay	a,y			; get queue element address

	ldx	*q$gosub		; active process ?
	beq	1$			; no - skip
	ldd	*que$timr		; check timeout
	subd	#1
	std	*que$timr
	bgt	3$			; proceed with process
	ldd	,y			; get queue element
	ldx	#acqvtbl
	aslb
	leax	[b,x]
	adda	#HVC$ERR		; offset
	sta	hvc$sts,x		; set failure status
	ldx	#q$error		; use error routine
	bra	3$

1$:	ldd	,y			; valid queued function ?
	stb	*que$chnl		; channel number
	cmpb	#0d32			; valid channel ?
	bhi	6$			; no - skip
	tsta				; valid function ?
	beq	6$			; no - skip
	cmpa	#QUE$FNCT		; valid function ?
	bhi	6$			; no - skip
	asla
	asla
	ldx	#que$disp		; initial function dispatch
	leax	a,x

	ldd	2,x			; setup timeout counter
	std	*que$timr
	leax	[,x]			; function address

2$:	bsr	que$scan		; scan for HV4032A
	bne	2$			; failing channel report

3$:	jsr	,x			; dispatch to the function

4$:	puls	d,dp,x,y,u
	rts

5$:	bsr	que$scan		; scan for HV4032A
	bne	5$			; failing channel report
	puls	d,dp,x,y,u
	rts

6$:	jsr	de$que			; dump this queue element
	puls	d,dp,x,y,u
	rts

que$scan:
	pshs	b,x
	jsr	tt_inp			; have an unsolicited char ?
	beq	3$			; no - skip
	ldb	*hvc$fseq		; go to current sequencer state
	aslb
	cmpb	#5$-4$
	bhis	2$
	ldx	#4$
	jsr	[b,x]
	inc	*hvc$fseq		; next sequence
	bra	3$

1$:	leas	2,s			; pop return
2$:	clr	*hvc$fseq		; restart
3$:	puls	b,x
	lda	*char
	rts

4$:	.word	5$,6$,7$,8$,9$

5$:	cmpa	#'*			; the channel failure status
	bne	1$			; is of the form *CHxx
	rts

6$:	cmpa	#'C
	bne	1$
	rts

7$:	cmpa	#'H
	bne	1$
	rts

8$:	cmpa	#'0			; tens digit
	blo	1$
	cmpa	#'9
	bhi	1$
	suba	#'0
	asla
	sta	,-s
	asla
	asla
	adda	,s+
	sta	*hvc$fchn
	rts

9$:	cmpa	#'0			; ones digit
	blo	1$
	cmpa	#'9
	bhi	1$
	suba	#'0
	adda	*hvc$fchn
	sta	*hvc$fchn
	cmpa	#0d31			; verify a valid channel
	bhi	1$
	asla
	ldx	#acqvtbl
	leax	[a,x]
	lda	#$HVFAIL		; set FAIL status
	sta	hv$sts,x
	ldd	#0
	std	hv$volt,x		; voltage = 0

	lda	acq$sts,x
	beq	1$
	ora	#$HOLD			; implicit HOLD
	sta	acq$sts,x
	bra	1$


q$nxtgos:
	ldx	,s++			; next entry
	stx	*q$gosub
	rts				; finished

q$deque:
	jsr	de$que			; finished

q$endgos:
	ldx	#0			; no entry
	stx	*q$gosub
	rts				; finished

q$error:
	ldd	#0d1200			; 10 second timeout
	std	*que$timr
	jsr	q$nxtgos
	lda	#0q015			; try a CR
	jsr	tt_out

	ldd	#0d240			; set wait timer
	std	*que$wait		; for a 2 second wait
	jsr	q$nxtgos
	jsr	tt_inp			; wait for '>
	cmpa	#'>
	beq	1$			; ok - have a response
	jsr	wait$seq		; wait que$wait ticks

	lda	#0q015			; try another CR
	jsr	tt_out

	ldd	#0d240			; set wait timer
	std	*que$wait		; for a 2 second wait
	jsr	q$nxtgos
	jsr	tt_inp			; wait for '>
	cmpa	#'>
	beq	1$			; ok - have a response
	jsr	wait$seq		; wait que$wait ticks

	ldx	#2$			; try a selection
	stx	*hvc$pntr
	jsr	wrt$strng
	bra	q$error			; and try again for a completion

1$:	ldd	#0d120			; set wait timer
	std	*que$wait		; for a 1 second wait
	jsr	q$nxtgos
	jsr	wait$seq		; wait que$wait ticks
	jsr	tt_inp			; input buffer must be empty
	bne	q$error			; else - loop
	ldd	#0			; retry aborted process
	std	*que$timr		; clear timer
	std	*q$gosub		; kill error process
	rts

2$:	.asciz	"M16"			; unit selection


	QUE$FNCT  =  0d11		; number of functions

que$disp::
	;	function	timeout
	;	--------	-------
	.word	q$endgos,	0d0	; invalid function	0
	.word	fM16F,		0d1200	; HV-Off		1
	.word	fM16N,		0d1200	; HV-On			2
	.word	fM16S,		0d1800	; HV-Status		3
	.word	fM16D,		0d1800	; Demand Voltages	4
	.word	fM16V,		0d1800	; Voltage Readings	5
	.word	fM16CxxG,	0d600	; Get Channel Voltage	6
	.word	fM16CxxS,	0d600	; Set Channel Voltage	7
	.word	fM16CxxZ,	0d600	; Zero Channel		8
	.word	fM16CxxR,	0d600	; Restore Channel	9
	.word	fM16UPDT,	0d600	; Update Sequence	10
	.word	fM16WAIT,	0x7FFF	; Wait			11


fM16F:
	ldx	#acqvar
	ldb	#0d32			; check all acq$sts's
1$:	lda	acq$sts,x
	beq	2$
	ora	#$HOLD			; place on HOLD
	sta	acq$sts,x
2$:	leax	ACQVARSZ,x
	decb
	bgt	1$

	ldd	#0d120			; set wait timer
	std	*que$wait		; for a 1 second wait
	addd	*que$timr		; update timeout counter
	std	*que$timr

	jsr	q$nxtgos		; wait que$wait ticks to allow
	jsr	wait$seq		; completion of any acq updates

	jsr	wrt$cmd			; send command
	jmp	fM16$end


fM16N:
	ldx	#acqvar
	ldb	#0d32			; check all acq$sts's
1$:	lda	acq$sts,x
	beq	2$
	ora	#$HOLD			; place on HOLD
	sta	acq$sts,x
2$:	leax	ACQVARSZ,x
	decb
	bgt	1$

	jsr	wrt$cmd			; send command
	jmp	fM16$end


fM16S:
	jsr	wrt$cmd			; send command
	jsr	q$nxtgos

	pshs	b,x
	jsr	tt_inp			; have a cahr ?
	beq	3$			; no - skip
	ldb	*hvc$sseq		; go to current sequencer state
	aslb
	cmpb	#5$-4$
	bhis	2$
	ldx	#4$
	jsr	[b,x]
	inc	*hvc$sseq		; next sequence
	bra	3$

1$:	leas	2,s			; pop return
2$:	clr	*hvc$sseq		; restart
3$:	puls	b,x
	rts

4$:	.word	5$,6$,7$,8$		; CHxx
	.word	10$,11$,12$,13$		; HV ON / HV OFF

5$:	cmpa	#'H			; the status is of the
	beq	9$			; form 'HV ON' or 'HV OFF'

	cmpa	#'C			; channel failure is of
	bne	1$			; the form CHxx
	rts

6$:	cmpa	#'H
	bne	1$
	rts

7$:	cmpa	#'0			; tens digit
	blo	1$
	cmpa	#'9
	bhi	1$
	suba	#'0
	asla
	sta	,-s
	asla
	asla
	adda	,s+
	sta	*hvc$fchn
	rts

8$:	cmpa	#'0			; ones digit
	blo	1$
	cmpa	#'9
	bhi	1$
	suba	#'0
	adda	*hvc$fchn
	sta	*hvc$fchn
	cmpa	#0d31			; verify a valid channel
	bhi	1$
	asla
	ldx	#acqvtbl
	leax	[a,x]
	lda	#$HVFAIL		; set FAIL status
	sta	hv$sts,x
	bra	1$

9$:	lda	#4-1
	sta	*hvc$sseq		; this sequence next
	rts

10$:	cmpa	#'V
	bne	1$
	rts

11$:	cmpa	#(' )
	bne	1$
	rts

12$:	cmpa	#'O
	bne	1$
	rts

13$:	cmpa	#'N			; ON ?
	bne	14$
	lda	#$HVON
	bra	16$

14$:	cmpa	#'F			; OFF ?
	bne	15$
	lda	#$HVOFF
	bra	16$

15$:	clra				; unknown state

16$:	ldx	#tmpvar
	sta	hv$sts,x
	jmp	fM16$end


fM16D:
	jsr	wrt$cmd			; send command

	clr	*que$chnl		; clear loop counter/channel

	; skip lines from HV4032A

	jsr	skp$line		; skip line
	jsr	skp$line		; skip line

	; skip channel specification

1$:	jsr	skp$line		; skip line

	jsr	skp$spcs		; skip any leading spaces
	jsr	skp$char		; skip to spaces

	; 8 channels per line

2$:	jsr	skp$spcs		; skip any leading spaces
	jsr	vltg$scn		; scan for voltage
	lbvs	fM16$err		; invalid string
	pshs	d
	ldx	#acqvtbl		; variables
	ldb	*que$chnl		; current channel
	aslb
	leax	[b,x]
	puls	d
	std	hv$dmnd,x		; demand voltage

	inc	*que$chnl
	lda	*que$chnl
	anda	#0x07			; 8 values per line
	bne	2$

	lda	*que$chnl
	cmpa	#0d32
	blo	1$

	jmp	fM16$end		; finished


fM16V:
	jsr	wrt$cmd			; send command

	clr	*que$chnl		; clear loop counter/channel

	; skip line from HV4032A

	jsr	skp$line		; skip line
	jsr	skp$line		; skip line

	; skip channel specification

1$:	jsr	skp$line		; skip line

	jsr	skp$spcs		; skip any leading spaces
	jsr	skp$char		; skip to spaces

	; 8 channels per line

2$:	jsr	skp$spcs		; skip any leading spaces
	jsr	vltg$scn		; scan for voltage
	lbvs	fM16$err		; invalid string
	pshs	d
	ldx	#acqvtbl		; variables
	ldb	*que$chnl
	aslb
	leax	[b,x]
	puls	d
	std	hv$volt,x		; current voltage

	cmpd	#0d75			; Check on or off
	blo	3$
	lda	#$HVON
	bra	4$
3$:	lda	#$HVOFF
4$:	sta	hv$sts,x		; load status

	inc	*que$chnl
	lda	*que$chnl
	anda	#0x07			; 8 values per line
	bne	2$

	lda	*que$chnl
	cmpa	#0d32
	blo	1$

	jmp	fM16$end		; finished


fM16CxxG:
	jsr	wrt$cmd			; send command
	jsr	csts$scn		; check for ZERO/FAIL
	jsr	skp$line		; skip line
	jsr	skp$spcs		; skip any leading spaces
	jsr	vltg$scn		; scan for voltage
	lbvs	fM16$err		; invalid string
	lbcs	fM16$fin		; ZERO / FAIL
	pshs	d
	ldx	#acqvtbl		; variables
	ldb	*que$chnl
	aslb
	leax	[b,x]

	lda	*hvc$csts		; ZERO / FAIL ?
	beq	4$			; no - skip
	cmpa	#'Z			; ZERO ?
	bne	1$
	lda	#$HVZERO
	bra	2$

1$:	cmpa	#'F			; FAIL ?
	bne	4$
	lda	#$HVFAIL

2$:	sta	hv$sts,x
	ldd	#0
	std	hv$volt,x		; voltage = 0
	puls	d			; pop the read demand voltage
	lda	acq$sts,x
	beq	3$
	ora	#$HOLD			; implicit HOLD
	sta	acq$sts,x
3$:	jmp	fM16$fin		; do completion

4$:	puls	d
	std	hv$volt,x		; current voltage
	cmpd	#0d75			; Check on or off
	blo	5$
	lda	#$HVON
	bra	6$
5$:	lda	#$HVOFF
6$:	sta	hv$sts,x		; load status
	jmp	fM16$fin		; do completion


fM16CxxS:
	ldx	#acqvtbl		; pointer to variables
	ldb	*que$chnl
	aslb
	leax	[b,x]
	lda	acq$sts,x
	beq	1$
	ora	#$HOLD			; implicit HOLD
	sta	acq$sts,x

	ldd	#0d120			; set wait timer
	std	*que$wait		; for a 1 second wait
	addd	*que$timr		; update timeout counter
	std	*que$timr

	jsr	q$nxtgos		; wait que$wait ticks to allow
	jsr	wait$seq		; completion of any acq updates

1$:	jsr	wrt$cmd			; send command
	jsr	skp$line		; skip line
	jsr	skp$spcs		; skip any leading spaces
	jsr	vltg$scn		; scan for voltage
	lbvs	fM16$err		; invalid string
	lbcs	fM16$fin		; ZERO / FAIL
	ldx	#acqvtbl		; variables
	ldd	,y
	aslb
	leax	[b,x]
	ldd	hv$setv,x		; new set voltage
	std	hv$dmnd,x
	jsr	wrt$vltg
	jmp	fM16$end


fM16CxxZ:
	ldx	#acqvtbl		; pointer to variables
	ldb	*que$chnl
	aslb
	leax	[b,x]
	lda	acq$sts,x
	beq	1$
	ora	#$HOLD			; implicit HOLD
	sta	acq$sts,x

	ldd	#0d120			; set wait timer
	std	*que$wait		; for a 1 second wait
	addd	*que$timr		; update timeout counter
	std	*que$timr

	jsr	q$nxtgos		; wait que$wait ticks to allow
	jsr	wait$seq		; completion of any acq updates

1$:	jsr	wrt$cmd			; send command
	jsr	cmd$end			; check for completion
	lda	#$HVZERO		; voltage zeroed
	sta	hv$sts,x
	jmp	q$deque			; finished here


fM16CxxR:
	ldx	#acqvtbl		; pointer to variables
	ldb	*que$chnl
	aslb
	leax	[b,x]
	lda	acq$sts,x
	beq	1$
	ora	#$HOLD			; implicit HOLD
	sta	acq$sts,x

1$:	jsr	wrt$cmd			; send command
	jsr	cmd$end			; check for completion
	lda	#$HVON			; voltage on
	sta	hv$sts,x
	jmp	q$deque			; finished here


fM16UPDT:
	jsr	wrt$cmd			; send command
	jsr	skp$line		; skip line
	jsr	skp$spcs		; skip any leading spaces
	jsr	vltg$scn		; scan for voltage (discard)
	lbvs	fM16$err		; invalid string
	lbcs	fM16$fin		; ZERO / FAIL
	ldx	#acqvtbl		; variables
	ldb	*que$chnl
	aslb
	leax	[b,x]
	ldd	hv$volt,x		; get voltage
	addd	hv$chng,x		; change required
	std	hv$dmnd,x		; new demand value
	jsr	wrt$vltg
	jmp	fM16$end


fM16WAIT:
	ldd	#0d240			; set wait timer
	std	*que$wait		; for a 2 second wait
	jsr	q$nxtgos
	jsr	wait$seq
	jmp	q$deque


fM16$fin:
	jsr	q$nxtgos
	lda	#0q015			; terminate the command
	jsr	tt_out

fM16$end:
	jsr	cmd$end			; check for completion
	jmp	q$deque			; finished here


fM16$err:
	jsr	q$nxtgos
	lda	#0q015			; terminate the command
	jsr	tt_out
	jsr	cmd$end
	jmp	q$endgos		; retry same command


wait$seq:
	ldd	*que$wait		; update wait counter
	subd	#1
	bgt	1$
	ldd	#0
1$:	std	*que$wait
	beq	2$
	leas	2,s			; pop return
2$:	rts


wrt$cmd:
	ldd	,y			; get queue element
	ldx	#acqvtbl
	aslb
	leax	[b,x]
	sta	hvc$sts,x		; updating note

	ldx	#hv$cmnd
	asla
	leax	[a,x]			; address of command string
	leau	hvc$strng,u		; buffer address
	stu	*hvc$pntr

1$:	lda	,x+
	sta	,u+
	bgt	1$
	beq	2$
	leau	-1,u			; backup pointer

	; Insert Channel Number

	pshs	x
	leas	-4,s			; temporary area
	tfr	s,x
	ldb	*que$chnl		; channel number
	jsr	i$b$d
	ldd	1,s			; last two digits
	std	,u++
	leas	4,s
	puls	x
	bra	1$			; go complete sequence

2$:	ldu	*lclstk			; restore user stack pointer

wrt$strng:
	ldx	,s++			; save return address
	stx	*hvc$gosub

1$:	jsr	q$nxtgos
	ldx	*hvc$pntr
	lda	,x+
	stx	*hvc$pntr
	sta	*hvc$char		; save character
	ble	3$
	jsr	tt_out			; send character
	jsr	q$nxtgos
	jsr	tt_inp			; wait for echo of character
	beq	2$			; none - exit
	cmpa	*hvc$char		; skip all other characters
	beq	1$
2$:	rts

3$:	blt	4$
	lda	#0q015			; terminate with CR
	jsr	tt_out

4$:	jmp	[hvc$gosub,u]		; return inline
	

wrt$vltg:
	std	,--s
	ldd	,s++
	bpl	1$
	ldd	#0			; minimum voltage
1$:	cmpd	#0d3000
	blos	2$
	ldd	#0d3000			; maximum voltage
2$:	jsr	vltg$sav		; save update voltage / time
	leax	hvc$strng,u		; use this buffer
	leax	1,x
	stx	*hvc$pntr		; last 4 digits
	leax	-1,x
	jsr	i$w$d			; convert to string
	clr	,x			; terminate string
	bra	wrt$strng


cmd$end:
	ldd	,s++
	std	*hvc$gosub		; save return

1$:	jsr	tt_inp			; any input from HV ?
	beq	2$			; no - skip
	cmpa	#'>			; command finished ?
	beq	3$			; yes - skip
2$:	jsr	q$nxtgos
	bra	1$

3$:	ldx	#acqvtbl		; pointer to variables
	ldb	*que$chnl
	aslb
	leax	[b,x]
	clr	hvc$sts,x		; clear status

	jmp	[hvc$gosub,u]		; return in line



	.page
	.sbttl	TT_INP Scanning Functions

skp$line:
	ldd	,s++
	std	*hvc$gosub		; save return

1$:	lda	*char			; a character ?
	bne	2$			; yes process it
	jsr	tt_inp			; else try to get one
	beq	3$			; none - skip
2$:	cmpa	#(' )			; scan until a CR / LF
	blo	4$
	clr	*char			; clear the character
3$:	jsr	q$nxtgos
	bra	1$

4$:	lda	*char			; a character ?
	bne	5$			; yes process it
	jsr	tt_inp			; else try to get one
	beq	6$			; none - skip
5$:	cmpa	#(' )			; scan until past CR / LF
	bhis	7$
	clr	*char			; clear the character
6$:	jsr	q$nxtgos
	bra	4$

7$:	jmp	[hvc$gosub,u]		; return in line


skp$spcs:
	ldd	,s++
	std	*hvc$gosub		; save return

1$:	lda	*char			; a character ?
	bne	2$			; yes process it
	jsr	tt_inp			; else try to get one
	beq	3$			; none - skip
2$:	cmpa	#(' )			; scan until past spaces
	bne	4$
	clr	*char			; clear the character
3$:	jsr	q$nxtgos
	bra	1$

4$:	jmp	[hvc$gosub,u]		; return in line


skp$char:
	ldd	,s++
	std	*hvc$gosub		; save return

1$:	lda	*char			; a character ?
	bne	2$			; yes process it
	jsr	tt_inp			; else try to get one
	beq	3$			; none - skip
2$:	cmpa	#(' )			; scan until past characters
	blos	4$			; space or CR / LF terminates scan
3$:	clr	*char			; clear the character
	jsr	q$nxtgos
	bra	1$

4$:	jmp	[hvc$gosub,u]		; return in line


csts$scn:
	ldd	,s++
	std	*hvc$gosub		; save return
	clr	*hvc$csts		; clear readout status

1$:	lda	*char			; a character ?
	bne	2$			; yes process it
	jsr	tt_inp			; else try to get one
	beq	4$			; none - skip
2$:	cmpa	#(' )			; scan until past characters
	blo	5$			; CR / LF terminates scan
	cmpa	#'Z			; Zeroed channel ?
	beq	3$
	cmpa	#'F			; Failed channel ?
	bne	4$
3$:	sta	*hvc$csts		; save csts
4$:	clr	*char			; clear the character
	jsr	q$nxtgos
	bra	1$

5$:	jmp	[hvc$gosub,u]		; return in line


	; Scan string for ZERO / FAIL / voltage string
	;
	;	return - 'C' set if ZERO / FAIL
	;	return - 'V' set if not a voltage
	;	return - 'C' and 'V' clear if a voltage string
	;
	;	return - voltage in d

vltg$scn:
	ldd	,s++
	std	*hvc$gosub		; save return
	clr	*hvc$cntr		; clear counter

1$:	lda	*char			; a character ?
	bne	2$			; yes process it
	jsr	tt_inp			; else try to get one
	beq	4$			; none - skip
2$:	cmpa	#(' )
	bhi	3$			; space or CR / LF terminates scan
	clra
3$:	leax	hvc$strng,u		; buffer
	ldb	*hvc$cntr		; position
	sta	b,x			; '0' is end of scan
	beq	5$
	cmpb	#4			; no more than 4 digits
	bhis	4$
	inc	*hvc$cntr		; update position
4$:	clr	*char			; clear the character
	jsr	q$nxtgos
	bra	1$

5$:	ldx	#acqvtbl		; pointer to variables
	ldb	*que$chnl
	aslb
	leax	[b,x]
	
	pshs	x,y
6$:	leax	hvc$strng,u		; buffer
	ldy	#16$			; ZERO ?
	ldb	#4			; position
7$:	lda	,x+
	cmpa	,y+
	bne	8$
	decb
	bgt	7$

	puls	x,y
	lda	#$HVZERO		; ZERO -> Zero
	bra	10$

8$:	leax	hvc$strng,u		; buffer
	ldy	#17$			; FAIL ?
	ldb	#4			; position
9$:	lda	,x+
	cmpa	,y+
	bne	12$
	decb
	bgt	9$

	puls	x,y
	lda	#$HVFAIL		; FAIL -> Fail

10$:	sta	hv$sts,x
	lda	acq$sts,x
	beq	11$
	ora	#$HOLD			; implicit HOLD
	sta	acq$sts,x

11$:	clra				; ZERO / FAIL
	clrb
	sec
	jmp	[hvc$gosub,u]		; return in line

12$:	leax	hvc$strng,u		; buffer
13$:	lda	,x+
	beq	14$
	cmpa	#'0
	blo	15$
	cmpa	#'9
	bhi	15$
	bra	13$

14$:	leax	hvc$strng,u		; buffer
	jsr	a$d$i			; convert to integer
	puls	x,y
	clc				; a voltage
	clv
	jmp	[hvc$gosub,u]		; return in line

15$:	puls	x,y
	clra				; not a voltage
	clrb
	sev
	jmp	[hvc$gosub,u]		; return in line
	

16$:	.asciz	"ZERO"
17$:	.asciz	"FAIL"


	; Save the voltage update and current time in the
	; acquisition array for this channel.

vltg$sav:
	pshs	d,x

	lda	*que$chnl		; channel
	asla
	ldx	#acqvtbl		; variables this channel
	leax	[a,x]
	ldb	hv$index,x		; current index
	pshs	b			; save
	incb
	andb	#0x3F			; mod 64
	stb	hv$index,x		; next index
	ldx	#acqbtbl		; buffers this channel
	leax	[a,x]
	puls	b			; array index
	aslb
	leax	b,x			; offset into buffer
	ldd	,s			; high voltage
	std	acq$vltg,x
	lda	days			; compute time
	ldb	#0d5			; 1440. * days
	mul				; days <= 44.
	exg	a,b
	std	,--s
	lda	days
	ldb	#0d160
	mul
	addd	,s
	std	,s
	lda	hours
	ldb	#0d60			; 60. * hours
	mul
	addd	,s++
	addb	minutes
	adca	#0
	std	acq$time,x		; current time

	puls	d,x
	rts


hv$cmnd:
	.word	1$,2$,3$,4$,5$,6$,7$,8$,9$,10$,11$,12$

1$:	.asciz	""			; not a command
2$:	.asciz	"M16F"			; HV-OFF
3$:	.asciz	"M16N"			; HV-ON
4$:	.asciz	"M16S"			; Status
5$:	.asciz	"M16D"			; Demand settings
6$:	.asciz	"M16V"			; Voltage readings
7$:	.ascii	"M16C"			; Get voltage
	.byte	0q200
	.asciz	""
8$:	.ascii	"M16C"			; Set voltage
	.byte	0q200
	.asciz	""
9$:	.ascii	"M16C"			; Zero voltage
	.byte	0q200
	.asciz	"Z"
10$:	.ascii	"M16C"			; Restore voltage
	.byte	0q200
	.asciz	"R"
11$:	.ascii	"M16C"			; Update voltage
	.byte	0q200
	.asciz	""
12$:	.asciz	""			; not a command


hvc$optn::
	.word	1$,2$,3$,4$,5$,6$,7$,8$,9$,10$,11$,12$
	.word	13$,14$,15$,16$,17$,18$,19$,20$,21$,22$,23$,24$

1$:	.asciz	"                         "	; ok
2$:	.asciz	" Sending HV-OFF Command  "	; HV-OFF
3$:	.asciz	" Sending HV-ON Command   "	; HV-ON
4$:	.asciz	"   Reading HV-Status     "	; Status
5$:	.asciz	"  Reading Demand Values  "	; Demand settings
6$:	.asciz	" Reading Voltage Levels  "	; Voltage readings
7$:	.asciz	" Reading Channel Voltage "	; Get voltage
8$:	.asciz	" Setting Channel Voltage "	; Set voltage
9$:	.asciz	"     Zeroing Channel     "	; Zero voltage
10$:	.asciz	"    Restoring Channel    "	; Restore voltage
11$:	.asciz	" P.H.S. Updating Channel "	; PHS Updating
12$:	.asciz	"                         "	; Wait

	HVC$ERR	= 0d12				; error offset

13$:	.asciz	"                         "	; ok
14$:	.asciz	"     HV-OFF  Failed      "	; HV-OFF
15$:	.asciz	"     HV-ON  Failed       "	; HV-ON
16$:	.asciz	"    HV-Status Failed     "	; Status
17$:	.asciz	"  Demand Readout Failed  "	; Demand settings
18$:	.asciz	" Voltage Readout Failed  "	; Voltage readings
19$:	.asciz	"   Read Voltage Failed   "	; Get voltage
20$:	.asciz	"   Set Voltage Failed    "	; Set voltage
21$:	.asciz	"      Zero Failed        "	; Zero voltage
22$:	.asciz	"     Restore Failed      "	; Restore voltage
23$:	.asciz	" P.H.S. Updating Failed  "	; PHS Updating
24$:	.asciz	"                         "	; Wait

