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
BLOW_UP             =        SPRITE_BLOW_UP 
CAR3_Y_OFFSET       EQU      -1                           ;-2 
CAR3_X_OFFSET       EQU      1 
CAR3_LENGTH         EQU      20 
CAR3_Y_OFFSET_PLUS  EQU      4 
CAR3_X_OFFSET_PLUS  EQU      1 
CAR3_LENGTH_PLUS    EQU      20 
; sprite definition
car1a_sprite: 
                    DW       (MAX_LINE_NUM-($10+1))*ONE_LINE_LENGTH 
                    DB       -$02*BLOW_UP, +$02*BLOW_UP   ; draw to y, x 
                    DB       -$02*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$04*BLOW_UP   ; draw to y, x 
                    DB       +$03*BLOW_UP, -$01*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, +$04*BLOW_UP   ; draw to y, x 
                    DB       -$03*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$04*BLOW_UP   ; draw to y, x 
                    DB       +$03*BLOW_UP, -$02*BLOW_UP   ; draw to y, x 
                    DB       +$04*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$03*BLOW_UP, +$02*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$04*BLOW_UP   ; draw to y, x 
                    DB       -$03*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, -$04*BLOW_UP   ; draw to y, x 
                    DB       +$03*BLOW_UP, +$01*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$04*BLOW_UP   ; draw to y, x 
                    DB       -$02*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       -$02*BLOW_UP, -$02*BLOW_UP   ; draw to y, x 
carbig_m1a_object: 
                    DB       -1                           ; speed + direction 
                    DW       car1a_sprite                 ; graphic definition 
                    DB       CAR3_LENGTH                  ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       carbig_m1b_object            ; pointer to next anim object 
                    DB       CAR3_Y_OFFSET                ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       CAR3_X_OFFSET                ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
carbig_m3a_object: 
                    DB       -3                           ; speed + direction 
                    DW       car1a_sprite                 ; graphic definition 
                    DB       CAR3_LENGTH                  ; length in SCALE_FACTOR_GAME 
                    DB       2                            ; anim delay value 
                    DW       carbig_m3b_object            ; pointer to next anim object 
                    DB       CAR3_Y_OFFSET                ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       CAR3_X_OFFSET                ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
; sprite definition
car1b_sprite: 
                    DW       (MAX_LINE_NUM-($10+1))*ONE_LINE_LENGTH 
                    DB       -$02*BLOW_UP, +$02*BLOW_UP   ; draw to y, x 
                    DB       -$02*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$03*BLOW_UP   ; draw to y, x 
                    DB       +$03*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, +$04*BLOW_UP   ; draw to y, x 
                    DB       -$03*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$03*BLOW_UP   ; draw to y, x 
                    DB       +$03*BLOW_UP, -$01*BLOW_UP   ; draw to y, x 
                    DB       +$04*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$03*BLOW_UP, +$01*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$03*BLOW_UP   ; draw to y, x 
                    DB       -$03*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, -$04*BLOW_UP   ; draw to y, x 
                    DB       +$03*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$03*BLOW_UP   ; draw to y, x 
                    DB       -$02*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       -$02*BLOW_UP, -$02*BLOW_UP   ; draw to y, x 
carbig_m1b_object: 
                    DB       -1                           ; speed + direction 
                    DW       car1b_sprite                 ; graphic definition 
                    DB       CAR3_LENGTH                  ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       carbig_m1c_object            ; pointer to next anim object 
                    DB       CAR3_Y_OFFSET                ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       CAR3_X_OFFSET                ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
carbig_m3b_object: 
                    DB       -3                           ; speed + direction 
                    DW       car1b_sprite                 ; graphic definition 
                    DB       CAR3_LENGTH                  ; length in SCALE_FACTOR_GAME 
                    DB       2                            ; anim delay value 
                    DW       carbig_m3c_object            ; pointer to next anim object 
                    DB       CAR3_Y_OFFSET                ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       CAR3_X_OFFSET                ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
; sprite definition
car1c_sprite: 
                    DW       (MAX_LINE_NUM-($10+1))*ONE_LINE_LENGTH 
                    DB       -$02*BLOW_UP, +$02*BLOW_UP   ; draw to y, x 
                    DB       -$02*BLOW_UP, -$01*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$04*BLOW_UP   ; draw to y, x 
                    DB       +$03*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, +$04*BLOW_UP   ; draw to y, x 
                    DB       -$03*BLOW_UP, -$01*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$04*BLOW_UP   ; draw to y, x 
                    DB       +$03*BLOW_UP, -$01*BLOW_UP   ; draw to y, x 
                    DB       +$04*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$03*BLOW_UP, +$01*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$04*BLOW_UP   ; draw to y, x 
                    DB       -$03*BLOW_UP, +$01*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, -$04*BLOW_UP   ; draw to y, x 
                    DB       +$03*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$04*BLOW_UP   ; draw to y, x 
                    DB       -$02*BLOW_UP, +$01*BLOW_UP   ; draw to y, x 
                    DB       -$02*BLOW_UP, -$02*BLOW_UP   ; draw to y, x 
carbig_m1c_object: 
                    DB       -1                           ; speed + direction 
                    DW       car1c_sprite                 ; graphic definition 
                    DB       CAR3_LENGTH                  ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       carbig_m1d_object            ; pointer to next anim object 
                    DB       CAR3_Y_OFFSET                ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       CAR3_X_OFFSET                ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
carbig_m1d_object: 
                    DB       -1                           ; speed + direction 
                    DW       car1b_sprite                 ; graphic definition 
                    DB       CAR3_LENGTH                  ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       carbig_m1a_object            ; pointer to next anim object 
                    DB       CAR3_Y_OFFSET                ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       CAR3_X_OFFSET                ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
carbig_m3c_object: 
                    DB       -3                           ; speed + direction 
                    DW       car1c_sprite                 ; graphic definition 
                    DB       CAR3_LENGTH                  ; length in SCALE_FACTOR_GAME 
                    DB       2                            ; anim delay value 
                    DW       carbig_m3d_object            ; pointer to next anim object 
                    DB       CAR3_Y_OFFSET                ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       CAR3_X_OFFSET                ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
carbig_m3d_object: 
                    DB       -3                           ; speed + direction 
                    DW       car1b_sprite                 ; graphic definition 
                    DB       CAR3_LENGTH                  ; length in SCALE_FACTOR_GAME 
                    DB       2                            ; anim delay value 
                    DW       carbig_m3a_object            ; pointer to next anim object 
                    DB       CAR3_Y_OFFSET                ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       CAR3_X_OFFSET                ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
;; back from here
car1a_sprite_plus: 
                    DW       (MAX_LINE_NUM-($10+1))*ONE_LINE_LENGTH 
                    DB       -$04*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       -$03*BLOW_UP, -$02*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$04*BLOW_UP   ; draw to y, x 
                    DB       +$03*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$04*BLOW_UP   ; draw to y, x 
                    DB       -$03*BLOW_UP, -$01*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$04*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, +$02*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, -$02*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$04*BLOW_UP   ; draw to y, x 
                    DB       -$03*BLOW_UP, +$01*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, -$04*BLOW_UP   ; draw to y, x 
                    DB       +$03*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$04*BLOW_UP   ; draw to y, x 
                    DB       -$03*BLOW_UP, +$02*BLOW_UP   ; draw to y, x 
carbig_1a_object: 
                    DB       1                            ; speed + direction 
                    DW       car1a_sprite_plus            ; graphic definition 
                    DB       CAR3_LENGTH_PLUS             ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       carbig_1b_object             ; pointer to next anim object 
                    DB       CAR3_Y_OFFSET_PLUS           ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       CAR3_X_OFFSET_PLUS           ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
carbig_2a_object: 
                    DB       2                            ; speed + direction 
                    DW       car1a_sprite_plus            ; graphic definition 
                    DB       CAR3_LENGTH_PLUS             ; length in SCALE_FACTOR_GAME 
                    DB       4                            ; anim delay value 
                    DW       carbig_2b_object             ; pointer to next anim object 
                    DB       CAR3_Y_OFFSET_PLUS           ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       CAR3_X_OFFSET_PLUS           ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
; sprite definition
car1b_sprite_plus: 
                    DW       (MAX_LINE_NUM-($10+1))*ONE_LINE_LENGTH 
                    DB       -$04*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       -$03*BLOW_UP, -$01*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$03*BLOW_UP   ; draw to y, x 
                    DB       +$03*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$04*BLOW_UP   ; draw to y, x 
                    DB       -$03*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$03*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, +$02*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, -$02*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$03*BLOW_UP   ; draw to y, x 
                    DB       -$03*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, -$04*BLOW_UP   ; draw to y, x 
                    DB       +$03*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$03*BLOW_UP   ; draw to y, x 
                    DB       -$03*BLOW_UP, +$01*BLOW_UP   ; draw to y, x 
carbig_1b_object: 
                    DB       1                            ; speed + direction 
                    DW       car1b_sprite_plus            ; graphic definition 
                    DB       CAR3_LENGTH_PLUS             ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       carbig_1c_object             ; pointer to next anim object 
                    DB       CAR3_Y_OFFSET_PLUS           ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       CAR3_X_OFFSET_PLUS           ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
carbig_2b_object: 
                    DB       2                            ; speed + direction 
                    DW       car1b_sprite_plus            ; graphic definition 
                    DB       CAR3_LENGTH_PLUS             ; length in SCALE_FACTOR_GAME 
                    DB       4                            ; anim delay value 
                    DW       carbig_2c_object             ; pointer to next anim object 
                    DB       CAR3_Y_OFFSET_PLUS           ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       CAR3_X_OFFSET_PLUS           ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
; sprite definition
car1c_sprite_plus: 
                    DW       (MAX_LINE_NUM-($10+1))*ONE_LINE_LENGTH 
                    DB       -$04*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       -$03*BLOW_UP, -$01*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$04*BLOW_UP   ; draw to y, x 
                    DB       +$03*BLOW_UP, -$01*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$04*BLOW_UP   ; draw to y, x 
                    DB       -$03*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$04*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, -$01*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, +$02*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, -$02*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, +$01*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$04*BLOW_UP   ; draw to y, x 
                    DB       -$03*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, -$04*BLOW_UP   ; draw to y, x 
                    DB       +$03*BLOW_UP, +$01*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$04*BLOW_UP   ; draw to y, x 
                    DB       -$03*BLOW_UP, +$01*BLOW_UP   ; draw to y, x 
carbig_1c_object: 
                    DB       1                            ; speed + direction 
                    DW       car1c_sprite_plus            ; graphic definition 
                    DB       CAR3_LENGTH_PLUS             ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       carbig_1d_object             ; pointer to next anim object 
                    DB       CAR3_Y_OFFSET_PLUS           ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       CAR3_X_OFFSET_PLUS           ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
carbig_1d_object: 
                    DB       1                            ; speed + direction 
                    DW       car1b_sprite_plus            ; graphic definition 
                    DB       CAR3_LENGTH_PLUS             ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       carbig_1a_object             ; pointer to next anim object 
                    DB       CAR3_Y_OFFSET_PLUS           ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       CAR3_X_OFFSET_PLUS           ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
carbig_2c_object: 
                    DB       2                            ; speed + direction 
                    DW       car1c_sprite_plus            ; graphic definition 
                    DB       CAR3_LENGTH_PLUS             ; length in SCALE_FACTOR_GAME 
                    DB       4                            ; anim delay value 
                    DW       carbig_2d_object             ; pointer to next anim object 
                    DB       CAR3_Y_OFFSET_PLUS           ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       CAR3_X_OFFSET_PLUS           ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
carbig_2d_object: 
                    DB       2                            ; speed + direction 
                    DW       car1b_sprite_plus            ; graphic definition 
                    DB       CAR3_LENGTH_PLUS             ; length in SCALE_FACTOR_GAME 
                    DB       4                            ; anim delay value 
                    DW       carbig_2a_object             ; pointer to next anim object 
                    DB       CAR3_Y_OFFSET_PLUS           ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       CAR3_X_OFFSET_PLUS           ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
