                              1 ;;; gcc for m6809 : Mar 17 2019 13:25:32
                              2 ;;; 4.3.6 (gcc6809)
                              3 ;;; ABI version 1
                              4 ;;; -mabi=bx -mint8 -fomit-frame-pointer -O0
                              5 	.module	vec_ram_0xc8_2.c
                              6 ;----- asm -----
                              7 	.bank page_c8 (BASE=0xc800,SIZE=0x0080)
                              8 	.area .dpc8 (OVR,BANK=page_c8)
                              9 	
                             10 ;--- end asm ---
                             11 	.globl	_Vec_Snd_shadow
                             12 	.area	.dpc8
   C800                      13 _Vec_Snd_shadow:
   C800 00 00 00 00 00 00    14 	.word	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
   C81E 00                   15 	.byte	0
                             16 	.globl	_Vec_Joy_Mux
   C81F                      17 _Vec_Joy_Mux:
   C81F 00 00 00 00 00 00    18 	.word	0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00
   C82D 00                   19 	.byte	0
                             20 	.globl	_Vec_Counters
   C82E                      21 _Vec_Counters:
   C82E 00 00 00 00 00 00    22 	.word	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00
   C84E 00 00 00 00 00 00    23 	.word	0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00
                             24 	.globl	_Vec_XXX_09
   C85E                      25 _Vec_XXX_09:
   C85E 00                   26 	.byte	0
ASxxxx Assembler V05.31  (Motorola 6809)                                Page 1
Hexadecimal [16-Bits]                                 Thu Jan 30 13:14:27 2020

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
  2 _Vec_Counters      002E GR  |   2 _Vec_Joy_Mux       001F GR
  2 _Vec_Snd_shado     0000 GR  |   2 _Vec_XXX_09        005E GR

ASxxxx Assembler V05.31  (Motorola 6809)                                Page 2
Hexadecimal [16-Bits]                                 Thu Jan 30 13:14:27 2020

Area Table

[_CSEG]
   0 _CODE            size    0   flags C080
[_DSEG]
   1 _DATA            size    0   flags C0C0
[page_c8]
   2 .dpc8            size   5F   flags 8584

