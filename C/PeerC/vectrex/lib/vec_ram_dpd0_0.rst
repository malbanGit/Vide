                              1 
                              2 ;;; gcc for m6809 : Feb 15 2016 21:40:10
                              3 ;;; 4.3.6 (gcc6809)
                              4 ;;; ABI version 1
                              5 ;;; -mint8
                              6 	.module	vec_ram_dpd0_0.c
                              7 ;----- asm -----
                              8 	.bank page_00 (BASE=0x0000,SIZE=0x0100)
                              9 	.area direct (OVR,BANK=page_00)
                             10 	
                             11 ;--- end asm ---
                             12 	.globl _dp_VIA_port_b
                             13 	.area	direct
   0000                      14 _dp_VIA_port_b:
   0000 00                   15 	.byte	0	;skip space
                             16 	.globl _dp_VIA_port_a
   0001                      17 _dp_VIA_port_a:
   0001 00                   18 	.byte	0	;skip space
                             19 	.globl _dp_VIA_DDR_b
   0002                      20 _dp_VIA_DDR_b:
   0002 00                   21 	.byte	0	;skip space
                             22 	.globl _dp_VIA_DDR_a
   0003                      23 _dp_VIA_DDR_a:
   0003 00                   24 	.byte	0	;skip space
                             25 	.globl _dp_VIA_t1_cnt_lo
   0004                      26 _dp_VIA_t1_cnt_lo:
   0004 00                   27 	.byte	0	;skip space
                             28 	.globl _dp_VIA_t1_cnt_hi
   0005                      29 _dp_VIA_t1_cnt_hi:
   0005 00                   30 	.byte	0	;skip space
                             31 	.globl _dp_VIA_t1_lch_lo
   0006                      32 _dp_VIA_t1_lch_lo:
   0006 00                   33 	.byte	0	;skip space
                             34 	.globl _dp_VIA_t1_lch_hi
   0007                      35 _dp_VIA_t1_lch_hi:
   0007 00                   36 	.byte	0	;skip space
                             37 	.globl _dp_VIA_t2_lo
   0008                      38 _dp_VIA_t2_lo:
   0008 00                   39 	.byte	0	;skip space
                             40 	.globl _dp_VIA_t2_hi
   0009                      41 _dp_VIA_t2_hi:
   0009 00                   42 	.byte	0	;skip space
                             43 	.globl _dp_VIA_shift_reg
   000A                      44 _dp_VIA_shift_reg:
   000A 00                   45 	.byte	0	;skip space
                             46 	.globl _dp_VIA_aux_cntl
   000B                      47 _dp_VIA_aux_cntl:
   000B 00                   48 	.byte	0	;skip space
                             49 	.globl _dp_VIA_cntl
   000C                      50 _dp_VIA_cntl:
   000C 00                   51 	.byte	0	;skip space
                             52 	.globl _dp_VIA_int_flags
   000D                      53 _dp_VIA_int_flags:
   000D 00                   54 	.byte	0	;skip space
                             55 	.globl _dp_VIA_int_enable
   000E                      56 _dp_VIA_int_enable:
   000E 00                   57 	.byte	0	;skip space
                             58 	.globl _dp_VIA_port_a_nohs
   000F                      59 _dp_VIA_port_a_nohs:
   000F 00                   60 	.byte	0	;skip space
ASxxxx Assembler V05.00  (Motorola 6809), page 1.
Hexidecimal [16-Bits]

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
  2 _dp_VIA_DDR_a      0003 GR  |   2 _dp_VIA_DDR_b      0002 GR
  2 _dp_VIA_aux_cn     000B GR  |   2 _dp_VIA_cntl       000C GR
  2 _dp_VIA_int_en     000E GR  |   2 _dp_VIA_int_fl     000D GR
  2 _dp_VIA_port_a     0001 GR  |   2 _dp_VIA_port_a     000F GR
  2 _dp_VIA_port_b     0000 GR  |   2 _dp_VIA_shift_     000A GR
  2 _dp_VIA_t1_cnt     0005 GR  |   2 _dp_VIA_t1_cnt     0004 GR
  2 _dp_VIA_t1_lch     0007 GR  |   2 _dp_VIA_t1_lch     0006 GR
  2 _dp_VIA_t2_hi      0009 GR  |   2 _dp_VIA_t2_lo      0008 GR

ASxxxx Assembler V05.00  (Motorola 6809), page 2.
Hexidecimal [16-Bits]

Area Table

[_CSEG]
   0 _CODE            size    0   flags C080
[_DSEG]
   1 _DATA            size    0   flags C0C0
[page_00]
   2 direct           size   10   flags 8584

