	.title	Test of 1802 Assembler
	.sbttl	All 1802 instructions

again=$$4567

main:

; Register operations
	inc	r1		; 11
	inc	r2		; 12
;	inc	r16	;
	irx			; 60
	glo	r12		; 8C
	ghi	r12		; 9C
	plo	r10		; AA
	phi	r10		; BA
	ghi	r15		; 9F

; Memory reference
	ldn	r3		; 03
;	ldn	r0	;

	lda	r4		; 44
	ldx			; F0
	ldxa			; 72
	ldi	35		; F8 23
;	ldi	1000	;

	str	r2		; 52
	stxd			; 73

; Logic operations
	or			; F1
	ori	35		; F9 23
	ori	255		; F9 FF
;	ori	356	;

	xor			; F3
	xri	25		; FB 19
	and			; F2
	ani	22		; FA 16

; Shift operations
	shr			; F6
	shrc			; 76
	shl			; FE
	shlc			; 7E

; Arithmetic operations
	add			; F4
	adi	57		; FC 39
	adc			; 74
	adci	57		; 7C 39
	sd			; F5
	sdi	57		; FD 39
	sdb			; 75
	sdbi	57		; 7D 39
	sm			; F7
	smi	57		; FF 39
	smb			; 77
	smbi	57		; 7F 39

; Short branches

; This will cause Linker paging errors for all branches.

	br	again		;n30*67
	nbr	again		;n38*67
	bz	again		;n32*67
	bnz	again		;n3A*67
	bdf	again		;n33*67
	bpz	again		;n33*67
	bge	again		;n33*67
	bnf	again		;n3B*67
	bm	again		;n3B*67
	bl	again		;n3B*67
	bq	again		;n31*67
	bnq	again		;n39*67
	b1	again		;n34*67
	bn1	again		;n3C*67
	b2	again		;n35*67
	bn2	again		;n3D*67
	b3	again		;n36*67
	bn3	again		;n3E*67
	b4	again		;n37*67
	bn4	again		;n3F*67

; Long branches
	lbr	again		; C0 45 67
	nlbr	again		; C8 45 67
	lbz	again		; C2 45 67
	lbnz	again		; CA 45 67
	lbdf	again		; C3 45 67
	lbnf	again		; C8 45 67
	lbq	again		; C1 45 67
	lbnq	again		; C9 45 67

	skp			; 38
	lskp			; C8
	lsz			; CE
	lsnz			; C6
	lsdf			; CF
	lsnf			; C7
	lsq			; CD
	lsnq			; C5
	lsie			; CC

; Control
	idl			; 00
	nop			; C4
	sep	r3		; D3
	sex	r11		; EB
	seq			; 7B
	req			; 7A
	sav			; 78
	mark			; 79
	ret			; 70
	dis			; 71

; I/O
	out	1		; 61
	out	2		; 62
	out	3		; 63
	out	4		; 64
	out	5		; 65
	out	6		; 66
	out	7		; 67
	inp	1		; 69
	inp	2		; 6A
	inp	3		; 6B
	inp	4		; 6C
	inp	5		; 6D
	inp	6		; 6E
	inp	7		; 6F

; Short branches

; This Address will cause Linker paging errors for all branches.
. = main + $$00EC

Short_Begin_1:
1$:	br	20$		;n30*12
2$:	nbr	19$		;n38*10
3$:	bz	18$		;n32*0E
4$:	bnz	17$		;n3A*0C
5$:	bdf	16$		;n33*0A
6$:	bpz	15$		;n33*08
7$:	bge	14$		;n33*06
8$:	bnf	13$		;n3B*04
9$:	bm	12$		;n3B*02
10$:	bl	11$		;n3B*00
; ------------------		; Page Boundary
11$:	bq	10$		;n31*FE
12$:	bnq	9$		;n39*FC
13$:	b1	8$		;n34*FA
14$:	bn1	7$		;n3C*F8
15$:	b2	6$		;n35*F6
16$:	bn2	5$		;n3D*F4
17$:	b3	4$		;n36*F2
18$:	bn3	3$		;n3E*F0
19$:	b4	2$		;n37*EE
20$:	bn4	1$		;n3F*EC
Short_End_1:

; This Address will cause Linker paging errors for 2 branches.
. = main + $$01FE

Short_Begin_2:
1$:	br	20$		;n30*24
; ------------------		; Page Boundary
2$:	nbr	19$		;n38*22
3$:	bz	18$		;n32*20
4$:	bnz	17$		;n3A*1E
5$:	bdf	16$		;n33*1C
6$:	bpz	15$		;n33*1A
7$:	bge	14$		;n33*18
8$:	bnf	13$		;n3B*16
9$:	bm	12$		;n3B*14
10$:	bl	11$		;n3B*12
11$:	bq	10$		;n31*10
12$:	bnq	9$		;n39*0E
13$:	b1	8$		;n34*0C
14$:	bn1	7$		;n3C*0A
15$:	b2	6$		;n35*08
16$:	bn2	5$		;n3D*06
17$:	b3	4$		;n36*04
18$:	bn3	3$		;n3E*02
19$:	b4	2$		;n37*00
20$:	bn4	1$		;n3F*FE
Short_End_2:

; This Address will cause Linker paging errors for 2 branches.
. = main + $$02DA

Short_Begin_3:
1$:	br	20$		;n30*00
2$:	nbr	19$		;n38*FE
3$:	bz	18$		;n32*FC
4$:	bnz	17$		;n3A*FA
5$:	bdf	16$		;n33*F8
6$:	bpz	15$		;n33*F6
7$:	bge	14$		;n33*F4
8$:	bnf	13$		;n3B*F2
9$:	bm	12$		;n3B*F0
10$:	bl	11$		;n3B*EE
11$:	bq	10$		;n31*EC
12$:	bnq	9$		;n39*EA
13$:	b1	8$		;n34*E8
14$:	bn1	7$		;n3C*E6
15$:	b2	6$		;n35*E4
16$:	bn2	5$		;n3D*E2
17$:	b3	4$		;n36*E0
18$:	bn3	3$		;n3E*DE
19$:	b4	2$		;n37*DC
; ------------------		; Page Boundary
20$:	bn4	1$		;n3F*DA
Short_End_3:

; This Address will not cause Linker paging errors for these branches.
. = main + $$0400

Short_Begin_4:
; ------------------		; Page Boundary
1$:	br	20$		;n30*26
2$:	nbr	19$		;n38*24
3$:	bz	18$		;n32*22
4$:	bnz	17$		;n3A*20
5$:	bdf	16$		;n33*1E
6$:	bpz	15$		;n33*1C
7$:	bge	14$		;n33*1A
8$:	bnf	13$		;n3B*18
9$:	bm	12$		;n3B*16
10$:	bl	11$		;n3B*14
11$:	bq	10$		;n31*12
12$:	bnq	9$		;n39*10
13$:	b1	8$		;n34*0E
14$:	bn1	7$		;n3C*0C
15$:	b2	6$		;n35*0A
16$:	bn2	5$		;n3D*08
17$:	b3	4$		;n36*06
18$:	bn3	3$		;n3E*04
19$:	b4	2$		;n37*02
20$:	bn4	1$		;n3F*00
Short_End_4:

; This Address will not cause Linker paging errors for these branches.
. = main + $$04D8

Short_Begin_5:
1$:	br	20$		;n30*FE
2$:	nbr	19$		;n38*FC
3$:	bz	18$		;n32*FA
4$:	bnz	17$		;n3A*F8
5$:	bdf	16$		;n33*F6
6$:	bpz	15$		;n33*F4
7$:	bge	14$		;n33*F2
8$:	bnf	13$		;n3B*F0
9$:	bm	12$		;n3B*EE
10$:	bl	11$		;n3B*EC
11$:	bq	10$		;n31*EA
12$:	bnq	9$		;n39*E8
13$:	b1	8$		;n34*E6
14$:	bn1	7$		;n3C*E4
15$:	b2	6$		;n35*E2
16$:	bn2	5$		;n3D*E0
17$:	b3	4$		;n36*DE
18$:	bn3	3$		;n3E*DC
19$:	b4	2$		;n37*DA
20$:	bn4	1$		;n3F*D8
; ------------------		; Page Boundary
Short_End_5:


