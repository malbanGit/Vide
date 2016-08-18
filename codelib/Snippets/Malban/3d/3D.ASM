                INCLUDE "VECTREX.I"       ; vectrex function includes

                BSS
                ORG     $c880             ; well start of our ram space
                INCLUDE "3D_VAR.I"        ; vectrex function includes

                CODE
                INCLUDE "3D_MAKRO.I"
;***************************************************************************
                ORG     0
; start of vectrex memory with cartridge name...
                DB      "g GCE 1998", $80 ; 'g' is copyright sign
                DW      music7            ; music from the rom
                DB      $F8, $50, $20, -$30; hight, width, rel y, rel x (from 0,0)
                DB      "3D TEST", $80; some game information, ending with $80
                DB      $F8, $50, $5, -$6d; hight, width, rel y, rel x (from 0,0)
                DB      "MALBAN", $80; some game information, ending with $80
                DB      0                 ; end of game header
;***************************************************************************
; here the cartridge program starts off
entry_point:
                LDA     #6
                CLR     angle_x
                STA     angle_y
                STA     angle_z
main_loop:
                JSR     Wait_Recal        ; sets dp to d0, and pos at 0, 0

                JSR     Intensity_3F      ; intensity to $3f, gets destroyed
                                          ; by recalibration
                LDA     #$7f              ; scale factor
                STA     VIA_t1_cnt_lo     ; move to time 1 lo, this means scaling

                LDD     #0
                JSR     Moveto_d          ; and go to position


                JSR     init_cube
                LDX     #cubeM
                JSR     draw_3ds

                INC     angle_x
                LDA     angle_x
                CMPA    #64
                BNE     main_loop
                CLR     angle_x

                BRA     main_loop         ; go back to main loop
;***************************************************************************
init_cube:
                LDX     #cosinus3d
                LDU     #sinus3d

                LDB     angle_x
                LDA     B, X
                STA     cosx
                LDA     B, U
                STA     sinx

                LDB     angle_y
                LDA     B, X
                STA     cosy
                LDA     B, U
                STA     siny

                LDB     angle_z
                LDA     B, X
                STA     cosz
                LDA     B, U
                STA     sinz


                INIT_0_0_1_A

                INIT_0_1_0_A

                INIT_1_0_0_A

                RTS
;***************************************************************************

                INCLUDE "3D_PRG.I"

;***************************************************************************
CUBE_STRENGTH   EQU 250
cubeM:
                DB 0  , CUBE_STRENGTH/2
                DW _N_0_0
                DB 0  , CUBE_STRENGTH/2
                DW _0_N_0
                DB 0  , CUBE_STRENGTH/2
                DW _0_0_N

                DB 255, CUBE_STRENGTH
                DW _1_0_0
                DB 255, CUBE_STRENGTH
                DW _0_1_0
                DB 255, CUBE_STRENGTH
                DW _N_0_0
                DB 255, CUBE_STRENGTH
                DW _0_N_0

                DB 255, CUBE_STRENGTH
                DW _0_0_1

                DB 255, CUBE_STRENGTH
                DW _1_0_0
                DB 255, CUBE_STRENGTH
                DW _0_1_0
                DB 255, CUBE_STRENGTH
                DW _N_0_0
                DB 255, CUBE_STRENGTH
                DW _0_N_0

                DB   0, CUBE_STRENGTH
                DW _1_0_0
                DB 255, CUBE_STRENGTH
                DW _0_0_N

                DB   0, CUBE_STRENGTH
                DW _0_1_0
                DB 255, CUBE_STRENGTH
                DW _0_0_1
                DB   0, CUBE_STRENGTH
                DW _N_0_0
                DB 255, CUBE_STRENGTH
                DW _0_0_N

                DB   1

;***************************************************************************
                END entry_point
;***************************************************************************
