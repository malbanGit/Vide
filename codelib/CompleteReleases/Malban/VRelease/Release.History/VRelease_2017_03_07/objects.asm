u_offset1           =        -TYPE                        ; behaviour offset is determined by next structure element 
; all behaviour routines leave
; with u pointed to the next object structure (or 0)
; GENERAL Object functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SET_U_FREE          macro    
                    ldy      list_empty_head              ; set u free, as new free head 
                    sty      NEXT_OBJECT,u                ; load to u the next linked list element 
                    stu      list_empty_head 
                    leau     ,x                           ; x contains always next object - even if next is the "null" (return-) object 
                    pulu     d,x,y,pc                     ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 
                    endm     
; in u pointer to the object that must be removed
; destroys x, y 
; sets u to pointer of next object in linked list (or 0)
removeObject:                                             ;#isfunction  
                    leau     u_offset1,u                  ; u -> pointer object strutire (correction of offset) 
                    ldx      NEXT_OBJECT,u                ; x pointer to next objext 
                    bpl      was_last_re                  ; if positive than object in ROM space - therefor LAST 
                    ldy      PREVIOUS_OBJECT,u            ; y pointer to previous object 
                    bpl      was_first_re                 ; if positive than object in ROM space - therefor first 
                    stx      NEXT_OBJECT,y                ; set next object as previous next 
                    sty      PREVIOUS_OBJECT,x            ; set previous object as next previous 
                    SET_U_FREE  
was_first_re 
                    sty      PREVIOUS_OBJECT,x            ; clear previous' object of next object 
                    stx      list_objects_head            ; set next object as head 
                    SET_U_FREE  
was_last_re: 
                    ldy      PREVIOUS_OBJECT,u            ; y pointer to previous object 
                    bpl      was_last_and_first_re        ; if positive than object in ROM space - therefor first 
                    stx      NEXT_OBJECT,y                ; clear last objects next object 
                    sty      list_objects_tail            ; set last object as tail 
                    SET_U_FREE  
; clear both
was_last_and_first_re: 
                    stx      list_objects_head            ; the "null" object (ROM) is in x, store it to head 
                    stx      list_objects_tail            ; and tail 
                    SET_U_FREE  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; SPECIFIC Object functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
******************************  
***** OBJECT X *************** 
******************************  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; X SPAWN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; in u pointer to new object structure that should be filled with object 
; data
spawnX 
                    PLAY_SFX  SpawnX_Sound 
                    ldu      #enemyXObject 
; copy and initialze new enemy
                    stu      ORIGIN,x 
                    lda      #TYPE_X 
                    sta      TYPE, x 
                    lda      X_add_delay 
                    sta      TICK_COUNTER, x 
                    lda      X_addi 
                    sta      SPEED_COUNTER, x 
                    ldd      #xBehaviour 
                    std      BEHAVIOUR,x 
                    ldd      1,u                          ; vectorlist 
                    std      CURRENT_LIST,x 
                    lda      3,u                          ; anim reset 
                    sta      ANIM_COUNTER,x 
                    lda      #$ff 
                    sta      DDRA,x                       ; performance dummy 
                    sta      SCALE,x                      ; start with max scale (for xEnemy) 
                    jsr      Random                       ; a = random 
                    anda     #%01111111 
; in a random number between 0 - 127
                    tfr      a, b 
                    clra     
                    MY_LSL_D                              ; double it 
                    tfr      d,u 
                    leau     d,u 
                    leau     d,u                          ; u = 0 - 720 -> spawning angle of our new enemy 
                    stu      ANGLE,x                      ; store current angle of object 
                    ldd      #circle 
                    leau     d,u                          ; u pointer to spwan angle coordinates 
                    ldd      ,u 
                    std      Y_POS,x                      ; save start pos 
                    rts      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; behaviours control (action) and draw all objects
; each object type has an individual behaviour
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; values are set from "u" list as:
;      pulu     pc,d,x,y ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 
xBehaviour                                                ;#isfunction  
                                                          ; do the scaling 
                    sty      VIA_DDR_a                    ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
; start the move to
; following calcs can be done within that move
                    MY_MOVE_TO_D_START  
                    lda      SCALE+u_offset1,u            ; load current scale to a - for later calcs 
                    dec      TICK_COUNTER+u_offset1, u    ; see if wee need calc at all, compare tick counter with below zero 
                    bpl      no_scale_update_xb           ; if not, scale will not be updated 
                    ldb      X_add_delay                  ; otherwise reset the delay counter for scale update (this is global now, should I use that from the structure?) 
                    stb      TICK_COUNTER+u_offset1, u    ; store it 
                    suba     SPEED_COUNTER+u_offset1, u   ; and actually descrease the scale with the "decrease" value 
                    bcc      base_not_reached             ; if the decreas generated an overflow - than we reached the base (scale below zero) 
; if we reached the base - 
; a) moveto was SMALL - finished anyway
; b) not interested in move - nothing will be drawn anymore!
; MY_MOVE_TO_B_END
                    jmp      gameOver                     ; if base was hit -> game over 

base_not_reached: 
                    sta      SCALE+u_offset1,u            ; store the calculated scale (used next round) 
no_scale_update_xb: 
                    ldu      NEXT_OBJECT+u_offset1,u      ; preload next user stack 
                    lda      #$5f                         ; intensity 
                    MY_MOVE_TO_B_END                      ; end a move to 
                    _INTENSITY_A  
                    lda      #6 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    jsr      myDraw_VL_mode 
                    _ZERO_VECTOR_BEAM  
                    pulu     d,x,y,pc                     ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 
******************************  
***** EXPLOSION ************** 
******************************  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
explosionBehaviour                                        ;#isfunction  
                    lda      EXPLOSION_SCALE+u_offset1,u 
                    inca     
                    inca     
                    sta      EXPLOSION_SCALE+u_offset1,u 
                    cmpa     #EXPLOSION_MAX 
                    bgt      endExplosion 
; draw explosion
                    jsr      explosionDotDraw 
                    _ZERO_VECTOR_BEAM  
                    ldu      NEXT_OBJECT+u_offset1,u 
                    pulu     d,x,y,pc                     ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 
endExplosion: 
                    jmp      removeObject 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
******************************  
***** SCORE ****************** 
******************************  
scoreBehaviour                                            ;#isfunction  
                    dec      SCORE_COUNTDOWN+u_offset1,u 
                    beq      removeObject 
                    lda      #$ff 
                    sta      DDRA,x                       ; performance dummy 
                    lda      #SCORE_DISPLAY_TIME 
                    suba     SCORE_COUNTDOWN+u_offset1,u 
                    lsra     
                    adda     SCALE+u_offset1,u 
                    bcc      noSplill_sb 
                    lda      #$f0 
noSplill_sb: 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo) 
                    JSR      Intensity_5F                 ; Sets the intensity of the 
                    ldd      Y_POS+u_offset1,u 
                    jsr      Moveto_d 
                    lda      #3 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    ldx      CURRENT_LIST+u_offset1,u 
                    jsr      draw_vlcp 
                    _ZERO_VECTOR_BEAM  
                    ldu      NEXT_OBJECT+u_offset1,u 
                    pulu     d,x,y,pc                     ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 
