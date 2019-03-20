; this file is part of Karl Quappe, written by Malban
; in 2016
; all stuff contained here is public domain
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this file contains subroutines declared as 'intermissions', like          ;
; game over, level done, new life...                                        ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
                    direct   -1 
; death intermission
Death_BOX:          FCB      $00, $7f 
                    FCB      -$30, $00 
                    FCB      $00,-$7f 
                    FCB      $30, $00 
frog_dead: 
                    direct   $c8 
                    clr      gimmickActive                ; gimmick is always switched of with a death! 
; finish last move
                    lda      froggerInJump                ; is an "old" jump still ongoing? 
                    beq      notMoving 
                    lda      current_frog_heading 
                    cmpa     #HEADING_LEFT                ; than the last left? 
                    beq      continue_left_jump_d 
                    cmpa     #HEADING_RIGHT               ; than the last right 
                    beq      continue_right_jump_d 
                    cmpa     #HEADING_UP                  ; than the last up 
                    beq      continue_up_jump_d 
                    cmpa     #HEADING_DOWN                ; than the last down? 
                    beq      continue_down_jump_d 
                    bra      notMoving 

continue_left_jump_d 
                    LDB      frog_x                       ; load old pos to B 
                    ADDB     #-(FROG_X_JUMP /8)*7         ; decrease position with speed faktor 
                    STB      frog_x                       ; and store new position 
                    bra      notMoving 

continue_right_jump_d 
                    LDB      frog_x                       ; load old pos to B 
                    ADDB     #+(FROG_X_JUMP /8)*7         ; decrease position with speed faktor 
                    STB      frog_x                       ; and store new position 
                    bra      notMoving 

continue_up_jump_d 
                    LDB      frog_y                       ; load old pos to B 
                    ADDB     #+(FROG_Y_JUMP /8)*7         ; decrease position with speed faktor 
                    STB      frog_y                       ; and store new position 
                    bra      notMoving 

continue_down_jump_d 
                    LDB      frog_y                       ; load old pos to B 
                    ADDB     #-(FROG_Y_JUMP /8)*7         ; decrease position with speed faktor 
                    STB      frog_y                       ; and store new position 
notMoving: 
                    LDA      #50                          ; any value != 0 will do 
                    sta      frogDeath                    ; != 0 
                    sta      intermissionActive           ; != 0 
                    ldx      kind_of_death 
                    cmpx     #DIE_CAR 
                    bne      waterDeathSound 
laneDeathSound: 
                    PLAY_SFX  Karl_DeathLane_Sound 
                    bra      startDeathing 

waterDeathSound: 
                    cmpx     #DIE_TIME 
                    beq      laneDeathSound 
                    PLAY_SFX  Karl_DeathWater_Sound 
startDeathing 
; prepare first animation step
                    ldx      #frogDeathObject_0 
                    LDD      frog_pos                     ; load old pos to B 
                    SUBA     current_frog_offset          ; korrekt the old offset y 
                    SUBB     current_frog_offset+1        ; korrekt the old offset x 
                    adda     5,x                          ; y offset 
                    addb     6,x                          ; x offset, of current death animation object 
                    STD      frog_pos                     ; store it back 
                    LDD      5,x                          ; load the current offset 
                    STD      current_frog_offset          ; and remember it 
                    lda      2,x                          ; animation delay counter 
                    sta      froggerInJump                ; frogger in jump gets reusead as death animation counter 
                    stx      froggerAnimPointer 
                    ldx      ,x 
                    stx      frog_pic 
death_screen_loop1: 
                    _DP_TO_D0  
                    clr      skipCount_now 
                    jsr      do_csa_sound_startup 
                    ldx      currentMusic 
                    beq      no_streaming_4 
                                                          ; initialize dispatcher for "in move" stuff - this is only the decoder, other stuff is done "directly" 
                    ldd      #STREAM_PART_1               ; first jumper of ym decoder 
                    std      inMovePointer 
no_streaming_4: 
                    lda      skipCount 
                    sta      skipCount_now 
;;;;; DEATH MESSAGE start
                    lda      #130 
                    _SCALE_A  
                    ldd      #(94*256)+(256-62) 
                    LDX      #Death_BOX 
                    jsr      drawBox 
; BOX END
                    ldd      #$fe32 
                    std      Vec_Text_Height 
                    lda      #80 
                    _SCALE_A  
                    ldd      kind_of_death 
                    ldu      #cause_strings 
                    leau     d,u 
                    ldd      #$78A9 
                    jsr      sync_Print_Str_d 
                    LDA      #$CC                         ; Blank low, zero high? 
                    STA      <VIA_cntl                    ; 
;;;;; DEATH MESSAGE END
                                                          ; here display frog death anim 
; *** OUTPUT Frog DEATH
                    MY_GAME_SCALE                         ; set game scaling 
                    LDD      frog_pos                     ; load current frog position to D 
                                                          ; following passage is a move_to_d derivat 
                    STA      <VIA_port_a                  ; Store Y in D/A register 
                    LDA      #$CE                         ; Blank low, zero high? 
                    STA      <VIA_cntl                    ; 
                    CLRA     
                    STA      <VIA_port_b                  ; Enable mux 
                    INC      <VIA_port_b                  ; Disable mux 
                    STB      <VIA_port_a                  ; Store X in D/A register 
                    STA      <VIA_t1_cnt_hi               ; enable timer 
                    LDU      frog_pic                     ; load current frog sprite 
                    jsr      move_wait_draw_vlc_unloop 
                    ldd      #$98cc 
                    STA      <VIA_aux_cntl                ; Shift reg mode = 000 free disable, T1 PB7 enabled 
                    STB      <VIA_cntl                    ; /BLANK low and /ZERO low 
; *** OUT Frog Death done
no_list 
; handle animation
                    dec      froggerInJump                ; frogger in jump gets reusead as death animation counter 
                    bne      animstagedone 
                    ldx      froggerAnimPointer 
                    cmpx     3,x 
                    beq      deathDone 
                    ldx      3,x                          ; next anim pointer 
                    LDA      frog_y                       ; load old pos to D 
                    LDB      frog_x                       ; load old pos to B 
                    SUBA     current_frog_offset          ; korrekt the old offset y 
                    SUBB     current_frog_offset+1        ; korrekt the old offset x 
                    adda     5,x                          ; y offset 
                    addb     6,x                          ; x offset, of current death animation object 
                    STD      frog_pos                     ; store it back 
                    LDD      5,x                          ; load the current offset 
                    STD      current_frog_offset          ; and remember it 
                    lda      2,x                          ; animation delay counter 
                    sta      froggerInJump                ; frogger in jump gets reusead as death animation counter 
                    stx      froggerAnimPointer 
                    ldx      ,x 
                    stx      frog_pic 
                                                          ; here display frog death anim done 
animstagedone: 
                    JSR      entry_timer_count_down       ; draw_objects, same as on timer countdown 
                    tst      isAttractMode 
                    beq      no_attract_2 
                    jsr      displayButton 
no_attract_2 
                    jmp      death_screen_loop1           ; and loop until when not zero yet 

deathDone: 
exit_to_reinit: 
                    JSR      DP_to_C8 
                    direct   $C8 
                    clr      frogDeath                    ; != 0 
                    clr      intermissionActive           ; != 0 
                    CLR      frog_bonus                   ; no bonus collected for this frog 
; correct girl carried
                    LDA      girl_status                  ; what's the girls status? 
                    CMPA     #IS_CARRIED                  ; is it displayed 
                    bne      no_girlyReset1 
                    inc      girl_status                  ; is displayed 
                    inc      girl_status                  ; is waiting 
                    LDA      girl_round_counter_reset     ; initiate the round counter 
                    STA      girl_round_counter           ; store it 
no_girlyReset1: 
                    clr      highScoreReached             ; no highscore = default 
                    lda      no_frogs 
                    sta      no_frogs2 
                    tst      isAttractMode 
                    lbne     exitDeathAtt 
                    tst      no_frogs 
                    lbne     noHSOption 
; check if death is game over
; check if score is highscore relevant
                    lda      gameModeOption 
                    cmpa     #1 
                    lbeq     noHSOption                   ; Training = no HS 
                    clr      highScorePlace               ; default 1 place! 
; lazy - build 
                    ldx      #score_digit_5 
                    jsr      toConversion5                ; put current score to conversion buffer 
                    jsr      scrollOneRight 
                    jsr      addConversion0               ; put current score to conversion buffer 
                    jsr      convertAsciiToD              ; current score as "number" in D 
                    pshs     d                            ; remember it 
                    cmpd     #03000                       ; if player reached a "saveable" score of 30000 than level edit mode is switched on! 
                    bls      notEditAllowed 
                    lda      #1 
                    sta      levelEditAllowed 
                    ldd      ,s 
notEditAllowed: 
; load top score
                    ldx      #highScoreTable+4 
                    tst      gameModeOption 
                    beq      torunamentHS 
                    ldx      #highScoreHardTable+4 
torunamentHS: 
                    pshs     x 
                    jsr      toConversion5                ; put score to conversion buffer 
                    jsr      convertAsciiToD              ; score as "number" in D 
                    cmpd     2,s 
                    bls      highScoreFound 
                    inc      highScorePlace 
                    ldx      ,s 
                    leax     HighScoreEntry,x             ; 2. place high score 5 ascii 
                    jsr      toConversion5                ; put score to conversion buffer 
                    jsr      convertAsciiToD              ; score as "number" in D 
                    cmpd     2,s 
                    bls      highScoreFound 
                    inc      highScorePlace 
                    ldx      ,s 
                    leax     HighScoreEntry*2,x           ; 3. place high score 5 ascii 
                    jsr      toConversion5                ; put score to conversion buffer 
                    jsr      convertAsciiToD              ; score as "number" in D 
                    cmpd     2,s 
                    bls      highScoreFound 
                    inc      highScorePlace 
                    ldx      ,s 
                    leax     HighScoreEntry*3,x           ; 4. place high score 5 ascii 
                    jsr      toConversion5                ; put score to conversion buffer 
                    jsr      convertAsciiToD              ; score as "number" in D 
                    cmpd     2,s 
                    bls      highScoreFound 
                    inc      highScorePlace 
                    ldx      ,s 
                    leax     HighScoreEntry*4,x           ; 5. place high score 5 ascii 
                    jsr      toConversion5                ; put score to conversion buffer 
                    jsr      convertAsciiToD              ; score as "number" in D 
                    cmpd     2,s 
                    bls      highScoreFound 
; no highscore found
noHSOptionPre 
                    leas     4,s 
noHSOption: 
                    jsr      check2Player 
exitDeathAtt: 
                    rts      

highScoreFound 
                                                          ; in highScorePlace place we reached (0 based) 
                                                          ; in ,s the number score 
                    inc      highScoreReached             ; we reached a highscore 
                    lda      game_level 
                    sta      highScoreLevel 
                    ldd      2,s 
                    std      highScoreDone 
                    bra      noHSOptionPre 

;***************************************************************************
                    direct   $d0 
                    direct   $c8 
addHundred 
                    ADD_SCORE_100  
                    rts      

                    direct   $d0 
;***************************************************************************
; frog reached home intermission
frog_in_home: 
                                                          ; MY_QUIT ; be quiet 
                    INIT_NEXT_MUSIC  reachedHomeMusicNormal ; default 
                    clr      bonusScore 
                    direct   $c8 
                    CLR      Vec_Misc_Count               ; must be zero for Add_Score_a (left to $ff in vector routine) 
                    LDA      #50 
                    clr      tmp1 
                    sta      intermissionActive           ; != 0 
                    STA      counter 
                    LDA      frog_bonus                   ; load bonus state 
                    ANDA     #FLY_BONUS                   ; is there a fly bonus 
                    BEQ      no_fly_bonus                 ; if no jump 
                    inc      tmp1 
                    ADD_SCORE_200  
                    inc      bonusScore 
                                                          ; LDA #200 ; otherwise load 200 
                                                          ; LDX #no_score_string ; load score address 
                                                          ; JSR Add_Score_a ; add to score 
                    ldx      #reachedHomeMusicFly         ; default 
no_fly_bonus:                                             ;        
                    inc      tmp1 
                    LDA      frog_bonus                   ; load bonus state 
                    ANDA     #GIRL_BONUS                  ; is there a girl bonus 
                    BEQ      no_girl_bonus                ; if no jump 
                    inc      bonusScore 
                    ADD_SCORE_200  
                                                          ; LDA #200 ; otherwise load 200 
                                                          ; LDX #no_score_string ; load score address 
                                                          ; JSR Add_Score_a ; add to score 
                    ldb      #2 
                    cmpb     tmp1 
                    beq      happy 
                    ldx      #reachedHomeMusicGirl 
                    bra      no_girl_bonus 

happy 
                    ldx      #reachedHomeHappyMusic 
no_girl_bonus: 
                    INIT_NEXT_MUSIC_X  
                    LDA      #50                          ; 
                    sta      frogDeath                    ; != 0 
                    sta      intermissionActive           ; != 0 
                    sta      tmp2 

;***************************************************************************
; sets the current level "timer" of the home reached
; to the RAM string that is displayed in the "Box" when a home was reached
;
; 16bit uInt in "my_timer" to 2*8 bit ascii data in "timeLeft"+5
;***************************************************************************
; start                    jsr      setTimerToString 

                    LDD      my_timer                     ; load the timer value 
                    ASRA     
                    RORB                                  ; divide by two 
                                                          ; value should defenitly be in B 
                    LDU      #$0000                       ; Initialize BCD result to zero 
LF861: 
                    CMPA     #99                          ; Add in the hundreds 
                    BLS      LF86D 
                    SUBA     #100 
                    LEAU     $0100,U 
                    BRA      LF861 

LF86D: 
                    CMPA     #9                           ; Add in the tens 
                    BLS      LF878 
                    SUBA     #10 
                    LEAU     $10,U 
                    BRA      LF86D 

LF878: 
                    LEAU     A,U                          ; Add in the ones 
                    TFR      U,D                          ; Move it to the D-register 
                    tfr      b,a                          ; only the high timer counts 
                    lsra                                  ; High nibble of the byte 
                    lsra     
                    lsra     
                    lsra     
                    adda     #48                          ; Number+'0' = Number as ASCII 
                    sta      timeLeft+5 
                    andb     #15                          ; Low nibble 
                    addb     #48 
                    stb      timeLeft+6 
; end                    jsr      setTimerToString 
;***************************************************************************


                    LDD      my_timer                     ; load the timer value 
                                                          ; here starts the timer count down loop 
timer_bonus: 
                    direct   -1 
                    STD      my_timer                     ; store the timer value 
                    bpl      scoreAdd 
                    ldd      #0 
                    std      my_timer 
                    bra      noScoreAdd         
scoreAdd
                    ADD_SCORE_10  
                     ldx #KarlTimerBonusSound
                 jsr play_sfx_x_if_nothing_else                   
noScoreAdd: 
                    _DP_TO_D0  
                    jsr      do_csa_sound_startup 
                    ldx      currentMusic 
                    beq      no_streaming_3 
                                                          ; initialize dispatcher for "in move" stuff - this is only the decoder, other stuff is done "directly" 
                    ldd      #STREAM_PART_1               ; first jumper of ym decoder 
                    std      inMovePointer 
no_streaming_3: 
                    lda      skipCount 
                    sta      skipCount_now 
                    jsr      do_score 
 
                    LDd      #$60CC 
                    STB      <VIA_cntl                    ;blank low and zero low 
                    JSR      Intensity_a
                    JSR      entry_timer_count_down       ; draw_objects 

                    LDb      #$CC 
                    STB      <VIA_cntl                    ;blank low and zero low 
                    lda      bonusScore 
                    lbeq     noBonusDisplay 
                    ldu      #n200 
                    cmpa     #2 
                    bne      nodoublebonus 
                    ldu      #n200200 
nodoublebonus: 
                    lda      frog_y 
                    inca     
                    cmpa     #$7f 
                    beq      noAdd 
                    sta      frog_y 
                    bra      goOnScore 

noAdd 
                    clr      bonusScore 
                    jmp      noBonusDisplay 

goOnScore 
                    MY_GAME_SCALE                         ; set game scaling 
                    LDD      frog_pos                     ; load current frog position to D 
                                                          ; slight offset to frog Pos 
                                                          ; adda #20 
                    subb     #8 
                    cmpu     #n200200 
                    bne      noXAdjust 
                    subb     #8 
noXAdjust: 
                    jsr      my_move_to_d 
                                                          ; PRINT_STR_5 zahlen2,zahlen2_end, 18 
                    PRINT_STR_5  zahlen2,zahlen2_end, ZAHLEN_MAX, (127/3), (-4) 
                    lda      #$cc 
                    sta      <VIA_cntl                    ; 22 cycles from switch on ZERO disabled, and BLANK enabled 
                    bra      noBonusDisplay 

n200200: 
                    db       02,0,0,SPACE 
n200:               db       02,0,0,$81 
Timer_BOX:          FCB      $00, $7f 
                    FCB      -$38, $00 
                    FCB      $00,-$7f 
                    FCB      $38, $00 
noBonusDisplay: 
; below timer as String display takes 4500 cycles
; look very nice - what to "drop"?
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                    lda      #100 
                    _SCALE_A  
                    ldd      #(120*256)+(256-63) 
                    LDX      #Timer_BOX 
                    jsr      drawBox 
                    ldd      #$fe50 
                    std      Vec_Text_Height 
                    _SCALE_B  
                    ldu      #timeLeft 
                    ldd      #$78BA 
                    jsr      sync_Print_Str_d 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                    tst      isAttractMode 
                    beq      no_attract_1 
                    jsr      displayButton 
no_attract_1 
                    LDD      my_timer                     ; load the timer value 
                    SUBA     #$2                          ; count it down by $20 
                    lBPL     timer_bonus                  ; if not minus... go on 
                    dec      tmp2 
                    lbne     timer_bonus 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                    JSR      DP_to_C8 
                    clra     
                    sta      bonusScore 
                    sta      intermissionActive           ; != 0 
                    sta      frogDeath                    ; != 0 
                    sta      frog_bonus                   ; no bonus collected for this frog 
                    LDA      girl_status                  ; what's the girls status? 
                    CMPA     #IS_CARRIED                  ; is it displayed 
                    bne      no_girlyReset2 
                    inc      girl_status                  ; is displayed 
                    inc      girl_status                  ; is waiting 
                    LDA      girl_round_counter_reset     ; initiate the round counter 
                    STA      girl_round_counter           ; store it 
no_girlyReset2: 
                    direct   $C8 
                    rts      

                                                          ; JMP reinit_level ; last JSR can allways be a jump 
;***************************************************************************
level_complete: 
                    direct   $c8 
                    clr      gimmickPossible              ; possible if 0 or negative 
                    lda      #100 
                    sta      levelDoneTemp 
                    MY_QUIT                               ; be quiet 
                    ADD_SCORE_500  
                    LDA      game_level                   ; load this level to A 
                    PSHS     A                            ; remember it... 
                                                          ; load 'LEVEL DONE' level number 
                    LDA      #((level_done_data-level1_data)/LEVEL_DATA_LENGTH) 
                    STA      game_level                   ; and store it to game level 
                    JSR      setup_level                  ; set this level up 
                    JSR      init_new_frog_vars           ; and init it 
                                                          ; display till button pressed 
                    INIT_MUSICl  levelDoneMusic 
 inc intermissionActive
level_loop: 
                    _DP_TO_D0  
                    clr      skipCount_now 
                    jsr      do_csa_sound_startup 
                    jsr      oneYMRound 
no_streaming_21: 
                    bra      overbox 

Level_BOX_1:          FCB      $00, $7f 
                    FCB      -$30, $00 
                    FCB      $00,-$7f 
                    FCB      $30, $00 
overbox: 
; below timer as String display takes 4500 cycles
; look very nice - what to "drop"?
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; BOX
                    lda      #150 
                    _SCALE_A  
                    ldd      #(80*256)+(256-63) 
                    LDX      #Level_BOX_1 
                    bsr      drawBox 
                    ldd      #$fe2d 
                    std      Vec_Text_Height 
                    lda      #70 
                    _SCALE_A  
                    LDU      #level_complete_text 
                    ldd      #$78c4 
                    jsr      sync_Print_Str_d 
                    LDA      #$80 
                    STA      <VIA_aux_cntl                ; Shift reg mode = 000 free disable, T1 PB7 enabled 
                    JSR      entry_level_done             ; draw this 'level' 
                    lda      musicOption 
                    beq      testmusic 
                    dec      levelDoneTemp 
                    bmi      level_loop_done 
                    bra      testdondeon 

testmusic 
                    ldx      currentYLenCount 
                    cmpx     #1 
                    ble      level_loop_done 
testdondeon: 
                    JSR      Read_Btns                    ; get button status 
                    CMPA     #$00                         ; is a button pressed? 
                    BEQ      level_loop                   ; no, than stay in init_screen_loop 
level_loop_done: 
                    PULS     A                            ; restore old game level 
                    STA      game_level                   ; and set it 
no_new_life1: 
 clr intermissionActive
                    RTS      

;***************************************************************************
drawBox 
                    pshs     d 
                    LDA      #$98 
                    STA      <VIA_aux_cntl                ; Shift reg mode = 000 free disable, T1 PB7 enabled 
                    ldb      RecalCounter+1 
                    clr      Vec_0Ref_Enable 
                    ASRB                                  ;Get line pattern from table 
                    ANDB     #$03 
                    LDY      #$F0FD 
                    LDB      B,Y 
                    STB      Vec_Pattern                  ;Store pattern 
                    puls     d 
                    jsr      my_move_to_d 
                    LDA      #$03                         ;Draw 4 lines 
                    JMP      Draw_Pat_VL_a 

                  ;rts 
;***************************************************************************
; and some 'small' intermissions...
; just text, nothing fancy
; the following functions could as well be only one with a
; index pointer to the text to be displayed...
; well, we got space enough, haven't we?
;roll_over_intermission: 
;                    direct   $d0 
;                    MY_QUIT                               ; be quiet 
;                    JSR      Read_Btns                    ; get button status 
;                    LDA      #$ff                         ; load a timer, how long the following 
;                    STA      tmp1                         ; text will be displayed 
;roll_over_intermission_loop: 
;                    JSR      print_score 
;                    LDD      #LITTLE_TEXT_SIZE            ; load score text size 
;                    STD      Vec_Text_HW                  ; poke it to ram location 
;                    LDU      #roll_over_string            ; string to be printed 
;                    LDD      #(-$10*256)+(lo(-$50)) 
;                    JSR      Print_Str_d                  ; Print the string 
;                    DEC      tmp1                         ; decreas timer, 
;                    BEQ      roll_over_intermission_end   ; if zero, than we are done 
;                    TST      Vec_Music_Flag               ; test the music flag 
;                    BNE      roll_over_sound_is_playing   ; if music done, get out of loop 
;           ;         PLAY_SOUND  ta_ta_ta1 
;roll_over_sound_is_playing: 
;                    JSR      Read_Btns                    ; get button status 
;                    CMPA     #$00                         ; is a button pressed? 
;                    BEQ      roll_over_intermission_loop  ; start another round 
;roll_over_intermission_end: 
;                    RTS      
;***************************************************************************
; check if 2 player game
; if so switch to other player, in case he is already dead - stay at same player
; decreases no_frogs2 of other player in case he is already dead - each round
check2Player: 
                    lda      no_frogs 
                    sta      no_frogs2 
                    lda      playerCountOption 
                    beq      checkAndOut 
                    lda      currentPlayer 
                    bne      savePlayerTwo 
; check if other player is dead
                    lda      P2_no_frogs 
                    ble      stayWithPlayerOtherIsDead2 
                    lda      no_frogs 
                    beq      justDied_skip1 
                    jsr      startPlayer 
justDied_skip1 
                    ldu      #P1_start 
                    bsr      savePlayer 
                    bra      savePlayerDone 

savePlayerTwo: 
; check if other player is dead
                    lda      P1_no_frogs 
                    ble      stayWithPlayerOtherIsDead1 
                    lda      no_frogs 
                    beq      justDied_skip2 
                    jsr      startPlayer 
justDied_skip2 
                    ldu      #P2_start 
                    bsr      savePlayer 
savePlayerDone: 
; now load other player
                    lda      currentPlayer 
                    inca     
                    anda     #1 
                    sta      currentPlayer 
                    bne      loadPlayerTwo 
                    ldu      #P1_start 
                    jsr      loadPlayer 
                    bra      loadPlayerDone 

loadPlayerTwo: 
                    ldu      #P2_start 
                    jsr      loadPlayer 
loadPlayerDone: 
                    clr      tmp2 
                    jsr      no_reinit_level 
checkAndOut: 
                    rts      

stayWithPlayerOtherIsDead2: 
                    dec      P2_no_frogs 
                    lda      P2_no_frogs 
                    sta      no_frogs2 
                    rts      

stayWithPlayerOtherIsDead1: 
                    dec      P1_no_frogs 
                    lda      P1_no_frogs 
                    sta      no_frogs2 
                    rts      

;***************************************************************************
; writes data from current active variables to 
; player variables pointed to by U register
savePlayer 
                    pshs     u 
; ensure befr save that houses are clean from temporary stuff
                    LDA      croco_status                 ; is there any croco stuff at all? 
                    CMPA     #IS_DISPLAYED                ; croco is displayed 
                    bne      crocoOk 
                    LDB      croco_house                  ; load current croco offset 
                    LDU      #home_objects                ; get address of U and add the offset 
                    LEAU     B,U                          ; in U address of 'random' home 
                    LDD      #0 
                    STD      ,U 
                    INC      croco_status                 ; IS WAITING 
crocoOk 
                    LDA      fly_status                   ; is there any croco stuff at all? 
                    CMPA     #IS_DISPLAYED                ; fly is displayed 
                    bne      flyOk 
                    LDB      fly_house                    ; load current fly offset 
                    LDU      #home_objects                ; get address of U and add the offset 
                    LEAU     B,U                          ; in U address of 'random' home 
                    LDD      #0 
                    STD      ,U 
                    INC      fly_status                   ; is WAITING 
flyOk 
                    puls     u 
                    ldd      score_digit_front 
                    std      ,u++ 
                    ldd      score_digit_4 
                    std      ,u++ 
                    ldd      score_digit_2 
                    std      ,u++ 
                    ldd      score_digit_SPACE1 
                    std      ,u++ 
                    ldd      score_digit_SPACE2 
                    std      ,u++ 
                    lda      score_digit_back 
                    sta      ,u+ 
                    lda      no_frogs 
                    sta      ,u+ 
                    lda      game_level 
                    sta      ,u+ 
                    lda      in_home_counter 
                    sta      ,u+ 
                    ldx      #home_objects 
                    ldb      #25 
copyHomeGoOn: 
                    lda      ,x+ 
                    sta      ,u+ 
                    decb     
                    bne      copyHomeGoOn 
                    rts      

;***************************************************************************
; writes data from player var (pointer U) to current active variables 
loadPlayer 
                    ldd      ,u++ 
                    std      score_digit_front 
                    ldd      ,u++ 
                    std      score_digit_4 
                    ldd      ,u++ 
                    std      score_digit_2 
                    ldd      ,u++ 
                    std      score_digit_SPACE1 
                    ldd      ,u++ 
                    std      score_digit_SPACE2 
                    lda      ,u+ 
                    sta      score_digit_back 
                    lda      ,u+ 
                    sta      no_frogs 
                    lda      ,u+ 
                    sta      game_level 
                    lda      ,u+ 
                    sta      in_home_counter 
                    ldx      #home_objects 
                    ldb      #25 
copyHomeGoOn_1: 
                    lda      ,u+ 
                    sta      ,x+ 
                    decb     
                    bne      copyHomeGoOn_1 
                                                          ; correct highscore checking 
                    lda      score_digit_5 
                    sta      high_check                   ; and store it, for new life at change... (every 10000 points) 
                    rts      

;***************************************************************************
Level_BOX:          FCB      $00, $7f 
                    FCB      -$30, $00 
                    FCB      $00,-$7f 
                    FCB      $30, $00 
playerOne 
                    db       "PLAYER ONE", $80
playerTWO 
                    db       "PLAYER TWO", $80
startPlayer: 
                    ldd      #0                           ; no music is played 
                    std      nextMusic 
                    std      currentMusic 
                    sta      sfx_status_3 
                                                          ; display till button pressed 
                    jsr      shutup 
                    direct   $d0 
                    lda      #100 
                    sta      tmp1 
startPlayer_loop: 
                    ldx      RecalCounter                 ; recal counter, about 21 Minutes befor roll over 
                    leax     1,x 
                    stx      RecalCounter 
                    JSR      Wait_Recal                   ; sets dp to d0, and pos at 0, 0 
                    direct   $D0                          ; just for assembler optimization... 
; below timer as String display takes 4500 cycles
; look very nice - what to "drop"?
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; BOX
                    lda      #150 
                    _SCALE_A  
                    ldd      #(80*256)+(256-63) 
                    LDX      #Level_BOX 
                    jsr      drawBox 
                    ldd      #$fe2d 
                    std      Vec_Text_Height 
                    lda      #70 
                    _SCALE_A  
                    lda      currentPlayer 
                    beq      usePlayerTwo 
                    ldu      #playerOne 
                    bra      printStringOfPlayer 

usePlayerTwo 
                    ldu      #playerTWO 
printStringOfPlayer 
                    ldd      #$78c4 
                    jsr      sync_Print_Str_d 
                    LDA      #$80 
                    STA      <VIA_aux_cntl                ; Shift reg mode = 000 free disable, T1 PB7 enabled 
                    dec      tmp1 
                    beq      outofPalyer 
                    JSR      Read_Btns                    ; get button status 
                    CMPA     #$00                         ; is a button pressed? 
                    BEQ      startPlayer_loop             ; no, than stay in init_screen_loop 
outofPalyer 
                    _DP_TO_C8  
                    RTS      

;pauseGame
; andcc #$ff-$40 ; clear firq
;                    pshs     d,y,u,cc,dp 
;loopi 
;                    jsr      do_csa_startup 
;                    LDD      #NORMAL_TEXT_SIZE            ; load default text height & width 
;                    STD      Vec_Text_HW                  ; poke it to ram location 
;                    JSR      Intensity_5F                 ; Sets the intensity of the 
;                    ldd      #$ff3c
;                    std      Vec_Text_Height 
;
;                    _SCALE_B  
;                    ldu      Vec_Str_Ptr 
;                    ldd      #0 
;                    jsr      Print_Str_d 
;                    JSR      Read_Btns                    ; get button status 
;                    CMPA     #$00                         ; is a button pressed? 
;
;
;                    BEQ     loopi                      ; no, than stay in init_screen_loop 
;                    puls     d,y,u,cc,dp, pc 





