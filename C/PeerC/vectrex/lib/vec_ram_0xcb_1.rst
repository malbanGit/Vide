                              1 
                              2 ;;; gcc for m6809 : Feb 15 2016 21:40:10
                              3 ;;; 4.3.6 (gcc6809)
                              4 ;;; ABI version 1
                              5 ;;; -mint8
                              6 	.module	vec_ram_0xcb_1.c
                              7 ;----- asm -----
                              8 	.bank page_cb (BASE=0xcbea,SIZE=0x0100)
                              9 	.area .dpcb (OVR,BANK=page_cb)
                             10 	
                             11 ;--- end asm ---
                             12 	.globl _Vec_Default_Stk
                             13 	.area	.dpcb
   CBEA                      14 _Vec_Default_Stk:
   CBEA 00                   15 	.byte	0	;skip space
                             16 	.globl _Vec_High_score
   CBEB                      17 _Vec_High_score:
   CBEB 00 00                18 	.word	0	;skip space 7
   CBED 00 00                19 	.word	0	;skip space 5
   CBEF 00 00                20 	.word	0	;skip space 3
   CBF1 00                   21 	.byte	0	;skip space
                             22 	.globl _Vec_SWI3_vector
   CBF2                      23 _Vec_SWI3_vector:
   CBF2 00 00                24 	.word	0	;skip space 3
   CBF4 00                   25 	.byte	0	;skip space
                             26 	.globl _Vec_FIRQ_vector
   CBF5                      27 _Vec_FIRQ_vector:
   CBF5 00 00                28 	.word	0	;skip space 3
   CBF7 00                   29 	.byte	0	;skip space
                             30 	.globl _Vec_IRQ_vector
   CBF8                      31 _Vec_IRQ_vector:
   CBF8 00 00                32 	.word	0	;skip space 3
   CBFA 00                   33 	.byte	0	;skip space
                             34 	.globl _Vec_SWI_vector
   CBFB                      35 _Vec_SWI_vector:
   CBFB 00 00                36 	.word	0	;skip space 3
   CBFD 00                   37 	.byte	0	;skip space
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

