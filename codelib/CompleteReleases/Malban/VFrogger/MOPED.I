; this file is part of vectrex frogger, written by Malban
; in March-April 1998
; all stuff contained here is public domain
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this file contains 'sprite' definition data for a motorcycle              ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
; for collision checking: SPRITES MUST HAVE THE LEFTMOST POINT AS STARTVECTOR (*)
; moped1 is moving to the left with a speed of -1
moped1a_sprite:
 if USE_LOOP_UNROLING !=1
                DB 19
 else
                DW (MAX_LINE_NUM-(19+1))*ONE_LINE_LENGTH
 endif
                DB  2*SPRITE_BLOW_UP,   4*SPRITE_BLOW_UP    ;
                DB -2*SPRITE_BLOW_UP,  -2*SPRITE_BLOW_UP    ;
                DB -2*SPRITE_BLOW_UP,   2*SPRITE_BLOW_UP    ;
                DB  1*SPRITE_BLOW_UP,   2*SPRITE_BLOW_UP    ;
                DB  0*SPRITE_BLOW_UP,   3*SPRITE_BLOW_UP    ;
                DB -1*SPRITE_BLOW_UP,  -1*SPRITE_BLOW_UP    ;
                DB  1*SPRITE_BLOW_UP,   3*SPRITE_BLOW_UP    ;
                DB -1*SPRITE_BLOW_UP,  -2*SPRITE_BLOW_UP    ;
                DB -1*SPRITE_BLOW_UP,   2*SPRITE_BLOW_UP    ;
                DB  1*SPRITE_BLOW_UP,  -3*SPRITE_BLOW_UP    ;
                DB -1*SPRITE_BLOW_UP,   1*SPRITE_BLOW_UP    ;         /
                DB -2*SPRITE_BLOW_UP,  -2*SPRITE_BLOW_UP    ;       //
                DB  0*SPRITE_BLOW_UP,  -2*SPRITE_BLOW_UP    ;      // \     -------
                DB  3*SPRITE_BLOW_UP,  -2*SPRITE_BLOW_UP    ;     /  I \  /      /
                DB -3*SPRITE_BLOW_UP,  -3*SPRITE_BLOW_UP    ;      /    \/      /
                DB  1*SPRITE_BLOW_UP,  -1*SPRITE_BLOW_UP    ;    /    /\         \
                DB  2*SPRITE_BLOW_UP,   1*SPRITE_BLOW_UP    ; */    /    \        \
                DB  1*SPRITE_BLOW_UP,   2*SPRITE_BLOW_UP    ;  \   /       \      /
                DB  1*SPRITE_BLOW_UP,   0*SPRITE_BLOW_UP    ;   \ /          \___/
                DB  0*SPRITE_BLOW_UP,  -2*SPRITE_BLOW_UP    ;
moped1a_object:
                DB -1                   ; speed + direction
                DW moped1a_sprite       ; graphic definition
                DB 14                   ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW moped1b_object       ; pointer to next anim object
                DB -1                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB -1                   ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag

moped1b_sprite:
 if USE_LOOP_UNROLING !=1
                DB 19
 else
                DW (MAX_LINE_NUM-(19+1))*ONE_LINE_LENGTH
 endif
                DB  2*SPRITE_BLOW_UP,   4*SPRITE_BLOW_UP    ;
                DB -2*SPRITE_BLOW_UP,  -2*SPRITE_BLOW_UP    ;
                DB -2*SPRITE_BLOW_UP,   2*SPRITE_BLOW_UP    ;
                DB  1*SPRITE_BLOW_UP,   2*SPRITE_BLOW_UP    ;
                DB  0*SPRITE_BLOW_UP,   3*SPRITE_BLOW_UP    ;
                DB -1*SPRITE_BLOW_UP,  -1*SPRITE_BLOW_UP    ;
                DB  1*SPRITE_BLOW_UP,   3*SPRITE_BLOW_UP    ;
                DB -1*SPRITE_BLOW_UP,   0*SPRITE_BLOW_UP    ;
                DB -1*SPRITE_BLOW_UP,   0*SPRITE_BLOW_UP    ;
                DB  1*SPRITE_BLOW_UP,  -3*SPRITE_BLOW_UP    ;
                DB -1*SPRITE_BLOW_UP,   1*SPRITE_BLOW_UP    ;         /
                DB -2*SPRITE_BLOW_UP,  -2*SPRITE_BLOW_UP    ;       //
                DB  0*SPRITE_BLOW_UP,  -2*SPRITE_BLOW_UP    ;      // \     -------
                DB  3*SPRITE_BLOW_UP,  -2*SPRITE_BLOW_UP    ;     /  I \  /      /
                DB -3*SPRITE_BLOW_UP,  -3*SPRITE_BLOW_UP    ;      /    \/      /
                DB  1*SPRITE_BLOW_UP,  -1*SPRITE_BLOW_UP    ;    /    /\         \
                DB  2*SPRITE_BLOW_UP,   1*SPRITE_BLOW_UP    ; */    /    \        \
                DB  1*SPRITE_BLOW_UP,   2*SPRITE_BLOW_UP    ;  \   /       \      /
                DB  1*SPRITE_BLOW_UP,   0*SPRITE_BLOW_UP    ;   \ /          \___/
                DB  0*SPRITE_BLOW_UP,  -2*SPRITE_BLOW_UP    ;
moped1b_object:
                DB -1                   ; speed + direction
                DW moped1b_sprite       ; graphic definition
                DB 14                   ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW moped1c_object       ; pointer to next anim object
                DB -1                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB -1                   ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag

moped1c_sprite:
 if USE_LOOP_UNROLING !=1
                DB 19
 else
                DW (MAX_LINE_NUM-(19+1))*ONE_LINE_LENGTH
 endif
                DB  2*SPRITE_BLOW_UP,   4*SPRITE_BLOW_UP    ;
                DB -2*SPRITE_BLOW_UP,  -2*SPRITE_BLOW_UP    ;
                DB -2*SPRITE_BLOW_UP,   2*SPRITE_BLOW_UP    ;
                DB  1*SPRITE_BLOW_UP,   2*SPRITE_BLOW_UP    ;
                DB  0*SPRITE_BLOW_UP,   3*SPRITE_BLOW_UP    ;
                DB -1*SPRITE_BLOW_UP,  -1*SPRITE_BLOW_UP    ;
                DB  1*SPRITE_BLOW_UP,   3*SPRITE_BLOW_UP    ;
                DB -1*SPRITE_BLOW_UP,   2*SPRITE_BLOW_UP    ;
                DB -1*SPRITE_BLOW_UP,  -2*SPRITE_BLOW_UP    ;
                DB  1*SPRITE_BLOW_UP,  -3*SPRITE_BLOW_UP    ;
                DB -1*SPRITE_BLOW_UP,   1*SPRITE_BLOW_UP    ;         /
                DB -2*SPRITE_BLOW_UP,  -2*SPRITE_BLOW_UP    ;       //
                DB  0*SPRITE_BLOW_UP,  -2*SPRITE_BLOW_UP    ;      // \     -------
                DB  3*SPRITE_BLOW_UP,  -2*SPRITE_BLOW_UP    ;     /  I \  /      /
                DB -3*SPRITE_BLOW_UP,  -3*SPRITE_BLOW_UP    ;      /    \/      /
                DB  1*SPRITE_BLOW_UP,  -1*SPRITE_BLOW_UP    ;    /    /\         \
                DB  2*SPRITE_BLOW_UP,   1*SPRITE_BLOW_UP    ; */    /    \        \
                DB  1*SPRITE_BLOW_UP,   2*SPRITE_BLOW_UP    ;  \   /       \      /
                DB  1*SPRITE_BLOW_UP,   0*SPRITE_BLOW_UP    ;   \ /          \___/
                DB  0*SPRITE_BLOW_UP,  -2*SPRITE_BLOW_UP    ;
moped1c_object:
                DB -1                   ; speed + direction
                DW moped1c_sprite       ; graphic definition
                DB 14                   ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW moped1d_object       ; pointer to next anim object
                DB -1                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB -1                   ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag

moped1d_object:
                DB -1                   ; speed + direction
                DW moped1b_sprite       ; graphic definition
                DB 14                   ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW moped1a_object       ; pointer to next anim object
                DB -1                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB -1                   ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
moped2a_object:
                DB -2                   ; speed + direction
                DW moped1a_sprite       ; graphic definition
                DB 14                   ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW moped2b_object       ; pointer to next anim object
                DB -1                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB -1                   ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
moped2b_object:
                DB -2                   ; speed + direction
                DW moped1b_sprite       ; graphic definition
                DB 14                   ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW moped2c_object       ; pointer to next anim object
                DB -1                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB -1                   ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
moped2c_object:
                DB -2                   ; speed + direction
                DW moped1c_sprite       ; graphic definition
                DB 14                   ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW moped2d_object       ; pointer to next anim object
                DB -1                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB -1                   ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
moped2d_object:
                DB -2                   ; speed + direction
                DW moped1b_sprite       ; graphic definition
                DB 14                   ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW moped2a_object       ; pointer to next anim object
                DB -1                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB -1                   ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
moped3a_object:
                DB -3                   ; speed + direction
                DW moped1a_sprite       ; graphic definition
                DB 14                   ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW moped3b_object       ; pointer to next anim object
                DB -1                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB -1                   ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
moped3b_object:
                DB -3                   ; speed + direction
                DW moped1b_sprite       ; graphic definition
                DB 14                   ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW moped3c_object       ; pointer to next anim object
                DB -1                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB -1                   ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
moped3c_object:
                DB -3                   ; speed + direction
                DW moped1c_sprite       ; graphic definition
                DB 14                   ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW moped3d_object       ; pointer to next anim object
                DB -1                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB -1                   ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
moped3d_object:
                DB -3                   ; speed + direction
                DW moped1b_sprite       ; graphic definition
                DB 14                   ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW moped3a_object       ; pointer to next anim object
                DB -1                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB -1                   ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
