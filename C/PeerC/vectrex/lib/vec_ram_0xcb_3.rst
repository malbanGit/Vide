                              1 ;;; gcc for m6809 : Mar 11 2019 13:34:05
                              2 ;;; 4.3.6 (gcc6809)
                              3 ;;; ABI version 1
                              4 ;;; -mabi=bx -mint8 -fomit-frame-pointer -O2
                              5 	.module	vec_ram_0xcb_3.c
                              6 ;----- asm -----
                              7 	.bank page_cb (BASE=0xcbea,SIZE=0x0100)
                              8 	.area .dpcb (OVR,BANK=page_cb)
                              9 	
                             10 ;--- end asm ---
                             11 	.globl	_Vec_Default_Stk
                             12 	.area	.dpcb
   CBEA                      13 _Vec_Default_Stk:
   CBEA 00 00 00 00 00 00    14 	.word	0,0,0,0
        00 00
                             15 	.globl	_Vec_SWI2_vector
   CBF2                      16 _Vec_SWI2_vector:
   CBF2 00 00 00 00 00 00    17 	.word	0,0,0,0
        00 00
   CBFA 00                   18 	.byte	0
                             19 	.globl	_Vec_NWI_vector
   CBFB                      20 _Vec_NWI_vector:
   CBFB 00 00                21 	.word	0
   CBFD 00                   22 	.byte	0
ASxxxx Assembler V05.00  (Motorola 6809), page 1.
Hexidecimal [16-Bits]

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
  2 _Vec_Default_S     0000 GR  |   2 _Vec_NWI_vecto     0011 GR
  2 _Vec_SWI2_vect     0008 GR

ASxxxx Assembler V05.00  (Motorola 6809), page 2.
Hexidecimal [16-Bits]

Area Table

[_CSEG]
   0 _CODE            size    0   flags C080
[_DSEG]
   1 _DATA            size    0   flags C0C0
[page_cb]
   2 .dpcb            size   14   flags 8584

