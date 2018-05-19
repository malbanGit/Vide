                              1 
                              2 ;;; gcc for m6809 : Feb 15 2016 21:40:10
                              3 ;;; 4.3.6 (gcc6809)
                              4 ;;; ABI version 1
                              5 ;;; -mint8
                              6 	.module	vec_rom_0xed_0.c
                              7 ;----- asm -----
                              8 	.bank page_ed (BASE=0xed77,SIZE=0x0100)
                              9 	.area .dped (OVR,BANK=page_ed)
                             10 	
                             11 ;--- end asm ---
                             12 	.globl _Vec_Music_0
                             13 	.area	.dped
   ED77                      14 _Vec_Music_0:
   ED77 00 00                15 	.word	0	;skip space 24
   ED79 00 00                16 	.word	0	;skip space 22
   ED7B 00 00                17 	.word	0	;skip space 20
   ED7D 00 00                18 	.word	0	;skip space 18
   ED7F 00 00                19 	.word	0	;skip space 16
   ED81 00 00                20 	.word	0	;skip space 14
   ED83 00 00                21 	.word	0	;skip space 12
   ED85 00 00                22 	.word	0	;skip space 10
   ED87 00 00                23 	.word	0	;skip space 8
   ED89 00 00                24 	.word	0	;skip space 6
   ED8B 00 00                25 	.word	0	;skip space 4
   ED8D 00 00                26 	.word	0	;skip space 2
                             27 	.globl _Vec_ADSR_FADE66
   ED8F                      28 _Vec_ADSR_FADE66:
   ED8F 00                   29 	.byte	0	;skip space
ASxxxx Assembler V05.00  (Motorola 6809), page 1.
Hexidecimal [16-Bits]

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
  2 _Vec_ADSR_FADE     0018 GR  |   2 _Vec_Music_0       0000 GR

ASxxxx Assembler V05.00  (Motorola 6809), page 2.
Hexidecimal [16-Bits]

Area Table

[_CSEG]
   0 _CODE            size    0   flags C080
[_DSEG]
   1 _DATA            size    0   flags C0C0
[page_ed]
   2 .dped            size   19   flags 8584

