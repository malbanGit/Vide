;
;***************************************************************************
_LDD                macro    pa, pb 
                    ldd      #(lo(pa)*256)+(lo(pb)) 
                    endm     
;***************************************************************************
_DP_TO_C8           macro                                 ; pretty for optimizing to use a makro :-) 
                    LDA      #$C8 
                    TFR      A,DP 
                    direct   $C8 
                    endm     
;***************************************************************************
_DP_TO_D0           macro                                 ; pretty for optimizing to use a makro :-) 
                    LDA      #$D0 
                    TFR      A,DP 
                    direct   $D0 
                    endm     
NEG_D               macro    
                    COMA     
                    COMB     
                    ADDD     #1 
                    endm                                  ; done 
;***************************************************************************
RESET_VECTOR_BEAM   macro    
                    LDA      #$CC 
                    STA      <VIA_cntl                    ;/BLANK low and /ZERO low 
                    lda      #$83                         ; a = $18, b = $83 disable RAMP, muxsel=false, channel 1 (integrators offsets) 
                    clr      <VIA_port_a                  ; Clear D/A output 
                    sta      <VIA_port_b                  ; set mux to channel 1, leave mux disabled 
                    deca     
                    sta      <VIA_port_b                  ; enable mux, reset integrator offset values 
                                                          ;nop 4 
                    LDA      #$CE 
                    STA      <VIA_cntl                    ;/BLANK high and /ZERO low 
                    LDA      #$81 
                    STA      <VIA_port_b                  ; Disable mux 
                    endm     
;***************************************************************************
_SCALE              macro    value 
                    LDA      #\1                          ; scale for placing first point 
                    _SCALE_A  
                    endm     
;***************************************************************************
_SCALE_A            macro    
                    STA      VIA_t1_cnt_lo                ; move to time 1 lo, this means scaling 
                    endm     
;***************************************************************************
MY_WAIT_RECAL       macro    
                    direct   $d0 
                    LDA      #$20 
                    ldx      Vec_Loop_Count               ; recal counter, about 21 Minutes befor roll over 
                    leax     1,x 
                    stx      Vec_Loop_Count 
                    ldb      <VIA_t2_hi 
                    stb      t2_rest 
LF19E\?:            BITA     <VIA_int_flags               ;Wait for timer t2 
                    BEQ      LF19E\? 
                    LDD      #$3075                       ;Store refresh value 
                    STD      <VIA_t2_lo                   ;into timer t2 
                    LDD      #$CC 
                    STB      <VIA_cntl                    ;blank low and zero low 
                    STA      <VIA_shift_reg               ;clear shift register 
                    sta      <VIA_port_a                  ;clear D/A register 
                    LDD      #$0302 
                    STA      <VIA_port_b                  ;mux=1, disable mux 
                    STB      <VIA_port_b                  ;mux=1, enable mux 
                    LDB      #$01 
                    STB      <VIA_port_b                  ;disable mux 
                    endm     
;***************************************************************************
_ini_ZERO_VECTOR_BEAM2  macro    
                    LDB      #$CC 
                    STB      VIA_cntl                     ;/BLANK low and /ZERO low 
                    clra     
                    sta      <VIA_port_a                  ;clear D/A register 
                    LDD      #$0302 
                    STA      <VIA_port_b                  ;mux=1, disable mux 
                    STB      <VIA_port_b                  ;mux=1, enable mux 
                    LDB      #$01 
                    STB      <VIA_port_b                  ;disable mux 
                    endm     
_ZERO_VECTOR_BEAM   macro    
                    LDB      #$CC 
                    STB      VIA_cntl                     ;/BLANK low and /ZERO low 
                    endm     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; macro D = D *2
MY_LSL_D            macro    
                    ASLB     
                    ROLA     
                    endm                                  ; done 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; macro D = D /2
MY_LSR_D            macro    
                    ASRA     
                    RORB     
                    endm                                  ; done 


MY_MOVE_TO_D_START  macro    
                    STA      <VIA_port_a                  ;Store Y in D/A register 
                    LDA      #$CE                         ;Blank low, zero high? 
                    STA      <VIA_cntl                    ; 
                    CLRA     
                    STA      <VIA_port_b                  ;Enable mux ; hey dis si "break integratorzero 440" 
                    nop                                   ; y must be set more than xx cycles on some vectrex 
                    INC      <VIA_port_b                  ;Disable mux 
                    STB      <VIA_port_a                  ;Store X in D/A register 
                    STA      <VIA_t1_cnt_hi               ;enable timer 
                    endm     
MY_MOVE_TO_D_START_NO_SHIFT  macro  
                    STA      <VIA_port_a                  ;Store Y in D/A register 
                    LDA      #$CE                         ;Blank low, zero high? 
                    STA      <VIA_cntl                    ; 
                    CLRA     
                    STA      <VIA_port_b                  ;Enable mux ; hey dis si "break integratorzero 440" 
                    nop      
                                                          ; nop 
                    INC      <VIA_port_b                  ;Disable mux 
                    STB      <VIA_port_a                  ;Store X in D/A register 
                    STA      <VIA_t1_cnt_hi               ;enable timer 
                    endm     

MY_MOVE_TO_A_END    macro    
                    local    LF33D 
                    LDA      #$40                         ; 
LF33D\?:            BITA     <VIA_int_flags               ; 
                    BEQ      LF33D\?                      ; 
                    endm     
MY_MOVE_TO_B_END    macro    
                    local    LF33D 
                    LDB      #$40                         ; 
LF33D\?:            BITB     <VIA_int_flags               ; 
                    BEQ      LF33D\?                      ; 
                    endm     
MY_MOVE_TO_D_END    macro    
                    local    LF33D 
                    LDB      #$40                         ; 
LF33D\?:            BITB     <VIA_int_flags               ; 
                    BEQ      LF33D\?                      ; 
                    endm     
MY_MOVE_TO_D        macro    
; optimzed, tweaked not perfect... 'MOVE TO D' makro
                    MY_MOVE_TO_D_START  
                    MY_MOVE_TO_B_END  
                    endm     
;***************************************************************************
_INTENSITY_A_8      macro    
                    STA      <VIA_port_a                  ;Store intensity in D/A 
;                    LDD      #$8584                       ;mux disabled channel 2 
;                    STA      <VIA_port_b                  ; 
;                    STB      <VIA_port_b                  ;mux enabled channel 2 
;                    STA      <VIA_port_b                  ;turn off mux 

; V1.06b
                LDD     #$8584          ;mux disabled channel 2
                STA     <VIA_port_b
                STB     <VIA_port_b     ;mux enabled channel 2
                STB     <VIA_port_b     ;do it again just because
                LDB     #$81
                STB     <VIA_port_b     ;turn off mux


                    endm     
_INTENSITY_A        macro    
                    STA      <VIA_port_a                  ;Store intensity in D/A 
;                    LDD      #$0504                       ;mux disabled channel 2 
;                    STA      <VIA_port_b                  ; 
;                    STB      <VIA_port_b                  ;mux enabled channel 2 
;                    STA      <VIA_port_b                  ;turn off mux 

; V1.06b
                LDD     #$0504          ;mux disabled channel 2
                STA     <VIA_port_b
                STB     <VIA_port_b     ;mux enabled channel 2
                STB     <VIA_port_b     ;do it again just because
                LDB     #$01
                STB     <VIA_port_b     ;turn off mux



                    endm     




_INTENSITY_A_ONLY   macro    
                    STA      <VIA_port_a                  ;Store intensity in D/A 

;                    LDa      #$05                         ;mux disabled channel 2 
;                    STA      <VIA_port_b                  ; 
;                    deca     

;                    STa      <VIA_port_b                  ;mux enabled channel 2 
;                    inca     
;                    STA      <VIA_port_b                  ;turn off mux 

; V1.06b
                    LDa      #$05                         ;mux disabled channel 2 
                    STA      <VIA_port_b                  ; 
                    deca     

                    STa      <VIA_port_b                  ;mux enabled channel 2 
                    STa      <VIA_port_b                  ;mux enabled channel 2 
                    LDA #1     
                    STA      <VIA_port_b                  ;turn off mux 


                    endm     

_INTENSITY_B        macro    
                    STB      <VIA_port_a                  ;Store intensity in D/A 

;                    LDD      #$0504                       ;mux disabled channel 2 
;                    STA      <VIA_port_b                  ; 
;                    STB      <VIA_port_b                  ;mux enabled channel 2 
;                    STA      <VIA_port_b                  ;turn off mux 

; V1.06b
                LDD     #$0504          ;mux disabled channel 2
                STA     <VIA_port_b
                STB     <VIA_port_b     ;mux enabled channel 2
                STB     <VIA_port_b     ;do it again just because
                LDB     #$01
                STB     <VIA_port_b     ;turn off mux
                    endm     
