
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;< Spudster's Revenge - a Play in 3 acts							<
;> by Brian Mastrobuono (gauze@dropdead.org)						>
;< copyright 2002-2014 GNU GPL licensed, use as you wish as long as <
;> your changes in source form are made public					  >
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; best viewed with vim :set ts=4  (www.vim.org)
	title "Spudster's Revenge"
;		BIOS ROUTINES and other crap
	include "vectrex.i"
;	include "vecvox.i"
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;			VARIABLES
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
current_song equ music8	; junk.

;	data
;	org $C880
;;; player (Spud) values
score 		equ $C880		;7 bytes as defined in BIOS routine Add_Score_?
level 		equ score+7
spuds_left 	equ level+1
spud_ypos 	equ spuds_left+1  ; y
spud_xpos	equ spud_ypos+1   ; x
spud_coor	equ spud_ypos	 ; for Obj_Hit routine load into Y-reg
spudstate 	equ spud_xpos+1 
mollystate 	equ spudstate+1
spud_start 	equ mollystate+1

; missle
arrow_y 	equ spud_start+2  ; y
arrow_x 	equ arrow_y+1	 ; x
arrow_coor  equ arrow_y		  ; for Obj_Hit routines load into X
;								this routine take 2 bytes args

intlevel 	equ arrow_x+1
brightdir 	equ intlevel+1
coord		equ brightdir+1
count		equ coord+2
dec_score	equ count+1
highscore	equ	dec_score+7
SpudRot		equ highscore+7
sfx_pointer equ	SpudRot+1
sfx_status  equ	sfx_pointer+1
vox_addr	equ sfx_status+1
currentframe equ vox_addr+2

;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;@			CONSTANTS
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
MINBRIGHT 	equ 20
MAXBRIGHT	equ 100

;]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]
;|			 SETTING UP AND MAIN BLOCK				  |
;[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[

;; *** Init block
	code
	org	0
	fcc	"g GCE 1982"
	fcb	$80
	fdb	current_song
	fdb	$f850
	fcb	$30		; X
	fcb	   -$70		; Y
	fcc	"SPUDSTER'S REVENGE"
	fcb	$80
	fcb		$0
;;# end of magic init block.
;	end	

	jsr 	setup			; sets up what hardware to use and stuff
restart
	jsr		start
	jsr 	titlescreen		; wait for button press here before start
	jsr		arrow_create	; create an arrow
;
main
	jsr 	Wait_Recal
	jsr 	Intensity_3F
	lda		#127
	jsr 	set_scale 	
	lda 	#0
	jsr		guys_left
	jsr		show_score
;
;	jsr		sound_update
	jsr 	joystick_crap
	jsr 	button_push
;
;

; SEE IF IT'S POSSIBLE TO 'SCORE'
	lda		spud_xpos
	cmpa	#53				; right next 2 molly
	blt		cantscore
	jsr		check_if_score
cantscore
	jsr		draw_post
	jsr		draw_molly
	jsr		draw_mollysface ; TODO
	jsr		draw_mollyslegs 
	jsr		draw_spud
	jsr		draw_spudslegs 	; TODO

	jsr		Reset0Int
	jsr		draw_arrow

; collision
	lda		#127
	jsr 	set_scale 	
	ldx		arrow_coor
	ldy		spud_coor
	lda		#17		; MUST fix ; spud h+arrow h/2
	ldb		#10		; MUST fix ; spud w+arrow h/2
	jsr		Obj_Hit
	blo		yer_hit
	bra		yer_ok
yer_hit
	jsr		got_hit
	jsr 	arrow_create
yer_ok

; move the arrow for next frame (or not) 
	lda 	currentframe	; check frame countdown
	cmpa	#0
	bne		arrow_done ; still counting frames if false
	lda		level			; reseting frame counter
	ldx		#time_frames
	lda		a,x
	sta		currentframe    ; ^^
	lda		level
	ldx		#speed_distance
	lda		a,x
arrow_speed
	jsr		move_arrow 
	deca 	
	bne 	arrow_speed	
	jsr 	arrow_in_bounds  ; check if it's at legal pos
arrow_done
	dec		currentframe
; checking for game over condition...
	lda		spuds_left
	lbne	main		; jump to top
	jmp		gameoverloop

; *** end of main ***
;
;#######################################################
;		SUBROUTINES/FUNCTIONS 
;#######################################################

	include	"functions.i"
	include	"sfx.asm"

;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
;			 DATA SECTION
;********************************************************
	include "data.i"
;	include "sound2.asm"

	end

