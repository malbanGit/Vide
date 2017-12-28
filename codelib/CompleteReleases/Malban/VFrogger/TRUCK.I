; this file is part of vectrex frogger, written by Malban
; in March-April 1998
; all stuff contained here is public domain
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this file contains the 'sprite' definition for a truck                    ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
truck1a_sprite:
 if USE_LOOP_UNROLING !=1
                DB 17
 else
                DW (MAX_LINE_NUM-(17+1))*ONE_LINE_LENGTH
 endif
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  4*SPRITE_BLOW_UP
                DB -4*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB -3*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -4*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
truck1a_object:
                DB 1                   ; speed + direction
                DW truck1a_sprite      ; graphic definition
                DB 35                  ; length in SCALE_FACTOR_GAME
                DB 5                   ; anim delay value
                DW truck1b_object      ; pointer to next anim object
                DB 6                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB 1                   ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                 ; brightness
                DB 0                   ; special flag

truck1b_sprite:
 if USE_LOOP_UNROLING !=1
                DB 17
 else
                DW (MAX_LINE_NUM-(17+1))*ONE_LINE_LENGTH
 endif
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  4*SPRITE_BLOW_UP
                DB -4*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB -3*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -4*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
truck1b_object:
                DB 1                   ; speed + direction
                DW truck1b_sprite      ; graphic definition
                DB 35                  ; length in SCALE_FACTOR_GAME
                DB 5                   ; anim delay value
                DW truck1c_object      ; pointer to next anim object
                DB 6                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB 1                   ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                 ; brightness
                DB 0                   ; special flag
truck1c_sprite:
 if USE_LOOP_UNROLING !=1
                DB 17
 else
                DW (MAX_LINE_NUM-(17+1))*ONE_LINE_LENGTH
 endif
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  4*SPRITE_BLOW_UP
                DB -4*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB -3*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -4*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
truck1c_object:
                DB 1                   ; speed + direction
                DW truck1c_sprite      ; graphic definition
                DB 35                  ; length in SCALE_FACTOR_GAME
                DB 5                   ; anim delay value
                DW truck1d_object      ; pointer to next anim object
                DB 6                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB 1                   ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                 ; brightness
                DB 0                   ; special flag
truck1d_object:
                DB 1                   ; speed + direction
                DW truck1b_sprite      ; graphic definition
                DB 35                  ; length in SCALE_FACTOR_GAME
                DB 5                   ; anim delay value
                DW truck1a_object      ; pointer to next anim object
                DB 6                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB 1                   ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                 ; brightness
                DB 0                   ; special flag
truck2a_object:
                DB 2                   ; speed + direction
                DW truck1a_sprite      ; graphic definition
                DB 35                  ; length in SCALE_FACTOR_GAME
                DB 5                   ; anim delay value
                DW truck2b_object      ; pointer to next anim object
                DB 6                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB 1                   ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                 ; brightness
                DB 0                   ; special flag

truck2b_object:
                DB 2                   ; speed + direction
                DW truck1b_sprite      ; graphic definition
                DB 35                  ; length in SCALE_FACTOR_GAME
                DB 5                   ; anim delay value
                DW truck2c_object      ; pointer to next anim object
                DB 6                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB 1                   ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                 ; brightness
                DB 0                   ; special flag
truck2c_object:
                DB 2                   ; speed + direction
                DW truck1c_sprite      ; graphic definition
                DB 35                  ; length in SCALE_FACTOR_GAME
                DB 5                   ; anim delay value
                DW truck2d_object      ; pointer to next anim object
                DB 6                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB 1                   ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                 ; brightness
                DB 0                   ; special flag
truck2d_object:
                DB 2                   ; speed + direction
                DW truck1b_sprite      ; graphic definition
                DB 35                  ; length in SCALE_FACTOR_GAME
                DB 5                   ; anim delay value
                DW truck2a_object      ; pointer to next anim object
                DB 6                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB 1                   ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                 ; brightness
                DB 0                   ; special flag
