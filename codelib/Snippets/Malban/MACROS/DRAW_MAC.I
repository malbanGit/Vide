;***************************************************************************
DRAW_VLC        macro
                 direct  $d0             ; following code uses d0
                 LDD     ,X++            ;
                 STA     $C823           ;
                 CLRA
_DRAW_VLA\?:
                 STD     VIA_port_b
                 LDB     ,X+
                 INC     VIA_port_b     ;Disable mux
                 STB     VIA_port_a     ;Send X to A/D
                 DEC     VIA_shift_reg  ;Put pattern in shift register
                 STA     VIA_t1_cnt_hi  ;enable timer 1

                 LDB     ,X+             ; 6
                 DEC     $C823           ; 7
                 BEQ     _DRAW_END\?     ; 3 Go back for more points
                 LDA     #$40          ;B-reg = T1 interrupt bit
LF_1\?:
                 BITA    VIA_int_flags  ;Wait for T1 to time out
                 BEQ     LF_1\?         ;
                 CLRA                    ;Wait a moment more
                 STA     VIA_shift_reg  ;Clear shift register (blank output)
                 BRA     _DRAW_VLA\?     ; 3
_DRAW_END\?:
                 LDA     #$40          ;B-reg = T1 interrupt bit
LF_2\?:
                 BITA    VIA_int_flags  ;Wait for T1 to time out
                 BEQ     LF_2\?         ;
                 CLRA                    ;Wait a moment more
                 STA     VIA_shift_reg
; one more round
                 STD     VIA_port_b
                 LDB     ,X+
                 INC     VIA_port_b     ;Disable mux
                 STB     VIA_port_a     ;Send X to A/D
                 DEC     VIA_shift_reg  ;Put pattern in shift register
                 STA     VIA_t1_cnt_hi  ;enable timer 1

                 LDA     #$40          ;B-reg = T1 interrupt bit
LF_3\?:
                 BITA    VIA_int_flags  ;Wait for T1 to time out
                 BEQ     LF_3\?
                 CLR     VIA_shift_reg  ;Clear shift register (blank output)
                 endm
;***************************************************************************
DRAW_VLP             macro
                direct  $d0             ; following code uses d0
dvlp1\?:
        LDD   1,x
        STA   VIA_port_a
        CLR   VIA_port_b
        LDA   ,x
        INC   VIA_port_b
        STB   VIA_port_a
        STA   VIA_shift_reg
        CLR   VIA_t1_cnt_hi

        LEAX  3,x
        LDA   ,x
        BGT   dvlpEnd\?
        LDD   #$0040
dvlp2\?:
        BITB  VIA_int_flags
        BEQ   dvlp2\?
        STA   VIA_shift_reg
        BRA   dvlp1\?
dvlpEnd\?:
        LDD   #$0040
dvlp3\?:
        BITB  VIA_int_flags
        BEQ   dvlp3\?
        STA   VIA_shift_reg
end_DRAW_VLP\?:
                        endm
