                              1 ;;; gcc for m6809 : Mar 11 2019 13:34:05
                              2 ;;; 4.3.6 (gcc6809)
                              3 ;;; ABI version 1
                              4 ;;; -mabi=bx -mint8 -fomit-frame-pointer -O2
                              5 	.module	vec_ram_0xd0_0.c
                              6 ;----- asm -----
                              7 	.bank page_d0 (BASE=0xd000,SIZE=0x0100)
                              8 	.area .dpd0 (OVR,BANK=page_d0)
                              9 	
                             10 ;--- end asm ---
                             11 	.globl	_VIA_port_b
                             12 	.area	.dpd0
   D000                      13 _VIA_port_b:
   D000 00                   14 	.byte	0
                             15 	.globl	_VIA_port_a
   D001                      16 _VIA_port_a:
   D001 00                   17 	.byte	0
                             18 	.globl	_VIA_DDR_b
   D002                      19 _VIA_DDR_b:
   D002 00                   20 	.byte	0
                             21 	.globl	_VIA_DDR_a
   D003                      22 _VIA_DDR_a:
   D003 00                   23 	.byte	0
                             24 	.globl	_VIA_t1_cnt_lo
   D004                      25 _VIA_t1_cnt_lo:
   D004 00                   26 	.byte	0
                             27 	.globl	_VIA_t1_cnt_hi
   D005                      28 _VIA_t1_cnt_hi:
   D005 00                   29 	.byte	0
                             30 	.globl	_VIA_t1_lch_lo
   D006                      31 _VIA_t1_lch_lo:
   D006 00                   32 	.byte	0
                             33 	.globl	_VIA_t1_lch_hi
   D007                      34 _VIA_t1_lch_hi:
   D007 00                   35 	.byte	0
                             36 	.globl	_VIA_t2_lo
   D008                      37 _VIA_t2_lo:
   D008 00                   38 	.byte	0
                             39 	.globl	_VIA_t2_hi
   D009                      40 _VIA_t2_hi:
   D009 00                   41 	.byte	0
                             42 	.globl	_VIA_shift_reg
   D00A                      43 _VIA_shift_reg:
   D00A 00                   44 	.byte	0
                             45 	.globl	_VIA_aux_cntl
   D00B                      46 _VIA_aux_cntl:
   D00B 00                   47 	.byte	0
                             48 	.globl	_VIA_cntl
   D00C                      49 _VIA_cntl:
   D00C 00                   50 	.byte	0
                             51 	.globl	_VIA_int_flags
   D00D                      52 _VIA_int_flags:
   D00D 00                   53 	.byte	0
                             54 	.globl	_VIA_int_enable
   D00E                      55 _VIA_int_enable:
   D00E 00                   56 	.byte	0
                             57 	.globl	_VIA_port_a_nohs
   D00F                      58 _VIA_port_a_nohs:
   D00F 00                   59 	.byte	0
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

