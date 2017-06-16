;***************************************************************************
MY_LSR_D            macro    
                    ASRA     
                    RORB     
                    endm                                  ; done 
;***************************************************************************
DIV_D_64_A          macro    
                    ASLB                                  ; this divides d by 64 
                    ROLA                                  ; result in A 
                    ASLB     
                    ROLA     
                    endm                                  ; done 
;***************************************************************************
MY_DIV_D_16_UNSIGNED  macro  
                    LSLA     
                    LSLA     
                    LSLA     
                    LSLA     
                    LSRB     
                    LSRB     
                    LSRB     
                    LSRB     
                    STA      divide_tmp 
                    ORB      divide_tmp 
                    endm     
;***************************************************************************
;***************************************************************************
; entry:   D has clip_counter
;          clip_test is set
;          v0 is set
; result: v1 = y1, x1
;         v2 = y2, x2
;         get calculated
;
; this one assumes X0 is either 64, 32 or 16
; divide is pretty fast than...
HELP_CALC_P2        macro    
                                                          ; first setup x1 and x2 according to clipping 
                                                          ; information 
                    SUBD     BORDER 
                    STB      x2                           ; part of vector that is visible (or vice versa) 
                    SUBB     x0 
                    NEGB     
                    STB      x1                           ; part of vector that is invisible (or vice versa) 
                                                          ; now we have to calculate the Y part of the two 
                                                          ; halves 
                                                          ; Y1/X1 and Y2/X2 should be like Y0/X0 
                                                          ; X0 = original length 
                                                          ; 
                                                          ; than Y1 = Y0*X1/X0 
                                                          ; than Y2 = Y0*X2/X0 
                                                          ; but we know that Y1 + Y2 = Y0 
                                                          ; -> Y2 = Y0 - Y1 
                                                          ; div cycles depend on size of tmp1 
                                                          ; the bigger tmp1 the faster div 
                                                          ; we do div and mul unsigned 
                                                          ; so check for signness here 
                                                          ; and adjust later 
                    CLRA     
                    STA      neggi 
                    LDB      x0 
                    BPL      is_pl1\? 
                    INC      neggi 
                    NEGB     
is_pl1\?: 
                    CMPB     #32 
                    BEQ      div_d_32\? 
                    CMPB     #16 
                    BEQ      div_d_16\? 
                    CMPB     #8 
                    BEQ      div_d_8\? 
                    CMPB     #4 
                    BEQ      div_d_4\? 
div_d_64\? 
                    LDA      y0 
                    BPL      is_pl2\? 
                    INC      neggi 
                    NEGA     
is_pl2\?: 
                    LDB      x1 
                    BPL      is_pl3\? 
                    INC      neggi 
                    NEGB     
is_pl3\?: 
                    MUL      
                    ASLB                                  ; this divides d by 64 
                    ROLA                                  ; result in A 
                    ASLB     
                    ROLA     
                    ASR      neggi 
                    BCC      no_neggi1\? 
                    NEGA     
no_neggi1\?: 
                    STA      y1                           ; store y1 
                    NEGA                                  ; -y1 + y0 = y0 - y1 = y2 
                    ADDA     y0 
                    STA      y2                           ; store y2 
                    BRA      end_macro\? 

div_d_16\? 
                    LDA      y0 
                    BPL      is_pl4\? 
                    INC      neggi 
                    NEGA     
is_pl4\?: 
                    LDB      x1 
                    BPL      is_pl5\? 
                    INC      neggi 
                    NEGB     
is_pl5\?: 
                    MUL      
                    BRA      enter_div32\? 

div_d_8\? 
                    LDA      y0 
                    BPL      is_pl48\? 
                    INC      neggi 
                    NEGA     
is_pl48\?: 
                    LDB      x1 
                    BPL      is_pl58\? 
                    INC      neggi 
                    NEGB     
is_pl58\?: 
                    MUL      
                    BRA      enter_div328\? 

div_d_4\? 
                    LDA      y0 
                    BPL      is_pl44\? 
                    INC      neggi 
                    NEGA     
is_pl44\?: 
                    LDB      x1 
                    BPL      is_pl54\? 
                    INC      neggi 
                    NEGB     
is_pl54\?: 
                    MUL      
                    BRA      enter_div324\? 

div_d_32\? 
                    LDA      y0 
                    BPL      is_pl6\? 
                    INC      neggi 
                    NEGA     
is_pl6\?: 
                    LDB      x1 
                    BPL      is_pl7\? 
                    INC      neggi 
                    NEGB     
is_pl7\?: 
                    MUL      
                    MY_LSR_D  
enter_div32\?: 
                    MY_LSR_D  
enter_div328\?: 
                    MY_LSR_D  
enter_div324\?: 
                    MY_LSR_D  
                    MY_LSR_D  
                    ASR      neggi 
                    BCC      no_neggi\? 
                    NEGB     
no_neggi\?: 
                    STB      y1                           ; store y1 
                    NEGB                                  ; -y1 + y0 = y0 - y1 = y2 
                    ADDB     y0 
                    STB      y2                           ; store y2 
end_macro\?: 
                    endm     
; performance depends on the length of processed list
; ~ about 180 cycles per vector of vectorlist
; input, D is a 16bit X position (BORDER) within the vectorlist
; vectorlist is supposed to start at the left most point
; left most point within vectorlist is point 0
; coordinates "grow" to positive with going further right
; 
; every coordinate greater X position is visible
; every lower is invisible
; X values of coordinates are summurized in clip_counter (starts with 0)
; so the relative coordinates are added to a 16 bit compare value against BORDER
;
; 
; clip_vlp_p2_right clips the right side of the BORDER
; clip_vlp_p2_left clips the left side of the BORDER
;
; Example: 
; ldx #2
; ldx #vlist
; JSR clip_vlp_p2_right
; assuming vlist point zero is in the CENTER of the vectorlist, than everything
; left of point 2 (positive) is displayed
;
; Example: 
; ldx #2
; ldx #vlist
; JSR clip_vlp_p2_left
; assuming vlist point zero is in the CENTER of the vectorlist, than everything
; right of point 2 (positive) is displayed
; assumes modified pattern list input
; 0 = move
; high bit set = draw
; not 0 and not hightbit set = end
; !!!!!
; vectorlists must consist of vectors coordinates 0, 16, 32, 64 
; in order to do a performant DIV
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
clip_vlp_p2_left: 
                    direct   $D0                          ; but here the code still uses c8 
                    clr      firstVector 
                    CLR      clip_pattern                 ; default pattern is 0, invisible 
                    STD      BORDER                       ; remember clipping edge 
                    _DP_TO_C8  
                    LDU      #clipped_vector_list         ; address of result list 
                    LDD      #0 
                    STD      clip_counter                 ; clip starts at 0 
                                                          ; we add to this each strength 
                                                          ; of a vector 
                    lda      0,x 
                    beq      was_not_visible_vlp 
                    bra      was_visible_vlp 

                    BRA      was_not_visible_vlp          ; when first vector will be invisible 

do_next_vector_vlp: 
                    CLR      clip_pattern                 ; default pattern is 0, invisible 
                    LDD      clip_counter                 ; compare current 'place' 
                    CMPD     BORDER                       ; with clipping edge 
                    BGT      was_visible_vlp              ; if higher... the start of this 
                                                          ; current vector is visible -> branch 
was_not_visible_vlp: 
                    ldy      clip_counter 
                                                          ; otherwise the start was not visible 
                    LEAX     1,X 
                    LDD      ,X++                         ; get current Vector strength 
                    STD      v0                           ; remember it as v0 
                    SEX                                   ; extend it X part 
                    ADDD     clip_counter                 ; and adjust clip_counter 
                    STD      clip_counter                 ; store it 
                                                          ; clip counter has vector 
                                                          ; 'position' at the end 
                                                          ; of current vector 
                    CMPD     BORDER                       ; test for clipping edge 
                    BLE      startpoint_invisible_coord   ; str_pat_and_scale_vlp 
; startpoint is visible by coordinates
                    TST      -3,X 
                    BEQ      startpoint_invisible_pattern ; str_pat_and_scale_vlp_nv 
                    BPL      end_of_computing_vlp 
                    BRA      first_invisible_second_visible ;make_two_pieces_invisible_vlp ; one invisible the other visible? -> branch 

startpoint_invisible_coord: 
str_pat_and_scale_vlp: 
                    TST      -3,X 
                    BGT      end_of_computing_vlp 
str_pat_and_scale_vlp_nt: 
next_point_invisible_pattern: 
                    CLR      ,U+                          ; pattern is 0 
                    LDD      v0                           ; load current Vector 
                    STD      ,U++                         ; store it also 
                    inc      firstVector 
                    BRA      was_not_visible_vlp 

end_of_computing_vlp: 
                    LDA      #1                           ; pattern = 1 ends VList 
                    STA      ,U                           ; store it 
                    LDX      #clipped_vector_list         ; load X with correct VLp 
                    _DP_TO_D0                             ; reset dp to d0 
                    direct   $C8                          ; but here the code still uses c8 
                    RTS                                   ; return 

startpoint_invisible_pattern: 
                    CLR      ,U+                          ; pattern is 0 
                    LDD      v0                           ; load current Vector 
                    STD      ,U++                         ; store it also 

                    inc      firstVector 
was_visible_vlp: 
                    ldy      clip_counter 
                    LEAX     1,X 
                    LDD      ,X++                         ; get current Vector 
                    STD      v0                           ; remember it as v0 
                    SEX                                   ; extend it x0 part 
                    ADDD     clip_counter                 ; and adjuct clip_counter 
                    STD      clip_counter                 ; store it 
                                                          ; clip counter has vector 
                                                          ; 'position' at the end 
                                                          ; of current vector 
                    TST      -3,X 
                    BEQ      next_point_invisible_pattern ; str_pat_and_scale_vlp_nt 
                    BPL      end_of_computing_vlp 
                    CMPD     BORDER                       ; test for clipping edge 
                    BLE      first_visible_second_invisible ; make_two_pieces_visible_vlp ; if the whole is visible -> branch 
                    LDA      #$ff                         ; use full pattern 
                    STA      ,U+                          ; store in vlist 
                    LDD      v0                           ; load current Vector 
                    STD      ,U++                         ; store it also 
                    inc      firstVector 
                    BRA      was_visible_vlp              ; no? -> branch 

make_two_pieces_visible_vlp: 
first_visible_second_invisible: 
                    tst      firstVector 
                    beq      startpoint_invisible_coord 
                    COM      clip_pattern 
                    cmpy     BORDER 
                    ble      bothEndsSame 
                    bra      do_end_calcs 

make_two_pieces_invisible_vlp: 
first_invisible_second_visible: 
;NEW
                                                          ; check if invisible was due to a move 
                                                          ; and the current vector might be displayed COMPLETELY 
                    cmpy     BORDER 
                    bgt      bothEndsSame 
; NEW END
do_end_calcs 
                    bsr      CALC_P2 
                                                          ; HELP_CALC_P2 ; leaves with v1 and v2 calculated 
                    LDA      clip_pattern                 ; get pattern 
                    STA      ,U+                          ; store it 
                    LDD      v1                           ; build vector from X1 and Y1 
                    STD      ,U++                         ; store it to list 
                    LDA      clip_pattern                 ; get pattern and 
                    COMA                                  ; reverse it 
                    STA      ,U+                          ; store it 
                    LDD      v2                           ; build vector from X2 and Y2 
                    STD      ,U++                         ; store it to list 
                    inc      firstVector 
                    jmp      do_next_vector_vlp           ; do next 

; NEW
bothEndsSame 
                    COM      clip_pattern 
                    LDA      clip_pattern                 ; get pattern and 
;                    COMA                                  ; reverse it 
                    STA      ,U+                          ; store it 
                    LDD      v0                           ; build vector from X2 and Y2 
                    STD      ,U++                         ; store it to list 
                    inc      firstVector 
                    jmp      do_next_vector_vlp           ; do next !!! (rather to was visible? 

; NEW END
CALC_P2: 
                    HELP_CALC_P2  
                    rts      

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
clip_vlp_p2_right: 
                    direct   $D0                          ; but here the code still uses c8 
                    CLR      clip_pattern                 ; default pattern is 0, invisible 
                    STD      BORDER                       ; remember clipping edge 
                    _DP_TO_C8  
                    LDU      #clipped_vector_list         ; address of result list 
                    LDD      #0 
                    STD      clip_counter                 ; clip starts at 0 
                                                          ; we add to this each strength 
                                                          ; of a vector 
                    lda      0,x 
                    beq      was_not_visible_vlpr 
                    bra      was_visible_vlpr 

                    BRA      was_not_visible_vlpr         ; when first vector will be invisible 

                    BRA      was_not_visible_vlpr         ;start of first vector will be invisible 

do_next_vector_vlpr: 
                    CLR      clip_pattern                 ; default pattern is 0, invisible 
                    LDD      clip_counter                 ; compare current 'place' 
                    CMPD     BORDER                       ; with clipping edge 
                    BLE      was_visible_vlpr             ; if lower... the start of this 
                                                          ; current vector is visible -> branch 
was_not_visible_vlpr: 
                                                          ; otherwise the start was not visible 
                    LEAX     1,X 
                    LDD      ,X++                         ; get current Vector strength 
                    STD      v0                           ; remember it as v0 
                    SEX                                   ; extend it X part 
                    ADDD     clip_counter                 ; and adjust clip_counter 
                    STD      clip_counter                 ; store it 
                                                          ; clip counter has vector 
                                                          ; 'position' at the end 
                                                          ; of current vector 
                    CMPD     BORDER                       ; test for clipping edge 
                    BGT      str_pat_and_scale_vlpr 
                    TST      -3,X 
                    BEQ      str_pat_and_scale_vlpr_nv 
                    BPL      end_of_computing_vlpr 
                    BRA      make_two_pieces_invisible_vlpr ; one invisible the other visible? -> branch 

                                                          ; both vector ends are invisible 
str_pat_and_scale_vlpr: 
                    TST      -3,X 
                    BGT      end_of_computing_vlpr 
str_pat_and_scale_vlpr_nt: 
                    CLR      ,U+                          ; pattern is 0 
                    LDD      v0                           ; load current Vector 
                    STD      ,U++                         ; store it also 
                    inc      firstVector 
                    BRA      was_not_visible_vlpr 

end_of_computing_vlpr: 
                    LDA      #1                           ; pattern = 1 ends VList 
                    STA      ,U                           ; store it 
                    LDX      #clipped_vector_list         ; load X with correct vlpr 
                    _DP_TO_D0                             ; reset dp to d0 
                    direct   $C8                          ; but here the code still uses c8 
                    RTS                                   ; return 

str_pat_and_scale_vlpr_nt_ft: 
                    CMPD     BORDER                       ; test for clipping edge 
                    BGT      str_pat_and_scale_vlpr_nt 
str_pat_and_scale_vlpr_nv: 
                    CLR      ,U+                          ; pattern is 0 
                    LDD      v0                           ; load current Vector 
                    STD      ,U++                         ; store it also 
                                                          ;BRA was_visible_vlpr 
was_visible_vlpr: 
                    LEAX     1,X 
                    LDD      ,X++                         ; get current Vector 
                    STD      v0                           ; remember it as v0 
                    SEX                                   ; extend it x0 part 
                    ADDD     clip_counter                 ; and adjuct clip_counter 
                    STD      clip_counter                 ; store it 
                                                          ; clip counter has vector 
                                                          ; 'position' at the end 
                                                          ; of current vector 
                    TST      -3,X 
                    BEQ      str_pat_and_scale_vlpr_nt_ft 
                    BPL      end_of_computing_vlpr 
                    CMPD     BORDER                       ; test for clipping edge 
                    BGT      make_two_pieces_visible_vlpr ; if the whole is visible -> branch 
                    LDA      #$ff                         ; use full pattern 
                    STA      ,U+                          ; store in vlist 
                    LDD      v0                           ; load current Vector 
                    STD      ,U++                         ; store it also 
                    inc      firstVector 
                    BRA      was_visible_vlpr             ; no? -> branch 

make_two_pieces_visible_vlpr: 
                    tst      firstVector 
                    beq      str_pat_and_scale_vlpr 
                    COM      clip_pattern 
make_two_pieces_invisible_vlpr: 
                    JSR      CALC_P2 
; HELP_CALC_P2 ; leaves with v1 and v2 calculated 
                    LDA      clip_pattern                 ; get pattern 
                    STA      ,U+                          ; store it 
                    LDD      v1                           ; build vector from X1 and Y1 
                    STD      ,U++                         ; store it to list 
                    LDA      clip_pattern                 ; get pattern and 
                    COMA                                  ; reverse it 
                    STA      ,U+                          ; store it 
                    LDD      v2                           ; build vector from X2 and Y2 
                    STD      ,U++                         ; store it to list 
                    inc      firstVector 
                    jmp      do_next_vector_vlpr          ; do next 
