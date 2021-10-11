                              1 ;;; gcc for m6809 : Mar 17 2019 13:25:32
                              2 ;;; 4.3.6 (gcc6809)
                              3 ;;; ABI version 1
                              4 ;;; -mabi=bx -mint8 -fomit-frame-pointer -O0
                              5 	.module	vec_rum_0xf1.c
                              6 ;----- asm -----
                              7 	.bank page_f1 (BASE=0xf14c,SIZE=0x00b4)
                              8 	.area .0xf1 (OVR,BANK=page_f1)
                              9 	
                             10 ;--- end asm ---
                             11 	.globl	___Init_VIA
                             12 	.area	.0xf1
   F14C                      13 ___Init_VIA:
   F14C 00 00 00 00 00 00    14 	.word	0,0,0,0,0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
                             15 	.globl	___Init_OS_RAM
   F164                      16 ___Init_OS_RAM:
   F164 00 00 00 00 00 00    17 	.word	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00
   F184 00 00 00 00 00 00    18 	.word	0,0,0
   F18A 00                   19 	.byte	0
                             20 	.globl	___Init_OS
   F18B                      21 ___Init_OS:
   F18B 00 00 00 00 00 00    22 	.word	0,0,0
   F191 00                   23 	.byte	0
                             24 	.globl	___Wait_Recal
   F192                      25 ___Wait_Recal:
   F192 00 00 00 00 00 00    26 	.word	0,0,0,0,0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
                             27 	.globl	___DP_to_D0
   F1AA                      28 ___DP_to_D0:
   F1AA 00 00 00 00          29 	.word	0,0
   F1AE 00                   30 	.byte	0
                             31 	.globl	___DP_to_C8
   F1AF                      32 ___DP_to_C8:
   F1AF 00 00 00 00          33 	.word	0,0
   F1B3 00                   34 	.byte	0
                             35 	.globl	___Read_Btns_Mask
   F1B4                      36 ___Read_Btns_Mask:
   F1B4 00 00 00 00 00 00    37 	.word	0,0,0
                             38 	.globl	___Read_Btns
   F1BA                      39 ___Read_Btns:
   F1BA 00 00 00 00 00 00    40 	.word	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00
   F1DA 00 00 00 00 00 00    41 	.word	0,0,0,0,0,0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00
   F1F4 00                   42 	.byte	0
                             43 	.globl	___Joy_Analog
   F1F5                      44 ___Joy_Analog:
   F1F5 00 00                45 	.word	0
   F1F7 00                   46 	.byte	0
                             47 	.globl	___Joy_Digital
   F1F8                      48 ___Joy_Digital:
   F1F8 00                   49 	.byte	0
ASxxxx Assembler V05.31  (Motorola 6809)                                Page 1
Hexadecimal [16-Bits]                                 Thu Jan 30 13:14:28 2020

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
  2 ___DP_to_C8        0063 GR  |   2 ___DP_to_D0        005E GR
  2 ___Init_OS         003F GR  |   2 ___Init_OS_RAM     0018 GR
  2 ___Init_VIA        0000 GR  |   2 ___Joy_Analog      00A9 GR
  2 ___Joy_Digital     00AC GR  |   2 ___Read_Btns       006E GR
  2 ___Read_Btns_M     0068 GR  |   2 ___Wait_Recal      0046 GR

ASxxxx Assembler V05.31  (Motorola 6809)                                Page 2
Hexadecimal [16-Bits]                                 Thu Jan 30 13:14:28 2020

Area Table

[_CSEG]
   0 _CODE            size    0   flags C080
[_DSEG]
   1 _DATA            size    0   flags C0C0
[page_f1]
   2 .0xf1            size   AD   flags 8584

