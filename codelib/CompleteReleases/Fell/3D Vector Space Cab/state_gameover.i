; Game over state
; By Fell^DSS, Ludum Dare 38 \p/

; ***** CONSTANTS *****
TIMEOUT		equ 1000		; 20 secs

; ***** MEMORY MAP *****
framecount 	equ GAME_RAM_TOP	; 16 bit! How many frames have we been showing this screeen?
is_high_score	equ framecount+2	; Did the player just get a high score?

; ***** INIT *****
GameOverInit:
	clr intens		; Note: reusing this var from gamestate! (also the score ofc)
	clr is_high_score
	
	ldd #0			; Reset framecount
	sta framecount
debug_me_bro:
	ldd cash		; Check for a new high score
	cmpd high_score
	ble no_new_hs
	std high_score
	lda #1
	sta is_high_score	; Set this 'ere flag if so
	ldx #sfx_highscore	; Play the high score sound effect
	bra now_play
no_new_hs:
	ldx #sfx_death		; Play the normal death sound effect
now_play:
	bsr sfx_playsound
	
	ldd high_score		; Convert high score to ASCII
	ldu #high_score_asc+1
	bsr bin2ascii
	lda #104		; Currency sign...
	sta high_score_asc
	lda #$80		; ... and termie
	sta high_score_asc+6
	
	ldx #Vec_High_Score	; Copy our HS to machine HS
	ldy #high_score_asc
next_byte:
	lda ,y+
	cmpa $80
	sta ,x+
	beq mischief_managed
	bra next_byte
mischief_managed:

	rts

; ***** FRAME *****
GameOverFrame:
	ldd framecount		; Tick framecount
	addd #1
	cmpd #TIMEOUT		; Reached timeout? Go to splash state if so
	bne no_timeout
	ldx #SplashInit
	ldy #SplashFrame
	bsr ChangeState
	rts
no_timeout:
	std framecount

	lda intens		; Set intensity
	cmpa #MAX_INTENSITY
	bge dont_step_intensity2
	adda #FADE_SPEED
	sta intens
dont_step_intensity2:
	FastIntensity_a

	lda #100		; Set scale
	sta <VIA_t1_cnt_lo
	
	lda #-50		; Draw Game Over text
	ldb #-40
	FastMoveTo_d
	ldu #gameover_text	; u=pointer to ASCII cash
	Wait_T1			; Wait for de beam
	bsr Print_Str		; Print the cash score
	
	FastZeroRef		; Draw final score
	lda #-62
	ldb #-30
	FastMoveTo_d
	ldu #cash_ascii		; u=pointer to ASCII cash
	Wait_T1			; Wait for de beam
	bsr Print_Str		; Print the cash score
	
	FastZeroRef		; Draw high score line
	lda #-80		; Print the label
	ldb #-50
	FastMoveTo_d
	lda is_high_score
	beq no_new_hs2
	ldu #new_hs_label
	bra now_print
no_new_hs2:
	ldu #hs_label
now_print:
	Wait_T1
	bsr Print_Str
	FastZeroRef		; Print the high score
	lda #-92
	ldb #-30
	FastMoveTo_d
	ldu #high_score_asc
	Wait_T1
	bsr Print_Str
	
	FastZeroRef		; Draw the crashed UFO :)
	lda #40
	ldb #-40
	FastMoveTo_d
	ldx #crashed_ufo_pic
	Wait_T1
	bsr Draw_VL_mode
	
	lda intens		; Skip input / call to action text if not faded in yet
	cmpa #MAX_INTENSITY
	blt dont_change_state	
	
	FastZeroRef		; Draw "press any button"
	lda #-120
	ldb #-73
	FastMoveTo_d
	ldu #cta_text		; u=pointer to ASCII cash
	Wait_T1			; Wait for de beam
	bsr Print_Str		; Print the cash score
	
	jsr GetJoystick		; Read the joystick
	lda joy_b		; Check for a button press...
	beq dont_change_state
	ldx #GameInit		; ...and request state change if they hit button 1
	ldy #GameFrame
	bsr ChangeState
dont_change_state:

	jsr sfx_doframe		; Process sfx
	rts
	