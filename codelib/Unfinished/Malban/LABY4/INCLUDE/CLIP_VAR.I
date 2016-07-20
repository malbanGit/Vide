 INCLUDE "INCLUDE\\VECTREX.I" ; vectrex function includes


; Macro
 INCLUDE "include\\macros\\div_mac.i"
 INCLUDE "include\\macros\\util_mac.i"



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
HELP_CALC_P2 macro
                ; first setup x1 and x2 according to clipping
                ; information
                SUBD    clip_test
                STB     x2        ; part of vector that is visible (or vice versa)
                SUBB    x0
                NEGB
                STB     x1        ; part of vector that is invisible (or vice versa)
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
                STA     neggi
                LDB     x0
                BPL     is_pl1\?
                INC     neggi
                NEGB
is_pl1\?:
                CMPB    #32
                BEQ     div_d_32\?
                CMPB    #16
                BEQ     div_d_16\?
div_d_64\?
                LDA     y0
                BPL     is_pl2\?
                INC     neggi
                NEGA
is_pl2\?:
                LDB     x1
                BPL     is_pl3\?
                INC     neggi
                NEGB
is_pl3\?:
                MUL
                ASLB                              ; this divides d by 64
                ROLA                              ; result in A
                ASLB
                ROLA
                ASR     neggi
                BCC     no_neggi1\?
                NEGA
no_neggi1\?:
                STB     y1      ; store y1
                NEGA            ; -y1 + y0 = y0 - y1 = y2
                ADDA    y0
                STA     y2      ; store y2
                BRA     end_macro\?
div_d_16\?
                LDA     y0
                BPL     is_pl4\?
                INC     neggi
                NEGA
is_pl4\?:
                LDB     x1
                BPL     is_pl5\?
                INC     neggi
                NEGB
is_pl5\?:
                MUL
                BRA     enter_div32\?
div_d_32\?
                LDA     y0
                BPL     is_pl6\?
                INC     neggi
                NEGA
is_pl6\?:
                LDB     x1
                BPL     is_pl7\?
                INC     neggi
                NEGB
is_pl7\?:
                MUL
                MY_LSR_D
enter_div32\?:
                MY_LSR_D
                MY_LSR_D
                MY_LSR_D
                MY_LSR_D

                ASR     neggi
                BCC     no_neggi\?
                NEGB
no_neggi\?:
                STB     y1      ; store y1
                NEGB            ; -y1 + y0 = y0 - y1 = y2
                ADDB    y0
                STB     y2      ; store y2
end_macro\?:
                endm


; Variable

v0:
y0:          DB 0
x0:          DB 0
v1:
y1:          DB 0
x1:          DB 0
v2:
y2:          DB 0
x2:          DB 0

neggi: DB 0
clip_test:       DW 0
clip_line_counter: DB 0
clip_counter:    DW 0
clip_pattern:    DW 0
clipped_vector_list:    DS 40*3


DIGIT_VLP_RELOAD EQU 6 ; due to try and error
