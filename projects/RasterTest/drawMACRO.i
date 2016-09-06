;***************************************************************************
_DP_TO_C8           macro    
                    LDA      #$C8 
                    TFR      A,DP 
                    direct   $C8                          ; pretty for optimizing to use a makro :-) 
                    endm     
;***************************************************************************
_DP_TO_D0           macro    
                    LDA      #$D0 
                    TFR      A,DP 
                    direct   $D0                          ; pretty for optimizing to use a makro :-) 
                    endm     
;***************************************************************************
; divides D by tmp1, result in B
; uses divide_tmp as storage
; only 8 bit in tmp1, but must be manually poked to tmp1 + 1
; sign is correctly handled
;
; can probably be optimized like hell
; perhaps only nearing the result
; using 2 shifts and a plus
; might be worth a try,
; see vectrex emulator for algorithm...
; could be implemented with a tabel, which in turn
; could be caclulated on the fly... (upon startup)
;
; this makro divides exact, but slow
MY_DIV_D_BY_TMP1_TO_B  macro  
                    CLR      divide_tmp 
                    TST      tmp1+1 
                    BEQ      divide_by_zero\? 
                    DEC      divide_tmp 
                    CMPD     #0 
                    BPL      divide_next\? 
divide_next1\?: 
                    INC      divide_tmp 
                    ADDD     tmp1 
                    BMI      divide_next1\? 
divide_by_zero1\?: 
                    LDB      divide_tmp 
                    NEGB     
                    BRA      divide_end\? 

divide_next\?: 
                    INC      divide_tmp 
                    SUBD     tmp1 
                    BPL      divide_next\? 
divide_by_zero\?: 
                    LDB      divide_tmp 
divide_end\?: 
                    endm     
;***************************************************************************
RESET_VECTOR_BEAM   macro    
                    LDA      #$CC 
                    STA      <VIA_cntl                    ;/BLANK low and /ZERO low 

                    lda #$83                              ; a = $18, b = $83 disable RAMP, muxsel=false, channel 1 (integrators offsets) 
                    clr <VIA_port_a                       ; Clear D/A output 
                    sta <VIA_port_b                       ; set mux to channel 1, leave mux disabled 
                    dec <VIA_port_b                       ; enable mux, reset integrator offset values

                    LDA      #$CE 
                    STA      <VIA_cntl                    ;/BLANK low and /ZERO low 

                    inc <VIA_port_b                       ; Disable mux 
                    endm     
;***************************************************************************
_ZERO_VECTOR_BEAM   macro    
                    LDB      #$CC 
                    STB      <VIA_cntl                    ;/BLANK low and /ZERO low 
                    endm     
;***************************************************************************
MY_GAME_SCALE       macro    
                    LDA      #SCALE_FACTOR_GAME 
                    _SCALE_A  
                    endm     
;***************************************************************************
_SCALE_A            macro    
                    STA      VIA_t1_cnt_lo                ; move to time 1 lo, this means scaling 
                    endm     
;***************************************************************************
_SCALE              macro    value 
                    LDA      #\1                          ; scale for placing first point 
                    _SCALE_A  
                    endm     
;***************************************************************************
_DRAW_VLC           macro    
                    LDA      ,X+                          ; 
_DRAW_VLA\?                                               ;        the local directive doesn't work here ??? 
                                                          ; I think because it is a makro using makro... 
                    STA      $C823                        ; 
                    LDD      ,X                           ; 
                    _DRAW_LINE_D                          ; 
                    LDA      $C823                        ;Decrement line count 
                    DECA                                  ; 
                    BPL      _DRAW_VLA\?                  ;Go back for more points 
                    endm     
;***************************************************************************
_DRAW_LINE_D        macro    
                    local    LF3F4                        ;defines 'LF3F4' as a local variable 
                    STA      <VIA_port_a                  ;Send Y to A/D 
                    CLR      <VIA_port_b                  ;Enable mux 
                                                          ; the followin two instructions might be optimized 
                                                          ; but there is something about 18 cycles :-) 
                    LEAX     2,X                          ;Point to next coordinate pair 
                    NOP                                   ;Wait a moment 
                    INC      <VIA_port_b                  ;Disable mux 
                    STB      <VIA_port_a                  ;Send X to A/D 
                    LDD      #$FF00                       ;Shift reg=$FF (solid line), T1H=0 
                    STA      <VIA_shift_reg               ;Put pattern in shift register 
                    STB      <VIA_t1_cnt_hi               ;Set T1H (scale factor?) 
                    LDD      #$0040                       ;B-reg = T1 interrupt bit 
LF3F4:              BITB     <VIA_int_flags               ;Wait for T1 to time out 
                    BEQ      LF3F4                        ; 
                    NOP                                   ;Wait a moment more 
                    STA      <VIA_shift_reg               ;Clear shift register (blank output) 
                    endm     
;***************************************************************************
DRAW_LINE_D_no_x    macro    
                    local    LF3F4                        ;defines 'LF3F4' as a local variable 
                    STA      <VIA_port_a                  ;Send Y to A/D 
                    CLR      <VIA_port_b                  ;Enable mux 
                                                          ; the followin two instructions might be optimized 
                                                          ; but there is something about 18 cycles :-) 
                    NOP                                   ;Wait a moment 
                    INC      <VIA_port_b                  ;Disable mux 
                    STB      <VIA_port_a                  ;Send X to A/D 
                    LDD      #$FF00                       ;Shift reg=$FF (solid line), T1H=0 
                    STA      <VIA_shift_reg               ;Put pattern in shift register 
                    STB      <VIA_t1_cnt_hi               ;Set T1H (scale factor?) 
                    LDD      #$0040                       ;B-reg = T1 interrupt bit 
LF3F4:              BITB     <VIA_int_flags               ;Wait for T1 to time out 
                    BEQ      LF3F4                        ; 
                    NOP                                   ;Wait a moment more 
                    STA      <VIA_shift_reg               ;Clear shift register (blank output) 
                    endm     
;***************************************************************************
; the following makro ...
; they search for a better (faster) scale/DAC relation and use
; the scaling thus found, it should be somewhat faster that way...
; per round we save approxematly: ? cycles
; both destroy X and D
; SCALE factor is changed
;
; forget it !!!
;***************************************************************************

MY_MOVE_TO_D         macro    
; optimzed, tweaked not perfect... 'MOVE TO D' makro
;
;
; NOT DONE:
;
; what should be done:
; s = $ff / max(abs(a),abs(b))
; a = a * s
; b = b * s
; scaling = scaling / s
;
; that would give the most efficient positioning
; bother it takes more time to calculate the above,
; than it saves
; with every positioning via this routine now,
; it takes SCALE_FACTOR_GAME + const (of another 100+) cycles
; to do one simple positioning!!!
; that is probably about 300 cycles per positioning
; this is done about 30-40 times per round
; alone the positioning takes thus about over 10000 cycles
; and we haven't drawn a single line yet!!!
                    local    LF33D_ 
                    STA      <VIA_port_a                  ;Store Y in D/A register 
                    LDA      #$CE                         ;Blank low, zero high? 
                    STA      <VIA_cntl                    ; 
                    CLRA     
                    STA      <VIA_port_b                  ;Enable mux 
                    STA      <VIA_shift_reg               ;Clear shift regigster 
                    INC      <VIA_port_b                  ;Disable mux 
                    STB      <VIA_port_a                  ;Store X in D/A register 
                    STA      <VIA_t1_cnt_hi               ;enable timer 
                    LDB      #$40                         ; 
LF33D_:              BITB     <VIA_int_flags               ; 
                    BEQ      LF33D_                        ; 
                    endm     



;
SIMPLE_DRAW_VL_MODE  macro   
                    local    LF33D_2 
                    CLR      Vec_0Ref_Enable              ;Don't reset the zero reference yet 
next_VListByte:     LDA      ,X+                          ;Get the next mode byte 
                    BNE      draw_one_line 
move_one_Line: 
                    LDD      ,x++ 
;;;;;
;;                    MY_MOVE_TO_D  
                    STA      <VIA_port_a                  ;Store Y in D/A register 
                    CLRA     
                    STA      <VIA_port_b                  ;Enable mux 
                    STA      <VIA_shift_reg               ;Clear shift regigster 
                    INC      <VIA_port_b                  ;Disable mux 
                    STB      <VIA_port_a                  ;Store X in D/A register 
                    STA      <VIA_t1_cnt_hi               ;enable timer 
;                    LDB      #$40                         ; 
;LF33D_2:              
;                    BITB     <VIA_int_flags               ; 
;                    BEQ      LF33D_2                        ; 
;;;;
; NOP 3
;with small scale factor we do not really need to wait at all



                    BRA      next_VListByte 

draw_one_line: 
                    DECA     
                    BEQ      done_Draw 
                    LDD      ,x++ 
;                    DRAW_LINE_D_no_x  
;;; 
                    STA      <VIA_port_a                  ;Send Y to A/D 
                    CLRA     
                    STA      <VIA_port_b                  ;Enable mux 

                    INC      <VIA_port_b                  ;Disable mux 
                    STB      <VIA_port_a                  ;Store X in D/A register 
                    LDD      #$FF00                       ;Shift reg=$FF (solid line), T1H=0 
                    STA      <VIA_shift_reg               ;Put pattern in shift register 
                    STB      <VIA_t1_cnt_hi               ;Set T1H (scale factor?) 

                    LDA      #$40                       ;B-reg = T1 interrupt bit 
LF3F4:              BITA     <VIA_int_flags               ;Wait for T1 to time out 
                    BEQ      LF3F4                        ; 
 NOP 
                    STB      <VIA_shift_reg               ;Clear shift register (blank output) 
;;;;;

                    BRA      next_VListByte 

done_Draw: 
                    endm     
