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
spawnX:                                                   ;        #isfunction 
                    PLAY_SFX  SpawnX_Sound 
; copy and initialze new enemy
                    lda      #TYPE_X 
                    sta      TYPE, x 
                    lda      X_add_delay 
                    sta      TICK_COUNTER, x 
                    lda      X_addi 
                    sta      SCALE_DELTA, x 
                    ldd      #xBehaviour 
                    std      BEHAVIOUR,x 
                    ldd      #enemyXList                  ; vectorlist 
                    std      CURRENT_LIST,x 
                    lda      #$ff 
                    sta      DDRA,x                       ; performance dummy 
                    lda      #SPAWN_MAX_SCALE 
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
                    suba     SCALE_DELTA+u_offset1, u     ; and actually descrease the scale with the "decrease" value 
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
                    sta      DDRA+u_offset1,u             ; performance dummy 
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
                    jsr      myDraw_VL_mode 
                    _ZERO_VECTOR_BEAM  
                    ldu      NEXT_OBJECT+u_offset1,u 
                    pulu     d,x,y,pc                     ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 
******************************  
***** OBJECT STARLET ********* 
******************************  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; STARTLET SPAWN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; in u pointer to new object structure that should be filled with object 
; data
spawnStarlet:                                             ;        #isfunction 
                    PLAY_SFX  SpawnX_Sound 
; copy and initialze new enemy
                    lda      #TYPE_STARLET 
                    sta      TYPE, x 
                    ldd      #starletBehaviour 
                    std      BEHAVIOUR,x 
                    ldd      #StarletList_0               ; vectorlist 
                    std      CURRENT_LIST,x 
                    lda      #STARLET_ANIM_DELAY          ; anim reset 
                    sta      ANIM_COUNTER,x 
                    lda      #$ff 
                    sta      DDRA,x                       ; performance dummy 
                    lda      #STAR_SCALE 
                    sta      SCALE,x                      ; start with max scale (for xEnemy) 
                    lda      #STARLET_SCORE_DELAY 
                    sta      SCORE_COUNTER,x 
                    lda      #STARLET_START_SCORE 
                    sta      SCORE_COUNT,x 



 lda star_active_flag
 bita #$01
 beq i_am_0
 bita #$02
 beq i_am_1

i_am_2:
 ora  #$04
 sta star_active_flag
 lda  SCALE,x
 adda #5
 sta  SCALE,x
 lda  #2
 sta  I_AM_STAR_NO,x
 bra my_flag_set_ss

i_am_1:
 ora  #$02
 sta star_active_flag
 lda  SCALE,x
 suba #5
 sta  SCALE,x
 lda  #1
 sta  I_AM_STAR_NO,x
 bra my_flag_set_ss
i_am_0:
 ora  #$01
 sta star_active_flag
 lda  #0
 sta  I_AM_STAR_NO,x
my_flag_set_ss:

; in a my star count. flags should be set


; redundant test
 tsta
                    bne      notFirstStar_ss 
                    clrb     
                    bra      storeStarAngle_ss 

notFirstStar_ss: 
                    cmpa     #1 
                    bne      notSecondStar_ss 
                    ldb      #120 
                    bra      storeStarAngle_ss 

notSecondStar_ss: 
                    ldb      #240 
storeStarAngle_ss 
                    ldu      #0 
                    clra     
                    leau     d,u 
                    leau     d,u                          ; angle from 00 to 720 
                    stu      ANGLE,x                      ; store current angle of object 
                    ldd      starletAngle 
                    leau     d,u 
                    cmpu     #720 
                    blt      not_oob_ss 
                    leau     -720,u 
not_oob_ss: 
                    ldd      #circle 
                    leau     d,u                          ; u pointer to spwan angle coordinates 
                    ldd      ,u 
                    std      Y_POS,x                      ; save start pos 

 ; reset quick score math 
 lda  I_AM_STAR_NO,x
 lsla
 lsla ; times 4
 ldx #star_0_score
 leax a,x
 ldd #1
 std ,x++ 
 sta ,x 



                    inc      starletCount 
                    rts      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; behaviours control (action) and draw all objects
; each object type has an individual behaviour
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; values are set from "u" list as:
;      pulu     pc,d,x,y ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 
starletBehaviour                                          ;#isfunction  
                                                          ; do the scaling 
                    sty      VIA_DDR_a                    ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
; start the move to
; following calcs can be done within that move
                    MY_MOVE_TO_D_START  
                    ldy      ANGLE+u_offset1,u            ; load current scale to a - for later calcs 
                    ldd      starletAngle 
                    leay     d,y 
                    cmpy     #720 
                    blt      not_oob_sb 
                    leay     -720,y 
not_oob_sb 
                    ldd      #circle 
                    leay     d,y                          ; 
                    ldd      ,y 
                    std      Y_POS+u_offset1,u            ; save pos 
no_angle_update_sb: 
                    dec      ANIM_COUNTER+u_offset1, u    ; see if wee need calc at all, compare tick counter with below zero 
                    bpl      no_anim_update_sb            ; if not, scale will not be updated 
                    lda      #STARLET_ANIM_DELAY          ; anim reset 
                    sta      ANIM_COUNTER+u_offset1, u 
                    ldd      CURRENT_LIST+u_offset1,u 
                    addd     #(StarletList_1-StarletList_0) 
                    cmpd     #(StarletList_10+(StarletList_1-StarletList_0)) 
                    bne      not_last_anim_sb 
                    ldd      #StarletList_0 
not_last_anim_sb: 
                    std      CURRENT_LIST+u_offset1,u 
no_anim_update_sb: 
                    dec      SCORE_COUNTER+u_offset1, u 
                    bpl      no_score_update_sb 
                    lda      #STARLET_SCORE_DELAY 
                    sta      SCORE_COUNTER+u_offset1, u 
                    lda      SCORE_COUNT+u_offset1, u 
                    pshs     x,u 
                    adda     #2 
                    bcs      abort_new_new_score_sb 
                    sta      SCORE_COUNT+u_offset1, u 

 lda  I_AM_STAR_NO+u_offset1, u 
 lsla
 lsla ; times 4
 ldx #star_0_score
 adda #2
 leax a,x
; in x now pointer to lowest qm score
 lda ,x
 inca 
 inca
 cmpa #9
 bls score_ok 
 suba #10
 sta ,x
 lda ,-x
 inca
 cmpa #9
 bls score_ok 
 suba #10
 sta ,x
 lda ,-x
 inca
score_ok:
 sta ,x

; pointer x = 
; hundreds (0,1,2)
; tens (0-9)
; singles (0-9)



abort_new_new_score_sb  
                    jsr      buildscoreX 
                    puls     x,u 
no_score_update_sb 
                    ldu      NEXT_OBJECT+u_offset1,u      ; preload next user stack 
                    lda      #$5f                         ; intensity 
                    MY_MOVE_TO_B_END                      ; end a move to 
                    _INTENSITY_A  
                    lda      #3 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    jsr      drawRotated                  ; TODO myDraw_VL_move 
                    _ZERO_VECTOR_BEAM  
                    pulu     d,x,y,pc                     ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 
 
******************************  
***** SCORE X***************** 
******************************  
; special
; the X vectorlist(s)
; are generated in move to
scoreXBehaviour                                            ;#isfunction  
                    dec      SCORE_COUNTDOWN+u_offset1,u 
                    beq      removeObject 
                    lda      #$ff 
                    sta      DDRA+u_offset1,u             ; performance dummy 
                    lda      #SCORE_DISPLAY_TIME 
                    suba     SCORE_COUNTDOWN+u_offset1,u 
                    lsra     
                    adda     SCALE+u_offset1,u 
                    bcc      noSplill_sx 
                    lda      #$f0 
noSplill_sx: 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo) 
                    JSR      Intensity_5F                 ; Sets the intensity of the 
                    ldd      Y_POS+u_offset1,u 
                    jsr      Moveto_d 
                    lda      #3 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 

; generate display from score: SCORE_TO_DISPLAY

                    ldx      SCORE_POINTER_3+u_offset1,u 
 beq not_3_score_xb
                    jsr      myDraw_VL_mode 
not_3_score_xb
                    ldx      SCORE_POINTER_2+u_offset1,u 
                    jsr      myDraw_VL_mode 
                    ldx      SCORE_POINTER_1+u_offset1,u 
                    jsr      myDraw_VL_mode 

                    _ZERO_VECTOR_BEAM  
                    ldu      NEXT_OBJECT+u_offset1,u 
                    pulu     d,x,y,pc                     ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 