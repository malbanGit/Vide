                              1 ;;; gcc for m6809 : Mar 11 2019 13:34:05
                              2 ;;; 4.3.6 (gcc6809)
                              3 ;;; ABI version 1
                              4 ;;; -mabi=bx -mint8 -fomit-frame-pointer -O2
                              5 	.module	vec_rum_0xe7.c
                              6 ;----- asm -----
                              7 	.bank page_e7 (BASE=0xe7b5,SIZE=0x004b)
                              8 	.area .0xe7 (OVR,BANK=page_e7)
                              9 	
                             10 ;--- end asm ---
                             11 	.globl	___Displ8_xy
                             12 	.area	.0xe7
   E7B5                      13 ___Displ8_xy:
   E7B5 00 00 00 00 00 00    14 	.word	0,0,0,0,0,0,0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00
   E7D1 00                   15 	.byte	0
                             16 	.globl	___Displ16_xy
   E7D2                      17 ___Displ16_xy:
   E7D2 00                   18 	.byte	0
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

