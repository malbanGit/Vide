	.title	AS430 Assembler Checks

	; Assembler this file:
	;
	;	as430 -gloaxff t430
	;
	;
	; A Destination Mode of #N is considered
	; an addressing syntax error. The code generated
	; defaults to an absolute address of N.
	;

	.area	AS430	(ABS,OVR)
	.org	0x0000


	.sbttl	'DOP' Instruction Tests

	; Test Addressing Modes for Dual Operand Instructions
	
	.sbttl	Quick WORD DOP Check

DOP:	; Check all Registers
	mov	r0,	r15		; 0F 40
	mov	r1,	r15		; 0F 41
	mov	r2,	r15		; 0F 42
	mov	r3,	r15		; 0F 43
	mov	r4,	r15		; 0F 44
	mov	r5,	r15		; 0F 45
	mov	r6,	r15		; 0F 46
	mov	r7,	r15		; 0F 47
	mov	r8,	r15		; 0F 48
	mov	r9,	r15		; 0F 49
	mov	r10,	r15		; 0F 4A
	mov	r11,	r15		; 0F 4B
	mov	r12,	r15		; 0F 4C
	mov	r13,	r15		; 0F 4D
	mov	r14,	r15		; 0F 4E
	mov	r15,	r15		; 0F 4F

	mov	pc,	r15		; 0F 40
	mov	sp,	r15		; 0F 41
	mov	sr,	r15		; 0F 42
	mov	cg1,	r15		; 0F 42
	mov	cg2,	r15		; 0F 43

	mov	r15,	r0		; 00 4F
	mov	r15,	r1		; 01 4F
	mov	r15,	r2		; 02 4F
	mov	r15,	r3		; 03 4F
	mov	r15,	r4		; 04 4F
	mov	r15,	r5		; 05 4F
	mov	r15,	r6		; 06 4F
	mov	r15,	r7		; 07 4F
	mov	r15,	r8		; 08 4F
	mov	r15,	r9		; 09 4F
	mov	r15,	r10		; 0A 4F
	mov	r15,	r11		; 0B 4F
	mov	r15,	r12		; 0C 4F
	mov	r15,	r13		; 0D 4F
	mov	r15,	r14		; 0E 4F
	mov	r15,	r15		; 0F 4F

	mov	r15,	pc		; 00 4F
	mov	r15,	sp		; 01 4F
	mov	r15,	sr		; 02 4F
	mov	r15,	cg1		; 02 4F
	mov	r15,	cg2		; 03 4F

	; Special Constants Mode to Register R15
1$:	mov	#4,	r15		; 2F 42
	mov	#8,	r15		; 3F 42
	mov	#0,	r15		; 0F 43
	mov	#1,	r15		; 1F 43
	mov	#2,	r15		; 2F 43
	mov	#-1,	r15		; 3F 43

	; All Addressing Modes to Register r15
	mov	r5,	r15		; 0F 45
	mov	0x2(r5),r15		; 1F 45 02 00
	mov	1$,	r15		; 1F 40 EC FF
	mov	&1$,	r15		; 1F 42r54s00
	mov	@r5,	r15		; 2F 45
	mov	@r5+,	r15		; 3F 45
	mov	#0x3412,r15		; 3F 40 12 34

	; Alternate Forms
	mov	(r5),	r15		; 2F 45
	mov	(r5)+,	r15		; 3F 45

	mov	(pc)+,	r15		; 3F 40
2$:	.word	0x3412			; 12 34


	.sbttl	All Normal Modes with R4/R8

	; Special Constants Mode to Register R4
3$:	mov	#4,	r4		; 24 42
	mov	#8,	r4		; 34 42
	mov	#0,	r4		; 04 43
	mov	#1,	r4		; 14 43
	mov	#2,	r4		; 24 43
	mov	#-1,	r4		; 34 43

	; All Addressing Modes to Register R4
	mov	r5,	r4		; 04 45
	mov	0x2(r5),r4		; 14 45 02 00
	mov	3$,	r4		; 14 40 EC FF
	mov	&3$,	r4		; 14 42r7Es00
	mov	@r5,	r4		; 24 45
	mov	@r5+,	r4		; 34 45
	mov	#0x3412,r4		; 34 40 12 34

	; Special Constants Mode to Register 0x7856(R4)
	mov	#4,	0x7856(r4)	; A4 42 56 78
	mov	#8,	0x7856(r4)	; B4 42 56 78
	mov	#0,	0x7856(r4)	; 84 43 56 78
	mov	#1,	0x7856(r4)	; 94 43 56 78
	mov	#2,	0x7856(r4)	; A4 43 56 78
	mov	#-1,	0x7856(r4)	; B4 43 56 78

	; All Addressing Modes to X(r4)
	mov	r5,	0x7856(r4)	; 84 45 56 78
	mov	0x2(r5),0x7856(r4)	; 94 45 02 00 56 78
	mov	3$,	0x7856(r4)	; 94 40 BA FF 56 78
	mov	&3$,	0x7856(r4)	; 94 42r7Es00 56 78
	mov	@r5,	0x7856(r4)	; A4 45 56 78
	mov	@r5+,	0x7856(r4)	; B4 45 56 78
	mov	#0x3412,0x7856(r4)	; B4 40 12 34 56 78

	; Special Constants Mode to Register R8
4$:	mov	#4,	r8		; 28 42
	mov	#8,	r8		; 38 42
	mov	#0,	r8		; 08 43
	mov	#1,	r8		; 18 43
	mov	#2,	r8		; 28 43
	mov	#-1,	r8		; 38 43

	; All Addressing Modes to Register R8
	mov	r5,	r8		; 08 45
	mov	0x2(r5),r8		; 18 45 02 00
	mov	4$,	r8		; 18 40 EC FF
	mov	&4$,	r8		; 18 42rDCs00
	mov	@r5,	r8		; 28 45
	mov	@r5+,	r8		; 38 45
	mov	#0x3412,r8		; 38 40 12 34

	; Special Constants Mode to Register 0x7856(R8)
	mov	#4,	0x7856(r8)	; A8 42 56 78
	mov	#8,	0x7856(r8)	; B8 42 56 78
	mov	#0,	0x7856(r8)	; 88 43 56 78
	mov	#1,	0x7856(r8)	; 98 43 56 78
	mov	#2,	0x7856(r8)	; A8 43 56 78
	mov	#-1,	0x7856(r8)	; B8 43 56 78

	; All Addressing Modes to X(r8)
	mov	r5,	0x7856(r8)	; 88 45 56 78
	mov	0x2(r5),0x7856(r8)	; 98 45 02 00 56 78
	mov	4$,	0x7856(r8)	; 98 40 BA FF 56 78
	mov	&4$,	0x7856(r8)	; 98 42rDCs00 56 78
	mov	@r5,	0x7856(r8)	; A8 45 56 78
	mov	@r5+,	0x7856(r8)	; B8 45 56 78
	mov	#0x3412,0x7856(r8)	; B8 40 12 34 56 78

	; Special Constants Mode to 6$
	mov	#4,	6$		; A0 42 78 00
	mov	#8,	6$		; B0 42 74 00
	mov	#0,	6$		; 80 43 70 00
	mov	#1,	6$		; 90 43 6C 00
	mov	#2,	6$		; A0 43 68 00
	mov	#-1,	6$		; B0 43 64 00

	; All Addressing Modes to 6$
	mov	r5,	6$		; 80 45 60 00
	mov	0x2(r5),6$		; 90 45 02 00 5A 00
	mov	5$,	6$		; 90 40 54 00 54 00
	mov	&5$,	6$		; 90 42rB2s01 4E 00
	mov	@r5,	6$		; A0 45 4A 00
	mov	@r5+,	6$		; B0 45 46 00
	mov	#0x3412,6$		; B0 40 12 34 40 00

	; Special Constants Mode to &6$
	mov	#4,	&6$		; A2 42rB4s01
	mov	#8,	&6$		; B2 42rB4s01
	mov	#0,	&6$		; 82 43rB4s01
	mov	#1,	&6$		; 92 43rB4s01
	mov	#2,	&6$		; A2 43rB4s01
	mov	#-1,	&6$		; B2 43rB4s01

	; All Addressing Modes to &6$
	mov	r5,	&6$		; 82 45rB4s01
	mov	0x2(r5),&6$		; 92 45 02 00rB4s01
	mov	5$,	&6$		; 92 40 18 00rB4s01
	mov	&5$,	&6$		; 92 42rB2s01rB4s01
	mov	@r5,	&6$		; A2 45rB4s01
	mov	@r5+,	&6$		; B2 45rB4s01
	mov	#0x3412,&6$		; B2 40 12 34rB4s01

5$:	.word	0			; 00 00
6$:	.word	0			; 00 00


	.sbttl	Emulated Modes with R4/R8

	; Special Constants Mode to @r4
7$:	mov	#4,	@r4		; A4 42 00 00
	mov	#8,	@r4		; B4 42 00 00
	mov	#0,	@r4		; 84 43 00 00
	mov	#1,	@r4		; 94 43 00 00
	mov	#2,	@r4		; A4 43 00 00
	mov	#-1,	@r4		; B4 43 00 00

	; All Addressing Modes to @r4
	mov	r5,	@r4		; 84 45 00 00
	mov	0x2(r5),@r4		; 94 45 02 00 00 00
	mov	7$,	@r4		; 94 40 DC FF 00 00
	mov	&7$,	@r4		; 94 42rB6s01 00 00
	mov	@r5,	@r4		; A4 45 00 00
	mov	@r5+,	@r4		; B4 45 00 00
	mov	#0x3412,@r4		; B4 40 12 34 00 00

	; Special Constants Mode to @r4+
	mov	#4,	@r4+		; A4 42 00 00 24 53
	mov	#8,	@r4+		; B4 42 00 00 24 53
	mov	#0,	@r4+		; 84 43 00 00 24 53
	mov	#1,	@r4+		; 94 43 00 00 24 53
	mov	#2,	@r4+		; A4 43 00 00 24 53
	mov	#-1,	@r4+		; B4 43 00 00 24 53

	; All Addressing Modes to @r4+
	mov	r5,	@r4+		; 84 45 00 00 24 53
	mov	0x2(r5),@r4+		; 94 45 02 00 00 00
	mov	7$,	@r4+		; 94 40 90 FF 00 00
	mov	&7$,	@r4+		; 94 42rB6s01 00 00
	mov	@r5,	@r4+		; A4 45 00 00 24 53
	mov	@r5+,	@r4+		; B4 45 00 00 24 53
	mov	#0x3412,@r4+		; B4 40 12 34 00 00

	; Special Constants Mode to @r8
8$:	mov	#4,	@r8		; A8 42 00 00
	mov	#8,	@r8		; B8 42 00 00
	mov	#0,	@r8		; 88 43 00 00
	mov	#1,	@r8		; 98 43 00 00
	mov	#2,	@r8		; A8 43 00 00
	mov	#-1,	@r8		; B8 43 00 00

	; All Addressing Modes to @r8
	mov	r5,	@r8		; 88 45 00 00
	mov	0x2(r5),@r8		; 98 45 02 00 00 00
	mov	8$,	@r8		; 98 40 DC FF 00 00
	mov	&8$,	@r8		; 98 42r48s02 00 00
	mov	@r5,	@r8		; A8 45 00 00
	mov	@r5+,	@r8		; B8 45 00 00
	mov	#0x3412,@r8		; B8 40 12 34 00 00

	; Special Constants Mode to @r8+
	mov	#4,	@r8+		; A8 42 00 00 28 53
	mov	#8,	@r8+		; B8 42 00 00 28 53
	mov	#0,	@r8+		; 88 43 00 00 28 53
	mov	#1,	@r8+		; 98 43 00 00 28 53
	mov	#2,	@r8+		; A8 43 00 00 28 53
	mov	#-1,	@r8+		; B8 43 00 00 28 53

	; All Addressing Modes to @r8+
	mov	r5,	@r8+		; 88 45 00 00 28 53
	mov	0x2(r5),@r8+		; 98 45 02 00 00 00
	mov	8$,	@r8+		; 98 40 90 FF 00 00
	mov	&8$,	@r8+		; 98 42r48s02 00 00
	mov	@r5,	@r8+		; A8 45 00 00 28 53
	mov	@r5+,	@r8+		; B8 45 00 00 28 53
	mov	#0x3412,@r8+		; B8 40 12 34 00 00


	.sbttl	Quick BYTE DOP Check

	; Check all Registers
	mov.b	r0,	r15		; 4F 40
	mov.b	r1,	r15		; 4F 41
	mov.b	r2,	r15		; 4F 42
	mov.b	r3,	r15		; 4F 43
	mov.b	r4,	r15		; 4F 44
	mov.b	r5,	r15		; 4F 45
	mov.b	r6,	r15		; 4F 46
	mov.b	r7,	r15		; 4F 47
	mov.b	r8,	r15		; 4F 48
	mov.b	r9,	r15		; 4F 49
	mov.b	r10,	r15		; 4F 4A
	mov.b	r11,	r15		; 4F 4B
	mov.b	r12,	r15		; 4F 4C
	mov.b	r13,	r15		; 4F 4D
	mov.b	r14,	r15		; 4F 4E
	mov.b	r15,	r15		; 4F 4F

	mov.b	pc,	r15		; 4F 40
	mov.b	sp,	r15		; 4F 41
	mov.b	sr,	r15		; 4F 42
	mov.b	cg1,	r15		; 4F 42
	mov.b	cg2,	r15		; 4F 43

	mov.b	r15,	r0		; 40 4F
	mov.b	r15,	r1		; 41 4F
	mov.b	r15,	r2		; 42 4F
	mov.b	r15,	r3		; 43 4F
	mov.b	r15,	r4		; 44 4F
	mov.b	r15,	r5		; 45 4F
	mov.b	r15,	r6		; 46 4F
	mov.b	r15,	r7		; 47 4F
	mov.b	r15,	r8		; 48 4F
	mov.b	r15,	r9		; 49 4F
	mov.b	r15,	r10		; 4A 4F
	mov.b	r15,	r11		; 4B 4F
	mov.b	r15,	r12		; 4C 4F
	mov.b	r15,	r13		; 4D 4F
	mov.b	r15,	r14		; 4E 4F
	mov.b	r15,	r15		; 4F 4F

	mov.b	r15,	pc		; 40 4F
	mov.b	r15,	sp		; 41 4F
	mov.b	r15,	sr		; 42 4F
	mov.b	r15,	cg1		; 42 4F
	mov.b	r15,	cg2		; 43 4F

	; Special Constants Mode to Register R15
11$:	mov.b	#4,	r15		; 6F 42
	mov.b	#8,	r15		; 7F 42
	mov.b	#0,	r15		; 4F 43
	mov.b	#1,	r15		; 5F 43
	mov.b	#2,	r15		; 6F 43
	mov.b	#-1,	r15		; 7F 43

	; All Addressing Modes to Register r15
	mov.b	r5,	r15		; 4F 45
	mov.b	0x2(r5),r15		; 5F 45 02 00
	mov.b	11$,	r15		; 5F 40 EC FF
	mov.b	&11$,	r15		; 5F 42r2Es03
	mov.b	@r5,	r15		; 6F 45
	mov.b	@r5+,	r15		; 7F 45
	mov.b	#0x3412,r15		; 7F 40 12 34

	; Alternate Forms
	mov.b	(r5),	r15		; 6F 45
	mov.b	(r5)+,	r15		; 7F 45

	mov.b	(pc)+,	r15		; 7F 40
12$:	.word	0x3412			; 12 34


	.sbttl	All Normal Modes with R4/R8

	; Special Constants Mode to Register R4
13$:	mov.b	#4,	r4		; 64 42
	mov.b	#8,	r4		; 74 42
	mov.b	#0,	r4		; 44 43
	mov.b	#1,	r4		; 54 43
	mov.b	#2,	r4		; 64 43
	mov.b	#-1,	r4		; 74 43

	; All Addressing Modes to Register R4
	mov.b	r5,	r4		; 44 45
	mov.b	0x2(r5),r4		; 54 45 02 00
	mov.b	13$,	r4		; 54 40 EC FF
	mov.b	&13$,	r4		; 54 42r58s03
	mov.b	@r5,	r4		; 64 45
	mov.b	@r5+,	r4		; 74 45
	mov.b	#0x3412,r4		; 74 40 12 34

	; Special Constants Mode to Register 0x7856(R4)
	mov.b	#4,	0x7856(r4)	; E4 42 56 78
	mov.b	#8,	0x7856(r4)	; F4 42 56 78
	mov.b	#0,	0x7856(r4)	; C4 43 56 78
	mov	#1,	0x7856(r4)	; 94 43 56 78
	mov.b	#2,	0x7856(r4)	; E4 43 56 78
	mov.b	#-1,	0x7856(r4)	; F4 43 56 78

	; All Addressing Modes to X(r4)
	mov.b	r5,	0x7856(r4)	; C4 45 56 78
	mov.b	0x2(r5),0x7856(r4)	; D4 45 02 00 56 78
	mov.b	13$,	0x7856(r4)	; D4 40 BA FF 56 78
	mov.b	&13$,	0x7856(r4)	; D4 42r58s03 56 78
	mov.b	@r5,	0x7856(r4)	; E4 45 56 78
	mov.b	@r5+,	0x7856(r4)	; F4 45 56 78
	mov.b	#0x3412,0x7856(r4)	; F4 40 12 34 56 78

	; Special Constants Mode to Register R8
14$:	mov.b	#4,	r8		; 68 42
	mov.b	#8,	r8		; 78 42
	mov.b	#0,	r8		; 48 43
	mov.b	#1,	r8		; 58 43
	mov.b	#2,	r8		; 68 43
	mov.b	#-1,	r8		; 78 43

	; All Addressing Modes to Register R8
	mov.b	r5,	r8		; 48 45
	mov.b	0x2(r5),r8		; 58 45 02 00
	mov.b	14$,	r8		; 58 40 EC FF
	mov.b	&14$,	r8		; 58 42rB6s03
	mov.b	@r5,	r8		; 68 45
	mov.b	@r5+,	r8		; 78 45
	mov.b	#0x3412,r8		; 78 40 12 34

	; Special Constants Mode to Register 0x7856(R8)
	mov.b	#4,	0x7856(r8)	; E8 42 56 78
	mov.b	#8,	0x7856(r8)	; F8 42 56 78
	mov.b	#0,	0x7856(r8)	; C8 43 56 78
	mov.b	#1,	0x7856(r8)	; D8 43 56 78
	mov.b	#2,	0x7856(r8)	; E8 43 56 78
	mov.b	#-1,	0x7856(r8)	; F8 43 56 78

	; All Addressing Modes to X(r8)
	mov.b	r5,	0x7856(r8)	; C8 45 56 78
	mov.b	0x2(r5),0x7856(r8)	; D8 45 02 00 56 78
	mov.b	4$,	0x7856(r8)	; D8 40 E0 FC 56 78
	mov.b	&14$,	0x7856(r8)	; D8 42rB6s03 56 78
	mov.b	@r5,	0x7856(r8)	; E8 45 56 78
	mov.b	@r5+,	0x7856(r8)	; F8 45 56 78
	mov.b	#0x3412,0x7856(r8)	; F8 40 12 34 56 78

	; Special Constants Mode to 6$
	mov.b	#4,	16$		; E0 42 78 00
	mov.b	#8,	16$		; F0 42 74 00
	mov.b	#0,	16$		; C0 43 70 00
	mov.b	#1,	16$		; D0 43 6C 00
	mov.b	#2,	16$		; E0 43 68 00
	mov.b	#-1,	16$		; F0 43 64 00

	; All Addressing Modes to 6$
	mov.b	r5,	16$		; C0 45 60 00
	mov.b	0x2(r5),16$		; D0 45 02 00 5A 00
	mov.b	15$,	16$		; D0 40 54 00 54 00
	mov.b	&15$,	16$		; D0 42r8Cs04 4E 00
	mov.b	@r5,	16$		; E0 45 4A 00
	mov.b	@r5+,	16$		; F0 45 46 00
	mov.b	#0x3412,16$		; F0 40 12 34 40 00

	; Special Constants Mode to &6$
	mov.b	#4,	&16$		; E2 42r8Es04
	mov.b	#8,	&16$		; F2 42r8Es04
	mov.b	#0,	&16$		; C2 43r8Es04
	mov.b	#1,	&16$		; D2 43r8Es04
	mov.b	#2,	&16$		; E2 43r8Es04
	mov.b	#-1,	&16$		; F2 43r8Es04

	; All Addressing Modes to &6$
	mov.b	r5,	&16$		; C2 45r8Es04
	mov.b	0x2(r5),&16$		; D2 45 02 00r8Es04
	mov.b	15$,	&16$		; D2 40 18 00r8Es04
	mov.b	&15$,	&16$		; D2 42r8Cs04r8Es04
	mov.b	@r5,	&16$		; E2 45r8Es04
	mov.b	@r5+,	&16$		; F2 45r8Es04
	mov.b	#0x3412,&16$		; F2 40 12 34r8Es04

15$:	.word	0			; 00 00
16$:	.word	0			; 00 00


	.sbttl	Emulated Modes with R4/R8

	; Special Constants Mode to @r4
17$:	mov.b	#4,	@r4		; E4 42 00 00
	mov.b	#8,	@r4		; F4 42 00 00
	mov.b	#0,	@r4		; C4 43 00 00
	mov.b	#1,	@r4		; D4 43 00 00
	mov.b	#2,	@r4		; E4 43 00 00
	mov.b	#-1,	@r4		; F4 43 00 00

	; All Addressing Modes to @r4
	mov.b	r5,	@r4		; C4 45 00 00
	mov.b	0x2(r5),@r4		; D4 45 02 00 00 00
	mov.b	17$,	@r4		; D4 40 DC FF 00 00
	mov.b	&17$,	@r4		; D4 42r90s04 00 00
	mov.b	@r5,	@r4		; E4 45 00 00
	mov.b	@r5+,	@r4		; F4 45 00 00
	mov.b	#0x3412,@r4		; F4 40 12 34 00 00

	; Special Constants Mode to @r4+
	mov.b	#4,	@r4+		; E4 42 00 00 14 53
	mov.b	#8,	@r4+		; F4 42 00 00 14 53
	mov.b	#0,	@r4+		; C4 43 00 00 14 53
	mov.b	#1,	@r4+		; D4 43 00 00 14 53
	mov.b	#2,	@r4+		; E4 43 00 00 14 53
	mov.b	#-1,	@r4+		; F4 43 00 00 14 53

	; All Addressing Modes to @r4+
	mov.b	r5,	@r4+		; C4 45 00 00 14 53
	mov.b	0x2(r5),@r4+		; D4 45 02 00 00 00
	mov.b	17$,	@r4+		; D4 40 90 FF 00 00
	mov.b	&17$,	@r4+		; D4 42r90s04 00 00
	mov.b	@r5,	@r4+		; E4 45 00 00 14 53
	mov.b	@r5+,	@r4+		; F4 45 00 00 14 53
	mov.b	#0x3412,@r4+		; F4 40 12 34 00 00

	; Special Constants Mode to @r8
18$:	mov.b	#4,	@r8		; E8 42 00 00
	mov.b	#8,	@r8		; F8 42 00 00
	mov.b	#0,	@r8		; C8 43 00 00
	mov.b	#1,	@r8		; D8 43 00 00
	mov.b	#2,	@r8		; E8 43 00 00
	mov.b	#-1,	@r8		; F8 43 00 00

	; All Addressing Modes to @r8
	mov.b	r5,	@r8		; C8 45 00 00
	mov.b	0x2(r5),@r8		; D8 45 02 00 00 00
	mov.b	18$,	@r8		; D8 40 DC FF 00 00
	mov.b	&18$,	@r8		; D8 42r22s05 00 00
	mov.b	@r5,	@r8		; E8 45 00 00
	mov.b	@r5+,	@r8		; F8 45 00 00
	mov.b	#0x3412,@r8		; F8 40 12 34 00 00

	; Special Constants Mode to @r8+
	mov.b	#4,	@r8+		; E8 42 00 00 18 53
	mov.b	#8,	@r8+		; F8 42 00 00 18 53
	mov.b	#0,	@r8+		; C8 43 00 00 18 53
	mov.b	#1,	@r8+		; D8 43 00 00 18 53
	mov.b	#2,	@r8+		; E8 43 00 00 18 53
	mov.b	#-1,	@r8+		; F8 43 00 00 18 53

	; All Addressing Modes to @r8+
	mov.b	r5,	@r8+		; C8 45 00 00 18 53
	mov.b	0x2(r5),@r8+		; D8 45 02 00 00 00
	mov.b	18$,	@r8+		; D8 40 90 FF 00 00
	mov.b	&18$,	@r8+		; D8 42r22s05 00 00
	mov.b	@r5,	@r8+		; E8 45 00 00 18 53
	mov.b	@r5+,	@r8+		; F8 45 00 00 18 53
	mov.b	#0x3412,@r8+		; F8 40 12 34 00 00



	.sbttl	'RLX' Instruction Tests

	; Test Addressing Modes for Single Operand Instructions

	.sbttl	Word RLX Check
	
RLX:	; Check all Registers
	rla	r0			; 00 50
	rla	r1			; 01 51
	rla	r2			; 02 52
	rla	r3			; 03 53
	rla	r4			; 04 54
	rla	r5			; 05 55
	rla	r6			; 06 56
	rla	r7			; 07 57
	rla	r8			; 08 58
	rla	r9			; 09 59
	rla	r10			; 0A 5A
	rla	r11			; 0B 5B
	rla	r12			; 0C 5C
	rla	r13			; 0D 5D
	rla	r14			; 0E 5E
	rla	r15			; 0F 5F

	rla	pc			; 00 50
	rla	sp			; 01 51
	rla	sr			; 02 52
	rla	cg1			; 02 52
	rla	cg2			; 03 53

	; All Addressing Modes
1$:	rla	r5			; 05 55
	rla	0x2(r5)			; 95 55 02 00 02 00
	rla	1$			; 90 50 F6 FF F4 FF
	rla	&1$			; 92 52rDEs05rDEs05
	rla	@r5			; A5 55 00 00
	rla	@r5+			; B5 55 FE FF
;	rla	#0x3412			; 92 52 12 34 12 34

	; Alternate Forms
	rla	(r5)			; A5 55 00 00
	rla	(r5)+			; B5 55 FE FF


	.sbttl	BYTE RLX Check

	; Check all Registers
	rla.b	r0			; 40 50
	rla.b	r1			; 41 51
	rla.b	r2			; 42 52
	rla.b	r3			; 43 53
	rla.b	r4			; 44 54
	rla.b	r5			; 45 55
	rla.b	r6			; 46 56
	rla.b	r7			; 47 57
	rla.b	r8			; 48 58
	rla.b	r9			; 49 59
	rla.b	r10			; 4A 5A
	rla.b	r11			; 4B 5B
	rla.b	r12			; 4C 5C
	rla.b	r13			; 4D 5D
	rla.b	r14			; 4E 5E
	rla.b	r15			; 4F 5F

	rla.b	pc			; 40 50
	rla.b	sp			; 41 51
	rla.b	sr			; 42 52
	rla.b	cg1			; 42 52
	rla.b	cg2			; 43 53

	; All Addressing Modes
11$:	rla.b	r5			; 45 55
	rla.b	0x2(r5)			; D5 55 02 00 02 00
	rla.b	11$			; D0 50 F6 FF F4 FF
	rla.b	&11$			; D2 52r2Cs06r2Cs06
	rla.b	@r5			; E5 55 00 00
	rla.b	@r5+			; F5 55 FF FF
;	rla.b	#0x3412			; D2 52 12 34 12 34

	; Alternate Forms
	rla.b	(r5)			; E5 55 00 00
	rla.b	(r5)+			; F5 55 FF FF



	.sbttl	'BRA' Instruction Tests

BRA:	; Check all Registers
	bra	r0			; 00 40
	bra	r1			; 00 41
	bra	r2			; 00 42
	bra	r3			; 00 43
	bra	r4			; 00 44
	bra	r5			; 00 45
	bra	r6			; 00 46
	bra	r7			; 00 47
	bra	r8			; 00 48
	bra	r9			; 00 49
	bra	r10			; 00 4A
	bra	r11			; 00 4B
	bra	r12			; 00 4C
	bra	r13			; 00 4D
	bra	r14			; 00 4E
	bra	r15			; 00 4F

	bra	pc			; 00 40
	bra	sp			; 00 41
	bra	sr			; 00 42
	bra	cg1			; 00 42
	bra	cg2			; 00 43

	; All Addressing Modes
1$:	bra	r5			; 00 45
	bra	0x2(r5)			; 10 45 02 00
	bra	1$			; 10 40 F8 FF
	bra	&1$			; 10 42r7As06
	bra	@r5			; 20 45
	bra	@r5+			; 30 45
;	bra	#0x3412			; 30 40 12 34

	; Alternate Forms
	bra	(r5)			; 20 45
	bra	(r5)+			; 30 45



	.sbttl	'SOP' Instruction Tests

	; Test Addressing Modes for Single Operand Instructions

	.sbttl	Word SOP Check

SOP:	; Check all Registers
	rrc	r0			; 00 10
	rrc	r1			; 01 10
	rrc	r2			; 02 10
	rrc	r3			; 03 10
	rrc	r4			; 04 10
	rrc	r5			; 05 10
	rrc	r6			; 06 10
	rrc	r7			; 07 10
	rrc	r8			; 08 10
	rrc	r9			; 09 10
	rrc	r10			; 0A 10
	rrc	r11			; 0B 10
	rrc	r12			; 0C 10
	rrc	r13			; 0D 10
	rrc	r14			; 0E 10
	rrc	r15			; 0F 10

	rrc	pc			; 00 10
	rrc	sp			; 01 10
	rrc	sr			; 02 10
	rrc	cg1			; 02 10
	rrc	cg2			; 03 10

	; All Addressing Modes
1$:	rrc	r5			; 05 10
	rrc	0x2(r5)			; 15 10 02 00
	rrc	1$			; 10 10 F8 FF
	rrc	&1$			; 10 12rBAs06
	rrc	@r5			; 25 10
	rrc	@r5+			; 35 10
;	rrc	#0x3412			; 10 12 12 34

	; Alternate Forms
	rrc	(r5)			; 25 10
	rrc	(r5)+			; 35 10

	rrc	(pc)+			; 30 10
2$:	.word	0x3412			; 12 34


	.sbttl	BYTE SOP Check

	; Check all Registers
	rrc.b	r0			; 40 10
	rrc.b	r1			; 41 10
	rrc.b	r2			; 42 10
	rrc.b	r3			; 43 10
	rrc.b	r4			; 44 10
	rrc.b	r5			; 45 10
	rrc.b	r6			; 46 10
	rrc.b	r7			; 47 10
	rrc.b	r8			; 48 10
	rrc.b	r9			; 49 10
	rrc.b	r10			; 4A 10
	rrc.b	r11			; 4B 10
	rrc.b	r12			; 4C 10
	rrc.b	r13			; 4D 10
	rrc.b	r14			; 4E 10
	rrc.b	r15			; 4F 10

	rrc.b	pc			; 40 10
	rrc.b	sp			; 41 10
	rrc.b	sr			; 42 10
	rrc.b	cg1			; 42 10
	rrc.b	cg2			; 43 10

	; All Addressing Modes
11$:	rrc.b	r5			; 45 10
	rrc.b	0x2(r5)			; 55 10 02 00
	rrc.b	11$			; 50 10 F8 FF
	rrc.b	&11$			; 50 12rFEs06
	rrc.b	@r5			; 65 10
	rrc.b	@r5+			; 75 10
;	rrc.b	#0x3412			; 50 12 12 34

	; Alternate Forms
	rrc.b	(r5)			; 65 10
	rrc.b	(r5)+			; 75 10

	rrc.b	(pc)+			; 70 10
12$:	.word	0x3412			; 12 34



	.sbttl	'DST' Instruction Tests

	; Test Addressing Modes for Single Operand Instructions

	.sbttl	Word DST Check

DST:	; Check all Registers
	clr	r0			; 00 43
	clr	r1			; 01 43
	clr	r2			; 02 43
	clr	r3			; 03 43
	clr	r4			; 04 43
	clr	r5			; 05 43
	clr	r6			; 06 43
	clr	r7			; 07 43
	clr	r8			; 08 43
	clr	r9			; 09 43
	clr	r10			; 0A 43
	clr	r11			; 0B 43
	clr	r12			; 0C 43
	clr	r13			; 0D 43
	clr	r14			; 0E 43
	clr	r15			; 0F 43

	clr	pc			; 00 43
	clr	sp			; 01 43
	clr	sr			; 02 43
	clr	cg1			; 02 43
	clr	cg2			; 03 43

	; All Addressing Modes
1$:	clr	r5			; 05 43
	clr	0x2(r5)			; 85 43 02 00
	clr	1$			; 80 43 F8 FF
	clr	&1$			; 82 43r42s07
	clr	@r5			; 85 43 00 00
	clr	@r5+			; 85 43 00 00 25 53
;	clr	#0x3412			; 82 43 12 34

	; Alternate Forms
	clr	(r5)			; 85 43 00 00
	clr	(r5)+			; 85 43 00 00 25 53

	clr	(pc)+			; 80 43 00 00 20 53
2$:	.word	0x3412			; 12 34


	.sbttl	Byte DST Check

	; Check all Registers
	clr.b	r0			; 40 43
	clr.b	r1			; 41 43
	clr.b	r2			; 42 43
	clr.b	r3			; 43 43
	clr.b	r4			; 44 43
	clr.b	r5			; 45 43
	clr.b	r6			; 46 43
	clr.b	r7			; 47 43
	clr.b	r8			; 48 43
	clr.b	r9			; 49 43
	clr.b	r10			; 4A 43
	clr.b	r11			; 4B 43
	clr.b	r12			; 4C 43
	clr.b	r13			; 4D 43
	clr.b	r14			; 4E 43
	clr.b	r15			; 4F 43

	clr.b	pc			; 40 43
	clr.b	sp			; 41 43
	clr.b	sr			; 42 43
	clr.b	cg1			; 42 43
	clr.b	cg2			; 43 43

	; All Addressing Modes
3$:	clr.b	r5			; 45 43
	clr.b	0x2(r5)			; C5 43 02 00
	clr.b	3$			; C0 43 F8 FF
	clr.b	&3$			; C2 43r96s07
	clr.b	@r5			; C5 43 00 00
	clr.b	@r5+			; C5 43 00 00 15 53
;	clr.b	#0x3412			; C2 43 12 34

	; Alternate Forms
	clr.b	(r5)			; C5 43 00 00
	clr.b	(r5)+			; C5 43 00 00 15 53

	clr.b	(pc)+			; C0 43 00 00 20 53
4$:	.word	0x3412			; 12 34


	.sbttl	'JXX' Instruction Tests

	.org	0x0800
JXX:
 
1$:
	jne	1$			; FF 23
	jnz	1$			; FE 23
	jeq	1$			; FD 27
	jz	1$			; FC 27
	jnc	1$			; FB 2B
	jlo	1$			; FA 2B
	jc	1$			; F9 2F
	jhs	1$			; F8 2F
	jn	1$			; F7 33
	jge	1$			; F6 37
	jl	1$			; F5 3B
	jmp	1$			; F4 3F

	jne	2$			; 0B 20
	jnz	2$			; 0A 20
	jeq	2$			; 09 24
	jz	2$			; 08 24
	jnc	2$			; 07 28
	jlo	2$			; 06 28
	jc	2$			; 05 2C
	jhs	2$			; 04 2C
	jn	2$			; 03 30
	jge	2$			; 02 34
	jl	2$			; 01 38
	jmp	2$			; 00 3C
2$:

	.org	0x0BFE

	jmp	1$			; 00 3E
	jmp	3$			; FF 3D

	.org	0x1000

3$:



	.sbttl	Basic All Instruction Test

ALL:
		; DOP
	mov	r0,r0			; 00 40
	add	r0,r0			; 00 50
	addc	r0,r0			; 00 60
	sbb	r0,r0			; 00 70
	subc	r0,r0			; 00 70
	sub	r0,r0			; 00 80
	cmp	r0,r0			; 00 90
	dadd	r0,r0			; 00 A0
	bit	r0,r0			; 00 B0
	bic	r0,r0			; 00 C0
	bis	r0,r0			; 00 D0
	xor	r0,r0			; 00 E0
	and	r0,r0			; 00 F0

	mov.b	r0,r0			; 40 40
	add.b	r0,r0			; 40 50
	addc.b	r0,r0			; 40 60
	sbb.b	r0,r0			; 40 70
	subc.b	r0,r0			; 40 70
	sub.b	r0,r0			; 40 80
	cmp.b	r0,r0			; 40 90
	dadd.b	r0,r0			; 40 A0
	bit.b	r0,r0			; 40 B0
	bic.b	r0,r0			; 40 C0
	bis.b	r0,r0			; 40 D0
	xor.b	r0,r0			; 40 E0
	and.b	r0,r0			; 40 F0

	mov.w	r0,r0			; 00 40
	add.w	r0,r0			; 00 50
	addc.w	r0,r0			; 00 60
	sbb.w	r0,r0			; 00 70
	subc.w	r0,r0			; 00 70
	sub.w	r0,r0			; 00 80
	cmp.w	r0,r0			; 00 90
	dadd.w	r0,r0			; 00 A0
	bit.w	r0,r0			; 00 B0
	bic.w	r0,r0			; 00 C0
	bis.w	r0,r0			; 00 D0
	xor.w	r0,r0			; 00 E0
	and.w	r0,r0			; 00 F0

		; SOP
	push	r0			; 00 12
	rra	r0			; 00 11
	rrc	r0			; 00 10

	push.b	r0			; 40 12
	rra.b	r0			; 40 11
	rrc.b	r0			; 40 10

	push.w	r0			; 00 12
	rra.w	r0			; 00 11
	rrc.w	r0			; 00 10

	call	r0			; 80 12
	swpb	r0			; 80 10
	sxt	r0			; 80 11

		; JXX
	jne	.+2			; 00 20
	jnz	.+2			; 00 20
	jeq	.+2			; 00 24
	jz	.+2			; 00 24
	jnc	.+2			; 00 28
	jlo	.+2			; 00 28
	jc	.+2			; 00 2C
	jhs	.+2			; 00 2C
	jn	.+2			; 00 30
	jge	.+2			; 00 34
	jl	.+2			; 00 38
	jmp	.+2			; 00 3C

		; DST/RLX
	adc	r0			; 00 63
	clr	r0			; 00 43
	dadc	r0			; 00 A3
	dec	r0			; 10 83
	decd	r0			; 20 83
	inc	r0			; 10 53
	incd	r0			; 20 53
	inv	r0			; 30 E3
	pop	r0			; 30 41
	rla	r0			; 00 50
	rlc	r0			; 00 60
	sbc	r0			; 00 73
	tst	r0			; 00 93

	adc.b	r0			; 40 63
	clr.b	r0			; 40 43
	dadc.b	r0			; 40 A3
	dec.b	r0			; 50 83
	decd.b	r0			; 60 83
	inc.b	r0			; 50 53
	incd.b	r0			; 60 53
	inv.b	r0			; 70 E3
	pop.b	r0			; 70 41
	rla.b	r0			; 40 50
	rlc.b	r0			; 40 60
	sbc.b	r0			; 40 73
	tst.b	r0			; 40 93

	adc.w	r0			; 00 63
	clr.w	r0			; 00 43
	dadc.w	r0			; 00 A3
	dec.w	r0			; 10 83
	decd.w	r0			; 20 83
	inc.w	r0			; 10 53
	incd.w	r0			; 20 53
	inv.w	r0			; 30 E3
	pop.w	r0			; 30 41
	rla.w	r0			; 00 50
	rlc.w	r0			; 00 60
	sbc.w	r0			; 00 73
	tst.w	r0			; 00 93

	; BRA
	bra	.+2			; 10 40 00 00

	; INH
	reti				; 00 13
	clrc				; 12 C3
	clrn				; 02 C2
	clrz				; 22 C3
	setc				; 12 D3
	setn				; 02 D2
	setz				; 22 D3
	dint				; 32 C3
	eint				; 32 D3
	nop				; 03 43
	ret				; 30 41




