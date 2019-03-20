	.title	AS6816 Assembler Error Check

	.module	t6816e

	; This file should be assembled as follows:
	;
	; as6816 -xlff t6816e
	;

	imm8	=	0x01
	imm16	=	0x2345
	ind8	=	0x12
	ind16	=	0x3456
	ix	=	0x06
	iy	=	0x07
	ixiy	=	0x89
	mask8	=	0x78
	mask16	=	0x9ABC

	address	=	0x1122
	bnk	=	0x03

	.globl	num8
	.globl	num16
	.globl	external

	. = .+0x0001
	bra	.		;b B0 FE

	adca	ind16,x8	;a 43 56

	andp	num16		;a

	asl	#num8		;a
	asl	ind16,x8	;a 04 56
	asl	e,x		;a

	bclr	ind16,x8,#mask8	;a 17 08 78 56
	bclr	e,x,#mask8	;a
	bclr	ind8,x8,#mask16	;a 17 08 BC 12

	bclrw	ind8,x8,#mask16	;a 27 08 9A BC 00 12
	bclrw	e,x,#mask16	;a 27 08 9A BC 00 00

	bcs	#0x1000		;r B5 D2
	bcs	.-0xFF		;r B5 FF

	jmp	bnk,#0x100	;a
	jmp	bnk,ind16,x8	;a

	movb	#num16,external	;a
	movb	#num8,e,x	;a
	movb	external,e,x	;a
	movb	e,x,external	;a

	pshm	cc		;aq
	pulm	cc		;aq

	staa	#10		;a
	sts	#external	;a

