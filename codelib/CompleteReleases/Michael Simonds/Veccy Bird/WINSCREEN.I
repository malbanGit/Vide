FIREWORK_GRAVITY	equ		16

win_screen:

	jsr		Clear_Sound
	lda 	#$07              ;Modify Register 7 mixer
	ldb		#%00111111 			;set mixer to all channels off 
    jsr     Sound_Byte ;Set register
	lda		#127
	std		firework_counter
	lda		#127
	sta		credit_intensity
	
win_screen_2:
;	jsr		calib
    jsr    Wait_Recal        ; BIOS recalibration
	lda		credit_intensity
	cmpa	#0
	beq		skip_print_win
	jsr		print_win
skip_print_win:
;	clra
;	sta		bird_x
;	sta		bird_y
;	lda		#1
;	sta		flap_on
;	inc		bird_rotation
;	jsr		draw_bird
;	jsr		Do_Sound
	jsr		up_rocket_sound
	jsr		up_explode_sound
	jsr		rocket_fireworks
	jsr		update_emitters
	jsr		update_rockets
	bra		win_screen_2; loop forever
	
rocket_fireworks:
	lda		firework_counter
	cmpa	#0
	bne		fw_counter_dec
	jsr		Random
	anda	#%011111		;use mask to get lower number
	;lda		#6
	sta		firework_counter		;reset counter to random value
;check f slot - use a emitter/rocket not being used
	lda		rocket_1_on
	cmpa	#0
	bne		check_f_slot_2
	lda		emitter_1_on
	cmpa	#0
	bne		check_f_slot_2
	jsr		fire_rocket_1
	lda		firework_counter	;adds a slight delay
	adda	#3					;by adding 5 if a rocket has been fired
	sta		firework_counter	;ok?
	bra		fw_counter_dec
check_f_slot_2:
	lda		rocket_2_on
	cmpa	#0
	bne		check_f_slot_3
	lda		emitter_2_on
	cmpa	#0
	bne		check_f_slot_3
	jsr		fire_rocket_2
	lda		firework_counter	;adds a slight delay
	adda	#3					;by adding 5 if a rocket has been fired
	sta		firework_counter	;ok?
	bra		fw_counter_dec
check_f_slot_3:
	lda		rocket_3_on
	cmpa	#0
	bne		fw_counter_dec
	lda		emitter_3_on
	cmpa	#0
	bne		fw_counter_dec
	jsr		fire_rocket_3
	;rts
fw_counter_dec:
	dec		firework_counter		;decrease counter
	rts
	
fire_rocket_1: ;{ reusing particle emitter
	lda		#1
	sta		rocket_1_on
	lda		#-127				;start pos 16bit
	ldb		#0
	std		emitter_1_y
	lda		#0
	ldb		#0
	std		emitter_1_x
	lda		#5					;start vel 16bit * 2
	ldb		#80
	std		emitter_1_vel_y
	jsr		Random
	anda	#%0000011		;use mask to get lower number
	suba	#1				;subtract to get some neg values
	asra
	ldb		#13
	std		emitter_1_vel_x
	jsr		play_rocketsound_1
	rts
;}	
fire_rocket_2: ;{ reusing particle emitter
	lda		#1
	sta		rocket_2_on
	lda		#-127				;start pos 16bit
	ldb		#0
	std		emitter_2_y
	lda		#0
	ldb		#0
	std		emitter_2_x
	lda		#5					;start vel 16bit * 2
	ldb		#81
	std		emitter_2_vel_y
	jsr		Random
	anda	#%0000011		;use mask to get lower number
	suba	#1				;subtract to get some neg values
	asra
	ldb		#12
	std		emitter_2_vel_x
	jsr		play_rocketsound_2
	rts
;}
fire_rocket_3: ;{ reusing particle emitter
	lda		#1
	sta		rocket_3_on
	lda		#-127				;start pos 16bit
	ldb		#0
	std		emitter_3_y
	lda		#0
	ldb		#0
	std		emitter_3_x
	lda		#5					;start vel 16bit * 2
	ldb		#84
	std		emitter_3_vel_y
	jsr		Random
	anda	#%0000011		;use mask to get lower number
	suba	#1				;subtract to get some neg values
	asra
	ldb		#16
	std		emitter_3_vel_x
	jsr		play_rocketsound_3
	rts
;}

update_rockets:
	lda		#127			;move this to the move d? dot draw?
	jsr		Intensity_a
	lda		#127
	sta		VIA_t1_cnt_lo	;store scale factor
;check rocket 1
	lda		emitter_1_vel_y	;check if high bit is 0 if so blowup
	cmpa	#0
	bne		check_rocket_2		;if not 0 update rocket
	lda		#0				;explode firework	
	sta		rocket_1_on		;turn rocket off
	lda		#1
	sta		emitter_1_on
	sta		emitter_1_vel_y ;set this high so it doesnt try explode again
	lda		#16 ;max of 16
	sta		emitter_1_pcount
	jsr 	init_emitter_1 ;start emitter
	jsr		play_explodesound_1
;	ldu		#explode_sound
;	jsr		Explosion_Snd
check_rocket_2:
	lda		emitter_2_vel_y	;check if high bit is 0 if so blowup
	cmpa	#0
	bne		check_rocket_3		;if not 0 update rocket
	lda		#0				;explode firework	
	sta		rocket_2_on		;turn rocket off
	lda		#1
	sta		emitter_2_on
	sta		emitter_2_vel_y ;set this high so it doesnt try explode again
	lda		#16 ;max of 16
	sta		emitter_2_pcount
	jsr 	init_emitter_2 ;start emitter
	jsr		play_explodesound_2
check_rocket_3:
	lda		emitter_3_vel_y	;check if high bit is 0 if so blowup
	cmpa	#0
	bne		up_rock_1		;if not 0 update rocket
	lda		#0				;explode firework	
	sta		rocket_3_on		;turn rocket off
	lda		#1
	sta		emitter_3_on
	sta		emitter_3_vel_y ;set this high so it doesnt try explode again
	lda		#16 ;max of 16
	sta		emitter_3_pcount
	jsr 	init_emitter_3 ;start emitter
	jsr		play_explodesound_3
	rts		;return?
up_rock_1:
	lda		rocket_1_on
	cmpa	#0
	beq		up_rock_2			;if off skip
	ldd		emitter_1_vel_y
	subd	#FIREWORK_GRAVITY					;gravity
	std		emitter_1_vel_y
	addd	emitter_1_y
	std		emitter_1_y
	ldd		emitter_1_vel_x
	addd	emitter_1_x
	std		emitter_1_x
	jsr		Reset0Ref
	lda		emitter_1_y	;highbyte y
	ldb		emitter_1_x	;highbyte x
	jsr		Dot_d
up_rock_2:	
	lda		rocket_2_on
	cmpa	#0
	beq		up_rock_3			;if off skip
	ldd		emitter_2_vel_y
	subd	#FIREWORK_GRAVITY				;gravity
	std		emitter_2_vel_y
	addd	emitter_2_y
	std		emitter_2_y
	ldd		emitter_2_vel_x
	addd	emitter_2_x
	std		emitter_2_x
	jsr		Reset0Ref
	lda		emitter_2_y	;highbyte y
	ldb		emitter_2_x	;highbyte x
	jsr		Dot_d
up_rock_3:
	lda		rocket_3_on
	cmpa	#0
	beq		up_rock_rt			;if off skip
	ldd		emitter_3_vel_y
	subd	#FIREWORK_GRAVITY				;gravity
	std		emitter_3_vel_y
	addd	emitter_3_y
	std		emitter_3_y
	ldd		emitter_3_vel_x
	addd	emitter_3_x
	std		emitter_3_x
	jsr		Reset0Ref
	lda		emitter_3_y	;highbyte y
	ldb		emitter_3_x	;highbyte x
	jsr		Dot_d
up_rock_rt:	
	rts

	
up_rocket_sound:

check_r_sound_1:
	lda		sound_flag_1
	cmpa	#1
	beq		do_sound_1
	bra		check_r_sound_2
do_sound_1
	lda		Vec_ADSR_Timers
	deca	
	cmpa	#0
	beq		fin_sound_1	
	sta		Vec_ADSR_Timers
	ldx		#r_soundfx
	lda     #$08; Modify Register 9 (vol)
	ldb		Vec_ADSR_Timers
	ldb		b,x
	jsr     Sound_Byte
	bra		check_r_sound_2
fin_sound_1:
	lda		#0
	sta		Vec_ADSR_Timers
	sta		sound_flag_1

check_r_sound_2:
	lda		sound_flag_2
	cmpa	#1
	beq		do_sound_2
	rts
do_sound_2
	lda		Vec_ADSR_Timers+1
	deca	
	cmpa	#0
	beq		fin_sound_2
	sta		Vec_ADSR_Timers+1
	ldx		#r_soundfx
	lda     #$09; Modify Register 9 (vol)
	ldb		Vec_ADSR_Timers+1
	ldb		b,x
	jsr     Sound_Byte
	bra		check_r_sound_3
fin_sound_2:
	lda		#0
	sta Vec_ADSR_Timers+1
	sta		sound_flag_2
check_r_sound_3:
	lda		sound_flag_3
	cmpa	#1
	beq		do_sound_3
	rts
do_sound_3
	lda		Vec_ADSR_Timers+2
	deca	
	cmpa	#0
	beq		fin_sound_3
	sta		Vec_ADSR_Timers+2
	ldx		#r_soundfx
	lda     #$10; Modify Register 9 (vol)
	ldb		Vec_ADSR_Timers+2
	ldb		b,x
	jsr     Sound_Byte
	rts		;return
fin_sound_3:
	lda		#0
	sta Vec_ADSR_Timers+2
	sta		sound_flag_3		
	rts		;return

;check explode sound
up_explode_sound:

check_e_sound_1:
	lda		sound_explode_flag_1
	cmpa	#1
	beq		do_e_sound_1
	bra		check_e_sound_2
do_e_sound_1:
	lda		Vec_ADSR_Timers
	deca	
	cmpa	#0
	beq		fin_e_sound_1	
	sta		Vec_ADSR_Timers
	ldx		#r_explodefx
	lda     #$08; Modify Register 9 (vol)
	ldb		Vec_ADSR_Timers
	ldb		b,x
	jsr     Sound_Byte
	bra		check_e_sound_2
fin_e_sound_1:
	lda		#0
	sta		Vec_ADSR_Timers
	sta		sound_explode_flag_1
check_e_sound_2:
	lda		sound_explode_flag_2
	cmpa	#1
	beq		do_e_sound_2
	bra		check_e_sound_3
do_e_sound_2:
	lda		Vec_ADSR_Timers+1
	deca	
	cmpa	#0
	beq		fin_e_sound_2
	sta		Vec_ADSR_Timers+1
	ldx		#r_explodefx
	lda     #$09; Modify Register 9 (vol)
	ldb		Vec_ADSR_Timers+1
	ldb		b,x
	jsr     Sound_Byte
	bra		check_e_sound_3
fin_e_sound_2:
	lda		#0
	sta		Vec_ADSR_Timers+1
	sta		sound_explode_flag_2


check_e_sound_3:
	lda		sound_explode_flag_3
	cmpa	#1
	beq		do_e_sound_3
	;bra		check_e_sound_4
	rts
do_e_sound_3:
	lda		Vec_ADSR_Timers+2
	deca	
	cmpa	#0
	beq		fin_e_sound_3	
	sta		Vec_ADSR_Timers+2
	ldx		#r_explodefx
	lda     #$A; Modify Register 9 (vol)
	ldb		Vec_ADSR_Timers+2
	ldb		b,x
	jsr     Sound_Byte
	;jsr		print_win
	;bra		check_e_sound_4
	rts
fin_e_sound_3:
	lda		#0
	sta		Vec_ADSR_Timers+2
	sta		sound_explode_flag_3

	rts

	
play_rocketsound_1:
	lda 	#$08			;Modify Register 8
	ldb 	#0				;Volume=10
	jsr     Sound_Byte		;Set register
	lda 	#$07			;Modify Register 7 mixer
	ldb 	$c807			;Get previous value for register 7
	andb	#%00110111
	;orb		#%00001000
	jsr     Sound_Byte		;Set register
	lda     #24				; Set sound count to 10
	sta     Vec_ADSR_Timers	;first byte of 3 normally used for bios - we borrow it user +1 +2 for the other bytes!
	lda		#1
	sta		sound_flag_1	;set sound to on
	rts
	
play_rocketsound_2:
	lda 	#$09			;Modify Register 8
	ldb 	#0				;Volume=10
	jsr     Sound_Byte		;Set register
	lda 	#$07			;Modify Register 7 mixer
	ldb 	$c807			;Get previous value for register 7
	andb	#%00101111
	;orb		#%00001000
	jsr     Sound_Byte		;Set register
	lda     #24				; Set sound count to 10
	sta     Vec_ADSR_Timers+1	;first byte of 3 normally used for bios - we borrow it user +1 +2 for the other bytes!
	lda		#1
	sta		sound_flag_2	;set sound to on
	rts
	
play_rocketsound_3:
	lda 	#$10			;Modify Register 8
	ldb 	#0				;Volume=10
	jsr     Sound_Byte		;Set register
	lda 	#$07			;Modify Register 7 mixer
	ldb 	$c807			;Get previous value for register 7
	andb	#%00011111
	;orb		#%00001000
	jsr     Sound_Byte		;Set register
	lda     #24				; Set sound count to 10
	sta     Vec_ADSR_Timers+2	;first byte of 3 normally used for bios - we borrow it user +1 +2 for the other bytes!
	lda		#1
	sta		sound_flag_3	;set sound to on
	rts
	
play_explodesound_1:
	lda 	#$06			;Modify Register 6 noise frew
	ldb 	#13		;noise period
	jsr     Sound_Byte		;Set register
	
	lda 	#$08			;Modify Register 8
	ldb 	#15				;Volume=10
	jsr     Sound_Byte		;Set register
	lda 	#$07			;Modify Register 7 mixer
	ldb 	$c807			;Get previous value for register 7
	andb	#%00110111
	;orb		#%00001000
	jsr     Sound_Byte		;Set register
	lda     #36				; Set sound count to 10
	sta     Vec_ADSR_Timers	;first byte of 3 normally used for bios - we borrow it user +1 +2 for the other bytes!
	lda		#1
	sta		sound_explode_flag_1	;set sound to on
	rts
	
play_explodesound_2:
	lda 	#$06			;Modify Register 6 noise frew
	ldb 	#11		;noise period
	jsr     Sound_Byte		;Set register
	
	lda 	#$09			;Modify Register 8
	ldb 	#15				;Volume=10
	jsr     Sound_Byte		;Set register
	lda 	#$07			;Modify Register 7 mixer
	ldb 	$c807			;Get previous value for register 7
	andb	#%00101111
	;orb		#%00001000
	jsr     Sound_Byte		;Set register
	lda     #36				; Set sound count to 10
	sta     Vec_ADSR_Timers+1	;first byte of 3 normally used for bios - we borrow it user +1 +2 for the other bytes!
	lda		#1
	sta		sound_explode_flag_2	;set sound to on
	rts
	
play_explodesound_3:
	lda 	#$06			;Modify Register 6 noise frew
	ldb 	#12		;noise period
	jsr     Sound_Byte		;Set register
	
	lda 	#$A			;Modify Register 10
	ldb 	#14				;Volume=10
	jsr     Sound_Byte		;Set register
	lda 	#$07			;Modify Register 7 mixer
	ldb 	$c807			;Get previous value for register 7
	andb	#%00011111
	;orb		#%00001000
	;ldb		#%00000000
	jsr     Sound_Byte		;Set register
	lda     #36			; Set sound count to 10
	sta     Vec_ADSR_Timers+2	;first byte of 3 normally used for bios - we borrow it user +1 +2 for the other bytes!
	lda		#1
	sta		sound_explode_flag_3	;set sound to on
	rts

	
	
r_soundfx:
	;dont set volume above 15, as 16 turns on hardware envelopes !
	fcb 0,0,3,4,5,6,7,8,9,8,8,10,11,10,10,8,7,6,5,7,6,5,4,2,1,0
	
r_explodefx:
	fcb	0,0,1,1,2,3,1,2,4,6,1,2,3,8,9,0,1,3,5,9,10,8,9,10,0,5,10,15,5,10,13,15,12,10,15,15