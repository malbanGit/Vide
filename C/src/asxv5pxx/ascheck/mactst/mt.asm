	.title	Macro Processor Tests
	.list	(me)

	; Macro definition with
	; conditional exits.
	.macro	cond	A,B,C
	.if	nb,^!A!
	  .if	nb,^!B!
	    .if	nb,^!C!
	      .mexit	; C
	    .endif
	    .mexit	; B
	  .endif
	  .mexit	; A
	.endif
	.endm

	cond

	cond	X

	cond	X,Y

	cond	X,Y,Z



