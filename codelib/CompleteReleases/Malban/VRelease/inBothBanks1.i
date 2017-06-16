; this file is part of Release, written by Malban in 2017
;
; load vectrex bios routine definitions
                    INCLUDE  "VECTREXR.I"                 ; vectrex function includes
                    INCLUDE  "macro.i"                    ; vectrex function includes
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
; $c800 - $c80f used as sound shadow - I use them also for that
                    org      $c80f                        ; 20 BIOS bytes to reuse 
list_empty_head     ds       2                            ; if empty these contain a positive value that points to a RTS 
list_objects_head   ds       2                            ; if negative, than this is a pointer to a RAM location 
list_objects_tail   ds       2 
currentSFX_1        ds       2                            ; sfx player used 
currentSFX_2        ds       2                            ; sfx player used 
currentSFX_3        ds       2                            ; sfx player used 
sfx_status_1        ds       1                            ; sfx player used 
sfx_status_2        ds       1                            ; sfx player used 
sfx_pointer_1       ds       2                            ; sfx player used 
sfx_pointer_2       ds       2                            ; sfx player used 
sfx_pointer_3       ds       2                            ; sfx player used 
; only in game usable, since RAM used by print and loops
phase_count         ds       1 
spawn_count         ds       2 
deadEnemies         ds       1 
spawnRest_Counter   ds       1 
spawn_increase_delay  ds     1 
spawn_reset         ds       1                            ; after x ticks a new spawn happens , test for dec -> bpl 
spawn_timer         ds       1                            ; current counter for those ticks , test for dec -> bpl 
shield_delay        ds       1                            ; delay after which a shield collaps and a new shield can spawn 
shieldMinorIncreaseCounter  ds  1                         ; 1 = every second, test for dec -> bpl 
shieldWidthCounter  ds       1                            ; shield width, grows each "x" cycles by "y" (this is x) 
tmp_byte            ds       0 
tmp_count2          ds       1                            ; 
tmp_word            ds       0 
tmp_add             ds       2                            ; poly 
tmp_angle           ds       2                            ; poly 
neg_test            ds       1 
tmp_offset          ds       2                            ; poly 
tmp_lastpos         ds       2                            ; poly 
currentMusic        ds       2                            ; ym player used 
currentYLenCount    ds       2                            ; ym player used 
nextMusic           ds       2                            ; ym player used 
; $C83d + Recal  music work buffer (14 bytes)
; I use them for ym registers also
; none of the following BIOS RAM location 
; must be reserved for "Release" and can thus be reused!
                    org      $c84d 
rotList             ds       8*2+3                        ; some ... space for a max 8 sided base (shield/explosion) 
star_swirl          ds       1                            ; -1, 1 or 0 
tmp_first_vector    ds       2 
sfx_status_3        ds       1                            ; sfx player used 
starletCount        ds       1 
starletAngle        ds       2 
currentMaxOffset    ds       1                            ; dunno if that is correct anymore with new collision detection (TODO check - as of now this is FIXED, should be scale dependend) 
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
;                    org      $c880 
currentPatternPointer  ds    2 
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
;
;;;;; PHASE BLOCK START
hs_place_got        ds       0 
phaseBlockStart     ds       0                            ;#isfunction 
spawn_allowed       ds       1 
hs_place_edit       ds       0 
shieldWidthGrowth   ds       1                            ; shield width, grows each "x" cycles by "y" (this is y) 
hs_blink_count      ds       0 
shieldSpeed         ds       1                            ; speed of the shield MOVEMENT - not the speed of growth 
hs_blink_state      ds       0 
shieldMinorIncreaseCounterReset  ds  1 
last_joy_x          ds       0 
shieldMinorIncrease  ds      1 
last_joy_y          ds       0 
shield_width_adder  ds       1 
Vec_Joy_1_X         ds       0 
shot_add_delay      ds       1                            ; change pos each this "ticks" , test for dec -> bpl 
Vec_Joy_1_Y         ds       0 
shot_addi           ds       1                            ; change pos by this each "change" 
Vec_Joy_2_X         ds       0 
X_add_delay         ds       1                            ; change pos each this "ticks" , test for dec -> bpl 
Vec_Joy_2_Y         ds       0 
X_addi              ds       1                            ; change pos by this each "change" 
HX_add_delay        ds       1                            ; change pos each this "ticks" , test for dec -> bpl 
Hunter_addi         ds       1                            ; change pos by this each "change" 
Bomber_add_delay    ds       1                            ; change pos each this "ticks" , test for dec -> bpl 
Bomber_addi         ds       1                            ; change pos by this each "change" 
bomber_delay_start  ds       1 
Dragon_Scale_delay  ds       1                            ; change pos each this "ticks" , test for dec -> bpl 
Dragon_Angle_addi   ds       2                            ; change (angle) pos each this "tic 
Dragon_Angle_delay  ds       1                            ; change (angle) pos each this "tic 
dragonchild_addi    ds       1                            ; change pos by this each "change" 
minimum_bomb_reload  ds      1 
Bonus_add_delay     ds       1                            ; change pos each this "ticks" , test for dec -> bpl 
Bonus_addi          ds       1                            ; change pos by this each "change" 
bonusActiveTime     ds       1                            ; in seconds! MAX 99! 
phase_spawn_reset   ds       1 
phase_spawn_increase_delay  ds  1 
phase_min_spawn_reset  ds    1 
phase_max_spawn_increase_delay  ds  1 
next_phase_at       ds       2 
phaseBlockEnd       ds       0 
Hunter_add_delay    ds       1                            ; change pos each this "ticks" , test for dec -> bpl 
HX_addi             ds       1                            ; change pos by this each "change" 
;;;;; PHASE BLOCK END
;
base_angle          ds       2                            ; current start angle of base (*2) 
sided               ds       1                            ; current count of sides for base 
shieldWidth         ds       1                            ; shield width now 
shieldStart         ds       1                            ; outer shield position (in scale) 
innerShield         ds       1                            ; inner shield position (in scale) 
noShieldGrowthVar   ds       1                            ; if shield has max size do not grow anymore! 
current_forth_dif   ds       1                            ; var for oscillating "inner" shield 
current_back_dif    ds       1                            ; var for oscillating "inner" shield 
osc_forth           ds       1                            ; var for oscillating "inner" shield 
currentScroller     ds       0 
osc_back            ds       1                            ; var for oscillating "inner" shield 
bonusCounter        ds       0                            ; counter in system ticks 
bonusCounter_hi     ds       1                            ; counter in system ticks 
bonusCounter_lo     ds       1                            ; counter in system ticks 
bonus_time_1        ds       1                            ; csa score digit 1 
bonus_time_0        ds       1                            ; csa score digit 0 
bonusIconMoveScale  ds       1                            ; scaled position of the bonus icon 
bonusIconList       ds       2                            ; scaled position of the bonus icon 
use_half_stepCounter  ds     0                            ; 0 = yes use half steps,else no 
bonusActiveType     ds       1 
currentPhaseData    ds       2 
shield_max          ds       1 
spawn_max           ds       1                            ; 
min_spawn_reset     ds       1 
max_spawn_increase_delay  ds  1 
current_eprom_blocksize  ds  1 
current_eprom_blockadr  ds   1 
ds2431Present       ds       1                            ; flag whether the eEprom was found or not 
ignoreDs2431        ds       1                            ; flag whether to ignore eEprom altogether (button on startup), VecFlash gets irritated by PB6 access 
;
                    struct   HighScoreEntry 
                    ds       NAME,3                       ; 
                    ds       BCD_SCORE,3                  ; 
                    end struct 
;
;********************************************************************
; save to eEprom Starts here!
v4e_saveBlockStart  ds       0                            ;#isfunction 
;
optionsBlock        ds       0 
demo_mode           ds       0                            ;1 
option1             ds       1 
musicOption         ds       1 
sfxOption           ds       1 
halfnoise           ds       1 
demo_blink_Counter  ds       0                            ;1 
option5             ds       1 
return_state        ds       0                            ;1 
option6             ds       1 
demo_Intensity      ds       0                            ;1 
option7             ds       1 
option8             ds       1                            ; last is "filler" chksum 
optionsBlockEnd     ds       0                            ; 8 byte at least for a block 
;
highScoreBlock      ds       0 
highScoreTable      ds       HighScoreEntry * 5           ; 6*5 = 30 byte 
                    ds       2                            ; filler to 32 
highScoreTableEnd   ds       0 
v4e_saveBlockEnd    ds       0 
;********************************************************************
bcd_buf             ds       3 
csa_buf             ds       6 
t2_rest             ds       1 
noTimerCheck        ds       1                            ; if one no timer adjustment! 
explosionMax        ds       1 
object_count        ds       1                            ; how many objects are alive? 
starFieldCounter    ds       1 
explosionActiveCounter  ds   1 
score_display_time  ds       1 
starfield_max       ds       1 
shieldActive        ds       1 
startDataPos        ds       2 
nextDataPos         ds       2 
currentDataBitPos   ds       1 
currentDataByte     ds       1 
inMovePointer       ds       2 
initialPhase        ds       2 
demoWaitShieldToActivate  ds  1 
demoWaitShieldToDeActivate  ds  1 
scrollBlink         ds       1 
scrollIntensity     ds       1 
scrollBlinkAdd      ds       1 
bonusDestroyedCounter  ds    1 
INITIAL_STARFIELD_MAX  =     10 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;newEepromRAMStart   ds      highScoreHardcoreBlockEnd    ; new save struct, straight 32 bytes 
;newEepromRAMEnd     ds      32        ; of which only 28 bytes are used! 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                    org      $c900 
; 16 bytes per object
                    struct   ObjectStruct 
                    ds       Y_POS,1                      ; D (1) current position 
                    ds       SCALE,1                      ; D (2) scale to position the object 
                    ds       CURRENT_LIST,2               ; X current list vectorlist 
                    ds       TYPE, 0 
                    ds       BEHAVIOUR,2                  ; PC 
                    ds       X_POS,1                      ; D (2) 
                    ds       ANGLE,2                      ; if angle base, angle in degree *2 
                    ds       NEXT_OBJECT,2                ; positive = end of list 
                    ds       filler, 5                    ; #noDoubleWarn 
                    end struct 
MAX_OBJECTS         =        38                           ; todo determine max possible spawns! 
; all objects are held in a linked list
; the linked list is made up by object defined by structs
; the BASIC Object list consists of empty fields - plus the entry "NEXT_OBJECT"
; if NEXT_OBJECT is positive (not RAM pointer), than the list is finished
object_list         ds       ObjectStruct*MAX_OBJECTS     ;#isfunction 
object_list_end     ds       0 
                    org      object_list_end+ObjectStruct 
timerObject         ds       ObjectStruct                 ;#isfunction 
; 
; start of some RAM Vars for Arkos Tracker
;
; below RAM usuage is 74 byte (without psh shadow/work registers, which are set to
; vectrex default RAM locations)
arkosPlayerMemStart  ds      0                            ;#isfunction 
tmp_track_param     ds       1 
tmp_track_instrument  ds     1                            ; 
tmp_instrument_second_byte  ds  1 
; following are player vars which are channel independend
PLY_HEIGHT          ds       1                            ; height of pattern 
PLY_SPEED           ds       1                            ; speed of pattern 
PLY_SPEEDCPT        ds       1                            ; current speed position (count down to 0) 
PLY_HEIGHTCPT       ds       1                            ; current height position (count down to 0) 
PLY_TRACK_INSTRUMENTSTABLEPT  ds  2                       ; address of instrument table 
PLY_LINKER_PT       ds       2                            ; current linker position 
PLY_PSGREG13_RETRIG  ds      1                            ; retrigger "flag" - if same as PLY_PSGREG13, than not retriggered, otherewise - yes 
PLY_SAVESPECIALTRACK  ds     2                            ; start position of current special track 
PLY_SPECIALTRACK_PT  ds      2                            ; current position in special track 
PLY_SPECIALTRACK_WAITCOUNTER  ds  1                       ; wait counter for special track (count down to 0) 
;
; in general in below player, y reg points to the start of
; following structure (one for each channel)
                    struct   ArkosChannel 
                    ds       PLY_TRANSPOSITION, 1 
                    ds       PLY_TRACK_SAVEPTINSTRUMENT, 2 
                    ds       PLY_TRACK_INSTRUMENT, 2 
                    ds       PLY_TRACK_INSTRUMENTSPEED, 1 
                    ds       PLY_TRACK_INSTRUMENTSPEEDCPT, 1 
                    ds       PLY_TRACK_PT, 2 
                    ds       PLY_TRACK_WAITCOUNTER, 1 
                    ds       PLY_TRACK_NOTE, 1 
                    ds       PLY_TRACK_VOLUME, 1 
                    ds       PLY_TRACK_PITCH, 2 
                    ds       PLY_TRACK_PITCHADD, 2 
                    ds       PLY_TRACK_REG_7 ,1 
                    end struct 
;
Channel1Data        ds       ArkosChannel 
Channel2Data        ds       ArkosChannel 
Channel3Data        ds       ArkosChannel 
ChannelDataEnd      ds       0 
;
PLY_PSGREG13        ds       1                            ; special - this is used for retrigger activities 
PLY_VOL_REG         ds       2                            ; these two are used to stay "channel" independend 
PLY_FREQ_REG        ds       2                            ; they are loaded befor the "work" routines with the corresponding regs of the current channel 
songOver            ds       1 
arkosPlayerMemEnd   ds       0 
                    org      Vec_Music_Work 
; simple redefines for source compatability 
PLY_PSGREGISTERSARRAY                                     ;#isfunction  
PLY_PSGREG0         ds       1 
PLY_PSGREG1         ds       1 
PLY_PSGREG2         ds       1 
PLY_PSGREG3         ds       1 
PLY_PSGREG4         ds       1 
PLY_PSGREG5         ds       1 
PLY_PSGREG6         ds       2 
PLY_PSGREG8         ds       1 
PLY_PSGREG9         ds       1 
PLY_PSGREG10        ds       1 
PLY_PSGREG11        ds       1 
PLY_PSGREG12        ds       2 
PLY_PSGREGISTERSARRAY_END 
SCROLL_RAM_START    =        object_list +20*ObjectStruct ; reserve space for 20 objects for starfield 
SCALE_FACTOR_GAME=$80  -     SHIFT_TITLE_UP 
;
; Defines
;
BASE_SCALE          =        5                            ; base scale is "5" 
SHIELD_START_SCALE  =        1 
SHIELD_START_WIDTH  =        3                            ; first shield width is 3 scale 
SHIELD_WIDTH_GROWTH_DEFAULT  =  4                         ; 2 up ; grow shield width every x ticks with speed (counter) 
INITIAL_SHIELD_WIDTH_ADDER  =  1                          ; 1-4 WIDTH OF SHIELD increase (strength) 
SHIELD_DEFAULT_SPEED  =      2                            ; increase position of shield with 2 every each increase step 
SHIELD_MAX_SCALE_INIT  =     $d0                          ; further out gives more often the "external" glow 
SHIELD_VARIANCE     =        10                           ; for collision detection, shield to midpoint of object - 10 should reach every midpoint... 
SHIELD_MINOR_DELAY_COUNTER_DEFAULT  =  2                  ; every third 
SHIELD_MINOR_INCREASE_DEFAULT  =  0                       ; add 0 
SHIELD_DELAY_TICKS  =        7                            ; wait after each shield collaps this many ticks, befor a new shield can be initiated (otherwise shield spawning is possible) 
INITIAL_EXPLOSION_MAX  =     40                           ; max scale of explosion 
; for enemies it must be ensured that ALL have a different highbyte
TYPE_BONUS          =        (bonusBehaviour/256)         ;9 
TYPE_DRAGONCHILD    =        (dragonchildBoundBehaviour/256) ;8 
TYPE_DRAGON         =        (dragonBehaviour_full/256)   ;7 
TYPE_SHOT           =        (shotBehaviour/256)          ;6 
TYPE_BOMBER         =        (bomberBehaviour/256)        ;5 
TYPE_HUNTER         =        (hunterBehaviour/256)        ;4 
TYPE_HIDDEN_X       =        (hiddenXBehaviour/256)       ;3 
TYPE_STARLET        =        (starletBehaviour/256)       ;2 
TYPE_X              =        (xBehaviour/256)             ;1 
;
; below behaviours are WAY bigger than above ones
;
TYPE_BOUNDARY       =        ($6000/256) 
TYPE_EX             =        (explosionBehaviour/256)     ;-1 ; negative types are not destroyed by shield 
TYPE_SCORE          =        (scoreBehaviour/256)         ;-2 or scoreXBehaviour ; 
TYPE_TIMER          =        (timerBehaviour/256)         ;-3 
TYPE_STARFIELD      =        (starfieldBehaviour/256)     ; -4 
TYPE_LETTER         =        (letterBehaviour/256 )       ;-10 
TYPE_LETTER_1       =        (letterBehaviour/256)        ; -11 
TYPE_LETTER_2       =        (letterBehaviour/256)        ; -12 
TYPE_LETTER_3       =        (letterBehaviour/256)        ; -13 
TYPE_LETTER_4       =        (letterBehaviour/256)        ; -14 
TYPE_LETTER_5       =        (letterBehaviour/256)        ; -15 
TYPE_LETTER_6       =        (letterBehaviour/256)        ; -16 
TYPE_LETTER_7       =        (letterBehaviour/256)        ; -17 
BUFFER_OBJECT_COUNT  =       10                           ; number of objects that should be free - starfields will spawn/destroyed accordingly 
INITIAL_SCORE_DISPLAY_TIME  =  50                         ; scores are displayed for about 1 s 
SPAWN_MAX_SCALE_INIT  =      $c8                          ; further out gives more often the "external" glow 
STAR_SCALE          =        40                           ; radius pos of starlets 
STARLET_ANIM_DELAY  =        1                            ; test for dec -> bpl 
X_ANIM_DELAY        =        2                            ; test for dec -> bpl 
STARLET_SCORE_DELAY  =       75                           ; at 50Hz 1,5 seconds 
STARLET_START_SCORE  =       2                            ; start bonus of star score at 2 bonus points (first displayed is 4) 
BONUS_ANIM_DELAY    =        1 
INITIAL_BONUS_MOVE_DELAY  =  0                            ; every tick 
INITIAL_BONUS_MOVE_STRENGTH  =  2                         ; move one scale pos 
INITIAL_SHOT_MOVE_DELAY  =   1                            ; every tick 
INITIAL_SHOT_MOVE_STRENGTH  =  1                          ; move one scale pos 
INITIAL_HX_MOVE_DELAY  =     1                            ; every second tick 
INITIAL_HX_MOVE_STRENGTH  =  1                            ; move one scale pos 
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
INITIAL_DRAGON_MOVE_STRENGTH  =  2                        ; angle SUB per 
INITIAL_DRAGON_ANGLE_DELAY  =  0                          ; angle SUB per 
DRAGON_CHILD_FREE_SPEED  =   1                            ; decrease scale with 2 every tick 
;
; with each spawn increase
; the speed of the increase slows down
INITIAL_SPAWN_INCREASE_DELAY  =  1 
INITIAL_SPAWN_RESET_TIMER  =  50                          ; each second , test for dec -> bpl 
MAXIMUM_RESET_INCREASE_SLOWDOWN  =  10 
FASTEST_SPAWN_RATE  =        15                           ; 15/50 s a spawn happens at the fastest rate 
DEFAULT_BONUS_ACTIVE_TIME  =  30                          ; 99 is max! seconds - in seconds! 
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
ALLOW_SQUAD         =        $80 
DEFAULT_ALL_SPAWN   =        $ff 
;
BONUS_TYPE_SHIELD   =        1 
BONUS_TYPE_EXPAND   =        2 
BONUS_TYPE_FASTER   =        3 
SHIFT_TITLE_UP      =        $20 
