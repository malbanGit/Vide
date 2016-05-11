; there are many 16 bit operands missing, so is
; a LSRD
; this macro does a 16 bit LSR on register D

NEG_D              macro
        COMA
        COMB
        ADDD #1
                      endm               ; done
;***************************************************************************
MY_LSR_D              macro
        ASRA
        RORB
                      endm               ; done
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
                      TSTA
                      BPL D_positive\?
                      NEG_D
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
                      TSTA
                      BPL D_positive\?
                      NEG_D

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
                      TSTA
                      BPL D_positive\?
                      NEG_D

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
                      TSTA
                      BPL D_positive\?
                      NEG_D
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
; divides D by tmp1, result in B
; uses divide_tmp as storage
; only 8 bit in tmp1, but must be manually poked to tmp1 + 1
; sign is correctly handled
;
; can probably be optimized like hell
; perhaps only nearing the result
; using 2 shifts and a plus
; might be worth a try,
; see vectrex emulator for algorithm...
; could be implemented with a tabel, which in turn
; could be caclulated on the fly... (upon startup)
;
; this makro divides exact, but slow
MY_DIV_D_BY_TMP1_TO_B macro
                CLR     divide_tmp
                TST     tmp1+1
                BEQ     divide_by_zero\?
                DEC     divide_tmp
                CMPD    #0
                BPL     divide_next\?
divide_next1\?:
                INC     divide_tmp
                ADDD    tmp1
                BMI     divide_next1\?
divide_by_zero1\?:
                LDB     divide_tmp
                NEGB
                BRA     divide_end\?
divide_next\?:
                INC     divide_tmp
                SUBD    tmp1
                BPL     divide_next\?
divide_by_zero\?:
                LDB     divide_tmp
divide_end\?:
                endm
;***************************************************************************
; divides D by tmp1, result in B
; uses divide_tmp as storage
; only 8 bit in tmp1, but must be manually poked to tmp1 + 1
; sign is correctly handled
;
; can probably be optimized like hell
; perhaps only nearing the result
; using 2 shifts and a plus
; might be worth a try,
; see vectrex emulator for algorithm...
; could be implemented with a tabel, which in turn
; could be caclulated on the fly... (upon startup)
;
; this makro divides exact, but slow
MY_DIV_D_BY_TMP1_TO_B_UNSIGNED macro
                CLR     divide_tmp
                TST     tmp1+1
                BEQ     divide_by_zero\?
                DEC     divide_tmp
                CMPD    #0
                BPL     divide_next\?
divide_next1\?:
                INC     divide_tmp
                ADDD    tmp1
                BMI     divide_next1\?
divide_by_zero1\?:
                LDB     divide_tmp
                NEGB
                BRA     divide_end\?
divide_next\?:
                INC     divide_tmp
                SUBD    tmp1
                BPL     divide_next\?
divide_by_zero\?:
                LDB     divide_tmp
divide_end\?:
                endm
