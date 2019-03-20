; this file is part of Karl Quappe, written by Malban
; in 2016
; all stuff contained here is public domain
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this file contains 'sprite' definition data for crocodiles                ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
BLOW_UP             =        SPRITE_BLOW_UP 
CROCO_LENGTH        EQU      34 
CROCO_X_OFFSET      EQU      2 
CROCO_Y_OFFSET      EQU      -1 
croco3a_sprite: 
                    DW       (MAX_LINE_NUM-(13+1))*ONE_LINE_LENGTH 
                    DB       -$01*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, -$02*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, +$01*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, +$01*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       -$02*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, -$03*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, -$02*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
croco3a_object: 
                    DB       -1                           ; speed + direction 
                    DW       croco3a_sprite               ; graphic definition 
                    DB       CROCO_LENGTH                 ; length in SCALE_FACTOR_GAME 
                    DB       9                            ; anim delay value 
                    DW       croco3b_object               ; pointer to next anim object 
                    DB       CROCO_Y_OFFSET               ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       CROCO_X_OFFSET               ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_LEFT_CROCO           ; special flag 
croco3b_sprite: 
                    DW       (MAX_LINE_NUM-(13+1))*ONE_LINE_LENGTH 
                    DB       +$00*BLOW_UP, +$04*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, -$03*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, +$02*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, +$03*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, +$03*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$04*BLOW_UP   ; draw to y, x 
                    DB       -$02*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, -$03*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, -$02*BLOW_UP   ; draw to y, x 
                    DB       -$02*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
croco3b_object: 
                    DB       -1                           ; speed + direction 
                    DW       croco3b_sprite               ; graphic definition 
                    DB       CROCO_LENGTH                 ; length in SCALE_FACTOR_GAME 
                    DB       9                            ; anim delay value 
                    DW       croco3c_object               ; pointer to next anim object 
                    DB       CROCO_Y_OFFSET -1            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       CROCO_X_OFFSET               ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_LEFT_CROCO           ; special flag 
croco3c_sprite: 
                    DW       (MAX_LINE_NUM-(11+1))*ONE_LINE_LENGTH 
                    DB       +$00*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, +$04*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$03*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, +$02*BLOW_UP   ; draw to y, x 
                    DB       +$03*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, -$04*BLOW_UP   ; draw to y, x 
                    DB       -$02*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, -$03*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, -$02*BLOW_UP   ; draw to y, x 
                    DB       -$02*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
croco3c_object: 
                    DB       -1                           ; speed + direction 
                    DW       croco3c_sprite               ; graphic definition 
                    DB       CROCO_LENGTH                 ; length in SCALE_FACTOR_GAME 
                    DB       9                            ; anim delay value 
                    DW       croco3d_object               ; pointer to next anim object 
                    DB       CROCO_Y_OFFSET -1            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       CROCO_X_OFFSET               ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_LEFT_CROCO           ; special flag 
croco3d_sprite: 
                    DW       (MAX_LINE_NUM-(13+1))*ONE_LINE_LENGTH 
                    DB       -$01*BLOW_UP, +$04*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, -$03*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, +$04*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$03*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, +$02*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, -$03*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, -$02*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
croco3d_object: 
                    DB       -1                           ; speed + direction 
                    DW       croco3d_sprite               ; graphic definition 
                    DB       CROCO_LENGTH                 ; length in SCALE_FACTOR_GAME 
                    DB       9                            ; anim delay value 
                    DW       croco3a_object               ; pointer to next anim object 
                    DB       CROCO_Y_OFFSET               ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       CROCO_X_OFFSET               ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_LEFT_CROCO           ; special flag 
croco4a_object: 
                    DB       -2                           ; speed + direction 
                    DW       croco3a_sprite               ; graphic definition 
                    DB       CROCO_LENGTH                 ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       croco4b_object               ; pointer to next anim object 
                    DB       CROCO_Y_OFFSET               ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       CROCO_X_OFFSET               ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_LEFT_CROCO           ; special flag 
croco4b_object: 
                    DB       -2                           ; speed + direction 
                    DW       croco3b_sprite               ; graphic definition 
                    DB       CROCO_LENGTH                 ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       croco4c_object               ; pointer to next anim object 
                    DB       CROCO_Y_OFFSET -1            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       CROCO_X_OFFSET               ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_LEFT_CROCO           ; special flag 
croco4c_object: 
                    DB       -2                           ; speed + direction 
                    DW       croco3c_sprite               ; graphic definition 
                    DB       CROCO_LENGTH                 ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       croco4d_object               ; pointer to next anim object 
                    DB       CROCO_Y_OFFSET -1            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       CROCO_X_OFFSET               ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_LEFT_CROCO           ; special flag 
croco4d_object: 
                    DB       -2                           ; speed + direction 
                    DW       croco3d_sprite               ; graphic definition 
                    DB       CROCO_LENGTH                 ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       croco4a_object               ; pointer to next anim object 
                    DB       CROCO_Y_OFFSET               ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       CROCO_X_OFFSET               ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_LEFT_CROCO           ; special flag 
crocoh1a_sprite: 
                    DW       (MAX_LINE_NUM_16-(11+1))*ONE_LINE_LENGTH 
                    DB       -1*SPRITE_BLOW_UP, 5*SPRITE_BLOW_UP 
                    DB       -1*SPRITE_BLOW_UP, 0*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP 
                    DB       -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP 
                    DB       -2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP 
                    DB       -1*SPRITE_BLOW_UP, 1*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, 1*SPRITE_BLOW_UP 
                    DB       -1*SPRITE_BLOW_UP, 1*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, 1*SPRITE_BLOW_UP 
                    DB       -1*SPRITE_BLOW_UP, 1*SPRITE_BLOW_UP 
                    DB       -1*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP 
                    DB       5*SPRITE_BLOW_UP, 0*SPRITE_BLOW_UP 
crocoh1a_object: 
                    DB       0                            ; speed + direction 
                    DW       crocoh1a_sprite              ; graphic definition 
                    DB       0                            ; length in SCALE_FACTOR_GAME 
                    DB       $20                          ; anim delay value 
                    DW       crocoh1b_object              ; pointer to next anim object 
                    DB       0                            ; offsets y in 'SCALE_IN_HOME', since this is a home object 
                    DB       CROCO_X_OFFSET               ; offsets x in 'SCALE_IN_HOME', since this is a home object 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_CROCO_HALF           ; special flag 
crocoh1b_sprite: 
                    DW       (MAX_LINE_NUM_16-(14+1))*ONE_LINE_LENGTH 
                    DB       -1*SPRITE_BLOW_UP, 5*SPRITE_BLOW_UP 
                    DB       -1*SPRITE_BLOW_UP, 3*SPRITE_BLOW_UP 
                    DB       -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP 
                    DB       -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP 
                    DB       -1*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP 
                    DB       0*SPRITE_BLOW_UP, 2*SPRITE_BLOW_UP 
                    DB       -1*SPRITE_BLOW_UP, 2*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, 1*SPRITE_BLOW_UP 
                    DB       -1*SPRITE_BLOW_UP, 1*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, 1*SPRITE_BLOW_UP 
                    DB       -2*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP 
                    DB       0*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP 
                    DB       4*SPRITE_BLOW_UP, 0*SPRITE_BLOW_UP 
crocoh1b_object: 
                    DB       0                            ; speed + direction 
                    DW       crocoh1b_sprite              ; graphic definition 
                    DB       0                            ; length in SCALE_FACTOR_GAME 
                    DB       $20                          ; anim delay value 
                    DW       crocoh1c_object              ; pointer to next anim object 
                    DB       0                            ; offsets y in 'SCALE_IN_HOME', since this is a home object 
                    DB       0                            ; offsets x in 'SCALE_IN_HOME', since this is a home object 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_CROCO_HALF           ; special flag 
crocoh1c_sprite: 
                    DW       (MAX_LINE_NUM_16-(16+1))*ONE_LINE_LENGTH 
                    DB       -1*SPRITE_BLOW_UP, 5*SPRITE_BLOW_UP 
                    DB       0*SPRITE_BLOW_UP, 4*SPRITE_BLOW_UP 
                    DB       2*SPRITE_BLOW_UP, 1*SPRITE_BLOW_UP 
                    DB       -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP 
                    DB       -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP 
                    DB       0*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, 3*SPRITE_BLOW_UP 
                    DB       -1*SPRITE_BLOW_UP, 1*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, 1*SPRITE_BLOW_UP 
                    DB       -1*SPRITE_BLOW_UP, 1*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, 1*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP 
                    DB       -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP 
                    DB       -4*SPRITE_BLOW_UP, 0*SPRITE_BLOW_UP 
crocoh1c_object: 
                    DB       0                            ; speed + direction 
                    DW       crocoh1c_sprite              ; graphic definition 
                    DB       0                            ; length in SCALE_FACTOR_GAME 
                    DB       $05                          ; anim delay value 
                    DW       crocoh1d_object              ; pointer to next anim object 
                    DB       -7                           ; offsets y in 'SCALE_IN_HOME', since this is a home object 
                    DB       0                            ; offsets x in 'SCALE_IN_HOME', since this is a home object 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_CROCO_FULL           ; special flag 
crocoh1d_sprite: 
                    DW       (MAX_LINE_NUM_16-(16+1))*ONE_LINE_LENGTH 
                    DB       -2*SPRITE_BLOW_UP, 5*SPRITE_BLOW_UP 
                    DB       0*SPRITE_BLOW_UP, 4*SPRITE_BLOW_UP 
                    DB       2*SPRITE_BLOW_UP, 1*SPRITE_BLOW_UP 
                    DB       -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP 
                    DB       -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, 3*SPRITE_BLOW_UP 
                    DB       -1*SPRITE_BLOW_UP, 1*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, 1*SPRITE_BLOW_UP 
                    DB       -1*SPRITE_BLOW_UP, 1*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, 1*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP 
                    DB       -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP 
                    DB       -4*SPRITE_BLOW_UP, 0*SPRITE_BLOW_UP 
crocoh1d_object: 
                    DB       0                            ; speed + direction 
                    DW       crocoh1d_sprite              ; graphic definition 
                    DB       0                            ; length in SCALE_FACTOR_GAME 
                    DB       $05                          ; anim delay value 
                    DW       crocoh1e_object              ; pointer to next anim object 
                    DB       -7                           ; offsets y in 'SCALE_IN_HOME', since this is a home object 
                    DB       -0                           ; offsets x in 'SCALE_IN_HOME', since this is a home object 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_CROCO_FULL           ; special flag 
crocoh1e_sprite: 
                    DW       (MAX_LINE_NUM_16-(16+1))*ONE_LINE_LENGTH 
                    DB       -1*SPRITE_BLOW_UP, 5*SPRITE_BLOW_UP 
                    DB       -1*SPRITE_BLOW_UP, 4*SPRITE_BLOW_UP 
                    DB       2*SPRITE_BLOW_UP, 1*SPRITE_BLOW_UP 
                    DB       -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP 
                    DB       -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP 
                    DB       2*SPRITE_BLOW_UP, 3*SPRITE_BLOW_UP 
                    DB       -1*SPRITE_BLOW_UP, 1*SPRITE_BLOW_UP 
                    DB       2*SPRITE_BLOW_UP, 1*SPRITE_BLOW_UP 
                    DB       -1*SPRITE_BLOW_UP, 1*SPRITE_BLOW_UP 
                    DB       2*SPRITE_BLOW_UP, 1*SPRITE_BLOW_UP 
                    DB       -1*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP 
                    DB       0*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP 
                    DB       -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP 
                    DB       -4*SPRITE_BLOW_UP, 0*SPRITE_BLOW_UP 
crocoh1e_object: 
                    DB       0                            ; speed + direction 
                    DW       crocoh1e_sprite              ; graphic definition 
                    DB       0                            ; length in SCALE_FACTOR_GAME 
                    DB       $05                          ; anim delay value 
                    DW       crocoh1f_object              ; pointer to next anim object 
                    DB       -7                           ; offsets y in 'SCALE_IN_HOME', since this is a home object 
                    DB       -0                           ; offsets x in 'SCALE_IN_HOME', since this is a home object 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_CROCO_FULL           ; special flag 
crocoh1f_object: 
                    DB       0                            ; speed + direction 
                    DW       crocoh1d_sprite              ; graphic definition 
                    DB       0                            ; length in SCALE_FACTOR_GAME 
                    DB       $05                          ; anim delay value 
                    DW       crocoh1c_object              ; pointer to next anim object 
                    DB       -7                           ; offsets y in 'SCALE_IN_HOME', since this is a home object 
                    DB       -0                           ; offsets x in 'SCALE_IN_HOME', since this is a home object 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_CROCO_FULL           ; special flag 
                    if       ARCADE_MOVE = 1 
;;;;; CROCO PLUS
CROCO_LENGTH_PLUS   EQU      50 
CROCO_X_OFFSET_PLUS  EQU     2 
CROCO_Y_OFFSET_PLUS  EQU     1 
crocoM3a_sprite: 
                    DW       (MAX_LINE_NUM-(13+1))*ONE_LINE_LENGTH 
                    DB       +$01*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       -$02*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, +$03*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$02*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, +$02*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, -$01*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, -$01*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
crocoM3a_object: 
                    DB       1                            ; speed + direction 
                    DW       crocoM3a_sprite              ; graphic definition 
                    DB       CROCO_LENGTH_PLUS            ; length in SCALE_FACTOR_GAME 
                    DB       9                            ; anim delay value 
                    DW       crocoM3b_object              ; pointer to next anim object 
                    DB       CROCO_Y_OFFSET_PLUS          ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       CROCO_X_OFFSET_PLUS          ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_RIGHT_CROCO          ; special flag 
crocoM3b_sprite: 
                    DW       (MAX_LINE_NUM-(13+1))*ONE_LINE_LENGTH 
                    DB       +$00*BLOW_UP, +$04*BLOW_UP   ; draw to y, x 
                    DB       -$02*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, +$03*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$02*BLOW_UP   ; draw to y, x 
                    DB       -$02*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$04*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, +$03*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, -$02*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, -$03*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, -$03*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
crocoM3b_object: 
                    DB       1                            ; speed + direction 
                    DW       crocoM3b_sprite              ; graphic definition 
                    DB       CROCO_LENGTH_PLUS            ; length in SCALE_FACTOR_GAME 
                    DB       9                            ; anim delay value 
                    DW       crocoM3c_object              ; pointer to next anim object 
                    DB       CROCO_Y_OFFSET_PLUS+(1)*2    ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       CROCO_X_OFFSET_PLUS+(1)*2    ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_RIGHT_CROCO          ; special flag 
crocoM3c_sprite: 
                    DW       (MAX_LINE_NUM-(11+1))*ONE_LINE_LENGTH 
                    DB       -$01*BLOW_UP, +$04*BLOW_UP   ; draw to y, x 
                    DB       -$02*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, +$03*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$02*BLOW_UP   ; draw to y, x 
                    DB       -$02*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, -$04*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, -$03*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, -$02*BLOW_UP   ; draw to y, x 
                    DB       +$03*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
crocoM3c_object: 
                    DB       1                            ; speed + direction 
                    DW       crocoM3c_sprite              ; graphic definition 
                    DB       CROCO_LENGTH_PLUS            ; length in SCALE_FACTOR_GAME 
                    DB       9                            ; anim delay value 
                    DW       crocoM3d_object              ; pointer to next anim object 
                    DB       CROCO_Y_OFFSET_PLUS +(2)*2   ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       CROCO_X_OFFSET_PLUS +(1)*2   ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_RIGHT_CROCO          ; special flag 
crocoM3d_sprite: 
                    DW       (MAX_LINE_NUM-(13+1))*ONE_LINE_LENGTH 
                    DB       +$00*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, +$03*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$02*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, -$04*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, +$03*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, -$04*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, -$03*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, -$02*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
crocoM3d_object: 
                    DB       1                            ; speed + direction 
                    DW       crocoM3d_sprite              ; graphic definition 
                    DB       CROCO_LENGTH_PLUS            ; length in SCALE_FACTOR_GAME 
                    DB       9                            ; anim delay value 
                    DW       crocoM3a_object              ; pointer to next anim object 
                    DB       CROCO_Y_OFFSET_PLUS          ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       CROCO_X_OFFSET_PLUS          ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_RIGHT_CROCO          ; special flag 
crocoM4a_object: 
                    DB       2                            ; speed + direction 
                    DW       crocoM3a_sprite              ; graphic definition 
                    DB       CROCO_LENGTH_PLUS            ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       crocoM4b_object              ; pointer to next anim object 
                    DB       CROCO_Y_OFFSET_PLUS          ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       CROCO_X_OFFSET_PLUS          ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_RIGHT_CROCO          ; special flag 
crocoM4b_object: 
                    DB       2                            ; speed + direction 
                    DW       crocoM3b_sprite              ; graphic definition 
                    DB       CROCO_LENGTH_PLUS            ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       crocoM4c_object              ; pointer to next anim object 
                    DB       CROCO_Y_OFFSET_PLUS+(1)*2    ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       CROCO_X_OFFSET_PLUS+(1)*2    ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_RIGHT_CROCO          ; special flag 
crocoM4c_object: 
                    DB       2                            ; speed + direction 
                    DW       crocoM3c_sprite              ; graphic definition 
                    DB       CROCO_LENGTH_PLUS            ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       crocoM4d_object              ; pointer to next anim object 
                    DB       CROCO_Y_OFFSET_PLUS +(2)*2   ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       CROCO_X_OFFSET_PLUS +(1)*2   ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_RIGHT_CROCO          ; special flag 
crocoM4d_object: 
                    DB       2                            ; speed + direction 
                    DW       crocoM3d_sprite              ; graphic definition 
                    DB       CROCO_LENGTH_PLUS            ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       crocoM4a_object              ; pointer to next anim object 
                    DB       CROCO_Y_OFFSET_PLUS          ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       CROCO_X_OFFSET_PLUS          ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_RIGHT_CROCO          ; special flag 
                    endif    
