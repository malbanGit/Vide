                              1 
                              2 ;;; gcc for m6809 : Feb 15 2016 21:40:10
                              3 ;;; 4.3.6 (gcc6809)
                              4 ;;; ABI version 1
                              5 ;;; -mint8
                              6 	.module	vec_rom_dpfe_0.c
                              7 ;----- asm -----
                              8 	.bank page_00 (BASE=0x0000,SIZE=0x0100)
                              9 	.area direct (OVR,BANK=page_00)
                             10 	
                             11 ;--- end asm ---
                             12 	.globl _dp_Vec_Snd_shadow
                             13 	.area	direct
   0000                      14 _dp_Vec_Snd_shadow:
   0000 00 00                15 	.word	0	;skip space 40
   0002 00 00                16 	.word	0	;skip space 38
   0004 00 00                17 	.word	0	;skip space 36
   0006 00 00                18 	.word	0	;skip space 34
   0008 00 00                19 	.word	0	;skip space 32
   000A 00 00                20 	.word	0	;skip space 30
   000C 00 00                21 	.word	0	;skip space 28
   000E 00 00                22 	.word	0	;skip space 26
   0010 00 00                23 	.word	0	;skip space 24
   0012 00 00                24 	.word	0	;skip space 22
   0014 00 00                25 	.word	0	;skip space 20
   0016 00 00                26 	.word	0	;skip space 18
   0018 00 00                27 	.word	0	;skip space 16
   001A 00 00                28 	.word	0	;skip space 14
   001C 00 00                29 	.word	0	;skip space 12
   001E 00 00                30 	.word	0	;skip space 10
   0020 00 00                31 	.word	0	;skip space 8
   0022 00 00                32 	.word	0	;skip space 6
   0024 00 00                33 	.word	0	;skip space 4
   0026 00 00                34 	.word	0	;skip space 2
                             35 	.globl _dp_Vec_ADSR_FADE1
   0028                      36 _dp_Vec_ADSR_FADE1:
   0028 00 00                37 	.word	0	;skip space 16
   002A 00 00                38 	.word	0	;skip space 14
   002C 00 00                39 	.word	0	;skip space 12
   002E 00 00                40 	.word	0	;skip space 10
   0030 00 00                41 	.word	0	;skip space 8
   0032 00 00                42 	.word	0	;skip space 6
   0034 00 00                43 	.word	0	;skip space 4
   0036 00 00                44 	.word	0	;skip space 2
                             45 	.globl _dp_Vec_Music_5
   0038                      46 _dp_Vec_Music_5:
   0038 00 00                47 	.word	0	;skip space 46
   003A 00 00                48 	.word	0	;skip space 44
   003C 00 00                49 	.word	0	;skip space 42
   003E 00 00                50 	.word	0	;skip space 40
   0040 00 00                51 	.word	0	;skip space 38
   0042 00 00                52 	.word	0	;skip space 36
   0044 00 00                53 	.word	0	;skip space 34
   0046 00 00                54 	.word	0	;skip space 32
   0048 00 00                55 	.word	0	;skip space 30
   004A 00 00                56 	.word	0	;skip space 28
   004C 00 00                57 	.word	0	;skip space 26
   004E 00 00                58 	.word	0	;skip space 24
   0050 00 00                59 	.word	0	;skip space 22
   0052 00 00                60 	.word	0	;skip space 20
   0054 00 00                61 	.word	0	;skip space 18
   0056 00 00                62 	.word	0	;skip space 16
   0058 00 00                63 	.word	0	;skip space 14
   005A 00 00                64 	.word	0	;skip space 12
   005C 00 00                65 	.word	0	;skip space 10
   005E 00 00                66 	.word	0	;skip space 8
   0060 00 00                67 	.word	0	;skip space 6
   0062 00 00                68 	.word	0	;skip space 4
   0064 00 00                69 	.word	0	;skip space 2
                             70 	.globl _dp_Vec_ADSR_FADE2
   0066                      71 _dp_Vec_ADSR_FADE2:
   0066 00 00                72 	.word	0	;skip space 16
   0068 00 00                73 	.word	0	;skip space 14
   006A 00 00                74 	.word	0	;skip space 12
   006C 00 00                75 	.word	0	;skip space 10
   006E 00 00                76 	.word	0	;skip space 8
   0070 00 00                77 	.word	0	;skip space 6
   0072 00 00                78 	.word	0	;skip space 4
   0074 00 00                79 	.word	0	;skip space 2
                             80 	.globl _dp_Vec_Music_6
   0076                      81 _dp_Vec_Music_6:
   0076 00 00                82 	.word	0	;skip space 60
   0078 00 00                83 	.word	0	;skip space 58
   007A 00 00                84 	.word	0	;skip space 56
   007C 00 00                85 	.word	0	;skip space 54
   007E 00 00                86 	.word	0	;skip space 52
   0080 00 00                87 	.word	0	;skip space 50
   0082 00 00                88 	.word	0	;skip space 48
   0084 00 00                89 	.word	0	;skip space 46
   0086 00 00                90 	.word	0	;skip space 44
   0088 00 00                91 	.word	0	;skip space 42
   008A 00 00                92 	.word	0	;skip space 40
   008C 00 00                93 	.word	0	;skip space 38
   008E 00 00                94 	.word	0	;skip space 36
   0090 00 00                95 	.word	0	;skip space 34
   0092 00 00                96 	.word	0	;skip space 32
   0094 00 00                97 	.word	0	;skip space 30
   0096 00 00                98 	.word	0	;skip space 28
   0098 00 00                99 	.word	0	;skip space 26
   009A 00 00               100 	.word	0	;skip space 24
   009C 00 00               101 	.word	0	;skip space 22
   009E 00 00               102 	.word	0	;skip space 20
   00A0 00 00               103 	.word	0	;skip space 18
   00A2 00 00               104 	.word	0	;skip space 16
   00A4 00 00               105 	.word	0	;skip space 14
   00A6 00 00               106 	.word	0	;skip space 12
   00A8 00 00               107 	.word	0	;skip space 10
   00AA 00 00               108 	.word	0	;skip space 8
   00AC 00 00               109 	.word	0	;skip space 6
   00AE 00 00               110 	.word	0	;skip space 4
   00B0 00 00               111 	.word	0	;skip space 2
                            112 	.globl _dp_Vec_ADSR_FADE3
   00B2                     113 _dp_Vec_ADSR_FADE3:
   00B2 00 00               114 	.word	0	;skip space 4
   00B4 00 00               115 	.word	0	;skip space 2
                            116 	.globl _dp_Vec_TWANG_VIBEHL
   00B6                     117 _dp_Vec_TWANG_VIBEHL:
   00B6 00 00               118 	.word	0	;skip space 16
   00B8 00 00               119 	.word	0	;skip space 14
   00BA 00 00               120 	.word	0	;skip space 12
   00BC 00 00               121 	.word	0	;skip space 10
   00BE 00 00               122 	.word	0	;skip space 8
   00C0 00 00               123 	.word	0	;skip space 6
   00C2 00 00               124 	.word	0	;skip space 4
   00C4 00 00               125 	.word	0	;skip space 2
                            126 	.globl _dp_Vec_Music_7
   00C6                     127 _dp_Vec_Music_7:
   00C6 00 00               128 	.word	0	;skip space 34
   00C8 00 00               129 	.word	0	;skip space 32
   00CA 00 00               130 	.word	0	;skip space 30
   00CC 00 00               131 	.word	0	;skip space 28
   00CE 00 00               132 	.word	0	;skip space 26
   00D0 00 00               133 	.word	0	;skip space 24
   00D2 00 00               134 	.word	0	;skip space 22
   00D4 00 00               135 	.word	0	;skip space 20
   00D6 00 00               136 	.word	0	;skip space 18
   00D8 00 00               137 	.word	0	;skip space 16
   00DA 00 00               138 	.word	0	;skip space 14
   00DC 00 00               139 	.word	0	;skip space 12
   00DE 00 00               140 	.word	0	;skip space 10
   00E0 00 00               141 	.word	0	;skip space 8
   00E2 00 00               142 	.word	0	;skip space 6
   00E4 00 00               143 	.word	0	;skip space 4
   00E6 00 00               144 	.word	0	;skip space 2
                            145 	.globl _dp_Vec_ADSR_FADE4
   00E8                     146 _dp_Vec_ADSR_FADE4:
   00E8 00 00               147 	.word	0	;skip space 16
   00EA 00 00               148 	.word	0	;skip space 14
   00EC 00 00               149 	.word	0	;skip space 12
   00EE 00 00               150 	.word	0	;skip space 10
   00F0 00 00               151 	.word	0	;skip space 8
   00F2 00 00               152 	.word	0	;skip space 6
   00F4 00 00               153 	.word	0	;skip space 4
   00F6 00 00               154 	.word	0	;skip space 2
                            155 	.globl _dp_Vec_Music_8
   00F8                     156 _dp_Vec_Music_8:
   00F8 00                  157 	.byte	0	;skip space
ASxxxx Assembler V05.00  (Motorola 6809), page 1.
Hexidecimal [16-Bits]

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
  2 _dp_Vec_ADSR_F     0028 GR  |   2 _dp_Vec_ADSR_F     0066 GR
  2 _dp_Vec_ADSR_F     00B2 GR  |   2 _dp_Vec_ADSR_F     00E8 GR
  2 _dp_Vec_Music_     0038 GR  |   2 _dp_Vec_Music_     0076 GR
  2 _dp_Vec_Music_     00C6 GR  |   2 _dp_Vec_Music_     00F8 GR
  2 _dp_Vec_Snd_sh     0000 GR  |   2 _dp_Vec_TWANG_     00B6 GR

ASxxxx Assembler V05.00  (Motorola 6809), page 2.
Hexidecimal [16-Bits]

Area Table

[_CSEG]
   0 _CODE            size    0   flags C080
[_DSEG]
   1 _DATA            size    0   flags C0C0
[page_00]
   2 direct           size   F9   flags 8584

