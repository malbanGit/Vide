	.title	H8/3xx Assembler Test
	.module	H8s3xx

	;	This is the H8/3xx assembler test package

	;	Assemble this file as follows
	;
	;	ASH8 -glff th8


	.page
	; Examples on Optional / Free Format Modes

	; @ is optional for a label
	; xx16 <-- @xx16
	; xx08 <-- @xx08
	;
	; The address of an undefined (external) variable
	; will use the long form of the address.
	;
	; @ is "not" optional for memory indirect (@@xx08) addressing
	;
	; * is an optional prefix for labels within the last
	;   256 bytes of the address space.  This prefix causes
	;   the form @aa:8 to be selected.  (Because all label
	;   addresses are considered relocatable the form @xx:16
	;   of the addressing mode will be selected by default.)
	;   At link time the value will be checked to be within
	;   the last 256 bytes.
	;
	;   Use .setdp directive to select the area for the direct
	;   variables.  e.g.:
	;			.setdp			;current area
	;			  or
	;			.setdp	0xFF00,DIRECT	;specific area
	;
	;   The * is only useful for the mov and jmp / jsr instructions
	;   as all other instructions donot have an @aa:16 addressing
	;   mode.  All other instructions with the @aa:8 addressing
	;   mode will check for addresses within the last 256 bytes
	;   at assembly or link time.
	;

	; (external global variable)
	mov	@value,r7	;6B 07s00r00
	mov	value,r7	;6B 07s00r00
	; (mov.w has no @aa:8 mode)
	mov	*@value,r7	;6B 07s00r00
	mov	*value,r7	;6B 07s00r00
	mov	#value,r7	;79 07s00r00

	mov	@value,r0L	;6A 08s00r00
	mov	value,r0L	;6A 08s00r00
	mov	*@value,r0L	;28*00
	mov	*value,r0L	;28*00
	mov	#value,r0L	;F8r00

	jsr	@start		;5E 00s00r00
	jsr	start		;5E 00s00r00

begin:	bf	1$		;41 06
	mov	data,r0L	;6A 08s00r3C
	mov	*exdata,r0H	;20*00
1$:	bra	begin		;40 F6
	mov	data,r1L	;6A 09s00r3C
	mov	*exdata,r1H	;21*00
	bra	begin		;40 EE

data:	.byte	0x10		;10
	.even


	.page
	.radix	X

	nn08	=	0x005A

	xx03	=	0x0005
	xx08	=	0xFF5A
	xx16	=	0xA5A5


	; Inherent Instructions

	eepmov			;7B 5C 59 8F
	nop			;00 00
	sleep			;01 80
	rte			;56 70
	rts			;54 70

	; Multiply and Divide

	mulxu.b	r0L,r1		;50 81
	divxu.b	r2L,r3		;51 A3

	mulxu	r0L,r1		;50 81
	divxu	r2L,r3		;51 A3

	; Condition Code Instructions

	stc	ccr,r1L		;02 09
	ldc	r0L,ccr		;03 08

	orc	#nn08,ccr	;04 5A
	xorc	#nn08,ccr	;05 5A
	andc	#nn08,ccr	;06 5A
	ldc	#nn08,ccr	;07 5A

	stc	r1L		;02 09
	ldc	r0L		;03 08

	orc	#nn08		;04 5A
	xorc	#nn08		;05 5A
	andc	#nn08		;06 5A
	ldc	#nn08		;07 5A

	; Jump and Jump to Subroutine Instructions

	jmp	@r6		;59 60
	jmp	@xx16		;5A 00 A5 A5
	jmp	@@nn08		;5B 5A

	jsr	@r6		;5D 60
	jsr	@xx16		;5E 00 A5 A5
	jsr	@@nn08		;5F 5A

	; Branch and Branch to Subroutine Instructions

	bra	.-0x10		;40 EE
	bt	.-0x0E		;40 F0
	brn	.-0x0C		;41 F2
	bf	.-0x0A		;41 F4
	bhi	.-0x08		;42 F6
	bls	.-0x06		;43 F8
	bcc	.-0x04		;44 FA
	bhs	.-0x02		;44 FC
	bcs	.-0x00		;45 FE
	blo	.+0x02		;45 00
	bne	.+0x04		;46 02
	beq	.+0x06		;47 04
	bvc	.+0x08		;48 06
	bvs	.+0x0A		;49 08
	bpl	.+0x0C		;4A 0A
	bmi	.+0x0E		;4B 0C
	bge	.+0x10		;4C 0E
	blt	.+0x12		;4D 10
	bgt	.+0x14		;4E 12
	ble	.+0x16		;4F 14
	bsr	.+0x18		;55 16

	; Shift and Rotate Instructions

	shal.b	r0L		;10 88
	shar.b	r1L		;11 89
	shll.b	r2L		;10 0A
	shlr.b	r3L		;11 0B
	rotxl.b	r4H		;12 04
	rotxr.b	r5H		;13 05
	rotl.b	r6H		;12 86
	rotr.b	r7H		;13 87

	shal	r0L		;10 88
	shar	r1L		;11 89
	shll	r2L		;10 0A
	shlr	r3L		;11 0B
	rotxl	r4H		;12 04
	rotxr	r5H		;13 05
	rotl	r6H		;12 86
	rotr	r7H		;13 87

	; Bit Manipulation Instructions

	bst	#xx03,r0L	;67 58
	bst	#xx03,@r1	;7D 10 67 50
	bst	#xx03,@xx08	;7F*5A 67 50

	bist	#xx03,r0L	;67 D8
	bist	#xx03,@r1	;7D 10 67 D0
	bist	#xx03,@xx08	;7F*5A 67 D0

	bor	#xx03,r0L	;74 58
	bor	#xx03,@r1	;7C 10 74 50
	bor	#xx03,@xx08	;7E*5A 74 50

	bior	#xx03,r0L	;74 D8
	bior	#xx03,@r1	;7C 10 74 D0
	bior	#xx03,@xx08	;7E*5A 74 D0

	bxor	#xx03,r0L	;75 58
	bxor	#xx03,@r1	;7C 10 75 50
	bxor	#xx03,@xx08	;7E*5A 75 50

	bixor	#xx03,r0L	;75 D8
	bixor	#xx03,@r1	;7C 10 75 D0
	bixor	#xx03,@xx08	;7E*5A 75 D0

	band	#xx03,r0L	;76 58
	band	#xx03,@r1	;7C 10 76 50
	band	#xx03,@xx08	;7E*5A 76 50

	biand	#xx03,r0L	;76 D8
	biand	#xx03,@r1	;7C 10 76 D0
	biand	#xx03,@xx08	;7E*5A 76 D0

	bld	#xx03,r0L	;77 58
	bld	#xx03,@r1	;7C 10 77 50
	bld	#xx03,@xx08	;7E*5A 77 50

	bild	#xx03,r0L	;77 D8
	bild	#xx03,@r1	;7C 10 77 D0
	bild	#xx03,@xx08	;7E*5A 77 D0

	; Extended Bit Manipulation Instructions

	bset	#xx03,r0L	;70 58
	bset	#xx03,@r1	;7D 10 70 50
	bset	#xx03,@xx08	;7F*5A 70 50
	bset	r0L,r2L		;60 8A
	bset	r1L,@r3		;7D 30 60 90
	bset	r2L,@xx08	;7F*5A 60 A0

	bnot	#xx03,r0L	;71 58
	bnot	#xx03,@r1	;7D 10 71 50
	bnot	#xx03,@xx08	;7F*5A 71 50
	bnot	r0L,r2L		;61 8A
	bnot	r1L,@r3		;7D 30 61 90
	bnot	r2L,@xx08	;7F*5A 61 A0

	bclr	#xx03,r0L	;72 58
	bclr	#xx03,@r1	;7D 10 72 50
	bclr	#xx03,@xx08	;7F*5A 72 50
	bclr	r0L,r2L		;62 8A
	bclr	r1L,@r3		;7D 30 62 90
	bclr	r2L,@xx08	;7F*5A 62 A0

	btst	#xx03,r0L	;73 58
	btst	#xx03,@r1	;7D 10 73 50
	btst	#xx03,@xx08	;7F*5A 73 50
	btst	r0L,r2L		;63 8A
	btst	r1L,@r3		;7D 30 63 90
	btst	r2L,@xx08	;7F*5A 63 A0

	; Single Operand byte forms

	inc.b	r0L		;0A 08
	daa.b	r1L		;0F 09
	dec.b	r2L		;1A 0A
	das.b	r3L		;1F 0B
	neg.b	r4L		;17 8C
	not.b	r5L		;17 0D

	inc	r0L		;0A 08
	daa	r1L		;0F 09
	dec	r2L		;1A 0A
	das	r3L		;1F 0B
	neg	r4L		;17 8C
	not	r5L		;17 0D

	; MOV with peripheral clock

	movfpe.b   @xx16,r0L	;6A 48 A5 A5
	movtpe.b   r1L,@xx16	;6A C9 A5 A5

	movfpe	@xx16,r0L	;6A 48 A5 A5
	movtpe	r1L,@xx16	;6A C9 A5 A5

	; POP / PUSH

	push.w	r0		;6D F0
	pop.w	r1		;6D 71

	push	r0		;6D F0
	pop	r1		;6D 71

	; SUB - byte/word forms

	sub.b	r0L,r1L		;18 89
	sub.w	r1,r2		;19 12

	sub	r0L,r1L		;18 89
	sub	r1,r2		;19 12

	; ADDS - word forms

	adds.w	#1,r0		;0B 00
	adds.w	#2,r1		;0B 81

	adds	#1,r0		;0B 00
	adds	#2,r1		;0B 81

	; SUBS - word forms

	subs.w	#1,r0		;1B 00
	subs.w	#2,r1		;1B 81

	subs	#1,r0		;1B 00
	subs	#2,r1		;1B 81

	; ADD - byte/word forms

	add.b	#nn08,r0L	;88 5A
	add.b	r0L,r1L		;08 89
	add.w	r1,r2		;09 12

	add	#nn08,r0L	;88 5A
	add	r0L,r1L		;08 89
	add	r1,r2		;09 12

	; ADDX - byte forms

	addx.b	#nn08,r0L	;98 5A
	addx.b	r0L,r1L		;0E 89

	addx	#nn08,r0L	;98 5A
	addx	r0L,r1L		;0E 89

	; CMP - byte/word forms

	cmp.b	#nn08,r0L	;A8 5A
	cmp.b	r0L,r1L		;1C 89
	cmp.w	r1,r2		;1D 12

	cmp	#nn08,r0L	;A8 5A
	cmp	r0L,r1L		;1C 89
	cmp	r1,r2		;1D 12

	; SUBX - byte forms

	subx.b	#nn08,r0L	;B8 5A
	subx.b	r0L,r1L		;1E 89

	subx	#nn08,r0L	;B8 5A
	subx	r0L,r1L		;1E 89

	; OR - byte forms

	or.b	#nn08,r0L	;C8 5A
	or.b	r0L,r1L		;14 89
	or.b	#nn08,ccr	;04 5A

	or	#nn08,r0L	;C8 5A
	or	r0L,r1L		;14 89
	or	#nn08,ccr	;04 5A

	; XOR - byte forms

	xor.b	#nn08,r0L	;D8 5A
	xor.b	r0L,r1L		;15 89
	xor.b	#nn08,ccr	;05 5A

	xor	#nn08,r0L	;D8 5A
	xor	r0L,r1L		;15 89
	xor	#nn08,ccr	;05 5A

	; AND - byte forms

	and.b	#nn08,r0L	;E8 5A
	and.b	r0L,r1L		;16 89
	and.b	#nn08,ccr	;06 5A

	and	#nn08,r0L	;E8 5A
	and	r0L,r1L		;16 89
	and	#nn08,ccr	;06 5A

	; MOV - byte modes

	mov.b	#nn08,r0L	;F8 5A
	mov.b	r0L,r1L		;0C 89
	mov.b	@r1,r2L		;68 1A
	mov.b	@[xx16,r2],r3L	;6E 2B A5 A5
	mov.b	@r3+,r4L	;6C 3C
	mov.b	@xx08,r5L	;2D*5A
	mov.b	@xx16,r6L	;6A 0E A5 A5

	mov.b	r0H,@r0		;68 80
	mov.b	r1H,@[xx16,r1]	;6E 91 A5 A5
	mov.b	r2H,@-r2	;6C A2
	mov.b	r3H,@xx08	;33*5A
	mov.b	r4H,@xx16	;6A 84 A5 A5

	; MOV - free form byte modes

	mov	#nn08,r0L	;F8 5A
	mov	r0L,r1L		;0C 89
	mov	@r1,r2L		;68 1A
	mov	@[xx16,r2],r3L	;6E 2B A5 A5
	mov	@r3+,r4L	;6C 3C
	mov	@xx08,r5L	;2D*5A
	mov	@xx16,r6L	;6A 0E A5 A5

	mov	r0H,@r0		;68 80
	mov	r1H,@[xx16,r1]	;6E 91 A5 A5
	mov	r2H,@-r2	;6C A2
	mov	r3H,@xx08	;33*5A
	mov	r4H,@xx16	;6A 84 A5 A5

	; MOV - word modes

	mov.w	#xx16,r0	;79 00 A5 A5
	mov.w	r0,r1		;0D 01
	mov.w	@r1,r2		;69 12
	mov.w	@[xx16,r2],r3	;6F 23 A5 A5
	mov.w	@r3+,r4		;6D 34
	mov.w	@xx16,r5	;6B 05 A5 A5
	mov.w	r4,@r6		;69 E4
	mov.w	r5,@[xx16,r7]	;6F F5 A5 A5
	mov.w	r6,@-r0		;6D 86
	mov.w	r7,@xx16	;6B 87 A5 A5

	; MOV - free form word modes

	mov	#xx16,r0	;79 00 A5 A5
	mov	r0,r1		;0D 01
	mov	@r1,r2		;69 12
	mov	@[xx16,r2],r3	;6F 23 A5 A5
	mov	@r3+,r4		;6D 34
	mov	@xx16,r5	;6B 05 A5 A5
	mov	r4,@r6		;69 E4
	mov	r5,@[xx16,r7]	;6F F5 A5 A5
	mov	r6,@-r0		;6D 86
	mov	r7,@xx16	;6B 87 A5 A5

	.page

	; Register sequencing for each instruction type

	; S_OPS

	adds	#1,r0		;0B 00
	adds	#1,r7		;0B 07
	adds	#1,sp		;0B 07

	; S_OPX

	addx	#nn08,r0H	;90 5A
	addx	#nn08,r7H	;97 5A
	addx	#nn08,r0L	;98 5A
	addx	#nn08,r7L	;9F 5A

	addx	#nn08,spH	;97 5A
	addx	#nn08,spL	;9F 5A

	addx	r0H,r0H		;0E 00
	addx	r7H,r0H		;0E 70
	addx	r0L,r0H		;0E 80
	addx	r7L,r0H		;0E F0

	addx	spH,r0H		;0E 70
	addx	spL,r0H		;0E F0

	addx	r0H,r0H		;0E 00
	addx	r0H,r7H		;0E 07
	addx	r0H,r0L		;0E 08
	addx	r0H,r7L		;0E 0F

	addx	r0H,spH		;0E 07
	addx	r0H,spL		;0E 0F

	; S_OP

	and	#nn08,r0H	;E0 5A
	and	#nn08,r7H	;E7 5A
	and	#nn08,r0L	;E8 5A
	and	#nn08,r7L	;EF 5A

	and	#nn08,spH	;E7 5A
	and	#nn08,spL	;EF 5A

	and	r0H,r0H		;16 00
	and	r7H,r0H		;16 70
	and	r0L,r0H		;16 80
	and	r7L,r0H		;16 F0

	and	spH,r0H		;16 70
	and	spL,r0H		;16 F0

	and	r0H,r0H		;16 00
	and	r0H,r7H		;16 07
	and	r0H,r0L		;16 08
	and	r0H,r7L		;16 0F

	and	r0H,spH		;16 07
	and	r0H,spL		;16 0F

	; S_CMP / S_ADD / S_SUB

	cmp	#nn08,r0H	;A0 5A
	cmp	#nn08,r7H	;A7 5A
	cmp	#nn08,r0L	;A8 5A
	cmp	#nn08,r7L	;AF 5A

	cmp	#nn08,spH	;A7 5A
	cmp	#nn08,spL	;AF 5A

	cmp	r0H,r0H		;1C 00
	cmp	r7H,r0H		;1C 70
	cmp	r0L,r0H		;1C 80
	cmp	r7L,r0H		;1C F0

	cmp	spH,r0H		;1C 70
	cmp	spL,r0H		;1C F0

	cmp	r0H,r0H		;1C 00
	cmp	r0H,r7H		;1C 07
	cmp	r0H,r0L		;1C 08
	cmp	r0H,r7L		;1C 0F

	cmp	r0H,spH		;1C 07
	cmp	r0H,spL		;1C 0F

	cmp	r0,r0		;1D 00
	cmp	r7,r0		;1D 70

	cmp	sp,r0		;1D 70

	cmp	r0,r0		;1D 00
	cmp	r0,r7		;1D 07

	cmp	r0,sp		;1D 07

	; S_MOV		(byte forms)

	mov	r0H,r0H		;0C 00
	mov	r7H,r0H		;0C 70
	mov	r0L,r7H		;0C 87
	mov	r7L,r7H		;0C F7

	mov	spH,r0H		;0C 70
	mov	spL,r7H		;0C F7

	mov	r0H,r0H		;0C 00
	mov	r0H,r7H		;0C 07
	mov	r7H,r0L		;0C 78
	mov	r7H,r7L		;0C 7F

	mov	r0H,spH		;0C 07
	mov	spH,spL		;0C 7F

	mov	#nn08,r0H	;F0 5A
	mov	#nn08,r7H	;F7 5A
	mov	#nn08,r0L	;F8 5A
	mov	#nn08,r7L	;FF 5A

	mov	#nn08,spH	;F7 5A
	mov	#nn08,spL	;FF 5A

	mov	@r0,r0H		;68 00
	mov	@r0,r7H		;68 07
	mov	@r7,r0L		;68 78
	mov	@r7,r7L		;68 7F

	mov	@r0,spH		;68 07
	mov	@sp,spL		;68 7F

	mov	@r0+,r0H	;6C 00
	mov	@r0+,r7H	;6C 07
;	mov	@r7+,r0L	;6C 78 (illegal)
;	mov	@r7+,r7L	;6C 7F (illegal)

	mov	@r0+,spH	;6C 07
;	mov	@sp+,spL	;6C 7F (illegal)

	mov	@[xx16,r0],r0H	;6E 00 A5 A5
	mov	@[xx16,r0],r7H	;6E 07 A5 A5
	mov	@[xx16,r7],r0L	;6E 78 A5 A5
	mov	@[xx16,r7],r7L	;6E 7F A5 A5

	mov	@[xx16,r0],spH	;6E 07 A5 A5
	mov	@[xx16,sp],spL	;6E 7F A5 A5

	mov	@xx08,r0H	;20*5A
	mov	@xx08,r7H	;27*5A
	mov	@xx08,r0L	;28*5A
	mov	@xx08,r7L	;2F*5A

	mov	@xx08,spH	;27*5A
	mov	@xx08,spL	;2F*5A

	mov	@xx16,r0H	;6A 00 A5 A5
	mov	@xx16,r7H	;6A 07 A5 A5
	mov	@xx16,r0L	;6A 08 A5 A5
	mov	@xx16,r7L	;6A 0F A5 A5

	mov	@xx16,spH	;6A 07 A5 A5
	mov	@xx16,spL	;6A 0F A5 A5

	mov	r0H,@r0		;68 80
	mov	r7H,@r0		;68 87
	mov	r0L,@r7		;68 F8
	mov	r7L,@r7		;68 FF

	mov	spH,@r0		;68 87
	mov	spL,@sp		;68 FF

	mov	r0H,@-r0	;6C 80
	mov	r7H,@-r0	;6C 87
;	mov	r0L,@-r7	;6C F8 (illegal)
;	mov	r7L,@-r7	;6C FF (illegal)

	mov	spH,@-r0	;6C 87
;	mov	spL,@-sp	;6C FF (illegal)

	mov	r0H,@[xx16,r0]	;6E 80 A5 A5
	mov	r7H,@[xx16,r0]	;6E 87 A5 A5
	mov	r0L,@[xx16,r7]	;6E F8 A5 A5
	mov	r7L,@[xx16,r7]	;6E FF A5 A5

	mov	spH,@[xx16,r0]	;6E 87 A5 A5
	mov	spL,@[xx16,sp]	;6E FF A5 A5

	mov	r0H,@xx08	;30*5A
	mov	r7H,@xx08	;37*5A
	mov	r0L,@xx08	;38*5A
	mov	r7L,@xx08	;3F*5A

	mov	spH,@xx08	;37*5A
	mov	spL,@xx08	;3F*5A

	mov	r0H,@xx16	;6A 80 A5 A5
	mov	r7H,@xx16	;6A 87 A5 A5
	mov	r0L,@xx16	;6A 88 A5 A5
	mov	r7L,@xx16	;6A 8F A5 A5

	mov	spH,@xx16	;6A 87 A5 A5
	mov	spL,@xx16	;6A 8F A5 A5

	; S_MOV		(word forms)

	mov	r0,r0		;0D 00
	mov	r7,r0		;0D 70
	mov	r7,r7		;0D 77

	mov	sp,r0		;0D 70
	mov	sp,sp		;0D 77

	mov	#xx16,r0	;79 00 A5 A5
	mov	#xx16,r7	;79 07 A5 A5

	mov	#xx16,sp	;79 07 A5 A5

	mov	@r0,r0		;69 00
	mov	@r0,r7		;69 07
	mov	@r7,r7		;69 77

	mov	@r0,sp		;69 07
	mov	@sp,sp		;69 77

	mov	@r0+,r0		;6D 00
	mov	@r0+,r7		;6D 07
	mov	@r7+,r7		;6D 77

	mov	@r0+,sp		;6D 07
	mov	@sp+,sp		;6D 77

	mov	@[xx16,r0],r0	;6F 00 A5 A5
	mov	@[xx16,r0],r7	;6F 07 A5 A5
	mov	@[xx16,r7],r7	;6F 77 A5 A5

	mov	@[xx16,r0],sp	;6F 07 A5 A5
	mov	@[xx16,sp],sp	;6F 77 A5 A5

	mov	@xx16,r0	;6B 00 A5 A5
	mov	@xx16,r7	;6B 07 A5 A5

	mov	@xx16,sp	;6B 07 A5 A5

	mov	r0,@r0		;69 80
	mov	r7,@r0		;69 87
	mov	r7,@r7		;69 F7

	mov	sp,@r0		;69 87
	mov	sp,@sp		;69 F7

	mov	r0,@-r0		;6D 80
	mov	r7,@-r0		;6D 87
	mov	r7,@-r7		;6D F7

	mov	sp,@-r0		;6D 87
	mov	sp,@-sp		;6D F7

	mov	r0,@[xx16,r0]	;6F 80 A5 A5
	mov	r7,@[xx16,r0]	;6F 87 A5 A5
	mov	r7,@[xx16,r7]	;6F F7 A5 A5

	mov	sp,@[xx16,r0]	;6F 87 A5 A5
	mov	sp,@[xx16,sp]	;6F F7 A5 A5

	mov	r0,@xx16	;6B 80 A5 A5
	mov	r7,@xx16	;6B 87 A5 A5

	mov	sp,@xx16	;6B 87 A5 A5

	; S_SOP

	daa	r0H		;0F 00
	daa	r7H		;0F 07
	daa	r0L		;0F 08
	daa	r7L		;0F 0F

	daa	spH		;0F 07
	daa	spL		;0F 0F

	; S_CCR

	ldc	r0H		;03 00
	ldc	r7H		;03 07
	ldc	r0L		;03 08
	ldc	r7L		;03 0F

	ldc	spH		;03 07
	ldc	spL		;03 0F

	stc	r0H		;02 00
	stc	r7H		;02 07
	stc	r0L		;02 08
	stc	r7L		;02 0F

	stc	spH		;02 07
	stc	spL		;02 0F

	; S_MLDV

	mulxu	r0H,r0		;50 00
	mulxu	r7H,r0		;50 70
	mulxu	r0L,r7		;50 87
	mulxu	r7L,r7		;50 F7

	mulxu	spH,r0		;50 70
	mulxu	spL,r7		;50 F7

	; S_ROSH

	rotl	r0H		;12 80
	rotl	r7H		;12 87
	rotl	r0L		;12 88
	rotl	r7L		;12 8F

	rotl	spH		;12 87
	rotl	spL		;12 8F

	; S_PP

	push	r0		;6D F0
	push	r7		;6D F7

	push	sp		;6D F7

	; S_MVFPE

	movfpe	@xx16,r0H	;6A 40 A5 A5
	movfpe	@xx16,r7H	;6A 47 A5 A5
	movfpe	@xx16,r0L	;6A 48 A5 A5
	movfpe	@xx16,r7L	;6A 4F A5 A5

	movfpe	@xx16,spH	;6A 47 A5 A5
	movfpe	@xx16,spL	;6A 4F A5 A5

	; S_MVFPE

	movtpe	r0H,@xx16	;6A C0 A5 A5
	movtpe	r7H,@xx16	;6A C7 A5 A5
	movtpe	r0L,@xx16	;6A C8 A5 A5
	movtpe	r7L,@xx16	;6A CF A5 A5

	movtpe	spH,@xx16	;6A C7 A5 A5
	movtpe	spL,@xx16	;6A CF A5 A5

	; S_JXX

	jsr	@r0		;5D 00
	jsr	@r7		;5D 70

	jsr	@sp		;5D 70

	; S_BIT1

	bset	#xx03,r0H	;70 50
	bset	#xx03,r7H	;70 57
	bset	#xx03,r0L	;70 58
	bset	#xx03,r7L	;70 5F

	bset	#xx03,spH	;70 57
	bset	#xx03,spL	;70 5F

	bset	#xx03,@r0	;7D 00 70 50
	bset	#xx03,@r7	;7D 70 70 50

	bset	#xx03,@sp	;7D 70 70 50

	bset	r0H,r0H		;60 00
	bset	r7H,r0H		;60 70
	bset	r0L,r7H		;60 87
	bset	r7L,r7H		;60 F7

	bset	spH,r0H		;60 70
	bset	r0L,spH		;60 87

	bset	r0H,r0H		;60 00
	bset	r0H,r7H		;60 07
	bset	r7H,r0L		;60 78
	bset	r7H,r7L		;60 7F

	bset	r0H,spH		;60 07
	bset	spH,r0L		;60 78

	bset	r0H,@r0		;7D 00 60 00
	bset	r7H,@r0		;7D 00 60 70
	bset	r0L,@r7		;7D 70 60 80
	bset	r7L,@r7		;7D 70 60 F0

	bset	spH,@r0		;7D 00 60 70
	bset	spL,@sp		;7D 70 60 F0

	bset	r0H,@xx08	;7F*5A 60 00
	bset	r7H,@xx08	;7F*5A 60 70
	bset	r0L,@xx08	;7F*5A 60 80
	bset	r7L,@xx08	;7F*5A 60 F0

	bset	spH,@xx08	;7F*5A 60 70
	bset	spL,@xx08	;7F*5A 60 F0

	; S_BIT2

	bst	#xx03,r0H	;67 50
	bst	#xx03,r7H	;67 57
	bst	#xx03,r0L	;67 58
	bst	#xx03,r7L	;67 5F

	bst	#xx03,spH	;67 57
	bst	#xx03,spL	;67 5F

	bst	#xx03,@r0	;7D 00 67 50
	bst	#xx03,@r7	;7D 70 67 50

	bst	#xx03,@sp	;7D 70 67 50

	; End of ASH8 Test Program
