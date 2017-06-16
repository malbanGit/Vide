; this file is part of Release, written by Malban in 2017
;
_0N1x            EQU (allDirs_calc + _0_N_1 - _0_0_0)
_0N1y            EQU (allDirs_calc + _0_N_1 - _0_0_0 + 1)
_0N1z            EQU (allDirs_calc + _0_N_1 - _0_0_0 + 2)
_0N1xi           EQU (allDirs_calc + (_0_N_1 - _0_0_0) + INVERS_OFFSET)
_0N1yi           EQU (allDirs_calc + (_0_N_1 - _0_0_0) + INVERS_OFFSET + 1)
_0N1zi           EQU (allDirs_calc + (_0_N_1 - _0_0_0) + INVERS_OFFSET + 2)

;***************************************************************************
INIT_0_N_1       MACRO
                 CALC_0_N_1 _0N1x, _0N1y, _0N1z
                 ENDM
;***************************************************************************
INIT_0_N_1_I     MACRO
                 CALC_0_N_1_I _0N1xi, _0N1yi, _0N1zi
                 ENDM
;***************************************************************************
INIT_0_N_1_A     MACRO
                 CALC_0_N_1_A _0N1x, _0N1y, _0N1z, _0N1xi, _0N1yi, _0N1zi
                 ENDM
;***************************************************************************
INIT_0_1_N       MACRO
                 CALC_0_N_1_I _0N1xi, _0N1yi, _0N1zi
                 ENDM
;***************************************************************************
INIT_0_1_N_I     MACRO
                 CALC_0_N_1 _0N1x, _0N1y, _0N1z
                 ENDM
;***************************************************************************
INIT_0_1_N_A     MACRO
                 CALC_0_N_1_A _0N1x, _0N1y, _0N1z, _0N1xi, _0N1yi, _0N1zi
                 ENDM
;***************************************************************************
CALC_0_N_1       MACRO _x, _y, _z
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
CALC_0_N_1_I     MACRO _xi, _yi, _zi
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
CALC_0_N_1_A     MACRO _x, _y, _z, _xi, _yi, _zi
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
