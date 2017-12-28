; Joystick funcs
; DSS, 2017

; Init joystick-related bios vars
InitJoystick:
	lda #1
	sta Vec_Joy_Mux_1_X	; x axis only!
	
	lda #0
	sta Vec_Joy_Mux_1_Y
	sta Vec_Joy_Mux_2_X
	sta Vec_Joy_Mux_2_Y
	rts
	
; Read joystick
GetJoystick:
	clr joy_lr
	jsr Read_Btns
	lda Vec_Btn_State
	sta joy_b
	jsr Joy_Digital
	lda Vec_Joy_1_X
	beq x_done
	bmi left_move
	lda #1
	sta joy_lr
	bra x_done
left_move:
	lda #-1
	sta joy_lr
x_done:	rts
		