 INCLUDE "INCLUDE/MACROS/DIV_MAC.I"

SPEED           EQU $9    ; speed of 'walker'
                          ; (the bigger the number, the faster one walks)
LIGHT           EQU $20   ; 7f - light + current_z_pos �er round - LIGHT
                          ; (the smaller the number, the further one can look)
LAB_SCALE       EQU $80   ; size of maze
                          ; (the bigger the number, the bigger the maze)

; simple defintions
SOUTH           EQU 0
WEST            EQU 2
NORTH           EQU 4
EAST            EQU 6

UP              EQU 4
DOWN            EQU 5

; maze sizes, corresponding to data!!!
MAZE_SIZE       EQU 16
MAZE_X          EQU MAZE_SIZE
MAZE_Y          EQU MAZE_SIZE

; following MUST not be changed!!! (anymore)
; since divide routines use binary arithmetic and assume
; some sizes HARDCODED!!! (like WALL_SIZE, STEPS, DOUBLE_STEP...)

; is easyly divideable by 16
; $30 is not to small, but a multiple of 16
; which is very good for sprite sizes for clipping!
WALL_SIZE       EQU $30 ; some maximum, depending one other values!
                        ; due to 8 bit arithmetic (gets negative...)

SQUARE_SIZE     EQU WALL_SIZE*2
                        ; -> Position must be SQUARE_SIZE, -SQUARE_SIZE
                        ; Wall MUST be smaller than Square
                        ; max = $7f due to 8 bit arithmetic (gets negative...)

LAB_REDUCT_1    EQU (LAB_SCALE * WALL_SIZE) / SQUARE_SIZE
STEPS           EQU WALL_SIZE*2
DOUBLE_STEP     EQU STEPS*2
DOUBLE_STEP_INVERSE EQU (DOUBLE_STEP/256) + ((DOUBLE_STEP-((DOUBLE_STEP/256)*256))*256)

;***************************************************************************
; double step is 192
; 192/2 = 96
; 96 /2 = 48
; 48 /2 = 24
; 24 /2 = 12
; 12 /2 = 6
;  6 /2 = 3
; using this macro instead of a regular DIV - > saves sometimes
; (depending on div) per use up to 1000 cycles !!!

DIV_D_BY_DOUBLE_STEP_TO_B macro ; UNSIGNED

        DIV_D_64_A

        SUBA    #%11000000 ; this is a divider 3
        BCC     is_divider_1\?
        ADDA    #%11000000
        ANDCC   #NOT_CARRY
        ROLB               ; roll in carry

procede1\?:
        SUBA    #%01100000
        BCC     is_divider_2\?
        ADDA    #%01100000
        ANDCC   #NOT_CARRY
        ROLB               ; roll in carry

procede2\?:
        SUBA    #%00110000
        BCC     is_divider_3\?
        ADDA    #%00110000
        ANDCC   #NOT_CARRY
        ROLB               ; roll in carry

procede3\?:
        SUBA    #%00011000
        BCC     is_divider_4\?
        ADDA    #%00011000
        ANDCC   #NOT_CARRY
        ROLB               ; roll in carry

procede4\?:
        SUBA    #%00001100
        BCC     is_divider_5\?
        ADDA    #%00001100
        ANDCC   #NOT_CARRY
        ROLB               ; roll in carry

procede5\?:
        SUBA    #%00000110
        BCC     is_divider_6\?
        ADDA    #%00000110
        ANDCC   #NOT_CARRY
        ROLB               ; roll in carry

procede6\?:
        SUBA    #%00000011
        BCC     is_divider_7\?
        ADDA    #%00000011
        ANDCC   #NOT_CARRY
        ROLB               ; roll in carry

        BRA     macro_end\?

is_divider_1\?:
        ORCC    #CARRY
        ROLB               ; roll in carry
        BRA     procede1\?

is_divider_2\?:
        ORCC    #CARRY
        ROLB               ; roll in carry
        BRA     procede2\?

is_divider_3\?:
        ORCC    #CARRY
        ROLB               ; roll in carry
        BRA     procede3\?

is_divider_4\?:
        ORCC    #CARRY
        ROLB               ; roll in carry
        BRA     procede4\?

is_divider_5\?:
        ORCC    #CARRY
        ROLB               ; roll in carry
        BRA     procede5\?

is_divider_6\?:
        ORCC    #CARRY
        ROLB               ; roll in carry
        BRA     procede6\?

is_divider_7\?:
        ORCC    #CARRY
        ROLB               ; roll in carry

macro_end\?:
       endm

scale_step:      DB 0 ; calculated stepping in scale, precalculated
                      ; before maze is drawn

maze_intensity:  DB 0 ; current intensity of maze frame,
                      ; decreases the further away from player

view_pos_y:      DB 0 ; current frame-maze position while drawing the maze

helper_first:    DB 0 ; the first frame is drawn a bit smaller,
                      ; otherwise we have bright corners in the display
                      ; this is just a flag to indicate we are drawing
                      ; the first frame

tmp0:            DW 0           ; used in maze to calculate size of maze
scale_shadow:    DB 0           ; used in maze to store a shadow copy of scaling
maze_ram:        DS MAZE_SIZE*4 ; only 3 needed, but with four we can use ASL!
maze_draw_y:     DB 0
