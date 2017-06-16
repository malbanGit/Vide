; this file is part of vectrex frogger, written by Malban
; in March-April 1998
; all stuff contained here is public domain
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this file contains 'sprite' definition data for crocodiles                ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
;croco1a_sprite:
; if USE_LOOP_UNROLING !=1
;                DB 13
; else
;                DW (MAX_LINE_NUM-(13+1))*ONE_LINE_LENGTH
; endif
;                DB  3*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
;                DB -2*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
;                DB  2*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
;                DB -2*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
;                DB  1*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
;                DB -1*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
;                DB -1*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
;                DB -1*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
;                DB  1*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
;                DB -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
;                DB  1*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
;                DB -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
;                DB  1*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
;                DB  0*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
;croco1a_object:
;                DB 1                    ; speed + direction
;                DW croco1a_sprite       ; graphic definition
;                DB 34                   ; length in SCALE_FACTOR_GAME
;                DB 5                    ; anim delay value
;                DW croco1b_object       ; pointer to next anim object
;                DB 0                    ; offsets y in 'SCALE_FACTOR_GAME'
;                DB 1                    ; offsets x in 'SCALE_FACTOR_GAME'
;                DB $60                  ; brightness
;                DB SPECIAL_RIGHT_CROCO  ; special flag
;croco1b_sprite:
; if USE_LOOP_UNROLING !=1
;                DB 13
; else
;                DW (MAX_LINE_NUM-(13+1))*ONE_LINE_LENGTH
; endif
;                DB  3*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
;                DB -2*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
;                DB  2*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
;                DB -2*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
;                DB  1*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
;                DB -1*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
;                DB -1*SPRITE_BLOW_UP, -4*SPRITE_BLOW_UP
;                DB -1*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
;                DB  1*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
;                DB -1*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
;                DB  1*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
;                DB -1*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
;                DB  1*SPRITE_BLOW_UP, -4*SPRITE_BLOW_UP
;                DB  0*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
;croco1b_object:
;                DB 1                    ; speed + direction
;                DW croco1b_sprite       ; graphic definition
;                DB 34                   ; length in SCALE_FACTOR_GAME
;                DB 5                    ; anim delay value
;                DW croco1c_object       ; pointer to next anim object
;                DB 0                    ; offsets y in 'SCALE_FACTOR_GAME'
;                DB 1                    ; offsets x in 'SCALE_FACTOR_GAME'
;                DB $60                  ; brightness
;                DB SPECIAL_RIGHT_CROCO  ; special flag
;croco1c_sprite:
; if USE_LOOP_UNROLING !=1
;                DB 11
; else
;                DW (MAX_LINE_NUM-(11+1))*ONE_LINE_LENGTH
; endif
;                DB  3*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
;                DB -2*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
;                DB  2*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
;                DB -2*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
;                DB  1*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
;                DB -2*SPRITE_BLOW_UP,  4*SPRITE_BLOW_UP
;                DB  0*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
;                DB -1*SPRITE_BLOW_UP, -4*SPRITE_BLOW_UP
;                DB  1*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
;                DB -1*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
;                DB  1*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
;                DB  0*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
;croco1c_object:
;                DB 1                    ; speed + direction
;                DW croco1c_sprite       ; graphic definition
;                DB 34                   ; length in SCALE_FACTOR_GAME
;                DB 5                    ; anim delay value
;                DW croco1a_object       ; pointer to next anim object
;                DB 0                    ; offsets y in 'SCALE_FACTOR_GAME'
;                DB 1                    ; offsets x in 'SCALE_FACTOR_GAME'
;                DB $60                  ; brightness
;                DB SPECIAL_RIGHT_CROCO  ; special flag
;croco2a_object:
;                DB 2                    ; speed + direction
;                DW croco1a_sprite       ; graphic definition
;                DB 34                   ; length in SCALE_FACTOR_GAME
;                DB 5                    ; anim delay value
;                DW croco2b_object       ; pointer to next anim object
;                DB 0                    ; offsets y in 'SCALE_FACTOR_GAME'
;                DB 1                    ; offsets x in 'SCALE_FACTOR_GAME'
;                DB $60                  ; brightness
;                DB SPECIAL_RIGHT_CROCO  ; special flag
;croco2b_object:
;                DB 2                    ; speed + direction
;                DW croco1b_sprite       ; graphic definition
;                DB 34                   ; length in SCALE_FACTOR_GAME
;                DB 5                    ; anim delay value
;                DW croco2c_object       ; pointer to next anim object
;                DB 0                    ; offsets y in 'SCALE_FACTOR_GAME'
;                DB 1                    ; offsets x in 'SCALE_FACTOR_GAME'
;                DB $60                  ; brightness
;                DB SPECIAL_RIGHT_CROCO  ; special flag
;croco2c_object:
;                DB 2                    ; speed + direction
;                DW croco1c_sprite       ; graphic definition
;                DB 34                   ; length in SCALE_FACTOR_GAME
;                DB 5                    ; anim delay value
;                DW croco2a_object       ; pointer to next anim object
;                DB 0                    ; offsets y in 'SCALE_FACTOR_GAME'
;                DB 1                    ; offsets x in 'SCALE_FACTOR_GAME'
;                DB $60                  ; brightness
;                DB SPECIAL_RIGHT_CROCO  ; special flag

 db 13
croco3a_sprite:
                DW (MAX_LINE_NUM-(13+1))*ONE_LINE_LENGTH
                DB -1*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  3*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
croco3a_object:
                DB -1                   ; speed + direction
                DW croco3a_sprite       ; graphic definition
                DB 34                   ; length in SCALE_FACTOR_GAME
                DB 5                    ; anim delay value
                DW croco3b_object       ; pointer to next anim object
                DB 0                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB 1                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB SPECIAL_LEFT_CROCO   ; special flag
 db 13

croco3b_sprite:
                DW (MAX_LINE_NUM-(13+1))*ONE_LINE_LENGTH
                DB -1*SPRITE_BLOW_UP,  4*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  4*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  3*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
croco3b_object:
                DB -1                   ; speed + direction
                DW croco3b_sprite       ; graphic definition
                DB 34                   ; length in SCALE_FACTOR_GAME
                DB 5                    ; anim delay value
                DW croco3c_object       ; pointer to next anim object
                DB 0                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB 1                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB SPECIAL_LEFT_CROCO   ; special flag
 db 11

croco3c_sprite:
                DW (MAX_LINE_NUM-(11+1))*ONE_LINE_LENGTH
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  4*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  3*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -4*SPRITE_BLOW_UP
croco3c_object:
                DB -1                   ; speed + direction
                DW croco3c_sprite       ; graphic definition
                DB 34                   ; length in SCALE_FACTOR_GAME
                DB 5                    ; anim delay value
                DW croco3a_object       ; pointer to next anim object
                DB -1                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB 2                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB SPECIAL_LEFT_CROCO   ; special flag

croco4a_object:
                DB -2                   ; speed + direction
                DW croco3a_sprite       ; graphic definition
                DB 34                   ; length in SCALE_FACTOR_GAME
                DB 5                    ; anim delay value
                DW croco4b_object       ; pointer to next anim object
                DB 0                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB 1                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB SPECIAL_LEFT_CROCO  ; special flag

croco4b_object:
                DB -2                   ; speed + direction
                DW croco3b_sprite       ; graphic definition
                DB 34                   ; length in SCALE_FACTOR_GAME
                DB 5                    ; anim delay value
                DW croco4c_object       ; pointer to next anim object
                DB 0                    ; offsets y in 'SCALE_FACTOR_GAME'
                DB 1                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB SPECIAL_LEFT_CROCO   ; special flag
croco4c_object:
                DB -2                   ; speed + direction
                DW croco3c_sprite       ; graphic definition
                DB 34                   ; length in SCALE_FACTOR_GAME
                DB 5                    ; anim delay value
                DW croco4a_object       ; pointer to next anim object
                DB -1                   ; offsets y in 'SCALE_FACTOR_GAME'
                DB 2                    ; offsets x in 'SCALE_FACTOR_GAME'
                DB $60                  ; brightness
                DB SPECIAL_LEFT_CROCO   ; special flag
 db 12

crocoh1a_sprite:
                DB 12
                DB -1*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
crocoh1a_object:

                DB 0                    ; speed + direction
                DW crocoh1a_sprite      ; graphic definition
                DB 0                    ; length in SCALE_FACTOR_GAME
                DB $20                  ; anim delay value
                DW crocoh1b_object      ; pointer to next anim object
                DB 0                    ; offsets y in 'SCALE_IN_HOME', since this is a home object
                DB 0                    ; offsets x in 'SCALE_IN_HOME', since this is a home object
                DB $60                  ; brightness
                DB SPECIAL_CROCO_HALF   ; special flag
 db 15

crocoh1b_sprite:
                DB 15
                DB -1*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
crocoh1b_object:
                DB 0                    ; speed + direction
                DW crocoh1b_sprite      ; graphic definition
                DB 0                    ; length in SCALE_FACTOR_GAME
                DB $20                  ; anim delay value
                DW crocoh1c_object      ; pointer to next anim object
                DB 0                    ; offsets y in 'SCALE_IN_HOME', since this is a home object
                DB 0                    ; offsets x in 'SCALE_IN_HOME', since this is a home object
                DB $60                  ; brightness
                DB SPECIAL_CROCO_HALF   ; special flag
 db 17

crocoh1c_sprite:
                DB 17
                DB -1*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  4*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB -4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
crocoh1c_object:
                DB 0                    ; speed + direction
                DW crocoh1c_sprite      ; graphic definition
                DB 0                    ; length in SCALE_FACTOR_GAME
                DB $05                  ; anim delay value
                DW crocoh1d_object      ; pointer to next anim object
                DB -7                   ; offsets y in 'SCALE_IN_HOME', since this is a home object
                DB 0                    ; offsets x in 'SCALE_IN_HOME', since this is a home object
                DB $60                  ; brightness
                DB SPECIAL_CROCO_FULL   ; special flag
 db 17

crocoh1d_sprite:
                DB 17
                DB -2*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  4*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB -4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
crocoh1d_object:
                DB 0                    ; speed + direction
                DW crocoh1d_sprite      ; graphic definition
                DB 0                    ; length in SCALE_FACTOR_GAME
                DB $05                  ; anim delay value
                DW crocoh1e_object      ; pointer to next anim object
                DB -7                  ; offsets y in 'SCALE_IN_HOME', since this is a home object
                DB -0                   ; offsets x in 'SCALE_IN_HOME', since this is a home object
                DB $60                  ; brightness
                DB SPECIAL_CROCO_FULL   ; special flag
 db 17

crocoh1e_sprite:
                DB 17
                DB -1*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  4*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB -4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
crocoh1e_object:
                DB 0                    ; speed + direction
                DW crocoh1e_sprite      ; graphic definition
                DB 0                    ; length in SCALE_FACTOR_GAME
                DB $05                  ; anim delay value
                DW crocoh1f_object      ; pointer to next anim object
                DB -7                   ; offsets y in 'SCALE_IN_HOME', since this is a home object
                DB -0                   ; offsets x in 'SCALE_IN_HOME', since this is a home object
                DB $60                  ; brightness
                DB SPECIAL_CROCO_FULL   ; special flag
crocoh1f_object:
                DB 0                    ; speed + direction
                DW crocoh1d_sprite      ; graphic definition
                DB 0                    ; length in SCALE_FACTOR_GAME
                DB $05                  ; anim delay value
                DW crocoh1c_object      ; pointer to next anim object
                DB -7                  ; offsets y in 'SCALE_IN_HOME', since this is a home object
                DB -0                   ; offsets x in 'SCALE_IN_HOME', since this is a home object
                DB $60                  ; brightness
                DB SPECIAL_CROCO_FULL   ; special flag
