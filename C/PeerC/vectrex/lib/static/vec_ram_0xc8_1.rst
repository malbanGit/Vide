                              1 ;;; gcc for m6809 : Mar 17 2019 13:25:32
                              2 ;;; 4.3.6 (gcc6809)
                              3 ;;; ABI version 1
                              4 ;;; -mabi=bx -mint8 -fomit-frame-pointer -O0
                              5 	.module	vec_ram_0xc8_1.c
                              6 ;----- asm -----
                              7 	.bank page_c8 (BASE=0xc800,SIZE=0x0080)
                              8 	.area .dpc8 (OVR,BANK=page_c8)
                              9 	
                             10 ;--- end asm ---
                             11 	.globl	_Vec_Snd_Shadow
                             12 	.area	.dpc8
   C800                      13 _Vec_Snd_Shadow:
   C800 00 00 00 00 00 00    14 	.word	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
   C81E 00                   15 	.byte	0
                             16 	.globl	_Vec_Joy_Mux_1_X
   C81F                      17 _Vec_Joy_Mux_1_X:
   C81F 00                   18 	.byte	0
                             19 	.globl	_Vec_Joy_Mux_1_Y
   C820                      20 _Vec_Joy_Mux_1_Y:
   C820 00                   21 	.byte	0
                             22 	.globl	_Vec_Joy_Mux_2_X
   C821                      23 _Vec_Joy_Mux_2_X:
   C821 00                   24 	.byte	0
                             25 	.globl	_Vec_Joy_Mux_2_Y
   C822                      26 _Vec_Joy_Mux_2_Y:
   C822 00 00                27 	.word	0
   C824 00                   28 	.byte	0
                             29 	.globl	_Vec_Loop_Count_hi
   C825                      30 _Vec_Loop_Count_hi:
   C825 00                   31 	.byte	0
                             32 	.globl	_Vec_Loop_Count_lo
   C826                      33 _Vec_Loop_Count_lo:
   C826 00 00 00 00          34 	.word	0,0
                             35 	.globl	_Vec_Text_Height
   C82A                      36 _Vec_Text_Height:
   C82A 00                   37 	.byte	0
                             38 	.globl	_Vec_Text_Width
   C82B                      39 _Vec_Text_Width:
   C82B 00 00                40 	.word	0
   C82D 00                   41 	.byte	0
                             42 	.globl	_Vec_Counter_1
   C82E                      43 _Vec_Counter_1:
   C82E 00                   44 	.byte	0
                             45 	.globl	_Vec_Counter_2
   C82F                      46 _Vec_Counter_2:
   C82F 00                   47 	.byte	0
                             48 	.globl	_Vec_Counter_3
   C830                      49 _Vec_Counter_3:
   C830 00                   50 	.byte	0
                             51 	.globl	_Vec_Counter_4
   C831                      52 _Vec_Counter_4:
   C831 00                   53 	.byte	0
                             54 	.globl	_Vec_Counter_5
   C832                      55 _Vec_Counter_5:
   C832 00                   56 	.byte	0
                             57 	.globl	_Vec_Counter_6
   C833                      58 _Vec_Counter_6:
   C833 00 00 00 00 00 00    59 	.word	0,0,0
                             60 	.globl	_Vec_XXX_00
   C839                      61 _Vec_XXX_00:
   C839 00 00                62 	.word	0
                             63 	.globl	_Vec_XXX_01
   C83B                      64 _Vec_XXX_01:
   C83B 00 00                65 	.word	0
                             66 	.globl	_Vec_Rfrsh_lo
   C83D                      67 _Vec_Rfrsh_lo:
   C83D 00                   68 	.byte	0
                             69 	.globl	_Vec_Rfrsh_hi
   C83E                      70 _Vec_Rfrsh_hi:
   C83E 00 00 00 00 00 00    71 	.word	0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00
   C84E 00                   72 	.byte	0
                             73 	.globl	_Vec_Max_Players
   C84F                      74 _Vec_Max_Players:
   C84F 00                   75 	.byte	0
                             76 	.globl	_Vec_Max_Games
   C850                      77 _Vec_Max_Games:
   C850 00 00                78 	.word	0
   C852 00                   79 	.byte	0
                             80 	.globl	_Vec_Expl_ChanA
   C853                      81 _Vec_Expl_ChanA:
   C853 00                   82 	.byte	0
                             83 	.globl	_Vec_Expl_Chans
   C854                      84 _Vec_Expl_Chans:
   C854 00 00 00 00          85 	.word	0,0
                             86 	.globl	_Vec_Music_Twang
   C858                      87 _Vec_Music_Twang:
   C858 00 00 00 00 00 00    88 	.word	0,0,0
                             89 	.globl	_Vec_ADSR_Timers
   C85E                      90 _Vec_ADSR_Timers:
   C85E 00 00                91 	.word	0
   C860 00                   92 	.byte	0
                             93 	.globl	_Vec_Music_Freq
   C861                      94 _Vec_Music_Freq:
   C861 00 00 00 00 00 00    95 	.word	0,0,0,0,0,0,0,0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00 00 00
                             96 	.globl	_Vec_Random_Seed
   C87D                      97 _Vec_Random_Seed:
   C87D 00                   98 	.byte	0
ASxxxx Assembler V05.31  (Motorola 6809)                                Page 1
Hexadecimal [16-Bits]                                 Thu Jan 30 13:14:27 2020

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

ASxxxx Assembler V05.31  (Motorola 6809)                                Page 2
Hexadecimal [16-Bits]                                 Thu Jan 30 13:14:27 2020

Area Table

[_CSEG]
   0 _CODE            size    0   flags C080
[_DSEG]
   1 _DATA            size    0   flags C0C0
[page_c8]
   2 .dpc8            size   7E   flags 8584

