INVINCIBLE          =        1 
;change explosion max in accordance to:
; - time left in recal
;- number of explosions currrently happening!
; RANDOM
; bonus 
; optimize
; Sounds for Spawning
; balance
; game Over
; intro
; extro
; high score?
; opti thoughts:
; remove vectorlist from puls
; we can set it in MOVE
; saves RAM
; saves 1 cycle :-) (puls)
; saves 1 cycle because we can use reg x instead of reg y for scale
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
; I use sound shadow and sound working buffer myself
                    org      $c80f                        ; 19 byte for buttons reuse 
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
                    org      $c82e                        ; 14 byte resue 
sfx_pointer_3       ds       2                            ; sfx player used 
sfx_status_3        ds       1                            ; sfx player used 
tmp_count2          ds       1                            ; 
tmp_add             ds       2                            ; poly 
tmp_angle           ds       2                            ; poly 
tmp_offset          ds       2                            ; poly 
tmp_lastpos         ds       2                            ; poly 
tmp_first_vector    ds       2 
                    org      $c84d 
rotList             ds       8*2+3                        ; some ... space for a max 8 sided base (shield/explosion) 
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
                    org      $c880 
tmp_count           ds       1                            ; poly 
RecalCounter        ds       0                            ; similar var to BIOS Vec_Loop_Count, this gets increased ones every cycle (but also reseted), 
RecalCounterHi      ds       1 
RecalCounterLow     ds       1 
current_button_state  ds     1                            ; only bit 0 
last_button_state   ds       1                            ; only bit 0 
my_random           ds       1 
my_random2          ds       1 
;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Game vars
;;;;;;;;;;;;;;;;;;;;;;;;;
phase_count         ds       1 
spawn_count         ds       2 
deadEnemies         ds       1 
spawnRest_Counter   ds       1 
spawn_increase_delay  ds     1 
spawn_reset         ds       1                            ; after x ticks a new spawn happens , test for dec -> bpl 
spawn_timer         ds       1                            ; current counter for those ticks , test for dec -> bpl 
shield_delay        ds       1                            ; change pos each this "ticks" 
shield_width_adder  ds       1 
shieldMinorIncreaseCounterReset  ds  1 
shieldMinorIncreaseCounter  ds  1                         ; 1 = every second, test for dec -> bpl 
shieldMinorIncrease  ds      1 
spawn_allowed       ds       1 
bomber_delay_start  ds       1 
Bonus_addi          ds       1                            ; change pos by this each "change" 
Bonus_add_delay     ds       1                            ; change pos each this "ticks" , test for dec -> bpl 
Dragon_add_delay    ds       1                            ; change pos each this "ticks" , test for dec -> bpl 
X_addi              ds       1                            ; change pos by this each "change" 
X_add_delay         ds       1                            ; change pos each this "ticks" , test for dec -> bpl 
Hunter_addi         ds       1                            ; change pos by this each "change" 
Hunter_add_delay    ds       1                            ; change pos each this "ticks" , test for dec -> bpl 
Bomber_addi         ds       1                            ; change pos by this each "change" 
Bomber_add_delay    ds       1                            ; change pos each this "ticks" , test for dec -> bpl 
base_angle          ds       2                            ; current start angle of base (*2) 
shot_addi           ds       1                            ; change pos by this each "change" 
shot_add_delay      ds       1                            ; change pos each this "ticks" , test for dec -> bpl 
dragonchild_addi    ds       1                            ; change pos by this each "change" 
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
next_phase_at       ds       2 
minimum_bomb_reload  ds      1 
bonusCounter        ds       2 
bonusActiveTime     ds       1                            ; in seconds! MAX 99! 
bonus_time_1        ds       1 
bonus_time_0        ds       1 
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
                    ds       filler, 5                    ; #noDoubleWarn 
                    end struct 
MAX_OBJECTS         =        35                           ; todo determine max possible spawns! 
; all objects are held in a linked list
; the linked list is made up by object defined by structs
; the BASIC Object list consists of empty fields - plus the entry "NEXT_OBJECT"
; if NEXT_OBJECT is positive (not RAM pointer), than the list is finished
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
SHIELD_START_WIDTH  =        3                            ; first shield width is 3 scale 
SHIELD_WIDTH_GROWTH_DEFAULT  =  4                         ; 2 up ; grow shield width every x ticks with speed (counter) 
SHIELD_DEFAULT_SPEED  =      2                            ; increase position of shield with 2 every each increase step 
SHIELD_MAX_SCALE    =        $d0                          ; further out gives more often the "external" glow 
SHIELD_VARIANCE     =        10                           ; for collision detection, shield to midpoint of object - 10 should reach every midpoint... 
SHIELD_MINOR_DELAY_COUNTER_DEFAULT  =  2                  ; every third 
SHIELD_MINOR_INCREASE_DEFAULT  =  0                       ; add 0 
SHIELD_DELAY_TICKS  =        7                            ; wait after each shield collaps this many ticks, befor a new shield can be initiated (otherwise shield spawning is possible) 
INITIAL_SHIELD_WIDTH_ADDER  =  1                          ; 1-4 WIDTH OF SHIELD increase (strength) 
EXPLOSION_MAX       =        40                           ; max scale of explosion 
TYPE_BONUS          =        9 
TYPE_DRAGONCHILD    =        8 
TYPE_DRAGON         =        7 
TYPE_SHOT           =        6 
TYPE_BOMBER         =        5 
TYPE_HUNTER         =        4 
TYPE_HIDDEN_X       =        3 
TYPE_STARLET        =        2 
TYPE_X              =        1 
TYPE_EX             =        -1                           ; negative types are not destroyed by shield 
TYPE_SCORE          =        -2                           ; 
TYPE_TIMER          =        -3 
SCORE_DISPLAY_TIME  =        50                           ; scores are displayed for about 1 s 
SPAWN_MAX_SCALE     =        $c8                          ; further out gives more often the "external" glow 
STAR_SCALE          =        40                           ; radius pos of starlets 
STARLET_ANIM_DELAY  =        1                            ; test for dec -> bpl 
X_ANIM_DELAY        =        2                            ; test for dec -> bpl 
STARLET_SCORE_DELAY  =       100                          ; at 50Hz 2 seconds 
STARLET_START_SCORE  =       2                            ; start bonus of star score at 2 bonus points (first displayed is 4) 
BONUS_ANIM_DELAY    =        1 
INITIAL_BONUS_MOVE_DELAY  =  3                            ; every tick 
INITIAL_BONUS_MOVE_STRENGTH  =  1                         ; move one scale pos 
INITIAL_SHOT_MOVE_DELAY  =   0                            ; every tick 
INITIAL_SHOT_MOVE_STRENGTH  =  1                          ; move one scale pos 
INITIAL_X_MOVE_DELAY  =      1                            ; every second tick 
INITIAL_X_MOVE_STRENGTH  =   1                            ; move one scale pos 
INITIAL_HUNTER_MOVE_DELAY  =  0                           ; every tick 
INITIAL_HUNTER_MOVE_STRENGTH  =  1                        ; move one scale pos 
INITIAL_BOMBER_MOVE_DELAY  =  1                           ; move two scale pos 
INITIAL_BOMBER_MOVE_STRENGTH  =  1                        ; move one scale pos 
INITIAL_BOMBER_SHOT_DELAY  =  200                         ; 4s 
BOMBER_ANIM_DELAY   =        2                            ; test for dec -> bpl 
BOMB_RELOAD_REDUCTION  =     25                           ; each bomb is shot 1/2 faster than the last, untill minum reload is reached 
DEFAULT_MINIMUM_BOMB_RELOAD_DELAY  =  50                  ; minimum reload timer for bombs (1 s) 
INITIAL_DRAGON_MOVE_DELAY  =  5                           ; every fifth tick one inward move 
DRAGON_CHILD_FREE_SPEED  =   2                            ; decrease scale with 2 every tick 
;
; with each spawn increase
; the speed of the increase slows down
INITIAL_SPAWN_INCREASE_DELAY  =  1 
INITIAL_SPAWN_RESET_TIMER  =  50                          ; each second , test for dec -> bpl 
MAXIMUM_RESET_INCREASE_SLOWDOWN  =  10 
FASTEST_SPAWN_RATE  =        15                           ; 15/50 s a spawn happens at the fastest rate 
DEFAULT_BONUS_ACTIVE_TIME  =  9                           ; 9 is max! seconds - in seconds! 
; each "phase" can allow / forbid spawns 
; 0000 0001 STAR
; 0000 0010 X
; 0000 0100 HIDDEN X
; 0000 1000 HUNTER
; 0001 0000 BOMBER
; 0010 0000 DRAGON
; 0100 0000 BONUS
ALLOW_STAR          =        $01 
ALLOW_X             =        $02 
ALLOW_HIDDEN_X      =        $04 
ALLOW_HUNTER        =        $08 
ALLOW_BOMBER        =        $10 
ALLOW_DRAGON        =        $20 
ALLOW_BONUS         =        $40 
DEFAULT_ALL_SPAWN   =        $ff 
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
                    DB       "g GCE 2017", $80 ; 'g' is copyright sign
                    DW       music1                       ; music from the rom 
                    DB       $F8, $50, $20, -$30          ; hight, width, rel y, rel x (from 0,0) 
release_string 
                    DB       "RELEASE", $80               ; some game information, ending with $80
                    DB       0                            ; end of game header 
;***************************************************************************
; CODE SECTION
;***************************************************************************
; here the cartridge program starts off
                    bra      start 

                    DB       $20, -$40                    ; hight, width, rel y, rel x (from 0,0) 
go_string 
                    DB       "GAME OVER", $80             ; some game information, ending with $80
                    INCLUDE  "macro.i"                    ; vectrex function includes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
start: 
                    jsr      initGame 
title_main 
                    jsr      Wait_Recal 
                    ldx      RecalCounter                 ; recal counter, about 21 Minutes befor roll over 
                    leax     1,x 
                    stx      RecalCounter 
                    _DP_TO_D0                             ; round_startup_main expects dp set to d0 
                    JSR      do_ym_sound2 
                    jsr      Intensity_5F 
                    ldd      #0 
                    jsr      Moveto_d 
                    ldu      #go_string 
                    ldd      -2,u 
                    jsr      Print_Str_d 
                    JSR      draw_Score                   ; has a nice long moveto 
                    tst      tmp_add 
                    beq      shsh 
                    dec      tmp_add 
                    bra      title_main 

shsh 
                    jsr      getButtonState               ; is a button pressed? 
                    bne      title_main 
title_main1 
                    jsr      Wait_Recal 
                    ldx      RecalCounter                 ; recal counter, about 21 Minutes befor roll over 
                    leax     1,x 
                    stx      RecalCounter 
                    _DP_TO_D0                             ; round_startup_main expects dp set to d0 
                    JSR      do_ym_sound2 
                    jsr      Intensity_5F 
                    ldd      #0 
                    jsr      Moveto_d 
                    ldu      #release_string 
                    ldd      -2,u 
                    jsr      Print_Str_d 
                    JSR      draw_Score                   ; has a nice long moveto 
                    jsr      getButtonState               ; is a button pressed? 
                    beq      title_main1 
game_start 
                    jsr      initGame 
                    _DP_TO_D0                             ; round_startup_main expects dp set to d0 
; reset music to 0
                    CLR      Vec_Music_Flag               ; no music is playing ->0 
                    JSR      Init_Music_Buf               ; shadow regs 
                    JSR      Do_Sound                     ; ROM function that does the sound playing 
;                    INIT_MUSICl  gameStartMusic 
main:                                                     ;#isfunction  
                    tst      shield_delay 
                    bmi      can_do_shield_m 
                    dec      shield_delay 
can_do_shield_m 
                    jsr      check_stage 
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
                    _ZERO_VECTOR_BEAM  
                    jsr      drawPlayerHome 
                    _ZERO_VECTOR_BEAM  

                    bsr      check_spawn 
                    ldu      list_objects_head 
                    pulu     d,x,y,pc                     ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this is actually an Object structure with a behaviour RTS    
PC_MAIN: 
                    dw       0                            ; d 
                    dw       0                            ; x 
                    dw       0                            ; y 
                    dw       #main                        ; pc 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; counts down spawn timer
; if 0 than spawn new
check_spawn:                                              ;#isfunction  
                    dec      spawn_timer                  ; only ever spawn if spawn _timer < 0 
; is initially "INITIAL_SPAWN_RESET_TIMER = 50"  = each second one spawn (might be "empty" spawn though)
; the spawn_timer is decreased as the game gets harder (faster spawning)
                    bpl      cs_done 
; reset the timer for next spawn
                    lda      spawn_reset                  ; in spawn reset is the timer that needs to be count down to achieve a spawn 
; in spawnRest_Counter a counter is decreased
; each time the counter reaches 0 the the "spawn_reset" (in reg a) timer is decreased, thus
; the game gets  more difficult as the game progresses
; spawnResr_Counter is initialized with INITIAL_SPAWN_INCREASE_DELAY = 1
; each countdown the spawnResr_Counter is reset with spawn_increase_delay
; spawn_increase_delay is increased each such a reset (up to a maximum)
; thus the game gets slower more difficult the longer the game lasts
                    dec      spawnRest_Counter 
                    bpl      no_resetDecrease 
                    ldb      spawn_increase_delay 
                    incb     
                    cmpb     #MAXIMUM_RESET_INCREASE_SLOWDOWN ; slowes in 
                    blo      noMax_cs 
                    ldb      #MAXIMUM_RESET_INCREASE_SLOWDOWN 
noMax_cs 
                    stb      spawn_increase_delay 
                    stb      spawnRest_Counter 
                    deca                                  ; decrease the actual SPAWN rate 
                    cmpa     #FASTEST_SPAWN_RATE          ; fastest spawn rate = 15/50 seconds delay 
                    bgt      nomin_cs 
                    lda      #FASTEST_SPAWN_RATE 
nomin_cs 
no_resetDecrease 
                    sta      spawn_reset 
                    sta      spawn_timer 
; calculate object position of next spawned object
; determine (random) type
; random coordinates
; scale
; but first determine what kind of object we spawn
; for each spawn we do we increase the spawn count
; the # of spawns determines a possible phase switch (in main)
                    ldx      spawn_count 
                    leax     1,x 
                    stx      spawn_count 
                    lda      my_random                    ; load a random number 
                    ldb      spawn_allowed                ; and our current "allowed" flags 
; lda #160 
                    cmpa     #10 
                    bls      doStarlet 
                    cmpa     #50 
                    lbls     spawnX 
                    cmpa     #90 
                    lbls     spawnHiddenX 
                    cmpa     #130 
                    lbls     spawnHunter 
                    cmpa     #150 
                    lbls     spawnBomber 
                    cmpa     #170 
                    lbls     spawnDragon 
                    cmpa     #180 
                    bhi     no_spawn_at_all 
                    ldx      bonusCounter 
                    bne      returnSpawnNotAllowed 
                    jmp      spawnBonus 
no_spawn_at_all

; if spawn was not allowed - decrease spawn count and return
returnSpawnNotAllowed: 
                    ldx      spawn_count 
                    leax     -1,x 
                    stx      spawn_count 
cs_done: 
                    rts      

doStarlet 
                    lda      starletCount                 ; check starlet count - max 3 
                    cmpa     #3 
                    bge      returnSpawnNotAllowed 
                    jmp      spawnStarlet 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                    INCLUDE  "objects.asm"     
                    INCLUDE  "drawSubRoutines.i"          ; vectrex function includes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; construct new shield from current player base
newShield:                                                ;#isfunction  
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
continueShield:                                           ;#isfunction  
                    tst      shield_delay                 ; for a certain time (shield_delay tick) no further shield can be initiated after a shield collaps 
                                                          ; that way we can prevent the player from just shield spamming and doing nothing else 
                    lbpl      no_playerAction 

can_do_shield 
                    tst      noShieldGrowthVar            ; do not grow if max width is acchieved 
                    bne      noShieldGrowth 
                    dec      shieldWidthCounter           ; growth only happens each "x" rounds (kept in shieldWidthCounter) 
                    bpl      noShieldGrowth               ; jump if that counter is not belwo zero 
                    lda      shieldWidthGrowth            ; restore current growth rate to counter 
                    sta      shieldWidthCounter 
; shieldWidth growth influences the width of the shield,
; NOT the position!
                                                          ; inc shieldWidth ; increase the width of the shield 
                    lda      shieldWidth 
                    adda     shield_width_adder 
                    sta      shieldWidth 
noShieldGrowth: 
; no the position of the shield is updated
                    lda      shieldStart 
                    adda     shieldSpeed 
; minor increase is not 
; taken into account with oscillators
; minor increase should always be lower than major increase!
; otherwise on displaying the shield
; the inner osciallator can never catch up and the shield appears to 
; be greater than it actually is!
                    dec      shieldMinorIncreaseCounter 
                    bpl      noMinorIncrease 
                    ldb      shieldMinorIncreaseCounterReset 
                    stb      shieldMinorIncreaseCounter 
                    adda     shieldMinorIncrease 
noMinorIncrease: 
                    cmpa     #SHIELD_MAX_SCALE 
                    bls      noMax_c_s                    ; $SHIELD_MAX_SCALE is max, if carry is set, than we have an overflow to our max, 
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
noMax_c_s: 
                    sta      shieldStart 
; and draw the complete shield 
                    jmp      drawShield 

finishShield:                                             ;#isfunction  
; check all objects if they are destroyed by shield vanishing
;..............
                    lda      #SHIELD_DELAY_TICKS 
                    sta      shield_delay 
                    clr      deadEnemies 
                    lda      shieldStart 
                    cmpa     #9                           ; if shield end is TO near to our base - nothing happens! 
                    lbls     no_playerAction              ; no collision if shield is "in base" 
                    SET_CORRECTION_POINTER                ; load x with correct correction pointer 
                    ldu      list_objects_head 
                    lbeq      no_playerAction 
do_next_shield_check: 
                    jsr      onShield 
                    tsta     
                    beq      shield_not_touched           ; branch if a (shield inner wall) is higher or same than pos (scale) of object 
                    jsr      exchangeToExplosion 
                    inc      deadEnemies 
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
                    lbpl     nextAngle_ts 
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
 ldb     SCALE,u                      ; compare outer border with object position 
 stb tmp_count2
                    cmpa     tmp_count2                      ; compare outer border with object position 
                    bls      out_notTouched               ; branch if a (shield outer wall) is lower or same than pos (scale) of object 
                    suba     shieldWidth 
                    suba     #(2*SHIELD_VARIANCE)         ; wider (to compensate size of object and irregulatity to circle coords) 
                    suba     currentMaxOffset 
                    clra     
                    bpl      no_minus_os 
no_minus_os: 
; todo - check if below zero                   
                    cmpa     tmp_count2                      ; compare outer border with object position 
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
 pshs u,x
 GET_DIVI_B_M
;                    jsr      getDivi_b 
                    cmpb     tmp_count2                      ; compare outer border with object position 
                    bls      out_notTouched2               ; branch if a (shield outer wall) is lower or same than pos (scale) of object 
                    ldb      shieldStart                  ; outer shield border 
                    subb     shieldWidth 
                    subb     #(SHIELD_VARIANCE)           ; wider 
                    bcc      no_underflow_os 
                    addb     #(SHIELD_VARIANCE)           ; wider 
no_underflow_os: 
 GET_DIVI_B_M
;                    jsr      getDivi_b 
                    cmpb     tmp_count2                      ; compare outer border with object position 
                    bhs      out_notTouched2               ; branch if a (shield inner wall) is higher or same than pos (scale) of object 
                    lda      #1 
 puls u,x
                    rts      
out_notTouched2 
                    clra     
 puls u,x
                    rts      



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
drawPlayerHome:                                           ;#isfunction  
; draw player "home"
;                    lda      #$5f                         ; intensity 
;                    _INTENSITY_A  
                    lda      #BASE_SCALE 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    jsr      buildRotatedNSidedFigure 
                    ldx      #rotList+1 
                    lda      sided 
                    cmpa     #5 
                    beq      is_five_list 
                    cmpa     #6 
                    beq      is_six_list 
                    cmpa     #7 
                    beq      is_seven_list 
is_eight_list 
                    ldy      #(MAX_LINE_NUM-($08+1))*ONE_LINE_LENGTH 
                    bra      do_draw_home 

is_seven_list 
                    ldy      #(MAX_LINE_NUM-($07+1))*ONE_LINE_LENGTH 
                    bra      do_draw_home 

is_six_list 
                    ldy      #(MAX_LINE_NUM-($06+1))*ONE_LINE_LENGTH 
                    bra      do_draw_home 

is_five_list 
                    ldy      #(MAX_LINE_NUM-($05+1))*ONE_LINE_LENGTH 
do_draw_home 
                    jsr      move_wait_draw_mvlc_unloop_home 
                    ldd      #$cc98 
                    sta      <VIA_cntl                    ; 22 cycles from switch on ZERO disabled, and BLANK enabled 
                    STb      <VIA_aux_cntl                ; 
                    rts      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
drawShield:                                               ;#isfunction  
; outer shield wall
;  jsr testShield 
;                    lda      #$5f                         ; intensity 
;                    _INTENSITY_A  
                    lda      shieldStart 
                    sta      VIA_t1_cnt_lo                ; to timer t1 
                    ldx      #rotList 

;                    jsr      drawRotated 
;;;;;;;;;;;;;;;;; one draw rotated start
drawRotated_i1 
                    ldd      1,x 
                    MY_MOVE_TO_D_START  
                    lda      ,x                           ; get count of vectors 
                    sta      tmp_count2 
                    leax     3,x 
; IN MOVE FROM DRAW START
; inner shield wall (calc by width)
                    lda      shieldStart 
                    suba     shieldWidth 
                    bcc      shieldWidthOk 
                    cmpa     shieldStart 
                    blo      shieldWidthOk 
                    lda      #SHIELD_VARIANCE+1 
                    ldb      shieldStart 
                    cmpb     #SHIELD_MAX_SCALE 
                    blo      shieldWidthOk 
                    lda      shieldStart 
                    suba     #SHIELD_VARIANCE+1 
                    sta      shieldWidth 
                    lda      #SHIELD_VARIANCE+1 
                    inc      noShieldGrowthVar 
shieldWidthOk: 
                    sta      innerShield 
; IN MOVE FROM DRAW END
                    MY_MOVE_TO_B_END  
next_line_dri1: 
                    LDD      ,X 
                    STA      <VIA_port_a                  ;Send Y to A/D 
                    CLR      <VIA_port_b                  ;Enable mux 
                    INC      <VIA_port_b                  ;Disable mux 
                    STB      <VIA_port_a                  ;Send X to A/D 
                    LDD      #$FF00                       ;Shift reg=$FF (solid line), T1H=0 
                    STA      <VIA_shift_reg               ;Put pattern in shift register 
                    STB      <VIA_t1_cnt_hi               ;Set T1H (scale factor?) 
                    LDD      #$0040                       ;B-reg = T1 interrupt bit 
                    LEAX     2,X                          ;Point to next coordinate pair 
wait_draw_dri1: 
                    BITB     <VIA_int_flags               ;Wait for T1 to time out 
                    BEQ      wait_draw_dri1 
                    STA      <VIA_shift_reg               ;Clear shift register (blank output) 
                    dec      tmp_count2                   ;Decrement line count 
                    BPL      next_line_dri1               ;Go back for more points 
;;;;;;;;;;;;;;;;; one draw rotated end
                    _ZERO_VECTOR_BEAM  

                    lda      innerShield 
                    sta      VIA_t1_cnt_lo                ; to timer t1 
                    ldx      #rotList 

; following lines moved out of "in move"
; since zeroing for full shield was not finished!
                    lda      ,x                           ; get count of vectors 
                    sta      tmp_count2 

;                    jsr      drawRotated 
;;;;;;;;;;;;;;;;; one draw rotated start
drawRotated_i2 
                    ldd      1,x 
                    MY_MOVE_TO_D_START  
                    leax     3,x 
; IN MOVE FROM DRAW START
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
                    cmpb     #$f0 
                    blo      nosf_1ok 
                    clrb     
nosf_1ok: 
                    stb      osc_forth 
                                                          ; does not effect carry 
draw_next_osc_forth: 
; IN MOVE FROM DRAW END
                    MY_MOVE_TO_B_END  
next_line_dri2: 
                    LDD      ,X 
                    STA      <VIA_port_a                  ;Send Y to A/D 
                    CLR      <VIA_port_b                  ;Enable mux 
                    INC      <VIA_port_b                  ;Disable mux 
                    STB      <VIA_port_a                  ;Send X to A/D 
                    LDD      #$FF00                       ;Shift reg=$FF (solid line), T1H=0 
                    STA      <VIA_shift_reg               ;Put pattern in shift register 
                    STB      <VIA_t1_cnt_hi               ;Set T1H (scale factor?) 
                    LDD      #$0040                       ;B-reg = T1 interrupt bit 
                    LEAX     2,X                          ;Point to next coordinate pair 
wait_draw_dri2: 
                    BITB     <VIA_int_flags               ;Wait for T1 to time out 
                    BEQ      wait_draw_dri2 
                    STA      <VIA_shift_reg               ;Clear shift register (blank output) 
                    dec      tmp_count2                   ;Decrement line count 
                    BPL      next_line_dri2               ;Go back for more points 
;;;;;;;;;;;;;;;;; one draw rotated end
; draw oscillators
                    _ZERO_VECTOR_BEAM  
                    ldb      osc_forth                    ; load current scale (of index) 
                    stb      VIA_t1_cnt_lo                ; to timer t1 

                    ldx      #rotList 
;                    jsr      drawRotated 
;;;;;;;;;;;;;;;;; one draw rotated start
drawRotated_i3
                    ldd      1,x 
                    MY_MOVE_TO_D_START  
                    lda      ,x                           ; get count of vectors 
                    sta      tmp_count2 
                    leax     3,x 
; IN MOVE FROM DRAW START
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
; IN MOVE FROM DRAW END
                    MY_MOVE_TO_B_END  
next_line_dri3: 
                    LDD      ,X 
                    STA      <VIA_port_a                  ;Send Y to A/D 
                    CLR      <VIA_port_b                  ;Enable mux 
                    INC      <VIA_port_b                  ;Disable mux 
                    STB      <VIA_port_a                  ;Send X to A/D 
                    LDD      #$FF00                       ;Shift reg=$FF (solid line), T1H=0 
                    STA      <VIA_shift_reg               ;Put pattern in shift register 
                    STB      <VIA_t1_cnt_hi               ;Set T1H (scale factor?) 
                    LDD      #$0040                       ;B-reg = T1 interrupt bit 
                    LEAX     2,X                          ;Point to next coordinate pair 
wait_draw_dri3: 
                    BITB     <VIA_int_flags               ;Wait for T1 to time out 
                    BEQ      wait_draw_dri3 
                    STA      <VIA_shift_reg               ;Clear shift register (blank output) 
                    dec      tmp_count2                   ;Decrement line count 
                    BPL      next_line_dri3               ;Go back for more points 
;;;;;;;;;;;;;;;;; one draw rotated end
                    _ZERO_VECTOR_BEAM  
                    ldb      osc_back 
                                                          ; load current scale (of index) 
                    stb      VIA_t1_cnt_lo                ; to timer t1 
                    ldx      #rotList 


                    jsr      drawRotated 
                    jmp      no_playerAction 

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
buildRotatedNSidedFigure                                  ;#isfunction  about 500-600 cycles
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
                    cmpa     #TYPE_DRAGON+$40 
                    bne      nofullDragon_ete 
                    anda     #%00111111 
                    sta      TYPE, u 
                    puls     x,u 
                    rts      

nofullDragon_ete: 
; check a type "bonus" was destroed 
                    cmpa     #TYPE_BONUS 
                    bne      noBonus_ete 
                    ldd      #0 
                    std      bonusCounter 
                    jmp      continue_ete                 ;bonusDestroyed_ete 

noBonus_ete: 
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
                    cmpa     #TYPE_DRAGONCHILD 
                    beq      explode_typeDragonchild 
                    cmpa     #TYPE_DRAGON 
                    beq      explode_typeDragon 
                    cmpa     #TYPE_BOMBER 
                    beq      explode_typeBomber 
                    cmpa     #TYPE_HIDDEN_X 
                    beq      explode_typeHiddenX 
                    cmpa     #TYPE_HUNTER 
                    beq      explode_typeHunter 
                    cmpa     #TYPE_X 
                    beq      explode_typeX 
explode_typeX 
                    jsr      buildscore10 
                    bra      continue_ete 

explode_typeHunter 
explode_typeHiddenX 
                    jsr      buildscore15 
                    bra      continue_ete 

explode_typeBomber 
                    jsr      buildscore18 
                    bra      continue_ete 

explode_typeDragonchild 
; freeParent
                    ldd      #0 
                    ldx      DRAGON, u 
                    beq      parentWasDead_ex 
                    cmpu     CHILD_1,x 
                    bne      notChild1_ex 
                    std      CHILD_1,x 
                    bra      parentWasDead_ex 

notChild1_ex 
                    std      CHILD_2,x 
parentWasDead_ex: 
                    jsr      buildscore10 
                    bra      continue_ete 

explode_typeDragon 
                    ldx      CHILD_1,u 
                    beq      no_child1_ex 
                    ldd      #dragonchildFreeBehaviour 
                    std      BEHAVIOUR,x 
                    ldd      #0 
                    std      DRAGON,x 
no_child1_ex 
                    ldx      CHILD_2,u 
                    beq      explodeDragonDone_ex 
                    ldd      #dragonchildFreeBehaviour 
                    std      BEHAVIOUR,x 
                    ldd      #0 
                    std      DRAGON,x 
explodeDragonDone_ex 
                    jsr      buildscore18 
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

buildShot                                                 ;#isfunction  
                    tfr      u,y 
; build new object 
                    jsr      newObject 
                    bpl      noObjectAvailable_bs 
; copy interesting things from y to u
                    lda      #TYPE_SHOT 
                    sta      TYPE, u 
                    ldd      Y_POS+u_offset1,y 
                    std      Y_POS,u 
                    ldd      ANGLE+u_offset1,y 
                    std      ANGLE,u 
                    lda      #$ff 
                    sta      DDRA,u                       ; performance dummy 
                    lda      SCALE+u_offset1,y 
                    sta      SCALE,u 
                    ldd      #shotBehaviour 
                    std      BEHAVIOUR,u 
                    ldd      #ShotList_0 
                    std      CURRENT_LIST,u 
                    lda      shot_add_delay 
                    sta      TICK_COUNTER, u 
                    lda      shot_addi 
                    sta      SCALE_DELTA, u 
noObjectAvailable_bs: 
                    rts      

buildscore15:                                             ;#isfunction  
; #score15
                    lda      deadEnemies 
                    beq      bs15_0 
                    cmpa     #1 
                    beq      bs15_1 
bs15_2: 
                    ADD_SCORE_45  
                    tfr      u,y 
; build new object 
                    jsr      newObject 
                    lbpl     noObjectAvailable_b10 
                    ldd      #score45 
                    std      CURRENT_LIST,u 
                    jmp      copy_rest_10 

bs15_1: 
                    ADD_SCORE_30  
                    tfr      u,y 
                    jsr      newObject 
                    lbpl     noObjectAvailable_b10 
                    ldd      #score30 
                    std      CURRENT_LIST,u 
                    bra      copy_rest_10 

bs15_0: 
                    ADD_SCORE_15  
                    tfr      u,y 
                    jsr      newObject 
                    bpl      noObjectAvailable_b10 
                    ldd      #score15 
                    std      CURRENT_LIST,u 
                    bra      copy_rest_10 

buildscore10:                                             ;#isfunction  
; #score10
                    lda      deadEnemies 
                    beq      bs10_0 
                    cmpa     #1 
                    beq      bs10_1 
bs10_2: 
                    ADD_SCORE_30  
                    tfr      u,y 
                    jsr      newObject 
                    bpl      noObjectAvailable_b10 
                    ldd      #score30 
                    std      CURRENT_LIST,u 
                    bra      copy_rest_10 

bs10_1: 
                    ADD_SCORE_20  
                    tfr      u,y 
                    jsr      newObject 
                    bpl      noObjectAvailable_b10 
                    ldd      #score20 
                    std      CURRENT_LIST,u 
                    bra      copy_rest_10 

bs10_0: 
                    ADD_SCORE_10  
                    tfr      u,y 
                    jsr      newObject 
                    bpl      noObjectAvailable_b10 
                    ldd      #score10 
                    std      CURRENT_LIST,u 
copy_rest_10: 
; copy interesting things from y to u
                    lda      #TYPE_SCORE 
                    sta      TYPE, u 
                    ldd      Y_POS,y 
                    std      Y_POS,u 
                    ldd      ANGLE,y 
                    std      ANGLE,u 
                    lda      #$ff 
                    sta      DDRA,u                       ; performance dummy 
                    lda      SCALE,y 
                    sta      SCALE,u 
                    ldd      #scoreBehaviour 
                    std      BEHAVIOUR,u 
                    lda      #SCORE_DISPLAY_TIME 
                    sta      SCORE_COUNTDOWN,u 
noObjectAvailable_b10: 
                    rts      

buildscore18:                                             ;#isfunction  
; #score18
                    lda      deadEnemies 
                    beq      bs18_0 
                    cmpa     #1 
                    beq      bs18_1 
bs18_2: 
                    ADD_SCORE_54  
                    tfr      u,y 
; build new object 
                    jsr      newObject 
                    bpl      noObjectAvailable_b10 
                    ldd      #score54 
                    std      CURRENT_LIST,u 
                    bra      copy_rest_10 

bs18_1: 
                    ADD_SCORE_36  
                    tfr      u,y 
                    jsr      newObject 
                    bpl      noObjectAvailable_b10 
                    ldd      #score36 
                    std      CURRENT_LIST,u 
                    bra      copy_rest_10 

bs18_0: 
                    ADD_SCORE_18  
                    tfr      u,y 
                    jsr      newObject 
                    bpl      noObjectAvailable_b10 
                    ldd      #score18 
                    std      CURRENT_LIST,u 
                    bra      copy_rest_10 

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
                    lda      #$ff 
                    sta      DDRA,u                       ; performance dummy 
                    lda      SCALE+u_offset1,y 
                    sta      SCALE,u 
                    lda      I_AM_STAR_NO+u_offset1, y 
                    lsla     
                    lsla                                  ; times 4 
                    ldx      #star_0_score 
                    leax     a,x 
                    ldy      #NumberList                  ; list of pointers to number vectorlists 
; in x now pointer to lowest csa score
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
                    std      bonusCounter 
                    sta      phase_count 
                    std      spawn_count 
                    sta      shield_delay 
                    sta      RecalCounter 
                    sta      star_active_flag 
                    std      player_score_5 
                    std      player_score_3 
                    std      player_score_1 
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
                    ldb      #8                           ; start with a 5 sided polygon 
                    stb      sided 
                    lda      #INITIAL_SPAWN_RESET_TIMER   ; spawn timer 
                    sta      spawn_reset 
                    sta      spawn_timer 
                    lda      #INITIAL_SPAWN_INCREASE_DELAY 
                    sta      spawnRest_Counter 
                    sta      spawn_increase_delay 
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
                    ldx      #phase1 
                    jsr      initPhase 
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
                    adda     RecalCounterHi 
                    adda     current_button_state 
                    eora     my_random 
                    rola     
                    sta      my_random 
                    bra      no2_gbs 

b2_gbs 
                    adda     RecalCounterHi 
                    adda     current_button_state 
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

initBonus:                                                ;#isfunction  
                    lda      bonusActiveTime 
                    ldx      #0 
                    stx      bonus_time_1                 ; clear csa counter 
addBonusTimeAgain: 
                    leax     50,x 
                    inc      bonus_time_0 
                    ldb      bonus_time_0 
                    cmpb     #10 
                    blo      noten_gbs 
                    clr      bonus_time_0 
                    inc      bonus_time_1 
noten_gbs 
                    deca     
                    bne      addBonusTimeAgain 
                    stx      bonusCounter 
; todo actually initialize bonus
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
exchangeToBonusTimer:                                     ;#isfunction  
                    leau     u_offset1,u                  ; u now again at start up structure 

                    lda      #6 
                    sta      SCALE, u 
                    tst      bonus_time_1 
                    beq      smallNumber_gbs 
                    ldd      #$e0c0                       ; y,x pos 2 number timer
                    bra      storePos_gbs 

smallNumber_gbs 
                    ldd      #$e0e0                       ; y,x pos  1 number timer
storePos_gbs 
                    std      Y_POS,u 
                    lda      #50 
                    sta      SECOND_COUNTER, u 
                    lda      #TYPE_TIMER 
                    sta      TYPE, u 
                    ldd      #timerBehaviour 
                    std      BEHAVIOUR,u 
; in case bonus is below 10 s, than init the vectorlist from here
                    ldy      #NumberList                  ; list of pointers to number vectorlists 
                    lda      bonus_time_0 
                    lsla                                  ; times two 
                    ldd      a,y 
                    std      CURRENT_LIST,u 
                    PLAY_SFX  BonusGot_Sound 
                    ldu      NEXT_OBJECT,u                ; preload next user stack 
                    pulu     d,x,y,pc                     ; (D = y,x, X = vectorlist, Y = DDRA+Scale) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; for now this is only reached when an object "hits" the base
; as // TODO
; only remove the villain
gameOver:                                                 ;#isfunction  
                    lda      #200 
                    sta      tmp_add 
                    PLAY_SFX  Gotcha_Sound 
                    if       INVINCIBLE = 1 
                    jmp      removeObject 

                    endif    
                    ldd      #0 
                    std      VIA_t1_cnt_lo                ; disable ramping 
                    _ZERO_VECTOR_BEAM  
                    jmp      title_main 

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
SCORE_X_START       =        $20-8 
draw_Score                                                ;#isfunction  
; has a nice long moveto
                    lda      #$7f 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    ldb      #SCORE_X_START 
 MY_MOVE_TO_D_START
; in between about 200 cylces spare time!
                    lda      #SCORE_SIZE 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    ldu      #NumberList 
                    lda      player_score_5 
                    lsla     
                    ldx      a,u 
                    lda      #$5f                         ; intensity 
 MY_MOVE_TO_B_END
                    _INTENSITY_A  
                    jsr      myDraw_VL_mode2 
                    lda      player_score_4 
                    lsla     
                    ldx      a,u 
                    jsr      myDraw_VL_mode2 
                    lda      player_score_3 
                    lsla     
                    ldx      a,u 
                    jsr      myDraw_VL_mode2 
                    lda      player_score_2 
                    lsla     
                    ldx      a,u 
                    jsr      myDraw_VL_mode2 
                    lda      player_score_1 
                    lsla     
                    ldx      a,u 
                    jsr      myDraw_VL_mode2 
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
; phase 1
phaseList 
                    dw       phase1 
                    dw       phase2 
                    dw       phase3 
                    dw       phase4 
                    dw       0 
phase1: 
                    db       DEFAULT_ALL_SPAWN            ; spawn types allowed 
                    db       2;SHIELD_WIDTH_GROWTH_DEFAULT  ;4 2 up , ec -> bpl than width grow 
                    db       3;SHIELD_DEFAULT_SPEED         ;2 shield major speed ; update every tick, must be in sum greater than minor increase 
                    db       SHIELD_MINOR_DELAY_COUNTER_DEFAULT ; 2 shield minor counter delay; test for dec -> bpl 
                    db       SHIELD_MINOR_INCREASE_DEFAULT ; 0 shield minor speed increase 
                    db       INITIAL_SHIELD_WIDTH_ADDER   ; 1 1-4 shield width adder 
                    db       INITIAL_SHOT_MOVE_DELAY      ;0 shot move delay ; test for dec -> bpl 
                    db       INITIAL_SHOT_MOVE_STRENGTH   ;0 shot move strength 
                    db       INITIAL_X_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_X_MOVE_STRENGTH      ;1 x move strength 
                    db       INITIAL_HUNTER_MOVE_DELAY    ;0 hunter move delay ; test for dec -> bpl 
                    db       INITIAL_HUNTER_MOVE_STRENGTH ;1 hunter move strength 
                    db       INITIAL_BOMBER_MOVE_DELAY    ;1 bomber move delay ; test for dec -> bpl 
                    db       INITIAL_BOMBER_MOVE_STRENGTH ;1 bomber move strength 
                    db       INITIAL_BOMBER_SHOT_DELAY    ; 200 bomber shot delay ; test for dec -> bpl, decreased by 25 every shot down to 50 (50 = 1 s) 
                    db       INITIAL_DRAGON_MOVE_DELAY    ;5 dragon inner move delay; test for dec -> bpl 
                    db       DRAGON_CHILD_FREE_SPEED      ;2 dragonchild (free) speed; update per tick 
                    db       DEFAULT_MINIMUM_BOMB_RELOAD_DELAY ; 50 
                    db       INITIAL_BONUS_MOVE_DELAY     ; 3 x move delay ; test for dec -> bpl 
                    db       INITIAL_BONUS_MOVE_STRENGTH  ; 1 x move strength 
                    db       DEFAULT_BONUS_ACTIVE_TIME    ; 9 in seconds 
                    dw       20                           ; next phase after 20 spawnes 
phase2: 
                    db       DEFAULT_ALL_SPAWN            ; spawn types allowed 
                    db       SHIELD_WIDTH_GROWTH_DEFAULT  ;4 2 up , ec -> bpl than width grow 
                    db       SHIELD_DEFAULT_SPEED         ;2 shield major speed ; update every tick, must be in sum greater than minor increase 
                    db       3                            ; shield minor counter delay; test for dec -> bpl 
                    db       1                            ; 0 shield minor speed increase 
                    db       INITIAL_SHIELD_WIDTH_ADDER   ; 1 1-4 shield width adder 
                    db       INITIAL_SHOT_MOVE_DELAY      ;0 shot move delay ; test for dec -> bpl 
                    db       INITIAL_SHOT_MOVE_STRENGTH   ;0 shot move strength 
                    db       INITIAL_X_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_X_MOVE_STRENGTH      ;1 x move strength 
                    db       INITIAL_HUNTER_MOVE_DELAY    ;0 hunter move delay ; test for dec -> bpl 
                    db       INITIAL_HUNTER_MOVE_STRENGTH ;1 hunter move strength 
                    db       INITIAL_BOMBER_MOVE_DELAY    ;1 bomber move delay ; test for dec -> bpl 
                    db       INITIAL_BOMBER_MOVE_STRENGTH ;1 bomber move strength 
                    db       INITIAL_BOMBER_SHOT_DELAY    ; 200 bomber shot delay ; test for dec -> bpl, decreased by 25 every shot down to 50 (50 = 1 s) 
                    db       INITIAL_DRAGON_MOVE_DELAY    ;5 dragon inner move delay; test for dec -> bpl 
                    db       DRAGON_CHILD_FREE_SPEED      ;2 dragonchild (free) speed; update per tick 
                    db       DEFAULT_MINIMUM_BOMB_RELOAD_DELAY 
                    db       INITIAL_BONUS_MOVE_DELAY     ; 3 
                    db       INITIAL_BONUS_MOVE_STRENGTH  ; 1 
                    db       DEFAULT_BONUS_ACTIVE_TIME    ; 9 
                    dw       20 
phase3: 
                    db       DEFAULT_ALL_SPAWN            ; spawn types allowed 
                    db       SHIELD_WIDTH_GROWTH_DEFAULT  ;4 2 up , ec -> bpl than width grow 
                    db       SHIELD_DEFAULT_SPEED         ;2 shield major speed ; update every tick, must be in sum greater than minor increase 
                    db       2                            ; shield minor counter delay; test for dec -> bpl 
                    db       1                            ; 0 shield minor speed increase 
                    db       INITIAL_SHIELD_WIDTH_ADDER   ; 1 1-4 shield width adder 
                    db       INITIAL_SHOT_MOVE_DELAY      ;0 shot move delay ; test for dec -> bpl 
                    db       INITIAL_SHOT_MOVE_STRENGTH   ;0 shot move strength 
                    db       INITIAL_X_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_X_MOVE_STRENGTH      ;1 x move strength 
                    db       INITIAL_HUNTER_MOVE_DELAY    ;0 hunter move delay ; test for dec -> bpl 
                    db       INITIAL_HUNTER_MOVE_STRENGTH ;1 hunter move strength 
                    db       INITIAL_BOMBER_MOVE_DELAY    ;1 bomber move delay ; test for dec -> bpl 
                    db       INITIAL_BOMBER_MOVE_STRENGTH ;1 bomber move strength 
                    db       INITIAL_BOMBER_SHOT_DELAY    ; bomber shot delay ; test for dec -> bpl, decreased by 25 every shot down to 50 (50 = 1 s) 
                    db       INITIAL_DRAGON_MOVE_DELAY    ;5 dragon inner move delay; test for dec -> bpl 
                    db       DRAGON_CHILD_FREE_SPEED      ;2 dragonchild (free) speed; update per tick 
                    db       DEFAULT_MINIMUM_BOMB_RELOAD_DELAY 
                    db       INITIAL_BONUS_MOVE_DELAY     ; 3 
                    db       INITIAL_BONUS_MOVE_STRENGTH  ; 1 
                    db       DEFAULT_BONUS_ACTIVE_TIME    ; 9 
                    dw       20 
phase4: 
                    db       DEFAULT_ALL_SPAWN            ; spawn types allowed 
                    db       3                            ;4 2 up , ec -> bpl than width grow 
                    db       3                            ;2 shield major speed ; update every tick, must be in sum greater than minor increase 
                    db       20                           ; shield minor counter delay; test for dec -> bpl 
                    db       0                            ; 0 shield minor speed increase 
                    db       2                            ;INITIAL_SHIELD_WIDTH_ADDER ; 1 1-4 shield width adder 
                    db       INITIAL_SHOT_MOVE_DELAY      ;0 shot move delay ; test for dec -> bpl 
                    db       INITIAL_SHOT_MOVE_STRENGTH   ;0 shot move strength 
                    db       INITIAL_X_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_X_MOVE_STRENGTH      ;1 x move strength 
                    db       INITIAL_HUNTER_MOVE_DELAY    ;0 hunter move delay ; test for dec -> bpl 
                    db       2                            ;INITIAL_HUNTER_MOVE_STRENGTH ;1 hunter move strength 
                    db       INITIAL_BOMBER_MOVE_DELAY    ;1 bomber move delay ; test for dec -> bpl 
                    db       INITIAL_BOMBER_MOVE_STRENGTH ;1 bomber move strength 
                    db       25                           ; INITIAL_BOMBER_SHOT_DELAY ; 200 bomber shot delay ; test for dec -> bpl, decreased by 25 every shot down to 50 (50 = 1 s) 
                    db       INITIAL_DRAGON_MOVE_DELAY    ;5 dragon inner move delay; test for dec -> bpl 
                    db       DRAGON_CHILD_FREE_SPEED      ;2 dragonchild (free) speed; update per tick 
                    db       DEFAULT_MINIMUM_BOMB_RELOAD_DELAY 
                    db       INITIAL_BONUS_MOVE_DELAY     ; 3 
                    db       INITIAL_BONUS_MOVE_STRENGTH  ; 1 
                    db       DEFAULT_BONUS_ACTIVE_TIME    ; 9 
                    dw       0 
; 0000 0001 STAR
; 0000 0010 X
; 0000 0100 HIDDEN X
; 0000 1000 HUNTER
; 0001 0000 BOMBER
; 0010 0000 DRAGON
; 0100 0000 BONUS
; THIS
; could be optimized :-)
; if I only kept the variable in RAM in the same order
; than I could just do a "moveMem"
; damn why dont I need more rom, so I actually DO optimize
initPhase 
                    lda      ,x+                          ; DEFAULT_ALL_SPAWN 
                    sta      spawn_allowed 
                    lda      ,x+                          ; SHIELD_WIDTH_GROWTH_DEFAULT 
                    sta      shieldWidthGrowth 
                    lda      ,x+                          ; SHIELD_DEFAULT_SPEED 
                    sta      shieldSpeed 
                    lda      ,x+                          ; SHIELD_MINOR_DELAY_COUNTER_DEFAULT 
                    sta      shieldMinorIncreaseCounterReset 
                    sta      shieldMinorIncreaseCounter 
                    lda      ,x+                          ; SHIELD_MINOR_INCREASE_DEFAULT 
                    sta      shieldMinorIncrease 
                    lda      ,x+                          ; INITIAL_SHIELD_WIDTH_ADDER 
                    sta      shield_width_adder 
                    lda      ,x+                          ; INITIAL_SHOT_MOVE_DELAY 
                    sta      shot_add_delay 
                    lda      ,x+                          ; INITIAL_SHOT_MOVE_STRENGTH 
                    sta      shot_addi 
                    lda      ,x+                          ; INITIAL_X_MOVE_DELAY 
                    sta      X_add_delay 
                    lda      ,x+                          ; INITIAL_X_MOVE_STRENGTH 
                    sta      X_addi 
                    lda      ,x+                          ; INITIAL_HUNTER_MOVE_DELAY 
                    sta      Hunter_add_delay 
                    lda      ,x+                          ; INITIAL_HUNTER_MOVE_STRENGTH 
                    sta      Hunter_addi 
                    lda      ,x+                          ; INITIAL_BOMBER_MOVE_DELAY 
                    sta      Bomber_add_delay 
                    lda      ,x+                          ; INITIAL_BOMBER_MOVE_STRENGTH 
                    sta      Bomber_addi 
                    lda      ,x+                          ; INITIAL_BOMBER_SHOT_DELAY 
                    sta      bomber_delay_start 
                    lda      ,x+                          ; INITIAL_DRAGON_MOVE_DELAY 
                    sta      Dragon_add_delay 
                    lda      ,x+                          ; DRAGON_CHILD_FREE_SPEED 
                    sta      dragonchild_addi 
                    lda      ,x+                          ; DEFAULT_MINIMUM_BOMB_RELOAD_DELAY 
                    sta      minimum_bomb_reload 
                    lda      ,x+                          ; INITIAL_BONUS_MOVE_DELAY 
                    sta      Bonus_add_delay 
                    lda      ,x+                          ; INITIAL_BONUS_MOVE_STRENGTH 
                    sta      Bonus_addi 
                    lda      ,x+                          ; DEFAULT_BONUS_ACTIVE_TIME 
                    sta      bonusActiveTime 
                    ldd      ,x                           ; next phase in 
                    std      next_phase_at 
                    rts      

; check whether some game factors should change
; speed increase / decrease etc
check_stage 
                    ldd      next_phase_at 
                    beq      out_cs 
                    subd     spawn_count 
                    bpl      out_cs 
                    ldd      #0 
                    std      spawn_count 
                    ldu      #phaseList 
                    lda      phase_count 
                    inca     
                    lsla     
                    ldx      a,u 
                    beq      out_cs 
                    inc      phase_count 
                    jsr      initPhase 
                    PLAY_SFX  phaseChange_Sound 
out_cs 
                    rts      
