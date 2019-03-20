;  TPIC17CX.ASM - Test file for ASPIC assembler
;
;  Assemble:
;	aspic -gloaxff tpic17cx
;

	.include	"tpic17cx.def"

	.area	DATA

	fcode =		1
	wcode =		0

	num0 =		0
	num7 =		7
	num1 =		1

	.area	CODE

	addr_00	=	. + 0x00
	addr_1FFF =	. + 0x1fff

	nop			; 00 00

	return			; 02 00
	retfie			; 05 00

	sleep			; 03 00
	clrwdt			; 04 00

	movwf	0x00		; 00 01
	movwf	0xFF		; FF 01
	movwf	extreg		;*00n01

	movwf	*0x00		; 00 01
	movwf	*0xFF		; FF 01
	movwf	*extreg		;*00n01

	subwfb	0x00,w		; 00 02
	subwfb	0xFF,w		; FF 02
	subwfb	extreg,w	;*00n02

	subwfb	0x00,f		; 00 03
	subwfb	0xFF,f		; FF 03
	subwfb	extreg,f	;*00n03

	subwfb	*0x00,w		; 00 02
	subwfb	*0xFF,w		; FF 02
	subwfb	*extreg,w	;*00n02

	subwfb	*0x00,f		; 00 03
	subwfb	*0xFF,f		; FF 03
	subwfb	*extreg,f	;*00n03

	subwfb	0x00,0		; 00 02
	subwfb	*0x00,0		; 00 02
	subwfb	extreg,0	;*00n02
	subwfb	*extreg,0	;*00n02
	subwfb	0x00,#0		; 00 02
	subwfb	*0x00,#0	; 00 02
	subwfb	extreg,#0	;*00n02
	subwfb	*extreg,#0	;*00n02
	subwfb	0x00,wcode	; 00 02
	subwfb	*0x00,wcode	; 00 02
	subwfb	extreg,wcode	;*00n02
	subwfb	*extreg,wcode	;*00n02
	subwfb	0x00,#wcode	; 00 02
	subwfb	*0x00,#wcode	; 00 02
	subwfb	extreg,#wcode	;*00n02
	subwfb	*extreg,#wcode	;*00n02

	subwfb	0x00,1		; 00 03
	subwfb	*0x00,1		; 00 03
	subwfb	extreg,1	;*00n03
	subwfb	*extreg,1	;*00n03
	subwfb	0x00,#1		; 00 03
	subwfb	*0x00,#1	; 00 03
	subwfb	extreg,#1	;*00n03
	subwfb	*extreg,#1	;*00n03
	subwfb	0x00,fcode	; 00 03
	subwfb	*0x00,fcode	; 00 03
	subwfb	extreg,fcode	;*00n03
	subwfb	*extreg,fcode	;*00n03
	subwfb	0x00,#fcode	; 00 03
	subwfb	*0x00,#fcode	; 00 03
	subwfb	extreg,#fcode	;*00n03
	subwfb	*extreg,#fcode	;*00n03

	subwf	0x00,w		; 00 04
	subwf	0xFF,w		; FF 04
	subwf	extreg,w	;*00n04

	subwf	0x00,f		; 00 05
	subwf	0xFF,f		; FF 05
	subwf	extreg,f	;*00n05

	subwf	*0x00,w		; 00 04
	subwf	*0xFF,w		; FF 04
	subwf	*extreg,w	;*00n04

	subwf	*0x00,f		; 00 05
	subwf	*0xFF,f		; FF 05
	subwf	*extreg,f	;*00n05

	subwf	0x00,0		; 00 04
	subwf	*0x00,0		; 00 04
	subwf	extreg,0	;*00n04
	subwf	*extreg,0	;*00n04
	subwf	0x00,#0		; 00 04
	subwf	*0x00,#0	; 00 04
	subwf	extreg,#0	;*00n04
	subwf	*extreg,#0	;*00n04
	subwf	0x00,wcode	; 00 04
	subwf	*0x00,wcode	; 00 04
	subwf	extreg,wcode	;*00n04
	subwf	*extreg,wcode	;*00n04
	subwf	0x00,#wcode	; 00 04
	subwf	*0x00,#wcode	; 00 04
	subwf	extreg,#wcode	;*00n04
	subwf	*extreg,#wcode	;*00n04

	subwf	0x00,1		; 00 05
	subwf	*0x00,1		; 00 05
	subwf	extreg,1	;*00n05
	subwf	*extreg,1	;*00n05
	subwf	0x00,#1		; 00 05
	subwf	*0x00,#1	; 00 05
	subwf	extreg,#1	;*00n05
	subwf	*extreg,#1	;*00n05
	subwf	0x00,fcode	; 00 05
	subwf	*0x00,fcode	; 00 05
	subwf	extreg,fcode	;*00n05
	subwf	*extreg,fcode	;*00n05
	subwf	0x00,#fcode	; 00 05
	subwf	*0x00,#fcode	; 00 05
	subwf	extreg,#fcode	;*00n05
	subwf	*extreg,#fcode	;*00n05

	decf	0x00,w		; 00 06
	decf	0xFF,w		; FF 06
	decf	extreg,w	;*00n06

	decf	0x00,f		; 00 07
	decf	0xFF,f		; FF 07
	decf	extreg,f	;*00n07

	decf	*0x00,w		; 00 06
	decf	*0xFF,w		; FF 06
	decf	*extreg,w	;*00n06

	decf	*0x00,f		; 00 07
	decf	*0xFF,f		; FF 07
	decf	*extreg,f	;*00n07

	decf	0x00,0		; 00 06
	decf	*0x00,0		; 00 06
	decf	extreg,0	;*00n06
	decf	*extreg,0	;*00n06
	decf	0x00,#0		; 00 06
	decf	*0x00,#0	; 00 06
	decf	extreg,#0	;*00n06
	decf	*extreg,#0	;*00n06
	decf	0x00,wcode	; 00 06
	decf	*0x00,wcode	; 00 06
	decf	extreg,wcode	;*00n06
	decf	*extreg,wcode	;*00n06
	decf	0x00,#wcode	; 00 06
	decf	*0x00,#wcode	; 00 06
	decf	extreg,#wcode	;*00n06
	decf	*extreg,#wcode	;*00n06

	decf	0x00,1		; 00 07
	decf	*0x00,1		; 00 07
	decf	extreg,1	;*00n07
	decf	*extreg,1	;*00n07
	decf	0x00,#1		; 00 07
	decf	*0x00,#1	; 00 07
	decf	extreg,#1	;*00n07
	decf	*extreg,#1	;*00n07
	decf	0x00,fcode	; 00 07
	decf	*0x00,fcode	; 00 07
	decf	extreg,fcode	;*00n07
	decf	*extreg,fcode	;*00n07
	decf	0x00,#fcode	; 00 07
	decf	*0x00,#fcode	; 00 07
	decf	extreg,#fcode	;*00n07
	decf	*extreg,#fcode	;*00n07

	iorwf	0x00,w		; 00 08
	iorwf	0xFF,w		; FF 08
	iorwf	extreg,w	;*00n08

	iorwf	0x00,f		; 00 09
	iorwf	0xFF,f		; FF 09
	iorwf	extreg,f	;*00n09

	iorwf	*0x00,w		; 00 08
	iorwf	*0xFF,w		; FF 08
	iorwf	*extreg,w	;*00n08

	iorwf	*0x00,f		; 00 09
	iorwf	*0xFF,f		; FF 09
	iorwf	*extreg,f	;*00n09

	iorwf	0x00,0		; 00 08
	iorwf	*0x00,0		; 00 08
	iorwf	extreg,0	;*00n08
	iorwf	*extreg,0	;*00n08
	iorwf	0x00,#0		; 00 08
	iorwf	*0x00,#0	; 00 08
	iorwf	extreg,#0	;*00n08
	iorwf	*extreg,#0	;*00n08
	iorwf	0x00,wcode	; 00 08
	iorwf	*0x00,wcode	; 00 08
	iorwf	extreg,wcode	;*00n08
	iorwf	*extreg,wcode	;*00n08
	iorwf	0x00,#wcode	; 00 08
	iorwf	*0x00,#wcode	; 00 08
	iorwf	extreg,#wcode	;*00n08
	iorwf	*extreg,#wcode	;*00n08

	iorwf	0x00,1		; 00 09
	iorwf	*0x00,1		; 00 09
	iorwf	extreg,1	;*00n09
	iorwf	*extreg,1	;*00n09
	iorwf	0x00,#1		; 00 09
	iorwf	*0x00,#1	; 00 09
	iorwf	extreg,#1	;*00n09
	iorwf	*extreg,#1	;*00n09
	iorwf	0x00,fcode	; 00 09
	iorwf	*0x00,fcode	; 00 09
	iorwf	extreg,fcode	;*00n09
	iorwf	*extreg,fcode	;*00n09
	iorwf	0x00,#fcode	; 00 09
	iorwf	*0x00,#fcode	; 00 09
	iorwf	extreg,#fcode	;*00n09
	iorwf	*extreg,#fcode	;*00n09

	andwf	0x00,w		; 00 0A
	andwf	0xFF,w		; FF 0A
	andwf	extreg,w	;*00n0A

	andwf	0x00,f		; 00 0B
	andwf	0xFF,f		; FF 0B
	andwf	extreg,f	;*00n0B

	andwf	*0x00,w		; 00 0A
	andwf	*0xFF,w		; FF 0A
	andwf	*extreg,w	;*00n0A

	andwf	*0x00,f		; 00 0B
	andwf	*0xFF,f		; FF 0B
	andwf	*extreg,f	;*00n0B

	andwf	0x00,0		; 00 0A
	andwf	*0x00,0		; 00 0A
	andwf	extreg,0	;*00n0A
	andwf	*extreg,0	;*00n0A
	andwf	0x00,#0		; 00 0A
	andwf	*0x00,#0	; 00 0A
	andwf	extreg,#0	;*00n0A
	andwf	*extreg,#0	;*00n0A
	andwf	0x00,wcode	; 00 0A
	andwf	*0x00,wcode	; 00 0A
	andwf	extreg,wcode	;*00n0A
	andwf	*extreg,wcode	;*00n0A
	andwf	0x00,#wcode	; 00 0A
	andwf	*0x00,#wcode	; 00 0A
	andwf	extreg,#wcode	;*00n0A
	andwf	*extreg,#wcode	;*00n0A

	andwf	0x00,1		; 00 0B
	andwf	*0x00,1		; 00 0B
	andwf	extreg,1	;*00n0B
	andwf	*extreg,1	;*00n0B
	andwf	0x00,#1		; 00 0B
	andwf	*0x00,#1	; 00 0B
	andwf	extreg,#1	;*00n0B
	andwf	*extreg,#1	;*00n0B
	andwf	0x00,fcode	; 00 0B
	andwf	*0x00,fcode	; 00 0B
	andwf	extreg,fcode	;*00n0B
	andwf	*extreg,fcode	;*00n0B
	andwf	0x00,#fcode	; 00 0B
	andwf	*0x00,#fcode	; 00 0B
	andwf	extreg,#fcode	;*00n0B
	andwf	*extreg,#fcode	;*00n0B

	xorwf	0x00,w		; 00 0C
	xorwf	0xFF,w		; FF 0C
	xorwf	extreg,w	;*00n0C

	xorwf	0x00,f		; 00 0D
	xorwf	0xFF,f		; FF 0D
	xorwf	extreg,f	;*00n0D

	xorwf	*0x00,w		; 00 0C
	xorwf	*0xFF,w		; FF 0C
	xorwf	*extreg,w	;*00n0C

	xorwf	*0x00,f		; 00 0D
	xorwf	*0xFF,f		; FF 0D
	xorwf	*extreg,f	;*00n0D

	xorwf	0x00,0		; 00 0C
	xorwf	*0x00,0		; 00 0C
	xorwf	extreg,0	;*00n0C
	xorwf	*extreg,0	;*00n0C
	xorwf	0x00,#0		; 00 0C
	xorwf	*0x00,#0	; 00 0C
	xorwf	extreg,#0	;*00n0C
	xorwf	*extreg,#0	;*00n0C
	xorwf	0x00,wcode	; 00 0C
	xorwf	*0x00,wcode	; 00 0C
	xorwf	extreg,wcode	;*00n0C
	xorwf	*extreg,wcode	;*00n0C
	xorwf	0x00,#wcode	; 00 0C
	xorwf	*0x00,#wcode	; 00 0C
	xorwf	extreg,#wcode	;*00n0C
	xorwf	*extreg,#wcode	;*00n0C

	xorwf	0x00,1		; 00 0D
	xorwf	*0x00,1		; 00 0D
	xorwf	extreg,1	;*00n0D
	xorwf	*extreg,1	;*00n0D
	xorwf	0x00,#1		; 00 0D
	xorwf	*0x00,#1	; 00 0D
	xorwf	extreg,#1	;*00n0D
	xorwf	*extreg,#1	;*00n0D
	xorwf	0x00,fcode	; 00 0D
	xorwf	*0x00,fcode	; 00 0D
	xorwf	extreg,fcode	;*00n0D
	xorwf	*extreg,fcode	;*00n0D
	xorwf	0x00,#fcode	; 00 0D
	xorwf	*0x00,#fcode	; 00 0D
	xorwf	extreg,#fcode	;*00n0D
	xorwf	*extreg,#fcode	;*00n0D

	addwf	0x00,w		; 00 0E
	addwf	0xFF,w		; FF 0E
	addwf	extreg,w	;*00n0E

	addwf	0x00,f		; 00 0F
	addwf	0xFF,f		; FF 0F
	addwf	extreg,f	;*00n0F

	addwf	*0x00,w		; 00 0E
	addwf	*0xFF,w		; FF 0E
	addwf	*extreg,w	;*00n0E

	addwf	*0x00,f		; 00 0F
	addwf	*0xFF,f		; FF 0F
 	addwf	*extreg,f	;*00n0F

	addwf	0x00,0		; 00 0E
	addwf	*0x00,0		; 00 0E
	addwf	extreg,0	;*00n0E
	addwf	*extreg,0	;*00n0E
	addwf	0x00,#0		; 00 0E
	addwf	*0x00,#0	; 00 0E
	addwf	extreg,#0	;*00n0E
	addwf	*extreg,#0	;*00n0E
	addwf	0x00,wcode	; 00 0E
	addwf	*0x00,wcode	; 00 0E
	addwf	extreg,wcode	;*00n0E
	addwf	*extreg,wcode	;*00n0E
	addwf	0x00,#wcode	; 00 0E
	addwf	*0x00,#wcode	; 00 0E
	addwf	extreg,#wcode	;*00n0E
	addwf	*extreg,#wcode	;*00n0E

	addwf	0x00,1		; 00 0F
	addwf	*0x00,1		; 00 0F
	addwf	extreg,1	;*00n0F
	addwf	*extreg,1	;*00n0F
	addwf	0x00,#1		; 00 0F
	addwf	*0x00,#1	; 00 0F
	addwf	extreg,#1	;*00n0F
	addwf	*extreg,#1	;*00n0F
	addwf	0x00,fcode	; 00 0F
	addwf	*0x00,fcode	; 00 0F
	addwf	extreg,fcode	;*00n0F
	addwf	*extreg,fcode	;*00n0F
	addwf	0x00,#fcode	; 00 0F
	addwf	*0x00,#fcode	; 00 0F
	addwf	extreg,#fcode	;*00n0F
	addwf	*extreg,#fcode	;*00n0F

	addwfc	0x00,w		; 00 10
	addwfc	0xFF,w		; FF 10
	addwfc	extreg,w	;*00n10

	addwfc	0x00,f		; 00 11
	addwfc	0xFF,f		; FF 11
	addwfc	extreg,f	;*00n11

	addwfc	*0x00,w		; 00 10
	addwfc	*0xFF,w		; FF 10
	addwfc	*extreg,w	;*00n10

	addwfc	*0x00,f		; 00 11
	addwfc	*0xFF,f		; FF 11
 	addwfc	*extreg,f	;*00n11

	addwfc	0x00,0		; 00 10
	addwfc	*0x00,0		; 00 10
	addwfc	extreg,0	;*00n10
	addwfc	*extreg,0	;*00n10
	addwfc	0x00,#0		; 00 10
	addwfc	*0x00,#0	; 00 10
	addwfc	extreg,#0	;*00n10
	addwfc	*extreg,#0	;*00n10
	addwfc	0x00,wcode	; 00 10
	addwfc	*0x00,wcode	; 00 10
	addwfc	extreg,wcode	;*00n10
	addwfc	*extreg,wcode	;*00n10
	addwfc	0x00,#wcode	; 00 10
	addwfc	*0x00,#wcode	; 00 10
	addwfc	extreg,#wcode	;*00n10
	addwfc	*extreg,#wcode	;*00n10

	addwfc	0x00,1		; 00 11
	addwfc	*0x00,1		; 00 11
	addwfc	extreg,1	;*00n11
	addwfc	*extreg,1	;*00n11
	addwfc	0x00,#1		; 00 11
	addwfc	*0x00,#1	; 00 11
	addwfc	extreg,#1	;*00n11
	addwfc	*extreg,#1	;*00n11
	addwfc	0x00,fcode	; 00 11
	addwfc	*0x00,fcode	; 00 11
	addwfc	extreg,fcode	;*00n11
	addwfc	*extreg,fcode	;*00n11
	addwfc	0x00,#fcode	; 00 11
	addwfc	*0x00,#fcode	; 00 11
	addwfc	extreg,#fcode	;*00n11
	addwfc	*extreg,#fcode	;*00n11

	comf	0x00,w		; 00 12
	comf	0xFF,w		; FF 12
	comf	extreg,w	;*00n12

	comf	0x00,f		; 00 13
	comf	0xFF,f		; FF 13
 	comf	extreg,f	;*00n13

	comf	*0x00,w		; 00 12
	comf	*0xFF,w		; FF 12
	comf	*extreg,w	;*00n12

	comf	*0x00,f		; 00 13
	comf	*0xFF,f		; FF 13
 	comf	*extreg,f	;*00n13

	comf	0x00,0		; 00 12
	comf	*0x00,0		; 00 12
	comf	extreg,0	;*00n12
	comf	*extreg,0	;*00n12
	comf	0x00,#0		; 00 12
	comf	*0x00,#0	; 00 12
	comf	extreg,#0	;*00n12
	comf	*extreg,#0	;*00n12
	comf	0x00,wcode	; 00 12
	comf	*0x00,wcode	; 00 12
	comf	extreg,wcode	;*00n12
	comf	*extreg,wcode	;*00n12
	comf	0x00,#wcode	; 00 12
	comf	*0x00,#wcode	; 00 12
	comf	extreg,#wcode	;*00n12
	comf	*extreg,#wcode	;*00n12

	comf	0x00,1		; 00 13
	comf	*0x00,1		; 00 13
	comf	extreg,1	;*00n13
	comf	*extreg,1	;*00n13
	comf	0x00,#1		; 00 13
	comf	*0x00,#1	; 00 13
	comf	extreg,#1	;*00n13
	comf	*extreg,#1	;*00n13
	comf	0x00,fcode	; 00 13
	comf	*0x00,fcode	; 00 13
	comf	extreg,fcode	;*00n13
	comf	*extreg,fcode	;*00n13
	comf	0x00,#fcode	; 00 13
	comf	*0x00,#fcode	; 00 13
	comf	extreg,#fcode	;*00n13
	comf	*extreg,#fcode	;*00n13

	incf	0x00,w		; 00 14
	incf	0xFF,w		; FF 14
	incf	extreg,w	;*00n14

	incf	0x00,f		; 00 15
	incf	0xFF,f		; FF 15
	incf	extreg,f	;*00n15

	incf	*0x00,w		; 00 14
	incf	*0xFF,w		; FF 14
	incf	*extreg,w	;*00n14

	incf	*0x00,f		; 00 15
	incf	*0xFF,f		; FF 15
	incf	*extreg,f	;*00n15

	incf	0x00,0		; 00 14
	incf	*0x00,0		; 00 14
	incf	extreg,0	;*00n14
	incf	*extreg,0	;*00n14
	incf	0x00,#0		; 00 14
	incf	*0x00,#0	; 00 14
	incf	extreg,#0	;*00n14
	incf	*extreg,#0	;*00n14
	incf	0x00,wcode	; 00 14
	incf	*0x00,wcode	; 00 14
	incf	extreg,wcode	;*00n14
	incf	*extreg,wcode	;*00n14
	incf	0x00,#wcode	; 00 14
	incf	*0x00,#wcode	; 00 14
	incf	extreg,#wcode	;*00n14
	incf	*extreg,#wcode	;*00n14

	incf	0x00,1		; 00 15
	incf	*0x00,1		; 00 15
	incf	extreg,1	;*00n15
	incf	*extreg,1	;*00n15
	incf	0x00,#1		; 00 15
	incf	*0x00,#1	; 00 15
	incf	extreg,#1	;*00n15
	incf	*extreg,#1	;*00n15
	incf	0x00,fcode	; 00 15
	incf	*0x00,fcode	; 00 15
	incf	extreg,fcode	;*00n15
	incf	*extreg,fcode	;*00n15
	incf	0x00,#fcode	; 00 15
	incf	*0x00,#fcode	; 00 15
	incf	extreg,#fcode	;*00n15
	incf	*extreg,#fcode	;*00n15

	decfsz	0x00,w		; 00 16
	decfsz	0xFF,w		; FF 16
	decfsz	extreg,w	;*00n16

	decfsz	0x00,f		; 00 17
	decfsz	0xFF,f		; FF 17
	decfsz	extreg,f	;*00n17

	decfsz	*0x00,w		; 00 16
	decfsz	*0xFF,w		; FF 16
	decfsz	*extreg,w	;*00n16

	decfsz	*0x00,f		; 00 17
	decfsz	*0xFF,f		; FF 17
 	decfsz	*extreg,f	;*00n17

	decfsz	0x00,0		; 00 16
	decfsz	*0x00,0		; 00 16
	decfsz	extreg,0	;*00n16
	decfsz	*extreg,0	;*00n16
	decfsz	0x00,#0		; 00 16
	decfsz	*0x00,#0	; 00 16
	decfsz	extreg,#0	;*00n16
	decfsz	*extreg,#0	;*00n16
	decfsz	0x00,wcode	; 00 16
	decfsz	*0x00,wcode	; 00 16
	decfsz	extreg,wcode	;*00n16
	decfsz	*extreg,wcode	;*00n16
	decfsz	0x00,#wcode	; 00 16
	decfsz	*0x00,#wcode	; 00 16
	decfsz	extreg,#wcode	;*00n16
	decfsz	*extreg,#wcode	;*00n16

	decfsz	0x00,1		; 00 17
	decfsz	*0x00,1		; 00 17
	decfsz	extreg,1	;*00n17
	decfsz	*extreg,1	;*00n17
	decfsz	0x00,#1		; 00 17
	decfsz	*0x00,#1	; 00 17
	decfsz	extreg,#1	;*00n17
	decfsz	*extreg,#1	;*00n17
	decfsz	0x00,fcode	; 00 17
	decfsz	*0x00,fcode	; 00 17
	decfsz	extreg,fcode	;*00n17
	decfsz	*extreg,fcode	;*00n17
	decfsz	0x00,#fcode	; 00 17
	decfsz	*0x00,#fcode	; 00 17
	decfsz	extreg,#fcode	;*00n17
	decfsz	*extreg,#fcode	;*00n17

	rrcf	0x00,w		; 00 18
	rrcf	0xFF,w		; FF 18
	rrcf	extreg,w	;*00n18

	rrcf	0x00,f		; 00 19
	rrcf	0xFF,f		; FF 19
	rrcf	extreg,f	;*00n19

	rrcf	*0x00,w		; 00 18
	rrcf	*0xFF,w		; FF 18
	rrcf	*extreg,w	;*00n18

	rrcf	*0x00,f		; 00 19
	rrcf	*0xFF,f		; FF 19
 	rrcf	*extreg,f	;*00n19

	rrcf	0x00,0		; 00 18
	rrcf	*0x00,0		; 00 18
	rrcf	extreg,0	;*00n18
	rrcf	*extreg,0	;*00n18
	rrcf	0x00,#0		; 00 18
	rrcf	*0x00,#0	; 00 18
	rrcf	extreg,#0	;*00n18
	rrcf	*extreg,#0	;*00n18
	rrcf	0x00,wcode	; 00 18
	rrcf	*0x00,wcode	; 00 18
	rrcf	extreg,wcode	;*00n18
	rrcf	*extreg,wcode	;*00n18
	rrcf	0x00,#wcode	; 00 18
	rrcf	*0x00,#wcode	; 00 18
	rrcf	extreg,#wcode	;*00n18
	rrcf	*extreg,#wcode	;*00n18

	rrcf	0x00,1		; 00 19
	rrcf	*0x00,1		; 00 19
	rrcf	extreg,1	;*00n19
	rrcf	*extreg,1	;*00n19
	rrcf	0x00,#1		; 00 19
	rrcf	*0x00,#1	; 00 19
	rrcf	extreg,#1	;*00n19
	rrcf	*extreg,#1	;*00n19
	rrcf	0x00,fcode	; 00 19
	rrcf	*0x00,fcode	; 00 19
	rrcf	extreg,fcode	;*00n19
	rrcf	*extreg,fcode	;*00n19
	rrcf	0x00,#fcode	; 00 19
	rrcf	*0x00,#fcode	; 00 19
	rrcf	extreg,#fcode	;*00n19
	rrcf	*extreg,#fcode	;*00n19

	rlcf	0x00,w		; 00 1A
	rlcf	0xFF,w		; FF 1A
	rlcf	extreg,w	;*00n1A

	rlcf	0x00,f		; 00 1B
	rlcf	0xFF,f		; FF 1B
	rlcf	extreg,f	;*00n1B

	rlcf	*0x00,w		; 00 1A
	rlcf	*0xFF,w		; FF 1A
	rlcf	*extreg,w	;*00n1A

	rlcf	*0x00,f		; 00 1B
	rlcf	*0xFF,f		; FF 1B
	rlcf	*extreg,f	;*00n1B

	rlcf	0x00,0		; 00 1A
	rlcf	*0x00,0		; 00 1A
	rlcf	extreg,0	;*00n1A
	rlcf	*extreg,0	;*00n1A
	rlcf	0x00,#0		; 00 1A
	rlcf	*0x00,#0	; 00 1A
	rlcf	extreg,#0	;*00n1A
	rlcf	*extreg,#0	;*00n1A
	rlcf	0x00,wcode	; 00 1A
	rlcf	*0x00,wcode	; 00 1A
	rlcf	extreg,wcode	;*00n1A
	rlcf	*extreg,wcode	;*00n1A
	rlcf	0x00,#wcode	; 00 1A
	rlcf	*0x00,#wcode	; 00 1A
	rlcf	extreg,#wcode	;*00n1A
	rlcf	*extreg,#wcode	;*00n1A

	rlcf	0x00,1		; 00 1B
	rlcf	*0x00,1		; 00 1B
	rlcf	extreg,1	;*00n1B
	rlcf	*extreg,1	;*00n1B
	rlcf	0x00,#1		; 00 1B
	rlcf	*0x00,#1	; 00 1B
	rlcf	extreg,#1	;*00n1B
	rlcf	*extreg,#1	;*00n1B
	rlcf	0x00,fcode	; 00 1B
	rlcf	*0x00,fcode	; 00 1B
	rlcf	extreg,fcode	;*00n1B
	rlcf	*extreg,fcode	;*00n1B
	rlcf	0x00,#fcode	; 00 1B
	rlcf	*0x00,#fcode	; 00 1B
	rlcf	extreg,#fcode	;*00n1B
	rlcf	*extreg,#fcode	;*00n1B

	swapf	0x00,w		; 00 1C
	swapf	0xFF,w		; FF 1C
	swapf	extreg,w	;*00n1C

	swapf	0x00,f		; 00 1D
	swapf	0xFF,f		; FF 1D
	swapf	extreg,f	;*00n1D

	swapf	*0x00,w		; 00 1C
	swapf	*0xFF,w		; FF 1C
	swapf	*extreg,w	;*00n1C

	swapf	*0x00,f		; 00 1D
	swapf	*0xFF,f		; FF 1D
	swapf	*extreg,f	;*00n1D

	swapf	0x00,0		; 00 1C
	swapf	*0x00,0		; 00 1C
	swapf	extreg,0	;*00n1C
	swapf	*extreg,0	;*00n1C
	swapf	0x00,#0		; 00 1C
	swapf	*0x00,#0	; 00 1C
	swapf	extreg,#0	;*00n1C
	swapf	*extreg,#0	;*00n1C
	swapf	0x00,wcode	; 00 1C
	swapf	*0x00,wcode	; 00 1C
	swapf	extreg,wcode	;*00n1C
	swapf	*extreg,wcode	;*00n1C
	swapf	0x00,#wcode	; 00 1C
	swapf	*0x00,#wcode	; 00 1C
	swapf	extreg,#wcode	;*00n1C
	swapf	*extreg,#wcode	;*00n1C

	swapf	0x00,1		; 00 1D
	swapf	*0x00,1		; 00 1D
	swapf	extreg,1	;*00n1D
	swapf	*extreg,1	;*00n1D
	swapf	0x00,#1		; 00 1D
	swapf	*0x00,#1	; 00 1D
	swapf	extreg,#1	;*00n1D
	swapf	*extreg,#1	;*00n1D
	swapf	0x00,fcode	; 00 1D
	swapf	*0x00,fcode	; 00 1D
	swapf	extreg,fcode	;*00n1D
	swapf	*extreg,fcode	;*00n1D
	swapf	0x00,#fcode	; 00 1D
	swapf	*0x00,#fcode	; 00 1D
	swapf	extreg,#fcode	;*00n1D
	swapf	*extreg,#fcode	;*00n1D

	incfsz	0x00,w		; 00 1E
	incfsz	0xFF,w		; FF 1E
	incfsz	extreg,w	;*00n1E

	incfsz	0x00,f		; 00 1F
	incfsz	0xFF,f		; FF 1F
	incfsz	extreg,f	;*00n1F

	incfsz	*0x00,w		; 00 1E
	incfsz	*0xFF,w		; FF 1E
	incfsz	*extreg,w	;*00n1E

	incfsz	*0x00,f		; 00 1F
	incfsz	*0xFF,f		; FF 1F
	incfsz	*extreg,f	;*00n1F

	incfsz	0x00,0		; 00 1E
	incfsz	*0x00,0		; 00 1E
	incfsz	extreg,0	;*00n1E
	incfsz	*extreg,0	;*00n1E
	incfsz	0x00,#0		; 00 1E
	incfsz	*0x00,#0	; 00 1E
	incfsz	extreg,#0	;*00n1E
	incfsz	*extreg,#0	;*00n1E
	incfsz	0x00,wcode	; 00 1E
	incfsz	*0x00,wcode	; 00 1E
	incfsz	extreg,wcode	;*00n1E
	incfsz	*extreg,wcode	;*00n1E
	incfsz	0x00,#wcode	; 00 1E
	incfsz	*0x00,#wcode	; 00 1E
	incfsz	extreg,#wcode	;*00n1E
	incfsz	*extreg,#wcode	;*00n1E

	incfsz	0x00,1		; 00 1F
	incfsz	*0x00,1		; 00 1F
	incfsz	extreg,1	;*00n1F
	incfsz	*extreg,1	;*00n1F
	incfsz	0x00,#1		; 00 1F
	incfsz	*0x00,#1	; 00 1F
	incfsz	extreg,#1	;*00n1F
	incfsz	*extreg,#1	;*00n1F
	incfsz	0x00,fcode	; 00 1F
	incfsz	*0x00,fcode	; 00 1F
	incfsz	extreg,fcode	;*00n1F
	incfsz	*extreg,fcode	;*00n1F
	incfsz	0x00,#fcode	; 00 1F
	incfsz	*0x00,#fcode	; 00 1F
	incfsz	extreg,#fcode	;*00n1F
	incfsz	*extreg,#fcode	;*00n1F

	rrncf	0x00,w		; 00 20
	rrncf	0xFF,w		; FF 20
	rrncf	extreg,w	;*00n20

	rrncf	0x00,f		; 00 21
	rrncf	0xFF,f		; FF 21
	rrncf	extreg,f	;*00n21

	rrncf	*0x00,w		; 00 20
	rrncf	*0xFF,w		; FF 20
	rrncf	*extreg,w	;*00n20

	rrncf	*0x00,f		; 00 21
	rrncf	*0xFF,f		; FF 21
 	rrncf	*extreg,f	;*00n21

	rrncf	0x00,0		; 00 20
	rrncf	*0x00,0		; 00 20
	rrncf	extreg,0	;*00n20
	rrncf	*extreg,0	;*00n20
	rrncf	0x00,#0		; 00 20
	rrncf	*0x00,#0	; 00 20
	rrncf	extreg,#0	;*00n20
	rrncf	*extreg,#0	;*00n20
	rrncf	0x00,wcode	; 00 20
	rrncf	*0x00,wcode	; 00 20
	rrncf	extreg,wcode	;*00n20
	rrncf	*extreg,wcode	;*00n20
	rrncf	0x00,#wcode	; 00 20
	rrncf	*0x00,#wcode	; 00 20
	rrncf	extreg,#wcode	;*00n20
	rrncf	*extreg,#wcode	;*00n20

	rrncf	0x00,1		; 00 21
	rrncf	*0x00,1		; 00 21
	rrncf	extreg,1	;*00n21
	rrncf	*extreg,1	;*00n21
	rrncf	0x00,#1		; 00 21
	rrncf	*0x00,#1	; 00 21
	rrncf	extreg,#1	;*00n21
	rrncf	*extreg,#1	;*00n21
	rrncf	0x00,fcode	; 00 21
	rrncf	*0x00,fcode	; 00 21
	rrncf	extreg,fcode	;*00n21
	rrncf	*extreg,fcode	;*00n21
	rrncf	0x00,#fcode	; 00 21
	rrncf	*0x00,#fcode	; 00 21
	rrncf	extreg,#fcode	;*00n21
	rrncf	*extreg,#fcode	;*00n21

	rlncf	0x00,w		; 00 22
	rlncf	0xFF,w		; FF 22
	rlncf	extreg,w	;*00n22

	rlncf	0x00,f		; 00 23
	rlncf	0xFF,f		; FF 23
	rlncf	extreg,f	;*00n23
	rlncf	*0x00,w		; 00 22

	rlncf	*0xFF,w		; FF 22
	rlncf	*extreg,w	;*00n22
	rlncf	*0x00,f		; 00 23

	rlncf	*0xFF,f		; FF 23
	rlncf	*extreg,f	;*00n23
	rlncf	0x00,0		; 00 22

	rlncf	*0x00,0		; 00 22
	rlncf	extreg,0	;*00n22
	rlncf	*extreg,0	;*00n22
	rlncf	0x00,#0		; 00 22
	rlncf	*0x00,#0	; 00 22
	rlncf	extreg,#0	;*00n22
	rlncf	*extreg,#0	;*00n22
	rlncf	0x00,wcode	; 00 22
	rlncf	*0x00,wcode	; 00 22
	rlncf	extreg,wcode	;*00n22
	rlncf	*extreg,wcode	;*00n22
	rlncf	0x00,#wcode	; 00 22
	rlncf	*0x00,#wcode	; 00 22
	rlncf	extreg,#wcode	;*00n22
	rlncf	*extreg,#wcode	;*00n22

	rlncf	0x00,1		; 00 23
	rlncf	*0x00,1		; 00 23
	rlncf	extreg,1	;*00n23
	rlncf	*extreg,1	;*00n23
	rlncf	0x00,#1		; 00 23
	rlncf	*0x00,#1	; 00 23
	rlncf	extreg,#1	;*00n23
	rlncf	*extreg,#1	;*00n23
	rlncf	0x00,fcode	; 00 23
	rlncf	*0x00,fcode	; 00 23
	rlncf	extreg,fcode	;*00n23
	rlncf	*extreg,fcode	;*00n23
	rlncf	0x00,#fcode	; 00 23
	rlncf	*0x00,#fcode	; 00 23
	rlncf	extreg,#fcode	;*00n23
	rlncf	*extreg,#fcode	;*00n23

	infsnz	0x00,w		; 00 24
	infsnz	0xFF,w		; FF 24
	infsnz	extreg,w	;*00n24

	infsnz	0x00,f		; 00 25
	infsnz	0xFF,f		; FF 25
	infsnz	extreg,f	;*00n25

	infsnz	*0x00,w		; 00 24
	infsnz	*0xFF,w		; FF 24
	infsnz	*extreg,w	;*00n24

	infsnz	*0x00,f		; 00 25
	infsnz	*0xFF,f		; FF 25
	infsnz	*extreg,f	;*00n25

	infsnz	0x00,0		; 00 24
	infsnz	*0x00,0		; 00 24
	infsnz	extreg,0	;*00n24
	infsnz	*extreg,0	;*00n24
	infsnz	0x00,#0		; 00 24
	infsnz	*0x00,#0	; 00 24
	infsnz	extreg,#0	;*00n24
	infsnz	*extreg,#0	;*00n24
	infsnz	0x00,wcode	; 00 24
	infsnz	*0x00,wcode	; 00 24
	infsnz	extreg,wcode	;*00n24
	infsnz	*extreg,wcode	;*00n24
	infsnz	0x00,#wcode	; 00 24
	infsnz	*0x00,#wcode	; 00 24
	infsnz	extreg,#wcode	;*00n24
	infsnz	*extreg,#wcode	;*00n24

	infsnz	0x00,1		; 00 25
	infsnz	*0x00,1		; 00 25
	infsnz	extreg,1	;*00n25
	infsnz	*extreg,1	;*00n25
	infsnz	0x00,#1		; 00 25
	infsnz	*0x00,#1	; 00 25
	infsnz	extreg,#1	;*00n25
	infsnz	*extreg,#1	;*00n25
	infsnz	0x00,fcode	; 00 25
	infsnz	*0x00,fcode	; 00 25
	infsnz	extreg,fcode	;*00n25
	infsnz	*extreg,fcode	;*00n25
	infsnz	0x00,#fcode	; 00 25
	infsnz	*0x00,#fcode	; 00 25
	infsnz	extreg,#fcode	;*00n25
	infsnz	*extreg,#fcode	;*00n25

	dcfsnz	0x00,w		; 00 26
	dcfsnz	0xFF,w		; FF 26
	dcfsnz	extreg,w	;*00n26

	dcfsnz	0x00,f		; 00 27
	dcfsnz	0xFF,f		; FF 27
	dcfsnz	extreg,f	;*00n27

	dcfsnz	*0x00,w		; 00 26
	dcfsnz	*0xFF,w		; FF 26
	dcfsnz	*extreg,w	;*00n26

	dcfsnz	*0x00,f		; 00 27
	dcfsnz	*0xFF,f		; FF 27
 	dcfsnz	*extreg,f	;*00n27

	dcfsnz	0x00,0		; 00 26
	dcfsnz	*0x00,0		; 00 26
	dcfsnz	extreg,0	;*00n26
	dcfsnz	*extreg,0	;*00n26
	dcfsnz	0x00,#0		; 00 26
	dcfsnz	*0x00,#0	; 00 26
	dcfsnz	extreg,#0	;*00n26
	dcfsnz	*extreg,#0	;*00n26
	dcfsnz	0x00,wcode	; 00 26
	dcfsnz	*0x00,wcode	; 00 26
	dcfsnz	extreg,wcode	;*00n26
	dcfsnz	*extreg,wcode	;*00n26
	dcfsnz	0x00,#wcode	; 00 26
	dcfsnz	*0x00,#wcode	; 00 26
	dcfsnz	extreg,#wcode	;*00n26
	dcfsnz	*extreg,#wcode	;*00n26

	dcfsnz	0x00,1		; 00 27
	dcfsnz	*0x00,1		; 00 27
	dcfsnz	extreg,1	;*00n27
	dcfsnz	*extreg,1	;*00n27
	dcfsnz	0x00,#1		; 00 27
	dcfsnz	*0x00,#1	; 00 27
	dcfsnz	extreg,#1	;*00n27
	dcfsnz	*extreg,#1	;*00n27
	dcfsnz	0x00,fcode	; 00 27
	dcfsnz	*0x00,fcode	; 00 27
	dcfsnz	extreg,fcode	;*00n27
	dcfsnz	*extreg,fcode	;*00n27
	dcfsnz	0x00,#fcode	; 00 27
	dcfsnz	*0x00,#fcode	; 00 27
	dcfsnz	extreg,#fcode	;*00n27
	dcfsnz	*extreg,#fcode	;*00n27

	clrf	0x00,w		; 00 28
	clrf	0xFF,w		; FF 28
	clrf	extreg,w	;*00n28

	clrf	*0x00,w		; 00 28
	clrf	*0xFF,w		; FF 28
	clrf	*extreg,w	;*00n28

	clrf	0x00,f		; 00 29
	clrf	0xFF,f		; FF 29
	clrf	extreg,f	;*00n29

	clrf	*0x00,f		; 00 29
	clrf	*0xFF,f		; FF 29
	clrf	*extreg,f	;*00n29

	clrf	0x00,0		; 00 28
	clrf	*0x00,0		; 00 28
	clrf	extreg,0	;*00n28
	clrf	*extreg,0	;*00n28
	clrf	0x00,#0		; 00 28
	clrf	*0x00,#0	; 00 28
	clrf	extreg,#0	;*00n28
	clrf	*extreg,#0	;*00n28
	clrf	0x00,wcode	; 00 28
	clrf	*0x00,wcode	; 00 28
	clrf	extreg,wcode	;*00n28
	clrf	*extreg,wcode	;*00n28
	clrf	0x00,#wcode	; 00 28
	clrf	*0x00,#wcode	; 00 28
	clrf	extreg,#wcode	;*00n28
	clrf	*extreg,#wcode	;*00n28

	clrf	0x00,1		; 00 29
	clrf	*0x00,1		; 00 29
	clrf	extreg,1	;*00n29
	clrf	*extreg,1	;*00n29
	clrf	0x00,#1		; 00 29
	clrf	*0x00,#1	; 00 29
	clrf	extreg,#1	;*00n29
	clrf	*extreg,#1	;*00n29
	clrf	0x00,fcode	; 00 29
	clrf	*0x00,fcode	; 00 29
	clrf	extreg,fcode	;*00n29
	clrf	*extreg,fcode	;*00n29
	clrf	0x00,#fcode	; 00 29
	clrf	*0x00,#fcode	; 00 29
	clrf	extreg,#fcode	;*00n29
	clrf	*extreg,#fcode	;*00n29

	setf	0x00,w		; 00 2A
	setf	0xFF,w		; FF 2A
	setf	extreg,w	;*00n2A

	setf	*0x00,w		; 00 2A
	setf	*0xFF,w		; FF 2A
	setf	*extreg,w	;*00n2A

	setf	0x00,f		; 00 2B
	setf	0xFF,f		; FF 2B
	setf	extreg,f	;*00n2B

	setf	*0x00,f		; 00 2B
	setf	*0xFF,f		; FF 2B
	setf	*extreg,f	;*00n2B

	setf	0x00,0		; 00 2A
	setf	*0x00,0		; 00 2A
	setf	extreg,0	;*00n2A
	setf	*extreg,0	;*00n2A
	setf	0x00,#0		; 00 2A
	setf	*0x00,#0	; 00 2A
	setf	extreg,#0	;*00n2A
	setf	*extreg,#0	;*00n2A
	setf	0x00,wcode	; 00 2A
	setf	*0x00,wcode	; 00 2A
	setf	extreg,wcode	;*00n2A
	setf	*extreg,wcode	;*00n2A
	setf	0x00,#wcode	; 00 2A
	setf	*0x00,#wcode	; 00 2A
	setf	extreg,#wcode	;*00n2A
	setf	*extreg,#wcode	;*00n2A

	setf	0x00,1		; 00 2B
	setf	*0x00,1		; 00 2B
	setf	extreg,1	;*00n2B
	setf	*extreg,1	;*00n2B
	setf	0x00,#1		; 00 2B
	setf	*0x00,#1	; 00 2B
	setf	extreg,#1	;*00n2B
	setf	*extreg,#1	;*00n2B
	setf	0x00,fcode	; 00 2B
	setf	*0x00,fcode	; 00 2B
	setf	extreg,fcode	;*00n2B
	setf	*extreg,fcode	;*00n2B
	setf	0x00,#fcode	; 00 2B
	setf	*0x00,#fcode	; 00 2B
	setf	extreg,#fcode	;*00n2B
	setf	*extreg,#fcode	;*00n2B

	negw	0x00,w		; 00 2C
	negw	0xFF,w		; FF 2C
	negw	extreg,w	;*00n2C

	negw	*0x00,w		; 00 2C
	negw	*0xFF,w		; FF 2C
	negw	*extreg,w	;*00n2C

	negw	0x00,f		; 00 2D
	negw	0xFF,f		; FF 2D
	negw	extreg,f	;*00n2D

	negw	*0x00,f		; 00 2D
	negw	*0xFF,f		; FF 2D
	negw	*extreg,f	;*00n2D

	negw	0x00,0		; 00 2C
	negw	*0x00,0		; 00 2C
	negw	extreg,0	;*00n2C
	negw	*extreg,0	;*00n2C
	negw	0x00,#0		; 00 2C
	negw	*0x00,#0	; 00 2C
	negw	extreg,#0	;*00n2C
	negw	*extreg,#0	;*00n2C
	negw	0x00,wcode	; 00 2C
	negw	*0x00,wcode	; 00 2C
	negw	extreg,wcode	;*00n2C
	negw	*extreg,wcode	;*00n2C
	negw	0x00,#wcode	; 00 2C
	negw	*0x00,#wcode	; 00 2C
	negw	extreg,#wcode	;*00n2C
	negw	*extreg,#wcode	;*00n2C

	negw	0x00,1		; 00 2D
	negw	*0x00,1		; 00 2D
	negw	extreg,1	;*00n2D
	negw	*extreg,1	;*00n2D
	negw	0x00,#1		; 00 2D
	negw	*0x00,#1	; 00 2D
	negw	extreg,#1	;*00n2D
	negw	*extreg,#1	;*00n2D
	negw	0x00,fcode	; 00 2D
	negw	*0x00,fcode	; 00 2D
	negw	extreg,fcode	;*00n2D
	negw	*extreg,fcode	;*00n2D
	negw	0x00,#fcode	; 00 2D
	negw	*0x00,#fcode	; 00 2D
	negw	extreg,#fcode	;*00n2D
	negw	*extreg,#fcode	;*00n2D

	daw	0x00,w		; 00 2E
	daw	0xFF,w		; FF 2E
	daw	extreg,w	;*00n2E

	daw	*0x00,w		; 00 2E
	daw	*0xFF,w		; FF 2E
	daw	*extreg,w	;*00n2E

	daw	0x00,f		; 00 2F
	daw	0xFF,f		; FF 2F
	daw	extreg,f	;*00n2F

	daw	*0x00,f		; 00 2F
	daw	*0xFF,f		; FF 2F
	daw	*extreg,f	;*00n2F

	daw	0x00,0		; 00 2E
	daw	*0x00,0		; 00 2E
	daw	extreg,0	;*00n2E
	daw	*extreg,0	;*00n2E
	daw	0x00,#0		; 00 2E
	daw	*0x00,#0	; 00 2E
	daw	extreg,#0	;*00n2E
	daw	*extreg,#0	;*00n2E
	daw	0x00,wcode	; 00 2E
	daw	*0x00,wcode	; 00 2E
	daw	extreg,wcode	;*00n2E
	daw	*extreg,wcode	;*00n2E
	daw	0x00,#wcode	; 00 2E
	daw	*0x00,#wcode	; 00 2E
	daw	extreg,#wcode	;*00n2E
	daw	*extreg,#wcode	;*00n2E

	daw	0x00,1		; 00 2F
	daw	*0x00,1		; 00 2F
	daw	extreg,1	;*00n2F
	daw	*extreg,1	;*00n2F
	daw	0x00,#1		; 00 2F
	daw	*0x00,#1	; 00 2F
	daw	extreg,#1	;*00n2F
	daw	*extreg,#1	;*00n2F
	daw	0x00,fcode	; 00 2F
	daw	*0x00,fcode	; 00 2F
	daw	extreg,fcode	;*00n2F
	daw	*extreg,fcode	;*00n2F
	daw	0x00,#fcode	; 00 2F
	daw	*0x00,#fcode	; 00 2F
	daw	extreg,#fcode	;*00n2F
	daw	*extreg,#fcode	;*00n2F

	cpfslt	0x00		; 00 30
	cpfslt	0xFF		; FF 30
	cpfslt	extreg		;*00n30

	cpfslt	*0x00		; 00 30
	cpfslt	*0xFF		; FF 30
	cpfslt	*extreg		;*00n30

	cpfseq	0x00		; 00 31
	cpfseq	0xFF		; FF 31
	cpfseq	extreg		;*00n31

	cpfseq	*0x00		; 00 31
	cpfseq	*0xFF		; FF 31
	cpfseq	*extreg		;*00n31

	cpfsgt	0x00		; 00 32
	cpfsgt	0xFF		; FF 32
	cpfsgt	extreg		;*00n32

	cpfsgt	*0x00		; 00 32
	cpfsgt	*0xFF		; FF 32
	cpfsgt	*extreg		;*00n32

	tstfsz	0x00		; 00 33
	tstfsz	0xFF		; FF 33
	tstfsz	extreg		;*00n33

	tstfsz	*0x00		; 00 33
	tstfsz	*0xFF		; FF 33
	tstfsz	*extreg		;*00n33

	mulwf	0x00		; 00 34
	mulwf	0xFF		; FF 34
	mulwf	extreg		;*00n34

	mulwf	*0x00		; 00 34
	mulwf	*0xFF		; FF 34
	mulwf	*extreg		;*00n34

	btg	0x00,0		; 00 38
	btg	0xFF,0		; FF 38
	btg	extreg,0	;*00n38

	btg	0x00,7		; 00 3F
	btg	0xFF,7		; FF 3F
	btg	extreg,7	;*00n3F

	btg	*0x00,0		; 00 38
	btg	*0xFF,0		; FF 38
	btg	*extreg,0	;*00n38

	btg	*0x00,7		; 00 3F
	btg	*0xFF,7		; FF 3F
	btg	*extreg,7	;*00n3F

	btg	0x00,num0	; 00 38
	btg	*0x00,num0	; 00 38
	btg	extreg,num0	;*00n38
	btg	*extreg,num0	;*00n38
	btg	0x00,#num0	; 00 38
	btg	*0x00,#num0	; 00 38
	btg	extreg,#num0	;*00n38
	btg	*extreg,#num0	;*00n38

	btg	0x00,num7	; 00 3F
	btg	*0x00,num7	; 00 3F
	btg	extreg,num7	;*00n3F
	btg	*extreg,num7	;*00n3F
	btg	0x00,#num7	; 00 3F
	btg	*0x00,#num7	; 00 3F
	btg	extreg,#num7	;*00n3F
	btg	*extreg,#num7	;*00n3F

	movpf	0x00,0x00	; 00 40
	movpf	0x1F,*0x00	; 00 5F
	movpf	0x00,0xFF	; FF 40
	movpf	0x1F,*0xFF	; FF 5F
	movpf	0x00,extreg	;*00n40
	movpf	0x1F,*extreg	;*00n5F

	movpf	*0x00,0x00	; 00 40
	movpf	*0x1F,*0x00	; 00 5F
	movpf	*0x00,0xFF	; FF 40
	movpf	*0x1F,*0xFF	; FF 5F
	movpf	*0x00,extreg	;*00n40
	movpf	*0x1F,*extreg	;*00n5F

	movfp	0x00,0x00	; 00 60
	movfp	*0x00,0x1F	; 00 7F
	movfp	0xFF,0x00	; FF 60
	movfp	*0xFF,0x1F	; FF 7F
	movfp	extreg,0x00	;*00n60
	movfp	*extreg,0x1F	;*00n7F

	movfp	0x00,*0x00	; 00 60
	movfp	*0x00,*0x1F	; 00 7F
	movfp	0xFF,*0x00	; FF 60
	movfp	*0xFF,*0x1F	; FF 7F
	movfp	extreg,*0x00	;*00n60
	movfp	*extreg,*0x1F	;*00n7F

	bsf	0x00,0		; 00 80
	bsf	0xFF,0		; FF 80
	bsf	extreg,0	;*00n80

	bsf	0x00,7		; 00 87
	bsf	0xFF,7		; FF 87
	bsf	extreg,7	;*00n87

	bsf	*0x00,0		; 00 80
	bsf	*0xFF,0		; FF 80
	bsf	*extreg,0	;*00n80

	bsf	*0x00,7		; 00 87
	bsf	*0xFF,7		; FF 87
 	bsf	*extreg,7	;*00n87

	bsf	0x00,num0	; 00 80
	bsf	*0x00,num0	; 00 80
	bsf	extreg,num0	;*00n80
	bsf	*extreg,num0	;*00n80
	bsf	0x00,#num0	; 00 80
	bsf	*0x00,#num0	; 00 80
	bsf	extreg,#num0	;*00n80
	bsf	*extreg,#num0	;*00n80

	bsf	0x00,num7	; 00 87
	bsf	*0x00,num7	; 00 87
	bsf	extreg,num7	;*00n87
	bsf	*extreg,num7	;*00n87
	bsf	0x00,#num7	; 00 87
	bsf	*0x00,#num7	; 00 87
	bsf	extreg,#num7	;*00n87
	bsf	*extreg,#num7	;*00n87

	bcf	0x00,0		; 00 88
	bcf	0xFF,0		; FF 88
	bcf	extreg,0	;*00n88

	bcf	0x00,7		; 00 8F
	bcf	0xFF,7		; FF 8F
	bcf	extreg,7	;*00n8F

	bcf	*0x00,0		; 00 88
	bcf	*0xFF,0		; FF 88
	bcf	*extreg,0	;*00n88

	bcf	*0x00,7		; 00 8F
	bcf	*0xFF,7		; FF 8F
	bcf	*extreg,7	;*00n8F

	bcf	0x00,num0	; 00 88
	bcf	*0x00,num0	; 00 88
	bcf	extreg,num0	;*00n88
	bcf	*extreg,num0	;*00n88
	bcf	0x00,#num0	; 00 88
	bcf	*0x00,#num0	; 00 88
	bcf	extreg,#num0	;*00n88
	bcf	*extreg,#num0	;*00n88

	bcf	0x00,num7	; 00 8F
	bcf	*0x00,num7	; 00 8F
	bcf	extreg,num7	;*00n8F
	bcf	*extreg,num7	;*00n8F
	bcf	0x00,#num7	; 00 8F
	bcf	*0x00,#num7	; 00 8F
	bcf	extreg,#num7	;*00n8F
	bcf	*extreg,#num7	;*00n8F

	btfss	0x00,0		; 00 90
	btfss	0xFF,0		; FF 90
	btfss	extreg,0	;*00n90

	btfss	0x00,7		; 00 97
	btfss	0xFF,7		; FF 97
	btfss	extreg,7	;*00n97

	btfss	*0x00,0		; 00 90
	btfss	*0xFF,0		; FF 90
	btfss	*extreg,0	;*00n90

	btfss	*0x00,7		; 00 97
	btfss	*0xFF,7		; FF 97
	btfss	*extreg,7	;*00n97

	btfss	0x00,num0	; 00 90
	btfss	*0x00,num0	; 00 90
	btfss	extreg,num0	;*00n90
	btfss	*extreg,num0	;*00n90
	btfss	0x00,#num0	; 00 90
	btfss	*0x00,#num0	; 00 90
	btfss	extreg,#num0	;*00n90
	btfss	*extreg,#num0	;*00n90

	btfss	0x00,num7	; 00 97
	btfss	*0x00,num7	; 00 97
	btfss	extreg,num7	;*00n97
	btfss	*extreg,num7	;*00n97
	btfss	0x00,#num7	; 00 97
	btfss	*0x00,#num7	; 00 97
	btfss	extreg,#num7	;*00n97
	btfss	*extreg,#num7	;*00n97

	btfsc	0x00,0		; 00 98
	btfsc	0xFF,0		; FF 98
	btfsc	extreg,0	;*00n98

	btfsc	0x00,7		; 00 9F
	btfsc	0xFF,7		; FF 9F
	btfsc	extreg,7	;*00n9F

	btfsc	*0x00,0		; 00 98
	btfsc	*0xFF,0		; FF 98
	btfsc	*extreg,0	;*00n98

	btfsc	*0x00,7		; 00 9F
	btfsc	*0xFF,7		; FF 9F
	btfsc	*extreg,7	;*00n9F

	btfsc	0x00,num0	; 00 98
	btfsc	*0x00,num0	; 00 98
	btfsc	extreg,num0	;*00n98
	btfsc	*extreg,num0	;*00n98
	btfsc	0x00,#num0	; 00 98
	btfsc	*0x00,#num0	; 00 98
	btfsc	extreg,#num0	;*00n98
	btfsc	*extreg,#num0	;*00n98

	btfsc	0x00,num7	; 00 9F
	btfsc	*0x00,num7	; 00 9F
	btfsc	extreg,num7	;*00n9F
	btfsc	*extreg,num7	;*00n9F
	btfsc	0x00,#num7	; 00 9F
	btfsc	*0x00,#num7	; 00 9F
	btfsc	extreg,#num7	;*00n9F
	btfsc	*extreg,#num7	;*00n9F

	tlrd	0,0x00		; 00 A0
	tlrd	0,0xFF		; FF A0
	tlrd	0,extreg	;*00nA0

	tlrd	1,0x00		; 00 A2
	tlrd	1,0xFF		; FF A2
	tlrd	1,extreg	;*00nA2

	tlrd	0,*0x00		; 00 A0
	tlrd	0,*0xFF		; FF A0
	tlrd	0,*extreg	;*00nA0

	tlrd	1,*0x00		; 00 A2
	tlrd	1,*0xFF		; FF A2
	tlrd	1,*extreg	;*00nA2

	tlrd	num0,0x00	; 00 A0
	tlrd	num0,*0xFF	; FF A0
	tlrd	num0,extreg	;*00nA0
	tlrd	num0,*extreg	;*00nA0
	tlrd	#num0,0x00	; 00 A0
	tlrd	#num0,*0xFF	; FF A0
	tlrd	#num0,extreg	;*00nA0
	tlrd	#num0,*extreg	;*00nA0

	tlrd	num1,0x00	; 00 A2
	tlrd	num1,*0xFF	; FF A2
	tlrd	num1,extreg	;*00nA2
	tlrd	num1,*extreg	;*00nA2
	tlrd	#num1,0x00	; 00 A2
	tlrd	#num1,*0xFF	; FF A2
	tlrd	#num1,extreg	;*00nA2
	tlrd	#num1,*extreg	;*00nA2

	tlwt	0,0x00		; 00 A4
	tlwt	0,0xFF		; FF A4
	tlwt	0,extreg	;*00nA4

	tlwt	1,0x00		; 00 A6
	tlwt	1,0xFF		; FF A6
	tlwt	1,extreg	;*00nA6

	tlwt	0,*0x00		; 00 A4
	tlwt	0,*0xFF		; FF A4
	tlwt	0,*extreg	;*00nA4

	tlwt	1,*0x00		; 00 A6
	tlwt	1,*0xFF		; FF A6
	tlwt	1,*extreg	;*00nA6

	tlwt	num0,0x00	; 00 A4
	tlwt	num0,*0xFF	; FF A4
	tlwt	num0,extreg	;*00nA4
	tlwt	num0,*extreg	;*00nA4
	tlwt	#num0,0x00	; 00 A4
	tlwt	#num0,*0xFF	; FF A4
	tlwt	#num0,extreg	;*00nA4
	tlwt	#num0,*extreg	;*00nA4

	tlwt	num1,0x00	; 00 A6
	tlwt	num1,*0xFF	; FF A6
	tlwt	num1,extreg	;*00nA6
	tlwt	num1,*extreg	;*00nA6
	tlwt	#num1,0x00	; 00 A6
	tlwt	#num1,*0xFF	; FF A6
	tlwt	#num1,extreg	;*00nA6
	tlwt	#num1,*extreg	;*00nA6

	tablrd	0,0,0x00	; 00 A8
	tablrd	0,0,0xFF	; FF A8
	tablrd	0,0,extreg	;*00nA8

	tablrd	0,1,0x00	; 00 A9
	tablrd	0,1,0xFF	; FF A9
	tablrd	0,1,extreg	;*00nA9

	tablrd	1,0,0x00	; 00 AA
	tablrd	1,0,0xFF	; FF AA
	tablrd	1,0,extreg	;*00nAA

	tablrd	1,1,0x00	; 00 AB
	tablrd	1,1,0xFF	; FF AB
	tablrd	1,1,extreg	;*00nAB

	tablrd	0,0,*0x00	; 00 A8
	tablrd	0,0,*0xFF	; FF A8
	tablrd	0,0,*extreg	;*00nA8

	tablrd	0,1,*0x00	; 00 A9
	tablrd	0,1,*0xFF	; FF A9
	tablrd	0,1,*extreg	;*00nA9

	tablrd	1,0,*0x00	; 00 AA
	tablrd	1,0,*0xFF	; FF AA
	tablrd	1,0,*extreg	;*00nAA

	tablrd	1,1,*0x00	; 00 AB
	tablrd	1,1,*0xFF	; FF AB
	tablrd	1,1,*extreg	;*00nAB

	tablrd	num0,num0,0x00		; 00 A8
	tablrd	num0,num0,*0xFF		; FF A8
	tablrd	num0,num0,extreg	;*00nA8
	tablrd	num0,num0,*extreg	;*00nA8

	tablrd	#num0,num0,0x00		; 00 A8
	tablrd	#num0,num0,*0xFF	; FF A8
	tablrd	#num0,num0,extreg	;*00nA8
	tablrd	#num0,num0,*extreg	;*00nA8

	tablrd	num1,num0,0x00		; 00 AA
	tablrd	num1,num0,*0xFF		; FF AA
	tablrd	num1,num0,extreg	;*00nAA
	tablrd	num1,num0,*extreg	;*00nAA

	tablrd	#num1,num0,0x00		; 00 AA
	tablrd	#num1,num0,*0xFF	; FF AA
	tablrd	#num1,num0,extreg	;*00nAA
	tablrd	#num1,num0,*extreg	;*00nAA

	tablrd	num0,#num0,0x00		; 00 A8
	tablrd	num0,#num0,*0xFF	; FF A8
	tablrd	num0,#num0,extreg	;*00nA8
	tablrd	num0,#num0,*extreg	;*00nA8

	tablrd	#num0,#num0,0x00	; 00 A8
	tablrd	#num0,#num0,*0xFF	; FF A8
	tablrd	#num0,#num0,extreg	;*00nA8
	tablrd	#num0,#num0,*extreg	;*00nA8

	tablrd	num1,#num0,0x00		; 00 AA
	tablrd	num1,#num0,*0xFF	; FF AA
	tablrd	num1,#num0,extreg	;*00nAA
	tablrd	num1,#num0,*extreg	;*00nAA

	tablrd	#num1,#num0,0x00	; 00 AA
	tablrd	#num1,#num0,*0xFF	; FF AA
	tablrd	#num1,#num0,extreg	;*00nAA
	tablrd	#num1,#num0,*extreg	;*00nAA

	tablrd	num0,num1,0x00		; 00 A9
	tablrd	num0,num1,*0xFF		; FF A9
	tablrd	num0,num1,extreg	;*00nA9
	tablrd	num0,num1,*extreg	;*00nA9

	tablrd	#num0,num1,0x00		; 00 A9
	tablrd	#num0,num1,*0xFF	; FF A9
	tablrd	#num0,num1,extreg	;*00nA9
	tablrd	#num0,num1,*extreg	;*00nA9

	tablrd	num1,num1,0x00		; 00 AB
	tablrd	num1,num1,*0xFF		; FF AB
	tablrd	num1,num1,extreg	;*00nAB
	tablrd	num1,num1,*extreg	;*00nAB

	tablrd	#num1,num1,0x00		; 00 AB
	tablrd	#num1,num1,*0xFF	; FF AB
	tablrd	#num1,num1,extreg	;*00nAB
	tablrd	#num1,num1,*extreg	;*00nAB

	tablrd	num0,#num1,0x00		; 00 A9
	tablrd	num0,#num1,*0xFF	; FF A9
	tablrd	num0,#num1,extreg	;*00nA9
	tablrd	num0,#num1,*extreg	;*00nA9

	tablrd	#num0,#num1,0x00	; 00 A9
	tablrd	#num0,#num1,*0xFF	; FF A9
	tablrd	#num0,#num1,extreg	;*00nA9
	tablrd	#num0,#num1,*extreg	;*00nA9

	tablrd	num1,#num1,0x00		; 00 AB
	tablrd	num1,#num1,*0xFF	; FF AB
	tablrd	num1,#num1,extreg	;*00nAB
	tablrd	num1,#num1,*extreg	;*00nAB

	tablrd	#num1,#num1,0x00	; 00 AB
	tablrd	#num1,#num1,*0xFF	; FF AB
	tablrd	#num1,#num1,extreg	;*00nAB
	tablrd	#num1,#num1,*extreg	;*00nAB

	tablwt	0,0,0x00	; 00 AC
	tablwt	0,0,0xFF	; FF AC
	tablwt	0,0,extreg	;*00nAC

	tablwt	0,1,0x00	; 00 AD
	tablwt	0,1,0xFF	; FF AD
	tablwt	0,1,extreg	;*00nAD

	tablwt	1,0,0x00	; 00 AE
	tablwt	1,0,0xFF	; FF AE
	tablwt	1,0,extreg	;*00nAE

	tablwt	1,1,0x00	; 00 AF
	tablwt	1,1,0xFF	; FF AF
	tablwt	1,1,extreg	;*00nAF

	tablwt	0,0,*0x00	; 00 AC
	tablwt	0,0,*0xFF	; FF AC
	tablwt	0,0,*extreg	;*00nAC

	tablwt	0,1,*0x00	; 00 AD
	tablwt	0,1,*0xFF	; FF AD
	tablwt	0,1,*extreg	;*00nAD

	tablwt	1,0,*0x00	; 00 AE
	tablwt	1,0,*0xFF	; FF AE
	tablwt	1,0,*extreg	;*00nAE

	tablwt	1,1,*0x00	; 00 AF
	tablwt	1,1,*0xFF	; FF AF
	tablwt	1,1,*extreg	;*00nAF

	tablwt	num0,num0,0x00		; 00 AC
	tablwt	num0,num0,*0xFF		; FF AC
	tablwt	num0,num0,extreg	;*00nAC
	tablwt	num0,num0,*extreg	;*00nAC

	tablwt	#num0,num0,0x00		; 00 AC
	tablwt	#num0,num0,*0xFF	; FF AC
	tablwt	#num0,num0,extreg	;*00nAC
	tablwt	#num0,num0,*extreg	;*00nAC

	tablwt	num1,num0,0x00		; 00 AE
	tablwt	num1,num0,*0xFF		; FF AE
	tablwt	num1,num0,extreg	;*00nAE
	tablwt	num1,num0,*extreg	;*00nAE

	tablwt	#num1,num0,0x00		; 00 AE
	tablwt	#num1,num0,*0xFF	; FF AE
	tablwt	#num1,num0,extreg	;*00nAE
	tablwt	#num1,num0,*extreg	;*00nAE

	tablwt	num0,#num0,0x00		; 00 AC
	tablwt	num0,#num0,*0xFF	; FF AC
	tablwt	num0,#num0,extreg	;*00nAC
	tablwt	num0,#num0,*extreg	;*00nAC

	tablwt	#num0,#num0,0x00	; 00 AC
	tablwt	#num0,#num0,*0xFF	; FF AC
	tablwt	#num0,#num0,extreg	;*00nAC
	tablwt	#num0,#num0,*extreg	;*00nAC

	tablwt	num1,#num0,0x00		; 00 AE
	tablwt	num1,#num0,*0xFF	; FF AE
	tablwt	num1,#num0,extreg	;*00nAE
	tablwt	num1,#num0,*extreg	;*00nAE

	tablwt	#num1,#num0,0x00	; 00 AE
	tablwt	#num1,#num0,*0xFF	; FF AE
	tablwt	#num1,#num0,extreg	;*00nAE
	tablwt	#num1,#num0,*extreg	;*00nAE

	tablwt	num0,num1,0x00		; 00 AD
	tablwt	num0,num1,*0xFF		; FF AD
	tablwt	num0,num1,extreg	;*00nAD
	tablwt	num0,num1,*extreg	;*00nAD

	tablwt	#num0,num1,0x00		; 00 AD
	tablwt	#num0,num1,*0xFF	; FF AD
	tablwt	#num0,num1,extreg	;*00nAD
	tablwt	#num0,num1,*extreg	;*00nAD

	tablwt	num1,num1,0x00		; 00 AF
	tablwt	num1,num1,*0xFF		; FF AF
	tablwt	num1,num1,extreg	;*00nAF
	tablwt	num1,num1,*extreg	;*00nAF

	tablwt	#num1,num1,0x00		; 00 AF
	tablwt	#num1,num1,*0xFF	; FF AF
	tablwt	#num1,num1,extreg	;*00nAF
	tablwt	#num1,num1,*extreg	;*00nAF

	tablwt	num0,#num1,0x00		; 00 AD
	tablwt	num0,#num1,*0xFF	; FF AD
	tablwt	num0,#num1,extreg	;*00nAD
	tablwt	num0,#num1,*extreg	;*00nAD

	tablwt	#num0,#num1,0x00	; 00 AD
	tablwt	#num0,#num1,*0xFF	; FF AD
	tablwt	#num0,#num1,extreg	;*00nAD
	tablwt	#num0,#num1,*extreg	;*00nAD

	tablwt	num1,#num1,0x00		; 00 AF
	tablwt	num1,#num1,*0xFF	; FF AF
	tablwt	num1,#num1,extreg	;*00nAF
	tablwt	num1,#num1,*extreg	;*00nAF

	tablwt	#num1,#num1,0x00	; 00 AF
	tablwt	#num1,#num1,*0xFF	; FF AF
	tablwt	#num1,#num1,extreg	;*00nAF
	tablwt	#num1,#num1,*extreg	;*00nAF

	movlw	0x00		; 00 B0
	movlw	0xFF		; FF B0
	movlw	extvalu		;r00sB0

	movlw	#0x00		; 00 B0
	movlw	#0xFF		; FF B0
	movlw	#extvalu	;r00sB0

	addlw	0x00		; 00 B1
	addlw	0xFF		; FF B1
	addlw	extvalu		;r00sB1

	addlw	#0x00		; 00 B1
	addlw	#0xFF		; FF B1
	addlw	#extvalu	;r00sB1

	sublw	0x00		; 00 B2
	sublw	0xFF		; FF B2
	sublw	extvalu		;r00sB2

	sublw	#0x00		; 00 B2
	sublw	#0xFF		; FF B2
	sublw	#extvalu	;r00sB2

	iorlw	0x00		; 00 B3
	iorlw	0xFF		; FF B3
	iorlw	extvalu		;r00sB3

	iorlw	#0x00		; 00 B3
	iorlw	#0xFF		; FF B3
	iorlw	#extvalu	;r00sB3

	xorlw	0x00		; 00 B4
	xorlw	0xFF		; FF B4
	xorlw	extvalu		;r00sB4

	xorlw	#0x00		; 00 B4
	xorlw	#0xFF		; FF B4
	xorlw	#extvalu	;r00sB4

	andlw	0x00		; 00 B5
	andlw	0xFF		; FF B5
	andlw	extvalu		;r00sB5

	andlw	#0x00		; 00 B5
	andlw	#0xFF		; FF B5
	andlw	#extvalu	;r00sB5

	retlw	0x00		; 00 B6
	retlw	0xFF		; FF B6
	retlw	extvalu		;r00sB6

	retlw	#0x00		; 00 B6
	retlw	#0xFF		; FF B6
	retlw	#extvalu	;r00sB6

	.setdmm	0x0000		; PCLATH = 0x00
	lcall	0x00		;*00nB7
;L	lcall	0x00-0x01	;*FFnB7
;L	lcall	0xFF+0x01	;*00nB7
	.setdmm	0x1F00		; PCLATH = 0x1F
	lcall	0x1FFF		;*FFnB7
;L	lcall	0x1FFF+0x001	;*00nB7
;L	lcall	0x1FFF-0x100	;*FFnB7
	.setdmm	0x0000		; PCLATH = 0x00
	lcall	addr_00		;*00nB7
;L	lcall	addr_00-0x001	;*FFnB7
;L	lcall	addr_00+0x100	;*00nB7
	.setdmm	0x1F00		; PCLATH = 0x1F
	lcall	addr_1FFF	;*FFnB7
;L	lcall	addr_1FFF+0x001	;*00nB7
;L	lcall	addr_1FFF-0x100 ;*FFnB7
	.setdmm	0x0000		; PCLATH = 0x00
	lcall	extaddr		;*00nB7
;L	lcall	extaddr-0x001	;*FFnB7
;L	lcall	extaddr+0x100	;*00nB7

	.setdmm	0x1F00		; PCLATH = 0x1F

	movlb	0x00		; 00 B8
	movlb	0x0F		; 0F B8
	movlb	extvalu		;r00sB8

	movlb	#0x00		; 00 B8
	movlb	#0x0F		; 0F B8
	movlb	#extvalu	;r00sB8

	movlr	0x00		; 00 BA
	movlr	0x0F		; F0 BA
	movlr	extvalu		;r00sBA

	movlr	#0x00		; 00 BA
	movlr	#0x0F		; F0 BA
	movlr	#extvalu	;r00sBA

	mullw	0x00		; 00 BC
	mullw	0xFF		; FF BC
	mullw	extvalu		;r00sBC

	mullw	#0x00		; 00 BC
	mullw	#0xFF		; FF BC
	mullw	#extvalu	;r00sBC

	goto	0x00		; 00 C0
	goto	0x1FFF		; FF DF

	goto	addr_00		;r00sC0
	goto	addr_1FFF	;rFFsDF

	goto	extaddr		;r00sC0

	call	0x00		; 00 E0
	call	0x1FFF		; FF FF

	call	addr_00		;r00sE0
	call	addr_1FFF	;rFFsFF

	call	extaddr		;r00sE0


