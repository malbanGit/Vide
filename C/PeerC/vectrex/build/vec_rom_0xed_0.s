
;;; gcc for m6809 : Feb 15 2016 21:40:10
;;; 4.3.6 (gcc6809)
;;; ABI version 1
;;; -mint8
	.module	vec_rom_0xed_0.c
;----- asm -----
	.bank page_ed (BASE=0xed77,SIZE=0x0100)
	.area .dped (OVR,BANK=page_ed)
	
;--- end asm ---
	.globl _Vec_Music_0
	.area	.dped
_Vec_Music_0:
	.word	0	;skip space 24
	.word	0	;skip space 22
	.word	0	;skip space 20
	.word	0	;skip space 18
	.word	0	;skip space 16
	.word	0	;skip space 14
	.word	0	;skip space 12
	.word	0	;skip space 10
	.word	0	;skip space 8
	.word	0	;skip space 6
	.word	0	;skip space 4
	.word	0	;skip space 2
	.globl _Vec_ADSR_FADE66
_Vec_ADSR_FADE66:
	.byte	0	;skip space
