; this file is part of Karl Quappe, written by Malban
; in 2016
; all stuff contained here is public domain
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; all in moves are totally independend
; meaning all registers may be destroyed
; only thing - DP register should stay (or resetted) [Exception: GENERAL_IN_MOVE_SPRITE]
;
; this is stuff which takes time,
; but can be done anywhere, so we do it here
; in a 'pause', our pause lasts till GAME_SCALE ($91)
; timer is count down, that is our scale - timer...
;
; note:
; if levels are done well only a small fraction of these pauses will be done
; each round
;
; 
; these macros are used only ONCE in the source
; this more a form of "code folding" than of macroing
; but since these macros are only used once I
; was abit lax about "local" jumps
;
; in general it is really dangerous to use non localized jumps in macros, but
; since all of them are used only once it does not realy matter
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IN_MOVE_1           macro    
                                                          ; pause stuff start! 
                    _DP_TO_C8  
                    LDB      y_timer+1                    ; load new vector (length was cut by timer :-)) 
;                    Bne      no_timer_death               ; if timer is zero, we are dead 
                    lbeq      timer_death 

no_timer_death: 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; let us look if we need to initiate/destroy a home object
; that is fly or crocodile
; independent code section
; do timer stuff for fly
; insert/remove fly
                    LDA      fly_status                   ; is there any fly stuff at all? 
                    BEQ      no_fly_in_level              ; no?, than go on 
                    TST      fly_timer                    ; is zero? 
                    BNE      finnished_fly_stuff2         ; if not zero, do nothing 
                    CMPA     #IS_WAITING                  ; fly is waiting to be displayed 
                    BNE      fly_is_being_displayed       ; no?, than it is allready displayed 
; if zero... initiate new fly
;                    JSR      Random                       ; get a random number 
 jsr getMyRandom
                    ANDA     #$7                          ; only the lower three bits 
                    CMPA     #4                           ; not higher than 4 
                    BLO      home_got                     ; if lower than ok 
                    ASRA                                  ; otherwise take only half of it 
home_got:                                                 ;        now we have a random home... 
                    LDB      #5                           ; must multiply by 5, length of home object 
                    MUL                                   ; times 5 
                    STB      tmp1                         ; remember start address if all homes are occupied 
                    LDU      #home_objects                ; load the address to U, start of list of homes 
test_next_house: 
                    TST      B,U                          ; is this home empty (only checking upper byte, should be ok) 
                    BEQ      home_is_empty                ; if yes, than go on 
                    CMPB     #(HOME_OBJECT_SIZE*(5-1))    ; otherwise, compare to 20 (right most home) 
                    BNE      not_last_home_yet            ; not last home?, than go on 
                    LDB      #-(HOME_OBJECT_SIZE)         ; store -5, so that +5 is 0, leftmost home 
not_last_home_yet: 
                    ADDB     #HOME_OBJECT_SIZE            ; check next home (home object is 5 bytes long) 
                    CMPB     tmp1                         ; checked all homes yet 
                    BEQ      finnished_fly_stuff          ; yes, than no home is free 
                    BRA      test_next_house              ; and check again if empty... 

home_is_empty:                                            ;        now we got a 'random' empty home address in B,U 
                    STB      fly_house                    ; remember offset to home for removal 
                    LDU      #home_objects                ; get address of U and add the offset 
                    LEAU     B,U                          ; in U address of 'random' home 
                    LDD      #fly1a_object                ; load fly object 
                    STD      ,U                           ; store to the calculated home address 
                    LDA      (fly1a_object+4)             ; load animation counter of object 
                    STA      4,U                          ; and store it to object in RAM 
                    DEC      fly_status                   ; IS DISPLAYED 
home_ffull: 
                    BRA      finnished_fly_stuff          ; and finnished with fly stuff... 

; fly is allready displayed, must check if we should destroy it...
fly_is_being_displayed: 
; now destroy fly
                    LDB      fly_house                    ; load current fly offset 
                    LDU      #home_objects                ; get address of U and add the offset 
                    LEAU     B,U                          ; in U address of 'random' home 
                    LDD      #0 
                    STD      ,U 
                    INC      fly_status                   ; is WAITING 
finnished_fly_stuff: 
                    LDD      fly_timer_start              ; reload the fly timer 
                    STD      fly_timer                    ; and store it 
finnished_fly_stuff2: 
no_fly_in_level: 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; do timer stuff for croco (home)
; insert/remove croco
                    LDA      croco_status                 ; is there any croco stuff at all? 
                    BEQ      no_croco_in_level            ; no?, than go on 
                    TST      croco_timer                  ; store it back 
                    BNE      finnished_croco_stuff2       ; if not zero, do nothing 
                    LDA      croco_status                 ; is there any croco stuff at all? 
                    CMPA     #IS_WAITING                  ; croco is waiting to be displayed 
                    BNE      croco_is_being_displayed     ; no?, than it is allready displayed 
; if zero... initiate new croco
;                    JSR      Random                       ; get a random number 
 jsr getMyRandom
                    ANDA     #$7                          ; only the lower three bits 
                    CMPA     #4                           ; not higher than 4 
                    BLO      chome_got                    ; if lower than ok 
                    ASRA                                  ; otherwise take only half of it 
chome_got:                                                ;        now we have a random home... 
                    LDB      #5                           ; must multiply by 5, length of home object 
                    MUL                                   ; times 5 
                    STB      tmp1                         ; remember start address if all homes are occupied 
                    LDU      #home_objects                ; load the address to U, start of list of homes 
ctest_next_house: 
                    TST      B,U                          ; is this home empty (only checking upper byte, should be ok) 
                    BEQ      chome_is_empty               ; if yes, than go on 
                    CMPB     #(HOME_OBJECT_SIZE*(5-1))    ; otherwise, compate to 20 (right most home) 
                    BNE      cnot_last_home_yet           ; not last home?, than go on 
                    LDB      #-HOME_OBJECT_SIZE           ; store -5, so that +5 is 0, leftmost home 
cnot_last_home_yet: 
                    ADDB     #HOME_OBJECT_SIZE            ; check next home (home object is 5 bytes long) 
                    CMPB     tmp1                         ; checked all homes yet 
                    BEQ      finnished_croco_stuff        ; yes, than no home is free 
                    BRA      ctest_next_house             ; and check again if empty... 

chome_is_empty:                                           ;        now we got a 'random' empty home address in B,U 
                    STB      croco_house                  ; remember offset to home for removal 
                    LDU      #home_objects                ; get address of U and add the offset 
                    LEAU     B,U                          ; in U address of 'random' home 
                    LDD      #crocoh1a_object             ; load croco object 
                    STD      ,U                           ; store to the calculated home address 
                    LDA      (crocoh1a_object+4)          ; load animation counter of object 
                    STA      4,U                          ; and store it to object in RAM 
                    DEC      croco_status                 ; is DISPLAYED 
home_cfull: 
                    BRA      finnished_croco_stuff        ; and finnished with croco stuff... 

; croco is allready displayed, must check if we should destroy it...
croco_is_being_displayed: 
; now destroy croco
                    LDB      croco_house                  ; load current croco offset 
                    LDU      #home_objects                ; get address of U and add the offset 
                    LEAU     B,U                          ; in U address of 'random' home 
                    LDD      #0 
                    STD      ,U 
                    INC      croco_status                 ; IS WAITING 
finnished_croco_stuff: 
                    LDD      croco_timer_start            ; reload the croco timer 
                    STD      croco_timer                  ; and store it 
no_croco_in_level: 
finnished_croco_stuff2: 






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; EXPECTS DP = C8!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; independent code section
; do timer stuff for diving turtles
; initiate alternate turtle sprites on
; timer...
; clean up stuff
; NOTE: turtles really suck
; sometimes turtles are torn appart due to
; huge sprite offsets
; higher than the (now used 5 maximum offset)
;
                    TST      dive_timer                   ; should the turtles dive? 
                    BNE      no_dive_change               ; if not zero, don't do anything 
                    LDA      dive_timer_start             ; first let us restore the timer 
                    STA      dive_timer                   ; store it HI 
                                                          ; go thru all sprites 
                                                          ; see if diving special is there, 
                                                          ; than change sprites to diving sprites 
                    LDY      #t_list 
next_dive_object: 
                    LDX      ,Y++ 
                    BEQ      all_objects_done 
                    LDU      ,X                           ; load object address 
                                                          ; U pointer to object 
                                                          ; X pointer to this object list 
                                                          ; Y pointer to t_list 
                                                          ; from here we change the actual object in the object list 
                                                          ; these special objects (for now only turtles) 
                                                          ; have an extra entry in their object describtion 
                                                          ; this is the 'alternate' object describtion address 
                                                          ; this will be loaded and placed in the object list 
                                                          ; on each timer 0 we just change to the alternate sprite 
                                                          ; which allways switches back and forth between diving 
                                                          ; and non diving turtles (as we defined the object 
                                                          ; information as this) 
                    STY      tmp1                         ; faster than a PSHS 
                    LEAY     [11,U]                       ; load alternate object to Y 
                    LDD      7,U                          ; load old sprite offsets 
                    NEGA                                  ; negate them (A) 
                    NEGB                                  ; negate them (B) 
                    ADDA     2,X                          ; add y position to old sprite offset y 
                    ADDB     3,X                          ; add x position to old sprite offset x 
                    ADDA     7,Y                          ; add new sprite offset y 
                    ADDB     8,Y                          ; add new sprite offset x 
                    STD      2,X                          ; and store the corrected position 
                    LDA      4,Y                          ; load new animation counter start 
                    STA      4,X                          ; and set it in object list 
                    STY      ,X                           ; store new object definition to object list 
                    LDY      tmp1                         ; faster than a PULS 
                    BRA      next_dive_object             ; and go on 

all_objects_done: 
no_dive_change: 
diving_done: 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                    LDA      otter_status 
                    CMPA     #IS_WAITING 
                    BNE      finnish_otter_timer_stuff    ; if not zero, do nothing 
                    TST      otter_timer 
                    BNE      finnish_otter_timer_stuff    ; if not zero, do nothing 
; if zero... initiate new otter
;                    JSR      Random                       ; get a random number 
 jsr getMyRandom
                    ANDA     #15                          ; random in range of 0 - 15 
                    STA      tmp1                         ; remember for lane offset 
                    ANDA     #7                           ; only the lower three bits 
                    CMPA     #5                           ; not higher than 5 
                    BLO      band_got                     ; if lower than ok 
                    LSRA                                  ; otherwise take only half of it 
band_got:                                                 ;        now we have a random river band... 
                    STA      otter_band                   ; this is the band we are on now 
                    LSLA                                  ; multiply by band structure width 
                    LSLA                                  ; which is 16 bytes 
                    LSLA     
                    LSLA     
                    TFR      A,B                          ; copy A to B 
                    CLRA                                  ; SEX B :-) but without sign 
                    ADDD     #band_list                   ; add address start of band list 
                                                          ; now we try to get a pseudo random offset of objects within 
                                                          ; this lane, we use the same random number as for lane determination 
                                                          ; but this time ranging from 0 - 15, see above 
                    INC      tmp1                         ; at least 1 in tmp1 so we don't loop to 255 
                                                          ; start address of this bandlist is in D (and remains there untouched...) 
object_random_select_init: 
                    TFR      D,X                          ; copy start of lane list to X 
object_random_select: 
                    LDU      ,X++                         ; load object list address to U 
                    BEQ      object_random_select_init    ; if zero than we have gone past the last object 
                                                          ; and jump to reinit X 
no_zero_object: 
                    DEC      tmp1                         ; otherwise we decrement our random value by 1 
                    BNE      object_random_select         ; if not zero, get the next object list member 
object_random_select_done: 
                    STU      otter_log_pre                ; store list object address of 
                                                          ; 'log' pre otter 
                    LDU      ,X                           ; load next list position 
                    BNE      got_second_log               ; if not zero jump 
                    TFR      D,X                          ; if zero we have to use the first object in this band 
                    LDU      ,X                           ; even if it is the same... as the pre object 
got_second_log: 
                    STU      otter_log_past               ; store list object address of 
                                                          ; 'log' past otter 
                    LDX      #otter1a_object              ; load object address of first otter animation to X 
                    LDU      otter_log_pre                ; load pre otter object list address 
                    LDD      2,U                          ; position of pre list object 
                    LDU      ,U                           ; pre object 
                    SUBA     7,U                          ; modify for y offset of pre object 
                    SUBB     8,U                          ; modify for x offset of pre object 
                    ADDB     3,U                          ; add length of pre object 
                    ADDA     7,X                          ; modify y position with otter offset 
                    ADDB     8,X                          ; modify x position with otter offset 
                    ADDB     #3                           ; add another 3 just for good measure... 
                    STD      otter_pos                    ; and store this as the new otter position 
                    CMPB     #85                          ; are we to far to the right? 
                    BGE      destroy_timer_otter          ; if so, don't use this otter 
                    CMPB     #-110                        ; are we to far to the left? 
                    BLE      destroy_timer_otter          ; if so don't use this otter either 
                                                          ; the above is sort of needed, since I don't want to check 
                                                          ; all fancy cases... there e.g. might be some weird positioning 
                                                          ; that otter is quasi outside of the main screen and the 
                                                          ; log it is looking for reaches the out of bounds boundary allways 
                                                          ; befor the otter has a chance to realize it is allready near 
                                                          ; thus the otter might stay there forever... 
                    LDA      ,U                           ; load speed of pre object 
                    INCA                                  ; otter allways + 1 
                                                          ; my otter allways moves from left to right 
                                                          ; or standstill 
                    STA      otter_speed                  ; store the new speed 
                    STX      otter_object                 ; store otter anim A 1 object as the relevant otter object 
                    LDA      4,U                          ; reset animation counter for otter 
                    STA      otter_anim_counter           ; and store it 
                                                          ; now we do some checking if we haven't gotten ourself a real 
                                                          ; stupid 'log' object, like a midway turtle or a 
                                                          ; middle 'big' log... 
                    LDU      otter_log_past               ; load object list address of object past otter 
                    LDB      otter_pos+1                  ; and load the position of otter now 
                    SUBB     3,U                          ; subtract these two 
                    _ABS_B                                ; absolute that 
                    CMPB     #15                          ; look if they are really near each other 
                                                          ; 15 'includes' length of otter, hardcoded :-( 
                    BHI      timer_otter_ok               ; if not near, go to end, otherwise destroy otter 
destroy_timer_otter: 
                    LDD      otter_timer_start            ; reload the otter timer 
                    STD      otter_timer                  ; and store it 
                    BRA      finnish_otter_timer_stuff    ; and go to done 

timer_otter_ok: 
                    DEC      otter_status                 ; is displayed 
finnish_otter_timer_stuff: 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                    _DP_TO_D0  
                    endm     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; IN MOVE 1 END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; independent code section
IN_MOVE_3           macro    
                    TST      kind_of_death+1              ; test if we are in death timer loop 
                    BNE      no_timer_change              ; frog is allready dead! 
                    LDD      fly_timer                    ; load fly timer 
                    SUBD     #$20                         ; decrease it 
                    STD      fly_timer                    ; store it back 
                    LDD      croco_timer                  ; load croco timer 
                    SUBD     #$20                         ; decrease it 
                    STD      croco_timer                  ; store it back 
                    LDD      dive_timer                   ; load the timer value 
                    CMPA     #$ff                         ; if $ff, than no turtle 
                    BEQ      not_dive_timer_change        ; overstep the next two 
                    SUBD     #$20                         ; count it down by $20 
                    STD      dive_timer                   ; store it 
not_dive_timer_change: 
                    LDD      my_timer                     ; load the timer value 
                                                          ; SUBD #$20 ; count it down by $20 
                    SUBD     #$10                         ; count it down by $20 
                    STD      my_timer                     ; store it 
                    LDA      otter_status 
                    CMPA     #IS_WAITING                  ; is displayed 
                    BNE      otter_no_timer_change 
                    LDD      otter_timer                  ; load otter timer 
                    SUBD     #$20                         ; decrease it 
                    STD      otter_timer                  ; store it back 
otter_no_timer_change: 
no_timer_change: 
                    ldx      currentMusic                 ; if music is not playing 
                    beq      no_streaming_here                 ; jump, otherwise initialize "in move" subroutines for ym decode 

 jsr STREAM_PART_1  ; also sets up inMovePointer
                    jsr      [inMovePointer]              ; first and second is really small 
no_streaming_here:


                    endm     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; independent code section
; decrease and check level timer
; warn if low
IN_MOVE_4           macro    
                    LDB      y_timer+1                    ; load new vector (length was cut by timer :-)) 
                    CMPB     #$20                         ; is it small yet? 
                    BGT      die_not_time 
                    BNE      go_on_timer1                 ; no, than jump 
                    tst      intermissionActive 
                    bne      die_not_time 
                    PLAY_SFX  KarlTimeOut_Sound 
                    BRA      die_not_time 

go_on_timer1: 
                    CMPB     #$10                         ; is it really really small? 
                    BNE      die_not_time                 ; nah, not that small yet 
                    tst      intermissionActive 
                    bne      die_not_time 
                    PLAY_SFX  KarlTimeOut_Sound 
die_not_time: 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                    jsr      [inMovePointer]              ; fourth is big
                    endm     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
COLLISION_MACRO     macro    
do_collision_check: 
                    _DP_TO_C8  
; collosion only allowed when not already dead
                    ldb      frogDeath 
                    lbne     out_here 
                                                          ; hey dissi "br eak" 
                    LDB      frog_y_band                  ; load band information 
; first we must get the position of this band in the band list
                    DECB                                  ; one less, since homes, don't have a band 
                    CLRA                                  ; fixed to 16 byte, 
                    LSLB                                  ; so we just use some LSL instead 
                    LSLB                                  ; of MUL... 
                    LSLB     
                    LSLB     
                    LDX      #band_list                   ; load bandlist 
                    LEAX     d,X                          ; and go to current band in bandlist 
collision_loop: 
                    LDU      ,X++                         ; get pointer to next object_list element in this band 
                    BEQ      end_no_collision_detected    ; if empty we are done 
collision_loop1: 
; ok, here we have an object_list entry we must check...
                    LDY      ,U 
; U pointer to object_list, points to position (y,x) information of current entry
; X pointer to band_list, points to NEXT possible entry of object_list
; Y pointer to object structure, points to speed of the current object
; now it gets tricky, we have to compare the position information,
; which is in SCALE_FACTOR_GAME
; with the sprite length and width, which is in SCALE_FACTOR_SPRITE
; we dismiss the difference here and just think that the
; value we find in 'length' in the object definition is
; also in SCALE_FACTOR_GAME, than we can do a normal compare!
;
                    LDA      frog_x                       ; load frog position 
                    INCA                                  ; so that detection is not all THAT sharp 
                    INCA                                  ; so that detection is not all THAT sharp 
                    CMPA     3,U                          ; compare it to x postion of object 
                    BLT      frog_lower                   ; if frog further left, jump 
frog_higher:                                              ;        otherwise frog is on the right 
                    SUBA     3,Y                          ; subtract length of object 
                    SUBA     3,U                          ; subtract X position of object 
                    BLT      collision_detected           ; if we are now on 'the left' we hit it 
                    LDU      ,X++                         ; get pointer to next object_list element in this band 
                    BNE      collision_loop1              ; if empty we are done 
end_no_collision_detected:                                ;  no collision detected, is that good? 
                    LDA      frog_y_band                  ; load band, if in lower half 
                    CMPA     #5                           ; not collision is good 
                    BLE      die_drown                    ; otherwise we die (drowning) 
end_no_collision_detected_really: 
                    jmp      out_here 

frog_lower:                                               ;        frog is on the left 
                    ADDA     current_frog_size_x          ; add the size of the frog to A (position of frog) 
                    CMPA     3,U                          ; compare it to x postion of object 
                    BLT      collision_loop               ; still lower, than no collision 
collision_detected:                                       ;       ok, a collision happened, check if good or bad 
                    LDA      frog_y_band                  ; load band information 
                    CMPA     #5                           ; if in upper half, than it is good 
                    BLE      transporting                 ; than we are being transported 
                    LDA      10,Y                         ; SPECIAL... 
                    BEQ      no_special_test_c            ; middle band is treated as a street 
                    CMPA     #SPECIAL_RIGHT_SNAKE         ; if a snake is encountered 
                    BNE      no_right_snake               ; jump if not 
                    LDA      frog_x                       ; load the frog postion 
                    SUBA     3,U                          ; minus X position of object 
                    CMPA     #11                          ; hardcoded length of snake :-( 
                    BLE      collision_loop               ; otherwise go on 
                    BRA      die_snake                    ; otherwise die a snake death 

no_right_snake: 
                                                          ; must be left snake than (or something is wrong) 
                                                          ; there are no special cars! 
                    LDA      frog_x                       ; load the frog postion 
                    SUBA     3,U                          ; minus X position of object 
                    CMPA     #10                          ; hardcoded length of snake :-( 
                    BGE      collision_loop               ; otherwise go on 
                    BRA      die_snake                    ; if lower than bitten by snake 

no_special_test_c: 
; NOTE: A should always be zero here
                    LDB      #DIE_CAR                     ; otherwise we die a DIE_CAR 
die_set: 
                    STD      kind_of_death                ; type of death 
die:                                                      ;        the frog is lost 
                    DEC      no_frogs                     ; decrease number of available frogs 
                    JSR      frog_dead                    ; do a frog_dead intermission, kind of death 
                                                          ; is correctly set in 'kind_of_death' 
                    direct   $d0 
 tst isAttractMode
 bne not_lost_yet; attract mode does not lose
                                                         ; LDA # '0' ; compare to '0' 
                                                          ; CMPA no_frogs ; the number of available frogs 
                    tst      no_frogs2 
                    Bgt      not_lost_yet                 ; if not zero yet, go on 
                    JMP      game_lost                    ; do a game_lost intermission and return there 

not_lost_yet: 
                    JSR      DP_to_C8                     ; init_new_frog_vars expects dp at c8 
                    direct   $C8 
                    JSR      init_new_frog_vars           ; clear the frog variables 
                    INIT_NEXT_MUSIC  inGameMusic1 
                    JMP      DP_to_D0                     ; init_new_frog_vars expects dp at c8 
                    ; rts 

die_out: 
                    LDD      #DIE_OUT                     ; die a DIE_OUT kind of 
                    BRA      die_set                      ; jump to die 

die_drown: 
                    LDD      #DIE_DROWN                   ; die a DIE_DROWN kind of 
                    BRA      die_set                      ; jump to die 

die_croco: 
                    LDD      #DIE_CROCO                   ; die a DIE_CROCO kind of 
                    BRA      die_set                      ; jump to die 

die_snake: 
                    LDD      #DIE_SNAKE                   ; die a DIE_SNAKE kind of 
                    BRA      die_set                      ; jump to die 

transporting:                                             ;        no we are 'riding' some object 
                    direct   $c8 
                    LDA      10,Y                         ; lets test the special flag... 
                    BEQ      no_special_test              ; if no special go on 
                    CMPA     #SPECIAL_LEFT_CROCO          ; test for left crocodile 
                    BNE      no_left_croco                ; if not, jump 
                    LDA      frog_x                       ; load the frog postion 
                    SUBA     3,U                          ; subtract X position of object 
                    CMPA     #10                          ; hardcoded length of croco :-( 
                    BGE     _no_snake_                   ; not eaten by croco, nothing else can be here 
                    BRA      die_croco                    ; if lower frogger was eaten by crocodile 

no_left_croco: 
                    CMPA     #SPECIAL_RIGHT_CROCO         ; are we sitting on a right croco? 
                    BNE      no_right_croco               ; no? than jump 
                                                          ; hey dissi "bre ak" 
                    LDA      frog_x                       ; load the frog postion 
                    SUBA     3,U                          ; subtract X position of object 
                    CMPA     #20                          ; hardcoded length of croco :-( 
                    BLE     _no_snake_                   ; not eaten by croco, nothing else can be here 
                    BRA      die_croco                    ; if higher frogger was eaten by crocodile 

no_right_croco: 
                    CMPA     #SPECIAL_DIVE_DOWN           ; look if this is a dived turtle 
                    BEQ      die_drown                    ; if yes... drown 
no_dived_turtle: 
no_special_test: 
; check if we 'capture' a girl
                    LDA      girl_status                  ; what's the girls status? 
                    CMPA     #IS_DISPLAYED                ; is it displayed 
                    BNE      _no_girl_                    ; no? than jump 
                    LDD      girl_log_object              ; load log object address 
                    SUBD     #3                           ; address + 3 is stored, correct it 
                    SUBD     -2,X                         ; subtract the current object information 
                    BNE      _no_girl_                    ; if not the same, go to no_girl_ 
                                                          ; check for collision 
                    LDB      girl_pos+1                   ; load girl x pos 
                    SUBB     frog_x                       ; subtract frog_x pos 
                    _ABS_B                                ; absolute it 
                    CMPB     #10                          ; if not in the range of 10 
                    BHI      _no_girl_                    ; jump to no girl 
girl_collision: 
                    DEC      girl_status                  ; IS CARRIED 
                    LDA      frog_bonus                   ; load bonus state 
                    ADDA     #GIRL_BONUS                  ; add a girl bonus 
                    STA      frog_bonus                   ; store it 
                    PLAY_SFX KarlGirlGot_Sound 
_no_girl_: 
; check if we hit a 'log' snake
                    LDA      snake_status                 ; what's the snake's status? 
                    CMPA     #IS_DISPLAYED                ; is it displayed 
                    BNE      _no_snake_                   ; no? than jump 
                    LDA      frog_y_band                  ; what band are we on now ? 
                    CMPA     #3                           ; compare with 'snake band' 
                    BNE      _no_snake_                   ; if not our band... go on 
                    LDX      snake_object                 ; which contains the log a objectlist address 
                    LDA      10,X                         ; load special 
                    CMPA     #SPECIAL_RIGHT_SNAKE         ; if a snake is encountered 
                    BNE      no_log_right_snake           ; jump if not 
                    LDB      frog_x                       ; load the frog postion 
                    SUBB     snake_pos + 1                ; minus X position of object 
                    SUBB     #32                          ; real hardcoded length 
                    _ABS_B                                ; absolut it 
                    CMPB     #4                           ; somewhere arround the snakes head? 
                    BGE      _no_snake_                   ; if higher, than not hit 
                    bra      die_snake                    ; otherwise than bitten by snake 

no_log_right_snake: 
                    CMPA     #SPECIAL_LEFT_SNAKE          ; now we look for left snake 
                    BNE      _no_snake_                   ; no?, than jump 
                    LDB      frog_x                       ; load the frog postion 
                    SUBB     snake_pos + 1                ; minus X position of object 
                    _ABS_B                                ; absolut it 
                    CMPB     #10                          ; somewhere arround the snakes head? 
                    lBLT     die_snake                    ; if lower than bitten by snake 
_no_snake_: 
                    LDA      frog_x                       ; load the frog postion 
                    ADDA     ,Y                           ; add the speed of the object 
                    STA      frog_x                       ; and store it 
                    CMPA     #FROG_RIGHT_OUT              ; are we out of bounds right? 
                    lBGT     die_out                      ; than dead 
                    CMPA     #FROG_LEFT_OUT               ; are we out of bounds left? 
                    lBLT     die_out                      ; than dead 
                    LDA      tmp_band_offset              ; ok, for checking of 'normal' bounds 
                                                          ; we need to calculate the band_x 
                                                          ; coordinates, 'tmp_band_offset' is now 
                                                          ; used as a helper 
                                                          ; it counts from 0 to 9 
                                                          ; if below 0 band_x is decremented 
                                                          ; if 10 or high it is incremented... 
                    ADDA     ,Y                           ; add the speed of the object 
                    BMI      band_minus_one               ; if below zero, dec band_x 1 
                    CMPA     #GRID_SIZE_GAME              ; if higher GRID_SIZE... 
                    BGE      band_plus_one                ; ... add one to band_x 
                    STA      tmp_band_offset              ; otherwise just store it back 
                    bra      out_here 

band_plus_one: 
                    INC      frog_x_band                  ; for internal checking 
                    SUBA     #GRID_SIZE_GAME              ; make it modulo 10 
                    STA      tmp_band_offset              ; store it 
                    bra      out_here 

band_minus_one: 
                    DEC      frog_x_band                  ; for internal checking 
                    ADDA     #GRID_SIZE_GAME              ; make it modulo 10 
                    STA      tmp_band_offset              ; store it 
out_here: 
                    _DP_TO_D0  
                    endm     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IN_MOVE_SNAKE       macro    
                    LEAU     1,U                          ; + 1 
                    LDD      snake_pos                    ; do positioning, load pos here 
                    ADDB     snake_speed                  ; add the speed, got from log information earlier 
                    CMPB     #(BOUNDARY_LO)               ; is on left side out of bounds? 
                    BGT      snot_lower_out_of_bounds     ; no, than no coordinate fiddling 
snake_wait: 
                    INC      snake_status                 ; is waiting 
                    LDA      snake_round_counter_reset    ; initiate the round counter 
                    STA      snake_round_counter          ; store it 
                    BRA      snake_done_no_snake_next_round 

snot_lower_out_of_bounds: 
                    CMPB     #(BOUNDARY_HI)               ; check if we are out of bounds on the right 
                    BGT      snake_wait 
snot_higher_out_of_bounds: 
                    STD      snake_pos                    ; and 're' store it 
snake_done_no_snake_next_round: 
                    DEC      snake_gone                   ; decrease the number of steps a snake does befor turing arround 
                    BNE      go_on_snake                  ; if not turning... go on 
                    LDA      9,U                          ; look at special in object definition for information... 
                    CMPA     #SPECIAL_RIGHT_SNAKE         ; are we now left or right? 
                    BEQ      switch_to_left_snake         ; if right... jump 
switch_to_right_snake: 
                    LDD      6,U                          ; load old sprite offsets 
                    NEGA                                  ; negate them (A) 
                    NEGB                                  ; negate them (B) 
                    ADDA     snake_pos                    ; add y position to old sprite offset y 
                    ADDB     snake_pos + 1                ; add x position to old sprite offset x 
                    LDY      #snake1a_object              ; load new object definition 
                    ADDA     7,Y                          ; add new sprite offset y 
                    ADDB     8,Y                          ; add new sprite offset x 
                    STD      snake_pos                    ; and store the corrected position 
                    STY      snake_object                 ; store new object definition 
                    LDA      4,Y                          ; load new animation counter start 
                    STA      snake_anim_counter           ; and set it in object list 
                    INC      snake_speed                  ; now go to opposite direction +1 equal log speed 
                    INC      snake_speed                  ; plus another to be 1 step faster 
                    LDA      #SNAKE_GO_LIMIT              ; get the limit of snake movement before turing again 
                    STA      snake_gone                   ; and store it 
                    BRA      snake_all_done               ; done with snake 

switch_to_left_snake: 
                    LDD      6,U                          ; load old sprite offsets 
                    NEGA                                  ; negate them (A) 
                    NEGB                                  ; negate them (B) 
                    ADDA     snake_pos                    ; add y position to old sprite offset y 
                    ADDB     snake_pos + 1                ; add x position to old sprite offset x 
                    LDY      #snake3a_object              ; load new object definition 
                    ADDA     7,Y                          ; add new sprite offset y 
                    ADDB     8,Y                          ; add new sprite offset x 
                    STD      snake_pos                    ; and store the corrected position 
                    STY      snake_object                 ; store new object definition 
                    LDA      4,Y                          ; load new animation counter start 
                    STA      snake_anim_counter           ; and set it in object list 
                    DEC      snake_speed                  ; now go to opposite direction -1 equal log speed 
                    DEC      snake_speed                  ; minus another to be 1 step faster 
                    LDA      #SNAKE_GO_LIMIT              ; get the limit of snake movement before turing again 
                    STA      snake_gone                   ; and store it 
                    BRA      snake_all_done               ; done with snake, on turn, no animation check is needed 

go_on_snake: 
                    DEC      ,X+                          ; decrease animation counter 
                    BNE      snake_all_done               ; if zero, we must initialize new animation phase 
; snake animation change
                    LDD      6,U                          ; load old sprite offsets 
                    NEGA                                  ; negate them (A) 
                    NEGB                                  ; negate them (B) 
                    ADDA     -3,X                         ; add y position to old sprite offset y 
                    ADDB     -2,X                         ; add x position to old sprite offset x 
                    LDY      4,U                          ; load new object definition 
                    ADDA     7,Y                          ; add new sprite offset y 
                    ADDB     8,Y                          ; add new sprite offset x 
                    STD      -3,X                         ; and store the corrected position 
                    STY      -5,X                         ; store new object definition to object list 
                    LDA      4,Y                          ; load new animation counter start 
                    STA      -1,X                         ; and set it in object list 
snake_all_done: 
                    endm     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GENERAL_IN_MOVE_SPRITE  macro  
; in move action here!
; following code must be executed here for all 
; in moves in the vectorlist,
; it is the preparation of the next object,
; so we leave it here...
;
; I go out of may way here to have y only localy used
; that way I can use y as a indirect jump variable for the unlooping
; jump ,y is 3 cycles
; jump [location] is 8 cycles!
;
                    leay     [2,x] 
                    LEAX     5,X                          ; [3] Increment X by 5 
                    ADDB     ,Y                           ; add to B (x coordinate that is) 
                                                          ; the speed value (in the list object, 
                                                          ; e.g. car_1), increment Y by 1 
;;;;; NOT USED NOW ;;;;;
; idea is to add speed only X cycles
; that way really slow speeds and differences can be done
; the main crux is girl and snake which
; depend on parents speeds
; this can be accomplished using two new variables - but 
; i don't think it is NEEDED - really
; the below few lines do NOT make a speed difference since its completley in MOVE TO
    if       HALFSPEED = 1 
                    lda      9,Y                          ; brightness 
                    beq      nosh 
                    bpl      inc_half 
                    anda     #$f 
                    anda     RecalCounter+1 
                    bne      nosh 
                    decb     
inc_half 
                    bra      nosh 

                    anda     #$f 
                    anda     RecalCounter+1 
                    bne      nosh 
                    incb     
nosh 
    endif    
;;;;; NOT USED NOW END ;;;;;
                    CMPB     #(BOUNDARY_LO)               ; is on left side out of bounds? 
                    BGT      not_lower_out_of_bounds      ; no, than no coordinate fiddling 
                    ADDB     #(127+100-MAX_SPRITE_OFFSET) 
                    BRA      now_check_for_girl           ; don't check for right out of bounds now 

not_lower_out_of_bounds: 
                    CMPB     #(BOUNDARY_HI)               ; check if we are out of bounds on the right 
                                                          ; BLE not_higher_out_of_bounds ; no? than go on 
                    bgt      higherOutOfBounds 
                    STB      ,X                           ; store the new x position 
                                                          ; (X points to animation) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; MOVE X START
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; about 20 - 30 cycles have already passed
; but neither girl nor snake was processed
; so we may do a short special in move here
; dp is c8 and does not need to be restored internally!
                    jsr      [inMovePointer]              ; [12] stream processing done in jsrs 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; MOVE X END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                    bra      not_higher_out_of_bounds2 

higherOutOfBounds: 
                    SUBB     #(127+100-MAX_SPRITE_OFFSET) 
; on each out of bounds a girl check is made...
now_check_for_girl: 
                    PSHS     B                            ; save coordinates 
                    _DP_TO_C8  
                    LDA      girl_status                  ; what's the girls status? 
                    BEQ      no_girl_                     ; no girl at all? than jump 
                    CMPX     girl_log_object 
                    BNE      no_girl_                     ; if not the same, go to no_girl_ 
                    LDA      girl_status                  ; what's the girls status? 
                    CMPA     #IS_WAITING                  ; we are waiting to be displayed 
                    BEQ      girl_might_be_displayed      ; than go to might be displayed routine 
                    CMPA     #IS_CARRIED                  ; if frogger carries girl, 
                    BEQ      no_girl_                     ; do nothing 
                                                          ; now IS_DISPLAYED, resetting counter and reset status 
is_currently_displayed: 
                    INC      girl_status                  ; IS WAITING 
                    LDA      girl_round_counter_reset     ; initiate the round counter 
                    STA      girl_round_counter           ; store it 
                                                          ;bra no_girl ; do not redisplay at once! 
girl_might_be_displayed:                                  ;  check if the girl will be displayed 
                    DEC      girl_round_counter           ; count down the round counter 
                    BNE      no_girl_                     ; if not zero, than no girl will be displayed 
                    DEC      girl_status                  ; IS DISPLAYED 
                    LDD      #girl1a_object               ; load girl object address 
                    STD      girl_object                  ; store it as first object 
                                                          ; now do positioning... 
                    LDB      ,S                           ; the position of the log is on the stack 
                    addb     #3                           ; more in the middle of the log 
                    STB      girl_pos+1                   ; get and store the X position 
                    LDA      #32                          ; y position hardcoded, since sprites have different starting points 
                    STA      girl_pos                     ; store y position 
                    BRA      no_snake_                    ; if we did girl, than no snake here! 

no_girl_: 
now_check_for_snake: 
                    LDA      snake_status                 ; what's the snake's status? 
                    BEQ      nothingSpecial               ; no snake at all? than jump 
                    CMPX     snake_log_object 
                    BNE      nothingSpecial               ; if not the same, go to no_snake_ 
                    LDA      snake_status                 ; what's the snake's status? 
                    CMPA     #IS_WAITING                  ; we are waiting to be displayed 
                    BEQ      snake_might_be_displayed     ; than go to might be displayed routine 
snake_is_currently_displayed: 
                    INC      snake_status                 ; IS WAITING 
                    LDA      snake_round_counter_reset    ; initiate the round counter 
                    STA      snake_round_counter          ; store it 
snake_might_be_displayed:                                 ;  check if the snake will be displayed 
                    DEC      snake_round_counter          ; count down the round counter 
                    BNE      no_snake_                    ; if not zero, than no snake will be displayed 
                    DEC      snake_status                 ; IS DISPLAYED 
                    LDD      #snake1a_object              ; load snake object address 
                    STD      snake_object                 ; store it as first object 
                                                          ; now do positioning... 
                    LDB      ,S                           ; the position of the log is on the stack 
                    STB      snake_pos+1                  ; get and store the X position 
                    LDA      #48                          ; y position hardcoded, since sprites have different starting points 
                    STA      snake_pos                    ; store y position 
                    LDA      snake_speed_start            ; get the speed of snake start 
                    STA      snake_speed                  ; store it 
                    LDA      #SNAKE_GO_LIMIT-10           ; get the number of steps a snake can take befor turning arround (hardcoded :-() 
                    STA      snake_gone                   ; and store it 
nothingSpecial: 
no_snake_: 
                    _DP_TO_D0  
                    PULS     B                            ; restore coordinates 
bound_test_done: 
not_higher_out_of_bounds: 
                    STB      ,X                           ; store the new x position, and increment U 
                                                          ; (U points to animation) 
not_higher_out_of_bounds2: 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; now we do that animation checking
                    LDU      1,Y                          ; load object vector list to u 
;;;;;;;;;;;; costs e.g. in level 8 18 cycles alltogether, we are still in "IN MOVE" range
;;;;; DRAW no snakes in intermission
                    tst      intermissionActive 
                    beq      noIntermissionNow 
                    ldb      #$10 
                    BITB     10,y                         ; get special flag 
                    beq      noSnakeBla 
                    bra      doNotDraw 

noSnakeBla 
                    dec      skipCount_now 
                    bpl      doNotDraw                    ;no_sprite_draw 
noIntermissionNow 
;;;;; DRAW no snakes in intermission
;;;;;;;;;;;;
                    DEC      1,X                          ; decrease animation counter 
                    BNE      no_animation_move            ; if zero, we must initialize new animation phase 
new_animation_phase: 
; 4 cycles less than above -> if I weren't lazy I would do that switch in other places also...
                    ldd      -1,X 
                    suba     7,y 
                    subb     8,y 
                    LDY      5,Y                          ; load new object definition 
                    ADDA     7,Y                          ; add new sprite offset y 
                    ADDB     8,Y                          ; add new sprite offset x 
                    STD      -1,X                         ; and store the corrected position 
                    STY      -3,X                         ; store new object definition to object list 
                    LDA      4,Y                          ; load new animation counter start 
                    STA      1,X                          ; and set it in object list 
no_animation_move: 
                    lda      2,x                          ; just a test if next vectorlist is 0 
                    LBEQ     anim_no_next                 ; and do the next object (or jump away) 
                    dec      skipCount_now 
                    bmi      goOnDraw                     ;no_sprite_draw 
doNotDraw 
; stop moving forcably!
                    lda      #0 
                    STA      VIA_t1_cnt_lo                ; move to time 1 lo, this means scaling 
                    STA      VIA_t1_cnt_hi                ; move to time 1 lo, this means scaling 
                    JMP      next_object                  ; and do the next 

goOnDraw 
                    pulu     y 
                    leay     >(unloop_start_address1+LENGTH_OF_HEADER),y ; 
                    LDD      #((SCALE_FACTOR_SPRITE*256)+$40) ; A= SCALE, B = Timer IRQ check 
                                                          ; the following is the position checking loop 
                                                          ; waiting till an interrupt occurs 
                    _SCALE_A                              ; scale for sprite 
                    endm     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
