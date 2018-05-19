                              1 
                              2 ;;; gcc for m6809 : Feb 15 2016 21:40:10
                              3 ;;; 4.3.6 (gcc6809)
                              4 ;;; ABI version 1
                              5 ;;; -mint8
                              6 	.module	vec_rum_0xe7.c
                              7 ;----- asm -----
                              8 	.bank page_e7 (BASE=0xe7b5,SIZE=0x004b)
                              9 	.area .0xe7 (OVR,BANK=page_e7)
                             10 	
                             11 ;--- end asm ---
                             12 	.globl ___Displ8_xy
                             13 	.area	.0xe7
   E7B5                      14 ___Displ8_xy:
   E7B5 00 00                15 	.word	0	;skip space 29
   E7B7 00 00                16 	.word	0	;skip space 27
   E7B9 00 00                17 	.word	0	;skip space 25
   E7BB 00 00                18 	.word	0	;skip space 23
   E7BD 00 00                19 	.word	0	;skip space 21
   E7BF 00 00                20 	.word	0	;skip space 19
   E7C1 00 00                21 	.word	0	;skip space 17
   E7C3 00 00                22 	.word	0	;skip space 15
   E7C5 00 00                23 	.word	0	;skip space 13
   E7C7 00 00                24 	.word	0	;skip space 11
   E7C9 00 00                25 	.word	0	;skip space 9
   E7CB 00 00                26 	.word	0	;skip space 7
   E7CD 00 00                27 	.word	0	;skip space 5
   E7CF 00 00                28 	.word	0	;skip space 3
   E7D1 00                   29 	.byte	0	;skip space
                             30 	.globl ___Displ16_xy
   E7D2                      31 ___Displ16_xy:
   E7D2 00                   32 	.byte	0	;skip space
ASxxxx Assembler V05.00  (Motorola 6809), page 1.
Hexidecimal [16-Bits]

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
  2 ___Displ16_xy      001D GR  |   2 ___Displ8_xy       0000 GR

ASxxxx Assembler V05.00  (Motorola 6809), page 2.
Hexidecimal [16-Bits]

Area Table

[_CSEG]
   0 _CODE            size    0   flags C080
[_DSEG]
   1 _DATA            size    0   flags C0C0
[page_e7]
   2 .0xe7            size   1E   flags 8584

