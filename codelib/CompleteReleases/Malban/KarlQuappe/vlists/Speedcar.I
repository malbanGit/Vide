; this file is part of Karl Quappe, written by Malban
; in 2016
; all stuff contained here is public domain
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this file contains 'sprite' definition data for a motorcycle              ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
; for collision checking: SPRITES MUST HAVE THE LEFTMOST POINT AS STARTVECTOR (*)
; moped1 is moving to the left with a speed of -1
SPEEDCAR_Y_OFFSET   EQU      -1 
SPEEDCAR_X_OFFSET   EQU      -1 
SPEEDCAR_LENGTH     EQU      24 
moped1a_sprite: 
                    DW       (MAX_LINE_NUM-($10+1))*ONE_LINE_LENGTH 
                    DB       -$03*BLOW_UP, +$03*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$03*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$04*BLOW_UP   ; draw to y, x 
                    DB       -$02*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$03*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$03*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, -$03*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$03*BLOW_UP   ; draw to y, x 
                    DB       -$02*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$04*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$03*BLOW_UP   ; draw to y, x 
                    DB       -$03*BLOW_UP, -$03*BLOW_UP   ; draw to y, x 
speeder_m1a_object: 
                    DB       -1                           ; speed + direction 
                    DW       moped1a_sprite               ; graphic definition 
                    DB       SPEEDCAR_LENGTH              ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       speeder_m1b_object           ; pointer to next anim object 
                    DB       SPEEDCAR_Y_OFFSET            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       SPEEDCAR_X_OFFSET            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
moped1b_sprite: 
                    DW       (MAX_LINE_NUM-($11+1))*ONE_LINE_LENGTH 
                    DB       -$03*BLOW_UP, +$03*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$03*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$04*BLOW_UP   ; draw to y, x 
                    DB       -$02*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$03*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$03*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$01*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, -$01*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, -$03*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$03*BLOW_UP   ; draw to y, x 
                    DB       -$02*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$04*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$03*BLOW_UP   ; draw to y, x 
                    DB       -$03*BLOW_UP, -$03*BLOW_UP   ; draw to y, x 
speeder_m1b_object: 
                    DB       -1                           ; speed + direction 
                    DW       moped1b_sprite               ; graphic definition 
                    DB       SPEEDCAR_LENGTH              ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       speeder_m1c_object           ; pointer to next anim object 
                    DB       SPEEDCAR_Y_OFFSET            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       SPEEDCAR_X_OFFSET            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
moped1c_sprite: 
                    DW       (MAX_LINE_NUM-($11+1))*ONE_LINE_LENGTH 
                    DB       -$03*BLOW_UP, +$03*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$03*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$04*BLOW_UP   ; draw to y, x 
                    DB       -$02*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$03*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$03*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$03*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, -$03*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, -$03*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$03*BLOW_UP   ; draw to y, x 
                    DB       -$02*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$04*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$03*BLOW_UP   ; draw to y, x 
                    DB       -$03*BLOW_UP, -$03*BLOW_UP   ; draw to y, x 
speeder_m1c_object 
                    DB       -1                           ; speed + direction 
                    DW       moped1c_sprite               ; graphic definition 
                    DB       SPEEDCAR_LENGTH              ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       speeder_m1d_object           ; pointer to next anim object 
                    DB       SPEEDCAR_Y_OFFSET            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       SPEEDCAR_X_OFFSET            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
moped1d_sprite: 
                    DW       (MAX_LINE_NUM-($12+1))*ONE_LINE_LENGTH 
                    DB       -$03*BLOW_UP, +$03*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$03*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$04*BLOW_UP   ; draw to y, x 
                    DB       -$02*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$03*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$03*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, +$03*BLOW_UP   ; draw to y, x 
                    DB       -$02*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, -$03*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, -$03*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$03*BLOW_UP   ; draw to y, x 
                    DB       -$02*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$04*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$03*BLOW_UP   ; draw to y, x 
                    DB       -$03*BLOW_UP, -$03*BLOW_UP   ; draw to y, x 
speeder_m1d_object: 
                    DB       -1                           ; speed + direction 
                    DW       moped1d_sprite               ; graphic definition 
                    DB       SPEEDCAR_LENGTH              ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       speeder_m1a_object           ; pointer to next anim object 
                    DB       SPEEDCAR_Y_OFFSET            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       SPEEDCAR_X_OFFSET            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
speeder_m2a_object: 
                    DB       -2                           ; speed + direction 
                    DW       moped1a_sprite               ; graphic definition 
                    DB       14                           ; length in SCALE_FACTOR_GAME 
                    DB       2                            ; anim delay value 
                    DW       speeder_m2b_object           ; pointer to next anim object 
                    DB       SPEEDCAR_Y_OFFSET            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       SPEEDCAR_X_OFFSET            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
speeder_m2b_object: 
                    DB       -2                           ; speed + direction 
                    DW       moped1b_sprite               ; graphic definition 
                    DB       SPEEDCAR_LENGTH              ; length in SCALE_FACTOR_GAME 
                    DB       2                            ; anim delay value 
                    DW       speeder_m2c_object           ; pointer to next anim object 
                    DB       SPEEDCAR_Y_OFFSET            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       SPEEDCAR_X_OFFSET            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
speeder_m2c_object: 
                    DB       -2                           ; speed + direction 
                    DW       moped1c_sprite               ; graphic definition 
                    DB       SPEEDCAR_LENGTH              ; length in SCALE_FACTOR_GAME 
                    DB       2                            ; anim delay value 
                    DW       speeder_m2d_object           ; pointer to next anim object 
                    DB       SPEEDCAR_Y_OFFSET            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       SPEEDCAR_X_OFFSET            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
speeder_m2d_object: 
                    DB       -2                           ; speed + direction 
                    DW       moped1b_sprite               ; graphic definition 
                    DB       SPEEDCAR_LENGTH              ; length in SCALE_FACTOR_GAME 
                    DB       2                            ; anim delay value 
                    DW       speeder_m2a_object           ; pointer to next anim object 
                    DB       SPEEDCAR_Y_OFFSET            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       SPEEDCAR_X_OFFSET            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
speeder_m3a_object: 
SPEEDER_M3          =        0 
                    if       SPEEDER_M3 = 1 
speeder_m3a_object: 
                    DB       -3                           ; speed + direction 
                    DW       moped1a_sprite               ; graphic definition 
                    DB       SPEEDCAR_LENGTH              ; length in SCALE_FACTOR_GAME 
                    DB       2                            ; anim delay value 
                    DW       speeder_m3b_object           ; pointer to next anim object 
                    DB       SPEEDCAR_Y_OFFSET            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       SPEEDCAR_X_OFFSET            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
speeder_m3b_object: 
                    DB       -3                           ; speed + direction 
                    DW       moped1b_sprite               ; graphic definition 
                    DB       SPEEDCAR_LENGTH              ; length in SCALE_FACTOR_GAME 
                    DB       2                            ; anim delay value 
                    DW       speeder_m3c_object           ; pointer to next anim object 
                    DB       SPEEDCAR_Y_OFFSET            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       SPEEDCAR_X_OFFSET            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
speeder_m3c_object: 
                    DB       -3                           ; speed + direction 
                    DW       moped1c_sprite               ; graphic definition 
                    DB       SPEEDCAR_LENGTH              ; length in SCALE_FACTOR_GAME 
                    DB       2                            ; anim delay value 
                    DW       speeder_m3d_object           ; pointer to next anim object 
                    DB       SPEEDCAR_Y_OFFSET            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       SPEEDCAR_X_OFFSET            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
speeder_m3d_object: 
                    DB       -3                           ; speed + direction 
                    DW       moped1b_sprite               ; graphic definition 
                    DB       SPEEDCAR_LENGTH              ; length in SCALE_FACTOR_GAME 
                    DB       2                            ; anim delay value 
                    DW       speeder_m3a_object           ; pointer to next anim object 
                    DB       SPEEDCAR_Y_OFFSET            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       SPEEDCAR_X_OFFSET            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
                    endif    
