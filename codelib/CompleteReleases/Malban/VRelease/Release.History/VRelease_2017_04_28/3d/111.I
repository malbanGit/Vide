; this file is part of Release, written by Malban in 2017
;
_111x            EQU (allDirs_calc + _1_1_1 - _0_0_0)
_111y            EQU (allDirs_calc + _1_1_1 - _0_0_0 + 1)
_111z            EQU (allDirs_calc + _1_1_1 - _0_0_0 + 2)
_111xi           EQU (allDirs_calc + (_1_1_1 - _0_0_0) + INVERS_OFFSET)
_111yi           EQU (allDirs_calc + (_1_1_1 - _0_0_0) + INVERS_OFFSET + 1)
_111zi           EQU (allDirs_calc + (_1_1_1 - _0_0_0) + INVERS_OFFSET + 2)

;***************************************************************************
INIT_1_1_1       MACRO
                 CALC_1_1_1 _111x, _111y, _111z
                 ENDM
;***************************************************************************
INIT_1_1_1_I     MACRO
                 CALC_1_1_1_I _111xi, _111yi, _111zi
                 ENDM
;***************************************************************************
INIT_1_1_1_A     MACRO
                 CALC_1_1_1_A _111x, _111y, _111z, _111xi, _111yi, _111zi
                 ENDM
;***************************************************************************
INIT_N_N_N       MACRO
                 CALC_1_1_1_I _111xi, _111yi, _111zi
                 ENDM
;***************************************************************************
INIT_N_N_N_I     MACRO
                 CALC_1_1_1 _111x, _111y, _111z
                 ENDM
;***************************************************************************
INIT_N_N_N_A     MACRO
                 CALC_1_1_1_A _111x, _111y, _111z, _111xi, _111yi, _111zi
                 ENDM
;***************************************************************************
CALC_1_1_1       MACRO _x, _y, _z
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
CALC_1_1_1_I     MACRO _xi, _yi, _zi
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
CALC_1_1_1_A     MACRO _x, _y, _z, _xi, _yi, _zi
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
