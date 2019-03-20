	;	  This file contains typical console input and
	;	output routines you must write, assemble and link with
	;	MOND09 or AST09.

	.title	Option File for Monitor - 09

	.module	monopt

	.area	OPTFUN	(ABS,OVR)

	.sbttl	MONDEB - 09 Startup Entry Points

mond09:	ldd	#typswi		; check if settup
	cmpd	exswi
	bne	1$
	swi			; trap into MOND09
	rts

1$:	ldd	#typswi
	std	exswi		; swi interrupt vector
	ldd	#dspidta
	std	conin
	std	altin
	ldd	#dspodta
	std	conout
	std	altout
	jsr	mond09		; start up MONDEB - 09
	rts


	;********************************************************
	;*      typical console i/o drivers
	;********************************************************

	;* dspidta - return console input character
	;* output: c=0 if no data ready, c=1 a=character

dspidta:
	tst	rcvrcsr		; a character ?
	bmi	1$		; yes - skip
	clc			; no character
	rts			; return to caller

1$:	lda	rcvrdata	; get character
	cmpa	#0o141		; translate lower to upper
	bcs	2$
	cmpa	#0o173
	bcc	2$
	suba	#0o40
2$:	sec			; character taken
	rts

	;* dspodta - output character to console device
	;* input: a=character to send
	;* all registers transparent

dspodta:
	tst	xmtrcsr		; transmitter ready ?
	bpl	dspodta		; no - loop until ready
	sta	xmtrdata	; send character
	rts



	.title	Option File for Assist09

	.module	astopt

	.page
	.sbttl	Assist09 SWI Functions

	;********************************************************
	;* assist09 monitor swi functions
	;*
	;*  the following equates define functions provided
	;*  by the assist09 monitor via the swi instruction.
	;********************************************************

inchnp	=	0		; input char in a reg - no parity
outch	=	1		; output char from a reg
pdata1	=	2		; output string
pdata	=	3		; output cr/lf then string
out2hs	=	4		; output two hex and space
out4hs	=	5		; output four hex and space
pcrlf	=	6		; output cr/lf
space	=	7		; output a space
monitr	=	8		; enter assist09 monitor
vctrsw	=	9		; vector examine/switch
brkpt	=	10		; user program breakpoint
pause	=	11		; task pause function
numfun	=	11		; number of available functions

	;* sub-codes for accessing the vector table.
	;* they are equivalent to offsets in the table.
	;* relative positioning must be maintained.

.avtbl	=	0		; address of vector table
.cmdl1	=	2		; first command list
.rsvd	=	4		; reserved hardware vector
.swi3	=	6		; swi3 routine
.swi2	=	8		; swi2 routine
.firq	=	10		; firq routine
.irq	=	12		; irq routine
.swi	=	14		; swi routine
.nmi	=	16		; nmi routine
.reset	=	18		; reset routine
.cion	=	20		; console on
.cidta	=	22		; console input data
.cioff	=	24		; console input off
.coon	=	26		; console output on
.codta	=	28		; console output data
.cooff	=	30		; console output off
.hsdta	=	32		; high speed printdata
.bson	=	34		; punch/load on
.bsdta	=	36		; punch/load data
.bsoff	=	38		; punch/load off
.pause	=	40		; task pause routine
.expan	=	42		; expression analyzer
.cmdl2	=	44		; second command list
.pad	=	46		; character pad and new line pad
.echo	=	48		; echo/load and null bkpt flag


	.sbttl	Assist09 Startup Entry Points

ast09:	ldd	exswi		; verify settup
	cmpd	#swi
	bne	1$
	lda	#1
	swi			; reenter monitor
	.byte	monitr
	pshs	cc
	orcc	#120		; inhibit interrupts
	puls	cc,pc		; return to caller

1$:	ldd	#swi		; load swi vector
	std	exswi
	leas	astack,pcr	; stack pointer
	jsr	bldvtr		; build vector table
	ldd	#dspidta	; console input
	std	.cidta,u	; load vector table
	ldd	#dspodta	; console output
	std	.codta,u	; load vector table
	clra			; announce
	swi			; monitor fireup
	.byte	monitr		; to enter command processing
	pshs	cc
	orcc	#120		; inhibit interrupts
	jmp	main		; restart caller


	;********************************************************
	;*      typical i/o drivers
	;********************************************************

	;* dspidta - return console input character
	;* output: c=0 if no data ready, c=1 a=character

dspidta:
	tst	rcvrcsr		; a character ?
	bmi	1$		; yes - skip
	clc			; no character
	rts			; return to caller

1$:	lda	rcvrdata	; get character
	cmpa	#0o141		; translate lower to upper
	bcs	2$
	cmpa	#0o173
	bcc	2$
	suba	#0o40
2$:	sec			; character taken
	rts

	;* dspodta - output character to console device
	;* input: a=character to send
	;* all registers transparent

dspodta:
	tst	xmtrcsr		; transmitter ready ?
	bpl	dspodta		; no - loop until ready
	sta	xmtrdata	; send character
	rts

