; this file is part of Release, written by Malban in 2017
;
;                    bank     1 
INVINCIBLE          =        0 
USE_PB6             =        1 
; 
;
;***************************************************************************
; DEFINE SECTION
;***************************************************************************
;
;;;;;;;;;;;;;;;;;;;;;;
; what is a csa score - used below
;;;;;;;;;;;;;;;;;;;;;;
; a csa score can have an arbitary count of digits
; msb first goes down to lsb
; each byte contains a decimal byte value (0-9)
; if one does an add "add" the result is higher than 9, than the next digit is increased
; thus the number 1025 is represented in 4 bytes
; db 01, 00, 02, 05
; 
; using this format makes it very easy to translate the representing number into a drawing of
; individual number vectors
; for each digit we take the digit multiply with two and add that to a pointer to number vectorlists
;
; in fact the csa score is quite similar to BCD numbers, but use more space and are even more easy to handle
;
;
                    include  "inBothBanks1.i"
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
                    jmp      first_init 

;***************************************************************************
; MAGIC CARTHEADER SECTION
;      DO NOT CHANGE THIS STRUCT
;***************************************************************************
bomber_in_title 
                    db       "BOMBER",$80
bonus_in_title 
                    db       "GIFTS",$80
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this is actually an Object structure with a behaviour RTS (not rts anymore - but to a place of our definition)   
PC_MAIN_A: 
                    dw       #main                        ; pc 
PC_TITLE_A: 
                    dw       #title_main1                 ; pc 
PC_SCORE_A: 
                    dw       #display_highscore_intern    ; pc 
PC_MAIN             =        PC_MAIN_A-4 
PC_TITLE            =        PC_TITLE_A-4 
PC_SCORE            =        PC_SCORE_A-4 
; 1 byte left
                    ORG      $30 
; following the card header for VecFever support!
                    fcb      "ThGS"                       ; magic handshake marker
v4ecartversion      fdb      $0001                        ; I always have a version 
                                                          ; in comm. structs 
v4ecartflags        fdb      $28c0                        ; v4e flags: 
                                                          ; $8000 + always set by v4e 
                                                          ; $4000 - hiscore entry supported 
                                                          ; $2000 - enable cart as ram 
                                                          ; $1000 - supply default font 
                                                          ; $0800 - 1: fast menu switch supported 
                                                          ; set to 0 if hiscore entry 
                                                          ; $0700 + v4e timing bits: 
                                                          ; 0 - heuristic 
                                                          ; 1 - zero 
                                                          ; 2 - one 
                                                          ; 3 - two 
                                                          ; 4 - three 
                                                          ; $0080 - populate storage upon start 
                                                          ; $0040 - 1: extension calls used 
                                                          ; $0020 - gpios used (@7ffe) 
                                                          ; $0010 - free for future use 
                                                          ; $0008 - 1:screensaver enabled 
                                                          ; $0003 - font size 
                                                          ; 
                                                          ; first the variables for the v4e font system 
                                                          ; 
v4efontptr          fdb      0                            ; supplied by app: 
                                                          ; if != 0: the cart uses this 
                                                          ; ptr to supply a font and to 
                                                          ; optimize strings; 
v4efontwidth        fcb      0                            ; supplied by app: 
                                                          ; the cart stores a system 
                                                          ; font at v4efontptr+0x20 and 
                                                          ; adds v4efontwidth per line 
                                                          ; ..must be at least $3f 
v4efontlastchar     fcb      0                            ; supplied by cart:($5e or $7e) 
                                                          ; last char supplied by v4e 
                                                          ; (first one is always 0x20) 
v4estringlists      fdb      0                            ; if !=0 a ptr to a list of ptrs 
                                                          ; containing lists of constant 
                                                          ; strings that can be optimized 
                                                          ; for a given font (0 == end 
                                                          ; of lists) 
                                                          ; 
                                                          ; now the variables for the v4e store/load area 
                                                          ; 
v4eStorageArea      fdb      vec4SaveBuffer               ; pointer to the area - 0: unused 
v4eStorageSize      fdb      v4e_saveBlockEnd-v4e_saveBlockStart ; and its size 
v4eStorageLoaded    fdb      0                            ; set by v4e: return size for a load 
                                                          ; e.g. if set to zero in compile an != 0 
                                                          ; at the start shows whether something was 
                                                          ; loaded via 'populate storage upon start' 
v4eStorageID                                              ; storage identifier 
                                                          ; 
                    fcb      "M0VR"
                                                          ; end of v4e cart header 
                                                          ; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
hx_in_title 
                    db       "HIDDEN X",$80
dragon_in_title 
                    db       "DRAGON",$80
helper_in_title 
                    db       "HELP",$80
demo_string: 
                    db       "DEMO",$80
hunter_in_title 
                    db       "HUNTER",$80
x_in_title 
                    db       "TERRIBLE X",$80
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
defaultValuesEeprom: 
                    db       0,0,0,1,0,0,0,0              ; options 
                    db       "MAL", $10,$00, $00
                    db       "TOM", $05,$00, $00
                    db       "VTK", $03,$00, $00
                    db       "ALX", $02,$00, $00
                    db       "VEC", $01,$00, $00
                    direct   $d0 
backFromDemo_setUp 
                    clr      demo_mode 
                    jsr      clear_all_sound 
                    INIT_MUSIC  titleMusic 
                    LDD      #($ff80)                     ; scroll speed (going from right to left) 
                    STD      scroll_speed                 ; store it 
                    LDD      #(-128*256)+127              ; left boundary 
                    STD      scroll_x_left                ; store it 
                    LDD      #$60                         ; and intensity of scroll text 
                    STB      scroll_intensity             ; store it 
                    sta      currentScroller 
                    sta      use_half_stepCounter 
                    LDX      #scroller1 
                    jsr      set_up_scrolling 
; clr current_button_state
                    jsr      initTitel 
                    rts      

start_cart 
                    jsr      initGame 
title_main_go 
                    clr      demo_mode 
                    lda      #1 
                    sta      return_state                 ; in init game where should the object return to - here title = 1 
                    jsr      initGame 
backFromDemo 
                    bsr      backFromDemo_setUp 
title_main1_hs_ret 
                    jsr      initTitle2 
                    lda      #3 
                    sta      current_button_state 
                    sta      last_button_state 
title_main1 
                    lda      scrollBlink 
                    adda     scrollBlinkAdd 
                    sta      scrollBlink 
                    cmpa     #$2f 
                    bne      notToLoBlink 
                    lda      #4 
                    sta      scrollBlinkAdd 
notToLoBlink 
                    cmpa     #$7f 
                    bne      notToHiBlink 
                    lda      #-4 
                    sta      scrollBlinkAdd 
notToHiBlink 
                    jsr      PLY_PLAY                     ; the ym song only using channel 1 
                    jsr      Wait_Recal 
                    ldx      RecalCounter                 ; recal counter, about 21 Minutes befor roll over 
                    leax     1,x 
                    stx      RecalCounter 
                    _DP_TO_D0                             ; round_startup_main expects dp set to d0 
                    JSR      do_ym_sound2_no_sfx          ; copies all ym shadow registers that did change to the psg chip 
                    jsr      Intensity_5F 
                    ldd      print_angle                  ; agle of the first letter "R" of release - the BASE angle 
                    addd     angle_speed                  ; change it in accordance to the current speed of "change" 
                    bpl      no_anglecircle_overflow      ; ensure not higher lower 0 
                    addd     #720 
no_anglecircle_overflow: 
                    cmpd     #720                         ; or higher 720 
                    blt      no_anglecircle_overflow2 
                    subd     #720 
no_anglecircle_overflow2: 
                    std      print_angle 
                    ldd      print_angle_2                ; angle2 is the "rythm" of the letters expanding and shrinking in releation to their position to the "R" 
                    addd     #6 
                    cmpd     #720 
                    blt      no_anglecircle_overflow2_2 
                    subd     #720 
no_anglecircle_overflow2_2: 
                    std      print_angle_2 
                    jsr      do_one_scroll_step           ; 13000 cycles 
                    jsr      do_one_title_round           ; this prints the little messages in the mittle of the release circle 
                    _ZERO_VECTOR_BEAM  
                    tst      scrollReset                  ; if scrolltext has run its course - do one demo start 
                    beq      normalRound 
                    inc      currentScroller 
                    lda      currentScroller 
                    sta      use_half_stepCounter 
                    cmpa     #1 
                    beq      startScroll2 
                    cmpa     #2 
                    beq      startScroll3 
                    cmpa     #3 
                    beq      startScroll4 
                    bra      start_a_demo_ft 

startScroll2 
                    LDA      #-2                          ; scroll speed (going from right to left) 
                    STA      scroll_speed                 ; store it 
                    LDX      #scroller2 
                    bra      cont_scroll_init 

startScroll3 
                    LDA      #-3                          ; scroll speed (going from right to left) 
                    STA      scroll_speed                 ; store it 
                    LDX      #scroller3 
                    bra      cont_scroll_init 

startScroll4 
                    LDA      #-4                          ; scroll speed (going from right to left) 
                    STA      scroll_speed                 ; store it 
                    LDX      #scroller4 
                    bra      cont_scroll_init 

cont_scroll_init 
                    ldd      #(-128*256)+127 
                    std      scroll_x_left 
                    LDD      #$8060                       ; y position of scroller 
                    STA      scroll_y                     ; store it 
                    STB      scroll_intensity             ; store it 
                    jsr      set_up_scrolling 
                    bra      normalRound 

start_a_demo_ft 
                    ldd      #1*256+250 
                    sta      demo_mode 
                    stb      demoWaitShieldToActivate 
                    clr      demoWaitShieldToDeActivate 
                    bra      game_start 

normalRound: 
                    jsr      getButtonState               ; is a button pressed? 
                    bne      check_buttons                ; title_main1 
do_normal_after_all 
                    ldd      #emptyStreamInMove 
                    std      inMovePointer 
                    ldu      list_objects_head 
                    pulu     d,x,pc                       ; (D = y,x, X = vectorlist) ; do all objects (the circling letters and the starfield) 
check_buttons 
                    cmpb     #3                           ; same aslast state 
                    beq      do_normal_after_all 
                    cmpb     #2                           ; as released - possibly from highscore return 
                    beq      do_normal_after_all 
                    bita     #$02 
                    lbeq     display_highscore 
                    bita     #$04 
                    lbeq     display_options 
                    bita     #$08 
                    bne      game_start                   ; no -> than jump to game start 
                    lda      v4ecartflags                 ; check if there is any v4e at all? 
                    lbmi     goback                       ; if vec4 present - go back to vec4 menu 
game_start 
                    clr      return_state                 ; return 0 is IN GAME (for objects) 
                    jsr      initGame 
                    _DP_TO_D0                             ; round_startup_main expects dp set to d0 
; reset music to 0
                    CLR      Vec_Music_Flag               ; no music is playing ->0 
                    JSR      Init_Music_Buf               ; shadow regs 
                    JSR      Do_Sound                     ; ROM function that does the sound playing, here used to clear all regs 
                    INIT_MUSIC_1CH  inGameMusic 
main:                                                     ;#isfunction  
                    jsr      decode_1ChannelRest          ; decode the possible rest of un decoded YM stuff (if there are not enought objetcs with move vectors) 
                    tst      shield_delay                 ; shields are not allowed directly after the other, otherwise the plaer could spawn shields like mad directly around his base 
                    bmi      can_do_shield_m 
                    dec      shield_delay 
can_do_shield_m 
                    jsr      check_stage                  ; check if another stage is reached - if so initialize it 
                    MY_WAIT_RECAL  
                    JSR      do_ym_sound2 
                                                          ; init in move pointer 
                                                          ; todo for 1channel player 
                    ldd      #emptyStreamInMove 
                    tst      musicOption 
                    bne      playMusic_NOk_m 
                    ldd      #PLY_PLAY_1CHANNEL_PART1 
playMusic_NOk_m 
                    std      inMovePointer 
                    JSR      draw_Score_game              ; has a nice long moveto 
                    JSR      drawBonus                    ; if there is a bonus active draw the icon 
; increase base angle by 1 degree
; and modulo it at 360 degrees
                    ldx      base_angle                   ; slight rotation of the base 
                    leax     2,x 
                    cmpx     #(360*2) 
                    blo      angleOk 
                    leax     -(360*2),x 
angleOk: 
                    stx      base_angle 
                    tfr      x,d 
                    NEG_D    
                    addd     #720 
                    std      starletAngle                 ; starlets rotate opposite... 
; query joystick buttons
; four states:
; a) was not pressed and is not pressed -> do nothing
; b) was not pressed and is NOW pressed -> init new shield
; c) was pressed and is pressed -> continue shield (grow)
; d) was pressed and is NOT pressed -> shield finished
                    jsr      getButtonState               ; is a button pressed? 
                    tst      demo_mode 
                    beq      no_demo_m1 
                    tstb     
                    beq      no_demo_m1_button 
                    clr      demo_mode 
returnFromDemoInGame 
                    lda      #1 
                    sta      return_state                 ; returning to title - restore "DEMO" return for objects 
                    jsr      initGame 
                    lda      #1 
                    sta      current_button_state         ; save a known button state, that way the game does not start immedialtly upon exiting the demo 
                    jmp      backFromDemo 

no_demo_m1_button 
                    lda      spawn_count+1                ; automatical demo return, if there are many spawn objects 
                    cmpa     #MAX_OBJECTS-2 
                    blt      no_demo_m1_testshield 
                    jsr      backFromDemo_setUp 
                    jmp      display_highscore            ;returnFromDemoInGame 

no_demo_m1_testshield 
; do random shield activation during demo
                    tst      demoWaitShieldToActivate 
                    beq      shieldIsActiveDemo 
                    dec      demoWaitShieldToActivate 
                    bne      no_shield 
                    ldb      #1 
; reload shield to deactive waiter
                    lda      my_random2 
                    anda     #%00011111 
                    inca     
                    sta      demoWaitShieldToDeActivate 
                    bra      no_demo_m1 

no_shield 
                    clrb     
                    bra      no_demo_m1 

shieldIsActiveDemo 
                    dec      demoWaitShieldToDeActivate 
                    bne      shieldActiveDemo 
; reload shield to activate waiter
                    lda      my_random2 
                    anda     #%00011111 
                    inca     
                    sta      demoWaitShieldToActivate 
                    ldb      #2 
                    bra      no_demo_m1 

shieldActiveDemo 
                    ldb      #3 
                    bra      no_demo_m1 

; now check the button for above mentioned states
no_demo_m1 
                    CMPB     #$01                         ; yes, but last time is was not pressed 
                    lbeq     newShield 
                    CMPB     #$03                         ; yes, and last time was pressed 
                    lbeq     continueShield 
                    CMPB     #$02                         ; no, but last time was pressed 
                    lbeq     finishShield 
; beq no_playerAction ; zero means no, and last was also not pressed
no_playerAction:                                          ;        returning here when shield stuff is finished 
                    _ZERO_VECTOR_BEAM  
                    jsr      drawPlayerHome               ; draws the "base" 
                    tst      timerObject+BEHAVIOUR 
                    beq      noTimer_now 
                    jsr      [timerObject+BEHAVIOUR]      ; timer or gimmik 
noTimer_now 
                    jsr      check_spawn 
                    ldu      list_objects_head 
                    pulu     d,x,pc                       ; (D = y,x, X = vectorlist) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; following entries are reached from check spawn
; in check span we also check the current speed
; and initialize/deinitialize objects according to the analysis
; less than 10000 cycles to spare
speedAlert_10000 
                    tst      shieldActive                 ; if shield is active than 10000 is normal - do nothing 
                    bne      speed_loaded 
                    tst      explosionActiveCounter       ; if explosions are active - don't bother about 10000 
                    bne      speed_loaded 
                    lda      #8                           ; two starfields less than max... 
                    sta      starfield_max 
                    ldd      #(INITIAL_EXPLOSION_MAX*256) + INITIAL_SCORE_DISPLAY_TIME 
                    bra      speed_loaded 

; less than 5000 cycles to spare
speedAlert_5000 
                    lda      #3                           ; only 3 starfields 
                    sta      starfield_max 
;                    ldd      #((INITIAL_EXPLOSION_MAX/2)*256) + (INITIAL_SCORE_DISPLAY_TIME/2) ; explosion scale and score time somehat reduced 
                    ldd      #((INITIAL_EXPLOSION_MAX)*256) + (INITIAL_SCORE_DISPLAY_TIME/2) ; explosion scale and score time somehat reduced 
                    bra      speed_loaded 

; less than 1000 cycles to spare
speedAlert_1000 
                    lda      #1                           ; only one starfield 
                    sta      starfield_max 
;                    ldd      #((INITIAL_EXPLOSION_MAX/4)*256) + (INITIAL_SCORE_DISPLAY_TIME/4) ; explosion scale and score time greatly reduced 
                    ldd      #((INITIAL_EXPLOSION_MAX)*256) + (INITIAL_SCORE_DISPLAY_TIME/4) ; explosion scale and score time greatly reduced 
                    bra      speed_loaded 

; this round we did no spawn
; thus we have some time to do a 50Hz analysis 
no_spawn_now: 
; $3a = about 15000 cycles 
; $27 = about 10000 cycles
; $13 = about 5000 cycles
; $3 = about 1000 cycles
                    lda      t2_rest 
                    cmpa     #$4 
                    ble      speedAlert_1000 
                    cmpa     #$13 
                    ble      speedAlert_5000 
                    cmpa     #$23 
                    ble      speedAlert_10000 
; reset to max if more than 10000 left
                    lda      #INITIAL_STARFIELD_MAX 
                    sta      starfield_max 
                    ldd      #(INITIAL_EXPLOSION_MAX*256) + INITIAL_SCORE_DISPLAY_TIME 
speed_loaded 
                    sta      explosionMax 
                    stb      score_display_time 
; above we checked for speed - no lets
; check for object count
                    lda      #MAX_OBJECTS                 ; max num of objects 
                    suba     object_count                 ; reduced b current objects 
                    adda     starfield_max 
                    suba     #BUFFER_OBJECT_COUNT         ; so many objects besides the starfield should be available 
                    cmpa     #10                          ; 
                    bgt      no_starfield_change 
                    tsta     
                    bmi      at_least_one 
                    beq      at_least_one 
                    bra      starfieldMaxStore 

at_least_one 
                    lda      #1 
starfieldMaxStore 
                    sta      starfield_max 
; now check the number of starfields displayed, spawn or destroy accordingly (one at a time)
no_starfield_change: 
                    lda      starFieldCounter 
                    cmpa     starfield_max 
                    lblo     spawnStarfield 
                    bhi      despawnStarfield 
                    rts      

; go thru all objects
; look if there is a "fresh" starfield - destory fresh starfields (that are internaly not initialzed yet)
; first - so switching on and of is not so "visible" to the player
despawnStarfield 
                    ldu      list_objects_head 
                    bpl      no_starfield_found 
; seek round 1
seek_starfield_next 
                    lda      TYPE,u 
                    cmpa     #TYPE_STARFIELD              ; seek new starfields 
                    bne      nextObject_test 
                    lda      <IS_NEW_STARFIELD,u 
                    beq      removeStarfield 
nextObject_test 
                    ldu      NEXT_OBJECT,u 
                    bmi      seek_starfield_next 
no_starfield_found: 
                    ldu      list_objects_head 
                    bpl      no_starfield_found_1 
; if non was found - destroy the first found - all are seemingly initialized...
seek_starfield_next_1 
                    lda      TYPE,u 
                    cmpa     #TYPE_STARFIELD              ; seek any starfield 
                    beq      removeStarfield 
                    ldu      NEXT_OBJECT,u 
                    bmi      seek_starfield_next_1 
no_starfield_found_1: 
                    rts      

removeStarfield: 
                    dec      starFieldCounter 
                    jmp      removeObject_rts 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; counts down spawn timer
; if 0 than spawn new
check_spawn:                                              ;#isfunction  
;t2_rest ds 1
;noTimerCheck ds 1 ; if one no timer adjustment!
;explosionMax ds 1
;object_count ds 1 ; how many objects are alive?
;starFieldCounter ds 1
                    dec      spawn_timer                  ; only ever spawn if spawn _timer < 0 
; is initially "INITIAL_SPAWN_RESET_TIMER = 50"  = each second one spawn (might be "empty" spawn though)
; the spawn_timer is decreased as the game gets harder (faster spawning)
                    bpl      no_spawn_now 
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
                    cmpb     max_spawn_increase_delay     ; slowes in 
                    blo      noMax_cs 
                    ldb      max_spawn_increase_delay 
noMax_cs 
                    stb      spawn_increase_delay 
                    stb      spawnRest_Counter 
                    deca                                  ; decrease the actual SPAWN rate 
                    cmpa     min_spawn_reset              ; fastest spawn rate = 15/50 seconds delay 
                    bgt      nomin_cs 
                    lda      min_spawn_reset 
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
noCount_cs1: 
                    lda      my_random                    ; load a random number 
                    ldb      spawn_allowed                ; and our current "allowed" flags 
                    cmpb     #ALLOW_SQUAD                 ; if ONLY squad - than do squad directly 
                    beq      spawnSquad 
                    cmpa     #15 
                    lbls     doStarlet 
                    cmpa     #80 
                    lbls     spawnX 
                    cmpa     #130 
                    lbls     spawnHiddenX 
                    cmpa     #170 
                    lbls     spawnHunter 
                    cmpa     #200 
                    lbls     spawnBomber 
                    cmpa     #230 
                    lbls     spawnDragon 
                    cmpa     #240 
                    bls      spawnSquad 
                    cmpa     #252 
                    bhi      no_spawn_at_all 
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

CORRECT_SQUAD       macro    
                    ldu      2,s 
                    ldy      ANGLE,u                      ; store current angle of object 
                    leay     120,y 
                    cmpy     #720 
                    blt      not_oob_squad_1\? 
                    leay     -720,y 
not_oob_squad_1\?: 
                    sty      ANGLE,x                      ; store current angle of object 
                    ldd      #circle 
                    leau     d,y                          ; u pointer to spwan angle coordinates 
                    ldd      ,u 
                    sta      Y_POS,x                      ; save start pos 
                    stb      X_POS,x                      ; save start pos 
                    stx      2,s 
                    endm     
;
CORRECT_HUNTER_ANGLE  macro  
                    tfr      y,d 
                    MY_LSR_D  
                    MY_LSR_D  
                    MY_LSR_D  
                    MY_LSR_D  
                    andb     #$fe 
                    ldu      #HunterList 
                    ldu      b,u 
                    stu      CURRENT_LIST,x 
                    endm     
; dont worry about cycles when squad
; we have time enough, otherwise it wouldn't be a squad...
correctSquad 
                    bpl      sbs_done_cs 
                    CORRECT_SQUAD  
                    rts      

sbs_done_cs 
                    puls     x,d,pc                       ; just one more pull 
correctHunterAngle 
                    CORRECT_HUNTER_ANGLE  
                    rts      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
spawnSquad 
                    lda      demo_mode 
                    bne      squadallowed 
                    lda      object_count 
                    cmpa     #25                          ; squad appears only if less than 25 object are visible 
                    bhi      no_spawn_at_all 
                    lda      t2_rest 
                    cmpa     #$20                         ; suqad only appears if more than 10000 cycle to spare 
                    ble      no_spawn_at_all 
                    bitb     #ALLOW_SQUAD 
                    bne      squadallowed 
                    clr      spawn_timer                  ; check spawn next round again 
                    bra      no_spawn_at_all 

; no "timer" checking in squad wave...
squadallowed: 
                    lda      my_random2                   ; load a random number 
                    cmpa     #50 
                    lbls     spawnHunterSquad 
                    cmpa     #100 
                    bls      spawnHiddenXSquad 
                    cmpa     #150 
                    bls      spawnXSquad 
                    cmpa     #200 
                    bls      spawnBomberSquad 
                                                          ; cmpa #250 
                                                          ; lbls spawnDragonSquad 
                    bra      no_spawn_at_all 

spawnBomberSquad 
                    ldx      spawn_count 
                    leax     5,x 
                    stx      spawn_count 
; spawn 6
                    jsr      spb_allowed 
                    pshs     x 
                    bpl      sbs_done 
                    jsr      spb_allowed 
                    jsr      correctSquad                 ;CORRECT_SQUAD 
                    jsr      spb_allowed 
                    jsr      correctSquad                 ;CORRECT_SQUAD 
                    jsr      spb_allowed 
                    jsr      correctSquad                 ;CORRECT_SQUAD 
                    jsr      spb_allowed 
                    jsr      correctSquad                 ;CORRECT_SQUAD 
                    jsr      spb_allowed 
                    jsr      correctSquad                 ;CORRECT_SQUAD 
sbs_done 
                    puls     d,pc 
spawnXSquad 
                    ldx      spawn_count 
                    leax     5,x 
                    stx      spawn_count 
; spawn 6
                    jsr      spx_allowed 
                    pshs     x 
                    bpl      sxs_done 
                    jsr      spx_allowed 
                    jsr      correctSquad                 ;CORRECT_SQUAD 
                    jsr      spx_allowed 
                    jsr      correctSquad                 ;CORRECT_SQUAD 
                    jsr      spx_allowed 
                    jsr      correctSquad                 ;CORRECT_SQUAD 
                    jsr      spx_allowed 
                    jsr      correctSquad                 ;CORRECT_SQUAD 
                    jsr      spx_allowed 
                    jsr      correctSquad                 ;CORRECT_SQUAD 
sxs_done 
                    puls     d,pc 
spawnHiddenXSquad 
                    ldx      spawn_count 
                    leax     5,x 
                    stx      spawn_count 
; spawn 6
                    jsr      sphx_allowed 
                    pshs     x 
                    bpl      shxs_done 
                    jsr      sphx_allowed 
                    jsr      correctSquad                 ;CORRECT_SQUAD 
                    jsr      sphx_allowed 
                    jsr      correctSquad                 ;CORRECT_SQUAD 
                    jsr      sphx_allowed 
                    jsr      correctSquad                 ;CORRECT_SQUAD 
                    jsr      sphx_allowed 
                    jsr      correctSquad                 ;CORRECT_SQUAD 
                    jsr      sphx_allowed 
                    jsr      correctSquad                 ;CORRECT_SQUAD 
shxs_done 
                    puls     d,pc 
spawnHunterSquad 
                    ldx      spawn_count 
                    leax     5,x 
                    stx      spawn_count 
; spawn 6
                    jsr      sph_allowed 
                    pshs     x 
                    bpl      sph_done 
                    jsr      sph_allowed 
                    jsr      correctSquad 
                    jsr      correctHunterAngle           ; CORRECT_HUNTER_ANGLE 
                    jsr      sph_allowed 
                    jsr      correctSquad 
                    jsr      correctHunterAngle           ; CORRECT_HUNTER_ANGLE 
                    jsr      sph_allowed 
                    jsr      correctSquad 
                    jsr      correctHunterAngle           ; CORRECT_HUNTER_ANGLE 
                    jsr      sph_allowed 
                    jsr      correctSquad 
                    jsr      correctHunterAngle           ; CORRECT_HUNTER_ANGLE 
                    jsr      sph_allowed 
                    jsr      correctSquad 
                    jsr      correctHunterAngle           ; CORRECT_HUNTER_ANGLE 
sph_done 
                    puls     d,pc 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
doStarlet 
                    lda      starletCount                 ; check starlet count - max 3 
                    cmpa     #3 
                    lbge     returnSpawnNotAllowed 
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
                    lbpl     no_playerAction 
can_do_shield 
                    lda      #1 
                    sta      shieldActive 
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
                    cmpa     shield_max 
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
                    lda      shield_max                   ; max the shields outer rim 
noMax_c_s: 
                    sta      shieldStart 
; insure width is not to big!
                    cmpa     shieldWidth 
                    bhi      widthOk_sc 
                    deca     
                    sta      shieldWidth 
widthOk_sc 
; and draw the complete shield 
                    jmp      drawShield 

finishShield:                                             ;#isfunction  
; check all objects if they are destroyed by shield vanishing
;..............
                    inc      noTimerCheck                 ; when shield explodes do no auto timer adjustment! 
                    lda      #SHIELD_DELAY_TICKS 
                    sta      shield_delay 
                    clr      shieldActive 
                    clr      deadEnemies 
                    lda      shieldStart 
                    cmpa     #9                           ; if shield end is TO near to our base - nothing happens! 
                    lbls     no_playerAction              ; no collision if shield is "in base" 
                    SET_CORRECTION_POINTER                ; load x with correct correction pointer 
                    ldu      list_objects_head 
                    lbpl     no_playerAction 
do_next_shield_check: 
                    jsr      onShield 
                    tsta     
                    beq      shield_not_touched           ; branch if a (shield inner wall) is higher or same than pos (scale) of object 
                    ldd      NEXT_OBJECT,u 
                    std      tmp_lastpos 
                    jsr      exchangeToExplosion 
                                                          ; ldd NEXT_OBJECT,u 
                                                          ; bmi do_next_shield_check 
                                                          ; jmp no_playerAction 
shield_not_touched: 
                    ldu      NEXT_OBJECT,u 
backfromExplosionRemove 
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
out_notTouched 
                    clra     
                    rts      

onShield:                                                 ;#isfunction  
; first look if current object and shield are completely out of bounds
                    lda      TYPE,u                       ; negative objects do not get hit by the shield 
                    cmpa     #TYPE_BOUNDARY 
                    bhi      out_notTouched 
                    lda      shieldStart                  ; outer shield border 
                    cmpa     #$ff 
                    bhs      noadd_os1 
                    adda     #SHIELD_VARIANCE             ; a little bit wider 
noadd_os1: 
                    ldb      SCALE,u                      ; compare outer border with object position 
                    stb      tmp_count2 
                    cmpa     tmp_count2                   ; compare outer border with object position 
                    bls      out_notTouched               ; branch if a (shield outer wall) is lower or same than pos (scale) of object 
                    suba     shieldWidth 
                    suba     #(2*SHIELD_VARIANCE)         ; wider (to compensate size of object and irregulatity to circle coords) 
                    suba     currentMaxOffset 
                    clra     
                    bpl      no_minus_os 
no_minus_os: 
; todo - check if below zero                   
                    cmpa     tmp_count2                   ; compare outer border with object position 
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
                    pshs     u,x 
                    GET_DIVI_B_M  
                    cmpb     tmp_count2                   ; compare outer border with object position 
                    bls      out_notTouched2              ; branch if a (shield outer wall) is lower or same than pos (scale) of object 
                    ldb      shieldStart                  ; outer shield border 
                    subb     shieldWidth 
                    subb     #(SHIELD_VARIANCE)           ; wider 
                    bcc      no_underflow_os 
                    addb     #(SHIELD_VARIANCE)           ; wider 
no_underflow_os: 
                    GET_DIVI_B_M  
                    cmpb     tmp_count2                   ; compare outer border with object position 
                    bhs      out_notTouched2              ; branch if a (shield inner wall) is higher or same than pos (scale) of object 
                    lda      #1 
                    puls     u,x 
                    rts      

out_notTouched2 
                    clra     
                    puls     u,x 
                    rts      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
drawPlayerHome                                            ;#isfunction  
; draw player "home"
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
                    leay     >(unloop_start_addressSub+LENGTH_OF_HEADER),y ; 
                    leau     -4,s                         ; prepare for a simulated pulu d,x,pc 
                    leas     2,s 
                    jmp      entry_optimized_draw_mvlc_unloop 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
drawShield:                                               ;#isfunction  
; outer shield wall
                    lda      shieldStart 
                    sta      VIA_t1_cnt_lo                ; to timer t1 
;                    jsr      drawRotated 
;;;;;;;;;;;;;;;;; one draw rotated start
drawRotated_i1 
                    ldx      #rotList 
                    ldd      1,x 
                    MY_MOVE_TO_D_START  
                    lda      ,x                           ; get count of vectors 
                    sta      tmp_count2 
                    leax     3,x 
; IN MOVE FROM DRAW START
; inner shield wall (calc by width)
                    lda      shieldStart 
                    suba     shieldWidth 
                    ldb      shieldStart 
                    cmpb     shield_max 
                    blo      noInnerChange 
                    cmpa     #9 
                    bhi      noInnerChange 
                    lda      #10 
                    sta      innerShield 
                    lda      shieldStart 
                    suba     #10 
                    sta      shieldWidth 
noInnerChange 
                    sta      innerShield 
a 
; IN MOVE FROM DRAW END
                    clra     
                    MY_MOVE_TO_B_END  
next_line_dri1: 
                    STA      <VIA_shift_reg               ;Clear shift register (blank output) 
                    LDD      ,X 
                    STA      <VIA_port_a                  ;Send Y to A/D 
                    CLR      <VIA_port_b                  ;Enable mux 
                    INC      <VIA_port_b                  ;Disable mux 
                    STB      <VIA_port_a                  ;Send X to A/D 
                    LDD      #$00FF                       ;Shift reg=$FF (solid line), T1H=0 
                    STB      <VIA_shift_reg               ;Put pattern in shift register 
                    STA      <VIA_t1_cnt_hi               ;Set T1H (scale factor?) 
                    LDB      #$40                         ;B-reg = T1 interrupt bit 
                    LEAX     2,X                          ;Point to next coordinate pair 
wait_draw_dri1: 
                    BITB     <VIA_int_flags               ;Wait for T1 to time out 
                    BEQ      wait_draw_dri1 
                    dec      tmp_count2                   ;Decrement line count 
                    BPL      next_line_dri1               ;Go back for more points 
                    STA      <VIA_shift_reg               ;Clear shift register (blank output) 
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
; ldb innerShield
; cmpb #1
; beq no_innerShield
                    clra     
                    MY_MOVE_TO_B_END  
next_line_dri2: 
                    STA      <VIA_shift_reg               ;Clear shift register (blank output) 
                    LDD      ,X 
                    STA      <VIA_port_a                  ;Send Y to A/D 
                    CLR      <VIA_port_b                  ;Enable mux 
                    INC      <VIA_port_b                  ;Disable mux 
                    STB      <VIA_port_a                  ;Send X to A/D 
                    LDD      #$00FF                       ;Shift reg=$FF (solid line), T1H=0 
                    STB      <VIA_shift_reg               ;Put pattern in shift register 
                    STA      <VIA_t1_cnt_hi               ;Set T1H (scale factor?) 
                    LDB      #$40                         ;B-reg = T1 interrupt bit 
                    LEAX     2,X                          ;Point to next coordinate pair 
wait_draw_dri2: 
                    BITB     <VIA_int_flags               ;Wait for T1 to time out 
                    BEQ      wait_draw_dri2 
                    dec      tmp_count2                   ;Decrement line count 
                    BPL      next_line_dri2               ;Go back for more points 
;;;;;;;;;;;;;;;;; one draw rotated end
; draw oscillators
                    STA      <VIA_shift_reg               ;Clear shift register (blank output) 
no_innerShield 
                    _ZERO_VECTOR_BEAM  
                    ldb      osc_forth                    ; load current scale (of index) 
                    stb      VIA_t1_cnt_lo                ; to timer t1 
                    ldx      #rotList 
; following lines moved out of "in move"
; since zeroing for full shield was not finished!
                    lda      ,x                           ; get count of vectors 
                    sta      tmp_count2 
;                    jsr      drawRotated 
;;;;;;;;;;;;;;;;; one draw rotated start
drawRotated_i3 
                    ldd      1,x 
                    MY_MOVE_TO_D_START  
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
                    clra     
                    MY_MOVE_TO_B_END  
next_line_dri3: 
                    STA      <VIA_shift_reg               ;Clear shift register (blank output) 
                    LDD      ,X 
                    STA      <VIA_port_a                  ;Send Y to A/D 
                    CLR      <VIA_port_b                  ;Enable mux 
                    INC      <VIA_port_b                  ;Disable mux 
                    STB      <VIA_port_a                  ;Send X to A/D 
                    LDD      #$00FF                       ;Shift reg=$FF (solid line), T1H=0 
                    STB      <VIA_shift_reg               ;Put pattern in shift register 
                    STA      <VIA_t1_cnt_hi               ;Set T1H (scale factor?) 
                    LDB      #$40                         ;B-reg = T1 interrupt bit 
                    LEAX     2,X                          ;Point to next coordinate pair 
wait_draw_dri3: 
                    BITB     <VIA_int_flags               ;Wait for T1 to time out 
                    BEQ      wait_draw_dri3 
                    dec      tmp_count2                   ;Decrement line count 
                    BPL      next_line_dri3               ;Go back for more points 
;;;;;;;;;;;;;;;;; one draw rotated end
                    STA      <VIA_shift_reg               ;Clear shift register (blank output) 
                    _ZERO_VECTOR_BEAM  
                    ldb      osc_back 
                                                          ; load current scale (of index) 
                    stb      VIA_t1_cnt_lo                ; to timer t1 
                    ldx      #rotList 
                    ldd      1,x 
                    MY_MOVE_TO_D_START  
                    lda      ,x                           ; get count of vectors 
                    sta      tmp_count2 
                    leax     3,x 
                    MY_MOVE_TO_B_END  
next_line_dr_ds4: 
                    LDD      ,X 
                    STA      <VIA_port_a                  ;Send Y to A/D 
                    CLR      <VIA_port_b                  ;Enable mux 
                    INC      <VIA_port_b                  ;Disable mux 
                    STB      <VIA_port_a                  ;Send X to A/D 
                    LDD      #$00FF                       ;Shift reg=$FF (solid line), T1H=0 
                    STB      <VIA_shift_reg               ;Put pattern in shift register 
                    STA      <VIA_t1_cnt_hi               ;Set T1H (scale factor?) 
                    LDB      #$40                         ;B-reg = T1 interrupt bit 
                    LEAX     2,X                          ;Point to next coordinate pair 
wait_draw_dr_ds4: 
                    BITB     <VIA_int_flags               ;Wait for T1 to time out 
                    BEQ      wait_draw_dr_ds4 
                    STA      <VIA_shift_reg               ;Clear shift register (blank output) 
                    dec      tmp_count2                   ;Decrement line count 
                    BPL      next_line_dr_ds4             ;Go back for more points 
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
; expects U register to point to
; self and the next_object to be still relevant
;
; in general this function is "to death with you - scum"
exchangeToExplosion:                                      ;#isfunction  
                    pshs     u,x 
                    ldd      BEHAVIOUR, u 
                    cmpd     #dragonBehaviour_full        ; check if we hit a "full life" dragon 
                    bne      nofullDragon_ete 
                    ldd      #dragonBehaviour_half 
                    std      BEHAVIOUR, u 
                    ldd      #DragonFirstHit_Sound        ; do a first hit sound 
                    jsr      play_sfx 
                    puls     x,u 
                    rts                                   ; and go out 

nofullDragon_ete: 
; check a type "bonus" was destroyed 
                    cmpa     #TYPE_BONUS 
                    bne      noBonus_ete 
                    ldd      #0                           ; if bonus was destroyed, set the counter to 0, if it is != 0 than no bonus can spawn 
                    std      bonusCounter                 ; the counter is also a flag whether a new bonus can spawn 
                    inc      bonusDestroyedCounter 
                    ldx      #csa_buf 
                    ldd      #$0500 
                    std      ,x 
                    sta      2,x 
                    lda      bonusDestroyedCounter 
                    sta      tmp_count 
add_again_bonus5 
                    jsr      add_score_x 
                    dec      tmp_count 
                    bne      add_again_bonus5 
                    lda      bonusDestroyedCounter 
testagainBonus 
                    cmpa     #20 
                    blo      doit_boe 
                    suba     #15 
                    bra      testagainBonus 

doit_boe 
                    cmpa     #5 
                    lbeq     initPacman 
                    cmpa     #10 
                    lbeq     initWorm 
                    cmpa     #15 
                    lbeq     initGhost 
                    ldd      #Explosion_Sound             ; 
                    jsr      play_sfx 
                    puls     x,u 
                    lda      #6                           ; explosopn type bonus 
                    jmp      entry_otherexplosion_type 

                                                          ; jmp continue_ete ;bonusDestroyed_ete 
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
                    jmp      was_star_ete 

disable_star_1: 
                    lda      star_active_flag 
                    anda     #($ff-$02) 
                    sta      star_active_flag 
                    jmp      was_star_ete 

disable_star_0: 
                    lda      star_active_flag 
                    anda     #($ff-$01) 
                    sta      star_active_flag 
                    jmp      was_star_ete 

; each enemy has potentialy a "different" explosion type
; that was never realized, but each enemy has different scores
; so - there - we can still habe different explode subs :-)
noStar_ete: 
                    cmpa     #TYPE_DRAGONCHILD 
                    lbeq     explode_typeDragonchild 
                    cmpa     #TYPE_DRAGON 
                    beq      explode_typeDragon 
                    cmpa     #TYPE_BOMBER 
                    beq      explode_typeBomber 
                    cmpa     #TYPE_HIDDEN_X 
                    lbeq     explode_typeHiddenX 
                    cmpa     #TYPE_HUNTER 
                    beq      explode_typeHunter 
                    cmpa     #TYPE_X 
                    beq      explode_typeX 
                    cmpa     #TYPE_SHOT 
                    beq      explode_typeShot 
                    jsr      buildscore10 
                    jmp      continue_ete 

explode_typeShot 
                    jsr      buildscore10 
                    ldd      #Explosion_Sound             ; 
                    jsr      play_sfx 
                    puls     x,u 
                    lda      #$7f 
                    sta      EXPLOSION_INTENSITY, u 
                    lda      #4                           ; explosion type shot 
                    sta      EXPLOSION_DATA,u 
                    jmp      entry_otherexplosion_type 

explode_typeX 
                    jsr      buildscore10 
                    ldd      #Explosion_Sound             ; 
                    jsr      play_sfx 
                    puls     x,u 
                    lda      #0                           ; explosion type X 
                    sta      EXPLOSION_DATA,u 
                    bra      entry_otherexplosion_type 

explode_typeBomber 
                    jsr      buildscore18 
                    ldd      #Explosion_Sound             ; 
                    jsr      play_sfx 
                    puls     x,u 
                    lda      #1                           ; explosopn type bomber 
                    bra      entry_otherexplosion_type 

; if a dragon is destroyed - he must tell its children
explode_typeDragon 
                    ldx      CHILD_1,u 
                    beq      no_child1_ex                 ; 0 means child is dead already - jump 
                    ldd      #dragonchildFreeBehaviour 
                    std      BEHAVIOUR,x 
                    ldd      #0 
                    std      DRAGON,x 
no_child1_ex 
                    ldx      CHILD_2,u                    ; ame for second child 
                    beq      explodeDragonDone_ex 
                    ldd      #dragonchildFreeBehaviour 
                    std      BEHAVIOUR,x 
                    ldd      #0 
                    std      DRAGON,x 
explodeDragonDone_ex 
                    jsr      buildscore18 
                    ldd      #Explosion_Sound             ; 
                    jsr      play_sfx 
                    puls     x,u 
                    lda      #2                           ; explosopn type dragon 
                    bra      entry_otherexplosion_type 

explode_typeHunter 
                    bsr      buildscore15 
                    ldd      #Explosion_Sound             ; 
                    jsr      play_sfx 
                    puls     x,u 
                    lda      #3                           ; explosopn type hunter 
                    bra      entry_otherexplosion_type 

explode_typeHiddenX 
                    bsr      buildscore15 
                    ldd      #Explosion_Sound             ; 
                    jsr      play_sfx 
                    bra      continue_ete 

; dragon children must tell their parent that they were destroyed (pointer to 0)
explode_typeDragonchild 
; freeParent
                    ldd      #0 
                    ldx      DRAGON, u 
                    beq      parentWasDead_ex             ; if parent is already 0 - han we don't tell anyone we are dead - we just ARE 
                    cmpu     CHILD_1,x                    ; check - am I child 1 
                    bne      notChild1_ex                 ; if not jump - I am obviously child 2 :-) 
                    std      CHILD_1,x 
                    bra      parentWasDead_ex 

notChild1_ex 
                    std      CHILD_2,x 
parentWasDead_ex: 
                    jsr      buildscore10 
                    bra      continue_ete 

continue_ete 
                    inc      deadEnemies                  ; remember how many enemies died, we use thhis for score multiplication (up to 3 times) 
; now start the actual explosion
                    ldd      #Explosion_Sound             ; 
                    jsr      play_sfx 
                    puls     x,u 
                    lda      #$ff 
entry_otherexplosion_type 
                    inc      deadEnemies                  ; remember how many enemies died, we use thhis for score multiplication (up to 3 times) 
entry_otherexplosion_type_star 
                    ldy      #explosionBehaviour 
                    sty      BEHAVIOUR,u 
                    sta      EXPLOSION_TYPE,u 
; check how many objects are left
; if not many objects left - check how many explosions are active
; if the first is low and the second hi
; we do not show more explosions - saving some objects
; to display scores instead of explosions
                    lda      object_count 
                    cmpa     #MAX_OBJECTS -3              ; object count high? 
                    blo      explosion_is_ok 
                    lda      explosionActiveCounter 
                    cmpa     #4                           ; explosions high? 
                    blo      explosion_is_ok 
                    pshs     x 
                    jsr      removeObject_rts             ; no we remove the explosins befor its starts - and save space for scores 
                    puls     x 
                    leas     2,s 
                    cmpu     #0 
                    jmp      backfromExplosionRemove      ; go back to the shield "check" 

was_star_ete: 
                    ldd      #Explosion_Sound             ; 
                    jsr      play_sfx 
                    puls     x,u 
                    lda      #5                           ; explosion star type 
                    bra      entry_otherexplosion_type_star 

; explosion is really defenitly ok now
; so exchange the object with an explosion object
; reuse of the object that just got killed
explosion_is_ok 
                    clr      EXPLOSION_SCALE,u 
                    inc      explosionActiveCounter 
                    rts      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; scores are built in respect to their names
; it is taken into account the count of enemies destroyed by the shield
; the score gets multiplied by 1, 2 or 3 accordingly (not more tho)
; score vectorlists of dead ships are explicit vectorlists
; in opposite to the scores generated by the starlets
buildscore15:                                             ;#isfunction  
; #score15
                    lda      deadEnemies 
                    beq      bs15_0 
                    cmpa     #1 
                    beq      bs15_1 
bs15_2: 
                    ADD_SCORE_45  
                    ldd      #score45 
                    pshs     d 
                    bra      copy_rest_10 

bs15_1: 
                    ADD_SCORE_30  
                    ldd      #score30 
                    pshs     d 
                    bra      copy_rest_10 

bs15_0: 
                    ADD_SCORE_15  
                    ldd      #score15 
                    pshs     d 
                    bra      copy_rest_10 

buildscore10:                                             ;#isfunction  
; #score10
                    lda      deadEnemies 
                    beq      bs10_0 
                    cmpa     #1 
                    beq      bs10_1 
bs10_2: 
                    ADD_SCORE_30  
                    ldd      #score30 
                    pshs     d 
                    bra      copy_rest_10 

bs10_1: 
                    ADD_SCORE_20  
                    ldd      #score20 
                    pshs     d 
                    bra      copy_rest_10 

bs10_0: 
                    ADD_SCORE_10  
                    ldd      #score10 
                    pshs     d 
copy_rest_10: 
                    tfr      u,y 
                    jsr      newObject 
                    bpl      noObjectAvailable_b10_2 
                    ldd      ,s++ 
                    std      CURRENT_LIST,u 
; copy interesting things from y to u
                    lda      Y_POS,y 
                    sta      Y_POS,u 
                    ldb      X_POS,y 
                    stb      X_POS,u 
                    ldd      ANGLE,y 
                    std      ANGLE,u 
                    lda      SCALE,y 
                    sta      SCALE,u 
                    ldd      #scoreBehaviour 
                    std      BEHAVIOUR,u 
                    clr      SCORE_COUNTDOWN,u 
noObjectAvailable_b10: 
                    rts      

noObjectAvailable_b10_2: 
                    leas     2,s 
                    rts      

buildscore18:                                             ;#isfunction  
; #score18
                    lda      deadEnemies 
                    beq      bs18_0 
                    cmpa     #1 
                    beq      bs18_1 
bs18_2: 
                    ADD_SCORE_54  
                    ldd      #score54 
                    pshs     d 
                    bra      copy_rest_10 

bs18_1: 
                    ADD_SCORE_36  
                    ldd      #score36 
                    pshs     d 
                    bra      copy_rest_10 

bs18_0: 
                    ADD_SCORE_18  
                    ldd      #score18 
                    pshs     d 
                    bra      copy_rest_10 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; score x builds the score from the starlets
; this scores are represented by the digits which are displayed
; seperately, the csa scores are used to build those vectorlists
; each starlet has its own (csa) score RAM
MY_SCORE_TO_X       macro    
                    lda      I_AM_STAR_NO+u_offset1, y 
                    lsla     
                    lsla                                  ; times 4 
                    ldx      #star_0_score                ; add the csa score starting RAM address 
                    leax     a,x                          ; and put the sum to x 
                    endm     
buildscoreX:                                              ;#isfunction  
                    tfr      u,y 
; first calculate the csa score position for this star
; check which star is "active"
; for easier math the csa score occupies 4 digits instead of the needed 3
;
; the vectorlists (0 skips a digit) to the three digits are determined below and stored in the
; scoreX object structure for direct access
; during the object behaviour
                    MY_SCORE_TO_X  
                    jsr      add_score_x                  ; and add the (csa) score that is referenced from X to the players score 
; build new object 
                    tfr      u,y 
                    jsr      newObject                    ; destroys u 
                    bpl      noObjectAvailable_bx 
; copy interesting things from y to u
                    lda      Y_POS+u_offset1,y 
                    sta      Y_POS,u 
                    ldb      X_POS+u_offset1,y 
                    stb      X_POS,u 
                    ldd      ANGLE+u_offset1,y 
                    std      ANGLE,u 
                    lda      SCALE+u_offset1,y 
                    sta      SCALE,u 
                    MY_SCORE_TO_X  
                    ldy      #NumberList                  ; list of pointers to number vectorlists 
; in x now pointer to lowest csa score
                    lda      ,x+                          ; get current csa score digit 
                    lsla                                  ; times two, since vectorlist pointer is WORD not BYTE 
                    beq      no_hundred_bx                ; if its a zero skip it (leading zero of 3 digits is always skipped) 
                    ldd      a,y                          ; get the digit vectorlist 
                    bra      store_hundred_bx 

no_hundred_bx 
                    ldd      #0                           ; skipping means 0 
store_hundred_bx 
                    std      SCORE_POINTER_3, u           ; and store as vectorlist of 3rd digit 
                    lda      ,x+                          ; get current csa score digit 
                    lsla                                  ; times two, since vectorlist pointer is WORD not BYTE 
; draw 0 tens when a hundred is drawn!
                    bne      draw_tens_bx                 ; if != 0 than draw defenitly 
                    tst      -2,x                         ; if 0 we test if the 3rd digits was also 3, in that case we have two leading zeros - only one digit must be displayed 
                    beq      no_tens_bx                   ; if zero - than jump 
draw_tens_bx 
                    ldd      a,y                          ; get the digit vectorlist 
                    bra      store_tens_bx 

no_tens_bx 
                    ldd      #0                           ; skipping means 0 
store_tens_bx 
                    std      SCORE_POINTER_2, u           ; and store as vectorlist of 2rd digit 
                    lda      ,x+                          ; get current csa score digit 
                    lsla                                  ; times two, since vectorlist pointer is WORD not BYTE 
                    ldd      a,y                          ; lowest digit is always displayed - no further testing 
                    std      SCORE_POINTER_1, u           ; and store as vectorlist of 1st digit 
                    ldd      #scoreXBehaviour 
                    std      BEHAVIOUR,u 
                    clr      SCORE_COUNTDOWN,u            ; countdown set to zero - if countdown reaches "max" than the score stops being displayed 
noObjectAvailable_bx: 
                    rts      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; initialize all game vars with sensible dfault values
; this can probably be optimized... no further comments tho
initGame                                                  ;#isfunction  
                    ldd      #0 
                    sta      phase_count 
                    sta      star_swirl 
                    sta      currentScroller 
                    sta      starFieldCounter 
                    std      nextMusic 
                    sta      object_count 
                    std      bonusCounter 
                    sta      explosionActiveCounter 
                    std      spawn_count 
                    sta      shield_delay 
                    sta      RecalCounter 
                    sta      star_active_flag 
                    std      player_score_5 
                    std      player_score_3 
                    std      player_score_1 
                    std      timerObject+BEHAVIOUR 
                    stb      starletCount 
                    std      base_angle 
                    std      currentSFX_3 
                    std      currentSFX_2 
                    std      currentSFX_1 
                    std      sfx_pointer_3 
                    std      sfx_pointer_2 
                    std      sfx_pointer_1 
                    sta      sfx_status_3 
                    std      sfx_status_1 
                    sta      bonusDestroyedCounter 
                    sta      current_button_state         ; store a known current button state 
                    sta      last_button_state 
                    sta      bonusActiveType 
                    inca     
                    sta      bonusIconMoveScale 
                    ldd      #$0408 
                    sta      scrollBlinkAdd 
                    stb      sided 
                    ldb      #SPAWN_MAX_SCALE_INIT 
                    stb      spawn_max 
                    ldb      #SHIELD_MAX_SCALE_INIT 
                    stb      shield_max 
                    lda      #INITIAL_EXPLOSION_MAX 
                    sta      explosionMax 
                    lda      #INITIAL_SCORE_DISPLAY_TIME 
                    sta      score_display_time 
                    lda      #FASTEST_SPAWN_RATE 
                    sta      min_spawn_reset 
                    lda      #MAXIMUM_RESET_INCREASE_SLOWDOWN 
                    sta      max_spawn_increase_delay 
                    lda      #INITIAL_STARFIELD_MAX 
                    sta      starfield_max 
                    ldd      #$145f 
                    sta      demo_blink_Counter 
                    stb      scrollBlink 
                    stb      scrollIntensity 
                    stb      demo_Intensity 
                    ldd      #emptyStreamInMove 
                    std      inMovePointer 
                    lda      #INITIAL_SPAWN_RESET_TIMER   ; spawn timer 
                    sta      spawn_reset 
                    sta      spawn_timer 
                    lda      #INITIAL_SPAWN_INCREASE_DELAY 
                    sta      spawnRest_Counter 
                    sta      spawn_increase_delay 
                    sta      spawn_increase_delay 
; initialize the empty object list 
; depending on what "phase" we initialize for (title, score or game) - the return address of our
; object list is set
                    ldd      #phaseList 
seekPhase 
                    cmpd     initialPhase 
                    beq      phaseFound_i 
                    addd     #2 
                    inc      phase_count 
                    bra      seekPhase 

phaseFound_i 
                    ldu      initialPhase 
                    ldu      ,u 
                    jsr      initPhase 
init_objects 
                    lda      #MAX_OBJECTS 
init_objects_a 
                    ldu      #object_list 
                    stu      list_empty_head 
                    ldy      #PC_MAIN                     ; one less? 
                    ldb      return_state 
                    beq      is_game 
                    ldy      #PC_TITLE                    ; one less? 
                    cmpb     #1 
                    beq      is_title 
                    ldy      #PC_SCORE                    ; one less? 
is_title 
is_game: 
next_list_entry_ig 
                    leax     ObjectStruct,u 
                    stx      NEXT_OBJECT,u 
                    leau     ,x 
                    deca     
                    bne      next_list_entry_ig 
                    sty      NEXT_OBJECT,u 
                    sty      list_objects_head 
                    sty      list_objects_tail 
emptyStreamInMove 
                    rts      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Button 1-4
; returns in B the current button state in relation to last button state
; bit 0 represents current button state
; bit 1 last button state
; 1 = pressed
; 0 = not pressed
; in a state of current button 1-4
; bit == 0 = pressed
; bit == 1 = not pressed
; a = xxxx 0000
;          4321 - buttons
getButtonState:                                           ;#isfunction  
; save last states, and shift the old current one bit
; query buttons from psg
; do an own "Random"
; some stupd calcs... 
; everything is faster than "jsr random"
                    lda      RecalCounterLow              ; counter that gets increased every "round" in wait recal 
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
; random done
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
                    anda     #$f                          ; only joystick 1 
                    cmpa     #$0f 
                    beq      noButtonPressed 
                    incb     
noButtonPressed: 
                    stb      current_button_state 
                    andb     #3 
                    rts      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
initBonus:                                                ;#isfunction  
                    lda      bonusActiveTime              ; bonus time of current level (phase) 
                    clr      bonusDestroyedCounter 
                    ldx      #0 
                    stx      bonus_time_1                 ; clear csa counter (which is displayed via vectorlist digits) 
; loop thru all "seconds"
; the counter will be active
; to set the round counter correctly
; and the csa "score" digits of the timer that is displayed in the middle of our home
addBonusTimeAgain: 
                    leax     50,x                         ; 50 = 1 second - this will be the "round" tick countdown 
                    inc      bonus_time_0                 ; this is the actual "seconds" csa counter (see above), lower digit 
                    ldb      bonus_time_0 
                    cmpb     #10                          ; if digit rollover 
                    blo      noten_gbs 
                    clr      bonus_time_0                 ; on rollover - set to 0 
                    inc      bonus_time_1                 ; increase 2nd digit of seconds counter (csa) 
noten_gbs 
                    deca     
                    bne      addBonusTimeAgain            ; loop 
                    stx      bonusCounter                 ; actual round "ticks" collected 50 * seconds 
; actually initialize bonus, first what bonus to chose?
; random number 0-4; numbers represent the actual bonus, 0 is shield - shield is twice as often as other bonus
                    lda      my_random2 
                    anda     #3 
                    inca     
                    cmpa     #4 
                    bne      no4B 
                    lda      #BONUS_TYPE_SHIELD 
no4B 
                    sta      bonusActiveType 
                    cmpa     #BONUS_TYPE_FASTER 
                    beq      activeFaster 
                    cmpa     #BONUS_TYPE_EXPAND 
                    beq      activeExpand 
                    cmpa     #BONUS_TYPE_SHIELD 
                    beq      activeShield 
; below tweak according to bonus the
; paremeters of shield generation (or "blocking")
activeShield: 
                    ldb      #1 
                    stb      bonusIconMoveScale 
                    ldd      #BonusShieldList 
                    std      bonusIconList 
                    bra      exchangeToBonusTimer 

activeFaster 
                    lsl      shieldSpeed                  ; more with each adder 
                                                          ; we also enlargen the width adder, otherwise the width would (alltogether) be smaller 
                    lsl      shield_width_adder           ; more with each adder 
; 2,x db       SHIELD_DEFAULT_SPEED ;2 shield major speed ; update every tick, must be in sum greater than minor increase 
                    ldb      #1 
                    stb      bonusIconMoveScale 
                    ldd      #BonusFasterList 
                    std      bonusIconList 
                    bra      exchangeToBonusTimer 

activeExpand 
;1,x shieldWidthGrowth SHIELD_WIDTH_GROWTH_DEFAULT  =  4                         ; 2 up ; grow shield width every x ticks with speed (counter) 
;5,x shield_width_adder INITIAL_SHIELD_WIDTH_ADDER  =  1                          ; 1-4 WIDTH OF SHIELD increase (strength) 
;                    lsr      shieldWidthGrowth            ; faster width change 
;                    lsl      shield_width_adder           ; more with each adder 
                    lda      #1 
                    sta      shieldWidthGrowth 
                    ldb      shieldSpeed 
                    stb      shield_width_adder           ; more with each adder 
                                                          ;ldb #1 
                    sta      bonusIconMoveScale 
                    ldd      #BonusExpandList 
                    std      bonusIconList 
                    bra      exchangeToBonusTimer 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; exchanges the "?" that was coming our way - to the actual "timer" object displayed inside our base
exchangeToBonusTimer:                                     ;#isfunction  
                    ldx      #timerObject 
                    lda      #6 
                    sta      SCALE, x 
                    tst      bonus_time_1 
                    beq      smallNumber_gbs 
                    ldd      #$e0b0                       ; y,x pos 2 number timer 
                    bra      storePos_gbs 

smallNumber_gbs 
                    ldd      #$e0e0                       ; y,x pos 1 number timer 
storePos_gbs 
                    sta      Y_POS,x 
                    stb      X_POS,x 
                    lda      #50 
                    sta      SECOND_COUNTER, x 
                    ldd      #timerBehaviour 
                    std      BEHAVIOUR,x 
; in case bonus is below 10 s, than init the vectorlist from here
                    ldy      #NumberList                  ; list of pointers to number vectorlists 
                    lda      bonus_time_0 
                    lsla                                  ; times two 
                    ldd      a,y 
                    std      CURRENT_LIST,x 
                    ldd      #BonusGot_Sound 
                    jsr      play_sfx 
                                                          ; ldu u_offset1+NEXT_OBJECT,u ; preload next user stack 
                    jmp      removeObject 

initPacman 
                    ldy      #PacmanSmall_0               ; list of pointers to number vectorlists 
                    lda      #1                           ; 1 = PACMAN 
                    ldu      #$2bf3 
                    bra      cont_i 

initWorm 
                    ldy      #WormSmall_0                 ; list of pointers to number vectorlists 
                    lda      #2                           ; 2 = WORM 
                    ldu      #$00c0 
                    bra      cont_i 

initGhost 
                    ldy      #GhostSmall_0                ; list of pointers to number vectorlists 
                    lda      #3                           ; 3 = GHOST 
                    ldu      #$e028 
cont_i 
                    ldx      #timerObject 
                    sta      1+SECOND_COUNTER,x           ; type of bonus 
                    lda      #3                           ; anim countdown 
                    sta      2+SECOND_COUNTER,x           ; 
                    sty      CURRENT_LIST+timerObject 
                    lda      #6 
                    sta      SCALE, x 
                    tfr      u,d 
; ldd      #$e0e0                       ; y,x pos 1 number timer 
                    sta      Y_POS,x 
                    stb      X_POS,x 
                    ldd      #gimmikBehaviour 
                    std      BEHAVIOUR,x 
                    lda      #$ff 
                    sta      SECOND_COUNTER, x 
                    jmp      continue_ete 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; for now this is only reached when an object "hits" the base
gameOver:                                                 ;#isfunction  
                    lda      bonusActiveType              ; is there an active shield? 
                    cmpa     #BONUS_TYPE_SHIELD 
                    beq      not_gameOver                 ; if so jump to not game over 
                    tst      demo_mode                    ; are we actually in "demo" mode? 
                    beq      no_demo_go                   ; if so we are also not dead 
                    jmp      removeObject                 ; we just remove the object - and carry on 

no_demo_go 
                    if       INVINCIBLE = 1               ; same if invincible 
                    jmp      removeObject 

                    endif    
                    ldd      #$0a00                       ; make sure ramping is disabled 
                    std      VIA_t1_cnt_lo                ; disable ramping 
                    _ZERO_VECTOR_BEAM                     ; and we go to zero 
                    jsr      doGameOver                   ; display game over animation 
; test for hight score
; high score tabel 
; etc
                    jsr      test_highscore               ; test highscore 
                    tsta                                  ; result in a 
                    bmi      no_hs_acchieved              ; if negative - no score 
                    jsr      edit_highscore               ; if positive in a place we acchieved - go to the hs editor 
                    ldd      #(EEPROM_STORESIZE_HS*256)+EEPROM_HS1_BLOCK 
                    ldx      #highScoreBlock 
                    std      current_eprom_blocksize 
                    jsr      eeprom_save_highscore        ; and save the newly claimed highscore to eprom / VecFever 
no_hs_acchieved 
                    lda      #1                           ; set state of object generator to 1 (title) 
                    sta      return_state 
                    jsr      initGame                     ; init that 
                    ldb      #3                           ; set a button status - so that a possible pressed button does not DIRECTLY start a new game 
                    stb      last_button_state 
                    stb      current_button_state 
                    jmp      backFromDemo                 ; and go back 

not_gameOver 
                    clr      bonusActiveType              ; remove shield active flag 
                    ldd      #1                           ; next round bonus gets deecreased to 0 - and a new bonus can spawen again 
                    std      bonusCounter                 ; 
                    jmp      removeObject                 ; remove the enemy that hit us - and "jump" back 

;***************************************************************************
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                    INCLUDE  "data.i"                     ; 
                    INCLUDE  "sound.i"                    ; 
                    INCLUDE  "ayfxPlayer_channel3.i"
                    INCLUDE  "ayfxPlayer_channel2.i"
                    INCLUDE  "ayfxPlayer_channel1.i"
                    INCLUDE  "collisionRoutines.i"
                    INCLUDE  "highscore.asm"
; u must be preserved
; destroys d,y
; in x pointer to 3 digit csa score (lsb)
; 
; adds the score pointed to by X (3 didgit csa score) to 
; the player score (6 digit csa score)
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
SCORE_X_START       =        $10 
; entry point for ingame score display
; score has a CERTAIN nice long move
; therefor we can decode some music here
; the decoding of music is handled differently if not in game.
draw_Score_game 
draw_Score                                                ;#isfunction  
; has a nice long moveto
                    ldd      #($7f *256)+SCORE_X_START 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                                                          ; ldb #SCORE_X_START 
                    MY_MOVE_TO_D_START  
; in between about 200 cylces spare time!
;                    jsr      [inMovePointer] 
                    jsr      [inMovePointer] 
in_game_score 
                    tst      demo_mode                    ; are we in demo mode? 
                    bne      draw_demo                    ; if so jump to display demo rather than the score 
                    lda      #SCORE_SIZE 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    ldu      #NumberList 
                    lda      player_score_5 
                    lsla     
                    ldx      a,u 
                    lda      #$5f                         ; intensity 
                    MY_MOVE_TO_B_END  
                    _INTENSITY_A  
; the score is positioned with one move only
; all subsequent letters can be drawn directly, since the
; score allways "leave" at the correct position
;
; display 6 digits!
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

; display demo instead of score
; demo "blinks" at the ferquency of 5/2 second (50/20)
;
; in opposite to the score
; the letters of the DEMO are displayed seperately
; each letters gets positioned from 0,0 
; otherwise (for whatever reason) the 
; demo does not display nicely
;
; additionally: due to the phenomenon which I call "zero retain", 
; befor the first letter I do one "dummy" move and zero,
; otherwise the first letter is not in line with the others. 
;
; on entry we are already in the first MOVE
draw_demo                                                 ;#isfunction  
                    ldd      #($7f *256)+SCORE_X_START 
                    std      tmp_word 
                    ldu      #demo_string 
                    lda      #$7f 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    ldd      tmp_word 
                    dec      demo_blink_Counter 
                    bpl      no_change_demo_int 
                    lda      #20 
                    sta      demo_blink_Counter 
                    lda      demo_Intensity 
                    beq      make_light_demo 
                    clr      demo_Intensity 
                    bra      no_change_demo_int 

make_light_demo 
                    lda      #$5f 
                    sta      demo_Intensity 
no_change_demo_int 
                    lda      demo_Intensity               ; intensity 
                    MY_MOVE_TO_B_END  
                    _INTENSITY_A  
                    _ZERO_VECTOR_BEAM                     ; draw each letter with a move from zero, more stable 
                    nop      2 
next_name_letter_vp_d 
                    lda      #$7f 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    ldd      tmp_word 
                                                          ;#isfunction 
                    MY_MOVE_TO_D_START  
indemo_draw 
                    LDB      ,u+                          ; first char of three letter name 
                    SUBB     # 'A'                        ; subtract smallest letter, so A has 0 offset
                    LSLB                                  ; multiply by two, since addresses are 16 bit 
                    ldx      #_abc                        ; and add the abc (table of vector list address of the alphabet's letters) 
                    LDX      b,X                          ; in x now address of first letter vectorlist 
                    lda      tmp_word+1 
                    adda     #10 
                    sta      tmp_word+1 
                    lda      #16 
                    _SCALE_A  
                    MY_MOVE_TO_B_END  
                    jsr      myDraw_VL_mode2              ;2 
                    _ZERO_VECTOR_BEAM                     ; draw each letter with a move from zero, more stable 
                    LDB      ,u 
                    bpl      next_name_letter_vp_d 
                    lda      #$5f 
                    _INTENSITY_A  
                    rts      

;;;;;;;;;;;;;;;;;;;;;;
BONUS_X_START       =        $0-30 
; draws the bonus Icon next to the score
drawBonus                                                 ;#isfunction  
; has a nice long moveto
                    ldd      bonusCounter 
                    cmpd     #1 
                    bls      noBonus_db 
                    lda      bonusIconMoveScale 
                    cmpa     #$7f 
                    bhs      scale_mx_db 
                    adda     #2 
                    sta      bonusIconMoveScale 
scale_mx_db 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    ldb      #BONUS_X_START 
                    MY_MOVE_TO_D_START  
; in between about 200 cylces spare time!
                    jsr      [inMovePointer] 
                    lda      #4 
                    sta      VIA_t1_cnt_lo                ; to timer t1 (lo= 
                    ldx      bonusIconList 
                    MY_MOVE_TO_B_END  
                    jsr      myDraw_VL_mode2 
                    _ZERO_VECTOR_BEAM  
noBonus_db: 
                    rts      

                    include  "phaseDefinitions.i"         ; the actual hardcoded part of the level information
out_cs2 
                    rts      

; check whether some game factors should change
; speed increase / decrease etc
; the determining factor are the number of enemy "spawns" 
; the actual count needed to advance to the next phase is included in the active phase (or 0 - than phase stays forever)
check_stage 
                    ldd      next_phase_at 
                    beq      out_cs2 
                    subd     spawn_count 
                    bpl      out_cs2 
                    ldd      #0 
                    std      spawn_count 
                    ldu      #phaseList 
                    lda      phase_count 
                    inca     
                    lsla     
                    ldu      a,u 
                    beq      out_cs2 
                    inc      phase_count 
                    ldd      #phaseChange_Sound 
                    jsr      play_sfx 
; in u pointer to phase
initPhase 
; some values of the phase can be set to -1
; if these are set, the old values are kept
; like accumulated spawn timer etc
; these values are set "manually"
; in the next lines
; the actual
; initialize values from the the phase are copied
; later nonetheless via memmove
; but not used for further initialization
                    stu      currentPhaseData 
                    lda      3,u 
                    sta      shieldMinorIncreaseCounter 
                    lda      21+5-2,u 
                    cmpa     #$ff 
                    beq      no_change_cs1 
                    sta      spawn_reset 
                    sta      spawn_timer 
no_change_cs1 
                    lda      22+5-2,u 
                    cmpa     #$ff 
                    beq      no_change_cs2 
                    sta      spawn_increase_delay 
no_change_cs2 
                    lda      23+5-2,u 
                    cmpa     #$ff 
                    beq      no_change_cs3 
                    sta      min_spawn_reset 
no_change_cs3 
                    lda      24+5-2,u 
                    cmpa     #$ff 
                    beq      no_change_cs4 
                    sta      max_spawn_increase_delay 
no_change_cs4 
                    lda      #(phaseBlockEnd-phaseBlockStart) 
                    ldx      #phaseBlockStart 
                    jsr      Move_Mem_a 
                    lda      #INITIAL_HUNTER_MOVE_DELAY 
                    sta      Hunter_add_delay 
                    lda      #INITIAL_HX_MOVE_STRENGTH 
                    sta      HX_addi 
; keep bonus alive on new phase!
                    lda      bonusActiveType 
                    beq      out_cs 
                    cmpa     #BONUS_TYPE_FASTER 
                    beq      activeFaster_cs 
                    cmpa     #BONUS_TYPE_EXPAND 
                    beq      activeExpand_cs 
                    cmpa     #BONUS_TYPE_SHIELD 
                    beq      activeShield_cs 
activeFaster_cs 
                    lsl      shieldSpeed                  ; more with each adder 
                                                          ; we also enlargen the width adder, otherwise the width would (alltogether) be smaller 
                    lsl      shield_width_adder           ; more with each adder 
                    bra      out_cs 

activeExpand_cs 
                    lda      #1 
                    sta      shieldWidthGrowth 
                    lda      shieldSpeed 
                    sta      shield_width_adder           ; more with each adder 
activeShield_cs 
out_cs 
                    rts      

;***************************************************************************
; x = in csa score [6 byte] msb first
; u = out bcd [3 byte] msb first
csa_to_bcd 
                    ldb      #3 
next_byte_c_b: 
                    lda      ,x+ 
                    lsla     
                    lsla     
                    lsla     
                    lsla     
                    sta      tmp_byte 
                    lda      ,x+ 
                    ora      tmp_byte 
                    sta      ,u+ 
                    decb     
                    bne      next_byte_c_b 
                    rts      

;***************************************************************************
; u = in bcd [3 byte] msb first
; x = out csa score [6 byte] msb first
bcd_to_csa 
                    ldb      #3 
next_byte_b_c: 
                    lda      ,u 
                    lsra     
                    lsra     
                    lsra     
                    lsra     
                    sta      ,x+ 
                    lda      ,u+ 
                    anda     #%00001111 
                    sta      ,x+ 
                    decb     
                    bne      next_byte_b_c 
                    rts      

;***************************************************************************
; unsigned!
; u = in csa score [6 byte] msb first
; x = in csa score [6 byte] msb first
; return a = $ff if u<x
; return a = 1 if u>x
; return a = 0 if u=x
; flags are set corresponingly
;
compare_csa 
                    ldb      #6 
next_compare_cc: 
                    lda      ,u+ 
                    cmpa     ,x+ 
                    bhi      return_u_greater_x 
                    blo      return_u_smaller_x 
                    decb     
                    bne      next_compare_cc 
return_u_equal_x 
                    lda      #$00 
                    rts      

return_u_smaller_x 
                    lda      #$ff 
                    rts      

return_u_greater_x 
                    lda      #$01 
                    rts      

;***************************************************************************
; unsigned!
; u = in bcd score [3 byte] msb first
; x = in csa score [6 byte] msb first
; return a = $ff if u<x
; return a = 1 if u>x
; return a = 0 if u=x
; flags are set corresponingly
;
; uses: csa_buf
compare_csa_bcd: 
                    pshs     x 
                    ldx      #csa_buf 
                    bsr      bcd_to_csa 
                    ldu      #csa_buf 
                    puls     x 
                    bsr      compare_csa 
                    rts      

highScoreSeekDone 
                    lda      tmp_word 
                    cmpa     #5 
                    bne      done_hsd 
                    lda      #$ff 
done_hsd 
                    rts      

; compares the last acchieved score (in player_score - csa 6 msb first)
; to all highscore in highScoreTable (5 bcd scores)
; if high score is valid, the scores get copied to the correct places
; 
; leaves with a = place achieved 0-4
; or $ff for no highscore
test_highscore                                            ;#isfunction  
                    lda      #5 
                    sta      tmp_word 
                    ldu      #highScoreTableEnd-3-2       ; (pointer to last bsd highscore) 
testNext_highscore_th: 
                    ldx      #player_score 
                    pshs     x,u 
                    bsr      compare_csa_bcd 
                    puls     x,u 
                    bmi      newHighscore 
                    bra      highScoreSeekDone 

newHighscore 
; if not last position, copy this position to one further
                    lda      tmp_word 
                    cmpa     #5 
                    beq      only_new_score_copy 
; copy score (and name) in table to one position lower
                    ldd      -3,u 
                    std      -3+6,u 
                    lda      -1,u 
                    sta      -1+6,u 
                    ldd      ,u 
                    std      6,u 
                    lda      2,u 
                    sta      8,u 
only_new_score_copy: 
; copy my score to this position (and keep the old name)
                    ldx      #player_score 
                                                          ; convert X to bcd 
                    pshs     u 
                    jsr      csa_to_bcd 
                    puls     u 
                    leau     -6,u                         ; one score earlier 
                    dec      tmp_word 
                    bne      testNext_highscore_th 
                    clra     
                    rts      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
clear_all_sound                                           ;#isfunction  
                    ldd      #0 
                    std      currentSFX_3 
                    std      currentSFX_2 
                    std      currentSFX_1 
                    std      sfx_pointer_3 
                    std      sfx_pointer_2 
                    std      sfx_pointer_1 
                    std      sfx_status_1 
                    sta      sfx_status_3 
                    CLR      Vec_Music_Flag               ; no music is playing ->0 (is placed in rottist! 
                    JSR      Init_Music_Buf               ; shadow regs 
                    JSR      Do_Sound                     ; ROM function that does the sound playing, here used to clear all regs 
                    rts      

;move_to_d
; MY_MOVE_TO_D_START_NT
; MY_MOVE_TO_B_END
; rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; in d music address
; prioratize 1 (supposed for noise)
play_sfx_p1 
                    pshs     u,x 
                    tfr      d,x 
use1SFX_psfx1: 
                    tst      sfx_status_1 
                    bne      use2SFX_psfx1 
                    jsr      play_sfx_1 
                    bra      out_psfx1 

use2SFX_psfx1: 
                    tst      sfx_status_2 
                    bne      use3SFX_psfx1 
                    jsr      play_sfx_2 
                    bra      out_psfx1 

use3SFX_psfx1: 
                    tst      sfx_status_3 
                    bne      testPrio1_psfx1 
                    jsr      play_sfx_3 
                    bra      out_psfx1 

testPrio1_psfx1: 
                    jsr      play_sfx_1 
                    cmpa     #1 
                    beq      out_psfx1                    ; playing1|\? 
testPrio2_psfx1: 
                    jsr      play_sfx_2 
                    cmpa     #1 
                    beq      out_psfx1                    ; playing2\? 
testPrio3_psfx1: 
                    jsr      play_sfx_3 
out_psfx1 
                    puls     u,x 
                    rts      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; uses only channels B+C (not A - where the music is playing)
play_sfx                                                  ;#isfunction  
                    tst      musicOption 
                    bne      play_sfx_p1 
                    pshs     u,x 
                    tfr      d,x 
use2SFX_psfx_np: 
                    tst      sfx_status_2 
                    bne      use3SFX_psfx_np 
                    jsr      play_sfx_2 
                    bra      out_psfx_np 

use3SFX_psfx_np: 
                    tst      sfx_status_3 
                    bne      testPrio2_psfx_np 
                    jsr      play_sfx_3 
                    bra      out_psfx_np 

testPrio2_psfx_np: 
                    jsr      play_sfx_2 
                    cmpa     #1 
                    beq      out_psfx_np                  ; playing2\? 
testPrio3_psfx_np: 
                    jsr      play_sfx_3 
out_psfx_np 
                    puls     u,x 
                    rts      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
query_joystick:                                           ;#isfunction  
                    QUERY_JOYSTICK  
                    rts      

;***************************************************************************
                    INCLUDE  "scroller.asm"               ; 
                    INCLUDE  "title.asm"                  ; 
                    INCLUDE  "options.asm"                ; 
                    INCLUDE  "gameover.asm"               ; 
                    INCLUDE  "arkosPlayer1Channel.i"      ; 
                    INCLUDE  "arkosPlayerAllChannel.i"    ; 
                    INCLUDE  "objects2.asm"               ; 
;***************************************************************************
;***************************************************************************
;***************************************************************************
CURRENT_BANK        =        2 
                    include  "inBothBanks2.i"
