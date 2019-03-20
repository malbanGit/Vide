; this file is part of Karl Quappe, written by Malban
; in 2016
; all stuff contained here is public domain
;
;
;***************************************************************************
; this routine calculates the new positions
; nothing is returned
; leaves with dp pointing to c8
move_frog: 
                    _DP_TO_C8  
                    lda      froggerInJump                ; is an "old" jump still ongoing? 
                    beq      newJumpPossible 
                    dec      froggerInJump 
                    lda      current_frog_heading 
                    cmpa     #HEADING_LEFT                ; than the last left? 
                    lbeq     continue_left_jump 
                    cmpa     #HEADING_RIGHT               ; than the last right 
                    beq      continue_right_jump 
                    cmpa     #HEADING_UP                  ; than the last up 
                    lbeq     continue_up_jump 
                    cmpa     #HEADING_DOWN                ; than the last down? 
                    lbeq     continue_down_jump 
; if we come here some error occured, ignoring it and querying new move...
newJumpPossible: 
                    LDB      last_joy_x                   ; only jump if last joy pos was zero (needed for testing later) 
                    LDA      Vec_Joy_1_X                  ; load joystick 1 position X to A 
                    STA      last_joy_x                   ; store this joystick position 
                    lBEQ     no_new_xpos                  ; no x joystick input available 
                    BMI      pos_left                     ; joystick moved to left 
pos_right: 
                    TSTB                                  ; test the old joystick position 
                    LBNE     positioning_done             ; was center 
; he y dissi "print JOYSTICK_READ timeHi= $RecalCounterHi timeLow= $RecalCounterLow , X= $Vec_Joy_1_X"
                    LDB      frog_x_band                  ; load old pos to B 
                    CMPB     #12                          ; is it at maximum right position? 
                    lBEQ     positioning_done             ; if so, do nothing 
                    PLAY_SFX  Karl_Jump_Sound 
; PLAY_SFX Karl_Live_Got_Sound
                    lda      #7                           ; animation counter of one jump, so many jump steps are taken, befor 
                    sta      froggerInJump                ; befor another move can be made 
; do from here
; remember x offset in frog.i 
; must also work for girl
                    INC      frog_x_band                  ; for internal checking 
                    LDA      #HEADING_RIGHT 
                    CMPA     current_frog_heading         ; new heading == old heading? 
                    BEQ      continue_right_jump          ; if yes -> we are done 
                    STA      current_frog_heading         ; store it 
                    ldd      frog_pos 
                    SUBA     current_frog_offset          ; korrekt the old offset y 
                    SUBB     current_frog_offset+1        ; korrekt the old offset x 
                    ADDA     frogger_right_offset         ; korrekt the new offset y 
                    ADDB     frogger_right_offset+1       ; korrekt the new offset x 
                    STD      frog_pos                     ; store it back 
                    LDD      frogger_right_offset         ; load the current offset 
                    STD      current_frog_offset          ; and remember it 
continue_right_jump: 
                    LDX      #froggerRightAnim            ; use the vector list for 
                    stx      froggerAnimPointer 
                    lda      froggerInJump 
                    lsla     
                    ldx      a,x 
                    STX      frog_pic                     ; right pointing frog 
                    LDB      frog_x                       ; load old pos to B 
                    ADDB     #FROG_X_JUMP /8              ; decrease position with speed faktor 
                    STB      frog_x                       ; and store new position 
                    jmp      positioning_done 

pos_left: 
                    TSTB                                  ; test the old joystick position 
                    lBNE     positioning_done             ; was center 
; he y dissi "print JOYSTICK_READ timeHi= $RecalCounterHi timeLow= $RecalCounterLow , X= $Vec_Joy_1_X"
                    LDB      frog_x_band                  ; load old pos to B 
                    lBLE     positioning_done             ; if so, do nothing 
                    PLAY_SFX  Karl_Jump_Sound 
; init new jump anim sequence
                    lda      #7                           ; animation counter of one jump, so many jump steps are taken, befor 
                    sta      froggerInJump                ; befor another move can be made 
                    DEC      frog_x_band                  ; for internal checking 
                    LDA      #HEADING_LEFT                ; than the last? 
                    CMPA     current_frog_heading 
                    BEQ      continue_left_jump           ; if yes -> we are done 
                    STA      current_frog_heading         ; and store it 
                    ldd      frog_pos 
                    SUBA     current_frog_offset          ; korrekt the old offset y 
                    SUBB     current_frog_offset+1        ; korrekt the old offset x 
                    ADDA     frogger_left_offset          ; korrekt the new offset y 
                    ADDB     frogger_left_offset+1        ; korrekt the new offset x 
                    STD      frog_pos                     ; store it back 
                    LDD      frogger_left_offset          ; load the current offset 
                    STD      current_frog_offset          ; and store it 
continue_left_jump: 
                    LDX      #froggerLeftAnim             ; use the vector list for 
                    lda      froggerInJump 
                    lsla     
                    stx      froggerAnimPointer 
                    ldx      a,x 
                    STX      frog_pic                     ; left pointing frog 
                    LDB      frog_x                       ; load old pos to B 
                    SUBB     #FROG_X_JUMP /8              ; decrease position with speed faktor 
                    STB      frog_x                       ; and store new position 
                    jmp      positioning_done             ; if so, do nothing 

new_xpos_exit: 
no_new_xpos: 
; than checking for changed y pos
                    LDA      Vec_Joy_1_Y                  ; load joystick 1 position X to A 
                    LDB      last_joy_y                   ; only jump if last joy pos was zero 
                    STA      last_joy_y                   ; store this joystick position 
                    lBEQ     no_new_ypos                  ; no joystick input available 
                    BMI      pos_down                     ; joystick moved to down 
pos_up: 
                    TSTB                                  ; test the old joystick position 
                    lBNE     positioning_done             ; was center 
; he y dissi "print JOYSTICK_READ timeHi= $RecalCounterHi timeLow= $RecalCounterLow , Y= $Vec_Joy_1_Y"
                    LDB      frog_y_band                  ; load old pos to B 
                    lBEQ     positioning_done             ; if so, do nothing 
                    PLAY_SFX  Karl_Jump_Sound 
                    lda      #7                           ; animation counter of one jump, so many jump steps are taken, befor 
                    sta      froggerInJump                ; befor another move can be made 
                                                          ; INC level_score 
                    ADD_SCORE_10  
                    DEC      frog_y_band                  ; for internal checking 
                    LDB      #HEADING_UP                  ; than the last? 
                    CMPB     current_frog_heading         ; is the heading now the same 
                    BEQ      continue_up_jump             ; if yes -> we are done 
                    STB      current_frog_heading         ; store new heading 
                    ldd      frog_pos 
                    SUBA     current_frog_offset          ; korrekt the old offset y 
                    SUBB     current_frog_offset+1        ; korrekt the old offset x 
                    ADDA     frogger_up_offset            ; korrekt the new offset y 
                    ADDB     frogger_up_offset+1          ; korrekt the new offset x 
                    STD      frog_pos                     ; store it back 
                    LDD      frogger_up_offset            ; remember the current offset 
                    STD      current_frog_offset          ; 
continue_up_jump: 
                    LDX      #froggerUpAnim               ; use the vector list for 
                    lda      froggerInJump 
                    lsla     
                    stx      froggerAnimPointer 
                    ldx      a,x 
                    STX      frog_pic                     ; left pointing frog 
                    LDB      frog_y                       ; load old pos to B 
                    ADDB     #FROG_Y_JUMP /8              ; decrease position with speed faktor 
                    STB      frog_y                       ; and store new position 
                    bra      positioning_done             ; and exit joystick position routine 

pos_down: 
                    TSTB                                  ; test the old joystick position 
                    BNE      no_new_ypos                  ; was center 
; he y dissi "print JOYSTICK_READ timeHi= $RecalCounterHi timeLow= $RecalCounterLow , Y= $Vec_Joy_1_Y"
                    LDB      frog_y_band                  ; load old pos to B 
                    CMPB     #12                          ; is it at maximum down position? 
                    BEQ      positioning_done             ; if so, do nothing 
                    PLAY_SFX  Karl_Jump_Sound 
                    lda      #7                           ; animation counter of one jump, so many jump steps are taken, befor 
                    sta      froggerInJump                ; befor another move can be made 
                    SUB_SCORE_10  
                                                          ; DEC level_score 
                    INC      frog_y_band                  ; for internal checking 
                    LDB      #HEADING_DOWN                ; than the last? 
                    CMPB     current_frog_heading         ; is the heading now the same 
                    BEQ      continue_down_jump           ; if yes -> we are done 
                    STB      current_frog_heading         ; store new heading 
                    ldd      frog_pos 
                    SUBA     current_frog_offset          ; korrekt the old offset y 
                    SUBB     current_frog_offset+1        ; korrekt the old offset x 
                    ADDA     frogger_down_offset          ; korrekt the new offset y 
                    ADDB     frogger_down_offset+1        ; korrekt the new offset x 
                    STD      frog_pos                     ; store it back 
                    LDD      frogger_down_offset          ; remember the current offset 
                    STD      current_frog_offset          ; 
continue_down_jump: 
                    LDX      #froggerDownAnim             ; use the vector list for 
                    lda      froggerInJump 
                    lsla     
                    stx      froggerAnimPointer 
                    ldx      a,x 
                    STX      frog_pic                     ; left pointing frog 
                    LDB      frog_y                       ; load old pos to B 
                    SUBB     #FROG_Y_JUMP /8              ; decrease position with speed faktor 
                    STB      frog_y                       ; and store new position 
new_ypos_exit: 
no_new_ypos: 
positioning_done: 
                    LDB      frog_y_band                  ; load band information 
                    BEQ      home_jump_tried              ; a short jump saves a few cycles 
                    rts      

                    direct   $c8 
; ******************************************************************
home_jump_tried: 
; here check for homereach must be put and new frog started
                    LDD      #DIE_WALL_JUMP               ; default death for this 
                    STD      kind_of_death                ; band is DIE_WALL_JUMP 
                    LDA      frog_x                       ; load frog position 
home1_test: 
                    CMPA     #HOME1_POS_LEFT              ; are we left of home 
                    LBLE     die                          ; yep, than die DIE_WALL_JUMP 
                    CMPA     #HOME1_POS_RIGHT             ; or are we right, than 
                    BGT      home2_test                   ; goto next test 
                    LDX      #home_entry_1                ; load home address to X 
                    LDU      home_entry_1                 ; load home object to U 
                    BEQ      no_object_in_home            ; if none, than OK 
                    BRA      object_in_home               ; if there is something,... further checking 

home2_test: 
                    CMPA     #HOME2_POS_LEFT              ; are we left of home 
                    LBLE     die                          ; yep, than die DIE_WALL_JUMP 
                    CMPA     #HOME2_POS_RIGHT             ; or are we right, than 
                    BGT      home3_test                   ; goto next test 
                    LDX      #home_entry_2                ; load home address to X 
                    LDU      home_entry_2                 ; load home object to U 
                    BEQ      no_object_in_home            ; if none, than OK 
                    BRA      object_in_home               ; if there is something,... further checking 

home3_test: 
                    CMPA     #HOME3_POS_LEFT              ; are we left of home 
                    LBLE     die                          ; yep, than die DIE_WALL_JUMP 
                    CMPA     #HOME3_POS_RIGHT             ; or are we right, than 
                    BGT      home4_test                   ; goto next test 
                    LDX      #home_entry_3                ; load home address to X 
                    LDU      home_entry_3                 ; load home object to U 
                    BEQ      no_object_in_home            ; if none, than OK 
                    BRA      object_in_home               ; if there is something,... further checking 

home4_test: 
                    CMPA     #HOME4_POS_LEFT              ; are we left of home 
                    LBLE     die                          ; yep, than die DIE_WALL_JUMP 
                    CMPA     #HOME4_POS_RIGHT             ; or are we right, than 
                    BGT      home5_test                   ; goto next test 
                    LDX      #home_entry_4                ; load home address to X 
                    LDU      home_entry_4                 ; load home object to U 
                    BEQ      no_object_in_home            ; if none, than OK 
                    BRA      object_in_home               ; if there is something,... further checking 

home5_test: 
                    CMPA     #HOME5_POS_LEFT              ; are we left of home 
                    LBLE     die                          ; yep, than die DIE_WALL_JUMP 
                    CMPA     #HOME5_POS_RIGHT             ; or are we right, than 
                    LBGT     die                          ; goto die DIE_WALL_JUMP 
                    LDX      #home_entry_5                ; load home address to X 
                    LDU      home_entry_5                 ; load home object to U 
                    BEQ      no_object_in_home            ; if none, than OK 
; X pointer to home object position
; U pointer to home object
object_in_home: 
; here test ob frog, croco or fly in home
                    LDA      10,U                         ; load the object special to A 
                    CMPA     #SPECIAL_HOME_FLY            ; check if fly... 
                    BNE      no_home_fly                  ; no?. bother, than dead :-( 
                                                          ; yep, this is a fly object, reinitiate fly... 
                    LDD      fly_timer_start              ; reload the fly timer 
                    STD      fly_timer                    ; and store it 
                    INC      fly_status                   ; is WAITING 
                    LDA      #FLY_BONUS                   ; load fly bonus for extro 
                    ADDA     frog_bonus                   ; add old bonus to it 
                    STA      frog_bonus                   ; and store it back... 
                    BRA      init_with_bonus              ; and do 'frog reached home' 

no_home_fly: 
                    CMPA     #SPECIAL_CROCO_HALF          ; is only half a crocodile seen? 
                    BNE      no_half_croco                ; no, than jump 
                    LDD      croco_timer_start            ; reload the croco timer 
                    STD      croco_timer                  ; and store it 
                    INC      croco_status                 ; is WAITING 
                    BRA      init_with_bonus              ; and do 'frog reached home', phhht 

no_half_croco: 
                    CMPA     #SPECIAL_CROCO_FULL          ; if a full crocodile is in house 
                    BNE      no_full_croco                ; no?, than jump 
                    JMP      die_croco                    ; otherwise frogger is dead 

no_full_croco: 
                    LDD      #DIE_HOME_FULL               ; default death 
                    JMP      die_set                      ; frogger jumped to occupied home 

;***************************************************************************
; X pointer to home object position
; 0
init_with_bonus: 
no_object_in_home: 
                    LDD      #frog1a_in_home_object       ; load object for frog is in home 
                    STD      ,X                           ; and set it as new home object 
                    LDA      (frog1a_in_home_object+4)    ; load animation counter of object 
                    STA      4,X                          ; and store it to object in RAM 
                    PLAY_SFX  KarlHomeJump_Sound 
                    lda      #4                           ; gimick possible with 0 or 1 house occupied 
                    cmpa     in_home_counter 
                    bls      gimmickStillPossible 
                    lda      #1 
                    sta      gimmickPossible 
gimmickStillPossible 
                    DEC      in_home_counter              ; decrease home counter 
                    BNE      no_new_level                 ; if not zero, than not all homes are full 
                    JSR      frog_in_home                 ; do a frog in home intermission 
                    direct   $c8 
                    JSR      level_complete               ; do a level done intermission 
                    direct   $d0 
                    INC      game_level                   ; increase level counter 
                    LDA      #((level_done_data-level1_data)/LEVEL_DATA_LENGTH) ; load number of none level 
                    CMPA     game_level                   ; compare to game_level 
                    BNE      no_roll_over                 ; if equal a roll_over has occured 
 inc did_rollOver
                    CLR      game_level                   ; clear level (start at 0 again) 
; TODO if space left - roll Over intermission!
;                  JSR      roll_over_intermission       ; and do a roll_over intermission 
no_roll_over: 
                    INIT_MUSICs  gameStartMusic 
                    JSR      DP_to_C8                     ; for set up level... 
                    direct   $C8 
                    JSR      setup_level                  ; set up a new level 
goingOutHere 
                    jsr      init_new_frog_vars 
                    leas     4,s 
                    _DP_TO_D0  
                    rts      

no_new_level: 
                    JSR      frog_in_home                 ; do a frog in home intermission 
                    bra      goingOutHere 
;***************************************************************************
