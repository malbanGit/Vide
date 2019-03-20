	.title	Option File for PHS

	.module	phsopt

	.include	/area.def/
	.include	/define.def/


	;  Include this file in Down Loadable Code
	;  destined for the PHS

	;  The following labels and data allocations
	;  are defined in PHS.

	;  This file should be the first file to be linked
	;  to insure that the dispatch table is cleared.

	; $xtrn0:	.blkb	4	; 4096 bytes allocated
	; $xtrn1:	.blkb	4	; for optional functions
	; $xtrn2:	.blkb	4
	; $xtrn3:	.blkb	4
	; $xtrn4:	.blkb	4
	; $xtrn5:	.blkb	4
	; $xtrn6:	.blkb	4
	; $xtrn7:	.blkb	4
	; $xtrn8:	.blkb	4
	; $xtrn9:	.blkb	4

	; $xtend			; end of user area


	;  System Vector Table as defined in DSPCGC.

	; exrsrv:	.blkb	2	; loadable system vectors
	; exswi3:	.blkb	2
	; exswi2:	.blkb	2
	; exfirq:	.blkb	2
	; exirq:	.blkb	2
	; exswi:	.blkb	2
	; exnmi:	.blkb	2

	.page
	.sbttl	Option Dispatcher

	.area	OPTFUN	(ABS,OVR)

	.radix	o

	.word	.$0HDR		; $0 header entry
	.word	.$0HDR-0x5AA5
	.word	0		; $1
	.word	0
	.word	0		; $2
	.word	0
	.word	0		; $3
	.word	0
	.word	0		; $4
	.word	0
	.word	0		; $5
	.word	0
	.word	0		; $6
	.word	0
	.word	0		; $7
	.word	0
	.word	0		; $8
	.word	0
	.word	.$9		; $9
	.word	.$9-0x5AA5


	.page
	.sbttl	PHSOPT Header

opt$id:	.byte	15,12
	.ascii	*PHS  V01.00*
	.byte	15,12
	.ascii	*PHS Optional Function Header - V01.00*
	.byte	15,12
	id$len	=	.-opt$id	; length of version
	.ascii	*Copyright 1992*
	.byte	15,12
	.ascii	*Otselic Specialties*
	.byte	15,12
	.ascii	*721 Berkeley*
	.byte	15,12
	.ascii	*Kent, Ohio  44240*
	.byte	15,12
	cr$len	=	.-opt$id	; length of notice


	.page
	.sbttl	$0 command

.$0HDR:	jsr	nxtchr		; get character

	jsr	$dispatch
	.byte	'V
	.word	1$		; version select
	.byte	'C
	.word	2$		; copyright select
	.byte	0

1$:	lda	#id$len		; id$len, length of id
	bra	3$

2$:	lda	#cr$len		; cr$len, length of cr

3$:	sta	*number
	ldx	#opt$id		; version string
4$:	ldb	,x+		; get character
	stx	,--s		; save pointer
	jsr	plcbuf		; send character
	ldx	,s++		; get pointer
	dec	*number		; more ?
	bne	4$		; yes - loop
	bra	.$0HDR

	.page
	.sbttl	.$9 -- Reset PHS Interrupt Vectors

	;  The default Vector Table is loaded from the
	;  following table defined in PHS

	; irqtbl:	.word	undfnd,	exrsrvd	;reserved	(unused)
	;		.word	debugp,	exswi3	;swi3
	;		.word	undfnd,	exswi2	;swi2
	;		.word	undfnd,	exfirq	;firq vector
	;		.word	clocki,	exirq	;irq  vector
	;		.word	undfnd,	exswi	;swi		(unused)
	;		.word	undfnd,	exnmi	;nmi		(unused)
	;		.word	0,	0	;end of table

	;  Reset Interrupt Table using this routine

.$9:	ldx	#irqtbl		; table pointer
1$:	ldd	,x++		; get vector entry
	beq	2$
	std	[,x++]		; place in vector table
	bra	1$		; loop

2$:	rts			; finished

