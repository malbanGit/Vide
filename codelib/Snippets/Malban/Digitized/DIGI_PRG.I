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
