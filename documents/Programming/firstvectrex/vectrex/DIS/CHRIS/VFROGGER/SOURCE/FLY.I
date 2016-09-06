; this file is part of vectrex frogger, written by Malban
; in March-April 1998
; all stuff contained here is public domain
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this file contains 'sprite' definition data for the fly                   ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
; fly1 is not moving
fly1a_sprite:
                DB 9
                DB -5*SPRITE_BLOW_UP,  4*SPRITE_BLOW_UP
                DB -3*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  3*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  5*SPRITE_BLOW_UP,  4*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB -3*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  3*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
fly1a_object:
                DB 0                    ; speed + direction
                DW fly1a_sprite         ; graphic definition
                DB 0                    ; length in SCALE_FACTOR_GAME
                DB 5                    ; anim delay value
                DW fly1b_object         ; pointer to next anim object
                DB 1                    ; offsets y in 'SCALE_IN_HOME', since this is a home object
                DB 2                    ; offsets x in 'SCALE_IN_HOME', since this is a home object
                DB $60                  ; brightness
                DB SPECIAL_HOME_FLY     ; special flag
fly1b_sprite:
                DB 9
                DB -3*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB -3*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  3*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  3*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
fly1b_object:
                DB 0                    ; speed + direction
                DW fly1b_sprite         ; graphic definition
                DB 0                    ; length in SCALE_FACTOR_GAME
                DB 5                    ; anim delay value
                DW fly1c_object         ; pointer to next anim object
                DB -2                   ; offsets y in 'SCALE_IN_HOME', since this is a home object
                DB 3                    ; offsets x in 'SCALE_IN_HOME', since this is a home object
                DB $60                  ; brightness
                DB SPECIAL_HOME_FLY     ; special flag

fly1c_sprite:
                DB 9
                DB -3*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB -3*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  3*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  3*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
fly1c_object:
                DB 0                    ; speed + direction
                DW fly1c_sprite         ; graphic definition
                DB 0                    ; length in SCALE_FACTOR_GAME
                DB 5                    ; anim delay value
                DW fly1d_object         ; pointer to next anim object
                DB -2                   ; offsets y in 'SCALE_IN_HOME', since this is a home object
                DB 5                    ; offsets x in 'SCALE_IN_HOME', since this is a home object
                DB $60                  ; brightness
                DB SPECIAL_HOME_FLY     ; special flag

fly1d_object:
                DB 0                    ; speed + direction
                DW fly1b_sprite         ; graphic definition
                DB 0                    ; length in SCALE_FACTOR_GAME
                DB 5                    ; anim delay value
                DW fly1a_object         ; pointer to next anim object
                DB -2                   ; offsets y in 'SCALE_IN_HOME', since this is a home object
                DB 3                    ; offsets x in 'SCALE_IN_HOME', since this is a home object
                DB $60                  ; brightness
                DB SPECIAL_HOME_FLY     ; special flag
