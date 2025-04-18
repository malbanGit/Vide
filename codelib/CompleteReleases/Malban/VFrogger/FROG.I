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
frogger_left:
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
