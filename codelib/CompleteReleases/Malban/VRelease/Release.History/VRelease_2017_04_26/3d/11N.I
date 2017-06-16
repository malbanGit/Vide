; this file is part of Release, written by Malban in 2017
;
_11Nx            EQU (allDirs_calc + _1_1_N - _0_0_0)
_11Ny            EQU (allDirs_calc + _1_1_N - _0_0_0 + 1)
_11Nz            EQU (allDirs_calc + _1_1_N - _0_0_0 + 2)
_11Nxi           EQU (allDirs_calc + (_1_1_N - _0_0_0) + INVERS_OFFSET)
_11Nyi           EQU (allDirs_calc + (_1_1_N - _0_0_0) + INVERS_OFFSET + 1)
_11Nzi           EQU (allDirs_calc + (_1_1_N - _0_0_0) + INVERS_OFFSET + 2)

;***************************************************************************
INIT_1_1_N       MACRO
                 CALC_1_1_N _11Nx, _11Ny, _11Nz
                 ENDM
;***************************************************************************
INIT_1_1_N_I     MACRO
                 CALC_1_1_N_I _11Nxi, _11Nyi, _11Nzi
                 ENDM
;***************************************************************************
INIT_1_1_N_A     MACRO
                 CALC_1_1_N_A _11Nx, _11Ny, _11Nz, _11Nxi, _11Nyi, _11Nzi
                 ENDM
;***************************************************************************
INIT_N_N_1       MACRO
                 CALC_1_1_N_I _11Nxi, _11Nyi, _11Nzi
                 ENDM
;***************************************************************************
INIT_N_N_1_I     MACRO
                 CALC_1_1_N _11Nx, _11Ny, _11Nz
                 ENDM
;***************************************************************************
INIT_N_N_1_A     MACRO
                 CALC_1_1_N_A _11Nx, _11Ny, _11Nz, _11Nxi, _11Nyi, _11Nzi
                 ENDM
;***************************************************************************
CALC_1_1_N       MACRO _x, _y, _z
 ifdef DO_Z_KOORDINATE 
                 LDA cosx
                 SUBA sinx
                 STA \3
 endif
                 LDA   cosx
                 SUBA  sinx
                 STA   \3

                 LDA   cosx
                 NEGA
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
CALC_1_1_N_I     MACRO _xi, _yi, _zi
 ifdef DO_Z_KOORDINATE 
                 LDA cosx
                 SUBA sinx
                 NEGA
                 STA \3
 endif
                 LDA   cosx
                 SUBA  sinx
                 STA   \3

                 LDA   cosx
                 NEGA
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
CALC_1_1_N_A     MACRO _x, _y, _z, _xi, _yi, _zi
 ifdef DO_Z_KOORDINATE 
                 LDA cosx
                 SUBA sinx
                 STA \3
                 NEGA
                 STA \6
 endif
                 LDA   cosx
                 SUBA  sinx
                 STA   \3

                 LDA   cosx
                 NEGA
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
