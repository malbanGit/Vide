                              1 
                              2 ;;; gcc for m6809 : Feb 15 2016 21:40:10
                              3 ;;; 4.3.6 (gcc6809)
                              4 ;;; ABI version 1
                              5 ;;; -mint8
                              6 	.module	vec_rum_0xf6.c
                              7 ;----- asm -----
                              8 	.bank page_f6 (BASE=0xf601,SIZE=0x00ff)
                              9 	.area .0xf6 (OVR,BANK=page_f6)
                             10 	
                             11 ;--- end asm ---
                             12 	.globl ___Rise_Run_Y
                             13 	.area	.0xf6
   F601                      14 ___Rise_Run_Y:
   F601 00 00                15 	.word	0	;skip space 2
                             16 	.globl ___Rise_Run_Len
   F603                      17 ___Rise_Run_Len:
   F603 00 00                18 	.word	0	;skip space 13
   F605 00 00                19 	.word	0	;skip space 11
   F607 00 00                20 	.word	0	;skip space 9
   F609 00 00                21 	.word	0	;skip space 7
   F60B 00 00                22 	.word	0	;skip space 5
   F60D 00 00                23 	.word	0	;skip space 3
   F60F 00                   24 	.byte	0	;skip space
                             25 	.globl ___Rot_VL_ab
   F610                      26 ___Rot_VL_ab:
   F610 00 00                27 	.word	0	;skip space 3
   F612 00                   28 	.byte	0	;skip space
                             29 	.globl ___Rot_VL_Diff
   F613                      30 ___Rot_VL_Diff:
   F613 00 00                31 	.word	0	;skip space 3
   F615 00                   32 	.byte	0	;skip space
                             33 	.globl ___Rot_VL
   F616                      34 ___Rot_VL:
   F616 00 00                35 	.word	0	;skip space 9
   F618 00 00                36 	.word	0	;skip space 7
   F61A 00 00                37 	.word	0	;skip space 5
   F61C 00 00                38 	.word	0	;skip space 3
   F61E 00                   39 	.byte	0	;skip space
                             40 	.globl ___Rot_VL_Mode
   F61F                      41 ___Rot_VL_Mode:
   F61F 00 00                42 	.word	0	;skip space 3
   F621 00                   43 	.byte	0	;skip space
                             44 	.globl ___Rot_VL_Pack
   F622                      45 ___Rot_VL_Pack:
   F622 00 00                46 	.word	0	;skip space 9
   F624 00 00                47 	.word	0	;skip space 7
   F626 00 00                48 	.word	0	;skip space 5
   F628 00 00                49 	.word	0	;skip space 3
   F62A 00                   50 	.byte	0	;skip space
                             51 	.globl ___Rot_VL_M_dft
   F62B                      52 ___Rot_VL_M_dft:
   F62B 00 00                53 	.word	0	;skip space 48
   F62D 00 00                54 	.word	0	;skip space 46
   F62F 00 00                55 	.word	0	;skip space 44
   F631 00 00                56 	.word	0	;skip space 42
   F633 00 00                57 	.word	0	;skip space 40
   F635 00 00                58 	.word	0	;skip space 38
   F637 00 00                59 	.word	0	;skip space 36
   F639 00 00                60 	.word	0	;skip space 34
   F63B 00 00                61 	.word	0	;skip space 32
   F63D 00 00                62 	.word	0	;skip space 30
   F63F 00 00                63 	.word	0	;skip space 28
   F641 00 00                64 	.word	0	;skip space 26
   F643 00 00                65 	.word	0	;skip space 24
   F645 00 00                66 	.word	0	;skip space 22
   F647 00 00                67 	.word	0	;skip space 20
   F649 00 00                68 	.word	0	;skip space 18
   F64B 00 00                69 	.word	0	;skip space 16
   F64D 00 00                70 	.word	0	;skip space 14
   F64F 00 00                71 	.word	0	;skip space 12
   F651 00 00                72 	.word	0	;skip space 10
   F653 00 00                73 	.word	0	;skip space 8
   F655 00 00                74 	.word	0	;skip space 6
   F657 00 00                75 	.word	0	;skip space 4
   F659 00 00                76 	.word	0	;skip space 2
                             77 	.globl ___Xform_Run_a
   F65B                      78 ___Xform_Run_a:
   F65B 00 00                79 	.word	0	;skip space 2
                             80 	.globl ___Xform_Run
   F65D                      81 ___Xform_Run:
   F65D 00 00                82 	.word	0	;skip space 4
   F65F 00 00                83 	.word	0	;skip space 2
                             84 	.globl ___Xform_Rise_a
   F661                      85 ___Xform_Rise_a:
   F661 00 00                86 	.word	0	;skip space 2
                             87 	.globl ___Xform_Rise
   F663                      88 ___Xform_Rise:
   F663 00 00                89 	.word	0	;skip space 28
   F665 00 00                90 	.word	0	;skip space 26
   F667 00 00                91 	.word	0	;skip space 24
   F669 00 00                92 	.word	0	;skip space 22
   F66B 00 00                93 	.word	0	;skip space 20
   F66D 00 00                94 	.word	0	;skip space 18
   F66F 00 00                95 	.word	0	;skip space 16
   F671 00 00                96 	.word	0	;skip space 14
   F673 00 00                97 	.word	0	;skip space 12
   F675 00 00                98 	.word	0	;skip space 10
   F677 00 00                99 	.word	0	;skip space 8
   F679 00 00               100 	.word	0	;skip space 6
   F67B 00 00               101 	.word	0	;skip space 4
   F67D 00 00               102 	.word	0	;skip space 2
                            103 	.globl ___Move_Mem_a_1
   F67F                     104 ___Move_Mem_a_1:
   F67F 00 00               105 	.word	0	;skip space 4
   F681 00 00               106 	.word	0	;skip space 2
                            107 	.globl ___Move_Mem_a
   F683                     108 ___Move_Mem_a:
   F683 00 00               109 	.word	0	;skip space 4
   F685 00 00               110 	.word	0	;skip space 2
                            111 	.globl ___Init_Music_chk
   F687                     112 ___Init_Music_chk:
   F687 00 00               113 	.word	0	;skip space 6
   F689 00 00               114 	.word	0	;skip space 4
   F68B 00 00               115 	.word	0	;skip space 2
                            116 	.globl ___Init_Music
   F68D                     117 ___Init_Music:
   F68D 00 00               118 	.word	0	;skip space 3
   F68F 00                  119 	.byte	0	;skip space
                            120 	.globl ___Init_Music_a
   F690                     121 ___Init_Music_a:
   F690 00 00               122 	.word	0	;skip space 2
                            123 	.globl ___Init_Music_x
   F692                     124 ___Init_Music_x:
   F692 00                  125 	.byte	0	;skip space
ASxxxx Assembler V05.00  (Motorola 6809), page 1.
Hexidecimal [16-Bits]

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
  2 ___Init_Music      008C GR  |   2 ___Init_Music_     008F GR
  2 ___Init_Music_     0086 GR  |   2 ___Init_Music_     0091 GR
  2 ___Move_Mem_a      0082 GR  |   2 ___Move_Mem_a_     007E GR
  2 ___Rise_Run_Le     0002 GR  |   2 ___Rise_Run_Y      0000 GR
  2 ___Rot_VL          0015 GR  |   2 ___Rot_VL_Diff     0012 GR
  2 ___Rot_VL_M_df     002A GR  |   2 ___Rot_VL_Mode     001E GR
  2 ___Rot_VL_Pack     0021 GR  |   2 ___Rot_VL_ab       000F GR
  2 ___Xform_Rise      0062 GR  |   2 ___Xform_Rise_     0060 GR
  2 ___Xform_Run       005C GR  |   2 ___Xform_Run_a     005A GR

ASxxxx Assembler V05.00  (Motorola 6809), page 2.
Hexidecimal [16-Bits]

Area Table

[_CSEG]
   0 _CODE            size    0   flags C080
[_DSEG]
   1 _DATA            size    0   flags C0C0
[page_f6]
   2 .0xf6            size   92   flags 8584

