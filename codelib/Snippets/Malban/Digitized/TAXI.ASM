; I used the 6809 assembler:
; as09 [1.11].
; Copyright 1990-1994, Frank A. Vorstenbosch, Kingswood Software.
; Available at:
; http://www.falstaff.demon.co.uk/cross.html
;
                 INCLUDE "VECTREX.I"       ; vectrex function includes

                 BSS
                 ORG     $c880             ; well start of our ram space
                 INCLUDE "DIGI_VAR.I"      ;

                 CODE
                 INCLUDE "DIGI_MAK.I"
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

                 LDD     #LEFT_START    ; position of sample
                 LDX     #LEFT_LENGTH   ; length of sample
                 JSR     init_digit_sound  ; init it!

main:
                 ; first allways is a wait_recal, as usual
                 JSR     wait_recal_digitj ; same as makro: WAIT_RECAL_DIGIT

                 ; set some intensity for our to be displayed vectors
                 LDA     #$7f              ; seems about bright enough
                 JSR     intensity_a_digitj; and set the intensity
                                           ; same as makro: INTENSITY_A_DIGIT

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

                 LDX     #frogger_left    ; load right vector list
                 JSR     draw_vlc_digitj   ; and draw it
                                           ; same as makro: DRAW_VLC_DIGIT

                 LDA     digit_is_playing  ; are we still playing a sample?
                 BNE     main              ; yep? than go back to main
                 LDD     #LEFT_START    ; position of FROGGER-sample
                 LDX     #LEFT_LENGTH  ; length of FROGGER-sample
                 JSR     init_digit_sound  ; and initialize the sound...
                 BRA     main              ; back to main loop


;***************************************************************************
                 INCLUDE "DIGI_PRG.I"
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


sample_start:

; where are the samples?
; this must follow after the above 'sample_start' definition!
; otherwise the assembler doesn't calculate 'sample_start' properly

LEFT_START              EQU (sample_start +00)

                INCLUDE "TEST.DB" ; vectrex function includes
sample_end:
LEFT_LENGTH             EQU sample_end - LEFT_START
