; this file is part of vectrex frogger, written by Malban
; in March-April 1998
; all stuff contained here is public domain (?)
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this file contains private makros, some are taken from the BIOS of vectrex;
; and changed slightly to be more speedy, other were written alltogether by ;
; me, some of these are even obsolete... but all should be in a working     ;
; state                                                                     ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
 if MY_MAKROS_I != 1

MY_MAKROS_I equ 1
;
; following are some 'private' makro definitions
;
; some heavily optimized for speed :-(
;

;***************************************************************************
; this makro is supposed to 'reset' the sound hardware,
; it doesn't seem to work correctly though, frog jumps sometimes
; sound differently, what kind of 'bug' is that?
MY_QUIT         macro
                CLR     Vec_Music_Flag     ; no music is playing ->0
                JSR     Init_Music_Buf     ; shadow regs
                                           ; in the next do sound call
                                           ; all regs are cleared automatically
                endm                       ; end of macro
;***************************************************************************
; this makro should be called every round a music is to be played
; this does not play the sound, it initializes it only, but also every round!
;
; leaves with DP set to C8
; expects music to be initialized
; and pointer in music_active
DO_MY_SOUND     macro                      ; name of macro
                _DP_TO_C8                  ; (MAKRO) the 'Init_Music_chk' expects this
                LDU     music_active       ; get active music
                JSR     Init_Music_chk     ; and init new notes
                endm                       ; end of macro
; offspring of the above, squized cycles :-)
DO_MY_SOUND_MAIN macro                      ; name of macro
                direct $c8
                LDU     music_active       ; get active music
                JSR     Init_Music_chk     ; and init new notes
                endm                       ; end of macro
;***************************************************************************
; this makro initializes a new piece of music
; the above 'function' must be called every round in order for the music
; actually to be played
PLAY_SOUND      macro piece_of_music       ; name of macro, and variable name, can also be accessed with \1
                ; the next instructions initialize a new sound
                ; load #1
                ; set this as marker for music start
                CLR     Vec_Music_Flag     ; doesn'T destroy a register
                INC     Vec_Music_Flag     ; to do it that way
                LDU     #\1                ; load a music structure (piece_of_music)
                STU     music_active       ; and store it to my own music active pointer
                                           ; next a do_my_sound and than do sound must be called
                endm                       ; end of macro
;***************************************************************************
; this makro is sort of the startup for every display round
; does all sound stuff and recalibration, leaves with
; DP set to D0
; destroyes pretty much every register...
ROUND_STARTUP   macro                      ; name of macro
                DO_MY_SOUND                ; (MAKRO) see above
                JSR     Wait_Recal         ; sets dp to d0, and pos at 0, 0
                direct  $D0                ; just for assembler optimization...
                JSR     Do_Sound           ; ROM function that does the sound playing
                endm                       ; end of macro
; offspring of the above, squized cycles :-)
ROUND_STARTUP_MAIN macro                   ; name of macro
;                JSR     Wait_Recal         ; sets dp to d0, and pos at 0, 0
                direct  $D0                ; just for assembler optimization...
                MY_WAIT_RECAL
                _DO_SOUND
                endm                       ; end of macro
;***************************************************************************
; the following makros are for intensity setting
; to set a intensity the bios does use some (many) cycles, here a
; test really saves some cycles, if intensity is set many times per round
; (like differently shaded sprites)
;
; intensity set to value found in register A
; is compared/stored to 'current_brightness'
; if not equal the new brightness is set!
MY_INTENSITY_A  macro                      ; name of macro, and variable name, can also be accessed with
                CMPA    current_brightness ; compare to last known value
                BEQ     no_brightness_change\? ; if the same, than jump
                STA     current_brightness ; otherwise store new value
                _INTENSITY_A               ; and than set the intensity
no_brightness_change\?:
                endm                       ; end of macro
;***************************************************************************
; same as above, only the brightness is passed as makro parameter
MY_INTENSITY   macro brightness            ; name of macro, and variable name, can also be accessed with \1
                LDA     #\1                ; load brightness to register A
                MY_INTENSITY_A             ; 'call' the other makro
                endm                       ; end of macro
;***************************************************************************
; same as above, but allways sets the new brightness
; good for startup of new round, since intensity MUST be set at that point
; or after other functions which destroy brighness (print_str...)
MY_INTENSITY_FORCE  macro brightness           ; name of macro, and variable name, can also be accessed with \1
                LDA     #\1                    ; load brightness to A
                STA     current_brightness     ; store it
                _INTENSITY_A                   ; and change the brightness
                endm                           ; end of macro
;***************************************************************************
MY_GAME_SCALE   macro
                LDA #SCALE_FACTOR_GAME
                _SCALE_A
                endm
;***************************************************************************
; the following makro ...
; they search for a better (faster) scale/DAC relation and use
; the scaling thus found, it should be somewhat faster that way...
; per round we save approxematly: ? cycles
; both destroy X and D
; SCALE factor is changed
;
; forget it !!!
;***************************************************************************
MY_MOVE_TO_D    macro
; optimzed, tweaked not perfect... 'MOVE TO D' makro
;
;
; NOT DONE:
;
; what should be done:
; s = $ff / max(abs(a),abs(b))
; a = a * s
; b = b * s
; scaling = scaling / s
;
; that would give the most efficient positioning
; bother it takes more time to calculate the above,
; than it saves
; with every positioning via this routine now,
; it takes SCALE_FACTOR_GAME + const (of another 100+) cycles
; to do one simple positioning!!!
; that is probably about 300 cycles per positioning
; this is done about 30-40 times per round
; alone the positioning takes thus about over 10000 cycles
; and we haven't drawn a single line yet!!!
                 local   LF33D
                 STA     <VIA_port_a     ;Store Y in D/A register
                 LDA     #$CE            ;Blank low, zero high?
                 STA     <VIA_cntl       ;
                 CLRA
                 STA     <VIA_port_b     ;Enable mux
                 STA     <VIA_shift_reg  ;Clear shift regigster
                 INC     <VIA_port_b     ;Disable mux
                 STB     <VIA_port_a     ;Store X in D/A register
                 STA     <VIA_t1_cnt_hi  ;enable timer
                 LDB     #$40            ;
LF33D:           BITB    <VIA_int_flags  ;
                 BEQ     LF33D           ;
                endm
;***************************************************************************
; only positive for now
; multiply two 16 bit values to another 16 bit value
; multiplies D and tmp1 to D
; result should be also 16 bit able, otherwise high bit is lost
;
;***ERROR*** It is not tested for signedness, should test
; at startup, if our counter us negative, like the last mul above
; but I don't need it now, it would be just a waste of time
; for my needs!!!
MY_MUL_D_tmp1_D    macro
                STD mul_tmp1             ; remember D
                BEQ  mul_zero\?          ; was it a mul zero? than go there
                LDD tmp1                 ; get the other 16 bit value to D
                BEQ  mul_zero\?          ; was that one a zero? than go there
                BRA  mul_on2\?           ; otherwise start multiplying
mul_on\?:                                ; here we loop after the first step
                LDD mul_tmp2             ; load our last intermediate multiply value
                ADDD tmp1                ; add tmp1 once
mul_on2\?:                               ; here we go with our first mul step
                STD mul_tmp2             ; store the intermediate mul value to mul_tmp2
                LDD mul_tmp1             ; load 'counter' (was D)
                SUBD #1                  ; decrement counter ***ERROR***,
                STD mul_tmp1             ; and store counter back
                BNE mul_on\?             ; if counter not zero, repeat multi...
                LDD mul_tmp2             ; otherwise load the result to D register
                BRA mul_end\?            ; and goto end
mul_zero\?:                              ; here we come if a zero mul was made
                CLRA                     ; result (D) is than zero
                CLRB
mul_end\?:                               ; and done...
                endm
;***************************************************************************
; there are many 16 bit operands missing, so is
; a LSRD
; this macro does a 16 bit LSR on register D
MY_LSR_D              macro
                      LSRB               ; LSR B
                      LSRA               ; LSR A
                      BCC no_carry\?     ; if no carry, than exit
                      ORB #128           ; otherwise underflow from A to 7bit of B
no_carry\?:
                      endm               ; done
;***************************************************************************
; divides D by tmp1, result in B
; uses divide_tmp as storage
; only 8 bit in tmp1, but must be manually poked to tmp1 + 1
; sign is correctly handled
;
; can probably be optimized like hell
; perhaps only nearing the result
; using 2 shifts and a plus
; might be worth a try,
; see vectrex emulator for algorithm...
; could be implemented with a tabel, which in turn
; could be caclulated on the fly... (upon startup)
;
; this makro divides exact, but slow
MY_DIV_D_BY_TMP1_TO_B macro
                CLR     divide_tmp
                TST     tmp1+1
                BEQ     divide_by_zero\?
                DEC     divide_tmp
                CMPD    #0
                BPL     divide_next\?
divide_next1\?:
                INC     divide_tmp
                ADDD    tmp1
                BMI     divide_next1\?
divide_by_zero1\?:
                LDB     divide_tmp
                NEGB
                BRA     divide_end\?
divide_next\?:
                INC     divide_tmp
                SUBD    tmp1
                BPL     divide_next\?
divide_by_zero\?:
                LDB     divide_tmp
divide_end\?:
                endm
;***************************************************************************
MY_DIV_D_16_UNSIGNED macro
                      LSLA
                      LSLA
                      LSLA
                      LSLA
                      LSRB
                      LSRB
                      LSRB
                      LSRB
                      STA divide_tmp
                      ORB divide_tmp
                      endm
;***************************************************************************
; divides D by tmp1, result in B
; uses divide_tmp as storage
; only 8 bit in tmp1, but must be manually poked to tmp1 + 1
; sign is correctly handled
;
; can probably be optimized like hell
; perhaps only nearing the result
; using 2 shifts and a plus
; might be worth a try,
; see vectrex emulator for algorithm...
; could be implemented with a tabel, which in turn
; could be caclulated on the fly... (upon startup)
;
; this makro divides exact, but slow
MY_DIV_D_BY_TMP1_TO_B_UNSIGNED macro
                CLR     divide_tmp
                TST     tmp1+1
                BEQ     divide_by_zero\?
                DEC     divide_tmp
                CMPD    #0
                BPL     divide_next\?
divide_next1\?:
                INC     divide_tmp
                ADDD    tmp1
                BMI     divide_next1\?
divide_by_zero1\?:
                LDB     divide_tmp
                NEGB
                BRA     divide_end\?
divide_next\?:
                INC     divide_tmp
                SUBD    tmp1
                BPL     divide_next\?
divide_by_zero\?:
                LDB     divide_tmp
divide_end\?:
                endm
;***************************************************************************
MY_READ_BUTTONS_A macro
                direct  $d0
                LDA     #$0E            ;Sound chip register 0E to port A
                STA     <VIA_port_a
                LDD     #$1901          ;sound BDIR on, BC1 on, mux off
                STA     <VIA_port_b
                NOP                     ;pause
                STB     <VIA_port_b     ;sound BDIR off, BC1 off, mux off
                CLR     <VIA_DDR_a      ;DDR A to input
                LDD     #$0901          ;sound BDIR off, BC1 on, mux off
                STA     <VIA_port_b
                NOP                     ;pause
                LDA     <VIA_port_a     ;Read buttons
                STB     <VIA_port_b     ;sound BDIR off, BC1 off, mux off
                LDB     #$FF
                STB     <VIA_DDR_a      ;DDR A to output
                 endm
;***************************************************************************
MY_WAIT_RECAL macro
                direct $d0
                LDA     #$20
LF19E\?:        BITA    <VIA_int_flags  ;Wait for timer t2
                BEQ     LF19E\?
                LDD     $C83D           ;Store refresh value
                STD     <VIA_t2_lo      ;into timer t2

                LDB     #$FF
                STB     <VIA_t1_cnt_lo  ;Set scale factor
                LDD     #$7F7F
                MY_MOVE_TO_D

                LDB     #$CC
                STB     <VIA_cntl       ;blank low and zero low
                STA     <VIA_shift_reg  ;clear shift register

                LDD     #$8080
                MY_MOVE_TO_D

                LDB     #$CC
                STB     <VIA_cntl       ;/BLANK low and /ZERO low
                STA     <VIA_shift_reg  ;clear shift register

                LDD     #$0302
                CLR     <VIA_port_a     ;clear D/A register
                STA     <VIA_port_b     ;mux=1, disable mux
                STB     <VIA_port_b     ;mux=1, enable mux
                STB     <VIA_port_b     ;do it again
                LDB     #$01
                STB     <VIA_port_b     ;disable mux
                 endm
;***************************************************************************
; destroys Vec_Misc_Count ($C823)
; expects dp to d0
; only OK for small scales, cause not exact!
MY_DRAW_VLC        macro
                 LDD     ,X++            ;
                 STA     $C823           ;
                 CLRA
_DRAW_VLA\?:
;                 STB     <VIA_port_a     ;Send Y to A/D
;                 STA     <VIA_port_b
                 STD     VIA_port_b
                 LDB     ,X+
                 INC     <VIA_port_b     ;Disable mux
                 STB     <VIA_port_a     ;Send X to A/D
                 DEC     <VIA_shift_reg  ;Put pattern in shift register
                 STA     <VIA_t1_cnt_hi  ;enable timer 1

                 LDB     ,X+             ; 6
                 DEC     $C823           ; 7
                 BMI     _DRAW_END\?     ; 3 Go back for more points
                 LDA     #$40          ;B-reg = T1 interrupt bit
LF3F4\?:
                 BITA    <VIA_int_flags  ;Wait for T1 to time out
                 BEQ     LF3F4\?         ;
                 CLRA                    ;Wait a moment more
                 STA     <VIA_shift_reg  ;Clear shift register (blank output)
                 BRA     _DRAW_VLA\?     ; 3
_DRAW_END\?:
                 LDA     #$40          ;B-reg = T1 interrupt bit
LF3F4:           BITA    <VIA_int_flags  ;Wait for T1 to time out
                 CLRA                    ;Wait a moment more
                 STA     <VIA_shift_reg
                 endm
;***************************************************************************
MY_HOME_SPRITE        macro

                LDD     #(SCALE_IN_HOME*256)+$CC
;                LDB     #$CC            ; prepare for zero below
                STB     VIA_cntl        ; BLANK low and /ZERO low
                ; zero here for following homes
;                LDA     #SCALE_IN_HOME
                _SCALE_A                   ; for first house
                LDD     2,U ; load object position
                ADDA    7,X ; korrect with sprite offset Y
                ADDB    8,X ; korrect with sprite offset X
                ; move to
                STA     VIA_port_a         ; Store Y in D/A register
                CLR     VIA_port_b         ; Enable mux
                LDA     #$CE               ; Blank low, zero high?
                STA     VIA_cntl           ;
                INC     VIA_port_b         ; Disable mux
                STB     VIA_port_a         ; Store X in D/A register
                CLR     VIA_t1_cnt_hi      ; enable timer

                DEC     4,U             ; decrease animation counter
                BNE     no_new_animation_phase_home\? ; if zero, we must initialize new animation phase
new_animation_phase_home\?:
                LDY     5,X             ; load new object definition
                STY     ,U              ; store new object definition to object list
                LDA     4,Y             ; load new animation counter start
                STA     4,U             ; and set it in object list
no_new_animation_phase_home\?:
                LDX     1,X             ; load object vector list to X,
                LDD  #((SCALE_FACTOR_SPRITE)*256)+$40;A= scale, B= Timer flag
home_object_move\?:
                BITB    VIA_int_flags      ; Wait for T1 to time out
                BEQ     home_object_move\?  ;
                ; move to done
                _SCALE_A                   ; do it
                ; in X vector list now!
                ; U still untouched, pointer to first home!
                ; display the vector list
                MY_SPRITE_DRAW_VLC    ; (MAKRO) and draw the vector list
                STA     VIA_shift_reg
                 endm

MY_HOME_SPRITE1        macro
                LDA     #SCALE_IN_HOME
                _SCALE_A                   ; for first house
                LDD     2,U ; load object position
                ADDA    7,X ; korrect with sprite offset Y
                ADDB    8,X ; korrect with sprite offset X
                ; move to
                STA     VIA_port_a         ; Store Y in D/A register
                CLR     VIA_port_b         ; Enable mux
                LDA     #$CE               ; Blank low, zero high?
                STA     VIA_cntl           ;
                INC     VIA_port_b         ; Disable mux
                STB     VIA_port_a         ; Store X in D/A register
                CLR     VIA_t1_cnt_hi      ; enable timer

                DEC     4,U             ; decrease animation counter
                BNE     no_new_animation_phase_home\? ; if zero, we must initialize new animation phase
new_animation_phase_home\?:
                LDY     5,X             ; load new object definition
                STY     ,U              ; store new object definition to object list
                LDA     4,Y             ; load new animation counter start
                STA     4,U             ; and set it in object list
no_new_animation_phase_home\?:
                LDX     1,X             ; load object vector list to X,
                LDD  #((SCALE_FACTOR_SPRITE)*256)+$40;A= scale, B= Timer flag
home_object_move\?:
                BITB    VIA_int_flags      ; Wait for T1 to time out
                BEQ     home_object_move\?  ;
                ; move to done
                _SCALE_A                   ; do it
                ; in X vector list now!
                ; U still untouched, pointer to first home!
                ; display the vector list
                MY_SPRITE_DRAW_VLC    ; (MAKRO) and draw the vector list
                STA     VIA_shift_reg
                 endm

 endif
