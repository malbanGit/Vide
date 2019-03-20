USE_PB6             =        1

; hey dissi "watch RecalCounter 2"
;
; Karl Quappe
;
; 1.0 Version was:
;     written by Malban in March-April 1998, that version was called Vectrex Frogger
;     all stuff contained here is public domain
;
; 2.0 Version was done in 2016 by Malban
;
; comments and vectrex talk are welcome
; my email: malban@malban.de
;
;
; Stuff that might be subject to change/is not as a player would expect:
; - RecalCounter is not player dependend -> Wave sound 
;
;
; start level - first level that will be played, level definitions in "level.i"
START_LEVEL         EQU     0
FROGS_PER_GAME      EQU      (lo(5))                      ; number of frogs per game, 
HALFSPEED           =        0                            ; if defined, it is possible for objects to move slower than 1 "pixel" 
                                                          ; see also if defs for HALFSPEED in other files (InMoves.i -> GENERAL_IN_MOVE_SPRITE e.g.) 
                                                          ; if included defined Bin > 32k 
ARCADE_MOVE         =        0                            ; than logs and crocos are also defined in the opposite direction (no levels done though) 
                                                          ; if included defined Bin > 32k 
                    INCLUDE  "VECTREX.I"                  ; vectrex function includes
                    INCLUDE  "MAKROS.I"                   ; vectrex functions as macros (some)
;
; the RAM usage could be better organized and optimized
; as of now I still have a 100 bytes (or so) to spare, so there never was a need to optimize
; there are even some vars that are not used anymore but are leftovers that I didn't clean up from version 1
; user variable definitions
; $c880
user_ram            EQU      $c880                        ; well start of our ram space 
user_ram_start      EQU      user_ram 
music_active        EQU      user_ram                     ; pointer to music piece which is playing now 
music_counter       EQU      music_active + 2             ; pointer to weridos, used only in init screen 
tmp1                EQU      music_counter + 2            ; two temporal storage variables 
tmp2                EQU      tmp1 + 2                     ; ... 
mul_tmp1            EQU      tmp2 + 2                     ; two variable used in MY_MUL only 
mul_tmp2            EQU      mul_tmp1 + 2                 ; 
morph_status        EQU      mul_tmp2 + 2                 ; status--- 
morph_tmp           EQU      morph_status + 1             ; saves a few cycles... for the step counter only in one_morph_step 
morph_sign          EQU      morph_tmp + 1                ; number of steps between 'from' and 'to' variable 
morph_counter       EQU      morph_sign + 1               ; number of steps between 'from' and 'to' variable 
morph_steps         EQU      morph_counter + 1            ; number of steps between 'from' and 'to' constant 
morph_delay         EQU      morph_steps + 1              ; delay between one step and another (variable) 
morph_structure     EQU      morph_delay + 2              ; pointer to morphstructure of current morphing 
morph_div_jsr       EQU      morph_structure + 2          ; pointer to indirectly JSR to a divide routine (for optimization) 
; following are 'in game' variables, out of the game these can be reused
; scroll_variables_start  EQU  morph_div_jsr + 2            ; from here reuse scroll variables... 
; from here only variables in game!!!
kind_of_death       EQU      morph_div_jsr + 2            ; storage to text, what kind of death happened to frog 
in_home_counter     EQU      kind_of_death + 2            ; number of free homes in the currently played level 
game_level          EQU      in_home_counter + 1          ; what game level are we playing 
current_frog_size_x  EQU     game_level + 1               ; size of frog 'sprites' following (all the same for now) 
current_frog_offset  EQU     current_frog_size_x + 1      ; offset to 'zero' of current frog sprite 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; a short note on the sprite offsets: all sprites have 'naturally' a starting
; point the offset is the space between that starting point and a 'virtual'
; grid position. the value of these offsets heavily depend on which scaling is used,
; so if you use a different 'resolution' these offsets must be changed also...
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
current_frog_heading  EQU    current_frog_offset + 2      ; what direction is karl looking at 
last_joy_x          EQU      current_frog_heading + 1     ; last joystick position X, 
last_joy_y          EQU      last_joy_x + 1               ; and Y, for checking, we don't want an autorun feature... 
current_frog_brightness  EQU  last_joy_y + 1              ; current brightness of karl, 
high_check          EQU      current_frog_brightness + 1  ; checker variable for new life (every 10000 points) 
frog_pos            EQU      high_check + 1               ; position 16bit y,x of frog 
frog_y              EQU      frog_pos                     ; y pos of frog 
frog_x              EQU      frog_y + 1                   ; and the x 
frog_pos_band       EQU      frog_x + 1                   ; band information (ranging from 0-11), y,x 
frog_y_band         EQU      frog_pos_band                ; band y information 
frog_x_band         EQU      frog_y_band + 1              ; band y information 
frog_pic            EQU      frog_x_band + 1              ; now used frog 'picture' 
my_timer_start      EQU      frog_pic + 2                 ; reset value of level timer 
y_timer             EQU      my_timer_start + 2           ; y value of my timer vector line 
my_timer            EQU      y_timer + 1                  ; x value of vector line (8bit) AND the timer variable itself (16bit) variable 
fly_timer           EQU      my_timer + 2                 ; timer variable for fly 
stringBufferTemp    EQU      fly_timer                    ; for option screen is never at the same time as game, so we can double use RAM 
fly_timer_start     EQU      fly_timer + 2                ; reset value of fly timer 
fly_house           EQU      fly_timer_start + 2          ; what house is the fly currently in 
fly_status          EQU      fly_house + 1                ; what's the flys status? 
croco_timer         EQU      fly_status + 1               ; croco (home) timer variable 
croco_timer_start   EQU      croco_timer + 2              ; croco timer reset 
croco_house         EQU      croco_timer_start + 2        ; what house is the croco currently 'visiting' 
croco_status        EQU      croco_house + 1              ; what's the crocos status 
dive_timer          EQU      croco_status + 1             ; (turtle) dive timer variable 
dive_timer_start    EQU      dive_timer + 2               ; reset value for the above 
frog_bonus          EQU      dive_timer_start + 1         ; what bonuses has frog collected? (girl, fly) 
otter_status        EQU      frog_bonus + 1               ; what's the otters status 
otter_timer_start   EQU      otter_status + 1             ; otter timer reset value 
otter_timer         EQU      otter_timer_start + 2        ; otter timer variable 
current_highscore_gameMode  equ  otter_timer 
otter_log_pre       EQU      otter_timer + 2              ; the 'logs' address of the 'log' BEFOR the otter 
otter_log_past      EQU      otter_log_pre + 2            ; the 'logs' address of the 'log' BEHIND the otter 
otter_object        EQU      otter_log_past + 2           ; the object information address of current otter 
otter_pos           EQU      otter_object + 2             ; current position of otter 
otter_anim_counter  EQU      otter_pos + 2                ; animation counter of otter 
otter_speed         EQU      otter_anim_counter + 1       ; current speed of otter 
otter_band          EQU      otter_speed + 1              ; what band is otter swimming in? 
girl_status         EQU      otter_band + 2               ; what's the girls status? 
girl_round_counter  EQU      girl_status + 1              ; counter, for what round girl will be next displayed 
girl_round_counter_reset  EQU  girl_round_counter + 1     ; counter reset value 
girl_log_object     EQU      girl_round_counter_reset + 1 ; log, the girl is on, allways first log on second river band 
                                                          ; following is an exact list object structure... for girl 
girl_object         EQU      girl_log_object + 2          ; pointer to current girl object information 
girl_pos            EQU      girl_object + 2              ; current position of girl 
girl_anim_counter   EQU      girl_pos + 2                 ; animation counter of girl 
girl_zero           EQU      girl_anim_counter + 1        ; allways a 16 bit zero, to jump out of the loop... 
girl_speed          EQU      girl_zero + 2                ; speed of girl 
snake_status        EQU      girl_speed + 1               ; snake's status (only one snake on logs possible for now) 
snake_round_counter  EQU     snake_status + 1             ; counter, for what round snake will be next displayed (variable) 
snake_round_counter_reset  EQU  snake_round_counter + 1   ; reset value for above 
snake_log_object    EQU      snake_round_counter_reset + 1 ; 'log', the snake is on, allways first log on third river band!!! 
snake_object        EQU      snake_log_object + 2         ; pointer to snake's object definition 
eeprom_tmp          EQU      snake_log_object + 2 
snake_pos           EQU      snake_object + 2             ; position of snake (y,x) 
hs_reset_tmp        equ      snake_pos + 2 
snake_anim_counter  EQU      snake_pos + 2                ; animation counter for snake 
snake_gone          EQU      snake_anim_counter+1         ; number of steps a snake can make before turing arround 
snake_speed_start   EQU      snake_gone + 1               ; startspeed of snake (determined by 'log's' speed) 
snake_speed         EQU      snake_speed_start+1          ; speed of snake now 
i_jump              EQU      snake_speed + 1              ; indirect jump for vector list drawing unlooped 
current_eprom_blocksize  equ  i_jump 
current_eprom_blockadr  equ  i_jump+1 
nextMusic           equ      i_jump +2                    ; word 
currentPlayer       equ      nextMusic+2                  ; 0 = player 1, 1 = player 2 
currentSelectedOption  EQU   currentPlayer+1              ; for the option menu, to know which one is hilighted 
;;;;;;;;;
; one complete set of player information
; this is copy to and from when the players switch
; there is RAM enough to spare, I just didn't want a 3 or 4 player game... (pl 3+4 scores could be on the bottom)
; player 1
;;;;;;;;;
P1_start            EQU      currentSelectedOption+1 
P1_score_digit_front  EQU    P1_start+0                   ; $81 
P1_score_digit_5    EQU      P1_start+1 
P1_score_digit_4    EQU      P1_start+2 
P1_score_digit_3    EQU      P1_start+3 
P1_score_digit_2    EQU      P1_start+4 
P1_score_digit_1    EQU      P1_start+5 
P1_score_digit_SPACE1  EQU   P1_start+6 
P1_score_digit_LIFES  EQU    P1_start+7 
P1_score_digit_SPACE2  EQU   P1_start+8 
P1_score_digit_Level  EQU    P1_start+9 
P1_score_digit_back  EQU     P1_start+10                  ; $81 
P1_no_frogs         EQU      P1_score_digit_back+1 
P1_level            EQU      P1_no_frogs+1 
P1_homes            EQU      P1_level+1 
P1_in_home_counter  EQU      P1_homes+1 
P1_end              EQU      P1_in_home_counter+25 
;;;;;;;;;
; one complete set of player information
; this is copy to and from when the players switch
; there is RAM enough to spare, I just didn't want a 3 or 4 player game... (pl 3+4 scores could be on the bottom)
; player 2
;;;;;;;;;
P2_start            EQU      P1_end 
P2_score_digit_front  EQU    P2_start+0                   ; $81 
P2_score_digit_5    EQU      P2_start+1 
P2_score_digit_4    EQU      P2_start+2 
P2_score_digit_3    EQU      P2_start+3 
P2_score_digit_2    EQU      P2_start+4 
P2_score_digit_1    EQU      P2_start+5 
P2_score_digit_SPACE1  EQU   P2_start+6 
P2_score_digit_LIFES  EQU    P2_start+7 
P2_score_digit_SPACE2  EQU   P2_start+8 
P2_score_digit_Level  EQU    P2_start+9 
P2_score_digit_back  EQU     P2_start+10                  ; $81 
P2_no_frogs         EQU      P2_score_digit_back+1 
P2_level            EQU      P2_no_frogs+1 
P2_homes            EQU      P2_level+1 
P2_in_home_counter  EQU      P2_homes+1 
P2_end              EQU      P2_in_home_counter+25 
;;;;;;;;;
timeLeft            EQU      P2_end +1                    ; ASCII - generated String "TIME xxx",$81 
skipCount           EQU      timeLeft+9                   ; I count the number of "sprites" to skip in each level, when level is initialized 
skipCount_now       EQU      skipCount+1                  ; these "skipped" will not be displayed, when a frog reached home (and the time is display) - would be over 50Hz otherwise 
levelFromOptions    EQU      skipCount_now+1 
startDataPos        EQU      levelFromOptions+1           ; used by ym player 
nextDataPos         EQU      startDataPos+ 2              ; used by ym player 
currentDataBitPos   EQU      nextDataPos+2                ; used by ym player 
currentDataByte     EQU      currentDataBitPos+ 1         ; used by ym player 
froggerInJump       EQU      currentDataByte+1            ; a jump phase of the frog consists of 7 steps, countdown to 0, this is where current step is stored 
froggerAnimPointer  EQU      froggerInJump+1              ; pointer to the animation sprite object structure for the current frog animation step 
inMovePointer       equ      froggerAnimPointer +2        ; pointer to the subroutine that gets executed during a "move" - that is always one part of the ym unpacker 
RecalCounter        equ      inMovePointer +2             ; similar var to BIOS Vec_Loop_Count, this gets increased ones every cycle (but also reseted), 
                                                          ; recoded movements are synced to that counter, also some intensity effects 
RecalCounterHi      equ      RecalCounter 
RecalCounterLow     equ      RecalCounter +1 
my_random           equ      RecalCounter +2 
frogDeath           equ      my_random +1                 ; indicator flag that we are in a death sequence intermission 
ds2431Present       equ      frogDeath+1                  ; flag whether the eEprom was found or not 
ignoreDs2431        equ      ds2431Present+1              ; flag whether to ignore eEprom altogether (button on startup), VecFlash gets irritated by PB6 access 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; -> 9*5 +3 = 48 byte
; this is the "old" save structure
; uses verbatim "bytes
; during a "save" this gets converted to "new save structure"
; which is reduced to use only 32 bytes
; if I wasn't so lazy, than I would have gotton rid
; of the old structure, as it is now it adds to confusion :-)
; anyways, in highscore editing and displaying - the "old" structure is used
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                    struct   HighScoreEntry 
                    ds       NAME,3                       ; 
                    ds       LEVEL,1                      ; 
                    ds       ASCIISCORE,6                 ; 
                    end struct 
; save to eEprom Starts here!
optionsBlock        equ      ignoreDs2431+1 
v4e_saveBlockStart  equ      optionsBlock 
;eepromRAMStart      EQU     optionsBlock
playerCountOption   equ      optionsBlock                 ; 0 = 1 player, 1 = 2 player game 
gameModeOption      equ      playerCountOption+1          ; 0 = tournament, 1 = training, 2 Hardcore 
musicOption         equ      gameModeOption+1             ; 0 = on, 1 = off 
levelEditAllowed    equ      musicOption+1                ; 0 = no, 1 = yes 
optionsBlockEnd     equ      levelEditAllowed+1+4         ; 8 byte at least for a block 
highScoreCompetitionBlock  equ  optionsBlockEnd 
highScoreTable      equ      highScoreCompetitionBlock 
highScoreTableEnd   EQU      highScoreTable + HighScoreEntry*5 ; 5 entries 
highScoreCompetitionBlockEnd  equ  highScoreTableEnd 
highScoreHardcoreBlock  equ  highScoreCompetitionBlockEnd 
highScoreHardTable  equ      highScoreHardcoreBlock 
highScoreHardTableEnd  EQU   highScoreHardTable + HighScoreEntry*5 ; 5 entries 
highScoreHardcoreBlockEnd  equ  highScoreHardTableEnd 
v4e_saveBlockEnd    equ      highScoreHardcoreBlockEnd 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
newEepromRAMStart   equ      highScoreHardcoreBlockEnd    ; new save struct, straight 32 bytes 
newEepromRAMEnd     equ      newEepromRAMStart +32        ; of which only 28 bytes are used! 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
conversionBuffer    EQU      newEepromRAMEnd              ; internal buffer used by conversion ASCII <-> 16 bit value (in D) vice/versa [values from 0 to 65536*10 + $80] 
highScoreTmpBuffer  EQU      conversionBuffer+7           ; one "0" is added to achieve the tenfold length of 16 bit! (which cant be displayed - hahaha!) 

highScoreLevel      EQU      highScoreTmpBuffer+14                ; the level of the highscore that was reached, a "transport" byte from death sequence to HighScore sequence 



currentHSEditPlace  EQU      highScoreLevel+1             ; one of the three possible letters 
currentHSEditBlinkState  EQU  currentHSEditPlace+1        ; 
hsEditLetter1       EQU      currentHSEditBlinkState+1    ; three letters can be edited, 
hsEditLetter2       EQU      hsEditLetter1+1              ; these hold the actual ASCII values 
hsEditLetter3       EQU      hsEditLetter2+1 
isAttractMode       EQU      hsEditLetter3+1              ; are we playing in attract mode? 0= no, 1 = yes (no score, no joystick, joystick recording is taken etc) 
attractMovePointer  EQU      isAttractMode+1              ; pointer to joystick data of the current attract mode setting 
buttonBlinker       EQU      attractMovePointer+2         ; blink state of the "press button" in attract mode 
buttonBlinkerIntensity  EQU  buttonBlinker+1              ; 
attractCount        EQU      buttonBlinkerIntensity+1     ; number of the next attract level to be displayed 
levelDoneTemp       EQU      attractCount+1               ; just a temp, that is not one of the above, which already were used 
highScorePlace      EQU      levelDoneTemp +1             ; more of above "transport" vars, what place did the high score reach? 
highScoreReached    EQU      highScorePlace + 1           ; did we get a highscore at all? 
highScoreDone       EQU      highScoreReached +1          ; whatWAS the actual score? 
current_brightness  EQU      highScoreDone +2             ; currently set brightness (why didn't I use the vectrex's os variable???) 
initMoveTable       equ      current_brightness+1         ; current pointer to frog movement in title screen 
gimmickPossible     equ      initMoveTable+2              ; 1 = gimick not possible, 0 = possible 
gimmickActive       equ      gimmickPossible+2            ; 1= active, 0 = not active 
gimmick_status      EQU      gimmickActive + 1            ; what's the gimmick status? 
gimmick_object      EQU      gimmick_status + 1           ; pointer to current gimmick object information 
gimmick_pos         EQU      gimmick_object + 2           ; current position of gimmick 
gimmick_anim_counter  EQU    gimmick_pos + 2              ; animation counter of gimmick 
gimmick_speed       EQU      gimmick_anim_counter + 1     ; speed of gimmick 
gimmick_countdown   EQU      gimmick_speed + 1            ; countdown, # of cycles this gimicks "plays" 
gimmick_pointer     EQU      gimmick_countdown + 1        ; pointer to next gimmick in table of all gmmicks 
levelString         equ      gimmick_pointer+2            ;"LEVEL 1",81 
did_rollOver        equ      levelString+9 
TWINKLE_COUNT       equ      6                            ; six twinkle in title possible at the same time 
twinklers           equ      did_rollOver+1               ; twinklers+TWINKLE_COUNT*(Twinkle) ; 6 structures of twinklers like (following) 
                    struct   Twinkle 
                    ds       TWINKEL_Y,1                  ; some data here is redundant, but I didn't change it - enough RAM :-) 
                    ds       TWINKEL_X,1                  ; 
                    ds       TWINKLE_ANGLE,1              ; 
                    ds       TWINKLE_BRIGHTNESS,1         ; 
                    ds       TWINKLE_LENGTH,1             ; 
                    ds       TWINKLE_COUNTER,1            ; 
                    ds       TWINKLE_WAIT,1               ; 
                    end struct 
; for easier debugging
twinkle1_y          equ      twinklers 
twinkle1_x          equ      twinklers+1 
twinkle1_angle      equ      twinklers+2 
twinkle1_brighness  equ      twinklers+3 
twinkle1_length     equ      twinklers+4 
twinkle1_counter    equ      twinklers+5 
twinkle1_wait       equ      twinklers+6 
user_ram_end        EQU      twinklers                    ; end of user ram 
;
;
; these are the addresses used in the game 
; that ram is used during the game to keep track of sprite movement 
; and house occupants
HOME_OBJECT_SIZE    equ      (5) 
LIST_OBJECT_SIZE    equ      (5) 
home_objects        EQU      user_ram_end 
home_entry_1        EQU      home_objects 
home_entry_2        EQU      home_objects+1*HOME_OBJECT_SIZE 
home_entry_3        EQU      home_objects+2*HOME_OBJECT_SIZE 
home_entry_4        EQU      home_objects+3*HOME_OBJECT_SIZE 
home_entry_5        EQU      home_objects+4*HOME_OBJECT_SIZE 
home_end            EQU      home_objects+5*HOME_OBJECT_SIZE 
object_list         EQU      home_end 
object_list_end     EQU      object_list+(LIST_OBJECT_SIZE)*30+2 
band_list           EQU      object_list_end 
band_list_end       equ      band_list+ 12*(8*2) 
t_list              EQU      band_list_end                ; start of dive object list 
t_list_end          EQU      (t_list+2*6+2)               ; note maximum of 6 dives per level 
;
;
; morphing uses ram occupied by the game, therefor only be used
; as start, end or in between sequences
current_morph_vectorlist_org  EQU  (object_list) 
current_morph_vectorlist  EQU  (current_morph_vectorlist_org+2*MAX_VECTOR_MORPH+1) 
current_morph_vector_diffs  EQU  (current_morph_vectorlist+2*MAX_VECTOR_MORPH+1) 
end_of_my_ram       EQU      current_morph_vector_diffs+2*MAX_VECTOR_MORPH 
; end by current_morph_vector_diffs + 2*MAX_VECTOR_MORPH
;
;
; following vars use BIOS ram locations, these BIOS routines are not used by Karl Quappe and can thus
; be reused here! 
; 
currentMusic        equ      $C868                        ; ym player used 
currentYLenCount    equ      $C86a                        ; ym player used 
currentSFX          equ      $C86e                        ; sfx player used 
sfx_pointer_3       equ      $C870                        ; sfx player used 
sfx_status_3        equ      $C872                        ; sfx player used 
intermissionActive  equ      $C873                        ; flag whether an intermission is active ( see also "frogDeath") 
no_frogs            equ      $C874                        ; current number of lives left to current player 
bonusScore          equ      $C875                        ; flag whether to display a little "200" above the home sprite 0=none, 1 = "200", 2 = "200 200" 
no_frogs2           equ      $C876                        ; number of frogs the previous active player had left after playing (in one player game same as no_frogs) 
highScoreEditMode   equ      $C878                        ; is the high score "viewer" in editor mode? 
;
;
; default BIOS highscore place
; using also IRQ spaces, which are not used by frogger
; following locations keep the entries that are displayed
; as the player score during game play
score_digit_front   EQU      $CBEB+0                      ; $81 
score_digit_5       EQU      $CBEB+1 
score_digit_4       EQU      $CBEB+2 
score_digit_3       EQU      $CBEB+3 
score_digit_2       EQU      $CBEB+4 
score_digit_1       EQU      $CBEB+5 
score_digit_SPACE1  EQU      $CBEB+6 
score_digit_LIFES   EQU      $CBEB+7 
score_digit_SPACE2  EQU      $CBEB+8 
score_digit_Level   EQU      $CBEB+9 
score_digit_back    EQU      $CBEB+10                     ; $81 
;
;
; following are some 'in' game variables which can be reused, they do not
; collide with the other side...
loop1               EQU      tmp1                         ; loop1 counter in level setup 
loop2               EQU      tmp1 + 1                     ; loop2 counter in level setup 
divide_tmp          EQU      mul_tmp1                     ; divide tmp variable, you don't divide while multiplying vice versa 
tmp_band_offset     EQU      mul_tmp1                     ; used in level setup and gameplay, but there is NO multiplication in game... 
tmp_band_list       EQU      mul_tmp2                     ; used in level setup 
counter             EQU      mul_tmp2                     ; counter used in intermissions 
game_over_intensity  EQU     current_frog_size_x          ; intensity of game over text 
game_over_scaley    EQU      current_frog_offset          ; 16 bit ok scale y of game over string 
game_over_scalex    EQU      current_frog_offset+1        ; scale x of game over string 
game_over_ypos      EQU      last_joy_x                   ; 16 bit ok game over y position 
game_over_xpos      EQU      last_joy_y                   ; game over x position 
;
;
; variables that are only used on startup screen
; these use the same namespace as the above variables below
init_screen_mode    EQU      morph_div_jsr + 2 
init_current_intensity  EQU  init_screen_mode + 1 
;
;
;
; see bottom of file for further addresses!
; following are a lot of constants which I declared for 'better'
; readability (and to keep things variable (constant<->variable!!!)) of the source...
; these are not really well sorted...
OTTER_X_LEN         EQU      10                           ; size of otter (x) for collision checking 
SNAKE_GO_LIMIT      EQU      55                           ; number of 'pixels' a snake can go before turing arround 
;
; following are some status constants used for turtle, snake, otter, fly, girl and croco
NOT_AVAILABLE       EQU      0                            ; not in this level at all (is not checked for, only via ZERO flag!!!) 
IS_CARRIED          EQU      1                            ; the object (girl) is carried by frog 
IS_DISPLAYED        EQU      2                            ; the object is currently visible 
IS_WAITING          EQU      3                            ; the object is waiting to be displayed 
NOT_DIVING          EQU      0                            ; turtle is not diving (under water) right now 
IS_DIVING           EQU      1                            ; the turtle is under water (frog can drown) 
;
; bonus BIT MAPS, only two for now, these are AND or ORed
FLY_BONUS           EQU      $1                           ; if set a fly bonus is awarded 
GIRL_BONUS          EQU      $2                           ; if set a girl bonus is awarded 
;
; morphing stati...
MORPHING_DONE       EQU      (lo(10))                     ; this morphing structure finnished 
MORPHING_WORKING    EQU      (lo(11))                     ; is morphing 
MORPHING_COMPLETE   EQU      (lo(0))                      ; no more morphing 
;
; and general morphing constants
MAX_VECTOR_MORPH    EQU      (lo(63))                     ; this uses 128*3 bytes of RAM, maximum number of vectors for a morph 
MORPH_STARTUP_DELAY  EQU     (lo(80))                     ; constants used in init morph 
MORPH_STEPS_INTRO   EQU      (lo(15)) 
MORPH_DELAY_INIT    EQU      (lo(2)) 
MORPH_STEPS_Z       EQU      (lo(15))                     ; below is history, morphing is 
                                                          ; now fixed and allways done with 
                                                          ; 16 steps!!! 
                                                          ; 
                                                          ; number of steps between first and second object 
                                                          ; this actually uses shift rights to implement 32 steps between vectors 
                                                          ; here allways the actual number of steps -1 
                                                          ; !!! all values supported, but only 
                                                          ; 8, 16, 32, 64 are using shift as divs!!! 
                                                          ; other values will be SLOW 
                                                          ; (about 10000 cycles per round) 
;
; they always appear somewhere... truth values :-)
FALSE               EQU      (lo(0)) 
TRUE                EQU      (lo(1)) 
;
; vectrex coordinates use range from -128 to +127
; these top and bottom values are for scale factor $ff
SCREEN_TOP          EQU      (lo($7f)) 
SCREEN_BOTTOM       EQU      (lo(-$80)) 
SCREEN_LEFT         EQU      (lo(-$80)) 
SCREEN_RIGHT        EQU      (lo($7f)) 
SCREEN_CENTER       EQU      (lo(0)) 
;
; different sizes of texts, in format yx, note: different ranges for y and x!
NORMAL_TEXT_SIZE    EQU      $F160                        ; big text that is 
LITTLE_TEXT_SIZE    EQU      $fb30                        ; fairly small text 
SCORE_TEXT_SIZE     EQU      $f530                        ; 'middle' big text :-) 
;
; following are SPECIAL definitions for special objects
; these must be set in the object definition
SPECIAL_CROCO_FULL  EQU      $81 
SPECIAL_CROCO_HALF  EQU      $82 
SPECIAL_HOME_FLY    EQU      $83 
SPECIAL_RIGHT_CROCO  EQU     $84 
SPECIAL_LEFT_CROCO  EQU      $85 
SPECIAL_RIGHT_SNAKE  EQU     $16 
SPECIAL_LEFT_SNAKE  EQU      $17 
SPECIAL_GIRL        EQU      $20                          ; note: the $20 in this and the next two 
SPECIAL_GIRL_RIGHT  EQU      $20                          ; is ANDed and compared to... 
SPECIAL_GIRL_LEFT   EQU      $21 
SPECIAL_DIVE        EQU      $40                          ; note: the $40 in this and the next two 
SPECIAL_DIVE_UP     EQU      $40                          ; is ANDed and compared to... 
SPECIAL_DIVE_DOWN   EQU      $41 
;
; scale factors used in the game (all different for optimization :-) :-( )
SCALE_FACTOR_GRID   EQU      $ea                          ; the virtual grid, which everything is set in 
SCALE_FACTOR_GAME   EQU      $91                          ; every (nearly) positioning is made with 
SCALE_FACTOR_HOME   EQU      $1c                          ; scale factor for drawing the homes 
SCALE_IN_HOME       EQU      $83                          ; scale factor for objects within an home 
SCALE_FACTOR_SPRITE  EQU     $6                           ; all sprites are drawn using this scale factor 
SCALE_FACTOR_VECTOR_MORPH  EQU  $70                       ; scale factor for morphing objects... 
;
; these positions describe where the objects
; will appear/disappear on the screen
BOUNDARY_HI         EQU      (lo(112))                    ; right boundary of playfield 
BOUNDARY_LO         EQU      (lo(-122))                   ; left boundary of playfield 
MAX_SPRITE_OFFSET   EQU      5                            ; supposed to maximal sprite offset 
                                                          ; this value is added to the repositioning of sprites 
                                                          ; if they move out of bounds and go to the other side 
                                                          ; to prevent going out of bounds right away again 
                                                          ; because of thei offset 
                                                          ; 
                                                          ; I'm not sure all sprites keep this maximum 
                                                          ; this may 'cause random repositioning of sprites 
                                                          ; a known problem, but I didin't increase this, since the 
                                                          ; actual playing area is already quite small as it is... 
;
; following are some 'blowup' factors applied to various objects (for optimization)
; these factors must be set that the resulting coordinate is still below 127
; for optimization the resulting vectors should be pretty near 127
; and the scale factor be set that it is the smallest possible value!
SPRITE_BLOW_UP      EQU      25                           ; thru this sprites get a possible max of 5 * 25 = 125 (pretty near 127...) 
HOME_BLOW_UP        EQU      8                            ; ... 
VEC_BLOWUP          EQU      12                           ; max vector 5 for now, double == 10 times 12 = 120, max would be 128... 
;
; grid size of the virtal grid in different scale factors
GRID_SIZE_GAME      EQU      16                           ; (10*($ea/$91)), for SCALE_FACTOR_GRID 
GRID_SIZE           EQU      10                           ; for scale factor $ff 
                                                          ; max 10, so that 12*GRID_SIZE still <= 127 
                                                          ; size can than be altered using scale factor 
                                                          ; I want to draw all lines in one 
                                                          ; go, so 10 is max here :-( 
                                                          ; otherwise I could scale the sprites 
                                                          ; with the same scaling value... 
;
; frogger constants
; following are position information as to where the houses are located
; in SCALE_FACTOR_GAME
HOME1_POS_LEFT      EQU      (lo(178)) 
HOME1_POS_RIGHT     EQU      (lo(193)) 
HOME2_POS_LEFT      EQU      (lo(210)) 
HOME2_POS_RIGHT     EQU      (lo(225)) 
HOME3_POS_LEFT      EQU      (lo($f3)) 
HOME3_POS_RIGHT     EQU      (lo(2+2)) 
HOME4_POS_LEFT      EQU      (lo(20)) 
HOME4_POS_RIGHT     EQU      (lo(35+2)) 
HOME5_POS_LEFT      EQU      (lo(53)) 
HOME5_POS_RIGHT     EQU      (lo(68+2)) 
;
; following are for constants for checking which way frogger heads
; value of these is of no importance, just difference...
HEADING_RIGHT       EQU      (lo(1)) 
HEADING_LEFT        EQU      (lo(2)) 
HEADING_DOWN        EQU      (lo(3)) 
HEADING_UP          EQU      (lo(4)) 
;
; start position of frog in GRID_SIZE GAME
FROG_INIT_YPOS      EQU      (lo((-GRID_SIZE_GAME)*6)) 
FROG_INIT_XPOS      EQU      (lo(6)) 
FROG_INIT_POS       EQU      FROG_INIT_YPOS*256 + FROG_INIT_XPOS 
;
; start band of frog in (0-12) in GRID POSITION
FROG_INIT_YPOS_BAND  EQU     (lo(12))                     ; home band is twelf (in memory) 
FROG_INIT_XPOS_BAND  EQU     (lo(7))                      ; six is middle 
FROG_INIT_POS_BAND  EQU      FROG_INIT_YPOS_BAND*256 + FROG_INIT_XPOS_BAND 
;
; number of 'pixels' one jump takes the frog...
; obviously in GRID_SIZE_GAME - for animation of frog, this should be divideable by 8!
FROG_X_JUMP         EQU      GRID_SIZE_GAME 
FROG_Y_JUMP         EQU      GRID_SIZE_GAME 
;
; sizes of the different frog objects...
; since all the same, I don't use them anymore...
FROG_SIZEX_RIGHT    EQU      9 
FROG_SIZEX_LEFT     EQU      9 
FROG_SIZEX_DOWN     EQU      9 
FROG_SIZEX_UP       EQU      9 
;
; positions of where frog will be considered to be out of bounds...
; in GAME position
;
FROG_RIGHT_OUT      EQU      (lo(110)) 
FROG_LEFT_OUT       EQU      (lo(-110)) 
;
; some positioning variables for the score information display...
; in screen coordinates
SCORE_YPOS          EQU      (SCREEN_TOP-8) 
SCORE_XPOS          EQU      (SCREEN_LEFT+8) 
LEVEL_YPOS          EQU      (SCREEN_TOP-8) 
LEVEL_XPOS          EQU      (lo(0-30)) 
FROGS_YPOS          EQU      (SCREEN_TOP-8) 
FROGS_XPOS          EQU      (SCREEN_RIGHT-60) 
;
HOME_Y_POS          EQU      106 
HOME_X_POS          EQU      -80 
HOME_X_WIDTH        EQU      36 
;
; following are some 'private' makro definitions
; most of them have been splitted into the main source by now
                    INCLUDE  "MY_MAKRO.I"
                    INCLUDE  "UNLOOP.I"                   ; makros for unlooping
                    INCLUDE  "InMoves.i"                  ; subroutines for "in move pauses"
;
; it turns out, sorting the different displayed 
; vector drawing parts influences the
; stability of the screen,
; so e.g. printing the score (a fixed display)
; after moving or blinking parts -> is a bad idea
; since the score is also slightly displaced...
POSSIBLE_RESET1     macro    
; jsr smallCalibration 
                    endm     
POSSIBLE_RESET2     macro    
;                    jsr      calibration 
                    endm     
POSSIBLE_RESET3     macro    
; jsr smallCalibration 
                    endm     
POSSIBLE_RESET4     macro    
; jsr smallCalibration 
                    endm     
POSSIBLE_RESET5     macro    
; jsr smallCalibration 
                    endm     
;***************************************************************************
                    ORG      0 
; start of vectrex memory with cartridge name...
                    DB       "g GCE 2017", $80 ; 'g' is copyright sign
                    DW       music7                       ; music from the rom 
                    DB       $F8, $50, $20, -$40          ; hight, width, rel y, rel x (from 0,0) 
game_name: 
                    DB       "KARL QUAPPE", $80           ; some game information, ending with $80
                    DB       0                            ; end of game header 
;***************************************************************************
; here the cartridge program starts off
;***************************************************************************
                    bra      entry_point 

timeStringBASE: 
                    db       "TIME xx", $81
timeStringBASEEnd: 
backMainMenu: 
                    db       "<BACK>", $80 
;***************************************************************************
; MAGIC CARTHEADER SECTION
;      DO NOT CHANGE THIS STRUCT
;***************************************************************************
                    ORG      $30 
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
v4eStorageID                                              ;       fcb      "MAL1"; ; 4 bytes storage identifier 
                                                          ; 
                    fcb     "M8KQ"
                                                          ; end of v4e cart header 
                                                          ; 
levelStringBASE: 
                    db       "LEVEL  1", $81
levelStringBASEEnd: 
continue_string 
pressButton 
                    db       "PRESS BUTTON",$81
defaultValuesEeprom: 
;                    db       0,0,0,0                      ; playerCountOption, gameModeOption, musicOption. levelEditAllowedOption 
;                    db       "MAL", 0, "  1000"
;                    db       "MAL", 0, "   500"
;                    db       "MAL", 0, "   400"
;                    db       "MAL", 0, "   300"
                    db       "MAL", 0, "   100"
;                    db       0                            ; filler 
;                    db       0                            ; checksum 
copyDefaults 
                    ldd      #0 
                    std      optionsBlock 
                    std      optionsBlock+2 
                    std      optionsBlock+4 
                    std      optionsBlock+6 
                    ldx      #highScoreCompetitionBlock 
                    ldy      #highScoreHardcoreBlock 
                    ldb      #5                           ; 5 * 10 
                    stb      tmp1 
copyEvenMore: 
                    ldb      #10                          ; 5 * 10 
                    ldu      #defaultValuesEeprom 
copyMore: 
                    lda      ,u+ 
                    sta      ,x+ 
                    sta      ,y+ 
                    decb     
                    bne      copyMore 
                    dec      tmp1 
                    bne      copyEvenMore 
                    rts      

;debug_print
; DEBUG_PRINT__
; rts     
;null db "000",$80
;eins db "111",$80
;zwei db "222",$80
;store db "STORE",$80
;vier db "444",$80
;viera db "4 A",$80
;fuenf db "555",$80
;sechs db "666",$80
;defaults db "DEFAULT",$80
;
;  DEBUG_PRINT eins
;
; Do one time initializations
entry_point: 
; DEBUG_PRINT eins
                    clr      attractCount                 ; number of first attract mode 
                    clr      highScoreEditMode            ; not in highscore edit mode 
                    clr      ignoreDs2431                 ; we assume a eEprom is available 
                    ldx      #initMoveTable_addresses     ; movement of frog in title screen default 
                    stx      initMoveTable 
                    ldx      #gimickTable 
                    stx      gimmick_pointer 
; check if we should ignore eEprom completly (Button press on startup)
                    if       USE_PB6 = 1 
                    JSR      Read_Btns                    ; get button status 
                    CMPA     #$00                         ; is a button pressed? 
                    beq      noignore 
                    else 
                    endif
                    inc      ignoreDs2431                 ; yes, than set ignore flag 
noignore 
                    ldx      v4eStorageLoaded             ; check if v4e did load bytes from storage area 
                    bne      noScoreDefaults              ; if != 0, than yes -> jump 
                    bsr      copyDefaults                 ; initiate eEprom Highscore defaults 
                    lda      v4ecartflags                 ; check if there is any v4e at all? 
                    bpl      nov4e                        ; if not (positive) jump 
                    jsr COPY_RAM_TO_VECROM                    ; otherwise fill the (usual) ROM with default values (v4e this is RAM to!) 
nov4e 
noScoreDefaults 
                    jsr      checkEprom                   ; is there an eprom (ignore flag always checked in eeprom routines) 
                                                          ; eprom saves valus in three stages, to keep times smaller (when only block save is needed) 
                    ldd      #(EEPROM_STORESIZE_OPTIONS*256)+EEPROM_OPTION_BLOCK 
                    std      current_eprom_blocksize 
                    ldx      #optionsBlock 
                    jsr      eeprom_load_option           ; load eprom data (also resets if no data found) 
                    lda      v4ecartflags                 ; check if there is any v4e at all? 
                    bmi      donotSaveagain               ; if yes, than don't save the same stuff 3 times, poor Flash... 
                    ldd      #(EEPROM_STORESIZE_HS*256)+EEPROM_HS1_BLOCK 
                    std      current_eprom_blocksize 
                    ldx      #highScoreCompetitionBlock 
                    jsr      eeprom_load_highscore        ; load eprom data (also resets if no data found) 
                    ldd      #(EEPROM_STORESIZE_HS*256)+EEPROM_HS2_BLOCK 
                    std      current_eprom_blocksize 
                    ldx      #highScoreHardcoreBlock 
                    jsr      eeprom_load_highscore        ; load eprom data (also resets if no data found) 
donotSaveagain 
                    lda      #8 
                    ldu      #timeStringBASE 
                    ldx      #timeLeft 
                    jsr      Move_Mem_a 
                    lda      #9 
                    ldu      #levelStringBASE 
                    ldx      #levelString 
                    jsr      Move_Mem_a 
                    lda      #1 
                    sta      levelFromOptions             ; default level 1 
                    ldd      #emptyStreamInMove           ; first jumper of ym decoder -> direct RTS 
                    std      inMovePointer 
                    ldd      #0                           ; no music is played 
                    std      nextMusic 
                    sta      isAttractMode                ; we are not in attract mode 
; done with one times
;
; new game will always start here
new_game: 
                    JSR      init_vars                    ; initialize game variables 
                    JSR      init_screen                  ; startup screen 
                                                          ; init_screen messes up variables, 
                                                          ; so init them again :-) 
                    JSR      init_vars                    ; initialize game variables 
; entry point for attract mode from main menu
attractEnter: 
                    clr      RecalCounter                 ; starting attract mode resets counter 
                    clr      RecalCounter+1               ; otherwise joystick simulation would not sync 
                    clr      my_random 
                    JSR      setup_level                  ; set up the first level 
                    clr      currentPlayer                ; player 1 first 
                    lda      playerCountOption            ; if there are two players, we first must set up there 
                    beq      NoSavecheckAndOut            ; RAM save structures 
                    ldu      #P1_start                    ; init save structures 
                    jsr      savePlayer 
                    ldu      #P2_start 
                    jsr      savePlayer 
NoSavecheckAndOut 
restart_game: 
                    _DP_TO_D0                             ; round_startup_main expects dp set to d0 
                    CLR      Vec_Music_Flag               ; no music is playing ->0 
                    JSR      Init_Music_Buf               ; shadow regs 
                    JSR      Do_Sound                     ; ROM function that does the sound playing 
                    INIT_MUSICl  gameStartMusic 
main_loop: 
                    ROUND_STARTUP_MAIN                    ; well, this does the round initializing, main optimized special 
                    lda      froggerInJump                ; is a "old" jump still ongoing? 
                    bne      noJoystickQueryNeeded 
                    jsr      query_joystick 
                    direct   $d0                          ; after draw objects, dp is set to d0 
noJoystickQueryNeeded: 
                                                          ; splitted, saves one DP_TO_C8! 
                    JSR      draw_objects                 ; draw all graphical elements (and does everything else, since everything else is "in move" now) 
                    lda      gimmickPossible              ; only when not 1 level and only when 0 or 1 house is occupied 
                    lbne     nogimickDisplay 
                    lda      intermissionActive           ; no gimmick in intermission 
                    lbne     nogimickDisplay 
                    lda      isAttractMode                ; no gimick in attrackt 
                    lbne     nogimickDisplay 
                    lda      gameModeOption               ; no gimick while training 
                    lbne     nogimickDisplay 
                    LDB      y_timer+1                    ; load new vector (length was cut by timer :-)) 
                    CMPB     #40                          ; is it small yet? 
                    BGT      nogimickInit 
                    lda      current_frog_heading 
                    cmpa     #HEADING_DOWN 
                    bne      nogimickInit 
                    tst      gimmickActive 
                    bne      nogimickInit 
                    INIT_GIMICK  
nogimickInit 
                    tst      gimmickActive 
                    lbeq     nogimickDisplay 
                    DISPLAY_GIMICK  
                    PLAY_SFX_IF_NOTHING_ELSE  KarlGimmickSound 
                    lda      RecalCounter+1               ; otherwise joystick simulation would not sync 
                    anda     #%00000001 
                    bne      nogimickDisplay 
                    ADD_SCORE_10                          ; Bonus score for gimmick! 
nogimickDisplay 
                    lda      snake_status                 ; check if we have a snake on a log 
                    cmpa     #IS_DISPLAYED                ; if snake is displayed, 
                    bne      noSnakeSound                 ; we must make the "sname sound" (jump if not) 
                    PLAY_SFX_IF_NOTHING_ELSE  KarlSnakeNoise_Sound 
noSnakeSound: 
                    lda      RecalCounter                 ; check if quite some time has passed, if so 
                    cmpa     #15                          ; 12 ~ 1 Minute with WaitRecal 50 Hz 
                    ble      noWaveSound                  ; check if its is time for another of those sounds 
                    anda     #3 
                    bne      noWaveSound                  ; if yes, make that "shhhh" sound (or jump out) 
                    PLAY_SFX_IF_NOTHING_ELSE  KarlWaveNoise_Sound 
noWaveSound: 
; put all gathered sound chips and throw them at the PSG
                    jsr      do_my_sound 
main_loop_enter: 
                    tst      isAttractMode                ; are we in attract mode? 
                    lbeq     main_loop                    ; no? -> than jump 

 jsr calibration

                    ldx      attractMovePointer           ; otherwise check if our movement sim is over (== 0) 
                    ldx      ,x 
                    beq      attractOver 
                    bsr      displayButton                ; if not over, display our "press button" message and 
                    JSR      Read_Btns                    ; get button status 
                    CMPA     #$00                         ; is a button pressed? 
                    lbeq     main_loop                    ; if not, start another round 
attractOver: 
                    leas     4,s                          ; correct current stack 
                    jsr      DP_to_C8                     ; correct DP 
                    jmp      init_screen                  ; and jump out of here! 

;***************************************************************************
gimickTable: 
                    dw       pacman 
                    dw       worm 
                    dw       ghost 
                    dw       pacman2 
                    dw       worm2 
                    dw       ghost2 
                    dw       0 
pacman: 
                    db       3                            ; y 
                    db       -70                          ; x 
                    db       150                          ; length 
                    dw       pacman1a_object 
worm: 
                    db       -100                         ; y 
                    db       -70                          ; x 
                    db       150                          ; length 
                    dw       worm1a_object 
ghost: 
                    db       92                           ; y 
                    db       -10                          ; x 
                    db       150                          ; length 
                    dw       ghost1a_object 
pacman2: 
                    db       -92                          ; y 
                    db       -70                          ; x 
                    db       150                          ; length 
                    dw       pacman1a_object 
worm2: 
                    db       3                            ; y 
                    db       -70                          ; x 
                    db       150                          ; length 
                    dw       worm1a_object 
ghost2: 
                    db       92                           ; y 
                    db       22                           ; x 
                    db       150                          ; length 
                    dw       ghost1a_object 
displayButton                                             ;        takes 3700 cycles to display 
; print string "presss button to play"
                    dec      buttonBlinker 
                    bne      noblinkChange 
                    lda      #20                          ; every 20 cylces the blink "changes" the state 
                    sta      buttonBlinker 
                    lda      buttonBlinkerIntensity 
                    beq      go60in 
                    lda      #$0                          ; 0 intensity 
                    sta      buttonBlinkerIntensity 
                    bra      noblinkChange 

go60in 
                    lda      #$60                         ; or 60 intensity 
                    sta      buttonBlinkerIntensity 
noblinkChange 
                    lda      buttonBlinkerIntensity 
                    jsr      Intensity_a 
                    ldd      #$fd28                       ; size of text in strength 
                    std      Vec_Text_Height 
                    lda      #30                          ; scale for movement 
                    _SCALE_A  
                    ldu      #pressButton 
                    ldd      #$0580 
                    jsr      sync_Print_Str_d 
                    lda      #$60 
                    jmp      Intensity_a 

                                                          ;rts 
;***************************************************************************
do_score 
                    DO_SCORE  
                    POSSIBLE_RESET5  
                    rts      

;***************************************************************************
; belongs to draw object below
; is here because of short branch...
                    direct   $c8 
timer_death: 
                    LDB      #$40                         ; B timer 1 bit test 
draw_frog_move_timer: 
                    BITB     VIA_int_flags                ; done with move? 
                    BEQ      draw_frog_move_timer         ; no, than go on waiting 
                    LDD      #DIE_TIME                    ; die a DIE_TIME kind of 
die_set_2: 
                    STD      kind_of_death                ; type of death 
                    DEC      no_frogs                     ; decrease number of available frogs 
                    JSR      frog_dead                    ; do a frog_dead intermission, kind of death 
                                                          ; is correctly set in 'kind_of_death' 
                    direct   $d0 
                    tst      no_frogs2                    ; 
                    Bgt      not_lost_yet2                ; if not zero yet, go on 
                    JMP      game_lost                    ; otherwise do a game_lost intermission 

not_lost_yet2: 
                    _DP_TO_C8  
                    JSR      init_new_frog_vars           ; clear the frog variables 
                    JSR      DP_to_D0 
                    direct   $D0 
                    INIT_NEXT_MUSIC  inGameMusic1 
                    RTS      

;***************************************************************************
; exits with dp to d0
; nothing is returned
draw_objects: 
                    direct   $D0 


                    lda      #$60 
                    _INTENSITY_A                        ; all following sprites have intensity of $60 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; print the score, # of lives and # level, all in one "fast" draw String, takes pretty exactly 2000 cylces
; in the move section all the frog move data handling from the joystick query is done
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                    jsr      do_score                     ; no jumper 



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; here is the entry point for the timer count down / intermissions / death
; when frog reaches home...

; first draw homes
; than 2 lines in the middle
; and last the timer line

entry_timer_count_down: 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; independent code section
; draw home, middway and timer line


                    LDD      #$98CC 
                    STa      <VIA_aux_cntl                ; Shift reg mode = 000 free disable, T1 PB7 enabled 
                    STB      <VIA_cntl                    ; /BLANK low and /ZERO low 


                                                          ; for positioning allways 'SCALE_FACTOR_GRID' 
                    LDD      #(SCALE_FACTOR_GRID/2)       ; clear A, and scale to B 
                    _SCALE_B                              ; patched for speed... /2 
                                                          ; this is again a move to D, this time D is splitted into two B, A is 
                                                          ; still 0 
                    LDB      #(2*(5*GRID_SIZE+GRID_SIZE/2)) ; B=Y pos 
                    STD      <VIA_port_b 
                    LDB      #$CE                         ; Blank low, zero high? 
                    STB      <VIA_cntl                    ; 
                    INC      <VIA_port_b                  ; Disable mux 
                    LDB      #-(2*(6*GRID_SIZE))          ; X pos relative to start 
                    STB      <VIA_port_a                  ; Store X in D/A register 
                    STA      <VIA_t1_cnt_hi               ; enable timer 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; MOVE 3 START
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; prepare hardcoded vectorlength for home draw (20)
                    sta      <VIA_shift_reg               ; 0 to shiftreg 
                    lda      #20 
                    STA      $C823                        ; remember in counter 
                    COLLISION_MACRO                       ; no jumper 
                    LDX      #homes+1                     ; address of home vector list 
                    LDD      #((SCALE_FACTOR_HOME*256)+$40) ; A = Scale factor, B Bit for timer test #$1c40 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; MOVE 3 END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                                          ; scale factor can be set while in move! 
                                                          ; own scale factor to homes, since they are drawn in an individually fitted scale 
                    _SCALE_A  
                    CLRA                                  ; clear A 
home_draw_move: 
                    BITB     <VIA_int_flags               ; done with move? 
                    BEQ      home_draw_move               ; no, than go on waiting 
                                                          ; done with move 
                                                          ; now a MY_DRAW_VLC 
                    LDB      ,X+                          ; A= how many vectors?, B = Y coordinate 
_DRAW_VLA_home: 
                    STD      <VIA_port_b 
                    LDB      ,X                           ; load next coordinate (X) 
                    INC      <VIA_port_b                  ; Disable mux 
                    STB      <VIA_port_a                  ; Send X to A/D 
                    DEC      <VIA_shift_reg               ; Put pattern in shift register ($ff) 
                    STA      <VIA_t1_cnt_hi               ; enable timer 1 
                    LDB      1,X                          ; [5] next coordinate (Y) 
                    DEC      $C823                        ; [7] more vectors? 
                    BMI      _DRAW_END_home               ; [3] Go back for more points 
                    LDA      #$40                         ; [2] B-reg = T1 interrupt bit 
                    leax     2,x                          ; [3] 
LF3F4_home1: 
                    BITA     <VIA_int_flags               ; [4] Wait for T1 to time out 
                    BEQ      LF3F4_home1                  ; [3] 
                    CLRA                                  ; [2] Wait a moment more 
                    STA      <VIA_shift_reg               ; [4] Clear shift register (blank output) 
; 28 cycles - exactly $1c scale factor
; instead of flag testing we should just do 4 nops
                    BRA      _DRAW_VLA_home               ; 

_DRAW_END_home: 
                    LDD      #(($40*256)+$cc)             ; A-reg = T1 interrupt bit, B = zero vector byte 
LF3F4_home2: 
                    BITA     <VIA_int_flags               ; Wait for T1 to time out 
                    BEQ      LF3F4_home2                  ; 
                    CLRA                                  ; Wait a moment more 
                    STA      <VIA_shift_reg 
                                                          ; DRAW THE LINES IN BETWEEN 
                    STB      <VIA_cntl                    ; /BLANK low and /ZERO low 
                    _SCALE   (SCALE_FACTOR_GRID/2)        ; patched for speed... /2 
                    LDD      #(2*(GRID_SIZE/2))-2         ; Y pos, A=0 
                                                          ; move to D 
                    std      <VIA_port_b 
                    LDB      #$CE                         ; Blank low, zero high? 
                    INC      <VIA_port_b                  ; Disable mux 
                    STB      <VIA_cntl                    ; zero high! 
                    LDB      #(2*(6*GRID_SIZE))           ; X pos relative to start 
                    STB      <VIA_port_a                  ; Store X in D/A register 
                    STA      <VIA_t1_cnt_hi               ; enable timer 
                                                          ; cycles wasted in below wait for TI1 
                                                          ; we use the time and do some stuff in here... 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; MOVE 4 START
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                    IN_MOVE_3  
                    LDD      #((SCALE_FACTOR_GRID*256)+$40) ; A is scale, B is bit test $40 
                    _SCALE_A  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; MOVE 4 START
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pattern_line_move1: 
                    BITB     <VIA_int_flags               ; Wait for T1 to time out 
                    BEQ      pattern_line_move1           ; 
                                                          ; move to done 
                                                          ; draw line... 
                    LDD      #(lo(-(12*GRID_SIZE)))       ; A=0, B=X 
                    STA      <VIA_port_a                  ; Send Y to A/D 
                    STA      <VIA_port_b                  ; Enable mux 
                    INC      <VIA_port_b                  ; Disable mux 
                    STB      <VIA_port_a                  ; Send X to A/D 
                    STA      <VIA_t1_cnt_hi               ; enable T1H 
                    DEC      <VIA_shift_reg 
; this waits for $ea cycles to finish drawing
; *shudder*
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; in move DRAW
; following CAN be done, since the routine is sort of stable!
; the changes in cycles are really seldom, 
; otherwise the length of the drawn vector would be shaky
                    lda      gameModeOption 
                    ldb      #HARDMODE 
                    cmpa     #2 
                    beq      hardModeDone_1n 
                    lda      score_digit_5 
                    cmpa     high_check 
                    beq      no_new_life_1n 
                    sta      high_check                   ; and store it, for new life at change... (every 10000 points) 
                    INC      no_frogs                     ; incraese frog lifes 
                    PLAY_SFX  Karl_NewHigScoreSound 
no_new_life_1n 
                    ldb      no_frogs                     ; is in 
hardModeDone_1n 
                    stb      score_digit_LIFES 
                    LDd      #(SCALE_FACTOR_GRID/12) 
                    _SCALE_B  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                    LDB      #$40                         ; B-reg = T1 interrupt bit 
line_1_LF3F4: 
                    BITB     <VIA_int_flags               ; Wait for T1 to time out 
                    BEQ      line_1_LF3F4 
                                                          ; line draw done 
                                                          ; move start 
                    LDB      #(lo(-1-(12*GRID_SIZE)))+10  ; a small Y offset down 
                    STA      <VIA_shift_reg               ; Clear shift register (blank output) 
                    STB      <VIA_port_a                  ; Store Y in D/A register 
                    STA      <VIA_port_b                  ; Enable mux 
                    LDB      #$CE                         ; Blank low, zero high? 
                    STB      <VIA_cntl                    ; 
                    INC      <VIA_port_b                  ; Disable mux 
                    STA      <VIA_port_a                  ; Store X in D/A register 
                    STA      <VIA_t1_cnt_hi               ; enable timer 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; MOVE 5 START
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this is a "small" move, we do not use
; move is "only" (SCALE_FACTOR_GRID/12)
                    LDD      #((SCALE_FACTOR_GRID)*256+$40) ; A is scale, B is bit test $40 
                    _SCALE_A  
                    clra     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; MOVE 5 END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pattern_line_move2: 
                    BITB     <VIA_int_flags               ; Wait for T1 to time out 
                    BEQ      pattern_line_move2           ; 
                                                          ; move end 
                                                          ; draw start 
                    LDB      #(lo((12*GRID_SIZE)))        ; A=0, B=X 
                    STA      <VIA_port_a                  ; Send Y to A/D 
                    STA      <VIA_port_b                  ; Enable mux 
                    INC      <VIA_port_b                  ; Disable mux 
                    STB      <VIA_port_a                  ; Send X to A/D 
                    STA      <VIA_t1_cnt_hi               ; Set T1H (scale factor?) 
                    DEC      <VIA_shift_reg 
; this waits for $ea cycles to finish drawing
; *shudder*
; Seeking - what could be donein this $ea cycles?
; haven't found more stuff todo in waiting *grml*
;
; new:
; just doing both JSR "earlier" than later in a move
; seems to save (level 1) about 100 cycles, so I do it here
; vide measurements - hurray!
;                    jsr      [inMovePointer]              ; first is really small 
;                    jsr      [inMovePointer]              ; first is really small 
; I can not use the above two EVEN though they fit perfectly
; because they use different cycles each call
; because of that the blank is switched on on a different cycle count
; and the end of the vector "wiggles" - thats vectrex
; if I find a routine with a fixed cycle count - I can put it in here and
; save them!
                    LDB      #(SCALE_FACTOR_GRID/2) 
                    _SCALE_B  
                    LDd      #$40CC 
line_2_LF3F4_e: 
                    BITa     <VIA_int_flags               ; Wait for T1 to time out 
                    BEQ      line_2_LF3F4_e 
                    clra     
                    sta      <VIA_shift_reg               ; Clear shift register (blank output) 
                                                          ; draw end 
                                                          ; notice! 
                                                          ; the timer line length could also be altered using the scale factor, 
                                                          ; in fact that would save some cycles, especially 
                                                          ; when time goes low... 
                                                          ; also the timer line would not grow "brighter" the shorter it gets... 
                    STb      <VIA_cntl                    ;/BLANK low and /ZERO low 
                                                          ; 
                                                          ; move to 
                    LDb      #lo(-(2*(5*GRID_SIZE+GRID_SIZE/2))) ; y offset 
                    STB      <VIA_port_a                  ; Store Y in D/A register 
                    STA      <VIA_port_b                  ; Enable mux 
                    LDB      #$CE                         ; Blank low, zero high? 
                    INC      <VIA_port_b                  ; Disable mux 
                    STB      <VIA_cntl                    ; zero high, this is really a few cycles to early! 
                    LDB      #-(2*(6*GRID_SIZE))          ; X pos relative to start 
                    STB      <VIA_port_a                  ; Store X in D/A register 
                    STA      <VIA_t1_cnt_hi               ; enable timer 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; MOVE 6 START
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this is a "small" move, we do not use extensivly
; move is "only" (SCALE_FACTOR_GRID/2) - which is still large and might be used
; jsr emptyInMove
                    IN_MOVE_4  
                    LDD      #((SCALE_FACTOR_GRID*256)+$40) ;A= scale, B-reg = T1 interrupt bit 
                    _SCALE_A  
                    CLRA     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; MOVE 6 END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
time_line_move: 
                    BITB     <VIA_int_flags               ; Wait for T1 to time out 
                    BEQ      time_line_move               ; 
                                                          ; move done 
                    LDB      y_timer+1                    ; load new vector (length was cut by timer :-)), y is always 0 
                    beq      no_timerDraw                 ; skip null timer (from intermissions) 
                                                          ; draw line 
                    STA      <VIA_port_a                  ; Send Y to A/D 
                    STA      <VIA_port_b                  ; Enable mux 
                    INC      <VIA_port_b                  ; Disable mux 
                    STB      <VIA_port_a                  ; Send X to A/D 
                    STA      <VIA_t1_cnt_hi               ; Set T1H (scale factor?) 
                    DEC      <VIA_shift_reg 
                    LDB      #$40                         ; B-reg = T1 interrupt bit 
                    sta      tmp1                         ; clear temporal 
                    sta      tmp1+1                       ; storage for offset 
line_3_LF3F4: 
                    BITB     <VIA_int_flags               ; Wait for T1 to time out 
                    BEQ      line_3_LF3F4 
                    STA      <VIA_shift_reg               ; Clear shift register (blank output) 
                                                          ; draw end 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
no_timerDraw: 
                    POSSIBLE_RESET1  

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; independent code section
; draw all 'home' sprites
                    LDx      #home_objects                ; load the address to x, start of list of homes 
                    LDA      #$80 
                    STA      <VIA_aux_cntl                ; Shift reg mode = 000 free disable, T1 PB7 enabled 
                    bra      nexthome 

no_object_in_1_house_org 
                    leax     (HOME_OBJECT_SIZE),x 
                    cmpx     #home_objects+(5*HOME_OBJECT_SIZE) 
                    lbeq     nonexthome 
nexthome: 
                    LDD      #(SCALE_IN_HOME*256)+$CC     ; prepare for zero below - SCAL_HOME = $83 
                    stb      <VIA_cntl                    ; 22 cycles from switch on ZERO disabled, and BLANK enabled 
                    LDu      ,x                           ; load object to u 
                    BEQ      no_object_in_1_house_org     ; if zero, than anothing to do 
; do 1 house object here!
                                                          ; zero here for following homes 
                    _SCALE_A                              ; for first house 
                    LDD      2,x                          ; load object position 
                    ADDA     7,u                          ; korrect with sprite offset Y 
                    ADDB     8,u                          ; korrect with sprite offset X 
                                                          ; move to 
                    STA      <VIA_port_a                  ; Store Y in D/A register 
                    CLR      <VIA_port_b                  ; Enable mux 
                    LDA      #$CE                         ; Blank low, zero high? 
                    STA      <VIA_cntl                    ; 
                    INC      <VIA_port_b                  ; Disable mux 
                    STB      <VIA_port_a                  ; Store X in D/A register 
                    CLR      <VIA_t1_cnt_hi               ; enable timer 
;;;;;; IN MOVE HERE
                    DEC      4,x                          ; decrease animation counter 
                    BNE      no_new_animation_phase_home_1 ; if zero, we must initialize new animation phase 
new_animation_phase_home_1: 
                    LDY      5,u                          ; load new object definition 
                    STY      ,x                           ; store new object definition to object list 
                    LDA      4,Y                          ; load new animation counter start 
                    STA      4,x                          ; and set it in object list 
no_new_animation_phase_home_1: 
                    LDY      1,u                          ; load object vector list to , (save u in y register) 
                                                          ; in this move (if it happens) we can do some ym decoding.... 
                    jsr      [inMovePointer]              ; do ym decode "in move" 
                    leau     2,y                          ; restore and u 
                    LDy      ,y                           ; load offset of vector list draw 
                    leay     >(unloop_start_addressh1+LENGTH_OF_HEADER),y ; 
                    LDD      #((SCALE_FACTOR_SPRITE)*256)+$40 ;A= scale, B= Timer flag 
                    _SCALE_A                              ; do it 
                    leax     (HOME_OBJECT_SIZE),x 
home_object_move_1: 
                    BITB     <VIA_int_flags               ; Wait for T1 to time out 
                    BEQ      home_object_move_1           ; 
                                                          ; move to done 
                                                          ; in X vector list now! 
                                                          ; U still untouched, pointer to first home! 
                                                          ; display the vector list 
unloop_start_addressh1: 
; since there can actually be 5 sprites displayed at once I do not use a subroutine, but the
; direct unlooping via a macro (this costs nearly 600 bytes)
                    MY_SPRITE_DRAW_VLC_UNLOOP_16  
; loop thru all five homes
no_object_in_1_house 
                    cmpx     #home_objects+(5*HOME_OBJECT_SIZE) 
                    lbne     nexthome 
nonexthome: 
all_home_objects_done: 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; print the score, # of lives and # level, all in one "fast" draw String, takes pretty exactly 2000 cylces
; in the move section all the frog move data handling from the joystick query is done
                    _ZERO_VECTOR_BEAM  
                    POSSIBLE_RESET4  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; independent code section
; remove/display otter
                    LDA      otter_status                 ; is there any otter stuff at all? 
                    LBEQ     no_otter_in_level            ; no?, than go on 
                    tst      intermissionActive 
                    bne      destroy_otter 
                    CMPA     #IS_WAITING                  ; croco is waiting to be displayed 
                    LBEQ     finnished_otter_stuff        ; if zero, do nothing 
; otter is already displayed, must check if we should destroy it...
otter_is_being_displayed: 
                    LDu      otter_log_past               ; load object list address of object past otter 
                    LDB      otter_pos+1                  ; and load the position of otter now 
                    CMPB     3,u                          ; compare to log pos 
                    BGE      display_otter                ; go to display if otter higher log 
                                                          ; here when otter pos smaller log pos 
                    ADDB     #OTTER_X_LEN+5               ; now add the hardcoded length plus some (5) extra 'pixel' 
                    CMPB     3,u                          ; compare to log pos 
                    BLE      display_otter                ; if still lower, than display 
                                                          ; otherwise if now greater, than a 'collision' with log happened 
; now destroy otter
destroy_otter: 
                    lda      #IS_WAITING 
                    sta      otter_status 
                    LDD      otter_timer_start            ; reload the otter timer 
                    STD      otter_timer                  ; and store it 
                    JMP      finnished_otter_stuff        ; and go to done 

                                                          ; ok, otter is available and still displayed... 
                                                          ; first let us look if there is afrog to be eaten... :-) 
display_otter: 
                    _ZERO_VECTOR_BEAM                     ; go to 0,0 
                    LDA      otter_band                   ; what band are we on now ? 
                    INCA                                  ; plus one to compare with frog band 
                    CMPA     frog_y_band                  ; compare with frog band 
                    BNE      display_otter_1              ; if not equal... do a simple otter display 
                    LDB      otter_pos + 1                ; load otter position 
                    SUBB     frog_x                       ; subtract frog position 
                    BPL      display_otter_1              ; if positive no collision is possible -> jump to display 
                    CMPB     #-20                         ; near 20 
                    BLO      display_otter_1              ; if lower, than everything OK 
                    TST      kind_of_death+1              ; test if we are in death timer loop 
                    BNE      display_otter_1              ; frog is allready dead! 
                    _DP_TO_C8  
                    LDD      #DIE_MOLE                    ; die a DIE_MOLE kind of 
                    JMP      die_set_2 

                    direct   $d0 
display_otter_1: 
;............................................................................
; this is actually the same as the code used in the main sprite loop
; just fitted for otter only...
                    MY_GAME_SCALE                         ; scale for game positioning 
                    LDD      otter_pos                    ; load otter position 
                                                          ; move to 
                    STA      <VIA_port_a                  ; Store Y in D/A register 
                    LDA      #$CE                         ; Blank low, zero high? 
                    STA      <VIA_cntl                    ; 
                    CLRA     
                    STA      <VIA_port_b                  ; Enable mux 
                    INC      <VIA_port_b                  ; Disable mux 
                    STB      <VIA_port_a                  ; Store X in D/A register 
                    STA      <VIA_t1_cnt_hi               ; enable timer 
; this is a "special" 
; in move stuff, since it
; is only relevant if there realy is an otter
; and we do not even get to this code
; if there is no otter,
; for that reason no subroutine is called - but left here directly
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; IN MOVE OTTER START
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; in move stuff start
                    LDD      otter_pos                    ; load otter position 
                    ADDB     otter_speed                  ; add the speed 
                    CMPB     #(BOUNDARY_LO)               ; is on left side out of bounds? 
                    BGT      onot_lower_out_of_bounds     ; no, than no coordinate fiddling 
                    ADDB     #(127+100-MAX_SPRITE_OFFSET) 
                    BRA      obound_test_done             ; don't check for right out of bounds now 

onot_lower_out_of_bounds: 
                    CMPB     #(BOUNDARY_HI)               ; check if we are out of bounds on the right 
                    BLE      onot_higher_out_of_bounds    ; no? than go on 
                    SUBB     #(127+100-MAX_SPRITE_OFFSET) 
obound_test_done: 
onot_higher_out_of_bounds: 
                    STB      otter_pos + 1                ; store the new x position 
                    LDx      otter_object                 ; load the otter object to U 
                    DEC      otter_anim_counter           ; decrease animation counter 
                    BNE      no_anim_change_otter         ; if zero, we must initialize new animation phase 
                    LDD      7,x                          ; load old sprite offsets 
                    NEGA                                  ; negate them (A) 
                    NEGB                                  ; negate them (B) 
                    ADDA     otter_pos                    ; add y position to old sprite offset y 
                    ADDB     otter_pos + 1                ; add x position to old sprite offset x 
                    LDu      5,x                          ; load new object definition 
                    ADDA     7,u                          ; add new sprite offset y 
                    ADDB     8,u                          ; add new sprite offset x 
                    STD      otter_pos                    ; and store the corrected position 
                    STu      otter_object                 ; store new object definition to object list 
                    LDA      4,u                          ; load new animation counter start 
                    STA      otter_anim_counter           ; and set it in object list 
no_anim_change_otter: 
                    LDu      1,x                          ; load object vector list to X, 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; IN MOVE OTTER END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                    jsr      move_wait_draw_vlc_unloop 
                    lda      #$cc 
                    sta      <VIA_cntl                    ; 22 cycles from switch on ZERO disabled, and BLANK enabled 
otter_draw_done: 
;............................................................................
no_otter_in_level: 
finnished_otter_stuff: 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; now look if there is a snake on some log
                    LDB      snake_status                 ; get the status 
                    LBEQ     no_snake                     ; if zero, than no snake on level 
                    CMPB     #IS_DISPLAYED                ; if waiting 
                    LBNE     no_snake                     ; go to no snake 
                                                          ; now we set the new coordinates 
                    MY_GAME_SCALE                         ; a different scale again... still very high :-( 
                    LDD      snake_pos                    ; do positioning, load pos here 
                                                          ; move to start 
                    STA      <VIA_port_a                  ; Store Y in D/A register 
                    LDA      #$CE                         ; Blank low, zero high? 
                    STA      <VIA_cntl                    ; 
                    CLRA     
                    STA      <VIA_port_b                  ; Enable mux 
                    INC      <VIA_port_b                  ; Disable mux 
                    STB      <VIA_port_a                  ; Store X in D/A register 
                    STA      <VIA_t1_cnt_hi               ; enable timer 
; this is a "special" 
; in move stuff, since it
; is only relevant if there realy is a snake
; and we do not even get to this code
; if there is no snake,
; for that reason no subroutine is called - but left here directly
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; IN MOVE SNAKE START
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                    LDx      #snake_anim_counter          ; X to snake_anim_counter 
                    LDu      snake_object                 ; U to snake object 
                    IN_MOVE_SNAKE  
                    tst      intermissionActive 
                    beq      goOnSnameDisplay 
                    lda      #$40 
LF33D_11 
                    BITA     VIA_int_flags                ; wait for timer to finnish move to 
                    Beq      LF33D_11                     ; 
                    bra      no_snakeDisplay 

goOnSnameDisplay: 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; IN MOVE SNAKE END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                    LDu      ,u                           ; load object vector list to X, 
                    _SCALE_B                              ; scale for sprite 
;unloop_start_address10: 
                    jsr      move_wait_draw_vlc_unloop 
no_snakeDisplay: 
                    lda      #$ce 
                    sta      <VIA_cntl                    ; 22 cycles from switch on ZERO disabled, and BLANK enabled 
no_snake: 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; entry for 'LEVEL DONE' display
; only the 'sprites' are displayed (and moved) below...
; (new: collosion check
; is inlined now as well, but wrapped with a "death"/intermission check)
                    POSSIBLE_RESET3  
entry_level_done: 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; independent code section
; setup independend code section jumper
                                                          ; DRAW ALL LEVEL SPRITES 
                                                          ; now drawing all sprites (or object, whatever you call them) 
                                                          ; routine, to draw all sprites, 
                                                          ; move them, do an out of bounds checking, 
                                                          ; intensity changing, and initializing 
                                                          ; new animation sequences? 
                                                          ; actually the animation initialization takes most of the code 
                    LDX      #object_list-2               ; load the address to X, start of list of 
                                                          ; all objects (sprites) for this level 
                                                          ; and their position 
                                                          ; -2 and offsets are chose, that we adjust X only once in the GENERAL MACRO 
; moved to "in move" LDY      object_list                 ; load new list object 
                                                          ; X pointing to Y coordinate now 
                                                          ; Y pointing to object structure AND 
                                                          ; Y pointing to x-speed in object structure 
next_object: 
                    LDD      2+2,X                        ; [5] load y, x coordinate from object_list to 
                                                          ; A,B=D, 
                                                          ; intensities of all sprites are the same, so no 
                                                          ; setting is really needed! 
; since game positioning is done with a 'huge' scale factor ($91) there
; is a whole lot of empty space in here, and that at EACH sprite.
; anyway, the thing done in (befor!) that loop is the
; checking whether an animation occurs or not.
; and now if the sprite is out of bounds
; and girl and snake checking!!!
; another 1000 cycles saved.
;;;;;;;;;;;;; NOW MOVE_TO_D
                                                          ; note: there are 2 or 3 cycles more that could be saved here 
                                                          ; by optimizing, but the vectrex zeroing is NOT 
                                                          ; fast enough, vectors are not positioned correctly than!!! 
                    STA      <VIA_port_a                  ; [4]Store Y in D/A register 
                    nop      
                    lda      #$cc 
                    STa      <VIA_cntl                    ;/BLANK low and /ZERO low -> move cursor to zero 
                    LDA      #SCALE_FACTOR_GAME 
                    STA      <VIA_t1_cnt_lo               ; move to time 1 lo, this means scaling 
                                                          ; [8] a different scale again... still very high :-( 
                                                          ; wait for zeroing to take effect 
                                                          ; if we do not wait here, the zeroing is not 100% completed, and some sprites are 
                                                          ; a little bit off in their positioning 

 nop 10 ; wait with buffer for bad vectrex to finish zeroing, this nops takes about 600 cycles!
                    clra     
                    sta      <VIA_port_b                  ; Enable mux, this sets the Y integrator 
                    INC      <VIA_port_b                  ; Disable mux 
                    STB      <VIA_port_a                  ; Store X in D/A register this goes to the X integrator 
                    sta      <VIA_t1_cnt_hi               ; enable timer, by accessing it! 
                    LDA      #$CE                         ; Blank low, zero high? 
                    STA      <VIA_cntl                    ; Now zero is off... we can integrate! 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; MOVE 7 START
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                    GENERAL_IN_MOVE_SPRITE  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; MOVE 7 END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
objects_not_all_done_move: 
; in move action done
move_sprite_1: 
                    BITB     <VIA_int_flags               ; test the bit 
                    BEQ      move_sprite_1                ; if not zero, than loop 
unloop_start_address1: 
                    MY_SPRITE_DRAW_VLC_UNLOOP  
                    JMP      next_object                  ; and do the next 

                                                          ; here if no new animation is to be done 
anim_no_next: 
; the last object is done via a JSR, for easier loop exiting
                    jsr      move_wait_draw_vlc_unloop 
objects_all_done: 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; now look if there is a girl on some log
                    LDB      girl_status                  ; get the status 
                    CMPB     #IS_DISPLAYED                ; if waiting 
                    BEQ      do_girl_stuff                ; go to girl stuff 
                    _ZERO_VECTOR_BEAM                     ; go to zero 
no_girl: 
girl_allready_done: 
                    direct   $d0 
 bra do_mainFrogDraw

; girl stuff below main function for short branches...
do_girl_stuff: 
                                                          ; now we set the new coordinates and jump into the object 
                                                          ; display loop again 
                                                          ; setup all registers for a jump into the object loop 
                    MY_GAME_SCALE                         ; a different scale again... still very high :-( 
; todo check with real hardare
; here the game scale is done befor -> should be 4 nops less (8) cycles
;                    nop      (10-4)                      ; wait till abou 22 cycles passed from light sitch on to off 
                    _ZERO_VECTOR_BEAM                     ; go allways to zero, is sort of bad, 
                    LDD      girl_pos                     ; do positioning, load pos here 
                    STA      <VIA_port_a                  ; Store Y in D/A register 
                    CLR      <VIA_port_b                  ; Enable mux, this sets the Y integrator 
                    INC      <VIA_port_b                  ; Disable mux 
                    STB      <VIA_port_a                  ; Store X in D/A register this goes to the X integrator 
                    LDA      #$CE                         ; Blank low, zero high? 
                    STA      <VIA_cntl                    ; Now zero is of... we can integrate! 
                    CLR      <VIA_t1_cnt_hi               ; enable timer, by accessing it! 
; this is a "special" 
; in move stuff, since it
; is only relevant if there realy is an girl
; and we do not even get to this code
; if there is no girl,
; for that reason no subroutine is called - but left here directly
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; IN MOVE GIRL START
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                                          ; here we have more than SCALE_FACTOR_GAME ($91) cycles time! 
                                                          ; nothing is now done here! 
                    LDx      #girl_anim_counter           ; x to girl_anim_counter 
                    LDY      girl_object                  ; Y to girl object 
                    LEAY     1,Y                          ; + 1 
                    LDD      girl_pos                     ; do positioning, load pos here 
                    ADDB     girl_speed                   ; add the speed, got from log information earlier 
                    STD      girl_pos                     ; and 're' store it 
; now we do that animation checking
                    LDu      ,Y                           ; load object vector list to u, 
                    DEC      ,x+                          ; decrease animation counter 
                    BNE      no_animation_moveg           ; if zero, we must initialize new animation phase 
new_animation_phaseg: 
                    LDD      6,Y                          ; load old sprite offsets 
                    NEGA                                  ; negate them (A) 
                    NEGB                                  ; negate them (B) 
                    ADDA     -3,x                         ; add y position to old sprite offset y 
                    ADDB     -2,x                         ; add x position to old sprite offset x 
                    LDY      4,Y                          ; load new object definition 
                    ADDA     7,Y                          ; add new sprite offset y 
                    ADDB     8,Y                          ; add new sprite offset x 
                    STD      -3,x                         ; and store the corrected position 
                    STY      -5,x                         ; store new object definition to object list 
                    LDA      4,Y                          ; load new animation counter start 
                    STA      -1,x                         ; and set it in object list 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; IN MOVE GIRL END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
no_animation_moveg: 
                    jsr      move_wait_draw_vlc_unloop 
                    lda      #$cc
                    sta      <VIA_cntl                    ; 22 cycles from switch on ZERO disabled, and BLANK enabled 
                    direct   $d0 
do_mainFrogDraw:
 tst intermissionActive
 lbne finaly_done_draw

; independent code section
; draw frog
; intensity is "default" at $60 now
                    ldb      girl_status 
                    cmpb     #IS_CARRIED                  ; if girl is carried - flicker slightly! 
                    bne      keep_intensity 
                    lda      RecalCounter+1               ; lsb of counter is used as "flicker" "counter" 
                    anda     #$1f 
                    adda     #$60 
                    _INTENSITY_A  
keep_intensity: 
                    MY_GAME_SCALE                         ; set game scaling 
                    LDD      frog_pos                     ; load current frog position to D 
                                                          ; following passage is a move_to_d derivat 
                    STA      <VIA_port_a                  ; Store Y in D/A register 
                    LDA      #$CE                         ; Blank low, zero high? 
                    STA      <VIA_cntl                    ; 
                    CLRA     
                    STA      <VIA_port_b                  ; Enable mux 
                    INC      <VIA_port_b                  ; Disable mux 
                    STB      <VIA_port_a                  ; Store X in D/A register 
                    STA      <VIA_t1_cnt_hi               ; enable timer 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; MOVE 1 START
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                    sta      skipCount_now                ; clear the count of currently skipped sprites each round (used in intermissions to switch of first 3 lanes) 
                    IN_MOVE_1                             ; no jumper 
                    LDu      frog_pic                     ; load current frog sprite 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; MOVE 1 END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; done with our in 'pause' move stuff!
draw_frog_move: 
                    jsr      move_wait_draw_vlc_unloop 
                    LDD      #$98CC 
                    STA      <VIA_aux_cntl                ; Shift reg mode = 000 free disable, T1 PB7 enabled 
                    STB      <VIA_cntl                    ; /BLANK low and /ZERO low 
finaly_done_draw
                    RTS                                   ; and finnished drawing even the girl 

;***************************************************************************
; this darling moves the frog on the title screen
; query joystick handles the actual move information via recorded data given
oneFrog_move_init 
                    jsr      query_joystick 
                    jsr      move_frog 
                    LDd      #$60D0 
                    TFR      b,DP 
                    direct   $D0 
                    jsr      Intensity_a 
                    MY_GAME_SCALE                         ; set game scaling 
                    LDD      frog_pos                     ; load current frog position to D 
                                                          ; following passage is a move_to_d derivat 
                    STA      <VIA_port_a                  ; Store Y in D/A register 
                    LDA      #$CE                         ; Blank low, zero high? 
                    STA      <VIA_cntl                    ; 
                    CLRA     
                    STA      <VIA_port_b                  ; Enable mux 
                    INC      <VIA_port_b                  ; Disable mux 
                    STB      <VIA_port_a                  ; Store X in D/A register 
                    STA      <VIA_t1_cnt_hi               ; enable timer 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; MOVE 1 START
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                    LDu      frog_pic                     ; load current frog sprite 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; MOVE 1 END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                    jsr      move_wait_draw_vlc_unloop 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                    LDA      #$98 
                    STA      <VIA_aux_cntl                ; Shift reg mode = 000 free disable, T1 PB7 enabled 
                    rts      

;***************************************************************************
clearMyScore 
                    CLEAR_SCORE  
                    rts      

;***************************************************************************
; this routine initializes the game variables
; nothing is expected and nothing is returned
; leaves DP to C8
init_vars: 
                    JSR      DP_to_C8 
                    direct   $C8 
                    ldd      #$38f4                       ; for attract mode to work properly - we need a not so random seed! 
                    std      Vec_Random_Seed 
                    lda      #-28 
                    sta      Vec_Random_Seed+2 
                    ldd      #$0103                       ; these set up the joystick 
                    std      Vec_Joy_Mux_1_X 
                    sta      gimmickPossible              ; not on startup = 1 
                                                          ; enquiries 
                                                          ; allowing only all directions for 
                                                          ; for joystick one 
                    LDd      #0                           ; this setting up saves a few hundred 
                    sta      did_rollOver 
                    sta      gimmickActive 
                    STd      Vec_Joy_Mux_2_X              ; cycles 
                                                          ; don't miss it, if you don't need the 
                                                          ; second joystick! 
                    bsr      clearMyScore 
                    LDX      #home_objects                ; address to clear 
                    LDD      #((home_end-home_objects)-1) ; number of bytes - 1 to clear 
                    JSR      Clear_x_d                    ; clear sub routine in ROM 
                    lda      #5 
                    sta      tmp1 
                    LDX      #home_objects+2              ; pointer to y pos 
                    ldd      #HOME_Y_POS*256+(HOME_X_POS-(HOME_X_WIDTH)) 
nextHomeIni 
                    addb     #HOME_X_WIDTH 
                    std      ,x 
                    leax     5,x 
                    dec      tmp1 
                    bne      nextHomeIni 
;;;;;;;;;;
                    LDX      #object_list                 ; address to clear 
                    LDD      #((object_list_end-object_list)-1) ; number of bytes - 1 to clear 
                    JSR      Clear_x_d                    ; clear sub routine in ROM 
                    LDX      #band_list                   ; address to clear 
                    LDD      #((band_list_end-band_list)-1) ; number of bytes - 1 to clear 
                    JSR      Clear_x_d                    ; clear sub routine in ROM 
                    LDA      #START_LEVEL                 ; initial game level 
                    STA      game_level                   ; upon startup 
                    ldb      gameModeOption 
                    cmpb     #1 
                    bne      noTrainingMode 
                    lda      levelFromOptions             ; one based 
                    deca     
                    sta      game_level 
noTrainingMode: 
                    CLR      y_timer                      ; no y change for timer line... 
; entry point for continue with current level
continue_level: 
                    LDA      #FROGS_PER_GAME              ; balls 5 
                    ldb      gameModeOption 
                    cmpb     #2 
                    bne      noHardMode 
                    lda      #1 
noHardMode: 
                    STA      no_frogs                     ; and store five balls 
                    lda      score_digit_5 
                    sta      high_check                   ; and store it, for new life at change... (every 10000 points) 
; entry point for each new frog
init_new_frog_vars: 
                    direct   $c8 
                    ldd      #0 
                    std      currentSFX                   ;sta currentSFX+1 
                    std      Vec_Joy_1_X                  ;sta Vec_Joy_1_Y 
                    sta      froggerInJump 
                    inca     
; ensure no autojump!
                    sta      last_joy_x                   ; only jump if last joy pos was zero 
                    sta      last_joy_y                   ; only jump if last joy pos was zero 
                    LDD      #frogger_up                  ; frogger faces up 
                    STD      frog_pic                     ; upon startup 
                    LDB      #FROG_SIZEX_UP               ; adjust sizing information 
                    STB      current_frog_size_x          ; store it 
                    LDA      #HEADING_UP                  ; first frog is looking up 
                    STA      current_frog_heading         ; store that 
                    LDD      frogger_up_offset            ; load the offset of the currently used pic 
                    STD      current_frog_offset          ; and store it for later use 
                    LDD      #FROG_INIT_POS               ; load init values 
                    ADDA     frogger_up_offset            ; and evalute the new pos 
                    ADDB     frogger_up_offset+1          ; corresponding to the offset 
                    STD      frog_pos                     ; and store them... 
                    LDD      #FROG_INIT_POS_BAND          ; load init values 
                    STD      frog_pos_band                ; and store them... 
                    LDD      my_timer_start               ; initialize timer 
                    STD      my_timer                     ; store it 
                    CLR      kind_of_death + 1            ; always clear, for double death check 
                    DEFAULT_PSG_SETTING  
                    ldb      #$fe                         ; sign for calling "score print" to NOT print score 
                    RTS      

setup_level: 
; expects DP to $C8
; mainly this routine sets up the sprite information which are
; stored in the simple level structure
; sprites are arranged in a fixed length list
; a maximum of currently 30 sprites (should be enough) can be
; stored in that list
; though it depends on the size and position of these sprites if
; vectrex is capable of drawing them in a way which doesn't hurt the eyes
;
; the 'playfield' is divided into a 12*12 grid
; the lowest position cannot contain any sprites, since
; that's where frogger starts of
;
; the level (see levels.i for an example) is constructed of a field of
; bytes. If a byte differs from 0 a sprite is assumed
; in that position
; the position in screen coordinates is calculated from the byte position
; in the field.
; the byte itself is used as information what kind of sprite is to be
; used
; the position and the address where the sprite data is stored is
; copied to an object_list in vectrex ram
; this list will be repainted every round
;
; for easier collision detection a second list is used
; one for each band, a maximum of 7 sprites per band is currently supported
; that way I don't have to check every single sprite, only those
; in the band which interests me (still a few sprites to check)
;
; the length of the sprite is stored in it's data structure, only the
; length is relevant for collision detection,
; since it is assumed that frogger allways hops over a whole band
;
; sprites are allways assumed to start at 0 and than have a width of
; 'length'
; if frogger 'touches' such a length it dies (or swims)
; actually I think this is a very nasty collision detection
; for the road, since the mearest scratch kills frogger,
; on the other hand, he can get hold of only a 'pixel' of log
; and still hold on to it :-)
;
                    direct   $c8 
                    LDA      #5                           ; five homes exist 
                    STA      in_home_counter              ; store it 
                                                          ; this means 5 empty homes 
                    LDD      #0                           ; clear all homes 
                    LDY      #home_objects                ; first home 
                    STD      ,Y                           ; store the clear to home 1 
                    STD      5,Y                          ; store the clear to home 2 
                    STD      10,Y                         ; store the clear to home 3 
                    STD      15,Y                         ; store the clear to home 4 
                    STD      20,Y                         ; store the clear to home 5 
                    STD      tmp2                         ; this is a helper if we reinit the 
                    BRA      no_reinit_level              ; level or start a new one 

                                                          ; this sets it to new level 
; entry point for level reinit
; must allways be done after a morph, since a morph uses
; the same ram as the level information
; damn only 1 K (or less that is)
reinit_level: 
                    CLR      tmp2                         ; otherwise set tmp2 
                    INC      tmp2                         ; to 1, which means reinit 
no_reinit_level: 
                    ldb      #SPACE 
                    stb      score_digit_SPACE1           ; space betwwen score, and lives 
                    stb      score_digit_SPACE2           ; space betwwen lifes, and level 
                    ldb      game_level                   ; look at level 
                    incb                                  ; start at 1 not 0 
                    stb      score_digit_Level            ; high "level" is per default a space 
                    ldb      #$81                         ; end string with $81 
                    stb      score_digit_front 
                    stb      score_digit_back 
                    clr      frogDeath                    ; != 0 
                    clr      intermissionActive           ; != 0 
                    CLR      tmp2+1 
                    LDD      #0                           ; clear all homes 
                                                          ; clear static dive turtle list 
                    LDX      #t_list                      ; load start address 
                    LDD      #14                          ; load length of structure 
                    JSR      Clear_x_d                    ; clear object structure 
                                                          ; first clear the current level 
                                                          ; this clears the last level band list 
                    LDX      #band_list                   ; load start address 
                    STX      tmp_band_list                ; savety copy to tmp_band_list 
                    LDD      #(band_list_end-band_list)   ; load length of structure 
                    JSR      Clear_x_d                    ; clear band_list 
                                                          ; this clears the level object list 
                    LDX      #object_list                 ; load start address 
                    LDD      #(object_list_end-object_list) ; load length of structure 
                    JSR      Clear_x_d                    ; clear object structure 
                    LDU      #object_list                 ; load the address to U 
                                                          ; than we go to current level 
                    LDA      #LEVEL_DATA_LENGTH           ; load length of level 
                    LDB      game_level                   ; load level number 
                    MUL                                   ; multiply these two 
                    ADDD     #level1_data                 ; and add to start address of level data 
                    TFR      D,X                          ; and in X register for easier access (indexed) 
                                                          ; now we will loop a while, first thru all bands (11) 
                    LDA      #11                          ; 11 bands (10+ middle) 
                    ldb      game_level                   ; if the level ist the "LEVEL DONE" level, only the middle band is loaded, all other 
                    cmpb     #16                          ; data is ignored 
                    bne      allData 
                    LDX      #band_list 
                    leax     7*16, x 
                    STX      tmp_band_list 
                    ldx      #level_done_data 
                    lda      #7 
allData 
                    STA      loop1                        ; initialize counter for loop1 
_loop1: 
                                                          ; and than the inner loop thru all band positions (12) 
                    CLR      tmp_band_offset              ; band list (x) offset for each new 
                    CLR      tmp_band_offset+1            ; band = 0 
                    LDA      #12                          ; fixed GRID_WIDTH 
                    STA      loop2                        ; initialize counter for loop2 
_loop2: 
                    LDB      ,X+                          ; load level information (one byte each pass), increment X by 1 
                    BEQ      move_on                      ; than move on 
                                                          ; if we encounter something different than 0 
                                                          ; we have a sprite which we will place in the 
                                                          ; object structure, 
                                                          ; this object structur will be updated all thru the 
                                                          ; game... 
                    CLRA                                  ; clear A 
                    DECB                                  ; since it starts at 1 not 0 
                    ASLB                                  ; multiply B by 2 
                    ADDD     #object_table                ; add object table address 
                    TFR      D,Y                          ; move to index register Y 
                    LDD      ,Y                           ; and load the the sprite object structure to D 
; first lets save this object list position to the current band_list
; pointer
; in the band_list are all object_list positions stored, sorted
; by each band
; band list provides storage for a maximum of 7 sprites per band
; this is NOT checked, make the levels good!!!
                    PSHS     X,D                          ; save X,D register 
                    LDD      tmp_band_list                ; load current band list 'band' (y) position 
                    ADDD     tmp_band_offset              ; add the current (x) position (how many objects on this band) 
                    INC      tmp_band_offset+1            ; increment the offset 
                    INC      tmp_band_offset+1            ; by two 
                    TFR      D,X                          ; store that in X index register 
                    STU      ,X                           ; save the current object_list position to band_list 
                    PULS     X,D                          ; and restore the pointer to level information 
                                                          ; in D still the current object 
; init dive turtle start
; a list with a max of 6, not checked!
                    PSHS     D,X                          ; save D and X 
                    TFR      D,Y                          ; transfer D to index Y, get the object pointer to Y 
                    LDA      10,Y                         ; load special to A 
                    ANDA     #SPECIAL_DIVE                ; look if it is a DIVE_SPECIAL 
                    BEQ      this_is_no_dive_object       ; if not, go on 
                    LDB      tmp2+1                       ; counter for number of divers 
                    LDX      #t_list                      ; position to store divers 
                    STU      B,X                          ; store object_list position to t_list plus offset 
                    INCB                                  ; and increment list pointer by 2 
                    INCB     
                    STB      tmp2+1                       ; and store it back 
this_is_no_dive_object: 
                    PULS     D,X                          ; restore D and X 
; init dive turtle end
; now store the object definition address to the object_list
; and initialize all variables...
                    STD      ,U++                         ; and store it to object_list increment U by two 
                    TFR      D,Y                          ; transfer D to index Y 
                    LDD      7,Y                          ; load the offsets from Y pointer 
                    STA      ,U                           ; y offset (these are offset in the sprite) 
                    STB      1,U                          ; x offset itself, an offset to the starting vector 
                    LDB      loop1                        ; now get the y pos 
                    SUBB     #6                           ; make it signed 
                    LDA      #GRID_SIZE_GAME              ; in game pos relation 
                    MUL                                   ; should be a byte value 
                    ADDB     ,U                           ; add to offset 
                    STB      ,U+                          ; and store it to object... increment U by one 
                    LDB      loop2                        ; now get the x pos 
                    NEGB                                  ; reverse the X coordinate 
                    ADDB     #6                           ; make it signed 
                    LDA      #GRID_SIZE_GAME              ; in game pos relation 
                    MUL                                   ; should be a byte value 
                    ADDB     ,U                           ; add to offset 
                    STB      ,U+                          ; and store it to object... increment U by one 
                    JSR      Random                       ; randomize the animation startup 
                                                          ; so that not all sprites are animated 
                                                          ; in the same round... 
                    ANDA     #$f                          ; maximum of 15 
                    INCA                                  ; at least one 
                    STA      ,U+                          ; store it to anim counter 
move_on: 
                    DEC      loop2                        ; dec loop2 
                    BNE      _loop2                       ; end check if finnished 
                    lda      game_level 
                    cmpa     #16 
                    bne      doTheRest 
                    clra     
                    STA      girl_status                  ; store to status, this means no girl on screen 
                    sta      girl_log_object 
                    sta      girl_log_object+1            ; default girl_object = 0 
                    sta      girl_round_counter_reset     ; if !=0 than it is the round_counter 
                    rts      

doTheRest 
;                    lbeq     no_reinit_stuff 
                    LDD      #16                          ; fixed band list len 
                    ADDD     tmp_band_list                ; go one band list element further 
                    STD      tmp_band_list                ; and store it 
                    DEC      loop1                        ; dec loop1 
                    lBNE     _loop1                       ; end check if finnished 
error_list_to_long: 
                    TST      tmp2                         ; we don't won't to reinit 
                    LBNE     no_reinit_stuff              ; the next stuff 
                    LDA      ,X+                          ; fly 
                    cmpa     #NOT_AVAILABLE 
                    BNE      fly_available                ; if fly available , jump 
                    STA      fly_status                   ; store to status, this means no fly on screen 
                    BRA      fly_go_on                    ; and go on 

fly_available: 
                    STA      fly_timer_start              ; otherwise use A as timer information HI 
                    CLR      fly_timer_start +1           ; clear LO 
                    LDD      fly_timer_start              ; reload 
                    STD      fly_timer                    ; and set the used timer to it 
                    LDA      #IS_WAITING                  ; fly is waiting to be displayed 
                    STA      fly_status                   ; store it 
fly_go_on: 
                    LDA      ,X+                          ; crocodile 
                    cmpa     #NOT_AVAILABLE 
                    BNE      croco_available              ; if croco available , jump 
                    STA      croco_status                 ; store to status, this means no croco on screen 
                    BRA      croco_go_on                  ; and go on 

croco_available: 
                    STA      croco_timer_start            ; otherwise use A as timer information HI 
                    CLR      croco_timer_start +1         ; clear LO 
                    LDD      croco_timer_start            ; reload 
                    STD      croco_timer                  ; and set the used timer to it 
                    LDA      #IS_WAITING                  ; croco is waiting to be displayed 
                    STA      croco_status                 ; store it 
croco_go_on: 
                    CLR      otter_timer_start+1          ; reset LO of otter timer allways 
                    LDA      ,X+                          ; otter 
                    STA      otter_status                 ; store to status, this means no otter on screen if zero 
                    STA      otter_timer_start            ; otherwise use A as timer information HI 
                                                          ; rest of otter is initialized below in the 'always' section 
                    LDA      ,X+                          ; snake on log 
                    STA      snake_status                 ; store to status, this means no snake on log 
                    STA      snake_round_counter_reset    ; if !=0 than it is the round_counter 
                    BEQ      snake_go_on                  ; and go on 
                                                          ; x, y pos will be set in sprite draw loop 
                                                          ; speed will also be taken from host (log) object 
                    STA      snake_round_counter          ; and store it to object 
                    LDA      #5                           ; reasonably small value 
                    STA      snake_anim_counter           ; and store it to object 
                    LDY      #band_list+16+16             ; align snake to first object in band 3 
                    LDY      ,Y                           ; remember the object list position of that object 
                    LDU      ,Y                           ; get the object address 
                    LDA      ,U                           ; get the speed of the object 
                    INCA                                  ; allways go from left to right on startup... 
                    STA      snake_speed_start            ; store it 
                    LEAY     3,Y                          ; add three to object list position for easier checking in 
                                                          ; draw object routine 
                    STY      snake_log_object             ; save the objectlist address... 
snake_go_on: 
                    LDA      ,X+                          ; female 
                    STA      girl_status                  ; store to status, this means no girl on screen 
                    clr      girl_log_object 
                    clr      girl_log_object+1            ; default girl_object = 0 
                    STA      girl_round_counter_reset     ; if !=0 than it is the round_counter 
                    BEQ      girl_go_on                   ; and go on 
                                                          ; x, y pos will be set in sprite draw loop 
                                                          ; speed will also be taken from host (log) object 
                    STA      girl_round_counter           ; and store it to object 
                    lda      #GIRL_SPRING_TIMER           ; reasonable value for wait of first girl jump 
                    sta      girl_anim_counter 
                    CLR      girl_zero                    ; clear the girl zero vector 
                    CLR      girl_zero + 1                ; so that we jump out of the display loop 
                    LDY      #band_list+16+16+16          ; align girl to first object in band 4 
                    LDY      ,Y                           ; remember the object list position of that object 
                    LDU      ,Y                           ; get the object address 
                    LDA      ,U                           ; get the speed of the object 
                    STA      girl_speed                   ; store it 
                    LEAY     3,Y                          ; add three to object list position for easier checking in 
                                                          ; draw object routine 
                    STY      girl_log_object              ; save the objectlist address... 
girl_go_on: 
                    LDA      ,X+                          ; timer 
                    tst      did_rollOver 
                    beq      noroll1 
                    lsra     
                    cmpa     #40 
                    bgt      noroll1 
                    lda      #40 
noroll1: 
                    STA      my_timer_start               ; store time for level information 
                    LDA      #$e0                         ; and set low timer 
                                                          ; this now has the same length as the middway 
                                                          ; (if timer in level is set correctly that is) 
                    STA      my_timer_start+1             ; store it 
                    LDA      ,X+                          ; turtle timer 
                    STA      dive_timer_start             ; load the diving counter 
                    STA      dive_timer                   ; and set the timer for diving HI 
                    CLR      dive_timer+1                 ; clear LO 
                                                          ; from here on again some 'allways init' stuff 
no_reinit_stuff: 
                    LDA      girl_round_counter_reset     ; if !=0 than it is the round_counter 
                    STA      girl_round_counter           ; if !=0 than it is the round_counter 
                    BEQ      no_girl_on_this_level 
                    LDA      #IS_WAITING                  ; girl is waiting to be displayed 
no_girl_on_this_level: 
                    STA      girl_status                  ; store it 
                    LDA      snake_round_counter_reset    ; if !=0 than it is the round_counter 
                    STA      snake_round_counter          ; if !=0 than it is the round_counter 
                    BEQ      no_snake_on_this_level 
                    LDA      #IS_WAITING                  ; snake is waiting to be displayed 
no_snake_on_this_level: 
                    STA      snake_status                 ; store it 
                    LDD      otter_timer_start            ; reload the otter timer 
                    STD      otter_timer                  ; and store it 
                    BEQ      no_otter_on_this_level 
                    LDA      #IS_WAITING                  ; otter status now is 'is waiting' 
no_otter_on_this_level: 
                    STA      otter_status                 ; store the status 
                    CLR      frog_bonus                   ; no bonus collected for this frog 
                    LDD      my_timer_start               ; reset timer 
                    STD      my_timer                     ; store it 
                    LDA      #GRID_SIZE_GAME/2            ; needed for band information calculation 
                    STA      tmp_band_offset              ; when frog 'rides' an object 
; calculate skip count
                    clr      skipCount 
                    ldx      #band_list                   ; band 0 
countOn1: 
                    ldu      ,x++ 
                    beq      nextBand1 
                    inc      skipCount 
                    bra      countOn1 

nextBand1: 
                    ldx      #band_list+16                ; band 1 
countOn2: 
                    ldu      ,x++ 
                    beq      nextBand2 
                    inc      skipCount 
                    bra      countOn2 

nextBand2: 
                    ldx      #band_list+16 +16            ; band 2 
countOn3: 
                    ldu      ,x++ 
                    beq      nextBand3 
                    inc      skipCount 
                    bra      countOn3 

nextBand3:
                    RTS      

;***************************************************************************
game_lost: 
                    lda      playerCountOption 
                    beq      checkDone 
                    lda      no_frogs2                    ; last played player lives 
                    blt      wasDeadAlready 
otherPlayerjustDied 
                    bsr      gameOverLoop 
                    jsr      checkHS2 
died_too 
                    _DP_TO_C8  
                    JSR      init_new_frog_vars           ; clear the frog variables 
                    JSR      DP_to_D0 
                    direct   $D0 
                    INIT_NEXT_MUSIC  inGameMusic1 
                    RTS      

wasDeadAlready: 
; check if current player is also dead
                    lda      no_frogs                     ; last played player lives 
                    bgt      died_too 
checkDone 
reallyOver: 
no_new_high: 
                    JSR      DP_to_C8                     ; not speed optimized, but space! 
                    direct   $C8 
                                                          ; do some extro 
                    ldd      #0                           ; clear A 
                    STA      game_over_intensity          ; and store in intensity 
                    STd      game_over_scaley             ; scale y 
                    STd      game_over_ypos               ; pos y 
                    bsr      gameOverLoop 
                    jsr      checkHS2 
                    JSR      DP_to_C8 
                    direct   $C8 
                    lda      gameModeOption 
                    cmpa     #1 
                    bne      new_game2 
                    jsr      clearMyScore 
                    JSR      reinit_level                 ; 
                    JSR      continue_level               ; clear the frog variables 
; correct stack, since we came here from a subroutine "jsr draw_objects"
                    leas     2,s 
                    JMP      restart_game                 ; 

new_game2 
                    puls     d                            ; correct stack 
getOutToNewGame: 
                    jmp      new_game 

end_of_end_of_game: 
                                                          ; BRA new_game ; start a new game 
                    direct   $d0 
;***************************************************************************
gameOverLoop: 
                    INIT_MUSICl  gameOverMusic            ; default 
                    clr      RecalCounter 
                    clr      RecalCounter+1 
game_over_loop1: 
                    _DP_TO_D0  
                    jsr      do_csa_sound_startup 
                    jsr      oneYMRound 
                    ldd      game_over_scaley             ; prepare drawing of game over string , load scaling stuff 
                    STD      Vec_Text_HW                  ; poke it to ram location 
                    LDA      game_over_intensity          ; load intensity 
 cmpa #$5f
 ble usethatintensity
 lda #$57
usethatintensity
                    JSR      Intensity_a                  ; set intensity 
                    ldd      game_over_ypos               ; load position, to D (A,B) register 
                    LDU      #game_over_string            ; and the address of the string itself 
                    JSR      Print_Str_d                  ; and draw it 
                                                          ; calculate new appearence 
                    LDA      game_over_intensity          ; increase intensity 
                    ADDA     #3                           ; three per step 
                    STA      game_over_intensity          ; store it 
         ;           ANDA     #$1                          ; every second step increase 
                    ANDA     #$3                          ; every second step increase 


                    BNE      no_y_scale_now               ; y scale of string 
                    LDA      game_over_scaley             ; load it 
                    SUBA     #1                           ; increase it 
                    STA      game_over_scaley             ; save it 
no_y_scale_now: 
                    LDA      game_over_ypos               ; now look at the position of the 
                    ADDA     #2                           ; string, first y pos 
                    CMPA     #$70                         ; increase it by two, but not to much 
                    BLO      use_y                        ; 
                    LDA      #$70                         ; maximum at $70 
use_y: 
                    STA      game_over_ypos               ; store it 
                    LDA      game_over_xpos               ; likewise treat x pos load it 
                    SUBA     #2                           ; decrease it 
                    CMPA     #-$70                        ; till -$70 
                    BGE      use_x                        ; 
                    LDA      #-$70                        ; or use minimum of -$70 
use_x: 
                    STA      game_over_xpos               ; store it 
                    LDA      game_over_scalex             ; now do the x scaling 
                    ADDA     #3                           ; every round add 3 
                    STA      game_over_scalex             ; and store it 
                    LDA      game_over_intensity          ; do all this 
                    CMPA     #$7f                         ; till intensity is full 
                    BLO      game_over_loop1              ; do the game loop 
                    JSR      Read_Btns                    ; get button status once, since only 
                                                          ; differences are noticed 
                    LDA      game_over_scalex             ; now correct x scaling 
                    SUBA     #3                           ; since it just rolled over, sub 3 
                    STA      game_over_scalex             ; and store it 
                    lda      gameModeOption 
                    cmpa     #1 
                    bne      noMorph1 
                    LDU      #morph_countdown1            ; load address of morph structure 
                    JSR      set_up_morphing              ; and initialize a new morphing 
noMorph1 
game_over_loop2: 
                    _DP_TO_D0  
                    jsr      do_csa_sound_startup 
                    jsr      oneYMRound 
                    JSR      Intensity_5F                 ; and do it 
                    ldd      game_over_scaley             ; prepare drawing of game over string , load scaling stuff 
                    STD      Vec_Text_HW                  ; poke it to ram location 
                    ldd      game_over_ypos               ; load position, to D (A,B) register 
                    LDU      #game_over_string            ; and the address of the string itself 
                    JSR      Print_Str_d                  ; and draw it 
                    JSR      Intensity_5F                 ; and do it 
                    _ZERO_VECTOR_BEAM                     ; back to zero 
                    lda      gameModeOption 
                    cmpa     #1 
                    bne      noMorph3 
                    LDA      morph_status                 ; look of morphing is complete 
                    BEQ      new_game2_stack              ; don't morph anymore 
                    JSR      do_one_morph_step_16         ; does one morph step, changing of vectors 
                    _SCALE   (SCALE_FACTOR_VECTOR_MORPH/2) 
                    LDD      #(5*VEC_BLOWUP)              ; y=0, X = '5' 
                    JSR      Moveto_d                     ; and move there 
                    LDX      #current_morph_vectorlist    ; load the morph vector list to X 
                    _SCALE   (SCALE_FACTOR_VECTOR_MORPH)  ; scale it correctly 
                    JSR      Draw_VLc                     ; and draw the vectorlist 
                    _ZERO_VECTOR_BEAM                     ; back to zero 
                    LDD      #LITTLE_TEXT_SIZE            ; load score text size 
                    STD      Vec_Text_HW                  ; poke it to ram location 
                    LDD      #-$45*256+(lo(-$20))         ; load position, to D (A,B) register 
                    LDU      #continue_string             ; get address of string 
                    JSR      Print_Str_d                  ; and draw it 
;morph_complete:
noMorph2 
                    JSR      Read_Btns                    ; get button status 
                    CMPA     #$00                         ; is a button pressed? 
                    BEQ      game_over_loop2              ; no, than stay in game_over_loop2 
; here continue...
gameoverDone: 
                    rts      

noMorph3 
                    ldx      currentYLenCount             ; if music is playing, the length of the game over music determins the 
                    cmpx     #1                           ; length of the game over sign that is displayed 
                    bls      gameoverDone 
                    lda      musicOption                  ; if music is not playing 
                    beq      noMorph2 
                    ldx      RecalCounter 
                    cmpx     #150                         ; than show it for 3 seconds 
                    bgt      gameoverDone 
                    bra      noMorph2 

new_game2_stack 
                    leas     4,s 
                    jmp      getOutToNewGame 

;***************************************************************************
move_wait_draw_vlc_unloop: 
                    pulu     y                            ; load offset of vector list draw 
                    leay     >(unloop_start_addressSub+LENGTH_OF_HEADER),y ; 
                    LDD      #((SCALE_FACTOR_SPRITE*256)+$40) ; A= SCALE, B = Timer IRQ check 
                                                          ; the following is the position checking loop 
                                                          ; waiting till an interrupt occurs 
                    _SCALE_A                              ; scale for sprite 
                    LDA      #$80 
move_sprite_rest: 
                    BITB     <VIA_int_flags               ; test the bit 
                    BEQ      move_sprite_rest             ; if not zero, than loop 
                    STA      <VIA_aux_cntl                ; Shift reg mode = 000 free disable, T1 PB7 enabled 
unloop_start_addressSub: 
                    MY_SPRITE_DRAW_VLC_UNLOOP  
                    nop      8 
                    rts      

;***************************************************************************
do_my_sound 
                    DO_SOUND  
                    rts      

;***************************************************************************
; destroys D X U
; play the given SFX, but only if nothing else is played (regardless of prio)
play_sfx_x_if_nothing_else 
                    tst      currentSFX 
                    bne      no_new_12 
play_sfx_x 
                    ldu      currentSFX                   ; load current sfx 
                    beq      storeO_12k                   ; if none playing - jump 
                    lda      2,u                          ; load current prio to a 
                    cmpa     2,x                          ; compare to prio of new sfx 
                    bgt      no_new_12                    ; if old prio is higher than go out 
storeO_12k: 
                    stx      currentSFX                   ; so we store it as current sfx 
                    ldx      ,x                           ; and the actual sfx data store to our sfx player vars 
                    stx      sfx_pointer_3 
                    LDA      #$01                         ; tell the player, that it should play! 
                    STA      sfx_status_3 
no_new_12 
                    rts      

;***************************************************************************
do_csa_sound_startup: 
                    bsr      do_my_sound 
do_csa_startup 
                    FULL_WAIT_RECAL  
calibration 
                    VECTOR_RESET  
                    rts      

;***************************************************************************
getMyRandom 
                    lda      RecalCounterLow 
                    adda     my_random 
                    sta      my_random 
                    rts      

;***************************************************************************
query_joystick: 
                    QUERY_JOYSTICK  
                    rts      

;***************************************************************************
my_move_to_d 
                    MY_MOVE_TO_D  
                    rts      

;***************************************************************************
shutup 
                    MY_QUIT  
                    DO_MY_SOUND  
                    JSR      DP_to_D0 
                    JMP      Do_Sound                     ; ROM function that does the sound playing 

                                                          ;rts 
;***************************************************************************
;smallCalibration
; RESET_INT
; _ZERO_VECTOR_BEAM
; rts
;***************************************************************************
; rotation coords, actually X = -sin, Y = cos
; BIOS also has a sin table, but that one is one 1/4 of a full wave
; and it is called so weirdly (Rise/Run)
; this is straight forward and I don't have to check in what quarter I am or whether I am cos or sin...
; thank god we have the space :-) 
coords_list: 
                    DB       +$00, +$78                   ; draw to y, x 
                    DB       -$0C, +$77                   ; draw to y, x 
                    DB       -$19, +$75                   ; draw to y, x 
                    DB       -$24, +$72                   ; draw to y, x 
                    DB       -$30, +$6E                   ; draw to y, x 
                    DB       -$3B, +$68                   ; draw to y, x 
                    DB       -$46, +$62                   ; draw to y, x 
                    DB       -$4F, +$5A                   ; draw to y, x 
                    DB       -$58, +$52                   ; draw to y, x 
                    DB       -$60, +$48                   ; draw to y, x 
                    DB       -$67, +$3E                   ; draw to y, x 
                    DB       -$6D, +$33                   ; draw to y, x 
                    DB       -$71, +$27                   ; draw to y, x 
                    DB       -$75, +$1C                   ; draw to y, x 
                    DB       -$77, +$0F                   ; draw to y, x 
                    DB       -$78, +$03                   ; draw to y, x 
                    DB       -$78, -$09                   ; draw to y, x 
                    DB       -$76, -$16                   ; draw to y, x 
                    DB       -$73, -$22                   ; draw to y, x 
                    DB       -$6F, -$2D                   ; draw to y, x 
                    DB       -$6A, -$38                   ; draw to y, x 
                    DB       -$64, -$43                   ; draw to y, x 
                    DB       -$5C, -$4D                   ; draw to y, x 
                    DB       -$54, -$56                   ; draw to y, x 
                    DB       -$4A, -$5E                   ; draw to y, x 
                    DB       -$40, -$65                   ; draw to y, x 
                    DB       -$36, -$6B                   ; draw to y, x 
                    DB       -$2A, -$70                   ; draw to y, x 
                    DB       -$1F, -$74                   ; draw to y, x 
                    DB       -$12, -$77                   ; draw to y, x 
                    DB       -$06, -$78                   ; draw to y, x 
                    DB       +$06, -$78                   ; draw to y, x 
                    DB       +$12, -$77                   ; draw to y, x 
                    DB       +$1F, -$74                   ; draw to y, x 
                    DB       +$2A, -$70                   ; draw to y, x 
                    DB       +$36, -$6B                   ; draw to y, x 
                    DB       +$40, -$65                   ; draw to y, x 
                    DB       +$4A, -$5E                   ; draw to y, x 
                    DB       +$54, -$56                   ; draw to y, x 
                    DB       +$5C, -$4D                   ; draw to y, x 
                    DB       +$64, -$43                   ; draw to y, x 
                    DB       +$6A, -$38                   ; draw to y, x 
                    DB       +$6F, -$2D                   ; draw to y, x 
                    DB       +$73, -$22                   ; draw to y, x 
                    DB       +$76, -$16                   ; draw to y, x 
                    DB       +$78, -$09                   ; draw to y, x 
                    DB       +$78, +$03                   ; draw to y, x 
                    DB       +$77, +$0F                   ; draw to y, x 
                    DB       +$75, +$1C                   ; draw to y, x 
                    DB       +$71, +$27                   ; draw to y, x 
                    DB       +$6D, +$33                   ; draw to y, x 
                    DB       +$67, +$3E                   ; draw to y, x 
                    DB       +$60, +$48                   ; draw to y, x 
                    DB       +$58, +$52                   ; draw to y, x 
                    DB       +$4F, +$5A                   ; draw to y, x 
                    DB       +$46, +$62                   ; draw to y, x 
                    DB       +$3B, +$68                   ; draw to y, x 
                    DB       +$30, +$6E                   ; draw to y, x 
                    DB       +$24, +$72                   ; draw to y, x 
                    DB       +$19, +$75                   ; draw to y, x 
                    DB       +$0C, +$77                   ; draw to y, x 
;***************************************************************************
;twinklers = current_brightness+1 ;
;
;                    struct   Twinkle 
;                    ds       TWINKEL_Y,1                       ; 
;                    ds       TWINKEL_X,1                       ; 
;                    ds       TWINKLE_ANGLE,1                      ; 
;                    ds       TWINKLE_BRIGHTNESS,1                 ; 
;                    ds       TWINKLE_LENGTH,1                 ; scale
;                    ds       TWINKLE_COUNTER,1                 ; 
;                    end struct 
; d0 needed
; in X twinkler
; moves to position, draws an arm, negates "arm" and moves back to pos
; that three times for a full three armed "twinkler"
;***************************************************************************
oneTwinkleStep 
                    lda      TWINKLE_COUNTER,X            ; still twinkling? 
                    beq      twinkleDone                  ; no - than we are waiting - jump to done 
                    pshs     a                            ; remember counter (for easier acces to S, one might argue that also saves one cycle - hahaha, wasted by puls, push 
                    _DP_TO_D0  
                    ldy      #coords_list 
                    jsr      Reset0Ref 
                    MY_GAME_SCALE                         ; scale to do positioning 
                    ldd      TWINKEL_Y,X 
                    jsr      Moveto_d 
                    ldd      TWINKLE_BRIGHTNESS,X         ; brightness and scale is increased decreased with sin (from coordinates) 
                    andb     #%11111110                   ; only acces sin of coords 
                    ldb      b,y 
                    lsrb     
                    lsrb     
                    lsrb     
                    lsrb     
                    lsrb                                  ; scale is only on 16ths of sine value 
                    _SCALE_B                              ; and set scale 
                    anda     #%11111110                   ; only acces sin of coords 
                    lda      a,y 
                                                          ; _INTENSITY_A ; and set intensity 
                    jsr      Intensity_a 
; first "arm"
                    lda      ,s 
                    ldd      a,y 
                    jsr      Draw_Line_d 
                    leax     -2,x                         ; drawLine_d add 2 
; go back to center
                    lda      ,s 
                    ldd      a,y 
                    nega     
                    negb     
                    jsr      Moveto_d 
; second "arm"
                    lda      ,s 
                    adda     #40                          ; one third 
                    cmpa     #120 
                    blo      noOverflow1 
                    suba     #120 
noOverflow1 
                    ldd      a,y 
                    pshs     d 
                    jsr      Draw_Line_d 
                    leax     -2,x                         ; drawLine_d add 2 
; go back to center
                    puls     d 
                    nega     
                    negb     
                    jsr      Moveto_d 
; third "arm"
                    lda      ,s 
                    adda     #80                          ; one third 
                    cmpa     #120 
                    blo      noOverflow2 
                    suba     #120 
noOverflow2 
                    ldd      a,y 
                    jsr      Draw_Line_d 
                    leax     -2,x                         ; drawLine_d add 2 
                    dec      TWINKLE_LENGTH,X 
                    dec      TWINKLE_BRIGHTNESS,X 
                    dec      TWINKLE_COUNTER,X            ; counter decreased twice, since positions are word pointers 
                    dec      TWINKLE_COUNTER,X 
                    puls     a 
twinkleDone: 
                    rts      

;***************************************************************************
; in x twinler struct
initTwinkler 
                    tst      TWINKLE_COUNTER,x            ; should we init this twinkler? 
                    bne      noTwinkleInit                ; no than jump 
                    dec      TWINKLE_WAIT,x               ; wait for next init over? 
                    bne      noTwinkleInit                ; no - jump 
; reset all values
                    ldd      #0 
                    std      TWINKEL_Y,x 
                    ldd      #$7878                       ; 120 to brightness and scale, pointer to "sine" data actually 
                    std      TWINKLE_ANGLE,x 
                    sta      TWINKLE_LENGTH,x 
                    sta      TWINKLE_COUNTER,x            ; one twinkle round is also 120, since 120 = 360°, that is one full circle of our "arms" 
                    jsr      Random                       ; find the position of our twinkle in the position table 
                    anda     #%00011111                   ; 0 - 31 
                    lsla                                  ; *2 
                    ldu      #twinklerpositions 
                    ldd      a,u 
                    sta      TWINKEL_Y,x 
                    stb      TWINKEL_X,x 
                    jsr      Random                       ; when that twinkle is finished - how long to restart the next init? -> random 
                    lsra                                  ; values from 0 - 127 
                    sta      TWINKLE_WAIT,x 
noTwinkleInit 
;***************************************************************************
                    rts      

; Possible "twinkle" positions, all on an edge of the "KARL QUAPPE" bitmap
twinklerpositions: 
                    db       67, 40 
                    db       67, 15 
                    db       67, 15 
                    db       67, 20 
                    db       73, -20 
                    db       88, -57 
                    db       77, -85 
                    db       77, -63 
                    db       77, -30 
                    db       77, 17 
                    db       77, 45 
                    db       77, 87 
                    db       79, 80 
                    db       74, 84 
                    db       74, 69 
                    db       79, 65 
                    db       79,50 
                    db       77, 45 
                    db       67, 100 
                    db       67, 90 
                    db       67, 31 
                    db       67, 7 
                    db       67, -32 
                    db       67, -70 
                    db       67, -83 
                    db       88, 100 
                    db       88, 90 
                    db       88, 31 
                    db       88, 7 
                    db       88, -32 
                    db       88, -70 
                    db       88, -83 
;***************************************************************************
; this routine draws the initial screen
; with information about the game
; nothing is expected and nothing is returned
; leaves dp pointing d0 expected
init_screen: 
                    jsr      init_new_frog_vars           ; since a frog moves - we init all frog vars 
                    ldx      #0 
                    stx      frog_pos 
                    ldd      #$0707                       ; starting pos of frog on init screen 
                    std      frog_pos_band 
                    lda      #TWINKLE_COUNT               ; do our twinklings first, call init for all of them, 
                    sta      tmp1                         ; counter for init 
                    ldx      #twinklers                   ; RAM position of twinkle data 
                    ldd      #1 
initNextTwinkle 
                    sta      TWINKLE_COUNTER,x 
                    stb      TWINKLE_WAIT,x 
                    addb     #25                          ; first twinklers are 0.5 seconds apart, (next will be random) 
                    leax     Twinkle,x                    ; next entry 
                    dec      tmp1 
                    bne      initNextTwinkle              ; loop thru all entries 
                    ldx      initMoveTable                ; here the table for our different frog move data is loaded 
                    ldu      ,x                           ; select move data 
                    bne      douseit                      ; if zero, than end of table reached - reset table pos 
                    ldx      #initMoveTable_addresses 
                    stx      initMoveTable 
                    ldu      ,x                           ; and use the "first entry (this must be != 0) 
douseit: 
                    stu      attractMovePointer           ; and save the froge movement pointer to its "used" location 
                    leax     2,x                          ; increase movement table for next "round" 
                    stx      initMoveTable 
                    inc      isAttractMode                ; switch to atttract mode, other wise frog movement routine does "in game" stuff as well (jump into a house or so) 
                    JSR      DP_to_D0 
                    direct   $D0 
                    clr      RecalCounter 
                    clr      RecalCounter+1 
                    JSR      Read_Btns                    ; get button status once, since only 
                                                          ; differences are noticed 
                    JSR      DP_to_C8 
                    direct   $C8 
                    LDA      #$6f                         ; startup intensity 
                    STA      init_current_intensity       ; store it to current intensity 
                    clr      tmp2                         ; tmp2 = 0 dec , 1 = inc 
                    ldx      #messages                    ; setup messages to display at the botom - start with message 0 
                    stx      tmp1 
                    jsr      shutup 
init_screen_loop_1: 
                    direct   $D0 
                    LDA      Vec_Music_Flag               ; is music still playing? 
                    BNE      no_new_music_1               ; than jump 
                    LDX      #yankee                      ; load adddress of music structure 
                    PLAY_SOUND  yankee                    ; and play the tune again... 
no_new_music_1: 
                    ROUND_STARTUP                         ; well, the startup... 
                    ldx      #twinklers                   ; do twinklers first, for all of the do 
doNextTwinkle 
                    pshs     x 
                    jsr      initTwinkler                 ; check if new twinkle should start, and sets it up 
                    jsr      oneTwinkleStep               ; and do one twinkling step (or increase waiter) 
                    puls     x 
                    leax     Twinkle,x 
                    cmpx     #twinklers+(Twinkle*TWINKLE_COUNT) 
                    bne      doNextTwinkle 
                    ldx      RecalCounter                 ; load "timer" 
                    cmpx     #1240                        ; 50 = 1 second, when 50 Hz 
                    bne      noAttract 
doAtta1 
                    clr      Vec_Music_Flag               ; if timer readed about 10 seconds (all messages were displyed ones) 
                    jsr      doAttractMode                ; call the attract mode "game" 
                    clr      RecalCounter 
                    clr      RecalCounter+1 
                    jmp      init_screen                  ; and start anew from the beginning of init screen 

noAttract 
                    jsr      calibration 
; print bitmap
                    LDD      #$Fa38                       ; load default text height & width 
                    STD      Vec_Text_HW                  ; poke it to ram location 
                    JSR      Intensity_5F                 ; Sets the intensity of the 
                    ldd      #$7f81 
                    LDU      #FroggerLogo_data 
                    JSR      draw_raster_image            ; print routine 
                    jsr      calibration 
; print messages
; the fade in and out (different directions of intensity increase/decrease are handled in the next
; couple of lines
                    lda      init_current_intensity       ; messages fade in and out 
                    tst      tmp2                         ; indicator to increase / decrease intensity (1= increase, 0 = decrease) 
                    bne      incInt 
                    deca     
                    cmpa     #$10                         ; on intensity of 10 (decreasing) the message is changed to next 
                    bne      goOnInta                     ; otherwise go on 
                    inc      tmp2                         ; switch to intensity increase 
changeStringPointer 
                    ldx      tmp1                         ; message pointer + "1" 
                    leax     2,x 
                    stx      tmp1 
                    ldu      ,x 
                    bne      goOnInta 
                    ldx      #messages                    ; store current message pointer to tmp1 
                    stx      tmp1 
                    bra      goOnInta 

incInt 
                    inca     
                    cmpa     #$70                         ; maximum message brighness 
                    bne      goOnInta 
                    clr      tmp2                         ; switch to brightness decrease 
goOnInta 
                    sta      init_current_intensity       ; set the intensity we got currently 
                    JSR      Intensity_a 
                    ldd      #$fe2d 
                    std      Vec_Text_Height 
                    lda      #70 
                    _SCALE_A  
                    LDU      [tmp1] 
                    ldd      #$8e95                       ; y = -114, x = -107 ; location of message 
                    jsr      sync_Print_Str_d 
                    lda      #$cc 
                    sta      <VIA_cntl                    ; reset to 0 
                    jsr      calibration 
no_morph_display: 
                    jsr      oneFrog_move_init 
                    JSR      Read_Btns                    ; get button status 
                    CMPA     #$00                         ; is a button pressed? 
                    lBEQ     init_screen_loop_1           ; no, than stay in init_screen_loop 
                    cmpa     #8 
                    beq      dooptionss_screen 
                    cmpa     #1 
                    beq      exit_init_screen_1           ; starting a game is actualy only "exiting" the init screen 
                    cmpa     #2 
                    beq      do_highscore_screen 
                    cmpa     #4 
                    lbeq     doAtta1 
                    anda     #$f0 
                    lbne     goback 
                    jmp      init_screen_loop_1 

do_highscore_screen 
                    jsr      highscores_screen 
                    jmp      init_screen_loop_1 

dooptionss_screen 
                    ldy      tmp2 
                    ldx      tmp1 
                    pshs     x,y 
                    ldx      RecalCounter 
                    pshs     x 
                    jsr      option_screen 
                    puls     x 
                    stx      RecalCounter 
                    puls     x,y 
                    sty      tmp2 
                    stx      tmp1 
                    jmp      init_screen_loop_1 

exit_init_screen_1:                                       ;       otherwise proceed 
                    clr      isAttractMode 
                    clr      Vec_Music_Flag 
                    RTS      

;***************************************************************************
; check whether current game score (of a "game over" game)
; is worthy of high score table
; if so the highscore screen will be "called" in editor mode, and the player
; can enter his 3 letters
checkHS2: 
                    lda      gameModeOption 
                    cmpa     #1 
                    beq      noHSOptio2n                  ; Training = no HS 
                    tst      highScoreReached             ; no - noHs 
                    beq      noHSOptio2n                  ; Training = no HS 
; in 'highScorePlace' is our place and
; in 'highScoreDone' is the hex value of our score
; in 'highScoreLevel' is our current level (-1)
                    ldx      #highScoreTable 
                    tst      gameModeOption 
                    beq      torunamentHSchs2 
                    ldx      #highScoreHardTable 
torunamentHSchs2: 
                    tfr      x,y 
                    leay     (5*HighScoreEntry),y         ; last hs entry + 1 
                    leax     (4*HighScoreEntry),x         ; last hs entry 
                    ldb      #4                           ; highscore place to compare with - from last to first 
compareNext 
                    cmpb     highScorePlace               ; from previous testings we now (if we achieved highscore - the place of the entry (sounds redundant...) 
                    beq      putHSToX                     ; if place was found - put the current values in there 
                    decb                                  ; otherwise we copy the score form one entry above to this entry, since the high score list "scrolls" down one entry 
                    leax     -HighScoreEntry,x            ; 10 (HighScoreEntry) = length of a highscore entry 
                    leay     -HighScoreEntry,y 
                    bsr      copyHSEntry                  ; copy the selected data downwards 
                    bra      compareNext                  ; and do next entry if our place was not reached 

putHSToX: 
; convert score to ascii
                    ldd      highScoreDone                ; load score to D 
                    pshs     x                            ; save X 
                    jsr      convertDToAscii              ; convert to ascii 
                    puls     x 
                    ldu      #conversionBuffer            ; result is in conversion buffer 
                    ldd      ,u++                         ; copy conversion buffer ascii data 
                    std      4,x                          ; to our current place in the highscore table 
                    ldd      ,u++ 
                    std      6,x 
                    ldd      ,u++ 
                    std      8,x 
                    lda      highScoreLevel               ; also copy the level we achieved 
                    inca                                  ; plus one, since the levels are 0 based 
                    sta      3,x 
                    inc      highScoreEditMode            ; switch to high score editor mode 
                    jsr      highscores_screen            ; and call the high score screen 
                    clr      highScoreEditMode            ; switch editor mode off 
                    lda      gameModeOption 
                    beq      tournamentSave 
hardmodeSave 
                    ldd      #(EEPROM_STORESIZE_HS*256)+EEPROM_HS2_BLOCK 
                    ldx      #highScoreHardcoreBlock 
                    bra      doTheSave 

tournamentSave 
                    ldd      #(EEPROM_STORESIZE_HS*256)+EEPROM_HS1_BLOCK 
                    ldx      #highScoreCompetitionBlock 
doTheSave 
                    std      current_eprom_blocksize 
                    jsr      eeprom_save_highscore 
noHSOptio2n 
                    rts      

;***************************************************************************
; copy HS entry from x to y - without destroying register
copyHSEntry 
                    pshs     d,x,y 
                    ldb      #HighScoreEntry              ; length of one entry 
contcopyhs 
                    lda      ,x+ 
                    sta      ,y+ 
                    decb     
                    bne      contcopyhs 
                    puls     d,x,y ,pc 
;                    rts      
;***************************************************************************
doAttractMode 
                    inc      isAttractMode                ; set flag that we "play" in attract mode 
                    JSR      init_vars                    ; initialize game variables 
reloadAt: 
                    lda      attractCount                 ; which attract level do we "play" 
                    inc      attractCount 
                    lsla                                  ; times two since its a word pointer 
                    ldx      #attractLevels               ; leval data table 
                    ldx      a,x                          ; load calculated entry 
                    bne      alevelGot                    ; if not 0 than we got a correct entry 
                    clr      attractCount                 ; attract rollover 
                    bra      reloadAt 

alevelGot 
                    lda      ,x+                          ; first byte indicates level number 
                    sta      game_level                   ; store this as current level 
                    stx      attractMovePointer           ; store x as current attract level "movement" pointer, accessing "joystick" subroutine read this 
                    ldd      #$2060                       ; and setup the blinking "press button" 
                    std      buttonBlinker 
                    jsr      attractEnter                 ; enter the main loop at the "attract" enter point, from here on it is a "normal" game 
                    clr      isAttractMode                ; once the game finishes - clear attract mode, 
                    rts                                   ; and go back to init screen 

;***************************************************************************
                    INCLUDE  "epromStuff.i"
;***************************************************************************
                    direct   $c8 
;***************************************************************************
                    include  "ayfxPlayer_f.i"
;***************************************************************************
                    INCLUDE  "IMISSION.I"
;***************************************************************************
                    INCLUDE  "MORPH.I"
;***************************************************************************
                    INCLUDE  "rasterDraw.asm"
;***************************************************************************
                    include  "highscoreStuff.I"
;***************************************************************************
game_over_string: 
                    DB       "GAME OVER", $80
level_complete_text: 
                    DB       "+500 BONUS", $80
cause_strings: 
home_full: 
                    DB       " HOME OCCUPIED", $80
wall_jump: 
                    DB       " HOME NOT FOUND", $80
car: 
                    DB       " DEATH BY WHEEL", $80
out: 
                    DB       " OUT OF BOUNDS", $80
drown: 
                    DB       "    DROWNED", $80
snake: 
                    DB       "SNACK FOR SNAKE", $80
croco: 
                    DB       " CROCODILE ROCK", $80
mole: 
                    DB       " EATEN BY OTTER", $80
time: 
                    DB       " NATURAL DEATH", $80
;***************************************************************************
; include vector sprite definitions
                    INCLUDE  "attractData.i"
                    INCLUDE  "vlists\\MORPHS.I"
                    INCLUDE  "vlists\\HOMES.I"
                    include  "vlists\\FROG_DeathUnloop.I"
                    INCLUDE  "vlists\\LETTERS.I"
                    INCLUDE  "vlists\\gimmick.I"
                    INCLUDE  "FASTSPRI.I"
                    INCLUDE  "PRINT.I"
                    INCLUDE  "options.i"
                    INCLUDE  "InMovesSubs.i"
                    INCLUDE  "musics.i"
                    INCLUDE  "KarlLogo.asm"
DFEE8:              FDB      $7788,$8877,$7766,$6555,$5544,$4433,$3333,$3333 
;***************************************************************************
yankee: 
                    INCLUDE  "YANKEE.I"
;***************************************************************************
messages: 
                    dw       message1 
                    dw       message2 
                    dw       message5 
                    dw       message3 
                    dw       message4 
                    dw       message6 
                    dw       message7 
                    dw       0 
message1: 
                    db       "BUTTON 1 - START GAME", $81
message2: 
                    db       "BUTTON 2 - HIGH SCORES", $81
message3: 
                    db       "BUTTON 4 - OPTIONS", $81
message4: 
                    db       " WRITTEN BY MALBAN", $81
message5: 
                    db       "BUTTON 3 - ATTRACT", $81
message6: 
                    db       "    FREE EDITION", $81
message7: 
                    db       "    FREE FOR ALL!", $81 
;***************************************************************************
; stupid assembler, these defines must be made after the above
; labels
LEVEL_DATA_LENGTH   EQU      ((level2_data-level1_data))  ; length of one level in byte 
; following are string offsets for the different deaths
DIE_HOME_FULL       EQU      (lo(home_full-cause_strings)) 
DIE_WALL_JUMP       EQU      (lo(wall_jump-cause_strings)) 
DIE_CAR             EQU      (lo(car-cause_strings)) 
DIE_OUT             EQU      (lo(out-cause_strings)) 
DIE_DROWN           EQU      (lo(drown-cause_strings)) 
DIE_SNAKE           EQU      (lo(snake-cause_strings)) 
DIE_CROCO           EQU      (lo(croco-cause_strings)) 
DIE_HOME_CROCO      EQU      (lo(croco-cause_strings)) 
DIE_MOLE            EQU      (lo(mole-cause_strings)) 
DIE_TIME            EQU      (lo(time-cause_strings)) 
;***************************************************************************
goback 
ramfunction         equ      newEepromRAMStart 
;
;   Immediately back to menu
;
                    ldu      #ramfunctiondata             ; copy the vec4ever switching function into place 
                    ldx      #ramfunction 
                    lda      #1+ramfuncend-ramfunctiondata 
                    jsr      Move_Mem_a 
                    ldx      #$1000                       ; the 'switch back to menu' command 
                    jmp      ramfunction                  ; up up and away 

COPY_RAM_TO_VECROM  
                    ldu      #v4e_saveBlockStart          ; Source copy the vec4ever switching function into place 
                    ldx      #vec4SaveBuffer              ; destination 
                    lda      #1+(v4e_saveBlockEnd-v4e_saveBlockStart) 
                    jmp      Move_Mem_a 

store_score 
                    bsr COPY_RAM_TO_VECROM  
; ldu #highScoreTable
; lda #'A'
; sta 0,u
                    ldu      #StoreHiscoreFnc             ; copy the vec4ever switching function into place 
                    ldx      #ramfunction 
                    lda      #1+StoreHiscoreFncEnd-StoreHiscoreFnc 
                    jsr      Move_Mem_a 
                    ldx      #$4000                       ; the 'store data' command 
                    jmp      ramfunction                  ; up up and away 

;
; the function below does the magic handshake with the cart,
; then waits for the new cart data to appear in the cart address
; space and jumps back to the v4e cart
;
StoreHiscoreFnc 
                    lda      $7ff0                        ; notify v4e 
                    lda      ,x                           ; and put command on the bus 
                    ldd      # "g "
v4eloop             cmpd     $0                           ; while the cart is working there is only one data byte 
                    bne      v4eloop                      ; header just in case 
                    rts      

StoreHiscoreFncEnd 
;
; the function below does the magic handshake with the cart,
; then waits for the new cart data to appear in the cart address
; space and jumps back to the menu
;
ramfunctiondata 
                    ldb      $7ff0                        ; notify the cart uProc 
                    ldb      ,x                           ; put command on the bus 
                    ldx      #0 
                    ldd      # "g "
ramloop             cmpd     0,x                          ; while the cart is setting up itself there is only one data byte 
                    bne      ramloop                      ; available, so check for .two. known and different ones 
                    leax     $D,x                         ; 0-A: "GCE xxxx",$80 / B+C: music pointer (could contain a zero..) 
ramloop2            lda      ,x+                          ; look for end of menu cart header 
                    bne      ramloop2 
                    tfr      x,pc                         ; return to menu code data 
ramfuncend 
vec4SaveBuffer: 
                    ds       (v4e_saveBlockEnd-v4e_saveBlockStart) 
 if USE_PB6 = 1
PADDBYTES:          ds       706
 else
PADDBYTES:          ds       706+7
 endif
vec4Register: 
                    ds       16 
;***************************************************************************
                    END      entry_point 
;***************************************************************************
