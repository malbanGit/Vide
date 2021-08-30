                              1 ;;; gcc for m6809 : Mar 17 2019 13:25:32
                              2 ;;; 4.3.6 (gcc6809)
                              3 ;;; ABI version 1
                              4 ;;; -mabi=bx -mint8 -fomit-frame-pointer -O0
                              5 	.module	vec_rum_0xea.c
                              6 ;----- asm -----
                              7 	.bank page_ea (BASE=0xea3e,SIZE=0x00c2)
                              8 	.area .0xea (OVR,BANK=page_ea)
                              9 	
                             10 ;--- end asm ---
                             11 	.globl	___Rnd_Cone
                             12 	.area	.0xea
   EA3E                      13 ___Rnd_Cone:
   EA3E 00 00 00 00 00 00    14 	.word	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
   EA5C 00                   15 	.byte	0
                             16 	.globl	___Dot_y
   EA5D                      17 ___Dot_y:
   EA5D 00 00 00 00 00 00    18 	.word	0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00
                             19 	.globl	___Dot_py
   EA6D                      20 ___Dot_py:
   EA6D 00 00 00 00 00 00    21 	.word	0,0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00 00 00
                             22 	.globl	___Draw_Pack
   EA7F                      23 ___Draw_Pack:
   EA7F 00 00 00 00 00 00    24 	.word	0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00
                             25 	.globl	___Draw_Pack_py
   EA8D                      26 ___Draw_Pack_py:
   EA8D 00 00 00 00 00 00    27 	.word	0,0,0,0,0,0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00
   EAA7 00                   28 	.byte	0
                             29 	.globl	___Print_Msg
   EAA8                      30 ___Print_Msg:
   EAA8 00 00 00 00 00 00    31 	.word	0,0,0,0,0,0
        00 00 00 00 00 00
                             32 	.globl	___Draw_Score
   EAB4                      33 ___Draw_Score:
   EAB4 00 00 00 00 00 00    34 	.word	0,0,0,0,0,0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00
   EACE 00                   35 	.byte	0
                             36 	.globl	___Draw_Scores
   EACF                      37 ___Draw_Scores:
   EACF 00 00 00 00 00 00    38 	.word	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00
   EAEF 00                   39 	.byte	0
                             40 	.globl	___Wait_Bound
   EAF0                      41 ___Wait_Bound:
   EAF0 00                   42 	.byte	0
ASxxxx Assembler V05.31  (Motorola 6809)                                Page 1
Hexadecimal [16-Bits]                                 Thu Jan 30 13:14:28 2020

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
  2 ___Dot_py          002F GR  |   2 ___Dot_y           001F GR
  2 ___Draw_Pack       0041 GR  |   2 ___Draw_Pack_p     004F GR
  2 ___Draw_Score      0076 GR  |   2 ___Draw_Scores     0091 GR
  2 ___Print_Msg       006A GR  |   2 ___Rnd_Cone        0000 GR
  2 ___Wait_Bound      00B2 GR

ASxxxx Assembler V05.31  (Motorola 6809)                                Page 2
Hexadecimal [16-Bits]                                 Thu Jan 30 13:14:28 2020

Area Table

[_CSEG]
   0 _CODE            size    0   flags C080
[_DSEG]
   1 _DATA            size    0   flags C0C0
[page_ea]
   2 .0xea            size   B3   flags 8584

