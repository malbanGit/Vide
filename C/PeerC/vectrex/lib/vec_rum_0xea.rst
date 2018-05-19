                              1 
                              2 ;;; gcc for m6809 : Feb 15 2016 21:40:10
                              3 ;;; 4.3.6 (gcc6809)
                              4 ;;; ABI version 1
                              5 ;;; -mint8
                              6 	.module	vec_rum_0xea.c
                              7 ;----- asm -----
                              8 	.bank page_ea (BASE=0xea3e,SIZE=0x00c2)
                              9 	.area .0xea (OVR,BANK=page_ea)
                             10 	
                             11 ;--- end asm ---
                             12 	.globl ___Rnd_Cone
                             13 	.area	.0xea
   EA3E                      14 ___Rnd_Cone:
   EA3E 00 00                15 	.word	0	;skip space 31
   EA40 00 00                16 	.word	0	;skip space 29
   EA42 00 00                17 	.word	0	;skip space 27
   EA44 00 00                18 	.word	0	;skip space 25
   EA46 00 00                19 	.word	0	;skip space 23
   EA48 00 00                20 	.word	0	;skip space 21
   EA4A 00 00                21 	.word	0	;skip space 19
   EA4C 00 00                22 	.word	0	;skip space 17
   EA4E 00 00                23 	.word	0	;skip space 15
   EA50 00 00                24 	.word	0	;skip space 13
   EA52 00 00                25 	.word	0	;skip space 11
   EA54 00 00                26 	.word	0	;skip space 9
   EA56 00 00                27 	.word	0	;skip space 7
   EA58 00 00                28 	.word	0	;skip space 5
   EA5A 00 00                29 	.word	0	;skip space 3
   EA5C 00                   30 	.byte	0	;skip space
                             31 	.globl ___Dot_y
   EA5D                      32 ___Dot_y:
   EA5D 00 00                33 	.word	0	;skip space 16
   EA5F 00 00                34 	.word	0	;skip space 14
   EA61 00 00                35 	.word	0	;skip space 12
   EA63 00 00                36 	.word	0	;skip space 10
   EA65 00 00                37 	.word	0	;skip space 8
   EA67 00 00                38 	.word	0	;skip space 6
   EA69 00 00                39 	.word	0	;skip space 4
   EA6B 00 00                40 	.word	0	;skip space 2
                             41 	.globl ___Dot_py
   EA6D                      42 ___Dot_py:
   EA6D 00 00                43 	.word	0	;skip space 18
   EA6F 00 00                44 	.word	0	;skip space 16
   EA71 00 00                45 	.word	0	;skip space 14
   EA73 00 00                46 	.word	0	;skip space 12
   EA75 00 00                47 	.word	0	;skip space 10
   EA77 00 00                48 	.word	0	;skip space 8
   EA79 00 00                49 	.word	0	;skip space 6
   EA7B 00 00                50 	.word	0	;skip space 4
   EA7D 00 00                51 	.word	0	;skip space 2
                             52 	.globl ___Draw_Pack
   EA7F                      53 ___Draw_Pack:
   EA7F 00 00                54 	.word	0	;skip space 14
   EA81 00 00                55 	.word	0	;skip space 12
   EA83 00 00                56 	.word	0	;skip space 10
   EA85 00 00                57 	.word	0	;skip space 8
   EA87 00 00                58 	.word	0	;skip space 6
   EA89 00 00                59 	.word	0	;skip space 4
   EA8B 00 00                60 	.word	0	;skip space 2
                             61 	.globl ___Draw_Pack_py
   EA8D                      62 ___Draw_Pack_py:
   EA8D 00 00                63 	.word	0	;skip space 27
   EA8F 00 00                64 	.word	0	;skip space 25
   EA91 00 00                65 	.word	0	;skip space 23
   EA93 00 00                66 	.word	0	;skip space 21
   EA95 00 00                67 	.word	0	;skip space 19
   EA97 00 00                68 	.word	0	;skip space 17
   EA99 00 00                69 	.word	0	;skip space 15
   EA9B 00 00                70 	.word	0	;skip space 13
   EA9D 00 00                71 	.word	0	;skip space 11
   EA9F 00 00                72 	.word	0	;skip space 9
   EAA1 00 00                73 	.word	0	;skip space 7
   EAA3 00 00                74 	.word	0	;skip space 5
   EAA5 00 00                75 	.word	0	;skip space 3
   EAA7 00                   76 	.byte	0	;skip space
                             77 	.globl ___Print_Msg
   EAA8                      78 ___Print_Msg:
   EAA8 00 00                79 	.word	0	;skip space 12
   EAAA 00 00                80 	.word	0	;skip space 10
   EAAC 00 00                81 	.word	0	;skip space 8
   EAAE 00 00                82 	.word	0	;skip space 6
   EAB0 00 00                83 	.word	0	;skip space 4
   EAB2 00 00                84 	.word	0	;skip space 2
                             85 	.globl ___Draw_Score
   EAB4                      86 ___Draw_Score:
   EAB4 00 00                87 	.word	0	;skip space 27
   EAB6 00 00                88 	.word	0	;skip space 25
   EAB8 00 00                89 	.word	0	;skip space 23
   EABA 00 00                90 	.word	0	;skip space 21
   EABC 00 00                91 	.word	0	;skip space 19
   EABE 00 00                92 	.word	0	;skip space 17
   EAC0 00 00                93 	.word	0	;skip space 15
   EAC2 00 00                94 	.word	0	;skip space 13
   EAC4 00 00                95 	.word	0	;skip space 11
   EAC6 00 00                96 	.word	0	;skip space 9
   EAC8 00 00                97 	.word	0	;skip space 7
   EACA 00 00                98 	.word	0	;skip space 5
   EACC 00 00                99 	.word	0	;skip space 3
   EACE 00                  100 	.byte	0	;skip space
                            101 	.globl ___Draw_Scores
   EACF                     102 ___Draw_Scores:
   EACF 00 00               103 	.word	0	;skip space 33
   EAD1 00 00               104 	.word	0	;skip space 31
   EAD3 00 00               105 	.word	0	;skip space 29
   EAD5 00 00               106 	.word	0	;skip space 27
   EAD7 00 00               107 	.word	0	;skip space 25
   EAD9 00 00               108 	.word	0	;skip space 23
   EADB 00 00               109 	.word	0	;skip space 21
   EADD 00 00               110 	.word	0	;skip space 19
   EADF 00 00               111 	.word	0	;skip space 17
   EAE1 00 00               112 	.word	0	;skip space 15
   EAE3 00 00               113 	.word	0	;skip space 13
   EAE5 00 00               114 	.word	0	;skip space 11
   EAE7 00 00               115 	.word	0	;skip space 9
   EAE9 00 00               116 	.word	0	;skip space 7
   EAEB 00 00               117 	.word	0	;skip space 5
   EAED 00 00               118 	.word	0	;skip space 3
   EAEF 00                  119 	.byte	0	;skip space
                            120 	.globl ___Wait_Bound
   EAF0                     121 ___Wait_Bound:
   EAF0 00                  122 	.byte	0	;skip space
ASxxxx Assembler V05.00  (Motorola 6809), page 1.
Hexidecimal [16-Bits]

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
  2 ___Dot_py          002F GR  |   2 ___Dot_y           001F GR
  2 ___Draw_Pack       0041 GR  |   2 ___Draw_Pack_p     004F GR
  2 ___Draw_Score      0076 GR  |   2 ___Draw_Scores     0091 GR
  2 ___Print_Msg       006A GR  |   2 ___Rnd_Cone        0000 GR
  2 ___Wait_Bound      00B2 GR

ASxxxx Assembler V05.00  (Motorola 6809), page 2.
Hexidecimal [16-Bits]

Area Table

[_CSEG]
   0 _CODE            size    0   flags C080
[_DSEG]
   1 _DATA            size    0   flags C0C0
[page_ea]
   2 .0xea            size   B3   flags 8584

