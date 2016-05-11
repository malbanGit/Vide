;code for rolling credits contained in credits.i

check_credit_roll:
	lda		credit_roll_counter_a
	cmpa	#-120
	ble		credit_roll				;check if a is 0....if so dec b, otherwise return
	lda		credit_roll_counter_a
	deca
	sta		credit_roll_counter_a
	rts
	
check_credit_back:
	lda		credit_roll_counter_a
	cmpa	#-120
	ble		return_to_startscreen				;check if a is 0....if so dec b, otherwise return
	lda		credit_roll_counter_a
	deca
	sta		credit_roll_counter_a
	rts

return_to_startscreen:
	lda		#127
	sta		credit_roll_counter_a
	bra		startscreen				;ATTENTION - FIX THIS! is this dodgy do we need to retun? is this growing the stack?

credit_roll:
	lda		#127	
	sta		credit_roll_counter_a	;reset the credit roll counter that lets us go to the credit roll after a time
	clra
	sta		credit_intensity
;	lda		#2
;	sta		tmp_1	;try alternating the text every frame to stop flicker?
	
draw_credits:
;	jsr		calib					;calibrates
    jsr    Wait_Recal        ; BIOS recalibration
	jsr		check_credit_back
	
	jsr		Reset0Ref
	lda		credit_intensity
	inca
	cmpa	#100
	bge		draw_credits_t
	sta		credit_intensity
draw_credits_t:
	jsr     Intensity_a            ; Sets the intensity of the
	;lda		tmp_1;
	;deca;
	;cmpa	#1;
	beq		draw_credits_2;
	jsr		Moveto_d
	ldu		#Credit_0
    jsr    Print_List_hw            ; Vectrex BIOS print rout
	lda		#2
	sta		tmp_1
	;rts;
draw_credits_2:
	lda		credit_intensity
	suba	#50
	jsr		Intensity_a
	ldu		#Credit_1
	jsr    Print_List_hw
	jsr		Read_Btns
	cmpa	#0
	beq		draw_credits_r	;if button not pressed keep drawing credits
	lda		#127					;reset counter and return to main screen
	sta		credit_roll_counter_a	;reset counter so we dont get jumped back to the credits screen
	rts
draw_credits_r:

	bra		draw_credits