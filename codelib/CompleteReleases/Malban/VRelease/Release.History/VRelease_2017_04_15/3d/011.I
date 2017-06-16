; this file is part of Release, written by Malban in 2017
;
_011x            EQU (allDirs_calc + _0_1_1 - _0_0_0)
_011y            EQU (allDirs_calc + _0_1_1 - _0_0_0 + 1)
_011z            EQU (allDirs_calc + _0_1_1 - _0_0_0 + 2)
_011xi           EQU (allDirs_calc + (_0_1_1 - _0_0_0) + INVERS_OFFSET)
_011yi           EQU (allDirs_calc + (_0_1_1 - _0_0_0) + INVERS_OFFSET + 1)
_011zi           EQU (allDirs_calc + (_0_1_1 - _0_0_0) + INVERS_OFFSET + 2)

;***************************************************************************
INIT_0_1_1       MACRO
                 CALC_0_1_1 _011x, _011y, _011z
                 ENDM
;***************************************************************************
INIT_0_1_1_I     MACRO
                 CALC_0_1_1_I _011xi, _011yi, _011zi
                 ENDM
;***************************************************************************
INIT_0_1_1_A     MACRO
                 CALC_0_1_1_A _011x, _011y, _011z, _011xi, _011yi, _011zi
                 ENDM
;***************************************************************************
INIT_0_N_N       MACRO
                 CALC_0_1_1_I _011xi, _011yi, _011zi
                 ENDM
;***************************************************************************
INIT_0_N_N_I     MACRO
                 CALC_0_1_1 _011x, _011y, _011z
                 ENDM
;***************************************************************************
INIT_0_N_N_A     MACRO
                 CALC_0_1_1_A _011x, _011y, _011z, _011xi, _011yi, _011zi
                 ENDM
;***************************************************************************
CALC_0_1_1       MACRO _x, _y, _z
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
CALC_0_1_1_I     MACRO _xi, _yi, _zi
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
CALC_0_1_1_A     MACRO _x, _y, _z, _xi, _yi, _zi
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
