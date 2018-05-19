
;;; gcc for m6809 : Feb 15 2016 21:40:10
;;; 4.3.6 (gcc6809)
;;; ABI version 1
;;; -mint8
	.module	vec_ram_dpc8_1.c
;----- asm -----
	.bank page_00 (BASE=0x0000,SIZE=0x0100)
	.area direct (OVR,BANK=page_00)
	
;--- end asm ---
	.globl _dp_Vec_Snd_Shadow
	.area	direct
_dp_Vec_Snd_Shadow:
	.word	0	;skip space 31
	.word	0	;skip space 29
	.word	0	;skip space 27
	.word	0	;skip space 25
	.word	0	;skip space 23
	.word	0	;skip space 21
	.word	0	;skip space 19
	.word	0	;skip space 17
	.word	0	;skip space 15
	.word	0	;skip space 13
	.word	0	;skip space 11
	.word	0	;skip space 9
	.word	0	;skip space 7
	.word	0	;skip space 5
	.word	0	;skip space 3
	.byte	0	;skip space
	.globl _dp_Vec_Joy_Mux_1_X
_dp_Vec_Joy_Mux_1_X:
	.byte	0	;skip space
	.globl _dp_Vec_Joy_Mux_1_Y
_dp_Vec_Joy_Mux_1_Y:
	.byte	0	;skip space
	.globl _dp_Vec_Joy_Mux_2_X
_dp_Vec_Joy_Mux_2_X:
	.byte	0	;skip space
	.globl _dp_Vec_Joy_Mux_2_Y
_dp_Vec_Joy_Mux_2_Y:
	.word	0	;skip space 3
	.byte	0	;skip space
	.globl _dp_Vec_Loop_Count_hi
_dp_Vec_Loop_Count_hi:
	.byte	0	;skip space
	.globl _dp_Vec_Loop_Count_lo
_dp_Vec_Loop_Count_lo:
	.word	0	;skip space 4
	.word	0	;skip space 2
	.globl _dp_Vec_Text_Height
_dp_Vec_Text_Height:
	.byte	0	;skip space
	.globl _dp_Vec_Text_Width
_dp_Vec_Text_Width:
	.word	0	;skip space 3
	.byte	0	;skip space
	.globl _dp_Vec_Counter_1
_dp_Vec_Counter_1:
	.byte	0	;skip space
	.globl _dp_Vec_Counter_2
_dp_Vec_Counter_2:
	.byte	0	;skip space
	.globl _dp_Vec_Counter_3
_dp_Vec_Counter_3:
	.byte	0	;skip space
	.globl _dp_Vec_Counter_4
_dp_Vec_Counter_4:
	.byte	0	;skip space
	.globl _dp_Vec_Counter_5
_dp_Vec_Counter_5:
	.byte	0	;skip space
	.globl _dp_Vec_Counter_6
_dp_Vec_Counter_6:
	.word	0	;skip space 6
	.word	0	;skip space 4
	.word	0	;skip space 2
	.globl _dp_Vec_XXX_00
_dp_Vec_XXX_00:
	.word	0	;skip space 2
	.globl _dp_Vec_XXX_01
_dp_Vec_XXX_01:
	.word	0	;skip space 2
	.globl _dp_Vec_Rfrsh_lo
_dp_Vec_Rfrsh_lo:
	.byte	0	;skip space
	.globl _dp_Vec_Rfrsh_hi
_dp_Vec_Rfrsh_hi:
	.word	0	;skip space 17
	.word	0	;skip space 15
	.word	0	;skip space 13
	.word	0	;skip space 11
	.word	0	;skip space 9
	.word	0	;skip space 7
	.word	0	;skip space 5
	.word	0	;skip space 3
	.byte	0	;skip space
	.globl _dp_Vec_Max_Players
_dp_Vec_Max_Players:
	.byte	0	;skip space
	.globl _dp_Vec_Max_Games
_dp_Vec_Max_Games:
	.word	0	;skip space 3
	.byte	0	;skip space
	.globl _dp_Vec_Expl_ChanA
_dp_Vec_Expl_ChanA:
	.byte	0	;skip space
	.globl _dp_Vec_Expl_Chans
_dp_Vec_Expl_Chans:
	.word	0	;skip space 4
	.word	0	;skip space 2
	.globl _dp_Vec_Music_Twang
_dp_Vec_Music_Twang:
	.word	0	;skip space 6
	.word	0	;skip space 4
	.word	0	;skip space 2
	.globl _dp_Vec_ADSR_Timers
_dp_Vec_ADSR_Timers:
	.word	0	;skip space 3
	.byte	0	;skip space
	.globl _dp_Vec_Music_Freq
_dp_Vec_Music_Freq:
	.word	0	;skip space 28
	.word	0	;skip space 26
	.word	0	;skip space 24
	.word	0	;skip space 22
	.word	0	;skip space 20
	.word	0	;skip space 18
	.word	0	;skip space 16
	.word	0	;skip space 14
	.word	0	;skip space 12
	.word	0	;skip space 10
	.word	0	;skip space 8
	.word	0	;skip space 6
	.word	0	;skip space 4
	.word	0	;skip space 2
	.globl _dp_Vec_Random_Seed
_dp_Vec_Random_Seed:
	.byte	0	;skip space
