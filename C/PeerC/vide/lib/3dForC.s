 .module _3dforc.pre.s


 .area .text

                    .area .bss      
; Warning - org line found, my be countering relocatable code!
;                    ORG      0xc880                ; start of our ram space 

; include line ->                     INCLUDE  "VECTREX.I"          ; vectrex function includes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this file contains includes for vectrex BIOS functions and variables      ;
; it was written by Bruce Tomlin, slighte changed by Malban                 ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE_I = 1

Vec_Snd_Shadow  =     0xC800   ;Shadow of sound chip registers (15 bytes)
Vec_Btn_State   =     0xC80F   ;Current state of all joystick buttons
Vec_Prev_Btns   =     0xC810   ;Previous state of all joystick buttons
Vec_Buttons     =     0xC811   ;Current toggle state of all buttons
Vec_Button_1_1  =     0xC812   ;Current toggle state of stick 1 button 1
Vec_Button_1_2  =     0xC813   ;Current toggle state of stick 1 button 2
Vec_Button_1_3  =     0xC814   ;Current toggle state of stick 1 button 3
Vec_Button_1_4  =     0xC815   ;Current toggle state of stick 1 button 4
Vec_Button_2_1  =     0xC816   ;Current toggle state of stick 2 button 1
Vec_Button_2_2  =     0xC817   ;Current toggle state of stick 2 button 2
Vec_Button_2_3  =     0xC818   ;Current toggle state of stick 2 button 3
Vec_Button_2_4  =     0xC819   ;Current toggle state of stick 2 button 4
Vec_Joy_Resltn  =     0xC81A   ;Joystick A/D resolution (0x80=min 0x00=max)
Vec_Joy_1_X     =     0xC81B   ;Joystick 1 left/right
Vec_Joy_1_Y     =     0xC81C   ;Joystick 1 up/down
Vec_Joy_2_X     =     0xC81D   ;Joystick 2 left/right
Vec_Joy_2_Y     =     0xC81E   ;Joystick 2 up/down
Vec_Joy_Mux     =     0xC81F   ;Joystick enable/mux flags (4 bytes)
Vec_Joy_Mux_1_X =     0xC81F   ;Joystick 1 X enable/mux flag (=1)
Vec_Joy_Mux_1_Y =     0xC820   ;Joystick 1 Y enable/mux flag (=3)
Vec_Joy_Mux_2_X =     0xC821   ;Joystick 2 X enable/mux flag (=5)
Vec_Joy_Mux_2_Y =     0xC822   ;Joystick 2 Y enable/mux flag (=7)
Vec_Misc_Count  =     0xC823   ;Misc counter/flag byte, zero when not in use
Vec_0Ref_Enable =     0xC824   ;Check0Ref enable flag
Vec_Loop_Count  =     0xC825   ;Loop counter word (incremented in Wait_Recal)
Vec_Brightness  =     0xC827   ;Default brightness
Vec_Dot_Dwell   =     0xC828   ;Dot dwell time?
Vec_Pattern     =     0xC829   ;Dot pattern (bits)
Vec_Text_HW     =     0xC82A   ;Default text height and width
Vec_Text_Height =     0xC82A   ;Default text height
Vec_Text_Width  =     0xC82B   ;Default text width
Vec_Str_Ptr     =     0xC82C   ;Temporary string pointer for Print_Str
Vec_Counters    =     0xC82E   ;Six bytes of counters
Vec_Counter_1   =     0xC82E   ;First  counter byte
Vec_Counter_2   =     0xC82F   ;Second counter byte
Vec_Counter_3   =     0xC830   ;Third  counter byte
Vec_Counter_4   =     0xC831   ;Fourth counter byte
Vec_Counter_5   =     0xC832   ;Fifth  counter byte
Vec_Counter_6   =     0xC833   ;Sixth  counter byte
Vec_RiseRun_Tmp =     0xC834   ;Temp storage word for rise/run
Vec_Angle       =     0xC836   ;Angle for rise/run and rotation calculations
Vec_Run_Index   =     0xC837   ;Index pair for run
;                       0xC839   ;Pointer to copyright string during startup
Vec_Rise_Index  =     0xC839   ;Index pair for rise
;                       0xC83B   ;High score cold-start flag (=0 if valid)
Vec_RiseRun_Len =     0xC83B   ;length for rise/run
;                       0xC83C   ;temp byte
Vec_Rfrsh       =     0xC83D   ;Refresh time (divided by 1.5MHz)
Vec_Rfrsh_lo    =     0xC83D   ;Refresh time low byte
Vec_Rfrsh_hi    =     0xC83E   ;Refresh time high byte
Vec_Music_Work  =     0xC83F   ;Music work buffer (14 bytes, backwards?)
Vec_Music_Wk_A  =     0xC842   ;        register 10
;                       0xC843   ;        register 9
;                       0xC844   ;        register 8
Vec_Music_Wk_7  =     0xC845   ;        register 7
Vec_Music_Wk_6  =     0xC846   ;        register 6
Vec_Music_Wk_5  =     0xC847   ;        register 5
;                       0xC848   ;        register 4
;                       0xC849   ;        register 3
;                       0xC84A   ;        register 2
Vec_Music_Wk_1  =     0xC84B   ;        register 1
;                       0xC84C   ;        register 0
Vec_Freq_Table  =     0xC84D   ;Pointer to note-to-frequency table (normally 0xFC8D)
Vec_Max_Players =     0xC84F   ;Maximum number of players for Select_Game
Vec_Max_Games   =     0xC850   ;Maximum number of games for Select_Game
Vec_ADSR_Table  =     0xC84F   ;Storage for first music header word (ADSR table)
Vec_Twang_Table =     0xC851   ;Storage for second music header word ('twang' table)
Vec_Music_Ptr   =     0xC853   ;Music data pointer
Vec_Expl_ChanA  =     0xC853   ;Used by Explosion_Snd - bit for first channel used?
Vec_Expl_Chans  =     0xC854   ;Used by Explosion_Snd - bits for all channels used?
Vec_Music_Chan  =     0xC855   ;Current sound channel number for Init_Music
Vec_Music_Flag  =     0xC856   ;Music active flag (0x00=off 0x01=start 0x80=on)
Vec_Duration    =     0xC857   ;Duration counter for Init_Music
Vec_Music_Twang =     0xC858   ;3 word 'twang' table used by Init_Music
Vec_Expl_1      =     0xC858   ;Four bytes copied from Explosion_Snd's U-reg parameters
Vec_Expl_2      =     0xC859   ;
Vec_Expl_3      =     0xC85A   ;
Vec_Expl_4      =     0xC85B   ;
Vec_Expl_Chan   =     0xC85C   ;Used by Explosion_Snd - channel number in use?
Vec_Expl_ChanB  =     0xC85D   ;Used by Explosion_Snd - bit for second channel used?
Vec_ADSR_Timers =     0xC85E   ;ADSR timers for each sound channel (3 bytes)
Vec_Music_Freq  =     0xC861   ;Storage for base frequency of each channel (3 words)
;                       0xC85E   ;Scratch 'score' storage for Display_Option (7 bytes)
Vec_Expl_Flag   =     0xC867   ;Explosion_Snd initialization flag?
;               0xC868...0xC876   ;Unused?
Vec_Expl_Timer  =     0xC877   ;Used by Explosion_Snd
;                       0xC878   ;Unused?
Vec_Num_Players =     0xC879   ;Number of players selected in Select_Game
Vec_Num_Game    =     0xC87A   ;Game number selected in Select_Game
Vec_Seed_Ptr    =     0xC87B   ;Pointer to 3-byte random number seed (=0xC87D)
Vec_Random_Seed =     0xC87D   ;Default 3-byte random number seed
                                ;
;    0xC880 - 0xCBEA is user RAM  ;
                                ;
Vec_Default_Stk =     0xCBEA   ;Default top-of-stack
Vec_High_Score  =     0xCBEB   ;High score storage (7 bytes)
Vec_SWI3_Vector =     0xCBF2   ;SWI2/SWI3 interrupt vector (3 bytes)
Vec_SWI2_Vector =     0xCBF2   ;SWI2/SWI3 interrupt vector (3 bytes)
Vec_FIRQ_Vector =     0xCBF5   ;FIRQ interrupt vector (3 bytes)
Vec_IRQ_Vector  =     0xCBF8   ;IRQ interrupt vector (3 bytes)
Vec_SWI_Vector  =     0xCBFB   ;SWI/NMI interrupt vector (3 bytes)
Vec_NMI_Vector  =     0xCBFB   ;SWI/NMI interrupt vector (3 bytes)
Vec_Cold_Flag   =     0xCBFE   ;Cold start flag (warm start if = 0x7321)
                                ;
VIA_port_b      =     0xD000   ;VIA port B data I/O register
;       0 sample/hold (0=enable  mux 1=disable mux)
;       1 mux sel 0
;       2 mux sel 1
;       3 sound BC1
;       4 sound BDIR
;       5 comparator input
;       6 external device (slot pin 35) initialized to input
;       7 /RAMP
VIA_port_a      =     0xD001   ;VIA port A data I/O register (handshaking)
VIA_DDR_b       =     0xD002   ;VIA port B data direction register (0=input 1=output)
VIA_DDR_a       =     0xD003   ;VIA port A data direction register (0=input 1=output)
VIA_t1_cnt_lo   =     0xD004   ;VIA timer 1 count register lo (scale factor)
VIA_t1_cnt_hi   =     0xD005   ;VIA timer 1 count register hi
VIA_t1_lch_lo   =     0xD006   ;VIA timer 1 latch register lo
VIA_t1_lch_hi   =     0xD007   ;VIA timer 1 latch register hi
VIA_t2_lo       =     0xD008   ;VIA timer 2 count/latch register lo (refresh)
VIA_t2_hi       =     0xD009   ;VIA timer 2 count/latch register hi
VIA_shift_reg   =     0xD00A   ;VIA shift register
VIA_aux_cntl    =     0xD00B   ;VIA auxiliary control register
;       0 PA latch enable
;       1 PB latch enable
;       2 \                     110=output to CB2 under control of phase 2 clock
;       3  > shift register control     (110 is the only mode used by the Vectrex ROM)
;       4 /
;       5 0=t2 one shot                 1=t2 free running
;       6 0=t1 one shot                 1=t1 free running
;       7 0=t1 disable PB7 output       1=t1 enable PB7 output
VIA_cntl        =     0xD00C   ;VIA control register
;       0 CA1 control     CA1 -> SW7    0=IRQ on low 1=IRQ on high
;       1 \
;       2  > CA2 control  CA2 -> /ZERO  110=low 111=high
;       3 /
;       4 CB1 control     CB1 -> NC     0=IRQ on low 1=IRQ on high
;       5 \
;       6  > CB2 control  CB2 -> /BLANK 110=low 111=high
;       7 /
VIA_int_flags   =     0xD00D   ;VIA interrupt flags register
;               bit                             cleared by
;       0 CA2 interrupt flag            reading or writing port A I/O
;       1 CA1 interrupt flag            reading or writing port A I/O
;       2 shift register interrupt flag reading or writing shift register
;       3 CB2 interrupt flag            reading or writing port B I/O
;       4 CB1 interrupt flag            reading or writing port A I/O
;       5 timer 2 interrupt flag        read t2 low or write t2 high
;       6 timer 1 interrupt flag        read t1 count low or write t1 high
;       7 IRQ status flag               write logic 0 to IER or IFR bit
VIA_int_enable  =     0xD00E   ;VIA interrupt enable register
;       0 CA2 interrupt enable
;       1 CA1 interrupt enable
;       2 shift register interrupt enable
;       3 CB2 interrupt enable
;       4 CB1 interrupt enable
;       5 timer 2 interrupt enable
;       6 timer 1 interrupt enable
;       7 IER set/clear control
VIA_port_a_nohs =     0xD00F   ;VIA port A data I/O register (no handshaking)

Cold_Start      =     0xF000   ;
Warm_Start      =     0xF06C   ;
Init_VIA        =     0xF14C   ;
Init_OS_RAM     =     0xF164   ;
Init_OS         =     0xF18B   ;
Wait_Recal      =     0xF192   ;
Set_Refresh     =     0xF1A2   ;
DP_to_D0        =     0xF1AA   ;
DP_to_C8        =     0xF1AF   ;
Read_Btns_Mask  =     0xF1B4   ;
Read_Btns       =     0xF1BA   ;
Joy_Analog      =     0xF1F5   ;
Joy_Digital     =     0xF1F8   ;
Sound_Byte      =     0xF256   ;
Sound_Byte_x    =     0xF259   ;
Sound_Byte_raw  =     0xF25B   ;
Clear_Sound     =     0xF272   ;
Sound_Bytes     =     0xF27D   ;
Sound_Bytes_x   =     0xF284   ;
Do_Sound        =     0xF289   ;
Do_Sound_x      =     0xF28C   ;
Intensity_1F    =     0xF29D   ;
Intensity_3F    =     0xF2A1   ;
Intensity_5F    =     0xF2A5   ;
Intensity_7F    =     0xF2A9   ;
Intensity_a     =     0xF2AB   ;
Dot_ix_b        =     0xF2BE   ;
Dot_ix          =     0xF2C1   ;
Dot_d           =     0xF2C3   ;
Dot_here        =     0xF2C5   ;
Dot_List        =     0xF2D5   ;
Dot_List_Reset  =     0xF2DE   ;
Recalibrate     =     0xF2E6   ;
Moveto_x_7F     =     0xF2F2   ;
Moveto_d_7F     =     0xF2FC   ;
Moveto_ix_FF    =     0xF308   ;
Moveto_ix_7F    =     0xF30C   ;
Moveto_ix_b     =     0xF30E   ;
Moveto_ix       =     0xF310   ;
Moveto_d        =     0xF312   ;
Reset0Ref_D0    =     0xF34A   ;
Check0Ref       =     0xF34F   ;
Reset0Ref       =     0xF354   ;
Reset_Pen       =     0xF35B   ;
Reset0Int       =     0xF36B   ;
Print_Str_hwyx  =     0xF373   ;
Print_Str_yx    =     0xF378   ;
Print_Str_d     =     0xF37A   ;
Print_List_hw   =     0xF385   ;
Print_List      =     0xF38A   ;
Print_List_chk  =     0xF38C   ;
Print_Ships_x   =     0xF391   ;
Print_Ships     =     0xF393   ;
Mov_Draw_VLc_a  =     0xF3AD   ;count y x y x ...
Mov_Draw_VL_b   =     0xF3B1   ;y x y x ...
Mov_Draw_VLcs   =     0xF3B5   ;count scale y x y x ...
Mov_Draw_VL_ab  =     0xF3B7   ;y x y x ...
Mov_Draw_VL_a   =     0xF3B9   ;y x y x ...
Mov_Draw_VL     =     0xF3BC   ;y x y x ...
Mov_Draw_VL_d   =     0xF3BE   ;y x y x ...
Draw_VLc        =     0xF3CE   ;count y x y x ...
Draw_VL_b       =     0xF3D2   ;y x y x ...
Draw_VLcs       =     0xF3D6   ;count scale y x y x ...
Draw_VL_ab      =     0xF3D8   ;y x y x ...
Draw_VL_a       =     0xF3DA   ;y x y x ...
Draw_VL         =     0xF3DD   ;y x y x ...
Draw_Line_d     =     0xF3DF   ;y x y x ...
Draw_VLp_FF     =     0xF404   ;pattern y x pattern y x ... 0x01
Draw_VLp_7F     =     0xF408   ;pattern y x pattern y x ... 0x01
Draw_VLp_scale  =     0xF40C   ;scale pattern y x pattern y x ... 0x01
Draw_VLp_b      =     0xF40E   ;pattern y x pattern y x ... 0x01
Draw_VLp        =     0xF410   ;pattern y x pattern y x ... 0x01
Draw_Pat_VL_a   =     0xF434   ;y x y x ...
Draw_Pat_VL     =     0xF437   ;y x y x ...
Draw_Pat_VL_d   =     0xF439   ;y x y x ...
Draw_VL_mode    =     0xF46E   ;mode y x mode y x ... 0x01
Print_Str       =     0xF495   ;
Random_3        =     0xF511   ;
Random          =     0xF517   ;
Init_Music_Buf  =     0xF533   ;
Clear_x_b       =     0xF53F   ;
Clear_C8_RAM    =     0xF542   ;never used by GCE carts?
Clear_x_256     =     0xF545   ;
Clear_x_d       =     0xF548   ;
Clear_x_b_80    =     0xF550   ;
Clear_x_b_a     =     0xF552   ;
Dec_3_Counters  =     0xF55A   ;
Dec_6_Counters  =     0xF55E   ;
Dec_Counters    =     0xF563   ;
Delay_3         =     0xF56D   ;30 cycles
Delay_2         =     0xF571   ;25 cycles
Delay_1         =     0xF575   ;20 cycles
Delay_0         =     0xF579   ;12 cycles
Delay_b         =     0xF57A   ;5*B + 10 cycles
Delay_RTS       =     0xF57D   ;5 cycles
Bitmask_a       =     0xF57E   ;
Abs_a_b         =     0xF584   ;
Abs_b           =     0xF58B   ;
Rise_Run_Angle  =     0xF593   ;
Get_Rise_Idx    =     0xF5D9   ;
Get_Run_Idx     =     0xF5DB   ;
Get_Rise_Run    =     0xF5EF   ;
Rise_Run_X      =     0xF5FF   ;
Rise_Run_Y      =     0xF601   ;
Rise_Run_Len    =     0xF603   ;

Rot_VL_ab       =     0xF610   ;
Rot_VL          =     0xF616   ;
Rot_VL_Mode   =     0xF61F   ;
Rot_VL_M_dft     =     0xF62B   ;
;Rot_VL_dft      EQU     0xF637   ;


;Rot_VL_ab       EQU     0xF610   ;
;Rot_VL          EQU     0xF616   ;
;Rot_VL_Mode_a   EQU     0xF61F   ;
;Rot_VL_Mode     EQU     0xF62B   ;
;Rot_VL_dft      EQU     0xF637   ;

Xform_Run_a     =     0xF65B   ;
Xform_Run       =     0xF65D   ;
Xform_Rise_a    =     0xF661   ;
Xform_Rise      =     0xF663   ;
Move_Mem_a_1    =     0xF67F   ;
Move_Mem_a      =     0xF683   ;
Init_Music_chk  =     0xF687   ;
Init_Music      =     0xF68D   ;
Init_Music_x    =     0xF692   ;
Select_Game     =     0xF7A9   ;
Clear_Score     =     0xF84F   ;
Add_Score_a     =     0xF85E   ;
Add_Score_d     =     0xF87C   ;
Strip_Zeros     =     0xF8B7   ;
Compare_Score   =     0xF8C7   ;
New_High_Score  =     0xF8D8   ;
Obj_Will_Hit_u  =     0xF8E5   ;
Obj_Will_Hit    =     0xF8F3   ;
Obj_Hit         =     0xF8FF   ;
Explosion_Snd   =     0xF92E   ;
Draw_Grid_VL    =     0xFF9F   ;
                                ;
music1  = 0xFD0D               ;
music2  = 0xFD1D               ;
music3  = 0xFD81               ;
music4  = 0xFDD3               ;
music5  = 0xFE38               ;
music6  = 0xFE76               ;
music7  = 0xFEC6               ;
music8  = 0xFEF8               ;
music9  = 0xFF26               ;
musica  = 0xFF44               ;
musicb  = 0xFF62               ;
musicc  = 0xFF7A               ;
musicd  = 0xFF8F               ;
Char_Table = 0xF9F4
Char_Table_End = 0xFBD4

; include line ->                     INCLUDE  "3d_var.I"          ; vectrex function includes
; this file is part of Release, written by Malban in 2017
;
; uses 11 + 27 *3 = 92 bytes RAM space

 .globl _helper
_helper:          .blkb 1
 .globl _cosx
_cosx:            .blkb 1
 .globl _sinx
_sinx:            .blkb 1
 .globl _cosy
_cosy:            .blkb 1
 .globl _siny
_siny:            .blkb 1
 .globl _cosz
_cosz:            .blkb 1
 .globl _sinz
_sinz:            .blkb 1
 .globl _angle_x
_angle_x:         .blkb 1
 .globl _angle_y
_angle_y:         .blkb 1
 .globl _angle_z
_angle_z:         .blkb 1
 .globl _vectorBits
_vectorBits: .blkb 2; 16 bits for vectors which must be calculated, order like below
 .globl _scale_3d
_scale_3d: .blkb 1
 .globl _scale_3d_move
_scale_3d_move: .blkb 1


 .globl _allDirs_calc
_allDirs_calc:    .blkb 27 * 3
 .globl _start_letter_data
_start_letter_data: .blkb 0

TEST_0_0_0           = 0x01 ; low byte
TEST_1_0_0           = 0x02 ; low byte
TEST_1_1_0           = 0x04 ; low byte
TEST_1_0_1           = 0x08 ; low byte
TEST_1_1_1           = 0x10 ; low byte
TEST_0_1_0           = 0x20 ; low byte
TEST_0_1_1           = 0x40 ; low byte
TEST_0_0_1           = 0x80 ; low byte
TEST_N_1_0           = 0x01 ; high byte
TEST_N_0_1           = 0x02 ; high byte
TEST_0_N_1           = 0x04 ; high byte
TEST_N_1_1           = 0x08 ; high byte
TEST_1_N_1           = 0x10 ; high byte
TEST_1_1_N           = 0x20 ; high byte

_0_0_0           = (_allDirs_calc+0)
_1_0_0           = (_allDirs_calc+3)
_1_1_0           = (_allDirs_calc+6)
_1_0_1           = (_allDirs_calc+9)
_1_1_1           = (_allDirs_calc+12)
_0_1_0           = (_allDirs_calc+15)
_0_1_1           = (_allDirs_calc+18)
_0_0_1           = (_allDirs_calc+21)
_N_1_0           = (_allDirs_calc+24)
_N_0_1           = (_allDirs_calc+27)
_0_N_1           = (_allDirs_calc+30)
_N_1_1           = (_allDirs_calc+33)
_1_N_1           = (_allDirs_calc+36)
_1_1_N           = (_allDirs_calc+39)

INVERS_OFFSET    = 42

ADD_000 = 0
ADD_100 = 3
ADD_110 = 6
ADD_101 = 9
ADD_111 = 12
ADD_010 = 15
ADD_011 = 18
ADD_001 = 21
ADD_N10 = 24
ADD_N01 = 27
ADD_0N1 = 30
ADD_N11 = 33
ADD_1N1 = 36
ADD_11N = 39

I_0_0_0          = (_0_0_0 + INVERS_OFFSET)
I_1_0_0          = (_1_0_0 + INVERS_OFFSET)
I_1_1_0          = (_1_1_0 + INVERS_OFFSET)
I_1_0_1          = (_1_0_1 + INVERS_OFFSET)
I_1_1_1          = (_1_1_1 + INVERS_OFFSET)
I_0_1_0          = (_0_1_0 + INVERS_OFFSET)
I_0_1_1          = (_0_1_1 + INVERS_OFFSET)
I_0_0_1          = (_0_0_1 + INVERS_OFFSET)
I_N_1_0          = (_N_1_0 + INVERS_OFFSET)
I_N_0_1          = (_N_0_1 + INVERS_OFFSET)
I_0_N_1          = (_0_N_1 + INVERS_OFFSET)
I_N_1_1          = (_N_1_1 + INVERS_OFFSET)
I_1_N_1          = (_1_N_1 + INVERS_OFFSET)
I_1_1_N          = (_1_1_N + INVERS_OFFSET)

_N_0_0           = I_1_0_0
_N_N_0           = I_1_1_0
_N_0_N           = I_1_0_1
_N_N_N           = I_1_1_1
_0_N_0           = I_0_1_0
_0_N_N           = I_0_1_1
_0_0_N           = I_0_0_1
_1_N_0           = I_N_1_0
_1_0_N           = I_N_0_1
_0_1_N           = I_0_N_1
_1_N_N           = I_N_1_1
_N_1_N           = I_1_N_1
_N_N_1           = I_1_1_N
; include line ->                     INCLUDE  "3d_MAKRO.I"          ; vectrex function includes
; this file is part of Release, written by Malban in 2017
;
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
; this does:
; signed multiplication of parameter 1 and parameter 2 to D
; and divides D by 64
; result is stored in A

;***************************************************************************
; include line ->                  INCLUDE "000.I"
; this file is part of Release, written by Malban in 2017
;
_000x            = (_allDirs_calc + ADD_000)
_000y            = (_allDirs_calc + ADD_000 + 1)
_000z            = (_allDirs_calc + ADD_000 + 2)
_000xi           = (_allDirs_calc + (ADD_000) + INVERS_OFFSET)
_000yi           = (_allDirs_calc + (ADD_000) + INVERS_OFFSET + 1)
_000zi           = (_allDirs_calc + (ADD_000) + INVERS_OFFSET + 2)

;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
; include line ->                  INCLUDE "100.I"
; this file is part of Release, written by Malban in 2017
;
_100x            = (_allDirs_calc + ADD_100)
_100y            = (_allDirs_calc + ADD_100 + 1)
_100z            = (_allDirs_calc + ADD_100 + 2)
_100xi           = (_allDirs_calc + (ADD_100) + INVERS_OFFSET)
_100yi           = (_allDirs_calc + (ADD_100) + INVERS_OFFSET + 1)
_100zi           = (_allDirs_calc + (ADD_100) + INVERS_OFFSET + 2)

;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
; include line ->                  INCLUDE "110.I"
; this file is part of Release, written by Malban in 2017
;
_110x            = (_allDirs_calc + ADD_110)
_110y            = (_allDirs_calc + ADD_110 + 1)
_110z            = (_allDirs_calc + ADD_110 + 2)
_110xi           = (_allDirs_calc + (ADD_110) + INVERS_OFFSET)
_110yi           = (_allDirs_calc + (ADD_110) + INVERS_OFFSET + 1)
_110zi           = (_allDirs_calc + (ADD_110) + INVERS_OFFSET + 2)

;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
; include line ->                  INCLUDE "101.I"
; this file is part of Release, written by Malban in 2017
;
_101x            = (_allDirs_calc + ADD_101)
_101y            = (_allDirs_calc + ADD_101 + 1)
_101z            = (_allDirs_calc + ADD_101 + 2)
_101xi           = (_allDirs_calc + (ADD_101) + INVERS_OFFSET)
_101yi           = (_allDirs_calc + (ADD_101) + INVERS_OFFSET + 1)
_101zi           = (_allDirs_calc + (ADD_101) + INVERS_OFFSET + 2)

;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
; include line ->                  INCLUDE "111.I"
; this file is part of Release, written by Malban in 2017
;
_111x            = (_allDirs_calc + ADD_111)
_111y            = (_allDirs_calc + ADD_111 + 1)
_111z            = (_allDirs_calc + ADD_111 + 2)
_111xi           = (_allDirs_calc + (ADD_111) + INVERS_OFFSET)
_111yi           = (_allDirs_calc + (ADD_111) + INVERS_OFFSET + 1)
_111zi           = (_allDirs_calc + (ADD_111) + INVERS_OFFSET + 2)

;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
; include line ->                  INCLUDE "010.I"
; this file is part of Release, written by Malban in 2017
;
_010x            = (_allDirs_calc + ADD_010)
_010y            = (_allDirs_calc + ADD_010 + 1)
_010z            = (_allDirs_calc + ADD_010 + 2)
_010xi           = (_allDirs_calc + (ADD_010) + INVERS_OFFSET)
_010yi           = (_allDirs_calc + (ADD_010) + INVERS_OFFSET + 1)
_010zi           = (_allDirs_calc + (ADD_010) + INVERS_OFFSET + 2)

;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
; include line ->                  INCLUDE "011.I"
; this file is part of Release, written by Malban in 2017
;
_011x            = (_allDirs_calc + ADD_011)
_011y            = (_allDirs_calc + ADD_011 + 1)
_011z            = (_allDirs_calc + ADD_011 + 2)
_011xi           = (_allDirs_calc + (ADD_011) + INVERS_OFFSET)
_011yi           = (_allDirs_calc + (ADD_011) + INVERS_OFFSET + 1)
_011zi           = (_allDirs_calc + (ADD_011) + INVERS_OFFSET + 2)

;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
; include line ->                  INCLUDE "001.I"
; this file is part of Release, written by Malban in 2017
;
_001x            = (_allDirs_calc + ADD_001)
_001y            = (_allDirs_calc + ADD_001 + 1)
_001z            = (_allDirs_calc + ADD_001 + 2)
_001xi           = (_allDirs_calc + (ADD_001) + INVERS_OFFSET)
_001yi           = (_allDirs_calc + (ADD_001) + INVERS_OFFSET + 1)
_001zi           = (_allDirs_calc + (ADD_001) + INVERS_OFFSET + 2)

;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
; include line ->                  INCLUDE "N10.I"
; this file is part of Release, written by Malban in 2017
;
_N10x            = (_allDirs_calc + ADD_N10)
_N10y            = (_allDirs_calc + ADD_N10 + 1)
_N10z            = (_allDirs_calc + ADD_N10 + 2)
_N10xi           = (_allDirs_calc + (ADD_N10) + INVERS_OFFSET)
_N10yi           = (_allDirs_calc + (ADD_N10) + INVERS_OFFSET + 1)
_N10zi           = (_allDirs_calc + (ADD_N10) + INVERS_OFFSET + 2)

;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
; include line ->                  INCLUDE "N01.I"
; this file is part of Release, written by Malban in 2017
;
_N01x            = (_allDirs_calc + ADD_N01)
_N01y            = (_allDirs_calc + ADD_N01 + 1)
_N01z            = (_allDirs_calc + ADD_N01 + 2)
_N01xi           = (_allDirs_calc + (ADD_N01) + INVERS_OFFSET)
_N01yi           = (_allDirs_calc + (ADD_N01) + INVERS_OFFSET + 1)
_N01zi           = (_allDirs_calc + (ADD_N01) + INVERS_OFFSET + 2)

;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
; include line ->                  INCLUDE "0N1.I"
; this file is part of Release, written by Malban in 2017
;
_0N1x            = (_allDirs_calc + ADD_0N1)
_0N1y            = (_allDirs_calc + ADD_0N1 + 1)
_0N1z            = (_allDirs_calc + ADD_0N1 + 2)
_0N1xi           = (_allDirs_calc + (ADD_0N1) + INVERS_OFFSET)
_0N1yi           = (_allDirs_calc + (ADD_0N1) + INVERS_OFFSET + 1)
_0N1zi           = (_allDirs_calc + (ADD_0N1) + INVERS_OFFSET + 2)

;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
; include line ->                  INCLUDE "N11.I"
; this file is part of Release, written by Malban in 2017
;
_N11x            = (_allDirs_calc + ADD_N11)
_N11y            = (_allDirs_calc + ADD_N11 + 1)
_N11z            = (_allDirs_calc + ADD_N11 + 2)
_N11xi           = (_allDirs_calc + (ADD_N11) + INVERS_OFFSET)
_N11yi           = (_allDirs_calc + (ADD_N11) + INVERS_OFFSET + 1)
_N11zi           = (_allDirs_calc + (ADD_N11) + INVERS_OFFSET + 2)

;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
; include line ->                  INCLUDE "1N1.I"
; this file is part of Release, written by Malban in 2017
;
_1N1x            = (_allDirs_calc + ADD_1N1)
_1N1y            = (_allDirs_calc + ADD_1N1 + 1)
_1N1z            = (_allDirs_calc + ADD_1N1 + 2)
_1N1xi           = (_allDirs_calc + (ADD_1N1) + INVERS_OFFSET)
_1N1yi           = (_allDirs_calc + (ADD_1N1) + INVERS_OFFSET + 1)
_1N1zi           = (_allDirs_calc + (ADD_1N1) + INVERS_OFFSET + 2)

;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
; include line ->                  INCLUDE "11N.I"
; this file is part of Release, written by Malban in 2017
;
_11Nx            = (_allDirs_calc + ADD_11N)
_11Ny            = (_allDirs_calc + ADD_11N + 1)
_11Nz            = (_allDirs_calc + ADD_11N + 2)
_11Nxi           = (_allDirs_calc + (ADD_11N) + INVERS_OFFSET)
_11Nyi           = (_allDirs_calc + (ADD_11N) + INVERS_OFFSET + 1)
_11Nzi           = (_allDirs_calc + (ADD_11N) + INVERS_OFFSET + 2)

;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************



;***************************************************************************
; HEADER SECTION
;***************************************************************************
; The cartridge ROM starts at address 0
                    .area .text     
; Warning - org line found, my be countering relocatable code!
;                    ORG      0 


; include line ->                     INCLUDE  "3d_prg.I"          ; vectrex function includes
; this file is part of Release, written by Malban in 2017
;
;**********************************************************  
; input list in X
; destroys u
; 0 move
; negative use as shift
; positive end
 .globl asm_draw_3ds
asm_draw_3ds: 
       ldu 2,x
       lda 1,x;
 .globl starts
starts:
       sta 0xd004;
       ldd ,u;
       sta 0xd001;
       clr 0xd000;
       lda ,x;
       inc 0xd000;
       stb 0xd001;
       sta 0xd00A;
       clr 0xd005;
       leax 4,x;
       ldu 2,x;
       lda ,x;
       bgt end1s;
       lda 1,x;
       ldb #0x40;
 .globl waits
waits: bitb 0xd00D;
       beq waits;
       ldb #0
       stb 0xd00A;
       bra starts;
 .globl end1s
end1s: ldd #0x0040;
 .globl ends
ends:  bitb 0xd00D;
       beq ends;
       sta 0xd00A
 rts

 
 .globl asm_draw_3d
asm_draw_3d:
       ldu 1,x
 .globl start
start: ldd ,u;
       sta 0xd001;
       clr 0xd000;
       lda ,x;
       inc 0xd000;
       stb 0xd001;
       sta 0xd00A;
       clr 0xd005;
       leax 3,x;
       ldu 1,x;
       lda ,x;
       bgt end1;
       ldd #0x0040;
 .globl wait
wait:  bitb 0xd00D;
       beq wait;
       sta 0xd00A;
       bra start;
 .globl end1
end1:  ldd #0x0040;
 .globl end
end:   bitb 0xd00D;
       beq end;
       sta 0xd00A
 rts

 .globl asm_draw_3d_dp
asm_draw_3d_dp:
       ldu 1,x
 .globl start_dp
start_dp: ldd ,u;
       sta *0xd001;
       clr *0xd000;
       lda ,x;
       inc *0xd000;
       stb *0xd001;
       sta *0xd00A;
       clr *0xd005;
       leax 3,x;
       ldu 1,x;
       lda ,x;
       bgt end1_dp;
       ldd #0x0040;
 .globl wait_dp
wait_dp:  bitb *0xd00D;
       beq wait_dp;
       sta *0xd00A;
       bra start_dp;
 .globl end1_dp
end1_dp:  ldd #0x0040;
 .globl end_dp
end_dp:   bitb *0xd00D;
       beq end_dp;
       sta *0xd00A
 rts


; Cosinus data
 .globl _cosinus3d
_cosinus3d: 
                    .byte       63, 62, 61, 60, 58, 55, 52, 48, 43, 39, 34 ; 11 
                    .byte       28, 23, 17, 10, 4, -1, -7, -14, -20, -25, -31 ; 22 
                    .byte       -36, -41, -46, -50, -53, -56, -59, -61, -62, -62, -62 ; 33 
                    .byte       -62, -61, -59, -56, -53, -50, -46, -41, -36, -31, -25 ; 44 
                    .byte       -20, -14, -7, -1, 4, 10, 17, 23, 28, 34, 39 ; 55 
                    .byte       43, 48, 52, 55, 58, 60, 61, 62, 63 
; Sinus data
 .globl _sinus3d
_sinus3d: 
                    .byte       0, 6, 12, 18, 24, 30, 35, 40, 45, 49, 52 ; 11 
                    .byte       56, 58, 60, 62, 62, 62, 62, 61, 59, 57, 54 ; 22 
                    .byte       51, 47, 42, 38, 32, 27, 21, 15, 9, 3, -3 ; 33 
                    .byte       -9, -15, -21, -27, -32, -38, -42, -47, -51, -54, -57 ; 44 
                    .byte       -59, -61, -62, -62, -62, -62, -60, -58, -56, -52, -49 ; 55 
                    .byte       -45, -40, -35, -30, -24, -18, -12, -6, -3 


 .globl init_2d
init_2d:
                    LDX      #_cosinus3d 
                    LDU      #_sinus3d 
                    LDB      _angle_x 
                    LDA      B, X 
                    STA      _cosx 
                    LDA      B, U 
                    STA      _sinx 
                    LDB      _angle_y 
                    LDA      B, X 
                    STA      _cosy 
                    LDA      B, U 
                    STA      _siny 
                    LDB      _angle_z 
                    LDA      B, X 
                    STA      _cosz 
                    LDA      B, U 
                    STA      _sinz 

 lda _vectorBits+1
 bita #TEST_0_0_0
 beq no0002d
; macro call ->                     INIT_0_0_0_A  
; macro call ->                  CALC_0_0_0_A _000x, _000y, _000z, _000xi, _000yi, _000zi
                 CLRA
                 STA           _000x
                 STA           _000y
                 STA           _000xi
                 STA           _000yi
 lda _vectorBits+1
 .globl no0002d
no0002d:
 bita #TEST_0_1_0
 lbeq no0102d
; macro call ->                     INIT_0_1_0_A  
; macro call ->                  CALC_0_1_0_A _010x, _010y, _010z, _010xi, _010yi, _010yi
; macro call ->                  A_EQUALS_MUL _cosx, _siny
                 LDB           _siny
                 LDA           _cosx
                 BPL           mul_Ap5
                 NEGA
                 TSTB
                 BPL           mul_An_Bp5
                 NEGB
                 BRA           mul_An_Bn5
 .globl mul_Ap5
mul_Ap5:
                 TSTB
                 BPL           mul_Ap_Bp5
                 NEGB
 .globl mul_An_Bp5
mul_An_Bp5:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end5
 .globl mul_Ap_Bp5
mul_Ap_Bp5:
 .globl mul_An_Bn5
mul_An_Bn5:
                 MUL
 .globl mul_end5
mul_end5:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  STORE_A _010x
                 STA           _010x
; macro call ->                  A_EQUALS_MUL _010x, _sinz
                 LDB           _sinz
                 LDA           _010x
                 BPL           mul_Ap7
                 NEGA
                 TSTB
                 BPL           mul_An_Bp7
                 NEGB
                 BRA           mul_An_Bn7
 .globl mul_Ap7
mul_Ap7:
                 TSTB
                 BPL           mul_Ap_Bp7
                 NEGB
 .globl mul_An_Bp7
mul_An_Bp7:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end7
 .globl mul_Ap_Bp7
mul_Ap_Bp7:
 .globl mul_An_Bn7
mul_An_Bn7:
                 MUL
 .globl mul_end7
mul_end7:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  STORE_A _010y
                 STA           _010y
; macro call ->                  A_EQUALS_MUL _sinx, _cosz
                 LDB           _cosz
                 LDA           _sinx
                 BPL           mul_Ap9
                 NEGA
                 TSTB
                 BPL           mul_An_Bp9
                 NEGB
                 BRA           mul_An_Bn9
 .globl mul_Ap9
mul_Ap9:
                 TSTB
                 BPL           mul_Ap_Bp9
                 NEGB
 .globl mul_An_Bp9
mul_An_Bp9:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end9
 .globl mul_Ap_Bp9
mul_Ap_Bp9:
 .globl mul_An_Bn9
mul_An_Bn9:
                 MUL
 .globl mul_end9
mul_end9:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  SUB_A_FROM _010y
                 NEGA
; macro call ->                  ADD_A_TO      _010y
                 ADDA          _010y
; macro call ->                  STORE_A       _010y
                 STA           _010y
; macro call ->                  STORE_A_NEG _010yi
                 NEGA
                 STA           _010yi
; macro call ->                  A_EQUALS_MUL _010x, _cosz
                 LDB           _cosz
                 LDA           _010x
                 BPL           mul_Ap14
                 NEGA
                 TSTB
                 BPL           mul_An_Bp14
                 NEGB
                 BRA           mul_An_Bn14
 .globl mul_Ap14
mul_Ap14:
                 TSTB
                 BPL           mul_Ap_Bp14
                 NEGB
 .globl mul_An_Bp14
mul_An_Bp14:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end14
 .globl mul_Ap_Bp14
mul_Ap_Bp14:
 .globl mul_An_Bn14
mul_An_Bn14:
                 MUL
 .globl mul_end14
mul_end14:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  STORE_A _010x
                 STA           _010x
; macro call ->                  A_EQUALS_MUL _sinx, _sinz
                 LDB           _sinz
                 LDA           _sinx
                 BPL           mul_Ap16
                 NEGA
                 TSTB
                 BPL           mul_An_Bp16
                 NEGB
                 BRA           mul_An_Bn16
 .globl mul_Ap16
mul_Ap16:
                 TSTB
                 BPL           mul_Ap_Bp16
                 NEGB
 .globl mul_An_Bp16
mul_An_Bp16:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end16
 .globl mul_Ap_Bp16
mul_Ap_Bp16:
 .globl mul_An_Bn16
mul_An_Bn16:
                 MUL
 .globl mul_end16
mul_end16:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  ADD_A_TO _010x
                 ADDA          _010x
; macro call ->                  STORE_A       _010x
                 STA           _010x
; macro call ->                  STORE_A_NEG _010xi
                 NEGA
                 STA           _010xi
 lda _vectorBits+1
 .globl no0102d
no0102d:
 bita #TEST_1_0_0
 beq no1002d
; macro call ->                     INIT_1_0_0_A  
; macro call ->                  CALC_1_0_0_A _100x, _100y, _100z, _100xi, _100yi, _100zi
; macro call ->                  A_EQUALS_MUL _cosy, _sinz
                 LDB           _sinz
                 LDA           _cosy
                 BPL           mul_Ap22
                 NEGA
                 TSTB
                 BPL           mul_An_Bp22
                 NEGB
                 BRA           mul_An_Bn22
 .globl mul_Ap22
mul_Ap22:
                 TSTB
                 BPL           mul_Ap_Bp22
                 NEGB
 .globl mul_An_Bp22
mul_An_Bp22:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end22
 .globl mul_Ap_Bp22
mul_Ap_Bp22:
 .globl mul_An_Bn22
mul_An_Bn22:
                 MUL
 .globl mul_end22
mul_end22:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  STORE_A _100y
                 STA           _100y
; macro call ->                  STORE_A_NEG _100yi
                 NEGA
                 STA           _100yi
; macro call ->                  A_EQUALS_MUL _cosy, _cosz
                 LDB           _cosz
                 LDA           _cosy
                 BPL           mul_Ap25
                 NEGA
                 TSTB
                 BPL           mul_An_Bp25
                 NEGB
                 BRA           mul_An_Bn25
 .globl mul_Ap25
mul_Ap25:
                 TSTB
                 BPL           mul_Ap_Bp25
                 NEGB
 .globl mul_An_Bp25
mul_An_Bp25:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end25
 .globl mul_Ap_Bp25
mul_Ap_Bp25:
 .globl mul_An_Bn25
mul_An_Bn25:
                 MUL
 .globl mul_end25
mul_end25:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  STORE_A _100x
                 STA           _100x
; macro call ->                  STORE_A_NEG _100xi
                 NEGA
                 STA           _100xi
 lda _vectorBits+1
 .globl no1002d
no1002d:
 bita #TEST_1_1_0
 lbeq no1102d
; macro call ->                     INIT_1_1_0_A  
; macro call ->                  CALC_1_1_0_A _110x, _110y, _110z, _110xi, _110yi, _110zi
                 LDA   _sinx
                 NEGA
                 STA   _helper
; macro call ->                  A_EQUALS_MUL _cosx, _siny
                 LDB           _siny
                 LDA           _cosx
                 BPL           mul_Ap30
                 NEGA
                 TSTB
                 BPL           mul_An_Bp30
                 NEGB
                 BRA           mul_An_Bn30
 .globl mul_Ap30
mul_Ap30:
                 TSTB
                 BPL           mul_Ap_Bp30
                 NEGB
 .globl mul_An_Bp30
mul_An_Bp30:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end30
 .globl mul_Ap_Bp30
mul_Ap_Bp30:
 .globl mul_An_Bn30
mul_An_Bn30:
                 MUL
 .globl mul_end30
mul_end30:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

                 ADDA  _cosy
; macro call ->                  STORE_A _110x
                 STA           _110x
; macro call ->                  A_EQUALS_MUL _helper, _cosz
                 LDB           _cosz
                 LDA           _helper
                 BPL           mul_Ap32
                 NEGA
                 TSTB
                 BPL           mul_An_Bp32
                 NEGB
                 BRA           mul_An_Bn32
 .globl mul_Ap32
mul_Ap32:
                 TSTB
                 BPL           mul_Ap_Bp32
                 NEGB
 .globl mul_An_Bp32
mul_An_Bp32:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end32
 .globl mul_Ap_Bp32
mul_Ap_Bp32:
 .globl mul_An_Bn32
mul_An_Bn32:
                 MUL
 .globl mul_end32
mul_end32:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  STORE_A _110y
                 STA           _110y
; macro call ->                  A_EQUALS_MUL _110x, _sinz
                 LDB           _sinz
                 LDA           _110x
                 BPL           mul_Ap34
                 NEGA
                 TSTB
                 BPL           mul_An_Bp34
                 NEGB
                 BRA           mul_An_Bn34
 .globl mul_Ap34
mul_Ap34:
                 TSTB
                 BPL           mul_Ap_Bp34
                 NEGB
 .globl mul_An_Bp34
mul_An_Bp34:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end34
 .globl mul_Ap_Bp34
mul_Ap_Bp34:
 .globl mul_An_Bn34
mul_An_Bn34:
                 MUL
 .globl mul_end34
mul_end34:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  ADD_A_TO _110y
                 ADDA          _110y
; macro call ->                  STORE_A       _110y
                 STA           _110y
; macro call ->                  STORE_A_NEG _110yi
                 NEGA
                 STA           _110yi
; macro call ->                  A_EQUALS_MUL _110x, _cosz
                 LDB           _cosz
                 LDA           _110x
                 BPL           mul_Ap38
                 NEGA
                 TSTB
                 BPL           mul_An_Bp38
                 NEGB
                 BRA           mul_An_Bn38
 .globl mul_Ap38
mul_Ap38:
                 TSTB
                 BPL           mul_Ap_Bp38
                 NEGB
 .globl mul_An_Bp38
mul_An_Bp38:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end38
 .globl mul_Ap_Bp38
mul_Ap_Bp38:
 .globl mul_An_Bn38
mul_An_Bn38:
                 MUL
 .globl mul_end38
mul_end38:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  STORE_A _110x
                 STA           _110x
; macro call ->                  A_EQUALS_MUL _helper, _sinz
                 LDB           _sinz
                 LDA           _helper
                 BPL           mul_Ap40
                 NEGA
                 TSTB
                 BPL           mul_An_Bp40
                 NEGB
                 BRA           mul_An_Bn40
 .globl mul_Ap40
mul_Ap40:
                 TSTB
                 BPL           mul_Ap_Bp40
                 NEGB
 .globl mul_An_Bp40
mul_An_Bp40:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end40
 .globl mul_Ap_Bp40
mul_Ap_Bp40:
 .globl mul_An_Bn40
mul_An_Bn40:
                 MUL
 .globl mul_end40
mul_end40:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  SUB_A_FROM _110x
                 NEGA
; macro call ->                  ADD_A_TO      _110x
                 ADDA          _110x
; macro call ->                  STORE_A       _110x
                 STA           _110x
; macro call ->                  STORE_A_NEG _110xi
                 NEGA
                 STA           _110xi
 .globl no1102d
no1102d:
 lda _vectorBits
 bita #TEST_N_1_0
 lbeq noN102d
; macro call ->                     INIT_N_1_0_A  
; macro call ->                  CALC_N_1_0_A _N10x, _N10y, _N10z, _N10xi, _N10yi, _N10zi
                 LDA   _sinx
                 NEGA
                 STA   _helper
; macro call ->                  A_EQUALS_MUL _cosx, _siny
                 LDB           _siny
                 LDA           _cosx
                 BPL           mul_Ap47
                 NEGA
                 TSTB
                 BPL           mul_An_Bp47
                 NEGB
                 BRA           mul_An_Bn47
 .globl mul_Ap47
mul_Ap47:
                 TSTB
                 BPL           mul_Ap_Bp47
                 NEGB
 .globl mul_An_Bp47
mul_An_Bp47:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end47
 .globl mul_Ap_Bp47
mul_Ap_Bp47:
 .globl mul_An_Bn47
mul_An_Bn47:
                 MUL
 .globl mul_end47
mul_end47:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

                 SUBA  _cosy
; macro call ->                  STORE_A _N10x
                 STA           _N10x
; macro call ->                  A_EQUALS_MUL _helper, _cosz
                 LDB           _cosz
                 LDA           _helper
                 BPL           mul_Ap49
                 NEGA
                 TSTB
                 BPL           mul_An_Bp49
                 NEGB
                 BRA           mul_An_Bn49
 .globl mul_Ap49
mul_Ap49:
                 TSTB
                 BPL           mul_Ap_Bp49
                 NEGB
 .globl mul_An_Bp49
mul_An_Bp49:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end49
 .globl mul_Ap_Bp49
mul_Ap_Bp49:
 .globl mul_An_Bn49
mul_An_Bn49:
                 MUL
 .globl mul_end49
mul_end49:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  STORE_A _N10y
                 STA           _N10y
; macro call ->                  A_EQUALS_MUL _N10x, _sinz
                 LDB           _sinz
                 LDA           _N10x
                 BPL           mul_Ap51
                 NEGA
                 TSTB
                 BPL           mul_An_Bp51
                 NEGB
                 BRA           mul_An_Bn51
 .globl mul_Ap51
mul_Ap51:
                 TSTB
                 BPL           mul_Ap_Bp51
                 NEGB
 .globl mul_An_Bp51
mul_An_Bp51:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end51
 .globl mul_Ap_Bp51
mul_Ap_Bp51:
 .globl mul_An_Bn51
mul_An_Bn51:
                 MUL
 .globl mul_end51
mul_end51:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  ADD_A_TO _N10y
                 ADDA          _N10y
; macro call ->                  STORE_A       _N10y
                 STA           _N10y
; macro call ->                  STORE_A_NEG _N10yi
                 NEGA
                 STA           _N10yi
; macro call ->                  A_EQUALS_MUL _N10x, _cosz
                 LDB           _cosz
                 LDA           _N10x
                 BPL           mul_Ap55
                 NEGA
                 TSTB
                 BPL           mul_An_Bp55
                 NEGB
                 BRA           mul_An_Bn55
 .globl mul_Ap55
mul_Ap55:
                 TSTB
                 BPL           mul_Ap_Bp55
                 NEGB
 .globl mul_An_Bp55
mul_An_Bp55:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end55
 .globl mul_Ap_Bp55
mul_Ap_Bp55:
 .globl mul_An_Bn55
mul_An_Bn55:
                 MUL
 .globl mul_end55
mul_end55:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  STORE_A _N10x
                 STA           _N10x
; macro call ->                  A_EQUALS_MUL _helper, _sinz
                 LDB           _sinz
                 LDA           _helper
                 BPL           mul_Ap57
                 NEGA
                 TSTB
                 BPL           mul_An_Bp57
                 NEGB
                 BRA           mul_An_Bn57
 .globl mul_Ap57
mul_Ap57:
                 TSTB
                 BPL           mul_Ap_Bp57
                 NEGB
 .globl mul_An_Bp57
mul_An_Bp57:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end57
 .globl mul_Ap_Bp57
mul_Ap_Bp57:
 .globl mul_An_Bn57
mul_An_Bn57:
                 MUL
 .globl mul_end57
mul_end57:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  SUB_A_FROM _N10x
                 NEGA
; macro call ->                  ADD_A_TO      _N10x
                 ADDA          _N10x
; macro call ->                  STORE_A       _N10x
                 STA           _N10x
; macro call ->                  STORE_A_NEG _N10xi
                 NEGA
                 STA           _N10xi
 .globl noN102d
noN102d:
                    RTS     



 .globl init_all
init_all:
                    LDX      #_cosinus3d 
                    LDU      #_sinus3d 
                    LDB      _angle_x 
                    LDA      B, X 
                    STA      _cosx 
                    LDA      B, U 
                    STA      _sinx 
                    LDB      _angle_y 
                    LDA      B, X 
                    STA      _cosy 
                    LDA      B, U 
                    STA      _siny 
                    LDB      _angle_z 
                    LDA      B, X 
                    STA      _cosz 
                    LDA      B, U 
                    STA      _sinz 

DO_Z_KOORDINATE = 1

 lda _vectorBits+1
 bita #TEST_0_0_0
 beq no000
; macro call ->                     INIT_0_0_0_A  
; macro call ->                  CALC_0_0_0_A _000x, _000y, _000z, _000xi, _000yi, _000zi
                 CLRA
                 STA           _000x
                 STA           _000y
                 STA           _000xi
                 STA           _000yi
                 STA _000z
                 STA _000zi
 lda _vectorBits+1
 .globl no000
no000:
 bita #TEST_1_0_0
 beq no100
; macro call ->                     INIT_1_0_0_A  
; macro call ->                  CALC_1_0_0_A _100x, _100y, _100z, _100xi, _100yi, _100zi
                 CLRA
                 STA _100z
                 STA _100zi
; macro call ->                  A_EQUALS_MUL _cosy, _sinz
                 LDB           _sinz
                 LDA           _cosy
                 BPL           mul_Ap66
                 NEGA
                 TSTB
                 BPL           mul_An_Bp66
                 NEGB
                 BRA           mul_An_Bn66
 .globl mul_Ap66
mul_Ap66:
                 TSTB
                 BPL           mul_Ap_Bp66
                 NEGB
 .globl mul_An_Bp66
mul_An_Bp66:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end66
 .globl mul_Ap_Bp66
mul_Ap_Bp66:
 .globl mul_An_Bn66
mul_An_Bn66:
                 MUL
 .globl mul_end66
mul_end66:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  STORE_A _100y
                 STA           _100y
; macro call ->                  STORE_A_NEG _100yi
                 NEGA
                 STA           _100yi
; macro call ->                  A_EQUALS_MUL _cosy, _cosz
                 LDB           _cosz
                 LDA           _cosy
                 BPL           mul_Ap69
                 NEGA
                 TSTB
                 BPL           mul_An_Bp69
                 NEGB
                 BRA           mul_An_Bn69
 .globl mul_Ap69
mul_Ap69:
                 TSTB
                 BPL           mul_Ap_Bp69
                 NEGB
 .globl mul_An_Bp69
mul_An_Bp69:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end69
 .globl mul_Ap_Bp69
mul_Ap_Bp69:
 .globl mul_An_Bn69
mul_An_Bn69:
                 MUL
 .globl mul_end69
mul_end69:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  STORE_A _100x
                 STA           _100x
; macro call ->                  STORE_A_NEG _100xi
                 NEGA
                 STA           _100xi
 lda _vectorBits+1
 .globl no100
no100:
 bita #TEST_1_1_0
 lbeq no110
; macro call ->                     INIT_1_1_0_A  
; macro call ->                  CALC_1_1_0_A _110x, _110y, _110z, _110xi, _110yi, _110zi
                 LDA _cosx
                 STA _110z
                 NEGA
                 STA _110zi
                 LDA   _sinx
                 NEGA
                 STA   _helper
; macro call ->                  A_EQUALS_MUL _cosx, _siny
                 LDB           _siny
                 LDA           _cosx
                 BPL           mul_Ap74
                 NEGA
                 TSTB
                 BPL           mul_An_Bp74
                 NEGB
                 BRA           mul_An_Bn74
 .globl mul_Ap74
mul_Ap74:
                 TSTB
                 BPL           mul_Ap_Bp74
                 NEGB
 .globl mul_An_Bp74
mul_An_Bp74:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end74
 .globl mul_Ap_Bp74
mul_Ap_Bp74:
 .globl mul_An_Bn74
mul_An_Bn74:
                 MUL
 .globl mul_end74
mul_end74:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

                 ADDA  _cosy
; macro call ->                  STORE_A _110x
                 STA           _110x
; macro call ->                  A_EQUALS_MUL _helper, _cosz
                 LDB           _cosz
                 LDA           _helper
                 BPL           mul_Ap76
                 NEGA
                 TSTB
                 BPL           mul_An_Bp76
                 NEGB
                 BRA           mul_An_Bn76
 .globl mul_Ap76
mul_Ap76:
                 TSTB
                 BPL           mul_Ap_Bp76
                 NEGB
 .globl mul_An_Bp76
mul_An_Bp76:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end76
 .globl mul_Ap_Bp76
mul_Ap_Bp76:
 .globl mul_An_Bn76
mul_An_Bn76:
                 MUL
 .globl mul_end76
mul_end76:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  STORE_A _110y
                 STA           _110y
; macro call ->                  A_EQUALS_MUL _110x, _sinz
                 LDB           _sinz
                 LDA           _110x
                 BPL           mul_Ap78
                 NEGA
                 TSTB
                 BPL           mul_An_Bp78
                 NEGB
                 BRA           mul_An_Bn78
 .globl mul_Ap78
mul_Ap78:
                 TSTB
                 BPL           mul_Ap_Bp78
                 NEGB
 .globl mul_An_Bp78
mul_An_Bp78:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end78
 .globl mul_Ap_Bp78
mul_Ap_Bp78:
 .globl mul_An_Bn78
mul_An_Bn78:
                 MUL
 .globl mul_end78
mul_end78:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  ADD_A_TO _110y
                 ADDA          _110y
; macro call ->                  STORE_A       _110y
                 STA           _110y
; macro call ->                  STORE_A_NEG _110yi
                 NEGA
                 STA           _110yi
; macro call ->                  A_EQUALS_MUL _110x, _cosz
                 LDB           _cosz
                 LDA           _110x
                 BPL           mul_Ap82
                 NEGA
                 TSTB
                 BPL           mul_An_Bp82
                 NEGB
                 BRA           mul_An_Bn82
 .globl mul_Ap82
mul_Ap82:
                 TSTB
                 BPL           mul_Ap_Bp82
                 NEGB
 .globl mul_An_Bp82
mul_An_Bp82:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end82
 .globl mul_Ap_Bp82
mul_Ap_Bp82:
 .globl mul_An_Bn82
mul_An_Bn82:
                 MUL
 .globl mul_end82
mul_end82:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  STORE_A _110x
                 STA           _110x
; macro call ->                  A_EQUALS_MUL _helper, _sinz
                 LDB           _sinz
                 LDA           _helper
                 BPL           mul_Ap84
                 NEGA
                 TSTB
                 BPL           mul_An_Bp84
                 NEGB
                 BRA           mul_An_Bn84
 .globl mul_Ap84
mul_Ap84:
                 TSTB
                 BPL           mul_Ap_Bp84
                 NEGB
 .globl mul_An_Bp84
mul_An_Bp84:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end84
 .globl mul_Ap_Bp84
mul_Ap_Bp84:
 .globl mul_An_Bn84
mul_An_Bn84:
                 MUL
 .globl mul_end84
mul_end84:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  SUB_A_FROM _110x
                 NEGA
; macro call ->                  ADD_A_TO      _110x
                 ADDA          _110x
; macro call ->                  STORE_A       _110x
                 STA           _110x
; macro call ->                  STORE_A_NEG _110xi
                 NEGA
                 STA           _110xi
 lda _vectorBits+1
 .globl no110
no110:
 bita #TEST_1_0_1
 lbeq no101
; macro call ->                     INIT_1_0_1_A  
; macro call ->                  CALC_1_0_1_A _101x, _101y, _101z, _101xi, _101yi, _101zi
                 LDA _sinx
                 STA _101z
                 NEGA
                 STA _101zi
; macro call ->                  A_EQUALS_MUL _sinx, _siny
                 LDB           _siny
                 LDA           _sinx
                 BPL           mul_Ap91
                 NEGA
                 TSTB
                 BPL           mul_An_Bp91
                 NEGB
                 BRA           mul_An_Bn91
 .globl mul_Ap91
mul_Ap91:
                 TSTB
                 BPL           mul_Ap_Bp91
                 NEGB
 .globl mul_An_Bp91
mul_An_Bp91:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end91
 .globl mul_Ap_Bp91
mul_Ap_Bp91:
 .globl mul_An_Bn91
mul_An_Bn91:
                 MUL
 .globl mul_end91
mul_end91:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

                 ADDA   _cosy
; macro call ->                  STORE_A _101x
                 STA           _101x
; macro call ->                  A_EQUALS_MUL _cosx, _cosz
                 LDB           _cosz
                 LDA           _cosx
                 BPL           mul_Ap93
                 NEGA
                 TSTB
                 BPL           mul_An_Bp93
                 NEGB
                 BRA           mul_An_Bn93
 .globl mul_Ap93
mul_Ap93:
                 TSTB
                 BPL           mul_Ap_Bp93
                 NEGB
 .globl mul_An_Bp93
mul_An_Bp93:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end93
 .globl mul_Ap_Bp93
mul_Ap_Bp93:
 .globl mul_An_Bn93
mul_An_Bn93:
                 MUL
 .globl mul_end93
mul_end93:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  STORE_A _101y
                 STA           _101y
; macro call ->                  A_EQUALS_MUL _101x, _sinz
                 LDB           _sinz
                 LDA           _101x
                 BPL           mul_Ap95
                 NEGA
                 TSTB
                 BPL           mul_An_Bp95
                 NEGB
                 BRA           mul_An_Bn95
 .globl mul_Ap95
mul_Ap95:
                 TSTB
                 BPL           mul_Ap_Bp95
                 NEGB
 .globl mul_An_Bp95
mul_An_Bp95:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end95
 .globl mul_Ap_Bp95
mul_Ap_Bp95:
 .globl mul_An_Bn95
mul_An_Bn95:
                 MUL
 .globl mul_end95
mul_end95:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  ADD_A_TO _101y
                 ADDA          _101y
; macro call ->                  STORE_A       _101y
                 STA           _101y
; macro call ->                  STORE_A_NEG _101yi
                 NEGA
                 STA           _101yi
; macro call ->                  A_EQUALS_MUL _101x, _cosz
                 LDB           _cosz
                 LDA           _101x
                 BPL           mul_Ap99
                 NEGA
                 TSTB
                 BPL           mul_An_Bp99
                 NEGB
                 BRA           mul_An_Bn99
 .globl mul_Ap99
mul_Ap99:
                 TSTB
                 BPL           mul_Ap_Bp99
                 NEGB
 .globl mul_An_Bp99
mul_An_Bp99:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end99
 .globl mul_Ap_Bp99
mul_Ap_Bp99:
 .globl mul_An_Bn99
mul_An_Bn99:
                 MUL
 .globl mul_end99
mul_end99:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  STORE_A _101x
                 STA           _101x
; macro call ->                  A_EQUALS_MUL _cosx, _sinz
                 LDB           _sinz
                 LDA           _cosx
                 BPL           mul_Ap101
                 NEGA
                 TSTB
                 BPL           mul_An_Bp101
                 NEGB
                 BRA           mul_An_Bn101
 .globl mul_Ap101
mul_Ap101:
                 TSTB
                 BPL           mul_Ap_Bp101
                 NEGB
 .globl mul_An_Bp101
mul_An_Bp101:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end101
 .globl mul_Ap_Bp101
mul_Ap_Bp101:
 .globl mul_An_Bn101
mul_An_Bn101:
                 MUL
 .globl mul_end101
mul_end101:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  SUB_A_FROM _101x
                 NEGA
; macro call ->                  ADD_A_TO      _101x
                 ADDA          _101x
; macro call ->                  STORE_A       _101x
                 STA           _101x
; macro call ->                  STORE_A_NEG _101xi
                 NEGA
                 STA           _101xi
 lda _vectorBits+1
 .globl no101
no101:
 bita #TEST_1_1_1
 lbeq no111
; macro call ->                     INIT_1_1_1_A  
; macro call ->                  CALC_1_1_1_A _111x, _111y, _111z, _111xi, _111yi, _111zi
                 LDA _cosx
                 ADDA _sinx
                 STA _111z
                 NEGA
                 STA _111zi
                 LDA   _sinx
                 ADDA  _cosx
                 STA   _111z

                 LDA   _cosx
                 SUBA  _sinx
                 STA   _helper

; macro call ->                  A_EQUALS_MUL _111z, _siny
                 LDB           _siny
                 LDA           _111z
                 BPL           mul_Ap108
                 NEGA
                 TSTB
                 BPL           mul_An_Bp108
                 NEGB
                 BRA           mul_An_Bn108
 .globl mul_Ap108
mul_Ap108:
                 TSTB
                 BPL           mul_Ap_Bp108
                 NEGB
 .globl mul_An_Bp108
mul_An_Bp108:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end108
 .globl mul_Ap_Bp108
mul_Ap_Bp108:
 .globl mul_An_Bn108
mul_An_Bn108:
                 MUL
 .globl mul_end108
mul_end108:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

                 ADDA  _cosy
; macro call ->                  STORE_A _111x
                 STA           _111x
; macro call ->                  A_EQUALS_MUL _helper, _cosz
                 LDB           _cosz
                 LDA           _helper
                 BPL           mul_Ap110
                 NEGA
                 TSTB
                 BPL           mul_An_Bp110
                 NEGB
                 BRA           mul_An_Bn110
 .globl mul_Ap110
mul_Ap110:
                 TSTB
                 BPL           mul_Ap_Bp110
                 NEGB
 .globl mul_An_Bp110
mul_An_Bp110:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end110
 .globl mul_Ap_Bp110
mul_Ap_Bp110:
 .globl mul_An_Bn110
mul_An_Bn110:
                 MUL
 .globl mul_end110
mul_end110:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  STORE_A _111y
                 STA           _111y
; macro call ->                  A_EQUALS_MUL _111x, _sinz
                 LDB           _sinz
                 LDA           _111x
                 BPL           mul_Ap112
                 NEGA
                 TSTB
                 BPL           mul_An_Bp112
                 NEGB
                 BRA           mul_An_Bn112
 .globl mul_Ap112
mul_Ap112:
                 TSTB
                 BPL           mul_Ap_Bp112
                 NEGB
 .globl mul_An_Bp112
mul_An_Bp112:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end112
 .globl mul_Ap_Bp112
mul_Ap_Bp112:
 .globl mul_An_Bn112
mul_An_Bn112:
                 MUL
 .globl mul_end112
mul_end112:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  ADD_A_TO _111y
                 ADDA          _111y
; macro call ->                  STORE_A       _111y
                 STA           _111y
; macro call ->                  STORE_A_NEG _111yi
                 NEGA
                 STA           _111yi
; macro call ->                  A_EQUALS_MUL _111x, _cosz
                 LDB           _cosz
                 LDA           _111x
                 BPL           mul_Ap116
                 NEGA
                 TSTB
                 BPL           mul_An_Bp116
                 NEGB
                 BRA           mul_An_Bn116
 .globl mul_Ap116
mul_Ap116:
                 TSTB
                 BPL           mul_Ap_Bp116
                 NEGB
 .globl mul_An_Bp116
mul_An_Bp116:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end116
 .globl mul_Ap_Bp116
mul_Ap_Bp116:
 .globl mul_An_Bn116
mul_An_Bn116:
                 MUL
 .globl mul_end116
mul_end116:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  STORE_A _111x
                 STA           _111x
; macro call ->                  A_EQUALS_MUL _helper, _sinz
                 LDB           _sinz
                 LDA           _helper
                 BPL           mul_Ap118
                 NEGA
                 TSTB
                 BPL           mul_An_Bp118
                 NEGB
                 BRA           mul_An_Bn118
 .globl mul_Ap118
mul_Ap118:
                 TSTB
                 BPL           mul_Ap_Bp118
                 NEGB
 .globl mul_An_Bp118
mul_An_Bp118:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end118
 .globl mul_Ap_Bp118
mul_Ap_Bp118:
 .globl mul_An_Bn118
mul_An_Bn118:
                 MUL
 .globl mul_end118
mul_end118:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  SUB_A_FROM _111x
                 NEGA
; macro call ->                  ADD_A_TO      _111x
                 ADDA          _111x
; macro call ->                  STORE_A       _111x
                 STA           _111x
; macro call ->                  STORE_A_NEG _111xi
                 NEGA
                 STA           _111xi
 lda _vectorBits+1
 .globl no111
no111:
 bita #TEST_0_1_0
 lbeq no010
; macro call ->                     INIT_0_1_0_A  
; macro call ->                  CALC_0_1_0_A _010x, _010y, _010z, _010xi, _010yi, _010yi
                 LDA _cosx
                 STA _010z
                 NEGA
                 STA _010yi
; macro call ->                  A_EQUALS_MUL _cosx, _siny
                 LDB           _siny
                 LDA           _cosx
                 BPL           mul_Ap125
                 NEGA
                 TSTB
                 BPL           mul_An_Bp125
                 NEGB
                 BRA           mul_An_Bn125
 .globl mul_Ap125
mul_Ap125:
                 TSTB
                 BPL           mul_Ap_Bp125
                 NEGB
 .globl mul_An_Bp125
mul_An_Bp125:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end125
 .globl mul_Ap_Bp125
mul_Ap_Bp125:
 .globl mul_An_Bn125
mul_An_Bn125:
                 MUL
 .globl mul_end125
mul_end125:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  STORE_A _010x
                 STA           _010x
; macro call ->                  A_EQUALS_MUL _010x, _sinz
                 LDB           _sinz
                 LDA           _010x
                 BPL           mul_Ap127
                 NEGA
                 TSTB
                 BPL           mul_An_Bp127
                 NEGB
                 BRA           mul_An_Bn127
 .globl mul_Ap127
mul_Ap127:
                 TSTB
                 BPL           mul_Ap_Bp127
                 NEGB
 .globl mul_An_Bp127
mul_An_Bp127:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end127
 .globl mul_Ap_Bp127
mul_Ap_Bp127:
 .globl mul_An_Bn127
mul_An_Bn127:
                 MUL
 .globl mul_end127
mul_end127:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  STORE_A _010y
                 STA           _010y
; macro call ->                  A_EQUALS_MUL _sinx, _cosz
                 LDB           _cosz
                 LDA           _sinx
                 BPL           mul_Ap129
                 NEGA
                 TSTB
                 BPL           mul_An_Bp129
                 NEGB
                 BRA           mul_An_Bn129
 .globl mul_Ap129
mul_Ap129:
                 TSTB
                 BPL           mul_Ap_Bp129
                 NEGB
 .globl mul_An_Bp129
mul_An_Bp129:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end129
 .globl mul_Ap_Bp129
mul_Ap_Bp129:
 .globl mul_An_Bn129
mul_An_Bn129:
                 MUL
 .globl mul_end129
mul_end129:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  SUB_A_FROM _010y
                 NEGA
; macro call ->                  ADD_A_TO      _010y
                 ADDA          _010y
; macro call ->                  STORE_A       _010y
                 STA           _010y
; macro call ->                  STORE_A_NEG _010yi
                 NEGA
                 STA           _010yi
; macro call ->                  A_EQUALS_MUL _010x, _cosz
                 LDB           _cosz
                 LDA           _010x
                 BPL           mul_Ap134
                 NEGA
                 TSTB
                 BPL           mul_An_Bp134
                 NEGB
                 BRA           mul_An_Bn134
 .globl mul_Ap134
mul_Ap134:
                 TSTB
                 BPL           mul_Ap_Bp134
                 NEGB
 .globl mul_An_Bp134
mul_An_Bp134:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end134
 .globl mul_Ap_Bp134
mul_Ap_Bp134:
 .globl mul_An_Bn134
mul_An_Bn134:
                 MUL
 .globl mul_end134
mul_end134:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  STORE_A _010x
                 STA           _010x
; macro call ->                  A_EQUALS_MUL _sinx, _sinz
                 LDB           _sinz
                 LDA           _sinx
                 BPL           mul_Ap136
                 NEGA
                 TSTB
                 BPL           mul_An_Bp136
                 NEGB
                 BRA           mul_An_Bn136
 .globl mul_Ap136
mul_Ap136:
                 TSTB
                 BPL           mul_Ap_Bp136
                 NEGB
 .globl mul_An_Bp136
mul_An_Bp136:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end136
 .globl mul_Ap_Bp136
mul_Ap_Bp136:
 .globl mul_An_Bn136
mul_An_Bn136:
                 MUL
 .globl mul_end136
mul_end136:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  ADD_A_TO _010x
                 ADDA          _010x
; macro call ->                  STORE_A       _010x
                 STA           _010x
; macro call ->                  STORE_A_NEG _010xi
                 NEGA
                 STA           _010xi
 lda _vectorBits+1
 .globl no010
no010:
 bita #TEST_0_1_1
 lbeq no011
; macro call ->                     INIT_0_1_1_A  
; macro call ->                  CALC_0_1_1_A _011x, _011y, _011z, _011xi, _011yi, _011zi
                 LDA _cosx
                 ADDA _sinx
                 STA _011z
                 NEGA
                 STA _011zi
                 LDA   _sinx
                 ADDA  _cosx
                 STA   _011z
                 LDA   _cosx
                 SUBA  _sinx
                 STA   _helper
; macro call ->                  A_EQUALS_MUL _011z, _siny
                 LDB           _siny
                 LDA           _011z
                 BPL           mul_Ap142
                 NEGA
                 TSTB
                 BPL           mul_An_Bp142
                 NEGB
                 BRA           mul_An_Bn142
 .globl mul_Ap142
mul_Ap142:
                 TSTB
                 BPL           mul_Ap_Bp142
                 NEGB
 .globl mul_An_Bp142
mul_An_Bp142:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end142
 .globl mul_Ap_Bp142
mul_Ap_Bp142:
 .globl mul_An_Bn142
mul_An_Bn142:
                 MUL
 .globl mul_end142
mul_end142:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  STORE_A _011x
                 STA           _011x
; macro call ->                  A_EQUALS_MUL _helper, _cosz
                 LDB           _cosz
                 LDA           _helper
                 BPL           mul_Ap144
                 NEGA
                 TSTB
                 BPL           mul_An_Bp144
                 NEGB
                 BRA           mul_An_Bn144
 .globl mul_Ap144
mul_Ap144:
                 TSTB
                 BPL           mul_Ap_Bp144
                 NEGB
 .globl mul_An_Bp144
mul_An_Bp144:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end144
 .globl mul_Ap_Bp144
mul_Ap_Bp144:
 .globl mul_An_Bn144
mul_An_Bn144:
                 MUL
 .globl mul_end144
mul_end144:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  STORE_A _011y
                 STA           _011y
; macro call ->                  A_EQUALS_MUL _011x, _sinz
                 LDB           _sinz
                 LDA           _011x
                 BPL           mul_Ap146
                 NEGA
                 TSTB
                 BPL           mul_An_Bp146
                 NEGB
                 BRA           mul_An_Bn146
 .globl mul_Ap146
mul_Ap146:
                 TSTB
                 BPL           mul_Ap_Bp146
                 NEGB
 .globl mul_An_Bp146
mul_An_Bp146:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end146
 .globl mul_Ap_Bp146
mul_Ap_Bp146:
 .globl mul_An_Bn146
mul_An_Bn146:
                 MUL
 .globl mul_end146
mul_end146:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  ADD_A_TO _011y
                 ADDA          _011y
; macro call ->                  STORE_A       _011y
                 STA           _011y
; macro call ->                  STORE_A_NEG _011yi
                 NEGA
                 STA           _011yi
; macro call ->                  A_EQUALS_MUL _011x, _cosz
                 LDB           _cosz
                 LDA           _011x
                 BPL           mul_Ap150
                 NEGA
                 TSTB
                 BPL           mul_An_Bp150
                 NEGB
                 BRA           mul_An_Bn150
 .globl mul_Ap150
mul_Ap150:
                 TSTB
                 BPL           mul_Ap_Bp150
                 NEGB
 .globl mul_An_Bp150
mul_An_Bp150:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end150
 .globl mul_Ap_Bp150
mul_Ap_Bp150:
 .globl mul_An_Bn150
mul_An_Bn150:
                 MUL
 .globl mul_end150
mul_end150:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  STORE_A _011x
                 STA           _011x
; macro call ->                  A_EQUALS_MUL _helper, _sinz
                 LDB           _sinz
                 LDA           _helper
                 BPL           mul_Ap152
                 NEGA
                 TSTB
                 BPL           mul_An_Bp152
                 NEGB
                 BRA           mul_An_Bn152
 .globl mul_Ap152
mul_Ap152:
                 TSTB
                 BPL           mul_Ap_Bp152
                 NEGB
 .globl mul_An_Bp152
mul_An_Bp152:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end152
 .globl mul_Ap_Bp152
mul_Ap_Bp152:
 .globl mul_An_Bn152
mul_An_Bn152:
                 MUL
 .globl mul_end152
mul_end152:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  SUB_A_FROM _011x
                 NEGA
; macro call ->                  ADD_A_TO      _011x
                 ADDA          _011x
; macro call ->                  STORE_A       _011x
                 STA           _011x
; macro call ->                  STORE_A_NEG _011xi
                 NEGA
                 STA           _011xi
 lda _vectorBits+1
 .globl no011
no011:
 bita #TEST_0_0_1
 lbeq no001
; macro call ->                     INIT_0_0_1_A  
; macro call ->                  CALC_0_0_1_A _001x, _001y, _001z, _001xi, _001yi, _001zi
                 LDA _sinx
                 STA _001z
                 NEGA
                 STA _001zi
; macro call ->                  A_EQUALS_MUL _sinx, _siny
                 LDB           _siny
                 LDA           _sinx
                 BPL           mul_Ap159
                 NEGA
                 TSTB
                 BPL           mul_An_Bp159
                 NEGB
                 BRA           mul_An_Bn159
 .globl mul_Ap159
mul_Ap159:
                 TSTB
                 BPL           mul_Ap_Bp159
                 NEGB
 .globl mul_An_Bp159
mul_An_Bp159:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end159
 .globl mul_Ap_Bp159
mul_Ap_Bp159:
 .globl mul_An_Bn159
mul_An_Bn159:
                 MUL
 .globl mul_end159
mul_end159:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  STORE_A _001x
                 STA           _001x
; macro call ->                  A_EQUALS_MUL _cosx, _cosz
                 LDB           _cosz
                 LDA           _cosx
                 BPL           mul_Ap161
                 NEGA
                 TSTB
                 BPL           mul_An_Bp161
                 NEGB
                 BRA           mul_An_Bn161
 .globl mul_Ap161
mul_Ap161:
                 TSTB
                 BPL           mul_Ap_Bp161
                 NEGB
 .globl mul_An_Bp161
mul_An_Bp161:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end161
 .globl mul_Ap_Bp161
mul_Ap_Bp161:
 .globl mul_An_Bn161
mul_An_Bn161:
                 MUL
 .globl mul_end161
mul_end161:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  STORE_A _001y
                 STA           _001y
; macro call ->                  A_EQUALS_MUL _001x, _sinz
                 LDB           _sinz
                 LDA           _001x
                 BPL           mul_Ap163
                 NEGA
                 TSTB
                 BPL           mul_An_Bp163
                 NEGB
                 BRA           mul_An_Bn163
 .globl mul_Ap163
mul_Ap163:
                 TSTB
                 BPL           mul_Ap_Bp163
                 NEGB
 .globl mul_An_Bp163
mul_An_Bp163:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end163
 .globl mul_Ap_Bp163
mul_Ap_Bp163:
 .globl mul_An_Bn163
mul_An_Bn163:
                 MUL
 .globl mul_end163
mul_end163:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  ADD_A_TO _001y
                 ADDA          _001y
; macro call ->                  STORE_A       _001y
                 STA           _001y
; macro call ->                  STORE_A_NEG _001yi
                 NEGA
                 STA           _001yi
; macro call ->                  A_EQUALS_MUL _001x, _cosz
                 LDB           _cosz
                 LDA           _001x
                 BPL           mul_Ap167
                 NEGA
                 TSTB
                 BPL           mul_An_Bp167
                 NEGB
                 BRA           mul_An_Bn167
 .globl mul_Ap167
mul_Ap167:
                 TSTB
                 BPL           mul_Ap_Bp167
                 NEGB
 .globl mul_An_Bp167
mul_An_Bp167:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end167
 .globl mul_Ap_Bp167
mul_Ap_Bp167:
 .globl mul_An_Bn167
mul_An_Bn167:
                 MUL
 .globl mul_end167
mul_end167:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  STORE_A _001x
                 STA           _001x
; macro call ->                  A_EQUALS_MUL _cosx, _sinz
                 LDB           _sinz
                 LDA           _cosx
                 BPL           mul_Ap169
                 NEGA
                 TSTB
                 BPL           mul_An_Bp169
                 NEGB
                 BRA           mul_An_Bn169
 .globl mul_Ap169
mul_Ap169:
                 TSTB
                 BPL           mul_Ap_Bp169
                 NEGB
 .globl mul_An_Bp169
mul_An_Bp169:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end169
 .globl mul_Ap_Bp169
mul_Ap_Bp169:
 .globl mul_An_Bn169
mul_An_Bn169:
                 MUL
 .globl mul_end169
mul_end169:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  SUB_A_FROM _001x
                 NEGA
; macro call ->                  ADD_A_TO      _001x
                 ADDA          _001x
; macro call ->                  STORE_A       _001x
                 STA           _001x
; macro call ->                  STORE_A_NEG _001xi
                 NEGA
                 STA           _001xi
 .globl no001
no001:
 lda _vectorBits
 bita #TEST_N_1_0
 lbeq noN10
; macro call ->                     INIT_N_1_0_A  
; macro call ->                  CALC_N_1_0_A _N10x, _N10y, _N10z, _N10xi, _N10yi, _N10zi
                 LDA _cosx
                 STA _N10z
                 NEGA
                 STA _N10zi
                 LDA   _sinx
                 NEGA
                 STA   _helper
; macro call ->                  A_EQUALS_MUL _cosx, _siny
                 LDB           _siny
                 LDA           _cosx
                 BPL           mul_Ap176
                 NEGA
                 TSTB
                 BPL           mul_An_Bp176
                 NEGB
                 BRA           mul_An_Bn176
 .globl mul_Ap176
mul_Ap176:
                 TSTB
                 BPL           mul_Ap_Bp176
                 NEGB
 .globl mul_An_Bp176
mul_An_Bp176:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end176
 .globl mul_Ap_Bp176
mul_Ap_Bp176:
 .globl mul_An_Bn176
mul_An_Bn176:
                 MUL
 .globl mul_end176
mul_end176:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

                 SUBA  _cosy
; macro call ->                  STORE_A _N10x
                 STA           _N10x
; macro call ->                  A_EQUALS_MUL _helper, _cosz
                 LDB           _cosz
                 LDA           _helper
                 BPL           mul_Ap178
                 NEGA
                 TSTB
                 BPL           mul_An_Bp178
                 NEGB
                 BRA           mul_An_Bn178
 .globl mul_Ap178
mul_Ap178:
                 TSTB
                 BPL           mul_Ap_Bp178
                 NEGB
 .globl mul_An_Bp178
mul_An_Bp178:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end178
 .globl mul_Ap_Bp178
mul_Ap_Bp178:
 .globl mul_An_Bn178
mul_An_Bn178:
                 MUL
 .globl mul_end178
mul_end178:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  STORE_A _N10y
                 STA           _N10y
; macro call ->                  A_EQUALS_MUL _N10x, _sinz
                 LDB           _sinz
                 LDA           _N10x
                 BPL           mul_Ap180
                 NEGA
                 TSTB
                 BPL           mul_An_Bp180
                 NEGB
                 BRA           mul_An_Bn180
 .globl mul_Ap180
mul_Ap180:
                 TSTB
                 BPL           mul_Ap_Bp180
                 NEGB
 .globl mul_An_Bp180
mul_An_Bp180:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end180
 .globl mul_Ap_Bp180
mul_Ap_Bp180:
 .globl mul_An_Bn180
mul_An_Bn180:
                 MUL
 .globl mul_end180
mul_end180:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  ADD_A_TO _N10y
                 ADDA          _N10y
; macro call ->                  STORE_A       _N10y
                 STA           _N10y
; macro call ->                  STORE_A_NEG _N10yi
                 NEGA
                 STA           _N10yi
; macro call ->                  A_EQUALS_MUL _N10x, _cosz
                 LDB           _cosz
                 LDA           _N10x
                 BPL           mul_Ap184
                 NEGA
                 TSTB
                 BPL           mul_An_Bp184
                 NEGB
                 BRA           mul_An_Bn184
 .globl mul_Ap184
mul_Ap184:
                 TSTB
                 BPL           mul_Ap_Bp184
                 NEGB
 .globl mul_An_Bp184
mul_An_Bp184:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end184
 .globl mul_Ap_Bp184
mul_Ap_Bp184:
 .globl mul_An_Bn184
mul_An_Bn184:
                 MUL
 .globl mul_end184
mul_end184:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  STORE_A _N10x
                 STA           _N10x
; macro call ->                  A_EQUALS_MUL _helper, _sinz
                 LDB           _sinz
                 LDA           _helper
                 BPL           mul_Ap186
                 NEGA
                 TSTB
                 BPL           mul_An_Bp186
                 NEGB
                 BRA           mul_An_Bn186
 .globl mul_Ap186
mul_Ap186:
                 TSTB
                 BPL           mul_Ap_Bp186
                 NEGB
 .globl mul_An_Bp186
mul_An_Bp186:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end186
 .globl mul_Ap_Bp186
mul_Ap_Bp186:
 .globl mul_An_Bn186
mul_An_Bn186:
                 MUL
 .globl mul_end186
mul_end186:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  SUB_A_FROM _N10x
                 NEGA
; macro call ->                  ADD_A_TO      _N10x
                 ADDA          _N10x
; macro call ->                  STORE_A       _N10x
                 STA           _N10x
; macro call ->                  STORE_A_NEG _N10xi
                 NEGA
                 STA           _N10xi
 lda _vectorBits
 .globl noN10
noN10:
 bita #TEST_N_0_1
 lbeq noN01
; macro call ->                     INIT_N_0_1_A  
; macro call ->                  CALC_N_0_1_A _N01x, _N01y, _N01z, _N01xi, _N01yi, _N01zi
                 LDA _sinx
                 STA _N01z
                 NEGA
                 STA _N01zi
; macro call ->                  A_EQUALS_MUL _sinx, _siny
                 LDB           _siny
                 LDA           _sinx
                 BPL           mul_Ap193
                 NEGA
                 TSTB
                 BPL           mul_An_Bp193
                 NEGB
                 BRA           mul_An_Bn193
 .globl mul_Ap193
mul_Ap193:
                 TSTB
                 BPL           mul_Ap_Bp193
                 NEGB
 .globl mul_An_Bp193
mul_An_Bp193:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end193
 .globl mul_Ap_Bp193
mul_Ap_Bp193:
 .globl mul_An_Bn193
mul_An_Bn193:
                 MUL
 .globl mul_end193
mul_end193:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

                 SUBA   _cosy
; macro call ->                  STORE_A _N01x
                 STA           _N01x
; macro call ->                  A_EQUALS_MUL _cosx, _cosz
                 LDB           _cosz
                 LDA           _cosx
                 BPL           mul_Ap195
                 NEGA
                 TSTB
                 BPL           mul_An_Bp195
                 NEGB
                 BRA           mul_An_Bn195
 .globl mul_Ap195
mul_Ap195:
                 TSTB
                 BPL           mul_Ap_Bp195
                 NEGB
 .globl mul_An_Bp195
mul_An_Bp195:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end195
 .globl mul_Ap_Bp195
mul_Ap_Bp195:
 .globl mul_An_Bn195
mul_An_Bn195:
                 MUL
 .globl mul_end195
mul_end195:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  STORE_A _N01y
                 STA           _N01y
; macro call ->                  A_EQUALS_MUL _N01x, _sinz
                 LDB           _sinz
                 LDA           _N01x
                 BPL           mul_Ap197
                 NEGA
                 TSTB
                 BPL           mul_An_Bp197
                 NEGB
                 BRA           mul_An_Bn197
 .globl mul_Ap197
mul_Ap197:
                 TSTB
                 BPL           mul_Ap_Bp197
                 NEGB
 .globl mul_An_Bp197
mul_An_Bp197:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end197
 .globl mul_Ap_Bp197
mul_Ap_Bp197:
 .globl mul_An_Bn197
mul_An_Bn197:
                 MUL
 .globl mul_end197
mul_end197:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  ADD_A_TO _N01y
                 ADDA          _N01y
; macro call ->                  STORE_A       _N01y
                 STA           _N01y
; macro call ->                  STORE_A_NEG _N01yi
                 NEGA
                 STA           _N01yi
; macro call ->                  A_EQUALS_MUL _N01x, _cosz
                 LDB           _cosz
                 LDA           _N01x
                 BPL           mul_Ap201
                 NEGA
                 TSTB
                 BPL           mul_An_Bp201
                 NEGB
                 BRA           mul_An_Bn201
 .globl mul_Ap201
mul_Ap201:
                 TSTB
                 BPL           mul_Ap_Bp201
                 NEGB
 .globl mul_An_Bp201
mul_An_Bp201:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end201
 .globl mul_Ap_Bp201
mul_Ap_Bp201:
 .globl mul_An_Bn201
mul_An_Bn201:
                 MUL
 .globl mul_end201
mul_end201:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  STORE_A _N01x
                 STA           _N01x
; macro call ->                  A_EQUALS_MUL _cosx, _sinz
                 LDB           _sinz
                 LDA           _cosx
                 BPL           mul_Ap203
                 NEGA
                 TSTB
                 BPL           mul_An_Bp203
                 NEGB
                 BRA           mul_An_Bn203
 .globl mul_Ap203
mul_Ap203:
                 TSTB
                 BPL           mul_Ap_Bp203
                 NEGB
 .globl mul_An_Bp203
mul_An_Bp203:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end203
 .globl mul_Ap_Bp203
mul_Ap_Bp203:
 .globl mul_An_Bn203
mul_An_Bn203:
                 MUL
 .globl mul_end203
mul_end203:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  SUB_A_FROM _N01x
                 NEGA
; macro call ->                  ADD_A_TO      _N01x
                 ADDA          _N01x
; macro call ->                  STORE_A       _N01x
                 STA           _N01x
; macro call ->                  STORE_A_NEG _N01xi
                 NEGA
                 STA           _N01xi
 lda _vectorBits
 .globl noN01
noN01:
 bita #TEST_0_N_1
 lbeq no0N1
; macro call ->                     INIT_0_N_1_A  
; macro call ->                  CALC_0_N_1_A _0N1x, _0N1y, _0N1z, _0N1xi, _0N1yi, _0N1zi
                 LDA _sinx
                 SUBA _cosx
                 STA _0N1z
                 NEGA
                 STA _0N1zi
                 LDA   _sinx
                 SUBA  _cosx
                 STA   _0N1z
                 LDA   _cosx
                 ADDA  _sinx
                 STA   _helper
; macro call ->                  A_EQUALS_MUL _0N1z, _siny
                 LDB           _siny
                 LDA           _0N1z
                 BPL           mul_Ap210
                 NEGA
                 TSTB
                 BPL           mul_An_Bp210
                 NEGB
                 BRA           mul_An_Bn210
 .globl mul_Ap210
mul_Ap210:
                 TSTB
                 BPL           mul_Ap_Bp210
                 NEGB
 .globl mul_An_Bp210
mul_An_Bp210:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end210
 .globl mul_Ap_Bp210
mul_Ap_Bp210:
 .globl mul_An_Bn210
mul_An_Bn210:
                 MUL
 .globl mul_end210
mul_end210:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  STORE_A _0N1x
                 STA           _0N1x
; macro call ->                  A_EQUALS_MUL _helper, _cosz
                 LDB           _cosz
                 LDA           _helper
                 BPL           mul_Ap212
                 NEGA
                 TSTB
                 BPL           mul_An_Bp212
                 NEGB
                 BRA           mul_An_Bn212
 .globl mul_Ap212
mul_Ap212:
                 TSTB
                 BPL           mul_Ap_Bp212
                 NEGB
 .globl mul_An_Bp212
mul_An_Bp212:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end212
 .globl mul_Ap_Bp212
mul_Ap_Bp212:
 .globl mul_An_Bn212
mul_An_Bn212:
                 MUL
 .globl mul_end212
mul_end212:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  STORE_A _0N1y
                 STA           _0N1y
; macro call ->                  A_EQUALS_MUL _0N1x, _sinz
                 LDB           _sinz
                 LDA           _0N1x
                 BPL           mul_Ap214
                 NEGA
                 TSTB
                 BPL           mul_An_Bp214
                 NEGB
                 BRA           mul_An_Bn214
 .globl mul_Ap214
mul_Ap214:
                 TSTB
                 BPL           mul_Ap_Bp214
                 NEGB
 .globl mul_An_Bp214
mul_An_Bp214:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end214
 .globl mul_Ap_Bp214
mul_Ap_Bp214:
 .globl mul_An_Bn214
mul_An_Bn214:
                 MUL
 .globl mul_end214
mul_end214:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  ADD_A_TO _0N1y
                 ADDA          _0N1y
; macro call ->                  STORE_A       _0N1y
                 STA           _0N1y
; macro call ->                  STORE_A_NEG _0N1yi
                 NEGA
                 STA           _0N1yi
; macro call ->                  A_EQUALS_MUL _0N1x, _cosz
                 LDB           _cosz
                 LDA           _0N1x
                 BPL           mul_Ap218
                 NEGA
                 TSTB
                 BPL           mul_An_Bp218
                 NEGB
                 BRA           mul_An_Bn218
 .globl mul_Ap218
mul_Ap218:
                 TSTB
                 BPL           mul_Ap_Bp218
                 NEGB
 .globl mul_An_Bp218
mul_An_Bp218:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end218
 .globl mul_Ap_Bp218
mul_Ap_Bp218:
 .globl mul_An_Bn218
mul_An_Bn218:
                 MUL
 .globl mul_end218
mul_end218:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  STORE_A _0N1x
                 STA           _0N1x
; macro call ->                  A_EQUALS_MUL _helper, _sinz
                 LDB           _sinz
                 LDA           _helper
                 BPL           mul_Ap220
                 NEGA
                 TSTB
                 BPL           mul_An_Bp220
                 NEGB
                 BRA           mul_An_Bn220
 .globl mul_Ap220
mul_Ap220:
                 TSTB
                 BPL           mul_Ap_Bp220
                 NEGB
 .globl mul_An_Bp220
mul_An_Bp220:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end220
 .globl mul_Ap_Bp220
mul_Ap_Bp220:
 .globl mul_An_Bn220
mul_An_Bn220:
                 MUL
 .globl mul_end220
mul_end220:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  SUB_A_FROM _0N1x
                 NEGA
; macro call ->                  ADD_A_TO      _0N1x
                 ADDA          _0N1x
; macro call ->                  STORE_A       _0N1x
                 STA           _0N1x
; macro call ->                  STORE_A_NEG _0N1xi
                 NEGA
                 STA           _0N1xi
 lda _vectorBits
 .globl no0N1
no0N1:
 bita #TEST_N_1_1
 lbeq noN11
; macro call ->                     INIT_N_1_1_A  
; macro call ->                  CALC_N_1_1_A _N11x, _N11y, _N11z, _N11xi, _N11yi, _N11zi
                 LDA _cosx
                 ADDA _sinx
                 STA _N11z
                 NEGA
                 STA _N11zi
                 LDA   _sinx
                 ADDA  _cosx
                 STA   _N11z

                 LDA   _cosx
                 SUBA  _sinx
                 STA   _helper

; macro call ->                  A_EQUALS_MUL _N11z, _siny
                 LDB           _siny
                 LDA           _N11z
                 BPL           mul_Ap227
                 NEGA
                 TSTB
                 BPL           mul_An_Bp227
                 NEGB
                 BRA           mul_An_Bn227
 .globl mul_Ap227
mul_Ap227:
                 TSTB
                 BPL           mul_Ap_Bp227
                 NEGB
 .globl mul_An_Bp227
mul_An_Bp227:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end227
 .globl mul_Ap_Bp227
mul_Ap_Bp227:
 .globl mul_An_Bn227
mul_An_Bn227:
                 MUL
 .globl mul_end227
mul_end227:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

                 SUBA  _cosy
; macro call ->                  STORE_A _N11x
                 STA           _N11x
; macro call ->                  A_EQUALS_MUL _helper, _cosz
                 LDB           _cosz
                 LDA           _helper
                 BPL           mul_Ap229
                 NEGA
                 TSTB
                 BPL           mul_An_Bp229
                 NEGB
                 BRA           mul_An_Bn229
 .globl mul_Ap229
mul_Ap229:
                 TSTB
                 BPL           mul_Ap_Bp229
                 NEGB
 .globl mul_An_Bp229
mul_An_Bp229:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end229
 .globl mul_Ap_Bp229
mul_Ap_Bp229:
 .globl mul_An_Bn229
mul_An_Bn229:
                 MUL
 .globl mul_end229
mul_end229:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  STORE_A _N11y
                 STA           _N11y
; macro call ->                  A_EQUALS_MUL _N11x, _sinz
                 LDB           _sinz
                 LDA           _N11x
                 BPL           mul_Ap231
                 NEGA
                 TSTB
                 BPL           mul_An_Bp231
                 NEGB
                 BRA           mul_An_Bn231
 .globl mul_Ap231
mul_Ap231:
                 TSTB
                 BPL           mul_Ap_Bp231
                 NEGB
 .globl mul_An_Bp231
mul_An_Bp231:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end231
 .globl mul_Ap_Bp231
mul_Ap_Bp231:
 .globl mul_An_Bn231
mul_An_Bn231:
                 MUL
 .globl mul_end231
mul_end231:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  ADD_A_TO _N11y
                 ADDA          _N11y
; macro call ->                  STORE_A       _N11y
                 STA           _N11y
; macro call ->                  STORE_A_NEG _N11yi
                 NEGA
                 STA           _N11yi
; macro call ->                  A_EQUALS_MUL _N11x, _cosz
                 LDB           _cosz
                 LDA           _N11x
                 BPL           mul_Ap235
                 NEGA
                 TSTB
                 BPL           mul_An_Bp235
                 NEGB
                 BRA           mul_An_Bn235
 .globl mul_Ap235
mul_Ap235:
                 TSTB
                 BPL           mul_Ap_Bp235
                 NEGB
 .globl mul_An_Bp235
mul_An_Bp235:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end235
 .globl mul_Ap_Bp235
mul_Ap_Bp235:
 .globl mul_An_Bn235
mul_An_Bn235:
                 MUL
 .globl mul_end235
mul_end235:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  STORE_A _N11x
                 STA           _N11x
; macro call ->                  A_EQUALS_MUL _helper, _sinz
                 LDB           _sinz
                 LDA           _helper
                 BPL           mul_Ap237
                 NEGA
                 TSTB
                 BPL           mul_An_Bp237
                 NEGB
                 BRA           mul_An_Bn237
 .globl mul_Ap237
mul_Ap237:
                 TSTB
                 BPL           mul_Ap_Bp237
                 NEGB
 .globl mul_An_Bp237
mul_An_Bp237:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end237
 .globl mul_Ap_Bp237
mul_Ap_Bp237:
 .globl mul_An_Bn237
mul_An_Bn237:
                 MUL
 .globl mul_end237
mul_end237:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  SUB_A_FROM _N11x
                 NEGA
; macro call ->                  ADD_A_TO      _N11x
                 ADDA          _N11x
; macro call ->                  STORE_A       _N11x
                 STA           _N11x
; macro call ->                  STORE_A_NEG _N11xi
                 NEGA
                 STA           _N11xi
 lda _vectorBits
 .globl noN11
noN11:
 bita #TEST_1_N_1
 lbeq no1N1
; macro call ->                     INIT_1_N_1_A  
; macro call ->                  CALC_1_N_1_A _1N1x, _1N1y, _1N1z, _1N1xi, _1N1yi, _1N1zi
                 LDA _sinx
                 SUBA _cosx
                 STA _1N1z
                 NEGA
                 STA _1N1zi
                 LDA   _sinx
                 SUBA  _cosx
                 STA   _1N1z

                 LDA   _cosx
                 ADDA  _sinx
                 STA   _helper

; macro call ->                  A_EQUALS_MUL _1N1z, _siny
                 LDB           _siny
                 LDA           _1N1z
                 BPL           mul_Ap244
                 NEGA
                 TSTB
                 BPL           mul_An_Bp244
                 NEGB
                 BRA           mul_An_Bn244
 .globl mul_Ap244
mul_Ap244:
                 TSTB
                 BPL           mul_Ap_Bp244
                 NEGB
 .globl mul_An_Bp244
mul_An_Bp244:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end244
 .globl mul_Ap_Bp244
mul_Ap_Bp244:
 .globl mul_An_Bn244
mul_An_Bn244:
                 MUL
 .globl mul_end244
mul_end244:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

                 ADDA  _cosy
; macro call ->                  STORE_A _1N1x
                 STA           _1N1x
; macro call ->                  A_EQUALS_MUL _helper, _cosz
                 LDB           _cosz
                 LDA           _helper
                 BPL           mul_Ap246
                 NEGA
                 TSTB
                 BPL           mul_An_Bp246
                 NEGB
                 BRA           mul_An_Bn246
 .globl mul_Ap246
mul_Ap246:
                 TSTB
                 BPL           mul_Ap_Bp246
                 NEGB
 .globl mul_An_Bp246
mul_An_Bp246:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end246
 .globl mul_Ap_Bp246
mul_Ap_Bp246:
 .globl mul_An_Bn246
mul_An_Bn246:
                 MUL
 .globl mul_end246
mul_end246:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  STORE_A _1N1y
                 STA           _1N1y
; macro call ->                  A_EQUALS_MUL _1N1x, _sinz
                 LDB           _sinz
                 LDA           _1N1x
                 BPL           mul_Ap248
                 NEGA
                 TSTB
                 BPL           mul_An_Bp248
                 NEGB
                 BRA           mul_An_Bn248
 .globl mul_Ap248
mul_Ap248:
                 TSTB
                 BPL           mul_Ap_Bp248
                 NEGB
 .globl mul_An_Bp248
mul_An_Bp248:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end248
 .globl mul_Ap_Bp248
mul_Ap_Bp248:
 .globl mul_An_Bn248
mul_An_Bn248:
                 MUL
 .globl mul_end248
mul_end248:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  ADD_A_TO _1N1y
                 ADDA          _1N1y
; macro call ->                  STORE_A       _1N1y
                 STA           _1N1y
; macro call ->                  STORE_A_NEG _1N1yi
                 NEGA
                 STA           _1N1yi
; macro call ->                  A_EQUALS_MUL _1N1x, _cosz
                 LDB           _cosz
                 LDA           _1N1x
                 BPL           mul_Ap252
                 NEGA
                 TSTB
                 BPL           mul_An_Bp252
                 NEGB
                 BRA           mul_An_Bn252
 .globl mul_Ap252
mul_Ap252:
                 TSTB
                 BPL           mul_Ap_Bp252
                 NEGB
 .globl mul_An_Bp252
mul_An_Bp252:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end252
 .globl mul_Ap_Bp252
mul_Ap_Bp252:
 .globl mul_An_Bn252
mul_An_Bn252:
                 MUL
 .globl mul_end252
mul_end252:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  STORE_A _1N1x
                 STA           _1N1x
; macro call ->                  A_EQUALS_MUL _helper, _sinz
                 LDB           _sinz
                 LDA           _helper
                 BPL           mul_Ap254
                 NEGA
                 TSTB
                 BPL           mul_An_Bp254
                 NEGB
                 BRA           mul_An_Bn254
 .globl mul_Ap254
mul_Ap254:
                 TSTB
                 BPL           mul_Ap_Bp254
                 NEGB
 .globl mul_An_Bp254
mul_An_Bp254:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end254
 .globl mul_Ap_Bp254
mul_Ap_Bp254:
 .globl mul_An_Bn254
mul_An_Bn254:
                 MUL
 .globl mul_end254
mul_end254:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  SUB_A_FROM _1N1x
                 NEGA
; macro call ->                  ADD_A_TO      _1N1x
                 ADDA          _1N1x
; macro call ->                  STORE_A       _1N1x
                 STA           _1N1x
; macro call ->                  STORE_A_NEG _1N1xi
                 NEGA
                 STA           _1N1xi
 lda _vectorBits
 .globl no1N1
no1N1:
 bita #TEST_1_1_N
 lbeq no11N
; macro call ->                     INIT_1_1_N_A  
; macro call ->                  CALC_1_1_N_A _11Nx, _11Ny, _11Nz, _11Nxi, _11Nyi, _11Nzi
                 LDA _cosx
                 SUBA _sinx
                 STA _11Nz
                 NEGA
                 STA _11Nzi
                 LDA   _cosx
                 SUBA  _sinx
                 STA   _11Nz

                 LDA   _cosx
                 NEGA
                 SUBA  _sinx
                 STA   _helper

; macro call ->                  A_EQUALS_MUL _11Nz, _siny
                 LDB           _siny
                 LDA           _11Nz
                 BPL           mul_Ap261
                 NEGA
                 TSTB
                 BPL           mul_An_Bp261
                 NEGB
                 BRA           mul_An_Bn261
 .globl mul_Ap261
mul_Ap261:
                 TSTB
                 BPL           mul_Ap_Bp261
                 NEGB
 .globl mul_An_Bp261
mul_An_Bp261:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end261
 .globl mul_Ap_Bp261
mul_Ap_Bp261:
 .globl mul_An_Bn261
mul_An_Bn261:
                 MUL
 .globl mul_end261
mul_end261:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

                 ADDA  _cosy
; macro call ->                  STORE_A _11Nx
                 STA           _11Nx
; macro call ->                  A_EQUALS_MUL _helper, _cosz
                 LDB           _cosz
                 LDA           _helper
                 BPL           mul_Ap263
                 NEGA
                 TSTB
                 BPL           mul_An_Bp263
                 NEGB
                 BRA           mul_An_Bn263
 .globl mul_Ap263
mul_Ap263:
                 TSTB
                 BPL           mul_Ap_Bp263
                 NEGB
 .globl mul_An_Bp263
mul_An_Bp263:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end263
 .globl mul_Ap_Bp263
mul_Ap_Bp263:
 .globl mul_An_Bn263
mul_An_Bn263:
                 MUL
 .globl mul_end263
mul_end263:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  STORE_A _11Ny
                 STA           _11Ny
; macro call ->                  A_EQUALS_MUL _11Nx, _sinz
                 LDB           _sinz
                 LDA           _11Nx
                 BPL           mul_Ap265
                 NEGA
                 TSTB
                 BPL           mul_An_Bp265
                 NEGB
                 BRA           mul_An_Bn265
 .globl mul_Ap265
mul_Ap265:
                 TSTB
                 BPL           mul_Ap_Bp265
                 NEGB
 .globl mul_An_Bp265
mul_An_Bp265:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end265
 .globl mul_Ap_Bp265
mul_Ap_Bp265:
 .globl mul_An_Bn265
mul_An_Bn265:
                 MUL
 .globl mul_end265
mul_end265:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  ADD_A_TO _11Ny
                 ADDA          _11Ny
; macro call ->                  STORE_A       _11Ny
                 STA           _11Ny
; macro call ->                  STORE_A_NEG _11Nyi
                 NEGA
                 STA           _11Nyi
; macro call ->                  A_EQUALS_MUL _11Nx, _cosz
                 LDB           _cosz
                 LDA           _11Nx
                 BPL           mul_Ap269
                 NEGA
                 TSTB
                 BPL           mul_An_Bp269
                 NEGB
                 BRA           mul_An_Bn269
 .globl mul_Ap269
mul_Ap269:
                 TSTB
                 BPL           mul_Ap_Bp269
                 NEGB
 .globl mul_An_Bp269
mul_An_Bp269:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end269
 .globl mul_Ap_Bp269
mul_Ap_Bp269:
 .globl mul_An_Bn269
mul_An_Bn269:
                 MUL
 .globl mul_end269
mul_end269:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  STORE_A _11Nx
                 STA           _11Nx
; macro call ->                  A_EQUALS_MUL _helper, _sinz
                 LDB           _sinz
                 LDA           _helper
                 BPL           mul_Ap271
                 NEGA
                 TSTB
                 BPL           mul_An_Bp271
                 NEGB
                 BRA           mul_An_Bn271
 .globl mul_Ap271
mul_Ap271:
                 TSTB
                 BPL           mul_Ap_Bp271
                 NEGB
 .globl mul_An_Bp271
mul_An_Bp271:
                 MUL
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end271
 .globl mul_Ap_Bp271
mul_Ap_Bp271:
 .globl mul_An_Bn271
mul_An_Bn271:
                 MUL
 .globl mul_end271
mul_end271:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

; macro call ->                  SUB_A_FROM _11Nx
                 NEGA
; macro call ->                  ADD_A_TO      _11Nx
                 ADDA          _11Nx
; macro call ->                  STORE_A       _11Nx
                 STA           _11Nx
; macro call ->                  STORE_A_NEG _11Nxi
                 NEGA
                 STA           _11Nxi
 .globl no11N
no11N:

				rts

