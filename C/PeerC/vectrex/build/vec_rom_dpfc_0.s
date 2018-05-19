
;;; gcc for m6809 : Feb 15 2016 21:40:10
;;; 4.3.6 (gcc6809)
;;; ABI version 1
;;; -mint8
	.module	vec_rom_dpfc_0.c
;----- asm -----
	.bank page_00 (BASE=0x0000,SIZE=0x0100)
	.area direct (OVR,BANK=page_00)
	
;--- end asm ---
	.globl _dp_Vec_Snd_shadow
	.area	direct
_dp_Vec_Snd_shadow:
	.word	0	;skip space 109
	.word	0	;skip space 107
	.word	0	;skip space 105
	.word	0	;skip space 103
	.word	0	;skip space 101
	.word	0	;skip space 99
	.word	0	;skip space 97
	.word	0	;skip space 95
	.word	0	;skip space 93
	.word	0	;skip space 91
	.word	0	;skip space 89
	.word	0	;skip space 87
	.word	0	;skip space 85
	.word	0	;skip space 83
	.word	0	;skip space 81
	.word	0	;skip space 79
	.word	0	;skip space 77
	.word	0	;skip space 75
	.word	0	;skip space 73
	.word	0	;skip space 71
	.word	0	;skip space 69
	.word	0	;skip space 67
	.word	0	;skip space 65
	.word	0	;skip space 63
	.word	0	;skip space 61
	.word	0	;skip space 59
	.word	0	;skip space 57
	.word	0	;skip space 55
	.word	0	;skip space 53
	.word	0	;skip space 51
	.word	0	;skip space 49
	.word	0	;skip space 47
	.word	0	;skip space 45
	.word	0	;skip space 43
	.word	0	;skip space 41
	.word	0	;skip space 39
	.word	0	;skip space 37
	.word	0	;skip space 35
	.word	0	;skip space 33
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
	.globl _dp_Vec_Sine_Table
_dp_Vec_Sine_Table:
	.word	0	;skip space 16
	.word	0	;skip space 14
	.word	0	;skip space 12
	.word	0	;skip space 10
	.word	0	;skip space 8
	.word	0	;skip space 6
	.word	0	;skip space 4
	.word	0	;skip space 2
	.globl _dp_Vec_Cosine_Table
_dp_Vec_Cosine_Table:
	.word	0	;skip space 16
	.word	0	;skip space 14
	.word	0	;skip space 12
	.word	0	;skip space 10
	.word	0	;skip space 8
	.word	0	;skip space 6
	.word	0	;skip space 4
	.word	0	;skip space 2
	.globl _dp_Vec_Note_Table
_dp_Vec_Note_Table:
	.byte	0	;skip space
