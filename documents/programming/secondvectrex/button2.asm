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
                DB      "BUTTON TEST",$80       ; some game information,
                                                ; ending with $80
                DB      0                       ; end of game header
;***************************************************************************
; CODE SECTION
;***************************************************************************
; here the cartridge program starts off
                LDD     #$FC20                  ; HEIGTH, WIDTH (-4, 32)
                STD     Vec_Text_HW             ; store to BIOS RAM location
main:
main_loop:
                JSR     Wait_Recal              ; Vectrex BIOS recalibration
                JSR     Intensity_5F            ; Sets the intensity of the
                                                ; vector beam to $5f
                JSR     Read_Btns               ; get button status
                LDA     Vec_Btn_State           ; get the current state of all
                                                ; buttons
                CMPA    #$00                    ; is a button pressed?
                BEQ     no_button               ; no, than go on
                BITA    #$01                    ; test for button 1 1
                BEQ     button_1_1_not          ; if not pressed jump
                LDU     #button_1_1_string      ; otherwise display the
                PSHS    A                       ; store A
                JSR     Print_Str_yx            ; string using string function
                PULS    A                       ; restore A
button_1_1_not:
                BITA    #$02                    ; test for button 1 2
                BEQ     button_1_2_not          ; if not pressed jump
                LDU     #button_1_2_string      ; otherwise display the
                PSHS    A                       ; store A
                JSR     Print_Str_yx            ; string using string function
                PULS    A                       ; restore A
button_1_2_not:
                BITA    #$04                    ; test for button 1 3
                BEQ     button_1_3_not          ; if not pressed jump
                LDU     #button_1_3_string      ; otherwise display the
                PSHS    A                       ; store A
                JSR     Print_Str_yx            ; string using string function
                PULS    A                       ; restore A
button_1_3_not:
                BITA    #$08                    ; test for button 1 4
                BEQ     button_1_4_not          ; if not pressed jump
                LDU     #button_1_4_string      ; otherwise display the
                PSHS    A                       ; store A
                JSR     Print_Str_yx            ; string using string function
                PULS    A                       ; restore A
button_1_4_not:
                BITA    #$10                    ; test for button 2 1
                BEQ     button_2_1_not          ; if not pressed jump
                LDU     #button_2_1_string      ; otherwise display the
                PSHS    A                       ; store A
                JSR     Print_Str_yx            ; string using string function
                PULS    A                       ; restore A
button_2_1_not:
                BITA    #$20                    ; test for button 2 2
                BEQ     button_2_2_not          ; if not pressed jump
                LDU     #button_2_2_string      ; otherwise display the
                PSHS    A                       ; store A
                JSR     Print_Str_yx            ; string using string function
                PULS    A                       ; restore A
button_2_2_not:
                BITA    #$40                    ; test for button 2 3
                BEQ     button_2_3_not          ; if not pressed jump
                LDU     #button_2_3_string      ; otherwise display the
                PSHS    A                       ; store A
                JSR     Print_Str_yx            ; string using string function
                PULS    A                       ; restore A
button_2_3_not:
                BITA    #$80                    ; test for button 2 4
                BEQ     button_2_4_not          ; if not pressed jump
                LDU     #button_2_4_string      ; otherwise display the
                JSR     Print_Str_yx            ; string using string function
button_2_4_not:
                BRA     main_loop               ; go on, repeat...
no_button:
                LDU     #no_button_string
                JSR     Print_Str_yx
                BRA     main_loop               ; and repeat forever
;***************************************************************************
no_button_string:
                DB 50,-50,"NO BUTTON PRESSED", $80
button_1_1_string:
                DB 40,-50,"JOYPAD 1 BUTTON 1", $80
button_1_2_string:
                DB 30,-50,"JOYPAD 1 BUTTON 2", $80
button_1_3_string:
                DB 20,-50,"JOYPAD 1 BUTTON 3", $80
button_1_4_string:
                DB 10,-50,"JOYPAD 1 BUTTON 4", $80
button_2_1_string:
                DB 0,-50,"JOYPAD 2 BUTTON 1", $80
button_2_2_string:
                DB -10,-50,"JOYPAD 2 BUTTON 2", $80
button_2_3_string:
                DB -20,-50,"JOYPAD 2 BUTTON 3", $80
button_2_4_string:
                DB -30,-50,"JOYPAD 2 BUTTON 4", $80
;***************************************************************************
                END main
;***************************************************************************
