	.module	SCROLL.C

 .area .text

NUMBER_OF_SCROLL_LETTERS=8
SPRITE_BLOW_UP=25
SCALE_FACTOR_GAME=0H91
SCROLL_SCALE_FACTOR=6
Intensity_a=0HF2AB
VIA_t1_cnt_lo=0HD004
VIA_cntl=0HD00C
VIA_port_a=0HD001
VIA_port_b=0HD000
VIA_shift_reg=0HD00A
VIA_t1_cnt_hi=0HD005
VIA_int_flags=0HD00D


        .area .bss
tmp1:
        .blkb   2
tmp2:
        .blkb   2
divide_tmp:
mul_tmp1:
        .blkb   2
mul_tmp2:
        .blkb   2
        .globl  _scr_strt
_scr_strt:
        .blkb   2
        .globl  _scr_crnt
_scr_crnt:
        .blkb   2
        .globl  _scr_sped
_scr_sped:
        .blkb   1
        .globl  _scr_y
_scr_y:
        .blkb   1
        .globl  _scr_lbnd
_scr_lbnd:
        .blkb   1
        .globl  _scr_rbnd
_scr_rbnd:
        .blkb   1
        .globl  _scr_stpw
_scr_stpw:
        .blkb   1
        .globl  _scr_ints
_scr_ints:
        .blkb   1
        .globl  _scr_objs
_scr_objs:
        .blkb    (5*NUMBER_OF_SCROLL_LETTERS)+1

        .area .text
; this file is part of vectrex frogger, written by Christopher Salomon
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
; (only two) scr_init(), do_one_scr_step()
; scroll text ends with $80
; this restarts scrolling...
;***************************************************************************
; expects text address in X register
; scr_y:                  the y coordinate (signed byte value)
; scr_lbnd       (signed byte value)
; scr_rbnd      (signed byte value)
; scr_sped               (signed byte value) must be negative
; scr_ints           (byte value)
;
; NUMBER_OF_SCROLL_LETTERS
;
; uses tmp1, tmp2
        .ascii "I WAS HERE!"
        .globl  scr_init
scr_init:
                stx     _scr_strt ; remember address of first letter
                stx     _scr_crnt ; and store it as current address
                ldd     #NUMBER_OF_SCROLL_LETTERS ; how many letters are at most to be displayed at once?
                std     tmp1               ; remember that value in tmp1 (16 bit)
                ldb     _scr_rbnd ; load right boundary
                subb    _scr_lbnd ; subtract left boundary
                clra                       ; SEX it, this is the 16 bit width 'in pixel'
                ;MY_DIV_D_BY_TMP1_TO_B      ; divide it by the number od letters to be displayed

                clr     divide_tmp
                tst     tmp1+1
                beq     divide_by_zero
                dec     divide_tmp
                cmpd    #0
                bpl     divide_next
divide_next1:
                inc     divide_tmp
                addd    tmp1
                bmi     divide_next1
divide_by_zero1:
                ldb     divide_tmp
                negb
                bra     divide_end
divide_next:
                inc     divide_tmp
                subd    tmp1
                bpl     divide_next
divide_by_zero:
                ldb     divide_tmp
divide_end:


                stb     _scr_stpw  ; remember that as the scroll step...
                lda     #NUMBER_OF_SCROLL_LETTERS ; set loop counter for initializing the scroll objects
                sta     tmp1               ; remember that too in tmp1 (only 8 bit this time)
                ldx     #_scr_objs    ; get address of the first 'scroll object' (RAM address)
                ldb     _scr_y           ; get the y position of the scroll text
                lda     _scr_rbnd ; and screen address where first letter will appear
                ; now we loop 'NUMBER_OF_SCROLL_LETTERS' times to set up our object space
scr_setup_loop1:
                stb     ,x+                ; y coordinate, from above
                sta     ,x+                ; x coordinate, from above
                clr     ,x+                ; no object yet
                clr     ,x+                ; no object yet, these two are an address pointer,
                                           ; zero means a SPACE is printed...
                clr     ,x+                ; no x offset yet, here we will remember
                                           ; the x offset later on, must remember this,
                                           ; otherwise letters will overlap eventually...
                suba    _scr_stpw  ; go one letter to the left (x coordinate that is)
                dec     tmp1               ; decrements our loop counter
                bne     scr_setup_loop1 ; if not finnished ... loop again
                lda     #0Hff               ; otherwise store a 'ff' as an and marker
                sta     ,x+                ; y coordinate ff loop over
                rts                        ; bye bye...
;***************************************************************************
; does one scroll step of text initialized with the above function
; does also all printing...
; expects dp set to d0
; sets intensity and trashs beam position (as well as everything else...)
; destroys tmp1
        .globl  scr_step
scr_step:
                lda     _scr_ints   ; load intensity
                jsr     Intensity_a
                ldu     #_scr_objs    ; get address of our scroll objects
                ; now loop thru all objects, till we find a $ff
                ; than we are done...
next_scr_object:
                ;MY_GAME_SCALE              ; first set our scaling (whatever we designed our
                                           ; object offsets for)
                lda #SCALE_FACTOR_GAME
                sta     VIA_t1_cnt_lo      ; move to time 1 lo, this means scaling


                ;_ZERO_VECTOR_BEAM          ; than go to zero (pitty :-()
                                           ; but I guess we have to, otherwise
                                           ; the position will garble up I think
                 ldb     #0HCC
                 stb     VIA_cntl       ;/BLANK low and /ZERO low


                ldd     ,u+                ; load y, x coordinate
                                           ; A,B=D, increment U by 1, U pointing to X
                                           ; coordinate now
                cmpa    #0Hff               ; are we done yet?
                lbeq    scr_objs_all_done ; if so, jump out of the loop
                addb    _scr_sped       ; add to B (x coordinate that is)
                                           ; the speed value
                cmpb    _scr_lbnd; is on left side out of bounds?
                bgt     scr_bound_test_done ; if not go on...
                ; otherwise ...
                ; init new letter here
                ldy     _scr_crnt ; get address of current letter
                ldb     ,y                 ; load the current letter to B
                cmpb    #0H80               ; compare to $80, end marker
                bne     scr_text_not_over_yet ; if not set, go on
                ldy     _scr_strt ; otherwise load start address of text
                sty     _scr_crnt ; store it as current
                ldb     ,y                 ; and load the first letter of the text to B
scr_text_not_over_yet:
                ; here we certainly have a correct 'letter'- value in B register
                cmpb    #32                ; really correct? isn't it a SPACE
                bne     nscr_space    ; no? than go on...
                ldx     #0                 ; otherwise zero everything, pointer to vector list
                ldd     #0                 ; and offsets
                bra     load_x_with_letter_address_done ; go on
nscr_space:
                cmpb    #46               ; is it even a 'fullstop'
                bne     nscr_fullstop ; if not... go on
                ldx     #_fs               ; if it is load vectorlist addres to X
                bra     load1_x_with_letter_address_don ; and go on
nscr_fullstop:
                cmpb    #48               ; is it even a 'turtle' :-)
                bne     nscr_0 ; if not... go on
                ldx     #_t_               ; if it is load vectorlist addres to X
                bra     load1_x_with_letter_address_don ; and go on
nscr_0:
                ; no it should be a 'real' letter (CAPITAL!!!)
                ; lets calculate the abc-table offset...
                subb    #65               ; subtract smallest letter, so A has 0 offset
                lslb                       ; multiply by two, since addresses are 16 bit
                clra                       ; SEX it :-)
                addd    #_abc              ; and add the abc (table of vector list address of the alphabet's letters)
                tfr     d,x                ; get that into an index register (X)
                ldx     ,x                 ; load the letters address from the table
load1_x_with_letter_address_don:
                ldd     -2,x               ; and load the vector list offsets to D
load_x_with_letter_address_done:
                ; now we correct everything ...
                stx     1,u                ; save vectorlist address to objectlist
                std     tmp1               ; remember the offsets

                ; now a small intermezzo...
                ; just increment the letter pointer in our
                ; text by one... so that the next letter will be correctly
                ; handled
                ldd     _scr_crnt ; load current text address to D
                addd    #1                 ; increment one
                std     _scr_crnt ; and store it back

                ; ok, now back to that offset stuff from above
                ; swap old and new offsets...
                lda     3,u                ; load x offset of old letter to A (from object list)
                ldb     tmp1+1             ; load x offset of new letter to B (from remembering from above)
                sta     tmp1+1             ; store the old offset to tmp1 + 1
                stb     3,u                ; and put the new offset into our object list
                addb    _scr_rbnd ; now add the right boundary address to B

                subb    tmp1+1             ; and subtract the old offset from that, that
                                           ; is our new start address (screen oriented)
                                           ; (might even be further right than our
                                           ; dedicated start address, but that can't be helped)
                lda     _scr_y           ; load y address
                adda    tmp1               ; modify that with new y offset ONLY
                sta     -1,u               ; and store that to our object list
scr_bound_test_done:
                stb     ,u+                ; store the new x position, and increment U

                sta     VIA_port_a     ;Store Y in D/A register
                lda     #0HCE            ;Blank low, zero high?
                sta     VIA_cntl       ;
                clra
                sta     VIA_port_b     ;Enable mux
                sta     VIA_shift_reg  ;Clear shift regigster
                inc     VIA_port_b     ;Disable mux
                stb     VIA_port_a     ;Store X in D/A register
                sta     VIA_t1_cnt_hi  ;enable timer
                ldb     #0H40            ;
LF33D:          bitb    VIA_int_flags  ;
                beq     LF33D           ;



                ldx     ,u++               ; load object vector list to X,
                beq     no_space_draw      ; don't draw if vector is not available (== 0 means SPACE)
                 lda     #SCROLL_SCALE_FACTOR               ; scale for placing first point
                 sta     VIA_t1_cnt_lo   ; move to time 1 lo, this means scaling
                ;_draw_vlc                  ; (MAKRO) and draw the vector list

                 lda     ,x+             ;
_DRAW_VLA:                               ; the local directive doesn't work here ???
                                         ; I think because it is a makro using makro...
                 sta     0HC823           ;
                 ldd     ,x              ;

                 sta     VIA_port_a     ;Send Y to A/D
                 clr     VIA_port_b     ;Enable mux
                 leax    2,x             ;Point to next coordinate pair
                 nop                     ;Wait a moment
                 inc     VIA_port_b     ;Disable mux
                 stb     VIA_port_a     ;Send X to A/D
                 ldd     #0HFF00          ;Shift reg=$FF (solid line), T1H=0
                 sta     VIA_shift_reg  ;Put pattern in shift register
                 stb     VIA_t1_cnt_hi  ;Set T1H (scale factor?)
                 ldd     #0H0040          ;B-reg = T1 interrupt bit
LF3F4:           bitb    VIA_int_flags  ;Wait for T1 to time out
                 beq     LF3F4           ;
                 nop                     ;Wait a moment more
                 sta     VIA_shift_reg  ;Clear shift register (blank output)

                 lda     0HC823           ;Decrement line count
                 deca                    ;
                 bpl     _DRAW_VLA       ;Go back for more points


no_space_draw:
                leau    1,u                ; increment object list by one, since we are not
                                           ; really interested in the x offset at that point
                                           ; anymore...
                jmp     next_scr_object ; and go on with our next listobject...
scr_objs_all_done:
                rts                        ; ok, that was our scroll step :-)
;***************************************************************************

; this file is part of vectrex frogger, written by Christopher Salomon
; in March-April 1998
; all stuff contained here is public domain
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this file contains 'sprite' definition data for all letters and a dot,    ;
; used in scroll text                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;

                .byte  0                      ; y offset
                .byte  0                      ; x offset
; sprite definition
_t_: ; _t_ == turtle
                .byte 23
                .byte  2*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                .byte -1*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                .byte  2*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                .byte  2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                .byte  0*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                .byte -1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                .byte  1*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                .byte -1*SPRITE_BLOW_UP,  4*SPRITE_BLOW_UP
                .byte  1*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte -1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                .byte -1*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte -3*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                .byte -3*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                .byte -1*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                .byte  1*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte -1*SPRITE_BLOW_UP, -4*SPRITE_BLOW_UP
                .byte  1*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                .byte -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                .byte  0*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                .byte  2*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                .byte  2*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                .byte -1*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                .byte  2*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP

                .byte  -5   ; y offset
                .byte  1    ; x offset
; sprite definition
_fs: ; _fs == full stop
                .byte 3
                .byte  0*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                .byte -2*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte  0*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                .byte  2*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte -7    ; y offset
                .byte  1    ; x offset
; sprite definition
_a:
                .byte 6
                .byte  5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte  5*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                .byte  0*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                .byte -5*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                .byte -5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte  5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte  0*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                .byte -7    ; y offset
                .byte  1    ; x offset
; sprite definition
_b:
                .byte 8
                .byte  5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte  5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte  0*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                .byte -2*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                .byte -1*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte -1*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                .byte -2*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                .byte -3*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte -1*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                .byte  5    ; y offset
                .byte  8    ; x offset
; sprite definition
_c:
                .byte 7
                .byte  1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                .byte  0*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                .byte -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                .byte -5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte -3*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte -1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                .byte  0*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                .byte  1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                .byte -7    ; y offset
                .byte  1    ; x offset
; sprite definition
_d:
                .byte 7
                .byte  5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte  5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte  0*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                .byte -1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                .byte -4*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                .byte -4*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                .byte -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                .byte  0*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                .byte -7    ; y offset
                .byte  8    ; x offset
; sprite definition
_e:
                .byte 5
                .byte  0*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                .byte  4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte  1*SPRITE_BLOW_UP,  4*SPRITE_BLOW_UP
                .byte  1*SPRITE_BLOW_UP, -4*SPRITE_BLOW_UP
                .byte  4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                .byte -7    ; y offset
                .byte  1    ; x offset
; sprite definition
_f:
                .byte 4
                .byte  4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte  1*SPRITE_BLOW_UP,  4*SPRITE_BLOW_UP
                .byte  1*SPRITE_BLOW_UP, -4*SPRITE_BLOW_UP
                .byte  4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                .byte  5    ; y offset
                .byte  8    ; x offset
; sprite definition
_g:
                .byte 9
                .byte  1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                .byte  0*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                .byte -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                .byte -4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte -4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte -1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                .byte  0*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                .byte  1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                .byte  4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte  0*SPRITE_BLOW_UP, -4*SPRITE_BLOW_UP
                .byte  6    ; y offset
                .byte  1    ; x offset
; sprite definition
_h:
                .byte 6
                .byte -5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte -5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte  5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                .byte  5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte -5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte -5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte  6    ; y offset
                .byte  1    ; x offset
; sprite definition
_i:
                .byte 5
                .byte  0*SPRITE_BLOW_UP,  4*SPRITE_BLOW_UP
                .byte  0*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                .byte -5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte -5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte  0*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                .byte  0*SPRITE_BLOW_UP,  4*SPRITE_BLOW_UP
                .byte  6    ; y offset
                .byte  1    ; x offset
; sprite definition
_j:
                .byte 6
                .byte  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                .byte -5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte -4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                .byte  0*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                .byte  1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                .byte  2*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte  6    ; y offset
                .byte  1    ; x offset
; sprite definition
_k:
                .byte 5
                .byte -5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte  5*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                .byte -5*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                .byte -5*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                .byte  5*SPRITE_BLOW_UP, -5*SPRITE_BLOW_UP
                .byte -5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte  6    ; y offset
                .byte  1    ; x offset
; sprite definition
_l:
                .byte 2
                .byte -5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte -5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte  0*SPRITE_BLOW_UP,  5*SPRITE_BLOW_UP
                .byte -7    ; y offset
                .byte  1    ; x offset
; sprite definition
_m:
                .byte 5
                .byte  5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte  5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte -5*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                .byte  5*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                .byte -5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte -5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte -7    ; y offset
                .byte  1    ; x offset
; sprite definition
_n:
                .byte 5
                .byte  5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte  5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte -5*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                .byte -5*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                .byte  5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte  5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte -7    ; y offset
                .byte  3    ; x offset
; sprite definition
_o:
                .byte 9
                .byte  1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                .byte  4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte  4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte  1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                .byte  0*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                .byte -1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                .byte -4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte -4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                .byte  0*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                .byte -7    ; y offset
                .byte  1    ; x offset
; sprite definition
_p:
                .byte 6
                .byte  5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte  5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte  0*SPRITE_BLOW_UP,  4*SPRITE_BLOW_UP
                .byte -1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                .byte -3*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                .byte  0*SPRITE_BLOW_UP, -4*SPRITE_BLOW_UP
                .byte -3    ; y offset
                .byte  4    ; x offset
; sprite definition
_q:
                .byte 10
                .byte -3*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                .byte  1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                .byte  4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte  4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte  1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                .byte  0*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                .byte -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                .byte -4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte -4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte -1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                .byte  0*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                .byte -7    ; y offset
                .byte  1    ; x offset
; sprite definition
_r:
                .byte 8
                .byte  5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte  5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte  0*SPRITE_BLOW_UP,  4*SPRITE_BLOW_UP
                .byte -1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                .byte -3*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                .byte  0*SPRITE_BLOW_UP, -4*SPRITE_BLOW_UP
                .byte  0*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                .byte -5*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                .byte  5    ; y offset
                .byte  8    ; x offset
; sprite definition
_s:
                .byte 10
                .byte  1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                .byte  0*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                .byte -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                .byte -3*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte -1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                .byte  0*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                .byte -1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                .byte -3*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte -1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                .byte  0*SPRITE_BLOW_UP, -3*SPRITE_BLOW_UP
                .byte  1*SPRITE_BLOW_UP, -1*SPRITE_BLOW_UP
                .byte  6    ; y offset
                .byte  1    ; x offset
; sprite definition
_t:
                .byte 3
                .byte  0*SPRITE_BLOW_UP,  4*SPRITE_BLOW_UP
                .byte  0*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                .byte -5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte -5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte  6    ; y offset
                .byte  1    ; x offset
; sprite definition
_u:
                .byte 6
                .byte -5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte -4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte -1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                .byte  0*SPRITE_BLOW_UP,  3*SPRITE_BLOW_UP
                .byte  1*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                .byte  4*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte  5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte  6    ; y offset
                .byte  1    ; x offset
; sprite definition
_v:
                .byte 3
                .byte -5*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                .byte -5*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                .byte  5*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                .byte  5*SPRITE_BLOW_UP,  1*SPRITE_BLOW_UP
                .byte  6    ; y offset
                .byte  1    ; x offset
; sprite definition
_w:
                .byte 5
                .byte -5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte -5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte  4*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                .byte -4*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                .byte  5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte  5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte  6    ; y offset
                .byte  1    ; x offset
; sprite definition
_x:
                .byte 5
                .byte -5*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                .byte -5*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                .byte  5*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                .byte  5*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                .byte -5*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                .byte -5*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                .byte  6    ; y offset
                .byte  1    ; x offset
; sprite definition
_y:
                .byte 3
                .byte -5*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                .byte  5*SPRITE_BLOW_UP,  2*SPRITE_BLOW_UP
                .byte -5*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                .byte -5*SPRITE_BLOW_UP,  0*SPRITE_BLOW_UP
                .byte  6    ; y offset
                .byte  1    ; x offset
; sprite definition
_z:
                .byte 3
                .byte  0*SPRITE_BLOW_UP,  4*SPRITE_BLOW_UP
                .byte -5*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                .byte -5*SPRITE_BLOW_UP, -2*SPRITE_BLOW_UP
                .byte  0*SPRITE_BLOW_UP,  4*SPRITE_BLOW_UP
_abc:
                .word _a, _b, _c, _d, _e, _f, _g, _h, _i, _j
                .word _k, _l, _m, _n, _o, _p, _q, _r, _s, _t
                .word _u, _v, _w, _x, _y, _z
