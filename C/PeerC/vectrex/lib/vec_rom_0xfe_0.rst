                              1 
                              2 ;;; gcc for m6809 : Feb 15 2016 21:40:10
                              3 ;;; 4.3.6 (gcc6809)
                              4 ;;; ABI version 1
                              5 ;;; -mint8
                              6 	.module	vec_rom_0xfe_0.c
                              7 ;----- asm -----
                              8 	.bank page_fe (BASE=0xfe28,SIZE=0x0100)
                              9 	.area .dpfe (OVR,BANK=page_fe)
                             10 	
                             11 ;--- end asm ---
                             12 	.globl _Vec_ADSR_FADE1
                             13 	.area	.dpfe
   FE28                      14 _Vec_ADSR_FADE1:
   FE28 00 00                15 	.word	0	;skip space 16
   FE2A 00 00                16 	.word	0	;skip space 14
   FE2C 00 00                17 	.word	0	;skip space 12
   FE2E 00 00                18 	.word	0	;skip space 10
   FE30 00 00                19 	.word	0	;skip space 8
   FE32 00 00                20 	.word	0	;skip space 6
   FE34 00 00                21 	.word	0	;skip space 4
   FE36 00 00                22 	.word	0	;skip space 2
                             23 	.globl _Vec_Music_5
   FE38                      24 _Vec_Music_5:
   FE38 00 00                25 	.word	0	;skip space 46
   FE3A 00 00                26 	.word	0	;skip space 44
   FE3C 00 00                27 	.word	0	;skip space 42
   FE3E 00 00                28 	.word	0	;skip space 40
   FE40 00 00                29 	.word	0	;skip space 38
   FE42 00 00                30 	.word	0	;skip space 36
   FE44 00 00                31 	.word	0	;skip space 34
   FE46 00 00                32 	.word	0	;skip space 32
   FE48 00 00                33 	.word	0	;skip space 30
   FE4A 00 00                34 	.word	0	;skip space 28
   FE4C 00 00                35 	.word	0	;skip space 26
   FE4E 00 00                36 	.word	0	;skip space 24
   FE50 00 00                37 	.word	0	;skip space 22
   FE52 00 00                38 	.word	0	;skip space 20
   FE54 00 00                39 	.word	0	;skip space 18
   FE56 00 00                40 	.word	0	;skip space 16
   FE58 00 00                41 	.word	0	;skip space 14
   FE5A 00 00                42 	.word	0	;skip space 12
   FE5C 00 00                43 	.word	0	;skip space 10
   FE5E 00 00                44 	.word	0	;skip space 8
   FE60 00 00                45 	.word	0	;skip space 6
   FE62 00 00                46 	.word	0	;skip space 4
   FE64 00 00                47 	.word	0	;skip space 2
                             48 	.globl _Vec_ADSR_FADE2
   FE66                      49 _Vec_ADSR_FADE2:
   FE66 00 00                50 	.word	0	;skip space 16
   FE68 00 00                51 	.word	0	;skip space 14
   FE6A 00 00                52 	.word	0	;skip space 12
   FE6C 00 00                53 	.word	0	;skip space 10
   FE6E 00 00                54 	.word	0	;skip space 8
   FE70 00 00                55 	.word	0	;skip space 6
   FE72 00 00                56 	.word	0	;skip space 4
   FE74 00 00                57 	.word	0	;skip space 2
                             58 	.globl _Vec_Music_6
   FE76                      59 _Vec_Music_6:
   FE76 00 00                60 	.word	0	;skip space 60
   FE78 00 00                61 	.word	0	;skip space 58
   FE7A 00 00                62 	.word	0	;skip space 56
   FE7C 00 00                63 	.word	0	;skip space 54
   FE7E 00 00                64 	.word	0	;skip space 52
   FE80 00 00                65 	.word	0	;skip space 50
   FE82 00 00                66 	.word	0	;skip space 48
   FE84 00 00                67 	.word	0	;skip space 46
   FE86 00 00                68 	.word	0	;skip space 44
   FE88 00 00                69 	.word	0	;skip space 42
   FE8A 00 00                70 	.word	0	;skip space 40
   FE8C 00 00                71 	.word	0	;skip space 38
   FE8E 00 00                72 	.word	0	;skip space 36
   FE90 00 00                73 	.word	0	;skip space 34
   FE92 00 00                74 	.word	0	;skip space 32
   FE94 00 00                75 	.word	0	;skip space 30
   FE96 00 00                76 	.word	0	;skip space 28
   FE98 00 00                77 	.word	0	;skip space 26
   FE9A 00 00                78 	.word	0	;skip space 24
   FE9C 00 00                79 	.word	0	;skip space 22
   FE9E 00 00                80 	.word	0	;skip space 20
   FEA0 00 00                81 	.word	0	;skip space 18
   FEA2 00 00                82 	.word	0	;skip space 16
   FEA4 00 00                83 	.word	0	;skip space 14
   FEA6 00 00                84 	.word	0	;skip space 12
   FEA8 00 00                85 	.word	0	;skip space 10
   FEAA 00 00                86 	.word	0	;skip space 8
   FEAC 00 00                87 	.word	0	;skip space 6
   FEAE 00 00                88 	.word	0	;skip space 4
   FEB0 00 00                89 	.word	0	;skip space 2
                             90 	.globl _Vec_ADSR_FADE3
   FEB2                      91 _Vec_ADSR_FADE3:
   FEB2 00 00                92 	.word	0	;skip space 4
   FEB4 00 00                93 	.word	0	;skip space 2
                             94 	.globl _Vec_TWANG_VIBEHL
   FEB6                      95 _Vec_TWANG_VIBEHL:
   FEB6 00 00                96 	.word	0	;skip space 16
   FEB8 00 00                97 	.word	0	;skip space 14
   FEBA 00 00                98 	.word	0	;skip space 12
   FEBC 00 00                99 	.word	0	;skip space 10
   FEBE 00 00               100 	.word	0	;skip space 8
   FEC0 00 00               101 	.word	0	;skip space 6
   FEC2 00 00               102 	.word	0	;skip space 4
   FEC4 00 00               103 	.word	0	;skip space 2
                            104 	.globl _Vec_Music_7
   FEC6                     105 _Vec_Music_7:
   FEC6 00 00               106 	.word	0	;skip space 34
   FEC8 00 00               107 	.word	0	;skip space 32
   FECA 00 00               108 	.word	0	;skip space 30
   FECC 00 00               109 	.word	0	;skip space 28
   FECE 00 00               110 	.word	0	;skip space 26
   FED0 00 00               111 	.word	0	;skip space 24
   FED2 00 00               112 	.word	0	;skip space 22
   FED4 00 00               113 	.word	0	;skip space 20
   FED6 00 00               114 	.word	0	;skip space 18
   FED8 00 00               115 	.word	0	;skip space 16
   FEDA 00 00               116 	.word	0	;skip space 14
   FEDC 00 00               117 	.word	0	;skip space 12
   FEDE 00 00               118 	.word	0	;skip space 10
   FEE0 00 00               119 	.word	0	;skip space 8
   FEE2 00 00               120 	.word	0	;skip space 6
   FEE4 00 00               121 	.word	0	;skip space 4
   FEE6 00 00               122 	.word	0	;skip space 2
                            123 	.globl _Vec_ADSR_FADE4
   FEE8                     124 _Vec_ADSR_FADE4:
   FEE8 00 00               125 	.word	0	;skip space 16
   FEEA 00 00               126 	.word	0	;skip space 14
   FEEC 00 00               127 	.word	0	;skip space 12
   FEEE 00 00               128 	.word	0	;skip space 10
   FEF0 00 00               129 	.word	0	;skip space 8
   FEF2 00 00               130 	.word	0	;skip space 6
   FEF4 00 00               131 	.word	0	;skip space 4
   FEF6 00 00               132 	.word	0	;skip space 2
                            133 	.globl _Vec_Music_8
   FEF8                     134 _Vec_Music_8:
   FEF8 00                  135 	.byte	0	;skip space
ASxxxx Assembler V05.00  (Motorola 6809), page 1.
Hexidecimal [16-Bits]

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
  2 _Vec_ADSR_FADE     0000 GR  |   2 _Vec_ADSR_FADE     003E GR
  2 _Vec_ADSR_FADE     008A GR  |   2 _Vec_ADSR_FADE     00C0 GR
  2 _Vec_Music_5       0010 GR  |   2 _Vec_Music_6       004E GR
  2 _Vec_Music_7       009E GR  |   2 _Vec_Music_8       00D0 GR
  2 _Vec_TWANG_VIB     008E GR

ASxxxx Assembler V05.00  (Motorola 6809), page 2.
Hexidecimal [16-Bits]

Area Table

[_CSEG]
   0 _CODE            size    0   flags C080
[_DSEG]
   1 _DATA            size    0   flags C0C0
[page_fe]
   2 .dpfe            size   D1   flags 8584

