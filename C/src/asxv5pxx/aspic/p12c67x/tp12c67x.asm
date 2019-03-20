;  TP12C67X.ASM - Test file for ASPIC assembler
;
;  Assemble:
;	aspic -gloaxff tp12c67x
;

	.include	"tp12c67x.def"

	.area	DATA

	triscode =	6

	fcode =		1
	wcode =		0

	num0 =		0
	num7 =		7

	.area	CODE

	addr_00	=	. + 0x00
	addr_7FF =	. + 0x7ff

	nop			; 00 00

	return			; 08 00
	retfie			; 09 00

	sleep			; 63 00
	clrwdt			; 64 00

	tris	6		; 66 00
	tris	#6		; 66 00
	tris	triscode	; 66 00
	tris	#triscode	; 66 00

	movwf	0x00		; 80 00
	movwf	0x7F		; FF 00
	movwf	extreg		;*80n00

	movwf	*0x00		; 80 00
	movwf	*0x7F		; FF 00
	movwf	*extreg		;*80n00

	clrw			; 03 01

	clrf	0x00		; 80 01
	clrf	0x7F		; FF 01
	clrf	extreg		;*80n01

	clrf	*0x00		; 80 01
	clrf	*0x7F		; FF 01
	clrf	*extreg		;*80n01

	subwf	0x00,w		; 00 02
	subwf	0x7F,w		; 7F 02
	subwf	extreg,w	;*00n02

	subwf	*0x00,w		; 00 02
	subwf	*0x7F,w		; 7F 02
	subwf	*extreg,w	;*00n02

	subwf	0x00,f		; 80 02
	subwf	0x7F,f		; FF 02
	subwf	extreg,f	;*80n02

	subwf	*0x00,f		; 80 02
	subwf	*0x7F,f		; FF 02
	subwf	*extreg,f	;*80n02

	subwf	0x00,0		; 00 02
	subwf	*0x00,0		; 00 02
	subwf	extreg,0	;*00n02
	subwf	*extreg,0	;*00n02
	subwf	0x00,#0		; 00 02
	subwf	*0x00,#0	; 00 02
	subwf	extreg,#0	;*00n02
	subwf	*extreg,#0	;*00n02
	subwf	0x00,wcode	; 00 02
	subwf	*0x00,wcode	; 00 02
	subwf	extreg,wcode	;*00n02
	subwf	*extreg,wcode	;*00n02
	subwf	0x00,#wcode	; 00 02
	subwf	*0x00,#wcode	; 00 02
	subwf	extreg,#wcode	;*00n02
	subwf	*extreg,#wcode	;*00n02

	subwf	0x00,1		; 80 02
	subwf	*0x00,1		; 80 02
	subwf	extreg,1	;*80n02
	subwf	*extreg,1	;*80n02
	subwf	0x00,#1		; 80 02
	subwf	*0x00,#1	; 80 02
	subwf	extreg,#1	;*80n02
	subwf	*extreg,#1	;*80n02
	subwf	0x00,fcode	; 80 02
	subwf	*0x00,fcode	; 80 02
	subwf	extreg,fcode	;*80n02
	subwf	*extreg,fcode	;*80n02
	subwf	0x00,#fcode	; 80 02
	subwf	*0x00,#fcode	; 80 02
	subwf	extreg,#fcode	;*80n02
	subwf	*extreg,#fcode	;*80n02

	decf	0x00,w		; 00 03
	decf	0x7F,w		; 7F 03
	decf	extreg,w	;*00n03

	decf	0x00,f		; 80 03
	decf	0x7F,f		; FF 03
	decf	extreg,f	;*80n03

	decf	*0x00,w		; 00 03
	decf	*0x7F,w		; 7F 03
	decf	*extreg,w	;*00n03

	decf	*0x00,f		; 80 03
	decf	*0x7F,f		; FF 03
	decf	*extreg,f	;*80n03

	decf	0x00,0		; 00 03
	decf	*0x00,0		; 00 03
	decf	extreg,0	;*00n03
	decf	*extreg,0	;*00n03
	decf	0x00,#0		; 00 03
	decf	*0x00,#0	; 00 03
	decf	extreg,#0	;*00n03
	decf	*extreg,#0	;*00n03
	decf	0x00,wcode	; 00 03
	decf	*0x00,wcode	; 00 03
	decf	extreg,wcode	;*00n03
	decf	*extreg,wcode	;*00n03
	decf	0x00,#wcode	; 00 03
	decf	*0x00,#wcode	; 00 03
	decf	extreg,#wcode	;*00n03
	decf	*extreg,#wcode	;*00n03

	decf	0x00,1		; 80 03
	decf	*0x00,1		; 80 03
	decf	extreg,1	;*80n03
	decf	*extreg,1	;*80n03
	decf	0x00,#1		; 80 03
	decf	*0x00,#1	; 80 03
	decf	extreg,#1	;*80n03
	decf	*extreg,#1	;*80n03
	decf	0x00,fcode	; 80 03
	decf	*0x00,fcode	; 80 03
	decf	extreg,fcode	;*80n03
	decf	*extreg,fcode	;*80n03
	decf	0x00,#fcode	; 80 03
	decf	*0x00,#fcode	; 80 03
	decf	extreg,#fcode	;*80n03
	decf	*extreg,#fcode	;*80n03

	iorwf	0x00,w		; 00 04
	iorwf	0x7F,w		; 7F 04
	iorwf	extreg,w	;*00n04

	iorwf	0x00,f		; 80 04
	iorwf	0x7F,f		; FF 04
	iorwf	extreg,f	;*80n04

	iorwf	*0x00,w		; 00 04
	iorwf	*0x7F,w		; 7F 04
	iorwf	*extreg,w	;*00n04

	iorwf	*0x00,f		; 80 04
	iorwf	*0x7F,f		; FF 04
	iorwf	*extreg,f	;*80n04

	iorwf	0x00,0		; 00 04
	iorwf	*0x00,0		; 00 04
	iorwf	extreg,0	;*00n04
	iorwf	*extreg,0	;*00n04
	iorwf	0x00,#0		; 00 04
	iorwf	*0x00,#0	; 00 04
	iorwf	extreg,#0	;*00n04
	iorwf	*extreg,#0	;*00n04
	iorwf	0x00,wcode	; 00 04
	iorwf	*0x00,wcode	; 00 04
	iorwf	extreg,wcode	;*00n04
	iorwf	*extreg,wcode	;*00n04
	iorwf	0x00,#wcode	; 00 04
	iorwf	*0x00,#wcode	; 00 04
	iorwf	extreg,#wcode	;*00n04
	iorwf	*extreg,#wcode	;*00n04

	iorwf	0x00,1		; 80 04
	iorwf	*0x00,1		; 80 04
	iorwf	extreg,1	;*80n04
	iorwf	*extreg,1	;*80n04
	iorwf	0x00,#1		; 80 04
	iorwf	*0x00,#1	; 80 04
	iorwf	extreg,#1	;*80n04
	iorwf	*extreg,#1	;*80n04
	iorwf	0x00,fcode	; 80 04
	iorwf	*0x00,fcode	; 80 04
	iorwf	extreg,fcode	;*80n04
	iorwf	*extreg,fcode	;*80n04
	iorwf	0x00,#fcode	; 80 04
	iorwf	*0x00,#fcode	; 80 04
	iorwf	extreg,#fcode	;*80n04
	iorwf	*extreg,#fcode	;*80n04

	andwf	0x00,w		; 00 05
	andwf	0x7F,w		; 7F 05
	andwf	extreg,w	;*00n05

	andwf	0x00,f		; 80 05
	andwf	0x7F,f		; FF 05
	andwf	extreg,f	;*80n05

	andwf	*0x00,w		; 00 05
	andwf	*0x7F,w		; 7F 05
	andwf	*extreg,w	;*00n05

	andwf	*0x00,f		; 80 05
	andwf	*0x7F,f		; FF 05
	andwf	*extreg,f	;*80n05

	andwf	0x00,0		; 00 05
	andwf	*0x00,0		; 00 05
	andwf	extreg,0	;*00n05
	andwf	*extreg,0	;*00n05
	andwf	0x00,#0		; 00 05
	andwf	*0x00,#0	; 00 05
	andwf	extreg,#0	;*00n05
	andwf	*extreg,#0	;*00n05
	andwf	0x00,wcode	; 00 05
	andwf	*0x00,wcode	; 00 05
	andwf	extreg,wcode	;*00n05
	andwf	*extreg,wcode	;*00n05
	andwf	0x00,#wcode	; 00 05
	andwf	*0x00,#wcode	; 00 05
	andwf	extreg,#wcode	;*00n05
	andwf	*extreg,#wcode	;*00n05

	andwf	0x00,1		; 80 05
	andwf	*0x00,1		; 80 05
	andwf	extreg,1	;*80n05
	andwf	*extreg,1	;*80n05
	andwf	0x00,#1		; 80 05
	andwf	*0x00,#1	; 80 05
	andwf	extreg,#1	;*80n05
	andwf	*extreg,#1	;*80n05
	andwf	0x00,fcode	; 80 05
	andwf	*0x00,fcode	; 80 05
	andwf	extreg,fcode	;*80n05
	andwf	*extreg,fcode	;*80n05
	andwf	0x00,#fcode	; 80 05
	andwf	*0x00,#fcode	; 80 05
	andwf	extreg,#fcode	;*80n05
	andwf	*extreg,#fcode	;*80n05

	xorwf	0x00,w		; 00 06
	xorwf	0x7F,w		; 7F 06
	xorwf	extreg,w	;*00n06

	xorwf	0x00,f		; 80 06
	xorwf	0x7F,f		; FF 06
	xorwf	extreg,f	;*80n06

	xorwf	*0x00,w		; 00 06
	xorwf	*0x7F,w		; 7F 06
	xorwf	*extreg,w	;*00n06

	xorwf	*0x00,f		; 80 06
	xorwf	*0x7F,f		; FF 06
	xorwf	*extreg,f	;*80n06

	xorwf	0x00,0		; 00 06
	xorwf	*0x00,0		; 00 06
	xorwf	extreg,0	;*00n06
	xorwf	*extreg,0	;*00n06
	xorwf	0x00,#0		; 00 06
	xorwf	*0x00,#0	; 00 06
	xorwf	extreg,#0	;*00n06
	xorwf	*extreg,#0	;*00n06
	xorwf	0x00,wcode	; 00 06
	xorwf	*0x00,wcode	; 00 06
	xorwf	extreg,wcode	;*00n06
	xorwf	*extreg,wcode	;*00n06
	xorwf	0x00,#wcode	; 00 06
	xorwf	*0x00,#wcode	; 00 06
	xorwf	extreg,#wcode	;*00n06
	xorwf	*extreg,#wcode	;*00n06

	xorwf	0x00,1		; 80 06
	xorwf	*0x00,1		; 80 06
	xorwf	extreg,1	;*80n06
	xorwf	*extreg,1	;*80n06
	xorwf	0x00,#1		; 80 06
	xorwf	*0x00,#1	; 80 06
	xorwf	extreg,#1	;*80n06
	xorwf	*extreg,#1	;*80n06
	xorwf	0x00,fcode	; 80 06
	xorwf	*0x00,fcode	; 80 06
	xorwf	extreg,fcode	;*80n06
	xorwf	*extreg,fcode	;*80n06
	xorwf	0x00,#fcode	; 80 06
	xorwf	*0x00,#fcode	; 80 06
	xorwf	extreg,#fcode	;*80n06
	xorwf	*extreg,#fcode	;*80n06

	addwf	0x00,w		; 00 07
	addwf	0x7F,w		; 7F 07
	addwf	extreg,w	;*00n07

	addwf	0x00,f		; 80 07
	addwf	0x7F,f		; FF 07
	addwf	extreg,f	;*80n07

	addwf	*0x00,w		; 00 07
	addwf	*0x7F,w		; 7F 07
	addwf	*extreg,w	;*00n07

	addwf	*0x00,f		; 80 07
	addwf	*0x7F,f		; FF 07
 	addwf	*extreg,f	;*80n07

	addwf	0x00,0		; 00 07
	addwf	*0x00,0		; 00 07
	addwf	extreg,0	;*00n07
	addwf	*extreg,0	;*00n07
	addwf	0x00,#0		; 00 07
	addwf	*0x00,#0	; 00 07
	addwf	extreg,#0	;*00n07
	addwf	*extreg,#0	;*00n07
	addwf	0x00,wcode	; 00 07
	addwf	*0x00,wcode	; 00 07
	addwf	extreg,wcode	;*00n07
	addwf	*extreg,wcode	;*00n07
	addwf	0x00,#wcode	; 00 07
	addwf	*0x00,#wcode	; 00 07
	addwf	extreg,#wcode	;*00n07
	addwf	*extreg,#wcode	;*00n07

	addwf	0x00,1		; 80 07
	addwf	*0x00,1		; 80 07
	addwf	extreg,1	;*80n07
	addwf	*extreg,1	;*80n07
	addwf	0x00,#1		; 80 07
	addwf	*0x00,#1	; 80 07
	addwf	extreg,#1	;*80n07
	addwf	*extreg,#1	;*80n07
	addwf	0x00,fcode	; 80 07
	addwf	*0x00,fcode	; 80 07
	addwf	extreg,fcode	;*80n07
	addwf	*extreg,fcode	;*80n07
	addwf	0x00,#fcode	; 80 07
	addwf	*0x00,#fcode	; 80 07
	addwf	extreg,#fcode	;*80n07
	addwf	*extreg,#fcode	;*80n07

	movf	0x00,w		; 00 08
	movf	0x7F,w		; 7F 08
	movf	extreg,w	;*00n08

	movf	0x00,f		; 80 08
	movf	0x7F,f		; FF 08
	movf	extreg,f	;*80n08

	movf	*0x00,w		; 00 08
	movf	*0x7F,w		; 7F 08
	movf	*extreg,w	;*00n08

	movf	*0x00,f		; 80 08
	movf	*0x7F,f		; FF 08
	movf	*extreg,f	;*80n08

	movf	0x00,0		; 00 08
	movf	*0x00,0		; 00 08
	movf	extreg,0	;*00n08
	movf	*extreg,0	;*00n08
	movf	0x00,#0		; 00 08
	movf	*0x00,#0	; 00 08
	movf	extreg,#0	;*00n08
	movf	*extreg,#0	;*00n08
	movf	0x00,wcode	; 00 08
	movf	*0x00,wcode	; 00 08
	movf	extreg,wcode	;*00n08
	movf	*extreg,wcode	;*00n08
	movf	0x00,#wcode	; 00 08
	movf	*0x00,#wcode	; 00 08
	movf	extreg,#wcode	;*00n08
	movf	*extreg,#wcode	;*00n08

	movf	0x00,1		; 80 08
	movf	*0x00,1		; 80 08
	movf	extreg,1	;*80n08
	movf	*extreg,1	;*80n08
	movf	0x00,#1		; 80 08
	movf	*0x00,#1	; 80 08
	movf	extreg,#1	;*80n08
	movf	*extreg,#1	;*80n08
	movf	0x00,fcode	; 80 08
	movf	*0x00,fcode	; 80 08
	movf	extreg,fcode	;*80n08
	movf	*extreg,fcode	;*80n08
	movf	0x00,#fcode	; 80 08
	movf	*0x00,#fcode	; 80 08
	movf	extreg,#fcode	;*80n08
	movf	*extreg,#fcode	;*80n08

	comf	0x00,w		; 00 09
	comf	0x7F,w		; 7F 09
	comf	extreg,w	;*00n09

	comf	0x00,f		; 80 09
	comf	0x7F,f		; FF 09
 	comf	extreg,f	;*80n09

	comf	*0x00,w		; 00 09
	comf	*0x7F,w		; 7F 09
	comf	*extreg,w	;*00n09

	comf	*0x00,f		; 80 09
	comf	*0x7F,f		; FF 09
 	comf	*extreg,f	;*80n09

	comf	0x00,0		; 00 09
	comf	*0x00,0		; 00 09
	comf	extreg,0	;*00n09
	comf	*extreg,0	;*00n09
	comf	0x00,#0		; 00 09
	comf	*0x00,#0	; 00 09
	comf	extreg,#0	;*00n09
	comf	*extreg,#0	;*00n09
	comf	0x00,wcode	; 00 09
	comf	*0x00,wcode	; 00 09
	comf	extreg,wcode	;*00n09
	comf	*extreg,wcode	;*00n09
	comf	0x00,#wcode	; 00 09
	comf	*0x00,#wcode	; 00 09
	comf	extreg,#wcode	;*00n09
	comf	*extreg,#wcode	;*00n09

	comf	0x00,1		; 80 09
	comf	*0x00,1		; 80 09
	comf	extreg,1	;*80n09
	comf	*extreg,1	;*80n09
	comf	0x00,#1		; 80 09
	comf	*0x00,#1	; 80 09
	comf	extreg,#1	;*80n09
	comf	*extreg,#1	;*80n09
	comf	0x00,fcode	; 80 09
	comf	*0x00,fcode	; 80 09
	comf	extreg,fcode	;*80n09
	comf	*extreg,fcode	;*80n09
	comf	0x00,#fcode	; 80 09
	comf	*0x00,#fcode	; 80 09
	comf	extreg,#fcode	;*80n09
	comf	*extreg,#fcode	;*80n09

	incf	0x00,w		; 00 0A
	incf	0x7F,w		; 7F 0A
	incf	extreg,w	;*00n0A

	incf	0x00,f		; 80 0A
	incf	0x7F,f		; FF 0A
	incf	extreg,f	;*80n0A

	incf	*0x00,w		; 00 0A
	incf	*0x7F,w		; 7F 0A
	incf	*extreg,w	;*00n0A

	incf	*0x00,f		; 80 0A
	incf	*0x7F,f		; FF 0A
	incf	*extreg,f	;*80n0A

	incf	0x00,0		; 00 0A
	incf	*0x00,0		; 00 0A
	incf	extreg,0	;*00n0A
	incf	*extreg,0	;*00n0A
	incf	0x00,#0		; 00 0A
	incf	*0x00,#0	; 00 0A
	incf	extreg,#0	;*00n0A
	incf	*extreg,#0	;*00n0A
	incf	0x00,wcode	; 00 0A
	incf	*0x00,wcode	; 00 0A
	incf	extreg,wcode	;*00n0A
	incf	*extreg,wcode	;*00n0A
	incf	0x00,#wcode	; 00 0A
	incf	*0x00,#wcode	; 00 0A
	incf	extreg,#wcode	;*00n0A
	incf	*extreg,#wcode	;*00n0A

	incf	0x00,1		; 80 0A
	incf	*0x00,1		; 80 0A
	incf	extreg,1	;*80n0A
	incf	*extreg,1	;*80n0A
	incf	0x00,#1		; 80 0A
	incf	*0x00,#1	; 80 0A
	incf	extreg,#1	;*80n0A
	incf	*extreg,#1	;*80n0A
	incf	0x00,fcode	; 80 0A
	incf	*0x00,fcode	; 80 0A
	incf	extreg,fcode	;*80n0A
	incf	*extreg,fcode	;*80n0A
	incf	0x00,#fcode	; 80 0A
	incf	*0x00,#fcode	; 80 0A
	incf	extreg,#fcode	;*80n0A
	incf	*extreg,#fcode	;*80n0A

	decfsz	0x00,w		; 00 0B
	decfsz	0x7F,w		; 7F 0B
	decfsz	extreg,w	;*00n0B

	decfsz	0x00,f		; 80 0B
	decfsz	0x7F,f		; FF 0B
	decfsz	extreg,f	;*80n0B

	decfsz	*0x00,w		; 00 0B
	decfsz	*0x7F,w		; 7F 0B
	decfsz	*extreg,w	;*00n0B

	decfsz	*0x00,f		; 80 0B
	decfsz	*0x7F,f		; FF 0B
 	decfsz	*extreg,f	;*80n0B

	decfsz	0x00,0		; 00 0B
	decfsz	*0x00,0		; 00 0B
	decfsz	extreg,0	;*00n0B
	decfsz	*extreg,0	;*00n0B
	decfsz	0x00,#0		; 00 0B
	decfsz	*0x00,#0	; 00 0B
	decfsz	extreg,#0	;*00n0B
	decfsz	*extreg,#0	;*00n0B
	decfsz	0x00,wcode	; 00 0B
	decfsz	*0x00,wcode	; 00 0B
	decfsz	extreg,wcode	;*00n0B
	decfsz	*extreg,wcode	;*00n0B
	decfsz	0x00,#wcode	; 00 0B
	decfsz	*0x00,#wcode	; 00 0B
	decfsz	extreg,#wcode	;*00n0B
	decfsz	*extreg,#wcode	;*00n0B

	decfsz	0x00,1		; 80 0B
	decfsz	*0x00,1		; 80 0B
	decfsz	extreg,1	;*80n0B
	decfsz	*extreg,1	;*80n0B
	decfsz	0x00,#1		; 80 0B
	decfsz	*0x00,#1	; 80 0B
	decfsz	extreg,#1	;*80n0B
	decfsz	*extreg,#1	;*80n0B
	decfsz	0x00,fcode	; 80 0B
	decfsz	*0x00,fcode	; 80 0B
	decfsz	extreg,fcode	;*80n0B
	decfsz	*extreg,fcode	;*80n0B
	decfsz	0x00,#fcode	; 80 0B
	decfsz	*0x00,#fcode	; 80 0B
	decfsz	extreg,#fcode	;*80n0B
	decfsz	*extreg,#fcode	;*80n0B

	rrf	0x00,w		; 00 0C
	rrf	0x7F,w		; 7F 0C
	rrf	extreg,w	;*00n0C

	rrf	0x00,f		; 80 0C
	rrf	0x7F,f		; FF 0C
	rrf	extreg,f	;*80n0C

	rrf	*0x00,w		; 00 0C
	rrf	*0x7F,w		; 7F 0C
	rrf	*extreg,w	;*00n0C

	rrf	*0x00,f		; 80 0C
	rrf	*0x7F,f		; FF 0C
 	rrf	*extreg,f	;*80n0C

	rrf	0x00,0		; 00 0C
	rrf	*0x00,0		; 00 0C
	rrf	extreg,0	;*00n0C
	rrf	*extreg,0	;*00n0C
	rrf	0x00,#0		; 00 0C
	rrf	*0x00,#0	; 00 0C
	rrf	extreg,#0	;*00n0C
	rrf	*extreg,#0	;*00n0C
	rrf	0x00,wcode	; 00 0C
	rrf	*0x00,wcode	; 00 0C
	rrf	extreg,wcode	;*00n0C
	rrf	*extreg,wcode	;*00n0C
	rrf	0x00,#wcode	; 00 0C
	rrf	*0x00,#wcode	; 00 0C
	rrf	extreg,#wcode	;*00n0C
	rrf	*extreg,#wcode	;*00n0C

	rrf	0x00,1		; 80 0C
	rrf	*0x00,1		; 80 0C
	rrf	extreg,1	;*80n0C
	rrf	*extreg,1	;*80n0C
	rrf	0x00,#1		; 80 0C
	rrf	*0x00,#1	; 80 0C
	rrf	extreg,#1	;*80n0C
	rrf	*extreg,#1	;*80n0C
	rrf	0x00,fcode	; 80 0C
	rrf	*0x00,fcode	; 80 0C
	rrf	extreg,fcode	;*80n0C
	rrf	*extreg,fcode	;*80n0C
	rrf	0x00,#fcode	; 80 0C
	rrf	*0x00,#fcode	; 80 0C
	rrf	extreg,#fcode	;*80n0C
	rrf	*extreg,#fcode	;*80n0C

	rlf	0x00,w		; 00 0D
	rlf	0x7F,w		; 7F 0D
	rlf	extreg,w	;*00n0D

	rlf	0x00,f		; 80 0D
	rlf	0x7F,f		; FF 0D
	rlf	extreg,f	;*80n0D

	rlf	*0x00,w		; 00 0D
	rlf	*0x7F,w		; 7F 0D
	rlf	*extreg,w	;*00n0D

	rlf	*0x00,f		; 80 0D
	rlf	*0x7F,f		; FF 0D
	rlf	*extreg,f	;*80n0D

	rlf	0x00,0		; 00 0D
	rlf	*0x00,0		; 00 0D
	rlf	extreg,0	;*00n0D
	rlf	*extreg,0	;*00n0D
	rlf	0x00,#0		; 00 0D
	rlf	*0x00,#0	; 00 0D
	rlf	extreg,#0	;*00n0D
	rlf	*extreg,#0	;*00n0D
	rlf	0x00,wcode	; 00 0D
	rlf	*0x00,wcode	; 00 0D
	rlf	extreg,wcode	;*00n0D
	rlf	*extreg,wcode	;*00n0D
	rlf	0x00,#wcode	; 00 0D
	rlf	*0x00,#wcode	; 00 0D
	rlf	extreg,#wcode	;*00n0D
	rlf	*extreg,#wcode	;*00n0D

	rlf	0x00,1		; 80 0D
	rlf	*0x00,1		; 80 0D
	rlf	extreg,1	;*80n0D
	rlf	*extreg,1	;*80n0D
	rlf	0x00,#1		; 80 0D
	rlf	*0x00,#1	; 80 0D
	rlf	extreg,#1	;*80n0D
	rlf	*extreg,#1	;*80n0D
	rlf	0x00,fcode	; 80 0D
	rlf	*0x00,fcode	; 80 0D
	rlf	extreg,fcode	;*80n0D
	rlf	*extreg,fcode	;*80n0D
	rlf	0x00,#fcode	; 80 0D
	rlf	*0x00,#fcode	; 80 0D
	rlf	extreg,#fcode	;*80n0D
	rlf	*extreg,#fcode	;*80n0D

	swapf	0x00,w		; 00 0E
	swapf	0x7F,w		; 7F 0E
	swapf	extreg,w	;*00n0E

	swapf	0x00,f		; 80 0E
	swapf	0x7F,f		; FF 0E
	swapf	extreg,f	;*80n0E

	swapf	*0x00,w		; 00 0E
	swapf	*0x7F,w		; 7F 0E
	swapf	*extreg,w	;*00n0E


	swapf	*0x00,f		; 80 0E
	swapf	*0x7F,f		; FF 0E
	swapf	*extreg,f	;*80n0E

	swapf	0x00,0		; 00 0E
	swapf	*0x00,0		; 00 0E
	swapf	extreg,0	;*00n0E
	swapf	*extreg,0	;*00n0E
	swapf	0x00,#0		; 00 0E
	swapf	*0x00,#0	; 00 0E
	swapf	extreg,#0	;*00n0E
	swapf	*extreg,#0	;*00n0E
	swapf	0x00,wcode	; 00 0E
	swapf	*0x00,wcode	; 00 0E
	swapf	extreg,wcode	;*00n0E
	swapf	*extreg,wcode	;*00n0E
	swapf	0x00,#wcode	; 00 0E
	swapf	*0x00,#wcode	; 00 0E
	swapf	extreg,#wcode	;*00n0E
	swapf	*extreg,#wcode	;*00n0E

	swapf	0x00,1		; 80 0E
	swapf	*0x00,1		; 80 0E
	swapf	extreg,1	;*80n0E
	swapf	*extreg,1	;*80n0E
	swapf	0x00,#1		; 80 0E
	swapf	*0x00,#1	; 80 0E
	swapf	extreg,#1	;*80n0E
	swapf	*extreg,#1	;*80n0E
	swapf	0x00,fcode	; 80 0E
	swapf	*0x00,fcode	; 80 0E
	swapf	extreg,fcode	;*80n0E
	swapf	*extreg,fcode	;*80n0E
	swapf	0x00,#fcode	; 80 0E
	swapf	*0x00,#fcode	; 80 0E
	swapf	extreg,#fcode	;*80n0E
	swapf	*extreg,#fcode	;*80n0E

	incfsz	0x00,w		; 00 0F
	incfsz	0x7F,w		; 7F 0F
	incfsz	extreg,w	;*00n0F

	incfsz	0x00,f		; 80 0F
	incfsz	0x7F,f		; FF 0F
	incfsz	extreg,f	;*80n0F

	incfsz	*0x00,w		; 00 0F
	incfsz	*0x7F,w		; 7F 0F
	incfsz	*extreg,w	;*00n0F

	incfsz	*0x00,f		; 80 0F
	incfsz	*0x7F,f		; FF 0F
	incfsz	*extreg,f	;*80n0F

	incfsz	0x00,0		; 00 0F
	incfsz	*0x00,0		; 00 0F
	incfsz	extreg,0	;*00n0F
	incfsz	*extreg,0	;*00n0F
	incfsz	0x00,#0		; 00 0F
	incfsz	*0x00,#0	; 00 0F
	incfsz	extreg,#0	;*00n0F
	incfsz	*extreg,#0	;*00n0F
	incfsz	0x00,wcode	; 00 0F
	incfsz	*0x00,wcode	; 00 0F
	incfsz	extreg,wcode	;*00n0F
	incfsz	*extreg,wcode	;*00n0F
	incfsz	0x00,#wcode	; 00 0F
	incfsz	*0x00,#wcode	; 00 0F
	incfsz	extreg,#wcode	;*00n0F
	incfsz	*extreg,#wcode	;*00n0F

	incfsz	0x00,1		; 80 0F
	incfsz	*0x00,1		; 80 0F
	incfsz	extreg,1	;*80n0F
	incfsz	*extreg,1	;*80n0F
	incfsz	0x00,#1		; 80 0F
	incfsz	*0x00,#1	; 80 0F
	incfsz	extreg,#1	;*80n0F
	incfsz	*extreg,#1	;*80n0F
	incfsz	0x00,fcode	; 80 0F
	incfsz	*0x00,fcode	; 80 0F
	incfsz	extreg,fcode	;*80n0F
	incfsz	*extreg,fcode	;*80n0F
	incfsz	0x00,#fcode	; 80 0F
	incfsz	*0x00,#fcode	; 80 0F
	incfsz	extreg,#fcode	;*80n0F
	incfsz	*extreg,#fcode	;*80n0F

	bcf	0x00,0		; 00 10
	bcf	0x7F,0		; 7F 10
	bcf	extreg,0	;*00n10

	bcf	0x00,7		; 80 13
	bcf	0x7F,7		; FF 13
	bcf	extreg,7	;*80n13

	bcf	*0x00,0		; 00 10
	bcf	*0x7F,0		; 7F 10
	bcf	*extreg,0	;*00n10

	bcf	*0x00,7		; 80 13
	bcf	*0x7F,7		; FF 13
	bcf	*extreg,7	;*80n13

	bcf	0x00,num0	; 00 10
	bcf	*0x00,num0	; 00 10
	bcf	extreg,num0	;*00n10
	bcf	*extreg,num0	;*00n10
	bcf	0x00,#num0	; 00 10
	bcf	*0x00,#num0	; 00 10
	bcf	extreg,#num0	;*00n10
	bcf	*extreg,#num0	;*00n10
	bcf	0x00,num7	; 80 13
	bcf	*0x00,num7	; 80 13
	bcf	extreg,num7	;*80n13
	bcf	*extreg,num7	;*80n13
	bcf	0x00,#num7	; 80 13
	bcf	*0x00,#num7	; 80 13
	bcf	extreg,#num7	;*80n13
	bcf	*extreg,#num7	;*80n13

	bsf	0x00,0		; 00 14
	bsf	0x7F,0		; 7F 14
	bsf	extreg,0	;*00n14

	bsf	0x00,7		; 80 17
	bsf	0x7F,7		; FF 17
	bsf	extreg,7	;*80n17

	bsf	*0x00,0		; 00 14
	bsf	*0x7F,0		; 7F 14
	bsf	*extreg,0	;*00n14

	bsf	*0x00,7		; 80 17
	bsf	*0x7F,7		; FF 17
 	bsf	*extreg,7	;*80n17

	bsf	0x00,num0	; 00 14
	bsf	*0x00,num0	; 00 14
	bsf	extreg,num0	;*00n14
	bsf	*extreg,num0	;*00n14
	bsf	0x00,#num0	; 00 14
	bsf	*0x00,#num0	; 00 14
	bsf	extreg,#num0	;*00n14
	bsf	*extreg,#num0	;*00n14
	bsf	0x00,num7	; 80 17
	bsf	*0x00,num7	; 80 17
	bsf	extreg,num7	;*80n17
	bsf	*extreg,num7	;*80n17
	bsf	0x00,#num7	; 80 17
	bsf	*0x00,#num7	; 80 17
	bsf	extreg,#num7	;*80n17
	bsf	*extreg,#num7	;*80n17

	btfsc	0x00,0		; 00 18
	btfsc	0x7F,0		; 7F 18
	btfsc	extreg,0	;*00n18

	btfsc	0x00,7		; 80 1B
	btfsc	0x7F,7		; FF 1B
	btfsc	extreg,7	;*80n1B

	btfsc	*0x00,0		; 00 18
	btfsc	*0x7F,0		; 7F 18
	btfsc	*extreg,0	;*00n18

	btfsc	*0x00,7		; 80 1B
	btfsc	*0x7F,7		; FF 1B
	btfsc	*extreg,7	;*80n1B

	btfsc	0x00,num0	; 00 18
	btfsc	*0x00,num0	; 00 18
	btfsc	extreg,num0	;*00n18
	btfsc	*extreg,num0	;*00n18
	btfsc	0x00,#num0	; 00 18
	btfsc	*0x00,#num0	; 00 18
	btfsc	extreg,#num0	;*00n18
	btfsc	*extreg,#num0	;*00n18
	btfsc	0x00,num7	; 80 1B
	btfsc	*0x00,num7	; 80 1B
	btfsc	extreg,num7	;*80n1B
	btfsc	*extreg,num7	;*80n1B
	btfsc	0x00,#num7	; 80 1B
	btfsc	*0x00,#num7	; 80 1B
	btfsc	extreg,#num7	;*80n1B
	btfsc	*extreg,#num7	;*80n1B

	btfss	0x00,0		; 00 1C
	btfss	0x7F,0		; 7F 1C
	btfss	extreg,0	;*00n1C

	btfss	0x00,7		; 80 1F
	btfss	0x7F,7		; FF 1F
	btfss	extreg,7	;*80n1F

	btfss	*0x00,0		; 00 1C
	btfss	*0x7F,0		; 7F 1C
	btfss	*extreg,0	;*00n1C

	btfss	*0x00,7		; 80 1F
	btfss	*0x7F,7		; FF 1F
	btfss	*extreg,7	;*80n1F

	btfss	0x00,num0	; 00 1C
	btfss	*0x00,num0	; 00 1C
	btfss	extreg,num0	;*00n1C
	btfss	*extreg,num0	;*00n1C
	btfss	0x00,#num0	; 00 1C
	btfss	*0x00,#num0	; 00 1C
	btfss	extreg,#num0	;*00n1C
	btfss	*extreg,#num0	;*00n1C
	btfss	0x00,num7	; 80 1F
	btfss	*0x00,num7	; 80 1F
	btfss	extreg,num7	;*80n1F
	btfss	*extreg,num7	;*80n1F
	btfss	0x00,#num7	; 80 1F
	btfss	*0x00,#num7	; 80 1F
	btfss	extreg,#num7	;*80n1F
	btfss	*extreg,#num7	;*80n1F

	retlw	0x00		; 00 34
	retlw	0xFF		; FF 34
	retlw	extvalu		;r00s34

	retlw	#0x00		; 00 34
	retlw	#0xFF		; FF 34
	retlw	#extvalu	;r00s34

	call	0x00		; 00 20
	call	0x7FF		; FF 27

	call	addr_00		;r00s20
	call	addr_7FF	;rFFs27

	call	extaddr		;r00s20

	goto	0x00		; 00 28
	goto	0x7FF		; FF 2F

	goto	addr_00		;r00s28
	goto	addr_7FF	;rFFs2F

	goto	extaddr		;r00s28

	movlw	0x00		; 00 30
	movlw	0xFF		; FF 30
	movlw	extvalu		;r00s30

	movlw	#0x00		; 00 30
	movlw	#0xFF		; FF 30
	movlw	#extvalu	;r00s30

	iorlw	0x00		; 00 38
	iorlw	0xFF		; FF 38
	iorlw	extvalu		;r00s38

	iorlw	#0x00		; 00 38
	iorlw	#0xFF		; FF 38
	iorlw	#extvalu	;r00s38

	andlw	0x00		; 00 39
	andlw	0xFF		; FF 39
	andlw	extvalu		;r00s39

	andlw	#0x00		; 00 39
	andlw	#0xFF		; FF 39
	andlw	#extvalu	;r00s39

	xorlw	0x00		; 00 3A
	xorlw	0xFF		; FF 3A
	xorlw	extvalu		;r00s3A

	xorlw	#0x00		; 00 3A
	xorlw	#0xFF		; FF 3A
	xorlw	#extvalu	;r00s3A

	sublw	0x00		; 00 3C
	sublw	0xFF		; FF 3C
	sublw	extvalu		;r00s3C

	sublw	#0x00		; 00 3C
	sublw	#0xFF		; FF 3C
	sublw	#extvalu	;r00s3C

	addlw	0x00		; 00 3E
	addlw	0xFF		; FF 3E
	addlw	extvalu		;r00s3E

	addlw	#0x00		; 00 3E
	addlw	#0xFF		; FF 3E
	addlw	#extvalu	;r00s3E


