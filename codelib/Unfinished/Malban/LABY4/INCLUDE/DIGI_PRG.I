                direct  $d0             ; following code uses d0
;***************************************************************************
; expects startposition in D
; expects length in X
;
; sets up Y register, this should under no circumstances be destroyed
init_digit_sound:
                 INIT_SOUND_DIGIT
                 RTS                       ; back

;***************************************************************************
; now the makros from above as functions...
; shortens the source...
;***************************************************************************
wait_recal_digit:
                 WAIT_RECAL_DIGIT
                 RTS

;***************************************************************************
; position in D
move_to_d_digit:
                 MOVE_TO_D_DIGIT
                 RTS

;***************************************************************************
; vector list in X
Draw_VLc_digit:
                 DRAW_VLC_DIGIT
                 RTS

;***************************************************************************
; intensity in A
intensity_a_digit:
                 INTENSITY_A
                 RTS
;***************************************************************************
Draw_VLp_digit:
 DRAW_VLP_DIGIT
                 RTS
;***************************************************************************
next_digit:
 NEXT_DIGIT_BYTE_WITH_TEST
 RTS
;***************************************************************************
Read_Btns_digit:
;***************************************************************************
                LDX     #Vec_Button_1_1 ;Point to button flags
                LDA     -3,X            ;Save previous state
                STA     -2,X            ;
                LDA     #$0E            ;Sound chip register 0E to port A
                STA     VIA_port_a     ;
                                        ;
                                        ;
                LDD     #$1901          ;sound BDIR on, BC1 on, mux off
                STA     VIA_port_b     ;
                                        ;
                                        ;
                NOP                     ;pause
                STB     VIA_port_b     ;sound BDIR off, BC1 off, mux off
                                        ;
                                        ;
                CLR     VIA_DDR_a      ;DDR A to input
                LDD     #$0901          ;sound BDIR off, BC1 on, mux off
                STA     VIA_port_b     ;
                                        ;
                                        ;
                NOP                     ;pause
                LDA     VIA_port_a     ;Read buttons
                COMA                    ;Convert to active high
                STA     -3,X            ;Save buttons
                STB     VIA_port_b     ;sound BDIR off, BC1 off, mux off
                                        ;
                                        ;
                LDB     #$FF            ;
                STB     VIA_DDR_a      ;DDR A to output
                COMA                    ;Check for transitions
                ORA     -2,X            ;
                COMA                    ;
                STA     -1,X            ;Store transition result
                 RTS

