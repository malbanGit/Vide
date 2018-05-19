                              1 
                              2 ;;; gcc for m6809 : Feb 15 2016 21:40:10
                              3 ;;; 4.3.6 (gcc6809)
                              4 ;;; ABI version 1
                              5 ;;; -mint8
                              6 	.module	vec_rom_0xfc_0.c
                              7 ;----- asm -----
                              8 	.bank page_fc (BASE=0xfc6d,SIZE=0x0100)
                              9 	.area .dpfc (OVR,BANK=page_fc)
                             10 	
                             11 ;--- end asm ---
                             12 	.globl _Vec_Sine_Table
                             13 	.area	.dpfc
   FC6D                      14 _Vec_Sine_Table:
   FC6D 00 00                15 	.word	0	;skip space 16
   FC6F 00 00                16 	.word	0	;skip space 14
   FC71 00 00                17 	.word	0	;skip space 12
   FC73 00 00                18 	.word	0	;skip space 10
   FC75 00 00                19 	.word	0	;skip space 8
   FC77 00 00                20 	.word	0	;skip space 6
   FC79 00 00                21 	.word	0	;skip space 4
   FC7B 00 00                22 	.word	0	;skip space 2
                             23 	.globl _Vec_Cosine_Table
   FC7D                      24 _Vec_Cosine_Table:
   FC7D 00 00                25 	.word	0	;skip space 16
   FC7F 00 00                26 	.word	0	;skip space 14
   FC81 00 00                27 	.word	0	;skip space 12
   FC83 00 00                28 	.word	0	;skip space 10
   FC85 00 00                29 	.word	0	;skip space 8
   FC87 00 00                30 	.word	0	;skip space 6
   FC89 00 00                31 	.word	0	;skip space 4
   FC8B 00 00                32 	.word	0	;skip space 2
                             33 	.globl _Vec_Note_Table
   FC8D                      34 _Vec_Note_Table:
   FC8D 00                   35 	.byte	0	;skip space
ASxxxx Assembler V05.00  (Motorola 6809), page 1.
Hexidecimal [16-Bits]

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
  2 _Vec_Cosine_Ta     0010 GR  |   2 _Vec_Note_Tabl     0020 GR
  2 _Vec_Sine_Tabl     0000 GR

ASxxxx Assembler V05.00  (Motorola 6809), page 2.
Hexidecimal [16-Bits]

Area Table

[_CSEG]
   0 _CODE            size    0   flags C080
[_DSEG]
   1 _DATA            size    0   flags C0C0
[page_fc]
   2 .dpfc            size   21   flags 8584

