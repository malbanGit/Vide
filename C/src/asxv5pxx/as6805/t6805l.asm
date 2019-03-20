	.sbttl	Assembler Link Tests

	.module	t6805l

	; This file and TCONST.ASM should be assembled and linked.
	;
	; AS6805 -XGOL T6805L
	; AS6805 -XGOL TCONST
	;
	; ASLINK -C
	; -XMS
	; T6805L
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

	lda	*minus1		;*L B6 00  [B6 FF]
	lda	*zero		;   B6 00  [B6 00]
	lda	*two55		;   B6 00  [B6 FF]
	lda	*two56		;*L B6 00  [B6 00]

	lda	*lminus1	;*L B6 00  [B6 FF]
	lda	*lzero		;   B6 00  [B6 00]
	lda	*ltwo55		;   B6 00  [B6 FF]
	lda	*ltwo56		;*L B6 00  [B6 00]

	; indexed test

	lda	minus1,x	;   D6 00 00  [D6 FF FF]
	lda	zero,x		;   D6 00 00  [D6 00 00]
	lda	two55,x		;   D6 00 00  [D6 00 FF]
	lda	two56,x		;   D6 00 00  [D6 01 00]

	; direct page boundary / length checking

	.area	A

	.blkb	1

	.area	PAGE0	(PAG)	;*L Linker -- page boundary error

	.setdp	0,PAGE0		;*L Linker -- page definition boundary error

	.blkb	0x101		;*L Linker -- page length error

