                              1 
                              2 ;;; gcc for m6809 : Feb 15 2016 21:40:10
                              3 ;;; 4.3.6 (gcc6809)
                              4 ;;; ABI version 1
                              5 ;;; -mint8
                              6 	.module	vec_ram_0xc8_1.c
                              7 ;----- asm -----
                              8 	.bank page_c8 (BASE=0xc800,SIZE=0x0080)
                              9 	.area .dpc8 (OVR,BANK=page_c8)
                             10 	
                             11 ;--- end asm ---
                             12 	.globl _Vec_Snd_Shadow
                             13 	.area	.dpc8
   C800                      14 _Vec_Snd_Shadow:
   C800 00 00                15 	.word	0	;skip space 31
   C802 00 00                16 	.word	0	;skip space 29
   C804 00 00                17 	.word	0	;skip space 27
   C806 00 00                18 	.word	0	;skip space 25
   C808 00 00                19 	.word	0	;skip space 23
   C80A 00 00                20 	.word	0	;skip space 21
   C80C 00 00                21 	.word	0	;skip space 19
   C80E 00 00                22 	.word	0	;skip space 17
   C810 00 00                23 	.word	0	;skip space 15
   C812 00 00                24 	.word	0	;skip space 13
   C814 00 00                25 	.word	0	;skip space 11
   C816 00 00                26 	.word	0	;skip space 9
   C818 00 00                27 	.word	0	;skip space 7
   C81A 00 00                28 	.word	0	;skip space 5
   C81C 00 00                29 	.word	0	;skip space 3
   C81E 00                   30 	.byte	0	;skip space
                             31 	.globl _Vec_Joy_Mux_1_X
   C81F                      32 _Vec_Joy_Mux_1_X:
   C81F 00                   33 	.byte	0	;skip space
                             34 	.globl _Vec_Joy_Mux_1_Y
   C820                      35 _Vec_Joy_Mux_1_Y:
   C820 00                   36 	.byte	0	;skip space
                             37 	.globl _Vec_Joy_Mux_2_X
   C821                      38 _Vec_Joy_Mux_2_X:
   C821 00                   39 	.byte	0	;skip space
                             40 	.globl _Vec_Joy_Mux_2_Y
   C822                      41 _Vec_Joy_Mux_2_Y:
   C822 00 00                42 	.word	0	;skip space 3
   C824 00                   43 	.byte	0	;skip space
                             44 	.globl _Vec_Loop_Count_hi
   C825                      45 _Vec_Loop_Count_hi:
   C825 00                   46 	.byte	0	;skip space
                             47 	.globl _Vec_Loop_Count_lo
   C826                      48 _Vec_Loop_Count_lo:
   C826 00 00                49 	.word	0	;skip space 4
   C828 00 00                50 	.word	0	;skip space 2
                             51 	.globl _Vec_Text_Height
   C82A                      52 _Vec_Text_Height:
   C82A 00                   53 	.byte	0	;skip space
                             54 	.globl _Vec_Text_Width
   C82B                      55 _Vec_Text_Width:
   C82B 00 00                56 	.word	0	;skip space 3
   C82D 00                   57 	.byte	0	;skip space
                             58 	.globl _Vec_Counter_1
   C82E                      59 _Vec_Counter_1:
   C82E 00                   60 	.byte	0	;skip space
                             61 	.globl _Vec_Counter_2
   C82F                      62 _Vec_Counter_2:
   C82F 00                   63 	.byte	0	;skip space
                             64 	.globl _Vec_Counter_3
   C830                      65 _Vec_Counter_3:
   C830 00                   66 	.byte	0	;skip space
                             67 	.globl _Vec_Counter_4
   C831                      68 _Vec_Counter_4:
   C831 00                   69 	.byte	0	;skip space
                             70 	.globl _Vec_Counter_5
   C832                      71 _Vec_Counter_5:
   C832 00                   72 	.byte	0	;skip space
                             73 	.globl _Vec_Counter_6
   C833                      74 _Vec_Counter_6:
   C833 00 00                75 	.word	0	;skip space 6
   C835 00 00                76 	.word	0	;skip space 4
   C837 00 00                77 	.word	0	;skip space 2
                             78 	.globl _Vec_XXX_00
   C839                      79 _Vec_XXX_00:
   C839 00 00                80 	.word	0	;skip space 2
                             81 	.globl _Vec_XXX_01
   C83B                      82 _Vec_XXX_01:
   C83B 00 00                83 	.word	0	;skip space 2
                             84 	.globl _Vec_Rfrsh_lo
   C83D                      85 _Vec_Rfrsh_lo:
   C83D 00                   86 	.byte	0	;skip space
                             87 	.globl _Vec_Rfrsh_hi
   C83E                      88 _Vec_Rfrsh_hi:
   C83E 00 00                89 	.word	0	;skip space 17
   C840 00 00                90 	.word	0	;skip space 15
   C842 00 00                91 	.word	0	;skip space 13
   C844 00 00                92 	.word	0	;skip space 11
   C846 00 00                93 	.word	0	;skip space 9
   C848 00 00                94 	.word	0	;skip space 7
   C84A 00 00                95 	.word	0	;skip space 5
   C84C 00 00                96 	.word	0	;skip space 3
   C84E 00                   97 	.byte	0	;skip space
                             98 	.globl _Vec_Max_Players
   C84F                      99 _Vec_Max_Players:
   C84F 00                  100 	.byte	0	;skip space
                            101 	.globl _Vec_Max_Games
   C850                     102 _Vec_Max_Games:
   C850 00 00               103 	.word	0	;skip space 3
   C852 00                  104 	.byte	0	;skip space
                            105 	.globl _Vec_Expl_ChanA
   C853                     106 _Vec_Expl_ChanA:
   C853 00                  107 	.byte	0	;skip space
                            108 	.globl _Vec_Expl_Chans
   C854                     109 _Vec_Expl_Chans:
   C854 00 00               110 	.word	0	;skip space 4
   C856 00 00               111 	.word	0	;skip space 2
                            112 	.globl _Vec_Music_Twang
   C858                     113 _Vec_Music_Twang:
   C858 00 00               114 	.word	0	;skip space 6
   C85A 00 00               115 	.word	0	;skip space 4
   C85C 00 00               116 	.word	0	;skip space 2
                            117 	.globl _Vec_ADSR_Timers
   C85E                     118 _Vec_ADSR_Timers:
   C85E 00 00               119 	.word	0	;skip space 3
   C860 00                  120 	.byte	0	;skip space
                            121 	.globl _Vec_Music_Freq
   C861                     122 _Vec_Music_Freq:
   C861 00 00               123 	.word	0	;skip space 28
   C863 00 00               124 	.word	0	;skip space 26
   C865 00 00               125 	.word	0	;skip space 24
   C867 00 00               126 	.word	0	;skip space 22
   C869 00 00               127 	.word	0	;skip space 20
   C86B 00 00               128 	.word	0	;skip space 18
   C86D 00 00               129 	.word	0	;skip space 16
   C86F 00 00               130 	.word	0	;skip space 14
   C871 00 00               131 	.word	0	;skip space 12
   C873 00 00               132 	.word	0	;skip space 10
   C875 00 00               133 	.word	0	;skip space 8
   C877 00 00               134 	.word	0	;skip space 6
   C879 00 00               135 	.word	0	;skip space 4
   C87B 00 00               136 	.word	0	;skip space 2
                            137 	.globl _Vec_Random_Seed
   C87D                     138 _Vec_Random_Seed:
   C87D 00                  139 	.byte	0	;skip space
ASxxxx Assembler V05.00  (Motorola 6809), page 1.
Hexidecimal [16-Bits]

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
  2 _Vec_ADSR_Time     005E GR  |   2 _Vec_Counter_1     002E GR
  2 _Vec_Counter_2     002F GR  |   2 _Vec_Counter_3     0030 GR
  2 _Vec_Counter_4     0031 GR  |   2 _Vec_Counter_5     0032 GR
  2 _Vec_Counter_6     0033 GR  |   2 _Vec_Expl_Chan     0053 GR
  2 _Vec_Expl_Chan     0054 GR  |   2 _Vec_Joy_Mux_1     001F GR
  2 _Vec_Joy_Mux_1     0020 GR  |   2 _Vec_Joy_Mux_2     0021 GR
  2 _Vec_Joy_Mux_2     0022 GR  |   2 _Vec_Loop_Coun     0025 GR
  2 _Vec_Loop_Coun     0026 GR  |   2 _Vec_Max_Games     0050 GR
  2 _Vec_Max_Playe     004F GR  |   2 _Vec_Music_Fre     0061 GR
  2 _Vec_Music_Twa     0058 GR  |   2 _Vec_Random_Se     007D GR
  2 _Vec_Rfrsh_hi      003E GR  |   2 _Vec_Rfrsh_lo      003D GR
  2 _Vec_Snd_Shado     0000 GR  |   2 _Vec_Text_Heig     002A GR
  2 _Vec_Text_Widt     002B GR  |   2 _Vec_XXX_00        0039 GR
  2 _Vec_XXX_01        003B GR

ASxxxx Assembler V05.00  (Motorola 6809), page 2.
Hexidecimal [16-Bits]

Area Table

[_CSEG]
   0 _CODE            size    0   flags C080
[_DSEG]
   1 _DATA            size    0   flags C0C0
[page_c8]
   2 .dpc8            size   7E   flags 8584

