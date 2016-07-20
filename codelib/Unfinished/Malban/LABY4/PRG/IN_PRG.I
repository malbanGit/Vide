;***************************************************************************
handle_input:
                JSR     Joy_Digital     ; read joystick positions
                JSR     next_digit
                LDA     Vec_Joy_1_Y     ; load joystick 1 position Y to A
                LBEQ    joystick_done_y
                BMI     moved_down
moved_up:
                LDA     maze_draw_y     ; load current y position
                INCA                    ; look at next wall, not
                                        ; at current position

                ASLA                    ; maze view is 4 size
                ASLA
                INCA                    ; plus 1 for current position

                LDX     #maze_ram       ; and load maze address
                LEAU    A,X             ; add them
                                        ; in U position ahead of current position
                LDA     ,U              ; A has current ahead char

                LDB     move_offset_y
                ADDB    #SPEED
                STB     move_offset_y
                CMPB    #STEPS
                BLT     up_done

                CMPA    #'#'
                BEQ     up_not_allowed

                INC     maze_draw_y
                LDA     #-(STEPS-1)
                STA     move_offset_y
                BRA     up_done
up_not_allowed:
                LDA     #(STEPS-(SPEED-1))
                STA     move_offset_y
up_done:
                BRA     joystick_done_y
moved_down:
                LDA     maze_draw_y     ; load current y position
                DECA                    ; look at wall behind, not
                                        ; at current position

                ASLA                    ; maze view is 4 size
                ASLA
                INCA                    ; plus 1 for current position

                LDX     #maze_ram       ; and load maze address
                LEAU    A,X             ; add them
                                        ; in U position ahead of current position
                LDA     ,U              ; A has current ahead char

                LDB     move_offset_y
                SUBB    #SPEED
                STB     move_offset_y
                CMPB    #(-STEPS)
                BGT     joystick_done_y

                CMPA    #'#'
                BEQ     down_not_allowed

                DEC     maze_draw_y
                LDA     #(STEPS-1)
                STA     move_offset_y
                BRA     joystick_done_y
down_not_allowed:
                LDA     #-(STEPS-(SPEED-1))
                STA     move_offset_y
joystick_done_y:
                LDA     Vec_Joy_1_X       ; load joystick 1 position Y to A
                BEQ     joystick_done_really
                CMPA    last_x_pressed
                BEQ     joystick_done_really
                STA     last_x_pressed
                BMI     turn_right
turn_left:
                JSR     display_turn_left
                JSR     init_turn_left
                RTS
turn_right:
                JSR     display_turn_right
                JSR     init_turn_right
                RTS
joystick_done_really:
                STA     last_x_pressed
                RTS
;***************************************************************************
handle_input_digit:
                JSR     Joy_Digital       ; read joystick positions
                NEXT_DIGIT_BYTE
                LDA     Vec_Joy_1_Y       ; load joystick 1 position Y to A
                LBEQ    joystick_done_y_digit
                BMI     moved_down_digit
moved_up_digit:
                LDA     maze_draw_y     ; load current y position
                INCA                    ; look at next wall, not
                                        ; at current position

                ASLA                    ; maze view is 4 size
                ASLA
                INCA                    ; plus 1 for current position

                LDX     #maze_ram       ; and load maze address
                LEAU    A,X             ; add them
                                        ; in U position ahead of current position
                LDA     ,U              ; A has current ahead char

                LDB     move_offset_y
                ADDB    #SPEED
                STB     move_offset_y
                CMPB    #STEPS
                BLT     up_done_digit

                CMPA    #'#'
                BEQ     up_not_allowed_digit

                INC     maze_draw_y
                LDA     #-(STEPS-1)
                STA     move_offset_y
                BRA     up_done_digit
up_not_allowed_digit:
                LDA     #(STEPS-(SPEED-1))
                STA     move_offset_y
up_done_digit:
                BRA     joystick_done_y_digit
moved_down_digit:
                LDA     maze_draw_y     ; load current y position
                DECA                    ; look at wall behind, not
                                        ; at current position

                ASLA                    ; maze view is 4 size
                ASLA
                INCA                    ; plus 1 for current position

                LDX     #maze_ram       ; and load maze address
                LEAU    A,X             ; add them
                                        ; in U position ahead of current position
                LDA     ,U              ; A has current ahead char

                LDB     move_offset_y
                SUBB    #SPEED
                STB     move_offset_y
                CMPB    #(-STEPS)
                BGT     joystick_done_y_digit

                CMPA    #'#'
                BEQ     down_not_allowed_digit

                DEC     maze_draw_y
                LDA     #(STEPS-1)
                STA     move_offset_y
                BRA     joystick_done_y_digit
down_not_allowed_digit:
                LDA     #-(STEPS-(SPEED-1))
                STA     move_offset_y
joystick_done_y_digit:
                LDA     Vec_Joy_1_X       ; load joystick 1 position Y to A
                BEQ     joystick_done_really_digit
                CMPA    last_x_pressed
                BEQ     joystick_done_really_digit
                STA     last_x_pressed
                BMI     turn_right_digit
turn_left_digit:
                JSR     display_turn_left
                JSR     init_turn_left
                RTS
turn_right_digit:
                JSR     display_turn_right
                JSR     init_turn_right
                RTS
joystick_done_really_digit:
                STA     last_x_pressed
                RTS
;***************************************************************************
