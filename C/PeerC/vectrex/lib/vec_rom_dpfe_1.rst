                              1 
                              2 ;;; gcc for m6809 : Feb 15 2016 21:40:10
                              3 ;;; 4.3.6 (gcc6809)
                              4 ;;; ABI version 1
                              5 ;;; -mint8
                              6 	.module	vec_rom_dpfe_1.c
                              7 ;----- asm -----
                              8 	.bank page_00 (BASE=0x0000,SIZE=0x0100)
                              9 	.area direct (OVR,BANK=page_00)
                             10 	
                             11 ;--- end asm ---
                             12 	.globl _dp_Vec_Snd_shadow
                             13 	.area	direct
   0000                      14 _dp_Vec_Snd_shadow:
   0000 00 00                15 	.word	0	;skip space 182
   0002 00 00                16 	.word	0	;skip space 180
   0004 00 00                17 	.word	0	;skip space 178
   0006 00 00                18 	.word	0	;skip space 176
   0008 00 00                19 	.word	0	;skip space 174
   000A 00 00                20 	.word	0	;skip space 172
   000C 00 00                21 	.word	0	;skip space 170
   000E 00 00                22 	.word	0	;skip space 168
   0010 00 00                23 	.word	0	;skip space 166
   0012 00 00                24 	.word	0	;skip space 164
   0014 00 00                25 	.word	0	;skip space 162
   0016 00 00                26 	.word	0	;skip space 160
   0018 00 00                27 	.word	0	;skip space 158
   001A 00 00                28 	.word	0	;skip space 156
   001C 00 00                29 	.word	0	;skip space 154
   001E 00 00                30 	.word	0	;skip space 152
   0020 00 00                31 	.word	0	;skip space 150
   0022 00 00                32 	.word	0	;skip space 148
   0024 00 00                33 	.word	0	;skip space 146
   0026 00 00                34 	.word	0	;skip space 144
   0028 00 00                35 	.word	0	;skip space 142
   002A 00 00                36 	.word	0	;skip space 140
   002C 00 00                37 	.word	0	;skip space 138
   002E 00 00                38 	.word	0	;skip space 136
   0030 00 00                39 	.word	0	;skip space 134
   0032 00 00                40 	.word	0	;skip space 132
   0034 00 00                41 	.word	0	;skip space 130
   0036 00 00                42 	.word	0	;skip space 128
   0038 00 00                43 	.word	0	;skip space 126
   003A 00 00                44 	.word	0	;skip space 124
   003C 00 00                45 	.word	0	;skip space 122
   003E 00 00                46 	.word	0	;skip space 120
   0040 00 00                47 	.word	0	;skip space 118
   0042 00 00                48 	.word	0	;skip space 116
   0044 00 00                49 	.word	0	;skip space 114
   0046 00 00                50 	.word	0	;skip space 112
   0048 00 00                51 	.word	0	;skip space 110
   004A 00 00                52 	.word	0	;skip space 108
   004C 00 00                53 	.word	0	;skip space 106
   004E 00 00                54 	.word	0	;skip space 104
   0050 00 00                55 	.word	0	;skip space 102
   0052 00 00                56 	.word	0	;skip space 100
   0054 00 00                57 	.word	0	;skip space 98
   0056 00 00                58 	.word	0	;skip space 96
   0058 00 00                59 	.word	0	;skip space 94
   005A 00 00                60 	.word	0	;skip space 92
   005C 00 00                61 	.word	0	;skip space 90
   005E 00 00                62 	.word	0	;skip space 88
   0060 00 00                63 	.word	0	;skip space 86
   0062 00 00                64 	.word	0	;skip space 84
   0064 00 00                65 	.word	0	;skip space 82
   0066 00 00                66 	.word	0	;skip space 80
   0068 00 00                67 	.word	0	;skip space 78
   006A 00 00                68 	.word	0	;skip space 76
   006C 00 00                69 	.word	0	;skip space 74
   006E 00 00                70 	.word	0	;skip space 72
   0070 00 00                71 	.word	0	;skip space 70
   0072 00 00                72 	.word	0	;skip space 68
   0074 00 00                73 	.word	0	;skip space 66
   0076 00 00                74 	.word	0	;skip space 64
   0078 00 00                75 	.word	0	;skip space 62
   007A 00 00                76 	.word	0	;skip space 60
   007C 00 00                77 	.word	0	;skip space 58
   007E 00 00                78 	.word	0	;skip space 56
   0080 00 00                79 	.word	0	;skip space 54
   0082 00 00                80 	.word	0	;skip space 52
   0084 00 00                81 	.word	0	;skip space 50
   0086 00 00                82 	.word	0	;skip space 48
   0088 00 00                83 	.word	0	;skip space 46
   008A 00 00                84 	.word	0	;skip space 44
   008C 00 00                85 	.word	0	;skip space 42
   008E 00 00                86 	.word	0	;skip space 40
   0090 00 00                87 	.word	0	;skip space 38
   0092 00 00                88 	.word	0	;skip space 36
   0094 00 00                89 	.word	0	;skip space 34
   0096 00 00                90 	.word	0	;skip space 32
   0098 00 00                91 	.word	0	;skip space 30
   009A 00 00                92 	.word	0	;skip space 28
   009C 00 00                93 	.word	0	;skip space 26
   009E 00 00                94 	.word	0	;skip space 24
   00A0 00 00                95 	.word	0	;skip space 22
   00A2 00 00                96 	.word	0	;skip space 20
   00A4 00 00                97 	.word	0	;skip space 18
   00A6 00 00                98 	.word	0	;skip space 16
   00A8 00 00                99 	.word	0	;skip space 14
   00AA 00 00               100 	.word	0	;skip space 12
   00AC 00 00               101 	.word	0	;skip space 10
   00AE 00 00               102 	.word	0	;skip space 8
   00B0 00 00               103 	.word	0	;skip space 6
   00B2 00 00               104 	.word	0	;skip space 4
   00B4 00 00               105 	.word	0	;skip space 2
                            106 	.globl _dp_Vec_TWANG_VIBENL
   00B6                     107 _dp_Vec_TWANG_VIBENL:
   00B6 00                  108 	.byte	0	;skip space
ASxxxx Assembler V05.00  (Motorola 6809), page 1.
Hexidecimal [16-Bits]

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
  2 _dp_Vec_Snd_sh     0000 GR  |   2 _dp_Vec_TWANG_     00B6 GR

ASxxxx Assembler V05.00  (Motorola 6809), page 2.
Hexidecimal [16-Bits]

Area Table

[_CSEG]
   0 _CODE            size    0   flags C080
[_DSEG]
   1 _DATA            size    0   flags C0C0
[page_00]
   2 direct           size   B7   flags 8584

