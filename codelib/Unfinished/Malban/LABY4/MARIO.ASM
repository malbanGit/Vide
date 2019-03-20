; magic - slow, fast, dizzy
; magic map,
; light, darkness
; traps -> forget map
; ceiling colapses
; traps to next level
; stalagtides, stalagnites
; treasure
; throwable (3d) items
; temple
; teleport
; secret doors
; level teleport
; monster information screen
; strategic, or action battle
; monster not passable
; monster passable
; ghost monster (go thru wall)
; levitate, go thru wall...
; labyrinth that is open to all sides (wrapping)
; torches, candles, lamp

                INCLUDE "INCLUDE/VECTREX.I" ; vectrex function includes
                INCLUDE "INCLUDE/MACROS/BEAM_MAC.I" ; vectrex function includes
                INCLUDE "INCLUDE/MACROS/MOVE_MAC.I"
                INCLUDE "INCLUDE/MACROS/DRAW_MAC.I"
                INCLUDE "INCLUDE/MACROS/MULT_MAC.I"
                INCLUDE "PRG/TILE_MAC.I"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Size definitions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
NO_MONSTER EQU (-1)             ; default value for no monster displayed
                                ; in maze
FAR_AWAY EQU (lo(50))           ; a 'max' value for distance of monsters
                                ; used as init-value in calculation which
                                ; monster is nearest - and therefor visible

MAZE_SIZE_ALL       EQU 256     ; now, since 16 times 16, but will be bits 2*16
                                ; (if done in BIT not BYTE)
MAX_MONSTER         EQU 2       ; number of monters active per maze

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Type defintions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ANIMATION           EQU 0       ;
MORPHING            EQU 1       ; not done yet

NOT_MOVING          EQU 0       ;
PATROLING_X         EQU 1       ;
PATROLING_Y         EQU 2       ; following not done yet
PATROLING_LEFT      EQU 3
PATROLING_RIGHT     EQU 4
INTELLIGENT_SEEKING EQU 5
INTELLIGENT_FLEEING EQU 6

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Structure definitions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; current active monsters
; these are initialized to RAM when level is loaded
;             DB 0,0 ; 0 x,y 0,0 denotes NO monster
;             DB 0,0 ; 2 x,y offset
;             DB 0   ; 4 movement type
;             DW 0   ; 5 monster definition place (from level)
;             DB 0   ; 7 animation counter
;             DW 0   ; 8 current graphic pointer
;             DB 0   ; 10 current graphic counter
;             DB 0   ; 11 heading
C_MONSTER_SIZE EQU 12 ; size of monster struct in bytes
C_MONSTER_X EQU 0
C_MONSTER_Y EQU 1
C_MONSTER_POSITION EQU 0
C_MONSTER_OFFSET EQU 2
C_MONSTER_X_OFFSET EQU 2
C_MONSTER_Y_OFFSET EQU 3
C_MONSTER_MOVEMENT_TYPE EQU 4
C_MONSTER_DEFINITION EQU 5
C_MONSTER_ANIM_COUNTER EQU 7
C_MONSTER_GRAPHIC EQU 8
C_MONSTER_GRAPHIC_COUNTER EQU 10
C_MONSTER_HEADING EQU 11

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; monster information
; is placed in ROM, see data section
;          DB 3, 5               ; 0 x, y position in Labyrinth
;          DB 0, 0               ; 2 x, y offset position in field
;          DB NOT_MOVING         ; 4 moving type
;          DB 0                  ; 5 moving type speed
;          DB 0,0,0,0            ; 6 moving type information (not used here)
;          DW goblin_monster     ; 10 monster information structure
M_MONSTER_POSITION EQU 0
M_MONSTER_OFFSET EQU 2
M_MONSTER_MOVEMENT_TYPE EQU 4
M_MONSTER_MOVEMENT_SPEED EQU 5
M_MONSTER_FROM_X EQU 6
M_MONSTER_FROM_Y EQU 7
M_MONSTER_TO_X EQU 8
M_MONSTER_TO_Y EQU 9
M_MONSTER_STRUCT EQU 10

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; animation structure for 'objects'
; is places in ROM, see data section
;                DB 5            ; 0 anim delay value
;                DB ANIMATION    ; 1 type of animation ANIMATION or MORPHING
;                DW goblin_pic1  ; 2 vector VList
;                DW goblin_pic2  ; ... vector VList
;                DW 0            ; end of list
ANIMATION_DELAY EQU 0
ANIMATION_TYPE EQU 1
ANIMATION_GRAPHIC_START EQU 2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;monster definition
; is placed in ROM, see data section
;          DB 0                  ; 0 special information TORCH_CARRYING, TREASURE TYPE...
;                                ; baddie, goodie
;          DW goblin_animation   ; 1 graphic definition
MONSTER_TYPE EQU 0
MONSTER_ANIM_STRUCT EQU 1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                 BSS
                 ORG $c880       ; well start of our ram space
                 INCLUDE "INCLUDE/CLIP_VAR.I"
                 INCLUDE "INCLUDE/YM_VAR.I"
                 INCLUDE "INCLUDE/DIGI_VAR.I"
                 INCLUDE "PRG/MAZE_VAR.I"
                 INCLUDE "PRG/IN_VAR.I"

;********************************************************************
; variables used in map displaying
;********************************************************************
; these are redefines from clip_var.i!
; -> must be AFER the above include,
; otherwise the assembler doesn't work correctly
; these are used in the MAP routines, therefor they'll never
; collide with MAZE information
_x               EQU y0
_y               EQU x0
_xo              EQU y1
_yo              EQU x1
mx               EQU x2
my               EQU y2
map_offset:      DB 0
map_worker:      DW 0
map_address:     DW 0
map_helper:      DW 0
map_bits: DS MAZE_SIZE*2 ; 16 Words

;********************************************************************
look_direction:  DB 0 ; direction the player is facing
;********************************************************************
; position of player in maze, in display coordinates
; used in 'input' 'draw_maze'...
; therefor we only have 'y' coordinates...
move_offset_y_big:
move_offset_y_hi: DB 0
move_offset_y:   DB 0
;********************************************************************
; the translate_position() subroutines
; sets the following variables
; these are the postion in the maze in maze coordinates
; not in 'display'-coordinates
pos:
pos_y:           DB 0
pos_x:           DB 0
; offset in that current position
pos_offset:
pos_offset_y:    DB 0
pos_offset_x:    DB 0
;********************************************************************
; current 'level' pointer
current_maze:    DW 0

; all 'active' monsters in that level
current_monster_list:
                 DS C_MONSTER_SIZE * MAX_MONSTER

; only one monster is seen at any given time
; this monsters attributes will be set here
view_monster:
             DB 0,0   ; 0 x,y, in view coordinates (x max 2), y direction dependent
             DB 0,0,0 ; 2 x,y_hi,y_lo offset
             DW 0     ; 5 pointer to above list, only one monster/item is viewable at a time
             DB 0     ; 7 near to player
             DB 0     ; 8 movement in player axis
             DB 0     ; 9 movement in player axis temp

; these definitions MUST be placed in the source AFTER the
; above!
V_MONSTER_X EQU ((view_monster) + 0)
V_MONSTER_Y EQU ((view_monster) + 1)
V_MONSTER_POSITION EQU ((view_monster) + 0)
V_MONSTER_OFFSET EQU ((view_monster) + 2)
V_MONSTER_OFFSET_X EQU ((view_monster) + 2)
V_MONSTER_OFFSET_Y EQU ((view_monster) + 3)
V_MONSTER_POINTER EQU ((view_monster) + 5)
V_MONSTER_NEARNESS EQU ((view_monster) + 7)
V_MONSTER_MOVEMENT_AXIS EQU ((view_monster) + 8)
V_MONSTER_MOVEMENT_AXIS_TEMP EQU ((view_monster) + 9)

; for each checked monster the axis is calculated before knowing
; if the monster is the one that is being shown
; so -> we have to 'temp' the value :-(

; V_MONSTER_MOVEMENT_AXIS
; this entry is some cheat for a better/easier display for moving
; monster is the labyrinth
; if the movement axis of the monster is the same as the player heading
; than the (view) x-koordinate (only in clipped right/left view) MUST
; be set accordingly to the current offset of the monster,
; otherwise the monster 'jumps' from maze cell to maze cell -> no
; smooth moving. The clipped vector lists 'moves' in a diagonal along
; the maze edges
;
; on the other hand, if the axis is orthogonal to the player heading...
; the vector list should be clipped as if the offset was '-STEPS', since
; otherwise the vector would be clipped in 'empty' space, according
; to the (now y) offset. The clipping would be done along the diagonal
; of the maze cells. This looks stupid and wrong. The player
; can 'sorta' watch till the outer edge of the maze cell -> therefor the
; monster should also be seen to the outer edge of the maze cell.
;
; I couldn't think of hand about an easy way to implement these to different
; display-types... so I chose for now, to do just a hack and
; have a switch, which kind of display is the current active one...

; only one item is seen at any given time
; this items attributes will be set here
view_item:
             DB 0,0 ; x,y in view coordinates (x max 2), y direction dependent
             DB 0,0 ; x,y offset
             DW 0   ; pointer, only one item/monster is viewable at a time

                CODE
;***************************************************************************
                ORG     0
; start of vectrex memory with cartridge name...
                DB      "g GCE 2000", $80 ; 'g' is copyright sign
                DW      music7            ; music from the rom
                DB      $F8, $50, $20, -$56; hight, width, rel y, rel x (from 0,0)
game_name:
                DB      "VECTREX ROUGE", $80; some game information, ending with $80
                DB      $F8, $50, $5, -$6d; hight, width, rel y, rel x (from 0,0)
                DB      "MALBAN", $80; some game information, ending with $80
                DB      0                 ; end of game header
;***************************************************************************
; here the cartridge program starts off
                direct  $d0                ; pretty for optimizing to use a makro :-)
entry_point:
                JMP     new_game
;***************************************************************************
new_game:
                JSR     init_vars          ; initialize game variables
                JSR     init_screen        ; startup screen

                ldu     #SONG_DATA
                JSR     init_ym_sound

                LDX     #maze1
                JSR     init_level

; conceptional thoughts
; two main routines, they do exactly the same, apart from
; -one is playing an ym file
; -the other plays a digital sample

main_loop_1:
                JSR     Read_Btns          ;
                JSR     Wait_Recal
digit_is_not_playing:
                JSR     handle_input
                TST     digit_is_playing
                LBNE    digi_is_playing
                LDA     Vec_Buttons
                CMPA    #0                 ; is a button pressed?
                LBNE    draw_map
                JSR     translate_position
                JSR     update_map
                JSR     update_monsters
                JSR     draw_maze          ; also draws monster if one is viewable

                JSR     do_ym_sound
                BRA     main_loop_1        ; go back to main loop
main_loop_2:
                JSR     Read_Btns
                JSR     wait_recal_digit
                TST     digit_is_playing
                BEQ     digit_is_not_playing
                JSR     handle_input_digit
digi_is_playing:
                LDA     Vec_Buttons
                CMPA    #0                 ; is a button pressed?
                LBNE    draw_map
                JSR     translate_position
                JSR     update_map
                JSR     update_monsters
                JSR     draw_maze_digit    ; also draws monster if one is viewable

                BRA     main_loop_2        ; go back to main loop
;***************************************************************************
my_move_to_d:
                MOVE_TO_D
                RTS
;***************************************************************************
update_monsters:
; update all monsters, according to their behavour
; the neareast visible, will be set to be visible to the
; player!
; animation will be set accordingly
                ; default is no view monster
                LDD    #NO_MONSTER
                STD    V_MONSTER_POSITION
                LDA    #FAR_AWAY
                STD    V_MONSTER_NEARNESS  ; first near is very big

                ; go thru all monsters
                LDX     #current_monster_list
next_monster:
                LDD     C_MONSTER_POSITION,X ; zero position denotes no monsters left
                LBEQ    monster_update_all_done ; jump outa here than
                LDB     C_MONSTER_MOVEMENT_TYPE,X ; movement type
                BEQ     not_moving_monster ; NOT_MOVING = 0
; todo
                CMPB    #PATROLING_X       ; only implemented moving type
                BNE     not_x_patroling
; X Patroling
                ; temporary calculate the movement axis
                ; we don't know yet if this monster is the one
                ; that is being shown :-(
                LDA     look_direction     ; looking west?
                CMPA    #WEST              ; checking for same or
                BEQ     in_x_axis          ; orthogonal axis
                CMPA    #EAST              ; x == WEST and EAST
                BNE     not_in_x_axis      ; no? than not same axis
in_x_axis:
                LDA     #1                 ; something different than 0
                STA     V_MONSTER_MOVEMENT_AXIS_TEMP
                BRA     x_axis_done        ; axis stuff done
not_in_x_axis:
                CLR     V_MONSTER_MOVEMENT_AXIS_TEMP ; not same axis -> == 0
x_axis_done:
                LDU     C_MONSTER_DEFINITION,X ; get monster definition pointer
                LDA     M_MONSTER_MOVEMENT_SPEED,U ; get the speed if it
                LDB     C_MONSTER_HEADING,X; ... and its heading
                BPL     xpatrol_positive   ; going positive (east)? yep? -> jump
                ; negative heading
                NEGA                       ; negate speed for heading west

                ADDA    C_MONSTER_X_OFFSET,X ; calculate new X offset
                CMPA    #-(STEPS)          ; moving to next maze cell?
                BGT     no_negative_overflow ; no -> jump
                ADDA    #(STEPS-1)         ; offset to beginning of next cell
                ADDA    #(STEPS-1)
                LDB     C_MONSTER_X, X     ; and move to next cell
                DECB                       ; heading west -> decrease maze pointer
                CMPB    M_MONSTER_FROM_X,U ; patroling done in that direction?
                BGE     no_negative_position_overflow ; no -> jump
                NEG     C_MONSTER_HEADING,X; otherwise... reverse patroling direction (heading)
                BRA     negative_turning   ; and done with turning

no_negative_position_overflow:             ; save new x position to monster position
                STB     C_MONSTER_X, X
no_negative_overflow:
                STA     C_MONSTER_X_OFFSET,X; and new offset also
negative_turning:
                BRA     moving_done        ; done with moving this monster
xpatrol_positive:
                ; in a speed to add to offset
                ADDA    C_MONSTER_X_OFFSET,X ; calculate new X offset
                CMPA    #STEPS             ; moving to next maze cell?
                BLT     no_positive_overflow ; no -> jump
                SUBA    #(STEPS-1)         ; offset to beginning of next cell
                SUBA    #(STEPS-1)
                LDB     C_MONSTER_X, X     ; and move to next cell
                INCB                       ; heading east -> increase maze pointer
                CMPB    M_MONSTER_TO_X,U   ; patroling done in that direction?
                BLE     no_positive_position_overflow ; no -> jump
                NEG     C_MONSTER_HEADING,X; otherwise... reverse patroling direction (heading)
                BRA     positive_turning   ; and done with turning

no_positive_position_overflow:             ; save new x position to monster position
                STB     C_MONSTER_X, X
no_positive_overflow:
                STA     C_MONSTER_X_OFFSET,X; and new offset also
positive_turning:
                BRA     moving_done        ; done with moving this monster

not_x_patroling:
                ; moving not done yet
                BRA     moving_done        ; done with all moving... (todo)
not_moving_monster:
moving_done:

                ; look if monster is in display view
                ; that is only space allowed between player and monster
                LDA     look_direction     ; looking west?
                CMPA    #WEST
                BNE     test_east1         ; no->jump

                LDB     C_MONSTER_X,X      ; x position of monster
                CMPB    pos_x              ; is it in front of us?
                LBGE    this_monster_done  ; no->jump
                LDA     C_MONSTER_Y,X      ; y position of monster
                DECA                       ; is it -1, 0 , 1 from us?
                CMPA    pos_y
                LBGT    this_monster_done  ; no, further away -> jump
                INCA
                INCA
                CMPA    pos_y
                LBLT    this_monster_done  ; no, further away -> jump

                ; monster is in front and in our view corridor
                ; but is it nearer than last found monster?
                LDB     pos_x
                SUBB    C_MONSTER_X,X
                CMPB    V_MONSTER_NEARNESS
                LBGE    this_monster_done  ; no, not nearer -> jump

                ; now init view of monster
                ; translate its position to view position
                ; and store it
                LDU     #view_monster      ; view monster pointer
                SUBA    pos_y              ;
                STA     ,U+                ; view x pos

                LDB     C_MONSTER_X,X      ; x position of monster
                NEGB
                ADDB    #(MAZE_SIZE-1)
                STB     ,U+                ; view y pos

                LDD     C_MONSTER_OFFSET,X ; x, y offset of monster
                EXG     A,B
                NEGA
                STA     ,U+                ; view x offset
                SEX
                STD     ,U++               ; view y offset
                STX     ,U++               ; current structure information

                LDB     pos_x
                SUBB    C_MONSTER_X,X
                STB     ,U                 ; near to player

                LDA     V_MONSTER_MOVEMENT_AXIS_TEMP
                STA     V_MONSTER_MOVEMENT_AXIS

                JMP     this_monster_done
test_east1:
                CMPA    #EAST              ; facing east?
                BNE     test_south1        ; no - jump

                LDB     C_MONSTER_X,X      ; x position of monster
                CMPB    pos_x              ; if monster behind or 'on' us
                LBLE    this_monster_done  ; jump
                LDA     C_MONSTER_Y,X      ; y position of monster
                INCA                       ; is in up, here, or down space
                CMPA    pos_y              ; of vision?
                LBLT    this_monster_done  ; no goto next monster
                DECA
                DECA
                CMPA    pos_y
                LBGT    this_monster_done  ; no goto next monster

                ; now init view of monster
                LDB     C_MONSTER_X,X      ; get monster position
                SUBB    pos_x              ; and build abs 'difference'
                CMPB    V_MONSTER_NEARNESS ; if 'nearer' accept new monster
                LBGE    this_monster_done  ; otherwise go on looking

                ; now init view of monster
                ; translate its position to view position
                ; and store it
                LDB     C_MONSTER_X,X      ; x position of monster
                LDU     #view_monster
                NEGA
                ADDA    pos_y
                STA     ,U+                ; view x pos
                STB     ,U+                ; view y pos

                LDD     C_MONSTER_OFFSET,X ; x, y offset of monster
                EXG     A,B
                STA     ,U+                ; view x offset
                NEGB
                SEX
                STD     ,U++               ; view y offset
                STX     ,U++

                LDB     pos_x
                SUBB    C_MONSTER_X,X
                STB     ,U                 ; near to player

                LDA     V_MONSTER_MOVEMENT_AXIS_TEMP
                STA     V_MONSTER_MOVEMENT_AXIS

                JMP     this_monster_done
test_south1:
                CMPA     #SOUTH            ; facing south?
                BNE      test_north1       ; na->jump

                LDB      C_MONSTER_Y,X     ; y position of monster
                CMPB     pos_y             ; is it behind us?
                LBLE     this_monster_done ; yep->jump

                ; look if monster is in display view
                ; that is only space allowed between player and monster
                LDA      C_MONSTER_X,X     ; x position of monster
                DECA                       ; checking for +-1 view corridor
                CMPA    pos_x              ; (-1)
                BGT     this_monster_done  ; not it corridor->jump
                INCA
                INCA                       ; (+1)
                CMPA    pos_x
                BLT     this_monster_done  ; not it corridor->jump

                ; now init view of monster
                LDB     C_MONSTER_Y,X      ; get monster position
                SUBB    pos_y              ; and build abs 'difference'
                CMPB    V_MONSTER_NEARNESS ; if 'nearer' accept new monster
                BGE     this_monster_done  ; otherwise go on looking

                ; now init view of monster
                ; translate its position to view position
                ; and store it
                LDB     C_MONSTER_Y,X      ; y position of monster
                LDU     #view_monster
                SUBA    pos_x
                STA     ,U+                ; view x pos
                STB     ,U+                ; view y pos

                LDD     C_MONSTER_OFFSET,X ; x, y offset of monster
                NEGA
                STA     ,U+                ; view x offset
                SEX
                STD     ,U++               ; view y offset
                STX     ,U++

                LDB     C_MONSTER_Y,X
                SUBB    pos_y
                STB     ,U                 ; near to player

                LDA     V_MONSTER_MOVEMENT_AXIS_TEMP
                STA     V_MONSTER_MOVEMENT_AXIS

                BRA     this_monster_done
test_north1:
                LDB      C_MONSTER_Y,X     ; y position of monster
                CMPB     pos_y             ; is monster behind us?
                BGE      this_monster_done ; yep->jump

                ; look if monster is in display view
                ; that is only space allowed between player and monster
                LDA      C_MONSTER_X,X     ; x position of monster
                INCA                       ; checking for +-1 view corridor
                CMPA    pos_x              ; (+1)
                BLT     this_monster_done  ; not it corridor->jump
                DECA
                DECA                       ; (-1)
                CMPA    pos_x
                BGT     this_monster_done  ; not it corridor->jump

                LDB     pos_y              ; get monster position
                SUBB    C_MONSTER_Y,X      ; and build abs 'difference'
                CMPB    V_MONSTER_NEARNESS ; if 'nearer' accept new monster
                BGE     this_monster_done  ; otherwise go on looking
                LDB     C_MONSTER_Y,X      ; y position of monster

                ; now init view of monster
                ; translate its position to view position
                ; and store it
                LDU     #view_monster
                NEGA
                ADDA    pos_x
                STA     ,U+                ; view x pos

                NEGB
                ADDB    #(MAZE_SIZE-1)
                STB     ,U+                ; view y pos

                LDD     C_MONSTER_OFFSET,X ; x, y offset of monster
                STA     ,U+                ; view x offset
                NEGB
                SEX
                STD     ,U++               ; view y offset
                STX     ,U++

                LDB     pos_y
                SUBB    C_MONSTER_Y,X
                STB     ,U                 ; near to player

                LDA     V_MONSTER_MOVEMENT_AXIS_TEMP
                STA     V_MONSTER_MOVEMENT_AXIS

this_monster_done:
                LEAX    C_MONSTER_SIZE,X
                BRA     next_monster
monster_update_all_done:

;;;;;;;;;;;;;;
                ; test whether there is a current display monster
                LDD     V_MONSTER_POSITION
                CMPD    #NO_MONSTER
                BEQ     update_all_done

                ; yes, there is
                ; check what type of 'visual monster'
                LDX     V_MONSTER_POINTER    ; get pointer to maze monster
                LDU     C_MONSTER_DEFINITION,X ; get maze monster definition
                LDU     M_MONSTER_STRUCT,U   ; get monster structure
                LDU     MONSTER_ANIM_STRUCT,U; get animation struct
                LDA     ANIMATION_TYPE,U     ; get type of animtion
                CMPA    #ANIMATION           ; is type animation?
                BNE     no_animation         ; no - jump

                ; in U now pointer to animation struct
                ; in X now pointer to current monster (not view monster)
                DEC     C_MONSTER_ANIM_COUNTER,X ; decrease animation delay counter
                BNE     no_animation_change; if not zero... nothing changes->jump

                LDA     ANIMATION_DELAY ,U ; get animation delay value
                STA     C_MONSTER_ANIM_COUNTER,X ; an store it as new delay

                INC     C_MONSTER_GRAPHIC_COUNTER,X ; increase
                LDA     C_MONSTER_GRAPHIC_COUNTER,X ; and load current graphic index
                INCA                       ; increase one, since we are intersted
                                           ; in the next vector list not the current
                ASLA                       ; double it, since it is a 'word pointer'


                LDD    A,U                 ; ... if not last... (last is filled with 0,0)
                BNE    not_last            ; not last->jump
                CLR    C_MONSTER_GRAPHIC_COUNTER,X ; otherwise reset index
                LDD    ANIMATION_GRAPHIC_START,U ; and use first graphic
not_last:
                STD    C_MONSTER_GRAPHIC,X ; store graphic pointer as current
                BRA    animation_done
no_animation_change:
no_animation:
animation_done:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
update_all_done:
                RTS
;***************************************************************************
                direct  $d0             ; following code uses d0
;***************************************************************************
draw_map:
                JSR     Read_Btns          ; get button status once, since only
                CMPA    #$00               ; is a button pressed?
                BNE     draw_map

                ; center map on player
                LDD     pos
                CMPA    #4
                BLT     y_should_be_zero
                SUBA    #4
                STA     _yo
                CMPA    #MAZE_Y-8
                BLT     y_calc_done
                LDA     #MAZE_Y-8
                STA     _yo
                BRA     y_calc_done
y_should_be_zero:
                CLR     _yo
y_calc_done:
                CMPB    #4
                BLT     x_should_be_zero
                SUBB    #4
                STB     _xo
                CMPB    #MAZE_X-8
                BLT     x_calc_done
                LDB     #MAZE_X-8
                STB     _xo
                BRA     x_calc_done
x_should_be_zero:
                CLR     _xo
x_calc_done:

map_main_loop:
                JSR     do_ym_sound
                JSR     Wait_Recal        ; sets dp to d0, and pos at 0, 0
                JSR     Intensity_7F
                JSR     Joy_Digital       ; read joystick positions
                LDA     Vec_Joy_1_Y       ; load joystick 1 position Y to A
                BEQ     y_done
                BPL     negative_change
                LDA     _yo
                CMPA    #MAZE_Y-8
                BEQ     y_done
                INC     _yo
                BRA     y_done
negative_change:
                LDA     _yo
                BEQ     y_done
                DEC     _yo
y_done:
                LDA     Vec_Joy_1_X       ; load joystick 1 position Y to A
                BEQ     x_done
                BMI     negative_change_x
                LDA     _xo
                CMPA    #MAZE_X-8
                BEQ     x_done
                INC     _xo
                BRA     x_done
negative_change_x:
                LDA     _xo
                BEQ     x_done
                DEC     _xo
x_done:
                LDA     _yo
                LDB     #MAZE_X
                MUL
                STD     map_offset
                LDB     _xo
                CLRA
                ADDD    map_offset
                STD     map_offset

                LDX     #map_bits
                LDB     _yo
                CLRA
                LSLB
                LEAX    D,X     ; address of current check
                STX     map_address
                LDD     ,X
                STD     map_worker
                LDB     _xo
                BEQ     no_adjust
adjust_further:
                PSHS    B
                LDD     map_worker
                MY_LSR_D
                STD     map_worker
                PULS    B
                DECB
                BNE     adjust_further
no_adjust:
                LDA     #100
                STA     VIA_t1_cnt_lo     ; move to time 1 lo, this means scaling
                LDA     #120
                LDB     #-120
                STD     map_helper
                MOVE_TO_D
                ;JSR     Moveto_d

                LDA     #20
                STA     VIA_t1_cnt_lo     ; move to time 1 lo, this means scaling

                LDX     map_bits
                LDU     #maze1
                LDD     map_offset
                LEAU    D,U
                CLR     _y
                LDA     _yo
                STA     my
draw_next_line:
                CLR     _x
                LDA     _xo
                STA     mx
draw_next_tile:
                LDD     map_worker
                PSHS    D
                MY_LSR_D
                STD     map_worker
                PULS    D
                LDA     #' '
                LSRB
                BCC     map_unkown

                LDB     _x
                LDA     B, U
map_unkown:
                ;jsr     DRAW_TILE_A
                DRAW_TILE_A
                INC     _x
                INC     mx
                LDB     _x
                CMPB    #8;MAZE_X
                BNE     draw_next_tile
                LEAU    MAZE_X, U
                INC     _y
                LDB     _y
                CMPB    #8;MAZE_Y
                BEQ     maze_done
                _ZERO_VECTOR_BEAM
                LDA     #100
                STA     VIA_t1_cnt_lo     ; move to time 1 lo, this means scaling
                LDD     map_helper
                SUBA    #27
                STD     map_helper
                ;JSR     Moveto_d
                MOVE_TO_D
                LDA     #20
                STA     VIA_t1_cnt_lo     ; move to time 1 lo, this means scaling
                INC     my

                LDX     map_address
                LEAX    2,X
                STX     map_address
                LDD     ,X
                STD     map_worker
                LDB     _xo
                BEQ     no_adjust_2
adjust_further_2:
                PSHS    B
                LDD     map_worker
                MY_LSR_D
                STD     map_worker
                PULS    B
                DECB
                BNE     adjust_further_2
no_adjust_2:
                BRA     draw_next_line
maze_done:
                JSR     Read_Btns          ; get button status once, since only
                CMPA    #$00               ; is a button pressed?
                BEQ     map_main_loop     ; go back to main loop
                BRA     main_loop_1
;***************************************************************************
update_map:
                LDA     pos_y
                LDX     #map_bits
                ASLA
                LEAX    A,X
                CLRA
                LDB     pos_x
                STB     map_helper
                LDB     #7              ; 0111 bits
sub_u:
                DEC     map_helper
                BEQ     shift_done
                MY_LSL_D
                BRA     sub_u
shift_done:
                TFR     D,U
                ORA      ,X
                ORB     1,X
                STD      ,X
                TFR     U,D
                ORA      -2,X
                ORB     -1,X
                STD      -2,X
                TFR     U,D
                ORA      2,X
                ORB     3,X
                STD      2,X
                TFR     U,D

                RTS
;***************************************************************************
display_turn:
display_turn_left:
                RTS
display_turn_right:
                RTS
;***************************************************************************
init_turn:
init_turn_left:
                JSR     translate_position
                INC     look_direction
                INC     look_direction
                LDA     look_direction
                CMPA    #8
                BNE     init_turn_finished_left
                CLR     look_direction
                CLRA
init_turn_finished_left:
play_samples_for_turn:

                CMPA     #WEST
                BNE      test_next1
                JSR      init_looking_west
                LDX      #west_sample_struct
                BRA      play_it
test_next1:
                CMPA     #EAST
                BNE      test_next2
                JSR      init_looking_east

                LDX      #east_sample_struct
                BRA      play_it
test_next2:
                CMPA     #SOUTH
                BNE      test_next3
                JSR      init_looking_south
                LDX      #south_sample_struct
                BRA      play_it
test_next3:
                JSR      init_looking_north
                LDX      #north_sample_struct
play_it:
                JSR     init_digit_sound
                RTS

;***************************************************************************
init_turn_right:
                JSR     translate_position
                DEC     look_direction
                DEC     look_direction
                LDA     look_direction
                CMPA    #-2
                BNE     init_turn_finished_right
                LDA     #EAST
                STA     look_direction
init_turn_finished_right:
                BRA     play_samples_for_turn
;***************************************************************************
; translates maze view position to player (pos) position
translate_position:
                LDA     look_direction
                CMPA    #SOUTH
                BEQ     translate_south
                CMPA    #EAST
                BEQ     translate_east
                CMPA    #NORTH
                BEQ     translate_north
translate_west:
                LDA     #(MAZE_SIZE-1)
                SUBA    maze_draw_y
                STA     pos_x
                LDB     move_offset_y
                NEGB
                STB     pos_offset_x
                RTS
translate_north:
                LDA     #(MAZE_SIZE-1)
                SUBA    maze_draw_y
                STA     pos_y
                LDB     move_offset_y
                NEGB
                STB     pos_offset_y
                RTS
translate_south:
                LDA     maze_draw_y
                STA     pos_y
                LDB     move_offset_y
                STB     pos_offset_y
                RTS
translate_east:
                LDA     maze_draw_y
                STA     pos_x
                LDB     move_offset_y
                STB     pos_offset_x
                RTS
;***************************************************************************
; this routine initializes the game variables
; nothing is expected and nothing is returned
; leaves DP to C8
init_vars:
                _DP_TO_C8
                LDA    #1                ; these set up the joystick
                STA    Vec_Joy_Mux_1_X   ; enquiries
                LDA    #3                ; allowing only all directions for
                STA    Vec_Joy_Mux_1_Y   ; for joystick one
                LDA    #0                ; this setting up saves a few hundred
                STA    Vec_Joy_Mux_2_X   ; cycles
                STA    Vec_Joy_Mux_2_Y   ; don't miss it, if you don't need the
                                         ; second joystick!
                CLRA
                LDX    #$c880
clear_loop:
                STA    ,X+
                CMPX   #$cbe0
                BNE    clear_loop

                CLR    digit_is_playing

                JSR    Wait_Recal        ; sets dp to d0, and pos at 0, 0
                direct $d0             ; pretty for optimizing to use a makro :-)
                JSR    Read_Btns         ;
;                JSR    switch_to_ym
                RTS
;***************************************************************************
init_screen:
exit_init_screen:                          ; otherwise proceed
                RTS
;***************************************************************************
init_level:
                LDX    #maze1
                STX    current_maze

                LDD    MAZE_PLAYER_START,X
                STD    pos
                LDA    MAZE_PLAYER_DIRECTION,X
                STA    look_direction
                CMPA   #SOUTH
                BNE    check_north
                JSR    init_looking_south
                BRA    direct_check_end
check_north:
                CMPA   #NORTH
                BNE    check_east
                JSR    init_looking_north
                BRA    direct_check_end
check_east:
                CMPA   #EAST
                BNE    check_west
                JSR    init_looking_east
                BRA    direct_check_end
check_west:
                JSR    init_looking_west
direct_check_end:
                LDX    current_maze

                LEAX   MAZE_MONSTER_START,X    ; start of monster info DATA for maze

                ; init monster info
                LDU    #current_monster_list
next_monster_init:
                LDD    M_MONSTER_POSITION,X; position in lab
                STD    ,U++
                BEQ    all_monsters_inserted

                LDD    M_MONSTER_OFFSET,X     ; offset at position
                STD    ,U++

                LDA    M_MONSTER_MOVEMENT_TYPE,X ; movement type
                STA    ,U+

                STX    ,U++                   ; level monster information

                LDY    M_MONSTER_STRUCT,X     ; get monster structure
                LDY    MONSTER_ANIM_STRUCT,Y  ; get animation struct
                LDA    ANIMATION_DELAY,Y      ; get animation delay value
                STA    ,U+

                LDD    ANIMATION_GRAPHIC_START,Y ; get first Vectorlist of Monster in animation
                STD    ,U++

                CLR    ,U+                    ; currently used vector list is number 0

                LDA    #1                     ; heading is positive
                STA    ,U+                    ; currently used vector list is number 0

                LEAX   MAZE_MONSTER_LEN,X
                BRA    next_monster_init
all_monsters_inserted:
                LDD     #- (STEPS - 1)
                STD     move_offset_y_big
                RTS
;***************************************************************************
                direct  $D0             ;
                INCLUDE "INCLUDE/CLIP_PRG.I"
                INCLUDE "INCLUDE/YM_PRG.I"
                INCLUDE "INCLUDE/DIGI_PRG.I"
                INCLUDE "PRG/MAZE_PRG.I"
                INCLUDE "PRG/IN_PRG.I"
;***************************************************************************
maze1:
                DB       "################"
                DB       "#   #   # #    #"
                DB       "# # # # #      #"
                DB       "# #   # # #    #"
                DB       "#     # # ###  #"
                DB       "#     #   # ## #"
                DB       "#     # ### #  #"
                DB       "######### #### #"
                DB       "#   #          #"
                DB       "# # # ##########"
                DB       "# # #          #"
                DB       "# # ########## #"
                DB       "#   #          #"
                DB       "# # # ######## #"
                DB       "# #            #"
                DB       "################"
player_start1:
                DB       3,5    ; start point in maze for player y, x
player_direction1:
                DB       WEST  ; start looking direction
monster1:
          DB 2, 4               ; 0 x, y position in Labyrinth
          DB 0, 0               ; 2 x, y offset position in field
          DB PATROLING_X        ; 4 moving type
          DB 5                  ; 5 moving type speed
          DB 2,4,4,4            ; 6 moving type information (not used here)
          DW goblin_monster     ; 10 monster information structure
monster2:
          DB 10, 2              ; 0 x, y position in Labyrinth
          DB 0, 0               ; 2 x, y offset position in field
          DB PATROLING_X        ; 4 moving type
          DB 2                  ; 5 moving type speed
          DB 10,2,14,2          ; 6 moving type information (not used here)
          DW goblin_monster     ; 10 monster information structure
monster3:
          DB 0, 0               ; 0 is end of monster definition for
                                ; current labyrinth
MAZE_MONSTER_LEN EQU (monster2 - monster1)
MAZE_MONSTER_START EQU (monster1 - maze1)
MAZE_PLAYER_START EQU (player_start1 - maze1)
MAZE_PLAYER_DIRECTION EQU (player_direction1 - maze1)
;***************************************************************************
goblin_monster:
          DB 0                  ; 0 special information TORCH_CARRYING, TREASURE TYPE...
                                ; baddie, goodie
          DW goblin_animation   ; 1 graphic definition
;***************************************************************************
goblin_animation:
                DB 5            ; 0 anim delay value
                DB ANIMATION    ; 1 type of animation ANIMATION or MORPHING
                DW Figure0
                DW Figure1
                DW Figure2
                DW Figure1
                DW 0            ; end of list
;***************************************************************************
                INCLUDE "DATA/TILE_DAT.I"   ; for map drawing
                INCLUDE "DATA/SONG.I"       ; ym song
                INCLUDE "DATA/SAMPLES.I"
;***************************************************************************

; goblin
; sprite for clipping, X sized 1, 2 or 4! (allways double)
; Size is 16 so ALL X are power of 2
; 64 is highest :-(
GOBLINE_SIZE EQU 16
                ; middle offset list for goblin_pic1
Figure0:
                DB 0, 0*GOBLINE_SIZE, -4*GOBLINE_SIZE
                DB 0, 0*GOBLINE_SIZE, -2*GOBLINE_SIZE
                DB 0,-1*GOBLINE_SIZE,  1*GOBLINE_SIZE
                DB 255, 5*GOBLINE_SIZE,  2*GOBLINE_SIZE
                DB 255, 0*GOBLINE_SIZE,  2*GOBLINE_SIZE
                DB 255, 1*GOBLINE_SIZE,  0*GOBLINE_SIZE
                DB 255, 0*GOBLINE_SIZE, -2*GOBLINE_SIZE
                DB 255, 4*GOBLINE_SIZE,  0*GOBLINE_SIZE
                DB 255, 0*GOBLINE_SIZE,  2*GOBLINE_SIZE
                DB 255, 0*GOBLINE_SIZE,  4*GOBLINE_SIZE
                DB 255,-4*GOBLINE_SIZE,  0*GOBLINE_SIZE
                DB 255,  0*GOBLINE_SIZE, -2*GOBLINE_SIZE
                DB 255, -1*GOBLINE_SIZE,  0*GOBLINE_SIZE
                DB 255,  0*GOBLINE_SIZE,  2*GOBLINE_SIZE
                DB 255, -5*GOBLINE_SIZE,  2*GOBLINE_SIZE
                DB 255,  0*GOBLINE_SIZE, -2*GOBLINE_SIZE
                DB 255,  3*GOBLINE_SIZE, -1*GOBLINE_SIZE
                DB 255, -5*GOBLINE_SIZE,  0*GOBLINE_SIZE
                DB 255, -4*GOBLINE_SIZE,  1*GOBLINE_SIZE
                DB 255,  0*GOBLINE_SIZE, -2*GOBLINE_SIZE
                DB 255,  4*GOBLINE_SIZE, -1*GOBLINE_SIZE
                DB 255, -5*GOBLINE_SIZE, -1*GOBLINE_SIZE
                DB 255,  0*GOBLINE_SIZE, -2*GOBLINE_SIZE
                DB 255,  5*GOBLINE_SIZE,  1*GOBLINE_SIZE
                DB 255,  5*GOBLINE_SIZE,  0*GOBLINE_SIZE
                DB 255, -3*GOBLINE_SIZE, -1*GOBLINE_SIZE
                DB 255,  0*GOBLINE_SIZE, -2*GOBLINE_SIZE
                DB  1
Figure1:
                DB 0, 0*GOBLINE_SIZE, -4*GOBLINE_SIZE
                DB 0, 0*GOBLINE_SIZE, -2*GOBLINE_SIZE
                DB 0,-1*GOBLINE_SIZE,  1*GOBLINE_SIZE
                DB 255,  5*GOBLINE_SIZE,  2*GOBLINE_SIZE
                DB 255,  0*GOBLINE_SIZE,  2*GOBLINE_SIZE
                DB 255,  1*GOBLINE_SIZE,  0*GOBLINE_SIZE
                DB 255,  0*GOBLINE_SIZE, -2*GOBLINE_SIZE
                DB 255,  4*GOBLINE_SIZE,  0*GOBLINE_SIZE
                DB 255,  0*GOBLINE_SIZE,  2*GOBLINE_SIZE
                DB 255,  0*GOBLINE_SIZE,  4*GOBLINE_SIZE
                DB 255, -4*GOBLINE_SIZE,  0*GOBLINE_SIZE
                DB 255,  0*GOBLINE_SIZE, -2*GOBLINE_SIZE
                DB 255, -1*GOBLINE_SIZE,  0*GOBLINE_SIZE
                DB 255,  0*GOBLINE_SIZE,  2*GOBLINE_SIZE
                DB 255, -2*GOBLINE_SIZE,  1*GOBLINE_SIZE
                DB 255, -1*GOBLINE_SIZE,  2*GOBLINE_SIZE
                DB 255, -2*GOBLINE_SIZE, -1*GOBLINE_SIZE
                DB 255,  1*GOBLINE_SIZE, -1*GOBLINE_SIZE
                DB 255,  2*GOBLINE_SIZE, -2*GOBLINE_SIZE
                DB 255, -5*GOBLINE_SIZE,  0*GOBLINE_SIZE
                DB 255, -5*GOBLINE_SIZE,  1*GOBLINE_SIZE
                DB 255,  0*GOBLINE_SIZE, -2*GOBLINE_SIZE
                DB 255,  5*GOBLINE_SIZE, -1*GOBLINE_SIZE
                DB 255, -5*GOBLINE_SIZE, -1*GOBLINE_SIZE
                DB 255,  0*GOBLINE_SIZE, -2*GOBLINE_SIZE
                DB 255,  5*GOBLINE_SIZE,  1*GOBLINE_SIZE
                DB 255,  5*GOBLINE_SIZE,  0*GOBLINE_SIZE
                DB 255, -3*GOBLINE_SIZE, -1*GOBLINE_SIZE
                DB 255,  0*GOBLINE_SIZE, -2*GOBLINE_SIZE
                DB  1
Figure2:
                DB 0, 0*GOBLINE_SIZE, -4*GOBLINE_SIZE
                DB 0, 0*GOBLINE_SIZE, -2*GOBLINE_SIZE
                DB 0,-1*GOBLINE_SIZE,  1*GOBLINE_SIZE
                DB 255,  5*GOBLINE_SIZE,  2*GOBLINE_SIZE
                DB 255,  0*GOBLINE_SIZE,  2*GOBLINE_SIZE
                DB 255,  1*GOBLINE_SIZE,  0*GOBLINE_SIZE
                DB 255,  0*GOBLINE_SIZE, -2*GOBLINE_SIZE
                DB 255,  4*GOBLINE_SIZE,  0*GOBLINE_SIZE
                DB 255,  0*GOBLINE_SIZE,  2*GOBLINE_SIZE
                DB 255,  0*GOBLINE_SIZE,  4*GOBLINE_SIZE
                DB 255, -4*GOBLINE_SIZE,  0*GOBLINE_SIZE
                DB 255,  0*GOBLINE_SIZE, -2*GOBLINE_SIZE
                DB 255, -1*GOBLINE_SIZE,  0*GOBLINE_SIZE
                DB 255,  0*GOBLINE_SIZE,  2*GOBLINE_SIZE
                DB 255, -2*GOBLINE_SIZE,  1*GOBLINE_SIZE
                DB 255,  2*GOBLINE_SIZE,  2*GOBLINE_SIZE
                DB 255, -2*GOBLINE_SIZE,  0*GOBLINE_SIZE
                DB 255, -2*GOBLINE_SIZE, -2*GOBLINE_SIZE
                DB 255,  2*GOBLINE_SIZE, -2*GOBLINE_SIZE
                DB 255, -5*GOBLINE_SIZE,  0*GOBLINE_SIZE
                DB 255, -5*GOBLINE_SIZE,  1*GOBLINE_SIZE
                DB 255,  0*GOBLINE_SIZE, -2*GOBLINE_SIZE
                DB 255,  5*GOBLINE_SIZE, -1*GOBLINE_SIZE
                DB 255, -4*GOBLINE_SIZE, -1*GOBLINE_SIZE
                DB 255,  0*GOBLINE_SIZE, -2*GOBLINE_SIZE
                DB 255,  4*GOBLINE_SIZE,  1*GOBLINE_SIZE
                DB 255,  5*GOBLINE_SIZE,  0*GOBLINE_SIZE
                DB 255, -3*GOBLINE_SIZE, -1*GOBLINE_SIZE
                DB 255,  0*GOBLINE_SIZE, -2*GOBLINE_SIZE
                DB  1
;***************************************************************************
                END entry_point
;***************************************************************************
