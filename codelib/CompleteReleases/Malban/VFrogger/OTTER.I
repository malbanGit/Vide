; this file is part of vectrex frogger, written by Malban
; in March-April 1998
; all stuff contained here is public domain
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this file contains 'sprite' definition data for otter                     ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
otter1a_sprite:
                DB 10
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP,  4*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB -5*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
otter1a_object:
                DB 0                    ; speed + direction
                DW otter1a_sprite       ; graphic definition
                DB 0                    ; length in SCALE_FACTOR_GAME
                DB 5                    ; anim delay value
                DW otter1b_object       ; pointer to next anim object
                DB -4                   ; offsets y in 'SCALE_IN_HOME', since this is a home object
                DB 0                    ; offsets x in 'SCALE_IN_HOME', since this is a home object
                DB $60                  ; brightness
                DB 0                    ; special flag
otter1b_sprite:
                DB 10
                DB  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP,  4*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB  3*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB -5*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
otter1b_object:
                DB 0                    ; speed + direction
                DW otter1b_sprite       ; graphic definition
                DB 0                    ; length in SCALE_FACTOR_GAME
                DB 5                    ; anim delay value
                DW otter1a_object       ; pointer to next anim object
                DB -4                   ; offsets y in 'SCALE_IN_HOME', since this is a home object
                DB 0                    ; offsets x in 'SCALE_IN_HOME', since this is a home object
                DB $60                  ; brightness
                DB 0                    ; special flag
