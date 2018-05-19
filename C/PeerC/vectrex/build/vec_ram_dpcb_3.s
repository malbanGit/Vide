
;;; gcc for m6809 : Feb 15 2016 21:40:10
;;; 4.3.6 (gcc6809)
;;; ABI version 1
;;; -mint8
	.module	vec_ram_dpcb_3.c
;----- asm -----
	.bank page_00 (BASE=0x0000,SIZE=0x0100)
	.area direct (OVR,BANK=page_00)
	
;--- end asm ---
	.globl _dp_Vec_Snd_shadow
	.area	direct
_dp_Vec_Snd_shadow:
	.word	0	;skip space 242
	.word	0	;skip space 240
	.word	0	;skip space 238
	.word	0	;skip space 236
	.word	0	;skip space 234
	.word	0	;skip space 232
	.word	0	;skip space 230
	.word	0	;skip space 228
	.word	0	;skip space 226
	.word	0	;skip space 224
	.word	0	;skip space 222
	.word	0	;skip space 220
	.word	0	;skip space 218
	.word	0	;skip space 216
	.word	0	;skip space 214
	.word	0	;skip space 212
	.word	0	;skip space 210
	.word	0	;skip space 208
	.word	0	;skip space 206
	.word	0	;skip space 204
	.word	0	;skip space 202
	.word	0	;skip space 200
	.word	0	;skip space 198
	.word	0	;skip space 196
	.word	0	;skip space 194
	.word	0	;skip space 192
	.word	0	;skip space 190
	.word	0	;skip space 188
	.word	0	;skip space 186
	.word	0	;skip space 184
	.word	0	;skip space 182
	.word	0	;skip space 180
	.word	0	;skip space 178
	.word	0	;skip space 176
	.word	0	;skip space 174
	.word	0	;skip space 172
	.word	0	;skip space 170
	.word	0	;skip space 168
	.word	0	;skip space 166
	.word	0	;skip space 164
	.word	0	;skip space 162
	.word	0	;skip space 160
	.word	0	;skip space 158
	.word	0	;skip space 156
	.word	0	;skip space 154
	.word	0	;skip space 152
	.word	0	;skip space 150
	.word	0	;skip space 148
	.word	0	;skip space 146
	.word	0	;skip space 144
	.word	0	;skip space 142
	.word	0	;skip space 140
	.word	0	;skip space 138
	.word	0	;skip space 136
	.word	0	;skip space 134
	.word	0	;skip space 132
	.word	0	;skip space 130
	.word	0	;skip space 128
	.word	0	;skip space 126
	.word	0	;skip space 124
	.word	0	;skip space 122
	.word	0	;skip space 120
	.word	0	;skip space 118
	.word	0	;skip space 116
	.word	0	;skip space 114
	.word	0	;skip space 112
	.word	0	;skip space 110
	.word	0	;skip space 108
	.word	0	;skip space 106
	.word	0	;skip space 104
	.word	0	;skip space 102
	.word	0	;skip space 100
	.word	0	;skip space 98
	.word	0	;skip space 96
	.word	0	;skip space 94
	.word	0	;skip space 92
	.word	0	;skip space 90
	.word	0	;skip space 88
	.word	0	;skip space 86
	.word	0	;skip space 84
	.word	0	;skip space 82
	.word	0	;skip space 80
	.word	0	;skip space 78
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
	.globl _dp_Vec_SWI2_vector
_dp_Vec_SWI2_vector:
	.word	0	;skip space 9
	.word	0	;skip space 7
	.word	0	;skip space 5
	.word	0	;skip space 3
	.byte	0	;skip space
	.globl _dp_Vec_NWI_vector
_dp_Vec_NWI_vector:
	.word	0	;skip space 3
	.byte	0	;skip space
