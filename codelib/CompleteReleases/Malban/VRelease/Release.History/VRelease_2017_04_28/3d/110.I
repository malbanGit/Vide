; this file is part of Release, written by Malban in 2017
;
_110x            EQU (allDirs_calc + _1_1_0 - _0_0_0)
_110y            EQU (allDirs_calc + _1_1_0 - _0_0_0 + 1)
_110z            EQU (allDirs_calc + _1_1_0 - _0_0_0 + 2)
_110xi           EQU (allDirs_calc + (_1_1_0 - _0_0_0) + INVERS_OFFSET)
_110yi           EQU (allDirs_calc + (_1_1_0 - _0_0_0) + INVERS_OFFSET + 1)
_110zi           EQU (allDirs_calc + (_1_1_0 - _0_0_0) + INVERS_OFFSET + 2)

;***************************************************************************
INIT_1_1_0       MACRO
                 CALC_1_1_0 _110x, _110y, _110z
                 ENDM
;***************************************************************************
INIT_1_1_0_I     MACRO
                 CALC_1_1_0_I _110xi, _110yi, _110zi
                 ENDM
;***************************************************************************
INIT_1_1_0_A     MACRO
                 CALC_1_1_0_A _110x, _110y, _110z, _110xi, _110yi, _110zi
                 ENDM
;***************************************************************************
INIT_N_N_0       MACRO
                 CALC_1_1_0_I _110xi, _110yi, _110zi
                 ENDM
;***************************************************************************
INIT_N_N_0_I     MACRO
                 CALC_1_1_0 _110x, _110y, _110z
                 ENDM
;***************************************************************************
INIT_N_N_0_A     MACRO
                 CALC_1_1_0_A _110x, _110y, _110z, _110xi, _110yi, _110zi
                 ENDM
;***************************************************************************
CALC_1_1_0       MACRO _x, _y, _z
 ifdef DO_Z_KOORDINATE 
                 LDA cosx
                 STA \3
 endif
                 LDA   sinx
                 NEGA
                 STA   helper
                 A_EQUALS_MUL cosx, siny
                 ADDA  cosy
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
CALC_1_1_0_I     MACRO _xi, _yi, _zi
 ifdef DO_Z_KOORDINATE 
                 LDA cosx
                 NEGA
                 STA \3
 endif
                 LDA   sinx
                 NEGA
                 STA   helper
                 A_EQUALS_MUL cosx, siny
                 ADDA  cosy
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
CALC_1_1_0_A     MACRO _x, _y, _z, _xi, _yi, _zi
 ifdef DO_Z_KOORDINATE 
                 LDA cosx
                 STA \3
                 NEGA
                 STA \6
 endif
                 LDA   sinx
                 NEGA
                 STA   helper
                 A_EQUALS_MUL cosx, siny
                 ADDA  cosy
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
