	.title	H8 Assembler Error Check

	.area	DIRECT	(REL,OVR)

. = . + 0xFF00
dirval:	.blkb	0d256

	.area	ASH8	(REL,OVR)

	.setdp	0xFF00,DIRECT

	dbase	=	0x0100
	offset	=	0x0101
	dir	=	0xFEFF

1$:	add	r0H,#32		;a

	mov	r0L,r4L
	mov	r0L,r4		;a
	mov	r0,r4L		;a

	mov	r0,r4
	mov.b	r0,r4		;a
	mov.w	r0L,r4L		;a

	mov	*dir,r0H	;a
	mov	r0H,*dir	;a

	mov	#2211,r0H	;a
	mov	r0H,#1122	;a

	jmp	@@dbase		;a
	jmp	#2211		;a

	mov	*0xFFFF,r0H	;
	mov	*0x0000,r0H	;a
	mov	*0x8000,r0H	;a
	mov	*0xFEFF,r0H	;a

	mov	*dirval,r0H	;
	mov	dirval,r0H	;
	mov  *dirval+0x100,r0H	;   / *L error at link time
	mov	*1$,r0H		;   / *L error at link time

	.setdp	0xFF01,DIRECT	;b  / *L error at link time
	.setdp	0x0000,DIRECT	;b  / *L error at link time
				;all subsequent direct page accesses
				;will give errors at link time

