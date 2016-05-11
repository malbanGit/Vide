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
                DB      $F8, $50, $20, -$70     ; height, width, rel y, rel x
                                                ; (from 0,0)
                DB      "POSITION SOME DOTS",$80; some game information,
                                                ; ending with $80
                DB      0                       ; end of game header
;***************************************************************************
; CODE SECTION
;***************************************************************************
; here the cartridge program starts off
main:
                JSR     Wait_Recal              ; Vectrex BIOS recalibration

                ; prepare dot 0
                JSR     Intensity_5F            ; Sets the intensity of the
                                                ; vector beam to $5f
                JSR     Delay_3                 ; delay for 30 cycles
                JSR     Dot_here                ; Plot a dot here
                ; end of dot 0

                ; prepare dot 1
                LDA     #100                    ; load 100
                STA     VIA_t1_cnt_lo           ; 100 as scaling
                LDA     #-100                   ; relative Y position = -100
                LDB     #-50                    ; relative X position = -50
                                                ; register D = 256*A+B
                JSR     Moveto_d                ; move to position specified
                                                ; in D register
                JSR     Dot_here                ; Plot a dot here
                ; end of dot 1

                ; prepare dot 2
                LDA     #50                     ; load 50
                STA     VIA_t1_cnt_lo           ; 50 as scaling
                LDA     #100                    ; relative Y position = 100
                LDB     #50                     ; relative X position = 50
                                                ; register D = 256*A+B
                JSR     Moveto_d                ; move to position specified
                                                ; in D register
                JSR     Dot_here                ; Plot a dot here
                ; end of dot 2

                ; prepare dot 3
                LDA     #200                    ; scale factor of 200
                LDX     #position               ; load address of position
                JSR     Moveto_ix_a             ; move to position specified
                                                ; in address pointed to by X
                                                ; and set scaling factor found
                                                ; register B
                                                ; (befor positioning)
                JSR     Dot_here                ; Plot a dot here
                ; end of dot 3
                BRA     main                    ; and repeat forever
;***************************************************************************
; DATA SECTION
;***************************************************************************
position:
                DB      100, 50                 ; relative Y, X position
;***************************************************************************
                END  main
;***************************************************************************
