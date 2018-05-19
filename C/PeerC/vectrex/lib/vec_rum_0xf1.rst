                              1 
                              2 ;;; gcc for m6809 : Feb 15 2016 21:40:10
                              3 ;;; 4.3.6 (gcc6809)
                              4 ;;; ABI version 1
                              5 ;;; -mint8
                              6 	.module	vec_rum_0xf1.c
                              7 ;----- asm -----
                              8 	.bank page_f1 (BASE=0xf14c,SIZE=0x00b4)
                              9 	.area .0xf1 (OVR,BANK=page_f1)
                             10 	
                             11 ;--- end asm ---
                             12 	.globl ___Init_VIA
                             13 	.area	.0xf1
   F14C                      14 ___Init_VIA:
   F14C 00 00                15 	.word	0	;skip space 24
   F14E 00 00                16 	.word	0	;skip space 22
   F150 00 00                17 	.word	0	;skip space 20
   F152 00 00                18 	.word	0	;skip space 18
   F154 00 00                19 	.word	0	;skip space 16
   F156 00 00                20 	.word	0	;skip space 14
   F158 00 00                21 	.word	0	;skip space 12
   F15A 00 00                22 	.word	0	;skip space 10
   F15C 00 00                23 	.word	0	;skip space 8
   F15E 00 00                24 	.word	0	;skip space 6
   F160 00 00                25 	.word	0	;skip space 4
   F162 00 00                26 	.word	0	;skip space 2
                             27 	.globl ___Init_OS_RAM
   F164                      28 ___Init_OS_RAM:
   F164 00 00                29 	.word	0	;skip space 39
   F166 00 00                30 	.word	0	;skip space 37
   F168 00 00                31 	.word	0	;skip space 35
   F16A 00 00                32 	.word	0	;skip space 33
   F16C 00 00                33 	.word	0	;skip space 31
   F16E 00 00                34 	.word	0	;skip space 29
   F170 00 00                35 	.word	0	;skip space 27
   F172 00 00                36 	.word	0	;skip space 25
   F174 00 00                37 	.word	0	;skip space 23
   F176 00 00                38 	.word	0	;skip space 21
   F178 00 00                39 	.word	0	;skip space 19
   F17A 00 00                40 	.word	0	;skip space 17
   F17C 00 00                41 	.word	0	;skip space 15
   F17E 00 00                42 	.word	0	;skip space 13
   F180 00 00                43 	.word	0	;skip space 11
   F182 00 00                44 	.word	0	;skip space 9
   F184 00 00                45 	.word	0	;skip space 7
   F186 00 00                46 	.word	0	;skip space 5
   F188 00 00                47 	.word	0	;skip space 3
   F18A 00                   48 	.byte	0	;skip space
                             49 	.globl ___Init_OS
   F18B                      50 ___Init_OS:
   F18B 00 00                51 	.word	0	;skip space 7
   F18D 00 00                52 	.word	0	;skip space 5
   F18F 00 00                53 	.word	0	;skip space 3
   F191 00                   54 	.byte	0	;skip space
                             55 	.globl ___Wait_Recal
   F192                      56 ___Wait_Recal:
   F192 00 00                57 	.word	0	;skip space 24
   F194 00 00                58 	.word	0	;skip space 22
   F196 00 00                59 	.word	0	;skip space 20
   F198 00 00                60 	.word	0	;skip space 18
   F19A 00 00                61 	.word	0	;skip space 16
   F19C 00 00                62 	.word	0	;skip space 14
   F19E 00 00                63 	.word	0	;skip space 12
   F1A0 00 00                64 	.word	0	;skip space 10
   F1A2 00 00                65 	.word	0	;skip space 8
   F1A4 00 00                66 	.word	0	;skip space 6
   F1A6 00 00                67 	.word	0	;skip space 4
   F1A8 00 00                68 	.word	0	;skip space 2
                             69 	.globl ___DP_to_D0
   F1AA                      70 ___DP_to_D0:
   F1AA 00 00                71 	.word	0	;skip space 5
   F1AC 00 00                72 	.word	0	;skip space 3
   F1AE 00                   73 	.byte	0	;skip space
                             74 	.globl ___DP_to_C8
   F1AF                      75 ___DP_to_C8:
   F1AF 00 00                76 	.word	0	;skip space 5
   F1B1 00 00                77 	.word	0	;skip space 3
   F1B3 00                   78 	.byte	0	;skip space
                             79 	.globl ___Read_Btns_Mask
   F1B4                      80 ___Read_Btns_Mask:
   F1B4 00 00                81 	.word	0	;skip space 6
   F1B6 00 00                82 	.word	0	;skip space 4
   F1B8 00 00                83 	.word	0	;skip space 2
                             84 	.globl ___Read_Btns
   F1BA                      85 ___Read_Btns:
   F1BA 00 00                86 	.word	0	;skip space 59
   F1BC 00 00                87 	.word	0	;skip space 57
   F1BE 00 00                88 	.word	0	;skip space 55
   F1C0 00 00                89 	.word	0	;skip space 53
   F1C2 00 00                90 	.word	0	;skip space 51
   F1C4 00 00                91 	.word	0	;skip space 49
   F1C6 00 00                92 	.word	0	;skip space 47
   F1C8 00 00                93 	.word	0	;skip space 45
   F1CA 00 00                94 	.word	0	;skip space 43
   F1CC 00 00                95 	.word	0	;skip space 41
   F1CE 00 00                96 	.word	0	;skip space 39
   F1D0 00 00                97 	.word	0	;skip space 37
   F1D2 00 00                98 	.word	0	;skip space 35
   F1D4 00 00                99 	.word	0	;skip space 33
   F1D6 00 00               100 	.word	0	;skip space 31
   F1D8 00 00               101 	.word	0	;skip space 29
   F1DA 00 00               102 	.word	0	;skip space 27
   F1DC 00 00               103 	.word	0	;skip space 25
   F1DE 00 00               104 	.word	0	;skip space 23
   F1E0 00 00               105 	.word	0	;skip space 21
   F1E2 00 00               106 	.word	0	;skip space 19
   F1E4 00 00               107 	.word	0	;skip space 17
   F1E6 00 00               108 	.word	0	;skip space 15
   F1E8 00 00               109 	.word	0	;skip space 13
   F1EA 00 00               110 	.word	0	;skip space 11
   F1EC 00 00               111 	.word	0	;skip space 9
   F1EE 00 00               112 	.word	0	;skip space 7
   F1F0 00 00               113 	.word	0	;skip space 5
   F1F2 00 00               114 	.word	0	;skip space 3
   F1F4 00                  115 	.byte	0	;skip space
                            116 	.globl ___Joy_Analog
   F1F5                     117 ___Joy_Analog:
   F1F5 00 00               118 	.word	0	;skip space 3
   F1F7 00                  119 	.byte	0	;skip space
                            120 	.globl ___Joy_Digital
   F1F8                     121 ___Joy_Digital:
   F1F8 00                  122 	.byte	0	;skip space
ASxxxx Assembler V05.00  (Motorola 6809), page 1.
Hexidecimal [16-Bits]

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
  2 ___DP_to_C8        0063 GR  |   2 ___DP_to_D0        005E GR
  2 ___Init_OS         003F GR  |   2 ___Init_OS_RAM     0018 GR
  2 ___Init_VIA        0000 GR  |   2 ___Joy_Analog      00A9 GR
  2 ___Joy_Digital     00AC GR  |   2 ___Read_Btns       006E GR
  2 ___Read_Btns_M     0068 GR  |   2 ___Wait_Recal      0046 GR

ASxxxx Assembler V05.00  (Motorola 6809), page 2.
Hexidecimal [16-Bits]

Area Table

[_CSEG]
   0 _CODE            size    0   flags C080
[_DSEG]
   1 _DATA            size    0   flags C0C0
[page_f1]
   2 .0xf1            size   AD   flags 8584

