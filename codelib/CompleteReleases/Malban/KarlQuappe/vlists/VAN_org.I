; this file is part of Karl Quappe, written by Malban
; in 2016
; all stuff contained here is public domain
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this file contains 'sprite' definition data for the van                  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
; for collision checking: SPRITES MUST HAVE THE LEFTMOST POINT AS STARTVECTOR (*)
; van1 is moving to the left with a speed of -1
VAN_Y_OFFSET        =        2 
VAN_X_OFFSET        =        0 
VAN_LENGTH          =        38 
BLOW_UP             =        SPRITE_BLOW_UP 
; sprite definition
van1a_sprite: 
                    DW       (MAX_LINE_NUM-($12+1))*ONE_LINE_LENGTH 
                    DB       +$01*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       -$04*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       -$04*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$04*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$04*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$04*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
van_m1a_object: 
                    DB       -1                           ; speed + direction 
                    DW       van1a_sprite                ; graphic definition 
                    DB       VAN_LENGTH                   ; length in SCALE_FACTOR_GAME 
                    DB       4                            ; anim delay value 
                    DW       van_m1b_object               ; pointer to next anim object 
                    DB       VAN_Y_OFFSET                 ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       VAN_X_OFFSET                 ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
van_m2a_object: 
                    DB       -2                           ; speed + direction 
                    DW       van1a_sprite                ; graphic definition 
                    DB       VAN_LENGTH                   ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       van_m2b_object               ; pointer to next anim object 
                    DB       VAN_Y_OFFSET                 ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       VAN_X_OFFSET                 ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
van_m3a_object: 
                    DB       -3                           ; speed + direction 
                    DW       van1a_sprite                ; graphic definition 
                    DB       VAN_LENGTH                   ; length in SCALE_FACTOR_GAME 
                    DB       2                            ; anim delay value 
                    DW       van_m3b_object               ; pointer to next anim object 
                    DB       VAN_Y_OFFSET                 ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       VAN_X_OFFSET                 ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
; sprite definition
van1b_sprite: 
                    DW       (MAX_LINE_NUM-($14+1))*ONE_LINE_LENGTH 
                    DB       +$01*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       -$04*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       -$04*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, -$01*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, +$01*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$04*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
van_m1b_object: 
                    DB       -1                           ; speed + direction 
                    DW       van1b_sprite                ; graphic definition 
                    DB       VAN_LENGTH                   ; length in SCALE_FACTOR_GAME 
                    DB       4                            ; anim delay value 
                    DW       van_m1c_object               ; pointer to next anim object 
                    DB       VAN_Y_OFFSET                 ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       VAN_X_OFFSET                 ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
van_m2b_object: 
                    DB       -2                           ; speed + direction 
                    DW       van1b_sprite                ; graphic definition 
                    DB       VAN_LENGTH                   ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       van_m2c_object               ; pointer to next anim object 
                    DB       VAN_Y_OFFSET                 ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       VAN_X_OFFSET                 ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
van_m3b_object: 
                    DB       -3                           ; speed + direction 
                    DW       van1b_sprite                ; graphic definition 
                    DB       VAN_LENGTH                   ; length in SCALE_FACTOR_GAME 
                    DB       2                            ; anim delay value 
                    DW       van_m3c_object               ; pointer to next anim object 
                    DB       VAN_Y_OFFSET                 ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       VAN_X_OFFSET                 ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
van1c_sprite: 
                    DW       (MAX_LINE_NUM-($14+1))*ONE_LINE_LENGTH 
                    DB       +$01*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       -$04*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       -$04*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$03*BLOW_UP, +$04*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, -$04*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$04*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
van_m1c_object: 
                    DB       -1                           ; speed + direction 
                    DW       van1c_sprite                ; graphic definition 
                    DB       VAN_LENGTH                   ; length in SCALE_FACTOR_GAME 
                    DB       4                            ; anim delay value 
                    DW       van_m1d_object               ; pointer to next anim object 
                    DB       VAN_Y_OFFSET                 ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       VAN_X_OFFSET                 ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
van_m2c_object: 
                    DB       -2                           ; speed + direction 
                    DW       van1c_sprite                ; graphic definition 
                    DB       VAN_LENGTH                   ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       van_m2d_object               ; pointer to next anim object 
                    DB       VAN_Y_OFFSET                 ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       VAN_X_OFFSET                 ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
van_m3c_object: 
                    DB       -3                           ; speed + direction 
                    DW       van1c_sprite                ; graphic definition 
                    DB       VAN_LENGTH                   ; length in SCALE_FACTOR_GAME 
                    DB       2                            ; anim delay value 
                    DW       van_m3d_object               ; pointer to next anim object 
                    DB       VAN_Y_OFFSET                 ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       VAN_X_OFFSET                 ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
van1d_sprite: 
                    DW       (MAX_LINE_NUM-($13+1))*ONE_LINE_LENGTH 
                    DB       +$01*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       -$04*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       -$04*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, -$01*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$04*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$04*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
van_m1d_object: 
                    DB       -1                           ; speed + direction 
                    DW       van1d_sprite                ; graphic definition 
                    DB       VAN_LENGTH                   ; length in SCALE_FACTOR_GAME 
                    DB       4                            ; anim delay value 
                    DW       van_m1e_object               ; pointer to next anim object 
                    DB       VAN_Y_OFFSET                 ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       VAN_X_OFFSET                 ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
van_m2d_object: 
                    DB       -2                           ; speed + direction 
                    DW       van1d_sprite                ; graphic definition 
                    DB       VAN_LENGTH                   ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       van_m2e_object               ; pointer to next anim object 
                    DB       VAN_Y_OFFSET                 ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       VAN_X_OFFSET                 ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
van_m3d_object: 
                    DB       -3                           ; speed + direction 
                    DW       van1d_sprite                ; graphic definition 
                    DB       VAN_LENGTH                   ; length in SCALE_FACTOR_GAME 
                    DB       2                            ; anim delay value 
                    DW       van_m3e_object               ; pointer to next anim object 
                    DB       VAN_Y_OFFSET                 ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       VAN_X_OFFSET                 ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
van1e_sprite: 
                    DW       (MAX_LINE_NUM-($13+1))*ONE_LINE_LENGTH 
                    DB       +$01*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, +$05*BLOW_UP   ; draw to y, x 
                    DB       -$04*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       -$04*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$02*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, +$03*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, -$01*BLOW_UP   ; draw to y, x 
                    DB       +$00*BLOW_UP, -$02*BLOW_UP   ; draw to y, x 
                    DB       -$01*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
                    DB       +$01*BLOW_UP, -$05*BLOW_UP   ; draw to y, x 
                    DB       +$04*BLOW_UP, +$00*BLOW_UP   ; draw to y, x 
van_m1e_object: 
                    DB       -1                           ; speed + direction 
                    DW       van1e_sprite                ; graphic definition 
                    DB       VAN_LENGTH                   ; length in SCALE_FACTOR_GAME 
                    DB       4                            ; anim delay value 
                    DW       van_m1a_object               ; pointer to next anim object 
                    DB       VAN_Y_OFFSET                 ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       VAN_X_OFFSET                 ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
van_m2e_object: 
                    DB       -2                           ; speed + direction 
                    DW       van1e_sprite                ; graphic definition 
                    DB       VAN_LENGTH                   ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       van_m2a_object               ; pointer to next anim object 
                    DB       VAN_Y_OFFSET                 ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       VAN_X_OFFSET                 ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
van_m3e_object: 
                    DB       -3                           ; speed + direction 
                    DW       van1e_sprite                ; graphic definition 
                    DB       VAN_LENGTH                   ; length in SCALE_FACTOR_GAME 
                    DB       2                            ; anim delay value 
                    DW       van_m3a_object               ; pointer to next anim object 
                    DB       VAN_Y_OFFSET                 ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       VAN_X_OFFSET                 ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 

    if       HALFSPEED = 1 
van_mHalfa_object: 
                    DB       0                            ; speed + direction 
                    DW       van1a_sprite                ; graphic definition 
                    DB       VAN_LENGTH                   ; length in SCALE_FACTOR_GAME 
                    DB       4                            ; anim delay value 
                    DW       van_mHalfb_object            ; pointer to next anim object 
                    DB       VAN_Y_OFFSET                 ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       VAN_X_OFFSET                 ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       $81                          ; 8 = minus 1 = every second 
                    DB       0                            ; special flag 
van_mHalfb_object: 
                    DB       0                            ; speed + direction 
                    DW       van1b_sprite                ; graphic definition 
                    DB       VAN_LENGTH                   ; length in SCALE_FACTOR_GAME 
                    DB       4                            ; anim delay value 
                    DW       van_mHalfc_object            ; pointer to next anim object 
                    DB       VAN_Y_OFFSET                 ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       VAN_X_OFFSET                 ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       $81                          ; 8 = minus 1 = every second 
                    DB       0                            ; special flag 
van_mHalfc_object: 
                    DB       0                            ; speed + direction 
                    DW       van1c_sprite                ; graphic definition 
                    DB       VAN_LENGTH                   ; length in SCALE_FACTOR_GAME 
                    DB       4                            ; anim delay value 
                    DW       van_mHalfd_object            ; pointer to next anim object 
                    DB       VAN_Y_OFFSET                 ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       VAN_X_OFFSET                 ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       $81                          ; 8 = minus 1 = every second 
                    DB       0                            ; special flag 
van_mHalfd_object: 
                    DB       0                            ; speed + direction 
                    DW       van1d_sprite                ; graphic definition 
                    DB       VAN_LENGTH                   ; length in SCALE_FACTOR_GAME 
                    DB       4                            ; anim delay value 
                    DW       van_mHalfe_object            ; pointer to next anim object 
                    DB       VAN_Y_OFFSET                 ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       VAN_X_OFFSET                 ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       $81                          ; 8 = minus 1 = every second 
                    DB       0                            ; special flag 
van_mHalfe_object: 
                    DB       0                            ; speed + direction 
                    DW       van1e_sprite                ; graphic definition 
                    DB       VAN_LENGTH                   ; length in SCALE_FACTOR_GAME 
                    DB       4                            ; anim delay value 
                    DW       van_mHalfa_object            ; pointer to next anim object 
                    DB       VAN_Y_OFFSET                 ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       VAN_X_OFFSET                 ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       $81                          ; 8 = minus 1 = every second 
                    DB       0                            ; special flag 
    endif    
