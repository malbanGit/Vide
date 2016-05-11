; make sure there is enough time from calling this
; to do the next move/draw
RESET_0_REF    macro            ;Replacing Reset0Ref subroutine
        LDD   #0x00CC;
;        STB   <VIA_cntl         ;0x0C;
;        STA   <VIA_shift_reg    ;0x0A;
;        LDD   #0x0302;
;        CLR   <VIA_port_a       ;0x01;
;        STA   <VIA_port_b       ;0x00;
;        STB   <VIA_port_b       ;0x00;
;        STB   <VIA_port_b       ;0x00;
;        LDB   #0x01;
;        STB   <VIA_port_b       ;0x00;
;        LDB    #0x00CC;
        STB    <VIA_cntl         ;0x0C;
                endm            ;end of macro

_DP_TO_C8        macro
                 LDA     #$C8
                 TFR     A,DP
                 direct  $C8             ; pretty for optimizing to use a makro :-)
                 endm
;***************************************************************************
_DP_TO_D0        macro
                 LDA     #$D0
                 TFR     A,DP
                 direct  $D0             ; pretty for optimizing to use a makro :-)
                 endm

RESET_0_REF_D0          macro
        _DP_TO_D0
        RESET_0_REF
                        endm

RH_DRAW_VLC        macro
                 LDD     ,X++            ;
                 STA     $C823           ;
                 CLRA
_DRAW_VLA\?:
;                 STB     <VIA_port_a     ;Send Y to A/D
;                 STA     <VIA_port_b
                 STD     VIA_port_b
                 LDB     ,X+
                 INC     <VIA_port_b     ;Disable mux
                 STB     <VIA_port_a     ;Send X to A/D
                 DEC     <VIA_shift_reg  ;Put pattern in shift register
                 STA     <VIA_t1_cnt_hi  ;enable timer 1

                 LDB     ,X+             ; 6
                 DEC     $C823           ; 7
                 BEQ     _DRAW_END\?     ; 3 Go back for more points
                 LDA     #$40          ;B-reg = T1 interrupt bit
LF_1\?:
                 BITA    <VIA_int_flags  ;Wait for T1 to time out
                 BEQ     LF_1\?         ;
                 CLRA                    ;Wait a moment more
                 STA     <VIA_shift_reg  ;Clear shift register (blank output)
                 BRA     _DRAW_VLA\?     ; 3
_DRAW_END\?:
                 LDA     #$40          ;B-reg = T1 interrupt bit
LF_2\?:
                 BITA    <VIA_int_flags  ;Wait for T1 to time out
                 BEQ     LF_2\?         ;
                 CLRA                    ;Wait a moment more
                 STA     <VIA_shift_reg
; one more round
                 STD     VIA_port_b
                 LDB     ,X+
                 INC     <VIA_port_b     ;Disable mux
                 STB     <VIA_port_a     ;Send X to A/D
                 DEC     <VIA_shift_reg  ;Put pattern in shift register
                 STA     <VIA_t1_cnt_hi  ;enable timer 1

                 LDA     #$40          ;B-reg = T1 interrupt bit
LF_3\?:
                 BITA    <VIA_int_flags  ;Wait for T1 to time out
                 BEQ     LF_3\?
                 CLR     <VIA_shift_reg  ;Clear shift register (blank output)
                 endm

_RH_DRAW_VLC             macro           ;Replacing Draw_VLc subrutine
        LDA   ,x+
dvlc1\?:
        STA   $C823
        LDD   ,x
        STA   <VIA_port_a               ;0x01
        CLR   <VIA_port_b               ;0x00
        LEAX  2,x
        NOP
        INC   <VIA_port_b               ;0x00
        STB   <VIA_port_a               ;0x01
        LDD   #$FF00
dvlc2\?:
        STA   <VIA_shift_reg            ;0x0a
        STB   <VIA_t1_cnt_hi            ;0x05
        LDD   #$0040
dvlc3\?:
        BITB  <VIA_int_flags            ;0x0D
        BEQ   dvlc3\?
        STA   <VIA_shift_reg            ;0x0a
        LDA   $C823
        DECA
        BPL   dvlc1\?
        LDA   $C824
        BEQ   end_DRAW_VLC\?
        RESET_0_REF
end_DRAW_VLC\?:
                        endm

RH_DRAW_VLP             macro
dvlp1\?:
        LDD   1,x
        STA   <VIA_port_a
        CLR   <VIA_port_b
        LDA   ,x
        INC   <VIA_port_b
        STB   <VIA_port_a
        STA   <VIA_shift_reg
        CLR   <VIA_t1_cnt_hi

        LEAX  3,x
        LDA   ,x
        BGT   dvlpEnd\?
        LDD   #$0040
dvlp2\?:
        BITB  <VIA_int_flags
        BEQ   dvlp2\?
        STA   <VIA_shift_reg
        BRA   dvlp1\?
dvlpEnd\?:
        LDD   #$0040
dvlp3\?:
        BITB  <VIA_int_flags
        BEQ   dvlp3\?
        STA   <VIA_shift_reg
end_DRAW_VLP\?:
                        endm


RH_MOVE_TO_D            macro
                 local   LF33D
                 STA     <VIA_port_a     ;Store Y in D/A register
                 LDA     #$CE            ;Blank low, zero high?
                 STA     <VIA_cntl       ;
                 CLRA
                 STA     <VIA_port_b     ;Enable mux
                 STA     <VIA_shift_reg  ;Clear shift regigster
                 INC     <VIA_port_b     ;Disable mux
                 STB     <VIA_port_a     ;Store X in D/A register
                 STA     <VIA_t1_cnt_hi  ;enable timer
                 LDB     #$40            ;
LF33D:           BITB    <VIA_int_flags  ;
                 BEQ     LF33D           ;
                        endm
