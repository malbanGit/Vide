
;;; gcc for m6809 : Feb 15 2016 21:40:10
;;; 4.3.6 (gcc6809)
;;; ABI version 1
;;; -mint8
	.module	vec_ram_dpd0_1.c
;----- asm -----
	.bank page_00 (BASE=0x0000,SIZE=0x0100)
	.area direct (OVR,BANK=page_00)
	
;--- end asm ---
	.globl _dp_VIA_port_b
	.area	direct
_dp_VIA_port_b:
	.word	0	;skip space 4
	.word	0	;skip space 2
	.globl _dp_VIA_t1_cnt
_dp_VIA_t1_cnt:
	.word	0	;skip space 2
	.globl _dp_VIA_t1_lch
_dp_VIA_t1_lch:
	.word	0	;skip space 2
	.globl _dp_VIA_t2
_dp_VIA_t2:
	.word	0	;skip space 2
