                              1 ;;; gcc for m6809 : Mar 11 2019 13:34:05
                              2 ;;; 4.3.6 (gcc6809)
                              3 ;;; ABI version 1
                              4 ;;; -mabi=bx -mint8 -fomit-frame-pointer -O2
                              5 	.module	vec_ram_0xcb_1.c
                              6 ;----- asm -----
                              7 	.bank page_cb (BASE=0xcbea,SIZE=0x0100)
                              8 	.area .dpcb (OVR,BANK=page_cb)
                              9 	
                             10 ;--- end asm ---
                             11 	.globl	_Vec_Default_Stk
                             12 	.area	.dpcb
   CBEA                      13 _Vec_Default_Stk:
   CBEA 00                   14 	.byte	0
                             15 	.globl	_Vec_High_score
   CBEB                      16 _Vec_High_score:
   CBEB 00 00 00 00 00 00    17 	.word	0,0,0
   CBF1 00                   18 	.byte	0
                             19 	.globl	_Vec_SWI3_vector
   CBF2                      20 _Vec_SWI3_vector:
   CBF2 00 00                21 	.word	0
   CBF4 00                   22 	.byte	0
                             23 	.globl	_Vec_FIRQ_vector
   CBF5                      24 _Vec_FIRQ_vector:
   CBF5 00 00                25 	.word	0
   CBF7 00                   26 	.byte	0
                             27 	.globl	_Vec_IRQ_vector
   CBF8                      28 _Vec_IRQ_vector:
   CBF8 00 00                29 	.word	0
   CBFA 00                   30 	.byte	0
                             31 	.globl	_Vec_SWI_vector
   CBFB                      32 _Vec_SWI_vector:
   CBFB 00 00                33 	.word	0
   CBFD 00                   34 	.byte	0
ASxxxx Assembler V05.00  (Motorola 6809), page 1.
Hexidecimal [16-Bits]

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
  2 _Vec_Default_S     0000 GR  |   2 _Vec_FIRQ_vect     000B GR
  2 _Vec_High_scor     0001 GR  |   2 _Vec_IRQ_vecto     000E GR
  2 _Vec_SWI3_vect     0008 GR  |   2 _Vec_SWI_vecto     0011 GR

ASxxxx Assembler V05.00  (Motorola 6809), page 2.
Hexidecimal [16-Bits]

Area Table

[_CSEG]
   0 _CODE            size    0   flags C080
[_DSEG]
   1 _DATA            size    0   flags C0C0
[page_cb]
   2 .dpcb            size   14   flags 8584

