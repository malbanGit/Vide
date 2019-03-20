	.sbttl	Assembler Link Tests

	.module	t6800l

	; This file and TCONST.ASM should be assembled and linked.
	;
	; AS6800 -XGOL T6800L
	; AS6800 -XGOL TCONST
	;
	; ASLINK -C
	; -XMS
	; T6800L
	; TCONST
	; -E
	;
	; The following tests verify the correct processing of
	; external references for the direct page, index mode offsets,
	; and branches.
	;
	; *L signifies an error will be reported at link time.

	; branch test must be first

	.area	TEST	(ABS,OVR)

	.blkb	0x7E		;bra1:
	bra	bra1		;   20 00  [20 80]
	.blkb	0x7F		;bra2:
	bra	bra2		;*L 20 00  [20 7F]
	bra	bra3		;   20 00  [20 7F]
	.blkb	0x7F
	.blkb	0x00		;bra3:
	bra	bra4		;*L 20 00  [20 [80]
	.blkb	0x80
	.blkb	0x00		;bra4:

	.blkb	0x7E		;bra5:
	bra	bra5		;   20 00  [20 80]
	.blkb	0x7F		;bra6:
	bra	bra6		;*L 20 00  [20 7F]
	bra	bra7		;   20 00  [20 7F]
	.blkb	0x7F
	.blkb	0x00		;bra7:
	bra	bra8		;*L 20 00  [20 [80]
	.blkb	0x80
	.blkb	0x00		;bra8:

	; direct page test

	.area	DIRECT	(ABS,OVR)
	.setdp	0,DIRECT

	lda a	*minus1		;*L 96 00  [96 FF]
	lda a	*zero		;   96 00  [96 00]
	lda a	*two55		;   96 00  [96 FF]
	lda a	*two56		;*L 96 00  [96 00]

	lda a	*lminus1	;*L 96 00  [96 FF]
	lda a	*lzero		;   96 00  [96 00]
	lda a	*ltwo55		;   96 00  [96 FF]
	lda a	*ltwo56		;*L 96 00  [96 00]

	; indexed test

	lda a	minus1,x	;*L A6 00  [A6 FF]
	lda a	zero,x		;   A6 00  [A6 00]
	lda a	two55,x		;   A6 00  [A6 FF]
	lda a	two56,x		;*L A6 00  [A6 00]

	; direct page boundary / length checking

	.area	A

	.blkb	1

	.area	PAGE0	(PAG)	;*L Linker -- page boundary error

	.setdp	0,PAGE0		;*L Linker -- page definition boundary error

	.blkb	0x101		;*L Linker -- page length error

