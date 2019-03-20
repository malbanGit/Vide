	.sbttl	Assembler Link Tests

	.module	t

	; This file and TCONST.ASM should be assembled and linked.
	;
	; AS6809 -XGOL T
	; AS6809 -XGOL TCONST
	;
	; ASLINK -C
	; -XMS
	; T
	; T
	; TCONST
	; -E
	;
	; The following tests verify the correct processing of
	; external references for the direct page, index mode offsets,
	; and branches.
	;
	; *L signifies an error will be reported at link time.

	.area	A

	.blkb	1

	.area	PAGE0	(PAG)	;*L Linker -- page boundary error

	.setdp	0,PAGE0		;*L Linker -- page definition boundary error

	.blkb	0x101		;*L Linker -- page length error

	.area	PAGE1	(ABS,OVR)

	.setdp	0x100,PAGE1

	.setdp	boundary,PAGE1	;*L Linker -- page definition boundary error


