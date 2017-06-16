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
;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Sound vars
;;;;;;;;;;;;;;;;;;;;;;;;;
currentMusic        ds       2                            ; ym player used 
currentYLenCount    ds       2                            ; ym player used 
nextMusic           ds       2                            ; ym player used 
currentSFX_1        ds       2                            ; sfx player used 
sfx_pointer_1       ds       2                            ; sfx player used 
sfx_status_1        ds       1                            ; sfx player used 
currentSFX_2        ds       2                            ; sfx player used 
sfx_pointer_2       ds       2                            ; sfx player used 
sfx_status_2        ds       1                            ; sfx player used 
currentSFX_3        ds       2                            ; sfx player used 
sfx_pointer_3       ds       2                            ; sfx player used 
sfx_status_3        ds       1                            ; sfx player used 
current_button_state  ds     1                            ; only bit 0 
last_button_state   ds       1                            ; only bit 0 
tmp_count           ds       1                            ; poly 
tmp_count2          ds       1                            ; 
tmp_add             ds       2                            ; poly 
tmp_angle           ds       2                            ; poly 
tmp_offset          ds       2                            ; poly 
tmp_lastpos         ds       2                            ; poly 
tmp_first_vector    ds       2 
RecalCounter        ds       0                            ; similar var to BIOS Vec_Loop_Count, this gets increased ones every cycle (but also reseted), 
                                                          ; recoded movements are synced to that counter, also some intensity effects 
RecalCounterHi      ds       1 
RecalCounterLow     ds       1 
my_random           ds       1 
my_random2          ds       1 
;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Game vars
;;;;;;;;;;;;;;;;;;;;;;;;;
X_addi              ds       1                            ; change pos by this each "change" 
X_add_delay         ds       1                            ; change pos each this "ticks" 
base_angle          ds       2                            ; current start angle of base (*2) 
sided               ds       1                            ; current count of sides for base 
shieldWidthGrowth   ds       1                            ; shield width, grows each "x" cycles by "y" (this is y) 
shieldWidthCounter  ds       1                            ; shield width, grows each "x" cycles by "y" (this is x) 
shieldWidth         ds       1                            ; shield width now 
shieldStart         ds       1                            ; outer shield position (in scale) 
innerShield         ds       1                            ; inner shield position (in scale) 
shieldSpeed         ds       1                            ; speed of the shield MOVEMENT - not the speed of growth 
noShieldGrowthVar   ds       1                            ; if shield has max size do not grow anymore! 
current_forth_dif   ds       1                            ; var for oscillating "inner" shield 
current_back_dif    ds       1                            ; var for oscillating "inner" shield 
osc_forth           ds       1                            ; var for oscillating "inner" shield 
osc_back            ds       1                            ; var for oscillating "inner" shield 
rotList             ds       8*2+3                        ; some ... space for a max 8 sided base (shield/explosion) 
spawn_reset         ds       1                            ; after x ticks a new spawn happens 
spawn_timer         ds       1                            ; current counter for those ticks 
starletCount        ds       1 
starletAngle        ds       2 
currentMaxOffset    ds       1                            ; dunno if that is correct anymore with new collision detection (TODO check - as of now this is FIXED, should be scale dependend) 
list_empty_head     ds       2                            ; if empty these contain a positive value that points to a RTS 
list_objects_head   ds       2                            ; if negative, than this is a pointer to a RAM location 
list_objects_tail   ds       2 
player_score        ds       0 
player_score_5      ds       1 
player_score_4      ds       1 
player_score_3      ds       1 
player_score_2      ds       1 
player_score_1      ds       1 
player_score_0      ds       1 
star_0_score        ds       0 
star_0_score_3      ds       1 
star_0_score_2      ds       1 
star_0_score_1      ds       1 
star_0_score_0      ds       1 
star_1_score        ds       0 
star_1_score_3      ds       1 
star_1_score_2      ds       1 
star_1_score_1      ds       1 
star_1_score_0      ds       1 
star_2_score        ds       0 
star_2_score_3      ds       1 
star_2_score_2      ds       1 
star_2_score_1      ds       1 
star_2_score_0      ds       1 
score_buf           ds       3 
star_active_flag    ds       1 
MAX_OBJECTS         =        35                           ; todo determine max possible spawns! 
; all objects are held in a linked list
; the linked list is made up by object defined in below structs
; the BASIC Object list consists of empty fileds - plus the last entry "NEXT_OBJECT"
; if NEXT_OBJECT is positive (not RAM pointer), than the list is finished
                    org      $c900 
; 20 bytes per object
                    struct   ObjectStruct 
                    ds       Y_POS,1                      ; D (1) current position 
                    ds       X_POS,1                      ; D (2) 
                    ds       CURRENT_LIST,2               ; X current list vectorlist 
                    ds       DDRA,1                       ; Y (1) 
                    ds       SCALE,1                      ; Y (2) scale to position the object 
                    ds       BEHAVIOUR,2                  ; PC 
                    ds       TYPE,1                       ; enemy type 
                    ds       ANGLE,2                      ; if angle base, angle in degree *2 
                    ds       PREVIOUS_OBJECT,2            ; positive = start of list 
                    ds       NEXT_OBJECT,2                ; positive = end of list 
                    ds       filler, 5 
                    end struct 
; all following object "inherit" from above defined Object struct
; all vars after "NEXT_OBJECT" can be different for each of the objects
;
; all definitions with the same name must be at the same structure position
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
                    ds       TICK_COUNTER,1               ; after how many rounds the movement updates (0 = each, 1 = every second etc) 
                    ds       SCALE_DELTA,1                ; with what value does the movement get updated (1-4)? 
                    ds       filler, 3 
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
                    ds       SCORE_COUNTER, 1 
                    ds       SCORE_COUNT, 1 
                    ds       I_AM_STAR_NO, 1 
                    ds       filler, 0 
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
                    ds       filler, 4 
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
                    ds       SCORE_COUNTDOWN,1 
                    ds       filler, 4 
                    end struct 
;
                    struct   ScoreXObjectStruct 
                    ds       Y_POS,1                      ; current position 
                    ds       X_POS,1 
                    ds       SCORE_POINTER_1,2            ; current list vectorlist 
                    ds       DDRA,1 
                    ds       SCALE,1                      ; scale to position the object 
                    ds       BEHAVIOUR,2 
                    ds       TYPE,1                       ; enemy type 
                    ds       ANGLE,2                      ; if angle base, angle in degree *2 
                    ds       PREVIOUS_OBJECT,2            ; positive = start of list 
                    ds       NEXT_OBJECT,2                ; positive = end of list 
                    ds       SCORE_COUNTDOWN,1 
                    DS       SCORE_POINTER_2,2 
                    DS       SCORE_POINTER_3,2 
                    ds       filler, 0 
                    end struct 
object_list         ds       ObjectStruct*MAX_OBJECTS 
; for debugging some possible watches
o_behaviour         =        object_list +BEHAVIOUR 
o_type              =        object_list+TYPE 
o_scale             =        object_list+SCALE 
o_angle             =        object_list+ANGLE 
o_pos               =        object_list+Y_POS 
o_list              =        object_list+CURRENT_LIST 
o_previous          =        object_list+PREVIOUS_OBJECT 
o_next              =        object_list+NEXT_OBJECT 
;
; Defines
;
BASE_SCALE          =        5                            ; base scale is "5" 
SHIELD_START_SCALE  =        1 
SHIELD_START_WIDTH  =        3                            ; first shield width is 5 (shield starts at 15) scale 
SHIELD_WIDTH_GROWTH_DEFAULT  =  4                         ; grow shield width every 4 round with 1 
SHIELD_DEFAULT_SPEED  =      2                            ; increase position of shield with 2 every each increase step 
SHIELD_MAX_SCALE    =        $d0 
SHIELD_VARIANCE     equ      10 
EXPLOSION_MAX       =        40                           ; max scale of explosion 
TYPE_STARLET        =        2 
TYPE_HIDDEN_X       =        3 
TYPE_X              =        1 
TYPE_EX             =        -1                           ; negative types are not destroyed by shield 
TYPE_SCORE          =        -2                           ; 
SCORE_DISPLAY_TIME  =        50 
SPAWN_MAX_SCALE     =        $c8 
STAR_SCALE          =        40                           ; radius pos of starlets 
STARLET_ANIM_DELAY  =        1 
STARLET_SCORE_DELAY  =       100                          ; at 50Hz 2 seconds 
STARLET_START_SCORE  =       2 
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
                    bra      start 

                    INCLUDE  "macro.i"                    ; vectrex function includes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
start: 
                    jsr      initGame 
                    _DP_TO_D0                             ; round_startup_main expects dp set to d0 
; reset music to 0
                    CLR      Vec_Music_Flag               ; no music is playing ->0 
                    JSR      Init_Music_Buf               ; shadow regs 
                    JSR      Do_Sound                     ; ROM function that does the sound playing 
;                    INIT_MUSICl  gameStartMusic 
main:                                                     ;#isfunction  
                    MY_WAIT_RECAL  
                    JSR      do_ym_sound2 
                    JSR      draw_Score                   ; has a nice long moveto 
; increase base angle by 1 degree
; and modulo it at 360 degrees
                    ldx      base_angle 
                    leax     2,x 
                    cmpx     #(360*2) 
                    blo      angleOk 
                    leax     -(360*2),x 
angleOk: 
                    stx      base_angle 
                    tfr      x,d 
                    NEG_D    
                    addd     #720 
                    std      starletAngle 
; query joystick buttons
; four states:
; a) was not pressed and is not pressed -> do nothing
; b) was not pressed and is NOW pressed -> init new shield
; c) was pressed and is pressed -> continue shield (grow)
; d) was pressed and is NOT pressed -> shield finished
                    jsr      getButtonState               ; is a button pressed? 
                    CMPB     #$01                         ; yes, but last time is was not pressed 
                    lbeq     newShield 
                    CMPB     #$03                         ; yes, and last time was pressed 
                    lbeq     continueShield 
                    CMPB     #$02                         ; no, but last time was pressed 
                    lbeq     finishShield 
; beq no_playerAction ; zero means no, and last was also not pressed
no_playerAction: 
                    jsr      Reset0Ref 
                    jsr      drawPlayerHome 
                    jsr      Reset0Ref 
                    bsr      check_spawn 
                    ldu      list_objects_head 
                    pulu     d,x,y,pc                     ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; new list object to U
; leaves with flags set to i contents
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; counts down spawn timer
; if 0 than spawn new
check_spawn:                                              ;#isfunction  
                    dec      spawn_timer 
                    lbne     cs_done 
; reset the timer for next spawn
                    lda      spawn_reset 
                    deca     
                    cmpa     #15 
                    bgt      nomin_cs 
                    lda      #15 
nomin_cs 
                    sta      spawn_reset 
                    sta      spawn_timer 
; calculate object position of next spawned object
; determine (random) type
; random coordinates
; scale
; todo ... somehow determine random type of object
; for starters we determined an "X" object
                    lda      my_random 

                    cmpa     #10 
                    bls      doStarlet 
                    cmpa     #50 
                    bls      spawnX 
                    cmpa     #100 
                    lbls     spawnHiddenX 
cs_done: 
                    rts      

doStarlet 
                    lda      starletCount 
                    cmpa     #3 
                    bge      cs_done 
                    jmp      spawnStarlet 

; this is actually an Object structure with a behaviour RTS    
PC_MAIN: 
                    dw       0                            ; d 
                    dw       0                            ; x 
                    dw       0                            ; y 
                    dw       #main                        ; pc 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                    INCLUDE  "objects.asm"     
                    INCLUDE  "drawSubRoutines.i"          ; vectrex function includes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; construct new shield from current player base
newShield: 
                    lda      #SHIELD_START_SCALE          ; the relevant "measure" shield is the outer shield wall 
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
                    lda      #SHIELD_START_WIDTH          ; for a new shield initialize the width to 
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
                    cmpa     #SHIELD_MAX_SCALE 
                    bls      noMax                        ; $SHIELD_MAX_SCALE is max, if carry is set, than we have an overflow to our max, 
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
                    lda      #SHIELD_MAX_SCALE            ; max the shields outer rim 
noMax: 
                    sta      shieldStart 
; and draw the complete shield 
                    jsr      drawShield 
;  jsr testShield 
                    jmp      no_playerAction 

finishShield:                                             ;#isfunction  
; check all objects if they are destroyed by shield vanishing
;..............
                    lda      shieldStart 
                    cmpa     #7 
                    bls      no_playerAction              ; no collision if shield is "in base" 
                    SET_CORRECTION_POINTER                ; load x with correct correction pointer 
                    ldu      list_objects_head 
                    beq      shield_check_done 
do_next_shield_check: 
                    jsr      onShield 
                    tsta     
                    beq      shield_not_touched           ; branch if a (shield inner wall) is higher or same than pos (scale) of object 
                    jsr      exchangeToExplosion 
shield_not_touched: 
                    ldu      NEXT_OBJECT,u 
                    bmi      do_next_shield_check 
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
maxOffsetValues: 
                    db       21,16,11,10                  ; this should be scale related, e.g. instead of 21 it should be ~ 1/5 of scale 
polygon_5_div_correction                                  ;  72 values 
                    db       NO_DIV,NO_DIV, DIV_BY32, DIV_BY12, DIV_BY12,DIV_BY11, DIV_BY10, DIV_BY8, DIV_BY8, DIV_BY7 
                    db       DIV_BY7, DIV_BY6, DIV_BY6, DIV_BY6, DIV_BY6, DIV_BY6, DIV_BY52, DIV_BY52, DIV_BY52, DIV_BY53 
                    db       DIV_BY53, DIV_BY53, DIV_BY53, DIV_BY53, DIV_BY55, DIV_BY55, DIV_BY55, DIV_BY55, DIV_BY55, DIV_BY55 
                    db       DIV_BY55, DIV_BY55, DIV_BY55, DIV_BY5, DIV_BY5, DIV_BY5, DIV_BY5, DIV_BY5, DIV_BY55, DIV_BY55 
                    db       DIV_BY55, DIV_BY55, DIV_BY55, DIV_BY55, DIV_BY55, DIV_BY55, DIV_BY55, DIV_BY53, DIV_BY53, DIV_BY53 
                    db       DIV_BY53, DIV_BY53, DIV_BY52, DIV_BY52, DIV_BY52, DIV_BY6, DIV_BY6, DIV_BY6, DIV_BY6, DIV_BY6 
                    db       DIV_BY6, DIV_BY7, DIV_BY7, DIV_BY8, DIV_BY8, DIV_BY10, DIV_BY11,DIV_BY12, DIV_BY12, DIV_BY32 
                    db       NO_DIV, NO_DIV 
polygon_6_div_correction:                                 ;  60 values 
                    db       NO_DIV, DIV_BY32, DIV_BY32, DIV_BY32, DIV_BY16, DIV_BY16, DIV_BY16, DIV_BY12, DIV_BY12, DIV_BY12 
                    db       DIV_BY10, DIV_BY10, DIV_BY10, DIV_BY10, DIV_BY8, DIV_BY8, DIV_BY7, DIV_BY7, DIV_BY6, DIV_BY6 
                    db       DIV_BY6, DIV_BY6, DIV_BY6, DIV_BY6, DIV_BY6, DIV_BY6, DIV_BY6, DIV_BY6, DIV_BY6, DIV_BY6 
                    db       DIV_BY6, DIV_BY6, DIV_BY6, DIV_BY6, DIV_BY6, DIV_BY6, DIV_BY6, DIV_BY6, DIV_BY6, DIV_BY6 
                    db       DIV_BY6, DIV_BY6, DIV_BY7, DIV_BY7, DIV_BY8, DIV_BY8, DIV_BY10, DIV_BY10, DIV_BY10, DIV_BY10 
                    db       DIV_BY12, DIV_BY12, DIV_BY12, DIV_BY16, DIV_BY16, DIV_BY16, DIV_BY32, DIV_BY32, DIV_BY32, NO_DIV 
polygon_7_div_correction:                                 ;  52 values 
                    db       NO_DIV, NO_DIV, DIV_BY32, DIV_BY32, DIV_BY32, DIV_BY16, DIV_BY16, DIV_BY12, DIV_BY12, DIV_BY12 
                    db       DIV_BY12, DIV_BY11, DIV_BY11, DIV_BY11, DIV_BY10, DIV_BY10, DIV_BY10, DIV_BY10, DIV_BY10, DIV_BY10 
                    db       DIV_BY10, DIV_BY10, DIV_BY10, DIV_BY10, DIV_BY10, DIV_BY10, DIV_BY10, DIV_BY10, DIV_BY10, DIV_BY10 
                    db       DIV_BY11, DIV_BY10, DIV_BY10, DIV_BY10, DIV_BY10, DIV_BY10, DIV_BY10, DIV_BY10, DIV_BY11, DIV_BY11 
                    db       DIV_BY12, DIV_BY12, DIV_BY12, DIV_BY12, DIV_BY12, DIV_BY16, DIV_BY16, DIV_BY32, DIV_BY32, DIV_BY32 
                    db       NO_DIV, NO_DIV 
polygon_8_div_correction:                                 ;  45 values 
                    db       NO_DIV, DIV_BY32, DIV_BY32, DIV_BY32, DIV_BY16, DIV_BY16, DIV_BY16, DIV_BY12, DIV_BY12, DIV_BY12 
                    db       DIV_BY12, DIV_BY11, DIV_BY11, DIV_BY11, DIV_BY11, DIV_BY11, DIV_BY11, DIV_BY11, DIV_BY11, DIV_BY11 
                    db       DIV_BY10, DIV_BY10, DIV_BY10, DIV_BY10, DIV_BY11, DIV_BY11, DIV_BY11, DIV_BY11, DIV_BY11, DIV_BY11 
                    db       DIV_BY11, DIV_BY11, DIV_BY11, DIV_BY12, DIV_BY12, DIV_BY12, DIV_BY12, DIV_BY12, DIV_BY16, DIV_BY16 
                    db       DIV_BY16, DIV_BY32, DIV_BY32, DIV_BY32, NO_DIV 
testShield 
                                                          ;#isfunction 
                    jsr      Reset0Ref 
                    SET_CORRECTION_POINTER                ; load x with correct correction pointer 
testCount2          =        tmp_first_vector 
                    ldd      #720 
                    std      testCount2 
nextAngle_ts 
; now a more thorough check is needed
; if the shield were a perfect circle the above should be enough
                    ldd      testCount2 
                                                          ; angle of object 
                    subd     base_angle                   ; angle diff = object angle - base angle 
                    bpl      isPositive_ts 
                    addd     #720 
isPositive_ts: 
                    MY_LSR_D                              ; half it (value now 0 - 360 ) 
                    tfr      d,y 
                    GET_POLY_DIV                          ; load polygone "divider" to d (72, 60, 52 or 45) 
                    lsrb     
                    negb     
; the following does a 
; angle % poly divider
;  (gets the angle modulo the polygon angle)
getMod_ts: 
                    leay     b,y 
                    cmpy     #0                           ; lea does not influence carry :-( 
                    bpl      getMod_ts 
                    negb     
                    leay     b,y 
; mod done
                    tfr      y,d 
                    leay     d,x 
; now in y
; is the pointer to the correction table, for circle position correction of
; our object in relation to the shield polygon
; do the above check AGAIN now with correction values present
                    ldb      shieldStart                  ; outer shield border 
                    cmpb     #$ff 
                    bhs      noadd_ts2 
                    addb     #SHIELD_VARIANCE             ; a little bit wider 
noadd_ts2: 
                    jsr      getDivi_b 
                    stb      VIA_t1_cnt_lo                ; to timer t1 (lo) 
                    ldd      testCount2 
                    pshs     y 
                    ldy      #circle 
                    ldd      d,y 
                    jsr      Moveto_d 
                    jsr      Dot_here 
                    jsr      Reset0Ref 
                    puls     y 
; outer done here
                    ldb      shieldStart                  ; outer shield border 
                    subb     shieldWidth 
                    subb     #(SHIELD_VARIANCE)           ; wider 
                    bcc      no_underflow_ts 
                    addb     #(SHIELD_VARIANCE)           ; wider 
no_underflow_ts: 
                    jsr      getDivi_b 
                    stb      VIA_t1_cnt_lo                ; to timer t1 (lo) 
                    ldd      testCount2 
                    ldy      #circle 
                    ldd      d,y 
                    jsr      Moveto_d 
                    jsr      Dot_here 
                    jsr      Reset0Ref 
                    ldd      testCount2 
                    subd     #2 
                    std      testCount2 
                    bpl      nextAngle_ts 
                    rts      

out_notTouched 
                    clra     
                    rts      

onShield:                                                 ;#isfunction  
; first look if current object and shield are completely out of bounds
                    lda      TYPE,u                       ; negative objects do not get hit by the shield 
                    bmi      out_notTouched 
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
                    clra     
                    bpl      no_minus_os 
no_minus_os: 
; todo - check if below zero                   
                    cmpa     SCALE,u                      ; compare outer border with object position 
                    bhs      out_notTouched               ; branch if a (shield inner wall) is higher or same than pos (scale) of object 
; real checking!
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
                    ldb      shieldStart                  ; outer shield border 
                    cmpb     #$ff 
                    bhs      noadd_os2 
                    addb     #SHIELD_VARIANCE             ; a little bit wider 
noadd_os2: 
                    jsr      getDivi_b 
                    cmpb     SCALE,u                      ; compare outer border with object position 
                    bls      out_notTouched               ; branch if a (shield outer wall) is lower or same than pos (scale) of object 
                    ldb      shieldStart                  ; outer shield border 
                    subb     shieldWidth 
                    subb     #(SHIELD_VARIANCE)           ; wider 
                    bcc      no_underflow_os 
                    addb     #(SHIELD_VARIANCE)           ; wider 
no_underflow_os: 
                    jsr      getDivi_b 
                    cmpb     SCALE,u                      ; compare outer border with object position 
                    bhs      out_notTouched               ; branch if a (shield inner wall) is higher or same than pos (scale) of object 
                    lda      #1 
                    rts      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
drawPlayerHome:                                           ;#isfunction  
; draw player "home"
                    JSR      Intensity_5F                 ; Sets the intensity of the 
                                                          ; vector beam to $5f 
                    lda      #BASE_SCALE 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    jsr      buildRotatedNSidedFigure 
                    ldx      #rotList+1 
;                    jsr      drawRotated 

 lda sided
 cmpa #5
 beq is_five_list
 cmpa #6
 beq is_six_list
 cmpa #7
 beq is_seven_list
is_eight_list
 ldy #(MAX_LINE_NUM-($08+1))*ONE_LINE_LENGTH 
 bra do_draw_home

is_seven_list
 ldy #(MAX_LINE_NUM-($07+1))*ONE_LINE_LENGTH 
 bra do_draw_home
is_six_list
 ldy #(MAX_LINE_NUM-($06+1))*ONE_LINE_LENGTH 
 bra do_draw_home
is_five_list
 ldy #(MAX_LINE_NUM-($05+1))*ONE_LINE_LENGTH 

do_draw_home
 jsr move_wait_draw_vlc_unloop_home

                    ldd      #$cc98 
                    sta      <VIA_cntl                    ; 22 cycles from switch on ZERO disabled, and BLANK enabled 
                    STb      <VIA_aux_cntl                ; 
                    rts      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
drawShield:                                               ;#isfunction  
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
                    bcc      shieldWidthOk 
                    cmpa     shieldStart 
                    blo      shieldWidthOk 
                    lda      shieldStart 
                    suba     #SHIELD_VARIANCE+1 
                    sta      shieldWidth 
                    lda      #SHIELD_VARIANCE+1 
; ldb shieldWidth
; cmpb #60 ; some "high" number
; ble shieldWidthOk
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
                    bcc      greaterzero_b 
                    clrb     
greaterzero_b 
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


buildRotatedNSidedFigure                                  ;#isfunction  
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
exchangeToExplosion:                                      ;#isfunction  
                    pshs     u,x 
                    lda      TYPE, u 
; check a type "starlet" was destroed 
                    cmpa     #TYPE_STARLET 
                    bne      noStar_ete 
; if so - the starlets must be cleaned up
; which one was destroyed there are actually 3 "different"
                    dec      starletCount 
                    lda      I_AM_STAR_NO,u 
                    beq      disable_star_0 
                    cmpa     #1 
                    beq      disable_star_1 
disable_star_2: 
                    lda      star_active_flag 
                    anda     #($ff-$04) 
                    sta      star_active_flag 
                    bra      was_star_ete 

disable_star_1: 
                    lda      star_active_flag 
                    anda     #($ff-$02) 
                    sta      star_active_flag 
                    bra      was_star_ete 

disable_star_0: 
                    lda      star_active_flag 
                    anda     #($ff-$01) 
                    sta      star_active_flag 
                    bra      was_star_ete 

noStar_ete: 
                    cmpa     #TYPE_HIDDEN_X 
                    beq      explode_typeHiddenX 
                    cmpa     #TYPE_X 
                    beq      explode_typeX 
explode_typeX 
                    bsr      buildscore10 
                    bra      continue_ete 

explode_typeHiddenX 
                    jsr      buildscore15 
                    bra      continue_ete 

continue_ete 
was_star_ete: 
                    PLAY_SFX  Explosion_Sound 
                    puls     x,u 
                    lda      #TYPE_EX 
                    sta      TYPE, u 
                    ldd      #explosionBehaviour 
                    std      BEHAVIOUR,u 
                    clr      EXPLOSION_SCALE,u 
                    rts      

buildscore10:                                             ;#isfunction  
; #score10
                    ADD_SCORE_10  
                    tfr      u,y 
; build new object 
                    jsr      newObject 
                    bpl      noObjectAvailable_b10 
; copy interesting things from y to u
                    lda      #TYPE_SCORE 
                    sta      TYPE, u 
                    ldd      Y_POS,y 
                    std      Y_POS,u 
                    ldd      ANGLE,y 
                    std      ANGLE,u 
                    lda      SCALE,y 
                    sta      SCALE,u 
                    ldd      #scoreBehaviour 
                    std      BEHAVIOUR,u 
                    ldd      #score10 
                    std      CURRENT_LIST,u 
                    lda      #SCORE_DISPLAY_TIME 
                    sta      SCORE_COUNTDOWN,u 
noObjectAvailable_b10: 
                    rts      

buildscore15:                                             ;#isfunction  
; #score10
                    ADD_SCORE_10  
                    tfr      u,y 
; build new object 
                    jsr      newObject 
                    bpl      noObjectAvailable_b15 
; copy interesting things from y to u
                    lda      #TYPE_SCORE 
                    sta      TYPE, u 
                    ldd      Y_POS,y 
                    std      Y_POS,u 
                    ldd      ANGLE,y 
                    std      ANGLE,u 
                    lda      SCALE,y 
                    sta      SCALE,u 
                    ldd      #scoreBehaviour 
                    std      BEHAVIOUR,u 
                    ldd      #score15 
                    std      CURRENT_LIST,u 
                    lda      #SCORE_DISPLAY_TIME 
                    sta      SCORE_COUNTDOWN,u 
noObjectAvailable_b15: 
                    rts      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
buildscoreX:                                              ;#isfunction  
                    tfr      u,y 
                    lda      I_AM_STAR_NO+u_offset1, y 
                    lsla     
                    lsla                                  ; times 4 
                    ldx      #star_0_score 
                    leax     a,x 
                    jsr      add_score_x 
; build new object 
; #score10
                    tfr      u,y 
                    jsr      newObject                    ; destroys u 
                    bpl      noObjectAvailable_bx 
; copy interesting things from y to u
                    lda      #TYPE_SCORE 
                    sta      TYPE, u 
                    ldd      Y_POS+u_offset1,y 
                    std      Y_POS,u 
                    ldd      ANGLE+u_offset1,y 
                    std      ANGLE,u 
                    lda      SCALE+u_offset1,y 
                    sta      SCALE,u 
                    lda      I_AM_STAR_NO+u_offset1, y 
                    lsla     
                    lsla                                  ; times 4 
                    ldx      #star_0_score 
                    leax     a,x 
                    ldy      #NumberList                  ; list of pointers to number vectorlists 
; in x now pointer to lowest qm score
                    lda      ,x+ 
                    lsla                                  ; times two 
                    beq      no_hundred_bx 
                    ldd      a,y 
                    bra      store_hundred_bx 

no_hundred_bx 
                    ldd      #0 
store_hundred_bx 
                    std      SCORE_POINTER_3, u 
                    lda      ,x+ 
                    lsla                                  ; times two 
                    beq      no_tens_bx 
                    ldd      a,y 
                    bra      store_tens_bx 

no_tens_bx 
                    ldd      #0 
store_tens_bx 
                    std      SCORE_POINTER_2, u 
                    lda      ,x+ 
                    lsla                                  ; times two 
                    ldd      a,y 
                    std      SCORE_POINTER_1, u 
                    ldd      #scoreXBehaviour 
                    std      BEHAVIOUR,u 
                    lda      #SCORE_DISPLAY_TIME 
                    sta      SCORE_COUNTDOWN,u 
noObjectAvailable_bx: 
                    rts      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; initialize all game vars with sensible dfault values
initGame                                                  ;#isfunction  
                    clra     
                    clrb     
                    sta      RecalCounter 
                    sta      star_active_flag 
                    std      player_score_5 
                    std      player_score_3 
                    std      player_score_1 
                    inca     
                    sta      X_add_delay                  ; update x every cycle 
                    clra     
                    inca     
                    sta      X_addi                       ; with one scale dec 
                    ldd      #8                           ; start with a 5 sided polygon 
                    stb      sided 
                    clrb                                  ; start at angle 0 
                    stb      starletCount 
                    std      base_angle 
                    std      currentSFX_3 
                    std      currentSFX_2 
                    std      currentSFX_1 
                    std      sfx_pointer_3 
                    std      sfx_pointer_2 
                    std      sfx_pointer_1 
                    sta      sfx_status_3 
                    sta      sfx_status_2 
                    sta      sfx_status_1 
                    sta      current_button_state         ; store a known current button state 
                    sta      last_button_state 
                    lda      #SHIELD_WIDTH_GROWTH_DEFAULT ; shield per default grows one scale per round 
                    sta      shieldWidthGrowth 
                    lda      #SHIELD_DEFAULT_SPEED 
                    sta      shieldSpeed 
                    lda      #50                          ; spawn timer 
                    sta      spawn_reset 
                    sta      spawn_timer 
; initialize the empty object list 
                    lda      #MAX_OBJECTS 
                    ldu      #object_list 
                    stu      list_empty_head 
                    ldy      #PC_MAIN 
next_list_entry_ig 
                    leax     ObjectStruct,u 
                    stx      NEXT_OBJECT,u 
                    sty      PREVIOUS_OBJECT,u 
                    leay     ,u 
                    leau     ,x 
                    deca     
                    bne      next_list_entry_ig 
                    ldd      #PC_MAIN 
                    std      NEXT_OBJECT,y 
                    std      list_objects_head 
                    std      list_objects_tail 
                    rts      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Button 1-4
; returns in B the current button state in relation to last button state
; bit 0 represents current button state
; bit 1 last button state
; 1 = pressed
; 0 = not pressed
getButtonState:                                           ;#isfunction  
; save last states, and shift the old current one bit
; query buttons from psg
                    lda      RecalCounterLow 
                    ldb      RecalCounterLow 
                    andb     #1 
                    beq      b2_gbs 
                    eora     my_random 
                    rola     
                    sta      my_random 
                    bra      no2_gbs 

b2_gbs 
                    eora     my_random2 
                    rola     
                    sta      my_random2 
no2_gbs 
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

; for now this is only reached when an object "hits" the base
; as // TODO
; only remove the villain
gameOver: 
                    PLAY_SFX  Gotcha_Sound 
                    bra      removeObject                 ; remove the object from game - for now, this be be a "GAME OVER" 

;***************************************************************************
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                    INCLUDE  "Data.i"                     ; vectrex function includes
                    INCLUDE  "sound.i"                    ; vectrex function includes
                    INCLUDE  "ayfxPlayer_channel3.i"
                    INCLUDE  "ayfxPlayer_channel2.i"
                    INCLUDE  "ayfxPlayer_channel1.i"
                    INCLUDE  "collisionRoutines.i"
; u must be preserved
; destroys d,y
; in x pointer to 3 digit csa score (lsb)
add_score_x                                               ;#isfunction  
                                                          ; x pointer to 3 digits in csa format 
                    ldy      #player_score_0 
                    lda      ,y 
                    adda     2,x 
                    cmpa     #9 
                    bls      no_overflow_0_asx 
                    suba     #10 
                    inc      -1,y 
no_overflow_0_asx: 
                    sta      ,y                           ; write score 0 
                    lda      ,-y 
                    adda     1,x 
                    cmpa     #9 
                    bls      no_overflow_1_asx 
                    suba     #10 
                    inc      -1,y 
no_overflow_1_asx: 
                    sta      ,y                           ; write score 1 
                    lda      ,-y 
                    adda     0,x 
                    cmpa     #9 
                    bhi      overflow_2_asx 
                    sta      ,y+                          ; write score 2 
                    rts      

overflow_2_asx 
                    suba     #10 
                    sta      ,y                           ; write score 2 
                    lda      ,-y 
                    inca     
                    cmpa     #9 
                    bhi      overflow_3_asx 
                    sta      ,y                           ; write score 3 
                    rts      

overflow_3_asx 
                    suba     #10 
                    sta      ,y                           ; write score 3 
                    lda      ,-y 
                    inca     
                    cmpa     #9 
                    bhi      overflow_4_asx 
                    sta      ,y                           ; write score 4 
                    rts      

overflow_4_asx 
                    suba     #10 
                    sta      ,y                           ; write score 4 
                    lda      ,-y 
                    inca     
                    cmpa     #9 
                    bhi      overflow_5_asx 
                    sta      ,y                           ; write score 5 
                    rts      

overflow_5_asx: 
                                                          ; no further increase - score reached max (999999, flipped to 900000) 
                    rts      

;***************************************************************************
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCORE_SIZE          =        16 
SCORE_POS_DIF       =        16 
SCORE_X_START       =        $20 
draw_Score                                                ;#isfunction  
; has a nice long moveto
                    lda      #$5f                         ; intensity 
                    _INTENSITY_A  
                    lda      #$7f 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    ldd      #$7f*256+SCORE_X_START 
                    jsr      Moveto_d 
;                    _ZERO_VECTOR_BEAM  
; lda #$7f
;                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
;                    ldd      #$7f*256+SCORE_X_START
;                    jsr      Moveto_d 
                    lda      #SCORE_SIZE 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    ldu      #NumberList 
                    lda      player_score_5 
                    lsla     
                    ldx      a,u 
                    jsr      myDraw_VL_mode2 
;                    _ZERO_VECTOR_BEAM  
;                    lda #$7f
;                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
;                    ldd      #$7f*256+SCORE_X_START+(SCORE_POS_DIF*1)
;                    jsr      Moveto_d 
;                    lda      #SCORE_SIZE
;                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    lda      player_score_4 
                    lsla     
                    ldx      a,u 
                    jsr      myDraw_VL_mode2 
;                    _ZERO_VECTOR_BEAM  
;                    lda #$7f
;                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
;                    ldd      #$7f*256+SCORE_X_START+(SCORE_POS_DIF*2)
;                    jsr      Moveto_d 
;                    lda      #SCORE_SIZE
;                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    lda      player_score_3 
                    lsla     
                    ldx      a,u 
                    jsr      myDraw_VL_mode2 
;                    _ZERO_VECTOR_BEAM  
;                    lda #$7f
;                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
;                    ldd      #$7f*256+SCORE_X_START+(SCORE_POS_DIF*3)
;                    jsr      Moveto_d 
;                    lda      #SCORE_SIZE
;                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    lda      player_score_2 
                    lsla     
                    ldx      a,u 
                    jsr      myDraw_VL_mode2 
;                    _ZERO_VECTOR_BEAM  
;                    lda #$7f
;                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
;                    ldd      #$7f*256+SCORE_X_START+(SCORE_POS_DIF*4)
;                    jsr      Moveto_d 
;                    lda      #SCORE_SIZE
;                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    lda      player_score_1 
                    lsla     
                    ldx      a,u 
                    jsr      myDraw_VL_mode2 
;                    _ZERO_VECTOR_BEAM  
;                    lda #$7f
;                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
;                    ldd      #$7f*256+SCORE_X_START+(SCORE_POS_DIF*5)
;                    jsr      Moveto_d 
;                    lda      #SCORE_SIZE
;                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    lda      player_score_0 
                    lsla     
                    ldx      a,u 
                    jsr      myDraw_VL_mode2 
                    _ZERO_VECTOR_BEAM  
                    rts      

;;;;;;;;;;;;;;;;;;;;;;
; what is a csa score
;;;;;;;;;;;;;;;;;;;;;;
; a csa score can have an arbitary count of digits
; msb first goes down to lsb
; each byte contains a decimal byte value (0-9)
; if one an "add" the resuklt is hight than 9, than the next digit is increased
; thus the number 1025 is represented in 4 bytes
; db 01, 00, 02, 05
; 
; using this format makes it very easy to translate the representing number into a drawing of
; individual number vectors
; for each digit we take the digit multiply with two and add that to a pointer to number vectorlists
;
; in fact the csa score is quite similar to BCD numbers, but use more space and are even more easy to handle
