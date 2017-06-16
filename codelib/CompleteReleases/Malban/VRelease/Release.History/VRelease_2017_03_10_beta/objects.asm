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
; in x pointer to new object structure that should be filled with object 
; data
spawnX:                                                   ;        #isfunction 
                    jsr      newObject 
                    lbpl     cs_done_no 
                    leax     ,u                           ; pointer to new object 
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
                    lda      #X_ANIM_DELAY                ; anim reset 
                    sta      ANIM_COUNTER, x 
                    ldd      #enemyXList_0                ; vectorlist 
                    std      CURRENT_LIST,x 
                    lda      #$ff 
                    sta      DDRA,x                       ; performance dummy 
                    lda      #SPAWN_MAX_SCALE 
                    sta      SCALE,x                      ; start with max scale (for xEnemy) 
                    lda      my_random2 
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
                    bcs      die_xb                       ; if below zero, than base reaches 
                    cmpa     #BASE_SCALE+3                ; if lower base scale, than also dead 
                    bhi      base_not_reached 
;                    bcc      base_not_reached             ; if the decreas generated an overflow - than we reached the base (scale below zero) 
; if we reached the base - 
; a) moveto was SMALL - finished anyway
; b) not interested in move - nothing will be drawn anymore!
; MY_MOVE_TO_B_END
die_xb 
; cancle move
                    _ZERO_VECTOR_BEAM  
                    jmp      gameOver                     ; if base was hit -> game over 

base_not_reached: 
                    sta      SCALE+u_offset1,u            ; store the calculated scale (used next round) 
no_scale_update_xb: 
                    dec      ANIM_COUNTER+u_offset1, u    ; see if wee need calc at all, compare tick counter with below zero 
                    bpl      no_anim_update_xb            ; if not, scale will not be updated 
                    lda      #X_ANIM_DELAY                ; anim reset 
                    sta      ANIM_COUNTER+u_offset1, u 
                    ldd      CURRENT_LIST+u_offset1,u 
                    addd     #(enemyXList_1-enemyXList_0) 
                    cmpd     #(enemyXList_3+(enemyXList_1-enemyXList_0)) 
                    bne      not_last_anim_xb 
                    ldd      #enemyXList_0 
not_last_anim_xb: 
                    std      CURRENT_LIST+u_offset1,u 
no_anim_update_xb: 
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
***** OBJECT HUNTER **********
******************************  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Hunter SPAWN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; in x pointer to new object structure that should be filled with object 
; data
spawnHunter:                                              ;        #isfunction 
                    jsr      newObject 
                    lbpl     cs_done_no 
                    leax     ,u                           ; pointer to new object 
                    PLAY_SFX  SpawnHunter_Sound 
; copy and initialze new enemy
                    lda      #TYPE_HUNTER 
                    sta      TYPE, x 
                    lda      Hunter_add_delay 
                    sta      TICK_COUNTER, x 
                    lda      Hunter_addi 
                    sta      SCALE_DELTA, x 
                    ldd      #hunterBehaviour 
                    std      BEHAVIOUR,x 
                    lda      #$ff 
                    sta      DDRA,x                       ; performance dummy 
                    lda      #SPAWN_MAX_SCALE 
                    sta      SCALE,x                      ; start with max scale (for xEnemy) 
                    ldb      my_random2 
                    andb     #%01111111 
; in a random number between 0 - 127
                    clra     
                    cmpd     #120 
                    blt      noMax_dh 
                    subd     #120 
noMax_dh 
                    MY_LSL_D                              ; double it 
                    tfr      d,u 
                    leau     d,u 
                    leau     d,u                          ; u = 0 - 720 -> spawning angle of our new enemy 
                    leau     31,u                         ; u = 0 - 720 -> spawning angle of our new enemy 
                    tfr      u,d 
                    MY_LSR_D  
                    MY_LSR_D  
                    MY_LSR_D  
                    MY_LSR_D  
                    MY_LSR_D                              ; angle / 32 
                    MY_LSL_D                              ; *2 
                    ldu      #HunterList 
                    leau     d,u 
                    ldu      ,u 
                    stu      CURRENT_LIST,x 
                    MY_LSL_D                              ; *2 
                    MY_LSL_D                              ; *2 
                    MY_LSL_D                              ; *2 
                    MY_LSL_D                              ; *2 
                    tfr      d,u 
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
hunterBehaviour                                           ;#isfunction  
                                                          ; do the scaling 
                    sty      VIA_DDR_a                    ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
; start the move to
; following calcs can be done within that move
                    MY_MOVE_TO_D_START  
                    lda      SCALE+u_offset1,u            ; load current scale to a - for later calcs 
                    dec      TICK_COUNTER+u_offset1, u    ; see if wee need calc at all, compare tick counter with below zero 
                    bpl      no_scale_update_hb           ; if not, scale will not be updated 
                    ldb      Hunter_add_delay             ; otherwise reset the delay counter for scale update (this is global now, should I use that from the structure?) 
                    stb      TICK_COUNTER+u_offset1, u    ; store it 
                    suba     SCALE_DELTA+u_offset1, u     ; and actually descrease the scale with the "decrease" value 
                    bcs      die_hb                       ; if below zero, than base reaches 
                    cmpa     #BASE_SCALE+3                ; if lower base scale, than also dead 
                    bhi      base_not_reached_hb 
;                    bcc      base_not_reached             ; if the decreas generated an overflow - than we reached the base (scale below zero) 
; if we reached the base - 
; a) moveto was SMALL - finished anyway
; b) not interested in move - nothing will be drawn anymore!
; MY_MOVE_TO_B_END
die_hb 
; cancle move
                    _ZERO_VECTOR_BEAM  
                    jmp      gameOver                     ; if base was hit -> game over 

base_not_reached_hb: 
                    sta      SCALE+u_offset1,u            ; store the calculated scale (used next round) 
no_scale_update_hb: 
                    ldu      NEXT_OBJECT+u_offset1,u      ; preload next user stack 
                    lda      #$5f                         ; intensity 
                    MY_MOVE_TO_B_END                      ; end a move to 
                    _INTENSITY_A  
                    lda      #6 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    jsr      my_drawVLC 
                    _ZERO_VECTOR_BEAM  
                    pulu     d,x,y,pc                     ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 
******************************  
***** OBJECT HIDDEN X ********
******************************  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; HIDDEN X SPAWN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; in x pointer to new object structure that should be filled with object 
; data
spawnHiddenX:                                             ;        #isfunction 
                    jsr      newObject 
                    lbpl     cs_done_no 
                    leax     ,u                           ; pointer to new object 
                    PLAY_SFX  SpawnX_Sound 
; copy and initialze new enemy
                    lda      #TYPE_HIDDEN_X 
                    sta      TYPE, x 
                    lda      X_add_delay 
                    sta      TICK_COUNTER, x 
                    lda      X_addi 
                    sta      SCALE_DELTA, x 
                    ldd      #hiddenXBehaviour 
                    std      BEHAVIOUR,x 
                    lda      #X_ANIM_DELAY                ; anim reset 
                    sta      ANIM_COUNTER, x 
                    ldd      #enemyXList_0                ; vectorlist 
                    std      CURRENT_LIST,x 
                    lda      #$ff 
                    sta      DDRA,x                       ; performance dummy 
                    lda      #SPAWN_MAX_SCALE 
                    sta      SCALE,x                      ; start with max scale (for xEnemy) 
                    lda      my_random 
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
hiddenXBehaviour                                          ;#isfunction  
                                                          ; do the scaling 
                    sty      VIA_DDR_a                    ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
; start the move to
; following calcs can be done within that move
                    MY_MOVE_TO_D_START  
                    dec      ANIM_COUNTER+u_offset1, u    ; see if wee need calc at all, compare tick counter with below zero 
                    bpl      no_anim_update_hxb           ; if not, scale will not be updated 
                    lda      #X_ANIM_DELAY                ; anim reset 
                    sta      ANIM_COUNTER+u_offset1, u 
                    ldd      CURRENT_LIST+u_offset1,u 
                    addd     #(enemyXList_1-enemyXList_0) 
                    cmpd     #(enemyXList_3+(enemyXList_1-enemyXList_0)) 
                    bne      not_last_anim_hxb 
                    ldd      #enemyXList_0 
not_last_anim_hxb: 
                    std      CURRENT_LIST+u_offset1,u 
no_anim_update_hxb: 
                    lda      SCALE+u_offset1,u            ; load current scale to a - for later calcs 
                    dec      TICK_COUNTER+u_offset1, u    ; see if wee need calc at all, compare tick counter with below zero 
                    bpl      no_scale_update_hxb          ; if not, scale will not be updated 
                    ldb      X_add_delay                  ; otherwise reset the delay counter for scale update (this is global now, should I use that from the structure?) 
                    stb      TICK_COUNTER+u_offset1, u    ; store it 
                    suba     SCALE_DELTA+u_offset1, u     ; and actually descrease the scale with the "decrease" value 
                    bcs      die_hxb                      ; if below zero, than base reaches 
                    cmpa     #BASE_SCALE+3                ; if lower base scale, than also dead 
                    bhi      base_not_reached_hxb 
;                    bcc      base_not_reached             ; if the decreas generated an overflow - than we reached the base (scale below zero) 
; if we reached the base - 
; a) moveto was SMALL - finished anyway
; b) not interested in move - nothing will be drawn anymore!
; MY_MOVE_TO_B_END
die_hxb 
; cancle move
                    _ZERO_VECTOR_BEAM  
                    jmp      gameOver                     ; if base was hit -> game over 

base_not_reached_hxb: 
                    sta      SCALE+u_offset1,u            ; store the calculated scale (used next round) 
no_scale_update_hxb: 
                    ldu      NEXT_OBJECT+u_offset1,u      ; preload next user stack 
                    bita     #$80 
                    beq      go_on_int_hxb 
                    clra     
                    bra      no_int_hxb 

go_on_int_hxb 
                    nega     
                    adda     #$7f 
no_int_hxb: 
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
                    lbeq     removeObject 
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
; in x pointer to new object structure that should be filled with object 
; data
spawnStarlet:                                             ;        #isfunction 
                    jsr      newObject 
                    lbpl     cs_done_no 
                    leax     ,u                           ; pointer to new object 
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
                    lda      star_active_flag 
                    bita     #$01 
                    beq      i_am_0 
                    bita     #$02 
                    beq      i_am_1 
i_am_2: 
                    ora      #$04 
                    sta      star_active_flag 
                    lda      SCALE,x 
                    adda     #15 
                    sta      SCALE,x 
                    lda      #2 
                    sta      I_AM_STAR_NO,x 
                    bra      my_flag_set_ss 

i_am_1: 
                    ora      #$02 
                    sta      star_active_flag 
                    lda      SCALE,x 
                    suba     #15 
                    sta      SCALE,x 
                    lda      #1 
                    sta      I_AM_STAR_NO,x 
                    bra      my_flag_set_ss 

i_am_0: 
                    ora      #$01 
                    sta      star_active_flag 
                    lda      #0 
                    sta      I_AM_STAR_NO,x 
my_flag_set_ss: 
; in a my star count. flags should be set
; redundant test
; slightly random angle +- (0-31)
                    ldb      my_random2 
                    lsrb     
                    lsrb     
                    lsrb     
                    tsta     
                    beq      storeStarAngle_ss 
notFirstStar_ss: 
                    cmpa     #1 
                    bne      notSecondStar_ss 
                                                          ; addb #120 
                                                          ; 
                    addb     #150 
                    bra      storeStarAngle_ss 

notSecondStar_ss: 
                    addb     #90 
storeStarAngle_ss 
                    clra     
                    tfr      d,u                          ; angle from 00 to 720 
                    leau     d,u 
                    cmpu     #720 
                    blt      not_oob1_ss 
                    leau     -720,u 
not_oob1_ss: 
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
                    lda      I_AM_STAR_NO,x 
                    lsla     
                    lsla                                  ; times 4 
                    ldx      #star_0_score 
                    leax     a,x 
                    ldd      #0 
                    std      ,x++ 
                    lda      #STARLET_START_SCORE 
                    sta      ,x 
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
; following code adds two to the current starlet score
; and correct the csa score pointers
                    lda      SCORE_COUNT+u_offset1, u 
                    pshs     x,u 
                    adda     #2 
                    bcs      abort_new_new_score_sb 
; if new score is higher than a "digit" we have to check following digits
                    sta      SCORE_COUNT+u_offset1, u 
                    lda      I_AM_STAR_NO+u_offset1, u 
                    lsla     
                    lsla                                  ; times 4 
                    ldx      #star_0_score 
                    adda     #2 
                    leax     a,x 
; in x now pointer to lowest qm score
                    lda      ,x 
                    inca     
                    inca     
                    cmpa     #9 
                    bls      score_ok 
                    suba     #10 
                    sta      ,x 
                    lda      ,-x 
                    inca     
                    cmpa     #9 
                    bls      score_ok 
                    suba     #10 
                    sta      ,x 
                    lda      ,-x 
                    inca     
score_ok: 
                    sta      ,x 
; pointer x = 
; hundreds (0,1,2)
; tens (0-9)
; singles (0-9)
abort_new_new_score_sb 
; build a new scoreX object
                    jsr      buildscoreX 
                    puls     x,u 
no_score_update_sb 
                    ldu      NEXT_OBJECT+u_offset1,u      ; preload next user stack 
                    lda      #$5f                         ; intensity 
                    MY_MOVE_TO_B_END                      ; end a move to 
                    _INTENSITY_A  
                    lda      #3 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
;                    jsr      drawRotated                  ; TODO myDraw_VL_move 
                    jsr      drawRotated_o 
                    _ZERO_VECTOR_BEAM  
                    pulu     d,x,y,pc                     ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 
******************************  
***** SCORE X***************** 
******************************  
; special
; the X vectorlist(s)
; are generated in move to
scoreXBehaviour                                           ;#isfunction  
                    dec      SCORE_COUNTDOWN+u_offset1,u 
                    lbeq     removeObject 
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
                    beq      not_3_score_xb 
                    jsr      myDraw_VL_mode 
not_3_score_xb 
                    ldx      SCORE_POINTER_2+u_offset1,u 
                    beq      not_2_score_xb 
                    jsr      myDraw_VL_mode 
not_2_score_xb 
                    ldx      SCORE_POINTER_1+u_offset1,u 
                    jsr      myDraw_VL_mode 
                    _ZERO_VECTOR_BEAM  
                    ldu      NEXT_OBJECT+u_offset1,u 
                    pulu     d,x,y,pc                     ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 
******************************  
***** OBJECT BOMBER **********
******************************  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Bomber SPAWN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; in x pointer to new object structure that should be filled with object 
; data
spawnBomber:                                              ;        #isfunction 
                    jsr      newObject 
                    lbpl     cs_done_no 
                    leax     ,u                           ; pointer to new object 
                    PLAY_SFX  SpawnBomber_Sound 
; copy and initialze new enemy
                    lda      #TYPE_BOMBER 
                    sta      TYPE, x 
                    lda      Bomber_add_delay 
                    sta      ANGLE_TICK_COUNTER, x 
                    lda      Bomber_addi 
                    sta      ANGLE_DELTA, x 
                    ldd      #bomberBehaviour 
                    std      BEHAVIOUR,x 
                    lda      #$ff 
                    sta      DDRA,x                       ; performance dummy 
                    lda      #BOMBER_ANIM_DELAY 
                    sta      ANIM_COUNTER,x 
                    ldd      #BomberList_0 
                    std      CURRENT_LIST,x 
                    lda      #INITIAL_BOMBER_SHOT_DELAY 
                    sta      SHOT_COUNTER_RESET,x 
                    sta      SHOT_COUNTER,x 
                    ldb      my_random2 
                    andb     #%00111111                   ; max 63 
                    addb     #64 
; spawn between scale 63 - 127
                    stb      SCALE,x 
; generate another random
                    lda      my_random 
                    rola     
                    rola     
                    rola     
                    rola     
                    eora     my_random2 
                    adda     my_random2 
                    eora     RecalCounterLow 
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
bomberBehaviour                                           ;#isfunction  
                                                          ; do the scaling 
                    sty      VIA_DDR_a                    ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
; start the move to
; following calcs can be done within that move
                    MY_MOVE_TO_D_START  
                    dec      ANGLE_TICK_COUNTER+u_offset1, u ; see if wee need calc at all, compare tick counter with below zero 
                    bpl      no_angle_update_bb           ; if not, scale will not be updated 
                    ldb      Bomber_add_delay             ; otherwise reset the delay counter for scale update (this is global now, should I use that from the structure?) 
                    stb      ANGLE_TICK_COUNTER+u_offset1, u ; store it 
                    ldd      ANGLE+u_offset1,u            ; load current scale to a - for later calcs 
                    subd     #2 
                    bcc      angle_ok_bb                  ; if below zero, than base reaches 
                    addd     #720 
angle_ok_bb: 
                    std      ANGLE+u_offset1,u            ; load current scale to a - for later calcs 
                    ldy      #circle 
                    leay     d,y                          ; u pointer to spwan angle coordinates 
                    ldd      ,y 
                    std      Y_POS+u_offset1,u            ; save start pos 
no_angle_update_bb 
; check anim
                    dec      ANIM_COUNTER+u_offset1, u    ; see if wee need calc at all, compare tick counter with below zero 
                    bpl      no_anim_update_bb            ; if not, scale will not be updated 
                    lda      #BOMBER_ANIM_DELAY           ; anim reset 
                    sta      ANIM_COUNTER+u_offset1, u 
                    ldd      CURRENT_LIST+u_offset1,u 
                    addd     #(BomberList_1-BomberList_0) 
                    cmpd     #(BomberList_8+(BomberList_1-BomberList_0)) 
                    bne      not_last_anim_bb 
                    ldd      #BomberList_0 
not_last_anim_bb: 
                    std      CURRENT_LIST+u_offset1,u 
no_anim_update_bb: 
; check shot
; TODO
                    dec      SHOT_COUNTER+u_offset1, u 
                    bne      no_shot_update_bb 
                    lda      SHOT_COUNTER_RESET+u_offset1, u 
                    suba     #25 
                    cmpa     #50 
                    bhi      short_timer_ok 
                    lda      #50 
short_timer_ok 
                    sta      SHOT_COUNTER+u_offset1, u 
                    sta      SHOT_COUNTER_RESET+u_offset1, u 
                    pshs     x,u 
                    jsr      buildShot 
                    puls     x,u 
no_shot_update_bb 
                    ldu      NEXT_OBJECT+u_offset1,u      ; preload next user stack 
                    lda      #$5f                         ; intensity 
                    MY_MOVE_TO_B_END                      ; end a move to 
                    _INTENSITY_A  
                    lda      #6 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    jsr      drawRotated_o 
                    _ZERO_VECTOR_BEAM  
                    pulu     d,x,y,pc                     ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 
shotBehaviour                                             ;#isfunction  
                                                          ; do the scaling 
                    sty      VIA_DDR_a                    ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
; start the move to
; following calcs can be done within that move
                    MY_MOVE_TO_D_START  
                    lda      SCALE+u_offset1,u            ; load current scale to a - for later calcs 
                    dec      TICK_COUNTER+u_offset1, u    ; see if wee need calc at all, compare tick counter with below zero 
                    bpl      no_scale_update_sb           ; if not, scale will not be updated 
                    ldb      shot_add_delay               ; otherwise reset the delay counter for scale update (this is global now, should I use that from the structure?) 
                    stb      TICK_COUNTER+u_offset1, u    ; store it 
                    suba     SCALE_DELTA+u_offset1, u     ; and actually descrease the scale with the "decrease" value 
                    bcs      die_sb                       ; if below zero, than base reaches 
                    cmpa     #BASE_SCALE+3                ; if lower base scale, than also dead 
                    bhi      base_not_reached_sb 
; if we reached the base - 
; a) moveto was SMALL - finished anyway
; b) not interested in move - nothing will be drawn anymore!
; MY_MOVE_TO_B_END
die_sb 
; cancle move
                    _ZERO_VECTOR_BEAM  
                    jmp      gameOver                     ; if base was hit -> game over 

base_not_reached_sb: 
                    sta      SCALE+u_offset1,u            ; store the calculated scale (used next round) 
no_scale_update_sb: 
                    ldu      NEXT_OBJECT+u_offset1,u      ; preload next user stack 
                    lda      #$7f                         ; intensity 
                    MY_MOVE_TO_B_END                      ; end a move to 
                    _INTENSITY_A  
                    lda      #6 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    jsr      my_drawVLC 
                    _ZERO_VECTOR_BEAM  
                    pulu     d,x,y,pc                     ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 
******************************  
***** OBJECT DRAGON ********** 
******************************  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Dragon SPAWN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; in x pointer to new object structure that should be filled with object 
; data
spawnDragon:                                              ;        #isfunction 
                    jsr      newObject 
                    lbpl     cs_done_no 
                    leax     ,u                           ; pointer to new object 
                    PLAY_SFX  SpawnDragon_Sound 
; copy and initialze new enemy
                    lda      #TYPE_DRAGON +$40 
                    sta      TYPE, x 
                    lda      Dragon_add_delay 
                    sta      DRAGON_COUNTER, x 
                    ldd      #dragonBehaviour 
                    std      BEHAVIOUR,x 
                    ldd      #DragonList_0                ; vectorlist 
                    std      CURRENT_LIST,x 
                    lda      #$ff 
                    sta      DDRA,x                       ; performance dummy 
                    ldb      my_random2 
                    andb     #%00111111                   ; max 63 
                    addb     #64 
; spawn between scale 63 - 127
                    stb      SCALE,x 
                    lda      my_random2 
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
; todo spawn children
                    ldd      #0                           ; vectorlist 
                    std      CHILD_1,x 
                    std      CHILD_2,x 
                    tfr      x,y                          ; y is save in respect to newObject 
                    jsr      newObject 
                    lbpl     cs_done_no 
                    ldd      #-20 
                    stu      CHILD_1,y 
                    sty      DRAGON, u 
                    jsr      initDragonChild 
                    jsr      newObject 
                    lbpl     cs_done_no 
                    ldd      #-40 
                    stu      CHILD_2,y 
                    sty      DRAGON, u 
                    jsr      initDragonChild 
                    rts      

; initializes the dragon child
; in u pointer to child
; in y pointer to dragon
; in a angle offset
; must leave with y intact
initDragonChild 
                    leax     ,u 
                    std      ANGLE_OFFSET, x 
                    addd     ANGLE,y 
                    cmpd     #720 
                    blt      noAngleChange_idc 
                    subd     #720 
noAngleChange_idc 
                    std      ANGLE, x 
                    ldu      #circle 
                    leau     d,u                          ; u pointer to spwan angle coordinates 
                    ldd      ,u 
                    std      Y_POS,x                      ; save start pos 
                    lda      #TYPE_DRAGONCHILD 
                    sta      TYPE, x 
                    ldd      #dragonchildBoundBehaviour 
                    std      BEHAVIOUR,x 
                    ldd      #Dragonchild_List            ; vectorlist 
                    std      CURRENT_LIST,x 
                    lda      #$ff 
                    sta      DDRA,x                       ; performance dummy 
                    ldb      SCALE,y 
                    lda      ANGLE_OFFSET+1, x 
                    nega     
                    lsra     
                    sta      SCALE_OFFSET, x 
                    addb     SCALE_OFFSET, x 
                    stb      SCALE,x 
                    rts      

dragonchildBoundBehaviour                                 ;#isfunction  
                                                          ; do the scaling 
;                    ldu      NEXT_OBJECT+u_offset1,u      ; preload next user stack 
;                    pulu     d,x,y,pc                     ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 
                    sty      VIA_DDR_a                    ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
; start the move to
; following calcs can be done within that move
                    MY_MOVE_TO_D_START  
                    ldy      DRAGON+u_offset1,u 
                    lda      SCALE,y 
                    adda     SCALE_OFFSET+u_offset1, u 
                    sta      SCALE+u_offset1,u 
                    ldd      ANGLE,y                      ; from dragon 
                    addd     ANGLE_OFFSET+u_offset1,u     ; from child 
; cmpd #720
                    bpl      noAngleChange_dcb 
                    addd     #720 
noAngleChange_dcb 
                    std      ANGLE+u_offset1,u 
                    ldy      #circle 
                    leay     d,y                          ; u pointer to spwan angle coordinates 
                    ldd      ,y 
                    std      Y_POS+u_offset1,u            ; save start pos 
                    lda      #$5f                         ; intensity 
                    ldu      NEXT_OBJECT+u_offset1,u      ; preload next user stack 
                    MY_MOVE_TO_B_END                      ; end a move to 
                    _INTENSITY_A  
                    lda      #6 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    jsr      myDraw_VL_mode 
                    _ZERO_VECTOR_BEAM  
                    pulu     d,x,y,pc                     ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 

dragonchildFreeBehaviour;#isfunction  
                                                          ; do the scaling 
                    sty      VIA_DDR_a                    ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
; start the move to
; following calcs can be done within that move
                    MY_MOVE_TO_D_START  
                    lda      SCALE+u_offset1,u            ; load current scale to a - for later calcs 
                    suba     #DRAGON_CHILD_FREE_SPEED     ; and actually descrease the scale with the "decrease" value 
                    bcs      die_dcfb                       ; if below zero, than base reaches 
                    cmpa     #BASE_SCALE+3                ; if lower base scale, than also dead 
                    bhi      base_not_reached_dcfb 
; if we reached the base - 
; a) moveto was SMALL - finished anyway
; b) not interested in move - nothing will be drawn anymore!
; MY_MOVE_TO_B_END
die_dcfb 
; cancle move
                    _ZERO_VECTOR_BEAM  
                    jmp      gameOver                     ; if base was hit -> game over 

base_not_reached_dcfb: 
                    sta      SCALE+u_offset1,u            ; store the calculated scale (used next round) 
no_scale_update_dcfb: 
                    ldu      NEXT_OBJECT+u_offset1,u      ; preload next user stack 
                    lda      #$7f                         ; intensity 
                    MY_MOVE_TO_B_END                      ; end a move to 
                    _INTENSITY_A  
                    lda      #6 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    jsr      myDraw_VL_mode 
                    _ZERO_VECTOR_BEAM  
                    pulu     d,x,y,pc                     ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; behaviours control (action) and draw all objects
; each object type has an individual behaviour
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; values are set from "u" list as:
;      pulu     pc,d,x,y ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 
dragonBehaviour                                           ;#isfunction  
                                                          ; do the scaling 
                    sty      VIA_DDR_a                    ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
; start the move to
; following calcs can be done within that move
                    MY_MOVE_TO_D_START  
                    ldd      ANGLE+u_offset1,u            ; load current scale to a - for later calcs 
                    addd     #2 
                    cmpd     #720 
                    blo      dragonAngleOk_db 
                    subd     #720 
dragonAngleOk_db 
                    std      ANGLE+u_offset1,u            ; load current scale to a - for later calcs 
                    ldy      #circle 
                    leay     d,y                          ; u pointer to spwan angle coordinates 
                    ldd      ,y 
                    std      Y_POS+u_offset1,u            ; save start pos 
                    dec      DRAGON_COUNTER+u_offset1, u  ; see if wee need calc at all, compare tick counter with below zero 
                    bpl      no_scale_update_db           ; if not, scale will not be updated 
                    ldb      Dragon_add_delay             ; otherwise reset the delay counter for scale update (this is global now, should I use that from the structure?) 
                    stb      DRAGON_COUNTER+u_offset1, u  ; store it 
                    lda      SCALE+u_offset1,u            ; load current scale to a - for later calcs 
                    deca     
                    sta      SCALE+u_offset1,u            ; store the calculated scale (used next round) 
                    cmpa     #BASE_SCALE+3                ; if lower base scale, than also dead 
                    bhi      base_not_reached_db 
; if we reached the base - 
; a) moveto was SMALL - finished anyway
; b) not interested in move - nothing will be drawn anymore!
; MY_MOVE_TO_B_END
die_db: 
; cancle move
; following is not really necessary - since the player is dead anyway

; but as long as game over is only a "remove" this makes sense
 pshs x
 ldx CHILD_1+u_offset1,u
 beq no_child1_ex_db
 ldd #dragonchildFreeBehaviour
 std BEHAVIOUR,x   
 ldd #0
 std DRAGON,x   
no_child1_ex_db
 ldx CHILD_2+u_offset1,u
 beq explodeDragonDone_ex_db
 ldd #dragonchildFreeBehaviour
 std BEHAVIOUR,x   
 ldd #0
 std DRAGON,x   
explodeDragonDone_ex_db
 puls x


                    _ZERO_VECTOR_BEAM  
                    jmp      gameOver                     ; if base was hit -> game over 

base_not_reached_db: 
no_scale_update_db: 
                    lda      RecalCounterLow 
                    bita     #$01 
                    beq      no_anim_update_db 
                    ldd      CURRENT_LIST+u_offset1,u 
                    addd     #(DragonList_1-DragonList_0) 
                    cmpd     #(DragonList_3+(DragonList_1-DragonList_0)) 
                    bne      not_last_anim_db 
                    ldd      #DragonList_0 
not_last_anim_db: 
                    std      CURRENT_LIST+u_offset1,u 
no_anim_update_db: 
                    lda      #$4f                         ; intensity 
                    ldb      TYPE+u_offset1,u 
                    cmpb     #20 
                    blt      half_dead_dragon 
                    lda      #$7f                         ; intensity 
half_dead_dragon: 
                    ldu      NEXT_OBJECT+u_offset1,u      ; preload next user stack 
                    MY_MOVE_TO_B_END                      ; end a move to 
                    _INTENSITY_A  
                    lda      #6 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    jsr      drawRotated_o 
                    _ZERO_VECTOR_BEAM  
                    pulu     d,x,y,pc                     ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 
