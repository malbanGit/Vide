;***************************************************************************
; DEFINE SECTION
;***************************************************************************
                INCLUDE "VECTREX.I"             ; vectrex function includes
; start of vectrex memory with cartridge name...
                ORG     0
;***************************************************************************
; HEADER SECTION
;***************************************************************************
                DB      "g GCE 1998", $80       ; 'g' is copyright sign
                DW      music1                  ; music from the rom
                DB      $F8, $50, $20, -$56     ; height, width, rel y, rel x
                                                ; (from 0,0)
                DB      "PLOT A DOT",$80        ; some game information,
                                                ; ending with $80
                DB      0                       ; end of game header
;***************************************************************************
; CODE SECTION
;***************************************************************************
; here the cartridge program starts off
main:
                JSR     Wait_Recal              ; Vectrex BIOS recalibration
                JSR     Intensity_5F            ; Sets the intensity of the
                                                ; vector beam to $5f
                ; special attention here!!!
                JSR     Dot_here                ; Plot a dot at the center of
                                                ; the screen
                BRA     main                    ; and repeat forever
;***************************************************************************
                END  main
;***************************************************************************
