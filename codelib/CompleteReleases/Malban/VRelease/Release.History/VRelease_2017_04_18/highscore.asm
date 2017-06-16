; this file is part of Release, written by Malban in 2017
;
HIGH_SCORE_ZERO_POS  =       $7090 
X_STEP_LETTERS      =        20 
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
display_highscore 
                    jsr      init_objects 
                    jsr      spawnStarfield 
                    ldd      #PC_SCORE 
                    std      NEXT_OBJECT,u 
                    jsr      spawnStarfield 
                    ldd      #PC_SCORE 
                    std      NEXT_OBJECT,u 
                    jsr      spawnStarfield 
                    ldd      #PC_SCORE 
                    std      NEXT_OBJECT,u 
                    jsr      spawnStarfield 
                    ldd      #PC_SCORE 
                    std      NEXT_OBJECT,u 
                    jsr      spawnStarfield 
                    ldd      #PC_SCORE 
                    std      NEXT_OBJECT,u 
display_highscore_intern 
                    jsr      decode_ym_1_channel 
                    jsr      Wait_Recal 
                    ldx      RecalCounter                 ; recal counter, about 21 Minutes befor roll over 
                    leax     1,x 
                    stx      RecalCounter 
                    _DP_TO_D0                             ; round_startup_main expects dp set to d0 
                    JSR      do_ym_sound2_no_sfx 
                    jsr      Intensity_5F 
                    ldd      #HIGH_SCORE_ZERO_POS 
                    std      tmp1 
                    lda      #5 
                    sta      tmp_count 
                    ldy      #highScoreBlock 
next_score_entry 
                    lda      #3 
                    sta      tmp_count2 
next_name_letter 
                    _SCALE   (SCALE_FACTOR_GAME)          ; everything we do with "positioning" is scale SCALE_FACTOR_GAME 
                    ldd      tmp1                         ; the current move vector 
                    MY_MOVE_TO_D_START_NT  
                    LDB      ,y+                          ; first char of three letter name 
                                                          ; lets calculate the abc-table offset... 
                    SUBB     # 'A'                        ; subtract smallest letter, so A has 0 offset
                    LSLB                                  ; multiply by two, since addresses are 16 bit 
                    ldx      #_abc                        ; and add the abc (table of vector list address of the alphabet's letters) 
                    LDX      b,X                          ; in x now address of first letter vectorlist 
                    _SCALE   24                           ; (SCROLL_SCALE_FACTOR) ; drawing of letters is done in SCROLL_SCALE_FACTOR 
                    lda      mov_x 
                    adda     #X_STEP_LETTERS 
                    sta      mov_x 
                    MY_MOVE_TO_B_END  
                    jsr      myDraw_VL_mode3 
                    _ZERO_VECTOR_BEAM                     ; draw each letter with a move from zero, more stable 
                    dec      tmp_count2 
                    bne      next_name_letter 
                    lda      mov_x 
                    adda     #2*X_STEP_LETTERS 
                    sta      mov_x 
                    _SCALE   (SCALE_FACTOR_GAME)          ; everything we do with "positioning" is scale SCALE_FACTOR_GAME 
; put to be displayed bcd score as csa score into player score
; player_score
                    ldd      tmp1                         ; the current move vector 
                    MY_MOVE_TO_D_START  
                    leau     ,y 
                    leay     3,y 
                    ldx      #player_score 
                    jsr      bcd_to_csa 
                    pshs     y 
                    lda      mov_y 
                    suba     #50 
                    sta      mov_y 
                    lda      #$90 
                    sta      mov_x 
                    jsr      in_game_score                ;#isfunction 
                    puls     y 
                    dec      tmp_count 
                    lbne     next_score_entry 
                    jsr      getButtonState               ; is a button pressed? 
                    beq      display_highscore_intern2 
                    cmpb     #3                           ; same aslast state 
                    beq      display_highscore_intern2 
                    cmpb     #2                           ; as released - possibly from highscore return 
                    beq      display_highscore_intern2 
                    lda      #15 
                    jsr      init_objects 
                    ldb      #3 
                    stb      last_button_state 
                    stb      current_button_state 
                    jmp      title_main1_hs_ret 

display_highscore_intern2 
                    ldd      #emptyStreamInMove 
                    std      inMovePointer 
                    ldu      list_objects_head 
                    pulu     d,x,pc                     ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; in reg a place to be edited
BLINK_LENGTH        =        50/3                         ; 1/3 second 
edit_highscore 
                    nega     
                    adda     #5 
                                                          ; in a now the compare value to ourcounter 
                    sta      hs_place_got 
                    lda      #3 
                    sta      hs_place_edit 
                    lda      #BLINK_LENGTH 
                    sta      hs_blink_count 
                    clr      hs_blink_state 
; save player hs
                    ldx      #player_score 
                    ldu      #star_0_score 
                    ldd      ,x++ 
                    std      ,u++ 
                    ldd      ,x++ 
                    std      ,u++ 
                    ldd      ,x++ 
                    std      ,u++ 
edit_highscore_inner 
                    jsr      decode_ym_1_channel 
                    jsr      Wait_Recal 
                    ldx      RecalCounter                 ; recal counter, about 21 Minutes befor roll over 
                    leax     1,x 
                    stx      RecalCounter 
                    _DP_TO_D0                             ; round_startup_main expects dp set to d0 
                    JSR      do_ym_sound2 
                    jsr      Intensity_5F 
                    ldd      #HIGH_SCORE_ZERO_POS 
                    std      tmp1 
                    lda      #5 
                    sta      tmp_count 
                    ldy      #highScoreBlock 
next_score_entry_edit 
                    lda      #3 
                    sta      tmp_count2 
next_name_letter_edit 
                    _SCALE   (SCALE_FACTOR_GAME)          ; everything we do with "positioning" is scale SCALE_FACTOR_GAME 
                    ldd      tmp1                         ; the current move vector 
                    MY_MOVE_TO_D_START_NT  
                    LDB      ,y+                          ; first char of three letter name 
                                                          ; lets calculate the abc-table offset... 
                    SUBB     # 'A'                        ; subtract smallest letter, so A has 0 offset
                    LSLB                                  ; multiply by two, since addresses are 16 bit 
                    ldx      #_abc                        ; and add the abc (table of vector list address of the alphabet's letters) 
                    LDX      b,X                          ; in x now address of first letter vectorlist 
; check if current place is the "blinker"
                    lda      tmp_count 
                    cmpa     hs_place_got 
                    bne      no_blinker 
                    lda      tmp_count2 
                    cmpa     hs_place_edit 
                    bne      no_blinker 
; here we have our blinking position
                    dec      hs_blink_count 
                    bne      no_blink_state_change 
                    lda      #BLINK_LENGTH 
                    sta      hs_blink_count 
                    lda      hs_blink_state 
                    bne      clear_blink_state 
                    inc      hs_blink_state 
                    bra      no_blink_state_change 

clear_blink_state 
                    clr      hs_blink_state 
no_blink_state_change 
                    tst      hs_blink_state 
                    bne      no_blinker                   ;if blink state != than display normal character 
; load SPACE
                    ldx      #ABC_28 
no_blinker: 
                    _SCALE   24                           ; (SCROLL_SCALE_FACTOR) ; drawing of letters is done in SCROLL_SCALE_FACTOR 
                    lda      mov_x 
                    adda     #X_STEP_LETTERS 
                    sta      mov_x 
                    MY_MOVE_TO_B_END  
                    jsr      myDraw_VL_mode3 
                    _ZERO_VECTOR_BEAM                     ; draw each letter with a move from zero, more stable 
                    dec      tmp_count2 
                    bne      next_name_letter_edit 
                    lda      mov_x 
                    adda     #2*X_STEP_LETTERS 
                    sta      mov_x 
                    _SCALE   (SCALE_FACTOR_GAME)          ; everything we do with "positioning" is scale SCALE_FACTOR_GAME 
; put to be displayed bcd score as csa score into player score
; player_score
                    ldd      tmp1                         ; the current move vector 
                    MY_MOVE_TO_D_START  
                    leau     ,y 
                    leay     3,y 
                    ldx      #player_score 
                    jsr      bcd_to_csa 
                    lda      mov_y 
                    suba     #50 
                    sta      mov_y 
                    lda      #$90 
                    sta      mov_x 
                    pshs     y 
                    jsr      in_game_score                ;#isfunction 
                    puls     y 
                    dec      tmp_count 
                    lbne     next_score_entry_edit 
                    jsr      query_joystick 
                    ldy      #highScoreBlock 
                    LDB      last_joy_x                   ; only jump if last joy pos was zero (needed for testing later) 
                    LDA      Vec_Joy_1_X                  ; load joystick 1 position X to A 
                    STA      last_joy_x                   ; store this joystick position 
                    BEQ      hs_no_new_xpos 
                    BMI      pos_left_hse                 ; joystick moved to left 
pos_right_hse: 
                    TSTB                                  ; test the old joystick position 
                    BNE      positioning_done_hse         ; was center 
; pos dec 1
                    dec      hs_place_edit 
                    bne      hs_no_new_xpos 
                    inc      hs_place_edit 
                    bra      hs_no_new_xpos 

pos_left_hse: 
                    TSTB                                  ; test the old joystick position 
                    BNE      positioning_done_hse         ; was center 
; pos inc 1
                    inc      hs_place_edit 
                    lda      #4 
                    cmpa     hs_place_edit 
                    bne      hs_no_new_xpos 
                    lda      #3 
                    sta      hs_place_edit 
                    bra      hs_no_new_xpos 

hs_no_new_xpos: 
; todo check y
                    LDB      last_joy_y                   ; only jump if last joy pos was zero (needed for testing later) 
                    LDA      Vec_Joy_1_Y                  ; load joystick 1 position X to A 
                    STA      last_joy_y                   ; store this joystick position 
                    BEQ      hs_no_new_ypos 
                    BMI      pos_down_hse                 ; joystick moved to left 
pos_up_hse: 
                    TSTB                                  ; test the old joystick position 
                    BNE      positioning_done_hse         ; was center 
                    lda      hs_place_got 
                    nega     
                    adda     #5 
                    ldb      #6 
                    mul      
                    leay     d,y 
                    lda      hs_place_edit 
                    nega     
                    adda     #3 
                    leay     a,y 
; in y now the to be changed letter
                    lda      ,y 
                    inca     
                    cmpa     # 'Z'
                    bls      no_overflow_plus_hs 
                    lda      # 'A'
no_overflow_plus_hs 
                    sta      ,y 
                    bra      hs_no_new_ypos 

pos_down_hse: 
                    TSTB                                  ; test the old joystick position 
                    BNE      positioning_done_hse         ; was center 
                    lda      hs_place_got 
                    nega     
                    adda     #5 
                    ldb      #6 
                    mul      
                    leay     d,y 
                    lda      hs_place_edit 
                    nega     
                    adda     #3 
                    leay     a,y 
; in y now the to be changed letter
                    lda      ,y 
                    deca     
                    cmpa     # 'A'
                    bhs      no_overflow_minus_hs 
                    lda      # 'Z'
no_overflow_minus_hs 
                    sta      ,y 
                    bra      hs_no_new_ypos 

; letter inc 1
positioning_done_hse 
hs_no_new_ypos 
                    jsr      getButtonState               ; is a button pressed? 
                    lbeq     edit_highscore_inner 
check_buttons_edit 
                    cmpb     #3                           ; same aslast state 
                    lbeq     edit_highscore_inner 
                    cmpb     #2                           ; as released - possibly from highscore return 
                    lbeq     edit_highscore_inner 
                    ldb      #3 
                    stb      last_button_state 
                    stb      current_button_state 
; restore player hs
                    ldu      #player_score 
                    ldx      #star_0_score 
                    ldd      ,x++ 
                    std      ,u++ 
                    ldd      ,x++ 
                    std      ,u++ 
                    ldd      ,x++ 
                    std      ,u++ 
                    rts      

;                    bra      title_main1 
