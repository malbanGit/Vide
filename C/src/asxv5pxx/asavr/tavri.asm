	.title	AVR Assembler Tests
	.module	AVR

	; All instructions
	.at90sxxxx

	.bank   CodeBank1       (FSFX = _CB1)
	.bank   DataBank1       (FSFX = _DB1)


	S_AVR = 1			; Process ALL

	S_CODE = 0			; Assembler Data Directives
	S_DATA = 0

	S_INH = 0			; Machine Instruction Groups
	S_IBYTE = 0
	S_CBR = 0
	S_IWORD = 0
	S_SNGL = 0
	S_SAME = 0
	S_DUBL = 0
	S_SER = 0
	S_SREG = 0
	S_TFLG = 0
	S_SKIP = 0
	S_BRA = 0
	S_SBRA = 0
	S_JMP = 0
	S_RJMP = 0
	S_IOR = 0
	S_IN = 0
	S_OUT = 0
	S_LD = 0
	S_ST = 0
	S_ILD = 0
	S_IST = 0
	S_LDS = 0
	S_STS = 0
	S_FMUL = 0
	S_MOVW = 0
	S_MULS = 0
	S_ELPM = 0


	.globl	xtrn			; external variable

	const = 0x12			; local constants
	n6 = 0x06


	.page
	.sbttl	.sbttl	Code Area Tests

	; The AVR Code Segment Characteristics:
	;	Addressing is by word (2-bytes per word)

	.area   CODE1   (REL,CSEG,Bank=CodeBank1)

CODE1::

.if S_AVR | S_CODE
L_S_CODE:
	.byte	0x00,	0x01,	0x02,	0x03,	0x04,	0x05
	.byte	0x06,	0x07
	.byte	0x08
	.byte	external		; r error

	.word	0x1110,	0x1312

	.ascii	"0123456789"
	.ascii	"0123456789A"
	.asciz	"0123456789"
	.asciz	"0123456789A"
	.ascis	"0123456789"
	.ascis	"0123456789A"
.endif


	.page
	.sbttl	S_INH

.if S_AVR | S_INH
L_S_INH:
	nop
.endif


	.page
	.sbttl	S_IBYTE

.if S_AVR | S_IBYTE
L_S_IBYTE:
	andi	r0,#255			; a	ro
	andi	r0,255			; a	r0
	andi	r0,#256			; a	r0, > 255
	andi	r0,256			; a	r0, > 255

	andi	r15,#255		; a	r15
	andi	r15,255			; a	r15
	andi	r15,#256		; a	r15, > 255
	andi	r15,256			; a	r15, > 255

	andi	r16,#255
	andi	r16,255
	andi	r16,#256		; a	> 255
	andi	r16,256			; a	> 255

	andi	r31,#255
	andi	r31,255
	andi	r31,#256		; a	> 255
	andi	r31,256			; a	> 255

	andi	r31,#-1			; a	(unsigned -1) > 255

	andi	r31,#const
	andi	r31,const

	andi	r31,#xtrn
	andi	r31,xtrn
.endif


	.page
	.sbttl	S_CBR

.if S_AVR | S_CBR
L_S_CBR:
	cbr	r0,#255			; a	r0
	cbr	r0,255			; a	r0
	cbr	r0,#256			; a	r0, > 255
	cbr	r0,256			; a	r0, > 255

	cbr	r15,#255		; a	r15
	cbr	r15,255			; a	r15
	cbr	r15,#256		; a	r15, > 255
	cbr	r15,256			; a	r15, > 255

	cbr	r16,#255
	cbr	r16,255
	cbr	r16,#256		; a	> 255
	cbr	r16,256			; a	> 255

	cbr	r31,#255
	cbr	r31,255
	cbr	r31,#256		; a	> 255
	cbr	r31,256			; a	> 255

	cbr	r31,#-1			; a	(unsigned -1) > 255

	cbr	r31,#const
	cbr	r31,const

	cbr	r31,#xtrn		; a	linker cannot complement xtrn
	cbr	r31,xtrn		; a	linker cannot complement xtrn
.endif


	.page
	.sbttl	S_IWORD

.if S_AVR | S_IWORD
L_S_IWORD:
	adiw	r0,#63			; a	r0
	adiw	r0,63			; a	r0
	adiw	r0,#64			; a	r0, > 63
	adiw	r0,64			; a	r0, > 63

	adiw	r23,#63			; a	r23
	adiw	r23,63			; a	r23
	adiw	r23,#64			; a	r23, > 63
	adiw	r23,64			; a	r23, > 63

	adiw	r24,#63
	adiw	r24,63
	adiw	r24,#64			; a	> 63
	adiw	r24,64			; a	> 63

	adiw	r30,#63
	adiw	r30,63
	adiw	r30,#64			; a	> 63
	adiw	r30,64			; a	> 63

	adiw	r30,#-1			; a	(unsigned -1) > 63

	adiw	r30,#const
	adiw	r30,const

	adiw	r30,#xtrn
	adiw	r30,xtrn

	adiw	r31,0			; a	r31
.endif


	.page
	.sbttl	S_SNGL

.if S_AVR | S_SNGL
L_S_SNGL:
	asr	r0
	asr	r31
.endif


	.page
	.sbttl	S_SAME

.if S_AVR | S_SAME
L_S_SAME:
	clr	r0
	clr	r15
	clr	r16
	clr	r31
.endif


	.page
	.sbttl	S_DUBL

.if S_AVR | S_DUBL
L_S_DUBL:
	adc	r0,r1
	adc	r15,r8
	add	r16,r16
	add	r31,r31
.endif


	.page
	.sbttl	S_SER

.if S_AVR | S_SER
L_S_SER:
	ser	r0			; a	r0
	ser	r15			; a	r15
	ser	r16
	ser	r31
.endif


	.page
	.sbttl	S_SREG

.if S_AVR | S_SREG
L_S_SREG:
	bclr	#0
	bclr	0
	bclr	#7
	bclr	7

	bclr	#n6
	bclr	n6
	bclr	#xtrn			; r	external
	bclr	xtrn			; r	external

	bclr	#8			; a	8
	bclr	8			; a	8
.endif


	.page
	.sbttl	S_TFLG

.if S_AVR | S_TFLG
L_S_TFLG:
	bld	r0,#0
	bld	r15,0
	bld	r16,#7
	bld	r31,7

	bld	r0,#n6
	bld	r15,n6
	bld	r16,#xtrn		; r	external
	bld	r31,xtrn		; r	external

	bld	r0,#8			; a	8
	bld	r31,8			; a	8
.endif


	.page
	.sbttl	S_SKIP

.if S_AVR | S_SKIP
L_S_SKIP:
	sbrc	r0,#0
	sbrc	r15,0
	sbrc	r16,#7
	sbrc	r31,7

	sbrc	r0,#n6
	sbrc	r15,n6
	sbrc	r16,#xtrn		; r	external
	sbrc	r31,xtrn		; r	external

	sbrc	r0,#8			; a	8
	sbrc	r31,8			; a	8
.endif


	.page
	.sbttl	S_BRA

.if S_AVR | S_BRA
L_S_BRA:
1$:	. = . + 64
	brcc	1$			; a	displacement > -64
2$:	. = . + 63
	brcc	2$
3$:	brcc	3$
	brcc	4$
4$:	brcc	5$
	. = . + 63
5$:	brcc	7$			; a	displacement > 63
6$:	. = . + 64
7$:
	brcc	xtrn
.endif


	.page
	.sbttl	S_SBRA

.if S_AVR | S_SBRA
L_S_SBRA:
1$:	. = . + 64
	brbc	1,1$			; a	displacement > -64
2$:	. = . + 63
	brbc	2,2$
3$:	brbc	3,3$
	brbc	4,4$
4$:	brbc	5,5$
	. = . + 63
5$:	brbc	7,7$			; a	displacement > 63
6$:	. = . + 64
7$:
	brbc	1,xtrn

L_S_SBRA_1:
1$:	. = . + 64
	brbc	#1,1$			; a	displacement > -64
2$:	. = . + 63
	brbc	#2,2$
3$:	brbc	#3,3$
	brbc	#4,4$
4$:	brbc	#5,5$
	. = . + 63
5$:	brbc	#7,7$			; a	displacement > 63
6$:	. = . + 64
7$:
	brbc	#1,xtrn

L_S_SBRA_2:
1$:	brbc	xtrn,1$			; r	xtrn
2$:	brbc	#xtrn,2$		; r	xtrn
.endif


	.page
	.sbttl	S_JMP

.if S_AVR | S_JMP
L_S_JMP:
	jmp	1$
	jmp	CODE1
1$:	jmp	xtrn
.endif


	.page
	.sbttl	S_RJMP

.if S_AVR | S_RJMP
L_S_RJMP:
	.avr_4K		0	        ; standard mode

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
	rjmp	xtrn

L_S_RJMP_1:
	.avr_4K		1		; 4K mode

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
	rjmp	xtrn

	.avr_4k		0		; standard mode
.endif


	.page
	.sbttl	S_IOR

.if S_AVR | S_IOR
L_S_IOR:
       cbi	0,0
       cbi	31,0
       cbi	#0,0
       cbi	#31,0
       cbi	0,#0
       cbi	31,#0
       cbi	#0,#0
       cbi	#31,#0

       cbi	0,7
       cbi	31,7
       cbi	#0,7
       cbi	#31,7
       cbi	0,#7
       cbi	31,#7
       cbi	#0,#7
       cbi	#31,#7

       cbi	32,0			; a	> 31
       cbi	#32,0			; a	> 31
       cbi	0,8			; a	> 7
       cbi	0,#8			; a	> 7

       cbi	#const,0
       cbi	#xtrn,0
       cbi	#0,xtrn			; r	external
       cbi	#31,xtrn		; r	external
.endif


	.page
	.sbttl	S_IN

.if S_AVR | S_IN
L_S_IN:		; Rd,P
       in	r0,0
       in	r31,0
       in	r0,#0
       in	r31,#0

       in	r0,63
       in	r31,63
       in	r0,#63
       in	r31,#63

       in	r0,64			; a	> 63
       in	r31,#64			; a	> 63

       in	r0,0
       in	r0,xtrn
       in	r31,#xtrn
.endif


	.page
	.sbttl	S_OUT

.if S_AVR | S_OUT
L_S_OUT:	; Rd,P
       out	0,r0
       out	0,r31
       out	#0,r0
       out	#0,r31

       out	63,r0
       out	63,r31
       out	#63,r0
       out	#63,r31

       out	64,r0			; a	> 63
       out	#64,r31			; a	> 63

       out	0,r0
       out	xtrn,r0
       out	#xtrn,r31
.endif


	.page
	.sbttl	S_LD

.if S_AVR | S_LD
L_S_LD:
	ld	r0,x
	ld	r0,x+
	ld	r0,-x
	ld	r31,x
	ld	r31,x+
	ld	r31,-x

	ld	r0,y
	ld	r0,y+
	ld	r0,-y
	ld	r31,y
	ld	r31,y+
	ld	r31,-y

	ld	r0,z
	ld	r0,z+
	ld	r0,-z
	ld	r31,z
	ld	r31,z+
	ld	r31,-z
.endif


	.page
	.sbttl	S_ST

.if S_AVR | S_ST
L_S_ST:
	st	x,r0
	st	x+,r0
	st	-x,r0
	st	x,r31
	st	x+,r31
	st	-x,r31

	st	y,r0
	st	y+,r0
	st	-y,r0
	st	y,r31
	st	y+,r31
	st	-y,r31

	st	z,r0
	st	z+,r0
	st	-z,r0
	st	z,r31
	st	z+,r31
	st	-z,r31
.endif


	.page
	.sbttl	S_ILD

.if S_AVR | S_ILD
L_S_ILD:
	ldd	r0,x+0			; a	x
	ldd	r31,x+0			; a	x
	ldd	r0,x+#0			; a	x
	ldd	r31,x+#0		; a	x

	ldd	r0,y+0
	ldd	r31,y+0
	ldd	r0,y+#0
	ldd	r31,y+#0

	ldd	r0,y+63
	ldd	r31,y+63
	ldd	r0,y+#63
	ldd	r31,y+#63

	ldd	r0,y+64			; a	> 63
	ldd	r31,y+64		; a	> 63
	ldd	r0,y+#64		; a	> 63
	ldd	r31,y+#64		; a	> 63

	ldd	r0,y+xtrn
	ldd	r31,y+xtrn
	ldd	r0,y+#xtrn
	ldd	r31,y+#xtrn

	ldd	r0,y+const
	ldd	r31,y+const
	ldd	r0,y+#const
	ldd	r31,y+#const

	ldd	r0,z+0
	ldd	r31,z+0
	ldd	r0,z+#0
	ldd	r31,z+#0

	ldd	r0,z+63
	ldd	r31,z+63
	ldd	r0,z+#63
	ldd	r31,z+#63

	ldd	r0,z+64			; a	> 63
	ldd	r31,z+64		; a	> 63
	ldd	r0,z+#64		; a	> 63
	ldd	r31,z+#64		; a	> 63

	ldd	r0,z+xtrn
	ldd	r31,z+xtrn
	ldd	r0,z+#xtrn
	ldd	r31,z+#xtrn

	ldd	r0,z+const
	ldd	r31,z+const
	ldd	r0,z+#const
	ldd	r31,z+#const

.endif


	.page
	.sbttl	S_IST

.if S_AVR | S_IST
L_S_IST:
	std	x+0,r0			; a	x
	std	x+0,r31			; a	x
	std	x+#0,r0			; a	x
	std	x+#0,r31		; a	x

	std	y+0,r0
	std	y+0,r31
	std	y+#0,r0
	std	y+#0,r31

	std	y+63,r0
	std	y+63,r31
	std	y+#63,r0
	std	y+#63,r31

	std	y+64,r0			; a	> 63
	std	y+64,r31		; a	> 63
	std	y+#64,r0		; a	> 63
	std	y+#64,r31		; a	> 63

	std	y+xtrn,r0
	std	y+xtrn,r31
	std	y+#xtrn,r0
	std	y+#xtrn,r31

	std	y+const,r0
	std	y+const,r31
	std	y+#const,r0
	std	y+#const,r31

	std	z+0,r0
	std	z+0,r31
	std	z+#0,r0
	std	z+#0,r31

	std	z+63,r0
	std	z+63,r31
	std	z+#63,r0
	std	z+#63,r31

	std	z+64,r0			; a	> 63
	std	z+64,r31		; a	> 63
	std	z+#64,r0		; a	> 63
	std	z+#64,r31		; a	> 63

	std	z+xtrn,r0
	std	z+xtrn,r31
	std	z+#xtrn,r0
	std	z+#xtrn,r31

	std	z+const,r0
	std	z+const,r31
	std	z+#const,r0
	std	z+#const,r31

.endif


	.page
	.sbttl	S_LDS

.if S_AVR | S_LDS
L_S_LDS:
	lds	r0,DATA1
	lds	r31,DATA1
	lds	r0,#DATA1		; a	#
	lds	r31,#DATA1		; a	#
.endif


	.page
	.sbttl	S_STS

.if S_AVR | S_STS
L_S_STS:
	sts	DATA1,r0
	sts	DATA1,r31
	sts	#DATA1,r0		; a	#
	sts	#DATA1,r31		; a	#
.endif


	.page
	.sbttl	S_FMUL

.if S_AVR | S_FMUL
L_S_FMUL:
	fmul	r0,r16			; a	r0
	fmup	r15,r16			; a	r15
	fmul	r16,r16
	fmul	r23,r16
	fmul	r24,r16			; a	r24
	fmul	r31,r16			; a	r31

	fmul	r16,r0			; a	r0
	fmul	r16,r15			; a	r15
	fmul	r16,r16
	fmul	r16,r23
	fmul	r16,r24			; a	r24
	fmul	r16,r31			; a	r31
.endif


	.page
	.sbttl	S_MOVW

.if S_AVR | S_MOVW
L_S_MOVW:
	movw	r0,r0
	movw	r1,r0			; a	r1
	movw	r2,r0
	movw	r29,r0			; a	r29
	movw	r30,r0
	movw	r31,r0			; a	r31

	movw	r0,r0
	movw	r0,r1			; a	r1
	movw	r0,r2
	movw	r0,r29			; a	r29
	movw	r0,r30
	movw	r0,r31			; a	r31
.endif


	.page
	.sbttl	S_MULS

.if S_AVR | S_MULS
L_S_MULS:
	muls	r0,r16			; a	r0
	muls	r15,r16			; a	r15
	muls	r16,r16
	muls	r31,r16

	muls	r16,r0			; a	r0
	muls	r16,r15			; a	r15
	muls	r16,r16
	muls	r16,r31
.endif


	.page
	.sbttl	S_ELPM

.if S_AVR | S_ELPM
L_S_ELPM:
	elpm

	elpm	r0,x			; a	x
	elpm	r0,x+			; a	x
	elpm	r0,-x			; a	x
	elpm	r31,x			; a	x
	elpm	r31,x+			; a	x
	elpm	r31,-x			; a	x

	elpm	r0,y			; a	x
	elpm	r0,y+			; a	x
	elpm	r0,-y			; a	x
	elpm	r31,y			; a	x
	elpm	r31,y+			; a	x
	elpm	r31,-y			; a	x

	elpm	r0,z
	elpm	r0,z+
	elpm	r0,-z			; a	x
	elpm	r31,z
	elpm	r31,z+
	elpm	r31,-z			; a	x
.endif


	.page
	.sbttl	Data Area Tests

	; The AVR Data Segment Characteristics:
	;	Addressing is by byte

	.area   DATA1	(REL,DSEG,BANK=DataBank1)

DATA1::

.if S_AVR | S_DATA
L_S_DATA:
	.byte	0x00,	0x01,	0x02,	0x03,	0x04,	0x05
	.byte	0x06,	0x07
	.byte	0x08
	.byte	external

	.word	0x1110,	0x1312

	.ascii	"0123456789"
	.ascii	"0123456789A"
	.asciz	"0123456789"
	.asciz	"0123456789A"
	.ascis	"0123456789"
	.ascis	"0123456789A"
.endif

;.end
