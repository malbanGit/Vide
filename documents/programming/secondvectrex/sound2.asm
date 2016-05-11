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
                LDU     #yankee                 ; get some music, here yankee
                JSR     Init_Music_chk          ; and init new notes
                JSR     Wait_Recal              ; Vectrex BIOS recalibration
                JSR     Do_Sound                ; ROM function that does the
                                                ; sound playing
                BRA     main_loop               ; and repeat forever
;***************************************************************************
yankee:
                FDB     $FEE8, $FEB6            ; ADSR and twang address tables, in Vectrex ROM
                FCB     2,12                    ;;;;;;;;
                FCB     0,12                    ; first byte is a note, to be
                FCB     2,12                    ; found in vectrex rom, is a
                FCB     0,12                    ; 64 byte table...
                FCB     2,6                     ; last byte is length of note
                FCB     0,6
                FCB     2,6
                FCB     0,6
                FCB     2,6
                FCB     0,6
                FCB     2,12
                FCB     0,12                    ;;;;;;;;
                FCB     2,12
                FCB     0,12
                FCB     2,12
                FCB     0,12                    ;;;;;;;;
                FCB     2,6
                FCB     0,6
                FCB     2,6
                FCB     0,6
                FCB     2,6
                FCB     0,6
                FCB     2,6                     ;;;;;;;;
                FCB     0,6
                FCB     2,12
                FCB     0,12
                FCB     128+2,128+26,26-12, 12  ;
                FCB     128+0,128+31,31-12, 12  ;;;;;;;;
                FCB     128+2,128+31,31-12, 12  ; a 128 means the next byte is
                FCB     128+0,128+33,33-12, 12  ; a note for the next channel
                FCB     128+2,128+35,35-12, 12  ; channel...
                FCB     128+0,128+31,31-12, 12  ;;;;;;;;
                FCB     128+2,128+35,35-12, 12
                FCB     128+0,128+33,33-12, 12
                FCB     128+2,128+26,26-12, 12
                FCB     128+0,128+31,31-12, 12  ;;;;;;;;
                FCB     128+2,128+31,31-12, 12
                FCB     128+0,128+33,33-12, 12
                FCB     128+2,128+35,35-12, 12
                FCB     128+0,128+31,31-12, 12  ;;;;;;;;
                FCB     2,12
                FCB     128+0,128+30,30-12, 12
                FCB     128+2,128+26,26-12, 12
                FCB     128+0,128+31,31-12, 12  ;;;;;;;;
                FCB     128+2,128+31,31-12, 12
                FCB     128+0,128+33,33-12, 12
                FCB     128+2,128+35,35-12, 12
                FCB     128+0,128+36,36-12, 12  ;;;;;;;;
                FCB     128+2,128+35,35-12, 12
                FCB     128+0,128+33,33-12, 12
                FCB     128+2,128+31,31-12, 12
                FCB     128+0,128+30,30-12, 12  ;;;;;;;;
                FCB     128+2,128+26,26-12, 12
                FCB     128+0,128+28,28-12, 12
                FCB     128+2,128+30,30-12, 12
                FCB     128+0,128+31,31-12, 12  ;;;;;;;;
                FCB     2, 12
                FCB     128+0,128+31,31-12, 12
                FCB     2, 12
                FCB     128+0,128+28,28-12, 18  ;;;;;;;;
                FCB     128+30,30-12, 06
                FCB     128+2,128+28,28-12, 12
                FCB     128+0,128+26,26-12, 12
                FCB     128+2,128+28,28-12, 12  ;;;;;;;;
                FCB     128+0,128+30,30-12, 12
                FCB     128+2,128+31,31-12, 12
                FCB     0, 12
                FCB     128+0,128+26,26-12, 18  ;;;;;;;;
                FCB     128+28,28-12, 06
                FCB     128+2,128+26,26-12, 12
                FCB     128+0,128+24,24-12, 12
                FCB     128+2,128+23,23-12, 12  ;;;;;;;;
                FCB     0, 12
                FCB     128+2,128+26,26-12, 12
                FCB     0, 12
                FCB     128+2,128+28,28-12, 18  ;;;;;;;;
                FCB     128+30,30-12, 06
                FCB     128+0,128+28,28-12, 12
                FCB     128+2,128+26,26-12, 12
                FCB     128+0,128+28,28-12, 12  ;;;;;;;;
                FCB     128+2,128+30,30-12, 12
                FCB     128+0,128+31,31-12, 12
                FCB     128+2,128+28,28-12, 12
                FCB     128+0,128+26,26-12, 12  ;;;;;;;;
                FCB     128+2,128+31,31-12, 12
                FCB     128+0,128+30,30-12, 12
                FCB     128+2,128+33,33-12, 12
                FCB     128+0,128+31,31-12, 12  ;;;;;;;;
                FCB     2, 12
                FCB     128+0,128+31,31-12, 12
                FCB     2, 12
                FCB     19, $80                 ; $80 is end marker for music
                                                ; (high byte set)
;***************************************************************************
                END main
;***************************************************************************
