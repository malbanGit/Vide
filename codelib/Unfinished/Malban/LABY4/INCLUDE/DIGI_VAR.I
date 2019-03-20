; Plays digitized sound, while displaying vectors
;
; This is a second version, DIFFERENT than last one, might be more
; efficient!
;
; Sample output is not guranteed to be 'in time'.
; That means the samples are not send to via with a fixed frequence, rather
; at some frequency that comes near the desired frequency.
; The programmer using these routines must make sure
; the samples are output often enough.
; The provided DRAW, MOVE and RECALIBRATION routines update in correct
; frequencies, the things the programmer does apart from
; these routines... well, is his concern.
; As said above, missing a sample output by some cycles ... doesn't really
; matter.
;
; How it works this time.
; The timer 2 is set as usual to 30000 so that update frequency is 50Hz.
; depending on the sample rate I calculate the next cycle that a sample
; should be put to VIA.
; 2kHz samples should (about) be outputed(?grammar?) every 700 cycles.
; So we should output at:
; 29300, 28600, 27900, ...
;
; The (non public) macro WAIT_FOR_NEXT_DIGIT does wait for the next
; timer position to output a sample (if the timer has not already passed).
; The macro NEXT_DIGIT_BYTE puts the next sample to VIA after calling above
; macro. NEXT_DIGIT_BYTE does not test whether the complete sample has already
; finished playing! NEXT_DIGIT_BYTE should not be put to code randomly
; since it ALLWAYS puts some sort of sample to VIA. That might be WRONG.
; Likewise for optimization, the MOVE and DRAW macros (which do use
; NEXT_DIGIT_BYTE, should not be called when no sample is playing).
;
; If you want to use routines which can allways be used, change below
; MOVE and DRAW macros to use NEXT_DIGIT_BYTE_WITH_TEST.
; Which does test for sample end and sets the variables for checking
; accordingly.
; The provided RECALIBRATION macro uses NEXT_DIGIT_BYTE_WITH_TEST, therefor
; per default a sample is only checked for its end during the recalibration
; phase. This saves considerable time! (about 5000 - 8000 cycles)
;
; Current sample position is stored in register Y.
; Y MUST NOT BE CHANGED!
; (or you have to reprogram the makros below to use a ram slot and not Y)
;
; Routines play sample structures now,
; that way samples might be concatinated on the fly and thus
; reused.
; following is the sample structure:
; Structure of samples
; DB 0      ; is looping 0 or 1
; DW 0, 0   ; start position and length of sample
; DW 0, 0   ; start position and length of sample 2...
; ...
; DW 0      ; finishes with a zero to indicate end of sample!
;
; A sample should have a small buffer behind (befor, since played backwords) it,
; since it is only check during recalibration whether the sample
; is finished.
; Using 2kHz samples playes about 40 = (30000 / T2_TIMER_PEROID_REAL)
; samples per update round
; so -> in worst case we play 39 garbage samples.
;
;
; samples must be:
; 8 bit mono signed
; different sample-frequency can be used, provided
; the constant "T2_TIMER_PEROID_REAL" is set to a appropriate value
; for now this routine playes all samples 'backwards'
; -> so you also have to turn your samples arround :-)
;
;
; I used the 6809 assembler:
; as09 [1.11].
; Copyright 1990-1994, Frank A. Vorstenbosch, Kingswood Software.
; Available at:
; http://www.falstaff.demon.co.uk/cross.html
;
                INCLUDE "INCLUDE/VECTREX.I" ; vectrex function includes
                INCLUDE "INCLUDE/MACROS/BEAM_MAC.I" ; vectrex function includes

; This is the single most important variable...
; for different sample frequency, THIS must be adjusted...
; 140 for 8KHz samples
; 330 for 4KHz samples
; 700 for 2KHz samples
; 1400 for 1KHz samples
; ...
T2_TIMER_PEROID_REAL    EQU (768/256); again a multiple of 256, nice for only hi byte testing! 740 ; 2K samples about that many cycles between update of samples
T2_TIMER_PEROID_LO      EQU lo(T2_TIMER_PEROID_REAL-(256*(T2_TIMER_PEROID_REAL/256)))
T2_TIMER_PEROID_HI      EQU lo(T2_TIMER_PEROID_REAL/256)
T2_TIMER_PEROID         EQU T2_TIMER_PEROID_HI+256*T2_TIMER_PEROID_LO


; ***************************************************************************
; this sets VIA B to our known sample state...
; Kills A
SET_VIAB_WITH_VARIABLE macro               ; name of macro
                 LDA     via_b_start       ; load the calculated VIA B
                 STA     VIA_port_b        ; write back to reg B in 6522
                 endm                      ; end of macro

; ***************************************************************************
; this calculates our sample state for VIA B
; Kills A
SET_VIAB_INTERN  macro                     ; name of macro
                 LDA     VIA_port_b        ; data reg B from 6522
                 ANDA    #$f8              ; save top 5 bits, mask off bottom 3
                 ORA     #$06              ; set S/H, SEL 0, SEL 1
                 STA     via_b_start       ; and remember it
                 endm                      ; end of macro

; ***************************************************************************
; this is a waiter, for our current sample-byte to finnish
; Kills D
WAIT_FOR_NEXT_DIGIT macro                  ; name of macro
wait_for_next_digit\?:
                 LDA     VIA_t2_hi         ; get timer
                                           ; note:
                                           ; by reading the timer we
                                           ; can MISS an interrupt state
                                           ; since reading clears the
                                           ; interrupt!
                                           ; during recalibration this
                                           ; is considered (see below)
                                           ; hopefully we have NO
                                           ; interrupt miss here!
                 CMPA    digit_next_digit_cycle   ; and compare to next
                                                  ; time we should update
                 BGT     wait_for_next_digit\?    ; not yet? than test again
jump\?:
                 SUBA    #T2_TIMER_PEROID_REAL    ; note:
                                                  ; if this thing is called early enough
                                                  ; we could calculate this above
                                                  ; and save some cycles here!
                                                  ; on the other hand, IF we are called early
                                                  ; enough... we don't need to save cycles :-)

                 STA     digit_next_digit_cycle   ; and store it
                 endm                      ; end of macro
; ***************************************************************************
FORCE_DIGIT_PLAY macro
                 LDA     VIA_t2_hi         ; get timer
                 SUBA    #T2_TIMER_PEROID_REAL    ;
                 STA     digit_next_digit_cycle   ; and store it
                 LDA     ,-Y               ; load the next sample_byte to A
                 STA     VIA_port_a        ; store in reg A in 6522 (DAC)
                 SET_VIAB_WITH_VARIABLE    ; this sets the MUX of 6522 to PSG
                 CLR     VIA_shift_reg     ; Clear shift regigster, why ???
                 INC     VIA_port_b        ; and disable the mux, so no junk will
                 endm
; ***************************************************************************

; ***************************************************************************
; this outputs a sample if one is in the queue
; otherwise not,
; not testing if sample is active!
; Kills D
; must ALLWAYS have Y the position
PERHAPS_NEXT_DIGIT macro                  ; name of macro
wait_for_next_digit\?:
                 LDA     VIA_t2_hi         ; get timer
                                           ; note:
                                           ; by reading the timer we
                                           ; can MISS an interrupt state
                                           ; since reading clears the
                                           ; interrupt!
                                           ; during recalibration this
                                           ; is considered (see belowe)
                                           ; hopefully we have NO
                                           ; interrupt miss here!
                 CMPA    digit_next_digit_cycle   ; and compare to next
                                                  ; time we should update
                 BGT     rts_macro\?    ; not yet? than test again
                 SUBA    #T2_TIMER_PEROID_REAL    ; note:
                                                  ; if this thing is called early enough
                                                  ; we could calculate this above
                                                  ; and save some cycles here!
                                                  ; on the other hand, IF we are called early
                                                  ; enough... we don't need to save cycles :-)

                 STA     digit_next_digit_cycle   ; and store it
                 LDA     ,-Y               ; load the next sample_byte to A
                                           ; and store it to the 6522 -> PSG
                 STA     VIA_port_a        ; store in reg A in 6522 (DAC)
                                           ; following must come after the above, or we
                                           ; put noise to the psg,
                                           ; likewise, before storing anything else to
                                           ; port A, we will disable the connection to PSG
                 SET_VIAB_WITH_VARIABLE    ; this sets the MUX of 6522 to PSG
                 CLR     VIA_shift_reg     ; Clear shift regigster, why ???
                                           ; without it, the display 'wobbles' a bit???
                 INC     VIA_port_b        ; and disable the mux, so no junk will
                                           ; enter our PSG-DAC...
rts_macro\?
                 endm                      ; end of macro

; ***************************************************************************
; Kills D
; not testing if sample is active!
; must ALLWAYS have Y the position
;
NEXT_DIGIT_BYTE macro          ; name of macro
                 WAIT_FOR_NEXT_DIGIT       ; wait till the last played
                                           ; sample-byte is finnished
                 LDA     ,-Y               ; load the next sample_byte to A
                                           ; and store it to the 6522 -> PSG
                 STA     VIA_port_a        ; store in reg A in 6522 (DAC)
                                           ; following must come after the above, or we
                                           ; put noise to the psg,
                                           ; likewise, before storing anything else to
                                           ; port A, we will disable the connection to PSG
                 SET_VIAB_WITH_VARIABLE    ; this sets the MUX of 6522 to PSG
                 CLR     VIA_shift_reg     ; Clear shift regigster, why ???
                                           ; without it, the display 'wobbles' a bit???
                 INC     VIA_port_b        ; and disable the mux, so no junk will
                                           ; enter our PSG-DAC...
                 endm                      ; end of macro

; ***************************************************************************
; First do output a sample ... and than MOVE to D
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
; not testing whether sample is active!
DRAW_VLP_DIGIT             macro
                                  ; output first line without testing for end
dvlp1\?:
        LDD   1,x                 ; Load Y, X to D
        STA   VIA_port_a         ; put Y to DAC
        CLR   VIA_port_b         ; MUX Y
        LDA   ,x                  ; get pattern
        INC   VIA_port_b         ; un MUX (X allways set)
        STB   VIA_port_a         ; put X to DAC
        STA   VIA_shift_reg      ; set pattern
        CLR   VIA_t1_cnt_hi      ; start timer
                                  ;
                                  ; do some work in timer waiting
        LEAX  3,x                 ; increase X by 3
        LDA   ,x                  ; load next pattern
        BGT   dvlpEnd\?           ; if one(!) - branch

                                  ; now digit stuff
                                  ; testing for timer...
        LDA     VIA_t2_hi         ; get timer
        CMPA    digit_next_digit_cycle   ; and compare to next
        BLE     will_output_digit\?
        LDD     #$0040           ; load zero and timer interrupt bit
dvlp2\?:
        BITB  VIA_int_flags      ; loop till timer interrupt bit set
        BEQ   dvlp2\?
        STA   VIA_shift_reg      ; pattern to OFF
        BRA   dvlp1\?             ; and go on with next vector
will_output_digit\?:
        SUBA    #T2_TIMER_PEROID_REAL    ; note:
        STA     digit_next_digit_cycle   ; and store it
        LDD     #$0040            ; load zero and timer interrupt bit
dvlp4\?:
        BITB  VIA_int_flags      ; loop till timer interrupt bit set
        BEQ   dvlp4\?
        STA   VIA_shift_reg      ; pattern to OFF

                                  ; now play next sample
        LDA     ,-Y               ; load the next sample_byte to A
        STA     VIA_port_a        ; store in reg A in 6522 (DAC)
        SET_VIAB_WITH_VARIABLE    ; this sets the MUX of 6522 to PSG
        CLR     VIA_shift_reg     ; Clear shift regigster, why ???
        INC     VIA_port_b        ; and disable the mux, so no junk will
        BRA     dvlp1\?           ; and go on with next vector
dvlpEnd\?:
        LDD   #$0040              ; load zero and timer interrupt bit
dvlp3\?:
        BITB  VIA_int_flags      ; loop till timer interrupt bit set
        BEQ   dvlp3\?
        STA   VIA_shift_reg      ; pattern to OFF
end_DRAW_VLP\?:
                        endm

;***************************************************************************
; not testing whether sample is active!
DRAW_VLC_DIGIT             macro
                                   ; output first line without testing for end
        LDA     ,X+                ; load # of lines in this list
        INCA
        STA     $C823
dvlc1\?:
        LDD     ,X++                ; Load Y, X to D
        STA     VIA_port_a          ; put Y to DAC
        CLR     VIA_port_b          ; MUX Y
        INC     VIA_port_b          ; un MUX (X allways set)
        STB     VIA_port_a          ; put X to DAC
        LDD     #$ff00
        STA     VIA_shift_reg       ; set pattern
        STB     VIA_t1_cnt_hi       ; start timer
                                    ;
                                    ; do some work in timer waiting
        DEC     $C823
        BEQ     dvlcEnd\?           ; if 0 - branch

                                    ; now digit stuff
                                    ; testing for timer...
        LDA     VIA_t2_hi           ; get timer
        CMPA    digit_next_digit_cycle ; and compare to next
        BLE     will_output_digit\?
        LDD     #$0040              ; load zero and timer interrupt bit
dvlc2\?:
        BITB    VIA_int_flags       ; loop till timer interrupt bit set
        BEQ     dvlc2\?
        STA     VIA_shift_reg       ; pattern to OFF
        BRA     dvlc1\?             ; and go on with next vector

will_output_digit\?:
        SUBA    #T2_TIMER_PEROID_REAL    ; note:
        STA     digit_next_digit_cycle   ; and store it
        LDD     #$0040              ; load zero and timer interrupt bit
dvlc4\?:
        BITB    VIA_int_flags       ; loop till timer interrupt bit set
        BEQ     dvlc4\?
        STA     VIA_shift_reg       ; pattern to OFF

                                    ; now play next sample
        LDA     ,-Y                 ; load the next sample_byte to A
        STA     VIA_port_a          ; store in reg A in 6522 (DAC)
        SET_VIAB_WITH_VARIABLE      ; this sets the MUX of 6522 to PSG
        CLR     VIA_shift_reg       ; Clear shift regigster, why ???
        INC     VIA_port_b          ; and disable the mux, so no junk will
        BRA     dvlc1\?             ; and go on with next vector
dvlcEnd\?:
        LDD   #$0040                ; load zero and timer interrupt bit
dvlc3\?:
        BITB  VIA_int_flags         ; loop till timer interrupt bit set
        BEQ   dvlc3\?
        STA   VIA_shift_reg         ; pattern to OFF
                        endm

; ***************************************************************************
; Kills D
; must ALLWAYS have Y the position
NEXT_DIGIT_BYTE_WITH_TEST macro          ; name of macro
                 TST     digit_is_playing  ; is there a digital sample to be played?
                 BEQ     makro_rts\?       ; no, than jump out of here
                 WAIT_FOR_NEXT_DIGIT       ; otherwise we wait till the last played
                                           ; sample-byte is finnished
                 LDA     ,-Y               ; load the next sample_byte to A
                 CMPY    digit_start_pos
                 BGT     sound_not_done\?  ; with this sample, otherwise we continue further below
sound_done\?:
                 LDY     digit_structure_pos_current
                 LDD     ,Y
                 BNE     reinit_sample\?
                 LDY     digit_structure_pos
                 LDA     ,Y+               ; is this sample a looping one?
                 STA     digit_is_playing  ; store it to is_playing
                 BNE     reinit_sample\?   ; if none looping... we are done
;                 JSR     switch_to_ym
                 BRA     makro_rts\?       ; if none looping... we are done
reinit_sample\?:
                 LDD     ,Y++
                 STD     digit_start_pos   ; store new start position
                 LDD     ,Y++
                 STY     digit_structure_pos_current

                 ADDD    digit_start_pos   ; calculate end position
                 STD     digit_end_pos     ; and store it
                                           ; ok, for restart, we only change current position
                 TFR     D,Y               ; load the start position
                                           ; this is the end_position of the sample,
                                           ; since we go backwards
                 BRA     makro_rts\?       ; next byte
                                           ; is played next round...
sound_not_done\?:
                                           ; and store it to the 6522 -> PSG
                 STA     VIA_port_a        ; store in reg A in 6522 (DAC)
                                           ; following must come after the above, or we
                                           ; put noise to the psg,
                                           ; likewise, before storing anything else to
                                           ; port A, we will disable the connection to PSG
                 SET_VIAB_WITH_VARIABLE    ; this sets the MUX of 6522 to PSG
                 CLR     VIA_shift_reg     ; Clear shift regigster, why ???
                                           ; without it, the display 'wobbles' a bit???
                 INC     VIA_port_b        ; and disable the mux, so no junk will
                                           ; enter our PSG-DAC...
makro_rts\?:
                 endm                      ; end of macro

; ***************************************************************************
; Kills D
; must ALLWAYS have Y the position
NEXT_DIGIT_BYTE_RECALIBRATION macro          ; name of macro
                 TST     digit_is_playing  ; is there a digital sample to be played?
                 BEQ     makro_rts\?       ; no, than jump out of here
                 LDA     ,-Y               ; load the next sample_byte to A
                 CMPY    digit_start_pos
                 BGT     sound_not_done\?  ; with this sample, otherwise we continue further below
sound_done\?:
                 LDY     digit_structure_pos_current
                 LDD     ,Y
                 BNE     reinit_sample\?
                 LDY     digit_structure_pos
                 LDA     ,Y+               ; is this sample a looping one?
                 STA     digit_is_playing  ; store it to is_playing
                 BNE     reinit_sample\?   ; if none looping... we are done
;                 JSR     switch_to_ym
                 BRA     makro_rts\?       ; if none looping... we are done
reinit_sample\?:
                 LDD     ,Y++
                 STD     digit_start_pos   ; store new start position
                 LDD     ,Y++
                 STY     digit_structure_pos_current

                 ADDD    digit_start_pos   ; calculate end position
                 STD     digit_end_pos     ; and store it
                                           ; ok, for restart, we only change current position
                 TFR     D,Y               ; load the start position
                                           ; this is the end_position of the sample,
                                           ; since we go backwards
                 BRA     makro_rts\?       ; next byte
                                           ; is played next round...
sound_not_done\?:
                                           ; and store it to the 6522 -> PSG
                 STA     VIA_port_a        ; store in reg A in 6522 (DAC)
                                           ; following must come after the above, or we
                                           ; put noise to the psg,
                                           ; likewise, before storing anything else to
                                           ; port A, we will disable the connection to PSG
                 SET_VIAB_WITH_VARIABLE    ; this sets the MUX of 6522 to PSG
                 CLR     VIA_shift_reg     ; Clear shift regigster, why ???
                                           ; without it, the display 'wobbles' a bit???
                 INC     VIA_port_b        ; and disable the mux, so no junk will
                                           ; enter our PSG-DAC...
makro_rts\?:
                 endm                      ; end of macro

;***************************************************************************
; uses 0 cycles
; (in relation to the last done digital output)
; a wait_recal routine for the sample... output

WAIT_RECAL_DIGIT macro
                 BRA     LF19E\?          ; go to waiting
play_one_digit\?:
                 SUBA    #T2_TIMER_PEROID_REAL
                 STA     digit_next_digit_cycle   ; and store it
                 NEXT_DIGIT_BYTE_RECALIBRATION ; play a sample directly, but with test
LF19E\?:
                 LDA     VIA_t2_hi        ; load timer
                 BMI     out_of_loop\?    ; interrupt_miss
                 CMPA    digit_next_digit_cycle ; otherwise look if we should play a sample
                 BLE     play_one_digit\? ; yep... do it than
                 LDA     #$20             ; otherwise... did an inerrupt occur?
                 BITA    VIA_int_flags   ; test for interrupt
                 BEQ     LF19E\?          ; if no interrupt keep on testing
out_of_loop\?:
                 LDD     $C83D            ; Store refresh value
                 STD     VIA_t2_lo       ; into timer t2
                 EXG     A,B
                 SUBA    #T2_TIMER_PEROID_REAL ; next sample output timer
                 STA     digit_next_digit_cycle ; store it

                                           ; note: for low sample rates
                                           ; we could use a normal MOVE
                                           ; and save probably
                                           ; a thousand or more cycles!
                                           ; since THIS MOVE first
                                           ; outputs an sample!
                                           ; (which also means waiting for the sample)

                 LDA     #$ff              ; set the fixed scale factor we will use...
                 STA     VIA_t1_cnt_lo     ; move to time 1 lo, this means scaling

                 LDD     #$7F7F            ; load the next pos, super long saturation
                 JSR     move_to_d_digit   ; move to d -> must be achieved
                 LDB     #$CC
                 STB     VIA_cntl          ; blank low and zero low

                 LDD     #$8080            ; load the next pos, super long saturation
                 JSR     move_to_d_digit   ; move to d -> must be achieved

                 LDB     #$CC
                 STB     VIA_cntl          ; /BLANK low and /ZERO low

                 LDD     #$0302
                 STA     VIA_port_b        ; mux=1, disable mux
                 CLR     VIA_port_a        ; clear D/A register
                 STB     VIA_port_b        ; mux=1, enable mux
                 STB     VIA_port_b        ; do it again
                 LDB     #$01
                 STB     VIA_port_b        ; disable mux

                 SET_VIAB_INTERN           ; rethink our VIAB value
                 NEXT_DIGIT_BYTE           ; and do one sample-byte
                 endm
;***************************************************************************
; expects struct in X
;
; sets up Y register, this should under no circumstances be destroyed
INIT_SOUND_DIGIT macro
                 STX     digit_structure_pos
                 LDD     1,X
                 STD     digit_start_pos   ; store new start position
                 LDD     3,X
                 LEAX    5,X
                 STX     digit_structure_pos_current

                 ADDD    digit_start_pos   ; calculate end position
                 STD     digit_end_pos     ; and store it

                 LDA     #1                ; sound is playing is ON
                 STA     digit_is_playing  ; sound is playing

                 SET_VIAB_INTERN           ; calculate out first VIA B poke

                 LDY     digit_end_pos     ; initialize Y to position in sample data

                 LDD     #$0E00            ; Clear_Sound
clear_next_register\?:
                 JSR     Sound_Byte
                 DECA
                 BPL     clear_next_register\?
                 LDA     VIA_t2_hi        ; load timer
                 SUBA    #T2_TIMER_PEROID_REAL
                 STA     digit_next_digit_cycle   ; and store it
;                 JSR     switch_to_digit
                 endm
; ***************************************************************************
; This can be used to test a position if a sample should be played
; or not. Comes handy to test if routines use aprox. to many
; cycles and to insert a 'play next digit' call...
; Kills D
;
; uses DVE special features
;
TESTER_DIGIT macro                  ; name of macro
wait_for_next_digit\?:
                 PSHS A
                 TST     digit_is_playing  ; is there a digital sample to be played?
                 BEQ     rts_macro\?       ; no, than jump out of here
                 LDA     VIA_t2_hi         ; get timer
                 CMPA    digit_next_digit_cycle   ; and compare to next
                 BGT     rts_macro\?       ; not yet? than test again
 DB 1
 DB 2
rts_macro\?
                 PULS A

                 endm                      ; end of macro


via_b_start:                    DB 1    ; init via save
digit_is_playing:               DB 1    ; 1 = true, 0 = false
digit_next_digit_cycle          DW 0    ; next timer cycle we should play next sample
                                        ; timer loaded for recalibration with
                                        ; 30000 -> 50Hz update
                                        ; gets counted backword by VIA
                                        ; so after recalibration the next
                                        ; sample will be played
                                        ; at (30000 - T2_TIMER_PEROID_REAL)
                                        ; asking the timer about its value is
                                        ; done in WAIT_FOR_NEXT_DIGIT
                                        ; missing a few cycles doesn't really matter
                                        ; BAD is that VIA counter has different
                                        ; endianess, so we waste cycles EXGing...
digit_structure_pos             DW 1    ; position of sample structure
digit_structure_pos_current     DW 1    ; current position in sample structure
digit_end_pos:                  DW 1    ; this is the start position of the sample, since we play it backwards
digit_start_pos:                DW 1    ; start position of samples
digit_timer_saver:              DW 1
