	.sbttl	Assembler Link Tests

	.module	t6816l

	; This file and TCONST.ASM should be assembled and linked.
	;
	; AS6816 -XGOL T6816L
	; AS6816 -XGOL TCONST
	;
	; ASLINK -C
	; -XMS
	; T6816L
	; TCONST
	; -E
	;
	; The following tests verify the correct processing of
	; index mode offsets and branches.
	;
	; *L signifies an error will be reported at link time.

	; branch test must be first

	.area	TEST	(ABS,OVR)

	.blkb	0x7E		;bra1:
	bra	bra1		;   B0 00  [B0 80]
	.blkb	0x80		;bra2:
	bra	bra2		;*L B0 00  [B0 7E]
	bra	bra3		;   B0 00  [B0 7E]
	.blkb	0x7E
	.blkb	0x00		;bra3:
	bra	bra4		;*L B0 00  [B0 80]
	.blkb	0x80
	.blkb	0x00		;bra4:

	.blkb	0x7E		;bra5:
	bra	bra5		;   B0 00  [B0 80]
	.blkb	0x80		;bra6:
	bra	bra6		;*L B0 00  [B0 7E]
	bra	bra7		;   B0 00  [B0 7E]
	.blkb	0x7E
	.blkb	0x00		;bra7:
	bra	bra8		;*L B0 00  [B0 80]
	.blkb	0x80
	.blkb	0x00		;bra8:

	; indexed test

	.radix	x

	adca	minus1,x8	;*L C3 00  [C3 FF]
	adca	zero,x8		;   C3 00  [C3 00]
	adca	two55,x8	;   C3 00  [C3 FF]
	adca	two56,x8	;*L C3 00  [C3 00]

	adcd	minus1,x8	;*L 83 00  [83 FF]
	adcd	zero,x8		;   83 00  [83 00]
	adcd	two55,x8	;   83 00  [83 FF]
	adcd	two56,x8	;*L 83 00  [83 00]

	asl	minus1,x8	;*L 04 00  [04 FF]
	asl	zero,x8		;   04 00  [04 00]
	asl	two55,x8	;   04 00  [04 FF]
	asl	two56,x8	;*L 04 00  [04 00]

	bclr	1234,#minus1	;*L 38 00 12 34  [38 FF 12 34]
	bclr	1234,#zero	;   38 00 12 34  [38 00 12 34]
	bclr	1234,#two55	;   38 00 12 34  [38 FF 12 34]
	bclr	1234,#two56	;*L 38 00 12 34  [38 00 12 34]

	bclr	12,x8,#minus1	;*L 17 08 00 12  [17 08 FF 12]
	bclr	12,x8,#zero	;   17 08 00 12  [17 08 00 12]
	bclr	12,x8,#two55	;   17 08 00 12  [17 08 FF 12]
	bclr	12,x8,#two56	;*L 17 08 00 12  [17 08 00 12]

	bclr	1234,x,#minus1	;*L 08 00 12 34  [08 FF 12 34]
	bclr	1234,x,#zero	;   08 00 12 34  [08 00 12 34]
	bclr	1234,x,#two55	;   08 00 12 34  [08 FF 12 34]
	bclr	1234,x,#two56	;*L 08 00 12 34  [08 00 12 34]

	bclr  minus1,x8,#two55	;*L 17 08 FF FF  [17 08 FF FF]
	bclr  zero,x8,#two55	;   17 08 FF 00  [17 08 FF 00]
	bclr  two55,x8,#two55	;   17 08 FF FF  [17 08 FF FF]
	bclr  two56,x8,#two55	;*L 17 08 FF 00  [17 08 FF 00]

	brset	1234,#minus1,.+16	;*L 3B 00 12 34 00 10
					;  [3B FF 12 34 00 10]
	brset	1234,#zero,.+16		;   3B 00 12 34 00 10
					;  [3B 00 12 34 00 10]
	brset	1234,#two55,.+16	;   3B 00 12 34 00 10
					;  [3B FF 12 34 00 10]
	brset	1234,#two56,.+16	;*L 3B 00 12 34 00 10
					;  [3B 00 12 34 00 10]

	brset	12,x8,#minus1,.+14	;*L 8B 00 12 10  [8B FF 12 10]
	brset	12,x8,#zero,.+14	;   8B 00 12 10  [8B 00 12 10]
	brset	12,x8,#two55,.+14	;   8B 00 12 10  [8B FF 12 10]
	brset	12,x8,#two56,.+14	;*L 8B 00 12 10  [8B 00 12 10]

	brset	1234,x,#minus1,.+16	;*L 09 00 12 34 00 10
					;  [09 FF 12 34 00 10]
	brset	1234,x,#zero,.+16	;   09 00 12 34 00 10
					;  [09 00 12 34 00 10]
	brset	1234,x,#two55,.+16	;   09 00 12 34 00 10
					;  [09 FF 12 34 00 10]
	brset	1234,x,#two56,.+16	;*L 09 00 12 34 00 10
					;  [09 00 12 34 00 10]

	brset	minus1,x8,#two55,.+14	;*L 8B FF FF 10  [8B FF FF 10]
	brset	zero,x8,#two55,.+14	;   8B FF 00 10  [8B FF 00 10]
	brset	two55,x8,#two55,.+14	;   8B FF FF 10  [8B FF FF 10]
	brset	two56,x8,#two55,.+14	;*L 8B FF 00 10  [8B FF 00 10]

	cps	minus1,x8		;*L 4F 00  [4F FF]
	cps	zero,x8			;   4F 00  [4F 00]
	cps	two55,x8		;   4F 00  [4F FF]
	cps	two56,x8		;*L 4F 00  [4F 00]

