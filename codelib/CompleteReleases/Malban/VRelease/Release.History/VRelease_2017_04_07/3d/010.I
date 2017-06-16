; this file is part of Release, written by Malban in 2017
;
_010x            EQU (allDirs_calc + _0_1_0 - _0_0_0)
_010y            EQU (allDirs_calc + _0_1_0 - _0_0_0 + 1)
_010z            EQU (allDirs_calc + _0_1_0 - _0_0_0 + 2)
_010xi           EQU (allDirs_calc + (_0_1_0 - _0_0_0) + INVERS_OFFSET)
_010yi           EQU (allDirs_calc + (_0_1_0 - _0_0_0) + INVERS_OFFSET + 1)
_010zi           EQU (allDirs_calc + (_0_1_0 - _0_0_0) + INVERS_OFFSET + 2)

;***************************************************************************
INIT_0_1_0       MACRO
                 CALC_0_1_0 _010x, _010y, _010z
                 ENDM
;***************************************************************************
INIT_0_1_0_I     MACRO
                 CALC_0_1_0_I _010xi, _010yi, _010zi
                 ENDM
;***************************************************************************
INIT_0_1_0_A     MACRO
                 CALC_0_1_0_A _010x, _010y, _010z, _010xi, _010yi, _010yi
                 ENDM
;***************************************************************************
INIT_0_N_0       MACRO
                 CALC_0_1_0_I _010xi, _010yi, _010zi
                 ENDM
;***************************************************************************
INIT_0_N_0_I     MACRO
                 CALC_0_1_0 _010x, _010y, _010z
                 ENDM
;***************************************************************************
INIT_0_N_0_A     MACRO
                 CALC_0_1_0_A _010x, _010y, _010z, _010xi, _010yi, _010zi
                 ENDM
;***************************************************************************
CALC_0_1_0       MACRO _x, _y, _z
 ifdef DO_Z_KOORDINATE 
                 LDA cosx
                 STA \3
 endif
                 A_EQUALS_MUL cosx, siny
                 STORE_A \1
                 A_EQUALS_MUL \1, sinz
                 STORE_A \2
                 A_EQUALS_MUL sinx, cosz
                 SUB_A_FROM \2
                 A_EQUALS_MUL \1, cosz
                 STORE_A \1
                 A_EQUALS_MUL sinx, sinz
                 ADD_A_TO \1
                 ENDM
;***************************************************************************
CALC_0_1_0_I     MACRO _xi, _yi, _zi
 ifdef DO_Z_KOORDINATE 
                 LDA cosx
                 NEGA
                 STA \3
 endif
                 A_EQUALS_MUL cosx, siny
                 STORE_A \1
                 A_EQUALS_MUL \1, sinz
                 STORE_A \2
                 A_EQUALS_MUL sinx, cosz
                 SUB_A_FROM_NEG \2
                 A_EQUALS_MUL \1, cosz
                 STORE_A \1
                 A_EQUALS_MUL sinx, sinz
                 ADD_A_TO_NEG \1
                 ENDM
;***************************************************************************
CALC_0_1_0_A     MACRO _x, _y, _z, _xi, _yi, _zi
 ifdef DO_Z_KOORDINATE 
                 LDA cosx
                 STA \3
                 NEGA
                 STA \6
 endif
                 A_EQUALS_MUL cosx, siny
                 STORE_A \1
                 A_EQUALS_MUL \1, sinz
                 STORE_A \2
                 A_EQUALS_MUL sinx, cosz
                 SUB_A_FROM \2
                 STORE_A_NEG \5
                 A_EQUALS_MUL \1, cosz
                 STORE_A \1
                 A_EQUALS_MUL sinx, sinz
                 ADD_A_TO \1
                 STORE_A_NEG \4
                 ENDM
;***************************************************************************
