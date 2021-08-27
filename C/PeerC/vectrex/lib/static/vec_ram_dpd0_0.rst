                              1 ;;; gcc for m6809 : Mar 17 2019 13:25:32
                              2 ;;; 4.3.6 (gcc6809)
                              3 ;;; ABI version 1
                              4 ;;; -mabi=bx -mint8 -fomit-frame-pointer -O0
                              5 	.module	vec_ram_dpd0_0.c
                              6 ;----- asm -----
                              7 	.bank page_00 (BASE=0x0000,SIZE=0x0100)
                              8 	.area .direct (OVR,BANK=page_00)
                              9 	
                             10 ;--- end asm ---
                             11 	.globl	_dp_VIA_port_b
                             12 	.area	.direct
   0000                      13 _dp_VIA_port_b:
   0000 00                   14 	.byte	0
                             15 	.globl	_dp_VIA_port_a
   0001                      16 _dp_VIA_port_a:
   0001 00                   17 	.byte	0
                             18 	.globl	_dp_VIA_DDR_b
   0002                      19 _dp_VIA_DDR_b:
   0002 00                   20 	.byte	0
                             21 	.globl	_dp_VIA_DDR_a
   0003                      22 _dp_VIA_DDR_a:
   0003 00                   23 	.byte	0
                             24 	.globl	_dp_VIA_t1_cnt_lo
   0004                      25 _dp_VIA_t1_cnt_lo:
   0004 00                   26 	.byte	0
                             27 	.globl	_dp_VIA_t1_cnt_hi
   0005                      28 _dp_VIA_t1_cnt_hi:
   0005 00                   29 	.byte	0
                             30 	.globl	_dp_VIA_t1_lch_lo
   0006                      31 _dp_VIA_t1_lch_lo:
   0006 00                   32 	.byte	0
                             33 	.globl	_dp_VIA_t1_lch_hi
   0007                      34 _dp_VIA_t1_lch_hi:
   0007 00                   35 	.byte	0
                             36 	.globl	_dp_VIA_t2_lo
   0008                      37 _dp_VIA_t2_lo:
   0008 00                   38 	.byte	0
                             39 	.globl	_dp_VIA_t2_hi
   0009                      40 _dp_VIA_t2_hi:
   0009 00                   41 	.byte	0
                             42 	.globl	_dp_VIA_shift_reg
   000A                      43 _dp_VIA_shift_reg:
   000A 00                   44 	.byte	0
                             45 	.globl	_dp_VIA_aux_cntl
   000B                      46 _dp_VIA_aux_cntl:
   000B 00                   47 	.byte	0
                             48 	.globl	_dp_VIA_cntl
   000C                      49 _dp_VIA_cntl:
   000C 00                   50 	.byte	0
                             51 	.globl	_dp_VIA_int_flags
   000D                      52 _dp_VIA_int_flags:
   000D 00                   53 	.byte	0
                             54 	.globl	_dp_VIA_int_enable
   000E                      55 _dp_VIA_int_enable:
   000E 00                   56 	.byte	0
                             57 	.globl	_dp_VIA_port_a_nohs
   000F                      58 _dp_VIA_port_a_nohs:
   000F 00                   59 	.byte	0
ASxxxx Assembler V05.31  (Motorola 6809)                                Page 1
Hexadecimal [16-Bits]                                 Thu Jan 30 13:14:28 2020

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

ASxxxx Assembler V05.31  (Motorola 6809)                                Page 2
Hexadecimal [16-Bits]                                 Thu Jan 30 13:14:28 2020

Area Table

[_CSEG]
   0 _CODE            size    0   flags C080
[_DSEG]
   1 _DATA            size    0   flags C0C0
[page_00]
   2 .direct          size   10   flags 8584

