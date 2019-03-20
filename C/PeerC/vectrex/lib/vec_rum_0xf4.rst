                              1 ;;; gcc for m6809 : Mar 11 2019 13:34:05
                              2 ;;; 4.3.6 (gcc6809)
                              3 ;;; ABI version 1
                              4 ;;; -mabi=bx -mint8 -fomit-frame-pointer -O2
                              5 	.module	vec_rum_0xf4.c
                              6 ;----- asm -----
                              7 	.bank page_f4 (BASE=0xf404,SIZE=0x00f8)
                              8 	.area .0xf4 (OVR,BANK=page_f4)
                              9 	
                             10 ;--- end asm ---
                             11 	.globl	___Draw_VLp_FF
                             12 	.area	.0xf4
   F404                      13 ___Draw_VLp_FF:
   F404 00 00 00 00          14 	.word	0,0
                             15 	.globl	___Draw_VLp_7F
   F408                      16 ___Draw_VLp_7F:
   F408 00 00 00 00          17 	.word	0,0
                             18 	.globl	___Draw_VLp_scale
   F40C                      19 ___Draw_VLp_scale:
   F40C 00 00                20 	.word	0
                             21 	.globl	___Draw_VLp_b
   F40E                      22 ___Draw_VLp_b:
   F40E 00 00                23 	.word	0
                             24 	.globl	___Draw_VLp
   F410                      25 ___Draw_VLp:
   F410 00 00 00 00 00 00    26 	.word	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00
   F430 00 00                27 	.word	0
   F432 00                   28 	.byte	0
                             29 	.globl	___Draw_Pat_VL_aa
   F433                      30 ___Draw_Pat_VL_aa:
   F433 00                   31 	.byte	0
                             32 	.globl	___Draw_Pat_VL_a
   F434                      33 ___Draw_Pat_VL_a:
   F434 00 00                34 	.word	0
   F436 00                   35 	.byte	0
                             36 	.globl	___Draw_Pat_VL
   F437                      37 ___Draw_Pat_VL:
   F437 00 00                38 	.word	0
                             39 	.globl	___Draw_Pat_VL_d
   F439                      40 ___Draw_Pat_VL_d:
   F439 00 00 00 00 00 00    41 	.word	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00
   F459 00 00 00 00 00 00    42 	.word	0,0,0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00
   F46D 00                   43 	.byte	0
                             44 	.globl	___Draw_VL_mode
   F46E                      45 ___Draw_VL_mode:
   F46E 00 00 00 00 00 00    46 	.word	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00
   F48E 00 00 00 00 00 00    47 	.word	0,0,0
   F494 00                   48 	.byte	0
                             49 	.globl	___Print_Str
   F495                      50 ___Print_Str:
   F495 00 00                51 	.word	0
   F497 00                   52 	.byte	0
                             53 	.globl	___Print_MRast
   F498                      54 ___Print_MRast:
   F498 00                   55 	.byte	0
ASxxxx Assembler V05.00  (Motorola 6809), page 1.
Hexidecimal [16-Bits]

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
  2 ___Draw_Pat_VL     0033 GR  |   2 ___Draw_Pat_VL     0030 GR
  2 ___Draw_Pat_VL     002F GR  |   2 ___Draw_Pat_VL     0035 GR
  2 ___Draw_VL_mod     006A GR  |   2 ___Draw_VLp        000C GR
  2 ___Draw_VLp_7F     0004 GR  |   2 ___Draw_VLp_FF     0000 GR
  2 ___Draw_VLp_b      000A GR  |   2 ___Draw_VLp_sc     0008 GR
  2 ___Print_MRast     0094 GR  |   2 ___Print_Str       0091 GR

ASxxxx Assembler V05.00  (Motorola 6809), page 2.
Hexidecimal [16-Bits]

Area Table

[_CSEG]
   0 _CODE            size    0   flags C080
[_DSEG]
   1 _DATA            size    0   flags C0C0
[page_f4]
   2 .0xf4            size   95   flags 8584

