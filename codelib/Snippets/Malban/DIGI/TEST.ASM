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

;
; I used the 6809 assembler:
; as09 [1.11].
; Copyright 1990-1994, Frank A. Vorstenbosch, Kingswood Software.
; Available at:
; http://www.falstaff.demon.co.uk/cross.html
;
                INCLUDE "VECTREX.I" ; vectrex function includes

; This is the single most important variable...
; for different sample frequency, THIS must be adjusted...
; 140 for 8KHz samples
; 300 for 4KHz samples
; ??? for ?KHz samples
T2_TIMER_PEROID_REAL    EQU 300
T2_TIMER_PEROID_LO      EQU lo(T2_TIMER_PEROID_REAL-(256*(T2_TIMER_PEROID_REAL/256)))
T2_TIMER_PEROID_HI      EQU lo(T2_TIMER_PEROID_REAL/256)
T2_TIMER_PEROID         EQU T2_TIMER_PEROID_HI+256*T2_TIMER_PEROID_LO

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
; about 70  for 4 kHz
; about 135 for 8 kHz
; this means only this many times our samples can be called
; this also means the way it is implemented now...
; only about that many vectors can be drawn
;
; in order to be able to draw more vectors, the DRAW_VLC
; function must be changed, so that more than just one vector is
; drawn between two samples (can easily be done)
RECAL_COUNTER_RESET     EQU (30000/(T2_TIMER_PEROID_REAL + 71 + 50) )


; sort of a state machine :-), only relevant for the 'demo'
; these are the three states!
DEMO_LEFT               EQU 0
DEMO_RIGHT              EQU 1
DEMO_FROGGER            EQU 2

; user variable definitions
; $c880
user_ram                        EQU    $c880              ; well start of our ram space
user_ram_start                  EQU    user_ram

via_b_start                     EQU    user_ram ; 1
digit_sound_struct              EQU    via_b_start + 1
digit_is_playing                EQU    digit_sound_struct + 0 ; 1
digit_start_pos                 EQU    digit_sound_struct + 1 ; 1
digit_length                    EQU    digit_sound_struct + 2 ; 2
digit_looping                   EQU    digit_sound_struct + 4 ; 1
digit_current_pos               EQU    digit_sound_struct + 5 ; 2
digit_end_pos                   EQU    digit_sound_struct + 7 ; 2
digit_counter                   EQU    digit_sound_struct + 9 ; 2
digit_recal_counter             EQU    digit_sound_struct + 11; 1
digit_sound_struct_end          EQU    digit_sound_struct + 12;

demo_state                      EQU    digit_sound_struct_end ; 1

; this sets the timer to our restart value
RESTART_TIMER    macro                     ; name of macro
                 LDD     #T2_TIMER_PEROID  ; load the timer 2 value we calculated
                 STD     VIA_t2_lo         ; and set the timer
                 endm                      ; end of macro

; this sets VIA B to our known sample state...
SET_VIAB_WITH_VARIABLE macro               ; name of macro
                 LDA     via_b_start       ; load the calculated VIA B
                 STA     VIA_port_b        ; write back to reg B in 6522
                 endm                      ; end of macro

; this calculates our sample state for VIA B
SET_VIAB_INTERN  macro                     ; name of macro
                 LDA     VIA_port_b        ; data reg B from 6522
                 ANDA    #$f8              ; save top 5 bits, mask off bottom 3
                 ORA     #$06              ; set S/H, SEL 0, SEL 1
                 STA     via_b_start       ; and remember it
                 endm                      ; end of macro

; this is a waiter, for our current sample-byte to finnish
WAIT_FOR_NEXT_DIGIT macro                  ; name of macro
wait_for_next_digit\?:
                 LDB     #$0020            ; B-reg = T2 interrupt bit
                 BITB    VIA_int_flags     ; Wait for T2 to time out
                 BEQ     wait_for_next_digit\?; repeat
                 endm                      ; end of macro

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

; Kills D
; must ALLWAYS have Y, U, U contains the length of the sample, Y the position
; must ALLWAYS have Timer 2
;
; Kills and VIA port B and A
; cycles left = 130 (with clays digitized sound = 8Khz)
; cycles left = 300 (4Khz)
;
; uses 27+30 cycles when completely done, without restart
; uses 51+30 cycles when completely done, with restart
; uses 32+30 cycles when one digitized sound byte was played.
; + 9
;
; => Interrupts are not worth it...
;
NEXT_DIGIT_BYTE_FASTER_NO_I macro          ; name of macro
; load current digit byte and increment counter
                 DEC     digit_recal_counter; decrement our counter, used for wait_recal
                 TST     digit_is_playing  ; is there a digital sample to be played?
                 BEQ     timer_restart_only\?; no, than jump out of here
                 WAIT_FOR_NEXT_DIGIT       ; otherwise we wait till the last played
                                           ; sample-byte is finnished
                 LDA     ,-U               ; this one is in truth only a U=U-1
                 CMPU    #0                ; if it is zero, than we are finnished
                 BNE     sound_not_done\?  ; with this sample, otherwise we continue further below

; if we are done, should we restart?
sound_done\?:
                 LDA     digit_looping     ; is this sample a looping one?
                 STA     digit_is_playing  ; store it to is_playing
                 BEQ     timer_restart_only\?; if none looping... we are done
                                           ; but we still must use the timer
; ok, for restart, we only change current position
                 LDU     digit_counter     ; load the counter to U
                 LDY     digit_end_pos     ; load the start position
                                           ; this is the end_position of the sample,
                                           ; since we go backwards
                 BRA     timer_restart_only\?; and restart the timer, next byte
                                           ; is played next round...
; here our normal 'digit_byte_playing_section'
sound_not_done\?:
                 LDA     ,-Y               ; load the next sample_byte to A
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

; uses for a scalefactor of 50
; about 100+... cycles (could still be optimized further)
;
MOVE_TO_D_DIGIT  macro
                 PSHS    D                 ; save the position
                 NEXT_DIGIT_BYTE_FASTER_NO_I; play one sample_byte
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
; uses for a scalefactor of 50
; exactly 51 cycles (could still be optimized further)
;
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
                 NEXT_DIGIT_BYTE_FASTER_NO_I; play one sample-byte
                 LDA     ,X+               ; load # of lines in this list
DRAW_VLA_DIGIT\?:
                 STA     $C823             ; helper RAM, here we store the # of lines
                 LDD     ,X                ; load y, x
                 DRAW_LINE_D_DIGIT         ; draw the line
                 NEXT_DIGIT_BYTE_FASTER_NO_I; and play one sample-byte
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
                 NEXT_DIGIT_BYTE_FASTER_NO_I; play one sample-byte
                 LDA     digit_recal_counter; load # of time_outs
                 CMPA    #RECAL_COUNTER_RESET; # should we recalibrate now?
                 BLO     wait_for_next_digit\?; if not yet... loop till the time is right

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
                 NEXT_DIGIT_BYTE_FASTER_NO_I; and do one sample-byte
                 endm
;***************************************************************************

;***************************************************************************
                 ORG     0
; start of vectrex memory with cartridge name...
                 DB      "g GCE 1998", $80 ; 'g' is copyright sign
                 DW      music             ; music from the rom
                 DB      $F8, $50, $20, -$80; hight, width, rel y, rel x (from 0,0)
                 DB      "LINES + DIGITIZED SOUND", $80; some game information, ending with $80
                 DB      0                 ; end of game header
;***************************************************************************
; here the cartridge program starts off


                 direct  $d0

                 LDD     #FROGGER_START    ; position of sample
                 LDX     #FROGGER_LENGTH   ; length of sample
                 JSR     init_digit_sound  ; init it!

                 LDA     #DEMO_FROGGER     ; init state'machine' to FROGGER
                 STA     demo_state        ; and set it
main:
                 ; first allways is a wait_recal, as usual
                 JSR     wait_recal_digitj ; same as makro: WAIT_RECAL_DIGIT

                 ; set some intensity for our to be displayed vectors
                 LDA     #$7f              ; seems about bright enough
                 JSR     intensity_a_digitj; and set the intensity
                                           ; same as makro: INTENSITY_A_DIGIT

                 ; and jump to the state we are in...
                 LDA     demo_state        ; load current state
                 CMPA    #DEMO_LEFT        ; is it LEFT?
                 BEQ     left_frog         ; than go there, otherwise
                 CMPA    #DEMO_RIGHT       ; is it RIGHT?
                 BEQ     right_frog        ; than go there, otherwise
                 CMPA    #DEMO_FROGGER     ; is it FROGGER?
                 BEQ     frogger_only      ; than go there, otherwise
                 BRA     main              ; default... should never be here
right_frog:
                 ; this draws the right frog
                 LDD     #$60              ; some position, y=0, x=$60
                 JSR     move_to_d_digitj  ; move to D
                                           ; same as makro: MOVE_TO_D_DIGIT
                 LDX     #frogger_left     ; load vector list
                 JSR     draw_vlc_digitj   ; and display it
                                           ; same as makro: DRAW_VLC_DIGIT

                 LDA     digit_is_playing  ; are we still playing a sample?
                 BNE     main              ; yep? than go back to main
                 LDA     #DEMO_LEFT        ; otherwise initialize the next state
                 STA     demo_state        ; to LEFT and store it here
                 LDD     #LEFT_START       ; position of LEFT-sample
                 LDX     #LEFT_LENGTH      ; length of LEFT-sample
                 JSR     init_digit_sound  ; and initialize the sound...
                 BRA     main              ; back to main loop

left_frog:
                 ; this draws the right frog
                 ; first move it, this is cumbersome, due to the fixed
                 ; scale factor
                 LDA     #-$2b             ; load y
                 LDB     #-$50             ; load x
                 JSR     move_to_d_digitj  ; and move there...
                                           ; same as makro: MOVE_TO_D_DIGIT
                 LDA     #-$2b             ; load y
                 LDB     #-$50             ; load x
                 JSR     move_to_d_digitj  ; and move there...
                                           ; same as makro: MOVE_TO_D_DIGIT
                 LDA     #-$2b             ; load y
                 LDB     #-$50             ; load x
                 JSR     move_to_d_digitj  ; and move there...
                                           ; same as makro: MOVE_TO_D_DIGIT
                 LDA     #-$2b             ; load y
                 LDB     #-$50             ; load x
                 JSR     move_to_d_digitj  ; and move there...
                                           ; same as makro: MOVE_TO_D_DIGIT

                 LDX     #frogger_right    ; load right vector list
                 JSR     draw_vlc_digitj   ; and draw it
                                           ; same as makro: DRAW_VLC_DIGIT

                 LDA     digit_is_playing  ; are we still playing a sample?
                 BNE     main              ; yep? than go back to main
                 LDA     #DEMO_FROGGER     ; otherwise initialize the next state
                 STA     demo_state        ; to FROGGER and store it here
                 LDD     #FROGGER_START    ; position of FROGGER-sample
                 LDX     #FROGGER_LENGTH   ; length of FROGGER-sample
                 JSR     init_digit_sound  ; and initialize the sound...
                 BRA     main              ; back to main loop

frogger_only:
                 LDA     digit_is_playing  ; are we still playing a sample?
                 BNE     main              ; yep? than go back to main
                 LDA     #DEMO_RIGHT       ; otherwise initialize the next state
                 STA     demo_state        ; to RIGHT and store it here
                 LDD     #RIGHT_START      ; position of RIGHT-sample
                 LDX     #RIGHT_LENGTH     ; length of RIGHT-sample
                 JSR     init_digit_sound  ; and initialize the sound...
                 BRA     main              ; back to main loop
;***************************************************************************
; expects startposition in D
; expects length in X
;
; sets up Y and U register, these should under no circumstances be destroyed
init_digit_sound:
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
                 
                 LDU     digit_counter     ; initialize U to length, this will be counted down...
                 LDY     digit_end_pos     ; initialize Y to position in sample data

                 LDA     #SCALE_FACTOR_DIGIT; set the fixed scale factor we will use...
                 STA     VIA_t1_cnt_lo     ; move to time 1 lo, this means scaling
                 RESTART_TIMER             ; set our timer 2 for the first time...
                 RTS                       ; back
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

;***************************************************************************
music:
        FDB     $ff16,$feb6
        FCB     $00,  $80

SPRITE_BLOW_UP                  EQU 25        ; thru this sprites get a possible max of 5 * 25 = 125 (pretty near 127...)
frogger_left:
                DB 17
                DB -1*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB -4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB  4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -3*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  4*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP

frogger_right:
                DB 17
                DB  1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  1*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                DB  2*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB -2*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                DB -4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                DB  4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                DB -3*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                DB -1*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                DB  0*SPRITE_BLOW_UP, -4*SPRITE_BLOW_UP

sample_start:
 include "LEFT.BIN.asm"
 include "RIGHT.BIN.asm"
 include "FROGGER.BIN.asm"
; where are the samples?
; this must follow after the above 'sample_start' definition!
; otherwise the assembler doesn't calculate 'sample_start' properly
LEFT_START              EQU sample_start
LEFT_LENGTH             EQU 2018

RIGHT_START             EQU LEFT_START + LEFT_LENGTH
RIGHT_LENGTH            EQU 1746

FROGGER_START           EQU RIGHT_START + RIGHT_LENGTH
FROGGER_LENGTH          EQU 2226

