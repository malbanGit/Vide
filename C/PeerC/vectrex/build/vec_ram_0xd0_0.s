
;;; gcc for m6809 : Feb 15 2016 21:40:10
;;; 4.3.6 (gcc6809)
;;; ABI version 1
;;; -mint8
	.module	vec_ram_0xd0_0.c
;----- asm -----
	.bank page_d0 (BASE=0xd000,SIZE=0x0100)
	.area .dpd0 (OVR,BANK=page_d0)
	
;--- end asm ---
	.globl _VIA_port_b
	.area	.dpd0
_VIA_port_b:
	.byte	0	;skip space
	.globl _VIA_port_a
_VIA_port_a:
	.byte	0	;skip space
	.globl _VIA_DDR_b
_VIA_DDR_b:
	.byte	0	;skip space
	.globl _VIA_DDR_a
_VIA_DDR_a:
	.byte	0	;skip space
	.globl _VIA_t1_cnt_lo
_VIA_t1_cnt_lo:
	.byte	0	;skip space
	.globl _VIA_t1_cnt_hi
_VIA_t1_cnt_hi:
	.byte	0	;skip space
	.globl _VIA_t1_lch_lo
_VIA_t1_lch_lo:
	.byte	0	;skip space
	.globl _VIA_t1_lch_hi
_VIA_t1_lch_hi:
	.byte	0	;skip space
	.globl _VIA_t2_lo
_VIA_t2_lo:
	.byte	0	;skip space
	.globl _VIA_t2_hi
_VIA_t2_hi:
	.byte	0	;skip space
	.globl _VIA_shift_reg
_VIA_shift_reg:
	.byte	0	;skip space
	.globl _VIA_aux_cntl
_VIA_aux_cntl:
	.byte	0	;skip space
	.globl _VIA_cntl
_VIA_cntl:
	.byte	0	;skip space
	.globl _VIA_int_flags
_VIA_int_flags:
	.byte	0	;skip space
	.globl _VIA_int_enable
_VIA_int_enable:
	.byte	0	;skip space
	.globl _VIA_port_a_nohs
_VIA_port_a_nohs:
	.byte	0	;skip space
