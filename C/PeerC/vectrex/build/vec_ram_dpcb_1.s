
;;; gcc for m6809 : Feb 15 2016 21:40:10
;;; 4.3.6 (gcc6809)
;;; ABI version 1
;;; -mint8
	.module	vec_ram_dpcb_1.c
;----- asm -----
	.bank page_00 (BASE=0x0000,SIZE=0x0100)
	.area direct (OVR,BANK=page_00)
	
;--- end asm ---
	.globl _dp_Vec_Snd_shadow
	.area	direct
_dp_Vec_Snd_shadow:
	.word	0	;skip space 235
	.word	0	;skip space 233
	.word	0	;skip space 231
	.word	0	;skip space 229
	.word	0	;skip space 227
	.word	0	;skip space 225
	.word	0	;skip space 223
	.word	0	;skip space 221
	.word	0	;skip space 219
	.word	0	;skip space 217
	.word	0	;skip space 215
	.word	0	;skip space 213
	.word	0	;skip space 211
	.word	0	;skip space 209
	.word	0	;skip space 207
	.word	0	;skip space 205
	.word	0	;skip space 203
	.word	0	;skip space 201
	.word	0	;skip space 199
	.word	0	;skip space 197
	.word	0	;skip space 195
	.word	0	;skip space 193
	.word	0	;skip space 191
	.word	0	;skip space 189
	.word	0	;skip space 187
	.word	0	;skip space 185
	.word	0	;skip space 183
	.word	0	;skip space 181
	.word	0	;skip space 179
	.word	0	;skip space 177
	.word	0	;skip space 175
	.word	0	;skip space 173
	.word	0	;skip space 171
	.word	0	;skip space 169
	.word	0	;skip space 167
	.word	0	;skip space 165
	.word	0	;skip space 163
	.word	0	;skip space 161
	.word	0	;skip space 159
	.word	0	;skip space 157
	.word	0	;skip space 155
	.word	0	;skip space 153
	.word	0	;skip space 151
	.word	0	;skip space 149
	.word	0	;skip space 147
	.word	0	;skip space 145
	.word	0	;skip space 143
	.word	0	;skip space 141
	.word	0	;skip space 139
	.word	0	;skip space 137
	.word	0	;skip space 135
	.word	0	;skip space 133
	.word	0	;skip space 131
	.word	0	;skip space 129
	.word	0	;skip space 127
	.word	0	;skip space 125
	.word	0	;skip space 123
	.word	0	;skip space 121
	.word	0	;skip space 119
	.word	0	;skip space 117
	.word	0	;skip space 115
	.word	0	;skip space 113
	.word	0	;skip space 111
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
	.globl _dp_Vec_High_score
_dp_Vec_High_score:
	.word	0	;skip space 7
	.word	0	;skip space 5
	.word	0	;skip space 3
	.byte	0	;skip space
	.globl _dp_Vec_SWI3_vector
_dp_Vec_SWI3_vector:
	.word	0	;skip space 3
	.byte	0	;skip space
	.globl _dp_Vec_FIRQ_vector
_dp_Vec_FIRQ_vector:
	.word	0	;skip space 3
	.byte	0	;skip space
	.globl _dp_Vec_IRQ_vector
_dp_Vec_IRQ_vector:
	.word	0	;skip space 3
	.byte	0	;skip space
	.globl _dp_Vec_SWI_vector
_dp_Vec_SWI_vector:
	.word	0	;skip space 3
	.byte	0	;skip space
