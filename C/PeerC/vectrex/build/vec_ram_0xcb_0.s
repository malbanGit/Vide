
;;; gcc for m6809 : Feb 15 2016 21:40:10
;;; 4.3.6 (gcc6809)
;;; ABI version 1
;;; -mint8
	.module	vec_ram_0xcb_0.c
;----- asm -----
	.bank page_cb (BASE=0xcbea,SIZE=0x0100)
	.area .dpcb (OVR,BANK=page_cb)
	
;--- end asm ---
	.globl _Vec_Default_Stk
	.area	.dpcb
_Vec_Default_Stk:
	.byte	0	;skip space
	.globl _Vec_High_Score
_Vec_High_Score:
	.word	0	;skip space 7
	.word	0	;skip space 5
	.word	0	;skip space 3
	.byte	0	;skip space
	.globl _Vec_SWI3_Vector
_Vec_SWI3_Vector:
	.word	0	;skip space 3
	.byte	0	;skip space
	.globl _Vec_FIRQ_Vector
_Vec_FIRQ_Vector:
	.word	0	;skip space 3
	.byte	0	;skip space
	.globl _Vec_IRQ_Vector
_Vec_IRQ_Vector:
	.word	0	;skip space 3
	.byte	0	;skip space
	.globl _Vec_SWI_Vector
_Vec_SWI_Vector:
	.word	0	;skip space 3
	.byte	0	;skip space
	.globl _Vec_Cold_Flag
_Vec_Cold_Flag:
	.word	0	;skip space 2
