
;;; gcc for m6809 : Feb 15 2016 21:40:10
;;; 4.3.6 (gcc6809)
;;; ABI version 1
;;; -mint8
	.module	vec_ram_dpd0_0.c
;----- asm -----
	.bank page_00 (BASE=0x0000,SIZE=0x0100)
	.area direct (OVR,BANK=page_00)
	
;--- end asm ---
	.globl _dp_VIA_port_b
	.area	direct
_dp_VIA_port_b:
	.byte	0	;skip space
	.globl _dp_VIA_port_a
_dp_VIA_port_a:
	.byte	0	;skip space
	.globl _dp_VIA_DDR_b
_dp_VIA_DDR_b:
	.byte	0	;skip space
	.globl _dp_VIA_DDR_a
_dp_VIA_DDR_a:
	.byte	0	;skip space
	.globl _dp_VIA_t1_cnt_lo
_dp_VIA_t1_cnt_lo:
	.byte	0	;skip space
	.globl _dp_VIA_t1_cnt_hi
_dp_VIA_t1_cnt_hi:
	.byte	0	;skip space
	.globl _dp_VIA_t1_lch_lo
_dp_VIA_t1_lch_lo:
	.byte	0	;skip space
	.globl _dp_VIA_t1_lch_hi
_dp_VIA_t1_lch_hi:
	.byte	0	;skip space
	.globl _dp_VIA_t2_lo
_dp_VIA_t2_lo:
	.byte	0	;skip space
	.globl _dp_VIA_t2_hi
_dp_VIA_t2_hi:
	.byte	0	;skip space
	.globl _dp_VIA_shift_reg
_dp_VIA_shift_reg:
	.byte	0	;skip space
	.globl _dp_VIA_aux_cntl
_dp_VIA_aux_cntl:
	.byte	0	;skip space
	.globl _dp_VIA_cntl
_dp_VIA_cntl:
	.byte	0	;skip space
	.globl _dp_VIA_int_flags
_dp_VIA_int_flags:
	.byte	0	;skip space
	.globl _dp_VIA_int_enable
_dp_VIA_int_enable:
	.byte	0	;skip space
	.globl _dp_VIA_port_a_nohs
_dp_VIA_port_a_nohs:
	.byte	0	;skip space
