                              1 
                              2 ;;; gcc for m6809 : Feb 15 2016 21:40:10
                              3 ;;; 4.3.6 (gcc6809)
                              4 ;;; ABI version 1
                              5 ;;; -mint8
                              6 	.module	vec_rom_0xfd_0.c
                              7 ;----- asm -----
                              8 	.bank page_fd (BASE=0xfd0d,SIZE=0x0100)
                              9 	.area .dpfd (OVR,BANK=page_fd)
                             10 	
                             11 ;--- end asm ---
                             12 	.globl _Vec_Music_1
                             13 	.area	.dpfd
   FD0D                      14 _Vec_Music_1:
   FD0D 00 00                15 	.word	0	;skip space 16
   FD0F 00 00                16 	.word	0	;skip space 14
   FD11 00 00                17 	.word	0	;skip space 12
   FD13 00 00                18 	.word	0	;skip space 10
   FD15 00 00                19 	.word	0	;skip space 8
   FD17 00 00                20 	.word	0	;skip space 6
   FD19 00 00                21 	.word	0	;skip space 4
   FD1B 00 00                22 	.word	0	;skip space 2
                             23 	.globl _Vec_Music_2
   FD1D                      24 _Vec_Music_2:
   FD1D 00 00                25 	.word	0	;skip space 76
   FD1F 00 00                26 	.word	0	;skip space 74
   FD21 00 00                27 	.word	0	;skip space 72
   FD23 00 00                28 	.word	0	;skip space 70
   FD25 00 00                29 	.word	0	;skip space 68
   FD27 00 00                30 	.word	0	;skip space 66
   FD29 00 00                31 	.word	0	;skip space 64
   FD2B 00 00                32 	.word	0	;skip space 62
   FD2D 00 00                33 	.word	0	;skip space 60
   FD2F 00 00                34 	.word	0	;skip space 58
   FD31 00 00                35 	.word	0	;skip space 56
   FD33 00 00                36 	.word	0	;skip space 54
   FD35 00 00                37 	.word	0	;skip space 52
   FD37 00 00                38 	.word	0	;skip space 50
   FD39 00 00                39 	.word	0	;skip space 48
   FD3B 00 00                40 	.word	0	;skip space 46
   FD3D 00 00                41 	.word	0	;skip space 44
   FD3F 00 00                42 	.word	0	;skip space 42
   FD41 00 00                43 	.word	0	;skip space 40
   FD43 00 00                44 	.word	0	;skip space 38
   FD45 00 00                45 	.word	0	;skip space 36
   FD47 00 00                46 	.word	0	;skip space 34
   FD49 00 00                47 	.word	0	;skip space 32
   FD4B 00 00                48 	.word	0	;skip space 30
   FD4D 00 00                49 	.word	0	;skip space 28
   FD4F 00 00                50 	.word	0	;skip space 26
   FD51 00 00                51 	.word	0	;skip space 24
   FD53 00 00                52 	.word	0	;skip space 22
   FD55 00 00                53 	.word	0	;skip space 20
   FD57 00 00                54 	.word	0	;skip space 18
   FD59 00 00                55 	.word	0	;skip space 16
   FD5B 00 00                56 	.word	0	;skip space 14
   FD5D 00 00                57 	.word	0	;skip space 12
   FD5F 00 00                58 	.word	0	;skip space 10
   FD61 00 00                59 	.word	0	;skip space 8
   FD63 00 00                60 	.word	0	;skip space 6
   FD65 00 00                61 	.word	0	;skip space 4
   FD67 00 00                62 	.word	0	;skip space 2
                             63 	.globl _Vec_ADSR_FADE0
   FD69                      64 _Vec_ADSR_FADE0:
   FD69 00 00                65 	.word	0	;skip space 16
   FD6B 00 00                66 	.word	0	;skip space 14
   FD6D 00 00                67 	.word	0	;skip space 12
   FD6F 00 00                68 	.word	0	;skip space 10
   FD71 00 00                69 	.word	0	;skip space 8
   FD73 00 00                70 	.word	0	;skip space 6
   FD75 00 00                71 	.word	0	;skip space 4
   FD77 00 00                72 	.word	0	;skip space 2
                             73 	.globl _Vec_TWANG_VIBE0
   FD79                      74 _Vec_TWANG_VIBE0:
   FD79 00 00                75 	.word	0	;skip space 8
   FD7B 00 00                76 	.word	0	;skip space 6
   FD7D 00 00                77 	.word	0	;skip space 4
   FD7F 00 00                78 	.word	0	;skip space 2
                             79 	.globl _Vec_Music_3
   FD81                      80 _Vec_Music_3:
   FD81 00 00                81 	.word	0	;skip space 66
   FD83 00 00                82 	.word	0	;skip space 64
   FD85 00 00                83 	.word	0	;skip space 62
   FD87 00 00                84 	.word	0	;skip space 60
   FD89 00 00                85 	.word	0	;skip space 58
   FD8B 00 00                86 	.word	0	;skip space 56
   FD8D 00 00                87 	.word	0	;skip space 54
   FD8F 00 00                88 	.word	0	;skip space 52
   FD91 00 00                89 	.word	0	;skip space 50
   FD93 00 00                90 	.word	0	;skip space 48
   FD95 00 00                91 	.word	0	;skip space 46
   FD97 00 00                92 	.word	0	;skip space 44
   FD99 00 00                93 	.word	0	;skip space 42
   FD9B 00 00                94 	.word	0	;skip space 40
   FD9D 00 00                95 	.word	0	;skip space 38
   FD9F 00 00                96 	.word	0	;skip space 36
   FDA1 00 00                97 	.word	0	;skip space 34
   FDA3 00 00                98 	.word	0	;skip space 32
   FDA5 00 00                99 	.word	0	;skip space 30
   FDA7 00 00               100 	.word	0	;skip space 28
   FDA9 00 00               101 	.word	0	;skip space 26
   FDAB 00 00               102 	.word	0	;skip space 24
   FDAD 00 00               103 	.word	0	;skip space 22
   FDAF 00 00               104 	.word	0	;skip space 20
   FDB1 00 00               105 	.word	0	;skip space 18
   FDB3 00 00               106 	.word	0	;skip space 16
   FDB5 00 00               107 	.word	0	;skip space 14
   FDB7 00 00               108 	.word	0	;skip space 12
   FDB9 00 00               109 	.word	0	;skip space 10
   FDBB 00 00               110 	.word	0	;skip space 8
   FDBD 00 00               111 	.word	0	;skip space 6
   FDBF 00 00               112 	.word	0	;skip space 4
   FDC1 00 00               113 	.word	0	;skip space 2
                            114 	.globl _Vec_ADSR_FADE12
   FDC3                     115 _Vec_ADSR_FADE12:
   FDC3 00 00               116 	.word	0	;skip space 16
   FDC5 00 00               117 	.word	0	;skip space 14
   FDC7 00 00               118 	.word	0	;skip space 12
   FDC9 00 00               119 	.word	0	;skip space 10
   FDCB 00 00               120 	.word	0	;skip space 8
   FDCD 00 00               121 	.word	0	;skip space 6
   FDCF 00 00               122 	.word	0	;skip space 4
   FDD1 00 00               123 	.word	0	;skip space 2
                            124 	.globl _Vec_Music_4
   FDD3                     125 _Vec_Music_4:
   FDD3 00                  126 	.byte	0	;skip space
ASxxxx Assembler V05.00  (Motorola 6809), page 1.
Hexidecimal [16-Bits]

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
  2 _Vec_ADSR_FADE     005C GR  |   2 _Vec_ADSR_FADE     00B6 GR
  2 _Vec_Music_1       0000 GR  |   2 _Vec_Music_2       0010 GR
  2 _Vec_Music_3       0074 GR  |   2 _Vec_Music_4       00C6 GR
  2 _Vec_TWANG_VIB     006C GR

ASxxxx Assembler V05.00  (Motorola 6809), page 2.
Hexidecimal [16-Bits]

Area Table

[_CSEG]
   0 _CODE            size    0   flags C080
[_DSEG]
   1 _DATA            size    0   flags C0C0
[page_fd]
   2 .dpfd            size   C7   flags 8584

