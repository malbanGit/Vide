; this file is part of Release, written by Malban in 2017
;
_001x            EQU (allDirs_calc + _0_0_1 - _0_0_0)
_001y            EQU (allDirs_calc + _0_0_1 - _0_0_0 + 1)
_001z            EQU (allDirs_calc + _0_0_1 - _0_0_0 + 2)
_001xi           EQU (allDirs_calc + (_0_0_1 - _0_0_0) + INVERS_OFFSET)
_001yi           EQU (allDirs_calc + (_0_0_1 - _0_0_0) + INVERS_OFFSET + 1)
_001zi           EQU (allDirs_calc + (_0_0_1 - _0_0_0) + INVERS_OFFSET + 2)

;***************************************************************************
INIT_0_0_1       MACRO
                 CALC_0_0_1 _001x, _001y, _001z
                 ENDM
;***************************************************************************
INIT_0_0_1_I     MACRO
                 CALC_0_0_1_I _001xi, _001yi, _001zi
                 ENDM
;***************************************************************************
INIT_0_0_1_A     MACRO
                 CALC_0_0_1_A _001x, _001y, _001z, _001xi, _001yi, _001zi
                 ENDM
;***************************************************************************
INIT_0_0_N       MACRO
                 CALC_0_0_1_I _001xi, _001yi, _001zi
                 ENDM
;***************************************************************************
INIT_0_0_N_I     MACRO
                 CALC_0_0_1 _001x, _001y, _001z
                 ENDM
;***************************************************************************
INIT_0_0_N_A     MACRO
                 CALC_0_0_1_A _001x, _001y, _001z, _001xi, _001yi, _001zi
                 ENDM
;***************************************************************************
CALC_0_0_1       MACRO _x, _y, _z

 ifdef DO_Z_KOORDINATE 
                 LDA sinx
                 STA \3
 endif
                 A_EQUALS_MUL sinx, siny
                 STORE_A \1
                 A_EQUALS_MUL cosx, cosz
                 STORE_A \2
                 A_EQUALS_MUL \1, sinz
                 ADD_A_TO \2
                 A_EQUALS_MUL \1, cosz
                 STORE_A \1
                 A_EQUALS_MUL cosx, sinz
                 SUB_A_FROM \1

                 ENDM
;***************************************************************************
CALC_0_0_1_I     MACRO _xi, _yi, _zi

 ifdef DO_Z_KOORDINATE 
                 LDA sinx
                 NEGA
                 STA \3
 endif
                 A_EQUALS_MUL sinx, siny
                 STORE_A \1
                 A_EQUALS_MUL cosx, cosz
                 STORE_A \2
                 A_EQUALS_MUL \1, sinz
                 ADD_A_TO_NEG \2
                 A_EQUALS_MUL \1, cosz
                 STORE_A \1
                 A_EQUALS_MUL cosx, sinz
                 SUB_A_FROM_NEG \1
                 ENDM
;***************************************************************************
CALC_0_0_1_A     MACRO _x, _y, _z, _xi, _yi, _zi
 ifdef DO_Z_KOORDINATE 
                 LDA sinx
                 STA \3
                 NEGA
                 STA \6
 endif
                 A_EQUALS_MUL sinx, siny
                 STORE_A \1
                 A_EQUALS_MUL cosx, cosz
                 STORE_A \2
                 A_EQUALS_MUL \1, sinz
                 ADD_A_TO \2
                 STORE_A_NEG \5
                 A_EQUALS_MUL \1, cosz
                 STORE_A \1
                 A_EQUALS_MUL cosx, sinz
                 SUB_A_FROM \1
                 STORE_A_NEG \4
                 ENDM
;***************************************************************************
