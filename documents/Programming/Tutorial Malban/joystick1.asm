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
                DB      "JOYSTICK 1 TEST",$80   ; some game information,
                                                ; ending with $80
                DB      0                       ; end of game header
;***************************************************************************
; CODE SECTION
;***************************************************************************
; here the cartridge program starts off
                LDD     #$FC20                  ; HEIGTH, WIDTH (-4, 32)
                STD     Vec_Text_HW             ; store to BIOS RAM location
                LDA     #1                      ; these set up the joystick
                STA     Vec_Joy_Mux_1_X         ; enquiries
                LDA     #3                      ; allowing only all directions
                STA     Vec_Joy_Mux_1_Y         ; for joystick one
                LDA     #0                      ; this setting up saves a few
                STA     Vec_Joy_Mux_2_X         ; hundred cycles
                STA     Vec_Joy_Mux_2_Y         ; don't miss it, if you don't
                                                ; need the second joystick!
main:
main_loop:
                JSR     Wait_Recal              ; Vectrex BIOS recalibration
                JSR     Intensity_5F            ; Sets the intensity of the
                                                ; vector beam to $5f
                JSR     Joy_Digital             ; read joystick positions
                LDA     Vec_Joy_1_X             ; load joystick 1 position
                                                ; X to A
                BEQ     no_x_movement           ; if zero, than no x position
                BMI     left_move               ; if negative, than left
                                                ; otherwise right
right_move:
                LDU     #joypad_right_string    ; display right string
                BRA     x_done                  ; goto x done
left_move:
                LDU     #joypad_left_string     ; display left string
                BRA     x_done                  ; goto x done
no_x_movement:
                LDU     #no_joypad_x_string     ; display no x string
x_done:
                JSR     Print_Str_yx            ; using string function
                LDA     Vec_Joy_1_Y             ; load joystick 1 position
                                                ; Y to A
                BEQ     no_y_movement           ; if zero, than no y position
                BMI     down_move               ; if negative, than down
                                                ; otherwise up
up_move:
                LDU     #joypad_up_string       ; display up string
                BRA     y_done                  ; goto y done
down_move:
                LDU     #joypad_down_string     ; display down string
                BRA     y_done                  ; goto y done
no_y_movement:
                LDU     #no_joypad_y_string     ; display no y string
y_done:
                JSR     Print_Str_yx            ; using string function
                BRA     main_loop               ; and repeat forever
;***************************************************************************
no_joypad_x_string:
                DB 40,-50,"NO JOYPAD X INPUT", $80
joypad_right_string:
                DB 40,-50,"JOYPAD 1 RIGHT", $80
joypad_left_string:
                DB 40,-50,"JOYPAD 1 LEFT", $80
no_joypad_y_string:
                DB 20,-50,"NO JOYPAD Y INPUT", $80
joypad_up_string:
                DB 20,-50,"JOYPAD 1 UP", $80
joypad_down_string:
                DB 20,-50,"JOYPAD 1 DOWN", $80
;***************************************************************************
                END main
;***************************************************************************
