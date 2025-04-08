S_FONT_LENGTH = $50

; bank 1 + 2 + 0 (from dodger)
; zero delay is needed for zeroing to work correctly
; depends on the distance of the current integrator position to actual zero point
; experiment with my vectri:
;ZERO ing the integrators takes time. Measures at my vectrex show e.g.:
;If you move the beam with a to x = -127 and y = -127 at diffferent scale values, the time to reach zero:
;- scale $ff -> zero 110 cycles
;- scale $7f -> zero 75 cycles
;- scale $40 -> zero 57 cycles
;- scale $20 -> zero 53 cycles
ZERO_DELAY_P2       EQU      1                            ;2 ; delay 7 counter is exactly 111 cycles delay between zero SETTING and zero unsetting (in moveto_d) 
                    direct   $d0 
S_NEXT_SYNC_LINE      macro    
; zero
                    ldd      #(ZERO_DELAY_P2)*256+$CC     ; zero the integrators 
                    stb      <VIA_cntl                    ; store zeroing values to cntl 
                    LDb      #$98 
                    STb      <VIA_aux_cntl                ;T1?PB7 enabled 
; wait that zeroing surely has the desired effect!
zeroLoop_a\?: 
                    nop      2 
                    deca     
                    bne      zeroLoop_a\? 
                    ldd      ,s 
                    MY_MOVE_TO_D_START  
 lda ,s
 suba Vec_Text_Height
 sta ,s
 
;                    dec      ,s                           ; can be done in move 
                    LEAX     S_FONT_LENGTH,X                ;[3]Point to next chargen row 
                    lda      #$18 
                    LDU      Vec_Str_Ptr                  ;Point to start of text string 
                    MY_MOVE_TO_B_END  
                    STA      <VIA_aux_cntl                ;Shift reg mode = 110 (shift out under system clock), T1 PB7 disabled, one shot mode 
                                                          ; first entry here, ramp is disabled 
                                                          ; if there was a jump from below 
                                                          ; ramp will be enabled by next line 
                    LDD      #$0080                       ;a?AUX: b?ORB: $8x = Disable RAMP, Disable Mux, mux sel = 01 (int offsets) 
                    sta      <VIA_port_a                  ;Clear D/A output 
                    STb      <VIA_port_b                  ;Enable mux 
; TO FAST EXAMPLE!!! (cranky)
;                    LDD      #$8000                       ;a?AUX: b?ORB: $8x = Disable RAMP, Disable Mux, mux sel = 01 (int offsets) 
; std <VIA_port_b
                    sty      <VIA_port_b 
; assuming first char is NEVER $80
                    LDb      ,U+                          ;[+6]Get next character 
; one letter is drawn (one row that is) in 18 cycles
; 13 cycles overhead
; ramp is thus active for #ofLetters*18 + 13 cycles
LF4C7_a\?: 
                    LDb      b,X                          ;[+5]Get bitmap from chargen table 
                    STb      <VIA_shift_reg               ;[+4]rasterout of char bitmap "row" thru shift out in shift register 
                    LDb      ,U+                          ;[+6]Get next character 
                    BPL      LF4C7_a\?                    ;[+3]Go back if not terminator 
                    STa      <VIA_port_b                  ; is still $80 ;[4]disable RAMP, disable mux don't matter 
                    endm     
sync_Std_Print_Str_d
; put move position on stack put it so, that we can load "d" directly from stack
                    pshs     d ,y 
                    STU      Vec_Str_Ptr                  ;Save string pointer 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; POSITION "EXACT" PATCH assuming x pos is midle alligned, 
; if that is a case we can use neg x pos as "opposite" string pos
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                    ldd      #(%10000010)*256+$CC         ; zero the integrators 
                    stb      <VIA_cntl                    ; store zeroing values to cntl 
                    ldb      #ZERO_DELAY_P2               ; and wait for zeroing to be actually done 
; reset integrators
                    clr      <VIA_port_a                  ; reset integrator offset 
                                                          ; lda #%10000010 
; wait that zeroing surely has the desired effect!
zeroLoop_a_2_S: 
                    sta      <VIA_port_b                  ; while waiting, zero offsets 
                    decb     
                    bne      zeroLoop_a_2_S 
                    inca     
                    sta      <VIA_port_b 
                    ldd      ,s 
                    negb     
                    MY_MOVE_TO_D_START  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                    LDX      #Char_Table -$20-S_FONT_LENGTH   ;Point to start of chargen bitmaps 
                    ldb      Vec_Text_Width 
                    lda      #$81 
                    lda      #$01 
                    tfr      d,y 
                    MY_MOVE_TO_B_END  
printsyncAgain_S 
                    S_NEXT_SYNC_LINE  
                    S_NEXT_SYNC_LINE  
                    S_NEXT_SYNC_LINE  
                    S_NEXT_SYNC_LINE  
                    S_NEXT_SYNC_LINE  
                    S_NEXT_SYNC_LINE  
; zero
                    ldd      #(ZERO_DELAY_P2)*256+$CC     ; zero the integrators 
                    stb      <VIA_cntl                    ; store zeroing values to cntl 
                    LDb      #$98 
                    STb      <VIA_aux_cntl                ;T1?PB7 enabled 
; wait that zeroing surely has the desired effect!
zeroLoop_a_S: 
                    nop      2 
                    deca     
                    bne      zeroLoop_a_S 
                    ldd      ,s 
                    MY_MOVE_TO_D_START  
                    LEAX     S_FONT_LENGTH,X                ;[3]Point to next chargen row 
                    lda      #$18 
                    LDU      Vec_Str_Ptr                  ;Point to start of text string 
                    MY_MOVE_TO_B_END  
                    STA      <VIA_aux_cntl                ;Shift reg mode = 110 (shift out under system clock), T1 PB7 disabled, one shot mode 
                                                          ; first entry here, ramp is disabled 
                                                          ; if there was a jump from below 
                                                          ; ramp will be enabled by next line 
                    LDD      #$0080                       ;a?AUX: b?ORB: $8x = Disable RAMP, Disable Mux, mux sel = 01 (int offsets) 
                    sta      <VIA_port_a                  ;Clear D/A output 
                    STb      <VIA_port_b                  ;Enable mux 
; TO FAST EXAMPLE!!!
; texts have different angles!
;                    LDD      #$8000                       ;a?AUX: b?ORB: $8x = Disable RAMP, Disable Mux, mux sel = 01 (int offsets) 
; std <VIA_port_b
                    sty      <VIA_port_b 
; assuming first character in a string is never $80
                    LDA      ,U+                          ;[+6]Get next character 
; one letter is drawn (one row that is) in 18 cycles
; 13 cycles overhead
; ramp is thus active for #ofLetters*18 + 13 cycles
LF4C7_a_S: 
                    LDA      A,X                          ;[+5]Get bitmap from chargen table 
                    STA      <VIA_shift_reg               ;[+4]rasterout of char bitmap "row" thru shift out in shift register 
                    LDA      ,U+                          ;[+6]Get next character 
                    BPL      LF4C7_a_S                      ;[+3]Go back if not terminator 
                    STb      <VIA_port_b                  ; is still $81 ;[4]disable RAMP, disable mux 
                    ldd      #$98 
                    std      <VIA_shift_reg 

 if USE_CALIBRATION = 1
                    jsr      calibrationZero 
 endif					

                    puls     y, d ,pc                     ; all done, correct stack 
