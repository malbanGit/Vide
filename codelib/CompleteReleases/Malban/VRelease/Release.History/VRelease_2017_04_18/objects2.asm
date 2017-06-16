

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
explosionBehaviour                                        ;#isfunction  
                    stb      VIA_t1_cnt_lo                    ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
                    ldb X_POS+u_offset1,u
; start the move to
; following calcs can be done within that move
                    MY_MOVE_TO_D_START                    ; move to last know position of object 
                    lda      EXPLOSION_SCALE+u_offset1,u 
                    inca                                  ; "fast" expension to "points per round 
                    inca     
                    sta      EXPLOSION_SCALE+u_offset1,u 
                    adda     explosionActiveCounter       ; trick that not all explosion "die" in the same round - saves cleanup time 
                                                          ; also - the more explosions, the less far they reach :-) 
                    cmpa     explosionMax                 ; if the maximum extend of the explosion is reached -> remove it 
                    ble      explosion_alive_eb 
                    lda      explosionMax                 ; add a little to the explosion max extend... 
                    adda     #5                           ; since now there is are less explosions about 
                    sta      explosionMax 
                    dec      explosionActiveCounter       ; and also decrement the explosion active counter 
                    jmp      removeObject                 ; remove the object, "returns" via puls of next object 

explosion_alive_eb: 
                    sta      VIA_t1_cnt_lo                ; explosion scale 
                    lda      SCALE+u_offset1,u 
                    cmpa     #$80                         ; if the explosion is far away 
                    blo      noMusic_eb1 
                    jsr      [inMovePointer]              ; decrunch a piece of music 
noMusic_eb1 
                    ldx      #rotList                     ; reuse of the rotation list of shield/base 
                    lda      ,x+                          ; get count of vectors 
                    sta      tmp_count2 
                    lda      #$7f                         ; explosions are bright! 
                    ldu      NEXT_OBJECT+u_offset1,u      ; correct U for going out later 
                    MY_MOVE_TO_B_END                      ; end a move to 
                    _INTENSITY_A  
next_edd: 
                    ldd      ,x                           ; load the corners of the polygon 
                    MY_MOVE_TO_D_START_NT                 ; move to the corner, and draw a dot at every corner 
                    leax     2,x                          ; little time saving, the ++ of x moved into the MOVE 
                    lda      #$ff                         ; preload shift 
                    MY_MOVE_TO_B_END                      ; end a move to 
                    STA      <VIA_shift_reg               ; Store in VIA shift register 
; delay for dot dwell
                    CLR      <VIA_shift_reg               ; Blank beam in VIA shift register 
                    dec      tmp_count2                   ; check if vector count finished 
                    bpl      next_edd                     ; if not - draw next dot 
done_edd: 
                    _ZERO_VECTOR_BEAM  
                    pulu     d,x,pc                     ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
******************************  
***** SCORE ****************** 
******************************  
; scores displayed by ONE vectorlist, 
; these are "destruction" scores
scoreBehaviour                                            ;#isfunction  
                    stb      VIA_t1_cnt_lo                    ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
                    ldb X_POS+u_offset1,u
                    MY_MOVE_TO_D_START_NT  
                    cmpy     ddra_scale_compare           ; a prepared score + ddra compare 
                    lbhi     removeObject                 ; if score scale is higher than max shield - don't bother displaying it 
                    lda      SCALE+u_offset1,u            ; if score is far away 
                    cmpa     #$80 
                    blo      noMusic_ssb1 
                    jsr      [inMovePointer]              ; decrunch a music part 
noMusic_ssb1 
                    lda      SCORE_COUNTDOWN+u_offset1,u  ; scores shown round counter 
                    inca     
                    sta      SCORE_COUNTDOWN+u_offset1,u 
                    cmpa     score_display_time           ; scores are displayed in "rounds" not in movement, if shown long enough 
                    lbhi     removeObject                 ; remove it 
                    lda      RecalCounterLow              ; scores move slowly only 1 "point" every second round 
                    bita     #$01                         ; use some counter to access a single bit as compare 
                    beq      noAdd_sb 
                    inc      SCALE+u_offset1,u            ; and only if bit is set increase the score scale 
noAdd_sb: 
                    lda      #3                           ; tiny little score 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    lda      #$5f 
                    ldu      NEXT_OBJECT+u_offset1,u      ; prepare next object to u 
                    MY_MOVE_TO_B_END                      ; end a move to 
                    _INTENSITY_A  
                    jsr      myDraw_VL_mode 
                    _ZERO_VECTOR_BEAM  
                    pulu     d,x,pc                     ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 
******************************  
***** SCORE X***************** 
******************************  
; special
; the X vectorlist(s)
; are generated in move to display a 3 digit score (max) generated by the starlets 
scoreXBehaviour                                           ;#isfunction  
                    stb      VIA_t1_cnt_lo                    ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
                    ldb X_POS+u_offset1,u
                    MY_MOVE_TO_D_START_NT  
                    lda      SCORE_COUNTDOWN+u_offset1,u  ; timer countdown for score display 
                    inca     
                    sta      SCORE_COUNTDOWN+u_offset1,u 
                    cmpa     score_display_time           ; if count down reached max 
                    lbhi     removeObject                 ; remove the score 
                    lda      RecalCounterLow              ; scores move slowly only 1 "point" every second round 
                    bita     #$01                         ; use some counter to access a single bit as compare 
                    beq      noAdd_sxb 
                    inc      SCALE+u_offset1,u            ; and only if bit is set increase the score scale 
noAdd_sxb: 
                    lda      #3                           ; tiny little score 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    lda      #$5f 
                    MY_MOVE_TO_B_END                      ; end a move to 
                    _INTENSITY_A  
; generate display from score: SCORE_TO_DISPLAY
; the vectorlist of the scores are generated in the spawner
; if list is 0, than nothing is displayed (leading zero of a score)
                    ldx      SCORE_POINTER_3+u_offset1,u 
                    beq      not_3_score_xb 
                    jsr      myDraw_VL_mode 
not_3_score_xb 
                    ldx      SCORE_POINTER_2+u_offset1,u 
                    beq      not_2_score_xb 
                    jsr      myDraw_VL_mode 
not_2_score_xb 
                    ldx      SCORE_POINTER_1+u_offset1,u 
                    jsr      myDraw_VL_mode 
                    ldu      NEXT_OBJECT+u_offset1,u      ; prepare next object to u 
                    _ZERO_VECTOR_BEAM  
                    pulu     d,x,pc                     ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 

******************************  
***** TIMER ****************** 
******************************  
; this is a special object in the middle of our base
; that displays the timer that is left for our current activated bonus
; special
; the X vectorlist(s)
; are generated in move to
timerBehaviour                                            ;#isfunction  
                    stb      VIA_t1_cnt_lo                    ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
                    ldb X_POS+u_offset1,u
                    MY_MOVE_TO_D_START  
                    tst      bonus_time_1                 ; the position of a two digit timer is different from a one digit timer, here we determine that 
                    beq      smallBonusTimer 
; large bonus timer
                    ldy      bonusCounter                 ; contains 50 * times seconds bonus counter - meaning the complete timer in ticks 
                    leay     -1,y 
                    sty      bonusCounter 
                    lbeq     endBonus                     ; must stay here, if shield was used, than the counter will be rest to 0 here! 
                    dec      SECOND_COUNTER+u_offset1,u   ; 50Hz that means every 50 ticks is one second 
                    bne      noTimerChange_tblarge 
                    lda      #50 
                    sta      SECOND_COUNTER+u_offset1,u 
                    dec      bonus_time_0                 ; csa string print version of digit 0 of timer 
                    bpl      no_hi_timer_change_tb 
                    lda      #9 
                    sta      bonus_time_0 
                    dec      bonus_time_1                 ; csa string print version of digit 1 of timer 
                    bne      still_large_timer_tb 
                    ldd      #$e0e0                       ; y,x pos -1,-10 
                    sta      Y_POS+u_offset1,u 
                    stb      X_POS+u_offset1,u 
                    bra      entry_small_timer_tb 

still_large_timer_tb 
no_hi_timer_change_tb 
noTimerChange_tblarge 
                    lda      #3 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    lda      #$5f 
;                    MY_MOVE_TO_B_END                      ; we do not end the move, time has certainly passed by here!
                    _INTENSITY_A  
                    ldu      NEXT_OBJECT+u_offset1,u      ; preload next user stack 
                    ldy      #NumberList                  ; list of pointers to number vectorlists 
                    lda      bonus_time_1 
                    lsla                                  ; times two 
                    ldx      a,y 
                    jsr      myDraw_VL_mode 
                    lda      bonus_time_0 
                    lsla                                  ; times two 
                    ldx      a,y 
                    jsr      myDraw_VL_mode 
                    _ZERO_VECTOR_BEAM  
                    pulu     d,x,pc                     ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
smallBonusTimer: 
                    ldy      bonusCounter                 ; contains 50 * times seconds bonus counter - meaning the complete timer in ticks 
                    leay     -1,y 
                    sty      bonusCounter 
                    beq      endBonus                     ; if zero is reached - than bonus is discarded 
                    dec      SECOND_COUNTER+u_offset1,u 
                    bne      noTimerChange_tb 
                    lda      #50 
                    sta      SECOND_COUNTER+u_offset1,u 
                    dec      bonus_time_0 
entry_small_timer_tb: 
                    ldy      #NumberList                  ; list of pointers to number vectorlists 
                    lda      bonus_time_0 
                    lsla                                  ; times two 
                    ldd      a,y 
                    std      CURRENT_LIST+u_offset1,u 
noTimerChange_tb: 
                    lda      #3 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    lda      #$5f 
;                    MY_MOVE_TO_B_END                      ; we do not end the move, time has certainly passed by here!
                    _INTENSITY_A  
                    ldu      NEXT_OBJECT+u_offset1,u      ; preload next user stack 
                    jsr      myDraw_VL_mode 
                    _ZERO_VECTOR_BEAM  
                    pulu     d,x,pc                     ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 
endBonus 
;  deinit the actual bonus 
                    ldy      currentPhaseData             ; load data of current "level" - e use this to restore the speed/growth settings 
                    lda      bonusActiveType 
                    cmpa     #BONUS_TYPE_FASTER 
                    beq      deactiveFaster 
                    cmpa     #BONUS_TYPE_EXPAND 
                    beq      deactiveExpand 
                    cmpa     #BONUS_TYPE_SHIELD 
                    beq      deactiveShield 
deactiveShield: 
                    bra      deactivateDone_bb            ; nothing realy to deactivate here 

deactiveFaster 
                    lda      2,y 
                    sta      shieldSpeed                  ; 
                    lda      5,y 
                    sta      shield_width_adder 
                    bra      deactivateDone_bb 

deactiveExpand 
                    lda      1,y 
                    sta      shieldWidthGrowth 
                    lda      5,y 
                    sta      shield_width_adder 
                    bra      deactivateDone_bb 

deactivateDone_bb: 
                    clr      bonusActiveType 
                    lbeq     removeObject 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; behaviours control (action) and draw all objects
; each object type has an individual behaviour
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; values are set from "u" list as:
;      pulu     pc,d,x,y ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 
DO_ONE_STAR         macro    mPos, mScale 
                    sta      VIA_t1_cnt_lo                ; load and set the correct scale 
                    cmpb     #$ff                       ; if $ffff than not 
                    lbeq      inInit1\? 

; 17 cycles per star more to calc os from angle, instead of old "pos" version
; saving another 6 cycled by ldd instead of lda + ldb above (pos+scale)
; 11 per star more
; saving one ldd due to puls = 6 cycles
; 11*4-6
; 38 cycles for one star cluster more due to using "angle" instead of pos
                    clra     
;CIRCLE_ADR gotton from puls in y
                    ldy      #circle 
                    leay     d,y 
 MY_LSL_D
; angle final d value 0-762
; corrected in first move to 0 - 720
                   ldd      d,y 

; TODO?
; it is possible to precalculate in a cluster of 4 stars
; the next 3 stars within the previous move
; might save another 20 cycles or so...



                    MY_MOVE_TO_D_START_NT                 ; otherwise move to the pos 
; in move - don't bother about cycle waste

 lda RecalCounterLow
 bita #$01
 bne noChangests\?
 lda mPos+u_offset1,u 
 adda star_swirl ; since pos is already times 2
; cmpa #241
; blo angleStarOk\?
; suba #240
angleStarOk\?:
 sta mPos+u_offset1,u 

 lda RecalCounterHi
 anda #%000000010
 bne noChangests\?
 tst RecalCounterLow
 bne noChangests\?
 inc RecalCounterLow ; do only once
 ldb star_swirl
 lda my_random2
 bmi decswirl\?
incswirl\?
 addb #2
 cmpb #4
 beq decswirl\?
 bra storeswirl\?

decswirl\?
 subb #2
 cmpb #-4
 beq incswirl\?
storeswirl\?
 stb star_swirl
noChangests\?

                    lda      mScale+u_offset1,u           ; load scale 
                    cmpa     spawn_max                    ; and see if star is not out of bounds yet 
                    bhi      doInit1\?                    ; jump to init if out of bounds 
                    cmpa     #$80                         ; see if star is pretty far away 
                    blo      noMusic\?                    ; if not jump 
                    jsr      [inMovePointer]              ; if yes, decrunch a piece of music 
                    lda      mScale+u_offset1,u           ; reload the scale 
; and depending on ho "big" the scale is - add even more to the scale
noMusic\? 
                    adda     #5 
                    cmpa     #$b0 
                    bhi      s1_done\? 
                    deca     
                    cmpa     #$80 
                    bhi      s1_done\? 
                    deca     
                    cmpa     #$40 
                    bhi      s1_done\? 
                    deca     
                    cmpa     #$20 
                    bhi      s1_done\? 
                    deca     
s1_done\? 
                    sta      mScale+u_offset1,u           ; and store the after add 
                    adda     #10                          ; also depending on the scale calc an intensity level 
                    cmpa     #$2f                         ; minimum intensity 
                    blo      b_ok_1\? 
                    lda      #$2f 
b_ok_1\? 
                    MY_MOVE_TO_B_END                      ; end a move to 
                    _INTENSITY_A  
                    lda      #$ff 
                    STA      <VIA_shift_reg               ; Store in VIA shift register 
; delay for dot dwell
                    CLR      <VIA_shift_reg               ; Blank beam in VIA shift register 
                    _ZERO_VECTOR_BEAM  
                    bra      do_pos3\?                    ; jump to done 

inInit1\? 
                    dec      mScale+u_offset1,u           ; we are in initi phase, dec the init delay counter 
                    bne      do_pos2\?                    ; if not zero yet - jump out 
;                    inc      TYPE+u_offset1,u             ; if zero, we remember that one of our four stars is "alive" 
 inc IS_NEW_STARFIELD+u_offset1,u 

doInit1\?: 
                    _ZERO_VECTOR_BEAM                     ; in case we are here from an oob, zero the beam 
                    ldd      #$0a00                       ; and also "break" current ramping (move) 
                    std      VIA_t1_cnt_lo                ; disable ramping 
                    lda      #8                           ; minimum scale at star birth 
                    sta      mScale+u_offset1,u           ; store the scale 
                    ldb      my_random2                   ;  
                    andb     #%01111111                   ; 0 - 127 
; in a random number between 0 - 127
 aslb ; between 0-254
                    stb      mPos+u_offset1,u 
do_pos2\?: 
do_pos3\? 
                    endm     

starfieldBehaviour                                        ;#isfunction  
; four stars per star "atom"
                    DO_ONE_STAR  POS_1, SCALE_1 
                    ldd      SCALE_2+u_offset1,u ; load scale and pos to d
                    DO_ONE_STAR  POS_2, SCALE_2 
                    ldd      SCALE_3+u_offset1,u ; load scale and pos to d
                    DO_ONE_STAR  POS_3, SCALE_3 
                    ldd      SCALE_4+u_offset1,u ; load scale and pos to d
                    DO_ONE_STAR  POS_4, SCALE_4 
                    ldu      NEXT_OBJECT+u_offset1,u      ; preload next user stack 
                    pulu     d,x,pc                     ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; behaviours control (action) and draw all objects
; each object type has an individual behaviour
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; values are set from "u" list as:
;      pulu     pc,d,x,y ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 
letterBehaviour                                           ;#isfunction  
                                                          ; do the scaling 
                    stb      VIA_t1_cnt_lo                    ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
                    ldb X_POS+u_offset1,u
; start the move to
; following calcs can be done within that move
                    MY_MOVE_TO_D_START_NT  
                    ldd      ANGLE+u_offset1,u            ; load current scale to a - for later calcs 
                    std      tmp_angle 
;                    lda      TYPE+u_offset1,u 
                    ldy      PREVIOUS_LETTER+u_offset1,u  ; if we are the "R" than there is no previous letter 
                    beq      np_previousLetter            ; we have the lead and do not depend on other letters (jump) 
                                                          ; CSA dec DIF_DELAY+u_offset1,u 
; bne no_space_changenow_lb
                                                          ; CSA lda #ADD_DELAY 
                                                          ; CSA sta DIF_DELAY+u_offset1,u 
                    ldd      print_angle_2                ; the current "sinus" position of the space pulsation between letters 
                    ldy      #circle                      ; 
; leay d,y
                    ldd      d,y 
                    tstb                                  ; b is the -sin of the circle 
                    bmi      do_minus 
                    beq      no_space_changenow_lb        ; if we happen to get a 0 do nothing, if we count zero as plus or minus, than the spaces change over time! 
                    ldd      SPACE_TO_PREVIOUS+u_offset1,u ;space between each letter 
                    addd     #2                           ; space change per "add" 
                    bra      change_space_done_lb 

do_minus 
                    ldd      SPACE_TO_PREVIOUS+u_offset1,u 
                    subd     #2                           ; space change per sub 
change_space_done_lb 
                    std      SPACE_TO_PREVIOUS+u_offset1,u ; and store the changed space offset 
no_space_changenow_lb: 
                    ldy      PREVIOUS_LETTER+u_offset1,u  ; our own position is always dependened on our prvious letter 
                    ldd      ANGLE,y                      ; load angle of previous 
                    addd     SPACE_TO_PREVIOUS+u_offset1,u ; and add our space to that letter 
                    bpl      no_anglecircle_overflow_lb   ; and correct if over or underflow 
                    addd     #720 
no_anglecircle_overflow_lb: 
                    cmpd     #720 
                    blt      no_anglecircle_overflow2_lb 
                    subd     #720 
no_anglecircle_overflow2_lb: 
                    bra      angle_lb_done 

np_previousLetter 
                    ldd      print_angle                  ; print angle has the major "circle angle" ("R" moves with that angle) 
angle_lb_done 
                    std      ANGLE+u_offset1,u            ; store current angle 
                    ldy      #circle                      ; and get a pos from that angle 
                    leay     d,y                          ; u pointer to spwan angle coordinates 
                    ldd      ,y 
                    sta      Y_POS+u_offset1,u            ; save start pos 
                    stb      X_POS+u_offset1,u            ; save start pos 
                    ldu      NEXT_OBJECT+u_offset1,u      ; preload next user stack 
                    lda      #$5f                         ; intensity 
                    pshs     u 
                    MY_MOVE_TO_B_END                      ; end a move to 
                    _INTENSITY_A  
                    lda      #20                          ;SHIFT_TITLE_UP ; this title is shifted a little bit upwards to better display the scroller 
                    _SCALE_A  
                    ldd      #$7f00                       ; $7f is maximum possible positive strength to move 
                    MY_MOVE_TO_D_START_NT  
                    lda      vector_print_scale           ; strength in that the letters are printed 
                    _SCALE_A  
                    MY_MOVE_TO_B_END                      ; end a move to 
                    jsr      myDraw_VL_mode4 
                    puls     u 
                    _ZERO_VECTOR_BEAM  
                    pulu     d,x,pc                     ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 


