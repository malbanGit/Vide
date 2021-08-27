                              1 ;;; gcc for m6809 : Mar 17 2019 13:25:32
                              2 ;;; 4.3.6 (gcc6809)
                              3 ;;; ABI version 1
                              4 ;;; -mabi=bx -mint8 -fomit-frame-pointer -O0
                              5 	.module	vec_rum_0xf8.c
                              6 ;----- asm -----
                              7 	.bank page_f8 (BASE=0xf835,SIZE=0x00cb)
                              8 	.area .0xf8 (OVR,BANK=page_f8)
                              9 	
                             10 ;--- end asm ---
                             11 	.globl	___Display_Option
                             12 	.area	.0xf8
   F835                      13 ___Display_Option:
   F835 00 00 00 00 00 00    14 	.word	0,0,0,0,0,0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00
                             15 	.globl	___Clear_Score
   F84F                      16 ___Clear_Score:
   F84F 00 00 00 00 00 00    17 	.word	0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00
   F85D 00                   18 	.byte	0
                             19 	.globl	___Add_Score_a
   F85E                      20 ___Add_Score_a:
   F85E 00 00 00 00 00 00    21 	.word	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
                             22 	.globl	___Add_Score_d
   F87C                      23 ___Add_Score_d:
   F87C 00 00 00 00 00 00    24 	.word	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00
   F89C 00 00 00 00 00 00    25 	.word	0,0,0,0,0,0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00
   F8B6 00                   26 	.byte	0
                             27 	.globl	___Strip_Zeros
   F8B7                      28 ___Strip_Zeros:
   F8B7 00 00 00 00 00 00    29 	.word	0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00
                             30 	.globl	___Compare_Score
   F8C7                      31 ___Compare_Score:
   F8C7 00 00 00 00 00 00    32 	.word	0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00
   F8D7 00                   33 	.byte	0
                             34 	.globl	___New_High_Score
   F8D8                      35 ___New_High_Score:
   F8D8 00 00 00 00 00 00    36 	.word	0,0,0,0,0,0
        00 00 00 00 00 00
   F8E4 00                   37 	.byte	0
                             38 	.globl	___Obj_Will_Hit_u
   F8E5                      39 ___Obj_Will_Hit_u:
   F8E5 00 00 00 00 00 00    40 	.word	0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00
                             41 	.globl	___Obj_Will_Hit
   F8F3                      42 ___Obj_Will_Hit:
   F8F3 00 00 00 00 00 00    43 	.word	0,0,0,0,0,0
        00 00 00 00 00 00
                             44 	.globl	___Obj_Hit
   F8FF                      45 ___Obj_Hit:
   F8FF 00                   46 	.byte	0
ASxxxx Assembler V05.31  (Motorola 6809)                                Page 1
Hexadecimal [16-Bits]                                 Thu Jan 30 13:14:29 2020

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
  2 ___Add_Score_a     0029 GR  |   2 ___Add_Score_d     0047 GR
  2 ___Clear_Score     001A GR  |   2 ___Compare_Sco     0092 GR
  2 ___Display_Opt     0000 GR  |   2 ___New_High_Sc     00A3 GR
  2 ___Obj_Hit         00CA GR  |   2 ___Obj_Will_Hi     00BE GR
  2 ___Obj_Will_Hi     00B0 GR  |   2 ___Strip_Zeros     0082 GR

ASxxxx Assembler V05.31  (Motorola 6809)                                Page 2
Hexadecimal [16-Bits]                                 Thu Jan 30 13:14:29 2020

Area Table

[_CSEG]
   0 _CODE            size    0   flags C080
[_DSEG]
   1 _DATA            size    0   flags C0C0
[page_f8]
   2 .0xf8            size   CB   flags 8584

