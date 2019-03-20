	.title	6500 Assembler Error Test

	dir	=	0x0033
	ext	=	0x1122
	offset	=	0x0044
	
	.globl	extext
	.globl	extdir

;
; All documented 65C02 instructions with proper AS6500 syntax
;
; The instructions that run only on 65C02 are marked with `*'.

;
 	; Set Default Radix
	.radix x

	; Enable 65C02 Instructions
	.r65c02

begin::

	; S_DOP
adc *ext	;d 65 22
		; ---
adc *ext,x	;d 75 22
		; ---
adc [*ext,x]	;d 61 22
		; ---
adc [*ext],y	;d 71 22
		; ---
adc [*ext]	;  65 00	*
adc [ext]	;  65 00	*

	; S_SOP
asl *ext	;d 06 22
		; ---
asl *ext,x	;d 16 22
		; ---
	; S_BB
bbr0 [dir],.    ;q		*

	; S_BIT
bit *ext	;d 24 22
		; ---
bit *ext,x	;d 24 00	*

	; S_CP
cpx *ext	;d E4 22

	; S_JMP
jmp offset,x	;a 4C 00 00
jmp offset,y	;a 4C 00 00
jmp [offset],y	;a 4C 00 00

	; S_JSR
jsr offset,x	;a 20 44 00
jsr offset,y	;a 20 44 00
jsr [offset,x]	;a 20 44 00
jsr [offset],y	;a 20 44 00

	; S_LDSTX / S_LDSTY
ldx [offset,x]	;a a6 00
ldx [offset],y	;a A6 00
ldx *ext	;d A6 22
sta #12		;a 89 12

	; S_STZ
stz *ext	;d 		*
stz [offset,x]	;a
stz offset,y	;a
stz [offset],y	;a
stz *extdir	;		*

	; S_TB
trb offset,x	;a
trb offset,y	;a
trb [offset,x]	;a
trb [offset],y	;a
