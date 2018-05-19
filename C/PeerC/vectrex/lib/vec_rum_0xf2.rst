                              1 
                              2 ;;; gcc for m6809 : Feb 15 2016 21:40:10
                              3 ;;; 4.3.6 (gcc6809)
                              4 ;;; ABI version 1
                              5 ;;; -mint8
                              6 	.module	vec_rum_0xf2.c
                              7 ;----- asm -----
                              8 	.bank page_f2 (BASE=0xf256,SIZE=0x00aa)
                              9 	.area .0xf2 (OVR,BANK=page_f2)
                             10 	
                             11 ;--- end asm ---
                             12 	.globl ___Sound_Byte
                             13 	.area	.0xf2
   F256                      14 ___Sound_Byte:
   F256 00 00                15 	.word	0	;skip space 3
   F258 00                   16 	.byte	0	;skip space
                             17 	.globl ___Sound_Byte_x
   F259                      18 ___Sound_Byte_x:
   F259 00 00                19 	.word	0	;skip space 25
   F25B 00 00                20 	.word	0	;skip space 23
   F25D 00 00                21 	.word	0	;skip space 21
   F25F 00 00                22 	.word	0	;skip space 19
   F261 00 00                23 	.word	0	;skip space 17
   F263 00 00                24 	.word	0	;skip space 15
   F265 00 00                25 	.word	0	;skip space 13
   F267 00 00                26 	.word	0	;skip space 11
   F269 00 00                27 	.word	0	;skip space 9
   F26B 00 00                28 	.word	0	;skip space 7
   F26D 00 00                29 	.word	0	;skip space 5
   F26F 00 00                30 	.word	0	;skip space 3
   F271 00                   31 	.byte	0	;skip space
                             32 	.globl ___Clear_Sound
   F272                      33 ___Clear_Sound:
   F272 00 00                34 	.word	0	;skip space 11
   F274 00 00                35 	.word	0	;skip space 9
   F276 00 00                36 	.word	0	;skip space 7
   F278 00 00                37 	.word	0	;skip space 5
   F27A 00 00                38 	.word	0	;skip space 3
   F27C 00                   39 	.byte	0	;skip space
                             40 	.globl ___Sound_Bytes
   F27D                      41 ___Sound_Bytes:
   F27D 00 00                42 	.word	0	;skip space 7
   F27F 00 00                43 	.word	0	;skip space 5
   F281 00 00                44 	.word	0	;skip space 3
   F283 00                   45 	.byte	0	;skip space
                             46 	.globl ___Sound_Bytes_x
   F284                      47 ___Sound_Bytes_x:
   F284 00 00                48 	.word	0	;skip space 5
   F286 00 00                49 	.word	0	;skip space 3
   F288 00                   50 	.byte	0	;skip space
                             51 	.globl ___Do_Sound
   F289                      52 ___Do_Sound:
   F289 00 00                53 	.word	0	;skip space 3
   F28B 00                   54 	.byte	0	;skip space
                             55 	.globl ___Do_Sound_x
   F28C                      56 ___Do_Sound_x:
   F28C 00 00                57 	.word	0	;skip space 17
   F28E 00 00                58 	.word	0	;skip space 15
   F290 00 00                59 	.word	0	;skip space 13
   F292 00 00                60 	.word	0	;skip space 11
   F294 00 00                61 	.word	0	;skip space 9
   F296 00 00                62 	.word	0	;skip space 7
   F298 00 00                63 	.word	0	;skip space 5
   F29A 00 00                64 	.word	0	;skip space 3
   F29C 00                   65 	.byte	0	;skip space
                             66 	.globl ___Intensity_1F
   F29D                      67 ___Intensity_1F:
   F29D 00 00                68 	.word	0	;skip space 4
   F29F 00 00                69 	.word	0	;skip space 2
                             70 	.globl ___Intensity_3F
   F2A1                      71 ___Intensity_3F:
   F2A1 00 00                72 	.word	0	;skip space 4
   F2A3 00 00                73 	.word	0	;skip space 2
                             74 	.globl ___Intensity_5F
   F2A5                      75 ___Intensity_5F:
   F2A5 00 00                76 	.word	0	;skip space 4
   F2A7 00 00                77 	.word	0	;skip space 2
                             78 	.globl ___Intensity_7F
   F2A9                      79 ___Intensity_7F:
   F2A9 00 00                80 	.word	0	;skip space 2
                             81 	.globl ___Intensity_a
   F2AB                      82 ___Intensity_a:
   F2AB 00 00                83 	.word	0	;skip space 19
   F2AD 00 00                84 	.word	0	;skip space 17
   F2AF 00 00                85 	.word	0	;skip space 15
   F2B1 00 00                86 	.word	0	;skip space 13
   F2B3 00 00                87 	.word	0	;skip space 11
   F2B5 00 00                88 	.word	0	;skip space 9
   F2B7 00 00                89 	.word	0	;skip space 7
   F2B9 00 00                90 	.word	0	;skip space 5
   F2BB 00 00                91 	.word	0	;skip space 3
   F2BD 00                   92 	.byte	0	;skip space
                             93 	.globl ___Dot_ix_b
   F2BE                      94 ___Dot_ix_b:
   F2BE 00 00                95 	.word	0	;skip space 3
   F2C0 00                   96 	.byte	0	;skip space
                             97 	.globl ___Dot_ix
   F2C1                      98 ___Dot_ix:
   F2C1 00 00                99 	.word	0	;skip space 2
                            100 	.globl ___Dot_d
   F2C3                     101 ___Dot_d:
   F2C3 00 00               102 	.word	0	;skip space 2
                            103 	.globl ___Dot_here
   F2C5                     104 ___Dot_here:
   F2C5 00 00               105 	.word	0	;skip space 16
   F2C7 00 00               106 	.word	0	;skip space 14
   F2C9 00 00               107 	.word	0	;skip space 12
   F2CB 00 00               108 	.word	0	;skip space 10
   F2CD 00 00               109 	.word	0	;skip space 8
   F2CF 00 00               110 	.word	0	;skip space 6
   F2D1 00 00               111 	.word	0	;skip space 4
   F2D3 00 00               112 	.word	0	;skip space 2
                            113 	.globl ___Dot_List
   F2D5                     114 ___Dot_List:
   F2D5 00 00               115 	.word	0	;skip space 9
   F2D7 00 00               116 	.word	0	;skip space 7
   F2D9 00 00               117 	.word	0	;skip space 5
   F2DB 00 00               118 	.word	0	;skip space 3
   F2DD 00                  119 	.byte	0	;skip space
                            120 	.globl ___Dot_List_Reset
   F2DE                     121 ___Dot_List_Reset:
   F2DE 00 00               122 	.word	0	;skip space 8
   F2E0 00 00               123 	.word	0	;skip space 6
   F2E2 00 00               124 	.word	0	;skip space 4
   F2E4 00 00               125 	.word	0	;skip space 2
                            126 	.globl ___Recalibrate
   F2E6                     127 ___Recalibrate:
   F2E6 00 00               128 	.word	0	;skip space 12
   F2E8 00 00               129 	.word	0	;skip space 10
   F2EA 00 00               130 	.word	0	;skip space 8
   F2EC 00 00               131 	.word	0	;skip space 6
   F2EE 00 00               132 	.word	0	;skip space 4
   F2F0 00 00               133 	.word	0	;skip space 2
                            134 	.globl ___Moveto_x_7F
   F2F2                     135 ___Moveto_x_7F:
   F2F2 00 00               136 	.word	0	;skip space 10
   F2F4 00 00               137 	.word	0	;skip space 8
   F2F6 00 00               138 	.word	0	;skip space 6
   F2F8 00 00               139 	.word	0	;skip space 4
   F2FA 00 00               140 	.word	0	;skip space 2
                            141 	.globl ___Moveto_d_7F
   F2FC                     142 ___Moveto_d_7F:
   F2FC 00                  143 	.byte	0	;skip space
ASxxxx Assembler V05.00  (Motorola 6809), page 1.
Hexidecimal [16-Bits]

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
  2 ___Clear_Sound     001C GR  |   2 ___Do_Sound        0033 GR
  2 ___Do_Sound_x      0036 GR  |   2 ___Dot_List        007F GR
  2 ___Dot_List_Re     0088 GR  |   2 ___Dot_d           006D GR
  2 ___Dot_here        006F GR  |   2 ___Dot_ix          006B GR
  2 ___Dot_ix_b        0068 GR  |   2 ___Intensity_1     0047 GR
  2 ___Intensity_3     004B GR  |   2 ___Intensity_5     004F GR
  2 ___Intensity_7     0053 GR  |   2 ___Intensity_a     0055 GR
  2 ___Moveto_d_7F     00A6 GR  |   2 ___Moveto_x_7F     009C GR
  2 ___Recalibrate     0090 GR  |   2 ___Sound_Byte      0000 GR
  2 ___Sound_Byte_     0003 GR  |   2 ___Sound_Bytes     0027 GR
  2 ___Sound_Bytes     002E GR

ASxxxx Assembler V05.00  (Motorola 6809), page 2.
Hexidecimal [16-Bits]

Area Table

[_CSEG]
   0 _CODE            size    0   flags C080
[_DSEG]
   1 _DATA            size    0   flags C0C0
[page_f2]
   2 .0xf2            size   A7   flags 8584

