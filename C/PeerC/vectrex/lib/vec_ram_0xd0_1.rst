                              1 ;;; gcc for m6809 : Mar 11 2019 13:34:05
                              2 ;;; 4.3.6 (gcc6809)
                              3 ;;; ABI version 1
                              4 ;;; -mabi=bx -mint8 -fomit-frame-pointer -O2
                              5 	.module	vec_ram_0xd0_1.c
                              6 ;----- asm -----
                              7 	.bank page_d0 (BASE=0xd000,SIZE=0x0100)
                              8 	.area .dpd0 (OVR,BANK=page_d0)
                              9 	
                             10 ;--- end asm ---
                             11 	.globl	_VIA_port_ba
                             12 	.area	.dpd0
   D000                      13 _VIA_port_ba:
   D000 00 00                14 	.word	0
                             15 	.globl	_VIA_DDR_ba
   D002                      16 _VIA_DDR_ba:
   D002 00 00                17 	.word	0
                             18 	.globl	_VIA_t1_cnt
   D004                      19 _VIA_t1_cnt:
   D004 00 00                20 	.word	0
                             21 	.globl	_VIA_t1_lch
   D006                      22 _VIA_t1_lch:
   D006 00 00                23 	.word	0
                             24 	.globl	_VIA_t2
   D008                      25 _VIA_t2:
   D008 00 00                26 	.word	0
                             27 	.globl	_dummy
   D00A                      28 _dummy:
   D00A 00                   29 	.byte	0
                             30 	.globl	_VIA_aux_cntl_w
   D00B                      31 _VIA_aux_cntl_w:
   D00B 00 00                32 	.word	0
ASxxxx Assembler V05.00  (Motorola 6809), page 1.
Hexidecimal [16-Bits]

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
  2 _VIA_DDR_ba        0002 GR  |   2 _VIA_aux_cntl_     000B GR
  2 _VIA_port_ba       0000 GR  |   2 _VIA_t1_cnt        0004 GR
  2 _VIA_t1_lch        0006 GR  |   2 _VIA_t2            0008 GR
  2 _dummy             000A GR

ASxxxx Assembler V05.00  (Motorola 6809), page 2.
Hexidecimal [16-Bits]

Area Table

[_CSEG]
   0 _CODE            size    0   flags C080
[_DSEG]
   1 _DATA            size    0   flags C0C0
[page_d0]
   2 .dpd0            size    D   flags 8584

