	.page
	.sbttl	MC6850 ACIA Control Routines

	.module	acia

	.include	/area.def/
	.include	/define.def/

	.area	ACIA

	;	dlstat status register format
	;
	;	7-	interrupt request flag
	;	6-	parity error flag
	;	5-	rcvr overrun flag
	;	4-	framing error flag
	;	3-	/cts monitor
	;	2-	/dcd monitor
	;	1-	transmitter data register empty
	;	0-	rcvr data register full
	;	
	;
	;	dlcsr control register format
	;
	;	7-	rcvr interrupt enable
	;	6-	$ - transmitter function
	;	5-	$
	;		6 5	Function
	;		- -	--------
	;		0 0	/RTS = low,  xmtr interrupt disabled
	;		0 1	/RTS = low,  xmtr interrupt enabled
	;		1 0	/RTS = high, xmtr interrupt disabled
	;		1 1	/RTS = low,  xmtr interrupt disabled and
	;				     transmits a break
	;	4-	#
	;	3-	# - data encoding format
	;	2-	#
	;		4 3 2	Function
	;		- - -	--------
	;		0 0 0	7 Bits + Even Parity + 2 Stop Bits
	;		0 0 1	7 Bits + Odd  Parity + 2 Stop Bits
	;		0 1 0	7 Bits + Even Parity + 1 Stop Bit
	;		0 1 1	7 Bits + Even Parity + 1 Stop Bit
	;		1 0 0	8 Bits + 2 Stop Bits
	;		1 0 1	8 Bits + 1 Stop Bit
	;		1 1 0	8 Bits + Even Parity + 1 Stop Bits
	;		1 1 1	8 Bits + Even Parity + 1 Stop Bits
	;
	;	1-	% - counter divider select
	;	0-	%
	;		1 0	Function
	;		- -	--------
	;		0 0	Counter Divide Ratio 1
	;		0 1	Counter Divide Ratio 16
	;		1 0	Counter Divide Ratio 64
	;		1 1	Master Reset
	;
	;

	.page
	.sbttl	ACIA Initialization

	;	Enter with index register u = user's base data address
	;	Enter with register d = serial port number (0, 1, or 2)


ini$6850::
	pshs	d,y		; save registers

	pshs	d
	tfr	u,d
	tfr	a,dp		; direct page register
	puls	d

	aslb
	clra
	addd	#sys$ser0	; hardware address of serial port 0
	std	*ser$port	; port status register address
	addd	#1
	std	*ser$port+2	; port rcvr/xmtr register address


	lda	#3		; reset acia's
	sta	[dlcsr,u]

	;set acia for
	; 1.	8 bits data + no parity + 1 stop
	; 2.	64x clock from MC14441 baud rate generator
	; 3.	transmitter interrupt disable
	; 4.	receiver interrupt enable
	;
	;	   76543210
	;	   --------
	lda	#0b10010110
	sta	[dlcsr,u]	; load acia
	sta	*d.csr		; save setup

	leay	dlbuf,u		; preset host link buffer
	sty	*dlqntr
	sty	*dlpntr

	leay	dllen,y		; preset end of buffer
	sty	*dlend

	leay	scbuf,u		; preset scan buffer
	sty	*scqntr
	sty	*scpntr

	leay	sclen,y		; preset end of buffer
	sty	*scend

	clr	*bfstat		; buffers are empty

	clr	*$dxonf		; clear special character

	lda	#1		; xon/xoff enabled
	sta	*d.stat

	puls	d,y		; restore registers
	rts			; finished
