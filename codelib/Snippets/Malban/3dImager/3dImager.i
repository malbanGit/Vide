                    INCLUDE  "VECTREX.I"                  ; vectrex function includes
;
; subroutines for imager handling
                    code     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; sets wheel frequency (T2 Timer) to Narrow Escape timer value of $e000
; init Interrupt
; and vars used by later pwm calculation
imagerInit: 
                    ldd      #T2_INVERSE 
                    std      >Vec_Rfrsh                   ; Set refresh timer = 0.0382 sec 
                    stb      >PWM_T2_Compare_slower 
                    ldd      #$08 
                    std      >countIRQFailureAfterRefreshFor8Samples 
                    stb      >loopCounterIRQ1             ; Init IRQ handler's loop counter 
                    clr      >PWM_T2_Compare_faster 
                    clr      >PWM_T2_Compare_current 
                    ldd      #$7E82 
_0064: 
                    sta      >Vec_IRQ_Vector              ; Set up IRQ interrupt vector: JMP 
                    stb      <VIA_int_enable 
                    ldd      #IRQ_Handler 
                    std      >InterruptVectorRam          ; Set IRQ interrupt function: Sync 
                    jsr      ZeroResetPenAndDelay         ; zero integrators, and ensure CA1 trigger on active edge 
                    clr      >tmp_counter                 ; Set loop counter = 0 (we want 3 correct syncs, this is the counter for that) 
; from here on get the imager spinning with
; short pulses (no output is done till we reach the spin frequency we want)
spinFullWheel: 
                    ldd      >Vec_Rfrsh                   ; Wait for the goggle's disk to come upto speed* 
                    std      <VIA_t2_lo                   ; Set refresh timer 
                    PSG_PORT_A_INPUT                      ; get the sync state befor we initiate next pulse sequences 
                    bsr      GetGoggleIndexState 
                    sta      >flagImagerSyncReceived      ; and store the result 
doAnotherPulseSequence: 
                    PSG_PORT_A_OUTPUT                     ; switch to output, that we can set the pulse 
                    PULSE_LOW  
                    ldb      #$60                         ; set delay loop value 
pulseOnDelayLoop: 
                    decb     
                    bne      pulseOnDelayLoop             ; Delay for awhile 
                    PULSE_HI  
                    PSG_PORT_A_INPUT                      ; switch to input, so we can poll the "button 4" CA1 flag 
                    bsr      GetGoggleIndexState 
                    tst      >flagImagerSyncReceived      ; check the last sync state 
                    bne      previousStateOff             ; has gone from off to on (jump if previous was off) 
                    tsta                                  ; previous state of sync was on 
                    bne      syncFromOnToOff              ; if switch was from on to off, than a full "round" was done -> jump 
previousStateOff: 
                    sta      >flagImagerSyncReceived      ; otherwise store the current sync state and do another pulse sequence 
                    bra      doAnotherPulseSequence 

; we have succeded in getting the imager wheel spinning for a full round (at least we see the sync hole)
; now lets check if we did that in the required frequency, checking Timer T2 for that purpose
syncFromOnToOff: 
                    lda      <VIA_int_flags               ; load T2 interrupt flag 
                    bita     #$20                         ; if the timer interrupt flag is set, than the timer elapsed BEFOR 
                    bne      spinFullWheel                ; we got to the sync hole -> we are to slow, spin another full round 
                    inc      >tmp_counter                 ; The disk is now upto speed; for 
                    lda      >tmp_counter                 ; good measure, repeat, for a 
                    cmpa     #$03                         ; total of 3 times. 
                    bne      spinFullWheel 
                    rts                                   ; setup done! 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Exit: a = state of goggle index signal
; 0 => index signal not seen
; !=0 => index signal seen
; GetGoggleIndexState()
GetGoggleIndexState: 
                    lda      #$0E                         ; Check to see if the color wheel index has been seen. 
                    sta      <VIA_port_a                  ; PSG register 14 
                    ldd      #$1901 
                    sta      <VIA_port_b                  ; PSG latch 
                    nop      
                    stb      <VIA_port_b                  ; PSG inactive 
                    clr      <VIA_DDR_a                   ; configure port A of via as input 
                    ldd      #$0901 
                    sta      <VIA_port_b                  ; PSG read 
                    nop      
                    lda      <VIA_port_a                  ; Read Port VIA A and this PSG A lines 
                    nop      
                    stb      <VIA_port_b                  ; PSG inactive 
                    ldb      #$FF 
                    stb      <VIA_DDR_a                   ; Set Port A lines as outputs 
                    anda     #$80                         ; only button 4 of joystick 1 is of interested (CA1 
                    rts      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; checks whether interrupt occured befor T2 expired or after
; if befor, we are slightly to fast, if after, than we are slightly to slow
; the next pulse modulation is contolled by  "PWM_T2_Compare_current", in dependence of to slow or to fast
; a slightly different compare value is taken and used in the next main loop round
;
; the greater the compare value, the shorter is the PWM pulse
; if the wheel spins "to fast", the (go) "slow(er) compare" value is taken the next round
; if the wheel spins to slow, the (go) "fast(er) compare" value is taken the next round
; the (go) faster value is always smaller than the (go) slower value
; (since the smaller the value, the longer the pulse lasts, since it is a compare value to the expire of T2)
;
; every 8 wheel spins (main loops) the values are reevaluated and can be corrected
; for a detailed explanation see VIDE documentation!
; expects DP = D0
IRQ_Handler: 
                    clr      <VIA_shift_reg               ; ensure vectors are not drawn anymore!, clear shift (blank = enabled) 
                    lda      <VIA_int_flags               ; load the current interruptflags 
                    bita     #$20                         ; did refresh timer2 already expire? 
                    bne      Timeout                      ; Yes -> so mark another timeout 
                    lda      >PWM_T2_Compare_slower       ; if not, the pulse next round will be shorter 
                    sta      >PWM_T2_Compare_current 
                    dec      >loopCounterIRQ1             ; decrement the IRQ loop counter 
                    bgt      FinishIRQ                    ; have we taken 8 samples? -> if not "return" to main loop 
                    bra      ProcessSamples               ; if yes -> process the results 

Timeout: 
                    lda      >PWM_T2_Compare_faster       ; a timeout did occur, meaning, the wheel spun to slow, so we 
                    sta      >PWM_T2_Compare_current      ; increase the pulse length slightly next round 
                    inc      >countIRQFailureAfterRefreshFor8Samples ; Increment failure counter 
                    dec      >loopCounterIRQ1             ; have we taken 8 samples? 
                    bgt      FinishIRQ                    ; -> if not "return" to main loop 
ProcessSamples: 
                    ldb      #$08 
                    stb      >loopCounterIRQ1             ; reset IRQ sample counter 
; begin calculation for the "PWM_T2_Compare_faster" adjustment
                    ldb      >countIRQFailureAfterRefreshFor8Samples ; Sum the # of failures for this 
                    addb     >countIRQFailureAfterRefreshFor8Samples_1 ; pass and the previous pass. 
                    tfr      b,a                          ; duplicate b to a 
                    suba     #$0D                         ; transform a to an adjustment value 
                    nega                                  ; if to many misses (>13) (wheel to slow) A will be negative, if to "few" misses (<13) (wheel to fast) A will be positive 
                    cmpb     #$0D 
                    beq      fasterAdjustmentDone         ; jmp if last 2 failure counts == 13, no adjustment 
                    bpl      fast_wheelToSlowAdjustment   ; jmp if last 2 failure counts > 13 
; here if last 2 failure counts < 13, 
; then the wheel in average is too fast, 
; add positive value to the "fast compare", 
; so the resulting value is greater, 
; -> resulting in a shorter PWM pulse, and the speed gets slowed down
                    adda     >PWM_T2_Compare_faster       ; add positive difference 
                    bcs      fasterAdjustmentDone         ; if we are above maximum, jump 
                    sta      >PWM_T2_Compare_faster       ; otherwise store the adjustment 
                    bra      fasterAdjustmentDone 

fast_wheelToSlowAdjustment: 
; here if last 2 failure counts > 13, 
; then the wheel in average is too slow, 
; add negative value to the "fast compare", 
; so the resulting value is smaller, 
; -> resulting in a longer PWM pulse, and the speed gets sped up
                    adda     >PWM_T2_Compare_faster       ; add the negative difference 
                    bcc      fasterAdjustmentDone         ; if underflow - jump 
                    sta      >PWM_T2_Compare_faster       ; otherwise store the adjustment 
fasterAdjustmentDone: 
; begin calculation for the "PWM_T2_Compare_slower" adjustment
                    addb     >countIRQFailureAfterRefreshFor8Samples_2 ; Failures for (pass - 2) 
                    addb     >countIRQFailureAfterRefreshFor8Samples_3 ; Failures for (pass - 3) 
                    subb     #$18                         ; b contains sum of 4 passes of failure counts (32 values), subtract 3/4 
                    beq      slowerAdjustmentDone         ; if exactly 24 - we do not change the slower compare value -> jump 
                    tfr      b,a                          ; double b to a 
                    clrb                                  ; "extend" a to d 
                    nega                                  ; negate the difference 
                    asra                                  ; and sign correct divide it by two 
                    rorb                                  ; put that C bit into b (which is not used) 
                    tsta     
                    bmi      slow_wheelToSlowAdjustment   ; if A negative, than more than 24 failures did occur (we are to slow -> ) 
; here if last failue counts are less then 24 (out of 32)
; in average the wheel is to fast, so
; add positive value to the "slow compare", 
; so the resulting value is greater, 
; -> resulting in a shorter PWM pulse, and the speed gets slowed down
                    addd     >PWM_T2_Compare_slower       ; wheel to fast, add positive adjustment adjustment 
                    bcs      slowerAdjustmentDone         ; if overflow jump 
                    std      >PWM_T2_Compare_slower       ; otherwise store the new value 
                    bra      slowerAdjustmentDone 

slow_wheelToSlowAdjustment: 
; here if last failue counts are more then 24 (out of 32)
; in average the wheel is to slow, so
; add negative value to the "slow compare", 
; so the resulting value is smaller, 
; -> resulting in a longer PWM pulse, and the speed gets sped up 
                    addd     >PWM_T2_Compare_slower       ; "subtract" adjustment 
                    bcc      slowerAdjustmentDone         ; if underflow - jump 
                    std      >PWM_T2_Compare_slower       ; otherwise store the new value 
slowerAdjustmentDone: 
; here we begin our last check
; the "slower" and "faster" compare should not be too close to each other
; if slow is with a $1a reach of "fast", than ensure $1a as minimum distance bewteen the two
                    lda      >PWM_T2_Compare_slower       ; 
                    suba     #$1A 
                    suba     >PWM_T2_Compare_faster 
                    bhi      ShuffleFailureInfo           ; if distance hi enough jump 
                    lda      >PWM_T2_Compare_faster       ; otherwise slow = fast + $1a 
                    adda     #$1A 
                    sta      >PWM_T2_Compare_slower 
ShuffleFailureInfo: 
                    ldd      >countIRQFailureAfterRefreshFor8Samples_1 ; Shuffle down the failure results (16 bit this contains pass 1+2) 
                    std      >countIRQFailureAfterRefreshFor8Samples_2 ; information for the last 3 passes (and puts it into passt 2+3) 
                    lda      >countIRQFailureAfterRefreshFor8Samples ; discarding the results for the (get current result) 
                    sta      >countIRQFailureAfterRefreshFor8Samples_1 ; oldest pass (and store to 1) 
                    clr      >countIRQFailureAfterRefreshFor8Samples ; Start w/ 0 failures for next pass 
FinishIRQ: 
                    nop      ; ensure PWM is off duty
                    PULSE_HI  
                    PSG_PORT_A_OUTPUT  
                    jsr      >Reset0Ref ; don't bother with interrupt, edge thingy will be set in main...
                    lds      #$CBEA                       ; restore stack frame 
                    jmp      >ReturnFromIRQ 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ZeroResetPenAndDelay: 
                    lda      #$CD                         ; Zero integrators, and trigger IRQ 
                    sta      <VIA_cntl                    ; on positive edge. 
                    jsr      >Reset_Pen 
                    jsr      >Delay_RTS 
                    rts      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
checkPWMOutput: 
                    PWM_CHECK  
                    rts      
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; copy of the BIOS Print_Str_d with the only difference being
; that the active edge of the CA1 interrupt is kept
Print_Str_d_active: 
                    JSR      Moveto_d_active 
                    JSR      Delay_1 
Print_Str_active: 
                    STU      Vec_Str_Ptr                  ;Save string pointer 
                    LDX      #Char_Table-$20              ;Point to start of chargen bitmaps 
                    LDD      #$1883                       ;a→AUX: b→ORB: $8x = Disable RAMP, Disable Mux, mux sel = 01 (int offsets) 
                    CLR      <VIA_port_a                  ;Clear D/A output 
                    STA      <VIA_aux_cntl                ;Shift reg mode = 110 (shift out under system clock), T1 PB7 disabled, one shot mode 
                    LDX      #Char_Table-$20              ;Point to start of chargen bitmaps 
                                                          ; first entry here, ramp is disabled 
                                                          ; if there was a jump from below 
                                                          ; ramp will be enabled by next line 
LF4A5: 
                    STB      <VIA_port_b                  ;ramp off/on set mux to channel 1 
                    DEC      <VIA_port_b                  ;Enable mux 
                    LDD      #$8081                       ;both to ORB, both disable ram, mux sel = 0 (y int), a:→enable mux: b:→disable mux 
                    NOP                                   ;Wait a moment 
                    INC      <VIA_port_b                  ;Disable mux 
                    STB      <VIA_port_b                  ;Disable RAMP, set mux to channel 0, disable mux 
                    STA      <VIA_port_b                  ;Enable mux 
                    TST      $C800                        ;I think this is a delay only 
                    INC      <VIA_port_b                  ;disable mux 
                    LDA      Vec_Text_Width               ;Get text width 
                    STA      <VIA_port_a                  ;Send it to the D/A 
                    LDD      #$0100                       ;both to ORB, both ENABLE RAMP, a:→ disable mux, b:→ enable mux 
                    LDU      Vec_Str_Ptr                  ;Point to start of text string 
                    STA      <VIA_port_b                  ;[4]enable RAMP, disable mux 
                    BRA      LF4CB                        ;[3] 

; one letter is drawn (one row that is) in 18 cycles
; 13 cycles overhead
; ramp is thus active for #ofLetters*18 + 13 cycles
LF4C7: 
                    LDA      A,X                          ;[+5]Get bitmap from chargen table 
                    STA      <VIA_shift_reg               ;[+4]rasterout of char bitmap "row" thru shift out in shift register 
LF4CB: 
                    LDA      ,U+                          ;[+6]Get next character 
                    BPL      LF4C7                        ;[+3]Go back if not terminator 
                    LDA      #$81                         ;[2]disable mux, disable ramp 
                    STA      <VIA_port_b                  ;[4]disable RAMP, disable mux 
                    NEG      <VIA_port_a                  ;Negate text width to D/A 
                    LDA      #$01                         ;enable ramp, disable mux 
                    STA      <VIA_port_b                  ;enable RAMP, disable mux 
                    CMPX     #Char_Table_End-$20          ;[4]Check for last row 
                    BEQ      LF50A                        ;[3]Branch if last row 
                    LEAX     $50,X                        ;[3]Point to next chargen row 
                    TFR      U,D                          ;[6]Get string length 
                    SUBD     Vec_Str_Ptr                  ;[7] 
                    SUBB     #$02                         ;[2] - 2 
                    ASLB                                  ;[2] * 2 calculate return "way" 
                    BRN      LF4EB                        ;[3]Delay a moment 
LF4EB: 
                    LDA      #$81                         ;[2]disable RAMP, disable mux 
                    NOP                                   ;[2] 
                    DECB                                  ;[2] 
                    BNE      LF4EB                        ;Delay some more in a loop 
                    STA      <VIA_port_b                  ;disable RAMP, disable mux 
                    LDB      Vec_Text_Height              ;Get text height 
                    STB      <VIA_port_a                  ;Store text height in D/A [go down → later] 
                    DEC      <VIA_port_b                  ;Enable mux 
                    LDD      #$8101 
                    NOP                                   ;Wait a moment 
                    STA      <VIA_port_b                  ;disable RAMP, disable mux 
                    CLR      <VIA_port_a                  ;Clear D/A 
                    STB      <VIA_port_b                  ;enable RAMP, disable mux 
                    STA      <VIA_port_b                  ;disable RAMP, disable mux 
                    LDB      #$03                         ;$0x = ENABLE RAMP? 
                    BRA      LF4A5                        ;Go back for next scan line 

LF50A: 
                    LDA      #$98 
                    STA      <VIA_aux_cntl                ;T1→PB7 enabled 
                    JMP      ZeroResetPenAndDelay         ;Reset the zero reference 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; copy of the BIOS Moveto_d with the only difference being
; that the active edge of the CA1 interrupt is kept
Moveto_d_active: 
                    pshs     a 
                    lda      #$7f 
                    sta      <VIA_t1_cnt_lo 
                    puls     a 
                    STA      VIA_port_a                   ;Store Y in D/A register 
                    LDA      #$CF                         ;Blank low, zero high, active edge 
                    STA      VIA_cntl                     ; 
                    CLRA     
                    STA      VIA_port_b                   ;Enable mux 
                    STA      VIA_shift_reg                ;Clear shift regigster 
                    INC      VIA_port_b                   ;Disable mux 
                    STB      VIA_port_a                   ;Store X in D/A register 
                    STA      VIA_t1_cnt_hi                ;enable timer 
                    LDB      #$40                         ; 
finish_moving_loop: 
                    BITB     VIA_int_flags                ; 
                    BEQ      finish_moving_loop           ; 
                    rts      
