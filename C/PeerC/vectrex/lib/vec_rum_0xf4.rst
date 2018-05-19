                              1 
                              2 ;;; gcc for m6809 : Feb 15 2016 21:40:10
                              3 ;;; 4.3.6 (gcc6809)
                              4 ;;; ABI version 1
                              5 ;;; -mint8
                              6 	.module	vec_rum_0xf4.c
                              7 ;----- asm -----
                              8 	.bank page_f4 (BASE=0xf404,SIZE=0x00f8)
                              9 	.area .0xf4 (OVR,BANK=page_f4)
                             10 	
                             11 ;--- end asm ---
                             12 	.globl ___Draw_VLp_FF
                             13 	.area	.0xf4
   F404                      14 ___Draw_VLp_FF:
   F404 00 00                15 	.word	0	;skip space 4
   F406 00 00                16 	.word	0	;skip space 2
                             17 	.globl ___Draw_VLp_7F
   F408                      18 ___Draw_VLp_7F:
   F408 00 00                19 	.word	0	;skip space 4
   F40A 00 00                20 	.word	0	;skip space 2
                             21 	.globl ___Draw_VLp_scale
   F40C                      22 ___Draw_VLp_scale:
   F40C 00 00                23 	.word	0	;skip space 2
                             24 	.globl ___Draw_VLp_b
   F40E                      25 ___Draw_VLp_b:
   F40E 00 00                26 	.word	0	;skip space 2
                             27 	.globl ___Draw_VLp
   F410                      28 ___Draw_VLp:
   F410 00 00                29 	.word	0	;skip space 35
   F412 00 00                30 	.word	0	;skip space 33
   F414 00 00                31 	.word	0	;skip space 31
   F416 00 00                32 	.word	0	;skip space 29
   F418 00 00                33 	.word	0	;skip space 27
   F41A 00 00                34 	.word	0	;skip space 25
   F41C 00 00                35 	.word	0	;skip space 23
   F41E 00 00                36 	.word	0	;skip space 21
   F420 00 00                37 	.word	0	;skip space 19
   F422 00 00                38 	.word	0	;skip space 17
   F424 00 00                39 	.word	0	;skip space 15
   F426 00 00                40 	.word	0	;skip space 13
   F428 00 00                41 	.word	0	;skip space 11
   F42A 00 00                42 	.word	0	;skip space 9
   F42C 00 00                43 	.word	0	;skip space 7
   F42E 00 00                44 	.word	0	;skip space 5
   F430 00 00                45 	.word	0	;skip space 3
   F432 00                   46 	.byte	0	;skip space
                             47 	.globl ___Draw_Pat_VL_aa
   F433                      48 ___Draw_Pat_VL_aa:
   F433 00                   49 	.byte	0	;skip space
                             50 	.globl ___Draw_Pat_VL_a
   F434                      51 ___Draw_Pat_VL_a:
   F434 00 00                52 	.word	0	;skip space 3
   F436 00                   53 	.byte	0	;skip space
                             54 	.globl ___Draw_Pat_VL
   F437                      55 ___Draw_Pat_VL:
   F437 00 00                56 	.word	0	;skip space 2
                             57 	.globl ___Draw_Pat_VL_d
   F439                      58 ___Draw_Pat_VL_d:
   F439 00 00                59 	.word	0	;skip space 53
   F43B 00 00                60 	.word	0	;skip space 51
   F43D 00 00                61 	.word	0	;skip space 49
   F43F 00 00                62 	.word	0	;skip space 47
   F441 00 00                63 	.word	0	;skip space 45
   F443 00 00                64 	.word	0	;skip space 43
   F445 00 00                65 	.word	0	;skip space 41
   F447 00 00                66 	.word	0	;skip space 39
   F449 00 00                67 	.word	0	;skip space 37
   F44B 00 00                68 	.word	0	;skip space 35
   F44D 00 00                69 	.word	0	;skip space 33
   F44F 00 00                70 	.word	0	;skip space 31
   F451 00 00                71 	.word	0	;skip space 29
   F453 00 00                72 	.word	0	;skip space 27
   F455 00 00                73 	.word	0	;skip space 25
   F457 00 00                74 	.word	0	;skip space 23
   F459 00 00                75 	.word	0	;skip space 21
   F45B 00 00                76 	.word	0	;skip space 19
   F45D 00 00                77 	.word	0	;skip space 17
   F45F 00 00                78 	.word	0	;skip space 15
   F461 00 00                79 	.word	0	;skip space 13
   F463 00 00                80 	.word	0	;skip space 11
   F465 00 00                81 	.word	0	;skip space 9
   F467 00 00                82 	.word	0	;skip space 7
   F469 00 00                83 	.word	0	;skip space 5
   F46B 00 00                84 	.word	0	;skip space 3
   F46D 00                   85 	.byte	0	;skip space
                             86 	.globl ___Draw_VL_mode
   F46E                      87 ___Draw_VL_mode:
   F46E 00 00                88 	.word	0	;skip space 39
   F470 00 00                89 	.word	0	;skip space 37
   F472 00 00                90 	.word	0	;skip space 35
   F474 00 00                91 	.word	0	;skip space 33
   F476 00 00                92 	.word	0	;skip space 31
   F478 00 00                93 	.word	0	;skip space 29
   F47A 00 00                94 	.word	0	;skip space 27
   F47C 00 00                95 	.word	0	;skip space 25
   F47E 00 00                96 	.word	0	;skip space 23
   F480 00 00                97 	.word	0	;skip space 21
   F482 00 00                98 	.word	0	;skip space 19
   F484 00 00                99 	.word	0	;skip space 17
   F486 00 00               100 	.word	0	;skip space 15
   F488 00 00               101 	.word	0	;skip space 13
   F48A 00 00               102 	.word	0	;skip space 11
   F48C 00 00               103 	.word	0	;skip space 9
   F48E 00 00               104 	.word	0	;skip space 7
   F490 00 00               105 	.word	0	;skip space 5
   F492 00 00               106 	.word	0	;skip space 3
   F494 00                  107 	.byte	0	;skip space
                            108 	.globl ___Print_Str
   F495                     109 ___Print_Str:
   F495 00 00               110 	.word	0	;skip space 3
   F497 00                  111 	.byte	0	;skip space
                            112 	.globl ___Print_MRast
   F498                     113 ___Print_MRast:
   F498 00                  114 	.byte	0	;skip space
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

