                              1 ;;; gcc for m6809 : Mar 11 2019 13:34:05
                              2 ;;; 4.3.6 (gcc6809)
                              3 ;;; ABI version 1
                              4 ;;; -mabi=bx -mint8 -fomit-frame-pointer -O2
                              5 	.module	vec_rom_0xfd_0.c
                              6 ;----- asm -----
                              7 	.bank page_fd (BASE=0xfd0d,SIZE=0x0100)
                              8 	.area .dpfd (OVR,BANK=page_fd)
                              9 	
                             10 ;--- end asm ---
                             11 	.globl	_Vec_Music_1
                             12 	.area	.dpfd
   FD0D                      13 _Vec_Music_1:
   FD0D 00 00 00 00 00 00    14 	.word	0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00
                             15 	.globl	_Vec_Music_2
   FD1D                      16 _Vec_Music_2:
   FD1D 00 00 00 00 00 00    17 	.word	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00
   FD3D 00 00 00 00 00 00    18 	.word	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00
   FD5D 00 00 00 00 00 00    19 	.word	0,0,0,0,0,0
        00 00 00 00 00 00
                             20 	.globl	_Vec_ADSR_FADE0
   FD69                      21 _Vec_ADSR_FADE0:
   FD69 00 00 00 00 00 00    22 	.word	0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00
                             23 	.globl	_Vec_TWANG_VIBE0
   FD79                      24 _Vec_TWANG_VIBE0:
   FD79 00 00 00 00 00 00    25 	.word	0,0,0,0
        00 00
                             26 	.globl	_Vec_Music_3
   FD81                      27 _Vec_Music_3:
   FD81 00 00 00 00 00 00    28 	.word	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00
   FDA1 00 00 00 00 00 00    29 	.word	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00
   FDC1 00 00                30 	.word	0
                             31 	.globl	_Vec_ADSR_FADE12
   FDC3                      32 _Vec_ADSR_FADE12:
   FDC3 00 00 00 00 00 00    33 	.word	0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00
                             34 	.globl	_Vec_Music_4
   FDD3                      35 _Vec_Music_4:
   FDD3 00                   36 	.byte	0
ASxxxx Assembler V05.00  (Motorola 6809), page 1.
Hexidecimal [16-Bits]

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
  2 _Vec_ADSR_FADE     005C GR  |   2 _Vec_ADSR_FADE     00B6 GR
  2 _Vec_Music_1       0000 GR  |   2 _Vec_Music_2       0010 GR
  2 _Vec_Music_3       0074 GR  |   2 _Vec_Music_4       00C6 GR
  2 _Vec_TWANG_VIB     006C GR

ASxxxx Assembler V05.00  (Motorola 6809), page 2.
Hexidecimal [16-Bits]

Area Table

[_CSEG]
   0 _CODE            size    0   flags C080
[_DSEG]
   1 _DATA            size    0   flags C0C0
[page_fd]
   2 .dpfd            size   C7   flags 8584

