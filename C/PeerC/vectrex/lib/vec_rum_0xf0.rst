                              1 
                              2 ;;; gcc for m6809 : Feb 15 2016 21:40:10
                              3 ;;; 4.3.6 (gcc6809)
                              4 ;;; ABI version 1
                              5 ;;; -mint8
                              6 	.module	vec_rum_0xf0.c
                              7 ;----- asm -----
                              8 	.bank page_f0 (BASE=0xf000,SIZE=0x0100)
                              9 	.area .0xf0 (OVR,BANK=page_f0)
                             10 	
                             11 ;--- end asm ---
                             12 	.globl ___Reset
                             13 	.area	.0xf0
   F000                      14 ___Reset:
   F000 00                   15 	.byte	0	;skip space
ASxxxx Assembler V05.00  (Motorola 6809), page 1.
Hexidecimal [16-Bits]

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
  2 ___Reset           0000 GR

ASxxxx Assembler V05.00  (Motorola 6809), page 2.
Hexidecimal [16-Bits]

Area Table

[_CSEG]
   0 _CODE            size    0   flags C080
[_DSEG]
   1 _DATA            size    0   flags C0C0
[page_f0]
   2 .0xf0            size    1   flags 8584

