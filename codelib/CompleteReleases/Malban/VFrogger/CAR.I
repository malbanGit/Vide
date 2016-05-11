; this file is part of vectrex frogger, written by Malban
; in March-April 1998
; all stuff contained here is public domain
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this file contains 'sprite' definition data for all cars                  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
; for collision checking: SPRITES MUST HAVE THE LEFTMOST POINT AS STARTVECTOR (*)
; car1 is moving left with a speed of -1
; for collision checking: SPRITES MUST HAVE THE LEFTMOST POINT AS STARTVECTOR (*)
; car3 is moving right with a speed of 1

; sprite definition
car1a_sprite:
 if USE_LOOP_UNROLING !=1
                DB 12
 else
                DW (MAX_LINE_NUM-(12+1))*ONE_LINE_LENGTH
 endif
                DB  5*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB -5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  3*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  4*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP,  4*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -4*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -4*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  4*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
car1a_object:
                DB -1                   ; speed + direction
                DW car1a_sprite         ; graphic definition
                DB 20                   ; length in SCALE_FACTOR_GAME
                DB 5                    ; anim delay value
                DW car1b_object         ; pointer to next anim object
                DB -2                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB 1                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
; sprite definition
car1b_sprite:
 if USE_LOOP_UNROLING !=1
                DB 12
 else
                DW (MAX_LINE_NUM-(12+1))*ONE_LINE_LENGTH
 endif
                DB  5*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB -5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  3*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -4*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -4*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  4*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
car1b_object:
                DB -1                   ; speed + direction
                DW car1b_sprite         ; graphic definition
                DB 20                   ; length in SCALE_FACTOR_GAME
                DB 5                    ; anim delay value
                DW car1c_object         ; pointer to next anim object
                DB -2                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB 1                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
; sprite definition
car1c_sprite:
 if USE_LOOP_UNROLING !=1
                DB 11
 else
                DW (MAX_LINE_NUM-(11+1))*ONE_LINE_LENGTH
 endif
                DB  5*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB -5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB -4*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -4*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  4*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
car1c_object:
                DB -1                   ; speed + direction
                DW car1c_sprite         ; graphic definition
                DB 20                   ; length in SCALE_FACTOR_GAME
                DB 5                    ; anim delay value
                DW car1d_object         ; pointer to next anim object
                DB -2                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB 1                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
car1d_object:
                DB -1                   ; speed + direction
                DW car1b_sprite         ; graphic definition
                DB 20                   ; length in SCALE_FACTOR_GAME
                DB 5                    ; anim delay value
                DW car1a_object         ; pointer to next anim object
                DB -2                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB 1                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
; sprite definition
car3a_sprite:
 if USE_LOOP_UNROLING !=1
                DB 11
 else
                DW (MAX_LINE_NUM-(11+1))*ONE_LINE_LENGTH
 endif
                DB  0*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -4*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB -3*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB  4*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
car3a_object:
                DB 1                    ; speed + direction
                DW car3a_sprite         ; graphic definition
                DB 16                   ; length in SCALE_FACTOR_GAME
                DB 5                    ; anim delay value
                DW car3b_object         ; pointer to next anim object
                DB -1                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB 3                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
; sprite definition
car3b_sprite:
 if USE_LOOP_UNROLING !=1
                DB 11
 else
                DW (MAX_LINE_NUM-(11+1))*ONE_LINE_LENGTH
 endif
                DB  0*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -4*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB -3*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB  4*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
car3b_object:
                DB 1                    ; speed + direction
                DW car3b_sprite         ; graphic definition
                DB 16                   ; length in SCALE_FACTOR_GAME
                DB 5                    ; anim delay value
                DW car3a_object         ; pointer to next anim object
                DB 0                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB 3                   ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
; sprite definition
car4a_sprite:
 if USE_LOOP_UNROLING !=1
                DB 11
 else
                DW (MAX_LINE_NUM-(11+1))*ONE_LINE_LENGTH
 endif
                DB -2*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB  4*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -4*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB -3*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
car4a_object:
                DB -1                   ; speed + direction
                DW car4a_sprite         ; graphic definition
                DB 16                   ; length in SCALE_FACTOR_GAME
                DB 5                    ; anim delay value
                DW car4b_object         ; pointer to next anim object
                DB -5                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB 1                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
; sprite definition
car4b_sprite:
 if USE_LOOP_UNROLING !=1
                DB 11
 else
                DW (MAX_LINE_NUM-(11+1))*ONE_LINE_LENGTH
 endif
                DB -1*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB  4*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -4*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB -3*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
car4b_object:
                DB -1                   ; speed + direction
                DW car4b_sprite         ; graphic definition
                DB 16                   ; length in SCALE_FACTOR_GAME
                DB 5                    ; anim delay value
                DW car4a_object         ; pointer to next anim object
                DB -6                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB 1                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
; sprite definition

car5a_sprite:
 if USE_LOOP_UNROLING !=1
                DB 10
 else
                DW (MAX_LINE_NUM-(10+1))*ONE_LINE_LENGTH
 endif
                DB -4*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB  4*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  4*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB -4*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
car5a_object:
                DB 1                    ; speed + direction
                DW car5a_sprite         ; graphic definition
                DB 20                   ; length in SCALE_FACTOR_GAME
                DB 5                    ; anim delay value
                DW car5b_object         ; pointer to next anim object
                DB 0                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB 1                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
; sprite definition
car5b_sprite:
 if USE_LOOP_UNROLING !=1
                DB 10
 else
                DW (MAX_LINE_NUM-(10+1))*ONE_LINE_LENGTH
 endif
                DB  4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  4*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB -4*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB -4*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
car5b_object:
                DB 1                    ; speed + direction
                DW car5b_sprite         ; graphic definition
                DB 20                   ; length in SCALE_FACTOR_GAME
                DB 5                    ; anim delay value
                DW car5c_object         ; pointer to next anim object
                DB -5                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB 2                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
; sprite definition
car5c_sprite:
 if USE_LOOP_UNROLING !=1
                DB 10
 else
                DW (MAX_LINE_NUM-(10+1))*ONE_LINE_LENGTH
 endif
                DB  4*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  4*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB -4*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB -4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
car5c_object:
                DB 1                    ; speed + direction
                DW car5c_sprite         ; graphic definition
                DB 20                   ; length in SCALE_FACTOR_GAME
                DB 5                    ; anim delay value
                DW car5d_object         ; pointer to next anim object
                DB -5                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB 2                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
car5d_object:
                DB 1                    ; speed + direction
                DW car5b_sprite         ; graphic definition
                DB 20                   ; length in SCALE_FACTOR_GAME
                DB 5                    ; anim delay value
                DW car5a_object         ; pointer to next anim object
                DB -5                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB 2                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
car6a_object:
                DB 2                    ; speed + direction
                DW car5a_sprite         ; graphic definition
                DB 20                   ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW car6b_object         ; pointer to next anim object
                DB 0                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB 1                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
car6b_object:
                DB 2                    ; speed + direction
                DW car5b_sprite         ; graphic definition
                DB 20                   ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW car6c_object         ; pointer to next anim object
                DB -5                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB 2                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
car6c_object:
                DB 2                    ; speed + direction
                DW car5c_sprite         ; graphic definition
                DB 20                   ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW car6d_object         ; pointer to next anim object
                DB -5                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB 2                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
car6d_object:
                DB 2                    ; speed + direction
                DW car5b_sprite         ; graphic definition
                DB 20                   ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW car6a_object         ; pointer to next anim object
                DB -5                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB 2                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
; sprite definition
car7a_sprite:
 if USE_LOOP_UNROLING !=1
                DB 10
 else
                DW (MAX_LINE_NUM-(10+1))*ONE_LINE_LENGTH
 endif
                DB -2*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB  4*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  4*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB -4*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB -4*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
car7a_object:
                DB -1                   ; speed + direction
                DW car7a_sprite         ; graphic definition
                DB 20                   ; length in SCALE_FACTOR_GAME
                DB 5                    ; anim delay value
                DW car7b_object         ; pointer to next anim object
                DB -5                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB 1                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
; sprite definition
car7b_sprite:
 if USE_LOOP_UNROLING !=1
                DB 10
 else
                DW (MAX_LINE_NUM-(10+1))*ONE_LINE_LENGTH
 endif
                DB  4*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  4*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB -4*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB -4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
car7b_object:
                DB -1                   ; speed + direction
                DW car7b_sprite         ; graphic definition
                DB 20                   ; length in SCALE_FACTOR_GAME
                DB 5                    ; anim delay value
                DW car7c_object         ; pointer to next anim object
                DB -5                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB 1                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
; sprite definition
car7c_sprite:
 if USE_LOOP_UNROLING !=1
                DB 10
 else
                DW (MAX_LINE_NUM-(10+1))*ONE_LINE_LENGTH
 endif
                DB  4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  4*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB -4*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB -4*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
car7c_object:
                DB -1                   ; speed + direction
                DW car7c_sprite         ; graphic definition
                DB 20                   ; length in SCALE_FACTOR_GAME
                DB 5                    ; anim delay value
                DW car7d_object         ; pointer to next anim object
                DB -5                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB 1                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
car7d_object:
                DB -1                   ; speed + direction
                DW car7b_sprite         ; graphic definition
                DB 20                   ; length in SCALE_FACTOR_GAME
                DB 5                    ; anim delay value
                DW car7a_object         ; pointer to next anim object
                DB -5                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB 1                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
car8a_object:
                DB -2                   ; speed + direction
                DW car7a_sprite         ; graphic definition
                DB 20                   ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW car8b_object         ; pointer to next anim object
                DB -5                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB 1                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
car8b_object:
                DB -2                   ; speed + direction
                DW car7b_sprite         ; graphic definition
                DB 20                   ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW car8c_object         ; pointer to next anim object
                DB -5                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB 1                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
car8c_object:
                DB -2                   ; speed + direction
                DW car7c_sprite         ; graphic definition
                DB 20                   ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW car8d_object         ; pointer to next anim object
                DB -5                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB 1                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
car8d_object:
                DB -2                   ; speed + direction
                DW car7b_sprite         ; graphic definition
                DB 20                   ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW car8a_object         ; pointer to next anim object
                DB -5                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB 1                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
