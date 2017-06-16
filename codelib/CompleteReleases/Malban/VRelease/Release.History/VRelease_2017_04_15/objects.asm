; this file is part of Release, written by Malban in 2017
;
; this is the offset in the below defined "stack" structure after the initial pull has been done
u_offset1           =        -TYPE                        ; behaviour offset is determined by next structure element 
; all following objects "inherit" from defined Objectstruct
; all vars after "NEXT_OBJECT" can be different for each of the objects
;
; all definitions with the same name must be at the same structure position
                    struct   LetterObjectStruct 
                    ds       Y_POS,1                      ; current position 
                    ds       X_POS,1 
                    ds       CURRENT_LIST,2               ; current list vectorlist 
                    ds       DDRA,1 
                    ds       SCALE,1                      ; scale to position the object 
                    ds       BEHAVIOUR,2 
                    ds       TYPE,1                       ; enemy type 
                    ds       ANGLE,2                      ; if angle base, angle in degree *2 
                    ds       NEXT_OBJECT,2                ; positive = end of list 
                    ds       SPACE_TO_PREVIOUS,2          ; with what value does the animation get updated 
                    ds       PREVIOUS_LETTER,2            ; after how many rounds the movement updates (0 = each, 1 = every second etc) 
                    ds       DIF_DELAY, 1                 ; #noDoubleWarn 
                    end struct 
;
                    struct   DragonObjectStruct 
                    ds       Y_POS,1                      ; current position 
                    ds       X_POS,1 
                    ds       CURRENT_LIST,2               ; current list vectorlist 
                    ds       DDRA,1 
                    ds       SCALE,1                      ; scale to position the object 
                    ds       BEHAVIOUR,2 
                    ds       TYPE,1                       ; enemy type, also holds in case of dragon whether dragon was hit befor! 
                    ds       ANGLE,2                      ; if angle base, angle in degree *2 
                    ds       NEXT_OBJECT,2                ; positive = end of list 
                    ds       DRAGON_COUNTER,1             ; DRAGON TICK_COUNTER - on a different position, therfor named differently 
; lower nibble is counter for scale move (inward)
; higher nibble is counter for angle move
                    ds       CHILD_1, 2 
                    ds       CHILD_2, 2 
                    ds       filler, 0                    ; #noDoubleWarn 
                    end struct 
;
                    struct   DragonChildObjectStruct 
                    ds       Y_POS,1                      ; current position 
                    ds       X_POS,1 
                    ds       WIGGLE,1 
                    ds       WIGGLE_DIRECTION, 1 
                                                          ; ds CURRENT_LIST,2 ; current list vectorlist 
                    ds       DDRA,1 
                    ds       SCALE,1                      ; scale to position the object 
                    ds       BEHAVIOUR,2 
                    ds       TYPE,1                       ; enemy type 
                    ds       ANGLE,2                      ; if angle base, angle in degree *2 
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
                    ds       NEXT_OBJECT,2                ; positive = end of list 
                    ds       SECOND_COUNTER,1             ; initialized with 50 again and again and countdown 
                    ds       filler, 4                    ; #noDoubleWarn 
                    end struct 
;
                    struct   StarfieldObjectStruct 
                    ds       POS_1,2                      ; current position 
                    ds       SCALE_1,1 
                    ds       POS_2,2                      ; current position 
                    ds       SCALE_2,1 
                    ds       BEHAVIOUR,2 
                    ds       TYPE,1                       ; enemy type 
                    ds       POS_3,2                      ; current position 
                    ds       NEXT_OBJECT,2                ; positive = end of list 
                    ds       POS_4,2                      ; current position 
                    ds       SCALE_4,1 
                    ds       SCALE_3, 1                   ; #noDoubleWarn 
                    end struct 
;
                    code     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; GENERAL Object functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this macro is placed at the end of each possible "remove" exit
; it stores the just removed object at the head of the "empty" list and 
; sets up its "next" pointer
UPDATE_EMPTY_LIST   macro    
                    dec      object_count 
                    ldy      list_empty_head              ; set u free, as new free head 
                    sty      NEXT_OBJECT,x                ; load to u the next linked list element 
                    stx      list_empty_head 
                    endm     
; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; in u+u_offset1 pointer to the object that must be removed
; destroys x, y 
; sets u to pointer of next object in linked list (might be the "return" structure)
; this version is called at the end of an explosion or at the
; end of a score display, called by "behaviours"
; and thus the "return" is the call of the next object thru U stack
removeObject:                                             ;#isfunction  
; since often called from "in move" we disable the move!
; set default draw values
; and zero everything
; in the hopes of less glitches (ZERO should actually do all we need)
                    ldd      #$0800 
                    sta      VIA_t1_cnt_lo                ; disable ramping 
                    stb      VIA_t1_cnt_hi                ; disable ramping 
                    MY_MOVE_TO_B_END                      ; end a move to 
                    _ZERO_VECTOR_BEAM  
                    lda      #$83                         ; a = $18, b = $83 disable RAMP, muxsel=false, channel 1 (integrators offsets) 
                    clr      <VIA_port_a                  ; Clear D/A output 
                    sta      <VIA_port_b                  ; set mux to channel 1, leave mux disabled 
                    dec      <VIA_port_b                  ; enable mux, reset integrator offset values 
                    inc      <VIA_port_b                  ; enable mux, reset integrator offset values 
; draw cleanup done, no start the remove
                    leax     u_offset1,u                  ; x -> pointer object struture (correction of offset) 
                    cmpx     list_objects_head            ; is it the first? 
                    bne      was_not_first_re             ; no -> jump 
was_first_re 
                    ldu      NEXT_OBJECT,x                ; u pointer to next objext 
                    stu      list_objects_head            ; the next object will be the first 
                    bpl      was_first_and_last_re        ; if the next is "positive" than the removed object also was the last 
was_first_not_last_re 
                    UPDATE_EMPTY_LIST                     ; if not - cleaning up of current "working" list is done 
                    pulu     d,x,y,pc                     ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 
was_first_and_last_re 
                    stu      list_objects_tail            ; if our object was also the last, than also store the "next" object (the returner) to the tail 
                    UPDATE_EMPTY_LIST                     ; and clean up the empties 
                    pulu     d,x,y,pc                     ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 
was_not_first_re                                          ;        find previous, go thru all objects from first and look where "I" am the next... 
                    ldy      list_objects_head            ; start at list head 
try_next_re 
                    cmpx     NEXT_OBJECT,y                ; am I the next object of the current investigated list element 
                    beq      found_next_switch_re         ; jup -> jump 
                    ldy      NEXT_OBJECT,y                ; otherwise load the next as new current 
                    bra      try_next_re                  ; and search further 

found_next_switch_re 
                    ldu      NEXT_OBJECT,x                ; we load "our" next object to u 
                    stu      NEXT_OBJECT,y                ; and store our next in the place of our previous next and thus eleminate ourselfs 
                    bpl      was_not_first_but_last_re    ; of our next was positive, than we were last, 
was_not_first_and_not_last_re 
                    UPDATE_EMPTY_LIST                     ; if not last, than finish and restore empties 
                    pulu     d,x,y,pc                     ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 
was_not_first_but_last_re: 
                    sty      list_objects_tail            ; otherwise our we were last, than our previous is the new last 
                    UPDATE_EMPTY_LIST                     ; and clean up the empties 
                    pulu     d,x,y,pc                     ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; the return version is called by out timing analysier
; it removes in general stars
; but might also remove the occasional explosion if
; there are to many (from shield)
; no cleanup of vectors needed
removeObject_rts:                                         ;#isfunction  
                    leax     ,u                           ; x -> pointer object struture (correction of offset) 
                    cmpx     list_objects_head            ; is it the first? 
                    bne      was_not_first_re_rts         ; no -> jump 
was_first_rts: 
                    ldu      NEXT_OBJECT,x                ; u pointer to next objext 
                    stu      list_objects_head            ; the next object will be the first 
                    bpl      was_first_and_last_rts       ; if the next is "positive" than the removed object also was the last 
was_first_not_last_rts: 
                    UPDATE_EMPTY_LIST                     ; if not - cleaning up of current "working" list is done 
                    rts      

was_first_and_last_rts: 
                    stu      list_objects_tail            ; if our object was also the last, than also store the "next" object (the returner) to the tail 
                    UPDATE_EMPTY_LIST                     ; and clean up the empties 
                    rts      

was_not_first_re_rts                                      ;      find previous, go thru all objects from first and look where "I" am the next... 
                    ldy      list_objects_head            ; start at list head 
try_next_re_rts 
                    cmpx     NEXT_OBJECT,y                ; am I the next object of the current investigated list element 
                    beq      found_next_switch_re_rts     ; jup -> jump 
                    ldy      NEXT_OBJECT,y                ; otherwise load the next as new current 
                    bra      try_next_re_rts              ; and search further 

found_next_switch_re_rts 
                    ldu      NEXT_OBJECT,x                ; we load "our" next object to u 
                    stu      NEXT_OBJECT,y                ; and store our next in the place of our previous next and thus eleminate ourselfs 
                    bpl      was_not_first_but_last_rts   ; of our next was positive, than we were last, 
was_not_first_and_not_last_rts 
                    UPDATE_EMPTY_LIST                     ; if not last, than finish and restore empties 
                    rts      

was_not_first_but_last_rts: 
                    sty      list_objects_tail            ; otherwise our we were last, than our previous is the new last 
                    UPDATE_EMPTY_LIST                     ; and clean up the empties 
                    rts      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
                    ldd      NEXT_OBJECT,u                ; the next in out empty list will be the new 
                    std      list_empty_head              ; head of our empty list 
; load last of current object list
                    ldx      list_objects_tail            ; load current last "working" object 
                    bpl      no_next_no                   ; if positive, than there was no previous last (and no head) 
; of the last object, the new object is the next object
                    stu      NEXT_OBJECT,x                ; otherwise we will be the next of that working object 
                    bra      was_not_only_no 

no_next_no: 
                    stu      list_objects_head            ; if there was no last, than also no first -> therefor set new object as head 
was_not_only_no: 
                    ldd      #PC_MAIN                     ; the next object of our current object is "return", since we are last 
                    std      NEXT_OBJECT,u 
                    inc      object_count                 ; and remember that we created a new object 
                    stu      list_objects_tail            ; our new object is the new tail 
cs_done_no 
                    rts      

;
; all behaviour routines leave
; with u pointed to the next object structure (+ offset of PUL)
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
                    bitb     #ALLOW_X                     ; first check if allowed to spawn 
                    bne      spx_allowed                  ; if so -> jumo 
                    clr      spawn_timer                  ; if not make sure to check spawn next round again 
                    jmp      returnSpawnNotAllowed        ; and jump back (to the only location we can be called from) 

spx_allowed: 
                    bsr      newObject                    ; "create" (or rather get) new object 
                    bpl      cs_done_no                   ; if positve - there is no object left, jump out 
                    leax     ,u                           ; pointer to new object now in X also 
                    ldd      #SpawnX_Sound                ; play a sound for out new spawn 
                    jsr      play_sfx 
; copy and initialze new enemy
                    lda      #TYPE_X 
                    sta      TYPE, x 
                    lda      X_add_delay                  ; delay between two scale changes (speed of object) 
                    sta      TICK_COUNTER, x 
                    lda      X_addi                       ; strength of scale change once we actually do it 
                    sta      SCALE_DELTA, x 
                    ldd      #xBehaviour 
                    std      BEHAVIOUR,x 
                    lda      #X_ANIM_DELAY                ; anim reset 
                    sta      ANIM_COUNTER, x 
                    ldd      #enemyXList_0                ; vectorlist 
                    std      CURRENT_LIST,x 
                    lda      #$ff 
                    sta      DDRA,x                       ; performance dummy 
                    lda      spawn_max                    ; maximum our object can spawn at 
                    sta      SCALE,x                      ; start with max scale (for xEnemy) 
;
; leaves with angle also in D
; stores the angle to ANGLE,x
ANGLE_0_762         macro    
; the following generates an angle between 0 - 762 degrees (we have enough angles in out list to support this) angles are "doubles" so the real angle is 0° - 381°
                    ldb      my_random2                   ; make sure this is random2 not just "random", since the random was already used in "creating" the X object, using it again leaves pretty same values for location 
                    andb     #%01111111                   ; 0 - 127 
                    clra     
                    MY_LSL_D                              ; double it 0 - 254 
                    tfr      d,u 
                    leau     d,u 
                    leau     d,u                          ; in u 0-254 times 3 -> 0 - 762 
                    stu      ANGLE,x                      ; store current angle of object 
                    endm     
;
STORE_POS_FROM_ANGLE  macro  
                    ldd      #circle                      ; circle with angle as offset gives us the actual coordinates 
                    leau     d,u                          ; u pointer to spwan angle coordinates 
                    ldd      ,u 
                    std      Y_POS,x                      ; save start pos 
                    endm     
;
                    ANGLE_0_762  
                    STORE_POS_FROM_ANGLE  
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
                    cmpa     #$80                         ; if scale is rather large, we cen decipher music in that time 
                    blo      noMusic_xb1 
                    jsr      [inMovePointer]              ; uncrunch one music "piece" 
                    lda      SCALE+u_offset1,u 
noMusic_xb1 
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
; check if animation should change
; if yes, get the new vectorlist for NEXT beheaviour round
; (current round uses the X reg from U stack)
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
                    lda      #6                           ; set scale value for next print 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    lda      #$5f                         ; and preload intensity 
                    MY_MOVE_TO_B_END                      ; end a move to 
                    _INTENSITY_A  
                    jsr      myDraw_VL_mode               ; draw the list 
                    _ZERO_VECTOR_BEAM                     ; and zero as fast as you can! 
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
                    bitb     #ALLOW_HUNTER                ; first check if allowed to spawn 
                    bne      sph_allowed                  ; if so -> jumo 
                    clr      spawn_timer                  ; if not make sure to check spawn next round again 
                    jmp      returnSpawnNotAllowed        ; and jump back (to the only location we can be called from) 

sph_allowed: 
                    jsr      newObject                    ; "create" (or rather get) new object 
                    lbpl     cs_done_no                   ; if positve - there is no object left, jump out 
                    leax     ,u                           ; pointer to new object now in X also 
                    ldd      #SpawnHunter_Sound           ; play a sound for out new spawn 
                    jsr      play_sfx 
; copy and initialze new enemy
                    lda      #TYPE_HUNTER 
                    sta      TYPE, x 
                    lda      Hunter_add_delay             ; delay between two scale changes (speed of object) 
                    sta      TICK_COUNTER, x 
                    lda      Hunter_addi                  ; strength of scale change once we actually do it 
                    sta      SCALE_DELTA, x 
                    ldd      #hunterBehaviour 
                    std      BEHAVIOUR,x 
                    lda      #$ff 
                    sta      DDRA,x                       ; performance dummy 
                    lda      spawn_max 
                    sta      SCALE,x                      ; start with max scale (for xEnemy) 
                    ldb      my_random2 
                    andb     #%01111111 
; in a random number between 0 - 127
                    clra     
                    cmpd     #120                         ; mod 120 
                    blt      noMax_dh                     ; if higher 
                    subd     #120                         ; sub 120 
; following calculates the correct angle vectorlist for the hunter
noMax_dh 
                    MY_LSL_D                              ; double it 0 - 240 
                    tfr      d,u                          ; triple it 
                    leau     d,u 
                    leau     d,u                          ; u = 0 - 720 -> spawning angle of our new enemy 
                                                          ; leau 31,u looks better with a little offset? 
                    tfr      u,d                          ; u = 0 - 720 -> spawning angle of our new enemy 
                    MY_LSR_D  
                    MY_LSR_D  
                    MY_LSR_D  
                    MY_LSR_D  
                    MY_LSR_D                              ; angle / 32 
                    MY_LSL_D                              ; *2, in d now 0 - 44 (in steps of 2) 
                    ldu      #HunterList                  ; take this "angle" as our offsit of our different hunter rotations 
                    leau     d,u 
                    ldu      ,u 
                    stu      CURRENT_LIST,x               ; and store as current vectorlist 
                    MY_LSL_D                              ; *2 
                    MY_LSL_D                              ; *2 
                    MY_LSL_D                              ; *2 
                    MY_LSL_D                              ; *2 retrieved the full 720 angle (0 - 704 actually) 
                    tfr      d,u 
                    stu      ANGLE,x                      ; store current angle of object 
                    ldd      #circle 
                    leau     d,u                          ; u pointer to spawn angle coordinates 
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
                    cmpa     #$80                         ; if scale is rather large, we cen decipher music in that time 
                    blo      noMusic_hub1 
                    jsr      [inMovePointer]              ; uncrunch one music "piece" 
                    lda      SCALE+u_offset1,u 
noMusic_hub1 
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
                    bitb     #ALLOW_HIDDEN_X              ; first check if allowed to spawn 
                    bne      sphx_allowed                 ; if so -> jumo 
                    clr      spawn_timer                  ; if not make sure to check spawn next round again 
                    jmp      returnSpawnNotAllowed        ; and jump back (to the only location we can be called from) 

sphx_allowed: 
                    jsr      newObject                    ; "create" (or rather get) new object 
                    lbpl     cs_done_no                   ; if positve - there is no object left, jump out 
                    leax     ,u                           ; pointer to new object now in X also 
                    ldd      #SpawnX_Sound                ; play a sound for out new spawn 
                    jsr      play_sfx 
; copy and initialze new enemy
                    lda      #TYPE_HIDDEN_X 
                    sta      TYPE, x 
                    lda      HX_add_delay                 ; delay between two scale changes (speed of object) 
                    sta      TICK_COUNTER, x 
                    lda      HX_addi                      ; strength of scale change once we actually do it 
                    sta      SCALE_DELTA, x 
                    ldd      #hiddenXBehaviour 
                    std      BEHAVIOUR,x 
                    lda      #X_ANIM_DELAY                ; anim reset 
                    sta      ANIM_COUNTER, x 
                    ldd      #enemyXList_0                ; vectorlist 
                    std      CURRENT_LIST,x 
                    lda      #$ff 
                    sta      DDRA,x                       ; performance dummy 
                    lda      spawn_max 
                    sta      SCALE,x                      ; start with max scale (for xEnemy) 
                    ANGLE_0_762  
                    STORE_POS_FROM_ANGLE  
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
                    lda      SCALE+u_offset1,u            ; load current scale to a - for later calcs 
                    cmpa     #$80                         ; if scale is rather large, we cen decipher music in that time 
                    blo      noMusic_hxb1 
                    jsr      [inMovePointer]              ; uncrunch one music "piece" 
noMusic_hxb1 
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
                    ldb      HX_add_delay                 ; otherwise reset the delay counter for scale update (this is global now, should I use that from the structure?) 
                    stb      TICK_COUNTER+u_offset1, u    ; store it 
                    suba     SCALE_DELTA+u_offset1, u     ; and actually descrease the scale with the "decrease" value 
                    bcs      die_hxb                      ; if below zero, than base reaches 
                    cmpa     #BASE_SCALE+3                ; if lower base scale, than also dead 
                    bhi      base_not_reached_hxb         ; if the decreas generated an overflow - than we reached the base (scale below zero) 
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
; calculate a slowly  brightening intensity
                    ldu      NEXT_OBJECT+u_offset1,u      ; preload next user stack 
                    bita     #$80                         ; if far away 
                    beq      go_on_int_hxb 
                    clra                                  ; make it invisible 
                    bra      no_int_hxb 

go_on_int_hxb 
                    nega                                  ; inverse the near scale (now -1 - -127) 
                    adda     #$8f                         ; add 143, result is positive intensity 
                    bpl      no_int_hxb 
                    suba     #$10                         ; adjust negative values slightly 
no_int_hxb: 
                    ldb      #6                           ; preload and set scale 
                    stb      VIA_t1_cnt_lo                ; to timer t1 (lo= scale) 
                    MY_MOVE_TO_B_END                      ; end a move to 
                    _INTENSITY_A                          ; set the int 
                    jsr      myDraw_VL_mode               ; and draw 
                    _ZERO_VECTOR_BEAM                     ; zero as fast as possible 
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
                    pulu     d,x,y,pc                     ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
******************************  
***** SCORE ****************** 
******************************  
; scores displayed by ONE vectorlist, 
; these are "destruction" scores
scoreBehaviour                                            ;#isfunction  
                    sty      VIA_DDR_a                    ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
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
                    pulu     d,x,y,pc                     ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 
******************************  
***** SCORE X***************** 
******************************  
; special
; the X vectorlist(s)
; are generated in move to display a 3 digit score (max) generated by the starlets 
scoreXBehaviour                                           ;#isfunction  
                    sty      VIA_DDR_a                    ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
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
                    bitb     #ALLOW_STAR                  ; first check if allowed to spawn 
                    bne      sps_allowed                  ; if so -> jumo 
                    clr      spawn_timer                  ; if not make sure to check spawn next round again 
                    jmp      returnSpawnNotAllowed        ; and jump back (to the only location we can be called from) 

sps_allowed: 
                    jsr      newObject                    ; "create" (or rather get) new object 
                    lbpl     cs_done_no                   ; if positve - there is no object left, jump out 
                    leax     ,u                           ; pointer to new object now in X also 
                    ldd      #SpawnX_Sound                ; play a sound for out new spawn - OOPS forgotten to do a special Starlet sound! 
                    jsr      play_sfx 
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
                    lda      #STARLET_SCORE_DELAY         ; delay between score spawns 
                    sta      SCORE_COUNTER,x              ; to the counter 
                    lda      #STARLET_START_SCORE         ; initial score to spawn (6 I think) 
                    sta      SCORE_COUNT,x 
; the three stars are realized as objects, but are still "individuals"
; store the individual ID in the starlet struct
; and initialize our "place" - starlets have "fixed" scales
                    lda      star_active_flag             ; bit 0-2 are set for starlets active 1 2 or 3 
                    bita     #$01 
                    beq      i_am_0 
                    bita     #$02 
                    beq      i_am_1 
i_am_2: 
                    ora      #$04 
                    sta      star_active_flag 
                    lda      SCALE,x 
                    adda     #15 -5 
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
                    ldd      starletAngle                 ; rotation done by main() in opposite direction than base 
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
                    ldu      #star_0_score 
                    leau     a,u 
                    ldd      #0 
                    std      ,u++ 
                    lda      #STARLET_START_SCORE 
                    sta      ,u 
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
                    ldd      starletAngle                 ; and add the "main" starlet angle 
                    leay     d,y                          ; watch out that it isn't to high (modulo 720) 
                    cmpy     #720 
                    blt      not_oob_sb 
                    leay     -720,y 
not_oob_sb 
                    ldd      #circle                      ; and get the current positions 
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
                    dec      SCORE_COUNTER+u_offset1, u   ; decrease score "delay" counter 
                    bpl      no_score_update_sb           ; jump if not minus 
                    lda      #STARLET_SCORE_DELAY         ; now initiate a new score spawn, first reinstate the next delay 
                    sta      SCORE_COUNTER+u_offset1, u 
; following code adds two to the current starlet score
; and correct the csa score pointers
;                    lda      SCORE_COUNT+u_offset1, u ; current score value - which is not used anymore
                    pshs     x,u                          ; save 
; if new score is higher than a "digit" we have to check following digits
;                    sta      SCORE_COUNT+u_offset1, u 
; scores are now held in the individual score csa counters
; each star accesses its csa counters by their id
                    lda      I_AM_STAR_NO+u_offset1, u    ; get ID 
                    lsla     
                    lsla                                  ; times 4 (one csa score is 4 bytes), only need 3 but 4 is easier math 
; wasting 3 bytes of precious RAM here!
                    ldx      #star_0_score                ; base score 
                    adda     #2 
                    leax     a,x                          ; and offset with ID * 4 
; in x now pointer to lowest csa score
                    lda      ,x                           ; score 0 
                    inca                                  ; add two 
                    inca     
                    cmpa     #9                           ; if rollover 
                    bls      score_ok 
                    suba     #10                          ; reduce by 10 (might be 1m since we added 2) 
                    sta      ,x                           ; store it 
                    lda      ,-x                          ; load next digit, since we rolled over 
                    inca                                  ; add one 
                    cmpa     #9                           ; check for next roll over 
                    bls      score_ok 
;                    suba     #10 ; if yes do the same again, reduce by ten
                    clra                                  ; or simply to 0 since max 1 was added 
                    sta      ,x                           ; store it 
                    lda      ,-x                          ; load next digit 
                    inca                                  ; +1 
                    cmpa     #9                           ; if rollower, ignore 
                    bls      score_ok 
                    lda      #9                           ; and for safety - the complete score is set to 999 
                    sta      1,x 
                    sta      2,x 
                    bra      score_max 

score_ok: 
                    sta      ,x                           ; store last digit 
score_max: 
; pointer x = 
; hundreds (0,1,2)
; tens (0-9)
; singles (0-9)
abort_new_new_score_sb 
; build a new scoreX object
                    jsr      buildscoreX                  ; actually spawn a score with above values 
                    puls     x,u                          ; restore 
no_score_update_sb 
                    ldu      NEXT_OBJECT+u_offset1,u      ; preload next user stack 
                    lda      #3                           ; tiny starlet 
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
                    bitb     #ALLOW_BOMBER                ; first check if allowed to spawn 
                    bne      spb_allowed                  ; if so -> jumo 
                    clr      spawn_timer                  ; if not make sure to check spawn next round again 
                    jmp      returnSpawnNotAllowed        ; and jump back (to the only location we can be called from) 

spb_allowed: 
                    jsr      newObject                    ; "create" (or rather get) new object 
                    lbpl     cs_done_no                   ; if positve - there is no object left, jump out 
                    leax     ,u                           ; pointer to new object now in X also 
                    ldd      #SpawnBomber_Sound           ; play a sound for out new spawn 
                    jsr      play_sfx 
; copy and initialze new enemy
                    lda      #TYPE_BOMBER 
                    sta      TYPE, x 
                    lda      Bomber_add_delay             ; delay between two scale changes (speed of object) 
                    sta      ANGLE_TICK_COUNTER, x 
                    lda      Bomber_addi                  ; strength of scale change once we actually do it 
                    sta      ANGLE_DELTA, x 
                    ldd      #bomberBehaviour 
                    std      BEHAVIOUR,x 
                    lda      #$ff 
                    sta      DDRA,x                       ; performance dummy 
                    lda      #BOMBER_ANIM_DELAY           ; anim reset 
                    sta      ANIM_COUNTER,x 
                    ldd      #BomberList_0 
                    std      CURRENT_LIST,x 
                    lda      bomber_delay_start 
                    sta      SHOT_COUNTER_RESET,x 
                    sta      SHOT_COUNTER,x 
                    ldb      my_random2 
                    andb     #%00011111                   ; max 31 
                    addb     #100                         ;+4 
; spawn between scale 63 - 127
                    stb      SCALE,x 
; generate another random
                    ldb      my_random 
                    rolb     
                    rolb     
                    rolb     
                    rolb     
                    eorb     my_random2 
                    addb     my_random2 
                    eorb     RecalCounterLow 
                    andb     #%01111111 
; in a random number between 0 - 127
                    clra     
                    MY_LSL_D                              ; double it 
                    tfr      d,u 
                    leau     d,u 
                    leau     d,u                          ; in u 0-254 times 3 -> 0 - 762 
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
                    dec      SHOT_COUNTER+u_offset1, u    ; decrease shot counter 
                    bne      no_shot_update_bb            ; if not 0 jump 
                    lda      SHOT_COUNTER_RESET+u_offset1, u ; otherwise restore shot "delay" 
                    suba     #BOMB_RELOAD_REDUCTION       ; and reduce the delay for next shot 
                    cmpa     minimum_bomb_reload          ; if smaller than minimum 
                    bhi      short_timer_ok 
                    lda      minimum_bomb_reload          ; load the minimum 
short_timer_ok 
                    sta      SHOT_COUNTER+u_offset1, u    ; and store it as next delay counter 
                    sta      SHOT_COUNTER_RESET+u_offset1, u ; which also is the next reset value 
                    pshs     x,u 
                    jsr      buildShot                    ; "spawnShot" 
                    puls     x,u 
no_shot_update_bb 
                    ldu      NEXT_OBJECT+u_offset1,u      ; preload next user stack 
                    lda      #6 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    lda      #$5f                         ; intensity 
                    MY_MOVE_TO_B_END                      ; end a move to 
                    ldy      ,x++                         ; load offset of vector list draw 
                    leay     >(unloop_start_addressSub+LENGTH_OF_HEADER),y ; 
do_rest_above 
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
                    bitb     #ALLOW_DRAGON                ; first check if allowed to spawn 
                    bne      spd_allowed                  ; if so -> jump 
                    clr      spawn_timer                  ; if not make sure to check spawn next round again 
                    jmp      returnSpawnNotAllowed        ; and jump back (to the only location we can be called from) 

spd_allowed: 
                    jsr      newObject                    ; "create" (or rather get) new object 
                    lbpl     cs_done_no                   ; if positve - there is no object left, jump out 
                    leax     ,u                           ; pointer to new object now in X also 
                    ldd      #SpawnDragon_Sound           ; play a sound for out new spawn 
                    jsr      play_sfx 
; copy and initialze new enemy
                    lda      #TYPE_DRAGON +$40            ; + $40 means it has two shots until dead 
                    sta      TYPE, x 
; lower nibble is counter for scale move (inward)
; higher nibble is counter for angle move
;Dragon_Angle_delay
;Dragon_Scale_delay
                    lda      Dragon_Angle_delay           ; after how many ticks does an "angle" move occur (circular movement) 
                    lsla     
                    lsla     
                    lsla     
                    lsla     
                    sta      tmp_count2 
                    lda      Dragon_Scale_delay           ; after how many ticks does an "scale" move oocur (inward bound) 
                    anda     #%00001111 
                    ora      tmp_count2 
                    sta      DRAGON_COUNTER, x            ; combined delay storage 
                    ldd      #dragonBehaviour 
                    std      BEHAVIOUR,x 
                    ldd      #DragonList_0                ; vectorlist 
                    std      CURRENT_LIST,x 
                    lda      #$ff 
                    sta      DDRA,x                       ; performance dummy 
                    ldb      my_random2 
                    andb     #%00011111                   ; max 35 
                    addb     #100 
; spawn between scale 35 - max
                    stb      SCALE,x 
                    ANGLE_0_762  
                    STORE_POS_FROM_ANGLE  
; spawn children
                    ldd      #0                           ; vectorlist 
                    std      CHILD_1,x                    ; efault 0 - perhpa not enough objects 
                    std      CHILD_2,x                    ; 0 means "dead" child 
                    tfr      x,y                          ; y is save in respect to newObject 
                    jsr      newObject                    ; build one object to use for child 1 
                    lbpl     cs_done_no                   ; if none left, jump out 
                    ldd      #-20                         ; first child is 20 positions away 
                    stu      CHILD_1,y                    ; store child struct 
                    sty      DRAGON, u                    ; and that dragon struct to child, both must know each other! 
                    bsr      initDragonChild              ; 
                    lda      #4                           ; wiggle +-4 
                    sta      WIGGLE,x 
                    lda      #0                           ; 0 is dec direction of wiggle 
                    sta      WIGGLE_DIRECTION, x 
                    jsr      newObject 
                    lbpl     cs_done_no 
                    ldd      #-40                         ; first child is 40 positions away 
                    stu      CHILD_2,y 
                    sty      DRAGON, u 
                    bsr      initDragonChild 
                    lda      #-4                          ; wiggle +-4 
                    sta      WIGGLE,x 
                    lda      #1                           ; one is inc direction of wiggle 
                    sta      WIGGLE_DIRECTION, x 
                    rts      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; initializes the dragon child
; in u pointer to child
; in y pointer to dragon
; in a angle offset
; must leave with y intact
initDragonChild 
                    leax     ,u                           ; use x instead of u 
                    std      ANGLE_OFFSET, x              ; this was loaded from caller either -20 or -40, its the offset of the child to the parent 
                    addd     ANGLE,y                      ; this is actually a angle - diff - since dif is a negative value 
                    bpl      noAngleChange_idc            ; calc the "real" angle we add the dragon angle to the (negative) offset 
                    addd     #720                         ; and correct it if neccessary 
noAngleChange_idc 
                    std      ANGLE, x                     ; store the thus calculated angle 
                    ldu      #circle                      ; and get pos from circle 
                    leau     d,u                          ; u pointer to spwan angle coordinates 
                    ldd      ,u 
                    std      Y_POS,x                      ; save start pos 
                    lda      #TYPE_DRAGONCHILD 
                    sta      TYPE, x 
                    ldd      #dragonchildBoundBehaviour 
                    std      BEHAVIOUR,x 
                                                          ; ldd #Dragonchild_List ; vectorlist 
                                                          ; std CURRENT_LIST,x 
                    lda      #$ff 
                    sta      DDRA,x                       ; performance dummy 
                    ldb      SCALE,y 
                    lda      ANGLE_OFFSET+1, x            ; scale offset of child is also calculated from the angle offset 
                    nega                                  ; its half the angle offset, but positive (further away) 
                    lsra     
                    sta      SCALE_OFFSET, x              ; store the offset 
                    addb     SCALE_OFFSET, x              ; and calculate the "active" current scale of the child 
                    stb      SCALE,x 
                    rts      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dragonchildBoundBehaviour                                 ;#isfunction  
                                                          ; do the scaling 
                    sty      VIA_DDR_a                    ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
; start the move to
; following calcs can be done within that move
                    MY_MOVE_TO_D_START  
; calculate scale, angle and POS and wiggle anew each round
; since parent might have changed something, which effects us
                    ldy      DRAGON+u_offset1,u           ; y is offset of out parent, we assume parent is not dead, otherwise we would be a free child 
                    lda      SCALE,y                      ; get the scale of the parent 
                    adda     SCALE_OFFSET+u_offset1, u    ; and addd our own offset 
                    sta      SCALE+u_offset1,u 
                    ldd      ANGLE_OFFSET+u_offset1,u     ; from child 
                    addd     ANGLE,y                      ; from dragon 
                    bpl      noAngleChange_dcb 
                    addd     #720 
noAngleChange_dcb 
                    std      ANGLE+u_offset1,u            ; store angle and calculate the actual new position 
                    ldy      #circle 
                    leay     d,y                          ; u pointer to spwan angle coordinates 
                    ldd      ,y 
                    std      Y_POS+u_offset1,u            ; save start pos 
                    lda      #6 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
; calculate the wiggle offset,
; leaves the calculation with actual current offset in b
; wiggle is allways +-4 in "one" steps
; the direction + or . is given by WIGGLE_DIRECTION
                    ldb      WIGGLE+u_offset1,u 
                    lda      WIGGLE_DIRECTION+u_offset1,u 
                    beq      wiggle_minus 
                    incb     
                    stb      WIGGLE+u_offset1,u 
                    cmpb     #4 
                    bne      do_changescale 
                    dec      WIGGLE_DIRECTION+u_offset1,u 
                    bra      do_changescale 

wiggle_minus 
                    decb     
                    stb      WIGGLE+u_offset1,u 
                    cmpb     #-4 
                    bne      do_changescale 
                    inc      WIGGLE_DIRECTION+u_offset1,u 
do_changescale 
; wiggle calc finished
                    addb     SCALE+u_offset1, u           ; no apply the wiggle to the actual scale 
                    stb      SCALE+u_offset1, u           ; and store it (for next round) 
                    lda      #$5f                         ; intensity 
                    ldu      NEXT_OBJECT+u_offset1,u      ; preload next user stack 
                    ldx      #Dragonchild_List 
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
                    ldx      #Dragonchild_List 
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
; decode the two in nibbles stored delay counter
                    lda      DRAGON_COUNTER+u_offset1, u 
                    lsra     
                    lsra     
                    lsra     
                    lsra     
                    deca     
                    sta      tmp_add 
                    bpl      dragon_no_angle_update 
                    ldb      Dragon_Angle_delay 
                    stb      tmp_add 
                    ldd      ANGLE+u_offset1,u            ; load current scale to a - for later calcs 
                    addd     Dragon_Angle_addi 
                    cmpd     #720 
                    blo      dragonAngleOk_db 
                    subd     #720 
dragonAngleOk_db 
                    std      ANGLE+u_offset1,u            ; load current scale to a - for later calcs 
                    ldy      #circle 
                    leay     d,y                          ; u pointer to spwan angle coordinates 
                    ldd      ,y 
                    std      Y_POS+u_offset1,u            ; save pos 
dragon_no_angle_update 
                    lda      DRAGON_COUNTER+u_offset1, u 
                    anda     #%00001111 
                    deca     
                    sta      tmp_count2 
                    bpl      no_scale_update_db           ; if not, scale will not be updated 
                    ldb      Dragon_Scale_delay           ; otherwise reset the delay counter for scale update (this is global now, should I use that from the structure?) 
                    stb      tmp_count2 
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
; tell both children, that the parent dragon is dead...
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
; store the two delay values in nibbles and store them to the combined DRAGON COUNTER
no_scale_update_db: 
                    lda      tmp_add                      ; angle delay 
                    lsla     
                    lsla     
                    lsla     
                    lsla     
                    anda     #%11110000 
                    ora      tmp_count2 
; lower nibble is counter for scale move (inward)
; higher nibble is counter for angle move
;Dragon_Angle_delay
;Dragon_Scale_delay
                    sta      DRAGON_COUNTER+u_offset1,u 
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
                    ldb      TYPE+u_offset1,u             ; type byte tells us, if the dragon has been shot once 
                    cmpb     #20                          ; and we thus can set the brightness 
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
                    bitb     #ALLOW_BONUS                 ; first check if allowed to spawn 
                    bne      bonux_allowed                ; if so -> jumo 
                    clr      spawn_timer                  ; if not make sure to check spawn next round again 
                    jmp      returnSpawnNotAllowed        ; and jump back (to the only location we can be called from) 

bonux_allowed: 
                    jsr      newObject                    ; "create" (or rather get) new object 
                    lbpl     cs_done_no                   ; if positve - there is no object left, jump out 
                    inc      bonusCounter+1               ; disable other bonus spawns 
                    leax     ,u                           ; pointer to new object 
                    ldd      #SpawnBonus_Sound            ; play a sound for out new spawn 
                    jsr      play_sfx 
; copy and initialze new enemy
                    lda      #TYPE_BONUS 
                    sta      TYPE, x 
                    lda      Bonus_add_delay              ; delay between two scale changes (speed of object) 
                    sta      TICK_COUNTER, x 
                    lda      Bonus_addi                   ; strength of scale change once we actually do it 
                    sta      SCALE_DELTA, x 
                    ldd      #bonusBehaviour 
                    std      BEHAVIOUR,x 
                    lda      #BONUS_ANIM_DELAY            ; anim reset 
                    sta      ANIM_COUNTER, x 
                    ldd      #BonusList_0                 ; vectorlist 
                    std      CURRENT_LIST,x 
                    lda      #$ff 
                    sta      DDRA,x                       ; performance dummy 
                    lda      spawn_max 
                    sta      SCALE,x                      ; start with max scale (for xEnemy) 
                    ANGLE_0_762  
                    STORE_POS_FROM_ANGLE  
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
                    cmpa     #$80                         ; if scale is rather large, we cen decipher music in that time 
                    blo      noMusic_bb1 
                    jsr      [inMovePointer]              ; uncrunch one music "piece" 
                    lda      SCALE+u_offset1,u 
noMusic_bb1 
                    dec      TICK_COUNTER+u_offset1, u    ; see if wee need calc at all, compare tick counter with below zero 
                    bpl      no_scale_update_bob          ; if not, scale will not be updated 
                    ldb      X_add_delay                  ; otherwise reset the delay counter for scale update (this is global now, should I use that from the structure?) 
                    stb      TICK_COUNTER+u_offset1, u    ; store it 
                    suba     SCALE_DELTA+u_offset1, u     ; and actually descrease the scale with the "decrease" value 
                    bcs      get_bob                      ; if below zero, than base reaches 
                    cmpa     #BASE_SCALE+3                ; if lower base scale, than also dead 
                    bhi      base_not_reached_bob 
; if we reached the base - we collect the bonus
get_bob: 
                    MY_MOVE_TO_B_END                      ; probably not needed here, since we have a realy low scale here 
                    _ZERO_VECTOR_BEAM  
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
; this is a special object in the middle of our base
; that displays the timer that is left for our current activated bonus
; special
; the X vectorlist(s)
; are generated in move to
timerBehaviour                                            ;#isfunction  
                    sty      VIA_DDR_a                    ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
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
                    std      Y_POS+u_offset1,u 
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
                    pulu     d,x,y,pc                     ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 
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
                    pulu     d,x,y,pc                     ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
******************************  
***** STARFIELD ************** 
******************************  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Starfield SPAWN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; in x pointer to new object structure that should be filled with object 
; data
spawnStarfield:                                           ;        #isfunction 
                    jsr      newObject                    ; "create" (or rather get) new object 
                    lbpl     cs_done_no                   ; if positve - there is no object left, jump out 
                    leax     ,u                           ; pointer to new object 
; copy and initialze new enemy
                    inc      starFieldCounter             ; remember how many starfields are active 
                    lda      #TYPE_STARFIELD_FRESH        ; new starfield type - type fresh are primarily despawned if nccessary 
                    sta      TYPE, x 
                    ldd      #starfieldBehaviour 
                    std      BEHAVIOUR,x 
                    ldd      #$ffff                       ; internal indicator for new starfield, the initialization of positions is done ofer time, when the "counters" have run out 
                    std      POS_1, x                     ; store neg pos as indicator, that nothing is displayed 
                    std      POS_2, x                     ; store neg pos as indicator, that nothing is displayed 
                    std      POS_3, x                     ; store neg pos as indicator, that nothing is displayed 
                    std      POS_4, x                     ; store neg pos as indicator, that nothing is displayed 
                    lda      my_random2                   ; scale value in initialization of stars are "delay" factors for spawning a "real" star 
                    anda     #%01111111 
                    sta      SCALE_1, x                   ; in init - wait for star spawn at 0 
; generate another random
                    lda      my_random 
                    rola     
                    eora     my_random2 
                    adda     my_random2 
                    eora     RecalCounterLow 
                    sta      my_random2 
                    anda     #%01111111 
                    sta      SCALE_2, x                   ; in init - wait for star spawn at 0 
                    lda      my_random 
                    rola     
                    eora     my_random2 
                    adda     my_random2 
                    eora     RecalCounterLow 
                    sta      my_random2 
                    anda     #%01111111 
                    sta      SCALE_3, x                   ; in init - wait for star spawn at 0 
                    lda      my_random 
                    rola     
                    eora     my_random2 
                    adda     my_random2 
                    eora     RecalCounterLow 
                    sta      my_random2 
                    anda     #%01111111 
                    sta      SCALE_4, x                   ; in init - wait for star spawn at 0 
                    rts      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; behaviours control (action) and draw all objects
; each object type has an individual behaviour
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; values are set from "u" list as:
;      pulu     pc,d,x,y ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 
DO_ONE_STAR         macro    mPos, mScale 
                    lda      mScale+u_offset1,u           ; in case the star will be printed - 
                    sta      VIA_t1_cnt_lo                ; load and set the correct scale 
                    ldd      mPos+u_offset1,u             ; check if this particular star is initialized 
                    cmpd     #$ffff                       ; if $ffff than not 
                    beq      inInit1\? 
                    MY_MOVE_TO_D_START_NT                 ; otherwise move to the pos 
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
                    inc      TYPE+u_offset1,u             ; if zero, we remember that one of our four stars is "alive" 
doInit1\?: 
                    _ZERO_VECTOR_BEAM                     ; in case we are here from an oob, zero the beam 
                    ldd      #$0a00                       ; and also "break" current ramping (move) 
                    std      VIA_t1_cnt_lo                ; disable ramping 
                    lda      #8                           ; minimum scale at star birth 
                    sta      mScale+u_offset1,u           ; store the scale 
                    ldb      my_random2                   ; make sure this is random2 not just "random", since the random was already used in "creating" the X object, using it again leaves pretty same values for location 
                    andb     #%01111111                   ; 0 - 127 
; in a random number between 0 - 127
                    clra     
                    MY_LSL_D                              ; double it 
                    tfr      d,x 
                    leax     d,x 
                    leax     d,x                          ; in u 0-254 times 3 -> 0 - 762 
                    ldd      #circle                      ; circle with angle as offset gives us the actual coordinates 
                    leax     d,x                          ; u pointer to spwan angle coordinates 
                    ldd      ,x 
                    std      mPos+u_offset1,u 
do_pos2\?: 
do_pos3\? 
                    endm     
starfieldBehaviour                                        ;#isfunction  
; four stars per star "atom"
                    DO_ONE_STAR  POS_1, SCALE_1 
                    DO_ONE_STAR  POS_2, SCALE_2 
                    DO_ONE_STAR  POS_3, SCALE_3 
                    DO_ONE_STAR  POS_4, SCALE_4 
                    ldu      NEXT_OBJECT+u_offset1,u      ; preload next user stack 
                    pulu     d,x,y,pc                     ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 
******************************  
***** OBJECT Letter ********** 
****************************** 
; One letter from the title screen that "circles" 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; X Letter
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; in a letter that should be built
spawnFailed: 
                    ldu      #0                           ; exit with status 0 
                    puls     a 
                    rts      

spawnLetter: 
                    pshs     a                            ; save out letter 
                    jsr      newObject                    ; "create" (or rather get) new object 
                    bpl      spawnFailed                  ; if positve - there is no object left, jump out 
                    leax     ,u                           ; pointer to new object now in X also 
; copy and initialze new enemy
                    lda      #TYPE_LETTER 
                    sta      TYPE, x 
                    puls     b                            ; in b out current letter 
_no_space_found_letter_object 
                    SUBB     # 'A'                        ; subtract smallest letter, so A has 0 offset
                    LSLB                                  ; multiply by two, since addresses are 16 bit 
                    ldu      #_abc                        ; and add the abc (table of vector list address of the alphabet's letters) 
                    LDu      b,u                          ; in x now address of letter vectorlist 
cont_letter_object 
                    stu      CURRENT_LIST,x 
                    ldd      #letterBehaviour 
                    std      BEHAVIOUR,x 
                    lda      #$ff 
                    sta      DDRA,x                       ; performance dummy 
                    lda      vector_move_scale 
                    sta      SCALE,x                      ; start with max scale (for xEnemy) 
                                                          ; CSA lda #ADD_DELAY 
                                                          ; CSA sta DIF_DELAY,x 
                    rts      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; behaviours control (action) and draw all objects
; each object type has an individual behaviour
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; values are set from "u" list as:
;      pulu     pc,d,x,y ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 
letterBehaviour                                           ;#isfunction  
                                                          ; do the scaling 
                    sty      VIA_DDR_a                    ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
; start the move to
; following calcs can be done within that move
                    MY_MOVE_TO_D_START_NT  
                    ldd      ANGLE+u_offset1,u            ; load current scale to a - for later calcs 
                    std      tmp_angle 
                    lda      TYPE+u_offset1,u 
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
                    std      Y_POS+u_offset1,u            ; save start pos 
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
                    pulu     d,x,y,pc                     ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 
