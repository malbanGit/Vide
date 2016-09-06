;***************************************************************************
; SCALE_FACTOR_SPRITE 6
; destroys Vec_Misc_Count ($C823)
; optimized vector list draw makro
; for scale of 6 only!!!
; we even don't wait for the timer
; note: after completetion you must
; do a           STA     VIA_shift_reg
; after about 3 cycles!
; otherwise the beam is not switched off
; reg A contains 0
; saves 1 (STA VIA_shift_reg) over _S makro, with 30 sprites that are 120 cycles!

; idea, not imlemented, to save another 10 cycles per line!
; do the maximum of lines per vector list entries hardcoded
; than jump in the beginning to the required length of vectors to be drawn
;
;                 DEC     $C823           ; 7
;                 BMI     _DRAW_END\?     ; 3 Go back for more points
;
; these instructions will not be needed anymore!
; we can than go straight from one line to the next, doing that in the
; sprite routine will save nearly 10 cycles per vector per sprite!!!
; another 3000-4000 cycles!!!

ONE_LINE_DRAW macro                        ; cycles
                 INC     VIA_port_b        ; [6] Disable mux
                 STB     VIA_port_a        ; [6] Send X to A/D
                 DEC     VIA_shift_reg     ; [6] Put pattern in shift register
                 CLR     VIA_t1_cnt_hi     ; [4] enable timer 1
                 LDD     ,X++              ; [8] load Y coordinate to A, X coordinate to B
                 STA     VIA_port_a        ; [4] Send Y to A/D
                 CLR     VIA_port_b        ; [4] enable mux, thus y integrators are set to Y
                 CLR     VIA_shift_reg     ; [4] turn the lights off
              endm

MAX_LINE_NUM EQU 23
ONE_LINE_LENGTH EQU 16
LENGTH_OF_HEADER EQU (4+2+2+2)
MY_SPRITE_DRAW_VLC_UNLOOP        macro
                LDD     ,X++              ;(2)
                STA     VIA_port_a        ;(2) [4] Send Y to A/D
                CLR     VIA_port_b        ;(2) [4] enable mux, thus y integrators are set to Y
                JMP     [i_jump]          ;(4)
JUMP_INTO_ALL\?:
JUMP_INTO_23\?:
             ONE_LINE_DRAW
JUMP_INTO_22\?:
             ONE_LINE_DRAW
JUMP_INTO_21\?:
             ONE_LINE_DRAW
JUMP_INTO_20\?:
             ONE_LINE_DRAW
JUMP_INTO_19\?:
             ONE_LINE_DRAW
JUMP_INTO_18\?:
             ONE_LINE_DRAW
JUMP_INTO_17\?:
             ONE_LINE_DRAW
JUMP_INTO_16\?:
             ONE_LINE_DRAW
JUMP_INTO_15\?:
             ONE_LINE_DRAW
JUMP_INTO_14\?:
             ONE_LINE_DRAW
JUMP_INTO_13\?:
             ONE_LINE_DRAW
JUMP_INTO_12\?:
             ONE_LINE_DRAW
JUMP_INTO_11\?:
             ONE_LINE_DRAW
JUMP_INTO_10\?:
             ONE_LINE_DRAW
JUMP_INTO_09\?:
             ONE_LINE_DRAW
JUMP_INTO_08\?:
             ONE_LINE_DRAW
JUMP_INTO_07\?:
             ONE_LINE_DRAW
JUMP_INTO_06\?:
             ONE_LINE_DRAW
JUMP_INTO_05\?:
             ONE_LINE_DRAW
JUMP_INTO_04\?:
             ONE_LINE_DRAW
JUMP_INTO_03\?:
             ONE_LINE_DRAW
JUMP_INTO_02\?:
             ONE_LINE_DRAW
JUMP_INTO_01\?:
                 INC     VIA_port_b        ; [6] Disable mux
                 STB     VIA_port_a        ; [6] Send X to A/D
                 DEC     VIA_shift_reg     ; [6] Put pattern in shift register
                 CLR     VIA_t1_cnt_hi     ; [4] enable timer 1
                 NOP
                 NOP
                 NOP
                 endm
;***************************************************************************
MY_SPRITE_DRAW_VLC_UNLOOP_SMALL        macro
                LDD     ,X++              ;(2)
                STA     VIA_port_a        ;(2) [4] Send Y to A/D
                CLR     VIA_port_b        ;(2) [4] enable mux, thus y integrators are set to Y
                JMP     [i_jump]          ;(4)
JUMP_INTO_ALL\?:
JUMP_INTO_11\?:
             ONE_LINE_DRAW
JUMP_INTO_10\?:
             ONE_LINE_DRAW
JUMP_INTO_09\?:
             ONE_LINE_DRAW
JUMP_INTO_08\?:
             ONE_LINE_DRAW
JUMP_INTO_07\?:
             ONE_LINE_DRAW
JUMP_INTO_06\?:
             ONE_LINE_DRAW
JUMP_INTO_05\?:
             ONE_LINE_DRAW
JUMP_INTO_04\?:
             ONE_LINE_DRAW
JUMP_INTO_03\?:
             ONE_LINE_DRAW
JUMP_INTO_02\?:
             ONE_LINE_DRAW
JUMP_INTO_01\?:
                 INC     VIA_port_b        ; [6] Disable mux
                 STB     VIA_port_a        ; [6] Send X to A/D
                 DEC     VIA_shift_reg     ; [6] Put pattern in shift register
                 CLR     VIA_t1_cnt_hi     ; [4] enable timer 1
                 NOP
                 NOP
                 NOP
                 endm
;***************************************************************************

MY_SPRITE_DRAW_VLC        macro
                 LDD     ,X++            ;
                 STA     $C823           ;
                 CLRA
                 STB     <VIA_port_a     ;Send Y to A/D
                 STA     <VIA_port_b
                 LDB     ,X+
                 INC     <VIA_port_b     ;Disable mux
                 STB     <VIA_port_a     ;Send X to A/D
                 DEC     <VIA_shift_reg  ;Put pattern in shift register
                 STA     <VIA_t1_cnt_hi  ;enable timer 1
                 LDB     ,X+             ; 6
                 DEC     $C823           ; 7
                 BMI     _DRAW_END\?     ; 3 Go back for more points
_DRAW_VLA\?:
                 STB     <VIA_port_a     ;Send Y to A/D
                 STA     <VIA_shift_reg
                 STA     <VIA_port_b
                 LDB     ,X+
                 INC     <VIA_port_b     ;Disable mux
                 STB     <VIA_port_a     ;Send X to A/D
                 DEC     <VIA_shift_reg  ;Put pattern in shift register
                 STA     <VIA_t1_cnt_hi  ;enable timer 1
                 LDB     ,X+             ; 6
                 DEC     $C823           ; 7
                 BPL     _DRAW_VLA\?     ; 3 Go back for more points
_DRAW_END\?:
;                 NOP                     ; 2
;                 STA     <VIA_shift_reg
                 endm

;***************************************************************************
; note: after completetion you must
; do a           STA     VIA_shift_reg
; after about 3 cycles!
; otherwise the beam is not switched off
; reg A contains 0
MY_SPRITE_DRAW_VLC_S      macro
                 LDD     ,X++            ;
                 STA     $C823           ;
                 CLRA
_DRAW_VLA\?:
                 STB     <VIA_port_a     ;Send Y to A/D
                 STA     <VIA_shift_reg
                 STA     <VIA_port_b
                 LDB     ,X+
                 INC     <VIA_port_b     ;Disable mux
                 STB     <VIA_port_a     ;Send X to A/D
                 DEC     <VIA_shift_reg  ;Put pattern in shift register
                 STA     <VIA_t1_cnt_hi  ;enable timer 1
                 LDB     ,X+             ; 6
                 DEC     $C823           ; 7
                 BPL     _DRAW_VLA\?     ; 3
                 endm

