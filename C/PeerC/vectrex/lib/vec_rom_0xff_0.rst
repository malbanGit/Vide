                              1 
                              2 ;;; gcc for m6809 : Feb 15 2016 21:40:10
                              3 ;;; 4.3.6 (gcc6809)
                              4 ;;; ABI version 1
                              5 ;;; -mint8
                              6 	.module	vec_rom_0xff_0.c
                              7 ;----- asm -----
                              8 	.bank page_ff(BASE=0xff16,SIZE=0x00A0)
                              9 	.area .dpff (OVR,BANK=page_ff)
                             10 	
                             11 ;--- end asm ---
                             12 	.globl _Vec_ADSR_FADE8
                             13 	.area	.dpff
   FF16                      14 _Vec_ADSR_FADE8:
   FF16 00 00                15 	.word	0	;skip space 16
   FF18 00 00                16 	.word	0	;skip space 14
   FF1A 00 00                17 	.word	0	;skip space 12
   FF1C 00 00                18 	.word	0	;skip space 10
   FF1E 00 00                19 	.word	0	;skip space 8
   FF20 00 00                20 	.word	0	;skip space 6
   FF22 00 00                21 	.word	0	;skip space 4
   FF24 00 00                22 	.word	0	;skip space 2
                             23 	.globl _Vec_Music_9
   FF26                      24 _Vec_Music_9:
   FF26 00 00                25 	.word	0	;skip space 30
   FF28 00 00                26 	.word	0	;skip space 28
   FF2A 00 00                27 	.word	0	;skip space 26
   FF2C 00 00                28 	.word	0	;skip space 24
   FF2E 00 00                29 	.word	0	;skip space 22
   FF30 00 00                30 	.word	0	;skip space 20
   FF32 00 00                31 	.word	0	;skip space 18
   FF34 00 00                32 	.word	0	;skip space 16
   FF36 00 00                33 	.word	0	;skip space 14
   FF38 00 00                34 	.word	0	;skip space 12
   FF3A 00 00                35 	.word	0	;skip space 10
   FF3C 00 00                36 	.word	0	;skip space 8
   FF3E 00 00                37 	.word	0	;skip space 6
   FF40 00 00                38 	.word	0	;skip space 4
   FF42 00 00                39 	.word	0	;skip space 2
                             40 	.globl _Vec_Music_a
   FF44                      41 _Vec_Music_a:
   FF44 00 00                42 	.word	0	;skip space 30
   FF46 00 00                43 	.word	0	;skip space 28
   FF48 00 00                44 	.word	0	;skip space 26
   FF4A 00 00                45 	.word	0	;skip space 24
   FF4C 00 00                46 	.word	0	;skip space 22
   FF4E 00 00                47 	.word	0	;skip space 20
   FF50 00 00                48 	.word	0	;skip space 18
   FF52 00 00                49 	.word	0	;skip space 16
   FF54 00 00                50 	.word	0	;skip space 14
   FF56 00 00                51 	.word	0	;skip space 12
   FF58 00 00                52 	.word	0	;skip space 10
   FF5A 00 00                53 	.word	0	;skip space 8
   FF5C 00 00                54 	.word	0	;skip space 6
   FF5E 00 00                55 	.word	0	;skip space 4
   FF60 00 00                56 	.word	0	;skip space 2
                             57 	.globl _Vec_Music_b
   FF62                      58 _Vec_Music_b:
   FF62 00 00                59 	.word	0	;skip space 24
   FF64 00 00                60 	.word	0	;skip space 22
   FF66 00 00                61 	.word	0	;skip space 20
   FF68 00 00                62 	.word	0	;skip space 18
   FF6A 00 00                63 	.word	0	;skip space 16
   FF6C 00 00                64 	.word	0	;skip space 14
   FF6E 00 00                65 	.word	0	;skip space 12
   FF70 00 00                66 	.word	0	;skip space 10
   FF72 00 00                67 	.word	0	;skip space 8
   FF74 00 00                68 	.word	0	;skip space 6
   FF76 00 00                69 	.word	0	;skip space 4
   FF78 00 00                70 	.word	0	;skip space 2
                             71 	.globl _Vec_Music_c
   FF7A                      72 _Vec_Music_c:
   FF7A 00 00                73 	.word	0	;skip space 21
   FF7C 00 00                74 	.word	0	;skip space 19
   FF7E 00 00                75 	.word	0	;skip space 17
   FF80 00 00                76 	.word	0	;skip space 15
   FF82 00 00                77 	.word	0	;skip space 13
   FF84 00 00                78 	.word	0	;skip space 11
   FF86 00 00                79 	.word	0	;skip space 9
   FF88 00 00                80 	.word	0	;skip space 7
   FF8A 00 00                81 	.word	0	;skip space 5
   FF8C 00 00                82 	.word	0	;skip space 3
   FF8E 00                   83 	.byte	0	;skip space
                             84 	.globl _Vec_Music_d
   FF8F                      85 _Vec_Music_d:
   FF8F 00                   86 	.byte	0	;skip space
ASxxxx Assembler V05.00  (Motorola 6809), page 1.
Hexidecimal [16-Bits]

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
  2 _Vec_ADSR_FADE     0000 GR  |   2 _Vec_Music_9       0010 GR
  2 _Vec_Music_a       002E GR  |   2 _Vec_Music_b       004C GR
  2 _Vec_Music_c       0064 GR  |   2 _Vec_Music_d       0079 GR

ASxxxx Assembler V05.00  (Motorola 6809), page 2.
Hexidecimal [16-Bits]

Area Table

[_CSEG]
   0 _CODE            size    0   flags C080
[_DSEG]
   1 _DATA            size    0   flags C0C0
[page_ff]
   2 .dpff            size   7A   flags 8584

