; Splash screen state
; By Fell^DSS, Ludum Dare 38 \p/

; ***** CONSTANTS *****
SPLASH_ROT_DELAY	equ 3				; Planet rotates every this many frames
LABEL_OFFSET		equ 20				; x offset for landmark labels

; ***** MEMORY MAP *****
planet_rot_splash	equ state_base			; Planet rotation val
intens_splash	  	equ planet_rot_splash+1		; Screen intensity
rot_delay		equ intens_splash+1		; Track frames left till rotation
framecount_splash	equ rot_delay+1			; 16 bit frame counter

; ***** INIT *****
SplashInit:
	clra			; Reset stuff
	sta planet_rot_splash
	sta intens_splash
	sta rot_delay
	clrb
	std framecount_splash
	
	lda #SPLASH_ROT_DELAY
	sta rot_delay
	rts

; ***** FRAME *****
SplashFrame:
	; Fade in
	lda intens_splash
	cmpa #MAX_INTENSITY
	bge dont_step_intensity_splash
	adda #FADE_SPEED
	sta intens_splash
dont_step_intensity_splash:
	FastIntensity_a	
	
	; Tick rotation
	dec rot_delay
	bne no_rot_step
	lda #SPLASH_ROT_DELAY
	sta rot_delay
	lda planet_rot_splash
	deca
	cmpa #-1		; Loop if needed
	bne dont_reset_rot_intro
	lda #NUM_FRAMES-1
dont_reset_rot_intro:
	sta planet_rot_splash
no_rot_step:
	
	; Draw planet
	lda planet_rot_splash	; Grab planet rot
	asla			; x2 to use as offset into frame index
	ldx #theplanet_index	; x points to the index of frames
	ldx a,x			; x points to the actual contours :)
ap_next_contour_splash:		; For each contour
	lda #$CE 		; /BLANK low, /ZERO high
	sta <VIA_cntl
	lda intens_splash	; Set scale for the draw
	adda #(150-MAX_INTENSITY)	
	Wait_T1			; Wait for move
	sta <VIA_t1_cnt_lo	; Set scale
	lda ,x+			; Get num vectors in this contour
	sta Vec_Misc_Count	; Write to vec count
	ldd ,x			; Get next coordinate pair -- this is the absolute start pos so we can add the offset here
	sta <VIA_port_a 	; Send Y to A/D
	clr <VIA_port_b		; Enable mux
	leax 2,x		; Point to next coordinate pair
	nop			; Wait a moment
	inc <VIA_port_b     	; Disable mux
	stb <VIA_port_a     	; Send X to A/D
	ldd #$0000          	; Shift reg=0 (no draw, move only), T1H=0
	bra ap_draw_it_splash	; A->D00A, B->D005 -- DO THE MOVE
ap_next_point_splash:	
	sta Vec_Misc_Count	; Update count
	ldd ,x			; Grab the coord pair
	sta <VIA_port_a     	; Send Y to A/D
	clr <VIA_port_b     	; Enable mux
	leax 2,x            	; Point to next coordinate pair
	nop                 	; Wait a moment
	inc <VIA_port_b     	; Disable mux
	stb <VIA_port_a     	; Send X to A/D
	ldd #$FF00          	; Shift reg=$FF (solid line), T1H=0
ap_draw_it_splash:   	
	sta <VIA_shift_reg  	; Put pattern in shift register
	stb <VIA_t1_cnt_hi  	; Set T1H to start the ramp
	ldd #$0040          	; B-reg = T1 interrupt bit
ap_w_t1_splash:
	bitb <VIA_int_flags 	; Wait for T1 to time out
	beq ap_w_t1_splash
	nop                 	; Wait a moment more
	sta <VIA_shift_reg  	; Clear shift register (blank output)
	lda Vec_Misc_Count	; Decrement line count
	deca
	bpl ap_next_point_splash 	; Go back for more points	
	FastZeroRef		; Return beam to origin
	lda ,x			; Check if x now points to a zero (end of frame)
	cmpa #FRAME_DELIMITER
	bne ap_next_contour_splash	; Loop if not
	
	; Skip input / call to action text if not faded in yet
	lda intens_splash	
	cmpa #MAX_INTENSITY
	lblt dont_change_state_splash
	
	; Set text intensity
	ldd framecount_splash
	tfr b,a
	cmpa #192
	bhs fade_text_out
	cmpa #63
	blo fade_text_in
	lda #127	
	bra now_set_intensity
fade_text_out:
	;sbca #192
	suba #192	
	sta scratch
	lda #63
	suba scratch
	asla
	bra now_set_intensity
fade_text_in:
	asla
now_set_intensity:
	FastIntensity_a
	
	; Choose whether to do landmarks or title/cta text
	ldd framecount_splash
	addd #1
	std framecount_splash
	anda #1
	lbeq do_title_text
	
	; Show landmark labels: UNROLL YOUR LOOPS FOR GREAT JUSTICE .......... and also laziness
	lda #LM_MOVE_SCALE
	sta <VIA_t1_cnt_lo	; Set scale for the LM moves
	
	lda #-3			; Set text params for labels
	sta Vec_Text_Height
	lda #30
	sta Vec_Text_Width
	
	; Unroll: 1
	ldx #landmark1
	lda planet_rot_splash	; Grab curr rot
	asla			; x2 -- each coord pair's 2 bytes
	leax a,x		; Step forward by a
	ldd ,x
	cmpd #INVISIBLE
	beq skip_it_1
	subb #LABEL_OFFSET
	FastMoveTo_d
	ldu #lm1_name
	Wait_T1
	bsr Print_Str
	FastZeroRef
skip_it_1:
	; Unroll: 1
	ldx #landmark2
	lda planet_rot_splash	; Grab curr rot
	asla			; x2 -- each coord pair's 2 bytes
	leax a,x		; Step forward by a
	ldd ,x
	cmpd #INVISIBLE
	beq skip_it_2
	adda #50		; HACK: y axis hack for TRSiLand
	subb #LABEL_OFFSET	
	FastMoveTo_d
	ldu #lm2_name
	Wait_T1
	bsr Print_Str
	FastZeroRef
skip_it_2:
	; Unroll: 3
	ldx #landmark3
	lda planet_rot_splash	; Grab curr rot
	asla			; x2 -- each coord pair's 2 bytes
	leax a,x		; Step forward by a
	ldd ,x
	cmpd #INVISIBLE
	beq skip_it_3
	subb #LABEL_OFFSET
	FastMoveTo_d
	ldu #lm3_name
	Wait_T1
	bsr Print_Str
	FastZeroRef
skip_it_3:
	; Unroll: 4
	ldx #landmark4
	lda planet_rot_splash	; Grab curr rot
	asla			; x2 -- each coord pair's 2 bytes
	leax a,x		; Step forward by a
	ldd ,x
	cmpd #INVISIBLE
	beq skip_it_4
	subb #LABEL_OFFSET
	FastMoveTo_d
	ldu #lm4_name
	Wait_T1
	bsr Print_Str
	FastZeroRef
skip_it_4:

	lda #-4			; Reset default text size
	sta Vec_Text_Height
	lda #40
	sta Vec_Text_Width
	
	bra do_input		; Skip the title/cta text
	
	; Draw the CTA text
do_title_text:	
	lda #120
	sta <VIA_t1_cnt_lo	; Set scale for mooooove
	lda #-110
	ldb #-58
	FastMoveTo_d
	ldu #welcome_text
	Wait_T1			; Wait for de beam
	bsr Print_Str		; Print it
	
	; Draw title text
	FastZeroRef
	lda #120
	ldb #-62
	FastMoveTo_d
	ldu #title_text
	Wait_T1			; Wait for de beam
	bsr Print_Str		; Print it	

	; Change state if they hit a button
do_input:
	jsr GetJoystick		; Read the joystick
	lda joy_b		; Check for a button press...
	beq dont_change_state_splash
	ldx #GameInit		; ...and request state change if they hit button 1
	ldy #GameFrame
	bsr ChangeState
dont_change_state_splash:	
	rts
