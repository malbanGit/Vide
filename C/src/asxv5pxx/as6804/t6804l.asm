	.sbttl	Assembler Link Tests

	.module	t6804l

	; This file and TCONST.ASM should be assembled and linked.
	;
	; AS6804 -XGOL T6804L
	; AS6804 -XGOL TCONST
	;
	; ASLINK -C
	; -XMS
	; T6804L
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

	.blkb	0x7D		;bra1:
	brclr	#0,0,bra1	;   C0 00 00  [C0 00 80]
	.blkb	0x7E		;bra2:
	brclr	#0,0,bra2	;*L C0 00 00  [C0 00 7F]
	brclr	#0,0,bra3+1	;   C0 00 01  [C0 00 7F]
	.blkb	0x7E
	.blkb	0x00		;bra3:
	brclr	#0,0,bra4+1	;*L C0 00 01  [C0 00 80]
	.blkb	0x7F
	.blkb	0x00		;bra4:

	.blkb	0x7D		;bra5:
	brclr	#0,0,bra5	;   C0 00 00  [C0 00 80]
	.blkb	0x7E		;bra6:
	brclr	#0,0,bra6	;*L C0 00 00  [C0 00 7F]
	brclr	#0,0,bra7+1	;   C0 00 01  [C0 00 7F]
	.blkb	0x7E
	.blkb	0x00		;bra7:
	brclr	#0,0,bra8+1	;*L C0 00 01  [C0 00 80]
	.blkb	0x7F
	.blkb	0x00		;bra8:


	lda	minus1		;*L F8 00  [F8 FF]
	lda	zero		;   F8 00  [F8 00]
	lda	two55		;   F8 00  [F8 FF]
	lda	two56		;*L F8 00  [F8 00]

	lda	lminus1		;*L F8 00  [F8 FF]
	lda	lzero		;   F8 00  [F8 00]
	lda	ltwo55		;   F8 00  [F8 FF]
	lda	ltwo56		;*L F8 00  [F8 00]

