; this file is part of Release, written by Malban in 2017
;
;***************************************************************************
STORE_A          MACRO address
                 STA           \1
                 ENDM
;***************************************************************************
ADD_A_TO         MACRO address
                 ADDA          \1
                 STORE_A       \1
                 ENDM
;***************************************************************************
SUB_A_FROM       MACRO address
                 NEGA
                 ADD_A_TO      \1
                 ENDM
;***************************************************************************
STORE_A_NEG      MACRO address
                 NEGA
                 STA           \1
                 ENDM
;***************************************************************************
ADD_A_TO_NEG     MACRO address
                 ADDA          \1
                 STORE_A_NEG   \1
                 ENDM
;***************************************************************************
SUB_A_FROM_NEG   MACRO address
                 NEGA
                 ADD_A_TO_NEG  \1
                 ENDM
;***************************************************************************
; this does:
; signed multiplication of parameter 1 and parameter 2 to D
; and divides D by 64
; result is stored in A
A_EQUALS_MUL     MACRO mul1, mul2
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
                 COMB                              ; here we can use this as negd
                 COMA                              ; since the low nibble of b doesn't interest us
                 BRA           mul_end\?
mul_Ap_Bp\?:
mul_An_Bn\?:
                 MUL
mul_end\?:
                 ASLB                              ; this divides d by 64
                 ROLA
                 ASLB
                 ROLA

                 ENDM

;***************************************************************************
                 INCLUDE "3d/000.I"
                 INCLUDE "3d/100.I"
                 INCLUDE "3d/110.I"
                 INCLUDE "3d/101.I"
                 INCLUDE "3d/111.I"
                 INCLUDE "3d/010.I"
                 INCLUDE "3d/011.I"
                 INCLUDE "3d/001.I"
                 INCLUDE "3d/N10.I"
                 INCLUDE "3d/N01.I"
                 INCLUDE "3d/0N1.I"
                 INCLUDE "3d/N11.I"
                 INCLUDE "3d/1N1.I"
                 INCLUDE "3d/11N.I"


