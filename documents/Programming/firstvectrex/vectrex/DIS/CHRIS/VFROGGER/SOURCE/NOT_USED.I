;***************************************************************************
MY_MOVE_TO      macro
                LDA #\2
                LDB #\1
                MY_MOVE_TO_D
                endm
;***************************************************************************
; signed multiplication of A, B to D
; uses mul_tmp1, (old mul_tmp2)
; destroys A, B
;
; can probably be optimized like hell
; perhaps look if higher than a power of two and use
; some initial ASLs...
;
; or look if the two are of different sign and use MUL and NEG
; this last is done here...
MY_MUL_A_B_D    macro
                TSTA                     ; test A
                BPL  mul_Ap\?            ; if positive, jump to MUL A positive
                NEGA                     ; otherwise make A positive
mul_An\?:                                ; here A was negative
                TSTB                     ; now test B
                BPL  mul_An_Bp\?         ; if B positive, than jump to MUL A negative, B positive
mul_An_Bn\?:                             ; here A and B negative
                NEGB                     ; make B positive
                BRA  mul_Ap_Bp\?         ; and do the same as A and B positive
mul_Ap\?:                                ; here A positive
                TSTB                     ; now test B
                BPL  mul_Ap_Bp\?         ; if B positive jump to MUL A positive and B positive
                NEGB                     ; otherwise make B positive
mul_An_Bp\?:                             ; here A negative and B positive
mul_Ap_Bn\?:                             ; here A positive and B negative
                MUL                      ; do a simple MUL
                STD mul_tmp1             ; isn't that sick ?
                CLRA                     ; this crap
                CLRB                     ; is in fact
                SUBD mul_tmp1            ; a NEGD !!!
                BRA mul_end\?            ; and go to exit
mul_Ap_Bp\?:                             ; here both A, B are positive
                MUL                      ; than a simple MUL is enough
mul_end\?:                               ; and done
                endm
;***************************************************************************
; quite a bit slower than the above...
; this is just a history lesson on how a MUL can be
; implemented using adds...
; not used anywhere :-)
old_MY_MUL_A_B_D    macro
                TSTB                     ; Test B
                BEQ  mul_zero\?          ; if zero, than do MUL zero
                TSTA                     ; Test A
                BEQ  mul_zero\?          ; if zero, than do MUL zero
                BPL  no_minus_a\?        ; jump if A positive
                NEGA                     ; A should be positiv, since it is our 'counter'
                NEGB                     ; invert both, so the sign is still the same
no_minus_a\?:                            ; A was positive from start
                STA  mul_tmp2            ; remember A
                CLRA                     ; clear A
                SEX                      ; make B sign extended
                STD  mul_tmp1            ; rememer extened B as well
                CLRA                     ; clear A
                CLRB                     ; clear B (D=0)
mul_on\?:                                ; now loop, D is our working area
                ADDD mul_tmp1            ; add 'sign extened B' to D
                DEC mul_tmp2             ; decrement 'counter A'
                BNE mul_on\?             ; if 'counter' not zero, go on
                BRA mul_end\?            ; otherwise finnish it
mul_zero\?:
                CLRA                     ; mul zero, clears D
                CLRB
mul_end\?:                               ; and done
                endm
;***************************************************************************
; divides B (0-127) by A (0-127)
; makro which divides the number in B by A, return in A
; B lost, A return val, tmp1 trashed...
; returns A(=0) on divide by 0, than nothing is lost at all
; uses divide_tmp as storage
MY_DIV          macro
                TSTA                     ; divide by zero is allways bad
                BEQ     divide_by_zero\? ; goto exit if that happened
                STA     divide_tmp       ; otherwise remember A
                LDA     #-1              ; and put -1 to A (incremented on loop entry)
divide_next\?:
                INCA                     ; increment one
                SUBB    divide_tmp       ; subtract B
                BPL     divide_next\?    ; and if still positive, loop again
divide_by_zero\?:
                endm                     ; end, result in A
;***************************************************************************
; fast (?) DIV D by 8
MY_DIV_D_8            macro
                      STD divide_tmp     ; isn't that sick ?
                      BPL D_positive\?   ; if positive, than jump
                      CLRA               ; this crap
                      CLRB               ; is in fact
                      SUBD divide_tmp    ; a NEGD !!!
                      MY_LSR_D           ; right shift is div 2
                      MY_LSR_D           ; 2 right shifts is div 4
                      MY_LSR_D           ; 3 right shifts is div 8
                      NEGB               ; it was negative, neg the result
                      BRA div_end\?      ; and exit
D_positive\?:
                      MY_LSR_D           ; right shift is div 2
                      MY_LSR_D           ; 2 right shifts is div 4
                      MY_LSR_D           ; 3 right shifts is div 8
div_end\?:
                      endm
;***************************************************************************
MY_DIV_D_32           macro
                      STD divide_tmp ; isn't that sick ?
                      BPL D_positive\?
                      CLRA           ; this crap
                      CLRB           ; is in fact
                      SUBD divide_tmp; a NEGD !!!

                      MY_LSR_D
                      MY_LSR_D
                      MY_LSR_D
                      MY_LSR_D
                      MY_LSR_D
                      NEGB
                      BRA div_end\?
D_positive\?:
                      MY_LSR_D
                      MY_LSR_D
                      MY_LSR_D
                      MY_LSR_D
                      MY_LSR_D
div_end\?:
                      endm
;***************************************************************************
MY_DIV_D_64           macro
                      STD divide_tmp ; isn't that sick ?
                      BPL D_positive\?
                      CLRA           ; this crap
                      CLRB           ; is in fact
                      SUBD divide_tmp; a NEGD !!!

                      MY_LSR_D
                      MY_LSR_D
                      MY_LSR_D
                      MY_LSR_D
                      MY_LSR_D
                      MY_LSR_D
                      NEGB
                      BRA div_end\?
D_positive\?:
                      MY_LSR_D
                      MY_LSR_D
                      MY_LSR_D
                      MY_LSR_D
                      MY_LSR_D
                      MY_LSR_D
div_end\?:
                      endm
;***************************************************************************
; fast (?) DIV D by 16
MY_DIV_D_16           macro
                      TSTA               ; 2 cycles
                      BPL D_positive\?   ; if positive, than jump
                      STD divide_tmp     ; isn't that sick ? 6 cycles
                      CLRA               ; this crap
                      CLRB               ; is in fact
                      SUBD divide_tmp    ; a NEGD !!!
                      LSLA               ; left shift A 4 times
                      LSLA
                      LSLA
                      LSLA
                      LSRB               ; right shift B 4 times
                      LSRB
                      LSRB
                      LSRB
                      STA divide_tmp     ; there is no such thing as ORB A (!)
                      ORB divide_tmp     ; or the result
                      NEGB               ; here we are negative
                      BRA div_end\?      ; jump to done
D_positive\?:
                      LSLA               ; left shift A 4 times
                      LSLA
                      LSLA
                      LSLA
                      LSRB               ; right shift B 4 times
                      LSRB
                      LSRB
                      LSRB
                      STA divide_tmp     ; there is no such thing as ORB A (!)
                      ORB divide_tmp     ; or the result
div_end\?:
                      endm               ; done
;***************************************************************************
MY_DIV_D_8_UNSIGNED   macro
                      MY_LSR_D
                      MY_LSR_D
                      MY_LSR_D
                      endm
;***************************************************************************
MY_DIV_D_32_UNSIGNED  macro
                      MY_LSR_D
                      MY_LSR_D
                      MY_LSR_D
                      MY_LSR_D
                      MY_LSR_D
                      endm
;***************************************************************************
MY_DIV_D_64_UNSIGNED  macro
                      MY_LSR_D
                      MY_LSR_D
                      MY_LSR_D
                      MY_LSR_D
                      MY_LSR_D
                      MY_LSR_D
                      endm
;***************************************************************************
