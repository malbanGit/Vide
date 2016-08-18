;***************************************************************************
; DEFINE SECTION
;***************************************************************************
; load vectrex bios routine definitions
                    INCLUDE  "VECTREX.I"                  ; vectrex function includes
                    include  "3dImagerVars.i"
; Attention
; A) Imager routines expect the interrupt on CA1 to be triggered by a positive edge
;    configuration of the "edge" is done with Via reg $c periphal control register.
;
;    BIOS routines store values into that regisser and "overwrite" the needed imager
;    settings, most commonly routines, which access
;    ZERO and BLANK can be set with that register, 
;    so all integrator reset stuff (WaitRecal, Reset0Ref..., all MoveTo...)
;    are dangerous. For the example I provided several routines, which support the different bit.
;
;***************************************************************************
; Variable / RAM SECTION
;***************************************************************************
; insert your variables (RAM usage) in the BSS section
; user RAM starts at $c880 
                    BSS      
                    ORG      $c880                        ; start of our ram space 
;***************************************************************************
; HEADER SECTION
;***************************************************************************
; The cartridge ROM starts at address 0
                    CODE     
                    ORG      0 
; the first few bytes are mandatory, otherwise the BIOS will not load
; the ROM file, and will start MineStorm instead
                    DB       "g GCE 1998", $80 ; 'g' is copyright sign
                    DW       music1                       ; music from the rom 
                    DB       $F8, $50, $20, -$80          ; hight, width, rel y, rel x (from 0,0) 
                    DB       "IMAGER 2D", $80             ; some game information, ending with $80
                    DB       0                            ; end of game header 
;***************************************************************************
; CODE SECTION
;***************************************************************************
; here the cartridge program starts off
start: 
                    LDA      #$D0 
                    TFR      A,DP 
                    direct   $D0 
                    jsr      imagerInit                   ; initiate the Imager 
                    jmp      ReturnFromIRQ                ; and do one interrupt handling 

; main "IRQ" Loop
ReturnFromIRQ: 
                    ldd      >Vec_Rfrsh                   ; initiate our timing reference! 
                    std      <VIA_t2_lo                   ; Set refresh timer 
; the first thing we should do here is check the joystick ports (buttons!)
; so they do not interfere later with PWM pulses
; however - for the example
; there is no joystick polling required, so - for the sake of
; lazyness, I just leave that out!    
;                    PSG_PORT_A_INPUT
;                    jsr      >Read_Btns
;
                    PSG_PORT_A_OUTPUT                     ; start our duty cycle, PSG to output 
                    PULSE_LOW                             ; and output a low signal 
                    lda      #$CF                         ; Un-zero integrators, and trigger 
                    sta      <VIA_cntl                    ; IRQ on positive edge. 
                    ldb      #$02                         ; CA1 bitmask 
                    stb      <VIA_int_flags               ; enable (clear) interrupt flag for CA1 in VIA 
                    andcc    #$EF                         ; and also enable interrupts in general in our CPU 
;
wait_for_draw_right_blue: 
                    jsr      checkPWMOutput               ; after each timeconsuming "thing" (or in iddle loop) check if PWM impulse should be put off duty 
                    ldd      #RIGHT_BLUE_TIMER_WAIT       ; check timee2 if we should start doing out current eye/color combination 
                    cmpa     <VIA_t2_hi 
                    bls      wait_for_draw_right_blue     ; if not, just wait till time passes 
                    ldd      #$B030                       ; coordinate for current string (y,x) 
                    ldu      #blueString 
                    jsr      Print_Str_d_active           ; and just do a print (own version because of active edge CA1 interrupt) 
;
wait_for_draw_right_green: 
                    jsr      checkPWMOutput               ; after each timeconsuming "thing" (or in iddle loop) check if PWM impulse should be put off duty 
                    ldd      #RIGHT_GREEN_TIMER_WAIT      ; check timer if we should start doing out current eye/color combination 
                    cmpa     <VIA_t2_hi 
                    bls      wait_for_draw_right_green    ; if not, just wait till time passes 
                    ldd      #$0030                       ; coordinate for current string (y,x) 
                    ldu      #greenString 
                    jsr      Print_Str_d_active           ; and just do a print (own version because of active edge CA1 interrupt) 
;
wait_for_draw_right_red: 
                    jsr      checkPWMOutput               ; after each timeconsuming "thing" (or in iddle loop) check if PWM impulse should be put off duty 
                    ldd      #RIGHT_RED_TIMER_WAIT        ; check timer2 if we should start doing out current eye/color combination 
                    cmpa     <VIA_t2_hi 
                    bls      wait_for_draw_right_red      ; if not, just wait till time passes 
                    ldd      #$5030                       ; coordinate for current string (y,x) 
                    ldu      #redString 
                    jsr      Print_Str_d_active           ; and just do a print (own version because of active edge CA1 interrupt) 
;
wait_for_draw_left_blue: 
                    jsr      checkPWMOutput               ; after each timeconsuming "thing" (or in iddle loop) check if PWM impulse should be put off duty 
                    ldd      #LEFT_BLUE_TIMER_WAIT        ; check timer2 if we should start doing out current eye/color combination 
                    cmpa     <VIA_t2_hi 
                    bls      wait_for_draw_left_blue      ; if not, just wait till time passes 
                    ldd      #$B0B0                       ; coordinate for current string (y,x) 
                    ldu      #blueString 
                    jsr      Print_Str_d_active           ; and just do a print (own version because of active edge CA1 interrupt) 
;
wait_for_draw_left_green: 
                    jsr      checkPWMOutput               ; after each timeconsuming "thing" (or in iddle loop) check if PWM impulse should be put off duty 
                    ldd      #LEFT_GREEN_TIMER_WAIT       ; check timer2 if we should start doing out current eye/color combination 
                    cmpa     <VIA_t2_hi 
                    bls      wait_for_draw_left_green     ; if not, just wait till time passes 
                    ldd      #$00B0                       ; coordinate for current string (y,x) 
                    ldu      #greenString 
                    jsr      Print_Str_d_active           ; and just do a print (own version because of active edge CA1 interrupt) 
;
wait_for_draw_left_red: 
                    jsr      checkPWMOutput               ; after each timeconsuming "thing" (or in iddle loop) check if PWM impulse should be put off duty 
                    ldd      #LEFT_RED_TIMER_WAIT         ; check timer2 if we should start doing out current eye/color combination 
                    cmpa     <VIA_t2_hi 
                    bls      wait_for_draw_left_red       ; if not, just wait till time passes 
                    ldd      #$50B0                       ; coordinate for current string (y,x) 
                    ldu      #redString 
                    jsr      Print_Str_d_active           ; and just do a print (own version because of active edge CA1 interrupt) 
; at last we should check for joytick movement
; which actually for the example is not really neccessary!
;                    clr      >Vec_Misc_Count    ; Disable joystick approximation
;                    jsr      >Joy_Digital
                    jsr      >ZeroResetPenAndDelay        ; and finish main loop 
                    jsr      >Reset_Pen 
                    cwai     #$EF                         ; * Enable IRQ & wait for goggle index 
;***************************************************************************
; DATA SECTION
;***************************************************************************
redString: 
                    DB       "RED"                        ; only capital letters
                    DB       $80                          ; $80 is end of string 
greenString: 
                    DB       "GREEN"                      ; only capital letters
                    DB       $80                          ; $80 is end of string 
blueString: 
                    DB       "BLUE"                       ; only capital letters
                    DB       $80                          ; $80 is end of string 
;***************************************************************************
                    include  "3dImager.i"
