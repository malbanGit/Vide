; this file is part of Release, written by Malban in 2017
;
initStart 
                    LDX      #cosinus3d 
                    LDU      #sinus3d 
                    LDB      angle_x 
                    LDA      B, X 
                    STA      cosx 
                    LDA      B, U 
                    STA      sinx 
                    LDB      angle_y 
                    LDA      B, X 
                    STA      cosy 
                    LDA      B, U 
                    STA      siny 
                    LDB      angle_z 
                    LDA      B, X 
                    STA      cosz 
                    LDA      B, U 
                    STA      sinz 
                    rts      

init_all 
                    bsr      initStart 
                    INIT_1_0_0_A  
                    INIT_0_1_0_A  
                    INIT_1_1_0_A  
                    INIT_1_N_0_A  
                    RTS      

;init_A:
; jsr  initStart
;                INIT_1_1_0_A
;                INIT_0_1_0_A
;                INIT_1_0_0_A
;                INIT_N_1_0
;                RTS
;init_E:
; jsr  initStart
;                INIT_0_1_0_A
;                INIT_N_1_0
;                INIT_1_0_0
;                RTS
;init_G:
; jsr  initStart
;                INIT_1_0_0_A
;                INIT_0_1_0_A
;                INIT_N_N_0
;                RTS
;init_M:
; jsr  initStart
;                INIT_1_0_0_A
;                INIT_1_1_0_A
;                INIT_N_1_0
;                RTS
;
;init_O:
; jsr  initStart
;                INIT_1_0_0_A
;                INIT_0_1_0_A
;                INIT_N_N_0
;                RTS
;
;init_R:
; jsr  initStart
;                INIT_0_1_0_A
;                INIT_1_0_0
;                INIT_N_N_0
;                RTS
;
;init_V:
; jsr  initStart
;                INIT_1_0_0_A
;                INIT_1_N_0_A
;                INIT_1_1_0
;                RTS
GameOver3d: 
                    DW       GameOver3d_0                 ; A list of all single vectorlists in this 
                    DW       GameOver3d_1                 ; E 
                    DW       GameOver3d_2                 ; G 
                    DW       GameOver3d_3                 ; M 
                    DW       GameOver3d_4                 ; O 
                    DW       GameOver3d_5                 ; R 
                    DW       GameOver3d_6                 ; V 
LETTER_SIZE         equ      100 
a_3d: 
GameOver3d_0: 
                    DW       $0000+LETTER_SIZE, _N_N_0    ; mode, y, x 
                    DW       $ff00+LETTER_SIZE, _1_0_0    ; mode, y, x 
                    DW       $0000+LETTER_SIZE, _0_1_0    ; mode, y, x 
                    DW       $0000+LETTER_SIZE, _0_1_0    ; mode, y, x 
                    DW       $ff00+LETTER_SIZE, _0_N_0    ; mode, y, x 
                    DW       $ff00+LETTER_SIZE, _0_N_0    ; mode, y, x 
                    DW       $ff00+LETTER_SIZE, _1_1_0    ; mode, y, x 
                    DW       $ff00+LETTER_SIZE, _N_1_0    ; mode, y, x 
                    DW       $ff00+LETTER_SIZE, _N_0_0    ; mode, y, x 
                    DB       $01                          ; endmarker (1) 
e_3d: 
GameOver3d_1: 
                    DW       $0000+LETTER_SIZE, _N_1_0    ; mode, y, x 
                    DW       $ff00+LETTER_SIZE, _0_N_0    ; mode, y, x 
                    DW       $ff00+LETTER_SIZE, _0_N_0    ; mode, y, x 
                    DW       $ff00+LETTER_SIZE, _1_0_0    ; mode, y, x 
                    DW       $ff00+LETTER_SIZE, _0_1_0    ; mode, y, x 
                    DW       $0000+LETTER_SIZE, _0_N_0    ; mode, y, x 
                    DW       $ff00+LETTER_SIZE, _1_0_0    ; mode, y, x 
                    DW       $ff00+LETTER_SIZE, _0_1_0    ; mode, y, x 
                    DW       $ff00+LETTER_SIZE, _0_1_0    ; mode, y, x 
                    DB       $01                          ; endmarker (1) 
g_3d: 
GameOver3d_2: 
                    DW       $0000+LETTER_SIZE, _N_N_0    ; mode, y, x 
                    DW       $ff00+LETTER_SIZE, _0_1_0    ; mode, y, x 
                    DW       $ff00+LETTER_SIZE, _0_1_0    ; mode, y, x 
                    DW       $ff00+LETTER_SIZE, _1_0_0    ; mode, y, x 
                    DW       $ff00+LETTER_SIZE, _0_N_0    ; mode, y, x 
                    DW       $ff00+LETTER_SIZE, _0_N_0    ; mode, y, x 
                    DW       $0000+LETTER_SIZE, _N_0_0    ; mode, y, x 
                    DW       $ff00+LETTER_SIZE, _1_0_0    ; mode, y, x 
                    DW       $ff00+LETTER_SIZE, _1_0_0    ; mode, y, x 
                    DW       $ff00+LETTER_SIZE, _0_1_0    ; mode, y, x 
                    DW       $ff00+LETTER_SIZE, _0_1_0    ; mode, y, x 
                    DB       $01                          ; endmarker (1) 
m_3d: 
GameOver3d_3: 
                    DW       $0000+LETTER_SIZE, _N_N_0    ; mode, y, x 
                    DW       $ff00+LETTER_SIZE, _1_0_0    ; mode, y, x 
                    DW       $ff00+LETTER_SIZE, _1_0_0    ; mode, y, x 
                    DW       $ff00+LETTER_SIZE, _N_1_0    ; mode, y, x 
                    DW       $ff00+LETTER_SIZE, _1_1_0    ; mode, y, x 
                    DW       $ff00+LETTER_SIZE, _N_0_0    ; mode, y, x 
                    DW       $ff00+LETTER_SIZE, _N_0_0    ; mode, y, x 
                    DB       $01                          ; endmarker (1) 
o_3d: 
GameOver3d_4: 
                    DW       $0000+LETTER_SIZE, _N_N_0    ; mode, y, x 
                    DW       $ff00+LETTER_SIZE, _1_0_0    ; mode, y, x 
                    DW       $ff00+LETTER_SIZE, _1_0_0    ; mode, y, x 
                    DW       $ff00+LETTER_SIZE, _0_1_0    ; mode, y, x 
                    DW       $ff00+LETTER_SIZE, _0_1_0    ; mode, y, x 
                    DW       $ff00+LETTER_SIZE, _N_0_0    ; mode, y, x 
                    DW       $ff00+LETTER_SIZE, _N_0_0    ; mode, y, x 
                    DW       $ff00+LETTER_SIZE, _0_N_0    ; mode, y, x 
                    DW       $ff00+LETTER_SIZE, _0_N_0    ; mode, y, x 
                    DB       $01                          ; endmarker (1) 
r_3d: 
GameOver3d_5: 
                    DW       $0000+LETTER_SIZE, _N_N_0    ; mode, y, x 
                    DW       $ff00+LETTER_SIZE, _1_0_0    ; mode, y, x 
                    DW       $ff00+LETTER_SIZE, _1_0_0    ; mode, y, x 
                    DW       $ff00+LETTER_SIZE, _0_1_0    ; mode, y, x 
                    DW       $ff00+LETTER_SIZE, _0_1_0    ; mode, y, x 
                    DW       $ff00+LETTER_SIZE, _N_N_0    ; mode, y, x 
                    DW       $ff00+LETTER_SIZE, _N_1_0    ; mode, y, x 
                    DB       $01                          ; endmarker (1) 
v_3d: 
GameOver3d_6: 
                    DW       $0000+LETTER_SIZE, _1_N_0    ; mode, y, x 
                    DW       $ff00+LETTER_SIZE, _N_0_0    ; mode, y, x 
                    DW       $ff00+LETTER_SIZE, _N_1_0    ; mode, y, x 
                    DW       $ff00+LETTER_SIZE, _1_1_0    ; mode, y, x 
                    DW       $ff00+LETTER_SIZE, _1_0_0    ; mode, y, x 
                    DB       $01                          ; endmarker (1) 
;***************************************************************************
;***************************************************************************
