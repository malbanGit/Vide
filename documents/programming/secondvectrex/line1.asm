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
                DB      $F8, $50, $20, -$45     ; height, width, rel y, rel x
                                                ; (from 0,0)
                DB      "SINGLE LINE",$80       ; some game information,
                                                ; ending with $80
                DB      0                       ; end of game header
;***************************************************************************
; CODE SECTION
;***************************************************************************
; here the cartridge program starts off
main:
                JSR     Wait_Recal              ; Vectrex BIOS recalibration
                LDA     #$80                    ; scaling factor of $80 to A
                STA     VIA_t1_cnt_lo           ; move to time 1 lo, this
                                                ; means scaling
                LDA     #0                      ; to 0 (y)
                LDB     #0                      ; to 0 (x)
                JSR     Moveto_d                ; move the vector beam the
                                                ; relative position
                JSR     Intensity_5F            ; Sets the intensity of the
                                                ; vector beam to $5f
                CLR     Vec_Misc_Count          ; in order for drawing only 1
                                                ; vector, this must be set to
                                                ; 0
                LDA     #100                    ; to 100 (y)
                LDB     #50                     ; to 50 (x)
                JSR     Draw_Line_d             ; draw the line now
                BRA     main                    ; and repeat forever
;***************************************************************************
                END main
;***************************************************************************
