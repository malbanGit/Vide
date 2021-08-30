                              1 ;;; gcc for m6809 : Mar 17 2019 13:25:32
                              2 ;;; 4.3.6 (gcc6809)
                              3 ;;; ABI version 1
                              4 ;;; -mabi=bx -mint8 -fomit-frame-pointer -O0
                              5 	.module	vec_rum_0xf3.c
                              6 ;----- asm -----
                              7 	.bank page_f3 (BASE=0xf308,SIZE=0x00f8)
                              8 	.area .0xf3 (OVR,BANK=page_f3)
                              9 	
                             10 ;--- end asm ---
                             11 	.globl	___Moveto_ix_FF
                             12 	.area	.0xf3
   F308                      13 ___Moveto_ix_FF:
   F308 00 00 00 00          14 	.word	0,0
                             15 	.globl	___Moveto_ix_7F
   F30C                      16 ___Moveto_ix_7F:
   F30C 00 00                17 	.word	0
                             18 	.globl	___Moveto_ix_b
   F30E                      19 ___Moveto_ix_b:
   F30E 00 00                20 	.word	0
                             21 	.globl	___Moveto_ix
   F310                      22 ___Moveto_ix:
   F310 00 00                23 	.word	0
                             24 	.globl	___Moveto_d
   F312                      25 ___Moveto_d:
   F312 00 00 00 00 00 00    26 	.word	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00
   F332 00 00 00 00 00 00    27 	.word	0,0,0,0,0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
                             28 	.globl	___Reset0Ref_D0
   F34A                      29 ___Reset0Ref_D0:
   F34A 00 00 00 00          30 	.word	0,0
   F34E 00                   31 	.byte	0
                             32 	.globl	___Check0Ref
   F34F                      33 ___Check0Ref:
   F34F 00 00 00 00          34 	.word	0,0
   F353 00                   35 	.byte	0
                             36 	.globl	___Reset0Ref
   F354                      37 ___Reset0Ref:
   F354 00 00 00 00 00 00    38 	.word	0,0,0
   F35A 00                   39 	.byte	0
                             40 	.globl	___Reset_Pen
   F35B                      41 ___Reset_Pen:
   F35B 00 00 00 00 00 00    42 	.word	0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00
                             43 	.globl	___Reset0Int
   F36B                      44 ___Reset0Int:
   F36B 00 00 00 00 00 00    45 	.word	0,0,0,0
        00 00
                             46 	.globl	___Print_Str_hwyx
   F373                      47 ___Print_Str_hwyx:
   F373 00 00 00 00          48 	.word	0,0
   F377 00                   49 	.byte	0
                             50 	.globl	___Print_Str_yx
   F378                      51 ___Print_Str_yx:
   F378 00 00                52 	.word	0
                             53 	.globl	___Print_Str_d
   F37A                      54 ___Print_Str_d:
   F37A 00 00 00 00 00 00    55 	.word	0,0,0,0,0
        00 00 00 00
   F384 00                   56 	.byte	0
                             57 	.globl	___Print_List_hw
   F385                      58 ___Print_List_hw:
   F385 00 00 00 00          59 	.word	0,0
   F389 00                   60 	.byte	0
                             61 	.globl	___Print_List
   F38A                      62 ___Print_List:
   F38A 00 00                63 	.word	0
                             64 	.globl	___Print_List_chk
   F38C                      65 ___Print_List_chk:
   F38C 00 00 00 00          66 	.word	0,0
   F390 00                   67 	.byte	0
                             68 	.globl	___Print_Ships_x
   F391                      69 ___Print_Ships_x:
   F391 00 00                70 	.word	0
                             71 	.globl	___Print_Ships
   F393                      72 ___Print_Ships:
   F393 00 00 00 00 00 00    73 	.word	0,0,0,0,0,0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00
                             74 	.globl	___Mov_Draw_VLc_a
   F3AD                      75 ___Mov_Draw_VLc_a:
   F3AD 00 00 00 00          76 	.word	0,0
                             77 	.globl	___Mov_Draw_VL_b
   F3B1                      78 ___Mov_Draw_VL_b:
   F3B1 00 00 00 00          79 	.word	0,0
                             80 	.globl	___Mov_Draw_VLcs
   F3B5                      81 ___Mov_Draw_VLcs:
   F3B5 00 00                82 	.word	0
                             83 	.globl	___Mov_Draw_VL_ab
   F3B7                      84 ___Mov_Draw_VL_ab:
   F3B7 00 00                85 	.word	0
                             86 	.globl	___Mov_Draw_VL_a
   F3B9                      87 ___Mov_Draw_VL_a:
   F3B9 00 00                88 	.word	0
   F3BB 00                   89 	.byte	0
                             90 	.globl	___Mov_Draw_VL
   F3BC                      91 ___Mov_Draw_VL:
   F3BC 00 00                92 	.word	0
                             93 	.globl	___Mov_Draw_VL_d
   F3BE                      94 ___Mov_Draw_VL_d:
   F3BE 00 00 00 00 00 00    95 	.word	0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00
                             96 	.globl	___Draw_VLc
   F3CE                      97 ___Draw_VLc:
   F3CE 00 00 00 00          98 	.word	0,0
                             99 	.globl	___Draw_VL_b
   F3D2                     100 ___Draw_VL_b:
   F3D2 00 00 00 00         101 	.word	0,0
                            102 	.globl	___Draw_VLcs
   F3D6                     103 ___Draw_VLcs:
   F3D6 00 00               104 	.word	0
                            105 	.globl	___Draw_VL_ab
   F3D8                     106 ___Draw_VL_ab:
   F3D8 00 00               107 	.word	0
                            108 	.globl	___Draw_VL_a
   F3DA                     109 ___Draw_VL_a:
   F3DA 00 00               110 	.word	0
   F3DC 00                  111 	.byte	0
                            112 	.globl	___Draw_VL
   F3DD                     113 ___Draw_VL:
   F3DD 00 00               114 	.word	0
                            115 	.globl	___Draw_Line_d
   F3DF                     116 ___Draw_Line_d:
   F3DF 00                  117 	.byte	0
ASxxxx Assembler V05.31  (Motorola 6809)                                Page 1
Hexadecimal [16-Bits]                                 Thu Jan 30 13:14:29 2020

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
  2 ___Check0Ref       0047 GR  |   2 ___Draw_Line_d     00D7 GR
  2 ___Draw_VL         00D5 GR  |   2 ___Draw_VL_a       00D2 GR
  2 ___Draw_VL_ab      00D0 GR  |   2 ___Draw_VL_b       00CA GR
  2 ___Draw_VLc        00C6 GR  |   2 ___Draw_VLcs       00CE GR
  2 ___Mov_Draw_VL     00B4 GR  |   2 ___Mov_Draw_VL     00B1 GR
  2 ___Mov_Draw_VL     00AF GR  |   2 ___Mov_Draw_VL     00A9 GR
  2 ___Mov_Draw_VL     00B6 GR  |   2 ___Mov_Draw_VL     00A5 GR
  2 ___Mov_Draw_VL     00AD GR  |   2 ___Moveto_d        000A GR
  2 ___Moveto_ix       0008 GR  |   2 ___Moveto_ix_7     0004 GR
  2 ___Moveto_ix_F     0000 GR  |   2 ___Moveto_ix_b     0006 GR
  2 ___Print_List      0082 GR  |   2 ___Print_List_     0084 GR
  2 ___Print_List_     007D GR  |   2 ___Print_Ships     008B GR
  2 ___Print_Ships     0089 GR  |   2 ___Print_Str_d     0072 GR
  2 ___Print_Str_h     006B GR  |   2 ___Print_Str_y     0070 GR
  2 ___Reset0Int       0063 GR  |   2 ___Reset0Ref       004C GR
  2 ___Reset0Ref_D     0042 GR  |   2 ___Reset_Pen       0053 GR

ASxxxx Assembler V05.31  (Motorola 6809)                                Page 2
Hexadecimal [16-Bits]                                 Thu Jan 30 13:14:29 2020

Area Table

[_CSEG]
   0 _CODE            size    0   flags C080
[_DSEG]
   1 _DATA            size    0   flags C0C0
[page_f3]
   2 .0xf3            size   D8   flags 8584

