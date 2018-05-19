
;;; gcc for m6809 : Feb 15 2016 21:40:10
;;; 4.3.6 (gcc6809)
;;; ABI version 1
;;; -mint8
	.module	vec_ram_0xd0_1.c
;----- asm -----
	.bank page_d0 (BASE=0xd000,SIZE=0x0100)
	.area .dpd0 (OVR,BANK=page_d0)
	
;--- end asm ---
	.globl _VIA_port_b
	.area	.dpd0
_VIA_port_b:
	.word	0	;skip space 4
	.word	0	;skip space 2
	.globl _VIA_t1_cnt
_VIA_t1_cnt:
	.word	0	;skip space 2
	.globl _VIA_t1_lch
_VIA_t1_lch:
	.word	0	;skip space 2
	.globl _VIA_t2
_VIA_t2:
	.word	0	;skip space 2
