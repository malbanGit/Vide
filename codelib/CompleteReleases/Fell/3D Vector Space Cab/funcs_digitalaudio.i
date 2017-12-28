; Complicated digital sample player
; By Malban
; Hacked with by Fell^DSS, Ludum Dare 38 \p/

SAMPLE_RATE equ 8000

; user variable definitions
user_ram            equ      $c980                        ; well start of our ram space 
user_ram_start      equ      user_ram 
via_b_start         equ      user_ram                     ; 1 
digit_sound_struct  equ      via_b_start + 1 
digit_is_playing    equ      digit_sound_struct + 0       ; 1 
digit_start_pos     equ      digit_sound_struct + 1       ; 1 
digit_length        equ      digit_sound_struct + 3       ; 2 
digit_looping       equ      digit_sound_struct + 5       ; 1 
digit_current_pos   equ      digit_sound_struct + 6       ; 2 
digit_end_pos       equ      digit_sound_struct + 8       ; 2 
digit_recal_counter  equ     digit_sound_struct + 10      ; 1 
digit_sound_struct_end  equ  digit_sound_struct + 12      ; 

; the following value will differ with each program you use your samples in
; the thing is samples are not ALLWAYS played in time, there are certain to be times
; when the timing will "miss" a few
; this is not really all that bad, you won't really hear it, untill you miss quite a lot
; but it DOES matter concerning the 50Hz display limit of 30000 Cycles
; therefor you should measure your routines using e.g. dissi and
; alter this "correction" value till you are pretty near 30000 cycles
; (use tracki addresses like in the example "NOP")
CORRECTION equ 150


; a) we wait in a delay loop till T2 expires, but after expiring and a value is actualy send to the dac,
;    there are quite a few cycles, this must be considered in calculating the Timer/sample rate
; b) after the sample is put to dac, there also is a delay till the new t2 timer is set, this
;    also must be calculated into the sample rate timing!
; these values are the cycles of the instructions between these "events" you have to 
; look at dissi to count those (count cycles of instructions)
CYCLES_AFTER_T2_EXPIRES equ      43 ; for the routines below, these values are correct!
CYCLES_BEFOR_T2_IS_SET  equ      23 
TIMER_T2_DELAY          equ      CYCLES_AFTER_T2_EXPIRES + CYCLES_BEFOR_T2_IS_SET 

; SAMPLE_RATE == xxxx, that means we must play xxxx samples per second
; vectrex CPU runs at 1/1500000s (1.5 Mhz)
; every "UPDATE_TIMER" cycles we must output one sample! (to keep up with samplerate)
UPDATE_TIMER            equ      (1500000/SAMPLE_RATE) -TIMER_T2_DELAY 
UPDATE_TIMER_LO         equ      lo(UPDATE_TIMER) 
UPDATE_TIMER_HI         equ      hi(UPDATE_TIMER) 
T2_TIMER_PEROID_REAL    equ      UPDATE_TIMER 
T2_TIMER_PEROID_LO      equ      lo(T2_TIMER_PEROID_REAL) 
T2_TIMER_PEROID_HI      equ      hi(T2_TIMER_PEROID_REAL) 
T2_TIMER_PEROID_ENDIAN_REVERSE  equ  T2_TIMER_PEROID_HI+256*T2_TIMER_PEROID_LO 
RECAL_COUNTER_RESET     equ      (30000/(T2_TIMER_PEROID_REAL+CORRECTION) ) 

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
SCALE_FACTOR_DIGIT  equ      50 

; this sets the timer to our restart value
RESTART_TIMER       macro                                 ; name of macro 
                    ldd      #T2_TIMER_PEROID_ENDIAN_REVERSE ; load the timer 2 value we calculated 
                    std      VIA_t2_lo                    ; and set the timer 
                    endm                                  ; end of macro 

; this sets VIA B to our known sample state...
SET_VIAB_WITH_VARIABLE  macro                             ; name of macro 
                    lda      via_b_start                  ; load the calculated VIA B 
                    sta      VIA_port_b                   ; write back to reg B in 6522 
                    endm                                  ; end of macro 

; this calculates our sample state for VIA B
SET_VIAB_INTERN     macro                                 ; name of macro 
                    lda      VIA_port_b                   ; data reg B from 6522 
                    anda     #$f8                         ; save top 5 bits, mask off bottom 3 
                    ora      #$06                         ; set S/H, SEL 0, SEL 1 
                    sta      via_b_start                  ; and remember it 
                    endm                                  ; end of macro 

; this is a waiter, for our current sample-byte to finnish
WAIT_FOR_NEXT_DIGIT  macro                                ; name of macro 
wait_for_next_digit\?: 
                    ldb      #$0020                       ; B-reg = T2 interrupt bit 
                    bitb     VIA_int_flags                ; Wait for T2 to time out 
                    beq      wait_for_next_digit\?        ; repeat 
                    endm                                  ; end of macro 

; well, not really a 'digit' function... but it does what it's called
INTENSITY_A_DIGIT   macro    
                    sta      Vec_Brightness               ; Save intensity in $C827 
                    sta      VIA_port_a                   ; Store intensity in D/A 
                    ldd      #$0504                       ; mux disabled channel 2 
                    sta      VIA_port_b                   ; 
                    stb      VIA_port_b                   ; mux enabled channel 2 
                    stb      VIA_port_b                   ; do it again just because ? 
                    ldb      #$01                         ; 
                    stb      VIA_port_b                   ; turn off mux 
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
NEXT_DIGIT_BYTE_FASTER_NO_I  macro                        ; name of macro 
; load current digit byte and increment counter
                    dec      digit_recal_counter          ; decrement our counter, used for wait_recal 
                    tst      digit_is_playing             ; is there a digital sample to be played? 
                    beq      timer_restart_only\?         ; no, than jump out of here 
                    WAIT_FOR_NEXT_DIGIT                   ; otherwise we wait till the last played 
                                                          ; sample-byte is finnished 
                    cmpy     digit_start_pos              ; if it is zero, than we are finnished 
                    bne      sound_not_done\?             ; with this sample, otherwise we continue further below 
; if we are done, should we restart?
sound_done\?: 
                    lda      digit_looping                ; is this sample a looping one? 
                    sta      digit_is_playing             ; store it to is_playing 
                    beq      timer_restart_only\?         ; if none looping... we are done 
                                                          ; but we still must use the timer 
; ok, for restart, we only change current position
                    ldy      digit_end_pos                ; load the start position 
                                                          ; this is the end_position of the sample, 
                                                          ; since we go backwards 
                    bra      timer_restart_only\?         ; and restart the timer, next byte 

                                                          ; is played next round... 
; here our normal 'digit_byte_playing_section'
sound_not_done\?: 
                    lda      ,-y                          ; load the next sample_byte to A 
; and store it to the 6522 -> PSG
                    sta      VIA_port_a                   ; store in reg A in 6522 (DAC) 
; following must come after the above, or we
; put noise to the psg,
; likewise, before storing anything else to
; port A, we will disable the connection to PSG
                    SET_VIAB_WITH_VARIABLE                ; this sets the MUX of 6522 to PSG 
sound_restart_timer\?: 
                    inc      VIA_port_b                   ; and disable the mux, so no junk will 
                                                          ; enter our PSG-DAC... 
timer_restart_only\?: 
                    RESTART_TIMER                         ; restart timer... 
makro_rts\?: 
                    endm                                  ; end of macro 

; uses for a scalefactor of 50
; about 100+... cycles (could still be optimized further)
MOVE_TO_D_DIGIT     macro    
                    pshs     d                            ; save the position 
                    NEXT_DIGIT_BYTE_FASTER_NO_I           ; play one sample_byte 
                    puls     d                            ; restore position 
                    sta      VIA_port_a                   ; Store Y in D/A register 
                    lda      #$CE                         ; Blank low, zero high? 
                    sta      VIA_cntl                     ; 
                    clra     
                    sta      VIA_port_b                   ; Enable mux 
                    sta      VIA_shift_reg                ; Clear shift regigster 
                    inc      VIA_port_b                   ; Disable mux 
                                                          ; PSHS D ; save the position 
                                                          ; NEXT_DIGIT_BYTE_FASTER_NO_I ; play one sample_byte 
                                                          ; PULS D ; restore position 
                    stb      VIA_port_a                   ; Store X in D/A register 
                    sta      VIA_t1_cnt_hi                ; enable timer 
                    ldb      #$40                         ; t1 flag 
wait_for_t1\?: 
                    bitb     VIA_int_flags                ; 
                    beq      wait_for_t1\? 
                    endm     

;***************************************************************************
; uses for a scalefactor of 50
; exactly 51 cycles (could still be optimized further)
DRAW_LINE_D_DIGIT   macro    
                    sta      VIA_port_a                   ; Send Y to A/D 
                    clr      VIA_port_b                   ; Enable mux switched 
                    leax     2,x                          ; Point to next coordinate pair X=X+2 
                    nop                                   ; Wait a moment 
                    inc      VIA_port_b                   ; Disable mux 
                    stb      VIA_port_a                   ; Send X to A/D 
                    ldd      #$FF00                       ; Shift reg=$FF (solid line), T1H=0 
                    sta      VIA_shift_reg                ; Put pattern in shift register 
                    stb      VIA_t1_cnt_hi                ; Set T1H (scale factor), enabling t1 
                    ldd      #$0040                       ; B-reg = T1 interrupt bit 
wait_for_t1\?: 
                    bitb     VIA_int_flags                ; 
                    beq      wait_for_t1\? 
                    nop      
                    sta      VIA_shift_reg                ; Clear shift register (blank output) 
                    endm     

;***************************************************************************
; uses 8 cycles
; (in relation to the last done digital output)
; only one vector drawn for now...
; could probably be doubled (2*51 < 130)
DRAW_VLC_DIGIT      macro    
                    NEXT_DIGIT_BYTE_FASTER_NO_I           ; play one sample-byte 
                    lda      ,x+                          ; load # of lines in this list 
DRAW_VLA_DIGIT\?: 
                    sta      $C823                        ; helper RAM, here we store the # of lines 
                    ldd      ,x                           ; load y, x 
                    DRAW_LINE_D_DIGIT                     ; draw the line 
                    NEXT_DIGIT_BYTE_FASTER_NO_I           ; and play one sample-byte 
                    lda      $C823                        ; load line count 
                    deca                                  ; decrement it 
                    bpl      DRAW_VLA_DIGIT\?             ; go back for more points if not below 0 
                    endm     

;***************************************************************************
; uses 0 cycles
; (in relation to the last done digital output)
; a wait_recal routine for the sample... output
WAIT_RECAL_DIGIT    macro    
wait_for_next_digit\?: 
                    NEXT_DIGIT_BYTE_FASTER_NO_I           ; play one sample-byte 
                    lda      digit_recal_counter          ; load # of time_outs 
                    cmpa     #RECAL_COUNTER_RESET         ; # should we recalibrate now? 
                    blo      wait_for_next_digit\?        ; if not yet... loop till the time is right 
; now we move out of bounds
; five times the move should about be 255 (ff) scalefactor :-?
                    lda      #5                           ; loop 5 times 
                    sta      $C823                        ; store that 
recal_loop1\?: 
                    ldd      #$7F7F                       ; load the next pos, super long saturation 
                    bsr      move_to_d_digitj             ; move to d -> must be achieved 
                    dec      $C823                        ; done yet with out 5? 
                    bne      recal_loop1\?                ; not yet? than loop 
                    ldb      #$CC 
                    stb      VIA_cntl                     ; blank low and zero low 
; five times the move should about be 255 (ff) scalefactor :-?
                    lda      #5                           ; loop 5 times 
                    sta      $C823                        ; store that 
recal_loop2\?: 
                    ldd      #$8080                       ; load the next pos, super long saturation 
                    bsr      move_to_d_digitj             ; move to d -> must be achieved 
                    dec      $C823                        ; done yet with out 5? 
                    bne      recal_loop2\?                ; not yet? than loop 
                    ldb      #$CC 
                    stb      VIA_cntl                     ; /BLANK low and /ZERO low 
                    ldd      #$0302 
                    sta      VIA_port_b                   ; mux=1, disable mux 
                    clr      VIA_port_a                   ; clear D/A register 
                    stb      VIA_port_b                   ; mux=1, enable mux 
                    stb      VIA_port_b                   ; do it again 
                    ldb      #$01 
                    stb      VIA_port_b                   ; disable mux 
                    lda      #RECAL_COUNTER_RESET         ; load our calculated reset value 
                    sta      digit_recal_counter          ; and store it to our timer counter... 
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
                    std      digit_start_pos              ; store new start position 
                    stx      digit_length                 ; store the length 
                    tfr      x,d                          ; move X to D 
                    addd     digit_start_pos              ; calculate end position 
                    std      digit_end_pos                ; and store it 
                    lda      #0                           ; looping per default is OFF 
                    sta      digit_looping                ; store it 
                    lda      #1                           ; sound is playing is ON 
                    sta      digit_is_playing             ; sound is playing 
                    SET_VIAB_INTERN                       ; calculate out first VIA B poke 
                    ldy      digit_end_pos                ; initialize Y to position in sample data 
                    lda      #SCALE_FACTOR_DIGIT          ; set the fixed scale factor we will use... 
                    sta      VIA_t1_cnt_lo                ; move to time 1 lo, this means scaling 
                    RESTART_TIMER                         ; set our timer 2 for the first time... 
                    rts                                   ; back 

;***************************************************************************
; now the makros from above as functions...
; shortens the source...
;***************************************************************************
wait_recal_digitj: 
                    WAIT_RECAL_DIGIT  
                    rts      

;***************************************************************************
; position in D
move_to_d_digitj: 
                    MOVE_TO_D_DIGIT  
                    rts      

;***************************************************************************
; vector list in X
draw_vlc_digitj: 
                    DRAW_VLC_DIGIT  
                    rts      

;***************************************************************************
; intensity in A
intensity_a_digitj: 
                    INTENSITY_A_DIGIT  
                    rts      

;***************************************************************************
Char_Table equ $F9D4
Char_Table_End equ $Fbb4
; String pointer in D
Print_Str_digit:      
                std     Vec_Str_Ptr     ;Save string pointer
                NEXT_DIGIT_BYTE_FASTER_NO_I
                ldx     #Char_Table     ;Point to start of chargen bitmaps
                ldd     #$1883          ;a->AUX: b->ORB: $8x = Disable RAMP, Disable Mux, mux sel = 01 (int offsets)
                clr     <VIA_port_a     ;Clear D/A output
                sta     <VIA_aux_cntl   ;Shift reg mode = 110 (shift out under system clock), T1 PB7 disabled, one shot mode
                ldx     #Char_Table     ;Point to start of chargen bitmaps
                ; first entry here, ramp is disabled
                ; if there was a jump from below
                ; ramp will be enabled by next line
LF4A5:          stb     <VIA_port_b     ;ramp off/on set mux to channel 1
                dec     <VIA_port_b     ;Enable mux
                ldd     #$8081          ;both to ORB, both disable ram, mux sel = 0 (y int), a:->enable mux: b:->disable mux
                nop                     ;Wait a moment
                inc     <VIA_port_b     ;Disable mux
                stb     <VIA_port_b     ;Disable RAMP, set mux to channel 0, disable mux
                sta     <VIA_port_b     ;Enable mux
                tst     $C800           ;I think this is a delay only
                inc     <VIA_port_b     ;disable mux


                lda     Vec_Text_Width  ;Get text width
                sta     <VIA_port_a     ;Send it to the D/A
                ldd     #$0100	         ;both to ORB, both ENABLE RAMP, a:-> disable mux, b:-> enable mux
                ldu     Vec_Str_Ptr     ;Point to start of text string
                sta     <VIA_port_b     ;[4]enable RAMP, disable mux
                bra     LF4CB	         ;[3]
; one letter is drawn (one row that is) in 18 cycles
; 13 cycles overhead
; ramp is thus active for #ofLetters*18 + 13 cycles
LF4C7:          lda     a,x             ;[+5]Get bitmap from chargen table
                sta     <VIA_shift_reg  ;[+4]rasterout of char bitmap "row" thru shift out in shift register
LF4CB:          lda     ,u+             ;[+6]Get next character
                bpl     LF4C7           ;[+3]Go back if not terminator
                lda     #$81	         ;[2]disable mux, disable ramp 
                sta     <VIA_port_b     ;[4]disable RAMP, disable mux
                neg     <VIA_port_a     ;Negate text width to D/A
                lda     #$01	         ;enable ramp, disable mux
                sta     <VIA_port_b     ;enable RAMP, disable mux
                cmpx    #Char_Table_End ;[4]Check for last row
                beq     LF50A           ;[3]Branch if last row
                leax    $50,x           ;[3]Point to next chargen row
                tfr     u,d             ;[6]Get string length
                subd    Vec_Str_Ptr     ;[7] 
                subb    #$02            ;[2] -  2 
                aslb                    ;[2] *  2 calculate return "way"
                brn     LF4EB           ;[3]Delay a moment
LF4EB:          lda     #$81            ;[2]disable RAMP, disable mux
                nop		         ;[2]
                decb                    ;[2]
                bne     LF4EB           ;Delay some more in a loop
                sta     <VIA_port_b     ;disable RAMP, disable mux

; d can be destroyed here!
                NEXT_DIGIT_BYTE_FASTER_NO_I
                lda     #$81            ;[2]disable RAMP, disable mux
                sta     <VIA_port_b     ;disable RAMP, disable mux

                ldb     Vec_Text_Height ;Get text height
                stb     <VIA_port_a     ;Store text height in D/A [go down -> later]
                dec     <VIA_port_b     ;Enable mux
                ldd     #$8101
                nop                     ;Wait a moment
                sta     <VIA_port_b     ;disable RAMP, disable mux
                clr     <VIA_port_a     ;Clear D/A
                stb     <VIA_port_b     ;enable RAMP, disable mux
                sta     <VIA_port_b     ;disable RAMP, disable mux
                ldb     #$03            ;$0x = ENABLE RAMP?
                bra     LF4A5           ;Go back for next scan line

LF50A:          lda     #$98
                sta     <VIA_aux_cntl   ;T1->PB7 enabled

                NEXT_DIGIT_BYTE_FASTER_NO_I


                jmp     Reset0Ref       ;Reset the zero reference
