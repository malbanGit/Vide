                              1 ;;; gcc for m6809 : Mar 17 2019 13:25:32
                              2 ;;; 4.3.6 (gcc6809)
                              3 ;;; ABI version 1
                              4 ;;; -mabi=bx -mint8 -fomit-frame-pointer -O0
                              5 	.module	vec_rom_0xfc_0.c
                              6 ;----- asm -----
                              7 	.bank page_fc (BASE=0xfc6d,SIZE=0x0100)
                              8 	.area .dpfc (OVR,BANK=page_fc)
                              9 	
                             10 ;--- end asm ---
                             11 	.globl	_Vec_Sine_Table
                             12 	.area	.dpfc
   FC6D                      13 _Vec_Sine_Table:
   FC6D 00 00 00 00 00 00    14 	.word	0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00
                             15 	.globl	_Vec_Cosine_Table
   FC7D                      16 _Vec_Cosine_Table:
   FC7D 00 00 00 00 00 00    17 	.word	0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00
                             18 	.globl	_Vec_Note_Table
   FC8D                      19 _Vec_Note_Table:
   FC8D 00                   20 	.byte	0
ASxxxx Assembler V05.31  (Motorola 6809)                                Page 1
Hexadecimal [16-Bits]                                 Thu Jan 30 13:14:28 2020

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
  2 _Vec_Cosine_Ta     0010 GR  |   2 _Vec_Note_Tabl     0020 GR
  2 _Vec_Sine_Tabl     0000 GR

ASxxxx Assembler V05.31  (Motorola 6809)                                Page 2
Hexadecimal [16-Bits]                                 Thu Jan 30 13:14:28 2020

Area Table

[_CSEG]
   0 _CODE            size    0   flags C080
[_DSEG]
   1 _DATA            size    0   flags C0C0
[page_fc]
   2 .dpfc            size   21   flags 8584

