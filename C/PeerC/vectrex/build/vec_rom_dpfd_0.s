
;;; gcc for m6809 : Feb 15 2016 21:40:10
;;; 4.3.6 (gcc6809)
;;; ABI version 1
;;; -mint8
	.module	vec_rom_dpfd_0.c
;----- asm -----
	.bank page_00 (BASE=0x0000,SIZE=0x0100)
	.area direct (OVR,BANK=page_00)
	
;--- end asm ---
	.globl _dp_Vec_Snd_shadow
	.area	direct
_dp_Vec_Snd_shadow:
	.word	0	;skip space 13
	.word	0	;skip space 11
	.word	0	;skip space 9
	.word	0	;skip space 7
	.word	0	;skip space 5
	.word	0	;skip space 3
	.byte	0	;skip space
	.globl _dp_Vec_Music_1
_dp_Vec_Music_1:
	.word	0	;skip space 16
	.word	0	;skip space 14
	.word	0	;skip space 12
	.word	0	;skip space 10
	.word	0	;skip space 8
	.word	0	;skip space 6
	.word	0	;skip space 4
	.word	0	;skip space 2
	.globl _dp_Vec_Music_2
_dp_Vec_Music_2:
	.word	0	;skip space 76
	.word	0	;skip space 74
	.word	0	;skip space 72
	.word	0	;skip space 70
	.word	0	;skip space 68
	.word	0	;skip space 66
	.word	0	;skip space 64
	.word	0	;skip space 62
	.word	0	;skip space 60
	.word	0	;skip space 58
	.word	0	;skip space 56
	.word	0	;skip space 54
	.word	0	;skip space 52
	.word	0	;skip space 50
	.word	0	;skip space 48
	.word	0	;skip space 46
	.word	0	;skip space 44
	.word	0	;skip space 42
	.word	0	;skip space 40
	.word	0	;skip space 38
	.word	0	;skip space 36
	.word	0	;skip space 34
	.word	0	;skip space 32
	.word	0	;skip space 30
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
	.globl _dp_Vec_ADSR_FADE0
_dp_Vec_ADSR_FADE0:
	.word	0	;skip space 16
	.word	0	;skip space 14
	.word	0	;skip space 12
	.word	0	;skip space 10
	.word	0	;skip space 8
	.word	0	;skip space 6
	.word	0	;skip space 4
	.word	0	;skip space 2
	.globl _dp_Vec_TWANG_VIBE0
_dp_Vec_TWANG_VIBE0:
	.word	0	;skip space 8
	.word	0	;skip space 6
	.word	0	;skip space 4
	.word	0	;skip space 2
	.globl _dp_Vec_Music_3
_dp_Vec_Music_3:
	.word	0	;skip space 66
	.word	0	;skip space 64
	.word	0	;skip space 62
	.word	0	;skip space 60
	.word	0	;skip space 58
	.word	0	;skip space 56
	.word	0	;skip space 54
	.word	0	;skip space 52
	.word	0	;skip space 50
	.word	0	;skip space 48
	.word	0	;skip space 46
	.word	0	;skip space 44
	.word	0	;skip space 42
	.word	0	;skip space 40
	.word	0	;skip space 38
	.word	0	;skip space 36
	.word	0	;skip space 34
	.word	0	;skip space 32
	.word	0	;skip space 30
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
	.globl _dp_Vec_ADSR_FADE12
_dp_Vec_ADSR_FADE12:
	.word	0	;skip space 16
	.word	0	;skip space 14
	.word	0	;skip space 12
	.word	0	;skip space 10
	.word	0	;skip space 8
	.word	0	;skip space 6
	.word	0	;skip space 4
	.word	0	;skip space 2
	.globl _dp_Vec_Music_4
_dp_Vec_Music_4:
	.byte	0	;skip space
