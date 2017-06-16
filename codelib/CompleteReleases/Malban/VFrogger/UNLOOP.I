;ONE_LINE_DRAW macro                        ; cycles
;                 INC     VIA_port_b        ; [6] Disable mux
;                 STB     VIA_port_a        ; [6] Send X to A/D
;                 DEC     VIA_shift_reg     ; [6] Put pattern in shift register
;                 CLR     VIA_t1_cnt_hi     ; [4] enable timer 1
;                 LDD     ,X++              ; [8] load Y coordinate to A, X coordinate to B
;                 STA     VIA_port_a        ; [4] Send Y to A/D
;                 CLR     VIA_port_b        ; [4] enable mux, thus y integrators are set to Y
;                 CLR     VIA_shift_reg     ; [4] turn the lights off
;              endm
;
;MAX_LINE_NUM EQU 23
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
ONE_LINE_DRAW       macro                                 ; cycles 
line_start: 
                    inca     
                    sta      <VIA_port_b 
                    STB      <VIA_port_a                  ; [6] Send X to A/D 
                    tst      <VIA_shift_reg               ; this is only atrigger, but lda is faster than tst 
                    CLR      <VIA_t1_cnt_hi               ; [4] enable timer 1 
                    LDD      ,X++                         ; [8] load Y coordinate to A, X coordinate to B 
                    STA      <VIA_port_a                  ; [4] Send Y to A/D 
; dec VIA_port_b
                    clr      <VIA_port_b 
line_end: 
                    endm     
HEADER_ADDEE        equ      (0) 
MAX_LINE_NUM        EQU      24 
ONE_LINE_LENGTH     EQU      (line_end-line_start)        ; 16 
MY_SPRITE_DRAW_VLC_UNLOOP  macro  
 jsr fixDraw
 lbra looDone\?
header_start 
                    LDD      ,X++                         ;(2) 
                    STA      <VIA_port_a                  ;(2) [4] Send Y to A/D 
                    clra     
                    sta      <VIA_port_b 
                    inca     
                    sta      <VIA_port_b 
                    STB      <VIA_port_a                  ; [6] Send X to A/D 
                    sta      <VIA_shift_reg 
                    CLR      <VIA_t1_cnt_hi               ; [4] enable timer 1 
                    LDD      ,X++                         ; [8] load Y coordinate to A, X coordinate to B 
                    STA      <VIA_port_a                  ; [4] Send Y to A/D 
                    clra     
                    sta      <VIA_port_b 
                    JMP      [i_jump]                     ;(4) 

header_end 
LENGTH_OF_HEADER    EQU      (header_end-header_start) 
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
                    inca     
                    sta      <VIA_port_b 
                    STB      <VIA_port_a                  ; [6] Send X to A/D 
                    lda      <VIA_shift_reg               ; this is only atrigger 
                    CLR      <VIA_t1_cnt_hi               ; [4] enable timer 1 
                    NOP      7 
                    clra     
                    sta      <VIA_shift_reg               ; [4] turn the lights off 
looDone\?
                    endm     
;***************************************************************************
MY_SPRITE_DRAW_VLC_UNLOOP_SMALL  macro  
header_start 
                    LDD      ,X++                         ;(2) 
                    STA      <VIA_port_a                  ;(2) [4] Send Y to A/D 
                    clra     
                    sta      <VIA_port_b 
                    inca     
                    sta      <VIA_port_b 
                    STB      <VIA_port_a                  ; [6] Send X to A/D 
                    sta      <VIA_shift_reg 
                    CLR      <VIA_t1_cnt_hi               ; [4] enable timer 1 
                    LDD      ,X++                         ; [8] load Y coordinate to A, X coordinate to B 
                    STA      <VIA_port_a                  ; [4] Send Y to A/D 
                    clra     
                    sta      <VIA_port_b 
                    JMP      [i_jump]                     ;(4) 

header_end 
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
                    inca     
                    sta      <VIA_port_b 
                    STB      <VIA_port_a                  ; [6] Send X to A/D 
                    lda      <VIA_shift_reg               ; this is only atrigger 
                    CLR      <VIA_t1_cnt_hi               ; [4] enable timer 1 
                    NOP      7 
                    clra     
                    sta      <VIA_shift_reg               ; [4] turn the lights off 
                    endm     
;***************************************************************************
MY_SPRITE_DRAW_VLC  macro    
                    LDD      ,X++                         ; 
                    STA      $C823                        ; 
                    CLRA     
                    STB      <VIA_port_a                  ;Send Y to A/D 
                    STA      <VIA_port_b 
                    LDB      ,X+ 
                    INC      <VIA_port_b                  ;Disable mux 
                    STB      <VIA_port_a                  ;Send X to A/D 
                    DEC      <VIA_shift_reg               ;Put pattern in shift register 
                    STA      <VIA_t1_cnt_hi               ;enable timer 1 
                    LDB      ,X+                          ; 6 
                    DEC      $C823                        ; 7 
                    BMI      _DRAW_END\?                  ; 3 Go back for more points 
_DRAW_VLA\?: 
                    STB      <VIA_port_a                  ;Send Y to A/D 
                    STA      <VIA_shift_reg 
                    STA      <VIA_port_b 
                    LDB      ,X+ 
                    INC      <VIA_port_b                  ;Disable mux 
                    STB      <VIA_port_a                  ;Send X to A/D 
                    DEC      <VIA_shift_reg               ;Put pattern in shift register 
                    STA      <VIA_t1_cnt_hi               ;enable timer 1 
                    LDB      ,X+                          ; 6 
                    DEC      $C823                        ; 7 
                    BPL      _DRAW_VLA\?                  ; 3 Go back for more points 
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
MY_SPRITE_DRAW_VLC_S  macro  
                    LDD      ,X++                         ; 
                    STA      $C823                        ; 
                    CLRA     
_DRAW_VLA\?: 
                    STB      <VIA_port_a                  ;Send Y to A/D 
                    STA      <VIA_shift_reg 
                    STA      <VIA_port_b 
                    LDB      ,X+ 
                    INC      <VIA_port_b                  ;Disable mux 
                    STB      <VIA_port_a                  ;Send X to A/D 
                    DEC      <VIA_shift_reg               ;Put pattern in shift register 
                    STA      <VIA_t1_cnt_hi               ;enable timer 1 
                    LDB      ,X+                          ; 6 
                    DEC      $C823                        ; 7 
                    BPL      _DRAW_VLA\?                  ; 3 
                    endm     

