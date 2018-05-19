                              1 
                              2 ;;; gcc for m6809 : Feb 15 2016 21:40:10
                              3 ;;; 4.3.6 (gcc6809)
                              4 ;;; ABI version 1
                              5 ;;; -mint8
                              6 	.module	vec_ram_dpcb_3.c
                              7 ;----- asm -----
                              8 	.bank page_00 (BASE=0x0000,SIZE=0x0100)
                              9 	.area direct (OVR,BANK=page_00)
                             10 	
                             11 ;--- end asm ---
                             12 	.globl _dp_Vec_Snd_shadow
                             13 	.area	direct
   0000                      14 _dp_Vec_Snd_shadow:
   0000 00 00                15 	.word	0	;skip space 242
   0002 00 00                16 	.word	0	;skip space 240
   0004 00 00                17 	.word	0	;skip space 238
   0006 00 00                18 	.word	0	;skip space 236
   0008 00 00                19 	.word	0	;skip space 234
   000A 00 00                20 	.word	0	;skip space 232
   000C 00 00                21 	.word	0	;skip space 230
   000E 00 00                22 	.word	0	;skip space 228
   0010 00 00                23 	.word	0	;skip space 226
   0012 00 00                24 	.word	0	;skip space 224
   0014 00 00                25 	.word	0	;skip space 222
   0016 00 00                26 	.word	0	;skip space 220
   0018 00 00                27 	.word	0	;skip space 218
   001A 00 00                28 	.word	0	;skip space 216
   001C 00 00                29 	.word	0	;skip space 214
   001E 00 00                30 	.word	0	;skip space 212
   0020 00 00                31 	.word	0	;skip space 210
   0022 00 00                32 	.word	0	;skip space 208
   0024 00 00                33 	.word	0	;skip space 206
   0026 00 00                34 	.word	0	;skip space 204
   0028 00 00                35 	.word	0	;skip space 202
   002A 00 00                36 	.word	0	;skip space 200
   002C 00 00                37 	.word	0	;skip space 198
   002E 00 00                38 	.word	0	;skip space 196
   0030 00 00                39 	.word	0	;skip space 194
   0032 00 00                40 	.word	0	;skip space 192
   0034 00 00                41 	.word	0	;skip space 190
   0036 00 00                42 	.word	0	;skip space 188
   0038 00 00                43 	.word	0	;skip space 186
   003A 00 00                44 	.word	0	;skip space 184
   003C 00 00                45 	.word	0	;skip space 182
   003E 00 00                46 	.word	0	;skip space 180
   0040 00 00                47 	.word	0	;skip space 178
   0042 00 00                48 	.word	0	;skip space 176
   0044 00 00                49 	.word	0	;skip space 174
   0046 00 00                50 	.word	0	;skip space 172
   0048 00 00                51 	.word	0	;skip space 170
   004A 00 00                52 	.word	0	;skip space 168
   004C 00 00                53 	.word	0	;skip space 166
   004E 00 00                54 	.word	0	;skip space 164
   0050 00 00                55 	.word	0	;skip space 162
   0052 00 00                56 	.word	0	;skip space 160
   0054 00 00                57 	.word	0	;skip space 158
   0056 00 00                58 	.word	0	;skip space 156
   0058 00 00                59 	.word	0	;skip space 154
   005A 00 00                60 	.word	0	;skip space 152
   005C 00 00                61 	.word	0	;skip space 150
   005E 00 00                62 	.word	0	;skip space 148
   0060 00 00                63 	.word	0	;skip space 146
   0062 00 00                64 	.word	0	;skip space 144
   0064 00 00                65 	.word	0	;skip space 142
   0066 00 00                66 	.word	0	;skip space 140
   0068 00 00                67 	.word	0	;skip space 138
   006A 00 00                68 	.word	0	;skip space 136
   006C 00 00                69 	.word	0	;skip space 134
   006E 00 00                70 	.word	0	;skip space 132
   0070 00 00                71 	.word	0	;skip space 130
   0072 00 00                72 	.word	0	;skip space 128
   0074 00 00                73 	.word	0	;skip space 126
   0076 00 00                74 	.word	0	;skip space 124
   0078 00 00                75 	.word	0	;skip space 122
   007A 00 00                76 	.word	0	;skip space 120
   007C 00 00                77 	.word	0	;skip space 118
   007E 00 00                78 	.word	0	;skip space 116
   0080 00 00                79 	.word	0	;skip space 114
   0082 00 00                80 	.word	0	;skip space 112
   0084 00 00                81 	.word	0	;skip space 110
   0086 00 00                82 	.word	0	;skip space 108
   0088 00 00                83 	.word	0	;skip space 106
   008A 00 00                84 	.word	0	;skip space 104
   008C 00 00                85 	.word	0	;skip space 102
   008E 00 00                86 	.word	0	;skip space 100
   0090 00 00                87 	.word	0	;skip space 98
   0092 00 00                88 	.word	0	;skip space 96
   0094 00 00                89 	.word	0	;skip space 94
   0096 00 00                90 	.word	0	;skip space 92
   0098 00 00                91 	.word	0	;skip space 90
   009A 00 00                92 	.word	0	;skip space 88
   009C 00 00                93 	.word	0	;skip space 86
   009E 00 00                94 	.word	0	;skip space 84
   00A0 00 00                95 	.word	0	;skip space 82
   00A2 00 00                96 	.word	0	;skip space 80
   00A4 00 00                97 	.word	0	;skip space 78
   00A6 00 00                98 	.word	0	;skip space 76
   00A8 00 00                99 	.word	0	;skip space 74
   00AA 00 00               100 	.word	0	;skip space 72
   00AC 00 00               101 	.word	0	;skip space 70
   00AE 00 00               102 	.word	0	;skip space 68
   00B0 00 00               103 	.word	0	;skip space 66
   00B2 00 00               104 	.word	0	;skip space 64
   00B4 00 00               105 	.word	0	;skip space 62
   00B6 00 00               106 	.word	0	;skip space 60
   00B8 00 00               107 	.word	0	;skip space 58
   00BA 00 00               108 	.word	0	;skip space 56
   00BC 00 00               109 	.word	0	;skip space 54
   00BE 00 00               110 	.word	0	;skip space 52
   00C0 00 00               111 	.word	0	;skip space 50
   00C2 00 00               112 	.word	0	;skip space 48
   00C4 00 00               113 	.word	0	;skip space 46
   00C6 00 00               114 	.word	0	;skip space 44
   00C8 00 00               115 	.word	0	;skip space 42
   00CA 00 00               116 	.word	0	;skip space 40
   00CC 00 00               117 	.word	0	;skip space 38
   00CE 00 00               118 	.word	0	;skip space 36
   00D0 00 00               119 	.word	0	;skip space 34
   00D2 00 00               120 	.word	0	;skip space 32
   00D4 00 00               121 	.word	0	;skip space 30
   00D6 00 00               122 	.word	0	;skip space 28
   00D8 00 00               123 	.word	0	;skip space 26
   00DA 00 00               124 	.word	0	;skip space 24
   00DC 00 00               125 	.word	0	;skip space 22
   00DE 00 00               126 	.word	0	;skip space 20
   00E0 00 00               127 	.word	0	;skip space 18
   00E2 00 00               128 	.word	0	;skip space 16
   00E4 00 00               129 	.word	0	;skip space 14
   00E6 00 00               130 	.word	0	;skip space 12
   00E8 00 00               131 	.word	0	;skip space 10
   00EA 00 00               132 	.word	0	;skip space 8
   00EC 00 00               133 	.word	0	;skip space 6
   00EE 00 00               134 	.word	0	;skip space 4
   00F0 00 00               135 	.word	0	;skip space 2
                            136 	.globl _dp_Vec_SWI2_vector
   00F2                     137 _dp_Vec_SWI2_vector:
   00F2 00 00               138 	.word	0	;skip space 9
   00F4 00 00               139 	.word	0	;skip space 7
   00F6 00 00               140 	.word	0	;skip space 5
   00F8 00 00               141 	.word	0	;skip space 3
   00FA 00                  142 	.byte	0	;skip space
                            143 	.globl _dp_Vec_NWI_vector
   00FB                     144 _dp_Vec_NWI_vector:
   00FB 00 00               145 	.word	0	;skip space 3
   00FD 00                  146 	.byte	0	;skip space
ASxxxx Assembler V05.00  (Motorola 6809), page 1.
Hexidecimal [16-Bits]

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
  2 _dp_Vec_NWI_ve     00FB GR  |   2 _dp_Vec_SWI2_v     00F2 GR
  2 _dp_Vec_Snd_sh     0000 GR

ASxxxx Assembler V05.00  (Motorola 6809), page 2.
Hexidecimal [16-Bits]

Area Table

[_CSEG]
   0 _CODE            size    0   flags C080
[_DSEG]
   1 _DATA            size    0   flags C0C0
[page_00]
   2 direct           size   FE   flags 8584

