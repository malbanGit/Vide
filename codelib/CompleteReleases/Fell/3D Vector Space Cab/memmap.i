; Ye olde memory map
; By Fell^DSS, Ludum Dare 38 \p/

base		equ $c880
scratch		equ base		; General purpose scratch
scratch2	equ scratch+1		; General purpose scratch
scratch16	equ scratch2+1		; General purpose 16-bit scratch

; State manager stuff
state_frame	equ scratch16+2		; 16 bit frame function for current state

; Controller interface stuff
joy_b		equ state_frame+2	; Controller button state
joy_lr		equ joy_b+1		; Joystick x state

; SFX stuff
sfx_pointer	equ joy_lr+1		; 16-bit pointer to SFX curr data byte
sfx_status	equ sfx_pointer+2	; SFX play status

; Textwriter stuff
textpos		equ sfx_status+1	; yx coords for text
textscale	equ textpos+2
textbright	equ textscale+1

; Safe for gamestates to use
state_base	equ textbright+1
