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
LOG_SMALL_LENGTH    EQU      34 

LOG_LEFT_Y_OFFSET EQU -0

BLOW_UP equ 25

log2a_sprite: 
                    DW       (MAX_LINE_NUM-($d+1))*ONE_LINE_LENGTH 
 DB -$03*BLOW_UP, -$01*BLOW_UP ; draw to y, x
 DB -$01*BLOW_UP, +$02*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, +$04*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, +$04*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, +$05*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, +$03*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, +$05*BLOW_UP ; draw to y, x
 DB +$03*BLOW_UP, -$01*BLOW_UP ; draw to y, x
 DB +$01*BLOW_UP, +$01*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, -$04*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, -$04*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, -$05*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, -$05*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, -$04*BLOW_UP ; draw to y, x

log2b_sprite: 
                    DW       (MAX_LINE_NUM-($d+1))*ONE_LINE_LENGTH 
 DB -$02*BLOW_UP, -$01*BLOW_UP ; draw to y, x
 DB -$02*BLOW_UP, +$01*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, +$04*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, +$05*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, +$05*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, +$04*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, +$04*BLOW_UP ; draw to y, x
 DB +$02*BLOW_UP, -$01*BLOW_UP ; draw to y, x
 DB +$02*BLOW_UP, +$01*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, -$04*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, -$04*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, -$05*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, -$05*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, -$04*BLOW_UP ; draw to y, x
log2c_sprite: 
                    DW       (MAX_LINE_NUM-($d+1))*ONE_LINE_LENGTH 
 DB -$01*BLOW_UP, -$01*BLOW_UP ; draw to y, x
 DB -$03*BLOW_UP, +$01*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, +$04*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, +$05*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, +$05*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, +$04*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, +$04*BLOW_UP ; draw to y, x
 DB +$01*BLOW_UP, -$01*BLOW_UP ; draw to y, x
 DB +$03*BLOW_UP, +$01*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, -$04*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, -$04*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, -$05*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, -$05*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, -$04*BLOW_UP ; draw to y, x

log1a_sprite: 
                    DW       (MAX_LINE_NUM-($d+1))*ONE_LINE_LENGTH 
 DB +$00*BLOW_UP, +$04*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, +$04*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, +$05*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, +$05*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, +$04*BLOW_UP ; draw to y, x
 DB -$03*BLOW_UP, +$01*BLOW_UP ; draw to y, x
 DB -$01*BLOW_UP, -$02*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, -$04*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, -$04*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, -$05*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, -$03*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, -$05*BLOW_UP ; draw to y, x
 DB +$03*BLOW_UP, +$01*BLOW_UP ; draw to y, x
 DB +$01*BLOW_UP, -$01*BLOW_UP ; draw to y, x
log1a_object: 
                    DB       1                            ; speed + direction 
                    DW       log1a_sprite                 ; graphic definition 
                    DB       LOG_SMALL_LENGTH             ; length in SCALE_FACTOR_GAME 
                    DB       4                            ; anim delay value 
                    DW       log1b_object                 ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       -2                           ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
log1b_sprite: 
                    DW       (MAX_LINE_NUM-($d+1))*ONE_LINE_LENGTH 
 DB +$00*BLOW_UP, +$04*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, +$04*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, +$05*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, +$05*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, +$04*BLOW_UP ; draw to y, x
 DB -$02*BLOW_UP, +$01*BLOW_UP ; draw to y, x
 DB -$02*BLOW_UP, -$01*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, -$04*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, -$05*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, -$05*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, -$04*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, -$04*BLOW_UP ; draw to y, x
 DB +$02*BLOW_UP, +$01*BLOW_UP ; draw to y, x
 DB +$02*BLOW_UP, -$01*BLOW_UP ; draw to y, x
log1b_object: 
                    DB       1                            ; speed + direction 
                    DW       log1b_sprite                 ; graphic definition 
                    DB       LOG_SMALL_LENGTH             ; length in SCALE_FACTOR_GAME 
                    DB       4                            ; anim delay value 
                    DW       log1c_object                 ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       -2                           ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
log1c_sprite: 
                    DW       (MAX_LINE_NUM-($d+1))*ONE_LINE_LENGTH 
 DB +$00*BLOW_UP, +$04*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, +$04*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, +$05*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, +$05*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, +$03*BLOW_UP ; draw to y, x
 DB -$01*BLOW_UP, +$02*BLOW_UP ; draw to y, x
 DB -$03*BLOW_UP, -$01*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, -$04*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, -$05*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, -$05*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, -$04*BLOW_UP ; draw to y, x
 DB +$00*BLOW_UP, -$04*BLOW_UP ; draw to y, x
 DB +$01*BLOW_UP, +$01*BLOW_UP ; draw to y, x
 DB +$03*BLOW_UP, -$01*BLOW_UP ; draw to y, x
log1c_object: 
                    DB       1                            ; speed + direction 
                    DW       log1c_sprite                 ; graphic definition 
                    DB       LOG_SMALL_LENGTH             ; length in SCALE_FACTOR_GAME 
                    DB       4                            ; anim delay value 
                    DW       log1d_object                 ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       -2                           ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
log1d_object: 
                    DB       1                            ; speed + direction 
                    DW       log1b_sprite                 ; graphic definition 
                    DB       LOG_SMALL_LENGTH             ; length in SCALE_FACTOR_GAME 
                    DB       4                            ; anim delay value 
                    DW       log1a_object                 ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       -2                           ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
log2a_object: 
                    DB       -1                           ; speed + direction 
                    DW       log2a_sprite                 ; graphic definition 
                    DB       LOG_SMALL_LENGTH             ; length in SCALE_FACTOR_GAME 
                    DB       4                            ; anim delay value 
                    DW       log2b_object                 ; pointer to next anim object 
                    DB       2 +LOG_LEFT_Y_OFFSET                           ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       -2                           ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
log2b_object: 
                    DB       -1                           ; speed + direction 
                    DW       log2b_sprite                 ; graphic definition 
                    DB       LOG_SMALL_LENGTH             ; length in SCALE_FACTOR_GAME 
                    DB       4                            ; anim delay value 
                    DW       log2c_object                 ; pointer to next anim object 
                    DB       2 +LOG_LEFT_Y_OFFSET                           ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       -2                           ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
log2c_object: 
                    DB       -1                           ; speed + direction 
                    DW       log2c_sprite                 ; graphic definition 
                    DB       LOG_SMALL_LENGTH             ; length in SCALE_FACTOR_GAME 
                    DB       4                            ; anim delay value 
                    DW       log2d_object                 ; pointer to next anim object 
                    DB       2 +LOG_LEFT_Y_OFFSET                           ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       -2                           ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
log2d_object: 
                    DB       -1                           ; speed + direction 
                    DW       log2b_sprite                 ; graphic definition 
                    DB       LOG_SMALL_LENGTH             ; length in SCALE_FACTOR_GAME 
                    DB       4                            ; anim delay value 
                    DW       log2a_object                 ; pointer to next anim object 
                    DB       2 +LOG_LEFT_Y_OFFSET                           ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       -2                           ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
log7a_object: 
                    DB       2                            ; speed + direction 
                    DW       log1a_sprite                 ; graphic definition 
                    DB       LOG_SMALL_LENGTH             ; length in SCALE_FACTOR_GAME 
                    DB       4                            ; anim delay value 
                    DW       log7b_object                 ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       -2                           ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
log7b_object: 
                    DB       2                            ; speed + direction 
                    DW       log1b_sprite                 ; graphic definition 
                    DB       LOG_SMALL_LENGTH             ; length in SCALE_FACTOR_GAME 
                    DB       4                            ; anim delay value 
                    DW       log7c_object                 ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       -2                           ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
log7c_object: 
                    DB       2                            ; speed + direction 
                    DW       log1c_sprite                 ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       4                            ; anim delay value 
                    DW       log7d_object                 ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       -2                           ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
log7d_object: 
                    DB       2                            ; speed + direction 
                    DW       log1b_sprite                 ; graphic definition 
                    DB       LOG_SMALL_LENGTH             ; length in SCALE_FACTOR_GAME 
                    DB       4                            ; anim delay value 
                    DW       log7a_object                 ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       -2                           ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
log8a_object: 
                    DB       -2                           ; speed + direction 
                    DW       log2a_sprite                 ; graphic definition 
                    DB       LOG_SMALL_LENGTH             ; length in SCALE_FACTOR_GAME 
                    DB       4                            ; anim delay value 
                    DW       log8b_object                 ; pointer to next anim object 
                    DB       2 +LOG_LEFT_Y_OFFSET                           ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       -2                           ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
log8b_object: 
                    DB       -2                           ; speed + direction 
                    DW       log2b_sprite                 ; graphic definition 
                    DB       LOG_SMALL_LENGTH             ; length in SCALE_FACTOR_GAME 
                    DB       4                            ; anim delay value 
                    DW       log8c_object                 ; pointer to next anim object 
                    DB       2  +LOG_LEFT_Y_OFFSET                          ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       -2                           ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
log8c_object: 
                    DB       -2                           ; speed + direction 
                    DW       log2c_sprite                 ; graphic definition 
                    DB       LOG_SMALL_LENGTH             ; length in SCALE_FACTOR_GAME 
                    DB       4                            ; anim delay value 
                    DW       log8d_object                 ; pointer to next anim object 
                    DB       2 +LOG_LEFT_Y_OFFSET                           ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       -2                           ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
log8d_object: 
                    DB       -2                           ; speed + direction 
                    DW       log2b_sprite                 ; graphic definition 
                    DB       LOG_SMALL_LENGTH             ; length in SCALE_FACTOR_GAME 
                    DB       4                            ; anim delay value 
                    DW       log8a_object                 ; pointer to next anim object 
                    DB       2  +LOG_LEFT_Y_OFFSET                          ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       -2                           ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 

