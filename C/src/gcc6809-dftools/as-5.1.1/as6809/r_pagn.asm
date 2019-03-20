	.title	R_PAGN Diagnostic (AS6809 Specific)

	; Notes:
	;	Compile:	as6809 -gloaxff r_pagn
	;
	;			r_pagn.asm should compile with no errors
	;
	;
	;	Link:		aslink -xmus r_pagn
	;
	;			linking r_pagn will give PAGN errors for
	;	   		lines having labels of er____


	.sbttl	DATA Space

	.area	DATA (DSEG)
	; Area 'DATA' will be placed at 0x1000 by the linker -b DATA=0x1000 option.
	; Symbol 'DATA' will be set  to 0x1000 by the linker -g DATA=0x1000 option.

pg0:					; First 256 byte Data Page
pg0_00:	.blkb	1			; relocatable label
pg0_01 = .				; relocatable symbol
	.blkb	0x0100 - (. - pg0)

;	pg0_05 = DATA + 0x0005		; external symbol + a constant (illegal construct)
.define	pg0_05, "DATA + 0x0005"		; define pg0_05
	pg0_06 = 0x1006			; constant symbol within Page 0 of DATA

pg1:					; Second 256 byte Data Page
pg1_00:	.blkb	1			; relocatable label
pg1_01 = .				; relocatable symbol
	.blkb	0x0100 - (. -pg1)

;	pg1_05 = DATA + 0x0105		; external symbol + a constant (illegal construct)
.define	pg1_05, "DATA + 0x0105"		; define pg1_05
	pg1_06 = 0x1106			; constant symbol within Page 1 of DATA

pgend:	.assume	(pgend - pg0) & 0x00FF	; Page Boundary Error


	.sbttl	CODE Space

	.area	CODE (CSEG)
	; Area 'CODE' will be placed at 0x1200 by the linker -b CODE=0x1200 option.
	; Symbol 'CODE' will be set  to 0x1200 by the linker -g CODE=0x1200 option.

	code = .			; Base Address of CODE Segment

code00:	.blkb	1			; relocatable label
code01 = .				; relocatable symbol

;	code05 = CODE + 0x0005		; external symbol + a constant (illegal construct)
.define	code05, "CODE + 0x0005"		; define code05
	code06 = 0x1206			; constant symbol within Page 1 of CODE

	.setdp	0x0000,DATA	; Direct Page: area = DATA, offset address = 0x0000

	; Direct Page with constants
	adcb	*0x0000		; d9*00
	adcb	*0x0001		; d9*01
	adcb	*0x0005		; d9*05
	adcb	*0x0006		; d9*06

er_01:	adcb	*0x0100		; d9*00
er_02:	adcb	*0x0101		; d9*01
er_03:	adcb	*0x0105		; d9*05
er_04:	adcb	*0x0106		; d9*06

er_05:	adcb	*0x0200		; d9*00
er_06:	adcb	*0x0201		; d9*01
er_07:	adcb	*0x0205		; d9*05
er_08:	adcb	*0x0206		; d9*06

	; Direct Page with labels and symbols
	adcb	*pg0_00		; d9*00
	adcb	*pg0_01		; d9*01
	adcb	*pg0_05		; d9*05
	adcb	*pg0_06		; d9*06

er_09:	adcb	*pg1_00		; d9*00
er_10:	adcb	*pg1_01		; d9*01
er_11:	adcb	*pg1_05		; d9*05
er_12:	adcb	*pg1_06		; d9*06

er_13:	adcb	*code00		; d9*00
er_14:	adcb	*code01		; d9*01
er_15:	adcb	*code05		; d9*05
er_16:	adcb	*code06		; d9*06

	.setdp	0x0100,DATA	; Direct Page: area = DATA, offset address = 0x0100

	; Direct Page with constants
er_17:	adcb	*0x0000		; d9*00
er_18:	adcb	*0x0001		; d9*01
er_19:	adcb	*0x0005		; d9*05
er_20:	adcb	*0x0006		; d9*06

	adcb	*0x0100		; d9*00
	adcb	*0x0101		; d9*01
	adcb	*0x0105		; d9*05
	adcb	*0x0106		; d9*06

er_21:	adcb	*0x0200		; d9*00
er_22:	adcb	*0x0201		; d9*01
er_23:	adcb	*0x0205		; d9*05
er_24:	adcb	*0x0206		; d9*06

	; Direct Page with labels and symbols
er_25:	adcb	*pg0_00		; d9*00
er_26:	adcb	*pg0_01		; d9*01
er_27:	adcb	*pg0_05		; d9*05
er_28:	adcb	*pg0_06		; d9*06

	adcb	*pg1_00		; d9*00
	adcb	*pg1_01		; d9*01
	adcb	*pg1_05		; d9*05
	adcb	*pg1_06		; d9*06

er_29:	adcb	*code00		; d9*00
er_30:	adcb	*code01		; d9*01
er_31:	adcb	*code05		; d9*05
er_32:	adcb	*code06		; d9*06

	.setdp	0x0200,DATA	; Direct Page: area = DATA, offset address = 0x0200
				; Linker automatically places area CODE after
				; the area DATA starting at 0x0200.  Order of
				; .area directives determines linking order
				; unless overridden by .bank directives.

	; Direct Page with constants
er_33:	adcb	*0x0000		; d9*00
er_34:	adcb	*0x0001		; d9*01
er_35:	adcb	*0x0005		; d9*05
er_36:	adcb	*0x0006		; d9*06

er_37:	adcb	*0x0100		; d9*00
er_38:	adcb	*0x0101		; d9*01
er_39:	adcb	*0x0105		; d9*05
er_40:	adcb	*0x0106		; d9*06

	adcb	*0x0200		; d9*00
	adcb	*0x0201		; d9*01
	adcb	*0x0205		; d9*05
	adcb	*0x0206		; d9*06

	; Direct Page with labels and symbols
er_41:	adcb	*pg0_00		; d9*00
er_42:	adcb	*pg0_01		; d9*01
er_43:	adcb	*pg0_05		; d9*05
er_44:	adcb	*pg0_06		; d9*06

er_45:	adcb	*pg1_00		; d9*00
er_46:	adcb	*pg1_01		; d9*01
er_47:	adcb	*pg1_05		; d9*05
er_48:	adcb	*pg1_06		; d9*06

	adcb	*code00		; d9*00
	adcb	*code01		; d9*01
	adcb	*code05		; d9*05
	adcb	*code06		; d9*06


	.end

