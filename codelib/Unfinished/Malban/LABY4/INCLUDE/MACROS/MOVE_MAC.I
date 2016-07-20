MOVE_TO_D            macro
                 direct  $d0             ; following code uses d0
                 local   LF33D
                 STA     VIA_port_a     ;Store Y in D/A register
                 LDA     #$CE            ;Blank low, zero high?
                 STA     VIA_cntl       ;
                 CLRA
                 STA     VIA_port_b     ;Enable mux
                 STA     VIA_shift_reg  ;Clear shift regigster
                 INC     VIA_port_b     ;Disable mux
                 STB     VIA_port_a     ;Store X in D/A register
                 STA     VIA_t1_cnt_hi  ;enable timer
                 LDB     #$40            ;
LF33D:           BITB    VIA_int_flags  ;
                 BEQ     LF33D           ;
                        endm

MOVE_TO_D_OPEN            macro
                 direct  $d0             ; following code uses d0
                 STA     VIA_port_a     ;Store Y in D/A register
                 LDA     #$CE            ;Blank low, zero high?
                 STA     VIA_cntl       ;
                 CLRA
                 STA     VIA_port_b     ;Enable mux
;                 STA     VIA_shift_reg  ;Clear shift regigster
                 INC     VIA_port_b     ;Disable mux
                 STB     VIA_port_a     ;Store X in D/A register
                 STA     VIA_t1_cnt_hi  ;enable timer
                        endm
