; this file is part of Karl Quappe, written by Malban
; in 2016
; all stuff contained here is public domain
;
;
; size similar to: SCALE_FACTOR_SPRITE 6
; "similar" since the drawing below does not use a shift register,
; so the timings are slightly different
; these routines are manualy tested using different vectrex systems
; they seem to defy cycle counting but work on the real machines rather well
; Emulators don' like it (Vide is ok'ish)
; ParaJVE: displayes only dashed
; Mess doesn't display anything
;
; one "inner line" of the vectorlist drawing routine
;***************************************************************************
ONE_LINE_DRAW       macro                                 ; cycles 
line_start: ;#noDoubleWarn 
                    STB      <VIA_port_a                  ; [6] Send X to A/D 
                    ldb      #$ee 
                    CLR      <VIA_t1_cnt_hi               ; [4] enable timer 1 
; light on
                    stb      <VIA_cntl                    ; [4] ZERO disabled, and BLANK disabled 
; pulu d ;[7] ; saves one cycle, which is nice -> about 350 cycles in the game, but the vectors are not connected anymore
                    ldd      ,u++                         ; [8] load Y coordinate to A, X coordinate to B 
                    STA      <VIA_port_a                  ; [4] Send Y to A/D 
                    clr      <VIA_port_b                  ; [6] 
 
                    lda      #$ce                         ; [2] 
; light off
                    sta      <VIA_cntl                    ; [4] ZERO disabled, and BLANK enabled 
                    INC      <VIA_port_b                  ; [6] Disable mux 
line_end: ;#noDoubleWarn 
                    endm     
;***************************************************************************
; 
; repetition of the above macro
; 27 times below
; this is a "counter" to calculate where to jump into the the unlooping!
MAX_LINE_NUM        EQU      25 
;
; length of one of the vector drawing lines in ASM
; definition must come after the above, otherwise calculation would be false
ONE_LINE_LENGTH     EQU      (line_end-line_start)        ; 
;
;
; the callable unloop" macro
; must be followed after 22 cycles with a 
;         ldb      #$ce 
;         STB     <VIA_cntl         ;/BLANK low and /ZERO low
;
; for example look at the subroutine: "move_wait_draw_vlc_unloop" in the main file
; "y" must be set beforehand to the jump "table"
MY_SPRITE_DRAW_VLC_UNLOOP  macro  
header_start ;#noDoubleWarn 

; (x) length in bytes
; [x] duration in cycles
; do one "manual" starter line in advance
                    pulu     d                            ; get current coordinates 
                    STA      <VIA_port_a                  ;(2) [4] Send Y to A/D 
                    CLR      <VIA_port_b                  ;(2) [4] enable mux, thus y integrators are set to Y 
                    INC      <VIA_port_b                  ;[6] Disable mux 
                    ONE_LINE_DRAW  
                    jmp      ,y 

header_end ;#noDoubleWarn 
; definition must come after the above, otherwise calculation would be false
LENGTH_OF_HEADER    EQU      (header_end-header_start) 
JUMP_INTO_ALL\?: 
;JUMP_INTO_26\?: 
;                    ONE_LINE_DRAW  
;JUMP_INTO_25\?: 
;                    ONE_LINE_DRAW  
JUMP_INTO_24\?: 
                    ONE_LINE_DRAW  
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
                    STB      <VIA_port_a                  ; [6] Send X to A/D 
; light on
                    ldb      #$ee 
                    CLR      <VIA_t1_cnt_hi               ; [4] enable timer 1 
                    stb      <VIA_cntl                    ; ZERO disabled, and BLANK disabled 
; light off
; there must the above mentioned "switch the light off" 
; after 22 cycles still be manually done
; (but the 22 cycles might be reused otherwise!)
                    endm     

MAX_LINE_NUM_16        EQU      17 
MY_SPRITE_DRAW_VLC_UNLOOP_16  macro  
; (x) length in bytes
; [x] duration in cycles
; do one "manual" starter line in advance
                    pulu     d                            ; get current coordinates 
                    STA      <VIA_port_a                  ;(2) [4] Send Y to A/D 
                    CLR      <VIA_port_b                  ;(2) [4] enable mux, thus y integrators are set to Y 
                    INC      <VIA_port_b                  ;[6] Disable mux 
                    ONE_LINE_DRAW  
                    jmp      ,y 
JUMP_INTO_ALL\?: 
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
                    STB      <VIA_port_a                  ; [6] Send X to A/D 
; light on
                    ldb      #$ee 
                    CLR      <VIA_t1_cnt_hi               ; [4] enable timer 1 
                    stb      <VIA_cntl                    ; ZERO disabled, and BLANK disabled 
; light off
; there must the above mentioned "switch the light off" 
; after 22 cycles still be manually done
; (but the 22 cycles might be reused otherwise!)
                    endm     
