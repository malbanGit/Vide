                              1 ;;; gcc for m6809 : Mar 17 2019 13:25:32
                              2 ;;; 4.3.6 (gcc6809)
                              3 ;;; ABI version 1
                              4 ;;; -mabi=bx -mint8 -fomit-frame-pointer -O0
                              5 	.module	vec_ram_dpd0_1.c
                              6 ;----- asm -----
                              7 	.bank page_00 (BASE=0x0000,SIZE=0x0100)
                              8 	.area .direct (OVR,BANK=page_00)
                              9 	
                             10 ;--- end asm ---
                             11 	.globl	_dp_VIA_port_ba
                             12 	.area	.direct
   0000                      13 _dp_VIA_port_ba:
   0000 00 00                14 	.word	0
                             15 	.globl	_dp_VIA_DDR_ba
   0002                      16 _dp_VIA_DDR_ba:
   0002 00 00                17 	.word	0
                             18 	.globl	_dp_VIA_t1_cnt
   0004                      19 _dp_VIA_t1_cnt:
   0004 00 00                20 	.word	0
                             21 	.globl	_dp_VIA_t1_lch
   0006                      22 _dp_VIA_t1_lch:
   0006 00 00                23 	.word	0
                             24 	.globl	_dp_VIA_t2
   0008                      25 _dp_VIA_t2:
   0008 00 00                26 	.word	0
                             27 	.globl	_dp_dummy
   000A                      28 _dp_dummy:
   000A 00                   29 	.byte	0
                             30 	.globl	_dp_VIA_aux_cntl_w
   000B                      31 _dp_VIA_aux_cntl_w:
   000B 00 00                32 	.word	0
ASxxxx Assembler V05.31  (Motorola 6809)                                Page 1
Hexadecimal [16-Bits]                                 Thu Jan 30 13:14:28 2020

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
  2 _dp_VIA_DDR_ba     0002 GR  |   2 _dp_VIA_aux_cn     000B GR
  2 _dp_VIA_port_b     0000 GR  |   2 _dp_VIA_t1_cnt     0004 GR
  2 _dp_VIA_t1_lch     0006 GR  |   2 _dp_VIA_t2         0008 GR
  2 _dp_dummy          000A GR

ASxxxx Assembler V05.31  (Motorola 6809)                                Page 2
Hexadecimal [16-Bits]                                 Thu Jan 30 13:14:28 2020

Area Table

[_CSEG]
   0 _CODE            size    0   flags C080
[_DSEG]
   1 _DATA            size    0   flags C0C0
[page_00]
   2 .direct          size    D   flags 8584

