; this file is part of vectrex frogger, written by Malban
; in March-April 1998
; all stuff contained here is public domain
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this file contains 'sprite' definition data for logs                      ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
; for collision checking: SPRITES MUST HAVE THE LEFTMOST POINT AS STARTVECTOR (*)
; log1 is moving right with a speed of 1
; log2 is moving left with a speed of -1
 db 11
log1a_sprite:
                DW (MAX_LINE_NUM-(11+1))*ONE_LINE_LENGTH
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB -4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  3*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  3*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB  4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
log1a_object:
                DB 1                    ; speed + direction
                DW log1a_sprite         ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 4                    ; anim delay value
                DW log1b_object         ; pointer to next anim object
                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB -2                   ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
 db 11
log1b_sprite:
                DW (MAX_LINE_NUM-(11+1))*ONE_LINE_LENGTH
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB -4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB  4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
log1b_object:
                DB 1                    ; speed + direction
                DW log1b_sprite         ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 4                    ; anim delay value
                DW log1c_object         ; pointer to next anim object
                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB -2                   ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag

 db 11
log1c_sprite:
                DW (MAX_LINE_NUM-(11+1))*ONE_LINE_LENGTH
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB -4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB  4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP

log1c_object:
                DB 1                    ; speed + direction
                DW log1c_sprite         ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 4                    ; anim delay value
                DW log1d_object         ; pointer to next anim object
                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB -2                   ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
 db 11
log1d_sprite:
                DW (MAX_LINE_NUM-(11+1))*ONE_LINE_LENGTH
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB -4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB -3*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  4*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB -3*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB  4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
log1d_object:
                DB 1                    ; speed + direction
                DW log1d_sprite         ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 4                    ; anim delay value
                DW log1e_object         ; pointer to next anim object
                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB -2                   ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
log1e_object:
                DB 1                    ; speed + direction
                DW log1c_sprite         ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 4                    ; anim delay value
                DW log1f_object         ; pointer to next anim object
                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB -2                   ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
log1f_object:
                DB 1                    ; speed + direction
                DW log1b_sprite         ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 4                    ; anim delay value
                DW log1a_object         ; pointer to next anim object
                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB -2                   ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag


log2a_object:
                DB -1                   ; speed + direction
                DW log1a_sprite         ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 4                    ; anim delay value
                DW log2b_object         ; pointer to next anim object
                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB -2                   ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
log2b_object:
                DB -1                   ; speed + direction
                DW log1b_sprite         ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 4                    ; anim delay value
                DW log2c_object         ; pointer to next anim object
                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB -2                   ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
log2c_object:
                DB -1                   ; speed + direction
                DW log1c_sprite         ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 4                    ; anim delay value
                DW log2d_object         ; pointer to next anim object
                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB -2                   ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
log2d_object:
                DB -1                   ; speed + direction
                DW log1d_sprite         ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 4                    ; anim delay value
                DW log2e_object         ; pointer to next anim object
                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB -2                   ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
log2e_object:
                DB -1                   ; speed + direction
                DW log1c_sprite         ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 4                    ; anim delay value
                DW log2f_object         ; pointer to next anim object
                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB -2                   ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
log2f_object:
                DB -1                   ; speed + direction
                DW log1b_sprite         ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 4                    ; anim delay value
                DW log2a_object         ; pointer to next anim object
                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB -2                   ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
 db 10
log3a_sprite:
                DW (MAX_LINE_NUM-(10+1))*ONE_LINE_LENGTH
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB  4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
log3a_object:
                DB -1                   ; speed + direction
                DW log3a_sprite         ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW log3b_object         ; pointer to next anim object
                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB 0                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag

log3b_sprite:
                DW (MAX_LINE_NUM-(10+1))*ONE_LINE_LENGTH
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB  4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
log3b_object:
                DB -1                   ; speed + direction
                DW log3b_sprite         ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW log3c_object         ; pointer to next anim object
                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB 0                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
 db 10
log3c_sprite:
                DW (MAX_LINE_NUM-(10+1))*ONE_LINE_LENGTH
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB  4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
log3c_object:
                DB -1                   ; speed + direction
                DW log3c_sprite         ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW log3d_object         ; pointer to next anim object
                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB 0                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
 db 10
log3d_sprite:
                DW (MAX_LINE_NUM-(10+1))*ONE_LINE_LENGTH
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB  4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
log3d_object:
                DB -1                   ; speed + direction
                DW log3d_sprite         ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW log3e_object         ; pointer to next anim object
                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB 0                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
log3e_object:
                DB -1                   ; speed + direction
                DW log3c_sprite         ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW log3f_object         ; pointer to next anim object
                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB 0                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
log3f_object:
                DB -1                   ; speed + direction
                DW log3b_sprite         ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW log3a_object         ; pointer to next anim object
                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB 0                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
 db 10
log4a_sprite:
                DW (MAX_LINE_NUM-(10+1))*ONE_LINE_LENGTH
                DB -2*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB  4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
log4a_object:
                DB -1                   ; speed + direction
                DW log4a_sprite         ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW log4b_object         ; pointer to next anim object
                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB 0                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
 db 10
log4b_sprite:
                DW (MAX_LINE_NUM-(10+1))*ONE_LINE_LENGTH
                DB -1*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB  4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
log4b_object:
                DB -1                   ; speed + direction
                DW log4b_sprite         ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW log4c_object         ; pointer to next anim object
                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB 0                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
 db 10
log4c_sprite:
                DW (MAX_LINE_NUM-(10+1))*ONE_LINE_LENGTH
                DB -2*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB  4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
log4c_object:
                DB -1                   ; speed + direction
                DW log4c_sprite         ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW log4d_object         ; pointer to next anim object
                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB 0                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
 db 10
log4d_sprite:
                DW (MAX_LINE_NUM-(10+1))*ONE_LINE_LENGTH
                DB -1*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB  4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
log4d_object:
                DB -1                   ; speed + direction
                DW log4d_sprite         ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW log4e_object         ; pointer to next anim object
                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB 0                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
log4e_object:
                DB -1                   ; speed + direction
                DW log4c_sprite         ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW log4f_object         ; pointer to next anim object
                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB 0                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
log4f_object:
                DB -1                   ; speed + direction
                DW log4b_sprite         ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW log4a_object         ; pointer to next anim object
                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB 0                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
;log5a_object:
;                DB 1                    ; speed + direction
;                DW log3a_sprite         ; graphic definition
;                DB 32                   ; length in SCALE_FACTOR_GAME
;                DB 3                    ; anim delay value
;                DW log5b_object         ; pointer to next anim object
;                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
;                DB 0                    ; offsets x in 'SCALE_FACTOR_GAME'
;                DB $60                  ; brightness
;                DB 0                    ; special flag
;log5b_object:
;                DB 1                    ; speed + direction
;                DW log3b_sprite         ; graphic definition
;                DB 32                   ; length in SCALE_FACTOR_GAME
;                DB 3                    ; anim delay value
;                DW log5c_object         ; pointer to next anim object
;                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
;                DB 0                    ; offsets x in 'SCALE_FACTOR_GAME'
;                DB $60                  ; brightness
;                DB 0                    ; special flag
;log5c_object:
;                DB 1                    ; speed + direction
;                DW log3c_sprite         ; graphic definition
;                DB 32                   ; length in SCALE_FACTOR_GAME
;                DB 3                    ; anim delay value
;                DW log5d_object         ; pointer to next anim object
;                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
;                DB 0                    ; offsets x in 'SCALE_FACTOR_GAME'
;                DB $60                  ; brightness
;                DB 0                    ; special flag
;log5d_object:
;                DB 1                    ; speed + direction
;                DW log3d_sprite         ; graphic definition
;                DB 32                   ; length in SCALE_FACTOR_GAME
;                DB 3                    ; anim delay value
;                DW log5e_object         ; pointer to next anim object
;                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
;                DB 0                    ; offsets x in 'SCALE_FACTOR_GAME'
;                DB $60                  ; brightness
;                DB 0                    ; special flag
;log5e_object:
;                DB 1                    ; speed + direction
;                DW log3c_sprite         ; graphic definition
;                DB 32                   ; length in SCALE_FACTOR_GAME
;                DB 3                    ; anim delay value
;                DW log5f_object         ; pointer to next anim object
;                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
;                DB 0                    ; offsets x in 'SCALE_FACTOR_GAME'
;                DB $60                  ; brightness
;                DB 0                    ; special flag
;log5f_object:
;                DB 1                    ; speed + direction
;                DW log3b_sprite         ; graphic definition
;                DB 32                   ; length in SCALE_FACTOR_GAME
;                DB 3                    ; anim delay value
;                DW log5a_object         ; pointer to next anim object
;                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
;                DB 0                    ; offsets x in 'SCALE_FACTOR_GAME'
;                DB $60                  ; brightness
;                DB 0                    ; special flag
;log6a_object:
;                DB 1                    ; speed + direction
;                DW log4a_sprite         ; graphic definition
;                DB 32                   ; length in SCALE_FACTOR_GAME
;                DB 3                    ; anim delay value
;                DW log6b_object         ; pointer to next anim object
;                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
;                DB 0                    ; offsets x in 'SCALE_FACTOR_GAME'
;                DB $60                  ; brightness
;                DB 0                    ; special flag
;log6b_object:
;                DB 1                    ; speed + direction
;                DW log4b_sprite         ; graphic definition
;                DB 32                   ; length in SCALE_FACTOR_GAME
;                DB 3                    ; anim delay value
;                DW log6c_object         ; pointer to next anim object
;                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
;                DB 0                    ; offsets x in 'SCALE_FACTOR_GAME'
;                DB $60                  ; brightness
;                DB 0                    ; special flag
;log6c_object:
;                DB 1                    ; speed + direction
;                DW log4c_sprite         ; graphic definition
;                DB 32                   ; length in SCALE_FACTOR_GAME
;                DB 3                    ; anim delay value
;                DW log6d_object         ; pointer to next anim object
;                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
;                DB 0                    ; offsets x in 'SCALE_FACTOR_GAME'
;                DB $60                  ; brightness
;                DB 0                    ; special flag
;log6d_object:
;                DB 1                    ; speed + direction
;                DW log4d_sprite         ; graphic definition
;                DB 32                   ; length in SCALE_FACTOR_GAME
;                DB 3                    ; anim delay value
;                DW log6e_object         ; pointer to next anim object
;                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
;                DB 0                    ; offsets x in 'SCALE_FACTOR_GAME'
;                DB $60                  ; brightness
;                DB 0                    ; special flag
;log6e_object:
;                DB 1                    ; speed + direction
;                DW log4c_sprite         ; graphic definition
;                DB 32                   ; length in SCALE_FACTOR_GAME
;                DB 3                    ; anim delay value
;                DW log6f_object         ; pointer to next anim object
;                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
;                DB 0                    ; offsets x in 'SCALE_FACTOR_GAME'
;                DB $60                  ; brightness
;                DB 0                    ; special flag
;log6f_object:
;                DB 1                    ; speed + direction
;                DW log4b_sprite         ; graphic definition
;                DB 32                   ; length in SCALE_FACTOR_GAME
;                DB 3                    ; anim delay value
;                DW log6a_object         ; pointer to next anim object
;                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
;                DB 0                    ; offsets x in 'SCALE_FACTOR_GAME'
;                DB $60                  ; brightness
;                DB 0                    ; special flag
log7a_object:
                DB 2                    ; speed + direction
                DW log1a_sprite         ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 4                    ; anim delay value
                DW log7b_object         ; pointer to next anim object
                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB -2                   ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
log7b_object:
                DB 2                    ; speed + direction
                DW log1b_sprite         ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 4                    ; anim delay value
                DW log7c_object         ; pointer to next anim object
                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB -2                   ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
log7c_object:
                DB 2                    ; speed + direction
                DW log1c_sprite         ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 4                    ; anim delay value
                DW log7d_object         ; pointer to next anim object
                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB -2                   ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
log7d_object:
                DB 2                    ; speed + direction
                DW log1d_sprite         ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 4                    ; anim delay value
                DW log7e_object         ; pointer to next anim object
                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB -2                   ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
log7e_object:
                DB 2                    ; speed + direction
                DW log1c_sprite         ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 4                    ; anim delay value
                DW log7f_object         ; pointer to next anim object
                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB -2                   ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
log7f_object:
                DB 2                    ; speed + direction
                DW log1b_sprite         ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 4                    ; anim delay value
                DW log7a_object         ; pointer to next anim object
                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB -2                   ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
log8a_object:
                DB -2                   ; speed + direction
                DW log1a_sprite         ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 4                    ; anim delay value
                DW log8b_object         ; pointer to next anim object
                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB -2                   ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
log8b_object:
                DB -2                   ; speed + direction
                DW log1b_sprite         ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 4                    ; anim delay value
                DW log8c_object         ; pointer to next anim object
                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB -2                   ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
log8c_object:
                DB -2                   ; speed + direction
                DW log1c_sprite         ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 4                    ; anim delay value
                DW log8d_object         ; pointer to next anim object
                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB -2                   ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
log8d_object:
                DB -2                   ; speed + direction
                DW log1d_sprite         ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 4                    ; anim delay value
                DW log8e_object         ; pointer to next anim object
                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB -2                   ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
log8e_object:
                DB -2                   ; speed + direction
                DW log1c_sprite         ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 4                    ; anim delay value
                DW log8f_object         ; pointer to next anim object
                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB -2                   ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
log8f_object:
                DB -2                   ; speed + direction
                DW log1b_sprite         ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 4                    ; anim delay value
                DW log8a_object         ; pointer to next anim object
                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB -2                   ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
log9a_object:
                DB -2                   ; speed + direction
                DW log3a_sprite         ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW log9b_object         ; pointer to next anim object
                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB 0                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
log9b_object:
                DB -2                   ; speed + direction
                DW log3b_sprite         ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW log9c_object         ; pointer to next anim object
                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB 0                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
log9c_object:
                DB -2                   ; speed + direction
                DW log3c_sprite         ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW log9d_object         ; pointer to next anim object
                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB 0                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
log9d_object:
                DB -2                   ; speed + direction
                DW log3d_sprite         ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW log9e_object         ; pointer to next anim object
                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB 0                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
log9e_object:
                DB -2                   ; speed + direction
                DW log3c_sprite         ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW log9f_object         ; pointer to next anim object
                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB 0                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
log9f_object:
                DB -2                   ; speed + direction
                DW log3b_sprite         ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW log9a_object         ; pointer to next anim object
                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB 0                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
log10a_object:
                DB -2                   ; speed + direction
                DW log4a_sprite         ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW log10b_object        ; pointer to next anim object
                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB 0                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
log10b_object:
                DB -2                   ; speed + direction
                DW log4b_sprite         ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW log10c_object        ; pointer to next anim object
                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB 0                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
log10c_object:
                DB -2                   ; speed + direction
                DW log4c_sprite         ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW log10d_object        ; pointer to next anim object
                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB 0                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
log10d_object:
                DB -2                   ; speed + direction
                DW log4d_sprite         ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW log10e_object        ; pointer to next anim object
                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB 0                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
log10e_object:
                DB -2                   ; speed + direction
                DW log4c_sprite         ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW log10f_object        ; pointer to next anim object
                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB 0                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
log10f_object:
                DB -2                   ; speed + direction
                DW log4b_sprite         ; graphic definition
                DB 32                   ; length in SCALE_FACTOR_GAME
                DB 3                    ; anim delay value
                DW log10a_object        ; pointer to next anim object
                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB 0                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB 0                    ; special flag
;log11a_object:
;                DB 2                    ; speed + direction
;                DW log3a_sprite         ; graphic definition
;                DB 32                   ; length in SCALE_FACTOR_GAME
;                DB 3                    ; anim delay value
;                DW log11b_object        ; pointer to next anim object
;                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
;                DB 0                    ; offsets x in 'SCALE_FACTOR_GAME'
;                DB $60                  ; brightness
;                DB 0                    ; special flag
;log11b_object:
;                DB 2                    ; speed + direction
;                DW log3b_sprite         ; graphic definition
;                DB 32                   ; length in SCALE_FACTOR_GAME
;                DB 3                    ; anim delay value
;                DW log11c_object        ; pointer to next anim object
;                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
;                DB 0                    ; offsets x in 'SCALE_FACTOR_GAME'
;                DB $60                  ; brightness
;                DB 0                    ; special flag
;log11c_object:
;                DB 2                    ; speed + direction
;                DW log3c_sprite         ; graphic definition
;                DB 32                   ; length in SCALE_FACTOR_GAME
;                DB 3                    ; anim delay value
;                DW log11d_object        ; pointer to next anim object
;                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
;                DB 0                    ; offsets x in 'SCALE_FACTOR_GAME'
;                DB $60                  ; brightness
;                DB 0                    ; special flag
;log11d_object:
;                DB 2                    ; speed + direction
;                DW log3d_sprite         ; graphic definition
;                DB 32                   ; length in SCALE_FACTOR_GAME
;                DB 3                    ; anim delay value
;                DW log11e_object        ; pointer to next anim object
;                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
;                DB 0                    ; offsets x in 'SCALE_FACTOR_GAME'
;                DB $60                  ; brightness
;                DB 0                    ; special flag
;log11e_object:
;                DB 2                    ; speed + direction
;                DW log3c_sprite         ; graphic definition
;                DB 32                   ; length in SCALE_FACTOR_GAME
;                DB 3                    ; anim delay value
;                DW log11f_object        ; pointer to next anim object
;                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
;                DB 0                    ; offsets x in 'SCALE_FACTOR_GAME'
;                DB $60                  ; brightness
;                DB 0                    ; special flag
;log11f_object:
;                DB 2                    ; speed + direction
;                DW log3b_sprite         ; graphic definition
;                DB 32                   ; length in SCALE_FACTOR_GAME
;                DB 3                    ; anim delay value
;                DW log11a_object        ; pointer to next anim object
;                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
;                DB 0                    ; offsets x in 'SCALE_FACTOR_GAME'
;                DB $60                  ; brightness
;                DB 0                    ; special flag
;log12a_object:
;                DB 2                    ; speed + direction
;                DW log4a_sprite         ; graphic definition
;                DB 32                   ; length in SCALE_FACTOR_GAME
;                DB 3                    ; anim delay value
;                DW log12b_object        ; pointer to next anim object
;                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
;                DB 0                    ; offsets x in 'SCALE_FACTOR_GAME'
;                DB $60                  ; brightness
;                DB 0                    ; special flag
;log12b_object:
;                DB 2                    ; speed + direction
;                DW log4b_sprite         ; graphic definition
;                DB 32                   ; length in SCALE_FACTOR_GAME
;                DB 3                    ; anim delay value
;                DW log12c_object        ; pointer to next anim object
;                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
;                DB 0                    ; offsets x in 'SCALE_FACTOR_GAME'
;                DB $60                  ; brightness
;                DB 0                    ; special flag
;log12c_object:
;                DB 2                    ; speed + direction
;                DW log4c_sprite         ; graphic definition
;                DB 32                   ; length in SCALE_FACTOR_GAME
;                DB 3                    ; anim delay value
;                DW log12d_object        ; pointer to next anim object
;                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
;                DB 0                    ; offsets x in 'SCALE_FACTOR_GAME'
;                DB $60                  ; brightness
;                DB 0                    ; special flag
;log12d_object:
;                DB 2                    ; speed + direction
;                DW log4d_sprite         ; graphic definition
;                DB 32                   ; length in SCALE_FACTOR_GAME
;                DB 3                    ; anim delay value
;                DW log12e_object        ; pointer to next anim object
;                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
;                DB 0                    ; offsets x in 'SCALE_FACTOR_GAME'
;                DB $60                  ; brightness
;                DB 0                    ; special flag
;log12e_object:
;                DB 2                    ; speed + direction
;                DW log4c_sprite         ; graphic definition
;                DB 32                   ; length in SCALE_FACTOR_GAME
;                DB 3                    ; anim delay value
;                DW log12f_object        ; pointer to next anim object
;                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
;                DB 0                    ; offsets x in 'SCALE_FACTOR_GAME'
;                DB $60                  ; brightness
;                DB 0                    ; special flag
;log12f_object:
;                DB 2                    ; speed + direction
;                DW log4b_sprite         ; graphic definition
;                DB 32                   ; length in SCALE_FACTOR_GAME
;                DB 3                    ; anim delay value
;                DW log12a_object        ; pointer to next anim object
;                DB 2                    ; offsets y in 'SCALE_FACTOR_GAME'
;                DB 0                    ; offsets x in 'SCALE_FACTOR_GAME'
;                DB $60                  ; brightness
;                DB 0                    ; special flag
