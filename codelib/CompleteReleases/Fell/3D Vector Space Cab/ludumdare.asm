; Main controller / game state manager
; By Fell^DSS, Ludum Dare 38 \p/

; ****** CONSTANTS & DEFINES ******
VOICE_LENGTH	equ 100

	include 'memmap.i'		; Here be all ram location definitions
	include 'vectrex.i'		; Sys defines (thanks Malban!)
	include 'macros.i'		; Drawing-related macros
	
; ****** CART HEADER ******
	org 0				; Force to address 0
	db "g GCE DSS ",$80		; 1st 5 bytes = highly sensitive magic string!
	dw silence			; Boot music address
	db -4,40,80,-62			; height (neg bcos text), width, y, x
	db "3D VECTOR SPACE CAB",$80	; Cart title
	db 0				; End of header

; ****** ENTRYPOINT ******
main:	
	; Init high score if cold boot, otherwise leave it be
	lda Vec_High_Score		; Grab first char of Vec_High_Score
	cmpa #104			; Already got an Imperial Standard Triangular Currency Unit?
	beq warm_start			; Then it's a warm start, leave the score alone!
	ldd #0
	std high_score
warm_start:
	
	; Just play the sample for the first VOICE_LENGTH frames
	ldd #0
	std scratch16
	ldd #taxisample_data_start  	; position of sample 
	ldx taxisample_length 		; length of sample 
	jsr init_digit_sound   		; init it! 
	clra
	sta digit_looping 
	lda #-5
	sta Vec_Text_Height	
	lda #200			; Set scale for everything
	sta <VIA_t1_cnt_lo
voice_hack:
	jsr wait_recal_digitj		; Wait for BIOS recal
	lda #127			; Set intensity
	jsr intensity_a_digitj
	lda #30				; Move...
	ldb #-5
	jsr move_to_d_digitj
	ldx #ship			; Draw the wee ship
	jsr draw_vlc_digitj
	FastZeroRef			; Back to origin
	clra
	ldb #-37
	jsr move_to_d_digitj		; Move to draw text
	ldd #title_text
	jsr Print_Str_digit		; Draw it
	ldd scratch16			; Tick the framecount and get outta here if it's time
	addd #1
	std scratch16
	cmpd #VOICE_LENGTH
	bne voice_hack
	
	; Set default gamestate
	ldx #SplashInit
	ldy #SplashFrame
	bsr ChangeState
	
	; Main frame loop
frame_loop:				; Frame start
	bsr Wait_Recal			; Wait for BIOS recal
	jsr [state_frame]		; Run the frame function for current state
	bra frame_loop			; looop

; ****** STATE MANAGER ******	
; Change state
; Expects: x=state init function, y=state frame function
ChangeState:
	sty state_frame
	jsr ,x
	rts
	
; ***** GLOBAL FUNCTIONS ******
	include 'funcs_biosfixes.i'	; Some bugfixed / macro-fied BIOS routines
	include 'funcs_sfx.i'		; AYFX player
	include 'funcs_utils.i'		; Misc utes
	include 'funcs_joystick.i'	; Stick funcs
	include 'funcs_digitalaudio.i'	; Malban's sample player
	
; ***** GAME STATES ******
	include 'state_splash.i'	; Splash screen
	include 'state_game.i'		; Main game state
	include 'state_gameover.i'	; Game over state
	
; ****** DATA ******
	include 'data_silence.i'	; Silent music
	include 'data_gamegfx.i'	; Ship, landmark icons, the lovely planet <3
	include 'data_sfx.i'		; Sound effects
	include 'data_gameover.i'	; Game over state data
	include 'data_splashstate.i'	; Splash state data
	include 'data_taxisample.i'	; Taxi sample

text: 
	db "DIGITAL",$80
	