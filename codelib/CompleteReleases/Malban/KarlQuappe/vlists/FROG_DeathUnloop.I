; this file is part of Karl Quappe, written by Malban
; in 2016
; all stuff contained here is public domain
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this file contains 'sprite' definition data for all frogs (non morphing)  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; These are manual values, that respresent the 
; visual offset the current frog sprite has in relation to its
; position 
; the offset is neccesary, since not all vectorlists of the sprite 
; start at the same "grid position"
;
GIRL_X_OFFSET       equ      0 
GIRL_SPRING_TIMER   EQU      58                           ; how often does the girl hop on her log 
;
frogger_down_offset: 
                    DB       3-1                          ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       2                            ; offsets x in 'SCALE_FACTOR_GAME' 
frogger_up_offset: 
                    DB       4 -1                         ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       3                            ; offsets x in 'SCALE_FACTOR_GAME' 
frogger_left_offset: 
                    DB       -3 -1                        ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       0                            ; offsets x in 'SCALE_FACTOR_GAME' 
frogger_right_offset: 
                    DB       0 -1                         ;-1 ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       1                            ; offsets x in 'SCALE_FACTOR_GAME' 
BLOW_UP_VLISTS             EQU      20 
froggerDownAnim: 
                    dw       frogger_down_0 
                    dw       frogger_down_1 
                    dw       frogger_down_2 
                    dw       frogger_down_3 
                    dw       frogger_down_4 
                    dw       frogger_down_5 
                    dw       frogger_down_5 
                    dw       frogger_down_0 
frogger_down: 
frogger_down_0: 
; DB +$17 ; number of lines to draw
                    DW       (MAX_LINE_NUM-($12+1))*ONE_LINE_LENGTH 
                    DB       +$01*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$03*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$05*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$05*BLOW_UP_VLISTS, +$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$05*BLOW_UP_VLISTS, +$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$05*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$03*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
frogger_down_1: 
; DB +$17 ; number of lines to draw
                    DW       (MAX_LINE_NUM-($12+1))*ONE_LINE_LENGTH 
                    DB       +$01*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$05*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$05*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$04*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$05*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$03*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$03*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$05*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$04*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$05*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$05*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
frogger_down_2: 
; DB +$17 ; number of lines to draw
                    DW       (MAX_LINE_NUM-($12+1))*ONE_LINE_LENGTH 
                    DB       +$00*BLOW_UP_VLISTS, +$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$05*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$05*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$05*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$05*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$03*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$04*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$04*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$03*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$05*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$05*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$05*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$05*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
frogger_down_3: 
; DB +$17 ; number of lines to draw
                    DW       (MAX_LINE_NUM-($12+1))*ONE_LINE_LENGTH 
                    DB       -$01*BLOW_UP_VLISTS, +$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, +$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$05*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$05*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$05*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$05*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$04*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$04*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$04*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$04*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$05*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$05*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$05*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$05*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
frogger_down_4: 
; DB +$17 ; number of lines to draw
                    DW       (MAX_LINE_NUM-($12+1))*ONE_LINE_LENGTH 
                    DB       +$00*BLOW_UP_VLISTS, +$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$05*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$05*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$04*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$05*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$04*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$04*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$04*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$04*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$05*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$04*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$05*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$05*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
frogger_down_5: 
; DB +$17 ; number of lines to draw
                    DW       (MAX_LINE_NUM-($12+1))*ONE_LINE_LENGTH 
                    DB       +$01*BLOW_UP_VLISTS, +$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, +$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$04*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$04*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$04*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$05*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$05*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$04*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$04*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$04*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
froggerUpAnim: 
                    dw       frogger_up_0 
                    dw       frogger_up_1 
                    dw       frogger_up_2 
                    dw       frogger_up_3 
                    dw       frogger_up_4 
                    dw       frogger_up_5 
                    dw       frogger_up_5 
                    dw       frogger_up_0 
frogger_up: 
frogger_up_0: 
; DB +$17 ; number of lines to draw
                    DW       (MAX_LINE_NUM-($12+1))*ONE_LINE_LENGTH 
                    DB       +$02*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$05*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$05*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$03*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$03*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$05*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$05*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
frogger_up_1: 
; DB +$17 ; number of lines to draw
                    DW       (MAX_LINE_NUM-($12+1))*ONE_LINE_LENGTH 
                    DB       +$02*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$03*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$05*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$04*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$05*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$05*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$05*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$05*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$04*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$05*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$03*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
frogger_up_2: 
; DB +$17 ; number of lines to draw
                    DW       (MAX_LINE_NUM-($12+1))*ONE_LINE_LENGTH 
                    DB       +$02*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$04*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$03*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$05*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$05*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$05*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$05*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$05*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$05*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$05*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$05*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$03*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$04*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
frogger_up_3: 
; DB +$17 ; number of lines to draw
                    DW       (MAX_LINE_NUM-($12+1))*ONE_LINE_LENGTH 
                    DB       +$02*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$04*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$04*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$05*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$05*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$05*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$05*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$05*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$05*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$05*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$05*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$04*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$04*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
frogger_up_4: 
; DB +$17 ; number of lines to draw
                    DW       (MAX_LINE_NUM-($12+1))*ONE_LINE_LENGTH 
                    DB       +$02*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$04*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$04*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$05*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$04*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$05*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$05*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$05*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$05*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$04*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$05*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$04*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$04*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
frogger_up_5: 
; DB +$17 ; number of lines to draw
                    DW       (MAX_LINE_NUM-($12+1))*ONE_LINE_LENGTH 
                    DB       +$02*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$05*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$04*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$04*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$04*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$04*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$04*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$04*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$05*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
froggerLeftAnim: 
                    dw       frogger_left_0 
                    dw       frogger_left_1 
                    dw       frogger_left_2 
                    dw       frogger_left_3 
                    dw       frogger_left_4 
                    dw       frogger_left_5 
                    dw       frogger_left_5 
                    dw       frogger_left_0 
frogger_left_0: 
; DB +$17 ; number of lines to draw
                    DW       (MAX_LINE_NUM-($12+1))*ONE_LINE_LENGTH 
                    DB       +$04*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$03*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$04*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$04*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$03*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
frogger_left_1: 
; DB +$17 ; number of lines to draw
                    DW       (MAX_LINE_NUM-($12+1))*ONE_LINE_LENGTH 
                    DB       +$04*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$04*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$04*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, +$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
frogger_left_2: 
; DB +$17 ; number of lines to draw
                    DW       (MAX_LINE_NUM-($12+1))*ONE_LINE_LENGTH 
                    DB       +$04*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, +$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$03*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$03*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
frogger_left_3: 
; DB +$17 ; number of lines to draw
                    DW       (MAX_LINE_NUM-($12+1))*ONE_LINE_LENGTH 
                    DB       +$04*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$03*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$03*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
frogger_left_4: 
; DB +$17 ; number of lines to draw
                    DW       (MAX_LINE_NUM-($12+1))*ONE_LINE_LENGTH 
                    DB       +$04*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$03*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$03*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
frogger_left_5: 
; DB +$17 ; number of lines to draw
                    DW       (MAX_LINE_NUM-($12+1))*ONE_LINE_LENGTH 
                    DB       +$04*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$03*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$03*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
froggerRightAnim: 
                    dw       frogger_right_0 
                    dw       frogger_right_1 
                    dw       frogger_right_2 
                    dw       frogger_right_3 
                    dw       frogger_right_4 
                    dw       frogger_right_5 
                    dw       frogger_right_5 
                    dw       frogger_right_0 
frogger_right_0: 
; DB +$17 ; number of lines to draw
                    DW       (MAX_LINE_NUM-($12+1))*ONE_LINE_LENGTH 
                    DB       +$04*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$03*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$04*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$03*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$04*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
frogger_right_1: 
; DB +$17 ; number of lines to draw
                    DW       (MAX_LINE_NUM-($12+1))*ONE_LINE_LENGTH 
                    DB       +$04*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$04*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, +$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$04*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
frogger_right_2: 
; DB +$17 ; number of lines to draw
                    DW       (MAX_LINE_NUM-($12+1))*ONE_LINE_LENGTH 
                    DB       +$03*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, +$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$04*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$03*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
frogger_right_3: 
; DB +$17 ; number of lines to draw
                    DW       (MAX_LINE_NUM-($12+1))*ONE_LINE_LENGTH 
                    DB       +$03*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$04*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$03*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
frogger_right_4: 
; DB +$17 ; number of lines to draw
                    DW       (MAX_LINE_NUM-($12+1))*ONE_LINE_LENGTH 
                    DB       +$03*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$04*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$03*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
frogger_right_5: 
; DB +$17 ; number of lines to draw
                    DW       (MAX_LINE_NUM-($12+1))*ONE_LINE_LENGTH 
                    DB       +$03*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$04*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$03*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
frog1a_in_home_sprite: 
;                DB 7
                    DW       (MAX_LINE_NUM_16-($7+1))*ONE_LINE_LENGTH 
                    DB       -3*SPRITE_BLOW_UP, 2*SPRITE_BLOW_UP 
                    DB       0*SPRITE_BLOW_UP, 3*SPRITE_BLOW_UP 
                    DB       3*SPRITE_BLOW_UP, 2*SPRITE_BLOW_UP 
                    DB       -1*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP 
                    DB       4*SPRITE_BLOW_UP, 0*SPRITE_BLOW_UP 
                    DB       0*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP 
                    DB       -4*SPRITE_BLOW_UP, 2*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP 
frog1a_in_home_object: 
                    DB       0                            ; speed + direction 
                    DW       frog1a_in_home_sprite        ; graphic definition 
                    DB       0                            ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       frog1b_in_home_object        ; pointer to next anim object 
                    DB       -4                           ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       4                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       $60                          ; brightness 
                    DB       0                            ; special flag 
frog1b_in_home_sprite: 
;                DB 7
                    DW       (MAX_LINE_NUM_16-($7+1))*ONE_LINE_LENGTH 
                    DB       -3*SPRITE_BLOW_UP, 2*SPRITE_BLOW_UP 
                    DB       0*SPRITE_BLOW_UP, 3*SPRITE_BLOW_UP 
                    DB       3*SPRITE_BLOW_UP, 2*SPRITE_BLOW_UP 
                    DB       -1*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP 
                    DB       4*SPRITE_BLOW_UP, 1*SPRITE_BLOW_UP 
                    DB       0*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP 
                    DB       -4*SPRITE_BLOW_UP, 1*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP 
frog1b_in_home_object: 
                    DB       0                            ; speed + direction 
                    DW       frog1b_in_home_sprite        ; graphic definition 
                    DB       0                            ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       frog1c_in_home_object        ; pointer to next anim object 
                    DB       -4                           ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       4                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       $60                          ; brightness 
                    DB       0                            ; special flag 
frog1c_in_home_sprite: 
                    DW       (MAX_LINE_NUM_16-($7+1))*ONE_LINE_LENGTH 
                    DB       -3*SPRITE_BLOW_UP, 2*SPRITE_BLOW_UP 
                    DB       0*SPRITE_BLOW_UP, 3*SPRITE_BLOW_UP 
                    DB       3*SPRITE_BLOW_UP, 2*SPRITE_BLOW_UP 
                    DB       -1*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP 
                    DB       4*SPRITE_BLOW_UP, 2*SPRITE_BLOW_UP 
                    DB       0*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP 
                    DB       -4*SPRITE_BLOW_UP, 0*SPRITE_BLOW_UP 
                    DB       1*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP 
frog1c_in_home_object: 
                    DB       0                            ; speed + direction 
                    DW       frog1c_in_home_sprite        ; graphic definition 
                    DB       0                            ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       frog1d_in_home_object        ; pointer to next anim object 
                    DB       -4                           ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       4                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       $60                          ; brightness 
                    DB       0                            ; special flag 
frog1d_in_home_object: 
                    DB       0                            ; speed + direction 
                    DW       frog1b_in_home_sprite        ; graphic definition 
                    DB       0                            ; length in SCALE_FACTOR_GAME 
                    DB       3                            ; anim delay value 
                    DW       frog1a_in_home_object        ; pointer to next anim object 
                    DB       -4                           ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       4                            ; offsets x in 'SCALE_FACTOR_GAME' 
                    DB       $60                          ; brightness 
                    DB       0                            ; special flag 
froggerGirl_right_0: 
                    DW       (MAX_LINE_NUM-($0f+1))*ONE_LINE_LENGTH 
                    DB       +$02*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$04*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, +$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
froggerGirl_right_1: 
                    DW       (MAX_LINE_NUM-($0f+1))*ONE_LINE_LENGTH 
                    DB       +$02*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$03*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$04*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$03*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
froggerGirl_right_2: 
                    DW       (MAX_LINE_NUM-($0f+1))*ONE_LINE_LENGTH 
                    DB       +$02*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$04*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
froggerGirl_right_3: 
                    DW       (MAX_LINE_NUM-($0f+1))*ONE_LINE_LENGTH 
                    DB       +$02*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$04*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
froggerGirl_right_4: 
                    DW       (MAX_LINE_NUM-($0f+1))*ONE_LINE_LENGTH 
                    DB       +$04*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$04*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, +$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
froggerGirl_left_0: 
                    DW       (MAX_LINE_NUM-($0f+1))*ONE_LINE_LENGTH 
                    DB       +$04*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, +$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, +$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
froggerGirl_left_1: 
                    DW       (MAX_LINE_NUM-($0f+1))*ONE_LINE_LENGTH 
                    DB       +$04*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$03*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$03*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, +$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
froggerGirl_left_2: 
                    DW       (MAX_LINE_NUM-($0f+1))*ONE_LINE_LENGTH 
                    DB       +$04*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
froggerGirl_left_3: 
                    DW       (MAX_LINE_NUM-($0f+1))*ONE_LINE_LENGTH 
                    DB       +$04*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
froggerGirl_left_4: 
                    DW       (MAX_LINE_NUM-($0f+1))*ONE_LINE_LENGTH 
                    DB       +$04*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, +$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$04*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, +$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
girl1a_object: 
                    DB       0                            ; speed + direction 
                    DW       froggerGirl_right_0          ; graphic definition 
                    DB       10                           ; length in SCALE_FACTOR_GAME 
                    DB       GIRL_SPRING_TIMER            ; anim delay value 
                    DW       girl1a1_object               ; pointer to next anim object 
                    DB       -2                           ; offsets y in 'SCALE_IN_HOME', since this is a home object 
                    DB       -25 +GIRL_X_OFFSET           ; offsets x in 'SCALE_IN_HOME', since this is a home object 
                    DB       $7f                          ; brightness 
                    DB       SPECIAL_GIRL_RIGHT           ; special flag 
girl1a1_object: 
                    DB       0                            ; speed + direction 
                    DW       froggerGirl_right_1          ; graphic definition 
                    DB       10                           ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       girl1a2_object               ; pointer to next anim object 
                    DB       -2                           ; offsets y in 'SCALE_IN_HOME', since this is a home object 
                    DB       -20 +GIRL_X_OFFSET           ; offsets x in 'SCALE_IN_HOME', since this is a home object 
                    DB       $7f                          ; brightness 
                    DB       SPECIAL_GIRL_RIGHT           ; special flag 
girl1a2_object: 
                    DB       0                            ; speed + direction 
                    DW       froggerGirl_right_2          ; graphic definition 
                    DB       10                           ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       girl1a3_object               ; pointer to next anim object 
                    DB       -2                           ; offsets y in 'SCALE_IN_HOME', since this is a home object 
                    DB       -18 +GIRL_X_OFFSET           ; offsets x in 'SCALE_IN_HOME', since this is a home object 
                    DB       $7f                          ; brightness 
                    DB       SPECIAL_GIRL_RIGHT           ; special flag 
girl1a3_object: 
                    DB       0                            ; speed + direction 
                    DW       froggerGirl_right_3          ; graphic definition 
                    DB       10                           ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       girl1a4_object               ; pointer to next anim object 
                    DB       -2                           ; offsets y in 'SCALE_IN_HOME', since this is a home object 
                    DB       -15 +GIRL_X_OFFSET           ; offsets x in 'SCALE_IN_HOME', since this is a home object 
                    DB       $7f                          ; brightness 
                    DB       SPECIAL_GIRL_RIGHT           ; special flag 
girl1a4_object: 
                    DB       0                            ; speed + direction 
                    DW       froggerGirl_right_4          ; graphic definition 
                    DB       10                           ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       girl1b_object                ; pointer to next anim object 
                    DB       -2                           ; offsets y in 'SCALE_IN_HOME', since this is a home object 
                    DB       -12 +GIRL_X_OFFSET           ; offsets x in 'SCALE_IN_HOME', since this is a home object 
                    DB       $7f                          ; brightness 
                    DB       SPECIAL_GIRL_RIGHT           ; special flag 
girl1b_object: 
                    DB       0                            ; speed + direction 
                    DW       froggerGirl_left_0           ; graphic definition 
                    DB       10                           ; length in SCALE_FACTOR_GAME 
                    DB       GIRL_SPRING_TIMER            ; anim delay value 
                    DW       girl1b1_object               ; pointer to next anim object 
                    DB       -3                           ; offsets y in 'SCALE_IN_HOME', since this is a home object 
                    DB       -10 +GIRL_X_OFFSET           ; offsets x in 'SCALE_IN_HOME', since this is a home object 
                    DB       $7f                          ; brightness 
                    DB       SPECIAL_GIRL_LEFT            ; special flag 
girl1b1_object: 
                    DB       0                            ; speed + direction 
                    DW       froggerGirl_left_1           ; graphic definition 
                    DB       10                           ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       girl1b2_object               ; pointer to next anim object 
                    DB       -3                           ; offsets y in 'SCALE_IN_HOME', since this is a home object 
                    DB       -12 +GIRL_X_OFFSET           ; offsets x in 'SCALE_IN_HOME', since this is a home object 
                    DB       $7f                          ; brightness 
                    DB       SPECIAL_GIRL_LEFT            ; special flag 
girl1b2_object: 
                    DB       0                            ; speed + direction 
                    DW       froggerGirl_left_2           ; graphic definition 
                    DB       10                           ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       girl1b3_object               ; pointer to next anim object 
                    DB       -3                           ; offsets y in 'SCALE_IN_HOME', since this is a home object 
                    DB       -15 +GIRL_X_OFFSET           ; offsets x in 'SCALE_IN_HOME', since this is a home object 
                    DB       $7f                          ; brightness 
                    DB       SPECIAL_GIRL_LEFT            ; special flag 
girl1b3_object: 
                    DB       0                            ; speed + direction 
                    DW       froggerGirl_left_3           ; graphic definition 
                    DB       10                           ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       girl1b4_object               ; pointer to next anim object 
                    DB       -3                           ; offsets y in 'SCALE_IN_HOME', since this is a home object 
                    DB       -18 +GIRL_X_OFFSET           ; offsets x in 'SCALE_IN_HOME', since this is a home object 
                    DB       $7f                          ; brightness 
                    DB       SPECIAL_GIRL_LEFT            ; special flag 
girl1b4_object: 
                    DB       0                            ; speed + direction 
                    DW       froggerGirl_left_4           ; graphic definition 
                    DB       10                           ; length in SCALE_FACTOR_GAME 
                    DB       5                            ; anim delay value 
                    DW       girl1a_object                ; pointer to next anim object 
                    DB       -3                           ; offsets y in 'SCALE_IN_HOME', since this is a home object 
                    DB       -20 +GIRL_X_OFFSET           ; offsets x in 'SCALE_IN_HOME', since this is a home object 
                    DB       $7f                          ; brightness 
                    DB       SPECIAL_GIRL_LEFT            ; special flag 
DEATH_DELAY         EQU      4 
DEATH_Y             EQU      0 
DEATH_X             EQU      0 
frogDeathObject_0: 
                    DW       FroggerDeathSprite_0         ; graphic definition 
                    DB       DEATH_DELAY                  ; anim delay value 
                    DW       frogDeathObject_1            ; pointer to next anim object 
                    DB       DEATH_Y                      ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       DEATH_X                      ; offsets x in 'SCALE_FACTOR_GAME' 
frogDeathObject_1: 
                    DW       FroggerDeathSprite_1         ; graphic definition 
                    DB       DEATH_DELAY                  ; anim delay value 
                    DW       frogDeathObject_2            ; pointer to next anim object 
                    DB       DEATH_Y -1*2                 ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       DEATH_X +1*2                 ; offsets x in 'SCALE_FACTOR_GAME' 
frogDeathObject_2: 
                    DW       FroggerDeathSprite_2         ; graphic definition 
                    DB       DEATH_DELAY                  ; anim delay value 
                    DW       frogDeathObject_3            ; pointer to next anim object 
                    DB       DEATH_Y -0*2                 ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       DEATH_X +1*2                 ; offsets x in 'SCALE_FACTOR_GAME' 
frogDeathObject_3: 
                    DW       FroggerDeathSprite_3         ; graphic definition 
                    DB       DEATH_DELAY                  ; anim delay value 
                    DW       frogDeathObject_4            ; pointer to next anim object 
                    DB       DEATH_Y -1*2                 ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       DEATH_X +2*2                 ; offsets x in 'SCALE_FACTOR_GAME' 
frogDeathObject_4: 
                    DW       FroggerDeathSprite_4         ; graphic definition 
                    DB       DEATH_DELAY                  ; anim delay value 
                    DW       frogDeathObject_5            ; pointer to next anim object 
                    DB       DEATH_Y -3*2                 ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       DEATH_X +1*2                 ; offsets x in 'SCALE_FACTOR_GAME' 
frogDeathObject_5: 
                    DW       FroggerDeathSprite_5         ; graphic definition 
                    DB       DEATH_DELAY                  ; anim delay value 
                    DW       frogDeathObject_6            ; pointer to next anim object 
                    DB       DEATH_Y -3*2                 ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       DEATH_X +2*2                 ; offsets x in 'SCALE_FACTOR_GAME' 
NEW_D_OFFSET_Y equ (-(2*9))
NEW_D_OFFSET_X equ (+(2*1))
frogDeathObject_6: 
                    DW       FroggerDeathSprite_6         ; graphic definition 
                    DB       DEATH_DELAY                  ; anim delay value 
                    DW       frogDeathObject_7            ; pointer to next anim object 
                    DB       DEATH_Y -3*2                 ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       DEATH_X +1*2                 ; offsets x in 'SCALE_FACTOR_GAME' 
frogDeathObject_7: 
                    DW       FroggerDeathSprite_7         ; graphic definition 
                    DB       DEATH_DELAY                  ; anim delay value 
                    DW       frogDeathObject_8            ; pointer to next anim object 
                    DB       DEATH_Y -0*2 +NEW_D_OFFSET_Y +10                ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       DEATH_X +1*2 +NEW_D_OFFSET_X                ; offsets x in 'SCALE_FACTOR_GAME' 
frogDeathObject_8: 
                    DW       FroggerDeathSprite_8         ; graphic definition 
                    DB       DEATH_DELAY                  ; anim delay value 
                    DW       frogDeathObject_9            ; pointer to next anim object 
                    DB       DEATH_Y +1*2  +NEW_D_OFFSET_Y  +7              ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       DEATH_X +1*2  +NEW_D_OFFSET_X               ; offsets x in 'SCALE_FACTOR_GAME' 
frogDeathObject_9: 
                    DW       FroggerDeathSprite_9         ; graphic definition 
                    DB       DEATH_DELAY                  ; anim delay value 
                    DW       frogDeathObject_10           ; pointer to next anim object 
                    DB       DEATH_Y +2*2   +NEW_D_OFFSET_Y   +2            ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       DEATH_X +1*2   +NEW_D_OFFSET_X              ; offsets x in 'SCALE_FACTOR_GAME' 
frogDeathObject_10: 
                    DW       FroggerDeathSprite_10        ; graphic definition 
                    DB       DEATH_DELAY                  ; anim delay value 
                    DW       frogDeathObject_11           ; pointer to next anim object 
                    DB       DEATH_Y +3*2   +NEW_D_OFFSET_Y               ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       DEATH_X +1*2   +NEW_D_OFFSET_X              ; offsets x in 'SCALE_FACTOR_GAME' 
frogDeathObject_11: 
                    DW       FroggerDeathSprite_10        ; graphic definition 
                    DB       DEATH_DELAY                  ; anim delay value 
                    DW       frogDeathObject_12           ; pointer to next anim object 
                    DB       DEATH_Y +4*2   +NEW_D_OFFSET_Y               ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       DEATH_X +1*2   +NEW_D_OFFSET_X              ; offsets x in 'SCALE_FACTOR_GAME' 
frogDeathObject_12: 
                    DW       FroggerDeathSprite_10        ; graphic definition 
                    DB       DEATH_DELAY                  ; anim delay value 
                    DW       frogDeathObject_13           ; pointer to next anim object 
                    DB       DEATH_Y +5*2   +NEW_D_OFFSET_Y               ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       DEATH_X +1*2   +NEW_D_OFFSET_X              ; offsets x in 'SCALE_FACTOR_GAME' 
frogDeathObject_13: 
                    DW       FroggerDeathSprite_10        ; graphic definition 
                    DB       DEATH_DELAY                  ; anim delay value 
                    DW       frogDeathObject_14           ; pointer to next anim object 
                    DB       DEATH_Y +6*2   +NEW_D_OFFSET_Y               ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       DEATH_X +1*2   +NEW_D_OFFSET_X              ; offsets x in 'SCALE_FACTOR_GAME' 
frogDeathObject_14: 
                    DW       FroggerDeathSprite_10        ; graphic definition 
                    DB       DEATH_DELAY                  ; anim delay value 
                    DW       frogDeathObject_15           ; pointer to next anim object 
                    DB       DEATH_Y +6*2   +NEW_D_OFFSET_Y               ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       DEATH_X +2*2   +NEW_D_OFFSET_X              ; offsets x in 'SCALE_FACTOR_GAME' 
frogDeathObject_15: 
                    DW       FroggerDeathSprite_10        ; graphic definition 
                    DB       DEATH_DELAY                  ; anim delay value 
                    DW       frogDeathObject_16           ; pointer to next anim object 
                    DB       DEATH_Y +5*2  +NEW_D_OFFSET_Y                ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       DEATH_X +2*2  +NEW_D_OFFSET_X               ; offsets x in 'SCALE_FACTOR_GAME' 
frogDeathObject_16: 
                    DW       FroggerDeathSprite_10        ; graphic definition 
                    DB       DEATH_DELAY                  ; anim delay value 
                    DW       frogDeathObject_17           ; pointer to next anim object 
                    DB       DEATH_Y +4*2   +NEW_D_OFFSET_Y               ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       DEATH_X +1*2   +NEW_D_OFFSET_X              ; offsets x in 'SCALE_FACTOR_GAME' 
frogDeathObject_17: 
                    DW       FroggerDeathSprite_10        ; graphic definition 
                    DB       DEATH_DELAY                  ; anim delay value 
                    DW       frogDeathObject_17           ; pointer to next anim object 
                    DB       DEATH_Y +5*2    +NEW_D_OFFSET_Y              ; offsets y in 'SCALE_FACTOR_GAME' 
                    DB       DEATH_X +0*2    +NEW_D_OFFSET_X             ; offsets x in 'SCALE_FACTOR_GAME' 
FroggerDeathSprite_0: 
                    DW       (MAX_LINE_NUM-($12+1))*ONE_LINE_LENGTH 
                    DB       +$02*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$05*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$05*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$03*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$03*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$05*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$05*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
FroggerDeathSprite_1: 
                    DW       (MAX_LINE_NUM-($12+1))*ONE_LINE_LENGTH 
                    DB       +$02*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$04*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$03*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$03*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$04*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
FroggerDeathSprite_2: 
                    DW       (MAX_LINE_NUM-($d+1))*ONE_LINE_LENGTH 
                    DB       +$00*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$00*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
FroggerDeathSprite_3: 
                    DW       (MAX_LINE_NUM-($8+1))*ONE_LINE_LENGTH 
                    DB       +$00*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
FroggerDeathSprite_4: 
                    DW       (MAX_LINE_NUM-($3+1))*ONE_LINE_LENGTH 
                    DB       +$02*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
FroggerDeathSprite_5: 
                    DW       (MAX_LINE_NUM-($3+1))*ONE_LINE_LENGTH 
                    DB       +$01*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$01*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$01*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS   ; draw to y, x 
FroggerDeathSprite_6: 
                    DW       (MAX_LINE_NUM-($3+1))*ONE_LINE_LENGTH 
                    DB       +$02*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       -$02*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
                    DB       +$02*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS   ; draw to y, x 
FroggerDeathSprite_7: 
                    DW       (MAX_LINE_NUM-($12+1))*ONE_LINE_LENGTH 
 DB +$00*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS ; draw to y, x
 DB +$01*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS ; draw to y, x
 DB +$02*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS ; draw to y, x
 DB +$03*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS ; draw to y, x
 DB +$00*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS ; draw to y, x
 DB -$03*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS ; draw to y, x
 DB -$02*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS ; draw to y, x
 DB -$01*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS ; draw to y, x
 DB +$00*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS ; draw to y, x
 DB +$02*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS ; draw to y, x
 DB +$00*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS ; draw to y, x
 DB +$02*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS ; draw to y, x
 DB -$01*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS ; draw to y, x
 DB +$01*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS ; draw to y, x
 DB +$00*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS ; draw to y, x
 DB +$00*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS ; draw to y, x
 DB -$01*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS ; draw to y, x
 DB +$01*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS ; draw to y, x
 DB -$02*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS ; draw to y, x
FroggerDeathSprite_8: 
                    DW       (MAX_LINE_NUM-($12+1))*ONE_LINE_LENGTH 
 DB +$00*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS ; draw to y, x
 DB +$02*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS ; draw to y, x
 DB +$03*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS ; draw to y, x
 DB +$03*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS ; draw to y, x
 DB +$00*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS ; draw to y, x
 DB -$03*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS ; draw to y, x
 DB -$03*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS ; draw to y, x
 DB -$02*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS ; draw to y, x
 DB +$00*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS ; draw to y, x
 DB +$03*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS ; draw to y, x
 DB +$00*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS ; draw to y, x
 DB +$02*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS ; draw to y, x
 DB -$01*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS ; draw to y, x
 DB +$01*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS ; draw to y, x
 DB +$00*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS ; draw to y, x
 DB +$00*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS ; draw to y, x
 DB -$01*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS ; draw to y, x
 DB +$01*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS ; draw to y, x
 DB -$02*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS ; draw to y, x
FroggerDeathSprite_9: 
                    DW       (MAX_LINE_NUM-($13+1))*ONE_LINE_LENGTH 
 DB +$00*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS ; draw to y, x
 DB +$03*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS ; draw to y, x
 DB +$03*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS ; draw to y, x
 DB +$04*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS ; draw to y, x
 DB +$01*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS ; draw to y, x
 DB -$01*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS ; draw to y, x
 DB -$04*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS ; draw to y, x
 DB -$03*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS ; draw to y, x
 DB -$03*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS ; draw to y, x
 DB +$00*BLOW_UP_VLISTS, -$01*BLOW_UP_VLISTS ; draw to y, x
 DB +$04*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS ; draw to y, x
 DB +$00*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS ; draw to y, x
 DB +$03*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS ; draw to y, x
 DB -$01*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS ; draw to y, x
 DB +$01*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS ; draw to y, x
 DB +$00*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS ; draw to y, x
 DB +$00*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS ; draw to y, x
 DB -$01*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS ; draw to y, x
 DB +$01*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS ; draw to y, x
 DB -$03*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS ; draw to y, x
FroggerDeathSprite_10: 
                    DW       (MAX_LINE_NUM-($13+1))*ONE_LINE_LENGTH 
 DB +$00*BLOW_UP_VLISTS, -$04*BLOW_UP_VLISTS ; draw to y, x
 DB +$03*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS ; draw to y, x
 DB +$03*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS ; draw to y, x
 DB +$05*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS ; draw to y, x
 DB +$01*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS ; draw to y, x
 DB -$01*BLOW_UP_VLISTS, +$04*BLOW_UP_VLISTS ; draw to y, x
 DB -$05*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS ; draw to y, x
 DB -$03*BLOW_UP_VLISTS, -$03*BLOW_UP_VLISTS ; draw to y, x
 DB -$03*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS ; draw to y, x
 DB +$00*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS ; draw to y, x
 DB +$03*BLOW_UP_VLISTS, +$00*BLOW_UP_VLISTS ; draw to y, x
 DB +$00*BLOW_UP_VLISTS, -$02*BLOW_UP_VLISTS ; draw to y, x
 DB +$04*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS ; draw to y, x
 DB -$02*BLOW_UP_VLISTS, +$03*BLOW_UP_VLISTS ; draw to y, x
 DB +$02*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS ; draw to y, x
 DB +$00*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS ; draw to y, x
 DB +$00*BLOW_UP_VLISTS, -$05*BLOW_UP_VLISTS ; draw to y, x
 DB -$02*BLOW_UP_VLISTS, +$02*BLOW_UP_VLISTS ; draw to y, x
 DB +$02*BLOW_UP_VLISTS, +$03*BLOW_UP_VLISTS ; draw to y, x
 DB -$04*BLOW_UP_VLISTS, +$01*BLOW_UP_VLISTS ; draw to y, x
