	.title	AS2650 Assembler Checks

	; Assembler this file:
	;
	;	as2650 -gloaxff t2650e
	;

	.sbttl	Absolute Code

	; Absolute Variables

	.define	ADDR	"0x1234"
	.define	BADD	"0x7654"
	.define	DATA8	"0x21"
	.define	DATA2	"0"
	.define	P	"0x98"
	.define	DISP	"."


	.area	AS2650	(ABS,OVR)
	.org	0x1000


	.sbttl	Illegal Instruction Tests

	andz	r0			; 40

	bcfr	.un.,DISP		; 9B 7E
	bcfr	#DATA2 + 3,DISP		; 9B 7E
	bcfr	.un.,[DISP]		; 9B FE
	bcfr	#DATA2 + 3,[DISP]	; 9B FE
	bcfr	.un.,@DISP		; 9B FE
	bcfr	#DATA2 + 3,@DISP	; 9B FE

	bcfa	.un.,BADD		; 9F 76 54
	bcfa	#DATA2 + 3,BADD		; 9F 76 54
	bcfa	.un.,[BADD]		; 9F F6 54
	bcfa	#DATA2 + 3,[BADD]	; 9F F6 54
	bcfa	.un.,@BADD		; 9F F6 54
	bcfa	#DATA2 + 3,@BADD	; 9F F6 54

	bsfr	.un.,DISP		; BB 7E
	bsfr	#DATA2 + 3,DISP		; BB 7E
	bsfr	.un.,[DISP]		; BB FE
	bsfr	#DATA2 + 3,[DISP]	; BB FE
	bsfr	.un.,@DISP		; BB FE
	bsfr	#DATA2 + 3,@DISP	; BB FE

	bsfa	.un.,BADD		; BF 76 54
	bsfa	#DATA2 + 3,BADD		; BF 76 54
	bsfa	.un.,[BADD]		; BF F6 54
	bsfa	#DATA2 + 3,[BADD]	; BF F6 54
	bsfa	.un.,@BADD		; BF F6 54
	bsfa	#DATA2 + 3,@BADD	; BF F6 54

	stri	r0,#DATA8		; C4 21
	stri	r1,#DATA8		; C5 21
	stri	r2,#DATA8		; C6 21
	stri	r3,#DATA8		; C7 21

	.sbttl	Illegal Addressing Mode Tests

	; Type: S_IO

	redc	r0

	redc	.eq.
	redc	#DATA8
	redc	BADD
	redc	[BADD]
	redc	[BADD,r0]
	redc	[BADD,r0+]
	redc	[BADD,-r0]


	; Type: S_IOE

	rede	r0,#P

	rede	r0,.eq.
	rede	r0,BADD
	rede	r0,[BADD]
	rede	r0,[BADD,r0]
	rede	r0,[BADD,r0+]
	rede	r0,[BADD,-r0]

	rede	.eq.
	rede	#DATA8
	rede	BADD
	rede	[BADD]
	rede	[BADD,r0]
	rede	[BADD,r0+]
	rede	[BADD,-r0]


	; Type: S_TYP1

	lodr	r0,DISP

	lodr	r0,#DATA8		; linker error
	lodr	r0,[BADD,r0]
	lodr	r0,[BADD,r0+]
	lodr	r0,[BADD,-r0]

	lodr	.eq.,r0
	lodr	#DATA8,r0
	lodr	BADD,r0
	lodr	[BADD],r0
	lodr	[BADD,r0],r0
	lodr	[BADD,r0+],r0
	lodr	[BADD,-r0],r0

	lodr	r0
	lodr	.eq.
	lodr	#DATA8
	lodr	BADD
	lodr	[BADD]
	lodr	[BADD,r0]
	lodr	[BADD,r0+]
	lodr	[BADD,-r0]

	lodr	r0,[BADD,r0]
	lodr	r1,[BADD,r1]
	lodr	r2,[BADD,r2]
	lodr	r3,[BADD,r3]

	lodr	r0,[BADD,+r0]
	lodr	r1,[BADD,+r1]
	lodr	r2,[BADD,+r2]
	lodr	r3,[BADD,+r3]

	lodr	r0,[BADD,-r0]
	lodr	r1,[BADD,-r1]
	lodr	r2,[BADD,-r2]
	lodr	r3,[BADD,-r3]

	; Type: S_TYP2

	loda	r0,[ADDR]

	loda	r0,#DATA8

	loda	.eq.,r0
	loda	#DATA8,r0
	loda	BADD,r0
	loda	[BADD],r0
	loda	[BADD,r0],r0
	loda	[BADD,r0+],r0
	loda	[BADD,-r0],r0

	loda	r0
	loda	.eq.
	loda	#DATA8
	loda	BADD
	loda	[BADD]
	loda	[BADD,r0]
	loda	[BADD,r0+]
	loda	[BADD,-r0]

	loda	r0,[BADD,r0]
	loda	r1,[BADD,r1]
	loda	r2,[BADD,r2]
	loda	r3,[BADD,r3]

	loda	r0,[BADD,+r0]
	loda	r1,[BADD,+r1]
	loda	r2,[BADD,+r2]
	loda	r3,[BADD,+r3]

	loda	r0,[BADD,-r0]
	loda	r1,[BADD,-r1]
	loda	r2,[BADD,-r2]
	loda	r3,[BADD,-r3]

	; Type: S_TYP3

	lodi	r0,#DATA8

	lodi	r0,[BADD,r0]
	lodi	r0,[BADD,r0+]
	lodi	r0,[BADD,-r0]

	lodi	.eq.,r0
	lodi	#DATA8,r0
	lodi	BADD,r0
	lodi	[BADD],r0
	lodi	[BADD,r0],r0
	lodi	[BADD,r0+],r0
	lodi	[BADD,-r0],r0

	lodi	r0
	lodi	.eq.
	lodi	#DATA8
	lodi	BADD
	lodi	[BADD]
	lodi	[BADD,r0]
	lodi	[BADD,r0+]
	lodi	[BADD,-r0]

	lodi	r0,[BADD,r0]
	lodi	r1,[BADD,r1]
	lodi	r2,[BADD,r2]
	lodi	r3,[BADD,r3]

	lodi	r0,[BADD,+r0]
	lodi	r1,[BADD,+r1]
	lodi	r2,[BADD,+r2]
	lodi	r3,[BADD,+r3]

	lodi	r0,[BADD,-r0]
	lodi	r1,[BADD,-r1]
	lodi	r2,[BADD,-r2]
	lodi	r3,[BADD,-r3]

	; Type: S_TYP4

	lodz	r1

	lodz	.eq.
	lodz	#DATA8
	lodz	BADD
	lodz	[BADD]
	lodz	[BADD,r0]
	lodz	[BADD,r0+]
	lodz	[BADD,-r0]

	; Type: S_TYP5

	ppsu	#DATA8

	ppsu	r0
	ppsu	.eq.
	ppsu	BADD
	ppsu	[BADD]
	ppsu	[BADD,r0]
	ppsu	[BADD,r0+]
	ppsu	[BADD,-r0]

	; Type: S_BRAZ

	zbrr	.-63
	zbrr	.-62
	zbrr	.+0
	zbrr	.+2
	zbrr	.+4
	zbrr	.+65
	zbrr	.+66

	zbrr	[.-63]
	zbrr	[.-62]
	zbrr	[.+0]
	zbrr	[.+2]
	zbrr	[.+4]
	zbrr	[.+65]
	zbrr	[.+66]

	; Type: S_BRAE

	bxa	r0
	bxa	.eq.
	bxa	#DATA8
	bxa	0x8000
	bxa	[0x8000]
	bxa	[0x8000,r0]
	bxa	[0x8000,r0+]
	bxa	[0x8000,-r0]

	; Type: S_BRCR

	bctr	#DATA2,DISP-63
	bctr	#DATA2,DISP-62
	bctr	#DATA2,DISP+0
	bctr	#DATA2,DISP+2
	bctr	#DATA2,DISP+4
	bctr	#DATA2,DISP+65
	bctr	#DATA2,DISP+66

	bctr	r0,DISP
	bctr	ADDR,DISP
	bctr	[ADDR],DISP
	bctr	[ADDR,r0],DISP
	bctr	[ADDR,r0+],DISP
	bctr	[ADDR,-r0],DISP

	; Type: S_BRCA

	bcta	.eq.,[BADD]
	bcta	#DATA2,[BADD]

	bcta	r0,BADD
	bcta	#DATA8,BADD
	bcta	ADDR,BADD
	bcta	[ADDR],BADD
	bcta	[ADDR,r0],BADD
	bcta	[ADDR,r0+],BADD
	bcta	[ADDR,-r0],BADD

	bcta	#DATA2,r0
	bcta	#DATA2,#DATA8
	bcta	#DATA2,[ADDR,r0]
	bcta	#DATA2,[ADDR,r0+]
	bcta	#DATA2,[ADDR,-r0]

	; Type: S_BRRR

	birr	r0,DISP-63
	birr	r0,DISP-62
	birr	r0,DISP+0
	birr	r0,DISP+2
	birr	r0,DISP+4
	birr	r0,DISP+65
	birr	r0,DISP+66

	birr	#DATA8,DISP
	birr	ADDR,DISP
	birr	[ADDR],DISP
	birr	[ADDR,r0],DISP
	birr	[ADDR,r0+],DISP
	birr	[ADDR,-r0],DISP

	; Type: S_BRRA

	bira	r0,[BADD]

	bira	r0,r0
	bira	r0,.eq.
	bira	r0,#DATA8
	bira	r0,0x8000
	bira	r0,[0x8000]
	bira	r0,[0x8000,r0]
	bira	r0,[0x8000,r0+]
	bira	r0,[0x8000,-r0]

	bira	.eq.,[BADD]
	bira	#DATA8,[BADD]
	bira	ADDR,[BADD]
	bira	[ADDR],[BADD]
	bira	[ADDR,r0],[BADD]
	bira	[ADDR,r0+],[BADD]
	bira	[ADDR,-r0],[BADD]

	; Type: S_RET

	retc	.eq.
	retc	#DATA2

	retc	r0
	retc	#DATA8
	retc	ADDR
	retc	[ADDR]
	retc	[ADDR,r0]
	retc	[ADDR,r0+]
	retc	[ADDR,-r0]


