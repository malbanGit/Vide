                              1 ;;; gcc for m6809 : Mar 11 2019 13:34:05
                              2 ;;; 4.3.6 (gcc6809)
                              3 ;;; ABI version 1
                              4 ;;; -mabi=bx -mint8 -fomit-frame-pointer -O2
                              5 	.module	vec_ram_dpc8_2.c
                              6 ;----- asm -----
                              7 	.bank page_00 (BASE=0x0000,SIZE=0x0100)
                              8 	.area .direct (OVR,BANK=page_00)
                              9 	
                             10 ;--- end asm ---
                             11 	.globl	_dp_Vec_Snd_shadow
                             12 	.area	.direct
   0000                      13 _dp_Vec_Snd_shadow:
   0000 00 00 00 00 00 00    14 	.word	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
   001E 00                   15 	.byte	0
                             16 	.globl	_dp_Vec_Joy_Mux
   001F                      17 _dp_Vec_Joy_Mux:
   001F 00 00 00 00 00 00    18 	.word	0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00
   002D 00                   19 	.byte	0
                             20 	.globl	_dp_Vec_Counters
   002E                      21 _dp_Vec_Counters:
   002E 00 00 00 00 00 00    22 	.word	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00
   004E 00 00 00 00 00 00    23 	.word	0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00
                             24 	.globl	_dp_Vec_XXX_09
   005E                      25 _dp_Vec_XXX_09:
   005E 00                   26 	.byte	0
ASxxxx Assembler V05.00  (Motorola 6809), page 1.
Hexidecimal [16-Bits]

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
  2 _dp_Vec_Counte     002E GR  |   2 _dp_Vec_Joy_Mu     001F GR
  2 _dp_Vec_Snd_sh     0000 GR  |   2 _dp_Vec_XXX_09     005E GR

ASxxxx Assembler V05.00  (Motorola 6809), page 2.
Hexidecimal [16-Bits]

Area Table

[_CSEG]
   0 _CODE            size    0   flags C080
[_DSEG]
   1 _DATA            size    0   flags C0C0
[page_00]
   2 .direct          size   5F   flags 8584

