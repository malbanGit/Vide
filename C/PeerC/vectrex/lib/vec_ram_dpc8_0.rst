                              1 ;;; gcc for m6809 : Mar 11 2019 13:34:05
                              2 ;;; 4.3.6 (gcc6809)
                              3 ;;; ABI version 1
                              4 ;;; -mabi=bx -mint8 -fomit-frame-pointer -O2
                              5 	.module	vec_ram_dpc8_0.c
                              6 ;----- asm -----
                              7 	.bank page_00 (BASE=0x0000,SIZE=0x0100)
                              8 	.area .direct (OVR,BANK=page_00)
                              9 	
                             10 ;--- end asm ---
                             11 	.globl	_dp_Vec_Snd_shadow
                             12 	.area	.direct
   0000                      13 _dp_Vec_Snd_shadow:
   0000 00 00 00 00 00 00    14 	.word	0,0,0,0,0,0,0
        00 00 00 00 00 00
        00 00
   000E 00                   15 	.byte	0
                             16 	.globl	_dp_Vec_Btn_State
   000F                      17 _dp_Vec_Btn_State:
   000F 00                   18 	.byte	0
                             19 	.globl	_dp_Vec_Prev_Btns
   0010                      20 _dp_Vec_Prev_Btns:
   0010 00                   21 	.byte	0
                             22 	.globl	_dp_Vec_Buttons
   0011                      23 _dp_Vec_Buttons:
   0011 00                   24 	.byte	0
                             25 	.globl	_dp_Vec_Button_1_1
   0012                      26 _dp_Vec_Button_1_1:
   0012 00                   27 	.byte	0
                             28 	.globl	_dp_Vec_Button_1_2
   0013                      29 _dp_Vec_Button_1_2:
   0013 00                   30 	.byte	0
                             31 	.globl	_dp_Vec_Button_1_3
   0014                      32 _dp_Vec_Button_1_3:
   0014 00                   33 	.byte	0
                             34 	.globl	_dp_Vec_Button_1_4
   0015                      35 _dp_Vec_Button_1_4:
   0015 00                   36 	.byte	0
                             37 	.globl	_dp_Vec_Button_2_1
   0016                      38 _dp_Vec_Button_2_1:
   0016 00                   39 	.byte	0
                             40 	.globl	_dp_Vec_Button_2_2
   0017                      41 _dp_Vec_Button_2_2:
   0017 00                   42 	.byte	0
                             43 	.globl	_dp_Vec_Button_2_3
   0018                      44 _dp_Vec_Button_2_3:
   0018 00                   45 	.byte	0
                             46 	.globl	_dp_Vec_Button_2_4
   0019                      47 _dp_Vec_Button_2_4:
   0019 00                   48 	.byte	0
                             49 	.globl	_dp_Vec_Joy_Resltn
   001A                      50 _dp_Vec_Joy_Resltn:
   001A 00                   51 	.byte	0
                             52 	.globl	_dp_Vec_Joy_1_X
   001B                      53 _dp_Vec_Joy_1_X:
   001B 00                   54 	.byte	0
                             55 	.globl	_dp_Vec_Joy_1_Y
   001C                      56 _dp_Vec_Joy_1_Y:
   001C 00                   57 	.byte	0
                             58 	.globl	_dp_Vec_Joy_2_X
   001D                      59 _dp_Vec_Joy_2_X:
   001D 00                   60 	.byte	0
                             61 	.globl	_dp_Vec_Joy_2_Y
   001E                      62 _dp_Vec_Joy_2_Y:
   001E 00                   63 	.byte	0
                             64 	.globl	_dp_Vec_Joy_mux
   001F                      65 _dp_Vec_Joy_mux:
   001F 00 00 00 00          66 	.word	0,0
                             67 	.globl	_dp_Vec_Misc_Count
   0023                      68 _dp_Vec_Misc_Count:
   0023 00                   69 	.byte	0
                             70 	.globl	_dp_Vec_0Ref_Enable
   0024                      71 _dp_Vec_0Ref_Enable:
   0024 00                   72 	.byte	0
                             73 	.globl	_dp_Vec_Loop_Count
   0025                      74 _dp_Vec_Loop_Count:
   0025 00 00                75 	.word	0
                             76 	.globl	_dp_Vec_Brightness
   0027                      77 _dp_Vec_Brightness:
   0027 00                   78 	.byte	0
                             79 	.globl	_dp_Vec_Dot_Dwell
   0028                      80 _dp_Vec_Dot_Dwell:
   0028 00                   81 	.byte	0
                             82 	.globl	_dp_Vec_Pattern
   0029                      83 _dp_Vec_Pattern:
   0029 00                   84 	.byte	0
                             85 	.globl	_dp_Vec_Text_HW
   002A                      86 _dp_Vec_Text_HW:
   002A 00 00                87 	.word	0
                             88 	.globl	_dp_Vec_Str_Ptr
   002C                      89 _dp_Vec_Str_Ptr:
   002C 00 00                90 	.word	0
                             91 	.globl	_dp_Vec_counters
   002E                      92 _dp_Vec_counters:
   002E 00 00 00 00 00 00    93 	.word	0,0,0
                             94 	.globl	_dp_Vec_RiseRun_Tmp
   0034                      95 _dp_Vec_RiseRun_Tmp:
   0034 00 00                96 	.word	0
                             97 	.globl	_dp_Vec_Angle
   0036                      98 _dp_Vec_Angle:
   0036 00                   99 	.byte	0
                            100 	.globl	_dp_Vec_Run_Index
   0037                     101 _dp_Vec_Run_Index:
   0037 00 00               102 	.word	0
                            103 	.globl	_dp_Vec_Rise_Index
   0039                     104 _dp_Vec_Rise_Index:
   0039 00 00               105 	.word	0
                            106 	.globl	_dp_Vec_RiseRun_Len
   003B                     107 _dp_Vec_RiseRun_Len:
   003B 00                  108 	.byte	0
                            109 	.globl	_dp_Vec_XXX_02
   003C                     110 _dp_Vec_XXX_02:
   003C 00                  111 	.byte	0
                            112 	.globl	_dp_Vec_Rfrsh
   003D                     113 _dp_Vec_Rfrsh:
   003D 00 00               114 	.word	0
                            115 	.globl	_dp_Vec_Music_Work
   003F                     116 _dp_Vec_Music_Work:
   003F 00 00               117 	.word	0
   0041 00                  118 	.byte	0
                            119 	.globl	_dp_Vec_Music_Wk_A
   0042                     120 _dp_Vec_Music_Wk_A:
   0042 00                  121 	.byte	0
                            122 	.globl	_dp_Vec_XXX_03
   0043                     123 _dp_Vec_XXX_03:
   0043 00                  124 	.byte	0
                            125 	.globl	_dp_Vec_XXX_04
   0044                     126 _dp_Vec_XXX_04:
   0044 00                  127 	.byte	0
                            128 	.globl	_dp_Vec_Music_Wk_7
   0045                     129 _dp_Vec_Music_Wk_7:
   0045 00                  130 	.byte	0
                            131 	.globl	_dp_Vec_Music_Wk_6
   0046                     132 _dp_Vec_Music_Wk_6:
   0046 00                  133 	.byte	0
                            134 	.globl	_dp_Vec_Music_Wk_5
   0047                     135 _dp_Vec_Music_Wk_5:
   0047 00                  136 	.byte	0
                            137 	.globl	_dp_Vec_XXX_05
   0048                     138 _dp_Vec_XXX_05:
   0048 00                  139 	.byte	0
                            140 	.globl	_dp_Vec_XXX_06
   0049                     141 _dp_Vec_XXX_06:
   0049 00                  142 	.byte	0
                            143 	.globl	_dp_Vec_XXX_07
   004A                     144 _dp_Vec_XXX_07:
   004A 00                  145 	.byte	0
                            146 	.globl	_dp_Vec_Music_Wk_1
   004B                     147 _dp_Vec_Music_Wk_1:
   004B 00                  148 	.byte	0
                            149 	.globl	_dp_Vec_XXX_08
   004C                     150 _dp_Vec_XXX_08:
   004C 00                  151 	.byte	0
                            152 	.globl	_dp_Vec_Freq_Table
   004D                     153 _dp_Vec_Freq_Table:
   004D 00 00               154 	.word	0
                            155 	.globl	_dp_Vec_ADSR_Table
   004F                     156 _dp_Vec_ADSR_Table:
   004F 00 00               157 	.word	0
                            158 	.globl	_dp_Vec_Twang_Table
   0051                     159 _dp_Vec_Twang_Table:
   0051 00 00               160 	.word	0
                            161 	.globl	_dp_Vec_Music_Ptr
   0053                     162 _dp_Vec_Music_Ptr:
   0053 00 00               163 	.word	0
                            164 	.globl	_dp_Vec_Music_Chan
   0055                     165 _dp_Vec_Music_Chan:
   0055 00                  166 	.byte	0
                            167 	.globl	_dp_Vec_Music_Flag
   0056                     168 _dp_Vec_Music_Flag:
   0056 00                  169 	.byte	0
                            170 	.globl	_dp_Vec_Duration
   0057                     171 _dp_Vec_Duration:
   0057 00                  172 	.byte	0
                            173 	.globl	_dp_Vec_Expl_1
   0058                     174 _dp_Vec_Expl_1:
   0058 00                  175 	.byte	0
                            176 	.globl	_dp_Vec_Expl_2
   0059                     177 _dp_Vec_Expl_2:
   0059 00                  178 	.byte	0
                            179 	.globl	_dp_Vec_Expl_3
   005A                     180 _dp_Vec_Expl_3:
   005A 00                  181 	.byte	0
                            182 	.globl	_dp_Vec_Expl_4
   005B                     183 _dp_Vec_Expl_4:
   005B 00                  184 	.byte	0
                            185 	.globl	_dp_Vec_Expl_Chan
   005C                     186 _dp_Vec_Expl_Chan:
   005C 00                  187 	.byte	0
                            188 	.globl	_dp_Vec_Expl_ChanB
   005D                     189 _dp_Vec_Expl_ChanB:
   005D 00                  190 	.byte	0
                            191 	.globl	_dp_Vec_ADSR_timers
   005E                     192 _dp_Vec_ADSR_timers:
   005E 00 00               193 	.word	0
   0060 00                  194 	.byte	0
                            195 	.globl	_dp_Vec_Music_freq
   0061                     196 _dp_Vec_Music_freq:
   0061 00 00 00 00 00 00   197 	.word	0,0,0
                            198 	.globl	_dp_Vec_Expl_Flag
   0067                     199 _dp_Vec_Expl_Flag:
   0067 00                  200 	.byte	0
                            201 	.globl	_dp_Vec_XXX_10
   0068                     202 _dp_Vec_XXX_10:
   0068 00                  203 	.byte	0
                            204 	.globl	_dp_Vec_XXX_11
   0069                     205 _dp_Vec_XXX_11:
   0069 00                  206 	.byte	0
                            207 	.globl	_dp_Vec_XXX_12
   006A                     208 _dp_Vec_XXX_12:
   006A 00                  209 	.byte	0
                            210 	.globl	_dp_Vec_XXX_13
   006B                     211 _dp_Vec_XXX_13:
   006B 00                  212 	.byte	0
                            213 	.globl	_dp_Vec_XXX_14
   006C                     214 _dp_Vec_XXX_14:
   006C 00                  215 	.byte	0
                            216 	.globl	_dp_Vec_XXX_15
   006D                     217 _dp_Vec_XXX_15:
   006D 00                  218 	.byte	0
                            219 	.globl	_dp_Vec_XXX_16
   006E                     220 _dp_Vec_XXX_16:
   006E 00                  221 	.byte	0
                            222 	.globl	_dp_Vec_XXX_17
   006F                     223 _dp_Vec_XXX_17:
   006F 00                  224 	.byte	0
                            225 	.globl	_dp_Vec_XXX_18
   0070                     226 _dp_Vec_XXX_18:
   0070 00                  227 	.byte	0
                            228 	.globl	_dp_Vec_XXX_19
   0071                     229 _dp_Vec_XXX_19:
   0071 00                  230 	.byte	0
                            231 	.globl	_dp_Vec_XXX_20
   0072                     232 _dp_Vec_XXX_20:
   0072 00                  233 	.byte	0
                            234 	.globl	_dp_Vec_XXX_21
   0073                     235 _dp_Vec_XXX_21:
   0073 00                  236 	.byte	0
                            237 	.globl	_dp_Vec_XXX_22
   0074                     238 _dp_Vec_XXX_22:
   0074 00                  239 	.byte	0
                            240 	.globl	_dp_Vec_XXX_23
   0075                     241 _dp_Vec_XXX_23:
   0075 00                  242 	.byte	0
                            243 	.globl	_dp_Vec_XXX_24
   0076                     244 _dp_Vec_XXX_24:
   0076 00                  245 	.byte	0
                            246 	.globl	_dp_Vec_Expl_Timer
   0077                     247 _dp_Vec_Expl_Timer:
   0077 00                  248 	.byte	0
                            249 	.globl	_dp_Vec_XXX_25
   0078                     250 _dp_Vec_XXX_25:
   0078 00                  251 	.byte	0
                            252 	.globl	_dp_Vec_Num_Players
   0079                     253 _dp_Vec_Num_Players:
   0079 00                  254 	.byte	0
                            255 	.globl	_dp_Vec_Num_Game
   007A                     256 _dp_Vec_Num_Game:
   007A 00                  257 	.byte	0
                            258 	.globl	_dp_Vec_Seed_Ptr
   007B                     259 _dp_Vec_Seed_Ptr:
   007B 00 00               260 	.word	0
                            261 	.globl	_dp_Vec_Random_Seed0
   007D                     262 _dp_Vec_Random_Seed0:
   007D 00                  263 	.byte	0
                            264 	.globl	_dp_Vec_Random_Seed1
   007E                     265 _dp_Vec_Random_Seed1:
   007E 00                  266 	.byte	0
                            267 	.globl	_dp_Vec_Random_Seed2
   007F                     268 _dp_Vec_Random_Seed2:
   007F 00                  269 	.byte	0
ASxxxx Assembler V05.00  (Motorola 6809), page 1.
Hexidecimal [16-Bits]

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
  2 _dp_Vec_0Ref_E     0024 GR  |   2 _dp_Vec_ADSR_T     004F GR
  2 _dp_Vec_ADSR_t     005E GR  |   2 _dp_Vec_Angle      0036 GR
  2 _dp_Vec_Bright     0027 GR  |   2 _dp_Vec_Btn_St     000F GR
  2 _dp_Vec_Button     0012 GR  |   2 _dp_Vec_Button     0013 GR
  2 _dp_Vec_Button     0014 GR  |   2 _dp_Vec_Button     0015 GR
  2 _dp_Vec_Button     0016 GR  |   2 _dp_Vec_Button     0017 GR
  2 _dp_Vec_Button     0018 GR  |   2 _dp_Vec_Button     0019 GR
  2 _dp_Vec_Button     0011 GR  |   2 _dp_Vec_Dot_Dw     0028 GR
  2 _dp_Vec_Durati     0057 GR  |   2 _dp_Vec_Expl_1     0058 GR
  2 _dp_Vec_Expl_2     0059 GR  |   2 _dp_Vec_Expl_3     005A GR
  2 _dp_Vec_Expl_4     005B GR  |   2 _dp_Vec_Expl_C     005C GR
  2 _dp_Vec_Expl_C     005D GR  |   2 _dp_Vec_Expl_F     0067 GR
  2 _dp_Vec_Expl_T     0077 GR  |   2 _dp_Vec_Freq_T     004D GR
  2 _dp_Vec_Joy_1_     001B GR  |   2 _dp_Vec_Joy_1_     001C GR
  2 _dp_Vec_Joy_2_     001D GR  |   2 _dp_Vec_Joy_2_     001E GR
  2 _dp_Vec_Joy_Re     001A GR  |   2 _dp_Vec_Joy_mu     001F GR
  2 _dp_Vec_Loop_C     0025 GR  |   2 _dp_Vec_Misc_C     0023 GR
  2 _dp_Vec_Music_     0055 GR  |   2 _dp_Vec_Music_     0056 GR
  2 _dp_Vec_Music_     0053 GR  |   2 _dp_Vec_Music_     004B GR
  2 _dp_Vec_Music_     0047 GR  |   2 _dp_Vec_Music_     0046 GR
  2 _dp_Vec_Music_     0045 GR  |   2 _dp_Vec_Music_     0042 GR
  2 _dp_Vec_Music_     003F GR  |   2 _dp_Vec_Music_     0061 GR
  2 _dp_Vec_Num_Ga     007A GR  |   2 _dp_Vec_Num_Pl     0079 GR
  2 _dp_Vec_Patter     0029 GR  |   2 _dp_Vec_Prev_B     0010 GR
  2 _dp_Vec_Random     007D GR  |   2 _dp_Vec_Random     007E GR
  2 _dp_Vec_Random     007F GR  |   2 _dp_Vec_Rfrsh      003D GR
  2 _dp_Vec_RiseRu     003B GR  |   2 _dp_Vec_RiseRu     0034 GR
  2 _dp_Vec_Rise_I     0039 GR  |   2 _dp_Vec_Run_In     0037 GR
  2 _dp_Vec_Seed_P     007B GR  |   2 _dp_Vec_Snd_sh     0000 GR
  2 _dp_Vec_Str_Pt     002C GR  |   2 _dp_Vec_Text_H     002A GR
  2 _dp_Vec_Twang_     0051 GR  |   2 _dp_Vec_XXX_02     003C GR
  2 _dp_Vec_XXX_03     0043 GR  |   2 _dp_Vec_XXX_04     0044 GR
  2 _dp_Vec_XXX_05     0048 GR  |   2 _dp_Vec_XXX_06     0049 GR
  2 _dp_Vec_XXX_07     004A GR  |   2 _dp_Vec_XXX_08     004C GR
  2 _dp_Vec_XXX_10     0068 GR  |   2 _dp_Vec_XXX_11     0069 GR
  2 _dp_Vec_XXX_12     006A GR  |   2 _dp_Vec_XXX_13     006B GR
  2 _dp_Vec_XXX_14     006C GR  |   2 _dp_Vec_XXX_15     006D GR
  2 _dp_Vec_XXX_16     006E GR  |   2 _dp_Vec_XXX_17     006F GR
  2 _dp_Vec_XXX_18     0070 GR  |   2 _dp_Vec_XXX_19     0071 GR
  2 _dp_Vec_XXX_20     0072 GR  |   2 _dp_Vec_XXX_21     0073 GR
  2 _dp_Vec_XXX_22     0074 GR  |   2 _dp_Vec_XXX_23     0075 GR
  2 _dp_Vec_XXX_24     0076 GR  |   2 _dp_Vec_XXX_25     0078 GR
  2 _dp_Vec_counte     002E GR

ASxxxx Assembler V05.00  (Motorola 6809), page 2.
Hexidecimal [16-Bits]

Area Table

[_CSEG]
   0 _CODE            size    0   flags C080
[_DSEG]
   1 _DATA            size    0   flags C0C0
[page_00]
   2 .direct          size   80   flags 8584

