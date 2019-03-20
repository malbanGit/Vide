; this file is part of Karl Quappe, written by Malban
; in 2016
; all stuff contained here is public domain
;
;
SPACE               =        17 
HARDMODE = 18
ZAHLEN_MAX = 19
zahlen2:            
; 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 SPACE M
                    db       %00001100, %00001100, %00001100, %00001100, %00010000, %00001110, %00001100, %00011110, %00001100, %00001100, %11001100, %11001100, %11001100, %11001100, %11010000, %11001110, %110001100, %00000000, %01100110
                    db       %00010010, %00000100, %00010010, %00010010, %00010000, %00001000, %00010000, %00000100, %00010010, %00010010, %01010010, %01000100, %01010010, %01010010, %01010000, %01001000, %010010000, %00000000, %01100110
                    db       %00010010, %00000100, %00000100, %00000100, %00010100, %00001100, %00001100, %00001000, %00001100, %00001100, %01010010, %01000100, %01000100, %01000100, %01010100, %01001100, %010001100, %00000000, %01111110
                    db       %00010010, %00000100, %00001000, %00010010, %00011110, %00000010, %00010010, %00001000, %00010010, %00000010, %01010010, %01000100, %01001000, %01010010, %01011110, %01000010, %010010010, %00000000, %01100110
                    db       %00001100, %00000100, %00011110, %00001100, %00000100, %00001100, %00001100, %00001000, %00001100, %00001100, %01001100, %01000100, %01011110, %01001100, %01000100, %01001100, %010001100, %00000000, %01100110
zahlen2_end: 
;C !"#$%&´()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_  
FontRow1: 
                    DB       %00111000, %00000000, %00111000, %01101100, %00000000 
                    DB       %00010000, %11000100, %01110000, %00110000, %00011000, %00110000 
                    DB       %00000000, %00000000, %00000000, %00000000, %00000000, %00000100 
                    DB       %00111000, %00011000, %01111100, %01111110, %00011100, %11111100 
                    DB       %00111100, %11111110, %01111000, %01111100, %00000000, %00000000 
                    DB       %00001100, %00000000, %01100000, %00111100, %00111000, %00111000 
                    DB       %11111100, %00111100, %11111000, %11111110, %11111110, %00111110 
                    DB       %11000110, %01111110, %00000110, %11000110, %11000000, %11000110 
                    DB       %11000110, %01111100, %11111100, %01111100, %11111100, %01111000 
                    DB       %01111110, %11000110, %11000110, %11000110, %11000110, %01100110 
                    DB       %11111110, %00111100, %10000000, %01111000, %00010000, %00000000 
                    DB       %00010000, %00111000, %00010000, %00010000, %00010000, %11111110 
FontRow2: 
                    DB       %01000100, %00000000, %00111000, %01101100, %01101100 
                    DB       %01111100, %11001100, %11011000, %00110000, %00110000, %00011000 
                    DB       %00010000, %00010000, %00000000, %00000000, %00000000, %00001100 
                    DB       %01001100, %00111000, %11000110, %00001100, %00111100, %11000000 
                    DB       %01100000, %11000110, %11000100, %11000110, %00110000, %00110000 
                    DB       %00011000, %00000000, %00110000, %01100110, %01000100, %01101100 
                    DB       %11000110, %01100110, %11001100, %11000000, %11000000, %01100000 
                    DB       %11000110, %00011000, %00000110, %11001100, %11000000, %11101110 
                    DB       %11100110, %11000110, %11000110, %11000110, %11000110, %11001100 
                    DB       %00011000, %11000110, %11000110, %11000110, %11101110, %01100110 
                    DB       %00001110, %00110000, %11000000, %00011000, %00111000, %00000000 
                    DB       %00111000, %00111000, %00110000, %00011000, %00111000, %10000010 
FontRow3: 
                    DB       %10011010, %00000000, %00111000, %01001000, %11111110 
                    DB       %11010000, %00011000, %11011000, %01100000, %01100000, %00001100 
                    DB       %01010100, %00010000, %00000000, %00000000, %00000000, %00011000 
                    DB       %11000110, %00011000, %00001110, %00011000, %01101100, %11111100 
                    DB       %11000000, %00001100, %11100100, %11000110, %00110000, %00110000 
                    DB       %00110000, %01111100, %00011000, %00000110, %10011010, %11000110 
                    DB       %11000110, %11000000, %11000110, %11000000, %11000000, %11000000 
                    DB       %11000110, %00011000, %00000110, %11011000, %11000000, %11111110 
                    DB       %11110110, %11000110, %11000110, %11000110, %11000110, %11000000 
                    DB       %00011000, %11000110, %11000110, %11010110, %01111100, %01100110 
                    DB       %00011100, %00110000, %01100000, %00011000, %01101100, %00000000 
                    DB       %01111100, %00111000, %01111110, %11111100, %01111100, %10000010 
FontRow4: 
                    DB       %10100010, %00000000, %00110000, %00000000, %01101100 
                    DB       %01111100, %00110000, %01110010, %00000000, %01100000, %00001100 
                    DB       %00111000, %01111100, %00000000, %01111100, %00000000, %00110000 
                    DB       %11000110, %00011000, %00111100, %00111100, %11001100, %00000110 
                    DB       %11111100, %00011000, %01111000, %01111110, %00000000, %00000000 
                    DB       %01100000, %00000000, %00001100, %00001100, %10101010, %11000110 
                    DB       %11111100, %11000000, %11000110, %11111100, %11111100, %11001110 
                    DB       %11111110, %00011000, %00000110, %11110000, %11000000, %11111110 
                    DB       %11111110, %11000110, %11000110, %11000110, %11001110, %01111100 
                    DB       %00011000, %11000110, %11101110, %11111110, %00111000, %00111100 
                    DB       %00111000, %00110000, %00110000, %00011000, %00000000, %00000000 
                    DB       %11111110, %11111110, %11111110, %11111110, %00000000, %10000010 
FontRow5: 
                    DB       %10011010, %00000000, %00110000, %00000000, %11111110 
                    DB       %00010110, %01100000, %11011110, %00000000, %01100000, %00001100 
                    DB       %01010100, %00010000, %00110000, %00000000, %00000000, %01100000 
                    DB       %11000110, %00011000, %01111000, %00000110, %11111110, %00000110 
                    DB       %11000110, %00110000, %10011110, %00000110, %00110000, %00110000 
                    DB       %00110000, %01111100, %00011000, %00011000, %10011100, %11111110 
                    DB       %11000110, %11000000, %11000110, %11000000, %11000000, %11000110 
                    DB       %11000110, %00011000, %00000110, %11111000, %11000000, %11010110 
                    DB       %11011110, %11000110, %11111100, %11011110, %11111000, %00000110 
                    DB       %00011000, %11000110, %01111100, %11111110, %01111100, %00011000 
                    DB       %01110000, %00110000, %00011000, %00011000, %00000000, %00000000 
                    DB       %00111000, %01111100, %01111110, %11111100, %01111100, %10000010 
FontRow6: 
                    DB       %01000100, %00000000, %00000000, %00000000, %01101100 
                    DB       %01111100, %11001100, %11001100, %00000000, %00110000, %00011000 
                    DB       %00010000, %00010000, %00110000, %00000000, %00110000, %11000000 
                    DB       %01100100, %00011000, %11100000, %11000110, %00001100, %11000110 
                    DB       %11000110, %00110000, %10000110, %00001100, %00110000, %00110000 
                    DB       %00011000, %00000000, %00110000, %00000000, %01000000, %11000110 
                    DB       %11000110, %01100110, %11001100, %11000000, %11000000, %01100110 
                    DB       %11000110, %00011000, %11000110, %11011100, %11000000, %11000110 
                    DB       %11001110, %11000110, %11000000, %11001100, %11011100, %11000110 
                    DB       %00011000, %11000110, %00111000, %11101110, %11101110, %00011000 
                    DB       %11100000, %00110000, %00001100, %00011000, %00000000, %00000000 
                    DB       %00111000, %00111000, %00110000, %00011000, %00111000, %10000010 
FontRow7: 
                    DB       %00111000, %00000000, %00110000, %00000000, %00000000 
                    DB       %00010000, %10001100, %01110110, %00000000, %00011000, %00110000 
                    DB       %00000000, %00000000, %01100000, %00000000, %00110000, %10000000 
                    DB       %00111000, %01111110, %11111110, %01111100, %00001100, %01111100 
                    DB       %01111100, %00110000, %01111100, %01111000, %00000000, %01100000 
                    DB       %00001100, %00000000, %01100000, %00011000, %00111000, %11000110 
                    DB       %11111100, %00111100, %11111000, %11111110, %11000000, %00111110 
                    DB       %11000110, %01111110, %01111100, %11001110, %11111110, %11000110 
                    DB       %11000110, %01111100, %11000000, %01111010, %11001110, %01111100 
                    DB       %00011000, %01111100, %00010000, %11000110, %11000110, %00011000 
                    DB       %11111110, %00111100, %00000100, %01111000, %00000000, %11111110 
                    DB       %00111000, %00010000, %00010000, %00010000, %00010000, %11111110 
; zero delay is needed for zeroing to work correctly
; depends on the distance of the current integrator position to actual zero point
; experiment with my vectri:
;ZERO ing the integrators takes time. Measures at my vectrex show e.g.:
;If you move the beam with a to x = -127 and y = -127 at diffferent scale values, the time to reach zero:
;- scale $ff -> zero 110 cycles
;- scale $7f -> zero 75 cycles
;- scale $40 -> zero 57 cycles
;- scale $20 -> zero 53 cycles
ZERO_DELAY_P          EQU      2                            ; delay 7 counter is exactly 111 cycles delay between zero SETTING and zero unsetting (in moveto_d) 
                    direct   $d0 
FONT_LENGTH         EQU      ((FontRow2-FontRow1)) 
FONT_START_A        EQU      FontRow1 + 1 -$20            ; // space is 1 
FONT_END            EQU      FONT_START_A+6*FONT_LENGTH 
sync_Print_Str_d_fixed 
sync_Print_Str_d 
; put move position on stack put it so, that we can load "d" directly from stack
 pshs d
                    STU      Vec_Str_Ptr                  ;Save string pointer 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; POSITION "EXACT" PATCH assuming x pos is midle alligned, 
; if that is a case we can use neg x pos as "opposite" string pos
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                    ldd      #(%10000010)*256+$CC                         ; zero the integrators 
                    stb      <VIA_cntl                    ; store zeroing values to cntl 
                    ldb      #ZERO_DELAY                  ; and wait for zeroing to be actually done 
; reset integrators
                    clr      <VIA_port_a                  ; reset integrator offset 
           ;         lda      #%10000010 
; wait that zeroing surely has the desired effect!
zeroLoop_a2: 
                    sta      <VIA_port_b                  ; while waiting, zero offsets 
                    decb     
                    bne      zeroLoop_a2 

                    ldd      ,s 
 negb
 jsr my_move_to_d
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


                    LDX      #FONT_START_A                ;Point to start of chargen bitmaps 
next_line_a: 
; zero
                    ldd      #(%10000010)*256+$CC                         ; zero the integrators 
                    stb      <VIA_cntl                    ; store zeroing values to cntl 
                    ldb      #ZERO_DELAY_P                  ; and wait for zeroing to be actually done 
; reset integrators
                    clr      <VIA_port_a                  ; reset integrator offset 
           ;         lda      #%10000010 
; wait that zeroing surely has the desired effect!
zeroLoop_a: 
                    sta      <VIA_port_b                  ; while waiting, zero offsets 
                    decb     
                    bne      zeroLoop_a 
                    inc      <VIA_port_b 
                    ldd      ,s 
;;;;;;;
                    MY_MOVE_TO_D  
;;;;;;;


Print_Str_a: 
                    LDD      #$1883                       ;a→AUX: b→ORB: $8x = Disable RAMP, Disable Mux, mux sel = 01 (int offsets) 
                    CLR      <VIA_port_a                  ;Clear D/A output 
                    STA      <VIA_aux_cntl                ;Shift reg mode = 110 (shift out under system clock), T1 PB7 disabled, one shot mode 
                                                          ; first entry here, ramp is disabled 
                                                          ; if there was a jump from below 
                                                          ; ramp will be enabled by next line 
LF4A5_a: 
                    STB      <VIA_port_b                  ;ramp off/on set mux to channel 1 
                    DEC      <VIA_port_b                  ;Enable mux 
                    LDD      #$8081                       ;both to ORB, both disable ram, mux sel = 0 (y int), a:→enable mux: b:→disable mux 
   ;                 NOP                                   ;Wait a moment 
                    INC      <VIA_port_b                  ;Disable mux 
                    STB      <VIA_port_b                  ;Disable RAMP, set mux to channel 0, disable mux 
                    STA      <VIA_port_b                  ;Enable mux 
   ;                 TST      $C800                        ;I think this is a delay only 
                    INC      <VIA_port_b                  ;disable mux 
                    LDA      Vec_Text_Width               ;Get text width 
                    STA      <VIA_port_a                  ;Send it to the D/A 
                    LDD      #$0100                       ;both to ORB, both ENABLE RAMP, a:→ disable mux, b:→ enable mux 
                    LDU      Vec_Str_Ptr                  ;Point to start of text string 
                    STA      <VIA_port_b                  ;[4]enable RAMP, disable mux 
                    BRA      LF4CB_a                      ;[3] 

; one letter is drawn (one row that is) in 18 cycles
; 13 cycles overhead
; ramp is thus active for #ofLetters*18 + 13 cycles
LF4C7_a: 
                    LDA      A,X                          ;[+5]Get bitmap from chargen table 
                    STA      <VIA_shift_reg               ;[+4]rasterout of char bitmap "row" thru shift out in shift register 
LF4CB_a: 
                    LDA      ,U+                          ;[+6]Get next character 
                    BPL      LF4C7_a                      ;[+3]Go back if not terminator 

                    LDA      #$81                         ;[2]disable mux, disable ramp 
                    STA      <VIA_port_b                  ;[4]disable RAMP, disable mux 
                    CMPX     #FONT_END                    ;[4]Check for last row 
                    BEQ      LF50A_a                      ;[3]Branch if last row 
                    LEAX     FONT_LENGTH,X                ;[3]Point to next chargen row 
                    LDA      #$98 
                    STA      <VIA_aux_cntl                ;T1→PB7 enabled 
                    lda      Vec_Text_Height 
                    adda     ,s 
                    sta      ,s 
;            dec      0,s
                    BRA      next_line_a                  ;Go back for next scan line 

LF50A_a: 
 ldd #$98
   ;                 clra     
                    sta      <VIA_shift_reg 
                   ; LDA      #$98 
                    STb      <VIA_aux_cntl                ;T1→PB7 enabled 
                    puls     d  ,pc                          ; all done, correct stack 
;                    rts      
