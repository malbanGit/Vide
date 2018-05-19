                    BSS      
                    ORG      $c880                ; start of our ram space 

                    INCLUDE  "VECTREX.I"          ; vectrex function includes
                    INCLUDE  "3d_var.I"          ; vectrex function includes
                    INCLUDE  "3d_MAKRO.I"          ; vectrex function includes

;***************************************************************************
; HEADER SECTION
;***************************************************************************
; The cartridge ROM starts at address 0
                    CODE     
                    ORG      0 


                    INCLUDE  "3d_prg.I"          ; vectrex function includes


init_2d
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

 tst do000
 beq no0002d
                    INIT_0_0_0_A  
no0002d
 tst do010
 lbeq no0102d
                    INIT_0_1_0_A  
no0102d
 tst do100
 beq no1002d
                    INIT_1_0_0_A  
no1002d
 tst do110
 lbeq no1102d
                    INIT_1_1_0_A  
no1102d
 tst doN10
 lbeq noN102d
                    INIT_N_1_0_A  
noN102d
                    RTS     

init_all
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

DO_Z_KOORDINATE = 1
 tst do000
 beq no000
                    INIT_0_0_0_A  
no000
 tst do100
 beq no100
                    INIT_1_0_0_A  
no100
 tst do110
 lbeq no110
                    INIT_1_1_0_A  
no110
 tst do101
 lbeq no101
                    INIT_1_0_1_A  
no101
 tst do111
 lbeq no111
                    INIT_1_1_1_A  
no111
 tst do010
 lbeq no010
                    INIT_0_1_0_A  
no010
 tst do011
 lbeq no011
                    INIT_0_1_1_A  
no011
 tst do001
 lbeq no001
                    INIT_0_0_1_A  
no001
 tst doN10
 lbeq noN10
                    INIT_N_1_0_A  
noN10:
 tst doN01
 lbeq noN01
                    INIT_N_0_1_A  
noN01
 tst do0N1
 lbeq no0N1
                    INIT_0_N_1_A  
no0N1
 tst doN11
 lbeq noN11
                    INIT_N_1_1_A  
noN11
 tst do1N1
 lbeq no1N1
                    INIT_1_N_1_A  
no1N1
 tst do11N
 lbeq no11N
                    INIT_1_1_N_A  
no11N

				rts

