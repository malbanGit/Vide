; this file is part of Release, written by Malban in 2017
;
_000x            EQU (allDirs_calc + _0_0_0 - _0_0_0)
_000y            EQU (allDirs_calc + _0_0_0 - _0_0_0 + 1)
_000z            EQU (allDirs_calc + _0_0_0 - _0_0_0 + 2)
_000xi           EQU (allDirs_calc + (_0_0_0 - _0_0_0) + INVERS_OFFSET)
_000yi           EQU (allDirs_calc + (_0_0_0 - _0_0_0) + INVERS_OFFSET + 1)
_000zi           EQU (allDirs_calc + (_0_0_0 - _0_0_0) + INVERS_OFFSET + 2)

;***************************************************************************
INIT_0_0_0       MACRO
                 CALC_0_0_0 _000x, _000y, _000z
                 ENDM
;***************************************************************************
INIT_0_0_0_I     MACRO
                 CALC_0_0_0_I _000xi, _000yi, _000zi
                 ENDM
;***************************************************************************
INIT_0_0_0_A     MACRO
                 CALC_0_0_0_A _000x, _000y, _000z, _000xi, _000yi, _000zi
                 ENDM
;***************************************************************************
CALC_0_0_0       MACRO _x, _y, _z
                 CLRA
                 STA           \1
                 STA           \2
 ifdef DO_Z_KOORDINATE 
                 STA \3
 endif
                 ENDM
;***************************************************************************
CALC_0_0_0_I     MACRO _xi, _yi, _zi
                 CLRA
                 STA           \1
                 STA           \2
 ifdef DO_Z_KOORDINATE 
                 STA \3
 endif
                 ENDM
;***************************************************************************
CALC_0_0_0_A     MACRO _x, _y, _z, _xi, _yi, _zi
                 CLRA
                 STA           \1
                 STA           \2
                 STA           \4
                 STA           \5
 ifdef DO_Z_KOORDINATE 
                 STA \3
                 STA \6
 endif
                 ENDM
;***************************************************************************
