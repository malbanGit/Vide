
;;; gcc for m6809 : Feb 15 2016 21:40:10
;;; 4.3.6 (gcc6809)
;;; ABI version 1
;;; -mint8
	.module	vec_rom_0xfc_0.c
;----- asm -----
	.bank page_fc (BASE=0xfc6d,SIZE=0x0100)
	.area .dpfc (OVR,BANK=page_fc)
	
;--- end asm ---
	.globl _Vec_Sine_Table
	.area	.dpfc
_Vec_Sine_Table:
	.word	0	;skip space 16
	.word	0	;skip space 14
	.word	0	;skip space 12
	.word	0	;skip space 10
	.word	0	;skip space 8
	.word	0	;skip space 6
	.word	0	;skip space 4
	.word	0	;skip space 2
	.globl _Vec_Cosine_Table
_Vec_Cosine_Table:
	.word	0	;skip space 16
	.word	0	;skip space 14
	.word	0	;skip space 12
	.word	0	;skip space 10
	.word	0	;skip space 8
	.word	0	;skip space 6
	.word	0	;skip space 4
	.word	0	;skip space 2
	.globl _Vec_Note_Table
_Vec_Note_Table:
	.byte	0	;skip space
