
;;; gcc for m6809 : Feb 15 2016 21:40:10
;;; 4.3.6 (gcc6809)
;;; ABI version 1
;;; -mint8
	.module	vec_ram_0xc8_0.c
;----- asm -----
	.bank page_c8 (BASE=0xc800,SIZE=0x0080)
	.area .dpc8 (OVR,BANK=page_c8)
	
;--- end asm ---
	.globl _Vec_Snd_shadow
	.area	.dpc8
_Vec_Snd_shadow:
	.word	0	;skip space 15
	.word	0	;skip space 13
	.word	0	;skip space 11
	.word	0	;skip space 9
	.word	0	;skip space 7
	.word	0	;skip space 5
	.word	0	;skip space 3
	.byte	0	;skip space
	.globl _Vec_Btn_State
_Vec_Btn_State:
	.byte	0	;skip space
	.globl _Vec_Prev_Btns
_Vec_Prev_Btns:
	.byte	0	;skip space
	.globl _Vec_Buttons
_Vec_Buttons:
	.byte	0	;skip space
	.globl _Vec_Button_1_1
_Vec_Button_1_1:
	.byte	0	;skip space
	.globl _Vec_Button_1_2
_Vec_Button_1_2:
	.byte	0	;skip space
	.globl _Vec_Button_1_3
_Vec_Button_1_3:
	.byte	0	;skip space
	.globl _Vec_Button_1_4
_Vec_Button_1_4:
	.byte	0	;skip space
	.globl _Vec_Button_2_1
_Vec_Button_2_1:
	.byte	0	;skip space
	.globl _Vec_Button_2_2
_Vec_Button_2_2:
	.byte	0	;skip space
	.globl _Vec_Button_2_3
_Vec_Button_2_3:
	.byte	0	;skip space
	.globl _Vec_Button_2_4
_Vec_Button_2_4:
	.byte	0	;skip space
	.globl _Vec_Joy_Resltn
_Vec_Joy_Resltn:
	.byte	0	;skip space
	.globl _Vec_Joy_1_X
_Vec_Joy_1_X:
	.byte	0	;skip space
	.globl _Vec_Joy_1_Y
_Vec_Joy_1_Y:
	.byte	0	;skip space
	.globl _Vec_Joy_2_X
_Vec_Joy_2_X:
	.byte	0	;skip space
	.globl _Vec_Joy_2_Y
_Vec_Joy_2_Y:
	.byte	0	;skip space
	.globl _Vec_Joy_mux
_Vec_Joy_mux:
	.word	0	;skip space 4
	.word	0	;skip space 2
	.globl _Vec_Misc_Count
_Vec_Misc_Count:
	.byte	0	;skip space
	.globl _Vec_0Ref_Enable
_Vec_0Ref_Enable:
	.byte	0	;skip space
	.globl _Vec_Loop_Count
_Vec_Loop_Count:
	.word	0	;skip space 2
	.globl _Vec_Brightness
_Vec_Brightness:
	.byte	0	;skip space
	.globl _Vec_Dot_Dwell
_Vec_Dot_Dwell:
	.byte	0	;skip space
	.globl _Vec_Pattern
_Vec_Pattern:
	.byte	0	;skip space
	.globl _Vec_Text_HW
_Vec_Text_HW:
	.word	0	;skip space 2
	.globl _Vec_Str_Ptr
_Vec_Str_Ptr:
	.word	0	;skip space 2
	.globl _Vec_counters
_Vec_counters:
	.word	0	;skip space 6
	.word	0	;skip space 4
	.word	0	;skip space 2
	.globl _Vec_RiseRun_Tmp
_Vec_RiseRun_Tmp:
	.word	0	;skip space 2
	.globl _Vec_Angle
_Vec_Angle:
	.byte	0	;skip space
	.globl _Vec_Run_Index
_Vec_Run_Index:
	.word	0	;skip space 2
	.globl _Vec_Rise_Index
_Vec_Rise_Index:
	.word	0	;skip space 2
	.globl _Vec_RiseRun_Len
_Vec_RiseRun_Len:
	.byte	0	;skip space
	.globl _Vec_XXX_02
_Vec_XXX_02:
	.byte	0	;skip space
	.globl _Vec_Rfrsh
_Vec_Rfrsh:
	.word	0	;skip space 2
	.globl _Vec_Music_Work
_Vec_Music_Work:
	.word	0	;skip space 3
	.byte	0	;skip space
	.globl _Vec_Music_Wk_A
_Vec_Music_Wk_A:
	.byte	0	;skip space
	.globl _Vec_XXX_03
_Vec_XXX_03:
	.byte	0	;skip space
	.globl _Vec_XXX_04
_Vec_XXX_04:
	.byte	0	;skip space
	.globl _Vec_Music_Wk_7
_Vec_Music_Wk_7:
	.byte	0	;skip space
	.globl _Vec_Music_Wk_6
_Vec_Music_Wk_6:
	.byte	0	;skip space
	.globl _Vec_Music_Wk_5
_Vec_Music_Wk_5:
	.byte	0	;skip space
	.globl _Vec_XXX_05
_Vec_XXX_05:
	.byte	0	;skip space
	.globl _Vec_XXX_06
_Vec_XXX_06:
	.byte	0	;skip space
	.globl _Vec_XXX_07
_Vec_XXX_07:
	.byte	0	;skip space
	.globl _Vec_Music_Wk_1
_Vec_Music_Wk_1:
	.byte	0	;skip space
	.globl _Vec_XXX_08
_Vec_XXX_08:
	.byte	0	;skip space
	.globl _Vec_Freq_Table
_Vec_Freq_Table:
	.word	0	;skip space 2
	.globl _Vec_ADSR_Table
_Vec_ADSR_Table:
	.word	0	;skip space 2
	.globl _Vec_Twang_Table
_Vec_Twang_Table:
	.word	0	;skip space 2
	.globl _Vec_Music_Ptr
_Vec_Music_Ptr:
	.word	0	;skip space 2
	.globl _Vec_Music_Chan
_Vec_Music_Chan:
	.byte	0	;skip space
	.globl _Vec_Music_Flag
_Vec_Music_Flag:
	.byte	0	;skip space
	.globl _Vec_Duration
_Vec_Duration:
	.byte	0	;skip space
	.globl _Vec_Expl_1
_Vec_Expl_1:
	.byte	0	;skip space
	.globl _Vec_Expl_2
_Vec_Expl_2:
	.byte	0	;skip space
	.globl _Vec_Expl_3
_Vec_Expl_3:
	.byte	0	;skip space
	.globl _Vec_Expl_4
_Vec_Expl_4:
	.byte	0	;skip space
	.globl _Vec_Expl_Chan
_Vec_Expl_Chan:
	.byte	0	;skip space
	.globl _Vec_Expl_ChanB
_Vec_Expl_ChanB:
	.byte	0	;skip space
	.globl _Vec_ADSR_timers
_Vec_ADSR_timers:
	.word	0	;skip space 3
	.byte	0	;skip space
	.globl _Vec_Music_freq
_Vec_Music_freq:
	.word	0	;skip space 6
	.word	0	;skip space 4
	.word	0	;skip space 2
	.globl _Vec_Expl_Flag
_Vec_Expl_Flag:
	.byte	0	;skip space
	.globl _Vec_XXX_10
_Vec_XXX_10:
	.byte	0	;skip space
	.globl _Vec_XXX_11
_Vec_XXX_11:
	.byte	0	;skip space
	.globl _Vec_XXX_12
_Vec_XXX_12:
	.byte	0	;skip space
	.globl _Vec_XXX_13
_Vec_XXX_13:
	.byte	0	;skip space
	.globl _Vec_XXX_14
_Vec_XXX_14:
	.byte	0	;skip space
	.globl _Vec_XXX_15
_Vec_XXX_15:
	.byte	0	;skip space
	.globl _Vec_XXX_16
_Vec_XXX_16:
	.byte	0	;skip space
	.globl _Vec_XXX_17
_Vec_XXX_17:
	.byte	0	;skip space
	.globl _Vec_XXX_18
_Vec_XXX_18:
	.byte	0	;skip space
	.globl _Vec_XXX_19
_Vec_XXX_19:
	.byte	0	;skip space
	.globl _Vec_XXX_20
_Vec_XXX_20:
	.byte	0	;skip space
	.globl _Vec_XXX_21
_Vec_XXX_21:
	.byte	0	;skip space
	.globl _Vec_XXX_22
_Vec_XXX_22:
	.byte	0	;skip space
	.globl _Vec_XXX_23
_Vec_XXX_23:
	.byte	0	;skip space
	.globl _Vec_XXX_24
_Vec_XXX_24:
	.byte	0	;skip space
	.globl _Vec_Expl_Timer
_Vec_Expl_Timer:
	.byte	0	;skip space
	.globl _Vec_XXX_25
_Vec_XXX_25:
	.byte	0	;skip space
	.globl _Vec_Num_Players
_Vec_Num_Players:
	.byte	0	;skip space
	.globl _Vec_Num_Game
_Vec_Num_Game:
	.byte	0	;skip space
	.globl _Vec_Seed_Ptr
_Vec_Seed_Ptr:
	.word	0	;skip space 2
	.globl _Vec_Random_Seed0
_Vec_Random_Seed0:
	.byte	0	;skip space
	.globl _Vec_Random_Seed1
_Vec_Random_Seed1:
	.byte	0	;skip space
	.globl _Vec_Random_Seed2
_Vec_Random_Seed2:
	.byte	0	;skip space
