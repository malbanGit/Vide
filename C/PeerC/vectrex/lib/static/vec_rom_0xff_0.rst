                              1 ;;; gcc for m6809 : Mar 17 2019 13:25:32
                              2 ;;; 4.3.6 (gcc6809)
                              3 ;;; ABI version 1
                              4 ;;; -mabi=bx -mint8 -fomit-frame-pointer -O0
                              5 	.module	vec_rom_0xff_0.c
                              6 ;----- asm -----
                              7 	.bank page_ff(BASE=0xff16,SIZE=0x00A0)
                              8 	.area .dpff (OVR,BANK=page_ff)
                              9 	
                             10 ;--- end asm ---
                             11 	.globl	_Vec_ADSR_FADE8
                             12 	.area	.dpff
   FF16                      13 _Vec_ADSR_FADE8:
   FF16 00 00 00 00 00 00    14 	.word	0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00
                             15 	.globl	_Vec_Music_9
   FF26                      16 _Vec_Music_9:
   FF26 00 00 00 00 00 00    17 	.word	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
                             18 	.globl	_Vec_Music_a
   FF44                      19 _Vec_Music_a:
   FF44 00 00 00 00 00 00    20 	.word	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
                             21 	.globl	_Vec_Music_b
   FF62                      22 _Vec_Music_b:
   FF62 00 00 00 00 00 00    23 	.word	0,0,0,0,0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
                             24 	.globl	_Vec_Music_c
   FF7A                      25 _Vec_Music_c:
   FF7A 00 00 00 00 00 00    26 	.word	0,0,0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00
   FF8E 00                   27 	.byte	0
                             28 	.globl	_Vec_Music_d
   FF8F                      29 _Vec_Music_d:
   FF8F 00                   30 	.byte	0
ASxxxx Assembler V05.31  (Motorola 6809)                                Page 1
Hexadecimal [16-Bits]                                 Thu Jan 30 13:14:28 2020

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
  2 _Vec_ADSR_FADE     0000 GR  |   2 _Vec_Music_9       0010 GR
  2 _Vec_Music_a       002E GR  |   2 _Vec_Music_b       004C GR
  2 _Vec_Music_c       0064 GR  |   2 _Vec_Music_d       0079 GR

ASxxxx Assembler V05.31  (Motorola 6809)                                Page 2
Hexadecimal [16-Bits]                                 Thu Jan 30 13:14:28 2020

Area Table

[_CSEG]
   0 _CODE            size    0   flags C080
[_DSEG]
   1 _DATA            size    0   flags C0C0
[page_ff]
   2 .dpff            size   7A   flags 8584

