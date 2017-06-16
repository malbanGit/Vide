; this file is part of Release, written by Malban in 2017
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; All the different explosions were done "on the fly"
; they were not "planned", and certainly do not consist of good or nice code
; please do not look further!
;
explosionBehaviour                                        ;#isfunction  
                    stb      VIA_t1_cnt_lo                ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
                    bne      explosion_alive_1            ; anti glitch 
                    jmp      removeObject                 ; anti glitch 

explosion_alive_1                                         ;        anti glitch 
                    ldb      X_POS+u_offset1,u 
; start the move to
; following calcs can be done within that move
                    MY_MOVE_TO_D_START                    ; move to last know position of object 
                    tst      EXPLOSION_TYPE+u_offset1,u 
                    bne      noxxplosion1                 ; if not explosion 0 - jump, xplosion 0 is the terribe x - the implosion... 
                    lda      EXPLOSION_SCALE+u_offset1,u 
                    ldb      EXPLOSION_DATA+u_offset1,u 
                    bne      xxplosionPart2 
                    cmpa     #30                          ; max * 2 ; if the maximum extend of the explosion is init "implosion" 
                    blo      noxxplosion1_2_0 
                    inc      EXPLOSION_DATA+u_offset1,u 
xxplosionPart2 
                    suba     #3                           ; implosion slightly fatser than explosion (2 vs 3) 
                    bmi      removeIt_ex_1                ; if negative - than remove the explosion - finally! 
                    bra      scalingDone_ex 

removeIt_ex_1                                             ;        anti glitch 
                    adda     #3 
                    clr      SCALE+u_offset1,u            ; anti glitch 
                    dec      explosionActiveCounter       ; and also decrement the explosion active counter 
                    bra      scalingDone_ex               ; anti glitch 

noxxplosion1_2_0                                          ;        " no x explosion" 
                    adda     #2 
                    sta      EXPLOSION_SCALE+u_offset1,u 
                    bra      explosion_alive_eb 

noxxplosion1 
                    lda      EXPLOSION_SCALE+u_offset1,u 
noxxplosion1_2 
                    adda     #2 
                    ldb      EXPLOSION_TYPE+u_offset1,u 
                    cmpb     #5                           ; star - stars expland double fast -> and are brighter 
                    bne      noStarExplosion 
                    adda     #2 
scalingDone_ex 
                    sta      EXPLOSION_SCALE+u_offset1,u 
                    cmpa     #80                          ; max * 2 ; if the maximum extend of the explosion is reached -> remove it 
                    ble      explosion_alive_eb 
                    bra      starExplodeDone 

noStarExplosion 
                    sta      EXPLOSION_SCALE+u_offset1,u 
                    adda     explosionActiveCounter       ; trick that not all explosion "die" in the same round - saves cleanup time 
                                                          ; also - the more explosions, the less far they reach :-) 
                    cmpa     explosionMax                 ; if the maximum extend of the explosion is reached -> remove it 
                    ble      explosion_alive_eb 
removeIt_ex 
                    ldb      explosionMax                 ; add a little to the explosion max extend... 
                    addb     #5                           ; since now there is are less explosions about 
                    stb      explosionMax 
starExplodeDone 
                    dec      explosionActiveCounter       ; and also decrement the explosion active counter 
; anti glitch              jmp      removeObject                 ; remove the object, "returns" via puls of next object 
                    clr      SCALE+u_offset1,u            ; anti glitch 
starScaleDone: 
explosion_alive_eb: 
                    sta      VIA_t1_cnt_lo                ; explosion scale 
                    ldx      #rotList                     ; reuse of the rotation list of shield/base 
                    lda      ,x+                          ; get count of vectors 
                    sta      tmp_count2 
                    lda      #$7f                         ; explosions are bright! 
                    tfr      u,y 
                    ldu      NEXT_OBJECT+u_offset1,u      ; correct U for going out later 
                    ldb      EXPLOSION_TYPE+u_offset1,y 
                    cmpb     #4 
                    beq      doShotExplosion 
                    MY_MOVE_TO_B_END                      ; end a move to 
                    _INTENSITY_A  
next_edd: 
                    ldd      ,x                           ; load the corners of the polygon 
                    MY_MOVE_TO_D_START_NT                 ; move to the corner, and draw a dot at every corner 
                    leax     2,x                          ; little time saving, the ++ of x moved into the MOVE 
                    ldb      EXPLOSION_TYPE+u_offset1,y 
                    beq      doXExplosion 
                    cmpb     #1 
                    lbeq     doBomberExplosion 
                    cmpb     #2 
                    lbeq     doDragonExplosion 
                    cmpb     #3 
                    lbeq     doHunterExplosion 
                    cmpb     #5 
                    lbge     doBonusExplosion 
doXExplosion 
; do normal explosion here
                    lda      #$ff                         ; preload shift 
                    MY_MOVE_TO_B_END                      ; end a move to 
                    STA      <VIA_shift_reg               ; Store in VIA shift register 
; the next MoveTo blanks anyways
                    dec      tmp_count2                   ; check if vector count finished 
                    bpl      next_edd                     ; if not - draw next dot 
                    clra     
                    LDB      #$CC 
                    sta      <VIA_shift_reg 
                    STB      VIA_cntl                     ;/BLANK low and /ZERO low 
                    pulu     d,x,pc                       ; (D = y,x, X = vectorlist) 
doShotExplosion 
                    ldb      #$06 
                    stb      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    lda      EXPLOSION_INTENSITY+u_offset1,y 
                    MY_MOVE_TO_B_END                      ; end a move to 
                    _INTENSITY_A  
                    lda      #$80 
; shots does not explode at all - the shot stays in its place and "fades" 
; here the shot is optimized:
; here I inline the drawing of 4 lines
                    STA      <VIA_aux_cntl                ; Shift reg mode = 000 free disable, T1 PB7 enabled 
                    ldb      #$28 
                    STB      <VIA_port_a                  ;(2) [4] Send Y to A/D 
                    CLR      <VIA_port_b                  ;(2) [4] enable mux, thus y integrators are set to Y 
                    INC      <VIA_port_b                  ;[6] Disable mux 
; ONE LINE
                    STB      <VIA_port_a                  ; [6] Send X to A/D 
                    ldb      #$ee 
                    CLR      <VIA_t1_cnt_hi               ; [4] enable timer 1 
; light on
                    stb      <VIA_cntl                    ; [4] ZERO disabled, and BLANK disabled 
                    ldd      #$d828 
                    STA      <VIA_port_a                  ; [4] Send Y to A/D 
                    clr      <VIA_port_b                  ; [6] 
                    lda      #$ce                         ; [2] 
; light off
                    sta      <VIA_cntl                    ; [4] ZERO disabled, and BLANK enabled 
                    INC      <VIA_port_b                  ; [6] Disable mux 
; ONE LINE
                    STB      <VIA_port_a                  ; [6] Send X to A/D 
                    ldb      #$ee 
                    CLR      <VIA_t1_cnt_hi               ; [4] enable timer 1 
; light on
                    stb      <VIA_cntl                    ; [4] ZERO disabled, and BLANK disabled 
                    ldd      #$d8d8 
                    STA      <VIA_port_a                  ; [4] Send Y to A/D 
                    clr      <VIA_port_b                  ; [6] 
                    lda      #$ce                         ; [2] 
; light off
                    sta      <VIA_cntl                    ; [4] ZERO disabled, and BLANK enabled 
                    INC      <VIA_port_b                  ; [6] Disable mux 
; ONE LINE
                    STB      <VIA_port_a                  ; [6] Send X to A/D 
                    ldb      #$ee 
                    CLR      <VIA_t1_cnt_hi               ; [4] enable timer 1 
; light on
                    stb      <VIA_cntl                    ; [4] ZERO disabled, and BLANK disabled 
                    ldd      #$28d8 
                    STA      <VIA_port_a                  ; [4] Send Y to A/D 
                    clr      <VIA_port_b                  ; [6] 
                    lda      #$ce                         ; [2] 
; light off
                    sta      <VIA_cntl                    ; [4] ZERO disabled, and BLANK enabled 
                    INC      <VIA_port_b                  ; [6] Disable mux 
                    STB      <VIA_port_a                  ; [6] Send X to A/D 
; light on
                    ldb      #$ee 
                    CLR      <VIA_t1_cnt_hi               ; [4] enable timer 1 
                    stb      <VIA_cntl                    ; ZERO disabled, and BLANK disabled 
                    lda      EXPLOSION_INTENSITY+u_offset1,y 
                    suba     #4 
                    sta      EXPLOSION_INTENSITY+u_offset1,y 
                    bpl      shot_ongoing 
                    clr      SCALE+u_offset1,u            ; anti glitch 
shot_ongoing 
                    ldd      #$CC98 
                    STb      <VIA_aux_cntl                ; 
                    STa      VIA_cntl                     ;/BLANK low and /ZERO low 
                    pulu     d,x,pc                       ; (D = y,x, X = vectorlist) 
; same as above, but with a quite longer "dwelling"
doBonusExplosion 
                    lda      #$ff                         ; preload shift 
                    MY_MOVE_TO_B_END                      ; end a move to 
                    STA      <VIA_shift_reg               ; Store in VIA shift register 
                    ldb      #20                          ; dot dwell for ? explosion - they are bright! (and take some cycles)! 
dodecagain 
                    decb     
                    bpl      dodecagain 
; the next MoveTo blanks anyways
                    dec      tmp_count2                   ; check if vector count finished 
                    lbpl     next_edd                     ; if not - draw next dot 
                    clra     
                    sta      <VIA_shift_reg 
                    _ZERO_VECTOR_BEAM  
                    pulu     d,x,pc                       ; (D = y,x, X = vectorlist) 
doBomberExplosion 
                    ldd      #$8006 
                    stb      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    MY_MOVE_TO_B_END                      ; end a move to 
; bomber explosions are terrible cycle wise - 
; here I inline the drawing of 4 lines (one "shot" instead of an explosion "dot")
                    STA      <VIA_aux_cntl                ; Shift reg mode = 000 free disable, T1 PB7 enabled 
                    ldb      #$28 
                    STB      <VIA_port_a                  ;(2) [4] Send Y to A/D 
                    CLR      <VIA_port_b                  ;(2) [4] enable mux, thus y integrators are set to Y 
                    INC      <VIA_port_b                  ;[6] Disable mux 
; ONE LINE
                    STB      <VIA_port_a                  ; [6] Send X to A/D 
                    ldb      #$ee 
                    CLR      <VIA_t1_cnt_hi               ; [4] enable timer 1 
; light on
                    stb      <VIA_cntl                    ; [4] ZERO disabled, and BLANK disabled 
                    ldd      #$d828 
                    STA      <VIA_port_a                  ; [4] Send Y to A/D 
                    clr      <VIA_port_b                  ; [6] 
                    lda      #$ce                         ; [2] 
; light off
                    sta      <VIA_cntl                    ; [4] ZERO disabled, and BLANK enabled 
                    INC      <VIA_port_b                  ; [6] Disable mux 
; ONE LINE
                    STB      <VIA_port_a                  ; [6] Send X to A/D 
                    ldb      #$ee 
                    CLR      <VIA_t1_cnt_hi               ; [4] enable timer 1 
; light on
                    stb      <VIA_cntl                    ; [4] ZERO disabled, and BLANK disabled 
                    ldd      #$d8d8 
                    STA      <VIA_port_a                  ; [4] Send Y to A/D 
                    clr      <VIA_port_b                  ; [6] 
                    lda      #$ce                         ; [2] 
; light off
                    sta      <VIA_cntl                    ; [4] ZERO disabled, and BLANK enabled 
                    INC      <VIA_port_b                  ; [6] Disable mux 
; ONE LINE
                    STB      <VIA_port_a                  ; [6] Send X to A/D 
                    ldb      #$ee 
                    CLR      <VIA_t1_cnt_hi               ; [4] enable timer 1 
; light on
                    stb      <VIA_cntl                    ; [4] ZERO disabled, and BLANK disabled 
                    ldd      #$28d8 
                    STA      <VIA_port_a                  ; [4] Send Y to A/D 
                    clr      <VIA_port_b                  ; [6] 
                    lda      #$ce                         ; [2] 
; light off
                    sta      <VIA_cntl                    ; [4] ZERO disabled, and BLANK enabled 
                    INC      <VIA_port_b                  ; [6] Disable mux 
                    STB      <VIA_port_a                  ; [6] Send X to A/D 
; light on
                    ldb      #$ee 
                    CLR      <VIA_t1_cnt_hi               ; [4] enable timer 1 
                    stb      <VIA_cntl                    ; ZERO disabled, and BLANK disabled 
                    lda      EXPLOSION_SCALE+u_offset1,y 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    dec      tmp_count2                   ; check if vector count finished 
                    lbpl     next_edd                     ; if not - draw next dot 
                    ldd      #$CC98 
                    STb      <VIA_aux_cntl                ; 
                    STa      VIA_cntl                     ;/BLANK low and /ZERO low 
                    pulu     d,x,pc                       ; (D = y,x, X = vectorlist) 
doDragonExplosion 
; DB $ff, +$24, +$24 ; mode, y, x
; DB $00, +$00, -$24 ; mode, y, x
; DB $ff, -$24, +$24 ; mode, y, x
                    ldd      #$8006 
                    stb      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    MY_MOVE_TO_B_END                      ; end a move to 
; dragon explosions are terrible cycle wise - (one "dragontail" instead of an explosion "dot")
; here I inline the drawing of 4 lines
                    STA      <VIA_aux_cntl                ; Shift reg mode = 000 free disable, T1 PB7 enabled 
                    ldb      #$24 
                    STb      <VIA_port_a                  ;(2) [4] Send Y to A/D 
                    CLR      <VIA_port_b                  ;(2) [4] enable mux, thus y integrators are set to Y 
                    INC      <VIA_port_b                  ;[6] Disable mux 
; ONE LINE
                    STB      <VIA_port_a                  ; [6] Send X to A/D 
                    ldb      #$ee 
                    CLR      <VIA_t1_cnt_hi               ; [4] enable timer 1 
; light on
                    stb      <VIA_cntl                    ; [4] ZERO disabled, and BLANK disabled 
                    ldd      #$00dc 
                    STA      <VIA_port_a                  ; [4] Send Y to A/D 
                    clr      <VIA_port_b                  ; [6] 
                    lda      #$ce                         ; [2] 
; light off
                    sta      <VIA_cntl                    ; [4] ZERO disabled, and BLANK enabled 
                    INC      <VIA_port_b                  ; [6] Disable mux 
; ONE LINE
                    STB      <VIA_port_a                  ; [6] Send X to A/D 
                    ldb      #$ce 
                    CLR      <VIA_t1_cnt_hi               ; [4] enable timer 1 
; light on
                    stb      <VIA_cntl                    ; [4] ZERO disabled, and BLANK disabled 
                    ldd      #$dc24 
                    STA      <VIA_port_a                  ; [4] Send Y to A/D 
                    clr      <VIA_port_b                  ; [6] 
                    lda      #$ce                         ; [2] 
; light off
                    sta      <VIA_cntl                    ; [4] ZERO disabled, and BLANK enabled 
                    INC      <VIA_port_b                  ; [6] Disable mux 
; ONE LINE
                    STB      <VIA_port_a                  ; [6] Send X to A/D 
                    ldb      #$ee 
                    CLR      <VIA_t1_cnt_hi               ; [4] enable timer 1 
; light on
                    stb      <VIA_cntl                    ; [4] ZERO disabled, and BLANK disabled 
                    ldd      #$00dc 
                    STA      <VIA_port_a                  ; [4] Send Y to A/D 
                    clr      <VIA_port_b                  ; [6] 
                    lda      #$ce                         ; [2] 
; light off
                    sta      <VIA_cntl                    ; [4] ZERO disabled, and BLANK enabled 
                    INC      <VIA_port_b                  ; [6] Disable mux 
                    STB      <VIA_port_a                  ; [6] Send X to A/D 
; light on
                    ldb      #$ce 
                    CLR      <VIA_t1_cnt_hi               ; [4] enable timer 1 
                    stb      <VIA_cntl                    ; ZERO disabled, and BLANK disabled 
                    lda      EXPLOSION_SCALE+u_offset1,y 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    dec      tmp_count2                   ; check if vector count finished 
                    lbpl     next_edd                     ; if not - draw next dot 
                    ldd      #$CC98 
                    STb      <VIA_aux_cntl                ; 
                    STa      VIA_cntl                     ;/BLANK low and /ZERO low 
                    pulu     d,x,pc                       ; (D = y,x, X = vectorlist) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
doHunterExplosion 
                    lda      #$7f 
                    suba     EXPLOSION_SCALE+u_offset1,y 
                    suba     EXPLOSION_SCALE+u_offset1,y 
                    suba     EXPLOSION_SCALE+u_offset1,y 
                    MY_MOVE_TO_B_END                      ; end a move to 
                    _INTENSITY_A  
next_line_dr_ds4_eh: 
                    LDD      ,X 
                    STA      <VIA_port_a                  ;Send Y to A/D 
                    CLR      <VIA_port_b                  ;Enable mux 
                    INC      <VIA_port_b                  ;Disable mux 
                    STB      <VIA_port_a                  ;Send X to A/D 
                    LDD      #$00FF                       ;Shift reg=$FF (solid line), T1H=0 
                    STB      <VIA_shift_reg               ;Put pattern in shift register 
                    STA      <VIA_t1_cnt_hi               ;Set T1H (scale factor?) 
                    LDB      #$40                         ;B-reg = T1 interrupt bit 
                    LEAX     2,X                          ;Point to next coordinate pair 
wait_draw_dr_ds4_eh: 
                    BITB     <VIA_int_flags               ;Wait for T1 to time out 
                    BEQ      wait_draw_dr_ds4_eh 
                    STA      <VIA_shift_reg               ;Clear shift register (blank output) 
                    dec      tmp_count2                   ;Decrement line count 
                    bpl      next_line_dr_ds4_eh          ; if not - draw next dot 
                    _ZERO_VECTOR_BEAM  
                    pulu     d,x,pc                       ; (D = y,x, X = vectorlist) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
******************************  
***** SCORE ****************** 
******************************  
; scores displayed by ONE vectorlist, 
; these are "destruction" scores
scoreBehaviour                                            ;#isfunction  
                    stb      VIA_t1_cnt_lo                ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
                    bne      score_alive_1                ; anti glitch 
                    jmp      removeObject                 ; anti glitch 

score_alive_1                                             ;        anti glitch 
                    ldb      X_POS+u_offset1,u 
                    MY_MOVE_TO_D_START_NT  
                    lda      SCALE+u_offset1,u            ; if score is far away 
                    cmpa     shield_max 
                    blo      display_shield_1             ; anti glitchremoveObject ; if score scale is higher than max shield - don't bother displaying it 
                    clr      SCALE+u_offset1,u            ; anti glitch 
display_shield_1                                          ;        anti glitch 
                    cmpa     #$80 
                    blo      noMusic_ssb1 
                    jsr      [inMovePointer]              ; decrunch a music part 
noMusic_ssb1 
                    lda      SCORE_COUNTDOWN+u_offset1,u  ; scores shown round counter 
                    inca     
                    sta      SCORE_COUNTDOWN+u_offset1,u 
                    cmpa     score_display_time           ; scores are displayed in "rounds" not in movement, if shown long enough 
                    blo      score_alive_2 u              ; anti glitch removeObject ; remove it 
                    clr      SCALE+u_offset1,u            ; anti glitch 
score_alive_2                                             ;        anti glitch 
                    tst      SCALE+u_offset1,u 
                    beq      display_score_final 
                    lda      RecalCounterLow              ; scores move slowly only 1 "point" every second round 
                    bita     #$01                         ; use some counter to access a single bit as compare 
                    beq      noAdd_sb 
                    inc      SCALE+u_offset1,u            ; and only if bit is set increase the score scale 
noAdd_sb: 
display_score_final: 
                    ldd      #$5f03                       ; tiny little score 
                    stb      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    ldu      NEXT_OBJECT+u_offset1,u      ; prepare next object to u 
                    MY_MOVE_TO_B_END                      ; end a move to 
                    _INTENSITY_A  
                    jmp      myDraw_VL_mode_direct        ; draw the list 

******************************  
***** SCORE X***************** 
******************************  
; special
; the X vectorlist(s)
; are generated in move to display a 3 digit score (max) generated by the starlets 
scoreXBehaviour                                           ;#isfunction  
                    stb      VIA_t1_cnt_lo                ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
                    bne      scorex_alive_1               ; anti glitch 
                    jmp      removeObject                 ; anti glitch 

scorex_alive_1                                            ;        anti glitch 
                    ldb      X_POS+u_offset1,u 
                    MY_MOVE_TO_D_START_NT  
                    lda      SCORE_COUNTDOWN+u_offset1,u  ; timer countdown for score display 
                    inca     
                    sta      SCORE_COUNTDOWN+u_offset1,u 
                    cmpa     score_display_time           ; if count down reached max 
                    blo      scorex_alive_2               ; removeObject ; remove the score 
                    clr      SCALE+u_offset1,u            ; anti glitch 
scorex_alive_2                                            ;        anti glitch 
                    tst      SCALE+u_offset1,u 
                    beq      display_scorex_final 
                    lda      RecalCounterLow              ; scores move slowly only 1 "point" every second round 
                    bita     #$01                         ; use some counter to access a single bit as compare 
                    beq      noAdd_sxb 
                    inc      SCALE+u_offset1,u            ; and only if bit is set increase the score scale 
noAdd_sxb: 
display_scorex_final 
                    ldd      #$5f03                       ; tiny little score 
                    stb      VIA_t1_cnt_lo                ; to timer t1 (lo= 
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
                    ldu      NEXT_OBJECT+u_offset1,u      ; prepare next object to u 
                    jmp      myDraw_VL_mode_direct        ; draw the list 

******************************  
***** TIMER ****************** 
******************************  
; this is a special object in the middle of our base
; that displays the timer that is left for our current activated bonus
; special
; the X vectorlist(s)
; are generated in move to
timerBehaviour                                            ;#isfunction  
                    ldd      timerObject+Y_POS 
                    stb      VIA_t1_cnt_lo                ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
                    ldb      X_POS+timerObject 
                    MY_MOVE_TO_D_START  
                    tst      bonus_time_1                 ; the position of a two digit timer is different from a one digit timer, here we determine that 
                    beq      smallBonusTimer 
; large bonus timer
                    ldy      bonusCounter                 ; contains 50 * times seconds bonus counter - meaning the complete timer in ticks 
                    leay     -1,y 
                    sty      bonusCounter 
                    lbeq     endBonus                     ; must stay here, if shield was used, than the counter will be rest to 0 here! 
                    dec      SECOND_COUNTER+timerObject   ; 50Hz that means every 50 ticks is one second 
                    bne      noTimerChange_tblarge 
                    lda      #50 
                    sta      SECOND_COUNTER+timerObject 
                    dec      bonus_time_0                 ; csa string print version of digit 0 of timer 
                    bpl      no_hi_timer_change_tb 
                    lda      #9 
                    sta      bonus_time_0 
                    dec      bonus_time_1                 ; csa string print version of digit 1 of timer 
                    bne      still_large_timer_tb 
                    lda      #$e0                         ; y,x pos -1,-10 
                    sta      Y_POS+timerObject 
                    sta      X_POS+timerObject 
                    bra      entry_small_timer_tb 

still_large_timer_tb 
no_hi_timer_change_tb 
noTimerChange_tblarge 
                    ldd      #$5f03 
                    stb      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    _INTENSITY_A  
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
                    rts      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
smallBonusTimer: 
                    ldy      bonusCounter                 ; contains 50 * times seconds bonus counter - meaning the complete timer in ticks 
                    leay     -1,y 
                    sty      bonusCounter 
                    beq      endBonus                     ; if zero is reached - than bonus is discarded 
                    dec      SECOND_COUNTER+timerObject 
                    bne      noTimerChange_tb 
                    lda      #50 
                    sta      SECOND_COUNTER+timerObject 
                    dec      bonus_time_0 
entry_small_timer_tb: 
                    ldy      #NumberList                  ; list of pointers to number vectorlists 
                    lda      bonus_time_0 
                    lsla                                  ; times two 
                    ldd      a,y 
                    std      CURRENT_LIST+timerObject 
noTimerChange_tb: 
                    ldx      CURRENT_LIST+timerObject 
                    ldd      #$5f03 
                    stb      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    _INTENSITY_A  
                    jsr      myDraw_VL_mode 
                    _ZERO_VECTOR_BEAM  
                    rts      

endBonus 
                    _ZERO_VECTOR_BEAM  
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
                    ldd      #0 
                    std      timerObject+BEHAVIOUR 
                    rts      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; behaviours control (action) and draw all objects
; each object type has an individual behaviour
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; values are set from "u" list as:
;      pulu     pc,d,x ; (D = y,x, X = vectorlist) 
DO_ONE_STAR         macro    mPos, mScale 
                    sta      VIA_t1_cnt_lo                ; load and set the correct scale 
                    cmpb     #$ff                         ; if $ffff than not 
                    lbeq     inInit1\? 
; 17 cycles per star more to calc os from angle, instead of old "pos" version
; saving another 6 cycled by ldd instead of lda + ldb above (pos+scale)
; 11 per star more
; saving one ldd due to puls = 6 cycles
; 11*4-6
; 38 cycles for one star cluster more due to using "angle" instead of pos
; in b star angle 0-240
                    clra     
;CIRCLE_ADR gotton from puls in y
                    ldy      #circle 
                    leay     d,y                          ; y circle + starangle 0-240 
                    MY_LSL_D                              ; in d 0 - 480 
; angle final d value 0-762
; corrected in first move to 0 - 720
                    ldd      d,y                          ; load from y 0 - 720 (angle) 
; TODO?
; it is possible to precalculate in a cluster of 4 stars
; the next 3 stars within the previous move
; might save another 20 cycles or so...
                    MY_MOVE_TO_D_START_NT                 ; otherwise move to the pos 
; in move - don't bother about cycle waste
                    lda      mPos+u_offset1,u 
                    tst      star_swirl 
                    bpl      posAdd_dos\? 
                    adda     star_swirl                   ; since pos is already times 2 
                    cmpa     #241 
                    blo      angleStarOk\? 
                    lda      #240 
                    bra      angleStarOk\? 

posAdd_dos\? 
                    adda     star_swirl                   ; since pos is already times 2 
                    cmpa     #241 
                    blo      angleStarOk\? 
                    suba     #240 
angleStarOk\?: 
                    sta      mPos+u_offset1,u 
; change star direction everey 10 seconds (nearly)
                    lda      RecalCounterHi 
                    anda     #%000000010 
                    bne      noChangests\? 
                    tst      RecalCounterLow 
                    bne      noChangests\? 
                    inc      RecalCounterLow              ; do only once 
                    ldb      star_swirl 
                    lda      my_random2 
                    bmi      decswirl\? 
incswirl\? 
                    addb     #2 
                    cmpb     #4 
                    beq      decswirl\? 
                    bra      storeswirl\? 

decswirl\? 
                    subb     #2 
                    cmpb     #-4 
                    beq      incswirl\? 
storeswirl\? 
                    stb      star_swirl 
noChangests\? 
                    lda      mScale+u_offset1,u           ; load scale 
                    cmpa     spawn_max                    ; and see if star is not out of bounds yet 
                    bhi      doInit1\?                    ; jump to init if out of bounds 
; and depending on ho "big" the scale is - add even more to the scale
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
                    LDd      #$CC 
                    sta      VIA_shift_reg                ; Blank beam in VIA shift register 
                    STB      VIA_cntl                     ;/BLANK low and /ZERO low 
                    bra      do_pos3\?                    ; jump to done 

inInit1\? 
                    dec      mScale+u_offset1,u           ; we are in initi phase, dec the init delay counter 
                    bne      do_pos2\?                    ; if not zero yet - jump out 
                    inc      IS_NEW_STARFIELD+u_offset1,u 
doInit1\?: 
                    _ZERO_VECTOR_BEAM                     ; in case we are here from an oob, zero the beam 
                    ldd      #$0a00                       ; and also "break" current ramping (move) 
                    std      VIA_t1_cnt_lo                ; disable ramping 
                    lda      #8                           ; minimum scale at star birth 
                    sta      mScale+u_offset1,u           ; store the scale 
                    ldb      my_random2                   ; 
                    andb     #%01111111                   ; 0 - 127 
; in a random number between 0 - 127
                    aslb                                  ; between 0-254 
                    stb      mPos+u_offset1,u 
do_pos2\?: 
do_pos3\? 
                    endm     
starfieldBehaviour                                        ;#isfunction  
; four stars per star "atom"
                    DO_ONE_STAR  POS_1, SCALE_1 
                    ldd      SCALE_2+u_offset1,u          ; load scale and pos to d 
                    DO_ONE_STAR  POS_2, SCALE_2 
                    ldd      SCALE_3+u_offset1,u          ; load scale and pos to d 
                    DO_ONE_STAR  POS_3, SCALE_3 
                    ldd      SCALE_4+u_offset1,u          ; load scale and pos to d 
                    DO_ONE_STAR  POS_4, SCALE_4 
                    ldu      NEXT_OBJECT+u_offset1,u      ; preload next user stack 
                    pulu     d,x,pc                       ; (D = y,x, X = vectorlist) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; behaviours control (action) and draw all objects
; each object type has an individual behaviour
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; values are set from "u" list as:
;      pulu     pc,d,x ; (D = y,x, X = vectorlist) 
letterBehaviour                                           ;#isfunction  
                                                          ; do the scaling 
                    stb      VIA_t1_cnt_lo                ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
                    ldb      X_POS+u_offset1,u 
; start the move to
; following calcs can be done within that move
                    MY_MOVE_TO_D_START_NT  
                    ldd      ANGLE+u_offset1,u            ; load current scale to a - for later calcs 
                    std      tmp_angle 
                    ldy      PREVIOUS_LETTER+u_offset1,u  ; if we are the "R" than there is no previous letter 
                    beq      np_previousLetter            ; we have the lead and do not depend on other letters (jump) 
                                                          ; CSA dec DIF_DELAY+u_offset1,u 
; bne no_space_changenow_lb
                                                          ; CSA lda #ADD_DELAY 
                                                          ; CSA sta DIF_DELAY+u_offset1,u 
                    ldd      print_angle_2                ; the current "sinus" position of the space pulsation between letters 
                    ldy      #circle                      ; 
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
                    ldd      d,y 
                    sta      Y_POS+u_offset1,u            ; save start pos 
                    stb      X_POS+u_offset1,u            ; save start pos 
                    ldu      NEXT_OBJECT+u_offset1,u      ; preload next user stack 
                    lda      #20                          ;SHIFT_TITLE_UP ; this title is shifted a little bit upwards to better display the scroller 
                    _SCALE_A  
                    lda      #$5f                         ; intensity 
                    pshs     u 
                    MY_MOVE_TO_B_END                      ; end a move to 
                    _INTENSITY_A  
                    ldd      #$7f00                       ; $7f is maximum possible positive strength to move 
                    MY_MOVE_TO_D_START_NT  
                    lda      vector_print_scale           ; strength in that the letters are printed 
                    _SCALE_A  
                    MY_MOVE_TO_B_END                      ; end a move to 
                    jsr      myDraw_VL_mode4 
                    puls     u 
                    _ZERO_VECTOR_BEAM  
                    pulu     d,x,pc                       ; (D = y,x, X = vectorlist) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
gimmikBehaviour                                           ;        
                    ldd      timerObject+Y_POS 
                    stb      VIA_t1_cnt_lo                ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
                    ldb      X_POS+timerObject 
                    MY_MOVE_TO_D_START  
                    dec      SECOND_COUNTER+timerObject 
                    beq      endGimmik                    ; if zero is reached - than bonus is discarded 
                    dec      2+SECOND_COUNTER+timerObject 
                    bne      no_clist_change_g 
                    lda      #3 
                    sta      2+SECOND_COUNTER+timerObject ; anim counter 
                    lda      1+SECOND_COUNTER+timerObject ; type of bonus 
                    cmpa     #1 
                    beq      gimickPac 
                    cmpa     #2 
                    beq      gimickWorm 
gimickGhost 
                    ldd      CURRENT_LIST+timerObject 
                    addd     #(GhostSmall_1- GhostSmall_0) 
                    cmpd     #(GhostSmall_2+(GhostSmall_1- GhostSmall_0)) 
                    bne      store_vlist_gimmick 
                    ldd      #GhostSmall_0 
                    bra      store_vlist_gimmick 

gimickWorm 
                    inc      X_POS+timerObject 
                    ldd      CURRENT_LIST+timerObject 
                    addd     #(WormSmall_1- WormSmall_0) 
                    cmpd     #(WormSmall_6+(WormSmall_1- WormSmall_0)) 
                    bne      store_vlist_gimmick 
                    ldd      #WormSmall_0 
                    bra      store_vlist_gimmick 

gimickPac 
                    ldd      CURRENT_LIST+timerObject 
                    addd     #(PacmanSmall_1- PacmanSmall_0) 
                    cmpd     #(PacmanSmall_3+(PacmanSmall_1- PacmanSmall_0)) 
                    bne      store_vlist_gimmick 
                    ldd      #PacmanSmall_0 
store_vlist_gimmick: 
                    std      CURRENT_LIST+timerObject 
no_clist_change_g 
                    ldx      CURRENT_LIST+timerObject 
                    ldd      #$4f03 
                    stb      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    _INTENSITY_A  
                    ldy      ,x++                         ; load offset of vector list draw 
                    leay     >(unloop_start_addressSub+LENGTH_OF_HEADER),y ; 
                    leau     -4,s                         ; prepare for a simulated pulu d,x,pc 
                    leas     2,s 
                    jmp      my_drawVLC_inner 

endGimmik: 
                    ldd      #0 
                    std      timerObject+BEHAVIOUR 
                    _ZERO_VECTOR_BEAM  
                    rts      
