; this file is part of Karl Quappe, written by Malban
; in 2016
; all stuff contained here is public domain
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this file contains all 'sprite' definitions for turtles used in           ;
; vectrex frogger (excluding the '0')                                       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; for collision checking: SPRITES MUST HAVE THE LEFTMOST POINT AS STARTVECTOR (*)
; turtle1 is moving to the right with a speed of 1
; turtle2 is moving to the left with a speed of -1
; turtle3 is moving to the right with a speed of 2
; turtle4 is moving to the left with a speed of -2
TURTLE_LENGTH       =        27 
SPRITE_BLOW_UP_TURTLE = SPRITE_BLOW_UP-3
SPRITE_BLOW_UP_TURTLE_y = SPRITE_BLOW_UP_TURTLE-3
turtle1a_sprite: 
                    DW       (MAX_LINE_NUM-(10+1))*ONE_LINE_LENGTH 
                    DB       -5*SPRITE_BLOW_UP_TURTLE_y, 5*SPRITE_BLOW_UP_TURTLE 
                    DB       2*SPRITE_BLOW_UP_TURTLE_y, 5*SPRITE_BLOW_UP_TURTLE 
                    DB       -3*SPRITE_BLOW_UP_TURTLE_y, 4*SPRITE_BLOW_UP_TURTLE 
                    DB       5*SPRITE_BLOW_UP_TURTLE_y, -2*SPRITE_BLOW_UP_TURTLE 
                    DB       -1*SPRITE_BLOW_UP_TURTLE_y, 5*SPRITE_BLOW_UP_TURTLE 
                    DB       4*SPRITE_BLOW_UP_TURTLE_y, 0*SPRITE_BLOW_UP_TURTLE 
                    DB       -1*SPRITE_BLOW_UP_TURTLE_y, -5*SPRITE_BLOW_UP_TURTLE 
                    DB       5*SPRITE_BLOW_UP_TURTLE_y, 2*SPRITE_BLOW_UP_TURTLE 
                    DB       -3*SPRITE_BLOW_UP_TURTLE_y, -4*SPRITE_BLOW_UP_TURTLE 
                    DB       1*SPRITE_BLOW_UP_TURTLE_y, -5*SPRITE_BLOW_UP_TURTLE 
                    DB       -4*SPRITE_BLOW_UP_TURTLE_y, -5*SPRITE_BLOW_UP_TURTLE 
turtle1a_object: 
                    DB       1                            ; speed + direction 
                    DW       turtle1a_sprite              ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       turtle1b_object              ; pointer to next anim object 
                    DB       0                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       1                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
turtle1b_sprite: 
                    DW       (MAX_LINE_NUM-(12+1))*ONE_LINE_LENGTH 
                    DB       -3*SPRITE_BLOW_UP_TURTLE_y, 5*SPRITE_BLOW_UP_TURTLE 
                    DB       -2*SPRITE_BLOW_UP_TURTLE_y, 0*SPRITE_BLOW_UP_TURTLE 
                    DB       1*SPRITE_BLOW_UP_TURTLE_y, 4*SPRITE_BLOW_UP_TURTLE 
                    DB       -2*SPRITE_BLOW_UP_TURTLE_y, 1*SPRITE_BLOW_UP_TURTLE 
                    DB       5*SPRITE_BLOW_UP_TURTLE_y, 2*SPRITE_BLOW_UP_TURTLE 
                    DB       -1*SPRITE_BLOW_UP_TURTLE_y, 5*SPRITE_BLOW_UP_TURTLE 
                    DB       4*SPRITE_BLOW_UP_TURTLE_y, 0*SPRITE_BLOW_UP_TURTLE 
                    DB       -1*SPRITE_BLOW_UP_TURTLE_y, -5*SPRITE_BLOW_UP_TURTLE 
                    DB       5*SPRITE_BLOW_UP_TURTLE_y, -2*SPRITE_BLOW_UP_TURTLE 
                    DB       -2*SPRITE_BLOW_UP_TURTLE_y, -1*SPRITE_BLOW_UP_TURTLE 
                    DB       1*SPRITE_BLOW_UP_TURTLE_y, -4*SPRITE_BLOW_UP_TURTLE 
                    DB       -2*SPRITE_BLOW_UP_TURTLE_y, 0*SPRITE_BLOW_UP_TURTLE 
                    DB       -3*SPRITE_BLOW_UP_TURTLE_y, -5*SPRITE_BLOW_UP_TURTLE 
turtle1b_object: 
                    DB       1                            ; speed + direction 
                    DW       turtle1b_sprite              ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       turtle1c_object              ; pointer to next anim object 
                    DB       0                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       1                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
turtle1c_sprite: 
                    DW       (MAX_LINE_NUM-(12+1))*ONE_LINE_LENGTH 
                    DB       -3*SPRITE_BLOW_UP_TURTLE_y, 5*SPRITE_BLOW_UP_TURTLE 
                    DB       -2*SPRITE_BLOW_UP_TURTLE_y, -1*SPRITE_BLOW_UP_TURTLE 
                    DB       1*SPRITE_BLOW_UP_TURTLE_y, 5*SPRITE_BLOW_UP_TURTLE 
                    DB       -2*SPRITE_BLOW_UP_TURTLE_y, -1*SPRITE_BLOW_UP_TURTLE 
                    DB       5*SPRITE_BLOW_UP_TURTLE_y, 4*SPRITE_BLOW_UP_TURTLE 
                    DB       -1*SPRITE_BLOW_UP_TURTLE_y, 5*SPRITE_BLOW_UP_TURTLE 
                    DB       4*SPRITE_BLOW_UP_TURTLE_y, 0*SPRITE_BLOW_UP_TURTLE 
                    DB       -1*SPRITE_BLOW_UP_TURTLE_y, -5*SPRITE_BLOW_UP_TURTLE 
                    DB       5*SPRITE_BLOW_UP_TURTLE_y, -4*SPRITE_BLOW_UP_TURTLE 
                    DB       -2*SPRITE_BLOW_UP_TURTLE_y, 1*SPRITE_BLOW_UP_TURTLE 
                    DB       1*SPRITE_BLOW_UP_TURTLE_y, -5*SPRITE_BLOW_UP_TURTLE 
                    DB       -2*SPRITE_BLOW_UP_TURTLE_y, 1*SPRITE_BLOW_UP_TURTLE 
                    DB       -3*SPRITE_BLOW_UP_TURTLE_y, -5*SPRITE_BLOW_UP_TURTLE 
turtle1c_object: 
                    DB       1                            ; speed + direction 
                    DW       turtle1c_sprite              ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       turtle1a_object              ; pointer to next anim object 
                    DB       0                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       1                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
turtle2a_sprite: 
                    DW       (MAX_LINE_NUM-(10+1))*ONE_LINE_LENGTH 
                    DB       4*SPRITE_BLOW_UP_TURTLE_y, 0*SPRITE_BLOW_UP_TURTLE 
                    DB       -1*SPRITE_BLOW_UP_TURTLE_y, 5*SPRITE_BLOW_UP_TURTLE 
                    DB       5*SPRITE_BLOW_UP_TURTLE_y, -2*SPRITE_BLOW_UP_TURTLE 
                    DB       -3*SPRITE_BLOW_UP_TURTLE_y, 4*SPRITE_BLOW_UP_TURTLE 
                    DB       1*SPRITE_BLOW_UP_TURTLE_y, 5*SPRITE_BLOW_UP_TURTLE 
                    DB       -4*SPRITE_BLOW_UP_TURTLE_y, 5*SPRITE_BLOW_UP_TURTLE 
                    DB       -5*SPRITE_BLOW_UP_TURTLE_y, -5*SPRITE_BLOW_UP_TURTLE 
                    DB       2*SPRITE_BLOW_UP_TURTLE_y, -5*SPRITE_BLOW_UP_TURTLE 
                    DB       -3*SPRITE_BLOW_UP_TURTLE_y, -4*SPRITE_BLOW_UP_TURTLE 
                    DB       5*SPRITE_BLOW_UP_TURTLE_y, 2*SPRITE_BLOW_UP_TURTLE 
                    DB       -1*SPRITE_BLOW_UP_TURTLE_y, -5*SPRITE_BLOW_UP_TURTLE 
turtle2a_object: 
                    DB       -1                           ; speed + direction 
                    DW       turtle2a_sprite              ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       turtle2b_object              ; pointer to next anim object 
                    DB       -3                           ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       1                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
turtle2b_sprite: 
                    DW       (MAX_LINE_NUM-(12+1))*ONE_LINE_LENGTH 
                    DB       4*SPRITE_BLOW_UP_TURTLE_y, 0*SPRITE_BLOW_UP_TURTLE 
                    DB       -1*SPRITE_BLOW_UP_TURTLE_y, 5*SPRITE_BLOW_UP_TURTLE 
                    DB       5*SPRITE_BLOW_UP_TURTLE_y, 2*SPRITE_BLOW_UP_TURTLE 
                    DB       -2*SPRITE_BLOW_UP_TURTLE_y, 1*SPRITE_BLOW_UP_TURTLE 
                    DB       1*SPRITE_BLOW_UP_TURTLE_y, 4*SPRITE_BLOW_UP_TURTLE 
                    DB       -2*SPRITE_BLOW_UP_TURTLE_y, 0*SPRITE_BLOW_UP_TURTLE 
                    DB       -3*SPRITE_BLOW_UP_TURTLE_y, 5*SPRITE_BLOW_UP_TURTLE 
                    DB       -3*SPRITE_BLOW_UP_TURTLE_y, -5*SPRITE_BLOW_UP_TURTLE 
                    DB       -2*SPRITE_BLOW_UP_TURTLE_y, 0*SPRITE_BLOW_UP_TURTLE 
                    DB       1*SPRITE_BLOW_UP_TURTLE_y, -4*SPRITE_BLOW_UP_TURTLE 
                    DB       -2*SPRITE_BLOW_UP_TURTLE_y, -1*SPRITE_BLOW_UP_TURTLE 
                    DB       5*SPRITE_BLOW_UP_TURTLE_y, -2*SPRITE_BLOW_UP_TURTLE 
                    DB       -1*SPRITE_BLOW_UP_TURTLE_y, -5*SPRITE_BLOW_UP_TURTLE 
turtle2b_object: 
                    DB       -1                           ; speed + direction 
                    DW       turtle2b_sprite              ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       turtle2c_object              ; pointer to next anim object 
                    DB       -3                           ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       1                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
turtle2c_sprite: 
                    DW       (MAX_LINE_NUM-(12+1))*ONE_LINE_LENGTH 
                    DB       4*SPRITE_BLOW_UP_TURTLE_y, 0*SPRITE_BLOW_UP_TURTLE 
                    DB       -1*SPRITE_BLOW_UP_TURTLE_y, 5*SPRITE_BLOW_UP_TURTLE 
                    DB       5*SPRITE_BLOW_UP_TURTLE_y, 4*SPRITE_BLOW_UP_TURTLE 
                    DB       -2*SPRITE_BLOW_UP_TURTLE_y, -1*SPRITE_BLOW_UP_TURTLE 
                    DB       1*SPRITE_BLOW_UP_TURTLE_y, 5*SPRITE_BLOW_UP_TURTLE 
                    DB       -2*SPRITE_BLOW_UP_TURTLE_y, -1*SPRITE_BLOW_UP_TURTLE 
                    DB       -3*SPRITE_BLOW_UP_TURTLE_y, 5*SPRITE_BLOW_UP_TURTLE 
                    DB       -3*SPRITE_BLOW_UP_TURTLE_y, -5*SPRITE_BLOW_UP_TURTLE 
                    DB       -2*SPRITE_BLOW_UP_TURTLE_y, 1*SPRITE_BLOW_UP_TURTLE 
                    DB       1*SPRITE_BLOW_UP_TURTLE_y, -5*SPRITE_BLOW_UP_TURTLE 
                    DB       -2*SPRITE_BLOW_UP_TURTLE_y, 1*SPRITE_BLOW_UP_TURTLE 
                    DB       5*SPRITE_BLOW_UP_TURTLE_y, -4*SPRITE_BLOW_UP_TURTLE 
                    DB       -1*SPRITE_BLOW_UP_TURTLE_y, -5*SPRITE_BLOW_UP_TURTLE 
turtle2c_object: 
                    DB       -1                           ; speed + direction 
                    DW       turtle2c_sprite              ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       turtle2a_object              ; pointer to next anim object 
                    DB       -3                           ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       1                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
turtle3a_object: 
                    DB       2                            ; speed + direction 
                    DW       turtle1a_sprite              ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       2                            ; anim delay value 
                    DW       turtle3b_object              ; pointer to next anim object 
                    DB       0                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       1                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
turtle3b_object: 
                    DB       2                            ; speed + direction 
                    DW       turtle1b_sprite              ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       2                            ; anim delay value 
                    DW       turtle3c_object              ; pointer to next anim object 
                    DB       0                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       1                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
turtle3c_object: 
                    DB       2                            ; speed + direction 
                    DW       turtle1c_sprite              ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       2                            ; anim delay value 
                    DW       turtle3a_object              ; pointer to next anim object 
                    DB       0                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       1                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
turtle4a_object: 
                    DB       -2                           ; speed + direction 
                    DW       turtle2a_sprite              ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       2                            ; anim delay value 
                    DW       turtle4b_object              ; pointer to next anim object 
                    DB       -3                           ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       1                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
turtle4b_object: 
                    DB       -2                           ; speed + direction 
                    DW       turtle2b_sprite              ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       2                            ; anim delay value 
                    DW       turtle4c_object              ; pointer to next anim object 
                    DB       -3                           ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       1                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
turtle4c_object: 
                    DB       -2                           ; speed + direction 
                    DW       turtle2c_sprite              ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       2                            ; anim delay value 
                    DW       turtle4a_object              ; pointer to next anim object 
                    DB       -3                           ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       1                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
turtled1a_object: 
                    DB       1                            ; speed + direction 
                    DW       turtle1a_sprite              ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       turtled1b_object             ; pointer to next anim object 
                    DB       0                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       1                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_DIVE_UP              ; special flag 
                    DW       turtlea1a_object             ; alternate object for diving 
turtled1b_object: 
                    DB       1                            ; speed + direction 
                    DW       turtle1b_sprite              ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       turtled1c_object             ; pointer to next anim object 
                    DB       0                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       1                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_DIVE_UP              ; special flag 
                    DW       turtlea1a_object             ; alternate object for diving 
turtled1c_object: 
                    DB       1                            ; speed + direction 
                    DW       turtle1c_sprite              ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       turtled1a_object             ; pointer to next anim object 
                    DB       0                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       1                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_DIVE_UP              ; special flag 
                    DW       turtlea1a_object             ; alternate object for diving 
turtled2a_object: 
                    DB       -1                           ; speed + direction 
                    DW       turtle2a_sprite              ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       turtled2b_object             ; pointer to next anim object 
                    DB       -3                           ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       1                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_DIVE_UP              ; special flag 
                    DW       turtlea2a_object             ; alternate object for diving 
turtled2b_object: 
                    DB       -1                           ; speed + direction 
                    DW       turtle2b_sprite              ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       turtled2c_object             ; pointer to next anim object 
                    DB       -3                           ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       1                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_DIVE_UP              ; special flag 
                    DW       turtlea2a_object             ; alternate object for diving 
turtled2c_object: 
                    DB       -1                           ; speed + direction 
                    DW       turtle2c_sprite              ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       turtled2a_object             ; pointer to next anim object 
                    DB       -3                           ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       1                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_DIVE_UP              ; special flag 
                    DW       turtlea2a_object             ; alternate object for diving 
turtled3a_object: 
                    DB       2                            ; speed + direction 
                    DW       turtle1a_sprite              ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       2                            ; anim delay value 
                    DW       turtled3b_object             ; pointer to next anim object 
                    DB       0                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       1                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_DIVE_UP              ; special flag 
                    DW       turtlea3a_object             ; alternate object for diving 
turtled3b_object: 
                    DB       2                            ; speed + direction 
                    DW       turtle1b_sprite              ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       2                            ; anim delay value 
                    DW       turtled3c_object             ; pointer to next anim object 
                    DB       0                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       1                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_DIVE_UP              ; special flag 
                    DW       turtlea3a_object             ; alternate object for diving 
turtled3c_object: 
                    DB       2                            ; speed + direction 
                    DW       turtle1c_sprite              ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       2                            ; anim delay value 
                    DW       turtled3a_object             ; pointer to next anim object 
                    DB       0                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       1                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_DIVE_UP              ; special flag 
                    DW       turtlea3a_object             ; alternate object for diving 
turtled4a_object: 
                    DB       -2                           ; speed + direction 
                    DW       turtle2a_sprite              ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       2                            ; anim delay value 
                    DW       turtled4b_object             ; pointer to next anim object 
                    DB       -3                           ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       1                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_DIVE_UP              ; special flag 
                    DW       turtlea4a_object             ; alternate object for diving 
turtled4b_object: 
                    DB       -2                           ; speed + direction 
                    DW       turtle2b_sprite              ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       2                            ; anim delay value 
                    DW       turtled4c_object             ; pointer to next anim object 
                    DB       -3                           ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       1                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_DIVE_UP              ; special flag 
                    DW       turtlea4a_object             ; alternate object for diving 
turtled4c_object: 
                    DB       -2                           ; speed + direction 
                    DW       turtle2c_sprite              ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       2                            ; anim delay value 
                    DW       turtled4a_object             ; pointer to next anim object 
                    DB       -3                           ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       1                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_DIVE_UP              ; special flag 
                    DW       turtlea4a_object             ; alternate object for diving 
; sprite definition
turtlea1a_sprite: 
                    DW       (MAX_LINE_NUM-(8+1))*ONE_LINE_LENGTH 
                    DB       -2*SPRITE_BLOW_UP, 3*SPRITE_BLOW_UP 
                    DB       -1*SPRITE_BLOW_UP, 4*SPRITE_BLOW_UP 
                    DB       2*SPRITE_BLOW_UP, 3*SPRITE_BLOW_UP 
                    DB       -1*SPRITE_BLOW_UP, 2*SPRITE_BLOW_UP 
                    DB       4*SPRITE_BLOW_UP, 0*SPRITE_BLOW_UP 
                    DB       -1*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP 
                    DB       2*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP 
                    DB       -1*SPRITE_BLOW_UP, -4*SPRITE_BLOW_UP 
                    DB       -2*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP 
; sprite definition
turtlea1b_sprite: 
                    DW       (MAX_LINE_NUM-(8+1))*ONE_LINE_LENGTH 
                    DB       -1*SPRITE_BLOW_UP, 1*SPRITE_BLOW_UP 
                    DB       -1*SPRITE_BLOW_UP, 4*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, 3*SPRITE_BLOW_UP 
                    DB       0*SPRITE_BLOW_UP, 0*SPRITE_BLOW_UP 
                    DB       2*SPRITE_BLOW_UP, 0*SPRITE_BLOW_UP 
                    DB       0*SPRITE_BLOW_UP, 0*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP 
                    DB       -1*SPRITE_BLOW_UP, -4*SPRITE_BLOW_UP 
                    DB       -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP 
; sprite definition
turtlea1c_sprite: 
                    DW       (MAX_LINE_NUM-(5+1))*ONE_LINE_LENGTH 
                    DB       1*SPRITE_BLOW_UP, 2*SPRITE_BLOW_UP 
                    DB       0*SPRITE_BLOW_UP, 1*SPRITE_BLOW_UP 
                    DB       -1*SPRITE_BLOW_UP, 2*SPRITE_BLOW_UP 
                    DB       -1*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP 
                    DB       0*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP 
turtlea1d_sprite: 
; sprite definition
                    DW       (MAX_LINE_NUM-(13+1))*ONE_LINE_LENGTH 
                    DB       -3*SPRITE_BLOW_UP, 4*SPRITE_BLOW_UP 
                    DB       3*SPRITE_BLOW_UP, 4*SPRITE_BLOW_UP 
                    DB       3*SPRITE_BLOW_UP, -4*SPRITE_BLOW_UP 
                    DB       -3*SPRITE_BLOW_UP, -4*SPRITE_BLOW_UP 
                    DB       0*SPRITE_BLOW_UP, 1*SPRITE_BLOW_UP 
                    DB       -2*SPRITE_BLOW_UP, 3*SPRITE_BLOW_UP 
                    DB       2*SPRITE_BLOW_UP, 3*SPRITE_BLOW_UP 
                    DB       2*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP 
                    DB       -2*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP 
                    DB       0*SPRITE_BLOW_UP, 1*SPRITE_BLOW_UP 
                    DB       -1*SPRITE_BLOW_UP, 2*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, 2*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP 
                    DB       -1*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP 
; sprite definition
turtlea1e_sprite: 
                    DW       (MAX_LINE_NUM-(8+1))*ONE_LINE_LENGTH 
                    DB       -2*SPRITE_BLOW_UP, 4*SPRITE_BLOW_UP 
                    DB       2*SPRITE_BLOW_UP, 4*SPRITE_BLOW_UP 
                    DB       2*SPRITE_BLOW_UP, -4*SPRITE_BLOW_UP 
                    DB       -2*SPRITE_BLOW_UP, -4*SPRITE_BLOW_UP 
                    DB       0*SPRITE_BLOW_UP, 1*SPRITE_BLOW_UP 
                    DB       -1*SPRITE_BLOW_UP, 3*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, 3*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP 
                    DB       -1*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP 
; sprite definition
turtlea1f_sprite: 
                    DW       (MAX_LINE_NUM-(3+1))*ONE_LINE_LENGTH 
                    DB       -1*SPRITE_BLOW_UP, 4*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, 4*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, -4*SPRITE_BLOW_UP 
                    DB       -1*SPRITE_BLOW_UP, -4*SPRITE_BLOW_UP 
turtlea1a_object: 
                    DB       1                            ; speed + direction 
                    DW       turtlea1a_sprite             ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       15                           ; anim delay value 
                    DW       turtlea1b_object             ; pointer to next anim object 
                    DB       0                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       2                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_DIVE_UP              ; special flag 
                    DW       turtleb1a_object             ; alternate object for diving 
turtlea1b_object: 
                    DB       1                            ; speed + direction 
                    DW       turtlea1b_sprite             ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       15                           ; anim delay value 
                    DW       turtlea1c_object             ; pointer to next anim object 
                    DB       0                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       4                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_DIVE_UP              ; special flag 
                    DW       turtleb1a_object             ; alternate object for diving 
turtlea1c_object: 
                    DB       1                            ; speed + direction 
                    DW       turtlea1c_sprite             ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       15                           ; anim delay value 
                    DW       turtlea1d_object             ; pointer to next anim object 
                    DB       0                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       5                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_DIVE_UP              ; special flag 
                    DW       turtleb1a_object             ; alternate object for diving 
turtlea1d_object: 
                    DB       1                            ; speed + direction 
                    DW       turtlea1d_sprite             ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       turtlea1e_object             ; pointer to next anim object 
                    DB       0                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       3                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_DIVE_DOWN            ; special flag 
                    DW       turtleb1a_object             ; alternate object for diving 
turtlea1e_object: 
                    DB       1                            ; speed + direction 
                    DW       turtlea1e_sprite             ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       turtlea1f_object             ; pointer to next anim object 
                    DB       0                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       3                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_DIVE_DOWN            ; special flag 
                    DW       turtleb1a_object             ; alternate object for diving 
turtlea1f_object: 
                    DB       1                            ; speed + direction 
                    DW       turtlea1f_sprite             ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       turtlea1g_object             ; pointer to next anim object 
                    DB       0                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       4                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_DIVE_DOWN            ; special flag 
                    DW       turtleb1a_object             ; alternate object for diving 
turtlea1g_object: 
                    DB       1                            ; speed + direction 
                    DW       turtlea1e_sprite             ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       turtlea1d_object             ; pointer to next anim object 
                    DB       0                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       3                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_DIVE_DOWN            ; special flag 
                    DW       turtleb1a_object             ; alternate object for diving 
turtleb1a_object: 
                    DB       1                            ; speed + direction 
                    DW       turtlea1c_sprite             ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       15                           ; anim delay value 
                    DW       turtleb1b_object             ; pointer to next anim object 
                    DB       0                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       5                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_DIVE_UP              ; special flag 
                    DW       turtleb1a_object             ; alternate object for diving 
turtleb1b_object: 
                    DB       1                            ; speed + direction 
                    DW       turtlea1b_sprite             ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       15                           ; anim delay value 
                    DW       turtleb1c_object             ; pointer to next anim object 
                    DB       0                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       4                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_DIVE_UP              ; special flag 
                    DW       turtleb1a_object             ; alternate object for diving 
turtleb1c_object: 
                    DB       1                            ; speed + direction 
                    DW       turtlea1a_sprite             ; graphic definition 
                    DB       22                           ; length in SCALE_FACTOR_GAME 
                    DB       15                           ; anim delay value 
                    DW       turtled1a_object             ; pointer to next anim object 
                    DB       0                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       2                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_DIVE_UP              ; special flag 
                    DW       turtleb1a_object             ; alternate object for diving 
turtlea3a_object: 
                    DB       2                            ; speed + direction 
                    DW       turtlea1a_sprite             ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       15                           ; anim delay value 
                    DW       turtlea3b_object             ; pointer to next anim object 
                    DB       0                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       2                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_DIVE_UP              ; special flag 
                    DW       turtleb3a_object             ; alternate object for diving 
turtlea3b_object: 
                    DB       2                            ; speed + direction 
                    DW       turtlea1b_sprite             ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       15                           ; anim delay value 
                    DW       turtlea3c_object             ; pointer to next anim object 
                    DB       0                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       4                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_DIVE_UP              ; special flag 
                    DW       turtleb3a_object             ; alternate object for diving 
turtlea3c_object: 
                    DB       2                            ; speed + direction 
                    DW       turtlea1c_sprite             ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       15                           ; anim delay value 
                    DW       turtlea3d_object             ; pointer to next anim object 
                    DB       0                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       5                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_DIVE_UP              ; special flag 
                    DW       turtleb3a_object             ; alternate object for diving 
turtlea3d_object: 
                    DB       2                            ; speed + direction 
                    DW       turtlea1d_sprite             ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       turtlea3e_object             ; pointer to next anim object 
                    DB       0                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       3                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_DIVE_DOWN            ; special flag 
                    DW       turtleb3a_object             ; alternate object for diving 
turtlea3e_object: 
                    DB       2                            ; speed + direction 
                    DW       turtlea1e_sprite             ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       turtlea3f_object             ; pointer to next anim object 
                    DB       0                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       3                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_DIVE_DOWN            ; special flag 
                    DW       turtleb3a_object             ; alternate object for diving 
turtlea3f_object: 
                    DB       2                            ; speed + direction 
                    DW       turtlea1f_sprite             ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       turtlea3g_object             ; pointer to next anim object 
                    DB       0                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       4                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_DIVE_DOWN            ; special flag 
                    DW       turtleb3a_object             ; alternate object for diving 
turtlea3g_object: 
                    DB       2                            ; speed + direction 
                    DW       turtlea1e_sprite             ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       turtlea3d_object             ; pointer to next anim object 
                    DB       0                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       3                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_DIVE_DOWN            ; special flag 
                    DW       turtleb3a_object             ; alternate object for diving 
turtleb3a_object: 
                    DB       2                            ; speed + direction 
                    DW       turtlea1c_sprite             ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       15                           ; anim delay value 
                    DW       turtleb3b_object             ; pointer to next anim object 
                    DB       0                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       5                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_DIVE_UP              ; special flag 
                    DW       turtleb3a_object             ; alternate object for diving 
turtleb3b_object: 
                    DB       2                            ; speed + direction 
                    DW       turtlea1b_sprite             ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       15                           ; anim delay value 
                    DW       turtleb3c_object             ; pointer to next anim object 
                    DB       0                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       4                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_DIVE_UP              ; special flag 
                    DW       turtleb3a_object             ; alternate object for diving 
turtleb3c_object: 
                    DB       2                            ; speed + direction 
                    DW       turtlea1a_sprite             ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       15                           ; anim delay value 
                    DW       turtled3a_object             ; pointer to next anim object 
                    DB       0                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       2                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_DIVE_UP              ; special flag 
                    DW       turtleb3a_object             ; alternate object for diving 
; sprite definition
turtlea2a_sprite: 
                    DW       (MAX_LINE_NUM-(8+1))*ONE_LINE_LENGTH 
                    DB       1*SPRITE_BLOW_UP, 2*SPRITE_BLOW_UP 
                    DB       -2*SPRITE_BLOW_UP, 3*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, 4*SPRITE_BLOW_UP 
                    DB       2*SPRITE_BLOW_UP, 3*SPRITE_BLOW_UP 
                    DB       2*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, -4*SPRITE_BLOW_UP 
                    DB       -2*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP 
                    DB       -4*SPRITE_BLOW_UP, 0*SPRITE_BLOW_UP 
; sprite definition
turtlea2b_sprite: 
                    DW       (MAX_LINE_NUM-(8+1))*ONE_LINE_LENGTH 
                    DB       -1*SPRITE_BLOW_UP, 3*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, 4*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, 1*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, -4*SPRITE_BLOW_UP 
                    DB       -1*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP 
                    DB       0*SPRITE_BLOW_UP, 0*SPRITE_BLOW_UP 
                    DB       -2*SPRITE_BLOW_UP, 0*SPRITE_BLOW_UP 
                    DB       0*SPRITE_BLOW_UP, 0*SPRITE_BLOW_UP 
; sprite definition
turtlea2d_sprite: 
                    DW       (MAX_LINE_NUM-(13+1))*ONE_LINE_LENGTH 
                    DB       -3*SPRITE_BLOW_UP, 4*SPRITE_BLOW_UP 
                    DB       3*SPRITE_BLOW_UP, 4*SPRITE_BLOW_UP 
                    DB       3*SPRITE_BLOW_UP, -4*SPRITE_BLOW_UP 
                    DB       -3*SPRITE_BLOW_UP, -4*SPRITE_BLOW_UP 
                    DB       0*SPRITE_BLOW_UP, 1*SPRITE_BLOW_UP 
                    DB       -2*SPRITE_BLOW_UP, 3*SPRITE_BLOW_UP 
                    DB       2*SPRITE_BLOW_UP, 3*SPRITE_BLOW_UP 
                    DB       2*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP 
                    DB       -2*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP 
                    DB       0*SPRITE_BLOW_UP, 1*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, 2*SPRITE_BLOW_UP 
                    DB       -1*SPRITE_BLOW_UP, 2*SPRITE_BLOW_UP 
                    DB       -1*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP 
; sprite definition
turtlea2e_sprite: 
                    DW       (MAX_LINE_NUM-(8+1))*ONE_LINE_LENGTH 
                    DB       -2*SPRITE_BLOW_UP, 4*SPRITE_BLOW_UP 
                    DB       2*SPRITE_BLOW_UP, 4*SPRITE_BLOW_UP 
                    DB       2*SPRITE_BLOW_UP, -4*SPRITE_BLOW_UP 
                    DB       -2*SPRITE_BLOW_UP, -4*SPRITE_BLOW_UP 
                    DB       0*SPRITE_BLOW_UP, 1*SPRITE_BLOW_UP 
                    DB       -1*SPRITE_BLOW_UP, 3*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, 3*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP 
                    DB       -1*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP 
; sprite definition
turtlea2f_sprite: 
                    DW       (MAX_LINE_NUM-(3+1))*ONE_LINE_LENGTH 
                    DB       -1*SPRITE_BLOW_UP, 4*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, 4*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, -4*SPRITE_BLOW_UP 
                    DB       -1*SPRITE_BLOW_UP, -4*SPRITE_BLOW_UP 
turtlea2a_object: 
                    DB       -1                           ; speed + direction 
                    DW       turtlea2a_sprite             ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       15                           ; anim delay value 
                    DW       turtlea2b_object             ; pointer to next anim object 
                    DB       -3                           ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       2                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_DIVE_UP              ; special flag 
                    DW       turtleb2a_object             ; alternate object for diving 
turtlea2b_object: 
                    DB       -1                           ; speed + direction 
                    DW       turtlea2b_sprite             ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       15                           ; anim delay value 
                    DW       turtlea2c_object             ; pointer to next anim object 
                    DB       -2                           ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       4                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_DIVE_UP              ; special flag 
                    DW       turtleb2a_object             ; alternate object for diving 
turtlea2c_object: 
                    DB       -1                           ; speed + direction 
                    DW       turtlea1c_sprite             ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       15                           ; anim delay value 
                    DW       turtlea2d_object             ; pointer to next anim object 
                    DB       0                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       5                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_DIVE_UP              ; special flag 
                    DW       turtleb2a_object             ; alternate object for diving 
turtlea2d_object: 
                    DB       -1                           ; speed + direction 
                    DW       turtlea2d_sprite             ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       turtlea2e_object             ; pointer to next anim object 
                    DB       0                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       4                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_DIVE_DOWN            ; special flag 
                    DW       turtleb2a_object             ; alternate object for diving 
turtlea2e_object: 
                    DB       -1                           ; speed + direction 
                    DW       turtlea2e_sprite             ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       turtlea2f_object             ; pointer to next anim object 
                    DB       0                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       4                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_DIVE_DOWN            ; special flag 
                    DW       turtleb2a_object             ; alternate object for diving 
turtlea2f_object: 
                    DB       -1                           ; speed + direction 
                    DW       turtlea2f_sprite             ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       turtlea2g_object             ; pointer to next anim object 
                    DB       0                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       4                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_DIVE_DOWN            ; special flag 
                    DW       turtleb2a_object             ; alternate object for diving 
turtlea2g_object: 
                    DB       -1                           ; speed + direction 
                    DW       turtlea2e_sprite             ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       turtlea2d_object             ; pointer to next anim object 
                    DB       0                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       4                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_DIVE_DOWN            ; special flag 
                    DW       turtleb2a_object             ; alternate object for diving 
turtleb2a_object: 
                    DB       -1                           ; speed + direction 
                    DW       turtlea1c_sprite             ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       15                           ; anim delay value 
                    DW       turtleb2b_object             ; pointer to next anim object 
                    DB       0                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       5                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_DIVE_UP              ; special flag 
                    DW       turtleb2a_object             ; alternate object for diving 
turtleb2b_object: 
                    DB       -1                           ; speed + direction 
                    DW       turtlea2b_sprite             ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       15                           ; anim delay value 
                    DW       turtleb2c_object             ; pointer to next anim object 
                    DB       -2                           ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       4                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_DIVE_UP              ; special flag 
                    DW       turtleb2a_object             ; alternate object for diving 
turtleb2c_object: 
                    DB       -1                           ; speed + direction 
                    DW       turtlea2a_sprite             ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       15                           ; anim delay value 
                    DW       turtled2a_object             ; pointer to next anim object 
                    DB       -3                           ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       2                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_DIVE_UP              ; special flag 
                    DW       turtleb2a_object             ; alternate object for diving 
turtlea4a_object: 
                    DB       -2                           ; speed + direction 
                    DW       turtlea2a_sprite             ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       15                           ; anim delay value 
                    DW       turtlea4b_object             ; pointer to next anim object 
                    DB       -3                           ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       2                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_DIVE_UP              ; special flag 
                    DW       turtleb4a_object             ; alternate object for diving 
turtlea4b_object: 
                    DB       -2                           ; speed + direction 
                    DW       turtlea2b_sprite             ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       15                           ; anim delay value 
                    DW       turtlea4c_object             ; pointer to next anim object 
                    DB       -2                           ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       4                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_DIVE_UP              ; special flag 
                    DW       turtleb4a_object             ; alternate object for diving 
turtlea4c_object: 
                    DB       -2                           ; speed + direction 
                    DW       turtlea1c_sprite             ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       15                           ; anim delay value 
                    DW       turtlea4d_object             ; pointer to next anim object 
                    DB       0                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       5                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_DIVE_UP              ; special flag 
                    DW       turtleb4a_object             ; alternate object for diving 
turtlea4d_object: 
                    DB       -2                           ; speed + direction 
                    DW       turtlea2d_sprite             ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       turtlea4e_object             ; pointer to next anim object 
                    DB       0                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       4                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_DIVE_DOWN            ; special flag 
                    DW       turtleb4a_object             ; alternate object for diving 
turtlea4e_object: 
                    DB       -2                           ; speed + direction 
                    DW       turtlea2e_sprite             ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       turtlea4f_object             ; pointer to next anim object 
                    DB       0                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       4                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_DIVE_DOWN            ; special flag 
                    DW       turtleb4a_object             ; alternate object for diving 
turtlea4f_object: 
                    DB       -2                           ; speed + direction 
                    DW       turtlea2f_sprite             ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       turtlea4g_object             ; pointer to next anim object 
                    DB       0                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       4                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_DIVE_DOWN            ; special flag 
                    DW       turtleb4a_object             ; alternate object for diving 
turtlea4g_object: 
                    DB       -2                           ; speed + direction 
                    DW       turtlea2e_sprite             ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       turtlea4d_object             ; pointer to next anim object 
                    DB       0                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       4                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_DIVE_DOWN            ; special flag 
                    DW       turtleb4a_object             ; alternate object for diving 
turtleb4a_object: 
                    DB       -2                           ; speed + direction 
                    DW       turtlea1c_sprite             ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       15                           ; anim delay value 
                    DW       turtleb4b_object             ; pointer to next anim object 
                    DB       0                            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       5                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_DIVE_UP              ; special flag 
                    DW       turtleb4a_object             ; alternate object for diving 
turtleb4b_object: 
                    DB       -2                           ; speed + direction 
                    DW       turtlea2b_sprite             ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       15                           ; anim delay value 
                    DW       turtleb4c_object             ; pointer to next anim object 
                    DB       -2                           ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       4                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_DIVE_UP              ; special flag 
                    DW       turtleb4a_object             ; alternate object for diving 
turtleb4c_object: 
                    DB       -2                           ; speed + direction 
                    DW       turtlea2a_sprite             ; graphic definition 
                    DB       TURTLE_LENGTH                ; length in SCALE_FACTOR_GAME 
                    DB       15                           ; anim delay value 
                    DW       turtled4a_object             ; pointer to next anim object 
                    DB       -3                           ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       2                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; halfspeed value 
                    DB       SPECIAL_DIVE_UP              ; special flag 
                    DW       turtleb4a_object             ; alternate object for diving 
