; Game state
; By Fell^DSS, Ludum Dare 38 \p/

; ***** CONSTANTS *****
SHIP_MAX_Y	equ 90			; Ship y pos bounds
SHIP_MIN_Y	equ -80
SHIP_MAX_YVEL	equ 4			; Ship y velo bound
SHIP_MIN_YVEL	equ -2
MAX_SCALE	equ 80			; Scale of the ship when at horizon
MAX_FUEL	equ 255			; Max fuel ship can carry
GRAVITY		equ -1			; Gravity influence on y velo
THRUST		equ 3			; Thruster influence on y velo
DROPOFF_REWARD	equ 400			; Amount of moolah for dropping someone off
MAX_INTENSITY	equ 95			; Max screen intensity
FADE_SPEED	equ 1			; How fast do we fade in?
CLOSENESS	equ 3			; How close do they gotta be to hit the landmark?
FUEL_BURN_THR	equ 2			; How fast fuel burns when thrusting
FUEL_BURN_SPIN	equ 1			; How fast fuel burns when spinning
LM_MOVE_SCALE	equ 140			; Scale value to get correct moves from landmark coord table
COMBO_BUMP	equ 900			; How much combo_bonus gets bumped by on dropoff

; ***** MEMORY MAP *****
cash		equ state_base		; 16-bit cash counter
cash_ascii 	equ cash+2		; Ascii score (7 bytes -- 1 dollar sign, 5 digits, one string termie)
shipy		equ cash_ascii+7	; Ship y coordd
fuel		equ shipy+1		; Ship fuel
shipyvel	equ fuel+1		; Ship y velocity
odd_frame	equ shipyvel+1		; Is it an odd frame?
planet_rot	equ odd_frame+1		; Planet rotation val
current_fuel_lm	equ planet_rot+1	; Which landmark's the fuel depot? (0-3)
current_pass_lm	equ current_fuel_lm+1	; Which landmark's the dropoff or pickup point? (0-3)
taxi_mode	equ current_pass_lm+1	; -1=Pickup next; 1=Dropoff next
intens		equ taxi_mode+1		; Screen intensity
combo_bonus	equ intens+1		; 16 bit!! Track the current combo bonus
high_score	equ combo_bonus+2	; 16 bit!! Track the high score (SLIGHT HACK WARNING -- placed high so it doesn't get overwritten by other states)
high_score_asc	equ high_score+2	; 7 bytes for ASCII high score (1 dollar sign, 5 digits, one string termie)
combo_level	equ high_score_asc+7	; Track combo level (just for convenience... ideally we should calc combo_bonus from this but meh \o/)
GAME_RAM_TOP	equ combo_level+1	; End of our RAM (gameover state doesn't reuse the public state area cos it wants to access score)

; ***** INIT *****
GameInit:			; Gets called once when changing to this state
	lda #$80
	sta cash_ascii+6	; Write the string termie for the score
	;lda #116		; t - gives broken dollar symbol
	lda #104		; h - gives arrow thing
	
	sta cash_ascii		; Write the dollar sign
	
	ldd #0			; Reset score
	std cash		; Reset cash
	std combo_bonus		; Reset c-c-combo bonus <3
	sta combo_level		; Reset combo level
	sta shipyvel		; Reset ship velo
	sta planet_rot		; Reset planet rotation
	sta current_pass_lm	; Reset pickup (Always Emma first)
	sta intens		; Reset intensity
	
	ldu #cash_ascii+1	; Convert initial zero score to ASCII
	bsr bin2ascii
	
re_roll:
	bsr FixedRandom_3	; Roll a die
	anda #3			; Clamp 0-3
	cmpa current_pass_lm	; Reroll if we just picked the pickup point!
	beq re_roll
	sta current_fuel_lm	; Set initial fuel depot
	
	lda #MAX_FUEL		; Reset fuel
	sta fuel
	lda #SHIP_MAX_Y
	sta shipy		; Reset ship pos
	lda #1
	sta odd_frame
	lda #-1			; Reset taxi mode to pickup
	sta taxi_mode
	
	bsr InitJoystick	; Init controller
	bsr sfx_init		; Init sfx sys

	rts

; ***** FRAME *****	
GameFrame:			; Gets called every frame
	; Tick stuff
	lda odd_frame		; Toggle the odd-frame flag
	nega
	sta odd_frame
	
	lda intens		; Fade in
	cmpa #MAX_INTENSITY
	bge dont_step_intensity
	adda #FADE_SPEED
	sta intens
dont_step_intensity:
	FastIntensity_a
	
	; Tick physics
	bsr GetJoystick		; Read the joystick
	lda shipyvel		; First update velocity...
	ldb odd_frame		; Skip gravity every other frame
	bgt dont_apply_gravity
	adda #GRAVITY		; Apply gravity
dont_apply_gravity:
	ldb joy_b		; Are they pressing thrust?
	beq thrust_input_done
	adda #THRUST		; Yeah, apply some thrust to velocity
	ldb fuel		; And dec fuel
	subb #FUEL_BURN_THR
	bhi fuel_level_ok	; Check remaining fuel level
	jmp game_over		; Ees no goode! Keel them
fuel_level_ok:
	stb fuel
thrust_input_done:
	cmpa #SHIP_MIN_YVEL	; Clamp velo (note it's still in reg a)
	bge min_yvel_ok
	lda #SHIP_MIN_YVEL
min_yvel_ok:
	cmpa #SHIP_MAX_YVEL
	ble max_yvel_ok
	lda #SHIP_MAX_YVEL
max_yvel_ok:
	sta shipyvel
	adda shipy		; ...now update position
	cmpa #SHIP_MAX_Y	; Clamp pos
	ble ymax_ok
	lda #SHIP_MAX_Y
ymax_ok:	
	cmpa #SHIP_MIN_Y
	bge ymin_ok
	lda #SHIP_MIN_Y		; They're at screen min!! Let's cost them some fuel
	ldb fuel
	subb #FUEL_BURN_THR
	bhi fuel_level_ok3	; Check remaining fuel level
	jmp game_over		; Ees no goode! Keel them
fuel_level_ok3:
	stb fuel
ymin_ok:
	sta shipy
	
	; Update planet rotation
	ldb odd_frame		; Skip spin input every other frame
	bgt input_done
	lda joy_lr		; Check for input
	beq input_done
	ldb fuel		; OK, they're gonna spin one way or t'other, let's cost them some fuel
	subb #FUEL_BURN_SPIN
	bhi fuel_level_ok2	; Check remaining fuel level
	jmp game_over		; Ees no goode! Keel them
fuel_level_ok2:
	stb fuel
	cmpa #0			; (We killed the comp flags)
	bgt go_left
	bra go_right
go_left:			; Rot left
	ldb planet_rot
	decb
	cmpb #-1		; Loop if needed
	bne dont_reset_rot2
	ldb #NUM_FRAMES-1
dont_reset_rot2:
	stb planet_rot
	bra input_done
go_right:			; Rot right
	ldb planet_rot
	incb
	cmpb #NUM_FRAMES	; Loop if needed
	bne dont_reset_rot
	clrb
dont_reset_rot:
	stb planet_rot
input_done:	
	
	; Draw planet
	lda planet_rot		; Grab planet rot
	asla			; x2 to use as offset into frame index
	ldx #theplanet_index	; x points to the index of frames
	ldx a,x			; x points to the actual contours :)
ap_next_contour:		; For each contour
	lda #$CE 		; /BLANK low, /ZERO high
	sta <VIA_cntl
	lda #150		; Set scale for the draw
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
	bra ap_draw_it		; A->D00A, B->D005 -- DO THE MOVE
ap_next_point:	
	sta Vec_Misc_Count	; Update count
	ldd ,x			; Grab the coord pair
	sta <VIA_port_a     	; Send Y to A/D
	clr <VIA_port_b     	; Enable mux
	leax 2,x            	; Point to next coordinate pair
	nop                 	; Wait a moment
	inc <VIA_port_b     	; Disable mux
	stb <VIA_port_a     	; Send X to A/D
	ldd #$FF00          	; Shift reg=$FF (solid line), T1H=0
ap_draw_it:   	
	sta <VIA_shift_reg  	; Put pattern in shift register
	stb <VIA_t1_cnt_hi  	; Set T1H to start the ramp
	ldd #$0040          	; B-reg = T1 interrupt bit
ap_w_t1:
	bitb <VIA_int_flags 	; Wait for T1 to time out
	beq ap_w_t1
	nop                 	; Wait a moment more
	sta <VIA_shift_reg  	; Clear shift register (blank output)
	lda Vec_Misc_Count	; Decrement line count
	deca
	bpl ap_next_point   	; Go back for more points	
	FastZeroRef		; Return beam to origin
	lda ,x			; Check if x now points to a zero (end of frame)
	cmpa #FRAME_DELIMITER
	bne ap_next_contour	; Loop if not
	
	; Draw score (cash)
	;FastZeroRef		; Back to origin
	lda #120
	sta <VIA_t1_cnt_lo	; Set scale for mooooove
	lda #120
	ldb #50
	FastMoveTo_d
	ldu #cash_ascii		; u=pointer to ASCII cash
	Wait_T1			; Wait for de beam
	bsr Print_Str		; Print the cash score
	
	; Fuel gauge
	FastZeroRef		; Origin
	lda #118
	ldb #-85
	FastMoveTo_d		; Move to target pos
	Wait_T1			; Wait (sigh)
	lda fuel		; Use fuel val as scale
	lsra
	sta <VIA_t1_cnt_lo
	clra
	ldb #100
	FastDraw_Line_d		; Draw line
	
	; Draw ship
	FastZeroRef		; Back to origin
	lda #120
	sta <VIA_t1_cnt_lo	; Reset scale for mooooove
	lda shipy
	clrb
	FastMoveTo_d		; Move to target pos
	ldx #ship		; u=pointer to ASCII cash
	Wait_T1			; Wait for de beam
	ldb shipy		; Use y for scale!
	bge shipy_abs_ok	; y=abs(y)
	negb
shipy_abs_ok:
	asrb
	stb scratch
	lda #MAX_SCALE		; scale=max-abs(y)
	suba scratch
	sta <VIA_t1_cnt_lo	; Set scale for draw
	FastDraw_VLc
	
	; Draw the fuel depot
	FastZeroRef		; Back to origin
	lda #LM_MOVE_SCALE
	sta <VIA_t1_cnt_lo	; Reset scale for mooooove
	ldy #landmarks_index	; NOTE: y holds this for the rest of frame
	lda current_fuel_lm	; grab fuel depot's landmark id
	asla			; x4 (these records are 4 bytes)
	asla
	ldx a,y			; x points to the start of the actual landmark path
	lda planet_rot		; Grab curr rot
	asla			; x2 -- each coord pair's 2 bytes
	leax a,x		; Step forward by a
	ldd ,x			; Grab the coord pair
	cmpd #INVISIBLE
	beq no_fueldepot	; Skip draw if invisible for this rot val
	addb #3			; HACK: Draw the f icon slightly to the right of where its coords are	
	FastMoveTo_d		; Otherwise move!
	ldx #fueldepot
	Wait_T1
	lda #8
	sta <VIA_t1_cnt_lo	; Reset scale for draw
	bsr Draw_VL_mode	; And draw
no_fueldepot:
	
	; Draw the pickup / dropoff point
	FastZeroRef		; Back to origin
	lda #LM_MOVE_SCALE
	sta <VIA_t1_cnt_lo	; Reset scale for mooooove
	lda current_pass_lm	; grab pickup or dropoff point's landmark id
	asla			; x4 (these records are 4 bytes)
	asla
	ldx a,y			; a points to the start of the actual landmark path
	lda planet_rot		; Grab curr rot
	asla			; x2 -- each coord pair's 2 bytes
	leax a,x		; Step forward by a
	ldd ,x			; Grab the coord pair
	cmpd #INVISIBLE
	beq no_passenger_pt	; Skip draw if invisible for this rot val
	FastMoveTo_d		; Otherwise move!
	lda taxi_mode		; Load x with either passenger or pickup icon depending on taxi_mode
	bgt show_dropoff
	ldx #passenger
	bra now_draw_pass
show_dropoff:
	ldx #dropoff
now_draw_pass:
	Wait_T1			; Wait for that move we did aaaaaages ago! (NOTE: It's probably done and we can skip this...)
	lda #5
	sta <VIA_t1_cnt_lo	; Reset scale for draw
	bsr Draw_VL_mode	; And draw
no_passenger_pt:
	
	; Draw passenger UI icon if we have someone onboard :)
	lda taxi_mode
	blt nobody_onboard
	FastZeroRef		; Back to origin
	lda #140
	sta <VIA_t1_cnt_lo	; Reset scale for mooooove
	;lda #100
	;ldb #-85
	lda #-100
	ldb #85
	FastMoveTo_d		; Move!
	ldx #passenger
	Wait_T1			; Wait for that move
	lda #5
	sta <VIA_t1_cnt_lo	; Reset scale for draw
	bsr Draw_VL_mode	; And draw
nobody_onboard:

	; Draw combo level ticks
	lda combo_level
	beq no_combos_yo
	sta scratch
	FastZeroRef
	lda #120
	sta <VIA_t1_cnt_lo	; Scale for move
	lda #-127
	ldb #-90
	FastMoveTo_d
	lda #70
	Wait_T1
	sta <VIA_t1_cnt_lo	; Scale for draw
next_cl:
	ldx #wee_flag
	FastDraw_VLc
	dec scratch
	bne next_cl	
no_combos_yo:
	
	; Check if ship's over fuel depot
	lda current_fuel_lm	; grab fuel depot's landmark id
	asla			; x4 (these records are 4 bytes)
	asla
	adda #2			; Add another 2 to step over the coord pair!
	leax a,y		; step x
	lda ,x+			; a=ideal planet rot (and step x to shipy)
	cmpa planet_rot		; Rot OK?
	bne no_fuel_hit
	lda ,x			; a=landmark y
	
	cmpa shipy		; compare to ship y
	bgt ship_below2		; Check we're within #CLOSENESS of the actual landmark
	lda shipy
	suba ,x
	cmpa #CLOSENESS
	lbne no_pass_hit
	bra re_roll2
ship_below2:
	suba shipy
	cmpa #CLOSENESS	
	lbgt no_pass_hit
re_roll2:			; If we got here, we hit the fuel depot!
	ldd #0
	std combo_bonus		; Kill combo bonus
	sta combo_level
	bsr FixedRandom_3	; Pick a new depot! Roll a die
	anda #3			; Clamp 0-3
	cmpa current_pass_lm	; Reroll if we just picked the pickup point!
	beq re_roll2
	cmpa current_fuel_lm	; Reroll if we just picked the point we're just over!
	beq re_roll2
	sta current_fuel_lm	; Write it	
	ldb fuel		; Backup old fuel amount for a sec
	stb scratch
	ldb #MAX_FUEL		; Refuel them
	stb fuel
	subb scratch		; Amount to charge them!
	clra			; Set the high byte of D to zero
	std scratch16
	ldd cash		; Charge them for the fuel :)
	subd scratch16
	bge cash_ok		; Clamp to zero
	ldd #0
cash_ok:	
	std cash
	ldu #cash_ascii+1	; Convert updated score to ASCII
	bsr bin2ascii		
	ldx #sfx_fuel		; Play the sound effect
	jsr sfx_playsound
	bra no_pass_hit		; If we just fuelled, we can safely skip the pickup check
no_fuel_hit:

	; Check if ship's over pickup/dropoff point
	lda current_pass_lm
	asla
	asla
	adda #2
	leax a,y
	lda ,x+
	cmpa planet_rot		; Rot OK?
	bne no_pass_hit
	lda ,x			; a=landmark y
	cmpa shipy		; compare to ship y
	bgt ship_below		; Check we're within #CLOSENESS of the actual landmark
	lda shipy
	suba ,x
	cmpa #CLOSENESS
	bne no_pass_hit
	bra re_roll3
ship_below:
	suba shipy
	cmpa #CLOSENESS	
	bgt no_pass_hit
re_roll3:			; If we got here, we hit the pickup/dropoff point
	bsr FixedRandom_3	; Roll a die
	anda #3			; Clamp 0-3
	cmpa current_pass_lm	; Reroll if we just picked the pickup point!
	beq re_roll3
	cmpa current_fuel_lm	; Reroll if we just picked the fuel point
	beq re_roll3
	sta current_pass_lm	; Write it
	lda taxi_mode		; Toggle pickup/dropoff mode
	nega
	sta taxi_mode
	bgt was_pickup		; No reward for pickups
	ldx #sfx_dropoff	; Play the dropoff sound effect
	jsr sfx_playsound
	ldd cash		; Pay them :)
	addd #DROPOFF_REWARD
	addd combo_bonus
	std cash
	ldu #cash_ascii+1	; Convert updated score to ASCII
	bsr bin2ascii
	ldd combo_bonus		; Now bump the combo bonus
	addd #COMBO_BUMP
	std combo_bonus
	inc combo_level		; And the convenience var
	bra no_pass_hit
was_pickup:
	ldx #sfx_pickup		; Play the pickup sound effect
	jsr sfx_playsound	
no_pass_hit:

	jsr sfx_doframe		; Process sfx
	rts
	
; ***** Handle game over: Change state *****
game_over:
	ldx #GameOverInit	; Request state change
	ldy #GameOverFrame
	bsr ChangeState
	rts
