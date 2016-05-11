;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;< Spudster's Revenge - a Play in 3 acts                            <
;> by Brian Mastrobuono (gauze@dropdead.org)                        >
;< copyright 2002-2013 GNU GPL licensed, use as you wish as long as <
;> your changes in source form are made public                      >
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; best viewed with vim :set ts=4  (www.vim.org)
;
;#######################################################
;		SUBROUTINES/FUNCTIONS
;#######################################################

arrow_create
	lda		#127
	sta		arrow_y		; height
	jsr 	Random		; 
;	anda	#%01111111	; mask off 1st bit == positive numbers only
	sta		arrow_x  	; set random x coord
	rts
	
; display score, once per frame ...
show_score
	ldu		#score
	lda		#-10
	ldb		#-100
	jsr		Print_Str_d		
	rts
;
show_highscore
	ldu		#highscore
	lda		#100
	ldb		#-100
	jsr		Print_Str_d		
	rts
;
inc_score
	ldd		dec_score ; decimal score stored as a reference
	addd	#1
	std		dec_score
	lda		#1
	ldx 	#score
	jsr		Add_Score_a		

	lda		level		; level
	ldb		#50			; 50
	mul					; times 
	cmpd    dec_score	; if register > memory branch
	bgt		nope
	inc 	level	
nope	
	rts
;
check_if_score
	jsr		Read_Btns
	lda		Vec_Button_1_1
	beq		no_score
	jsr		inc_score
	lda		#10
	sta		mollystate
	sta		spudstate
no_score
	rts
;
level_up
	inc		level
; add more stuff to increase game speed?
	rts
;
draw_arrow
	lda		#127
	jsr		set_scale	
	lda		arrow_y
	ldb		arrow_x
	jsr		Moveto_d
	ldx		#Arrow		
	jsr 	Draw_VLc
	rts
;

arrow_in_bounds
; start of arrow bounds checking 	
; x test
	lda		arrow_x
	cmpa	#-127
	bne		x_ok
	bsr		arrow_create
x_ok
; y test
	lda		arrow_y
	bpl		y_ok
	bsr		arrow_create
y_ok
	rts

; end of arrow bounds checking
draw_post
	lda		#127
	jsr		set_scale	
	ldd		#0
	jsr		Moveto_d
	jsr		Intensity_3F
	ldx		#Post	
	jsr 	Draw_VLp
	rts
;
draw_molly
	lda		#83
	jsr 	set_scale 	
	ldx		#Molly	
	jsr 	Draw_VLp
	rts
;
draw_mollysface
; TODO
; include bow animation?
	lda 	#127
	jsr		set_scale
	ldx		#MollysFace
	lda 	mollystate   	; if state !=1
	beq		nothumpedface	; branch
	ldx		#MollysFaceHum
nothumpedface
	jsr		Draw_VLp
	rts
;
draw_mollyslegs
	ldx		#MollysLegs
	lda 	mollystate   ; if state !=1
	beq		nothumpeds	 ; branch
	ldx		#MollysLegsHum
	dec		mollystate
nothumpeds
	lda 	#83
	jsr		set_scale
	jsr		Draw_VLp
	rts
;

draw_spud
	lda		#127	
	jsr 	set_scale 	
	jsr		Reset0Int
	lda		spud_ypos
	ldb		spud_xpos
	jsr 	Moveto_d
	ldx		#Spud	
	lda 	spudstate   	; if state !=1
	beq		nothumpedspud	; branch
	ldx		#SpudHump
nothumpedspud
	jsr 	Draw_VLp
	rts
;
draw_spudslegs		; wip
	lda 	#127
	jsr		set_scale
	ldx		#SpudsLegsWalk1
	lda		spud_xpos
	anda	#%000000001  ; mask 1 bit testing for odd number ...
	bne		walk1
	ldx		#SpudsLegsWalk2
walk1
	lda 	spudstate   ; if state !=1
	beq		nothumping	 ; branch
	ldx		#SpudsLegsHum
	dec		spudstate
nothumping
	jsr		Draw_VLp
	rts
;
sound_update
; TODO
	rts
;

move_arrow 
	dec		arrow_x
	dec		arrow_y
	rts
;
button_push
	
	rts
;

joystick_crap
	jsr		Joy_Digital
	lda     Vec_Joy_1_X  
	beq		done_moving		;end
	bmi		going_left
;
going_right
	lda 	spud_xpos
	cmpa	#55
	bge		done_moving 		; if >= 52 don't move.
	lda 	spud_xpos
	adda	#3
	sta		spud_xpos
	bra		done_moving		
;
going_left
	lda		spud_xpos
	cmpa	#-127
	beq		done_moving
	lda		spud_xpos
	suba	#3
	sta		spud_xpos
	bra		done_moving
done_moving
	rts
;

; 	Lost a guy ...
got_hit
	dec		spuds_left
	lda		#127
	sta		count
	inc		spudstate
;play sound
;   ldx #ploop
;   stx sfx_pointer
;   lda #$01
;   sta sfx_status
	
;
loopy
;	jsr sfx_doframe
	jsr Wait_Recal


	lda		#127	
	jsr 	set_scale 	
	jsr 	Intensity_5F
	lda		#30
	ldb		#-27
	jsr 	Moveto_d
	ldx		#letter_O	
	jsr 	Draw_VLp
	jsr		Reset0Ref
	lda		#30
	ldb		#40
	jsr 	Moveto_d
	ldx		#letter_W
	jsr 	Draw_VLp

	jsr		Reset0Ref
;	lda		#-10
;	ldb		#96
;	std		Vec_Text_HW
;	ldu		#owstr	
;	lda 	#0
;	ldb		#36	
;	jsr 	Print_Str_d 	 
; shrink spud	
	lda		#127
	jsr 	set_scale 	
	lda		spud_ypos
	ldb		spud_xpos
	jsr 	Moveto_d
	lda		count
	jsr 	set_scale 	
	ldx		#SpudDead
	jsr 	Draw_VLp
;	jsr		Reset0Ref
	lda		count
	jsr 	set_scale 	
;	lda		spud_ypos
;	ldb		spud_xpos
;	jsr 	Moveto_d
	ldx		#SpudsLegsWalk2
	jsr 	Draw_VLp

	dec		count
	dec		count
	dec		count
	dec		count
	dec		count
	dec		count
	bmi		deadcont
	bne 	loopy  ; loop
deadcont
	lda		#20		; reload counter
	sta		count
deadStar
	jsr 	Wait_Recal
	lda		#127
	jsr 	set_scale 	
	lda		spud_ypos
	ldb		spud_xpos
	jsr 	Moveto_d
	jsr		Intensity_3F
	lda		#127
	jsr 	set_scale 	
	ldx 	#SpudDeadFinal
	jsr		Draw_VLp
	dec 	count
	bne		deadStar
; reset spud position
	lda		spud_start
	sta		spud_xpos
	rts
;
gameoverloop
	jsr 	Wait_Recal
	jsr 	Intensity_3F
	ldu		#gameoverstr
	lda		#10
	ldb		#206
	jsr 	Print_Str_d 
	jsr		show_score
	ldx		#score			; update highscore if needed
	ldu		#highscore
	jsr		New_High_Score
	ldu		#highscorestr
	lda		#127
	ldb		#206
	jsr 	Print_Str_d   	; print highscore label
	jsr		show_highscore
	ldx		#lolscore
	ldu		#score
	jsr		Compare_Score
	cmpa	#0
	beq		lol
	ldb		$FF				; pause a little before taking button input
	jsr		Delay_b
	jsr 	Read_Btns
	lda     Vec_Button_1_1
	ora     Vec_Button_1_2
	ora		Vec_Button_1_3
	ora		Vec_Button_1_4
	lbne	restart
	bra		gameoverloop
;
lol	
	ldu		#lolstring
	lda		#10
	ldb		#206
	jsr 	Print_Str_d 
	lda 	#127
	jsr		set_scale
	ldx		#lolgraphic
	jsr		Draw_VLp
	bra		lol
	rts
	
	
;
titlescreen
	lda		#0
	jsr		Read_Btns_Mask
	lda		Vec_Button_1_1
	bne 	main	
 	lda     Vec_Button_1_2
   	beq    	no_btn_psh
   	lda     Vec_Button_1_3
   	beq    	no_btn_psh
   	lda     Vec_Button_1_4
   	beq    	no_btn_psh
   	jmp     hidden_msg          ; all 3 buttons pushed
;
no_btn_psh
	clra
	clrb
	jsr		Wait_Recal
	jsr		Intensity_5F
	ldu		#titlestring
	lda		#$30
	ldb		#-$70
	jsr		Print_Str_d
;
;; start variable intensity routine NEED 2 FIX
	lda		brightdir		; Load variable saying which
	bne		up			; direction we're going & test
down	
	dec		intlevel		; load the 'level' of bright
	lda		intlevel		
	cmpa	#MINBRIGHT		;compare it to our threshhold
	beq		changedir2up		; if yes: 
	bra		finish_pulse
;
up
	inc		intlevel
	lda		intlevel
	cmpa	#MAXBRIGHT
	beq		changedir2down
	bra		finish_pulse
;
changedir2up
	lda		#1
	sta		brightdir
	bra		finish_pulse
;
changedir2down
	lda		#0
	sta		brightdir
;
finish_pulse
	lda		intlevel
	jsr		Intensity_a		; set intensity here
; end intensity routine
	ldu		#startstring
	lda		#-50
	ldb		#-110
	jsr		Print_Str_d
	bra 	titlescreen	; if not pushed ... loop
	rts

;
play_song
	ldb		#1	;movqi: #1 -> R:b
	stx		current_song	;movhi: R:x -> _current_song
	sta		brightdir			; direction 0 down 1 up 
	jsr		Do_Sound
	rts		; return from function
;
setup
	lda 	#1 	; enable  joystick 1's x axis, disable all others.
	sta 	Vec_Joy_Mux_1_X 	
	ldx 	#highscore
	jsr		Clear_Score ; Bios routine yay
	lda		#10
	sta		intlevel			; intensity level
	lda 	#0 				; disable for Joy Mux's
	sta 	Vec_Joy_Mux_1_Y
	sta 	Vec_Joy_Mux_2_X
	sta 	Vec_Joy_Mux_2_Y
	jsr 	Joy_Digital 	; set joymode, not analog.
	lda 	#0
;	jsr		vox_init
	;jsr 	Read_Btns		; no idea why this is here.
	;jsr 	Wait_Recal
	rts		; return from function

;
start
	lda 	#3
	sta 	spuds_left
	ldx 	#score
	jsr		Clear_Score
	lda		#0
	sta 	spudstate
	sta 	mollystate
	ldd 	#0
	std		dec_score
	lda 	#1	
	sta 	level
    ldx     #time_frames ; setting initial frame counter
    lda     a,x
    sta     currentframe    ; ^^
	lda		#-127
	sta		spud_start
	sta 	spud_xpos
	lda		#20
	sta		spud_ypos
	rts

; show hidden msg requires reset to escape
hidden_msg
	jsr		Intensity_3F
	jsr		Wait_Recal
	ldu		#hidden1str
	lda		#0			
	ldb		#-60	
	jsr 	Print_Str_d 	
	ldu		#hidden2str	
	lda		#-20	
	ldb		#-76
	jsr 	Print_Str_d 
	bra		hidden_msg ; no escape
;
;start_one_vectrex_round
;	ldb		#200	;movqi: #200 -> R:b
;	tfr 	b,dp 	; set dp to b (dp is direct page reg)
;	pshs 	y 	; save y register to HW stack
;	ldu		current_song	;movhi: _current_song -> R:u
;	jsr 	Init_Music_chk
;	puls 	y 	; restore y register
;	jsr 	Wait_Recal 	; wait_recal
;	jsr 	Do_Sound 	; do_sound
;	rts		; return from function

guys_left 	; display number of 'guys' left
	jsr		Intensity_3F
	lda		#-10 	; fix
	ldb		#65 	; change
	std		coord
	lda		#$69
	ldb		spuds_left	
	ldx 	coord
	jsr		Print_Ships
	rts
;
set_scale		;scales to content of reg A
	sta		$D004	; VIA t1 cnt lo register.
	rts

