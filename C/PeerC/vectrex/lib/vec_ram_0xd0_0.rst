                              1 
                              2 ;;; gcc for m6809 : Feb 15 2016 21:40:10
                              3 ;;; 4.3.6 (gcc6809)
                              4 ;;; ABI version 1
                              5 ;;; -mint8
                              6 	.module	vec_ram_0xd0_0.c
                              7 ;----- asm -----
                              8 	.bank page_d0 (BASE=0xd000,SIZE=0x0100)
                              9 	.area .dpd0 (OVR,BANK=page_d0)
                             10 	
                             11 ;--- end asm ---
                             12 	.globl _VIA_port_b
                             13 	.area	.dpd0
   D000                      14 _VIA_port_b:
   D000 00                   15 	.byte	0	;skip space
                             16 	.globl _VIA_port_a
   D001                      17 _VIA_port_a:
   D001 00                   18 	.byte	0	;skip space
                             19 	.globl _VIA_DDR_b
   D002                      20 _VIA_DDR_b:
   D002 00                   21 	.byte	0	;skip space
                             22 	.globl _VIA_DDR_a
   D003                      23 _VIA_DDR_a:
   D003 00                   24 	.byte	0	;skip space
                             25 	.globl _VIA_t1_cnt_lo
   D004                      26 _VIA_t1_cnt_lo:
   D004 00                   27 	.byte	0	;skip space
                             28 	.globl _VIA_t1_cnt_hi
   D005                      29 _VIA_t1_cnt_hi:
   D005 00                   30 	.byte	0	;skip space
                             31 	.globl _VIA_t1_lch_lo
   D006                      32 _VIA_t1_lch_lo:
   D006 00                   33 	.byte	0	;skip space
                             34 	.globl _VIA_t1_lch_hi
   D007                      35 _VIA_t1_lch_hi:
   D007 00                   36 	.byte	0	;skip space
                             37 	.globl _VIA_t2_lo
   D008                      38 _VIA_t2_lo:
   D008 00                   39 	.byte	0	;skip space
                             40 	.globl _VIA_t2_hi
   D009                      41 _VIA_t2_hi:
   D009 00                   42 	.byte	0	;skip space
                             43 	.globl _VIA_shift_reg
   D00A                      44 _VIA_shift_reg:
   D00A 00                   45 	.byte	0	;skip space
                             46 	.globl _VIA_aux_cntl
   D00B                      47 _VIA_aux_cntl:
   D00B 00                   48 	.byte	0	;skip space
                             49 	.globl _VIA_cntl
   D00C                      50 _VIA_cntl:
   D00C 00                   51 	.byte	0	;skip space
                             52 	.globl _VIA_int_flags
   D00D                      53 _VIA_int_flags:
   D00D 00                   54 	.byte	0	;skip space
                             55 	.globl _VIA_int_enable
   D00E                      56 _VIA_int_enable:
   D00E 00                   57 	.byte	0	;skip space
                             58 	.globl _VIA_port_a_nohs
   D00F                      59 _VIA_port_a_nohs:
   D00F 00                   60 	.byte	0	;skip space
ASxxxx Assembler V05.00  (Motorola 6809), page 1.
Hexidecimal [16-Bits]

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
  2 _VIA_DDR_a         0003 GR  |   2 _VIA_DDR_b         0002 GR
  2 _VIA_aux_cntl      000B GR  |   2 _VIA_cntl          000C GR
  2 _VIA_int_enabl     000E GR  |   2 _VIA_int_flags     000D GR
  2 _VIA_port_a        0001 GR  |   2 _VIA_port_a_no     000F GR
  2 _VIA_port_b        0000 GR  |   2 _VIA_shift_reg     000A GR
  2 _VIA_t1_cnt_hi     0005 GR  |   2 _VIA_t1_cnt_lo     0004 GR
  2 _VIA_t1_lch_hi     0007 GR  |   2 _VIA_t1_lch_lo     0006 GR
  2 _VIA_t2_hi         0009 GR  |   2 _VIA_t2_lo         0008 GR

ASxxxx Assembler V05.00  (Motorola 6809), page 2.
Hexidecimal [16-Bits]

Area Table

[_CSEG]
   0 _CODE            size    0   flags C080
[_DSEG]
   1 _DATA            size    0   flags C0C0
[page_d0]
   2 .dpd0            size   10   flags 8584

