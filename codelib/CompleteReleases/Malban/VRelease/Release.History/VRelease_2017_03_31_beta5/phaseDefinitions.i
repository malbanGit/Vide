phaseList 
                    dw       phase0_x 
                    dw       phase0_hx 
                    dw       hunter_raid_1 
                    dw       phase1 
 dw squad_raid_1
                    dw       phase1 
                    dw       bomber_raid_1 
                    dw       phase2 
 dw squad_raid_2
                    dw       phase2 
                    dw       dragon_raid_1 
                    dw       phase3 
 dw squad_raid_2
                    dw       phase3 
                    dw       hunter_raid_2 
                    dw       phase4 
 dw squad_raid_2
                    dw       phase4 
                    dw       bomber_raid_2 
                    dw       phase5 
 dw squad_raid_3
                    dw       phase5 
                    dw       dragon_raid_2 
                    dw       phase6 
 dw squad_raid_3
                    dw       phase6 
                    dw       bomber_raid_2 
                    dw       dragon_raid_2 
                    dw       phase7 
 dw squad_raid_3
                    dw       phase7 
                    dw       hunter_raid_2 
                    dw       hunter_raid_2 
                    dw       phase8 
                    dw       0 


ALLOW_STAR          =        $01 
ALLOW_X             =        $02 
ALLOW_HIDDEN_X      =        $04 
ALLOW_HUNTER        =        $08 
ALLOW_BOMBER        =        $10 
ALLOW_DRAGON        =        $20 
ALLOW_BONUS         =        $40 


; slow spawn, 
; very slow hiddens
phase0_x: 
                    db       ALLOW_STAR+ALLOW_X+ALLOW_HIDDEN_X+ALLOW_BONUS            ; spawn types allowed 
                    db       SHIELD_WIDTH_GROWTH_DEFAULT  ;4 2 up , ec -> bpl than width grow 
                    db       SHIELD_DEFAULT_SPEED         ;2 shield major speed ; update every tick, must be in sum greater than minor increase 
                    db       SHIELD_MINOR_DELAY_COUNTER_DEFAULT ; 2 shield minor counter delay; test for dec -> bpl 
                    db       SHIELD_MINOR_INCREASE_DEFAULT ; 0 shield minor speed increase 
                    db       1;INITIAL_SHIELD_WIDTH_ADDER   ; 1 1-4 shield width adder 
                    db       INITIAL_SHOT_MOVE_DELAY      ;1 shot move delay ; test for dec -> bpl 
                    db       INITIAL_SHOT_MOVE_STRENGTH   ;1 shot move strength 
                    db       INITIAL_X_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_X_MOVE_STRENGTH      ;1 x move strength 
                    db       3;INITIAL_HX_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_HX_MOVE_STRENGTH      ;1 x move strength 
                    db       INITIAL_HUNTER_MOVE_DELAY    ;0 hunter move delay ; test for dec -> bpl 
                    db       INITIAL_HUNTER_MOVE_STRENGTH ;1 hunter move strength 
                    db       INITIAL_BOMBER_MOVE_DELAY    ;1 bomber move delay ; test for dec -> bpl 
                    db       INITIAL_BOMBER_MOVE_STRENGTH ;1 bomber move strength 
                    db       INITIAL_BOMBER_SHOT_DELAY    ; first shot can also be shorter timed than minimum 200 bomber shot delay ; test for dec -> bpl, decreased by 25 every shot down to 50 (50 = 1 s) 
                    db       8;INITIAL_DRAGON_MOVE_DELAY    ;5 (scale) dragon inner move delay; test for dec -> bpl 
 dw INITIAL_DRAGON_MOVE_STRENGTH;2 Dragon_angle add ANGLES must be *2 since angles go up to 720
 db 1;INITIAL_DRAGON_ANGLE_DELAY; 0 angle delay
                    db       DRAGON_CHILD_FREE_SPEED      ;1 dragonchild (free) speed; update per tick 
                    db       DEFAULT_MINIMUM_BOMB_RELOAD_DELAY ; 50 
                    db       INITIAL_BONUS_MOVE_DELAY     ; 3 x move delay ; test for dec -> bpl 
                    db       INITIAL_BONUS_MOVE_STRENGTH  ; 1 x move strength 
                    db       DEFAULT_BONUS_ACTIVE_TIME    ; 30 in seconds 
 db INITIAL_SPAWN_RESET_TIMER ; phase_spawn_reset -1 == stay unchanged INITIAL_SPAWN_RESET_TIMER
 db INITIAL_SPAWN_INCREASE_DELAY; phase_spawn_increase_delay -1 == stay unchanged INITIAL_SPAWN_INCREASE_DELAY
 db FASTEST_SPAWN_RATE; phase_min_spawn_reset -1 == stay unchanged FASTEST_SPAWN_RATE
 db MAXIMUM_RESET_INCREASE_SLOWDOWN; phase_max_spawn_increase_delay -1 == stay unchanged MAXIMUM_RESET_INCREASE_SLOWDOWN
                    dw       20          

; slow spawn, 
; very slow hiddens
phase0_hx: 
                    db       ALLOW_STAR+ALLOW_X+ALLOW_HUNTER+ALLOW_BONUS            ; spawn types allowed 
                    db       SHIELD_WIDTH_GROWTH_DEFAULT  ;4 2 up , ec -> bpl than width grow 
                    db       SHIELD_DEFAULT_SPEED         ;2 shield major speed ; update every tick, must be in sum greater than minor increase 
                    db       SHIELD_MINOR_DELAY_COUNTER_DEFAULT ; 2 shield minor counter delay; test for dec -> bpl 
                    db       SHIELD_MINOR_INCREASE_DEFAULT ; 0 shield minor speed increase 
                    db       1;INITIAL_SHIELD_WIDTH_ADDER   ; 1 1-4 shield width adder 
                    db       INITIAL_SHOT_MOVE_DELAY      ;1 shot move delay ; test for dec -> bpl 
                    db       INITIAL_SHOT_MOVE_STRENGTH   ;1 shot move strength 
                    db       INITIAL_X_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_X_MOVE_STRENGTH      ;1 x move strength 
                    db       3;INITIAL_HX_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_HX_MOVE_STRENGTH      ;1 x move strength 
                    db       INITIAL_HUNTER_MOVE_DELAY    ;0 hunter move delay ; test for dec -> bpl 
                    db       INITIAL_HUNTER_MOVE_STRENGTH ;1 hunter move strength 
                    db       INITIAL_BOMBER_MOVE_DELAY    ;1 bomber move delay ; test for dec -> bpl 
                    db       INITIAL_BOMBER_MOVE_STRENGTH ;1 bomber move strength 
                    db       INITIAL_BOMBER_SHOT_DELAY    ; first shot can also be shorter timed than minimum 200 bomber shot delay ; test for dec -> bpl, decreased by 25 every shot down to 50 (50 = 1 s) 
                    db       8;INITIAL_DRAGON_MOVE_DELAY    ;5 (scale) dragon inner move delay; test for dec -> bpl 
 dw INITIAL_DRAGON_MOVE_STRENGTH;2 Dragon_angle add ANGLES must be *2 since angles go up to 720
 db 1;INITIAL_DRAGON_ANGLE_DELAY; 0 angle delay
                    db       DRAGON_CHILD_FREE_SPEED      ;1 dragonchild (free) speed; update per tick 
                    db       DEFAULT_MINIMUM_BOMB_RELOAD_DELAY ; 50 
                    db       INITIAL_BONUS_MOVE_DELAY     ; 3 x move delay ; test for dec -> bpl 
                    db       INITIAL_BONUS_MOVE_STRENGTH  ; 1 x move strength 
                    db       DEFAULT_BONUS_ACTIVE_TIME    ; 30 in seconds 
 db 50 ; phase_spawn_reset -1 == stay unchanged INITIAL_SPAWN_RESET_TIMER
 db INITIAL_SPAWN_INCREASE_DELAY; phase_spawn_increase_delay -1 == stay unchanged INITIAL_SPAWN_INCREASE_DELAY
 db FASTEST_SPAWN_RATE; phase_min_spawn_reset -1 == stay unchanged FASTEST_SPAWN_RATE
 db MAXIMUM_RESET_INCREASE_SLOWDOWN; phase_max_spawn_increase_delay -1 == stay unchanged MAXIMUM_RESET_INCREASE_SLOWDOWN
                    dw       20   ; slow spawn, 
; very slow hiddens
hunter_raid_1: 
                    db       ALLOW_HUNTER            ; spawn types allowed 
                    db       SHIELD_WIDTH_GROWTH_DEFAULT  ;4 2 up , ec -> bpl than width grow 
                    db       SHIELD_DEFAULT_SPEED         ;2 shield major speed ; update every tick, must be in sum greater than minor increase 
                    db       SHIELD_MINOR_DELAY_COUNTER_DEFAULT ; 2 shield minor counter delay; test for dec -> bpl 
                    db       SHIELD_MINOR_INCREASE_DEFAULT ; 0 shield minor speed increase 
                    db       1;INITIAL_SHIELD_WIDTH_ADDER   ; 1 1-4 shield width adder 
                    db       INITIAL_SHOT_MOVE_DELAY      ;1 shot move delay ; test for dec -> bpl 
                    db       INITIAL_SHOT_MOVE_STRENGTH   ;1 shot move strength 
                    db       INITIAL_X_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_X_MOVE_STRENGTH      ;1 x move strength 
                    db       3;INITIAL_HX_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_HX_MOVE_STRENGTH      ;1 x move strength 
                    db       INITIAL_HUNTER_MOVE_DELAY    ;0 hunter move delay ; test for dec -> bpl 
                    db       INITIAL_HUNTER_MOVE_STRENGTH ;1 hunter move strength 
                    db       INITIAL_BOMBER_MOVE_DELAY    ;1 bomber move delay ; test for dec -> bpl 
                    db       INITIAL_BOMBER_MOVE_STRENGTH ;1 bomber move strength 
                    db       INITIAL_BOMBER_SHOT_DELAY    ; first shot can also be shorter timed than minimum 200 bomber shot delay ; test for dec -> bpl, decreased by 25 every shot down to 50 (50 = 1 s) 
                    db       8;INITIAL_DRAGON_MOVE_DELAY    ;5 (scale) dragon inner move delay; test for dec -> bpl 
 dw INITIAL_DRAGON_MOVE_STRENGTH;2 Dragon_angle add ANGLES must be *2 since angles go up to 720
 db 1;INITIAL_DRAGON_ANGLE_DELAY; 0 angle delay
                    db       DRAGON_CHILD_FREE_SPEED      ;1 dragonchild (free) speed; update per tick 
                    db       DEFAULT_MINIMUM_BOMB_RELOAD_DELAY ; 50 
                    db       INITIAL_BONUS_MOVE_DELAY     ; 3 x move delay ; test for dec -> bpl 
                    db       INITIAL_BONUS_MOVE_STRENGTH  ; 1 x move strength 
                    db       DEFAULT_BONUS_ACTIVE_TIME    ; 30 in seconds 
 db 10 ; phase_spawn_reset -1 == stay unchanged INITIAL_SPAWN_RESET_TIMER
 db INITIAL_SPAWN_INCREASE_DELAY; phase_spawn_increase_delay -1 == stay unchanged INITIAL_SPAWN_INCREASE_DELAY
 db FASTEST_SPAWN_RATE; phase_min_spawn_reset -1 == stay unchanged FASTEST_SPAWN_RATE
 db MAXIMUM_RESET_INCREASE_SLOWDOWN; phase_max_spawn_increase_delay -1 == stay unchanged MAXIMUM_RESET_INCREASE_SLOWDOWN
                    dw       10   

; very slow hiddens
bomber_raid_1: 
                    db       ALLOW_BOMBER            ; spawn types allowed 
                    db       SHIELD_WIDTH_GROWTH_DEFAULT  ;4 2 up , ec -> bpl than width grow 
                    db       SHIELD_DEFAULT_SPEED         ;2 shield major speed ; update every tick, must be in sum greater than minor increase 
                    db       SHIELD_MINOR_DELAY_COUNTER_DEFAULT ; 2 shield minor counter delay; test for dec -> bpl 
                    db       SHIELD_MINOR_INCREASE_DEFAULT ; 0 shield minor speed increase 
                    db       1;INITIAL_SHIELD_WIDTH_ADDER   ; 1 1-4 shield width adder 
                    db       INITIAL_SHOT_MOVE_DELAY      ;1 shot move delay ; test for dec -> bpl 
                    db       INITIAL_SHOT_MOVE_STRENGTH   ;1 shot move strength 
                    db       INITIAL_X_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_X_MOVE_STRENGTH      ;1 x move strength 
                    db       3;INITIAL_HX_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_HX_MOVE_STRENGTH      ;1 x move strength 
                    db       INITIAL_HUNTER_MOVE_DELAY    ;0 hunter move delay ; test for dec -> bpl 
                    db       INITIAL_HUNTER_MOVE_STRENGTH ;1 hunter move strength 
                    db       INITIAL_BOMBER_MOVE_DELAY    ;1 bomber move delay ; test for dec -> bpl 
                    db       INITIAL_BOMBER_MOVE_STRENGTH ;1 bomber move strength 
                    db       INITIAL_BOMBER_SHOT_DELAY    ; first shot can also be shorter timed than minimum 200 bomber shot delay ; test for dec -> bpl, decreased by 25 every shot down to 50 (50 = 1 s) 
                    db       8;INITIAL_DRAGON_MOVE_DELAY    ;5 (scale) dragon inner move delay; test for dec -> bpl 
 dw INITIAL_DRAGON_MOVE_STRENGTH;2 Dragon_angle add ANGLES must be *2 since angles go up to 720
 db 1;INITIAL_DRAGON_ANGLE_DELAY; 0 angle delay
                    db       DRAGON_CHILD_FREE_SPEED      ;1 dragonchild (free) speed; update per tick 
                    db       DEFAULT_MINIMUM_BOMB_RELOAD_DELAY ; 50 
                    db       INITIAL_BONUS_MOVE_DELAY     ; 3 x move delay ; test for dec -> bpl 
                    db       INITIAL_BONUS_MOVE_STRENGTH  ; 1 x move strength 
                    db       DEFAULT_BONUS_ACTIVE_TIME    ; 30 in seconds 
 db 5 ; phase_spawn_reset -1 == stay unchanged INITIAL_SPAWN_RESET_TIMER
 db INITIAL_SPAWN_INCREASE_DELAY; phase_spawn_increase_delay -1 == stay unchanged INITIAL_SPAWN_INCREASE_DELAY
 db FASTEST_SPAWN_RATE; phase_min_spawn_reset -1 == stay unchanged FASTEST_SPAWN_RATE
 db MAXIMUM_RESET_INCREASE_SLOWDOWN; phase_max_spawn_increase_delay -1 == stay unchanged MAXIMUM_RESET_INCREASE_SLOWDOWN
                    dw       20   

; very slow hiddens
dragon_raid_1: 
                    db       ALLOW_DRAGON            ; spawn types allowed 
                    db       SHIELD_WIDTH_GROWTH_DEFAULT  ;4 2 up , ec -> bpl than width grow 
                    db       SHIELD_DEFAULT_SPEED         ;2 shield major speed ; update every tick, must be in sum greater than minor increase 
                    db       SHIELD_MINOR_DELAY_COUNTER_DEFAULT ; 2 shield minor counter delay; test for dec -> bpl 
                    db       SHIELD_MINOR_INCREASE_DEFAULT ; 0 shield minor speed increase 
                    db       1;INITIAL_SHIELD_WIDTH_ADDER   ; 1 1-4 shield width adder 
                    db       INITIAL_SHOT_MOVE_DELAY      ;1 shot move delay ; test for dec -> bpl 
                    db       INITIAL_SHOT_MOVE_STRENGTH   ;1 shot move strength 
                    db       INITIAL_X_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_X_MOVE_STRENGTH      ;1 x move strength 
                    db       3;INITIAL_HX_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_HX_MOVE_STRENGTH      ;1 x move strength 
                    db       INITIAL_HUNTER_MOVE_DELAY    ;0 hunter move delay ; test for dec -> bpl 
                    db       INITIAL_HUNTER_MOVE_STRENGTH ;1 hunter move strength 
                    db       INITIAL_BOMBER_MOVE_DELAY    ;1 bomber move delay ; test for dec -> bpl 
                    db       INITIAL_BOMBER_MOVE_STRENGTH ;1 bomber move strength 
                    db       INITIAL_BOMBER_SHOT_DELAY    ; first shot can also be shorter timed than minimum 200 bomber shot delay ; test for dec -> bpl, decreased by 25 every shot down to 50 (50 = 1 s) 
                    db       8;INITIAL_DRAGON_MOVE_DELAY    ;5 (scale) dragon inner move delay; test for dec -> bpl 
 dw INITIAL_DRAGON_MOVE_STRENGTH;2 Dragon_angle add ANGLES must be *2 since angles go up to 720
 db 1;INITIAL_DRAGON_ANGLE_DELAY; 0 angle delay
                    db       DRAGON_CHILD_FREE_SPEED      ;1 dragonchild (free) speed; update per tick 
                    db       DEFAULT_MINIMUM_BOMB_RELOAD_DELAY ; 50 
                    db       INITIAL_BONUS_MOVE_DELAY     ; 3 x move delay ; test for dec -> bpl 
                    db       INITIAL_BONUS_MOVE_STRENGTH  ; 1 x move strength 
                    db       DEFAULT_BONUS_ACTIVE_TIME    ; 30 in seconds 
 db 10 ; phase_spawn_reset -1 == stay unchanged INITIAL_SPAWN_RESET_TIMER
 db INITIAL_SPAWN_INCREASE_DELAY; phase_spawn_increase_delay -1 == stay unchanged INITIAL_SPAWN_INCREASE_DELAY
 db FASTEST_SPAWN_RATE; phase_min_spawn_reset -1 == stay unchanged FASTEST_SPAWN_RATE
 db MAXIMUM_RESET_INCREASE_SLOWDOWN; phase_max_spawn_increase_delay -1 == stay unchanged MAXIMUM_RESET_INCREASE_SLOWDOWN
                    dw       10   

; slow spawn, 
; very slow hiddens
phase1: 
                    db       DEFAULT_ALL_SPAWN            ; spawn types allowed 
                    db       SHIELD_WIDTH_GROWTH_DEFAULT  ;4 2 up , ec -> bpl than width grow 
                    db       SHIELD_DEFAULT_SPEED         ;2 shield major speed ; update every tick, must be in sum greater than minor increase 
                    db       SHIELD_MINOR_DELAY_COUNTER_DEFAULT ; 2 shield minor counter delay; test for dec -> bpl 
                    db       SHIELD_MINOR_INCREASE_DEFAULT ; 0 shield minor speed increase 
                    db       1;INITIAL_SHIELD_WIDTH_ADDER   ; 1 1-4 shield width adder 
                    db       INITIAL_SHOT_MOVE_DELAY      ;1 shot move delay ; test for dec -> bpl 
                    db       INITIAL_SHOT_MOVE_STRENGTH   ;1 shot move strength 
                    db       INITIAL_X_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_X_MOVE_STRENGTH      ;1 x move strength 
                    db       3;INITIAL_HX_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_HX_MOVE_STRENGTH      ;1 x move strength 
                    db       INITIAL_HUNTER_MOVE_DELAY    ;0 hunter move delay ; test for dec -> bpl 
                    db       INITIAL_HUNTER_MOVE_STRENGTH ;1 hunter move strength 
                    db       INITIAL_BOMBER_MOVE_DELAY    ;1 bomber move delay ; test for dec -> bpl 
                    db       INITIAL_BOMBER_MOVE_STRENGTH ;1 bomber move strength 
                    db       INITIAL_BOMBER_SHOT_DELAY    ; first shot can also be shorter timed than minimum 200 bomber shot delay ; test for dec -> bpl, decreased by 25 every shot down to 50 (50 = 1 s) 
                    db       8;INITIAL_DRAGON_MOVE_DELAY    ;5 (scale) dragon inner move delay; test for dec -> bpl 
 dw INITIAL_DRAGON_MOVE_STRENGTH;2 Dragon_angle add ANGLES must be *2 since angles go up to 720
 db 1;INITIAL_DRAGON_ANGLE_DELAY; 0 angle delay
                    db       DRAGON_CHILD_FREE_SPEED      ;1 dragonchild (free) speed; update per tick 
                    db       DEFAULT_MINIMUM_BOMB_RELOAD_DELAY ; 50 
                    db       INITIAL_BONUS_MOVE_DELAY     ; 3 x move delay ; test for dec -> bpl 
                    db       INITIAL_BONUS_MOVE_STRENGTH  ; 1 x move strength 
                    db       DEFAULT_BONUS_ACTIVE_TIME    ; 30 in seconds 
 db INITIAL_SPAWN_RESET_TIMER ; phase_spawn_reset -1 == stay unchanged INITIAL_SPAWN_RESET_TIMER
 db INITIAL_SPAWN_INCREASE_DELAY; phase_spawn_increase_delay -1 == stay unchanged INITIAL_SPAWN_INCREASE_DELAY
 db FASTEST_SPAWN_RATE; phase_min_spawn_reset -1 == stay unchanged FASTEST_SPAWN_RATE
 db MAXIMUM_RESET_INCREASE_SLOWDOWN; phase_max_spawn_increase_delay -1 == stay unchanged MAXIMUM_RESET_INCREASE_SLOWDOWN
                    dw       50                          ; next phase after 20 spawns 

; minor shield speed increase
; hidden same as x
; bomber shoots fast - but long reload
phase2: 
                    db       DEFAULT_ALL_SPAWN            ; spawn types allowed 
                    db       SHIELD_WIDTH_GROWTH_DEFAULT  ;4 2 up , ec -> bpl than width grow 
                    db       SHIELD_DEFAULT_SPEED         ;2 shield major speed ; update every tick, must be in sum greater than minor increase 
                    db       3                            ; shield minor counter delay; test for dec -> bpl 
                    db       1                            ; 0 shield minor speed increase 
                    db       INITIAL_SHIELD_WIDTH_ADDER   ; 1 1-4 shield width adder 
                    db       INITIAL_SHOT_MOVE_DELAY      ;0 shot move delay ; test for dec -> bpl 
                    db       INITIAL_SHOT_MOVE_STRENGTH   ;0 shot move strength 
                    db       INITIAL_X_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_X_MOVE_STRENGTH      ;1 x move strength 
                    db       2;INITIAL_HX_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_HX_MOVE_STRENGTH      ;1 x move strength 
                    db       INITIAL_HUNTER_MOVE_DELAY    ;0 hunter move delay ; test for dec -> bpl 
                    db       INITIAL_HUNTER_MOVE_STRENGTH ;1 hunter move strength 
                    db       INITIAL_BOMBER_MOVE_DELAY    ;1 bomber move delay ; test for dec -> bpl 
                    db       INITIAL_BOMBER_MOVE_STRENGTH ;1 bomber move strength 
                    db       20; INITIAL_BOMBER_SHOT_DELAY    ; 200 bomber shot delay ; test for dec -> bpl, decreased by 25 every shot down to 50 (50 = 1 s) 
                    db       INITIAL_DRAGON_MOVE_DELAY    ;5 dragon inner move delay; test for dec -> bpl 
 dw INITIAL_DRAGON_MOVE_STRENGTH;2 Dragon_angle add ANGLES must be *2 since angles go up to 720
 db INITIAL_DRAGON_ANGLE_DELAY; 0 angle delay
                    db       DRAGON_CHILD_FREE_SPEED      ;2 dragonchild (free) speed; update per tick 
                    db       200;DEFAULT_MINIMUM_BOMB_RELOAD_DELAY 
                    db       INITIAL_BONUS_MOVE_DELAY     ; 3 
                    db       INITIAL_BONUS_MOVE_STRENGTH  ; 1 
                    db       DEFAULT_BONUS_ACTIVE_TIME    ; 9 
 db 40 ; phase_spawn_reset -1 == stay unchanged INITIAL_SPAWN_RESET_TIMER
 db INITIAL_SPAWN_INCREASE_DELAY; phase_spawn_increase_delay -1 == stay unchanged INITIAL_SPAWN_INCREASE_DELAY
 db FASTEST_SPAWN_RATE; phase_min_spawn_reset -1 == stay unchanged FASTEST_SPAWN_RATE
 db 9; phase_max_spawn_increase_delay -1 == stay unchanged MAXIMUM_RESET_INCREASE_SLOWDOWN
                    dw       50 
phase3: 
                    db       DEFAULT_ALL_SPAWN            ; spawn types allowed 
                    db       SHIELD_WIDTH_GROWTH_DEFAULT  ;4 2 up , ec -> bpl than width grow 
                    db       SHIELD_DEFAULT_SPEED         ;2 shield major speed ; update every tick, must be in sum greater than minor increase 
                    db       2                            ; shield minor counter delay; test for dec -> bpl 
                    db       1                            ; 0 shield minor speed increase 
                    db       INITIAL_SHIELD_WIDTH_ADDER   ; 1 1-4 shield width adder 
                    db       INITIAL_SHOT_MOVE_DELAY      ;0 shot move delay ; test for dec -> bpl 
                    db       INITIAL_SHOT_MOVE_STRENGTH   ;0 shot move strength 
                    db       INITIAL_X_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_X_MOVE_STRENGTH      ;1 x move strength 
                    db       INITIAL_HX_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_HX_MOVE_STRENGTH      ;1 x move strength 
                    db       INITIAL_HUNTER_MOVE_DELAY    ;0 hunter move delay ; test for dec -> bpl 
                    db       INITIAL_HUNTER_MOVE_STRENGTH ;1 hunter move strength 
                    db       INITIAL_BOMBER_MOVE_DELAY    ;1 bomber move delay ; test for dec -> bpl 
                    db       INITIAL_BOMBER_MOVE_STRENGTH ;1 bomber move strength 
                    db       INITIAL_BOMBER_SHOT_DELAY    ; bomber shot delay ; test for dec -> bpl, decreased by 25 every shot down to 50 (50 = 1 s) 
                    db       INITIAL_DRAGON_MOVE_DELAY    ;5 dragon inner move delay; test for dec -> bpl 
 dw 4;INITIAL_DRAGON_MOVE_STRENGTH;2 Dragon_angle add ANGLES must be *2 since angles go up to 720
 db INITIAL_DRAGON_ANGLE_DELAY; 0 angle delay
                    db       DRAGON_CHILD_FREE_SPEED      ;2 dragonchild (free) speed; update per tick 
                    db       DEFAULT_MINIMUM_BOMB_RELOAD_DELAY 
                    db       INITIAL_BONUS_MOVE_DELAY     ; 3 
                    db       INITIAL_BONUS_MOVE_STRENGTH  ; 1 
                    db       DEFAULT_BONUS_ACTIVE_TIME    ; 9 
 db 35 ; phase_spawn_reset -1 == stay unchanged INITIAL_SPAWN_RESET_TIMER
 db INITIAL_SPAWN_INCREASE_DELAY; phase_spawn_increase_delay -1 == stay unchanged INITIAL_SPAWN_INCREASE_DELAY
 db FASTEST_SPAWN_RATE; phase_min_spawn_reset -1 == stay unchanged FASTEST_SPAWN_RATE
 db 8; phase_max_spawn_increase_delay -1 == stay unchanged MAXIMUM_RESET_INCREASE_SLOWDOWN
; db 25;10 ; phase_spawn_reset -1 == stay unchanged
; db 1;0; phase_spawn_increase_delay -1 == stay unchanged
; db 25;5; CANON -1; phase_min_spawn_reset -1 == stay unchanged
; db 1;1; -1; phase_max_spawn_increase_delay -1 == stay unchanged
                    dw       50 
; spawning slow down!

phase4: 
                    db       DEFAULT_ALL_SPAWN            ; spawn types allowed 
                    db       3                            ;4 2 up , ec -> bpl than width grow 
                    db       3                            ;2 shield major speed ; update every tick, must be in sum greater than minor increase 
                    db       20                           ; shield minor counter delay; test for dec -> bpl 
                    db       0                            ; 0 shield minor speed increase 
                    db       2                            ;INITIAL_SHIELD_WIDTH_ADDER ; 1 1-4 shield width adder 
                    db       INITIAL_SHOT_MOVE_DELAY      ;0 shot move delay ; test for dec -> bpl 
                    db       INITIAL_SHOT_MOVE_STRENGTH   ;0 shot move strength 
                    db       INITIAL_X_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_X_MOVE_STRENGTH      ;1 x move strength 
                    db       INITIAL_HX_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_HX_MOVE_STRENGTH      ;1 x move strength 
                    db       INITIAL_HUNTER_MOVE_DELAY    ;0 hunter move delay ; test for dec -> bpl 
                    db       1                            ;INITIAL_HUNTER_MOVE_STRENGTH ;1 hunter move strength 
                    db       INITIAL_BOMBER_MOVE_DELAY    ;1 bomber move delay ; test for dec -> bpl 
                    db       INITIAL_BOMBER_MOVE_STRENGTH ;1 bomber move strength 
                    db       25                           ; INITIAL_BOMBER_SHOT_DELAY ; 200 bomber shot delay ; test for dec -> bpl, decreased by 25 every shot down to 50 (50 = 1 s) 
                    db       INITIAL_DRAGON_MOVE_DELAY    ;5 dragon inner move delay; test for dec -> bpl 
 dw 4;INITIAL_DRAGON_MOVE_STRENGTH;2 Dragon_angle add ANGLES must be *2 since angles go up to 720
 db INITIAL_DRAGON_ANGLE_DELAY; 0 angle delay
                    db       DRAGON_CHILD_FREE_SPEED      ;2 dragonchild (free) speed; update per tick 
                    db       DEFAULT_MINIMUM_BOMB_RELOAD_DELAY 
                    db       INITIAL_BONUS_MOVE_DELAY     ; 3 
                    db       INITIAL_BONUS_MOVE_STRENGTH  ; 1 
                    db       DEFAULT_BONUS_ACTIVE_TIME    ; 9 
 db 30 ; phase_spawn_reset -1 == stay unchanged INITIAL_SPAWN_RESET_TIMER
 db INITIAL_SPAWN_INCREASE_DELAY; phase_spawn_increase_delay -1 == stay unchanged INITIAL_SPAWN_INCREASE_DELAY
 db FASTEST_SPAWN_RATE; phase_min_spawn_reset -1 == stay unchanged FASTEST_SPAWN_RATE
 db 7; phase_max_spawn_increase_delay -1 == stay unchanged MAXIMUM_RESET_INCREASE_SLOWDOWN
                    dw       100 
phase5: 
                    db       DEFAULT_ALL_SPAWN            ; spawn types allowed 
                    db       3                            ;4 2 up , ec -> bpl than width grow 
                    db       3                            ;2 shield major speed ; update every tick, must be in sum greater than minor increase 
                    db       2                            ; shield minor counter delay; test for dec -> bpl 
                    db       1                            ; 0 shield minor speed increase 
                    db       2                            ;INITIAL_SHIELD_WIDTH_ADDER ; 1 1-4 shield width adder 
                    db       INITIAL_SHOT_MOVE_DELAY      ;0 shot move delay ; test for dec -> bpl 
                    db       INITIAL_SHOT_MOVE_STRENGTH   ;0 shot move strength 
                    db       INITIAL_X_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_X_MOVE_STRENGTH      ;1 x move strength 
                    db       INITIAL_HX_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_HX_MOVE_STRENGTH      ;1 x move strength 
                    db       INITIAL_HUNTER_MOVE_DELAY    ;0 hunter move delay ; test for dec -> bpl 
                    db       1                            ;INITIAL_HUNTER_MOVE_STRENGTH ;1 hunter move strength 
                    db       INITIAL_BOMBER_MOVE_DELAY    ;1 bomber move delay ; test for dec -> bpl 
                    db       INITIAL_BOMBER_MOVE_STRENGTH ;1 bomber move strength 
                    db       25                           ; INITIAL_BOMBER_SHOT_DELAY ; 200 bomber shot delay ; test for dec -> bpl, decreased by 25 every shot down to 50 (50 = 1 s) 
                    db       INITIAL_DRAGON_MOVE_DELAY    ;5 dragon inner move delay; test for dec -> bpl 
 dw 4;INITIAL_DRAGON_MOVE_STRENGTH;2 Dragon_angle add ANGLES must be *2 since angles go up to 720
 db INITIAL_DRAGON_ANGLE_DELAY; 0 angle delay
                    db       DRAGON_CHILD_FREE_SPEED      ;2 dragonchild (free) speed; update per tick 
                    db       DEFAULT_MINIMUM_BOMB_RELOAD_DELAY 
                    db       INITIAL_BONUS_MOVE_DELAY     ; 3 
                    db       INITIAL_BONUS_MOVE_STRENGTH  ; 1 
                    db       DEFAULT_BONUS_ACTIVE_TIME    ; 9 
 db 25;10 ; phase_spawn_reset -1 == stay unchanged
 db 1;0; phase_spawn_increase_delay -1 == stay unchanged
 db 25;5; CANON -1; phase_min_spawn_reset -1 == stay unchanged
 db 1;1; -1; phase_max_spawn_increase_delay -1 == stay unchanged
                    dw       100 

squad_raid_1: 
                    db       ALLOW_SQUAD            ; spawn types allowed 
                    db       SHIELD_WIDTH_GROWTH_DEFAULT  ;4 2 up , ec -> bpl than width grow 
                    db       SHIELD_DEFAULT_SPEED         ;2 shield major speed ; update every tick, must be in sum greater than minor increase 
                    db       SHIELD_MINOR_DELAY_COUNTER_DEFAULT ; 2 shield minor counter delay; test for dec -> bpl 
                    db       SHIELD_MINOR_INCREASE_DEFAULT ; 0 shield minor speed increase 
                    db       1;INITIAL_SHIELD_WIDTH_ADDER   ; 1 1-4 shield width adder 
                    db       INITIAL_SHOT_MOVE_DELAY      ;0 shot move delay ; test for dec -> bpl 
                    db       INITIAL_SHOT_MOVE_STRENGTH   ;0 shot move strength 
                    db       INITIAL_X_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_X_MOVE_STRENGTH      ;1 x move strength 
                    db       INITIAL_HX_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_HX_MOVE_STRENGTH      ;1 x move strength 
                    db       INITIAL_HUNTER_MOVE_DELAY    ;0 hunter move delay ; test for dec -> bpl 
                    db       1                            ;INITIAL_HUNTER_MOVE_STRENGTH ;1 hunter move strength 
                    db       INITIAL_BOMBER_MOVE_DELAY    ;1 bomber move delay ; test for dec -> bpl 
                    db       INITIAL_BOMBER_MOVE_STRENGTH ;1 bomber move strength 
                    db       25                           ; INITIAL_BOMBER_SHOT_DELAY ; 200 bomber shot delay ; test for dec -> bpl, decreased by 25 every shot down to 50 (50 = 1 s) 
                    db       INITIAL_DRAGON_MOVE_DELAY    ;5 dragon inner move delay; test for dec -> bpl 
 dw 4;INITIAL_DRAGON_MOVE_STRENGTH;2 Dragon_angle add ANGLES must be *2 since angles go up to 720
 db INITIAL_DRAGON_ANGLE_DELAY; 0 angle delay
                    db       DRAGON_CHILD_FREE_SPEED      ;2 dragonchild (free) speed; update per tick 
                    db       DEFAULT_MINIMUM_BOMB_RELOAD_DELAY 
                    db       INITIAL_BONUS_MOVE_DELAY     ; 3 
                    db       INITIAL_BONUS_MOVE_STRENGTH  ; 1 
                    db       DEFAULT_BONUS_ACTIVE_TIME    ; 9 
 db 25;10 ; phase_spawn_reset -1 == stay unchanged
 db 1;0; phase_spawn_increase_delay -1 == stay unchanged
 db 25;5; CANON -1; phase_min_spawn_reset -1 == stay unchanged
 db 1;1; -1; phase_max_spawn_increase_delay -1 == stay unchanged
                    dw       24 



phase6: 
                    db       DEFAULT_ALL_SPAWN            ; spawn types allowed 
                    db       3                            ;4 2 up , ec -> bpl than width grow 
                    db       3                            ;2 shield major speed ; update every tick, must be in sum greater than minor increase 
                    db       1                            ; shield minor counter delay; test for dec -> bpl 
                    db       1                            ; 0 shield minor speed increase 
                    db       2                            ;INITIAL_SHIELD_WIDTH_ADDER ; 1 1-4 shield width adder 
                    db       3;INITIAL_SHOT_MOVE_DELAY      ;0 shot move delay ; test for dec -> bpl 
                    db       INITIAL_SHOT_MOVE_STRENGTH   ;0 shot move strength 
                    db       INITIAL_X_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_X_MOVE_STRENGTH      ;1 x move strength 
                    db       INITIAL_HX_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_HX_MOVE_STRENGTH      ;1 x move strength 
                    db       INITIAL_HUNTER_MOVE_DELAY    ;0 hunter move delay ; test for dec -> bpl 
                    db       2                            ;INITIAL_HUNTER_MOVE_STRENGTH ;1 hunter move strength 
                    db       0;INITIAL_BOMBER_MOVE_DELAY    ;1 bomber move delay ; test for dec -> bpl 
                    db       INITIAL_BOMBER_MOVE_STRENGTH ;1 bomber move strength 
                    db       25                           ; INITIAL_BOMBER_SHOT_DELAY ; 200 bomber shot delay ; test for dec -> bpl, decreased by 25 every shot down to 50 (50 = 1 s) 
                    db       4;INITIAL_DRAGON_MOVE_DELAY    ;5 dragon inner move delay; test for dec -> bpl 
 dw 4;INITIAL_DRAGON_MOVE_STRENGTH;2 Dragon_angle add ANGLES must be *2 since angles go up to 720
 db INITIAL_DRAGON_ANGLE_DELAY; 0 angle delay
                    db       DRAGON_CHILD_FREE_SPEED      ;2 dragonchild (free) speed; update per tick 
                    db       25; DEFAULT_MINIMUM_BOMB_RELOAD_DELAY 
                    db       INITIAL_BONUS_MOVE_DELAY     ; 3 
                    db       3;INITIAL_BONUS_MOVE_STRENGTH  ; 1 
                    db       DEFAULT_BONUS_ACTIVE_TIME    ; 9 
 db 30;10 ; phase_spawn_reset -1 == stay unchanged
 db 1;0; phase_spawn_increase_delay -1 == stay unchanged
 db 25;5; CANON -1; phase_min_spawn_reset -1 == stay unchanged
 db 5;1; -1; phase_max_spawn_increase_delay -1 == stay unchanged
                    dw       50 


squad_raid_2: 
                    db       ALLOW_SQUAD            ; spawn types allowed 
                    db       3                            ;4 2 up , ec -> bpl than width grow 
                    db       3                            ;2 shield major speed ; update every tick, must be in sum greater than minor increase 
                    db       1                            ; shield minor counter delay; test for dec -> bpl 
                    db       1                            ; 0 shield minor speed increase 
                    db       2                            ;INITIAL_SHIELD_WIDTH_ADDER ; 1 1-4 shield width adder 
                    db       3;INITIAL_SHOT_MOVE_DELAY      ;0 shot move delay ; test for dec -> bpl 
                    db       INITIAL_SHOT_MOVE_STRENGTH   ;0 shot move strength 
                    db       INITIAL_X_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_X_MOVE_STRENGTH      ;1 x move strength 
                    db       INITIAL_HX_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_HX_MOVE_STRENGTH      ;1 x move strength 
                    db       INITIAL_HUNTER_MOVE_DELAY    ;0 hunter move delay ; test for dec -> bpl 
                    db       2                            ;INITIAL_HUNTER_MOVE_STRENGTH ;1 hunter move strength 
                    db       0;INITIAL_BOMBER_MOVE_DELAY    ;1 bomber move delay ; test for dec -> bpl 
                    db       INITIAL_BOMBER_MOVE_STRENGTH ;1 bomber move strength 
                    db       25                           ; INITIAL_BOMBER_SHOT_DELAY ; 200 bomber shot delay ; test for dec -> bpl, decreased by 25 every shot down to 50 (50 = 1 s) 
                    db       4;INITIAL_DRAGON_MOVE_DELAY    ;5 dragon inner move delay; test for dec -> bpl 
 dw 4;INITIAL_DRAGON_MOVE_STRENGTH;2 Dragon_angle add ANGLES must be *2 since angles go up to 720
 db INITIAL_DRAGON_ANGLE_DELAY; 0 angle delay
                    db       DRAGON_CHILD_FREE_SPEED      ;2 dragonchild (free) speed; update per tick 
                    db       25; DEFAULT_MINIMUM_BOMB_RELOAD_DELAY 
                    db       INITIAL_BONUS_MOVE_DELAY     ; 3 
                    db       3;INITIAL_BONUS_MOVE_STRENGTH  ; 1 
                    db       DEFAULT_BONUS_ACTIVE_TIME    ; 9 
 db 25;10 ; phase_spawn_reset -1 == stay unchanged
 db 1;0; phase_spawn_increase_delay -1 == stay unchanged
 db 25;5; CANON -1; phase_min_spawn_reset -1 == stay unchanged
 db 1;1; -1; phase_max_spawn_increase_delay -1 == stay unchanged
                    dw       40 


phase7: 
                    db       DEFAULT_ALL_SPAWN            ; spawn types allowed 
                    db       3                            ;4 2 up , ec -> bpl than width grow 
                    db       3                            ;2 shield major speed ; update every tick, must be in sum greater than minor increase 
                    db       0                            ; shield minor counter delay; test for dec -> bpl 
                    db       1                            ; 0 shield minor speed increase 
                    db       2                            ;INITIAL_SHIELD_WIDTH_ADDER ; 1 1-4 shield width adder 
                    db       1;INITIAL_SHOT_MOVE_DELAY      ;0 shot move delay ; test for dec -> bpl 
                    db       INITIAL_SHOT_MOVE_STRENGTH   ;0 shot move strength 
                    db       INITIAL_X_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_X_MOVE_STRENGTH      ;1 x move strength 
                    db       INITIAL_HX_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_HX_MOVE_STRENGTH      ;1 x move strength 
                    db       INITIAL_HUNTER_MOVE_DELAY    ;0 hunter move delay ; test for dec -> bpl 
                    db       2                            ;INITIAL_HUNTER_MOVE_STRENGTH ;1 hunter move strength 
                    db       0;INITIAL_BOMBER_MOVE_DELAY    ;1 bomber move delay ; test for dec -> bpl 
                    db       INITIAL_BOMBER_MOVE_STRENGTH ;1 bomber move strength 
                    db       25                           ; INITIAL_BOMBER_SHOT_DELAY ; 200 bomber shot delay ; test for dec -> bpl, decreased by 25 every shot down to 50 (50 = 1 s) 
                    db       4;INITIAL_DRAGON_MOVE_DELAY    ;5 dragon inner move delay; test for dec -> bpl 
 dw 4;INITIAL_DRAGON_MOVE_STRENGTH;2 Dragon_angle add ANGLES must be *2 since angles go up to 720
 db INITIAL_DRAGON_ANGLE_DELAY; 0 angle delay
                    db       DRAGON_CHILD_FREE_SPEED      ;2 dragonchild (free) speed; update per tick 
                    db       25; DEFAULT_MINIMUM_BOMB_RELOAD_DELAY 
                    db       INITIAL_BONUS_MOVE_DELAY     ; 3 
                    db       3;INITIAL_BONUS_MOVE_STRENGTH  ; 1 
                    db       DEFAULT_BONUS_ACTIVE_TIME    ; 9 
 db -1;10 ; phase_spawn_reset -1 == stay unchanged
 db -1;0; phase_spawn_increase_delay -1 == stay unchanged
 db 20;5; CANON -1; phase_min_spawn_reset -1 == stay unchanged
 db -1;1; -1; phase_max_spawn_increase_delay -1 == stay unchanged
                    dw       100 


squad_raid_3: 
                    db       ALLOW_SQUAD            ; spawn types allowed 
                    db       3                            ;4 2 up , ec -> bpl than width grow 
                    db       3                            ;2 shield major speed ; update every tick, must be in sum greater than minor increase 
                    db       0                            ; shield minor counter delay; test for dec -> bpl 
                    db       1                            ; 0 shield minor speed increase 
                    db       2                            ;INITIAL_SHIELD_WIDTH_ADDER ; 1 1-4 shield width adder 
                    db       1;INITIAL_SHOT_MOVE_DELAY      ;0 shot move delay ; test for dec -> bpl 
                    db       INITIAL_SHOT_MOVE_STRENGTH   ;0 shot move strength 
                    db       INITIAL_X_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_X_MOVE_STRENGTH      ;1 x move strength 
                    db       INITIAL_HX_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_HX_MOVE_STRENGTH      ;1 x move strength 
                    db       INITIAL_HUNTER_MOVE_DELAY    ;0 hunter move delay ; test for dec -> bpl 
                    db       2                            ;INITIAL_HUNTER_MOVE_STRENGTH ;1 hunter move strength 
                    db       0;INITIAL_BOMBER_MOVE_DELAY    ;1 bomber move delay ; test for dec -> bpl 
                    db       INITIAL_BOMBER_MOVE_STRENGTH ;1 bomber move strength 
                    db       25                           ; INITIAL_BOMBER_SHOT_DELAY ; 200 bomber shot delay ; test for dec -> bpl, decreased by 25 every shot down to 50 (50 = 1 s) 
                    db       4;INITIAL_DRAGON_MOVE_DELAY    ;5 dragon inner move delay; test for dec -> bpl 
 dw 4;INITIAL_DRAGON_MOVE_STRENGTH;2 Dragon_angle add ANGLES must be *2 since angles go up to 720
 db INITIAL_DRAGON_ANGLE_DELAY; 0 angle delay
                    db       DRAGON_CHILD_FREE_SPEED      ;2 dragonchild (free) speed; update per tick 
                    db       25; DEFAULT_MINIMUM_BOMB_RELOAD_DELAY 
                    db       INITIAL_BONUS_MOVE_DELAY     ; 3 
                    db       3;INITIAL_BONUS_MOVE_STRENGTH  ; 1 
                    db       DEFAULT_BONUS_ACTIVE_TIME    ; 9 
 db 25;10 ; phase_spawn_reset -1 == stay unchanged
 db 1;0; phase_spawn_increase_delay -1 == stay unchanged
 db 25;5; CANON -1; phase_min_spawn_reset -1 == stay unchanged
 db 1;1; -1; phase_max_spawn_increase_delay -1 == stay unchanged
                    dw       40 

phase8: 
                    db       DEFAULT_ALL_SPAWN            ; spawn types allowed 
                    db       3                            ;4 2 up , ec -> bpl than width grow 
                    db       3                            ;2 shield major speed ; update every tick, must be in sum greater than minor increase 
                    db       20                            ; shield minor counter delay; test for dec -> bpl 
                    db       0                            ; 0 shield minor speed increase 
                    db       3                            ;INITIAL_SHIELD_WIDTH_ADDER ; 1 1-4 shield width adder 
                    db       0;INITIAL_SHOT_MOVE_DELAY      ;0 shot move delay ; test for dec -> bpl 
                    db       2;INITIAL_SHOT_MOVE_STRENGTH   ;0 shot move strength 
                    db       0;INITIAL_X_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       1;INITIAL_X_MOVE_STRENGTH      ;1 x move strength 
                    db       INITIAL_HX_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_HX_MOVE_STRENGTH      ;1 x move strength 
                    db       INITIAL_HUNTER_MOVE_DELAY    ;0 hunter move delay ; test for dec -> bpl 
                    db       2                            ;INITIAL_HUNTER_MOVE_STRENGTH ;1 hunter move strength 
                    db       0;INITIAL_BOMBER_MOVE_DELAY    ;1 bomber move delay ; test for dec -> bpl 
                    db       2;INITIAL_BOMBER_MOVE_STRENGTH ;1 bomber move strength 
                    db       40                           ; INITIAL_BOMBER_SHOT_DELAY ; 200 bomber shot delay ; test for dec -> bpl, decreased by 25 every shot down to 50 (50 = 1 s) 
                    db       1;INITIAL_DRAGON_MOVE_DELAY    ;5 dragon inner move delay; test for dec -> bpl 
 dw 6;INITIAL_DRAGON_MOVE_STRENGTH;2 Dragon_angle add ANGLES must be *2 since angles go up to 720
 db INITIAL_DRAGON_ANGLE_DELAY; 0 angle delay
                    db       2;DRAGON_CHILD_FREE_SPEED      ;2 dragonchild (free) speed; update per tick 
                    db       10; DEFAULT_MINIMUM_BOMB_RELOAD_DELAY 
                    db       INITIAL_BONUS_MOVE_DELAY     ; 3 
                    db       3;INITIAL_BONUS_MOVE_STRENGTH  ; 1 
                    db       15    ; 9 
 db 50;10 ; phase_spawn_reset -1 == stay unchanged
 db 1;0; phase_spawn_increase_delay -1 == stay unchanged
 db 15;5; CANON -1; phase_min_spawn_reset -1 == stay unchanged
 db 20;1; -1; phase_max_spawn_increase_delay -1 == stay unchanged
                    dw       0 



; very slow hiddens
hunter_raid_2: 
                    db       ALLOW_HUNTER            ; spawn types allowed 
                    db       3                            ;4 2 up , ec -> bpl than width grow 
                    db       3                            ;2 shield major speed ; update every tick, must be in sum greater than minor increase 
                    db       1                            ; shield minor counter delay; test for dec -> bpl 
                    db       1                            ; 0 shield minor speed increase 
                    db       2                            ;INITIAL_SHIELD_WIDTH_ADDER ; 1 1-4 shield width adder 
                    db       3;INITIAL_SHOT_MOVE_DELAY      ;0 shot move delay ; test for dec -> bpl 
                    db       INITIAL_SHOT_MOVE_STRENGTH   ;0 shot move strength 
                    db       INITIAL_X_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_X_MOVE_STRENGTH      ;1 x move strength 
                    db       INITIAL_HX_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_HX_MOVE_STRENGTH      ;1 x move strength 
                    db       INITIAL_HUNTER_MOVE_DELAY    ;0 hunter move delay ; test for dec -> bpl 
                    db       2                            ;INITIAL_HUNTER_MOVE_STRENGTH ;1 hunter move strength 
                    db       0;INITIAL_BOMBER_MOVE_DELAY    ;1 bomber move delay ; test for dec -> bpl 
                    db       INITIAL_BOMBER_MOVE_STRENGTH ;1 bomber move strength 
                    db       25                           ; INITIAL_BOMBER_SHOT_DELAY ; 200 bomber shot delay ; test for dec -> bpl, decreased by 25 every shot down to 50 (50 = 1 s) 
                    db       4;INITIAL_DRAGON_MOVE_DELAY    ;5 dragon inner move delay; test for dec -> bpl 
 dw 4;INITIAL_DRAGON_MOVE_STRENGTH;2 Dragon_angle add ANGLES must be *2 since angles go up to 720
 db INITIAL_DRAGON_ANGLE_DELAY; 0 angle delay
                    db       DRAGON_CHILD_FREE_SPEED      ;2 dragonchild (free) speed; update per tick 
                    db       25; DEFAULT_MINIMUM_BOMB_RELOAD_DELAY 
                    db       INITIAL_BONUS_MOVE_DELAY     ; 3 
                    db       3;INITIAL_BONUS_MOVE_STRENGTH  ; 1 
                    db       DEFAULT_BONUS_ACTIVE_TIME    ; 9 
 db 10 ; phase_spawn_reset -1 == stay unchanged INITIAL_SPAWN_RESET_TIMER
 db INITIAL_SPAWN_INCREASE_DELAY; phase_spawn_increase_delay -1 == stay unchanged INITIAL_SPAWN_INCREASE_DELAY
 db FASTEST_SPAWN_RATE; phase_min_spawn_reset -1 == stay unchanged FASTEST_SPAWN_RATE
 db MAXIMUM_RESET_INCREASE_SLOWDOWN; phase_max_spawn_increase_delay -1 == stay unchanged MAXIMUM_RESET_INCREASE_SLOWDOWN
                    dw       10   

; very slow hiddens
bomber_raid_2: 
                    db       ALLOW_BOMBER            ; spawn types allowed 
                    db       3                            ;4 2 up , ec -> bpl than width grow 
                    db       3                            ;2 shield major speed ; update every tick, must be in sum greater than minor increase 
                    db       0                            ; shield minor counter delay; test for dec -> bpl 
                    db       1                            ; 0 shield minor speed increase 
                    db       2                            ;INITIAL_SHIELD_WIDTH_ADDER ; 1 1-4 shield width adder 
                    db       1;INITIAL_SHOT_MOVE_DELAY      ;0 shot move delay ; test for dec -> bpl 
                    db       INITIAL_SHOT_MOVE_STRENGTH   ;0 shot move strength 
                    db       INITIAL_X_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_X_MOVE_STRENGTH      ;1 x move strength 
                    db       INITIAL_HX_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_HX_MOVE_STRENGTH      ;1 x move strength 
                    db       INITIAL_HUNTER_MOVE_DELAY    ;0 hunter move delay ; test for dec -> bpl 
                    db       2                            ;INITIAL_HUNTER_MOVE_STRENGTH ;1 hunter move strength 
                    db       0;INITIAL_BOMBER_MOVE_DELAY    ;1 bomber move delay ; test for dec -> bpl 
                    db       INITIAL_BOMBER_MOVE_STRENGTH ;1 bomber move strength 
                    db       25                           ; INITIAL_BOMBER_SHOT_DELAY ; 200 bomber shot delay ; test for dec -> bpl, decreased by 25 every shot down to 50 (50 = 1 s) 
                    db       4;INITIAL_DRAGON_MOVE_DELAY    ;5 dragon inner move delay; test for dec -> bpl 
 dw 4;INITIAL_DRAGON_MOVE_STRENGTH;2 Dragon_angle add ANGLES must be *2 since angles go up to 720
 db INITIAL_DRAGON_ANGLE_DELAY; 0 angle delay
                    db       DRAGON_CHILD_FREE_SPEED      ;2 dragonchild (free) speed; update per tick 
                    db       25; DEFAULT_MINIMUM_BOMB_RELOAD_DELAY 
                    db       INITIAL_BONUS_MOVE_DELAY     ; 3 
                    db       3;INITIAL_BONUS_MOVE_STRENGTH  ; 1 
                    db       DEFAULT_BONUS_ACTIVE_TIME    ; 9 
 db 10 ; phase_spawn_reset -1 == stay unchanged INITIAL_SPAWN_RESET_TIMER
 db INITIAL_SPAWN_INCREASE_DELAY; phase_spawn_increase_delay -1 == stay unchanged INITIAL_SPAWN_INCREASE_DELAY
 db FASTEST_SPAWN_RATE; phase_min_spawn_reset -1 == stay unchanged FASTEST_SPAWN_RATE
 db MAXIMUM_RESET_INCREASE_SLOWDOWN; phase_max_spawn_increase_delay -1 == stay unchanged MAXIMUM_RESET_INCREASE_SLOWDOWN
                    dw       20   

; very slow hiddens
dragon_raid_2: 
                    db       ALLOW_DRAGON            ; spawn types allowed 
                    db       3                            ;4 2 up , ec -> bpl than width grow 
                    db       3                            ;2 shield major speed ; update every tick, must be in sum greater than minor increase 
                    db       20                            ; shield minor counter delay; test for dec -> bpl 
                    db       0                            ; 0 shield minor speed increase 
                    db       3                            ;INITIAL_SHIELD_WIDTH_ADDER ; 1 1-4 shield width adder 
                    db       0;INITIAL_SHOT_MOVE_DELAY      ;0 shot move delay ; test for dec -> bpl 
                    db       2;INITIAL_SHOT_MOVE_STRENGTH   ;0 shot move strength 
                    db       0;INITIAL_X_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       1;INITIAL_X_MOVE_STRENGTH      ;1 x move strength 
                    db       INITIAL_HX_MOVE_DELAY         ;1 x move delay ; test for dec -> bpl 
                    db       INITIAL_HX_MOVE_STRENGTH      ;1 x move strength 
                    db       INITIAL_HUNTER_MOVE_DELAY    ;0 hunter move delay ; test for dec -> bpl 
                    db       2                            ;INITIAL_HUNTER_MOVE_STRENGTH ;1 hunter move strength 
                    db       0;INITIAL_BOMBER_MOVE_DELAY    ;1 bomber move delay ; test for dec -> bpl 
                    db       2;INITIAL_BOMBER_MOVE_STRENGTH ;1 bomber move strength 
                    db       40                           ; INITIAL_BOMBER_SHOT_DELAY ; 200 bomber shot delay ; test for dec -> bpl, decreased by 25 every shot down to 50 (50 = 1 s) 
                    db       1;INITIAL_DRAGON_MOVE_DELAY    ;5 dragon inner move delay; test for dec -> bpl 
 dw 6;INITIAL_DRAGON_MOVE_STRENGTH;2 Dragon_angle add ANGLES must be *2 since angles go up to 720
 db INITIAL_DRAGON_ANGLE_DELAY; 0 angle delay
                    db       2;DRAGON_CHILD_FREE_SPEED      ;2 dragonchild (free) speed; update per tick 
                    db       10; DEFAULT_MINIMUM_BOMB_RELOAD_DELAY 
                    db       INITIAL_BONUS_MOVE_DELAY     ; 3 
                    db       3;INITIAL_BONUS_MOVE_STRENGTH  ; 1 
                    db       15    ; 9 
 db 10 ; phase_spawn_reset -1 == stay unchanged INITIAL_SPAWN_RESET_TIMER
 db INITIAL_SPAWN_INCREASE_DELAY; phase_spawn_increase_delay -1 == stay unchanged INITIAL_SPAWN_INCREASE_DELAY
 db FASTEST_SPAWN_RATE; phase_min_spawn_reset -1 == stay unchanged FASTEST_SPAWN_RATE
 db MAXIMUM_RESET_INCREASE_SLOWDOWN; phase_max_spawn_increase_delay -1 == stay unchanged MAXIMUM_RESET_INCREASE_SLOWDOWN
                    dw       10   

