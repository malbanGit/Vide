                              1 ;;; gcc for m6809 : Mar 11 2019 13:34:05
                              2 ;;; 4.3.6 (gcc6809)
                              3 ;;; ABI version 1
                              4 ;;; -mabi=bx -mint8 -fomit-frame-pointer -O2
                              5 	.module	vec_rom_0xfe_0.c
                              6 ;----- asm -----
                              7 	.bank page_fe (BASE=0xfe28,SIZE=0x0100)
                              8 	.area .dpfe (OVR,BANK=page_fe)
                              9 	
                             10 ;--- end asm ---
                             11 	.globl	_Vec_ADSR_FADE1
                             12 	.area	.dpfe
   FE28                      13 _Vec_ADSR_FADE1:
   FE28 00 00 00 00 00 00    14 	.word	0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00
                             15 	.globl	_Vec_Music_5
   FE38                      16 _Vec_Music_5:
   FE38 00 00 00 00 00 00    17 	.word	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00
   FE58 00 00 00 00 00 00    18 	.word	0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00
                             19 	.globl	_Vec_ADSR_FADE2
   FE66                      20 _Vec_ADSR_FADE2:
   FE66 00 00 00 00 00 00    21 	.word	0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00
                             22 	.globl	_Vec_Music_6
   FE76                      23 _Vec_Music_6:
   FE76 00 00 00 00 00 00    24 	.word	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00
   FE96 00 00 00 00 00 00    25 	.word	0,0,0,0,0,0,0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00
                             26 	.globl	_Vec_ADSR_FADE3
   FEB2                      27 _Vec_ADSR_FADE3:
   FEB2 00 00 00 00          28 	.word	0,0
                             29 	.globl	_Vec_TWANG_VIBEHL
   FEB6                      30 _Vec_TWANG_VIBEHL:
   FEB6 00 00 00 00 00 00    31 	.word	0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00
                             32 	.globl	_Vec_Music_7
   FEC6                      33 _Vec_Music_7:
   FEC6 00 00 00 00 00 00    34 	.word	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00
   FEE6 00 00                35 	.word	0
                             36 	.globl	_Vec_ADSR_FADE4
   FEE8                      37 _Vec_ADSR_FADE4:
   FEE8 00 00 00 00 00 00    38 	.word	0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00
                             39 	.globl	_Vec_Music_8
   FEF8                      40 _Vec_Music_8:
   FEF8 00                   41 	.byte	0
ASxxxx Assembler V05.00  (Motorola 6809), page 1.
Hexidecimal [16-Bits]

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
  2 _Vec_ADSR_FADE     0000 GR  |   2 _Vec_ADSR_FADE     003E GR
  2 _Vec_ADSR_FADE     008A GR  |   2 _Vec_ADSR_FADE     00C0 GR
  2 _Vec_Music_5       0010 GR  |   2 _Vec_Music_6       004E GR
  2 _Vec_Music_7       009E GR  |   2 _Vec_Music_8       00D0 GR
  2 _Vec_TWANG_VIB     008E GR

ASxxxx Assembler V05.00  (Motorola 6809), page 2.
Hexidecimal [16-Bits]

Area Table

[_CSEG]
   0 _CODE            size    0   flags C080
[_DSEG]
   1 _DATA            size    0   flags C0C0
[page_fe]
   2 .dpfe            size   D1   flags 8584

