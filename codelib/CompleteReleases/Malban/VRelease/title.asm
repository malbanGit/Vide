; this file is part of Release, written by Malban in 2017
;
                    BSS      
                    ORG      clip_end                     ; start of our ram space 
title_phase         ds       1 
title_phase_counter  ds      2 
title_scale         ds       1 
vector_print_scale  ds       1 
print_angle         ds       2 
print_angle_2       ds       2 
print_letter_angle_dif  ds   2 
work_angle          ds       2 
angle_speed         ds       2 
;dif_add_delay ds 1
ADD_DELAY           =        5 
vector_move_scale   ds       1 
dummyCounter        ds       1 
                    code     
PHASE_0_NONE        =        0 
PHASE_1_SHOW_NOTHING  =      1 
PHASE_2_SHOW_X      =        2 
PHASE_3_SHOW_HX     =        3 
PHASE_4_SHOW_HUNTER  =       4 
PHASE_5_SHOW_BOMBER  =       5 
PHASE_6_SHOW_DRAGON  =       6 
PHASE_7_SHOW_BONUS  =        7 
PHASE_8_SHOW_SCORER  =       8 
PHASE_END_SHOW_END  =        9 
INITIAL_TITLE_PHASE_LENGTH  =  200 
;
;
                    direct   $d0 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
initTitel                                                 ;#isfunction  
                    lda      #PHASE_8_SHOW_SCORER 
                    sta      title_phase 
                    ldd      #1                           ; is titel 
                    std      title_phase_counter 
                    stb      return_state 
                    rts      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; removes from list all objects that can be "exploded" (positive)
remove_unwanted_objects                                   ;#isfunction  
                    ldu      list_objects_head 
test_text_unwanted 
                    cmpu     #PC_TITLE 
                    beq      unwanted_done 
                    ldb      TYPE,u 
                    cmpb     #TYPE_BOUNDARY 
                    bhi      do_next_one 
                    jsr      removeObject_rts 
                    bra      test_text_unwanted 

do_next_one 
                    ldu      NEXT_OBJECT, u 
                    bra      test_text_unwanted 

unwanted_done: 
                    rts      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
do_one_title_round:                                       ;#isfunction  
                    _ZERO_VECTOR_BEAM  
                    ldx      title_phase_counter 
                    leax     -1,x 
                    stx      title_phase_counter 
                    lbne     no_title_phase_switch 
                    ldd      #INITIAL_TITLE_PHASE_LENGTH 
                    std      title_phase_counter 
; change some circle stuff
                    lda      Vec_Loop_Count 
                    lsra     
                    anda     #1 
                    beq      do_slow 
do_fast 
                    ldb      Vec_Loop_Count 
                    andb     #%00001111 
                    lsrb     
                    lslb     
                    sex      
                    addd     angle_speed 
                    beq      speed_done 
                    std      angle_speed 
                    bra      speed_done 

do_slow 
                    ldb      Vec_Loop_Count 
                    andb     #%00001111 
                    lsrb     
                    lslb     
                    sex      
                    NEG_D    
                    ldx      angle_speed 
                    leax     d,x 
                    tfr      x,d 
                    beq      speed_done 
                    std      angle_speed 
speed_done 
                    cmpd     #8 
                    blt      no_to_hi_speed 
                    ldd      #4 
                    std      angle_speed 
no_to_hi_speed 
                    cmpd     #-8 
                    bgt      no_to_lo_speed 
                    ldd      #-4 
                    std      angle_speed 
no_to_lo_speed 
                    lda      title_phase 
                    inca     
                    cmpa     #PHASE_END_SHOW_END 
                    bne      was_not_last_phase 
                    lda      #PHASE_1_SHOW_NOTHING 
was_not_last_phase: 
                    sta      title_phase 
; do deinit old phase
                    jsr      remove_unwanted_objects 
                    lda      title_phase 
                    ldb      #$ff                         ; spawn allowed 
                    cmpa     #PHASE_2_SHOW_X 
                    beq      init_title_phase_2 
                    cmpa     #PHASE_3_SHOW_HX 
                    beq      init_title_phase_3 
                    cmpa     #PHASE_4_SHOW_HUNTER 
                    beq      init_title_phase_4 
                    cmpa     #PHASE_5_SHOW_BOMBER 
                    beq      init_title_phase_5 
                    cmpa     #PHASE_6_SHOW_DRAGON 
                    beq      init_title_phase_6 
                    cmpa     #PHASE_7_SHOW_BONUS 
                    beq      init_title_phase_7 
                    cmpa     #PHASE_8_SHOW_SCORER 
                    beq      init_title_phase_8 
                    jmp      done_title_init_phase_done 

SHIFT_TITLE_UP_SPRITE  =     40 
init_title_phase_2 
; init new phase
                    jsr      spawnX 
                    ldy      #behaviourXTitel 
                    ldd      #(SHIFT_TITLE_UP_SPRITE)*256+$b0 
                    bra      done_title_init_phase 

init_title_phase_3 
; init new phase
                    jsr      spawnHiddenX 
                    ldy      #behaviourHXTitel 
                    ldd      #(SHIFT_TITLE_UP_SPRITE)*256+$b0 
                    bra      done_title_init_phase 

init_title_phase_4 
; init new phase
                    jsr      spawnHunter 
                    ldy      #behaviourHunterTitel 
                    ldd      #(SHIFT_TITLE_UP_SPRITE)*256+$a0 
                    bra      done_title_init_phase 

init_title_phase_5 
; init new phase
                    jsr      spawnBomber 
                    ldy      #behaviourBomberTitel 
                    ldd      #(SHIFT_TITLE_UP_SPRITE)*256+$b0 
                    bra      done_title_init_phase 

init_title_phase_6 
; init new phase
                    jsr      spawnDragon 
                    clr      SCALE,y 
                    ldd      #behaviourDragonTitel 
                    std      BEHAVIOUR,y 
                    ldd      #(SHIFT_TITLE_UP_SPRITE)*256+$b0 
                    sta      Y_POS,y 
                    stb      X_POS,y 
; child 1
                    ldx      CHILD_1,y 
                    clr      SCALE,x 
                    ldd      #((SHIFT_TITLE_UP_SPRITE)+$15)*256+$b0 
                    sta      Y_POS,x 
                    stb      X_POS,x 
                    ldd      #behaviourDragonChildTitel 
                    std      BEHAVIOUR,x 
; child 2
                    ldx      CHILD_2,y 
                    ldd      #((SHIFT_TITLE_UP_SPRITE)+$20)*256+$b0 
                    ldy      #behaviourDragonChildTitel 
                    bra      done_title_init_phase 

init_title_phase_7 
; init new phase
                    jsr      spawnBonus 
                    ldy      #behaviourBonusTitel 
                    ldd      #(SHIFT_TITLE_UP_SPRITE)*256+$b0 
                    bra      done_title_init_phase 

init_title_phase_8 
; init new phase
                    jsr      spawnStarlet 
                    ldy      #behaviourStarletTitel 
                    ldd      #(SHIFT_TITLE_UP_SPRITE)*256+$b0 
                    bra      done_title_init_phase 

done_title_init_phase: 
                    sta      Y_POS,x 
                    stb      X_POS,x 
                    clr      SCALE,x 
                    ldu      #PC_TITLE 
                    stu      NEXT_OBJECT,x 
                    sty      BEHAVIOUR,x 
done_title_init_phase_done: 
no_title_phase_switch: 
                    lda      #$40 
                    sta      title_scale 
                    ldd      title_phase_counter 
                    cmpd     #(INITIAL_TITLE_PHASE_LENGTH-$40) 
                    blt      not_high_scale 
                    subd     #(INITIAL_TITLE_PHASE_LENGTH) 
                    NEG_D    
                    stb      title_scale 
not_high_scale 
                    ldd      title_phase_counter 
                    cmpd     #$40 
                    bhi      not_low_scale 
                    stb      title_scale 
not_low_scale 
                    lda      title_phase 
                    cmpa     #PHASE_2_SHOW_X 
                    beq      title_phase_2 
                    cmpa     #PHASE_3_SHOW_HX 
                    beq      title_phase_3 
                    cmpa     #PHASE_4_SHOW_HUNTER 
                    beq      title_phase_4 
                    cmpa     #PHASE_5_SHOW_BOMBER 
                    beq      title_phase_5 
                    cmpa     #PHASE_6_SHOW_DRAGON 
                    beq      title_phase_6 
                    cmpa     #PHASE_7_SHOW_BONUS 
                    beq      title_phase_7 
                    cmpa     #PHASE_8_SHOW_SCORER 
                    beq      title_phase_8 
                    bra      completely_done_title_phase 

title_phase_2 
                    ldu      #x_in_title 
                    bra      done_title_phase 

title_phase_3 
                    ldu      #hx_in_title 
                    bra      done_title_phase 

title_phase_4 
                    ldu      #hunter_in_title 
                    bra      done_title_phase 

title_phase_5 
                    ldu      #bomber_in_title 
                    bra      done_title_phase 

title_phase_6 
                    ldu      #dragon_in_title 
                    bra      done_title_phase 

title_phase_7 
                    ldu      #helper_in_title 
                    bra      done_title_phase 

title_phase_8 
                    ldu      #bonus_in_title 
                    bra      done_title_phase 

done_title_phase 
                    lda      title_scale 
                    _INTENSITY_A  
                    ldd      #$24*256+$00 
                    jsr      vectorPrint 
completely_done_title_phase 
                    rts      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
initTitle2                                                ;#isfunction  
                    jsr      spawnStarfield 
                    ldd      #PC_TITLE 
                    std      NEXT_OBJECT,u 
                    jsr      spawnStarfield 
                    ldd      #PC_TITLE 
                    std      NEXT_OBJECT,u 
                    jsr      spawnStarfield 
                    ldd      #PC_TITLE 
                    std      NEXT_OBJECT,u 
INITIAL_ANGLE_DIFFERENCE  =  60 
                    ldd      #(40*256)+$60 
                    sta      vector_print_scale 
                    stb      vector_move_scale 
                    ldd      #0 
                    std      print_angle 
                    std      print_angle_2 
                    ldb      #2 
                    std      angle_speed 
;;;
                    ldd      #INITIAL_ANGLE_DIFFERENCE 
                    std      print_letter_angle_dif 
                    lda      # 'R'
                    jsr      spawnLetter 
                    ldd      #PC_TITLE 
                    std      NEXT_OBJECT,x 
                    ldy      print_angle 
                    sty      ANGLE, x 
                    tfr      y,d 
                    ldu      #circle 
                    ldd      d,u 
                    sta      Y_POS,x 
                    stb      X_POS,x 
                    ldd      #0 
                    std      <SPACE_TO_PREVIOUS, x 
                    std      <PREVIOUS_LETTER,x 
;;;
                    lda      # 'E'
                    bsr      initOneFollowingLetter 
                    lda      # 'L'
                    bsr      initOneFollowingLetter 
                    lda      # 'E'
                    bsr      initOneFollowingLetter 
                    lda      # 'A'
                    bsr      initOneFollowingLetter 
                    lda      # 'S'
                    bsr      initOneFollowingLetter 
                    lda      # 'E'
initOneFollowingLetter 
                    leay     INITIAL_ANGLE_DIFFERENCE,y 
                    pshs     x 
                    jsr      spawnLetter 
                    ldd      #PC_TITLE 
                    std      NEXT_OBJECT,x 
                    sty      ANGLE, x 
                    tfr      y,d 
                    ldu      #circle 
                    ldd      d,u 
                    sta      Y_POS,x 
                    stb      X_POS,x 
                    ldd      print_letter_angle_dif 
                    std      <SPACE_TO_PREVIOUS, x 
                    puls     d 
                    std      <PREVIOUS_LETTER,x 
                    rts      

; print text pointed to by u as vector string
; only large letters and "."
; terminated by $80
; position in D
; positioning done with title_scale scale
; print done with title_scale/8 scale
vectorPrint                                               ;#isfunction  
                    std      tmp1 
next_name_letter_vp 
                    lda      title_scale 
                    _SCALE_A  
                    ldd      tmp1                         ; the current move vector 
                    MY_MOVE_TO_D_START_NT  
                    LDB      ,u+                          ; first char of three letter name 
                                                          ; lets calculate the abc-table offset... 
                    cmpb     # ' '
                    bne      _no_space_found 
                    ldx      #ABC_28                      ; and add the abc (table of vector list address of the alphabet's letters) 
                    bra      cont_vp 

_no_space_found 
                    SUBB     # 'A'                        ; subtract smallest letter, so A has 0 offset
                    LSLB                                  ; multiply by two, since addresses are 16 bit 
                    ldx      #_abc                        ; and add the abc (table of vector list address of the alphabet's letters) 
                    LDX      b,X                          ; in x now address of first letter vectorlist 
cont_vp 
                    lda      mov_x 
                    adda     #10 
                    sta      mov_x 
                    lda      title_scale 
                    lsra     
                    lsra     
                    lsra     
                    _SCALE_A  
                    MY_MOVE_TO_B_END  
                    jsr      myDraw_VL_mode               ;2 
                    _ZERO_VECTOR_BEAM                     ; draw each letter with a move from zero, more stable 
                    LDB      ,u 
                    bpl      next_name_letter_vp 
                    rts      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; behaviours control (action) and draw all objects
; each object type has an individual behaviour
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; values are set from "u" list as:
;      pulu     pc,d,x; (D = y,x, X = vectorlist) 
behaviourXTitel                                           ;#isfunction  
                                                          ; do the scaling 
                    stb      VIA_t1_cnt_lo                ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
                    ldb      X_POS+u_offset1, u           ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
; start the move to
; following calcs can be done within that move
                    jsr      move_to_d_start 
                    dec      ANIM_COUNTER+u_offset1, u    ; see if wee need calc at all, compare tick counter with below zero 
                    bpl      no_anim_update_ti_xb         ; if not, scale will not be updated 
                    lda      #X_ANIM_DELAY                ; anim reset 
                    sta      ANIM_COUNTER+u_offset1, u 
                    ldd      CURRENT_LIST+u_offset1,u 
                    addd     #(enemyXList_1-enemyXList_0) 
                    cmpd     #(enemyXList_3+(enemyXList_1-enemyXList_0)) 
                    bne      not_last_anim_ti_xb 
                    ldd      #enemyXList_0 
not_last_anim_ti_xb: 
                    std      CURRENT_LIST+u_offset1,u 
no_anim_update_ti_xb: 
do_behaviourRest1 
                    lda      title_scale 
                    sta      SCALE+u_offset1, u 
                    ldu      NEXT_OBJECT+u_offset1,u      ; preload next user stack 
                    lda      title_scale 
                    lsra     
                    lsra     
                    lsra     
                    lsra     
                    cmpa     #6 
                    blo      noscale_max_bxt 
                    lda      #6 
noscale_max_bxt 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    lda      title_scale 
do_behaviourRest2 
                    MY_MOVE_TO_B_END                      ; end a move to 
                    _INTENSITY_A  
                    jmp      myDraw_VL_mode_direct        ; draw the list 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; behaviours control (action) and draw all objects
; each object type has an individual behaviour
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; values are set from "u" list as:
;      pulu     pc,d,x; (D = y,x, X = vectorlist) 
behaviourHXTitel                                          ;#isfunction  
                                                          ; do the scaling 
                    stb      VIA_t1_cnt_lo                ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
                    ldb      X_POS+u_offset1, u           ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
; start the move to
; following calcs can be done within that move
                    jsr      move_to_d_start 
                    dec      ANIM_COUNTER+u_offset1, u    ; see if wee need calc at all, compare tick counter with below zero 
                    bpl      no_anim_update_ti_Hxb        ; if not, scale will not be updated 
                    lda      #X_ANIM_DELAY                ; anim reset 
                    sta      ANIM_COUNTER+u_offset1, u 
                    ldd      CURRENT_LIST+u_offset1,u 
                    addd     #(enemyXList_1-enemyXList_0) 
                    cmpd     #(enemyXList_3+(enemyXList_1-enemyXList_0)) 
                    bne      not_last_anim_ti_Hxb 
                    ldd      #enemyXList_0 
not_last_anim_ti_Hxb: 
                    std      CURRENT_LIST+u_offset1,u 
no_anim_update_ti_Hxb: 
                    lda      title_scale 
                    sta      SCALE+u_offset1, u 
                    ldu      NEXT_OBJECT+u_offset1,u      ; preload next user stack 
                    lda      title_scale 
                    lsra     
                    lsra     
                    lsra     
                    lsra     
                    cmpa     #6 
                    blo      noscale_max_bHxt 
                    lda      #6 
noscale_max_bHxt 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    lda      title_scale 
                    lsra     
                    bra      do_behaviourRest2 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; behaviours control (action) and draw all objects
; each object type has an individual behaviour
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; values are set from "u" list as:
;      pulu     pc,d,x; (D = y,x, X = vectorlist) 
behaviourHunterTitel                                      ;#isfunction  
                                                          ; do the scaling 
                    stb      VIA_t1_cnt_lo                ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
                    ldb      X_POS+u_offset1, u           ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
; start the move to
; following calcs can be done within that move
                    jsr      move_to_d_start 
do_behaviourRest3 
                    lda      title_scale 
                    sta      SCALE+u_offset1, u 
                    ldu      NEXT_OBJECT+u_offset1,u      ; preload next user stack 
                    ldy      ,x++                         ; load offset of vector list draw 
                    leay     >(unloop_start_addressSub+LENGTH_OF_HEADER),y ; 
                    lda      title_scale 
                    lsra     
                    lsra     
                    lsra     
                    lsra     
                    cmpa     #6 
                    blo      noscale_max_bHuntert 
                    lda      #6 
noscale_max_bHuntert 
                    lda      title_scale 
                    MY_MOVE_TO_B_END                      ; end a move to 
                    _INTENSITY_A  
                    jmp      entry_optimized_draw_mvlc_unloop 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; behaviours control (action) and draw all objects
; each object type has an individual behaviour
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; values are set from "u" list as:
;      pulu     pc,d,x; (D = y,x, X = vectorlist) 
behaviourBomberTitel:                                     ;#isfunction  
                                                          ; do the scaling 
                    stb      VIA_t1_cnt_lo                ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
                    ldb      X_POS+u_offset1, u           ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
; start the move to
; following calcs can be done within that move
                    jsr      move_to_d_start 
; check anim
                    dec      ANIM_COUNTER+u_offset1, u    ; see if wee need calc at all, compare tick counter with below zero 
                    bpl      no_anim_update_bbt           ; if not, scale will not be updated 
                    lda      #BOMBER_ANIM_DELAY           ; anim reset 
                    sta      ANIM_COUNTER+u_offset1, u 
                    ldd      CURRENT_LIST+u_offset1,u 
                    addd     #(BomberList_1-BomberList_0) 
                    cmpd     #(BomberList_8+(BomberList_1-BomberList_0)) 
                    bne      not_last_anim_bbt 
                    ldd      #BomberList_0 
not_last_anim_bbt: 
                    std      CURRENT_LIST+u_offset1,u 
no_anim_update_bbt: 
                    bra      do_behaviourRest3 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; behaviours control (action) and draw all objects
; each object type has an individual behaviour
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; values are set from "u" list as:
;      pulu     pc,d,x; (D = y,x, X = vectorlist) 
behaviourDragonTitel                                      ;#isfunction  
                                                          ; do the scaling 
                    stb      VIA_t1_cnt_lo                ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
                    ldb      X_POS+u_offset1, u           ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
; start the move to
; following calcs can be done within that move
                    jsr      move_to_d_start 
                    inc      dummyCounter 
                    lda      dummyCounter                 ; only every second tick 
                    bita     #$01 
                    beq      no_anim_update_dbt 
                    ldd      CURRENT_LIST+u_offset1,u 
                    addd     #(DragonList_1-DragonList_0) 
                    cmpd     #(DragonList_3+(DragonList_1-DragonList_0)) 
                    bne      not_last_anim_dbt 
                    ldd      #DragonList_0 
not_last_anim_dbt: 
                    std      CURRENT_LIST+u_offset1,u 
no_anim_update_dbt: 
                    bra      do_behaviourRest3 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
behaviourDragonChildTitel 
                                                          ; do the scaling 
                    stb      VIA_t1_cnt_lo                ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
                    ldb      X_POS+u_offset1, u           ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
; start the move to
; following calcs can be done within that move
                    bsr      move_to_d_start 
                    ldb      WIGGLE+u_offset1,u 
                    lda      WIGGLE_DIRECTION+u_offset1,u 
                    beq      wiggle_minus_t 
                    inc      X_POS+u_offset1, u 
                    incb     
                    stb      WIGGLE+u_offset1,u 
                    cmpb     #4 
                    bne      do_changescale_t 
                    dec      WIGGLE_DIRECTION+u_offset1,u 
                    bra      do_changescale_t 

wiggle_minus_t 
                    dec      X_POS+u_offset1, u 
                    decb     
                    stb      WIGGLE+u_offset1,u 
                    cmpb     #-4 
                    bne      do_changescale_t 
                    inc      WIGGLE_DIRECTION+u_offset1,u 
do_changescale_t 
                    ldx      #Dragonchild_List 
                    jmp      do_behaviourRest1 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; values are set from "u" list as:
;      pulu     pc,d,x; (D = y,x, X = vectorlist) 
behaviourBonusTitel                                       ;#isfunction  
                                                          ; do the scaling 
                    stb      VIA_t1_cnt_lo                ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
                    ldb      X_POS+u_offset1, u           ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
; start the move to
; following calcs can be done within that move
                    bsr      move_to_d_start 
                    dec      ANIM_COUNTER+u_offset1, u    ; see if wee need calc at all, compare tick counter with below zero 
                    bpl      no_anim_update_bobt          ; if not, scale will not be updated 
                    lda      #X_ANIM_DELAY                ; anim reset 
                    sta      ANIM_COUNTER+u_offset1, u 
                    ldd      CURRENT_LIST+u_offset1,u 
                    addd     #(BonusList_1-BonusList_0) 
                    cmpd     #(BonusList_16+(BonusList_1-BonusList_0)) 
                    bne      not_last_anim_bobt 
                    ldd      #BonusList_0 
not_last_anim_bobt: 
                    std      CURRENT_LIST+u_offset1,u 
no_anim_update_bobt: 
                    jmp      do_behaviourRest1 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; values are set from "u" list as:
;      pulu     pc,d,x; (D = y,x, X = vectorlist) 
behaviourStarletTitel                                     ;#isfunction  
                                                          ; do the scaling 
                    stb      VIA_t1_cnt_lo                ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
                    ldb      X_POS+u_offset1, u           ; also stores to scale :-() VIA_t1_cnt_lo ; to timer t1 (lo) 
; start the move to
; following calcs can be done within that move
                    bsr      move_to_d_start 
                    dec      ANIM_COUNTER+u_offset1, u    ; see if wee need calc at all, compare tick counter with below zero 
                    bpl      no_anim_update_sb_t          ; if not, scale will not be updated 
                    lda      #STARLET_ANIM_DELAY          ; anim reset 
                    sta      ANIM_COUNTER+u_offset1, u 
                    ldd      CURRENT_LIST+u_offset1,u 
                    addd     #(StarletList_1-StarletList_0) 
                    cmpd     #(StarletList_10+(StarletList_1-StarletList_0)) 
                    bne      not_last_anim_sb_t 
                    ldd      #StarletList_0 
not_last_anim_sb_t: 
                    std      CURRENT_LIST+u_offset1,u 
no_anim_update_sb_t: 
                    jmp      do_behaviourRest3 

move_to_d_start 
                    MY_MOVE_TO_D_START_NT  
                    rts      
