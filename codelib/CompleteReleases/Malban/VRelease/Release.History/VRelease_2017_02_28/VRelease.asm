;***************************************************************************
; DEFINE SECTION
;***************************************************************************
; load vectrex bios routine definitions
                    INCLUDE  "VECTREX.I"                  ; vectrex function includes
;***************************************************************************
; Variable / RAM SECTION
;***************************************************************************
; insert your variables (RAM usage) in the BSS section
; user RAM starts at $c880 
                    BSS      
                    ORG      $c880                        ; start of our ram space 
; Vars
;
zero_delay          ds       1                            ; obsolete ; delay for sync list -> variable 
current_button_state  ds     1                            ; only bit 0 
last_button_state   ds       1                            ; only bit 0 
tmp_count           ds       1                            ; poly 
tmp_count2          ds       1                            ; 
tmp_add             ds       2                            ; poly 
tmp_angle           ds       2                            ; poly 
tmp_offset          ds       2                            ; poly 
tmp_lastpos         ds       2                            ; poly 
tmp_first_vector    ds       2 
base_angle          ds       2                            ; current start angle of base (*2) 
sided               ds       1                            ; current count of sides for base 
shieldWidthGrowth   ds       1                            ; shield width grows each "x" cycles by 1 
shieldWidth         ds       1                            ; shield width per default is 
shieldStart         ds       1 
shieldWidthCounter  ds       1 
shieldSpeed         ds       1                            ; speed of the shield MOVEMENT - not the speed of growth 
noShieldGrowthVar   ds       1                            ; if shield has max size do not grow anymore! 
current_forth_dif   ds       1 
current_back_dif    ds       1 
innerShield         ds       1 
osc_forth           ds       1 
osc_back            ds       1 
rotList             ds       8*2+3                        ; some ... space for a max 8 sided base 
spawn_reset         ds       1                            ; after x ticks a new spawn happens 
spawn_timer         ds       1                            ; current counter for those ticks 
spawn_count         ds       1                            ; how many spawns are active 
currentMaxOffset    ds       1 
NUM_OBJECTS         =        20 
                    org      $c900 
; 23 bytes per object
                    struct   ObjectStruct 
                    ds       TYPE,1                       ; enemy type 
                    ds       TICK_COUNTER,1               ; after how many rounds the movement updates (0 = each, 1 = every second etc) 
                    ds       SPEED_COUNTER,1              ; with what value does the movement get updated (1-4)? 
                    ds       SCALE,1                      ; scale to position the object 
                    ds       ANGLE,2                      ; if angle base, angle in degree *2 
                    ds       ANIM_COUNTER,1               ; jmp to current draw routine 
                    ds       Y_POS,1                      ; current position 
                    ds       X_POS,1 
                    ds       CURRENT_LIST,2               ; current list vectorlist 
                    ds       DRAW_ROUTINE,2               ; jmp to current draw routine 
                    ds       ORIGIN,2                     ; pointer to original object definition 
                    ds       SHOT_ACTIVE,1 
                    ds       CHILD_ONE,2                  ; tailof kite - or active shot 
                    ds       CHILD_TWO,2 
                    
                    ds       EXPLOSION_SCALE,0
                    ds       HIT_COUNT,1 
                    ds       DISPLAY_COUNT,1              ; time for scores to appear (max $ff ticks) 
                    ds       BONUS_COUNT,1                ; max bonus = 255 
 ds BEHAVIOUR,2
                    ds       filler, 7 
                    end struct 
object_list         ds       ObjectStruct*NUM_OBJECTS 
o_type              =        object_list+TYPE 
o_scale             =        object_list+SCALE 
o_angle             =        object_list+ANGLE 
o_anim              =        object_list+ANIM_COUNTER 
o_pos               =        object_list+Y_POS 
o_list              =        object_list+CURRENT_LIST 
; hey dissi "watch o_pos 2"
;
; Defines
;
BASE_SCALE          =        5                            ; base scale is "5" 
;BASE_SHIELD_WIDTH   =        5                            ; first shield width is 5 (shield starts at 15) scale 
SHIELD_WIDTH_GROWTH_DEFAULT  =  4                         ; grow shield width every 4 round with 1 
SHIELD_DEFAULT_SPEED  =      2                            ; increase position of shield with 2 every each increase step 
BASE_SHIELD_WIDTH set 20

EXPLOSION_MAX = 30 ; max scale of explosion


TYPE_X = 1
TYPE_EX = -1


;
;
;***************************************************************************
; HEADER SECTION
;***************************************************************************
; The cartridge ROM starts at address 0
                    CODE     
                    ORG      0 
; the first few bytes are mandatory, otherwise the BIOS will not load
; the ROM file, and will start MineStorm instead
                    DB       "g GCE 1998", $80 ; 'g' is copyright sign
                    DW       music1                       ; music from the rom 
                    DB       $F8, $50, $20, -$80          ; hight, width, rel y, rel x (from 0,0) 
                    DB       "RELEASE", $80               ; some game information, ending with $80
                    DB       0                            ; end of game header 
;***************************************************************************
; CODE SECTION
;***************************************************************************
; here the cartridge program starts off
                    jmp      start 

here1: 
                    bra      here1 

; initialize all game vars with sensible dfault values
initGame 
                    clra     
                    sta      spawn_count 
                    sta      current_button_state         ; store a known current button state 
                    sta      last_button_state 
                    ldd      #8                           ; start with a 5 sided polygon 
                    stb      sided 
                    clrb                                  ; start at angle 0 
                    std      base_angle 
                    lda      #SHIELD_WIDTH_GROWTH_DEFAULT ; shield per default grows one scale per round 
                    sta      shieldWidthGrowth 
                    lda      #SHIELD_DEFAULT_SPEED 
                    sta      shieldSpeed 
                    lda      #20                          ; spawn timer 
                    sta      spawn_reset 
                    sta      spawn_timer 
                    rts      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; macro D = D *2
MY_LSL_D            macro    
                    ASLB     
                    ROLA     
                    endm                                  ; done 
; macro D = D /2
MY_LSR_D            macro    
                    ASRA     
                    RORB     
                    endm                                  ; done 
; set X to correct correction pointer for current sidedness polygon
SET_CORRECTION_POINTER  macro  
                    ldx      #polygon_5_correction 
                    lda      sided 
                    cmpa     #5 
                    beq      done\? 
                    leax     (polygon_6_correction-polygon_5_correction),x 
                    cmpa     #6 
                    beq      done\? 
                    leax     (polygon_7_correction-polygon_6_correction),x 
                    cmpa     #7 
                    beq      done\? 
                    leax     (polygon_8_correction-polygon_7_correction),x 
done\? 
                    endm     
; load the "divider" for n polygone (given in sided)
; to d
GET_POLY_DIV        macro    
                    lda      sided 
                    cmpa     #5 
                    bne      test_n6\? 
                    ldd      #FIVE_ADD 
                    bra      got_it\? 

test_n6\?: 
                    cmpa     #6 
                    bne      test_n7\? 
                    ldd      #SIX_ADD 
                    bra      got_it\? 

test_n7\?: 
                    cmpa     #7 
                    bne      test_n8\? 
                    ldd      #SEVEN_ADD 
                    bra      got_it\? 

test_n8\?: 
                    ldd      #EIGHT_ADD 
got_it\?: 
                    endm     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; counts down spawn timer
; if 0 than spawn new
check_spawn: ;#isfunction 
                    dec      spawn_timer 
                    bne      cs_done 
; reset the timer for next spawn
                    lda      spawn_reset 
                    sta      spawn_timer 
; calculate object position of next spawned object
                    lda      spawn_count 
                    ldb      #ObjectStruct 
                    mul      
                    ldx      #object_list                 ; object list 
                    leax     d,x                          ; pointer to new object 
; determine (random) type
; random coordinates
; scale
; ... somehow determine ranom type of object
; for starters we determined an "X" object
                    ldu      #enemyXObject 
; TODO
; copy and initialze new enemy
                    stu      ORIGIN,x 
 lda #TYPE_X
 sta TYPE, x
 ldd #xBehaviour
 std BEHAVIOUR,x
                    ldd      1,u                          ; draw routine 
                    std      DRAW_ROUTINE,x 
                    ldd      3,u                          ; vectorlist 
                    std      CURRENT_LIST,x 
                    lda      5,u                          ; anim reset 
                    sta      ANIM_COUNTER,x 
                    lda      #$ff 
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
                    inc      spawn_count 
cs_done: 
                    rts      
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; behaviours control (action) and draw all objects
; each object type has an individual behaviour
; 
; ! the behavhoiur is responsibly to
; increase the U pointer (                    leau     ObjectStruct,u)
; since e.g. a remove does NOT increase the pointer!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
xBehaviour;#isfunction
                    dec      SCALE,u 
                    bne      base_not_reached 

                    bra      removeObject 
                    bra      do_next 

base_not_reached 
                    beq      removeObject 
                    lda      SCALE,u 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo) 
                    JSR      Intensity_5F                 ; Sets the intensity of the 
                    ldd      Y_POS,u 
                    jsr      Moveto_d 
                    lda      #6 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    ldx      CURRENT_LIST,u 
                    jsr      [DRAW_ROUTINE,u] 
                    leau     ObjectStruct,u 
                    jmp      Reset0Ref 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

explosionBehaviour ;#isfunction 
                    lda  EXPLOSION_SCALE,u 
;                    inca 
;                    inca 
                    inca 
                    sta  EXPLOSION_SCALE,u 
                    cmpa #EXPLOSION_MAX  
                    bgt endExplosion
; draw exposion
                    jsr      [DRAW_ROUTINE,u] 

                    leau     ObjectStruct,u 
                    jmp      Reset0Ref 
endExplosion:
                    bra      removeObject 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; also move objects, moving for "normal" enemies "X" is decrease of scale
do_objects 
                    lda      spawn_count 
                    sta      tmp_count 
                    ldu      #object_list 
do_next: 
                    dec      tmp_count 
                    bmi      do_done 
; object lists are nicely ordered, so we start at the beginning
 jsr [BEHAVIOUR,u]
                    bra      do_next 

do_done: 
                    rts      


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; in x the current object list pos
removeObject: ;#isfunction 
                    dec      spawn_count 
; get last object and fill the just "freed" space
                    beq      do_done                      ; if it was the last object, we do not need to copy anything 
; load u pointer with last pos
                    pshs x
                    leax     ,u                           ; moveMem TO 
                    lda      spawn_count 
                    ldb      #ObjectStruct 
                    mul      
                    ldu      #object_list                 ; object list 
                    leau     d,u                          ; moveMem FROM 
; now copy all entries
                    lda      #ObjectStruct                ; moveMem count 
                    jsr      Move_Mem_a 
                    leau     ,x                           ; restore old u 
                    puls     x
                    rts      

                    INCLUDE  "drawSubRoutines.i"          ; vectrex function includes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
start: 
                    jsr      initGame 
main: 
                    jsr      Wait_Recal 
; increase base angle by 1 degree
; and modulo it at 360 degrees
                    ldx      base_angle 
                    leax     2,x 
                    cmpx     #(360*2) 
                    blo      angleOk 
                    leax     -(360*2),x 
angleOk: 
                    stx      base_angle 
; query joystick buttons
; four states:
; a) was not pressed and is not pressed -> do nothing
; b) was not pressed and is NOW pressed -> init new shield
; c) was pressed and is pressed -> continue shield (grow)
; d) was pressed and is NOT pressed -> shield finished
                    jsr      getButtonState               ; is a button pressed? 
                    CMPB     #$01                         ; yes, but last time is was not pressed 
                    beq      newShield 
                    CMPB     #$03                         ; yes, and last time was pressed 
                    beq      continueShield 
                    CMPB     #$02                         ; no, but last time was pressed 
                    lbeq     finishShield 
; beq no_playerAction ; zero means no, and last was also not pressed
no_playerAction: 
                    jsr      Reset0Ref 
                    jsr      drawPlayerHome 
                                                          ; vector beam to $5f 
                    jsr      Reset0Ref 
                    jsr      check_spawn 
                    jsr      do_objects 
                    BRA      main                         ; and repeat forever 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; construct new shield from current player base
newShield: 
                    lda      #BASE_SCALE+BASE_SHIELD_WIDTH ; the relevant "measure" shield is the outer shield wall 
                    sta      shieldStart                  ; this is our reference "start" value 
                    sta      osc_forth                    ; both oscillator drawing start from the outer rim 
                    sta      osc_back 
                    lda      shieldSpeed                  ; the speed of oscillators differs while still growing 
                    lsla     
                    sta      current_forth_dif            ; going forth is double the shield speed 
                    lsra     
                    lsra     
                    sta      current_back_dif             ; going back is half the shield speed 
; init a new shield with default values
                    lda      #BASE_SHIELD_WIDTH           ; for a new shield initialize the width to 
                    sta      shieldWidth                  ; the default width 
                    lda      shieldWidthGrowth 
                    sta      shieldWidthCounter 
                    clr      noShieldGrowthVar            ; once the shield reaches maximum ($ff) stop growing - here, allow it 
; each single button press (== new shield)
; the side of the base (and shield) is
; increased up 8 sides
                    lda      sided 
                    inca     
                    cmpa     #8 
                    ble      sideok 
                    lda      #5 
sideok 
                    sta      sided 
; set the current maximum of possible offset values
; for the n sided polygon
; used in first stage shield bound-check
                    suba     #5 
                    ldx      #maxOffsetValues 
                    lda      a,x 
                    sta      currentMaxOffset 
; shield scale starts of with base scale + shield width
; each round the size of the
; shield increases
continueShield: 
                    tst      noShieldGrowthVar            ; do not grow if max size is acchieved 
                    bne      noShieldGrowth 
                    dec      shieldWidthCounter           ; growth only happens each "x" rounds (kept in shieldWidthCounter) 
                    bpl      noShieldGrowth               ; jump if that counter is not belwo zero 
                    lda      shieldWidthGrowth            ; restore current growth rate to counter 
                    sta      shieldWidthCounter 
; shield growth influences the width of the shield,
; NOT the position!
                    inc      shieldWidth                  ; increase the width of the shield 
noShieldGrowth: 
; no the position of the shield is updated
                    lda      shieldStart 
                    adda     shieldSpeed 
                    bcc      noMax                        ; $ff is max, if carry is set, than we have an overflow to our max, 
; if outer shield stops growing we have to fix the oscilator speed
; oscillator speed is now dependend on
; a) width of shield
; b) speed of growth
                    lda      shieldSpeed 
                    sta      current_forth_dif 
                    sta      current_back_dif 
                    lda      shieldWidth 
                    cmpa     #$80 
                    ble      nowidthuse 
                    lsra     
                    lsra     
                    lsra     
                    sta      current_forth_dif 
                    sta      current_back_dif 
nowidthuse 
; also reduce the max to (unsigned) 255
                    lda      #$ff                         ; max the shields outer rim 
noMax: 
                    sta      shieldStart 
; and draw the complete shield 
                    jsr      drawShield 
                    jmp      no_playerAction 

finishShield:  ;#isfunction 
; check all objects if they are destroyed by shield vanishing
;..............
                    SET_CORRECTION_POINTER                ; load x with correct correction pointer 
                    lda      spawn_count 
                    sta      tmp_count 
                    ldu      #object_list 
do_next_shield_check: 
                    dec      tmp_count 
                    bmi      shield_check_done 
                    jsr      onShield 
                    tsta     
                    beq      shield_not_touched           ; branch if a (shield inner wall) is higher or same than pos (scale) of object 
                    jsr      exchangeToExplosion 
;                    bsr      removeObject 
                                                          ; init explosion 
;                    bra      do_next_shield_check 

shield_not_touched: 
                    leau     ObjectStruct,u 
                    bra      do_next_shield_check 

shield_check_done: 
;..............
                    jmp      no_playerAction 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; u pointer to object being tested
; relevant data in u, SCALE
; routine tests if object hits the shield
; return a = 0 -> no
; return a = 1 -> yes
; u is preserved
; expects polygon correction table of the current shield polygon set to X
; 
; trying to figure out whether the current object 
; mathematically lies on the area of the shield is
; quite bothersome - so I take a shortcut here
; since I know the current angle of the base and the "angle" of the object
; I can calculate the difference in angle
; both objects are drawn with the same scale
; knowing that the scale is actual the radius of a circle they are drawn
; around the middle point, I only have to check whether
; the object lies within the inner radius (scale) and the outer radius
; (scale) of the shield
; using a perfect circle while drawing a 5 sided polygon is
; error prone, but since I know the angle between the objects
; I can do some error correction to "circle" coordinates
; to simulate a n sided polygon
; for each sided x sided polygon slightly  different error corrections
; are used
; using the radius and a polygon correction I ONLY
; have to check the scale value not even a single coordinate!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; n correction values
correctionList: 
polygon_5_correction:                                     ;     72 values 
                    db       0, 1, 2, 3, 5, 7, 9, 11, 13, 14 
                    db       15, 16, 16, 17, 17, 17, 17, 17, 17, 18 
                    db       18, 18, 18, 18, 18, 18, 18, 18, 19, 19 
                    db       19, 19, 19, 19, 20, 20, 20, 19, 19, 19 
                    db       19, 19, 19, 18, 18, 18, 18, 18, 18, 18 
                    db       18, 18, 17, 17, 17, 17, 17, 17, 16, 16 
                    db       15, 14, 13, 13, 11, 9, 7, 5, 3, 2 
                    db       1, 0 
polygon_6_correction:                                     ;     60 values 
                    db       0, 1, 2, 3, 4, 6, 8, 10, 11, 11 
                    db       12, 12, 12, 13, 13, 13, 13, 13, 13, 13 
                    db       13, 13, 14, 14, 14, 14, 14, 14, 15, 15 
                    db       15, 15, 14, 14, 14, 14, 14, 14, 13, 13 
                    db       13, 13, 13, 13, 13, 13, 13, 12, 12, 12 
                    db       11, 11, 10, 8, 6, 4, 3, 2, 1, 0 
polygon_7_correction:                                     ;     52 values 
                    db       0, 1, 2, 3, 4, 5, 6, 6, 6, 7 
                    db       7, 7, 7, 8, 8, 8, 8, 8, 9, 9 
                    db       10, 10, 9, 9, 8, 8, 8, 8, 8, 7 
                    db       7, 7, 7, 6, 6, 6, 5, 4, 3, 2 
                    db       1, 0 
polygon_8_correction:                                     ;     45 values 
                    db       0, 1, 2, 3, 4, 5, 5, 6, 6, 6 
                    db       7, 7, 7, 7, 7, 7, 8, 8, 8, 8 
                    db       8, 9, 9, 9, 8, 8, 8, 8, 8, 7 
                    db       7, 7, 7, 7, 7, 6, 6, 6, 5, 5 
                    db       4, 3, 2, 1, 0 
maxOffsetValues: 
                    db       21,16,11,10 

SHIELD_VARIANCE     equ      5 
out_notTouched 
                    clra     
                    rts      

onShield: 
; first look if current object and shield are completely out of bounds
 lda TYPE,u
 bmi out_notTouched
                    lda      shieldStart                  ; outer shield border 
                    cmpa     #$ff 
                    bhs      noadd_os1 
                    adda     #SHIELD_VARIANCE             ; a little bit wider 
noadd_os1: 
                    cmpa     SCALE,u                      ; compare outer border with object position 
                    bls      out_notTouched               ; branch if a (shield outer wall) is lower or same than pos (scale) of object 
                    suba     shieldWidth 
                    suba     #(2*SHIELD_VARIANCE)         ; wider (to compensate size of object and irregulatity to circle coords) 
                    suba     currentMaxOffset 

; todo - check if below zero                   
 cmpa     SCALE,u                      ; compare outer border with object position 
                    bhs      out_notTouched               ; branch if a (shield inner wall) is higher or same than pos (scale) of object 
; now a more thorough check is needed
; if the shield were a perfect circle the above should be enough

                    ldd      ANGLE,u                      ; angle of object 
                    subd     base_angle                   ; angle diff = object angle - base angle 
                    bpl      isPositive_os 
                    addd     #720 
isPositive_os: 
                    MY_LSR_D                              ; half it (value now 0 - 360 ) 
                    tfr      d,y 
                    GET_POLY_DIV                          ; load polygone "divider" to d (72, 60, 52 or 45)
                    lsrb     
                    negb     
; the following does a 
; angle % poly divider
;  (gets the angle modulo the polygon angle)
getMod_os: 
                    leay     b,y 
                    cmpy     #0                           ; lea does not influence carry :-( 
                    bpl      getMod_os 
                    negb     
                    leay     b,y 
; mod done
                    tfr      y,d 
                    leay     d,x 
; now in y
; is the pointer to the correction table, for circle position correction of
; our object in relation to the shield polygon
; do the above check AGAIN now with correction values present
                    lda      shieldStart                  ; outer shield border 
                    cmpa     #$ff 
                    bhs      noadd_os2 
                    adda     #SHIELD_VARIANCE             ; a little bit wider 
noadd_os2: 
                    suba     ,y 
                    cmpa     SCALE,u                      ; compare outer border with object position 
                    bls      out_notTouched               ; branch if a (shield outer wall) is lower or same than pos (scale) of object 
                    suba     shieldWidth 
                    suba     #(2*SHIELD_VARIANCE)         ; wider  
                    cmpa     SCALE,u                      ; compare outer border with object position 
                    bhs      out_notTouched               ; branch if a (shield inner wall) is higher or same than pos (scale) of object 
                    lda      #1 
                    rts      

;; shield hit, remove object
; jsr removeObject
; todo - add explosion
; jmp do_next_shield_check
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
drawPlayerHome: ;#isfunction
; draw player "home"
                    JSR      Intensity_5F                 ; Sets the intensity of the 
                                                          ; vector beam to $5f 
                    lda      #BASE_SCALE 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    jsr      buildRotatedNSidedFigure 
                    ldx      #rotList 
                    jsr      drawRotated 
                    rts      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
drawShield: 
; outer shield wall
                    JSR      Intensity_5F                 ; Sets the intensity of the 
                    lda      shieldStart 
                    sta      VIA_t1_cnt_lo                ; to timer t1 
                    ldx      #rotList 
                    jsr      drawRotated 
; inner shield wall (calc by width)
                    jsr      Reset0Ref 
                    lda      shieldStart 
                    suba     shieldWidth 
                    cmpa     #BASE_SCALE 
                    bhs      shieldWidthOk 
                    lda      #BASE_SCALE 
                    inc      noShieldGrowthVar 
shieldWidthOk: 
                    sta      innerShield 
                    sta      VIA_t1_cnt_lo                ; to timer t1 
                    ldx      #rotList 
                    jsr      drawRotated 
; draw oscillators
                    jsr      Reset0Ref 
; forth
                    ldb      osc_forth 
                    addb     current_forth_dif 
                    stb      osc_forth 
                                                          ; does not effect carry 
                    bcs      new_osc_forth 
                    subb     shieldStart 
                    bcs      draw_next_osc_forth 
new_osc_forth: 
                    ldb      shieldStart 
                    subb     shieldWidth 
                    stb      osc_forth 
                                                          ; does not effect carry 
draw_next_osc_forth: 
                    ldb      osc_forth 
                                                          ; load current scale (of index) 
                    stb      VIA_t1_cnt_lo                ; to timer t1 
                    ldx      #rotList 
                    jsr      drawRotated 
                    jsr      Reset0Ref 
; back
                    ldb      osc_back 
                    subb     current_back_dif 
                    stb      osc_back 
                    subb     innerShield 
                    bcc      draw_next_osc_back 
new_osc_back 
                    ldb      shieldStart 
                    stb      osc_back 
draw_next_osc_back: 
                    ldb      osc_back 
                                                          ; load current scale (of index) 
                    stb      VIA_t1_cnt_lo                ; to timer t1 
                    ldx      #rotList 
                    jsr      drawRotated 
                    rts      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Button 1-4
; returns in B the current button state in relation to last button state
; bit 0 represents current button state
; bit 1 last button state
; 1 = pressed
; 0 = not pressed
getButtonState: 
; save last states, and shift the old current one bit
; query buttons from psg
                    LDA      #$0E                         ;Sound chip register 0E to port A 
                    STA      <VIA_port_a 
                    LDD      #$9981                       ;sound BDIR on, BC1 on, mux off 
                    sta      <VIA_port_b                  ; VIA Port B = 99, mux disabled, RAMP disabled, BC1/BDIR = 11 (Latch address) 
                    NOP                                   ;pause 
                    STB      <VIA_port_b                  ; VIA Port B = 81, mux disabled, RAMP disabled, BC1/BDIR = 00 (PSG inactive) 
                    CLR      <VIA_DDR_a                   ;DDR A to input 
                    LDD      #$8981                       ;sound BDIR off, BC1 on, mux off 
                    STA      <VIA_port_b                  ; VIA Port B = 89, mux disabled, RAMP disabled, BC1/BDIR = 01 (PSG Read) 
                    NOP                                   ;pause 
                    LDA      <VIA_port_a                  ;Read buttons 
                    STB      <VIA_port_b                  ; VIA Port B = 81, mux disabled, RAMP disabled, BC1/BDIR = 00 (PSG inactive) 
                    LDB      #$FF 
                    STB      <VIA_DDR_a                   ;DDR A to output 
; query done, in A current button state directly from psg
                    ldb      current_button_state 
                    stb      last_button_state 
                    lslb     
                    anda     #$f                          ; only jostick 1 
                    cmpa     #$0f 
                    beq      noButtonPressed 
                    incb     
noButtonPressed: 
                    stb      current_button_state 
                    andb     #3 
                    rts      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; builds to rotList
; in "base_angle" the angle to "rotate" (from 0 to 720 = 2 *360) since it is a 16 bit pointer angle!
; in "sided" the number of sides of the figure (regular figure, can be build by regular offsets in circle list)
; move coordinate is angle in circle list
; second and each following coordinate (n sided "add" in circle list)
; Ydrawvector = y2-y1
; Xdrawvector = x2-x1
; list generated will be format:
; db count
; db move y,x
; db draw y,x
; ...
; db draw y,x
;
; times two, since angle is a "list" of 16 bit values
FIVE_ADD            =        (360/5)*2 
SIX_ADD             =        (360/6)*2 
SEVEN_ADD           =        (360/7)*2 
EIGHT_ADD           =        (360/8)*2 
buildRotatedNSidedFigure 
                    ldu      #rotList 
                    lda      sided 
                    deca     
                    sta      tmp_count 
                    dec      tmp_count                    ; one less, since I plan to use the last vector pos = first vector pos 
                    sta      ,u+                          ; count 
; seek sidedness
                    cmpa     #4 
                    bne      test_n6 
                    ldd      #FIVE_ADD 
                    bra      brnsf1 

test_n6 
                    cmpa     #5 
                    bne      test_n7 
                    ldd      #SIX_ADD 
                    bra      brnsf1 

test_n7 
                    cmpa     #6 
                    bne      test_n8 
                    ldd      #SEVEN_ADD 
                    bra      brnsf1 

test_n8 
                    ldd      #EIGHT_ADD 
brnsf1: 
                    std      tmp_add                      ; add to angle for n sided polygon 
                    ldd      base_angle 
                    std      tmp_angle 
                    ldx      #circle 
                    ldd      d,x 
                    std      ,u++                         ; move 
                    std      tmp_first_vector 
                    std      tmp_lastpos 
                                                          ; now the sided 
next_brnsf: 
                    ldd      tmp_angle 
                    addd     tmp_add 
                    cmpd     #(360*2) 
                    blo      brnsf2 
                    subd     #(360*2) 
brnsf2 
                    std      tmp_angle 
                    ldd      d,x                          ; a = y2, b = x2 
                    tfr      d,y 
                                                          ; now we must build the y2-y1 etc part 
                    suba     tmp_lastpos                  ; y2-y1 
                    sta      ,u+                          ; store y move 
                    subb     tmp_lastpos+1                ; x2-x1 
                    stb      ,u+                          ; store x move 
                    sty      tmp_lastpos 
                    dec      tmp_count 
                    bpl      next_brnsf 
;; ensure last vector = first vector
                    ldd      tmp_first_vector             ; a = y2, b = x2 
                    tfr      d,y 
                                                          ; now we must build the y2-y1 etc part 
                    suba     tmp_lastpos                  ; y2-y1 
                    sta      ,u+                          ; store y move 
                    subb     tmp_lastpos+1                ; x2-x1 
                    stb      ,u+                          ; store x move 
                    rts      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; exchange the object structure pointed to by U register
; with a new "explosion" type object 
exchangeToExplosion: ;#isfunction 
 lda #TYPE_EX
 sta TYPE, u
 ldd #explosionBehaviour
 std BEHAVIOUR,u
 clr EXPLOSION_SCALE,u

 ldd #explosionDotDraw
 std DRAW_ROUTINE,u

 rts 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                    INCLUDE  "Data.i"                     ; vectrex function includes
