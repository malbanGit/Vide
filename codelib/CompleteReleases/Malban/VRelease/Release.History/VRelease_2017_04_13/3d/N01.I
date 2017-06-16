; this file is part of Release, written by Malban in 2017
;
_N01x            EQU (allDirs_calc + _N_0_1 - _0_0_0)
_N01y            EQU (allDirs_calc + _N_0_1 - _0_0_0 + 1)
_N01z            EQU (allDirs_calc + _N_0_1 - _0_0_0 + 2)
_N01xi           EQU (allDirs_calc + (_N_0_1 - _0_0_0) + INVERS_OFFSET)
_N01yi           EQU (allDirs_calc + (_N_0_1 - _0_0_0) + INVERS_OFFSET + 1)
_N01zi           EQU (allDirs_calc + (_N_0_1 - _0_0_0) + INVERS_OFFSET + 2)

;***************************************************************************
INIT_N_0_1       MACRO
                 CALC_N_0_1 _N01x, _N01y, _N01z
                 ENDM
;***************************************************************************
INIT_N_0_1_I     MACRO
                 CALC_N_0_1_I _N01xi, _N01yi, _N01zi
                 ENDM
;***************************************************************************
INIT_N_0_1_A     MACRO
                 CALC_N_0_1_A _N01x, _N01y, _N01z, _N01xi, _N01yi, _N01zi
                 ENDM
;***************************************************************************
INIT_1_0_N       MACRO
                 CALC_N_0_1_I _N01xi, _N01yi, _N01zi
                 ENDM
;***************************************************************************
INIT_1_0_N_I     MACRO
                 CALC_N_0_1 _N01x, _N01y, _N01z
                 ENDM
;***************************************************************************
INIT_1_0_N_A     MACRO
                 CALC_N_0_1_A _N01x, _N01y, _N01z, _N01xi, _N01yi, _N01zi
                 ENDM
;***************************************************************************
CALC_N_0_1       MACRO _x, _y, _z
 ifdef DO_Z_KOORDINATE 
                 LDA sinx
                 STA \3
 endif
                 A_EQUALS_MUL sinx, siny
                 SUBA   cosy
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
CALC_N_0_1_I     MACRO _xi, _yi, _zi
 ifdef DO_Z_KOORDINATE 
                 LDA sinx
                 NEGA
                 STA \3
 endif
                 A_EQUALS_MUL sinx, siny
                 SUBA   cosy
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
CALC_N_0_1_A     MACRO _x, _y, _z, _xi, _yi, _zi
 ifdef DO_Z_KOORDINATE 
                 LDA sinx
                 STA \3
                 NEGA
                 STA \6
 endif
                 A_EQUALS_MUL sinx, siny
                 SUBA   cosy
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
