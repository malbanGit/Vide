;***************************************************************************
; DEFINE SECTION
;***************************************************************************
                INCLUDE "VECTREX.I"
; start of vectrex memory with cartridge name...
                ORG     0
;***************************************************************************
; HEADER SECTION
;***************************************************************************
                DB      "g GCE 1998", $80       ; 'g' is copyright sign
                DW      music1                  ; music from the rom
                DB      $F8, $50, $20, -$55     ; height, width, rel y, rel x
                                                ; (from 0,0)
                DB      "VECTOR LIST TEST",$80  ; some game information,
                                                ; ending with $80
                DB      0                       ; end of game header
;***************************************************************************
; CODE SECTION
;***************************************************************************
; here the cartridge program starts off
main:
                LDA     #1                      ; one means, we are about to
                                                ; start a piece of music
                STA     Vec_Music_Flag          ; store it in appropriate RAM
                                                ; location
main_loop:
                JSR     DP_to_C8                ; DP to RAM
                LDU     #music1                 ; get some music, here music1
                JSR     Init_Music_chk          ; and init new notes
                JSR     Wait_Recal              ; Vectrex BIOS recalibration
                JSR     Do_Sound                ; ROM function that does the
                                                ; sound playing
                BRA     main_loop               ; and repeat forever
;***************************************************************************
                END main
;***************************************************************************
