                    INCLUDE  "VECTREX.I"                  ; vectrex function includes
                    bss      
                    org      $c900 
flagImagerSyncReceived  ds   1 
loopCounterIRQ1     ds       1                            ; sample counter of IRQ Handler, 8 IRQs are taken as one sample sequence 
countIRQFailureAfterRefreshFor8Samples  ds  1             ; storage for the current sampling 
countIRQFailureAfterRefreshFor8Samples_1  ds  1           ; storage for the last sampling 
countIRQFailureAfterRefreshFor8Samples_2  ds  1           ; storage for the last last sampling 
countIRQFailureAfterRefreshFor8Samples_3  ds  1           ; storage for the last last last sampling 
PWM_T2_Compare_current  ds   1                            ; in the current "main" round used compare value for pulse width modulation 
PWM_T2_Compare_faster  ds    1                            ; calculated value for a pulse that should spin the wheel slightly faster 
PWM_T2_Compare_slower  ds    1                            ; calculated value for a pulse that should spin the wheel slightly slower 
tmp_counter         ds       1                            ; gets overwritten by "PWM_T2_Compare_slower" 
;
T2_VALUE            EQU      $e000                        ; value for the wheel update frequency -> 1/(1/1500000 * 0xe000) = 26,1579241 Hz 
T2_HI               EQU      hi(T2_VALUE) 
T2_LO               EQU      lo(T2_VALUE) 
T2_INVERSE          EQU      (T2_LO*256)+T2_HI 
BLUE_ANGLE          EQU      60                           ; values for the angles 
GREEN_ANGLE         EQU      64                           ; I use the angles to calculate in relation to the above timer value 
RED_ANGLE           EQU      56                           ; the compare values, when the actual eye/color combination is drawn in the timeframe of one main round 
;
RIGHT_BLUE_TIMER_WAIT  =     T2_VALUE                     ; index hole is located so, that we can start right away with blue color 
RIGHT_GREEN_TIMER_WAIT  =    RIGHT_BLUE_TIMER_WAIT - ((T2_VALUE*BLUE_ANGLE)/360) 
RIGHT_RED_TIMER_WAIT  =      RIGHT_GREEN_TIMER_WAIT - ((T2_VALUE*GREEN_ANGLE)/360) 
LEFT_BLUE_TIMER_WAIT  =      RIGHT_RED_TIMER_WAIT - ((T2_VALUE*RED_ANGLE)/360) 
LEFT_GREEN_TIMER_WAIT  =     LEFT_BLUE_TIMER_WAIT - ((T2_VALUE*BLUE_ANGLE)/360) 
LEFT_RED_TIMER_WAIT  =       LEFT_GREEN_TIMER_WAIT - ((T2_VALUE*GREEN_ANGLE)/360) 
;
InterruptVectorRam  EQU      0xCBF9 
;
; Macro definitions
;
; set PSG Port A to input (vectrex receives data from device)
PSG_PORT_A_INPUT    macro    
                    ldb      >Vec_Music_Wk_7              ; Get current I/O enable setting 
                    andb     #$BF 
                    lda      #$07 
                    jsr      >Sound_Byte_raw              ; Config Port A as an input 
                    endm     
;
; set PSG Port A to output (vectrex sets data to device)
PSG_PORT_A_OUTPUT   macro    
                    ldb      >Vec_Music_Wk_7              ; Get current I/O enable setting 
                    orb      #$40 
                    lda      #$07 
                    jsr      >Sound_Byte_raw              ; Config Port A as an output 
                    endm     
;
; set the pulse from the PWM to LOW (duty cycle!)
PULSE_LOW           macro    
                    ldd      #$0E80                       ; write $80 to reg 14 of psg 
                    jsr      >Sound_Byte                  ; this means pulse on 
                    endm     
;
; set the pulse from the PWM to HI (NO duty cycle!)
PULSE_HI            macro    
                    ldd      #$0EFF                       ; write $ff to reg 14 of psg 
                    jsr      >Sound_Byte                  ; this means pulse off 
                    endm     
;
; checks if current PWM timer settings are reached
; if yes, the pulse is switched to HI
; and the compare value to 0, which indicates
; that for this round no more PWM checks are neccessary
PWM_CHECK           macro    
                    lda      >PWM_T2_Compare_current 
                    beq      pwm_check_done\? 
                    cmpa     <VIA_t2_hi                   ; if T2 still larger, than pulse must be kept in duty mode -> jump 
                    bls      pwm_check_done\? 
                    PULSE_HI  
                    PSG_PORT_A_INPUT  
                    clr      >PWM_T2_Compare_current 
pwm_check_done\?: 
                    endm     
