	.sbttl	Acquisition Module

	.module	acq

	.include	/area.def/
	.include	/define.def/


	.area	ACQVARBL (ABS,OVR)

	;  This area contains the variable definitions for the
	; each of the channels in the acquisition module.

	.org	0x0000
acq$sum::	.blkb	2		; sum of acq$avrg array
acq$index::	.blkb	1		; index into acq$avrg
acq$sts::	.blkb	1		; acquisition status

phs$avrg::	.blkb	2		; pulse height average of last scan

phs$index::	.blkb	1		; pulse height array index
phs$hofs::	.blkb	2		; pulse height horizontal offset
phs$hscl::	.blkb	1		; pulse height horizontal scale
phs$vofs::	.blkb	2		; pulse height vertical offset
phs$vscl::	.blkb	1		; pulse height vertical scale
					; bit	<7>	non auto scaling
					; bits	<3:0>	scale factor

avg$vofs::	.blkb	2		; averaging vertical offset
avg$vscl::	.blkb	1		; averaging vertical scale
					; bit	<7>	non auto scaling
					; bits	<3:0>	scale factor

run$index::	.blkb	1		; running array index

tmp$flag::	.blkb	1		; temperature active flag

hv$sts::	.blkb	1		; high voltage status
hvc$sts::	.blkb	1		; high voltage command status
					; The temperature channel high voltage
					; status is for Power ON / OFF

	TMPVARSZ  = . - acq$sum		; size of temperature variable segment

hv$index::	.blkb	1		; high voltage array index
hv$vofs::	.blkb	2		; high voltage vertical offset
hv$vscl::	.blkb	1		; high voltage vertical scale
					; bit	<7>	non auto scaling
					; bits	<3:0>	scale factor
hv$dmnd::	.blkb	2		; HV4032A high voltage demand
hv$volt::	.blkb	2		; HV4032A high voltage reading
hv$setv::	.blkb	2		; PHS HV-SET value

dlta$min::	.blkb	1		; Minimum voltage change
dlta$err::	.blkb	1		; Error voltage change
dlta$vlt::	.blkb	1		; Voltage change per %

hv$chng::	.blkb	2		; Updating HV-Change
hv$qued::	.blkb	1		; Updating queue flag

phs$lpht::	.blkb	2		; Pulse Height Calibration
cal$lpht::	.blkb	2		; LED Calibration amplitude
tmp$lpht::	.blkb	2		; LED Calibration Temperature
cor$lpht::	.blkb	2		; Corrected LED amplitude

	ACQVARSZ  = . - acq$sum		; size of acquisition variable segment


	.page
	.area	ACQBUFR (ABS,OVR)

	;  This area contains the buffer definitions for the
	; acquisition module.

	.org	0x0000

acq$phs::	.blkw	0d64		; pulse height spectrum
acq$avrg::	.blkw	0d64		; averaged pulse height responses

	TMPBUFSZ  = . - acq$phs		; size of temperature segment

acq$vltg::	.blkw	0d64		; HV4032A voltage levels
acq$time::	.blkw	0d64		; time of update (1 minute increments)

	ACQBUFSZ  = . - acq$phs		; size of acquisition segment


	.area	ACQDATA (REL,CON)

upd$inh::	.blkb	1		; acquisition inhibited flag
upd$seq::	.blkb	1		; sequence state
upd$chn::	.blkb	1		; updating channel
upd$cntr::	.blkb	1		; updating counter
upd$bufp::	.blkb	2		; current buffer pointer
upd$varp::	.blkb	2		; current variable pointer
upd$back::	.blkb	2		; background data
upd$smpl::	.blkb	2		; sample data
upd$sum::	.blkb	2		; sum of (sample - background)
upd$sque::	.blkb	2		; status queue
upd$temp::	.blkb	1		; temperature updated flag
svd$flg::	.blkb	1		; saved channel flag
svd$chn::	.blkb	1		; saved channel
dac$bit::	.blkb	2		; calibration bit
tictoc::	.blkb	1		; LED updating ticker

divcnt::	.blkb	1		;division bit counter
dsign::		.blkb	1		;dividend sign
dnd::		.blkb	2		;dividend
dsr::		.blkb	2		;divisor
qt::		.blkb	1		;quotient


acqbufr::
		.blkb	ACQBUFSZ * 0d32	; allocation for acquisition buffers
acqvar::
		.blkb	ACQVARSZ * 0d32	; allocation for acquisition variables


	.page
	.area	ACQ (REL,CON)

	;  This module contains the acquisition code used to
	; acquire data from the LED pulsed scintillators.

	;  Table of acquisition pointers

acqbtbl::
	.word	acqbufr + (ACQBUFSZ * 0d0)
	.word	acqbufr + (ACQBUFSZ * 0d1)
	.word	acqbufr + (ACQBUFSZ * 0d2)
	.word	acqbufr + (ACQBUFSZ * 0d3)
	.word	acqbufr + (ACQBUFSZ * 0d4)
	.word	acqbufr + (ACQBUFSZ * 0d5)
	.word	acqbufr + (ACQBUFSZ * 0d6)
	.word	acqbufr + (ACQBUFSZ * 0d7)
	.word	acqbufr + (ACQBUFSZ * 0d8)
	.word	acqbufr + (ACQBUFSZ * 0d9)
	.word	acqbufr + (ACQBUFSZ * 0d10)
	.word	acqbufr + (ACQBUFSZ * 0d11)
	.word	acqbufr + (ACQBUFSZ * 0d12)
	.word	acqbufr + (ACQBUFSZ * 0d13)
	.word	acqbufr + (ACQBUFSZ * 0d14)
	.word	acqbufr + (ACQBUFSZ * 0d15)
	.word	acqbufr + (ACQBUFSZ * 0d16)
	.word	acqbufr + (ACQBUFSZ * 0d17)
	.word	acqbufr + (ACQBUFSZ * 0d18)
	.word	acqbufr + (ACQBUFSZ * 0d19)
	.word	acqbufr + (ACQBUFSZ * 0d20)
	.word	acqbufr + (ACQBUFSZ * 0d21)
	.word	acqbufr + (ACQBUFSZ * 0d22)
	.word	acqbufr + (ACQBUFSZ * 0d23)
	.word	acqbufr + (ACQBUFSZ * 0d24)
	.word	acqbufr + (ACQBUFSZ * 0d25)
	.word	acqbufr + (ACQBUFSZ * 0d26)
	.word	acqbufr + (ACQBUFSZ * 0d27)
	.word	acqbufr + (ACQBUFSZ * 0d28)
	.word	acqbufr + (ACQBUFSZ * 0d29)
	.word	acqbufr + (ACQBUFSZ * 0d30)
	.word	acqbufr + (ACQBUFSZ * 0d31)
	.word	tmpbufr

	.page
acqvtbl::
	.word	acqvar + (ACQVARSZ * 0d0)
	.word	acqvar + (ACQVARSZ * 0d1)
	.word	acqvar + (ACQVARSZ * 0d2)
	.word	acqvar + (ACQVARSZ * 0d3)
	.word	acqvar + (ACQVARSZ * 0d4)
	.word	acqvar + (ACQVARSZ * 0d5)
	.word	acqvar + (ACQVARSZ * 0d6)
	.word	acqvar + (ACQVARSZ * 0d7)
	.word	acqvar + (ACQVARSZ * 0d8)
	.word	acqvar + (ACQVARSZ * 0d9)
	.word	acqvar + (ACQVARSZ * 0d10)
	.word	acqvar + (ACQVARSZ * 0d11)
	.word	acqvar + (ACQVARSZ * 0d12)
	.word	acqvar + (ACQVARSZ * 0d13)
	.word	acqvar + (ACQVARSZ * 0d14)
	.word	acqvar + (ACQVARSZ * 0d15)
	.word	acqvar + (ACQVARSZ * 0d16)
	.word	acqvar + (ACQVARSZ * 0d17)
	.word	acqvar + (ACQVARSZ * 0d18)
	.word	acqvar + (ACQVARSZ * 0d19)
	.word	acqvar + (ACQVARSZ * 0d20)
	.word	acqvar + (ACQVARSZ * 0d21)
	.word	acqvar + (ACQVARSZ * 0d22)
	.word	acqvar + (ACQVARSZ * 0d23)
	.word	acqvar + (ACQVARSZ * 0d24)
	.word	acqvar + (ACQVARSZ * 0d25)
	.word	acqvar + (ACQVARSZ * 0d26)
	.word	acqvar + (ACQVARSZ * 0d27)
	.word	acqvar + (ACQVARSZ * 0d28)
	.word	acqvar + (ACQVARSZ * 0d29)
	.word	acqvar + (ACQVARSZ * 0d30)
	.word	acqvar + (ACQVARSZ * 0d31)
	.word	tmpvar

	.page
	.sbttl	Change and Read Acquisition Status

	;  chng$sts
	;
	;   The change status routine waits for the acquisition
	;  routine to complete any pending update before loading
	;  the change queue.
	;
	;  wait$sts
	;
	;   The wait status routine waits for the aqcuisition routine
	;  to emtpy the update queue.
	;
	;  rd$sts
	;
	;   The read status routine returns the specified acquisition
	;  channels status.
	;
	
	;  a	-	channel number to change status
	;  b	-	channel status
	;	bit 0	initiate single scan / scanning
	;	bit 1	channel failed
	;	bit 2	channel on hold
	;	bit 3	channel active
	;
	;	bit 7	internal flag

chng$sts::
	pshs	d
1$:	pshs	cc		; save condition codes
	orcc	#0q120		; hold interrupts
	ldd	upd$sque	; check queued request
	beq	2$		; none - ok
	puls	cc		; else wait
	bra	1$

2$:	ldd	1,s
	orb	#0q200		; flag it
	std	upd$sque	; load update status queue
	puls	cc		; restore cc's
	puls	d
	rts

wait$sts::
	pshs	d
1$:	ldd	upd$sque	; wait for queue to empty
	bne	1$
	puls	d
	rts

rd$sts::
	pshs	a,x
	cmpa	#0d32		; check channel
	blos	1$		; ok - skip
	clrb			; invalid channel #
	bra	2$

1$:	asla			; make index
	ldx	#acqvtbl	; table of variable pointers
	leax	[a,x]		; get current channel variable base
	ldb	acq$sts,x	; get the current status
2$:	puls	a,x
	rts


	.page
	.sbttl	phs$set - LED Pulse Height Set

	;
	;  a	-	Channel to Calibrate
	;  x	-	LED DAC set value
	;
	;  Sequence:	Same as phs$cal except steps 2 & 3 replaced
	;		with DAC set value.
	;
	;	Note:	This sequence never fails.
	;

phs$set::

	;	1	Stop acquisition on this channel.

	pshs	b
	ldb	#$STOP		; DAC set must stop any acquisition
	jsr	chng$sts	; stop acquisition on this channel
	jsr	wait$sts	; wait for status queue to empty
	puls	b

	pshs	d,x,y
	pshs	a		; save channel number
	pshs	x		; save DAC set value
	asla
	ldx	#acqvtbl	; variables pointer
	leax	[a,x]
	ldy	#acqbtbl	; arrays pointer
	leay	[a,y]

	puls	d		; get DAC set value
	std	cal$lpht,x	; load
	std	cor$lpht,x
	bra	phs$sete	; go complete setup


	.page
	.sbttl	phs$cal - LED Pulse Height Calibration

	;
	;  a	-	Channel to Calibrate
	;
	;  Sequence:
	;
	;	1	Stop acquisition on this channel.
	;
	;	2	Perform a 12-bit successive approximation
	;		calibration of the LED drive output to
	;		produce a 1/2 full scale pulse height response.
	;
	;	3	If DAC level is > .95 * Full Scale or
	;		If DAC level is < .10 * Full Scale
	;			then the calibration FAILS
	;
	;	4	Load current temperature into tmp$lpht
	;		and set tmp$flag to enable temperature checks
	;
	;	5	Prepare channel's data arrays
	;			Clear histogram region
	;			Do a single scan for some real data
	;			Load acq$avrg array with the phs$avrg result
	;			Load acq$sum with 64. * phs$avrg
	;
	;	6	Activate Channel
	;
	;	7	After completion of 64 channel updates
	;		the reference pulse height calibration
	;		is set in phs$lpht
	;

phs$cal::
	pshs	d,x,y
	pshs	a		; save channel
	asla
	ldx	#acqvtbl	; variables pointer
	leax	[a,x]
	ldy	#acqbtbl	; arrays pointer
	leay	[a,y]

	;	1	Stop acquisition on this channel.

	lda	,s		; restore channel number
	ldb	#$STOP		; calibration must stop any acquisition
	jsr	chng$sts	; stop acquisition on this channel
	jsr	wait$sts	; wait for status queue to empty

	;	2	Perform a 12-bit successive approximation
	;		calibration of the LED drive output to
	;		produce a 1/2 full scale pulse height response.

	ldd	#0x0800		; msb of LED pulse height DAC
	std	dac$bit
	std	cal$lpht,x	; set dac amplitude
	std	cor$lpht,x

1$:	lda	,s		; restore channel number
	ldb	#$SCAN		; single scan mode
	jsr	chng$sts	; start operation
	jsr	wait$sts	; wait for status queue to empty
2$:	ldb	acq$sts,x	; get channel status
	bitb	#1		; wait for scan to complete
	bne	2$

	ldd	phs$avrg,x	; average of 64. samples
	cmpd	#0x0200		; if below 1/2 full scale - skip
	blo	3$
	ldd	cal$lpht,x	; else back off
	subd	dac$bit
	std	cal$lpht,x
	std	cor$lpht,x
3$:	ldd	dac$bit		; update to next msb
	asra
	rorb
	std	dac$bit
	beq	4$		; finished
	addd	cal$lpht,x
	std	cal$lpht,x
	std	cor$lpht,x
	bra	1$

	;	3	If DAC level is > .95 * Full Scale or
	;		If DAC level is < .10 * Full Scale
	;			then the calibration FAILS

4$:	ldd	cal$lpht,x	; get DAC level
	cmpd	#0d3891		; .95 * Full Scale
	bhi	9$		; FAIL
	cmpd	#0d410		; .10 * Full Scale
	blo	9$		; FAIL

	;	4	Load current temperature into tmp$lpht
	;		and set tmp$flag to enable temperature checks

phs$sete == .			; entry from phs$set
	pshs	y		; save buffer address
	ldy	#tmpvar
	ldd	acq$sum,y	; get sum of temperature array
	rolb			; divide by 64
	rola
	rolb
	rola
	rolb
	exg	a,b
	anda	#0x03
	std	tmp$lpht,x	; current temperature
	lda	tmp$flag,y
	sta	tmp$flag,x	; temperature flag
	puls	y		; restore buffer address

	;	5	Prepare channel's data arrays
	;			Clear histogram region
	;			Do a single scan for some real data
	;			Load acq$avrg array with the phs$avrg result
	;			Load acq$sum with 64. * phs$avrg

	pshs	y		; save buffer address
	leay	acq$phs+0d128,y	; end of histogram buffer + 1
	lda	#0d128		; buffer length
6$:	clr	,-y		; clear array
	deca
	bne	6$
	puls	y		; restore buffer address

	lda	,s		; restore channel number
	ldb	#$SCAN		; single scan
	jsr	chng$sts	; start operation
	jsr	wait$sts	; wait for status queue to empty
7$:	ldb	acq$sts,x	; get channel status
	bitb	#1		; wait for scan to complete
	bne	7$

	pshs	x,y		; save addresses
	leay	acq$avrg,y	; array of averages
	ldx	phs$avrg,x	; average of 64. samples
	lda	#0d64		; buffer length
8$:	stx	,y++		; load the array
	deca
	bgt	8$
	puls	x,y		; restore addresses

	ldd	phs$avrg,x
	asra
	rorb
	rora
	rorb
	rora
	exg	a,b		; 64. * phs$avrg
	std	acq$sum,x	; save result

	clr	acq$index,x	; clear the index

	ldd	#0
	std	phs$lpht,x	; Zero Pulse Height Calibration

	;	6	Activate Channel

	ldb	#$ACTIVE	; activate this channel
	bra	10$

9$:	ldb	#$FAILED	; FAILED
10$:	puls	a		; restore channel number
	jsr	chng$sts	; set acquisition status on this channel
	jsr	wait$sts	; wait for status queue to empty
	puls	d,x,y
	rts


	.page
	.sbttl	Channel Update

	;  Channel update code:
	;
	;	 This code acquires 64 samples and averages the
	;	results to produce a representation of the current
	;	pulse height response.  The code maintains a list
	;	of the last 64 pulse height responses.  Normally
	;	a 64 sample response for each active channel
	;	requires about .5-.6 seconds.  Thus if 32 channels
	;	were active, approximately 15-20 seconds are required
	;	to scan all active channels.
	;
	;	 After all channels have been scanned the temperature
	;	is scanned.
	;
	;	 Each call to chan$upd also updates one channel
	;	of the LED display.
	;

chan$upd::

	tst	upd$inh		; have we been inhibited ?
	lbne	14$		; yes - just exit

	; LED update

	lda	tictoc
	anda	#0x1F

	ldx	#sys$led	; LED address
	leax	a,x

	asla
	ldy	#acqvtbl	; variable address table
	leay	[a,y]
	lda	acq$sts,y

	bita	#$HOLD		; holding ?
	beq	3$		; no - skip

	; Holding LED Modes

	ldb	#$OFF		; default

	bita	#$SCAN		; scanning ?
	beq	1$		; no - skip
	ldb	#$YFLASH	; flashing if scanning
	lda	#$YELLOW
	cmpa	,x
	beq	4$
	lda	#$OFF
	cmpa	,x
	beq	4$
	sta	,x
	bra	4$

1$:	bita	#$FAILED	; FAILED ?
	beq	2$		; no - skip
	ldb	#$RFLASH	; red flashing if FAILED
	lda	#$RED
	cmpa	,x
	beq	4$
	lda	#$OFF
	cmpa	,x
	beq	4$
	sta	,x
	bra	4$

2$:	bita	#$ACTIVE	; active ?
	beq	5$		; no - skip to update
	ldb	#$GFLASH	; green flashing if active
	lda	#$GREEN
	cmpa	,x
	beq	4$
	lda	#$OFF
	cmpa	,x
	beq	4$
	sta	,x
	bra	4$

	; Non Holding LED Modes

3$:	ldb	#$YELLOW	; yellow if scanning
	bita	#$SCAN		; scanning ?
	bne	5$		; yes - skip to update

	ldb	#$RED		; red if FAILED
	bita	#$FAILED	; FAILED ?
	bne	5$		; yes - skip to update

	ldb	#$GREEN		; green if active
	bita	#$ACTIVE	; active ?
	bne	5$		; yes - skip to update

	ldb	#$OFF		; none on
	bra	5$		; go update

4$:	eorb	,x
5$:	stb	,x

	; Queue Updating

	tst	hv$qued,y	; ready for update ?
	beq	6$		; no - skip
	pshs	y		; get number of queue
	ldy	#port2		; elements used
	ldb	que$cntr,y
	puls	y
	cmpb	#0d16		; space ?
	bhis	6$		; no - try again later
	ldb	tictoc		; channel number
	andb	#0x1F
	lda	#M16CxxG
	jsr	en$que
	lda	#M16UPDT
	jsr	en$que
	lda	#M16WAIT
	jsr	en$que
	lda	#M16CxxG
	jsr	en$que
	clr	hv$qued,y	; queued

	; end of this tic's updating

6$:	inc	tictoc		; another tic

	; channel update

	lda	upd$chn		; time for temperature ?
	cmpa	#0x1F
	blos	7$		; no -  do a channel
	jmp	temp$upd	; yes - do temperature

7$:	lda	upd$seq
	lbne	12$

;state0
	tst	svd$flg		; a saved update ?
	beq	8$		; no - skip
	lda	svd$chn		; reload saved channel
	clr	svd$flg		; clear entry
	sta	upd$chn		; save it

8$:	ldd	upd$sque	; update a status ?
	beq	11$		; no - skip
	cmpa	#0x1F		; valid channel ?
	blos	9$		; yes - skip
	ldd	#0
	std	upd$sque	; clear the entry
	rts

9$:	asla			; make index
	ldx	#acqvtbl	; table of variable pointers
	leax	[a,x]		; get current channel variable base
	andb	#0q177		; mask internal flag
	stb	acq$sts,x	; save the new status
	bitb	#1		; immediate scan ?
	beq	10$		; no - skip
	ldb	upd$chn		; yes - save upd$chn
	stb	svd$chn
	inc	svd$flg		; and flag it
	ldd	upd$sque	; get immediate channel
	sta	upd$chn		; do this channel
10$:	ldd	#0		; clear status queue
	std	upd$sque
 
11$:	lda	upd$chn		; get current channel being processed
	asla			; make index
	ldx	#acqbtbl	; table of buffer pointers
	leax	[a,x]		; get current channel buffer base
	stx	upd$bufp	; save buffer pointer
	ldx	#acqvtbl	; table of variable pointers
	leax	[a,x]		; get current channel variable base
	stx	upd$varp	; save the variable pointer
	lda	acq$sts,x	; this channel active ?
	bita	#$HOLD		; holding ?
	bne	13$		; yes - skip channel
	bita	#$ACTIVE|$SCAN	; active / single scan
	beq	13$		; no  - skip channel
	ldd	#0
	sta	upd$cntr	; clear the counter
	std	upd$sum		; clear the sum
	ldd	cor$lpht,x	; load current channel
	std	acq$dac		; LED pulse amplitude
	lda	acq$sts,x	; set scan flag
	ora	#1
	sta	acq$sts,x
	inc	upd$seq		; next sequence after a clock tick
	rts

12$:	cmpa	#1		; state1 ?
	bne	14$
;state1
	ldd	#15$		; load FIRQ address
	std	exfirq
	lda	upd$chn		; select byte with no pulsing
	sta	acq$slct	; start acquisition
	rts

;skip channel
13$:	inc	upd$chn

;state - invalid
14$:	clr	upd$seq
	rts


;firqseq1
15$:	pshs	d		; save register
	ldd	acq$adc		; get background data
	exg	a,b		; oops !
	std	upd$back	; save background
	lbmi	25$		; acquisition inhibitted
	ldd	#16$		; load FIRQ address
	std	exfirq
	lda	upd$chn		; select byte with no pulsing
	ora	#0x80		; enable LED pulsing
	sta	acq$slct	; start acquisition
	puls	d
	rti

;firqseq2
16$:	pshs	d		; save register
	ldd	acq$adc		; get data sample
	exg	a,b		; oops !
	std	upd$smpl	; save sample
	lbmi	25$		; acquisition inhibitted
	subd	upd$back	; subtract background
	bpl	17$		; only upd$smpl-upd$back > 0 accepted
	ldd	#0
17$:	addd	upd$sum		; add to sum
	std	upd$sum

	pshs	x,y,u		; save registers
	ldu	upd$bufp	; get channel buffer pointer
	ldy	upd$varp	; get channel variable pointer

	; update the channels pulse height histogram

	ldb	phs$hscl,y	; get the display range
	cmpb	#0d4		; 0 - 1024, 1 - 512, 2 - 256, 3 - 128, 4 -64
	blos	18$
	clrb
18$:	leax	20$,pcr		; compute entry
	aslb
	leax	b,x
	ldd	upd$smpl	; get sample
	subd	upd$back	; subtract background
	bpl	19$		; only upd$smpl-upd$back > 0 accepted
	ldd	#0
19$:	subd	phs$hofs,y	; start from this point
	bmi	22$		; out of range - skip
	jmp	,x		; go to proper entry
20$:	asra			; 1024 range
	rorb
	asra			; 512 range
	rorb
	asra			; 256 range
	rorb
	asra			; 128 range
	rorb
	cmpd	#0x3F		; 64 range
	bhi	22$		; out of range - skip
	aslb			; *2
	leax	acq$phs,u	; pulse height spectrum address
	leax	b,x		; channel address
	ldd	,x		; increment channel
	addd	#1
	std	,x
	bpl	22$		; skip rescale if no overflow

	; rescale histogram array

	lda	#0d64		; length of array
	sta	,-s
	leax	acq$phs,u	; pulse height spectrum address
21$:	ldd	,x		; divide array by 2
	clc
	rora
	rorb
	std	,x++
	dec	,s
	bne	21$
	leas	1,s		; pop temporary

	; end of sample update

22$:	lda	upd$cntr	; update the sample counter
	inca			; next sample
	anda	#0x3F		; mod 64
	sta	upd$cntr	; and save
	bne	24$		; not finished - exit

	; divide upd$sum by 64

	ldd	upd$sum		; get sum
	rolb			; divide by 64
	rola
	rolb
	rola
	rolb
	exg	a,b
	anda	#0x03
	std	phs$avrg,y	; save average pulse height

	; update the response array and the running average

	leax	acq$avrg,u	; averaged spectrum address
	lda	acq$index,y	; current index into response array
	leax	a,x		; response spectrum address
	leax	a,x
	ldd	acq$sum,y	; get sum
	subd	,x		; subtract oldest
	addd	phs$avrg,y	; add new response
	std	acq$sum,y	; and save
	ldd	phs$avrg,y	; get new response
	std	,x		; save in array

	; update the index

	lda	acq$index,y	; current index into response array
	inca			; update index
	anda	#0x3F
	sta	acq$index,y
	bne	23$

	; update High Voltage

	jsr	phs$comp

	; after first 64 scans set final calibration value

	ldd	phs$lpht,y	; set ?
	bne	23$	

	; divide acq$sum by 64

	ldd	acq$sum,y	; get sum
	rolb			; divide by 64
	rola
	rolb
	rola
	rolb
	exg	a,b
	anda	#0x03
	std	phs$lpht,y	; save final pulse height calibration

	; finished scanning this channel

23$:	lda	acq$sts,y	; clear scan flag
	anda	#~1
	sta	acq$sts,y

	inc	upd$chn
	clr	upd$seq		; restart sequence

24$:	puls	x,y,u		; restore registers
	puls	d
	rti

25$:	jsr	abrt$upd
	puls	d		; restore register
	rti


	.page
	.sbttl	PHS -> High Voltage Update

	; This routine compares the just completed pulse height
	; scan with the original calibration.
	;
	; The voltage is adjusted dlta$vlt volts / 1%
	; change in response.
	;
	; If the computed voltage change exceeds dlta$err volts then
	; the channel is flagged as failed and the PHS updating
	; is terminated.
	;
	; If the computed voltage change between dlta$min and dlta$err
	; volts then the HV4032A is updated to restore the
	; original calibration.
	;

phs$comp::
	ldd	phs$lpht,y	; calibration
	std	dsr
	beq	5$		; calibration incomplete

	ldd	acq$sum,y	; get sum of acquisition array
	rolb			; divide by 64
	rola
	rolb
	rola
	rolb
	exg	a,b
	anda	#0x03

	clr	dsign		; (-)
	subd	dsr		; -(cal - current)
	bpl	1$
	com	dsign		; (+)
	coma
	comb
	addd	#1
1$:	std	dnd
	com	dsign		; (+ <--> -)

	; compute (cal - current)/cal to 8-bits

	lda	#0d8		; bit counter
	sta	divcnt
	ldd	dnd		; get dividend
	aslb			; initial shift
	rola
2$:	subd	dsr		; subtract divisor
	bcc	3$		; if carry clear - good test
	addd	dsr		; else restore dividend
3$:	rol	qt		; shift in computed bit
	aslb			; shift dnd
	rola
	dec	divcnt		; 8 bits generated yet ?
	bne	2$		; loop until done
	com	qt		; get true result

	; Compute voltage change

	lda	dlta$vlt,y	; 0 - 255  -->> 0 - 5.0 volts / %
	ldb	qt		; 0 - .996 -->> 0 - 100%
	mul
	aslb			; *2
	rola
	bcs	6$		; change greater than 256 volts
	tfr	a,b		; integer change in b in volts
	clra

	; Check for a change larger than error limit

	cmpb	dlta$err,y	; default is 25% / 64 volts
	bhis	6$		; yes - skip

	; Check for a change less than minimum

	cmpb	dlta$min,y	; default is 2% / 5 volts
	blo	5$		; yes - skip

	; correct for sign

	tst	dsign
	beq	4$
	coma
	comb
	addd	#1

	; save HV change and flag it

4$:	std	hv$chng,y	; save change
	inc	hv$qued,y	; queue it
5$:	rts			; finished

	; PHS Channel Failure

6$:	lda	#$FAILED	; channel failed
	sta	acq$sts,y
	rts			; finished


	.page
	.sbttl	PHS Update Value Initialization

phs$init::
	ldx	#acqvar		; variables
	lda	#0d32		; entries

1$:	ldb	#0d5		; default 5 volt minimum change
	stb	dlta$min,x
	ldb	#0d64		; default 64 volt error change
	stb	dlta$err,x
	ldb	#0d128		; default 2.5 volts / %
	stb	dlta$vlt,x

	leax	ACQVARSZ,x
	deca
	bgt	1$
	rts


	.page
	.sbttl	Temperature channel update

	.area	ACQDATA (REL,CON)

tmpbufr::
		.blkb	TMPBUFSZ	; allocation for temperature buffers
tmpvar::
		.blkb	TMPVARSZ	; allocation for temperature variables



	.area	ACQ (REL,CON)


	;  Temperature update code:
	;
	;	 This code acquires 64 samples and averages the
	;	results to produce a representation of the current
	;	external temperature. The code maintains a list
	;	of the last 64 temperature readings.  Normally
	;	a 64 sample of the temperature requires about
	;	.5-.6 seconds.
	;
	;	 If the temperature status is not active then
	;	an initialization of the temperature arrays is
	;	performed and the status is made active.  If the
	;	temperature sensor appears to be disconnected then
	;	the temperature updating flag is cleared.

temp$upd::
	lda	upd$seq
	bne	1$

;state0
	ldd	#0
	sta	upd$cntr	; clear the counter
	std	upd$sum		; clear the sum
	inc	upd$seq		; next sequence immediately
	lda	upd$seq

1$:	cmpa	#1		; state1 ?
	bne	2$

;state1
	ldd	#3$		; load FIRQ address
	std	exfirq
	lda	#0x20		; select temperature with out sampling
	sta	acq$slct	; start acquisition
	rts

;state - invalid
2$:	clr	upd$seq
	rts

;firqseq1
3$:	pshs	d		; save register
	ldd	acq$adc		; get background data
	exg	a,b		; oops !
	std	upd$back	; save background
	lbmi	17$		; acquisition inhibitted
	ldd	#4$		; load FIRQ address
	std	exfirq
	lda	#0x30		; temperature select with sampling
	sta	acq$slct	; start acquisition
	puls	d
	rti

;firqseq2
4$:	pshs	d		; save register
	ldd	acq$adc		; get data sample
	exg	a,b		; oops !
	std	upd$smpl	; save data
	lbmi	17$		; acquisition inhibitted
	subd	upd$back	; subtract background
	bpl	5$		; only upd$smpl-upd$back > 0 accepted
	ldd	#0
5$:	cmpd	#0d922		; > .90 * Full Scale ?
	lbhi	14$		; yes - stop temperature acquisition
	addd	upd$sum		; add to sum
	std	upd$sum

	pshs	x,y,u		; save registers
	ldu	#tmpbufr	; get temperature buffer pointer
	ldy	#tmpvar		; get temperature variable pointer

	; update the temperature pulse height histogram

	ldb	phs$hscl,y	; get the display range
	cmpb	#0d4		; 0 - 1024, 1 - 512, 2 - 256, 3 - 128, 4 -64
	blos	6$
	clrb
6$:	leax	8$,pcr		; compute entry
	aslb
	leax	b,x
	ldd	upd$smpl	; get sample
	subd	upd$back	; subtract background
	bpl	7$		; only upd$smpl-upd$back > 0 accepted
	ldd	#0
7$:	subd	phs$hofs,y	; start from this point
	bmi	10$		; out of range - skip
	jmp	,x		; go to proper entry
8$:	asra			; 1024 range
	rorb
	asra			; 512 range
	rorb
	asra			; 256 range
	rorb
	asra			; 128 range
	rorb
	cmpd	#0x3F		; 64 range
	bhi	10$		; out of range - skip
	aslb			; *2
	leax	acq$phs,u	; pulse height spectrum address
	leax	b,x		; channel address
	ldd	,x		; increment channel
	addd	#1
	std	,x
	bpl	10$		; skip rescale if no overflow

	; rescale histogram array

	lda	#0d64		; length of array
	sta	,-s
	leax	acq$phs,u	; pulse height spectrum address
9$:	ldd	,x		; divide array by 2
	clc
	rora
	rorb
	std	,x++
	dec	,s
	bne	9$
	leas	1,s		; pop temporary

	; end of sample update

10$:	lda	upd$cntr	; update the sample counter
	inca			; next sample
	anda	#0x3F		; mod 64
	sta	upd$cntr	; and save
	lbne	16$		; not finished - exit

	; divide upd$sum by 64

	ldd	upd$sum		; get sum
	rolb			; divide by 64
	rola
	rolb
	rola
	rolb
	exg	a,b
	anda	#0x03
	std	phs$avrg,y	; save average pulse height

	lda	acq$sts,y
	bita	#$ACTIVE	; active ?
	bne	13$		; yes - skip

	; initialize the arrays

	pshs	u		; save buffer address
	leau	acq$phs+0d128,u	; end of histogram buffer + 1
	lda	#0d128		; buffer length
11$:	clr	,-u		; clear array
	deca
	bgt	11$
	puls	u		; restore buffer address

	pshs	u		; save address
	leau	acq$avrg,u	; array of averages
	ldx	phs$avrg,y	; average of 64. samples
	lda	#0d64		; buffer length
12$:	stx	,u++		; load the array
	deca
	bgt	12$
	puls	u		; restore address

	ldd	phs$avrg,y
	asra
	rorb
	rora
	rorb
	rora
	exg	a,b		; 64. * phs$avrg
	std	acq$sum,y	; save result

	clr	acq$index,y	; clear the index

	; Activate Channel

	lda	#$ACTIVE	; active
	sta	acq$sts,y
	ldb	#$ACTIVE	; enable temperature updating
	stb	tmp$flag,y
	bra	15$

	; update the response array and the running average

13$:	leax	acq$avrg,u	; averaged spectrum address
	lda	acq$index,y	; current index into response array
	leax	a,x		; response spectrum address
	leax	a,x
	inca			; update index
	anda	#0x3F
	sta	acq$index,y
	ldd	acq$sum,y	; get sum
	subd	,x		; subtract oldest
	addd	phs$avrg,y	; add new response
	std	acq$sum,y	; and save
	ldd	phs$avrg,y	; get new response
	std	,x		; save in array
	bra	15$

	; Sensor Disconnected

14$:	pshs	x,y,u		; save registers
	ldy	#tmpvar		; get temperature variable pointer

	lda	#$FAILED	; FAILED
	sta	acq$sts,y
	ldb	#$STOP		; disable temperature updating
	stb	tmp$flag,y

15$:	ldb	tmp$flag,y	; copy to upd$temp
	stb	upd$temp	; temperature updated
	clr	upd$seq		; restart sequence
	clr	upd$chn		; and start with channel 0

16$:	puls	x,y,u		; restore registers
	puls	d
	rti

17$:	jsr	abrt$upd
	puls	d		; restore register
	rti


	.page
	.sbttl	Acquisition Abort

	;    Abort acquisition by resetting the 'firq' vector

abrt$upd::
	ldd	#1$		; load abort FIRQ address	
	std	exfirq
	rts

;firqabort
1$:	tst	acq$adc		; clear FIRQ request
	rti


	.page
	.sbttl	LED Drive Temperature Compensation

	; The correction for temperature is .5% per degree C.
	;
	; The temperature channel calibration is 20 counts per degree C.
	;
	; DELC = current temperature - tmp$lpht
	;
	; DEL ~ .005 * DELC * cal$lpht
	;
	; cor$lpht = cal$lpht + DEL

led$comp::
	pshs	d,x

	tst	upd$temp	; temperature updated ?
	lbeq	9$		; no - skip updates

	ldx	#tmpvar		; temperature variables
	tst	tmp$flag,x	; active ?
	lbeq	9$		; no - skip updates

	; Create a stack frame for updating

	ldd	acq$sum,x	; get sum of temperature array
	rolb			; divide by 64
	rola
	rolb
	rola
	rolb
	exg	a,b
	anda	#0x03
	std	,--s		; current temperature

	leas	-0d10,s		; temporaries

	; temporary definitions

	$DELC	=	0d0	; Absolute Change in temperature
	$DELCH	=	0d0
	$DELCL	=	0d1
	$LDRV	=	0d2	; LED Drive Calibration Value
	$LDRVH	=	0d2
	$LDRVL	=	0d3
	$32BT0	=	0d4	; msb of 32-bit result
	$32BT1	=	0d5
	$32BT2	=	0d6
	$32BT3	=	0d7	; lsb of 32-bit result
	$DELSGN	=	0d8	; sign of temperature change
	$CNTR	=	0d9	; loop counter
	$CURTMP	=	0d10	; current temperature

	ldx	#acqvar		; variables
	lda	#0d32		; counter
	sta	$CNTR,s

1$:	tst	tmp$flag,x	; active ?
	beq	8$		; no - skip this channel

	; Calculate temperature change DELC

	clr	$DELSGN,s	; assume +
	ldd	$CURTMP,s	; current temperature
	subd	tmp$lpht,x	; - calibration temperature
	bpl	2$		; + ok
	inc	$DELSGN,s	; else -
	ldd	tmp$lpht,x
	subd	$CURTMP,s

	; Do .005 * DELC with scaling

2$:	aslb			; .005/20 == .00025
	rola			; scaling method
	aslb			; 1.0     -->> 65536
	rola			; .005/20 -->> 16
	aslb			; thus
	rola			; DELC * 16
	aslb
	rola
	std	$DELC,s		; save temperature change

	; Copy LED calibration value cal$lpht

	ldd	cal$lpht,x
	std	$LDRV,s

	; Do 32-bit multiplication

	lda	$DELCL,s	; lsb * lsb
	ldb	$LDRVL,s
	mul
	std	$32BT2,s

	lda	$DELCH,s	; msb * msb
	ldb	$LDRVH,s
	mul
	std	$32BT0,s
	
	lda	$DELCL,s	; lsb * msb
	ldb	$LDRVH,s
	mul
	addd	$32BT1,s
	std	$32BT1,s
	bcc	3$
	inc	$32BT0,s

3$:	lda	$DELCH,s	; msb * lsb
	ldb	$LDRVL,s
	mul
	addd	$32BT1,s
	std	$32BT1,s
	bcc	4$
	inc	$32BT0,s

4$:	ldd	$32BT0,s	; correction in DAC units
	tst	$DELSGN,s	; +
	beq	5$		; yes - skip
	coma			; -
	comb
	addd	#1
5$:	addd	$LDRV,s
	bpl	6$		; underflow not allowed
	ldd	#0
6$:	cmpd	#0d4095		; overflow  not allowed
	blos	7$
	ldd	#0d4095
7$:	std	cor$lpht,x	; corrected LED Drive level

8$:	leax	ACQVARSZ,x
	dec	$CNTR,s
	bne	1$

	leas	0d12,s

9$:	puls	d,x
	rts

