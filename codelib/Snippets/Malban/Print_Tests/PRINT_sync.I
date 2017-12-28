; zero delay is needed for zeroing to work correctly
; depends on the distance of the current integrator position to actual zero point
; experiment with my vectri:
;ZERO ing the integrators takes time. Measures at my vectrex show e.g.:
;If you move the beam with a to x = -127 and y = -127 at diffferent scale values, the time to reach zero:
;- scale $ff -> zero 110 cycles
;- scale $7f -> zero 75 cycles
;- scale $40 -> zero 57 cycles
;- scale $20 -> zero 53 cycles
ZERO_DELAY          EQU      7                            ; delay 7 counter is exactly 111 cycles delay between zero SETTING and zero unsetting (in moveto_d) 
                    direct   $d0 

; height of string is determined by scale factor!
; so is the positioning
; if you want to seperate the two, you 
; a) have to remove the movetoD function to an own
; b) position the beam for in string movement (down) with your own moveto function which uses an own scale factor (height)
;***************************************************************************
sync_Print_Str_d
; put move position on stack put it so, that we can load "d" directly from stack
                    pshs     b 
                    pshs     a 
            STU     Vec_Str_Ptr     ;Save string pointer
            LDX     #Char_Table-$20 ;Point to start of chargen bitmaps

next_line: 
; zero
                    ldb      #$CC                         ; zero the integrators 
                    stb      <VIA_cntl                    ; store zeroing values to cntl 
                    ldb      #ZERO_DELAY                  ; and wait for zeroing to be actually done 
; reset integrators
                    clr      <VIA_port_a                  ; reset integrator offset 
                    lda      #%10000010 
; wait that zeroing surely has the desired effect!
zeroLoop: 
                    sta      <VIA_port_b                  ; while waiting, zero offsets 
                    decb     
                    bne      zeroLoop 
                    inc      <VIA_port_b 
; unzero is done by moveto_d
                    ldd      0,s 
                    jsr      Moveto_d 

Print_Str:
            LDD     #$1883          ;a→AUX: b→ORB: $8x = Disable RAMP, Disable Mux, mux sel = 01 (int offsets)
            CLR     <VIA_port_a     ;Clear D/A output
            STA     <VIA_aux_cntl   ;Shift reg mode = 110 (shift out under system clock), T1 PB7 disabled, one shot mode
            ; first entry here, ramp is disabled
            ; if there was a jump from below
            ; ramp will be enabled by next line
LF4A5:
            STB     <VIA_port_b     ;ramp off/on set mux to channel 1
            DEC     <VIA_port_b     ;Enable mux
            LDD     #$8081          ;both to ORB, both disable ram, mux sel = 0 (y int), a:→enable mux: b:→disable mux
            NOP                     ;Wait a moment
            INC     <VIA_port_b     ;Disable mux
            STB     <VIA_port_b     ;Disable RAMP, set mux to channel 0, disable mux
            STA     <VIA_port_b     ;Enable mux
            TST     $C800           ;I think this is a delay only
            INC     <VIA_port_b     ;disable mux
            LDA     Vec_Text_Width  ;Get text width
            STA     <VIA_port_a     ;Send it to the D/A
            LDD     #$0100          ;both to ORB, both ENABLE RAMP, a:→ disable mux, b:→ enable mux
            LDU     Vec_Str_Ptr     ;Point to start of text string
            STA     <VIA_port_b     ;[4]enable RAMP, disable mux
            BRA     LF4CB           ;[3]
; one letter is drawn (one row that is) in 18 cycles
; 13 cycles overhead
; ramp is thus active for #ofLetters*18 + 13 cycles
LF4C7:
            LDA     A,X             ;[+5]Get bitmap from chargen table
            STA     <VIA_shift_reg  ;[+4]rasterout of char bitmap "row" thru shift out in shift register
LF4CB:
            LDA     ,U+             ;[+6]Get next character
            BPL     LF4C7           ;[+3]Go back if not terminator
            LDA     #$81            ;[2]disable mux, disable ramp
            STA     <VIA_port_b     ;[4]disable RAMP, disable mux
            NEG     <VIA_port_a     ;Negate text width to D/A
            LDA     #$01            ;enable ramp, disable mux
            STA     <VIA_port_b     ;enable RAMP, disable mux
            CMPX    #Char_Table_End-$20;[4]Check for last row
            BEQ     LF50A           ;[3]Branch if last row
            LEAX    $50,X           ;[3]Point to next chargen row
            TFR     U,D             ;[6]Get string length
            SUBD    Vec_Str_Ptr     ;[7]
            SUBB    #$02            ;[2] - 2
            ASLB                    ;[2] * 2 calculate return "way"
            BRN     LF4EB           ;[3]Delay a moment
LF4EB:
            LDA     #$81            ;[2]disable RAMP, disable mux
            NOP                     ;[2]
            DECB                    ;[2]
            BNE     LF4EB           ;Delay some more in a loop
            STA     <VIA_port_b     ;disable RAMP, disable mux

            LDA     #$98
            STA     <VIA_aux_cntl   ;T1→PB7 enabled
            dec      0,s
            BRA     next_line           ;Go back for next scan line

LF50A:
            LDA     #$98
            STA     <VIA_aux_cntl   ;T1→PB7 enabled
                    puls     d                            ; all done, correct stack 
 rts

