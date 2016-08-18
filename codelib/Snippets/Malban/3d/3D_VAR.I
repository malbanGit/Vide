; uses 11 + 27 *3 = 92 bytes RAM space

helper:          DB 0
cosx:            DB 0
sinx:            DB 0
cosy:            DB 0
siny:            DB 0
cosz:            DB 0
sinz:            DB 0
angle_x:         DB 0
angle_y:         DB 0
angle_z:         DB 0

allDirs_calc:    DS 27 * 3

_0_0_0           EQU (allDirs_calc+0)
_1_0_0           EQU (allDirs_calc+3)
_1_1_0           EQU (allDirs_calc+6)
_1_0_1           EQU (allDirs_calc+9)
_1_1_1           EQU (allDirs_calc+12)
_0_1_0           EQU (allDirs_calc+15)
_0_1_1           EQU (allDirs_calc+18)
_0_0_1           EQU (allDirs_calc+21)
_N_1_0           EQU (allDirs_calc+24)
_N_0_1           EQU (allDirs_calc+27)
_0_N_1           EQU (allDirs_calc+30)
_N_1_1           EQU (allDirs_calc+33)
_1_N_1           EQU (allDirs_calc+36)
_1_1_N           EQU (allDirs_calc+39)

INVERS_OFFSET    EQU 42

I_0_0_0          EQU (_0_0_0 + INVERS_OFFSET)
I_1_0_0          EQU (_1_0_0 + INVERS_OFFSET)
I_1_1_0          EQU (_1_1_0 + INVERS_OFFSET)
I_1_0_1          EQU (_1_0_1 + INVERS_OFFSET)
I_1_1_1          EQU (_1_1_1 + INVERS_OFFSET)
I_0_1_0          EQU (_0_1_0 + INVERS_OFFSET)
I_0_1_1          EQU (_0_1_1 + INVERS_OFFSET)
I_0_0_1          EQU (_0_0_1 + INVERS_OFFSET)
I_N_1_0          EQU (_N_1_0 + INVERS_OFFSET)
I_N_0_1          EQU (_N_0_1 + INVERS_OFFSET)
I_0_N_1          EQU (_0_N_1 + INVERS_OFFSET)
I_N_1_1          EQU (_N_1_1 + INVERS_OFFSET)
I_1_N_1          EQU (_1_N_1 + INVERS_OFFSET)
I_1_1_N          EQU (_1_1_N + INVERS_OFFSET)

_N_0_0           EQU I_1_0_0
_N_N_0           EQU I_1_1_0
_N_0_N           EQU I_1_0_1
_N_N_N           EQU I_1_1_1
_0_N_0           EQU I_0_1_0
_0_N_N           EQU I_0_1_1
_0_0_N           EQU I_0_0_1
_1_N_0           EQU I_N_1_0
_1_0_N           EQU I_N_0_1
_0_1_N           EQU I_0_N_1
_1_N_N           EQU I_N_1_1
_N_1_N           EQU I_1_N_1
_N_N_1           EQU I_1_1_N
