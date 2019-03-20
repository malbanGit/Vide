	.title	6800 Assembler Error Check

	.area	DIRECT

dirval:	.blkb	0d256

	.area	AS6800

	.setdp	0,DIRECT

	dir	=	0x0100
	offset	=	0x0101

1$:	sta a	#32		;error
	stab	#33		;error

	lda a	offset,x	;error
	ldaa	*dir		;error

	sts	#2211		;error
	stx	#1122		;error

	sub	#20		;error

	jmp	*dir		;OK
	jmp	#2211		;error
	jsr	#1122		;error

	lda a	*255		;OK
	lda a	*256		;error
	lda a	*-1		;error
	lda a	*-256		;error

	lda a	*dirval		;OK
	lda a	dirval		;OK
	lda a	*dirval+0x100	;error at link time
	lda a	*1$		;error at link time

	.setdp	1,DIRECT	;error / error at link time
	.setdp	0x100,DIRECT	;error
				;all subsequent direct page accesses
				;will give errors at link time

