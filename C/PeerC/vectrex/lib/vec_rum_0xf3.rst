                              1 
                              2 ;;; gcc for m6809 : Feb 15 2016 21:40:10
                              3 ;;; 4.3.6 (gcc6809)
                              4 ;;; ABI version 1
                              5 ;;; -mint8
                              6 	.module	vec_rum_0xf3.c
                              7 ;----- asm -----
                              8 	.bank page_f3 (BASE=0xf308,SIZE=0x00f8)
                              9 	.area .0xf3 (OVR,BANK=page_f3)
                             10 	
                             11 ;--- end asm ---
                             12 	.globl ___Moveto_ix_FF
                             13 	.area	.0xf3
   F308                      14 ___Moveto_ix_FF:
   F308 00 00                15 	.word	0	;skip space 4
   F30A 00 00                16 	.word	0	;skip space 2
                             17 	.globl ___Moveto_ix_7F
   F30C                      18 ___Moveto_ix_7F:
   F30C 00 00                19 	.word	0	;skip space 2
                             20 	.globl ___Moveto_ix_b
   F30E                      21 ___Moveto_ix_b:
   F30E 00 00                22 	.word	0	;skip space 2
                             23 	.globl ___Moveto_ix
   F310                      24 ___Moveto_ix:
   F310 00 00                25 	.word	0	;skip space 2
                             26 	.globl ___Moveto_d
   F312                      27 ___Moveto_d:
   F312 00 00                28 	.word	0	;skip space 56
   F314 00 00                29 	.word	0	;skip space 54
   F316 00 00                30 	.word	0	;skip space 52
   F318 00 00                31 	.word	0	;skip space 50
   F31A 00 00                32 	.word	0	;skip space 48
   F31C 00 00                33 	.word	0	;skip space 46
   F31E 00 00                34 	.word	0	;skip space 44
   F320 00 00                35 	.word	0	;skip space 42
   F322 00 00                36 	.word	0	;skip space 40
   F324 00 00                37 	.word	0	;skip space 38
   F326 00 00                38 	.word	0	;skip space 36
   F328 00 00                39 	.word	0	;skip space 34
   F32A 00 00                40 	.word	0	;skip space 32
   F32C 00 00                41 	.word	0	;skip space 30
   F32E 00 00                42 	.word	0	;skip space 28
   F330 00 00                43 	.word	0	;skip space 26
   F332 00 00                44 	.word	0	;skip space 24
   F334 00 00                45 	.word	0	;skip space 22
   F336 00 00                46 	.word	0	;skip space 20
   F338 00 00                47 	.word	0	;skip space 18
   F33A 00 00                48 	.word	0	;skip space 16
   F33C 00 00                49 	.word	0	;skip space 14
   F33E 00 00                50 	.word	0	;skip space 12
   F340 00 00                51 	.word	0	;skip space 10
   F342 00 00                52 	.word	0	;skip space 8
   F344 00 00                53 	.word	0	;skip space 6
   F346 00 00                54 	.word	0	;skip space 4
   F348 00 00                55 	.word	0	;skip space 2
                             56 	.globl ___Reset0Ref_D0
   F34A                      57 ___Reset0Ref_D0:
   F34A 00 00                58 	.word	0	;skip space 5
   F34C 00 00                59 	.word	0	;skip space 3
   F34E 00                   60 	.byte	0	;skip space
                             61 	.globl ___Check0Ref
   F34F                      62 ___Check0Ref:
   F34F 00 00                63 	.word	0	;skip space 5
   F351 00 00                64 	.word	0	;skip space 3
   F353 00                   65 	.byte	0	;skip space
                             66 	.globl ___Reset0Ref
   F354                      67 ___Reset0Ref:
   F354 00 00                68 	.word	0	;skip space 7
   F356 00 00                69 	.word	0	;skip space 5
   F358 00 00                70 	.word	0	;skip space 3
   F35A 00                   71 	.byte	0	;skip space
                             72 	.globl ___Reset_Pen
   F35B                      73 ___Reset_Pen:
   F35B 00 00                74 	.word	0	;skip space 16
   F35D 00 00                75 	.word	0	;skip space 14
   F35F 00 00                76 	.word	0	;skip space 12
   F361 00 00                77 	.word	0	;skip space 10
   F363 00 00                78 	.word	0	;skip space 8
   F365 00 00                79 	.word	0	;skip space 6
   F367 00 00                80 	.word	0	;skip space 4
   F369 00 00                81 	.word	0	;skip space 2
                             82 	.globl ___Reset0Int
   F36B                      83 ___Reset0Int:
   F36B 00 00                84 	.word	0	;skip space 8
   F36D 00 00                85 	.word	0	;skip space 6
   F36F 00 00                86 	.word	0	;skip space 4
   F371 00 00                87 	.word	0	;skip space 2
                             88 	.globl ___Print_Str_hwyx
   F373                      89 ___Print_Str_hwyx:
   F373 00 00                90 	.word	0	;skip space 5
   F375 00 00                91 	.word	0	;skip space 3
   F377 00                   92 	.byte	0	;skip space
                             93 	.globl ___Print_Str_yx
   F378                      94 ___Print_Str_yx:
   F378 00 00                95 	.word	0	;skip space 2
                             96 	.globl ___Print_Str_d
   F37A                      97 ___Print_Str_d:
   F37A 00 00                98 	.word	0	;skip space 11
   F37C 00 00                99 	.word	0	;skip space 9
   F37E 00 00               100 	.word	0	;skip space 7
   F380 00 00               101 	.word	0	;skip space 5
   F382 00 00               102 	.word	0	;skip space 3
   F384 00                  103 	.byte	0	;skip space
                            104 	.globl ___Print_List_hw
   F385                     105 ___Print_List_hw:
   F385 00 00               106 	.word	0	;skip space 5
   F387 00 00               107 	.word	0	;skip space 3
   F389 00                  108 	.byte	0	;skip space
                            109 	.globl ___Print_List
   F38A                     110 ___Print_List:
   F38A 00 00               111 	.word	0	;skip space 2
                            112 	.globl ___Print_List_chk
   F38C                     113 ___Print_List_chk:
   F38C 00 00               114 	.word	0	;skip space 5
   F38E 00 00               115 	.word	0	;skip space 3
   F390 00                  116 	.byte	0	;skip space
                            117 	.globl ___Print_Ships_x
   F391                     118 ___Print_Ships_x:
   F391 00 00               119 	.word	0	;skip space 2
                            120 	.globl ___Print_Ships
   F393                     121 ___Print_Ships:
   F393 00 00               122 	.word	0	;skip space 26
   F395 00 00               123 	.word	0	;skip space 24
   F397 00 00               124 	.word	0	;skip space 22
   F399 00 00               125 	.word	0	;skip space 20
   F39B 00 00               126 	.word	0	;skip space 18
   F39D 00 00               127 	.word	0	;skip space 16
   F39F 00 00               128 	.word	0	;skip space 14
   F3A1 00 00               129 	.word	0	;skip space 12
   F3A3 00 00               130 	.word	0	;skip space 10
   F3A5 00 00               131 	.word	0	;skip space 8
   F3A7 00 00               132 	.word	0	;skip space 6
   F3A9 00 00               133 	.word	0	;skip space 4
   F3AB 00 00               134 	.word	0	;skip space 2
                            135 	.globl ___Mov_Draw_VLc_a
   F3AD                     136 ___Mov_Draw_VLc_a:
   F3AD 00 00               137 	.word	0	;skip space 4
   F3AF 00 00               138 	.word	0	;skip space 2
                            139 	.globl ___Mov_Draw_VL_b
   F3B1                     140 ___Mov_Draw_VL_b:
   F3B1 00 00               141 	.word	0	;skip space 4
   F3B3 00 00               142 	.word	0	;skip space 2
                            143 	.globl ___Mov_Draw_VLcs
   F3B5                     144 ___Mov_Draw_VLcs:
   F3B5 00 00               145 	.word	0	;skip space 2
                            146 	.globl ___Mov_Draw_VL_ab
   F3B7                     147 ___Mov_Draw_VL_ab:
   F3B7 00 00               148 	.word	0	;skip space 2
                            149 	.globl ___Mov_Draw_VL_a
   F3B9                     150 ___Mov_Draw_VL_a:
   F3B9 00 00               151 	.word	0	;skip space 3
   F3BB 00                  152 	.byte	0	;skip space
                            153 	.globl ___Mov_Draw_VL
   F3BC                     154 ___Mov_Draw_VL:
   F3BC 00 00               155 	.word	0	;skip space 2
                            156 	.globl ___Mov_Draw_VL_d
   F3BE                     157 ___Mov_Draw_VL_d:
   F3BE 00 00               158 	.word	0	;skip space 16
   F3C0 00 00               159 	.word	0	;skip space 14
   F3C2 00 00               160 	.word	0	;skip space 12
   F3C4 00 00               161 	.word	0	;skip space 10
   F3C6 00 00               162 	.word	0	;skip space 8
   F3C8 00 00               163 	.word	0	;skip space 6
   F3CA 00 00               164 	.word	0	;skip space 4
   F3CC 00 00               165 	.word	0	;skip space 2
                            166 	.globl ___Draw_VLc
   F3CE                     167 ___Draw_VLc:
   F3CE 00 00               168 	.word	0	;skip space 4
   F3D0 00 00               169 	.word	0	;skip space 2
                            170 	.globl ___Draw_VL_b
   F3D2                     171 ___Draw_VL_b:
   F3D2 00 00               172 	.word	0	;skip space 4
   F3D4 00 00               173 	.word	0	;skip space 2
                            174 	.globl ___Draw_VLcs
   F3D6                     175 ___Draw_VLcs:
   F3D6 00 00               176 	.word	0	;skip space 2
                            177 	.globl ___Draw_VL_ab
   F3D8                     178 ___Draw_VL_ab:
   F3D8 00 00               179 	.word	0	;skip space 2
                            180 	.globl ___Draw_VL_a
   F3DA                     181 ___Draw_VL_a:
   F3DA 00 00               182 	.word	0	;skip space 3
   F3DC 00                  183 	.byte	0	;skip space
                            184 	.globl ___Draw_VL
   F3DD                     185 ___Draw_VL:
   F3DD 00 00               186 	.word	0	;skip space 2
                            187 	.globl ___Draw_Line_d
   F3DF                     188 ___Draw_Line_d:
   F3DF 00                  189 	.byte	0	;skip space
ASxxxx Assembler V05.00  (Motorola 6809), page 1.
Hexidecimal [16-Bits]

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

ASxxxx Assembler V05.00  (Motorola 6809), page 2.
Hexidecimal [16-Bits]

Area Table

[_CSEG]
   0 _CODE            size    0   flags C080
[_DSEG]
   1 _DATA            size    0   flags C0C0
[page_f3]
   2 .0xf3            size   D8   flags 8584

