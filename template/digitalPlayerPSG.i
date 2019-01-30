; user variable definitions
; $c880
user_ram            EQU      $c883                        ; well start of our ram space 
user_ram_start      EQU      user_ram 
via_b_start         EQU      user_ram                     ; 1 
digit_sound_struct  EQU      via_b_start + 1 
digit_is_playing    EQU      digit_sound_struct + 0       ; 1 
digit_start_pos     EQU      digit_sound_struct + 1       ; 1 
digit_length        EQU      digit_sound_struct + 3       ; 2 
digit_looping       EQU      digit_sound_struct + 5       ; 1 
digit_current_pos   EQU      digit_sound_struct + 6       ; 2 
digit_end_pos       EQU      digit_sound_struct + 8       ; 2 
digit_recal_counter  EQU     digit_sound_struct + 10      ; 1 
digit_sound_struct_end  EQU  digit_sound_struct + 12      ; 
; the following value will differ with each program you use your samples in
; the thing is samples are not ALWAYS played in time, there are certain to be times
; when the timing will "miss" a few
; this is not really all that bad, you won't really hear it, untill you miss quite a lot
; but it DOES matter concerning the 50Hz display limit of 30000 Cycles
; therefor you should measure your routines using e.g. dissi and
; alter this "correction" value till you are pretty near 30000 cycles
; (use tracki addresses like in the example "NOP")
;
; this must be manually corrected!!!
CORRECTION          EQU      96                           ;150 



; a) we wait in a delay loop till T2 expires, but after expiring and a value is actualy send to the dac,
;    there are quite a few cycles, this must be considered in calculating the Timer/sample rate
; b) after the sample is put to dac, there also is a delay till the new t2 timer is set, this
;    also must be calculated into the sample rate timing!
; these values are the cycles of the instructions between these "events" you have to 
; look at dissi to count those (count cycles of instructions)
CYCLES_AFTER_T2_EXPIRES  EQU  55                          ; 43 ; for the routines below, these values are correct! 
CYCLES_BEFOR_T2_IS_SET  EQU  8                            ; 23 
TIMER_T2_DELAY      EQU      CYCLES_AFTER_T2_EXPIRES + CYCLES_BEFOR_T2_IS_SET 
; SAMPLE_RATE == xxxx, that means we must play xxxx samples per second
; vectrex CPU runs at 1/1500000s (1.5 Mhz)
; every "UPDATE_TIMER" cycles we must output one sample! (to keep up with samplerate)
UPDATE_TIMER        EQU      (1500000/SAMPLE_RATE) -TIMER_T2_DELAY 
UPDATE_TIMER_LO     EQU      lo(UPDATE_TIMER) 
UPDATE_TIMER_HI     EQU      hi(UPDATE_TIMER) 
T2_TIMER_PEROID_REAL  EQU    UPDATE_TIMER 
T2_TIMER_PEROID_LO  EQU      lo(T2_TIMER_PEROID_REAL) 
T2_TIMER_PEROID_HI  EQU      hi(T2_TIMER_PEROID_REAL) 
T2_TIMER_PEROID_ENDIAN_REVERSE  EQU  T2_TIMER_PEROID_HI+256*T2_TIMER_PEROID_LO 
RECAL_COUNTER_RESET  EQU     (30000/(T2_TIMER_PEROID_REAL+CORRECTION) ) 
;
; in order to be able to draw more vectors, the DRAW_VLC
; function must be changed, so that more than just one vector is
; drawn between two samples (can easily be done)
; we must use a fixed scale value, since  somehow we must
; calculate the wait_recal
; (actually we MUST asure, that we stay not for more time in the
;  move_to_d or draw_vlc functions, this is sort of a delimiter)
; it should be ok, to use smaller values,
; this (50) value was ment for use with 8kHz samples,
; for 4kHz samples it could probably be doubled...
; (without changing anything else)
SCALE_FACTOR_DIGIT  EQU      50 

; this sets the timer to our restart value
RESTART_TIMER       macro                                 ; name of macro 
                    LDD      #T2_TIMER_PEROID_ENDIAN_REVERSE ; load the timer 2 value we calculated 
                    STD      <VIA_t2_lo                   ; and set the timer 
                    endm                                  ; end of macro 
; this sets VIA B to our known sample state...
SET_VIAB_WITH_VARIABLE  macro                             ; name of macro 
                    LDA      via_b_start                  ; load the calculated VIA B 
                    STA      VIA_port_b                   ; write back to reg B in 6522 
                    endm                                  ; end of macro 
; this calculates our sample state for VIA B
SET_VIAB_INTERN     macro                                 ; name of macro 
                    LDA      VIA_port_b                   ; data reg B from 6522 
                    ANDA     #$f8                         ; save top 5 bits, mask off bottom 3 
                    ORA      #$06                         ; set S/H, SEL 0, SEL 1 
                    STA      via_b_start                  ; and remember it 
                    endm                                  ; end of macro 
; this is a waiter, for our current sample-byte to finnish
WAIT_FOR_NEXT_DIGIT  macro                                ; name of macro 
                    LDB      #$0020                       ; B-reg = T2 interrupt bit 
wait_for_next_digit\?: 
                    BITB     <VIA_int_flags               ; Wait for T2 to time out 
                    BEQ      wait_for_next_digit\?        ; repeat 
                    endm                                  ; end of macro 
; well, not really a 'digit' function... but it does what it's called
INTENSITY_A_DIGIT   macro    
                    STA      Vec_Brightness               ; Save intensity in $C827 
                    STA      VIA_port_a                   ; Store intensity in D/A 
                    LDD      #$0504                       ; mux disabled channel 2 
                    STA      VIA_port_b                   ; 
                    STB      VIA_port_b                   ; mux enabled channel 2 
                    STB      VIA_port_b                   ; do it again just because ? 
                    LDB      #$01                         ; 
                    STB      VIA_port_b                   ; turn off mux 
                    endm     
WRITE_PSG_DIRECT    macro    
                    STA      <VIA_port_a                  ;store register select byte 
                    LDA      #$19                         ;sound BDIR on, BC1 on, mux off _ LATCH 
                    STA      <VIA_port_b 
                    LDA      #$01                         ;sound BDIR off, BC1 off, mux off - INACTIVE 
                    STA      <VIA_port_b 
                    LDA      <VIA_port_a                  ;read sound chip status (?) 
                    STB      <VIA_port_a                  ;store data byte 
                    LDB      #$11                         ;sound BDIR on, BC1 off, mux off - WRITE 
                    STB      <VIA_port_b 
                    LDB      #$01                         ;sound BDIR off, BC1 off, mux off - INACTIVE 
                    STB      <VIA_port_b 
                    endm     
WRITE_PSG           macro    reg, data                    ; a = reg, b = data 
                    ldd      #(reg*256)+data 
                    WRITE_PSG_DIRECT  
                    endm     
; Kills D
; must ALLWAYS have Y, U, U contains the length of the sample, Y the position
; must ALLWAYS have Timer 2
;
; Kills and VIA port B and A
; cycles left = 130 (8Khz)
; cycles left = 300 (4Khz)
;
; uses 27+30 cycles when completely done, without restart
; uses 51+30 cycles when completely done, with restart
; uses 32+30 cycles when one digitized sound byte was played.
; + 9
;
; => Interrupts are not worth it...
NEXT_DIGIT_BYTE_FASTER_NO_I  macro  
                    jsr      [indirectSub] 
                    endm     
playSampleOdd 
                    dec      digit_recal_counter          ; load # of time_outs 
; load current digit byte and increment counter
                    WAIT_FOR_NEXT_DIGIT                   ; otherwise we wait till the last played 
                                                          ; sample-byte is finnished 
                                                          ; is played next round... 
; here our normal 'digit_byte_playing_section'
;doFirstNibble
                    LDb      ,Y                           ; load the next sample_byte to A 
                    lsrb     
                    lsrb     
                    lsrb     
                    lsrb     
                    inc      indirectSub 
; sound on psg is 4 bit only
; possibly we use a conversion table
; to reg 8 (Amplidtude)
                    lda      #8 
                    WRITE_PSG_DIRECT  
                    RESTART_TIMER                         ; restart timer... 
                    rts      

                    org      playSampleOdd+256 
playSampleEven 
                    dec      digit_recal_counter          ; load # of time_outs 
; load current digit byte and increment counter
                    WAIT_FOR_NEXT_DIGIT                   ; otherwise we wait till the last played 
                                                          ; sample-byte is finnished 
                                                          ; is played next round... 
; here our normal 'digit_byte_playing_section'
                    LDb      ,Y+                          ; load the next sample_byte to A 
                    andb     #%00001111 
                    dec      indirectSub 
; sound on psg is 4 bit only
; possibly we use a conversion table
; to reg 8 (Amplidtude)
                    lda      #8 
                    WRITE_PSG_DIRECT  
                    RESTART_TIMER                         ; restart timer... 
                    rts      

; uses for a scalefactor of 50
; about 100+... cycles (could still be optimized further)
MOVE_TO_D_DIGIT     macro    
                    PSHS     D                            ; save the position 
                    NEXT_DIGIT_BYTE_FASTER_NO_I           ; play one sample_byte 
                    PULS     D                            ; restore position 
                    STA      VIA_port_a                   ; Store Y in D/A register 
                    LDA      #$CE                         ; Blank low, zero high? 
                    STA      VIA_cntl                     ; 
                    CLRA     
                    STA      VIA_port_b                   ; Enable mux 
                    STA      VIA_shift_reg                ; Clear shift regigster 
                    INC      VIA_port_b                   ; Disable mux 
                                                          ; PSHS D ; save the position 
                                                          ; NEXT_DIGIT_BYTE_FASTER_NO_I ; play one sample_byte 
                                                          ; PULS D ; restore position 
                    STB      VIA_port_a                   ; Store X in D/A register 
                    STA      VIA_t1_cnt_hi                ; enable timer 
                    LDB      #$40                         ; t1 flag 
wait_for_t1\?: 
                    BITB     VIA_int_flags                ; 
                    BEQ      wait_for_t1\? 
                    endm     
;***************************************************************************
; uses for a scalefactor of 50
; exactly 51 cycles (could still be optimized further)
DRAW_LINE_D_DIGIT   macro    
                    STA      VIA_port_a                   ; Send Y to A/D 
                    CLR      VIA_port_b                   ; Enable mux switched 
                    LEAX     2,X                          ; Point to next coordinate pair X=X+2 
                    NOP                                   ; Wait a moment 
                    INC      VIA_port_b                   ; Disable mux 
                    STB      VIA_port_a                   ; Send X to A/D 
                    LDD      #$FF00                       ; Shift reg=$FF (solid line), T1H=0 
                    STA      VIA_shift_reg                ; Put pattern in shift register 
                    STB      VIA_t1_cnt_hi                ; Set T1H (scale factor), enabling t1 
                    LDD      #$0040                       ; B-reg = T1 interrupt bit 
wait_for_t1\?: 
                    BITB     VIA_int_flags                ; 
                    BEQ      wait_for_t1\? 
                    NOP      
                    STA      VIA_shift_reg                ; Clear shift register (blank output) 
                    endm     
;***************************************************************************
; uses 8 cycles
; (in relation to the last done digital output)
; only one vector drawn for now...
; could probably be doubled (2*51 < 130)
DRAW_VLC_DIGIT      macro    
                    NEXT_DIGIT_BYTE_FASTER_NO_I           ; play one sample-byte 
                    LDA      ,X+                          ; load # of lines in this list 
DRAW_VLA_DIGIT\?: 
                    STA      $C823                        ; helper RAM, here we store the # of lines 
                    LDD      ,X                           ; load y, x 
                    DRAW_LINE_D_DIGIT                     ; draw the line 
                    NEXT_DIGIT_BYTE_FASTER_NO_I           ; and play one sample-byte 
                    LDA      $C823                        ; load line count 
                    DECA                                  ; decrement it 
                    BPL      DRAW_VLA_DIGIT\?             ; go back for more points if not below 0 
                    endm     
;***************************************************************************
; uses 0 cycles
; (in relation to the last done digital output)
; a wait_recal routine for the sample... output
WAIT_RECAL_DIGIT    macro    
wait_for_next_digit\?: 
                    NEXT_DIGIT_BYTE_FASTER_NO_I           ; play one sample-byte 
                    LDA      digit_recal_counter          ; load # of time_outs 
                    CMPA     #RECAL_COUNTER_RESET         ; # should we recalibrate now? 
                    BLO      wait_for_next_digit\?        ; if not yet... loop till the time is right (waiting for roll over) 
; now we move out of bounds
; five times the move should about be 255 (ff) scalefactor :-?
                    CMPY     digit_end_pos                ; if it is zero, than we are finnished 
                    Blo      sound_not_done\?             ; with this sample, otherwise we continue further below 
; if we are done, should we restart?
sound_done\?: 
                    LDA      digit_looping                ; is this sample a looping one? 
                    STA      digit_is_playing             ; store it to is_playing 
                    BEQ      sound_not_done\?             ; if none looping... we are done 
                                                          ; but we still must use the timer 
; ok, for restart, we only change current position
                    LDY      digit_start_pos              ; load the start position 
sound_not_done\? 
                    LDA      #5                           ; loop 5 times 
                    STA      $C823                        ; store that 
recal_loop1\?: 
                    LDD      #$7F7F                       ; load the next pos, super long saturation 
                    JSR      move_to_d_digitj             ; move to d -> must be achieved 
                    DEC      $C823                        ; done yet with out 5? 
                    BNE      recal_loop1\?                ; not yet? than loop 
                    LDB      #$CC 
                    STB      VIA_cntl                     ; blank low and zero low 
; five times the move should about be 255 (ff) scalefactor :-?
                    LDA      #5                           ; loop 5 times 
                    STA      $C823                        ; store that 
recal_loop2\?: 
                    LDD      #$8080                       ; load the next pos, super long saturation 
                    JSR      move_to_d_digitj             ; move to d -> must be achieved 
                    DEC      $C823                        ; done yet with out 5? 
                    BNE      recal_loop2\?                ; not yet? than loop 
                    LDB      #$CC 
                    STB      VIA_cntl                     ; /BLANK low and /ZERO low 
                    LDD      #$0302 
                    STA      VIA_port_b                   ; mux=1, disable mux 
                    CLR      VIA_port_a                   ; clear D/A register 
                    STB      VIA_port_b                   ; mux=1, enable mux 
                    STB      VIA_port_b                   ; do it again 
                    LDB      #$01 
                    STB      VIA_port_b                   ; disable mux 
                    LDA      #RECAL_COUNTER_RESET         ; load our calculated reset value 
                    STA      digit_recal_counter          ; and store it to our timer counter... 
                    SET_VIAB_INTERN                       ; rethink our VIAB value 
                    NEXT_DIGIT_BYTE_FASTER_NO_I           ; and do one sample-byte 
                    endm     
;***************************************************************************
;***************************************************************************
; expects startposition in D
; expects length in X
;
; sets up Y register, should under no circumstances be destroyed
init_digit_sound: 
                    STD      digit_start_pos              ; store new start position 
                    ldd      #playSampleOdd 
                    std      indirectSub 
                    clr      digit_oddEven 
                    STX      digit_length                 ; store the length 
                    TFR      X,D                          ; move X to D 
                    ADDD     digit_start_pos              ; calculate end position 
                    STD      digit_end_pos                ; and store it 
                    LDA      #0                           ; looping per default is OFF 
                    STA      digit_looping                ; store it 
                    LDA      #1                           ; sound is playing is ON 
                    STA      digit_is_playing             ; sound is playing 
                    SET_VIAB_INTERN                       ; calculate out first VIA B poke 
                    LDY      digit_start_pos              ; initialize Y to position in sample data 
                    LDA      #SCALE_FACTOR_DIGIT          ; set the fixed scale factor we will use... 
                    STA      VIA_t1_cnt_lo                ; move to time 1 lo, this means scaling 
; ldx #PSG_Volumne_Hi
; note A3
                    WRITE_PSG  $0, $0                     ; turn oscillator off 
                    WRITE_PSG  $1, $0                     ; 
                    WRITE_PSG  $2, $0                     ; turn oscillator off 
                    WRITE_PSG  $3, $0                     ; 
                    WRITE_PSG  $4, $0                     ; turn oscillator off 
                    WRITE_PSG  $5, $0                     ; 
                    WRITE_PSG  $8, $8                     ; amplitude start = 0 
                    WRITE_PSG  $9, $0 
                    WRITE_PSG  $10, $0 
; enable channel 1 only
                    WRITE_PSG  $6, $0                     ; reg 8 Period 0 noise 
                    WRITE_PSG  $7, %10111111              ; reg 7 ; disable all 
                    RESTART_TIMER                         ; set our timer 2 for the first time... 
                    RTS                                   ; back 

;***************************************************************************
; now the makros from above as functions...
; shortens the source...
;***************************************************************************
wait_recal_digitj: 
                    WAIT_RECAL_DIGIT  
                    RTS      

;***************************************************************************
; position in D
move_to_d_digitj: 
                    MOVE_TO_D_DIGIT  
                    RTS      

;***************************************************************************
; vector list in X
draw_vlc_digitj: 
                    DRAW_VLC_DIGIT  
                    RTS      

;***************************************************************************
; intensity in A
intensity_a_digitj: 
                    INTENSITY_A_DIGIT  
                    RTS      

;***************************************************************************
Char_Table          equ      $F9D4 
Char_Table_End      equ      $Fbb4 
; String pointer in D


;
; DONT USE! NOT WORKING CORRECTLY!
;

Print_Str_digit: 
                    STD      Vec_Str_Ptr                  ;Save string pointer 
                    NEXT_DIGIT_BYTE_FASTER_NO_I  
                    LDX      #Char_Table                  ;Point to start of chargen bitmaps 
                    LDD      #$1883                       ;a->AUX: b->ORB: $8x = Disable RAMP, Disable Mux, mux sel = 01 (int offsets) 
                    CLR      <VIA_port_a                  ;Clear D/A output 
                    STA      <VIA_aux_cntl                ;Shift reg mode = 110 (shift out under system clock), T1 PB7 disabled, one shot mode 
                    LDX      #Char_Table                  ;Point to start of chargen bitmaps 
                                                          ; first entry here, ramp is disabled 
                                                          ; if there was a jump from below 
                                                          ; ramp will be enabled by next line 
LF4A5:              STB      <VIA_port_b                  ;ramp off/on set mux to channel 1 
                    DEC      <VIA_port_b                  ;Enable mux 
                    LDD      #$8081                       ;both to ORB, both disable ram, mux sel = 0 (y int), a:->enable mux: b:->disable mux 
                    NOP                                   ;Wait a moment 
                    INC      <VIA_port_b                  ;Disable mux 
                    STB      <VIA_port_b                  ;Disable RAMP, set mux to channel 0, disable mux 
                    STA      <VIA_port_b                  ;Enable mux 
                    TST      $C800                        ;I think this is a delay only 
                    INC      <VIA_port_b                  ;disable mux 
                    LDA      Vec_Text_Width               ;Get text width 
                    STA      <VIA_port_a                  ;Send it to the D/A 
                    LDD      #$0100                       ;both to ORB, both ENABLE RAMP, a:-> disable mux, b:-> enable mux 
                    LDU      Vec_Str_Ptr                  ;Point to start of text string 
                    STA      <VIA_port_b                  ;[4]enable RAMP, disable mux 
                    BRA      LF4CB                        ;[3] 

; one letter is drawn (one row that is) in 18 cycles
; 13 cycles overhead
; ramp is thus active for #ofLetters*18 + 13 cycles
LF4C7:              LDA      A,X                          ;[+5]Get bitmap from chargen table 
                    STA      <VIA_shift_reg               ;[+4]rasterout of char bitmap "row" thru shift out in shift register 
LF4CB:              LDA      ,U+                          ;[+6]Get next character 
                    BPL      LF4C7                        ;[+3]Go back if not terminator 
                    LDA      #$81                         ;[2]disable mux, disable ramp 
                    STA      <VIA_port_b                  ;[4]disable RAMP, disable mux 
                    NEG      <VIA_port_a                  ;Negate text width to D/A 
                    LDA      #$01                         ;enable ramp, disable mux 
                    STA      <VIA_port_b                  ;enable RAMP, disable mux 
                    CMPX     #Char_Table_End              ;[4]Check for last row 
                    lBEQ     LF50A                        ;[3]Branch if last row 
                    LEAX     $50,X                        ;[3]Point to next chargen row 
                    TFR      U,D                          ;[6]Get string length 
                    SUBD     Vec_Str_Ptr                  ;[7] 
                    SUBB     #$02                         ;[2] - 2 
                    ASLB                                  ;[2] * 2 calculate return "way" 
                    BRN      LF4EB                        ;[3]Delay a moment 
LF4EB:              LDA      #$81                         ;[2]disable RAMP, disable mux 
                    NOP                                   ;[2] 
                    DECB                                  ;[2] 
                    BNE      LF4EB                        ;Delay some more in a loop 
                    STA      <VIA_port_b                  ;disable RAMP, disable mux 
; d can be destroyed here!
; nop 5    
                    NEXT_DIGIT_BYTE_FASTER_NO_I  
                    LDA      #$81                         ;[2]disable RAMP, disable mux 
                    STA      <VIA_port_b                  ;disable RAMP, disable mux 
                    LDB      Vec_Text_Height              ;Get text height 
                    STB      <VIA_port_a                  ;Store text height in D/A [go down -> later] 
                    DEC      <VIA_port_b                  ;Enable mux 
                    LDD      #$8101 
                    NOP                                   ;Wait a moment 
                    STA      <VIA_port_b                  ;disable RAMP, disable mux 
                    CLR      <VIA_port_a                  ;Clear D/A 
                    STB      <VIA_port_b                  ;enable RAMP, disable mux 
                    STA      <VIA_port_b                  ;disable RAMP, disable mux 
                    LDB      #$03                         ;$0x = ENABLE RAMP? 
                    BRA      LF4A5                        ;Go back for next scan line 

LF50A:              LDA      #$98 
                    STA      <VIA_aux_cntl                ;T1->PB7 enabled 
                    NEXT_DIGIT_BYTE_FASTER_NO_I  
                    JMP      Reset0Ref                    ;Reset the zero reference 
