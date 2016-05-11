; this file is part of vectrex frogger, written by Malban
; in March-April 1998
; all stuff contained here is public domain
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this file contains 'sprite' definition data for letters (level done)      ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
_l_sprite:
 if USE_LOOP_UNROLING !=1
                DB 2
 else
                DW (MAX_LINE_NUM-(2+1))*ONE_LINE_LENGTH
 endif
                DB -5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
_l_object:
                DB -2                   ; speed + direction
                DW _l_sprite            ; graphic definition
                DB 0                    ; length in SCALE_FACTOR_GAME
                DB 100                  ; anim delay value
                DW _l_object            ; pointer to next anim object
                DB 0                    ; offsets y in 'SCALE_IN_HOME', since this is a home object
                DB 0                    ; offsets x in 'SCALE_IN_HOME', since this is a home object
;                DB $7f                  ; brightness
;                DB 0                    ; special flag
_e_sprite:
 if USE_LOOP_UNROLING !=1
                DB 6
 else
                DW (MAX_LINE_NUM-(6+1))*ONE_LINE_LENGTH
 endif
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                DB -4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  4*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -4*SPRITE_BLOW_UP
                DB -4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
_e_object:
                DB -2                   ; speed + direction
                DW _e_sprite            ; graphic definition
                DB 0                    ; length in SCALE_FACTOR_GAME
                DB 100                  ; anim delay value
                DW _e_object            ; pointer to next anim object
                DB 0                    ; offsets y in 'SCALE_IN_HOME', since this is a home object
                DB 0                    ; offsets x in 'SCALE_IN_HOME', since this is a home object
;                DB $7f                  ; brightness
;                DB 0                    ; special flag
_v_sprite:
 if USE_LOOP_UNROLING !=1
                DB 3
 else
                DW (MAX_LINE_NUM-(3+1))*ONE_LINE_LENGTH
 endif
                DB -5*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB -5*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  5*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  5*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
_v_object:
                DB -2                   ; speed + direction
                DW _v_sprite            ; graphic definition
                DB 0                    ; length in SCALE_FACTOR_GAME
                DB 100                  ; anim delay value
                DW _v_object            ; pointer to next anim object
                DB 0                    ; offsets y in 'SCALE_IN_HOME', since this is a home object
                DB 0                    ; offsets x in 'SCALE_IN_HOME', since this is a home object
;                DB $7f                  ; brightness
;                DB 0                    ; special flag
_d_sprite:
 if USE_LOOP_UNROLING !=1
                DB 9
 else
                DW (MAX_LINE_NUM-(9+1))*ONE_LINE_LENGTH
 endif
                DB -5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
_d_object:
                DB -2                   ; speed + direction
                DW _d_sprite            ; graphic definition
                DB 0                    ; length in SCALE_FACTOR_GAME
                DB 100                  ; anim delay value
                DW _d_object            ; pointer to next anim object
                DB 0                    ; offsets y in 'SCALE_IN_HOME', since this is a home object
                DB 0                    ; offsets x in 'SCALE_IN_HOME', since this is a home object
;                DB $7f                  ; brightness
;                DB 0                    ; special flag
_o_sprite:
 if USE_LOOP_UNROLING !=1
                DB 11
 else
                DW (MAX_LINE_NUM-(11+1))*ONE_LINE_LENGTH
 endif
                DB -5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
_o_object:
                DB -2                   ; speed + direction
                DW _o_sprite            ; graphic definition
                DB 0                    ; length in SCALE_FACTOR_GAME
                DB 100                  ; anim delay value
                DW _o_object            ; pointer to next anim object
                DB -4                   ; offsets y in 'SCALE_IN_HOME', since this is a home object
                DB 0                    ; offsets x in 'SCALE_IN_HOME', since this is a home object
;                DB $7f                  ; brightness
;                DB 0                    ; special flag
_n_sprite:
 if USE_LOOP_UNROLING !=1
                DB 5
 else
                DW (MAX_LINE_NUM-(5+1))*ONE_LINE_LENGTH
 endif
                DB  5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -5*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB -5*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB  5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
_n_object:
                DB -2                   ; speed + direction
                DW _n_sprite            ; graphic definition
                DB 0                    ; length in SCALE_FACTOR_GAME
                DB 100                  ; anim delay value
                DW _n_object            ; pointer to next anim object
                DB -14                  ; offsets y in 'SCALE_IN_HOME', since this is a home object
                DB 0                    ; offsets x in 'SCALE_IN_HOME', since this is a home object
;                DB $7f                  ; brightness
;                DB 0                    ; special flag
