	.title	AScheck Tests

	.sbttl	MSB Checks

	.area	TCHK

	tchk == 0x44332211

a_tchk:	.byte	>tchk

	.msb	0
1$:	.byte	>tchk

	.msb	1
2$:	.byte	>tchk

	.msb	2
3$:	.byte	>tchk

	.msb	3
4$:	.byte	>tchk


	.area	XTRN

	.msb	1

a_xtrn:	.byte	>xtrn

	.msb	0
1$:	.byte	>xtrn

	.msb	1
2$:	.byte	>xtrn

	.msb	2
3$:	.byte	>xtrn

	.msb	3
4$:	.byte	>xtrn


	.page
	.sbttl	Define Checks

	.define		..ret,		"255$"
	.define		..tmp,		"10$"

a_lcl:

..tmp:
	.word	..ret
	.word	..tmp
..ret:

b_lcl:

	.page
	.sbttl	Bank Size Checks

;	*****-----*****-----*****-----*****-----*****-----*****

	.bank	CodeBank1	(base = 0x0000, size = 0x1000, fsfx = _CB1)

	.area	Area1	(rel,con,cseg,bank = CodeBank1)

	.word	0x0201

	.area	Area2	(rel,con,dseg,bank = CodeBank1)

	. = . + 0x0FFC

	.byte	0x03, 0x04, 0x05		; byte 0x05 is past bank size boundary

;	*****-----*****-----*****-----*****-----*****-----*****

	.bank	CodeBank2	(base = 0x0000, size = 0x1000, fsfx = _CB2)

	.area	Area3	(rel,con,cseg,bank = CodeBank2)

	.word	0x0201

	.area	Area4	(rel,con,dseg,bank = CodeBank2)

	. = . + 0x0FFB

	.byte	0x03, 0x04, 0x05		; byte 0x05 is just before bank size boundary

;	*****-----*****-----*****-----*****-----*****-----*****

	.bank	CodeBank3	(base = 0x3000, size = 0x1000, fsfx = _CB3)

	.area	Area5	(rel,con,cseg,bank = CodeBank3)

	.word	0x0201

	.area	Area6	(rel,con,dseg,bank = CodeBank3)

	. = . + 0x0FFC

	.byte	0x03, 0x04, 0x05		; byte 0x05 is past bank size boundary

;	*****-----*****-----*****-----*****-----*****-----*****

	.bank	CodeBank4	(base = 0x3000, size = 0x1000, fsfx = _CB4)

	.area	Area7	(rel,con,cseg,bank = CodeBank4)

	.word	0x0201

	.area	Area8	(rel,con,dseg,bank = CodeBank4)

	. = . + 0x0FFB

	.byte	0x03, 0x04, 0x05		; byte 0x05 is just before bank size boundary

;	*****-----*****-----*****-----*****-----*****-----*****
;	-b Area9=0x5000
;	*****-----*****-----*****-----*****-----*****-----*****

	.bank	CodeBank5	(base = 0x3000, size = 0x1000, fsfx = _CB5)

	.area	Area9	(rel,con,cseg,bank = CodeBank5)

	.word	0x0201

	.area	Area10	(rel,con,dseg,bank = CodeBank5)

	. = . + 0x0FFC

	.byte	0x03, 0x04, 0x05		; byte 0x05 is past bank size boundary

;	*****-----*****-----*****-----*****-----*****-----*****
;	-b Area11=0x5000
;	*****-----*****-----*****-----*****-----*****-----*****

	.bank	CodeBank6	(base = 0x3000, size = 0x1000, fsfx = _CB6)

	.area	Area11	(rel,con,cseg,bank = CodeBank6)

	.word	0x0201

	.area	Area12	(rel,con,dseg,bank = CodeBank6)

	. = . + 0x0FFB

	.byte	0x03, 0x04, 0x05		; byte 0x05 is just before bank size boundary


