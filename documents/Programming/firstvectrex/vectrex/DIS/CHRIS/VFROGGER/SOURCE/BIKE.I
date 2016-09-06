; this file is part of vectrex frogger, written by Malban
; in March-April 1998
; all stuff contained here is public domain
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this file contains 'sprite' definition data for the bike                  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
; for collision checking: SPRITES MUST HAVE THE LEFTMOST POINT AS STARTVECTOR (*)
; bike1 is moving to the left with a speed of -1

; sprite definition
bike1a_sprite:
 if USE_LOOP_UNROLING !=1
                DB 22
 else
                DW (MAX_LINE_NUM-(22+1))*ONE_LINE_LENGTH
 endif
                DB  3*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -3*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  3*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  3*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB -3*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  4*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB -3*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  3*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB -4*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB -3*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  3*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
bike1a_object:
                DB -1                   ; speed + direction
                DW bike1a_sprite        ; graphic definition
                DB 20                   ; length in SCALE_FACTOR_GAME
                DB 4                    ; anim delay value
                DW bike1b_object        ; pointer to next anim object
                DB -5                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB 1                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
; sprite definition
bike1b_sprite:
 if USE_LOOP_UNROLING !=1
                DB 22
 else
                DW (MAX_LINE_NUM-(22+1))*ONE_LINE_LENGTH
 endif
                DB  3*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -3*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  3*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP,  4*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  4*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB -3*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  3*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB -3*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  3*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
bike1b_object:
                DB -1                   ; speed + direction
                DW bike1b_sprite        ; graphic definition
                DB 20                   ; length in SCALE_FACTOR_GAME
                DB 4                    ; anim delay value
                DW bike1c_object        ; pointer to next anim object
                DB -5                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB 1                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
bike1c_sprite:
 if USE_LOOP_UNROLING !=1
                DB 22
 else
                DW (MAX_LINE_NUM-(22+1))*ONE_LINE_LENGTH
 endif
                DB  3*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -3*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  3*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  3*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB -3*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  4*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB -3*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  3*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -4*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB -3*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  3*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
bike1c_object:
                DB -1                   ; speed + direction
                DW bike1c_sprite        ; graphic definition
                DB 20                   ; length in SCALE_FACTOR_GAME
                DB 4                    ; anim delay value
                DW bike1d_object        ; pointer to next anim object
                DB -5                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB 1                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
bike1d_sprite:
 if USE_LOOP_UNROLING !=1
                DB 22
 else
                DW (MAX_LINE_NUM-(22+1))*ONE_LINE_LENGTH
 endif
                DB  3*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -3*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  3*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP,  4*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  4*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB -3*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  3*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB -4*SPRITE_BLOW_UP, -4*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB -3*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  3*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
bike1d_object:
                DB -1                   ; speed + direction
                DW bike1d_sprite        ; graphic definition
                DB 20                   ; length in SCALE_FACTOR_GAME
                DB 4                    ; anim delay value
                DW bike1a_object        ; pointer to next anim object
                DB -5                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB 1                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
