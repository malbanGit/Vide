                              1 
                              2 ;;; gcc for m6809 : Feb 15 2016 21:40:10
                              3 ;;; 4.3.6 (gcc6809)
                              4 ;;; ABI version 1
                              5 ;;; -mint8
                              6 	.module	vec_rum_0xf8.c
                              7 ;----- asm -----
                              8 	.bank page_f8 (BASE=0xf835,SIZE=0x00cb)
                              9 	.area .0xf8 (OVR,BANK=page_f8)
                             10 	
                             11 ;--- end asm ---
                             12 	.globl ___Display_Option
                             13 	.area	.0xf8
   F835                      14 ___Display_Option:
   F835 00 00                15 	.word	0	;skip space 26
   F837 00 00                16 	.word	0	;skip space 24
   F839 00 00                17 	.word	0	;skip space 22
   F83B 00 00                18 	.word	0	;skip space 20
   F83D 00 00                19 	.word	0	;skip space 18
   F83F 00 00                20 	.word	0	;skip space 16
   F841 00 00                21 	.word	0	;skip space 14
   F843 00 00                22 	.word	0	;skip space 12
   F845 00 00                23 	.word	0	;skip space 10
   F847 00 00                24 	.word	0	;skip space 8
   F849 00 00                25 	.word	0	;skip space 6
   F84B 00 00                26 	.word	0	;skip space 4
   F84D 00 00                27 	.word	0	;skip space 2
                             28 	.globl ___Clear_Score
   F84F                      29 ___Clear_Score:
   F84F 00 00                30 	.word	0	;skip space 15
   F851 00 00                31 	.word	0	;skip space 13
   F853 00 00                32 	.word	0	;skip space 11
   F855 00 00                33 	.word	0	;skip space 9
   F857 00 00                34 	.word	0	;skip space 7
   F859 00 00                35 	.word	0	;skip space 5
   F85B 00 00                36 	.word	0	;skip space 3
   F85D 00                   37 	.byte	0	;skip space
                             38 	.globl ___Add_Score_a
   F85E                      39 ___Add_Score_a:
   F85E 00 00                40 	.word	0	;skip space 30
   F860 00 00                41 	.word	0	;skip space 28
   F862 00 00                42 	.word	0	;skip space 26
   F864 00 00                43 	.word	0	;skip space 24
   F866 00 00                44 	.word	0	;skip space 22
   F868 00 00                45 	.word	0	;skip space 20
   F86A 00 00                46 	.word	0	;skip space 18
   F86C 00 00                47 	.word	0	;skip space 16
   F86E 00 00                48 	.word	0	;skip space 14
   F870 00 00                49 	.word	0	;skip space 12
   F872 00 00                50 	.word	0	;skip space 10
   F874 00 00                51 	.word	0	;skip space 8
   F876 00 00                52 	.word	0	;skip space 6
   F878 00 00                53 	.word	0	;skip space 4
   F87A 00 00                54 	.word	0	;skip space 2
                             55 	.globl ___Add_Score_d
   F87C                      56 ___Add_Score_d:
   F87C 00 00                57 	.word	0	;skip space 59
   F87E 00 00                58 	.word	0	;skip space 57
   F880 00 00                59 	.word	0	;skip space 55
   F882 00 00                60 	.word	0	;skip space 53
   F884 00 00                61 	.word	0	;skip space 51
   F886 00 00                62 	.word	0	;skip space 49
   F888 00 00                63 	.word	0	;skip space 47
   F88A 00 00                64 	.word	0	;skip space 45
   F88C 00 00                65 	.word	0	;skip space 43
   F88E 00 00                66 	.word	0	;skip space 41
   F890 00 00                67 	.word	0	;skip space 39
   F892 00 00                68 	.word	0	;skip space 37
   F894 00 00                69 	.word	0	;skip space 35
   F896 00 00                70 	.word	0	;skip space 33
   F898 00 00                71 	.word	0	;skip space 31
   F89A 00 00                72 	.word	0	;skip space 29
   F89C 00 00                73 	.word	0	;skip space 27
   F89E 00 00                74 	.word	0	;skip space 25
   F8A0 00 00                75 	.word	0	;skip space 23
   F8A2 00 00                76 	.word	0	;skip space 21
   F8A4 00 00                77 	.word	0	;skip space 19
   F8A6 00 00                78 	.word	0	;skip space 17
   F8A8 00 00                79 	.word	0	;skip space 15
   F8AA 00 00                80 	.word	0	;skip space 13
   F8AC 00 00                81 	.word	0	;skip space 11
   F8AE 00 00                82 	.word	0	;skip space 9
   F8B0 00 00                83 	.word	0	;skip space 7
   F8B2 00 00                84 	.word	0	;skip space 5
   F8B4 00 00                85 	.word	0	;skip space 3
   F8B6 00                   86 	.byte	0	;skip space
                             87 	.globl ___Strip_Zeros
   F8B7                      88 ___Strip_Zeros:
   F8B7 00 00                89 	.word	0	;skip space 16
   F8B9 00 00                90 	.word	0	;skip space 14
   F8BB 00 00                91 	.word	0	;skip space 12
   F8BD 00 00                92 	.word	0	;skip space 10
   F8BF 00 00                93 	.word	0	;skip space 8
   F8C1 00 00                94 	.word	0	;skip space 6
   F8C3 00 00                95 	.word	0	;skip space 4
   F8C5 00 00                96 	.word	0	;skip space 2
                             97 	.globl ___Compare_Score
   F8C7                      98 ___Compare_Score:
   F8C7 00 00                99 	.word	0	;skip space 17
   F8C9 00 00               100 	.word	0	;skip space 15
   F8CB 00 00               101 	.word	0	;skip space 13
   F8CD 00 00               102 	.word	0	;skip space 11
   F8CF 00 00               103 	.word	0	;skip space 9
   F8D1 00 00               104 	.word	0	;skip space 7
   F8D3 00 00               105 	.word	0	;skip space 5
   F8D5 00 00               106 	.word	0	;skip space 3
   F8D7 00                  107 	.byte	0	;skip space
                            108 	.globl ___New_High_Score
   F8D8                     109 ___New_High_Score:
   F8D8 00 00               110 	.word	0	;skip space 13
   F8DA 00 00               111 	.word	0	;skip space 11
   F8DC 00 00               112 	.word	0	;skip space 9
   F8DE 00 00               113 	.word	0	;skip space 7
   F8E0 00 00               114 	.word	0	;skip space 5
   F8E2 00 00               115 	.word	0	;skip space 3
   F8E4 00                  116 	.byte	0	;skip space
                            117 	.globl ___Obj_Will_Hit_u
   F8E5                     118 ___Obj_Will_Hit_u:
   F8E5 00 00               119 	.word	0	;skip space 14
   F8E7 00 00               120 	.word	0	;skip space 12
   F8E9 00 00               121 	.word	0	;skip space 10
   F8EB 00 00               122 	.word	0	;skip space 8
   F8ED 00 00               123 	.word	0	;skip space 6
   F8EF 00 00               124 	.word	0	;skip space 4
   F8F1 00 00               125 	.word	0	;skip space 2
                            126 	.globl ___Obj_Will_Hit
   F8F3                     127 ___Obj_Will_Hit:
   F8F3 00 00               128 	.word	0	;skip space 12
   F8F5 00 00               129 	.word	0	;skip space 10
   F8F7 00 00               130 	.word	0	;skip space 8
   F8F9 00 00               131 	.word	0	;skip space 6
   F8FB 00 00               132 	.word	0	;skip space 4
   F8FD 00 00               133 	.word	0	;skip space 2
                            134 	.globl ___Obj_Hit
   F8FF                     135 ___Obj_Hit:
   F8FF 00                  136 	.byte	0	;skip space
ASxxxx Assembler V05.00  (Motorola 6809), page 1.
Hexidecimal [16-Bits]

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
  2 ___Add_Score_a     0029 GR  |   2 ___Add_Score_d     0047 GR
  2 ___Clear_Score     001A GR  |   2 ___Compare_Sco     0092 GR
  2 ___Display_Opt     0000 GR  |   2 ___New_High_Sc     00A3 GR
  2 ___Obj_Hit         00CA GR  |   2 ___Obj_Will_Hi     00BE GR
  2 ___Obj_Will_Hi     00B0 GR  |   2 ___Strip_Zeros     0082 GR

ASxxxx Assembler V05.00  (Motorola 6809), page 2.
Hexidecimal [16-Bits]

Area Table

[_CSEG]
   0 _CODE            size    0   flags C080
[_DSEG]
   1 _DATA            size    0   flags C0C0
[page_f8]
   2 .0xf8            size   CB   flags 8584

