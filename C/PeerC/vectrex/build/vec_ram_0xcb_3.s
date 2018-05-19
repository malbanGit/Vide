
;;; gcc for m6809 : Feb 15 2016 21:40:10
;;; 4.3.6 (gcc6809)
;;; ABI version 1
;;; -mint8
	.module	vec_ram_0xcb_3.c
;----- asm -----
	.bank page_cb (BASE=0xcbea,SIZE=0x0100)
	.area .dpcb (OVR,BANK=page_cb)
	
;--- end asm ---
	.globl _Vec_Default_Stk
	.area	.dpcb
_Vec_Default_Stk:
	.word	0	;skip space 8
	.word	0	;skip space 6
	.word	0	;skip space 4
	.word	0	;skip space 2
	.globl _Vec_SWI2_vector
_Vec_SWI2_vector:
	.word	0	;skip space 9
	.word	0	;skip space 7
	.word	0	;skip space 5
	.word	0	;skip space 3
	.byte	0	;skip space
	.globl _Vec_NWI_vector
_Vec_NWI_vector:
	.word	0	;skip space 3
	.byte	0	;skip space
