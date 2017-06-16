u_offset1           =        -TYPE                        ; behaviour offset is determined by next structure element 
; all following objects "inherit" from defined Objectstruct
; all vars after "NEXT_OBJECT" can be different for each of the objects
;
; all definitions with the same name must be at the same structure position
                    struct   DragonObjectStruct 
                    ds       Y_POS,1                      ; current position 
                    ds       X_POS,1 
                    ds       CURRENT_LIST,2               ; current list vectorlist 
                    ds       DDRA,1 
                    ds       SCALE,1                      ; scale to position the object 
                    ds       BEHAVIOUR,2 
                    ds       TYPE,1                       ; enemy type 
                    ds       ANGLE,2                      ; if angle base, angle in degree *2 
                    ds       PREVIOUS_OBJECT,2            ; positive = start of list 
                    ds       NEXT_OBJECT,2                ; positive = end of list 
                    ds       DRAGON_COUNTER,1             ; how many times was I hit? 
                    ds       CHILD_1, 2 
                    ds       CHILD_2, 2 
                    ds       filler, 0                    ; #noDoubleWarn 
                    end struct 
;
                    struct   DragonChildObjectStruct 
                    ds       Y_POS,1                      ; current position 
                    ds       X_POS,1 
                    ds       CURRENT_LIST,2               ; current list vectorlist 
                    ds       DDRA,1 
                    ds       SCALE,1                      ; scale to position the object 
                    ds       BEHAVIOUR,2 
                    ds       TYPE,1                       ; enemy type 
                    ds       ANGLE,2                      ; if angle base, angle in degree *2 
                    ds       PREVIOUS_OBJECT,2            ; positive = start of list 
                    ds       NEXT_OBJECT,2                ; positive = end of list 
                    ds       ANGLE_OFFSET,2               ; two byte for easier adding 
                    ds       DRAGON, 2                    ; my parent - I have to tell him when I die 
                    ds       SCALE_OFFSET, 1 
                    ds       filler, 0                    ; #noDoubleWarn 
                    end struct 
;
                    struct   XObjectStruct 
                    ds       Y_POS,1                      ; current position 
                    ds       X_POS,1 
                    ds       CURRENT_LIST,2               ; current list vectorlist 
                    ds       DDRA,1 
                    ds       SCALE,1                      ; scale to position the object 
                    ds       BEHAVIOUR,2 
                    ds       TYPE,1                       ; enemy type 
                    ds       ANGLE,2                      ; if angle base, angle in degree *2 
                    ds       PREVIOUS_OBJECT,2            ; positive = start of list 
                    ds       NEXT_OBJECT,2                ; positive = end of list 
                    ds       ANIM_COUNTER,1               ; with what value does the animation get updated 
                    ds       TICK_COUNTER,1               ; after how many rounds the movement updates (0 = each, 1 = every second etc) 
                    ds       SCALE_DELTA,1                ; with what value does the movement get updated (1-4)? 
                    ds       filler, 2                    ; #noDoubleWarn 
                    end struct 
;
                    struct   ShotObjectStruct 
                    ds       Y_POS,1                      ; current position 
                    ds       X_POS,1 
                    ds       CURRENT_LIST,2               ; current list vectorlist 
                    ds       DDRA,1 
                    ds       SCALE,1                      ; scale to position the object 
                    ds       BEHAVIOUR,2 
                    ds       TYPE,1                       ; enemy type 
                    ds       ANGLE,2                      ; if angle base, angle in degree *2 
                    ds       PREVIOUS_OBJECT,2            ; positive = start of list 
                    ds       NEXT_OBJECT,2                ; positive = end of list 
                    ds       filler, 1                    ; #noDoubleWarn 
                    ds       TICK_COUNTER,1               ; after how many rounds the movement updates (0 = each, 1 = every second etc) 
                    ds       SCALE_DELTA,1                ; with what value does the movement get updated (1-4)? 
                    ds       filler, 2                    ; #noDoubleWarn 
                    end struct 
;
                    struct   HunterObjectStruct 
                    ds       Y_POS,1                      ; current position 
                    ds       X_POS,1 
                    ds       CURRENT_LIST,2               ; current list vectorlist 
                    ds       DDRA,1 
                    ds       SCALE,1                      ; scale to position the object 
                    ds       BEHAVIOUR,2 
                    ds       TYPE,1                       ; enemy type 
                    ds       ANGLE,2                      ; if angle base, angle in degree *2 
                    ds       PREVIOUS_OBJECT,2            ; positive = start of list 
                    ds       NEXT_OBJECT,2                ; positive = end of list 
                    ds       filler, 1                    ; #noDoubleWarn 
                    ds       TICK_COUNTER,1               ; after how many rounds the movement updates (0 = each, 1 = every second etc) 
                    ds       SCALE_DELTA,1                ; with what value does the movement get updated (1-4)? 
                    ds       filler, 2                    ; #noDoubleWarn 
                    end struct 
;
                    struct   BomberObjectStruct 
                    ds       Y_POS,1                      ; current position 
                    ds       X_POS,1 
                    ds       CURRENT_LIST,2               ; current list vectorlist 
                    ds       DDRA,1 
                    ds       SCALE,1                      ; scale to position the object 
                    ds       BEHAVIOUR,2 
                    ds       TYPE,1                       ; enemy type 
                    ds       ANGLE,2                      ; if angle base, angle in degree *2 
                    ds       PREVIOUS_OBJECT,2            ; positive = start of list 
                    ds       NEXT_OBJECT,2                ; positive = end of list 
                    ds       ANIM_COUNTER,1               ; with what value does the animation get updated 
                    ds       ANGLE_TICK_COUNTER,1         ; after how many rounds the movement updates (0 = each, 1 = every second etc) 
                    ds       SHOT_COUNTER_RESET,1         ; after how many ticks will the counter be resetd next time 
                    ds       SHOT_COUNTER,1               ; after how many ticks do I shoot again? 
                    ds       ANGLE_DELTA, 1               ; add to angle each countdown 
                    ds       filler, 0                    ; #noDoubleWarn 
                    end struct 
;
                    struct   StarletObjectStruct 
                    ds       Y_POS,1                      ; current position 
                    ds       X_POS,1 
                    ds       CURRENT_LIST,2               ; current list vectorlist 
                    ds       DDRA,1 
                    ds       SCALE,1                      ; scale to position the object 
                    ds       BEHAVIOUR,2 
                    ds       TYPE,1                       ; enemy type 
                    ds       ANGLE,2                      ; if angle base, angle in degree *2 
                    ds       PREVIOUS_OBJECT,2            ; positive = start of list 
                    ds       NEXT_OBJECT,2                ; positive = end of list 
                    ds       ANIM_COUNTER,1               ; jmp to current draw routine 
                    ds       SCORE_COUNTER, 1             ; next time I spawn a bonus score 
                    ds       SCORE_COUNT, 1               ; what is the current bonus score (2-255) 
                    ds       I_AM_STAR_NO, 1              ; what number of star am I (0-2) 
                    ds       filler, 0                    ; #noDoubleWarn 
                    end struct 
;
                    struct   ExplosionObjectStruct 
                    ds       Y_POS,1                      ; current position 
                    ds       X_POS,1 
                    ds       CURRENT_LIST,2               ; current list vectorlist 
                    ds       DDRA,1 
                    ds       SCALE,1                      ; scale to position the object 
                    ds       BEHAVIOUR,2 
                    ds       TYPE,1                       ; enemy type 
                    ds       ANGLE,2                      ; if angle base, angle in degree *2 
                    ds       PREVIOUS_OBJECT,2            ; positive = start of list 
                    ds       NEXT_OBJECT,2                ; positive = end of list 
                    ds       EXPLOSION_SCALE,1 
                    ds       filler, 4                    ; #noDoubleWarn 
                    end struct 
;
                    struct   ScoreObjectStruct 
                    ds       Y_POS,1                      ; current position 
                    ds       X_POS,1 
                    ds       CURRENT_LIST,2               ; current list vectorlist 
                    ds       DDRA,1 
                    ds       SCALE,1                      ; scale to position the object 
                    ds       BEHAVIOUR,2 
                    ds       TYPE,1                       ; enemy type 
                    ds       ANGLE,2                      ; if angle base, angle in degree *2 
                    ds       PREVIOUS_OBJECT,2            ; positive = start of list 
                    ds       NEXT_OBJECT,2                ; positive = end of list 
                    ds       SCORE_COUNTDOWN,1            ; how long will I be displayed (countdon to zero) 
                    ds       filler, 4                    ; #noDoubleWarn 
                    end struct 
;
                    struct   ScoreXObjectStruct 
                    ds       Y_POS,1                      ; current position 
                    ds       X_POS,1 
                    ds       SCORE_POINTER_1,2            ; current list vectorlist of first score digit 
                    ds       DDRA,1 
                    ds       SCALE,1                      ; scale to position the object 
                    ds       BEHAVIOUR,2 
                    ds       TYPE,1                       ; enemy type 
                    ds       ANGLE,2                      ; if angle base, angle in degree *2 
                    ds       PREVIOUS_OBJECT,2            ; positive = start of list 
                    ds       NEXT_OBJECT,2                ; positive = end of list 
                    ds       SCORE_COUNTDOWN,1            ; how long will I be displayed (countdon to zero) 
                    DS       SCORE_POINTER_2,2            ; current list vectorlist of second score digit 
                    DS       SCORE_POINTER_3,2            ; current list vectorlist of third score digit 
                    ds       filler, 0                    ; #noDoubleWarn 
                    end struct 
;
                    struct   TimerObjectStruct 
                    ds       Y_POS,1                      ; current position 
                    ds       X_POS,1 
                    ds       CURRENT_LIST,2               ; current list vectorlist of first score digit 
                    ds       DDRA,1 
                    ds       SCALE,1                      ; scale to position the object 
                    ds       BEHAVIOUR,2 
                    ds       TYPE,1                       ; enemy type 
                    ds       ANGLE,2                      ; if angle base, angle in degree *2 
                    ds       PREVIOUS_OBJECT,2            ; positive = start of list 
                    ds       NEXT_OBJECT,2                ; positive = end of list 
                    ds       SECOND_COUNTER,1             ; initialized with 50 again and again and countdown 
                    ds       filler, 4                    ; #noDoubleWarn 
                    end struct 
                    code     
; all behaviour routines leave
; with u pointed to the next object structure 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; GENERAL Object functions
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
; sets u to pointer of next object in linked list 
removeObject:                                             ;#isfunction  
; since often called from "in move" we disable the move!
                    ldd      #0 
                    std      VIA_t1_cnt_lo                ; disable ramping 
                    _ZERO_VECTOR_BEAM  
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
; new list object to U
; leaves with flags set to result
; (positive = not successfull) ROM
; negative = successfull RAM
; destroys d, u , x
newObject                                                 ;#isfunction  
                    ldu      list_empty_head 
                    bpl      cs_done_no                   ; we don't have any spare objects -> go out 
; set the new empty head
                    ldd      NEXT_OBJECT,u 
                    std      list_empty_head 
; load last of current object list
                    ldx      list_objects_tail 
; of our new object, that last object is the previous
                    stx      PREVIOUS_OBJECT,u 
                    bpl      no_next_no                   ; the last object was 0, so we do net set a next there 
; of the last object, the new object is the next object
                    stu      NEXT_OBJECT,x 
                    bra      was_not_only_no 

no_next_no: 
                    stu      list_objects_head            ; if there was no last, than also no first -> therefor set new object as head 
was_not_only_no: 
; the next object of our current object is null, since we are last
                    ldd      #PC_MAIN 
                    std      NEXT_OBJECT,u 
; our new object is the new tail
                    stu      list_objects_tail 
cs_done_no 
                    rts      

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
                    bitb     #ALLOW_X 
                    bne      spx_allowed 
                    clr      spawn_timer                  ; check spawn next round again 
                    jmp      returnSpawnNotAllowed 

spx_allowed: 
                    bsr      newObject 
                    bpl      cs_done_no 
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
; if we reached the base - 
; a) moveto was SMALL - finished anyway
; b) not interested in move - nothing will be drawn anymore!
; MY_MOVE_TO_B_END
die_xb 
; cancle move
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
                    lda      #6 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    lda      #$5f                         ; intensity 
                    MY_MOVE_TO_B_END                      ; end a move to 
                    _INTENSITY_A  
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
                    bitb     #ALLOW_HUNTER 
                    bne      sph_allowed 
                    clr      spawn_timer                  ; check spawn next round again 
                    jmp      returnSpawnNotAllowed 

sph_allowed: 
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
; following calculates the correct angle vectorlist for the hunter
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
                    jmp      gameOver                     ; if base was hit -> game over 

base_not_reached_hb: 
                    sta      SCALE+u_offset1,u            ; store the calculated scale (used next round) 
no_scale_update_hb: 
                    ldu      NEXT_OBJECT+u_offset1,u      ; preload next user stack 
                    ldy      ,x++                         ; load offset of vector list draw 
                    leay     >(unloop_start_addressSub+LENGTH_OF_HEADER),y ; 
                    lda      #$5f                         ; intensity 
                    MY_MOVE_TO_B_END                      ; end a move to 
                    _INTENSITY_A  
                    jsr      entry_optimized_draw_mvlc_unloop 
                    ldd      #$cc98 
                    sta      <VIA_cntl                    ; 22 cycles from switch on ZERO disabled, and BLANK enabled 
                    STb      <VIA_aux_cntl                ; 
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
                    bitb     #ALLOW_HIDDEN_X 
                    bne      sphx_allowed 
                    clr      spawn_timer                  ; check spawn next round again 
                    jmp      returnSpawnNotAllowed 

sphx_allowed: 
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
                    adda     #$8f 
                    bpl      no_int_hxb 
                    suba     #$10 
no_int_hxb: 
                    ldb      #6 
                    stb      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    MY_MOVE_TO_B_END                      ; end a move to 
                    _INTENSITY_A  
                    jsr      myDraw_VL_mode 
                    _ZERO_VECTOR_BEAM  
                    pulu     d,x,y,pc                     ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 
******************************  
***** EXPLOSION ************** 
******************************  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
explosionBehaviour                                        ;#isfunction  
                    sty      VIA_DDR_a                    ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
; start the move to
; following calcs can be done within that move
                    MY_MOVE_TO_D_START                    ; move to last know position of object 
                    lda      EXPLOSION_SCALE+u_offset1,u 
                    inca     
                    inca     
                    sta      EXPLOSION_SCALE+u_offset1,u 
                    cmpa     #EXPLOSION_MAX 
                    lbgt     removeObject 
                    sta      VIA_t1_cnt_lo                ; explosion scale 
                    ldx      #rotList                     ; reuse of the rotation list of shield/base 
                    lda      ,x+                          ; get count of vectors 
                    sta      tmp_count2 
                    lda      #$7f                         ; explosions are bright! 
                    ldu      NEXT_OBJECT+u_offset1,u      ; correct U for going out later 
                    MY_MOVE_TO_B_END                      ; end a move to 
                    _INTENSITY_A  
next_edd: 
                    ldd      ,x++                         ; load the corners of the polygon 
                    MY_MOVE_TO_D_START                    ; move to the corner, and draw a dot at every corner 
                    lda      #$ff                         ; preload shift 
                    MY_MOVE_TO_B_END                      ; end a move to 
                    STA      <VIA_shift_reg               ; Store in VIA shift register 
; delay for dot dwell
                    CLR      <VIA_shift_reg               ; Blank beam in VIA shift register 
                    dec      tmp_count2                   ; check if vector count finished 
                    bpl      next_edd                     ; if not - draw next dot 
done_edd: 
                    _ZERO_VECTOR_BEAM  
                    pulu     d,x,y,pc                     ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
******************************  
***** SCORE ****************** 
******************************  
scoreBehaviour                                            ;#isfunction  
                    sty      VIA_DDR_a                    ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
                    MY_MOVE_TO_D_START  
                    cmpy     #$ff*256+SHIELD_MAX_SCALE 
                    lbhi     removeObject                 ; if score scale is higher than max shield - don't bother displaying it 
                    dec      SCORE_COUNTDOWN+u_offset1,u 
                    lbeq     removeObject 
                    lda      RecalCounterLow 
                    bita     #$01 
                    beq      noAdd_sb 
                    inc      SCALE+u_offset1,u 
noAdd_sb: 
                    lda      #3 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    lda      #$5f 
                    ldu      NEXT_OBJECT+u_offset1,u 
                    MY_MOVE_TO_B_END                      ; end a move to 
                    _INTENSITY_A  
                    jsr      myDraw_VL_mode 
                    _ZERO_VECTOR_BEAM  
                    pulu     d,x,y,pc                     ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 
******************************  
***** SCORE X***************** 
******************************  
; special
; the X vectorlist(s)
; are generated in move to
scoreXBehaviour                                           ;#isfunction  
                    sty      VIA_DDR_a                    ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
                    MY_MOVE_TO_D_START  
                    cmpy     #$ff*256+SHIELD_MAX_SCALE 
                    lbhi     removeObject                 ; if score scale is higher than max shield - don't bother displaying it 
                    dec      SCORE_COUNTDOWN+u_offset1,u 
                    lbeq     removeObject 
                    lda      RecalCounterLow 
                    bita     #$01 
                    beq      noAdd_sxb 
                    inc      SCALE+u_offset1,u 
noAdd_sxb: 
                    lda      #3 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    lda      #$5f 
                    MY_MOVE_TO_B_END                      ; end a move to 
                    _INTENSITY_A  
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
                    ldu      NEXT_OBJECT+u_offset1,u 
                    _ZERO_VECTOR_BEAM  
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
                    bitb     #ALLOW_STAR 
                    bne      sps_allowed 
                    clr      spawn_timer                  ; check spawn next round again 
                    jmp      returnSpawnNotAllowed 

sps_allowed: 
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
; in x now pointer to lowest csa score
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
                    lda      #3 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    lda      #$5f                         ; intensity 
                    ldy      ,x++                         ; load offset of vector list draw 
                    leay     >(unloop_start_addressSub+LENGTH_OF_HEADER),y ; 
                    MY_MOVE_TO_B_END                      ; end a move to 
                    _INTENSITY_A  
                    jsr      entry_optimized_draw_mvlc_unloop 
                    ldd      #$cc98 
                    sta      <VIA_cntl                    ; 22 cycles from switch on ZERO disabled, and BLANK enabled 
                    STb      <VIA_aux_cntl                ; 
                    pulu     d,x,y,pc                     ; (D = y,x, X = vectorlist, Y = DDRA+Scale) ****************************** 
******************************  
***** OBJECT BOMBER **********
******************************  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Bomber SPAWN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; in x pointer to new object structure that should be filled with object 
; data
spawnBomber:                                              ;        #isfunction 
                    bitb     #ALLOW_BOMBER 
                    bne      spb_allowed 
                    clr      spawn_timer                  ; check spawn next round again 
                    jmp      returnSpawnNotAllowed 

spb_allowed: 
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
                    lda      bomber_delay_start 
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
bomberBehaviour:                                          ;#isfunction  
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
                    suba     #BOMB_RELOAD_REDUCTION 
                    cmpa     minimum_bomb_reload 
                    bhi      short_timer_ok 
                    lda      minimum_bomb_reload 
short_timer_ok 
                    sta      SHOT_COUNTER+u_offset1, u 
                    sta      SHOT_COUNTER_RESET+u_offset1, u 
                    pshs     x,u 
                    jsr      buildShot 
                    puls     x,u 
no_shot_update_bb 
                    ldu      NEXT_OBJECT+u_offset1,u      ; preload next user stack 
                    lda      #6 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    lda      #$5f                         ; intensity 
                    MY_MOVE_TO_B_END                      ; end a move to 
                    ldy      ,x++                         ; load offset of vector list draw 
                    leay     >(unloop_start_addressSub+LENGTH_OF_HEADER),y ; 
                    _INTENSITY_A  
                    jsr      entry_optimized_draw_mvlc_unloop 
                    ldd      #$cc98 
                    sta      <VIA_cntl                    ; 22 cycles from switch on ZERO disabled, and BLANK enabled 
                    STb      <VIA_aux_cntl                ; 
                    pulu     d,x,y,pc                     ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
                    jmp      gameOver                     ; if base was hit -> game over 

base_not_reached_sb: 
                    sta      SCALE+u_offset1,u            ; store the calculated scale (used next round) 
no_scale_update_sb: 
                    ldu      NEXT_OBJECT+u_offset1,u      ; preload next user stack 
                    lda      #6 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    lda      #$7f                         ; intensity 
                    ldy      ,x++                         ; load offset of vector list draw 
                    leay     >(unloop_start_addressSub_2+LENGTH_OF_HEADER),y ; 
                    MY_MOVE_TO_B_END                      ; end a move to 
                    _INTENSITY_A  
                    jsr      my_drawVLC_inner 
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
                    bitb     #ALLOW_DRAGON 
                    bne      spd_allowed 
                    clr      spawn_timer                  ; check spawn next round again 
                    jmp      returnSpawnNotAllowed 

spd_allowed: 
                    jsr      newObject 
                    lbpl     cs_done_no 
                    leax     ,u                           ; pointer to new object 
                    PLAY_SFX  SpawnDragon_Sound 
; copy and initialze new enemy
                    lda      #TYPE_DRAGON +$40            ; + $40 means it has two shots until dead 
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
; spawn children
                    ldd      #0                           ; vectorlist 
                    std      CHILD_1,x 
                    std      CHILD_2,x 
                    tfr      x,y                          ; y is save in respect to newObject 
                    jsr      newObject 
                    lbpl     cs_done_no 
                    ldd      #-20 
                    stu      CHILD_1,y 
                    sty      DRAGON, u 
                    bsr      initDragonChild 
                    jsr      newObject 
                    lbpl     cs_done_no 
                    ldd      #-40 
                    stu      CHILD_2,y 
                    sty      DRAGON, u 
                    bsr      initDragonChild 
                    rts      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dragonchildBoundBehaviour                                 ;#isfunction  
                                                          ; do the scaling 
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
                    bpl      noAngleChange_dcb 
                    addd     #720 
noAngleChange_dcb 
                    std      ANGLE+u_offset1,u 
                    ldy      #circle 
                    leay     d,y                          ; u pointer to spwan angle coordinates 
                    ldd      ,y 
                    std      Y_POS+u_offset1,u            ; save start pos 
                    lda      #6 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    lda      #$5f                         ; intensity 
                    ldu      NEXT_OBJECT+u_offset1,u      ; preload next user stack 
                    MY_MOVE_TO_B_END                      ; end a move to 
                    _INTENSITY_A  
                    jsr      myDraw_VL_mode 
                    _ZERO_VECTOR_BEAM  
                    pulu     d,x,y,pc                     ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dragonchildFreeBehaviour                                  ;  #isfunction 
                                                          ; do the scaling 
                    sty      VIA_DDR_a                    ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
; start the move to
; following calcs can be done within that move
                    MY_MOVE_TO_D_START  
                    lda      SCALE+u_offset1,u            ; load current scale to a - for later calcs 
                    suba     dragonchild_addi             ; and actually decrease the scale with the "decrease" value 
                    bcs      die_dcfb                     ; if below zero, than base reaches 
                    cmpa     #BASE_SCALE+3                ; if lower base scale, than also dead 
                    bhi      base_not_reached_dcfb 
; if we reached the base - 
; a) moveto was SMALL - finished anyway
; b) not interested in move - nothing will be drawn anymore!
; MY_MOVE_TO_B_END
die_dcfb 
; cancle move
                    jmp      gameOver                     ; if base was hit -> game over 

base_not_reached_dcfb: 
                    sta      SCALE+u_offset1,u            ; store the calculated scale (used next round) 
no_scale_update_dcfb: 
                    ldu      NEXT_OBJECT+u_offset1,u      ; preload next user stack 
                    lda      #6 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    lda      #$7f                         ; intensity 
                    MY_MOVE_TO_B_END                      ; end a move to 
                    _INTENSITY_A  
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
                    pshs     x 
                    ldx      CHILD_1+u_offset1,u 
                    beq      no_child1_ex_db 
                    ldd      #dragonchildFreeBehaviour 
                    std      BEHAVIOUR,x 
                    ldd      #0 
                    std      DRAGON,x 
no_child1_ex_db 
                    ldx      CHILD_2+u_offset1,u 
                    beq      explodeDragonDone_ex_db 
                    ldd      #dragonchildFreeBehaviour 
                    std      BEHAVIOUR,x 
                    ldd      #0 
                    std      DRAGON,x 
explodeDragonDone_ex_db 
                    puls     x 
                    jmp      gameOver                     ; if base was hit -> game over 

base_not_reached_db: 
no_scale_update_db: 
                    lda      RecalCounterLow              ; only every second tick 
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
                    lda      #6 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    lda      #$4f                         ; intensity 
                    ldb      TYPE+u_offset1,u 
                    cmpb     #20 
                    blt      half_dead_dragon 
                    lda      #$7f                         ; intensity 
half_dead_dragon: 
                    ldu      NEXT_OBJECT+u_offset1,u      ; preload next user stack 
                    ldy      ,x++                         ; load offset of vector list draw 
                    leay     >(unloop_start_addressSub+LENGTH_OF_HEADER),y ; 
                    MY_MOVE_TO_B_END                      ; end a move to 
                    _INTENSITY_A  
                    jsr      entry_optimized_draw_mvlc_unloop 
                    ldd      #$cc98 
                    sta      <VIA_cntl                    ; 22 cycles from switch on ZERO disabled, and BLANK enabled 
                    STb      <VIA_aux_cntl                ; 
                    pulu     d,x,y,pc                     ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 
******************************  
***** OBJECT BONUS *********** 
******************************  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Bonus SPAWN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; in x pointer to new object structure that should be filled with object 
; data
spawnBonus:                                               ;        #isfunction 
                    bitb     #ALLOW_BONUS 
                    bne      bonux_allowed 
                    clr      spawn_timer                  ; check spawn next round again 
                    jmp      returnSpawnNotAllowed 

bonux_allowed: 
                    jsr      newObject 
                    lbpl     cs_done_no 
                    inc      bonusCounter+1               ; disable other bonus spawns 
                    leax     ,u                           ; pointer to new object 
                    PLAY_SFX  SpawnBonus_Sound 
; copy and initialze new enemy
                    lda      #TYPE_BONUS 
                    sta      TYPE, x 
                    lda      Bonus_add_delay 
                    sta      TICK_COUNTER, x 
                    lda      Bonus_addi 
                    sta      SCALE_DELTA, x 
                    ldd      #bonusBehaviour 
                    std      BEHAVIOUR,x 
                    lda      #BONUS_ANIM_DELAY            ; anim reset 
                    sta      ANIM_COUNTER, x 
                    ldd      #BonusList_0                 ; vectorlist 
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
bonusBehaviour                                            ;#isfunction  
                                                          ; do the scaling 
                    sty      VIA_DDR_a                    ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
; start the move to
; following calcs can be done within that move
                    MY_MOVE_TO_D_START  
                    lda      SCALE+u_offset1,u            ; load current scale to a - for later calcs 
                    dec      TICK_COUNTER+u_offset1, u    ; see if wee need calc at all, compare tick counter with below zero 
                    bpl      no_scale_update_bob          ; if not, scale will not be updated 
                    ldb      X_add_delay                  ; otherwise reset the delay counter for scale update (this is global now, should I use that from the structure?) 
                    stb      TICK_COUNTER+u_offset1, u    ; store it 
                    suba     SCALE_DELTA+u_offset1, u     ; and actually descrease the scale with the "decrease" value 
                    bcs      get_bob                      ; if below zero, than base reaches 
                    cmpa     #BASE_SCALE+3                ; if lower base scale, than also dead 
                    bhi      base_not_reached_bob 
; if we reached the base - 
; a) moveto was SMALL - finished anyway
; b) not interested in move - nothing will be drawn anymore!
; MY_MOVE_TO_B_END
get_bob: 
; cancle move
                    jmp      initBonus                    ; if base was hit -> game over 

base_not_reached_bob: 
                    sta      SCALE+u_offset1,u            ; store the calculated scale (used next round) 
no_scale_update_bob: 
                    dec      ANIM_COUNTER+u_offset1, u    ; see if wee need calc at all, compare tick counter with below zero 
                    bpl      no_anim_update_bob           ; if not, scale will not be updated 
                    lda      #X_ANIM_DELAY                ; anim reset 
                    sta      ANIM_COUNTER+u_offset1, u 
                    ldd      CURRENT_LIST+u_offset1,u 
                    addd     #(BonusList_1-BonusList_0) 
                    cmpd     #(BonusList_16+(BonusList_1-BonusList_0)) 
                    bne      not_last_anim_bob 
                    ldd      #BonusList_0 
not_last_anim_bob: 
                    std      CURRENT_LIST+u_offset1,u 
no_anim_update_bob: 
                    ldu      NEXT_OBJECT+u_offset1,u      ; preload next user stack 
                    lda      #6 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    lda      #$5f                         ; intensity 
                    MY_MOVE_TO_B_END                      ; end a move to 
                    _INTENSITY_A  
                    jsr      myDraw_VL_mode 
                    _ZERO_VECTOR_BEAM  
                    pulu     d,x,y,pc                     ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 
******************************  
***** TIMER ****************** 
******************************  
; special
; the X vectorlist(s)
; are generated in move to
timerBehaviour                                            ;#isfunction  
                    sty      VIA_DDR_a                    ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
                    MY_MOVE_TO_D_START  
                    tst      bonus_time_1 
                    beq      smallBonusTimer 
; large bonus timer
                    ldy      bonusCounter 
                    leay     -1,y 
                    sty      bonusCounter 
                    beq      endBonus 
                    dec      SECOND_COUNTER+u_offset1,u 
                    bne      noTimerChange_tblarge 
                    lda      #50 
                    sta      SECOND_COUNTER+u_offset1,u 
                    dec      bonus_time_0 
                    bpl      no_hi_timer_change_tb 
                    lda      #9 
                    sta      bonus_time_0 
                    dec      bonus_time_1 
                    bne      still_large_timer_tb 
                    ldd      #$e0e0                       ; y,x pos -1,-10 
                    std      Y_POS+u_offset1,u 
                    bra      entry_small_timer_tb 

still_large_timer_tb 
no_hi_timer_change_tb 
noTimerChange_tblarge 
                    lda      #3 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    lda      #$5f 
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
                    pulu     d,x,y,pc                     ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
endBonus 
; todo deinit the actual bonus 
                    lbeq     removeObject 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
smallBonusTimer: 
                    ldy      bonusCounter 
                    leay     -1,y 
                    sty      bonusCounter 
                    beq      endBonus 
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
;                    MY_MOVE_TO_B_END                      ; end a move to 
                    _INTENSITY_A  
                    ldu      NEXT_OBJECT+u_offset1,u      ; preload next user stack 
                    bsr      myDraw_VL_mode 
                    _ZERO_VECTOR_BEAM  
                    pulu     d,x,y,pc                     ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 
