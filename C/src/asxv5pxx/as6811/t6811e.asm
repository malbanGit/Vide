	.title	AS6811 Assembler Error Check

	dir	=	0x0100
	offset	=	0x0101

	sta a	#32		;error
	stab	#33		;error
	std	#1122		;error

	lda a	offset,x	;error
	ldaa	*dir		;error

	std	#1122		;error
	sts	#2211		;error
	stx	#1122		;error
	sty	#1122		;error

	sub	#20		;error

	jmp	*dir		;error
	jmp	#2211		;error
	jsr	#1122		;error

	lda a	*255		;OK
	lda a	*256		;error
	lda a	*-1		;error
	lda a	*-256		;error

