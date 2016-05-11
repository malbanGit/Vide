;
; I used the 6809 assembler:
; as09 [1.11].
; Copyright 1990-1994, Frank A. Vorstenbosch, Kingswood Software.
; Available at:
; http://www.falstaff.demon.co.uk/cross.html
;
                INCLUDE "VECTREX.I" ; vectrex function includes



; PUBLIC macros:
; INTENSITY_A_DIGIT -> set intensity to A uses ## cycles
; NEXT_DIGIT_BYTE
; MOVE_TO_D_DIGIT
; WAIT_RECAL_DIGIT -> uses 0 cycles

; INIT_SOUND_DIGIT -> ; expects startposition in D, expects length in X

; plays digitized sound, while displaying vectors
; first try was using interrupts, but handling them used to much
; time.
; therefor I switched to using timer 2 (without interrupt handling) only,
; that means in order to recalibrate I somehow have to keep track of
; system time
; the sound digitized routine pretty much allways uses ## cycles
; and I nearly have to call it every ### cycles
; which means I have to built
; uniform vector drawing routines, which also
; means some sort of fixed (or at least KNOWN) scalefactors to use
; (for positioning AND drawining AND recalibration!)
;
; I must use vector functions which allways use exactly the
; same cycles, so that I can calculate for the recalibration-needed 30000
; cycles...
; actually it is enough to insure that those function do not take longer
; than the 'pause' between our sample-byte-outputs

; samples must be:
; 8 bit mono signed
; different sample-frequency can be used, provided
; the constant "T2_TIMER_PEROID_REAL" is set to a appropriate value
; for now this routine playes all samples 'backwards'
; -> so you also have to turn your samples arround :-)


; This is the single most important variable...
; for different sample frequency, THIS must be adjusted...
; 140 for 8KHz samples
; 330 for 4KHz samples
; 700 for 2KHz samples
; 1400 for 1KHz samples
; ...
T2_TIMER_PEROID_REAL    EQU 700 ; 2K samples about that many cycles between update of samples
T2_TIMER_PEROID_LO      EQU lo(T2_TIMER_PEROID_REAL-(256*(T2_TIMER_PEROID_REAL/256)))
T2_TIMER_PEROID_HI      EQU lo(T2_TIMER_PEROID_REAL/256)
T2_TIMER_PEROID         EQU T2_TIMER_PEROID_HI+256*T2_TIMER_PEROID_LO


; it is enough if we don't miss a sample
; that means in between our about 700 cycle we can
; do whatever we want!
; we must use a fixed scale value, since  somehow we must
; calculate the wait_recal
; (actually we MUST asure, that we stay not for more time in the
;  move_to_d or draw_vlc functions, this is sort of a delimiter)
; it should be ok, to use smaller values,
; this (50) value was ment for use with 8kHz samples,
; for 4kHz samples it could probably be doubled...
; (without changing anything else)
SCALE_FACTOR_DIGIT      EQU 50

; 30000 cycles per wait_recal
; divided by T2_TIMER_PEROID_REAL + length of one digital sample play + offset for use of jsr's...
; about 35  for 2 kHz
; about 70  for 4 kHz
; about 135 for 8 kHz
; this means only this many times our samples can be called
; this also means the way it is implemented now...
; only about that many vectors can be drawn
;
; in order to be able to draw more vectors, the DRAW_VLC
; function must be changed, so that more than just one vector is
; drawn between two samples (can easily be done)

; must be corrected by the additions 13.03.2000
RECAL_COUNTER_RESET     EQU (30000/(T2_TIMER_PEROID_REAL + 71 + 50) )


; ***************************************************************************
; this sets the timer to our restart value
RESTART_TIMER    macro                     ; name of macro
                 LDD     #T2_TIMER_PEROID  ; load the timer 2 value we calculated
                 STD     VIA_t2_lo         ; and set the timer
                 endm                      ; end of macro

; ***************************************************************************
; this sets VIA B to our known sample state...
SET_VIAB_WITH_VARIABLE macro               ; name of macro
                 LDA     via_b_start       ; load the calculated VIA B
                 STA     VIA_port_b        ; write back to reg B in 6522
                 endm                      ; end of macro

; ***************************************************************************
; this calculates our sample state for VIA B
SET_VIAB_INTERN  macro                     ; name of macro
                 LDA     VIA_port_b        ; data reg B from 6522
                 ANDA    #$f8              ; save top 5 bits, mask off bottom 3
                 ORA     #$06              ; set S/H, SEL 0, SEL 1
                 STA     via_b_start       ; and remember it
                 endm                      ; end of macro

; ***************************************************************************
; this is a waiter, for our current sample-byte to finnish
WAIT_FOR_NEXT_DIGIT macro                  ; name of macro
wait_for_next_digit\?:
                 LDB     #$0020            ; B-reg = T2 interrupt bit
                 BITB    VIA_int_flags     ; Wait for T2 to time out
                 BEQ     wait_for_next_digit\?; repeat
                 endm                      ; end of macro

; ***************************************************************************
; well, not really a 'digit' function... but it does what it's called
INTENSITY_A_DIGIT macro
                 STA     Vec_Brightness    ; Save intensity in $C827
                 STA     VIA_port_a        ; Store intensity in D/A
                 LDD     #$0504            ; mux disabled channel 2
                 STA     VIA_port_b        ;
                 STB     VIA_port_b        ; mux enabled channel 2
                 STB     VIA_port_b        ; do it again just because ?
                 LDB     #$01              ;
                 STB     VIA_port_b        ; turn off mux
                 endm

; ***************************************************************************
; Kills D
; must ALLWAYS have Y the position
; must ALLWAYS have Timer 2
;
; Kills and VIA port B and A
; cycles left = 130 (with clays digitized sound = 8Khz)
; cycles left = 300 (4Khz)
;
; 13.03.2000 counting not correct anymore !!!
; uses 27+30 cycles when completely done, without restart
; uses 51+30 cycles when completely done, with restart
; uses 32+30 cycles when one digitized sound byte was played.
; + 9
;
; => Interrupts are not worth it...
;
NEXT_DIGIT_BYTE macro          ; name of macro
; load current digit byte and increment counter
                 DEC     digit_recal_counter; decrement our counter, used for wait_recal
                 TST     digit_is_playing  ; is there a digital sample to be played?
                 BEQ     timer_restart_only\?; no, than jump out of here
                 WAIT_FOR_NEXT_DIGIT       ; otherwise we wait till the last played
                                           ; sample-byte is finnished
                 LDA     ,-Y               ; load the next sample_byte to A
                 CMPY    digit_start_pos
                 BNE     sound_not_done\?  ; with this sample, otherwise we continue further below

; if we are done, should we restart?
sound_done\?:
                 LDB     digit_looping     ; is this sample a looping one?
                 STB     digit_is_playing  ; store it to is_playing
                 BEQ     timer_restart_only\?; if none looping... we are done
                                           ; but we still must use the timer

; ok, for restart, we only change current position
                 LDY     digit_end_pos     ; load the start position
                                           ; this is the end_position of the sample,
                                           ; since we go backwards
                 BRA     timer_restart_only\?; and restart the timer, next byte
                                           ; is played next round...
; here our normal 'digit_byte_playing_section'
sound_not_done\?:
                 ; load the next sample_byte to A
; and store it to the 6522 -> PSG
                 STA     VIA_port_a        ; store in reg A in 6522 (DAC)
; following must come after the above, or we
; put noise to the psg,
; likewise, before storing anything else to
; port A, we will disable the connection to PSG
                 SET_VIAB_WITH_VARIABLE    ; this sets the MUX of 6522 to PSG
sound_restart_timer\?:
                 CLR     VIA_shift_reg     ; Clear shift regigster, why ???
                                           ; without it, the display 'wobbles' a bit???
                 INC     VIA_port_b        ; and disable the mux, so no junk will
                                           ; enter our PSG-DAC...
timer_restart_only\?:
                 RESTART_TIMER             ; restart timer...
makro_rts\?:
                 endm                      ; end of macro

; ***************************************************************************
; uses for a scalefactor of 50
; about 100+... cycles (could still be optimized further)
;
MOVE_TO_D_DIGIT  macro
                 PSHS    D                 ; save the position
                 NEXT_DIGIT_BYTE           ; play one sample_byte
                 PULS    D                 ; restore position

                 STA     VIA_port_a        ; Store Y in D/A register
                 LDA     #$CE              ; Blank low, zero high?
                 STA     VIA_cntl          ;
                 CLRA
                 STA     VIA_port_b        ; Enable mux
                 STA     VIA_shift_reg     ; Clear shift regigster
                 INC     VIA_port_b        ; Disable mux
                 STB     VIA_port_a        ; Store X in D/A register
                 STA     VIA_t1_cnt_hi     ; enable timer
                 LDB     #$40              ; t1 flag
wait_for_t1\?:
                 BITB    VIA_int_flags     ;
                 BEQ     wait_for_t1\?
                 endm

;***************************************************************************
; exactly 60 with 1 loop (scale minimum 10)
; scale 50 uses 60 + 45 -> 105 cycles
;
; loop 1: 4 + 5 = 9 (branched)
; loop END 1: 4 + 3 = 7 (not branched)
;
; loop 1: 3 + (4 + 5) * 0 + 4 + 3 = 10 (scale)
; loop 2: 3 + (4 + 5) * 1 + 4 + 3 = 19
; loop 3: 3 + (4 + 5) * 2 + 4 + 3 = 28
; loop 4: 3 + (4 + 5) * 3 + 4 + 3 = 37
; loop 5: 3 + (4 + 5) * 4 + 4 + 3 = 46
; loop 6: 3 + (4 + 5) * 5 + 4 + 3 = 55
;
; minimum 1 loop = 3 + 4 + 3 = 10 -> minimum scale possible = 10
; -> per additional loop + 7
DRAW_LINE_D_DIGIT macro
                 STA     VIA_port_a        ; Send Y to A/D
                 CLR     VIA_port_b        ; Enable mux switched
                 LEAX    2,X               ; Point to next coordinate pair X=X+2
                 NOP                       ; Wait a moment
                 INC     VIA_port_b        ; Disable mux
                 STB     VIA_port_a        ; Send X to A/D
                 LDD     #$FF00            ; Shift reg=$FF (solid line), T1H=0
                 STA     VIA_shift_reg     ; Put pattern in shift register
                 STB     VIA_t1_cnt_hi     ; Set T1H (scale factor), enabling t1
                 LDD     #$0040            ; B-reg = T1 interrupt bit
wait_for_t1\?:
                 BITB    VIA_int_flags     ;
                 BEQ     wait_for_t1\?
                 NOP
                 STA     VIA_shift_reg     ; Clear shift register (blank output)
                 endm
;***************************************************************************
;
; uses 8 cycles
; (in relation to the last done digital output)
; only one vector drawn for now...
; could probably be doubled (2*51 < 130)
;
DRAW_VLC_DIGIT   macro
                 NEXT_DIGIT_BYTE; play one sample-byte
                 LDA     ,X+               ; load # of lines in this list
DRAW_VLA_DIGIT\?:
                 STA     $C823             ; helper RAM, here we store the # of lines
                 LDD     ,X                ; load y, x
                 DRAW_LINE_D_DIGIT         ; draw the line
                 NEXT_DIGIT_BYTE; and play one sample-byte
                 LDA     $C823             ; load line count
                 DECA                      ; decrement it
                 BPL     DRAW_VLA_DIGIT\?  ; go back for more points if not below 0
                 endm

;***************************************************************************
; uses 0 cycles
; (in relation to the last done digital output)
; a wait_recal routine for the sample... output
WAIT_RECAL_DIGIT macro

wait_for_next_digit\?:
                 NEXT_DIGIT_BYTE; play one sample-byte
                 LDA     digit_recal_counter; load # of time_outs
                 CMPA    #RECAL_COUNTER_RESET; # should we recalibrate now?
                 BLO     wait_for_next_digit\?; if not yet... loop till the time is right
                 LDA     #SCALE_FACTOR_DIGIT; set the fixed scale factor we will use...
                 STA     VIA_t1_cnt_lo     ; move to time 1 lo, this means scaling

; now we move out of bounds
; five times the move should about be 255 (ff) scalefactor :-?
                 LDA     #5                ; loop 5 times
                 STA     $C823             ; store that
recal_loop1\?:
                 LDD     #$7F7F            ; load the next pos, super long saturation
                 JSR     move_to_d_digitj  ; move to d -> must be achieved
                 DEC     $C823             ; done yet with out 5?
                 BNE     recal_loop1\?     ; not yet? than loop

                 LDB     #$CC
                 STB     VIA_cntl          ; blank low and zero low

; five times the move should about be 255 (ff) scalefactor :-?
                 LDA     #5                ; loop 5 times
                 STA     $C823             ; store that
recal_loop2\?:
                 LDD     #$8080            ; load the next pos, super long saturation
                 JSR     move_to_d_digitj  ; move to d -> must be achieved
                 DEC     $C823             ; done yet with out 5?
                 BNE     recal_loop2\?     ; not yet? than loop


                 LDB     #$CC
                 STB     VIA_cntl          ; /BLANK low and /ZERO low

                 LDD     #$0302
                 STA     VIA_port_b        ; mux=1, disable mux
                 CLR     VIA_port_a        ; clear D/A register
                 STB     VIA_port_b        ; mux=1, enable mux
                 STB     VIA_port_b        ; do it again
                 LDB     #$01
                 STB     VIA_port_b        ; disable mux

                 LDA     #RECAL_COUNTER_RESET; load our calculated reset value
                 STA     digit_recal_counter; and store it to our timer counter...

                 SET_VIAB_INTERN            ; rethink our VIAB value
                 NEXT_DIGIT_BYTE; and do one sample-byte
                 endm
;***************************************************************************
; expects startposition in D
; expects length in X
;
; sets up Y register, this should under no circumstances be destroyed
INIT_SOUND_DIGIT macro
                 STD     digit_start_pos   ; store new start position

                 STX     digit_length      ; store the length
                 STX     digit_counter     ; same in counter...

                 TFR     X,D               ; move X to D
                 ADDD    digit_start_pos   ; calculate end position
                 STD     digit_end_pos     ; and store it

                 LDA     #0                ; looping per default is OFF
                 STA     digit_looping     ; store it
                 LDA     #1                ; sound is playing is ON
                 STA     digit_is_playing  ; sound is playing

                 SET_VIAB_INTERN           ; calculate out first VIA B poke

                 LDY     digit_end_pos     ; initialize Y to position in sample data

;                 LDA     #SCALE_FACTOR_DIGIT; set the fixed scale factor we will use...
;                 STA     VIA_t1_cnt_lo     ; move to time 1 lo, this means scaling
                 RESTART_TIMER             ; set our timer 2 for the first time...
                 endm
