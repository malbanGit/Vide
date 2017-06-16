; this file is part of Release, written by Malban in 2017
;
_100x            EQU (allDirs_calc + _1_0_0 - _0_0_0)
_100y            EQU (allDirs_calc + _1_0_0 - _0_0_0 + 1)
_100z            EQU (allDirs_calc + _1_0_0 - _0_0_0 + 2)
_100xi           EQU (allDirs_calc + (_1_0_0 - _0_0_0) + INVERS_OFFSET)
_100yi           EQU (allDirs_calc + (_1_0_0 - _0_0_0) + INVERS_OFFSET + 1)
_100zi           EQU (allDirs_calc + (_1_0_0 - _0_0_0) + INVERS_OFFSET + 2)

;***************************************************************************
INIT_1_0_0       MACRO
                 CALC_1_0_0 _100x, _100y, _100z
                 ENDM
;***************************************************************************
INIT_1_0_0_I     MACRO
                 CALC_1_0_0_I _100xi, _100yi, _100zi
                 ENDM
;***************************************************************************
INIT_1_0_0_A     MACRO
                 CALC_1_0_0_A _100x, _100y, _100z, _100xi, _100yi, _100zi
                 ENDM
;***************************************************************************
INIT_N_0_0       MACRO
                 CALC_1_0_0_I _100xi, _100yi, _100zi
                 ENDM
;***************************************************************************
INIT_N_0_0_I     MACRO
                 CALC_1_0_0 _100x, _100y, _100z
                 ENDM
;***************************************************************************
INIT_N_0_0_A     MACRO
                 CALC_1_0_0_A _100x, _100y, _100z, _100xi, _100yi, _100zi
                 ENDM
;***************************************************************************
CALC_1_0_0       MACRO _x, _y, _z
 ifdef DO_Z_KOORDINATE 
                 CLRA
                 STA \3
 endif
                 A_EQUALS_MUL cosy, sinz
                 STORE_A \2
                 A_EQUALS_MUL cosy, cosz
                 STORE_A \1
                 ENDM
;***************************************************************************
CALC_1_0_0_I     MACRO _xi, _yi, _zi
 ifdef DO_Z_KOORDINATE 
                 CLRA
                 STA \3
 endif
                 A_EQUALS_MUL cosy, sinz
                 STORE_A_NEG \2
                 A_EQUALS_MUL cosy, cosz
                 STORE_A_NEG \1
                 ENDM
;***************************************************************************
CALC_1_0_0_A     MACRO _x, _y, _z, _xi, _yi, _zi
 ifdef DO_Z_KOORDINATE 
                 CLRA
                 STA \3
                 STA \6
 endif
                 A_EQUALS_MUL cosy, sinz
                 STORE_A \2
                 STORE_A_NEG \5
                 A_EQUALS_MUL cosy, cosz
                 STORE_A \1
                 STORE_A_NEG \4
                 ENDM
;***************************************************************************
