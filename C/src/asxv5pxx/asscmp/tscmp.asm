	.title	SC/MP Assembler Test File

	dat1	=	1
	dat2	=	2
	dat4	=	4
	dat8	=	8

	.globl	xdat1
	.globl	xdat2
	.globl	xdat4
	.globl	xdat8


	.bank	Local
	.area	Local	(rel,con,bank=Local)

lcl_1:	halt			; 00
	xae			; 01
	ccl			; 02
	scl			; 03
	dint			; 04
	ien			; 05
	csa			; 06
	cas			; 07
	nop			; 08
				; 09 - 18
	sio			; 19
				; 1A - 1B
	sr			; 1C
	srl			; 1D
	rr			; 1E
	rrl			; 1F
				; 20 - 2F
	xpal	p0		; 30
	xpal	p1		; 31
	xpal	p2		; 32
	xpal	p3		; 33
	xpah	p0		; 34
	xpah	p1		; 35
	xpah	p2		; 36
	xpah	p3		; 37
				; 38 - 3B
	xppc	p0		; 3C
	xppc	p1		; 3D
	xppc	p2		; 3E
	xppc	p3		; 3F
	lde			; 40
				; 41 - 4F
	ane			; 50
				; 51 - 57
	ore			; 58
				; 59 - 5F
	xre			; 60
				; 61 - 67
	dae			; 68
				; 69 - 6F
	ade			; 70
				; 71 - 77
	cae			; 78
				; 79 - 8E
	dly	#1		; 8F 01
1$:	jmp	1$		; 90 FF
	jmp	(p0)		; 90 00
	jmp	dat1(p0)	; 90 01
	jmp	dat2(p1)	; 91 02
	jmp	dat4(p2)	; 92 04
	jmp	dat8(p3)	; 93 08
2$:	jp	2$		; 94 FF
	jp	(p0)		; 94 00
	jp	dat1(p0)	; 94 01
	jp	dat2(p1)	; 95 02
	jp	dat4(p2)	; 96 04
	jp	dat8(p3)	; 97 08
3$:	jz	3$		; 98 FF
	jz	(p0)		; 98 00
	jz	dat1(p0)	; 98 01
	jz	dat2(p1)	; 99 02
	jz	dat4(p2)	; 9A 04
	jz	dat8(p3)	; 9B 08
4$:	jnz	4$		; 9C FF
	jnz	(p0)		; 9C 00
	jnz	dat1(p0)	; 9C 01
	jnz	dat2(p1)	; 9D 02
	jnz	dat4(p2)	; 9E 04
	jnz	dat8(p3)	; 9F 08
				; A0 - A7
5$:	ild	5$		; A8 FF
	ild	(p0)		; A8 00
	ild	dat1(p0)	; A8 01
	ild	dat2(p1)	; A9 02
	ild	dat4(p2)	; AA 04
	ild	dat8(p3)	; AB 08
				; AC - B7
6$:	dld	6$		; B8 FF
	dld	(p0)		; B8 00
	dld	dat1(p0)	; B8 01
	dld	dat2(p1)	; B9 02
	dld	dat4(p2)	; BA 04
	dld	dat8(p3)	; BB 08
				; BC - BF
7$:	ld	7$		; C0 FF
	ld	(p0)		; C0 00
	ld	dat1(p0)	; C0 01
	ld	dat2(p1)	; C1 02
	ld	dat4(p2)	; C2 04
	ld	dat8(p3)	; C3 08
	ldi	#1		; C4 01
	ld	#1		; C4 01
	ld	@(p1)		; C5 00
	ld	@dat2(p1)	; C5 02
	ld	@dat4(p2)	; C6 04
	ld	@dat8(p3)	; C7 08
8$:	st	8$		; C8 FF
	st	(p0)		; C8 00
	st	dat1(p0)	; C8 01
	st	dat2(p1)	; C9 02
 	st	dat4(p2)	; CA 04
	st	dat8(p3)	; CB 08
				; CC
	st	@(p1)		; CD 00
	st	@dat2(p1)	; CD 02
	st	@dat4(p2)	; CE 04
	st	@dat8(p3)	; CF 08
9$:	and	9$		; D0 FF
	and	(p0)		; D0 00
	and	dat1(p0)	; D0 01
	and	dat2(p1)	; D1 02
	and	dat4(p2)	; D2 04
	and	dat8(p3)	; D3 08
	ani	#1		; D4 01
	and	#1		; D4 01
	and	@(p1)		; D5 00
	and	@dat2(p1)	; D5 02
	and	@dat4(p2)	; D6 04
	and	@dat8(p3)	; D7 08
10$:	or	10$		; D8 FF
	or	(p0)		; D8 00
	or	dat1(p0)	; D8 01
	or	dat2(p1)	; D9 02
	or	dat4(p2)	; DA 04
	or	dat8(p3)	; DB 08
	ori	#1		; DC 01
	or	#1		; DC 01
	or	@(p1)		; DD 00
	or	@dat2(p1)	; DD 02
	or	@dat4(p2)	; DE 04
	or	@dat8(p3)	; DF 08
11$:	xor	11$		; E0 FF
	xor	(p0)		; E0 00
	xor	dat1(p0)	; E0 01
	xor	dat2(p1)	; E1 02
	xor	dat4(p2)	; E2 04
	xor	dat8(p3)	; E3 08
	xri	#1		; E4 01
	xor	#1		; E4 01
	xor	@(p1)		; E5 00
	xor	@dat2(p1)	; E5 02
	xor	@dat4(p2)	; E6 04
	xor	@dat8(p3)	; E7 08
12$:	dad	12$		; E8 FF
	dad	(p0)		; E8 00
	dad	dat1(p0)	; E8 01
	dad	dat2(p1)	; E9 02
	dad	dat4(p2)	; EA 04
	dad	dat8(p3)	; EB 08
	dai	#1		; EC 01
	dad	#1		; EC 01
	dad	@(p1)		; ED 00
	dad	@dat2(p1)	; ED 02
	dad	@dat4(p2)	; EE 04
	dad	@dat8(p3)	; EF 08
13$:	add	13$		; F0 FF
	add	(p0)		; F0 00
	add	dat1(p0)	; F0 01
	add	dat2(p1)	; F1 02
	add	dat4(p2)	; F2 04
	add	dat8(p3)	; F3 08
	adi	#1		; F4 01
	add	#1		; F4 01
	add	@(p1)		; F5 00
	add	@dat2(p1)	; F5 02
	add	@dat4(p2)	; F6 04
	add	@dat8(p3)	; F7 08
14$:	cad	14$		; F8 FF
	cad	(p0)		; F8 00
	cad	dat1(p0)	; F8 01
	cad	dat2(p1)	; F9 02
	cad	dat4(p2)	; FA 04
	cad	dat8(p3)	; FB 08
	cai	#1		; FC 01
	cad	#1		; FC 01
	cad	@(p1)		; FD 00
	cad	@dat2(p1)	; FD 02
	cad	@dat4(p2)	; FE 04
	cad	@dat8(p3)	; FF 08


lcl_2:	halt			; 00
	xae			; 01
	ccl			; 02
	scl			; 03
	dint			; 04
	ien			; 05
	csa			; 06
	cas			; 07
	nop			; 08
				; 09 - 18
	sio			; 19
				; 1A - 1B
	sr			; 1C
	srl			; 1D
	rr			; 1E
	rrl			; 1F
				; 20 - 2F
	xpal	p0		; 30
	xpal	p1		; 31
	xpal	p2		; 32
	xpal	p3		; 33
	xpah	p0		; 34
	xpah	p1		; 35
	xpah	p2		; 36
	xpah	p3		; 37
				; 38 - 3B
	xppc	p0		; 3C
	xppc	p1		; 3D
	xppc	p2		; 3E
	xppc	p3		; 3F
	lde			; 40
				; 41 - 4F
	ane			; 50
				; 51 - 57
	ore			; 58
				; 59 - 5F
	xre			; 60
				; 61 - 67
	dae			; 68
				; 69 - 6F
	ade			; 70
				; 71 - 77
	cae			; 78
				; 79 - 8E
	dly	#1		; 8F 01
1$:	jmp	1$		; 90 FF
	jmp	[p0]		; 90 00
	jmp	dat1[p0]	; 90 01
	jmp	dat2[p1]	; 91 02
	jmp	dat4[p2]	; 92 04
	jmp	dat8[p3]	; 93 08
2$:	jp	2$		; 94 FF
	jp	[p0]		; 94 00
	jp	dat1[p0]	; 94 01
	jp	dat2[p1]	; 95 02
	jp	dat4[p2]	; 96 04
	jp	dat8[p3]	; 97 08
3$:	jz	3$		; 98 FF
	jz	[p0]		; 98 00
	jz	dat1[p0]	; 98 01
	jz	dat2[p1]	; 99 02
	jz	dat4[p2]	; 9A 04
	jz	dat8[p3]	; 9B 08
4$:	jnz	4$		; 9C FF
	jnz	[p0]		; 9C 00
	jnz	dat1[p0]	; 9C 01
	jnz	dat2[p1]	; 9D 02
	jnz	dat4[p2]	; 9E 04
	jnz	dat8[p3]	; 9F 08
				; A0 - A7
5$:	ild	5$		; A8 FF
	ild	[p0]		; A8 00
	ild	dat1[p0]	; A8 01
	ild	dat2[p1]	; A9 02
	ild	dat4[p2]	; AA 04
	ild	dat8[p3]	; AB 08
				; AC - B7
6$:	dld	6$		; B8 FF
	dld	[p0]		; B8 00
	dld	dat1[p0]	; B8 01
	dld	dat2[p1]	; B9 02
	dld	dat4[p2]	; BA 04
	dld	dat8[p3]	; BB 08
				; BC - BF
7$:	ld	7$		; C0 FF
	ld	[p0]		; C0 00
	ld	dat1[p0]	; C0 01
	ld	dat2[p1]	; C1 02
	ld	dat4[p2]	; C2 04
	ld	dat8[p3]	; C3 08
	ldi	#1		; C4 01
	ld	#1		; C4 01
	ld	@[p1]		; C5 00
	ld	@dat2[p1]	; C5 02
	ld	@dat4[p2]	; C6 04
	ld	@dat8[p3]	; C7 08
8$:	st	8$:		; C8 FF
	st	[p0]		; C8 00
	st	dat1[p0]	; C8 01
	st	dat2[p1]	; C9 02
 	st	dat4[p2]	; CA 04
	st	dat8[p3]	; CB 08
				; CC
	st	@[p1]		; CD 00
	st	@dat2[p1]	; CD 02
	st	@dat4[p2]	; CE 04
	st	@dat8[p3]	; CF 08
9$:	and	9$		; D0 FF
	and	[p0]		; D0 00
	and	dat1[p0]	; D0 01
	and	dat2[p1]	; D1 02
	and	dat4[p2]	; D2 04
	and	dat8[p3]	; D3 08
	ani	#1		; D4 01
	and	#1		; D4 01
	and	@[p1]		; D5 00
	and	@dat2[p1]	; D5 02
	and	@dat4[p2]	; D6 04
	and	@dat8[p3]	; D7 08
10$:	or	10$		; D8 FF
	or	[p0]		; D8 00
	or	dat1[p0]	; D8 01
	or	dat2[p1]	; D9 02
	or	dat4[p2]	; DA 04
	or	dat8[p3]	; DB 08
	ori	#1		; DC 01
	or	#1		; DC 01
	or	@[p1]		; DD 00
	or	@dat2[p1]	; DD 02
	or	@dat4[p2]	; DE 04
	or	@dat8[p3]	; DF 08
11$:	xor	11$		; E0 FF
	xor	[p0]		; E0 00
	xor	dat1[p0]	; E0 01
	xor	dat2[p1]	; E1 02
	xor	dat4[p2]	; E2 04
	xor	dat8[p3]	; E3 08
	xri	#1		; E4 01
	xor	#1		; E4 01
	xor	@[p1]		; E5 00
	xor	@dat2[p1]	; E5 02
	xor	@dat4[p2]	; E6 04
	xor	@dat8[p3]	; E7 08
12$:	dad	12$		; E8 FF
	dad	[p0]		; E8 00
	dad	dat1[p0]	; E8 01
	dad	dat2[p1]	; E9 02
	dad	dat4[p2]	; EA 04
	dad	dat8[p3]	; EB 08
	dai	#1		; EC 01
	dad	#1		; EC 01
	dad	@[p1]		; ED 00
	dad	@dat2[p1]	; ED 02
	dad	@dat4[p2]	; EE 04
	dad	@dat8[p3]	; EF 08
13$:	add	13$		; F0 FF
	add	[p0]		; F0 00
	add	dat1[p0]	; F0 01
	add	dat2[p1]	; F1 02
	add	dat4[p2]	; F2 04
	add	dat8[p3]	; F3 08
	adi	#1		; F4 01
	add	#1		; F4 01
	add	@[p1]		; F5 00
	add	@dat2[p1]	; F5 02
	add	@dat4[p2]	; F6 04
	add	@dat8[p3]	; F7 08
14$:	cad	14$		; F8 FF
	cad	[p0]		; F8 00
	cad	dat1[p0]	; F8 01
	cad	dat2[p1]	; F9 02
	cad	dat4[p2]	; FA 04
	cad	dat8[p3]	; FB 08
	cai	#1		; FC 01
	cad	#1		; FC 01
	cad	@[p1]		; FD 00
	cad	@dat2[p1]	; FD 02
	cad	@dat4[p2]	; FE 04
	cad	@dat8[p3]	; FF 08


	.bank	Extern
	.area	Extern	(rel,con,bank=Extern)

ext_1:	halt			; 00
	xae			; 01
	ccl			; 02
	scl			; 03
	dint			; 04
	ien			; 05
	csa			; 06
	cas			; 07
	nop			; 08
				; 09 - 18
	sio			; 19
				; 1A - 1B
	sr			; 1C
	srl			; 1D
	rr			; 1E
	rrl			; 1F
				; 20 - 2F
	xpal	p0		; 30
	xpal	p1		; 31
	xpal	p2		; 32
	xpal	p3		; 33
	xpah	p0		; 34
	xpah	p1		; 35
	xpah	p2		; 36
	xpah	p3		; 37
				; 38 - 3B
	xppc	p0		; 3C
	xppc	p1		; 3D
	xppc	p2		; 3E
	xppc	p3		; 3F
	lde			; 40
				; 41 - 4F
	ane			; 50
				; 51 - 57
	ore			; 58
				; 59 - 5F
	xre			; 60
				; 61 - 67
	dae			; 68
				; 69 - 6F
	ade			; 70
				; 71 - 77
	cae			; 78
				; 79 - 8E
	dly	#1		; 8F 01
1$:	jmp	1$		; 90 FF
	jmp	(p0)		; 90 00
	jmp	xdat1+1(p0)	; 90r01
	jmp	xdat2+2(p1)	; 91r02
	jmp	xdat4+4(p2)	; 92r04
	jmp	xdat8+8(p3)	; 93r08
2$:	jp	2$		; 94 FF
	jp	(p0)		; 94 00
	jp	xdat1+1(p0)	; 94r01
	jp	xdat2+2(p1)	; 95r02
	jp	xdat4+4(p2)	; 96r04
	jp	xdat8+8(p3)	; 97r08
3$:	jz	3$		; 98 FF
	jz	(p0)		; 98 00
	jz	xdat1+1(p0)	; 98r01
	jz	xdat2+2(p1)	; 99r02
	jz	xdat4+4(p2)	; 9Ar04
	jz	xdat8+8(p3)	; 9Br08
4$:	jnz	4$		; 9C FF
	jnz	(p0)		; 9C 00
	jnz	xdat1+1(p0)	; 9Cr01
	jnz	xdat2+2(p1)	; 9Dr02
	jnz	xdat4+4(p2)	; 9Er04
	jnz	xdat8+8(p3)	; 9Fr08
				; A0 - A7
5$:	ild	5$		; A8 FF
	ild	(p0)		; A8 00
	ild	xdat1+1(p0)	; A8r01
	ild	xdat2+2(p1)	; A9r02
	ild	xdat4+4(p2)	; AAr04
	ild	xdat8+8(p3)	; ABr08
				; AC - B7
6$:	dld	6$		; B8 FF
	dld	(p0)		; B8 00
	dld	xdat1+1(p0)	; B8r01
	dld	xdat2+2(p1)	; B9r02
	dld	xdat4+4(p2)	; BAr04
	dld	xdat8+8(p3)	; BBr08
				; BC - BF
7$:	ld	7$		; C0 FF
	ld	(p0)		; C0 00
	ld	xdat1+1(p0)	; C0r01
	ld	xdat2+2(p1)	; C1r02
	ld	xdat4+4(p2)	; C2r04
	ld	xdat8+8(p3)	; C3r08
	ldi	#1		; C4 01
	ld	#1		; C4 01
	ld	@(p1)		; C5 00
	ld	@xdat2+2(p1)	; C5r02
	ld	@xdat4+4(p2)	; C6r04
	ld	@xdat8+8(p3)	; C7r08
8$:	st	8$		; C8 FF
	st	(p0)		; C8 00
	st	xdat1+1(p0)	; C8r01
	st	xdat2+2(p1)	; C9r02
 	st	xdat4+4(p2)	; CAr04
	st	xdat8+8(p3)	; CBr08
				; CC
	st	@(p1)		; CD 00
	st	@xdat2+2(p1)	; CDr02
	st	@xdat4+4(p2)	; CEr04
	st	@xdat8+8(p3)	; CFr08
9$:	and	9$		; D0 FF
	and	(p0)		; D0 00
	and	xdat1+1(p0)	; D0r01
	and	xdat2+2(p1)	; D1r02
	and	xdat4+4(p2)	; D2r04
	and	xdat8+8(p3)	; D3r08
	ani	#1		; D4 01
	and	#1		; D4 01
	and	@(p1)		; D5 00
	and	@xdat2+2(p1)	; D5r02
	and	@xdat4+4(p2)	; D6r04
	and	@xdat8+8(p3)	; D7r08
10$:	or	10$		; D8 FF
	or	(p0)		; D8 00
	or	xdat1+1(p0)	; D8r01
	or	xdat2+2(p1)	; D9r02
	or	xdat4+4(p2)	; DAr04
	or	xdat8+8(p3)	; DBr08
	ori	#1		; DC 01
	or	#1		; DC 01
	or	@(p1)		; DD 00
	or	@xdat2+2(p1)	; DDr02
	or	@xdat4+4(p2)	; DEr04
	or	@xdat8+8(p3)	; DFr08
11$:	xor	11$		; E0 FF
	xor	(p0)		; E0 00
	xor	xdat1+1(p0)	; E0r01
	xor	xdat2+2(p1)	; E1r02
	xor	xdat4+4(p2)	; E2r04
	xor	xdat8+8(p3)	; E3r08
	xri	#1		; E4 01
	xor	#1		; E4 01
	xor	@(p1)		; E5 00
	xor	@xdat2+2(p1)	; E5r02
	xor	@xdat4+4(p2)	; E6r04
	xor	@xdat8+8(p3)	; E7r08
12$:	dad	12$		; E8 FF
	dad	(p0)		; E8 00
	dad	xdat1+1(p0)	; E8r01
	dad	xdat2+2(p1)	; E9r02
	dad	xdat4+4(p2)	; EAr04
	dad	xdat8+8(p3)	; EBr08
	dai	#1		; EC 01
	dad	#1		; EC 01
	dad	@(p1)		; ED 00
	dad	@xdat2+2(p1)	; EDr02
	dad	@xdat4+4(p2)	; EEr04
	dad	@xdat8+8(p3)	; EFr08
13$:	add	13$		; F0 FF
	add	(p0)		; F0 00
	add	xdat1+1(p0)	; F0r01
	add	xdat2+2(p1)	; F1r02
	add	xdat4+4(p2)	; F2r04
	add	xdat8+8(p3)	; F3r08
	adi	#1		; F4 01
	add	#1		; F4 01
	add	@(p1)		; F5 00
	add	@xdat2+2(p1)	; F5r02
	add	@xdat4+4(p2)	; F6r04
	add	@xdat8+8(p3)	; F7r08
14$:	cad	14$		; F8 FF
	cad	(p0)		; F8 00
	cad	xdat1+1(p0)	; F8r01
	cad	xdat2+2(p1)	; F9r02
	cad	xdat4+4(p2)	; FAr04
	cad	xdat8+8(p3)	; FBr08
	cai	#1		; FC 01
	cad	#1		; FC 01
	cad	@(p1)		; FD 00
	cad	@xdat2+2(p1)	; FDr02
	cad	@xdat4+4(p2)	; FEr04
	cad	@xdat8+8(p3)	; FFr08


ext_2:	halt			; 00
	xae			; 01
	ccl			; 02
	scl			; 03
	dint			; 04
	ien			; 05
	csa			; 06
	cas			; 07
	nop			; 08
				; 09 - 18
	sio			; 19
				; 1A - 1B
	sr			; 1C
	srl			; 1D
	rr			; 1E
	rrl			; 1F
				; 20 - 2F
	xpal	p0		; 30
	xpal	p1		; 31
	xpal	p2		; 32
	xpal	p3		; 33
	xpah	p0		; 34
	xpah	p1		; 35
	xpah	p2		; 36
	xpah	p3		; 37
				; 38 - 3B
	xppc	p0		; 3C
	xppc	p1		; 3D
	xppc	p2		; 3E
	xppc	p3		; 3F
	lde			; 40
				; 41 - 4F
	ane			; 50
				; 51 - 57
	ore			; 58
				; 59 - 5F
	xre			; 60
				; 61 - 67
	dae			; 68
				; 69 - 6F
	ade			; 70
				; 71 - 77
	cae			; 78
				; 79 - 8E
	dly	#1		; 8F 01
1$:	jmp	1$		; 90 FF
	jmp	[p0]		; 90 00
	jmp	xdat1+1[p0]	; 90r01
	jmp	xdat2+2[p1]	; 91r02
	jmp	xdat4+4[p2]	; 92r04
	jmp	xdat8+8[p3]	; 93r08
2$:	jp	2$		; 94 FF
	jp	[p0]		; 94 00
	jp	xdat1+1[p0]	; 94r01
	jp	xdat2+2[p1]	; 95r02
	jp	xdat4+4[p2]	; 96r04
	jp	xdat8+8[p3]	; 97r08
3$:	jz	3$		; 98 FF
	jz	[p0]		; 98 00
	jz	xdat1+1[p0]	; 98r01
	jz	xdat2+2[p1]	; 99r02
	jz	xdat4+4[p2]	; 9Ar04
	jz	xdat8+8[p3]	; 9Br08
4$:	jnz	4$		; 9C FF
	jnz	[p0]		; 9C 00
	jnz	xdat1+1[p0]	; 9Cr01
	jnz	xdat2+2[p1]	; 9Dr02
	jnz	xdat4+4[p2]	; 9Er04
	jnz	xdat8+8[p3]	; 9Fr08
				; A0 - A7
5$:	ild	5$		; A8 FF
	ild	[p0]		; A8 00
	ild	xdat1+1[p0]	; A8r01
	ild	xdat2+2[p1]	; A9r02
	ild	xdat4+4[p2]	; AAr04
	ild	xdat8+8[p3]	; ABr08
				; AC - B7
6$:	dld	6$		; B8 FF
	dld	[p0]		; B8 00
	dld	xdat1+1[p0]	; B8r01
	dld	xdat2+2[p1]	; B9r02
	dld	xdat4+4[p2]	; BAr04
	dld	xdat8+8[p3]	; BBr08
				; BC - BF
7$:	ld	7$		; C0 FF
	ld	[p0]		; C0 00
	ld	xdat1+1[p0]	; C0r01
	ld	xdat2+2[p1]	; C1r02
	ld	xdat4+4[p2]	; C2r04
	ld	xdat8+8[p3]	; C3r08
	ldi	#1		; C4 01
	ld	#1		; C4 01
	ld	@[p1]		; C5 00
	ld	@xdat2+2[p1]	; C5r02
	ld	@xdat4+4[p2]	; C6r04
	ld	@xdat8+8[p3]	; C7r08
8$:	st	8$:		; C8 FF
	st	[p0]		; C8 00
	st	xdat1+1[p0]	; C8r01
	st	xdat2+2[p1]	; C9r02
 	st	xdat4+4[p2]	; CAr04
	st	xdat8+8[p3]	; CBr08
				; CC
	st	@[p1]		; CD 00
	st	@xdat2+2[p1]	; CDr02
	st	@xdat4+4[p2]	; CEr04
	st	@xdat8+8[p3]	; CFr08
9$:	and	9$		; D0 FF
	and	[p0]		; D0 00
	and	xdat1+1[p0]	; D0r01
	and	xdat2+2[p1]	; D1r02
	and	xdat4+4[p2]	; D2r04
	and	xdat8+8[p3]	; D3r08
	ani	#1		; D4 01
	and	#1		; D4 01
	and	@[p1]		; D5 00
	and	@xdat2+2[p1]	; D5r02
	and	@xdat4+4[p2]	; D6r04
	and	@xdat8+8[p3]	; D7r08
10$:	or	10$		; D8 FF
	or	[p0]		; D8 00
	or	xdat1+1[p0]	; D8r01
	or	xdat2+2[p1]	; D9r02
	or	xdat4+4[p2]	; DAr04
	or	xdat8+8[p3]	; DBr08
	ori	#1		; DC 01
	or	#1		; DC 01
	or	@[p1]		; DD 00
	or	@xdat2+2[p1]	; DDr02
	or	@xdat4+4[p2]	; DEr04
	or	@xdat8+8[p3]	; DFr08
11$:	xor	11$		; E0 FF
	xor	[p0]		; E0 00
	xor	xdat1+1[p0]	; E0r01
	xor	xdat2+2[p1]	; E1r02
	xor	xdat4+4[p2]	; E2r04
	xor	xdat8+8[p3]	; E3r08
	xri	#1		; E4 01
	xor	#1		; E4 01
	xor	@[p1]		; E5 00
	xor	@xdat2+2[p1]	; E5r02
	xor	@xdat4+4[p2]	; E6r04
	xor	@xdat8+8[p3]	; E7r08
12$:	dad	12$		; E8 FF
	dad	[p0]		; E8 00
	dad	xdat1+1[p0]	; E8r01
	dad	xdat2+2[p1]	; E9r02
	dad	xdat4+4[p2]	; EAr04
	dad	xdat8+8[p3]	; EBr08
	dai	#1		; EC 01
	dad	#1		; EC 01
	dad	@[p1]		; ED 00
	dad	@xdat2+2[p1]	; EDr02
	dad	@xdat4+4[p2]	; EEr04
	dad	@xdat8+8[p3]	; EFr08
13$:	add	13$		; F0 FF
	add	[p0]		; F0 00
	add	xdat1+1[p0]	; F0r01
	add	xdat2+2[p1]	; F1r02
	add	xdat4+4[p2]	; F2r04
	add	xdat8+8[p3]	; F3r08
	adi	#1		; F4 01
	add	#1		; F4 01
	add	@[p1]		; F5 00
	add	@xdat2+2[p1]	; F5r02
	add	@xdat4+4[p2]	; F6r04
	add	@xdat8+8[p3]	; F7r08
14$:	cad	14$		; F8 FF
	cad	[p0]		; F8 00
	cad	xdat1+1[p0]	; F8r01
	cad	xdat2+2[p1]	; F9r02
	cad	xdat4+4[p2]	; FAr04
	cad	xdat8+8[p3]	; FBr08
	cai	#1		; FC 01
	cad	#1		; FC 01
	cad	@[p1]		; FD 00
	cad	@xdat2+2[p1]	; FDr02
	cad	@xdat4+4[p2]	; FEr04
	cad	@xdat8+8[p3]	; FFr08



