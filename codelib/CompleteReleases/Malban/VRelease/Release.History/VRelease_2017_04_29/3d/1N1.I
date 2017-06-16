; this file is part of Release, written by Malban in 2017
;
_1N1x            EQU (allDirs_calc + _1_N_1 - _0_0_0)
_1N1y            EQU (allDirs_calc + _1_N_1 - _0_0_0 + 1)
_1N1z            EQU (allDirs_calc + _1_N_1 - _0_0_0 + 2)
_1N1xi           EQU (allDirs_calc + (_1_N_1 - _0_0_0) + INVERS_OFFSET)
_1N1yi           EQU (allDirs_calc + (_1_N_1 - _0_0_0) + INVERS_OFFSET + 1)
_1N1zi           EQU (allDirs_calc + (_1_N_1 - _0_0_0) + INVERS_OFFSET + 2)

;***************************************************************************
INIT_1_N_1       MACRO
                 CALC_1_N_1 _1N1x, _1N1y, _1N1z
                 ENDM
;***************************************************************************
INIT_1_N_1_I     MACRO
                 CALC_1_N_1_I _1N1xi, _1N1yi, _1N1zi
                 ENDM
;***************************************************************************
INIT_1_N_1_A     MACRO
                 CALC_1_N_1_A _1N1x, _1N1y, _1N1z, _1N1xi, _1N1yi, _1N1zi
                 ENDM
;***************************************************************************
INIT_N_1_N       MACRO
                 CALC_1_N_1_I _1N1xi, _1N1yi, _1N1zi
                 ENDM
;***************************************************************************
INIT_N_1_N_I     MACRO
                 CALC_1_N_1 _1N1x, _1N1y, _1N1z
                 ENDM
;***************************************************************************
INIT_N_1_N_A     MACRO
                 CALC_1_N_1_A _1N1x, _1N1y, _1N1z, _1N1xi, _1N1yi, _1N1zi
                 ENDM
;***************************************************************************
CALC_1_N_1       MACRO _x, _y, _z
 ifdef DO_Z_KOORDINATE 
                 LDA sinx
                 SUBA cosx
                 STA \3
 endif
                 LDA   sinx
                 SUBA  cosx
                 STA   \3

                 LDA   cosx
                 ADDA  sinx
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
CALC_1_N_1_I     MACRO _xi, _yi, _zi
 ifdef DO_Z_KOORDINATE 
                 LDA sinx
                 SUBA cosx
                 NEGA
                 STA \3
 endif
                 LDA   sinx
                 SUBA  cosx
                 STA   \3

                 LDA   cosx
                 ADDA  sinx
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
CALC_1_N_1_A     MACRO _x, _y, _z, _xi, _yi, _zi
 ifdef DO_Z_KOORDINATE 
                 LDA sinx
                 SUBA cosx
                 STA \3
                 NEGA
                 STA \6
 endif
                 LDA   sinx
                 SUBA  cosx
                 STA   \3

                 LDA   cosx
                 ADDA  sinx
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
