                              1 
                              2 ;;; gcc for m6809 : Feb 15 2016 21:40:10
                              3 ;;; 4.3.6 (gcc6809)
                              4 ;;; ABI version 1
                              5 ;;; -mint8
                              6 	.module	vec_rum_0xf5.c
                              7 ;----- asm -----
                              8 	.bank page_f5 (BASE=0xf511,SIZE=0x00ef)
                              9 	.area .0xf5 (OVR,BANK=page_f5)
                             10 	
                             11 ;--- end asm ---
                             12 	.globl ___Random_3
                             13 	.area	.0xf5
   F511                      14 ___Random_3:
   F511 00 00                15 	.word	0	;skip space 6
   F513 00 00                16 	.word	0	;skip space 4
   F515 00 00                17 	.word	0	;skip space 2
                             18 	.globl ___Random
   F517                      19 ___Random:
   F517 00 00                20 	.word	0	;skip space 28
   F519 00 00                21 	.word	0	;skip space 26
   F51B 00 00                22 	.word	0	;skip space 24
   F51D 00 00                23 	.word	0	;skip space 22
   F51F 00 00                24 	.word	0	;skip space 20
   F521 00 00                25 	.word	0	;skip space 18
   F523 00 00                26 	.word	0	;skip space 16
   F525 00 00                27 	.word	0	;skip space 14
   F527 00 00                28 	.word	0	;skip space 12
   F529 00 00                29 	.word	0	;skip space 10
   F52B 00 00                30 	.word	0	;skip space 8
   F52D 00 00                31 	.word	0	;skip space 6
   F52F 00 00                32 	.word	0	;skip space 4
   F531 00 00                33 	.word	0	;skip space 2
                             34 	.globl ___Init_Music_Buf
   F533                      35 ___Init_Music_Buf:
   F533 00 00                36 	.word	0	;skip space 12
   F535 00 00                37 	.word	0	;skip space 10
   F537 00 00                38 	.word	0	;skip space 8
   F539 00 00                39 	.word	0	;skip space 6
   F53B 00 00                40 	.word	0	;skip space 4
   F53D 00 00                41 	.word	0	;skip space 2
                             42 	.globl ___Clear_x_b
   F53F                      43 ___Clear_x_b:
   F53F 00 00                44 	.word	0	;skip space 3
   F541 00                   45 	.byte	0	;skip space
                             46 	.globl ___Clear_C8_RAM
   F542                      47 ___Clear_C8_RAM:
   F542 00 00                48 	.word	0	;skip space 3
   F544 00                   49 	.byte	0	;skip space
                             50 	.globl ___Clear_x_256
   F545                      51 ___Clear_x_256:
   F545 00 00                52 	.word	0	;skip space 3
   F547 00                   53 	.byte	0	;skip space
                             54 	.globl ___Clear_x_d
   F548                      55 ___Clear_x_d:
   F548 00 00                56 	.word	0	;skip space 8
   F54A 00 00                57 	.word	0	;skip space 6
   F54C 00 00                58 	.word	0	;skip space 4
   F54E 00 00                59 	.word	0	;skip space 2
                             60 	.globl ___Clear_x_b_80
   F550                      61 ___Clear_x_b_80:
   F550 00 00                62 	.word	0	;skip space 2
                             63 	.globl ___Clear_x_b_a
   F552                      64 ___Clear_x_b_a:
   F552 00 00                65 	.word	0	;skip space 8
   F554 00 00                66 	.word	0	;skip space 6
   F556 00 00                67 	.word	0	;skip space 4
   F558 00 00                68 	.word	0	;skip space 2
                             69 	.globl ___Dec_3_Counters
   F55A                      70 ___Dec_3_Counters:
   F55A 00 00                71 	.word	0	;skip space 4
   F55C 00 00                72 	.word	0	;skip space 2
                             73 	.globl ___Dec_6_Counters
   F55E                      74 ___Dec_6_Counters:
   F55E 00 00                75 	.word	0	;skip space 5
   F560 00 00                76 	.word	0	;skip space 3
   F562 00                   77 	.byte	0	;skip space
                             78 	.globl ___Dec_Counters
   F563                      79 ___Dec_Counters:
   F563 00 00                80 	.word	0	;skip space 10
   F565 00 00                81 	.word	0	;skip space 8
   F567 00 00                82 	.word	0	;skip space 6
   F569 00 00                83 	.word	0	;skip space 4
   F56B 00 00                84 	.word	0	;skip space 2
                             85 	.globl ___Delay_3
   F56D                      86 ___Delay_3:
   F56D 00 00                87 	.word	0	;skip space 4
   F56F 00 00                88 	.word	0	;skip space 2
                             89 	.globl ___Delay_2
   F571                      90 ___Delay_2:
   F571 00 00                91 	.word	0	;skip space 4
   F573 00 00                92 	.word	0	;skip space 2
                             93 	.globl ___Delay_1
   F575                      94 ___Delay_1:
   F575 00 00                95 	.word	0	;skip space 4
   F577 00 00                96 	.word	0	;skip space 2
                             97 	.globl ___Delay_0
   F579                      98 ___Delay_0:
   F579 00                   99 	.byte	0	;skip space
                            100 	.globl ___Delay_b
   F57A                     101 ___Delay_b:
   F57A 00 00               102 	.word	0	;skip space 3
   F57C 00                  103 	.byte	0	;skip space
                            104 	.globl ___Delay_RTS
   F57D                     105 ___Delay_RTS:
   F57D 00                  106 	.byte	0	;skip space
                            107 	.globl ___Bitmask_a
   F57E                     108 ___Bitmask_a:
   F57E 00 00               109 	.word	0	;skip space 6
   F580 00 00               110 	.word	0	;skip space 4
   F582 00 00               111 	.word	0	;skip space 2
                            112 	.globl ___Abs_a_b
   F584                     113 ___Abs_a_b:
   F584 00 00               114 	.word	0	;skip space 7
   F586 00 00               115 	.word	0	;skip space 5
   F588 00 00               116 	.word	0	;skip space 3
   F58A 00                  117 	.byte	0	;skip space
                            118 	.globl ___Abs_b
   F58B                     119 ___Abs_b:
   F58B 00 00               120 	.word	0	;skip space 8
   F58D 00 00               121 	.word	0	;skip space 6
   F58F 00 00               122 	.word	0	;skip space 4
   F591 00 00               123 	.word	0	;skip space 2
                            124 	.globl ___Rise_Run_Angle
   F593                     125 ___Rise_Run_Angle:
   F593 00 00               126 	.word	0	;skip space 70
   F595 00 00               127 	.word	0	;skip space 68
   F597 00 00               128 	.word	0	;skip space 66
   F599 00 00               129 	.word	0	;skip space 64
   F59B 00 00               130 	.word	0	;skip space 62
   F59D 00 00               131 	.word	0	;skip space 60
   F59F 00 00               132 	.word	0	;skip space 58
   F5A1 00 00               133 	.word	0	;skip space 56
   F5A3 00 00               134 	.word	0	;skip space 54
   F5A5 00 00               135 	.word	0	;skip space 52
   F5A7 00 00               136 	.word	0	;skip space 50
   F5A9 00 00               137 	.word	0	;skip space 48
   F5AB 00 00               138 	.word	0	;skip space 46
   F5AD 00 00               139 	.word	0	;skip space 44
   F5AF 00 00               140 	.word	0	;skip space 42
   F5B1 00 00               141 	.word	0	;skip space 40
   F5B3 00 00               142 	.word	0	;skip space 38
   F5B5 00 00               143 	.word	0	;skip space 36
   F5B7 00 00               144 	.word	0	;skip space 34
   F5B9 00 00               145 	.word	0	;skip space 32
   F5BB 00 00               146 	.word	0	;skip space 30
   F5BD 00 00               147 	.word	0	;skip space 28
   F5BF 00 00               148 	.word	0	;skip space 26
   F5C1 00 00               149 	.word	0	;skip space 24
   F5C3 00 00               150 	.word	0	;skip space 22
   F5C5 00 00               151 	.word	0	;skip space 20
   F5C7 00 00               152 	.word	0	;skip space 18
   F5C9 00 00               153 	.word	0	;skip space 16
   F5CB 00 00               154 	.word	0	;skip space 14
   F5CD 00 00               155 	.word	0	;skip space 12
   F5CF 00 00               156 	.word	0	;skip space 10
   F5D1 00 00               157 	.word	0	;skip space 8
   F5D3 00 00               158 	.word	0	;skip space 6
   F5D5 00 00               159 	.word	0	;skip space 4
   F5D7 00 00               160 	.word	0	;skip space 2
                            161 	.globl ___Get_Rise_Idx
   F5D9                     162 ___Get_Rise_Idx:
   F5D9 00 00               163 	.word	0	;skip space 2
                            164 	.globl ___Xform_Sin
   F5DB                     165 ___Xform_Sin:
   F5DB 00 00               166 	.word	0	;skip space 20
   F5DD 00 00               167 	.word	0	;skip space 18
   F5DF 00 00               168 	.word	0	;skip space 16
   F5E1 00 00               169 	.word	0	;skip space 14
   F5E3 00 00               170 	.word	0	;skip space 12
   F5E5 00 00               171 	.word	0	;skip space 10
   F5E7 00 00               172 	.word	0	;skip space 8
   F5E9 00 00               173 	.word	0	;skip space 6
   F5EB 00 00               174 	.word	0	;skip space 4
   F5ED 00 00               175 	.word	0	;skip space 2
                            176 	.globl ___Get_Rise_Run
   F5EF                     177 ___Get_Rise_Run:
   F5EF 00 00               178 	.word	0	;skip space 16
   F5F1 00 00               179 	.word	0	;skip space 14
   F5F3 00 00               180 	.word	0	;skip space 12
   F5F5 00 00               181 	.word	0	;skip space 10
   F5F7 00 00               182 	.word	0	;skip space 8
   F5F9 00 00               183 	.word	0	;skip space 6
   F5FB 00 00               184 	.word	0	;skip space 4
   F5FD 00 00               185 	.word	0	;skip space 2
                            186 	.globl ___Rise_Run_X
   F5FF                     187 ___Rise_Run_X:
   F5FF 00                  188 	.byte	0	;skip space
ASxxxx Assembler V05.00  (Motorola 6809), page 1.
Hexidecimal [16-Bits]

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
  2 ___Abs_a_b         0073 GR  |   2 ___Abs_b           007A GR
  2 ___Bitmask_a       006D GR  |   2 ___Clear_C8_RA     0031 GR
  2 ___Clear_x_256     0034 GR  |   2 ___Clear_x_b       002E GR
  2 ___Clear_x_b_8     003F GR  |   2 ___Clear_x_b_a     0041 GR
  2 ___Clear_x_d       0037 GR  |   2 ___Dec_3_Count     0049 GR
  2 ___Dec_6_Count     004D GR  |   2 ___Dec_Counter     0052 GR
  2 ___Delay_0         0068 GR  |   2 ___Delay_1         0064 GR
  2 ___Delay_2         0060 GR  |   2 ___Delay_3         005C GR
  2 ___Delay_RTS       006C GR  |   2 ___Delay_b         0069 GR
  2 ___Get_Rise_Id     00C8 GR  |   2 ___Get_Rise_Ru     00DE GR
  2 ___Init_Music_     0022 GR  |   2 ___Random          0006 GR
  2 ___Random_3        0000 GR  |   2 ___Rise_Run_An     0082 GR
  2 ___Rise_Run_X      00EE GR  |   2 ___Xform_Sin       00CA GR

ASxxxx Assembler V05.00  (Motorola 6809), page 2.
Hexidecimal [16-Bits]

Area Table

[_CSEG]
   0 _CODE            size    0   flags C080
[_DSEG]
   1 _DATA            size    0   flags C0C0
[page_f5]
   2 .0xf5            size   EF   flags 8584

