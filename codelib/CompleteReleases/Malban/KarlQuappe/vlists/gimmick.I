; this file is part of Karl Quappe, written by Malban
; in 2016
; all stuff contained here is public domain
;
;
; Following are the 3 gimmick definitions
; Gimmick - a sprite is displayed in places "just for fun"
; there is a Pacman, a ghost and a little worm crawling
;
; To show a gimmick following must be true:
;
; not in intermission, not in attract mode, not in training mode
; not on the first level
; at most one house is occupied
; timer must be below 20ticks
; frogger must be heading down
;
; only once per level
; player independend - the enable flag is resetted upon a level complete,
; if one player saw a gimmick the next gimmick is only enabled by viewing a "level done" screen


BLOW_UP_PACMAN      EQU      15 
PACMAN_Y_OFFSET     EQU      0 
PACMAN_X_OFFSET     EQU      0 
PACMAN_ANIM_SPEED   EQU      3 
;
BLOW_UP_GHOST       EQU      12 
GHOST_Y_OFFSET      EQU      0 
GHOST_X_OFFSET      EQU      0 
GHOST_ANIM_SPEED    EQU      3 
GHOST_SPEED         EQU      0 
;
BLOW_UP_WORM       EQU      12 
WORM_Y_OFFSET      EQU      0 
WORM_X_OFFSET      EQU      0 
WORM_ANIM_SPEED    EQU      3 
WORM_SPEED         EQU      1 
PacmanSmall_0: 
                    DW       (MAX_LINE_NUM-($8+1))*ONE_LINE_LENGTH 
                    DB       +$00*BLOW_UP_PACMAN, +$04*BLOW_UP_PACMAN ; draw to y, x 
                    DB       -$03*BLOW_UP_PACMAN, +$03*BLOW_UP_PACMAN ; draw to y, x 
                    DB       -$02*BLOW_UP_PACMAN, +$00*BLOW_UP_PACMAN ; draw to y, x 
                    DB       -$02*BLOW_UP_PACMAN, +$00*BLOW_UP_PACMAN ; draw to y, x 
                    DB       -$03*BLOW_UP_PACMAN, -$03*BLOW_UP_PACMAN ; draw to y, x 
                    DB       +$00*BLOW_UP_PACMAN, -$04*BLOW_UP_PACMAN ; draw to y, x 
                    DB       +$03*BLOW_UP_PACMAN, -$03*BLOW_UP_PACMAN ; draw to y, x 
                    DB       +$04*BLOW_UP_PACMAN, +$00*BLOW_UP_PACMAN ; draw to y, x 
                    DB       +$03*BLOW_UP_PACMAN, +$03*BLOW_UP_PACMAN ; draw to y, x 
PacmanSmall_1: 
                    DW       (MAX_LINE_NUM-($8+1))*ONE_LINE_LENGTH 
                    DB       +$00*BLOW_UP_PACMAN, +$04*BLOW_UP_PACMAN ; draw to y, x 
                    DB       -$04*BLOW_UP_PACMAN, +$03*BLOW_UP_PACMAN ; draw to y, x 
                    DB       -$01*BLOW_UP_PACMAN, -$02*BLOW_UP_PACMAN ; draw to y, x 
                    DB       -$01*BLOW_UP_PACMAN, +$02*BLOW_UP_PACMAN ; draw to y, x 
                    DB       -$04*BLOW_UP_PACMAN, -$03*BLOW_UP_PACMAN ; draw to y, x 
                    DB       +$00*BLOW_UP_PACMAN, -$04*BLOW_UP_PACMAN ; draw to y, x 
                    DB       +$03*BLOW_UP_PACMAN, -$03*BLOW_UP_PACMAN ; draw to y, x 
                    DB       +$04*BLOW_UP_PACMAN, +$00*BLOW_UP_PACMAN ; draw to y, x 
                    DB       +$03*BLOW_UP_PACMAN, +$03*BLOW_UP_PACMAN ; draw to y, x 
PacmanSmall_2: 
                    DW       (MAX_LINE_NUM-($8+1))*ONE_LINE_LENGTH 
                    DB       +$00*BLOW_UP_PACMAN, +$04*BLOW_UP_PACMAN ; draw to y, x 
                    DB       -$03*BLOW_UP_PACMAN, +$03*BLOW_UP_PACMAN ; draw to y, x 
                    DB       -$02*BLOW_UP_PACMAN, -$04*BLOW_UP_PACMAN ; draw to y, x 
                    DB       -$02*BLOW_UP_PACMAN, +$04*BLOW_UP_PACMAN ; draw to y, x 
                    DB       -$03*BLOW_UP_PACMAN, -$03*BLOW_UP_PACMAN ; draw to y, x 
                    DB       +$00*BLOW_UP_PACMAN, -$04*BLOW_UP_PACMAN ; draw to y, x 
                    DB       +$03*BLOW_UP_PACMAN, -$03*BLOW_UP_PACMAN ; draw to y, x 
                    DB       +$04*BLOW_UP_PACMAN, +$00*BLOW_UP_PACMAN ; draw to y, x 
                    DB       +$03*BLOW_UP_PACMAN, +$03*BLOW_UP_PACMAN ; draw to y, x 
PacmanSmall_3: 
                    DW       (MAX_LINE_NUM-($8+1))*ONE_LINE_LENGTH 
                    DB       +$00*BLOW_UP_PACMAN, +$04*BLOW_UP_PACMAN ; draw to y, x 
                    DB       -$02*BLOW_UP_PACMAN, +$03*BLOW_UP_PACMAN ; draw to y, x 
                    DB       -$03*BLOW_UP_PACMAN, -$05*BLOW_UP_PACMAN ; draw to y, x 
                    DB       -$03*BLOW_UP_PACMAN, +$05*BLOW_UP_PACMAN ; draw to y, x 
                    DB       -$02*BLOW_UP_PACMAN, -$03*BLOW_UP_PACMAN ; draw to y, x 
                    DB       +$00*BLOW_UP_PACMAN, -$04*BLOW_UP_PACMAN ; draw to y, x 
                    DB       +$03*BLOW_UP_PACMAN, -$03*BLOW_UP_PACMAN ; draw to y, x 
                    DB       +$04*BLOW_UP_PACMAN, +$00*BLOW_UP_PACMAN ; draw to y, x 
                    DB       +$03*BLOW_UP_PACMAN, +$03*BLOW_UP_PACMAN ; draw to y, x 
pacman1a_object: 
                    DB       1                            ; speed + direction 
                    DW       PacmanSmall_0                ; graphic definition 
                    DB       0                            ; length in SCALE_FACTOR_GAME 
                    DB       PACMAN_ANIM_SPEED            ; anim delay value 
                    DW       pacman1b_object              ; pointer to next anim object 
                    DB       PACMAN_Y_OFFSET              ; offsets y 
                    DB       PACMAN_X_OFFSET              ; offsets x 
pacman1b_object: 
                    DB       1                            ; speed + direction 
                    DW       PacmanSmall_1                ; graphic definition 
                    DB       0                            ; length in SCALE_FACTOR_GAME 
                    DB       PACMAN_ANIM_SPEED            ; anim delay value 
                    DW       pacman1c_object              ; pointer to next anim object 
                    DB       PACMAN_Y_OFFSET              ; offsets y 
                    DB       PACMAN_X_OFFSET              ; offsets x 
pacman1c_object: 
                    DB       1                            ; speed + direction 
                    DW       PacmanSmall_2                ; graphic definition 
                    DB       0                            ; length in SCALE_FACTOR_GAME 
                    DB       PACMAN_ANIM_SPEED            ; anim delay value 
                    DW       pacman1d_object              ; pointer to next anim object 
                    DB       PACMAN_Y_OFFSET              ; offsets y 
                    DB       PACMAN_X_OFFSET              ; offsets x 
pacman1d_object: 
                    DB       1                            ; speed + direction 
                    DW       PacmanSmall_3                ; graphic definition 
                    DB       0                            ; length in SCALE_FACTOR_GAME 
                    DB       PACMAN_ANIM_SPEED            ; anim delay value 
                    DW       pacman1e_object              ; pointer to next anim object 
                    DB       PACMAN_Y_OFFSET              ; offsets y 
                    DB       PACMAN_X_OFFSET              ; offsets x 
pacman1e_object: 
                    DB       1                            ; speed + direction 
                    DW       PacmanSmall_2                ; graphic definition 
                    DB       0                            ; length in SCALE_FACTOR_GAME 
                    DB       PACMAN_ANIM_SPEED            ; anim delay value 
                    DW       pacman1f_object              ; pointer to next anim object 
                    DB       PACMAN_Y_OFFSET              ; offsets y 
                    DB       PACMAN_X_OFFSET              ; offsets x 
pacman1f_object: 
                    DB       1                            ; speed + direction 
                    DW       PacmanSmall_1                ; graphic definition 
                    DB       0                            ; length in SCALE_FACTOR_GAME 
                    DB       PACMAN_ANIM_SPEED            ; anim delay value 
                    DW       pacman1a_object              ; pointer to next anim object 
                    DB       PACMAN_Y_OFFSET              ; offsets y 
                    DB       PACMAN_X_OFFSET              ; offsets x 
;***************************************************************************************
GhostSmall_0: 
                    DW       (MAX_LINE_NUM-($9+1))*ONE_LINE_LENGTH 
                    DB       +$05*BLOW_UP_GHOST, +$00*BLOW_UP_GHOST ; draw to y, x 
                    DB       +$05*BLOW_UP_GHOST, -$01*BLOW_UP_GHOST ; draw to y, x 
                    DB       +$00*BLOW_UP_GHOST, -$05*BLOW_UP_GHOST ; draw to y, x 
                    DB       +$00*BLOW_UP_GHOST, -$05*BLOW_UP_GHOST ; draw to y, x 
                    DB       -$05*BLOW_UP_GHOST, -$01*BLOW_UP_GHOST ; draw to y, x 
                    DB       -$05*BLOW_UP_GHOST, +$00*BLOW_UP_GHOST ; draw to y, x 
                    DB       +$02*BLOW_UP_GHOST, +$04*BLOW_UP_GHOST ; draw to y, x 
                    DB       -$02*BLOW_UP_GHOST, +$03*BLOW_UP_GHOST ; draw to y, x 
                    DB       +$02*BLOW_UP_GHOST, +$03*BLOW_UP_GHOST ; draw to y, x 
                    DB       -$02*BLOW_UP_GHOST, +$02*BLOW_UP_GHOST ; draw to y, x 
GhostSmall_1: 
                    DW       (MAX_LINE_NUM-($9+1))*ONE_LINE_LENGTH 
                    DB       +$05*BLOW_UP_GHOST, +$00*BLOW_UP_GHOST ; draw to y, x 
                    DB       +$05*BLOW_UP_GHOST, -$01*BLOW_UP_GHOST ; draw to y, x 
                    DB       +$00*BLOW_UP_GHOST, -$05*BLOW_UP_GHOST ; draw to y, x 
                    DB       +$00*BLOW_UP_GHOST, -$05*BLOW_UP_GHOST ; draw to y, x 
                    DB       -$05*BLOW_UP_GHOST, -$01*BLOW_UP_GHOST ; draw to y, x 
                    DB       -$05*BLOW_UP_GHOST, +$00*BLOW_UP_GHOST ; draw to y, x 
                    DB       +$02*BLOW_UP_GHOST, +$02*BLOW_UP_GHOST ; draw to y, x 
                    DB       -$02*BLOW_UP_GHOST, +$03*BLOW_UP_GHOST ; draw to y, x 
                    DB       +$02*BLOW_UP_GHOST, +$03*BLOW_UP_GHOST ; draw to y, x 
                    DB       -$02*BLOW_UP_GHOST, +$04*BLOW_UP_GHOST ; draw to y, x 
GhostSmall_2: 
                    DW       (MAX_LINE_NUM-($9+1))*ONE_LINE_LENGTH 
                    DB       +$05*BLOW_UP_GHOST, +$00*BLOW_UP_GHOST ; draw to y, x 
                    DB       +$05*BLOW_UP_GHOST, -$01*BLOW_UP_GHOST ; draw to y, x 
                    DB       +$00*BLOW_UP_GHOST, -$05*BLOW_UP_GHOST ; draw to y, x 
                    DB       +$00*BLOW_UP_GHOST, -$05*BLOW_UP_GHOST ; draw to y, x 
                    DB       -$05*BLOW_UP_GHOST, -$01*BLOW_UP_GHOST ; draw to y, x 
                    DB       -$05*BLOW_UP_GHOST, +$00*BLOW_UP_GHOST ; draw to y, x 
                    DB       +$02*BLOW_UP_GHOST, +$05*BLOW_UP_GHOST ; draw to y, x 
                    DB       -$02*BLOW_UP_GHOST, +$03*BLOW_UP_GHOST ; draw to y, x 
                    DB       +$02*BLOW_UP_GHOST, +$03*BLOW_UP_GHOST ; draw to y, x 
                    DB       -$02*BLOW_UP_GHOST, +$01*BLOW_UP_GHOST ; draw to y, x 
ghost1a_object: 
                    DB       GHOST_SPEED                  ; speed + direction 
                    DW       GhostSmall_0                 ; graphic definition 
                    DB       0                            ; length in SCALE_FACTOR_GAME 
                    DB       GHOST_ANIM_SPEED             ; anim delay value 
                    DW       ghost1b_object               ; pointer to next anim object 
                    DB       GHOST_Y_OFFSET               ; offsets y 
                    DB       GHOST_X_OFFSET               ; offsets x 
ghost1b_object: 
                    DB       GHOST_SPEED                  ; speed + direction 
                    DW       GhostSmall_1                 ; graphic definition 
                    DB       0                            ; length in SCALE_FACTOR_GAME 
                    DB       GHOST_ANIM_SPEED             ; anim delay value 
                    DW       ghost1c_object               ; pointer to next anim object 
                    DB       GHOST_Y_OFFSET               ; offsets y 
                    DB       GHOST_X_OFFSET               ; offsets x 
ghost1c_object: 
                    DB       GHOST_SPEED                  ; speed + direction 
                    DW       GhostSmall_2                 ; graphic definition 
                    DB       0                            ; length in SCALE_FACTOR_GAME 
                    DB       GHOST_ANIM_SPEED             ; anim delay value 
                    DW       ghost1d_object               ; pointer to next anim object 
                    DB       GHOST_Y_OFFSET               ; offsets y 
                    DB       GHOST_X_OFFSET               ; offsets x 
ghost1d_object: 
                    DB       GHOST_SPEED                  ; speed + direction 
                    DW       GhostSmall_1                 ; graphic definition 
                    DB       0                            ; length in SCALE_FACTOR_GAME 
                    DB       GHOST_ANIM_SPEED             ; anim delay value 
                    DW       ghost1a_object               ; pointer to next anim object 
                    DB       GHOST_Y_OFFSET               ; offsets y 
                    DB       GHOST_X_OFFSET               ; offsets x 

WormSmall_0:
                    DW       (MAX_LINE_NUM-($2+1))*ONE_LINE_LENGTH 
 DB +$00*BLOW_UP_WORM, +$05*BLOW_UP_WORM ; draw to y, x
 DB +$00*BLOW_UP_WORM, +$04*BLOW_UP_WORM ; draw to y, x
 DB +$01*BLOW_UP_WORM, +$01*BLOW_UP_WORM ; draw to y, x
WormSmall_1:
                    DW       (MAX_LINE_NUM-($4+1))*ONE_LINE_LENGTH 
 DB +$00*BLOW_UP_WORM, +$03*BLOW_UP_WORM ; draw to y, x
 DB +$02*BLOW_UP_WORM, +$04*BLOW_UP_WORM ; draw to y, x
 DB -$02*BLOW_UP_WORM, +$01*BLOW_UP_WORM ; draw to y, x
 DB +$00*BLOW_UP_WORM, +$01*BLOW_UP_WORM ; draw to y, x
 DB +$01*BLOW_UP_WORM, +$01*BLOW_UP_WORM ; draw to y, x
WormSmall_2:
                    DW       (MAX_LINE_NUM-($5+1))*ONE_LINE_LENGTH 
 DB +$00*BLOW_UP_WORM, +$03*BLOW_UP_WORM ; draw to y, x
 DB +$02*BLOW_UP_WORM, +$01*BLOW_UP_WORM ; draw to y, x
 DB +$01*BLOW_UP_WORM, +$02*BLOW_UP_WORM ; draw to y, x
 DB -$03*BLOW_UP_WORM, +$01*BLOW_UP_WORM ; draw to y, x
 DB +$00*BLOW_UP_WORM, +$01*BLOW_UP_WORM ; draw to y, x
 DB +$01*BLOW_UP_WORM, +$01*BLOW_UP_WORM ; draw to y, x
WormSmall_3:
                    DW       (MAX_LINE_NUM-($5+1))*ONE_LINE_LENGTH 
 DB +$00*BLOW_UP_WORM, +$02*BLOW_UP_WORM ; draw to y, x
 DB +$03*BLOW_UP_WORM, +$01*BLOW_UP_WORM ; draw to y, x
 DB -$01*BLOW_UP_WORM, +$02*BLOW_UP_WORM ; draw to y, x
 DB -$02*BLOW_UP_WORM, +$01*BLOW_UP_WORM ; draw to y, x
 DB +$00*BLOW_UP_WORM, +$01*BLOW_UP_WORM ; draw to y, x
 DB +$01*BLOW_UP_WORM, +$01*BLOW_UP_WORM ; draw to y, x
WormSmall_4:
                    DW       (MAX_LINE_NUM-($5+1))*ONE_LINE_LENGTH 
 DB +$00*BLOW_UP_WORM, +$02*BLOW_UP_WORM ; draw to y, x
 DB +$02*BLOW_UP_WORM, +$00*BLOW_UP_WORM ; draw to y, x
 DB +$01*BLOW_UP_WORM, +$02*BLOW_UP_WORM ; draw to y, x
 DB -$03*BLOW_UP_WORM, +$00*BLOW_UP_WORM ; draw to y, x
 DB +$01*BLOW_UP_WORM, +$02*BLOW_UP_WORM ; draw to y, x
 DB +$01*BLOW_UP_WORM, +$01*BLOW_UP_WORM ; draw to y, x
WormSmall_5:
                    DW       (MAX_LINE_NUM-($4+1))*ONE_LINE_LENGTH 
 DB +$00*BLOW_UP_WORM, +$02*BLOW_UP_WORM ; draw to y, x
 DB +$02*BLOW_UP_WORM, +$01*BLOW_UP_WORM ; draw to y, x
 DB -$01*BLOW_UP_WORM, +$03*BLOW_UP_WORM ; draw to y, x
 DB +$01*BLOW_UP_WORM, +$02*BLOW_UP_WORM ; draw to y, x
 DB +$01*BLOW_UP_WORM, +$01*BLOW_UP_WORM ; draw to y, x
WormSmall_6:
                    DW       (MAX_LINE_NUM-($4+1))*ONE_LINE_LENGTH 
 DB +$00*BLOW_UP_WORM, +$03*BLOW_UP_WORM ; draw to y, x
 DB +$01*BLOW_UP_WORM, +$02*BLOW_UP_WORM ; draw to y, x
 DB -$01*BLOW_UP_WORM, +$02*BLOW_UP_WORM ; draw to y, x
 DB +$01*BLOW_UP_WORM, +$02*BLOW_UP_WORM ; draw to y, x
 DB +$01*BLOW_UP_WORM, +$01*BLOW_UP_WORM ; draw to y, x

worm1a_object: 
                    DB       WORM_SPEED                  ; speed + direction 
                    DW       WormSmall_0                 ; graphic definition 
                    DB       0                            ; length in SCALE_FACTOR_GAME 
                    DB       WORM_ANIM_SPEED             ; anim delay value 
                    DW       worm1b_object               ; pointer to next anim object 
                    DB       WORM_Y_OFFSET               ; offsets y 
                    DB       WORM_X_OFFSET               ; offsets x 

worm1b_object: 
                    DB       WORM_SPEED                  ; speed + direction 
                    DW       WormSmall_1                 ; graphic definition 
                    DB       0                            ; length in SCALE_FACTOR_GAME 
                    DB       WORM_ANIM_SPEED             ; anim delay value 
                    DW       worm1c_object               ; pointer to next anim object 
                    DB       WORM_Y_OFFSET               ; offsets y 
                    DB       WORM_X_OFFSET               ; offsets x 

worm1c_object: 
                    DB       WORM_SPEED                  ; speed + direction 
                    DW       WormSmall_2                 ; graphic definition 
                    DB       0                            ; length in SCALE_FACTOR_GAME 
                    DB       WORM_ANIM_SPEED             ; anim delay value 
                    DW       worm1d_object               ; pointer to next anim object 
                    DB       WORM_Y_OFFSET               ; offsets y 
                    DB       WORM_X_OFFSET               ; offsets x 

worm1d_object: 
                    DB       WORM_SPEED                  ; speed + direction 
                    DW       WormSmall_3                 ; graphic definition 
                    DB       0                            ; length in SCALE_FACTOR_GAME 
                    DB       WORM_ANIM_SPEED             ; anim delay value 
                    DW       worm1e_object               ; pointer to next anim object 
                    DB       WORM_Y_OFFSET               ; offsets y 
                    DB       WORM_X_OFFSET               ; offsets x 

worm1e_object: 
                    DB       WORM_SPEED                  ; speed + direction 
                    DW       WormSmall_4                 ; graphic definition 
                    DB       0                            ; length in SCALE_FACTOR_GAME 
                    DB       WORM_ANIM_SPEED             ; anim delay value 
                    DW       worm1f_object               ; pointer to next anim object 
                    DB       WORM_Y_OFFSET               ; offsets y 
                    DB       WORM_X_OFFSET               ; offsets x 

worm1f_object: 
                    DB       WORM_SPEED                  ; speed + direction 
                    DW       WormSmall_5                 ; graphic definition 
                    DB       0                            ; length in SCALE_FACTOR_GAME 
                    DB       WORM_ANIM_SPEED             ; anim delay value 
                    DW       worm1g_object               ; pointer to next anim object 
                    DB       WORM_Y_OFFSET               ; offsets y 
                    DB       WORM_X_OFFSET               ; offsets x 

worm1g_object: 
                    DB       WORM_SPEED                  ; speed + direction 
                    DW       WormSmall_6                 ; graphic definition 
                    DB       0                            ; length in SCALE_FACTOR_GAME 
                    DB       WORM_ANIM_SPEED             ; anim delay value 
                    DW       worm1a_object               ; pointer to next anim object 
                    DB       WORM_Y_OFFSET               ; offsets y 
                    DB       WORM_X_OFFSET               ; offsets x 

