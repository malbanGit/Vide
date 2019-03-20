                              1 ;;; gcc for m6809 : Mar 11 2019 13:34:05
                              2 ;;; 4.3.6 (gcc6809)
                              3 ;;; ABI version 1
                              4 ;;; -mabi=bx -mint8 -fomit-frame-pointer -O2
                              5 	.module	vec_ram_0xc8_0.c
                              6 ;----- asm -----
                              7 	.bank page_c8 (BASE=0xc800,SIZE=0x0080)
                              8 	.area .dpc8 (OVR,BANK=page_c8)
                              9 	
                             10 ;--- end asm ---
                             11 	.globl	_Vec_Snd_shadow
                             12 	.area	.dpc8
   C800                      13 _Vec_Snd_shadow:
   C800 00 00 00 00 00 00    14 	.word	0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00
   C80E 00                   15 	.byte	0
                             16 	.globl	_Vec_Btn_State
   C80F                      17 _Vec_Btn_State:
   C80F 00                   18 	.byte	0
                             19 	.globl	_Vec_Prev_Btns
   C810                      20 _Vec_Prev_Btns:
   C810 00                   21 	.byte	0
                             22 	.globl	_Vec_Buttons
   C811                      23 _Vec_Buttons:
   C811 00                   24 	.byte	0
                             25 	.globl	_Vec_Button_1_1
   C812                      26 _Vec_Button_1_1:
   C812 00                   27 	.byte	0
                             28 	.globl	_Vec_Button_1_2
   C813                      29 _Vec_Button_1_2:
   C813 00                   30 	.byte	0
                             31 	.globl	_Vec_Button_1_3
   C814                      32 _Vec_Button_1_3:
   C814 00                   33 	.byte	0
                             34 	.globl	_Vec_Button_1_4
   C815                      35 _Vec_Button_1_4:
   C815 00                   36 	.byte	0
                             37 	.globl	_Vec_Button_2_1
   C816                      38 _Vec_Button_2_1:
   C816 00                   39 	.byte	0
                             40 	.globl	_Vec_Button_2_2
   C817                      41 _Vec_Button_2_2:
   C817 00                   42 	.byte	0
                             43 	.globl	_Vec_Button_2_3
   C818                      44 _Vec_Button_2_3:
   C818 00                   45 	.byte	0
                             46 	.globl	_Vec_Button_2_4
   C819                      47 _Vec_Button_2_4:
   C819 00                   48 	.byte	0
                             49 	.globl	_Vec_Joy_Resltn
   C81A                      50 _Vec_Joy_Resltn:
   C81A 00                   51 	.byte	0
                             52 	.globl	_Vec_Joy_1_X
   C81B                      53 _Vec_Joy_1_X:
   C81B 00                   54 	.byte	0
                             55 	.globl	_Vec_Joy_1_Y
   C81C                      56 _Vec_Joy_1_Y:
   C81C 00                   57 	.byte	0
                             58 	.globl	_Vec_Joy_2_X
   C81D                      59 _Vec_Joy_2_X:
   C81D 00                   60 	.byte	0
                             61 	.globl	_Vec_Joy_2_Y
   C81E                      62 _Vec_Joy_2_Y:
   C81E 00                   63 	.byte	0
                             64 	.globl	_Vec_Joy_mux
   C81F                      65 _Vec_Joy_mux:
   C81F 00 00 00 00          66 	.word	0,0
                             67 	.globl	_Vec_Misc_Count
   C823                      68 _Vec_Misc_Count:
   C823 00                   69 	.byte	0
                             70 	.globl	_Vec_0Ref_Enable
   C824                      71 _Vec_0Ref_Enable:
   C824 00                   72 	.byte	0
                             73 	.globl	_Vec_Loop_Count
   C825                      74 _Vec_Loop_Count:
   C825 00 00                75 	.word	0
                             76 	.globl	_Vec_Brightness
   C827                      77 _Vec_Brightness:
   C827 00                   78 	.byte	0
                             79 	.globl	_Vec_Dot_Dwell
   C828                      80 _Vec_Dot_Dwell:
   C828 00                   81 	.byte	0
                             82 	.globl	_Vec_Pattern
   C829                      83 _Vec_Pattern:
   C829 00                   84 	.byte	0
                             85 	.globl	_Vec_Text_HW
   C82A                      86 _Vec_Text_HW:
   C82A 00 00                87 	.word	0
                             88 	.globl	_Vec_Str_Ptr
   C82C                      89 _Vec_Str_Ptr:
   C82C 00 00                90 	.word	0
                             91 	.globl	_Vec_counters
   C82E                      92 _Vec_counters:
   C82E 00 00 00 00 00 00    93 	.word	0,0,0
                             94 	.globl	_Vec_RiseRun_Tmp
   C834                      95 _Vec_RiseRun_Tmp:
   C834 00 00                96 	.word	0
                             97 	.globl	_Vec_Angle
   C836                      98 _Vec_Angle:
   C836 00                   99 	.byte	0
                            100 	.globl	_Vec_Run_Index
   C837                     101 _Vec_Run_Index:
   C837 00 00               102 	.word	0
                            103 	.globl	_Vec_Rise_Index
   C839                     104 _Vec_Rise_Index:
   C839 00 00               105 	.word	0
                            106 	.globl	_Vec_RiseRun_Len
   C83B                     107 _Vec_RiseRun_Len:
   C83B 00                  108 	.byte	0
                            109 	.globl	_Vec_XXX_02
   C83C                     110 _Vec_XXX_02:
   C83C 00                  111 	.byte	0
                            112 	.globl	_Vec_Rfrsh
   C83D                     113 _Vec_Rfrsh:
   C83D 00 00               114 	.word	0
                            115 	.globl	_Vec_Music_Work
   C83F                     116 _Vec_Music_Work:
   C83F 00 00               117 	.word	0
   C841 00                  118 	.byte	0
                            119 	.globl	_Vec_Music_Wk_A
   C842                     120 _Vec_Music_Wk_A:
   C842 00                  121 	.byte	0
                            122 	.globl	_Vec_XXX_03
   C843                     123 _Vec_XXX_03:
   C843 00                  124 	.byte	0
                            125 	.globl	_Vec_XXX_04
   C844                     126 _Vec_XXX_04:
   C844 00                  127 	.byte	0
                            128 	.globl	_Vec_Music_Wk_7
   C845                     129 _Vec_Music_Wk_7:
   C845 00                  130 	.byte	0
                            131 	.globl	_Vec_Music_Wk_6
   C846                     132 _Vec_Music_Wk_6:
   C846 00                  133 	.byte	0
                            134 	.globl	_Vec_Music_Wk_5
   C847                     135 _Vec_Music_Wk_5:
   C847 00                  136 	.byte	0
                            137 	.globl	_Vec_XXX_05
   C848                     138 _Vec_XXX_05:
   C848 00                  139 	.byte	0
                            140 	.globl	_Vec_XXX_06
   C849                     141 _Vec_XXX_06:
   C849 00                  142 	.byte	0
                            143 	.globl	_Vec_XXX_07
   C84A                     144 _Vec_XXX_07:
   C84A 00                  145 	.byte	0
                            146 	.globl	_Vec_Music_Wk_1
   C84B                     147 _Vec_Music_Wk_1:
   C84B 00                  148 	.byte	0
                            149 	.globl	_Vec_XXX_08
   C84C                     150 _Vec_XXX_08:
   C84C 00                  151 	.byte	0
                            152 	.globl	_Vec_Freq_Table
   C84D                     153 _Vec_Freq_Table:
   C84D 00 00               154 	.word	0
                            155 	.globl	_Vec_ADSR_Table
   C84F                     156 _Vec_ADSR_Table:
   C84F 00 00               157 	.word	0
                            158 	.globl	_Vec_Twang_Table
   C851                     159 _Vec_Twang_Table:
   C851 00 00               160 	.word	0
                            161 	.globl	_Vec_Music_Ptr
   C853                     162 _Vec_Music_Ptr:
   C853 00 00               163 	.word	0
                            164 	.globl	_Vec_Music_Chan
   C855                     165 _Vec_Music_Chan:
   C855 00                  166 	.byte	0
                            167 	.globl	_Vec_Music_Flag
   C856                     168 _Vec_Music_Flag:
   C856 00                  169 	.byte	0
                            170 	.globl	_Vec_Duration
   C857                     171 _Vec_Duration:
   C857 00                  172 	.byte	0
                            173 	.globl	_Vec_Expl_1
   C858                     174 _Vec_Expl_1:
   C858 00                  175 	.byte	0
                            176 	.globl	_Vec_Expl_2
   C859                     177 _Vec_Expl_2:
   C859 00                  178 	.byte	0
                            179 	.globl	_Vec_Expl_3
   C85A                     180 _Vec_Expl_3:
   C85A 00                  181 	.byte	0
                            182 	.globl	_Vec_Expl_4
   C85B                     183 _Vec_Expl_4:
   C85B 00                  184 	.byte	0
                            185 	.globl	_Vec_Expl_Chan
   C85C                     186 _Vec_Expl_Chan:
   C85C 00                  187 	.byte	0
                            188 	.globl	_Vec_Expl_ChanB
   C85D                     189 _Vec_Expl_ChanB:
   C85D 00                  190 	.byte	0
                            191 	.globl	_Vec_ADSR_timers
   C85E                     192 _Vec_ADSR_timers:
   C85E 00 00               193 	.word	0
   C860 00                  194 	.byte	0
                            195 	.globl	_Vec_Music_freq
   C861                     196 _Vec_Music_freq:
   C861 00 00 00 00 00 00   197 	.word	0,0,0
                            198 	.globl	_Vec_Expl_Flag
   C867                     199 _Vec_Expl_Flag:
   C867 00                  200 	.byte	0
                            201 	.globl	_Vec_XXX_10
   C868                     202 _Vec_XXX_10:
   C868 00                  203 	.byte	0
                            204 	.globl	_Vec_XXX_11
   C869                     205 _Vec_XXX_11:
   C869 00                  206 	.byte	0
                            207 	.globl	_Vec_XXX_12
   C86A                     208 _Vec_XXX_12:
   C86A 00                  209 	.byte	0
                            210 	.globl	_Vec_XXX_13
   C86B                     211 _Vec_XXX_13:
   C86B 00                  212 	.byte	0
                            213 	.globl	_Vec_XXX_14
   C86C                     214 _Vec_XXX_14:
   C86C 00                  215 	.byte	0
                            216 	.globl	_Vec_XXX_15
   C86D                     217 _Vec_XXX_15:
   C86D 00                  218 	.byte	0
                            219 	.globl	_Vec_XXX_16
   C86E                     220 _Vec_XXX_16:
   C86E 00                  221 	.byte	0
                            222 	.globl	_Vec_XXX_17
   C86F                     223 _Vec_XXX_17:
   C86F 00                  224 	.byte	0
                            225 	.globl	_Vec_XXX_18
   C870                     226 _Vec_XXX_18:
   C870 00                  227 	.byte	0
                            228 	.globl	_Vec_XXX_19
   C871                     229 _Vec_XXX_19:
   C871 00                  230 	.byte	0
                            231 	.globl	_Vec_XXX_20
   C872                     232 _Vec_XXX_20:
   C872 00                  233 	.byte	0
                            234 	.globl	_Vec_XXX_21
   C873                     235 _Vec_XXX_21:
   C873 00                  236 	.byte	0
                            237 	.globl	_Vec_XXX_22
   C874                     238 _Vec_XXX_22:
   C874 00                  239 	.byte	0
                            240 	.globl	_Vec_XXX_23
   C875                     241 _Vec_XXX_23:
   C875 00                  242 	.byte	0
                            243 	.globl	_Vec_XXX_24
   C876                     244 _Vec_XXX_24:
   C876 00                  245 	.byte	0
                            246 	.globl	_Vec_Expl_Timer
   C877                     247 _Vec_Expl_Timer:
   C877 00                  248 	.byte	0
                            249 	.globl	_Vec_XXX_25
   C878                     250 _Vec_XXX_25:
   C878 00                  251 	.byte	0
                            252 	.globl	_Vec_Num_Players
   C879                     253 _Vec_Num_Players:
   C879 00                  254 	.byte	0
                            255 	.globl	_Vec_Num_Game
   C87A                     256 _Vec_Num_Game:
   C87A 00                  257 	.byte	0
                            258 	.globl	_Vec_Seed_Ptr
   C87B                     259 _Vec_Seed_Ptr:
   C87B 00 00               260 	.word	0
                            261 	.globl	_Vec_Random_Seed0
   C87D                     262 _Vec_Random_Seed0:
   C87D 00                  263 	.byte	0
                            264 	.globl	_Vec_Random_Seed1
   C87E                     265 _Vec_Random_Seed1:
   C87E 00                  266 	.byte	0
                            267 	.globl	_Vec_Random_Seed2
   C87F                     268 _Vec_Random_Seed2:
   C87F 00                  269 	.byte	0
ASxxxx Assembler V05.00  (Motorola 6809), page 1.
Hexidecimal [16-Bits]

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
  2 _Vec_0Ref_Enab     0024 GR  |   2 _Vec_ADSR_Tabl     004F GR
  2 _Vec_ADSR_time     005E GR  |   2 _Vec_Angle         0036 GR
  2 _Vec_Brightnes     0027 GR  |   2 _Vec_Btn_State     000F GR
  2 _Vec_Button_1_     0012 GR  |   2 _Vec_Button_1_     0013 GR
  2 _Vec_Button_1_     0014 GR  |   2 _Vec_Button_1_     0015 GR
  2 _Vec_Button_2_     0016 GR  |   2 _Vec_Button_2_     0017 GR
  2 _Vec_Button_2_     0018 GR  |   2 _Vec_Button_2_     0019 GR
  2 _Vec_Buttons       0011 GR  |   2 _Vec_Dot_Dwell     0028 GR
  2 _Vec_Duration      0057 GR  |   2 _Vec_Expl_1        0058 GR
  2 _Vec_Expl_2        0059 GR  |   2 _Vec_Expl_3        005A GR
  2 _Vec_Expl_4        005B GR  |   2 _Vec_Expl_Chan     005C GR
  2 _Vec_Expl_Chan     005D GR  |   2 _Vec_Expl_Flag     0067 GR
  2 _Vec_Expl_Time     0077 GR  |   2 _Vec_Freq_Tabl     004D GR
  2 _Vec_Joy_1_X       001B GR  |   2 _Vec_Joy_1_Y       001C GR
  2 _Vec_Joy_2_X       001D GR  |   2 _Vec_Joy_2_Y       001E GR
  2 _Vec_Joy_Reslt     001A GR  |   2 _Vec_Joy_mux       001F GR
  2 _Vec_Loop_Coun     0025 GR  |   2 _Vec_Misc_Coun     0023 GR
  2 _Vec_Music_Cha     0055 GR  |   2 _Vec_Music_Fla     0056 GR
  2 _Vec_Music_Ptr     0053 GR  |   2 _Vec_Music_Wk_     004B GR
  2 _Vec_Music_Wk_     0047 GR  |   2 _Vec_Music_Wk_     0046 GR
  2 _Vec_Music_Wk_     0045 GR  |   2 _Vec_Music_Wk_     0042 GR
  2 _Vec_Music_Wor     003F GR  |   2 _Vec_Music_fre     0061 GR
  2 _Vec_Num_Game      007A GR  |   2 _Vec_Num_Playe     0079 GR
  2 _Vec_Pattern       0029 GR  |   2 _Vec_Prev_Btns     0010 GR
  2 _Vec_Random_Se     007D GR  |   2 _Vec_Random_Se     007E GR
  2 _Vec_Random_Se     007F GR  |   2 _Vec_Rfrsh         003D GR
  2 _Vec_RiseRun_L     003B GR  |   2 _Vec_RiseRun_T     0034 GR
  2 _Vec_Rise_Inde     0039 GR  |   2 _Vec_Run_Index     0037 GR
  2 _Vec_Seed_Ptr      007B GR  |   2 _Vec_Snd_shado     0000 GR
  2 _Vec_Str_Ptr       002C GR  |   2 _Vec_Text_HW       002A GR
  2 _Vec_Twang_Tab     0051 GR  |   2 _Vec_XXX_02        003C GR
  2 _Vec_XXX_03        0043 GR  |   2 _Vec_XXX_04        0044 GR
  2 _Vec_XXX_05        0048 GR  |   2 _Vec_XXX_06        0049 GR
  2 _Vec_XXX_07        004A GR  |   2 _Vec_XXX_08        004C GR
  2 _Vec_XXX_10        0068 GR  |   2 _Vec_XXX_11        0069 GR
  2 _Vec_XXX_12        006A GR  |   2 _Vec_XXX_13        006B GR
  2 _Vec_XXX_14        006C GR  |   2 _Vec_XXX_15        006D GR
  2 _Vec_XXX_16        006E GR  |   2 _Vec_XXX_17        006F GR
  2 _Vec_XXX_18        0070 GR  |   2 _Vec_XXX_19        0071 GR
  2 _Vec_XXX_20        0072 GR  |   2 _Vec_XXX_21        0073 GR
  2 _Vec_XXX_22        0074 GR  |   2 _Vec_XXX_23        0075 GR
  2 _Vec_XXX_24        0076 GR  |   2 _Vec_XXX_25        0078 GR
  2 _Vec_counters      002E GR

ASxxxx Assembler V05.00  (Motorola 6809), page 2.
Hexidecimal [16-Bits]

Area Table

[_CSEG]
   0 _CODE            size    0   flags C080
[_DSEG]
   1 _DATA            size    0   flags C0C0
[page_c8]
   2 .dpc8            size   80   flags 8584

