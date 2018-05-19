                              1  .module _3dforc.pre.s
                              2  .bank rom(BASE=0x0000,SIZE=0x8000,FSFX=_rom)
                              3  .area .cartridge (BANK=rom) 
                              4  .area .text (BANK=rom)
                              5  .area .text.hot (BANK=rom)
                              6  .area .text.unlikely (BANK=rom)
                              7 
                              8  .bank ram(BASE=0xc880,SIZE=0x036b,FSFX=_ram)
                              9  .area .data  (BANK=ram)
                             10  .area .bss   (BANK=ram)
                             11 
                             12  .area .text
                             13 
                             14                     .area .bss      
                             15 ; Warning - org line found, my be countering relocatable code!
                             16 ;                    ORG      0xc880                ; start of our ram space 
                             17 
                             18 ; include line ->                     INCLUDE  "VECTREX.I"          ; vectrex function includes
                             19 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                             20 ; this file contains includes for vectrex BIOS functions and variables      ;
                             21 ; it was written by Bruce Tomlin, slighte changed by Malban                 ;
                             22 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                             23 
                     0001    24 INCLUDE_I = 1
                             25 
                     C800    26 Vec_Snd_Shadow  =     0xC800   ;Shadow of sound chip registers (15 bytes)
                     C80F    27 Vec_Btn_State   =     0xC80F   ;Current state of all joystick buttons
                     C810    28 Vec_Prev_Btns   =     0xC810   ;Previous state of all joystick buttons
                     C811    29 Vec_Buttons     =     0xC811   ;Current toggle state of all buttons
                     C812    30 Vec_Button_1_1  =     0xC812   ;Current toggle state of stick 1 button 1
                     C813    31 Vec_Button_1_2  =     0xC813   ;Current toggle state of stick 1 button 2
                     C814    32 Vec_Button_1_3  =     0xC814   ;Current toggle state of stick 1 button 3
                     C815    33 Vec_Button_1_4  =     0xC815   ;Current toggle state of stick 1 button 4
                     C816    34 Vec_Button_2_1  =     0xC816   ;Current toggle state of stick 2 button 1
                     C817    35 Vec_Button_2_2  =     0xC817   ;Current toggle state of stick 2 button 2
                     C818    36 Vec_Button_2_3  =     0xC818   ;Current toggle state of stick 2 button 3
                     C819    37 Vec_Button_2_4  =     0xC819   ;Current toggle state of stick 2 button 4
                     C81A    38 Vec_Joy_Resltn  =     0xC81A   ;Joystick A/D resolution (0x80=min 0x00=max)
                     C81B    39 Vec_Joy_1_X     =     0xC81B   ;Joystick 1 left/right
                     C81C    40 Vec_Joy_1_Y     =     0xC81C   ;Joystick 1 up/down
                     C81D    41 Vec_Joy_2_X     =     0xC81D   ;Joystick 2 left/right
                     C81E    42 Vec_Joy_2_Y     =     0xC81E   ;Joystick 2 up/down
                     C81F    43 Vec_Joy_Mux     =     0xC81F   ;Joystick enable/mux flags (4 bytes)
                     C81F    44 Vec_Joy_Mux_1_X =     0xC81F   ;Joystick 1 X enable/mux flag (=1)
                     C820    45 Vec_Joy_Mux_1_Y =     0xC820   ;Joystick 1 Y enable/mux flag (=3)
                     C821    46 Vec_Joy_Mux_2_X =     0xC821   ;Joystick 2 X enable/mux flag (=5)
                     C822    47 Vec_Joy_Mux_2_Y =     0xC822   ;Joystick 2 Y enable/mux flag (=7)
                     C823    48 Vec_Misc_Count  =     0xC823   ;Misc counter/flag byte, zero when not in use
                     C824    49 Vec_0Ref_Enable =     0xC824   ;Check0Ref enable flag
                     C825    50 Vec_Loop_Count  =     0xC825   ;Loop counter word (incremented in Wait_Recal)
                     C827    51 Vec_Brightness  =     0xC827   ;Default brightness
                     C828    52 Vec_Dot_Dwell   =     0xC828   ;Dot dwell time?
                     C829    53 Vec_Pattern     =     0xC829   ;Dot pattern (bits)
                     C82A    54 Vec_Text_HW     =     0xC82A   ;Default text height and width
                     C82A    55 Vec_Text_Height =     0xC82A   ;Default text height
                     C82B    56 Vec_Text_Width  =     0xC82B   ;Default text width
                     C82C    57 Vec_Str_Ptr     =     0xC82C   ;Temporary string pointer for Print_Str
                     C82E    58 Vec_Counters    =     0xC82E   ;Six bytes of counters
                     C82E    59 Vec_Counter_1   =     0xC82E   ;First  counter byte
                     C82F    60 Vec_Counter_2   =     0xC82F   ;Second counter byte
                     C830    61 Vec_Counter_3   =     0xC830   ;Third  counter byte
                     C831    62 Vec_Counter_4   =     0xC831   ;Fourth counter byte
                     C832    63 Vec_Counter_5   =     0xC832   ;Fifth  counter byte
                     C833    64 Vec_Counter_6   =     0xC833   ;Sixth  counter byte
                     C834    65 Vec_RiseRun_Tmp =     0xC834   ;Temp storage word for rise/run
                     C836    66 Vec_Angle       =     0xC836   ;Angle for rise/run and rotation calculations
                     C837    67 Vec_Run_Index   =     0xC837   ;Index pair for run
                             68 ;                       0xC839   ;Pointer to copyright string during startup
                     C839    69 Vec_Rise_Index  =     0xC839   ;Index pair for rise
                             70 ;                       0xC83B   ;High score cold-start flag (=0 if valid)
                     C83B    71 Vec_RiseRun_Len =     0xC83B   ;length for rise/run
                             72 ;                       0xC83C   ;temp byte
                     C83D    73 Vec_Rfrsh       =     0xC83D   ;Refresh time (divided by 1.5MHz)
                     C83D    74 Vec_Rfrsh_lo    =     0xC83D   ;Refresh time low byte
                     C83E    75 Vec_Rfrsh_hi    =     0xC83E   ;Refresh time high byte
                     C83F    76 Vec_Music_Work  =     0xC83F   ;Music work buffer (14 bytes, backwards?)
                     C842    77 Vec_Music_Wk_A  =     0xC842   ;        register 10
                             78 ;                       0xC843   ;        register 9
                             79 ;                       0xC844   ;        register 8
                     C845    80 Vec_Music_Wk_7  =     0xC845   ;        register 7
                     C846    81 Vec_Music_Wk_6  =     0xC846   ;        register 6
                     C847    82 Vec_Music_Wk_5  =     0xC847   ;        register 5
                             83 ;                       0xC848   ;        register 4
                             84 ;                       0xC849   ;        register 3
                             85 ;                       0xC84A   ;        register 2
                     C84B    86 Vec_Music_Wk_1  =     0xC84B   ;        register 1
                             87 ;                       0xC84C   ;        register 0
                     C84D    88 Vec_Freq_Table  =     0xC84D   ;Pointer to note-to-frequency table (normally 0xFC8D)
                     C84F    89 Vec_Max_Players =     0xC84F   ;Maximum number of players for Select_Game
                     C850    90 Vec_Max_Games   =     0xC850   ;Maximum number of games for Select_Game
                     C84F    91 Vec_ADSR_Table  =     0xC84F   ;Storage for first music header word (ADSR table)
                     C851    92 Vec_Twang_Table =     0xC851   ;Storage for second music header word ('twang' table)
                     C853    93 Vec_Music_Ptr   =     0xC853   ;Music data pointer
                     C853    94 Vec_Expl_ChanA  =     0xC853   ;Used by Explosion_Snd - bit for first channel used?
                     C854    95 Vec_Expl_Chans  =     0xC854   ;Used by Explosion_Snd - bits for all channels used?
                     C855    96 Vec_Music_Chan  =     0xC855   ;Current sound channel number for Init_Music
                     C856    97 Vec_Music_Flag  =     0xC856   ;Music active flag (0x00=off 0x01=start 0x80=on)
                     C857    98 Vec_Duration    =     0xC857   ;Duration counter for Init_Music
                     C858    99 Vec_Music_Twang =     0xC858   ;3 word 'twang' table used by Init_Music
                     C858   100 Vec_Expl_1      =     0xC858   ;Four bytes copied from Explosion_Snd's U-reg parameters
                     C859   101 Vec_Expl_2      =     0xC859   ;
                     C85A   102 Vec_Expl_3      =     0xC85A   ;
                     C85B   103 Vec_Expl_4      =     0xC85B   ;
                     C85C   104 Vec_Expl_Chan   =     0xC85C   ;Used by Explosion_Snd - channel number in use?
                     C85D   105 Vec_Expl_ChanB  =     0xC85D   ;Used by Explosion_Snd - bit for second channel used?
                     C85E   106 Vec_ADSR_Timers =     0xC85E   ;ADSR timers for each sound channel (3 bytes)
                     C861   107 Vec_Music_Freq  =     0xC861   ;Storage for base frequency of each channel (3 words)
                            108 ;                       0xC85E   ;Scratch 'score' storage for Display_Option (7 bytes)
                     C867   109 Vec_Expl_Flag   =     0xC867   ;Explosion_Snd initialization flag?
                            110 ;               0xC868...0xC876   ;Unused?
                     C877   111 Vec_Expl_Timer  =     0xC877   ;Used by Explosion_Snd
                            112 ;                       0xC878   ;Unused?
                     C879   113 Vec_Num_Players =     0xC879   ;Number of players selected in Select_Game
                     C87A   114 Vec_Num_Game    =     0xC87A   ;Game number selected in Select_Game
                     C87B   115 Vec_Seed_Ptr    =     0xC87B   ;Pointer to 3-byte random number seed (=0xC87D)
                     C87D   116 Vec_Random_Seed =     0xC87D   ;Default 3-byte random number seed
                            117                                 ;
                            118 ;    0xC880 - 0xCBEA is user RAM  ;
                            119                                 ;
                     CBEA   120 Vec_Default_Stk =     0xCBEA   ;Default top-of-stack
                     CBEB   121 Vec_High_Score  =     0xCBEB   ;High score storage (7 bytes)
                     CBF2   122 Vec_SWI3_Vector =     0xCBF2   ;SWI2/SWI3 interrupt vector (3 bytes)
                     CBF2   123 Vec_SWI2_Vector =     0xCBF2   ;SWI2/SWI3 interrupt vector (3 bytes)
                     CBF5   124 Vec_FIRQ_Vector =     0xCBF5   ;FIRQ interrupt vector (3 bytes)
                     CBF8   125 Vec_IRQ_Vector  =     0xCBF8   ;IRQ interrupt vector (3 bytes)
                     CBFB   126 Vec_SWI_Vector  =     0xCBFB   ;SWI/NMI interrupt vector (3 bytes)
                     CBFB   127 Vec_NMI_Vector  =     0xCBFB   ;SWI/NMI interrupt vector (3 bytes)
                     CBFE   128 Vec_Cold_Flag   =     0xCBFE   ;Cold start flag (warm start if = 0x7321)
                            129                                 ;
                     D000   130 VIA_port_b      =     0xD000   ;VIA port B data I/O register
                            131 ;       0 sample/hold (0=enable  mux 1=disable mux)
                            132 ;       1 mux sel 0
                            133 ;       2 mux sel 1
                            134 ;       3 sound BC1
                            135 ;       4 sound BDIR
                            136 ;       5 comparator input
                            137 ;       6 external device (slot pin 35) initialized to input
                            138 ;       7 /RAMP
                     D001   139 VIA_port_a      =     0xD001   ;VIA port A data I/O register (handshaking)
                     D002   140 VIA_DDR_b       =     0xD002   ;VIA port B data direction register (0=input 1=output)
                     D003   141 VIA_DDR_a       =     0xD003   ;VIA port A data direction register (0=input 1=output)
                     D004   142 VIA_t1_cnt_lo   =     0xD004   ;VIA timer 1 count register lo (scale factor)
                     D005   143 VIA_t1_cnt_hi   =     0xD005   ;VIA timer 1 count register hi
                     D006   144 VIA_t1_lch_lo   =     0xD006   ;VIA timer 1 latch register lo
                     D007   145 VIA_t1_lch_hi   =     0xD007   ;VIA timer 1 latch register hi
                     D008   146 VIA_t2_lo       =     0xD008   ;VIA timer 2 count/latch register lo (refresh)
                     D009   147 VIA_t2_hi       =     0xD009   ;VIA timer 2 count/latch register hi
                     D00A   148 VIA_shift_reg   =     0xD00A   ;VIA shift register
                     D00B   149 VIA_aux_cntl    =     0xD00B   ;VIA auxiliary control register
                            150 ;       0 PA latch enable
                            151 ;       1 PB latch enable
                            152 ;       2 \                     110=output to CB2 under control of phase 2 clock
                            153 ;       3  > shift register control     (110 is the only mode used by the Vectrex ROM)
                            154 ;       4 /
                            155 ;       5 0=t2 one shot                 1=t2 free running
                            156 ;       6 0=t1 one shot                 1=t1 free running
                            157 ;       7 0=t1 disable PB7 output       1=t1 enable PB7 output
                     D00C   158 VIA_cntl        =     0xD00C   ;VIA control register
                            159 ;       0 CA1 control     CA1 -> SW7    0=IRQ on low 1=IRQ on high
                            160 ;       1 \
                            161 ;       2  > CA2 control  CA2 -> /ZERO  110=low 111=high
                            162 ;       3 /
                            163 ;       4 CB1 control     CB1 -> NC     0=IRQ on low 1=IRQ on high
                            164 ;       5 \
                            165 ;       6  > CB2 control  CB2 -> /BLANK 110=low 111=high
                            166 ;       7 /
                     D00D   167 VIA_int_flags   =     0xD00D   ;VIA interrupt flags register
                            168 ;               bit                             cleared by
                            169 ;       0 CA2 interrupt flag            reading or writing port A I/O
                            170 ;       1 CA1 interrupt flag            reading or writing port A I/O
                            171 ;       2 shift register interrupt flag reading or writing shift register
                            172 ;       3 CB2 interrupt flag            reading or writing port B I/O
                            173 ;       4 CB1 interrupt flag            reading or writing port A I/O
                            174 ;       5 timer 2 interrupt flag        read t2 low or write t2 high
                            175 ;       6 timer 1 interrupt flag        read t1 count low or write t1 high
                            176 ;       7 IRQ status flag               write logic 0 to IER or IFR bit
                     D00E   177 VIA_int_enable  =     0xD00E   ;VIA interrupt enable register
                            178 ;       0 CA2 interrupt enable
                            179 ;       1 CA1 interrupt enable
                            180 ;       2 shift register interrupt enable
                            181 ;       3 CB2 interrupt enable
                            182 ;       4 CB1 interrupt enable
                            183 ;       5 timer 2 interrupt enable
                            184 ;       6 timer 1 interrupt enable
                            185 ;       7 IER set/clear control
                     D00F   186 VIA_port_a_nohs =     0xD00F   ;VIA port A data I/O register (no handshaking)
                            187 
                     F000   188 Cold_Start      =     0xF000   ;
                     F06C   189 Warm_Start      =     0xF06C   ;
                     F14C   190 Init_VIA        =     0xF14C   ;
                     F164   191 Init_OS_RAM     =     0xF164   ;
                     F18B   192 Init_OS         =     0xF18B   ;
                     F192   193 Wait_Recal      =     0xF192   ;
                     F1A2   194 Set_Refresh     =     0xF1A2   ;
                     F1AA   195 DP_to_D0        =     0xF1AA   ;
                     F1AF   196 DP_to_C8        =     0xF1AF   ;
                     F1B4   197 Read_Btns_Mask  =     0xF1B4   ;
                     F1BA   198 Read_Btns       =     0xF1BA   ;
                     F1F5   199 Joy_Analog      =     0xF1F5   ;
                     F1F8   200 Joy_Digital     =     0xF1F8   ;
                     F256   201 Sound_Byte      =     0xF256   ;
                     F259   202 Sound_Byte_x    =     0xF259   ;
                     F25B   203 Sound_Byte_raw  =     0xF25B   ;
                     F272   204 Clear_Sound     =     0xF272   ;
                     F27D   205 Sound_Bytes     =     0xF27D   ;
                     F284   206 Sound_Bytes_x   =     0xF284   ;
                     F289   207 Do_Sound        =     0xF289   ;
                     F28C   208 Do_Sound_x      =     0xF28C   ;
                     F29D   209 Intensity_1F    =     0xF29D   ;
                     F2A1   210 Intensity_3F    =     0xF2A1   ;
                     F2A5   211 Intensity_5F    =     0xF2A5   ;
                     F2A9   212 Intensity_7F    =     0xF2A9   ;
                     F2AB   213 Intensity_a     =     0xF2AB   ;
                     F2BE   214 Dot_ix_b        =     0xF2BE   ;
                     F2C1   215 Dot_ix          =     0xF2C1   ;
                     F2C3   216 Dot_d           =     0xF2C3   ;
                     F2C5   217 Dot_here        =     0xF2C5   ;
                     F2D5   218 Dot_List        =     0xF2D5   ;
                     F2DE   219 Dot_List_Reset  =     0xF2DE   ;
                     F2E6   220 Recalibrate     =     0xF2E6   ;
                     F2F2   221 Moveto_x_7F     =     0xF2F2   ;
                     F2FC   222 Moveto_d_7F     =     0xF2FC   ;
                     F308   223 Moveto_ix_FF    =     0xF308   ;
                     F30C   224 Moveto_ix_7F    =     0xF30C   ;
                     F30E   225 Moveto_ix_b     =     0xF30E   ;
                     F310   226 Moveto_ix       =     0xF310   ;
                     F312   227 Moveto_d        =     0xF312   ;
                     F34A   228 Reset0Ref_D0    =     0xF34A   ;
                     F34F   229 Check0Ref       =     0xF34F   ;
                     F354   230 Reset0Ref       =     0xF354   ;
                     F35B   231 Reset_Pen       =     0xF35B   ;
                     F36B   232 Reset0Int       =     0xF36B   ;
                     F373   233 Print_Str_hwyx  =     0xF373   ;
                     F378   234 Print_Str_yx    =     0xF378   ;
                     F37A   235 Print_Str_d     =     0xF37A   ;
                     F385   236 Print_List_hw   =     0xF385   ;
                     F38A   237 Print_List      =     0xF38A   ;
                     F38C   238 Print_List_chk  =     0xF38C   ;
                     F391   239 Print_Ships_x   =     0xF391   ;
                     F393   240 Print_Ships     =     0xF393   ;
                     F3AD   241 Mov_Draw_VLc_a  =     0xF3AD   ;count y x y x ...
                     F3B1   242 Mov_Draw_VL_b   =     0xF3B1   ;y x y x ...
                     F3B5   243 Mov_Draw_VLcs   =     0xF3B5   ;count scale y x y x ...
                     F3B7   244 Mov_Draw_VL_ab  =     0xF3B7   ;y x y x ...
                     F3B9   245 Mov_Draw_VL_a   =     0xF3B9   ;y x y x ...
                     F3BC   246 Mov_Draw_VL     =     0xF3BC   ;y x y x ...
                     F3BE   247 Mov_Draw_VL_d   =     0xF3BE   ;y x y x ...
                     F3CE   248 Draw_VLc        =     0xF3CE   ;count y x y x ...
                     F3D2   249 Draw_VL_b       =     0xF3D2   ;y x y x ...
                     F3D6   250 Draw_VLcs       =     0xF3D6   ;count scale y x y x ...
                     F3D8   251 Draw_VL_ab      =     0xF3D8   ;y x y x ...
                     F3DA   252 Draw_VL_a       =     0xF3DA   ;y x y x ...
                     F3DD   253 Draw_VL         =     0xF3DD   ;y x y x ...
                     F3DF   254 Draw_Line_d     =     0xF3DF   ;y x y x ...
                     F404   255 Draw_VLp_FF     =     0xF404   ;pattern y x pattern y x ... 0x01
                     F408   256 Draw_VLp_7F     =     0xF408   ;pattern y x pattern y x ... 0x01
                     F40C   257 Draw_VLp_scale  =     0xF40C   ;scale pattern y x pattern y x ... 0x01
                     F40E   258 Draw_VLp_b      =     0xF40E   ;pattern y x pattern y x ... 0x01
                     F410   259 Draw_VLp        =     0xF410   ;pattern y x pattern y x ... 0x01
                     F434   260 Draw_Pat_VL_a   =     0xF434   ;y x y x ...
                     F437   261 Draw_Pat_VL     =     0xF437   ;y x y x ...
                     F439   262 Draw_Pat_VL_d   =     0xF439   ;y x y x ...
                     F46E   263 Draw_VL_mode    =     0xF46E   ;mode y x mode y x ... 0x01
                     F495   264 Print_Str       =     0xF495   ;
                     F511   265 Random_3        =     0xF511   ;
                     F517   266 Random          =     0xF517   ;
                     F533   267 Init_Music_Buf  =     0xF533   ;
                     F53F   268 Clear_x_b       =     0xF53F   ;
                     F542   269 Clear_C8_RAM    =     0xF542   ;never used by GCE carts?
                     F545   270 Clear_x_256     =     0xF545   ;
                     F548   271 Clear_x_d       =     0xF548   ;
                     F550   272 Clear_x_b_80    =     0xF550   ;
                     F552   273 Clear_x_b_a     =     0xF552   ;
                     F55A   274 Dec_3_Counters  =     0xF55A   ;
                     F55E   275 Dec_6_Counters  =     0xF55E   ;
                     F563   276 Dec_Counters    =     0xF563   ;
                     F56D   277 Delay_3         =     0xF56D   ;30 cycles
                     F571   278 Delay_2         =     0xF571   ;25 cycles
                     F575   279 Delay_1         =     0xF575   ;20 cycles
                     F579   280 Delay_0         =     0xF579   ;12 cycles
                     F57A   281 Delay_b         =     0xF57A   ;5*B + 10 cycles
                     F57D   282 Delay_RTS       =     0xF57D   ;5 cycles
                     F57E   283 Bitmask_a       =     0xF57E   ;
                     F584   284 Abs_a_b         =     0xF584   ;
                     F58B   285 Abs_b           =     0xF58B   ;
                     F593   286 Rise_Run_Angle  =     0xF593   ;
                     F5D9   287 Get_Rise_Idx    =     0xF5D9   ;
                     F5DB   288 Get_Run_Idx     =     0xF5DB   ;
                     F5EF   289 Get_Rise_Run    =     0xF5EF   ;
                     F5FF   290 Rise_Run_X      =     0xF5FF   ;
                     F601   291 Rise_Run_Y      =     0xF601   ;
                     F603   292 Rise_Run_Len    =     0xF603   ;
                            293 
                     F610   294 Rot_VL_ab       =     0xF610   ;
                     F616   295 Rot_VL          =     0xF616   ;
                     F61F   296 Rot_VL_Mode   =     0xF61F   ;
                     F62B   297 Rot_VL_M_dft     =     0xF62B   ;
                            298 ;Rot_VL_dft      EQU     0xF637   ;
                            299 
                            300 
                            301 ;Rot_VL_ab       EQU     0xF610   ;
                            302 ;Rot_VL          EQU     0xF616   ;
                            303 ;Rot_VL_Mode_a   EQU     0xF61F   ;
                            304 ;Rot_VL_Mode     EQU     0xF62B   ;
                            305 ;Rot_VL_dft      EQU     0xF637   ;
                            306 
                     F65B   307 Xform_Run_a     =     0xF65B   ;
                     F65D   308 Xform_Run       =     0xF65D   ;
                     F661   309 Xform_Rise_a    =     0xF661   ;
                     F663   310 Xform_Rise      =     0xF663   ;
                     F67F   311 Move_Mem_a_1    =     0xF67F   ;
                     F683   312 Move_Mem_a      =     0xF683   ;
                     F687   313 Init_Music_chk  =     0xF687   ;
                     F68D   314 Init_Music      =     0xF68D   ;
                     F692   315 Init_Music_x    =     0xF692   ;
                     F7A9   316 Select_Game     =     0xF7A9   ;
                     F84F   317 Clear_Score     =     0xF84F   ;
                     F85E   318 Add_Score_a     =     0xF85E   ;
                     F87C   319 Add_Score_d     =     0xF87C   ;
                     F8B7   320 Strip_Zeros     =     0xF8B7   ;
                     F8C7   321 Compare_Score   =     0xF8C7   ;
                     F8D8   322 New_High_Score  =     0xF8D8   ;
                     F8E5   323 Obj_Will_Hit_u  =     0xF8E5   ;
                     F8F3   324 Obj_Will_Hit    =     0xF8F3   ;
                     F8FF   325 Obj_Hit         =     0xF8FF   ;
                     F92E   326 Explosion_Snd   =     0xF92E   ;
                     FF9F   327 Draw_Grid_VL    =     0xFF9F   ;
                            328                                 ;
                     FD0D   329 music1  = 0xFD0D               ;
                     FD1D   330 music2  = 0xFD1D               ;
                     FD81   331 music3  = 0xFD81               ;
                     FDD3   332 music4  = 0xFDD3               ;
                     FE38   333 music5  = 0xFE38               ;
                     FE76   334 music6  = 0xFE76               ;
                     FEC6   335 music7  = 0xFEC6               ;
                     FEF8   336 music8  = 0xFEF8               ;
                     FF26   337 music9  = 0xFF26               ;
                     FF44   338 musica  = 0xFF44               ;
                     FF62   339 musicb  = 0xFF62               ;
                     FF7A   340 musicc  = 0xFF7A               ;
                     FF8F   341 musicd  = 0xFF8F               ;
                     F9F4   342 Char_Table = 0xF9F4
                     FBD4   343 Char_Table_End = 0xFBD4
                            344 
                            345 ; include line ->                     INCLUDE  "3d_var.I"          ; vectrex function includes
                            346 ; this file is part of Release, written by Malban in 2017
                            347 ;
                            348 ; uses 11 + 27 *3 = 92 bytes RAM space
                            349 
                            350  .globl _helper
   C911                     351 _helper:          .blkb 1
                            352  .globl _cosx
   C912                     353 _cosx:            .blkb 1
                            354  .globl _sinx
   C913                     355 _sinx:            .blkb 1
                            356  .globl _cosy
   C914                     357 _cosy:            .blkb 1
                            358  .globl _siny
   C915                     359 _siny:            .blkb 1
                            360  .globl _cosz
   C916                     361 _cosz:            .blkb 1
                            362  .globl _sinz
   C917                     363 _sinz:            .blkb 1
                            364  .globl _angle_x
   C918                     365 _angle_x:         .blkb 1
                            366  .globl _angle_y
   C919                     367 _angle_y:         .blkb 1
                            368  .globl _angle_z
   C91A                     369 _angle_z:         .blkb 1
                            370  .globl _vectorBits
   C91B                     371 _vectorBits: .blkb 2; 16 bits for vectors which must be calculated, order like below
                            372  .globl _scale_3d
   C91D                     373 _scale_3d: .blkb 1
                            374  .globl _scale_3d_move
   C91E                     375 _scale_3d_move: .blkb 1
                            376 
                            377 
                            378  .globl _allDirs_calc
   C91F                     379 _allDirs_calc:    .blkb 27 * 3
                            380  .globl _start_letter_data
   C970                     381 _start_letter_data: .blkb 0
                            382 
                     0001   383 TEST_0_0_0           = 0x01 ; low byte
                     0002   384 TEST_1_0_0           = 0x02 ; low byte
                     0004   385 TEST_1_1_0           = 0x04 ; low byte
                     0008   386 TEST_1_0_1           = 0x08 ; low byte
                     0010   387 TEST_1_1_1           = 0x10 ; low byte
                     0020   388 TEST_0_1_0           = 0x20 ; low byte
                     0040   389 TEST_0_1_1           = 0x40 ; low byte
                     0080   390 TEST_0_0_1           = 0x80 ; low byte
                     0001   391 TEST_N_1_0           = 0x01 ; high byte
                     0002   392 TEST_N_0_1           = 0x02 ; high byte
                     0004   393 TEST_0_N_1           = 0x04 ; high byte
                     0008   394 TEST_N_1_1           = 0x08 ; high byte
                     0010   395 TEST_1_N_1           = 0x10 ; high byte
                     0020   396 TEST_1_1_N           = 0x20 ; high byte
                            397 
                     000E   398 _0_0_0           = (_allDirs_calc+0)
                     0011   399 _1_0_0           = (_allDirs_calc+3)
                     0014   400 _1_1_0           = (_allDirs_calc+6)
                     0017   401 _1_0_1           = (_allDirs_calc+9)
                     001A   402 _1_1_1           = (_allDirs_calc+12)
                     001D   403 _0_1_0           = (_allDirs_calc+15)
                     0020   404 _0_1_1           = (_allDirs_calc+18)
                     0023   405 _0_0_1           = (_allDirs_calc+21)
                     0026   406 _N_1_0           = (_allDirs_calc+24)
                     0029   407 _N_0_1           = (_allDirs_calc+27)
                     002C   408 _0_N_1           = (_allDirs_calc+30)
                     002F   409 _N_1_1           = (_allDirs_calc+33)
                     0032   410 _1_N_1           = (_allDirs_calc+36)
                     0035   411 _1_1_N           = (_allDirs_calc+39)
                            412 
                     002A   413 INVERS_OFFSET    = 42
                            414 
                     0000   415 ADD_000 = 0
                     0003   416 ADD_100 = 3
                     0006   417 ADD_110 = 6
                     0009   418 ADD_101 = 9
                     000C   419 ADD_111 = 12
                     000F   420 ADD_010 = 15
                     0012   421 ADD_011 = 18
                     0015   422 ADD_001 = 21
                     0018   423 ADD_N10 = 24
                     001B   424 ADD_N01 = 27
                     001E   425 ADD_0N1 = 30
                     0021   426 ADD_N11 = 33
                     0024   427 ADD_1N1 = 36
                     0027   428 ADD_11N = 39
                            429 
                     0038   430 I_0_0_0          = (_0_0_0 + INVERS_OFFSET)
                     003B   431 I_1_0_0          = (_1_0_0 + INVERS_OFFSET)
                     003E   432 I_1_1_0          = (_1_1_0 + INVERS_OFFSET)
                     0041   433 I_1_0_1          = (_1_0_1 + INVERS_OFFSET)
                     0044   434 I_1_1_1          = (_1_1_1 + INVERS_OFFSET)
                     0047   435 I_0_1_0          = (_0_1_0 + INVERS_OFFSET)
                     004A   436 I_0_1_1          = (_0_1_1 + INVERS_OFFSET)
                     004D   437 I_0_0_1          = (_0_0_1 + INVERS_OFFSET)
                     0050   438 I_N_1_0          = (_N_1_0 + INVERS_OFFSET)
                     0053   439 I_N_0_1          = (_N_0_1 + INVERS_OFFSET)
                     0056   440 I_0_N_1          = (_0_N_1 + INVERS_OFFSET)
                     0059   441 I_N_1_1          = (_N_1_1 + INVERS_OFFSET)
                     005C   442 I_1_N_1          = (_1_N_1 + INVERS_OFFSET)
                     005F   443 I_1_1_N          = (_1_1_N + INVERS_OFFSET)
                            444 
                     003B   445 _N_0_0           = I_1_0_0
                     003E   446 _N_N_0           = I_1_1_0
                     0041   447 _N_0_N           = I_1_0_1
                     0044   448 _N_N_N           = I_1_1_1
                     0047   449 _0_N_0           = I_0_1_0
                     004A   450 _0_N_N           = I_0_1_1
                     004D   451 _0_0_N           = I_0_0_1
                     0050   452 _1_N_0           = I_N_1_0
                     0053   453 _1_0_N           = I_N_0_1
                     0056   454 _0_1_N           = I_0_N_1
                     0059   455 _1_N_N           = I_N_1_1
                     005C   456 _N_1_N           = I_1_N_1
                     005F   457 _N_N_1           = I_1_1_N
                            458 ; include line ->                     INCLUDE  "3d_MAKRO.I"          ; vectrex function includes
                            459 ; this file is part of Release, written by Malban in 2017
                            460 ;
                            461 ;***************************************************************************
                            462 ;***************************************************************************
                            463 ;***************************************************************************
                            464 ;***************************************************************************
                            465 ;***************************************************************************
                            466 ;***************************************************************************
                            467 ;***************************************************************************
                            468 ; this does:
                            469 ; signed multiplication of parameter 1 and parameter 2 to D
                            470 ; and divides D by 64
                            471 ; result is stored in A
                            472 
                            473 ;***************************************************************************
                            474 ; include line ->                  INCLUDE "000.I"
                            475 ; this file is part of Release, written by Malban in 2017
                            476 ;
                     000E   477 _000x            = (_allDirs_calc + ADD_000)
                     000F   478 _000y            = (_allDirs_calc + ADD_000 + 1)
                     0010   479 _000z            = (_allDirs_calc + ADD_000 + 2)
                     0038   480 _000xi           = (_allDirs_calc + (ADD_000) + INVERS_OFFSET)
                     0039   481 _000yi           = (_allDirs_calc + (ADD_000) + INVERS_OFFSET + 1)
                     003A   482 _000zi           = (_allDirs_calc + (ADD_000) + INVERS_OFFSET + 2)
                            483 
                            484 ;***************************************************************************
                            485 ;***************************************************************************
                            486 ;***************************************************************************
                            487 ;***************************************************************************
                            488 ;***************************************************************************
                            489 ;***************************************************************************
                            490 ;***************************************************************************
                            491 ; include line ->                  INCLUDE "100.I"
                            492 ; this file is part of Release, written by Malban in 2017
                            493 ;
                     0011   494 _100x            = (_allDirs_calc + ADD_100)
                     0012   495 _100y            = (_allDirs_calc + ADD_100 + 1)
                     0013   496 _100z            = (_allDirs_calc + ADD_100 + 2)
                     003B   497 _100xi           = (_allDirs_calc + (ADD_100) + INVERS_OFFSET)
                     003C   498 _100yi           = (_allDirs_calc + (ADD_100) + INVERS_OFFSET + 1)
                     003D   499 _100zi           = (_allDirs_calc + (ADD_100) + INVERS_OFFSET + 2)
                            500 
                            501 ;***************************************************************************
                            502 ;***************************************************************************
                            503 ;***************************************************************************
                            504 ;***************************************************************************
                            505 ;***************************************************************************
                            506 ;***************************************************************************
                            507 ;***************************************************************************
                            508 ;***************************************************************************
                            509 ;***************************************************************************
                            510 ;***************************************************************************
                            511 ; include line ->                  INCLUDE "110.I"
                            512 ; this file is part of Release, written by Malban in 2017
                            513 ;
                     0014   514 _110x            = (_allDirs_calc + ADD_110)
                     0015   515 _110y            = (_allDirs_calc + ADD_110 + 1)
                     0016   516 _110z            = (_allDirs_calc + ADD_110 + 2)
                     003E   517 _110xi           = (_allDirs_calc + (ADD_110) + INVERS_OFFSET)
                     003F   518 _110yi           = (_allDirs_calc + (ADD_110) + INVERS_OFFSET + 1)
                     0040   519 _110zi           = (_allDirs_calc + (ADD_110) + INVERS_OFFSET + 2)
                            520 
                            521 ;***************************************************************************
                            522 ;***************************************************************************
                            523 ;***************************************************************************
                            524 ;***************************************************************************
                            525 ;***************************************************************************
                            526 ;***************************************************************************
                            527 ;***************************************************************************
                            528 ;***************************************************************************
                            529 ;***************************************************************************
                            530 ;***************************************************************************
                            531 ; include line ->                  INCLUDE "101.I"
                            532 ; this file is part of Release, written by Malban in 2017
                            533 ;
                     0017   534 _101x            = (_allDirs_calc + ADD_101)
                     0018   535 _101y            = (_allDirs_calc + ADD_101 + 1)
                     0019   536 _101z            = (_allDirs_calc + ADD_101 + 2)
                     0041   537 _101xi           = (_allDirs_calc + (ADD_101) + INVERS_OFFSET)
                     0042   538 _101yi           = (_allDirs_calc + (ADD_101) + INVERS_OFFSET + 1)
                     0043   539 _101zi           = (_allDirs_calc + (ADD_101) + INVERS_OFFSET + 2)
                            540 
                            541 ;***************************************************************************
                            542 ;***************************************************************************
                            543 ;***************************************************************************
                            544 ;***************************************************************************
                            545 ;***************************************************************************
                            546 ;***************************************************************************
                            547 ;***************************************************************************
                            548 ;***************************************************************************
                            549 ;***************************************************************************
                            550 ;***************************************************************************
                            551 ; include line ->                  INCLUDE "111.I"
                            552 ; this file is part of Release, written by Malban in 2017
                            553 ;
                     001A   554 _111x            = (_allDirs_calc + ADD_111)
                     001B   555 _111y            = (_allDirs_calc + ADD_111 + 1)
                     001C   556 _111z            = (_allDirs_calc + ADD_111 + 2)
                     0044   557 _111xi           = (_allDirs_calc + (ADD_111) + INVERS_OFFSET)
                     0045   558 _111yi           = (_allDirs_calc + (ADD_111) + INVERS_OFFSET + 1)
                     0046   559 _111zi           = (_allDirs_calc + (ADD_111) + INVERS_OFFSET + 2)
                            560 
                            561 ;***************************************************************************
                            562 ;***************************************************************************
                            563 ;***************************************************************************
                            564 ;***************************************************************************
                            565 ;***************************************************************************
                            566 ;***************************************************************************
                            567 ;***************************************************************************
                            568 ;***************************************************************************
                            569 ;***************************************************************************
                            570 ;***************************************************************************
                            571 ; include line ->                  INCLUDE "010.I"
                            572 ; this file is part of Release, written by Malban in 2017
                            573 ;
                     001D   574 _010x            = (_allDirs_calc + ADD_010)
                     001E   575 _010y            = (_allDirs_calc + ADD_010 + 1)
                     001F   576 _010z            = (_allDirs_calc + ADD_010 + 2)
                     0047   577 _010xi           = (_allDirs_calc + (ADD_010) + INVERS_OFFSET)
                     0048   578 _010yi           = (_allDirs_calc + (ADD_010) + INVERS_OFFSET + 1)
                     0049   579 _010zi           = (_allDirs_calc + (ADD_010) + INVERS_OFFSET + 2)
                            580 
                            581 ;***************************************************************************
                            582 ;***************************************************************************
                            583 ;***************************************************************************
                            584 ;***************************************************************************
                            585 ;***************************************************************************
                            586 ;***************************************************************************
                            587 ;***************************************************************************
                            588 ;***************************************************************************
                            589 ;***************************************************************************
                            590 ;***************************************************************************
                            591 ; include line ->                  INCLUDE "011.I"
                            592 ; this file is part of Release, written by Malban in 2017
                            593 ;
                     0020   594 _011x            = (_allDirs_calc + ADD_011)
                     0021   595 _011y            = (_allDirs_calc + ADD_011 + 1)
                     0022   596 _011z            = (_allDirs_calc + ADD_011 + 2)
                     004A   597 _011xi           = (_allDirs_calc + (ADD_011) + INVERS_OFFSET)
                     004B   598 _011yi           = (_allDirs_calc + (ADD_011) + INVERS_OFFSET + 1)
                     004C   599 _011zi           = (_allDirs_calc + (ADD_011) + INVERS_OFFSET + 2)
                            600 
                            601 ;***************************************************************************
                            602 ;***************************************************************************
                            603 ;***************************************************************************
                            604 ;***************************************************************************
                            605 ;***************************************************************************
                            606 ;***************************************************************************
                            607 ;***************************************************************************
                            608 ;***************************************************************************
                            609 ;***************************************************************************
                            610 ;***************************************************************************
                            611 ; include line ->                  INCLUDE "001.I"
                            612 ; this file is part of Release, written by Malban in 2017
                            613 ;
                     0023   614 _001x            = (_allDirs_calc + ADD_001)
                     0024   615 _001y            = (_allDirs_calc + ADD_001 + 1)
                     0025   616 _001z            = (_allDirs_calc + ADD_001 + 2)
                     004D   617 _001xi           = (_allDirs_calc + (ADD_001) + INVERS_OFFSET)
                     004E   618 _001yi           = (_allDirs_calc + (ADD_001) + INVERS_OFFSET + 1)
                     004F   619 _001zi           = (_allDirs_calc + (ADD_001) + INVERS_OFFSET + 2)
                            620 
                            621 ;***************************************************************************
                            622 ;***************************************************************************
                            623 ;***************************************************************************
                            624 ;***************************************************************************
                            625 ;***************************************************************************
                            626 ;***************************************************************************
                            627 ;***************************************************************************
                            628 ;***************************************************************************
                            629 ;***************************************************************************
                            630 ;***************************************************************************
                            631 ; include line ->                  INCLUDE "N10.I"
                            632 ; this file is part of Release, written by Malban in 2017
                            633 ;
                     0026   634 _N10x            = (_allDirs_calc + ADD_N10)
                     0027   635 _N10y            = (_allDirs_calc + ADD_N10 + 1)
                     0028   636 _N10z            = (_allDirs_calc + ADD_N10 + 2)
                     0050   637 _N10xi           = (_allDirs_calc + (ADD_N10) + INVERS_OFFSET)
                     0051   638 _N10yi           = (_allDirs_calc + (ADD_N10) + INVERS_OFFSET + 1)
                     0052   639 _N10zi           = (_allDirs_calc + (ADD_N10) + INVERS_OFFSET + 2)
                            640 
                            641 ;***************************************************************************
                            642 ;***************************************************************************
                            643 ;***************************************************************************
                            644 ;***************************************************************************
                            645 ;***************************************************************************
                            646 ;***************************************************************************
                            647 ;***************************************************************************
                            648 ;***************************************************************************
                            649 ;***************************************************************************
                            650 ;***************************************************************************
                            651 ; include line ->                  INCLUDE "N01.I"
                            652 ; this file is part of Release, written by Malban in 2017
                            653 ;
                     0029   654 _N01x            = (_allDirs_calc + ADD_N01)
                     002A   655 _N01y            = (_allDirs_calc + ADD_N01 + 1)
                     002B   656 _N01z            = (_allDirs_calc + ADD_N01 + 2)
                     0053   657 _N01xi           = (_allDirs_calc + (ADD_N01) + INVERS_OFFSET)
                     0054   658 _N01yi           = (_allDirs_calc + (ADD_N01) + INVERS_OFFSET + 1)
                     0055   659 _N01zi           = (_allDirs_calc + (ADD_N01) + INVERS_OFFSET + 2)
                            660 
                            661 ;***************************************************************************
                            662 ;***************************************************************************
                            663 ;***************************************************************************
                            664 ;***************************************************************************
                            665 ;***************************************************************************
                            666 ;***************************************************************************
                            667 ;***************************************************************************
                            668 ;***************************************************************************
                            669 ;***************************************************************************
                            670 ;***************************************************************************
                            671 ; include line ->                  INCLUDE "0N1.I"
                            672 ; this file is part of Release, written by Malban in 2017
                            673 ;
                     002C   674 _0N1x            = (_allDirs_calc + ADD_0N1)
                     002D   675 _0N1y            = (_allDirs_calc + ADD_0N1 + 1)
                     002E   676 _0N1z            = (_allDirs_calc + ADD_0N1 + 2)
                     0056   677 _0N1xi           = (_allDirs_calc + (ADD_0N1) + INVERS_OFFSET)
                     0057   678 _0N1yi           = (_allDirs_calc + (ADD_0N1) + INVERS_OFFSET + 1)
                     0058   679 _0N1zi           = (_allDirs_calc + (ADD_0N1) + INVERS_OFFSET + 2)
                            680 
                            681 ;***************************************************************************
                            682 ;***************************************************************************
                            683 ;***************************************************************************
                            684 ;***************************************************************************
                            685 ;***************************************************************************
                            686 ;***************************************************************************
                            687 ;***************************************************************************
                            688 ;***************************************************************************
                            689 ;***************************************************************************
                            690 ;***************************************************************************
                            691 ; include line ->                  INCLUDE "N11.I"
                            692 ; this file is part of Release, written by Malban in 2017
                            693 ;
                     002F   694 _N11x            = (_allDirs_calc + ADD_N11)
                     0030   695 _N11y            = (_allDirs_calc + ADD_N11 + 1)
                     0031   696 _N11z            = (_allDirs_calc + ADD_N11 + 2)
                     0059   697 _N11xi           = (_allDirs_calc + (ADD_N11) + INVERS_OFFSET)
                     005A   698 _N11yi           = (_allDirs_calc + (ADD_N11) + INVERS_OFFSET + 1)
                     005B   699 _N11zi           = (_allDirs_calc + (ADD_N11) + INVERS_OFFSET + 2)
                            700 
                            701 ;***************************************************************************
                            702 ;***************************************************************************
                            703 ;***************************************************************************
                            704 ;***************************************************************************
                            705 ;***************************************************************************
                            706 ;***************************************************************************
                            707 ;***************************************************************************
                            708 ;***************************************************************************
                            709 ;***************************************************************************
                            710 ;***************************************************************************
                            711 ; include line ->                  INCLUDE "1N1.I"
                            712 ; this file is part of Release, written by Malban in 2017
                            713 ;
                     0032   714 _1N1x            = (_allDirs_calc + ADD_1N1)
                     0033   715 _1N1y            = (_allDirs_calc + ADD_1N1 + 1)
                     0034   716 _1N1z            = (_allDirs_calc + ADD_1N1 + 2)
                     005C   717 _1N1xi           = (_allDirs_calc + (ADD_1N1) + INVERS_OFFSET)
                     005D   718 _1N1yi           = (_allDirs_calc + (ADD_1N1) + INVERS_OFFSET + 1)
                     005E   719 _1N1zi           = (_allDirs_calc + (ADD_1N1) + INVERS_OFFSET + 2)
                            720 
                            721 ;***************************************************************************
                            722 ;***************************************************************************
                            723 ;***************************************************************************
                            724 ;***************************************************************************
                            725 ;***************************************************************************
                            726 ;***************************************************************************
                            727 ;***************************************************************************
                            728 ;***************************************************************************
                            729 ;***************************************************************************
                            730 ;***************************************************************************
                            731 ; include line ->                  INCLUDE "11N.I"
                            732 ; this file is part of Release, written by Malban in 2017
                            733 ;
                     0035   734 _11Nx            = (_allDirs_calc + ADD_11N)
                     0036   735 _11Ny            = (_allDirs_calc + ADD_11N + 1)
                     0037   736 _11Nz            = (_allDirs_calc + ADD_11N + 2)
                     005F   737 _11Nxi           = (_allDirs_calc + (ADD_11N) + INVERS_OFFSET)
                     0060   738 _11Nyi           = (_allDirs_calc + (ADD_11N) + INVERS_OFFSET + 1)
                     0061   739 _11Nzi           = (_allDirs_calc + (ADD_11N) + INVERS_OFFSET + 2)
                            740 
                            741 ;***************************************************************************
                            742 ;***************************************************************************
                            743 ;***************************************************************************
                            744 ;***************************************************************************
                            745 ;***************************************************************************
                            746 ;***************************************************************************
                            747 ;***************************************************************************
                            748 ;***************************************************************************
                            749 ;***************************************************************************
                            750 ;***************************************************************************
                            751 
                            752 
                            753 
                            754 ;***************************************************************************
                            755 ; HEADER SECTION
                            756 ;***************************************************************************
                            757 ; The cartridge ROM starts at address 0
                            758                     .area .text     
                            759 ; Warning - org line found, my be countering relocatable code!
                            760 ;                    ORG      0 
                            761 
                            762 
                            763 ; include line ->                     INCLUDE  "3d_prg.I"          ; vectrex function includes
                            764 ; this file is part of Release, written by Malban in 2017
                            765 ;
                            766 ;**********************************************************  
                            767 ; input list in X
                            768 ; destroys u
                            769 ; 0 move
                            770 ; negative use as shift
                            771 ; positive end
                            772  .globl asm_draw_3ds
   101D                     773 asm_draw_3ds: 
   101D EE 02         [ 6]  774        ldu 2,x
   101F A6 01         [ 5]  775        lda 1,x;
                            776  .globl starts
   1021                     777 starts:
   1021 B7 D0 04      [ 5]  778        sta 0xd004;
   1024 EC C4         [ 5]  779        ldd ,u;
   1026 B7 D0 01      [ 5]  780        sta 0xd001;
   1029 7F D0 00      [ 7]  781        clr 0xd000;
   102C A6 84         [ 4]  782        lda ,x;
   102E 7C D0 00      [ 7]  783        inc 0xd000;
   1031 F7 D0 01      [ 5]  784        stb 0xd001;
   1034 B7 D0 0A      [ 5]  785        sta 0xd00A;
   1037 7F D0 05      [ 7]  786        clr 0xd005;
   103A 30 04         [ 5]  787        leax 4,x;
   103C EE 02         [ 6]  788        ldu 2,x;
   103E A6 84         [ 4]  789        lda ,x;
   1040 2E 10         [ 3]  790        bgt end1s;
   1042 A6 01         [ 5]  791        lda 1,x;
   1044 C6 40         [ 2]  792        ldb #0x40;
                            793  .globl waits
   1046 F5 D0 0D      [ 5]  794 waits: bitb 0xd00D;
   1049 27 FB         [ 3]  795        beq waits;
   104B C6 00         [ 2]  796        ldb #0
   104D F7 D0 0A      [ 5]  797        stb 0xd00A;
   1050 20 CF         [ 3]  798        bra starts;
                            799  .globl end1s
   1052 CC 00 40      [ 3]  800 end1s: ldd #0x0040;
                            801  .globl ends
   1055 F5 D0 0D      [ 5]  802 ends:  bitb 0xd00D;
   1058 27 FB         [ 3]  803        beq ends;
   105A B7 D0 0A      [ 5]  804        sta 0xd00A
   105D 39            [ 5]  805  rts
                            806 
                            807  
                            808  .globl asm_draw_3d
   105E                     809 asm_draw_3d:
   105E EE 01         [ 6]  810        ldu 1,x
                            811  .globl start
   1060 EC C4         [ 5]  812 start: ldd ,u;
   1062 B7 D0 01      [ 5]  813        sta 0xd001;
   1065 7F D0 00      [ 7]  814        clr 0xd000;
   1068 A6 84         [ 4]  815        lda ,x;
   106A 7C D0 00      [ 7]  816        inc 0xd000;
   106D F7 D0 01      [ 5]  817        stb 0xd001;
   1070 B7 D0 0A      [ 5]  818        sta 0xd00A;
   1073 7F D0 05      [ 7]  819        clr 0xd005;
   1076 30 03         [ 5]  820        leax 3,x;
   1078 EE 01         [ 6]  821        ldu 1,x;
   107A A6 84         [ 4]  822        lda ,x;
   107C 2E 0D         [ 3]  823        bgt end1;
   107E CC 00 40      [ 3]  824        ldd #0x0040;
                            825  .globl wait
   1081 F5 D0 0D      [ 5]  826 wait:  bitb 0xd00D;
   1084 27 FB         [ 3]  827        beq wait;
   1086 B7 D0 0A      [ 5]  828        sta 0xd00A;
   1089 20 D5         [ 3]  829        bra start;
                            830  .globl end1
   108B CC 00 40      [ 3]  831 end1:  ldd #0x0040;
                            832  .globl end
   108E F5 D0 0D      [ 5]  833 end:   bitb 0xd00D;
   1091 27 FB         [ 3]  834        beq end;
   1093 B7 D0 0A      [ 5]  835        sta 0xd00A
   1096 39            [ 5]  836  rts
                            837 
                            838  .globl asm_draw_3d_dp
   1097                     839 asm_draw_3d_dp:
   1097 EE 01         [ 6]  840        ldu 1,x
                            841  .globl start_dp
   1099 EC C4         [ 5]  842 start_dp: ldd ,u;
   109B 97 01         [ 4]  843        sta *0xd001;
   109D 0F 00         [ 6]  844        clr *0xd000;
   109F A6 84         [ 4]  845        lda ,x;
   10A1 0C 00         [ 6]  846        inc *0xd000;
   10A3 D7 01         [ 4]  847        stb *0xd001;
   10A5 97 0A         [ 4]  848        sta *0xd00A;
   10A7 0F 05         [ 6]  849        clr *0xd005;
   10A9 30 03         [ 5]  850        leax 3,x;
   10AB EE 01         [ 6]  851        ldu 1,x;
   10AD A6 84         [ 4]  852        lda ,x;
   10AF 2E 0B         [ 3]  853        bgt end1_dp;
   10B1 CC 00 40      [ 3]  854        ldd #0x0040;
                            855  .globl wait_dp
   10B4 D5 0D         [ 4]  856 wait_dp:  bitb *0xd00D;
   10B6 27 FC         [ 3]  857        beq wait_dp;
   10B8 97 0A         [ 4]  858        sta *0xd00A;
   10BA 20 DD         [ 3]  859        bra start_dp;
                            860  .globl end1_dp
   10BC CC 00 40      [ 3]  861 end1_dp:  ldd #0x0040;
                            862  .globl end_dp
   10BF D5 0D         [ 4]  863 end_dp:   bitb *0xd00D;
   10C1 27 FC         [ 3]  864        beq end_dp;
   10C3 97 0A         [ 4]  865        sta *0xd00A
   10C5 39            [ 5]  866  rts
                            867 
                            868 
                            869 ; Cosinus data
                            870  .globl _cosinus3d
   10C6                     871 _cosinus3d: 
   10C6 3F 3E 3D 3C 3A 37   872                     .byte       63, 62, 61, 60, 58, 55, 52, 48, 43, 39, 34 ; 11 
        34 30 2B 27 22
   10D1 1C 17 11 0A 04 FF   873                     .byte       28, 23, 17, 10, 4, -1, -7, -14, -20, -25, -31 ; 22 
        F9 F2 EC E7 E1
   10DC DC D7 D2 CE CB C8   874                     .byte       -36, -41, -46, -50, -53, -56, -59, -61, -62, -62, -62 ; 33 
        C5 C3 C2 C2 C2
   10E7 C2 C3 C5 C8 CB CE   875                     .byte       -62, -61, -59, -56, -53, -50, -46, -41, -36, -31, -25 ; 44 
        D2 D7 DC E1 E7
   10F2 EC F2 F9 FF 04 0A   876                     .byte       -20, -14, -7, -1, 4, 10, 17, 23, 28, 34, 39 ; 55 
        11 17 1C 22 27
   10FD 2B 30 34 37 3A 3C   877                     .byte       43, 48, 52, 55, 58, 60, 61, 62, 63 
        3D 3E 3F
                            878 ; Sinus data
                            879  .globl _sinus3d
   1106                     880 _sinus3d: 
   1106 00 06 0C 12 18 1E   881                     .byte       0, 6, 12, 18, 24, 30, 35, 40, 45, 49, 52 ; 11 
        23 28 2D 31 34
   1111 38 3A 3C 3E 3E 3E   882                     .byte       56, 58, 60, 62, 62, 62, 62, 61, 59, 57, 54 ; 22 
        3E 3D 3B 39 36
   111C 33 2F 2A 26 20 1B   883                     .byte       51, 47, 42, 38, 32, 27, 21, 15, 9, 3, -3 ; 33 
        15 0F 09 03 FD
   1127 F7 F1 EB E5 E0 DA   884                     .byte       -9, -15, -21, -27, -32, -38, -42, -47, -51, -54, -57 ; 44 
        D6 D1 CD CA C7
   1132 C5 C3 C2 C2 C2 C2   885                     .byte       -59, -61, -62, -62, -62, -62, -60, -58, -56, -52, -49 ; 55 
        C4 C6 C8 CC CF
   113D D3 D8 DD E2 E8 EE   886                     .byte       -45, -40, -35, -30, -24, -18, -12, -6, -3 
        F4 FA FD
                            887 
                            888 
                            889  .globl init_2d
   1146                     890 init_2d:
   1146 8E 10 C6      [ 3]  891                     LDX      #_cosinus3d 
   1149 CE 11 06      [ 3]  892                     LDU      #_sinus3d 
   114C F6 C9 18      [ 5]  893                     LDB      _angle_x 
   114F A6 85         [ 5]  894                     LDA      B, X 
   1151 B7 C9 12      [ 5]  895                     STA      _cosx 
   1154 A6 C5         [ 5]  896                     LDA      B, U 
   1156 B7 C9 13      [ 5]  897                     STA      _sinx 
   1159 F6 C9 19      [ 5]  898                     LDB      _angle_y 
   115C A6 85         [ 5]  899                     LDA      B, X 
   115E B7 C9 14      [ 5]  900                     STA      _cosy 
   1161 A6 C5         [ 5]  901                     LDA      B, U 
   1163 B7 C9 15      [ 5]  902                     STA      _siny 
   1166 F6 C9 1A      [ 5]  903                     LDB      _angle_z 
   1169 A6 85         [ 5]  904                     LDA      B, X 
   116B B7 C9 16      [ 5]  905                     STA      _cosz 
   116E A6 C5         [ 5]  906                     LDA      B, U 
   1170 B7 C9 17      [ 5]  907                     STA      _sinz 
                            908 
   1173 B6 C9 1C      [ 5]  909  lda _vectorBits+1
   1176 85 01         [ 2]  910  bita #TEST_0_0_0
   1178 27 10         [ 3]  911  beq no0002d
                            912 ; macro call ->                     INIT_0_0_0_A  
                            913 ; macro call ->                  CALC_0_0_0_A _000x, _000y, _000z, _000xi, _000yi, _000zi
   117A 4F            [ 2]  914                  CLRA
   117B B7 C9 1F      [ 5]  915                  STA           _000x
   117E B7 C9 20      [ 5]  916                  STA           _000y
   1181 B7 C9 49      [ 5]  917                  STA           _000xi
   1184 B7 C9 4A      [ 5]  918                  STA           _000yi
   1187 B6 C9 1C      [ 5]  919  lda _vectorBits+1
                            920  .globl no0002d
   118A                     921 no0002d:
   118A 85 20         [ 2]  922  bita #TEST_0_1_0
   118C 10 27 00 B2   [ 6]  923  lbeq no0102d
                            924 ; macro call ->                     INIT_0_1_0_A  
                            925 ; macro call ->                  CALC_0_1_0_A _010x, _010y, _010z, _010xi, _010yi, _010yi
                            926 ; macro call ->                  A_EQUALS_MUL _cosx, _siny
   1190 F6 C9 15      [ 5]  927                  LDB           _siny
   1193 B6 C9 12      [ 5]  928                  LDA           _cosx
   1196 2A 07         [ 3]  929                  BPL           mul_Ap5
   1198 40            [ 2]  930                  NEGA
   1199 5D            [ 2]  931                  TSTB
   119A 2A 07         [ 3]  932                  BPL           mul_An_Bp5
   119C 50            [ 2]  933                  NEGB
   119D 20 09         [ 3]  934                  BRA           mul_An_Bn5
                            935  .globl mul_Ap5
   119F                     936 mul_Ap5:
   119F 5D            [ 2]  937                  TSTB
   11A0 2A 06         [ 3]  938                  BPL           mul_Ap_Bp5
   11A2 50            [ 2]  939                  NEGB
                            940  .globl mul_An_Bp5
   11A3                     941 mul_An_Bp5:
   11A3 3D            [11]  942                  MUL
   11A4 53            [ 2]  943                  COMB                              ; here we can use this as negd
   11A5 43            [ 2]  944                  COMA                              ; since the low nibble of b doesn't interest us
   11A6 20 01         [ 3]  945                  BRA           mul_end5
                            946  .globl mul_Ap_Bp5
   11A8                     947 mul_Ap_Bp5:
                            948  .globl mul_An_Bn5
   11A8                     949 mul_An_Bn5:
   11A8 3D            [11]  950                  MUL
                            951  .globl mul_end5
   11A9                     952 mul_end5:
   11A9 58            [ 2]  953                  ASLB                              ; this divides d by 64
   11AA 49            [ 2]  954                  ROLA
   11AB 58            [ 2]  955                  ASLB
   11AC 49            [ 2]  956                  ROLA
                            957 
                            958 ; macro call ->                  STORE_A _010x
   11AD B7 C9 2E      [ 5]  959                  STA           _010x
                            960 ; macro call ->                  A_EQUALS_MUL _010x, _sinz
   11B0 F6 C9 17      [ 5]  961                  LDB           _sinz
   11B3 B6 C9 2E      [ 5]  962                  LDA           _010x
   11B6 2A 07         [ 3]  963                  BPL           mul_Ap7
   11B8 40            [ 2]  964                  NEGA
   11B9 5D            [ 2]  965                  TSTB
   11BA 2A 07         [ 3]  966                  BPL           mul_An_Bp7
   11BC 50            [ 2]  967                  NEGB
   11BD 20 09         [ 3]  968                  BRA           mul_An_Bn7
                            969  .globl mul_Ap7
   11BF                     970 mul_Ap7:
   11BF 5D            [ 2]  971                  TSTB
   11C0 2A 06         [ 3]  972                  BPL           mul_Ap_Bp7
   11C2 50            [ 2]  973                  NEGB
                            974  .globl mul_An_Bp7
   11C3                     975 mul_An_Bp7:
   11C3 3D            [11]  976                  MUL
   11C4 53            [ 2]  977                  COMB                              ; here we can use this as negd
   11C5 43            [ 2]  978                  COMA                              ; since the low nibble of b doesn't interest us
   11C6 20 01         [ 3]  979                  BRA           mul_end7
                            980  .globl mul_Ap_Bp7
   11C8                     981 mul_Ap_Bp7:
                            982  .globl mul_An_Bn7
   11C8                     983 mul_An_Bn7:
   11C8 3D            [11]  984                  MUL
                            985  .globl mul_end7
   11C9                     986 mul_end7:
   11C9 58            [ 2]  987                  ASLB                              ; this divides d by 64
   11CA 49            [ 2]  988                  ROLA
   11CB 58            [ 2]  989                  ASLB
   11CC 49            [ 2]  990                  ROLA
                            991 
                            992 ; macro call ->                  STORE_A _010y
   11CD B7 C9 2F      [ 5]  993                  STA           _010y
                            994 ; macro call ->                  A_EQUALS_MUL _sinx, _cosz
   11D0 F6 C9 16      [ 5]  995                  LDB           _cosz
   11D3 B6 C9 13      [ 5]  996                  LDA           _sinx
   11D6 2A 07         [ 3]  997                  BPL           mul_Ap9
   11D8 40            [ 2]  998                  NEGA
   11D9 5D            [ 2]  999                  TSTB
   11DA 2A 07         [ 3] 1000                  BPL           mul_An_Bp9
   11DC 50            [ 2] 1001                  NEGB
   11DD 20 09         [ 3] 1002                  BRA           mul_An_Bn9
                           1003  .globl mul_Ap9
   11DF                    1004 mul_Ap9:
   11DF 5D            [ 2] 1005                  TSTB
   11E0 2A 06         [ 3] 1006                  BPL           mul_Ap_Bp9
   11E2 50            [ 2] 1007                  NEGB
                           1008  .globl mul_An_Bp9
   11E3                    1009 mul_An_Bp9:
   11E3 3D            [11] 1010                  MUL
   11E4 53            [ 2] 1011                  COMB                              ; here we can use this as negd
   11E5 43            [ 2] 1012                  COMA                              ; since the low nibble of b doesn't interest us
   11E6 20 01         [ 3] 1013                  BRA           mul_end9
                           1014  .globl mul_Ap_Bp9
   11E8                    1015 mul_Ap_Bp9:
                           1016  .globl mul_An_Bn9
   11E8                    1017 mul_An_Bn9:
   11E8 3D            [11] 1018                  MUL
                           1019  .globl mul_end9
   11E9                    1020 mul_end9:
   11E9 58            [ 2] 1021                  ASLB                              ; this divides d by 64
   11EA 49            [ 2] 1022                  ROLA
   11EB 58            [ 2] 1023                  ASLB
   11EC 49            [ 2] 1024                  ROLA
                           1025 
                           1026 ; macro call ->                  SUB_A_FROM _010y
   11ED 40            [ 2] 1027                  NEGA
                           1028 ; macro call ->                  ADD_A_TO      _010y
   11EE BB C9 2F      [ 5] 1029                  ADDA          _010y
                           1030 ; macro call ->                  STORE_A       _010y
   11F1 B7 C9 2F      [ 5] 1031                  STA           _010y
                           1032 ; macro call ->                  STORE_A_NEG _010yi
   11F4 40            [ 2] 1033                  NEGA
   11F5 B7 C9 59      [ 5] 1034                  STA           _010yi
                           1035 ; macro call ->                  A_EQUALS_MUL _010x, _cosz
   11F8 F6 C9 16      [ 5] 1036                  LDB           _cosz
   11FB B6 C9 2E      [ 5] 1037                  LDA           _010x
   11FE 2A 07         [ 3] 1038                  BPL           mul_Ap14
   1200 40            [ 2] 1039                  NEGA
   1201 5D            [ 2] 1040                  TSTB
   1202 2A 07         [ 3] 1041                  BPL           mul_An_Bp14
   1204 50            [ 2] 1042                  NEGB
   1205 20 09         [ 3] 1043                  BRA           mul_An_Bn14
                           1044  .globl mul_Ap14
   1207                    1045 mul_Ap14:
   1207 5D            [ 2] 1046                  TSTB
   1208 2A 06         [ 3] 1047                  BPL           mul_Ap_Bp14
   120A 50            [ 2] 1048                  NEGB
                           1049  .globl mul_An_Bp14
   120B                    1050 mul_An_Bp14:
   120B 3D            [11] 1051                  MUL
   120C 53            [ 2] 1052                  COMB                              ; here we can use this as negd
   120D 43            [ 2] 1053                  COMA                              ; since the low nibble of b doesn't interest us
   120E 20 01         [ 3] 1054                  BRA           mul_end14
                           1055  .globl mul_Ap_Bp14
   1210                    1056 mul_Ap_Bp14:
                           1057  .globl mul_An_Bn14
   1210                    1058 mul_An_Bn14:
   1210 3D            [11] 1059                  MUL
                           1060  .globl mul_end14
   1211                    1061 mul_end14:
   1211 58            [ 2] 1062                  ASLB                              ; this divides d by 64
   1212 49            [ 2] 1063                  ROLA
   1213 58            [ 2] 1064                  ASLB
   1214 49            [ 2] 1065                  ROLA
                           1066 
                           1067 ; macro call ->                  STORE_A _010x
   1215 B7 C9 2E      [ 5] 1068                  STA           _010x
                           1069 ; macro call ->                  A_EQUALS_MUL _sinx, _sinz
   1218 F6 C9 17      [ 5] 1070                  LDB           _sinz
   121B B6 C9 13      [ 5] 1071                  LDA           _sinx
   121E 2A 07         [ 3] 1072                  BPL           mul_Ap16
   1220 40            [ 2] 1073                  NEGA
   1221 5D            [ 2] 1074                  TSTB
   1222 2A 07         [ 3] 1075                  BPL           mul_An_Bp16
   1224 50            [ 2] 1076                  NEGB
   1225 20 09         [ 3] 1077                  BRA           mul_An_Bn16
                           1078  .globl mul_Ap16
   1227                    1079 mul_Ap16:
   1227 5D            [ 2] 1080                  TSTB
   1228 2A 06         [ 3] 1081                  BPL           mul_Ap_Bp16
   122A 50            [ 2] 1082                  NEGB
                           1083  .globl mul_An_Bp16
   122B                    1084 mul_An_Bp16:
   122B 3D            [11] 1085                  MUL
   122C 53            [ 2] 1086                  COMB                              ; here we can use this as negd
   122D 43            [ 2] 1087                  COMA                              ; since the low nibble of b doesn't interest us
   122E 20 01         [ 3] 1088                  BRA           mul_end16
                           1089  .globl mul_Ap_Bp16
   1230                    1090 mul_Ap_Bp16:
                           1091  .globl mul_An_Bn16
   1230                    1092 mul_An_Bn16:
   1230 3D            [11] 1093                  MUL
                           1094  .globl mul_end16
   1231                    1095 mul_end16:
   1231 58            [ 2] 1096                  ASLB                              ; this divides d by 64
   1232 49            [ 2] 1097                  ROLA
   1233 58            [ 2] 1098                  ASLB
   1234 49            [ 2] 1099                  ROLA
                           1100 
                           1101 ; macro call ->                  ADD_A_TO _010x
   1235 BB C9 2E      [ 5] 1102                  ADDA          _010x
                           1103 ; macro call ->                  STORE_A       _010x
   1238 B7 C9 2E      [ 5] 1104                  STA           _010x
                           1105 ; macro call ->                  STORE_A_NEG _010xi
   123B 40            [ 2] 1106                  NEGA
   123C B7 C9 58      [ 5] 1107                  STA           _010xi
   123F B6 C9 1C      [ 5] 1108  lda _vectorBits+1
                           1109  .globl no0102d
   1242                    1110 no0102d:
   1242 85 02         [ 2] 1111  bita #TEST_1_0_0
   1244 27 4B         [ 3] 1112  beq no1002d
                           1113 ; macro call ->                     INIT_1_0_0_A  
                           1114 ; macro call ->                  CALC_1_0_0_A _100x, _100y, _100z, _100xi, _100yi, _100zi
                           1115 ; macro call ->                  A_EQUALS_MUL _cosy, _sinz
   1246 F6 C9 17      [ 5] 1116                  LDB           _sinz
   1249 B6 C9 14      [ 5] 1117                  LDA           _cosy
   124C 2A 07         [ 3] 1118                  BPL           mul_Ap22
   124E 40            [ 2] 1119                  NEGA
   124F 5D            [ 2] 1120                  TSTB
   1250 2A 07         [ 3] 1121                  BPL           mul_An_Bp22
   1252 50            [ 2] 1122                  NEGB
   1253 20 09         [ 3] 1123                  BRA           mul_An_Bn22
                           1124  .globl mul_Ap22
   1255                    1125 mul_Ap22:
   1255 5D            [ 2] 1126                  TSTB
   1256 2A 06         [ 3] 1127                  BPL           mul_Ap_Bp22
   1258 50            [ 2] 1128                  NEGB
                           1129  .globl mul_An_Bp22
   1259                    1130 mul_An_Bp22:
   1259 3D            [11] 1131                  MUL
   125A 53            [ 2] 1132                  COMB                              ; here we can use this as negd
   125B 43            [ 2] 1133                  COMA                              ; since the low nibble of b doesn't interest us
   125C 20 01         [ 3] 1134                  BRA           mul_end22
                           1135  .globl mul_Ap_Bp22
   125E                    1136 mul_Ap_Bp22:
                           1137  .globl mul_An_Bn22
   125E                    1138 mul_An_Bn22:
   125E 3D            [11] 1139                  MUL
                           1140  .globl mul_end22
   125F                    1141 mul_end22:
   125F 58            [ 2] 1142                  ASLB                              ; this divides d by 64
   1260 49            [ 2] 1143                  ROLA
   1261 58            [ 2] 1144                  ASLB
   1262 49            [ 2] 1145                  ROLA
                           1146 
                           1147 ; macro call ->                  STORE_A _100y
   1263 B7 C9 23      [ 5] 1148                  STA           _100y
                           1149 ; macro call ->                  STORE_A_NEG _100yi
   1266 40            [ 2] 1150                  NEGA
   1267 B7 C9 4D      [ 5] 1151                  STA           _100yi
                           1152 ; macro call ->                  A_EQUALS_MUL _cosy, _cosz
   126A F6 C9 16      [ 5] 1153                  LDB           _cosz
   126D B6 C9 14      [ 5] 1154                  LDA           _cosy
   1270 2A 07         [ 3] 1155                  BPL           mul_Ap25
   1272 40            [ 2] 1156                  NEGA
   1273 5D            [ 2] 1157                  TSTB
   1274 2A 07         [ 3] 1158                  BPL           mul_An_Bp25
   1276 50            [ 2] 1159                  NEGB
   1277 20 09         [ 3] 1160                  BRA           mul_An_Bn25
                           1161  .globl mul_Ap25
   1279                    1162 mul_Ap25:
   1279 5D            [ 2] 1163                  TSTB
   127A 2A 06         [ 3] 1164                  BPL           mul_Ap_Bp25
   127C 50            [ 2] 1165                  NEGB
                           1166  .globl mul_An_Bp25
   127D                    1167 mul_An_Bp25:
   127D 3D            [11] 1168                  MUL
   127E 53            [ 2] 1169                  COMB                              ; here we can use this as negd
   127F 43            [ 2] 1170                  COMA                              ; since the low nibble of b doesn't interest us
   1280 20 01         [ 3] 1171                  BRA           mul_end25
                           1172  .globl mul_Ap_Bp25
   1282                    1173 mul_Ap_Bp25:
                           1174  .globl mul_An_Bn25
   1282                    1175 mul_An_Bn25:
   1282 3D            [11] 1176                  MUL
                           1177  .globl mul_end25
   1283                    1178 mul_end25:
   1283 58            [ 2] 1179                  ASLB                              ; this divides d by 64
   1284 49            [ 2] 1180                  ROLA
   1285 58            [ 2] 1181                  ASLB
   1286 49            [ 2] 1182                  ROLA
                           1183 
                           1184 ; macro call ->                  STORE_A _100x
   1287 B7 C9 22      [ 5] 1185                  STA           _100x
                           1186 ; macro call ->                  STORE_A_NEG _100xi
   128A 40            [ 2] 1187                  NEGA
   128B B7 C9 4C      [ 5] 1188                  STA           _100xi
   128E B6 C9 1C      [ 5] 1189  lda _vectorBits+1
                           1190  .globl no1002d
   1291                    1191 no1002d:
   1291 85 04         [ 2] 1192  bita #TEST_1_1_0
   1293 10 27 00 B9   [ 6] 1193  lbeq no1102d
                           1194 ; macro call ->                     INIT_1_1_0_A  
                           1195 ; macro call ->                  CALC_1_1_0_A _110x, _110y, _110z, _110xi, _110yi, _110zi
   1297 B6 C9 13      [ 5] 1196                  LDA   _sinx
   129A 40            [ 2] 1197                  NEGA
   129B B7 C9 11      [ 5] 1198                  STA   _helper
                           1199 ; macro call ->                  A_EQUALS_MUL _cosx, _siny
   129E F6 C9 15      [ 5] 1200                  LDB           _siny
   12A1 B6 C9 12      [ 5] 1201                  LDA           _cosx
   12A4 2A 07         [ 3] 1202                  BPL           mul_Ap30
   12A6 40            [ 2] 1203                  NEGA
   12A7 5D            [ 2] 1204                  TSTB
   12A8 2A 07         [ 3] 1205                  BPL           mul_An_Bp30
   12AA 50            [ 2] 1206                  NEGB
   12AB 20 09         [ 3] 1207                  BRA           mul_An_Bn30
                           1208  .globl mul_Ap30
   12AD                    1209 mul_Ap30:
   12AD 5D            [ 2] 1210                  TSTB
   12AE 2A 06         [ 3] 1211                  BPL           mul_Ap_Bp30
   12B0 50            [ 2] 1212                  NEGB
                           1213  .globl mul_An_Bp30
   12B1                    1214 mul_An_Bp30:
   12B1 3D            [11] 1215                  MUL
   12B2 53            [ 2] 1216                  COMB                              ; here we can use this as negd
   12B3 43            [ 2] 1217                  COMA                              ; since the low nibble of b doesn't interest us
   12B4 20 01         [ 3] 1218                  BRA           mul_end30
                           1219  .globl mul_Ap_Bp30
   12B6                    1220 mul_Ap_Bp30:
                           1221  .globl mul_An_Bn30
   12B6                    1222 mul_An_Bn30:
   12B6 3D            [11] 1223                  MUL
                           1224  .globl mul_end30
   12B7                    1225 mul_end30:
   12B7 58            [ 2] 1226                  ASLB                              ; this divides d by 64
   12B8 49            [ 2] 1227                  ROLA
   12B9 58            [ 2] 1228                  ASLB
   12BA 49            [ 2] 1229                  ROLA
                           1230 
   12BB BB C9 14      [ 5] 1231                  ADDA  _cosy
                           1232 ; macro call ->                  STORE_A _110x
   12BE B7 C9 25      [ 5] 1233                  STA           _110x
                           1234 ; macro call ->                  A_EQUALS_MUL _helper, _cosz
   12C1 F6 C9 16      [ 5] 1235                  LDB           _cosz
   12C4 B6 C9 11      [ 5] 1236                  LDA           _helper
   12C7 2A 07         [ 3] 1237                  BPL           mul_Ap32
   12C9 40            [ 2] 1238                  NEGA
   12CA 5D            [ 2] 1239                  TSTB
   12CB 2A 07         [ 3] 1240                  BPL           mul_An_Bp32
   12CD 50            [ 2] 1241                  NEGB
   12CE 20 09         [ 3] 1242                  BRA           mul_An_Bn32
                           1243  .globl mul_Ap32
   12D0                    1244 mul_Ap32:
   12D0 5D            [ 2] 1245                  TSTB
   12D1 2A 06         [ 3] 1246                  BPL           mul_Ap_Bp32
   12D3 50            [ 2] 1247                  NEGB
                           1248  .globl mul_An_Bp32
   12D4                    1249 mul_An_Bp32:
   12D4 3D            [11] 1250                  MUL
   12D5 53            [ 2] 1251                  COMB                              ; here we can use this as negd
   12D6 43            [ 2] 1252                  COMA                              ; since the low nibble of b doesn't interest us
   12D7 20 01         [ 3] 1253                  BRA           mul_end32
                           1254  .globl mul_Ap_Bp32
   12D9                    1255 mul_Ap_Bp32:
                           1256  .globl mul_An_Bn32
   12D9                    1257 mul_An_Bn32:
   12D9 3D            [11] 1258                  MUL
                           1259  .globl mul_end32
   12DA                    1260 mul_end32:
   12DA 58            [ 2] 1261                  ASLB                              ; this divides d by 64
   12DB 49            [ 2] 1262                  ROLA
   12DC 58            [ 2] 1263                  ASLB
   12DD 49            [ 2] 1264                  ROLA
                           1265 
                           1266 ; macro call ->                  STORE_A _110y
   12DE B7 C9 26      [ 5] 1267                  STA           _110y
                           1268 ; macro call ->                  A_EQUALS_MUL _110x, _sinz
   12E1 F6 C9 17      [ 5] 1269                  LDB           _sinz
   12E4 B6 C9 25      [ 5] 1270                  LDA           _110x
   12E7 2A 07         [ 3] 1271                  BPL           mul_Ap34
   12E9 40            [ 2] 1272                  NEGA
   12EA 5D            [ 2] 1273                  TSTB
   12EB 2A 07         [ 3] 1274                  BPL           mul_An_Bp34
   12ED 50            [ 2] 1275                  NEGB
   12EE 20 09         [ 3] 1276                  BRA           mul_An_Bn34
                           1277  .globl mul_Ap34
   12F0                    1278 mul_Ap34:
   12F0 5D            [ 2] 1279                  TSTB
   12F1 2A 06         [ 3] 1280                  BPL           mul_Ap_Bp34
   12F3 50            [ 2] 1281                  NEGB
                           1282  .globl mul_An_Bp34
   12F4                    1283 mul_An_Bp34:
   12F4 3D            [11] 1284                  MUL
   12F5 53            [ 2] 1285                  COMB                              ; here we can use this as negd
   12F6 43            [ 2] 1286                  COMA                              ; since the low nibble of b doesn't interest us
   12F7 20 01         [ 3] 1287                  BRA           mul_end34
                           1288  .globl mul_Ap_Bp34
   12F9                    1289 mul_Ap_Bp34:
                           1290  .globl mul_An_Bn34
   12F9                    1291 mul_An_Bn34:
   12F9 3D            [11] 1292                  MUL
                           1293  .globl mul_end34
   12FA                    1294 mul_end34:
   12FA 58            [ 2] 1295                  ASLB                              ; this divides d by 64
   12FB 49            [ 2] 1296                  ROLA
   12FC 58            [ 2] 1297                  ASLB
   12FD 49            [ 2] 1298                  ROLA
                           1299 
                           1300 ; macro call ->                  ADD_A_TO _110y
   12FE BB C9 26      [ 5] 1301                  ADDA          _110y
                           1302 ; macro call ->                  STORE_A       _110y
   1301 B7 C9 26      [ 5] 1303                  STA           _110y
                           1304 ; macro call ->                  STORE_A_NEG _110yi
   1304 40            [ 2] 1305                  NEGA
   1305 B7 C9 50      [ 5] 1306                  STA           _110yi
                           1307 ; macro call ->                  A_EQUALS_MUL _110x, _cosz
   1308 F6 C9 16      [ 5] 1308                  LDB           _cosz
   130B B6 C9 25      [ 5] 1309                  LDA           _110x
   130E 2A 07         [ 3] 1310                  BPL           mul_Ap38
   1310 40            [ 2] 1311                  NEGA
   1311 5D            [ 2] 1312                  TSTB
   1312 2A 07         [ 3] 1313                  BPL           mul_An_Bp38
   1314 50            [ 2] 1314                  NEGB
   1315 20 09         [ 3] 1315                  BRA           mul_An_Bn38
                           1316  .globl mul_Ap38
   1317                    1317 mul_Ap38:
   1317 5D            [ 2] 1318                  TSTB
   1318 2A 06         [ 3] 1319                  BPL           mul_Ap_Bp38
   131A 50            [ 2] 1320                  NEGB
                           1321  .globl mul_An_Bp38
   131B                    1322 mul_An_Bp38:
   131B 3D            [11] 1323                  MUL
   131C 53            [ 2] 1324                  COMB                              ; here we can use this as negd
   131D 43            [ 2] 1325                  COMA                              ; since the low nibble of b doesn't interest us
   131E 20 01         [ 3] 1326                  BRA           mul_end38
                           1327  .globl mul_Ap_Bp38
   1320                    1328 mul_Ap_Bp38:
                           1329  .globl mul_An_Bn38
   1320                    1330 mul_An_Bn38:
   1320 3D            [11] 1331                  MUL
                           1332  .globl mul_end38
   1321                    1333 mul_end38:
   1321 58            [ 2] 1334                  ASLB                              ; this divides d by 64
   1322 49            [ 2] 1335                  ROLA
   1323 58            [ 2] 1336                  ASLB
   1324 49            [ 2] 1337                  ROLA
                           1338 
                           1339 ; macro call ->                  STORE_A _110x
   1325 B7 C9 25      [ 5] 1340                  STA           _110x
                           1341 ; macro call ->                  A_EQUALS_MUL _helper, _sinz
   1328 F6 C9 17      [ 5] 1342                  LDB           _sinz
   132B B6 C9 11      [ 5] 1343                  LDA           _helper
   132E 2A 07         [ 3] 1344                  BPL           mul_Ap40
   1330 40            [ 2] 1345                  NEGA
   1331 5D            [ 2] 1346                  TSTB
   1332 2A 07         [ 3] 1347                  BPL           mul_An_Bp40
   1334 50            [ 2] 1348                  NEGB
   1335 20 09         [ 3] 1349                  BRA           mul_An_Bn40
                           1350  .globl mul_Ap40
   1337                    1351 mul_Ap40:
   1337 5D            [ 2] 1352                  TSTB
   1338 2A 06         [ 3] 1353                  BPL           mul_Ap_Bp40
   133A 50            [ 2] 1354                  NEGB
                           1355  .globl mul_An_Bp40
   133B                    1356 mul_An_Bp40:
   133B 3D            [11] 1357                  MUL
   133C 53            [ 2] 1358                  COMB                              ; here we can use this as negd
   133D 43            [ 2] 1359                  COMA                              ; since the low nibble of b doesn't interest us
   133E 20 01         [ 3] 1360                  BRA           mul_end40
                           1361  .globl mul_Ap_Bp40
   1340                    1362 mul_Ap_Bp40:
                           1363  .globl mul_An_Bn40
   1340                    1364 mul_An_Bn40:
   1340 3D            [11] 1365                  MUL
                           1366  .globl mul_end40
   1341                    1367 mul_end40:
   1341 58            [ 2] 1368                  ASLB                              ; this divides d by 64
   1342 49            [ 2] 1369                  ROLA
   1343 58            [ 2] 1370                  ASLB
   1344 49            [ 2] 1371                  ROLA
                           1372 
                           1373 ; macro call ->                  SUB_A_FROM _110x
   1345 40            [ 2] 1374                  NEGA
                           1375 ; macro call ->                  ADD_A_TO      _110x
   1346 BB C9 25      [ 5] 1376                  ADDA          _110x
                           1377 ; macro call ->                  STORE_A       _110x
   1349 B7 C9 25      [ 5] 1378                  STA           _110x
                           1379 ; macro call ->                  STORE_A_NEG _110xi
   134C 40            [ 2] 1380                  NEGA
   134D B7 C9 4F      [ 5] 1381                  STA           _110xi
                           1382  .globl no1102d
   1350                    1383 no1102d:
   1350 B6 C9 1B      [ 5] 1384  lda _vectorBits
   1353 85 01         [ 2] 1385  bita #TEST_N_1_0
   1355 10 27 00 B9   [ 6] 1386  lbeq noN102d
                           1387 ; macro call ->                     INIT_N_1_0_A  
                           1388 ; macro call ->                  CALC_N_1_0_A _N10x, _N10y, _N10z, _N10xi, _N10yi, _N10zi
   1359 B6 C9 13      [ 5] 1389                  LDA   _sinx
   135C 40            [ 2] 1390                  NEGA
   135D B7 C9 11      [ 5] 1391                  STA   _helper
                           1392 ; macro call ->                  A_EQUALS_MUL _cosx, _siny
   1360 F6 C9 15      [ 5] 1393                  LDB           _siny
   1363 B6 C9 12      [ 5] 1394                  LDA           _cosx
   1366 2A 07         [ 3] 1395                  BPL           mul_Ap47
   1368 40            [ 2] 1396                  NEGA
   1369 5D            [ 2] 1397                  TSTB
   136A 2A 07         [ 3] 1398                  BPL           mul_An_Bp47
   136C 50            [ 2] 1399                  NEGB
   136D 20 09         [ 3] 1400                  BRA           mul_An_Bn47
                           1401  .globl mul_Ap47
   136F                    1402 mul_Ap47:
   136F 5D            [ 2] 1403                  TSTB
   1370 2A 06         [ 3] 1404                  BPL           mul_Ap_Bp47
   1372 50            [ 2] 1405                  NEGB
                           1406  .globl mul_An_Bp47
   1373                    1407 mul_An_Bp47:
   1373 3D            [11] 1408                  MUL
   1374 53            [ 2] 1409                  COMB                              ; here we can use this as negd
   1375 43            [ 2] 1410                  COMA                              ; since the low nibble of b doesn't interest us
   1376 20 01         [ 3] 1411                  BRA           mul_end47
                           1412  .globl mul_Ap_Bp47
   1378                    1413 mul_Ap_Bp47:
                           1414  .globl mul_An_Bn47
   1378                    1415 mul_An_Bn47:
   1378 3D            [11] 1416                  MUL
                           1417  .globl mul_end47
   1379                    1418 mul_end47:
   1379 58            [ 2] 1419                  ASLB                              ; this divides d by 64
   137A 49            [ 2] 1420                  ROLA
   137B 58            [ 2] 1421                  ASLB
   137C 49            [ 2] 1422                  ROLA
                           1423 
   137D B0 C9 14      [ 5] 1424                  SUBA  _cosy
                           1425 ; macro call ->                  STORE_A _N10x
   1380 B7 C9 37      [ 5] 1426                  STA           _N10x
                           1427 ; macro call ->                  A_EQUALS_MUL _helper, _cosz
   1383 F6 C9 16      [ 5] 1428                  LDB           _cosz
   1386 B6 C9 11      [ 5] 1429                  LDA           _helper
   1389 2A 07         [ 3] 1430                  BPL           mul_Ap49
   138B 40            [ 2] 1431                  NEGA
   138C 5D            [ 2] 1432                  TSTB
   138D 2A 07         [ 3] 1433                  BPL           mul_An_Bp49
   138F 50            [ 2] 1434                  NEGB
   1390 20 09         [ 3] 1435                  BRA           mul_An_Bn49
                           1436  .globl mul_Ap49
   1392                    1437 mul_Ap49:
   1392 5D            [ 2] 1438                  TSTB
   1393 2A 06         [ 3] 1439                  BPL           mul_Ap_Bp49
   1395 50            [ 2] 1440                  NEGB
                           1441  .globl mul_An_Bp49
   1396                    1442 mul_An_Bp49:
   1396 3D            [11] 1443                  MUL
   1397 53            [ 2] 1444                  COMB                              ; here we can use this as negd
   1398 43            [ 2] 1445                  COMA                              ; since the low nibble of b doesn't interest us
   1399 20 01         [ 3] 1446                  BRA           mul_end49
                           1447  .globl mul_Ap_Bp49
   139B                    1448 mul_Ap_Bp49:
                           1449  .globl mul_An_Bn49
   139B                    1450 mul_An_Bn49:
   139B 3D            [11] 1451                  MUL
                           1452  .globl mul_end49
   139C                    1453 mul_end49:
   139C 58            [ 2] 1454                  ASLB                              ; this divides d by 64
   139D 49            [ 2] 1455                  ROLA
   139E 58            [ 2] 1456                  ASLB
   139F 49            [ 2] 1457                  ROLA
                           1458 
                           1459 ; macro call ->                  STORE_A _N10y
   13A0 B7 C9 38      [ 5] 1460                  STA           _N10y
                           1461 ; macro call ->                  A_EQUALS_MUL _N10x, _sinz
   13A3 F6 C9 17      [ 5] 1462                  LDB           _sinz
   13A6 B6 C9 37      [ 5] 1463                  LDA           _N10x
   13A9 2A 07         [ 3] 1464                  BPL           mul_Ap51
   13AB 40            [ 2] 1465                  NEGA
   13AC 5D            [ 2] 1466                  TSTB
   13AD 2A 07         [ 3] 1467                  BPL           mul_An_Bp51
   13AF 50            [ 2] 1468                  NEGB
   13B0 20 09         [ 3] 1469                  BRA           mul_An_Bn51
                           1470  .globl mul_Ap51
   13B2                    1471 mul_Ap51:
   13B2 5D            [ 2] 1472                  TSTB
   13B3 2A 06         [ 3] 1473                  BPL           mul_Ap_Bp51
   13B5 50            [ 2] 1474                  NEGB
                           1475  .globl mul_An_Bp51
   13B6                    1476 mul_An_Bp51:
   13B6 3D            [11] 1477                  MUL
   13B7 53            [ 2] 1478                  COMB                              ; here we can use this as negd
   13B8 43            [ 2] 1479                  COMA                              ; since the low nibble of b doesn't interest us
   13B9 20 01         [ 3] 1480                  BRA           mul_end51
                           1481  .globl mul_Ap_Bp51
   13BB                    1482 mul_Ap_Bp51:
                           1483  .globl mul_An_Bn51
   13BB                    1484 mul_An_Bn51:
   13BB 3D            [11] 1485                  MUL
                           1486  .globl mul_end51
   13BC                    1487 mul_end51:
   13BC 58            [ 2] 1488                  ASLB                              ; this divides d by 64
   13BD 49            [ 2] 1489                  ROLA
   13BE 58            [ 2] 1490                  ASLB
   13BF 49            [ 2] 1491                  ROLA
                           1492 
                           1493 ; macro call ->                  ADD_A_TO _N10y
   13C0 BB C9 38      [ 5] 1494                  ADDA          _N10y
                           1495 ; macro call ->                  STORE_A       _N10y
   13C3 B7 C9 38      [ 5] 1496                  STA           _N10y
                           1497 ; macro call ->                  STORE_A_NEG _N10yi
   13C6 40            [ 2] 1498                  NEGA
   13C7 B7 C9 62      [ 5] 1499                  STA           _N10yi
                           1500 ; macro call ->                  A_EQUALS_MUL _N10x, _cosz
   13CA F6 C9 16      [ 5] 1501                  LDB           _cosz
   13CD B6 C9 37      [ 5] 1502                  LDA           _N10x
   13D0 2A 07         [ 3] 1503                  BPL           mul_Ap55
   13D2 40            [ 2] 1504                  NEGA
   13D3 5D            [ 2] 1505                  TSTB
   13D4 2A 07         [ 3] 1506                  BPL           mul_An_Bp55
   13D6 50            [ 2] 1507                  NEGB
   13D7 20 09         [ 3] 1508                  BRA           mul_An_Bn55
                           1509  .globl mul_Ap55
   13D9                    1510 mul_Ap55:
   13D9 5D            [ 2] 1511                  TSTB
   13DA 2A 06         [ 3] 1512                  BPL           mul_Ap_Bp55
   13DC 50            [ 2] 1513                  NEGB
                           1514  .globl mul_An_Bp55
   13DD                    1515 mul_An_Bp55:
   13DD 3D            [11] 1516                  MUL
   13DE 53            [ 2] 1517                  COMB                              ; here we can use this as negd
   13DF 43            [ 2] 1518                  COMA                              ; since the low nibble of b doesn't interest us
   13E0 20 01         [ 3] 1519                  BRA           mul_end55
                           1520  .globl mul_Ap_Bp55
   13E2                    1521 mul_Ap_Bp55:
                           1522  .globl mul_An_Bn55
   13E2                    1523 mul_An_Bn55:
   13E2 3D            [11] 1524                  MUL
                           1525  .globl mul_end55
   13E3                    1526 mul_end55:
   13E3 58            [ 2] 1527                  ASLB                              ; this divides d by 64
   13E4 49            [ 2] 1528                  ROLA
   13E5 58            [ 2] 1529                  ASLB
   13E6 49            [ 2] 1530                  ROLA
                           1531 
                           1532 ; macro call ->                  STORE_A _N10x
   13E7 B7 C9 37      [ 5] 1533                  STA           _N10x
                           1534 ; macro call ->                  A_EQUALS_MUL _helper, _sinz
   13EA F6 C9 17      [ 5] 1535                  LDB           _sinz
   13ED B6 C9 11      [ 5] 1536                  LDA           _helper
   13F0 2A 07         [ 3] 1537                  BPL           mul_Ap57
   13F2 40            [ 2] 1538                  NEGA
   13F3 5D            [ 2] 1539                  TSTB
   13F4 2A 07         [ 3] 1540                  BPL           mul_An_Bp57
   13F6 50            [ 2] 1541                  NEGB
   13F7 20 09         [ 3] 1542                  BRA           mul_An_Bn57
                           1543  .globl mul_Ap57
   13F9                    1544 mul_Ap57:
   13F9 5D            [ 2] 1545                  TSTB
   13FA 2A 06         [ 3] 1546                  BPL           mul_Ap_Bp57
   13FC 50            [ 2] 1547                  NEGB
                           1548  .globl mul_An_Bp57
   13FD                    1549 mul_An_Bp57:
   13FD 3D            [11] 1550                  MUL
   13FE 53            [ 2] 1551                  COMB                              ; here we can use this as negd
   13FF 43            [ 2] 1552                  COMA                              ; since the low nibble of b doesn't interest us
   1400 20 01         [ 3] 1553                  BRA           mul_end57
                           1554  .globl mul_Ap_Bp57
   1402                    1555 mul_Ap_Bp57:
                           1556  .globl mul_An_Bn57
   1402                    1557 mul_An_Bn57:
   1402 3D            [11] 1558                  MUL
                           1559  .globl mul_end57
   1403                    1560 mul_end57:
   1403 58            [ 2] 1561                  ASLB                              ; this divides d by 64
   1404 49            [ 2] 1562                  ROLA
   1405 58            [ 2] 1563                  ASLB
   1406 49            [ 2] 1564                  ROLA
                           1565 
                           1566 ; macro call ->                  SUB_A_FROM _N10x
   1407 40            [ 2] 1567                  NEGA
                           1568 ; macro call ->                  ADD_A_TO      _N10x
   1408 BB C9 37      [ 5] 1569                  ADDA          _N10x
                           1570 ; macro call ->                  STORE_A       _N10x
   140B B7 C9 37      [ 5] 1571                  STA           _N10x
                           1572 ; macro call ->                  STORE_A_NEG _N10xi
   140E 40            [ 2] 1573                  NEGA
   140F B7 C9 61      [ 5] 1574                  STA           _N10xi
                           1575  .globl noN102d
   1412                    1576 noN102d:
   1412 39            [ 5] 1577                     RTS     
                           1578 
                           1579 
                           1580 
                           1581  .globl init_all
   1413                    1582 init_all:
   1413 8E 10 C6      [ 3] 1583                     LDX      #_cosinus3d 
   1416 CE 11 06      [ 3] 1584                     LDU      #_sinus3d 
   1419 F6 C9 18      [ 5] 1585                     LDB      _angle_x 
   141C A6 85         [ 5] 1586                     LDA      B, X 
   141E B7 C9 12      [ 5] 1587                     STA      _cosx 
   1421 A6 C5         [ 5] 1588                     LDA      B, U 
   1423 B7 C9 13      [ 5] 1589                     STA      _sinx 
   1426 F6 C9 19      [ 5] 1590                     LDB      _angle_y 
   1429 A6 85         [ 5] 1591                     LDA      B, X 
   142B B7 C9 14      [ 5] 1592                     STA      _cosy 
   142E A6 C5         [ 5] 1593                     LDA      B, U 
   1430 B7 C9 15      [ 5] 1594                     STA      _siny 
   1433 F6 C9 1A      [ 5] 1595                     LDB      _angle_z 
   1436 A6 85         [ 5] 1596                     LDA      B, X 
   1438 B7 C9 16      [ 5] 1597                     STA      _cosz 
   143B A6 C5         [ 5] 1598                     LDA      B, U 
   143D B7 C9 17      [ 5] 1599                     STA      _sinz 
                           1600 
                     0001  1601 DO_Z_KOORDINATE = 1
                           1602 
   1440 B6 C9 1C      [ 5] 1603  lda _vectorBits+1
   1443 85 01         [ 2] 1604  bita #TEST_0_0_0
   1445 27 16         [ 3] 1605  beq no000
                           1606 ; macro call ->                     INIT_0_0_0_A  
                           1607 ; macro call ->                  CALC_0_0_0_A _000x, _000y, _000z, _000xi, _000yi, _000zi
   1447 4F            [ 2] 1608                  CLRA
   1448 B7 C9 1F      [ 5] 1609                  STA           _000x
   144B B7 C9 20      [ 5] 1610                  STA           _000y
   144E B7 C9 49      [ 5] 1611                  STA           _000xi
   1451 B7 C9 4A      [ 5] 1612                  STA           _000yi
   1454 B7 C9 21      [ 5] 1613                  STA _000z
   1457 B7 C9 4B      [ 5] 1614                  STA _000zi
   145A B6 C9 1C      [ 5] 1615  lda _vectorBits+1
                           1616  .globl no000
   145D                    1617 no000:
   145D 85 02         [ 2] 1618  bita #TEST_1_0_0
   145F 27 52         [ 3] 1619  beq no100
                           1620 ; macro call ->                     INIT_1_0_0_A  
                           1621 ; macro call ->                  CALC_1_0_0_A _100x, _100y, _100z, _100xi, _100yi, _100zi
   1461 4F            [ 2] 1622                  CLRA
   1462 B7 C9 24      [ 5] 1623                  STA _100z
   1465 B7 C9 4E      [ 5] 1624                  STA _100zi
                           1625 ; macro call ->                  A_EQUALS_MUL _cosy, _sinz
   1468 F6 C9 17      [ 5] 1626                  LDB           _sinz
   146B B6 C9 14      [ 5] 1627                  LDA           _cosy
   146E 2A 07         [ 3] 1628                  BPL           mul_Ap66
   1470 40            [ 2] 1629                  NEGA
   1471 5D            [ 2] 1630                  TSTB
   1472 2A 07         [ 3] 1631                  BPL           mul_An_Bp66
   1474 50            [ 2] 1632                  NEGB
   1475 20 09         [ 3] 1633                  BRA           mul_An_Bn66
                           1634  .globl mul_Ap66
   1477                    1635 mul_Ap66:
   1477 5D            [ 2] 1636                  TSTB
   1478 2A 06         [ 3] 1637                  BPL           mul_Ap_Bp66
   147A 50            [ 2] 1638                  NEGB
                           1639  .globl mul_An_Bp66
   147B                    1640 mul_An_Bp66:
   147B 3D            [11] 1641                  MUL
   147C 53            [ 2] 1642                  COMB                              ; here we can use this as negd
   147D 43            [ 2] 1643                  COMA                              ; since the low nibble of b doesn't interest us
   147E 20 01         [ 3] 1644                  BRA           mul_end66
                           1645  .globl mul_Ap_Bp66
   1480                    1646 mul_Ap_Bp66:
                           1647  .globl mul_An_Bn66
   1480                    1648 mul_An_Bn66:
   1480 3D            [11] 1649                  MUL
                           1650  .globl mul_end66
   1481                    1651 mul_end66:
   1481 58            [ 2] 1652                  ASLB                              ; this divides d by 64
   1482 49            [ 2] 1653                  ROLA
   1483 58            [ 2] 1654                  ASLB
   1484 49            [ 2] 1655                  ROLA
                           1656 
                           1657 ; macro call ->                  STORE_A _100y
   1485 B7 C9 23      [ 5] 1658                  STA           _100y
                           1659 ; macro call ->                  STORE_A_NEG _100yi
   1488 40            [ 2] 1660                  NEGA
   1489 B7 C9 4D      [ 5] 1661                  STA           _100yi
                           1662 ; macro call ->                  A_EQUALS_MUL _cosy, _cosz
   148C F6 C9 16      [ 5] 1663                  LDB           _cosz
   148F B6 C9 14      [ 5] 1664                  LDA           _cosy
   1492 2A 07         [ 3] 1665                  BPL           mul_Ap69
   1494 40            [ 2] 1666                  NEGA
   1495 5D            [ 2] 1667                  TSTB
   1496 2A 07         [ 3] 1668                  BPL           mul_An_Bp69
   1498 50            [ 2] 1669                  NEGB
   1499 20 09         [ 3] 1670                  BRA           mul_An_Bn69
                           1671  .globl mul_Ap69
   149B                    1672 mul_Ap69:
   149B 5D            [ 2] 1673                  TSTB
   149C 2A 06         [ 3] 1674                  BPL           mul_Ap_Bp69
   149E 50            [ 2] 1675                  NEGB
                           1676  .globl mul_An_Bp69
   149F                    1677 mul_An_Bp69:
   149F 3D            [11] 1678                  MUL
   14A0 53            [ 2] 1679                  COMB                              ; here we can use this as negd
   14A1 43            [ 2] 1680                  COMA                              ; since the low nibble of b doesn't interest us
   14A2 20 01         [ 3] 1681                  BRA           mul_end69
                           1682  .globl mul_Ap_Bp69
   14A4                    1683 mul_Ap_Bp69:
                           1684  .globl mul_An_Bn69
   14A4                    1685 mul_An_Bn69:
   14A4 3D            [11] 1686                  MUL
                           1687  .globl mul_end69
   14A5                    1688 mul_end69:
   14A5 58            [ 2] 1689                  ASLB                              ; this divides d by 64
   14A6 49            [ 2] 1690                  ROLA
   14A7 58            [ 2] 1691                  ASLB
   14A8 49            [ 2] 1692                  ROLA
                           1693 
                           1694 ; macro call ->                  STORE_A _100x
   14A9 B7 C9 22      [ 5] 1695                  STA           _100x
                           1696 ; macro call ->                  STORE_A_NEG _100xi
   14AC 40            [ 2] 1697                  NEGA
   14AD B7 C9 4C      [ 5] 1698                  STA           _100xi
   14B0 B6 C9 1C      [ 5] 1699  lda _vectorBits+1
                           1700  .globl no100
   14B3                    1701 no100:
   14B3 85 04         [ 2] 1702  bita #TEST_1_1_0
   14B5 10 27 00 C6   [ 6] 1703  lbeq no110
                           1704 ; macro call ->                     INIT_1_1_0_A  
                           1705 ; macro call ->                  CALC_1_1_0_A _110x, _110y, _110z, _110xi, _110yi, _110zi
   14B9 B6 C9 12      [ 5] 1706                  LDA _cosx
   14BC B7 C9 27      [ 5] 1707                  STA _110z
   14BF 40            [ 2] 1708                  NEGA
   14C0 B7 C9 51      [ 5] 1709                  STA _110zi
   14C3 B6 C9 13      [ 5] 1710                  LDA   _sinx
   14C6 40            [ 2] 1711                  NEGA
   14C7 B7 C9 11      [ 5] 1712                  STA   _helper
                           1713 ; macro call ->                  A_EQUALS_MUL _cosx, _siny
   14CA F6 C9 15      [ 5] 1714                  LDB           _siny
   14CD B6 C9 12      [ 5] 1715                  LDA           _cosx
   14D0 2A 07         [ 3] 1716                  BPL           mul_Ap74
   14D2 40            [ 2] 1717                  NEGA
   14D3 5D            [ 2] 1718                  TSTB
   14D4 2A 07         [ 3] 1719                  BPL           mul_An_Bp74
   14D6 50            [ 2] 1720                  NEGB
   14D7 20 09         [ 3] 1721                  BRA           mul_An_Bn74
                           1722  .globl mul_Ap74
   14D9                    1723 mul_Ap74:
   14D9 5D            [ 2] 1724                  TSTB
   14DA 2A 06         [ 3] 1725                  BPL           mul_Ap_Bp74
   14DC 50            [ 2] 1726                  NEGB
                           1727  .globl mul_An_Bp74
   14DD                    1728 mul_An_Bp74:
   14DD 3D            [11] 1729                  MUL
   14DE 53            [ 2] 1730                  COMB                              ; here we can use this as negd
   14DF 43            [ 2] 1731                  COMA                              ; since the low nibble of b doesn't interest us
   14E0 20 01         [ 3] 1732                  BRA           mul_end74
                           1733  .globl mul_Ap_Bp74
   14E2                    1734 mul_Ap_Bp74:
                           1735  .globl mul_An_Bn74
   14E2                    1736 mul_An_Bn74:
   14E2 3D            [11] 1737                  MUL
                           1738  .globl mul_end74
   14E3                    1739 mul_end74:
   14E3 58            [ 2] 1740                  ASLB                              ; this divides d by 64
   14E4 49            [ 2] 1741                  ROLA
   14E5 58            [ 2] 1742                  ASLB
   14E6 49            [ 2] 1743                  ROLA
                           1744 
   14E7 BB C9 14      [ 5] 1745                  ADDA  _cosy
                           1746 ; macro call ->                  STORE_A _110x
   14EA B7 C9 25      [ 5] 1747                  STA           _110x
                           1748 ; macro call ->                  A_EQUALS_MUL _helper, _cosz
   14ED F6 C9 16      [ 5] 1749                  LDB           _cosz
   14F0 B6 C9 11      [ 5] 1750                  LDA           _helper
   14F3 2A 07         [ 3] 1751                  BPL           mul_Ap76
   14F5 40            [ 2] 1752                  NEGA
   14F6 5D            [ 2] 1753                  TSTB
   14F7 2A 07         [ 3] 1754                  BPL           mul_An_Bp76
   14F9 50            [ 2] 1755                  NEGB
   14FA 20 09         [ 3] 1756                  BRA           mul_An_Bn76
                           1757  .globl mul_Ap76
   14FC                    1758 mul_Ap76:
   14FC 5D            [ 2] 1759                  TSTB
   14FD 2A 06         [ 3] 1760                  BPL           mul_Ap_Bp76
   14FF 50            [ 2] 1761                  NEGB
                           1762  .globl mul_An_Bp76
   1500                    1763 mul_An_Bp76:
   1500 3D            [11] 1764                  MUL
   1501 53            [ 2] 1765                  COMB                              ; here we can use this as negd
   1502 43            [ 2] 1766                  COMA                              ; since the low nibble of b doesn't interest us
   1503 20 01         [ 3] 1767                  BRA           mul_end76
                           1768  .globl mul_Ap_Bp76
   1505                    1769 mul_Ap_Bp76:
                           1770  .globl mul_An_Bn76
   1505                    1771 mul_An_Bn76:
   1505 3D            [11] 1772                  MUL
                           1773  .globl mul_end76
   1506                    1774 mul_end76:
   1506 58            [ 2] 1775                  ASLB                              ; this divides d by 64
   1507 49            [ 2] 1776                  ROLA
   1508 58            [ 2] 1777                  ASLB
   1509 49            [ 2] 1778                  ROLA
                           1779 
                           1780 ; macro call ->                  STORE_A _110y
   150A B7 C9 26      [ 5] 1781                  STA           _110y
                           1782 ; macro call ->                  A_EQUALS_MUL _110x, _sinz
   150D F6 C9 17      [ 5] 1783                  LDB           _sinz
   1510 B6 C9 25      [ 5] 1784                  LDA           _110x
   1513 2A 07         [ 3] 1785                  BPL           mul_Ap78
   1515 40            [ 2] 1786                  NEGA
   1516 5D            [ 2] 1787                  TSTB
   1517 2A 07         [ 3] 1788                  BPL           mul_An_Bp78
   1519 50            [ 2] 1789                  NEGB
   151A 20 09         [ 3] 1790                  BRA           mul_An_Bn78
                           1791  .globl mul_Ap78
   151C                    1792 mul_Ap78:
   151C 5D            [ 2] 1793                  TSTB
   151D 2A 06         [ 3] 1794                  BPL           mul_Ap_Bp78
   151F 50            [ 2] 1795                  NEGB
                           1796  .globl mul_An_Bp78
   1520                    1797 mul_An_Bp78:
   1520 3D            [11] 1798                  MUL
   1521 53            [ 2] 1799                  COMB                              ; here we can use this as negd
   1522 43            [ 2] 1800                  COMA                              ; since the low nibble of b doesn't interest us
   1523 20 01         [ 3] 1801                  BRA           mul_end78
                           1802  .globl mul_Ap_Bp78
   1525                    1803 mul_Ap_Bp78:
                           1804  .globl mul_An_Bn78
   1525                    1805 mul_An_Bn78:
   1525 3D            [11] 1806                  MUL
                           1807  .globl mul_end78
   1526                    1808 mul_end78:
   1526 58            [ 2] 1809                  ASLB                              ; this divides d by 64
   1527 49            [ 2] 1810                  ROLA
   1528 58            [ 2] 1811                  ASLB
   1529 49            [ 2] 1812                  ROLA
                           1813 
                           1814 ; macro call ->                  ADD_A_TO _110y
   152A BB C9 26      [ 5] 1815                  ADDA          _110y
                           1816 ; macro call ->                  STORE_A       _110y
   152D B7 C9 26      [ 5] 1817                  STA           _110y
                           1818 ; macro call ->                  STORE_A_NEG _110yi
   1530 40            [ 2] 1819                  NEGA
   1531 B7 C9 50      [ 5] 1820                  STA           _110yi
                           1821 ; macro call ->                  A_EQUALS_MUL _110x, _cosz
   1534 F6 C9 16      [ 5] 1822                  LDB           _cosz
   1537 B6 C9 25      [ 5] 1823                  LDA           _110x
   153A 2A 07         [ 3] 1824                  BPL           mul_Ap82
   153C 40            [ 2] 1825                  NEGA
   153D 5D            [ 2] 1826                  TSTB
   153E 2A 07         [ 3] 1827                  BPL           mul_An_Bp82
   1540 50            [ 2] 1828                  NEGB
   1541 20 09         [ 3] 1829                  BRA           mul_An_Bn82
                           1830  .globl mul_Ap82
   1543                    1831 mul_Ap82:
   1543 5D            [ 2] 1832                  TSTB
   1544 2A 06         [ 3] 1833                  BPL           mul_Ap_Bp82
   1546 50            [ 2] 1834                  NEGB
                           1835  .globl mul_An_Bp82
   1547                    1836 mul_An_Bp82:
   1547 3D            [11] 1837                  MUL
   1548 53            [ 2] 1838                  COMB                              ; here we can use this as negd
   1549 43            [ 2] 1839                  COMA                              ; since the low nibble of b doesn't interest us
   154A 20 01         [ 3] 1840                  BRA           mul_end82
                           1841  .globl mul_Ap_Bp82
   154C                    1842 mul_Ap_Bp82:
                           1843  .globl mul_An_Bn82
   154C                    1844 mul_An_Bn82:
   154C 3D            [11] 1845                  MUL
                           1846  .globl mul_end82
   154D                    1847 mul_end82:
   154D 58            [ 2] 1848                  ASLB                              ; this divides d by 64
   154E 49            [ 2] 1849                  ROLA
   154F 58            [ 2] 1850                  ASLB
   1550 49            [ 2] 1851                  ROLA
                           1852 
                           1853 ; macro call ->                  STORE_A _110x
   1551 B7 C9 25      [ 5] 1854                  STA           _110x
                           1855 ; macro call ->                  A_EQUALS_MUL _helper, _sinz
   1554 F6 C9 17      [ 5] 1856                  LDB           _sinz
   1557 B6 C9 11      [ 5] 1857                  LDA           _helper
   155A 2A 07         [ 3] 1858                  BPL           mul_Ap84
   155C 40            [ 2] 1859                  NEGA
   155D 5D            [ 2] 1860                  TSTB
   155E 2A 07         [ 3] 1861                  BPL           mul_An_Bp84
   1560 50            [ 2] 1862                  NEGB
   1561 20 09         [ 3] 1863                  BRA           mul_An_Bn84
                           1864  .globl mul_Ap84
   1563                    1865 mul_Ap84:
   1563 5D            [ 2] 1866                  TSTB
   1564 2A 06         [ 3] 1867                  BPL           mul_Ap_Bp84
   1566 50            [ 2] 1868                  NEGB
                           1869  .globl mul_An_Bp84
   1567                    1870 mul_An_Bp84:
   1567 3D            [11] 1871                  MUL
   1568 53            [ 2] 1872                  COMB                              ; here we can use this as negd
   1569 43            [ 2] 1873                  COMA                              ; since the low nibble of b doesn't interest us
   156A 20 01         [ 3] 1874                  BRA           mul_end84
                           1875  .globl mul_Ap_Bp84
   156C                    1876 mul_Ap_Bp84:
                           1877  .globl mul_An_Bn84
   156C                    1878 mul_An_Bn84:
   156C 3D            [11] 1879                  MUL
                           1880  .globl mul_end84
   156D                    1881 mul_end84:
   156D 58            [ 2] 1882                  ASLB                              ; this divides d by 64
   156E 49            [ 2] 1883                  ROLA
   156F 58            [ 2] 1884                  ASLB
   1570 49            [ 2] 1885                  ROLA
                           1886 
                           1887 ; macro call ->                  SUB_A_FROM _110x
   1571 40            [ 2] 1888                  NEGA
                           1889 ; macro call ->                  ADD_A_TO      _110x
   1572 BB C9 25      [ 5] 1890                  ADDA          _110x
                           1891 ; macro call ->                  STORE_A       _110x
   1575 B7 C9 25      [ 5] 1892                  STA           _110x
                           1893 ; macro call ->                  STORE_A_NEG _110xi
   1578 40            [ 2] 1894                  NEGA
   1579 B7 C9 4F      [ 5] 1895                  STA           _110xi
   157C B6 C9 1C      [ 5] 1896  lda _vectorBits+1
                           1897  .globl no110
   157F                    1898 no110:
   157F 85 08         [ 2] 1899  bita #TEST_1_0_1
   1581 10 27 00 BF   [ 6] 1900  lbeq no101
                           1901 ; macro call ->                     INIT_1_0_1_A  
                           1902 ; macro call ->                  CALC_1_0_1_A _101x, _101y, _101z, _101xi, _101yi, _101zi
   1585 B6 C9 13      [ 5] 1903                  LDA _sinx
   1588 B7 C9 2A      [ 5] 1904                  STA _101z
   158B 40            [ 2] 1905                  NEGA
   158C B7 C9 54      [ 5] 1906                  STA _101zi
                           1907 ; macro call ->                  A_EQUALS_MUL _sinx, _siny
   158F F6 C9 15      [ 5] 1908                  LDB           _siny
   1592 B6 C9 13      [ 5] 1909                  LDA           _sinx
   1595 2A 07         [ 3] 1910                  BPL           mul_Ap91
   1597 40            [ 2] 1911                  NEGA
   1598 5D            [ 2] 1912                  TSTB
   1599 2A 07         [ 3] 1913                  BPL           mul_An_Bp91
   159B 50            [ 2] 1914                  NEGB
   159C 20 09         [ 3] 1915                  BRA           mul_An_Bn91
                           1916  .globl mul_Ap91
   159E                    1917 mul_Ap91:
   159E 5D            [ 2] 1918                  TSTB
   159F 2A 06         [ 3] 1919                  BPL           mul_Ap_Bp91
   15A1 50            [ 2] 1920                  NEGB
                           1921  .globl mul_An_Bp91
   15A2                    1922 mul_An_Bp91:
   15A2 3D            [11] 1923                  MUL
   15A3 53            [ 2] 1924                  COMB                              ; here we can use this as negd
   15A4 43            [ 2] 1925                  COMA                              ; since the low nibble of b doesn't interest us
   15A5 20 01         [ 3] 1926                  BRA           mul_end91
                           1927  .globl mul_Ap_Bp91
   15A7                    1928 mul_Ap_Bp91:
                           1929  .globl mul_An_Bn91
   15A7                    1930 mul_An_Bn91:
   15A7 3D            [11] 1931                  MUL
                           1932  .globl mul_end91
   15A8                    1933 mul_end91:
   15A8 58            [ 2] 1934                  ASLB                              ; this divides d by 64
   15A9 49            [ 2] 1935                  ROLA
   15AA 58            [ 2] 1936                  ASLB
   15AB 49            [ 2] 1937                  ROLA
                           1938 
   15AC BB C9 14      [ 5] 1939                  ADDA   _cosy
                           1940 ; macro call ->                  STORE_A _101x
   15AF B7 C9 28      [ 5] 1941                  STA           _101x
                           1942 ; macro call ->                  A_EQUALS_MUL _cosx, _cosz
   15B2 F6 C9 16      [ 5] 1943                  LDB           _cosz
   15B5 B6 C9 12      [ 5] 1944                  LDA           _cosx
   15B8 2A 07         [ 3] 1945                  BPL           mul_Ap93
   15BA 40            [ 2] 1946                  NEGA
   15BB 5D            [ 2] 1947                  TSTB
   15BC 2A 07         [ 3] 1948                  BPL           mul_An_Bp93
   15BE 50            [ 2] 1949                  NEGB
   15BF 20 09         [ 3] 1950                  BRA           mul_An_Bn93
                           1951  .globl mul_Ap93
   15C1                    1952 mul_Ap93:
   15C1 5D            [ 2] 1953                  TSTB
   15C2 2A 06         [ 3] 1954                  BPL           mul_Ap_Bp93
   15C4 50            [ 2] 1955                  NEGB
                           1956  .globl mul_An_Bp93
   15C5                    1957 mul_An_Bp93:
   15C5 3D            [11] 1958                  MUL
   15C6 53            [ 2] 1959                  COMB                              ; here we can use this as negd
   15C7 43            [ 2] 1960                  COMA                              ; since the low nibble of b doesn't interest us
   15C8 20 01         [ 3] 1961                  BRA           mul_end93
                           1962  .globl mul_Ap_Bp93
   15CA                    1963 mul_Ap_Bp93:
                           1964  .globl mul_An_Bn93
   15CA                    1965 mul_An_Bn93:
   15CA 3D            [11] 1966                  MUL
                           1967  .globl mul_end93
   15CB                    1968 mul_end93:
   15CB 58            [ 2] 1969                  ASLB                              ; this divides d by 64
   15CC 49            [ 2] 1970                  ROLA
   15CD 58            [ 2] 1971                  ASLB
   15CE 49            [ 2] 1972                  ROLA
                           1973 
                           1974 ; macro call ->                  STORE_A _101y
   15CF B7 C9 29      [ 5] 1975                  STA           _101y
                           1976 ; macro call ->                  A_EQUALS_MUL _101x, _sinz
   15D2 F6 C9 17      [ 5] 1977                  LDB           _sinz
   15D5 B6 C9 28      [ 5] 1978                  LDA           _101x
   15D8 2A 07         [ 3] 1979                  BPL           mul_Ap95
   15DA 40            [ 2] 1980                  NEGA
   15DB 5D            [ 2] 1981                  TSTB
   15DC 2A 07         [ 3] 1982                  BPL           mul_An_Bp95
   15DE 50            [ 2] 1983                  NEGB
   15DF 20 09         [ 3] 1984                  BRA           mul_An_Bn95
                           1985  .globl mul_Ap95
   15E1                    1986 mul_Ap95:
   15E1 5D            [ 2] 1987                  TSTB
   15E2 2A 06         [ 3] 1988                  BPL           mul_Ap_Bp95
   15E4 50            [ 2] 1989                  NEGB
                           1990  .globl mul_An_Bp95
   15E5                    1991 mul_An_Bp95:
   15E5 3D            [11] 1992                  MUL
   15E6 53            [ 2] 1993                  COMB                              ; here we can use this as negd
   15E7 43            [ 2] 1994                  COMA                              ; since the low nibble of b doesn't interest us
   15E8 20 01         [ 3] 1995                  BRA           mul_end95
                           1996  .globl mul_Ap_Bp95
   15EA                    1997 mul_Ap_Bp95:
                           1998  .globl mul_An_Bn95
   15EA                    1999 mul_An_Bn95:
   15EA 3D            [11] 2000                  MUL
                           2001  .globl mul_end95
   15EB                    2002 mul_end95:
   15EB 58            [ 2] 2003                  ASLB                              ; this divides d by 64
   15EC 49            [ 2] 2004                  ROLA
   15ED 58            [ 2] 2005                  ASLB
   15EE 49            [ 2] 2006                  ROLA
                           2007 
                           2008 ; macro call ->                  ADD_A_TO _101y
   15EF BB C9 29      [ 5] 2009                  ADDA          _101y
                           2010 ; macro call ->                  STORE_A       _101y
   15F2 B7 C9 29      [ 5] 2011                  STA           _101y
                           2012 ; macro call ->                  STORE_A_NEG _101yi
   15F5 40            [ 2] 2013                  NEGA
   15F6 B7 C9 53      [ 5] 2014                  STA           _101yi
                           2015 ; macro call ->                  A_EQUALS_MUL _101x, _cosz
   15F9 F6 C9 16      [ 5] 2016                  LDB           _cosz
   15FC B6 C9 28      [ 5] 2017                  LDA           _101x
   15FF 2A 07         [ 3] 2018                  BPL           mul_Ap99
   1601 40            [ 2] 2019                  NEGA
   1602 5D            [ 2] 2020                  TSTB
   1603 2A 07         [ 3] 2021                  BPL           mul_An_Bp99
   1605 50            [ 2] 2022                  NEGB
   1606 20 09         [ 3] 2023                  BRA           mul_An_Bn99
                           2024  .globl mul_Ap99
   1608                    2025 mul_Ap99:
   1608 5D            [ 2] 2026                  TSTB
   1609 2A 06         [ 3] 2027                  BPL           mul_Ap_Bp99
   160B 50            [ 2] 2028                  NEGB
                           2029  .globl mul_An_Bp99
   160C                    2030 mul_An_Bp99:
   160C 3D            [11] 2031                  MUL
   160D 53            [ 2] 2032                  COMB                              ; here we can use this as negd
   160E 43            [ 2] 2033                  COMA                              ; since the low nibble of b doesn't interest us
   160F 20 01         [ 3] 2034                  BRA           mul_end99
                           2035  .globl mul_Ap_Bp99
   1611                    2036 mul_Ap_Bp99:
                           2037  .globl mul_An_Bn99
   1611                    2038 mul_An_Bn99:
   1611 3D            [11] 2039                  MUL
                           2040  .globl mul_end99
   1612                    2041 mul_end99:
   1612 58            [ 2] 2042                  ASLB                              ; this divides d by 64
   1613 49            [ 2] 2043                  ROLA
   1614 58            [ 2] 2044                  ASLB
   1615 49            [ 2] 2045                  ROLA
                           2046 
                           2047 ; macro call ->                  STORE_A _101x
   1616 B7 C9 28      [ 5] 2048                  STA           _101x
                           2049 ; macro call ->                  A_EQUALS_MUL _cosx, _sinz
   1619 F6 C9 17      [ 5] 2050                  LDB           _sinz
   161C B6 C9 12      [ 5] 2051                  LDA           _cosx
   161F 2A 07         [ 3] 2052                  BPL           mul_Ap101
   1621 40            [ 2] 2053                  NEGA
   1622 5D            [ 2] 2054                  TSTB
   1623 2A 07         [ 3] 2055                  BPL           mul_An_Bp101
   1625 50            [ 2] 2056                  NEGB
   1626 20 09         [ 3] 2057                  BRA           mul_An_Bn101
                           2058  .globl mul_Ap101
   1628                    2059 mul_Ap101:
   1628 5D            [ 2] 2060                  TSTB
   1629 2A 06         [ 3] 2061                  BPL           mul_Ap_Bp101
   162B 50            [ 2] 2062                  NEGB
                           2063  .globl mul_An_Bp101
   162C                    2064 mul_An_Bp101:
   162C 3D            [11] 2065                  MUL
   162D 53            [ 2] 2066                  COMB                              ; here we can use this as negd
   162E 43            [ 2] 2067                  COMA                              ; since the low nibble of b doesn't interest us
   162F 20 01         [ 3] 2068                  BRA           mul_end101
                           2069  .globl mul_Ap_Bp101
   1631                    2070 mul_Ap_Bp101:
                           2071  .globl mul_An_Bn101
   1631                    2072 mul_An_Bn101:
   1631 3D            [11] 2073                  MUL
                           2074  .globl mul_end101
   1632                    2075 mul_end101:
   1632 58            [ 2] 2076                  ASLB                              ; this divides d by 64
   1633 49            [ 2] 2077                  ROLA
   1634 58            [ 2] 2078                  ASLB
   1635 49            [ 2] 2079                  ROLA
                           2080 
                           2081 ; macro call ->                  SUB_A_FROM _101x
   1636 40            [ 2] 2082                  NEGA
                           2083 ; macro call ->                  ADD_A_TO      _101x
   1637 BB C9 28      [ 5] 2084                  ADDA          _101x
                           2085 ; macro call ->                  STORE_A       _101x
   163A B7 C9 28      [ 5] 2086                  STA           _101x
                           2087 ; macro call ->                  STORE_A_NEG _101xi
   163D 40            [ 2] 2088                  NEGA
   163E B7 C9 52      [ 5] 2089                  STA           _101xi
   1641 B6 C9 1C      [ 5] 2090  lda _vectorBits+1
                           2091  .globl no101
   1644                    2092 no101:
   1644 85 10         [ 2] 2093  bita #TEST_1_1_1
   1646 10 27 00 D4   [ 6] 2094  lbeq no111
                           2095 ; macro call ->                     INIT_1_1_1_A  
                           2096 ; macro call ->                  CALC_1_1_1_A _111x, _111y, _111z, _111xi, _111yi, _111zi
   164A B6 C9 12      [ 5] 2097                  LDA _cosx
   164D BB C9 13      [ 5] 2098                  ADDA _sinx
   1650 B7 C9 2D      [ 5] 2099                  STA _111z
   1653 40            [ 2] 2100                  NEGA
   1654 B7 C9 57      [ 5] 2101                  STA _111zi
   1657 B6 C9 13      [ 5] 2102                  LDA   _sinx
   165A BB C9 12      [ 5] 2103                  ADDA  _cosx
   165D B7 C9 2D      [ 5] 2104                  STA   _111z
                           2105 
   1660 B6 C9 12      [ 5] 2106                  LDA   _cosx
   1663 B0 C9 13      [ 5] 2107                  SUBA  _sinx
   1666 B7 C9 11      [ 5] 2108                  STA   _helper
                           2109 
                           2110 ; macro call ->                  A_EQUALS_MUL _111z, _siny
   1669 F6 C9 15      [ 5] 2111                  LDB           _siny
   166C B6 C9 2D      [ 5] 2112                  LDA           _111z
   166F 2A 07         [ 3] 2113                  BPL           mul_Ap108
   1671 40            [ 2] 2114                  NEGA
   1672 5D            [ 2] 2115                  TSTB
   1673 2A 07         [ 3] 2116                  BPL           mul_An_Bp108
   1675 50            [ 2] 2117                  NEGB
   1676 20 09         [ 3] 2118                  BRA           mul_An_Bn108
                           2119  .globl mul_Ap108
   1678                    2120 mul_Ap108:
   1678 5D            [ 2] 2121                  TSTB
   1679 2A 06         [ 3] 2122                  BPL           mul_Ap_Bp108
   167B 50            [ 2] 2123                  NEGB
                           2124  .globl mul_An_Bp108
   167C                    2125 mul_An_Bp108:
   167C 3D            [11] 2126                  MUL
   167D 53            [ 2] 2127                  COMB                              ; here we can use this as negd
   167E 43            [ 2] 2128                  COMA                              ; since the low nibble of b doesn't interest us
   167F 20 01         [ 3] 2129                  BRA           mul_end108
                           2130  .globl mul_Ap_Bp108
   1681                    2131 mul_Ap_Bp108:
                           2132  .globl mul_An_Bn108
   1681                    2133 mul_An_Bn108:
   1681 3D            [11] 2134                  MUL
                           2135  .globl mul_end108
   1682                    2136 mul_end108:
   1682 58            [ 2] 2137                  ASLB                              ; this divides d by 64
   1683 49            [ 2] 2138                  ROLA
   1684 58            [ 2] 2139                  ASLB
   1685 49            [ 2] 2140                  ROLA
                           2141 
   1686 BB C9 14      [ 5] 2142                  ADDA  _cosy
                           2143 ; macro call ->                  STORE_A _111x
   1689 B7 C9 2B      [ 5] 2144                  STA           _111x
                           2145 ; macro call ->                  A_EQUALS_MUL _helper, _cosz
   168C F6 C9 16      [ 5] 2146                  LDB           _cosz
   168F B6 C9 11      [ 5] 2147                  LDA           _helper
   1692 2A 07         [ 3] 2148                  BPL           mul_Ap110
   1694 40            [ 2] 2149                  NEGA
   1695 5D            [ 2] 2150                  TSTB
   1696 2A 07         [ 3] 2151                  BPL           mul_An_Bp110
   1698 50            [ 2] 2152                  NEGB
   1699 20 09         [ 3] 2153                  BRA           mul_An_Bn110
                           2154  .globl mul_Ap110
   169B                    2155 mul_Ap110:
   169B 5D            [ 2] 2156                  TSTB
   169C 2A 06         [ 3] 2157                  BPL           mul_Ap_Bp110
   169E 50            [ 2] 2158                  NEGB
                           2159  .globl mul_An_Bp110
   169F                    2160 mul_An_Bp110:
   169F 3D            [11] 2161                  MUL
   16A0 53            [ 2] 2162                  COMB                              ; here we can use this as negd
   16A1 43            [ 2] 2163                  COMA                              ; since the low nibble of b doesn't interest us
   16A2 20 01         [ 3] 2164                  BRA           mul_end110
                           2165  .globl mul_Ap_Bp110
   16A4                    2166 mul_Ap_Bp110:
                           2167  .globl mul_An_Bn110
   16A4                    2168 mul_An_Bn110:
   16A4 3D            [11] 2169                  MUL
                           2170  .globl mul_end110
   16A5                    2171 mul_end110:
   16A5 58            [ 2] 2172                  ASLB                              ; this divides d by 64
   16A6 49            [ 2] 2173                  ROLA
   16A7 58            [ 2] 2174                  ASLB
   16A8 49            [ 2] 2175                  ROLA
                           2176 
                           2177 ; macro call ->                  STORE_A _111y
   16A9 B7 C9 2C      [ 5] 2178                  STA           _111y
                           2179 ; macro call ->                  A_EQUALS_MUL _111x, _sinz
   16AC F6 C9 17      [ 5] 2180                  LDB           _sinz
   16AF B6 C9 2B      [ 5] 2181                  LDA           _111x
   16B2 2A 07         [ 3] 2182                  BPL           mul_Ap112
   16B4 40            [ 2] 2183                  NEGA
   16B5 5D            [ 2] 2184                  TSTB
   16B6 2A 07         [ 3] 2185                  BPL           mul_An_Bp112
   16B8 50            [ 2] 2186                  NEGB
   16B9 20 09         [ 3] 2187                  BRA           mul_An_Bn112
                           2188  .globl mul_Ap112
   16BB                    2189 mul_Ap112:
   16BB 5D            [ 2] 2190                  TSTB
   16BC 2A 06         [ 3] 2191                  BPL           mul_Ap_Bp112
   16BE 50            [ 2] 2192                  NEGB
                           2193  .globl mul_An_Bp112
   16BF                    2194 mul_An_Bp112:
   16BF 3D            [11] 2195                  MUL
   16C0 53            [ 2] 2196                  COMB                              ; here we can use this as negd
   16C1 43            [ 2] 2197                  COMA                              ; since the low nibble of b doesn't interest us
   16C2 20 01         [ 3] 2198                  BRA           mul_end112
                           2199  .globl mul_Ap_Bp112
   16C4                    2200 mul_Ap_Bp112:
                           2201  .globl mul_An_Bn112
   16C4                    2202 mul_An_Bn112:
   16C4 3D            [11] 2203                  MUL
                           2204  .globl mul_end112
   16C5                    2205 mul_end112:
   16C5 58            [ 2] 2206                  ASLB                              ; this divides d by 64
   16C6 49            [ 2] 2207                  ROLA
   16C7 58            [ 2] 2208                  ASLB
   16C8 49            [ 2] 2209                  ROLA
                           2210 
                           2211 ; macro call ->                  ADD_A_TO _111y
   16C9 BB C9 2C      [ 5] 2212                  ADDA          _111y
                           2213 ; macro call ->                  STORE_A       _111y
   16CC B7 C9 2C      [ 5] 2214                  STA           _111y
                           2215 ; macro call ->                  STORE_A_NEG _111yi
   16CF 40            [ 2] 2216                  NEGA
   16D0 B7 C9 56      [ 5] 2217                  STA           _111yi
                           2218 ; macro call ->                  A_EQUALS_MUL _111x, _cosz
   16D3 F6 C9 16      [ 5] 2219                  LDB           _cosz
   16D6 B6 C9 2B      [ 5] 2220                  LDA           _111x
   16D9 2A 07         [ 3] 2221                  BPL           mul_Ap116
   16DB 40            [ 2] 2222                  NEGA
   16DC 5D            [ 2] 2223                  TSTB
   16DD 2A 07         [ 3] 2224                  BPL           mul_An_Bp116
   16DF 50            [ 2] 2225                  NEGB
   16E0 20 09         [ 3] 2226                  BRA           mul_An_Bn116
                           2227  .globl mul_Ap116
   16E2                    2228 mul_Ap116:
   16E2 5D            [ 2] 2229                  TSTB
   16E3 2A 06         [ 3] 2230                  BPL           mul_Ap_Bp116
   16E5 50            [ 2] 2231                  NEGB
                           2232  .globl mul_An_Bp116
   16E6                    2233 mul_An_Bp116:
   16E6 3D            [11] 2234                  MUL
   16E7 53            [ 2] 2235                  COMB                              ; here we can use this as negd
   16E8 43            [ 2] 2236                  COMA                              ; since the low nibble of b doesn't interest us
   16E9 20 01         [ 3] 2237                  BRA           mul_end116
                           2238  .globl mul_Ap_Bp116
   16EB                    2239 mul_Ap_Bp116:
                           2240  .globl mul_An_Bn116
   16EB                    2241 mul_An_Bn116:
   16EB 3D            [11] 2242                  MUL
                           2243  .globl mul_end116
   16EC                    2244 mul_end116:
   16EC 58            [ 2] 2245                  ASLB                              ; this divides d by 64
   16ED 49            [ 2] 2246                  ROLA
   16EE 58            [ 2] 2247                  ASLB
   16EF 49            [ 2] 2248                  ROLA
                           2249 
                           2250 ; macro call ->                  STORE_A _111x
   16F0 B7 C9 2B      [ 5] 2251                  STA           _111x
                           2252 ; macro call ->                  A_EQUALS_MUL _helper, _sinz
   16F3 F6 C9 17      [ 5] 2253                  LDB           _sinz
   16F6 B6 C9 11      [ 5] 2254                  LDA           _helper
   16F9 2A 07         [ 3] 2255                  BPL           mul_Ap118
   16FB 40            [ 2] 2256                  NEGA
   16FC 5D            [ 2] 2257                  TSTB
   16FD 2A 07         [ 3] 2258                  BPL           mul_An_Bp118
   16FF 50            [ 2] 2259                  NEGB
   1700 20 09         [ 3] 2260                  BRA           mul_An_Bn118
                           2261  .globl mul_Ap118
   1702                    2262 mul_Ap118:
   1702 5D            [ 2] 2263                  TSTB
   1703 2A 06         [ 3] 2264                  BPL           mul_Ap_Bp118
   1705 50            [ 2] 2265                  NEGB
                           2266  .globl mul_An_Bp118
   1706                    2267 mul_An_Bp118:
   1706 3D            [11] 2268                  MUL
   1707 53            [ 2] 2269                  COMB                              ; here we can use this as negd
   1708 43            [ 2] 2270                  COMA                              ; since the low nibble of b doesn't interest us
   1709 20 01         [ 3] 2271                  BRA           mul_end118
                           2272  .globl mul_Ap_Bp118
   170B                    2273 mul_Ap_Bp118:
                           2274  .globl mul_An_Bn118
   170B                    2275 mul_An_Bn118:
   170B 3D            [11] 2276                  MUL
                           2277  .globl mul_end118
   170C                    2278 mul_end118:
   170C 58            [ 2] 2279                  ASLB                              ; this divides d by 64
   170D 49            [ 2] 2280                  ROLA
   170E 58            [ 2] 2281                  ASLB
   170F 49            [ 2] 2282                  ROLA
                           2283 
                           2284 ; macro call ->                  SUB_A_FROM _111x
   1710 40            [ 2] 2285                  NEGA
                           2286 ; macro call ->                  ADD_A_TO      _111x
   1711 BB C9 2B      [ 5] 2287                  ADDA          _111x
                           2288 ; macro call ->                  STORE_A       _111x
   1714 B7 C9 2B      [ 5] 2289                  STA           _111x
                           2290 ; macro call ->                  STORE_A_NEG _111xi
   1717 40            [ 2] 2291                  NEGA
   1718 B7 C9 55      [ 5] 2292                  STA           _111xi
   171B B6 C9 1C      [ 5] 2293  lda _vectorBits+1
                           2294  .globl no111
   171E                    2295 no111:
   171E 85 20         [ 2] 2296  bita #TEST_0_1_0
   1720 10 27 00 BC   [ 6] 2297  lbeq no010
                           2298 ; macro call ->                     INIT_0_1_0_A  
                           2299 ; macro call ->                  CALC_0_1_0_A _010x, _010y, _010z, _010xi, _010yi, _010yi
   1724 B6 C9 12      [ 5] 2300                  LDA _cosx
   1727 B7 C9 30      [ 5] 2301                  STA _010z
   172A 40            [ 2] 2302                  NEGA
   172B B7 C9 59      [ 5] 2303                  STA _010yi
                           2304 ; macro call ->                  A_EQUALS_MUL _cosx, _siny
   172E F6 C9 15      [ 5] 2305                  LDB           _siny
   1731 B6 C9 12      [ 5] 2306                  LDA           _cosx
   1734 2A 07         [ 3] 2307                  BPL           mul_Ap125
   1736 40            [ 2] 2308                  NEGA
   1737 5D            [ 2] 2309                  TSTB
   1738 2A 07         [ 3] 2310                  BPL           mul_An_Bp125
   173A 50            [ 2] 2311                  NEGB
   173B 20 09         [ 3] 2312                  BRA           mul_An_Bn125
                           2313  .globl mul_Ap125
   173D                    2314 mul_Ap125:
   173D 5D            [ 2] 2315                  TSTB
   173E 2A 06         [ 3] 2316                  BPL           mul_Ap_Bp125
   1740 50            [ 2] 2317                  NEGB
                           2318  .globl mul_An_Bp125
   1741                    2319 mul_An_Bp125:
   1741 3D            [11] 2320                  MUL
   1742 53            [ 2] 2321                  COMB                              ; here we can use this as negd
   1743 43            [ 2] 2322                  COMA                              ; since the low nibble of b doesn't interest us
   1744 20 01         [ 3] 2323                  BRA           mul_end125
                           2324  .globl mul_Ap_Bp125
   1746                    2325 mul_Ap_Bp125:
                           2326  .globl mul_An_Bn125
   1746                    2327 mul_An_Bn125:
   1746 3D            [11] 2328                  MUL
                           2329  .globl mul_end125
   1747                    2330 mul_end125:
   1747 58            [ 2] 2331                  ASLB                              ; this divides d by 64
   1748 49            [ 2] 2332                  ROLA
   1749 58            [ 2] 2333                  ASLB
   174A 49            [ 2] 2334                  ROLA
                           2335 
                           2336 ; macro call ->                  STORE_A _010x
   174B B7 C9 2E      [ 5] 2337                  STA           _010x
                           2338 ; macro call ->                  A_EQUALS_MUL _010x, _sinz
   174E F6 C9 17      [ 5] 2339                  LDB           _sinz
   1751 B6 C9 2E      [ 5] 2340                  LDA           _010x
   1754 2A 07         [ 3] 2341                  BPL           mul_Ap127
   1756 40            [ 2] 2342                  NEGA
   1757 5D            [ 2] 2343                  TSTB
   1758 2A 07         [ 3] 2344                  BPL           mul_An_Bp127
   175A 50            [ 2] 2345                  NEGB
   175B 20 09         [ 3] 2346                  BRA           mul_An_Bn127
                           2347  .globl mul_Ap127
   175D                    2348 mul_Ap127:
   175D 5D            [ 2] 2349                  TSTB
   175E 2A 06         [ 3] 2350                  BPL           mul_Ap_Bp127
   1760 50            [ 2] 2351                  NEGB
                           2352  .globl mul_An_Bp127
   1761                    2353 mul_An_Bp127:
   1761 3D            [11] 2354                  MUL
   1762 53            [ 2] 2355                  COMB                              ; here we can use this as negd
   1763 43            [ 2] 2356                  COMA                              ; since the low nibble of b doesn't interest us
   1764 20 01         [ 3] 2357                  BRA           mul_end127
                           2358  .globl mul_Ap_Bp127
   1766                    2359 mul_Ap_Bp127:
                           2360  .globl mul_An_Bn127
   1766                    2361 mul_An_Bn127:
   1766 3D            [11] 2362                  MUL
                           2363  .globl mul_end127
   1767                    2364 mul_end127:
   1767 58            [ 2] 2365                  ASLB                              ; this divides d by 64
   1768 49            [ 2] 2366                  ROLA
   1769 58            [ 2] 2367                  ASLB
   176A 49            [ 2] 2368                  ROLA
                           2369 
                           2370 ; macro call ->                  STORE_A _010y
   176B B7 C9 2F      [ 5] 2371                  STA           _010y
                           2372 ; macro call ->                  A_EQUALS_MUL _sinx, _cosz
   176E F6 C9 16      [ 5] 2373                  LDB           _cosz
   1771 B6 C9 13      [ 5] 2374                  LDA           _sinx
   1774 2A 07         [ 3] 2375                  BPL           mul_Ap129
   1776 40            [ 2] 2376                  NEGA
   1777 5D            [ 2] 2377                  TSTB
   1778 2A 07         [ 3] 2378                  BPL           mul_An_Bp129
   177A 50            [ 2] 2379                  NEGB
   177B 20 09         [ 3] 2380                  BRA           mul_An_Bn129
                           2381  .globl mul_Ap129
   177D                    2382 mul_Ap129:
   177D 5D            [ 2] 2383                  TSTB
   177E 2A 06         [ 3] 2384                  BPL           mul_Ap_Bp129
   1780 50            [ 2] 2385                  NEGB
                           2386  .globl mul_An_Bp129
   1781                    2387 mul_An_Bp129:
   1781 3D            [11] 2388                  MUL
   1782 53            [ 2] 2389                  COMB                              ; here we can use this as negd
   1783 43            [ 2] 2390                  COMA                              ; since the low nibble of b doesn't interest us
   1784 20 01         [ 3] 2391                  BRA           mul_end129
                           2392  .globl mul_Ap_Bp129
   1786                    2393 mul_Ap_Bp129:
                           2394  .globl mul_An_Bn129
   1786                    2395 mul_An_Bn129:
   1786 3D            [11] 2396                  MUL
                           2397  .globl mul_end129
   1787                    2398 mul_end129:
   1787 58            [ 2] 2399                  ASLB                              ; this divides d by 64
   1788 49            [ 2] 2400                  ROLA
   1789 58            [ 2] 2401                  ASLB
   178A 49            [ 2] 2402                  ROLA
                           2403 
                           2404 ; macro call ->                  SUB_A_FROM _010y
   178B 40            [ 2] 2405                  NEGA
                           2406 ; macro call ->                  ADD_A_TO      _010y
   178C BB C9 2F      [ 5] 2407                  ADDA          _010y
                           2408 ; macro call ->                  STORE_A       _010y
   178F B7 C9 2F      [ 5] 2409                  STA           _010y
                           2410 ; macro call ->                  STORE_A_NEG _010yi
   1792 40            [ 2] 2411                  NEGA
   1793 B7 C9 59      [ 5] 2412                  STA           _010yi
                           2413 ; macro call ->                  A_EQUALS_MUL _010x, _cosz
   1796 F6 C9 16      [ 5] 2414                  LDB           _cosz
   1799 B6 C9 2E      [ 5] 2415                  LDA           _010x
   179C 2A 07         [ 3] 2416                  BPL           mul_Ap134
   179E 40            [ 2] 2417                  NEGA
   179F 5D            [ 2] 2418                  TSTB
   17A0 2A 07         [ 3] 2419                  BPL           mul_An_Bp134
   17A2 50            [ 2] 2420                  NEGB
   17A3 20 09         [ 3] 2421                  BRA           mul_An_Bn134
                           2422  .globl mul_Ap134
   17A5                    2423 mul_Ap134:
   17A5 5D            [ 2] 2424                  TSTB
   17A6 2A 06         [ 3] 2425                  BPL           mul_Ap_Bp134
   17A8 50            [ 2] 2426                  NEGB
                           2427  .globl mul_An_Bp134
   17A9                    2428 mul_An_Bp134:
   17A9 3D            [11] 2429                  MUL
   17AA 53            [ 2] 2430                  COMB                              ; here we can use this as negd
   17AB 43            [ 2] 2431                  COMA                              ; since the low nibble of b doesn't interest us
   17AC 20 01         [ 3] 2432                  BRA           mul_end134
                           2433  .globl mul_Ap_Bp134
   17AE                    2434 mul_Ap_Bp134:
                           2435  .globl mul_An_Bn134
   17AE                    2436 mul_An_Bn134:
   17AE 3D            [11] 2437                  MUL
                           2438  .globl mul_end134
   17AF                    2439 mul_end134:
   17AF 58            [ 2] 2440                  ASLB                              ; this divides d by 64
   17B0 49            [ 2] 2441                  ROLA
   17B1 58            [ 2] 2442                  ASLB
   17B2 49            [ 2] 2443                  ROLA
                           2444 
                           2445 ; macro call ->                  STORE_A _010x
   17B3 B7 C9 2E      [ 5] 2446                  STA           _010x
                           2447 ; macro call ->                  A_EQUALS_MUL _sinx, _sinz
   17B6 F6 C9 17      [ 5] 2448                  LDB           _sinz
   17B9 B6 C9 13      [ 5] 2449                  LDA           _sinx
   17BC 2A 07         [ 3] 2450                  BPL           mul_Ap136
   17BE 40            [ 2] 2451                  NEGA
   17BF 5D            [ 2] 2452                  TSTB
   17C0 2A 07         [ 3] 2453                  BPL           mul_An_Bp136
   17C2 50            [ 2] 2454                  NEGB
   17C3 20 09         [ 3] 2455                  BRA           mul_An_Bn136
                           2456  .globl mul_Ap136
   17C5                    2457 mul_Ap136:
   17C5 5D            [ 2] 2458                  TSTB
   17C6 2A 06         [ 3] 2459                  BPL           mul_Ap_Bp136
   17C8 50            [ 2] 2460                  NEGB
                           2461  .globl mul_An_Bp136
   17C9                    2462 mul_An_Bp136:
   17C9 3D            [11] 2463                  MUL
   17CA 53            [ 2] 2464                  COMB                              ; here we can use this as negd
   17CB 43            [ 2] 2465                  COMA                              ; since the low nibble of b doesn't interest us
   17CC 20 01         [ 3] 2466                  BRA           mul_end136
                           2467  .globl mul_Ap_Bp136
   17CE                    2468 mul_Ap_Bp136:
                           2469  .globl mul_An_Bn136
   17CE                    2470 mul_An_Bn136:
   17CE 3D            [11] 2471                  MUL
                           2472  .globl mul_end136
   17CF                    2473 mul_end136:
   17CF 58            [ 2] 2474                  ASLB                              ; this divides d by 64
   17D0 49            [ 2] 2475                  ROLA
   17D1 58            [ 2] 2476                  ASLB
   17D2 49            [ 2] 2477                  ROLA
                           2478 
                           2479 ; macro call ->                  ADD_A_TO _010x
   17D3 BB C9 2E      [ 5] 2480                  ADDA          _010x
                           2481 ; macro call ->                  STORE_A       _010x
   17D6 B7 C9 2E      [ 5] 2482                  STA           _010x
                           2483 ; macro call ->                  STORE_A_NEG _010xi
   17D9 40            [ 2] 2484                  NEGA
   17DA B7 C9 58      [ 5] 2485                  STA           _010xi
   17DD B6 C9 1C      [ 5] 2486  lda _vectorBits+1
                           2487  .globl no010
   17E0                    2488 no010:
   17E0 85 40         [ 2] 2489  bita #TEST_0_1_1
   17E2 10 27 00 D1   [ 6] 2490  lbeq no011
                           2491 ; macro call ->                     INIT_0_1_1_A  
                           2492 ; macro call ->                  CALC_0_1_1_A _011x, _011y, _011z, _011xi, _011yi, _011zi
   17E6 B6 C9 12      [ 5] 2493                  LDA _cosx
   17E9 BB C9 13      [ 5] 2494                  ADDA _sinx
   17EC B7 C9 33      [ 5] 2495                  STA _011z
   17EF 40            [ 2] 2496                  NEGA
   17F0 B7 C9 5D      [ 5] 2497                  STA _011zi
   17F3 B6 C9 13      [ 5] 2498                  LDA   _sinx
   17F6 BB C9 12      [ 5] 2499                  ADDA  _cosx
   17F9 B7 C9 33      [ 5] 2500                  STA   _011z
   17FC B6 C9 12      [ 5] 2501                  LDA   _cosx
   17FF B0 C9 13      [ 5] 2502                  SUBA  _sinx
   1802 B7 C9 11      [ 5] 2503                  STA   _helper
                           2504 ; macro call ->                  A_EQUALS_MUL _011z, _siny
   1805 F6 C9 15      [ 5] 2505                  LDB           _siny
   1808 B6 C9 33      [ 5] 2506                  LDA           _011z
   180B 2A 07         [ 3] 2507                  BPL           mul_Ap142
   180D 40            [ 2] 2508                  NEGA
   180E 5D            [ 2] 2509                  TSTB
   180F 2A 07         [ 3] 2510                  BPL           mul_An_Bp142
   1811 50            [ 2] 2511                  NEGB
   1812 20 09         [ 3] 2512                  BRA           mul_An_Bn142
                           2513  .globl mul_Ap142
   1814                    2514 mul_Ap142:
   1814 5D            [ 2] 2515                  TSTB
   1815 2A 06         [ 3] 2516                  BPL           mul_Ap_Bp142
   1817 50            [ 2] 2517                  NEGB
                           2518  .globl mul_An_Bp142
   1818                    2519 mul_An_Bp142:
   1818 3D            [11] 2520                  MUL
   1819 53            [ 2] 2521                  COMB                              ; here we can use this as negd
   181A 43            [ 2] 2522                  COMA                              ; since the low nibble of b doesn't interest us
   181B 20 01         [ 3] 2523                  BRA           mul_end142
                           2524  .globl mul_Ap_Bp142
   181D                    2525 mul_Ap_Bp142:
                           2526  .globl mul_An_Bn142
   181D                    2527 mul_An_Bn142:
   181D 3D            [11] 2528                  MUL
                           2529  .globl mul_end142
   181E                    2530 mul_end142:
   181E 58            [ 2] 2531                  ASLB                              ; this divides d by 64
   181F 49            [ 2] 2532                  ROLA
   1820 58            [ 2] 2533                  ASLB
   1821 49            [ 2] 2534                  ROLA
                           2535 
                           2536 ; macro call ->                  STORE_A _011x
   1822 B7 C9 31      [ 5] 2537                  STA           _011x
                           2538 ; macro call ->                  A_EQUALS_MUL _helper, _cosz
   1825 F6 C9 16      [ 5] 2539                  LDB           _cosz
   1828 B6 C9 11      [ 5] 2540                  LDA           _helper
   182B 2A 07         [ 3] 2541                  BPL           mul_Ap144
   182D 40            [ 2] 2542                  NEGA
   182E 5D            [ 2] 2543                  TSTB
   182F 2A 07         [ 3] 2544                  BPL           mul_An_Bp144
   1831 50            [ 2] 2545                  NEGB
   1832 20 09         [ 3] 2546                  BRA           mul_An_Bn144
                           2547  .globl mul_Ap144
   1834                    2548 mul_Ap144:
   1834 5D            [ 2] 2549                  TSTB
   1835 2A 06         [ 3] 2550                  BPL           mul_Ap_Bp144
   1837 50            [ 2] 2551                  NEGB
                           2552  .globl mul_An_Bp144
   1838                    2553 mul_An_Bp144:
   1838 3D            [11] 2554                  MUL
   1839 53            [ 2] 2555                  COMB                              ; here we can use this as negd
   183A 43            [ 2] 2556                  COMA                              ; since the low nibble of b doesn't interest us
   183B 20 01         [ 3] 2557                  BRA           mul_end144
                           2558  .globl mul_Ap_Bp144
   183D                    2559 mul_Ap_Bp144:
                           2560  .globl mul_An_Bn144
   183D                    2561 mul_An_Bn144:
   183D 3D            [11] 2562                  MUL
                           2563  .globl mul_end144
   183E                    2564 mul_end144:
   183E 58            [ 2] 2565                  ASLB                              ; this divides d by 64
   183F 49            [ 2] 2566                  ROLA
   1840 58            [ 2] 2567                  ASLB
   1841 49            [ 2] 2568                  ROLA
                           2569 
                           2570 ; macro call ->                  STORE_A _011y
   1842 B7 C9 32      [ 5] 2571                  STA           _011y
                           2572 ; macro call ->                  A_EQUALS_MUL _011x, _sinz
   1845 F6 C9 17      [ 5] 2573                  LDB           _sinz
   1848 B6 C9 31      [ 5] 2574                  LDA           _011x
   184B 2A 07         [ 3] 2575                  BPL           mul_Ap146
   184D 40            [ 2] 2576                  NEGA
   184E 5D            [ 2] 2577                  TSTB
   184F 2A 07         [ 3] 2578                  BPL           mul_An_Bp146
   1851 50            [ 2] 2579                  NEGB
   1852 20 09         [ 3] 2580                  BRA           mul_An_Bn146
                           2581  .globl mul_Ap146
   1854                    2582 mul_Ap146:
   1854 5D            [ 2] 2583                  TSTB
   1855 2A 06         [ 3] 2584                  BPL           mul_Ap_Bp146
   1857 50            [ 2] 2585                  NEGB
                           2586  .globl mul_An_Bp146
   1858                    2587 mul_An_Bp146:
   1858 3D            [11] 2588                  MUL
   1859 53            [ 2] 2589                  COMB                              ; here we can use this as negd
   185A 43            [ 2] 2590                  COMA                              ; since the low nibble of b doesn't interest us
   185B 20 01         [ 3] 2591                  BRA           mul_end146
                           2592  .globl mul_Ap_Bp146
   185D                    2593 mul_Ap_Bp146:
                           2594  .globl mul_An_Bn146
   185D                    2595 mul_An_Bn146:
   185D 3D            [11] 2596                  MUL
                           2597  .globl mul_end146
   185E                    2598 mul_end146:
   185E 58            [ 2] 2599                  ASLB                              ; this divides d by 64
   185F 49            [ 2] 2600                  ROLA
   1860 58            [ 2] 2601                  ASLB
   1861 49            [ 2] 2602                  ROLA
                           2603 
                           2604 ; macro call ->                  ADD_A_TO _011y
   1862 BB C9 32      [ 5] 2605                  ADDA          _011y
                           2606 ; macro call ->                  STORE_A       _011y
   1865 B7 C9 32      [ 5] 2607                  STA           _011y
                           2608 ; macro call ->                  STORE_A_NEG _011yi
   1868 40            [ 2] 2609                  NEGA
   1869 B7 C9 5C      [ 5] 2610                  STA           _011yi
                           2611 ; macro call ->                  A_EQUALS_MUL _011x, _cosz
   186C F6 C9 16      [ 5] 2612                  LDB           _cosz
   186F B6 C9 31      [ 5] 2613                  LDA           _011x
   1872 2A 07         [ 3] 2614                  BPL           mul_Ap150
   1874 40            [ 2] 2615                  NEGA
   1875 5D            [ 2] 2616                  TSTB
   1876 2A 07         [ 3] 2617                  BPL           mul_An_Bp150
   1878 50            [ 2] 2618                  NEGB
   1879 20 09         [ 3] 2619                  BRA           mul_An_Bn150
                           2620  .globl mul_Ap150
   187B                    2621 mul_Ap150:
   187B 5D            [ 2] 2622                  TSTB
   187C 2A 06         [ 3] 2623                  BPL           mul_Ap_Bp150
   187E 50            [ 2] 2624                  NEGB
                           2625  .globl mul_An_Bp150
   187F                    2626 mul_An_Bp150:
   187F 3D            [11] 2627                  MUL
   1880 53            [ 2] 2628                  COMB                              ; here we can use this as negd
   1881 43            [ 2] 2629                  COMA                              ; since the low nibble of b doesn't interest us
   1882 20 01         [ 3] 2630                  BRA           mul_end150
                           2631  .globl mul_Ap_Bp150
   1884                    2632 mul_Ap_Bp150:
                           2633  .globl mul_An_Bn150
   1884                    2634 mul_An_Bn150:
   1884 3D            [11] 2635                  MUL
                           2636  .globl mul_end150
   1885                    2637 mul_end150:
   1885 58            [ 2] 2638                  ASLB                              ; this divides d by 64
   1886 49            [ 2] 2639                  ROLA
   1887 58            [ 2] 2640                  ASLB
   1888 49            [ 2] 2641                  ROLA
                           2642 
                           2643 ; macro call ->                  STORE_A _011x
   1889 B7 C9 31      [ 5] 2644                  STA           _011x
                           2645 ; macro call ->                  A_EQUALS_MUL _helper, _sinz
   188C F6 C9 17      [ 5] 2646                  LDB           _sinz
   188F B6 C9 11      [ 5] 2647                  LDA           _helper
   1892 2A 07         [ 3] 2648                  BPL           mul_Ap152
   1894 40            [ 2] 2649                  NEGA
   1895 5D            [ 2] 2650                  TSTB
   1896 2A 07         [ 3] 2651                  BPL           mul_An_Bp152
   1898 50            [ 2] 2652                  NEGB
   1899 20 09         [ 3] 2653                  BRA           mul_An_Bn152
                           2654  .globl mul_Ap152
   189B                    2655 mul_Ap152:
   189B 5D            [ 2] 2656                  TSTB
   189C 2A 06         [ 3] 2657                  BPL           mul_Ap_Bp152
   189E 50            [ 2] 2658                  NEGB
                           2659  .globl mul_An_Bp152
   189F                    2660 mul_An_Bp152:
   189F 3D            [11] 2661                  MUL
   18A0 53            [ 2] 2662                  COMB                              ; here we can use this as negd
   18A1 43            [ 2] 2663                  COMA                              ; since the low nibble of b doesn't interest us
   18A2 20 01         [ 3] 2664                  BRA           mul_end152
                           2665  .globl mul_Ap_Bp152
   18A4                    2666 mul_Ap_Bp152:
                           2667  .globl mul_An_Bn152
   18A4                    2668 mul_An_Bn152:
   18A4 3D            [11] 2669                  MUL
                           2670  .globl mul_end152
   18A5                    2671 mul_end152:
   18A5 58            [ 2] 2672                  ASLB                              ; this divides d by 64
   18A6 49            [ 2] 2673                  ROLA
   18A7 58            [ 2] 2674                  ASLB
   18A8 49            [ 2] 2675                  ROLA
                           2676 
                           2677 ; macro call ->                  SUB_A_FROM _011x
   18A9 40            [ 2] 2678                  NEGA
                           2679 ; macro call ->                  ADD_A_TO      _011x
   18AA BB C9 31      [ 5] 2680                  ADDA          _011x
                           2681 ; macro call ->                  STORE_A       _011x
   18AD B7 C9 31      [ 5] 2682                  STA           _011x
                           2683 ; macro call ->                  STORE_A_NEG _011xi
   18B0 40            [ 2] 2684                  NEGA
   18B1 B7 C9 5B      [ 5] 2685                  STA           _011xi
   18B4 B6 C9 1C      [ 5] 2686  lda _vectorBits+1
                           2687  .globl no011
   18B7                    2688 no011:
   18B7 85 80         [ 2] 2689  bita #TEST_0_0_1
   18B9 10 27 00 B9   [ 6] 2690  lbeq no001
                           2691 ; macro call ->                     INIT_0_0_1_A  
                           2692 ; macro call ->                  CALC_0_0_1_A _001x, _001y, _001z, _001xi, _001yi, _001zi
   18BD B6 C9 13      [ 5] 2693                  LDA _sinx
   18C0 B7 C9 36      [ 5] 2694                  STA _001z
   18C3 40            [ 2] 2695                  NEGA
   18C4 B7 C9 60      [ 5] 2696                  STA _001zi
                           2697 ; macro call ->                  A_EQUALS_MUL _sinx, _siny
   18C7 F6 C9 15      [ 5] 2698                  LDB           _siny
   18CA B6 C9 13      [ 5] 2699                  LDA           _sinx
   18CD 2A 07         [ 3] 2700                  BPL           mul_Ap159
   18CF 40            [ 2] 2701                  NEGA
   18D0 5D            [ 2] 2702                  TSTB
   18D1 2A 07         [ 3] 2703                  BPL           mul_An_Bp159
   18D3 50            [ 2] 2704                  NEGB
   18D4 20 09         [ 3] 2705                  BRA           mul_An_Bn159
                           2706  .globl mul_Ap159
   18D6                    2707 mul_Ap159:
   18D6 5D            [ 2] 2708                  TSTB
   18D7 2A 06         [ 3] 2709                  BPL           mul_Ap_Bp159
   18D9 50            [ 2] 2710                  NEGB
                           2711  .globl mul_An_Bp159
   18DA                    2712 mul_An_Bp159:
   18DA 3D            [11] 2713                  MUL
   18DB 53            [ 2] 2714                  COMB                              ; here we can use this as negd
   18DC 43            [ 2] 2715                  COMA                              ; since the low nibble of b doesn't interest us
   18DD 20 01         [ 3] 2716                  BRA           mul_end159
                           2717  .globl mul_Ap_Bp159
   18DF                    2718 mul_Ap_Bp159:
                           2719  .globl mul_An_Bn159
   18DF                    2720 mul_An_Bn159:
   18DF 3D            [11] 2721                  MUL
                           2722  .globl mul_end159
   18E0                    2723 mul_end159:
   18E0 58            [ 2] 2724                  ASLB                              ; this divides d by 64
   18E1 49            [ 2] 2725                  ROLA
   18E2 58            [ 2] 2726                  ASLB
   18E3 49            [ 2] 2727                  ROLA
                           2728 
                           2729 ; macro call ->                  STORE_A _001x
   18E4 B7 C9 34      [ 5] 2730                  STA           _001x
                           2731 ; macro call ->                  A_EQUALS_MUL _cosx, _cosz
   18E7 F6 C9 16      [ 5] 2732                  LDB           _cosz
   18EA B6 C9 12      [ 5] 2733                  LDA           _cosx
   18ED 2A 07         [ 3] 2734                  BPL           mul_Ap161
   18EF 40            [ 2] 2735                  NEGA
   18F0 5D            [ 2] 2736                  TSTB
   18F1 2A 07         [ 3] 2737                  BPL           mul_An_Bp161
   18F3 50            [ 2] 2738                  NEGB
   18F4 20 09         [ 3] 2739                  BRA           mul_An_Bn161
                           2740  .globl mul_Ap161
   18F6                    2741 mul_Ap161:
   18F6 5D            [ 2] 2742                  TSTB
   18F7 2A 06         [ 3] 2743                  BPL           mul_Ap_Bp161
   18F9 50            [ 2] 2744                  NEGB
                           2745  .globl mul_An_Bp161
   18FA                    2746 mul_An_Bp161:
   18FA 3D            [11] 2747                  MUL
   18FB 53            [ 2] 2748                  COMB                              ; here we can use this as negd
   18FC 43            [ 2] 2749                  COMA                              ; since the low nibble of b doesn't interest us
   18FD 20 01         [ 3] 2750                  BRA           mul_end161
                           2751  .globl mul_Ap_Bp161
   18FF                    2752 mul_Ap_Bp161:
                           2753  .globl mul_An_Bn161
   18FF                    2754 mul_An_Bn161:
   18FF 3D            [11] 2755                  MUL
                           2756  .globl mul_end161
   1900                    2757 mul_end161:
   1900 58            [ 2] 2758                  ASLB                              ; this divides d by 64
   1901 49            [ 2] 2759                  ROLA
   1902 58            [ 2] 2760                  ASLB
   1903 49            [ 2] 2761                  ROLA
                           2762 
                           2763 ; macro call ->                  STORE_A _001y
   1904 B7 C9 35      [ 5] 2764                  STA           _001y
                           2765 ; macro call ->                  A_EQUALS_MUL _001x, _sinz
   1907 F6 C9 17      [ 5] 2766                  LDB           _sinz
   190A B6 C9 34      [ 5] 2767                  LDA           _001x
   190D 2A 07         [ 3] 2768                  BPL           mul_Ap163
   190F 40            [ 2] 2769                  NEGA
   1910 5D            [ 2] 2770                  TSTB
   1911 2A 07         [ 3] 2771                  BPL           mul_An_Bp163
   1913 50            [ 2] 2772                  NEGB
   1914 20 09         [ 3] 2773                  BRA           mul_An_Bn163
                           2774  .globl mul_Ap163
   1916                    2775 mul_Ap163:
   1916 5D            [ 2] 2776                  TSTB
   1917 2A 06         [ 3] 2777                  BPL           mul_Ap_Bp163
   1919 50            [ 2] 2778                  NEGB
                           2779  .globl mul_An_Bp163
   191A                    2780 mul_An_Bp163:
   191A 3D            [11] 2781                  MUL
   191B 53            [ 2] 2782                  COMB                              ; here we can use this as negd
   191C 43            [ 2] 2783                  COMA                              ; since the low nibble of b doesn't interest us
   191D 20 01         [ 3] 2784                  BRA           mul_end163
                           2785  .globl mul_Ap_Bp163
   191F                    2786 mul_Ap_Bp163:
                           2787  .globl mul_An_Bn163
   191F                    2788 mul_An_Bn163:
   191F 3D            [11] 2789                  MUL
                           2790  .globl mul_end163
   1920                    2791 mul_end163:
   1920 58            [ 2] 2792                  ASLB                              ; this divides d by 64
   1921 49            [ 2] 2793                  ROLA
   1922 58            [ 2] 2794                  ASLB
   1923 49            [ 2] 2795                  ROLA
                           2796 
                           2797 ; macro call ->                  ADD_A_TO _001y
   1924 BB C9 35      [ 5] 2798                  ADDA          _001y
                           2799 ; macro call ->                  STORE_A       _001y
   1927 B7 C9 35      [ 5] 2800                  STA           _001y
                           2801 ; macro call ->                  STORE_A_NEG _001yi
   192A 40            [ 2] 2802                  NEGA
   192B B7 C9 5F      [ 5] 2803                  STA           _001yi
                           2804 ; macro call ->                  A_EQUALS_MUL _001x, _cosz
   192E F6 C9 16      [ 5] 2805                  LDB           _cosz
   1931 B6 C9 34      [ 5] 2806                  LDA           _001x
   1934 2A 07         [ 3] 2807                  BPL           mul_Ap167
   1936 40            [ 2] 2808                  NEGA
   1937 5D            [ 2] 2809                  TSTB
   1938 2A 07         [ 3] 2810                  BPL           mul_An_Bp167
   193A 50            [ 2] 2811                  NEGB
   193B 20 09         [ 3] 2812                  BRA           mul_An_Bn167
                           2813  .globl mul_Ap167
   193D                    2814 mul_Ap167:
   193D 5D            [ 2] 2815                  TSTB
   193E 2A 06         [ 3] 2816                  BPL           mul_Ap_Bp167
   1940 50            [ 2] 2817                  NEGB
                           2818  .globl mul_An_Bp167
   1941                    2819 mul_An_Bp167:
   1941 3D            [11] 2820                  MUL
   1942 53            [ 2] 2821                  COMB                              ; here we can use this as negd
   1943 43            [ 2] 2822                  COMA                              ; since the low nibble of b doesn't interest us
   1944 20 01         [ 3] 2823                  BRA           mul_end167
                           2824  .globl mul_Ap_Bp167
   1946                    2825 mul_Ap_Bp167:
                           2826  .globl mul_An_Bn167
   1946                    2827 mul_An_Bn167:
   1946 3D            [11] 2828                  MUL
                           2829  .globl mul_end167
   1947                    2830 mul_end167:
   1947 58            [ 2] 2831                  ASLB                              ; this divides d by 64
   1948 49            [ 2] 2832                  ROLA
   1949 58            [ 2] 2833                  ASLB
   194A 49            [ 2] 2834                  ROLA
                           2835 
                           2836 ; macro call ->                  STORE_A _001x
   194B B7 C9 34      [ 5] 2837                  STA           _001x
                           2838 ; macro call ->                  A_EQUALS_MUL _cosx, _sinz
   194E F6 C9 17      [ 5] 2839                  LDB           _sinz
   1951 B6 C9 12      [ 5] 2840                  LDA           _cosx
   1954 2A 07         [ 3] 2841                  BPL           mul_Ap169
   1956 40            [ 2] 2842                  NEGA
   1957 5D            [ 2] 2843                  TSTB
   1958 2A 07         [ 3] 2844                  BPL           mul_An_Bp169
   195A 50            [ 2] 2845                  NEGB
   195B 20 09         [ 3] 2846                  BRA           mul_An_Bn169
                           2847  .globl mul_Ap169
   195D                    2848 mul_Ap169:
   195D 5D            [ 2] 2849                  TSTB
   195E 2A 06         [ 3] 2850                  BPL           mul_Ap_Bp169
   1960 50            [ 2] 2851                  NEGB
                           2852  .globl mul_An_Bp169
   1961                    2853 mul_An_Bp169:
   1961 3D            [11] 2854                  MUL
   1962 53            [ 2] 2855                  COMB                              ; here we can use this as negd
   1963 43            [ 2] 2856                  COMA                              ; since the low nibble of b doesn't interest us
   1964 20 01         [ 3] 2857                  BRA           mul_end169
                           2858  .globl mul_Ap_Bp169
   1966                    2859 mul_Ap_Bp169:
                           2860  .globl mul_An_Bn169
   1966                    2861 mul_An_Bn169:
   1966 3D            [11] 2862                  MUL
                           2863  .globl mul_end169
   1967                    2864 mul_end169:
   1967 58            [ 2] 2865                  ASLB                              ; this divides d by 64
   1968 49            [ 2] 2866                  ROLA
   1969 58            [ 2] 2867                  ASLB
   196A 49            [ 2] 2868                  ROLA
                           2869 
                           2870 ; macro call ->                  SUB_A_FROM _001x
   196B 40            [ 2] 2871                  NEGA
                           2872 ; macro call ->                  ADD_A_TO      _001x
   196C BB C9 34      [ 5] 2873                  ADDA          _001x
                           2874 ; macro call ->                  STORE_A       _001x
   196F B7 C9 34      [ 5] 2875                  STA           _001x
                           2876 ; macro call ->                  STORE_A_NEG _001xi
   1972 40            [ 2] 2877                  NEGA
   1973 B7 C9 5E      [ 5] 2878                  STA           _001xi
                           2879  .globl no001
   1976                    2880 no001:
   1976 B6 C9 1B      [ 5] 2881  lda _vectorBits
   1979 85 01         [ 2] 2882  bita #TEST_N_1_0
   197B 10 27 00 C6   [ 6] 2883  lbeq noN10
                           2884 ; macro call ->                     INIT_N_1_0_A  
                           2885 ; macro call ->                  CALC_N_1_0_A _N10x, _N10y, _N10z, _N10xi, _N10yi, _N10zi
   197F B6 C9 12      [ 5] 2886                  LDA _cosx
   1982 B7 C9 39      [ 5] 2887                  STA _N10z
   1985 40            [ 2] 2888                  NEGA
   1986 B7 C9 63      [ 5] 2889                  STA _N10zi
   1989 B6 C9 13      [ 5] 2890                  LDA   _sinx
   198C 40            [ 2] 2891                  NEGA
   198D B7 C9 11      [ 5] 2892                  STA   _helper
                           2893 ; macro call ->                  A_EQUALS_MUL _cosx, _siny
   1990 F6 C9 15      [ 5] 2894                  LDB           _siny
   1993 B6 C9 12      [ 5] 2895                  LDA           _cosx
   1996 2A 07         [ 3] 2896                  BPL           mul_Ap176
   1998 40            [ 2] 2897                  NEGA
   1999 5D            [ 2] 2898                  TSTB
   199A 2A 07         [ 3] 2899                  BPL           mul_An_Bp176
   199C 50            [ 2] 2900                  NEGB
   199D 20 09         [ 3] 2901                  BRA           mul_An_Bn176
                           2902  .globl mul_Ap176
   199F                    2903 mul_Ap176:
   199F 5D            [ 2] 2904                  TSTB
   19A0 2A 06         [ 3] 2905                  BPL           mul_Ap_Bp176
   19A2 50            [ 2] 2906                  NEGB
                           2907  .globl mul_An_Bp176
   19A3                    2908 mul_An_Bp176:
   19A3 3D            [11] 2909                  MUL
   19A4 53            [ 2] 2910                  COMB                              ; here we can use this as negd
   19A5 43            [ 2] 2911                  COMA                              ; since the low nibble of b doesn't interest us
   19A6 20 01         [ 3] 2912                  BRA           mul_end176
                           2913  .globl mul_Ap_Bp176
   19A8                    2914 mul_Ap_Bp176:
                           2915  .globl mul_An_Bn176
   19A8                    2916 mul_An_Bn176:
   19A8 3D            [11] 2917                  MUL
                           2918  .globl mul_end176
   19A9                    2919 mul_end176:
   19A9 58            [ 2] 2920                  ASLB                              ; this divides d by 64
   19AA 49            [ 2] 2921                  ROLA
   19AB 58            [ 2] 2922                  ASLB
   19AC 49            [ 2] 2923                  ROLA
                           2924 
   19AD B0 C9 14      [ 5] 2925                  SUBA  _cosy
                           2926 ; macro call ->                  STORE_A _N10x
   19B0 B7 C9 37      [ 5] 2927                  STA           _N10x
                           2928 ; macro call ->                  A_EQUALS_MUL _helper, _cosz
   19B3 F6 C9 16      [ 5] 2929                  LDB           _cosz
   19B6 B6 C9 11      [ 5] 2930                  LDA           _helper
   19B9 2A 07         [ 3] 2931                  BPL           mul_Ap178
   19BB 40            [ 2] 2932                  NEGA
   19BC 5D            [ 2] 2933                  TSTB
   19BD 2A 07         [ 3] 2934                  BPL           mul_An_Bp178
   19BF 50            [ 2] 2935                  NEGB
   19C0 20 09         [ 3] 2936                  BRA           mul_An_Bn178
                           2937  .globl mul_Ap178
   19C2                    2938 mul_Ap178:
   19C2 5D            [ 2] 2939                  TSTB
   19C3 2A 06         [ 3] 2940                  BPL           mul_Ap_Bp178
   19C5 50            [ 2] 2941                  NEGB
                           2942  .globl mul_An_Bp178
   19C6                    2943 mul_An_Bp178:
   19C6 3D            [11] 2944                  MUL
   19C7 53            [ 2] 2945                  COMB                              ; here we can use this as negd
   19C8 43            [ 2] 2946                  COMA                              ; since the low nibble of b doesn't interest us
   19C9 20 01         [ 3] 2947                  BRA           mul_end178
                           2948  .globl mul_Ap_Bp178
   19CB                    2949 mul_Ap_Bp178:
                           2950  .globl mul_An_Bn178
   19CB                    2951 mul_An_Bn178:
   19CB 3D            [11] 2952                  MUL
                           2953  .globl mul_end178
   19CC                    2954 mul_end178:
   19CC 58            [ 2] 2955                  ASLB                              ; this divides d by 64
   19CD 49            [ 2] 2956                  ROLA
   19CE 58            [ 2] 2957                  ASLB
   19CF 49            [ 2] 2958                  ROLA
                           2959 
                           2960 ; macro call ->                  STORE_A _N10y
   19D0 B7 C9 38      [ 5] 2961                  STA           _N10y
                           2962 ; macro call ->                  A_EQUALS_MUL _N10x, _sinz
   19D3 F6 C9 17      [ 5] 2963                  LDB           _sinz
   19D6 B6 C9 37      [ 5] 2964                  LDA           _N10x
   19D9 2A 07         [ 3] 2965                  BPL           mul_Ap180
   19DB 40            [ 2] 2966                  NEGA
   19DC 5D            [ 2] 2967                  TSTB
   19DD 2A 07         [ 3] 2968                  BPL           mul_An_Bp180
   19DF 50            [ 2] 2969                  NEGB
   19E0 20 09         [ 3] 2970                  BRA           mul_An_Bn180
                           2971  .globl mul_Ap180
   19E2                    2972 mul_Ap180:
   19E2 5D            [ 2] 2973                  TSTB
   19E3 2A 06         [ 3] 2974                  BPL           mul_Ap_Bp180
   19E5 50            [ 2] 2975                  NEGB
                           2976  .globl mul_An_Bp180
   19E6                    2977 mul_An_Bp180:
   19E6 3D            [11] 2978                  MUL
   19E7 53            [ 2] 2979                  COMB                              ; here we can use this as negd
   19E8 43            [ 2] 2980                  COMA                              ; since the low nibble of b doesn't interest us
   19E9 20 01         [ 3] 2981                  BRA           mul_end180
                           2982  .globl mul_Ap_Bp180
   19EB                    2983 mul_Ap_Bp180:
                           2984  .globl mul_An_Bn180
   19EB                    2985 mul_An_Bn180:
   19EB 3D            [11] 2986                  MUL
                           2987  .globl mul_end180
   19EC                    2988 mul_end180:
   19EC 58            [ 2] 2989                  ASLB                              ; this divides d by 64
   19ED 49            [ 2] 2990                  ROLA
   19EE 58            [ 2] 2991                  ASLB
   19EF 49            [ 2] 2992                  ROLA
                           2993 
                           2994 ; macro call ->                  ADD_A_TO _N10y
   19F0 BB C9 38      [ 5] 2995                  ADDA          _N10y
                           2996 ; macro call ->                  STORE_A       _N10y
   19F3 B7 C9 38      [ 5] 2997                  STA           _N10y
                           2998 ; macro call ->                  STORE_A_NEG _N10yi
   19F6 40            [ 2] 2999                  NEGA
   19F7 B7 C9 62      [ 5] 3000                  STA           _N10yi
                           3001 ; macro call ->                  A_EQUALS_MUL _N10x, _cosz
   19FA F6 C9 16      [ 5] 3002                  LDB           _cosz
   19FD B6 C9 37      [ 5] 3003                  LDA           _N10x
   1A00 2A 07         [ 3] 3004                  BPL           mul_Ap184
   1A02 40            [ 2] 3005                  NEGA
   1A03 5D            [ 2] 3006                  TSTB
   1A04 2A 07         [ 3] 3007                  BPL           mul_An_Bp184
   1A06 50            [ 2] 3008                  NEGB
   1A07 20 09         [ 3] 3009                  BRA           mul_An_Bn184
                           3010  .globl mul_Ap184
   1A09                    3011 mul_Ap184:
   1A09 5D            [ 2] 3012                  TSTB
   1A0A 2A 06         [ 3] 3013                  BPL           mul_Ap_Bp184
   1A0C 50            [ 2] 3014                  NEGB
                           3015  .globl mul_An_Bp184
   1A0D                    3016 mul_An_Bp184:
   1A0D 3D            [11] 3017                  MUL
   1A0E 53            [ 2] 3018                  COMB                              ; here we can use this as negd
   1A0F 43            [ 2] 3019                  COMA                              ; since the low nibble of b doesn't interest us
   1A10 20 01         [ 3] 3020                  BRA           mul_end184
                           3021  .globl mul_Ap_Bp184
   1A12                    3022 mul_Ap_Bp184:
                           3023  .globl mul_An_Bn184
   1A12                    3024 mul_An_Bn184:
   1A12 3D            [11] 3025                  MUL
                           3026  .globl mul_end184
   1A13                    3027 mul_end184:
   1A13 58            [ 2] 3028                  ASLB                              ; this divides d by 64
   1A14 49            [ 2] 3029                  ROLA
   1A15 58            [ 2] 3030                  ASLB
   1A16 49            [ 2] 3031                  ROLA
                           3032 
                           3033 ; macro call ->                  STORE_A _N10x
   1A17 B7 C9 37      [ 5] 3034                  STA           _N10x
                           3035 ; macro call ->                  A_EQUALS_MUL _helper, _sinz
   1A1A F6 C9 17      [ 5] 3036                  LDB           _sinz
   1A1D B6 C9 11      [ 5] 3037                  LDA           _helper
   1A20 2A 07         [ 3] 3038                  BPL           mul_Ap186
   1A22 40            [ 2] 3039                  NEGA
   1A23 5D            [ 2] 3040                  TSTB
   1A24 2A 07         [ 3] 3041                  BPL           mul_An_Bp186
   1A26 50            [ 2] 3042                  NEGB
   1A27 20 09         [ 3] 3043                  BRA           mul_An_Bn186
                           3044  .globl mul_Ap186
   1A29                    3045 mul_Ap186:
   1A29 5D            [ 2] 3046                  TSTB
   1A2A 2A 06         [ 3] 3047                  BPL           mul_Ap_Bp186
   1A2C 50            [ 2] 3048                  NEGB
                           3049  .globl mul_An_Bp186
   1A2D                    3050 mul_An_Bp186:
   1A2D 3D            [11] 3051                  MUL
   1A2E 53            [ 2] 3052                  COMB                              ; here we can use this as negd
   1A2F 43            [ 2] 3053                  COMA                              ; since the low nibble of b doesn't interest us
   1A30 20 01         [ 3] 3054                  BRA           mul_end186
                           3055  .globl mul_Ap_Bp186
   1A32                    3056 mul_Ap_Bp186:
                           3057  .globl mul_An_Bn186
   1A32                    3058 mul_An_Bn186:
   1A32 3D            [11] 3059                  MUL
                           3060  .globl mul_end186
   1A33                    3061 mul_end186:
   1A33 58            [ 2] 3062                  ASLB                              ; this divides d by 64
   1A34 49            [ 2] 3063                  ROLA
   1A35 58            [ 2] 3064                  ASLB
   1A36 49            [ 2] 3065                  ROLA
                           3066 
                           3067 ; macro call ->                  SUB_A_FROM _N10x
   1A37 40            [ 2] 3068                  NEGA
                           3069 ; macro call ->                  ADD_A_TO      _N10x
   1A38 BB C9 37      [ 5] 3070                  ADDA          _N10x
                           3071 ; macro call ->                  STORE_A       _N10x
   1A3B B7 C9 37      [ 5] 3072                  STA           _N10x
                           3073 ; macro call ->                  STORE_A_NEG _N10xi
   1A3E 40            [ 2] 3074                  NEGA
   1A3F B7 C9 61      [ 5] 3075                  STA           _N10xi
   1A42 B6 C9 1B      [ 5] 3076  lda _vectorBits
                           3077  .globl noN10
   1A45                    3078 noN10:
   1A45 85 02         [ 2] 3079  bita #TEST_N_0_1
   1A47 10 27 00 BF   [ 6] 3080  lbeq noN01
                           3081 ; macro call ->                     INIT_N_0_1_A  
                           3082 ; macro call ->                  CALC_N_0_1_A _N01x, _N01y, _N01z, _N01xi, _N01yi, _N01zi
   1A4B B6 C9 13      [ 5] 3083                  LDA _sinx
   1A4E B7 C9 3C      [ 5] 3084                  STA _N01z
   1A51 40            [ 2] 3085                  NEGA
   1A52 B7 C9 66      [ 5] 3086                  STA _N01zi
                           3087 ; macro call ->                  A_EQUALS_MUL _sinx, _siny
   1A55 F6 C9 15      [ 5] 3088                  LDB           _siny
   1A58 B6 C9 13      [ 5] 3089                  LDA           _sinx
   1A5B 2A 07         [ 3] 3090                  BPL           mul_Ap193
   1A5D 40            [ 2] 3091                  NEGA
   1A5E 5D            [ 2] 3092                  TSTB
   1A5F 2A 07         [ 3] 3093                  BPL           mul_An_Bp193
   1A61 50            [ 2] 3094                  NEGB
   1A62 20 09         [ 3] 3095                  BRA           mul_An_Bn193
                           3096  .globl mul_Ap193
   1A64                    3097 mul_Ap193:
   1A64 5D            [ 2] 3098                  TSTB
   1A65 2A 06         [ 3] 3099                  BPL           mul_Ap_Bp193
   1A67 50            [ 2] 3100                  NEGB
                           3101  .globl mul_An_Bp193
   1A68                    3102 mul_An_Bp193:
   1A68 3D            [11] 3103                  MUL
   1A69 53            [ 2] 3104                  COMB                              ; here we can use this as negd
   1A6A 43            [ 2] 3105                  COMA                              ; since the low nibble of b doesn't interest us
   1A6B 20 01         [ 3] 3106                  BRA           mul_end193
                           3107  .globl mul_Ap_Bp193
   1A6D                    3108 mul_Ap_Bp193:
                           3109  .globl mul_An_Bn193
   1A6D                    3110 mul_An_Bn193:
   1A6D 3D            [11] 3111                  MUL
                           3112  .globl mul_end193
   1A6E                    3113 mul_end193:
   1A6E 58            [ 2] 3114                  ASLB                              ; this divides d by 64
   1A6F 49            [ 2] 3115                  ROLA
   1A70 58            [ 2] 3116                  ASLB
   1A71 49            [ 2] 3117                  ROLA
                           3118 
   1A72 B0 C9 14      [ 5] 3119                  SUBA   _cosy
                           3120 ; macro call ->                  STORE_A _N01x
   1A75 B7 C9 3A      [ 5] 3121                  STA           _N01x
                           3122 ; macro call ->                  A_EQUALS_MUL _cosx, _cosz
   1A78 F6 C9 16      [ 5] 3123                  LDB           _cosz
   1A7B B6 C9 12      [ 5] 3124                  LDA           _cosx
   1A7E 2A 07         [ 3] 3125                  BPL           mul_Ap195
   1A80 40            [ 2] 3126                  NEGA
   1A81 5D            [ 2] 3127                  TSTB
   1A82 2A 07         [ 3] 3128                  BPL           mul_An_Bp195
   1A84 50            [ 2] 3129                  NEGB
   1A85 20 09         [ 3] 3130                  BRA           mul_An_Bn195
                           3131  .globl mul_Ap195
   1A87                    3132 mul_Ap195:
   1A87 5D            [ 2] 3133                  TSTB
   1A88 2A 06         [ 3] 3134                  BPL           mul_Ap_Bp195
   1A8A 50            [ 2] 3135                  NEGB
                           3136  .globl mul_An_Bp195
   1A8B                    3137 mul_An_Bp195:
   1A8B 3D            [11] 3138                  MUL
   1A8C 53            [ 2] 3139                  COMB                              ; here we can use this as negd
   1A8D 43            [ 2] 3140                  COMA                              ; since the low nibble of b doesn't interest us
   1A8E 20 01         [ 3] 3141                  BRA           mul_end195
                           3142  .globl mul_Ap_Bp195
   1A90                    3143 mul_Ap_Bp195:
                           3144  .globl mul_An_Bn195
   1A90                    3145 mul_An_Bn195:
   1A90 3D            [11] 3146                  MUL
                           3147  .globl mul_end195
   1A91                    3148 mul_end195:
   1A91 58            [ 2] 3149                  ASLB                              ; this divides d by 64
   1A92 49            [ 2] 3150                  ROLA
   1A93 58            [ 2] 3151                  ASLB
   1A94 49            [ 2] 3152                  ROLA
                           3153 
                           3154 ; macro call ->                  STORE_A _N01y
   1A95 B7 C9 3B      [ 5] 3155                  STA           _N01y
                           3156 ; macro call ->                  A_EQUALS_MUL _N01x, _sinz
   1A98 F6 C9 17      [ 5] 3157                  LDB           _sinz
   1A9B B6 C9 3A      [ 5] 3158                  LDA           _N01x
   1A9E 2A 07         [ 3] 3159                  BPL           mul_Ap197
   1AA0 40            [ 2] 3160                  NEGA
   1AA1 5D            [ 2] 3161                  TSTB
   1AA2 2A 07         [ 3] 3162                  BPL           mul_An_Bp197
   1AA4 50            [ 2] 3163                  NEGB
   1AA5 20 09         [ 3] 3164                  BRA           mul_An_Bn197
                           3165  .globl mul_Ap197
   1AA7                    3166 mul_Ap197:
   1AA7 5D            [ 2] 3167                  TSTB
   1AA8 2A 06         [ 3] 3168                  BPL           mul_Ap_Bp197
   1AAA 50            [ 2] 3169                  NEGB
                           3170  .globl mul_An_Bp197
   1AAB                    3171 mul_An_Bp197:
   1AAB 3D            [11] 3172                  MUL
   1AAC 53            [ 2] 3173                  COMB                              ; here we can use this as negd
   1AAD 43            [ 2] 3174                  COMA                              ; since the low nibble of b doesn't interest us
   1AAE 20 01         [ 3] 3175                  BRA           mul_end197
                           3176  .globl mul_Ap_Bp197
   1AB0                    3177 mul_Ap_Bp197:
                           3178  .globl mul_An_Bn197
   1AB0                    3179 mul_An_Bn197:
   1AB0 3D            [11] 3180                  MUL
                           3181  .globl mul_end197
   1AB1                    3182 mul_end197:
   1AB1 58            [ 2] 3183                  ASLB                              ; this divides d by 64
   1AB2 49            [ 2] 3184                  ROLA
   1AB3 58            [ 2] 3185                  ASLB
   1AB4 49            [ 2] 3186                  ROLA
                           3187 
                           3188 ; macro call ->                  ADD_A_TO _N01y
   1AB5 BB C9 3B      [ 5] 3189                  ADDA          _N01y
                           3190 ; macro call ->                  STORE_A       _N01y
   1AB8 B7 C9 3B      [ 5] 3191                  STA           _N01y
                           3192 ; macro call ->                  STORE_A_NEG _N01yi
   1ABB 40            [ 2] 3193                  NEGA
   1ABC B7 C9 65      [ 5] 3194                  STA           _N01yi
                           3195 ; macro call ->                  A_EQUALS_MUL _N01x, _cosz
   1ABF F6 C9 16      [ 5] 3196                  LDB           _cosz
   1AC2 B6 C9 3A      [ 5] 3197                  LDA           _N01x
   1AC5 2A 07         [ 3] 3198                  BPL           mul_Ap201
   1AC7 40            [ 2] 3199                  NEGA
   1AC8 5D            [ 2] 3200                  TSTB
   1AC9 2A 07         [ 3] 3201                  BPL           mul_An_Bp201
   1ACB 50            [ 2] 3202                  NEGB
   1ACC 20 09         [ 3] 3203                  BRA           mul_An_Bn201
                           3204  .globl mul_Ap201
   1ACE                    3205 mul_Ap201:
   1ACE 5D            [ 2] 3206                  TSTB
   1ACF 2A 06         [ 3] 3207                  BPL           mul_Ap_Bp201
   1AD1 50            [ 2] 3208                  NEGB
                           3209  .globl mul_An_Bp201
   1AD2                    3210 mul_An_Bp201:
   1AD2 3D            [11] 3211                  MUL
   1AD3 53            [ 2] 3212                  COMB                              ; here we can use this as negd
   1AD4 43            [ 2] 3213                  COMA                              ; since the low nibble of b doesn't interest us
   1AD5 20 01         [ 3] 3214                  BRA           mul_end201
                           3215  .globl mul_Ap_Bp201
   1AD7                    3216 mul_Ap_Bp201:
                           3217  .globl mul_An_Bn201
   1AD7                    3218 mul_An_Bn201:
   1AD7 3D            [11] 3219                  MUL
                           3220  .globl mul_end201
   1AD8                    3221 mul_end201:
   1AD8 58            [ 2] 3222                  ASLB                              ; this divides d by 64
   1AD9 49            [ 2] 3223                  ROLA
   1ADA 58            [ 2] 3224                  ASLB
   1ADB 49            [ 2] 3225                  ROLA
                           3226 
                           3227 ; macro call ->                  STORE_A _N01x
   1ADC B7 C9 3A      [ 5] 3228                  STA           _N01x
                           3229 ; macro call ->                  A_EQUALS_MUL _cosx, _sinz
   1ADF F6 C9 17      [ 5] 3230                  LDB           _sinz
   1AE2 B6 C9 12      [ 5] 3231                  LDA           _cosx
   1AE5 2A 07         [ 3] 3232                  BPL           mul_Ap203
   1AE7 40            [ 2] 3233                  NEGA
   1AE8 5D            [ 2] 3234                  TSTB
   1AE9 2A 07         [ 3] 3235                  BPL           mul_An_Bp203
   1AEB 50            [ 2] 3236                  NEGB
   1AEC 20 09         [ 3] 3237                  BRA           mul_An_Bn203
                           3238  .globl mul_Ap203
   1AEE                    3239 mul_Ap203:
   1AEE 5D            [ 2] 3240                  TSTB
   1AEF 2A 06         [ 3] 3241                  BPL           mul_Ap_Bp203
   1AF1 50            [ 2] 3242                  NEGB
                           3243  .globl mul_An_Bp203
   1AF2                    3244 mul_An_Bp203:
   1AF2 3D            [11] 3245                  MUL
   1AF3 53            [ 2] 3246                  COMB                              ; here we can use this as negd
   1AF4 43            [ 2] 3247                  COMA                              ; since the low nibble of b doesn't interest us
   1AF5 20 01         [ 3] 3248                  BRA           mul_end203
                           3249  .globl mul_Ap_Bp203
   1AF7                    3250 mul_Ap_Bp203:
                           3251  .globl mul_An_Bn203
   1AF7                    3252 mul_An_Bn203:
   1AF7 3D            [11] 3253                  MUL
                           3254  .globl mul_end203
   1AF8                    3255 mul_end203:
   1AF8 58            [ 2] 3256                  ASLB                              ; this divides d by 64
   1AF9 49            [ 2] 3257                  ROLA
   1AFA 58            [ 2] 3258                  ASLB
   1AFB 49            [ 2] 3259                  ROLA
                           3260 
                           3261 ; macro call ->                  SUB_A_FROM _N01x
   1AFC 40            [ 2] 3262                  NEGA
                           3263 ; macro call ->                  ADD_A_TO      _N01x
   1AFD BB C9 3A      [ 5] 3264                  ADDA          _N01x
                           3265 ; macro call ->                  STORE_A       _N01x
   1B00 B7 C9 3A      [ 5] 3266                  STA           _N01x
                           3267 ; macro call ->                  STORE_A_NEG _N01xi
   1B03 40            [ 2] 3268                  NEGA
   1B04 B7 C9 64      [ 5] 3269                  STA           _N01xi
   1B07 B6 C9 1B      [ 5] 3270  lda _vectorBits
                           3271  .globl noN01
   1B0A                    3272 noN01:
   1B0A 85 04         [ 2] 3273  bita #TEST_0_N_1
   1B0C 10 27 00 D1   [ 6] 3274  lbeq no0N1
                           3275 ; macro call ->                     INIT_0_N_1_A  
                           3276 ; macro call ->                  CALC_0_N_1_A _0N1x, _0N1y, _0N1z, _0N1xi, _0N1yi, _0N1zi
   1B10 B6 C9 13      [ 5] 3277                  LDA _sinx
   1B13 B0 C9 12      [ 5] 3278                  SUBA _cosx
   1B16 B7 C9 3F      [ 5] 3279                  STA _0N1z
   1B19 40            [ 2] 3280                  NEGA
   1B1A B7 C9 69      [ 5] 3281                  STA _0N1zi
   1B1D B6 C9 13      [ 5] 3282                  LDA   _sinx
   1B20 B0 C9 12      [ 5] 3283                  SUBA  _cosx
   1B23 B7 C9 3F      [ 5] 3284                  STA   _0N1z
   1B26 B6 C9 12      [ 5] 3285                  LDA   _cosx
   1B29 BB C9 13      [ 5] 3286                  ADDA  _sinx
   1B2C B7 C9 11      [ 5] 3287                  STA   _helper
                           3288 ; macro call ->                  A_EQUALS_MUL _0N1z, _siny
   1B2F F6 C9 15      [ 5] 3289                  LDB           _siny
   1B32 B6 C9 3F      [ 5] 3290                  LDA           _0N1z
   1B35 2A 07         [ 3] 3291                  BPL           mul_Ap210
   1B37 40            [ 2] 3292                  NEGA
   1B38 5D            [ 2] 3293                  TSTB
   1B39 2A 07         [ 3] 3294                  BPL           mul_An_Bp210
   1B3B 50            [ 2] 3295                  NEGB
   1B3C 20 09         [ 3] 3296                  BRA           mul_An_Bn210
                           3297  .globl mul_Ap210
   1B3E                    3298 mul_Ap210:
   1B3E 5D            [ 2] 3299                  TSTB
   1B3F 2A 06         [ 3] 3300                  BPL           mul_Ap_Bp210
   1B41 50            [ 2] 3301                  NEGB
                           3302  .globl mul_An_Bp210
   1B42                    3303 mul_An_Bp210:
   1B42 3D            [11] 3304                  MUL
   1B43 53            [ 2] 3305                  COMB                              ; here we can use this as negd
   1B44 43            [ 2] 3306                  COMA                              ; since the low nibble of b doesn't interest us
   1B45 20 01         [ 3] 3307                  BRA           mul_end210
                           3308  .globl mul_Ap_Bp210
   1B47                    3309 mul_Ap_Bp210:
                           3310  .globl mul_An_Bn210
   1B47                    3311 mul_An_Bn210:
   1B47 3D            [11] 3312                  MUL
                           3313  .globl mul_end210
   1B48                    3314 mul_end210:
   1B48 58            [ 2] 3315                  ASLB                              ; this divides d by 64
   1B49 49            [ 2] 3316                  ROLA
   1B4A 58            [ 2] 3317                  ASLB
   1B4B 49            [ 2] 3318                  ROLA
                           3319 
                           3320 ; macro call ->                  STORE_A _0N1x
   1B4C B7 C9 3D      [ 5] 3321                  STA           _0N1x
                           3322 ; macro call ->                  A_EQUALS_MUL _helper, _cosz
   1B4F F6 C9 16      [ 5] 3323                  LDB           _cosz
   1B52 B6 C9 11      [ 5] 3324                  LDA           _helper
   1B55 2A 07         [ 3] 3325                  BPL           mul_Ap212
   1B57 40            [ 2] 3326                  NEGA
   1B58 5D            [ 2] 3327                  TSTB
   1B59 2A 07         [ 3] 3328                  BPL           mul_An_Bp212
   1B5B 50            [ 2] 3329                  NEGB
   1B5C 20 09         [ 3] 3330                  BRA           mul_An_Bn212
                           3331  .globl mul_Ap212
   1B5E                    3332 mul_Ap212:
   1B5E 5D            [ 2] 3333                  TSTB
   1B5F 2A 06         [ 3] 3334                  BPL           mul_Ap_Bp212
   1B61 50            [ 2] 3335                  NEGB
                           3336  .globl mul_An_Bp212
   1B62                    3337 mul_An_Bp212:
   1B62 3D            [11] 3338                  MUL
   1B63 53            [ 2] 3339                  COMB                              ; here we can use this as negd
   1B64 43            [ 2] 3340                  COMA                              ; since the low nibble of b doesn't interest us
   1B65 20 01         [ 3] 3341                  BRA           mul_end212
                           3342  .globl mul_Ap_Bp212
   1B67                    3343 mul_Ap_Bp212:
                           3344  .globl mul_An_Bn212
   1B67                    3345 mul_An_Bn212:
   1B67 3D            [11] 3346                  MUL
                           3347  .globl mul_end212
   1B68                    3348 mul_end212:
   1B68 58            [ 2] 3349                  ASLB                              ; this divides d by 64
   1B69 49            [ 2] 3350                  ROLA
   1B6A 58            [ 2] 3351                  ASLB
   1B6B 49            [ 2] 3352                  ROLA
                           3353 
                           3354 ; macro call ->                  STORE_A _0N1y
   1B6C B7 C9 3E      [ 5] 3355                  STA           _0N1y
                           3356 ; macro call ->                  A_EQUALS_MUL _0N1x, _sinz
   1B6F F6 C9 17      [ 5] 3357                  LDB           _sinz
   1B72 B6 C9 3D      [ 5] 3358                  LDA           _0N1x
   1B75 2A 07         [ 3] 3359                  BPL           mul_Ap214
   1B77 40            [ 2] 3360                  NEGA
   1B78 5D            [ 2] 3361                  TSTB
   1B79 2A 07         [ 3] 3362                  BPL           mul_An_Bp214
   1B7B 50            [ 2] 3363                  NEGB
   1B7C 20 09         [ 3] 3364                  BRA           mul_An_Bn214
                           3365  .globl mul_Ap214
   1B7E                    3366 mul_Ap214:
   1B7E 5D            [ 2] 3367                  TSTB
   1B7F 2A 06         [ 3] 3368                  BPL           mul_Ap_Bp214
   1B81 50            [ 2] 3369                  NEGB
                           3370  .globl mul_An_Bp214
   1B82                    3371 mul_An_Bp214:
   1B82 3D            [11] 3372                  MUL
   1B83 53            [ 2] 3373                  COMB                              ; here we can use this as negd
   1B84 43            [ 2] 3374                  COMA                              ; since the low nibble of b doesn't interest us
   1B85 20 01         [ 3] 3375                  BRA           mul_end214
                           3376  .globl mul_Ap_Bp214
   1B87                    3377 mul_Ap_Bp214:
                           3378  .globl mul_An_Bn214
   1B87                    3379 mul_An_Bn214:
   1B87 3D            [11] 3380                  MUL
                           3381  .globl mul_end214
   1B88                    3382 mul_end214:
   1B88 58            [ 2] 3383                  ASLB                              ; this divides d by 64
   1B89 49            [ 2] 3384                  ROLA
   1B8A 58            [ 2] 3385                  ASLB
   1B8B 49            [ 2] 3386                  ROLA
                           3387 
                           3388 ; macro call ->                  ADD_A_TO _0N1y
   1B8C BB C9 3E      [ 5] 3389                  ADDA          _0N1y
                           3390 ; macro call ->                  STORE_A       _0N1y
   1B8F B7 C9 3E      [ 5] 3391                  STA           _0N1y
                           3392 ; macro call ->                  STORE_A_NEG _0N1yi
   1B92 40            [ 2] 3393                  NEGA
   1B93 B7 C9 68      [ 5] 3394                  STA           _0N1yi
                           3395 ; macro call ->                  A_EQUALS_MUL _0N1x, _cosz
   1B96 F6 C9 16      [ 5] 3396                  LDB           _cosz
   1B99 B6 C9 3D      [ 5] 3397                  LDA           _0N1x
   1B9C 2A 07         [ 3] 3398                  BPL           mul_Ap218
   1B9E 40            [ 2] 3399                  NEGA
   1B9F 5D            [ 2] 3400                  TSTB
   1BA0 2A 07         [ 3] 3401                  BPL           mul_An_Bp218
   1BA2 50            [ 2] 3402                  NEGB
   1BA3 20 09         [ 3] 3403                  BRA           mul_An_Bn218
                           3404  .globl mul_Ap218
   1BA5                    3405 mul_Ap218:
   1BA5 5D            [ 2] 3406                  TSTB
   1BA6 2A 06         [ 3] 3407                  BPL           mul_Ap_Bp218
   1BA8 50            [ 2] 3408                  NEGB
                           3409  .globl mul_An_Bp218
   1BA9                    3410 mul_An_Bp218:
   1BA9 3D            [11] 3411                  MUL
   1BAA 53            [ 2] 3412                  COMB                              ; here we can use this as negd
   1BAB 43            [ 2] 3413                  COMA                              ; since the low nibble of b doesn't interest us
   1BAC 20 01         [ 3] 3414                  BRA           mul_end218
                           3415  .globl mul_Ap_Bp218
   1BAE                    3416 mul_Ap_Bp218:
                           3417  .globl mul_An_Bn218
   1BAE                    3418 mul_An_Bn218:
   1BAE 3D            [11] 3419                  MUL
                           3420  .globl mul_end218
   1BAF                    3421 mul_end218:
   1BAF 58            [ 2] 3422                  ASLB                              ; this divides d by 64
   1BB0 49            [ 2] 3423                  ROLA
   1BB1 58            [ 2] 3424                  ASLB
   1BB2 49            [ 2] 3425                  ROLA
                           3426 
                           3427 ; macro call ->                  STORE_A _0N1x
   1BB3 B7 C9 3D      [ 5] 3428                  STA           _0N1x
                           3429 ; macro call ->                  A_EQUALS_MUL _helper, _sinz
   1BB6 F6 C9 17      [ 5] 3430                  LDB           _sinz
   1BB9 B6 C9 11      [ 5] 3431                  LDA           _helper
   1BBC 2A 07         [ 3] 3432                  BPL           mul_Ap220
   1BBE 40            [ 2] 3433                  NEGA
   1BBF 5D            [ 2] 3434                  TSTB
   1BC0 2A 07         [ 3] 3435                  BPL           mul_An_Bp220
   1BC2 50            [ 2] 3436                  NEGB
   1BC3 20 09         [ 3] 3437                  BRA           mul_An_Bn220
                           3438  .globl mul_Ap220
   1BC5                    3439 mul_Ap220:
   1BC5 5D            [ 2] 3440                  TSTB
   1BC6 2A 06         [ 3] 3441                  BPL           mul_Ap_Bp220
   1BC8 50            [ 2] 3442                  NEGB
                           3443  .globl mul_An_Bp220
   1BC9                    3444 mul_An_Bp220:
   1BC9 3D            [11] 3445                  MUL
   1BCA 53            [ 2] 3446                  COMB                              ; here we can use this as negd
   1BCB 43            [ 2] 3447                  COMA                              ; since the low nibble of b doesn't interest us
   1BCC 20 01         [ 3] 3448                  BRA           mul_end220
                           3449  .globl mul_Ap_Bp220
   1BCE                    3450 mul_Ap_Bp220:
                           3451  .globl mul_An_Bn220
   1BCE                    3452 mul_An_Bn220:
   1BCE 3D            [11] 3453                  MUL
                           3454  .globl mul_end220
   1BCF                    3455 mul_end220:
   1BCF 58            [ 2] 3456                  ASLB                              ; this divides d by 64
   1BD0 49            [ 2] 3457                  ROLA
   1BD1 58            [ 2] 3458                  ASLB
   1BD2 49            [ 2] 3459                  ROLA
                           3460 
                           3461 ; macro call ->                  SUB_A_FROM _0N1x
   1BD3 40            [ 2] 3462                  NEGA
                           3463 ; macro call ->                  ADD_A_TO      _0N1x
   1BD4 BB C9 3D      [ 5] 3464                  ADDA          _0N1x
                           3465 ; macro call ->                  STORE_A       _0N1x
   1BD7 B7 C9 3D      [ 5] 3466                  STA           _0N1x
                           3467 ; macro call ->                  STORE_A_NEG _0N1xi
   1BDA 40            [ 2] 3468                  NEGA
   1BDB B7 C9 67      [ 5] 3469                  STA           _0N1xi
   1BDE B6 C9 1B      [ 5] 3470  lda _vectorBits
                           3471  .globl no0N1
   1BE1                    3472 no0N1:
   1BE1 85 08         [ 2] 3473  bita #TEST_N_1_1
   1BE3 10 27 00 D4   [ 6] 3474  lbeq noN11
                           3475 ; macro call ->                     INIT_N_1_1_A  
                           3476 ; macro call ->                  CALC_N_1_1_A _N11x, _N11y, _N11z, _N11xi, _N11yi, _N11zi
   1BE7 B6 C9 12      [ 5] 3477                  LDA _cosx
   1BEA BB C9 13      [ 5] 3478                  ADDA _sinx
   1BED B7 C9 42      [ 5] 3479                  STA _N11z
   1BF0 40            [ 2] 3480                  NEGA
   1BF1 B7 C9 6C      [ 5] 3481                  STA _N11zi
   1BF4 B6 C9 13      [ 5] 3482                  LDA   _sinx
   1BF7 BB C9 12      [ 5] 3483                  ADDA  _cosx
   1BFA B7 C9 42      [ 5] 3484                  STA   _N11z
                           3485 
   1BFD B6 C9 12      [ 5] 3486                  LDA   _cosx
   1C00 B0 C9 13      [ 5] 3487                  SUBA  _sinx
   1C03 B7 C9 11      [ 5] 3488                  STA   _helper
                           3489 
                           3490 ; macro call ->                  A_EQUALS_MUL _N11z, _siny
   1C06 F6 C9 15      [ 5] 3491                  LDB           _siny
   1C09 B6 C9 42      [ 5] 3492                  LDA           _N11z
   1C0C 2A 07         [ 3] 3493                  BPL           mul_Ap227
   1C0E 40            [ 2] 3494                  NEGA
   1C0F 5D            [ 2] 3495                  TSTB
   1C10 2A 07         [ 3] 3496                  BPL           mul_An_Bp227
   1C12 50            [ 2] 3497                  NEGB
   1C13 20 09         [ 3] 3498                  BRA           mul_An_Bn227
                           3499  .globl mul_Ap227
   1C15                    3500 mul_Ap227:
   1C15 5D            [ 2] 3501                  TSTB
   1C16 2A 06         [ 3] 3502                  BPL           mul_Ap_Bp227
   1C18 50            [ 2] 3503                  NEGB
                           3504  .globl mul_An_Bp227
   1C19                    3505 mul_An_Bp227:
   1C19 3D            [11] 3506                  MUL
   1C1A 53            [ 2] 3507                  COMB                              ; here we can use this as negd
   1C1B 43            [ 2] 3508                  COMA                              ; since the low nibble of b doesn't interest us
   1C1C 20 01         [ 3] 3509                  BRA           mul_end227
                           3510  .globl mul_Ap_Bp227
   1C1E                    3511 mul_Ap_Bp227:
                           3512  .globl mul_An_Bn227
   1C1E                    3513 mul_An_Bn227:
   1C1E 3D            [11] 3514                  MUL
                           3515  .globl mul_end227
   1C1F                    3516 mul_end227:
   1C1F 58            [ 2] 3517                  ASLB                              ; this divides d by 64
   1C20 49            [ 2] 3518                  ROLA
   1C21 58            [ 2] 3519                  ASLB
   1C22 49            [ 2] 3520                  ROLA
                           3521 
   1C23 B0 C9 14      [ 5] 3522                  SUBA  _cosy
                           3523 ; macro call ->                  STORE_A _N11x
   1C26 B7 C9 40      [ 5] 3524                  STA           _N11x
                           3525 ; macro call ->                  A_EQUALS_MUL _helper, _cosz
   1C29 F6 C9 16      [ 5] 3526                  LDB           _cosz
   1C2C B6 C9 11      [ 5] 3527                  LDA           _helper
   1C2F 2A 07         [ 3] 3528                  BPL           mul_Ap229
   1C31 40            [ 2] 3529                  NEGA
   1C32 5D            [ 2] 3530                  TSTB
   1C33 2A 07         [ 3] 3531                  BPL           mul_An_Bp229
   1C35 50            [ 2] 3532                  NEGB
   1C36 20 09         [ 3] 3533                  BRA           mul_An_Bn229
                           3534  .globl mul_Ap229
   1C38                    3535 mul_Ap229:
   1C38 5D            [ 2] 3536                  TSTB
   1C39 2A 06         [ 3] 3537                  BPL           mul_Ap_Bp229
   1C3B 50            [ 2] 3538                  NEGB
                           3539  .globl mul_An_Bp229
   1C3C                    3540 mul_An_Bp229:
   1C3C 3D            [11] 3541                  MUL
   1C3D 53            [ 2] 3542                  COMB                              ; here we can use this as negd
   1C3E 43            [ 2] 3543                  COMA                              ; since the low nibble of b doesn't interest us
   1C3F 20 01         [ 3] 3544                  BRA           mul_end229
                           3545  .globl mul_Ap_Bp229
   1C41                    3546 mul_Ap_Bp229:
                           3547  .globl mul_An_Bn229
   1C41                    3548 mul_An_Bn229:
   1C41 3D            [11] 3549                  MUL
                           3550  .globl mul_end229
   1C42                    3551 mul_end229:
   1C42 58            [ 2] 3552                  ASLB                              ; this divides d by 64
   1C43 49            [ 2] 3553                  ROLA
   1C44 58            [ 2] 3554                  ASLB
   1C45 49            [ 2] 3555                  ROLA
                           3556 
                           3557 ; macro call ->                  STORE_A _N11y
   1C46 B7 C9 41      [ 5] 3558                  STA           _N11y
                           3559 ; macro call ->                  A_EQUALS_MUL _N11x, _sinz
   1C49 F6 C9 17      [ 5] 3560                  LDB           _sinz
   1C4C B6 C9 40      [ 5] 3561                  LDA           _N11x
   1C4F 2A 07         [ 3] 3562                  BPL           mul_Ap231
   1C51 40            [ 2] 3563                  NEGA
   1C52 5D            [ 2] 3564                  TSTB
   1C53 2A 07         [ 3] 3565                  BPL           mul_An_Bp231
   1C55 50            [ 2] 3566                  NEGB
   1C56 20 09         [ 3] 3567                  BRA           mul_An_Bn231
                           3568  .globl mul_Ap231
   1C58                    3569 mul_Ap231:
   1C58 5D            [ 2] 3570                  TSTB
   1C59 2A 06         [ 3] 3571                  BPL           mul_Ap_Bp231
   1C5B 50            [ 2] 3572                  NEGB
                           3573  .globl mul_An_Bp231
   1C5C                    3574 mul_An_Bp231:
   1C5C 3D            [11] 3575                  MUL
   1C5D 53            [ 2] 3576                  COMB                              ; here we can use this as negd
   1C5E 43            [ 2] 3577                  COMA                              ; since the low nibble of b doesn't interest us
   1C5F 20 01         [ 3] 3578                  BRA           mul_end231
                           3579  .globl mul_Ap_Bp231
   1C61                    3580 mul_Ap_Bp231:
                           3581  .globl mul_An_Bn231
   1C61                    3582 mul_An_Bn231:
   1C61 3D            [11] 3583                  MUL
                           3584  .globl mul_end231
   1C62                    3585 mul_end231:
   1C62 58            [ 2] 3586                  ASLB                              ; this divides d by 64
   1C63 49            [ 2] 3587                  ROLA
   1C64 58            [ 2] 3588                  ASLB
   1C65 49            [ 2] 3589                  ROLA
                           3590 
                           3591 ; macro call ->                  ADD_A_TO _N11y
   1C66 BB C9 41      [ 5] 3592                  ADDA          _N11y
                           3593 ; macro call ->                  STORE_A       _N11y
   1C69 B7 C9 41      [ 5] 3594                  STA           _N11y
                           3595 ; macro call ->                  STORE_A_NEG _N11yi
   1C6C 40            [ 2] 3596                  NEGA
   1C6D B7 C9 6B      [ 5] 3597                  STA           _N11yi
                           3598 ; macro call ->                  A_EQUALS_MUL _N11x, _cosz
   1C70 F6 C9 16      [ 5] 3599                  LDB           _cosz
   1C73 B6 C9 40      [ 5] 3600                  LDA           _N11x
   1C76 2A 07         [ 3] 3601                  BPL           mul_Ap235
   1C78 40            [ 2] 3602                  NEGA
   1C79 5D            [ 2] 3603                  TSTB
   1C7A 2A 07         [ 3] 3604                  BPL           mul_An_Bp235
   1C7C 50            [ 2] 3605                  NEGB
   1C7D 20 09         [ 3] 3606                  BRA           mul_An_Bn235
                           3607  .globl mul_Ap235
   1C7F                    3608 mul_Ap235:
   1C7F 5D            [ 2] 3609                  TSTB
   1C80 2A 06         [ 3] 3610                  BPL           mul_Ap_Bp235
   1C82 50            [ 2] 3611                  NEGB
                           3612  .globl mul_An_Bp235
   1C83                    3613 mul_An_Bp235:
   1C83 3D            [11] 3614                  MUL
   1C84 53            [ 2] 3615                  COMB                              ; here we can use this as negd
   1C85 43            [ 2] 3616                  COMA                              ; since the low nibble of b doesn't interest us
   1C86 20 01         [ 3] 3617                  BRA           mul_end235
                           3618  .globl mul_Ap_Bp235
   1C88                    3619 mul_Ap_Bp235:
                           3620  .globl mul_An_Bn235
   1C88                    3621 mul_An_Bn235:
   1C88 3D            [11] 3622                  MUL
                           3623  .globl mul_end235
   1C89                    3624 mul_end235:
   1C89 58            [ 2] 3625                  ASLB                              ; this divides d by 64
   1C8A 49            [ 2] 3626                  ROLA
   1C8B 58            [ 2] 3627                  ASLB
   1C8C 49            [ 2] 3628                  ROLA
                           3629 
                           3630 ; macro call ->                  STORE_A _N11x
   1C8D B7 C9 40      [ 5] 3631                  STA           _N11x
                           3632 ; macro call ->                  A_EQUALS_MUL _helper, _sinz
   1C90 F6 C9 17      [ 5] 3633                  LDB           _sinz
   1C93 B6 C9 11      [ 5] 3634                  LDA           _helper
   1C96 2A 07         [ 3] 3635                  BPL           mul_Ap237
   1C98 40            [ 2] 3636                  NEGA
   1C99 5D            [ 2] 3637                  TSTB
   1C9A 2A 07         [ 3] 3638                  BPL           mul_An_Bp237
   1C9C 50            [ 2] 3639                  NEGB
   1C9D 20 09         [ 3] 3640                  BRA           mul_An_Bn237
                           3641  .globl mul_Ap237
   1C9F                    3642 mul_Ap237:
   1C9F 5D            [ 2] 3643                  TSTB
   1CA0 2A 06         [ 3] 3644                  BPL           mul_Ap_Bp237
   1CA2 50            [ 2] 3645                  NEGB
                           3646  .globl mul_An_Bp237
   1CA3                    3647 mul_An_Bp237:
   1CA3 3D            [11] 3648                  MUL
   1CA4 53            [ 2] 3649                  COMB                              ; here we can use this as negd
   1CA5 43            [ 2] 3650                  COMA                              ; since the low nibble of b doesn't interest us
   1CA6 20 01         [ 3] 3651                  BRA           mul_end237
                           3652  .globl mul_Ap_Bp237
   1CA8                    3653 mul_Ap_Bp237:
                           3654  .globl mul_An_Bn237
   1CA8                    3655 mul_An_Bn237:
   1CA8 3D            [11] 3656                  MUL
                           3657  .globl mul_end237
   1CA9                    3658 mul_end237:
   1CA9 58            [ 2] 3659                  ASLB                              ; this divides d by 64
   1CAA 49            [ 2] 3660                  ROLA
   1CAB 58            [ 2] 3661                  ASLB
   1CAC 49            [ 2] 3662                  ROLA
                           3663 
                           3664 ; macro call ->                  SUB_A_FROM _N11x
   1CAD 40            [ 2] 3665                  NEGA
                           3666 ; macro call ->                  ADD_A_TO      _N11x
   1CAE BB C9 40      [ 5] 3667                  ADDA          _N11x
                           3668 ; macro call ->                  STORE_A       _N11x
   1CB1 B7 C9 40      [ 5] 3669                  STA           _N11x
                           3670 ; macro call ->                  STORE_A_NEG _N11xi
   1CB4 40            [ 2] 3671                  NEGA
   1CB5 B7 C9 6A      [ 5] 3672                  STA           _N11xi
   1CB8 B6 C9 1B      [ 5] 3673  lda _vectorBits
                           3674  .globl noN11
   1CBB                    3675 noN11:
   1CBB 85 10         [ 2] 3676  bita #TEST_1_N_1
   1CBD 10 27 00 D4   [ 6] 3677  lbeq no1N1
                           3678 ; macro call ->                     INIT_1_N_1_A  
                           3679 ; macro call ->                  CALC_1_N_1_A _1N1x, _1N1y, _1N1z, _1N1xi, _1N1yi, _1N1zi
   1CC1 B6 C9 13      [ 5] 3680                  LDA _sinx
   1CC4 B0 C9 12      [ 5] 3681                  SUBA _cosx
   1CC7 B7 C9 45      [ 5] 3682                  STA _1N1z
   1CCA 40            [ 2] 3683                  NEGA
   1CCB B7 C9 6F      [ 5] 3684                  STA _1N1zi
   1CCE B6 C9 13      [ 5] 3685                  LDA   _sinx
   1CD1 B0 C9 12      [ 5] 3686                  SUBA  _cosx
   1CD4 B7 C9 45      [ 5] 3687                  STA   _1N1z
                           3688 
   1CD7 B6 C9 12      [ 5] 3689                  LDA   _cosx
   1CDA BB C9 13      [ 5] 3690                  ADDA  _sinx
   1CDD B7 C9 11      [ 5] 3691                  STA   _helper
                           3692 
                           3693 ; macro call ->                  A_EQUALS_MUL _1N1z, _siny
   1CE0 F6 C9 15      [ 5] 3694                  LDB           _siny
   1CE3 B6 C9 45      [ 5] 3695                  LDA           _1N1z
   1CE6 2A 07         [ 3] 3696                  BPL           mul_Ap244
   1CE8 40            [ 2] 3697                  NEGA
   1CE9 5D            [ 2] 3698                  TSTB
   1CEA 2A 07         [ 3] 3699                  BPL           mul_An_Bp244
   1CEC 50            [ 2] 3700                  NEGB
   1CED 20 09         [ 3] 3701                  BRA           mul_An_Bn244
                           3702  .globl mul_Ap244
   1CEF                    3703 mul_Ap244:
   1CEF 5D            [ 2] 3704                  TSTB
   1CF0 2A 06         [ 3] 3705                  BPL           mul_Ap_Bp244
   1CF2 50            [ 2] 3706                  NEGB
                           3707  .globl mul_An_Bp244
   1CF3                    3708 mul_An_Bp244:
   1CF3 3D            [11] 3709                  MUL
   1CF4 53            [ 2] 3710                  COMB                              ; here we can use this as negd
   1CF5 43            [ 2] 3711                  COMA                              ; since the low nibble of b doesn't interest us
   1CF6 20 01         [ 3] 3712                  BRA           mul_end244
                           3713  .globl mul_Ap_Bp244
   1CF8                    3714 mul_Ap_Bp244:
                           3715  .globl mul_An_Bn244
   1CF8                    3716 mul_An_Bn244:
   1CF8 3D            [11] 3717                  MUL
                           3718  .globl mul_end244
   1CF9                    3719 mul_end244:
   1CF9 58            [ 2] 3720                  ASLB                              ; this divides d by 64
   1CFA 49            [ 2] 3721                  ROLA
   1CFB 58            [ 2] 3722                  ASLB
   1CFC 49            [ 2] 3723                  ROLA
                           3724 
   1CFD BB C9 14      [ 5] 3725                  ADDA  _cosy
                           3726 ; macro call ->                  STORE_A _1N1x
   1D00 B7 C9 43      [ 5] 3727                  STA           _1N1x
                           3728 ; macro call ->                  A_EQUALS_MUL _helper, _cosz
   1D03 F6 C9 16      [ 5] 3729                  LDB           _cosz
   1D06 B6 C9 11      [ 5] 3730                  LDA           _helper
   1D09 2A 07         [ 3] 3731                  BPL           mul_Ap246
   1D0B 40            [ 2] 3732                  NEGA
   1D0C 5D            [ 2] 3733                  TSTB
   1D0D 2A 07         [ 3] 3734                  BPL           mul_An_Bp246
   1D0F 50            [ 2] 3735                  NEGB
   1D10 20 09         [ 3] 3736                  BRA           mul_An_Bn246
                           3737  .globl mul_Ap246
   1D12                    3738 mul_Ap246:
   1D12 5D            [ 2] 3739                  TSTB
   1D13 2A 06         [ 3] 3740                  BPL           mul_Ap_Bp246
   1D15 50            [ 2] 3741                  NEGB
                           3742  .globl mul_An_Bp246
   1D16                    3743 mul_An_Bp246:
   1D16 3D            [11] 3744                  MUL
   1D17 53            [ 2] 3745                  COMB                              ; here we can use this as negd
   1D18 43            [ 2] 3746                  COMA                              ; since the low nibble of b doesn't interest us
   1D19 20 01         [ 3] 3747                  BRA           mul_end246
                           3748  .globl mul_Ap_Bp246
   1D1B                    3749 mul_Ap_Bp246:
                           3750  .globl mul_An_Bn246
   1D1B                    3751 mul_An_Bn246:
   1D1B 3D            [11] 3752                  MUL
                           3753  .globl mul_end246
   1D1C                    3754 mul_end246:
   1D1C 58            [ 2] 3755                  ASLB                              ; this divides d by 64
   1D1D 49            [ 2] 3756                  ROLA
   1D1E 58            [ 2] 3757                  ASLB
   1D1F 49            [ 2] 3758                  ROLA
                           3759 
                           3760 ; macro call ->                  STORE_A _1N1y
   1D20 B7 C9 44      [ 5] 3761                  STA           _1N1y
                           3762 ; macro call ->                  A_EQUALS_MUL _1N1x, _sinz
   1D23 F6 C9 17      [ 5] 3763                  LDB           _sinz
   1D26 B6 C9 43      [ 5] 3764                  LDA           _1N1x
   1D29 2A 07         [ 3] 3765                  BPL           mul_Ap248
   1D2B 40            [ 2] 3766                  NEGA
   1D2C 5D            [ 2] 3767                  TSTB
   1D2D 2A 07         [ 3] 3768                  BPL           mul_An_Bp248
   1D2F 50            [ 2] 3769                  NEGB
   1D30 20 09         [ 3] 3770                  BRA           mul_An_Bn248
                           3771  .globl mul_Ap248
   1D32                    3772 mul_Ap248:
   1D32 5D            [ 2] 3773                  TSTB
   1D33 2A 06         [ 3] 3774                  BPL           mul_Ap_Bp248
   1D35 50            [ 2] 3775                  NEGB
                           3776  .globl mul_An_Bp248
   1D36                    3777 mul_An_Bp248:
   1D36 3D            [11] 3778                  MUL
   1D37 53            [ 2] 3779                  COMB                              ; here we can use this as negd
   1D38 43            [ 2] 3780                  COMA                              ; since the low nibble of b doesn't interest us
   1D39 20 01         [ 3] 3781                  BRA           mul_end248
                           3782  .globl mul_Ap_Bp248
   1D3B                    3783 mul_Ap_Bp248:
                           3784  .globl mul_An_Bn248
   1D3B                    3785 mul_An_Bn248:
   1D3B 3D            [11] 3786                  MUL
                           3787  .globl mul_end248
   1D3C                    3788 mul_end248:
   1D3C 58            [ 2] 3789                  ASLB                              ; this divides d by 64
   1D3D 49            [ 2] 3790                  ROLA
   1D3E 58            [ 2] 3791                  ASLB
   1D3F 49            [ 2] 3792                  ROLA
                           3793 
                           3794 ; macro call ->                  ADD_A_TO _1N1y
   1D40 BB C9 44      [ 5] 3795                  ADDA          _1N1y
                           3796 ; macro call ->                  STORE_A       _1N1y
   1D43 B7 C9 44      [ 5] 3797                  STA           _1N1y
                           3798 ; macro call ->                  STORE_A_NEG _1N1yi
   1D46 40            [ 2] 3799                  NEGA
   1D47 B7 C9 6E      [ 5] 3800                  STA           _1N1yi
                           3801 ; macro call ->                  A_EQUALS_MUL _1N1x, _cosz
   1D4A F6 C9 16      [ 5] 3802                  LDB           _cosz
   1D4D B6 C9 43      [ 5] 3803                  LDA           _1N1x
   1D50 2A 07         [ 3] 3804                  BPL           mul_Ap252
   1D52 40            [ 2] 3805                  NEGA
   1D53 5D            [ 2] 3806                  TSTB
   1D54 2A 07         [ 3] 3807                  BPL           mul_An_Bp252
   1D56 50            [ 2] 3808                  NEGB
   1D57 20 09         [ 3] 3809                  BRA           mul_An_Bn252
                           3810  .globl mul_Ap252
   1D59                    3811 mul_Ap252:
   1D59 5D            [ 2] 3812                  TSTB
   1D5A 2A 06         [ 3] 3813                  BPL           mul_Ap_Bp252
   1D5C 50            [ 2] 3814                  NEGB
                           3815  .globl mul_An_Bp252
   1D5D                    3816 mul_An_Bp252:
   1D5D 3D            [11] 3817                  MUL
   1D5E 53            [ 2] 3818                  COMB                              ; here we can use this as negd
   1D5F 43            [ 2] 3819                  COMA                              ; since the low nibble of b doesn't interest us
   1D60 20 01         [ 3] 3820                  BRA           mul_end252
                           3821  .globl mul_Ap_Bp252
   1D62                    3822 mul_Ap_Bp252:
                           3823  .globl mul_An_Bn252
   1D62                    3824 mul_An_Bn252:
   1D62 3D            [11] 3825                  MUL
                           3826  .globl mul_end252
   1D63                    3827 mul_end252:
   1D63 58            [ 2] 3828                  ASLB                              ; this divides d by 64
   1D64 49            [ 2] 3829                  ROLA
   1D65 58            [ 2] 3830                  ASLB
   1D66 49            [ 2] 3831                  ROLA
                           3832 
                           3833 ; macro call ->                  STORE_A _1N1x
   1D67 B7 C9 43      [ 5] 3834                  STA           _1N1x
                           3835 ; macro call ->                  A_EQUALS_MUL _helper, _sinz
   1D6A F6 C9 17      [ 5] 3836                  LDB           _sinz
   1D6D B6 C9 11      [ 5] 3837                  LDA           _helper
   1D70 2A 07         [ 3] 3838                  BPL           mul_Ap254
   1D72 40            [ 2] 3839                  NEGA
   1D73 5D            [ 2] 3840                  TSTB
   1D74 2A 07         [ 3] 3841                  BPL           mul_An_Bp254
   1D76 50            [ 2] 3842                  NEGB
   1D77 20 09         [ 3] 3843                  BRA           mul_An_Bn254
                           3844  .globl mul_Ap254
   1D79                    3845 mul_Ap254:
   1D79 5D            [ 2] 3846                  TSTB
   1D7A 2A 06         [ 3] 3847                  BPL           mul_Ap_Bp254
   1D7C 50            [ 2] 3848                  NEGB
                           3849  .globl mul_An_Bp254
   1D7D                    3850 mul_An_Bp254:
   1D7D 3D            [11] 3851                  MUL
   1D7E 53            [ 2] 3852                  COMB                              ; here we can use this as negd
   1D7F 43            [ 2] 3853                  COMA                              ; since the low nibble of b doesn't interest us
   1D80 20 01         [ 3] 3854                  BRA           mul_end254
                           3855  .globl mul_Ap_Bp254
   1D82                    3856 mul_Ap_Bp254:
                           3857  .globl mul_An_Bn254
   1D82                    3858 mul_An_Bn254:
   1D82 3D            [11] 3859                  MUL
                           3860  .globl mul_end254
   1D83                    3861 mul_end254:
   1D83 58            [ 2] 3862                  ASLB                              ; this divides d by 64
   1D84 49            [ 2] 3863                  ROLA
   1D85 58            [ 2] 3864                  ASLB
   1D86 49            [ 2] 3865                  ROLA
                           3866 
                           3867 ; macro call ->                  SUB_A_FROM _1N1x
   1D87 40            [ 2] 3868                  NEGA
                           3869 ; macro call ->                  ADD_A_TO      _1N1x
   1D88 BB C9 43      [ 5] 3870                  ADDA          _1N1x
                           3871 ; macro call ->                  STORE_A       _1N1x
   1D8B B7 C9 43      [ 5] 3872                  STA           _1N1x
                           3873 ; macro call ->                  STORE_A_NEG _1N1xi
   1D8E 40            [ 2] 3874                  NEGA
   1D8F B7 C9 6D      [ 5] 3875                  STA           _1N1xi
   1D92 B6 C9 1B      [ 5] 3876  lda _vectorBits
                           3877  .globl no1N1
   1D95                    3878 no1N1:
   1D95 85 20         [ 2] 3879  bita #TEST_1_1_N
   1D97 10 27 00 D2   [ 6] 3880  lbeq no11N
                           3881 ; macro call ->                     INIT_1_1_N_A  
                           3882 ; macro call ->                  CALC_1_1_N_A _11Nx, _11Ny, _11Nz, _11Nxi, _11Nyi, _11Nzi
   1D9B B6 C9 12      [ 5] 3883                  LDA _cosx
   1D9E B0 C9 13      [ 5] 3884                  SUBA _sinx
   1DA1 B7 C9 48      [ 5] 3885                  STA _11Nz
   1DA4 40            [ 2] 3886                  NEGA
   1DA5 B7 C9 72      [ 5] 3887                  STA _11Nzi
   1DA8 B6 C9 12      [ 5] 3888                  LDA   _cosx
   1DAB B0 C9 13      [ 5] 3889                  SUBA  _sinx
   1DAE B7 C9 48      [ 5] 3890                  STA   _11Nz
                           3891 
   1DB1 B6 C9 12      [ 5] 3892                  LDA   _cosx
   1DB4 40            [ 2] 3893                  NEGA
   1DB5 B0 C9 13      [ 5] 3894                  SUBA  _sinx
   1DB8 B7 C9 11      [ 5] 3895                  STA   _helper
                           3896 
                           3897 ; macro call ->                  A_EQUALS_MUL _11Nz, _siny
   1DBB F6 C9 15      [ 5] 3898                  LDB           _siny
   1DBE B6 C9 48      [ 5] 3899                  LDA           _11Nz
   1DC1 2A 07         [ 3] 3900                  BPL           mul_Ap261
   1DC3 40            [ 2] 3901                  NEGA
   1DC4 5D            [ 2] 3902                  TSTB
   1DC5 2A 07         [ 3] 3903                  BPL           mul_An_Bp261
   1DC7 50            [ 2] 3904                  NEGB
   1DC8 20 09         [ 3] 3905                  BRA           mul_An_Bn261
                           3906  .globl mul_Ap261
   1DCA                    3907 mul_Ap261:
   1DCA 5D            [ 2] 3908                  TSTB
   1DCB 2A 06         [ 3] 3909                  BPL           mul_Ap_Bp261
   1DCD 50            [ 2] 3910                  NEGB
                           3911  .globl mul_An_Bp261
   1DCE                    3912 mul_An_Bp261:
   1DCE 3D            [11] 3913                  MUL
   1DCF 53            [ 2] 3914                  COMB                              ; here we can use this as negd
   1DD0 43            [ 2] 3915                  COMA                              ; since the low nibble of b doesn't interest us
   1DD1 20 01         [ 3] 3916                  BRA           mul_end261
                           3917  .globl mul_Ap_Bp261
   1DD3                    3918 mul_Ap_Bp261:
                           3919  .globl mul_An_Bn261
   1DD3                    3920 mul_An_Bn261:
   1DD3 3D            [11] 3921                  MUL
                           3922  .globl mul_end261
   1DD4                    3923 mul_end261:
   1DD4 58            [ 2] 3924                  ASLB                              ; this divides d by 64
   1DD5 49            [ 2] 3925                  ROLA
   1DD6 58            [ 2] 3926                  ASLB
   1DD7 49            [ 2] 3927                  ROLA
                           3928 
   1DD8 BB C9 14      [ 5] 3929                  ADDA  _cosy
                           3930 ; macro call ->                  STORE_A _11Nx
   1DDB B7 C9 46      [ 5] 3931                  STA           _11Nx
                           3932 ; macro call ->                  A_EQUALS_MUL _helper, _cosz
   1DDE F6 C9 16      [ 5] 3933                  LDB           _cosz
   1DE1 B6 C9 11      [ 5] 3934                  LDA           _helper
   1DE4 2A 07         [ 3] 3935                  BPL           mul_Ap263
   1DE6 40            [ 2] 3936                  NEGA
   1DE7 5D            [ 2] 3937                  TSTB
   1DE8 2A 07         [ 3] 3938                  BPL           mul_An_Bp263
   1DEA 50            [ 2] 3939                  NEGB
   1DEB 20 09         [ 3] 3940                  BRA           mul_An_Bn263
                           3941  .globl mul_Ap263
   1DED                    3942 mul_Ap263:
   1DED 5D            [ 2] 3943                  TSTB
   1DEE 2A 06         [ 3] 3944                  BPL           mul_Ap_Bp263
   1DF0 50            [ 2] 3945                  NEGB
                           3946  .globl mul_An_Bp263
   1DF1                    3947 mul_An_Bp263:
   1DF1 3D            [11] 3948                  MUL
   1DF2 53            [ 2] 3949                  COMB                              ; here we can use this as negd
   1DF3 43            [ 2] 3950                  COMA                              ; since the low nibble of b doesn't interest us
   1DF4 20 01         [ 3] 3951                  BRA           mul_end263
                           3952  .globl mul_Ap_Bp263
   1DF6                    3953 mul_Ap_Bp263:
                           3954  .globl mul_An_Bn263
   1DF6                    3955 mul_An_Bn263:
   1DF6 3D            [11] 3956                  MUL
                           3957  .globl mul_end263
   1DF7                    3958 mul_end263:
   1DF7 58            [ 2] 3959                  ASLB                              ; this divides d by 64
   1DF8 49            [ 2] 3960                  ROLA
   1DF9 58            [ 2] 3961                  ASLB
   1DFA 49            [ 2] 3962                  ROLA
                           3963 
                           3964 ; macro call ->                  STORE_A _11Ny
   1DFB B7 C9 47      [ 5] 3965                  STA           _11Ny
                           3966 ; macro call ->                  A_EQUALS_MUL _11Nx, _sinz
   1DFE F6 C9 17      [ 5] 3967                  LDB           _sinz
   1E01 B6 C9 46      [ 5] 3968                  LDA           _11Nx
   1E04 2A 07         [ 3] 3969                  BPL           mul_Ap265
   1E06 40            [ 2] 3970                  NEGA
   1E07 5D            [ 2] 3971                  TSTB
   1E08 2A 07         [ 3] 3972                  BPL           mul_An_Bp265
   1E0A 50            [ 2] 3973                  NEGB
   1E0B 20 09         [ 3] 3974                  BRA           mul_An_Bn265
                           3975  .globl mul_Ap265
   1E0D                    3976 mul_Ap265:
   1E0D 5D            [ 2] 3977                  TSTB
   1E0E 2A 06         [ 3] 3978                  BPL           mul_Ap_Bp265
   1E10 50            [ 2] 3979                  NEGB
                           3980  .globl mul_An_Bp265
   1E11                    3981 mul_An_Bp265:
   1E11 3D            [11] 3982                  MUL
   1E12 53            [ 2] 3983                  COMB                              ; here we can use this as negd
   1E13 43            [ 2] 3984                  COMA                              ; since the low nibble of b doesn't interest us
   1E14 20 01         [ 3] 3985                  BRA           mul_end265
                           3986  .globl mul_Ap_Bp265
   1E16                    3987 mul_Ap_Bp265:
                           3988  .globl mul_An_Bn265
   1E16                    3989 mul_An_Bn265:
   1E16 3D            [11] 3990                  MUL
                           3991  .globl mul_end265
   1E17                    3992 mul_end265:
   1E17 58            [ 2] 3993                  ASLB                              ; this divides d by 64
   1E18 49            [ 2] 3994                  ROLA
   1E19 58            [ 2] 3995                  ASLB
   1E1A 49            [ 2] 3996                  ROLA
                           3997 
                           3998 ; macro call ->                  ADD_A_TO _11Ny
   1E1B BB C9 47      [ 5] 3999                  ADDA          _11Ny
                           4000 ; macro call ->                  STORE_A       _11Ny
   1E1E B7 C9 47      [ 5] 4001                  STA           _11Ny
                           4002 ; macro call ->                  STORE_A_NEG _11Nyi
   1E21 40            [ 2] 4003                  NEGA
   1E22 B7 C9 71      [ 5] 4004                  STA           _11Nyi
                           4005 ; macro call ->                  A_EQUALS_MUL _11Nx, _cosz
   1E25 F6 C9 16      [ 5] 4006                  LDB           _cosz
   1E28 B6 C9 46      [ 5] 4007                  LDA           _11Nx
   1E2B 2A 07         [ 3] 4008                  BPL           mul_Ap269
   1E2D 40            [ 2] 4009                  NEGA
   1E2E 5D            [ 2] 4010                  TSTB
   1E2F 2A 07         [ 3] 4011                  BPL           mul_An_Bp269
   1E31 50            [ 2] 4012                  NEGB
   1E32 20 09         [ 3] 4013                  BRA           mul_An_Bn269
                           4014  .globl mul_Ap269
   1E34                    4015 mul_Ap269:
   1E34 5D            [ 2] 4016                  TSTB
   1E35 2A 06         [ 3] 4017                  BPL           mul_Ap_Bp269
   1E37 50            [ 2] 4018                  NEGB
                           4019  .globl mul_An_Bp269
   1E38                    4020 mul_An_Bp269:
   1E38 3D            [11] 4021                  MUL
   1E39 53            [ 2] 4022                  COMB                              ; here we can use this as negd
   1E3A 43            [ 2] 4023                  COMA                              ; since the low nibble of b doesn't interest us
   1E3B 20 01         [ 3] 4024                  BRA           mul_end269
                           4025  .globl mul_Ap_Bp269
   1E3D                    4026 mul_Ap_Bp269:
                           4027  .globl mul_An_Bn269
   1E3D                    4028 mul_An_Bn269:
   1E3D 3D            [11] 4029                  MUL
                           4030  .globl mul_end269
   1E3E                    4031 mul_end269:
   1E3E 58            [ 2] 4032                  ASLB                              ; this divides d by 64
   1E3F 49            [ 2] 4033                  ROLA
   1E40 58            [ 2] 4034                  ASLB
   1E41 49            [ 2] 4035                  ROLA
                           4036 
                           4037 ; macro call ->                  STORE_A _11Nx
   1E42 B7 C9 46      [ 5] 4038                  STA           _11Nx
                           4039 ; macro call ->                  A_EQUALS_MUL _helper, _sinz
   1E45 F6 C9 17      [ 5] 4040                  LDB           _sinz
   1E48 B6 C9 11      [ 5] 4041                  LDA           _helper
   1E4B 2A 07         [ 3] 4042                  BPL           mul_Ap271
   1E4D 40            [ 2] 4043                  NEGA
   1E4E 5D            [ 2] 4044                  TSTB
   1E4F 2A 07         [ 3] 4045                  BPL           mul_An_Bp271
   1E51 50            [ 2] 4046                  NEGB
   1E52 20 09         [ 3] 4047                  BRA           mul_An_Bn271
                           4048  .globl mul_Ap271
   1E54                    4049 mul_Ap271:
   1E54 5D            [ 2] 4050                  TSTB
   1E55 2A 06         [ 3] 4051                  BPL           mul_Ap_Bp271
   1E57 50            [ 2] 4052                  NEGB
                           4053  .globl mul_An_Bp271
   1E58                    4054 mul_An_Bp271:
   1E58 3D            [11] 4055                  MUL
   1E59 53            [ 2] 4056                  COMB                              ; here we can use this as negd
   1E5A 43            [ 2] 4057                  COMA                              ; since the low nibble of b doesn't interest us
   1E5B 20 01         [ 3] 4058                  BRA           mul_end271
                           4059  .globl mul_Ap_Bp271
   1E5D                    4060 mul_Ap_Bp271:
                           4061  .globl mul_An_Bn271
   1E5D                    4062 mul_An_Bn271:
   1E5D 3D            [11] 4063                  MUL
                           4064  .globl mul_end271
   1E5E                    4065 mul_end271:
   1E5E 58            [ 2] 4066                  ASLB                              ; this divides d by 64
   1E5F 49            [ 2] 4067                  ROLA
   1E60 58            [ 2] 4068                  ASLB
   1E61 49            [ 2] 4069                  ROLA
                           4070 
                           4071 ; macro call ->                  SUB_A_FROM _11Nx
   1E62 40            [ 2] 4072                  NEGA
                           4073 ; macro call ->                  ADD_A_TO      _11Nx
   1E63 BB C9 46      [ 5] 4074                  ADDA          _11Nx
                           4075 ; macro call ->                  STORE_A       _11Nx
   1E66 B7 C9 46      [ 5] 4076                  STA           _11Nx
                           4077 ; macro call ->                  STORE_A_NEG _11Nxi
   1E69 40            [ 2] 4078                  NEGA
   1E6A B7 C9 70      [ 5] 4079                  STA           _11Nxi
                           4080  .globl no11N
   1E6D                    4081 no11N:
                           4082 
   1E6D 39            [ 5] 4083 				rts
                           4084 
ASxxxx Assembler V05.00  (Motorola 6809), page 1.
Hexidecimal [16-Bits]

Symbol Table

    .__.$$$.       =   2710 L   |     .__.ABS.       =   0000 G
    .__.CPU.       =   0000 L   |     .__.H$L.       =   0001 L
  3 A$3dForC.pre.a     01BD GR  |   3 A$3dForC.pre.a     01BF GR
  3 A$3dForC.pre.a     01C0 GR  |   3 A$3dForC.pre.a     01C2 GR
  3 A$3dForC.pre.a     01C3 GR  |   3 A$3dForC.pre.a     01C5 GR
  3 A$3dForC.pre.a     01C6 GR  |   3 A$3dForC.pre.a     01C7 GR
  3 A$3dForC.pre.a     01C8 GR  |   3 A$3dForC.pre.a     01C9 GR
  3 A$3dForC.pre.a     01CB GR  |   3 A$3dForC.pre.a     01CC GR
  3 A$3dForC.pre.a     01CD GR  |   3 A$3dForC.pre.a     01CE GR
  3 A$3dForC.pre.a     01CF GR  |   3 A$3dForC.pre.a     01D0 GR
  3 A$3dForC.pre.a     01D1 GR  |   3 A$3dForC.pre.a     01D4 GR
  3 A$3dForC.pre.a     01D7 GR  |   3 A$3dForC.pre.a     01D8 GR
  3 A$3dForC.pre.a     01DB GR  |   3 A$3dForC.pre.a     01DE GR
  3 A$3dForC.pre.a     01E1 GR  |   3 A$3dForC.pre.a     01E3 GR
  3 A$3dForC.pre.a     01E4 GR  |   3 A$3dForC.pre.a     01E5 GR
  3 A$3dForC.pre.a     01E7 GR  |   3 A$3dForC.pre.a     01E8 GR
  3 A$3dForC.pre.a     01EA GR  |   3 A$3dForC.pre.a     01EB GR
  3 A$3dForC.pre.a     01ED GR  |   3 A$3dForC.pre.a     01EE GR
  3 A$3dForC.pre.a     01EF GR  |   3 A$3dForC.pre.a     01F0 GR
  3 A$3dForC.pre.a     01F1 GR  |   3 A$3dForC.pre.a     01F3 GR
  3 A$3dForC.pre.a     01F4 GR  |   3 A$3dForC.pre.a     01F5 GR
  3 A$3dForC.pre.a     01F6 GR  |   3 A$3dForC.pre.a     01F7 GR
  3 A$3dForC.pre.a     01F8 GR  |   3 A$3dForC.pre.a     01FB GR
  3 A$3dForC.pre.a     01FE GR  |   3 A$3dForC.pre.a     0201 GR
  3 A$3dForC.pre.a     0203 GR  |   3 A$3dForC.pre.a     0204 GR
  3 A$3dForC.pre.a     0205 GR  |   3 A$3dForC.pre.a     0207 GR
  3 A$3dForC.pre.a     0208 GR  |   3 A$3dForC.pre.a     020A GR
  3 A$3dForC.pre.a     020B GR  |   3 A$3dForC.pre.a     020D GR
  3 A$3dForC.pre.a     020E GR  |   3 A$3dForC.pre.a     020F GR
  3 A$3dForC.pre.a     0210 GR  |   3 A$3dForC.pre.a     0211 GR
  3 A$3dForC.pre.a     0213 GR  |   3 A$3dForC.pre.a     0214 GR
  3 A$3dForC.pre.a     0215 GR  |   3 A$3dForC.pre.a     0216 GR
  3 A$3dForC.pre.a     0217 GR  |   3 A$3dForC.pre.a     0218 GR
  3 A$3dForC.pre.a     021B GR  |   3 A$3dForC.pre.a     021E GR
  3 A$3dForC.pre.a     021F GR  |   3 A$3dForC.pre.a     0222 GR
  3 A$3dForC.pre.a     0225 GR  |   3 A$3dForC.pre.a     0227 GR
  3 A$3dForC.pre.a     0229 GR  |   3 A$3dForC.pre.a     022C GR
  3 A$3dForC.pre.a     022F GR  |   3 A$3dForC.pre.a     0231 GR
  3 A$3dForC.pre.a     0232 GR  |   3 A$3dForC.pre.a     0233 GR
  3 A$3dForC.pre.a     0235 GR  |   3 A$3dForC.pre.a     0236 GR
  3 A$3dForC.pre.a     0238 GR  |   3 A$3dForC.pre.a     0239 GR
  3 A$3dForC.pre.a     023B GR  |   3 A$3dForC.pre.a     023C GR
  3 A$3dForC.pre.a     023D GR  |   3 A$3dForC.pre.a     023E GR
  3 A$3dForC.pre.a     023F GR  |   3 A$3dForC.pre.a     0241 GR
  3 A$3dForC.pre.a     0242 GR  |   3 A$3dForC.pre.a     0243 GR
  3 A$3dForC.pre.a     0244 GR  |   3 A$3dForC.pre.a     0245 GR
  3 A$3dForC.pre.a     0246 GR  |   3 A$3dForC.pre.a     0249 GR
  3 A$3dForC.pre.a     024A GR  |   3 A$3dForC.pre.a     024D GR
  3 A$3dForC.pre.a     0250 GR  |   3 A$3dForC.pre.a     0253 GR
  3 A$3dForC.pre.a     0255 GR  |   3 A$3dForC.pre.a     0256 GR
  3 A$3dForC.pre.a     0257 GR  |   3 A$3dForC.pre.a     0259 GR
  3 A$3dForC.pre.a     025A GR  |   3 A$3dForC.pre.a     025C GR
  3 A$3dForC.pre.a     025D GR  |   3 A$3dForC.pre.a     025F GR
  3 A$3dForC.pre.a     0260 GR  |   3 A$3dForC.pre.a     0261 GR
  3 A$3dForC.pre.a     0262 GR  |   3 A$3dForC.pre.a     0263 GR
  3 A$3dForC.pre.a     0265 GR  |   3 A$3dForC.pre.a     0266 GR
  3 A$3dForC.pre.a     0267 GR  |   3 A$3dForC.pre.a     0268 GR
  3 A$3dForC.pre.a     0269 GR  |   3 A$3dForC.pre.a     026A GR
  3 A$3dForC.pre.a     026D GR  |   3 A$3dForC.pre.a     026E GR
  3 A$3dForC.pre.a     0271 GR  |   3 A$3dForC.pre.a     0274 GR
  3 A$3dForC.pre.a     0276 GR  |   3 A$3dForC.pre.a     027A GR
  3 A$3dForC.pre.a     027D GR  |   3 A$3dForC.pre.a     027E GR
  3 A$3dForC.pre.a     0281 GR  |   3 A$3dForC.pre.a     0284 GR
  3 A$3dForC.pre.a     0287 GR  |   3 A$3dForC.pre.a     0289 GR
  3 A$3dForC.pre.a     028A GR  |   3 A$3dForC.pre.a     028B GR
  3 A$3dForC.pre.a     028D GR  |   3 A$3dForC.pre.a     028E GR
  3 A$3dForC.pre.a     0290 GR  |   3 A$3dForC.pre.a     0291 GR
  3 A$3dForC.pre.a     0293 GR  |   3 A$3dForC.pre.a     0294 GR
  3 A$3dForC.pre.a     0295 GR  |   3 A$3dForC.pre.a     0296 GR
  3 A$3dForC.pre.a     0297 GR  |   3 A$3dForC.pre.a     0299 GR
  3 A$3dForC.pre.a     029A GR  |   3 A$3dForC.pre.a     029B GR
  3 A$3dForC.pre.a     029C GR  |   3 A$3dForC.pre.a     029D GR
  3 A$3dForC.pre.a     029E GR  |   3 A$3dForC.pre.a     02A1 GR
  3 A$3dForC.pre.a     02A4 GR  |   3 A$3dForC.pre.a     02A7 GR
  3 A$3dForC.pre.a     02AA GR  |   3 A$3dForC.pre.a     02AC GR
  3 A$3dForC.pre.a     02AD GR  |   3 A$3dForC.pre.a     02AE GR
  3 A$3dForC.pre.a     02B0 GR  |   3 A$3dForC.pre.a     02B1 GR
  3 A$3dForC.pre.a     02B3 GR  |   3 A$3dForC.pre.a     02B4 GR
  3 A$3dForC.pre.a     02B6 GR  |   3 A$3dForC.pre.a     02B7 GR
  3 A$3dForC.pre.a     02B8 GR  |   3 A$3dForC.pre.a     02B9 GR
  3 A$3dForC.pre.a     02BA GR  |   3 A$3dForC.pre.a     02BC GR
  3 A$3dForC.pre.a     02BD GR  |   3 A$3dForC.pre.a     02BE GR
  3 A$3dForC.pre.a     02BF GR  |   3 A$3dForC.pre.a     02C0 GR
  3 A$3dForC.pre.a     02C1 GR  |   3 A$3dForC.pre.a     02C4 GR
  3 A$3dForC.pre.a     02C7 GR  |   3 A$3dForC.pre.a     02CA GR
  3 A$3dForC.pre.a     02CC GR  |   3 A$3dForC.pre.a     02CD GR
  3 A$3dForC.pre.a     02CE GR  |   3 A$3dForC.pre.a     02D0 GR
  3 A$3dForC.pre.a     02D1 GR  |   3 A$3dForC.pre.a     02D3 GR
  3 A$3dForC.pre.a     02D4 GR  |   3 A$3dForC.pre.a     02D6 GR
  3 A$3dForC.pre.a     02D7 GR  |   3 A$3dForC.pre.a     02D8 GR
  3 A$3dForC.pre.a     02D9 GR  |   3 A$3dForC.pre.a     02DA GR
  3 A$3dForC.pre.a     02DC GR  |   3 A$3dForC.pre.a     02DD GR
  3 A$3dForC.pre.a     02DE GR  |   3 A$3dForC.pre.a     02DF GR
  3 A$3dForC.pre.a     02E0 GR  |   3 A$3dForC.pre.a     02E1 GR
  3 A$3dForC.pre.a     02E4 GR  |   3 A$3dForC.pre.a     02E7 GR
  3 A$3dForC.pre.a     02E8 GR  |   3 A$3dForC.pre.a     02EB GR
  3 A$3dForC.pre.a     02EE GR  |   3 A$3dForC.pre.a     02F1 GR
  3 A$3dForC.pre.a     02F3 GR  |   3 A$3dForC.pre.a     02F4 GR
  3 A$3dForC.pre.a     02F5 GR  |   3 A$3dForC.pre.a     02F7 GR
  3 A$3dForC.pre.a     02F8 GR  |   3 A$3dForC.pre.a     02FA GR
  3 A$3dForC.pre.a     02FB GR  |   3 A$3dForC.pre.a     02FD GR
  3 A$3dForC.pre.a     02FE GR  |   3 A$3dForC.pre.a     02FF GR
  3 A$3dForC.pre.a     0300 GR  |   3 A$3dForC.pre.a     0301 GR
  3 A$3dForC.pre.a     0303 GR  |   3 A$3dForC.pre.a     0304 GR
  3 A$3dForC.pre.a     0305 GR  |   3 A$3dForC.pre.a     0306 GR
  3 A$3dForC.pre.a     0307 GR  |   3 A$3dForC.pre.a     0308 GR
  3 A$3dForC.pre.a     030B GR  |   3 A$3dForC.pre.a     030E GR
  3 A$3dForC.pre.a     0311 GR  |   3 A$3dForC.pre.a     0313 GR
  3 A$3dForC.pre.a     0314 GR  |   3 A$3dForC.pre.a     0315 GR
  3 A$3dForC.pre.a     0317 GR  |   3 A$3dForC.pre.a     0318 GR
  3 A$3dForC.pre.a     031A GR  |   3 A$3dForC.pre.a     031B GR
  3 A$3dForC.pre.a     031D GR  |   3 A$3dForC.pre.a     031E GR
  3 A$3dForC.pre.a     031F GR  |   3 A$3dForC.pre.a     0320 GR
  3 A$3dForC.pre.a     0321 GR  |   3 A$3dForC.pre.a     0323 GR
  3 A$3dForC.pre.a     0324 GR  |   3 A$3dForC.pre.a     0325 GR
  3 A$3dForC.pre.a     0326 GR  |   3 A$3dForC.pre.a     0327 GR
  3 A$3dForC.pre.a     0328 GR  |   3 A$3dForC.pre.a     0329 GR
  3 A$3dForC.pre.a     032C GR  |   3 A$3dForC.pre.a     032F GR
  3 A$3dForC.pre.a     0330 GR  |   3 A$3dForC.pre.a     0333 GR
  3 A$3dForC.pre.a     0336 GR  |   3 A$3dForC.pre.a     0338 GR
  3 A$3dForC.pre.a     033C GR  |   3 A$3dForC.pre.a     033F GR
  3 A$3dForC.pre.a     0340 GR  |   3 A$3dForC.pre.a     0343 GR
  3 A$3dForC.pre.a     0346 GR  |   3 A$3dForC.pre.a     0349 GR
  3 A$3dForC.pre.a     034B GR  |   3 A$3dForC.pre.a     034C GR
  3 A$3dForC.pre.a     034D GR  |   3 A$3dForC.pre.a     034F GR
  3 A$3dForC.pre.a     0350 GR  |   3 A$3dForC.pre.a     0352 GR
  3 A$3dForC.pre.a     0353 GR  |   3 A$3dForC.pre.a     0355 GR
  3 A$3dForC.pre.a     0356 GR  |   3 A$3dForC.pre.a     0357 GR
  3 A$3dForC.pre.a     0358 GR  |   3 A$3dForC.pre.a     0359 GR
  3 A$3dForC.pre.a     035B GR  |   3 A$3dForC.pre.a     035C GR
  3 A$3dForC.pre.a     035D GR  |   3 A$3dForC.pre.a     035E GR
  3 A$3dForC.pre.a     035F GR  |   3 A$3dForC.pre.a     0360 GR
  3 A$3dForC.pre.a     0363 GR  |   3 A$3dForC.pre.a     0366 GR
  3 A$3dForC.pre.a     0369 GR  |   3 A$3dForC.pre.a     036C GR
  3 A$3dForC.pre.a     036E GR  |   3 A$3dForC.pre.a     036F GR
  3 A$3dForC.pre.a     0370 GR  |   3 A$3dForC.pre.a     0372 GR
  3 A$3dForC.pre.a     0373 GR  |   3 A$3dForC.pre.a     0375 GR
  3 A$3dForC.pre.a     0376 GR  |   3 A$3dForC.pre.a     0378 GR
  3 A$3dForC.pre.a     0379 GR  |   3 A$3dForC.pre.a     037A GR
  3 A$3dForC.pre.a     037B GR  |   3 A$3dForC.pre.a     037C GR
  3 A$3dForC.pre.a     037E GR  |   3 A$3dForC.pre.a     037F GR
  3 A$3dForC.pre.a     0380 GR  |   3 A$3dForC.pre.a     0381 GR
  3 A$3dForC.pre.a     0382 GR  |   3 A$3dForC.pre.a     0383 GR
  3 A$3dForC.pre.a     0386 GR  |   3 A$3dForC.pre.a     0389 GR
  3 A$3dForC.pre.a     038C GR  |   3 A$3dForC.pre.a     038E GR
  3 A$3dForC.pre.a     038F GR  |   3 A$3dForC.pre.a     0390 GR
  3 A$3dForC.pre.a     0392 GR  |   3 A$3dForC.pre.a     0393 GR
  3 A$3dForC.pre.a     0395 GR  |   3 A$3dForC.pre.a     0396 GR
  3 A$3dForC.pre.a     0398 GR  |   3 A$3dForC.pre.a     0399 GR
  3 A$3dForC.pre.a     039A GR  |   3 A$3dForC.pre.a     039B GR
  3 A$3dForC.pre.a     039C GR  |   3 A$3dForC.pre.a     039E GR
  3 A$3dForC.pre.a     039F GR  |   3 A$3dForC.pre.a     03A0 GR
  3 A$3dForC.pre.a     03A1 GR  |   3 A$3dForC.pre.a     03A2 GR
  3 A$3dForC.pre.a     03A3 GR  |   3 A$3dForC.pre.a     03A6 GR
  3 A$3dForC.pre.a     03A9 GR  |   3 A$3dForC.pre.a     03AA GR
  3 A$3dForC.pre.a     03AD GR  |   3 A$3dForC.pre.a     03B0 GR
  3 A$3dForC.pre.a     03B3 GR  |   3 A$3dForC.pre.a     03B5 GR
  3 A$3dForC.pre.a     03B6 GR  |   3 A$3dForC.pre.a     03B7 GR
  3 A$3dForC.pre.a     03B9 GR  |   3 A$3dForC.pre.a     03BA GR
  3 A$3dForC.pre.a     03BC GR  |   3 A$3dForC.pre.a     03BD GR
  3 A$3dForC.pre.a     03BF GR  |   3 A$3dForC.pre.a     03C0 GR
  3 A$3dForC.pre.a     03C1 GR  |   3 A$3dForC.pre.a     03C2 GR
  3 A$3dForC.pre.a     03C3 GR  |   3 A$3dForC.pre.a     03C5 GR
  3 A$3dForC.pre.a     03C6 GR  |   3 A$3dForC.pre.a     03C7 GR
  3 A$3dForC.pre.a     03C8 GR  |   3 A$3dForC.pre.a     03C9 GR
  3 A$3dForC.pre.a     03CA GR  |   3 A$3dForC.pre.a     03CD GR
  3 A$3dForC.pre.a     03D0 GR  |   3 A$3dForC.pre.a     03D3 GR
  3 A$3dForC.pre.a     03D5 GR  |   3 A$3dForC.pre.a     03D6 GR
  3 A$3dForC.pre.a     03D7 GR  |   3 A$3dForC.pre.a     03D9 GR
  3 A$3dForC.pre.a     03DA GR  |   3 A$3dForC.pre.a     03DC GR
  3 A$3dForC.pre.a     03DD GR  |   3 A$3dForC.pre.a     03DF GR
  3 A$3dForC.pre.a     03E0 GR  |   3 A$3dForC.pre.a     03E1 GR
  3 A$3dForC.pre.a     03E2 GR  |   3 A$3dForC.pre.a     03E3 GR
  3 A$3dForC.pre.a     03E5 GR  |   3 A$3dForC.pre.a     03E6 GR
  3 A$3dForC.pre.a     03E7 GR  |   3 A$3dForC.pre.a     03E8 GR
  3 A$3dForC.pre.a     03E9 GR  |   3 A$3dForC.pre.a     03EA GR
  3 A$3dForC.pre.a     03EB GR  |   3 A$3dForC.pre.a     03EE GR
  3 A$3dForC.pre.a     03F1 GR  |   3 A$3dForC.pre.a     03F2 GR
  3 A$3dForC.pre.a     03F5 GR  |   3 A$3dForC.pre.a     03F6 GR
  3 A$3dForC.pre.a     03F9 GR  |   3 A$3dForC.pre.a     03FC GR
  3 A$3dForC.pre.a     03FF GR  |   3 A$3dForC.pre.a     0401 GR
  3 A$3dForC.pre.a     0404 GR  |   3 A$3dForC.pre.a     0406 GR
  3 A$3dForC.pre.a     0409 GR  |   3 A$3dForC.pre.a     040C GR
  3 A$3dForC.pre.a     040E GR  |   3 A$3dForC.pre.a     0411 GR
  3 A$3dForC.pre.a     0413 GR  |   3 A$3dForC.pre.a     0416 GR
  3 A$3dForC.pre.a     0419 GR  |   3 A$3dForC.pre.a     041B GR
  3 A$3dForC.pre.a     041E GR  |   3 A$3dForC.pre.a     0420 GR
  3 A$3dForC.pre.a     0423 GR  |   3 A$3dForC.pre.a     0426 GR
  3 A$3dForC.pre.a     0428 GR  |   3 A$3dForC.pre.a     042A GR
  3 A$3dForC.pre.a     042B GR  |   3 A$3dForC.pre.a     042E GR
  3 A$3dForC.pre.a     0431 GR  |   3 A$3dForC.pre.a     0434 GR
  3 A$3dForC.pre.a     0437 GR  |   3 A$3dForC.pre.a     043A GR
  3 A$3dForC.pre.a     043D GR  |   3 A$3dForC.pre.a     0440 GR
  3 A$3dForC.pre.a     0442 GR  |   3 A$3dForC.pre.a     0444 GR
  3 A$3dForC.pre.a     0445 GR  |   3 A$3dForC.pre.a     0448 GR
  3 A$3dForC.pre.a     044B GR  |   3 A$3dForC.pre.a     044E GR
  3 A$3dForC.pre.a     0451 GR  |   3 A$3dForC.pre.a     0453 GR
  3 A$3dForC.pre.a     0454 GR  |   3 A$3dForC.pre.a     0455 GR
  3 A$3dForC.pre.a     0457 GR  |   3 A$3dForC.pre.a     0458 GR
  3 A$3dForC.pre.a     045A GR  |   3 A$3dForC.pre.a     045B GR
  3 A$3dForC.pre.a     045D GR  |   3 A$3dForC.pre.a     045E GR
  3 A$3dForC.pre.a     045F GR  |   3 A$3dForC.pre.a     0460 GR
  3 A$3dForC.pre.a     0461 GR  |   3 A$3dForC.pre.a     0463 GR
  3 A$3dForC.pre.a     0464 GR  |   3 A$3dForC.pre.a     0465 GR
  3 A$3dForC.pre.a     0466 GR  |   3 A$3dForC.pre.a     0467 GR
  3 A$3dForC.pre.a     0468 GR  |   3 A$3dForC.pre.a     046B GR
  3 A$3dForC.pre.a     046C GR  |   3 A$3dForC.pre.a     046F GR
  3 A$3dForC.pre.a     0472 GR  |   3 A$3dForC.pre.a     0475 GR
  3 A$3dForC.pre.a     0477 GR  |   3 A$3dForC.pre.a     0478 GR
  3 A$3dForC.pre.a     0479 GR  |   3 A$3dForC.pre.a     047B GR
  3 A$3dForC.pre.a     047C GR  |   3 A$3dForC.pre.a     047E GR
  3 A$3dForC.pre.a     047F GR  |   3 A$3dForC.pre.a     0481 GR
  3 A$3dForC.pre.a     0482 GR  |   3 A$3dForC.pre.a     0483 GR
  3 A$3dForC.pre.a     0484 GR  |   3 A$3dForC.pre.a     0485 GR
  3 A$3dForC.pre.a     0487 GR  |   3 A$3dForC.pre.a     0488 GR
  3 A$3dForC.pre.a     0489 GR  |   3 A$3dForC.pre.a     048A GR
  3 A$3dForC.pre.a     048B GR  |   3 A$3dForC.pre.a     048C GR
  3 A$3dForC.pre.a     048F GR  |   3 A$3dForC.pre.a     0490 GR
  3 A$3dForC.pre.a     0493 GR  |   3 A$3dForC.pre.a     0496 GR
  3 A$3dForC.pre.a     0498 GR  |   3 A$3dForC.pre.a     049C GR
  3 A$3dForC.pre.a     049F GR  |   3 A$3dForC.pre.a     04A2 GR
  3 A$3dForC.pre.a     04A3 GR  |   3 A$3dForC.pre.a     04A6 GR
  3 A$3dForC.pre.a     04A9 GR  |   3 A$3dForC.pre.a     04AA GR
  3 A$3dForC.pre.a     04AD GR  |   3 A$3dForC.pre.a     04B0 GR
  3 A$3dForC.pre.a     04B3 GR  |   3 A$3dForC.pre.a     04B5 GR
  3 A$3dForC.pre.a     04B6 GR  |   3 A$3dForC.pre.a     04B7 GR
  3 A$3dForC.pre.a     04B9 GR  |   3 A$3dForC.pre.a     04BA GR
  3 A$3dForC.pre.a     04BC GR  |   3 A$3dForC.pre.a     04BD GR
  3 A$3dForC.pre.a     04BF GR  |   3 A$3dForC.pre.a     04C0 GR
  3 A$3dForC.pre.a     04C1 GR  |   3 A$3dForC.pre.a     04C2 GR
  3 A$3dForC.pre.a     04C3 GR  |   3 A$3dForC.pre.a     04C5 GR
  3 A$3dForC.pre.a     04C6 GR  |   3 A$3dForC.pre.a     04C7 GR
  3 A$3dForC.pre.a     04C8 GR  |   3 A$3dForC.pre.a     04C9 GR
  3 A$3dForC.pre.a     04CA GR  |   3 A$3dForC.pre.a     04CD GR
  3 A$3dForC.pre.a     04D0 GR  |   3 A$3dForC.pre.a     04D3 GR
  3 A$3dForC.pre.a     04D6 GR  |   3 A$3dForC.pre.a     04D8 GR
  3 A$3dForC.pre.a     04D9 GR  |   3 A$3dForC.pre.a     04DA GR
  3 A$3dForC.pre.a     04DC GR  |   3 A$3dForC.pre.a     04DD GR
  3 A$3dForC.pre.a     04DF GR  |   3 A$3dForC.pre.a     04E0 GR
  3 A$3dForC.pre.a     04E2 GR  |   3 A$3dForC.pre.a     04E3 GR
  3 A$3dForC.pre.a     04E4 GR  |   3 A$3dForC.pre.a     04E5 GR
  3 A$3dForC.pre.a     04E6 GR  |   3 A$3dForC.pre.a     04E8 GR
  3 A$3dForC.pre.a     04E9 GR  |   3 A$3dForC.pre.a     04EA GR
  3 A$3dForC.pre.a     04EB GR  |   3 A$3dForC.pre.a     04EC GR
  3 A$3dForC.pre.a     04ED GR  |   3 A$3dForC.pre.a     04F0 GR
  3 A$3dForC.pre.a     04F3 GR  |   3 A$3dForC.pre.a     04F6 GR
  3 A$3dForC.pre.a     04F8 GR  |   3 A$3dForC.pre.a     04F9 GR
  3 A$3dForC.pre.a     04FA GR  |   3 A$3dForC.pre.a     04FC GR
  3 A$3dForC.pre.a     04FD GR  |   3 A$3dForC.pre.a     04FF GR
  3 A$3dForC.pre.a     0500 GR  |   3 A$3dForC.pre.a     0502 GR
  3 A$3dForC.pre.a     0503 GR  |   3 A$3dForC.pre.a     0504 GR
  3 A$3dForC.pre.a     0505 GR  |   3 A$3dForC.pre.a     0506 GR
  3 A$3dForC.pre.a     0508 GR  |   3 A$3dForC.pre.a     0509 GR
  3 A$3dForC.pre.a     050A GR  |   3 A$3dForC.pre.a     050B GR
  3 A$3dForC.pre.a     050C GR  |   3 A$3dForC.pre.a     050D GR
  3 A$3dForC.pre.a     0510 GR  |   3 A$3dForC.pre.a     0513 GR
  3 A$3dForC.pre.a     0514 GR  |   3 A$3dForC.pre.a     0517 GR
  3 A$3dForC.pre.a     051A GR  |   3 A$3dForC.pre.a     051D GR
  3 A$3dForC.pre.a     051F GR  |   3 A$3dForC.pre.a     0520 GR
  3 A$3dForC.pre.a     0521 GR  |   3 A$3dForC.pre.a     0523 GR
  3 A$3dForC.pre.a     0524 GR  |   3 A$3dForC.pre.a     0526 GR
  3 A$3dForC.pre.a     0527 GR  |   3 A$3dForC.pre.a     0529 GR
  3 A$3dForC.pre.a     052A GR  |   3 A$3dForC.pre.a     052B GR
  3 A$3dForC.pre.a     052C GR  |   3 A$3dForC.pre.a     052D GR
  3 A$3dForC.pre.a     052F GR  |   3 A$3dForC.pre.a     0530 GR
  3 A$3dForC.pre.a     0531 GR  |   3 A$3dForC.pre.a     0532 GR
  3 A$3dForC.pre.a     0533 GR  |   3 A$3dForC.pre.a     0534 GR
  3 A$3dForC.pre.a     0537 GR  |   3 A$3dForC.pre.a     053A GR
  3 A$3dForC.pre.a     053D GR  |   3 A$3dForC.pre.a     053F GR
  3 A$3dForC.pre.a     0540 GR  |   3 A$3dForC.pre.a     0541 GR
  3 A$3dForC.pre.a     0543 GR  |   3 A$3dForC.pre.a     0544 GR
  3 A$3dForC.pre.a     0546 GR  |   3 A$3dForC.pre.a     0547 GR
  3 A$3dForC.pre.a     0549 GR  |   3 A$3dForC.pre.a     054A GR
  3 A$3dForC.pre.a     054B GR  |   3 A$3dForC.pre.a     054C GR
  3 A$3dForC.pre.a     054D GR  |   3 A$3dForC.pre.a     054F GR
  3 A$3dForC.pre.a     0550 GR  |   3 A$3dForC.pre.a     0551 GR
  3 A$3dForC.pre.a     0552 GR  |   3 A$3dForC.pre.a     0553 GR
  3 A$3dForC.pre.a     0554 GR  |   3 A$3dForC.pre.a     0555 GR
  3 A$3dForC.pre.a     0558 GR  |   3 A$3dForC.pre.a     055B GR
  3 A$3dForC.pre.a     055C GR  |   3 A$3dForC.pre.a     055F GR
  3 A$3dForC.pre.a     0562 GR  |   3 A$3dForC.pre.a     0564 GR
  3 A$3dForC.pre.a     0568 GR  |   3 A$3dForC.pre.a     056B GR
  3 A$3dForC.pre.a     056E GR  |   3 A$3dForC.pre.a     056F GR
  3 A$3dForC.pre.a     0572 GR  |   3 A$3dForC.pre.a     0575 GR
  3 A$3dForC.pre.a     0578 GR  |   3 A$3dForC.pre.a     057A GR
  3 A$3dForC.pre.a     057B GR  |   3 A$3dForC.pre.a     057C GR
  3 A$3dForC.pre.a     057E GR  |   3 A$3dForC.pre.a     057F GR
  3 A$3dForC.pre.a     0581 GR  |   3 A$3dForC.pre.a     0582 GR
  3 A$3dForC.pre.a     0584 GR  |   3 A$3dForC.pre.a     0585 GR
  3 A$3dForC.pre.a     0586 GR  |   3 A$3dForC.pre.a     0587 GR
  3 A$3dForC.pre.a     0588 GR  |   3 A$3dForC.pre.a     058A GR
  3 A$3dForC.pre.a     058B GR  |   3 A$3dForC.pre.a     058C GR
  3 A$3dForC.pre.a     058D GR  |   3 A$3dForC.pre.a     058E GR
  3 A$3dForC.pre.a     058F GR  |   3 A$3dForC.pre.a     0592 GR
  3 A$3dForC.pre.a     0595 GR  |   3 A$3dForC.pre.a     0598 GR
  3 A$3dForC.pre.a     059B GR  |   3 A$3dForC.pre.a     059D GR
  3 A$3dForC.pre.a     059E GR  |   3 A$3dForC.pre.a     059F GR
  3 A$3dForC.pre.a     05A1 GR  |   3 A$3dForC.pre.a     05A2 GR
  3 A$3dForC.pre.a     05A4 GR  |   3 A$3dForC.pre.a     05A5 GR
  3 A$3dForC.pre.a     05A7 GR  |   3 A$3dForC.pre.a     05A8 GR
  3 A$3dForC.pre.a     05A9 GR  |   3 A$3dForC.pre.a     05AA GR
  3 A$3dForC.pre.a     05AB GR  |   3 A$3dForC.pre.a     05AD GR
  3 A$3dForC.pre.a     05AE GR  |   3 A$3dForC.pre.a     05AF GR
  3 A$3dForC.pre.a     05B0 GR  |   3 A$3dForC.pre.a     05B1 GR
  3 A$3dForC.pre.a     05B2 GR  |   3 A$3dForC.pre.a     05B5 GR
  3 A$3dForC.pre.a     05B8 GR  |   3 A$3dForC.pre.a     05BB GR
  3 A$3dForC.pre.a     05BD GR  |   3 A$3dForC.pre.a     05BE GR
  3 A$3dForC.pre.a     05BF GR  |   3 A$3dForC.pre.a     05C1 GR
  3 A$3dForC.pre.a     05C2 GR  |   3 A$3dForC.pre.a     05C4 GR
  3 A$3dForC.pre.a     05C5 GR  |   3 A$3dForC.pre.a     05C7 GR
  3 A$3dForC.pre.a     05C8 GR  |   3 A$3dForC.pre.a     05C9 GR
  3 A$3dForC.pre.a     05CA GR  |   3 A$3dForC.pre.a     05CB GR
  3 A$3dForC.pre.a     05CD GR  |   3 A$3dForC.pre.a     05CE GR
  3 A$3dForC.pre.a     05CF GR  |   3 A$3dForC.pre.a     05D0 GR
  3 A$3dForC.pre.a     05D1 GR  |   3 A$3dForC.pre.a     05D2 GR
  3 A$3dForC.pre.a     05D5 GR  |   3 A$3dForC.pre.a     05D8 GR
  3 A$3dForC.pre.a     05D9 GR  |   3 A$3dForC.pre.a     05DC GR
  3 A$3dForC.pre.a     05DF GR  |   3 A$3dForC.pre.a     05E2 GR
  3 A$3dForC.pre.a     05E4 GR  |   3 A$3dForC.pre.a     05E5 GR
  3 A$3dForC.pre.a     05E6 GR  |   3 A$3dForC.pre.a     05E8 GR
  3 A$3dForC.pre.a     05E9 GR  |   3 A$3dForC.pre.a     05EB GR
  3 A$3dForC.pre.a     05EC GR  |   3 A$3dForC.pre.a     05EE GR
  3 A$3dForC.pre.a     05EF GR  |   3 A$3dForC.pre.a     05F0 GR
  3 A$3dForC.pre.a     05F1 GR  |   3 A$3dForC.pre.a     05F2 GR
  3 A$3dForC.pre.a     05F4 GR  |   3 A$3dForC.pre.a     05F5 GR
  3 A$3dForC.pre.a     05F6 GR  |   3 A$3dForC.pre.a     05F7 GR
  3 A$3dForC.pre.a     05F8 GR  |   3 A$3dForC.pre.a     05F9 GR
  3 A$3dForC.pre.a     05FC GR  |   3 A$3dForC.pre.a     05FF GR
  3 A$3dForC.pre.a     0602 GR  |   3 A$3dForC.pre.a     0604 GR
  3 A$3dForC.pre.a     0605 GR  |   3 A$3dForC.pre.a     0606 GR
  3 A$3dForC.pre.a     0608 GR  |   3 A$3dForC.pre.a     0609 GR
  3 A$3dForC.pre.a     060B GR  |   3 A$3dForC.pre.a     060C GR
  3 A$3dForC.pre.a     060E GR  |   3 A$3dForC.pre.a     060F GR
  3 A$3dForC.pre.a     0610 GR  |   3 A$3dForC.pre.a     0611 GR
  3 A$3dForC.pre.a     0612 GR  |   3 A$3dForC.pre.a     0614 GR
  3 A$3dForC.pre.a     0615 GR  |   3 A$3dForC.pre.a     0616 GR
  3 A$3dForC.pre.a     0617 GR  |   3 A$3dForC.pre.a     0618 GR
  3 A$3dForC.pre.a     0619 GR  |   3 A$3dForC.pre.a     061A GR
  3 A$3dForC.pre.a     061D GR  |   3 A$3dForC.pre.a     0620 GR
  3 A$3dForC.pre.a     0621 GR  |   3 A$3dForC.pre.a     0624 GR
  3 A$3dForC.pre.a     0627 GR  |   3 A$3dForC.pre.a     0629 GR
  3 A$3dForC.pre.a     062D GR  |   3 A$3dForC.pre.a     0630 GR
  3 A$3dForC.pre.a     0633 GR  |   3 A$3dForC.pre.a     0636 GR
  3 A$3dForC.pre.a     0637 GR  |   3 A$3dForC.pre.a     063A GR
  3 A$3dForC.pre.a     063D GR  |   3 A$3dForC.pre.a     0640 GR
  3 A$3dForC.pre.a     0643 GR  |   3 A$3dForC.pre.a     0646 GR
  3 A$3dForC.pre.a     0649 GR  |   3 A$3dForC.pre.a     064C GR
  3 A$3dForC.pre.a     064F GR  |   3 A$3dForC.pre.a     0652 GR
  3 A$3dForC.pre.a     0654 GR  |   3 A$3dForC.pre.a     0655 GR
  3 A$3dForC.pre.a     0656 GR  |   3 A$3dForC.pre.a     0658 GR
  3 A$3dForC.pre.a     0659 GR  |   3 A$3dForC.pre.a     065B GR
  3 A$3dForC.pre.a     065C GR  |   3 A$3dForC.pre.a     065E GR
  3 A$3dForC.pre.a     065F GR  |   3 A$3dForC.pre.a     0660 GR
  3 A$3dForC.pre.a     0661 GR  |   3 A$3dForC.pre.a     0662 GR
  3 A$3dForC.pre.a     0664 GR  |   3 A$3dForC.pre.a     0665 GR
  3 A$3dForC.pre.a     0666 GR  |   3 A$3dForC.pre.a     0667 GR
  3 A$3dForC.pre.a     0668 GR  |   3 A$3dForC.pre.a     0669 GR
  3 A$3dForC.pre.a     066C GR  |   3 A$3dForC.pre.a     066F GR
  3 A$3dForC.pre.a     0672 GR  |   3 A$3dForC.pre.a     0675 GR
  3 A$3dForC.pre.a     0677 GR  |   3 A$3dForC.pre.a     0678 GR
  3 A$3dForC.pre.a     0679 GR  |   3 A$3dForC.pre.a     067B GR
  3 A$3dForC.pre.a     067C GR  |   3 A$3dForC.pre.a     067E GR
  3 A$3dForC.pre.a     067F GR  |   3 A$3dForC.pre.a     0681 GR
  3 A$3dForC.pre.a     0682 GR  |   3 A$3dForC.pre.a     0683 GR
  3 A$3dForC.pre.a     0684 GR  |   3 A$3dForC.pre.a     0685 GR
  3 A$3dForC.pre.a     0687 GR  |   3 A$3dForC.pre.a     0688 GR
  3 A$3dForC.pre.a     0689 GR  |   3 A$3dForC.pre.a     068A GR
  3 A$3dForC.pre.a     068B GR  |   3 A$3dForC.pre.a     068C GR
  3 A$3dForC.pre.a     068F GR  |   3 A$3dForC.pre.a     0692 GR
  3 A$3dForC.pre.a     0695 GR  |   3 A$3dForC.pre.a     0697 GR
  3 A$3dForC.pre.a     0698 GR  |   3 A$3dForC.pre.a     0699 GR
  3 A$3dForC.pre.a     069B GR  |   3 A$3dForC.pre.a     069C GR
  3 A$3dForC.pre.a     069E GR  |   3 A$3dForC.pre.a     069F GR
  3 A$3dForC.pre.a     06A1 GR  |   3 A$3dForC.pre.a     06A2 GR
  3 A$3dForC.pre.a     06A3 GR  |   3 A$3dForC.pre.a     06A4 GR
  3 A$3dForC.pre.a     06A5 GR  |   3 A$3dForC.pre.a     06A7 GR
  3 A$3dForC.pre.a     06A8 GR  |   3 A$3dForC.pre.a     06A9 GR
  3 A$3dForC.pre.a     06AA GR  |   3 A$3dForC.pre.a     06AB GR
  3 A$3dForC.pre.a     06AC GR  |   3 A$3dForC.pre.a     06AF GR
  3 A$3dForC.pre.a     06B2 GR  |   3 A$3dForC.pre.a     06B3 GR
  3 A$3dForC.pre.a     06B6 GR  |   3 A$3dForC.pre.a     06B9 GR
  3 A$3dForC.pre.a     06BC GR  |   3 A$3dForC.pre.a     06BE GR
  3 A$3dForC.pre.a     06BF GR  |   3 A$3dForC.pre.a     06C0 GR
  3 A$3dForC.pre.a     06C2 GR  |   3 A$3dForC.pre.a     06C3 GR
  3 A$3dForC.pre.a     06C5 GR  |   3 A$3dForC.pre.a     06C6 GR
  3 A$3dForC.pre.a     06C8 GR  |   3 A$3dForC.pre.a     06C9 GR
  3 A$3dForC.pre.a     06CA GR  |   3 A$3dForC.pre.a     06CB GR
  3 A$3dForC.pre.a     06CC GR  |   3 A$3dForC.pre.a     06CE GR
  3 A$3dForC.pre.a     06CF GR  |   3 A$3dForC.pre.a     06D0 GR
  3 A$3dForC.pre.a     06D1 GR  |   3 A$3dForC.pre.a     06D2 GR
  3 A$3dForC.pre.a     06D3 GR  |   3 A$3dForC.pre.a     06D6 GR
  3 A$3dForC.pre.a     06D9 GR  |   3 A$3dForC.pre.a     06DC GR
  3 A$3dForC.pre.a     06DE GR  |   3 A$3dForC.pre.a     06DF GR
  3 A$3dForC.pre.a     06E0 GR  |   3 A$3dForC.pre.a     06E2 GR
  3 A$3dForC.pre.a     06E3 GR  |   3 A$3dForC.pre.a     06E5 GR
  3 A$3dForC.pre.a     06E6 GR  |   3 A$3dForC.pre.a     06E8 GR
  3 A$3dForC.pre.a     06E9 GR  |   3 A$3dForC.pre.a     06EA GR
  3 A$3dForC.pre.a     06EB GR  |   3 A$3dForC.pre.a     06EC GR
  3 A$3dForC.pre.a     06EE GR  |   3 A$3dForC.pre.a     06EF GR
  3 A$3dForC.pre.a     06F0 GR  |   3 A$3dForC.pre.a     06F1 GR
  3 A$3dForC.pre.a     06F2 GR  |   3 A$3dForC.pre.a     06F3 GR
  3 A$3dForC.pre.a     06F4 GR  |   3 A$3dForC.pre.a     06F7 GR
  3 A$3dForC.pre.a     06FA GR  |   3 A$3dForC.pre.a     06FB GR
  3 A$3dForC.pre.a     06FE GR  |   3 A$3dForC.pre.a     0701 GR
  3 A$3dForC.pre.a     0703 GR  |   3 A$3dForC.pre.a     0707 GR
  3 A$3dForC.pre.a     070A GR  |   3 A$3dForC.pre.a     070D GR
  3 A$3dForC.pre.a     070E GR  |   3 A$3dForC.pre.a     0711 GR
  3 A$3dForC.pre.a     0714 GR  |   3 A$3dForC.pre.a     0717 GR
  3 A$3dForC.pre.a     0719 GR  |   3 A$3dForC.pre.a     071A GR
  3 A$3dForC.pre.a     071B GR  |   3 A$3dForC.pre.a     071D GR
  3 A$3dForC.pre.a     071E GR  |   3 A$3dForC.pre.a     0720 GR
  3 A$3dForC.pre.a     0721 GR  |   3 A$3dForC.pre.a     0723 GR
  3 A$3dForC.pre.a     0724 GR  |   3 A$3dForC.pre.a     0725 GR
  3 A$3dForC.pre.a     0726 GR  |   3 A$3dForC.pre.a     0727 GR
  3 A$3dForC.pre.a     0729 GR  |   3 A$3dForC.pre.a     072A GR
  3 A$3dForC.pre.a     072B GR  |   3 A$3dForC.pre.a     072C GR
  3 A$3dForC.pre.a     072D GR  |   3 A$3dForC.pre.a     072E GR
  3 A$3dForC.pre.a     0731 GR  |   3 A$3dForC.pre.a     0734 GR
  3 A$3dForC.pre.a     0737 GR  |   3 A$3dForC.pre.a     0739 GR
  3 A$3dForC.pre.a     073A GR  |   3 A$3dForC.pre.a     073B GR
  3 A$3dForC.pre.a     073D GR  |   3 A$3dForC.pre.a     073E GR
  3 A$3dForC.pre.a     0740 GR  |   3 A$3dForC.pre.a     0741 GR
  3 A$3dForC.pre.a     0743 GR  |   3 A$3dForC.pre.a     0744 GR
  3 A$3dForC.pre.a     0745 GR  |   3 A$3dForC.pre.a     0746 GR
  3 A$3dForC.pre.a     0747 GR  |   3 A$3dForC.pre.a     0749 GR
  3 A$3dForC.pre.a     074A GR  |   3 A$3dForC.pre.a     074B GR
  3 A$3dForC.pre.a     074C GR  |   3 A$3dForC.pre.a     074D GR
  3 A$3dForC.pre.a     074E GR  |   3 A$3dForC.pre.a     0751 GR
  3 A$3dForC.pre.a     0754 GR  |   3 A$3dForC.pre.a     0757 GR
  3 A$3dForC.pre.a     0759 GR  |   3 A$3dForC.pre.a     075A GR
  3 A$3dForC.pre.a     075B GR  |   3 A$3dForC.pre.a     075D GR
  3 A$3dForC.pre.a     075E GR  |   3 A$3dForC.pre.a     0760 GR
  3 A$3dForC.pre.a     0761 GR  |   3 A$3dForC.pre.a     0763 GR
  3 A$3dForC.pre.a     0764 GR  |   3 A$3dForC.pre.a     0765 GR
  3 A$3dForC.pre.a     0766 GR  |   3 A$3dForC.pre.a     0767 GR
  3 A$3dForC.pre.a     0769 GR  |   3 A$3dForC.pre.a     076A GR
  3 A$3dForC.pre.a     076B GR  |   3 A$3dForC.pre.a     076C GR
  3 A$3dForC.pre.a     076D GR  |   3 A$3dForC.pre.a     076E GR
  3 A$3dForC.pre.a     076F GR  |   3 A$3dForC.pre.a     0772 GR
  3 A$3dForC.pre.a     0775 GR  |   3 A$3dForC.pre.a     0776 GR
  3 A$3dForC.pre.a     0779 GR  |   3 A$3dForC.pre.a     077C GR
  3 A$3dForC.pre.a     077F GR  |   3 A$3dForC.pre.a     0781 GR
  3 A$3dForC.pre.a     0782 GR  |   3 A$3dForC.pre.a     0783 GR
  3 A$3dForC.pre.a     0785 GR  |   3 A$3dForC.pre.a     0786 GR
  3 A$3dForC.pre.a     0788 GR  |   3 A$3dForC.pre.a     0789 GR
  3 A$3dForC.pre.a     078B GR  |   3 A$3dForC.pre.a     078C GR
  3 A$3dForC.pre.a     078D GR  |   3 A$3dForC.pre.a     078E GR
  3 A$3dForC.pre.a     078F GR  |   3 A$3dForC.pre.a     0791 GR
  3 A$3dForC.pre.a     0792 GR  |   3 A$3dForC.pre.a     0793 GR
  3 A$3dForC.pre.a     0794 GR  |   3 A$3dForC.pre.a     0795 GR
  3 A$3dForC.pre.a     0796 GR  |   3 A$3dForC.pre.a     0799 GR
  3 A$3dForC.pre.a     079C GR  |   3 A$3dForC.pre.a     079F GR
  3 A$3dForC.pre.a     07A1 GR  |   3 A$3dForC.pre.a     07A2 GR
  3 A$3dForC.pre.a     07A3 GR  |   3 A$3dForC.pre.a     07A5 GR
  3 A$3dForC.pre.a     07A6 GR  |   3 A$3dForC.pre.a     07A8 GR
  3 A$3dForC.pre.a     07A9 GR  |   3 A$3dForC.pre.a     07AB GR
  3 A$3dForC.pre.a     07AC GR  |   3 A$3dForC.pre.a     07AD GR
  3 A$3dForC.pre.a     07AE GR  |   3 A$3dForC.pre.a     07AF GR
  3 A$3dForC.pre.a     07B1 GR  |   3 A$3dForC.pre.a     07B2 GR
  3 A$3dForC.pre.a     07B3 GR  |   3 A$3dForC.pre.a     07B4 GR
  3 A$3dForC.pre.a     07B5 GR  |   3 A$3dForC.pre.a     07B6 GR
  3 A$3dForC.pre.a     07B9 GR  |   3 A$3dForC.pre.a     07BC GR
  3 A$3dForC.pre.a     07BD GR  |   3 A$3dForC.pre.a     07C0 GR
  3 A$3dForC.pre.a     07C3 GR  |   3 A$3dForC.pre.a     07C5 GR
  3 A$3dForC.pre.a     07C9 GR  |   3 A$3dForC.pre.a     07CC GR
  3 A$3dForC.pre.a     07CF GR  |   3 A$3dForC.pre.a     07D2 GR
  3 A$3dForC.pre.a     07D3 GR  |   3 A$3dForC.pre.a     07D6 GR
  3 A$3dForC.pre.a     07D9 GR  |   3 A$3dForC.pre.a     07DC GR
  3 A$3dForC.pre.a     07DF GR  |   3 A$3dForC.pre.a     07E2 GR
  3 A$3dForC.pre.a     07E5 GR  |   3 A$3dForC.pre.a     07E8 GR
  3 A$3dForC.pre.a     07EB GR  |   3 A$3dForC.pre.a     07EE GR
  3 A$3dForC.pre.a     07F0 GR  |   3 A$3dForC.pre.a     07F1 GR
  3 A$3dForC.pre.a     07F2 GR  |   3 A$3dForC.pre.a     07F4 GR
  3 A$3dForC.pre.a     07F5 GR  |   3 A$3dForC.pre.a     07F7 GR
  3 A$3dForC.pre.a     07F8 GR  |   3 A$3dForC.pre.a     07FA GR
  3 A$3dForC.pre.a     07FB GR  |   3 A$3dForC.pre.a     07FC GR
  3 A$3dForC.pre.a     07FD GR  |   3 A$3dForC.pre.a     07FE GR
  3 A$3dForC.pre.a     0800 GR  |   3 A$3dForC.pre.a     0801 GR
  3 A$3dForC.pre.a     0802 GR  |   3 A$3dForC.pre.a     0803 GR
  3 A$3dForC.pre.a     0804 GR  |   3 A$3dForC.pre.a     0805 GR
  3 A$3dForC.pre.a     0808 GR  |   3 A$3dForC.pre.a     080B GR
  3 A$3dForC.pre.a     080E GR  |   3 A$3dForC.pre.a     0810 GR
  3 A$3dForC.pre.a     0811 GR  |   3 A$3dForC.pre.a     0812 GR
  3 A$3dForC.pre.a     0814 GR  |   3 A$3dForC.pre.a     0815 GR
  3 A$3dForC.pre.a     0817 GR  |   3 A$3dForC.pre.a     0818 GR
  3 A$3dForC.pre.a     081A GR  |   3 A$3dForC.pre.a     081B GR
  3 A$3dForC.pre.a     081C GR  |   3 A$3dForC.pre.a     081D GR
  3 A$3dForC.pre.a     081E GR  |   3 A$3dForC.pre.a     0820 GR
  3 A$3dForC.pre.a     0821 GR  |   3 A$3dForC.pre.a     0822 GR
  3 A$3dForC.pre.a     0823 GR  |   3 A$3dForC.pre.a     0824 GR
  3 A$3dForC.pre.a     0825 GR  |   3 A$3dForC.pre.a     0828 GR
  3 A$3dForC.pre.a     082B GR  |   3 A$3dForC.pre.a     082E GR
  3 A$3dForC.pre.a     0830 GR  |   3 A$3dForC.pre.a     0831 GR
  3 A$3dForC.pre.a     0832 GR  |   3 A$3dForC.pre.a     0834 GR
  3 A$3dForC.pre.a     0835 GR  |   3 A$3dForC.pre.a     0837 GR
  3 A$3dForC.pre.a     0838 GR  |   3 A$3dForC.pre.a     083A GR
  3 A$3dForC.pre.a     083B GR  |   3 A$3dForC.pre.a     083C GR
  3 A$3dForC.pre.a     083D GR  |   3 A$3dForC.pre.a     083E GR
  3 A$3dForC.pre.a     0840 GR  |   3 A$3dForC.pre.a     0841 GR
  3 A$3dForC.pre.a     0842 GR  |   3 A$3dForC.pre.a     0843 GR
  3 A$3dForC.pre.a     0844 GR  |   3 A$3dForC.pre.a     0845 GR
  3 A$3dForC.pre.a     0848 GR  |   3 A$3dForC.pre.a     084B GR
  3 A$3dForC.pre.a     084C GR  |   3 A$3dForC.pre.a     084F GR
  3 A$3dForC.pre.a     0852 GR  |   3 A$3dForC.pre.a     0855 GR
  3 A$3dForC.pre.a     0857 GR  |   3 A$3dForC.pre.a     0858 GR
  3 A$3dForC.pre.a     0859 GR  |   3 A$3dForC.pre.a     085B GR
  3 A$3dForC.pre.a     085C GR  |   3 A$3dForC.pre.a     085E GR
  3 A$3dForC.pre.a     085F GR  |   3 A$3dForC.pre.a     0861 GR
  3 A$3dForC.pre.a     0862 GR  |   3 A$3dForC.pre.a     0863 GR
  3 A$3dForC.pre.a     0864 GR  |   3 A$3dForC.pre.a     0865 GR
  3 A$3dForC.pre.a     0867 GR  |   3 A$3dForC.pre.a     0868 GR
  3 A$3dForC.pre.a     0869 GR  |   3 A$3dForC.pre.a     086A GR
  3 A$3dForC.pre.a     086B GR  |   3 A$3dForC.pre.a     086C GR
  3 A$3dForC.pre.a     086F GR  |   3 A$3dForC.pre.a     0872 GR
  3 A$3dForC.pre.a     0875 GR  |   3 A$3dForC.pre.a     0877 GR
  3 A$3dForC.pre.a     0878 GR  |   3 A$3dForC.pre.a     0879 GR
  3 A$3dForC.pre.a     087B GR  |   3 A$3dForC.pre.a     087C GR
  3 A$3dForC.pre.a     087E GR  |   3 A$3dForC.pre.a     087F GR
  3 A$3dForC.pre.a     0881 GR  |   3 A$3dForC.pre.a     0882 GR
  3 A$3dForC.pre.a     0883 GR  |   3 A$3dForC.pre.a     0884 GR
  3 A$3dForC.pre.a     0885 GR  |   3 A$3dForC.pre.a     0887 GR
  3 A$3dForC.pre.a     0888 GR  |   3 A$3dForC.pre.a     0889 GR
  3 A$3dForC.pre.a     088A GR  |   3 A$3dForC.pre.a     088B GR
  3 A$3dForC.pre.a     088C GR  |   3 A$3dForC.pre.a     088D GR
  3 A$3dForC.pre.a     0890 GR  |   3 A$3dForC.pre.a     0893 GR
  3 A$3dForC.pre.a     0894 GR  |   3 A$3dForC.pre.a     0897 GR
  3 A$3dForC.pre.a     089A GR  |   3 A$3dForC.pre.a     089C GR
  3 A$3dForC.pre.a     08A0 GR  |   3 A$3dForC.pre.a     08A3 GR
  3 A$3dForC.pre.a     08A6 GR  |   3 A$3dForC.pre.a     08A7 GR
  3 A$3dForC.pre.a     08AA GR  |   3 A$3dForC.pre.a     08AD GR
  3 A$3dForC.pre.a     08B0 GR  |   3 A$3dForC.pre.a     08B2 GR
  3 A$3dForC.pre.a     08B3 GR  |   3 A$3dForC.pre.a     08B4 GR
  3 A$3dForC.pre.a     08B6 GR  |   3 A$3dForC.pre.a     08B7 GR
  3 A$3dForC.pre.a     08B9 GR  |   3 A$3dForC.pre.a     08BA GR
  3 A$3dForC.pre.a     08BC GR  |   3 A$3dForC.pre.a     08BD GR
  3 A$3dForC.pre.a     08BE GR  |   3 A$3dForC.pre.a     08BF GR
  3 A$3dForC.pre.a     08C0 GR  |   3 A$3dForC.pre.a     08C2 GR
  3 A$3dForC.pre.a     08C3 GR  |   3 A$3dForC.pre.a     08C4 GR
  3 A$3dForC.pre.a     08C5 GR  |   3 A$3dForC.pre.a     08C6 GR
  3 A$3dForC.pre.a     08C7 GR  |   3 A$3dForC.pre.a     08CA GR
  3 A$3dForC.pre.a     08CD GR  |   3 A$3dForC.pre.a     08D0 GR
  3 A$3dForC.pre.a     08D2 GR  |   3 A$3dForC.pre.a     08D3 GR
  3 A$3dForC.pre.a     08D4 GR  |   3 A$3dForC.pre.a     08D6 GR
  3 A$3dForC.pre.a     08D7 GR  |   3 A$3dForC.pre.a     08D9 GR
  3 A$3dForC.pre.a     08DA GR  |   3 A$3dForC.pre.a     08DC GR
  3 A$3dForC.pre.a     08DD GR  |   3 A$3dForC.pre.a     08DE GR
  3 A$3dForC.pre.a     08DF GR  |   3 A$3dForC.pre.a     08E0 GR
  3 A$3dForC.pre.a     08E2 GR  |   3 A$3dForC.pre.a     08E3 GR
  3 A$3dForC.pre.a     08E4 GR  |   3 A$3dForC.pre.a     08E5 GR
  3 A$3dForC.pre.a     08E6 GR  |   3 A$3dForC.pre.a     08E7 GR
  3 A$3dForC.pre.a     08EA GR  |   3 A$3dForC.pre.a     08ED GR
  3 A$3dForC.pre.a     08F0 GR  |   3 A$3dForC.pre.a     08F2 GR
  3 A$3dForC.pre.a     08F3 GR  |   3 A$3dForC.pre.a     08F4 GR
  3 A$3dForC.pre.a     08F6 GR  |   3 A$3dForC.pre.a     08F7 GR
  3 A$3dForC.pre.a     08F9 GR  |   3 A$3dForC.pre.a     08FA GR
  3 A$3dForC.pre.a     08FC GR  |   3 A$3dForC.pre.a     08FD GR
  3 A$3dForC.pre.a     08FE GR  |   3 A$3dForC.pre.a     08FF GR
  3 A$3dForC.pre.a     0900 GR  |   3 A$3dForC.pre.a     0902 GR
  3 A$3dForC.pre.a     0903 GR  |   3 A$3dForC.pre.a     0904 GR
  3 A$3dForC.pre.a     0905 GR  |   3 A$3dForC.pre.a     0906 GR
  3 A$3dForC.pre.a     0907 GR  |   3 A$3dForC.pre.a     090A GR
  3 A$3dForC.pre.a     090D GR  |   3 A$3dForC.pre.a     090E GR
  3 A$3dForC.pre.a     0911 GR  |   3 A$3dForC.pre.a     0914 GR
  3 A$3dForC.pre.a     0917 GR  |   3 A$3dForC.pre.a     0919 GR
  3 A$3dForC.pre.a     091A GR  |   3 A$3dForC.pre.a     091B GR
  3 A$3dForC.pre.a     091D GR  |   3 A$3dForC.pre.a     091E GR
  3 A$3dForC.pre.a     0920 GR  |   3 A$3dForC.pre.a     0921 GR
  3 A$3dForC.pre.a     0923 GR  |   3 A$3dForC.pre.a     0924 GR
  3 A$3dForC.pre.a     0925 GR  |   3 A$3dForC.pre.a     0926 GR
  3 A$3dForC.pre.a     0927 GR  |   3 A$3dForC.pre.a     0929 GR
  3 A$3dForC.pre.a     092A GR  |   3 A$3dForC.pre.a     092B GR
  3 A$3dForC.pre.a     092C GR  |   3 A$3dForC.pre.a     092D GR
  3 A$3dForC.pre.a     092E GR  |   3 A$3dForC.pre.a     0931 GR
  3 A$3dForC.pre.a     0934 GR  |   3 A$3dForC.pre.a     0937 GR
  3 A$3dForC.pre.a     0939 GR  |   3 A$3dForC.pre.a     093A GR
  3 A$3dForC.pre.a     093B GR  |   3 A$3dForC.pre.a     093D GR
  3 A$3dForC.pre.a     093E GR  |   3 A$3dForC.pre.a     0940 GR
  3 A$3dForC.pre.a     0941 GR  |   3 A$3dForC.pre.a     0943 GR
  3 A$3dForC.pre.a     0944 GR  |   3 A$3dForC.pre.a     0945 GR
  3 A$3dForC.pre.a     0946 GR  |   3 A$3dForC.pre.a     0947 GR
  3 A$3dForC.pre.a     0949 GR  |   3 A$3dForC.pre.a     094A GR
  3 A$3dForC.pre.a     094B GR  |   3 A$3dForC.pre.a     094C GR
  3 A$3dForC.pre.a     094D GR  |   3 A$3dForC.pre.a     094E GR
  3 A$3dForC.pre.a     094F GR  |   3 A$3dForC.pre.a     0952 GR
  3 A$3dForC.pre.a     0955 GR  |   3 A$3dForC.pre.a     0956 GR
  3 A$3dForC.pre.a     0959 GR  |   3 A$3dForC.pre.a     095C GR
  3 A$3dForC.pre.a     095E GR  |   3 A$3dForC.pre.a     0962 GR
  3 A$3dForC.pre.a     0965 GR  |   3 A$3dForC.pre.a     0968 GR
  3 A$3dForC.pre.a     0969 GR  |   3 A$3dForC.pre.a     096C GR
  3 A$3dForC.pre.a     096F GR  |   3 A$3dForC.pre.a     0970 GR
  3 A$3dForC.pre.a     0973 GR  |   3 A$3dForC.pre.a     0976 GR
  3 A$3dForC.pre.a     0979 GR  |   3 A$3dForC.pre.a     097B GR
  3 A$3dForC.pre.a     097C GR  |   3 A$3dForC.pre.a     097D GR
  3 A$3dForC.pre.a     097F GR  |   3 A$3dForC.pre.a     0980 GR
  3 A$3dForC.pre.a     0982 GR  |   3 A$3dForC.pre.a     0983 GR
  3 A$3dForC.pre.a     0985 GR  |   3 A$3dForC.pre.a     0986 GR
  3 A$3dForC.pre.a     0987 GR  |   3 A$3dForC.pre.a     0988 GR
  3 A$3dForC.pre.a     0989 GR  |   3 A$3dForC.pre.a     098B GR
  3 A$3dForC.pre.a     098C GR  |   3 A$3dForC.pre.a     098D GR
  3 A$3dForC.pre.a     098E GR  |   3 A$3dForC.pre.a     098F GR
  3 A$3dForC.pre.a     0990 GR  |   3 A$3dForC.pre.a     0993 GR
  3 A$3dForC.pre.a     0996 GR  |   3 A$3dForC.pre.a     0999 GR
  3 A$3dForC.pre.a     099C GR  |   3 A$3dForC.pre.a     099E GR
  3 A$3dForC.pre.a     099F GR  |   3 A$3dForC.pre.a     09A0 GR
  3 A$3dForC.pre.a     09A2 GR  |   3 A$3dForC.pre.a     09A3 GR
  3 A$3dForC.pre.a     09A5 GR  |   3 A$3dForC.pre.a     09A6 GR
  3 A$3dForC.pre.a     09A8 GR  |   3 A$3dForC.pre.a     09A9 GR
  3 A$3dForC.pre.a     09AA GR  |   3 A$3dForC.pre.a     09AB GR
  3 A$3dForC.pre.a     09AC GR  |   3 A$3dForC.pre.a     09AE GR
  3 A$3dForC.pre.a     09AF GR  |   3 A$3dForC.pre.a     09B0 GR
  3 A$3dForC.pre.a     09B1 GR  |   3 A$3dForC.pre.a     09B2 GR
  3 A$3dForC.pre.a     09B3 GR  |   3 A$3dForC.pre.a     09B6 GR
  3 A$3dForC.pre.a     09B9 GR  |   3 A$3dForC.pre.a     09BC GR
  3 A$3dForC.pre.a     09BE GR  |   3 A$3dForC.pre.a     09BF GR
  3 A$3dForC.pre.a     09C0 GR  |   3 A$3dForC.pre.a     09C2 GR
  3 A$3dForC.pre.a     09C3 GR  |   3 A$3dForC.pre.a     09C5 GR
  3 A$3dForC.pre.a     09C6 GR  |   3 A$3dForC.pre.a     09C8 GR
  3 A$3dForC.pre.a     09C9 GR  |   3 A$3dForC.pre.a     09CA GR
  3 A$3dForC.pre.a     09CB GR  |   3 A$3dForC.pre.a     09CC GR
  3 A$3dForC.pre.a     09CE GR  |   3 A$3dForC.pre.a     09CF GR
  3 A$3dForC.pre.a     09D0 GR  |   3 A$3dForC.pre.a     09D1 GR
  3 A$3dForC.pre.a     09D2 GR  |   3 A$3dForC.pre.a     09D3 GR
  3 A$3dForC.pre.a     09D6 GR  |   3 A$3dForC.pre.a     09D9 GR
  3 A$3dForC.pre.a     09DA GR  |   3 A$3dForC.pre.a     09DD GR
  3 A$3dForC.pre.a     09E0 GR  |   3 A$3dForC.pre.a     09E3 GR
  3 A$3dForC.pre.a     09E5 GR  |   3 A$3dForC.pre.a     09E6 GR
  3 A$3dForC.pre.a     09E7 GR  |   3 A$3dForC.pre.a     09E9 GR
  3 A$3dForC.pre.a     09EA GR  |   3 A$3dForC.pre.a     09EC GR
  3 A$3dForC.pre.a     09ED GR  |   3 A$3dForC.pre.a     09EF GR
  3 A$3dForC.pre.a     09F0 GR  |   3 A$3dForC.pre.a     09F1 GR
  3 A$3dForC.pre.a     09F2 GR  |   3 A$3dForC.pre.a     09F3 GR
  3 A$3dForC.pre.a     09F5 GR  |   3 A$3dForC.pre.a     09F6 GR
  3 A$3dForC.pre.a     09F7 GR  |   3 A$3dForC.pre.a     09F8 GR
  3 A$3dForC.pre.a     09F9 GR  |   3 A$3dForC.pre.a     09FA GR
  3 A$3dForC.pre.a     09FD GR  |   3 A$3dForC.pre.a     0A00 GR
  3 A$3dForC.pre.a     0A03 GR  |   3 A$3dForC.pre.a     0A05 GR
  3 A$3dForC.pre.a     0A06 GR  |   3 A$3dForC.pre.a     0A07 GR
  3 A$3dForC.pre.a     0A09 GR  |   3 A$3dForC.pre.a     0A0A GR
  3 A$3dForC.pre.a     0A0C GR  |   3 A$3dForC.pre.a     0A0D GR
  3 A$3dForC.pre.a     0A0F GR  |   3 A$3dForC.pre.a     0A10 GR
  3 A$3dForC.pre.a     0A11 GR  |   3 A$3dForC.pre.a     0A12 GR
  3 A$3dForC.pre.a     0A13 GR  |   3 A$3dForC.pre.a     0A15 GR
  3 A$3dForC.pre.a     0A16 GR  |   3 A$3dForC.pre.a     0A17 GR
  3 A$3dForC.pre.a     0A18 GR  |   3 A$3dForC.pre.a     0A19 GR
  3 A$3dForC.pre.a     0A1A GR  |   3 A$3dForC.pre.a     0A1B GR
  3 A$3dForC.pre.a     0A1E GR  |   3 A$3dForC.pre.a     0A21 GR
  3 A$3dForC.pre.a     0A22 GR  |   3 A$3dForC.pre.a     0A25 GR
  3 A$3dForC.pre.a     0A28 GR  |   3 A$3dForC.pre.a     0A2A GR
  3 A$3dForC.pre.a     0A2E GR  |   3 A$3dForC.pre.a     0A31 GR
  3 A$3dForC.pre.a     0A34 GR  |   3 A$3dForC.pre.a     0A35 GR
  3 A$3dForC.pre.a     0A38 GR  |   3 A$3dForC.pre.a     0A3B GR
  3 A$3dForC.pre.a     0A3E GR  |   3 A$3dForC.pre.a     0A40 GR
  3 A$3dForC.pre.a     0A41 GR  |   3 A$3dForC.pre.a     0A42 GR
  3 A$3dForC.pre.a     0A44 GR  |   3 A$3dForC.pre.a     0A45 GR
  3 A$3dForC.pre.a     0A47 GR  |   3 A$3dForC.pre.a     0A48 GR
  3 A$3dForC.pre.a     0A4A GR  |   3 A$3dForC.pre.a     0A4B GR
  3 A$3dForC.pre.a     0A4C GR  |   3 A$3dForC.pre.a     0A4D GR
  3 A$3dForC.pre.a     0A4E GR  |   3 A$3dForC.pre.a     0A50 GR
  3 A$3dForC.pre.a     0A51 GR  |   3 A$3dForC.pre.a     0A52 GR
  3 A$3dForC.pre.a     0A53 GR  |   3 A$3dForC.pre.a     0A54 GR
  3 A$3dForC.pre.a     0A55 GR  |   3 A$3dForC.pre.a     0A58 GR
  3 A$3dForC.pre.a     0A5B GR  |   3 A$3dForC.pre.a     0A5E GR
  3 A$3dForC.pre.a     0A61 GR  |   3 A$3dForC.pre.a     0A63 GR
  3 A$3dForC.pre.a     0A64 GR  |   3 A$3dForC.pre.a     0A65 GR
  3 A$3dForC.pre.a     0A67 GR  |   3 A$3dForC.pre.a     0A68 GR
  3 A$3dForC.pre.a     0A6A GR  |   3 A$3dForC.pre.a     0A6B GR
  3 A$3dForC.pre.a     0A6D GR  |   3 A$3dForC.pre.a     0A6E GR
  3 A$3dForC.pre.a     0A6F GR  |   3 A$3dForC.pre.a     0A70 GR
  3 A$3dForC.pre.a     0A71 GR  |   3 A$3dForC.pre.a     0A73 GR
  3 A$3dForC.pre.a     0A74 GR  |   3 A$3dForC.pre.a     0A75 GR
  3 A$3dForC.pre.a     0A76 GR  |   3 A$3dForC.pre.a     0A77 GR
  3 A$3dForC.pre.a     0A78 GR  |   3 A$3dForC.pre.a     0A7B GR
  3 A$3dForC.pre.a     0A7E GR  |   3 A$3dForC.pre.a     0A81 GR
  3 A$3dForC.pre.a     0A83 GR  |   3 A$3dForC.pre.a     0A84 GR
  3 A$3dForC.pre.a     0A85 GR  |   3 A$3dForC.pre.a     0A87 GR
  3 A$3dForC.pre.a     0A88 GR  |   3 A$3dForC.pre.a     0A8A GR
  3 A$3dForC.pre.a     0A8B GR  |   3 A$3dForC.pre.a     0A8D GR
  3 A$3dForC.pre.a     0A8E GR  |   3 A$3dForC.pre.a     0A8F GR
  3 A$3dForC.pre.a     0A90 GR  |   3 A$3dForC.pre.a     0A91 GR
  3 A$3dForC.pre.a     0A93 GR  |   3 A$3dForC.pre.a     0A94 GR
  3 A$3dForC.pre.a     0A95 GR  |   3 A$3dForC.pre.a     0A96 GR
  3 A$3dForC.pre.a     0A97 GR  |   3 A$3dForC.pre.a     0A98 GR
  3 A$3dForC.pre.a     0A9B GR  |   3 A$3dForC.pre.a     0A9E GR
  3 A$3dForC.pre.a     0A9F GR  |   3 A$3dForC.pre.a     0AA2 GR
  3 A$3dForC.pre.a     0AA5 GR  |   3 A$3dForC.pre.a     0AA8 GR
  3 A$3dForC.pre.a     0AAA GR  |   3 A$3dForC.pre.a     0AAB GR
  3 A$3dForC.pre.a     0AAC GR  |   3 A$3dForC.pre.a     0AAE GR
  3 A$3dForC.pre.a     0AAF GR  |   3 A$3dForC.pre.a     0AB1 GR
  3 A$3dForC.pre.a     0AB2 GR  |   3 A$3dForC.pre.a     0AB4 GR
  3 A$3dForC.pre.a     0AB5 GR  |   3 A$3dForC.pre.a     0AB6 GR
  3 A$3dForC.pre.a     0AB7 GR  |   3 A$3dForC.pre.a     0AB8 GR
  3 A$3dForC.pre.a     0ABA GR  |   3 A$3dForC.pre.a     0ABB GR
  3 A$3dForC.pre.a     0ABC GR  |   3 A$3dForC.pre.a     0ABD GR
  3 A$3dForC.pre.a     0ABE GR  |   3 A$3dForC.pre.a     0ABF GR
  3 A$3dForC.pre.a     0AC2 GR  |   3 A$3dForC.pre.a     0AC5 GR
  3 A$3dForC.pre.a     0AC8 GR  |   3 A$3dForC.pre.a     0ACA GR
  3 A$3dForC.pre.a     0ACB GR  |   3 A$3dForC.pre.a     0ACC GR
  3 A$3dForC.pre.a     0ACE GR  |   3 A$3dForC.pre.a     0ACF GR
  3 A$3dForC.pre.a     0AD1 GR  |   3 A$3dForC.pre.a     0AD2 GR
  3 A$3dForC.pre.a     0AD4 GR  |   3 A$3dForC.pre.a     0AD5 GR
  3 A$3dForC.pre.a     0AD6 GR  |   3 A$3dForC.pre.a     0AD7 GR
  3 A$3dForC.pre.a     0AD8 GR  |   3 A$3dForC.pre.a     0ADA GR
  3 A$3dForC.pre.a     0ADB GR  |   3 A$3dForC.pre.a     0ADC GR
  3 A$3dForC.pre.a     0ADD GR  |   3 A$3dForC.pre.a     0ADE GR
  3 A$3dForC.pre.a     0ADF GR  |   3 A$3dForC.pre.a     0AE0 GR
  3 A$3dForC.pre.a     0AE3 GR  |   3 A$3dForC.pre.a     0AE6 GR
  3 A$3dForC.pre.a     0AE7 GR  |   3 A$3dForC.pre.a     0AEA GR
  3 A$3dForC.pre.a     0AED GR  |   3 A$3dForC.pre.a     0AEF GR
  3 A$3dForC.pre.a     0AF3 GR  |   3 A$3dForC.pre.a     0AF6 GR
  3 A$3dForC.pre.a     0AF9 GR  |   3 A$3dForC.pre.a     0AFC GR
  3 A$3dForC.pre.a     0AFD GR  |   3 A$3dForC.pre.a     0B00 GR
  3 A$3dForC.pre.a     0B03 GR  |   3 A$3dForC.pre.a     0B06 GR
  3 A$3dForC.pre.a     0B09 GR  |   3 A$3dForC.pre.a     0B0C GR
  3 A$3dForC.pre.a     0B0F GR  |   3 A$3dForC.pre.a     0B12 GR
  3 A$3dForC.pre.a     0B15 GR  |   3 A$3dForC.pre.a     0B18 GR
  3 A$3dForC.pre.a     0B1A GR  |   3 A$3dForC.pre.a     0B1B GR
  3 A$3dForC.pre.a     0B1C GR  |   3 A$3dForC.pre.a     0B1E GR
  3 A$3dForC.pre.a     0B1F GR  |   3 A$3dForC.pre.a     0B21 GR
  3 A$3dForC.pre.a     0B22 GR  |   3 A$3dForC.pre.a     0B24 GR
  3 A$3dForC.pre.a     0B25 GR  |   3 A$3dForC.pre.a     0B26 GR
  3 A$3dForC.pre.a     0B27 GR  |   3 A$3dForC.pre.a     0B28 GR
  3 A$3dForC.pre.a     0B2A GR  |   3 A$3dForC.pre.a     0B2B GR
  3 A$3dForC.pre.a     0B2C GR  |   3 A$3dForC.pre.a     0B2D GR
  3 A$3dForC.pre.a     0B2E GR  |   3 A$3dForC.pre.a     0B2F GR
  3 A$3dForC.pre.a     0B32 GR  |   3 A$3dForC.pre.a     0B35 GR
  3 A$3dForC.pre.a     0B38 GR  |   3 A$3dForC.pre.a     0B3A GR
  3 A$3dForC.pre.a     0B3B GR  |   3 A$3dForC.pre.a     0B3C GR
  3 A$3dForC.pre.a     0B3E GR  |   3 A$3dForC.pre.a     0B3F GR
  3 A$3dForC.pre.a     0B41 GR  |   3 A$3dForC.pre.a     0B42 GR
  3 A$3dForC.pre.a     0B44 GR  |   3 A$3dForC.pre.a     0B45 GR
  3 A$3dForC.pre.a     0B46 GR  |   3 A$3dForC.pre.a     0B47 GR
  3 A$3dForC.pre.a     0B48 GR  |   3 A$3dForC.pre.a     0B4A GR
  3 A$3dForC.pre.a     0B4B GR  |   3 A$3dForC.pre.a     0B4C GR
  3 A$3dForC.pre.a     0B4D GR  |   3 A$3dForC.pre.a     0B4E GR
  3 A$3dForC.pre.a     0B4F GR  |   3 A$3dForC.pre.a     0B52 GR
  3 A$3dForC.pre.a     0B55 GR  |   3 A$3dForC.pre.a     0B58 GR
  3 A$3dForC.pre.a     0B5A GR  |   3 A$3dForC.pre.a     0B5B GR
  3 A$3dForC.pre.a     0B5C GR  |   3 A$3dForC.pre.a     0B5E GR
  3 A$3dForC.pre.a     0B5F GR  |   3 A$3dForC.pre.a     0B61 GR
  3 A$3dForC.pre.a     0B62 GR  |   3 A$3dForC.pre.a     0B64 GR
  3 A$3dForC.pre.a     0B65 GR  |   3 A$3dForC.pre.a     0B66 GR
  3 A$3dForC.pre.a     0B67 GR  |   3 A$3dForC.pre.a     0B68 GR
  3 A$3dForC.pre.a     0B6A GR  |   3 A$3dForC.pre.a     0B6B GR
  3 A$3dForC.pre.a     0B6C GR  |   3 A$3dForC.pre.a     0B6D GR
  3 A$3dForC.pre.a     0B6E GR  |   3 A$3dForC.pre.a     0B6F GR
  3 A$3dForC.pre.a     0B72 GR  |   3 A$3dForC.pre.a     0B75 GR
  3 A$3dForC.pre.a     0B76 GR  |   3 A$3dForC.pre.a     0B79 GR
  3 A$3dForC.pre.a     0B7C GR  |   3 A$3dForC.pre.a     0B7F GR
  3 A$3dForC.pre.a     0B81 GR  |   3 A$3dForC.pre.a     0B82 GR
  3 A$3dForC.pre.a     0B83 GR  |   3 A$3dForC.pre.a     0B85 GR
  3 A$3dForC.pre.a     0B86 GR  |   3 A$3dForC.pre.a     0B88 GR
  3 A$3dForC.pre.a     0B89 GR  |   3 A$3dForC.pre.a     0B8B GR
  3 A$3dForC.pre.a     0B8C GR  |   3 A$3dForC.pre.a     0B8D GR
  3 A$3dForC.pre.a     0B8E GR  |   3 A$3dForC.pre.a     0B8F GR
  3 A$3dForC.pre.a     0B91 GR  |   3 A$3dForC.pre.a     0B92 GR
  3 A$3dForC.pre.a     0B93 GR  |   3 A$3dForC.pre.a     0B94 GR
  3 A$3dForC.pre.a     0B95 GR  |   3 A$3dForC.pre.a     0B96 GR
  3 A$3dForC.pre.a     0B99 GR  |   3 A$3dForC.pre.a     0B9C GR
  3 A$3dForC.pre.a     0B9F GR  |   3 A$3dForC.pre.a     0BA1 GR
  3 A$3dForC.pre.a     0BA2 GR  |   3 A$3dForC.pre.a     0BA3 GR
  3 A$3dForC.pre.a     0BA5 GR  |   3 A$3dForC.pre.a     0BA6 GR
  3 A$3dForC.pre.a     0BA8 GR  |   3 A$3dForC.pre.a     0BA9 GR
  3 A$3dForC.pre.a     0BAB GR  |   3 A$3dForC.pre.a     0BAC GR
  3 A$3dForC.pre.a     0BAD GR  |   3 A$3dForC.pre.a     0BAE GR
  3 A$3dForC.pre.a     0BAF GR  |   3 A$3dForC.pre.a     0BB1 GR
  3 A$3dForC.pre.a     0BB2 GR  |   3 A$3dForC.pre.a     0BB3 GR
  3 A$3dForC.pre.a     0BB4 GR  |   3 A$3dForC.pre.a     0BB5 GR
  3 A$3dForC.pre.a     0BB6 GR  |   3 A$3dForC.pre.a     0BB7 GR
  3 A$3dForC.pre.a     0BBA GR  |   3 A$3dForC.pre.a     0BBD GR
  3 A$3dForC.pre.a     0BBE GR  |   3 A$3dForC.pre.a     0BC1 GR
  3 A$3dForC.pre.a     0BC4 GR  |   3 A$3dForC.pre.a     0BC6 GR
  3 A$3dForC.pre.a     0BCA GR  |   3 A$3dForC.pre.a     0BCD GR
  3 A$3dForC.pre.a     0BD0 GR  |   3 A$3dForC.pre.a     0BD3 GR
  3 A$3dForC.pre.a     0BD4 GR  |   3 A$3dForC.pre.a     0BD7 GR
  3 A$3dForC.pre.a     0BDA GR  |   3 A$3dForC.pre.a     0BDD GR
  3 A$3dForC.pre.a     0BE0 GR  |   3 A$3dForC.pre.a     0BE3 GR
  3 A$3dForC.pre.a     0BE6 GR  |   3 A$3dForC.pre.a     0BE9 GR
  3 A$3dForC.pre.a     0BEC GR  |   3 A$3dForC.pre.a     0BEF GR
  3 A$3dForC.pre.a     0BF1 GR  |   3 A$3dForC.pre.a     0BF2 GR
  3 A$3dForC.pre.a     0BF3 GR  |   3 A$3dForC.pre.a     0BF5 GR
  3 A$3dForC.pre.a     0BF6 GR  |   3 A$3dForC.pre.a     0BF8 GR
  3 A$3dForC.pre.a     0BF9 GR  |   3 A$3dForC.pre.a     0BFB GR
  3 A$3dForC.pre.a     0BFC GR  |   3 A$3dForC.pre.a     0BFD GR
  3 A$3dForC.pre.a     0BFE GR  |   3 A$3dForC.pre.a     0BFF GR
  3 A$3dForC.pre.a     0C01 GR  |   3 A$3dForC.pre.a     0C02 GR
  3 A$3dForC.pre.a     0C03 GR  |   3 A$3dForC.pre.a     0C04 GR
  3 A$3dForC.pre.a     0C05 GR  |   3 A$3dForC.pre.a     0C06 GR
  3 A$3dForC.pre.a     0C09 GR  |   3 A$3dForC.pre.a     0C0C GR
  3 A$3dForC.pre.a     0C0F GR  |   3 A$3dForC.pre.a     0C12 GR
  3 A$3dForC.pre.a     0C14 GR  |   3 A$3dForC.pre.a     0C15 GR
  3 A$3dForC.pre.a     0C16 GR  |   3 A$3dForC.pre.a     0C18 GR
  3 A$3dForC.pre.a     0C19 GR  |   3 A$3dForC.pre.a     0C1B GR
  3 A$3dForC.pre.a     0C1C GR  |   3 A$3dForC.pre.a     0C1E GR
  3 A$3dForC.pre.a     0C1F GR  |   3 A$3dForC.pre.a     0C20 GR
  3 A$3dForC.pre.a     0C21 GR  |   3 A$3dForC.pre.a     0C22 GR
  3 A$3dForC.pre.a     0C24 GR  |   3 A$3dForC.pre.a     0C25 GR
  3 A$3dForC.pre.a     0C26 GR  |   3 A$3dForC.pre.a     0C27 GR
  3 A$3dForC.pre.a     0C28 GR  |   3 A$3dForC.pre.a     0C29 GR
  3 A$3dForC.pre.a     0C2C GR  |   3 A$3dForC.pre.a     0C2F GR
  3 A$3dForC.pre.a     0C32 GR  |   3 A$3dForC.pre.a     0C34 GR
  3 A$3dForC.pre.a     0C35 GR  |   3 A$3dForC.pre.a     0C36 GR
  3 A$3dForC.pre.a     0C38 GR  |   3 A$3dForC.pre.a     0C39 GR
  3 A$3dForC.pre.a     0C3B GR  |   3 A$3dForC.pre.a     0C3C GR
  3 A$3dForC.pre.a     0C3E GR  |   3 A$3dForC.pre.a     0C3F GR
  3 A$3dForC.pre.a     0C40 GR  |   3 A$3dForC.pre.a     0C41 GR
  3 A$3dForC.pre.a     0C42 GR  |   3 A$3dForC.pre.a     0C44 GR
  3 A$3dForC.pre.a     0C45 GR  |   3 A$3dForC.pre.a     0C46 GR
  3 A$3dForC.pre.a     0C47 GR  |   3 A$3dForC.pre.a     0C48 GR
  3 A$3dForC.pre.a     0C49 GR  |   3 A$3dForC.pre.a     0C4C GR
  3 A$3dForC.pre.a     0C4F GR  |   3 A$3dForC.pre.a     0C50 GR
  3 A$3dForC.pre.a     0C53 GR  |   3 A$3dForC.pre.a     0C56 GR
  3 A$3dForC.pre.a     0C59 GR  |   3 A$3dForC.pre.a     0C5B GR
  3 A$3dForC.pre.a     0C5C GR  |   3 A$3dForC.pre.a     0C5D GR
  3 A$3dForC.pre.a     0C5F GR  |   3 A$3dForC.pre.a     0C60 GR
  3 A$3dForC.pre.a     0C62 GR  |   3 A$3dForC.pre.a     0C63 GR
  3 A$3dForC.pre.a     0C65 GR  |   3 A$3dForC.pre.a     0C66 GR
  3 A$3dForC.pre.a     0C67 GR  |   3 A$3dForC.pre.a     0C68 GR
  3 A$3dForC.pre.a     0C69 GR  |   3 A$3dForC.pre.a     0C6B GR
  3 A$3dForC.pre.a     0C6C GR  |   3 A$3dForC.pre.a     0C6D GR
  3 A$3dForC.pre.a     0C6E GR  |   3 A$3dForC.pre.a     0C6F GR
  3 A$3dForC.pre.a     0C70 GR  |   3 A$3dForC.pre.a     0C73 GR
  3 A$3dForC.pre.a     0C76 GR  |   3 A$3dForC.pre.a     0C79 GR
  3 A$3dForC.pre.a     0C7B GR  |   3 A$3dForC.pre.a     0C7C GR
  3 A$3dForC.pre.a     0C7D GR  |   3 A$3dForC.pre.a     0C7F GR
  3 A$3dForC.pre.a     0C80 GR  |   3 A$3dForC.pre.a     0C82 GR
  3 A$3dForC.pre.a     0C83 GR  |   3 A$3dForC.pre.a     0C85 GR
  3 A$3dForC.pre.a     0C86 GR  |   3 A$3dForC.pre.a     0C87 GR
  3 A$3dForC.pre.a     0C88 GR  |   3 A$3dForC.pre.a     0C89 GR
  3 A$3dForC.pre.a     0C8B GR  |   3 A$3dForC.pre.a     0C8C GR
  3 A$3dForC.pre.a     0C8D GR  |   3 A$3dForC.pre.a     0C8E GR
  3 A$3dForC.pre.a     0C8F GR  |   3 A$3dForC.pre.a     0C90 GR
  3 A$3dForC.pre.a     0C91 GR  |   3 A$3dForC.pre.a     0C94 GR
  3 A$3dForC.pre.a     0C97 GR  |   3 A$3dForC.pre.a     0C98 GR
  3 A$3dForC.pre.a     0C9B GR  |   3 A$3dForC.pre.a     0C9E GR
  3 A$3dForC.pre.a     0CA0 GR  |   3 A$3dForC.pre.a     0CA4 GR
  3 A$3dForC.pre.a     0CA7 GR  |   3 A$3dForC.pre.a     0CAA GR
  3 A$3dForC.pre.a     0CAD GR  |   3 A$3dForC.pre.a     0CAE GR
  3 A$3dForC.pre.a     0CB1 GR  |   3 A$3dForC.pre.a     0CB4 GR
  3 A$3dForC.pre.a     0CB7 GR  |   3 A$3dForC.pre.a     0CBA GR
  3 A$3dForC.pre.a     0CBD GR  |   3 A$3dForC.pre.a     0CC0 GR
  3 A$3dForC.pre.a     0CC3 GR  |   3 A$3dForC.pre.a     0CC6 GR
  3 A$3dForC.pre.a     0CC9 GR  |   3 A$3dForC.pre.a     0CCB GR
  3 A$3dForC.pre.a     0CCC GR  |   3 A$3dForC.pre.a     0CCD GR
  3 A$3dForC.pre.a     0CCF GR  |   3 A$3dForC.pre.a     0CD0 GR
  3 A$3dForC.pre.a     0CD2 GR  |   3 A$3dForC.pre.a     0CD3 GR
  3 A$3dForC.pre.a     0CD5 GR  |   3 A$3dForC.pre.a     0CD6 GR
  3 A$3dForC.pre.a     0CD7 GR  |   3 A$3dForC.pre.a     0CD8 GR
  3 A$3dForC.pre.a     0CD9 GR  |   3 A$3dForC.pre.a     0CDB GR
  3 A$3dForC.pre.a     0CDC GR  |   3 A$3dForC.pre.a     0CDD GR
  3 A$3dForC.pre.a     0CDE GR  |   3 A$3dForC.pre.a     0CDF GR
  3 A$3dForC.pre.a     0CE0 GR  |   3 A$3dForC.pre.a     0CE3 GR
  3 A$3dForC.pre.a     0CE6 GR  |   3 A$3dForC.pre.a     0CE9 GR
  3 A$3dForC.pre.a     0CEC GR  |   3 A$3dForC.pre.a     0CEE GR
  3 A$3dForC.pre.a     0CEF GR  |   3 A$3dForC.pre.a     0CF0 GR
  3 A$3dForC.pre.a     0CF2 GR  |   3 A$3dForC.pre.a     0CF3 GR
  3 A$3dForC.pre.a     0CF5 GR  |   3 A$3dForC.pre.a     0CF6 GR
  3 A$3dForC.pre.a     0CF8 GR  |   3 A$3dForC.pre.a     0CF9 GR
  3 A$3dForC.pre.a     0CFA GR  |   3 A$3dForC.pre.a     0CFB GR
  3 A$3dForC.pre.a     0CFC GR  |   3 A$3dForC.pre.a     0CFE GR
  3 A$3dForC.pre.a     0CFF GR  |   3 A$3dForC.pre.a     0D00 GR
  3 A$3dForC.pre.a     0D01 GR  |   3 A$3dForC.pre.a     0D02 GR
  3 A$3dForC.pre.a     0D03 GR  |   3 A$3dForC.pre.a     0D06 GR
  3 A$3dForC.pre.a     0D09 GR  |   3 A$3dForC.pre.a     0D0C GR
  3 A$3dForC.pre.a     0D0E GR  |   3 A$3dForC.pre.a     0D0F GR
  3 A$3dForC.pre.a     0D10 GR  |   3 A$3dForC.pre.a     0D12 GR
  3 A$3dForC.pre.a     0D13 GR  |   3 A$3dForC.pre.a     0D15 GR
  3 A$3dForC.pre.a     0D16 GR  |   3 A$3dForC.pre.a     0D18 GR
  3 A$3dForC.pre.a     0D19 GR  |   3 A$3dForC.pre.a     0D1A GR
  3 A$3dForC.pre.a     0D1B GR  |   3 A$3dForC.pre.a     0D1C GR
  3 A$3dForC.pre.a     0D1E GR  |   3 A$3dForC.pre.a     0D1F GR
  3 A$3dForC.pre.a     0D20 GR  |   3 A$3dForC.pre.a     0D21 GR
  3 A$3dForC.pre.a     0D22 GR  |   3 A$3dForC.pre.a     0D23 GR
  3 A$3dForC.pre.a     0D26 GR  |   3 A$3dForC.pre.a     0D29 GR
  3 A$3dForC.pre.a     0D2A GR  |   3 A$3dForC.pre.a     0D2D GR
  3 A$3dForC.pre.a     0D30 GR  |   3 A$3dForC.pre.a     0D33 GR
  3 A$3dForC.pre.a     0D35 GR  |   3 A$3dForC.pre.a     0D36 GR
  3 A$3dForC.pre.a     0D37 GR  |   3 A$3dForC.pre.a     0D39 GR
  3 A$3dForC.pre.a     0D3A GR  |   3 A$3dForC.pre.a     0D3C GR
  3 A$3dForC.pre.a     0D3D GR  |   3 A$3dForC.pre.a     0D3F GR
  3 A$3dForC.pre.a     0D40 GR  |   3 A$3dForC.pre.a     0D41 GR
  3 A$3dForC.pre.a     0D42 GR  |   3 A$3dForC.pre.a     0D43 GR
  3 A$3dForC.pre.a     0D45 GR  |   3 A$3dForC.pre.a     0D46 GR
  3 A$3dForC.pre.a     0D47 GR  |   3 A$3dForC.pre.a     0D48 GR
  3 A$3dForC.pre.a     0D49 GR  |   3 A$3dForC.pre.a     0D4A GR
  3 A$3dForC.pre.a     0D4D GR  |   3 A$3dForC.pre.a     0D50 GR
  3 A$3dForC.pre.a     0D53 GR  |   3 A$3dForC.pre.a     0D55 GR
  3 A$3dForC.pre.a     0D56 GR  |   3 A$3dForC.pre.a     0D57 GR
  3 A$3dForC.pre.a     0D59 GR  |   3 A$3dForC.pre.a     0D5A GR
  3 A$3dForC.pre.a     0D5C GR  |   3 A$3dForC.pre.a     0D5D GR
  3 A$3dForC.pre.a     0D5F GR  |   3 A$3dForC.pre.a     0D60 GR
  3 A$3dForC.pre.a     0D61 GR  |   3 A$3dForC.pre.a     0D62 GR
  3 A$3dForC.pre.a     0D63 GR  |   3 A$3dForC.pre.a     0D65 GR
  3 A$3dForC.pre.a     0D66 GR  |   3 A$3dForC.pre.a     0D67 GR
  3 A$3dForC.pre.a     0D68 GR  |   3 A$3dForC.pre.a     0D69 GR
  3 A$3dForC.pre.a     0D6A GR  |   3 A$3dForC.pre.a     0D6B GR
  3 A$3dForC.pre.a     0D6E GR  |   3 A$3dForC.pre.a     0D71 GR
  3 A$3dForC.pre.a     0D72 GR  |   3 A$3dForC.pre.a     0D75 GR
  3 A$3dForC.pre.a     0D78 GR  |   3 A$3dForC.pre.a     0D7A GR
  3 A$3dForC.pre.a     0D7E GR  |   3 A$3dForC.pre.a     0D81 GR
  3 A$3dForC.pre.a     0D84 GR  |   3 A$3dForC.pre.a     0D87 GR
  3 A$3dForC.pre.a     0D88 GR  |   3 A$3dForC.pre.a     0D8B GR
  3 A$3dForC.pre.a     0D8E GR  |   3 A$3dForC.pre.a     0D91 GR
  3 A$3dForC.pre.a     0D94 GR  |   3 A$3dForC.pre.a     0D97 GR
  3 A$3dForC.pre.a     0D98 GR  |   3 A$3dForC.pre.a     0D9B GR
  3 A$3dForC.pre.a     0D9E GR  |   3 A$3dForC.pre.a     0DA1 GR
  3 A$3dForC.pre.a     0DA4 GR  |   3 A$3dForC.pre.a     0DA6 GR
  3 A$3dForC.pre.a     0DA7 GR  |   3 A$3dForC.pre.a     0DA8 GR
  3 A$3dForC.pre.a     0DAA GR  |   3 A$3dForC.pre.a     0DAB GR
  3 A$3dForC.pre.a     0DAD GR  |   3 A$3dForC.pre.a     0DAE GR
  3 A$3dForC.pre.a     0DB0 GR  |   3 A$3dForC.pre.a     0DB1 GR
  3 A$3dForC.pre.a     0DB2 GR  |   3 A$3dForC.pre.a     0DB3 GR
  3 A$3dForC.pre.a     0DB4 GR  |   3 A$3dForC.pre.a     0DB6 GR
  3 A$3dForC.pre.a     0DB7 GR  |   3 A$3dForC.pre.a     0DB8 GR
  3 A$3dForC.pre.a     0DB9 GR  |   3 A$3dForC.pre.a     0DBA GR
  3 A$3dForC.pre.a     0DBB GR  |   3 A$3dForC.pre.a     0DBE GR
  3 A$3dForC.pre.a     0DC1 GR  |   3 A$3dForC.pre.a     0DC4 GR
  3 A$3dForC.pre.a     0DC7 GR  |   3 A$3dForC.pre.a     0DC9 GR
  3 A$3dForC.pre.a     0DCA GR  |   3 A$3dForC.pre.a     0DCB GR
  3 A$3dForC.pre.a     0DCD GR  |   3 A$3dForC.pre.a     0DCE GR
  3 A$3dForC.pre.a     0DD0 GR  |   3 A$3dForC.pre.a     0DD1 GR
  3 A$3dForC.pre.a     0DD3 GR  |   3 A$3dForC.pre.a     0DD4 GR
  3 A$3dForC.pre.a     0DD5 GR  |   3 A$3dForC.pre.a     0DD6 GR
  3 A$3dForC.pre.a     0DD7 GR  |   3 A$3dForC.pre.a     0DD9 GR
  3 A$3dForC.pre.a     0DDA GR  |   3 A$3dForC.pre.a     0DDB GR
  3 A$3dForC.pre.a     0DDC GR  |   3 A$3dForC.pre.a     0DDD GR
  3 A$3dForC.pre.a     0DDE GR  |   3 A$3dForC.pre.a     0DE1 GR
  3 A$3dForC.pre.a     0DE4 GR  |   3 A$3dForC.pre.a     0DE7 GR
  3 A$3dForC.pre.a     0DE9 GR  |   3 A$3dForC.pre.a     0DEA GR
  3 A$3dForC.pre.a     0DEB GR  |   3 A$3dForC.pre.a     0DED GR
  3 A$3dForC.pre.a     0DEE GR  |   3 A$3dForC.pre.a     0DF0 GR
  3 A$3dForC.pre.a     0DF1 GR  |   3 A$3dForC.pre.a     0DF3 GR
  3 A$3dForC.pre.a     0DF4 GR  |   3 A$3dForC.pre.a     0DF5 GR
  3 A$3dForC.pre.a     0DF6 GR  |   3 A$3dForC.pre.a     0DF7 GR
  3 A$3dForC.pre.a     0DF9 GR  |   3 A$3dForC.pre.a     0DFA GR
  3 A$3dForC.pre.a     0DFB GR  |   3 A$3dForC.pre.a     0DFC GR
  3 A$3dForC.pre.a     0DFD GR  |   3 A$3dForC.pre.a     0DFE GR
  3 A$3dForC.pre.a     0E01 GR  |   3 A$3dForC.pre.a     0E04 GR
  3 A$3dForC.pre.a     0E05 GR  |   3 A$3dForC.pre.a     0E08 GR
  3 A$3dForC.pre.a     0E0B GR  |   3 A$3dForC.pre.a     0E0E GR
  3 A$3dForC.pre.a     0E10 GR  |   3 A$3dForC.pre.a     0E11 GR
  3 A$3dForC.pre.a     0E12 GR  |   3 A$3dForC.pre.a     0E14 GR
  3 A$3dForC.pre.a     0E15 GR  |   3 A$3dForC.pre.a     0E17 GR
  3 A$3dForC.pre.a     0E18 GR  |   3 A$3dForC.pre.a     0E1A GR
  3 A$3dForC.pre.a     0E1B GR  |   3 A$3dForC.pre.a     0E1C GR
  3 A$3dForC.pre.a     0E1D GR  |   3 A$3dForC.pre.a     0E1E GR
  3 A$3dForC.pre.a     0E20 GR  |   3 A$3dForC.pre.a     0E21 GR
  3 A$3dForC.pre.a     0E22 GR  |   3 A$3dForC.pre.a     0E23 GR
  3 A$3dForC.pre.a     0E24 GR  |   3 A$3dForC.pre.a     0E25 GR
  3 A$3dForC.pre.a     0E28 GR  |   3 A$3dForC.pre.a     0E2B GR
  3 A$3dForC.pre.a     0E2E GR  |   3 A$3dForC.pre.a     0E30 GR
  3 A$3dForC.pre.a     0E31 GR  |   3 A$3dForC.pre.a     0E32 GR
  3 A$3dForC.pre.a     0E34 GR  |   3 A$3dForC.pre.a     0E35 GR
  3 A$3dForC.pre.a     0E37 GR  |   3 A$3dForC.pre.a     0E38 GR
  3 A$3dForC.pre.a     0E3A GR  |   3 A$3dForC.pre.a     0E3B GR
  3 A$3dForC.pre.a     0E3C GR  |   3 A$3dForC.pre.a     0E3D GR
  3 A$3dForC.pre.a     0E3E GR  |   3 A$3dForC.pre.a     0E40 GR
  3 A$3dForC.pre.a     0E41 GR  |   3 A$3dForC.pre.a     0E42 GR
  3 A$3dForC.pre.a     0E43 GR  |   3 A$3dForC.pre.a     0E44 GR
  3 A$3dForC.pre.a     0E45 GR  |   3 A$3dForC.pre.a     0E46 GR
  3 A$3dForC.pre.a     0E49 GR  |   3 A$3dForC.pre.a     0E4C GR
  3 A$3dForC.pre.a     0E4D GR  |   3 A$3dForC.pre.a     0E50 GR
  3 A$3dForC.pre.a     0000 GR  |   3 A$3dForC.pre.a     0002 GR
  3 A$3dForC.pre.a     0004 GR  |   3 A$3dForC.pre.a     0007 GR
  3 A$3dForC.pre.a     0009 GR  |   3 A$3dForC.pre.a     000C GR
  3 A$3dForC.pre.a     000F GR  |   3 A$3dForC.pre.a     0011 GR
  3 A$3dForC.pre.a     0014 GR  |   3 A$3dForC.pre.a     0017 GR
  3 A$3dForC.pre.a     001A GR  |   3 A$3dForC.pre.a     001D GR
  3 A$3dForC.pre.a     001F GR  |   3 A$3dForC.pre.a     0021 GR
  3 A$3dForC.pre.a     0023 GR  |   3 A$3dForC.pre.a     0025 GR
  3 A$3dForC.pre.a     0027 GR  |   3 A$3dForC.pre.a     0029 GR
  3 A$3dForC.pre.a     002C GR  |   3 A$3dForC.pre.a     002E GR
  3 A$3dForC.pre.a     0030 GR  |   3 A$3dForC.pre.a     0033 GR
  3 A$3dForC.pre.a     0035 GR  |   3 A$3dForC.pre.a     0038 GR
  3 A$3dForC.pre.a     003B GR  |   3 A$3dForC.pre.a     003D GR
  3 A$3dForC.pre.a     0040 GR  |   3 A$3dForC.pre.a     0041 GR
  3 A$3dForC.pre.a     0043 GR  |   3 A$3dForC.pre.a     0045 GR
  3 A$3dForC.pre.a     0048 GR  |   3 A$3dForC.pre.a     004B GR
  3 A$3dForC.pre.a     004D GR  |   3 A$3dForC.pre.a     0050 GR
  3 A$3dForC.pre.a     0053 GR  |   3 A$3dForC.pre.a     0056 GR
  3 A$3dForC.pre.a     0059 GR  |   3 A$3dForC.pre.a     005B GR
  3 A$3dForC.pre.a     005D GR  |   3 A$3dForC.pre.a     005F GR
  3 A$3dForC.pre.a     0061 GR  |   3 A$3dForC.pre.a     0064 GR
  3 A$3dForC.pre.a     0067 GR  |   3 A$3dForC.pre.a     0069 GR
  3 A$3dForC.pre.a     006C GR  |   3 A$3dForC.pre.a     006E GR
  3 A$3dForC.pre.a     0071 GR  |   3 A$3dForC.pre.a     0074 GR
  3 A$3dForC.pre.a     0076 GR  |   3 A$3dForC.pre.a     0079 GR
  3 A$3dForC.pre.a     007A GR  |   3 A$3dForC.pre.a     007C GR
  3 A$3dForC.pre.a     007E GR  |   3 A$3dForC.pre.a     0080 GR
  3 A$3dForC.pre.a     0082 GR  |   3 A$3dForC.pre.a     0084 GR
  3 A$3dForC.pre.a     0086 GR  |   3 A$3dForC.pre.a     0088 GR
  3 A$3dForC.pre.a     008A GR  |   3 A$3dForC.pre.a     008C GR
  3 A$3dForC.pre.a     008E GR  |   3 A$3dForC.pre.a     0090 GR
  3 A$3dForC.pre.a     0092 GR  |   3 A$3dForC.pre.a     0094 GR
  3 A$3dForC.pre.a     0097 GR  |   3 A$3dForC.pre.a     0099 GR
  3 A$3dForC.pre.a     009B GR  |   3 A$3dForC.pre.a     009D GR
  3 A$3dForC.pre.a     009F GR  |   3 A$3dForC.pre.a     00A2 GR
  3 A$3dForC.pre.a     00A4 GR  |   3 A$3dForC.pre.a     00A6 GR
  3 A$3dForC.pre.a     00A8 GR  |   3 A$3dForC.pre.a     0129 GR
  3 A$3dForC.pre.a     012C GR  |   3 A$3dForC.pre.a     012F GR
  3 A$3dForC.pre.a     0132 GR  |   3 A$3dForC.pre.a     0134 GR
  3 A$3dForC.pre.a     0137 GR  |   3 A$3dForC.pre.a     0139 GR
  3 A$3dForC.pre.a     013C GR  |   3 A$3dForC.pre.a     013F GR
  3 A$3dForC.pre.a     0141 GR  |   3 A$3dForC.pre.a     0144 GR
  3 A$3dForC.pre.a     0146 GR  |   3 A$3dForC.pre.a     0149 GR
  3 A$3dForC.pre.a     014C GR  |   3 A$3dForC.pre.a     014E GR
  3 A$3dForC.pre.a     0151 GR  |   3 A$3dForC.pre.a     0153 GR
  3 A$3dForC.pre.a     0156 GR  |   3 A$3dForC.pre.a     0159 GR
  3 A$3dForC.pre.a     015B GR  |   3 A$3dForC.pre.a     015D GR
  3 A$3dForC.pre.a     015E GR  |   3 A$3dForC.pre.a     0161 GR
  3 A$3dForC.pre.a     0164 GR  |   3 A$3dForC.pre.a     0167 GR
  3 A$3dForC.pre.a     016A GR  |   3 A$3dForC.pre.a     016D GR
  3 A$3dForC.pre.a     016F GR  |   3 A$3dForC.pre.a     0173 GR
  3 A$3dForC.pre.a     0176 GR  |   3 A$3dForC.pre.a     0179 GR
  3 A$3dForC.pre.a     017B GR  |   3 A$3dForC.pre.a     017C GR
  3 A$3dForC.pre.a     017D GR  |   3 A$3dForC.pre.a     017F GR
  3 A$3dForC.pre.a     0180 GR  |   3 A$3dForC.pre.a     0182 GR
  3 A$3dForC.pre.a     0183 GR  |   3 A$3dForC.pre.a     0185 GR
  3 A$3dForC.pre.a     0186 GR  |   3 A$3dForC.pre.a     0187 GR
  3 A$3dForC.pre.a     0188 GR  |   3 A$3dForC.pre.a     0189 GR
  3 A$3dForC.pre.a     018B GR  |   3 A$3dForC.pre.a     018C GR
  3 A$3dForC.pre.a     018D GR  |   3 A$3dForC.pre.a     018E GR
  3 A$3dForC.pre.a     018F GR  |   3 A$3dForC.pre.a     0190 GR
  3 A$3dForC.pre.a     0193 GR  |   3 A$3dForC.pre.a     0196 GR
  3 A$3dForC.pre.a     0199 GR  |   3 A$3dForC.pre.a     019B GR
  3 A$3dForC.pre.a     019C GR  |   3 A$3dForC.pre.a     019D GR
  3 A$3dForC.pre.a     019F GR  |   3 A$3dForC.pre.a     01A0 GR
  3 A$3dForC.pre.a     01A2 GR  |   3 A$3dForC.pre.a     01A3 GR
  3 A$3dForC.pre.a     01A5 GR  |   3 A$3dForC.pre.a     01A6 GR
  3 A$3dForC.pre.a     01A7 GR  |   3 A$3dForC.pre.a     01A8 GR
  3 A$3dForC.pre.a     01A9 GR  |   3 A$3dForC.pre.a     01AB GR
  3 A$3dForC.pre.a     01AC GR  |   3 A$3dForC.pre.a     01AD GR
  3 A$3dForC.pre.a     01AE GR  |   3 A$3dForC.pre.a     01AF GR
  3 A$3dForC.pre.a     01B0 GR  |   3 A$3dForC.pre.a     01B3 GR
  3 A$3dForC.pre.a     01B6 GR  |   3 A$3dForC.pre.a     01B9 GR
  3 A$3dForC.pre.a     01BB GR  |   3 A$3dForC.pre.a     01BC GR
    ADD_000        =   0000     |     ADD_001        =   0015 
    ADD_010        =   000F     |     ADD_011        =   0012 
    ADD_0N1        =   001E     |     ADD_100        =   0003 
    ADD_101        =   0009     |     ADD_110        =   0006 
    ADD_111        =   000C     |     ADD_11N        =   0027 
    ADD_1N1        =   0024     |     ADD_N01        =   001B 
    ADD_N10        =   0018     |     ADD_N11        =   0021 
    Abs_a_b        =   F584     |     Abs_b          =   F58B 
    Add_Score_a    =   F85E     |     Add_Score_d    =   F87C 
    Bitmask_a      =   F57E     |     Char_Table     =   F9F4 
    Char_Table_End =   FBD4     |     Check0Ref      =   F34F 
    Clear_C8_RAM   =   F542     |     Clear_Score    =   F84F 
    Clear_Sound    =   F272     |     Clear_x_256    =   F545 
    Clear_x_b      =   F53F     |     Clear_x_b_80   =   F550 
    Clear_x_b_a    =   F552     |     Clear_x_d      =   F548 
    Cold_Start     =   F000     |     Compare_Score  =   F8C7 
    DO_Z_KOORDINAT =   0001     |     DP_to_C8       =   F1AF 
    DP_to_D0       =   F1AA     |     Dec_3_Counters =   F55A 
    Dec_6_Counters =   F55E     |     Dec_Counters   =   F563 
    Delay_0        =   F579     |     Delay_1        =   F575 
    Delay_2        =   F571     |     Delay_3        =   F56D 
    Delay_RTS      =   F57D     |     Delay_b        =   F57A 
    Do_Sound       =   F289     |     Do_Sound_x     =   F28C 
    Dot_List       =   F2D5     |     Dot_List_Reset =   F2DE 
    Dot_d          =   F2C3     |     Dot_here       =   F2C5 
    Dot_ix         =   F2C1     |     Dot_ix_b       =   F2BE 
    Draw_Grid_VL   =   FF9F     |     Draw_Line_d    =   F3DF 
    Draw_Pat_VL    =   F437     |     Draw_Pat_VL_a  =   F434 
    Draw_Pat_VL_d  =   F439     |     Draw_VL        =   F3DD 
    Draw_VL_a      =   F3DA     |     Draw_VL_ab     =   F3D8 
    Draw_VL_b      =   F3D2     |     Draw_VL_mode   =   F46E 
    Draw_VLc       =   F3CE     |     Draw_VLcs      =   F3D6 
    Draw_VLp       =   F410     |     Draw_VLp_7F    =   F408 
    Draw_VLp_FF    =   F404     |     Draw_VLp_b     =   F40E 
    Draw_VLp_scale =   F40C     |     Explosion_Snd  =   F92E 
    Get_Rise_Idx   =   F5D9     |     Get_Rise_Run   =   F5EF 
    Get_Run_Idx    =   F5DB     |     INCLUDE_I      =   0001 
    INVERS_OFFSET  =   002A     |   7 I_0_0_0        =   0038 R
  7 I_0_0_1        =   004D R   |   7 I_0_1_0        =   0047 R
  7 I_0_1_1        =   004A R   |   7 I_0_N_1        =   0056 R
  7 I_1_0_0        =   003B R   |   7 I_1_0_1        =   0041 R
  7 I_1_1_0        =   003E R   |   7 I_1_1_1        =   0044 R
  7 I_1_1_N        =   005F R   |   7 I_1_N_1        =   005C R
  7 I_N_0_1        =   0053 R   |   7 I_N_1_0        =   0050 R
  7 I_N_1_1        =   0059 R   |     Init_Music     =   F68D 
    Init_Music_Buf =   F533     |     Init_Music_chk =   F687 
    Init_Music_x   =   F692     |     Init_OS        =   F18B 
    Init_OS_RAM    =   F164     |     Init_VIA       =   F14C 
    Intensity_1F   =   F29D     |     Intensity_3F   =   F2A1 
    Intensity_5F   =   F2A5     |     Intensity_7F   =   F2A9 
    Intensity_a    =   F2AB     |     Joy_Analog     =   F1F5 
    Joy_Digital    =   F1F8     |     Mov_Draw_VL    =   F3BC 
    Mov_Draw_VL_a  =   F3B9     |     Mov_Draw_VL_ab =   F3B7 
    Mov_Draw_VL_b  =   F3B1     |     Mov_Draw_VL_d  =   F3BE 
    Mov_Draw_VLc_a =   F3AD     |     Mov_Draw_VLcs  =   F3B5 
    Move_Mem_a     =   F683     |     Move_Mem_a_1   =   F67F 
    Moveto_d       =   F312     |     Moveto_d_7F    =   F2FC 
    Moveto_ix      =   F310     |     Moveto_ix_7F   =   F30C 
    Moveto_ix_FF   =   F308     |     Moveto_ix_b    =   F30E 
    Moveto_x_7F    =   F2F2     |     New_High_Score =   F8D8 
    Obj_Hit        =   F8FF     |     Obj_Will_Hit   =   F8F3 
    Obj_Will_Hit_u =   F8E5     |     Print_List     =   F38A 
    Print_List_chk =   F38C     |     Print_List_hw  =   F385 
    Print_Ships    =   F393     |     Print_Ships_x  =   F391 
    Print_Str      =   F495     |     Print_Str_d    =   F37A 
    Print_Str_hwyx =   F373     |     Print_Str_yx   =   F378 
    Random         =   F517     |     Random_3       =   F511 
    Read_Btns      =   F1BA     |     Read_Btns_Mask =   F1B4 
    Recalibrate    =   F2E6     |     Reset0Int      =   F36B 
    Reset0Ref      =   F354     |     Reset0Ref_D0   =   F34A 
    Reset_Pen      =   F35B     |     Rise_Run_Angle =   F593 
    Rise_Run_Len   =   F603     |     Rise_Run_X     =   F5FF 
    Rise_Run_Y     =   F601     |     Rot_VL         =   F616 
    Rot_VL_M_dft   =   F62B     |     Rot_VL_Mode    =   F61F 
    Rot_VL_ab      =   F610     |     Select_Game    =   F7A9 
    Set_Refresh    =   F1A2     |     Sound_Byte     =   F256 
    Sound_Byte_raw =   F25B     |     Sound_Byte_x   =   F259 
    Sound_Bytes    =   F27D     |     Sound_Bytes_x  =   F284 
    Strip_Zeros    =   F8B7     |     TEST_0_0_0     =   0001 
    TEST_0_0_1     =   0080     |     TEST_0_1_0     =   0020 
    TEST_0_1_1     =   0040     |     TEST_0_N_1     =   0004 
    TEST_1_0_0     =   0002     |     TEST_1_0_1     =   0008 
    TEST_1_1_0     =   0004     |     TEST_1_1_1     =   0010 
    TEST_1_1_N     =   0020     |     TEST_1_N_1     =   0010 
    TEST_N_0_1     =   0002     |     TEST_N_1_0     =   0001 
    TEST_N_1_1     =   0008     |     VIA_DDR_a      =   D003 
    VIA_DDR_b      =   D002     |     VIA_aux_cntl   =   D00B 
    VIA_cntl       =   D00C     |     VIA_int_enable =   D00E 
    VIA_int_flags  =   D00D     |     VIA_port_a     =   D001 
    VIA_port_a_noh =   D00F     |     VIA_port_b     =   D000 
    VIA_shift_reg  =   D00A     |     VIA_t1_cnt_hi  =   D005 
    VIA_t1_cnt_lo  =   D004     |     VIA_t1_lch_hi  =   D007 
    VIA_t1_lch_lo  =   D006     |     VIA_t2_hi      =   D009 
    VIA_t2_lo      =   D008     |     Vec_0Ref_Enabl =   C824 
    Vec_ADSR_Table =   C84F     |     Vec_ADSR_Timer =   C85E 
    Vec_Angle      =   C836     |     Vec_Brightness =   C827 
    Vec_Btn_State  =   C80F     |     Vec_Button_1_1 =   C812 
    Vec_Button_1_2 =   C813     |     Vec_Button_1_3 =   C814 
    Vec_Button_1_4 =   C815     |     Vec_Button_2_1 =   C816 
    Vec_Button_2_2 =   C817     |     Vec_Button_2_3 =   C818 
    Vec_Button_2_4 =   C819     |     Vec_Buttons    =   C811 
    Vec_Cold_Flag  =   CBFE     |     Vec_Counter_1  =   C82E 
    Vec_Counter_2  =   C82F     |     Vec_Counter_3  =   C830 
    Vec_Counter_4  =   C831     |     Vec_Counter_5  =   C832 
    Vec_Counter_6  =   C833     |     Vec_Counters   =   C82E 
    Vec_Default_St =   CBEA     |     Vec_Dot_Dwell  =   C828 
    Vec_Duration   =   C857     |     Vec_Expl_1     =   C858 
    Vec_Expl_2     =   C859     |     Vec_Expl_3     =   C85A 
    Vec_Expl_4     =   C85B     |     Vec_Expl_Chan  =   C85C 
    Vec_Expl_ChanA =   C853     |     Vec_Expl_ChanB =   C85D 
    Vec_Expl_Chans =   C854     |     Vec_Expl_Flag  =   C867 
    Vec_Expl_Timer =   C877     |     Vec_FIRQ_Vecto =   CBF5 
    Vec_Freq_Table =   C84D     |     Vec_High_Score =   CBEB 
    Vec_IRQ_Vector =   CBF8     |     Vec_Joy_1_X    =   C81B 
    Vec_Joy_1_Y    =   C81C     |     Vec_Joy_2_X    =   C81D 
    Vec_Joy_2_Y    =   C81E     |     Vec_Joy_Mux    =   C81F 
    Vec_Joy_Mux_1_ =   C81F     |     Vec_Joy_Mux_1_ =   C820 
    Vec_Joy_Mux_2_ =   C821     |     Vec_Joy_Mux_2_ =   C822 
    Vec_Joy_Resltn =   C81A     |     Vec_Loop_Count =   C825 
    Vec_Max_Games  =   C850     |     Vec_Max_Player =   C84F 
    Vec_Misc_Count =   C823     |     Vec_Music_Chan =   C855 
    Vec_Music_Flag =   C856     |     Vec_Music_Freq =   C861 
    Vec_Music_Ptr  =   C853     |     Vec_Music_Twan =   C858 
    Vec_Music_Wk_1 =   C84B     |     Vec_Music_Wk_5 =   C847 
    Vec_Music_Wk_6 =   C846     |     Vec_Music_Wk_7 =   C845 
    Vec_Music_Wk_A =   C842     |     Vec_Music_Work =   C83F 
    Vec_NMI_Vector =   CBFB     |     Vec_Num_Game   =   C87A 
    Vec_Num_Player =   C879     |     Vec_Pattern    =   C829 
    Vec_Prev_Btns  =   C810     |     Vec_Random_See =   C87D 
    Vec_Rfrsh      =   C83D     |     Vec_Rfrsh_hi   =   C83E 
    Vec_Rfrsh_lo   =   C83D     |     Vec_RiseRun_Le =   C83B 
    Vec_RiseRun_Tm =   C834     |     Vec_Rise_Index =   C839 
    Vec_Run_Index  =   C837     |     Vec_SWI2_Vecto =   CBF2 
    Vec_SWI3_Vecto =   CBF2     |     Vec_SWI_Vector =   CBFB 
    Vec_Seed_Ptr   =   C87B     |     Vec_Snd_Shadow =   C800 
    Vec_Str_Ptr    =   C82C     |     Vec_Text_HW    =   C82A 
    Vec_Text_Heigh =   C82A     |     Vec_Text_Width =   C82B 
    Vec_Twang_Tabl =   C851     |     Wait_Recal     =   F192 
    Warm_Start     =   F06C     |     Xform_Rise     =   F663 
    Xform_Rise_a   =   F661     |     Xform_Run      =   F65D 
    Xform_Run_a    =   F65B     |   7 _000x          =   000E R
  7 _000xi         =   0038 R   |   7 _000y          =   000F R
  7 _000yi         =   0039 R   |   7 _000z          =   0010 R
  7 _000zi         =   003A R   |   7 _001x          =   0023 R
  7 _001xi         =   004D R   |   7 _001y          =   0024 R
  7 _001yi         =   004E R   |   7 _001z          =   0025 R
  7 _001zi         =   004F R   |   7 _010x          =   001D R
  7 _010xi         =   0047 R   |   7 _010y          =   001E R
  7 _010yi         =   0048 R   |   7 _010z          =   001F R
  7 _010zi         =   0049 R   |   7 _011x          =   0020 R
  7 _011xi         =   004A R   |   7 _011y          =   0021 R
  7 _011yi         =   004B R   |   7 _011z          =   0022 R
  7 _011zi         =   004C R   |   7 _0N1x          =   002C R
  7 _0N1xi         =   0056 R   |   7 _0N1y          =   002D R
  7 _0N1yi         =   0057 R   |   7 _0N1z          =   002E R
  7 _0N1zi         =   0058 R   |   7 _0_0_0         =   000E R
  7 _0_0_1         =   0023 R   |   7 _0_0_N         =   004D R
  7 _0_1_0         =   001D R   |   7 _0_1_1         =   0020 R
  7 _0_1_N         =   0056 R   |   7 _0_N_0         =   0047 R
  7 _0_N_1         =   002C R   |   7 _0_N_N         =   004A R
  7 _100x          =   0011 R   |   7 _100xi         =   003B R
  7 _100y          =   0012 R   |   7 _100yi         =   003C R
  7 _100z          =   0013 R   |   7 _100zi         =   003D R
  7 _101x          =   0017 R   |   7 _101xi         =   0041 R
  7 _101y          =   0018 R   |   7 _101yi         =   0042 R
  7 _101z          =   0019 R   |   7 _101zi         =   0043 R
  7 _110x          =   0014 R   |   7 _110xi         =   003E R
  7 _110y          =   0015 R   |   7 _110yi         =   003F R
  7 _110z          =   0016 R   |   7 _110zi         =   0040 R
  7 _111x          =   001A R   |   7 _111xi         =   0044 R
  7 _111y          =   001B R   |   7 _111yi         =   0045 R
  7 _111z          =   001C R   |   7 _111zi         =   0046 R
  7 _11Nx          =   0035 R   |   7 _11Nxi         =   005F R
  7 _11Ny          =   0036 R   |   7 _11Nyi         =   0060 R
  7 _11Nz          =   0037 R   |   7 _11Nzi         =   0061 R
  7 _1N1x          =   0032 R   |   7 _1N1xi         =   005C R
  7 _1N1y          =   0033 R   |   7 _1N1yi         =   005D R
  7 _1N1z          =   0034 R   |   7 _1N1zi         =   005E R
  7 _1_0_0         =   0011 R   |   7 _1_0_1         =   0017 R
  7 _1_0_N         =   0053 R   |   7 _1_1_0         =   0014 R
  7 _1_1_1         =   001A R   |   7 _1_1_N         =   0035 R
  7 _1_N_0         =   0050 R   |   7 _1_N_1         =   0032 R
  7 _1_N_N         =   0059 R   |   7 _N01x          =   0029 R
  7 _N01xi         =   0053 R   |   7 _N01y          =   002A R
  7 _N01yi         =   0054 R   |   7 _N01z          =   002B R
  7 _N01zi         =   0055 R   |   7 _N10x          =   0026 R
  7 _N10xi         =   0050 R   |   7 _N10y          =   0027 R
  7 _N10yi         =   0051 R   |   7 _N10z          =   0028 R
  7 _N10zi         =   0052 R   |   7 _N11x          =   002F R
  7 _N11xi         =   0059 R   |   7 _N11y          =   0030 R
  7 _N11yi         =   005A R   |   7 _N11z          =   0031 R
  7 _N11zi         =   005B R   |   7 _N_0_0         =   003B R
  7 _N_0_1         =   0029 R   |   7 _N_0_N         =   0041 R
  7 _N_1_0         =   0026 R   |   7 _N_1_1         =   002F R
  7 _N_1_N         =   005C R   |   7 _N_N_0         =   003E R
  7 _N_N_1         =   005F R   |   7 _N_N_N         =   0044 R
  7 _allDirs_calc      000E GR  |   7 _angle_x           0007 GR
  7 _angle_y           0008 GR  |   7 _angle_z           0009 GR
  3 _cosinus3d         00A9 GR  |   7 _cosx              0001 GR
  7 _cosy              0003 GR  |   7 _cosz              0005 GR
  7 _helper            0000 GR  |   7 _scale_3d          000C GR
  7 _scale_3d_move     000D GR  |   3 _sinus3d           00E9 GR
  7 _sinx              0002 GR  |   7 _siny              0004 GR
  7 _sinz              0006 GR  |   7 _start_letter_     005F GR
  7 _vectorBits        000A GR  |   3 asm_draw_3d        0041 GR
  3 asm_draw_3d_dp     007A GR  |   3 asm_draw_3ds       0000 GR
  3 end                0071 GR  |   3 end1               006E GR
  3 end1_dp            009F GR  |   3 end1s              0035 GR
  3 end_dp             00A2 GR  |   3 ends               0038 GR
  3 init_2d            0129 GR  |   3 init_all           03F6 GR
  3 mul_An_Bn101       0614 GR  |   3 mul_An_Bn108       0664 GR
  3 mul_An_Bn110       0687 GR  |   3 mul_An_Bn112       06A7 GR
  3 mul_An_Bn116       06CE GR  |   3 mul_An_Bn118       06EE GR
  3 mul_An_Bn125       0729 GR  |   3 mul_An_Bn127       0749 GR
  3 mul_An_Bn129       0769 GR  |   3 mul_An_Bn134       0791 GR
  3 mul_An_Bn136       07B1 GR  |   3 mul_An_Bn14        01F3 GR
  3 mul_An_Bn142       0800 GR  |   3 mul_An_Bn144       0820 GR
  3 mul_An_Bn146       0840 GR  |   3 mul_An_Bn150       0867 GR
  3 mul_An_Bn152       0887 GR  |   3 mul_An_Bn159       08C2 GR
  3 mul_An_Bn16        0213 GR  |   3 mul_An_Bn161       08E2 GR
  3 mul_An_Bn163       0902 GR  |   3 mul_An_Bn167       0929 GR
  3 mul_An_Bn169       0949 GR  |   3 mul_An_Bn176       098B GR
  3 mul_An_Bn178       09AE GR  |   3 mul_An_Bn180       09CE GR
  3 mul_An_Bn184       09F5 GR  |   3 mul_An_Bn186       0A15 GR
  3 mul_An_Bn193       0A50 GR  |   3 mul_An_Bn195       0A73 GR
  3 mul_An_Bn197       0A93 GR  |   3 mul_An_Bn201       0ABA GR
  3 mul_An_Bn203       0ADA GR  |   3 mul_An_Bn210       0B2A GR
  3 mul_An_Bn212       0B4A GR  |   3 mul_An_Bn214       0B6A GR
  3 mul_An_Bn218       0B91 GR  |   3 mul_An_Bn22        0241 GR
  3 mul_An_Bn220       0BB1 GR  |   3 mul_An_Bn227       0C01 GR
  3 mul_An_Bn229       0C24 GR  |   3 mul_An_Bn231       0C44 GR
  3 mul_An_Bn235       0C6B GR  |   3 mul_An_Bn237       0C8B GR
  3 mul_An_Bn244       0CDB GR  |   3 mul_An_Bn246       0CFE GR
  3 mul_An_Bn248       0D1E GR  |   3 mul_An_Bn25        0265 GR
  3 mul_An_Bn252       0D45 GR  |   3 mul_An_Bn254       0D65 GR
  3 mul_An_Bn261       0DB6 GR  |   3 mul_An_Bn263       0DD9 GR
  3 mul_An_Bn265       0DF9 GR  |   3 mul_An_Bn269       0E20 GR
  3 mul_An_Bn271       0E40 GR  |   3 mul_An_Bn30        0299 GR
  3 mul_An_Bn32        02BC GR  |   3 mul_An_Bn34        02DC GR
  3 mul_An_Bn38        0303 GR  |   3 mul_An_Bn40        0323 GR
  3 mul_An_Bn47        035B GR  |   3 mul_An_Bn49        037E GR
  3 mul_An_Bn5         018B GR  |   3 mul_An_Bn51        039E GR
  3 mul_An_Bn55        03C5 GR  |   3 mul_An_Bn57        03E5 GR
  3 mul_An_Bn66        0463 GR  |   3 mul_An_Bn69        0487 GR
  3 mul_An_Bn7         01AB GR  |   3 mul_An_Bn74        04C5 GR
  3 mul_An_Bn76        04E8 GR  |   3 mul_An_Bn78        0508 GR
  3 mul_An_Bn82        052F GR  |   3 mul_An_Bn84        054F GR
  3 mul_An_Bn9         01CB GR  |   3 mul_An_Bn91        058A GR
  3 mul_An_Bn93        05AD GR  |   3 mul_An_Bn95        05CD GR
  3 mul_An_Bn99        05F4 GR  |   3 mul_An_Bp101       060F GR
  3 mul_An_Bp108       065F GR  |   3 mul_An_Bp110       0682 GR
  3 mul_An_Bp112       06A2 GR  |   3 mul_An_Bp116       06C9 GR
  3 mul_An_Bp118       06E9 GR  |   3 mul_An_Bp125       0724 GR
  3 mul_An_Bp127       0744 GR  |   3 mul_An_Bp129       0764 GR
  3 mul_An_Bp134       078C GR  |   3 mul_An_Bp136       07AC GR
  3 mul_An_Bp14        01EE GR  |   3 mul_An_Bp142       07FB GR
  3 mul_An_Bp144       081B GR  |   3 mul_An_Bp146       083B GR
  3 mul_An_Bp150       0862 GR  |   3 mul_An_Bp152       0882 GR
  3 mul_An_Bp159       08BD GR  |   3 mul_An_Bp16        020E GR
  3 mul_An_Bp161       08DD GR  |   3 mul_An_Bp163       08FD GR
  3 mul_An_Bp167       0924 GR  |   3 mul_An_Bp169       0944 GR
  3 mul_An_Bp176       0986 GR  |   3 mul_An_Bp178       09A9 GR
  3 mul_An_Bp180       09C9 GR  |   3 mul_An_Bp184       09F0 GR
  3 mul_An_Bp186       0A10 GR  |   3 mul_An_Bp193       0A4B GR
  3 mul_An_Bp195       0A6E GR  |   3 mul_An_Bp197       0A8E GR
  3 mul_An_Bp201       0AB5 GR  |   3 mul_An_Bp203       0AD5 GR
  3 mul_An_Bp210       0B25 GR  |   3 mul_An_Bp212       0B45 GR
  3 mul_An_Bp214       0B65 GR  |   3 mul_An_Bp218       0B8C GR
  3 mul_An_Bp22        023C GR  |   3 mul_An_Bp220       0BAC GR
  3 mul_An_Bp227       0BFC GR  |   3 mul_An_Bp229       0C1F GR
  3 mul_An_Bp231       0C3F GR  |   3 mul_An_Bp235       0C66 GR
  3 mul_An_Bp237       0C86 GR  |   3 mul_An_Bp244       0CD6 GR
  3 mul_An_Bp246       0CF9 GR  |   3 mul_An_Bp248       0D19 GR
  3 mul_An_Bp25        0260 GR  |   3 mul_An_Bp252       0D40 GR
  3 mul_An_Bp254       0D60 GR  |   3 mul_An_Bp261       0DB1 GR
  3 mul_An_Bp263       0DD4 GR  |   3 mul_An_Bp265       0DF4 GR
  3 mul_An_Bp269       0E1B GR  |   3 mul_An_Bp271       0E3B GR
  3 mul_An_Bp30        0294 GR  |   3 mul_An_Bp32        02B7 GR
  3 mul_An_Bp34        02D7 GR  |   3 mul_An_Bp38        02FE GR
  3 mul_An_Bp40        031E GR  |   3 mul_An_Bp47        0356 GR
  3 mul_An_Bp49        0379 GR  |   3 mul_An_Bp5         0186 GR
  3 mul_An_Bp51        0399 GR  |   3 mul_An_Bp55        03C0 GR
  3 mul_An_Bp57        03E0 GR  |   3 mul_An_Bp66        045E GR
  3 mul_An_Bp69        0482 GR  |   3 mul_An_Bp7         01A6 GR
  3 mul_An_Bp74        04C0 GR  |   3 mul_An_Bp76        04E3 GR
  3 mul_An_Bp78        0503 GR  |   3 mul_An_Bp82        052A GR
  3 mul_An_Bp84        054A GR  |   3 mul_An_Bp9         01C6 GR
  3 mul_An_Bp91        0585 GR  |   3 mul_An_Bp93        05A8 GR
  3 mul_An_Bp95        05C8 GR  |   3 mul_An_Bp99        05EF GR
  3 mul_Ap101          060B GR  |   3 mul_Ap108          065B GR
  3 mul_Ap110          067E GR  |   3 mul_Ap112          069E GR
  3 mul_Ap116          06C5 GR  |   3 mul_Ap118          06E5 GR
  3 mul_Ap125          0720 GR  |   3 mul_Ap127          0740 GR
  3 mul_Ap129          0760 GR  |   3 mul_Ap134          0788 GR
  3 mul_Ap136          07A8 GR  |   3 mul_Ap14           01EA GR
  3 mul_Ap142          07F7 GR  |   3 mul_Ap144          0817 GR
  3 mul_Ap146          0837 GR  |   3 mul_Ap150          085E GR
  3 mul_Ap152          087E GR  |   3 mul_Ap159          08B9 GR
  3 mul_Ap16           020A GR  |   3 mul_Ap161          08D9 GR
  3 mul_Ap163          08F9 GR  |   3 mul_Ap167          0920 GR
  3 mul_Ap169          0940 GR  |   3 mul_Ap176          0982 GR
  3 mul_Ap178          09A5 GR  |   3 mul_Ap180          09C5 GR
  3 mul_Ap184          09EC GR  |   3 mul_Ap186          0A0C GR
  3 mul_Ap193          0A47 GR  |   3 mul_Ap195          0A6A GR
  3 mul_Ap197          0A8A GR  |   3 mul_Ap201          0AB1 GR
  3 mul_Ap203          0AD1 GR  |   3 mul_Ap210          0B21 GR
  3 mul_Ap212          0B41 GR  |   3 mul_Ap214          0B61 GR
  3 mul_Ap218          0B88 GR  |   3 mul_Ap22           0238 GR
  3 mul_Ap220          0BA8 GR  |   3 mul_Ap227          0BF8 GR
  3 mul_Ap229          0C1B GR  |   3 mul_Ap231          0C3B GR
  3 mul_Ap235          0C62 GR  |   3 mul_Ap237          0C82 GR
  3 mul_Ap244          0CD2 GR  |   3 mul_Ap246          0CF5 GR
  3 mul_Ap248          0D15 GR  |   3 mul_Ap25           025C GR
  3 mul_Ap252          0D3C GR  |   3 mul_Ap254          0D5C GR
  3 mul_Ap261          0DAD GR  |   3 mul_Ap263          0DD0 GR
  3 mul_Ap265          0DF0 GR  |   3 mul_Ap269          0E17 GR
  3 mul_Ap271          0E37 GR  |   3 mul_Ap30           0290 GR
  3 mul_Ap32           02B3 GR  |   3 mul_Ap34           02D3 GR
  3 mul_Ap38           02FA GR  |   3 mul_Ap40           031A GR
  3 mul_Ap47           0352 GR  |   3 mul_Ap49           0375 GR
  3 mul_Ap5            0182 GR  |   3 mul_Ap51           0395 GR
  3 mul_Ap55           03BC GR  |   3 mul_Ap57           03DC GR
  3 mul_Ap66           045A GR  |   3 mul_Ap69           047E GR
  3 mul_Ap7            01A2 GR  |   3 mul_Ap74           04BC GR
  3 mul_Ap76           04DF GR  |   3 mul_Ap78           04FF GR
  3 mul_Ap82           0526 GR  |   3 mul_Ap84           0546 GR
  3 mul_Ap9            01C2 GR  |   3 mul_Ap91           0581 GR
  3 mul_Ap93           05A4 GR  |   3 mul_Ap95           05C4 GR
  3 mul_Ap99           05EB GR  |   3 mul_Ap_Bp101       0614 GR
  3 mul_Ap_Bp108       0664 GR  |   3 mul_Ap_Bp110       0687 GR
  3 mul_Ap_Bp112       06A7 GR  |   3 mul_Ap_Bp116       06CE GR
  3 mul_Ap_Bp118       06EE GR  |   3 mul_Ap_Bp125       0729 GR
  3 mul_Ap_Bp127       0749 GR  |   3 mul_Ap_Bp129       0769 GR
  3 mul_Ap_Bp134       0791 GR  |   3 mul_Ap_Bp136       07B1 GR
  3 mul_Ap_Bp14        01F3 GR  |   3 mul_Ap_Bp142       0800 GR
  3 mul_Ap_Bp144       0820 GR  |   3 mul_Ap_Bp146       0840 GR
  3 mul_Ap_Bp150       0867 GR  |   3 mul_Ap_Bp152       0887 GR
  3 mul_Ap_Bp159       08C2 GR  |   3 mul_Ap_Bp16        0213 GR
  3 mul_Ap_Bp161       08E2 GR  |   3 mul_Ap_Bp163       0902 GR
  3 mul_Ap_Bp167       0929 GR  |   3 mul_Ap_Bp169       0949 GR
  3 mul_Ap_Bp176       098B GR  |   3 mul_Ap_Bp178       09AE GR
  3 mul_Ap_Bp180       09CE GR  |   3 mul_Ap_Bp184       09F5 GR
  3 mul_Ap_Bp186       0A15 GR  |   3 mul_Ap_Bp193       0A50 GR
  3 mul_Ap_Bp195       0A73 GR  |   3 mul_Ap_Bp197       0A93 GR
  3 mul_Ap_Bp201       0ABA GR  |   3 mul_Ap_Bp203       0ADA GR
  3 mul_Ap_Bp210       0B2A GR  |   3 mul_Ap_Bp212       0B4A GR
  3 mul_Ap_Bp214       0B6A GR  |   3 mul_Ap_Bp218       0B91 GR
  3 mul_Ap_Bp22        0241 GR  |   3 mul_Ap_Bp220       0BB1 GR
  3 mul_Ap_Bp227       0C01 GR  |   3 mul_Ap_Bp229       0C24 GR
  3 mul_Ap_Bp231       0C44 GR  |   3 mul_Ap_Bp235       0C6B GR
  3 mul_Ap_Bp237       0C8B GR  |   3 mul_Ap_Bp244       0CDB GR
  3 mul_Ap_Bp246       0CFE GR  |   3 mul_Ap_Bp248       0D1E GR
  3 mul_Ap_Bp25        0265 GR  |   3 mul_Ap_Bp252       0D45 GR
  3 mul_Ap_Bp254       0D65 GR  |   3 mul_Ap_Bp261       0DB6 GR
  3 mul_Ap_Bp263       0DD9 GR  |   3 mul_Ap_Bp265       0DF9 GR
  3 mul_Ap_Bp269       0E20 GR  |   3 mul_Ap_Bp271       0E40 GR
  3 mul_Ap_Bp30        0299 GR  |   3 mul_Ap_Bp32        02BC GR
  3 mul_Ap_Bp34        02DC GR  |   3 mul_Ap_Bp38        0303 GR
  3 mul_Ap_Bp40        0323 GR  |   3 mul_Ap_Bp47        035B GR
  3 mul_Ap_Bp49        037E GR  |   3 mul_Ap_Bp5         018B GR
  3 mul_Ap_Bp51        039E GR  |   3 mul_Ap_Bp55        03C5 GR
  3 mul_Ap_Bp57        03E5 GR  |   3 mul_Ap_Bp66        0463 GR
  3 mul_Ap_Bp69        0487 GR  |   3 mul_Ap_Bp7         01AB GR
  3 mul_Ap_Bp74        04C5 GR  |   3 mul_Ap_Bp76        04E8 GR
  3 mul_Ap_Bp78        0508 GR  |   3 mul_Ap_Bp82        052F GR
  3 mul_Ap_Bp84        054F GR  |   3 mul_Ap_Bp9         01CB GR
  3 mul_Ap_Bp91        058A GR  |   3 mul_Ap_Bp93        05AD GR
  3 mul_Ap_Bp95        05CD GR  |   3 mul_Ap_Bp99        05F4 GR
  3 mul_end101         0615 GR  |   3 mul_end108         0665 GR
  3 mul_end110         0688 GR  |   3 mul_end112         06A8 GR
  3 mul_end116         06CF GR  |   3 mul_end118         06EF GR
  3 mul_end125         072A GR  |   3 mul_end127         074A GR
  3 mul_end129         076A GR  |   3 mul_end134         0792 GR
  3 mul_end136         07B2 GR  |   3 mul_end14          01F4 GR
  3 mul_end142         0801 GR  |   3 mul_end144         0821 GR
  3 mul_end146         0841 GR  |   3 mul_end150         0868 GR
  3 mul_end152         0888 GR  |   3 mul_end159         08C3 GR
  3 mul_end16          0214 GR  |   3 mul_end161         08E3 GR
  3 mul_end163         0903 GR  |   3 mul_end167         092A GR
  3 mul_end169         094A GR  |   3 mul_end176         098C GR
  3 mul_end178         09AF GR  |   3 mul_end180         09CF GR
  3 mul_end184         09F6 GR  |   3 mul_end186         0A16 GR
  3 mul_end193         0A51 GR  |   3 mul_end195         0A74 GR
  3 mul_end197         0A94 GR  |   3 mul_end201         0ABB GR
  3 mul_end203         0ADB GR  |   3 mul_end210         0B2B GR
  3 mul_end212         0B4B GR  |   3 mul_end214         0B6B GR
  3 mul_end218         0B92 GR  |   3 mul_end22          0242 GR
  3 mul_end220         0BB2 GR  |   3 mul_end227         0C02 GR
  3 mul_end229         0C25 GR  |   3 mul_end231         0C45 GR
  3 mul_end235         0C6C GR  |   3 mul_end237         0C8C GR
  3 mul_end244         0CDC GR  |   3 mul_end246         0CFF GR
  3 mul_end248         0D1F GR  |   3 mul_end25          0266 GR
  3 mul_end252         0D46 GR  |   3 mul_end254         0D66 GR
  3 mul_end261         0DB7 GR  |   3 mul_end263         0DDA GR
  3 mul_end265         0DFA GR  |   3 mul_end269         0E21 GR
  3 mul_end271         0E41 GR  |   3 mul_end30          029A GR
  3 mul_end32          02BD GR  |   3 mul_end34          02DD GR
  3 mul_end38          0304 GR  |   3 mul_end40          0324 GR
  3 mul_end47          035C GR  |   3 mul_end49          037F GR
  3 mul_end5           018C GR  |   3 mul_end51          039F GR
  3 mul_end55          03C6 GR  |   3 mul_end57          03E6 GR
  3 mul_end66          0464 GR  |   3 mul_end69          0488 GR
  3 mul_end7           01AC GR  |   3 mul_end74          04C6 GR
  3 mul_end76          04E9 GR  |   3 mul_end78          0509 GR
  3 mul_end82          0530 GR  |   3 mul_end84          0550 GR
  3 mul_end9           01CC GR  |   3 mul_end91          058B GR
  3 mul_end93          05AE GR  |   3 mul_end95          05CE GR
  3 mul_end99          05F5 GR  |     music1         =   FD0D 
    music2         =   FD1D     |     music3         =   FD81 
    music4         =   FDD3     |     music5         =   FE38 
    music6         =   FE76     |     music7         =   FEC6 
    music8         =   FEF8     |     music9         =   FF26 
    musica         =   FF44     |     musicb         =   FF62 
    musicc         =   FF7A     |     musicd         =   FF8F 
  3 no000              0440 GR  |   3 no0002d            016D GR
  3 no001              0959 GR  |   3 no010              07C3 GR
  3 no0102d            0225 GR  |   3 no011              089A GR
  3 no0N1              0BC4 GR  |   3 no100              0496 GR
  3 no1002d            0274 GR  |   3 no101              0627 GR
  3 no110              0562 GR  |   3 no1102d            0333 GR
  3 no111              0701 GR  |   3 no11N              0E50 GR
  3 no1N1              0D78 GR  |   3 noN01              0AED GR
  3 noN10              0A28 GR  |   3 noN102d            03F5 GR
  3 noN11              0C9E GR  |   3 start              0043 GR
  3 start_dp           007C GR  |   3 starts             0004 GR
  3 wait               0064 GR  |   3 wait_dp            0097 GR
  3 waits              0029 GR

ASxxxx Assembler V05.00  (Motorola 6809), page 2.
Hexidecimal [16-Bits]

Area Table

[_CSEG]
   0 _CODE            size    0   flags C080
[_DSEG]
   1 _DATA            size    0   flags C0C0
[rom]
   2 .cartridge       size    0   flags 8080
   3 .text            size  E51   flags 8180
   4 .text.hot        size    0   flags 8080
   5 .text.unlikely   size    0   flags 8080
[ram]
   6 .data            size    0   flags 8080
   7 .bss             size   5F   flags 8080

