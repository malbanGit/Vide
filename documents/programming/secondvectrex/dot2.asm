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
                DB      "PLOT A LIST OF DOTS",$80; some game information,
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
                JSR     Delay_3                 ; delay for 30 cycles
                LDA     #50                     ; load 50
                STA     VIA_t1_cnt_lo           ; 50 as scaling
                LDA     #6                      ; load A with 6, dots - 1
                STA     Vec_Misc_Count          ; set it as counter for dots
                LDX     #dot_list               ; load the address of dot_list
                JSR     Dot_List                ; Plot a series of dots
                BRA     main                    ; and repeat forever
;***************************************************************************
; DATA SECTION
;***************************************************************************
dot_list:
                DB       30,-70                 ; seven dots, relative
                DB      -40, 10                 ; position, Y, X
                DB        0, 30
                DB       40, 10
                DB       10, 30
                DB        5, 30
                DB       -10,40
;***************************************************************************
                END  main
;***************************************************************************
