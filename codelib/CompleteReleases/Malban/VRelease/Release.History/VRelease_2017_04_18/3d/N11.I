; this file is part of Release, written by Malban in 2017
;
_N11x            EQU (allDirs_calc + _N_1_1 - _0_0_0)
_N11y            EQU (allDirs_calc + _N_1_1 - _0_0_0 + 1)
_N11z            EQU (allDirs_calc + _N_1_1 - _0_0_0 + 2)
_N11xi           EQU (allDirs_calc + (_N_1_1 - _0_0_0) + INVERS_OFFSET)
_N11yi           EQU (allDirs_calc + (_N_1_1 - _0_0_0) + INVERS_OFFSET + 1)
_N11zi           EQU (allDirs_calc + (_N_1_1 - _0_0_0) + INVERS_OFFSET + 2)

;***************************************************************************
INIT_N_1_1       MACRO
                 CALC_N_1_1 _N11x, _N11y, _N11z
                 ENDM
;***************************************************************************
INIT_N_1_1_I     MACRO
                 CALC_N_1_1_I _N11xi, _N11yi, _N11zi
                 ENDM
;***************************************************************************
INIT_N_1_1_A     MACRO
                 CALC_N_1_1_A _N11x, _N11y, _N11z, _N11xi, _N11yi, _N11zi
                 ENDM
;***************************************************************************
INIT_1_N_N       MACRO
                 CALC_N_1_1_I _N11xi, _N11yi, _N11zi
                 ENDM
;***************************************************************************
INIT_1_N_N_I     MACRO
                 CALC_N_1_1 _N11x, _N11y, _N11z
                 ENDM
;***************************************************************************
INIT_1_N_N_A     MACRO
                 CALC_N_1_1_A _N11x, _N11y, _N11z, _N11xi, _N11yi, _N11zi
                 ENDM
;***************************************************************************
CALC_N_1_1       MACRO _x, _y, _z
 ifdef DO_Z_KOORDINATE 
                 LDA cosx
                 ADDA sinx
                 STA \3
 endif
                 LDA   sinx
                 ADDA  cosx
                 STA   \3

                 LDA   cosx
                 SUBA  sinx
                 STA   helper

                 A_EQUALS_MUL \3, siny
                 SUBA  cosy
                 STORE_A \1
                 A_EQUALS_MUL helper, cosz
                 STORE_A \2
                 A_EQUALS_MUL \1, sinz
                 ADD_A_TO \2
                 A_EQUALS_MUL \1, cosz
                 STORE_A \1
                 A_EQUALS_MUL helper, sinz
                 SUB_A_FROM \1
                 ENDM
;***************************************************************************
CALC_N_1_1_I     MACRO _xi, _yi, _zi
 ifdef DO_Z_KOORDINATE 
                 LDA cosx
                 ADDA sinx
                 NEGA
                 STA \3
 endif
                 LDA   sinx
                 ADDA  cosx
                 STA   \3

                 LDA   cosx
                 SUBA  sinx
                 STA   helper

                 A_EQUALS_MUL \3, siny
                 SUBA  cosy
                 STORE_A \1
                 A_EQUALS_MUL helper, cosz
                 STORE_A \2
                 A_EQUALS_MUL \1, sinz
                 ADD_A_TO_NEG \2
                 A_EQUALS_MUL \1, cosz
                 STORE_A \1
                 A_EQUALS_MUL helper, sinz
                 SUB_A_FROM_NEG \1
                 ENDM
;***************************************************************************
CALC_N_1_1_A     MACRO _x, _y, _z, _xi, _yi, _zi
 ifdef DO_Z_KOORDINATE 
                 LDA cosx
                 ADDA sinx
                 STA \3
                 NEGA
                 STA \6
 endif
                 LDA   sinx
                 ADDA  cosx
                 STA   \3

                 LDA   cosx
                 SUBA  sinx
                 STA   helper

                 A_EQUALS_MUL \3, siny
                 SUBA  cosy
                 STORE_A \1
                 A_EQUALS_MUL helper, cosz
                 STORE_A \2
                 A_EQUALS_MUL \1, sinz
                 ADD_A_TO \2
                 STORE_A_NEG \5
                 A_EQUALS_MUL \1, cosz
                 STORE_A \1
                 A_EQUALS_MUL helper, sinz
                 SUB_A_FROM \1
                 STORE_A_NEG \4
                 ENDM
;***************************************************************************
