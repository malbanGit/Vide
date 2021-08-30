                              1 ;;; gcc for m6809 : Mar 17 2019 13:25:32
                              2 ;;; 4.3.6 (gcc6809)
                              3 ;;; ABI version 1
                              4 ;;; -mabi=bx -mint8 -fomit-frame-pointer -O0
                              5 	.module	vec_rum_0xe9.c
                              6 ;----- asm -----
                              7 	.bank page_e9 (BASE=0xe98a,SIZE=0x0076)
                              8 	.area .0xe9 (OVR,BANK=page_e9)
                              9 	
                             10 ;--- end asm ---
                             11 	.globl	___Ranpos
                             12 	.area	.0xe9
   E98A                      13 ___Ranpos:
   E98A 00 00                14 	.word	0
ASxxxx Assembler V05.31  (Motorola 6809)                                Page 1
Hexadecimal [16-Bits]                                 Thu Jan 30 13:14:28 2020

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
  2 ___Ranpos          0000 GR

ASxxxx Assembler V05.31  (Motorola 6809)                                Page 2
Hexadecimal [16-Bits]                                 Thu Jan 30 13:14:28 2020

Area Table

[_CSEG]
   0 _CODE            size    0   flags C080
[_DSEG]
   1 _DATA            size    0   flags C0C0
[page_e9]
   2 .0xe9            size    2   flags 8584

