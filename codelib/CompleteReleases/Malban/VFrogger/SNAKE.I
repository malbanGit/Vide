; this file is part of vectrex frogger, written by Malban
; in March-April 1998
; all stuff contained here is public domain
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this file contains 'sprite' definition data for snakes                    ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; for collision checking: SPRITES MUST HAVE THE LEFTMOST POINT AS STARTVECTOR (*)
; snake1 is moving to the right with a speed of 1
; snake2 is moving to the right with a speed of 2
; snake3 is moving to the left with a speed of -1
; snake4 is moving to the left with a speed of -2
snake1a_sprite:
 if USE_LOOP_UNROLING !=1
                DB 10
 else
                DW (MAX_LINE_NUM-(10+1))*ONE_LINE_LENGTH
 endif
                DB  4*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -4*SPRITE_BLOW_UP,  4*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -4*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
snake1a_object:
                DB 1                    ; speed + direction
                DW snake1a_sprite       ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 4                    ; anim delay value
                DW snake1b_object       ; pointer to next anim object
                DB -7                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB 2                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB SPECIAL_RIGHT_SNAKE  ; special flag
snake1b_sprite:
 if USE_LOOP_UNROLING !=1
                DB 10
 else
                DW (MAX_LINE_NUM-(10+1))*ONE_LINE_LENGTH
 endif
                DB  2*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP,  4*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -4*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
snake1b_object:
                DB 1                    ; speed + direction
                DW snake1b_sprite       ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 4                    ; anim delay value
                DW snake1c_object       ; pointer to next anim object
                DB -7                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB 2                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB SPECIAL_RIGHT_SNAKE  ; special flag
snake1c_sprite:
 if USE_LOOP_UNROLING !=1
                DB 10
 else
                DW (MAX_LINE_NUM-(10+1))*ONE_LINE_LENGTH
 endif
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  4*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -4*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
snake1c_object:
                DB 1                    ; speed + direction
                DW snake1c_sprite       ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 4                    ; anim delay value
                DW snake1d_object       ; pointer to next anim object
                DB -3                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB 2                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB SPECIAL_RIGHT_SNAKE  ; special flag
snake1d_object:
                DB 1                    ; speed + direction
                DW snake1b_sprite       ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW snake1a_object       ; pointer to next anim object
                DB -7                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB 2                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB SPECIAL_RIGHT_SNAKE  ; special flag
snake2a_object:
                DB 2                    ; speed + direction
                DW snake1a_sprite       ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW snake2b_object       ; pointer to next anim object
                DB -7                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB 2                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB SPECIAL_RIGHT_SNAKE  ; special flag
snake2b_object:
                DB 2                    ; speed + direction
                DW snake1b_sprite       ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW snake2c_object       ; pointer to next anim object
                DB -7                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB 2                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB SPECIAL_RIGHT_SNAKE  ; special flag
snake2c_object:
                DB 2                    ; speed + direction
                DW snake1c_sprite       ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW snake2d_object       ; pointer to next anim object
                DB -3                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB 2                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB SPECIAL_RIGHT_SNAKE  ; special flag
snake2d_object:
                DB 2                    ; speed + direction
                DW snake1b_sprite       ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW snake2a_object       ; pointer to next anim object
                DB -7                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB 1                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB SPECIAL_RIGHT_SNAKE  ; special flag
snake3a_sprite:
 if USE_LOOP_UNROLING !=1
                DB 10
 else
                DW (MAX_LINE_NUM-(10+1))*ONE_LINE_LENGTH
 endif
                DB  1*SPRITE_BLOW_UP,  4*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  4*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -4*SPRITE_BLOW_UP, -4*SPRITE_BLOW_UP
snake3a_object:
                DB -1                   ; speed + direction
                DW snake3a_sprite       ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 4                    ; anim delay value
                DW snake3b_object       ; pointer to next anim object
                DB -4                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB 2                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB SPECIAL_LEFT_SNAKE   ; special flag
snake3b_sprite:
 if USE_LOOP_UNROLING !=1
                DB 10
 else
                DW (MAX_LINE_NUM-(10+1))*ONE_LINE_LENGTH
 endif
                DB -1*SPRITE_BLOW_UP,  4*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -4*SPRITE_BLOW_UP
snake3b_object:
                DB -1                   ; speed + direction
                DW snake3b_sprite       ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 4                    ; anim delay value
                DW snake3c_object       ; pointer to next anim object
                DB -4                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB 2                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB SPECIAL_LEFT_SNAKE   ; special flag
snake3c_sprite:
 if USE_LOOP_UNROLING !=1
                DB 10
 else
                DW (MAX_LINE_NUM-(10+1))*ONE_LINE_LENGTH
 endif
                DB -2*SPRITE_BLOW_UP,  4*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -4*SPRITE_BLOW_UP
snake3c_object:
                DB -1                   ; speed + direction
                DW snake3c_sprite       ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 4                    ; anim delay value
                DW snake3d_object       ; pointer to next anim object
                DB -4                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB 2                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB SPECIAL_LEFT_SNAKE   ; special flag
snake3d_object:
                DB -1                   ; speed + direction
                DW snake3b_sprite       ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 4                    ; anim delay value
                DW snake3a_object       ; pointer to next anim object
                DB -4                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB 2                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB SPECIAL_LEFT_SNAKE   ; special flag

snake4a_object:
                DB -2                   ; speed + direction
                DW snake3a_sprite       ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW snake4b_object       ; pointer to next anim object
                DB -4                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB 2                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB SPECIAL_LEFT_SNAKE   ; special flag
snake4b_object:
                DB -2                   ; speed + direction
                DW snake3b_sprite       ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW snake4c_object       ; pointer to next anim object
                DB -4                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB 2                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB SPECIAL_LEFT_SNAKE   ; special flag
snake4c_object:
                DB -2                   ; speed + direction
                DW snake3c_sprite       ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW snake4d_object       ; pointer to next anim object
                DB -4                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB 2                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB SPECIAL_LEFT_SNAKE   ; special flag
snake4d_object:
                DB -2                   ; speed + direction
                DW snake3b_sprite       ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW snake4a_object       ; pointer to next anim object
                DB -4                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB 2                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB SPECIAL_LEFT_SNAKE   ; special flag
