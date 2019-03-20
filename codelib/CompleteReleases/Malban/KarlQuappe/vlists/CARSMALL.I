; this file is part of Karl Quappe, written by Malban
; in 2016
; all stuff contained here is public domain
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this file contains the 'sprite' definition for a truck                    ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CAR4_Y_OFFSET       EQU      2  +1                          ;5 
CAR4_X_OFFSET       EQU      1 
CAR4_X_LENGTH       EQU      25 
truck1a_sprite: 
                    DW       (MAX_LINE_NUM-($11+1))*ONE_LINE_LENGTH 
                    DB       -$05*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, -$02*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$04*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, -$01*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$04*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$04*BLOW_UP   ; draw to y, x 
                    DB       +$03*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, -$04*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$04*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, +$01*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$04*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, +$02*BLOW_UP   ; draw to y, x 
carsmall_1a_object: 
                    DB       1                            ; speed + direction 
                    DW       truck1a_sprite               ; graphic definition 
                    DB       CAR4_X_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       carsmall_1b_object           ; pointer to next anim object 
                    DB       CAR4_Y_OFFSET                ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       CAR4_X_OFFSET                ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; 
                    DB       0                            ; special flag 
truck1b_sprite: 
                    DW       (MAX_LINE_NUM-($11+1))*ONE_LINE_LENGTH 
                    DB       -$05*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, -$01*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$03*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$03*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$04*BLOW_UP   ; draw to y, x 
                    DB       +$03*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, -$04*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$03*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$03*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, +$01*BLOW_UP   ; draw to y, x 
carsmall_1b_object: 
                    DB       1                            ; speed + direction 
                    DW       truck1b_sprite               ; graphic definition 
                    DB       CAR4_X_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       carsmall_1c_object           ; pointer to next anim object 
                    DB       CAR4_Y_OFFSET                ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       CAR4_X_OFFSET                ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; 
                    DB       0                            ; special flag 
truck1c_sprite: 
                    DW       (MAX_LINE_NUM-($11+1))*ONE_LINE_LENGTH 
                    DB       -$05*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, -$01*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$04*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, -$01*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$04*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, -$01*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$04*BLOW_UP   ; draw to y, x 
                    DB       +$03*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, -$04*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$01*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$04*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$01*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$04*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, +$01*BLOW_UP   ; draw to y, x 
carsmall_1c_object: 
                    DB       1                            ; speed + direction 
                    DW       truck1c_sprite               ; graphic definition 
                    DB       CAR4_X_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       carsmall_1a_object           ; pointer to next anim object 
                    DB       CAR4_Y_OFFSET                ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       CAR4_X_OFFSET                ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; 
                    DB       0                            ; special flag 
carsmall_2a_object: 
                    DB       2                            ; speed + direction 
                    DW       truck1a_sprite               ; graphic definition 
                    DB       CAR4_X_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       carsmall_2b_object           ; pointer to next anim object 
                    DB       CAR4_Y_OFFSET                ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       CAR4_X_OFFSET                ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; 
                    DB       0                            ; special flag 
carsmall_2b_object: 
                    DB       2                            ; speed + direction 
                    DW       truck1b_sprite               ; graphic definition 
                    DB       CAR4_X_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       carsmall_2c_object           ; pointer to next anim object 
                    DB       CAR4_Y_OFFSET                ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       CAR4_X_OFFSET                ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; 
                    DB       0                            ; special flag 
carsmall_2c_object: 
                    DB       2                            ; speed + direction 
                    DW       truck1c_sprite               ; graphic definition 
                    DB       CAR4_X_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       carsmall_2a_object           ; pointer to next anim object 
                    DB       CAR4_Y_OFFSET                ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       CAR4_X_OFFSET                ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; 
                    DB       0                            ; special flag 
