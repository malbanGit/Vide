
;;; gcc for m6809 : Feb 15 2016 21:40:10
;;; 4.3.6 (gcc6809)
;;; ABI version 1
;;; -mint8
	.module	gcc.c
;----- asm -----
	.globl		_abort				
	_abort		.equ 	0xf000		
	
	.globl		_free				
	_free		.equ 	0xf000		
	
	.globl		_malloc				
	_malloc	.equ 	0xf000		
	
;--- end asm ---
	.area .text
	.globl _memcmp
_memcmp:
	pshs	y,u
	leas	-12,s
	leau	,s
	stx	6,u
	; ldx	6,u	; optimization 5
	stx	8,u
	ldx	18,u
	stx	10,u
	bra	L2
L8:
	ldb	[8,u]
	stb	,u
	ldb	[10,u]
	clr	1,u
	cmpb	,u	;cmpqi:(R)
	beq	L3
	ldb	#1
	stb	1,u
L3:
	ldd	8,u
	addd	#1
	std	8,u
	ldd	10,u
	addd	#1
	std	10,u
	tst	1,u
	beq	L2
	ldy	8,u
	leax	-1,y
	ldb	,x
	stb	4,u
	ldy	10,u
	leax	-1,y
	ldb	,x
	cmpb	4,u	;cmpqi:(R)
	bls	L4
	ldb	#-1
	stb	3,u
	bra	L5
L4:
	ldb	#1
	stb	3,u
L5:
	ldb	3,u
	stb	2,u
	bra	L6
L2:
	clr	5,u
	ldx	20,u
	cmpx	#0
	beq	L7
	ldb	#1
	stb	5,u
L7:
	ldd	20,u
	addd	#-1
	std	20,u
	tst	5,u
	lbne	L8
	clr	2,u
L6:
	ldb	2,u
	leas	12,s
	puls	y,u,pc
	.globl _memcpy
_memcpy:
	pshs	u
	leas	-7,s
	leau	,s
	stx	1,u
	; ldx	1,u	; optimization 5
	stx	3,u
	ldx	11,u
	stx	5,u
	bra	L11
L13:
	ldb	[5,u]
	stb	[3,u]
	ldd	3,u
	addd	#1
	std	3,u
	ldd	5,u
	addd	#1
	std	5,u
L11:
	clr	,u
	ldx	13,u
	cmpx	#0
	beq	L12
	ldb	#1
	stb	,u
L12:
	ldd	13,u
	addd	#-1
	std	13,u
	tst	,u
	bne	L13
	ldx	1,u
	leas	7,s
	puls	u,pc
	.globl _memmove
_memmove:
	pshs	u
	leas	-12,s
	leau	,s
	stx	2,u
	; ldx	2,u	; optimization 5
	stx	4,u
	ldx	16,u
	stx	6,u
	ldx	4,u
	cmpx	6,u	;cmphi:
	bhs	L16
	bra	L17
L19:
	ldb	[6,u]
	stb	[4,u]
	ldd	4,u
	addd	#1
	std	4,u
	ldd	6,u
	addd	#1
	std	6,u
L17:
	clr	,u
	ldx	18,u
	cmpx	#0
	beq	L18
	ldb	#1
	stb	,u
L18:
	ldd	18,u
	addd	#-1
	std	18,u
	tst	,u
	bne	L19
	bra	L20
L16:
	ldd	18,u
	addd	#-1
	ldx	6,u
	leax	d,x
	stx	8,u
	ldd	18,u
	addd	#-1
	ldx	4,u
	leax	d,x
	stx	10,u
	bra	L21
L23:
	ldb	[8,u]
	stb	[10,u]
	ldd	10,u
	addd	#-1
	std	10,u
	ldd	8,u
	addd	#-1
	std	8,u
L21:
	clr	1,u
	ldx	18,u
	cmpx	#0
	beq	L22
	ldb	#1
	stb	1,u
L22:
	ldd	18,u
	addd	#-1
	std	18,u
	tst	1,u
	bne	L23
L20:
	ldx	2,u
	leas	12,s
	puls	u,pc
	.globl _memset
_memset:
	pshs	u
	leas	-6,s
	leau	,s
	stx	2,u
	stb	1,u
	ldx	2,u
	stx	4,u
	bra	L26
L28:
	ldb	1,u
	stb	[4,u]
	ldd	4,u
	addd	#1
	std	4,u
L26:
	clr	,u
	ldx	10,u
	cmpx	#0
	beq	L27
	ldb	#1
	stb	,u
L27:
	ldd	10,u
	addd	#-1
	std	10,u
	tst	,u
	bne	L28
	ldx	2,u
	leas	6,s
	puls	u,pc
