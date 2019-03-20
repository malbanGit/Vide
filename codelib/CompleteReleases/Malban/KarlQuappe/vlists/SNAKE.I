; this file is part of Karl Quappe, written by Malban
; in 2016
; all stuff contained here is public domain
;
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
Y_OFFSET_RIGHT      equ      -7 +2
Y_OFFSET_LEFT       EQU      -6 +2
snake1a_sprite: 
                    DW       (MAX_LINE_NUM-(10+1))*ONE_LINE_LENGTH 
                    DB       +$05*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       -$04*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$04*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       -$04*BLOW_UP, +$04*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, -$04*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       -$04*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$04*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       -$03*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
snake1a_object: 
                    DB       1                            ; speed + direction 
                    DW       snake1a_sprite               ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       snake1b_object               ; pointer to next anim object 
                    DB       0 +Y_OFFSET_RIGHT            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       2                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_RIGHT_SNAKE          ; special flag 
snake1b_sprite: 
                    DW       (MAX_LINE_NUM-(10+1))*ONE_LINE_LENGTH 
                    DB       +$04*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       -$02*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       -$04*BLOW_UP, +$04*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, -$04*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       -$02*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       -$02*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
snake1b_object: 
                    DB       1                            ; speed + direction 
                    DW       snake1b_sprite               ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       snake1c_object               ; pointer to next anim object 
                    DB       0*2 +Y_OFFSET_RIGHT          ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       2                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_RIGHT_SNAKE          ; special flag 
snake1c_sprite: 
                    DW       (MAX_LINE_NUM-(10+1))*ONE_LINE_LENGTH 
                    DB       +$02*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       -$04*BLOW_UP, +$04*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, -$04*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
snake1c_object: 
                    DB       1                            ; speed + direction 
                    DW       snake1c_sprite               ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       snake1d_object               ; pointer to next anim object 
                    DB       1 *2 +Y_OFFSET_RIGHT         ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       2                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_RIGHT_SNAKE          ; special flag 
snake1d_sprite: 
                    DW       (MAX_LINE_NUM-(10+1))*ONE_LINE_LENGTH 
                    DB       +$00*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       -$02*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       -$02*BLOW_UP, +$04*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, -$04*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       -$02*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
snake1d_object: 
                    DB       1                            ; speed + direction 
                    DW       snake1d_sprite               ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       snake1e_object               ; pointer to next anim object 
                    DB       2 *2 +Y_OFFSET_RIGHT         ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       2                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_RIGHT_SNAKE          ; special flag 
snake1e_sprite: 
                    DW       (MAX_LINE_NUM-(10+1))*ONE_LINE_LENGTH 
                    DB       -$02*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$04*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       -$04*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       -$02*BLOW_UP, +$04*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, -$04*BLOW_UP   ; draw to y, x 
                    DB       -$02*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$04*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       -$04*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$04*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
snake1e_object: 
                    DB       1                            ; speed + direction 
                    DW       snake1e_sprite               ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       snake1f_object               ; pointer to next anim object 
                    DB       3 *2 +Y_OFFSET_RIGHT         ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       2                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_RIGHT_SNAKE          ; special flag 
snake1f_object: 
                    DB       1                            ; speed + direction 
                    DW       snake1d_sprite               ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       snake1g_object               ; pointer to next anim object 
                    DB       2 *2 +Y_OFFSET_RIGHT         ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       2                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_RIGHT_SNAKE          ; special flag 
snake1g_object: 
                    DB       1                            ; speed + direction 
                    DW       snake1c_sprite               ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       snake1h_object               ; pointer to next anim object 
                    DB       1 *2 +Y_OFFSET_RIGHT         ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       2                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_RIGHT_SNAKE          ; special flag 
snake1h_object: 
                    DB       1                            ; speed + direction 
                    DW       snake1b_sprite               ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       snake1a_object               ; pointer to next anim object 
                    DB       -0 *2+Y_OFFSET_RIGHT         ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       2                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_RIGHT_SNAKE          ; special flag 
snake2a_object: 
                    DB       2                            ; speed + direction 
                    DW       snake1a_sprite               ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       4                            ; anim delay value 
                    DW       snake2b_object               ; pointer to next anim object 
                    DB       0+Y_OFFSET_RIGHT             ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       2                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_RIGHT_SNAKE          ; special flag 
snake2b_object: 
                    DB       2                            ; speed + direction 
                    DW       snake1b_sprite               ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       4                            ; anim delay value 
                    DW       snake2c_object               ; pointer to next anim object 
                    DB       0+Y_OFFSET_RIGHT             ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       2                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_RIGHT_SNAKE          ; special flag 
snake2c_object: 
                    DB       2                            ; speed + direction 
                    DW       snake1c_sprite               ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       4                            ; anim delay value 
                    DW       snake2d_object               ; pointer to next anim object 
                    DB       2+Y_OFFSET_RIGHT             ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       2                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_RIGHT_SNAKE          ; special flag 
snake2d_object: 
                    DB       2                            ; speed + direction 
                    DW       snake1d_sprite               ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       4                            ; anim delay value 
                    DW       snake2a_object               ; pointer to next anim object 
                    DB       4+Y_OFFSET_RIGHT             ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       1                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_RIGHT_SNAKE          ; special flag 
snake2e_object: 
                    DB       2                            ; speed + direction 
                    DW       snake1e_sprite               ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       4                            ; anim delay value 
                    DW       snake2f_object               ; pointer to next anim object 
                    DB       6+Y_OFFSET_RIGHT             ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       2                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_RIGHT_SNAKE          ; special flag 
snake2f_object: 
                    DB       2                            ; speed + direction 
                    DW       snake1d_sprite               ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       snake2g_object               ; pointer to next anim object 
                    DB       4+Y_OFFSET_RIGHT             ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       2                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_RIGHT_SNAKE          ; special flag 
snake2g_object: 
                    DB       2                            ; speed + direction 
                    DW       snake1c_sprite               ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       4                            ; anim delay value 
                    DW       snake2h_object               ; pointer to next anim object 
                    DB       2+Y_OFFSET_RIGHT             ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       2                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_RIGHT_SNAKE          ; special flag 
snake2h_object: 
                    DB       2                            ; speed + direction 
                    DW       snake1b_sprite               ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       4                            ; anim delay value 
                    DW       snake2a_object               ; pointer to next anim object 
                    DB       0+Y_OFFSET_RIGHT             ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       2                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_RIGHT_SNAKE          ; special flag 
snake3a_sprite: 
                    DW       (MAX_LINE_NUM-(10+1))*ONE_LINE_LENGTH 
                    DB       +$01*BLOW_UP, +$04*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       -$04*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$04*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       -$03*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$05*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       -$04*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$04*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       -$04*BLOW_UP, -$04*BLOW_UP   ; draw to y, x 
snake3a_object: 
                    DB       -1                           ; speed + direction 
                    DW       snake3a_sprite               ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       snake3b_object               ; pointer to next anim object 
                    DB       Y_OFFSET_LEFT + 1*2          ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       2                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_LEFT_SNAKE           ; special flag 
snake3b_sprite: 
                    DW       (MAX_LINE_NUM-(10+1))*ONE_LINE_LENGTH 
                    DB       +$01*BLOW_UP, +$04*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       -$02*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       -$02*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$04*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       -$02*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       -$04*BLOW_UP, -$04*BLOW_UP   ; draw to y, x 
snake3b_object: 
                    DB       -1                           ; speed + direction 
                    DW       snake3b_sprite               ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       snake3c_object               ; pointer to next anim object 
                    DB       Y_OFFSET_LEFT + 1*2          ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       2                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_LEFT_SNAKE           ; special flag 
snake3c_sprite: 
                    DW       (MAX_LINE_NUM-(10+1))*ONE_LINE_LENGTH 
                    DB       +$01*BLOW_UP, +$04*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       -$04*BLOW_UP, -$04*BLOW_UP   ; draw to y, x 
snake3c_object: 
                    DB       -1                           ; speed + direction 
                    DW       snake3c_sprite               ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       snake3d_object               ; pointer to next anim object 
                    DB       Y_OFFSET_LEFT + 0*2          ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       2                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_LEFT_SNAKE           ; special flag 
snake3d_sprite: 
                    DW       (MAX_LINE_NUM-(10+1))*ONE_LINE_LENGTH 
                    DB       -$01*BLOW_UP, +$04*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       -$02*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       -$02*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       -$02*BLOW_UP, -$04*BLOW_UP   ; draw to y, x 
snake3d_object: 
                    DB       -1                           ; speed + direction 
                    DW       snake3d_sprite               ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       snake3e_object               ; pointer to next anim object 
                    DB       Y_OFFSET_LEFT + 1*2          ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       2                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_LEFT_SNAKE           ; special flag 
snake3e_sprite: 
                    DW       (MAX_LINE_NUM-(10+1))*ONE_LINE_LENGTH 
                    DB       -$01*BLOW_UP, +$04*BLOW_UP   ; draw to y, x 
                    DB       -$02*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$04*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       -$04*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$04*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       -$02*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$04*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       -$04*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       -$02*BLOW_UP, -$04*BLOW_UP   ; draw to y, x 
snake3e_object: 
                    DB       -1                           ; speed + direction 
                    DW       snake3e_sprite               ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       snake3f_object               ; pointer to next anim object 
                    DB       Y_OFFSET_LEFT + 1*2          ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       2                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_LEFT_SNAKE           ; special flag 
snake3f_object: 
                    DB       -1                           ; speed + direction 
                    DW       snake3d_sprite               ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       snake3g_object               ; pointer to next anim object 
                    DB       Y_OFFSET_LEFT + 1*2          ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       2                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_LEFT_SNAKE           ; special flag 
snake3g_object: 
                    DB       -1                           ; speed + direction 
                    DW       snake3c_sprite               ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       snake3h_object               ; pointer to next anim object 
                    DB       Y_OFFSET_LEFT + 0*2          ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       2                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_LEFT_SNAKE           ; special flag 
snake3h_object: 
                    DB       -1                           ; speed + direction 
                    DW       snake3b_sprite               ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       snake3a_object               ; pointer to next anim object 
                    DB       Y_OFFSET_LEFT + 1*2          ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       2                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_LEFT_SNAKE           ; special flag 
snake4a_object: 
                    DB       -2                           ; speed + direction 
                    DW       snake3a_sprite               ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       4                            ; anim delay value 
                    DW       snake4b_object               ; pointer to next anim object 
                    DB       Y_OFFSET_LEFT + 1*2          ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       2                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_LEFT_SNAKE           ; special flag 
snake4b_object: 
                    DB       -2                           ; speed + direction 
                    DW       snake3b_sprite               ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       4                            ; anim delay value 
                    DW       snake4c_object               ; pointer to next anim object 
                    DB       Y_OFFSET_LEFT + 1*2          ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       2                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_LEFT_SNAKE           ; special flag 
snake4c_object: 
                    DB       -2                           ; speed + direction 
                    DW       snake3c_sprite               ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       4                            ; anim delay value 
                    DW       snake4d_object               ; pointer to next anim object 
                    DB       Y_OFFSET_LEFT + 0*2          ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       2                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_LEFT_SNAKE           ; special flag 
snake4d_object: 
                    DB       -2                           ; speed + direction 
                    DW       snake3d_sprite               ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       4                            ; anim delay value 
                    DW       snake4e_object               ; pointer to next anim object 
                    DB       Y_OFFSET_LEFT + 1*2          ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       2                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_LEFT_SNAKE           ; special flag 
snake4e_object: 
                    DB       -2                           ; speed + direction 
                    DW       snake3e_sprite               ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       4                            ; anim delay value 
                    DW       snake4f_object               ; pointer to next anim object 
                    DB       Y_OFFSET_LEFT + 1*2          ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       2                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_LEFT_SNAKE           ; special flag 
snake4f_object: 
                    DB       -2                           ; speed + direction 
                    DW       snake3d_sprite               ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       4                            ; anim delay value 
                    DW       snake4g_object               ; pointer to next anim object 
                    DB       Y_OFFSET_LEFT + 1*2          ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       2                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_LEFT_SNAKE           ; special flag 
snake4g_object: 
                    DB       -2                           ; speed + direction 
                    DW       snake3c_sprite               ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       4                            ; anim delay value 
                    DW       snake4h_object               ; pointer to next anim object 
                    DB       Y_OFFSET_LEFT + 0*2          ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       2                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_LEFT_SNAKE           ; special flag 
snake4h_object: 
                    DB       -2                           ; speed + direction 
                    DW       snake3b_sprite               ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       4                            ; anim delay value 
                    DW       snake4a_object               ; pointer to next anim object 
                    DB       Y_OFFSET_LEFT + 1*2          ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       2                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_LEFT_SNAKE           ; special flag 
