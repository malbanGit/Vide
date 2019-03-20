; this file is part of Karl Quappe, written by Malban
; in 2016
; all stuff contained here is public domain
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this file contains 'sprite' definition data for otter                     ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
otter1a_sprite: 
                    DW       (MAX_LINE_NUM-(09+1))*ONE_LINE_LENGTH 
                    DB       +$05*SPRITE_BLOW_UP, +$03*SPRITE_BLOW_UP ; draw to y, x 
                    DB       +$01*SPRITE_BLOW_UP, +$03*SPRITE_BLOW_UP ; draw to y, x 
                    DB       -$01*SPRITE_BLOW_UP, +$02*SPRITE_BLOW_UP ; draw to y, x 
                    DB       -$01*SPRITE_BLOW_UP, -$01*SPRITE_BLOW_UP ; draw to y, x 
                    DB       +$01*SPRITE_BLOW_UP, +$00*SPRITE_BLOW_UP ; draw to y, x 
                    DB       +$00*SPRITE_BLOW_UP, +$01*SPRITE_BLOW_UP ; draw to y, x 
                    DB       -$02*SPRITE_BLOW_UP, +$01*SPRITE_BLOW_UP ; draw to y, x 
                    DB       -$01*SPRITE_BLOW_UP, -$03*SPRITE_BLOW_UP ; draw to y, x 
                    DB       +$00*SPRITE_BLOW_UP, +$03*SPRITE_BLOW_UP ; draw to y, x 
                    DB       -$02*SPRITE_BLOW_UP, -$04*SPRITE_BLOW_UP ; draw to y, x 
otter1a_object: 
                    DB       0                            ; speed + direction 
                    DW       otter1a_sprite               ; graphic definition 
                    DB       0                            ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       otter1b_object               ; pointer to next anim object 
                    DB       -4                           ; offsets y in 'SCALE_IN_HOME', since this is a home object 
                    DB       0                            ; offsets x in 'SCALE_IN_HOME', since this is a home object 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
otter1b_sprite: 
                    DW       (MAX_LINE_NUM-(09+1))*ONE_LINE_LENGTH 
                    DB       +$05*SPRITE_BLOW_UP, +$03*SPRITE_BLOW_UP ; draw to y, x 
                    DB       +$01*SPRITE_BLOW_UP, +$03*SPRITE_BLOW_UP ; draw to y, x 
                    DB       -$01*SPRITE_BLOW_UP, +$02*SPRITE_BLOW_UP ; draw to y, x 
                    DB       -$01*SPRITE_BLOW_UP, -$01*SPRITE_BLOW_UP ; draw to y, x 
                    DB       +$01*SPRITE_BLOW_UP, +$00*SPRITE_BLOW_UP ; draw to y, x 
                    DB       +$00*SPRITE_BLOW_UP, +$01*SPRITE_BLOW_UP ; draw to y, x 
                    DB       -$03*SPRITE_BLOW_UP, +$01*SPRITE_BLOW_UP ; draw to y, x 
                    DB       +$00*SPRITE_BLOW_UP, -$03*SPRITE_BLOW_UP ; draw to y, x 
                    DB       +$00*SPRITE_BLOW_UP, +$03*SPRITE_BLOW_UP ; draw to y, x 
                    DB       -$02*SPRITE_BLOW_UP, -$04*SPRITE_BLOW_UP ; draw to y, x 
otter1b_object: 
                    DB       0                            ; speed + direction 
                    DW       otter1b_sprite               ; graphic definition 
                    DB       0                            ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       otter1a_object               ; pointer to next anim object 
                    DB       -4                           ; offsets y in 'SCALE_IN_HOME', since this is a home object 
                    DB       0                            ; offsets x in 'SCALE_IN_HOME', since this is a home object 
                    DB       0                            ; halfspeed value 
                    DB       0                            ; special flag 
