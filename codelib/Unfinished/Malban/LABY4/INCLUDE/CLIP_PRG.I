;***************************************************************************
; D = clipping place (in scale of added strengths of vector X positions)
; X = Vector list
; returns new vector list pointer in X
; result list has following format
;
; DB pattern, y, x
; DB pattern, y, x
; DB ... (till counter is 1)
;
; result in DrawVLp type Vector list
; clip vectors EXACTLY!
;
; note:
;       Due to DIVs and MULs, this function does take some time
;       maybe a few thousand cycles for LARGE VLISTs.
;       Therefor do zeroing + positioning AFTER calling this functions
;       otherwise vectrex beam drifts away a bit!
;
;       Noticeable on a real vectrex or in DVE when Drift is
;       set to something different than 0 (in *.ini)
;
; note:
;       Expects now VLists, that have X vector strength of 16, 32, or 64
;       Gabage will produced else...
;
; note:
;       using Y as shown in ';' saves a couple of cycles.
clip_vlp_p2_left:
                direct  $D0                     ; but here the code still uses c8
                STD     clip_test               ; remember clipping edge
                _DP_TO_C8
                LDU     #clipped_vector_list    ; address of result list
                LDD     #0
                STD     clip_counter            ; clip starts at 0
                                                ; we add to this each strength
                                                ; of a vector
                BRA    was_not_visible_vlp; when first vector will be invisible
do_next_vector_vlp:
                CLR     clip_pattern            ; default pattern is 0, invisible
                LDD     clip_counter            ; compare current 'place'
                CMPD    clip_test               ; with clipping edge
                BGT     was_visible_vlp         ; if higher... the start of this
                                                ; current vector is visible -> branch
was_not_visible_vlp:
                                                ; otherwise the start was not visible
                LEAX    1,X
                LDD     ,X++                    ; get current Vector strength
                STD     v0                      ; remember it as v0
                SEX                             ; extend it X part
                ADDD    clip_counter            ; and adjust clip_counter
                STD     clip_counter            ; store it
                                                ; clip counter has vector
                                                ; 'position' at the end
                                                ; of current vector
                CMPD    clip_test               ; test for clipping edge
                BLE     str_pat_and_scale_vlp
                TST     -3,X
                BEQ     str_pat_and_scale_vlp_nv
                BPL     end_of_computing_vlp
                BRA     make_two_pieces_invisible_vlp ; one invisible the other visible? -> branch

                ; both vector ends are invisible
str_pat_and_scale_vlp:
                TST     -3,X
                BGT     end_of_computing_vlp
str_pat_and_scale_vlp_nt:
                CLR     ,U+                     ; pattern is 0
                LDD     v0                      ; load current Vector
                STD     ,U++                    ; store it also
                BRA     was_not_visible_vlp
end_of_computing_vlp:
                LDA     #1                      ; pattern = 1 ends VList
                STA     ,U                      ; store it
                LDX     #clipped_vector_list    ; load X with correct VLp
                _DP_TO_D0                       ; reset dp to d0
                direct  $C8                     ; but here the code still uses c8
                RTS                             ; return
str_pat_and_scale_vlp_nv:
                CLR     ,U+                     ; pattern is 0
                LDD     v0                      ; load current Vector
                STD     ,U++                    ; store it also
                ;BRA     was_visible_vlp
was_visible_vlp:
                LEAX    1,X
                LDD     ,X++            ; get current Vector
                STD     v0              ; remember it as v0
                SEX                     ; extend it x0 part
                ADDD    clip_counter    ; and adjuct clip_counter
                STD     clip_counter    ; store it
                                        ; clip counter has vector
                                        ; 'position' at the end
                                        ; of current vector
                TST     -3,X
                BEQ     str_pat_and_scale_vlp_nt
                BPL     end_of_computing_vlp
                CMPD    clip_test       ; test for clipping edge
                BLE     make_two_pieces_visible_vlp ; if the whole is visible -> branch

                LDA     #$ff                    ; use full pattern
                STA     ,U+                     ; store in vlist
                LDD     v0                      ; load current Vector
                STD     ,U++                    ; store it also

                BRA     was_visible_vlp         ; no? -> branch
make_two_pieces_visible_vlp:
                COM     clip_pattern
make_two_pieces_invisible_vlp:
                HELP_CALC_P2            ; leaves with v1 and v2 calculated

                LDA     clip_pattern    ; get pattern
                STA     ,U+             ; store it
                LDD     v1              ; build vector from X1 and Y1
                STD     ,U++            ; store it to list

                LDA     clip_pattern    ; get pattern and
                COMA                    ; reverse it
                STA     ,U+             ; store it
                LDD     v2              ; build vector from X2 and Y2
                STD     ,U++            ; store it to list

                BRA     do_next_vector_vlp ; do next
;***************************************************************************
; D = clipping place (in scale of added strengths of vector X positions)
; X = Vector list
; returns new vector list pointer in X
; result list has following format
;
; DB pattern, y, x
; DB pattern, y, x
; DB ... (till counter is 1)
;
; result in DrawVLp type Vector list
; clip vectors EXACTLY!
;
; note:
;       Due to DIVs and MULs, this function does take some time
;       maybe a few thousand cycles for LARGE VLISTs.
;       Therefor do zeroing + positioning AFTER calling this functions
;       otherwise vectrex beam drifts away a bit!
;
;       Noticeable on a real vectrex or in DVE when Drift is
;       set to something different than 0 (in *.ini)
;
; note:
;       Expects now VLists, that have X vector strength of 16, 32, or 64
;       Gabage will produced else...
;
clip_vlp_p2_left_digit:
                direct  $D0                     ; but here the code still uses c8
                STD     clip_test               ; remember clipping edge
                _DP_TO_C8

                LDA     #DIGIT_VLP_RELOAD
                STA     clip_line_counter

                LDU     #clipped_vector_list    ; address of result list
                LDD     #0
                STD     clip_counter            ; clip starts at 0
                                                ; we add to this each strength
                                                ; of a vector
                BRA    was_not_visible_vlpd; when first vector will be invisible
do_next_vector_vlpd:
                CLR     clip_pattern            ; default pattern is 0, invisible
                LDD     clip_counter            ; compare current 'place'
                CMPD    clip_test               ; with clipping edge
                BGT     was_visible_vlpd        ; if higher... the start of this
                                                ; current vector is visible -> branch
was_not_visible_vlpd:
                TST     clip_line_counter
                BPL     no_digit_1
                LDA     #DIGIT_VLP_RELOAD
                STA     clip_line_counter
                FORCE_DIGIT_PLAY
no_digit_1:
                                                ; otherwise the start was not visible
                LEAX    1,X
                LDD     ,X++                    ; get current Vector strength
                STD     v0                      ; remember it as v0
                SEX                             ; extend it X part
                ADDD    clip_counter            ; and adjust clip_counter
                STD     clip_counter            ; store it
                                                ; clip counter has vector
                                                ; 'position' at the end
                                                ; of current vector
                CMPD    clip_test               ; test for clipping edge
                BLE     str_pat_and_scale_vlpd
                TST     -3,X
                BEQ     str_pat_and_scale_vlpd_nv
                BPL     end_of_computing_vlpd
                BRA     make_two_pieces_invisible_vlpd ; one invisible the other visible? -> branch

                ; both vector ends are invisible
str_pat_and_scale_vlpd:
                TST     -3,X
                BGT     end_of_computing_vlpd
str_pat_and_scale_vlpd_nt:
                CLR     ,U+                     ; pattern is 0
                LDD     v0                      ; load current Vector
                STD     ,U++                    ; store it also
                DEC     clip_line_counter
                BRA     was_not_visible_vlpd
end_of_computing_vlpd:
                LDA     #1                      ; pattern = 1 ends VList
                STA     ,U                      ; store it
                LDX     #clipped_vector_list    ; load X with correct VLp
                _DP_TO_D0                       ; reset dp to d0
                direct  $C8                     ; but here the code still uses c8
                RTS                             ; return
str_pat_and_scale_vlpd_nv:
                CLR     ,U+                     ; pattern is 0
                LDD     v0                      ; load current Vector
                STD     ,U++                    ; store it also
                ;BRA     was_visible_vlpd
was_visible_vlpd:
                TST     clip_line_counter
                BPL     no_digit_2
                LDA     #DIGIT_VLP_RELOAD
                STA     clip_line_counter
                FORCE_DIGIT_PLAY
no_digit_2:
                LEAX    1,X
                LDD     ,X++            ; get current Vector
                STD     v0              ; remember it as v0
                SEX                     ; extend it x0 part
                ADDD    clip_counter    ; and adjuct clip_counter
                STD     clip_counter    ; store it
                                        ; clip counter has vector
                                        ; 'position' at the end
                                        ; of current vector
                TST     -3,X
                BEQ     str_pat_and_scale_vlpd_nt
                BPL     end_of_computing_vlpd
                CMPD    clip_test       ; test for clipping edge
                BLE     make_two_pieces_visible_vlpd ; if the whole is visible -> branch

                LDA     #$ff                    ; use full pattern
                STA     ,U+                     ; store in vlist
                LDD     v0                      ; load current Vector
                STD     ,U++                    ; store it also

                DEC     clip_line_counter
                BRA     was_visible_vlpd         ; no? -> branch
make_two_pieces_visible_vlpd:
                COM     clip_pattern
make_two_pieces_invisible_vlpd:
                HELP_CALC_P2            ; leaves with v1 and v2 calculated

                LDA     clip_pattern    ; get pattern
                STA     ,U+             ; store it
                LDD     v1              ; build vector from X1 and Y1
                STD     ,U++            ; store it to list

                LDA     clip_pattern    ; get pattern and
                COMA                    ; reverse it
                STA     ,U+             ; store it
                LDD     v2              ; build vector from X2 and Y2
                STD     ,U++            ; store it to list

                DEC     clip_line_counter
                DEC     clip_line_counter
                DEC     clip_line_counter
                BRA     do_next_vector_vlpd ; do next
;***************************************************************************
; D = clipping place (in scale of added strengths of vector X positions)
; X = Vector list
; returns new vector list pointer in X
; result list has following format
;
; DB pattern, y, x
; DB pattern, y, x
; DB ... (till counter is 1)
;
; result in DrawVLp type Vector list
; clip vectors EXACTLY!
;
; note:
;       Due to DIVs and MULs, this function does take some time
;       maybe a few thousand cycles for LARGE VLISTs.
;       Therefor do zeroing + positioning AFTER calling this functions
;       otherwise vectrex beam drifts away a bit!
;
;       Noticeable on a real vectrex or in DVE when Drift is
;       set to something different than 0 (in *.ini)
;
; note:
;       Expects now VLists, that have X vector strength of 16, 32, or 64
;       Gabage will produced else...
;
; note:
;       using Y as shown in ';' saves a couple of cycles.
clip_vlp_p2_right:
                direct  $D0                     ; but here the code still uses c8
                STD     clip_test               ; remember clipping edge
                _DP_TO_C8
                LDU     #clipped_vector_list    ; address of result list
                LDD     #0
                STD     clip_counter            ; clip starts at 0
                                                ; we add to this each strength
                                                ; of a vector
                BRA    was_not_visible_vlpr; when first vector will be invisible
do_next_vector_vlpr:
                CLR     clip_pattern            ; default pattern is 0, invisible
                LDD     clip_counter            ; compare current 'place'
                CMPD    clip_test               ; with clipping edge
                BLE     was_visible_vlpr        ; if lower... the start of this
                                                ; current vector is visible -> branch
was_not_visible_vlpr:
                                                ; otherwise the start was not visible
                LEAX    1,X
                LDD     ,X++                    ; get current Vector strength
                STD     v0                      ; remember it as v0
                SEX                             ; extend it X part
                ADDD    clip_counter            ; and adjust clip_counter
                STD     clip_counter            ; store it
                                                ; clip counter has vector
                                                ; 'position' at the end
                                                ; of current vector
                CMPD    clip_test               ; test for clipping edge
                BGT     str_pat_and_scale_vlpr
                TST     -3,X
                BEQ     str_pat_and_scale_vlpr_nv
                BPL     end_of_computing_vlpr
                BRA     make_two_pieces_invisible_vlpr ; one invisible the other visible? -> branch

                ; both vector ends are invisible
str_pat_and_scale_vlpr:
                TST     -3,X
                BGT     end_of_computing_vlpr
str_pat_and_scale_vlpr_nt:
                CLR     ,U+                     ; pattern is 0
                LDD     v0                      ; load current Vector
                STD     ,U++                    ; store it also
                BRA     was_not_visible_vlpr
end_of_computing_vlpr:
                LDA     #1                      ; pattern = 1 ends VList
                STA     ,U                      ; store it
                LDX     #clipped_vector_list    ; load X with correct vlpr
                _DP_TO_D0                       ; reset dp to d0
                direct  $C8                     ; but here the code still uses c8
                RTS                             ; return
str_pat_and_scale_vlpr_nt_ft:
                CMPD    clip_test               ; test for clipping edge
                BGT     str_pat_and_scale_vlpr_nt
str_pat_and_scale_vlpr_nv:
                CLR     ,U+                     ; pattern is 0
                LDD     v0                      ; load current Vector
                STD     ,U++                    ; store it also
                ;BRA     was_visible_vlpr
was_visible_vlpr:
                LEAX    1,X
                LDD     ,X++            ; get current Vector
                STD     v0              ; remember it as v0
                SEX                     ; extend it x0 part
                ADDD    clip_counter    ; and adjuct clip_counter
                STD     clip_counter    ; store it
                                        ; clip counter has vector
                                        ; 'position' at the end
                                        ; of current vector
                TST     -3,X
                BEQ     str_pat_and_scale_vlpr_nt_ft
                BPL     end_of_computing_vlpr
                CMPD    clip_test       ; test for clipping edge
                BGT     make_two_pieces_visible_vlpr ; if the whole is visible -> branch

                LDA     #$ff                    ; use full pattern
                STA     ,U+                     ; store in vlist
                LDD     v0                      ; load current Vector
                STD     ,U++                    ; store it also

                BRA     was_visible_vlpr         ; no? -> branch
make_two_pieces_visible_vlpr:
                COM     clip_pattern
make_two_pieces_invisible_vlpr:
                HELP_CALC_P2            ; leaves with v1 and v2 calculated

                LDA     clip_pattern    ; get pattern
                STA     ,U+             ; store it
                LDD     v1              ; build vector from X1 and Y1
                STD     ,U++            ; store it to list

                LDA     clip_pattern    ; get pattern and
                COMA                    ; reverse it
                STA     ,U+             ; store it
                LDD     v2              ; build vector from X2 and Y2
                STD     ,U++            ; store it to list

                BRA     do_next_vector_vlpr ; do next
;***************************************************************************
; D = clipping place (in scale of added strengths of vector X positions)
; X = Vector list
; returns new vector list pointer in X
; result list has following format
;
; DB pattern, y, x
; DB pattern, y, x
; DB ... (till counter is 1)
;
; result in Drawvlpr type Vector list
; clip vectors EXACTLY!
;
; note:
;       Due to DIVs and MULs, this function does take some time
;       maybe a few thousand cycles for LARGE VLISTs.
;       Therefor do zeroing + positioning AFTER calling this functions
;       otherwise vectrex beam drifts away a bit!
;
;       Noticeable on a real vectrex or in DVE when Drift is
;       set to something different than 0 (in *.ini)
;
; note:
;       Expects now VLists, that have X vector strength of 16, 32, or 64
;       Gabage will produced else...
;
clip_vlp_p2_right_digit:
                direct  $D0                     ; but here the code still uses c8
                STD     clip_test               ; remember clipping edge
                _DP_TO_C8

                LDA     #DIGIT_VLP_RELOAD
                STA     clip_line_counter

                LDU     #clipped_vector_list    ; address of result list
                LDD     #0
                STD     clip_counter            ; clip starts at 0
                                                ; we add to this each strength
                                                ; of a vector
                BRA    was_not_visible_vlprd; when first vector will be invisible
do_next_vector_vlprd:
                CLR     clip_pattern            ; default pattern is 0, invisible
                LDD     clip_counter            ; compare current 'place'
                CMPD    clip_test               ; with clipping edge
                BLE     was_visible_vlprd        ; if higher... the start of this
                                                ; current vector is visible -> branch
was_not_visible_vlprd:
                TST     clip_line_counter
                BPL     no_digit_1r
                LDA     #DIGIT_VLP_RELOAD
                STA     clip_line_counter
                FORCE_DIGIT_PLAY
no_digit_1r:
                                                ; otherwise the start was not visible
                LEAX    1,X
                LDD     ,X++                    ; get current Vector strength
                STD     v0                      ; remember it as v0
                SEX                             ; extend it X part
                ADDD    clip_counter            ; and adjust clip_counter
                STD     clip_counter            ; store it
                                                ; clip counter has vector
                                                ; 'position' at the end
                                                ; of current vector
                CMPD    clip_test               ; test for clipping edge
                BGT     str_pat_and_scale_vlprd
                TST     -3,X
                BEQ     str_pat_and_scale_vlprd_nv
                BPL     end_of_computing_vlprd
                BRA     make_two_pieces_invisible_vlprd ; one invisible the other visible? -> branch

                ; both vector ends are invisible
str_pat_and_scale_vlprd:
                TST     -3,X
                BGT     end_of_computing_vlprd
str_pat_and_scale_vlprd_nt:
                CLR     ,U+                     ; pattern is 0
                LDD     v0                      ; load current Vector
                STD     ,U++                    ; store it also
                DEC     clip_line_counter
                BRA     was_not_visible_vlprd
end_of_computing_vlprd:
                LDA     #1                      ; pattern = 1 ends VList
                STA     ,U                      ; store it
                LDX     #clipped_vector_list    ; load X with correct vlpr
                _DP_TO_D0                       ; reset dp to d0
                direct  $C8                     ; but here the code still uses c8
                RTS                             ; return
str_pat_and_scale_vlprd_nt_ft:
                CMPD    clip_test               ; test for clipping edge
                BGT     str_pat_and_scale_vlprd_nt
str_pat_and_scale_vlprd_nv:
                CLR     ,U+                     ; pattern is 0
                LDD     v0                      ; load current Vector
                STD     ,U++                    ; store it also
                ;BRA     was_visible_vlprd
was_visible_vlprd:
                TST     clip_line_counter
                BPL     no_digit_2r
                LDA     #DIGIT_VLP_RELOAD
                STA     clip_line_counter
                FORCE_DIGIT_PLAY
no_digit_2r:
                LEAX    1,X
                LDD     ,X++            ; get current Vector
                STD     v0              ; remember it as v0
                SEX                     ; extend it x0 part
                ADDD    clip_counter    ; and adjuct clip_counter
                STD     clip_counter    ; store it
                                        ; clip counter has vector
                                        ; 'position' at the end
                                        ; of current vector
                TST     -3,X
                BEQ     str_pat_and_scale_vlprd_nt_ft
                BPL     end_of_computing_vlprd
                CMPD    clip_test       ; test for clipping edge
                BGT     make_two_pieces_visible_vlprd ; if the whole is visible -> branch

                LDA     #$ff                    ; use full pattern
                STA     ,U+                     ; store in vlist
                LDD     v0                      ; load current Vector
                STD     ,U++                    ; store it also

                DEC     clip_line_counter
                BRA     was_visible_vlprd         ; no? -> branch
make_two_pieces_visible_vlprd:
                COM     clip_pattern
make_two_pieces_invisible_vlprd:
                HELP_CALC_P2            ; leaves with v1 and v2 calculated

                LDA     clip_pattern    ; get pattern
                STA     ,U+             ; store it
                LDD     v1              ; build vector from X1 and Y1
                STD     ,U++            ; store it to list

                LDA     clip_pattern    ; get pattern and
                COMA                    ; reverse it
                STA     ,U+             ; store it
                LDD     v2              ; build vector from X2 and Y2
                STD     ,U++            ; store it to list

                DEC     clip_line_counter
                DEC     clip_line_counter
                DEC     clip_line_counter
                BRA     do_next_vector_vlprd ; do next
;***************************************************************************

