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
tmp_add             ds       2                            ; poly 
tmp_angle           ds       2                            ; poly 
tmp_offset          ds       2                            ; poly 
tmp_lastpos         ds       2                            ; poly 
tmp_first_vector    ds       2 
base_angle          ds       2                            ; current start angle of base 
sided               ds       1                            ; current count of sides for base 
shieldWidthGrowth   ds       1                            ; shield width grows each "x" cycles by 1 
shieldWidth         ds       1                            ; shield width per default is 
shieldStart         ds       1 
shieldWidthCounter  ds       1 
shieldSpeed         ds       1 
noShieldGrowthVar   ds       1                            ; if shield has max size do not grow anymore! 
current_forth_dif   ds       1 
current_back_dif    ds       1 
innerShield         ds       1 
osc_forth           ds       1 
osc_back            ds       1 
rotList             ds       8*2+3                        ; some ... 
spawn_reset         ds       1                            ; after x ticks a new spawn happens 
spawn_timer         ds       1                            ; current counter for those ticks 
spawn_count         ds       1                            ; how many spawns are active 
NUM_OBJECTS         =        20 
                    org      $c900 
; 23 bytes per object
                    struct   ObjectStruct 
                    ds       TYPE,1                       ; enemy type 
                    ds       TICK_COUNTER,1               ; after how many rounds the movement updates (0 = each, 1 = every second etc)
                    ds       SPEED_COUNTER,1              ; with what value does the movement get updated (1-4)? 
                    ds       SCALE,1                      ; scale to position the object 
                    ds       ANGLE,2                      ; if angle base, angle in degree 
                    ds       ANIM_COUNTER,1               ; jmp to current draw routine 
                    ds       Y_POS,1                      ; current position 
                    ds       X_POS,1 
                    ds       CURRENT_LIST,2               ; current list vectorlist 
                    ds       DRAW_ROUTINE,2               ; jmp to current draw routine 
                    ds       ORIGIN,2                     ; pointer to original object definition 
                    ds       SHOT_ACTIVE,1 
                    ds       CHILD_ONE,2                  ; tailof kite - or active shot 
                    ds       CHILD_TWO,2 
                    ds       HIT_COUNT,1 
                    ds       DISPLAY_COUNT,1              ; time for scores to appear (max $ff ticks) 
                    ds       BONUS_COUNT,1                ; max bonus = 255 
                    ds       filler, 11 
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
BASE_SHIELD_WIDTH   =        5                            ; first shield with is 5 (shield starts at 15) scale 
SHIELD_WIDTH_GROWTH_DEFAULT  =  4                         ; grow shield width every 4 round with 1 
SHIELD_DEFAULT_SPEED  =      2                            ; increase with 1 every round 
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
                    lda      #20 
                    sta      spawn_reset 
                    sta      spawn_timer 
                    rts      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MY_LSL_D            macro    
                    ASLB     
                    ROLA     
                    endm                                  ; done 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; counts down spawn timer
; if 0 than spawn new
check_spawn 
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
                    ldd      #circle 
                    leau     d,u                          ; u pointer to spwan angle coordinates 
                    ldd      ,u 
                    std      Y_POS,x                      ; save start pos 
                    inc      spawn_count 
cs_done: 
                    rts      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; also move objects, moving for "normal" enemies "X" is decrease of scale
draw_objects 
                    lda      spawn_count 
                    sta      tmp_count 
                    ldu      #object_list 
do_next: 
                    dec      tmp_count 
                    bmi      do_done 
; object lists are nicely ordered, so we start at the beginning
                    dec      SCALE,u 
                    beq      removeObject 
                    lda      SCALE,u 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    JSR      Intensity_5F                 ; Sets the intensity of the 
                    ldd      Y_POS,u 
                    jsr      Moveto_d 
                    lda      #6 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    ldx      CURRENT_LIST,u 
;                    jsr      Draw_VLc 
                    jsr      [DRAW_ROUTINE,u] 
                    jsr      Reset0Ref 
do_next2: 
                    leau     ObjectStruct,u 
                    bra      do_next 

do_done: 
                    rts      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; in x the current object list pos
removeObject: 
                    dec      spawn_count 
; get last object and fill the just "freed" space
                    beq      do_done                      ; if it was the last object, we do not need to copy anything 
; load u pointer with last pos
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
                    bra      do_next                      ; do not add for next object, since the just copied object is now the "next" 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                    INCLUDE  "drawSubRoutines.i"          ; vectrex function includes
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
                    jsr      draw_objects 
                    BRA      main                         ; and repeat forever 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; construct new shield from current player base
newShield: 
                    lda      #BASE_SCALE+BASE_SHIELD_WIDTH ; the relevant "measure" shield is the outer shield wall 
                    sta      shieldStart                  ; this is our reference "start" value 
                    sta      osc_forth                    ; both oscillator drawing start from the outer rim 
                    sta      osc_back 
                    lda      shieldSpeed                  ; the speed of oscillators differe while still groeing 
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
finishShield: 
                    jmp      no_playerAction 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
drawPlayerHome: 
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
                    INCLUDE  "Data.i"                     ; vectrex function includes
