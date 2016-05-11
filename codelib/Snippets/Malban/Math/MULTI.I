;***************************************************************************
NEG_D              macro
        COMA
        COMB
        ADDD #1
                      endm               ; done
;***************************************************************************
; there are many 16 bit operands missing, so is
; a LSRD
; this macro does a 16 bit LSR on register D
MY_LSL_D              macro
        ASLB
        ROLA
                      endm               ; done
;***************************************************************************
; this does:
; signed multiplication of A and B to D
; result is stored in D
D_EQUALS_MUL     MACRO mul1, mul2
                 LDB           \2
                 LDA           \1
                 BPL           mul_Ap\?
                 NEGA
                 TSTB
                 BPL           mul_An_Bp\?
                 NEGB
                 BRA           mul_An_Bn\?
mul_Ap\?:
                 TSTB
                 BPL           mul_Ap_Bp\?
                 NEGB
mul_An_Bp\?:
                 MUL
                 NEG_D
                 BRA           mul_end\?
mul_Ap_Bp\?:
mul_An_Bn\?:
                 MUL
mul_end\?:
                 ENDM
;***************************************************************************
D_EQUALS_MUL_A_B MACRO
                 TSTA
                 BPL           mul_Ap\?
                 NEGA
                 TSTB
                 BPL           mul_An_Bp\?
                 NEGB
                 BRA           mul_An_Bn\?
mul_Ap\?:
                 TSTB
                 BPL           mul_Ap_Bp\?
                 NEGB
mul_An_Bp\?:
                 MUL
                 NEG_D
                 BRA           mul_end\?
mul_Ap_Bp\?:
mul_An_Bn\?:
                 MUL
mul_end\?:
                 ENDM

;***************************************************************************
