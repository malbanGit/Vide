; this file is part of vectrex frogger, written by Malban
; in March-April 1998
; all stuff contained here is public domain
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this file contains 'sprite' definition data for all frogs (non morphing)  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
frogger_down_offset:
                DB  0   ; offsets y in 'SCALE_FACTOR_GAME'
                DB -4   ; offsets x in 'SCALE_FACTOR_GAME'
frogger_up_offset:
                DB  0   ; offsets y in 'SCALE_FACTOR_GAME'
                DB -4   ; offsets x in 'SCALE_FACTOR_GAME'
frogger_left_offset:
                DB  3   ; offsets y in 'SCALE_FACTOR_GAME'
                DB -4   ; offsets x in 'SCALE_FACTOR_GAME'
frogger_right_offset:

 db 4,5; ?
                DB -7   ; offsets y in 'SCALE_FACTOR_GAME'
                DB -4   ; offsets x in 'SCALE_FACTOR_GAME'


frogger_down:
frogger_up:
                DB  15       ; 16 vectors are drawn
                DB  3*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP    ;
                DB  1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP    ;
                DB  1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP    ;
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP    ;       -------
                DB -1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP    ;     /        \
                DB -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP    ;     \       /
                DB -3*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP    ;     /       \
                DB -4*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP    ;  */            \
                DB -1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP    ;   \            /
                DB  0*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP    ;    \    /-\   /
                DB  2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP    ;     \  /  \  /
                DB  0*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP    ;     /_/    \_\
                DB -2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP    ;
                DB  0*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP    ;
                DB  1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP    ;
                DB  4*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP    ;

froggerLeftAnim:
 dw frogger_left1
 dw frogger_left1
 dw frogger_left4
 dw frogger_left4
 dw frogger_left3
 dw frogger_left3
 dw frogger_left2
 dw frogger_left2
frogger_left:
frogger_left1:
                DB 17
                DB -1*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB -4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB  4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -3*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  4*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
frogger_left2:
 DB +$11 ; number of lines to draw
 DB -$01*SPRITE_BLOW_UP, +$00*SPRITE_BLOW_UP ; draw to y, x
 DB +$01*SPRITE_BLOW_UP, +$03*SPRITE_BLOW_UP ; draw to y, x
 DB -$02*SPRITE_BLOW_UP, +$01*SPRITE_BLOW_UP ; draw to y, x
 DB -$02*SPRITE_BLOW_UP, -$04*SPRITE_BLOW_UP ; draw to y, x
 DB +$00*SPRITE_BLOW_UP, -$01*SPRITE_BLOW_UP ; draw to y, x
 DB -$01*SPRITE_BLOW_UP, +$02*SPRITE_BLOW_UP ; draw to y, x
 DB +$02*SPRITE_BLOW_UP, +$05*SPRITE_BLOW_UP ; draw to y, x
 DB -$02*SPRITE_BLOW_UP, +$04*SPRITE_BLOW_UP ; draw to y, x
 DB -$01*SPRITE_BLOW_UP, +$03*SPRITE_BLOW_UP ; draw to y, x
 DB -$01*SPRITE_BLOW_UP, -$01*SPRITE_BLOW_UP ; draw to y, x
 DB +$00*SPRITE_BLOW_UP, +$03*SPRITE_BLOW_UP ; draw to y, x
 DB +$01*SPRITE_BLOW_UP, -$01*SPRITE_BLOW_UP ; draw to y, x
 DB +$04*SPRITE_BLOW_UP, -$02*SPRITE_BLOW_UP ; draw to y, x
 DB +$02*SPRITE_BLOW_UP, -$01*SPRITE_BLOW_UP ; draw to y, x
 DB +$01*SPRITE_BLOW_UP, -$04*SPRITE_BLOW_UP ; draw to y, x
 DB +$02*SPRITE_BLOW_UP, -$04*SPRITE_BLOW_UP ; draw to y, x
 DB -$01*SPRITE_BLOW_UP, -$02*SPRITE_BLOW_UP ; draw to y, x
 DB -$02*SPRITE_BLOW_UP, -$01*SPRITE_BLOW_UP ; draw to y, x

BLOW_UP EQU SPRITE_BLOW_UP

frogger_left3:
 DB +$11 ; number of lines to draw
 DB -$01*BLOW_UP, +$01*BLOW_UP ; draw to y, x
 DB +$01*BLOW_UP, +$02*BLOW_UP ; draw to y, x
 DB -$01*BLOW_UP, +$00*BLOW_UP ; draw to y, x
 DB -$02*BLOW_UP, -$03*BLOW_UP ; draw to y, x
 DB -$01*BLOW_UP, -$02*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, +$02*BLOW_UP ; draw to y, x
 DB +$02*BLOW_UP, +$04*BLOW_UP ; draw to y, x
 DB +$01*BLOW_UP, +$04*BLOW_UP ; draw to y, x
 DB +$01*BLOW_UP, +$04*BLOW_UP ; draw to y, x
 DB -$03*BLOW_UP, +$02*BLOW_UP ; draw to y, x
 DB -$02*BLOW_UP, +$00*BLOW_UP ; draw to y, x
 DB +$03*BLOW_UP, +$02*BLOW_UP ; draw to y, x
 DB +$04*BLOW_UP, -$02*BLOW_UP ; draw to y, x
 DB +$02*BLOW_UP, -$04*BLOW_UP ; draw to y, x
 DB -$02*BLOW_UP, -$05*BLOW_UP ; draw to y, x
 DB +$01*BLOW_UP, -$02*BLOW_UP ; draw to y, x
 DB -$01*BLOW_UP, -$02*BLOW_UP ; draw to y, x
 DB -$02*BLOW_UP, -$01*BLOW_UP ; draw to y, x



frogger_left4:
 DB +$11 ; number of lines to draw
 DB -$01*BLOW_UP, +$00*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, +$03*BLOW_UP ; draw to y, x
 DB -$02*BLOW_UP, +$00*BLOW_UP ; draw to y, x
 DB -$02*BLOW_UP, -$01*BLOW_UP ; draw to y, x
 DB -$01*BLOW_UP, -$02*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, +$02*BLOW_UP ; draw to y, x
 DB +$03*BLOW_UP, +$03*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, +$03*BLOW_UP ; draw to y, x
 DB -$01*BLOW_UP, +$00*BLOW_UP ; draw to y, x
 DB -$01*BLOW_UP, +$02*BLOW_UP ; draw to y, x
 DB -$01*BLOW_UP, -$01*BLOW_UP ; draw to y, x
 DB +$01*BLOW_UP, +$03*BLOW_UP ; draw to y, x
 DB +$01*BLOW_UP, -$01*BLOW_UP ; draw to y, x
 DB +$04*BLOW_UP, -$01*BLOW_UP ; draw to y, x
 DB +$01*BLOW_UP, -$04*BLOW_UP ; draw to y, x
 DB +$01*BLOW_UP, -$02*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, -$02*BLOW_UP ; draw to y, x
 DB -$02*BLOW_UP, -$02*BLOW_UP ; draw to y, x

frogger_right:
                DB 17
                DB  1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB -4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -3*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -4*SPRITE_BLOW_UP

froggerRightAnim:
 dw frogger_right1
 dw frogger_right1
 dw frogger_right4
 dw frogger_right4
 dw frogger_right3
 dw frogger_right3
 dw frogger_right2
 dw frogger_right2


frogger_right1:
 DB +$11 ; number of lines to draw
 DB -$01*BLOW_UP, +$00*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, -$03*BLOW_UP ; draw to y, x
 DB -$01*BLOW_UP, -$01*BLOW_UP ; draw to y, x
 DB -$04*BLOW_UP, +$00*BLOW_UP ; draw to y, x
 DB -$01*BLOW_UP, +$01*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, -$02*BLOW_UP ; draw to y, x
 DB +$04*BLOW_UP, +$00*BLOW_UP ; draw to y, x
 DB -$03*BLOW_UP, -$03*BLOW_UP ; draw to y, x
 DB -$01*BLOW_UP, +$02*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, -$04*BLOW_UP ; draw to y, x
 DB +$01*BLOW_UP, +$01*BLOW_UP ; draw to y, x
 DB +$01*BLOW_UP, -$01*BLOW_UP ; draw to y, x
 DB +$02*BLOW_UP, +$00*BLOW_UP ; draw to y, x
 DB +$02*BLOW_UP, +$01*BLOW_UP ; draw to y, x
 DB +$01*BLOW_UP, +$03*BLOW_UP ; draw to y, x
 DB +$02*BLOW_UP, +$02*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, +$02*BLOW_UP ; draw to y, x
 DB -$02*BLOW_UP, +$02*BLOW_UP ; draw to y, x

frogger_right2:
 DB +$11 ; number of lines to draw
 DB -$01*BLOW_UP, +$00*BLOW_UP ; draw to y, x
 DB +$01*BLOW_UP, -$03*BLOW_UP ; draw to y, x
 DB -$02*BLOW_UP, -$01*BLOW_UP ; draw to y, x
 DB -$02*BLOW_UP, +$04*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, +$01*BLOW_UP ; draw to y, x
 DB -$01*BLOW_UP, -$02*BLOW_UP ; draw to y, x
 DB +$02*BLOW_UP, -$05*BLOW_UP ; draw to y, x
 DB -$02*BLOW_UP, -$04*BLOW_UP ; draw to y, x
 DB -$01*BLOW_UP, -$03*BLOW_UP ; draw to y, x
 DB -$01*BLOW_UP, +$01*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, -$03*BLOW_UP ; draw to y, x
 DB +$01*BLOW_UP, +$01*BLOW_UP ; draw to y, x
 DB +$04*BLOW_UP, +$02*BLOW_UP ; draw to y, x
 DB +$02*BLOW_UP, +$01*BLOW_UP ; draw to y, x
 DB +$01*BLOW_UP, +$04*BLOW_UP ; draw to y, x
 DB +$02*BLOW_UP, +$04*BLOW_UP ; draw to y, x
 DB -$01*BLOW_UP, +$02*BLOW_UP ; draw to y, x
 DB -$02*BLOW_UP, +$01*BLOW_UP ; draw to y, x


frogger_right3:
 DB +$11 ; number of lines to draw
 DB -$01*BLOW_UP, -$01*BLOW_UP ; draw to y, x
 DB +$01*BLOW_UP, -$02*BLOW_UP ; draw to y, x
 DB -$01*BLOW_UP, +$00*BLOW_UP ; draw to y, x
 DB -$02*BLOW_UP, +$03*BLOW_UP ; draw to y, x
 DB -$01*BLOW_UP, +$02*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, -$02*BLOW_UP ; draw to y, x
 DB +$02*BLOW_UP, -$04*BLOW_UP ; draw to y, x
 DB +$01*BLOW_UP, -$04*BLOW_UP ; draw to y, x
 DB +$01*BLOW_UP, -$04*BLOW_UP ; draw to y, x
 DB -$03*BLOW_UP, -$02*BLOW_UP ; draw to y, x
 DB -$02*BLOW_UP, +$00*BLOW_UP ; draw to y, x
 DB +$03*BLOW_UP, -$02*BLOW_UP ; draw to y, x
 DB +$04*BLOW_UP, +$02*BLOW_UP ; draw to y, x
 DB +$02*BLOW_UP, +$04*BLOW_UP ; draw to y, x
 DB -$02*BLOW_UP, +$05*BLOW_UP ; draw to y, x
 DB +$01*BLOW_UP, +$02*BLOW_UP ; draw to y, x
 DB -$01*BLOW_UP, +$02*BLOW_UP ; draw to y, x
 DB -$02*BLOW_UP, +$01*BLOW_UP ; draw to y, x

frogger_right4:
 DB +$11 ; number of lines to draw
 DB -$01*BLOW_UP, +$00*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, -$03*BLOW_UP ; draw to y, x
 DB -$02*BLOW_UP, +$00*BLOW_UP ; draw to y, x
 DB -$02*BLOW_UP, +$01*BLOW_UP ; draw to y, x
 DB -$01*BLOW_UP, +$02*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, -$02*BLOW_UP ; draw to y, x
 DB +$03*BLOW_UP, -$03*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, -$03*BLOW_UP ; draw to y, x
 DB -$01*BLOW_UP, +$00*BLOW_UP ; draw to y, x
 DB -$01*BLOW_UP, -$02*BLOW_UP ; draw to y, x
 DB -$01*BLOW_UP, +$01*BLOW_UP ; draw to y, x
 DB +$01*BLOW_UP, -$03*BLOW_UP ; draw to y, x
 DB +$01*BLOW_UP, +$01*BLOW_UP ; draw to y, x
 DB +$04*BLOW_UP, +$01*BLOW_UP ; draw to y, x
 DB +$01*BLOW_UP, +$04*BLOW_UP ; draw to y, x
 DB +$01*BLOW_UP, +$02*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, +$02*BLOW_UP ; draw to y, x
 DB -$02*BLOW_UP, +$02*BLOW_UP ; draw to y, x

frog1a_in_home_sprite:
                DB 7
                DB -3*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB  3*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB  4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB -4*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
frog1a_in_home_object:
                DB 0                    ; speed + direction
                DW frog1a_in_home_sprite; graphic definition
                DB 0                    ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW frog1b_in_home_object; pointer to next anim object
                DB -4                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB 4                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
frog1b_in_home_sprite:
                DB 7
                DB -3*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB  3*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB  4*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB -4*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
frog1b_in_home_object:
                DB 0                    ; speed + direction
                DW frog1b_in_home_sprite; graphic definition
                DB 0                    ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW frog1c_in_home_object; pointer to next anim object
                DB -4                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB 4                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
frog1c_in_home_sprite:
                DB 7
                DB -3*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB  3*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB  4*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB -4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
frog1c_in_home_object:
                DB 0                    ; speed + direction
                DW frog1c_in_home_sprite; graphic definition
                DB 0                    ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW frog1d_in_home_object; pointer to next anim object
                DB -4                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB 4                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
frog1d_in_home_object:
                DB 0                    ; speed + direction
                DW frog1b_in_home_sprite; graphic definition
                DB 0                    ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW frog1a_in_home_object; pointer to next anim object
                DB -4                  ; offsets y in 'SCALE_FACTOR_GAME'
                DB 4                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
girl1a_object:
                DB 0                    ; speed + direction
                DW frogger_right        ; graphic definition
                DB 10                   ; length in SCALE_FACTOR_GAME
                DB 50                   ; anim delay value
                DW girl1b_object        ; pointer to next anim object
                DB -7                   ; offsets y in 'SCALE_IN_HOME', since this is a home object
                DB -4                   ; offsets x in 'SCALE_IN_HOME', since this is a home object
                DB $7f                  ; brightness
                DB SPECIAL_GIRL_RIGHT   ; special flag
girl1b_object:
                DB 0                    ; speed + direction
                DW frogger_left         ; graphic definition
                DB 10                   ; length in SCALE_FACTOR_GAME
                DB 50                   ; anim delay value
                DW girl1a_object        ; pointer to next anim object
                DB 2                    ; offsets y in 'SCALE_IN_HOME', since this is a home object
                DB 10                   ; offsets x in 'SCALE_IN_HOME', since this is a home object
                DB $7f                  ; brightness
                DB SPECIAL_GIRL_LEFT    ; special flag
frog_dead_pic:
                DB 27
                DB  3*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB -4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -3*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB -4*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  4*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
