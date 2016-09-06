; this file is part of vectrex frogger, written by Malban
; in March-April 1998
; all stuff contained here is public domain
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this file contains subroutines declared as 'intermissions', like          ;
; game over, level done, new life...                                        ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
;***************************************************************************
; does ROUND_STARTUP
; sets score text size
; sets intensity to $60
; prints score, level frogs
; this routine takes about 10000 cycles...
; damn the stupid text output!!!
print_score:
                direct  -1
                LDD     #SCORE_TEXT_SIZE   ; load score text size
                STD     Vec_Text_HW        ; poke it to ram location
                ROUND_STARTUP
                JSR     Intensity_5F
                LDU     #score_string      ; load text start to U
                LDA     #$20               ; for the $80
                STA     12,U               ; we store temporarily Spaces
                STA     25,U               ; ...
                LDD     #(SCORE_YPOS*256+SCORE_XPOS); load the position
                JSR     Print_Str_d        ; and do a simple print_str_d
                LDU     #score_string      ; load text start to U
                LDA     #$80               ; now we restore the $80
                STA     12,U               ; otherwise the scoring
                STA     25,U               ; will be busted
                RTS                        ; bye
;***************************************************************************
; death intermission
frog_dead:
                direct $c8
                LDA     #50
                STA     counter
                MY_QUIT                    ; be quiet
                ; fix the current frog position for 'dead frog'
                LDD     frog_pos           ; load old pos to B
                SUBA    current_frog_offset; korrekt the old offset y
                SUBB    current_frog_offset+1; korrekt the old offset x
                ADDA    frogger_up_offset  ; korrekt the new offset y
                ADDB    frogger_up_offset+1; korrekt the new offset x
                STD     frog_pos           ; store it back

                PLAY_SOUND death_sound     ; well, have a guess
                LDA     #30                ; counter for in level death sequence
death_screen_loop1:
                PSHS    A                  ; remember the counter
                ROUND_STARTUP              ; this is a new round...
                JSR     Intensity_7F
                MY_GAME_SCALE              ; set the scale factor for positioning
                LDD     frog_pos           ; load current frog position to D
                JSR     Moveto_d           ; go to that position
                _SCALE (SCALE_FACTOR_SPRITE); scale factor for frog
                LDX     #frog_dead_pic     ; load current frog sprite, dead here...
                JSR     Draw_VLc           ; and draw it
                CLRA                       ; mystery, for draw VL makro :-)
                JSR     entry_timer_count_down; draw_objects, same as on timer countdown
                PULS    A                  ; get our round counter back...
                DECA                       ; decrease it
                BNE     death_screen_loop1 ; and loop until when not zero yet

                LDA     level_score        ; jumps allready jumped in this level
                LDB     #10                ; times 10
                MUL                        ;
                TFR     B,A                ; must be in A :-(
                LDX     #no_score_string   ; load level address
                CLR     Vec_Misc_Count     ; must be zero for Add_Score_a (left to $ff in vector routine)
                JSR     Add_Score_a        ; add to score(level)
                JSR     Read_Btns          ; get button status once, since only
                                           ; differences are noticed
                LDD     #LITTLE_TEXT_SIZE  ; load score text size
                STD     Vec_Text_HW        ; poke it to ram location
                MY_QUIT                    ; be quiet
                PLAY_SOUND yankee
                LDU     #morph_death1      ; load address of morph structure
                JSR     set_up_morphing    ; and initialize a new morphing
death_screen_loop:
                ROUND_STARTUP              ; this is a new round...
                LDU     #died              ; load text start to U
                JSR     Print_List
                LDD     kind_of_death      ; how did we die?
                ADDD    #cause_strings     ; load text start to U
                                           ; Get A=Y, B=X (D=AB) coordinate
                TFR     D,U                ; load text start to U
                LDD     #(-$40*256)+(lo(-$67))
                JSR     Print_Str_d        ; Print the string
                _ZERO_VECTOR_BEAM          ; back to zero
                LDA     morph_status       ; look of morphing is complete
                BEQ     end_of_death_morph ; don't morph anymore
                JSR     do_one_morph_step_16; does one morph step, changing of vectors
go_on_anyway1:
                LDA     #$CE               ; /Blank low, /ZERO high
                STA     VIA_cntl           ; needed, since print_str leaves ZERO low!
                LDX     #current_morph_vectorlist ; load the morph vector list to X
                _SCALE  ($30)              ; scale it correctly
                JSR     Draw_VLc           ; and draw the vectorlist
                JSR     Read_Btns          ; get button status
                CMPA    #$00               ; is a button pressed?
                BEQ     death_screen_loop  ; no, than stay in init_screen_loop
exit_to_reinit:
                JSR     DP_to_C8
                direct  $C8

                JMP     reinit_level       ; last JSR can allways be a jump
end_of_death_morph:
                direct  $d0
                DEC     counter
                BNE     go_on_anyway1
                BRA     exit_to_reinit
;***************************************************************************
; frog reached home intermission
frog_in_home:
                direct  $c8
                CLR     Vec_Misc_Count     ; must be zero for Add_Score_a (left to $ff in vector routine)
                LDA     #50
                STA     counter
                MY_QUIT                    ; be quiet
                LDA     frog_bonus         ; load bonus state
                ANDA    #FLY_BONUS         ; is there a fly bonus
                BEQ     no_fly_bonus       ; if no jump
                LDA     #200               ; otherwise load 200
                LDX     #no_score_string   ; load score address
                JSR     Add_Score_a        ; add to score
no_fly_bonus:
                LDA     frog_bonus         ; load bonus state
                ANDA    #GIRL_BONUS        ; is there a girl bonus
                BEQ     no_girl_bonus      ; if no jump
                LDA     #200               ; otherwise load 200
                LDX     #no_score_string   ; load score address
                JSR     Add_Score_a        ; add to score
no_girl_bonus:
                LDD     my_timer           ; load the timer value
                ; here starts the timer count down loop
timer_bonus:
                direct -1
                STD     my_timer           ; store the timer value
                LDA     #10                ; add 10 for each 2 timer ticks
                LDX     #no_score_string   ; load level address
                CLR     Vec_Misc_Count     ; must be zero for Add_Score_a (left to $ff in vector routine)
                JSR     Add_Score_a        ; add to score(level)

                ROUND_STARTUP
                JSR     Intensity_7F
                CLRA                       ; mystery, for draw VL makro :-)
                JSR     entry_timer_count_down ; draw_objects
                PLAY_SOUND triller2        ; add some accoustic
                LDD     my_timer           ; load the timer value
                SUBA    #$2                ; count it down by $20
                BPL     timer_bonus        ; if not minus... go on
                LDA     level_score        ; add jumps times 10 (forward)
                LDB     #10                ; could be fixed,
                MUL                        ;
                TFR     B,A                ; must be in A :-(
                LDX     #no_score_string   ; load level address
                CLR     Vec_Misc_Count     ; must be zero for Add_Score_a (left to $ff in vector routine)
                JSR     Add_Score_a        ; add to score(level)
                JSR     Read_Btns          ; get button status once, since only
                                           ; differences are noticed
                LDD     #LITTLE_TEXT_SIZE  ; load score text size
                STD     Vec_Text_HW        ; poke it to ram location
                PLAY_SOUND frog_home_sound
                LDU     #morph_home1       ; load address of morph structure
                JSR     set_up_morphing    ; and initialize a new morphing
home_screen_loop:
                ROUND_STARTUP
                LDU     #reached_home      ; load text start to U
                                           ; Get A=Y, B=X (D=AB) coordinate
                LDD     #(-$40*256)+(lo(-$80))
                JSR     Print_Str_d        ; Print the string
                LDA     frog_bonus         ; was there a fly bonus?
                ANDA    #FLY_BONUS         ;
                BEQ     no_fly_bonus2      ; if not jump
                LDU     #fly_bonus_text    ; load text start to U
                                           ; Get A=Y, B=X (D=AB) coordinate
                LDD     #(-$50*256)+(lo(-$80))
                JSR     Print_Str_d        ; Print the string
no_fly_bonus2:
                LDA     frog_bonus         ; was there a girl bonus?
                ANDA    #GIRL_BONUS        ; if not jump
                BEQ     no_girl_bonus2     ;
                LDU     #girl_bonus_text   ; load text start to U
                                           ; Get A=Y, B=X (D=AB) coordinate
                LDD     #(-$60*256)+(lo(-$80))
                JSR     Print_Str_d        ; Print the string
no_girl_bonus2:
                _ZERO_VECTOR_BEAM          ; back to zero
                LDA     morph_status       ; look of morphing is complete
                BEQ     end_of_home_morph  ; don't morph anymore
                JSR     do_one_morph_step_16; does one morph step, changing of vectors
go_on_anyway2:
                LDA     #$CE               ; /Blank low, /ZERO high
                STA     VIA_cntl           ; needed, since print_str leaves ZERO low!
                LDX     #current_morph_vectorlist ; load the morph vector list to X
                _SCALE  ($30)              ; scale it correctly
                JSR     Draw_VLc           ; and draw the vectorlist
                JSR     Read_Btns          ; get button status
                CMPA    #$00               ; is a button pressed?
                BEQ     home_screen_loop   ; no, than stay in init_screen_loop
                BRA     end_of_home
end_of_home_morph:
                DEC     counter
                BNE     go_on_anyway2
end_of_home:
                LDA     no_score_string+1  ; load the 5th digit
                CMPA    high_check         ; changed from last check?
                BEQ     no_new_life        ; if not go on
                STA     high_check         ; otherwise stroe new value to check
                INC     no_frogs           ; incraese frog lifes
                JSR     new_life_intermission; and do an intermission
no_new_life:
                LBRA    exit_to_reinit
;***************************************************************************
level_complete:
                direct $c8
                CLR     Vec_Misc_Count     ; must be zero for Add_Score_a (left to $ff in vector routine)
                MY_QUIT                    ; be quiet
                LDA     #250
                LDX     #no_score_string   ; load level address
                JSR     Add_Score_a        ; add to score(level)
                LDA     #250
                LDX     #no_score_string   ; load level address
                JSR     Add_Score_a        ; add to score(level)
                LDA     game_level         ; load this level to A
                PSHS    A                  ; remember it...
                ; load 'LEVEL DONE' level number
                LDA     #((level_done_data-level1_data)/LEVEL_DATA_LENGTH)
                STA     game_level         ; and store it to game level
                JSR     setup_level        ; set this level up
                JSR     init_new_frog_vars ; and init it
                ; display till button pressed
                PLAY_SOUND level_done_sound
level_loop:
                JSR     print_score
                direct $d0
                LDD     #LITTLE_TEXT_SIZE  ; load score text size
                STD     Vec_Text_HW        ; poke it to ram location
                LDU     #level_complete_text
                LDD     #(-$50*256)+(lo(-$67))
                JSR     Print_Str_d        ; Print the string
                JSR     entry_level_done   ; draw this 'level'
                TST     Vec_Music_Flag     ; test the music flag
                BEQ     level_loop_done    ; if music done, get out of loop
                JSR     Read_Btns          ; get button status
                CMPA    #$00               ; is a button pressed?
                BEQ     level_loop         ; no, than stay in init_screen_loop
level_loop_done:
                PULS    A                  ; restore old game level
                STA     game_level         ; and set it
                LDA     no_score_string+1  ; load the 5th digit
                CMPA    high_check         ; changed from last check?
                BEQ     no_new_life1       ; if not go on
                STA     high_check         ; otherwise stroe new value to check
                INC     no_frogs           ; incraese frog lifes
                JSR     new_life_intermission; and do an intermission
no_new_life1:
                RTS
;***************************************************************************
; and some 'small' intermissions...
; just text, nothing fancy
; the following functions could as well be only one with a
; index pointer to the text to be displayed...
; well, we got space enough, haven't we?
roll_over_intermission:
                direct $d0
                MY_QUIT                    ; be quiet
                JSR     Read_Btns          ; get button status
                LDA     #$ff               ; load a timer, how long the following
                STA     tmp1               ; text will be displayed
roll_over_intermission_loop:
                JSR     print_score
                LDD     #LITTLE_TEXT_SIZE  ; load score text size
                STD     Vec_Text_HW        ; poke it to ram location
                LDU     #roll_over_string  ; string to be printed
                LDD     #(-$10*256)+(lo(-$50))
                JSR     Print_Str_d        ; Print the string
                DEC     tmp1               ; decreas timer,
                BEQ     roll_over_intermission_end; if zero, than we are done
                TST     Vec_Music_Flag     ; test the music flag
                BNE     roll_over_sound_is_playing; if music done, get out of loop
                PLAY_SOUND ta_ta_ta1
roll_over_sound_is_playing:
                JSR     Read_Btns          ; get button status
                CMPA    #$00               ; is a button pressed?
                BEQ     roll_over_intermission_loop ; start another round
roll_over_intermission_end:
                RTS
;***************************************************************************
new_life_intermission:
                direct $d0
                MY_QUIT                    ; be quiet
                JSR     Read_Btns          ; get button status
                LDA     #$ff               ; load a timer, how long the following
                STA     tmp1               ; text will be displayed
                PLAY_SOUND ta_ta_ta2
new_life_intermission_loop:
                JSR     print_score
                LDD     #LITTLE_TEXT_SIZE  ; load score text size
                STD     Vec_Text_HW        ; poke it to ram location
                LDU     #new_life_string   ; string to be printed
                LDD     #(-$10*256)+(lo(-$50))
                JSR     Print_Str_d        ; Print the string
                DEC     tmp1               ; decreas timer,
                BEQ     new_life_end       ; if zero, than we are done
                JSR     Read_Btns          ; get button status
                CMPA    #$00               ; is a button pressed?
                BEQ     new_life_intermission_loop ; start another round
new_life_end:
                RTS
;***************************************************************************
; yepeay... a new high score
new_high_score:
                direct $d0
                MY_QUIT                    ; be quiet
                JSR     Read_Btns          ; get button status
                LDA     #$ff               ; load a timer, how long the following
                STA     tmp1               ; text will be displayed
                PLAY_SOUND ta_ta_ta1
new_high_score_loop:
                JSR     print_score
                LDD     #LITTLE_TEXT_SIZE  ; load score text size
                STD     Vec_Text_HW        ; poke it to ram location
                LDU     #highscore_string  ; string to be printed
                LDD     #(-$10*256)+(lo(-$50))
                JSR     Print_Str_d        ; Print the string
                DEC     tmp1               ; decreas timer,
                BEQ     new_high_score_end ; if zero, than we are done
                JSR     Read_Btns          ; get button status
                CMPA    #$00               ; is a button pressed?
                BEQ     new_high_score_loop; start another round
new_high_score_end:
                RTS
;***************************************************************************
