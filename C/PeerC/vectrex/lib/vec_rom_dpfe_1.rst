                              1 ;;; gcc for m6809 : Mar 11 2019 13:34:05
                              2 ;;; 4.3.6 (gcc6809)
                              3 ;;; ABI version 1
                              4 ;;; -mabi=bx -mint8 -fomit-frame-pointer -O2
                              5 	.module	vec_rom_dpfe_1.c
                              6 ;----- asm -----
                              7 	.bank page_00 (BASE=0x0000,SIZE=0x0100)
                              8 	.area .direct (OVR,BANK=page_00)
                              9 	
                             10 ;--- end asm ---
                             11 	.globl	_dp_Vec_Snd_shadow
                             12 	.area	.direct
   0000                      13 _dp_Vec_Snd_shadow:
   0000 00 00 00 00 00 00    14 	.word	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00
   0020 00 00 00 00 00 00    15 	.word	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00
   0040 00 00 00 00 00 00    16 	.word	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00
   0060 00 00 00 00 00 00    17 	.word	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00
   0080 00 00 00 00 00 00    18 	.word	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00
   00A0 00 00 00 00 00 00    19 	.word	0,0,0,0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00
                             20 	.globl	_dp_Vec_TWANG_VIBENL
   00B6                      21 _dp_Vec_TWANG_VIBENL:
   00B6 00                   22 	.byte	0
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
   2 .direct          size   B7   flags 8584

