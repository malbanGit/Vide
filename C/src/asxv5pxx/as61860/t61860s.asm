;  T61860S.ASM - Test file for AS61860 assembler
;
;  Assemble:
;	as61860	-glaxff	t61860s
;
	.AREA t61860 (ABS)
        .ORG  0x8030

; CPU registers

REG_I	=    0x00               ; index register
REG_J	=    0x01               ; index register
REG_A	=    0x02               ; accumulator
REG_B	=    0x03               ; accumulator
REG_XL	=    0x04               ; LSB of adress pointer
REG_XH	=    0x05               ; MSB of adress pointer
REG_YL	=    0x06               ; LSB of adress pointer
REG_YH	=    0x07               ; MSB of adress pointer
REG_K	=    0x08               ; counter
REG_L	=    0x09               ; counter
REG_M	=    0x0A               ; counter
REG_N	=    0x0B               ; counter

; Sequential Opcodes
seq1::
; 0x00 - 0x0F
	lii	0		; 00 00
	lij	0		; 01 00
	lia	0		; 02 00
	lib	0		; 03 00
	ix			; 04
	iy			; 06
	dy			; 07
	mvw			; 08
	exw			; 09
	mvb			; 0A
	exb			; 0B
	adn			; 0C
	sbn			; 0D
	adw			; 0E
	sbw			; 0F

	; 0x10 - 0x1F
	lidp	0		; 10 00 00
	lidl	0		; 11 00
	lip	0		; 12 00
	liq	0		; 13 00
	adb			; 14
	sbb			; 15
				;
				;
	mvwd			; 18
	exwd			; 19
	mvbd			; 1A
	exbd			; 1B
	srw			; 1C
	slw			; 1D
	film			; 1E
	fild			; 1F

	; 0x20 - 0x2F
	ldp			; 20
	ldq			; 21
	ldr			; 22
	ra			; 23
	ixl			; 24
	dxl			; 25
	iys			; 26
	dys			; 27
1$:	jrnzp	2$		; 28 01
2$:	jrnzm	1$		; 29 03
3$:	jrncp	4$-(3$+1)	; 2A 01
4$:	jrncm	(4$+1)-3$	; 2B 03
	jrp	1		; 2C 01
	jrm	3		; 2D 03
				;
	loop	.		; 2F 01

	; 0x30 - 0x3F
	stp			; 30
	stq			; 31
	str			; 32
				;
	push			; 34
	data			; 35
				;
	rtn			; 37
5$:	jrzp	6$		; 38 05
	jrzm	5$		; 39 03
	jrcp	6$		; 3A 01
6$:	jrcm	5$		; 3B 07
				;
				;
				;
				;

	; 0x40 - 0x4F
	inci			; 40
	deci			; 41
	inca			; 42
	deca			; 43
	adm			; 44
	sbm			; 45
	anma			; 46
	orma			; 47
	inck			; 48
	deck			; 49
	incm			; 4A
	decm			; 4B
	ina			; 4C
	nopw			; 4D
	wait	0		; 4E 00
	waitj			; 4F

	; 0x50 - 0x5F
	incp			; 50
	decp			; 51
	std			; 52
	mvdm			; 53
	readm			; 54
	mvmd			; 55
	read			; 56
	ldd			; 57
	swp			; 58
	ldm			; 59
	sl			; 5A
	pop			; 5B
				;
	outa			; 5D
				;
	outf			; 5F

	; 0x60 - 0x6F
	anim	0		; 60 00
	orim	0		; 61 00
	tsim	0		; 62 00
	cpim	0		; 63 00
	ania	0		; 64 00
	oria	0		; 65 00
	tsia	0		; 66 00
	cpia	0		; 67 00
				;
;	etc
				;
	test	0		; 6B 00
				;
				;
				;
	wait0			; 6F

	; 0x70 - 0x7F
	adim	0		; 70 00
	sbim	0		; 71 00
				;
				;
	adia	0		; 74 00
	sbia	0		; 75 00
				;
				;
	call	0		; 78 00 00
	jp	0		; 79 00 00
	ptc	0x01,	addr	; 7A 01s00r00
				;
	jpnz	.		; 7Cs80rBE
	jpnc	.		; 7Ds80rC1
	jpz	.		; 7Es80rC4
	jpc	.		; 7Fs80rC7

	; 0x80 - 0x8F
	lp	0x00		; 80
	lp	0x01		; 81
	lp	0x02		; 82
	lp	0x03		; 83
	lp	0x04		; 84
	lp	0x05		; 85
	lp	0x06		; 86
	lp	0x07		; 87
	lp	0x08		; 88
	lp	0x09		; 89
	lp	0x0A		; 8A
	lp	0x0B		; 8B
	lp	0x0C		; 8C
	lp	0x0D		; 8D
	lp	0x0E		; 8E
	lp	0x0F		; 8F

	; 0x90 - 0x9F
	lp	0x10		; 90
	lp	0x11		; 91
	lp	0x12		; 92
	lp	0x13		; 93
	lp	0x14		; 94
	lp	0x15		; 95
	lp	0x16		; 96
	lp	0x17		; 97
	lp	0x18		; 98
	lp	0x19		; 99
	lp	0x1A		; 9A
	lp	0x1B		; 9B
	lp	0x1C		; 9C
	lp	0x1D		; 9D
	lp	0x1E		; 9E
	lp	0x1F		; 9F

	; 0xA0 - 0xAF
	lp	0x20		; A0
	lp	0x21		; A1
	lp	0x22		; A2
	lp	0x23		; A3
	lp	0x24		; A4
	lp	0x25		; A5
	lp	0x26		; A6
	lp	0x27		; A7
	lp	0x28		; A8
	lp	0x29		; A9
	lp	0x2A		; AA
	lp	0x2B		; AB
	lp	0x2C		; AC
	lp	0x2D		; AD
	lp	0x2E		; AE
	lp	0x2F		; AF

	; 0xB0 - 0xBF
	lp	0x30		; B0
	lp	0x31		; B1
	lp	0x32		; B2
	lp	0x33		; B3
	lp	0x34		; B4
	lp	0x35		; B5
	lp	0x36		; B6
	lp	0x37		; B7
	lp	0x38		; B8
	lp	0x39		; B9
	lp	0x3A		; BA
	lp	0x3B		; BB
	lp	0x3C		; BC
	lp	0x3D		; BD
	lp	0x3E		; BE
	lp	0x3F		; BF

	; 0xC0 - 0xCF
	incj			; C0
	decj			; C1
	incb			; C2
	decb			; C3
	adcm			; C4
	sbcm			; C5
	tsma			; C6
	cpma			; C7
	incl			; C8
	decl			; C9
	incm			; 4A
	decm			; 4B
	inb			; CC
				;
	nopt			; CE
				;

	; 0xD0 - 0xDF
	sc			; D0
	rc			; D1
	sr			; D2
	writ			; D3
	anid	0		; D4 00
	orid	0		; D5 00
	tsid	0		; D6 00
				;
	leave			; D8
				;
	exab			; DA
	exam			; DB
				;
	outb			; DD
				;
	outc			; DF

	; 0xE0 - 0xEF
	cal	0x0000		; E0 00
	cal	0x01FF		; E1 FF
	cal	0x02FF		; E2 FF
	cal	0x03ff		; E3 FF
	cal	0x04FF		; E4 FF
	cal	0x05FF		; E5 FF
	cal	0x06FF		; E6 FF
	cal	0x07FF		; E7 FF
	cal	0x08FF		; E8 FF
	cal	0x0AFF		; EA FF
	cal	0x0BFF		; EB FF
	cal	0x0CFF		; EC FF
	cal	0x0DFF		; ED FF
	cal	0x0EFF		; EE FF
	cal	0x0FFF		; EF FF

	; 0xF0 - 0xFF
	cal	0x1000		; F0 00
	cal	0x11FF		; F1 FF
	cal	0x12FF		; F2 FF
	cal	0x13ff		; F3 FF
	cal	0x14FF		; F4 FF
	cal	0x15FF		; F5 FF
	cal	0x16FF		; F6 FF
	cal	0x17FF		; F7 FF
	cal	0x18FF		; F8 FF
	cal	0x1AFF		; FA FF
	cal	0x1BFF		; FB FF
	cal	0x1CFF		; FC FF
	cal	0x1DFF		; FD FF
	cal	0x1EFF		; FE FF
	cal	0x1FFF		; FF FF


	; Other addressing modes

	.globl	addr,	reg,	extrn

; Sequential Opcodes
seq2::
	; 0x00 - 0x0F
	lii	#0x00		; 00 00
	lij	#0x01		; 01 01
	lia	#0x02		; 02 02
	lib	#0x03		; 03 03
	ix			; 04
	iy			; 06
	dy			; 07
	mvw			; 08
	exw			; 09
	mvb			; 0A
	exb			; 0B
	adn			; 0C
	sbn			; 0D
	adw			; 0E
	sbw			; 0F

	; 0x10 - 0x1F
	lidp	addr		; 10s00r00
	lidl	>#0x1234	; 11 12
	lip	<#0x1234	; 12 34
	liq	#0x04		; 13 04
	adb			; 14
	sbb			; 15
				;
				;
	mvwd			; 18
	exwd			; 19
	mvbd			; 1A
	exbd			; 1B
	srw			; 1C
	slw			; 1D
	film			; 1E
	fild			; 1F

	; 0x20 - 0x2F
	ldp			; 20
	ldq			; 21
	ldr			; 22
	ra			; 23
	ixl			; 24
	dxl			; 25
	iys			; 26
	dys			; 27
1$:	jrnzp	2$		; 28 01
2$:	jrnzm	1$		; 29 03
3$:	jrncp	4$-(3$+1)	; 2A 01
4$:	jrncm	(4$+1)-3$	; 2B 03
	jrp	1		; 2C 01
	jrm	3		; 2D 03
				;
	loop	.		; 2F 01

	; 0x30 - 0x3F
	stp			; 30
	stq			; 31
	str			; 32
				;
	push			; 34
	data			; 35
				;
	rtn			; 37
5$:	jrzp	6$		; 38 05
	jrzm	5$		; 39 03
	jrcp	6$		; 3A 01
6$:	jrcm	5$		; 3B 07
				;
				;
				;
				;

	; 0x40 - 0x4F
	inci			; 40
	deci			; 41
	inca			; 42
	deca			; 43
	adm			; 44
	sbm			; 45
	anma			; 46
	orma			; 47
	inck			; 48
	deck			; 49
	incm			; 4A
	decm			; 4B
	ina			; 4C
	nopw			; 4D
	wait	#0x05		; 4E 05
	waitj			; 4F

	; 0x50 - 0x5F
	incp			; 50
	decp			; 51
	std			; 52
	mvdm			; 53
	readm			; 54
	mvmd			; 55
	read			; 56
	ldd			; 57
	swp			; 58
	ldm			; 59
	sl			; 5A
	pop			; 5B
				;
	outa			; 5D
				;
	outf			; 5F

	; 0x60 - 0x6F
	anim	#0x06		; 60 06
	orim	#0x07		; 61 07
	tsim	#0x08		; 62 08
	cpim	#0x09		; 63 09
	ania	#0x0A + extrn	; 64r0A
	oria	#0x0B + extrn	; 65r0B
	tsia	#0x0C + extrn	; 66r0C
	cpia	#0x0D + extrn	; 67r0D
				;
;	etc
				;
	test	#0x0E		; 6B 0E
				;
				;
				;
	wait0			; 6F

	; 0x70 - 0x7F
	adim	#0x0F		; 70 0F
	sbim	#0x10		; 71 10
				;
				;
	adia	#0x11		; 74 11
	sbia	#0x12		; 75 12
				;
				;
	call	addr + 1	; 78s00r01
	jp	addr + 2	; 79s00r02
	ptc	0x01,	addr	; 7A 01s00r00
				;
	jpnz	addr + 3	; 7Cs00r03
	jpnc	addr + 4	; 7Ds00r04
	jpz	addr + 5	; 7Es00r05
	jpc	addr + 6	; 7Fs00r06

	; 0x80 - 0x8F
	lp	reg + 0x00	;*80
	lp	reg + 0x01	;*81
	lp	reg + 0x02	;*82
	lp	reg + 0x03	;*83
	lp	reg + 0x04	;*84
	lp	reg + 0x05	;*85
	lp	reg + 0x06	;*86
	lp	reg + 0x07	;*87
	lp	reg + 0x08	;*88
	lp	reg + 0x09	;*89
	lp	reg + 0x0A	;*8A
	lp	reg + 0x0B	;*8B
	lp	reg + 0x0C	;*8C
	lp	reg + 0x0D	;*8D
	lp	reg + 0x0E	;*8E
	lp	reg + 0x0F	;*8F

	; 0x90 - 0x9F
	lp	reg + 0x10	;*90
	lp	reg + 0x11	;*91
	lp	reg + 0x12	;*92
	lp	reg + 0x13	;*93
	lp	reg + 0x14	;*94
	lp	reg + 0x15	;*95
	lp	reg + 0x16	;*96
	lp	reg + 0x17	;*97
	lp	reg + 0x18	;*98
	lp	reg + 0x19	;*99
	lp	reg + 0x1A	;*9A
	lp	reg + 0x1B	;*9B
	lp	reg + 0x1C	;*9C
	lp	reg + 0x1D	;*9D
	lp	reg + 0x1E	;*9E
	lp	reg + 0x1F	;*9F

	; 0xA0 - 0xAF
	lp	reg + 0x20	;*A0
	lp	reg + 0x21	;*A1
	lp	reg + 0x22	;*A2
	lp	reg + 0x23	;*A3
	lp	reg + 0x24	;*A4
	lp	reg + 0x25	;*A5
	lp	reg + 0x26	;*A6
	lp	reg + 0x27	;*A7
	lp	reg + 0x28	;*A8
	lp	reg + 0x29	;*A9
	lp	reg + 0x2A	;*AA
	lp	reg + 0x2B	;*AB
	lp	reg + 0x2C	;*AC
	lp	reg + 0x2D	;*AD
	lp	reg + 0x2E	;*AE
	lp	reg + 0x2F	;*AF

	; 0xB0 - 0xBF
	lp	reg + 0x30	;*B0
	lp	reg + 0x31	;*B1
	lp	reg + 0x32	;*B2
	lp	reg + 0x33	;*B3
	lp	reg + 0x34	;*B4
	lp	reg + 0x35	;*B5
	lp	reg + 0x36	;*B6
	lp	reg + 0x37	;*B7
	lp	reg + 0x38	;*B8
	lp	reg + 0x39	;*B9
	lp	reg + 0x3A	;*BA
	lp	reg + 0x3B	;*BB
	lp	reg + 0x3C	;*BC
	lp	reg + 0x3D	;*BD
	lp	reg + 0x3E	;*BE
	lp	reg + 0x3F	;*BF

	; 0xC0 - 0xCF
	incj			; C0
	decj			; C1
	incb			; C2
	decb			; C3
	adcm			; C4
	sbcm			; C5
	tsma			; C6
	cpma			; C7
	incl			; C8
	decl			; C9
	incm			; 4A
	decm			; 4B
	inb			; CC
				;
	nopt			; CE
				;

	; 0xD0 - 0xDF
	sc			; D0
	rc			; D1
	sr			; D2
	writ			; D3
	anid	#0x13		; D4 13
	orid	#0x14		; D5 14
	tsid	#0x15		; D6 15
				;
	leave			; D8
				;
	exab			; DA
	exam			; DB
				;
	outb			; DD
				;
	outc			; DF

	; 0xE0 - 0xEF
	cal	addr + 0x0000	;nE0*00
	cal	addr + 0x01FF	;nE1*FF
	cal	addr + 0x02FF	;nE2*FF
	cal	addr + 0x03ff	;nE3*FF
	cal	addr + 0x04FF	;nE4*FF
	cal	addr + 0x05FF	;nE5*FF
	cal	addr + 0x06FF	;nE6*FF
	cal	addr + 0x07FF	;nE7*FF
	cal	addr + 0x08FF	;nE8*FF
	cal	addr + 0x0AFF	;nEA*FF
	cal	addr + 0x0BFF	;nEB*FF
	cal	addr + 0x0CFF	;nEC*FF
	cal	addr + 0x0DFF	;nED*FF
	cal	addr + 0x0EFF	;nEE*FF
	cal	addr + 0x0FFF	;nEF*FF

	; 0xF0 - 0xFF
	cal	addr + 0x1000	;nF0*00
	cal	addr + 0x11FF	;nF1*FF
	cal	addr + 0x12FF	;nF2*FF
	cal	addr + 0x13ff	;nF3*FF
	cal	addr + 0x14FF	;nF4*FF
	cal	addr + 0x15FF	;nF5*FF
	cal	addr + 0x16FF	;nF6*FF
	cal	addr + 0x17FF	;nF7*FF
	cal	addr + 0x18FF	;nF8*FF
	cal	addr + 0x1AFF	;nFA*FF
	cal	addr + 0x1BFF	;nFB*FF
	cal	addr + 0x1CFF	;nFC*FF
	cal	addr + 0x1DFF	;nFD*FF
	cal	addr + 0x1EFF	;nFE*FF
	cal	addr + 0x1FFF	;nFF*FF


	.sbttl	Symbol and Area Tables

.if 0

Symbol Table

    .__.ABS.       =   0000 G   |     REG_A          =   0002 G
    REG_B          =   0003 G   |     REG_I          =   0000 G
    REG_J          =   0001 G   |     REG_K          =   0008 G
    REG_L          =   0009 G   |     REG_M          =   000A G
    REG_N          =   000B G   |     REG_XH         =   0005 G
    REG_XL         =   0004 G   |     REG_YH         =   0007 G
    REG_YL         =   0006 G   |     addr               **** GX
    extrn              **** GX  |     reg                **** GX
  2 seq1               8030 GR  |   2 seq2               8163 GR


Area Table

[_CSEG]
   0 _CODE            size    0   flags C080
   2 t61860           size 8296   flags  808
[_DSEG]
   1 _DATA            size    0   flags C0C0

.endif



