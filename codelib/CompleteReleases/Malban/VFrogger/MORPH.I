; this file is part of vectrex frogger, written by Malban
; in March-April 1998
; all stuff contained here is public domain
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; morphing subroutines                                                      ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
;***************************************************************************
; below are all subroutines for morphing
; (only two) set_up_morphing(), do_one_morph_step()
;***************************************************************************
; this sets up a morph
; in U a pointer to a morph structure is expected,
;structure:
;               DW               ; morph from vector list
;               DW               ; morph to vector list
;               DB               ; morph steps
;               DB               ; delay between one morph step
;               DW               ; optional (0 or structure)
;                                ; pointer to next morph structure
;               DB               ; startup delay
;
; vector list must have (as usual with my routines) the following style
;       count, rel y, rel x, rel y, rel x, ...
;
; maximal vectors for morphing is now 63 (127/2)
; if more are needed than something below cries for a 16 bit change...
; vector list don't need to have the same length anymore
; for optimal performance use a power of two step counter (-1)
; (8, 16, 32, 64 are supported with fast DIV routines)
;
; this routine sets up three vector lists (sort of) in RAM
; current_morph_vectorlist_org
; current_morph_vectorlist
; current_morph_vector_diffs
;
; current_morph_vectorlist_org
; is the original startlist, but possibly lengthened to the
; max vectorlist length of the two passed vectors (filled with 0,0 coordinates)
;
; current_morph_vectorlist
; is the storage area for the next to be drawn vectorlist
; is set to the original vector list (not max length)
;
; current_morph_vector_diffs
; not a real vector list, this contains the difference between the
; points of the two passed vector lists
; used in 'do_one_morph_step' to calculate the next vector
;
; further some variables are set, like delay, div routine, and morph_structure...
;
;
set_up_morphing:
                 JSR    DP_to_C8
                 direct $c8
                 STU    morph_structure     ; remember current morph structure
                 ; first clear all current stuff, since we
                 ; don't know how long all vectors will be
                 ; could be optimized to a later fill
                 ; with only the fills we need,
                 ; but at this point vectrex should be fast enough
                 ; so it doesn't matter to waste a bit time here...
                 ;
                 ; since current_morph_vectorlist_org, current_morph_vectorlist and current_morph_vector_diffs
                 ; are neighbours one Clear_x_d should be enough...
                 LDX    #current_morph_vectorlist_org ; address to clear
                 LDD    #((3*(2*MAX_VECTOR_MORPH+1))-1); number of bytes - 1 to clear
                 JSR    Clear_x_d           ; clear sub routine in ROM
                 LDX    ,U                  ; X = pointer to 'from'
                 LDY    2,U                 ; Y = pointer to 'to'
                 LDA    ,X                  ; load number of vectors
                 CMPA   ,Y                  ; compare number of vectors
                 BHS    A_is_high_vector_counter ; which vector list is longer ?
                 LDA    ,Y                  ; load number of vectors 'to', the second...
A_is_high_vector_counter:
                 ; in A is the higher vector count
                 STA    current_morph_vectorlist_org ; set high value in vector lists
                 INCA                       ; add 1
                 ASLA                       ; multiply by two, since every vector has two coordinates
                 STA    tmp2                ; remember in tmp2
                 ; copy 'from' to original
                 LDX    #(current_morph_vectorlist_org+1) ; destination pointer
                 LDU    ,U                  ; source pointer
                 LDA    ,U+                 ; load length and step over length byte
                 INCA                       ; increase 1, since one is missing
                 ASLA                       ; times two, since there are two coordinates
                 JSR    Move_Mem_a          ; and copy it

                 LDU    morph_structure     ; load current morph structure
                 ; copy 'from' to current
                 LDX    #(current_morph_vectorlist) ; destination pointer
                 LDU    ,U                  ; source pointer
                 LDA    ,U                  ; load length
                 INCA                       ; increase 1, since one is missing
                 ASLA                       ; times two, since there are two coordinates
                 INCA                       ; add 1 since counter is also copied
                 JSR    Move_Mem_a          ; and copy it
                 LDU    morph_structure     ; load current morph structure
                 ; copy 'to' to 'buffer' (buffer is now 'current_morph_vector_diffs')
                                            ; destination pointer
                 LDX    #current_morph_vector_diffs ; no +1 here, since in diffs only the offsets are relevant anyway
                 LDU    2,U                 ; source pointer
                 LDA    ,U+                 ; load length and step over length byte
                 INCA                       ; increase 1, since one is missing
                 ASLA                       ; times two, since there are two coordinates
                 JSR    Move_Mem_a          ; and copy it
                 LDU    morph_structure     ; load current morph structure
                 LDA    4,U                 ; load morph steps to A
                 INCA                       ; plus one
                 STA    morph_counter       ; and save it this is variable
                 STA    morph_steps         ; and again not variable
                 LDA    8,U                 ; load morph delay A
                 STA    morph_delay         ; and save it
                 LDA    #MORPHING_WORKING   ; and mark the whole thing as active
                 STA    morph_status        ; and store it
; now we must calculate the current_morph_vector_diffs
; we must determine the difference between the two sets of coordinates
                                            ; use tmp2 as loop counter
                                            ; number of vectors to process * 2
                 LDX    #(current_morph_vectorlist_org+1)
                 LDY    #current_morph_vector_diffs ; Y = pointer to 'to' (buffer)
                                            ; and Y = pointer to vector diffs
set_up_morphing_loop2:
                 LDB    ,Y                  ; load the second's vector coordinate
                 NEGB                       ; neg it, since we actually want a 'a=a-b' style
                                            ; what we do is
                                            ; invert b and do a b=-b+a
                 ADDB   ,X+                 ; and add the source coordinate
                 STB    ,Y+                 ; store is (back) to vector diffs
                 DEC    tmp2                ; decrease vector counter by 1
                 BNE    set_up_morphing_loop2 ; and continue with next vector if not done
                 JSR    DP_to_D0
                 direct $d0
                 RTS                         ; all done now, return
;***************************************************************************
; uses tmp1 and tmp2
; destroys everything
;
; what it does:
; current_morph_vectorlist is set to a (possibly) newly calculated vector
;
; but hardcoded
; 16 steps,
; not using JSR for DIV
; saves 1000 cycles on intro screen!!!
do_one_morph_step_16:
                 direct $d0
                 LDA    morph_status        ; load the status
                 CMPA   #MORPHING_WORKING   ; and look what there is to do
                 BEQ    morphing_now_16     ; morphing now?
                 CMPA   #MORPHING_COMPLETE  ; or complete?
                 BEQ    no_new_morph_structure; should a new morph be initialized?
                 ; here we come with MORPHING_DONE
                 LDX    morph_structure     ; load the current morph structure
                 LDU    6,X                 ; look if there is a next structure
                 BEQ    no_new_morph_structure ; no? than go out
                 JSR    set_up_morphing     ; yes? than initialize it
                 RTS                        ; go back
no_new_morph_structure:
                 LDA    #MORPHING_COMPLETE  ; load completeness flag to A
                 STA    morph_status        ; and store it
                 RTS                        ; go back
morphing_now_16:
                 DEC    morph_delay         ; decrease delay value
                 BEQ    delay_done_16       ; only morph when zero
                 RTS                        ; otherise go back
delay_done_16:
                 LDU    morph_structure     ; in the current morph structure
                 LDA    5,U                 ; look for the next delay value
                 STA    morph_delay         ; and set it
                 LDA    morph_counter       ; load counter of morph steps
                 BEQ    no_morphing_is_last ; are we done ?
                 SUBA   morph_steps         ; no, than calculate offset to number of steps
                 BEQ    no_morphing_is_first; is it the beginning?
                 ; no, than we go on
                 LDX    #current_morph_vectorlist_org; pointer to original vectorlist
                                            ; (RAM), but the (maybe) longer version
                 LDA    ,X+                 ; load length of vectorlist and increment X
                 STA    current_morph_vectorlist ; only needed the first time we are in here...
                                            ; A current number of vectors in (RAM) vectorlist
                 INCA                       ; since it misses allways one, add one
                 ASLA                       ; multiply by two, since every vector has
                                            ; start and end point
                 STA    tmp2                ; use tmp2 as loop counter see below
                 LDU    #current_morph_vector_diffs ; U = pointer to vector diffs (RAM)
                 LDY    #(current_morph_vectorlist+1) ; target memory pointer (RAM)
                                            ; plus one, since we don't need the vector counter
                 LDB    morph_steps         ; load number of steps to B
                 SUBB   morph_counter       ; invert the morph counter
                 STB    morph_tmp           ; store..., so we don't have to calculate in the loop
                 CLR    morph_sign          ; clear signess... (that's positiv)
do_morph_loop2_16:  ; loop through all vector coordinates of list
                 LDA    ,U+                 ; load the difference between the 'to' coordinates to A
                 BPL    no_minus_morph_16   ; check if negative sign
                 INC    morph_sign          ; mark as negative
                 NEGA                       ; and make positiv
no_minus_morph_16:
                 LDB    morph_tmp           ; initiated above..., this is the
                                            ; 'morph step' of number of morph_steps we are makeing
                 MUL                        ; multiply, B should be smaller
                                            ; than A (B is cycle relevant)
                 MY_DIV_D_16_UNSIGNED
                 TST    morph_sign          ; is it signed?
                 BEQ    no_minus_morph2_16  ; no, than go on
                 NEGB                       ; otherwise restore the 'minus'
                 DEC    morph_sign          ; and reset sign memory
no_minus_morph2_16:
                 NEGB                       ; negate the div value
                                            ;
                                            ; this is again a formal a=a-b
                                            ; what we do is
                                            ; invert b and do a b=-b+a
                 ADDB   ,X+                 ; add the resulting difference to original coordinate
                 STB    ,Y+                 ; and store it to the current vectorlist
                 DEC    tmp2                ; decrement the vectorlist loop counter by one
                 BNE    do_morph_loop2_16   ; and if not done,.. repeat
                 ; on first entry vectorlist is allready set
no_morphing_is_first:
                 DEC    morph_counter       ; decrement morph step counter
                 RTS                        ; and go back
no_morphing_is_last:
                 LDU    morph_structure     ; load current morph structure
                 ; copy 'to' to current_morph_vectorlist
                 LDX    #(current_morph_vectorlist) ; destination pointer
                 LDU    2,U                 ; source pointer
                 LDA    ,U                  ; load length
                 INCA                       ; increase 1, since one is missing
                 ASLA                       ; times two, since there are two coordinates
                 INCA                       ; increase 1, since now we also copy the counter
                 JSR    Move_Mem_a          ; and copy it
                 LDA    #MORPHING_DONE      ; no we are done with morphing...
                 STA    morph_status        ; and store it
                 RTS                        ; go back...
;***************************************************************************
; end of morph routine section
;***************************************************************************
