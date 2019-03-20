;***************************************************************************
draw_maze:
                direct  $d0             ; following code uses d0
                CLR     helper_first

                LDA     move_offset_y
                SUBA    #STEPS
                NEGA
                LDB     #LAB_REDUCT_1
                MUL
                DIV_D_BY_DOUBLE_STEP_TO_B ; and divide by DOUBLE STEP
                NEGB
                ADDB    #LAB_SCALE
                STB     scale_step
                CMPB    #$58
                BGT     no_correcting
                INC     helper_first
no_correcting:

                LDB     move_offset_y

                ; Depending on size of LAB
                ; if steps are smaller use one shift less!
                ASRB
                ASRB
                ASRB
                ADDB    #($7f - (STEPS/8))
                STB     maze_intensity

                LDA     maze_draw_y
                STA     view_pos_y
                INCA
                ASLA
                ASLA
                LDX     #maze_ram       ; if u not used, we can put this
                                        ; out of the loop and do
                                        ; and LEAU 4,U!
                INCA ; x = 1 in maze_ram
                LEAU    A,X
next_maze:
                LDA     scale_step
                STA     VIA_t1_cnt_lo     ; move to time 1 lo, this means scaling

                LDA     maze_intensity
                INTENSITY_A               ;

                LDD     vpos_1
                MOVE_TO_D_OPEN
in_first:

                ; allways draw at least ONE frame
                LDA     ,U
                CMPA    #'#'
                BEQ     square_full

; here we have a good south square
                LDA     -1,U
                ADDA    -1-MAZE_X_RAM, U
                CMPA    #' '+' '; two spaces in a row
                BEQ     square_quarter_left

                LDA     1,U
                ADDA    1-MAZE_X_RAM, U
                CMPA    #' '+' '; two spaces in a row
                BEQ     square_quarter_right

                LDX     #square_half_vlist
                BRA     draw_square

square_quarter_left:
                LDX     #square_quarter_left_vlist
                LDA     1,U
                ADDA    1-MAZE_X_RAM, U
                CMPA    #' '+' '; two spaces in a row
                BNE     draw_square

                BRA     draw_no_square

square_quarter_right:
                LDX     #square_quarter_right_vlist
                BRA     draw_square
square_full:
                LDX     #square_full_vlist
draw_square:
                LDB     #$40
wait_for_move_finish:
                BITB    VIA_int_flags
                BEQ     wait_for_move_finish
                JSR     Draw_VLp
draw_no_square:

; check side walls
                LDA     1-MAZE_X_RAM,U
                CMPA    #'#'
                BEQ     left_wall

                LDA     1,U
                CMPA    #' '
                BEQ     no_left
no_no_left:
                LDX     #no_left_wall_vlist
                JSR     Draw_VLp
                LDX     #no_left_return
                JSR     Draw_VLp
                BRA     no_left
left_wall:
                LDA     helper_first
                BNE     draw_usual_left

                LDX     #left_wall_vlist_first
                JSR     Draw_VLp
                LDX     #left_return_first
                JSR     Draw_VLp
                BRA     no_left
draw_usual_left:
                LDX     #left_wall_vlist
                JSR     Draw_VLp
                LDX     #left_return
                JSR     Draw_VLp
no_left:

                LDA     -1-MAZE_X_RAM,U
                CMPA    #'#'
                BEQ     right_wall

                LDA     -1,U
                CMPA    #' '
                BEQ     no_right

                LDX     #no_right_wall_vlist
                JSR     Draw_VLp
                BRA     no_right
right_wall:
                LDA     helper_first
                BNE     draw_usual_right
                LDX     #right_wall_vlist_first
                JSR     Draw_VLp
                BRA     no_right
draw_usual_right:

                LDX     #right_wall_vlist
                JSR     Draw_VLp
no_right:
                INC     helper_first
                LDA     ,U
                CMPA    #'#'
                LBEQ    draw_finished

; bra no_monster_in_front
; do monster stuff
; if we do all monster stuff here we don't have to worry about
; positioning, since we are last :-)

; calculate scale for image
; that is our offset + figure offset + mazeparts in between
                INC     view_pos_y        ; view position of current maze square
                LDB     view_pos_y        ; current position in view
                CMPB    V_MONSTER_Y       ; y pos equal?
                LBNE    no_monster_in_front; no -> branch

                ; we have a monster in our visibility!

                _ZERO_VECTOR_BEAM
                ; calculate size
                ; since monsters can move of there own,
                ; we must :-( calculate their size!

                CLR      tmp0             ; helper for # of divides for scale

                LDB      move_offset_y    ; load our own offset
                SEX                       ; we use bigger numbers now
                ADDD     V_MONSTER_OFFSET_Y ; offset it with monster offset

                ; D is -DOUBLE_STEP - +DOUBLE_STEP
                ; should be -STEP - +STEP
                ; that's what we do now
                TSTA                      ; is it negative?
                BMI      negative_steps   ; well, than go there
                CMPD     #STEPS           ; is it to big?
                                          ; to big means the combined offsets
                                          ; are smaller than one maze square
                                          ; so we have to use one divider
                                          ; less
                BLT      step_fiddling_done ; nope, than all ok
                SUBD     #DOUBLE_STEP     ; to big, correct offset
                DEC      tmp0             ; and one LSR less
                BPL      step_fiddling_done ; done here
overflow_minus:
                LDA     V_MONSTER_Y       ; y pos of monster, allways greater than man!
                SUBA    maze_draw_y       ; our own position
                ADDA    tmp0              ; any offsets from above added
                DECA
                BPL     step_fiddling_done
                ADDD    #(STEPS+$7f)
                LBRA    halving_done
negative_steps:
                CMPD     #-STEPS          ; is it to small?
                                          ; to small means the combined offsets
                                          ; are bigger than one maze square
                                          ; so we have to use one divider
                                          ; more

                BGT      step_fiddling_done ; nope, than all ok
                ADDD     #DOUBLE_STEP     ; to small, correct offset
                INC      tmp0             ; and one LSR more

step_fiddling_done:
                ; B is be -STEP - +STEP
                ; should be 0 - +DOUBLE_STEP
                SUBB     #STEPS
                NEGB

                ; in D now 0 - DOUBLE_STEP
                LDA     #LAB_REDUCT_1      ; multiply with laby magic
                MUL
                DIV_D_BY_DOUBLE_STEP_TO_B  ; and divide by DOUBLE STEP
                NEGB                       ; do more magic
                ADDB    #LAB_SCALE         ; and voila our first scale is there!

                ; now lets see how many divides we need
                LDA     V_MONSTER_Y        ; y pos of monster, allways greater than man!
                SUBA    maze_draw_y        ; our own position
                ADDA    tmp0               ; any offsets from above added
                DECA
                BEQ     halving_done       ; perhaps nothing to do?
halving_again:
                LSRB                       ; halve it
                DECA                       ; loop count -1
                BNE     halving_again      ; done?
halving_done:
                STB     scale_shadow
                ; phuu
                ; done the sizing of our creature
                ; shitty stuff
                LDB     V_MONSTER_X        ; x  equal?
                DECB
                LBEQ     center_display
                BMI     right_display
left_display:
                LDX     V_MONSTER_POINTER  ; x pointer to monster level list
                LDX     C_MONSTER_GRAPHIC,X; load pointer to current graphic
                PSHS U

                ; bei gesamtbreite des monsters = 2 * SQUARE SIZE!,
                ; dann koennte die X pos als
                ; clipping gebarucht werden!
                ; Am einfachsten, einen 0 offset von links einf�hren!
                LDB     V_MONSTER_OFFSET_X ; these are steps, gotto convert to 2 * square
                                           ; step == square
                NEGB
                SEX
                JSR     clip_vlp_p2_left

                PULS U

                LDA     V_MONSTER_MOVEMENT_AXIS
                BEQ     not_in_axis_left

                LDB     scale_shadow
                STB     VIA_t1_cnt_lo     ; move to time 1 lo, this means scaling

                LDA     #0
                LDB     #-SQUARE_SIZE
                JSR     my_move_to_d

                LDB     scale_shadow
                LSRB                      ; halve it
                STB     VIA_t1_cnt_lo     ; move to time 1 lo, this means scaling

                BRA     move_monster_left
not_in_axis_left:

                LDA     #0
                LDB     #-SQUARE_SIZE
                JSR     my_move_to_d

                LDB     scale_shadow
                LSRB                      ; halve it
                STB     VIA_t1_cnt_lo     ; move to time 1 lo, this means scaling
move_monster_left:
                LDA     #0
                LDB     V_MONSTER_OFFSET_X
                JSR     my_move_to_d

; geklippte sprites von der seite 'springen' in den anfangskoordinaten!
                JSR     Draw_VLp
                BRA     finish_current_maze
right_display:
                LDX     V_MONSTER_POINTER   ; x pointer to monster level list
                LDX     C_MONSTER_GRAPHIC,X                ; load pointer to current graphic
                PSHS U

                ; bei gesamtbreite des monsters = 2 * SQUARE SIZE!,
                ; dann koennte die X pos als
                ; clipping gebarucht werden!
                ; Am einfachsten, einen 0 offset von links einf�hren!
                LDB     V_MONSTER_OFFSET_X ; these are steps, gotto convert to 2* square
                                         ; step == square
                NEGB
                SEX
                JSR     clip_vlp_p2_right

                PULS U

                LDA     V_MONSTER_MOVEMENT_AXIS
                BEQ     not_in_axis_right

                LDB     scale_shadow
                STB     VIA_t1_cnt_lo     ; move to time 1 lo, this means scaling

                LDA     #0
                LDB     #SQUARE_SIZE
                JSR     my_move_to_d

                LDB     scale_shadow
                LSRB                      ; halve it
                STB     VIA_t1_cnt_lo     ; move to time 1 lo, this means scaling

                BRA     move_monster_right
not_in_axis_right:
                LDA     #0
                LDB     #SQUARE_SIZE
                JSR     my_move_to_d

                LDB     scale_shadow
                LSRB                      ; halve it
                STB     VIA_t1_cnt_lo     ; move to time 1 lo, this means scaling
move_monster_right:
                LDA     #0
                LDB     V_MONSTER_OFFSET_X
                JSR     my_move_to_d

                JSR     Draw_VLp
                BRA     finish_current_maze
center_display:
                LDX     V_MONSTER_POINTER   ; x pointer to monster level list
                LDX     C_MONSTER_GRAPHIC,X                ; load pointer to current graphic

                ; bei gesamtbreite des monsters = 2 * SQUARE SIZE!,
                ; dann koennte die X pos als
                ; clipping gebarucht werden!
                ; Am einfachsten, einen 0 offset von links einf�hren!
                LDB     V_MONSTER_OFFSET_X ; these are steps, gotto convert to 2* square
                CMPB #(-(STEPS/2))
                BGT no_lower_clip
                NEGB
                SEX
                SUBD    #2*STEPS
                PSHS U

                JSR     clip_vlp_p2_left

                PULS U
no_lower_clip:

                LDB     scale_shadow
                LSRB                      ; halve it
                STB     VIA_t1_cnt_lo     ; move to time 1 lo, this means scaling

                LDA     #0
                LDB     V_MONSTER_OFFSET_X
                JSR     my_move_to_d

                ; now we can display it :-)
                JSR     Draw_VLp

no_monster_in_front:
finish_current_maze:
                _ZERO_VECTOR_BEAM
                LDA     maze_intensity
                SUBA    #LIGHT

                BMI     draw_finished
                STA     maze_intensity

                LSR     scale_step
                LEAU    4,U
                BRA     next_maze
draw_finished:
                RTS

;***************************************************************************
draw_maze_digit:
                direct  $d0             ; following code uses d0
                CLR     helper_first

                NEXT_DIGIT_BYTE

                LDA     move_offset_y
                SUBA    #STEPS
                NEGA
                LDB     #LAB_REDUCT_1
                MUL
                DIV_D_BY_DOUBLE_STEP_TO_B ; and divide by DOUBLE STEP
                NEGB
                ADDB    #LAB_SCALE
                STB     scale_step
                CMPB    #$58
                BGT     no_correcting_digit
                INC     helper_first
no_correcting_digit:

                NEXT_DIGIT_BYTE

                LDB     move_offset_y

                ; Depending on size of LAB
                ; if steps are smaller use one shift less!
                ASRB
                ASRB
                ASRB
                ADDB    #($7f - (STEPS/8))
                STB     maze_intensity

                LDA     maze_draw_y
                STA     view_pos_y
                INCA
                ASLA
                ASLA
                LDX     #maze_ram       ; if u not used, we can put this
                                        ; out of the loop and do
                                        ; and LEAU 4,U!
                INCA ; x = 1 in maze_ram
                LEAU    A,X
next_maze_digit:
                LDA     scale_step
                STA     VIA_t1_cnt_lo     ; move to time 1 lo, this means scaling

                LDA     maze_intensity
                INTENSITY_A               ;

                LDD     vpos_1
                MOVE_TO_D_OPEN

                LDA     ,U
                CMPA    #'#'
                BEQ     square_full_digit

; here we have a good south square
                LDA     -1,U
                ADDA    -1-MAZE_X_RAM, U
                CMPA    #' '+' '; two spaces in a row
                BEQ     square_quarter_left_digit

                LDA     1,U
                ADDA    1-MAZE_X_RAM, U
                CMPA    #' '+' '; two spaces in a row
                BEQ     square_quarter_right_digit

                LDX     #square_half_vlist
                BRA     draw_square_digit

square_quarter_left_digit:
                LDX     #square_quarter_left_vlist
                LDA     1,U
                ADDA    1-MAZE_X_RAM, U
                CMPA    #' '+' '; two spaces in a row
                BNE     draw_square_digit

                BRA     draw_no_square_digit

square_quarter_right_digit:
                LDX     #square_quarter_right_vlist
                BRA     draw_square_digit
square_full_digit:
                LDX     #square_full_vlist
draw_square_digit:
                LDB     #$40
wait_for_move_finish_digit:
                BITB    VIA_int_flags
                BEQ     wait_for_move_finish_digit
                JSR     Draw_VLp_digit
draw_no_square_digit:

; check side walls
                LDA     1-MAZE_X_RAM,U
                CMPA    #'#'
                BEQ     left_wall_digit

                LDA     1,U
                CMPA    #' '
                BEQ     no_left_digit
no_no_left_digit:
                LDX     #no_left_wall_vlist
                JSR     Draw_VLp_digit
                LDX     #no_left_return
                JSR     Draw_VLp_digit
                BRA     no_left_digit
left_wall_digit:
                LDA     helper_first
                BNE     draw_usual_left_digit

                LDX     #left_wall_vlist_first
                JSR     Draw_VLp_digit
                LDX     #left_return_first
                JSR     Draw_VLp_digit
                BRA     no_left_digit
draw_usual_left_digit:
                LDX     #left_wall_vlist
                JSR     Draw_VLp_digit
                LDX     #left_return
                JSR     Draw_VLp_digit
no_left_digit:
                LDA     -1-MAZE_X_RAM,U
                CMPA    #'#'
                BEQ     right_wall_digit

                LDA     -1,U
                CMPA    #' '
                BEQ     no_right_digit

                LDX     #no_right_wall_vlist
                JSR     Draw_VLp_digit
                BRA     no_right_digit
right_wall_digit:
                LDA     helper_first
                BNE     draw_usual_right_digit
                LDX     #right_wall_vlist_first
                JSR     Draw_VLp_digit
                BRA     no_right_digit
draw_usual_right_digit:

                LDX     #right_wall_vlist
                JSR     Draw_VLp_digit
no_right_digit:
                INC     helper_first

                LDA     ,U
                CMPA    #'#'
                LBEQ    draw_finished_digit

; bra no_monster_in_front
; do monster stuff
; if we do all monster stuff here we don't have to worry about
; positioning, since we are last :-)

; calculate scale for image
; that is our offset + figure offset + mazeparts in between
                INC     view_pos_y        ; view position of current maze square
                LDB     view_pos_y        ; current position in view
                CMPB    V_MONSTER_Y  ; y pos equal?
                LBNE    no_monster_in_front_digit; no -> branch


                ; we have a monster in our visibility!
                _ZERO_VECTOR_BEAM

                ; calculate size
                ; since monsters can move of there own,
                ; we must :-( calculate their size!

                ; following is already set from above
                ; keep it here as a reminder that we use it!

                CLR      tmp0             ; helper for # of divides for scale

                LDB      move_offset_y    ; load our own offset
                SEX                       ; we use bigger numbers now
                ADDD     V_MONSTER_OFFSET_Y ; offset it with monster offset

                ; D is -DOUBLE_STEP - +DOUBLE_STEP
                ; should be -STEP - +STEP
                ; that's what we do now
                TSTA                      ; is it negative?
                BMI      negative_steps_digit ; well, than go there
                CMPD     #STEPS           ; is it to big?
                                          ; to big means the combined offsets
                                          ; are smaller than one maze square
                                          ; so we have to use one divider
                                          ; less
                BLT      step_fiddling_done_digit ; nope, than all ok
                SUBD     #DOUBLE_STEP     ; to big, correct offset
                DEC      tmp0             ; and one LSR less
                BPL      step_fiddling_done_digit ; done here
overflow_minus_digit:
                LDA      V_MONSTER_Y       ; y pos of monster, allways greater than man!
                SUBA     maze_draw_y       ; our own position
                ADDA     tmp0              ; any offsets from above added
                DECA
                BPL      step_fiddling_done_digit

                ADDD     #(STEPS + $7f)
                LBRA     halving_done_digit
negative_steps_digit:
                CMPD     #-STEPS          ; is it to small?
                                          ; to small means the combined offsets
                                          ; are bigger than one maze square
                                          ; so we have to use one divider
                                          ; more

                BGT      step_fiddling_done_digit ; nope, than all ok
                ADDD     #DOUBLE_STEP     ; to small, correct offset
                INC      tmp0             ; and one LSR more

step_fiddling_done_digit:
                ; B is be -STEP - +STEP
                ; should be 0 - +DOUBLE_STEP
                SUBB     #STEPS
                NEGB

                PSHS D
                NEXT_DIGIT_BYTE
                PULS D

                ; in D now 0 - DOUBLE_STEP
                LDA     #LAB_REDUCT_1     ; multiply with laby magic
                MUL
                DIV_D_BY_DOUBLE_STEP_TO_B ; and divide by DOUBLE STEP

                NEGB                      ; do more magic
                ADDB    #LAB_SCALE        ; and voila our first scale is there!

                ; now lets see how many divides we need
                LDA     V_MONSTER_Y  ; y pos of monster, allways greater than man!
                SUBA    maze_draw_y       ; our own position
                ADDA    tmp0              ; any offsets from above added
                DECA
                BEQ     halving_done_digit; perhaps nothing to do?
halving_again_digit:
                LSRB                      ; halve it
                DECA                      ; loop count -1
                BNE     halving_again_digit ; done?
halving_done_digit:
                STB     scale_shadow

                ; phuu
                ; done the sizing of our creature
                ; shitty stuff

                LDB     V_MONSTER_X  ; x  equal?
                DECB
                LBEQ    center_display_digit
                BMI     right_display_digit
left_display_digit:

                LDX     V_MONSTER_POINTER   ; x pointer to monster level list
                LDX     C_MONSTER_GRAPHIC,X                ; load pointer to current graphic

                PSHS U

                ; bei gesamtbreite des monsters = 2 * SQUARE SIZE!,
                ; dann koennte die X pos als
                ; clipping gebarucht werden!
                ; Am einfachsten, einen 0 offset von links einf�hren!
                NEXT_DIGIT_BYTE
                LDB     V_MONSTER_OFFSET_X ; these are steps, gotto convert to 2* square
                                         ; step == square
                NEGB
                SEX

                JSR     clip_vlp_p2_left_digit
                PULS U

                LDA     V_MONSTER_MOVEMENT_AXIS
                BEQ     not_in_axis_left_digit

                LDB     scale_shadow
                STB     VIA_t1_cnt_lo     ; move to time 1 lo, this means scaling

                LDA     #0
                LDB     #-SQUARE_SIZE
                JSR     move_to_d_digit

                LDB     scale_shadow
                LSRB                      ; halve it
                STB     VIA_t1_cnt_lo     ; move to time 1 lo, this means scaling

                BRA     move_monster_left_digit
not_in_axis_left_digit:
                LDA     #0
                LDB     #-SQUARE_SIZE
                JSR     move_to_d_digit

                LDB     scale_shadow
                LSRB                      ; halve it
                STB     VIA_t1_cnt_lo     ; move to time 1 lo, this means scaling
move_monster_left_digit:
                LDA     #0
                LDB     V_MONSTER_OFFSET_X
                JSR     move_to_d_digit

                JSR     Draw_VLp_digit
                LBRA    finish_current_maze_digit
right_display_digit:
                LDX     V_MONSTER_POINTER   ; x pointer to monster level list
                LDX     C_MONSTER_GRAPHIC,X                ; load pointer to current graphic

                PSHS U

                ; bei gesamtbreite des monsters = 2 * SQUARE SIZE!,
                ; dann koennte die X pos als
                ; clipping gebarucht werden!
                ; Am einfachsten, einen 0 offset von links einf�hren!
                NEXT_DIGIT_BYTE
                LDB     V_MONSTER_OFFSET_X ; these are steps, gotto convert to 2* square
                                         ; step == square
                NEGB
                SEX

                JSR     clip_vlp_p2_right_digit
                PULS U

                LDA     V_MONSTER_MOVEMENT_AXIS
                BEQ     not_in_axis_right_digit

                LDB     scale_shadow
                STB     VIA_t1_cnt_lo     ; move to time 1 lo, this means scaling

                LDA     #0
                LDB     #SQUARE_SIZE
                JSR     move_to_d_digit

                LDB     scale_shadow
                LSRB                      ; halve it
                STB     VIA_t1_cnt_lo     ; move to time 1 lo, this means scaling

                BRA     move_monster_right_digit
not_in_axis_right_digit:
                LDA     #0
                LDB     #SQUARE_SIZE
                JSR     move_to_d_digit

                LDB     scale_shadow
                LSRB                      ; halve it
                STB     VIA_t1_cnt_lo     ; move to time 1 lo, this means scaling
move_monster_right_digit:
                LDA     #0
                LDB     V_MONSTER_OFFSET_X
                JSR     move_to_d_digit

                JSR     Draw_VLp_digit
                BRA     finish_current_maze_digit
center_display_digit:
                LDX     V_MONSTER_POINTER   ; x pointer to monster level list
                LDX     C_MONSTER_GRAPHIC,X                ; load pointer to current graphic


                ; bei gesamtbreite des monsters = 2 * SQUARE SIZE!,
                ; dann koennte die X pos als
                ; clipping gebarucht werden!
                ; Am einfachsten, einen 0 offset von links einf�hren!
                NEXT_DIGIT_BYTE
                LDB     V_MONSTER_OFFSET_X ; these are steps, gotto convert to 2* square
                CMPB    #(-(STEPS/2))
                BGT     no_lower_clip_digit
                NEGB
                SEX
                SUBD    #2*STEPS

                PSHS U

                JSR     clip_vlp_p2_left_digit

                PULS U
no_lower_clip_digit:
                LDB     scale_shadow
                LSRB                      ; halve it
                STB     VIA_t1_cnt_lo     ; move to time 1 lo, this means scaling

                LDA     #0
                LDB     V_MONSTER_OFFSET_X
                JSR     move_to_d_digit

                ; now we can display it :-)
                JSR     Draw_VLp_digit

no_monster_in_front_digit:
finish_current_maze_digit:
                _ZERO_VECTOR_BEAM
                LDA     maze_intensity
                SUBA    #LIGHT

                BMI     draw_finished_digit
                STA     maze_intensity

                LSR     scale_step
                LEAU    4,U
                BRA     next_maze_digit
draw_finished_digit:
                RTS


;***************************************************************************
init_looking_west:
                LDB     pos_offset_x
                NEGB
                STB     move_offset_y
                LDA     #(MAZE_SIZE-1)
                SUBA    pos_x
                STA     maze_draw_y
                LDU     #maze_ram
                LDX     current_maze
                LDA     pos_y
                DECA
                LDB     #MAZE_SIZE
                MUL
                LEAX    D,X
                LEAX    MAZE_SIZE-1,X
                LDB     #MAZE_SIZE
copy_maze_west:
                LDA     ,X
                STA     ,U+

                LDA     MAZE_SIZE,X
                STA     ,U+

                LDA     2*MAZE_SIZE,X
                STA     ,U+

                LEAU    1,U

                LEAX    -1,X
                DECB
                BNE     copy_maze_west
                RTS
;***************************************************************************
init_looking_north:
                LDB     pos_offset_y
                NEGB
                STB     move_offset_y
                LDA     #(MAZE_SIZE-1)
                SUBA    pos_y
                STA     maze_draw_y
                LDU     #maze_ram
                LDX     current_maze
                LDA     pos_x
                DECA
                LEAX    A,X
                LEAX    (MAZE_SIZE-1)*MAZE_SIZE,X
                LDB     #MAZE_SIZE
copy_maze_north:
                LDA     2,X
                STA     ,U+

                LDA     1,X
                STA     ,U+

                LDA     ,X
                STA     ,U+

                LEAU    1,U

                LEAX    -MAZE_SIZE,X
                DECB
                BNE     copy_maze_north
                RTS
;***************************************************************************
init_looking_east:
                LDB     pos_offset_x
                STB     move_offset_y
                LDA     pos_x
                STA     maze_draw_y
                LDU     #maze_ram
                LDX     current_maze
                LDA     pos_y
                DECA
                LDB     #MAZE_SIZE
                MUL
                LEAX    D,X
                LDB     #MAZE_SIZE
copy_maze_east:
                LDA     2*MAZE_SIZE,X
                STA     ,U+

                LDA     MAZE_SIZE,X
                STA     ,U+

                LDA     ,X
                STA     ,U+

                LEAU    1,U

                LEAX    1,X
                DECB
                BNE     copy_maze_east
                RTS
;***************************************************************************
init_looking_south:
                LDB     pos_offset_y
                STB     move_offset_y
                LDA     pos_y
                STA     maze_draw_y
                LDU     #maze_ram
                LDX     current_maze
                LDA     pos_x
                DECA
                LEAX    A,X
                LDB     #MAZE_SIZE
copy_maze_south:
                LDA     ,X
                STA     ,U+

                LDA     1,X
                STA     ,U+

                LDA     2,X
                STA     ,U+

                LEAU    1,U

                LEAX    MAZE_SIZE,X
                DECB
                BNE     copy_maze_south
                RTS
;***************************************************************************

 include "DATA\\MAZE_DAT.I"
