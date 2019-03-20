	.title	TP12C5XX.ASM - Test file for ASPIC assembler
;
;  Assemble:
;	aspic -gloaxff tpic12c5xx
;

	.include	"tp12c5xx.def"

	.area	DATA

	triscode =	6

	fcode =		1
	wcode =		0

	num0 =		0
	num7 =		7

	.area	CODE

	addr_00	=	. + 0x00
	addr_FF =	. + 0xff
	addr_1FF =	. + 0x1ff


	nop			; 00 00

	option			; 02 00
	sleep			; 03 00
	clrwdt			; 04 00

	tris	6		; 06 00
	tris	#6		; 06 00
	tris	triscode	; 06 00
	tris	#triscode	; 06 00

	movwf	0x00		; 20 00
	movwf	0x1F		; 3F 00
	movwf	extreg		;*20n00

	movwf	*0x00		; 20 00
	movwf	*0x1F		; 3F 00
	movwf	*extreg		;*20n00

	clrw			; 40 00

	clrf	0x00		; 60 00
	clrf	0x1F		; 7F 00
	clrf	extreg		;*60n00

	clrf	*0x00		; 60 00
	clrf	*0x1F		; 7F 00
	clrf	*extreg		;*60n00

	subwf	0x00,w		; 80 00
	subwf	0x1F,w		; 9F 00
	subwf	extreg,w	;*80n00

	subwf	*0x00,w		; 80 00
	subwf	*0x1F,w		; 9F 00
	subwf	*extreg,w	;*80n00

	subwf	0x00,f		; A0 00
	subwf	0x1F,f		; BF 00
	subwf	extreg,f	;*A0n00

	subwf	*0x00,f		; A0 00
	subwf	*0x1F,f		; BF 00
	subwf	*extreg,f	;*A0n00

	subwf	0x00,0		; 80 00
	subwf	*0x00,0		; 80 00
	subwf	extreg,0	;*80n00
	subwf	*extreg,0	;*80n00
	subwf	0x00,#0		; 80 00
	subwf	*0x00,#0	; 80 00
	subwf	extreg,#0	;*80n00
	subwf	*extreg,#0	;*80n00
	subwf	0x00,wcode	; 80 00
	subwf	*0x00,wcode	; 80 00
	subwf	extreg,wcode	;*80n00
	subwf	*extreg,wcode	;*80n00
	subwf	0x00,#wcode	; 80 00
	subwf	*0x00,#wcode	; 80 00
	subwf	extreg,#wcode	;*80n00
	subwf	*extreg,#wcode	;*80n00

	subwf	0x00,1		; A0 00
	subwf	*0x00,1		; A0 00
	subwf	extreg,1	;*A0n00
	subwf	*extreg,1	;*A0n00
	subwf	0x00,#1		; A0 00
	subwf	*0x00,#1	; A0 00
	subwf	extreg,#1	;*A0n00
	subwf	*extreg,#1	;*A0n00
	subwf	0x00,fcode	; A0 00
	subwf	*0x00,fcode	; A0 00
	subwf	extreg,fcode	;*A0n00
	subwf	*extreg,fcode	;*A0n00
	subwf	0x00,#fcode	; A0 00
	subwf	*0x00,#fcode	; A0 00
	subwf	extreg,#fcode	;*A0n00
	subwf	*extreg,#fcode	;*A0n00

	decf	0x00,w		; C0 00
	decf	0x1F,w		; DF 00
	decf	extreg,w	;*C0n00

	decf	0x00,f		; E0 00
	decf	0x1F,f		; FF 00
	decf	extreg,f	;*E0n00

	decf	*0x00,w		; C0 00
	decf	*0x1F,w		; DF 00
	decf	*extreg,w	;*C0n00

	decf	*0x00,f		; E0 00
	decf	*0x1F,f		; FF 00
	decf	*extreg,f	;*E0n00

	decf	0x00,0		; C0 00
	decf	*0x00,0		; C0 00
	decf	extreg,0	;*C0n00
	decf	*extreg,0	;*C0n00
	decf	0x00,#0		; C0 00
	decf	*0x00,#0	; C0 00
	decf	extreg,#0	;*C0n00
	decf	*extreg,#0	;*C0n00
	decf	0x00,wcode	; C0 00
	decf	*0x00,wcode	; C0 00
	decf	extreg,wcode	;*C0n00
	decf	*extreg,wcode	;*C0n00
	decf	0x00,#wcode	; C0 00
	decf	*0x00,#wcode	; C0 00
	decf	extreg,#wcode	;*C0n00
	decf	*extreg,#wcode	;*C0n00

	decf	0x00,1		; E0 00
	decf	*0x00,1		; E0 00
	decf	extreg,1	;*E0n00
	decf	*extreg,1	;*E0n00
	decf	0x00,#1		; E0 00
	decf	*0x00,#1	; E0 00
	decf	extreg,#1	;*E0n00
	decf	*extreg,#1	;*E0n00
	decf	0x00,fcode	; E0 00
	decf	*0x00,fcode	; E0 00
	decf	extreg,fcode	;*E0n00
	decf	*extreg,fcode	;*E0n00
	decf	0x00,#fcode	; E0 00
	decf	*0x00,#fcode	; E0 00
	decf	extreg,#fcode	;*E0n00
	decf	*extreg,#fcode	;*E0n00

	iorwf	0x00,w		; 00 01
	iorwf	0x1F,w		; 1F 01
	iorwf	extreg,w	;*00n01

	iorwf	0x00,f		; 20 01
	iorwf	0x1F,f		; 3F 01
	iorwf	extreg,f	;*20n01

	iorwf	*0x00,w		; 00 01
	iorwf	*0x1F,w		; 1F 01
	iorwf	*extreg,w	;*00n01

	iorwf	*0x00,f		; 20 01
	iorwf	*0x1F,f		; 3F 01
	iorwf	*extreg,f	;*20n01

	iorwf	0x00,0		; 00 01
	iorwf	*0x00,0		; 00 01
	iorwf	extreg,0	;*00n01
	iorwf	*extreg,0	;*00n01
	iorwf	0x00,#0		; 00 01
	iorwf	*0x00,#0	; 00 01
	iorwf	extreg,#0	;*00n01
	iorwf	*extreg,#0	;*00n01
	iorwf	0x00,wcode	; 00 01
	iorwf	*0x00,wcode	; 00 01
	iorwf	extreg,wcode	;*00n01
	iorwf	*extreg,wcode	;*00n01
	iorwf	0x00,#wcode	; 00 01
	iorwf	*0x00,#wcode	; 00 01
	iorwf	extreg,#wcode	;*00n01
	iorwf	*extreg,#wcode	;*00n01

	iorwf	0x00,1		; 20 01
	iorwf	*0x00,1		; 20 01
	iorwf	extreg,1	;*20n01
	iorwf	*extreg,1	;*20n01
	iorwf	0x00,#1		; 20 01
	iorwf	*0x00,#1	; 20 01
	iorwf	extreg,#1	;*20n01
	iorwf	*extreg,#1	;*20n01
	iorwf	0x00,fcode	; 20 01
	iorwf	*0x00,fcode	; 20 01
	iorwf	extreg,fcode	;*20n01
	iorwf	*extreg,fcode	;*20n01
	iorwf	0x00,#fcode	; 20 01
	iorwf	*0x00,#fcode	; 20 01
	iorwf	extreg,#fcode	;*20n01
	iorwf	*extreg,#fcode	;*20n01

	andwf	0x00,w		; 40 01
	andwf	0x1F,w		; 5F 01
	andwf	extreg,w	;*40n01

	andwf	0x00,f		; 60 01
	andwf	0x1F,f		; 7F 01
	andwf	extreg,f	;*60n01

	andwf	*0x00,w		; 40 01
	andwf	*0x1F,w		; 5F 01
	andwf	*extreg,w	;*40n01

	andwf	*0x00,f		; 60 01
	andwf	*0x1F,f		; 7F 01
	andwf	*extreg,f	;*60n01

	andwf	0x00,0		; 40 01
	andwf	*0x00,0		; 40 01
	andwf	extreg,0	;*40n01
	andwf	*extreg,0	;*40n01
	andwf	0x00,#0		; 40 01
	andwf	*0x00,#0	; 40 01
	andwf	extreg,#0	;*40n01
	andwf	*extreg,#0	;*40n01
	andwf	0x00,wcode	; 40 01
	andwf	*0x00,wcode	; 40 01
	andwf	extreg,wcode	;*40n01
	andwf	*extreg,wcode	;*40n01
	andwf	0x00,#wcode	; 40 01
	andwf	*0x00,#wcode	; 40 01
	andwf	extreg,#wcode	;*40n01
	andwf	*extreg,#wcode	;*40n01

	andwf	0x00,1		; 60 01
	andwf	*0x00,1		; 60 01
	andwf	extreg,1	;*60n01
	andwf	*extreg,1	;*60n01
	andwf	0x00,#1		; 60 01
	andwf	*0x00,#1	; 60 01
	andwf	extreg,#1	;*60n01
	andwf	*extreg,#1	;*60n01
	andwf	0x00,fcode	; 60 01
	andwf	*0x00,fcode	; 60 01
	andwf	extreg,fcode	;*60n01
	andwf	*extreg,fcode	;*60n01
	andwf	0x00,#fcode	; 60 01
	andwf	*0x00,#fcode	; 60 01
	andwf	extreg,#fcode	;*60n01
	andwf	*extreg,#fcode	;*60n01

	xorwf	0x00,w		; 80 01
	xorwf	0x1F,w		; 9F 01
	xorwf	extreg,w	;*80n01

	xorwf	0x00,f		; A0 01
	xorwf	0x1F,f		; BF 01
	xorwf	extreg,f	;*A0n01

	xorwf	*0x00,w		; 80 01
	xorwf	*0x1F,w		; 9F 01
	xorwf	*extreg,w	;*80n01

	xorwf	*0x00,f		; A0 01
	xorwf	*0x1F,f		; BF 01
	xorwf	*extreg,f	;*A0n01

	xorwf	0x00,0		; 80 01
	xorwf	*0x00,0		; 80 01
	xorwf	extreg,0	;*80n01
	xorwf	*extreg,0	;*80n01
	xorwf	0x00,#0		; 80 01
	xorwf	*0x00,#0	; 80 01
	xorwf	extreg,#0	;*80n01
	xorwf	*extreg,#0	;*80n01
	xorwf	0x00,wcode	; 80 01
	xorwf	*0x00,wcode	; 80 01
	xorwf	extreg,wcode	;*80n01
	xorwf	*extreg,wcode	;*80n01
	xorwf	0x00,#wcode	; 80 01
	xorwf	*0x00,#wcode	; 80 01
	xorwf	extreg,#wcode	;*80n01
	xorwf	*extreg,#wcode	;*80n01

	xorwf	0x00,1		; A0 01
	xorwf	*0x00,1		; A0 01
	xorwf	extreg,1	;*A0n01
	xorwf	*extreg,1	;*A0n01
	xorwf	0x00,#1		; A0 01
	xorwf	*0x00,#1	; A0 01
	xorwf	extreg,#1	;*A0n01
	xorwf	*extreg,#1	;*A0n01
	xorwf	0x00,fcode	; A0 01
	xorwf	*0x00,fcode	; A0 01
	xorwf	extreg,fcode	;*A0n01
	xorwf	*extreg,fcode	;*A0n01
	xorwf	0x00,#fcode	; A0 01
	xorwf	*0x00,#fcode	; A0 01
	xorwf	extreg,#fcode	;*A0n01
	xorwf	*extreg,#fcode	;*A0n01

	addwf	0x00,w		; C0 01
	addwf	0x1F,w		; DF 01
	addwf	extreg,w	;*C0n01

	addwf	0x00,f		; E0 01
	addwf	0x1F,f		; FF 01
	addwf	extreg,f	;*E0n01

	addwf	*0x00,w		; C0 01
	addwf	*0x1F,w		; DF 01
	addwf	*extreg,w	;*C0n01

	addwf	*0x00,f		; E0 01
	addwf	*0x1F,f		; FF 01
 	addwf	*extreg,f	;*E0n01

	addwf	0x00,0		; C0 01
	addwf	*0x00,0		; C0 01
	addwf	extreg,0	;*C0n01
	addwf	*extreg,0	;*C0n01
	addwf	0x00,#0		; C0 01
	addwf	*0x00,#0	; C0 01
	addwf	extreg,#0	;*C0n01
	addwf	*extreg,#0	;*C0n01
	addwf	0x00,wcode	; C0 01
	addwf	*0x00,wcode	; C0 01
	addwf	extreg,wcode	;*C0n01
	addwf	*extreg,wcode	;*C0n01
	addwf	0x00,#wcode	; C0 01
	addwf	*0x00,#wcode	; C0 01
	addwf	extreg,#wcode	;*C0n01
	addwf	*extreg,#wcode	;*C0n01

	addwf	0x00,1		; E0 01
	addwf	*0x00,1		; E0 01
	addwf	extreg,1	;*E0n01
	addwf	*extreg,1	;*E0n01
	addwf	0x00,#1		; E0 01
	addwf	*0x00,#1	; E0 01
	addwf	extreg,#1	;*E0n01
	addwf	*extreg,#1	;*E0n01
	addwf	0x00,fcode	; E0 01
	addwf	*0x00,fcode	; E0 01
	addwf	extreg,fcode	;*E0n01
	addwf	*extreg,fcode	;*E0n01
	addwf	0x00,#fcode	; E0 01
	addwf	*0x00,#fcode	; E0 01
	addwf	extreg,#fcode	;*E0n01
	addwf	*extreg,#fcode	;*E0n01

	movf	0x00,w		; 00 02
	movf	0x1F,w		; 1F 02
	movf	extreg,w	;*00n02

	movf	0x00,f		; 20 02
	movf	0x1F,f		; 3F 02
	movf	extreg,f	;*20n02

	movf	*0x00,w		; 00 02
	movf	*0x1F,w		; 1F 02
	movf	*extreg,w	;*00n02

	movf	*0x00,f		; 20 02
	movf	*0x1F,f		; 3F 02
	movf	*extreg,f	;*20n02

	movf	0x00,0		; 00 02
	movf	*0x00,0		; 00 02
	movf	extreg,0	;*00n02
	movf	*extreg,0	;*00n02
	movf	0x00,#0		; 00 02
	movf	*0x00,#0	; 00 02
	movf	extreg,#0	;*00n02
	movf	*extreg,#0	;*00n02
	movf	0x00,wcode	; 00 02
	movf	*0x00,wcode	; 00 02
	movf	extreg,wcode	;*00n02
	movf	*extreg,wcode	;*00n02
	movf	0x00,#wcode	; 00 02
	movf	*0x00,#wcode	; 00 02
	movf	extreg,#wcode	;*00n02
	movf	*extreg,#wcode	;*00n02

	movf	0x00,1		; 20 02
	movf	*0x00,1		; 20 02
	movf	extreg,1	;*20n02
	movf	*extreg,1	;*20n02
	movf	0x00,#1		; 20 02
	movf	*0x00,#1	; 20 02
	movf	extreg,#1	;*20n02
	movf	*extreg,#1	;*20n02
	movf	0x00,fcode	; 20 02
	movf	*0x00,fcode	; 20 02
	movf	extreg,fcode	;*20n02
	movf	*extreg,fcode	;*20n02
	movf	0x00,#fcode	; 20 02
	movf	*0x00,#fcode	; 20 02
	movf	extreg,#fcode	;*20n02
	movf	*extreg,#fcode	;*20n02

	comf	0x00,w		; 40 02
	comf	0x1F,w		; 5F 02
	comf	extreg,w	;*40n02

	comf	0x00,f		; 60 02
	comf	0x1F,f		; 7F 02
 	comf	extreg,f	;*60n02

	comf	*0x00,w		; 40 02
	comf	*0x1F,w		; 5F 02
	comf	*extreg,w	;*40n02

	comf	*0x00,f		; 60 02
	comf	*0x1F,f		; 7F 02
 	comf	*extreg,f	;*60n02

	comf	0x00,0		; 40 02
	comf	*0x00,0		; 40 02
	comf	extreg,0	;*40n02
	comf	*extreg,0	;*40n02
	comf	0x00,#0		; 40 02
	comf	*0x00,#0	; 40 02
	comf	extreg,#0	;*40n02
	comf	*extreg,#0	;*40n02
	comf	0x00,wcode	; 40 02
	comf	*0x00,wcode	; 40 02
	comf	extreg,wcode	;*40n02
	comf	*extreg,wcode	;*40n02
	comf	0x00,#wcode	; 40 02
	comf	*0x00,#wcode	; 40 02
	comf	extreg,#wcode	;*40n02
	comf	*extreg,#wcode	;*40n02

	comf	0x00,1		; 60 02
	comf	*0x00,1		; 60 02
	comf	extreg,1	;*60n02
	comf	*extreg,1	;*60n02
	comf	0x00,#1		; 60 02
	comf	*0x00,#1	; 60 02
	comf	extreg,#1	;*60n02
	comf	*extreg,#1	;*60n02
	comf	0x00,fcode	; 60 02
	comf	*0x00,fcode	; 60 02
	comf	extreg,fcode	;*60n02
	comf	*extreg,fcode	;*60n02
	comf	0x00,#fcode	; 60 02
	comf	*0x00,#fcode	; 60 02
	comf	extreg,#fcode	;*60n02
	comf	*extreg,#fcode	;*60n02

	incf	0x00,w		; 80 02
	incf	0x1F,w		; 9F 02
	incf	extreg,w	;*80n02

	incf	0x00,f		; A0 02
	incf	0x1F,f		; BF 02
	incf	extreg,f	;*A0n02

	incf	*0x00,w		; 80 02
	incf	*0x1F,w		; 9F 02
	incf	*extreg,w	;*80n02

	incf	*0x00,f		; A0 02
	incf	*0x1F,f		; BF 02
	incf	*extreg,f	;*A0n02

	incf	0x00,0		; 80 02
	incf	*0x00,0		; 80 02
	incf	extreg,0	;*80n02
	incf	*extreg,0	;*80n02
	incf	0x00,#0		; 80 02
	incf	*0x00,#0	; 80 02
	incf	extreg,#0	;*80n02
	incf	*extreg,#0	;*80n02
	incf	0x00,wcode	; 80 02
	incf	*0x00,wcode	; 80 02
	incf	extreg,wcode	;*80n02
	incf	*extreg,wcode	;*80n02
	incf	0x00,#wcode	; 80 02
	incf	*0x00,#wcode	; 80 02
	incf	extreg,#wcode	;*80n02
	incf	*extreg,#wcode	;*80n02

	incf	0x00,1		; A0 02
	incf	*0x00,1		; A0 02
	incf	extreg,1	;*A0n02
	incf	*extreg,1	;*A0n02
	incf	0x00,#1		; A0 02
	incf	*0x00,#1	; A0 02
	incf	extreg,#1	;*A0n02
	incf	*extreg,#1	;*A0n02
	incf	0x00,fcode	; A0 02
	incf	*0x00,fcode	; A0 02
	incf	extreg,fcode	;*A0n02
	incf	*extreg,fcode	;*A0n02
	incf	0x00,#fcode	; A0 02
	incf	*0x00,#fcode	; A0 02
	incf	extreg,#fcode	;*A0n02
	incf	*extreg,#fcode	;*A0n02

	decfsz	0x00,w		; C0 02
	decfsz	0x1F,w		; DF 02
	decfsz	extreg,w	;*C0n02

	decfsz	0x00,f		; E0 02
	decfsz	0x1F,f		; FF 02
	decfsz	extreg,f	;*E0n02

	decfsz	*0x00,w		; C0 02
	decfsz	*0x1F,w		; DF 02
	decfsz	*extreg,w	;*C0n02

	decfsz	*0x00,f		; E0 02
	decfsz	*0x1F,f		; FF 02
 	decfsz	*extreg,f	;*E0n02

	decfsz	0x00,0		; C0 02
	decfsz	*0x00,0		; C0 02
	decfsz	extreg,0	;*C0n02
	decfsz	*extreg,0	;*C0n02
	decfsz	0x00,#0		; C0 02
	decfsz	*0x00,#0	; C0 02
	decfsz	extreg,#0	;*C0n02
	decfsz	*extreg,#0	;*C0n02
	decfsz	0x00,wcode	; C0 02
	decfsz	*0x00,wcode	; C0 02
	decfsz	extreg,wcode	;*C0n02
	decfsz	*extreg,wcode	;*C0n02
	decfsz	0x00,#wcode	; C0 02
	decfsz	*0x00,#wcode	; C0 02
	decfsz	extreg,#wcode	;*C0n02
	decfsz	*extreg,#wcode	;*C0n02

	decfsz	0x00,1		; E0 02
	decfsz	*0x00,1		; E0 02
	decfsz	extreg,1	;*E0n02
	decfsz	*extreg,1	;*E0n02
	decfsz	0x00,#1		; E0 02
	decfsz	*0x00,#1	; E0 02
	decfsz	extreg,#1	;*E0n02
	decfsz	*extreg,#1	;*E0n02
	decfsz	0x00,fcode	; E0 02
	decfsz	*0x00,fcode	; E0 02
	decfsz	extreg,fcode	;*E0n02
	decfsz	*extreg,fcode	;*E0n02
	decfsz	0x00,#fcode	; E0 02
	decfsz	*0x00,#fcode	; E0 02
	decfsz	extreg,#fcode	;*E0n02
	decfsz	*extreg,#fcode	;*E0n02

	rrf	0x00,w		; 00 03
	rrf	0x1F,w		; 1F 03
	rrf	extreg,w	;*00n03

	rrf	0x00,f		; 20 03
	rrf	0x1F,f		; 3F 03
	rrf	extreg,f	;*20n03

	rrf	*0x00,w		; 00 03
	rrf	*0x1F,w		; 1F 03
	rrf	*extreg,w	;*00n03

	rrf	*0x00,f		; 20 03
	rrf	*0x1F,f		; 3F 03
 	rrf	*extreg,f	;*20n03

	rrf	0x00,0		; 00 03
	rrf	*0x00,0		; 00 03
	rrf	extreg,0	;*00n03
	rrf	*extreg,0	;*00n03
	rrf	0x00,#0		; 00 03
	rrf	*0x00,#0	; 00 03
	rrf	extreg,#0	;*00n03
	rrf	*extreg,#0	;*00n03
	rrf	0x00,wcode	; 00 03
	rrf	*0x00,wcode	; 00 03
	rrf	extreg,wcode	;*00n03
	rrf	*extreg,wcode	;*00n03
	rrf	0x00,#wcode	; 00 03
	rrf	*0x00,#wcode	; 00 03
	rrf	extreg,#wcode	;*00n03
	rrf	*extreg,#wcode	;*00n03

	rrf	0x00,1		; 20 03
	rrf	*0x00,1		; 20 03
	rrf	extreg,1	;*20n03
	rrf	*extreg,1	;*20n03
	rrf	0x00,#1		; 20 03
	rrf	*0x00,#1	; 20 03
	rrf	extreg,#1	;*20n03
	rrf	*extreg,#1	;*20n03
	rrf	0x00,fcode	; 20 03
	rrf	*0x00,fcode	; 20 03
	rrf	extreg,fcode	;*20n03
	rrf	*extreg,fcode	;*20n03
	rrf	0x00,#fcode	; 20 03
	rrf	*0x00,#fcode	; 20 03
	rrf	extreg,#fcode	;*20n03
	rrf	*extreg,#fcode	;*20n03

	rlf	0x00,w		; 40 03
	rlf	0x1F,w		; 5F 03
	rlf	extreg,w	;*40n03

	rlf	0x00,f		; 60 03
	rlf	0x1F,f		; 7F 03
	rlf	extreg,f	;*60n03

	rlf	*0x00,w		; 40 03
	rlf	*0x1F,w		; 5F 03
	rlf	*extreg,w	;*40n03

	rlf	*0x00,f		; 60 03
	rlf	*0x1F,f		; 7F 03
	rlf	*extreg,f	;*60n03

	rlf	0x00,0		; 40 03
	rlf	*0x00,0		; 40 03
	rlf	extreg,0	;*40n03
	rlf	*extreg,0	;*40n03
	rlf	0x00,#0		; 40 03
	rlf	*0x00,#0	; 40 03
	rlf	extreg,#0	;*40n03
	rlf	*extreg,#0	;*40n03
	rlf	0x00,wcode	; 40 03
	rlf	*0x00,wcode	; 40 03
	rlf	extreg,wcode	;*40n03
	rlf	*extreg,wcode	;*40n03
	rlf	0x00,#wcode	; 40 03
	rlf	*0x00,#wcode	; 40 03
	rlf	extreg,#wcode	;*40n03
	rlf	*extreg,#wcode	;*40n03

	rlf	0x00,1		; 60 03
	rlf	*0x00,1		; 60 03
	rlf	extreg,1	;*60n03
	rlf	*extreg,1	;*60n03
	rlf	0x00,#1		; 60 03
	rlf	*0x00,#1	; 60 03
	rlf	extreg,#1	;*60n03
	rlf	*extreg,#1	;*60n03
	rlf	0x00,fcode	; 60 03
	rlf	*0x00,fcode	; 60 03
	rlf	extreg,fcode	;*60n03
	rlf	*extreg,fcode	;*60n03
	rlf	0x00,#fcode	; 60 03
	rlf	*0x00,#fcode	; 60 03
	rlf	extreg,#fcode	;*60n03
	rlf	*extreg,#fcode	;*60n03

	swapf	0x00,w		; 80 03
	swapf	0x1F,w		; 9F 03
	swapf	extreg,w	;*80n03

	swapf	0x00,f		; A0 03
	swapf	0x1F,f		; BF 03
	swapf	extreg,f	;*A0n03

	swapf	*0x00,w		; 80 03
	swapf	*0x1F,w		; 9F 03
	swapf	*extreg,w	;*80n03


	swapf	*0x00,f		; A0 03
	swapf	*0x1F,f		; BF 03
	swapf	*extreg,f	;*A0n03

	swapf	0x00,0		; 80 03
	swapf	*0x00,0		; 80 03
	swapf	extreg,0	;*80n03
	swapf	*extreg,0	;*80n03
	swapf	0x00,#0		; 80 03
	swapf	*0x00,#0	; 80 03
	swapf	extreg,#0	;*80n03
	swapf	*extreg,#0	;*80n03
	swapf	0x00,wcode	; 80 03
	swapf	*0x00,wcode	; 80 03
	swapf	extreg,wcode	;*80n03
	swapf	*extreg,wcode	;*80n03
	swapf	0x00,#wcode	; 80 03
	swapf	*0x00,#wcode	; 80 03
	swapf	extreg,#wcode	;*80n03
	swapf	*extreg,#wcode	;*80n03

	swapf	0x00,1		; A0 03
	swapf	*0x00,1		; A0 03
	swapf	extreg,1	;*A0n03
	swapf	*extreg,1	;*A0n03
	swapf	0x00,#1		; A0 03
	swapf	*0x00,#1	; A0 03
	swapf	extreg,#1	;*A0n03
	swapf	*extreg,#1	;*A0n03
	swapf	0x00,fcode	; A0 03
	swapf	*0x00,fcode	; A0 03
	swapf	extreg,fcode	;*A0n03
	swapf	*extreg,fcode	;*A0n03
	swapf	0x00,#fcode	; A0 03
	swapf	*0x00,#fcode	; A0 03
	swapf	extreg,#fcode	;*A0n03
	swapf	*extreg,#fcode	;*A0n03

	incfsz	0x00,w		; C0 03
	incfsz	0x1F,w		; DF 03
	incfsz	extreg,w	;*C0n03

	incfsz	0x00,f		; E0 03
	incfsz	0x1F,f		; FF 03
	incfsz	extreg,f	;*E0n03

	incfsz	*0x00,w		; C0 03
	incfsz	*0x1F,w		; DF 03
	incfsz	*extreg,w	;*C0n03

	incfsz	*0x00,f		; E0 03
	incfsz	*0x1F,f		; FF 03
	incfsz	*extreg,f	;*E0n03

	incfsz	0x00,0		; C0 03
	incfsz	*0x00,0		; C0 03
	incfsz	extreg,0	;*C0n03
	incfsz	*extreg,0	;*C0n03
	incfsz	0x00,#0		; C0 03
	incfsz	*0x00,#0	; C0 03
	incfsz	extreg,#0	;*C0n03
	incfsz	*extreg,#0	;*C0n03
	incfsz	0x00,wcode	; C0 03
	incfsz	*0x00,wcode	; C0 03
	incfsz	extreg,wcode	;*C0n03
	incfsz	*extreg,wcode	;*C0n03
	incfsz	0x00,#wcode	; C0 03
	incfsz	*0x00,#wcode	; C0 03
	incfsz	extreg,#wcode	;*C0n03
	incfsz	*extreg,#wcode	;*C0n03

	incfsz	0x00,1		; E0 03
	incfsz	*0x00,1		; E0 03
	incfsz	extreg,1	;*E0n03
	incfsz	*extreg,1	;*E0n03
	incfsz	0x00,#1		; E0 03
	incfsz	*0x00,#1	; E0 03
	incfsz	extreg,#1	;*E0n03
	incfsz	*extreg,#1	;*E0n03
	incfsz	0x00,fcode	; E0 03
	incfsz	*0x00,fcode	; E0 03
	incfsz	extreg,fcode	;*E0n03
	incfsz	*extreg,fcode	;*E0n03
	incfsz	0x00,#fcode	; E0 03
	incfsz	*0x00,#fcode	; E0 03
	incfsz	extreg,#fcode	;*E0n03
	incfsz	*extreg,#fcode	;*E0n03

	bcf	0x00,0		; 00 04
	bcf	0x1F,0		; 1F 04
	bcf	extreg,0	;*00n04

	bcf	0x00,7		; E0 04
	bcf	0x1F,7		; FF 04
	bcf	extreg,7	;*E0n04

	bcf	*0x00,0		; 00 04
	bcf	*0x1F,0		; 1F 04
	bcf	*extreg,0	;*00n04

	bcf	*0x00,7		; E0 04
	bcf	*0x1F,7		; FF 04
	bcf	*extreg,7	;*E0n04

	bcf	0x00,num0	; 00 04
	bcf	*0x00,num0	; 00 04
	bcf	extreg,num0	;*00n04
	bcf	*extreg,num0	;*00n04
	bcf	0x00,#num0	; 00 04
	bcf	*0x00,#num0	; 00 04
	bcf	extreg,#num0	;*00n04
	bcf	*extreg,#num0	;*00n04
	bcf	0x00,num7	; E0 04
	bcf	*0x00,num7	; E0 04
	bcf	extreg,num7	;*E0n04
	bcf	*extreg,num7	;*E0n04
	bcf	0x00,#num7	; E0 04
	bcf	*0x00,#num7	; E0 04
	bcf	extreg,#num7	;*E0n04
	bcf	*extreg,#num7	;*E0n04

	bsf	0x00,0		; 00 05
	bsf	0x1F,0		; 1F 05
	bsf	extreg,0	;*00n05

	bsf	0x00,7		; E0 05
	bsf	0x1F,7		; FF 05
	bsf	extreg,7	;*E0n05

	bsf	*0x00,0		; 00 05
	bsf	*0x1F,0		; 1F 05
	bsf	*extreg,0	;*00n05

	bsf	*0x00,7		; E0 05
	bsf	*0x1F,7		; FF 05
 	bsf	*extreg,7	;*E0n05

	bsf	0x00,num0	; 00 05
	bsf	*0x00,num0	; 00 05
	bsf	extreg,num0	;*00n05
	bsf	*extreg,num0	;*00n05
	bsf	0x00,#num0	; 00 05
	bsf	*0x00,#num0	; 00 05
	bsf	extreg,#num0	;*00n05
	bsf	*extreg,#num0	;*00n05
	bsf	0x00,num7	; E0 05
	bsf	*0x00,num7	; E0 05
	bsf	extreg,num7	;*E0n05
	bsf	*extreg,num7	;*E0n05
	bsf	0x00,#num7	; E0 05
	bsf	*0x00,#num7	; E0 05
	bsf	extreg,#num7	;*E0n05
	bsf	*extreg,#num7	;*E0n05

	btfsc	0x00,0		; 00 06
	btfsc	0x1F,0		; 1F 06
	btfsc	extreg,0	;*00n06

	btfsc	0x00,7		; E0 06
	btfsc	0x1F,7		; FF 06
	btfsc	extreg,7	;*E0n06

	btfsc	*0x00,0		; 00 06
	btfsc	*0x1F,0		; 1F 06
	btfsc	*extreg,0	;*00n06

	btfsc	*0x00,7		; E0 06
	btfsc	*0x1F,7		; FF 06
	btfsc	*extreg,7	;*E0n06

	btfsc	0x00,num0	; 00 06
	btfsc	*0x00,num0	; 00 06
	btfsc	extreg,num0	;*00n06
	btfsc	*extreg,num0	;*00n06
	btfsc	0x00,#num0	; 00 06
	btfsc	*0x00,#num0	; 00 06
	btfsc	extreg,#num0	;*00n06
	btfsc	*extreg,#num0	;*00n06
	btfsc	0x00,num7	; E0 06
	btfsc	*0x00,num7	; E0 06
	btfsc	extreg,num7	;*E0n06
	btfsc	*extreg,num7	;*E0n06
	btfsc	0x00,#num7	; E0 06
	btfsc	*0x00,#num7	; E0 06
	btfsc	extreg,#num7	;*E0n06
	btfsc	*extreg,#num7	;*E0n06

	btfss	0x00,0		; 00 07
	btfss	0x1F,0		; 1F 07
	btfss	extreg,0	;*00n07

	btfss	0x00,7		; E0 07
	btfss	0x1F,7		; FF 07
	btfss	extreg,7	;*E0n07

	btfss	*0x00,0		; 00 07
	btfss	*0x1F,0		; 1F 07
	btfss	*extreg,0	;*00n07

	btfss	*0x00,7		; E0 07
	btfss	*0x1F,7		; FF 07
	btfss	*extreg,7	;*E0n07

	btfss	0x00,num0	; 00 07
	btfss	*0x00,num0	; 00 07
	btfss	extreg,num0	;*00n07
	btfss	*extreg,num0	;*00n07
	btfss	0x00,#num0	; 00 07
	btfss	*0x00,#num0	; 00 07
	btfss	extreg,#num0	;*00n07
	btfss	*extreg,#num0	;*00n07
	btfss	0x00,num7	; E0 07
	btfss	*0x00,num7	; E0 07
	btfss	extreg,num7	;*E0n07
	btfss	*extreg,num7	;*E0n07
	btfss	0x00,#num7	; E0 07
	btfss	*0x00,#num7	; E0 07
	btfss	extreg,#num7	;*E0n07
	btfss	*extreg,#num7	;*E0n07

	retlw	0x00		; 00 08
	retlw	0xFF		; FF 08
	retlw	extvalu		;r00s08

	retlw	#0x00		; 00 08
	retlw	#0xFF		; FF 08
	retlw	#extvalu	;r00s08

	call	0x00		; 00 09
	call	0xFF		; FF 09

	call	addr_00		;r00s09
	call	addr_FF		;rFFs09

	call	extaddr		;r00s09

	goto	0x00		; 00 0A
	goto	0x1FF		; FF 0B

	goto	addr_00		;r00s0A
	goto	addr_1FF	;rFFs0B

	goto	extaddr		;r00s0A

	movlw	0x00		; 00 0C
	movlw	0xFF		; FF 0C
	movlw	extvalu		;r00s0C

	movlw	#0x00		; 00 0C
	movlw	#0xFF		; FF 0C
	movlw	#extvalu	;r00s0C

	iorlw	0x00		; 00 0D
	iorlw	0xFF		; FF 0D
	iorlw	extvalu		;r00s0D

	iorlw	#0x00		; 00 0D
	iorlw	#0xFF		; FF 0D
	iorlw	#extvalu	;r00s0D

	andlw	0x00		; 00 0E
	andlw	0xFF		; FF 0E
	andlw	extvalu		;r00s0E

	andlw	#0x00		; 00 0E
	andlw	#0xFF		; FF 0E
	andlw	#extvalu	;r00s0E

	xorlw	0x00		; 00 0F
	xorlw	0xFF		; FF 0F
	xorlw	extvalu		;r00s0F

	xorlw	#0x00		; 00 0F
	xorlw	#0xFF		; FF 0F
	xorlw	#extvalu	;r00s0F


