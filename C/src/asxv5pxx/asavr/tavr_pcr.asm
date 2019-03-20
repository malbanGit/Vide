	.title	AVR Assembler Tests
	.module	AVR_PCR


	; All this to test the Assembler / Linker PCR relocation processing


	S_AVR = 1			; Process ALL

	S_RJMP_ASSEMBLER = 0		; Asembler Machine Instruction Groups
	S_SBRA_ASSEMBLER = 0

	S_RJMP_LINKER = 0		; Linker Machine Instruction Groups
	S_SBRA_LINKER = 0


	.page
	.sbttl	S_RJMP_ASSEMBLER

.if S_AVR | S_RJMP_ASSEMBLER

.area	A000

	.avr_4K		0	        ; standard mode

L_S_RJMP_ASSEMBLER:

1$:	. = . + 2048
	rjmp	1$			; a	displacement > -2048
2$:	. = . + 2047
	rjmp	2$
3$:	rjmp	3$
	rjmp	4$
4$:	rjmp	5$
	. = . + 2047
5$:	rjmp	7$			; a	displacement > 2048
6$:	. = . + 2048
7$:
	rjmp	xtrn			; Linker Undefined Global


	.avr_4K		1		; 4K mode

L_S_RJMP_ASSEMBLER_1:

1$:	. = . + 2048
	rjmp	1$
2$:	. = . + 2047
	rjmp	2$
3$:	rjmp	3$
	rjmp	4$
4$:	rjmp	5$
	. = . + 2047
5$:	rjmp	7$
6$:	. = . + 2048
7$:
	rjmp	xtrn			; Linker Undefined Global

	.avr_4k		0		; standard mode
.endif


	.page
	.sbttl	S_RJMP_LINKER

.if S_AVR | S_RJMP_LINKER
	.avr_4K		0	        ; standard mode

.area	A001

L_S_RJMP_LINKER:

1$:	. = . + 2048
.area	A002
	rjmp	1$			; Linker PCR error	displacement > -2048
.area	A003
2$:	. = . + 2047
.area	A004
	rjmp	2$
.area	A005
3$:
.area	A006
	rjmp	3$
.area	A007
	rjmp	4$
.area	A008
4$:	rjmp	5$
.area	A009
	. = . + 2047
.area	A010
5$:	rjmp	7$			; Linker PCR error	displacement > 2048
.area	A011
6$:	. = . + 2048
.area	A012
7$:
.area	A013
	rjmp	xtrn			; Linker Undefined Global


	.avr_4K		1		; 4K mode

.area	A101

L_S_RJMP_LINKER_1:

1$:	. = . + 2048
.area	A102
	rjmp	1$
.area	A103
2$:	. = . + 2047
.area	A104
	rjmp	2$
.area	A105
3$:
.area	A106
	rjmp	3$
.area	A107
	rjmp	4$
.area	A108
4$:	rjmp	5$
.area	A109
	. = . + 2047
.area	A110
5$:	rjmp	7$
.area	A111
6$:	. = . + 2048
.area	A112
7$:
.area	A113
	rjmp	xtrn			; Linker Undefined Global

	.avr_4k		0		; standard mode
.endif


	.page
	.sbttl	S_SBRA_ASSEMBLER

.if S_AVR | S_SBRA_ASSEMBLER

.area	B000

L_S_SBRA_ASSEMBLER:

1$:	. = . + 64
	breq	1$			; a	displacement > -64
2$:	. = . + 63
	breq	2$
3$:	breq	3$
	breq	4$
4$:	breq	5$
	. = . + 63
5$:	breq	7$			; a	displacement > 64
6$:	. = . + 64
7$:
	breq	xtrn			; Linker Undefined Global

.endif


	.page
	.sbttl	S_SBRA_LINKER

.if S_AVR | S_SBRA_LINKER

.area	B001

L_S_SBRA_LINKER:

1$:	. = . + 64
.area	B002
	breq	1$			; Linker PCR error	displacement > -64
.area	B003
2$:	. = . + 63
.area	B004
	breq	2$
.area	B005
3$:
.area	B006
	breq	3$
.area	B007
	breq	4$
.area	B008
4$:	breq	5$
.area	B009
	. = . + 63
.area	B010
5$:	breq	7$			; Linker PCR error	displacement > 64
.area	B011
6$:	. = . + 64
.area	B012
7$:
.area	B013
	breq	xtrn			; Linker Undefined Global

.endif

;.end
