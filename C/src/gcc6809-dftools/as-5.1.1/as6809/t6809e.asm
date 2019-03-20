	.title	6809 Error Tests

	;a   errors reported at assembly time
	;*L  errors reported at LINK time
	;
	;ASLINK -C
	;-XMS
	;T6809E
	;-B DATA = 0x100
	;-B ROM  = 0x400
	;-E
	;

	.blkb	0d256		;.area _CODE

	.area	DATA

	.globl	dat0,dat255,dat256

dat0:	.byte	4
	.blkb	254
dat255:	.byte	5
dat256:	.byte	6

	.area	ROM

	.globl	rom0,rom255,rom256

rom0:	.byte	1
	.blkb	254
rom255:	.byte	2
rom256:	.byte	3

	.sbttl	S_ACC Tests

	.area	PROGRAM

	.setdp	0,_CODE

	mmnn	=	0x2233

	adda	#0x01		;   8b 01
	adda	*0x02		;   9b 02
	adda	mmnn		;   bb 22 33
	adda	,x		;   ab 84
	adda	[mmnn]		;   ab 9f 22 33

	addb	#0x01		;   cb 01
	addb	*0x02		;   db 02
	addb	mmnn		;   fb 22 33
	addb	,x		;   eb 84
	addb	[mmnn]		;   eb 9f 22 33


	.sbttl	S_SOP Tests

	clr	#0x01		;a
	clr	*0x02		;   0f 02
	clr	mmnn		;   7f 22 33
	clr	,x		;   6f 84
	clr	[mmnn]		;   6f 9f 22 33


	.sbttl	S_LR Tests

	cmpx	#0x01		;   8c 00 01
	cmpx	*0x02		;   9c 02
	cmpx	mmnn		;   bc 22 33
	cmpx	,x		;   ac 84
	cmpx	[mmnn]		;   ac 9f 22 33


	.sbttl	S_STR Tests

	stx	#0x01		;a
	stx	*0x02		;   9f 02
	stx	mmnn		;   bf 22 33
	stx	,x		;   af 84
	stx	[mmnn]		;   af 9f 22 33


	.sbttl	S_LEA Tests

	leax	#0x01		;a
	leax	*0x02		;a
	leax	mmnn		;a
	leax	,x		;   30 84
	leax	[mmnn]		;   30 9f 22 33


	.page
	.sbttl	Direct Addressing Tests

	;*L == Error reported at LINK time !!!

	neg	*0x20		;00 20

	.setdp	0,ROM

	neg	*rom0		;   00 00
	neg	*rom255		;   00 ff

	neg	*rom256		;*L 00 00
	neg	*dat0		;*L 00 00
	neg	*dat255		;*L 00 ff
	neg	*dat256		;*L 00 00

	.setdp	0,DATA

	neg	*rom0		;*L 00 00
	neg	*rom255		;*L 00 ff
	neg	*rom256		;*L 00 00

	neg	*dat0		;   00 00
	neg	*dat255		;   00 ff
	neg	*dat256		;*L 00 00

	.setdp	0,_CODE

	neg	*rom0		;*L 00 00
	neg	*rom255		;*L 00 ff
	neg	*rom256		;*L 00 00

	neg	*dat0		;*L 00 00
	neg	*dat255		;*L 00 ff
	neg	*dat256		;*L 00 00


	.sbttl	PC and PCR mode checks

	.globl	extern

	num	=	0x7f
	ext	=	0x80

	adda	0x17,pc		;   ab 8c 17
	neg	num,pc		;   60 8c 7f
	tst	ext,pc		;   6d 8d 00 80
	tst	ext,pcr		;   6d 8c (0x80 - . - 3)
	adda	a0,pc		;a
	neg	extern,pc	;a
a0:
