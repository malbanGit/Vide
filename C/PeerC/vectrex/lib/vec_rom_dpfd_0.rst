                              1 
                              2 ;;; gcc for m6809 : Feb 15 2016 21:40:10
                              3 ;;; 4.3.6 (gcc6809)
                              4 ;;; ABI version 1
                              5 ;;; -mint8
                              6 	.module	vec_rom_dpfd_0.c
                              7 ;----- asm -----
                              8 	.bank page_00 (BASE=0x0000,SIZE=0x0100)
                              9 	.area direct (OVR,BANK=page_00)
                             10 	
                             11 ;--- end asm ---
                             12 	.globl _dp_Vec_Snd_shadow
                             13 	.area	direct
   0000                      14 _dp_Vec_Snd_shadow:
   0000 00 00                15 	.word	0	;skip space 13
   0002 00 00                16 	.word	0	;skip space 11
   0004 00 00                17 	.word	0	;skip space 9
   0006 00 00                18 	.word	0	;skip space 7
   0008 00 00                19 	.word	0	;skip space 5
   000A 00 00                20 	.word	0	;skip space 3
   000C 00                   21 	.byte	0	;skip space
                             22 	.globl _dp_Vec_Music_1
   000D                      23 _dp_Vec_Music_1:
   000D 00 00                24 	.word	0	;skip space 16
   000F 00 00                25 	.word	0	;skip space 14
   0011 00 00                26 	.word	0	;skip space 12
   0013 00 00                27 	.word	0	;skip space 10
   0015 00 00                28 	.word	0	;skip space 8
   0017 00 00                29 	.word	0	;skip space 6
   0019 00 00                30 	.word	0	;skip space 4
   001B 00 00                31 	.word	0	;skip space 2
                             32 	.globl _dp_Vec_Music_2
   001D                      33 _dp_Vec_Music_2:
   001D 00 00                34 	.word	0	;skip space 76
   001F 00 00                35 	.word	0	;skip space 74
   0021 00 00                36 	.word	0	;skip space 72
   0023 00 00                37 	.word	0	;skip space 70
   0025 00 00                38 	.word	0	;skip space 68
   0027 00 00                39 	.word	0	;skip space 66
   0029 00 00                40 	.word	0	;skip space 64
   002B 00 00                41 	.word	0	;skip space 62
   002D 00 00                42 	.word	0	;skip space 60
   002F 00 00                43 	.word	0	;skip space 58
   0031 00 00                44 	.word	0	;skip space 56
   0033 00 00                45 	.word	0	;skip space 54
   0035 00 00                46 	.word	0	;skip space 52
   0037 00 00                47 	.word	0	;skip space 50
   0039 00 00                48 	.word	0	;skip space 48
   003B 00 00                49 	.word	0	;skip space 46
   003D 00 00                50 	.word	0	;skip space 44
   003F 00 00                51 	.word	0	;skip space 42
   0041 00 00                52 	.word	0	;skip space 40
   0043 00 00                53 	.word	0	;skip space 38
   0045 00 00                54 	.word	0	;skip space 36
   0047 00 00                55 	.word	0	;skip space 34
   0049 00 00                56 	.word	0	;skip space 32
   004B 00 00                57 	.word	0	;skip space 30
   004D 00 00                58 	.word	0	;skip space 28
   004F 00 00                59 	.word	0	;skip space 26
   0051 00 00                60 	.word	0	;skip space 24
   0053 00 00                61 	.word	0	;skip space 22
   0055 00 00                62 	.word	0	;skip space 20
   0057 00 00                63 	.word	0	;skip space 18
   0059 00 00                64 	.word	0	;skip space 16
   005B 00 00                65 	.word	0	;skip space 14
   005D 00 00                66 	.word	0	;skip space 12
   005F 00 00                67 	.word	0	;skip space 10
   0061 00 00                68 	.word	0	;skip space 8
   0063 00 00                69 	.word	0	;skip space 6
   0065 00 00                70 	.word	0	;skip space 4
   0067 00 00                71 	.word	0	;skip space 2
                             72 	.globl _dp_Vec_ADSR_FADE0
   0069                      73 _dp_Vec_ADSR_FADE0:
   0069 00 00                74 	.word	0	;skip space 16
   006B 00 00                75 	.word	0	;skip space 14
   006D 00 00                76 	.word	0	;skip space 12
   006F 00 00                77 	.word	0	;skip space 10
   0071 00 00                78 	.word	0	;skip space 8
   0073 00 00                79 	.word	0	;skip space 6
   0075 00 00                80 	.word	0	;skip space 4
   0077 00 00                81 	.word	0	;skip space 2
                             82 	.globl _dp_Vec_TWANG_VIBE0
   0079                      83 _dp_Vec_TWANG_VIBE0:
   0079 00 00                84 	.word	0	;skip space 8
   007B 00 00                85 	.word	0	;skip space 6
   007D 00 00                86 	.word	0	;skip space 4
   007F 00 00                87 	.word	0	;skip space 2
                             88 	.globl _dp_Vec_Music_3
   0081                      89 _dp_Vec_Music_3:
   0081 00 00                90 	.word	0	;skip space 66
   0083 00 00                91 	.word	0	;skip space 64
   0085 00 00                92 	.word	0	;skip space 62
   0087 00 00                93 	.word	0	;skip space 60
   0089 00 00                94 	.word	0	;skip space 58
   008B 00 00                95 	.word	0	;skip space 56
   008D 00 00                96 	.word	0	;skip space 54
   008F 00 00                97 	.word	0	;skip space 52
   0091 00 00                98 	.word	0	;skip space 50
   0093 00 00                99 	.word	0	;skip space 48
   0095 00 00               100 	.word	0	;skip space 46
   0097 00 00               101 	.word	0	;skip space 44
   0099 00 00               102 	.word	0	;skip space 42
   009B 00 00               103 	.word	0	;skip space 40
   009D 00 00               104 	.word	0	;skip space 38
   009F 00 00               105 	.word	0	;skip space 36
   00A1 00 00               106 	.word	0	;skip space 34
   00A3 00 00               107 	.word	0	;skip space 32
   00A5 00 00               108 	.word	0	;skip space 30
   00A7 00 00               109 	.word	0	;skip space 28
   00A9 00 00               110 	.word	0	;skip space 26
   00AB 00 00               111 	.word	0	;skip space 24
   00AD 00 00               112 	.word	0	;skip space 22
   00AF 00 00               113 	.word	0	;skip space 20
   00B1 00 00               114 	.word	0	;skip space 18
   00B3 00 00               115 	.word	0	;skip space 16
   00B5 00 00               116 	.word	0	;skip space 14
   00B7 00 00               117 	.word	0	;skip space 12
   00B9 00 00               118 	.word	0	;skip space 10
   00BB 00 00               119 	.word	0	;skip space 8
   00BD 00 00               120 	.word	0	;skip space 6
   00BF 00 00               121 	.word	0	;skip space 4
   00C1 00 00               122 	.word	0	;skip space 2
                            123 	.globl _dp_Vec_ADSR_FADE12
   00C3                     124 _dp_Vec_ADSR_FADE12:
   00C3 00 00               125 	.word	0	;skip space 16
   00C5 00 00               126 	.word	0	;skip space 14
   00C7 00 00               127 	.word	0	;skip space 12
   00C9 00 00               128 	.word	0	;skip space 10
   00CB 00 00               129 	.word	0	;skip space 8
   00CD 00 00               130 	.word	0	;skip space 6
   00CF 00 00               131 	.word	0	;skip space 4
   00D1 00 00               132 	.word	0	;skip space 2
                            133 	.globl _dp_Vec_Music_4
   00D3                     134 _dp_Vec_Music_4:
   00D3 00                  135 	.byte	0	;skip space
ASxxxx Assembler V05.00  (Motorola 6809), page 1.
Hexidecimal [16-Bits]

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
  2 _dp_Vec_ADSR_F     0069 GR  |   2 _dp_Vec_ADSR_F     00C3 GR
  2 _dp_Vec_Music_     000D GR  |   2 _dp_Vec_Music_     001D GR
  2 _dp_Vec_Music_     0081 GR  |   2 _dp_Vec_Music_     00D3 GR
  2 _dp_Vec_Snd_sh     0000 GR  |   2 _dp_Vec_TWANG_     0079 GR

ASxxxx Assembler V05.00  (Motorola 6809), page 2.
Hexidecimal [16-Bits]

Area Table

[_CSEG]
   0 _CODE            size    0   flags C080
[_DSEG]
   1 _DATA            size    0   flags C0C0
[page_00]
   2 direct           size   D4   flags 8584

