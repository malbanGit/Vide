; this file is part of Karl Quappe, written by Malban
; in 2016
; all stuff contained here is public domain
;
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
CATER_Y_OFFSET      EQU      5    +1                        ;7 
CATER_X_OFFSET      EQU      0 
CATER_LENGTH        EQU      28 
CATER_Y_OFFSET_MINUS  EQU    2      +1                      ;7 
CATER_X_OFFSET_MINUS  EQU    0 
CATER_LENGTH_MINUS  EQU      28 
; sprite definition
car3a_sprite: 
                    DW       (MAX_LINE_NUM-($15+1))*ONE_LINE_LENGTH 
                    DB       -$04*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$04*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$04*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$03*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$03*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$05*BLOW_UP_VLISTS, +$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$05*BLOW_UP_VLISTS, +$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$04*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$04*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$04*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$05*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$05*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$03*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$03*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
caterpillar_1a_object: 
                    DB       1                            ; speed + direction 
                    DW       car3a_sprite                 ; graphic definition 
                    DB       CATER_LENGTH                 ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       caterpillar_1b_object        ; pointer to next anim object 
                    DB       CATER_Y_OFFSET               ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       CATER_X_OFFSET               ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
caterpillar_2a_object: 
                    DB       2                            ; speed + direction 
                    DW       car3a_sprite                 ; graphic definition 
                    DB       CATER_LENGTH                 ; length in SCALE_FACTOR_GAME 
                    DB       4                            ; anim delay value 
                    DW       caterpillar_2b_object        ; pointer to next anim object 
                    DB       CATER_Y_OFFSET               ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       CATER_X_OFFSET               ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
; sprite definition
car3b_sprite: 
                    DW       (MAX_LINE_NUM-($15+1))*ONE_LINE_LENGTH 
                    DB       -$04*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$04*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$04*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$03*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$03*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$05*BLOW_UP_VLISTS, +$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$04*BLOW_UP_VLISTS, +$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$04*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$04*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$04*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$06*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$05*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$03*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$03*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
caterpillar_1b_object: 
                    DB       1                            ; speed + direction 
                    DW       car3b_sprite                 ; graphic definition 
                    DB       CATER_LENGTH                 ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       caterpillar_1c_object        ; pointer to next anim object 
                    DB       CATER_Y_OFFSET               ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       CATER_X_OFFSET               ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
caterpillar_2b_object: 
                    DB       2                            ; speed + direction 
                    DW       car3b_sprite                 ; graphic definition 
                    DB       CATER_LENGTH                 ; length in SCALE_FACTOR_GAME 
                    DB       4                            ; anim delay value 
                    DW       caterpillar_2c_object        ; pointer to next anim object 
                    DB       CATER_Y_OFFSET               ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       CATER_X_OFFSET               ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
; sprite definition
car3c_sprite: 
                    DW       (MAX_LINE_NUM-($15+1))*ONE_LINE_LENGTH 
                    DB       -$04*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$04*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$04*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$03*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$03*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$05*BLOW_UP_VLISTS, +$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$05*BLOW_UP_VLISTS, +$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$04*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$04*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$04*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$05*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$05*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
caterpillar_1c_object: 
                    DB       1                            ; speed + direction 
                    DW       car3c_sprite                 ; graphic definition 
                    DB       CATER_LENGTH                 ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       caterpillar_1d_object        ; pointer to next anim object 
                    DB       CATER_Y_OFFSET               ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       CATER_X_OFFSET               ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
caterpillar_2c_object: 
                    DB       2                            ; speed + direction 
                    DW       car3c_sprite                 ; graphic definition 
                    DB       CATER_LENGTH                 ; length in SCALE_FACTOR_GAME 
                    DB       4                            ; anim delay value 
                    DW       caterpillar_2d_object        ; pointer to next anim object 
                    DB       CATER_Y_OFFSET               ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       CATER_X_OFFSET               ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
; sprite definition
car3d_sprite: 
                    DW       (MAX_LINE_NUM-($15+1))*ONE_LINE_LENGTH 
                    DB       -$04*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$04*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$04*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$03*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$03*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$05*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$06*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$04*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$04*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$04*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$04*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$05*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$03*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$03*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS   ; draw to y, x 
caterpillar_1d_object: 
                    DB       1                            ; speed + direction 
                    DW       car3d_sprite                 ; graphic definition 
                    DB       CATER_LENGTH                 ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       caterpillar_1a_object        ; pointer to next anim object 
                    DB       CATER_Y_OFFSET               ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       CATER_X_OFFSET               ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
caterpillar_2d_object: 
                    DB       2                            ; speed + direction 
                    DW       car3d_sprite                 ; graphic definition 
                    DB       CATER_LENGTH                 ; length in SCALE_FACTOR_GAME 
                    DB       4                            ; anim delay value 
                    DW       caterpillar_2a_object        ; pointer to next anim object 
                    DB       CATER_Y_OFFSET               ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       CATER_X_OFFSET               ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
                                                          ;;; back 
car3a_sprite_minus: 
                    DW       (MAX_LINE_NUM-($15+1))*ONE_LINE_LENGTH 
                    DB       -$04*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$04*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$05*BLOW_UP_VLISTS, +$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$05*BLOW_UP_VLISTS, +$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$03*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$03*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$04*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$04*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$04*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$03*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$03*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$05*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$05*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$04*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
caterpillar_m1a_object: 
                    DB       -1                           ; speed + direction 
                    DW       car3a_sprite_minus           ; graphic definition 
                    DB       CATER_LENGTH_MINUS           ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       caterpillar_m1b_object       ; pointer to next anim object 
                    DB       CATER_Y_OFFSET_MINUS         ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       CATER_X_OFFSET_MINUS         ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
caterpillar_m2a_object: 
                    DB       -2                           ; speed + direction 
                    DW       car3a_sprite_minus           ; graphic definition 
                    DB       CATER_LENGTH_MINUS           ; length in SCALE_FACTOR_GAME 
                    DB       4                            ; anim delay value 
                    DW       caterpillar_m2b_object       ; pointer to next anim object 
                    DB       CATER_Y_OFFSET_MINUS         ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       CATER_X_OFFSET_MINUS         ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
; sprite definition
car3b_sprite_minus: 
                    DW       (MAX_LINE_NUM-($15+1))*ONE_LINE_LENGTH 
                    DB       -$03*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$04*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$06*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$05*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$03*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$03*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$04*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$04*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$04*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$03*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$03*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$05*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$04*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$05*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
caterpillar_m1b_object: 
                    DB       -1                           ; speed + direction 
                    DW       car3b_sprite_minus           ; graphic definition 
                    DB       CATER_LENGTH_MINUS           ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       caterpillar_m1c_object       ; pointer to next anim object 
                    DB       CATER_Y_OFFSET_MINUS         ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       CATER_X_OFFSET_MINUS         ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
caterpillar_m2b_object: 
                    DB       -2                           ; speed + direction 
                    DW       car3b_sprite_minus           ; graphic definition 
                    DB       CATER_LENGTH_MINUS           ; length in SCALE_FACTOR_GAME 
                    DB       4                            ; anim delay value 
                    DW       caterpillar_m2c_object       ; pointer to next anim object 
                    DB       CATER_Y_OFFSET_MINUS         ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       CATER_X_OFFSET_MINUS         ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
; sprite definition
car3c_sprite_minus: 
                    DW       (MAX_LINE_NUM-($15+1))*ONE_LINE_LENGTH 
                    DB       -$04*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$04*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$05*BLOW_UP_VLISTS, +$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$05*BLOW_UP_VLISTS, +$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$04*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$04*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$04*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$03*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$03*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$05*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$05*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$04*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
caterpillar_m1c_object: 
                    DB       -1                           ; speed + direction 
                    DW       car3c_sprite_minus           ; graphic definition 
                    DB       CATER_LENGTH_MINUS           ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       caterpillar_m1d_object       ; pointer to next anim object 
                    DB       CATER_Y_OFFSET_MINUS         ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       CATER_X_OFFSET_MINUS         ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
caterpillar_m2c_object: 
                    DB       -2                           ; speed + direction 
                    DW       car3c_sprite_minus           ; graphic definition 
                    DB       CATER_LENGTH_MINUS           ; length in SCALE_FACTOR_GAME 
                    DB       4                            ; anim delay value 
                    DW       caterpillar_m2d_object       ; pointer to next anim object 
                    DB       CATER_Y_OFFSET_MINUS         ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       CATER_X_OFFSET_MINUS         ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
; sprite definition
car3d_sprite_minus: 
                    DW       (MAX_LINE_NUM-($15+1))*ONE_LINE_LENGTH 
                    DB       -$05*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$04*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$04*BLOW_UP_VLISTS, +$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$05*BLOW_UP_VLISTS, +$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$03*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$03*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$04*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$04*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$04*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$03*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$03*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$05*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$06*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$03*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
caterpillar_m1d_object: 
                    DB       -1                           ; speed + direction 
                    DW       car3d_sprite_minus           ; graphic definition 
                    DB       CATER_LENGTH_MINUS           ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       caterpillar_m1a_object       ; pointer to next anim object 
                    DB       CATER_Y_OFFSET_MINUS         ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       CATER_X_OFFSET_MINUS         ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
caterpillar_m2d_object: 
                    DB       -2                           ; speed + direction 
                    DW       car3d_sprite_minus           ; graphic definition 
                    DB       CATER_LENGTH_MINUS           ; length in SCALE_FACTOR_GAME 
                    DB       4                            ; anim delay value 
                    DW       caterpillar_m2a_object       ; pointer to next anim object 
                    DB       CATER_Y_OFFSET_MINUS         ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       CATER_X_OFFSET_MINUS         ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
