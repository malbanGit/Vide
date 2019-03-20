; this file is part of Karl Quappe, written by Malban
; in 2016
; all stuff contained here is public domain
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this file contains 'sprite' definition data for logs                      ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
; for collision checking: SPRITES MUST HAVE THE LEFTMOST POINT AS STARTVECTOR (*)
; log1 is moving right with a speed of 1
; log2 is moving left with a speed of -1
log3a_sprite: 
                    DW       (MAX_LINE_NUM-(10+1))*ONE_LINE_LENGTH 
                    DB       0*(SPRITE_BLOW_UP-1), 5*(SPRITE_BLOW_UP-1) 
                    DB       0*(SPRITE_BLOW_UP-1), 5*(SPRITE_BLOW_UP-1) 
                    DB       0*(SPRITE_BLOW_UP-1), 5*(SPRITE_BLOW_UP-1) 
                    DB       0*(SPRITE_BLOW_UP-1), 5*(SPRITE_BLOW_UP-1) 
                    DB       0*(SPRITE_BLOW_UP-1), 3*(SPRITE_BLOW_UP-1) 
                    DB       -2*(SPRITE_BLOW_UP-1), -5*(SPRITE_BLOW_UP-1) 
                    DB       0*(SPRITE_BLOW_UP-1), -5*(SPRITE_BLOW_UP-1) 
                    DB       -2*(SPRITE_BLOW_UP-1), -5*(SPRITE_BLOW_UP-1) 
                    DB       2*(SPRITE_BLOW_UP-1), -5*(SPRITE_BLOW_UP-1) 
                    DB       -2*(SPRITE_BLOW_UP-1), -3*(SPRITE_BLOW_UP-1) 
                    DB       4*(SPRITE_BLOW_UP-1), 0*(SPRITE_BLOW_UP-1) 
log3a_object: 
                    DB       -1                           ; speed + direction 
                    DW       log3a_sprite                 ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       log3b_object                 ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; 
                    DB       0                            ; special flag 
log3b_sprite: 
                    DW       (MAX_LINE_NUM-(10+1))*ONE_LINE_LENGTH 
                    DB       0*(SPRITE_BLOW_UP-1), 5*(SPRITE_BLOW_UP-1) 
                    DB       0*(SPRITE_BLOW_UP-1), 5*(SPRITE_BLOW_UP-1) 
                    DB       0*(SPRITE_BLOW_UP-1), 5*(SPRITE_BLOW_UP-1) 
                    DB       0*(SPRITE_BLOW_UP-1), 5*(SPRITE_BLOW_UP-1) 
                    DB       0*(SPRITE_BLOW_UP-1), 3*(SPRITE_BLOW_UP-1) 
                    DB       -1*(SPRITE_BLOW_UP-1), -5*(SPRITE_BLOW_UP-1) 
                    DB       -2*(SPRITE_BLOW_UP-1), -5*(SPRITE_BLOW_UP-1) 
                    DB       0*(SPRITE_BLOW_UP-1), -5*(SPRITE_BLOW_UP-1) 
                    DB       0*(SPRITE_BLOW_UP-1), -5*(SPRITE_BLOW_UP-1) 
                    DB       -1*(SPRITE_BLOW_UP-1), -3*(SPRITE_BLOW_UP-1) 
                    DB       4*(SPRITE_BLOW_UP-1), 0*(SPRITE_BLOW_UP-1) 
log3b_object: 
                    DB       -1                           ; speed + direction 
                    DW       log3b_sprite                 ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       log3c_object                 ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; 
                    DB       0                            ; special flag 
log3c_sprite: 
                    DW       (MAX_LINE_NUM-(10+1))*ONE_LINE_LENGTH 
                    DB       0*(SPRITE_BLOW_UP-1), 5*(SPRITE_BLOW_UP-1) 
                    DB       0*(SPRITE_BLOW_UP-1), 5*(SPRITE_BLOW_UP-1) 
                    DB       0*(SPRITE_BLOW_UP-1), 5*(SPRITE_BLOW_UP-1) 
                    DB       0*(SPRITE_BLOW_UP-1), 5*(SPRITE_BLOW_UP-1) 
                    DB       0*(SPRITE_BLOW_UP-1), 3*(SPRITE_BLOW_UP-1) 
                    DB       -2*(SPRITE_BLOW_UP-1), -5*(SPRITE_BLOW_UP-1) 
                    DB       -2*(SPRITE_BLOW_UP-1), -5*(SPRITE_BLOW_UP-1) 
                    DB       2*(SPRITE_BLOW_UP-1), -5*(SPRITE_BLOW_UP-1) 
                    DB       -2*(SPRITE_BLOW_UP-1), -5*(SPRITE_BLOW_UP-1) 
                    DB       0*(SPRITE_BLOW_UP-1), -3*(SPRITE_BLOW_UP-1) 
                    DB       4*(SPRITE_BLOW_UP-1), 0*(SPRITE_BLOW_UP-1) 
log3c_object: 
                    DB       -1                           ; speed + direction 
                    DW       log3c_sprite                 ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       log3d_object                 ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; 
                    DB       0                            ; special flag 
log3d_sprite: 
                    DW       (MAX_LINE_NUM-(10+1))*ONE_LINE_LENGTH 
                    DB       0*(SPRITE_BLOW_UP-1), 5*(SPRITE_BLOW_UP-1) 
                    DB       0*(SPRITE_BLOW_UP-1), 5*(SPRITE_BLOW_UP-1) 
                    DB       0*(SPRITE_BLOW_UP-1), 5*(SPRITE_BLOW_UP-1) 
                    DB       0*(SPRITE_BLOW_UP-1), 5*(SPRITE_BLOW_UP-1) 
                    DB       0*(SPRITE_BLOW_UP-1), 3*(SPRITE_BLOW_UP-1) 
                    DB       -1*(SPRITE_BLOW_UP-1), -5*(SPRITE_BLOW_UP-1) 
                    DB       -2*(SPRITE_BLOW_UP-1), -5*(SPRITE_BLOW_UP-1) 
                    DB       0*(SPRITE_BLOW_UP-1), -5*(SPRITE_BLOW_UP-1) 
                    DB       -2*(SPRITE_BLOW_UP-1), -5*(SPRITE_BLOW_UP-1) 
                    DB       1*(SPRITE_BLOW_UP-1), -3*(SPRITE_BLOW_UP-1) 
                    DB       4*(SPRITE_BLOW_UP-1), 0*(SPRITE_BLOW_UP-1) 
log3d_object: 
                    DB       -1                           ; speed + direction 
                    DW       log3d_sprite                 ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       log3e_object                 ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; 
                    DB       0                            ; special flag 
log3e_object: 
                    DB       -1                           ; speed + direction 
                    DW       log3c_sprite                 ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       log3f_object                 ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; 
                    DB       0                            ; special flag 
log3f_object: 
                    DB       -1                           ; speed + direction 
                    DW       log3b_sprite                 ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       log3a_object                 ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; 
                    DB       0                            ; special flag 
log4a_sprite: 
                    DW       (MAX_LINE_NUM-(10+1))*ONE_LINE_LENGTH 
                    DB       -2*(SPRITE_BLOW_UP-1), 5*(SPRITE_BLOW_UP-1) 
                    DB       0*(SPRITE_BLOW_UP-1), 5*(SPRITE_BLOW_UP-1) 
                    DB       -2*(SPRITE_BLOW_UP-1), 5*(SPRITE_BLOW_UP-1) 
                    DB       2*(SPRITE_BLOW_UP-1), 5*(SPRITE_BLOW_UP-1) 
                    DB       -2*(SPRITE_BLOW_UP-1), 3*(SPRITE_BLOW_UP-1) 
                    DB       4*(SPRITE_BLOW_UP-1), 0*(SPRITE_BLOW_UP-1) 
                    DB       0*(SPRITE_BLOW_UP-1), -5*(SPRITE_BLOW_UP-1) 
                    DB       0*(SPRITE_BLOW_UP-1), -5*(SPRITE_BLOW_UP-1) 
                    DB       0*(SPRITE_BLOW_UP-1), -5*(SPRITE_BLOW_UP-1) 
                    DB       0*(SPRITE_BLOW_UP-1), -5*(SPRITE_BLOW_UP-1) 
                    DB       0*(SPRITE_BLOW_UP-1), -3*(SPRITE_BLOW_UP-1) 
log4a_object: 
                    DB       -1                           ; speed + direction 
                    DW       log4a_sprite                 ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       log4b_object                 ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; 
                    DB       0                            ; special flag 
log4b_sprite: 
                    DW       (MAX_LINE_NUM-(10+1))*ONE_LINE_LENGTH 
                    DB       -1*(SPRITE_BLOW_UP-1), 5*(SPRITE_BLOW_UP-1) 
                    DB       -2*(SPRITE_BLOW_UP-1), 5*(SPRITE_BLOW_UP-1) 
                    DB       0*(SPRITE_BLOW_UP-1), 5*(SPRITE_BLOW_UP-1) 
                    DB       0*(SPRITE_BLOW_UP-1), 5*(SPRITE_BLOW_UP-1) 
                    DB       -1*(SPRITE_BLOW_UP-1), 3*(SPRITE_BLOW_UP-1) 
                    DB       4*(SPRITE_BLOW_UP-1), 0*(SPRITE_BLOW_UP-1) 
                    DB       0*(SPRITE_BLOW_UP-1), -5*(SPRITE_BLOW_UP-1) 
                    DB       0*(SPRITE_BLOW_UP-1), -5*(SPRITE_BLOW_UP-1) 
                    DB       0*(SPRITE_BLOW_UP-1), -5*(SPRITE_BLOW_UP-1) 
                    DB       0*(SPRITE_BLOW_UP-1), -5*(SPRITE_BLOW_UP-1) 
                    DB       0*(SPRITE_BLOW_UP-1), -3*(SPRITE_BLOW_UP-1) 
log4b_object: 
                    DB       -1                           ; speed + direction 
                    DW       log4b_sprite                 ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       log4c_object                 ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; 
                    DB       0                            ; special flag 
log4c_sprite: 
                    DW       (MAX_LINE_NUM-(10+1))*ONE_LINE_LENGTH 
                    DB       -2*(SPRITE_BLOW_UP-1), 5*(SPRITE_BLOW_UP-1) 
                    DB       -2*(SPRITE_BLOW_UP-1), 5*(SPRITE_BLOW_UP-1) 
                    DB       2*(SPRITE_BLOW_UP-1), 5*(SPRITE_BLOW_UP-1) 
                    DB       -2*(SPRITE_BLOW_UP-1), 5*(SPRITE_BLOW_UP-1) 
                    DB       0*(SPRITE_BLOW_UP-1), 3*(SPRITE_BLOW_UP-1) 
                    DB       4*(SPRITE_BLOW_UP-1), 0*(SPRITE_BLOW_UP-1) 
                    DB       0*(SPRITE_BLOW_UP-1), -5*(SPRITE_BLOW_UP-1) 
                    DB       0*(SPRITE_BLOW_UP-1), -5*(SPRITE_BLOW_UP-1) 
                    DB       0*(SPRITE_BLOW_UP-1), -5*(SPRITE_BLOW_UP-1) 
                    DB       0*(SPRITE_BLOW_UP-1), -5*(SPRITE_BLOW_UP-1) 
                    DB       0*(SPRITE_BLOW_UP-1), -3*(SPRITE_BLOW_UP-1) 
log4c_object: 
                    DB       -1                           ; speed + direction 
                    DW       log4c_sprite                 ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       log4d_object                 ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; 
                    DB       0                            ; special flag 
log4d_sprite: 
                    DW       (MAX_LINE_NUM-(10+1))*ONE_LINE_LENGTH 
                    DB       -1*(SPRITE_BLOW_UP-1), 5*(SPRITE_BLOW_UP-1) 
                    DB       -2*(SPRITE_BLOW_UP-1), 5*(SPRITE_BLOW_UP-1) 
                    DB       0*(SPRITE_BLOW_UP-1), 5*(SPRITE_BLOW_UP-1) 
                    DB       -2*(SPRITE_BLOW_UP-1), 5*(SPRITE_BLOW_UP-1) 
                    DB       1*(SPRITE_BLOW_UP-1), 3*(SPRITE_BLOW_UP-1) 
                    DB       4*(SPRITE_BLOW_UP-1), 0*(SPRITE_BLOW_UP-1) 
                    DB       0*(SPRITE_BLOW_UP-1), -5*(SPRITE_BLOW_UP-1) 
                    DB       0*(SPRITE_BLOW_UP-1), -5*(SPRITE_BLOW_UP-1) 
                    DB       0*(SPRITE_BLOW_UP-1), -5*(SPRITE_BLOW_UP-1) 
                    DB       0*(SPRITE_BLOW_UP-1), -5*(SPRITE_BLOW_UP-1) 
                    DB       0*(SPRITE_BLOW_UP-1), -3*(SPRITE_BLOW_UP-1) 
log4d_object: 
                    DB       -1                           ; speed + direction 
                    DW       log4d_sprite                 ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       log4e_object                 ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; 
                    DB       0                            ; special flag 
log4e_object: 
                    DB       -1                           ; speed + direction 
                    DW       log4c_sprite                 ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       log4f_object                 ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; 
                    DB       0                            ; special flag 
log4f_object: 
                    DB       -1                           ; speed + direction 
                    DW       log4b_sprite                 ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       log4a_object                 ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; 
                    DB       0                            ; special flag 
log9a_object: 
                    DB       -2                           ; speed + direction 
                    DW       log3a_sprite                 ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       log9b_object                 ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; 
                    DB       0                            ; special flag 
log9b_object: 
                    DB       -2                           ; speed + direction 
                    DW       log3b_sprite                 ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       log9c_object                 ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; 
                    DB       0                            ; special flag 
log9c_object: 
                    DB       -2                           ; speed + direction 
                    DW       log3c_sprite                 ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       log9d_object                 ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; 
                    DB       0                            ; special flag 
log9d_object: 
                    DB       -2                           ; speed + direction 
                    DW       log3d_sprite                 ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       log9e_object                 ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; 
                    DB       0                            ; special flag 
log9e_object: 
                    DB       -2                           ; speed + direction 
                    DW       log3c_sprite                 ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       log9f_object                 ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; 
                    DB       0                            ; special flag 
log9f_object: 
                    DB       -2                           ; speed + direction 
                    DW       log3b_sprite                 ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       log9a_object                 ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; 
                    DB       0                            ; special flag 
log10a_object: 
                    DB       -2                           ; speed + direction 
                    DW       log4a_sprite                 ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       log10b_object                ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; 
                    DB       0                            ; special flag 
log10b_object: 
                    DB       -2                           ; speed + direction 
                    DW       log4b_sprite                 ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       log10c_object                ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; 
                    DB       0                            ; special flag 
log10c_object: 
                    DB       -2                           ; speed + direction 
                    DW       log4c_sprite                 ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       log10d_object                ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; 
                    DB       0                            ; special flag 
log10d_object: 
                    DB       -2                           ; speed + direction 
                    DW       log4d_sprite                 ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       log10e_object                ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; 
                    DB       0                            ; special flag 
log10e_object: 
                    DB       -2                           ; speed + direction 
                    DW       log4c_sprite                 ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       log10f_object                ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; 
                    DB       0                            ; special flag 
log10f_object: 
                    DB       -2                           ; speed + direction 
                    DW       log4b_sprite                 ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       log10a_object                ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; 
                    DB       0                            ; special flag 
                    if       ARCADE_MOVE = 1 
; ************** LOG PLUS
log3a_P_object: 
                    DB       1                            ; speed + direction 
                    DW       log3a_sprite                 ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       log3b_P_object               ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; 
                    DB       0                            ; special flag 
log3b_P_object: 
                    DB       1                            ; speed + direction 
                    DW       log3b_sprite                 ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       log3c_P_object               ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; 
                    DB       0                            ; special flag 
log3c_P_object: 
                    DB       1                            ; speed + direction 
                    DW       log3c_sprite                 ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       log3d_P_object               ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; 
                    DB       0                            ; special flag 
log3d_P_object: 
                    DB       1                            ; speed + direction 
                    DW       log3d_sprite                 ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       log3e_P_object               ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; 
                    DB       0                            ; special flag 
log3e_P_object: 
                    DB       1                            ; speed + direction 
                    DW       log3c_sprite                 ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       log3f_P_object               ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; 
                    DB       0                            ; special flag 
log3f_P_object: 
                    DB       1                            ; speed + direction 
                    DW       log3b_sprite                 ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       log3a_P_object               ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; 
                    DB       0                            ; special flag 
log4a_P_object: 
                    DB       1                            ; speed + direction 
                    DW       log4a_sprite                 ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       log4b_P_object               ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; 
                    DB       0                            ; special flag 
log4b_P_object: 
                    DB       1                            ; speed + direction 
                    DW       log4b_sprite                 ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       log4c_P_object               ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; 
                    DB       0                            ; special flag 
log4c_P_object: 
                    DB       1                            ; speed + direction 
                    DW       log4c_sprite                 ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       log4d_P_object               ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; 
                    DB       0                            ; special flag 
log4d_P_object: 
                    DB       1                            ; speed + direction 
                    DW       log4d_sprite                 ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       log4e_P_object               ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; 
                    DB       0                            ; special flag 
log4e_P_object: 
                    DB       1                            ; speed + direction 
                    DW       log4c_sprite                 ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       log4f_P_object               ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; 
                    DB       0                            ; special flag 
log4f_P_object: 
                    DB       1                            ; speed + direction 
                    DW       log4b_sprite                 ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       log4a_P_object               ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; 
                    DB       0                            ; special flag 
log9a_P_object: 
                    DB       2                            ; speed + direction 
                    DW       log3a_sprite                 ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       log9b_P_object               ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; 
                    DB       0                            ; special flag 
log9b_P_object: 
                    DB       2                            ; speed + direction 
                    DW       log3b_sprite                 ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       log9c_P_object               ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; 
                    DB       0                            ; special flag 
log9c_P_object: 
                    DB       2                            ; speed + direction 
                    DW       log3c_sprite                 ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       log9d_P_object               ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; 
                    DB       0                            ; special flag 
log9d_P_object: 
                    DB       2                            ; speed + direction 
                    DW       log3d_sprite                 ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       log9e_P_object               ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; 
                    DB       0                            ; special flag 
log9e_P_object: 
                    DB       2                            ; speed + direction 
                    DW       log3c_sprite                 ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       log9f_P_object               ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; 
                    DB       0                            ; special flag 
log9f_P_object: 
                    DB       2                            ; speed + direction 
                    DW       log3b_sprite                 ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       log9a_P_object               ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; 
                    DB       0                            ; special flag 
log10a_P_object: 
                    DB       2                            ; speed + direction 
                    DW       log4a_sprite                 ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       log10b_P_object              ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; 
                    DB       0                            ; special flag 
log10b_P_object: 
                    DB       2                            ; speed + direction 
                    DW       log4b_sprite                 ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       log10c_P_object              ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; 
                    DB       0                            ; special flag 
log10c_P_object: 
                    DB       2                            ; speed + direction 
                    DW       log4c_sprite                 ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       log10d_P_object              ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; 
                    DB       0                            ; special flag 
log10d_P_object: 
                    DB       2                            ; speed + direction 
                    DW       log4d_sprite                 ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       log10e_P_object              ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; 
                    DB       0                            ; special flag 
log10e_P_object: 
                    DB       2                            ; speed + direction 
                    DW       log4c_sprite                 ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       log10f_P_object              ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; 
                    DB       0                            ; special flag 
log10f_P_object: 
                    DB       2                            ; speed + direction 
                    DW       log4b_sprite                 ; graphic definition 
                    DB       32                           ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       log10a_P_object              ; pointer to next anim object 
                    DB       2                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; 
                    DB       0                            ; special flag 
                    endif    
