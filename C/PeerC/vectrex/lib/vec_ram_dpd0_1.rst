                              1 
                              2 ;;; gcc for m6809 : Feb 15 2016 21:40:10
                              3 ;;; 4.3.6 (gcc6809)
                              4 ;;; ABI version 1
                              5 ;;; -mint8
                              6 	.module	vec_ram_dpd0_1.c
                              7 ;----- asm -----
                              8 	.bank page_00 (BASE=0x0000,SIZE=0x0100)
                              9 	.area direct (OVR,BANK=page_00)
                             10 	
                             11 ;--- end asm ---
                             12 	.globl _dp_VIA_port_ba
                             13 	.area	direct
   0000                      14 _dp_VIA_port_ba:
   0000 00 00                15 	.word	0	;skip space 2
                             16 	.globl _dp_VIA_DDR_ba
   0002                      17 _dp_VIA_DDR_ba:
   0002 00 00                18 	.word	0	;skip space 2
                             19 	.globl _dp_VIA_t1_cnt
   0004                      20 _dp_VIA_t1_cnt:
   0004 00 00                21 	.word	0	;skip space 2
                             22 	.globl _dp_VIA_t1_lch
   0006                      23 _dp_VIA_t1_lch:
   0006 00 00                24 	.word	0	;skip space 2
                             25 	.globl _dp_VIA_t2
   0008                      26 _dp_VIA_t2:
   0008 00 00                27 	.word	0	;skip space 2
                             28 	.globl _dp_dummy
   000A                      29 _dp_dummy:
   000A 00                   30 	.byte	0	;skip space
                             31 	.globl _dp_VIA_aux_cntl_w
   000B                      32 _dp_VIA_aux_cntl_w:
   000B 00 00                33 	.word	0	;skip space 2
ASxxxx Assembler V05.00  (Motorola 6809), page 1.
Hexidecimal [16-Bits]

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
  2 _dp_VIA_DDR_ba     0002 GR  |   2 _dp_VIA_aux_cn     000B GR
  2 _dp_VIA_port_b     0000 GR  |   2 _dp_VIA_t1_cnt     0004 GR
  2 _dp_VIA_t1_lch     0006 GR  |   2 _dp_VIA_t2         0008 GR
  2 _dp_dummy          000A GR

ASxxxx Assembler V05.00  (Motorola 6809), page 2.
Hexidecimal [16-Bits]

Area Table

[_CSEG]
   0 _CODE            size    0   flags C080
[_DSEG]
   1 _DATA            size    0   flags C0C0
[page_00]
   2 direct           size    D   flags 8584

