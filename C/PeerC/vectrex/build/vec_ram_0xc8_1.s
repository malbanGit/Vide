
;;; gcc for m6809 : Feb 15 2016 21:40:10
;;; 4.3.6 (gcc6809)
;;; ABI version 1
;;; -mint8
	.module	vec_ram_0xc8_1.c
;----- asm -----
	.bank page_c8 (BASE=0xc800,SIZE=0x0080)
	.area .dpc8 (OVR,BANK=page_c8)
	
;--- end asm ---
	.globl _Vec_Snd_Shadow
	.area	.dpc8
_Vec_Snd_Shadow:
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
	.globl _Vec_Joy_Mux_1_X
_Vec_Joy_Mux_1_X:
	.byte	0	;skip space
	.globl _Vec_Joy_Mux_1_Y
_Vec_Joy_Mux_1_Y:
	.byte	0	;skip space
	.globl _Vec_Joy_Mux_2_X
_Vec_Joy_Mux_2_X:
	.byte	0	;skip space
	.globl _Vec_Joy_Mux_2_Y
_Vec_Joy_Mux_2_Y:
	.word	0	;skip space 3
	.byte	0	;skip space
	.globl _Vec_Loop_Count_hi
_Vec_Loop_Count_hi:
	.byte	0	;skip space
	.globl _Vec_Loop_Count_lo
_Vec_Loop_Count_lo:
	.word	0	;skip space 4
	.word	0	;skip space 2
	.globl _Vec_Text_Height
_Vec_Text_Height:
	.byte	0	;skip space
	.globl _Vec_Text_Width
_Vec_Text_Width:
	.word	0	;skip space 3
	.byte	0	;skip space
	.globl _Vec_Counter_1
_Vec_Counter_1:
	.byte	0	;skip space
	.globl _Vec_Counter_2
_Vec_Counter_2:
	.byte	0	;skip space
	.globl _Vec_Counter_3
_Vec_Counter_3:
	.byte	0	;skip space
	.globl _Vec_Counter_4
_Vec_Counter_4:
	.byte	0	;skip space
	.globl _Vec_Counter_5
_Vec_Counter_5:
	.byte	0	;skip space
	.globl _Vec_Counter_6
_Vec_Counter_6:
	.word	0	;skip space 6
	.word	0	;skip space 4
	.word	0	;skip space 2
	.globl _Vec_XXX_00
_Vec_XXX_00:
	.word	0	;skip space 2
	.globl _Vec_XXX_01
_Vec_XXX_01:
	.word	0	;skip space 2
	.globl _Vec_Rfrsh_lo
_Vec_Rfrsh_lo:
	.byte	0	;skip space
	.globl _Vec_Rfrsh_hi
_Vec_Rfrsh_hi:
	.word	0	;skip space 17
	.word	0	;skip space 15
	.word	0	;skip space 13
	.word	0	;skip space 11
	.word	0	;skip space 9
	.word	0	;skip space 7
	.word	0	;skip space 5
	.word	0	;skip space 3
	.byte	0	;skip space
	.globl _Vec_Max_Players
_Vec_Max_Players:
	.byte	0	;skip space
	.globl _Vec_Max_Games
_Vec_Max_Games:
	.word	0	;skip space 3
	.byte	0	;skip space
	.globl _Vec_Expl_ChanA
_Vec_Expl_ChanA:
	.byte	0	;skip space
	.globl _Vec_Expl_Chans
_Vec_Expl_Chans:
	.word	0	;skip space 4
	.word	0	;skip space 2
	.globl _Vec_Music_Twang
_Vec_Music_Twang:
	.word	0	;skip space 6
	.word	0	;skip space 4
	.word	0	;skip space 2
	.globl _Vec_ADSR_Timers
_Vec_ADSR_Timers:
	.word	0	;skip space 3
	.byte	0	;skip space
	.globl _Vec_Music_Freq
_Vec_Music_Freq:
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
	.globl _Vec_Random_Seed
_Vec_Random_Seed:
	.byte	0	;skip space
