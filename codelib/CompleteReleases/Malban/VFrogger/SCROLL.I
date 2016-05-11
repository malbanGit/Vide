; this file is part of vectrex frogger, written by Malban
; in March-April 1998
; all stuff contained here is public domain
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; scroll subroutines used in the startup screen                             ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
;***************************************************************************
; below are all subroutines for scroll text
; scrolling from right to left!
; (only two) set_up_scrolling(), do_one_scroll_step()
; scroll text ends with $80
; this restarts scrolling...
;***************************************************************************
; expects text address in X register
; scroll_y:                  the y coordinate (signed byte value)
; scroll_left_boundary       (signed byte value)
; scroll_right_boundary      (signed byte value)
; scroll_speed               (signed byte value) must be negative
; scroll_intensity           (byte value)
;
; NUMBER_OF_SCROLL_LETTERS
;
; uses tmp1, tmp2
set_up_scrolling:
                direct $c8
                STX     scroll_text_address_start ; remember address of first letter
                STX     scroll_text_address_current ; and store it as current address
                LDD     #NUMBER_OF_SCROLL_LETTERS ; how many letters are at most to be displayed at once?
                STD     tmp1               ; remember that value in tmp1 (16 bit)
;                CLR     tmp1               ; make it 16 bit
                LDB     scroll_right_boundary ; load right boundary
                SUBB    scroll_left_boundary ; subtract left boundary
                CLRA                       ; SEX it, this is the 16 bit width 'in pixel'
                MY_DIV_D_BY_TMP1_TO_B      ; divide it by the number od letters to be displayed
                STB     scroll_step_width  ; remember that as the scroll step...
                LDA     #NUMBER_OF_SCROLL_LETTERS ; set loop counter for initializing the scroll objects
                STA     tmp1               ; remember that too in tmp1 (only 8 bit this time)
                LDX     #scroll_objects    ; get address of the first 'scroll object' (RAM address)
                LDB     scroll_y           ; get the y position of the scroll text
                LDA     scroll_right_boundary ; and screen address where first letter will appear
                ; now we loop 'NUMBER_OF_SCROLL_LETTERS' times to set up our object space
scroll_setup_loop1:
                STB     ,X+                ; y coordinate, from above
                STA     ,X+                ; x coordinate, from above
                CLR     ,X+                ; no object yet
                CLR     ,X+                ; no object yet, these two are an address pointer,
                                           ; zero means a SPACE is printed...
                CLR     ,X+                ; no x offset yet, here we will remember
                                           ; the x offset later on, must remember this,
                                           ; otherwise letters will overlap eventually...
                SUBA    scroll_step_width  ; go one letter to the left (x coordinate that is)
                DEC     tmp1               ; decrements our loop counter
                BNE     scroll_setup_loop1 ; if not finnished ... loop again
                LDA     #$ff               ; otherwise store a 'ff' as an and marker
                STA     ,X+                ; y coordinate ff loop over
                RTS                        ; bye bye...
;***************************************************************************
; does one scroll step of text initialized with the above function
; does also all printing...
; expects dp set to d0
; sets intensity and trashs beam position (as well as everything else...)
; destroys tmp1
do_one_scroll_step:
                direct $d0
                LDA     scroll_intensity   ; load intensity
                JSR     Intensity_a
                LDU     #scroll_objects    ; get address of our scroll objects
                ; now loop thru all objects, till we find a $ff
                ; than we are done...
next_scroll_object:
                MY_GAME_SCALE              ; first set our scaling (whatever we designed our
                                           ; object offsets for)
                _ZERO_VECTOR_BEAM          ; than go to zero (pitty :-()
                                           ; but I guess we have to, otherwise
                                           ; the position will garble up I think
                LDD     ,U+                ; load y, x coordinate
                                           ; A,B=D, increment U by 1, U pointing to X
                                           ; coordinate now
                CMPA    #$ff               ; are we done yet?
                LBEQ    scroll_objects_all_done ; if so, jump out of the loop
                ADDB    scroll_speed       ; add to B (x coordinate that is)
                                           ; the speed value
                CMPB    scroll_left_boundary; is on left side out of bounds?
                BGT     scroll_bound_test_done ; if not go on...
                ; otherwise ...
                ; init new letter here
                LDY     scroll_text_address_current ; get address of current letter
                LDB     ,Y                 ; load the current letter to B
                CMPB    #$80               ; compare to $80, end marker
                BNE     scroll_text_not_over_yet ; if not set, go on
                LDY     scroll_text_address_start ; otherwise load start address of text
                STY     scroll_text_address_current ; store it as current
                LDB     ,Y                 ; and load the first letter of the text to B
scroll_text_not_over_yet:
                ; here we certainly have a correct 'letter'- value in B register
                CMPB    #' '               ; really correct? isn't it a SPACE
                BNE     no_scroll_space    ; no? than go on...
                LDX     #0                 ; otherwise zero everything, pointer to vector list
                LDD     #0                 ; and offsets
                BRA     load_x_with_letter_address_done ; go on
no_scroll_space:
                CMPB    #'.'               ; is it even a 'fullstop'
                BNE     no_scroll_fullstop ; if not... go on
                LDX     #_fs               ; if it is load vectorlist addres to X
;                LDD     -2,X               ; and load the offsets to D
;                BRA     load_x_with_letter_address_done ; and go on
                BRA     load1_x_with_letter_address_don ; and go on
no_scroll_fullstop:
                CMPB    #'0'               ; is it even a 'turtle' :-)
                BNE     no_scroll_0 ; if not... go on
                LDX     #_t_               ; if it is load vectorlist addres to X
;                LDD     -2,X               ; and load the offsets to D
;                BRA     load_x_with_letter_address_done ; and go on
                BRA     load1_x_with_letter_address_don ; and go on
no_scroll_0:
                ; no it should be a 'real' letter (CAPITAL!!!)
                ; lets calculate the abc-table offset...
                SUBB    #'A'               ; subtract smallest letter, so A has 0 offset
                LSLB                       ; multiply by two, since addresses are 16 bit
                CLRA                       ; SEX it :-)
                ADDD    #_abc              ; and add the abc (table of vector list address of the alphabet's letters)
                TFR     D,X                ; get that into an index register (X)
                LDX     ,X                 ; load the letters address from the table
load1_x_with_letter_address_don:
                LDD     -2,X               ; and load the vector list offsets to D
load_x_with_letter_address_done:
                ; now we correct everything ...
                STX     1,U                ; save vectorlist address to objectlist
                STD     tmp1               ; remember the offsets

                ; now a small intermezzo...
                ; just increment the letter pointer in our
                ; text by one... so that the next letter will be correctly
                ; handled
                LDD     scroll_text_address_current ; load current text address to D
                ADDD    #1                 ; increment one
                STD     scroll_text_address_current ; and store it back

                ; ok, now back to that offset stuff from above
                ; swap old and new offsets...
                LDA     3,U                ; load x offset of old letter to A (from object list)
                LDB     tmp1+1             ; load x offset of new letter to B (from remembering from above)
                STA     tmp1+1             ; store the old offset to tmp1 + 1
                STB     3,U                ; and put the new offset into our object list
                ADDB    scroll_right_boundary ; now add the right boundary address to B

                SUBB    tmp1+1             ; and subtract the old offset from that, that
                                           ; is our new start address (screen oriented)
                                           ; (might even be further right than our
                                           ; dedicated start address, but that can't be helped)
                LDA     scroll_y           ; load y address
                ADDA    tmp1               ; modify that with new y offset ONLY
                STA     -1,U               ; and store that to our object list
scroll_bound_test_done:
                STB     ,U+                ; store the new x position, and increment U
                MY_MOVE_TO_D               ; move to the required position
                LDX     ,U++               ; load object vector list to X,
                BEQ     no_space_draw      ; don't draw if vector is not available (== 0 means SPACE)
                _SCALE (SCROLL_SCALE_FACTOR) ; pitty we have to do this!
                _DRAW_VLC                  ; (1MAKRO2) and draw the vector list
no_space_draw:
                LEAU    1,U                ; increment object list by one, since we are not
                                           ; really interested in the x offset at that point
                                           ; anymore...
                BRA     next_scroll_object ; and go on with our next listobject...
scroll_objects_all_done:
                RTS                        ; ok, that was our scroll step :-)
;***************************************************************************
; used variables and constants...
;
;SCROLL_SCALE_FACTOR             EQU    $6
;NUMBER_OF_SCROLL_LETTERS        EQU    10
;scroll_text_address_start       EQU    scroll_variables_start
;scroll_text_address_current     EQU    scroll_text_address_start + 2
;scroll_speed                    EQU    scroll_text_address_current + 2
;scroll_y                        EQU    scroll_speed + 1
;scroll_left_boundary            EQU    scroll_y + 1
;scroll_right_boundary           EQU    scroll_left_boundary + 1
;scroll_step_width               EQU    scroll_right_boundary + 1
;scroll_intensity                EQU    scroll_step_width + 1
;scroll_objects                  EQU    scroll_intensity + 1
;scroll_objects_end              EQU    (scroll_objects+(5*NUMBER_OF_SCROLL_LETTERS)+1)
;scroll_variables_end            EQU    scroll_objects_end
;***************************************************************************
