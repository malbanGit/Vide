; this file is part of Karl Quappe, written by Malban
; in 2016
; all stuff contained here is public domain
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this file contains makro definitions of vectrex BIOS functions, these are ;
; sometimes exact clones of the BIOS functions                              ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                    ifndef   MACRO_I 

MACRO_I             equ      1 
; most of these macros are taken from the ROM to avoid
; all those JSR / RTS, in order to save time (over space)
;
;***************************************************************************
_DP_TO_C8           macro                                 ;   pretty for optimizing to use a makro :-) 
                    LDA      #$C8 
                    TFR      A,DP 
                    direct   $C8 
                    endm     
;***************************************************************************
_DP_TO_D0           macro                                 ;   pretty for optimizing to use a makro :-) 
                    LDA      #$D0 
                    TFR      A,DP 
                    direct   $D0 
                    endm     
;***************************************************************************
_ZERO_VECTOR_BEAM   macro    
                    LDB      #$CC 
                    STB      <VIA_cntl                    ;/BLANK low and /ZERO low 
                    endm     
;***************************************************************************
_INTENSITY_A        macro    
                    STA      <VIA_port_a                  ;Store intensity in D/A 
                    LDD      #$0504                       ;mux disabled channel 2 
                    STA      <VIA_port_b                  ; 
                    STB      <VIA_port_b                  ;mux enabled channel 2 
                    STA      <VIA_port_b                  ;turn off mux 
                    endm     
;***************************************************************************
_INTENSITY          macro    value 
                    LDA      #\1 
                    _INTENSITY_A  
                    endm     
;***************************************************************************
_SCALE_A            macro    
                    STA      VIA_t1_cnt_lo                ; move to time 1 lo, this means scaling 
                    endm     
_SCALE_B            macro    
                    STB      VIA_t1_cnt_lo                ; move to time 1 lo, this means scaling 
                    endm     
;***************************************************************************
_SCALE              macro    value 
                    LDA      #\1                          ; scale for placing first point 
                    _SCALE_A  
                    endm     
;***************************************************************************
_ABS_B              macro    
                    local    leave_here 
                    local    Abs_b 
Abs_b:              TSTB     
                    BPL      leave_here 
                    NEGB     
                    BVC      leave_here 
                    DECB     
leave_here: 
                    endm     
;***************************************************************************
_DO_SOUND           macro    
                    local    LF291 
                    local    LF299 
                    LDX      #Vec_Snd_Shadow              ;point to shadow memory 
                    LDU      #Vec_Music_Work              ;point to sound buffer 
                    LDA      #$0D                         ;init count for 14 registers 
LF291:              LDB      ,U+                          ;get next register 
                    CMPB     A,X                          ;skip if unchanged 
                    BEQ      LF299                        ; 
                    STB      A,X                          ; 
                    STA      <VIA_port_a                  ;store register select byte 
                    LDA      #$19                         ;sound BDIR on, BC1 on, mux off 
                    STA      <VIA_port_b                  ; 
                    LDA      #$01                         ;sound BDIR off, BC1 off, mux off 
                    STA      <VIA_port_b                  ; 
                    LDA      <VIA_port_a                  ;read sound chip status (?) 
                    STB      <VIA_port_a                  ;store data byte 
                    LDB      #$11                         ;sound BDIR on, BC1 off, mux off 
                    STB      <VIA_port_b                  ; 
                    LDB      #$01                         ;sound BDIR off, BC1 off, mux off 
                    STB      <VIA_port_b                  ; 
LF299:              DECA                                  ;go back for next register 
                    BPL      LF291                        ; 
                    endm     
;***************************************************************************
                    endif    
