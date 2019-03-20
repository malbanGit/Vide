;
; VECTREX FROGGER
;
; this file is part of vectrex frogger, written by Malban
; in March-April 1998
; all stuff contained here is public domain
;
; comments and vectrex talk are welcome
; my email: malban@email.de
;
;
; following command line was used to assemble:
;
; C:>as09.exe -w200 -h0 -l -mcti frogger.asm >error
;
; I used the 6809 assembler:
; as09 [1.11].
; Copyright 1990-1994, Frank A. Vorstenbosch, Kingswood Software.
; Available at:
; http://www.falstaff.demon.co.uk/cross.html
;
; NOWN BUGS(!)
; * bug with diving turtle is still there (offsets of sprite higher 5)
;   - rarely seen!
; * sound glitches, dunno, what causes that
; * some vector drawings are not 100% exact, due to optimizations used
;
USE_LOOP_UNROLING EQU 1 ; loop unrolling costs nearly 1KB
                        ; look for this define in the source
                        ; to see all changes
;
                INCLUDE "VECTREX.I" ; vectrex function includes
; I like these makro definitions, they are like inlining :-)
                INCLUDE "MAKROS.I"  ; vectrex functions as macros (some)
; user variable definitions
; $c880
user_ram                        EQU    $c880              ; well start of our ram space
user_ram_start                  EQU    user_ram
music_active                    EQU    user_ram           ; pointer to music piece which is playing now
music_counter                   EQU    music_active + 2   ; pointer to weridos, used only in init screen
tmp1                            EQU    music_counter + 2  ; two temporal storage variables
tmp2                            EQU    tmp1 + 2           ; ...
mul_tmp1                        EQU    tmp2 + 2           ; two variable used in MY_MUL only
mul_tmp2                        EQU    mul_tmp1 + 2       ;
current_brightness              EQU    mul_tmp2 + 2       ; currently set brightness (why didn't I use the vectrex's os variable???)
                                ; following are some variable used only when something is 'morphing'
morph_status                    EQU    current_brightness + 1 ; status---
morph_tmp                       EQU    morph_status + 1   ; saves a few cycles... for the step counter only in one_morph_step
morph_sign                      EQU    morph_tmp + 1      ; number of steps between 'from' and 'to' variable
morph_counter                   EQU    morph_sign + 1     ; number of steps between 'from' and 'to' variable
morph_steps                     EQU    morph_counter + 1  ; number of steps between 'from' and 'to' constant
morph_delay                     EQU    morph_steps + 1    ; delay between one step and another (variable)
morph_structure                 EQU    morph_delay + 2    ; pointer to morphstructure of current morphing
morph_div_jsr                   EQU    morph_structure + 2; pointer to indirectly JSR to a divide routine (for optimization)

; following are 'in game' variables, out of the game these can be reused
scroll_variables_start          EQU    morph_div_jsr + 2  ; from here reuse scroll variables...
; from here only variables in game!!!
kind_of_death                   EQU    morph_div_jsr + 2  ; storage to text, what kind of death happened to frog
in_home_counter                 EQU    kind_of_death + 2  ; number of free homes in the currently played level
game_level                      EQU    in_home_counter + 1; what game level are we playing
current_frog_size_x             EQU    game_level + 1     ; size of frog 'sprites' following (all the same for now)
current_frog_offset             EQU    current_frog_size_x + 1 ; offset to 'zero' of current frog sprite
; a short note on the sprite offsets: all sprites have 'naturally' a starting
; point the offset is the space between that starting point and a 'virtual'
; grid position. the value of these offsets heavily depend on which scaling is used,
; so if you use a different 'resolution' these offsets must be changed also...

current_frog_heading            EQU    current_frog_offset + 2 ; what direction is frogger looking at
level_score                     EQU    current_frog_heading + 1; internel level score, score information is updated only
                                                          ; in between levels in the intermission sequences
last_joy_x                      EQU    level_score + 1    ; last joystick position X,
last_joy_y                      EQU    last_joy_x + 1     ; and Y,  for checking, we don't want an autorun feature...
current_frog_brightness         EQU    last_joy_y + 1     ; current brightness of frogger, not used anymore?
high_check                      EQU    current_frog_brightness + 1; checker variable for new life (every 10000 points)
frog_pos                        EQU    high_check + 1     ; position 16bit y,x of frog
frog_y                          EQU    frog_pos           ; y pos of frog
frog_x                          EQU    frog_y + 1         ; and the x
frog_pos_band                   EQU    frog_x + 1         ; band information (ranging from 0-11), y,x
frog_y_band                     EQU    frog_pos_band      ; band y information
frog_x_band                     EQU    frog_y_band + 1    ; band y information
frog_pic                        EQU    frog_x_band + 1    ; now used frog 'picture'
my_timer_start                  EQU    frog_pic + 2       ; reset value of level timer
y_timer                         EQU    my_timer_start + 2 ; y value of my timer vector line
my_timer                        EQU    y_timer + 1        ; x value of vector line (8bit) AND the timer variable itself (16bit) variable
fly_timer                       EQU    my_timer + 2       ; timer variable for fly
fly_timer_start                 EQU    fly_timer + 2      ; reset value of fly timer
fly_house                       EQU    fly_timer_start + 2; what house is the fly currently in
fly_status                      EQU    fly_house + 1      ; what's the flys status?
croco_timer                     EQU    fly_status + 1     ; croco (home) timer variable
croco_timer_start               EQU    croco_timer + 2    ; croco timer reset
croco_house                     EQU    croco_timer_start + 2; what house is the croco currently 'visiting'
croco_status                    EQU    croco_house + 1    ; what's the crocos status
dive_timer                      EQU    croco_status + 1   ; (turtle) dive timer variable
dive_timer_start                EQU    dive_timer + 2     ; reset value for the above
frog_bonus                      EQU    dive_timer_start + 1; what bonuses has frog collected? (girl, fly)
otter_status                    EQU    frog_bonus + 1     ; what's the otters status
otter_timer_start               EQU    otter_status + 1   ; otter timer reset value
otter_timer                     EQU    otter_timer_start + 2; otter timer variable
otter_log_pre                   EQU    otter_timer + 2    ; the 'logs' address of the 'log' BEFOR the otter
otter_log_past                  EQU    otter_log_pre + 2  ; the 'logs' address of the 'log' BEHIND the otter
otter_object                    EQU    otter_log_past + 2 ; the object information address of current otter
otter_pos                       EQU    otter_object + 2   ; current position of otter
otter_anim_counter              EQU    otter_pos + 2      ; animation counter of otter
otter_speed                     EQU    otter_anim_counter + 1; current speed of otter
otter_band                      EQU    otter_speed + 1    ; what band is otter swimming in?
girl_status                     EQU    otter_band + 2     ; what's the girls status?
girl_round_counter              EQU    girl_status + 1    ; counter, for what round girl will be next displayed
girl_round_counter_reset        EQU    girl_round_counter + 1; counter reset value
girl_log_object                 EQU    girl_round_counter_reset + 1 ; log, the girl is on, allways first log on second river band
                                ; following is an exact list object structure... for girl
girl_object                     EQU    girl_log_object + 2; pointer to current girl object information
girl_pos                        EQU    girl_object + 2    ; current position of girl
girl_anim_counter               EQU    girl_pos + 2       ; animation counter of girl
girl_zero                       EQU    girl_anim_counter + 1; allways a 16 bit zero, to jump out of the loop...
girl_speed                      EQU    girl_zero + 2      ; speed of girl
snake_status                    EQU    girl_speed + 1     ; snake's status (only one snake on logs possible for now)
snake_round_counter             EQU    snake_status + 1   ; counter, for what round snake will be next displayed (variable)
snake_round_counter_reset       EQU    snake_round_counter + 1; reset value for above
snake_log_object                EQU    snake_round_counter_reset + 1 ; 'log', the snake is on, allways first log on third river band!!!
snake_object                    EQU    snake_log_object + 2; pointer to snake's object definition
snake_pos                       EQU    snake_object + 2   ; position of snake (y,x)
snake_anim_counter              EQU    snake_pos + 2      ; animation counter for snake
snake_gone                      EQU    snake_anim_counter+1; number of steps a snake can make before turing arround
snake_speed_start               EQU    snake_gone + 1     ; startspeed of snake (determined by 'log's' speed)
snake_speed                     EQU    snake_speed_start+1; speed of snake now
 if USE_LOOP_UNROLING ==1
i_jump                          EQU    snake_speed + 1    ; indirect jump for vector list drawing unlooped
user_ram_end                    EQU    i_jump + 2         ; end of user ram
 else
user_ram_end                    EQU    snake_speed + 1    ; end of user ram
 endif
; following are some 'in' game variables which can be reused, they do not
; collide with the other side...
loop1                           EQU    tmp1               ; loop1 counter in level setup
loop2                           EQU    tmp1 + 1           ; loop2 counter in level setup
divide_tmp                      EQU    mul_tmp1           ; divide tmp variable, you don't divide while multiplying vice versa
tmp_band_offset                 EQU    mul_tmp1           ; used in level setup and gameplay, but there is NO multiplication in game...
tmp_band_list                   EQU    mul_tmp2           ; used in level setup
counter                         EQU    mul_tmp2           ; counter used in intermissions
game_over_intensity             EQU    current_frog_size_x; intensity of game over text
game_over_scaley                EQU    current_frog_heading; scale y of game over string
game_over_scalex                EQU    current_frog_offset; scale x of game over string
game_over_ypos                  EQU    last_joy_x         ; game over y position
game_over_xpos                  EQU    last_joy_y         ; game over x position

; variables that are only used on startup screen
; these use the same namespace as the above variables below
; scroll_variables_start
SCROLL_SCALE_FACTOR             EQU    $6                 ; constant, no variable, a scale factor, the offsets are calculated for this!
NUMBER_OF_SCROLL_LETTERS        EQU    8                  ; constant, number of letters visible at a time in the scroll text

scroll_text_address_start       EQU    scroll_variables_start ; start address of scroll variables, start address of scroll text
scroll_text_address_current     EQU    scroll_text_address_start + 2 ; current address of next scroll text letter
scroll_speed                    EQU    scroll_text_address_current + 2; speed of the scrolling
scroll_y                        EQU    scroll_speed + 1   ; y position of the scroll text
scroll_left_boundary            EQU    scroll_y + 1       ; left most position of scroll text
scroll_right_boundary           EQU    scroll_left_boundary + 1; right most position of scroll text
scroll_step_width               EQU    scroll_right_boundary + 1; how many 'pixels' the letters are appart
scroll_intensity                EQU    scroll_step_width + 1; intensity of scroll text
scroll_objects                  EQU    scroll_intensity + 1; start address of ram scroll text object definitions
scroll_objects_end              EQU    (scroll_objects+(5*NUMBER_OF_SCROLL_LETTERS)+1) ; space for number of letters for letter object definitions
scroll_variables_end            EQU    scroll_objects_end  ; the end...

; for init screen
init_screen_mode                EQU    scroll_variables_end + 1
init_current_intensity          EQU    init_screen_mode + 1

; see bottom of file for further addresses!

; following are a lot of constants which I declared for 'better'
; readability (and to keep things variable (constant<->variable!!!)) of the source...
; these are not really well sorted...
INIT_MODE_TEXT                  EQU 1         ; these two describe the mode
INIT_MODE_MORPH                 EQU 2         ; of the init screen

OTTER_X_LEN                     EQU  10       ; size of otter (x) for collision checking
SNAKE_GO_LIMIT                  EQU  55       ; number of 'pixels' a snake can go before turing arround
MAX_SPRITE_OFFSET               EQU  5        ; supposed to maximal sprite offset
                                              ; this value is added to the repositioning of sprites
                                              ; if they move out of bounds and go to the other side
                                              ; to prevent going out of bounds right away again
                                              ; because of there offset
                                              ;
                                              ; I'm not sure all sprites keep this maximum
                                              ; this may 'cause random repositioning of sprites
                                              ; a known problem, but I didin't increase this, since the
                                              ; actual playing area is allready quite small as it is...

; following are some status constants used for turtle, snake, otter, fly, girl and croco
NOT_AVAILABLE                   EQU 0         ; not in this level at all (is not checked for, only via ZERO flag!!!)
IS_CARRIED                      EQU 1         ; the object (girl) is carried by frog
IS_DISPLAYED                    EQU 2         ; the object is currently visible
IS_WAITING                      EQU 3         ; the object is waiting to be displayed
NOT_DIVING                      EQU 0         ; turtle is not diving (under water) right now
IS_DIVING                       EQU 1         ; the turtle is under water (frog can drown)

; bonus BIT MAPS, only two for now, these are AND or ORed
FLY_BONUS                       EQU $1        ; if set a fly bonus is awarded
GIRL_BONUS                      EQU $2        ; if set a girl bonus is awarded

; morphing stati...
MORPHING_DONE                   EQU  (lo(10)) ; this morphing structure finnished
MORPHING_WORKING                EQU  (lo(11)) ; is morphing
MORPHING_COMPLETE               EQU  (lo(0)) ; no more morphing

; and general morphing constants
MAX_VECTOR_MORPH                EQU  (lo(63)) ; this uses 128*3 bytes of RAM, maximum number of vectors for a morph
MORPH_STARTUP_DELAY             EQU  (lo(80)) ; constants used in init morph
MORPH_STEPS_INTRO               EQU  (lo(15))
MORPH_DELAY_INIT                EQU  (lo(2))
MORPH_STEPS_Z                   EQU  (lo(15)) ; below is history, morphing is
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
; they allways appear somewhere... truth values :-)
FALSE                           EQU  (lo(0))
TRUE                            EQU  (lo(1))

; vectrex coordinates use range from -128 to +127
; these top and bottom values are for scale factor $ff
SCREEN_TOP                      EQU  (lo($7f))
SCREEN_BOTTOM                   EQU  (lo(-$80))
SCREEN_LEFT                     EQU  (lo(-$80))
SCREEN_RIGHT                    EQU  (lo($7f))
SCREEN_CENTER                   EQU  (lo(0))

; different sizes of texts, in format yx, note: different ranges for y and x!
NORMAL_TEXT_SIZE                EQU $F160     ; big text that is
LITTLE_TEXT_SIZE                EQU $fb30     ; fairly small text
SCORE_TEXT_SIZE                 EQU $f530     ; 'middle' big text :-)

; following are SPECIAL definitions for special objects
; these must be set in the object definition
SPECIAL_CROCO_FULL              EQU $81
SPECIAL_CROCO_HALF              EQU $82
SPECIAL_HOME_FLY                EQU $83
SPECIAL_RIGHT_CROCO             EQU $84
SPECIAL_LEFT_CROCO              EQU $85
SPECIAL_RIGHT_SNAKE             EQU $86
SPECIAL_LEFT_SNAKE              EQU $87
SPECIAL_GIRL                    EQU $20       ; note: the $20 in this and the next two
SPECIAL_GIRL_RIGHT              EQU $20       ; is ANDed and compared to...
SPECIAL_GIRL_LEFT               EQU $21
SPECIAL_DIVE                    EQU $40       ; note: the $40 in this and the next two
SPECIAL_DIVE_UP                 EQU $40       ; is ANDed and compared to...
SPECIAL_DIVE_DOWN               EQU $41
;SPECIAL_MINUS_LENGTH            EQU -1       ; obsolete...

; scale factors used in the game (all different for optimization :-) :-( )
SCALE_FACTOR_GRID               EQU $ea       ; the virtual grid, which everything is set in
SCALE_FACTOR_GAME               EQU $91       ; every (nearly) positioning is made with
SCALE_FACTOR_HOME               EQU $1c       ; scale factor for drawing the homes
SCALE_IN_HOME                   EQU $83       ; scale factor for objects within an home
SCALE_FACTOR_SPRITE             EQU $6        ; all sprites are drawn using this scale factor
SCALE_FACTOR_VECTOR_MORPH       EQU $70       ; scale factor for morphing objects...

BOUNDARY_HI                     EQU (lo(100)) ; right boundary of playfield
BOUNDARY_LO                     EQU (lo(-127)); left boundary of playfield

; following are some 'blowup' factors applied to various objects (for optimization)
; these factors must be set that the resulting coordinate is still below 127
; for optimization the resulting vectors should be pretty near 127
; and the scale factor be set that it is the smallest possible value!
SPRITE_BLOW_UP                  EQU 25        ; thru this sprites get a possible max of 5 * 25 = 125 (pretty near 127...)
HOME_BLOW_UP                    EQU 8         ; ...
VEC_BLOWUP                      EQU 12        ; max vector 5 for now, double == 10 times 12 = 120, max would be 128...

; grid size of the virtal grid in different scale factors
GRID_SIZE_GAME                  EQU 16        ; (10*($ea/$91)), for SCALE_FACTOR_GRID
GRID_SIZE                       EQU 10        ; for scale factor $ff
                                              ; max 10, so that 12*GRID_SIZE still <= 127
                                              ; size can than be altered using scale factor
                                              ; I want to draw all lines in one
                                              ; go, so 10 is max here :-(
                                              ; otherwise I could scale the sprites
                                              ; with the same scaling value...

; frogger constants
; following are position information as to where the houses are located
; in SCALE_FACTOR_GAME
HOME1_POS_LEFT                  EQU (lo(178))
HOME1_POS_RIGHT                 EQU (lo(193))
HOME2_POS_LEFT                  EQU (lo(210))
HOME2_POS_RIGHT                 EQU (lo(225))
HOME3_POS_LEFT                  EQU (lo($f3))
HOME3_POS_RIGHT                 EQU (lo(2))
HOME4_POS_LEFT                  EQU (lo(20))
HOME4_POS_RIGHT                 EQU (lo(35))
HOME5_POS_LEFT                  EQU (lo(53))
HOME5_POS_RIGHT                 EQU (lo(68))

; following are for constants for checking which way frogger heads
; value of these is of no importance, just difference...
HEADING_RIGHT                   EQU (lo(1))
HEADING_LEFT                    EQU (lo(2))
HEADING_DOWN                    EQU (lo(3))
HEADING_UP                      EQU (lo(4))

FROGS_PER_GAME                  EQU (lo('5')); number of frogs per game, note: this is
                                             ; an ASCII '5' since it is displayed also with
                                             ; this value
; start position of frog in GRID_SIZE GAME
FROG_INIT_YPOS                  EQU (lo((-GRID_SIZE_GAME)*6))
FROG_INIT_XPOS                  EQU (lo(6))
FROG_INIT_POS                   EQU FROG_INIT_YPOS*256 + FROG_INIT_XPOS

; start band of frog in (0-12) in GRID POSITION
FROG_INIT_YPOS_BAND             EQU (lo(12)) ; home band is twelf (in memory)
FROG_INIT_XPOS_BAND             EQU (lo(7))  ; six is middle
FROG_INIT_POS_BAND              EQU FROG_INIT_YPOS_BAND*256 + FROG_INIT_XPOS_BAND

; number of 'pixels' one jump takes the frog...
; obviously in GRID_SIZE_GAME
FROG_X_JUMP                     EQU GRID_SIZE_GAME
FROG_Y_JUMP                     EQU GRID_SIZE_GAME

; sizes of the different frog objects...
; since all the same, I don't use them anymore...
FROG_SIZEX_RIGHT                EQU 10
FROG_SIZEX_LEFT                 EQU 10
FROG_SIZEX_DOWN                 EQU 10
FROG_SIZEX_UP                   EQU 10

; positions of where frog will be considered to be out of bounds...
; in GAME position
FROG_RIGHT_OUT                  EQU (lo(90))
FROG_LEFT_OUT                   EQU (lo(-97))

; some positioning variables for the score information display...
; in screen coordinates
SCORE_YPOS                      EQU (SCREEN_TOP-8)
SCORE_XPOS                      EQU (SCREEN_LEFT+8)
LEVEL_YPOS                      EQU (SCREEN_TOP-8)
LEVEL_XPOS                      EQU (lo(0-30))
FROGS_YPOS                      EQU (SCREEN_TOP-8)
FROGS_XPOS                      EQU (SCREEN_RIGHT-60)

;
; following are some 'private' makro definitions
; most of them have been splitted into the main source by now
                 INCLUDE "MY_MAKRO.I"
                 INCLUDE "UNLOOP.I"        ; makros for unlooping
;***************************************************************************
                 ORG     0
; start of vectrex memory with cartridge name...
                 DB      "g GCE 1998", $80 ; 'g' is copyright sign
                 DW      music7            ; music from the rom
                 DB      $F8, $50, $20, -$56; hight, width, rel y, rel x (from 0,0)
game_name:
                 DB      "VECTREX FROGGER", $80; some game information, ending with $80
                 DB      $F8, $50, $5, -$6d; hight, width, rel y, rel x (from 0,0)
                 DB      "MALBAN", $80; some game information, ending with $80
                 DB      0                 ; end of game header
;***************************************************************************
; here the cartridge program starts off
entry_point:
new_game:
                 JSR     init_vars         ; initialize game variables
                 JSR     init_screen       ; startup screen
                                           ; init_screen messes up variables,
                                           ; so init them again :-)
                 JSR     init_vars         ; initialize game variables
                 JSR     setup_level       ; set up the first level
restart_game:
                 JSR     DP_to_D0          ; round_startup_main expects dp set to d0
                 direct   $D0
main_loop:
                 ROUND_STARTUP_MAIN        ; well, this does the round initializing, main optimized special
                 JSR     move_frog         ; get joystick stuff, and move frog, collision detection...
                 DO_MY_SOUND_MAIN          ; is usually in ROUND_START_UP, here the above is
                                           ; splitted, saves one DP_TO_C8!
                 JSR     draw_objects      ; draw all graphical elements
                 direct $d0                ; after draw objects, dp is set to d0
main_loop_enter:                           ; enter from pause here
                                           ; perhaps jumps right back to pause!
                                           ; following used to be a call to
                                           ; the button function
                                           ; doing it this way saves
                                           ; a couple of hundred cycles!
                 MY_READ_BUTTONS_A         ; button status in A
                 ANDA    #$08              ; is button4 of joy 1 pressed?
                                           ; note, can EASILY be changed to any
                                           ; other button, it's just the bit!
                 BNE     main_loop         ; if not, start another round
                 ; pause game here...
                 ; first calculated the score now
                 JSR     Read_Btns         ; get button status
                 LDA     level_score       ; jumps allready jumped in this level
                 BMI     pause_loop        ; minus scores not added
                 BEQ     pause_loop        ; 0 scores not added
                 LDB     #10               ; times 10
                 MUL                       ;
                 TFR     B,A               ; must be in A :-(
                 LDX     #no_score_string  ; load level address
                 CLR     Vec_Misc_Count    ; must be zero for Add_Score_a (left to $ff in vector routine)
                 JSR     Add_Score_a       ; add to score(level)
                 CLR     level_score       ; jumps allready jumped in this level
pause_loop:
                 JSR     print_score       ; the cycles waster :-)
                 direct  $d0
                 LDD     #NORMAL_TEXT_SIZE ; load default text height & width
                 STD     Vec_Text_HW       ; poke it to ram location
                 LDU     #pause_string     ; get address of 'pause' string
                 LDA     #$10              ; Text Y
                 LDB     #-$50             ; Text X
                 JSR     Print_Str_d       ; Print the string
                 JSR     Read_Btns         ; get button status
                 CMPA    #$00              ; is a button pressed?
                 BEQ     pause_loop        ; start another round
                 BRA     main_loop_enter   ; go back to main loop
;***************************************************************************
; this routine calculates the new positions
; expected:dp is allready pointing to d0
; nothing is returned
; leaves with dp pointing to c8
move_frog:
                 direct  $d0
; move frog corresponding to joystick...
                 CLR     $C823             ; must be zero for digital joystick, is set to $ff in private vector routine
                 JSR     Joy_Digital       ; read joystick positions (cycle waste)
; first checking for changed x pos
                 _DP_TO_C8
                 LDB     last_joy_x        ; only jump if last joy pos was zero
                 LDA     Vec_Joy_1_X       ; load joystick 1 position X to A
                 STA     last_joy_x        ; store this joystick position
                 BEQ     no_new_xpos       ; no joystick input available
                 BMI     pos_left          ; joystick moved to left
pos_right:
                 TSTB                      ; test the old joystick position
                 BNE     no_new_xpos       ; was center
                 LDB     frog_x_band       ; load old pos to B
                 CMPB    #12               ; is it at maximum right position?
                 BEQ     no_new_xpos       ; if so, do nothing
                 PLAY_SOUND frog_jump
                 LDB     frog_x            ; load old pos to B
                 ADDB    #FROG_X_JUMP      ; increase position with speed faktor
                 STB     frog_x            ; and store new position
                 INC     frog_x_band       ; for internal checking
                 LDA     #HEADING_RIGHT
                 CMPA    current_frog_heading; new heading == old heading?
                 BEQ     new_xpos_exit     ; if yes -> we are done
                 STA     current_frog_heading ; store it
                 LDA     frog_y            ; load old pos to D
                 SUBA    current_frog_offset; korrekt the old offset y
                 SUBB    current_frog_offset+1 ; korrekt the old offset x
                 ADDA    frogger_right_offset ; korrekt the new offset y
                 ADDB    frogger_right_offset+1 ; korrekt the new offset x
                 STD     frog_pos          ; store it back
                 LDD     frogger_right_offset ; load the current offset
                 STD     current_frog_offset; and remember it
                 LDX     #frogger_right    ; use the vector list for frog
                 STX     frog_pic          ; right pointing frog store it
                 BRA     new_xpos_exit     ; and exit joystick position routine
pos_left:
                 TSTB                      ; test the old joystick position
                 BNE     no_new_xpos       ; was center
                 LDB     frog_x_band       ; load old pos to B
                 CMPB    #1                ; is it at maximum left position?
                 BEQ     no_new_xpos       ; if so, do nothing
                 PLAY_SOUND frog_jump
                 LDB     frog_x            ; load old pos to B
                 SUBB    #FROG_X_JUMP      ; decrease position with speed faktor
                 STB     frog_x            ; and store new position
                 DEC     frog_x_band       ; for internal checking
                 LDA     #HEADING_LEFT     ; than the last?
                 CMPA    current_frog_heading
                 BEQ     new_xpos_exit     ; if yes -> we are done
                 STA     current_frog_heading; and store it
                 LDA     frog_y            ; load old pos to D
                 SUBA    current_frog_offset; korrekt the old offset y
                 SUBB    current_frog_offset+1 ; korrekt the old offset x
                 ADDA    frogger_left_offset; korrekt the new offset y
                 ADDB    frogger_left_offset+1 ; korrekt the new offset x
                 STD     frog_pos          ; store it back
                 LDD     frogger_left_offset; load the current offset
                 STD     current_frog_offset; and store it
                 LDX     #frogger_left     ; use the vector list for
                 STX     frog_pic          ; left pointing frog
new_xpos_exit:
no_new_xpos:
; than checking for changed y pos
                 LDA     Vec_Joy_1_Y       ; load joystick 1 position X to A
                 LDB     last_joy_y        ; only jump if last joy pos was zero
                 STA     last_joy_y        ; store this joystick position
                 BEQ     no_new_ypos       ; no joystick input available
                 BMI     pos_down          ; joystick moved to down
pos_up:
                 TSTB                      ; test the old joystick position
                 BNE     no_new_ypos       ; was center
                 LDB     frog_y_band       ; load old pos to B
                 CMPB    #0                ; is it at maximum upper position?
                 BEQ     no_new_ypos       ; if so, do nothing
                 PLAY_SOUND frog_jump
                 LDA     frog_y            ; load old pos to B
                 INC     level_score
                 ADDA    #FROG_Y_JUMP      ; increase position with speed faktor
                 STA     frog_y            ; and store new position
                 DEC     frog_y_band       ; for internal checking
                 LDB     #HEADING_UP       ; than the last?
                 CMPB    current_frog_heading ; is the heading now the same
                 BEQ     new_ypos_exit     ; if yes -> we are done
                 STB     current_frog_heading; store new heading
                 LDB     frog_x            ; load old pos to D
                 SUBA    current_frog_offset; korrekt the old offset y
                 SUBB    current_frog_offset+1 ; korrekt the old offset x
                 ADDA    frogger_up_offset ; korrekt the new offset y
                 ADDB    frogger_up_offset+1; korrekt the new offset x
                 STD     frog_pos          ; store it back
                 LDD     frogger_up_offset ; remember the current offset
                 STD     current_frog_offset;
                 LDX     #frogger_up       ; use the vector list for
                 STX     frog_pic          ; up pointing frog, store it
                 BRA     new_ypos_exit     ; and exit joystick position routine
pos_down:
                 TSTB                      ; test the old joystick position
                 BNE     no_new_ypos       ; was center
                 LDB     frog_y_band       ; load old pos to B
                 CMPB    #12               ; is it at maximum down position?
                 BEQ     no_new_ypos       ; if so, do nothing
                 PLAY_SOUND frog_jump
                 LDA     frog_y            ; load old pos to B
                 DEC     level_score
                 SUBA    #FROG_Y_JUMP      ; decrease position with speed faktor
                 STA     frog_y            ; and store new position
                 INC     frog_y_band       ; for internal checking
                 LDB     #HEADING_DOWN     ; than the last?
                 CMPB    current_frog_heading ; is the heading now the same
                 BEQ     new_ypos_exit     ; if yes -> we are done
                 STB     current_frog_heading; store new heading
                 LDB     frog_x            ; load old pos to D
                 SUBA    current_frog_offset; korrekt the old offset y
                 SUBB    current_frog_offset+1 ; korrekt the old offset x
                 ADDA    frogger_down_offset; korrekt the new offset y
                 ADDB    frogger_down_offset+1 ; korrekt the new offset x
                 STD     frog_pos          ; store it back
                 LDD     frogger_down_offset; remember the current offset
                 STD     current_frog_offset;
                 LDX     #frogger_down     ; use the vector list for
                 STX     frog_pic          ; down pointing frog
new_ypos_exit:
no_new_ypos:
; now lets see if we hit a baddy or goody :-)
; note this stuff could be done in some dispatcher version
; in the sprite positioning loop
; look at the sprite section for what I mean by that :-)
; possibly another few hundred cycles could be saved!
                 LDB     frog_y_band       ; load band information
                 BNE     do_collision_check; a short jump saves a few cycles
                 JMP     home_jump_tried   ; do a far jump for the home stuff
do_collision_check:
                direct $c8
; first we must get the position of this band in the band list
                 DECB                      ; one less, since homes, don't have a band
                 CLRA                      ; fixed to 16 byte,
                 LSLB                      ; so we just use some LSL instead
                 LSLB                      ; of MUL...
                 LSLB
                 LSLB
                 LDX     #band_list        ; load bandlist
                 LEAX    D,X               ; and go to current band in bandlist
collision_loop:
                 LDU     ,X++              ; get pointer to next object_list element in this band
                 BEQ     end_no_collision_detected ; if empty we are done
collision_loop1:
; ok, here we have an object_list entry we must check...
                 LDY     ,U
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
; note: this minus stuff below, I removed it for some reason,
; but doing it would actually be a good idea
; for now all sprites have the leftmost position as starting vector
; the minus sprites used to have the rightmost point as the starting vector
; if frog had the opposite side as starting point from all other
; vectors, the collision
; checking could be done with just 1 compare instead of the now
; two compares... but actually I was to lazy to change the
; sprites...
; but on a busy lane one could save up to 100 cycles with this!!!
;
;                ;SPECIAL_MINUS_LENGTH
;                TST     10,Y              ; test if sprite starts at the right (MINUS)
;                BMI     negative_flag_set ; side ... than a different testing must be done
; perhaps some day I will move the frog position information out
; of the loop... should save a few cycles...
                 LDA     frog_x            ; load frog position
                 INCA                      ; so that detection is not all THAT sharp
                 INCA                      ; so that detection is not all THAT sharp

                 CMPA    3,U               ; compare it to x postion of object
                 BLT     frog_lower        ; if frog further left, jump
frog_higher:                               ; otherwise frog is on the right
                 SUBA    3,Y               ; subtract length of object
                 SUBA    3,U               ; subtract X position of object
                 BLT     collision_detected; if we are now on 'the left' we hit it
                 LDU     ,X++              ; get pointer to next object_list element in this band
                 BNE     collision_loop1   ; if empty we are done
end_no_collision_detected:                 ; no collision detected, is that good?
                 LDA     frog_y_band       ; load band, if in lower half
                 CMPA    #5                ; not collision is good
                 BLE     die_drown         ; otherwise we die (drowning)
                 RTS                       ; nothing happened, phuu! (bye)
frog_lower:                                ; frog is on the left
                 ADDA    current_frog_size_x; add the size of the frog to A (position of frog)
                 CMPA    3,U               ; compare it to x postion of object
                 BLT     collision_loop    ; still lower, than no collision
;negative_flag_set:
;                LDA     frog_x             ; load frog position
;                INCA                       ; so that detection is not all THAT sharp
;                INCA                       ; so that detection is not all THAT sharp
;                CMPA    1,U                ; compare it to x postion of object
;
;                BGT     collision_loop     ; if frog further right, than no collision at all
;nfrog_higher:                              ; otherwise frog is on the right
;                ADDA    3,Y                ; add the size of the object (Y+3=pointer to 'length')
;                ADDA    current_frog_size_x; add the size of the frog to A (position of frog)
;                CMPA    1,U                ; compare it to x postion of object
;                BGT     collision_detected ; if we are now on 'the left' we hit it
;                BRA     collision_loop     ; otherwise check next object

collision_detected:                        ; ok, a collision happened, check if good or bad
                 LDA     frog_y_band       ; load band information
                 CMPA    #5                ; if in upper half, than it is good
                 BLE     transporting      ; than we are being transported
                 LDA     10,Y              ; SPECIAL...
                 BEQ     no_special_test_c ; middle band is treated as a street
                 CMPA    #SPECIAL_RIGHT_SNAKE; if a snake is encountered
                 BNE     no_right_snake    ; jump if not
                 LDA     frog_x            ; load the frog postion
                 SUBA    3,U               ; minus X position of object
                 CMPA    #11               ; hardcoded length of snake :-(
                 BLE     collision_loop    ; otherwise go on
                 BRA     die_snake         ; otherwise die a snake death
no_right_snake:
                 ; must be left snake than (or something is wrong)
                 ; there are no special cars!
                 LDA     frog_x            ; load the frog postion
                 SUBA    3,U               ; minus X position of object
                 CMPA    #10               ; hardcoded length of snake :-(
                 BGE     collision_loop    ; otherwise go on
                 BRA     die_snake         ; if lower than bitten by snake
no_special_test_c:
; NOTE: A should allways be zero here
                 LDB     #DIE_CAR          ; otherwise we die a DIE_CAR
die_set:
                 STD     kind_of_death     ; type of death
die:                                       ; the frog is lost
                 DEC     no_frogs          ; decrease number of available frogs
                 JSR     frog_dead         ; do a frog_dead intermission, kind of death
                                           ; is correctly set in 'kind_of_death'
                 direct  $d0
                 LDA     #'0'              ; compare to '0'
                 CMPA    no_frogs          ; the number of available frogs
                 BNE     not_lost_yet      ; if not zero yet, go on
                 PULS    D                 ; clean up stack so that we can do a jump
                 JMP     game_lost         ; do a game_lost intermission and return there
not_lost_yet:
                 JSR     DP_to_C8          ; init_new_frog_vars expects dp at c8
                 direct   $C8
                 JMP     init_new_frog_vars; clear the frog variables
die_out:
                 LDD     #DIE_OUT          ; die a DIE_OUT kind of
                 BRA     die_set           ; jump to die
die_drown:
                 LDD     #DIE_DROWN        ; die a DIE_DROWN kind of
                 BRA     die_set           ; jump to die
die_croco:
                 LDD     #DIE_CROCO        ; die a DIE_CROCO kind of
                 BRA     die_set           ; jump to die
die_snake:
                 LDD     #DIE_SNAKE        ; die a DIE_SNAKE kind of
                 BRA     die_set           ; jump to die
transporting:                              ; no we are 'riding' some object
                 direct $c8
                 LDA    10,Y               ; lets test the special flag...
                 BEQ    no_special_test    ; if no special go on
                 CMPA   #SPECIAL_LEFT_CROCO; test for left crocodile
                 BNE    no_left_croco      ; if not, jump
                 LDA    frog_x             ; load the frog postion
                 SUBA   3,U                ; subtract X position of object
                 CMPA   #10                ; hardcoded length of croco :-(
                 BGE    _no_snake_         ; not eaten by croco, nothing else can be here
                 BRA    die_croco          ; if lower frogger was eaten by crocodile
no_left_croco:
                 CMPA   #SPECIAL_RIGHT_CROCO; are we sitting on a right croco?
                 BNE    no_right_croco     ; no? than jump
                 LDA    frog_x             ; load the frog postion
                 SUBA   3,U                ; subtract X position of object
                 CMPA   #11                ; hardcoded length of croco :-(
                 BLE    _no_snake_         ; not eaten by croco, nothing else can be here
                 BRA    die_croco          ; if higher frogger was eaten by crocodile
no_right_croco:
                 CMPA   #SPECIAL_DIVE_DOWN ; look if this is a dived turtle
                 BEQ    die_drown          ; if yes... drown
no_dived_turtle:
no_special_test:
; check if we 'capture' a girl
                 LDA     girl_status       ; what's the girls status?
                 CMPA    #IS_DISPLAYED     ; is it displayed
                 BNE     _no_girl_         ; no? than jump
                 LDD     girl_log_object   ; load log object address
                 SUBD    #3                ; address + 3 is stored, correct it
                 SUBD    -2,X              ; subtract the current object information
                 BNE     _no_girl_         ; if not the same, go to no_girl_
                 ; check for collision
                 LDB     girl_pos+1        ; load girl x pos
                 SUBB    frog_x            ; subtract frog_x pos
                 _ABS_B                    ; absolute it
                 CMPB    #10               ; if not in the range of 10
                 BHI     _no_girl_         ; jump to no girl
girl_collision:
                 DEC     girl_status       ; IS CARRIED
                 LDA     frog_bonus        ; load bonus state
                 ADDA    #GIRL_BONUS       ; add a girl bonus
                 STA     frog_bonus        ; store it
                 PLAY_SOUND girl_got_sound ; and play a girl tune
_no_girl_:
; check if we hit a 'log' snake
                 LDA     snake_status      ; what's the snake's status?
                 CMPA    #IS_DISPLAYED     ; is it displayed
                 BNE     _no_snake_        ; no? than jump
                 LDA     frog_y_band       ; what band are we on now ?
                 CMPA    #3                ; compare with 'snake band'
                 BNE     _no_snake_        ; if not our band... go on
                 LDX     snake_object      ; which contains the log a objectlist address
                 LDA     10,X              ; load special
                 CMPA   #SPECIAL_RIGHT_SNAKE; if a snake is encountered
                 BNE    no_log_right_snake ; jump if not
                 LDB    frog_x             ; load the frog postion
                 SUBB   snake_pos + 1      ; minus X position of object
                 SUBB   #32                ; real hardcoded length
                 _ABS_B                    ; absolut it
                 CMPB   #4                 ; somewhere arround the snakes head?
                 BGE    _no_snake_         ; if higher, than not hit
                 BRA    die_snake          ; otherwise than bitten by snake
no_log_right_snake:
                 CMPA   #SPECIAL_LEFT_SNAKE; now we look for left snake
                 BNE    _no_snake_         ; no?, than jump
                 LDB    frog_x             ; load the frog postion
                 SUBB   snake_pos + 1      ; minus X position of object
                 _ABS_B                    ; absolut it
                 CMPB   #10                ; somewhere arround the snakes head?
                 BLT    die_snake          ; if lower than bitten by snake
_no_snake_:
                 LDA     frog_x            ; load the frog postion
                 ADDA    ,Y                ; add the speed of the object
                 STA     frog_x            ; and store it
                 CMPA    #FROG_RIGHT_OUT   ; are we out of bounds right?
                 BGT     die_out           ; than dead
                 CMPA    #FROG_LEFT_OUT    ; are we out of bounds left?
                 BLT     die_out           ; than dead
                 LDA     tmp_band_offset   ; ok, for checking of 'normal' bounds
                                           ; we need to calculate the band_x
                                           ; coordinates, 'tmp_band_offset' is now
                                           ; used as a helper
                                           ; it counts from 0 to 9
                                           ; if below 0 band_x is decremented
                                           ; if 10 or high it is incremented...
                 ADDA    ,Y                ; add the speed of the object
                 BMI     band_minus_one    ; if below zero, dec band_x 1
                 CMPA    #GRID_SIZE_GAME   ; if higher GRID_SIZE...
                 BGE     band_plus_one     ; ... add one to band_x
                 STA     tmp_band_offset   ; otherwise just store it back
                 RTS
band_plus_one:
                 INC     frog_x_band       ; for internal checking
                 SUBA    #GRID_SIZE_GAME   ; make it modulo 10
                 STA     tmp_band_offset   ; store it
                 RTS                       ; otherwise bye for good
band_minus_one:
                 DEC     frog_x_band       ; for internal checking
                 ADDA    #GRID_SIZE_GAME   ; make it modulo 10
                 STA     tmp_band_offset   ; store it
                 RTS                       ; otherwise bye for good
home_jump_tried:
;; here check for homereach must be put and new frog started
                 LDD     #DIE_WALL_JUMP    ; default death for this
                 STD     kind_of_death     ; band is DIE_WALL_JUMP
                 LDA     frog_x            ; load frog position
home1_test:
                 CMPA    #HOME1_POS_LEFT   ; are we left of home
                 LBLE    die               ; yep, than die DIE_WALL_JUMP
                 CMPA    #HOME1_POS_RIGHT  ; or are we right, than
                 BGT     home2_test        ; goto next test
                 LDX     #home_entry_1     ; load home address to X
                 LDU     home_entry_1      ; load home object to U
                 BEQ     no_object_in_home ; if none, than OK
                 BRA     object_in_home    ; if there is something,... further checking
home2_test:
                 CMPA    #HOME2_POS_LEFT   ; are we left of home
                 LBLE    die               ; yep, than die DIE_WALL_JUMP
                 CMPA    #HOME2_POS_RIGHT  ; or are we right, than
                 BGT     home3_test        ; goto next test
                 LDX     #home_entry_2     ; load home address to X
                 LDU     home_entry_2      ; load home object to U
                 BEQ     no_object_in_home ; if none, than OK
                 BRA     object_in_home    ; if there is something,... further checking
home3_test:
                 CMPA    #HOME3_POS_LEFT   ; are we left of home
                 LBLE    die               ; yep, than die DIE_WALL_JUMP
                 CMPA    #HOME3_POS_RIGHT  ; or are we right, than
                 BGT     home4_test        ; goto next test
                 LDX     #home_entry_3     ; load home address to X
                 LDU     home_entry_3      ; load home object to U
                 BEQ     no_object_in_home ; if none, than OK
                 BRA     object_in_home    ; if there is something,... further checking
home4_test:
                 CMPA    #HOME4_POS_LEFT   ; are we left of home
                 LBLE    die               ; yep, than die DIE_WALL_JUMP
                 CMPA    #HOME4_POS_RIGHT  ; or are we right, than
                 BGT     home5_test        ; goto next test
                 LDX     #home_entry_4     ; load home address to X
                 LDU     home_entry_4      ; load home object to U
                 BEQ     no_object_in_home ; if none, than OK
                 BRA     object_in_home    ; if there is something,... further checking
home5_test:
                 CMPA    #HOME5_POS_LEFT   ; are we left of home
                 LBLE    die               ; yep, than die DIE_WALL_JUMP
                 CMPA    #HOME5_POS_RIGHT  ; or are we right, than
                 LBGT    die               ; goto die DIE_WALL_JUMP
                 LDX     #home_entry_5     ; load home address to X
                 LDU     home_entry_5      ; load home object to U
                 BEQ     no_object_in_home ; if none, than OK
; X pointer to home object position
; U pointer to home object
object_in_home:
; here test ob frog, croco or fly in home
                 LDA     10,U              ; load the object special to A
                 CMPA    #SPECIAL_HOME_FLY ; check if fly...
                 BNE     no_home_fly       ; no?. bother, than dead :-(
                 ; yep, this is a fly object, reinitiate fly...
                 LDD     fly_timer_start   ; reload the fly timer
                 STD     fly_timer         ; and store it
                 INC     fly_status        ; is WAITING
                 LDA     #FLY_BONUS        ; load fly bonus for extro
                 ADDA    frog_bonus        ; add old bonus to it
                 STA     frog_bonus        ; and store it back...
                 BRA     init_with_bonus   ; and do 'frog reached home'
no_home_fly:
                 CMPA    #SPECIAL_CROCO_HALF; is only half a crocodile seen?
                 BNE     no_half_croco     ; no, than jump
                 LDD     croco_timer_start ; reload the croco timer
                 STD     croco_timer       ; and store it
                 INC     croco_status      ; is WAITING
                 BRA     init_with_bonus   ; and do 'frog reached home', phhht
no_half_croco:
                 CMPA    #SPECIAL_CROCO_FULL; if a full crocodile is in house
                 BNE     no_full_croco     ; no?, than jump
                 LBRA    die_croco         ; otherwise frogger is dead
no_full_croco:
                 LDD     #DIE_HOME_FULL    ; default death
                 LBRA    die_set           ; frogger jumped to occupied home
; X pointer to home object position
; 0
init_with_bonus:
no_object_in_home:
                 LDD     #frog1a_in_home_object ; load object for frog is in home
                 STD     ,X                ; and set it as new home object
                 LDA     (frog1a_in_home_object+4) ; load animation counter of object
                 STA     4,X               ; and store it to object in RAM
                 DEC     in_home_counter   ; decrease home counter
                 BNE     no_new_level      ; if not zero, than not all homes are full
                 LDA     #1                ; 1 level plus
                 LDX     #no_level_string  ; load level address
                 CLR     Vec_Misc_Count    ; must be zero for Add_Score_a (left to $ff in vector routine)
                 JSR     Add_Score_a       ; add to score (level)
                 JSR     frog_in_home      ; do a frog in home intermission
                 direct  $c8
                 JSR     level_complete    ; do a level done intermission
                 direct  $d0
                 INC     game_level        ; increase level counter
                 LDA     #((level_done_data-level1_data)/LEVEL_DATA_LENGTH); load number of none level
                 CMPA    game_level        ; compare to game_level
                 BNE     no_roll_over      ; if equal a roll_over has occured
                 CLR     game_level        ; clear level (start at 0 again)
                 JSR     roll_over_intermission ; and do a roll_over intermission
no_roll_over:
                 JSR     DP_to_C8          ; for set up level...
                 direct   $C8
                 JSR     setup_level       ; set up a new level
                 JMP     init_new_frog_vars; clear the frog variables
no_new_level:
                 JSR     frog_in_home      ; do a frog in home intermission
                 JMP     init_new_frog_vars; clear the frog variables
;***************************************************************************
; belongs to draw object below
; is here because of short branch...
                 direct $c8
timer_death:
                 LDB     #$40              ; B timer 1 bit test
draw_frog_move_timer:
                 BITB    VIA_int_flags     ; done with move?
                 BEQ     draw_frog_move_timer ; no, than go on waiting
                 LDD     #DIE_TIME         ; die a DIE_TIME kind of
die_set_2:
                 STD     kind_of_death     ; type of death
                 DEC     no_frogs          ; decrease number of available frogs
                 JSR     frog_dead         ; do a frog_dead intermission, kind of death
                                           ; is correctly set in 'kind_of_death'
                 direct  $d0
                 LDA     #'0'              ; compare to '0'
                 CMPA    no_frogs          ;
                 BNE     not_lost_yet2     ; if not zero yet, go on
                 PULS    D                 ; clean up stack so that we can do a jump
                 JMP     game_lost         ; otherwise do a game_lost intermission
not_lost_yet2:
                 JSR     DP_to_C8
                 direct   $C8
                 _DP_TO_C8
                 JSR     init_new_frog_vars; clear the frog variables
                 JSR     DP_to_D0
                 direct   $D0
                 RTS
;***************************************************************************
; exits with dp to d0
; nothing is returned
draw_objects:
                 _DP_TO_D0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; independent code section
; draw frog
                 _INTENSITY $7F            ; frog is drawn in full intensity
                 MY_GAME_SCALE             ; set game scaling
                 LDD     frog_pos          ; load current frog position to D
                 ; following passage is a move_to_d derivat
                 STA     VIA_port_a        ; Store Y in D/A register
                 LDA     #$CE              ; Blank low, zero high?
                 STA     VIA_cntl          ;
                 CLRA
                 STA     VIA_port_b        ; Enable mux
                 INC     VIA_port_b        ; Disable mux
                 STB     VIA_port_a        ; Store X in D/A register
                 STA     VIA_t1_cnt_hi     ; enable timer
                 ; pause stuff start!
;
; this is stuff which takes time,
; but can be done anywhere, so we do it here
; in a 'pause', our pause lasts till GAME_SCALE ($91)
; timer is count down, that is our scale - timer...
;
; the below code looks like a bit
; overdone, but you might think about the possibilities,
; each of the about 20-30 sprite use the GAME_SCALE timer,
; if one wrote a dispatcher type for the time wasted in these sprite
; positioning, one could calculate whole 3d worlds!!!
; 20-30 * $91 timer cycles to waste!... (plus a bit of overhead)!!!
; furthermore, if we actually take longer than the $91 cycles
; it doesn't matter!
; since integration is halted by the timer countdown
; ( well after a few 1000 cycles it DOES matter)
;
; note:
; if levels are done well only a small fraction of this pause will be done
; each round
                 JSR     DP_to_C8
                 direct   $C8
                 LDB    y_timer+1          ; load new vector (length was cut by timer :-))
                 BEQ    timer_death        ; if timer is zero, we are dead
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; let us look if we need to initiate/destroy a home object
; that is fly or crocodile
; independent code section
; do timer stuff for fly
; insert/remove fly
                 LDA     fly_status        ; is there any fly stuff at all?
                 BEQ     no_fly_in_level   ; no?, than go on
                 TST     fly_timer         ; is zero?
                 BNE     finnished_fly_stuff2; if not zero, do nothing
                 LDA     fly_status        ; is there any fly stuff at all?
                 CMPA    #IS_WAITING       ; fly is waiting to be displayed
                 BNE     fly_is_being_displayed ; no?, than it is allready displayed
; if zero... initiate new fly
                 JSR     Random            ; get a random number
                 ANDA    #$7               ; only the lower three bits
                 CMPA    #4                ; not higher than 4
                 BLO     home_got          ; if lower than ok
                 ASRA                      ; otherwise take only half of it
home_got:                                  ; now we have a random home...
                 LDB     #5                ; must multiply by 5, length of home object
                 MUL                       ; times 5
                 STB     tmp1              ; remember start address if all homes are occupied
                 LDU     #home_objects     ; load the address to U, start of list of homes
test_next_house:
                 TST     B,U               ; is this home empty (only checking upper byte, should be ok)
                 BEQ     home_is_empty     ; if yes, than go on
                 CMPB    #20               ; otherwise, compare to 20 (right most home)
                 BNE     not_last_home_yet ; not last home?, than go on
                 LDB     #-5               ; store -5, so that +5 is 0, leftmost home
not_last_home_yet:
                 ADDB    #5                ; check next home (home object is 5 bytes long)
                 CMPB    tmp1              ; checked all homes yet
                 BEQ     finnished_fly_stuff; yes, than no home is free
                 BRA     test_next_house   ; and check again if empty...
home_is_empty:                             ; now we got a 'random' empty home address in B,U
                 STB     fly_house         ; remember offset to home for removal
                 LDU     #home_objects     ; get address of U and add the offset
                 LEAU    B,U               ; in U address of 'random' home
                 LDD     #fly1a_object     ; load fly object
                 STD     ,U                ; store to the calculated home address
                 LDA     (fly1a_object+4)  ; load animation counter of object
                 STA     4,U               ; and store it to object in RAM
                 DEC     fly_status        ; IS DISPLAYED
home_ffull:
                 BRA     finnished_fly_stuff; and finnished with fly stuff...
; fly is allready displayed, must check if we should destroy it...
fly_is_being_displayed:
; now destroy fly
                 LDB     fly_house         ; load current fly offset
                 LDU     #home_objects     ; get address of U and add the offset
                 LEAU    B,U               ; in U address of 'random' home
                 LDD     #0
                 STD     ,U
                 INC     fly_status        ; is WAITING
finnished_fly_stuff:
                 LDD     fly_timer_start   ; reload the fly timer
                 STD     fly_timer         ; and store it
finnished_fly_stuff2:
no_fly_in_level:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; independent code section
; do timer stuff for croco (home)
; insert/remove croco
                 LDA     croco_status      ; is there any croco stuff at all?
                 BEQ     no_croco_in_level ; no?, than go on
                 TST     croco_timer       ; store it back
                 BNE     finnished_croco_stuff2; if not zero, do nothing
                 LDA     croco_status      ; is there any croco stuff at all?
                 CMPA    #IS_WAITING       ; croco is waiting to be displayed
                 BNE     croco_is_being_displayed ; no?, than it is allready displayed
; if zero... initiate new croco
                 JSR     Random            ; get a random number
                 ANDA    #$7               ; only the lower three bits
                 CMPA    #4                ; not higher than 4
                 BLO     chome_got         ; if lower than ok
                 ASRA                      ; otherwise take only half of it
chome_got:                                 ; now we have a random home...
                 LDB     #5                ; must multiply by 5, length of home object
                 MUL                       ; times 5
                 STB     tmp1              ; remember start address if all homes are occupied
                 LDU     #home_objects     ; load the address to U, start of list of homes
ctest_next_house:
                 TST     B,U               ; is this home empty (only checking upper byte, should be ok)
                 BEQ     chome_is_empty    ; if yes, than go on
                 CMPB    #20               ; otherwise, compate to 20 (right most home)
                 BNE     cnot_last_home_yet; not last home?, than go on
                 LDB     #-5               ; store -5, so that +5 is 0, leftmost home
cnot_last_home_yet:
                 ADDB    #5                ; check next home (home object is 5 bytes long)
                 CMPB    tmp1              ; checked all homes yet
                 BEQ     finnished_croco_stuff; yes, than no home is free
                 BRA     ctest_next_house  ; and check again if empty...
chome_is_empty:                            ; now we got a 'random' empty home address in B,U
                 STB     croco_house       ; remember offset to home for removal
                 LDU     #home_objects     ; get address of U and add the offset
                 LEAU    B,U               ; in U address of 'random' home
                 LDD     #crocoh1a_object  ; load croco object
                 STD     ,U                ; store to the calculated home address

                 LDA     (crocoh1a_object+4); load animation counter of object
                 STA     4,U               ; and store it to object in RAM
                 DEC     croco_status      ; is DISPLAYED
home_cfull:
                 BRA     finnished_croco_stuff; and finnished with croco stuff...
; croco is allready displayed, must check if we should destroy it...
croco_is_being_displayed:
; now destroy croco
                 LDB     croco_house       ; load current croco offset
                 LDU     #home_objects     ; get address of U and add the offset
                 LEAU    B,U               ; in U address of 'random' home
                 LDD     #0
                 STD     ,U
                 INC     croco_status      ; IS WAITING
finnished_croco_stuff:
                 LDD     croco_timer_start ; reload the croco timer
                 STD     croco_timer       ; and store it
no_croco_in_level:
finnished_croco_stuff2:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
                 TST     dive_timer        ; should the turtles dive?
                 BNE     no_dive_change    ; if not zero, don't do anything
                 LDA     dive_timer_start  ; first let us restore the timer
                 STA     dive_timer        ; store it HI
                 ; go thru all sprites
                 ; see if diving special is there,
                 ; than change sprites to diving sprites
                 LDY     #t_list
next_dive_object:
                 LDX     ,Y++
                 BEQ     all_objects_done
                 LDU     ,X                ; load object address

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
                 STY     tmp1              ; faster than a PSHS
                 LEAY     [11,U]           ; load alternate object to Y
                 LDD     7,U               ; load old sprite offsets
                 NEGA                      ; negate them (A)
                 NEGB                      ; negate them (B)
                 ADDA    2,X               ; add y position to old sprite offset y
                 ADDB    3,X               ; add x position to old sprite offset x
                 ADDA    7,Y               ; add new sprite offset y
                 ADDB    8,Y               ; add new sprite offset x
                 STD     2,X               ; and store the corrected position
                 LDA     4,Y               ; load new animation counter start
                 STA     4,X               ; and set it in object list
                 STY     ,X                ; store new object definition to object list
                 LDY     tmp1              ; faster than a PULS
                 BRA     next_dive_object  ; and go on
all_objects_done:
no_dive_change:
diving_done:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                 LDA     otter_status
                 CMPA    #IS_WAITING
                 BNE     finnish_otter_timer_stuff; if not zero, do nothing
                 TST     otter_timer

                 BNE     finnish_otter_timer_stuff; if not zero, do nothing
; if zero... initiate new otter
                 JSR     Random            ; get a random number
                 ANDA    #15               ; random in range of 0 - 15
                 STA     tmp1              ; remember for lane offset
                 ANDA    #7                ; only the lower three bits
                 CMPA    #5                ; not higher than 5
                 BLO     band_got          ; if lower than ok
                 LSRA                      ; otherwise take only half of it
band_got:                                  ; now we have a random river band...
                 STA     otter_band        ; this is the band we are on now
                 LSLA                      ; multiply by band structure width
                 LSLA                      ; which is 16 bytes
                 LSLA
                 LSLA
                 TFR     A,B               ; copy A to B
                 CLRA                      ; SEX B :-) but without sign
                 ADDD    #band_list        ; add address start of band list
                 ; now we try to get a pseudo random offset of objects within
                 ; this lane, we use the same random number as for lane determination
                 ; but this time ranging from 0 - 15, see above
                 INC     tmp1               ; at least 1 in tmp1 so we don't loop to 255
                 ; start address of this bandlist is in D (and remains there untouched...)
object_random_select_init:
                 TFR     D,X               ; copy start of lane list to X
object_random_select:
                 LDU     ,X++              ; load object list address to U
                 BEQ     object_random_select_init ; if zero than we have gone past the last object
                                           ; and jump to reinit X
no_zero_object:
                 DEC     tmp1              ; otherwise we decrement our random value by 1
                 BNE     object_random_select ; if not zero, get the next object list member
object_random_select_done:
                 STU     otter_log_pre     ; store list object address of
                                           ; 'log' pre otter
                 LDU     ,X                ; load next list position
                 BNE     got_second_log    ; if not zero jump
                 TFR     D,X               ; if zero we have to use the first object in this band
                 LDU     ,X                ; even if it is the same... as the pre object
got_second_log:
                 STU     otter_log_past    ; store list object address of
                                           ; 'log' past otter
                 LDX     #otter1a_object   ; load object address of first otter animation to X
                 LDU     otter_log_pre     ; load pre otter object list address
                 LDD     2,U               ; position of pre list object
                 LDU     ,U                ; pre object
                 SUBA    7,U               ; modify for y offset of pre object
                 SUBB    8,U               ; modify for x offset of pre object
                 ADDB    3,U               ; add length of pre object
                 ADDA    7,X               ; modify y position with otter offset
                 ADDB    8,X               ; modify x position with otter offset
                 ADDB    #3                ; add another 3 just for good measure...
                 STD     otter_pos         ; and store this as the new otter position
                 CMPB    #85               ; are we to far to the right?
                 BGE     destroy_timer_otter; if so, don't use this otter
                 CMPB    #-110             ; are we to far to the left?
                 BLE     destroy_timer_otter; if so don't use this otter either
                 ; the above is sort of needed, since I don't want to check
                 ; all fancy cases... there e.g. might be some weird positioning
                 ; that otter is quasi outside of the main screen and the
                 ; log it is looking for reaches the out of bounds boundary allways
                 ; befor the otter has a chance to realize it is allready near
                 ; thus the otter might stay there forever...
                 LDA     ,U                ; load speed of pre object
                 INCA                      ; otter allways + 1
                 ; my otter allways moves from left to right
                 ; or standstill
                 STA     otter_speed       ; store the new speed
                 STX     otter_object      ; store otter anim A 1 object as the relevant otter object
                 LDA     4,U               ; reset animation counter for otter
                 STA     otter_anim_counter; and store it
                 ; now we do some checking if we haven't gotten ourself a real
                 ; stupid 'log' object, like a midway turtle or a
                 ; middle 'big' log...
                 LDU     otter_log_past    ; load object list address of object past otter
                 LDB     otter_pos+1       ; and load the position of otter now
                 SUBB    3,U               ; subtract these two
                 _ABS_B                    ; absolute that
                 CMPB    #15               ; look if they are really near each other
                                           ; 15 'includes' length of otter, hardcoded :-(
                 BHI     timer_otter_ok    ; if not near, go to end, otherwise destroy otter
destroy_timer_otter:
                 LDD     otter_timer_start ; reload the otter timer
                 STD     otter_timer       ; and store it
                 BRA     finnish_otter_timer_stuff; and go to done
timer_otter_ok:
                 DEC     otter_status      ; is displayed
finnish_otter_timer_stuff:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                 _DP_TO_D0
; finally, are done with our in 'pause' move stuff!
                 LDX     frog_pic          ; load current frog sprite
                 LDD     #((SCALE_FACTOR_SPRITE*256)+$40) ; A scale factor, B timer 1 bit test
draw_frog_move:
                 BITB    VIA_int_flags     ; done with move?
                 BEQ     draw_frog_move    ; no, than go on waiting
                 ; done with move_to_d
                 _SCALE_A
                 MY_SPRITE_DRAW_VLC
                 ; the above makro leaves with A set to 0!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; here is the entry point for the timer count down
; when frog reaches home...
entry_timer_count_down:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; independent code section
; draw home, middway and timer line
                 LDB     #$CC              ; this and the overnext instruction, zero the beam!
                 STA     VIA_shift_reg     ; from my sprite draw
                 STB     VIA_cntl          ; /BLANK low and /ZERO low
                _INTENSITY $60             ; all following sprites have intensity of $60
                 ; for positioning allways 'SCALE_FACTOR_GRID'
                 LDD     #(SCALE_FACTOR_GRID/2) ; clear A, and scale to B
                 _SCALE_B                  ; patched for speed... /2
                 ; this is again a move to D, this time D is splitted into two B, A is
                 ; still 0
                 LDB     #(2*(5*GRID_SIZE+GRID_SIZE/2)) ; B=Y pos
                 STB     VIA_port_a        ; Store Y in D/A register
                 STA     VIA_port_b        ; Enable mux
                 LDB     #$CE              ; Blank low, zero high?
                 STB     VIA_cntl          ;
                 INC     VIA_port_b        ; Disable mux
                 LDB     #-(2*(6*GRID_SIZE)); X pos relative to start
                 STB     VIA_port_a        ; Store X in D/A register
                 STA     VIA_t1_cnt_hi     ; enable timer
                 LDX     #homes            ; address of home vector list
;
; this is stuff which takes time,
; but can be done anywhere, so we do it here
; in a 'pause'
                 TST     kind_of_death+1   ; test if we are in death timer loop
                 BNE     no_timer_change   ; frog is allready dead!

                 LDD     fly_timer         ; load fly timer
                 SUBD    #$20              ; decrease it
                 STD     fly_timer         ; store it back

                 LDD     croco_timer       ; load croco timer
                 SUBD    #$20              ; decrease it
                 STD     croco_timer       ; store it back

                 LDD     dive_timer        ; load the timer value
                 CMPA    #$ff              ; if $ff, than no turtle
                 BEQ     not_dive_timer_change; overstep the next two
                 SUBD    #$20              ; count it down by $20
                 STD     dive_timer        ; store it
not_dive_timer_change:

                 LDD     my_timer          ; load the timer value
                 SUBD    #$20              ; count it down by $20
                 STD     my_timer          ; store it

                 LDA     otter_status
                 CMPA    #IS_WAITING       ; is displayed
                 BNE     otter_no_timer_change
                 LDD     otter_timer       ; load otter timer
                 SUBD    #$20              ; decrease it
                 STD     otter_timer       ; store it back
otter_no_timer_change:
no_timer_change:
; done with in 'pause' stuff

                 LDD     #((SCALE_FACTOR_HOME*256)+$40); A = Scale factor, B Bit for timer test
home_draw_move:
                 BITB    VIA_int_flags     ; done with move?
                 BEQ     home_draw_move    ; no, than go on waiting
                 ; done with move
                 ; own scale factor to homes, since they are drawn in an individually fitted scale
                 _SCALE_A
                 ; now a MY_DRAW_VLC
                 LDD     ,X++              ; A= how many vectors?, B = Y coordinate
                 STA     $C823             ; remember in counter
                 CLRA                      ; clear A
_DRAW_VLA_home:
;                 STB     VIA_port_a        ; Send Y to A/D
;                 STA     VIA_port_b        ; enable MUX
                 STD     VIA_port_b
                 LDB     ,X+               ; load next coordinate (X)
                 INC     VIA_port_b        ; Disable mux
                 STB     VIA_port_a        ; Send X to A/D
                 DEC     VIA_shift_reg     ; Put pattern in shift register ($ff)
                 STA     VIA_t1_cnt_hi     ; enable timer 1
                 LDB     ,X+               ; next coordinate (Y)
                 DEC     $C823             ; more vectors?
                 BMI     _DRAW_END_home    ; Go back for more points
                 LDA     #$40              ; B-reg = T1 interrupt bit
LF3F4_home1:
                 BITA    VIA_int_flags     ; Wait for T1 to time out
                 BEQ     LF3F4_home1       ;
                 CLRA                      ; Wait a moment more
                 STA     VIA_shift_reg     ; Clear shift register (blank output)
                 BRA     _DRAW_VLA_home    ;
_DRAW_END_home:
                 LDD     #(($40*256)+$cc)  ; A-reg = T1 interrupt bit, B = zero vector byte
LF3F4_home2:
                 BITA    VIA_int_flags     ; Wait for T1 to time out
                 BEQ     LF3F4_home2       ;
                 CLRA                      ; Wait a moment more
                 STA     VIA_shift_reg

                 ; DRAW THE THREE LINES IN BETWEEN
                 STB     VIA_cntl          ; /BLANK low and /ZERO low

                 _SCALE  (SCALE_FACTOR_GRID/2) ; patched for speed... /2
                 LDD     #(2*(GRID_SIZE/2)); Y pos, A=0
                 ; move to D
                 STB     VIA_port_a        ; Store Y in D/A register
                 STA     VIA_port_b        ; Enable mux
                 LDB     #$CE              ; Blank low, zero high?
                 INC     VIA_port_b        ; Disable mux
                 STB     VIA_cntl          ; zero high!
                 LDB     #(2*(6*GRID_SIZE)); X pos relative to start
                 STB     VIA_port_a        ; Store X in D/A register
                 STA     VIA_t1_cnt_hi     ; enable timer
                 ; much cycles wasted in below wait for TI1
                 ; we use the time and do some stuff in here...
;
; this is stuff which takes time,
; but can be done anywhere, so we do it here
; in a 'pause'

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; independent code section
; decrease and check level timer
; warn if low
                 LDB    y_timer+1          ; load new vector (length was cut by timer :-))
                 CMPB   #$20               ; is it small yet?
                 BGT    die_not_time
                 BNE    go_on_timer1       ; no, than jump
                 PLAY_SOUND triller1       ; otherwise play triller1
                 BRA    die_not_time
go_on_timer1:
                 CMPB   #$10               ; is it really really small?
                 BNE    die_not_time       ; nah, not that small yet
                 PLAY_SOUND triller2       ; or play triller2
die_not_time:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; done with in 'pause' stuff!
                 LDD     #((SCALE_FACTOR_GRID*256)+$40); A is scale, B is bit test $40
pattern_line_move1:
                 BITB    VIA_int_flags     ; Wait for T1 to time out
                 BEQ     pattern_line_move1;
                 ; move to done
                 _SCALE_A
                 ; draw line...
                 LDD     #(lo(-(12*GRID_SIZE))); A=0, B=X
                 STA     VIA_port_a        ; Send Y to A/D
                 STA     VIA_port_b        ; Enable mux
                 INC     VIA_port_b        ; Disable mux
                 STB     VIA_port_a        ; Send X to A/D
                 DEC     VIA_shift_reg
                 STA     VIA_t1_cnt_hi     ; enable T1H
                 LDB     #$40              ; B-reg = T1 interrupt bit
line_1_LF3F4:
                 BITB    VIA_int_flags     ; Wait for T1 to time out
                 BEQ     line_1_LF3F4
                 LDB     #(SCALE_FACTOR_GRID/6)
                 STA     VIA_shift_reg     ; Clear shift register (blank output)
                 ; line draw done
                 _SCALE_B
                 ; move start
                 LDB     #(lo(-1-(6*GRID_SIZE))); a small Y offset down
                 STB     VIA_port_a        ; Store Y in D/A register
                 STA     VIA_port_b        ; Enable mux
                 LDB     #$CE              ; Blank low, zero high?
                 STB     VIA_cntl          ;
                 INC     VIA_port_b        ; Disable mux
                 STA     VIA_port_a        ; Store X in D/A register
                 STA     VIA_t1_cnt_hi     ; enable timer
                 LDD     #((SCALE_FACTOR_GRID)*256+$40); A is scale, B is bit test $40
pattern_line_move2:
                 BITB    VIA_int_flags     ; Wait for T1 to time out
                 BEQ     pattern_line_move2;
                 ; move end
                 _SCALE_A
                 ; draw start
                 LDD     #(lo((12*GRID_SIZE))); A=0, B=X
                 STA     VIA_port_a        ; Send Y to A/D
                 STA     VIA_port_b        ; Enable mux
                 INC     VIA_port_b        ; Disable mux
                 STB     VIA_port_a        ; Send X to A/D
                 DEC     VIA_shift_reg
                 STA     VIA_t1_cnt_hi     ; Set T1H (scale factor?)
                 LDB     #$40              ; B-reg = T1 interrupt bit
line_2_LF3F4:
                 BITB    VIA_int_flags     ; Wait for T1 to time out
                 BEQ     line_2_LF3F4
                 LDB     #(SCALE_FACTOR_GRID/2)
                 STA     VIA_shift_reg     ; Clear shift register (blank output)
                 ; draw end
                 _SCALE_B
 ; notice!
 ; the timer line length could also be altered using the scale factor,
 ; in fact that would save some cycles, especially
 ; when time goes low...
                 _ZERO_VECTOR_BEAM         ; back to zero
                 ; A is still zero from above
                 ; move to
                 LDB     #lo(-(2*(5*GRID_SIZE+GRID_SIZE/2))); y offset
                 STB     VIA_port_a        ; Store Y in D/A register
                 STA     VIA_port_b        ; Enable mux
                 LDB     #$CE              ; Blank low, zero high?
                 INC     VIA_port_b        ; Disable mux
                 STB     VIA_cntl          ; zero high, this is really a few cycles to early!
                 LDB     #-(2*(6*GRID_SIZE)); X pos relative to start
                 STB     VIA_port_a        ; Store X in D/A register
                 STA     VIA_t1_cnt_hi     ; enable timer
                 LDD     #((SCALE_FACTOR_GRID*256)+$40) ;A= scale, B-reg = T1 interrupt bit
time_line_move:
                 BITB    VIA_int_flags     ; Wait for T1 to time out
                 BEQ     time_line_move    ;
                 ; move done
                 _SCALE_A
                 LDB     y_timer+1         ; load new vector (length was cut by timer :-)), y is allways 0
                 ; draw line
                 CLRA
                 STA     VIA_port_a        ; Send Y to A/D
                 STA     VIA_port_b        ; Enable mux
                 INC     VIA_port_b        ; Disable mux
                 STB     VIA_port_a        ; Send X to A/D
                 DEC     VIA_shift_reg
                 STA     VIA_t1_cnt_hi     ; Set T1H (scale factor?)
                 LDB     #$40              ; B-reg = T1 interrupt bit
                 CLR     tmp1              ; clear temporal
                 CLR     tmp1+1            ; storage for offset
                 LDU     #home_objects     ; load the address to U, start of list of homes
line_3_LF3F4:
                 BITB    VIA_int_flags     ; Wait for T1 to time out
                 BEQ     line_3_LF3F4
                 LDB     #$CC              ; prepare for zero below
                 STA     VIA_shift_reg     ; Clear shift register (blank output)
                 ; draw end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; independent code section
; draw all 'home' sprites
                 STB     VIA_cntl          ; BLANK low and /ZERO low
                 LDX     ,U                ; load object to X
                 BEQ     no_object_in_1_house; if zero, than anothing to do
; do 1 house object here!
                 MY_HOME_SPRITE1
no_object_in_1_house:
                 LDU     #home_objects+5   ; load the address to U, start of list of homes
                 LDX    ,U
                 BEQ     no_object_in_2_house ; if zero, than anothing to do
; do 2 house object here!
                 MY_HOME_SPRITE
no_object_in_2_house:
                 LDU     #home_objects+10  ; load the address to U, start of list of homes
                 LDX    ,U
                 BEQ     no_object_in_3_house ; if zero, than anothing to do
; do 3 house object here!
                 MY_HOME_SPRITE
no_object_in_3_house:
                 LDU     #home_objects+15  ; load the address to U, start of list of homes
                 LDX    ,U
                 BEQ     no_object_in_4_house ; if zero, than anothing to do
; do 4 house object here!
                 MY_HOME_SPRITE
no_object_in_4_house:
                 LDU     #home_objects+20  ; load the address to U, start of list of homes
                 LDX    ,U
                 BEQ     no_object_in_5_house ; if zero, than anothing to do
; do 5 house object here!
                 MY_HOME_SPRITE
no_object_in_5_house:
all_home_objects_done:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; now look if there is a snake on some log
                 LDB     snake_status      ; get the status
                 LBEQ    no_snake          ; if zero, than no snake on level
                 CMPB    #IS_DISPLAYED     ; if waiting
                 LBNE    no_snake          ; go to no snake
                 ; now we set the new coordinates
                 _ZERO_VECTOR_BEAM         ; go allways to zero, is sort of bad,
                 LDU     #snake_anim_counter; U to snake_anim_counter
                 LDX     snake_object      ; Y to snake object
                 MY_GAME_SCALE             ; a different scale again... still very high :-(
                 LDD     snake_pos         ; do positioning, load pos here
                 ; move to start
                 STA     VIA_port_a        ; Store Y in D/A register
                 LDA     #$CE              ; Blank low, zero high?
                 STA     VIA_cntl          ;
                 CLRA
                 STA     VIA_port_b        ; Enable mux
                 INC     VIA_port_b        ; Disable mux
                 STB     VIA_port_a        ; Store X in D/A register
                 STA     VIA_t1_cnt_hi     ; enable timer
; here in move stuff!
                 LEAX    1,X               ; + 1
                 LDD     snake_pos         ; do positioning, load pos here
                 ADDB    snake_speed       ; add the speed, got from log information earlier
                 CMPB    #(BOUNDARY_LO)    ; is on left side out of bounds?
                 BGT     snot_lower_out_of_bounds ; no, than no coordinate fiddling
snake_wait:
                 INC     snake_status      ; is waiting
                 LDA     snake_round_counter_reset ; initiate the round counter
                 STA     snake_round_counter; store it
                 LBRA    snake_done_no_snake_next_round
snot_lower_out_of_bounds:
                 CMPB    #(BOUNDARY_HI)    ; check if we are out of bounds on the right
                 BGT     snake_wait
snot_higher_out_of_bounds:
                 STD     snake_pos         ; and 're' store it
snake_done_no_snake_next_round:
                 DEC     snake_gone        ; decrease the number of steps a snake does befor turing arround
                 BNE     go_on_snake       ; if not turning... go on
                 PSHS    X                 ; save X
                 LDA     9,X               ; look at special in object definition for information...
                 CMPA    #SPECIAL_RIGHT_SNAKE; are we now left or right?
                 BEQ     switch_to_left_snake; if right... jump
switch_to_right_snake:
                 LDD     6,X               ; load old sprite offsets
                 NEGA                      ; negate them (A)
                 NEGB                      ; negate them (B)
                 ADDA    snake_pos         ; add y position to old sprite offset y
                 ADDB    snake_pos + 1     ; add x position to old sprite offset x
                 LDX     #snake1a_object   ; load new object definition
                 ADDA    7,X               ; add new sprite offset y
                 ADDB    8,X               ; add new sprite offset x
                 STD     snake_pos         ; and store the corrected position
                 STX     snake_object      ; store new object definition
                 LDA     4,X               ; load new animation counter start
                 STA     snake_anim_counter; and set it in object list
                 INC     snake_speed       ; now go to opposite direction +1 equal log speed
                 INC     snake_speed       ; plus another to be 1 step faster
                 LDA     #SNAKE_GO_LIMIT   ; get the limit of snake movement before turing again
                 STA     snake_gone        ; and store it
                 PULS    X                 ; restore X
                 BRA     snake_all_done    ; done with snake
switch_to_left_snake:
                 LDD     6,X               ; load old sprite offsets
                 NEGA                      ; negate them (A)
                 NEGB                      ; negate them (B)
                 ADDA    snake_pos         ; add y position to old sprite offset y
                 ADDB    snake_pos + 1     ; add x position to old sprite offset x
                 LDX     #snake3a_object   ; load new object definition
                 ADDA    7,X               ; add new sprite offset y
                 ADDB    8,X               ; add new sprite offset x
                 STD     snake_pos         ; and store the corrected position
                 STX     snake_object      ; store new object definition
                 LDA     4,X               ; load new animation counter start
                 STA     snake_anim_counter; and set it in object list
                 DEC     snake_speed       ; now go to opposite direction -1 equal log speed
                 DEC     snake_speed       ; minus another to be 1 step faster
                 LDA     #SNAKE_GO_LIMIT   ; get the limit of snake movement before turing again
                 STA     snake_gone        ; and store it
                 PULS    X                 ; restore X
                 BRA     snake_all_done    ; done with snake, on turn, no animation check is needed
go_on_snake:
                 DEC     ,U+               ; decrease animation counter
                 BNE     snake_all_done    ; if zero, we must initialize new animation phase
                 PSHS    X                 ; save X
; snake animation change
                 LDD     6,X               ; load old sprite offsets
                 NEGA                      ; negate them (A)
                 NEGB                      ; negate them (B)
                 ADDA    -3,U              ; add y position to old sprite offset y
                 ADDB    -2,U              ; add x position to old sprite offset x
                 LDX     4,X               ; load new object definition
                 ADDA    7,X               ; add new sprite offset y
                 ADDB    8,X               ; add new sprite offset x
                 STD     -3,U              ; and store the corrected position
                 STX     -5,U              ; store new object definition to object list
                 LDA     4,X               ; load new animation counter start
                 STA     -1,U              ; and set it in object list
                 PULS    X                 ; restore X
snake_all_done:
; in move stuff end
                 LDX     ,X                ; load object vector list to X,
 if USE_LOOP_UNROLING ==1
                 LDD     ,X++              ; load offset of vector list draw
                 ADDD    #(unloop_start_address0+LENGTH_OF_HEADER-12*ONE_LINE_LENGTH); 4=JMP [], 2=LDD ,X++


                 STD     i_jump
 endif
                 LDD     #(($40*256)+(SCALE_FACTOR_SPRITE)); A bit for timer, B scale
LF33D:           BITA    VIA_int_flags     ; wait for timer to finnish move to
                 BEQ     LF33D             ;
                                           ; if not allready
                 _SCALE_B                  ; scale for sprite
 if USE_LOOP_UNROLING !=1
 MY_SPRITE_DRAW_VLC        ; draw the sprite
 else
unloop_start_address0:
 MY_SPRITE_DRAW_VLC_UNLOOP_SMALL
 endif

 if USE_LOOP_UNROLING !=1
                 STA     VIA_shift_reg     ; finnish draw
 endif
no_snake:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; independent code section
; remove/display otter
                 LDA     otter_status      ; is there any otter stuff at all?
                 LBEQ    no_otter_in_level ; no?, than go on
 if USE_LOOP_UNROLING ==1
                 CLR     VIA_shift_reg     ; [4] turn the lights off
 endif
                 CMPA    #IS_WAITING       ; croco is waiting to be displayed
                 LBEQ    finnished_otter_stuff; if zero, do nothing
; otter is allready displayed, must check if we should destroy it...
otter_is_being_displayed:
                 LDX     otter_log_past    ; load object list address of object past otter
                 LDB     otter_pos+1       ; and load the position of otter now
                 CMPB    3,X               ; compare to log pos
                 BGE     display_otter     ; go to display if otter higher log
                 ; here when otter pos smaller log pos
                 ADDB    #OTTER_X_LEN+5    ; now add the hardcoded length plus some (5) extra 'pixel'
                 CMPB    3,X               ; compare to log pos
                 BLE     display_otter     ; if still lower, than display
                 ;otherwise if now greater, than a 'collision' with log happened
; now destroy otter
destroy_otter:
                 LDD     otter_timer_start ; reload the otter timer
                 STD     otter_timer       ; and store it
                 INC     otter_status      ; IS WAITING
                 LBRA    finnished_otter_stuff; and go to done
                 ; ok, otter is available and still displayed...
                 ; first let us look if there is afrog to be eaten... :-)
display_otter:
                 _ZERO_VECTOR_BEAM         ; go to 0,0
                 LDA     otter_band        ; what band are we on now ?
                 INCA                      ; plus one to compare with frog band
                 CMPA    frog_y_band       ; compare with frog band
                 BNE     display_otter_1   ; if not equal... do a simple otter display
                 LDB     otter_pos + 1     ; load otter position
                 SUBB    frog_x            ; subtract frog position
                 BPL     display_otter_1   ; if positive no collision is possible -> jump to display
                 CMPB    #-20              ; near 20
                 BLO     display_otter_1   ; if lower, than everything OK
                 TST     kind_of_death+1   ; test if we are in death timer loop
                 BNE     display_otter_1   ; frog is allready dead!
                 JSR     DP_to_C8
                 direct   $C8
                 LDD     #DIE_MOLE         ; die a DIE_MOLE kind of
                 JMP     die_set_2
                 direct $d0
display_otter_1:
;............................................................................
; this is actually the same as the code used in the main sprite loop
; just fitted for otter only...
                 MY_GAME_SCALE             ; scale for game positioning
                 LDD     otter_pos         ; load otter position
                 ; move to
                 STA     VIA_port_a        ; Store Y in D/A register
                 LDA     #$CE              ; Blank low, zero high?
                 STA     VIA_cntl          ;
                 CLRA
                 STA     VIA_port_b        ; Enable mux
                 INC     VIA_port_b        ; Disable mux
                 STB     VIA_port_a        ; Store X in D/A register
                 STA     VIA_t1_cnt_hi     ; enable timer
; in move stuff start
                 LDD     otter_pos         ; load otter position
                 ADDB    otter_speed       ; add the speed
                 CMPB    #(BOUNDARY_LO)    ; is on left side out of bounds?
                 BGT     onot_lower_out_of_bounds ; no, than no coordinate fiddling
                 ADDB    #(127+100-MAX_SPRITE_OFFSET)
                 BRA     obound_test_done  ; don't check for right out of bounds now
onot_lower_out_of_bounds:
                 CMPB    #(BOUNDARY_HI)    ; check if we are out of bounds on the right
                 BLE     onot_higher_out_of_bounds ; no? than go on
                 SUBB    #(127+100-MAX_SPRITE_OFFSET)
obound_test_done:
onot_higher_out_of_bounds:
                 STB     otter_pos + 1     ; store the new x position
                 LDU     otter_object      ; load the otter object to U
                 DEC     otter_anim_counter; decrease animation counter
                 BNE     no_anim_change_otter; if zero, we must initialize new animation phase
                 LDD     7,U               ; load old sprite offsets
                 NEGA                      ; negate them (A)
                 NEGB                      ; negate them (B)
                 ADDA    otter_pos         ; add y position to old sprite offset y
                 ADDB    otter_pos + 1     ; add x position to old sprite offset x
                 LDX     5,U               ; load new object definition
                 ADDA    7,X               ; add new sprite offset y
                 ADDB    8,X               ; add new sprite offset x
                 STD     otter_pos,U       ; and store the corrected position
                 STX     otter_object      ; store new object definition to object list
                 LDA     4,X               ; load new animation counter start
                 STA     otter_anim_counter; and set it in object list
no_anim_change_otter:
                 LDX     1,U               ; load object vector list to X,
; in move stuff end
                 LDD     #(((SCALE_FACTOR_SPRITE)*256)+$40); A= scale, B = timer IRQ...
otter_move1:
                 BITB    VIA_int_flags     ; Wait for T1 to time out
                 BEQ     otter_move1       ;
                 ; move done
                 _SCALE_A                  ; scale for sprite
                 MY_SPRITE_DRAW_VLC        ; draw sprite
                 STA     VIA_shift_reg     ; finnish otter
otter_draw_done:
;............................................................................
no_otter_in_level:
finnished_otter_stuff:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; entry for 'LEVEL DONE' display
; only the 'sprites' are displayed (and moved) below...
entry_level_done:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; independent code section
                 CLRA
                 ; DRAW ALL LEVEL SPRITES
                 ; now drawing all sprites (or object, whatever you call them)
                 ; isn't that a nice short routine, to draw all sprites,
                 ; move them, do an out of bounds checking,
                 ; intensity changing, and initializing
                 ; new animation sequences?
                 ; actually the animation initialization takes most of the code
                 ; well, split the makros... :-) and you'll see that it
                 ; is not that short afterall...
                 LDU     #object_list+2    ; load the address to U, start of list of
                                           ; all objects (sprites) for this level
                                           ; and their position
                 LDY     object_list       ; load new list object
                                           ; U pointing to Y coordinate now
                                           ; Y pointing to object structure AND
                                           ; Y pointing to x-speed in object structure
next_object:
 if USE_LOOP_UNROLING !=1
                 STA     VIA_shift_reg     ; leftover from draw vector list, A=0, switch pattern to 0
                 _ZERO_VECTOR_BEAM         ; go allways to zero, is sort of bad,
                                           ; bad doing relativ offsets need some
                                           ; calculating AND can be MUCH WORSE
                                           ; at least I know excactly where I am...
                 MY_GAME_SCALE             ; a different scale again... still very high :-(
 else
                 MY_GAME_SCALE             ; a different scale again... still very high :-(
                 LDB     #$CC
                 CLR     VIA_shift_reg     ; [4] turn the lights off
                 STB     <VIA_cntl       ;/BLANK low and /ZERO low
;                 _ZERO_VECTOR_BEAM         ; go allways to zero, is sort of bad,
                                           ; bad doing relativ offsets need some
                                           ; calculating AND can be MUCH WORSE
                                           ; at least I know excactly where I am...
 endif
                 LDD     ,U                ; load y, x coordinate from object_list to
                                           ; A,B=D,
                  ; intensities of all sprites are the same, so no
                  ; setting is really needed!
;                 LDA     9,Y                ; load intensity of sprite
;                 MY_INTENSITY_A             ; change to intensity in A
; fuck, now it really gets tricky, this used to be a makro, but due to
; optimization I split the makro
; notice:
; during a positioning of a vector, there is a loop, where the program just
; waits for the beam to reach the required position
; it waits for the SCALE.
; here I tweaked the move_to_d function for my purposes
; i use an optimized 'version' of move_to_D (without the delays, losing
; a little bit of accuracy)
; since game positioning is done with a 'huge' scale factor ($91) there
; is a whole lot of empty space in here, and that at EACH sprite.
; I don't know yet how to use the time wasted here efficiently,
; I should build a task handler for things like this :-)
; anyway, the only thing done yet in (befor!) that loop is the
; checking whether an animation occurs or not.
; and now if the sprite is out of bounds
; and girl and snake checking!!!
; not much yet, but another 1000 cycles saved.
; note: there can probably MUCH more been done during that waiting!!!
;;;;;;;;;;;;; NOW MOVE_TO_D
                 ; note: there are 2 or 3 cycles more that could be saved here
                 ; by optimizing, but the vectrex zeroing is NOT
                 ; fast enough, vectors are not positioned correctly than!!!
                 STA     VIA_port_a        ; Store Y in D/A register
                 CLR     VIA_port_b        ; Enable mux, this sets the Y integrator
                 LDA     #$CE              ; Blank low, zero high?
                 INC     VIA_port_b        ; Disable mux
                 STB     VIA_port_a        ; Store X in D/A register this goes to the X integrator
                 STA     VIA_cntl          ; Now zero is of... we can integrate!
                 CLR     VIA_t1_cnt_hi     ; enable timer, by accessing it!
                 ; here we have more than SCALE_FACTOR_GAME ($91) cycles time!
; in move action here!
                 LEAU     1,U              ; Increment U by 1
                 ADDB    ,Y+               ; add to B (x coordinate that is)
                                           ; the speed value (in the list object,
                                           ; e.g. car_1), increment Y by 1
                 CMPB    #(BOUNDARY_LO)    ; is on left side out of bounds?
                 BGT     not_lower_out_of_bounds ; no, than no coordinate fiddling
                 ADDB    #(127+100-MAX_SPRITE_OFFSET)
                 BRA     now_check_for_girl; don't check for right out of bounds now
not_lower_out_of_bounds:
                 CMPB    #(BOUNDARY_HI)    ; check if we are out of bounds on the right
                 BLE     not_higher_out_of_bounds ; no? than go on
                 SUBB    #(127+100-MAX_SPRITE_OFFSET)
; on each out of bounds a girl check is made...
now_check_for_girl:
                 PSHS    D                 ; save coordinates
                 _DP_TO_C8
                 LDA     girl_status       ; what's the girls status?
                 BEQ     no_girl_          ; no girl at all? than jump
;                 TFR     U,D               ; transfer object list address to D
;                 CMPA    girl_log_object   ; so that we can conveniently compare
;                 BNE     no_girl_          ; it to girl_log_object
;                 CMPB    girl_log_object+1 ; which contains the log a objectlist address
                 CMPU    girl_log_object
                 BNE     no_girl_          ; if not the same, go to no_girl_
                 LDA     girl_status       ; what's the girls status?
                 CMPA    #IS_WAITING       ; we are waiting to be displayed
                 BEQ     girl_might_be_displayed; than go to might be displayed routine
                 CMPA    #IS_CARRIED       ; if frogger carries girl,
                 BEQ     no_girl_          ; do nothing
                 ; now IS_DISPLAYED, resetting counter and reset status
is_currently_displayed:
                 INC     girl_status       ; IS WAITING
                 LDA     girl_round_counter_reset ; initiate the round counter
                 STA     girl_round_counter; store it
girl_might_be_displayed:                   ; check if the girl will be displayed
                 DEC     girl_round_counter; count down the round counter
                 BNE     no_girl_          ; if not zero, than no girl will be displayed
                 DEC     girl_status       ; IS DISPLAYED
                 LDD     #girl1a_object    ; load girl object address
                 STD     girl_object       ; store it as first object
                 ; now do positioning...
                 LDB     1,S               ; the position of the log is on the stack
                 STB     girl_pos+1        ; get and store the X position
                 LDA     #28               ; y position hardcoded, since sprites have different starting points
                 STA     girl_pos          ; store y position
                 BRA     no_snake_         ; if we did girl, than no snake here!
no_girl_:
now_check_for_snake:
                 LDA     snake_status      ; what's the snake's status?
                 BEQ     no_snake_         ; no snake at all? than jump
;                 TFR     U,D               ; transfer object list address to D
;                 CMPA    snake_log_object  ; so that we can conveniently compare
;                 BNE     no_snake_         ; it to girl_log_object
;                 CMPB    snake_log_object+1; which contains the log a objectlist address
                 CMPU    snake_log_object
                 BNE     no_snake_         ; if not the same, go to no_snake_
                 LDA     snake_status      ; what's the snake's status?
                 CMPA    #IS_WAITING       ; we are waiting to be displayed
                 BEQ     snake_might_be_displayed ; than go to might be displayed routine
snake_is_currently_displayed:
                 INC     snake_status      ; IS WAITING
                 LDA     snake_round_counter_reset ; initiate the round counter
                 STA     snake_round_counter; store it
snake_might_be_displayed:                  ; check if the snake will be displayed
                 DEC     snake_round_counter; count down the round counter
                 BNE     no_snake_         ; if not zero, than no snake will be displayed
                 DEC     snake_status      ; IS DISPLAYED
                 LDD     #snake1a_object   ; load snake object address
                 STD     snake_object      ; store it as first object
                 ; now do positioning...
                 LDB     1,S               ; the position of the log is on the stack
                 STB     snake_pos+1       ; get and store the X position
                 LDA     #48               ; y position hardcoded, since sprites have different starting points
                 STA     snake_pos         ; store y position
                 LDA     snake_speed_start ; get the speed of snake start
                 STA     snake_speed       ; store it
                 LDA     #SNAKE_GO_LIMIT-10; get the number of steps a snake can take befor turning arround (hardcoded :-()
                 STA     snake_gone        ; and store it
no_snake_:
                 _DP_TO_D0
                 PULS    D                 ; restore coordinates
bound_test_done:
not_higher_out_of_bounds:
                 STB     ,U+               ; store the new x position, and increment U
                                           ; (U points to animation)
; now we do that animation checking
                 LDX     ,Y                ; load object vector list to X,
                 DEC     ,U+               ; decrease animation counter
                 BNE     no_animation_move ; if zero, we must initialize new animation phase
new_animation_phase:
                 LDD     6,Y               ; load old sprite offsets
                 NEGA                      ; negate them (A)
                 NEGB                      ; negate them (B)
                 ADDA    -3,U              ; add y position to old sprite offset y
                 ADDB    -2,U              ; add x position to old sprite offset x
                 LDY     4,Y               ; load new object definition
                 ADDA    7,Y               ; add new sprite offset y
                 ADDB    8,Y               ; add new sprite offset x
                 STD     -3,U              ; and store the corrected position
                 STY     -5,U              ; store new object definition to object list
                 LDA     4,Y               ; load new animation counter start
                 STA     -1,U              ; and set it in object list
no_animation_move:
                 LDY     ,U++              ; load new list object, increment U by 2
                 LBEQ    anim_no_next      ; and do the next object  (or jump away)
 if USE_LOOP_UNROLING == 1
                 LDD     ,X++              ; load offset of vector list draw
                 ADDD    #(unloop_start_address1+LENGTH_OF_HEADER); 4=JMP [], 2=LDD ,X++
                 STD     i_jump
 endif
objects_not_all_done_move:
; in move action done
                 LDD     #((SCALE_FACTOR_SPRITE*256)+$40); A= SCALE, B = Timer IRQ check
                 ; the following is the position checking loop
                 ; waiting till an interrupt occurs
move_sprite_1:
                 BITB    VIA_int_flags     ; test the bit
                 BEQ     move_sprite_1     ; if not zero, than loop
                 _SCALE_A                  ; scale for sprite
 if USE_LOOP_UNROLING !=1
                 MY_SPRITE_DRAW_VLC        ; draw the sprite
 else
unloop_start_address1:
                 MY_SPRITE_DRAW_VLC_UNLOOP
 endif
                 BRA     next_object       ; and do the next

                 ; here if no new animation is to be done
anim_no_next:
 if USE_LOOP_UNROLING == 1
                 LDD     ,X++              ; load offset of vector list draw
                 ADDD    #(unloop_start_address2+LENGTH_OF_HEADER); 4=JMP [], 2=LDD ,X++
                 STD     i_jump
 endif
                 LDD     #((SCALE_FACTOR_SPRITE*256)+$40); A= SCALE, B = Timer IRQ check
                 ; the following is the position checking loop
                 ; waiting till an interrupt occurs
move_sprite_3:
                 BITB    VIA_int_flags     ; test the bit
                 BEQ     move_sprite_3     ; if not zero, than loop
                 _SCALE_A                  ; scale for sprite
 if USE_LOOP_UNROLING !=1
                 MY_SPRITE_DRAW_VLC        ; draw the sprite
 else
unloop_start_address2:
                 MY_SPRITE_DRAW_VLC_UNLOOP
 endif
objects_all_done:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; now look if there is a girl on some log
                 LDB     girl_status       ; get the status
 if USE_LOOP_UNROLING !=1
                 STA     VIA_shift_reg     ; finnish last sprite draw
                 CMPB    #IS_DISPLAYED     ; if waiting
                 BEQ     do_girl_stuff     ; go to girl stuff
 else
                 CMPB    #IS_DISPLAYED     ; if waiting
                 BEQ     do_girl_stuff     ; go to girl stuff
                 CLR     VIA_shift_reg     ; finnish last sprite draw
 endif
no_girl:
girl_allready_done:
                 direct $d0
                 ; finnished drawing the whole level once!
                 RTS
; girl stuff below main function for short branches...
do_girl_stuff:
                 ; now we set the new coordinates and jump into the object
                 ; display loop again
                 ; setup all registers for a jump into the object loop
                 MY_GAME_SCALE             ; a different scale again... still very high :-(
 if USE_LOOP_UNROLING ==1
                 CLR     VIA_shift_reg     ; finnish last sprite draw
 endif
                 _ZERO_VECTOR_BEAM         ; go allways to zero, is sort of bad,
                 LDD     girl_pos          ; do positioning, load pos here
                 STA     VIA_port_a        ; Store Y in D/A register
                 CLR     VIA_port_b        ; Enable mux, this sets the Y integrator
                 INC     VIA_port_b        ; Disable mux
                 STB     VIA_port_a        ; Store X in D/A register this goes to the X integrator
                 LDA     #$CE              ; Blank low, zero high?
                 STA     VIA_cntl          ; Now zero is of... we can integrate!
                 CLR     VIA_t1_cnt_hi     ; enable timer, by accessing it!

                 ; here we have more than SCALE_FACTOR_GAME ($91) cycles time!
                 ; nothing is now done here!
                 LDU     #girl_anim_counter; U to girl_anim_counter
                 LDY     girl_object       ; Y to girl object
                 LEAY    1,Y               ; + 1

                 LDD     girl_pos          ; do positioning, load pos here
                 ADDB    girl_speed        ; add the speed, got from log information earlier
                 STD     girl_pos          ; and 're' store it

; now we do that animation checking
                 LDX     ,Y                ; load object vector list to X,
                 DEC     ,U+               ; decrease animation counter
                 BNE     no_animation_moveg; if zero, we must initialize new animation phase
new_animation_phaseg:
                 LDD     6,Y               ; load old sprite offsets
                 NEGA                      ; negate them (A)
                 NEGB                      ; negate them (B)
                 ADDA    -3,U              ; add y position to old sprite offset y
                 ADDB    -2,U              ; add x position to old sprite offset x
                 LDY     4,Y               ; load new object definition
                 ADDA    7,Y               ; add new sprite offset y
                 ADDB    8,Y               ; add new sprite offset x
                 STD     -3,U              ; and store the corrected position
                 STY     -5,U              ; store new object definition to object list
                 LDA     4,Y               ; load new animation counter start
                 STA     -1,U              ; and set it in object list
no_animation_moveg:
                 LDD     #((SCALE_FACTOR_SPRITE*256)+$40); A= SCALE, B = Timer IRQ check
                 ; the following is the position checking loop
                 ; waiting till an interrupt occurs
move_sprite_g:
                 BITB    VIA_int_flags     ; test the bit
                 BEQ     move_sprite_g     ; if not zero, than loop
                 _SCALE_A                  ; (SCALE_FACTOR_SPRITE)
                 MY_SPRITE_DRAW_VLC        ; draw the sprite
                 STA     VIA_shift_reg     ; this is about 3 cycles to early, :(
                 direct $d0
                 RTS                       ; and finnished drawing even the girl
;***************************************************************************
; this routine initializes the game variables
; nothing is expected and nothing is returned
; leaves DP to C8
init_vars:
                 JSR     DP_to_C8
                 direct $C8
                 LDA     #1                ; these set up the joystick
                 STA     Vec_Joy_Mux_1_X   ; enquiries
                 LDA     #3                ; allowing only all directions for
                 STA     Vec_Joy_Mux_1_Y   ; for joystick one
                 LDA     #0                ; this setting up saves a few hundred
                 STA     Vec_Joy_Mux_2_X   ; cycles
                 STA     Vec_Joy_Mux_2_Y   ; don't miss it, if you don't need the
                                           ; second joystick!
                 LDD     #weirdos          ; load weirdos address
                 STD     music_counter     ; and store it to music counter
; copy music structure to ram
                 LDX     #copy_start4      ; start of ram copy 4 address
                 LDU     #_copy_start4     ; start of rom copy 4 address
copy_loop1:
                 LDA     ,U+               ; load byte from U to A and increment U
                 STA     ,X+               ; store A byte to X and increment X
                 CMPA    #$ff              ; was it last byte
                 BNE     copy_loop1        ; no, than loop on...
                 ; ram for score and 'small stuff'
                 LDU     #_copy_start1     ; my 'ram' address (source)
                 LDX     #copy_start1      ; copy my 'ram' to vectrex ram (destination)
                 LDA     #(_copy_end1-_copy_start1) ; number of bytes to be copied, must be less than $81
                 JSR     Move_Mem_a        ; and copy...

                 LDX     #copy_start2      ; address to clear
                 LDD     #((copy_end2-copy_start2)-1); number of bytes - 1 to clear
                 JSR     Clear_x_d         ; clear sub routine in ROM

                 LDX     #copy_start3      ; address to clear
                 LDD     #((copy_end3-copy_start3)-1); number of bytes - 1 to clear
                 JSR     Clear_x_d         ; clear sub routine in ROM
                 LDA     #0                ; initial game level
                 STA     game_level        ; upon startup
                 LDX     #no_level_string  ; get level string
                 JSR     Clear_Score       ; clear level string
                 CLR     y_timer           ; no y change for timer line...
; entry point for continue with current level
continue_level:
                 LDX     #no_score_string  ; get the address of score string
                 JSR     Clear_Score       ; clear score
                 LDA     #FROGS_PER_GAME   ; balls 5
                 STA     no_frogs          ; and store five balls
                 LDA     no_score_string+1 ; load the 5th digit
                 STA     high_check        ; and store it, for new life at change... (every 10000 points)
; entry point for each new frog
init_new_frog_vars:
                 direct $c8
                 CLR     level_score       ;
                 LDD     #frogger_up       ; frogger faces up
                 STD     frog_pic          ; upon startup
                 LDB     #FROG_SIZEX_UP    ; adjust sizing information
                 STB     current_frog_size_x; store it
                 LDA     #HEADING_UP       ; first frog is looking up
                 STA     current_frog_heading; store that
                 LDD     frogger_up_offset ; load the offset of the currently used pic
                 STD     current_frog_offset; and store it for later use
                 LDD     #FROG_INIT_POS    ; load init values
                 ADDA    frogger_up_offset ; and evalute the new pos
                 ADDB    frogger_up_offset+1; corresponding to the offset
                 STD     frog_pos          ; and store them...
                 LDD     #FROG_INIT_POS_BAND; load init values
                 STD     frog_pos_band     ; and store them...
                 LDD     my_timer_start    ; initialize timer
                 STD     my_timer          ; store it
                 CLR     kind_of_death + 1 ; allways clear, for double death check
                 MY_QUIT                   ; be quiet
                 RTS
;***************************************************************************
; this routine draws the initial screen
; with information about the game
; nothing is expected and nothing is returned
; leaves dp pointing d0 expected
init_screen:
                 JSR     DP_to_D0
                 direct $D0
                 JSR     Read_Btns         ; get button status once, since only
                                           ; differences are noticed
                 JSR     DP_to_C8
                 direct $C8
                 LDD     #NORMAL_TEXT_SIZE ; load default text height & width
                 STD     Vec_Text_HW       ; poke it to ram location
                 ; just for show a little scroll text...
                 ; scrolltext destroys a whole load of valuable
                 ; ram space...
                 ; had to use some ram twice...
                 LDA     #-$70             ; y position of scroller
                 STA     scroll_y          ; store it
                 LDA     #-60              ; left boundary
                 STA     scroll_left_boundary; store it
                 LDA     #60               ; right boundary
                 STA     scroll_right_boundary; store it
                 LDA     #-1               ; scroll speed (going from right to left)
                 STA     scroll_speed      ; store it
                 LDA     #$60              ; and intensity of scroll text
                 STA     scroll_intensity  ; store it
                 LDX     #scroll_text      ; address of the text
                 JSR     set_up_scrolling  ; set it all up...
                 LDA     #$7f              ; startup intensity
                 STA     init_current_intensity ; store it to current intensity
                 LDA     #INIT_MODE_TEXT   ; first start up displaying the text
                 STA     init_screen_mode  ; store it in init screen mode
init_screen_loop:
                 direct  $D0
                 LDA     Vec_Music_Flag    ; is music still playing?
                 BNE     no_new_music      ; than jump
                 LDD     music_counter     ; load new table addresses
                 CMPD    #weirdos_end      ; are we at the end?
                 BNE     no_last_weirdos   ; no, than go on
                 LDD     #weirdos          ; load weirdos address
                 STD     music_counter     ; and store it to music counter
no_last_weirdos:
                 ; in D now address of new weirdo
                 TFR     D,Y               ; transfer D to index register Y
                 ADDD    #4                ; now set the next weirdo address
                 STD     music_counter     ; and store it to music counter
                 LDX     #yankee           ; load adddress of music structure
                 LDD     ,Y++              ; load
                 STD     ,X++              ; and store new ADSR table
                 LDD     ,Y++              ; load
                 STD     ,X++              ; and store new twang table
                 PLAY_SOUND yankee         ; and play the tune again...
no_new_music:
                 ROUND_STARTUP             ; well, the startup...
                 JSR     do_one_scroll_step; this does the whole scroll text
                                           ; thing...
                                           ; beware... it destroys quite a
                                           ; lot of variables

                 LDA     init_current_intensity ; load the current intro intensity
                 JSR     Intensity_a       ; set it
                 LDA     init_screen_mode  ; load the current intro mode
                 ANDA    #INIT_MODE_TEXT   ; test for text more
                 BEQ     no_text_display   ; jump if not text mode
                 DEC     init_current_intensity ; decrement intensity
                 BNE     no_init_change    ; if not zero, than stay in same mode
                 LDA     #INIT_MODE_MORPH  ; otherwise switch to morph mode
                 STA     init_screen_mode  ; set it
                 LDA     #$60              ; load new intensity
                 STA     init_current_intensity ; and store it
                 LDU     #morph_init1      ; set up morphing
                 JSR     set_up_morphing   ; in a routine
no_init_change:
                 LDU     #game_name        ; load text start to U
                                           ; Get A=Y, B=X (D=AB) coordinate
                 LDD     #($70)*256+(lo(-$67)); Y, X coordinates
                 JSR     Print_Str_d       ; Print the string
;string printing "vectrex frogger" takes about 5000 cycles :-(
                 BRA     no_morph_display
no_text_display:
                 _ZERO_VECTOR_BEAM         ; back to zero
                 _SCALE  (SCALE_FACTOR_VECTOR_MORPH)
                 JSR     do_one_morph_step_16; does one morph step, changing of vectors
                 LDA     morph_status      ; load morph status
                 BNE     morph_not_done_yet; if not complete, jump
                 DEC     init_current_intensity; decrement intensity
                 BNE     no_init_change2   ; if not zero, jump
                 LDA     #INIT_MODE_TEXT   ; otherwise init text mode
                 STA     init_screen_mode  ; store it
                 LDA     #$7f              ; reload intensity
                 STA     init_current_intensity; store it
no_init_change2:
morph_not_done_yet:
                 LDD     #(20*256)+(lo(-80));y, x position of morph object
                 JSR     Moveto_d          ; must be after do_one_morph_step
                                           ; otherwise integraters 'leak'
                 LDX     #current_morph_vectorlist ; and load the new vector list
                 _SCALE  (SCALE_FACTOR_VECTOR_MORPH-30)
                 JSR     Draw_VLc          ; get it on the screen
no_morph_display:
                 JSR     Read_Btns         ; get button status
                 CMPA    #$00              ; is a button pressed?
                 BEQ     init_screen_loop  ; no, than stay in init_screen_loop
exit_init_screen:                          ; otherwise proceed
                 RTS
;***************************************************************************
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
                 direct $c8
                 LDA     #5                ; five homes exist
                 STA     in_home_counter   ; store it
                                           ; this means 5 empty homes
                 LDD     #0                ; clear all homes
                 LDY     #home_objects     ; first home
                 STD     ,Y                ; store the clear to home 1
                 STD     5,Y               ; store the clear to home 2
                 STD     10,Y              ; store the clear to home 3
                 STD     15,Y              ; store the clear to home 4
                 STD     20,Y              ; store the clear to home 5

                 STD     tmp2              ; this is a helper if we reinit the
                 BRA     no_reinit_level   ; level or start a new one
                                           ; this sets it to new level
; entry point for level reinit
; must allways be done after a morph, since a morph uses
; the same ram as the level information
; damn only 1 K (or less that is)
reinit_level:
                 CLR     tmp2              ; otherwise set tmp2
                 INC     tmp2              ; to 1, which means reinit
no_reinit_level:
                 CLR     tmp2+1
                 LDD     #0                ; clear all homes
                 ; clear static dive turtle list
                 LDX     #t_list           ; load start address
                 LDD     #14               ; load length of structure
                 JSR     Clear_x_d         ; clear object structure

                 ; first clear the current level
                 ; this clears the last level band list
                 LDX     #band_list        ; load start address
                 STX     tmp_band_list     ; savety copy to tmp_band_list
                 LDD     #(_band_list_end-_band_list_start) ; load length of structure
                 JSR     Clear_x_d         ; clear band_list
                 ; this clears the level object list
                 LDX     #object_list      ; load start address
                 LDD     #(_object_list_end-_object_list_start) ; load length of structure
                 JSR     Clear_x_d         ; clear object structure
                 LDU     #object_list      ; load the address to U
                 ; than we go to current level
                 LDA     #LEVEL_DATA_LENGTH; load length of level
                 LDB     game_level        ; load level number
                 MUL                       ; multiply these two
                 ADDD    #level1_data      ; and add to start address of level data
                 TFR     D,X               ; and in X register for easier access (indexed)
                 ; now we will loop a while, first thru all bands (11)
                 LDA     #11               ; 11 bands (10+ middle)
                 STA     loop1             ; initialize counter for loop1
_loop1:
                 ; and than the inner loop thru all band positions (12)
                 CLR     tmp_band_offset   ; band list (x) offset for each new
                 CLR     tmp_band_offset+1 ; band = 0
                 LDA     #12               ; fixed GRID_WIDTH
                 STA     loop2             ; initialize counter for loop2
_loop2:
                 LDB     ,X+               ; load level information (one byte each pass), increment X by 1
                 BEQ     move_on           ; than move on
                 ; if we encounter something different than 0
                 ; we have a sprite which we will place in the
                 ; object structure,
                 ; this object structur will be updated all thru the
                 ; game...
                 CLRA                      ; clear A
                 DECB                      ; since it starts at 1 not 0
                 ASLB                      ; multiply B by 2
                 ADDD    #object_table     ; add object table address
                 TFR     D,Y               ; move to index register Y
                 LDD     ,Y                ; and load the the sprite object structure to D
; first lets save this object list position to the current band_list
; pointer
; in the band_list are all object_list positions stored, sorted
; by each band
; band list provides storage for a maximum of 7 sprites per band
; this is NOT checked, make the levels good!!!
                 PSHS    X,D                 ; save X,D  register
                 LDD     tmp_band_list     ; load current band list 'band' (y) position
                 ADDD    tmp_band_offset   ; add the current (x) position (how many objects on this band)
                 INC     tmp_band_offset+1 ; increment the offset
                 INC     tmp_band_offset+1 ; by two
                 TFR     D,X               ; store that in X index register
                 STU     ,X                ; save the current object_list position to band_list
                 PULS    X,D               ; and restore the pointer to level information
                                           ; in D still the current object
; init dive turtle start
; a list with a max of 6, not checked!
                 PSHS    D,X               ; save D and X
                 TFR     D,Y               ; transfer D to index Y, get the object pointer to Y
                 LDA     10,Y              ; load special to A
                 ANDA    #SPECIAL_DIVE     ; look if it is a DIVE_SPECIAL
                 BEQ     this_is_no_dive_object ; if not, go on
                 LDB     tmp2+1            ; counter for number of divers
                 LDX     #t_list           ; position to store divers
                 STU     B,X               ; store object_list position to t_list plus offset
                 INCB                      ; and increment list pointer by 2
                 INCB
                 STB     tmp2+1            ; and store it back
this_is_no_dive_object:
                 PULS    D,X               ; restore D and X
; init dive turtle end
; now store the object definition address to the object_list
; and initialize all variables...
                 STD     ,U++              ; and store it to object_list increment U by two

                 TFR     D,Y               ; transfer D to index Y
                 LDD     7,Y               ; load the offsets from Y pointer
                 STA     ,U                ; y offset (these are offset in the sprite)
                 STB     1,U               ; x offset  itself, an offset to the starting vector
                 LDB     loop1             ; now get the y pos
                 SUBB    #6                ; make it signed
                 LDA     #GRID_SIZE_GAME   ; in game pos relation
                 MUL                       ; should be a byte value
                 ADDB    ,U                ; add to offset
                 STB     ,U+               ; and store it to object... increment U by one
                 LDB     loop2             ; now get the x pos
                 NEGB                      ; reverse the X coordinate
                 ADDB    #6                ; make it signed
                 LDA     #GRID_SIZE_GAME   ; in game pos relation
                 MUL                       ; should be a byte value
                 ADDB    ,U                ; add to offset
                 STB     ,U+               ; and store it to object... increment U by one
;                 LEAY    [-4,U]            ; load object again to Y
;                 LDB     4,Y               ; load anim speed at offset 4
                 JSR     Random            ; randomize the animation startup
                                           ; so that not all sprites are animated
                                           ; in the same round...
                 ANDA    #$f               ; maximum of 15
                 INCA                      ; at least one
                 STA     ,U+               ; store it to anim counter
move_on:
                 DEC     loop2             ; dec loop2
                 BNE     _loop2            ; end check if finnished
                 LDD     #16               ; fixed band list len
                 ADDD    tmp_band_list     ; go one band list element further
                 STD     tmp_band_list     ; and store it
                 DEC     loop1             ; dec loop1
                 BNE     _loop1            ; end check if finnished
error_list_to_long:
                 TST     tmp2              ; we don't won't to reinit
                 LBNE    no_reinit_stuff   ; the next stuff
                 LDA     ,X+               ; fly
                 BNE     fly_available     ; if fly available , jump
                 STA     fly_status        ; store to status, this means no fly on screen
                 BRA     fly_go_on         ; and go on
fly_available:
                 STA     fly_timer_start   ; otherwise use A as timer information HI
                 CLR     fly_timer_start +1; clear LO
                 LDD     fly_timer_start   ; reload
                 STD     fly_timer         ; and set the used timer to it
                 LDA     #IS_WAITING       ; fly is waiting to be displayed
                 STA     fly_status        ; store it
fly_go_on:
                 LDA     ,X+               ; crocodile
                 BNE     croco_available   ; if croco available , jump
                 STA     croco_status      ; store to status, this means no croco on screen
                 BRA     croco_go_on       ; and go on
croco_available:
                 STA     croco_timer_start ; otherwise use A as timer information HI
                 CLR     croco_timer_start +1; clear LO
                 LDD     croco_timer_start ; reload
                 STD     croco_timer       ; and set the used timer to it
                 LDA     #IS_WAITING       ; croco is waiting to be displayed
                 STA     croco_status      ; store it
croco_go_on:
                 CLR     otter_timer_start+1; reset LO of otter timer allways
                 LDA     ,X+               ; otter
                 STA     otter_status      ; store to status, this means no otter on screen if zero
                 STA     otter_timer_start ; otherwise use A as timer information HI
                                           ; rest of otter is initialized below in the 'allways' section
                 LDA     ,X+               ; snake on log
                 STA     snake_status      ; store to status, this means no snake on log
                 STA     snake_round_counter_reset ; if !=0 than it is the round_counter
                 BEQ     snake_go_on       ; and go on
                 ; x, y pos will be set in sprite draw loop
                 ; speed will also be taken from host (log) object
                 LDA     4,Y               ; load animation counter
                 STA     snake_anim_counter; and store it to object
                 LDY     #band_list+16+16  ; align snake to first object in band 3
                 LDY     ,Y                ; remember the object list position of that object
                 LDU     ,Y                ; get the object address
                 LDA     ,U                ; get the speed of the object
                 INCA                      ; allways go from left to right on startup...
                 STA     snake_speed_start ; store it
                 LEAY    3,Y               ; add three to object list position for easier checking in
                                           ; draw object routine
                 STY     snake_log_object  ; save the objectlist address...
snake_go_on:
                 LDA     ,X+               ; female
                 STA     girl_status       ; store to status, this means no girl on screen
                 STA     girl_round_counter_reset ; if !=0 than it is the round_counter
                 BEQ     girl_go_on        ; and go on
                 ; x, y pos will be set in sprite draw loop
                 ; speed will also be taken from host (log) object
                 LDA     4,Y               ; load animation counter
                 STA     girl_anim_counter ; and store it to object
                 CLR     girl_zero         ; clear the girl zero vector
                 CLR     girl_zero + 1     ; so that we jump out of the display loop
                 LDY     #band_list+16+16+16; align girl to first object in band 4
                 LDY     ,Y                ; remember the object list position of that object
                 LDU     ,Y                ; get the object address
                 LDA     ,U                ; get the speed of the object
                 STA     girl_speed        ; store it
                 LEAY    3,Y               ; add three to object list position for easier checking in
                                           ; draw object routine
                 STY     girl_log_object   ; save the objectlist address...
girl_go_on:
                 LDA     ,X+               ; timer
                 STA     my_timer_start    ; store time for level information
                 LDA     #$e0              ; and set low timer
                                           ; this now has the same length as the middway
                                           ; (if timer in level is set correctly that is)
                 STA     my_timer_start+1  ; store it
                 LDA     ,X+               ; turtle timer
                 STA     dive_timer_start  ; load the diving counter
                 STA     dive_timer        ; and set the timer for diving HI
                 CLR     dive_timer+1      ; clear LO
                 ; from here on again some 'allways init' stuff
no_reinit_stuff:
                 LDA     girl_round_counter_reset ; if !=0 than it is the round_counter
                 STA     girl_round_counter; if !=0 than it is the round_counter
                 BEQ     no_girl_on_this_level
                 LDA     #IS_WAITING       ; girl is waiting to be displayed
no_girl_on_this_level:
                 STA     girl_status       ; store it
                 LDA     snake_round_counter_reset ; if !=0 than it is the round_counter
                 STA     snake_round_counter; if !=0 than it is the round_counter
                 BEQ     no_snake_on_this_level
                 LDA     #IS_WAITING       ; snake is waiting to be displayed
no_snake_on_this_level:
                 STA     snake_status      ; store it
                 LDD     otter_timer_start ; reload the otter timer
                 STD     otter_timer       ; and store it
                 BEQ     no_otter_on_this_level
                 LDA     #IS_WAITING       ; otter status now is 'is waiting'
no_otter_on_this_level:
                 STA     otter_status      ; store the status
                 CLR     frog_bonus        ; no bonus collected for this frog
                 LDD     my_timer_start    ; reset timer
                 STD     my_timer          ; store it
                 LDA     #GRID_SIZE_GAME/2 ; needed for band information calculation
                 STA     tmp_band_offset   ; when frog 'rides' an object
                 RTS
;***************************************************************************
game_lost:
                 direct  $d0
                 LDU     #Vec_High_Score   ; 'OS' high score
                 LDX     #no_score_string  ; own last score
                 JSR     Compare_Score     ; jsr to compare the score now, to 'OS' high score
                 CMPA    #1                ; if 1, than the new score is new highscore
                 BNE     no_new_high       ; if not new high score, than jump
                 JSR     new_high_score    ; otherwise set this as new high
                 LDU     #Vec_High_Score   ; 'OS' high score
                 LDX     #no_score_string  ; own last score
                 JSR     New_High_Score    ; if own was higher, set 'OS' == own
no_new_high:
                 JSR     DP_to_C8          ; not speed optimized, but space!
                 direct  $C8
                 ; do some extro
                 CLRA                      ; clear A
                 STA     game_over_intensity; and store in intensity
                 STA     game_over_scalex  ; scale x
                 STA     game_over_scaley  ; scale y
                 STA     game_over_ypos    ; pos y
                 STA     game_over_xpos    ; pos x of game over string
                 PLAY_SOUND musicb
game_over_loop1:
                 ROUND_STARTUP
                 ; now print something on screen
                 LDA     game_over_scaley  ; prepare drawing of game over string
                 LDB     game_over_scalex  ; load scaling stuff
                 STD     Vec_Text_HW       ; poke it to ram location
                 LDA     game_over_intensity; load intensity
                 JSR     Intensity_a       ; set intensity
                 LDA     game_over_ypos    ; load position
                 LDB     game_over_xpos    ; to D (A,B) register
                 LDU     #game_over_string ; and the address of the string itself
                 JSR     Print_Str_d       ; and draw it
                 ; calculate new appearence
                 LDA     game_over_intensity; increase intensity
                 ADDA    #3                ; three per step
                 STA     game_over_intensity; store it
                 ANDA    #$1               ; every second step increase
                 BEQ     no_y_scale_now    ; y scale of string
                 LDA     game_over_scaley  ; load it
                 SUBA    #1                ; increase it
                 STA     game_over_scaley  ; save it
no_y_scale_now:
                 LDA     game_over_ypos    ; now look at the position of the
                 ADDA    #2                ; string, first y pos
                 CMPA    #$70              ; increase it by two, but not to much
                 BLO     use_y             ;
                 LDA     #$70              ; maximum at $70
use_y:
                 STA     game_over_ypos    ; store it
                 LDA     game_over_xpos    ; likewise treat x pos load it
                 SUBA    #2                ; decrease it
                 CMPA    #-$70             ; till -$70
                 BGE     use_x             ;
                 LDA     #-$70             ; or use minimum of -$70
use_x:
                 STA     game_over_xpos    ; store it
                 LDA     game_over_scalex  ; now do the x scaling
                 ADDA    #3                ; every round add 3
                 STA     game_over_scalex  ; and store it
                 LDA     game_over_intensity; do all this
                 CMPA    #$7f              ; till intensity is full
                 BLO     game_over_loop1   ; do the game loop
                 JSR     Read_Btns         ; get button status once, since only
                                           ; differences are noticed
                 LDA     game_over_scalex  ; now correct x scaling
                 SUBA    #3                ; since it just rolled over, sub 3
                 STA     game_over_scalex  ; and store it

                 LDU     #morph_countdown1 ; load address of morph structure
                 JSR     set_up_morphing   ; and initialize a new morphing
game_over_loop2:
                 ROUND_STARTUP             ; do sound and integrator reset stuff
                 JSR     Intensity_5F      ; and do it
                 LDD     #LITTLE_TEXT_SIZE ; load score text size
                 STD     Vec_Text_HW       ; poke it to ram location
                 LDD     #(-$70)*256+(lo(-$30)); Y=-$70, X=-$30
                 LDU     #score_only_string; get address of string
                 JSR     Print_Str_d       ; and draw it
                 LDA     game_over_scaley  ; prepare drawing of game over string
                 LDB     game_over_scalex  ; load scaling stuff
                 STD     Vec_Text_HW       ; poke it to ram location
                 LDA     game_over_ypos    ; load position
                 LDB     game_over_xpos    ; to D (A,B) register
                 LDU     #game_over_string ; and the address of the string itself
                 JSR     Print_Str_d       ; and draw it
                 JSR     Intensity_5F      ; and do it
                 _ZERO_VECTOR_BEAM         ; back to zero
                 LDA     morph_status      ; look of morphing is complete
                 LBEQ    new_game          ; don't morph anymore
                 JSR     do_one_morph_step_16; does one morph step, changing of vectors
                 _SCALE  (SCALE_FACTOR_VECTOR_MORPH/2)
                 LDD     #(5*VEC_BLOWUP)   ; y=0, X = '5'
                 JSR     Moveto_d          ; and move there
                 LDX     #current_morph_vectorlist ; load the morph vector list to X
                 _SCALE  (SCALE_FACTOR_VECTOR_MORPH) ; scale it correctly
                 JSR     Draw_VLc          ; and draw the vectorlist
                 _ZERO_VECTOR_BEAM         ; back to zero
                 LDD     #LITTLE_TEXT_SIZE ; load score text size
                 STD     Vec_Text_HW       ; poke it to ram location
                 LDD     #-$45*256+(lo(-$50)); load position, to D (A,B) register
                 LDU     #continue_string  ; get address of string
                 JSR     Print_Str_d       ; and draw it
;morph_complete:
                 JSR     Read_Btns         ; get button status
                 CMPA    #$00              ; is a button pressed?
                 BEQ     game_over_loop2   ; no, than stay in game_over_loop2
; here continue...
                 JSR     DP_to_C8
                 direct $C8
                 JSR     reinit_level      ;
                 JSR     continue_level    ; clear the frog variables
                 BRA     restart_game      ;
end_of_end_of_game:
 ;                BRA     new_game          ; start a new game
;***************************************************************************
; subroutines for intermissions
                 INCLUDE "IMISSION.I"
;***************************************************************************
; subroutines for morphing
                 INCLUDE "MORPH.I"
;***************************************************************************
; subroutines for scrolling
                 INCLUDE "SCROLL.I"
;***************************************************************************
game_over_string:
                 DB   "GAME OVER", $80
pause_string:
                 DB   "GAME PAUSED", $80
continue_string:
                 DB   "PRESS BUTTON TO CONTINUE", $80
girl_bonus_text:
                 DB   "GIRL RESCUED +200", $80
fly_bonus_text:
                 DB   "FLY CAPTURED +200", $80
level_complete_text:
                 DB   "LEVEL COMPLETED +500", $80
died:
                 DB   -$20,-$67,"FROGGER DIED!", $80
cause:
                 DB   -$30,-$67,"CAUSE:", $80,0
reached_home:
                 DB   "FROGGER REACHED HOME!", $80
cause_strings:
home_full:
                 DB   "HOME WAS OCCUPIED", $80
wall_jump:
                 DB   "JUMPED AGAINST WALL", $80
car:
                 DB   "OVERRUN BY VEHICLE", $80
out:
                 DB   "MOVED OUT OF BOUNDS", $80
drown:
                 DB   "DROWNED IN RIVER", $80
snake:
                 DB   "BITTEN BY SNAKE", $80
croco:
                 DB   "EATEN BY CROCODILE", $80
mole:
                 DB   "EATEN BY OTTER", $80
time:
                 DB   "NATURAL DEATH", $80
new_life_string:
                 DB   "YOU WERE AWARDED A NEW LIFE!",$80
roll_over_string:
                 DB   "YOU BEAT THE GAME! RESET!",$80
highscore_string:
                 DB   "YOU SET A NEW RECORD!",$80
scroll_text:
                 DB   "HI. "
                 DB   "THIS GAME WAS "
                 DB   "WRITTEN IN MARCH NINETEEN HUNDRED NINETYEIGHT... "
                 DB   "BY MALBAN... "
                 DB   "SOME GREETINGS GO TO..."
                 DB   " ANJEE ..."
                 DB   " FIDPO0 ..."
                 DB   " FILLY0 ..."
                 DB   " FUMOS0 ..."
                 DB   " FUBO0 ..."
                 DB   " AND JAMES. "
                 DB   "... .   .    .     .           "
                 DB   $80
;***************************************************************************
; include vector sprite definitions
                 INCLUDE "ABC.I"
                 INCLUDE "MORPHS.I"
                 INCLUDE "HOMES.I"
                 INCLUDE "FROG.I"
                 INCLUDE "LETTERS.I"
                 INCLUDE "FASTSPRI.I"
;***************************************************************************
weirdos:
                 DW     $FDC3, $FEB6       ; piano
                 DW     $ED8F, $FEB6       ; minestorm
                 DW     $EFFF, $FEDC       ; psychadelic :-), a missread address, but what the heck
                                           ; it sounds weird!!!
                 DW     $FE28, $FD79       ; well, another one of those
                 DW     $FE66, $FEB6       ; video game beep
                 DW     $FEE8, $FEB6       ; organ with echo
weirdos_end:
;***************************************************************************
death_sound:
                 DW     $FEE8,$FEB6
                 DB     30+128,30+128,30,4
                 DB     20+128,20+128,20,6
                 DB     10+128,10+128,10,12
                 DB     0, $80
;***************************************************************************
frog_home_sound:
                 DW     $FE66, $FEB6
                 FCB    128+2,128+28,28-12, 12
                 FCB    128+0,128+26,26-12, 12
                 FCB    128+2,128+31,31-12, 12
                 FCB    128+0,128+30,30-12, 12
                 FCB    128+2,128+33,33-12, 12
                 FCB    128+0,128+31,31-12, 12
                 FCB    2, 12
                 FCB    128+0,128+31,31-12, 12
                 FCB    2, 12
                 FCB    19, $ff            ; $FF is end marker for music
;***************************************************************************
girl_got_sound:
                 DW     $FEE8,$FEB6
                 DB     40+128,40-12+128,40-12-12,4
                 DB     50+128,50-12+128,50-12-12,6
                 DB     60+128,60-12+128,60-12-12,12
                 DB     0, $80
;***************************************************************************
level_done_sound:
                 FDB     $FEE8,$FEB6             ; ADSR and twang address tables, in Vectrex ROM
                 FCB     128+2,128+26,26-12, 12  ;
                 FCB     128+0,128+31,31-12, 12  ;;;;;;;;
                 FCB     128+2,128+31,31-12, 12  ; a 128 means the next byte is a note for the
                 FCB     128+0,128+33,33-12, 12  ; next channel...
                 FCB     128+2,128+35,35-12, 12
                 FCB     128+0,128+31,31-12, 12  ;;;;;;;;
                 FCB     128+2,128+35,35-12, 12
                 FCB     128+0,128+33,33-12, 12
                 FCB     128+2,128+26,26-12, 12
                 FCB     128+0,128+31,31-12, 12  ;;;;;;;;
                 FCB     128+2,128+31,31-12, 12
                 FCB     128+0,128+33,33-12, 12
                 FCB     128+2,128+35,35-12, 12
                 FCB     128+0,128+31,31-12, 12  ;;;;;;;;
                 FCB     2,12
                 FCB     128+0,128+30,30-12, 12
                 FCB     128+2,128+26,26-12, 12
                 FCB     128+0,128+31,31-12, 12  ;;;;;;;;
                 FCB     128+2,128+31,31-12, 12
                 FCB     128+0,128+33,33-12, 12
                 FCB     128+2,128+35,35-12, 12
                 FCB     128+0,128+36,36-12, 12  ;;;;;;;;
                 FCB     128+2,128+35,35-12, 12
                 FCB     128+0,128+33,33-12, 12
                 FCB     128+2,128+31,31-12, 12
                 FCB     128+0,128+30,30-12, 12  ;;;;;;;;
                 FCB     128+2,128+26,26-12, 12
                 FCB     128+0,128+28,28-12, 12
                 FCB     128+2,128+30,30-12, 12
                 FCB     128+0,128+31,31-12, 12  ;;;;;;;;
                 FCB     2, 12
                 FCB     19, $ff           ; $FF is end marker for music
                                           ; (high byte set)
;***************************************************************************
triller1:
                 DW     $FEE8,$FEB6
                 DB     50+128,50-12+128,50-12-12,12
                 DB     0, $80
;***************************************************************************
triller2:
                 DW     $FEE8,$FEB6
                 DB     63+128,63-12+128,63-12-12,12
                 DB     0, $80
;***************************************************************************
frog_jump:
                 DW     $FEE8,$FEB6
                 DB     30+128,30+128,30,02
                 DB     30+12+128,30+12+128,30+12,03
                 DB     0, $80
;***************************************************************************
ta_ta_ta1:
                 DW     $FEE8,$FEB6
                 DB     30+128,30-12+128,30-12-12,8
                 DB     0+128,0+128,0,2
                 DB     32+128,32-12+128,32-12-12,8
                 DB     0+128,0+128,0,2
                 DB     34+128,34-12+128,34-12-12,30
                 DB     0, $80
;***************************************************************************
ta_ta_ta2:
                 DW     $FEE8,$FEB6
                 DB     40+128,40-12+128,40-12-12,8
                 DB     0+128,0+128,0,2
                 DB     42+128,42-12+128,42-12-12,8
                 DB     0+128,0+128,0,2
                 DB     44+128,44-12+128,44-12-12,8
                 DB     0+128,0+128,0,2
                 DB     46+128,46-12+128,46-12-12,30
                 DB     0, $80
;***************************************************************************
; entries following must be copied to vectrex ram...
; copied or initialized
; start of 'my ram'
;***************************************************************************
_copy_start1:
_score_string:
_score_only_string:
                 DB   "SCORE:"
_no_score_string:
                 DB   "000000", $80
_level_string:
                 DB   "LEVEL:"
_no_level_string:
                 DB   "000000", $80
_frogs_string:
                 DB   "FROGS:"
_no_frogs:
                 DB   FROGS_PER_GAME,$80
_string_list_end:
                 DB   0
_home_objects_start:
_home_objects:
_home_entry_1:
HOME_Y_POS       EQU 106
HOME_X_POS       EQU -80
HOME_X_WIDTH     EQU 36
                 DW   0                    ; object
                 DB   HOME_Y_POS           ; y_pos SCALE_FIRST_HOME
                 DB   HOME_X_POS           ; x_pos SCALE_FIRST_HOME
                 DB   1                    ; anim counter
_home_entry_2:
                 DW   0                    ; object
                 DB   HOME_Y_POS           ; y_pos SCALE_IN_HOME
                 DB   HOME_X_POS+1*HOME_X_WIDTH ; x_pos SCALE_IN_HOME
                 DB   0                    ; anim counter
_home_entry_3:
                 DW   0                    ; object
                 DB   HOME_Y_POS           ; y_pos SCALE_IN_HOME
                 DB   HOME_X_POS+2*HOME_X_WIDTH ; x_pos SCALE_IN_HOME
                 DB   0                    ; anim counter
_home_entry_4:
                 DW   0                    ; object
                 DB   HOME_Y_POS           ; y_pos SCALE_IN_HOME
                 DB   HOME_X_POS+3*HOME_X_WIDTH ; x_pos SCALE_IN_HOME
                 DB   0                    ; anim counter
_home_entry_5:
                 DW   0                    ; object
                 DB   HOME_Y_POS           ; y_pos SCALE_IN_HOME
                 DB   HOME_X_POS+4*HOME_X_WIDTH ; x_pos SCALE_IN_HOME
;                 DB   0                    ; anim counter
_home_end:
;                 DW   -1                   ; object
_home_objects_end:
_copy_end1:
;***************************************************************************
_copy_start2     EQU _copy_end1
;one object:
;                DW   0 ; object
;                DB   0 ; y_pos
;                DB   0 ; x_pos
;                DB   0 ; anim counter

_object_list_start              EQU _copy_start2
_object_list                    EQU _copy_start2
_object_list_end                EQU _copy_start2+ 5*30 ;30 sprites
_copy_end2                      EQU _object_list_end + 2 ; + 2 that last object is allways zero
;***************************************************************************
_copy_start3                    EQU _copy_end2
_band_list                      EQU _copy_start3
_band_list_start                EQU _copy_start3
_band_list_end                  EQU _copy_start3 + 12*(8*2)
_copy_end3                      EQU _band_list_end
;***************************************************************************
_copy_start4:
_yankee:
                INCLUDE "YANKEE.I"
_copy_end4:
;***************************************************************************
; stupid assembler, these defines must be made after the above
; labels

LEVEL_DATA_LENGTH               EQU ((level2_data-level1_data)) ; length of one level in byte

; following are string offsets for the different deaths
DIE_HOME_FULL                   EQU (lo(home_full-cause_strings))
DIE_WALL_JUMP                   EQU (lo(wall_jump-cause_strings))
DIE_CAR                         EQU (lo(car-cause_strings))
DIE_OUT                         EQU (lo(out-cause_strings))
DIE_DROWN                       EQU (lo(drown-cause_strings))
DIE_SNAKE                       EQU (lo(snake-cause_strings))
DIE_CROCO                       EQU (lo(croco-cause_strings))
DIE_HOME_CROCO                  EQU (lo(croco-cause_strings))
DIE_MOLE                        EQU (lo(mole-cause_strings))
DIE_TIME                        EQU (lo(time-cause_strings))

; these are the addresses used in the game
; addresses which are copied have an underscore
; addresses which are used - not -
; first the scoring strings...
copy_start1                     EQU     (user_ram_start+(user_ram_end-user_ram_start))
; start of string
score_string                    EQU     (copy_start1)
; score string
score_only_string               EQU     (copy_start1+(_score_only_string-_copy_start1))
; score BCD number
no_score_string                 EQU     (copy_start1+(_no_score_string-_copy_start1))
; level string
level_string                    EQU     (copy_start1+(_level_string-_copy_start1))
; level BCD number
no_level_string                 EQU     (copy_start1+(_no_level_string-_copy_start1))
; frogs string
frogs_string                    EQU     (copy_start1+(_frogs_string-_copy_start1))
; no_frogs is a display ascii AND the counter for frogs per game
no_frogs                        EQU     (copy_start1+(_no_frogs-_copy_start1))
; addresses of home objects, actually I think not used as standalones
; allways calculates from the first...
home_objects                    EQU     (copy_start1+(_home_objects-_copy_start1))
home_entry_1                    EQU     home_objects
home_entry_2                    EQU     home_objects+5
home_entry_3                    EQU     home_objects+10
home_entry_4                    EQU     home_objects+15
home_entry_5                    EQU     home_objects+20
home_end                        EQU     (copy_start1+(_home_end-_copy_start1))

; here the music resides, dues to the roms method of playing
; we need a copy in ram for different envelopes...
copy_start4                     EQU     (copy_start1+(_copy_end1-_copy_start1))
yankee                          EQU     (copy_start4+(_yankee-_copy_start4))
copy_end4                       EQU     (copy_start4+(_copy_end4-_copy_start4))

; here the object list address resides...
copy_start2                     EQU     (copy_start4+(_copy_end4-_copy_start4))
object_list                     EQU     (copy_start2+(_object_list-_copy_start2))
object_list_end                 EQU     (copy_start2+(_object_list_end-_copy_start2))
copy_end2                       EQU     (copy_start2+(_copy_end2-_copy_start2))

; and the bandlist
copy_start3                     EQU     (copy_start2+(_copy_end2-_copy_start2))
band_list                       EQU     (copy_start3+(_band_list-_copy_start3))
copy_end3                       EQU     (copy_start3+(_copy_end3-_copy_start3))
t_list                          EQU     (copy_end3)  ; start of dive object list
t_list_end                      EQU     (copy_end3+2*6+2) ; note maximum of 6 dives per level

; morphing uses ram occupied by the game, therefor only be used
; as start, end or in between sequences
current_morph_vectorlist_org    EQU     (copy_start2)
current_morph_vectorlist        EQU     (current_morph_vectorlist_org+2*MAX_VECTOR_MORPH+1)
current_morph_vector_diffs      EQU     (current_morph_vectorlist+2*MAX_VECTOR_MORPH+1)
end_of_my_ram                   EQU      current_morph_vector_diffs+2*MAX_VECTOR_MORPH
; end by current_morph_vector_diffs + 2*MAX_VECTOR_MORPH
;***************************************************************************
                 END entry_point
;***************************************************************************
