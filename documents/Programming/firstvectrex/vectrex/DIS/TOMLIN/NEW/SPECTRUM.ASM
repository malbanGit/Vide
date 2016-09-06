; can be assembled correctly now
; corrected and compatibilty added by Malban
;
; assemble with comand line:
; .\ass\as09.exe -w200 -h0 -l -mcti alpha.asm >error
;
; used the 6809 assembler:
; as09 [1.11].
; Copyright 1990-1994, Frank A. Vorstenbosch, Kingswood Software.
; Available at:
; http://www.falstaff.demon.co.uk/cross.html
;
                     direct -1              ; disable use of dpr

D0000   FCC     "g GCE 1982"
        FCB     $80

        FDB     $FEC6

        FDB     $F850
        FDB     $20C0
        FCC     "SPECTRUM I+"
        FCB     $80

        FDB     $F850
        FDB     $F0A0
D0021   FCC     "g RA+A INC 1984"
        FCB     $80

        FCB     $00

L0032   LDS     #$CBEA
        CLR     $A000
        LDX     #$C883
L003C   CLR     ,X+
        CMPX    #$CBC5
        BNE     L003C
        INC     $C824   ;Vec_0Ref_Enable
        LDD     #$F848
        STD     $C82A   ;Vec_Text_Height
        CLR     $CBC7
        LDD     $CBEF
        CMPD    #$2030
        BNE     L0063
        STB     $CBEF
        LDB     $D000
        ANDB    #$40
        STB     $CBC6
L0063   JSR     L053C
L0066   LDS     #$CBEA
        LDD     #$8000
        STD     $CB71
        STB     $C8F8
        LDA     $C8C0
        STA     $C8BE
        BPL     L007E
        JSR     L028F
L007E   JSR     L029F
L0081   JSR     $F192   ;Wait_Recal
        JSR     L0365
        noopt
        LBNE    L00C1
        opt
        LDU     #$FE76  ;music
        JSR     L0256
        LDX     $C8C6
        LDA     $C88F
        INCA
        CMPA    #$4F
        BLT     L00A3
        LEAX    2,X
        STX     $C8C6
        SUBA    #$55
L00A3   STA     $C88F
        TFR     X,Y
        JSR     L02F5
        JSR     L02F5
        JSR     L02F5
        TST     $C892
        BEQ     L0081
        LDA     #$FF
        STA     $C89B
        JSR     L0475
        JMP     L0201

L00C1   CLR     $A000
        JSR     L028F
        CLR     $C89B
        CLR     $C8BE
        CLR     $C8F8
        TST     $CBC6
        BNE     L00E5
        LDA     $CBC7
        DECA
        TST     $C8EF
        BEQ     L00E2
        INCA
        SUBA    $87FE
L00E2   STA     $CBC7
L00E5   LDD     #$2000
        STD     $C891
        LDA     #$08
        STD     $C897
        STB     $C8C1
        LDA     #$80
        STD     $C88B
        LDX     #$C883
        STX     $C8C4
        TST     $CBC6
        BEQ     L0115
L0103   JSR     $F192   ;Wait_Recal
        LDU     #$FE38  ;music
        JSR     L0256
        CLRA
        JSR     $F1B4   ;Read_Btns_Mask
        TST     $C80F   ;Vec_Btn_State
        BNE     L0103
L0115   TST     $C897
        LBEQ    L0066
        LDA     $C898
        STA     $A000
        JSR     $F192   ;Wait_Recal
        JSR     L037A
        noopt
        LBNE    L00C1
        opt
        LDU     #$FE38  ;music
        JSR     L0256
        INC     $C88C
        LDA     $C88C
        BITA    #$20
        BNE     L0145
        LDD     #$7090
        LDU     #D0C16
        JSR     $F37A   ;Print_Str_d
L0145   LDY     #D0F52
        LDB     #$80
L014B   LDU     ,Y++
        PSHS    B,X,Y
        BITB    $C898
        BNE     L0165
        LDD     #$F160
        STD     $C82A   ;Vec_Text_Height
        LDD     14,Y
        JSR     $F37A   ;Print_Str_d
        LDD     #$F848
        STD     $C82A   ;Vec_Text_Height
L0165   PULS    B,X,Y
        LSRB
        BNE     L014B
        JSR     L041C
        BNE     L0115
        CLR     $A000
        LDX     #D0954
        STX     $C895
        LDX     #$C883
        LDY     #$C8B7
        STY     $C88F
L0183   LDD     ,X++
L0185   ASLA
        ASLA
        ASLA
        PSHS    B
        ORA     ,S+
        ASLA
        SUBA    #$02
        STA     ,Y+
        CMPX    #$C88B
        BCS     L0183
        CMPY    #$C8BB
        BNE     L01A2
        LDA     -8,X
        LDB     -1,X
        BRA     L0185

L01A2   JSR     L028F
        JSR     L04BE
        LDA     #$80
        STA     $C896
L01AD   JSR     $F192   ;Wait_Recal
        JSR     L037A
        LBNE    L00C1
        LDU     #$FE76  ;music
        JSR     L0256
        LDU     #D0BC0
        LDD     #$4088
        JSR     $F37A   ;Print_Str_d
        LDX     #$C883
        LDA     #$10
L01CB   LDB     #$80
        STA     $C898
L01D0   LDU     #D0F52
        LDA     ,X+
        BMI     L01F3
        ANDA    #$07
        ASLA
        LDU     A,U
        PSHS    B,X
        LDA     $C898
        JSR     $F37A   ;Print_Str_d
        PULS    B,X
        ADDB    #$55
        CMPB    #$7F
        BNE     L01D0
        LDA     $C898
        SUBA    #$20
        BRA     L01CB

L01F3   LDU     #D0E8D
        LDD     #$B088
        JSR     $F37A   ;Print_Str_d
        DEC     $C896
        BNE     L01AD
L0201   JSR     $F192   ;Wait_Recal
        JSR     L0365
        LBNE    L00C1
        LDU     #$FE76  ;music
        JSR     L0256
        LDX     $C893
        LDA     $C88F
        CMPA    #$20
        BLS     L0228
        LDU     ,X++
        LBEQ    L0066
        STX     $C893
        CLRA
        STA     $C88F
L0228   ADDA    #$60
        LDB     #$05
L022C   SUBA    #$20
L022E   LDU     ,X++
        BEQ     L0241
        TST     ,U
        BMI     L0241
        PSHS    D,X
        LDB     #$90
        JSR     $F37A   ;Print_Str_d
        PULS    D,X
        BMI     L022E
L0241   DECB
        BNE     L022C
        LDA     $C8EF
        ANDA    $87FF
        BNE     L0251
        COM     $C891
        BEQ     L0201
L0251   INC     $C88F
        BRA     L0201

L0256   TST     $C8F8
        BEQ     L0268
        DEC     $C8F8
        BEQ     L0270
        JSR     $F1AA   ;DP_to_D0
        JSR     $ED0A
        BRA     L0286

L0268   TST     $C856   ;Vec_Music_Flag
        BNE     L027A
        DEC     $C897
L0270   BSR     L028F
        TST     $C8BE
        BMI     L0286
        INC     $C856   ;Vec_Music_Flag
L027A   JSR     $F1AF   ;DP_to_C8
        JSR     $F687   ;Init_Music_chk
        JSR     $F1AA   ;DP_to_D0
        JSR     $F289   ;Do_Sound
L0286   JSR     $F1AA   ;DP_to_D0
        JSR     $F2A9   ;Intensity_7F
        JMP     $F2E6   ;Recalibrate

L028F   PSHS    U
        JSR     $F1AF   ;DP_to_C8
        JSR     $F742
        JSR     $F1AA   ;DP_to_D0
        JSR     $F272   ;Clear_Sound
        PULS    U,PC

L029F   LDD     #$2900
        STD     $C88F
        STB     $C891
        STB     $C892
        LDX     #$C900
        STX     $C8C6
        LDD     #$0000
        STD     ,X++
        STD     ,X++
        TST     $C8EF
        BNE     L02CC
L02BD   LDU     #D0E2B
        STU     ,X++
        STU     ,X++
        STU     ,X++
        STU     ,X++
        STU     ,X++
        BRA     L02EA

L02CC   LDU     #$876D
        LDD     #$2020
L02D2   CMPD    ,U
        BNE     L02DC
        CMPD    2,U
        BEQ     L02DE
L02DC   STU     ,X++
L02DE   LEAU    7,U
        CMPU    #$87F9
        BCS     L02D2
        LDD     -2,X
        BEQ     L02BD
L02EA   LDD     #$0000
        STD     ,X++
        STD     ,X++
        COMA
        STD     ,X++
        RTS

L02F5   PSHS    D,X,Y
        LDU     ,Y
        BEQ     L035E
        CMPU    #$FF00
        BCC     L035B
        CMPA    #$80
        BEQ     L035E
        CMPA    #$4F
        BGT     L035E
        STA     $C893
        LDD     #$8806
L030F   STA     $C894
        PSHS    D
        LDA     ,U+
        PSHS    U
        LDX     #D0FC8
        CMPA    #$24
        BEQ     L033E
        LDX     #D0FDA
        CMPA    #$2E
        BEQ     L033E
        SUBA    #$30
        BMI     L0350
        CMPA    #$09
        BLS     L0338
        SUBA    #$07
        CMPA    #$0A
        BLT     L0350
        CMPA    #$24
        BCC     L0350
L0338   ASLA
        LDX     #D0F72
        LDX     A,X
L033E   LDD     ,X++
        PSHS    X
        ADDB    $C894
        ADDA    $C893
        JSR     $F2FC   ;Moveto_d_7F
        PULS    X
        JSR     $F3D6   ;Draw_VLcs
L0350   PULS    U
        PULS    D
        ADDA    #$2A
        DECB
        BNE     L030F
        BRA     L035E

L035B   STU     $C892
L035E   PULS    D,X,Y
        SUBA    #$55
        LEAY    2,Y
        RTS

L0365   PSHS    D,X,Y,U
        TST     $CBC6
        BEQ     L0381
        CLRA
        JSR     $F1B4   ;Read_Btns_Mask
        TST     $C80F   ;Vec_Btn_State
        LBEQ    L0400
        JMP     L03D9

L037A   PSHS    D,X,Y,U
        TST     $CBC6
        BNE     L0400
L0381   TST     $CBC7
        BEQ     L0393
        TST     $C8EF
        BEQ     L03D9
        LDA     $87FE
        CMPA    $CBC7
        BLS     L03D9
L0393   LDX     #$0000
        LDB     #$40
L0398   LEAX    1,X
        BEQ     L03E2
        BITB    $D000
        BNE     L0398
        CMPX    #$0001
        BEQ     L0400
        LDX     #$CBEB
        LDA     #$01
        JSR     $F85E   ;Add_Score_a
        LDX     #$CBEB
        LDY     #$8002
        JSR     L05D2
        INC     $CBC7
        CLRA
        JSR     $F1B4   ;Read_Btns_Mask
        LDA     $C80F   ;Vec_Btn_State
        CMPA    #$88
        LBEQ    $F000   ;Cold_Start
        CMPA    #$70
        BEQ     L03ED
        TST     $C8EF
        BEQ     L03D9
        LDA     $87FE
        CMPA    $CBC7
        BHI     L0400
L03D9   LDD     #$0000
        STD     $CB71
        COMA
        BRA     L0401

L03E2   CLRA
        JSR     $F1B4   ;Read_Btns_Mask
        LDA     $C80F   ;Vec_Btn_State
        CMPA    #$80
        BNE     L0400
L03ED   CLRA
        JSR     $F1B4   ;Read_Btns_Mask
        LDA     $C80F   ;Vec_Btn_State
        BMI     L03ED
        CMPA    #$70
        BNE     L0400
L03FA   JSR     L057F
        JMP     L0066

L0400   CLRA
L0401   PSHS    CC
        ORCC    #$01
        LDD     $CB71
        BEQ     L041A
        INCB
        ANDB    #$7F
        BEQ     L0414
        LSRA
        BNE     L0414
        LDA     #$80
L0414   STD     $CB71
        STA     $A000
L041A   PULS    CC,D,X,Y,U,PC

L041C   CLRA
        JSR     $F1B4   ;Read_Btns_Mask
        TST     $CBC6
        BEQ     L043E
        TST     $C898
        BPL     L043E
        LDA     $D000
        BITA    #$40
        BNE     L043E
        LDA     $C80F   ;Vec_Btn_State
        CMPA    #$11
        LBEQ    $F000   ;Cold_Start
        CMPA    #$70
        BEQ     L03FA
L043E   LDD     #$0080
L0441   BITB    $C898
        BNE     L045D
        BITB    $C80F   ;Vec_Btn_State
        BEQ     L045D
        LDX     $C8C4
        STA     ,X+
        STX     $C8C4
        ORB     $C898
        STB     $C898
        BSR     L0463
        BRA     L0461

L045D   INCA
        LSRB
        BNE     L0441
L0461   COMB
        RTS

L0463   PSHS    D,X,Y,U
        LDU     #$ED5A
        LDA     #$10
        STA     $C8F8
        JSR     $F1AA   ;DP_to_D0
        JSR     $ED07
        PULS    D,X,Y,U,PC

L0475   LDX     #$C900
        STX     $C893
        LDU     #D0BD5
        STU     ,X++
        STU     ,X++
        STU     ,X++
        LDU     #D0930
        LDY     #D08DA
        TST     $C8EE
        BEQ     L04A3
        LDU     #$8073
L0493   CMPU    $CB81
        BCC     L04A0
        STU     ,X++
        LEAU    $15,U
        BRA     L0493

L04A0   LDU     #D0930
L04A3   STU     $C891
L04A6   LDU     ,Y++
        STU     ,X++
        CMPY    $C891
        BNE     L04A6
        LDY     #D093A
        TST     $C8EE
        LBEQ    L052B
        JMP     L0527

L04BE   LDX     #$C900
        STX     $C893
        LDU     #D0BD5
        STU     ,X++
        STU     ,X++
        STU     ,X++
        STU     ,X++
        STX     $C891
L04D2   LDX     $C88F
        CMPX    #$C8BB
        BHI     L0501
        LDA     ,X+
        STX     $C88F
        LDX     $C895
        LDY     A,X
        LEAX    $7C,X
        STX     $C895
        LDX     $C891
L04EE   STY     ,X++
L04F1   TST     ,Y+
        BPL     L04F1
        TST     ,Y
        BPL     L04EE
        STY     ,X++
        STX     $C891
        BRA     L04D2

L0501   LDX     $C891
        TST     $C8F0
        BEQ     L0519
        LDU     #$800A
L050C   CMPU    $CB83
        BCC     L0519
        STU     ,X++
        LEAU    $15,U
        BRA     L050C

L0519   LDY     #D092E
L051D   LDU     ,Y++
        STU     ,X++
        CMPY    #D093A
        BNE     L051D
L0527   LDY     #D0946
L052B   LDU     ,Y++
        STU     ,X++
        CMPY    #D0954
        BNE     L052B
        STU     $C88F
        STU     $C891
        RTS

L053C   LDB     #$A5
        STB     $8000
        COM     $8000
        COMB
        CMPB    $8000
        LBNE    L05DE
        LDB     $87FE
        BEQ     L0555
        CMPB    #$08
        BLS     L055A
L0555   LDB     #$01
        STB     $87FE
L055A   LDB     #$07
        STB     $C8EF
        CMPA    #$20
        BNE     L0589
        CLRA
        JSR     $F1B4   ;Read_Btns_Mask
        LDA     $C80F   ;Vec_Btn_State
        CMPA    #$80
        BNE     L0589
L056E   CLRA
        JSR     $F1B4   ;Read_Btns_Mask
        LDA     $C80F   ;Vec_Btn_State
        BMI     L056E
        CMPA    #$06
        BEQ     L057F
        CMPA    #$19
        BNE     L0589
L057F   TST     $C8EF
        LBEQ    L05DE
        JSR     L0602
L0589   LDU     #$8073
        CLRA
        PSHS    A,U
        LDX     #$800A
        BSR     L05DF
        PULS    A,U
        STA     $C8F0
        STX     $CB83
        LDX     #$876C
        CLRA
        PSHS    A,X
        TFR     U,X
        BSR     L05DF
        PULS    A,U
        STA     $C8EE
        STX     $CB81
        LDA     $87FF
        STA     $C8C0
        LDX     #$8002
        LDB     #$05
L05B9   LDA     B,X
        CMPA    #$20
        BEQ     L05CB
        CMPA    #$30
        BCS     L05C7
        CMPA    #$39
        BLS     L05CB
L05C7   LDX     #D0FC2
        CLRB
L05CB   DECB
        BPL     L05B9
        LDY     #$CBEB
L05D2   LDD     ,X++
        STD     ,Y++
        LDD     ,X++
        STD     ,Y++
        LDD     ,X++
        STD     ,Y++
L05DE   RTS

L05DF   TFR     X,Y
        LDB     #$14
L05E3   LDA     ,Y+
        CMPA    #$5F
        BHI     L0601
        CMPA    #$20
        BCS     L0601
        BNE     L05F3
        DECB
        BNE     L05E3
        RTS

L05F3   TST     $14,X
        BPL     L0601
        INC     2,S
        LEAX    $15,X
        CMPX    3,S
        BCS     L05DF
L0601   RTS

L0602   CLR     $A000
        PSHS    A
L0607   CLRA
        JSR     $F1B4   ;Read_Btns_Mask
        TST     $C80F   ;Vec_Btn_State
        BNE     L0607
        PULS    B
        SUBB    #$06
        BEQ     L063A
        LDX     #$876D
        STX     $CB81
        LDX     #$87F9
        STX     $CB83
        LDX     #D0F4C
        STX     $C8DA
        LDA     #$06
        STA     $C8B7
        LDA     #$23
        STA     $C8B8
        LDA     #$07
        STA     $C8B9
        JSR     L070F
L063A   CLR     $87FF
L063D   CLRA
        JSR     $F1B4   ;Read_Btns_Mask
        LDA     $C80F   ;Vec_Btn_State
        BNE     L063D
L0646   JSR     $F192   ;Wait_Recal
        LDU     #$FDD3  ;music
        JSR     L0256
        JSR     $F2E6   ;Recalibrate
        LDD     #$3090
        LDU     #D0F28
        JSR     $F37A   ;Print_Str_d
        LDD     #$1090
        LDU     #D0F30
        JSR     $F37A   ;Print_Str_d
        CLRA
        JSR     $F1B4   ;Read_Btns_Mask
        LDA     $C80F   ;Vec_Btn_State
        BEQ     L0646
        BPL     L0674
        LDA     #$07
        STA     $87FF
L0674   CLRA
        JSR     $F1B4   ;Read_Btns_Mask
        LDA     $C80F   ;Vec_Btn_State
        BNE     L0674
L067D   JSR     $F192   ;Wait_Recal
        LDU     #$FDD3  ;music
        JSR     L0256
        JSR     $F2E6   ;Recalibrate
        LDD     #$3090
        LDU     #D0F04
        JSR     $F37A   ;Print_Str_d
        LDD     #$1090
        LDU     #D0F16
        JSR     $F37A   ;Print_Str_d
        CLRA
        JSR     $F1B4   ;Read_Btns_Mask
        LDA     $C80F   ;Vec_Btn_State
        BEQ     L067D
        ANDA    #$80
        ORA     $87FF
        STA     $87FF
L06AC   CLRA
        JSR     $F1B4   ;Read_Btns_Mask
        LDA     $C80F   ;Vec_Btn_State
        BNE     L06AC
        TST     $CBC6
        BNE     L06EE
L06BA   JSR     $F192   ;Wait_Recal
        LDU     #$FDD3  ;music
        JSR     L0256
        JSR     $F2E6   ;Recalibrate
        LDD     #$1090
        LDU     #D0F44
        JSR     $F37A   ;Print_Str_d
        CLRA
        JSR     $F1B4   ;Read_Btns_Mask
        LDA     $C80F   ;Vec_Btn_State
        BEQ     L06BA
        LDX     #D0FB9
L06DB   LEAX    1,X
        ASLA
        BCC     L06DB
        LDA     ,X
        STA     $87FE
L06E5   CLRA
        JSR     $F1B4   ;Read_Btns_Mask
        LDA     $C80F   ;Vec_Btn_State
        BNE     L06E5
L06EE   LDX     #$800A
        STX     $CB81
        LDX     #$876C
        STX     $CB83
        LDX     #D089E
        STX     $C8DA
        LDA     #$14
        STA     $C8B7
        LDA     #$69
        STA     $C8B8
        LDA     #$15
        STA     $C8B9
L070F   CLR     $C88F
        CLR     $C890
        CLR     $C897
        LDX     $CB83
        TFR     X,Y
L071D   TST     ,-Y
        BPL     L0739
        LDB     $C8B7
L0724   LDA     ,-Y
        CMPA    #$20
        BCS     L0739
        CMPA    #$5F
        BHI     L0739
        DECB
        BNE     L0724
        CMPY    $CB81
        BNE     L071D
        BRA     L074C

L0739   LDA     #$80
        STA     ,-X
        LDA     #$20
        LDB     $C8B7
L0742   STA     ,-X
        DECB
        BNE     L0742
        CMPX    $CB81
        BNE     L0739
L074C   LDU     $CB81
        STU     $C8F9
        STU     $C891
        LDA     $C8B8
        LEAU    A,U
        STU     $C8FB
        CLR     $C8BC
L0760   JSR     $F192   ;Wait_Recal
        LDU     #$FDD3  ;music
        JSR     L0256
        LDA     [$C891]
        PSHS    A
        LDA     $C8BC
        ADDA    #$40
        STA     $C8BC
        BNE     L077F
        LDA     #$6D
        STA     [$C891]
L077F   LDD     #$5090
        LDU     $C8F9
        CMPU    $CB81
        BNE     L0798
        PSHS    D,U
        LDU     $C8DA
        LDD     #$7090
        JSR     $F37A   ;Print_Str_d
        PULS    D,U
L0798   PSHS    D
        PSHS    U
        JSR     $F37A   ;Print_Str_d
        PULS    U
        LDB     $C8B9
        LEAU    B,U
        PULS    D
        SUBA    #$20
        CMPU    $C8FB
        BCS     L0798
        PULS    A
        STA     [$C891]
        CLRA
        JSR     $F1B4   ;Read_Btns_Mask
        LDB     $C80F   ;Vec_Btn_State
        BEQ     L07CA
        JSR     L0463
        STB     $C890
        STB     $A000
        BRA     L0760

L07CA   LDA     $C890
        BEQ     L0760
        CLR     $C890
        LDB     #$10
L07D4   DECB
        ASLA
        BCC     L07D4
        TST     $C88F
        BNE     L07E6
        ASLB
        ASLB
        ASLB
        STB     $C88F
        JMP     L0760

L07E6   ANDB    #$07
        ORB     $C88F
        ANDB    #$3F
        CLR     $A000
        CLR     $C88F
        LDA     $C897
        STD     $C896
        LDU     $C891
        CMPB    #$38
        BCC     L084A
        LDY     #D08A2
        LDB     B,Y
        STB     ,U+
L0808   LDA     ,U+
        BMI     L0808
        LEAU    -1,U
        CMPU    $C8F9
        BCC     L0827
        CMPU    $CB81
        LBCS    L074C
        LDU     $C8F9
        LDB     $C8B8
        NEGB
        LEAU    B,U
        BRA     L0838

L0827   CMPU    $C8FB
        BCS     L0844
        CMPU    $CB83
        LBCC    L074C
        LDU     $C8FB
L0838   STU     $C8F9
        LDB     $C8B8
        LEAY    B,U
        STY     $C8FB
L0844   STU     $C891
        JMP     L0760

L084A   CMPB    #$3F
        BNE     L0856
        CMPB    $C896
        LBNE    L0760
        RTS

L0856   CMPB    #$3E
        LBEQ    L074C
        CMPB    #$3D
        BNE     L0864
        LEAU    1,U
        BRA     L089B

L0864   CMPB    #$3C
        BNE     L086C
        LEAU    -1,U
        BRA     L089B

L086C   CMPB    #$3B
        BNE     L0877
        LDB     $C8B9
        LEAU    B,U
        BRA     L089B

L0877   CMPB    #$3A
        BNE     L0883
        LDB     $C8B9
        NEGB
        LEAU    B,U
        BRA     L089B

L0883   CMPB    #$39
        BNE     L088D
L0887   LDA     ,U+
        BPL     L0887
        BRA     L089B

L088D   CMPU    $CB81
        BEQ     L089B
        LDA     ,-U
        BMI     L089B
        LDA     #$20
        STA     ,U
L089B   JMP     L0808

D089E   FCC     "ADS"
        FCB     $80

D08A2   FCC     "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ !"
        FCB     '"'
        FCC     "#$"
        FCC     "%&'()*+,-."
        FCB     '"'
        FCC     ":;?="

D08DA   FDB     D0BD5
        FDB     D0BC0
        FDB     D0BD6
        FDB     D0BD5
        FDB     D0BED
        FDB     D0C00
        FDB     D0C16
        FDB     D0C2A
        FDB     D0C41
        FDB     D0C57
        FDB     D0C6B
        FDB     D0C7A
        FDB     D0C8C
        FDB     D0CA0
        FDB     D0CB1
        FDB     D0CC5
        FDB     D0CD8
        FDB     D0BD5
        FDB     D0BC0
        FDB     D0CE8
        FDB     D0CFE
        FDB     D0D14
        FDB     D0D29
        FDB     D0D3D
        FDB     D0D53
        FDB     D0D69
        FDB     D0D7F
        FDB     D0BD5
        FDB     D0D8B
        FDB     D0D9F
        FDB     D0DB3
        FDB     D0DC7
        FDB     D0DD8
        FDB     D0BD5
        FDB     D0DE6
        FDB     D0DF6
        FDB     D0E08
        FDB     D0E19
        FDB     D0BD5
        FDB     D0E2A
        FDB     D0E3B
        FDB     D0E4C

D092E   FDB     D0BD5
D0930   FDB     D0E9F
        FDB     D0EB2
        FDB     D0EC4
        FDB     D0ED2
        FDB     D0BD5

D093A   FDB     D0E57
        FDB     D0E63
        FDB     D0E70
        FDB     D0E7C
        FDB     D0E89
        FDB     D0E8B

D0946   FDB     D0BD5
        FDB     D0021
        FDB     $0000
        FDB     $0000
        FDB     $0000
        FDB     $0000
        FDB     $0000

D0954   FDB     D113A
        FDB     D11B6
        FDB     D109D
        FDB     D10F2
        FDB     D1000
        FDB     D1066
        FDB     D122E
        FDB     D1CD9
        FDB     D0BD5
        FDB     D1E4D
        FDB     D1DC3
        FDB     D1E0F
        FDB     D1D1E
        FDB     D1D7B
        FDB     D1E94
        FDB     D1F05
        FDB     D208C
        FDB     D0BD5
        FDB     D1FE7
        FDB     D2036
        FDB     D1F40
        FDB     D1F98
        FDB     D20D2
        FDB     D17D8
        FDB     D1990
        FDB     D19E2
        FDB     D0BD5
        FDB     D1913
        FDB     D1841
        FDB     D18A0
        FDB     D1A3F
        FDB     D1A70
        FDB     D1BD5
        FDB     D1C21
        FDB     D1B89
        FDB     D0BD5
        FDB     D1AC8
        FDB     D1B11
        FDB     D1C8F
        FDB     D127C
        FDB     D13EC
        FDB     D147D
        FDB     D133A
        FDB     D137E
        FDB     D0BD5
        FDB     D12E4
        FDB     D14F6
        FDB     D1540
        FDB     D16B3
        FDB     D1739
        FDB     D15D7
        FDB     D1634
        FDB     D1585
        FDB     D0BD5
        FDB     D1787
        FDB     D2113
        FDB     D22C7
        FDB     D230E
        FDB     D21EE
        FDB     D2271
        FDB     D2158
        FDB     D21B5
        FDB     D253D
        FDB     D2593
        FDB     D245F
        FDB     D24D7
        FDB     D2394
        FDB     D23ED
        FDB     D25EA
        FDB     D30CF
        FDB     D0BD5
        FDB     D32BF
        FDB     D3221
        FDB     D3278
        FDB     D313C
        FDB     D31A9
        FDB     D332A
        FDB     D337E
        FDB     D356C
        FDB     D0BD5
        FDB     D34C0
        FDB     D3511
        FDB     D33F1
        FDB     D3458
        FDB     D359A
        FDB     D2BB5
        FDB     D2D5B
        FDB     D2DC5
        FDB     D0BD5
        FDB     D2CDD
        FDB     D2C07
        FDB     D2C6D
        FDB     D2E33
        FDB     D2E81
        FDB     D2FB1
        FDB     D3024
        FDB     D2F5B
        FDB     D0BD5
        FDB     D2EC0
        FDB     D2F1F
        FDB     D305E
        FDB     D2662
        FDB     D2810
        FDB     D287E
        FDB     D272C
        FDB     D279C
        FDB     D0BD5
        FDB     D26E3
        FDB     D28D0
        FDB     D2936
        FDB     D2A89
        FDB     D2AD4
        FDB     D29D9
        FDB     D2A3D
        FDB     D2985
        FDB     D0BD5
        FDB     D2B4D
        FDB     D3604
        FDB     D37EE
        FDB     D3863
        FDB     D3725
        FDB     D3780
        FDB     D3665
        FDB     D36B5
        FDB     D3A38
        FDB     D3A9E
        FDB     D395A
        FDB     D39D2
        FDB     D388B
        FDB     D38EC
        FDB     D3AEA
        FDB     D456F
        FDB     D0BD5
        FDB     D473A
        FDB     D46A2
        FDB     D46F9
        FDB     D45E2
        FDB     D4652
        FDB     D478B
        FDB     D47F7
        FDB     D49DD
        FDB     D0BD5
        FDB     D493D
        FDB     D499F
        FDB     D4843
        FDB     D48BF
        FDB     D4A2F
        FDB     D407C
        FDB     D41FD
        FDB     D4254
        FDB     D0BD5
        FDB     D419F
        FDB     D40DF
        FDB     D4126
        FDB     D42B6
        FDB     D431F
        FDB     D44B4
        FDB     D44F5
        FDB     D4456
        FDB     D0BD5
        FDB     D4385
        FDB     D4408
        FDB     D4533
        FDB     D3B4E
        FDB     D3CF1
        FDB     D3D61
        FDB     D3C11
        FDB     D3C6E
        FDB     D0BD5
        FDB     D3BB5
        FDB     D3DDD
        FDB     D3E01
        FDB     D3F4F
        FDB     D3F9F
        FDB     D3EBA
        FDB     D3F01
        FDB     D3E5E
        FDB     D0BD5
        FDB     D401D
        FDB     D4A80
        FDB     D4C0C
        FDB     D4C78
        FDB     D4B67
        FDB     D4BD0
        FDB     D4AE4
        FDB     D4B08
        FDB     D4EE7
        FDB     D4F50
        FDB     D4DFB
        FDB     D4E62
        FDB     D4CC9
        FDB     D4D51
        FDB     D4FF0
        FDB     D5FB4
        FDB     D0BD5
        FDB     D625F
        FDB     D6125
        FDB     D61C1
        FDB     D601D
        FDB     D6091
        FDB     D62DB
        FDB     D632A
        FDB     D65EE
        FDB     D0BD5
        FDB     D64D5
        FDB     D6560
        FDB     D63CA
        FDB     D6459
        FDB     D666A
        FDB     D57B6
        FDB     D5A10
        FDB     D5AAC
        FDB     D0BD5
        FDB     D5973
        FDB     D581D
        FDB     D58AA
        FDB     D5B37
        FDB     D5BD6
        FDB     D5DF0
        FDB     D5E8E
        FDB     D5D53
        FDB     D0BD5
        FDB     D5C5B
        FDB     D5CE5
        FDB     D5F1C
        FDB     D503F
        FDB     D522F
        FDB     D52A3
        FDB     D5118
        FDB     D51A5
        FDB     D0BD5
        FDB     D50CD
        FDB     D5335
        FDB     D53E0
        FDB     D560C
        FDB     D56A0
        FDB     D54D5
        FDB     D559E
        FDB     D548A
        FDB     D0BD5
        FDB     D571C
        FDB     D66DC
        FDB     D69A7
        FDB     D69F6
        FDB     D6870
        FDB     D690F
        FDB     D672B
        FDB     D67D6
        FDB     D6C43
        FDB     D6CC3
        FDB     D6B58
        FDB     D6BD2
        FDB     D6A68
        FDB     D6AD6
        FDB     D6D00
        FDB     D771C
        FDB     D0BD5
        FDB     D785C
        FDB     D77AF
        FDB     D7814
        FDB     D774D
        FDB     D7783
        FDB     D78A5
        FDB     D7914
        FDB     D7B1D
        FDB     D0BD5
        FDB     D7A5D
        FDB     D7AB1
        FDB     D7980
        FDB     D7A01
        FDB     D7B70
        FDB     D729D
        FDB     D740E
        FDB     D7454
        FDB     D0BD5
        FDB     D739B
        FDB     D7301
        FDB     D7341
        FDB     D749E
        FDB     D74CE
        FDB     D763A
        FDB     D769E
        FDB     D75C6
        FDB     D0BD5
        FDB     D751D
        FDB     D756C
        FDB     D76CB
        FDB     D6D81
        FDB     D6F1D
        FDB     D6F6D
        FDB     D6E42
        FDB     D6EA8
        FDB     D0BD5
        FDB     D6DD9
        FDB     D6FE0
        FDB     D7057
        FDB     D71B5
        FDB     D7223
        FDB     D70E5
        FDB     D7144
        FDB     D707C
        FDB     D0BD5
        FDB     D7275
        FDB     D7BEB
        FDB     D7DED
        FDB     D7E34
        FDB     D7D25
        FDB     D7DB1
        FDB     D7C43
        FDB     D7CB6

D0BC0   FCC     "YOUR CHOICE OF COLORS"
D0BD5   FCB     $80
D0BD6   FCC     "PROJECTS THE REAL YOU!"
        FCB     $80
D0BED   FCC     "DISCOVER HOW COLOR"
        FCB     $80
D0C00   FCC     "AFFECTS YOUR LIFE ..."
        FCB     $80
D0C16   FCC     "CHOOSE ALL 8 COLORS"
        FCB     $80
D0C2A   FCC     "AND THE COMPUTER WILL:"
        FCB     $80
D0C41   FCC     " ACCURATELY DETERMINE"
        FCB     $80
D0C57   FCC     "  YOUR MOOD NOW ..."
        FCB     $80
D0C6B   FCC     " DESCRIBE YOUR"
        FCB     $80
D0C7A   FCC     "  PERSONALITY ..."
        FCB     $80
D0C8C   FCC     " WARN YOU OF STRESS"
        FCB     $80
D0CA0   FCC     "  CONDITIONS ..."
        FCB     $80
D0CB1   FCC     " AND OFTEN TELL YOU"
        FCB     $80
D0CC5   FCC     "  OF RECENT EVENTS"
        FCB     $80
D0CD8   FCC     "  IN YOUR LIFE!"
        FCB     $80
D0CE8   FCC     "AFFECTS YOUR LIFE ..."
        FCB     $80
D0CFE   FCC     "AND MINOR DIFFERENCES"
        FCB     $80
D0D14   FCC     " SHOW SUBTLE CHANGES"
        FCB     $80
D0D29   FCC     " IN YOU. WITH MAJOR"
        FCB     $80
D0D3D   FCC     " SHIFTS IN SELECTIONS"
        FCB     $80
D0D53   FCC     " ... COMPUTER REVEALS"
        FCB     $80
D0D69   FCC     " DEEP AND INFORMATIVE"
        FCB     $80
D0D7F   FCC     " KNOWLEDGE."
        FCB     $80
D0D8B   FCC     " SELECT YOUR COLORS"
        FCB     $80
D0D9F   FCC     " OFTEN ... YOU WILL"
        FCB     $80
D0DB3   FCC     " BE AMAZED WITH THE"
        FCB     $80
D0DC7   FCC     " ACCURACY OF THE"
        FCB     $80
D0DD8   FCC     " SPECTRUM I+!"
        FCB     $80
D0DE6   FCC     " THERE ARE OVER"
        FCB     $80
D0DF6   FCC     " 41,000 DIFFERENT"
        FCB     $80
D0E08   FCC     " COMBINATIONS OF"
        FCB     $80
D0E19   FCC     " THESE 8 COLORS!"
        FCB     $80
D0E2A   FCB     $20

D0E2B   FCC     "COLOR BLINDNESS"
        FCB     $80
D0E3B   FCC     " DOES NOT CHANGE"
        FCB     $80
D0E4C   FCC     " THE TEST!"
        FCB     $80

D0E57   FCC     " EVERYTHING"
        FCB     $80
D0E63   FCC     " IS GREAT AT"
        FCB     $80
D0E70   FCC     " THE NEARBY"
        FCB     $80
D0E7C   FCC     " BUSINESSES."
        FCB     $80
D0E89   FCC     " "
        FCB     $80
D0E8B   FCC     " "
        FCB     $80
D0E8D   FCC     "SUGGESTS THAT ..."
        FCB     $80

D0E9F   FCC     "YOUR COLOR CHOICES"
        FCB     $80
D0EB2   FCC     "WILL BE DIFFERENT"
        FCB     $80
D0EC4   FCC     "LATER, SO TRY"
        FCB     $80
D0ED2   FCC     "AGAIN THEN!"
        FCB     $80

D0EDE   FCC     "BLUE"
        FCB     $80
D0EE3   FCC     "BROWN"
        FCB     $80
D0EE9   FCC     "BLACK"
        FCB     $80
D0EEF   FCC     "YELLOW"
        FCB     $80
D0EF6   FCC     "VIOLET"
        FCB     $80
D0EFD   FCC     "ORANGE"
        FCB     $80

D0F04   FCC     "CONTINUOUS MUSIC:"
        FCB     $80
D0F16   FCC     "NO=BLUE,YES="

D0F22   FCC     "GREEN"
        FCB     $80

D0F28   FCC     "SCROLL:"
        FCB     $80
D0F30   FCC     "FAST=BLUE,SLOW="

D0F3F   FCC     "GRAY"
        FCB     $80

D0F44   FCC     "# COINS"
        FCB     $80
D0F4C   FCC     "WORDS"
        FCB     $80

D0F52   FDB     D0EDE
        FDB     D0EE3
        FDB     D0EE9
        FDB     D0EEF
        FDB     D0EF6
        FDB     D0F22
        FDB     D0EFD
        FDB     D0F3F

        FCB     $18
        FCB     $A0
        FCB     $40
        FCB     $C0
        FCB     $40
        FCB     $10
        FCB     $18
        FCB     $30
        FCB     $E8
        FCB     $A0
        FCB     $C0
        FCB     $C0
        FCB     $C0
        FCB     $10
        FCB     $E8
        FCB     $38

D0F72   FDB     D7F63
        FDB     D7F29
        FDB     D7E71
        FDB     D7E7F
        FDB     D7E8F
        FDB     D7F97
        FDB     D7E99
        FDB     D7EA5
        FDB     D7EC9
        FDB     D7EAD
        FDB     D7EB9
        FDB     D7EC9
        FDB     D7ED9
        FDB     D7EE3
        FDB     D7EEF
        FDB     D7EFF
        FDB     D7F0D
        FDB     D7F1B
        FDB     D7F29
        FDB     D7F2F
        FDB     D7F37
        FDB     D7F45
        FDB     D7F4D
        FDB     D7F59
        FDB     D7F63
        FDB     D7F6F
        FDB     D7F7B
        FDB     D7F89
        FDB     D7F97
        FDB     D7FA5
        FDB     D7FAF
        FDB     D7FB9
        FDB     D7FC1
        FDB     D7FCD
        FDB     D7FD9
D0FB9   EQU     *+1
        FDB     D7FE5

        FCB     $07
        FCB     $08
        FCB     $01
        FCB     $02
        FCB     $06
        FCB     $05
        FCB     $04
        FCB     $03

D0FC2   FCC     "000000"

D0FC8   FCB     $00
        FCB     $00
        FCB     $06
        FCB     $7F
        FCB     $00
        FCB     $22
        FCB     $18
        FCB     $00
        FCB     $00
        FCB     $DE
        FCB     $18
        FCB     $00
        FCB     $00
        FCB     $22
        FCB     $00
        FCB     $EF
        FCB     $D0
        FCB     $00

D0FDA   FCB     $00
        FCB     $22
        FCB     $03
        FCB     $1F
        FCB     $00
        FCB     $DE
        FCB     $30
        FCB     $00
        FCB     $00
        FCB     $22
        FCB     $D0
        FCB     $00

        FDB     $FFFF,$FFFF,$FFFF,$FFFF,$FFFF
        FDB     $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF

D1000   FCC     "YOU ARE A VERY"
        FCB     $80
        FCC     "SENSITIVE INDIVIDUAL"
        FCB     $80
        FCC     "WHO QUIETLY MAKES"
        FCB     $80
        FCC     "ACCOMPLISHMENTS"
        FCB     $80
        FCC     "WITHOUT THE NEED OF"
        FCB     $80
        FCC     "PUBLICITY."
        FCB     $80
        FCB     $80

D1066   FCC     "YOU HAVE A STRONG"
        FCB     $80
        FCC     "DESIRE FOR REWARDING"
        FCB     $80
        FCC     "RELATIONSHIPS."
        FCB     $80
        FCB     $80

D109D   FCC     "YOU ARE A DOER ... A"
        FCB     $80
        FCC     "PERSON WILLING TO"
        FCB     $80
        FCC     "ADAPT TO ANY"
        FCB     $80
        FCC     "REQUIREMENTS TO GET"
        FCB     $80
        FCC     "A JOB DONE."
        FCB     $80
        FCB     $80

D10F2   FCC     "YOU ARE SENSITIVE TO"
        FCB     $80
        FCC     "THE FEELINGS OF"
        FCB     $80
        FCC     "OTHERS AND HAVE"
        FCB     $80
        FCC     "EXCELLENT TASTES."
        FCB     $80
        FCB     $80

D113A   FCC     "YOU HAVE BEEN"
        FCB     $80
        FCC     "EXPERIENCING SOME"
        FCB     $80
        FCC     "DEMANDS ON YOUR"
        FCB     $80
        FCC     "PHYSICAL ENDURANCE"
        FCB     $80
        FCC     "AND SEEK SOLUTIONS"
        FCB     $80
        FCC     "WHICH WILL ENABLE"
        FCB     $80
        FCC     "YOU TIME FOR REST."
        FCB     $80
        FCB     $80

D11B6   FCC     "YOU HAVE BEEN"
        FCB     $80
        FCC     "WANTING TO GET AWAY"
        FCB     $80
        FCC     "ON A VACATION OR A"
        FCB     $80
        FCC     "CHANGE IN"
        FCB     $80
        FCC     "ENVIRONMENT ... YOU"
        FCB     $80
        FCC     "NEED PEOPLE TO BE"
        FCB     $80
        FCC     "MORE CONSIDERATE."
        FCB     $80
        FCB     $80

D122E   FCC     "YOU HAVE BEEN"
        FCB     $80
        FCC     "EXPERIENCING"
        FCB     $80
        FCC     "PRESSURE IN YOUR"
        FCB     $80
        FCC     "ENVIRONMENT AND"
        FCB     $80
        FCC     "DESIRE A CHANGE."
        FCB     $80
        FCB     $80

D127C   FCC     "YOU ARE AN ACTIVE"
        FCB     $80
        FCC     "PERSON DESIRING TO"
        FCB     $80
        FCC     "PLEASE YOUR FRIENDS"
        FCB     $80
        FCC     "AND FAMILY ... YOU"
        FCB     $80
        FCC     "ARE CAPABLE OF"
        FCB     $80
        FCC     "GENEROSITY."
        FCB     $80
        FCB     $80

D12E4   FCC     "YOU ARE A WINNER ..."
        FCB     $80
        FCC     "AND DO NOT ALLOW"
        FCB     $80
        FCC     "ANYTHING TO STAND IN"
        FCB     $80
        FCC     "THE WAY OF YOUR"
        FCB     $80
        FCC     "PROGRESS."
        FCB     $80
        FCB     $80

D133A   FCC     "YOU HAVE STRONG"
        FCB     $80
        FCC     "AMBITIONS AND GOALS"
        FCB     $80
        FCC     "AND WORK HARD TO"
        FCB     $80
        FCC     "ACHIEVE THEM."
        FCB     $80
        FCB     $80

D137E   FCC     "YOU ARE A CLEVER"
        FCB     $80
        FCC     "PERSON CAPABLE OF"
        FCB     $80
        FCC     "OUTWITTING THE"
        FCB     $80
        FCC     "AVERAGE PERSON ..."
        FCB     $80
        FCC     "YOU APPRECIATE"
        FCB     $80
        FCC     "BEAUTY AND THE"
        FCB     $80
        FCC     "ORIGINAL."
        FCB     $80
        FCB     $80

D13EC   FCC     "YOU NEED A SHIFT IN"
        FCB     $80
        FCC     "YOUR LIFE FROM"
        FCB     $80
        FCC     "FEELING THAT YOU"
        FCB     $80
        FCC     "HAVE BEEN TAKING"
        FCB     $80
        FCC     "SECOND PLACE ... AND"
        FCB     $80
        FCC     "YOU FEEL THAT MAKING"
        FCB     $80
        FCC     "THIS SHIFT REQUIRES"
        FCB     $80
        FCC     "MUCH EFFORT."
        FCB     $80
        FCB     $80

D147D   FCC     "YOU ARE A STRONG"
        FCB     $80
        FCC     "INDIVIDUAL AND ARE"
        FCB     $80
        FCC     "RARELY MOVED BY"
        FCB     $80
        FCC     "PROBLEMS ... YOU ARE"
        FCB     $80
        FCC     "SELF-DETERMINED AND"
        FCB     $80
        FCC     "HAVE A STRONG"
        FCB     $80
        FCC     "PERSONALITY."
        FCB     $80
        FCB     $80

D14F6   FCC     "YOU ARE A DETERMINED"
        FCB     $80
        FCC     "INDIVIDUAL WHO FEELS"
        FCB     $80
        FCC     "YOU CAN OVERCOME ANY"
        FCB     $80
        FCC     "OBSTACLE."
        FCB     $80
        FCB     $80

D1540   FCC     "YOU ARE INVOLVED IN"
        FCB     $80
        FCC     "MANY THINGS AND"
        FCB     $80
        FCC     "ENJOY THE EXCITEMENT"
        FCB     $80
        FCC     "OF CHANGE."
        FCB     $80
        FCB     $80

D1585   FCC     "YOU ENJOY BEING A"
        FCB     $80
        FCC     "WINNER AND WORK HARD"
        FCB     $80
        FCC     "TO OBTAIN SUCCESS IN"
        FCB     $80
        FCC     "WHATEVER YOU CHOOSE."
        FCB     $80
        FCB     $80

D15D7   FCC     "YOU KNOW YOUR"
        FCB     $80
        FCC     "DESTINY IS TO BE"
        FCB     $80
        FCC     "SUCCESSFUL AND"
        FCB     $80
        FCC     "ACCEPT ANY CHALLENGE"
        FCB     $80
        FCC     "TO PROVE YOUR"
        FCB     $80
        FCC     "ABILITIES."
        FCB     $80
        FCB     $80

D1634   FCC     "YOU ENJOY BEING"
        FCB     $80
        FCC     "APPRECIATED FOR THE"
        FCB     $80
        FCC     "QUALITY OF THE"
        FCB     $80
        FCC     "POSSESSIONS IN YOUR"
        FCB     $80
        FCC     "LIFE AND DETEST"
        FCB     $80
        FCC     "BEING CHALLENGED AS"
        FCB     $80
        FCC     "TO YOUR INTEGRITY."
        FCB     $80
        FCB     $80

D16B3   FCC     "YOU HAVE BEEN TURNED"
        FCB     $80
        FCC     "AWAY FROM THE"
        FCB     $80
        FCC     "CHALLENGE IN LIFE"
        FCB     $80
        FCC     "AND ARE LOOKING MORE"
        FCB     $80
        FCC     "REALISTICALLY AT"
        FCB     $80
        FCC     "GOALS TO PROVIDE YOU"
        FCB     $80
        FCC     "WITH AN EASIER LIFE."
        FCB     $80
        FCB     $80

D1739   FCC     "YOU LEAD AN EXCITING"
        FCB     $80
        FCC     "LIFE AND FEEL"
        FCB     $80
        FCC     "NOTHING CAN STAND IN"
        FCB     $80
        FCC     "YOUR WAY OF SUCCESS."
        FCB     $80
        FCB     $80

D1787   FCC     "YOU ARE READY FOR"
        FCB     $80
        FCC     "ACTION ... READY TO"
        FCB     $80
        FCC     "TAKE ON LIFE AND ALL"
        FCB     $80
        FCC     "ITS EXCITING EVENTS."
        FCB     $80
        FCB     $80

D17D8   FCC     "YOU ENJOY THE"
        FCB     $80
        FCC     "CHALLENGE OF"
        FCB     $80
        FCC     "SOMETHING NEW AND"
        FCB     $80
        FCC     "WILL WORK HARD TO"
        FCB     $80
        FCC     "PROVE TO OTHERS YOU"
        FCB     $80
        FCC     "CAN ACHIEVE RESULTS."
        FCB     $80
        FCB     $80

D1841   FCC     "YOU ARE WILLING TO"
        FCB     $80
        FCC     "MAKE ANY CHANGE YOU"
        FCB     $80
        FCC     "FEEL OFFERS AN"
        FCB     $80
        FCC     "OPPORTUNITY TO"
        FCB     $80
        FCC     "ILLUSTRATE YOUR"
        FCB     $80
        FCC     "TALENTS."
        FCB     $80
        FCB     $80

D18A0   FCC     "YOU RECOGNIZE AN"
        FCB     $80
        FCC     "ABUNDANCE OF"
        FCB     $80
        FCC     "OPPORTUNITIES IN"
        FCB     $80
        FCC     "LIFE AND FEEL THE"
        FCB     $80
        FCC     "URGENCY TO TAKE"
        FCB     $80
        FCC     "ADVANTAGE OF AS MANY"
        FCB     $80
        FCC     "AS YOU CAN."
        FCB     $80
        FCB     $80

D1913   FCC     "YOU SPEND A GREAT"
        FCB     $80
        FCC     "DEAL OF TIME"
        FCB     $80
        FCC     "THINKING ABOUT THE"
        FCB     $80
        FCC     "WAY THINGS SHOULD BE"
        FCB     $80
        FCC     "RATHER THAN MAKING"
        FCB     $80
        FCC     "THEM THE WAY YOU"
        FCB     $80
        FCC     "WANT THEM TO BE."
        FCB     $80
        FCB     $80

D1990   FCC     "YOU HAVE BEEN"
        FCB     $80
        FCC     "FEELING EXHAUSTED"
        FCB     $80
        FCC     "AND NEED AN"
        FCB     $80
        FCC     "OPPORTUNITY TO"
        FCB     $80
        FCC     "RECHARGE YOUR"
        FCB     $80
        FCC     "ENERGY."
        FCB     $80
        FCB     $80

D19E2   FCC     "YOU HAVE A STRONG"
        FCB     $80
        FCC     "PERSONALITY AND MAKE"
        FCB     $80
        FCC     "YOUR OWN DECISIONS"
        FCB     $80
        FCC     "WITHOUT THE"
        FCB     $80
        FCC     "ASSISTANCE OF"
        FCB     $80
        FCC     "OTHERS."
        FCB     $80
        FCB     $80

D1A3F   FCC     "YOU ARE SEEKING"
        FCB     $80
        FCC     "SOLUTIONS TO SOME"
        FCB     $80
        FCC     "DIFFICULTIES."
        FCB     $80
        FCB     $80

D1A70   FCC     "YOU ARE A GENTLE AND"
        FCB     $80
        FCC     "SENSITIVE INDIVIDUAL"
        FCB     $80
        FCC     "WHO APPRECIATES"
        FCB     $80
        FCC     "BEAUTY IN YOUR"
        FCB     $80
        FCC     "SURROUNDINGS."
        FCB     $80
        FCB     $80

D1AC8   FCC     "YOU NEED CONTINUED"
        FCB     $80
        FCC     "RECOGNITION TO FEEL"
        FCB     $80
        FCC     "MOTIVATED TO ACHIEVE"
        FCB     $80
        FCC     "YOUR GOALS."
        FCB     $80
        FCB     $80

D1B11   FCC     "YOU ARE SEEN BY"
        FCB     $80
        FCC     "OTHERS AS AN"
        FCB     $80
        FCC     "INTERESTING PERSON"
        FCB     $80
        FCC     "... YOU ACCEPT AND"
        FCB     $80
        FCC     "ENJOY THE"
        FCB     $80
        FCC     "RESPONSIBILITY OF"
        FCB     $80
        FCC     "MAINTAINING YOUR"
        FCB     $80
        FCC     "IMAGE."
        FCB     $80
        FCB     $80

D1B89   FCC     "YOU ARE AN IDEA"
        FCB     $80
        FCC     "PERSON ... VERY"
        FCB     $80
        FCC     "ANXIOUS TO SEE YOUR"
        FCB     $80
        FCC     "IDEAS COME TO"
        FCB     $80
        FCC     "REALITY."
        FCB     $80
        FCB     $80

D1BD5   FCC     "YOU DESIRE THE RICH"
        FCB     $80
        FCC     "LIFE WITH EVERYTHING"
        FCB     $80
        FCC     "MADE AVAILABLE TO"
        FCB     $80
        FCC     "YOUR FANTASIES."
        FCB     $80
        FCB     $80

D1C21   FCC     "YOU ENJOY OTHERS WHO"
        FCB     $80
        FCC     "APPRECIATE THE"
        FCB     $80
        FCC     "BEAUTY IN LIFE AND"
        FCB     $80
        FCC     "CAN RECOGNIZE YOUR"
        FCB     $80
        FCC     "APPRECIATION FOR THE"
        FCB     $80
        FCC     "FINER THINGS."
        FCB     $80
        FCB     $80

D1C8F   FCC     "YOU AVOID"
        FCB     $80
        FCC     "DISAGREEMENTS OF ANY"
        FCB     $80
        FCC     "NATURE AND SEEK"
        FCB     $80
        FCC     "APPRECIATION FROM"
        FCB     $80
        FCC     "OTHERS."
        FCB     $80
        FCB     $80

D1CD9   FCC     "YOU WANT TO FEEL"
        FCB     $80
        FCC     "SAFE AND SECURE IN"
        FCB     $80
        FCC     "YOUR RELATIONSHIPS"
        FCB     $80
        FCC     "WITH OTHERS."
        FCB     $80
        FCB     $80

D1D1E   FCC     "YOU HAVE THE"
        FCB     $80
        FCC     "CAPACITY FOR STRONG"
        FCB     $80
        FCC     "SELF-DISCIPLINE AND"
        FCB     $80
        FCC     "ARE CAPABLE OF"
        FCB     $80
        FCC     "ACHIEVING YOUR"
        FCB     $80
        FCC     "DESIRES."
        FCB     $80
        FCB     $80

D1D7B   FCC     "YOU ENJOY THE BEAUTY"
        FCB     $80
        FCC     "IN LIFE AND THE"
        FCB     $80
        FCC     "SATISFACTIONS LIFE"
        FCB     $80
        FCC     "CAN OFFER YOU."
        FCB     $80
        FCB     $80

D1DC3   FCC     "YOU HAVE FOUND"
        FCB     $80
        FCC     "SECURITY IN YOUR OWN"
        FCB     $80
        FCC     "GOALS AND ARE MAKING"
        FCB     $80
        FCC     "LIFE MORE SIMPLE."
        FCB     $80
        FCB     $80

D1E0F   FCC     "YOU ENJOY THE FINER"
        FCB     $80
        FCC     "THINGS IN LIFE ..."
        FCB     $80
        FCC     "YOU LOOK FOR"
        FCB     $80
        FCC     "QUALITY."
        FCB     $80
        FCB     $80

D1E4D   FCC     "YOU HAVE NOT BEEN"
        FCB     $80
        FCC     "HONEST WITH YOURSELF"
        FCB     $80
        FCC     "AND THIS HAS"
        FCB     $80
        FCC     "PRODUCED FATIGUE."
        FCB     $80
        FCB     $80

D1E94   FCC     "YOU ARE READY FOR A"
        FCB     $80
        FCC     "CHANGE ... PERHAPS A"
        FCB     $80
        FCC     "VACATION OR"
        FCB     $80
        FCC     "SOMETHING TO ALLOW"
        FCB     $80
        FCC     "YOU TO RID YOURSELF"
        FCB     $80
        FCC     "OF PHYSICAL STRAIN."
        FCB     $80
        FCB     $80

D1F05   FCC     "YOU ARE DESIROUS OF"
        FCB     $80
        FCC     "A LIFE FREE FROM"
        FCB     $80
        FCC     "CONFLICT AND STRESS."
        FCB     $80
        FCB     $80

D1F40   FCC     "YOU ARE A VERY"
        FCB     $80
        FCC     "DETERMINED PERSON"
        FCB     $80
        FCC     "WHENEVER ANYONE"
        FCB     $80
        FCC     "PRESENTS A CHALLENGE"
        FCB     $80
        FCC     "TO YOUR BELIEFS."
        FCB     $80
        FCB     $80

D1F98   FCC     "YOU HAVE BEEN"
        FCB     $80
        FCC     "FEELING VERY EXCITED"
        FCB     $80
        FCC     "AND HAVE THE NEED TO"
        FCB     $80
        FCC     "DO SOMETHING"
        FCB     $80
        FCC     "UNUSUAL."
        FCB     $80
        FCB     $80

D1FE7   FCC     "YOU HAVE STRONG"
        FCB     $80
        FCC     "OPINIONS AND A"
        FCB     $80
        FCC     "DEFINITE NEED FOR"
        FCB     $80
        FCC     "SOLUTIONS TO OLD"
        FCB     $80
        FCC     "SITUATIONS."
        FCB     $80
        FCB     $80

D2036   FCC     "YOU HAVE BEEN"
        FCB     $80
        FCC     "UNCOMPROMISING FOR"
        FCB     $80
        FCC     "YOU KNOW YOUR"
        FCB     $80
        FCC     "DESIRES AND EXPECT"
        FCB     $80
        FCC     "THEIR FULFILLMENT."
        FCB     $80
        FCB     $80

D208C   FCC     "YOU HAVE BEEN"
        FCB     $80
        FCC     "FEELING FINANCIAL"
        FCB     $80
        FCC     "SUCCESS IS"
        FCB     $80
        FCC     "CONTINUALLY ESCAPING"
        FCB     $80
        FCC     "YOU."
        FCB     $80
        FCB     $80

D20D2   FCC     "YOU ENJOY BEING LEFT"
        FCB     $80
        FCC     "ALONE AND FREE FROM"
        FCB     $80
        FCC     "ANY CONFLICTS OF"
        FCB     $80
        FCC     "LIFE."
        FCB     $80
        FCB     $80

D2113   FCC     "YOU HAVE BEEN"
        FCB     $80
        FCC     "EXPERIENCING"
        FCB     $80
        FCC     "DIFFICULTY IN"
        FCB     $80
        FCC     "COMMUNICATING WITH"
        FCB     $80
        FCC     "OTHERS."
        FCB     $80
        FCB     $80

D2158   FCC     "YOU HAVE THE ABILITY"
        FCB     $80
        FCC     "TO PREDICT"
        FCB     $80
        FCC     "DIFFICULTIES WITH"
        FCB     $80
        FCC     "OTHERS ... SO YOU"
        FCB     $80
        FCC     "PLAN FOR THE"
        FCB     $80
        FCC     "AVOIDANCE."
        FCB     $80
        FCB     $80

D21B5   FCC     "YOU HAVE THE ABILITY"
        FCB     $80
        FCC     "TO MENTALLY OUTWIT"
        FCB     $80
        FCC     "YOUR OPPONENTS."
        FCB     $80
        FCB     $80

D21EE   FCC     "YOU SEEK LESS"
        FCB     $80
        FCC     "CONFLICT AND"
        FCB     $80
        FCC     "INVOLVEMENT WITH"
        FCB     $80
        FCC     "DISAGREEABLE"
        FCB     $80
        FCC     "INDIVIDUALS ... YOU"
        FCB     $80
        FCC     "FIND PRESSURES FROM"
        FCB     $80
        FCC     "OTHERS ARE DRAINING"
        FCB     $80
        FCC     "YOUR ENERGY."
        FCB     $80
        FCB     $80

D2271   FCC     "YOU ARE IN LOVE WITH"
        FCB     $80
        FCC     "LIFE ... AND AS A"
        FCB     $80
        FCC     "RESULT SEE THE"
        FCB     $80
        FCC     "NATURAL BEAUTY IN"
        FCB     $80
        FCC     "MANY PEOPLE."
        FCB     $80
        FCB     $80

D22C7   FCC     "YOU WOULD LIKE A"
        FCB     $80
        FCC     "CHANGE IN LIFE ..."
        FCB     $80
        FCC     "PERHAPS TIME FOR"
        FCB     $80
        FCC     "MORE RELAXATION."
        FCB     $80
        FCB     $80

D230E   FCC     "YOU ARE SEEKING"
        FCB     $80
        FCC     "SOLUTIONS AND NEW"
        FCB     $80
        FCC     "DIRECTIONS FOR"
        FCB     $80
        FCC     "CHANGES IN YOUR"
        FCB     $80
        FCC     "ENVIRONMENT ... YOU"
        FCB     $80
        FCC     "ARE LOOKING FOR"
        FCB     $80
        FCC     "BETTER PATHS TO YOUR"
        FCB     $80
        FCC     "AMBITIONS."
        FCB     $80
        FCB     $80

D2394   FCC     "YOU BELIEVE IN"
        FCB     $80
        FCC     "FOLLOWING"
        FCB     $80
        FCC     "INSTRUCTIONS AND"
        FCB     $80
        FCC     "COMPLETING"
        FCB     $80
        FCC     "OBJECTIVES WITH AN"
        FCB     $80
        FCC     "ORGANIZED PLAN."
        FCB     $80
        FCB     $80

D23ED   FCC     "YOU AVOID TAKING"
        FCB     $80
        FCC     "RESPONSIBILITY FOR"
        FCB     $80
        FCC     "ACTIONS OF OTHERS"
        FCB     $80
        FCC     "... BUT ARE VERY"
        FCB     $80
        FCC     "WILLING TO WORK IN"
        FCB     $80
        FCC     "COOPERATION WITH"
        FCB     $80
        FCC     "THEM."
        FCB     $80
        FCB     $80

D245F   FCC     "YOU FEEL ADDITIONAL"
        FCB     $80
        FCC     "STRENGTH IN YOUR"
        FCB     $80
        FCC     "ABILITY TO ACHIEVE"
        FCB     $80
        FCC     "YOUR OBJECTIVES IF"
        FCB     $80
        FCC     "YOU CAN RECEIVE THE"
        FCB     $80
        FCC     "ASSISTANCE FROM"
        FCB     $80
        FCC     "OTHERS."
        FCB     $80
        FCB     $80

D24D7   FCC     "YOU EXPERIENCE GREAT"
        FCB     $80
        FCC     "JOY WITH ASSOCIATES"
        FCB     $80
        FCC     "OF SIMILAR TASTES"
        FCB     $80
        FCC     "... ESPECIALLY IF"
        FCB     $80
        FCC     "THEY PRAISE YOUR"
        FCB     $80
        FCC     "TASTE."
        FCB     $80
        FCB     $80

D253D   FCC     "YOU HAVE BEEN"
        FCB     $80
        FCC     "SEEKING A LIFE FREE"
        FCB     $80
        FCC     "FROM CONFLICT WITH"
        FCB     $80
        FCC     "LITTLE DEMANDS"
        FCB     $80
        FCC     "PLACED UPON YOU."
        FCB     $80
        FCB     $80

D2593   FCC     "YOU HAVE A NEED FOR"
        FCB     $80
        FCC     "VERY SPECIAL"
        FCB     $80
        FCC     "ASSOCIATES WHO CAN"
        FCB     $80
        FCC     "RECOGNIZE YOUR"
        FCB     $80
        FCC     "NATURAL ABILITIES."
        FCB     $80
        FCB     $80

D25EA   FCC     "YOU HAVE BEEN"
        FCB     $80
        FCC     "EXPERIENCING SOME"
        FCB     $80
        FCC     "STRESS IN YOUR LIFE"
        FCB     $80
        FCC     "AND NEED FRIENDS TO"
        FCB     $80
        FCC     "LISTEN AND HELP YOU"
        FCB     $80
        FCC     "THROUGH YOUR"
        FCB     $80
        FCC     "DIFFICULTIES."
        FCB     $80
        FCB     $80

D2662   FCC     "YOU ARE A"
        FCB     $80
        FCC     "SELF-ASSURED"
        FCB     $80
        FCC     "INDIVIDUAL WHO"
        FCB     $80
        FCC     "PLACES RESTRAINTS"
        FCB     $80
        FCC     "UPON YOURSELF AND"
        FCB     $80
        FCC     "ENJOY THE"
        FCB     $80
        FCC     "ACCOMPLISHMENTS THAT"
        FCB     $80
        FCC     "DISCIPLINE BRINGS"
        FCB     $80
        FCC     "YOU."
        FCB     $80
        FCB     $80

D26E3   FCC     "YOU ARE A LEADER ..."
        FCB     $80
        FCC     "A DOER WHO ENJOYS"
        FCB     $80
        FCC     "THE CHALLENGE OF"
        FCB     $80
        FCC     "ACCOMPLISHMENT."
        FCB     $80
        FCB     $80

D272C   FCC     "YOU FEEL YOU ARE"
        FCB     $80
        FCC     "DESERVING OF NEW AND"
        FCB     $80
        FCC     "BETTER THINGS AND"
        FCB     $80
        FCC     "HAVE THE WILLINGNESS"
        FCB     $80
        FCC     "TO WORK FOR THEIR"
        FCB     $80
        FCC     "ACCOMPLISHMENT."
        FCB     $80
        FCB     $80

D279C   FCC     "YOU HAVE BEEN"
        FCB     $80
        FCC     "FEELING DISSATISFIED"
        FCB     $80
        FCC     "WITH YOURSELF AND"
        FCB     $80
        FCC     "ARE DETERMINED TO"
        FCB     $80
        FCC     "MAKE THE NECESSARY"
        FCB     $80
        FCC     "CHANGES FOR"
        FCB     $80
        FCC     "IMPROVEMENT."
        FCB     $80
        FCB     $80

D2810   FCC     "YOU ARE WILLING TO"
        FCB     $80
        FCC     "WORK HARD ... TO DO"
        FCB     $80
        FCC     "WHATEVER IS"
        FCB     $80
        FCC     "NECESSARY TO ACHIEVE"
        FCB     $80
        FCC     "THE GOALS YOU HAVE"
        FCB     $80
        FCC     "SET FOR YOURSELF."
        FCB     $80
        FCB     $80

D287E   FCC     "YOU MAY APPEAR TO"
        FCB     $80
        FCC     "OTHERS AS BEING"
        FCB     $80
        FCC     "STUBBORN AND"
        FCB     $80
        FCC     "UNWILLING TO SEE"
        FCB     $80
        FCC     "THEIR VIEWPOINT."
        FCB     $80
        FCB     $80

D28D0   FCC     "YOU FEEL OTHERS ARE"
        FCB     $80
        FCC     "PREVENTING YOU FROM"
        FCB     $80
        FCC     "ACHIEVING YOUR GOALS"
        FCB     $80
        FCC     "AND YOU TAKE OFFENSE"
        FCB     $80
        FCC     "AT THEIR POSITION."
        FCB     $80
        FCB     $80

D2936   FCC     "YOU DO NOT MIND"
        FCB     $80
        FCC     "WORKING ... AND YOU"
        FCB     $80
        FCC     "AVOID RELATIONSHIPS"
        FCB     $80
        FCC     "WHICH PRODUCE"
        FCB     $80
        FCC     "UPSETS."
        FCB     $80
        FCB     $80

D2985   FCC     "YOU BELIEVE IN"
        FCB     $80
        FCC     "CREATING SOLUTIONS"
        FCB     $80
        FCC     "TO PROBLEMS ... AND"
        FCB     $80
        FCC     "AS A RESULT YOU MOVE"
        FCB     $80
        FCC     "UPWARD."
        FCB     $80
        FCB     $80

D29D9   FCC     "YOU ARE AN"
        FCB     $80
        FCC     "AGGRESSIVE PERSON"
        FCB     $80
        FCC     "... YOU NEED TO FEEL"
        FCB     $80
        FCC     "YOU ARE MAKING"
        FCB     $80
        FCC     "PROGRESS OR YOU"
        FCB     $80
        FCC     "BECOME IMPATIENT."
        FCB     $80
        FCB     $80

D2A3D   FCC     "YOU ARE THE"
        FCB     $80
        FCC     "DAREDEVIL ... THE"
        FCB     $80
        FCC     "PERSON WHO ENJOYS"
        FCB     $80
        FCC     "ACTIVITIES AND"
        FCB     $80
        FCC     "CHALLENGES."
        FCB     $80
        FCB     $80

D2A89   FCC     "YOU ARE A CONTENT"
        FCB     $80
        FCC     "PERSON ... A PERSON"
        FCB     $80
        FCC     "WHO SEES NO REASON"
        FCB     $80
        FCC     "TO WASTE ENERGY."
        FCB     $80
        FCB     $80

D2AD4   FCC     "YOU FEEL FRUSTRATED"
        FCB     $80
        FCC     "BY OTHERS ... THAT"
        FCB     $80
        FCC     "THEY HAVE BEEN"
        FCB     $80
        FCC     "STANDING IN YOUR WAY"
        FCB     $80
        FCC     "OF HAVING WHAT YOU"
        FCB     $80
        FCC     "FEEL IS RIGHTFULLY"
        FCB     $80
        FCC     "YOURS."
        FCB     $80
        FCB     $80

D2B4D   FCC     "YOU ARE A"
        FCB     $80
        FCC     "REACTIONARY PERSON"
        FCB     $80
        FCC     "AND YOU NEED TO TAKE"
        FCB     $80
        FCC     "TIME OUT TO CONSIDER"
        FCB     $80
        FCC     "THE BEST PATH FOR"
        FCB     $80
        FCC     "YOUR EFFORTS."
        FCB     $80
        FCB     $80

D2BB5   FCC     "YOU ARE A GIVER ..."
        FCB     $80
        FCC     "A PERSON EASILY"
        FCB     $80
        FCC     "MOVED BY THE"
        FCB     $80
        FCC     "TROUBLES OR THE JOYS"
        FCB     $80
        FCC     "OF OTHERS."
        FCB     $80
        FCB     $80

D2C07   FCC     "YOU ARE RECOGNIZING"
        FCB     $80
        FCC     "THAT MORE PERSONAL"
        FCB     $80
        FCC     "EFFORT IS REQUIRED"
        FCB     $80
        FCC     "TO OBTAIN THOSE"
        FCB     $80
        FCC     "THINGS IN LIFE YOU"
        FCB     $80
        FCC     "DESIRE."
        FCB     $80
        FCB     $80

D2C6D   FCC     "YOU HAVE A FEELING"
        FCB     $80
        FCC     "OF IMPATIENCE OFTEN"
        FCB     $80
        FCC     "FOR DESIRED EVENTS"
        FCB     $80
        FCC     "SEEM TO COME TOO"
        FCB     $80
        FCC     "SLOWLY WHEN YOU WANT"
        FCB     $80
        FCC     "THEM SO BADLY."
        FCB     $80
        FCB     $80

D2CDD   FCC     "YOU ARE A CREATIVE"
        FCB     $80
        FCC     "PERSON BY NATURE ..."
        FCB     $80
        FCC     "YOU ENJOY THE"
        FCB     $80
        FCC     "UNUSUAL ... AND LIKE"
        FCB     $80
        FCC     "TO ASSOCIATE WITH"
        FCB     $80
        FCC     "OTHERS WHO HAVE"
        FCB     $80
        FCC     "SIMILAR TASTES."
        FCB     $80
        FCB     $80

D2D5B   FCC     "YOU ARE WORKING TO"
        FCB     $80
        FCC     "BUILD BETTER"
        FCB     $80
        FCC     "FEELINGS ABOUT"
        FCB     $80
        FCC     "YOURSELF AND TOWARDS"
        FCB     $80
        FCC     "PROVIDING A LIFE"
        FCB     $80
        FCC     "WITH MORE SECURITY."
        FCB     $80
        FCB     $80

D2DC5   FCC     "YOU HAVE BEEN"
        FCB     $80
        FCC     "EXPERIENCING"
        FCB     $80
        FCC     "PERSONAL PRESSURES"
        FCB     $80
        FCC     "IN YOUR LIFE AND YOU"
        FCB     $80
        FCC     "KNOW YOU CAN SOLVE"
        FCB     $80
        FCC     "YOUR OWN"
        FCB     $80
        FCC     "DIFFICULTIES."
        FCB     $80
        FCB     $80

D2E33   FCC     "INDECISION REGARDING"
        FCB     $80
        FCC     "DIFFICULTIES IN YOUR"
        FCB     $80
        FCC     "LIFE MAY BE"
        FCB     $80
        FCC     "PRODUCING"
        FCB     $80
        FCC     "ANXIOUSNESS."
        FCB     $80
        FCB     $80

D2E81   FCC     "YOU ARE ATTRACTED TO"
        FCB     $80
        FCC     "INDIVIDUALS WHO HAVE"
        FCB     $80
        FCC     "CREATIVE ABILITIES."
        FCB     $80
        FCB     $80

D2EC0   FCC     "YOU ARE CONCERNED AT"
        FCB     $80
        FCC     "HOW OTHERS SEE YOU"
        FCB     $80
        FCC     "AND CONSTANTLY WORK"
        FCB     $80
        FCC     "TOWARD IMPROVING"
        FCB     $80
        FCC     "YOUR SELF-IMAGE."
        FCB     $80
        FCB     $80

D2F1F   FCC     "YOU LOOK FOR ACTION"
        FCB     $80
        FCC     "... AND THE"
        FCB     $80
        FCC     "CHALLENGE LIFE"
        FCB     $80
        FCC     "OFFERS YOU."
        FCB     $80
        FCB     $80

D2F5B   FCC     "YOU LOOK FOR THE"
        FCB     $80
        FCC     "UNUSUAL IN LIFE AND"
        FCB     $80
        FCC     "ANYTHING THAT IS A"
        FCB     $80
        FCC     "CHALLENGE TO YOUR"
        FCB     $80
        FCC     "ABILITIES."
        FCB     $80
        FCB     $80

D2FB1   FCC     "YOU ARE A VERY"
        FCB     $80
        FCC     "SELECTIVE INDIVIDUAL"
        FCB     $80
        FCC     "REGARDING THE"
        FCB     $80
        FCC     "PURCHASE OF ITEMS"
        FCB     $80
        FCC     "WHICH REFLECT YOUR"
        FCB     $80
        FCC     "GOOD TASTE AND"
        FCB     $80
        FCC     "APPEARANCE."
        FCB     $80
        FCB     $80

D3024   FCC     "YOU ENJOY BEING A"
        FCB     $80
        FCC     "LEADER OR REGOGNIZED"
        FCB     $80
        FCC     "FOR YOUR TALENTS."
        FCB     $80
        FCB     $80

D305E   FCC     "YOU NEED THE"
        FCB     $80
        FCC     "ASSISTANCE OF"
        FCB     $80
        FCC     "SOMEONE WHO CAN"
        FCB     $80
        FCC     "RECOGNIZE YOUR"
        FCB     $80
        FCC     "DIFFICULTIES AND"
        FCB     $80
        FCC     "HELP YOU BRING PEACE"
        FCB     $80
        FCC     "INTO YOUR LIFE."
        FCB     $80
        FCB     $80

D30CF   FCC     "YOUR ENERGY HAS BEEN"
        FCB     $80
        FCC     "LACKING LATELY ..."
        FCB     $80
        FCC     "PERHAPS YOU NEED A"
        FCB     $80
        FCC     "VACATION OR REST"
        FCB     $80
        FCC     "FROM THE DEMANDS"
        FCB     $80
        FCC     "PLACED ON YOU."
        FCB     $80
        FCB     $80

D313C   FCC     "YOUR ENERGY HAS BEEN"
        FCB     $80
        FCC     "LACKING LATELY ..."
        FCB     $80
        FCC     "PERHAPS YOU NEED A"
        FCB     $80
        FCC     "VACATION OR REST"
        FCB     $80
        FCC     "FROM THE DEMANDS"
        FCB     $80
        FCC     "PLACED ON YOU."
        FCB     $80
        FCB     $80

D31A9   FCC     "YOU FEEL A CHANGE IS"
        FCB     $80
        FCC     "NEEDED IN YOUR LIFE"
        FCB     $80
        FCC     "FOR YOU HAVE BEEN"
        FCB     $80
        FCC     "EXPERIENCING FATIGUE"
        FCB     $80
        FCC     "AND LACK OF ENERGY"
        FCB     $80
        FCC     "TO FINISH PRODUCTS."
        FCB     $80
        FCB     $80

D3221   FCC     "YOU HAVE BEEN"
        FCB     $80
        FCC     "FEELING TIRED AND"
        FCB     $80
        FCC     "ARE UNWILLING TO"
        FCB     $80
        FCC     "TAKE ON ADDITIONAL"
        FCB     $80
        FCC     "RESPONSIBILITIES."
        FCB     $80
        FCB     $80

D3278   FCC     "YOU ENJOY SPENDING"
        FCB     $80
        FCC     "MONEY ON LUXURIOUS"
        FCB     $80
        FCC     "ITEMS YOU KNOW"
        FCB     $80
        FCC     "POSSESS QUALITY."
        FCB     $80
        FCB     $80

D32BF   FCC     "YOU HAVE EXPERIENCED"
        FCB     $80
        FCC     "A PERIOD WHERE YOUR"
        FCB     $80
        FCC     "ENERGIES HAVE BEEN"
        FCB     $80
        FCC     "DRAINED AND YOU SEEK"
        FCB     $80
        FCC     "AN ENVIRONMENT FOR"
        FCB     $80
        FCC     "REST."
        FCB     $80
        FCB     $80

D332A   FCC     "PROJECTS SEEM TO"
        FCB     $80
        FCC     "HAVE BEEN ESCAPING"
        FCB     $80
        FCC     "COMPLETION DUE TO"
        FCB     $80
        FCC     "LACK OF CONCENTRATED"
        FCB     $80
        FCC     "EFFORT."
        FCB     $80
        FCB     $80

D337E   FCC     "YOU HAVE BEEN"
        FCB     $80
        FCC     "REFUSING TO TAKE"
        FCB     $80
        FCC     "TIME OUT FOR NEEDED"
        FCB     $80
        FCC     "REST ... PERHAPS A"
        FCB     $80
        FCC     "VACATION WOULD BE"
        FCB     $80
        FCC     "APPROPRIATE AT THIS"
        FCB     $80
        FCC     "TIME."
        FCB     $80
        FCB     $80

D33F1   FCC     "YOU POSSESS EXTREME"
        FCB     $80
        FCC     "DETERMINATION TO"
        FCB     $80
        FCC     "SUCCEED REGARDING"
        FCB     $80
        FCC     "DEMANDS ON LIFE AND"
        FCB     $80
        FCC     "YOU FEEL YOU WILL"
        FCB     $80
        FCC     "PREVAIL."
        FCB     $80
        FCB     $80

D3458   FCC     "YOU HAVE BEEN"
        FCB     $80
        FCC     "EXPERIENCING"
        FCB     $80
        FCC     "IMPATIENCE ... YOU"
        FCB     $80
        FCC     "FEEL OBTAINING YOUR"
        FCB     $80
        FCC     "OBJECTIVES WILL"
        FCB     $80
        FCC     "SOLVE YOUR PROBLEMS."
        FCB     $80
        FCB     $80

D34C0   FCC     "SOME PERSONAL"
        FCB     $80
        FCC     "INVOLVEMENTS ARE"
        FCB     $80
        FCC     "CAUSING UNDESIRABLE"
        FCB     $80
        FCC     "CONDITIONS REQUIRING"
        FCB     $80
        FCC     "CHANGE."
        FCB     $80
        FCB     $80

D3511   FCC     "YOU ENJOY BEING IN"
        FCB     $80
        FCC     "THE ASSOCIATION OF"
        FCB     $80
        FCC     "ANYONE YOU RECOGNIZE"
        FCB     $80
        FCC     "AS AN ACCOMPLISHED"
        FCB     $80
        FCC     "INDIVIDUAL."
        FCB     $80
        FCB     $80

D356C   FCC     "CONDITIONS IN YOUR"
        FCB     $80
        FCC     "LIFE HAVE MADE YOU"
        FCB     $80
        FCC     "TIRED."
        FCB     $80
        FCB     $80

D359A   FCC     "CERTAIN CONDITIONS"
        FCB     $80
        FCC     "IN YOUR LIFE ARE"
        FCB     $80
        FCC     "UNATTRACTIVE AND YOU"
        FCB     $80
        FCC     "HAVE A STRONG DESIRE"
        FCB     $80
        FCC     "FOR A CHANGE AT THIS"
        FCB     $80
        FCC     "TIME."
        FCB     $80
        FCB     $80

D3604   FCC     "YOU HAVE A LIFE OF"
        FCB     $80
        FCC     "ROUTINE AND"
        FCB     $80
        FCC     "REPETITION ... LIFE"
        FCB     $80
        FCC     "IS PRESENTING NO"
        FCB     $80
        FCC     "MAJOR CHANGES AT"
        FCB     $80
        FCC     "THIS TIME."
        FCB     $80
        FCB     $80

D3665   FCC     "YOU ARE A STRONG"
        FCB     $80
        FCC     "PERSON WITH"
        FCB     $80
        FCC     "DETERMINATION TO WIN"
        FCB     $80
        FCC     "... EVEN AGAINST"
        FCB     $80
        FCC     "HEAVY ODDS."
        FCB     $80
        FCB     $80

D36B5   FCC     "YOU HAVE THE FEELING"
        FCB     $80
        FCC     "LADY LUCK HAS NOT"
        FCB     $80
        FCC     "BEEN ON YOUR SIDE"
        FCB     $80
        FCC     "RECENTLY ... PERHAPS"
        FCB     $80
        FCC     "POSITIVE THINKING IS"
        FCB     $80
        FCC     "THE ANSWER."
        FCB     $80
        FCB     $80

D3725   FCC     "YOU HAVE BEEN"
        FCB     $80
        FCC     "EXPERIENCING MANY"
        FCB     $80
        FCC     "CHALLENGES AND HAVE"
        FCB     $80
        FCC     "BEEN ASKED TO MAKE"
        FCB     $80
        FCC     "SEVERAL DECISIONS."
        FCB     $80
        FCB     $80

D3780   FCC     "YOU ARE A VERY"
        FCB     $80
        FCC     "POLITE AND CAUTIOUS"
        FCB     $80
        FCC     "INDIVIDUAL WHO TAKES"
        FCB     $80
        FCC     "GREAT CARE IN"
        FCB     $80
        FCC     "APPROACHING"
        FCB     $80
        FCC     "RELATIONSHIPS WITH"
        FCB     $80
        FCC     "OTHERS."
        FCB     $80
        FCB     $80

D37EE   FCC     "PERHAPS YOU HAVE"
        FCB     $80
        FCC     "BEEN FEELING YOU ARE"
        FCB     $80
        FCC     "LOSING ... INSTEAD"
        FCB     $80
        FCC     "OF MAKING THE"
        FCB     $80
        FCC     "PROGRESS YOU KNOW IS"
        FCB     $80
        FCC     "NECESSARY IN YOUR"
        FCB     $80
        FCC     "LIFE."
        FCB     $80
        FCB     $80

D3863   FCC     "YOU FEEL YOUR ENERGY"
        FCB     $80
        FCC     "HAS BEEN DRAINED."
        FCB     $80
        FCB     $80

D388B   FCC     "YOU ARE IN A"
        FCB     $80
        FCC     "POSITION OF HAVING"
        FCB     $80
        FCC     "TO ACCEPT LIFE AS IT"
        FCB     $80
        FCC     "IS RATHER THAN AS"
        FCB     $80
        FCC     "YOU WOULD LIKE IT TO"
        FCB     $80
        FCC     "BE."
        FCB     $80
        FCB     $80

D38EC   FCC     "YOU FEEL A"
        FCB     $80
        FCC     "RESISTANCE FROM"
        FCB     $80
        FCC     "OTHERS IN YOUR LIFE"
        FCB     $80
        FCC     "PREVENTING YOU FROM"
        FCB     $80
        FCC     "MAKING THE PROGRESS"
        FCB     $80
        FCC     "YOU FEEL YOU"
        FCB     $80
        FCC     "DESERVE."
        FCB     $80
        FCB     $80

D395A   FCC     "YOU FEEL YOU SHOULD"
        FCB     $80
        FCC     "MAINTAIN CONTROL OF"
        FCB     $80
        FCC     "YOUR EMOTIONS ..."
        FCB     $80
        FCC     "WHICH MAY PREVENT"
        FCB     $80
        FCC     "OTHERS FROM BUILDING"
        FCB     $80
        FCC     "A CLOSE"
        FCB     $80
        FCC     "RELATIONSHIP."
        FCB     $80
        FCB     $80

D39D2   FCC     "YOUR UNIQUE TASTES"
        FCB     $80
        FCC     "ENABLE YOU TO SENSE"
        FCB     $80
        FCC     "QUALITY AND YOU"
        FCB     $80
        FCC     "OFTEN FEEL DISTURBED"
        FCB     $80
        FCC     "WHEN THIS IS"
        FCB     $80
        FCC     "QUESTIONED."
        FCB     $80
        FCB     $80

D3A38   FCC     "YOU ARE SOMETIMES A"
        FCB     $80
        FCC     "SHY INDIVIDUAL WHO"
        FCB     $80
        FCC     "IS OFTEN"
        FCB     $80
        FCC     "MISUNDERSTOOD AS TO"
        FCB     $80
        FCC     "PERSONAL FEELINGS"
        FCB     $80
        FCC     "TOWARD OTHERS."
        FCB     $80
        FCB     $80

D3A9E   FCC     "DIFFICULTY IN FULLY"
        FCB     $80
        FCC     "EXPRESSING YOURSELF"
        FCB     $80
        FCC     "OFTEN LEAVES YOU"
        FCB     $80
        FCC     "FEELING LEFT OUT."
        FCB     $80
        FCB     $80

D3AEA   FCC     "YOU EXPECT OTHERS TO"
        FCB     $80
        FCC     "PERFORM EQUALLY TO"
        FCB     $80
        FCC     "YOUR OWN ABILITIES"
        FCB     $80
        FCC     "... THIS OFTEN LEADS"
        FCB     $80
        FCC     "TO DISAPPOINTMENT."
        FCB     $80
        FCB     $80

D3B4E   FCC     "PERHAPS YOU FEEL"
        FCB     $80
        FCC     "SOMETHING IS MISSING"
        FCB     $80
        FCC     "IN YOUR LIFE ..."
        FCB     $80
        FCC     "SOMETHING TO PUSH"
        FCB     $80
        FCC     "YOU ONWARD WITH"
        FCB     $80
        FCC     "GREAT DRIVE."
        FCB     $80
        FCB     $80

D3BB5   FCC     "YOU HAVE BEEN"
        FCB     $80
        FCC     "ACCEPTING"
        FCB     $80
        FCC     "DISAPPOINTING"
        FCB     $80
        FCC     "SITUATIONS TO"
        FCB     $80
        FCC     "ACHIEVE FREEDOM FROM"
        FCB     $80
        FCC     "OUTSIDE PRESSURE."
        FCB     $80
        FCB     $80

D3C11   FCC     "YOU FEEL ADAPTATION"
        FCB     $80
        FCC     "TO SITUATIONS IN"
        FCB     $80
        FCC     "YOUR LIFE IS ONE"
        FCB     $80
        FCC     "SOLUTION TOWARD"
        FCB     $80
        FCC     "SOLVING"
        FCB     $80
        FCC     "DIFFICULTIES."
        FCB     $80
        FCB     $80

D3C6E   FCC     "YOU KNOW YOU DESIRE"
        FCB     $80
        FCC     "MORE FROM LIFE THAN"
        FCB     $80
        FCC     "YOU ARE RECEIVING"
        FCB     $80
        FCC     "... BUT TEMPORARY"
        FCB     $80
        FCC     "ACCEPTANCE OF YOUR"
        FCB     $80
        FCC     "CONDITIONS IS OFTEN"
        FCB     $80
        FCC     "YOUR ATTITUDE."
        FCB     $80
        FCB     $80

D3CF1   FCC     "YOU HAVE A STRONG"
        FCB     $80
        FCC     "NEED TO LOOK ON THE"
        FCB     $80
        FCC     "BRIGHT SIDE AND TO"
        FCB     $80
        FCC     "FIND THE POSITIVE"
        FCB     $80
        FCC     "ATTRIBUTES AND"
        FCB     $80
        FCC     "TALENTS OF YOURSELF."
        FCB     $80
        FCB     $80

D3D61   FCC     "YOU ARE SOMEWHAT"
        FCB     $80
        FCC     "DISAPPOINTED WITH"
        FCB     $80
        FCC     "THE PRESENT STATE OF"
        FCB     $80
        FCC     "AFFAIRS AND FEEL"
        FCB     $80
        FCC     "THAT ACHIEVEMENT OF"
        FCB     $80
        FCC     "YOUR GOALS MUST BE"
        FCB     $80
        FCC     "POSTPONED."
        FCB     $80
        FCB     $80

D3DDD   FCC     "YOU SEEK SECURITY"
        FCB     $80
        FCC     "WITHOUT TURMOIL."
        FCB     $80
        FCB     $80

D3E01   FCC     "YOU ARE NOT"
        FCB     $80
        FCC     "RECEIVING AGREEMENT"
        FCB     $80
        FCC     "FROM OTHERS WHICH"
        FCB     $80
        FCC     "LEADS YOU TO FEEL"
        FCB     $80
        FCC     "ANNOYED AND"
        FCB     $80
        FCC     "FRUSTRATED."
        FCB     $80
        FCB     $80

D3E5E   FCC     "YOU HAVE BEEN"
        FCB     $80
        FCC     "ACCEPTING"
        FCB     $80
        FCC     "DISAPPOINTING"
        FCB     $80
        FCC     "SITUATIONS TO"
        FCB     $80
        FCC     "ACHIEVE FREEDOM FROM"
        FCB     $80
        FCC     "OUTSIDE PRESSURE."
        FCB     $80
        FCB     $80

D3EBA   FCC     "YOU ARE CONFUSED AS"
        FCB     $80
        FCC     "TO WHETHER YOUR"
        FCB     $80
        FCC     "GOALS ARE REALISTIC"
        FCB     $80
        FCC     "OR IMAGINARY."
        FCB     $80
        FCB     $80

D3F01   FCC     "YOU ARE A UNIQUE"
        FCB     $80
        FCC     "PERSON WHO WILL"
        FCB     $80
        FCC     "DEFEND YOUR IDEAS"
        FCB     $80
        FCC     "WHEN THEY ARE"
        FCB     $80
        FCC     "CHALLENGED."
        FCB     $80
        FCB     $80

D3F4F   FCC     "YOU HAVE SOME"
        FCB     $80
        FCC     "SITUATIONS CAUSING"
        FCB     $80
        FCC     "STRESS AND SOLUTIONS"
        FCB     $80
        FCC     "ARE EXTREMELY"
        FCB     $80
        FCC     "DESIRABLE."
        FCB     $80
        FCB     $80

D3F9F   FCC     "CIRCUMSTANCES IN"
        FCB     $80
        FCC     "YOUR LIFE APPEAR TO"
        FCB     $80
        FCC     "BE PREVENTING YOU"
        FCB     $80
        FCC     "FROM PROGRESSING ..."
        FCB     $80
        FCC     "BELIEVING IN"
        FCB     $80
        FCC     "YOURSELF WILL"
        FCB     $80
        FCC     "PROVIDE YOU"
        FCB     $80
        FCC     "STRENGTH."
        FCB     $80
        FCB     $80

D401D   FCC     "YOU FEEL THE NEED"
        FCB     $80
        FCC     "FOR A VACATION OR"
        FCB     $80
        FCC     "CHANGE IN"
        FCB     $80
        FCC     "ENVIRONMENT ... TO"
        FCB     $80
        FCC     "RELIEVE YOURSELF OF"
        FCB     $80
        FCC     "BURDENS."
        FCB     $80
        FCB     $80

D407C   FCC     "YOU ARE A VERY"
        FCB     $80
        FCC     "PRECISE PERSON WHO"
        FCB     $80
        FCC     "EXPECTS OTHERS TO"
        FCB     $80
        FCC     "PERFORM EQUALLY AS"
        FCB     $80
        FCC     "WELL AS YOUR"
        FCB     $80
        FCC     "CAPABILITIES."
        FCB     $80
        FCB     $80

D40DF   FCC     "YOU ARE CONSIDERED"
        FCB     $80
        FCC     "AN AGREEABLE PERSON"
        FCB     $80
        FCC     "EVEN WHEN TIMES ARE"
        FCB     $80
        FCC     "DIFFICULT."
        FCB     $80
        FCB     $80

D4126   FCC     "YOU ARE VERY EXCITED"
        FCB     $80
        FCC     "ABOUT ACHIEVING MORE"
        FCB     $80
        FCC     "OUT OF LIFE ..."
        FCB     $80
        FCC     "BUILDING YOUR"
        FCB     $80
        FCC     "SELF-CONFIDENCE CAN"
        FCB     $80
        FCC     "HELP YOU REACH THOSE"
        FCB     $80
        FCC     "GOALS."
        FCB     $80
        FCB     $80

D419F   FCC     "YOU ENJOY SOMEONE"
        FCB     $80
        FCC     "COMPLIMENTING YOUR"
        FCB     $80
        FCC     "PROGRESS AND FEEL"
        FCB     $80
        FCC     "THREATENED WHEN IT"
        FCB     $80
        FCC     "IS NOT RECOGNIZED."
        FCB     $80
        FCB     $80

D41FD   FCC     "YOUR EXCELLENT"
        FCB     $80
        FCC     "CHOICE OF ASSOCIATES"
        FCB     $80
        FCC     "AND PARTNERS HELPS"
        FCB     $80
        FCC     "PROTECT YOU FROM"
        FCB     $80
        FCC     "DIFFICULTIES."
        FCB     $80
        FCB     $80

D4254   FCC     "YOU HAVE STRONG"
        FCB     $80
        FCC     "SELF-CONFIDENCE IN"
        FCB     $80
        FCC     "YOURSELF EVEN WHEN"
        FCB     $80
        FCC     "SITUATIONS APPEAR TO"
        FCB     $80
        FCC     "BE GOING AGAINST"
        FCB     $80
        FCC     "YOU."
        FCB     $80
        FCB     $80

D42B6   FCC     "YOU ENJOY ADMIRATION"
        FCB     $80
        FCC     "AND COMPLIMENTS ..."
        FCB     $80
        FCC     "AND WILL GO OUT OF"
        FCB     $80
        FCC     "YOUR WAY TO AVOID"
        FCB     $80
        FCC     "DISAGREEMENT WITH"
        FCB     $80
        FCC     "OTHERS."
        FCB     $80
        FCB     $80

D431F   FCC     "YOUR UNIQUE TASTES"
        FCB     $80
        FCC     "ENABLE YOU TO SENSE"
        FCB     $80
        FCC     "QUALITY AND YOU"
        FCB     $80
        FCC     "OFTEN FEEL DISTURBED"
        FCB     $80
        FCC     "WHEN THIS IS"
        FCB     $80
        FCC     "QUESTIONED."
        FCB     $80
        FCB     $80

D4385   FCC     "YOU KNOW YOU DESIRE"
        FCB     $80
        FCC     "MORE FROM LIFE THAN"
        FCB     $80
        FCC     "YOU ARE RECEIVING"
        FCB     $80
        FCC     "... BUT TEMPORARY"
        FCB     $80
        FCC     "ACCEPTANCE OF YOUR"
        FCB     $80
        FCC     "CONDITIONS IS OFTEN"
        FCB     $80
        FCC     "YOUR ATTITUDE."
        FCB     $80
        FCB     $80

D4408   FCC     "YOU ARE A UNIQUE"
        FCB     $80
        FCC     "PERSON WHO WILL"
        FCB     $80
        FCC     "DEFEND YOUR IDEAS"
        FCB     $80
        FCC     "WHEN THEY ARE"
        FCB     $80
        FCC     "CHALLENGED."
        FCB     $80
        FCB     $80

D4456   FCC     "YOU ENJOY SOMEONE"
        FCB     $80
        FCC     "COMPLIMENTING YOUR"
        FCB     $80
        FCC     "PROGRESS AND FEEL"
        FCB     $80
        FCC     "THREATENED WHEN IT"
        FCB     $80
        FCC     "IS NOT RECOGNIZED."
        FCB     $80
        FCB     $80

D44B4   FCC     "YOU SEE YOURSELF AS"
        FCB     $80
        FCC     "A UNIQUE PERSON AND"
        FCB     $80
        FCC     "ENJOY BEING"
        FCB     $80
        FCC     "RECOGNIZED."
        FCB     $80
        FCB     $80

D44F5   FCC     "YOU INVOLVE YOURSELF"
        FCB     $80
        FCC     "IN PERSONAL"
        FCB     $80
        FCC     "RELATIONSHIPS WITH"
        FCB     $80
        FCC     "CAUTION."
        FCB     $80
        FCB     $80

D4533   FCC     "YOU BELIEVE"
        FCB     $80
        FCC     "RELATIONSHIPS SHOULD"
        FCB     $80
        FCC     "BE FOUNDED ON TOTAL"
        FCB     $80
        FCC     "LOVE."
        FCB     $80
        FCB     $80

D456F   FCC     "SOME SITUATIONS CAN"
        FCB     $80
        FCC     "STIR GREAT"
        FCB     $80
        FCC     "EXCITEMENT IN YOU"
        FCB     $80
        FCC     "... AND AT OTHER"
        FCB     $80
        FCC     "TIMES YOU BECOME"
        FCB     $80
        FCC     "NOTHING MORE THAN A"
        FCB     $80
        FCC     "SPECTATOR."
        FCB     $80
        FCB     $80

D45E2   FCC     "YOU HAVE A STRONG"
        FCB     $80
        FCC     "NEED TO LOOK ON THE"
        FCB     $80
        FCC     "BRIGHT SIDE AND TO"
        FCB     $80
        FCC     "FIND THE POSITIVE"
        FCB     $80
        FCC     "ATTRIBUTES AND"
        FCB     $80
        FCC     "TALENTS OF YOURSELF."
        FCB     $80
        FCB     $80

D4652   FCC     "YOU HAVE SOME"
        FCB     $80
        FCC     "SITUATIONS CAUSING"
        FCB     $80
        FCC     "STRESS AND SOLUTIONS"
        FCB     $80
        FCC     "ARE EXTREMELY"
        FCB     $80
        FCC     "DESIRABLE."
        FCB     $80
        FCB     $80

D46A2   FCC     "YOUR EXCELLENT"
        FCB     $80
        FCC     "CHOICE OF ASSOCIATES"
        FCB     $80
        FCC     "AND PARTNERS HELPS"
        FCB     $80
        FCC     "PROTECT YOU FROM"
        FCB     $80
        FCC     "DIFFICULTIES."
        FCB     $80
        FCB     $80

D46F9   FCC     "YOU SEE YOURSELF AS"
        FCB     $80
        FCC     "A UNIQUE PERSON AND"
        FCB     $80
        FCC     "ENJOY BEING"
        FCB     $80
        FCC     "RECOGNIZED."
        FCB     $80
        FCB     $80

D473A   FCC     "YOU HAVE BEEN"
        FCB     $80
        FCC     "ACCEPTING EXISTING"
        FCB     $80
        FCC     "SITUATONS EVEN"
        FCB     $80
        FCC     "THOUGH THEY MAY BE"
        FCB     $80
        FCC     "UNDESIRABLE."
        FCB     $80
        FCB     $80

D478B   FCC     "YOU ARE AN EXCITING"
        FCB     $80
        FCC     "AND COOPERATIVE"
        FCB     $80
        FCC     "INDIVIDUAL WHO CAN"
        FCB     $80
        FCC     "BE HELPFUL TO"
        FCB     $80
        FCC     "FRIENDS AS WELL AS"
        FCB     $80
        FCC     "TO FELLOW WORKERS."
        FCB     $80
        FCB     $80

D47F7   FCC     "DIFFICULTY IN FULLY"
        FCB     $80
        FCC     "EXPRESSING YOURSELF"
        FCB     $80
        FCC     "OFTEN LEAVES YOU"
        FCB     $80
        FCC     "FEELING LEFT OUT."
        FCB     $80
        FCB     $80

D4843   FCC     "YOU ARE SOMEWHAT"
        FCB     $80
        FCC     "DISAPPOINTED WITH"
        FCB     $80
        FCC     "THE PRESENT STATE OF"
        FCB     $80
        FCC     "AFFAIRS AND FEEL"
        FCB     $80
        FCC     "THAT ACHIEVEMENT OF"
        FCB     $80
        FCC     "YOUR GOALS MUST BE"
        FCB     $80
        FCC     "POSTPONED."
        FCB     $80
        FCB     $80

D48BF   FCC     "CIRCUMSTANCES IN"
        FCB     $80
        FCC     "YOUR LIFE APPEAR TO"
        FCB     $80
        FCC     "BE PREVENTING YOU"
        FCB     $80
        FCC     "FROM PROGRESSING ..."
        FCB     $80
        FCC     "BELIEVING IN"
        FCB     $80
        FCC     "YOURSELF WILL"
        FCB     $80
        FCC     "PROVIDE YOU"
        FCB     $80
        FCC     "STRENGTH."
        FCB     $80
        FCB     $80

D493D   FCC     "YOU HAVE STRONG"
        FCB     $80
        FCC     "SELF-CONFIDENCE IN"
        FCB     $80
        FCC     "YOURSELF EVEN WHEN"
        FCB     $80
        FCC     "SITUATIONS APPEAR TO"
        FCB     $80
        FCC     "BE GOING AGAINST"
        FCB     $80
        FCC     "YOU."
        FCB     $80
        FCB     $80

D499F   FCC     "YOU INVOLVE YOURSELF"
        FCB     $80
        FCC     "IN PERSONAL"
        FCB     $80
        FCC     "RELATIONSHIPS WITH"
        FCB     $80
        FCC     "CAUTION."
        FCB     $80
        FCB     $80

D49DD   FCC     "YOU HAVE BEEN"
        FCB     $80
        FCC     "ACCEPTING EXISTING"
        FCB     $80
        FCC     "SITUATIONS EVEN"
        FCB     $80
        FCC     "THOUGH THEY MAY BE"
        FCB     $80
        FCC     "UNDESIRABLE."
        FCB     $80
        FCB     $80

D4A2F   FCC     "YOU HAVE BEEN"
        FCB     $80
        FCC     "ADAPTING TO"
        FCB     $80
        FCC     "SITUATIONS IN YOUR"
        FCB     $80
        FCC     "LIFE TO PREVENT"
        FCB     $80
        FCC     "ADDITIONAL STRESS."
        FCB     $80
        FCB     $80

D4A80   FCC     "YOU EXPECT OTHERS TO"
        FCB     $80
        FCC     "PERFORM EQUALLY TO"
        FCB     $80
        FCC     "YOUR OWN ABILITIES"
        FCB     $80
        FCC     "... THIS OFTEN LEADS"
        FCB     $80
        FCC     "TO DISAPPOINTMENT."
        FCB     $80
        FCB     $80

D4AE4   FCC     "YOU SEEK SECURITY"
        FCB     $80
        FCC     "WITHOUT TURMOIL."
        FCB     $80
        FCB     $80

D4B08   FCC     "YOU FEEL THE NEED"
        FCB     $80
        FCC     "FOR A VACATION OR"
        FCB     $80
        FCC     "CHANGE IN"
        FCB     $80
        FCC     "ENVIRONMENT ... TO"
        FCB     $80
        FCC     "RELIEVE YOURSELF OF"
        FCB     $80
        FCC     "BURDENS."
        FCB     $80
        FCB     $80

D4B67   FCC     "YOU ENJOY ADMIRATION"
        FCB     $80
        FCC     "AND COMPLIMENTS ..."
        FCB     $80
        FCC     "AND WILL GO OUT OF"
        FCB     $80
        FCC     "YOUR WAY TO AVOID"
        FCB     $80
        FCC     "DISAGREEMENT WITH"
        FCB     $80
        FCC     "OTHERS."
        FCB     $80
        FCB     $80

D4BD0   FCC     "YOU BELIEVE"
        FCB     $80
        FCC     "RELATIONSHIPS SHOULD"
        FCB     $80
        FCC     "BE FOUNDED ON TOTAL"
        FCB     $80
        FCC     "LOVE."
        FCB     $80
        FCB     $80

D4C0C   FCC     "YOU ARE AN EXCITING"
        FCB     $80
        FCC     "AND COOPERATIVE"
        FCB     $80
        FCC     "INDIVIDUAL WHO CAN"
        FCB     $80
        FCC     "BE HELPFUL TO"
        FCB     $80
        FCC     "FRIENDS AS WELL AS"
        FCB     $80
        FCC     "TO FELLOW WORKERS."
        FCB     $80
        FCB     $80

D4C78   FCC     "YOU HAVE BEEN"
        FCB     $80
        FCC     "ADAPTING TO"
        FCB     $80
        FCC     "SITUATIONS IN YOUR"
        FCB     $80
        FCC     "LIFE TO PREVENT"
        FCB     $80
        FCC     "ADDITIONAL STRESS."
        FCB     $80
        FCB     $80

D4CC9   FCC     "AN EXISTING"
        FCB     $80
        FCC     "SITUATION IN YOUR"
        FCB     $80
        FCC     "LIFE HAS CONTINUALLY"
        FCB     $80
        FCC     "PRODUCED UPSETS ..."
        FCB     $80
        FCC     "AND YOU FEEL TIRED"
        FCB     $80
        FCC     "FROM YOUR INABILITY"
        FCB     $80
        FCC     "TO CHANGE THE"
        FCB     $80
        FCC     "SITUATION."
        FCB     $80
        FCB     $80

D4D51   FCC     "YOU HAVE HAD A"
        FCB     $80
        FCC     "DEFEATED ATTITUDE IN"
        FCB     $80
        FCC     "SOME RELATION OR"
        FCB     $80
        FCC     "SITUATION WHICH HAS"
        FCB     $80
        FCC     "CONTINUED TO DRAIN"
        FCB     $80
        FCC     "YOUR ENERGY ..."
        FCB     $80
        FCC     "PRODUCING OUTBURSTS"
        FCB     $80
        FCC     "OR EXPRESSIONS OF"
        FCB     $80
        FCC     "DISAGREEMENT FROM"
        FCB     $80
        FCC     "YOU."
        FCB     $80
        FCB     $80

D4DFB   FCC     "YOU HAVE BEEN"
        FCB     $80
        FCC     "FEELING STRONGER"
        FCB     $80
        FCC     "THRU EXERCISING"
        FCB     $80
        FCC     "SELF-CONTROL IN AN"
        FCB     $80
        FCC     "EXISTING SITUATION"
        FCB     $80
        FCC     "OR RELATIONSHIP."
        FCB     $80
        FCB     $80

D4E62   FCC     "YOU RECOGNIZE THERE"
        FCB     $80
        FCC     "IS A PROBLEM IN YOUR"
        FCB     $80
        FCC     "LIFE ... YOU FEEL IT"
        FCB     $80
        FCC     "HAS BEEN CREATED"
        FCB     $80
        FCC     "THRU BREAKDOWN IN"
        FCB     $80
        FCC     "COMMUNICATION WITH"
        FCB     $80
        FCC     "ANOTHER PERSON."
        FCB     $80
        FCB     $80

D4EE7   FCC     "YOU ARE A"
        FCB     $80
        FCC     "SELF-CONTAINED"
        FCB     $80
        FCC     "PERSON WHO POSSESSES"
        FCB     $80
        FCC     "INNER STRENGTH TO"
        FCB     $80
        FCC     "CARRY YOU THROUGH"
        FCB     $80
        FCC     "MOST DIFFICULT"
        FCB     $80
        FCC     "TIMES."
        FCB     $80
        FCB     $80

D4F50   FCC     "PERSONAL FATIGUE HAS"
        FCB     $80
        FCC     "PREVENTED YOU FROM"
        FCB     $80
        FCC     "BEING AS LOVING AND"
        FCB     $80
        FCC     "GIVING AS YOU ARE"
        FCB     $80
        FCC     "CAPABLE OF BEING ..."
        FCB     $80
        FCC     "THINK THROUGH YOUR"
        FCB     $80
        FCC     "SITUATION AND"
        FCB     $80
        FCC     "COMMUNICATE YOUR"
        FCB     $80
        FCC     "FEELINGS."
        FCB     $80
        FCB     $80

D4FF0   FCC     "SITUATIONS IN YOUR"
        FCB     $80
        FCC     "LIFE ARE CAUSING"
        FCB     $80
        FCC     "PROBLEMS CREATING AN"
        FCB     $80
        FCC     "URGENCY FOR CHANGES."
        FCB     $80
        FCB     $80

D503F   FCC     "YOU ARE FEELING"
        FCB     $80
        FCC     "FRUSTRATED FROM THE"
        FCB     $80
        FCC     "PRESSURES PRESENTED"
        FCB     $80
        FCC     "YOU BY ANOTHER"
        FCB     $80
        FCC     "INDIVIDUAL AND WOULD"
        FCB     $80
        FCC     "LIKE VERY MUCH TO"
        FCB     $80
        FCC     "SOLVE THIS"
        FCB     $80
        FCC     "DIFFICULTY QUICKLY."
        FCB     $80
        FCB     $80

D50CD   FCC     "YOU FEEL A NEED FOR"
        FCB     $80
        FCC     "REST TO ENABLE YOU"
        FCB     $80
        FCC     "TIME TO REACH PEACE"
        FCB     $80
        FCC     "WITH YOURSELF."
        FCB     $80
        FCB     $80

D5118   FCC     "THINGS HAVE NOT BEEN"
        FCB     $80
        FCC     "GOING YOUR WAY IN"
        FCB     $80
        FCC     "THE MAJOR AREAS OF"
        FCB     $80
        FCC     "YOUR LIFE ... AND TO"
        FCB     $80
        FCC     "RELIEVE THE PRESSURE"
        FCB     $80
        FCC     "YOU HAVE BEEN"
        FCB     $80
        FCC     "SEEKING FUN THINGS"
        FCB     $80
        FCC     "TO DO."
        FCB     $80
        FCB     $80

D51A5   FCC     "YOUR INNER STRENGTH"
        FCB     $80
        FCC     "IS FED THROUGH"
        FCB     $80
        FCC     "ACKNOWLEDGMENT FROM"
        FCB     $80
        FCC     "OTHERS ... AND YOU"
        FCB     $80
        FCC     "ARE VERY SENSITIVE"
        FCB     $80
        FCC     "TO NEGATIVE COMMENTS"
        FCB     $80
        FCC     "MADE TO YOU BY"
        FCB     $80
        FCC     "OTHERS."
        FCB     $80
        FCB     $80

D522F   FCC     "YOU ARE A VERY"
        FCB     $80
        FCC     "DETERMINED AND"
        FCB     $80
        FCC     "UNWAVERING"
        FCB     $80
        FCC     "INDIVIDUAL WHO MUST"
        FCB     $80
        FCC     "BE RECOGNIZED FOR"
        FCB     $80
        FCC     "YOUR ABILITIES AND"
        FCB     $80
        FCC     "ACCOMPLISHMENTS."
        FCB     $80
        FCB     $80

D52A3   FCC     "YOU WOULD LOVE TO BE"
        FCB     $80
        FCC     "FREE TO ACCOMPLISH"
        FCB     $80
        FCC     "MORE IN YOUR LIFE"
        FCB     $80
        FCC     "... SITUATIONS ARE"
        FCB     $80
        FCC     "SUCH THAT YOU FEEL"
        FCB     $80
        FCC     "CHANGES MUST BE MADE"
        FCB     $80
        FCC     "BEFORE THIS IS IS"
        FCB     $80
        FCC     "POSSIBLE."
        FCB     $80
        FCB     $80

D5335   FCC     "DIFFICULT SITUATIONS"
        FCB     $80
        FCC     "ARE BEING POSTPONED"
        FCB     $80
        FCC     "BY YOU AT THIS TIME"
        FCB     $80
        FCC     "FOR YOU HAVE BEEN"
        FCB     $80
        FCC     "FEELING TOO"
        FCB     $80
        FCC     "EXHAUSTED TO RESOLVE"
        FCB     $80
        FCC     "THEM ... PATIENCE"
        FCB     $80
        FCC     "AND CLEAR THINKING"
        FCB     $80
        FCC     "SOLVE MANY PROBLEMS."
        FCB     $80
        FCB     $80

D53E0   FCC     "YOU HAVE HAD A"
        FCB     $80
        FCC     "DEFEATED ATTITUDE IN"
        FCB     $80
        FCC     "SOME RELATION OR"
        FCB     $80
        FCC     "SITUATION WHICH HAS"
        FCB     $80
        FCC     "CONTINUED TO DRAIN"
        FCB     $80
        FCC     "YOUR ENERGY ..."
        FCB     $80
        FCC     "PRODUCING OUTBURSTS"
        FCB     $80
        FCC     "OR EXPRESSIONS OF"
        FCB     $80
        FCC     "DISAGREEMENT FROM"
        FCB     $80
        FCC     "YOU."
        FCB     $80
        FCB     $80

D548A   FCC     "YOU FEEL A NEED FOR"
        FCB     $80
        FCC     "REST TO ENABLE YOU"
        FCB     $80
        FCC     "TIME TO REACH PEACE"
        FCB     $80
        FCC     "WITH YOURSELF."
        FCB     $80
        FCB     $80

D54D5   FCC     "YOU FEEL YOU HAVE"
        FCB     $80
        FCC     "BEEN PREVENTED FROM"
        FCB     $80
        FCC     "ACHIEVING THE"
        FCB     $80
        FCC     "SUCCESS YOU DESIRE"
        FCB     $80
        FCC     "AND IN NO WAY WILL"
        FCB     $80
        FCC     "YOU ACCEPT THIS AS A"
        FCB     $80
        FCC     "FINAL OUTCOME FOR"
        FCB     $80
        FCC     "YOUR PERSONAL"
        FCB     $80
        FCC     "ACCOMPLISHMENTS ..."
        FCB     $80
        FCC     "YOU ARE OPTIMISTIC"
        FCB     $80
        FCC     "YOU WILL PREVAIL."
        FCB     $80
        FCB     $80

D559E   FCC     "YOU FEEL THE"
        FCB     $80
        FCC     "ACHIEVEMENTS YOU"
        FCB     $80
        FCC     "HAVE SET FOR"
        FCB     $80
        FCC     "YOURSELF HAVE BEEN"
        FCB     $80
        FCC     "ESCAPING YOU AND YOU"
        FCB     $80
        FCC     "WANT TO SEE RESULTS"
        FCB     $80
        FCC     "SOON."
        FCB     $80
        FCB     $80

D560C   FCC     "YOU FEEL GREAT"
        FCB     $80
        FCC     "STRENGTH SURGES"
        FCB     $80
        FCC     "WITHIN WHEN SOMEONE"
        FCB     $80
        FCC     "IS IN AGREEMENT WITH"
        FCB     $80
        FCC     "YOU ... YOU THEN"
        FCB     $80
        FCC     "KNOW YOU CAN MASTER"
        FCB     $80
        FCC     "ANY DIFFICULTY WITH"
        FCB     $80
        FCC     "THEIR ASSISTANCE."
        FCB     $80
        FCB     $80

D56A0   FCC     "YOU FEEL THE PRESENT"
        FCB     $80
        FCC     "IS UNSATISFACTORY"
        FCB     $80
        FCC     "AND YOU ARE WORKING"
        FCB     $80
        FCC     "HARD TO BUILD A"
        FCB     $80
        FCC     "LIFE-STYLE AND"
        FCB     $80
        FCC     "POSITION TO PROVIDE"
        FCB     $80
        FCC     "YOU FREEDOM."
        FCB     $80
        FCB     $80

D571C   FCC     "YOU FEEL YOU ARE"
        FCB     $80
        FCC     "LOSING GRASP OF THE"
        FCB     $80
        FCC     "THINGS THAT HAVE"
        FCB     $80
        FCC     "VALUE IN YOUR LIFE"
        FCB     $80
        FCC     "... AND FEEL THE"
        FCB     $80
        FCC     "NEED OF ASSISTANCE"
        FCB     $80
        FCC     "FROM OTHERS TO"
        FCB     $80
        FCC     "PREVENT THIS FROM"
        FCB     $80
        FCC     "HAPPENING."
        FCB     $80
        FCB     $80

D57B6   FCC     "YOU HAVE BEEN"
        FCB     $80
        FCC     "FEELING STRONGER"
        FCB     $80
        FCC     "THRU EXERCISING"
        FCB     $80
        FCC     "SELF-CONTROL IN AN"
        FCB     $80
        FCC     "EXISTING SITUATION"
        FCB     $80
        FCC     "OR RELATIONSHIP."
        FCB     $80
        FCB     $80

D581D   FCC     "THINGS HAVE NOT BEEN"
        FCB     $80
        FCC     "GOING YOUR WAY IN"
        FCB     $80
        FCC     "THE MAJOR AREAS OF"
        FCB     $80
        FCC     "YOUR LIFE ... AND TO"
        FCB     $80
        FCC     "RELEIVE THE PRESSURE"
        FCB     $80
        FCC     "YOU HAVE BEEN"
        FCB     $80
        FCC     "SEEKING FUN THINGS"
        FCB     $80
        FCC     "TO DO."
        FCB     $80
        FCB     $80

D58AA   FCC     "YOU FEEL YOU HAVE"
        FCB     $80
        FCC     "BEEN PREVENTED FROM"
        FCB     $80
        FCC     "ACHIEVING THE"
        FCB     $80
        FCC     "SUCCESS YOU DESIRE"
        FCB     $80
        FCC     "AND IN NO WAY WILL"
        FCB     $80
        FCC     "YOU ACCEPT THIS AS A"
        FCB     $80
        FCC     "FINAL OUTCOME FOR"
        FCB     $80
        FCC     "YOUR PERSONAL"
        FCB     $80
        FCC     "ACCOMPLISHMENTS ..."
        FCB     $80
        FCC     "YOU ARE OPTIMISTIC"
        FCB     $80
        FCC     "YOU WILL PREVAIL."
        FCB     $80
        FCB     $80

D5973   FCC     "YOU HAVE BEEN"
        FCB     $80
        FCC     "SHUTTING DOORS AND"
        FCB     $80
        FCC     "MISSING OUT ON"
        FCB     $80
        FCC     "POTENTIALLY"
        FCB     $80
        FCC     "REWARDING"
        FCB     $80
        FCC     "RELATIONSHIPS OUT OF"
        FCB     $80
        FCC     "THE FEAR THAT ANY"
        FCB     $80
        FCC     "RELATIONSHIP HAS A"
        FCB     $80
        FCC     "POSSIBILITY OF"
        FCB     $80
        FCC     "HURTING YOU."
        FCB     $80
        FCB     $80

D5A10   FCC     "YOU HAVE A FEELING"
        FCB     $80
        FCC     "OF INCOMPLETENESS"
        FCB     $80
        FCC     "FROM THE LACK OF"
        FCB     $80
        FCC     "RECOGNITION FOR YOUR"
        FCB     $80
        FCC     "ABILITIES ... THIS"
        FCB     $80
        FCC     "HAS LEAD YOU TO"
        FCB     $80
        FCC     "ADOPT A MORE"
        FCB     $80
        FCC     "DETERMINED ATTITUDE"
        FCB     $80
        FCC     "TO SUCCEED."
        FCB     $80
        FCB     $80

D5AAC   FCC     "YOU SEE YOURSELF AS"
        FCB     $80
        FCC     "A FREE PERSON ..."
        FCB     $80
        FCC     "FREE TO DETERMINE"
        FCB     $80
        FCC     "YOUR OWN DESTINY AND"
        FCB     $80
        FCC     "RESENT ANY"
        FCB     $80
        FCC     "INTERFERENCE BY"
        FCB     $80
        FCC     "OTHERS WHICH SLOWS"
        FCB     $80
        FCC     "YOUR PROGRESS."
        FCB     $80
        FCB     $80

D5B37   FCC     "YOU FEEL YOU HAVE"
        FCB     $80
        FCC     "MADE MISTAKES BY NOT"
        FCB     $80
        FCC     "ACTING QUICKLY ON"
        FCB     $80
        FCC     "OPPORTUNITIES ..."
        FCB     $80
        FCC     "AND YOU ARE"
        FCB     $80
        FCC     "DETERMINED YOU WILL"
        FCB     $80
        FCC     "NOT LET ANOTHER"
        FCB     $80
        FCC     "POTENTIAL"
        FCB     $80
        FCC     "OPPORTUNITY PASS YOU"
        FCB     $80
        FCC     "BY."
        FCB     $80
        FCB     $80

D5BD6   FCC     "YOU RECOGNIZE THERE"
        FCB     $80
        FCC     "IS A PROBLEM IN YOUR"
        FCB     $80
        FCC     "LIFE ... YOU FEEL IT"
        FCB     $80
        FCC     "HAS BEEN CREATED"
        FCB     $80
        FCC     "THRU BREAKDOWN IN"
        FCB     $80
        FCC     "COMMUNICATION WITH"
        FCB     $80
        FCC     "ANOTHER PERSON."
        FCB     $80
        FCB     $80

D5C5B   FCC     "YOUR INNER STRENGTH"
        FCB     $80
        FCC     "IS FED THROUGH"
        FCB     $80
        FCC     "ACKNOWLEDGMENT FROM"
        FCB     $80
        FCC     "OTHERS ... AND YOU"
        FCB     $80
        FCC     "ARE VERY SENSITIVE"
        FCB     $80
        FCC     "TO NEGATIVE COMMENTS"
        FCB     $80
        FCC     "MADE TO YOU BY"
        FCB     $80
        FCC     "OTHERS."
        FCB     $80
        FCB     $80

D5CE5   FCC     "YOU FEEL THE"
        FCB     $80
        FCC     "ACHIEVEMENTS YOU"
        FCB     $80
        FCC     "HAVE SET FOR"
        FCB     $80
        FCC     "YOURSELF HAVE BEEN"
        FCB     $80
        FCC     "ESCAPING YOU AND YOU"
        FCB     $80
        FCC     "WANT TO SEE RESULTS"
        FCB     $80
        FCC     "SOON."
        FCB     $80
        FCB     $80

D5D53   FCC     "YOU HAVE BEEN"
        FCB     $80
        FCC     "SHUTTING DOORS AND"
        FCB     $80
        FCC     "MISSING OUT ON"
        FCB     $80
        FCC     "POTENTIALLY"
        FCB     $80
        FCC     "REWARDING"
        FCB     $80
        FCC     "RELATIONSHIPS OUT OF"
        FCB     $80
        FCC     "THE FEAR THAT ANY"
        FCB     $80
        FCC     "RELATIONSHIP HAS A"
        FCB     $80
        FCC     "POSSIBILITY OF"
        FCB     $80
        FCC     "HURTING YOU."
        FCB     $80
        FCB     $80

D5DF0   FCC     "YOU ARE INDEED A"
        FCB     $80
        FCC     "VERY TALENTED AND"
        FCB     $80
        FCC     "SPECIAL PERSON ... A"
        FCB     $80
        FCC     "PERSON CAPABLE OF"
        FCB     $80
        FCC     "MAKING POSITIVE"
        FCB     $80
        FCC     "CONTRIBUTIONS IN ANY"
        FCB     $80
        FCC     "AREA YOU CHOOSE ..."
        FCB     $80
        FCC     "LIFE IS EXCITING FOR"
        FCB     $80
        FCC     "YOU."
        FCB     $80
        FCB     $80

D5E8E   FCC     "YOU ARE A"
        FCB     $80
        FCC     "FREE-SPIRITED"
        FCB     $80
        FCC     "INDIVIDUAL WHO HAS"
        FCB     $80
        FCC     "THE ABILITY TO"
        FCB     $80
        FCC     "ACCEPT CONSTRUCTIVE"
        FCB     $80
        FCC     "CRITICISM FROM"
        FCB     $80
        FCC     "OTHERS AND ENJOY"
        FCB     $80
        FCC     "COMMUNICATING WITH"
        FCB     $80
        FCC     "PLAIN TALK."
        FCB     $80
        FCB     $80

D5F1C   FCC     "YOU OFTEN FEEL"
        FCB     $80
        FCC     "OTHERS HAVE TAKEN"
        FCB     $80
        FCC     "ADVANTAGE OF YOU ..."
        FCB     $80
        FCC     "AND NOW YOU TAKE A"
        FCB     $80
        FCC     "POSITION OF"
        FCB     $80
        FCC     "EXAMINING THEIR"
        FCB     $80
        FCC     "MOTIVES MORE"
        FCB     $80
        FCC     "CAREFULLY BEFORE"
        FCB     $80
        FCC     "AGREEING WITH THEM."
        FCB     $80
        FCB     $80

D5FB4   FCC     "YOU ARE A"
        FCB     $80
        FCC     "SELF-CONTAINED"
        FCB     $80
        FCC     "PERSON WHO POSSESSES"
        FCB     $80
        FCC     "INNER STRENGTH TO"
        FCB     $80
        FCC     "CARRY YOU THROUGH"
        FCB     $80
        FCC     "MOST DIFFICULT"
        FCB     $80
        FCC     "TIMES."
        FCB     $80
        FCB     $80

D601D   FCC     "YOU ARE A VERY"
        FCB     $80
        FCC     "DETERMINED AND"
        FCB     $80
        FCC     "UNWAVERING"
        FCB     $80
        FCC     "INDIVIDUAL WHO MUST"
        FCB     $80
        FCC     "BE RECOGNIZED FOR"
        FCB     $80
        FCC     "YOUR ABILITIES AND"
        FCB     $80
        FCC     "ACCOMPLISHMENTS."
        FCB     $80
        FCB     $80

D6091   FCC     "YOU FEEL GREAT"
        FCB     $80
        FCC     "STRENGTH SURGES"
        FCB     $80
        FCC     "WITHIN WHEN SOMEONE"
        FCB     $80
        FCC     "IS IN AGREEMENT WITH"
        FCB     $80
        FCC     "YOU ... YOU THEN"
        FCB     $80
        FCC     "KNOW YOU CAN MASTER"
        FCB     $80
        FCC     "ANY DIFFICULTY WITH"
        FCB     $80
        FCC     "THEIR ASSISTANCE."
        FCB     $80
        FCB     $80

D6125   FCC     "YOU HAVE A FEELING"
        FCB     $80
        FCC     "OF INCOMPLETENESS"
        FCB     $80
        FCC     "FROM THE LACK OF"
        FCB     $80
        FCC     "RECOGNITION FOR YOUR"
        FCB     $80
        FCC     "ABILITIES ... THIS"
        FCB     $80
        FCC     "HAS LEAD YOU TO"
        FCB     $80
        FCC     "ADOPT A MORE"
        FCB     $80
        FCC     "DETERMINED ATTITUDE"
        FCB     $80
        FCC     "TO SUCCEED."
        FCB     $80
        FCB     $80

D61C1   FCC     "YOU ARE INDEED A"
        FCB     $80
        FCC     "VERY TALENTED AND"
        FCB     $80
        FCC     "SPECIAL PERSON ... A"
        FCB     $80
        FCC     "PERSON CAPABLE OF"
        FCB     $80
        FCC     "MAKING POSITIVE"
        FCB     $80
        FCC     "CONTRIBUTIONS IN ANY"
        FCB     $80
        FCC     "AREA YOU CHOOSE ..."
        FCB     $80
        FCC     "LIFE IS EXCITING FOR"
        FCB     $80
        FCC     "YOU."
        FCB     $80
        FCB     $80

D625F   FCC     "YOU ARE DETERMINED"
        FCB     $80
        FCC     "TO ACCOMPLISH"
        FCB     $80
        FCC     "WHATEVER IS"
        FCB     $80
        FCC     "NECESSARY IN LIFE TO"
        FCB     $80
        FCC     "PROVIDE YOU WITH"
        FCB     $80
        FCC     "FREEDOM TO GRASP"
        FCB     $80
        FCC     "OPPORTUNITIES YOU"
        FCB     $80
        FCC     "SEE."
        FCB     $80
        FCB     $80

D62DB   FCC     "YOU ARE A RARE"
        FCB     $80
        FCC     "PERSON ... YOU CAN"
        FCB     $80
        FCC     "BE LOOKED UP TO AND"
        FCB     $80
        FCC     "RECOGNIZED AS A"
        FCB     $80
        FCC     "LEADER."
        FCB     $80
        FCB     $80

D632A   FCC     "PERSONAL FATIGUE HAS"
        FCB     $80
        FCC     "PREVENTED YOU FROM"
        FCB     $80
        FCC     "BEING AS LOVING AND"
        FCB     $80
        FCC     "GIVING AS YOU ARE"
        FCB     $80
        FCC     "CAPABLE OF BEING ..."
        FCB     $80
        FCC     "THINK THROUGH YOUR"
        FCB     $80
        FCC     "SITUATION AND"
        FCB     $80
        FCC     "COMMUNICATE YOUR"
        FCB     $80
        FCC     "FEELINGS."
        FCB     $80
        FCB     $80

D63CA   FCC     "YOU WOULD LOVE TO BE"
        FCB     $80
        FCC     "FREE TO ACCOMPLISH"
        FCB     $80
        FCC     "MORE IN YOUR LIFE"
        FCB     $80
        FCC     "... SITUATIONS ARE"
        FCB     $80
        FCC     "SUCH THAT YOU FEEL"
        FCB     $80
        FCC     "CHANGES MUST BE MADE"
        FCB     $80
        FCC     "BEFORE THIS IS"
        FCB     $80
        FCC     "POSSIBLE."
        FCB     $80
        FCB     $80

D6459   FCC     "YOU FEEL THE PRESENT"
        FCB     $80
        FCC     "IS UNSATISFACTORY"
        FCB     $80
        FCC     "AND YOU ARE WORKING"
        FCB     $80
        FCC     "HARD TO BUILD A"
        FCB     $80
        FCC     "LIFE-STYLE AND"
        FCB     $80
        FCC     "POSITION TO PROVIDE"
        FCB     $80
        FCC     "YOU FREEDOM."
        FCB     $80
        FCB     $80

D64D5   FCC     "YOU SEE YOURSELF AS"
        FCB     $80
        FCC     "A FREE PERSON ..."
        FCB     $80
        FCC     "FREE TO DETERMINE"
        FCB     $80
        FCC     "YOUR OWN DESTINY AND"
        FCB     $80
        FCC     "RESENT ANY"
        FCB     $80
        FCC     "INTERFERENCE BY"
        FCB     $80
        FCC     "OTHERS WHICH SLOWS"
        FCB     $80
        FCC     "YOUR PROGRESS."
        FCB     $80
        FCB     $80

D6560   FCC     "YOU ARE A"
        FCB     $80
        FCC     "FREE-SPIRITED"
        FCB     $80
        FCC     "INDIVIDUAL WHO HAS"
        FCB     $80
        FCC     "THE ABILITY TO"
        FCB     $80
        FCC     "ACCEPT CONSTRUCTIVE"
        FCB     $80
        FCC     "CRITICISM FROM"
        FCB     $80
        FCC     "OTHERS AND ENJOY"
        FCB     $80
        FCC     "COMMUNICATING WITH"
        FCB     $80
        FCC     "PLAIN TALK."
        FCB     $80
        FCB     $80

D65EE   FCC     "YOU ARE DETERMINED"
        FCB     $80
        FCC     "TO ACCOMPLISH"
        FCB     $80
        FCC     "WHATEVER IS"
        FCB     $80
        FCC     "NECESSARY IN LIFE TO"
        FCB     $80
        FCC     "PROVIDE YOU WITH"
        FCB     $80
        FCC     "FREEDOM TO GRASP"
        FCB     $80
        FCC     "OPPORTUNITIES YOU"
        FCB     $80
        FCC     "SEE."
        FCB     $80
        FCB     $80

D666A   FCC     "YOU HAVE A WIDE"
        FCB     $80
        FCC     "VARIETY OF INTERESTS"
        FCB     $80
        FCC     "... AND YOU"
        FCB     $80
        FCC     "CONTINUALLY EXPAND"
        FCB     $80
        FCC     "YOUR SPECTRUM OF"
        FCB     $80
        FCC     "KNOWLEDGE TO ASSIST"
        FCB     $80
        FCC     "OTHERS."
        FCB     $80
        FCB     $80

D66DC   FCC     "SITUATIONS IN YOUR"
        FCB     $80
        FCC     "LIFE ARE CAUSING"
        FCB     $80
        FCC     "PROBLEMS CREATING AN"
        FCB     $80
        FCC     "URGENCY FOR CHANGES."
        FCB     $80
        FCB     $80

D672B   FCC     "DIFFICULT SITUATIONS"
        FCB     $80
        FCC     "ARE BEING POSTPONED"
        FCB     $80
        FCC     "BY YOU AT THIS TIME"
        FCB     $80
        FCC     "FOR YOU HAVE BEEN"
        FCB     $80
        FCC     "FEELING TOO"
        FCB     $80
        FCC     "EXHAUSTED TO RESOLVE"
        FCB     $80
        FCC     "THEM ... PATIENCE"
        FCB     $80
        FCC     "AND CLEAR THINKING"
        FCB     $80
        FCC     "SOLVE MANY PROBLEMS."
        FCB     $80
        FCB     $80

D67D6   FCC     "YOU FEEL YOU ARE"
        FCB     $80
        FCC     "LOSING GRASP OF THE"
        FCB     $80
        FCC     "THINGS THAT HAVE"
        FCB     $80
        FCC     "VALUE IN YOUR LIFE"
        FCB     $80
        FCC     "... AND FEEL THE"
        FCB     $80
        FCC     "NEED OF ASSISTANCE"
        FCB     $80
        FCC     "FROM OTHERS TO"
        FCB     $80
        FCC     "PREVENT THIS FROM"
        FCB     $80
        FCC     "HAPPENING."
        FCB     $80
        FCB     $80

D6870   FCC     "YOU FEEL YOU HAVE"
        FCB     $80
        FCC     "MADE MISTAKES BY NOT"
        FCB     $80
        FCC     "ACTING QUICKLY ON"
        FCB     $80
        FCC     "OPPORTUNITIES ..."
        FCB     $80
        FCC     "AND YOU ARE"
        FCB     $80
        FCC     "DETERMINED YOU WILL"
        FCB     $80
        FCC     "NOT LET ANOTHER"
        FCB     $80
        FCC     "POTENTIAL"
        FCB     $80
        FCC     "OPPORTUNITY PASS YOU"
        FCB     $80
        FCC     "BY."
        FCB     $80
        FCB     $80

D690F   FCC     "YOU OFTEN FEEL"
        FCB     $80
        FCC     "OTHERS HAVE TAKEN"
        FCB     $80
        FCC     "ADVANTAGE OF YOU ..."
        FCB     $80
        FCC     "AND NOW YOU TAKE A"
        FCB     $80
        FCC     "POSITION OF"
        FCB     $80
        FCC     "EXAMINING THEIR"
        FCB     $80
        FCC     "MOTIVES MORE"
        FCB     $80
        FCC     "CAREFULLY BEFORE"
        FCB     $80
        FCC     "AGREEING WITH THEM."
        FCB     $80
        FCB     $80

D69A7   FCC     "YOU ARE A RARE"
        FCB     $80
        FCC     "PERSON ... YOU CAN"
        FCB     $80
        FCC     "BE LOOKED UP TO AND"
        FCB     $80
        FCC     "RECOGNIZED AS A"
        FCB     $80
        FCC     "LEADER."
        FCB     $80
        FCB     $80

D69F6   FCC     "YOU HAVE A WIDE"
        FCB     $80
        FCC     "VARIETY OF INTERESTS"
        FCB     $80
        FCC     "... AND YOU"
        FCB     $80
        FCC     "CONTINUALLY EXPAND"
        FCB     $80
        FCC     "YOUR SPECTRUM OF"
        FCB     $80
        FCC     "KNOWLEDGE TO ASSIST"
        FCB     $80
        FCC     "OTHERS."
        FCB     $80
        FCB     $80

D6A68   FCC     "AFFAIRS IN YOUR LIFE"
        FCB     $80
        FCC     "HAVE BEEN CREATING"
        FCB     $80
        FCC     "PROBLEMS WHICH HAVE"
        FCB     $80
        FCC     "BEEN FATIGUING YOU"
        FCB     $80
        FCC     "BOTH MENTALLY AND"
        FCB     $80
        FCC     "PHYSICALLY."
        FCB     $80
        FCB     $80

D6AD6   FCC     "YOU ARE SOMEWHAT"
        FCB     $80
        FCC     "TIRED OF THE DEMANDS"
        FCB     $80
        FCC     "ON YOU AT THIS TIME"
        FCB     $80
        FCC     "AND FEEL THAT A"
        FCB     $80
        FCC     "CHANGE FOR THE"
        FCB     $80
        FCC     "BETTER TO ANY DEGREE"
        FCB     $80
        FCC     "WOULD BRING PEACE."
        FCB     $80
        FCB     $80

D6B58   FCC     "RECOGNITION FROM"
        FCB     $80
        FCC     "OTHERS IS IMPORTANT"
        FCB     $80
        FCC     "TO YOU AND RECENTLY"
        FCB     $80
        FCC     "YOU HAVE A FEELING"
        FCB     $80
        FCC     "OTHERS HAVE NOT BEEN"
        FCB     $80
        FCC     "EXPRESSING THIS TO"
        FCB     $80
        FCC     "YOU."
        FCB     $80
        FCB     $80

D6BD2   FCC     "SOMETIMES YOU SEE"
        FCB     $80
        FCC     "QUALITIES IN PEOPLE"
        FCB     $80
        FCC     "WHICH ARE"
        FCB     $80
        FCC     "NONEXISTENT AND AS A"
        FCB     $80
        FCC     "RESULT OF THIS YOU"
        FCB     $80
        FCC     "ARE TAKEN ADVANTAGE"
        FCB     $80
        FCC     "OF."
        FCB     $80
        FCB     $80

D6C43   FCC     "YOU HAVE A STRONG"
        FCB     $80
        FCC     "NEED TO BE LOOKED UP"
        FCB     $80
        FCC     "TO AS AN INDIVIDUAL"
        FCB     $80
        FCC     "OF ACCOMPLISHMENTS"
        FCB     $80
        FCC     "AND TO ATTRACT THOSE"
        FCB     $80
        FCC     "WHO RECOGNIZE YOUR"
        FCB     $80
        FCC     "EFFORTS."
        FCB     $80
        FCB     $80

D6CC3   FCC     "PEACE IS YOUR MOTTO"
        FCB     $80
        FCC     "... YOU AVOID"
        FCB     $80
        FCC     "DISAGREEMENT OF ANY"
        FCB     $80
        FCC     "KIND."
        FCB     $80
        FCB     $80

D6D00   FCC     "YOU FEEL SOMETHING"
        FCB     $80
        FCC     "HAS BEEN HOLDING YOU"
        FCB     $80
        FCC     "BACK FROM ACHIEVING"
        FCB     $80
        FCC     "ALL YOU DESIRE ..."
        FCB     $80
        FCC     "AND YOU HAVE BEEN"
        FCB     $80
        FCC     "LOOKING FOR A"
        FCB     $80
        FCC     "POSSIBLE CHANGE."
        FCB     $80
        FCB     $80

D6D81   FCC     "YOU ARE A CAPABLE"
        FCB     $80
        FCC     "INDIVIDUAL WHO HAS"
        FCB     $80
        FCC     "THE ABILITY TO"
        FCB     $80
        FCC     "ACHIEVE WHAT YOU"
        FCB     $80
        FCC     "DESIRE FROM LIFE."
        FCB     $80
        FCB     $80

D6DD9   FCC     "YOU HAVE THE ABILITY"
        FCB     $80
        FCC     "TO FORM STRONG"
        FCB     $80
        FCC     "OPINIONS AND TO"
        FCB     $80
        FCC     "DEFEND THOSE"
        FCB     $80
        FCC     "OPINIONS WHENEVER"
        FCB     $80
        FCC     "THEY ARE CHALLENGED."
        FCB     $80
        FCB     $80

D6E42   FCC     "YOU ENJOY WORKING"
        FCB     $80
        FCC     "WITH ACCURATE FACTS"
        FCB     $80
        FCC     "AND FIGURES ... AND"
        FCB     $80
        FCC     "USE THEM TO ADVANCE"
        FCB     $80
        FCC     "YOUR POSITION IN"
        FCB     $80
        FCC     "LIFE."
        FCB     $80
        FCB     $80

D6EA8   FCC     "YOU HAVE THE ABILITY"
        FCB     $80
        FCC     "TO QUICKLY EVALUATE"
        FCB     $80
        FCC     "ANY SITUATION AS TO"
        FCB     $80
        FCC     "ITS BENEFITS ..."
        FCB     $80
        FCC     "YOUR DECISIONS ARE"
        FCB     $80
        FCC     "USUALLY VERY FIRM."
        FCB     $80
        FCB     $80

D6F1D   FCC     "YOU ARE A GOAL"
        FCB     $80
        FCC     "SETTER AND WORK WITH"
        FCB     $80
        FCC     "COMPLETE DEVOTION TO"
        FCB     $80
        FCC     "ACHIEVE YOUR"
        FCB     $80
        FCC     "DESIRES."
        FCB     $80
        FCB     $80

D6F6D   FCC     "YOU ARE NOT EASILY"
        FCB     $80
        FCC     "SWAYED BY OTHER"
        FCB     $80
        FCC     "VIEWS OR OPINIONS"
        FCB     $80
        FCC     "... YOU ARE A HARD"
        FCB     $80
        FCC     "WORKER WHO SETS OUT"
        FCB     $80
        FCC     "TO ACHIEVE ALL"
        FCB     $80
        FCC     "GOALS."
        FCB     $80
        FCB     $80

D6FE0   FCC     "YOU KNOW WHAT YOU"
        FCB     $80
        FCC     "WANT OUT OF LIFE AND"
        FCB     $80
        FCC     "YOU ARE DETERIMINED"
        FCB     $80
        FCC     "NOT TO LET ANYONE"
        FCB     $80
        FCC     "INTERFERE WITH YOU"
        FCB     $80
        FCC     "ACHIEVING YOUR"
        FCB     $80
        FCC     "GOALS."
        FCB     $80
        FCB     $80

D7057   FCC     "YOU ARE AN ACTIVE"
        FCB     $80
        FCC     "PERSON BY NATURE."
        FCB     $80
        FCB     $80

D707C   FCC     "YOU HAVE THE ABILITY"
        FCB     $80
        FCC     "TO FORM STRONG"
        FCB     $80
        FCC     "OPINIONS AND TO"
        FCB     $80
        FCC     "DEFEND THOSE"
        FCB     $80
        FCC     "OPINIONS WHENEVER"
        FCB     $80
        FCC     "THEY ARE CHALLENGED."
        FCB     $80
        FCB     $80

D70E5   FCC     "YOUR GOALS FOR"
        FCB     $80
        FCC     "ACCOMPLISHMENTS"
        FCB     $80
        FCC     "SHOULD BE ACHIEVED"
        FCB     $80
        FCC     "BECAUSE YOU HAVE"
        FCB     $80
        FCC     "STRONG"
        FCB     $80
        FCC     "SELF-DETERMINATION."
        FCB     $80
        FCB     $80

D7144   FCC     "THERE IS A STRUGGLE"
        FCB     $80
        FCC     "IN YOU BETWEEN RIGHT"
        FCB     $80
        FCC     "AND WRONG ... AND"
        FCB     $80
        FCC     "THIS COMES FROM A"
        FCB     $80
        FCC     "NEED FOR EVERYTHING"
        FCB     $80
        FCC     "TO BE LOGICAL."
        FCB     $80
        FCB     $80

D71B5   FCC     "SUCCESS IS YOUR GOAL"
        FCB     $80
        FCC     "AND YOU ENJOY BEING"
        FCB     $80
        FCC     "INVOLVED IN ALL THE"
        FCB     $80
        FCC     "ACTIVITIES WHICH ARE"
        FCB     $80
        FCC     "REQUIRED TO BE"
        FCB     $80
        FCC     "SUCCESSFUL."
        FCB     $80
        FCB     $80

D7223   FCC     "YOU ENJOY MAKING"
        FCB     $80
        FCC     "YOUR OWN DECISIONS"
        FCB     $80
        FCC     "... OUTSIDE"
        FCB     $80
        FCC     "INTERFERENCE IS"
        FCB     $80
        FCC     "RESENTED BY YOU."
        FCB     $80
        FCB     $80

D7275   FCC     "YOU HAVE SET A FAST"
        FCB     $80
        FCC     "PACE FOR YOURSELF."
        FCB     $80
        FCB     $80

D729D   FCC     "YOU ARE NOT"
        FCB     $80
        FCC     "SATISFIED WITH"
        FCB     $80
        FCC     "SITUATIONS IN YOUR"
        FCB     $80
        FCC     "LIFE AND YOU ARE"
        FCB     $80
        FCC     "MAKING THE DECISION"
        FCB     $80
        FCC     "TO CHANGE THEM."
        FCB     $80
        FCB     $80

D7301   FCC     "IT IS VERY DIFFICULT"
        FCB     $80
        FCC     "FOR YOU TO ADMIT YOU"
        FCB     $80
        FCC     "HAVE MADE A MISTAKE."
        FCB     $80
        FCB     $80

D7341   FCC     "SOME SITUATION IN"
        FCB     $80
        FCC     "YOUR LIFE IS VERY"
        FCB     $80
        FCC     "UNDESIRABLE AND YOU"
        FCB     $80
        FCC     "ARE LOOKING FOR"
        FCB     $80
        FCC     "SOLUTIONS TO IT."
        FCB     $80
        FCB     $80

D739B   FCC     "YOU LIKE THINGS TO"
        FCB     $80
        FCC     "BE IN THEIR PROPER"
        FCB     $80
        FCC     "PLACE ... AND BECOME"
        FCB     $80
        FCC     "UNCOMFORTABLE WHEN"
        FCB     $80
        FCC     "SOMEONE MISPLACES"
        FCB     $80
        FCC     "YOUR POSSESSIONS."
        FCB     $80
        FCB     $80

D740E   FCC     "PERHAPS YOU ARE"
        FCB     $80
        FCC     "CONSIDERING LOOKING"
        FCB     $80
        FCC     "FOR A NEW POSITION"
        FCB     $80
        FCC     "AT THIS TIME."
        FCB     $80
        FCB     $80

D7454   FCC     "YOU FEEL ANSWERS TO"
        FCB     $80
        FCC     "YOUR PROGRESS AT"
        FCB     $80
        FCC     "THIS TIME ARE NOT"
        FCB     $80
        FCC     "AVAILABLE TO YOU."
        FCB     $80
        FCB     $80

D749E   FCC     "YOU ARE INVOLVED IN"
        FCB     $80
        FCC     "MANY DIFFERENT"
        FCB     $80
        FCC     "ACTIVITIES."
        FCB     $80
        FCB     $80

D74CE   FCC     "YOU HAVE BEEN"
        FCB     $80
        FCC     "DAYDREAMING A LOT"
        FCB     $80
        FCC     "LATELY ABOUT HOW YOU"
        FCB     $80
        FCC     "WOULD LIKE THINGS TO"
        FCB     $80
        FCC     "BE."
        FCB     $80
        FCB     $80

D751D   FCC     "YOU DESIRE A SHIFT"
        FCB     $80
        FCC     "IN YOUR ACTIVITIES"
        FCB     $80
        FCC     "... FROM REALITY TO"
        FCB     $80
        FCC     "WHAT YOU FANTASIZE."
        FCB     $80
        FCB     $80

D756C   FCC     "YOU HAVE BEEN"
        FCB     $80
        FCC     "WORKING EXTREMELY"
        FCB     $80
        FCC     "HARD ... AND ENJOY"
        FCB     $80
        FCC     "DREAMING OF"
        FCB     $80
        FCC     "POSSIBILITIES FOR"
        FCB     $80
        FCC     "CHANGE."
        FCB     $80
        FCB     $80

D75C6   FCC     "RECENTLY THINGS DID"
        FCB     $80
        FCC     "NOT GO AS PLANNED"
        FCB     $80
        FCC     "AND YOU HAVE BEEN"
        FCB     $80
        FCC     "SPENDING A LOT OF"
        FCB     $80
        FCC     "TIME MENTALLY"
        FCB     $80
        FCC     "SEARCHING FOR THE"
        FCB     $80
        FCC     "REASONS."
        FCB     $80
        FCB     $80

D763A   FCC     "YOU ENJOY CREATING"
        FCB     $80
        FCC     "THINGS FOR YOUR OWN"
        FCB     $80
        FCC     "PLEASURE ... AND"
        FCB     $80
        FCC     "RARELY EVER THINK OF"
        FCB     $80
        FCC     "THEM AS MONEY"
        FCB     $80
        FCC     "MAKERS."
        FCB     $80
        FCB     $80

D769E   FCC     "YOU USE YOUR"
        FCB     $80
        FCC     "PERSONALITY TO YOUR"
        FCB     $80
        FCC     "ADVANTAGE."
        FCB     $80
        FCB     $80

D76CB   FCC     "YOU BELIEVE IF YOU"
        FCB     $80
        FCC     "EXERCISE MORE"
        FCB     $80
        FCC     "PERSONAL CHARM YOUR"
        FCB     $80
        FCC     "GOALS WILL BECOME"
        FCB     $80
        FCC     "REALITY."
        FCB     $80
        FCB     $80

D771C   FCC     "YOU WOULD LIKE TO"
        FCB     $80
        FCC     "HAVE A VACATION AT"
        FCB     $80
        FCC     "THIS TIME."
        FCB     $80
        FCB     $80

D774D   FCC     "YOU HAVE BEEN TRYING"
        FCB     $80
        FCC     "TO ADJUST TO NEW"
        FCB     $80
        FCC     "POSSIBILITIES."
        FCB     $80
        FCB     $80

D7783   FCC     "YOU HAVE REALLY BEEN"
        FCB     $80
        FCC     "FEELING TIRED"
        FCB     $80
        FCC     "LATELY."
        FCB     $80
        FCB     $80

D77AF   FCC     "EVEN THOUGH YOU FEEL"
        FCB     $80
        FCC     "THINGS HAVE NOT"
        FCB     $80
        FCC     "WORKED OUT LATELY"
        FCB     $80
        FCC     "... IT COULD BE"
        FCB     $80
        FCC     "WORTH TRYING NEW"
        FCB     $80
        FCC     "DIRECTIONS."
        FCB     $80
        FCB     $80

D7814   FCC     "YOU HAVE EXCEPTIONAL"
        FCB     $80
        FCC     "TASTE AND USE THIS"
        FCB     $80
        FCC     "ABILITY TO JUDGE AND"
        FCB     $80
        FCC     "EVALUATE."
        FCB     $80
        FCB     $80

D785C   FCC     "YOU HAVE A STRONG"
        FCB     $80
        FCC     "MENTAL PICTURE OF"
        FCB     $80
        FCC     "THE LIFE YOU DESIRE"
        FCB     $80
        FCC     "FOR THE FUTURE."
        FCB     $80
        FCB     $80

D78A5   FCC     "YOUR STRONG NEED TO"
        FCB     $80
        FCC     "ACHIEVE HAS PERHAPS"
        FCB     $80
        FCC     "LEFT YOU EXHAUSTED"
        FCB     $80
        FCC     "AT THIS TIME AND YOU"
        FCB     $80
        FCC     "HAVE BEEN DESIRING"
        FCB     $80
        FCC     "SOME REST."
        FCB     $80
        FCB     $80

D7914   FCC     "OTHERS HAVE NOT BEEN"
        FCB     $80
        FCC     "COOPERATING WITH"
        FCB     $80
        FCC     "YOUR DESIRES AND"
        FCB     $80
        FCC     "GOALS AND THIS HAS"
        FCB     $80
        FCC     "LEFT YOU WITH AN"
        FCB     $80
        FCC     "ANGRY ATTITUDE."
        FCB     $80
        FCB     $80

D7980   FCC     "REDIRECTING YOUR"
        FCB     $80
        FCC     "ENERGIES WITHIN A"
        FCB     $80
        FCC     "CALM ENVIRONMENT"
        FCB     $80
        FCC     "COULD ASSIST YOU IN"
        FCB     $80
        FCC     "OVERCOMING THE"
        FCB     $80
        FCC     "DIFFICULTIES YOU"
        FCB     $80
        FCC     "HAVE BEEN"
        FCB     $80
        FCC     "EXPERIENCING."
        FCB     $80
        FCB     $80

D7A01   FCC     "YOU FEEL THE LACK OF"
        FCB     $80
        FCC     "ENERGY TO PURSUE"
        FCB     $80
        FCC     "SITUATIONS WHICH YOU"
        FCB     $80
        FCC     "FEEL HAVE NOT BEEN"
        FCB     $80
        FCC     "FAIR TO YOU."
        FCB     $80
        FCB     $80

D7A5D   FCC     "YOU ARE DETERMINED"
        FCB     $80
        FCC     "TO SUCCEED AT ALL"
        FCB     $80
        FCC     "COSTS ... THRU"
        FCB     $80
        FCC     "SELF-BELIEF EVERYONE"
        FCB     $80
        FCC     "SUCCEEDS."
        FCB     $80
        FCB     $80

D7AB1   FCC     "PERHAPS YOU NEED TO"
        FCB     $80
        FCC     "SLOW DOWN AND LISTEN"
        FCB     $80
        FCC     "MORE CAREFULLY TO"
        FCB     $80
        FCC     "ADVICE GIVEN BY"
        FCB     $80
        FCC     "OTHERS ... THEY"
        FCB     $80
        FCC     "COULD BE RIGHT."
        FCB     $80
        FCB     $80

D7B1D   FCC     "YOU POSSESS"
        FCB     $80
        FCC     "TREMENDOUS DRIVE TO"
        FCB     $80
        FCC     "ACHIEVE YOUR GOALS"
        FCB     $80
        FCC     "AND FEEL NOTHING CAN"
        FCB     $80
        FCC     "STOP YOU."
        FCB     $80
        FCB     $80

D7B70   FCC     "YOU HAVE THE ABILITY"
        FCB     $80
        FCC     "TO SEE OPPORTUNITIES"
        FCB     $80
        FCC     "FOR SUCCESS IN THE"
        FCB     $80
        FCC     "MANY DIFFERENT"
        FCB     $80
        FCC     "FIELDS OF INTEREST"
        FCB     $80
        FCC     "YOUR ENTHUSIASM"
        FCB     $80
        FCC     "LEADS YOU."
        FCB     $80
        FCB     $80

D7BEB   FCC     "YOU HAVE A STRONG"
        FCB     $80
        FCC     "DESIRE FOR CHANGE"
        FCB     $80
        FCC     "... YET YOU HAVE"
        FCB     $80
        FCC     "BEEN CONCEALING THIS"
        FCB     $80
        FCC     "FROM OTHERS."
        FCB     $80
        FCB     $80

D7C43   FCC     "YOU FIND IT"
        FCB     $80
        FCC     "DIFFICULT TO BECOME"
        FCB     $80
        FCC     "INTERESTED IN"
        FCB     $80
        FCC     "PROJECTS CREATED BY"
        FCB     $80
        FCC     "OTHERS AND FEEL THE"
        FCB     $80
        FCC     "NEED TO SEEK YOUR"
        FCB     $80
        FCC     "OWN PATH."
        FCB     $80
        FCB     $80

D7CB6   FCC     "YOU HAVE THE ABILITY"
        FCB     $80
        FCC     "TO OUTWIT THE"
        FCB     $80
        FCC     "AVERAGE PERSON AND"
        FCB     $80
        FCC     "TO ARRANGE YOUR"
        FCB     $80
        FCC     "AFFAIRS TO ACHIEVE"
        FCB     $80
        FCC     "YOUR PERSONAL GOALS."
        FCB     $80
        FCB     $80

D7D25   FCC     "LIKE SOME OF THE"
        FCB     $80
        FCC     "GREATEST MEN OF OUR"
        FCB     $80
        FCC     "TIME ... YOU HAVE"
        FCB     $80
        FCC     "NOT BEEN"
        FCB     $80
        FCC     "EXPERIENCING"
        FCB     $80
        FCC     "COMPLETION OF"
        FCB     $80
        FCC     "PROJECTS ..."
        FCB     $80
        FCC     "DETERMINATION WILL"
        FCB     $80
        FCC     "ALWAYS PREVAIL."
        FCB     $80
        FCB     $80

D7DB1   FCC     "PERHAPS YOU ARE"
        FCB     $80
        FCC     "OFTEN MISUNDERSTOOD"
        FCB     $80
        FCC     "AS TO YOUR"
        FCB     $80
        FCC     "INTENTIONS."
        FCB     $80
        FCB     $80

D7DED   FCC     "THE STRONG NEED TO"
        FCB     $80
        FCC     "BE RECOGNIZED IS"
        FCB     $80
        FCC     "PUSHING YOU INTO NEW"
        FCB     $80
        FCC     "EXPERIENCES."
        FCB     $80
        FCB     $80

D7E34   FCC     "YOU WOULD REALLY"
        FCB     $80
        FCC     "LIKE TO TELL THE"
        FCB     $80
        FCC     "WORLD TO LEAVE YOU"
        FCB     $80
        FCC     "ALONE."
        FCB     $80
        FCB     $80

D7E71   FCB     $00
        FCB     $22
        FCB     $04
        FCB     $7F
        FCB     $00
        FCB     $DE
        FCB     $18
        FCB     $00
        FCB     $00
        FCB     $22
        FCB     $18
        FCB     $00
        FCB     $00
        FCB     $DE

D7E7F   FCB     $30
        FCB     $00
        FCB     $05
        FCB     $7F
        FCB     $00
        FCB     $22
        FCB     $E8
        FCB     $00
        FCB     $00
        FCB     $EF
        FCB     $00
        FCB     $11
        FCB     $E8
        FCB     $00
        FCB     $00
        FCB     $DE

D7E8F   FCB     $00
        FCB     $22
        FCB     $02
        FCB     $7F
        FCB     $30
        FCB     $00
        FCB     $E8
        FCB     $DE
        FCB     $00
        FCB     $22

D7E99   FCB     $30
        FCB     $00
        FCB     $03
        FCB     $7F
        FCB     $D0
        FCB     $00
        FCB     $00
        FCB     $22
        FCB     $18
        FCB     $00
        FCB     $00
        FCB     $DE

D7EA5   FCB     $00
        FCB     $22
        FCB     $01
        FCB     $7F
        FCB     $30
        FCB     $00
        FCB     $00
        FCB     $DE

D7EAD   FCB     $00
        FCB     $22
        FCB     $03
        FCB     $7F
        FCB     $30
        FCB     $00
        FCB     $00
        FCB     $DE
        FCB     $E8
        FCB     $00
        FCB     $00
        FCB     $22

D7EB9   FCB     $00
        FCB     $00
        FCB     $05
        FCB     $7F
        FCB     $30
        FCB     $00
        FCB     $00
        FCB     $22
        FCB     $E8
        FCB     $00
        FCB     $00
        FCB     $DE
        FCB     $00
        FCB     $22
        FCB     $E8
        FCB     $00

D7EC9   FCB     $18
        FCB     $22
        FCB     $05
        FCB     $7F
        FCB     $00
        FCB     $DE
        FCB     $18
        FCB     $00
        FCB     $00
        FCB     $22
        FCB     $D0
        FCB     $00
        FCB     $00
        FCB     $DE
        FCB     $18
        FCB     $00

D7ED9   FCB     $30
        FCB     $22
        FCB     $02
        FCB     $7F
        FCB     $00
        FCB     $DE
        FCB     $D0
        FCB     $00
        FCB     $00
        FCB     $22

D7EE3   FCB     $00
        FCB     $00
        FCB     $03
        FCB     $7F
        FCB     $0C
        FCB     $22
        FCB     $18
        FCB     $00
        FCB     $0C
        FCB     $DE
        FCB     $D0
        FCB     $00

D7EEF   FCB     $30
        FCB     $22
        FCB     $05
        FCB     $7F
        FCB     $00
        FCB     $DE
        FCB     $E8
        FCB     $00
        FCB     $00
        FCB     $11
        FCB     $00
        FCB     $EF
        FCB     $E8
        FCB     $00
        FCB     $00
        FCB     $22

D7EFF   FCB     $30
        FCB     $22
        FCB     $04
        FCB     $7F
        FCB     $00
        FCB     $DE
        FCB     $E8
        FCB     $00
        FCB     $00
        FCB     $11
        FCB     $00
        FCB     $EF
        FCB     $E8
        FCB     $00

D7F0D   FCB     $30
        FCB     $22
        FCB     $04
        FCB     $7F
        FCB     $00
        FCB     $DE
        FCB     $D0
        FCB     $00
        FCB     $00
        FCB     $22
        FCB     $18
        FCB     $00
        FCB     $00
        FCB     $EF

D7F1B   FCB     $00
        FCB     $22
        FCB     $04
        FCB     $7F
        FCB     $30
        FCB     $00
        FCB     $E8
        FCB     $00
        FCB     $00
        FCB     $DE
        FCB     $18
        FCB     $00
        FCB     $D0
        FCB     $00

D7F29   FCB     $30
        FCB     $11
        FCB     $00
        FCB     $7F
        FCB     $D0
        FCB     $00

D7F2F   FCB     $30
        FCB     $11
        FCB     $01
        FCB     $7F
        FCB     $D0
        FCB     $00
        FCB     $00
        FCB     $EF

D7F37   FCB     $00
        FCB     $22
        FCB     $04
        FCB     $7F
        FCB     $18
        FCB     $DE
        FCB     $18
        FCB     $22
        FCB     $E8
        FCB     $DE
        FCB     $18
        FCB     $00
        FCB     $D0
        FCB     $00

D7F45   FCB     $00
        FCB     $22
        FCB     $01
        FCB     $7F
        FCB     $00
        FCB     $DE
        FCB     $30
        FCB     $00

D7F4D   FCB     $00
        FCB     $00
        FCB     $03
        FCB     $7F
        FCB     $30
        FCB     $00
        FCB     $E8
        FCB     $11
        FCB     $18
        FCB     $11
        FCB     $D0
        FCB     $00

D7F59   FCB     $00
        FCB     $00
        FCB     $02
        FCB     $7F
        FCB     $30
        FCB     $00
        FCB     $D0
        FCB     $22
        FCB     $30
        FCB     $00

D7F63   FCB     $00
        FCB     $22
        FCB     $03
        FCB     $7F
        FCB     $00
        FCB     $DE
        FCB     $30
        FCB     $00
        FCB     $00
        FCB     $22
        FCB     $D0
        FCB     $00

D7F6F   FCB     $00
        FCB     $00
        FCB     $03
        FCB     $7F
        FCB     $30
        FCB     $00
        FCB     $00
        FCB     $22
        FCB     $E8
        FCB     $00
        FCB     $00
        FCB     $DE

D7F7B   FCB     $00
        FCB     $22
        FCB     $04
        FCB     $7F
        FCB     $00
        FCB     $DE
        FCB     $30
        FCB     $00
        FCB     $00
        FCB     $22
        FCB     $D0
        FCB     $00
        FCB     $18
        FCB     $EF

D7F89   FCB     $00
        FCB     $22
        FCB     $04
        FCB     $7F
        FCB     $18
        FCB     $DE
        FCB     $00
        FCB     $22
        FCB     $18
        FCB     $00
        FCB     $00
        FCB     $DE
        FCB     $D0
        FCB     $00

D7F97   FCB     $00
        FCB     $00
        FCB     $04
        FCB     $7F
        FCB     $00
        FCB     $22
        FCB     $18
        FCB     $00
        FCB     $00
        FCB     $DE
        FCB     $18
        FCB     $00
        FCB     $00
        FCB     $22

D7FA5   FCB     $30
        FCB     $22
        FCB     $02
        FCB     $7F
        FCB     $00
        FCB     $DE
        FCB     $00
        FCB     $11
        FCB     $D0
        FCB     $00

D7FAF   FCB     $30
        FCB     $22
        FCB     $02
        FCB     $7F
        FCB     $D0
        FCB     $00
        FCB     $00
        FCB     $DE
        FCB     $30
        FCB     $00

D7FB9   FCB     $30
        FCB     $22
        FCB     $01
        FCB     $7F
        FCB     $D0
        FCB     $EF
        FCB     $30
        FCB     $EF

D7FC1   FCB     $30
        FCB     $22
        FCB     $03
        FCB     $7F
        FCB     $D0
        FCB     $00
        FCB     $18
        FCB     $EF
        FCB     $E8
        FCB     $EF
        FCB     $30
        FCB     $00

D7FCD   FCB     $30
        FCB     $22
        FCB     $03
        FCB     $7F
        FCB     $D0
        FCB     $DE
        FCB     $18
        FCB     $11
        FCB     $18
        FCB     $EF
        FCB     $D0
        FCB     $22

D7FD9   FCB     $30
        FCB     $22
        FCB     $03
        FCB     $7F
        FCB     $E8
        FCB     $EF
        FCB     $18
        FCB     $EF
        FCB     $E8
        FCB     $11
        FCB     $E8
        FCB     $00

D7FE5   FCB     $00
        FCB     $22
        FCB     $02
        FCB     $7F
        FCB     $00
        FCB     $DE
        FCB     $30
        FCB     $22
        FCB     $00
        FCB     $DE

        FCB     $FF
        FDB     $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF

;D8000   END
        END
